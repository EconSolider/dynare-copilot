# EA_QUEST3 Extraction Notes

Status: `needs_review`

## Source Match

- `raw/mmb_mineru/model_index.csv` row for `EA_QUEST3` has `model_title_match_score = 1.0000`.
- First 80 Markdown lines of `raw/mmb_mineru/runs/ea_quest3__quest_iii_an_estimated_open_economy_dsge_model_of_the_euro_area_with_fis__6b625a09/full.md` match the QUEST III title and authors.
- Raw PDF exists at `raw/mmb_papers/QUEST III- An estimated open-economy DSGE model of the euro area with fiscal and monetary policy.pdf`; PDF body was not read.
- No appendix normalization file exists at `docs/mmb_appendix_full_normalizations/EA_QUEST3.md`.

## Formula Quality

- The main Markdown source exposes the paper's model section and equations (1)-(38), including firm demand/production, firm FOCs, household FOCs, trade equations, fiscal rules, and monetary policy.
- OCR issues are visible in several equations. The derivation marks the affected formulas `needs_review` rather than silently normalizing them.
- Equations most needing source-level review:
  - firm labor FOC around paper Eq. (7a);
  - aggregate price markup around paper Eq. (7'd);
  - investment timing between paper Eq. (13) and Eq. (15a);
  - wage markup around paper Eq. (18);
  - appendix steady-state relationships, which were not visible enough in Markdown for a complete recursive block.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/EA_QUEST3_rep.mod` was read only as `implementation_cross_check`.
- The implementation confirms:
  - a large linearized/log-growth Dynare representation;
  - variables for monetary policy, fiscal policy, open-economy blocks, liquidity-constrained consumption, output gap, and smoothed employment/utilization;
  - shocks including monetary, fiscal, TFP, investment, trade, price/wage markup, risk-premium, and world-economy innovations;
  - runtime validation was commented out except for a quiet first-order `stoch_simul` command in the replication file.
- No equation in the derivation is sourced solely from the `.mod`; implementation names are listed to help later reconciliation.

## Deferred Issues

- Targeted PDF inspection is needed before promoting any formula from first-pass `needs_review` to reviewed status.
- Full steady-state recursion should be recovered from the paper appendix or a reviewed implementation note.
- The paper-side model is nonlinear with stochastic trends and stationary ratios, while the MMB implementation is linearized/log-growth; future work should explicitly map these forms before runnable archive promotion.
- Dynare runtime validation was not performed.

## Translation Status

- English derivation was drafted first.
- Chinese derivation was translated from the English version second.
- Equation numbers `(F1)` through `(F50)` are preserved in both files.
