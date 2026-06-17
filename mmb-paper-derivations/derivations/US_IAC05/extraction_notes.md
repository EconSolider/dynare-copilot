# US_IAC05 extraction notes

## Source Match

- `US_IAC05` maps to Iacoviello (2005), "House prices, borrowing constraints, and monetary policy in the business cycle."
- The `raw/mmb_mineru/model_index.csv` row reports `mineru_match_score=1.0000` and `model_title_match_score=1.0000`.
- The primary Markdown heading and author line match the expected title and Matteo Iacoviello.
- Raw PDF exists at `raw/mmb_papers/House prices, borrowing constraints, and monetary policy in the business cycle.pdf`.
- No `docs/mmb_appendix_full_normalizations/US_IAC05.md` file exists.

## Formula Quality

- Status: `needs_review`.
- The first-pass derivation uses the paper appendix's complete log-linearized extended model as the central equation source.
- Several appendix equations are OCR-normalized from noisy Markdown line breaks. The most important review points are:
  - entrepreneurial housing-consumption margin (A4), where Markdown/OCR suggests an extra `r` near the real-rate term;
  - patient household housing equation (A6), especially the adjustment-cost bracket;
  - steady-state ratios, where the appendix reports ratios but not a complete standalone normalized steady-state algorithm.
- No raw PDF body check was performed because the title/source match was clean and the task did not require targeted PDF verification. The above items should be checked against the PDF before status promotion.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/US_IAC05_rep.mod` exists and was read only as `implementation_cross_check`.
- The `.mod` confirms the reduced log-linear model variables: `Yhat`, `chat`, `c1hat`, `c2hat`, `Ihat`, `Khat`, `Xhat`, `qhat`, `bhat`, `b2hat`, `hhat`, `h2hat`, `pihat`, `Rhat`, `rrhat`, `jhat`, `Ahat`, and `uhat`.
- The `.mod` confirms exogenous innovations: `ejhat`, `euhat`, `eAhat`, `eRhat`.
- The `.mod` was not copied as a source of paper mathematics and was not executed.

## Translation Status

- English derivation was written first.
- Chinese derivation was then translated from the English artifact.
- Equation numbers `(F1)` through `(F18)` are preserved in both versions.
- File paths, model ID, DOI, and `needs_review` markers were preserved.

## Deferred Issues

- Runtime validation is deferred; Dynare was not run.
- PDF-level formula audit is deferred.
- Shared `catalog.csv` and `status.csv` were intentionally not edited; proposed rows are recorded in `worker_report.json` for later main-agent merging.
