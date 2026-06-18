# EA_CW05ta Extraction Notes

Status: `needs_review`

## Source Match

- `raw/mmb_mineru/model_index.csv` row for `EA_CW05ta` reports a full title match score of `1.0000`.
- Primary Markdown: `raw/mmb_mineru/runs/ea_cw05fm_ea_cw05ta__a_small_estimated_euro_area_model_with_rational_expectations_and_nominal__61e070cd/full.md`.
- Raw PDF path exists: `raw/mmb_papers/A small estimated euro area model with rational expectations and nominal rigidities.pdf`.
- PDF body was not read, per task instruction.
- First 80 Markdown lines show the expected title and Coenen/Wieland authors. Minor OCR mismatch: author first name appears as `Gunter`, while metadata uses Guenther/Gunther; OCR also contains substitutions such as `in1ation`, `2t`, and `di@erent`.

## Appendix Normalization

- No optional appendix normalization file exists at `docs/mmb_appendix_full_normalizations/EA_CW05ta.md`.

## Formula Extraction

- Core model equations were extracted from:
  - Table 1: overlapping-contract price/wage block.
  - Table 4: aggregate demand, policy rule, term structure, and long real rate.
  - Section 5 text: steady-state interpretation of output gap, long real rate, and inflation target.
  - Table 5: euro-area aggregate-demand coefficient source cue.
- The derivation targets the `EA_CW05ta` Taylor nominal wage-contract variant. The paper also discusses RW, RW-C, and RW-S variants; those are not used as the defining wage-contract block for this entry.
- First-pass uncertainty remains around the exact MMB transformation from the paper's price-level equations into implementation helper variables (`cwp`, `pi1`, lag aliases, and finite leads). This is marked `needs_review`.

## Implementation Cross-Check

- Cross-check file read: `.agents/skills/dynare-copilot/references/examples/EA_CW05ta_rep.mod`.
- Confirmed variant: Taylor (1980) nominal wage contracting model.
- Confirmed form: `model(linear)`.
- Confirmed MMB aliases: `interest = is`, `inflation = infl`, `outputgap = q`.
- Confirmed shocks: `e_cw`, `fiscal_`, and `interest_`.
- Confirmed that the implementation uses Gerdesmeier-Roffia-style smoothed policy-rule coefficients and helper lag variables; these are treated as implementation cross-check evidence only, not paper-side math evidence.

## Deferred Issues

- Source-level formula review against the PDF was not performed.
- Exact coefficient mapping between Table 4 policy-rule notation and the smoothed implementation rule needs review before any runnable archive promotion.
- Exact price-level normalization and inflation detrending used by the MMB conversion needs review.
- Dynare was not run and runtime validation is explicitly deferred.

## Translation Status

- English derivation was drafted first.
- Chinese derivation was translated from the English derivation.
- `(F#)` numbering was preserved in Chinese.
