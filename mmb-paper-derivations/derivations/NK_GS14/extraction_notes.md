# NK_GS14 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row: `NK_GS14`.
- MinerU match status: `matched`.
- MinerU/model title match scores: `1.0000` and `1.0000`.
- Primary full Markdown: `raw/mmb_mineru/runs/nk_gs14__should_monetary_policy_lean_against_the_wind_an_analysis_based_on_a_dsge__0f9b3acb/full.md`.
- MinerU run id: `0f9b3acb-25b5-48bb-94df-55820558f4d8`.
- Raw PDF path exists: `raw/mmb_papers/Should monetary policy lean against the wind? An analysis based on a DSGE model with banking.pdf`.
- PDF body was not read.
- No appendix normalization file exists at `docs/mmb_appendix_full_normalizations/NK_GS14.md`.

## Formula Quality

- Main extraction uses paper-side equations in Appendix A plus the policy-rule and technology-shock formulas in the main text.
- The production function timing was normalized to predetermined capital, because Appendix A's production equation prints \(k_t^E\) while the return-to-capital equation and the MMB implementation use \(k_{t-1}^E\). This remains `needs_review`.
- The goods markup / cost-push process is recorded from the implementation cross-check and from the paper's Phillips-curve discussion. It should receive source-level review before being treated as fully source-verified.
- Appendix C contains useful log-linear checks, but several formulas include OCR artifacts; those expressions were not copied wholesale into the derivation.
- The nominal-debt Appendix D variant was not folded into the baseline equation list.

## Implementation Cross-Check

- Cross-check file: `.agents/skills/dynare-copilot/references/examples/NK_GS14_rep.mod`.
- Used only as `implementation_cross_check`, not as a paper-side mathematical source.
- Cross-check confirmed endogenous variables, exogenous shock names `e_A_e` and `e_mk_y`, log-level `exp(...)` implementation, first-order simulation, and the gross-rate implementation of the augmented Taylor rule.
- Cross-check also exposed auxiliary variables `Y1`, `lev`, `spread`, and `rr`, which are recorded as implementation/diagnostic identities where appropriate.

## Deferred Issues

- Runtime validation was not performed; future work should run `resid; steady; check;` on the MMB implementation or a regenerated `.mod`.
- The exact analytic steady-state construction is not fully derived in this first-pass archive entry. The entry records calibration targets and a solution sequence instead.
- Source-level review is needed for the production-capital timing normalization and the markup/cost-push shock process.
- A separate variant entry or appendix note would be needed if the nominal-debt channel in Appendix D is to be archived.

## Translation Status

- English derivation drafted first.
- Chinese derivation translated from the English derivation.
- Equation numbers `(F1)` through `(F35)` were preserved in both files.

## Index Status

- Shared `catalog.csv` and `status.csv` were not edited because this task explicitly restricted ownership to `mmb-paper-derivations/derivations/NK_GS14/`.
