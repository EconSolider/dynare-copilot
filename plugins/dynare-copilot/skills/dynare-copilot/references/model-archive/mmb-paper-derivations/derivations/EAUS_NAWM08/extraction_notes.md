# EAUS_NAWM08 Extraction Notes

## Source Match

- Model-index row: `EAUS_NAWM08` in `raw/mmb_mineru/model_index.csv`.
- Primary Markdown: `raw/mmb_mineru/runs/eaus_nawm08__tax_reform_and_labour_market_performance_in_the_euro_area_a_simulation_b__5c5819cc/full.md`.
- Raw PDF path exists: `raw/mmb_papers/Tax reform and labour-market performance in the euro area- A simulation-based analysis using the New Area-Wide Model.pdf`.
- PDF body was not read. It was used only as a provenance path existence check.
- First-page / first-80-line sniff found the expected title and Coenen/McAdam/Straub authors. The Markdown has OCR/encoding artifacts: a trailing dollar in the title and `Gu¨ nter` in the author line. This is not treated as a source mismatch.

## Sources Read

- `.agents/skills/mmb-model-archive-builder/SKILL.md`
- `docs/MMB_MODEL_ARCHIVE_SUBAGENT_TASK.md`
- `docs/MODEL_ARCHIVE_BUILD_PLAN.md`
- `.agents/skills/dynare-copilot/references/derivation-style.md`
- `.agents/skills/dynare-copilot/references/model-archive/bgg_financial/bgg_financial_derivation.md`
- `raw/mmb_mineru/model_index.csv`
- primary `full.md`
- `.agents/skills/dynare-copilot/references/examples/EAUS_NAWM08_rep.mod`

## Optional Source Availability

- Appendix normalization was checked at `docs/mmb_appendix_full_normalizations/EAUS_NAWM08.md`; no file exists.
- Implementation cross-check exists at `.agents/skills/dynare-copilot/references/examples/EAUS_NAWM08_rep.mod`.

## Formula Quality

- The paper has a compact source-level model section with equations (1)-(39), Appendix A functional forms, and Appendix B calibration tables. It is not a full implementation appendix.
- MinerU captured most displayed equations, but several formulas show OCR or line-wrap damage:
  - firm labor FOC text around the marginal product of labor;
  - consumption-good \(\Gamma^\dagger\) definition after equation (30);
  - aggregate transaction-cost notation in the resource constraint;
  - some non-ASCII or malformed symbols in country/star notation.
- The derivation marks these areas as `needs_review` instead of silently normalizing them.

## Implementation Cross-Check

- The `.mod` file confirms separate `EA_` and `US_` country blocks, nonlinear model equations, country-specific calibration, and the implementation coverage for fiscal/tax AR(1) shocks.
- The `.mod` file maps the paper's infinite-sum wage and price reset FOCs into recursive auxiliary variables such as `EA_FI`, `EA_GI`, `EA_FJ`, `EA_GJ`, `EA_FH`, `EA_GH`, `EA_FX`, and `EA_GX`.
- The `.mod` file was not treated as source-stated mathematical evidence.

## Deferred Issues

- Full formula-level review should compare the compact source equations against the PDF or a cleaner appendix before using the derivation for code generation.
- The exact investment FOC derivative convention in equation (5) and the import-adjustment \(\Gamma^\dagger\) terms should be checked.
- The government budget constraint timing in the implementation differs from the paper's next-period stock notation and should be audited before promotion.
- Dynare runtime validation was not run.
- The entry was not promoted to `.agents/skills/dynare-copilot/references/model-archive/`.

## Translation Status

- `EAUS_NAWM08_derivation.zh.md` is a Chinese translation of the English core.
- `(F#)` numbering, file paths, model ID, DOI, and `needs_review` markers were preserved.
