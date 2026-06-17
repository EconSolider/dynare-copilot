# US_ACELswt Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row for `US_ACELswt` has `mineru_match_status=matched`, `mineru_match_score=1.0000`, `primary_source_title=Firm-specific capital, nominal rigidities`, and `model_title_match_score=1.0000`.
- The first 80 Markdown lines contain the expected title, author block, and abstract for Altig, Christiano, Eichenbaum, and Linde.
- Raw PDF exists at `raw/mmb_papers/Firm-specific capital, nominal rigidities.pdf`; it was not opened because the Markdown supplied enough first-pass structure and the user did not ask for PDF-level formula auditing.
- No appendix normalization exists at `docs/mmb_appendix_full_normalizations/US_ACELswt.md`.

## Formula Quality

- Status: `needs_review`.
- Paper-side equations extracted directly include the final-good aggregator and demand, intermediate production technology, technology scaling, household preferences and budget, money-demand FOC, wage aggregator/demand/indexation, capital-service and capital-accumulation equations, resource constraint, loan-market clearing, policy/shock processes, and the reduced-form inflation equation.
- Several coefficient-level linear equations in `US_ACELswt_rep.mod` are marked `implementation_cross_check` and `needs_review` because the cited technical appendix is referenced in the paper but not present as a local source normalization.
- The exact nonlinear function mapping firm-specific-capital parameters into `chi` in the inflation slope is not present in the MinerU Markdown and remains a deferred issue.

## Implementation Cross-Check

- Read `.agents/skills/dynare-copilot/references/examples/US_ACELswt_rep.mod` only as implementation cross-check.
- The `.mod` declares `model(linear)` and uses sticky-price variables plus flexible-price counterparts.
- The implementation includes 16 commented sticky-price equations, analogous flexible-price equations, and shock processes for monetary, neutral technology, embodied technology, and transitory neutral technology shocks.
- The file comments state that this version produces correct impulse responses to neutral and investment-specific technology shocks without the cost channel (`nu = 0`), but wrong answers to monetary policy shocks because variables are not predetermined. This is recorded as an implementation caveat, not a source-paper claim.
- Dynare was not run.

## Deferred Issues

- Verify the coefficient-level equations against Altig et al. (2004), "Technical Appendix to Firm-Specific Capital, Nominal Rigidities and the Business Cycle."
- Audit whether `US_ACELswt` should be described as sticky price and sticky wage with the specific MMB timing caveat or split more finely from the sibling ACEL model IDs.
- Confirm the exact interpretation of the MMB variable `R_t` in the linear block, because the paper notation uses `R_t` for a gross interest rate while the implementation comments replace the monetary policy rule in model-base form.
- Check whether the additional transitory neutral technology shock in the implementation should remain in the archive reference table for this MMB row after a full source/code review.

## Translation Status

- English derivation drafted first.
- Chinese derivation is a direct translation of the English core with identical section order, file paths, model ID, DOI, status markers, and equation numbers `(F1)` through `(F38)`.

## Runtime Validation

- Not performed. The user explicitly instructed: "Do not run Dynare."
