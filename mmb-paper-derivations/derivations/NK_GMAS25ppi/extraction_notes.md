# NK_GMAS25ppi Extraction Notes

## Source Match

- `model_id`: `NK_GMAS25ppi`
- `model_index` row title: "Monetary policy and exchange rate volatility in a small open economy"
- Primary Markdown: `raw/mmb_mineru/runs/nk_gm05_nk_gmas25cpi_nk_gmas25ppi__monetary_policy_and_exchange_rate_volatility_in_a_small_open_economy__6f92413a/full.md`
- Raw PDF: `raw/mmb_papers/Monetary policy and exchange rate volatility in a small open economy.pdf`
- MinerU run id: `6f92413a-db30-4472-9653-722aeb4c5a62`
- Match score and model-title score are both `1.0000`.
- Title and author sniff matched the intended paper, allowing for OCR accent and affiliation noise.

## Formula Quality

- Status: `needs_review`.
- The core household, open-economy identity, Calvo pricing, NKPC, natural-rate, dynamic-IS, and simple-rule equations are readable in the MinerU Markdown.
- Several OCR artifacts appear in prose and footnotes, including accent marks, occasional duplicated fragments, and noisy inline arrays. The main equations used in the derivation were taken from readable displayed formulas.
- The raw PDF path was checked and hashed, but the PDF body was not opened because the Markdown source was sufficient for this first-pass extraction.

## Implementation Cross-Check

- No optional normalization file exists at `docs/mmb_appendix_full_normalizations/NK_GMAS25ppi.md`.
- No optional example implementation exists at `.agents/skills/dynare-copilot/references/examples/NK_GMAS25ppi_rep.mod`.
- No MMB `.mod` file was used as a paper-side mathematical source.

## Variant Notes

- The same paper row also covers related Gali-Monacelli variants. This entry is specific to `NK_GMAS25ppi`, interpreted as the producer-price/domestic-inflation Taylor-rule variant.
- CPI inflation and exchange-rate-peg rules are mentioned only to distinguish variants. The equation set closes with the PPI/domestic-inflation rule \(r_t=\rho+\phi_\pi\pi_{H,t}\).

## Deferred Issues

- Human review should confirm the exact MMB naming convention for `ppi` versus the paper's "domestic inflation" terminology.
- A future implementation phase should compare the variable list and policy rule against the actual MMB model file if that file is intentionally brought in only for implementation cross-checking.
- Runtime validation was not performed: no Dynare run, residual check, steady-state check, BK check, or IRF comparison.
- The archive entry keeps first-pass status as `needs_review` until formula-level PDF review and implementation cross-check are completed.

## Translation Status

- English derivation was drafted first.
- Chinese derivation was translated from the English core.
- Equation labels `(F1)` through `(F32)` are preserved with matching unique F-number counts.
- File paths, model id, DOI, and status markers are preserved.
