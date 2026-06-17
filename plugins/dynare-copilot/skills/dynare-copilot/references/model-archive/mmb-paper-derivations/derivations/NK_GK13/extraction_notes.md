# NK_GK13 Extraction Notes

## Source Match

- Model row: `raw/mmb_mineru/model_index.csv`, `model_id=NK_GK13`.
- Paper title in row: "Qe 1 vs. 2 vs. 3. . . : A framework for analyzing large-scale asset purchases as a monetary policy tool".
- Primary source title in row: "A framework for analyzing large-scale asset purchases as a monetary policy tool".
- Match score: `0.9133`.
- Match notes: `primary source title differs from model title; review variant mapping`.
- MinerU run IDs listed in row: `77fee003-da75-47f6-9694-b53639b36ead; ba1c32ee-65ff-4cd8-9371-619bbe7a043a`.
- Primary full Markdown used: `raw/mmb_mineru/runs/nk_gk13__qe_1_vs_2_vs_3_a_framework_for_analyzing_large_scale_asset_purchases_as__77fee003/full.md`.
- Raw PDF path checked and found present: `raw/mmb_papers/A framework for analyzing large-scale asset purchases as a monetary policy tool.pdf`.
- Raw PDF body was not read. No targeted formula check was performed against the PDF.
- Appendix normalization: no `docs/mmb_appendix_full_normalizations/NK_GK13.md` file exists.

## Formula Quality

- Overall formula quality: `needs_review`.
- The main household, bank, central-bank, production, policy, and market-clearing equations are visible in the Markdown.
- OCR/source ambiguity: around the LSAP purchase rules, the Markdown prints both purchase fractions as `\varphi_{st}`. The English and Chinese derivations use `\varphi_{st}` for private securities and `\varphi_{bt}` for bonds, consistent with the surrounding text and the MMB implementation cross-check.
- OCR/source ambiguity: the resource-cost expression prints `\tau_g` for the government-bond purchase cost, while the government budget and text use a bond-intermediation cost. The derivations use `\tau_b` and mark the issue.
- Long-term yield equations (paper equations 26-28 and 46-47) were not included as core equilibrium F-equations because they are reporting/yield-construction equations; the OCR around equation 26 is visibly noisy.

## Implementation Cross-Check

- Cross-check file: `.agents/skills/dynare-copilot/references/examples/NK_GK13_rep.mod`.
- Used only to check variable coverage, shock names, purchase-rule separation, timing, and the fact that the implementation is linearized around logged steady states.
- The `.mod` contains endogenous variables including `Ym Y D K Keff L I C G Q varrho Lambda Z Ne Nn Rk Rb qn mu_s mu_b nu phi x Omega Pm X F H ir ib prem_K prem_B w qn_rf iir prem_ib rb q qB N Kb Bb Dep Nbook phibook Kbook Qfair Qbook qnbook Kh Bh irstar Welf a ksi g shock_ir infl inflstar psi Gamma shock_psi shock_Gamma ... zlb`.
- The `.mod` contains shocks `e_a e_ksi e_g e_Ne e_ir e_psi e_Gamma e_zlb`.
- Implementation-only extras such as `e_Ne`, book/fair-value accounting variables, ZLB indicator variables, and convenience yield variables were recorded as cross-check information but not treated as paper-side equations.
- Runtime validation was not performed.

## Deferred Issues

- Human review should confirm that the `77fee003` primary run is the preferred MinerU source over the alternate `ba1c32ee` run.
- Human review should confirm the LSAP bond-share notation and the resource-cost notation against the PDF if this entry is promoted beyond first-pass `needs_review`.
- The steady-state section is a source-backed solve order plus calibration targets, not a verified numeric steady-state reconstruction.
- The derivation does not attempt to reproduce the MMB linearized 67-equation implementation; it extracts the paper-side structural model and records implementation-only conveniences separately.

## Translation Status

- English derivation drafted first.
- Chinese derivation translated from the English derivation after the English structure was checked.
- Equation numbers `(F1)` through `(F47)` are intended to match exactly across English and Chinese files.
