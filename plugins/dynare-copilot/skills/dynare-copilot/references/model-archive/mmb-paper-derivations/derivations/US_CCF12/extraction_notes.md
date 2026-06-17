# US_CCF12 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` maps `US_CCF12` to Chen, Curdia, and Ferrero (2012), "The Macroeconomic Effects of Large-scale Asset Purchase Programmes".
- `model_title_match_score`: `1.0000`.
- MinerU run id: `2865b07c-427c-46bd-b58b-d89d31d5cf2b`.
- Primary Markdown: `raw/mmb_mineru/runs/us_ccf12__the_macroeconomic_effects_of_large_scale_asset_purchase_programmes__2865b07c/full.md`.
- Raw PDF exists at `raw/mmb_papers/The Macroeconomic Effects of Large-scale Asset Purchase Programmes.pdf`.

## Formula Quality

- Status: `needs_review`.
- The paper body contains equations for household utility and budget constraints, labor demand and wage index, capital accumulation, final-good demand, production, marginal cost, monetary policy, government budget, long-debt supply, fiscal rule, bond-pricing equations, risk premium, transaction costs, resource constraint, and technology growth.
- The paper states that the normalized nonlinear equilibrium conditions, steady-state solution, and full log-linear approximation are in the online Technical Appendix.
- That online appendix was not present as `docs/mmb_appendix_full_normalizations/US_CCF12.md` and was not included in the MinerU Markdown. The derivation therefore does not claim reviewed coverage of Appendix C or Appendix D.
- Two recursive FOC blocks are marked `needs_review`: Calvo price-setting and Calvo wage-setting. The paper body gives the optimization problems, but not the recursive normalized equations.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/US_CCF12_rep.mod` exists and was read only as `implementation_cross_check`.
- The implementation identifies the model as linearized and uses `model(linear)`.
- The `.mod` comments map many linear equations to online Appendix D labels, including intermediate-goods production, capital, household Euler equations, wage setting, government debt, LSAP long-bond policy, risk premium, monetary policy, and the aggregate resource constraint.
- No equation in the derivation was treated as paper-side sourced solely because it appears in the `.mod`.
- Dynare was not run.

## Deferred Issues

- Add or parse the online Technical Appendix before marking this entry `reviewed_derivation`.
- Check the full normalized nonlinear equations, Appendix C steady state, and Appendix D log-linear equations against source material.
- Confirm whether the MMB implementation's `eps_m`-only active shock setting is a Rep-MMB simulation choice or the intended benchmark shock subset for this archive row.
- Review OCR artifacts in names containing Curdia, policy notation, and some footnote markers.

## Translation Status

- English derivation drafted first.
- Chinese derivation translated from the English version.
- Equation numbering `(F1)` through `(F24)` is preserved in both versions.
