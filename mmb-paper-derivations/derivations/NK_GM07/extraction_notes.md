# NK_GM07 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row: `NK_GM07`.
- Match status: `matched`.
- MinerU match score: `1.0000`.
- Model title match score: `1.0000`.
- Primary source title: `Banking and interest rates in monetary policy analysis- A quantitative exploration`.
- Primary full Markdown: `raw/mmb_mineru/runs/nk_gm07__banking_and_interest_rates_in_monetary_policy_analysis_a_quantitative_ex__cb4ea347/full.md`.
- Raw PDF path exists: `raw/mmb_papers/Banking and interest rates in monetary policy analysis- A quantitative exploration.pdf`.
- Raw PDF body was not read. It was checked for existence only.
- Appendix normalization: none found at `docs/mmb_appendix_full_normalizations/NK_GM07.md`.

## Formula Quality

- The source Markdown contains the main nonlinear core equations, interest-rate definitions, steady-state equations, and linearized dynamic system.
- OCR quality is adequate for a first-pass derivation, but not review-grade.
- `needs_review`: the capital Euler condition corresponding to source equation (11) has OCR noise around the expectation term. The English and Chinese derivations preserve the intended capital-price structure and mark it as uncertain.
- `needs_review`: the government budget constraint corresponding to source equation (15) has OCR ambiguity around the placement of the bond denominator.
- `needs_review`: the steady-state equations (36), (40), (41), and (42) were transcribed from OCR text that appears algebraically suspicious in places. They match the available OCR, but should be checked against the PDF or a clean typeset source before promotion to reviewed status.

## Implementation Cross-Check

- Cross-check file: `.agents/skills/dynare-copilot/references/examples/NK_GM07_rep.mod`.
- Used only as `implementation_cross_check`, not as a paper-side mathematical source.
- Cross-check confirmed the MMB variable set: `dp, mc, omega, lambda, xi, w, n, m, c, q, p, h, b, a1, a2, a3, EFP, rT, rIB, rL, rB`.
- Cross-check confirmed exogenous innovations: `eps_h, eps_a1, eps_a2, eps_a3, eps_i`.
- Cross-check confirmed the dynamic implementation is a linear model in deviations around calibrated steady-state values.
- Cross-check confirmed policy variants for figures 3-7 use different values of `mu_1`, `mu_2`, and `mu_3`.

## Deferred Issues

- No Dynare runtime validation was performed.
- No residual, steady-state, `check`, or Blanchard-Kahn diagnostics were run.
- The derivation should remain `needs_review` until the marked OCR equations are checked against the raw PDF or a clean publisher version.
- The broad-liquidity and steady-state formulas need a human formula pass before any runnable `.mod` promotion.
- Shared `catalog.csv` and `status.csv` were intentionally not updated because the user assigned ownership only to `mmb-paper-derivations/derivations/NK_GM07/`.

## Translation Status

- English derivation was drafted first.
- Chinese derivation was translated from the English derivation.
- Equation numbers `(F1)` through `(F44)` are intended to match exactly between English and Chinese.
- File paths, DOI, model ID, and `needs_review` markers were preserved.
