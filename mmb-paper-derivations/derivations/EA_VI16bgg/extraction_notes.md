# EA_VI16bgg Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` reports `EA_VI16bgg` as matched with score `1.0000` and title-match score `1.0000`.
- Primary source title: `Financial frictions in the Euro Area and the United States- a Bayesian assessment`.
- Raw PDF path exists and was recorded for provenance. The PDF body was not read because the Markdown contains Table 1 and no targeted formula check became necessary.
- No appendix normalization file exists at `docs/mmb_appendix_full_normalizations/EA_VI16bgg.md`.

## Formula Quality

- The derivation is based on the paper's Table 1 linearized equations, not a reconstructed nonlinear model.
- Equations (F1)-(F15) cover the sticky-price SWBGG block after omitting the employment Phillips curve.
- Equations (F16)-(F22) cover the seven shock state processes.
- Equations (F23)-(F35) record the flexible-price auxiliary block used in the Rep-MMB implementation to construct the policy-rule output gap.
- The source table contains an employment Phillips curve, but `EA_VI16bgg_rep.mod` omits it. This is marked `needs_review`.
- Shock signs in (F16)-(F22) come from implementation cross-check. The paper states AR(1) shocks but does not provide all sign conventions in prose. This is marked `needs_review`.

## Implementation Cross-Check

- Cross-check file: `.agents/skills/dynare-copilot/references/examples/EA_VI16bgg_rep.mod`.
- Used only as `implementation_cross_check`.
- Confirmed `model(linear)`.
- Confirmed endogenous variables: sticky block variables, flexible-price counterparts, and seven endogenous shock states.
- Confirmed exogenous innovations: `e_a`, `e_g`, `e_x`, `e_r`, `e_p`, `e_w`, `e_k`.
- Confirmed calibration choices: `beta=0.99`, `alpha=0.33`, `delta=0.025`, `G_Y=0.20`, `N_K=0.500`, `theta=0.972`, and annual spread target of 150 basis points.

## Deferred Issues

- `needs_review`: the employment Phillips curve is source-visible but omitted in the implementation.
- `needs_review`: timing normalization from source equations with \(E_t\hat{K}_{t+1}\) and \(E_t\hat{N}_{t+1}\) to implementation variables `k` and `n`.
- `needs_review`: formula signs for shock processes should be checked against the original appendix or code comments before a reviewed archive status.
- `needs_review`: the full online appendix mentioned by the paper was not available in the required local source set and was not fetched.
- Runtime validation was not performed; no Dynare run, BK check, or IRF reproduction was attempted.

## Translation Status

- English derivation drafted first.
- Chinese derivation translated second.
- Both files preserve the same eight required sections and 35 `(F#)` markers.
