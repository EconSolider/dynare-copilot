# EA_SWW14 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row for `EA_SWW14` reports a clean match: `mineru_match_status=matched`, `mineru_match_score=1.0000`, `model_title_match_score=1.0000`.
- The first Markdown page matches the expected title, "Professional forecasters and real-time forecasting with a DSGE model", and the authors Frank Smets, Anders Warne, and Rafael Wouters.
- `mineru_run_ids` contains only `2118a8eb-5532-46a0-a3fb-bbbf4871f8d4`; no alternate MinerU run needed inspection.
- `source_index_issue`: none detected.
- Raw PDF exists at `raw/mmb_papers/Professional forecasters and real-time forecasting with a DSGE model.pdf`; the PDF body was not read.

## Formula Quality

- Status: `needs_review`.
- The paper's Section 2 provides the main log-linearized GSW equilibrium conditions, measurement equations, and steady-state transformations.
- OCR artifacts remain around several shock superscripts and markup equations, especially the price-markup/marginal-cost sentence and the wage/natural unemployment block.
- The price markup relation in (F5) is written with an approximate sign and marked `needs_review` because the source states the average price markup as inverse marginal cost while the implementation uses `-mc+100*epsilonp` in the Phillips curve.
- The wage observation row in (F20) is marked `needs_review`: the source Markdown shows `Delta w - Delta pi` on the right-hand side, while the implementation cross-check uses `dwobs-piobs=...`.
- The monetary-policy shock sign in (F30) is marked `needs_review`: the source equation adds the monetary-policy shock, while the implementation cross-check has `-epsilonr`.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/EA_SWW14_rep.mod` exists and was used only as `implementation_cross_check`.
- The `.mod` confirms `model(linear)`, the endogenous variable list, eight structural innovations, a flexible-price/wage counterpart block, output-gap definition, shock processes, and measurement equations.
- Information learned only from the `.mod`, such as explicit flexible-block equations and exact Rep-MMB ASCII names, is labeled as implementation cross-check rather than paper-side source evidence.
- Dynare was not run.

## Deferred Issues

- Source-level PDF check of the printed equations may be needed for the price markup sign, wage measurement row, and monetary-policy shock sign.
- A future validation pass should compare equation count and variable count after deciding whether measurement equations and SPF-conditioning equations belong in the runnable model block or only in the estimation/state-space layer.
- The paper's SPF news/noise forecasting layer should be separated from the benchmark structural model when building a `.mod` implementation.

## Translation Status

- English derivation drafted first.
- Chinese derivation translated from the English derivation with the same eight-section structure and preserved `(F#)` numbering.
