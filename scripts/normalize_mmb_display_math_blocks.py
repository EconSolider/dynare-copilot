#!/usr/bin/env python3
"""Normalize MMB derivation display-math block spacing for GitHub Markdown."""

from __future__ import annotations

import argparse
import re
from pathlib import Path


DEFAULT_GLOB = "mmb-paper-derivations/derivations/*/*_derivation.*.md"
SINGLE_LINE_DISPLAY = re.compile(r"^(\s*)\$\$(.*?)\$\$([.,;:]?)\s*$")


def expand_single_line_blocks(lines: list[str]) -> tuple[list[str], int]:
    expanded: list[str] = []
    changed = 0
    for line in lines:
        stripped = line.strip()
        match = SINGLE_LINE_DISPLAY.match(line)
        if match and stripped != "$$":
            indent, body, trailing = match.groups()
            body = body.strip()
            if trailing:
                body = f"{body}{trailing}"
            expanded.extend([f"{indent}$$", f"{indent}{body}", f"{indent}$$"])
            changed += 1
        elif stripped.startswith("$$") and stripped != "$$":
            indent = line[: len(line) - len(line.lstrip())]
            body = line.lstrip()[2:].strip()
            expanded.extend([f"{indent}$$", f"{indent}{body}"])
            changed += 1
        elif stripped.endswith("$$") and stripped != "$$":
            indent = line[: len(line) - len(line.lstrip())]
            body = line.rstrip()[:-2].strip()
            expanded.extend([f"{indent}{body}", f"{indent}$$"])
            changed += 1
        else:
            expanded.append(line)
    return expanded, changed


def pad_display_blocks(lines: list[str]) -> tuple[list[str], int]:
    padded: list[str] = []
    changed = 0
    in_block = False

    for idx, line in enumerate(lines):
        is_delimiter = line.strip() == "$$"

        if is_delimiter and not in_block:
            if padded and padded[-1].strip():
                padded.append("")
                changed += 1
            padded.append(line)
            in_block = True
            continue

        if is_delimiter and in_block:
            padded.append(line)
            in_block = False
            if idx + 1 < len(lines) and lines[idx + 1].strip():
                padded.append("")
                changed += 1
            continue

        padded.append(line)

    return padded, changed


def normalize_file(path: Path) -> int:
    text = path.read_text(encoding="utf-8")
    has_final_newline = text.endswith("\n")
    lines = text.splitlines()

    lines, expanded_count = expand_single_line_blocks(lines)
    lines, padded_count = pad_display_blocks(lines)

    changes = expanded_count + padded_count
    if changes:
        output = "\n".join(lines)
        if has_final_newline:
            output += "\n"
        path.write_text(output, encoding="utf-8")
    return changes


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--glob", default=DEFAULT_GLOB)
    parser.add_argument("--check", action="store_true", help="Report files that would change without writing.")
    args = parser.parse_args()

    changed: list[tuple[Path, int]] = []
    for path in sorted(Path().glob(args.glob)):
        original = path.read_text(encoding="utf-8")
        changes = normalize_file(path)
        if changes:
            changed.append((path, changes))
            if args.check:
                path.write_text(original, encoding="utf-8")

    for path, changes in changed:
        print(f"{path}: {changes}")
    print(f"files_with_display_math_spacing_changes={len(changed)} changes={sum(count for _, count in changed)}")
    return 1 if args.check and changed else 0


if __name__ == "__main__":
    raise SystemExit(main())
