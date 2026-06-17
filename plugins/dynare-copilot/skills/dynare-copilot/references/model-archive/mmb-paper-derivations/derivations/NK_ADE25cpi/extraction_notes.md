# NK_ADE25cpi Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` maps `NK_ADE25cpi` to "Trade Wars and the Optimal Design of Monetary Rules" with `match_status=matched`, `match_score=1.0000`, and `model_title_match_score=1.0000`.
- Primary Markdown: `raw/mmb_mineru/runs/nk_ade25cpi_nk_ade25ppi__trade_wars_and_the_optimal_design_of_monetary_rules__2eb96dcd/full.md`.
- Raw paper PDF exists at `raw/mmb_papers/Trade Wars and the Optimal Design of Monetary Rules.pdf`; the PDF body was not read.
- No normalized appendix Markdown exists at `docs/mmb_appendix_full_normalizations/NK_ADE25cpi.md`.
- No example replication file exists at `.agents/skills/dynare-copilot/references/examples/NK_ADE25cpi_rep.mod`.

## Formula Source And Quality

- The main paper Markdown contains the simple Section 3 model and describes the full model, but the full two-country equilibrium conditions are delegated to Online Appendix C.
- A local author-site appendix packet exists at `raw/theory_sources/mmb_appendix_nk_ade25cpi_author_personal_site_appendix_eae10669/`; its provenance says the appendix was downloaded from `http://aeyq.free.fr/pdf/TW_CPI_App.pdf` on 2026-06-16.
- Targeted `pdftotext -layout` extraction was used for Appendix C and D formulas. This is acceptable for first-pass extraction but remains `needs_review` because no normalized appendix Markdown packet exists.
- Equations (F1)-(F35) summarize the paper-side model and policy variant. They are not a runnable Dynare equation block.

## Implementation Cross-Check

- `raw/mmb/mmci-cli/models/NK_ADE25cpi/NK_ADE25cpi.mod` was read only as `implementation_cross_check`.
- The implementation cross-check confirms CPI inflation variables `Pih_cpi` and `Pif_cpi`, tariff variables `T` and `Ts`, two-country variables, Rotemberg price adjustment, portfolio-adjustment costs, and a flexible-price comparison block.
- The MMB `.mod` uses a modelbase policy rule for the Home interest rate and an explicit CPI rule for the Foreign rate in the displayed block. This was not treated as paper-side mathematical evidence.

## Deferred Issues

- `needs_review`: Appendix C reduced equation (C.41) displays an ambiguous marginal-cost scaling in OCR/text extraction. The derivation writes the symmetric Phillips curve as equated to `MC_t^*`, but this should be checked against the typeset PDF or source TeX.
- `needs_review`: Appendix D changes the international bond denomination for the US-China quantitative exercise. The derivation notes this but does not fully replace Appendix C's bond block with Appendix D's Home-currency bond system.
- `needs_review`: Exact steady-state numbers were not recomputed and not validated against Dynare output.
- Runtime validation was not performed. No `resid`, `steady`, `check`, `stoch_simul`, or optimal-control run was executed.

## Translation Status

- English derivation was drafted first.
- Chinese derivation was translated from the English derivation.
- The eight required sections and `(F#)` equation numbering are preserved across both files.
