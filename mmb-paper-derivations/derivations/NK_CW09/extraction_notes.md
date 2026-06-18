# NK_CW09 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row `NK_CW09` reports `mineru_match_status=matched`, `mineru_match_score=1.0000`, and `model_title_match_score=1.0000`.
- Primary source title: "Credit frictions and optimal monetary policy 2009".
- Primary full Markdown: `raw/mmb_mineru/runs/nk_cw09__credit_frictions_and_optimal_monetary_policy__763a743f/full.md`.
- Raw PDF path exists: `raw/mmb_papers/Credit frictions and optimal monetary policy 2009.pdf`.
- Appendix normalization file was not present at `docs/mmb_appendix_full_normalizations/NK_CW09.md`.

## Formula Quality

- Status: `needs_review`.
- The main Section 1 structural equations are readable enough for a first-pass derivation: household wealth, type Euler equations, aggregate demand, intermediation technology, spread identity, debt dynamics, labor supply, wage bill, and Calvo summary block.
- Several equations in the Section 2 log-linear block contain OCR damage around hatted interest-rate notation. I normalized these to economically standard notation in the derivation and marked the affected IS relation as `needs_review`.
- The Calvo functions \(\Pi(Z_t)\), \(G(\cdot)\), \(g(\cdot)\), and \(h(\Delta_{t-1},\Pi_t)\) are referenced in the main text as Appendix definitions. They were not expanded in this first pass.
- The full function \(B(Y_t,\lambda_t^b,\lambda_t^s,\Delta_t;\tilde{\xi}_t)\) in the aggregate borrowing law is also delegated to the Appendix and should be checked before runnable implementation.

## Implementation Cross-Check

- Cross-check file: `.agents/skills/dynare-copilot/references/examples/NK_CW09_rep.mod`.
- Used only to check variable names, shocks, calibration objects, and timing conventions.
- The implementation uses level variables such as `lambda_b`, `lambda_s`, `Pi`, `Y`, `K`, `F`, `Delta`, `b`, `G`, `omega`, `Z`, `b_g`, and auxiliary hatted variables for deviations/annualizations.
- The implementation includes eleven exogenous shocks: `e_C_bar_s`, `e_C_bar_b`, `e_G`, `e_H_bar`, `e_mu_w`, `e_tau`, `e_epsilon_m`, `e_Xi_tilde`, `e_chi_tilde`, `e_Z`, and `e_b_g`.
- Some implementation equations compress the paper's Calvo and debt-recursion blocks into MMB-specific variables (`K`, `F`, `B`, `lambda_tilde`, `Lambda`). These were not treated as paper-side derivations unless the paper text supported them directly.

## Deferred Issues

- Check the raw PDF or paper Appendix for the exact definitions of Calvo recursion functions and price-dispersion law if a runnable model is built later.
- Check Appendix definitions for the aggregate private debt term \(B(\cdot)\).
- Reconcile the paper's notation for technology/productivity \(A_t\) with the MMB implementation variable `Z`.
- Confirm whether the MMB `K` and `F` variables are Calvo auxiliary recursions rather than physical capital; the model is a consumption/output model without investment capital in the main paper exposition.
- Steady-state derivation needs a source-level Appendix pass before marking anything above first-pass `needs_review`.
- Runtime validation, Dynare residual checks, BK checks, and IRF comparison were not performed.

## Translation Status

- English derivation drafted first.
- Chinese derivation translated second from the English core.
- Both files preserve eight required sections and equation labels `(F1)` through `(F20)`.
