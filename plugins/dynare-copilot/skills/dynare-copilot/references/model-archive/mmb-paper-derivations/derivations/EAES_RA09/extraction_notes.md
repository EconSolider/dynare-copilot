# EAES_RA09 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row for `EAES_RA09` has `mineru_match_status=matched`, `mineru_match_score=1.0000`, `model_title_match_score=1.0000`, and no `model_match_notes`.
- First 80 Markdown lines show `PAU RABANAL` and `Inflation Differentials between Spain and the EMU: A DSGE Perspective`; this matches the expected title/authors except for case and punctuation.
- Raw PDF path exists. Per task instruction, the PDF body was not read.
- No `docs/mmb_appendix_full_normalizations/EAES_RA09.md` file exists.

## Formula Quality

- The Markdown source contains the paper's main model section: preferences, CES consumption and price indexes, household budget constraint, complete-markets risk-sharing condition, production, Calvo reset-price problem, price-index law, monetary rule, market clearing, normalization, and shock processes.
- The paper states that an appendix available upon request provides the full pricing equations. That appendix was not present locally. The Phillips-curve equations in the derivation are therefore marked `needs_review`.
- The derivation is a first-pass extraction and should not be treated as source-level checked.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/EAES_RA09_rep.mod` exists and was read only as `implementation_cross_check`.
- The `.mod` file confirms a `model(linear)` implementation with variables for consumption, marginal utility, real exchange rate, sectoral prices, sectoral labor, sectoral outputs, home/foreign CPI, EMU CPI, GDP growth, common monetary policy, sectoral productivity, and sectoral demand shocks.
- The `.mod` file sets positive estimated trends to zero for Rep-MMB IRF matching. The derivation records this as an implementation convention, not a paper-side mathematical source.
- Dynare was not run.

## Deferred Issues

- Obtain or reconstruct the appendix equilibrium conditions before moving beyond `needs_review`.
- Source-check the four Phillips curves and their trend-normalization terms against the appendix or a paper-author code appendix.
- Review whether the Rep-MMB `r` variable should be described as nominal policy-rate deviation, real rate, or interest-rate observable after aligning paper notation and implementation naming.
- Confirm all starred tradable price relative-price identities against the full appendix because the paper text gives only the home-country functional forms.

## Translation Status

- English derivation was written first.
- Chinese derivation is a direct translation of the English core and preserves `(F#)` numbering, paths, DOI values, model id, and `needs_review` markers.
