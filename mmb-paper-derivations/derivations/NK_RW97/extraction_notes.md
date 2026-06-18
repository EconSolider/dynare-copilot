# NK_RW97 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row for `NK_RW97` has `mineru_match_status=matched`, `mineru_match_score=1.0000`, `model_title_match_score=1.0000`, and no `model_match_notes`.
- Primary Markdown first 80 lines show the expected title, "An Optimization-Based Econometric Framework for the Evaluation of Monetary Policy", and Julio J. Rotemberg and Michael Woodford as authors.
- Alternate MinerU run `8afae8a2-eca9-450d-a44e-a6336fb3cff8` also begins with the expected title and authors.
- Primary Markdown: `raw/mmb_mineru/runs/nk_rw97_nk_rw97al__an_optimization_based_econometric_framework_for_the_evaluation_of_moneta__af3fb04e/full.md`.
- Raw PDF path exists: `raw/mmb_papers/An Optimization-Based Econometric Framework for the Evaluation of Monetary Policy.pdf`.
- No appendix normalization file exists at `docs/mmb_appendix_full_normalizations/NK_RW97.md`.

## Extraction Scope

- English derivation was drafted first using the required eight-section structure.
- Chinese derivation is a direct translation of the English core and preserves `(F#)` numbering, file paths, DOI values, model ID, and `needs_review` markers.
- The paper-side extraction focuses on equations (2.1), (3.1)-(3.18), and (5.1)-(5.5): the policy rule, household problem, CES price index, intertemporal budget, decision-lag IS equation, Calvo reset-pricing block, and shock-reconstruction equations.
- The `.mod` file `.agents/skills/dynare-copilot/references/examples/NK_RW97_rep.mod` was read only as `implementation_cross_check`.
- Shared `catalog.csv` and `status.csv` were not edited. Proposed rows are recorded in `worker_report.json`.

## Formula Quality

- Overall formula status: `needs_review`.
- MinerU Markdown captures the main model equations clearly enough for a first-pass derivation.
- Several OCR issues remain possible because the body PDF was not opened for formula-level comparison. Examples include Greek-letter ambiguity, line breaks in long summations, and the paper's use of $`\phi`$ both for policy coefficients and a price-setting correction term.
- The derivation normalizes notation to make the equations readable but does not claim source-level formula validation.
- Equation (F10), corresponding to paper equation (3.17), should be checked against the PDF before promotion beyond `needs_review` because it is a long multi-line condition with several nested expectations.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/NK_RW97_rep.mod` exists and was read only as `implementation_cross_check`.
- The `.mod` confirms `model(linear)` with endogenous variables `pi`, `y`, `ynat`, `rnat`, `i`, `x`, `u`, and `g`.
- The `.mod` implements a reduced Woodford-style system: NKPC, AR(1) cost-push shock, IS equation in the output gap, natural real rate, natural output, output-gap identity, AR(1) autonomous-spending shock, and Taylor rule.
- The `.mod` has shocks `u_` and `g_`; it does not include the paper's separate monetary-policy shock $`\epsilon_t`$.
- The `.mod` uses `beta=1/(1+0.035/4)` and `sigma=6.25`, while the paper text reports `beta=0.99` and `sigma=0.16`. This reflects implementation convention/scaling and is not treated as paper-side evidence.
- Dynare was not run.

## Deferred Issues

- Source-level PDF review should check long equations (3.17), (5.3), (5.4), and matrix definitions in (5.5).
- The relationship between the paper's full decision-lag system and the simpler Rep-MMB/Woodford reduced form should be reviewed before any runnable archive promotion.
- The MMB implementation does not include a monetary-policy shock innovation; future validation should decide whether to preserve the Rep-MMB two-shock specification or add the paper's policy-shock process in a separate replication.
- Runtime validation, residual checks, BK checks, IRF checks, and promotion to the runnable skill archive were not performed.

## Translation Status

- English derivation completed first.
- Chinese translation completed second.
- English and Chinese `(F#)` counts match in validation.
