# NK_MM10 Extraction Notes

## Source Match

- Model index row: `raw/mmb_mineru/model_index.csv`, `model_id=NK_MM10`.
- Primary source Markdown: `raw/mmb_mineru/runs/nk_mm10__the_role_of_bank_capital_in_the_propagation_of_shocks__6ca06dd0/full.md`.
- Raw PDF: `raw/mmb_papers/The role of bank capital in the propagation of shocks.pdf`.
- MinerU run id: `6ca06dd0-c999-4627-9268-920fc7c8800c`.
- The first Markdown lines show the expected title and authors, with only accent/OCR artifacts in the author line.
- No `docs/mmb_appendix_full_normalizations/NK_MM10.md` file exists.

## Formula Quality

Status: `needs_review`.

Core equations (1)-(57) are mostly readable in MinerU Markdown. The following items should receive targeted PDF-level review before promoting the entry beyond first pass:

- Production equation and factor-price FOCs: OCR corrupts some exponent placements in equations (4), (7), (9), and (10). The archive uses the economically standard Cobb-Douglas normalization implied by surrounding text and by the implementation cross-check.
- Reset-price equation (13): the OCR shows a negative denominator convention in the markup term. The archive uses the standard positive markup form and marks it `needs_review`.
- Wage reset expression: the paper-side OCR is readable only as an infinite-sum expression with several sign and typography artifacts. The implementation uses recursive helper variables `wtilde`, `numw`, and `denw`; those were used only as implementation cross-check evidence.
- Capital-asset ratio equation (27): the expanded expression is badly OCR-corrupted. The archive records the clean definition `kappa_t=a_t/(a_t+d_t)` and the implementation ratio `CA=A/((1+mu)I-N)`, but does not claim the expanded expression has been source-checked.
- Equation (F16) should be checked carefully against the PDF because the source equation (25) has a nested product in the denominator; the first-pass archive keeps the same economic content but may need parenthesis normalization.

## Implementation Cross-Check

The file `.agents/skills/dynare-copilot/references/examples/NK_MM10_rep.mod` was read only as `implementation_cross_check`.

Useful cross-checks from the implementation:

- Endogenous variables include household, entrepreneur, and banker consumption (`ch`, `Ce`, `Cb`), net worth (`bigN`, `bigA`), inverse leverage (`G`), capital price (`q`), rental rate (`rk`), inflation (`infl`), deposit/policy rate (`Rd`), bank return (`Ra`), capital-asset ratio (`CA`), bank lending (`TL`), utilization (`u`), and stock variables (`K`, `Ke`, `Kb`).
- Exogenous innovations are `z_shk`, `mp_shk`, and `bk_shk`.
- Stock timing in the implementation uses lagged total and sectoral capital for production and net-worth accumulation.
- The implementation includes an exogenous bank-capital shock through `lbk` in the bank net-worth equation.
- The implementation computes a steady state internally, but this archive entry did not run Dynare and did not validate those calculations.

## Deferred Issues

- No raw PDF body was read; only existence and SHA256 were recorded.
- No runtime validation, residual check, steady-state check, BK check, or IRF reproduction was performed.
- The English and Chinese derivations are first-pass archive notes, not a reviewed runnable model implementation.
- The full capital-adequacy expression and wage/price recursions should be source-checked before status is raised from `needs_review`.

## Translation Status

- English derivation written first.
- Chinese derivation translated from the English structure.
- Equation numbers and formulas are preserved across the two files.
