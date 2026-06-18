# EA_QR14 Extraction Notes

Status: `needs_review`.

## Source Match

- `raw/mmb_mineru/model_index.csv` maps `EA_QR14` to "Monetary and Macroprudential Policy in an Estimated DSGE Model of the Euro Area" by Dominic Quint and Pau Rabanal.
- The first 80 lines of `raw/mmb_mineru/runs/ea_qr14__monetary_and_macroprudential_policy_in_an_estimated_dsge_model_of_the_eu__78d59631/full.md` show the same title and the expected author names. The author line has OCR superscript artifacts (`Quinta`, `Rabanalb`) but no source mismatch.
- Raw PDF existence and SHA256 were recorded. The PDF body was not read, per task rule.
- No `docs/mmb_appendix_full_normalizations/EA_QR14.md` file exists.

## Formula Quality

- Appendix 2 in the Markdown contains a usable linearized condition list, including home and foreign country blocks, euro-area variables, policy rules, and shock processes.
- Equations involving mortgage default derivatives and financial-intermediary participation constraints are marked `needs_review` because OCR-sensitive subscripts and derivative terms can change the model.
- The Taylor rule is marked `needs_review`: the OCR/published appendix line around equation (93) repeats an inflation coefficient where the implementation and economic structure indicate an output-growth coefficient.
- The derivation records a compact source-backed system rather than every foreign-country equation separately. The foreign block is represented by the symmetric mapping (F32), while key open-economy and euro-area equations are explicit.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/EA_QR14_rep.mod` exists and was used only to check variable names, shock names, timing, policy rule structure, and steady-state initialization.
- The `.mod` implements a nonlinear exponentiated stationary model and uses first-order simulation. This differs in presentation from the paper appendix, which lists linearized conditions.
- The `.mod` confirms the model has saver and borrower blocks in both countries, housing stock laws with lagged investment, credit-to-GDP macroprudential rules, international premium shock, risk shocks, preference shocks, sectoral technology shocks, and a common unit-root technology shock.

## Deferred Issues

- Source-level PDF formula checks remain needed for the financial derivatives in (F8), (F9), (F12), and (F13).
- The exact printed Taylor-rule coefficient in (F36) should be checked against the PDF before promotion beyond first pass.
- Nonlinear steady-state derivation was not reconstructed from the paper; the entry records the linearized zero-deviation steady state and the implementation's initialization constants as cross-check evidence only.
- Dynare runtime validation was not performed.

## Translation Status

- English derivation was drafted first.
- Chinese derivation was translated from the English version and preserves section order, equation numbering, file paths, model id, DOI, and `needs_review` markers.
