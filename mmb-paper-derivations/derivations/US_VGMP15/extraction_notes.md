# US_VGMP15 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row for `US_VGMP15` has `mineru_match_status=matched`, `mineru_match_score=1.0000`, `model_title_match_score=1.0000`, and no `model_match_notes`.
- Primary Markdown: `raw/mmb_mineru/runs/us_vgmp15__the_effects_of_oil_price_shocks_in_a_new_keynesian_framework_with_capita__b2b0e207/full.md`.
- Raw PDF path exists: `raw/mmb_papers/The effects of oil price shocks in a new-Keynesian framework with capital accumulation.pdf`.
- No appendix normalization file exists at `docs/mmb_appendix_full_normalizations/US_VGMP15.md`.
- No implementation cross-check exists at `.agents/skills/dynare-copilot/references/examples/US_VGMP15_rep.mod`.

## Source Sniff

- The first 80 Markdown lines show the expected title: "The effects of oil price shocks in a new-Keynesian framework with capital accumulation".
- The first-page Markdown authors are Veronica Acurio Vasconez, Gael Giraud, Florent Mc Isaac, and Ngoc-Sang Pham.
- The index row's author string uses Jose/Frederic variants; this is recorded in `source_manifest.json` but not treated as a source-index mismatch because title, DOI, and run ID match unambiguously.
- Only one MinerU run ID is listed, so no alternate run inspection was needed.

## Formula Quality

- Status: `needs_review`.
- The primary Markdown includes the main-text equations for relative oil and capital prices, household utility and budget constraint, Cobb-Douglas consumption, CES final-good aggregation, oil/labor/capital production, marginal-cost pricing, Taylor rule, government budget, government spending process, and GDP definition.
- The source explicitly says a log-linear version of the model and the full Calvo pricing derivation are in the online appendix. No local appendix normalization file exists for this model.
- The English derivation therefore marks the bond Euler, labor supply, capital Euler, and Phillips relation as first-pass normalized conditions requiring source-level review.
- The price-markup shock is mentioned in the simulation section, but its exact process is not available in the local Markdown and is marked `needs_review`.

## Implementation Cross-Check

- No `.agents/skills/dynare-copilot/references/examples/US_VGMP15_rep.mod` file exists.
- No Dynare implementation was used as a source or cross-check.

## Deferred Issues

- Locate or normalize the online appendix for the exact log-linear model, Calvo pricing block, price-markup shock, and steady-state equations.
- Review the paper's use of $`P_{c,t}`$ versus $`P_{q,t}`$ in household Euler conditions and convert consistently before any runnable `.mod` work.
- Confirm the exact MMB implementation variable names and equation count once a `US_VGMP15` implementation source is available.
- No Dynare runtime validation was performed.

## Translation Status

- English derivation was drafted first.
- Chinese derivation is a direct translation of the English draft.
- Equation numbers `(F1)` through `(F23)` are preserved in both versions.
