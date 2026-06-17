# EA_BF17 Extraction Notes

## Source Match

- Model index row: `EA_BF17` in `raw/mmb_mineru/model_index.csv`.
- Expected paper: "Money And Monetary Policy In The Eurozone: An Empirical Analysis During Crises", Jonathan Benchimol and Andre Fourcans, 2017.
- Primary Markdown: `raw/mmb_mineru/runs/ea_bf17__money_and_monetary_policy_in_the_eurozone_an_empirical_analysis_during_c__c4e7b84e/full.md`.
- Raw PDF: `raw/mmb_papers/Money And Monetary Policy In The Eurozone- An Empirical Analysis During Crises.pdf`.
- MinerU run id: `c4e7b84e-cfee-46d2-910b-8167adc738b2`.
- First-page / first-80-line sniff: Markdown line 1 matches the expected title case-insensitively. Author lines report `JONATHAN BENCHIMOL` and OCR-rendered `ANDRE´ FOURC¸ANS`, matching the expected authors with accent artifacts. No source mismatch found.
- Appendix normalization: `docs/mmb_appendix_full_normalizations/EA_BF17.md` does not exist.

## Formula Quality

- Status: `needs_review`.
- The primary Markdown states that the two DSGE models are presented in the Online Appendix. The local MinerU text does not include the Online Appendix model-equation block.
- The Markdown contains useful model-identification evidence: Model 1 is the separable Gali-style baseline; Model 2 has nonseparable preferences between consumption and real money balances and a money-augmented policy rule; observed variables are output, inflation, short-term interest rate, and real money balances; shocks are markup, technology, monetary policy, and money shocks.
- Parameter and prior tables are present for `beta`, `alpha`, `theta`, `nu`, `sigma`, `b`, `eta`, `epsilon`, Taylor-rule coefficients, shock persistence, and shock standard errors.
- The derivation uses reduced equations cross-checked against `.agents/skills/dynare-copilot/references/examples/EA_BF17_rep.mod` and marks coefficient-level source uncertainty as `needs_review`.
- No PDF body was opened; raw PDF existence and hash were recorded for provenance only.

## Implementation Cross-Check

- Cross-check file: `.agents/skills/dynare-copilot/references/examples/EA_BF17_rep.mod`.
- Used only as `implementation_cross_check`, not as paper-side mathematical evidence.
- Confirmed log-linear implementation variables: `y, pi, r, mp, yf, mpf, ep, ei, em, at, ygap`.
- Confirmed exogenous innovations: `up, ui, um, ua`.
- Confirmed shock states: `at`, `ep`, `ei`, and `em` follow AR(1) laws.
- Confirmed the compact reduced equations for flexible-price output, flexible-price money, Phillips curve, IS curve, money demand, Taylor rule, and output gap identity.
- The implementation has `+ li4*(mp-mpf)` commented out in the Taylor rule while source prose says Model 2 includes money in the Taylor rule. This mismatch is unresolved and should be reviewed before promoting status.
- Dynare was not run.

## Deferred Issues

- Locate or ingest the Online Appendix before any `reviewed_derivation` status; the current MinerU Markdown does not contain the full model derivation.
- Source-level check the coefficient formulas in (F1)-(F4), especially the OCR-visible money-channel coefficient fragments around the GFC interpretation section.
- Resolve whether the MMB implementation intentionally omits the money term in the Taylor rule despite the paper description of Model 2.
- Verify the formulas for `a1` and `a2`; the implementation uses exponential expressions that may be OCR- or code-convention sensitive.
- Confirm whether `r` is best described as the short-term nominal interest rate or a detrended policy-rate variable in the MMB implementation.
- Runtime validation was intentionally not performed.

## Translation Status

- English derivation drafted first.
- Chinese derivation translated from the English core.
- Equation numbering `(F1)` through `(F11)` is preserved in both files.
