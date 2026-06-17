# US_CMR10fa Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` selects `raw/mmb_mineru/runs/us_cmr10_us_cmr10fa__financial_factors_in_economic_fluctuations__7ef56ea6/full.md`.
- The selected row has `model_title_match_score=1.0000`, `mineru_match_score=0.6720`, and no `model_match_notes`.
- Raw PDF exists at `raw/mmb_papers/Financial factors in economic fluctuations - small version with financial accelerator.pdf`.
- No appendix normalization file exists at `docs/mmb_appendix_full_normalizations/US_CMR10fa.md`.

## Extraction Scope

- English derivation was drafted first using the eight required sections.
- Chinese derivation is a translation of the checked English draft and preserves every `(F#)` marker.
- The entry targets the paper's `Financial Accelerator Model` variant described in section 2.10.1, not the full baseline model.
- The `.mod` file `.agents/skills/dynare-copilot/references/examples/US_CMR10fa_rep.mod` was read only as `implementation_cross_check`.

## Formula Quality

- Overall formula status: `needs_review`.
- Appendix A OCR is usable for equation coverage but has visible formula damage in several places:
  - A.5 is rendered with `(A. 5)` and contains OCR-sensitive auxiliary-variable notation.
  - A.11 has mismatched parentheses around $\Gamma_t'$, $G_t'$, $\Gamma_t$, and $G_t$.
  - A.12 appears dimensionally inconsistent in OCR because the right-hand loan principal term is attached to `1 + R`.
  - A.20 and A.25-A.27 contain very long liquidity utility terms; these are baseline-only and inactive for `US_CMR10fa`, but their OCR is not independently repaired.
  - A.30 is simplified in the derivation by pointing its right side to $Y_{z,t}$ from (F6); a reviewer should check the exact bracket structure against the PDF.
- No PDF body was opened because the Markdown supplied enough structure for a `needs_review` draft and the instruction was to avoid PDF body inspection by default.

## Implementation Cross-Check

- The implementation file names active variables such as `piU`, `sU`, `rkU`, `iU`, `uU`, `omegabarU`, `RkXU`, `nU`, `qU`, `uzcU`, `lambdazU`, `cU`, `wU`, `hU`, `kbarU`, `ReXU`, `pstarU`, `wstarU`, `FpXU`, `FwXU`, `YU`, `PrU`, and `BU`.
- It includes shocks for monetary policy, price markup, inflation target, investment-specific technology, government demand, persistent growth, financial wealth, transitory technology, risk, consumption preference, marginal efficiency of investment, and oil/utilization cost.
- The `.mod` confirms that the MMB implementation is a reduced financial-accelerator version without the full baseline money/liquidity block; it was not used to source mathematical formulas.

## Deferred Issues

- Full source-level formula review against the PDF is still required before promoting this entry beyond `needs_review`.
- The steady-state section records source-backed scaling, normalizations, and targets, but it does not reconstruct the numerical `steady_state_model`.
- The active equation count should be reviewed when a runnable `.mod` is built, especially for inactive baseline-only money/reserve equations.
- Runtime validation, Blanchard-Kahn checks, residual checks, and IRF checks were not performed.

## Translation Status

- Chinese translation completed after the English draft.
- English and Chinese `(F#)` counts match in validation.
