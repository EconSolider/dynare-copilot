# US_IR15 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row for `US_IR15` has `mineru_match_status=matched`, `mineru_match_score=1.0000`, `model_title_match_score=1.0000`, and no `model_match_notes`.
- First 80 Markdown lines show the expected title, "Monetary policy, bond risk premia, and the economy", and Peter N. Ireland as author.
- Primary Markdown: `raw/mmb_mineru/runs/us_ir15__monetary_policy_bond_risk_premia_and_the_economy__eb56aade/full.md`.
- Raw PDF path exists: `raw/mmb_papers/Monetary policy, bond risk premia, and the economy.pdf`.
- No appendix normalization file exists at `docs/mmb_appendix_full_normalizations/US_IR15.md`.

## Extraction Scope

- English derivation was drafted first using the required eight-section structure.
- Chinese derivation is a direct translation of the English core and preserves `(F#)` numbering, file paths, DOI values, model ID, and `needs_review` markers.
- The source model is an empirical affine term-structure/state-space model, not a household-firm DSGE model. Therefore section 2 records the pricing-kernel/no-arbitrage object rather than invented household or firm optimization problems.
- The `.mod` file `.agents/skills/dynare-copilot/references/examples/US_IR15_rep.mod` was read only as `implementation_cross_check`.

## Formula Quality

- Overall formula status: `needs_review`.
- MinerU Markdown captured the main-text model equations (1)-(20): inflation-target process, policy rule, inflation/output/risk-factor equations, compact state transition, pricing kernel, risk prices, bond-price and yield recursions, risk-premium definition, and measurement equation.
- OCR anomalies were visible in the Markdown, especially around Greek nu/v notation, the phrase around the sign of $`\rho_\nu`$, and some matrix/vector typography. The derivation uses normalized notation but keeps the status as first-pass `needs_review`.
- The paper points to supplementary appendix parts for the construction of the compact matrices, bond-pricing recursion derivation, steady-state yield matching, and construction of `U` and `V`. No local appendix normalization was present.
- The PDF body was not opened because the Markdown was sufficient for a first-pass `needs_review` extraction and the task contract says not to read the PDF body by default.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/US_IR15_rep.mod` exists and was read only as `implementation_cross_check`.
- The `.mod` confirms `model(linear)` and state variables `g_r`, `g_pi`, `g_y`, `tau`, and `v`.
- The `.mod` uses observables/derived variables for yields and premiums at 4, 8, 12, 16, and 20 quarters: `y_4`, `y_8`, `y_12`, `y_16`, `y_20`, `P_y_*`, and annualized `*_a` variables.
- The `.mod` uses shocks `epsilon_r`, `epsilon_pi`, `epsilon_y`, `epsilon_tau`, `epsilon_v`, plus measurement errors `eta_4`, `eta_8`, and `eta_16`.
- The `.mod` implements precomputed loading matrices (`Uij`, `Pij`, `Qij`, `Sij`) rather than deriving the affine recursions inside the Dynare model block. This was recorded as an implementation convention.
- Dynare was not run.

## Deferred Issues

- Source-level review should check equations (F13)-(F20) against the PDF or supplementary appendix before moving beyond `needs_review`.
- The local archive lacks the supplementary appendix, so exact formulas for constructing `U`, `V`, and the steady-state long-yield matching remain deferred.
- Review the notation mapping between paper $`\nu`$ and implementation `v`, especially where OCR renders `v`/`\nu` inconsistently.
- Runtime validation, residual checks, BK checks, IRF checks, and promotion to the runnable skill archive were not performed.

## Translation Status

- English derivation completed first.
- Chinese translation completed second.
- English and Chinese `(F#)` counts match in validation.
