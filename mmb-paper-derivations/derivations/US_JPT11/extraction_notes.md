# US_JPT11 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row 143 maps `US_JPT11` to "Investment shocks and the relative price of investment" with DOI `10.1016/j.red.2010.08.004`, match status `matched`, and title match score `1.0000`.
- The primary Markdown path exists: `raw/mmb_mineru/runs/us_jpt11__investment_shocks_and_the_relative_price_of_investment__8d6c49b8/full.md`.
- The raw PDF path exists: `raw/mmb_papers/Investment shocks and the relative price of investment.pdf`.
- The first 80 Markdown lines show the expected title and authors.
- No `docs/mmb_appendix_full_normalizations/US_JPT11.md` file exists.
- No alternate MinerU run is listed in the `mineru_run_ids` field.

## Formula Quality

- The core paper-side equations extracted from Markdown include the final-good aggregator, intermediate-good demand, intermediate production technology, price indexation rule, investment-good technology, capital-good technology, capital-producer objective, household utility and budget constraint, capital utilization, physical capital accumulation, labor aggregator, wage indexation rule, government spending rule, monetary policy rule, investment relative-price identity, one-sector capital accumulation representation, and the exogenous processes.
- First-pass uncertain formulas are explicitly marked `needs_review` in the derivations:
  - Intermediate-firm cost-minimization conditions are inferred from the production technology; the main Markdown source does not print all factor FOCs.
  - The real marginal-cost normalization with nonstationary $`A_t`$ and $`\Upsilon_t`$ should be source-level checked.
  - The explicit recursive Calvo price and wage Phillips-curve conditions are not printed in the paper-side model section in the Markdown.
  - The capital-producer $`Q`$ condition is inferred from the intertemporal profit problem and should be checked against the PDF before any reviewed status.
  - Household marginal utility, Euler, and utilization FOCs are standard implications of the stated problem but require source-level formula review because the paper text emphasizes the log-linear solution rather than listing every nonlinear FOC.
  - The GDP-gap flexible counterpart $`X_t^*`$ is identified from the policy rule and implementation cross-check, but the exact flexible-economy subsystem requires review.
- Appendix A was used only to record the relative-price wedge result for sticky prices in both consumption and investment sectors; the main `US_JPT11` derivation remains the baseline competitive investment-good model.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/US_JPT11_rep.mod` was read only as `implementation_cross_check`.
- Cross-check observations:
  - The implementation uses `model(linear)`.
  - The implementation declares the baseline and flexible-star blocks for output, capital, labor, marginal product of capital, wages, marginal cost, marginal utility, consumption, rates, utilization, investment, physical capital, wage gap, and GDP.
  - The implementation includes exogenous innovations `Rs`, `zs`, `gs`, `mius`, `lambdaps`, `lambdaws`, `bs`, and `upsilons`.
  - The implementation adds the relative-price-of-investment shock `upsilon`, consistent with the paper's IST process.
  - The implementation contains commands `steady; check;` and `stoch_simul`, but Dynare was not run for this archive task.
- No equations were copied from the `.mod` as paper-side mathematical source.

## Deferred Issues

- Source-level check the nonlinear FOCs and exact stationary normalizations against the PDF or an author appendix before promoting beyond `needs_review`.
- Reconcile the paper-side nonlinear/decentralized equations with the log-linear Rep-MMB model block, especially the starred flexible-economy subsystem.
- Review equation count and endogenous-variable coverage before using the derivation as a runnable `.mod` build contract.
- Runtime validation, BK checks, steady-state checks, and IRF checks are deferred by instruction.

## Translation Status

- English derivation was drafted first.
- Chinese derivation was translated from the English derivation second.
- Equation numbers `(F1)` through `(F29)`, file paths, model IDs, DOI values, and `needs_review` markers were preserved.
