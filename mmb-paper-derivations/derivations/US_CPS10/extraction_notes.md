# US_CPS10 Extraction Notes

## Source Match

- `US_CPS10` matches `raw/mmb_mineru/runs/us_cps10__inflation_gap_persistence_in_the_us__1f4da37a/full.md`.
- MinerU run id: `1f4da37a-8561-42b9-b0b5-1edf5edbf8fb`.
- Title sniff: Markdown begins with "Inflation-Gap Persistence in the US" and the authors Timothy Cogley, Giorgio E. Primiceri, and Thomas J. Sargent.
- `raw_pdf_path` exists at `raw/mmb_papers/Inflation-gap persistence in the us.pdf`; the PDF body was not read because the Markdown source was sufficient for a first-pass extraction.
- No appendix normalization file exists at `docs/mmb_appendix_full_normalizations/US_CPS10.md`.

## Formula Quality

- Status: `needs_review`.
- Paper-side structural primitives are clear in Section V.A: household objective, budget constraint, consumption aggregator, production function, Calvo price-setting problem, Taylor rule, and exogenous target process.
- The paper states that the model is solved by scaling variables by unit-root technology and log-linearizing around the nonstochastic steady state, but it does not print the complete log-linear system used by Rep-MMB.
- The derivation therefore records the primitives as paper source evidence and the full linear system as `implementation_cross_check` evidence from `.agents/skills/dynare-copilot/references/examples/US_CPS10_rep.mod`.
- MinerU OCR issue: equation (21) repeats $\log\pi_t^*$ on both sides. The lagged process in the implementation and surrounding prose is used in the derivation but remains marked `needs_review`.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/US_CPS10_rep.mod` exists and was read only as an implementation cross-check.
- The implementation uses `model (linear)` with endogenous variables `p y lambdda w R z lambddap pit b ystar lambddastar wstar Rstar inflgap realR outpgap`.
- Exogenous innovations are `Rs zs lambddaps pits bs`.
- The active calibration is the 1960-1979 posterior median block from the paper's Table 3; the counterfactual and 1982-2006 parameter blocks are commented in the `.mod`.
- Dynare was not run.

## Deferred Issues

- Source-level review should verify the exact algebra linking the paper primitives to equations (F1)-(F12), especially the habit marginal-utility relation and the Phillips-curve coefficient.
- A targeted PDF check may be useful for equation (21) if the archive later needs a clean source-level correction of the inflation-target lag.
- Runtime validation, determinacy, equation-count checks in Dynare, and IRF reproduction are deferred.

## Translation Status

- English derivation drafted first.
- Chinese derivation translated from the English version.
- Equation numbers `(F1)` through `(F16)` are preserved in both files.
