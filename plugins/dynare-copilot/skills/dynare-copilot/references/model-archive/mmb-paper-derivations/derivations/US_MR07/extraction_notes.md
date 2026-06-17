# US_MR07 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row for `US_MR07` is matched with score `1.0000`.
- Primary source title is `Sticky information in general equilibrium.` with model title match score `1.0000`.
- Source Markdown: `raw/mmb_mineru/runs/us_mr07__sticky_information_in_general_equilibrium__3f559c99/full.md`.
- Raw PDF exists at `raw/mmb_papers/Sticky information in general equilibrium..pdf`; it was recorded for provenance but not opened for body extraction.
- No appendix-normalization file exists at `docs/mmb_appendix_full_normalizations/US_MR07.md`.

## Formula Quality

- The available Markdown contains the journal article body and the five key reduced-form relations: price-setting / aggregate supply, IS, wage-setting, production, and Taylor rule.
- The paper states that detailed model presentation, equilibrium definition, loglinearization, and coefficient formulas are in an appendix available in the working-paper version. That appendix is not present in the required source set for this entry.
- The long real interest rate notation around equation (2) has OCR noise. The archive derivation records the economic object and marks exact index notation as `needs_review`.
- The natural-output closed form used in the derivation is marked `needs_review` because it is cross-checked from `.agents/skills/dynare-copilot/references/examples/US_MR07_rep.mod`, not directly printed in the available Markdown source.
- Productivity is described in the paper text as a productivity-growth AR(1) shock. The `.mod` represents this through a second-order process for productivity level plus `da = a - a(-1)`. This mapping is marked `needs_review`.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/US_MR07_rep.mod` was read only as `implementation_cross_check`.
- The implementation confirms `model(linear)`, endogenous variables `x pi y yn i l p w R g a e v gam da`, exogenous innovations `g_e a_e e_e v_e gam_e`, and parameters `delta lambda omega beta phi_p phi_y mu theta psi gamma rho_g rho_a rho_e rho_v rho_gam`.
- The implementation approximates the infinite sticky-information sums with 30 lag terms for `p`, `w`, `l`, `R`, and `y`.
- The implementation uses `y100 = y(+150)` as a proxy for long-run output.
- The implementation includes `check;` and `stoch_simul`, but no Dynare command was run for this task.

## Deferred Issues

- Locate and inspect the working-paper appendix if source-level checking of primitive optimization problems, equilibrium definitions, coefficient recursions, and exact natural-output formulas is required.
- Check exact OCR/index notation for the long real interest rate in equation (2).
- Confirm whether the archive should record both paper notation `\nu` and implementation notation `mu` for goods substitutability in any future shared catalog merge.
- Runtime validation, equation count against Dynare internals, and simulation behavior are deferred.

## Translation Status

- English derivation was drafted first.
- Chinese derivation was created second as a translation of the English core.
- Equation numbering `(F1)` through `(F13)` is preserved in both files.

## Proposed Status

- `status`: `needs_review`
- `formula_quality`: `first_pass_markdown_reduced_form_equations_legible_appendix_missing`
- `steady_state_quality`: `linear_zero_steady_state_recorded`
- `needs_human_review`: `true`
