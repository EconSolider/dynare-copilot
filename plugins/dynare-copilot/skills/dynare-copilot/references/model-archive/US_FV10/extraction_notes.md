# US_FV10 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row for `US_FV10` maps to "The Econometrics of DSGE Models" with `mineru_match_score=1.0000` and `model_title_match_score=1.0000`.
- First-page sniff of `raw/mmb_mineru/runs/us_fv10__the_econometrics_of_dsge_models__99400522/full.md` matches the expected title, author Jesús Fernández-Villaverde, and abstract.
- Raw PDF exists at `raw/mmb_papers/The Econometrics of DSGE Models.pdf`.
- No appendix normalization exists at `docs/mmb_appendix_full_normalizations/US_FV10.md`.

## Formula Quality

Status: `needs_review`.

- The core model equations are in paper section 5 and were extracted from the MinerU Markdown.
- The household consumption FOC appears twice. The first occurrence uses the coherent habit term `c_{j,t+1}-h c_{jt}`; the later aggregate repetition appears OCR-corrupted as `c_t-hc_t`. The derivation uses the coherent first occurrence and marks (F1) as `needs_review`.
- The composite trend definition includes an OCR artifact after the displayed formula. The derivation reconstructs (F27) using the adjacent formula and the implementation cross-check.
- The investment-specific technology process is implied by the composite trend and parameter tables, but the Markdown did not expose a clean standalone displayed law analogous to the neutral-technology law. (F30) is marked `needs_review`.
- Preference and labor-disutility shock AR(1) equations are supported by Table 1/Table 3 parameter names in the paper and by the implementation cross-check, but the displayed laws in this Markdown were not located as explicit paper-side equations. They are marked `implementation_cross_check`.

## Implementation Cross-Check

- Read `.agents/skills/dynare-copilot/references/examples/US_FV10_rep.mod` only as `implementation_cross_check`.
- The `.mod` comments identify Fernández-Villaverde and Rubio-Ramírez (2006), "A Baseline DSGE Model", as the detailed equation source and Fernández-Villaverde (2010) as the parameterization source. For this reason, `.mod` equations were not treated as primary mathematical evidence.
- Cross-check confirmed variable and shock coverage: `c`, `lambda`, `R`, `PI`, `r`, `x`, `u`, `q`, `f`, `ld`, `w`, `wstar`, `PIstarw`, `PIstar`, `g1`, `g2`, `yd`, `mc`, `k`, `vp`, `vw`, `l`, `d`, `phi`, `mu_I`, `mu_A`, `mu_z`, `yg`, and shocks `epsd`, `epsphi`, `epsmu_I`, `epsA`, `epsm`.
- Cross-check confirmed capital as predetermined and production using lagged capital.

## Deferred Issues

- Human review should compare formulas against the raw PDF or the FV-RR baseline model paper for the habit FOC, the exact stationary transformation, and the external steady-state file logic.
- The archive needs a later implementation-validation phase before any promotion into the runnable Dynare skill archive.
- Dynare runtime validation was not performed, by instruction.

## Translation Status

- English derivation was drafted first.
- Chinese derivation was translated second from the English core.
- Equation numbers `(F1)` through `(F33)` are preserved in both versions.
