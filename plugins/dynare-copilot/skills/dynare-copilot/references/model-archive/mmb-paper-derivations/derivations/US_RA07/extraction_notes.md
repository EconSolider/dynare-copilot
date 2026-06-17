# US_RA07 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row for `US_RA07` has `mineru_match_status=matched`, `mineru_match_score=1.0000`, `model_title_match_score=1.0000`, and no `model_match_notes`.
- Primary Markdown: `raw/mmb_mineru/runs/us_ra07__does_inflation_increase_after_a_monetary_policy_tightening_answers_based__122db070/full.md`.
- The first 80 Markdown lines show the expected author, Pau Rabanal, and the expected title. The model index has "a estimated" while the first page has "an estimated"; this is a minor article typo, not a source mismatch.
- Raw PDF path exists: `raw/mmb_papers/Does inflation increase after a monetary policy tightening? Answers based on a estimated DSGE model.pdf`.
- No appendix normalization file exists at `docs/mmb_appendix_full_normalizations/US_RA07.md`.

## Formula Quality

- Status: `needs_review`.
- The primary Markdown contains the paper's main structural setup and the linearized model equations (10)-(21). These were sufficient for a first-pass derivation.
- OCR artifacts are visible in several nonlinear primitives, especially the wage-bill/cost-channel expression, household labor notation, and utilization-cost notation.
- The derivation therefore treats the linearized equations as the core extraction and marks notation-sensitive items as `needs_review`.
- The raw PDF body was not opened; only existence and hash were recorded, per task instruction.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/US_RA07_rep.mod` exists and was read only as `implementation_cross_check`.
- The `.mod` confirms a `model(linear)` implementation with endogenous variables `pi`, `mc`, `rk`, `w`, `r`, `a`, `u`, `n`, `c`, `l`, `q`, `i`, `k`, `y`, and `g`.
- The `.mod` confirms exogenous innovations `epsp`, `epsz`, `epsa`, and `epsg`.
- The `.mod` adds `n=l` because of inconsistent labor notation in the source. The derivation records this identity as implementation-only, not as a paper-side source equation.
- Dynare was not run.

## Deferred Issues

- Source-level PDF review should check the nonlinear working-capital wage-bill expression and the utilization-cost notation.
- Review the paper's use of $\gamma$ as the fraction/elasticity of firms affected by the cost channel against any implementation comments before promotion beyond `needs_review`.
- Review the exact fixed values versus estimated posterior baseline values before any runtime validation; the MMB implementation has figure-specific parameter blocks.
- Confirm whether the resource constraint's utilization term should be retained exactly as in the paper's log-linear equation or transformed if a nonlinear runnable model is later built.
- Runtime validation, residual checks, BK checks, and IRF checks were not performed.

## Translation Status

- English derivation was drafted first.
- Chinese derivation is a direct translation of the English draft.
- Equation numbers `(F1)` through `(F15)` are preserved in both versions.
