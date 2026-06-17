# EA_GNSS10 Extraction Notes

## Source Match

- Model index row: `EA_GNSS10` in `raw/mmb_mineru/model_index.csv`.
- Expected paper: "Credit and Banking in a DSGE Model of the Euro Area", Andrea Gerali, Stefano Neri, Luca Sessa, and Federico M. Signoretti, 2010.
- Primary Markdown: `raw/mmb_mineru/runs/ea_gnss10__credit_and_banking_in_a_dsge_model_of_the_euro_area__2883c15a/full.md`.
- Raw PDF: `raw/mmb_papers/Credit and Banking in a DSGE Model of the Euro Area.pdf`.
- MinerU run id: `2883c15a-d7ec-4dfa-9313-d893eb9a6414`.
- First-80-line sniff: the expected title appears as the Markdown heading, and the four expected author names appear before it. No source mismatch found.
- Appendix normalization: `docs/mmb_appendix_full_normalizations/EA_GNSS10.md` does not exist.

## Formula Quality

- Status: `needs_review`.
- The Markdown source contains the model-economy section, household and entrepreneur optimization problems, collateral constraints, loan and deposit demand, banking problem and FOCs, bank profits, capital/retail production descriptions, monetary policy rule, market clearing, log-linearization statement, calibration table, and shock process discussion.
- OCR quality is usable for a first-pass derivation, but some formulas are visibly noisy. The capital-producer Tobin's q FOC, price Phillips curve, and wage Phillips curve should be checked against the PDF or author source before promotion.
- The English derivation summarizes the large model into a source-backed equilibrium skeleton and marks unresolved formula normalizations with `needs_review`.
- The raw PDF body was not opened, following the task rule. Only its path and hash were checked for provenance.

## Implementation Cross-Check

- Cross-check file: `.agents/skills/dynare-copilot/references/examples/EA_GNSS10_rep.mod`.
- Used only as `implementation_cross_check`, not as paper-side mathematical evidence.
- Confirmed the implemented blocks: patient households, impatient households, capital producers, entrepreneurs, banks, retailers, labor market/unions, aggregation/equilibrium, monetary policy, exogenous processes, and auxiliary variables.
- Confirmed 13 exogenous innovations: `e_A_e`, `e_eps_K_b`, `e_j`, `e_l`, `e_me`, `e_mi`, `e_mk_be`, `e_mk_bh`, `e_mk_d`, `e_r_ib`, `e_qk`, `e_y`, and `e_z`.
- Confirmed implementation variables use log storage and `exp(...)` equations. The derivation records that as implementation convention only.
- Dynare was not run.

## Deferred Issues

- Source-level check the exact capital-producer Tobin's q condition.
- Source-level check price and wage Phillips curve coefficient normalizations and indexation terms.
- Decide whether future review should archive a fully log-linear equation list or keep nonlinear constraints plus log-linear solution notes.
- Verify whether the bank-capital shock is best represented as a liability shock, a bank equity destruction shock, or both in future task packets.
- Runtime validation was intentionally not performed.

## Translation Status

- English derivation drafted first.
- Chinese derivation translated from the English core.
- Equation numbering `(F1)` through `(F27)` is preserved in both files.
