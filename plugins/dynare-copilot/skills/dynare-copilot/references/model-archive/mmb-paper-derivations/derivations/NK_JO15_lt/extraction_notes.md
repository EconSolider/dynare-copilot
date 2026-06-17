# NK_JO15_lt Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row for `NK_JO15_lt` is matched with score `1.0000`.
- Primary source title: "Productivity Shocks and Monetary Policy in a Two-Country Model".
- MinerU run id: `f031feec-a81e-43ec-ac7a-f89bd2d73785`.
- Primary Markdown exists and was used: `raw/mmb_mineru/runs/nk_jo15_ht_nk_jo15_lt__productivity_shocks_and_monetary_policy_in_a_two_country_model__f031feec/full.md`.
- Raw PDF path exists and was recorded for provenance: `raw/mmb_papers/Productivity Shocks and Monetary Policy in a Two-Country Model.pdf`.
- Raw PDF body was not read. The Markdown source was sufficient for a first-pass extraction, and no targeted formula check required opening the PDF.
- No appendix normalization file exists at `docs/mmb_appendix_full_normalizations/NK_JO15_lt.md`.

## Formula Quality

- Status: `needs_review`.
- The main model is source-backed from the paper's Section 2, Appendix A, Appendix C, and Appendix D text in MinerU Markdown.
- MinerU OCR issues observed:
  - Some equation numbers appear malformed, e.g. `(2 7)`, `(2 8)`, `(3 0)`.
  - Several inline array renderings include duplicated or stray fragments.
  - The source rendering of the CPI-inflation equations appears to include extra $r_t$ and $r_t^*$ terms. The appendix Dynare code and local implementation cross-check omit these terms.
  - The compact Phillips curve in the text uses a simplified coefficient presentation. The local `.mod` uses separate coefficients on domestic and foreign output gaps, consistent with substituting marginal-cost equations into the PPI Phillips curves.

## Implementation Cross-Check

- Checked `.agents/skills/dynare-copilot/references/examples/NK_JO15_lt_rep.mod` only as `implementation_cross_check`.
- Confirmed:
  - `model(linear)` form.
  - Low-trade openness calibration `alpha = 0.1`.
  - Endogenous variable list: `x pi_H r pi x_star pi_F_star r_star pi_star r_bar r_bar_star a a_star mc mc_star y y_star y_bar y_bar_star p p_star e s q`.
  - Exogenous variable list: `m m_star xi xi_star`.
  - Foreign productivity shock is the active simulation shock in the example.
  - Lag structure for policy rates, price levels, CPI-inflation identities, and productivity processes.
- The `.mod` file was not treated as a paper-side mathematical source.

## Deferred Issues

- Human review should compare the CPI-inflation equations against the PDF or publisher source because the OCR source and implementation differ.
- Human review should decide whether the derivation should present the compact paper Phillips curve, the implementation-expanded Phillips curve, or both as separate source and implementation layers.
- No Dynare runtime validation was performed. BK conditions, residual checks, IRF reproduction, and equation-count validation are deferred to a later runtime-validation phase.
- Shared `catalog.csv` and `status.csv` were not updated because this task explicitly limited write ownership to `data/model_archive/mmb_derivations/NK_JO15_lt/` and prohibited editing shared indexes.

## Translation Status

- English derivation was drafted first.
- Chinese derivation was created after the English draft.
- F-number parity between English and Chinese derivations should be validated mechanically before handoff.
