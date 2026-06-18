# US_LTW17rot Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row for `US_LTW17rot` matched `Clearing Up the Fiscal Multiplier Morass` with `mineru_match_score=1.0000` and `model_title_match_score=1.0000`.
- The first Markdown page/title sniff matched the expected title and authors.
- Raw PDF exists at `raw/mmb_papers/Clearing Up the Fiscal Multiplier Morass.pdf`; PDF body was not read because the task contract says not to read PDF body unless needed for targeted formula checks.
- No appendix normalization exists at `docs/mmb_appendix_full_normalizations/US_LTW17rot.md`.

## Formula Quality

- Status: `needs_review`.
- MinerU OCR is usable for model architecture but has visible formula corruption in several places:
  - final-goods and labor aggregation exponents include stray OCR fragments;
  - Calvo price-setting objective has a suspect `+` where the economic expression should multiply discount factors by profits;
  - wage indexation formula includes malformed spacing and marks;
  - government budget identity has OCR artifacts around $`P_t^B B_t`$, consumption taxes, and expenditure terms.
- The derivation keeps these equations as first-pass formulas and marks the affected equations `needs_review`.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/US_LTW17rot_rep.mod` was read only as `implementation_cross_check`.
- The `.mod` identifies this MMB variant as the rule-of-thumb-consumer version and declares `model(linear)`.
- Cross-check observations:
  - endogenous variables include `cs`, `cn`, `R`, `i`, `k`, `v`, `l`, `y`, `gc`, `c`, `q`, `rk`, `w`, `pi`, `b`, `sb`, `tauk`, `taul`, `tauc`, `r`, `z`, `mc`, `kbar`, `lambda`, `Pb`, `cstar`, fiscal accounting variables, observables, and a parallel flexprice block;
  - exogenous innovations are `eugc`, `euz`, `eua`, `eub`, `eum`, `eui`, `euw`, and `eup`;
  - the implementation sets `muHH=0.3`, while the paper's estimated specification section says the final estimated model eliminates rule-of-thumb agents with `mu=0`;
  - the implementation computes steady-state levels and solves a log-linear model.
- Dynare was not run.

## Deferred Issues

- Review `US_LTW17rot` ownership against MMB catalog metadata because the source paper's final estimation model and the MMB `rot` implementation variant differ.
- Targeted PDF checks are needed for the Calvo price objective, wage indexation equation, government budget constraint, and any missing nonlinear saver FOCs.
- The current document is a derivation-only archive entry; runtime validation, BK checks, IRF checks, and promotion to the runnable skill archive are deferred.

## Translation Status

- English derivation was written first.
- Chinese derivation was translated second from the English core.
- Equation numbers `(F1)` through `(F37)` are preserved in both files.
