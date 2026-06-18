#!/usr/bin/env python3
"""Convert MMB derivation math delimiters away from dollar syntax.

GitHub Markdown math rendering is less fragile when display math uses
``\[...\]`` and inline math uses ``\(...\)``.  This script rewrites only MMB
derivation Markdown and skips fenced code blocks plus inline code spans.
"""

from __future__ import annotations

import argparse
import re
from pathlib import Path


DEFAULT_GLOB = "mmb-paper-derivations/**/*.md"
SINGLE_LINE_DISPLAY = re.compile(r"^(\s*)\$\$(.*?)\$\$([.,;:]?)\s*$")
FENCE_RE = re.compile(r"^\s*(```|~~~)")


def expand_display_dollars(lines: list[str]) -> tuple[list[str], int]:
    expanded: list[str] = []
    changed = 0
    in_fence = False

    for line in lines:
        if FENCE_RE.match(line):
            in_fence = not in_fence
            expanded.append(line)
            continue
        if in_fence:
            expanded.append(line)
            continue

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


def convert_display_delimiters(lines: list[str]) -> tuple[list[str], int]:
    converted: list[str] = []
    changed = 0
    in_fence = False
    in_math = False

    for line in lines:
        if FENCE_RE.match(line):
            in_fence = not in_fence
            converted.append(line)
            continue
        if in_fence:
            converted.append(line)
            continue

        if line.strip() == "$$":
            indent = line[: len(line) - len(line.lstrip())]
            converted.append(f"{indent}\\]" if in_math else f"{indent}\\[")
            in_math = not in_math
            changed += 1
        else:
            converted.append(line)

    return converted, changed


def find_closing_inline_dollar(line: str, start: int) -> int | None:
    idx = start + 1
    while idx < len(line):
        if line[idx] == "$" and line[idx - 1] != "\\":
            if idx + 1 < len(line) and line[idx + 1] == "$":
                idx += 2
                continue
            return idx
        idx += 1
    return None


def convert_inline_dollars(line: str) -> tuple[str, int]:
    pieces: list[str] = []
    changed = 0
    idx = 0

    while idx < len(line):
        if line[idx] == "`":
            tick_end = idx + 1
            while tick_end < len(line) and line[tick_end] == "`":
                tick_end += 1
            ticks = line[idx:tick_end]
            close = line.find(ticks, tick_end)
            if close == -1:
                pieces.append(line[idx:])
                break
            pieces.append(line[idx : close + len(ticks)])
            idx = close + len(ticks)
            continue

        if line[idx] == "$" and (idx == 0 or line[idx - 1] != "\\"):
            if idx + 1 < len(line) and line[idx + 1] == "$":
                pieces.append(line[idx])
                idx += 1
                continue
            close = find_closing_inline_dollar(line, idx)
            if close is not None:
                inner = line[idx + 1 : close]
                pieces.append(r"\(" + inner + r"\)")
                changed += 1
                idx = close + 1
                continue

        pieces.append(line[idx])
        idx += 1

    return "".join(pieces), changed


def convert_inline_outside_display(lines: list[str]) -> tuple[list[str], int]:
    converted: list[str] = []
    changed = 0
    in_fence = False
    in_display = False

    for line in lines:
        if FENCE_RE.match(line):
            in_fence = not in_fence
            converted.append(line)
            continue
        if in_fence:
            converted.append(line)
            continue

        stripped = line.strip()
        if stripped == r"\[":
            in_display = True
            converted.append(line)
            continue
        if stripped == r"\]":
            in_display = False
            converted.append(line)
            continue
        if in_display:
            converted.append(line)
            continue

        new_line, line_changes = convert_inline_dollars(line)
        converted.append(new_line)
        changed += line_changes

    return converted, changed


def convert_text(text: str) -> tuple[str, int]:
    has_final_newline = text.endswith("\n")
    lines = text.splitlines()

    lines, display_expansions = expand_display_dollars(lines)
    lines, display_delimiters = convert_display_delimiters(lines)
    lines, inline_delimiters = convert_inline_outside_display(lines)

    output = "\n".join(lines)
    if has_final_newline:
        output += "\n"
    return output, display_expansions + display_delimiters + inline_delimiters


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--glob", default=DEFAULT_GLOB)
    parser.add_argument("--check", action="store_true", help="Report files that would change without writing.")
    args = parser.parse_args()

    changed: list[tuple[Path, int]] = []
    for path in sorted(Path().glob(args.glob)):
        original = path.read_text(encoding="utf-8")
        converted, count = convert_text(original)
        if converted != original:
            changed.append((path, count))
            if not args.check:
                path.write_text(converted, encoding="utf-8")

    for path, count in changed:
        print(f"{path}: {count}")
    print(f"files_with_math_delimiter_changes={len(changed)} changes={sum(count for _, count in changed)}")
    return 1 if args.check and changed else 0


if __name__ == "__main__":
    raise SystemExit(main())
