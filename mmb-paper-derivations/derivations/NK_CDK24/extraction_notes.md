# NK_CDK24 Extraction Notes

## Source Match

- `NK_CDK24` matched exactly in `raw/mmb_mineru/model_index.csv`.
- Primary source title: `Energy prices and household heterogeneity- Monetary policy in a Gas-TANK`.
- DOI: `10.1016/j.jmoneco.2024.103620`.
- MinerU run id: `9fe20b52-3cba-4756-b83c-e96a5eb2719b`.
- Raw PDF path exists: `raw/mmb_papers/Energy prices and household heterogeneity- Monetary policy in a Gas-TANK.pdf`.
- PDF body was not read; Markdown was sufficient for first-pass extraction.

## Formula Quality

- Status: `needs_review`.
- The main model equations are present in the Markdown, especially the household budget constraints, Euler equation, CES production function, factor demands, price setting, import/export equations, Taylor rule, shock processes, log-linear block, dynamic IS equation, consumption-gap decomposition, markup equation, and labor-share equation.
- OCR uncertainty remains in the household-type notation around the constrained share, in the production-cost multiplier notation around $`\tau_t^Z`$, and in several references to appendix material.
- The appendix key-parameter table is referenced by the paper text but is not visible in the extracted Markdown.

## Implementation Cross-Check

- Optional cross-check file was not present: `.agents/skills/dynare-copilot/references/examples/NK_CDK24_rep.mod`.
- No MMB `.mod` file was used as a mathematical source.

## Scope Choices

- The derivation focuses on the baseline Gas-TANK model with energy as a production input.
- Section 5 of the paper, where imported energy enters household consumption baskets, was checked and noted but not included in the baseline equation set because the MMB row is not labeled as a separate consumption-energy variant.
- Ramsey-optimal policy discussion was treated as an experiment on the same private-sector conditions, not as a separate equation system for this first-pass archive entry.

## Deferred Issues

- Recover supplementary appendix tables or inspect the PDF only if a later pass needs exact steady-state ratios and complete calibration details.
- Verify whether implementation uses the paper's $`R_t`$ notation as a nominal policy rate or separates nominal and real rates differently in code.
- Source-check the wage block against Appendix A.2 if a runnable `.mod` implementation is later produced.
- Runtime validation, residual checks, Blanchard-Kahn checks, and IRF replication were not performed.

## Translation Status

- English derivation drafted first.
- Chinese derivation translated from the English core.
- Equation numbers `(F1)` through `(F35)` are preserved in both files.
