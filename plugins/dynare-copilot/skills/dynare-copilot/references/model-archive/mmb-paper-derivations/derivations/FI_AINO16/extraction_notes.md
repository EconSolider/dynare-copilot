# FI_AINO16 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row is matched with score `1.0000`.
- Primary Markdown: `raw/mmb_mineru/runs/fi_aino16__the_aino_ii_model__bb68ecab/full.md`.
- Raw PDF exists: `raw/mmb_papers/The AINO II model.pdf`.
- First-page sniff found expected authors and the title family. The row title is "The AINO II model"; the source header is "The Aino 2.0 model". This is recorded as a title-normalization issue, not a different source.
- There is only one MinerU run id in the row, so no alternate run was inspected.

## Formula Quality

- Status: `needs_review`.
- The model blocks are readable enough to extract a first-pass derivation: CES production, Calvo pricing, final-good CES aggregators, household problem, wage setting, market clearing, capital producer, entrepreneurs, and banking sector.
- OCR issues remain in some symbols: markup parameters in the domestic goods aggregator, euro/rest-of-world asset notation, import-pricing notation, and occasional equation-number artifacts.
- The full linearized appendix/state-space representation was not reconstructed equation by equation. The derivation therefore summarizes the source-backed structural blocks plus key paper-reported/log-linearized banking equations.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/FI_AINO16_rep.mod` exists and was read only as `implementation_cross_check`.
- It confirms the MMB implementation uses `model(linear)`.
- It lists endogenous variables, shocks, banking variables, and the author's later corrections to Tobin's Q, net wholesale loan rate, and wage Phillips curve equations.
- Information learned only from the `.mod` is marked as implementation cross-check and was not treated as paper-side mathematical source.

## Deferred Issues

- Source-level review of the PDF body is needed for a final appendix-equation map.
- The deterministic steady-state construction should be reconciled with the paper tables, the implementation auxiliary definitions, and the required `.mat` calibration file before marking the entry reviewed.
- Wage Phillips curve, import price Phillips curve, domestic price Phillips curve, and all relative-price identities need formula-by-formula review against the PDF or a clean appendix source.
- Runtime validation was not performed, per instruction.

## Translation Status

- English derivation drafted first.
- Chinese derivation translated from the English file and preserves the same eight-section structure and `(F#)` numbering.
