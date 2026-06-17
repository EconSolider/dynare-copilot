# NK_KW16 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row: `NK_KW16`.
- Primary title match is exact (`model_title_match_score = 1.0000`).
- Primary Markdown: `raw/mmb_mineru/runs/nk_kw16__fiscal_deficits_financial_fragility_and_the_effectiveness_of_government__1f4dab15/full.md`.
- Raw PDF exists at `raw/mmb_papers/Fiscal deficits, financial fragility, and the effectiveness of government policies.pdf`.
- The raw PDF path was checked for existence only in this build; the PDF body was not read.
- No optional normalization file was present at `docs/mmb_appendix_full_normalizations/NK_KW16.md`.

## Formula Quality

- Overall status: `needs_review`.
- The paper body directly supports the model architecture: households, banks, MMFs, government debt allocation, fiscal policy, Taylor rule, Fisher relation, and core bank balance-sheet equations.
- The MinerU Markdown explicitly states that the full formal structure, steady state, and dynamics are listed in the appendix, but the local source only contains an online supplementary-data pointer.
- Equations (F1)-(F40) were drafted from the MMB implementation as `implementation_cross_check` and should be checked against the online supplementary appendix before the entry is upgraded beyond `needs_review`.
- The gross-rate vs net-rate distinction is important: the paper prints several equations in net rates, while the `.mod` uses gross rates inside `exp()` variables.

## Implementation Cross-Check

- Cross-check file: `.agents/skills/dynare-copilot/references/examples/NK_KW16_rep.mod`.
- Used only for variable names, shock names, timing, equation coverage, and steady-state sequencing.
- The `.mod` confirms the nonlinear/log-level `exp()` implementation and does not use `model(linear)`.
- The `.mod` confirms endogenous variables including `Y, Ym, L, w, C, U_c, Lambda, I, K, Q, a, ksi, Pm, infl, inflstar, F, Z, Dis, Rd, i, Rk, Rb, Rp, ERk, ERb, prem, prem2, Phi, portf_B, N, Om, D, nu_k, nu_b, nu_n, G, g, Gy, T, B`.
- The `.mod` declares shocks `e_ksi, e_g, e_i, e_a, e_n`; `e_n` is declared but not used in the displayed model block.
- The `.mod` confirms calibrations such as `beta=0.99`, `hh=0.815`, `delta=0.025`, `varphi=0.276`, `eta_i=1.728`, `alpha=0.33`, `gam=0.779`, `epsilon=4.167`, `G_over_Y=0.2`, `B_over_Y=2.4`, and `Phi_ss=4`.

## Deferred Issues

- Runtime validation was not performed; the user explicitly instructed not to run Dynare.
- The online supplementary appendix should be obtained and checked before formula status is upgraded.
- The paper discusses policy variants with pre-announced spending shocks, capital-quality-shock fiscal responses, bank recapitalization, and MMF-vs-bank financing shares; the archived MMB `.mod` implements the Figure 1 bank-financing stochastic closure rather than all policy variants.
- The Taylor rule in the derivation records both paper-side net-rate notation and implementation-side gross-rate notation; this should be source-checked against the supplementary appendix.
- No shared `catalog.csv` or `status.csv` rows were edited by request.

## Translation Status

- English derivation drafted first.
- Chinese derivation translated from the English artifact.
- F-number counts match: 40 in English and 40 in Chinese.
