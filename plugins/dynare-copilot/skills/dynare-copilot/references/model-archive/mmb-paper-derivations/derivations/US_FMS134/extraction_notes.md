# US_FMS134 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row for `US_FMS134` maps to "A pitfall with estimated dsge-based government spending multipliers" with match score `1.0000`.
- Primary Markdown: `raw/mmb_mineru/runs/us_fms134__a_pitfall_with_estimated_dsge_based_government_spending_multipliers__a04139a9/full.md`.
- Alternate MinerU run recorded: `a11daf77-e15e-4d97-94a3-24261481497e`.
- Raw PDF exists at `raw/mmb_papers/A pitfall with estimated dsge-based government spending multipliers.pdf`.
- First 80 Markdown lines match the expected title and authors.

## Formula Quality

- Status: `needs_review`.
- The paper-side Markdown fully supports the simple analytical model and the quantitative benchmark model with capital, labor habit, endogenous government spending, and steady-state multiplier formulas.
- The MMB `US_FMS134` implementation corresponds to the paper's Smets-Wouters-type robustness model, which the paper describes compactly rather than printing as a full equation appendix.
- Equations that encode Edgeworth complementarity and government-spending feedback are source-backed.
- Price Phillips, wage Phillips, consumption Euler, investment, Tobin's Q, and utilization equations are first-pass `implementation_cross_check` items and require paper appendix or source package verification before review promotion.

## Implementation Cross-Check

- Cross-check file: `.agents/skills/dynare-copilot/references/examples/US_FMS134_rep.mod`.
- Cross-check confirms:
  - `model(linear)` form.
  - Sticky and flexible blocks.
  - Seven exogenous innovations: `zetaz`, `zetab`, `zetax`, `zetap`, `zetaw`, `zetar`, `zetag`.
  - Endogenous fiscal policy parameter `phig`.
  - Edgeworth complementarity parameter `alphag`.
  - Measurement equations for output, consumption, investment, government spending, wages, inflation, interest rate, and hours.
- Dynare was not run.

## Deferred Issues

- No local normalized appendix exists at `docs/mmb_appendix_full_normalizations/US_FMS134.md`.
- The source Markdown does not print the full medium-scale SW-type FOC system; a later reviewer should inspect the official online appendix/source package if available.
- Several coefficients are compressed as `a_i`/`b_i` in the derivation to avoid copying long implementation algebra without paper-side confirmation.
- Runtime validation, BK checks, residual checks, and IRF validation are deferred.
- Shared `catalog.csv` and `status.csv` were not edited by user request.

## Translation Status

- English derivation drafted first.
- Chinese derivation translated from the English version with matching section structure and `(F#)` numbering.
