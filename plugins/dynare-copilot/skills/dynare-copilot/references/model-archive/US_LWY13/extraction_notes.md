# US_LWY13 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row for `US_LWY13` has `mineru_match_status=matched`, `mineru_match_score=1.0000`, `model_title_match_score=1.0000`, and no `model_match_notes`.
- Primary Markdown: `raw/mmb_mineru/runs/us_lwy13__fiscal_foresight_and_information_flows__08be5b79/full.md`.
- First-page sniff matched the expected title and authors.
- Raw PDF path exists: `raw/mmb_papers/Fiscal foresight and information flows.pdf`.
- No appendix normalization file exists at `docs/mmb_appendix_full_normalizations/US_LWY13.md`.
- Implementation cross-check exists at `.agents/skills/dynare-copilot/references/examples/US_LWY13_rep.mod`.

## Formula Quality

- Status: `needs_review`.
- The OCR Markdown contains the analytical growth-model equations and fiscal foresight information-flow processes.
- The paper-side Markdown gives the full NK model only as a block-level description and refers details to supplemental material. The detailed NK equations in the derivation are therefore marked `implementation_cross_check`.
- The wage-setting and government-budget equations are coefficient-heavy in the `.mod` file and were compressed in the derivation with explicit `needs_review` notes.
- The raw PDF body was not opened because the Markdown source was sufficient for title/provenance and the requested first-pass extraction.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/US_LWY13_rep.mod` was used only as `implementation_cross_check`.
- The implementation uses `model(linear)`.
- Endogenous variables include Ricardian and non-Ricardian consumption (`cr`, `cnr`), interest and inflation variables, investment, capital, utilization, labor, output, government variables, capital and labor taxes, flexible-price counterparts, output gap, and MMB reporting variables.
- Exogenous innovations include technology, preference, investment, wage markup, price markup, capital-tax, labor-tax, and transfer shocks; MMB also exposes `interest_` and `fiscal_`.
- The implementation uses lagged capital in production and flexible-price counterparts to define `ygap`.
- Dynare was not run.

## Deferred Issues

- Review the supplemental material or paper PDF for the full NK model equation list before promoting beyond first pass.
- Reconcile the compressed wage-setting and government-budget equations against source-level formulas.
- Confirm whether the model archive should privilege the analytical paper model, the quantitative NK application, or both as separate variants in future review.
- Runtime validation, BK checks, and IRF checks are deferred.

## Translation Status

- English derivation was drafted first.
- Chinese derivation is a direct translation of the English draft.
- Equation numbers `(F1)` through `(F35)` are preserved in both versions.
