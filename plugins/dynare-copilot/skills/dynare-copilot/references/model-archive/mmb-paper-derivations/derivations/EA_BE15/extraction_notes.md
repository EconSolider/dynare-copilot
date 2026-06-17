# EA_BE15 Extraction Notes

## Source Match

- Model index row: `EA_BE15` in `raw/mmb_mineru/model_index.csv`.
- Expected paper: "Money in the Production Function: A New Keynesian DSGE Perspective", Jonathan Benchimol, 2015.
- Primary Markdown: `raw/mmb_mineru/runs/ea_be15__money_in_the_production_function_a_new_keynesian_dsge_perspective__1c7666dc/full.md`.
- Raw PDF: `raw/mmb_papers/Money in the Production Function- A New Keynesian DSGE Perspective.pdf`.
- MinerU run id: `1c7666dc-063b-460a-8f2d-880e0b541ee9`.
- First-page / first-80-line sniff: title appears on Markdown line 1 and again as the article heading; author line reports `Author(s): Jonathan Benchimol`. No source mismatch found.
- Appendix normalization: `docs/mmb_appendix_full_normalizations/EA_BE15.md` does not exist.

## Formula Quality

- Status: `needs_review`.
- The Markdown contains the paper's household optimization problem, appendix FOCs, production function, Calvo pricing derivation, aggregate Phillips curve, IS equation, money-demand equations, quantity/velocity closure, DSGE eight-equation block, and AR(1) shock definitions.
- OCR quality is adequate for a first-pass derivation, but some notation is inconsistent (`v` versus `nu`, bold `mp`, and occasional OCR substitutions in appendix symbols). The English derivation normalizes notation while preserving uncertainty in review notes.
- The coefficient formulas for flexible-price output and the Phillips curve were summarized rather than fully rederived. They require formula-level review against the PDF or author source before any `reviewed_derivation` status.

## Implementation Cross-Check

- Cross-check file: `.agents/skills/dynare-copilot/references/examples/EA_BE15_rep.mod`.
- Used only as `implementation_cross_check`, not as paper-side mathematical evidence.
- Confirmed `model(linear)`.
- Confirmed endogenous variables: `y, pi, ir, mp, mn, yf, mpf, mnf, ea, eu, ei, ep, en, vel, rr, ygap`.
- Confirmed exogenous innovations: `ua, uu, ui, up, un`.
- Confirmed the implementation uses a productive-money-gap Taylor rule equivalent to the paper's `k=2` case.
- Dynare was not run.

## Deferred Issues

- Verify whether the MMB intended experiment is exactly the paper's `k=2` Taylor-rule variant or a broader entry representing all five variants.
- Source-level check the flexible-output coefficient aliases (`vym`, `vyc`, `vya`, `vyp`) and Phillips-curve aliases (`pi1`, `pi2`) against the paper equations.
- Reconcile paper notation for the household money-demand elasticity `v` / `nu` and the implementation parameter `nu`.
- Confirm whether auxiliary implementation identities `rr` and `ygap` should be included in future equation-count audits or left as reporting variables.

## Translation Status

- English derivation drafted first.
- Chinese derivation translated from the English core.
- Equation numbering `(F1)` through `(F14)` is preserved in both files.
