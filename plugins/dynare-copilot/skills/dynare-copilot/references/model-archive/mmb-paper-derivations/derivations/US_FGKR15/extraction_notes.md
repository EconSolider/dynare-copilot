# US_FGKR15 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row 124 maps `US_FGKR15` to "Fiscal volatility shocks and economic activity" with exact source/title scores.
- The first Markdown page matches the expected title, authors, and DOI.
- Raw PDF exists at `raw/mmb_papers/Fiscal volatility shocks and economic activity.pdf`.
- No normalized appendix file exists at `docs/mmb_appendix_full_normalizations/US_FGKR15.md`.
- A relevant online appendix packet exists at `raw/theory_sources/mmb_appendix_us_fgkr15/`; its PDF was used for the household FOCs and aggregation conditions.

## Formula Quality

- The main paper's Section III supplies preferences, budget constraints, production, marginal cost, Rotemberg Phillips curve, Taylor rules, fiscal budget, and fiscal rules.
- The online appendix Section E supplies the household FOCs and aggregation identities. PDF text extraction is readable but not fully LaTeX-clean.
- `needs_review`: wage-setting FOC and investment FOC were normalized from OCR plus the implementation cross-check.
- `needs_review`: steady-state section records source logic but does not certify all growth-normalized formulas needed for a runnable `steady_state_model`.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/US_FGKR15_rep.mod` was read only as `implementation_cross_check`.
- Cross-check confirmed variable groups: `ct`, `yt`, `invt`, `kt`, `kbt`, `ht`, `mct`, `wt`, `inflt`, `Rt`, tax rates, fiscal volatility states, preference and technology states.
- Cross-check confirmed the model uses production capital dated `kt(-1)`, book capital dated `kbt(-1)`, end-of-period government debt, and fiscal volatility shocks `ukt`, `uct`, `ugt`, `uwt`.
- Dynare was not run.

## Deferred Issues

- Source-level review should compare (F2) and (F7) against the PDF display equations and the authors' code before promoting the entry beyond `needs_review`.
- The exact stationary transformation under trend growth should be checked before constructing a runnable `.mod`.
- The distinction between baseline and extended Taylor rules should be preserved in any later implementation variant.
- The published nonlinear IRFs use third-order perturbation; a first-order Rep-MMB run is not equivalent for volatility-shock experiments.

## Translation Status

- English derivation was drafted first.
- Chinese derivation was translated from the English file and preserves section order and equation numbers `(F1)` through `(F26)`.
