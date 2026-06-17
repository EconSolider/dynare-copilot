# NK_BGG99AL Extraction Notes

## Source Match

- Model row read from `raw/mmb_mineru/model_index.csv`.
- Primary Markdown: `raw/mmb_mineru/runs/nk_bgg99_nk_bgg99al__the_financial_accelerator_in_a_quantitative_business__e6291ccb/full.md`.
- Raw PDF path exists: `raw/mmb_papers/The financial accelerator in a quantitative business.pdf`.
- PDF body was not read because the MinerU Markdown contained the required model and appendix equations for this first-pass extraction.
- No model-specific appendix normalization was found at `docs/mmb_appendix_full_normalizations/NK_BGG99AL.md`.
- No model-specific implementation example was found at `.agents/skills/dynare-copilot/references/examples/NK_BGG99AL_rep.mod`.

## Formula Quality

- The Markdown includes the paper's Section 3 financial-contract equations, Section 4 general-equilibrium and log-linear model equations, and Appendix B household/retail/government details.
- The derivation keeps the paper-side distinction between nonlinear primitives and the log-linearized computational system.
- The entry is marked `needs_review` because the model-index row itself flags variant mapping: `primary source title differs from model title; review variant mapping`.
- Equation (F16) has a timing issue to source-check before implementation. The nearby source text displays entrepreneurial equity with one denominator timing, then gives the aggregate net-worth difference equation with a different timing convention. The derivation follows the aggregate equation and flags this explicitly.
- Equation (F44) records the paper's investment-delay extension as a possible interpretation of the `AL` suffix. The source row alone does not prove that `NK_BGG99AL` is this extension, so it is not treated as a confirmed baseline replacement for (F29).

## Implementation Cross-Check

- No `.agents/skills/dynare-copilot/references/examples/NK_BGG99AL_rep.mod` file exists.
- No MMB `.mod` implementation was used as a mathematical source.
- Deferred implementation questions include exact Dynare variable naming, whether `AL` means accelerator with investment lag in the MMB implementation, and how the published log-linear equations map to the actual MMB equation count.

## Deferred Issues

- Confirm the `NK_BGG99AL` variant label against the MMB implementation or a source-side normalization document.
- Source-check the net-worth timing in (F16)/(F20) against the raw PDF or a trusted typeset source before coding.
- Reconstruct the full nonlinear steady-state ordering if this entry is later promoted to a runnable Dynare archive item.
- Run Dynare only in a later runtime-validation phase; no runtime validation was performed here.

## Translation Status

- English derivation was drafted first.
- Chinese derivation was translated from the English core after drafting.
- Section order, paths, DOI, status markers, and formulas were preserved.
- English and Chinese derivations both contain F-numbers `(F1)` through `(F44)`.
