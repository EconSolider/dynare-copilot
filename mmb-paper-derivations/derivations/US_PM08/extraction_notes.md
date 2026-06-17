# US_PM08 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row 157 lists `US_PM08` as Carabenciov, Ermolaev, Freedman, Juillard, Kamenik, Korshunov, and Laxton (2008), "A small quarterly projection model of the US economy."
- The row's `primary_full_md_path`, `raw/mmb_mineru/runs/gpm6_imf13_us_pm08_us_pm08fl__a_small_quarterly_projection_model_of_the_us_economy__a2e8676b/full.md`, begins with the expected title and authors.
- The row's `raw_pdf_path`, `raw/mmb_papers/A small quarterly projection model of the US economy.pdf`, exists and was used for targeted formula checks because the MinerU Markdown has OCR noise in several equation explanations.
- No appendix normalization file exists at `docs/mmb_appendix_full_normalizations/US_PM08.md`.

## Formula Quality

- Status: `needs_review`.
- The equation backbone is the paper's equations 1-11 for the benchmark model and equations 12-15 for the financial-real linkage extension.
- Targeted PDF text checks were performed for the benchmark equation pages and the BLT equation pages. These checks confirm the broad structures of the output-gap, inflation, policy-rate, Okun-law, BLT, and BLT distributed-lag equations.
- Remaining first-pass uncertainties:
  - equation 7 equilibrium real-rate coefficient placement is visually noisy in extracted PDF text and should be checked against rendered PDF;
  - equation 13 loses or distorts the left-side BLT subscript/overbar in text extraction;
  - the paper-level stochastic-trend equations for potential output and NAIRU do not map one-for-one to the stationary MMB `.mod` implementation;
  - the four-quarter inflation identity in the derivation uses the stationary implementation form and should be reconciled with the paper's CPI-log definition during review.
- No missing formula was invented. Uncertain formulas are marked `needs_review` in the derivation.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/US_PM08_rep.mod` exists and was read only as `implementation_cross_check`.
- The `.mod` confirms a stationary `model(linear)` form, MMB variable names (`RR_USh`, `RR_US_BARh`, `UNR_US_GAP`, `PIE_USh`, `PIE_US4h`, `Y_US`, `RS_USh`), shock names, expectation-reporting variables, and the BLT distributed-lag implementation.
- The `.mod` was not treated as paper-side mathematical evidence and was not run.

## Deferred Issues

- Review equations 7 and 13 against rendered PDF pages to resolve overbar/subscript placement.
- Decide whether future archive rows should separate paper-level stochastic-trend equations from stationary MMB implementation equations more explicitly for the `US_PM08`/`US_PM08fl` pair.
- Confirm whether the `US_PM08` and `US_PM08fl` entries should differ only by financial-real linkage terms or by additional stationary implementation conventions.
- Dynare runtime validation was not performed by instruction.

## Translation Status

- English derivation drafted first.
- Chinese derivation translated from the English draft.
- Equation numbers `(F1)` through `(F21)` are preserved in both files.
