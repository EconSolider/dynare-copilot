#!/usr/bin/env python3
"""Check MMB derivation Markdown for GitHub-hostile math delimiters."""

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


def has_unescaped_dollar(line: str) -> bool:
    line = strip_inline_code(line)
    for idx, ch in enumerate(line):
        if ch == "$" and (idx == 0 or line[idx - 1] != "\\"):
            return True
    return False


def check_file(path: Path) -> list[str]:
    errors: list[str] = []
    in_fence = False
    display_balance = 0

    for line_no, line in enumerate(path.read_text(encoding="utf-8").splitlines(), start=1):
        if FENCE_RE.match(line):
            in_fence = not in_fence
            continue
        if in_fence:
            continue

        stripped = strip_inline_code(line)
        if has_unescaped_dollar(line):
            errors.append(f"{path}:{line_no}: dollar math delimiter is not allowed")
        if r"\left{" in stripped:
            errors.append(f"{path}:{line_no}: use \\left\\{{ or fixed-size braces, not \\left{{")
        if r"\right}" in stripped:
            errors.append(f"{path}:{line_no}: use \\right\\}} or fixed-size braces, not \\right}}")

        display_balance += stripped.count(r"\[")
        display_balance -= stripped.count(r"\]")
        if display_balance < 0:
            errors.append(f"{path}:{line_no}: display math closes before it opens")
            display_balance = 0

    if in_fence:
        errors.append(f"{path}: unclosed fenced code block")
    if display_balance:
        errors.append(f"{path}: unbalanced \\[ / \\] display math delimiters")
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
