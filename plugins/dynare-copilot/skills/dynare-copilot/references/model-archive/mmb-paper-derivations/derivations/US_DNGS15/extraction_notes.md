# US_DNGS15 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row `model_id=US_DNGS15` maps to a single MinerU run id, `c8e184ab-3624-4257-9ea5-7ec1cf904fbb`.
- The first Markdown line is `# Inflation in the Great Recession and New Keynesian Models†`, matching the expected Del Negro, Giannoni, and Schorfheide paper.
- The index row and raw PDF filename spell the title as `Infation in the Great recession and New Keynesian models`. This is recorded as a `source_index_issue`; no shared metadata was edited.
- The raw PDF path exists. The PDF body was not opened because the Markdown equations were sufficient for a first-pass extraction.
- No appendix normalization file exists at `docs/mmb_appendix_full_normalizations/US_DNGS15.md`.

## Formula Quality

- Status: `needs_review`.
- Main extracted source region: Section I.A, equations (1)-(21), which gives the SW model, the time-varying inflation-target extension, and the financial-friction replacement of the capital arbitrage condition.
- Section I.B equations (22)-(27) were inspected. They define fundamental inflation and are analysis/measurement objects, not included in the core equilibrium block.
- MinerU OCR is mostly readable in the main model equations. Some notation is normalized in the derivation, especially `bar beta`, `tilde z`, `tilde sigma_omega`, `lambda_f`, and `lambda_w`.
- The source paper gives log-linear equilibrium conditions, not primitive nonlinear optimization problems. The derivation therefore records the economic optimization origins but marks primitive-program derivation as deferred.

## Implementation Cross-Check

- Cross-check file: `.agents/skills/dynare-copilot/references/examples/US_DNGS15_rep.mod`.
- Used only as implementation evidence for variable names, shock names, timing, the `model(linear)` form, and the flexible-price auxiliary economy.
- The `.mod` file includes sticky-price variables, flexible-price variables, nine shocks, and a financial-frictions block with `Rktil`, `sigw`, and `n`.
- The `.mod` file treats the flexible-price economy as having no financial frictions in the auxiliary arbitrage condition.
- Dynare was not run.

## Deferred Issues

- Verify primitive household, firm, wage-setting, and financial-contract problems against Christiano, Eichenbaum, and Evans (2005), Smets and Wouters (2007), Del Negro and Schorfheide (2013), and Christiano, Motto, and Rostagno (2014) before marking the entry reviewed.
- Verify the nonlinear steady-state formulas and the mapping from financial-contract primitives to `zeta_*` coefficients.
- Confirm whether the stochastic-trend and trend-stationary cases require separate archive variants for fixed-cost treatment.
- Decide whether equations for fundamental inflation, measurement equations, and ZLB/forward-guidance solution matrices should become separate analysis appendices in a later archive pass.

## Translation Status

- English derivation drafted first.
- Chinese derivation translated from the English derivation with matching section order and matching `(F#)` coverage.
