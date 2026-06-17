# EA_PV15 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row for `EA_PV15` points to one MinerU run: `e624b564-2ce5-4d2a-bd46-e55027276842`.
- First 80 Markdown lines were sniffed before extraction. The title and authors match Poutineau and Vermandel's JEDC 2015 paper.
- `raw_pdf_path` exists and is recorded for provenance. The PDF body was not opened.
- No `docs/mmb_appendix_full_normalizations/EA_PV15.md` file exists.

## Extraction Scope

- The English derivation was drafted first from the MinerU Markdown.
- The Chinese derivation is a translation of the English draft and preserves F-number order and formulas.
- `.agents/skills/dynare-copilot/references/examples/EA_PV15_rep.mod` was used only as `implementation_cross_check`, mainly to confirm variable names, `model(linear)`, shock naming, and timing conventions.
- Shared `catalog.csv` and `status.csv` were not edited by request.

## Formula Quality

- Status remains `needs_review`.
- MinerU OCR is usable for the main model sections but has visible noise in several formula neighborhoods.
- The following equation groups were intentionally marked `needs_review` in the derivation:
  - sticky loan-rate reset and log-linear rate equation;
  - household Euler equation;
  - sticky wage condition;
  - sticky price reset condition;
  - expected return on capital;
  - home resource constraint;
  - steady-state reconstruction.
- The Pareto appendix was used only through the Markdown extract around Eq. (34); no PDF body was opened for targeted checks.

## Implementation Cross-Check

- The `.mod` implementation declares `model(linear)`.
- Core/periphery suffixes are `_h` and `_f`.
- Capital timing in the implementation uses utilized lagged capital: `ku_i = k_i(-1) + u_i`.
- The implementation includes country shocks plus common shocks for productivity, spending, preference, net worth, external finance premium, bank rate markup, wage markup, bank liabilities, and ECB monetary policy.
- One steady-state discrepancy is deferred: the paper table reports bank capital to lending ratio as 0.10, while the implementation sets `BKss = 0.11*Lss`.

## Deferred Issues

- Check formulas marked `needs_review` against the PDF before promoting beyond first pass.
- Reconcile exact nonlinear-to-linear transformation of the loan-rate and wage/price Calvo blocks.
- Verify whether the English derivation should include more of the final-goods consumption/investment CES price indexes as separate F-numbered equations.
- Runtime validation was not performed.

## Translation Status

- Chinese file created after the English draft.
- English and Chinese F-number counts are intended to match exactly.
