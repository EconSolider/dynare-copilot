# G3_CW03 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` line 35 maps `G3_CW03` to Coenen and Wieland, "Inflation dynamics and international linkages: A model of the United States, the Euro Area and Japan".
- First 80 lines of the primary MinerU Markdown show the expected ECB Working Paper No. 181 title, Gunter Coenen, Volker Wieland, and September 2002 working paper front matter.
- `raw_pdf_path` exists and was recorded for provenance. The PDF body was not read because the Markdown source exposed the needed model equations.
- No alternate MinerU run was inspected because the row has a single run id and a 1.0000 title match score.
- `source_index_issue`: none.

## Formula Quality

- Status: `needs_review`.
- The paper source contains generic contract equations, table equations, and later policy-rule variants. The derivation extracts the final three-country model equations and uses the implementation cross-check to align country suffixes and horizons.
- The active MMB implementation declares `interest_` as an exogenous shock but does not include it in the active policy-rule equation. This mismatch is marked `needs_review`.
- The source's general monetary-policy rule allows forecast horizons and higher-order interest smoothing. The implementation cross-check uses a contemporaneous annual-inflation rule with the country-specific calibrated `rho`, `alpha`, and `beta`.
- Japan's demand equation omits second and third output-gap lags in the implementation by setting those coefficients to zero.

## Implementation Cross-Check

- Read `.agents/skills/dynare-copilot/references/examples/G3_CW03_rep.mod` only as `implementation_cross_check`.
- Cross-check confirmed `model(linear)`, the three country suffixes, 8-quarter long-rate horizons for euro area/U.S., 12-quarter horizon for Japan, the real exchange-rate identities, and the `one = one(-1)` constant process.
- Cross-check was not used as a paper-side mathematical source.

## Deferred Issues

- Human review should compare the normalized (F5)-(F9) contract equations against the PDF if exact contract-wage algebra is required.
- Human review should decide whether `interest_` is an intentionally inactive MMB shock placeholder or should be represented in a future runnable model.
- Runtime validation, Blanchard-Kahn checks, residual checks, and IRF reproduction were not assigned and were not run.
- No promotion was made to `.agents/skills/dynare-copilot/references/model-archive/`.

## Translation Status

- English derivation was drafted first.
- Chinese derivation was translated from the English draft with the same eight-section structure and matching `(F#)` numbering.
