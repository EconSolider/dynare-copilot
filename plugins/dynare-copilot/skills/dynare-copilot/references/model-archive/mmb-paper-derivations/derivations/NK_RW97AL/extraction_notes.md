# NK_RW97AL extraction notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row for `NK_RW97AL` has `mineru_match_status=matched`, `mineru_match_score=1.0000`, `model_title_match_score=1.0000`, and no match notes.
- Primary source: `raw/mmb_mineru/runs/nk_rw97_nk_rw97al__an_optimization_based_econometric_framework_for_the_evaluation_of_moneta__af3fb04e/full.md`.
- Raw PDF path exists: `raw/mmb_papers/An Optimization-Based Econometric Framework for the Evaluation of Monetary Policy.pdf`.
- No model-specific appendix normalization file exists at `docs/mmb_appendix_full_normalizations/NK_RW97AL.md`.
- The primary source is shared with `NK_RW97`; this entry is kept as a separate `NK_RW97AL` archive folder as assigned.

## Formula Quality

- First-pass status is `needs_review`.
- The core model equations in sections 2-5 are readable enough for a structured draft: policy rule, consumption/purchase timing, long real rate, IS equation, price index, Calvo pricing relations, aggregate supply relation, and shock reconstruction equations.
- OCR noise remains in matrix and tag-heavy formulas:
  - The VAR notation around equations (2.2)-(2.3) includes OCR artifacts in barred-vector notation.
  - The real-shock reconstruction equations (5.3)-(5.5) use matrix symbols that should be checked against the PDF before being treated as source-level exact.
  - Some table values are merged by OCR and were not used as derivation equations.
- The derivation separates paper-side shock reconstruction from the compact MMB implementation's two AR(1) processes.

## Implementation Cross-Check

- Read `.agents/skills/dynare-copilot/references/examples/NK_RW97_rep.mod` only as implementation cross-check.
- Cross-check confirms a compact `model(linear)` representation with endogenous variables `pi`, `y`, `ynat`, `rnat`, `i`, `x`, `u`, and `g`.
- Cross-check confirms exogenous innovations `u_` and `g_`, and parameters `beta`, `sigma`, `alpha`, `theta`, `omega`, `kappa`, `rhou`, `rhog`, `phipi`, and `phix`.
- Cross-check equations include the standard compact NK Phillips curve, output-gap IS equation, natural-rate equation, natural-output equation, output-gap identity, AR(1) shocks, and a simple contemporaneous policy rule.
- Implementation-only AR(1) equations and the output-gap identity are recorded as `implementation_cross_check`; they are not treated as direct paper-side source equations.
- Dynare was not run.

## Deferred Issues

- Source-level audit of equations (F32)-(F34) against the PDF or a higher-quality source is needed before marking formula quality as reviewed.
- The mapping from the paper's VAR-based real-shock reconstruction to the MMB implementation's `u` and `g` shocks should be reviewed if this entry is later promoted to a runnable model archive.
- The `NK_RW97AL` versus `NK_RW97` variant distinction is not visible in the shared paper-side source; this entry records the assigned `AL` model ID but uses the same matched paper.
- Runtime validation, Dynare residual checks, BK checks, and IRF checks were not performed.

## Translation Status

- English derivation drafted first.
- Chinese derivation translated from the English version with the same eight sections and the same `(F1)` through `(F41)` equation numbers.
