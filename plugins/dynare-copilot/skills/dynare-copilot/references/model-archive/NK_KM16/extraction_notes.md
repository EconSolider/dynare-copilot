# NK_KM16 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` maps `NK_KM16` to "Public Debt and Changing Inflation Targets" with `mineru_match_score=1.0000` and `model_title_match_score=1.0000`.
- MinerU run id: `e715ef78-2669-4f27-8813-b62be9614e4e`.
- Primary Markdown used: `raw/mmb_mineru/runs/nk_km16__public_debt_and_changing_inflation_targets__e715ef78/full.md`.
- Raw PDF path exists: `raw/mmb_papers/Public Debt and Changing Inflation Targets.pdf`.
- PDF body was not read. No targeted PDF formula check was performed.
- No appendix normalization file exists at `docs/mmb_appendix_full_normalizations/NK_KM16.md`.

## Formula Quality

- Section II of the MinerU Markdown contains the core paper equations (1)-(20), including long-term debt evolution, household FOCs, Calvo recursions, fiscal rule, monetary rule, signal extraction, and Kalman-filter updating.
- The long-term bond Euler equation is marked `needs_review` because OCR damage appears around the capital-loss term in the explanatory text following equation (4).
- The Kalman gain expression is not fully reproduced in the derivation because the Markdown line is compressed and riskier than the surrounding update equations. The target update, perceived shock, and forecast equations are included and marked where appropriate.
- The zero-lower-bound preference-shock extension is noted but excluded from the baseline derivation.

## Implementation Cross-Check

- Cross-check file: `.agents/skills/dynare-copilot/references/examples/NK_KM16_rep.mod`.
- Used only for implementation coverage, timing, and variable-name checks.
- The example confirms:
  - separate natural/flexible-price and sticky-price blocks;
  - variables `D`, `Dnew`, `i_D`, `i_Dnew`, `mu`, `tau`, `PIESTAR`, `pistar`, `Disp`, `Z1`, and `Z2`;
  - exogenous innovations `epsi_D`, `eta_PIESTAR`, `eta_r`, and `epsi_G`;
  - steady-state assignments for debt, money, long-term interest rates, tax rates, and Calvo auxiliaries.
- Equations in the derivation remain paper-side extractions; example `.mod` content was not treated as a mathematical source.

## Deferred Issues

- Full source-level equation audit against the PDF remains deferred.
- Runtime validation in Dynare remains deferred.
- The natural-rate block behind $`Y_t^n`$ should be reviewed if this derivation is promoted into a runnable model archive entry.
- Shared `catalog.csv` and `status.csv` were intentionally not edited because this task restricted ownership to `mmb-paper-derivations/derivations/NK_KM16/`.

## Translation Status

- English derivation was drafted first.
- Chinese derivation was produced as a translation of the English derivation.
- Equation labels `(F1)` through `(F26)` are intended to match exactly between English and Chinese files.
