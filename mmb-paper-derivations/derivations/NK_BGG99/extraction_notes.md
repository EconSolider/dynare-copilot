# NK_BGG99 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row for `NK_BGG99` has `mineru_match_status=matched`, `mineru_match_score=1.0000`, `model_title_match_score=1.0000`, and no `model_match_notes`.
- Primary Markdown: `raw/mmb_mineru/runs/nk_bgg99_nk_bgg99al__the_financial_accelerator_in_a_quantitative_business__e6291ccb/full.md`.
- Raw PDF path exists: `raw/mmb_papers/The financial accelerator in a quantitative business.pdf`.
- No appendix normalization file exists at `docs/mmb_appendix_full_normalizations/NK_BGG99.md`.
- Implementation cross-check exists at `.agents/skills/dynare-copilot/references/examples/NK_BGG99_rep.mod`.

## Formula Quality

- Status: `needs_review`.
- The OCR Markdown includes the main source equations in Sections 3-4 and Appendices A-B.
- The paper presents the computational macro model in log-linearized form and explicitly uses ellipses/second-order terms in several equations. Those omitted terms were not invented.
- The extracted nonlinear contract equations use the appendix notation for \(\Gamma(\bar\omega)\), \(\mu G(\bar\omega)\), \(s=R^k/R\), and \(QK/N=\psi(s)\).
- The final-goods resource constraint includes monitoring costs. Formula-level OCR should be reviewed before promoting the entry beyond first pass.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/NK_BGG99_rep.mod` was used only as `implementation_cross_check`.
- The implementation uses `model(linear)`.
- The implementation variables include `cH`, `hH`, `piH`, `rH`, `r_nH`, `qH`, `kH`, `nH`, `r_kH`, `yH`, `xH`, `iH`, `aH`, `c_eH`, `gH`, `pi_t1H`, and `premiumH`.
- The implementation shocks are `e_a`, `e_g`, and `e_rn`.
- The implementation uses lagged capital in production/return equations and a helper variable `pi_t1H` for Phillips-curve timing.

## Deferred Issues

- Reconcile the paper's appendix contract calibration with the implementation formulas for `GAMMA_WBAR`, `NY`, `DY`, and `CY`.
- Review OCR for the monitoring-cost term in the resource constraint and the \(\phi_t^v\), \(\phi_t^{c^e}\), and \(\phi_t^n\) terms.
- Confirm whether the archive should include the investment-delay extension for a separate variant; this first pass treats `NK_BGG99` as the baseline one-sector implementation.
- No Dynare runtime validation was performed.

## Translation Status

- English derivation was drafted first.
- Chinese derivation is a direct translation of the checked English draft.
- Equation numbers `(F1)` through `(F23)` are preserved in both versions.
