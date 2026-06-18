# US_BKM12 Extraction Notes

## Status

- Status: `needs_review`
- Extraction date: 2026-06-17
- Scope: private derivation archive draft only.
- Runtime validation: not performed.
- Promotion to `.agents/skills/dynare-copilot/references/model-archive/`: not performed.
- Shared `catalog.csv` / `status.csv`: not edited by user instruction.

## Sources Read

- `.agents/skills/mmb-model-archive-builder/SKILL.md`
- `.agents/skills/mmb-model-archive-builder/references/subagent-task-template.md`
- `docs/MODEL_ARCHIVE_BUILD_PLAN.md`
- `.agents/skills/dynare-copilot/references/derivation-style.md`
- `.agents/skills/dynare-copilot/references/model-archive/bgg_financial/bgg_financial_derivation.md`
- `raw/mmb_mineru/model_index.csv`
- `raw/mmb_mineru/runs/us_bkm12__reset_price_inflation_and_the_impact_of_monetary_policy_shocks__f65547b5/full.md`
- `.agents/skills/dynare-copilot/references/examples/US_BKM12_rep.mod` as implementation cross-check only.
- `raw/mmb_papers/Reset Price Inflation and the Impact of Monetary Policy Shocks.pdf` was checked for existence and hashed, but the PDF body was not read.

## Source Match

- `model_index.csv` reports `mineru_match_status=matched`, `mineru_match_score=1.0000`, and `model_title_match_score=1.0000`.
- Primary source title is `Reset Price Inflation and the Impact of Monetary Policy Shocks`.
- Raw PDF path exists.
- No alternate MinerU run is listed for this model.
- No title mismatch was found.

## Formula Quality

- The article body does not print a complete nonlinear Smets-Wouters derivation. It describes the reestimated bimonthly SW model, the imposed CPI price-change frequency, the removal of price indexation for reset-price exercises, and the reset-price inflation measurement equations.
- The draft therefore combines paper-side description and reset-price equations with a linear SW-style equilibrium inventory cross-checked against `US_BKM12_rep.mod`.
- `needs_review`: exact Kimball goods/labor curvature terms, Calvo reset-price FOC, Calvo wage-reset FOC, and source-side treatment of price indexation.
- `needs_review`: the implementation file contains a positive `cindp` parameter and a lagged inflation term in the price Phillips curve, while the paper says that from the reset-price comparison onward it avoids price indexation. This may reflect code reuse, estimation variant differences, or a Rep-MMB implementation convention.
- `needs_review`: the published article discusses markup-shock and no-markup-shock simulations; the implementation retains the price-markup state `spinf`. The derivation records the state but does not claim a single simulation setting.

## Implementation Cross-Check

`US_BKM12_rep.mod` is `model(linear)` and contains:

- Flexible-economy variables: `zcapf`, `rkf`, `kf`, `pkf`, `cf`, `invef`, `yf`, `labf`, `wf`, `rrf`, `kpf`.
- Sticky-economy variables: `mc`, `zcap`, `rk`, `k`, `pk`, `c`, `inve`, `y`, `lab`, `pinf`, `w`, `r`, `kp`.
- Shock states and auxiliaries: `a`, `b`, `g`, `qs`, `ms`, `spinf`, `sw`, `epinfma`, `ewma`.
- Observables: `labobs`, `robs`, `pinfobs`, `dy`, `dc`, `dinve`, `dw`.
- Innovations: `ea`, `eb`, `eg`, `eqs`, `em`, `epinf`, `ew`.

Information from the `.mod` file is used only to flag coverage and naming issues. It is not treated as source-stated paper math, and Dynare was not run.

## Deferred Issues

- Full nonlinear household, firm, final-good, and labor-union optimization problems require source review beyond the article body.
- The exact no-indexation reset-price variant should be aligned against either paper replication files or a PDF appendix, if available.
- Equation count is not ready for runtime validation because the model includes flexible-economy counterparts, measurement equations, and MA auxiliaries beyond the paper's prose exposition.
- The reset-inflation formulas are source-stated, but their simulation implementation is not reconstructed here.

## Translation

- English derivation added at `US_BKM12_derivation.en.md`.
- Chinese translation added at `US_BKM12_derivation.zh.md`.
- The Chinese version preserves section order and F-numbering.
