# NK_FNL23 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row for `NK_FNL23` has `mineru_match_status=matched`, `mineru_match_score=1.0000`, and `model_title_match_score=1.0000`.
- Primary Markdown: `raw/mmb_mineru/runs/nk_fnl23__towards_a_green_economy_the_role_of_the_central_bank_s_asset_purchases__2fa2f5c9/full.md`.
- Raw PDF path exists and was checked for provenance only: `raw/mmb_papers/Towards a Green Economy- The Role of the Central Bank's Asset Purchases.pdf`.
- No `docs/mmb_appendix_full_normalizations/NK_FNL23.md` file exists.

## Formula Quality

- The main model section and Appendix A jointly expose the household, production, environmental, policy, market-clearing, and steady-state equations.
- Appendix A states a 29-equation detrended system. The archive derivation adds two paper-side statistical identities, carbon price and euro-area pollution, as (F29)-(F30), and TFP as (F31).
- Marked `needs_review`:
  - (F27): MinerU OCR omits or distorts the time subscript on central-bank brown bond holdings in the brown bond market-clearing equation.
  - (F28): MinerU OCR renders the central-bank balance-sheet right-hand side ambiguously; the paper text supports real reserves `re_t`, while OCR text is noisy.
- No raw PDF body was read. A targeted PDF check may be useful only for the `needs_review` balance-sheet and brown-bond equations.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/NK_FNL23_rep.mod` exists and was used only as an implementation cross-check.
- The `.mod` confirms core variable coverage: household marginal utility, green and brown rates, sectoral capital/labor/output, pollution, abatement, Tobin's Q, resource constraint, central-bank bond holdings, and spread.
- The `.mod` adds simulation conveniences or implementation choices not treated as paper-side source equations here: investment-specific shocks, government-spending shocks, monetary-policy shocks, and a fixed-zero abatement setting in the shown business-cycle code path.

## Deferred Issues

- Runtime validation was not performed.
- The derivation should receive a targeted source review against the PDF for the two `needs_review` policy/bond equations before being promoted beyond first-pass archive status.
- The transition policy paths for \(\tau_t\) and reserves are scenario-specific and are not fully encoded as stationary stochastic processes in the paper appendix.

## Translation Status

- English derivation drafted first.
- Chinese derivation translated from the English core.
- F-number parity checked: English and Chinese both contain (F1)-(F31).
