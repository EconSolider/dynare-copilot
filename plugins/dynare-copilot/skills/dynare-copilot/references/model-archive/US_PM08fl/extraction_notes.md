# US_PM08fl Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row 157 identifies `US_PM08fl` as Carabenciov et al. (2008), "A small quarterly projection model of the US economy", DOI `10.5089/9781451871364.001`.
- The primary Markdown title sniff is unambiguous: `A Small Quarterly Projection Model of the US Economy`.
- `model_title_match_score` is `1.0000`; no `source_index_issue` was found.
- Raw PDF exists at `raw/mmb_papers/A small quarterly projection model of the US economy.pdf`; PDF body was not read because the Markdown equations were sufficient for first-pass extraction.
- No appendix normalization file exists at `docs/mmb_appendix_full_normalizations/US_PM08fl.md`.

## Formula Quality

- Status: `needs_review`.
- Source equations (1)-(15) are readable enough in the Markdown for first-pass extraction.
- OCR damage remains around text symbols for inflation, output-gap definition, and the left-hand side of the equilibrium BLT equation.
- (F5) normalizes the output gap identity from the prose because the Markdown line renders the printed relation incorrectly.
- (F9) is source-consistent but its exact four-quarter average form was taken from the MMB implementation as `implementation_cross_check`.
- (F14) preserves the printed/source implementation convention `rho*rr_ss + (1-rho)*rr(-1)` even though this reverses the most common AR(1) steady-state weighting; it remains `needs_review`.

## Implementation Cross-Check

- File: `.agents/skills/dynare-copilot/references/examples/US_PM08fl_rep.mod`.
- Used only as `implementation_cross_check`, not as a paper-side mathematical source.
- Confirmed the MMB variant is the stationary financial-real-linkages version with `model(linear)`.
- Confirmed implementation endogenous variables: `RR_USh`, `RR_US_BARh`, `UNR_US_GAP`, `PIE_USh`, `PIE_US4h`, `Y_US`, `RS_USh`, `E4_PIE_US4h`, `E1_Y_USh`, `E1_PIE_USh`, `E`, `E2`.
- Confirmed implementation shocks: `RES_RR_US_BAR`, `RES_UNR_US_GAP`, `RES_Y_US`, `RES_PIE_US`, `RES_BLT_US`, `RES_RS_US`.
- The implementation omits explicit level equations for potential output, NAIRU, and BLT equilibrium level, consistent with its stationarized representation.

## Deferred Issues

- Targeted PDF review should verify the damaged output-gap definition, the equilibrium real-rate process weights, and the equilibrium BLT random-walk subscript.
- The paper's conceptual system has more latent states and shocks than the stationarized MMB `.mod`; future catalog merging should keep this distinction explicit.
- Original level-model steady-state logic is not fully source-stated; the current entry records the zero-gap steady-state convention of the linear/stationarized implementation.
- Cross-correlated shocks are documented from the paper, but the stationarized Rep-MMB `.mod` excerpt does not encode the full covariance structure.
- Dynare runtime validation was intentionally not performed.

## Translation Status

- English derivation was drafted first.
- Chinese derivation was translated second from the English core.
- Equation numbers `(F1)` through `(F18)`, formulas, file paths, model ID, DOI, and `needs_review` markers were preserved.
