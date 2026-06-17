# Extraction Notes -- US_LTW17nu

## Source Match

- `raw/mmb_mineru/model_index.csv` row 148 maps `US_LTW17nu` to Leeper, Traum, and Walker (2017), "Clearing Up the Fiscal Multiplier Morass," DOI `10.1257/aer.20111196`.
- Title sniff passed: the first Markdown lines show the expected title and authors.
- `raw_pdf_path` exists and was hashed, but the PDF body was not read. The skill contract says PDF body reading is not required unless targeted formula checking is needed.
- No appendix normalization file exists at `docs/mmb_appendix_full_normalizations/US_LTW17nu.md`.

## Formula Quality

- Status: `needs_review`.
- The paper-side model block in MinerU Markdown is sufficient for first-pass structure: firms, Calvo price setting, household preferences and budget constraints, capital accumulation, monetary rule, fiscal budget identity, fiscal rules, aggregation, and nested model restrictions are visible.
- Several OCR formulas are noisy, especially the final-good/labor aggregators, wage indexation expression, and government budget identity.
- Equations (F5), (F16), and (F22) should be checked against PDF or author appendix before review promotion.
- The derivation records `model(linear)` equations because the MMB implementation is linear. Several compact log-linear equations are therefore implementation cross-checks, not standalone paper-side mathematical sources.

## Implementation Cross-Check Details

- Cross-check file: `.agents/skills/dynare-copilot/references/examples/US_LTW17nu_rep.mod`.
- Used only as `implementation_cross_check`; no Dynare command was run.
- Variant-specific findings from `.mod`:
  - `alphag = 0`, which removes government spending from utility.
  - `thet = 0.8`, described in the file comment as lower habits.
  - `muHH = 0`, which makes the non-saver block inactive in the numerical implementation.
  - The active `model (linear);` block includes 58 primary equations before the flex-price shadow economy; the archive derivation covers the main structural, fiscal, shock, and accounting equations as (F1)-(F42), excluding observable equations and the flex-price shadow economy from full first-pass derivation.

## Deferred Issues

- Verify exact Calvo price and wage reset FOCs from the raw PDF or online appendix.
- Decide whether future reviewed entries should include the flex-price shadow economy as a separate subsection or leave it as implementation-only auxiliary structure.
- Verify the government budget identity notation against a cleaner source because MinerU OCR introduced stray hats/dots in that equation.
- Confirm whether catalog/status merge should treat `US_LTW17nu` as a separate variant row with `alphag=0`, `thet=0.8`, and inactive non-savers.
- Runtime validation, BK checks, and steady-state validation are deferred by task instruction.

## Translation Status

- English derivation was drafted first.
- Chinese derivation was produced second as a translation of the English core.
- F-number counts match between English and Chinese derivations.
