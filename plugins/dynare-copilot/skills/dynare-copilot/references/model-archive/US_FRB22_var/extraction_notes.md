# US_FRB22_var Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` maps `US_FRB22_var` to "LINVER: The Linear Version of FRB/US".
- `primary_source_title` is "LINVER- The Linear Version of FRB:US".
- `mineru_match_score` and `model_title_match_score` are both `1.0000`.
- The first Markdown page/title matches the expected LINVER paper by Brayton and Reifschneider.
- Raw PDF exists at `raw/mmb_papers/LINVER- The Linear Version of FRB:US.pdf`; the PDF body was not read because the Markdown was sufficient for this first-pass source check.

## Formula Quality

- Status: `needs_review`.
- The paper is primarily an introduction to LINVER, its linearization methodology, simulation package, expectation assumptions, stochastic simulation procedures, ELB handling, policy rules, and ECFS mechanism.
- The paper does not publish a full equation-by-equation LINVER/FRB-US model listing.
- Equations in the derivation are therefore limited to paper-supported construction mappings, expectation concepts, representative policy rules, stochastic-simulation processes, ECFS, and clearly labeled implementation-cross-check summaries.
- The OCR text contains unreadable placeholders near some policy-rule formulas, especially where the lower bound appears as `????`; these were normalized to `ELB` and marked `needs_review`.

## Implementation Cross-Check

- Cross-check path: `raw/mmb/mmci-cli/models/US_FRB22_var/US_FRB22_var.mod`.
- Metadata path: `raw/mmb/mmci-cli/models/US_FRB22_var/US_FRB22_var.json`.
- The `.mod` header identifies `US_FRB22_var` as the variant in which all expectations are based on VAR predictions.
- The `.json` metadata describes the model as "Linearized by Brayton & Reifschneider (2022)" and categorizes it as an estimated U.S. model.
- The `.mod` declares 276 endogenous variables, 114 exogenous entries, and 1393 parameters/coefficient names. This count was used only for coverage notes.
- Dynare was not run.

## Deferred Issues

- Recover the full LINVER equation list from the official LINVER package/manual or detailed FRB/US documentation.
- Verify variable-by-variable log versus level linearization classifications.
- Verify package-specific scaling for output gaps, unemployment gaps, inflation annualization, and rule variables.
- Verify the exact VAR expectation state vectors and coefficients for the all-VAR variant.
- Verify how the MMB implementation maps the source's `ELB`, `FISCAL`, policy-rule, and residual-shock notation to Dynare names.

## Translation Status

- English derivation was drafted first.
- Chinese derivation was translated second from the English core.
- Equation numbers `(F1)` through `(F22)` match in both versions.
