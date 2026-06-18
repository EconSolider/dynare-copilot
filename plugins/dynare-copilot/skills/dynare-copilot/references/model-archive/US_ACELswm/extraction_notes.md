# US_ACELswm Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` lists `US_ACELswm` as Altig, Christiano, Eichenbaum, and Linde, "Firm-specific capital, nominal rigidities" (2005), DOI `10.3386/w11034`.
- The row's `primary_full_md_path`, `raw/mmb_mineru/runs/us_acelm_us_acelswm_us_acelswt_us_acelt__firm_specific_capital_nominal_rigidities__e0fac58f/full.md`, begins with the expected title and authors.
- The row's `raw_pdf_path`, `raw/mmb_papers/Firm-specific capital, nominal rigidities.pdf`, exists. Per task contract, the PDF body was not read.
- No `docs/mmb_appendix_full_normalizations/US_ACELswm.md` file exists.

## Formula Quality

- Status: `needs_review`.
- The paper-side Markdown contains the nonlinear model economy, timing, final-good aggregation, intermediate-firm technology, household preferences and budget, wage aggregation, monetary policy processes, market-clearing equations, reduced inflation equation, and steady-state calibration discussion.
- The paper references a separate technical appendix for the computational linear equilibrium system. That appendix is not present as a normalized source for this model. Therefore the linear equilibrium equations in the derivation are marked `needs_review` and identified as `implementation_cross_check` when they come from `.agents/skills/dynare-copilot/references/examples/US_ACELswm_rep.mod`.
- No long prose was copied from the paper. Equations were extracted or summarized into archive form.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/US_ACELswm_rep.mod` exists and was read only as `implementation_cross_check`.
- The `.mod` confirms `model(linear)`, the sticky-price block, the flexible-price allocation block, lead/pred timing auxiliaries, the parameter calibration, and the four exogenous innovations.
- The `.mod` states this MMB file produces the right monetary-policy-shock IRFs for the ACEL model without the cost channel (`nu = 0`) and warns that technology-shock answers are wrong because variables are predetermined.
- The `.mod` was not treated as paper-side evidence and was not run.

## Deferred Issues

- Locate or convert the Altig et al. technical appendix to source-check equations labeled technical-appendix eq. (1)-(16).
- Verify the exact firm-specific-capital expression for the inflation-slope mapping parameter `chi`.
- Check whether the MMB `gamma` comment "homogeneous capital model" reflects naming drift in this `US_ACELswm` implementation or a deliberate reduced-form observational-equivalence parameterization.
- Reconcile the extra transitory neutral technology shock in the MMB file with the original ACEL source package.
- Do not promote this derivation to the runnable skill archive until source-level formula review and runtime validation are separately assigned.

## Translation Status

- English derivation drafted first.
- Chinese derivation translated from the English version.
- Equation numbers `(F1)` through `(F53)` are preserved in both files.
