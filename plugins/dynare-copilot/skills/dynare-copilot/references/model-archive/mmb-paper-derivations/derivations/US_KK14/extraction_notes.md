# US_KK14 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row 145 has `mineru_match_status=matched`, `mineru_match_score=1.0000`, `model_title_match_score=1.0000`, and no `model_match_notes`.
- The first page / first 80 Markdown lines show the expected title, "Toward a Taylor rule for fiscal policy", and authors Martin Kliem and Alexander Kriwoluzky.
- Raw PDF exists at `raw/mmb_papers/Toward a Taylor rule for fiscal policy.pdf`; per task instruction and skill default, the PDF body was not read.
- No appendix normalization exists at `docs/mmb_appendix_full_normalizations/US_KK14.md`.

## Formula Quality

- Status: `needs_review`.
- The paper body gives household utility, budget constraint, capital accumulation, production, monetary policy rule, government budget constraint, tax-revenue identity, baseline fiscal rules, broad-variable fiscal rules, recommended fiscal rules, and the fiscal multiplier formula.
- The paper explicitly says household/firm maximization details, corresponding FOCs, steady-state solution, and the complete log-linear equations are in the online appendix. That appendix is not locally available as a normalization file.
- The English derivation therefore marks normalized private-sector FOCs, Phillips curves, linearized aggregation identities, and shock-process details as `needs_review`.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/US_KK14_rep.mod` exists and was read only as `implementation_cross_check`.
- The `.mod` file confirms a `model(linear)` implementation with variables for marginal utility, MRS, consumption, hours, wage, Tobin's Q, investment, capital, utilization, rental rate, inflation, policy rate, government debt, taxes, tax revenues, government consumption, transfers, measured GDP, investment/technology/preference shock states, and fiscal/monetary innovations.
- The `.mod` file was used to identify likely variable coverage, timing conventions, shock names, and calibration targets. It was not used as paper-side mathematical evidence.
- Dynare was not run.

## Deferred Issues

- Locate and normalize the online supplementary material before promoting this entry beyond `needs_review`.
- Source-check all private-sector FOCs, wage and price Phillips curves, and linearized market-clearing identities against the appendix.
- Reconstruct the steady-state solution from the appendix rather than relying on implementation cross-check targets.
- Confirm whether the MMB implementation's `R` variable should be documented as the nominal policy-rate deviation throughout, because the Euler equation and government budget combine it with inflation in real-return expressions.
- Runtime validation, Blanchard-Kahn checks, residual checks, and IRF checks were not performed.

## Translation Status

- English derivation was drafted first.
- Chinese derivation is a direct translation of the English draft.
- Equation numbers `(F1)` through `(F37)`, paths, DOI values, model id, and `needs_review` markers are preserved.
