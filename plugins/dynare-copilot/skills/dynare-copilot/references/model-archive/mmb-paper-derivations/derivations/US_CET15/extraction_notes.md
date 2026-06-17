# US_CET15 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row found for `US_CET15`.
- Match status: `matched`.
- MinerU match score: `1.0000`.
- Model title match score: `1.0000`.
- Primary source title: `Understanding the Great Recession`.
- Primary Markdown: `raw/mmb_mineru/runs/us_cet15__understanding_the_great_recession__310d6625/full.md`.
- Raw PDF exists: `raw/mmb_papers/Understanding the Great Recession.pdf`.
- PDF body was not opened, per task rule. It is recorded for provenance only.
- No appendix normalization file exists at `docs/mmb_appendix_full_normalizations/US_CET15.md`.

## Formula Quality

The Markdown source contains the main model exposition and many numbered equations for labor-force dynamics, household constraints, retailer production, matching, policy, technology, and Great Recession wedges. It also says that many technical details are relegated to a separate technical appendix. No normalized appendix file is present for this model.

Consequences:

- The derivation is a first-pass source-backed structural equation map.
- Calvo pricing recursions, investment FOC, utilization FOC, and labor-force FOC are marked `needs_review` where the paper-side Markdown does not provide a complete normalized derivation.
- No missing formula was silently filled in from the PDF body.
- No targeted PDF formula check was performed because the user asked to use `.mod` only as implementation cross-check and not run Dynare.

## Implementation Cross-Check

Read `.agents/skills/dynare-copilot/references/examples/US_CET15_rep.mod` only as `implementation_cross_check`.

Used for:

- confirming log-variable implementation and steady-state variable naming;
- confirming the two-parallel-economy structure: `R` economy for monetary-policy shocks under restricted information and `F` economy for other shocks under full information;
- checking implementation variable families for consumption, investment, capital, utilization, Calvo price auxiliaries, labor market values, vacancies, employment, labor force participation, technology growth, and aggregation;
- checking implementation shock names: `epsR_eps`, `muz_eps`, and `mupsi_eps`;
- checking that the local file contains `resid`, `check`, and `stoch_simul` commands, which were not run.

Not used for:

- claiming paper-side equations;
- runtime validation;
- promotion to `.agents/skills/dynare-copilot/references/model-archive/`.

## Deferred Issues

- Complete source-level formula review should inspect the raw PDF or technical appendix if available.
- Exact Calvo price recursions need source-level confirmation against the technical appendix.
- Exact investment FOC and capacity utilization FOC need source-level confirmation.
- Exact labor-force FOC normalization needs source-level confirmation.
- Steady-state derivation is a calibrated target map, not a full symbolic steady-state proof.
- Equation-variable count equality is not asserted because the MMB implementation duplicates the economy into `R` and `F` blocks for information-set handling.
- Runtime validation, Dynare residual checks, Blanchard-Kahn checks, and IRF checks were not performed.

## Translation Status

- English draft was written first.
- Chinese draft is a translation of the English draft.
- Equation numbers `(F1)` through `(F49)` are preserved in both files.
