# NK_RA16 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row 90 maps `NK_RA16` to Rannenberg (2016), "Bank leverage cycles and the external finance premium".
- `primary_full_md_path` exists: `raw/mmb_mineru/runs/nk_ra16__bank_leverage_cycles_and_the_external_finance_premium__b2ee5225/full.md`.
- `raw_pdf_path` exists: `raw/mmb_papers/Bank leverage cycles and the external finance premium.pdf`. The PDF body was not read; the path was checked only for provenance.
- The first Markdown lines show the expected author and title. `model_title_match_score=1.0000`.
- No appendix normalization file exists at `docs/mmb_appendix_full_normalizations/NK_RA16.md`.

## Extraction Scope

- English derivation was drafted first from the `primary_full_md_path`.
- Chinese derivation was translated from the English derivation, preserving equation labels `(F1)` through `(F52)` and all formulas.
- Shared indexes `mmb-paper-derivations/derivations/catalog.csv` and `mmb-paper-derivations/derivations/status.csv` were not edited.
- The raw PDF body was not opened because the Markdown contained the main text and Appendix A FOCs.

## Formula Quality

- The MinerU Markdown contains a useful Appendix A with household, retailer, capital-goods-producer, banker, and entrepreneur FOCs.
- Several formulas have OCR quirks, especially the household budget constraint, the price-index law, some banker-value notation, and the compact entrepreneur-equity equation.
- Formula (F34) is marked `needs_review` because the paper's main-text integral representation and Appendix A compact representation differ in OCR clarity.
- The steady-state sequence is reconstructed from the paper calibration discussion plus implementation cross-check constants, not a complete paper-side closed-form proof.
- Runtime validation was not performed.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/NK_RA16_rep.mod` exists and was read only as `implementation_cross_check`.
- `raw/mmb/mmci-cli/models/NK_RA16/NK_RA16.mod` and `.json` exist and were inspected only for implementation coverage.
- The implementation confirms `model(linear)`, variable capital utilization, flex-price counterparts, and broad variables: `Y`, `GDP`, `I`, `K`, `l`, `U`, `Cp`, `C`, `Ce`, `Cb`, `varrho`, `R`, `Rk`, `rk`, `Rb`, `Rl`, `w`, `a`, `Q`, `Pi`, `mc`, `N`, `V`, `phi_e`, `omega_bar_prime`, `L`, `Lr`, `Le`, `g`, `Nb`, `phi_b`, `z`, `Lambda`, spreads, `R4`, and `Pi4`.
- The implementation declares conventional shocks `e_i`, `e_a`, and `e_g`; the raw MMB model maps modelbase shocks `interest_` and `fiscal_`. Bank and entrepreneur net-worth shocks are source-stated for crisis experiments but not retained in the final Rep-MMB `shocks` block.
- No formulas were sourced solely from `.mod`; implementation files were used to detect omissions, form, timing, and variable coverage.

## Deferred Issues

- Human review should check (F34) and (F38) against the PDF or publisher text because OCR around the entrepreneur payoff integrals is fragile.
- Human review should verify whether a future runnable archive should include the bank and entrepreneur net-worth shocks as optional experiments.
- The variable-utilization cost parameter `c_U` is implementation-supplied, not fully documented in the paper text.
- The flexible-price duplicate block used for `outputgap` is an implementation device and was not expanded into a second derivation.
- Runtime validation, BK checks, impulse-response checks, and promotion to the runnable skill archive are deferred.

## Translation Status

- Chinese translation completed after the English derivation.
- English and Chinese derivations preserve matching section order and F-number labels.
