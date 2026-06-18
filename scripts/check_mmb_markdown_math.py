#!/usr/bin/env python3
"""Check MMB derivation Markdown for GitHub-compatible math delimiters."""

from __future__ import annotations

import argparse
import re
from pathlib import Path


DEFAULT_GLOB = "mmb-paper-derivations/**/*.md"
FENCE_RE = re.compile(r"^\s*(```|~~~)")


def strip_inline_code(line: str) -> str:
    pieces: list[str] = []
    idx = 0
    while idx < len(line):
        if line[idx] == "`":
            tick_end = idx + 1
            while tick_end < len(line) and line[tick_end] == "`":
                tick_end += 1
            ticks = line[idx:tick_end]
            close = line.find(ticks, tick_end)
            if close == -1:
                pieces.append(" " * (len(line) - idx))
                break
            pieces.append(" " * (close + len(ticks) - idx))
            idx = close + len(ticks)
            continue
        pieces.append(line[idx])
        idx += 1
    return "".join(pieces)


def check_file(path: Path) -> list[str]:
    errors: list[str] = []
    in_fence = False
    fence_delimiter = ""

    for line_no, line in enumerate(path.read_text(encoding="utf-8").splitlines(), start=1):
        fence_match = FENCE_RE.match(line)
        if fence_match:
            delimiter = fence_match.group(1)
            if in_fence and delimiter == fence_delimiter:
                in_fence = False
                fence_delimiter = ""
            elif not in_fence:
                in_fence = True
                fence_delimiter = delimiter
            continue
        if in_fence:
            continue

        stripped = strip_inline_code(line)
        if "$$" in stripped:
            errors.append(f"{path}:{line_no}: use fenced math blocks, not $$ display delimiters")
        if r"\[" in stripped or r"\]" in stripped:
            errors.append(f"{path}:{line_no}: GitHub Markdown does not support \\[...\\] math delimiters")
        if r"\(" in stripped or r"\)" in stripped:
            errors.append(f"{path}:{line_no}: GitHub Markdown does not support \\(...\\) math delimiters")
        if r"\left{" in stripped:
            errors.append(f"{path}:{line_no}: use \\left\\{{ or fixed-size braces, not \\left{{")
        if r"\right}" in stripped:
            errors.append(f"{path}:{line_no}: use \\right\\}} or fixed-size braces, not \\right}}")

    if in_fence:
        errors.append(f"{path}: unclosed fenced code block")
    return errors


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--glob", default=DEFAULT_GLOB)
    args = parser.parse_args()

    errors: list[str] = []
    for path in sorted(Path().glob(args.glob)):
        errors.extend(check_file(path))

    if errors:
        print("\n".join(errors))
        print(f"markdown_math_check=failed errors={len(errors)}")
        return 1

    print("markdown_math_check=ok")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
