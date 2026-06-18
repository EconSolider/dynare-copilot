# NK_GMAS25cpi Extraction Notes

## Source Match

- `model_id`: `NK_GMAS25cpi`
- Paper: Gali and Monacelli (2005), "Monetary policy and exchange rate volatility in a small open economy"
- DOI: `10.1111/j.1467-937x.2005.00349.x`
- MinerU run id: `6f92413a-db30-4472-9653-722aeb4c5a62`
- Match status: `matched`
- Model title match score: `1.0000`
- Raw PDF path exists: yes
- Appendix normalization: none found at `docs/mmb_appendix_full_normalizations/NK_GMAS25cpi.md`
- Implementation cross-check: none found at `.agents/skills/dynare-copilot/references/examples/NK_GMAS25cpi_rep.mod`

## Formula Quality

- Status: `needs_review`
- Core equations were extracted from the MinerU Markdown around the household problem, price-setting block, equilibrium conditions, policy-rule section, and appendix price-setting derivation.
- The derivation uses the paper's log-linear canonical small-open-economy system as the operative model form.
- The CPI Taylor rule is source-stated in the paper's simple-rules section; matching it specifically to `NK_GMAS25cpi` relies on the MMB model id label.
- Coefficient definitions for \(\Omega\), \(\Theta\), and OCR-rendered appendix formulas are readable enough for first-pass extraction but should receive a targeted PDF check before reviewed status.

## Implementation Cross-Check

- No `.agents/skills/dynare-copilot/references/examples/NK_GMAS25cpi_rep.mod` file exists.
- No implementation-side variables, calibration values, or timing conventions were used as derivation evidence.

## Deferred Issues

- Runtime validation was not performed.
- No PDF body was read; only the path existence was checked.
- A future reviewer should verify coefficient definitions and the exact MMB calibration for the `GMAS25cpi` variant before promotion.
- Shared `catalog.csv` and `status.csv` were not edited by request; proposed rows are recorded in `worker_report.json`.

## Translation Status

- English derivation was drafted first.
- Chinese derivation is a matched translation preserving section order, file paths, status markers, and all `(F#)` equation labels.
