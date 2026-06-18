# NK_CK08 Extraction Notes

## Source Match

- `NK_CK08` is a clean one-paper match in `raw/mmb_mineru/model_index.csv`.
- `mineru_match_score`: `1.0000`.
- `model_title_match_score`: `1.0000`.
- Primary source title: "Resuscitating the wage channel in models with unemployment".
- Raw PDF path exists. The PDF body was not read because the Markdown contained the needed model and appendix equations.
- No optional normalization file exists at `docs/mmb_appendix_full_normalizations/NK_CK08.md`.

## Formula Quality

- Status: `needs_review`.
- The main text and appendix A.2 provide a coherent linearized RTM system.
- MinerU OCR has visible symbol ambiguity in several places, especially where the source separation parameter $`\vartheta`$ appears as `9` in long value/surplus equations.
- Equations (F8)-(F11) are marked `needs_review` because they are long OCR-sensitive recursions for marginal wage-surplus terms, firm value, and worker surplus.
- The annual inflation convention differs across sources: the paper is monthly and uses year-on-year inflation, while the MMB replication is a quarterly recalibration. The derivation records both the paper monthly source and the implementation cross-check.

## Implementation Cross-Check

- Cross-check file: `.agents/skills/dynare-copilot/references/examples/NK_CK08_rep.mod`.
- Used only for variable coverage, shock names, timing, and `model(linear)` confirmation.
- The replication file states that the original model is monthly and the MMB file is recalibrated to quarterly frequency.
- Cross-check confirms endogenous variables including `ct`, `deltaFt`, `deltaWt`, `Deltastart`, `ht`, `Jstart`, `lambdat`, `mct`, `mt`, `nt`, `Pit`, `Piannt`, `qt`, `Rt`, `st`, `ut`, `vt`, `wstart`, `wt`, `xLt`, `yt`, and shock states `ebt`, `emoneyt`, `gt`, `zt`.
- Cross-check confirms exogenous innovations `inno_ebt`, `inno_zt`, `interest_`, and `g_`.

## Deferred Issues

- Check equations (F8)-(F11) against the raw PDF before promoting beyond `needs_review`.
- Confirm whether archive should preserve the paper's monthly Taylor-rule denominators or add a separate quarterly MMB implementation note in future runnable-model work.
- Runtime validation, equation-count matching to a runnable Dynare file, and BK diagnostics were not performed.

## Translation Status

- English derivation drafted first.
- Chinese derivation translated from the English file with matching section order and matching `(F#)` equation labels.
