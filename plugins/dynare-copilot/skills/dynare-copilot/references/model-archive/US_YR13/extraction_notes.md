# US_YR13 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` line 169 maps `US_YR13` to Rychalovska (2016), DOI `10.1016/j.jedc.2016.09.014`.
- The first page / first 80 Markdown lines of `primary_full_md_path` show the expected title and author: "The implications of financial frictions and imperfect knowledge in the estimated DSGE model of the U.S. economy" and Yuliya Rychalovska.
- `mineru_run_ids` has one run (`235aee23-e4aa-4a58-8e02-dbb3676a7975`), so no alternate run was inspected.
- The row's `raw_pdf_path` exists. The PDF body was not read.

## Formula Quality

- Status: `needs_review`.
- The capital-goods producer equations, utilization equations, expected capital return, external finance premium, net worth law, monetary policy rule, resource constraint, and adaptive-learning equations are visible in the primary Markdown.
- The paper explicitly refers the rest of the Smets-Wouters microfoundations to Smets and Wouters (2007). The consumption Euler equation, production/marginal-cost relation, price Phillips curve, and wage Phillips curve are included only as inherited block summaries and are marked `needs_review`.
- MinerU OCR has localized defects around equation prose and some figure/table extracts. A targeted PDF check is recommended for (F17) wage Phillips curve details and (F22) the bank-spread term in the resource constraint.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/US_YR13_rep.mod` exists and was read only as `implementation_cross_check`.
- Cross-check confirms `model(linear)`, the adaptive-learning model label, endogenous variables including `c`, `inve`, `y`, `lab`, `pinf`, `w`, `r`, `pk`, `rk`, `nw`, `prem`, `pinf4`, and exogenous shocks `ea`, `eb`, `eqs`, `epinf`, `ew`, `em`.
- Cross-check also confirms derived steady-state objects such as `cgamma`, `cbetabar`, `cr`, `crk`, `cw`, `cik`, `cky`, `ciy`, `ccy`, `crkky`, `cwhlc`, and `cwly`.
- The `.mod` file was not used as a paper-side source and Dynare was not run.

## Deferred Issues

- Reconstruct a complete SW07 household, price, wage, and marginal-cost derivation from the cited source if this model is promoted beyond first-pass archive status.
- Perform targeted PDF formula review for all equations marked `needs_review`.
- Rebuild a full steady-state ordering if a runnable archive entry is later required.
- Runtime validation, Blanchard-Kahn checks, and promotion to `.agents/skills/dynare-copilot/references/model-archive/` are deferred.

## Translation Status

- English derivation was written first.
- Chinese derivation preserves the same eight-section structure and the same equation numbering `(F1)` through `(F35)`.
