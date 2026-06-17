# NK_GK11 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row 63 maps `NK_GK11` to Gertler and Karadi (2011), "A model of unconventional monetary policy".
- `primary_full_md_path` exists: `raw/mmb_mineru/runs/nk_gk09lin_nk_gk11__a_model_of_unconvetional_monetary_policy__e6192938/full.md`.
- `raw_pdf_path` exists: `raw/mmb_papers/A Model of Unconvetional Monetary Policy.pdf`. The PDF body was not read; the path was checked only for provenance.
- The title in the local PDF path and MinerU source contains the typo `Unconvetional`; this is treated as a source-path/OCR typo rather than a substantive mismatch. `model_title_match_score=0.9877`.
- No appendix normalization file exists at `docs/mmb_appendix_full_normalizations/NK_GK11.md`.

## Extraction Scope

- English derivation was drafted first from the `primary_full_md_path`.
- Chinese derivation was translated from the English derivation, preserving equation labels `(F1)` through `(F43)` and all formulas.
- Shared indexes `data/model_archive/mmb_derivations/catalog.csv` and `data/model_archive/mmb_derivations/status.csv` were not edited.

## Formula Quality

- The MinerU Markdown contains the main paper equations for the household, banker/intermediary, credit-policy, production, capital-producer, retail-pricing, resource, government, and policy blocks.
- Several formulas have OCR quirks, especially around subscripts, Greek letters, and the return-to-capital expression. The derivation regularizes obvious notation but remains `needs_review`.
- The reset-price and investment-adjustment equations use compact `f(\cdot)` notation where the paper does the same or where OCR makes the full argument fragile.
- Runtime validation was not performed.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/NK_GK11_rep.mod` exists and was read only as `implementation_cross_check`.
- The example confirms the broad variable coverage: `Y`, `Ym`, `K`, `Keff`, `L`, `I`, `C`, `G`, `Q`, `varrho`, `Lambda`, `Rk`, `R`, `N`, `Ne`, `Nn`, `nu`, `eta`, `phi`, `z`, `x`, `Pm`, `w`, `VMPK`, `U`, `X`, `D`, `F`, `Z`, `i`, `prem`, `delta`, `In`, `Welf`, `infl`, `inflstar`, `a`, `ksi`, `g`.
- The example also carries shocks `e_a`, `e_ksi`, `e_g`, `e_Ne`, and `e_i`. The `e_Ne` wealth shock is marked as implementation cross-check only because it is not a core paper-side process in the source extraction.
- No formulas were sourced solely from the `.mod`; it was used to detect omissions and timing conventions.

## Deferred Issues

- Human review should check the exact return-to-capital formula `(F24)` against the PDF or publisher text because MinerU OCR around the capital-quality and depreciation terms is noisy.
- Human review should verify the price-dispersion recursion if a runnable `.mod` is later built; the paper presents the price-level law directly, while the implementation adds a dispersion state.
- The steady-state calibration target solution for `lambda`, `omega`, and `chi` is not fully closed-form in the paper and should remain `needs_review`.
- Runtime validation, BK checks, impulse-response checks, and promotion to the runnable skill archive are deferred.

## Translation Status

- Chinese translation completed after the English derivation.
- English and Chinese derivations preserve matching section order and F-number labels.
