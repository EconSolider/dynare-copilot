# HK_FP13 Extraction Notes

## Source Match

- `HK_FP13` maps to Funke and Paetz (2013), "Housing prices and the business cycle: An empirical application to Hong Kong".
- `raw/mmb_mineru/model_index.csv` reports `mineru_match_status=matched`, `mineru_match_score=1.0000`, `model_title_match_score=1.0000`, and no `model_match_notes`.
- Primary Markdown source: `raw/mmb_mineru/runs/hk_fp13__housing_prices_and_the_business_cycle_an_empirical_application_to_hong_k__d766767f/full.md`.
- Raw PDF path exists and was recorded for provenance only. The PDF body was not read because the Markdown source contained the model section and numbered equations.
- No `docs/mmb_appendix_full_normalizations/HK_FP13.md` file exists.

## Formula Quality

- The paper-side Markdown contains the main model equations from Section 3: household problems, borrower collateral constraint, saver risk-sharing, price and terms-of-trade identities, firm pricing, goods-market clearing, output aggregation, currency-board convention, and shock processes.
- Several OCR equations are marked `needs_review` in the derivations:
  - borrower housing Euler equation around the powers and expectation term;
  - borrower Euler equation where OCR alternates between `\mathcal E` and `\varepsilon`;
  - saver housing Euler equation where ratios are malformed;
  - saver foreign-bond Euler equation where exchange-rate notation is malformed.
- The source gives many conditions in nonlinear notation and then states that the complete model is log-linearized by first-order Taylor approximation. The archive entry therefore records both core nonlinear FOCs where available and log-linear market/shock equations where the paper provides them directly.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/HK_FP13_rep.mod` was used only as `implementation_cross_check`.
- The implementation confirms:
  - `model (linear)` form;
  - borrower/saver split (`c_b`, `c_s`, `d_b`, `d_s`, `b_b`, `psi`);
  - two-sector structure (`y_c`, `y_d`, `mc_c`, `mc_d`, `pi_c_h`, `pi_d_h`);
  - terms-of-trade and foreign blocks (`s_c`, `s_d`, `c_ast`, `i_d_ast`, `p_c_ast`, `p_d_ast`);
  - 13 exogenous innovations;
  - Rep-MMB active shock standard deviations for `epsd_s` and `epsd_b`.
- No equation was treated as paper-side source solely because it appears in the `.mod` file.

## Deferred Issues

- Source-level formula review against the raw PDF is still needed for the OCR-fragile Euler equations listed above.
- The steady-state section is based on the linear implementation and paper calibration discussion, not a full nonlinear steady-state derivation.
- Runtime validation was not performed: no Dynare `steady`, `check`, or simulation run was executed for this archive entry.
- A future implementation phase should verify the equation count against a runnable `.mod` replication and reconcile all OCR `needs_review` formulas.

## Translation Status

- English derivation was drafted first.
- Chinese derivation was translated from the English derivation.
- Both files preserve the same eight required section headings and 29 F-numbered conditions.
