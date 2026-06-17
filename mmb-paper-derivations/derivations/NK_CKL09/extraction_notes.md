# NK_CKL09 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row for `NK_CKL09` is matched with score `1.0000`.
- Primary Markdown: `raw/mmb_mineru/runs/ea_ckl09_nk_ckl09__the_role_of_labor_markets_for_euro_area_monetary_policy__c6a4d4a1/full.md`.
- Raw PDF exists at `raw/mmb_papers/The role of labor markets for euro area monetary policy.pdf`; PDF body was not read because the Markdown contains the model and Appendix A equations.
- No appendix normalization file exists at `docs/mmb_appendix_full_normalizations/NK_CKL09.md`.

## Formula Quality

- The model is a log-linear system around a calibrated steady state. The English derivation uses Appendix A's linearized economy as the main equation source.
- Equations (F13)-(F16) are marked `needs_review`; the OCR source contains several symbol corruptions in the wage-bargaining/value-recursion block, although the Rep-MMB `.mod` file provides a consistent implementation cross-check.
- The flexible-price/flexible-wage block is summarized rather than expanded into a full duplicate system. The implementation cross-check has explicit flex analogues, but the paper describes it conceptually as a duplicated system with nominal rigidities set to zero.
- First-pass status remains `needs_review`.

## Implementation Cross-Check

- Cross-check file: `.agents/skills/dynare-copilot/references/examples/NK_CKL09_rep.mod`.
- Confirmed `model(linear)` form.
- Confirmed calibrated Section 3 parameter values: `bet=0.992`, `epsilon=11`, `habit=0.6`, `sig=1.5`, `omega=0.75`, `xi=0.6`, `eta=0.5`, `gamma=0.83`, `vtheta=0.03`, `alp=0.66`, `gamma_R=0.85`, `gamma_Pi=1.5`, `gamma_y=0.5`, and `gamma_dy=0`.
- Confirmed state and shock names used in the archive table: `ebt`, `gt`, `emoneyt`, `zt`, `ebargaint`, `ekappat`, `esept`, and `eCt`.
- The `.mod` file was used only as `implementation_cross_check`, not as a paper-side mathematical source.

## Deferred Issues

- Source-level PDF formula check is still needed for the wage bargaining recursions and worker/firm value equations.
- The flex-price/flex-wage block should be expanded into full equation-by-equation form if a runnable archive implementation is later built.
- Runtime validation was not performed; no Dynare `resid`, `steady`, `check`, or simulation run was attempted.
- Shared `catalog.csv` and `status.csv` were intentionally not edited.

## Translation Status

- English derivation drafted first.
- Chinese derivation translated from the English derivation.
- Equation numbers `(F1)` through `(F32)` are preserved in both files.
