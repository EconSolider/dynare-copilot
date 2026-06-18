# NK_MPT10 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row 86 maps `NK_MPT10` to "Unemployment fiscal multipliers" by Monacelli, Perotti, and Trigari (2010), DOI `10.1016/j.jmoneco.2010.05.009`.
- Match score is `1.0000`; primary source title is also "Unemployment fiscal multipliers" with match score `1.0000`.
- First-page OCR title and authors match the index row.
- Raw PDF exists at `raw/mmb_papers/Unemployment fiscal multipliers.pdf`.
- No `docs/mmb_appendix_full_normalizations/NK_MPT10.md` file exists.

## Formula Quality

- The baseline search-and-matching block is well preserved in the OCR Markdown: matching, firm problem, household problem, marginal utility, Nash bargaining, surplus, government budget, spending process, and resource constraint.
- The active NK section in the paper Markdown clearly states the retail-sector setup, the Taylor rule, the markup-adjusted marginal product, and the NK surplus recursion.
- `needs_review`: the paper OCR does not expose the full Calvo price-setting recursions. The derivation includes these equations only as `implementation_cross_check` from `.agents/skills/dynare-copilot/references/examples/NK_MPT10_rep.mod`.
- `needs_review`: the MMB `.mod` comments identify corrections to paper equations (22) and (28). These are useful cross-check notes but require PDF/source-level review before the archive entry can be marked reviewed.
- `needs_review`: the paper contains additional variants (unemployment benefits, wage rigidity, distortionary taxation/debt financing). The current `NK_MPT10` derivation focuses on the MMB implementation's NK Figure 11 replication and records other variants only where they inform source context.

## Implementation Cross-Check

- Cross-check file: `.agents/skills/dynare-copilot/references/examples/NK_MPT10_rep.mod`.
- Used for: variable list, parameters, monthly calibration details, implementation timing, flexible-price duplicate block, Calvo auxiliary variables, output gap, active/inactive shocks, and implementation comments.
- Not used for: independent paper-side derivation of formulas.
- Dynare was not run.

## Deferred Issues

- Source-level verification of the Calvo block against the raw PDF or a cleaner source.
- Source-level verification of the implementation comments on equation (22) and equation (28).
- Decide whether a later archive entry should separately cover the paper's non-NK baseline and section 6 robustness variants, or keep `NK_MPT10` narrowly tied to the MMB Figure 11 NK implementation.
- Runtime validation, equation-count validation, and BK/IRF checks are deferred.

## Translation Status

- English derivation drafted first.
- Chinese derivation translated from the English file with matching `(F#)` numbering.
- Both files are first-pass `needs_review`.
