# EA_AWM05 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row for `EA_AWM05` has `mineru_match_status=matched`, `mineru_match_score=1.0000`, and `model_title_match_score=1.0000`.
- First-page/first-80-line sniff of `full.md` showed the expected title and authors: Dieppe, Kuester, and McAdam. No title/author mismatch was found.
- The raw PDF path exists and was recorded for provenance. The PDF body was not read.
- No appendix normalization exists at `docs/mmb_appendix_full_normalizations/EA_AWM05.md`.

## Formula Quality

- The indexed paper is mainly an optimal monetary policy-rule analysis using the AWM. It gives the policy loss function and generalized Taylor-style rules clearly.
- The paper does not reproduce the full private-sector AWM equation listing; it refers readers to Fagan et al. (2001) and Dieppe and Henry (2004). For that reason, private-sector blocks in the derivation are marked `implementation_cross_check` and `needs_review`.
- MinerU OCR for the policy-rule equations is usable but has minor missing parameter-name artifacts in prose and tables.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/EA_AWM05_rep.mod` exists and was read only as `implementation_cross_check`.
- The implementation is declared as `model(linear)`.
- The implementation header cites "An Area-Wide Model (AWM) for the Euro Area" by Gabriel Fagan, Jerome Henry, and Ricardo Mestre. This is the underlying AWM model documentation, while the indexed paper is the Dieppe-Kuester-McAdam policy-rule application.
- Cross-check highlights:
  - Modelbase variables include `interest`, `inflation`, `inflationq`, `outputgap`, and `output`.
  - The short-rate rule includes current, lagged, and forward inflation/output terms plus a monetary policy innovation.
  - `interest_` and `fiscal_` are Modelbase shocks; many `innoe*` residuals support empirical AWM blocks.
  - Stock variables such as `ksr`, `nfa`, and `gdn` use lagged accumulation equations.

## Deferred Issues

- Full AWM private-sector equations should be source-checked against the Fagan-Henry-Mestre AWM documentation before this is promoted beyond first-pass `needs_review`.
- The compact equation summary is not a complete one-for-one reconstruction of all MMB `.mod` equations and auxiliary lag variables.
- No Dynare runtime validation was performed.
- No shared `catalog.csv` or `status.csv` rows were edited; proposed rows are in `worker_report.json`.

## Translation Status

- English derivation was drafted first.
- Chinese derivation was translated from the English entry.
- `(F#)` numbering was preserved across English and Chinese.
