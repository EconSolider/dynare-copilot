# US_GG24 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row has `model_id=US_GG24`, title "Oil Prices, Monetary Policy and Inflation Surges", DOI `10.3386/w31263`, and MinerU run id `65e1c546-8764-48d5-8571-e080685b9992`.
- Title sniff of the first Markdown page matches the indexed paper title and authors Luca Gagliardone / Mark Gertler.
- `raw_pdf_path` exists at `raw/mmb_papers/Oil Prices, Monetary Policy and Inflation Surges.pdf`.
- No `docs/mmb_appendix_full_normalizations/US_GG24.md` file exists.

## Formula Quality

Status: `needs_review`.

- The main model equations in Section 2 are readable enough for a first-pass derivation.
- The marginal utility line after the household budget constraint contains OCR noise; the archive entry records the standard habit marginal utility implied by the surrounding text.
- The Nash wage expression is OCR-sensitive and was normalized from the Markdown; it needs a targeted PDF/formula check before promotion.
- The Taylor rule appears as a smoothing rule but the Markdown has an additive connection between the smoothed target and lagged-rate terms. The entry preserves that uncertainty and marks it `needs_review`.
- Demand and matching shock AR(1) forms are inferred from Appendix B estimates and the historical-decomposition text, not from explicit printed model equations.
- The paper provides steady-state targets and parameter estimates but not a full analytic steady-state block.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/US_GG24_rep.mod` was checked for existence and was not present.
- No MMB `.mod` file was used as a mathematical source.
- Dynare was not run.

## Deferred Issues

- Verify the Taylor rule algebra against author/MMB implementation if available.
- Verify Nash wage and household marginal utility formulas against the PDF or implementation source.
- Reconcile the final equation list with a runnable `model(linear)` implementation.
- Build a complete steady-state derivation if source code or author appendix becomes available.
- Confirm exact naming and count of endogenous variables, exogenous shocks, and observables from implementation files before marking reviewed.

## Translation Status

- English derivation drafted first in `US_GG24_derivation.en.md`.
- Chinese derivation translated second in `US_GG24_derivation.zh.md`.
- Equation numbers `(F1)` through `(F37)`, source paths, DOI, model ID, and `needs_review` markers were preserved.
