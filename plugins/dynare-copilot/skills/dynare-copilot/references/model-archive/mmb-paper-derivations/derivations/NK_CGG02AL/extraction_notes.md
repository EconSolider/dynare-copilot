# NK_CGG02AL Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row for `NK_CGG02AL` is matched with score `1.0000`.
- Primary source title: "A simple framework for international monetary policy analysis".
- Primary source Markdown: `raw/mmb_mineru/runs/nk_cgg02_nk_cgg02al__a_simple_framework_for_international_monetary_policy_analysis__8ffaf5fd/full.md`.
- Raw PDF path exists: `raw/mmb_papers/A simple framework for international monetary policy analysis.pdf`.
- No model-specific appendix normalization was present at `docs/mmb_appendix_full_normalizations/NK_CGG02AL.md`.
- No optional implementation cross-check file was present at `.agents/skills/dynare-copilot/references/examples/NK_CGG02AL_rep.mod`.

## Formula Quality

- The household, firm, equilibrium, and log-linear sticky-price blocks are mostly readable from MinerU Markdown.
- The paper's equation numbering was not preserved in the archive derivation. Equations were renumbered continuously as `(F1)` through `(F48)` to match archive style.
- `needs_review`: the policy-rule coefficient in the source around paper Eqs. (61) and (77) is rendered by OCR as `9`; the derivation uses $\vartheta$ by inference from the surrounding definition.
- `needs_review`: the cooperative reduced-form inflation expression near paper Eq. (76) has unreadable/duplicated $\psi$ symbols in the Markdown. I did not include that expression as a core archive equation.
- `needs_review`: technology shocks $a_t,a_t^*$ enter natural output and exchange-rate formulas, but the Markdown source does not specify an independent stochastic law for technology.

## Implementation Cross-Check

- No local `.mod` example was available for `NK_CGG02AL`.
- The derivation therefore uses only paper-side source equations and does not import variable names or timing conventions from implementation code.
- The entry is classified as a log-linear analytical model. A future implementation pass should determine whether the MMB implementation uses a compact `model(linear)` system based on the IS/Phillips/policy block or a larger structural block.

## Deferred Issues

- PDF formula check is needed for the OCR-sensitive policy coefficients and cooperative reduced-form inflation equations.
- A calibration and shock-process source is needed before a runnable Dynare model can be considered complete.
- Runtime validation, Blanchard-Kahn checks, steady-state checks, and IRF comparison were not performed.
- The first-pass archive status should remain `needs_review`.

## Translation Status

- English derivation was drafted first.
- Chinese derivation is a translation of the English derivation and preserves the same eight section headings and `(F#)` numbering.
