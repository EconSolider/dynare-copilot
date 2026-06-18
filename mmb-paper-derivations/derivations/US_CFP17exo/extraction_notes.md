# US_CFP17exo Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row for `US_CFP17exo` reports `mineru_match_status=matched`, `mineru_match_score=1.0000`, and `model_title_match_score=1.0000`.
- First Markdown lines match the expected paper title and authors.
- Raw PDF exists at `raw/mmb_papers/Targeting long rates in a model with segmented markets.pdf`.
- No appendix normalization file exists at `docs/mmb_appendix_full_normalizations/US_CFP17exo.md`.

## Formula Quality

- Status: `needs_review`.
- The main derivation uses the paper's published log-linearized system and its nonlinear equilibrium / steady-state appendix.
- MinerU OCR is generally readable, but Appendix notation has spacing and symbol artifacts, so the entry should remain first-pass until a targeted PDF check is performed.
- The source distinguishes two policy regimes: exogenous debt and endogenous debt. This folder is for `US_CFP17exo`, so the exogenous long-debt rule is included as the model-closing policy equation.

## Implementation Cross-Check

- Cross-check file: `.agents/skills/dynare-copilot/references/examples/US_CFP17exo_rep.mod`.
- The implementation declares `model(linear)`.
- Shock names cross-checked: `eps_a`, `eps_mp`, `eps_i`, `eps_psi`, `eps_mk`, `eps_mkw`, `eps_b2`, `eps_rn`.
- The implementation uses `b2 = -bb2` and an AR(2) `bb2` rule for the exogenous debt/QE policy block.
- The implementation includes both baseline and flexible-price counterpart variables (`cf`, `yf`, `kf`, `term_premf`, etc.) for the output gap and natural-rate comparisons.
- The `.mod` was not run and was not treated as a paper-side mathematical source.

## Deferred Issues

- Check Appendix equations against the raw PDF before promoting beyond `needs_review`.
- Resolve the timing presentation difference between the paper's \(k_{t+1}\) accumulation equation and the Rep-MMB implementation's `k(-1)` production timing if this entry is later used for runnable model reconstruction.
- Review the implementation's duplicated `r2` asset-return equations, one for investment-bond price `qi` and one for long government-bond price `q`, before using the `.mod` as a complete equation-count reference.
- The current archive entry does not update shared `catalog.csv` or `status.csv` per model ownership instructions.

## Translation Status

- English derivation drafted first.
- Chinese derivation translated from the English draft.
- F-numbering is intended to match exactly across English and Chinese versions.

## Validation

- Runtime validation: not performed by request.
- Dynare: not run.
