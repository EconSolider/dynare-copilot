# NK_CGG02 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row for `NK_CGG02` has `mineru_match_status=matched`, `mineru_match_score=1.0000`, `model_title_match_score=1.0000`, and no model-match notes.
- Primary Markdown: `raw/mmb_mineru/runs/nk_cgg02_nk_cgg02al__a_simple_framework_for_international_monetary_policy_analysis__8ffaf5fd/full.md`.
- Raw PDF exists at `raw/mmb_papers/A simple framework for international monetary policy analysis.pdf`. It was not opened because the Markdown was sufficient for a first-pass `needs_review` draft.
- No appendix normalization file exists at `docs/mmb_appendix_full_normalizations/NK_CGG02.md`.

## Formula Quality

- Household equations (consumption aggregator, CPI, budget constraint, labor demand, utility, expenditure shares, Euler equation, labor supply, and risk sharing) are readable.
- Firm equations (CES final-good aggregation, intermediate-good technology, marginal cost, reset-price condition, price index) are mostly readable.
- The reset-price objective preceding the reset-price FOC has an OCR sign issue: the source line prints `P^0 + P MC` where the FOC later has the expected `P^0 - (1+mu^p) P MC`. The derivation uses the readable FOC and marks this as `needs_review`.
- The Nash interest-rate rule line prints an OCR-like `9` before expected inflation. The following definition gives `vartheta = 1 + xi*sigma0*(1-rho)/rho`; the derivation uses `vartheta` and marks the coefficient as `needs_review`.
- Cooperative reduced-form expressions include visible OCR artifacts around barred/underlined `psi` objects. These formulas were not needed for the MMB Nash implementation core and were not promoted into the derivation's main equation list.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/NK_CGG02_rep.mod` exists and was used only as `implementation_cross_check`.
- The cross-check confirms `model(linear)`, the MMB variable set, and the calibration composites `kappa0`, `kappa`, `sigma0`, `delta1`, and `lambda`.
- The `.mod` includes exogenous innovations `inf_`, `a_`, `infstar_`, `ystar_`, `astar_`, `rstar_`, and `interest_`. The foreign-output innovation is recorded as implementation-specific because the paper presents the symmetric foreign block analytically.
- No Dynare run was performed.

## Deferred Issues

- Source-level review should verify the reset-price objective and the Nash policy-rule coefficient against the PDF or publisher copy before promoting status beyond `needs_review`.
- A reviewer should decide whether the model-archive entry should include cooperative-policy equations as a separate variant, because `NK_CGG02_rep.mod` implements the Nash-style linear block.
- The paper DOI field in local metadata is `10.3386/w8870`, an NBER working-paper DOI, while the citation is the 2002 Journal of Monetary Economics article.
- Equation-to-variable counts in the archive derivation are intentionally broader than the compact MMB `model(linear)` block because the derivation preserves paper-side household/firm conditions and market identities as provenance.

## Translation Status

- `NK_CGG02_derivation.zh.md` is a direct translation of the checked English draft.
- Equation numbers, model IDs, DOI values, file paths, and status markers are preserved.
