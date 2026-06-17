# NK_GN25 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row: `NK_GN25`.
- Primary source title match is exact (`model_title_match_score = 1.0000`).
- Primary Markdown: `raw/mmb_mineru/runs/nk_gn25__energy_price_shocks_unemployment_and_monetary_policy__ca6f092e/full.md`.
- Raw PDF exists at `raw/mmb_papers/Energy price shocks, unemployment, and monetary policy.pdf`; PDF body was not read because the Markdown contained the model equations needed for a first-pass extraction.
- No optional normalization file was present at `docs/mmb_appendix_full_normalizations/NK_GN25.md`.
- No optional implementation cross-check file was present at `.agents/skills/dynare-copilot/references/examples/NK_GN25_rep.mod`.
- Shared `catalog.csv` and `status.csv` were not edited because this task explicitly assigns ownership only over `data/model_archive/mmb_derivations/NK_GN25/`.

## Formula Quality

- Overall status: `needs_review`.
- The source Markdown includes the nonlinear household, producer, Calvo-pricing, matching, labor-market-clearing, zero-liquidity, constrained-efficient, linearized, and policy equations.
- OCR issue: several parameter names appear as `??`, especially around the Calvo parameter description, the flow vacancy cost prose, the relative welfare weight, and some composite coefficient definitions.
- OCR issue: the CPI price index in paper equation (4) is readable as a Cobb-Douglas product formula, but it remains marked for targeted review because this equation is central to the model's energy/non-energy inflation split.
- OCR issue: Euler equations (5)-(6) are readable, but the multiplication between the real return term and continuation marginal utilities is visually vulnerable to OCR spacing errors; both are marked `needs_review`.
- OCR issue: equations around the analytical natural/efficient unemployment wedge and optimal policy target paths contain malformed symbols in the Markdown. The derivation records the central wedge and welfare-relevant NKPC but leaves the closed-form target paths out of the F-numbered system.

## Implementation Cross-Check

- No local `.agents/skills/dynare-copilot/references/examples/NK_GN25_rep.mod` file exists.
- No `.mod` source was used as a mathematical source.
- Variable and timing coverage were inferred from the paper-side Markdown only.

## Deferred Issues

- Runtime validation was not performed.
- A targeted PDF check is recommended for (F3), (F4), (F5), and the composite-coefficient definitions used in (F31)-(F35).
- The extraction emphasizes the Section 5 `model(linear)` simulation block and source definitions. It does not attempt to reproduce every optimal-policy closed-form path because OCR quality is poor in that area and those formulas are policy-analysis results rather than the simple-rule simulation closure.
- The replication package URL is recorded in the source Markdown but no external package was downloaded or inspected.

## Translation Status

- English derivation drafted first.
- Chinese derivation translated from the English artifact.
- F-number parity target: F1-F36 in both English and Chinese.
