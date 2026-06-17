# NK_MI14 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row found for `NK_MI14`.
- Match status: `matched`.
- MinerU match score: `1.0000`.
- Model title match score: `1.0000`.
- Primary Markdown: `raw/mmb_mineru/runs/nk_mi14__a_theory_of_countercyclical_government_multiplier__afea0443/full.md`.
- Alternate MinerU Markdown: `raw/mmb_mineru/runs/nk_mi14__a_theory_of_countercyclical_government_multiplier__ee399d61/full.md`.
- First-page sniff for both Markdown runs matches the expected title and author.
- Raw PDF exists: `raw/mmb_papers/A Theory of Countercyclical Government Multiplier.pdf`.
- PDF body was not opened, per task rule. It is recorded for provenance only.
- No appendix normalization file exists at `docs/mmb_appendix_full_normalizations/NK_MI14.md`.

## Formula Quality

The primary Markdown contains the paper's comparative steady-state search model, the New Keynesian dynamic model, the symmetric equilibrium conditions, calibration table, and multiplier formula. Most core equations are legible enough for first-pass extraction.

Consequences:

- The derivation is a source-backed first-pass dynamic-equation map.
- The unsymmetrized intermediate-firm price FOC is marked `needs_review` because MinerU splits it across two displayed equations and OCR around subscripts/ratios should be checked against the PDF before implementation use.
- The symmetric Phillips curve, household Euler equation, matching block, resource constraint, wage rule, monetary rule, technology process, and steady-state multiplier formulas are clear in the Markdown.
- No missing formula was filled in from the PDF body.

## Implementation Cross-Check

Read `.agents/skills/dynare-copilot/references/examples/NK_MI14_rep.mod` only as `implementation_cross_check`.

Used for:

- endogenous variable cues: `a`, `c`, `pie`, `l`, `n`, `th`, `R`, `g`, `gendo`, `y`, `u`, `h`, `w`, `mpl`, `f`;
- exogenous shock names: `epsa`, `hireg`;
- nonlinear form and piecewise implementation cues: `min(1,...)` for job finding and `max(1,...)` for the nominal rate;
- calibration values and weekly-frequency steady-state targets;
- public-employment shock representation using `gendo` plus `hireg`.

Not used for:

- claiming paper-side equations;
- replacing source equations;
- runtime validation;
- promotion to `.agents/skills/dynare-copilot/references/model-archive/`.

## Deferred Issues

- Targeted PDF check is needed for the unsymmetrized Rotemberg price-setting FOC before treating that equation as implementation-ready.
- The MMB implementation uses `delta` for the discount factor where the paper writes `beta`; the derivation records this as an implementation naming convention.
- The paper's symmetric equilibrium lists bonds and taxes, while the MMB implementation suppresses them through resource-constraint aggregation. A later implementation pass should decide whether to include or eliminate those variables explicitly.
- The `.mod` uses `mpl` for the marginal product / marginal revenue cue; the paper uses `Lambda_t` as the real marginal revenue of intermediate production. A later implementation pass should document the exact normalization.
- Runtime validation, Dynare residual checks, Blanchard-Kahn checks, and IRF checks were not performed.

## Translation Status

- English draft was written first.
- Chinese draft is a translation of the English draft.
- Equation numbers `(F1)` through `(F35)` are preserved in both files.
