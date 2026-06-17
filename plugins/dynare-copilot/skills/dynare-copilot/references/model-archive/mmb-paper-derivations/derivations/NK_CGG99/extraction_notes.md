# NK_CGG99 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row for `NK_CGG99` has `mineru_match_status=matched`, `mineru_match_score=1.0000`, and `model_title_match_score=1.0000`.
- Primary Markdown: `raw/mmb_mineru/runs/nk_cgg99_nk_cgg99al__the_science_of_monetary_policy_a_new_keynesian_perspective__d3d8dd41/full.md`.
- Raw PDF exists at `raw/mmb_papers/The Science of Monetary Policy- A New Keynesian Perspective.pdf`; PDF body was not read because the Markdown contained the targeted equations.
- No optional appendix normalization file exists at `docs/mmb_appendix_full_normalizations/NK_CGG99.md`.

## Formula Quality

- Source equations (2.1)-(2.4), (6.1)-(6.2), and (7.2)-(7.3) are readable in Markdown.
- Some OCR notation around Greek letters and hats is noisy, but the core equations are recoverable.
- First-pass status remains `needs_review` because the MMB implementation maps the broad CGG paper to a specific hybrid/calibrated variant rather than a single fully primitive DSGE derivation in the paper.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/NK_CGG99_rep.mod` was read only as `implementation_cross_check`.
- Cross-check confirmed endogenous variables `x`, `i`, `pi`; shocks `demand_`, `inflation_`; `model(linear)` form; hybrid IS curve; hybrid Phillips curve; and a partial-adjustment expected-inflation policy rule.
- The file comments state that the variant uses the extended model starting on page 1691, adds output persistence and endogenous inflation, uses Rotemberg-Woodford parameter choices, and uses backward-looking shares of output and inflation.

## Deferred Issues

- Confirm whether the implemented `theta=0.44` and `phi=0.48` should be documented as paper-side values, Rotemberg-Woodford imported calibration values, or MMB-specific choices.
- Confirm whether the output-gap coefficient division by 4 in the policy rule should be represented in the archive as an implementation normalization only.
- No Dynare runtime validation, BK check, moments, or IRF validation was performed.
- A future review should compare the source PDF equations only if the Markdown OCR is judged insufficient for the hybrid Section 6 and policy-rule Section 7 mapping.

## Translation Status

- English derivation was drafted first.
- Chinese derivation is a direct translation of the English core.
- Section headings and `(F#)` equation labels were preserved with matching counts.
