# US_DG08 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row 118 maps `US_DG08` to De Graeve (2008), "The external finance premium and the macroeconomy: US post-WWII evidence."
- Match status is `matched`; MinerU match score and model-title match score are both `1.0000`.
- First-page Markdown sniff confirms the expected title and author.
- Raw PDF exists at `raw/mmb_papers/The external finance premium and the macroeconomy- US post-WWII evidence..pdf`.
- No appendix normalization file exists at `docs/mmb_appendix_full_normalizations/US_DG08.md`.

## Formula Quality

- Paper equations (1)-(12) were extracted into continuous archive equations (F1)-(F12), with additional identities and exogenous processes numbered (F13)-(F21).
- The model is explicitly log-linearized in the paper, so the steady state is recorded as zero deviations plus nonzero steady-state ratios and estimated/calibrated constants.
- `needs_review`: OCR renders the external finance elasticity symbol as a dash in prose. The derivation uses $`\varepsilon`$ because paper equation (9), Table 1 context, and `US_DG08_rep.mod` use that symbol.
- `needs_review`: paper equation (6) has a compact investment-technology disturbance term, while `US_DG08_rep.mod` normalizes the implemented shock as `tau*(1+beta)*phi*eps_I`.
- `needs_review`: the paper does not print the full nonlinear optimization problems; Section 2 of the derivation records the economic primitives implied by the printed log-linear system.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/US_DG08_rep.mod` was read only as implementation_cross_check.
- Cross-check confirms `model(linear)`, the main endogenous variables, shock names, the flexible-price counterpart block, and MMB posterior-mode parameter values.
- Cross-check was used to express `Prem = Rkforward - R`, `Rkforward = Rk(+1)`, the Fisher identity, AR(1) shock names, and the expanded utilization/bankruptcy terms in the resource constraint.
- Dynare was not run.

## Deferred Issues

- A targeted PDF formula check should verify the signs and expectations in the consumption Euler equation, sticky wage equation, and external finance premium condition.
- A reviewer should reconcile the paper's investment-shock normalization with the MMB implementation normalization before using the derivation as a source for code generation.
- The flexible-price block is currently recorded as implementation_cross_check rather than paper-side derivation because the paper defines the policy output objective verbally.
- Runtime validation, BK checks, residual checks, and IRF reproduction are deferred.

## Translation Status

- English derivation drafted first.
- Chinese translation drafted from the English version with identical section order and matching `(F#)` numbering.
