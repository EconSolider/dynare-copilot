# G2_SIGMA08 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row matched `G2_SIGMA08` to "Trade adjustment and the composition of trade" with `mineru_match_score=1.0000` and `model_title_match_score=1.0000`.
- Primary Markdown source: `raw/mmb_mineru/runs/g2_sigma08__trade_adjustment_and_the_composition_of_trade__2bcd14af/full.md`.
- Raw PDF path exists: `raw/mmb_papers/Trade adjustment and the composition of trade.pdf`.
- No optional normalization appendix exists at `docs/mmb_appendix_full_normalizations/G2_SIGMA08.md`.
- Optional implementation cross-check exists at `.agents/skills/dynare-copilot/references/examples/G2_SIGMA08_rep.mod`.

## Formula Quality

- The paper prints the core trade aggregator equations, adjustment-cost terms, selected household equations, monetary policy rule, resource constraint, and import-demand log-linear equations.
- The paper explicitly says the model description is abbreviated and refers to Erceg et al. (2006) for the full benchmark SIGMA model. Complete household budget constraints, Calvo reset FOCs, wage reset FOCs, fiscal accounting, and steady-state levels are therefore marked `needs_review`.
- MinerU extracted some chart tables with implausible future dates and approximate values. Those chart tables were not used as mathematical sources for the derivation.
- The raw PDF was not opened because the Markdown was sufficient for a first-pass structural extraction and no single targeted formula discrepancy required PDF inspection.

## Implementation Cross-Check

- The Rep-MMB file declares `model(linear)`, confirming the archived form convention.
- Implementation variables and equations confirm the two-country structure, segmented consumption/investment import block, home and foreign shock pairs, capital timing with production using `kp(-1)`, UIP with a net-foreign-asset stationarity premium, and MMB-facing variables `interest`, `inflation`, `inflationq`, `output`, and `outputgap`.
- Equations labeled `implementation_cross_check` in the derivations were used to preserve variable coverage and timing but should not be treated as independent paper-side derivations.

## Deferred Issues

- Source-level verification against the full SIGMA companion paper/documentation is needed for the complete nonlinear optimization problems and FOCs.
- Capital-tax shock process details include implementation switches and extra lags; the derivation records the visible implementation shape but marks interpretation as `needs_review`.
- The full nonlinear steady-state system is not reconstructed in this first-pass entry. The archive records only calibration identities and the zero-deviation steady state for `model(linear)`.
- Runtime validation was not performed: no Dynare run, residual check, steady-state check, or Blanchard-Kahn check.

## Translation Status

- English derivation drafted first.
- Chinese derivation translated from the English version while preserving eight required section headings and equation numbering `(F1)` through `(F40)`.
