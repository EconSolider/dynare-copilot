# ESREA_FIMOD12 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row: `ESREA_FIMOD12`.
- Primary Markdown: `raw/mmb_mineru/runs/esrea_fimod12__fimod_a_dsge_model_for_fiscal_policy_simulations__962e806e/full.md`.
- Raw PDF exists: `raw/mmb_papers/FiMod—A DSGE model for fiscal policy simulations.pdf`.
- First-page/title sniff: matched expected title `FiMod -- A DSGE model for fiscal policy simulations` and authors Nikolai Stahler / Carlos Thomas.
- `source_index_issue`: none found; no alternate MinerU run inspection was needed because the row has a single run id and the primary source matches.

## Formula Quality

Status: `needs_review`.

- The household, production, labor-market, fiscal, international, and monetary-policy blocks were extracted from the MinerU Markdown.
- The model is large and two-country; the English derivation records the home-country equations and notes the symmetric foreign-country block rather than duplicating every foreign equation.
- (F4) investment/Tobin's Q is marked `needs_review` because MinerU OCR damages the exponent/placement in the paper's Eq. (16). The written formula follows the intended adjustment-cost structure and implementation cross-check.
- (F13)-(F15) Calvo pricing is represented in recursive form consistent with the implementation cross-check; the paper presents a compact infinite-sum FOC.
- (F25) wage-bargaining sharing rule is condensed with auxiliary terms because the source equation has OCR noise in tax-rate notation.
- (F37) current-account timing/deflator conventions should be checked against the PDF before code generation.
- (F41) Taylor rule uses the implementation-cross-check multiplicative nonlinear form; the paper describes the monetary rule around the international-linkages section and the implementation clarifies the exact observable combination.

## Appendix Normalization

- `docs/mmb_appendix_full_normalizations/ESREA_FIMOD12.md` was checked and does not exist.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/ESREA_FIMOD12_rep.mod` exists and was used only as `implementation_cross_check`.
- Cross-check confirmed the home/foreign duplicated structure, key variable names, nonlinear model form, fiscal-rule shocks, matching variables, Calvo auxiliaries, public-capital accumulation, terms of trade, current account, and union Taylor rule.
- The `.mod` file was not treated as a paper-side mathematical source.

## Deferred Issues

- Complete steady-state reconstruction is deferred. The paper reports calibration targets and the implementation has a long calibration block, but this task did not assign runtime validation.
- Several fiscal-rule variants differ between the paper's generic rules and the MMB implementation's operational equations.
- PDF body was not read; raw PDF existence and hash were recorded only.
- Dynare was not run.
- No derivation was promoted into `.agents/skills/dynare-copilot/references/model-archive/`.

## Translation Status

- English derivation was drafted first.
- Chinese derivation was translated from the English core and preserves the eight-section structure and `(F#)` numbering.
