# NK_NS14 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row: `NK_NS14`.
- Primary title match is exact (`model_title_match_score = 1.0000`).
- Primary Markdown: `raw/mmb_mineru/runs/nk_ns14__fiscal_stimulus_in_a_monetary_union_evidence_from_us_regions__de79b39b/full.md`.
- Raw PDF exists at `raw/mmb_papers/Fiscal stimulus in a monetary union- Evidence from US regions.pdf`; PDF body was not read because the Markdown was sufficient for identifying the main-text model block.
- No optional normalization file was present at `docs/mmb_appendix_full_normalizations/NK_NS14.md`.

## Formula Quality

- Overall status: `needs_review`.
- The main-text equations for household preferences, CES aggregators, household budget constraint, Euler equation, labor supply, goods demand, price indices, Backus-Smith risk sharing, government demand, Taylor rule, firm production, labor demand, and Calvo price setting are present in MinerU Markdown.
- The MMB implementation corresponds to a `model(linear)` variable-capital version. The paper states that variable capital is incorporated in online appendices F/G, but those appendix equations are not present in the MinerU main-text Markdown.
- Equations (F15) and (F16), the optimal investment equations, are therefore marked `needs_review` and sourced from implementation cross-check coverage rather than paper-side formula extraction.
- The paper has several theoretical variants: separable preferences, GHH preferences, incomplete markets, and variable-capital alternatives. This archive entry focuses on the MMB `NK_NS14` linear implementation with variable capital and the GHH-compatible calibration.

## Implementation Cross-Check

- Cross-check file: `.agents/skills/dynare-copilot/references/examples/NK_NS14_rep.mod`.
- Used only for variable names, shock names, timing, and equation coverage.
- The `.mod` confirms `model(linear)`.
- The `.mod` confirms endogenous variables `c, cf, r, pi, pif, piH, piF, l, lf, pH, p, pf, sH, sF, y, yf, g, gf, w, wf, i, if, k, kf, ny, nyf, q`.
- The `.mod` confirms shocks `eg`, `egf`, and `er`.
- The `.mod` confirms capital is predetermined in production and marginal-cost equations via `k(-1)` and `kf(-1)`.

## Deferred Issues

- Runtime validation was not performed and Dynare was not run.
- Targeted PDF or source-appendix review is needed for the investment FOCs and reduced-form coefficient formulas.
- The derivation does not reproduce the incomplete-markets extension because the MMB implementation uses complete-markets Backus-Smith risk sharing.
- The derivation does not reproduce every policy experiment in Tables 6-9; it extracts the model equations needed for the MMB linear implementation.

## Translation Status

- English derivation drafted first.
- Chinese derivation translated from the English artifact.
- F-number counts match: 26 in English and 26 in Chinese.
