# US_LTW17 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row for `US_LTW17` reports match status `matched`, MinerU match score `1.0000`, model title match score `1.0000`, DOI `10.1257/aer.20111196`.
- First 80 lines of the primary Markdown match the expected title and authors: Leeper, Traum, and Walker.
- Raw PDF path exists and is recorded for provenance. The PDF body was not read.
- No `docs/mmb_appendix_full_normalizations/US_LTW17.md` file exists.
- The row lists alternate MinerU run id `a9ef5398-12f6-46fd-ac1a-ab3f92b52596`; the primary run title sniff was unambiguous, so the alternate was not opened.

## Formula Quality

- Status is `needs_review`.
- The primary Markdown source gives the main model section: production, marginal cost, Calvo pricing problem, labor aggregation, saver and non-saver household descriptions, non-saver budget constraint, monetary rule, fiscal rules, aggregation, calibration, policy regimes, and multiplier definition.
- The OCR source does not provide a clean complete appendix-level list of log-linear first-order conditions. FOCs and identities that are reconstructed from `.agents/skills/dynare-copilot/references/examples/US_LTW17_rep.mod` are marked `needs_review` in the English derivation.
- The dynamic equations are written in the linear implementation form for this model ID, not as a full nonlinear derivation.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/US_LTW17_rep.mod` exists and was used only as `implementation_cross_check`.
- The `.mod` confirms `model (linear)`, endogenous variables, eight structural innovations, active monetary/passive fiscal baseline coefficients, and the model block equations for production, factors, marginal cost, Phillips/wage equations, saver Euler, capital, fiscal rules, government budget, measurement equations, and shock processes.
- The `.mod` contains expectation-helper identities for forward variables; these are not treated as separate economic equations in the derivation.
- No `.mod` expression is treated as paper-side mathematical evidence unless independently described by the paper-side Markdown.

## Deferred Issues

- Locate the online appendix or a normalized appendix source for complete paper-side FOC verification.
- Check the price and wage Phillips equations, saver marginal utility equation, capital FOC, investment FOC, and government budget constraint against a PDF/appendix source before promoting beyond first pass.
- Verify the exact active monetary/passive fiscal regime assignment and same-paper variant differences for `US_LTW17gz`, `US_LTW17nu`, and `US_LTW17rot` before merging shared index rows.
- Runtime validation is deferred; no Dynare execution was performed.

## Translation Status

- English derivation was drafted first.
- Chinese derivation was translated from the English derivation and preserves equation numbers, formulas, file paths, DOI, model ID, and `needs_review` markers.
