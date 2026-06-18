# US_FV15 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row for `US_FV15` has `mineru_match_status=matched`, `mineru_match_score=1.0000`, `model_title_match_score=1.0000`, and no `model_match_notes`.
- First 80 Markdown lines show the expected title, "Estimating dynamic equilibrium models with stochastic volatility", and the expected three authors.
- Primary Markdown: `raw/mmb_mineru/runs/us_fv15__estimating_dynamic_equilibrium_models_with_stochastic_volatility__ae6b2e5b/full.md`.
- Raw PDF path exists: `raw/mmb_papers/Estimating dynamic equilibrium models with stochastic volatility.pdf`.
- No appendix normalization file exists at `docs/mmb_appendix_full_normalizations/US_FV15.md`.

## Extraction Scope

- English derivation was drafted first using the required eight-section structure.
- Chinese derivation is a direct translation of the English core and preserves `(F#)` numbering, file paths, DOI values, model ID, and `needs_review` markers.
- The paper-side Markdown gives the main model blocks in sections 5.1-5.4 but says the full stationary equilibrium is characterized in appendix 3. That appendix was not available as a local normalization file.
- The `.mod` file `.agents/skills/dynare-copilot/references/examples/US_FV15_rep.mod` was read only as `implementation_cross_check`.

## Formula Quality

- Overall formula status: `needs_review`.
- MinerU Markdown captured the main household objective, budget constraint, capital accumulation, final-good aggregator, intermediate production technology, Taylor rule, stochastic-volatility laws, policy-drift laws, state vector, and observable vector.
- OCR anomalies were visible around the utilization-cost function, some Greek-letter notation, and the stationary-rescaling definitions.
- The full wage-setting, price-setting, dispersion, and stationary equilibrium equations were normalized in the derivation and cross-checked against the Rep-MMB implementation. These should be source-level checked against the paper appendix or original computational files before review status is upgraded.
- The PDF body was not opened because the Markdown was sufficient for a first-pass `needs_review` extraction and the task contract says not to read the PDF body by default.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/US_FV15_rep.mod` exists and was read only as `implementation_cross_check`.
- The `.mod` confirms endogenous variables `d`, `c`, `mu_z`, `mu_I`, `mu_A`, `lambda`, `R`, `PI`, `r`, `x`, `u`, `q`, `f`, `ld`, `w`, `wstar`, `PIstarw`, `PIstar`, `g1`, `g2`, `yd`, `mc`, `k`, `vp`, `vw`, `l`, `phi`, `F`, `sigma_dt`, `sigma_phit`, `sigma_mut`, `sigma_At`, `sigma_mt`, `gammaPIt`, `gammayt`, and `yg`.
- The `.mod` confirms exogenous innovations `epsd`, `epsphi`, `epsmu_I`, `epsA`, `epsm`, `ud`, `uphi`, `umu`, `uA`, `um`, `epspi`, and `epsy`.
- The `.mod` declares `predetermined_variables k`, matching the timing note that production uses predetermined capital.
- Dynare was not run.

## Deferred Issues

- Source-level review should check equations (F3), (F6), (F7), (F13), (F19), (F20), and the stationarized capital/resource equations against appendix 3 or the original computational files.
- The steady-state solution is only summarized from the balanced-growth normalizations visible in the main text; a full analytic steady-state sequence remains deferred.
- The paper's estimation uses second-order approximation, while the Rep-MMB `.mod` is a first-order implementation. Runtime and approximation-order implications are deferred to a later validation phase.
- Runtime validation, residual checks, BK checks, IRF checks, and promotion to the runnable skill archive were not performed.

## Translation Status

- English derivation completed first.
- Chinese translation completed second.
- English and Chinese `(F#)` counts match in validation.
