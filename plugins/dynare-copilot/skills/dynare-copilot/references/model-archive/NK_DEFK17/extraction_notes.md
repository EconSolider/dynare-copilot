# NK_DEFK17 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` maps `NK_DEFK17` to "The Great Escape? A Quantitative Evaluation of the Fed's Liquidity Facilities" with `mineru_match_status=matched`, `mineru_match_score=1.0000`, and `model_title_match_score=1.0000`.
- Primary full Markdown: `raw/mmb_mineru/runs/nk_defk17__the_great_escape_a_quantitative_evaluation_of_the_fed_s_liquidity_facili__b6479bed/full.md`.
- Raw PDF path exists: `raw/mmb_papers/The Great Escape? A Quantitative Evaluation of the Fed's Liquidity Facilities.pdf`.
- Raw PDF body was not read. The existence check was sufficient for provenance under this task.

## Formula Quality

- The paper body provides usable equations for the household objective, flow of funds, borrowing/resaleability constraints, entrepreneur binding constraints, aggregate investment, bond and equity Euler equations, convenience-yield definition, Taylor rule, liquidity intervention rule, government budget constraint, fiscal rule, capital ownership, and resource constraint.
- The paper body states that final/intermediate-good firms, capital producers, and labor-market details are standard CEE/SW blocks and refers the detailed formulas to online Appendices B.1-B.3.
- `docs/mmb_appendix_full_normalizations/NK_DEFK17.md` does not exist, so detailed price/wage/capital-producer recursive equations are marked `needs_review`.
- The MinerU Markdown around the narrative explanation after equations (16)-(17) contains visible OCR noise; equations (16)-(17) themselves were usable enough for a first-pass archive draft.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/NK_DEFK17_rep.mod` exists and was read only as `implementation_cross_check`.
- The `.mod` confirms a nonlinear MMB implementation with endogenous variables `C`, `Inv`, `S_Inv`, `dS_Inv`, `H`, `Y`, `tau`, `K`, `N`, `Ng`, `LY`, `Q`, `pI`, `RK`, `rK`, `rr`, `rr0`, `ERQ`, `w`, `infl_w`, `X1w`, `X2w`, `mc`, `infl`, `X1p`, `X2p`, `Delta_p`, `CY`, `Spr`, `phi`, `QK`, and `GDP`.
- The `.mod` confirms the single exogenous innovation `e_phi`.
- The `.mod` includes implementation-specific timing, including production with `K(-1)` and the investment equation using lagged `N`, `LY`, and `Y`. This was recorded in the derivation but not treated as paper-side mathematical evidence.

## Deferred Issues

- Source-level checking of the detailed Calvo price block, Calvo wage block, capital-producer equation, and steady-state recursion requires either the online appendix or a normalized appendix extraction.
- Runtime validation, Dynare `steady`, residual checks, ZLB path validation, and perfect-foresight simulation were not performed.
- The English and Chinese derivations should remain `needs_review` until the appendix-level equations are checked against a paper-side source.

## Translation Status

- English derivation drafted first.
- Chinese derivation translated from the English version.
- Equation numbering `(F1)` through `(F35)` is preserved across English and Chinese files.

## Shared Indexes

- `mmb-paper-derivations/derivations/catalog.csv` was not edited.
- `mmb-paper-derivations/derivations/status.csv` was not edited.
- Proposed rows are recorded only inside `source_manifest.json`.
