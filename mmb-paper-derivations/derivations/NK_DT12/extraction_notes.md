# NK_DT12 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row 57 for `NK_DT12` points to `raw/mmb_mineru/runs/nk_dt12__optimal_monetary_policy_in_a_model_of_the_credit_channel__286bd0e5/full.md`.
- First-page/metadata sniff matched the expected title and authors: "Optimal Monetary Policy in a Model of the Credit Channel"; Fiorella De Fiore and Oreste Tristani.
- `raw_pdf_path` exists at `raw/mmb_papers/Optimal Monetary Policy in a Model of the Credit Channel.pdf`. The PDF body was not opened because the Markdown was sufficient for a first-pass `needs_review` draft.
- `docs/mmb_appendix_full_normalizations/NK_DT12.md` does not exist.
- `.agents/skills/dynare-copilot/references/examples/NK_DT12_rep.mod` exists and was used only as `implementation_cross_check`.

## Formula Quality

- Overall formula quality: `needs_review`.
- The main-text equations for household budget/preferences, wholesale technology, financing constraint, labor-demand condition, costly-state-verification contract, spread, entrepreneurial consumption, reduced-form linear equilibrium, Taylor rule, welfare loss, and endogenous-internal-funds extension are readable in Markdown.
- The paper explicitly delegates the financial contract derivation, retail price setting, steady state, gap definitions, and welfare approximation details to online appendices. No local appendix normalization file is available for `NK_DT12`.
- The first-pass derivation therefore preserves the visible main-text equations and marks appendix-dependent Calvo recursions, coefficient definitions, and full steady-state solution as deferred.

## Implementation Cross-Check

- The Rep-MMB implementation confirms the main endogenous names: `cons_h`, `i_dep`, `infl`, `omeg_t`, `s_t`, `chi_t`, `thet1_t`, `thet2_t`, `y_t`, `spread`, `q_t`, `ygap`, `cons_e`, `mon_cost`, `Bankrupt`, `fo_t`, `ho_t`, `i_l`, `credit`, `stdoi_t`, `i_e`, `y_e`, `a_t`, `mu_t`, `pol_t`, and `tau_t`.
- The implementation includes Calvo recursion auxiliaries (`thet1_t`, `thet2_t`), financial-contract share terms (`fo_t`, `ho_t`), bankruptcy probability, credit, loan rate, and shocks to productivity, monitoring cost, policy, internal funds, and idiosyncratic-risk dispersion.
- No equation was copied from the `.mod` file as paper-side mathematical source evidence.

## Deferred Issues

- Recover or normalize online Appendices A-D and F before upgrading this entry from `needs_review`.
- PDF-check the exact appendix definitions of $\alpha_1$, $\alpha_2$, $\delta_1$, $\xi_{1,t}$, $\xi_{2,t}$, $\xi_{3,t}$, and $\bar{\kappa}$.
- PDF-check or appendix-check the Calvo reset-price recursion corresponding to `thet1_t` and `thet2_t`.
- Decide whether implementation shocks to monitoring cost and idiosyncratic-risk dispersion should be documented as benchmark paper-side shocks or MMB implementation extensions.
- Runtime validation, Dynare equation count, steady-state residuals, BK checks, and IRF checks were not performed.

## Translation Status

- `NK_DT12_derivation.zh.md` is a translation of the English draft.
- Equation numbers `(F1)` through `(F35)` and LaTeX formulas were preserved.
