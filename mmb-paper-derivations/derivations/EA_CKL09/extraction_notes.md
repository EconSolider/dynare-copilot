# EA_CKL09 Extraction Notes

Status: `needs_review`

## Source Match

- `raw/mmb_mineru/model_index.csv` row has `model_id=EA_CKL09`, title "The role of labor markets for euro area monetary policy", DOI `10.1016/j.euroecorev.2009.04.007`, and `model_title_match_score=1.0000`.
- Primary Markdown exists: `raw/mmb_mineru/runs/ea_ckl09_nk_ckl09__the_role_of_labor_markets_for_euro_area_monetary_policy__c6a4d4a1/full.md`.
- Raw PDF exists and was recorded for provenance: `raw/mmb_papers/The role of labor markets for euro area monetary policy.pdf`.
- The PDF body was not read.
- First 80 Markdown lines matched the expected paper title and authors.
- No appendix normalization file exists at `docs/mmb_appendix_full_normalizations/EA_CKL09.md`.

## Formula Quality

- Main Section 2 nonlinear blocks are readable: household Euler equation, CES retail aggregation, Calvo price-setting FOC, matching function, employment law of motion, wage-value equations, firm value, vacancy free entry, policy rule, government budget, and market clearing.
- Appendix A linearized equations are usable but contain OCR noise in several wage-bargaining equations. The English and Chinese derivations mark these as `needs_review`.
- The first-pass entry preserves equation numbers `(F1)` through `(F37)` across English and Chinese.
- No source-level PDF formula check was performed.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/EA_CKL09_rep.mod` exists and was used only as `implementation_cross_check`.
- Cross-check findings:
  - The implementation uses `model(linear)`.
  - Endogenous variables include `ct`, `lambdat`, `mct`, `mt`, `nt`, `Pit`, `Piannt`, `qt`, `Rt`, `st`, `ut`, `vt`, `wstart`, `wt`, `xLt`, `yt`, wage-surplus auxiliaries, and flexible-price/flexible-wage counterparts.
  - Exogenous innovations include risk-premium, cost-push, technology, monetary-policy, government-spending, bargaining-power, vacancy-cost, and separation-rate innovations.
  - The `.mod` corresponds to the estimated Section 5 version rather than the pure calibrated baseline.
- The `.mod` was not treated as paper-side mathematical evidence.

## Deferred Issues

- Check Appendix A wage derivative equations `(F13)` and `(F14)`, reset firm value `(F16)`, and reset worker surplus `(F17)` against the PDF or another clean source before promoting beyond `needs_review`.
- Decide whether a future reviewed archive should fully expand the flexible-price/flexible-wage counterpart system or keep it as a policy-gap convention.
- Runtime validation, equation-count validation against Dynare, BK checks, and IRF checks are deferred.

## Translation Status

- Chinese derivation was translated from the English draft after the English structure was completed.
- Formula blocks and `(F#)` numbering were preserved.
