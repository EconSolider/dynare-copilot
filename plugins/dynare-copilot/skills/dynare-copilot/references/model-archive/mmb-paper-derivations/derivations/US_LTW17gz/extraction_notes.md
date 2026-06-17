# Extraction Notes -- US_LTW17gz

## Source Match

- `raw/mmb_mineru/model_index.csv` row `US_LTW17gz` has `mineru_match_status=matched`, `mineru_match_score=1.0000`, `primary_source_title=Clearing Up the Fiscal Multiplier Morass`, and `model_title_match_score=1.0000`.
- Primary Markdown title/authors match the expected paper: Leeper, Traum, and Walker, "Clearing Up the Fiscal Multiplier Morass."
- Raw PDF exists at `raw/mmb_papers/Clearing Up the Fiscal Multiplier Morass.pdf`; the PDF body was not opened because the Markdown contained the relevant model section and the task contract does not require reading the PDF body by default.
- No appendix normalization exists at `docs/mmb_appendix_full_normalizations/US_LTW17gz.md`.

## Formula Quality

Status: `needs_review`.

- The paper Markdown includes the model section, saver and non-saver budget constraints, capital accumulation, monetary rule, fiscal rules, aggregation, and calibration text.
- Several formulas have OCR artifacts. The highest-priority formula checks are:
  - labor aggregator and aggregate wage formula around the labor agency text;
  - wage indexation formula for non-reset wages;
  - the government budget identity;
  - the exact long-bond pricing and revaluation identities;
  - mapping from nonlinear source conditions to the log-linear coefficient form used by MMB.
- First-pass equations (F1)-(F34) deliberately retain `needs_review` markers where the `.mod` implementation clarified the log-linear form but paper-side OCR was insufficient for a source-level check.

## Implementation Cross-Check

The file `.agents/skills/dynare-copilot/references/examples/US_LTW17gz_rep.mod` was used only as `implementation_cross_check`.

Confirmed cross-check points:

- Variant label: the file states that this version replaces a government-consumption response to debt with transfer changes.
- Variant parameters: `gammgc=0`, `gammz=0.2`; capital and labor tax debt responses are zero in the checked implementation.
- Core endogenous variables include saver/non-saver consumption, policy rate, investment, effective and physical capital, utilization, labor, output, government consumption, aggregate consumption, Tobin's Q, capital returns, wage, inflation, debt, debt-output ratio, tax rates, real rate, transfers, marginal cost, saver multiplier, long-bond price, composite consumption, long-run inflation/rate variables, primary surplus, tax revenues, and observables.
- Exogenous innovations declared in the implementation are `euz`, `eua`, `eub`, `eum`, `eui`, `euw`, and `eup`; the government-consumption shock innovation is commented out while `ugc` remains in the model block. This is recorded as `needs_review`.
- The implementation has a flexible-price comparison economy with `f`-suffixed variables. The derivation records this as a counterfactual block, not a separate paper model.

## Deferred Issues

- Source-level equation verification against the published PDF or online appendix remains open.
- No Dynare runtime validation was performed and none should be inferred from this archive entry.
- The steady-state solution is summarized from the paper calibration and implementation cross-check; it remains `needs_review` until checked against paper-side replication documentation.
- Shared `catalog.csv` and `status.csv` were not edited per task ownership limits. Proposed row values are stored in `worker_report.json` and `source_manifest.json`.

## Translation Status

- English derivation was written first.
- Chinese derivation was translated from the English version second.
- Equation numbers `(F1)` through `(F34)`, file paths, model id, DOI, and status markers were preserved.
