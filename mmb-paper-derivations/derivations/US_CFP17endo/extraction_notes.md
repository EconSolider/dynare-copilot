# US_CFP17endo Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row for `US_CFP17endo` has `mineru_match_status=matched`, `mineru_match_score=1.0000`, `model_title_match_score=1.0000`, and no `model_match_notes`.
- First 80 Markdown lines show the expected title, "Targeting Long Rates in a Model with Segmented Markets", and the expected authors, Charles T. Carlstrom, Timothy S. Fuerst, and Matthias Paustian.
- Primary Markdown: `raw/mmb_mineru/runs/us_cfp17endo_us_cfp17exo__targeting_long_rates_in_a_model_with_segmented_markets__d8728772/full.md`.
- Raw PDF path exists: `raw/mmb_papers/Targeting long rates in a model with segmented markets.pdf`.
- No appendix normalization file exists at `docs/mmb_appendix_full_normalizations/US_CFP17endo.md`.

## Extraction Scope

- English derivation was drafted first using the required eight-section structure.
- Chinese derivation is a direct translation of the English core and preserves `(F#)` numbering, file paths, DOI values, model ID, and `needs_review` markers.
- The source paper contains nonlinear primitive problems and a log-linearized model. The MMB implementation cross-check is explicitly a linearized model, so the archive entry records `model(linear)` / log-linearized form.
- `US_CFP17endo` is treated as the endogenous-debt variant because the implementation cross-check sets `term_prem = 0` and `term_premf = 0`.
- The `.mod` file `.agents/skills/dynare-copilot/references/examples/US_CFP17endo_rep.mod` was read only as `implementation_cross_check`.

## Formula Quality

- Overall formula status: `needs_review`.
- MinerU Markdown captures the main model equations (1)-(64) and appendix FI value-function equations (A28)-(A40), but some OCR output is visibly noisy.
- Main issue: equation (47) in the paper-side Markdown has ambiguous typography around `\psi n_t` versus $\psi_n n_t`; the derivation normalizes it to $\psi_n n_t` and marks it `needs_review`.
- Some variables are notation-dependent across paper and `.mod`: paper $\lambda_t$ appears as implementation `muc`; paper $h_t$ labor maps to implementation `L`; paper $r_t^L` maps to implementation `r2`; paper $q_t^{EH}` maps to implementation `qnat`.
- The PDF body was not opened because the Markdown was sufficient for a first-pass `needs_review` extraction and the task contract says not to read the PDF body by default.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/US_CFP17endo_rep.mod` exists and was read only as `implementation_cross_check`.
- The `.mod` confirms a linearized implementation and declares sticky-price variables plus flexible-price counterparts with `f` suffixes.
- The `.mod` confirms endogenous policy variables `term_prem = 0` and `term_premf = 0`, with `bb2`/`b2` acting as the long-bond quantity variable.
- The `.mod` uses `k(-1)` in production and writes capital accumulation as `k = (1-delta)*k(-1)+delta*(i+muinv)`, confirming predetermined capital timing.
- The `.mod` shocks are `eps_a`, `eps_mp`, `eps_i`, `eps_psi`, `eps_mk`, `eps_mkw`, `eps_b2`, and `eps_rn`.
- Dynare was not run.

## Deferred Issues

- Source-level review should check equations (F11)-(F13), especially the hold-up/leverage and net-worth adjustment conditions, against the PDF or author replication materials before moving beyond `needs_review`.
- The archive entry does not reproduce the full flexible-price counterpart block from the `.mod`; it records the paper-side model plus the implementation convention that `f`-suffix variables are used for output-gap computation.
- Exact numeric steady-state values are loaded from `parameterfile` in the implementation and were not recalculated here.
- Runtime validation, residual checks, BK checks, IRF checks, and promotion to the runnable skill archive were not performed.

## Translation Status

- English derivation completed first.
- Chinese translation completed second.
- English and Chinese `(F#)` counts match in validation.
