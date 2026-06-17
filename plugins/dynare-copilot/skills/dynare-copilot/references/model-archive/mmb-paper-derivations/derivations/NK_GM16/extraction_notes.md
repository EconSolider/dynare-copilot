# NK_GM16 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row 68 maps `NK_GM16` to "Understanding the Gains from Wage Flexibility: The Exchange Rate Connection" with DOI `10.1257/aer.20131658`.
- `model_title_match_score` is `1.0000`; `primary_source_match_score` is `1.0000`; `model_match_notes` is empty.
- Primary Markdown exists at `raw/mmb_mineru/runs/nk_gm16__understanding_the_gains_from_wage_flexibility_the_exchange_rate_connecti__f3573fbb/full.md`.
- Raw PDF exists at `raw/mmb_papers/Understanding the Gains from Wage Flexibility- The Exchange Rate Connection.pdf`. The PDF body was not read; only path existence and hash were checked.
- No `docs/mmb_appendix_full_normalizations/NK_GM16.md` file exists.

## Formula Quality

- The baseline model and appendix equilibrium equations are legible enough in MinerU Markdown to draft a first-pass archive entry.
- OCR noise appears in appendix prose around risk-sharing notation, marginal-cost definitions, and constants in the natural equilibrium. Those pieces were not silently treated as exact prose; the derivation uses the clean main-text equilibrium system and the clearer appendix equations.
- The source paper's core model is a log-linear equilibrium system. This entry therefore records steady state as zero log deviations and stores natural-allocation equations for gap construction.
- Status remains `needs_review` until a human or targeted PDF check verifies every normalized equation.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/NK_GM16_rep.mod` exists and was used only as `implementation_cross_check`.
- The `.mod` confirms `model(linear)`, all variables are log deviations from respective steady states, and the active policy regime is currency union (`e=0`).
- The `.mod` confirms endogenous names including `y`, `c`, `s`, `z`, `zx1`, `zx2`, `i`, `dpc`, `e`, `p`, `n`, `a`, `dp`, `t`, `wp`, `dw`, `w`, `pc`, `r`, `de`, gap variables, natural variables, and graph transforms.
- The `.mod` graph variables `ngraph`, `igraph`, `rgraph`, and `sgraph` were recorded as reporting transformations, not as independent economic conditions.

## Deferred Issues

- No runtime validation was performed; no Dynare `steady`, `check`, or simulation output is claimed.
- The paper discusses a richer DSGE robustness model with habit formation, capital accumulation, import distribution, local-currency import pricing, indexation, and an exchange-rate-augmented policy rule. The MMB replication file for `NK_GM16` corresponds to the simpler baseline currency-union `model(linear)` system, so the robustness extension is recorded only as context.
- The paper's notation uses `\upsilon` and `v` for openness in different OCR renderings. The derivation standardizes on `\nu`, matching the MMB implementation's `nu`.
- The strict inflation-targeting alternative `\pi_{H,t}=0` is included as a paper regime, but not as the active MMB policy equation.
- Targeted PDF checks may be useful for constants in the natural equilibrium and for the exact printed policy-rule notation in the robustness section.

## Translation Status

- English derivation was drafted first.
- Chinese derivation preserves the same eight section headings, all file paths, status markers, DOI, model ID, and all F-number labels `(F1)` through `(F40)`.
- LaTeX formulas were kept identical across the English and Chinese files except for surrounding translated prose.
