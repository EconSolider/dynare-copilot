# CL_MS07 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row for `CL_MS07` is a clean match: `mineru_match_status=matched`, `mineru_match_score=1.0000`, `model_title_match_score=1.0000`.
- First-page Markdown sniff confirms the expected title, Central Bank of Chile Working Paper 457, and authors Juan Pablo Medina and Claudio Soto.
- Raw PDF path exists and is recorded for provenance. The PDF body was not opened.
- No appendix normalization file exists at `docs/mmb_appendix_full_normalizations/CL_MS07.md`.

## Formula Quality

- The Markdown source includes the nonlinear model economy section and Appendix A with the full log-linearized model.
- Appendix A has visible OCR defects in some equation numbers and long lines, for example labels rendered as `(1 6)` or `(1 7)` and line-wrapped fiscal/external-account equations.
- The first-pass derivation uses the readable log-linear appendix as the main mathematical surface and marks long fiscal/external-account equations as `needs_review`.
- Equations (F24), (F26), and (F38) are intentionally abbreviated with `\cdots` and require human/PDF formula review before promotion beyond first-pass status.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/CL_MS07_rep.mod` exists and was read only as `implementation_cross_check`.
- Cross-check confirms `model(linear)`, the principal endogenous variable names, fourteen exogenous innovations, the two monetary-policy regimes, capital timing with `k_hat(-1)`, and the flexible-price companion block.
- The `.mod` file was not treated as paper-side mathematical evidence.

## Deferred Issues

- Full reconstruction of the long fiscal structural-balance, fiscal-asset, and balance-of-payments equations should be checked against the PDF or a cleaner appendix source.
- Steady-state logic is summarized from calibration text and the replication file; a paper-side analytical steady-state derivation was not reconstructed.
- Runtime validation, Dynare residual checks, Blanchard-Kahn checks, and IRF verification are out of scope for this entry.

## Translation Status

- `CL_MS07_derivation.zh.md` is a translation of the checked English first-pass file.
- Equation numbers and formulas were preserved between English and Chinese versions.
