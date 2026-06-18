# NK_PP17 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row 88 maps `NK_PP17` to "Coordinating monetary and macroprudential policies" with `model_title_match_score=1.0000`.
- The first Markdown lines show the expected authors and title.
- Raw PDF exists at `raw/mmb_papers/Coordinating monetary and macroprudential policies.pdf`.
- No appendix normalization file was found at `docs/mmb_appendix_full_normalizations/NK_PP17.md`.

## Formula Quality

- Status: `needs_review`.
- Paper equations (1)-(23), (25)-(27), and selected later policy equations are readable in the MinerU Markdown.
- Paper equation (24) has malformed tag spacing in the OCR text (`(2 4)`), but the mathematical content is mostly readable and was cross-checked against the Rep-MMB `.mod` equation named `(24) Net worth evolution`.
- Several prose/math fragments around definitions of `\pi_t`, `\pi_{n,t+1}`, and the post-equation (26) definitions contain OCR garbage. These were not used as standalone equations without nearby context.
- The nonlinear Rotemberg Phillips curve and bank block should be source-level checked against the PDF before any reviewed status upgrade.

## Implementation Cross-Check

- Read `.agents/skills/dynare-copilot/references/examples/NK_PP17_rep.mod` only as `implementation_cross_check`.
- Confirmed `model(linear)`.
- Confirmed endogenous variables: `y`, `yg`, `R`, `pi`, `phi`, `n`, `del`, `S`, `z`, `a`, `ns`, `eps_m`, `eps_R`, `lam`.
- Confirmed exogenous innovations: `eta_a`, `eta_m`, `eta_n`, `eta_R`, `eta_l`.
- Confirmed Rep-MMB closure: `S = 0` and Taylor rule `R = tau*pi + tau_g*yg + eps_R`.
- Confirmed implementation notes that `rho_R` and `rho_l` are not given in the paper.
- Calibration discrepancy: the paper text reports Rotemberg cost `\varphi=173.08`, while the Rep-MMB file sets `varphi=211`; the `.mod` comments identify this as inherited from CFP(2010). This should be reviewed before promotion.

## Deferred Issues

- No Dynare run was performed.
- No PDF-body formula check was performed.
- The derivation records both nonlinear source equations and the linear Rep-MMB system; a future reviewer should decide whether the reviewed archive entry should privilege only the paper's optimal-policy linear system or the Rep-MMB simple-rule closure.
- The alternative liquidity-requirement instrument equations (43)-(46) were noted but not included in the baseline Rep-MMB equation count.

## Translation Status

- English derivation drafted first.
- Chinese derivation translated from the English file while preserving section order, equation numbers, file paths, DOI, model id, and status markers.
