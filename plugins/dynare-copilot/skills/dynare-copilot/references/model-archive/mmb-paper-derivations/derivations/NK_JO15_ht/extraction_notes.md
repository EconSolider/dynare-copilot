# NK_JO15_ht Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row for `NK_JO15_ht` has `mineru_match_status=matched`, `mineru_match_score=1.0000`, and `model_title_match_score=1.0000`.
- Primary source title matches the model row: "Productivity Shocks and Monetary Policy in a Two-Country Model".
- Primary Markdown source: `raw/mmb_mineru/runs/nk_jo15_ht_nk_jo15_lt__productivity_shocks_and_monetary_policy_in_a_two_country_model__f031feec/full.md`.
- Raw PDF path exists: `raw/mmb_papers/Productivity Shocks and Monetary Policy in a Two-Country Model.pdf`.
- PDF body was not read. The Markdown source was sufficient for the first-pass derivation and no targeted formula check was unavoidable.

## Formula Quality

- Status is `needs_review`.
- The derivation uses the paper's household, firm, equilibrium, dynamics, policy-rule, and steady-state equations from the MinerU Markdown.
- The high-trade variant is separated by calibration rather than a distinct equation system: `\alpha=0.9`.
- OCR-sensitive formulas are marked in the derivation where exact transcription is less certain.
- Main concern: the paper source and Appendix D contain several damaged OCR fragments, especially in Appendix C/D and in the Calvo reset-price expressions.
- The CPI/PPI identities in the derivation omit the extra `+ r_t` and `+ r_t^{*}` terms that appear in the OCR text near paper Eq. (32), because the MMB implementation and Appendix D cross-check do not include those terms in the CPI inflation identities. This is a paper-code/OCR reconciliation choice and should be reviewed against the PDF if this entry is promoted beyond draft status.

## Implementation Cross-Check

- Optional file read as implementation cross-check only: `.agents/skills/dynare-copilot/references/examples/NK_JO15_ht_rep.mod`.
- Cross-check facts used:
  - Model is `model(linear)`.
  - Variant is "High level of trade" with `alpha=0.9`.
  - Endogenous variables and shocks match the reduced-form system in Appendix D.
  - The reported simulation shocks `xi_star` for a foreign productivity shock.
- No equation was treated as paper-side evidence solely because it appeared in the `.mod` file.

## Deferred Issues

- A future reviewer should check the Calvo reset-price equations against the raw PDF because the Markdown has OCR ambiguity around foreign-output notation and overloaded `Q`.
- A future reviewer should check paper Eq. (32) against the PDF to confirm whether the `+ r_t` terms in the OCR text are genuine or OCR contamination; the implementation cross-check points to omission.
- Runtime validation was not performed; no Dynare `steady`, `check`, or IRF run was executed.
- The entry has not been merged into `catalog.csv` or `status.csv` because this task explicitly restricted edits to the model folder.

## Translation Status

- English derivation was drafted first.
- Chinese derivation was created afterward as a translation of the English core.
- Equation numbers `(F1)` through `(F24)` are preserved in both files.
- File paths, model ID, DOI, and `needs_review` markers are preserved.
