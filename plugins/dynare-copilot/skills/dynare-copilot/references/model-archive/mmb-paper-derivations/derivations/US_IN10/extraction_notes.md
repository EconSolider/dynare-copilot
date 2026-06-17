# US_IN10 Extraction Notes

Status: `needs_review`

## Source Match

- `raw/mmb_mineru/model_index.csv` row for `US_IN10` has `mineru_match_status=matched`, `mineru_match_score=1.0000`, and `model_title_match_score=1.0000`.
- Primary Markdown title sniff matches the model row: "Housing Market Spillovers: Evidence from an Estimated DSGE Model".
- Raw PDF exists at `raw/mmb_papers/Housing market spillovers- Evidence from an estimated dsge model.pdf`.
- No `docs/mmb_appendix_full_normalizations/US_IN10.md` file exists.

## Formula Quality

- Appendix B gives the main extraction spine as equations (B1)-(B36), plus balanced-growth equations in Section I.E and shock laws in the main text.
- First-pass uncertainty is marked directly in the English and Chinese derivations as `needs_review`.
- The patient budget constraint in Appendix B appears to show `q_l h_t`; the main-text budget constraint and context indicate house price `q_t h_t`. The draft uses `q_t h_t` and marks this for review.
- The wage Phillips-curve slope definitions after (B29)-(B32) contain inconsistent OCR/notation around `theta_wc`, `theta_wh`, and prime notation. The draft keeps the intended four-sector/type wage equations but marks the issue.
- The adjustment-cost expression for `phi_t` is vulnerable to OCR line-break ambiguity. Before implementation, verify the multiplication by lagged capital and trend scaling against the PDF.
- The Appendix variable list after (B36) appears duplicated and malformed; the variable table therefore uses the equation system and `.mod` coverage as a cross-check.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/US_IN10_rep.mod` exists and was read only as `implementation_cross_check`.
- Cross-check confirms a large log-linearized/detrended implementation with variables for patient and impatient households, flexible-price/flexible-wage counterparts, housing and nonhousing capital, collateral multiplier, price/wage markups, and the nine exogenous innovations `eps_c`, `eps_e`, `eps_h`, `eps_j`, `eps_k`, `eps_p`, `eps_s`, `eps_t`, `eps_z`.
- Cross-check confirms stock timing: production uses lagged `kc`, `kh`, and housing accumulation uses lagged household housing stocks.
- Dynare was not run.

## Deferred Issues

- Build a PDF-checked implementation-ready steady-state map before writing any `.mod` from this derivation.
- Verify Appendix B equations (B1), (B29)-(B32), the wage-slope definitions, and the adjustment-cost formula at source/PDF level.
- Decide in a later implementation phase whether to archive the full sticky-price/wage system only or include the flexible-price/flexible-wage auxiliary block used for output-gap construction.
- Runtime validation, residual checks, steady-state checks, BK checks, and IRF comparisons are deferred.

## Translation Status

- English derivation was drafted first.
- Chinese derivation was translated second from the English draft.
- Equation numbering and formulas are intended to match exactly between English and Chinese versions.
