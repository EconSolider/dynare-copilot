# US_FRB03 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row for `US_FRB03` has `mineru_match_status=matched`, `mineru_match_score=1.0000`, `model_title_match_score=1.0000`, and no `model_match_notes`.
- First 80 Markdown lines show the expected title, "The Performance of Forecast-Based Monetary Policy Rules Under Model Uncertainty."
- The model index author field lists `Levin, Andrew; Wieland, Volker; Taylor, John B.`, while the paper title page lists Andrew Levin, Volker Wieland, and John C. Williams. This entry preserves the index value in provenance and records the paper-side author mismatch as a metadata issue for later index review.
- Primary Markdown: `raw/mmb_mineru/runs/nk_lww03_nk_lww03al_us_frb03__the_performance_of_forecast_based_monetary_policy_rules_under_model_unce__c97e3d2f/full.md`.
- Raw PDF path exists: `raw/mmb_papers/The Performance of Forecast-Based Monetary Policy Rules under Model Uncertainty.pdf`.
- No appendix normalization file exists at `docs/mmb_appendix_full_normalizations/US_FRB03.md`.

## Extraction Scope

- English derivation was drafted first using the required eight-section structure.
- Chinese derivation is a direct translation of the English core and preserves `(F#)` numbering, file paths, DOI values, model ID, and `needs_review` markers.
- The paper is a cross-model policy-rule evaluation article. It summarizes FRB-US qualitatively and prints the policy-rule/loss-function equations, but it does not print the full FRB-US structural equation system.
- The `.mod` file `.agents/skills/dynare-copilot/references/examples/US_FRB03_rep.mod` was read only as `implementation_cross_check`.

## Formula Quality

- Overall formula status: `needs_review`.
- MinerU Markdown captured the main policy and evaluation formulas: forecast-based policy rule (1), benchmark federal funds rule (4), loss function (5), average-loss criterion (6), and robust benchmark rule (7).
- The article's FRB-US content is not a full source for private-sector FOCs, market-clearing conditions, or exact FRB-US stock timing. The derivation therefore does not invent household/firm FOCs and explicitly marks detailed FRB-US structure as deferred.
- OCR quality is adequate for the printed policy-rule equations after light normalization, but source-level review should compare equations (F1)-(F7) against the PDF before promoting beyond `needs_review`.
- The PDF body was not opened because the Markdown was sufficient for a first-pass extraction and the task contract says not to read the PDF body by default.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/US_FRB03_rep.mod` exists and was read only as `implementation_cross_check`.
- The `.mod` confirms this is the linearized version of the FRB-US model used in LWW (2003).
- The `.mod` maps modelbase variables as `interest = rffe`, `inflation = (1/4)*(picnia + picnia(-1) + picnia(-2) + picnia(-3))`, `inflationq = picnia`, `outputgap = xgap2`, and `output = xgdp*100`.
- The `.mod` uses `interest_` as the active shock in the final shock block and comments out longer simulation commands in favor of a no-moments `stoch_simul` setup.
- The `.mod` includes a large number of endogenous variables and shocks across consumption, durable consumption, housing, investment, labor, government, financial variables, expectation auxiliaries, and lag/lead helper variables. These details were not copied into the paper-side derivation because the `.mod` is not the mathematical source.
- Dynare was not run.

## Deferred Issues

- Review whether the model-index author field should be corrected from John B. Taylor to John C. Williams in a later shared-index pass. Shared CSVs were not edited in this task.
- Locate or normalize FRB-US documentation, especially Brayton et al. (1997) and Reifschneider et al. (1999), before attempting a complete FRB-US structural derivation.
- Check stock timing, expectation auxiliaries, and internal sector equations against FRB-US documentation rather than deriving them from the `.mod` alone.
- Runtime validation, residual checks, BK checks, IRF checks, and promotion to the runnable skill archive were not performed.

## Translation Status

- English derivation completed first.
- Chinese translation completed second.
- English and Chinese `(F#)` counts match in validation.
