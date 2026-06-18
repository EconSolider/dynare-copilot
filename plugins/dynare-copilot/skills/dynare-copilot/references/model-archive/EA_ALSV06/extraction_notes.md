# EA_ALSV06 Extraction Notes

Status: `needs_review`

## Source Match

- `raw/mmb_mineru/model_index.csv` row has `mineru_match_status=matched`, `mineru_match_score=1.0000`, and `model_title_match_score=1.0000`.
- First 80 Markdown lines match the expected paper title and authors. The only observed mismatch is OCR accent damage in `Andre´s` and `Valle´s`.
- `raw_pdf_path` exists at `raw/mmb_papers/Money in an estimated business cycle model of the euro area.pdf`; per instruction, the PDF body was not read.
- No appendix normalization exists at `docs/mmb_appendix_full_normalizations/EA_ALSV06.md`.

## Formula Quality

- The source Markdown clearly contains the household problem, budget constraint, production function, policy rule, and the log-linear equilibrium block.
- The archive derivation focuses on the `EA_ALSV06` Rep-MMB variant: separable preferences, CRRA specification, habits, and `model(linear)`.
- Paper equations (15)-(17) are used for the CRRA/separable IS equation, money-demand equation, and marginal-cost equation. Paper equations (7)-(13) supply the policy rule, money-growth identity, Phillips curve, and AR(1) shocks.
- `needs_review`: the velocity/money-demand shock term in paper equation (16) appears with a positive sign in OCR, while the Rep-MMB `.mod` writes the corresponding `e` term with the opposite sign. This may be a shock-definition convention, but it should be checked against the PDF or author source before promotion.
- `needs_review`: equation normalization changed OCR spacing and expectation notation but did not attempt a full PDF-level proof check.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/EA_ALSV06_rep.mod` exists and was read only as `implementation_cross_check`.
- The `.mod` declares endogenous variables `y m r mu pi mc a e z`, exogenous shocks `epsa epse epsz epsr`, and uses `model(linear)`.
- The `.mod` comments identify the variant as "Working Paper, separable preferences, CRRA specification and habits".
- The `.mod` confirms the same core block: IS relation, money demand, interest-rate rule, money-growth identity, Phillips curve, marginal cost, and three AR(1) state processes.
- Dynare was not run.

## Deferred Issues

- Source-level formula check against the PDF is still needed, especially for the money-demand shock sign convention and any typesetting ambiguity in equations (15)-(17).
- The English/Chinese derivations are first-pass archive drafts and should remain `needs_review`.
- No shared `catalog.csv` or `status.csv` edits were made. Proposed rows are in `worker_report.json`.

## Translation Status

- English derivation was drafted first.
- Chinese derivation was translated from the English derivation and preserves `(F#)` numbering and formulas.
