# NK_KRS12 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row for `NK_KRS12` is `matched` with model-title and source-title match scores of `1.0000`.
- The first 80 Markdown lines of the primary source contain the expected title, authors, journal citation, and DOI.
- Raw PDF exists at `raw/mmb_papers/Monetary and macroprudential policy rules in a model with house price booms.pdf`.
- No appendix normalization file exists at `docs/mmb_appendix_full_normalizations/NK_KRS12.md`.

## Formula Quality

- Status: `needs_review`.
- The source Markdown has embedded NUL/binary-like characters and OCR artifacts in prose, but the model equations are mostly readable.
- Appendix equation labels `(45)`, `(46)`, and `(53)` are OCR-damaged in places.
- The durable-sector Phillips curve in the Markdown appears to contain a malformed additional term `a_t^D`; the implementation cross-check has no durable TFP shock and uses `wD - q`.
- The paper states the nonlinear household problem and gives the final equilibrium in log-linear form. The archive derivation therefore uses the appendix's log-linear equilibrium as the core equation system.

## Implementation Cross-Check

- Read `.agents/skills/dynare-copilot/references/examples/NK_KRS12_rep.mod` only as `implementation_cross_check`.
- Confirmed `Model(linear);`, endogenous names, exogenous shocks `eps_A`, `eps_D`, `eps_v`, and the augmented Taylor plus macroprudential policy regime.
- Did not run Dynare.
- Potential-output auxiliary equations (`yCstar`, `yDstar`, `dstar`) are present in the implementation but are not fully derived in the paper appendix. They are mentioned as implementation details rather than promoted into the paper-side equation list.

## Deferred Issues

- Source-level review should compare the OCR-damaged appendix equations against the raw PDF, especially the durable Phillips curve and the Taylor rule factorization.
- The English and Chinese derivations preserve the same equation numbering, but the entry should remain `needs_review` until a targeted PDF formula check is completed.
- Runtime validation, residual checks, BK checks, and IRF replication are deferred.

## Translation Status

- English derivation drafted first.
- Chinese derivation created as a translation of the English core.
- Equation numbering `(F1)` through `(F29)` is preserved in both versions.
