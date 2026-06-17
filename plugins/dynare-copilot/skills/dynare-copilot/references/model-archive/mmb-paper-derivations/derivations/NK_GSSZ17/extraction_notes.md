# NK_GSSZ17 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row 73 maps `NK_GSSZ17` to "Inflation Dynamics during the Financial Crisis" with match status `matched`, MinerU match score `1.0000`, model title match score `1.0000`, and DOI `10.1257/aer.20150248`.
- Primary source Markdown used: `raw/mmb_mineru/runs/nk_gssz17__inflation_dynamics_during_the_financial_crisis__85a7350a/full.md`.
- Raw PDF path exists and was recorded for provenance: `raw/mmb_papers/Inflation Dynamics during the Financial Crisis.pdf`. The PDF body was not read.
- No appendix normalization file was present at `docs/mmb_appendix_full_normalizations/NK_GSSZ17.md`.

## Formula Quality

- The main model equations in the paper Markdown are usable for first-pass extraction: preferences, habit aggregator, demand, production, flow of funds, firm Lagrangian, FOCs, financing trigger, internal-funds wedge, markup, Rotemberg price adjustment, Phillips curve, SDF, Fisher equation, labor condition, Taylor rule, and heterogeneous-firm aggregation were extracted.
- Several formulas have OCR damage or ambiguity and are marked `needs_review` in the derivation:
  - Taylor rule (paper equation 29 / archive F10) has bracket/multiplication ambiguity in OCR.
  - The forward marginal-sales expression and customer-market coefficient around paper equation 23 / archive F23 should be checked against the journal PDF.
  - The log-linear Phillips curve around paper equation 25 / archive F26 should be source-level checked for hats, signs, and line-break placement.
- No long prose was copied into the derivations; prose was summarized and equations were transcribed/normalized only where the source structure was clear.

## Implementation Cross-Check

- Optional cross-check file read: `.agents/skills/dynare-copilot/references/examples/NK_GSSZ17_rep.mod`.
- Used only to check variable coverage, shock names, timing conventions, and model-block form.
- The implementation includes variables such as `xi`, `s`, `c`, `x`, `pt`, `y`, `h`, `pii`, `A`, `D`, `w`, `pS`, `m`, `dt`, `z`, `abar`, `mu`, `v`, `lambda`, `R`, `varrho`, `F`, and flexible-price counterparts.
- The implementation uses exogenous shocks `eA`, `eR`, `eF`, and `eD`.
- The implementation calibration differs from paper text in several places; these values were not treated as paper-side calibration.

## Deferred Issues

- Runtime validation was not performed; no Dynare run, residual check, steady-state solve, BK check, or IRF reproduction was attempted.
- The source does not provide a full directly copyable `steady_state_model`; the derivation records only source-derived steady-state restrictions and calibration notes.
- The exact equation-to-variable count for the implementation model is deferred because the archive task is derivation extraction, not runnable `.mod` validation.
- OCR-sensitive equations need a targeted source-level check before upgrading beyond `needs_review`.

## Translation Status

- English derivation was drafted first.
- Chinese derivation was translated from the English core after drafting.
- Equation numbers `(F1)` through `(F38)` were preserved in both English and Chinese files.
- File paths, DOI, model ID, and `needs_review` markers were preserved.
