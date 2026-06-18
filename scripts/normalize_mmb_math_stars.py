#!/usr/bin/env python3
"""Normalize raw star notation inside MMB derivation math spans.

GitHub's Markdown pipeline can treat bare `*` inside math as emphasis before the
math renderer sees it.  That corrupts formulas such as `B_t^*` into invalid TeX.
This script rewrites only math spans (`$...$`, `$$...$$`, `\(...\)`, `\[...\]`),
leaving prose Markdown and code ticks unchanged.
"""

from __future__ import annotations

import argparse
import re
from pathlib import Path


DEFAULT_GLOB = "mmb-paper-derivations/derivations/*/*_derivation.*.md"


def normalize_math(math: str) -> str:
    """Replace raw TeX star notation with an explicit LaTeX command."""

    out: list[str] = []
    i = 0
    while i < len(math):
        ch = math[i]
        if ch == "^" and math.startswith(r"\*", i + 1):
            out.append(r"^{\ast}")
            i += 3
            continue
        if math.startswith(r"\*", i):
            out.append(r"\ast")
            i += 2
            continue
        if ch == "\\":
            out.append(ch)
            if i + 1 < len(math):
                out.append(math[i + 1])
                i += 2
            else:
                i += 1
            continue
        if ch == "^" and i + 1 < len(math) and math[i + 1] == "*":
            out.append(r"^{\ast}")
            i += 2
            continue
        if ch == "*":
            out.append(r"\ast")
            i += 1
            continue
        out.append(ch)
        i += 1
    return "".join(out)


def iter_math_spans(text: str) -> list[tuple[int, int]]:
    """Return non-overlapping math spans including their dollar delimiters."""

    spans: list[tuple[int, int]] = []
    for match in re.finditer(r"(?<!\$)\$\$(?!\$).*?(?<!\$)\$\$(?!\$)", text, flags=re.S):
        spans.append(match.span())
    for match in re.finditer(r"\\\[.*?\\\]", text, flags=re.S):
        spans.append(match.span())

    masked = list(text)
    for start, end in spans:
        for idx in range(start, end):
            masked[idx] = " "
    masked_text = "".join(masked)

    for match in re.finditer(r"(?<!\$)\$(?!\$)[^\n$]*(?<!\$)\$(?!\$)", masked_text):
        spans.append(match.span())
    for match in re.finditer(r"\\\([^\n]*?\\\)", masked_text):
        spans.append(match.span())

    return sorted(spans)


def normalize_file(path: Path) -> int:
    text = path.read_text(encoding="utf-8")
    spans = iter_math_spans(text)
    if not spans:
        return 0

    pieces: list[str] = []
    last = 0
    replacements = 0
    for start, end in spans:
        pieces.append(text[last:start])
        span = text[start:end]
        if span.startswith("$$"):
            open_delimiter, close_delimiter = "$$", "$$"
        elif span.startswith(r"\["):
            open_delimiter, close_delimiter = r"\[", r"\]"
        elif span.startswith(r"\("):
            open_delimiter, close_delimiter = r"\(", r"\)"
        else:
            open_delimiter, close_delimiter = "$", "$"
        inner_start = len(open_delimiter)
        inner_end = len(span) - len(close_delimiter)
        inner = span[inner_start:inner_end]
        normalized = normalize_math(inner)
        replacements += inner.count("*")
        pieces.append(open_delimiter + normalized + close_delimiter)
        last = end
    pieces.append(text[last:])

    if replacements:
        with path.open("w", encoding="utf-8", newline="\n") as handle:
            handle.write("".join(pieces))
    return replacements


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--glob", default=DEFAULT_GLOB)
    parser.add_argument("--check", action="store_true", help="Report files that would change without writing.")
    args = parser.parse_args()

    paths = sorted(Path().glob(args.glob))
    changed: list[tuple[Path, int]] = []
    for path in paths:
        text = path.read_text(encoding="utf-8")
        count = sum(text[start:end].count("*") for start, end in iter_math_spans(text))
        if count:
            changed.append((path, count))
            if not args.check:
                normalize_file(path)

    for path, count in changed:
        print(f"{path}: {count}")
    print(f"files_with_math_stars={len(changed)} raw_math_stars={sum(count for _, count in changed)}")
    return 1 if args.check and changed else 0


if __name__ == "__main__":
    raise SystemExit(main())
