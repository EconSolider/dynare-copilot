# US_CMR10 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row 113 lists `US_CMR10` as Christiano, Motto, and Rostagno (2010), "Financial factors in economic fluctuations."
- The row's `primary_full_md_path`, `raw/mmb_mineru/runs/us_cmr10_us_cmr10fa__financial_factors_in_economic_fluctuations__263275d1/full.md`, begins with "IDENTIFICATION OF FINANCIAL FACTORS IN ECONOMIC FLUCTUATIONS" by Francesco Furlanetto, Francesco Ravazzolo, and Samad Sarferaz. Its linked row `raw_pdf_path` also has PDF metadata title "Identification of Financial Factors in Economic Fluctuations*".
- The same index row lists two MinerU runs. The alternate run `raw/mmb_mineru/runs/us_cmr10_us_cmr10fa__financial_factors_in_economic_fluctuations__7ef56ea6/full.md` is the CMR ECB Working Paper No. 1192 and was used as the paper-side equation source.
- The correct local PDF appears to be `raw/mmb_papers/Financial factors in economic fluctuations - small version with financial accelerator.pdf`. It exists and has PDF metadata title "Financial factors in economic fluctuations." Per instructions, the PDF body was not read.

## Formula Quality

- Status: `needs_review`.
- Appendix A provides a list of first-order/equilibrium conditions. I used those as the equation backbone and renumbered them `(F1)` through `(F38)` for the archive entry.
- Several formulas are OCR-sensitive or partially damaged in the Markdown and are marked `needs_review` in the English and Chinese derivations:
  - standard debt contract optimality;
  - entrepreneurial-loan zero-profit condition;
  - net-worth law of motion;
  - banking services production;
  - household liquidity/money choice equations;
  - Calvo wage auxiliary equations;
  - resource constraint.
- No missing formula was invented. Where OCR made a long adjustment-cost term unreliable, the derivation preserves a high-level placeholder and marks it `needs_review`.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/US_CMR10_rep.mod` exists and was read only as `implementation_cross_check`.
- The `.mod` confirms the US suffix convention (`*U`), a nonlinear `model;` block, a parallel flexible-price block, variables corresponding to the archive table, and AR(1)-style shock equations.
- The `.mod` was not treated as paper-side evidence and was not run.

## Deferred Issues

- Fix or review `raw/mmb_mineru/model_index.csv` so the `primary_full_md_path` and `raw_pdf_path` for `US_CMR10` point to the CMR run/PDF rather than the Furlanetto-Ravazzolo-Sarferaz VAR paper.
- Perform targeted PDF checks for equations marked `needs_review`, especially Appendix A equations A.11-A.13 and A.20-A.27.
- Reconstruct a full steady-state solution ordering from the original replication package and steady-state `.mat` file if this archive entry is later promoted toward runnable model replication.
- Confirm whether `US_CMR10` should represent the full baseline model and whether `US_CMR10fa` should receive a distinct reduced financial-accelerator variant entry.

## Translation Status

- English derivation drafted first.
- Chinese derivation translated from the checked English draft.
- Equation numbers `(F1)` through `(F38)` are preserved in both files.
