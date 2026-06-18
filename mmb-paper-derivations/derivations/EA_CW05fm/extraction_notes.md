# EA_CW05fm Extraction Notes

Status: `needs_review`

## Source Match

- `raw/mmb_mineru/model_index.csv` row for `EA_CW05fm` points to the Coenen and Wieland (2005) paper.
- The primary Markdown path exists: `raw/mmb_mineru/runs/ea_cw05fm_ea_cw05ta__a_small_estimated_euro_area_model_with_rational_expectations_and_nominal__61e070cd/full.md`.
- The raw PDF path exists and was recorded for provenance only: `raw/mmb_papers/A small estimated euro area model with rational expectations and nominal rigidities.pdf`.
- First-page/first-80-line sniff matched the expected title and authors. Observed OCR has minor character noise, including `Gunter` without the umlaut and recurring `in1ation` OCR artifacts.
- No `docs/mmb_appendix_full_normalizations/EA_CW05fm.md` file exists.

## Formula Quality

- MinerU captured the main model tables:
  - Table 1: overlapping contract equations M-1 through M-5.
  - Table 4: aggregate demand, policy rule, term structure, and real interest-rate equations M-6 through M-9.
  - Table 5: aggregate-demand parameter estimates.
- The English derivation extracts the paper-side RW model equations and closing block. It does not copy long prose.
- `needs_review`: the paper describes four wage-contract alternatives. The Rep-MMB comment identifies `EA_CW05fm` as the relative real wage contracting model, but the parameter values in the `.mod` (`s = 0.0742`, `gamma1 = 0.0212`) correspond to the paper's RW-S column in Table 2, while the code comment says relative real wage contracting generally. Human review should decide whether the archive label should be baseline RW or RW-S implementation variant.
- `needs_review`: the paper states that the contract block can be rewritten in terms of quarterly inflation and the real contract wage. The archive draft records the source equations and implementation cross-check, but does not fully derive the implementation's auxiliary variables (`pi1`, `infl`, `ldvindex*`, `ldpi*`) from Table 1.

## Implementation Cross-Check

- Read `.agents/skills/dynare-copilot/references/examples/EA_CW05fm_rep.mod` only as `implementation_cross_check`.
- The `.mod` confirms:
  - `model(linear)`;
  - modelbase variables `interest`, `inflation`, `outputgap`;
  - shocks `interest_`, `fiscal_`, and `e_cw`;
  - aggregate demand coefficients `delta0 = 0.0027`, `delta1 = 1.1807`, `delta2 = -0.2045`, `delta3 = -0.0947`, matching Table 5 A.2;
  - a smoothed implementation policy rule that differs from the paper's Table 4 simple Taylor rule.
- Dynare was not run.

## Deferred Issues

- Source-level formula review should verify whether `EA_CW05fm` should be described as the baseline RW or RW-S variant in the archive.
- A future implementation pass should re-derive the exact transformation from paper notation \((p_t,x_t,v_t,q_t)\) to the Rep-MMB linear auxiliary system.
- A future runtime pass should run Dynare and record steady-state/model diagnostics.

## Translation Status

- English derivation was drafted first.
- Chinese derivation is a translation of the English core and preserves all `(F#)` equation numbers.
