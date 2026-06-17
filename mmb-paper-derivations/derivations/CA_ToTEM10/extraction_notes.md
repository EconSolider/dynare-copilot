# CA_ToTEM10 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row found for `CA_ToTEM10`.
- Match status: `matched`.
- MinerU match score: `1.0000`.
- Model title match score: `1.0000`.
- Primary Markdown: `raw/mmb_mineru/runs/ca_totem10__totem_the_bank_of_canada_s_new_canadian_projection_model__1f1558b7/full.md`.
- Raw PDF exists: `raw/mmb_papers/ToTEM- The Bank of Canada's New Canadian Projection Model.pdf`.
- PDF body was not opened, per task rule. It is recorded for provenance only.
- No appendix normalization file exists at `docs/mmb_appendix_full_normalizations/CA_ToTEM10.md`.

## Formula Quality

The primary Markdown is a Bank of Canada overview article. It describes ToTEM's agents, sectors, nominal rigidities, calibration strategy, and illustrative shocks, but it does not include a formal mathematical appendix with a full equilibrium system.

Consequences:

- The derivation is a structural block map, not a verified complete equation system.
- Equations are marked `needs_review` wherever the exact algebra is not printed in the Markdown.
- No missing formula was silently filled in from the PDF body.
- No targeted PDF formula check was performed because the source limitation is broad and expected from the article type, not a localized OCR failure.

## Implementation Cross-Check

Read `.agents/skills/dynare-copilot/references/examples/CA_ToTEM10_rep.mod` only as `implementation_cross_check`.

Used for:

- exogenous shock names: `lyrow_shk`, `lpcomrow_shk`, `lxdc_shk`, `lforexn_shk`, `lc_shk`, `la_shk`, `gn_yn_shk`;
- policy-rule cues: `r1n`, `infq2`, `pertarget`, `pertran`, `ly_gap`, `smooth1`, `b`, `bqy`;
- price/wage stickiness parameter families: `calvo_*`, `dyn_*`;
- NFA/risk-premium variables: `nfa`, `nfa_ss`, `risk`, `risk_dyn`, `risk_ss`;
- fiscal rule variables: `gbn_yn`, `lg`, `tdn`, `tinc`, `transf_yn`.

Not used for:

- claiming paper-side equations;
- runtime validation;
- promotion to `.agents/skills/dynare-copilot/references/model-archive/`.

## Deferred Issues

- Complete formal ToTEM equations need a source-level review against the raw PDF or a more technical report appendix before this entry can move beyond `needs_review`.
- The exact nested CES production functions by sector are not printed in the Markdown.
- The exact utility functions for lifetime-income and current-income households are not printed in the Markdown.
- The exact Calvo wage and price recursions are not printed in the Markdown.
- The exact steady-state system is not printed in the Markdown.
- Equation-variable count equality is not meaningful for this first pass because the entry records structural blocks rather than the full MMB implementation equation list.
- Runtime validation, Dynare residual checks, Blanchard-Kahn checks, and IRF checks were not performed.

## Translation Status

- English draft was written first.
- Chinese draft is a translation of the checked English draft.
- Equation numbers `(F1)` through `(F30)` are preserved in both files.
