# US_MI07 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` line 152 lists `US_MI07` as Fabio Milani (2007), "Expectations, learning and macroeconomic persistence."
- The row's `primary_full_md_path`, `raw/mmb_mineru/runs/us_mi07_us_mi07al__expectations_learning_and_macroeconomic_persistence__96c7b552/full.md`, begins with the expected title and author.
- The row's `raw_pdf_path`, `raw/mmb_papers/Expectations, learning and macroeconomic persistence.pdf`, exists. Per instructions, the PDF body was not read.
- No appendix normalization file exists at `docs/mmb_appendix_full_normalizations/US_MI07.md`.

## Formula Quality

- Status: `needs_review`.
- The main aggregate equations (paper equations 1-12) are readable in MinerU Markdown and were renumbered as `(F1)` through `(F13)` for the archive.
- The subjective multi-step forecast expression is marked `needs_review`: the OCR/source text uses an $I_5$ identity matrix while $Z_t$ is defined as $[\pi_t,x_t,i_t]'$. This may reflect the augmented state vector or an OCR/notation issue and needs targeted source review.
- The paper gives a log-linear aggregate model rather than a complete nonlinear household-firm FOC derivation. Optimization blocks were therefore described at the source-supported aggregate level.
- No missing formulas were invented.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/US_MI07_rep.mod` exists and was read only as `implementation_cross_check`.
- The `.mod` confirms variable names `i`, `pi`, `pi_tilde`, `x`, `x_tilde`, `r_n`, `u`, exogenous innovations `v_r`, `v_u`, and a `model(linear)` rational-expectations equation subset.
- The `.mod` implements the rational-expectations comparison calibration with large habit/indexation values, not the baseline learning recursion. It was not used as paper-side evidence and was not run.

## Deferred Issues

- Targeted PDF review should check the dimensional convention in the forecast formula (paper equation 11).
- A future implementation phase would need to implement the constant-gain learning recursion and time-varying state-space matrices, not just the rational-expectations linear subset in the Rep-MMB `.mod`.
- The steady state of beliefs and recursive least-squares moments was not reconstructed; the archive records the zero-deviation state and marks belief steady-state details as `needs_review`.
- Dynare runtime validation was not performed.

## Translation Status

- English derivation drafted first.
- Chinese derivation translated from the English draft.
- Equation numbers `(F1)` through `(F13)` are preserved in both files.
