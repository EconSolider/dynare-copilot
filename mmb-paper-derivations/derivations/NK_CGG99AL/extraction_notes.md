# NK_CGG99AL Extraction Notes

## Source Match

- `model_id`: `NK_CGG99AL`
- Source title match score: `1.0000`
- MinerU run id: `d3d8dd41-6e6e-4b99-a950-51f1eeae5ef4`
- Primary Markdown: `raw/mmb_mineru/runs/nk_cgg99_nk_cgg99al__the_science_of_monetary_policy_a_new_keynesian_perspective__d3d8dd41/full.md`
- Raw PDF: `raw/mmb_papers/The Science of Monetary Policy- A New Keynesian Perspective.pdf`
- PDF path exists and was hashed, but the PDF body was not read.

## Formula Quality

- Overall status: `needs_review`.
- The baseline equations in Section 2.1 are readable enough to extract the output gap, IS curve, Phillips curve, AR(1) shocks, forward solutions, and policy objective.
- The OCR around the demand-shock innovation in equation (2.3) is damaged; the derivation uses conventional `\hat{g}_t` notation and flags it.
- The OCR around some commitment-policy symbols is noisy, especially the feedback coefficient and superscripted commitment variables. The derivation uses standard notation `\omega`, `x_t^c`, and `\pi_t^c` based on context.
- The paper states that the IS curve and Phillips curve come from household Euler and Calvo pricing problems, but it intentionally does not print full primitive optimization problems. Those generic problems are included only as source-consistent context and are marked `needs_review`.

## Implementation Cross-Check

- Optional implementation file `.agents/skills/dynare-copilot/references/examples/NK_CGG99AL_rep.mod` does not exist.
- Optional appendix normalization `docs/mmb_appendix_full_normalizations/NK_CGG99AL.md` does not exist.
- No MMB `.mod` file was used as a mathematical source.

## Deferred Issues

- Confirm whether `NK_CGG99AL` is intended to archive only the compact baseline log-linear model, or also a specific MMB implementation variant not visible in the local optional example path.
- Source-check equations (F4), (F5), (F7), (F8), and (F32) against the PDF or a cleaner source before promotion.
- Decide whether the commitment-policy equations (F16)-(F26) should be part of the runnable model target or treated as policy-analysis reference equations.
- Runtime validation was not performed; no Dynare `model(linear)` file was created or run.

## Translation Status

- English derivation drafted first.
- Chinese derivation translated from the English core.
- Section headings and equation numbers were preserved with matching `(F1)` through `(F32)` counts.
