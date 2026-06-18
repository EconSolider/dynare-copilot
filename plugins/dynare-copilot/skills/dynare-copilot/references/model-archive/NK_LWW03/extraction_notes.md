# NK_LWW03 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row for `NK_LWW03` is `matched` with `mineru_match_score = 1.0000` and `model_title_match_score = 1.0000`.
- The first Markdown lines match the expected title and authors for Levin, Wieland, and Williams (2003).
- Raw PDF path exists: `raw/mmb_papers/The Performance of Forecast-Based Monetary Policy Rules under Model Uncertainty.pdf`.
- No appendix-normalization file exists at `docs/mmb_appendix_full_normalizations/NK_LWW03.md`.
- The same paper source maps to `NK_LWW03`, `NK_LWW03AL`, and `US_FRB03`; this entry only claims the `NK_LWW03` reduced-form AD-AS / implementation variant.

## Formula Quality

- The core paper formulas for the optimizing AD-AS model are legible in MinerU Markdown:
  - paper equation (2): forward-looking Phillips curve;
  - paper equation (3): expectational IS curve;
  - paper equation (1): general forecast-based policy-rule class;
  - paper equation (7): benchmark forecast-based policy rule.
- Source cues checked in `full.md`: the equation (1) rule appears near the Table 1 discussion; equations (2)-(3) appear in Section II; equation (7) appears in the robust benchmark-rule discussion after Table 9.
- Formula status remains `needs_review` because the Markdown OCR around some table notes has small symbol omissions, and the paper does not give primitive optimization problems for the stylized model in the extracted text.
- The raw PDF was not opened for formula checks because the relevant Markdown formulas were readable and the task did not require PDF-body inspection.

## Implementation Cross-Check

- Cross-check file: `.agents/skills/dynare-copilot/references/examples/NK_LWW03_rep.mod`.
- Used only as `implementation_cross_check`; Dynare was not run.
- Observed form: `model(linear)`.
- Observed endogenous variables: `ygap`, `pdot`, `rff`, `rstar`, `drff`, `pdotsh`.
- Observed exogenous variables: `rstar_`, `pdotsh_`.
- Observed core model equations align with the paper's Phillips curve and expectational IS curve after annualization/scaling conventions:
  - implementation: `pdot = discountt*pdot(+1) + 4*phi*ygap + pdotsh`;
  - implementation: `ygap = ygap(+1) - 0.25*sigma*(rff - pdot(+1) - rstar)`.
- Observed implementation policy rule is `rff = 1.5*pdot`, not the paper's benchmark forecast-based rule. This was recorded as an implementation variant, not as paper-side mathematical source.

## Deferred Issues

- `needs_review`: Determine whether this archive should supplement the paper's reduced-form equations with primitive optimization problems from the cited Woodford / Clarida-Gali-Gertler sources.
- `needs_review`: Clarify why the MMB `NK_LWW03` implementation uses the current-inflation rule while the paper emphasizes forecast-based rules and benchmark rule (7).
- `deferred_runtime_validation`: No Dynare execution, residual check, BK check, or IRF validation was performed.
- `deferred_catalog_merge`: Shared `catalog.csv` and `status.csv` were not edited by instruction. Proposed row values are in `source_manifest.json` and `worker_report.json`.

## Translation Status

- English derivation drafted first.
- Chinese derivation translated from the English core, with the same eight-section order and translated section headings.
- F-number counts match between English and Chinese derivations: 9.
