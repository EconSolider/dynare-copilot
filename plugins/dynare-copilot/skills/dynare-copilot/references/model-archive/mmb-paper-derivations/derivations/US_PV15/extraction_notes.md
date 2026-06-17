# US_PV15 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row for `US_PV15` matches the paper title exactly: "Financial frictions and the extensive margin of activity".
- `mineru_run_ids`: `03a51d35-6914-42f0-b0e5-9d7f3e6fe7cb`.
- `model_title_match_score`: `1.0000`; `model_match_notes` is empty.
- Primary Markdown path exists: `raw/mmb_mineru/runs/us_pv15__financial_frictions_and_the_extensive_margin_of_activity__03a51d35/full.md`.
- Raw PDF path exists and is recorded for provenance: `raw/mmb_papers/Financial frictions and the extensive margin of activity.pdf`.
- No appendix-normalization file exists at `docs/mmb_appendix_full_normalizations/US_PV15.md`.

## Formula Quality

- Status is `needs_review`, as required for first-pass extraction.
- The main equation source is Appendix B.1-B.2 in the MinerU Markdown. Equations B.1-B.34 and B.35-B.53 are available, but several passages contain OCR artifacts.
- Marked uncertain formulas:
  - `F12` and `F13`: price markup / auxiliary term around $\Psi_t$ has noisy OCR and likely needs source-level PDF review.
  - `F19`: source notation around external finance premium mixes the elasticity symbols $\chi$ and $\varkappa$ in nearby text and equations.
  - `F23`: nominal lending-rate FOC has a long adjustment-cost derivative expression; first pass keeps the paper-side structure but should be checked against the PDF.
  - `F26`: source equation begins with $\varepsilon_t^I q_t`, while implementation cross-check uses `exp(s_i)*q`; likely OCR/notation issue.
  - `F29`: Taylor rule source uses both $\rho$ and $\rho_R`; implementation uses one smoothing parameter.
  - `F36`: Appendix B uses $n_{jt}$ notation while the model text and implementation use the aggregate number of firms.
- The steady-state value sentence at the end of Appendix B.2.3 is visibly corrupted/repeated in MinerU output; the value list is preserved only as approximate and remains `needs_review`.

## Implementation Cross-Check

- Cross-check file: `.agents/skills/dynare-copilot/references/examples/US_PV15_rep.mod`.
- Used only as `implementation_cross_check`, not as paper-side mathematical source.
- Cross-check confirmed:
  - Nonlinear Dynare `model` block, not `model(linear)`.
  - Additional natural/flexible counterpart variables are present for output-gap construction.
  - Dynare timing uses predetermined capital, e.g. `ku = u*k(-1)` and capital return with `q(-1)`.
  - Shock names include `e_a`, `e_g`, `e_b`, `e_i`, `e_l`, `e_n`, `e_p`, `e_w`, `e_e`, and `e_r`.
  - Implementation includes measurement equations and simulation commands, but they were not run.

## Deferred Issues

- Source-level PDF checks are needed for equations `F12`, `F13`, `F19`, `F23`, `F26`, `F29`, and `F36`.
- The treatment of the natural/flexible counterpart should be reviewed before any future `.mod` implementation work; this derivation records it only as a cross-check note.
- Runtime validation is deferred. Dynare was not run.
- Shared `catalog.csv` and `status.csv` were not edited by this worker; proposed row values are in `worker_report.json`.

## Translation Status

- English derivation was drafted first in `US_PV15_derivation.en.md`.
- Chinese translation was then written in `US_PV15_derivation.zh.md`.
- F-number counts match between English and Chinese versions.
