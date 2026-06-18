# NK_GM05 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row for `NK_GM05` has `mineru_match_status=matched`, `mineru_match_score=1.0000`, and `model_title_match_score=1.0000`.
- Primary source title exactly matches the paper title in the index: "Monetary policy and exchange rate volatility in a small open economy".
- Raw PDF path exists and was recorded for provenance. The PDF body was not read because the Markdown source was sufficient for the requested first-pass extraction.

## Formula Quality

- Main equilibrium equations in Sections 2-5 are readable in MinerU Markdown and support a log-linear archive entry.
- A few OCR fragments in Appendix A and Appendix B are noisy. The derivation uses those appendices only for steady-state and price-setting context, not for a full nonlinear implementation.
- The Calvo reset-price optimization problem is marked `needs_review` because the OCR compresses the demand argument in the objective. The resulting NKPC is readable and was extracted from the main text and Appendix B.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/NK_GM05_rep.mod` exists and was used only as `implementation_cross_check`.
- The example confirms the MMB representation is `model(linear)` and uses endogenous variables `pih`, `x`, `y`, `ynat`, `rnat`, `r`, `s`, `pi`, `p`, `ph`, `e`, `ystar`, `a`, and `pistar`.
- The example fixes the active policy to strict domestic inflation targeting with `pih = 0`; DITR, CITR, PEG, and UIP alternatives are present as commented implementation choices.
- The example sets foreign inflation to zero (`pistar = 0`) and uses shocks `a_` and `ystar_`.

## Deferred Issues

- No Dynare runtime validation was performed; residual, steady-state, BK, equation-count, and IRF checks are deferred.
- The first-pass derivation keeps both paper-side policy alternatives and the active MMB DIT implementation distinction. Future review should decide whether to split policy regimes into separate variant entries for `NK_GM05`, `NK_GM05cpi`, and `NK_GM05ppi` if the archive later needs implementation-specific folders.
- A targeted PDF check is recommended before marking this entry reviewed, especially for Appendix B price-setting algebra and Appendix A steady-state uniqueness.

## Translation Status

- English derivation was drafted first.
- Chinese derivation was translated from the English derivation with the same eight section headings and matching equation numbers `(F1)` through `(F32)`.
