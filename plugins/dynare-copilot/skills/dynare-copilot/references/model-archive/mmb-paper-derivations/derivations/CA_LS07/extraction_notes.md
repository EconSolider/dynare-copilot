# CA_LS07 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row for `CA_LS07` has `mineru_match_status=matched`, `mineru_match_score=1.0000`, `primary_source_title="Do central banks respond to exchange rate movements? A structural investigation"`, and `model_title_match_score=1.0000`.
- First-page Markdown sniff matches the expected title and authors Thomas A. Lubik and Frank Schorfheide.
- Raw PDF path exists: `raw/mmb_papers/Do central banks respond to exchange rate movements? A structural investigation.pdf`.
- PDF body was not opened. The Markdown source contains legible equations for the relevant first-pass model block.

## Formula Quality

- First-pass status: `needs_review`.
- Equations (F1)-(F5) are based on the visible Section 2 Markdown equations.
- Equations (F6)-(F12) are supported by the paper text around the exogenous-process description and by the implementation cross-check for exact implemented variable coverage.
- The paper's fully structural terms-of-trade relation is recorded but not numbered as an active model equation because the paper states that the estimated specification replaces it with an exogenous terms-of-trade growth process.
- OCR uncertainty remains around typography for Greek letters and starred variables, especially `tau`, `rho_y*`, and `rho_pi*`; the formulas should be checked against the PDF or author code before review promotion.

## Implementation Cross-Check

- Cross-check file exists: `.agents/skills/dynare-copilot/references/examples/CA_LS07_rep.mod`.
- Used only as `implementation_cross_check`.
- Confirms `model(linear)`, endogenous variables `y R pi z deltaq deltay_star y_bar y_star deltae pi_star inflationq interest`, exogenous shocks `epsR epsq epsy_star epspi_star epsz`, and Canadian replication parameter values.
- No Dynare execution was performed.

## Deferred Issues

- Primitive household utility, production, and price-setting problems are not printed in the local Markdown; the derivation therefore records reduced-form equilibrium equations rather than a full primitive derivation.
- The published PDF or original author code should be used for a source-level formula audit before changing status away from `needs_review`.
- Runtime validation, determinacy checks, and IRF comparison are explicitly deferred.

## Translation Status

- `CA_LS07_derivation.zh.md` is a translation of the checked English first-pass file.
- Equation numbers and formulas were preserved across English and Chinese versions.
