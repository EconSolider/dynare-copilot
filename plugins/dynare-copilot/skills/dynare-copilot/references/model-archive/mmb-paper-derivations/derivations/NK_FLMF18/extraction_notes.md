# NK_FLMF18 Extraction Notes

## Source Match

- Model index row: `NK_FLMF18`, row 59 in `raw/mmb_mineru/model_index.csv`.
- Primary Markdown: `raw/mmb_mineru/runs/nk_flmf18__monetary_policy_spillovers_global_commoditiy_prices_and_cooperation__837579b4/full.md`.
- MinerU run id: `837579b4-3cc3-47e0-8b89-5e6c1b717f14`.
- Raw PDF path exists: `raw/mmb_papers/Monetary policy spillovers, global commoditiy prices and cooperation.pdf`.
- Raw PDF body was not read. The Markdown source was sufficient for a draft extraction.
- No optional appendix normalization file exists at `docs/mmb_appendix_full_normalizations/NK_FLMF18.md`.

## Formula Quality

- Status: `needs_review`.
- The main model section and Appendix A/B/D/E are usable, but the MinerU Markdown contains OCR artifacts in some formulas and captions.
- Equations extracted into the derivation prioritize the paper-side model equations, with minor notation normalization for readability.
- The source has both nonlinear and log-linear forms. The derivation records nonlinear equilibrium blocks where possible and log-linear benchmark/policy equations where those are the paper's operative objects.
- The source table reports `EPS` around 7.66, while the implementation cross-check uses `EPS=7.67`; this is recorded as a rounding discrepancy.

## Implementation Cross-Check

- Cross-check file: `.agents/skills/dynare-copilot/references/examples/NK_FLMF18_rep.mod`.
- Used only to confirm variable coverage, shock names, switch names, and timing/form conventions.
- Confirmed shocks include `EZ`, `EOMEGA`, `EA`, `EG`, `EERR`, and `EGG`.
- Confirmed level/log dual naming with `N`-prefixed level variables and logged reporting variables such as `Y=ln(NY)`, `Q=ln(NQ)`, and `R=ln(NR)`.
- The displayed `.mod` parameter declaration omits `RHO_GG` while later assigning it; this was not corrected here because runtime validation is outside the archive-extraction scope.

## Deferred Issues

- Runtime validation was not performed.
- Human review should compare the formulas against the PDF for OCR-sensitive appendix equations if this entry is promoted beyond draft.
- Some notation conflicts are inherent: `N_t` appears as both a Calvo numerator in the appendix notation and `N`-prefixed level variables in the MMB implementation.
- The DOI in `model_index.csv` is preserved exactly even though the visible paper source is a BIS working paper.

## Translation Status

- English derivation was drafted first.
- Chinese derivation was translated from the English derivation.
- Equation numbering parity: English and Chinese both contain `(F1)` through `(F43)`.
