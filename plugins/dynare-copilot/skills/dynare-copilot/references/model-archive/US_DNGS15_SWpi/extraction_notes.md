# US_DNGS15_SWpi Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row for `US_DNGS15_SWpi` points to `raw/mmb_mineru/runs/us_dngs15_us_dngs15_sw_us_dngs15_swsp_us_dngs15__infation_in_the_great_recession_and_new_keynesian_models__c8e184ab/full.md`.
- First-page/first-80-line sniff matched the expected title and authors: "Inflation in the Great Recession and New Keynesian Models"; Marco Del Negro, Marc P. Giannoni, Frank Schorfheide.
- The source path and `primary_source_title` contain the OCR/file-name typo `Infation`; the article title in the Markdown body and model-index paper title are otherwise matched. `model_title_match_score = 0.9912`.
- `raw_pdf_path` exists at `raw/mmb_papers/Infation in the Great recession and New Keynesian models.pdf`. The PDF body was not opened because Markdown was sufficient for a first-pass `needs_review` draft.
- `docs/mmb_appendix_full_normalizations/US_DNGS15_SWpi.md` does not exist.
- `.agents/skills/dynare-copilot/references/examples/US_DNGS15_SWpi_rep.mod` exists and was used only as `implementation_cross_check`.

## Formula Quality

- Overall formula quality: `needs_review`.
- The main SW log-linear equations in the Markdown are readable: productivity trend, Euler equation, investment equation, capital accumulation, utilization, marginal cost, production, resource constraint, price and wage Phillips curves, MRS, policy rule, target inflation process, and exogenous processes.
- OCR artifacts appear in several source equations: the beta-bar definition has malformed text around the exponent; the wage-markup notation around `lambda_w` has OCR noise; the state-space section has malformed symbols that are not needed for this derivation.
- The paper says steady-state formulas are in the technical appendix of Del Negro and Schorfheide (2013), but no local appendix normalization exists for this model. Steady-state coverage is therefore partial.
- The source paper covers multiple model variants (`US_DNGS15`, `US_DNGS15_SW`, `US_DNGS15_SWSP`, `US_DNGS15_SWpi`) from the same Markdown/PDF. This entry isolates the SWpi target-inflation variant and records variant ambiguity as `needs_review`.

## Implementation Cross-Check

- The Rep-MMB implementation confirms `model(linear)` and the core variable list for the SWpi variant.
- The implementation comment states this is the DNGS15 model with a time-varying inflation target but no financial frictions.
- The implementation fixes `pist = 1.0069` and comments out the inflation-target process. The paper-side derivation retains the process from equation (18), while noting this implementation difference.
- The implementation retains `Rktil` and `sigw` equations under a "Financial Frictions" comment, but calibrates `rho_sigw = 0` and `psi_sigw` with zero standard error. These equations were documented as implementation-cross-check evidence only.
- No equations were copied from the `.mod` file as paper-side source evidence.
- Dynare was not run.

## Deferred Issues

- Check the technical appendix or another source-backed normalization for the steady-state constants before upgrading `steady_state_quality`.
- Decide whether reviewed `US_DNGS15_SWpi` should include the paper-side $`\pi_t^*`$ AR(1) process as active, or follow the Rep-MMB file's fixed-`pist` implementation.
- Review whether the inactive spread-shock/`Rktil` block should remain in the SWpi derivation or be treated solely as Rep-MMB implementation residue.
- Confirm whether the shared catalog should describe the model as "without financial frictions" despite `sigw`/spread observables appearing in the implementation file with zero variance.
- Runtime validation, Dynare equation count, steady-state residuals, BK checks, and IRF checks were not performed.

## Translation Status

- `US_DNGS15_SWpi_derivation.zh.md` is a translation of the English draft.
- Equation numbers `(F1)` through `(F38)` and LaTeX formulas were preserved.
