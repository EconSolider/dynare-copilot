# US_IR11 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row 142 maps `US_IR11` to Peter N. Ireland (2011), "A New Keynesian perspective on the Great Recession."
- Primary MinerU source: `raw/mmb_mineru/runs/us_ir11__a_new_keynesian_perspective_on_the_great_recession__fee43648/full.md`.
- The first 80 Markdown lines show the expected author, title, abstract, and journal metadata.
- Alternate MinerU run `064da916-acca-4e7e-8462-1f6d6a43c35b` was sniffed; its first 90 lines also match the expected title and author.
- Raw PDF exists at `raw/mmb_papers/A New Keynesian perspective on the Great Recession.pdf`.
- No appendix normalization file exists at `docs/mmb_appendix_full_normalizations/US_IR11.md`.

## Formula Quality

- Status: `needs_review`.
- The primary Markdown includes the model section and paper equations (1)-(30). The linear equations (21)-(30) are legible enough for first-pass extraction.
- The Rotemberg pricing first-order condition from paper equation (13) is long and OCR-sensitive; it is included in the English and Chinese derivations with a `needs_review` marker.
- The cost-push shock renormalization from the markup shock to `e` is described in the Markdown after paper equation (30); it is included but marked `needs_review` because the sign and scaling should be PDF-checked before review promotion.
- The paper's equation (22) was split across two Markdown display equations; it was recombined in the derivation.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/US_IR11_rep.mod` exists and was read only as `implementation_cross_check`.
- Cross-check confirms the MMB implementation is `model(linear)`.
- Cross-check endogenous names: `a`, `lambda`, `y`, `z`, `r`, `pi`, `e`, `g`, `q`, `x`, plus reporting variables `inflationq`, `interest`, `output`, `Z_au`.
- Cross-check exogenous names: `epsa`, `epse`, `epsz`, `epsr`.
- Cross-check parameter names: `gamma`, `alfa`, `rhopi`, `rhog`, `rhoa`, `rhoe`, `zeta`, `beta`, `psi`.
- Information learned only from the `.mod` file is labeled as `implementation_cross_check` in the derivation and manifest.

## Deferred Issues

- PDF-level formula audit is still needed for paper equation (13).
- PDF-level audit is still needed for the markup-shock-to-cost-push-shock renormalization after paper equation (30).
- Runtime validation, BK checks, impulse response checks, and reproduction of estimation/filtering results were not performed and remain deferred.
- Shared `catalog.csv` and `status.csv` were intentionally not edited per task ownership.

## Translation Status

- English derivation was drafted first.
- Chinese derivation was produced second as a translation of the English derivation.
- Equation numbering `(F1)` through `(F18)` is preserved in both files.
- LaTeX formulas, paths, model ID, DOI, and status markers are preserved.
