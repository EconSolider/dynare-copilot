# US_VI16bgg Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row status: `matched`.
- Primary source title: `Financial frictions in the Euro Area and the United States- a Bayesian assessment`.
- First-page sniff matched expected source: title `FINANCIAL FRICTIONS IN THE EURO AREA AND THE UNITED STATES: A BAYESIAN ASSESSMENT`, author `STEFANIA VILLA`.
- No alternate MinerU run inspection was needed; `mineru_run_ids` contains one run id, `ed2f2b1d-60d9-4da9-a9c6-b57af3b7e740`.
- Raw PDF exists and was recorded for provenance only; PDF body was not read.
- Appendix normalization file `docs/mmb_appendix_full_normalizations/US_VI16bgg.md` does not exist.

## Formula Quality

- Status: `needs_review`.
- The main Markdown source contains Table 1 with linearized model equations, but the paper states that the online appendix contains full model details.
- Optimization problems in Section 2 are therefore structural summaries, while the numbered equations in Sections 3-5 are anchored to Table 1 when present.
- The AR(1) shock process signs are not printed in Table 1 and were taken from `.agents/skills/dynare-copilot/references/examples/US_VI16bgg_rep.mod` as `implementation_cross_check`.
- The employment Phillips curve is printed in Table 1, but the US implementation comments it out. The derivation keeps it as source-stated optional content and marks this as a review issue.

## Implementation Cross-Check

- File read: `.agents/skills/dynare-copilot/references/examples/US_VI16bgg_rep.mod`.
- Cross-check findings:
  - Confirms `model(linear)`.
  - Confirms US SW-BGG variable set: `y c i w l pi r rn zk u k q rk ext_pr n` plus flexible-price counterparts.
  - Confirms seven innovations: `e_a e_g e_x e_r e_p e_w e_k`.
  - Confirms shock-state names: `a g eps_x eps_r eps_p eps_w eps_k`.
  - Confirms the US replication comments out employment equations.
  - Provides steady-state ratio calculations for implementation use: `R`, `ZK`, `RK`, `K_L`, `Y_K`, `K_Y`, `I_Y`, `C_Y`, `K_N`.

## Deferred Issues

- Review against Villa's online appendix before marking formulas `reviewed_derivation`.
- Check whether Section 2 should include a more explicit utility function, union problem, price-setting problem, and capital-producer adjustment-cost problem from appendix materials.
- Decide whether the optional employment equation should remain in the US archive equation count or be moved to notes only.
- Source-check shock process signs against an appendix or original replication package.
- Runtime validation, residual checks, steady-state checks, BK conditions, and IRF checks were not performed.

## Translation Status

- English derivation drafted first.
- Chinese derivation translated from the English derivation.
- The eight-section structure and `(F#)` numbering are preserved in both files.
