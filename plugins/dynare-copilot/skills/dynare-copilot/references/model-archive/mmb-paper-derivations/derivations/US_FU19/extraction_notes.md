# US_FU19 Extraction Notes

## Status

- Status: `needs_review`
- Extraction date: 2026-06-17
- Scope: private derivation archive draft only.
- Runtime validation: not performed.
- Promotion to `.agents/skills/dynare-copilot/references/model-archive/`: not performed.
- Shared indexes: `catalog.csv` and `status.csv` were not edited.

## Sources Read

- `.agents/skills/mmb-model-archive-builder/SKILL.md`
- `.agents/skills/mmb-model-archive-builder/references/subagent-task-template.md`
- `docs/MODEL_ARCHIVE_BUILD_PLAN.md`
- `.agents/skills/dynare-copilot/references/derivation-style.md`
- `.agents/skills/dynare-copilot/references/model-archive/bgg_financial/bgg_financial_derivation.md`
- `raw/mmb_mineru/model_index.csv`
- `raw/mmb_mineru/runs/us_fu19__accounting_for_post_crisis_inflation_a_retro_analysis__efab411e/full.md`
- `raw/mmb_mineru/runs/us_fu19__accounting_for_post_crisis_inflation_a_retro_analysis__9554deb8/full.md` for first-page/title comparison only.
- `.agents/skills/dynare-copilot/references/examples/US_FU19_rep.mod` as `implementation_cross_check` only.

No `docs/mmb_appendix_full_normalizations/US_FU19.md` file exists.

## Source Match

- `model_index.csv` reports `mineru_match_status=matched`, `mineru_match_score=1.0000`, and `model_title_match_score=1.0000`.
- Primary source title in the Markdown is `Accounting for post-crisis inflation: A retro analysis`.
- Raw PDF exists at `raw/mmb_papers/Accounting for Post Crisis Inflation- A Retro Analysis.pdf`.
- The alternate MinerU run has the same first-page title/authors and is recorded in `source_manifest.json`; no source-index issue was found.

## Formula Quality

- Formula quality is `partial_paper_body_equations_only`.
- The paper body states that the benchmark exercise uses the original Smets-Wouters (2007) model and describes the main frictions and seven shocks.
- The paper directly provides:
  - the hybrid price Phillips curve, paper equation (1);
  - the ZLB monetary-surprise mapping, paper equation (7);
  - the time-varying inflation-target extension;
  - selected Del Negro et al. (2015) financial-friction extension equations.
- The paper body does not reproduce the complete Smets-Wouters household, firm, wage-setting, capital-accumulation, flexible-economy, and steady-state derivations.
- Because the full formula set is not source-level checked from a paper appendix, first-pass uncertainty is marked `needs_review`.

## Implementation Cross-Check

`US_FU19_rep.mod` was used only as `implementation_cross_check` to confirm:

- the model is declared as `model(linear)`;
- the endogenous variable set includes sticky-price/wage variables, flexible-price counterparts, seven observables, and seven shock states;
- the exogenous innovations are `eZ`, `ep`, `ew`, `eb2`, `emu`, `eg`, and `ems`;
- the implementation includes measurement equations for output, consumption, investment, real wage, inflation, interest rate, and labor;
- the local code calibrates and estimates the same Smets-Wouters style block described by the paper.

The `.mod` was not treated as paper-side mathematical evidence and Dynare was not run.

## Deferred Issues

- Source-level review should locate and ingest the online appendix or the original Smets-Wouters derivation source used by Fratto and Uhlig.
- Equations (F1)-(F9), (F11), (F13)-(F32), and the steady-state ratio formulas require source-level verification beyond the local `.mod`.
- The precise mapping between paper notation for markup shocks and implementation names `lambda_p`, `lambda_w`, `ep`, and `ew` should be reviewed.
- The MMB row lacks a year value even though the catalog reference records 2019 publication metadata; this entry records year `2019` in the manifest and worker report.
- Runtime validation, equation-count validation against Dynare, BK checks, and IRF/shock-decomposition replication are deferred.

## Translation Status

- English derivation was drafted first.
- Chinese derivation was translated second.
- F-number counts were checked to match between English and Chinese files.
