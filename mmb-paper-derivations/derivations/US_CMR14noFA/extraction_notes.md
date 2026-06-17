# US_CMR14noFA Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` selects `raw/mmb_mineru/runs/us_cmr14_us_cmr14nofa__risk_shocks__d33971b2/full.md`.
- The selected row has `model_title_match_score=1.0000`, `mineru_match_score=1.0000`, and no `model_match_notes`.
- The first Markdown lines match the expected title, authors, DOI, and abstract for "Risk shocks."
- Raw PDF exists at `raw/mmb_papers/Risk shocks.pdf`.
- No appendix normalization file exists at `docs/mmb_appendix_full_normalizations/US_CMR14noFA.md`.

## Extraction Scope

- English derivation was drafted first using the eight required sections.
- Chinese derivation is a translation of the English draft and preserves every `(F#)` marker.
- The entry targets `US_CMR14noFA`, the no-financial-frictions CEE-style variant described in the paper, not the baseline CMR14 model with risk shocks and BGG financial accelerator.
- The `.mod` file `.agents/skills/dynare-copilot/references/examples/US_CMR14noFA_rep.mod` was read only as `implementation_cross_check`.
- Dynare was not run.

## Formula Quality

- Overall formula status: `needs_review`.
- The main article contains the standard-model equations for production, preferences, budget constraints, financial frictions, policy, and shock discussion, but it says detailed equation lists are in the online appendix and code.
- For `US_CMR14noFA`, paper-side evidence is strongest for the variant definition: add a household capital Euler equation and drop the financial-contract optimality condition, bank zero-profit condition, entrepreneurial net-worth law, and monitoring costs.
- The exact Calvo wage and price auxiliary normalizations are implementation-backed and need source-level review against the online appendix or PDF appendix material before this entry can be marked `reviewed_derivation`.
- The resource constraint and return-on-capital timing were not PDF-checked.

## Implementation Cross-Check

- The implementation file lists active variables such as `c`, `i`, `kbar`, `q`, `Re`, `Rk`, `rk`, `u`, `pi`, `pitarget`, `pstar`, `Fp`, `Fw`, `s`, `h`, `wtilde`, `wstar`, `lambdaf`, `muup`, `muzstar`, `zetac`, and `zetai`.
- It lists shocks `e_epsil`, `e_lambdaf`, `e_muup`, `e_muzstar`, `e_pitarget`, `e_zetac`, `e_zetai`, and `e_g`.
- It does not include active risk-shock, equity-shock, credit, spread, net-worth, default-cutoff, or leverage variables in the no-financial-frictions model block.
- It contains a household capital Euler equation for `Rk(+1)` and comments out the financial-contract equation that would appear in the financial-frictions version.

## Deferred Issues

- Full source-level formula review against the online appendix or PDF is still required.
- The steady-state section records source-backed targets and implementation cross-check values but does not reconstruct a full analytical `steady_state_model`.
- Equation count reconciliation should be repeated when building a runnable `.mod`, especially because the implementation uses auxiliary definitions and companion flexible-price variables.
- Runtime validation, Blanchard-Kahn checks, residual checks, and IRF checks were not performed.

## Translation Status

- Chinese translation completed after the English draft.
- English and Chinese `(F#)` counts match in validation.
