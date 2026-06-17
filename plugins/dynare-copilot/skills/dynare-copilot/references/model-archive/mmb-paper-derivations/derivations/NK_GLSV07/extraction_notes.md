# NK_GLSV07 Extraction Notes

## Source Match

- `model_index.csv` row found for `NK_GLSV07`.
- `primary_source_title`: "Understanding the effects of government spending on consumption".
- `model_title_match_score`: `1.0000`.
- MinerU run id: `47e78a28-668e-4d2c-a7ff-9274c85dd958`.
- Primary source Markdown exists and was used: `raw/mmb_mineru/runs/nk_glsv07__understanding_the_effects_of_government_spending_on_consumption__47e78a28/full.md`.
- Raw PDF exists and was recorded for provenance, but the PDF body was not read: `raw/mmb_papers/Understanding the effects of government spending on consumption.pdf`.
- No appendix normalization file exists at `docs/mmb_appendix_full_normalizations/NK_GLSV07.md`.

## Formula Quality

- Main model extraction used the paper's Section 3 and Appendix C.
- The operative `NK_GLSV07` archive derivation is based on the imperfectly competitive labor market reduced system because `.agents/skills/dynare-copilot/references/examples/NK_GLSV07_rep.mod` identifies `NK_GLSV07_iclm` and uses the Appendix C equations.
- Continuous F-numbering runs from `(F1)` through `(F17)` in both English and Chinese files.
- Formula status is `needs_review`: OCR was readable for the equations used, but no targeted raw-PDF formula comparison was performed.
- The markup notation is a review item. The paper uses $\mu^p$ for the gross price markup, while nearby calibration prose refers to a markup of 0.2. The example implementation sets `my_p=1.2`. The derivation records this convention rather than silently normalizing it.

## Implementation Cross-Check Details

- Cross-check file: `.agents/skills/dynare-copilot/references/examples/NK_GLSV07_rep.mod`.
- Used only as `implementation_cross_check`, not as a paper-side mathematical source.
- Confirmed endogenous variables: `n c pi k b g y w t i`.
- Confirmed exogenous shock: `e_g`.
- Confirmed predetermined variables: `k, b`.
- Confirmed selected variant: "Imperfectly competitive labor market".
- Confirmed that the MMB example implements a linear reduced system rather than the full nonlinear optimizing model.

## Deferred Issues

- Runtime validation was not performed.
- No Dynare equation-count or Blanchard-Kahn check was run.
- The entry does not attempt to reconstruct the full nonlinear Calvo recursion; it documents the paper's structural optimization blocks and the reduced log-linear MMB system.
- The treatment of taxes paid by rule-of-thumb households is retained at the aggregate reduced-system level. A future runnable replication should decide whether to expose `t_t^r` separately or keep the MMB aggregate rule.
- The implementation has an additional investment identity for IRF reporting; the derivation records the market-clearing and reduced capital equations and notes the implementation identity in the variable table.

## Translation Status

- English derivation drafted first.
- Chinese derivation translated from the English core.
- Section order is identical.
- F-number parity checked by validation script.
- File paths, model id, DOI, and status markers were preserved.
