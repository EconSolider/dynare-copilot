# US_SW07AL Extraction Notes

Status: `needs_review`

## Source Match

- `raw/mmb_mineru/model_index.csv` has an exact matched row for `US_SW07AL`.
- Primary source title: "Learning in an estimated medium-scale DSGE model".
- Title/authors in the first Markdown lines match the indexed source.
- MinerU run id: `4c268cb2-b0b4-4ab9-a228-2865f065d4b0`.
- Raw PDF exists at `raw/mmb_papers/Learning in an estimated medium-scale DSGE model.pdf`.
- No `docs/mmb_appendix_full_normalizations/US_SW07AL.md` file exists.

## Formula Quality

- The main learning equations in Section 3 are usable in Markdown: structural linear system, exogenous AR/ARMA representation, MSV solution form, PLM, constant-gain updates, and initial moment formulas.
- Appendix B supplies the log-linear Smets-Wouters structural equations. These were extracted as source-stated log-linear equations rather than reconstructed from a nonlinear optimization system.
- OCR uncertainty remains in several places:
  - The rendered dimension for the belief intercept vector near the statement "12 forward-looking variables, 11 endogenous state variables, and 9 exogenous stochastic processes" is garbled.
  - Some OCR symbols around the depreciation sentence, wage markup shock notation, and flexible-output notation are malformed.
  - The output-gap equation requires the flexible price/wage economy, but the Appendix B OCR does not provide the full companion flexible-economy block.
  - The markup shocks are described as ARMA(1,1), while the exact process-by-process notation is summarized generically and should be checked before implementation.

## Implementation Cross-Check

- Expected file `.agents/skills/dynare-copilot/references/examples/US_SW07AL_rep.mod` does not exist.
- Related file `.agents/skills/dynare-copilot/references/examples/US_SW07_rep.mod` exists, but it was not used as assigned cross-check evidence for `US_SW07AL`.
- No `.mod` file was treated as a paper-side mathematical source.

## Deferred Issues

- Reconstructing the full nonlinear Smets-Wouters household, firm, wage-setting, capital-utilization, and steady-state system is deferred.
- Checking the exact flexible-price/wage output block used in the policy-rule output gap is deferred.
- Verifying exact variable counts against a runnable MMB `.mod` implementation is deferred because no `US_SW07AL_rep.mod` cross-check file exists.
- Dynare runtime validation, BK checks, residual checks, IRFs, and posterior replication were not performed.

## Translation Status

- English derivation was drafted first.
- Chinese derivation was translated second from the English core.
- F-number counts match between English and Chinese in the current files.
