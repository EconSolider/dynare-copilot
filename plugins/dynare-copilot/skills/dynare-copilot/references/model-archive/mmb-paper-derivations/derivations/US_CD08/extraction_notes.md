# US_CD08 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row for `US_CD08` has `mineru_match_status=matched`, `mineru_match_score=1.0000`, `model_title_match_score=1.0000`, and no `model_match_notes`.
- Primary Markdown: `raw/mmb_mineru/runs/us_cd08__the_financial_accelerator_in_an_estimated_new_keynesian_model__a324933c/full.md`.
- Raw PDF path exists: `raw/mmb_papers/The financial accelerator in an estimated New Keynesian model.pdf`.
- No appendix normalization file exists at `docs/mmb_appendix_full_normalizations/US_CD08.md`.
- Implementation cross-check exists at `.agents/skills/dynare-copilot/references/examples/US_CD08_rep.mod`.

## Formula Quality

- Status: `needs_review`.
- The OCR Markdown includes the paper's model text plus Appendices A-C. Appendix C provides the log-linearized equilibrium system that aligns most directly with the MMB `model(linear)` implementation.
- The source uses both nonlinear variables and log deviations; the derivation records both, with the archive form classified as log-linearized.
- The raw PDF body was not opened. Formula-level review against the PDF remains deferred.
- The implementation cross-check contains `eta=1.315` even though `eta` is omitted from its `parameters` declaration header; this is recorded as an implementation cross-check observation, not a paper-side source issue.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/US_CD08_rep.mod` was used only as `implementation_cross_check`.
- The implementation uses `model(linear)`.
- The implementation variables are `lambda`, `c`, `b`, `m`, `e`, `r`, `h`, `w`, `y`, `k`, `a`, `i`, `cost`, `z`, `mu`, `pi`, `q`, `x`, `f`, `n`, and `rp`.
- The implementation shocks are `e_r`, `u_x`, `u_a`, `u_e`, and `u_b`.
- The implementation shifts paper timing so production uses lagged capital `k(-1)`; this matches the archive timing note.

## Deferred Issues

- Review the OCR formulas against the raw PDF before promoting beyond `needs_review`.
- Reconcile the paper's nonlinear capital timing $k_{t+1}$ with the implementation's shifted linear timing equation one more time during review.
- Check whether the implementation's omitted `eta` parameter declaration is a known Rep-MMB transcription issue.
- Runtime validation was intentionally not performed; no Dynare commands were run.
- Shared `catalog.csv` and `status.csv` were intentionally not edited for this task; proposed rows are in `worker_report.json`.

## Translation Status

- English derivation was drafted first.
- Chinese derivation is a direct translation of the English draft.
- Equation numbers `(F1)` through `(F39)` are preserved in both versions.
