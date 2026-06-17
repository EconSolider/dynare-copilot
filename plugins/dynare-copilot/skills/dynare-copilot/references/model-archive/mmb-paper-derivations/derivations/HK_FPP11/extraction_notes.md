# HK_FPP11 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row 39 maps `HK_FPP11` to Funke, Paetz, and Pytlarczyk (2011), DOI `10.1016/j.econmod.2010.08.016`.
- The row has `source_match_status=matched`, `source_match_score=1.0000`, and `model_title_match_score=1.0000`.
- Primary Markdown exists at `raw/mmb_mineru/runs/hk_fpp11__stock_market_wealth_effects_in_an_estimated_dsge_model_for_hong_kong__24bfe42d/full.md`.
- Raw PDF existence was checked at `raw/mmb_papers/Stock market wealth effects in an estimated DSGE model for Hong Kong.pdf`; the PDF body was not read.
- No `docs/mmb_appendix_full_normalizations/HK_FPP11.md` file exists.

## Formula Quality

- Status: `needs_review`.
- The main model equations are visible in the MinerU Markdown: household FOCs, wealth effect consumption law, price-setting, canonical dynamic IS curve, stock-price gap dynamics, hybrid NKPC, natural output, natural rate, and AR(1) shocks.
- Some OCR fragments around Greek parameters are noisy. The derivation uses paper-visible formulas plus implementation cross-check labels where necessary, but the exact definitions of composite coefficients such as `Gamma_0`, `Gamma_y*`, `Theta`, and `lambda_q` should receive targeted source-level review before promotion.
- The Markdown row for Eq. (53) prints the foreign-demand persistence subscript inconsistently in one location. The implementation cross-check uses `rho_y`; the derivation records it as `rho_{y^*}`.
- The cost-push shock is represented directly in the Phillips curve and as `mu_p` in the MMB implementation; no separate AR(1) process was identified in the model block.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/HK_FPP11_rep.mod` exists and was used only as `implementation_cross_check`.
- Cross-check confirms `model(linear)` and the MMB variable set: `x`, `q_dach`, `r`, `rr`, `pi_H`, `a`, `y_stern`, `pi`, `s`, `e`, `y`, `y_n`, `shock_eta`.
- Cross-check confirms exogenous innovations `epsa`, `epsy`, `mu_p`, and `epseta`.
- The replication file notes two author-confirmed typos in the original code: `gamma=0.13` rather than `0.03`, and a minus sign on the foreign-demand shock term in natural output. These notes were not treated as paper-side sources, but they support the `needs_review` flag for implementation provenance.

## Deferred Issues

- Runtime validation was not performed.
- No Dynare steady-state, residual, Blanchard-Kahn, or IRF checks were run.
- The derivation should be reviewed against the raw PDF or an appendix normalization before marking it `reviewed_derivation`.
- The interest-rate closure in the paper is an exchange-rate peg. The MMB implementation uses a simple rule `r = phi_pi*pi_H` with `phi_x=0`; this is recorded as an implementation cross-check rather than as a separate structural source claim.

## Translation Status

- English derivation was written first.
- Chinese derivation was translated from the English draft.
- Both files preserve eight required sections and 20 equation numbers `(F1)` through `(F20)`.
