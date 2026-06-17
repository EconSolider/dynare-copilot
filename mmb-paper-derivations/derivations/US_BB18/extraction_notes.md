# US_BB18 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row found for `US_BB18`.
- Match status: `matched`.
- MinerU match score: `1.0000`.
- Model title match score: `1.0000`.
- Primary Markdown: `raw/mmb_mineru/runs/us_bb18__oil_supply_shocks_and_the_u_s_economy_an_estimated_dsge_model__fb6c41df/full.md`.
- Raw PDF exists: `raw/mmb_papers/Oil supply shocks and the U.S. economy- An estimated DSGE model.pdf`.
- PDF body was not opened. The raw PDF is recorded for provenance only.
- No appendix normalization file exists at `docs/mmb_appendix_full_normalizations/US_BB18.md`.

## Formula Quality

The primary Markdown contains the paper's model section with numbered equations for the household, production, market-clearing, ROW, optimal oil-use, estimation, and calibration blocks. This is stronger than a narrative-only overview source.

Remaining limitations:

- Several OCR equations have malformed fragments, especially the capital-services supplier objective, final goods resource constraint, GDP measurement equation, and some ROW explanatory text.
- The paper states that FOCs and market-clearing equations are log-linearized, but the Markdown does not print the complete expanded log-linear system.
- The derivation therefore records the paper-side nonlinear or semi-structural equations and selected FOCs, while marking uncertain equations as `needs_review`.
- No missing formula was silently filled in from the `.mod` file.

## Implementation Cross-Check

Read `.agents/skills/dynare-copilot/references/examples/US_BB18_rep.mod` only as `implementation_cross_check`.

Used for:

- confirming `model(linear)` form;
- checking timing for stocks and efficiency variables: `kc(-1)`, `kf(-1)`, `km(-1)`, `ko(-1)`, `ec(-1)`, `ef(-1)`, `em(-1)`;
- checking endogenous variable families and auxiliary measurement variables;
- checking exogenous innovations: `vzm`, `vzc`, `vzo`, `vzoil`, `vzrowgdp`, `vznetexpf`, `vmk`, `vzprow`, `vzI`, `vzrisk`, `vzdoil`, `vpifstar`, `vR`;
- checking that the implementation expands the paper blocks into 99 linear equations.

Not used for:

- claiming paper-side equations where the Markdown is silent or malformed;
- runtime validation;
- promotion to `.agents/skills/dynare-copilot/references/model-archive/`.

## Deferred Issues

- Source-level review should check the raw PDF or a technical appendix for the complete log-linear equilibrium system.
- OCR for the capital-services supplier objective in paper Eq. (28) needs targeted formula review.
- OCR for the final goods resource constraint in paper Eq. (38) needs targeted formula review.
- OCR for the real GDP identity near paper Eq. (40) needs targeted formula review.
- The exact AR transition equations for all U.S. structural shocks are visible in the implementation but not printed as a compact paper-side list in the Markdown.
- Equation-variable count equality is not meaningful for this first-pass derivation because the paper-side derivation is block-level while the implementation has 99 expanded linear equations.
- Runtime validation, Dynare residual checks, Blanchard-Kahn checks, IRF checks, and archive promotion were not performed.

## Translation Status

- English draft was written first.
- Chinese draft is a translation of the English draft.
- Equation numbers `(F1)` through `(F47)` are preserved in both files.
