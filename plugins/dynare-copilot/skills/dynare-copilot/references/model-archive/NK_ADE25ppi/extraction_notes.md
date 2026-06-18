# NK_ADE25ppi Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row for `NK_ADE25ppi` is an exact match to "Trade Wars and the Optimal Design of Monetary Rules" with match score `1.0000`.
- Primary MinerU Markdown exists at `raw/mmb_mineru/runs/nk_ade25cpi_nk_ade25ppi__trade_wars_and_the_optimal_design_of_monetary_rules__2eb96dcd/full.md`.
- Raw PDF exists at `raw/mmb_papers/Trade Wars and the Optimal Design of Monetary Rules.pdf`. I checked existence and hash only; I did not read the PDF body.
- Optional normalized appendix `docs/mmb_appendix_full_normalizations/NK_ADE25ppi.md` does not exist.
- Author-site appendix PDF exists under `raw/theory_sources/...`, but no normalized Markdown was available. It is recorded in the manifest for future source review.

## Formula Quality

- Overall formula quality: `needs_review`.
- Main-text equations for the simple example model are visible in MinerU Markdown and support the household budget constraint, firm Phillips curve, government budget, balanced-trade condition, PPI/CPI policy distinction, and simple optimal-tariff formulas.
- The full two-country model is summarized in the main text by reference to Online Appendix C equations (C40)-(C48). Since those equations were not present as normalized Markdown, the quantitative two-country equilibrium conditions in the derivation are marked `needs_review`.
- Several MinerU OCR artifacts appear in the main text, especially around formulas with missing symbols in Sections 3.1-3.2. I did not silently normalize ambiguous terms except where the MMB implementation cross-check made the variable identity clear.

## Implementation Cross-Check

- Local MMB implementation read only as cross-check:
  - `raw/mmb/mmci-cli/models/NK_ADE25ppi/NK_ADE25ppi.mod`
  - `raw/mmb/mmci-cli/models/NK_ADE25ppi/NK_ADE25ppi.json`
- Cross-check finding: `NK_ADE25ppi` targets PPI inflation (`Pih`, `Pif`) in policy feedback variables. The paired `NK_ADE25cpi` implementation adds CPI variables (`Pih_cpi`, `Pif_cpi`) and targets those instead.
- Cross-check finding: implementation variables support a two-country structure with consumption, output, labor, terms of trade, marginal costs, intermediate inputs, import demand blocks, net foreign assets, tariffs, and interest rates.
- The MMB `.mod` was not used as a paper-side mathematical source.

## Deferred Issues

- Full Appendix C equations (C40)-(C48) should be extracted from the author-site appendix PDF or a future normalized appendix Markdown.
- Tariff-authority first-order conditions are not printed in the main text and need appendix-level verification.
- Net foreign asset and UIP equations need source-level notation verification from Appendix C.
- The steady-state solution sequence for the full quantitative model is incomplete until Appendix C formulas are reviewed.
- No Dynare run, residual check, BK check, IRF comparison, or runtime validation was performed.

## Translation Status

- English derivation drafted first.
- Chinese derivation translated from the English version.
- Equation labels `(F1)` through `(F23)` are preserved in both files.

## Proposed Shared Index Rows

These rows are proposed only for the main agent. I did not edit `catalog.csv` or `status.csv`.

`catalog.csv`:

```csv
NK_ADE25ppi,derivation,Trade Wars and the Optimal Design of Monetary Rules,2025,New Keynesian open-economy trade-war model,Two-country,Monetary policy and trade policy,"PPI targeting, producer-currency pricing, Rotemberg pricing, discretionary tariffs, terms-of-trade externality",2026-06-17,raw/mmb_mineru/runs/nk_ade25cpi_nk_ade25ppi__trade_wars_and_the_optimal_design_of_monetary_rules__2eb96dcd/full.md,raw/mmb_papers/Trade Wars and the Optimal Design of Monetary Rules.pdf,10.1016/j.jmoneco.2024.103726,needs_review
```

`status.csv`:

```csv
NK_ADE25ppi,Trade Wars and the Optimal Design of Monetary Rules,raw/mmb_mineru/runs/nk_ade25cpi_nk_ade25ppi__trade_wars_and_the_optimal_design_of_monetary_rules__2eb96dcd/full.md,raw/mmb_papers/Trade Wars and the Optimal Design of Monetary Rules.pdf,needs_review,needs_review,needs_review,true,"Full Appendix C equations not normalized; first-pass PPI variant derivation only."
```
