# EA_DKR11 Extraction Notes

Status: `needs_review`

## Source Match

- `raw/mmb_mineru/model_index.csv` row for `EA_DKR11` has `mineru_match_status=matched`, `mineru_match_score=1.0000`, and `model_title_match_score=1.0000`.
- First 80 Markdown lines were checked. Line 1 reports `Macroeconomic Propagation under Different Regulatory Regimes: Evidence from an Estimated DSGE Model for the Euro Area`; line 3 reports Matthieu Darracq Pariès, Christoffer Kok Sørensen, and Diego Rodriguez-Palenzuela.
- No title/author mismatch was detected.
- Raw PDF path exists and hash was recorded. The PDF body was not opened.
- No appendix normalization file exists at `docs/mmb_appendix_full_normalizations/EA_DKR11.md`.

## Formula Quality

- The OCR Markdown contains the main model description and a substantial set of displayed equations for household programs, borrower and entrepreneur default contracts, production, wholesale bank capital requirements, retail interest-rate setting, policy rules, and calibration/steady-state targets.
- The paper does not provide one compact appendix-style list of all model FOCs. The derivation therefore records a first-pass structural map and keeps compacted terms at `needs_review`.
- The following blocks need formula-level review before promotion:
  - saver and borrower habit-adjusted marginal utility terms;
  - borrower and entrepreneur modified Euler equations with external finance premia;
  - entrepreneur capital Euler equations and collateral-premium terms;
  - four wage-setting blocks summarized by one generic Calvo wage equation;
  - full retail rate recursion details for deposit, household-loan, and entrepreneur-loan branches;
  - risk-sensitive Basel II capital-requirement formulas and countercyclical capital-rule variant if a policy-regime-specific implementation is needed.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/EA_DKR11_rep.mod` exists and was read only as `implementation_cross_check`.
- The `.mod` confirms a nonlinear model with variables for saver and borrower consumption/housing, entrepreneur debt and collateral cutoffs, household and entrepreneur default functions, sectoral production, Calvo price and wage blocks, bank capital, loan/deposit rates, and the observed data series.
- The `.mod` also confirms shock-name families such as `E_A`, `E_A_D`, `E_B`, `E_G`, `E_H`, `E_R_D`, `E_R_L`, `E_R_L_E`, `E_SIG_HH`, `E_SIG`, `E_Bankcap`, and `E_R`.
- Information learned only from the `.mod` was not treated as paper-side mathematical evidence.

## Deferred Issues

- No Dynare run was performed.
- The entry was not promoted to `.agents/skills/dynare-copilot/references/model-archive/`.
- Formula-by-formula reconciliation to the full MMB implementation equation count is deferred.
- Steady-state logic is summarized from Appendix 2 and remains `needs_review`; the full implementation steady-state alias block was not adopted as source evidence.
- Shared `catalog.csv` and `status.csv` were not edited. Proposed rows are in `worker_report.json`.

## Translation Status

- English derivation was drafted first.
- Chinese derivation was translated from the English version.
- `(F#)` numbering was preserved in Chinese.
