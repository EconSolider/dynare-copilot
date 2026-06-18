# US_SW07 Extraction Notes

## Status

- Status: `needs_review`
- Extraction date: 2026-06-17
- Scope: private derivation archive draft only.
- Runtime validation: not performed.
- Promotion to `.agents/skills/dynare-copilot/references/model-archive/`: not performed.

## Sources Read

- `docs/MODEL_ARCHIVE_BUILD_PLAN.md`
- `.agents/skills/dynare-copilot/references/derivation-style.md`
- `.agents/skills/dynare-copilot/references/model-archive/bgg_financial/bgg_financial_derivation.md`
- `raw/mmb_mineru/model_index.csv`
- `raw/mmb_mineru/runs/us_sw07__shocks_and_frictions_in_us_business_cycles_a_bayesian_dsge_approach__5e0f76f1/full.md`
- `docs/mmb_appendix_full_normalizations/US_SW07.md`
- `.agents/skills/dynare-copilot/references/examples/US_SW07_rep.mod` as implementation cross-check only.

## Source Match

- `model_index.csv` reports `mineru_match_status=matched`, `mineru_match_score=1.0000`, and `model_title_match_score=1.0000`.
- Primary source title is `2007-shocks-and-frictions-in-us-business-cycles-a-bayesian-dsge-approach`.
- Raw PDF path exists.
- No title mismatch was found for this first draft.
- Multiple MinerU run ids exist; this draft uses the primary run selected in `model_index.csv`: `5e0f76f1`.

## Formula Quality

The paper `full.md` includes the published log-linear model equations (1)-(15), but some OCR tokens are malformed. The appendix normalization provides a fuller source-equation inventory with page coverage.

Formula groups still requiring source-level TeX audit:

- Kimball final-good and price-reset formulas: appendix eqs. 7, 8, 30, 32, 33.
- Household budget and compact FOC bundle: appendix eqs. 9, 13.
- Wage union FOC and wage index: appendix eqs. 20, 21, 41, 42, 43.
- Log-linear Phillips/wage/consumption/investment equations where OCR dropped terms or split constants: appendix eqs. 48, 53, 56, 58, 61.

## Implementation Cross-Check

`US_SW07_rep.mod` is `model(linear)` and contains:

- Sticky economy variables such as `mc`, `zcap`, `rk`, `k`, `pk`, `c`, `inve`, `y`, `lab`, `pinf`, `w`, `r`, `a`, `b`, `g`, `qs`, `ms`, `spinf`, `sw`, `kp`.
- Flexible-economy counterparts such as `zcapf`, `rkf`, `kf`, `pkf`, `cf`, `invef`, `yf`, `labf`, `wf`, `rrf`, `kpf`.
- Seven innovations: `ea`, `eb`, `eqs`, `eg`, `em`, `epinf`, `ew`.

Information from the `.mod` file is used only to flag coverage and naming issues. It is not treated as source-stated paper math.

## Deferred Issues

- The current derivation uses a compact source-backed representation. It does not expand every Kimball curvature term.
- The flexible-economy block is recorded as a potential-output cross-check but still needs source-side alignment against appendix section 1.6 and the implementation equations.
- The measurement equations are included for archive completeness but not yet tied to an estimation data manifest.
- Equation count is not ready for runtime validation because the `.mod` implementation carries auxiliary MA variables and observable equations beyond the published 14-equation exposition.

## Translation

- English translation added at `US_SW07_derivation.en.md`.
- The English version preserves the same section structure and F-numbering as `US_SW07_derivation.md`.
