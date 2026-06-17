# EA_SR07 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row for `EA_SR07` reports match status `matched`, MinerU match score `1.0000`, model title match score `1.0000`, DOI `10.1016/j.jinteco.2007.01.003`.
- First 80 lines of the primary Markdown match the expected title and authors: Adolfson, Laseen, Linde, and Villani.
- Raw PDF path exists and is recorded for provenance. The PDF body was not read.
- No `docs/mmb_appendix_full_normalizations/EA_SR07.md` file exists.

## Formula Quality

- Status is `needs_review`.
- The published Markdown source gives the main Section 2 model setup and several numbered equations: domestic aggregator, production, marginal cost, domestic Phillips curve, import/export aggregators, export demand, household utility, consumption/investment aggregators, capital accumulation, foreign-bond premium, monetary policy rule, generic shock process, fiscal VAR description, and foreign VAR description.
- The paper references an appendix manuscript for details, but that appendix is not available as a normalized local source for this model. Household Euler, investment FOC, capital FOC, money demand, wage Phillips curve, UIP equation, resource constraint, relative-price identities, and steady-state recursions are therefore first-pass and marked `needs_review` when derived from the implementation cross-check.
- The OCR for the marginal-cost equation and monetary-policy inflation-target term should be checked against the PDF before promoting the entry beyond first pass.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/EA_SR07_rep.mod` exists and was used only as `implementation_cross_check`.
- The `.mod` confirms `model(linear)` and labels the main model block with B1-B23 equations: domestic/import/export Phillips curves, wage equation, Euler equation, investment FOC, real-balances FOC, capital FOC, UIP, resource constraint, capital law of motion, utilization, loan market clearing, net foreign assets, relative prices, CPI inflation, output, employment, fiscal VAR, foreign VAR, and AR shock processes.
- No `.mod` expression is treated as paper-side mathematical evidence unless it is separately described in the Markdown source.

## Deferred Issues

- Locate and normalize the Adolfson et al. (2006) appendix or perform targeted PDF checks for appendix-level FOCs.
- Verify sector-specific import/export Phillips curves and marginal-cost definitions against a paper-side source.
- Verify steady-state equations A.2, A.3, A.6, A.9-A.12, A.16-A.19 cited in the implementation comments.
- Confirm exact timing of UIP and capital services relative to physical capital in the paper appendix.
- Runtime validation is deferred; no Dynare execution was performed.

## Translation Status

- English derivation was drafted first.
- Chinese derivation was translated from the English derivation and preserves equation numbers, formulas, file paths, DOI, model ID, and `needs_review` markers.
