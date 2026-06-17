# NK_ST13 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row for `NK_ST13` is matched with score `1.0000`.
- Primary Markdown title sniff: `INSIDE MONEY IN GENERAL EQUILIBRIUM: DOES IT MATTER FOR MONETARY POLICY?`
- Primary paper: Livio Stracca (2013), "Inside money in general equilibrium: Does it matter for monetary policy?", DOI `10.1017/s1365100511000368`.
- Raw PDF exists at `raw/mmb_papers/Inside money in general equilibrium- Does it matter for monetary policy?.pdf`; the PDF body was not read because the Markdown contained the model equations needed for first-pass extraction.
- No `docs/mmb_appendix_full_normalizations/NK_ST13.md` file exists.

## Formula Quality

- Status: `needs_review`.
- The model equations in Section 2 of the Markdown are mostly legible and were sufficient for a first-pass derivation.
- The household deposit FOC is marked `needs_review` because the Rep-MMB implementation comments that the sign on the deposit-in-advance multiplier differs from the paper. The English derivation follows the paper-side equation.
- The firm real marginal-cost expression is marked `needs_review`: the OCR display for equation (25) joins labor and capital marginal-cost relationships and needs PDF-level inspection before any reviewed archive promotion.
- The steady-state money-demand appendix is marked `needs_review` because the OCR for equation (A.5) includes an apparent trailing `= 0`; the derivation uses the paper's logged expression in equation (14)/(A.6).

## Implementation Cross-Check

- Read `.agents/skills/dynare-copilot/references/examples/NK_ST13_rep.mod` only as `implementation_cross_check`.
- No Dynare run was performed.
- Cross-check confirmed the implementation variables for consumption, investment, output, labor, wage, capital, deposits, bonds, loans, loan/deposit rates, multipliers, SDF, inflation, marginal cost, marginal products, intermediation costs, inside-money premium, external finance premium, $\alpha_t$, $\omega_t$, $A_t$, and $\theta_t`.
- Cross-check also confirmed a parallel frictionless block in the implementation. The archive derivation documents the paper-side baseline and notes the frictionless implementation as a reference block rather than a separate paper source.

## Deferred Issues

- PDF-level formula verification should inspect equations (11), (25), and Appendix equations (A.5)-(A.6).
- The paper's notation for $\psi_{t,t+1}$ includes an expectation in the definition; the implementation uses a one-step SDF variable. The timing convention should be reviewed before generating executable code from this archive entry.
- The optional banking-distress variant $\sigma_t=\sigma+\omega_t-\omega$ is recorded but not treated as the baseline model.
- Runtime validation, steady-state residual checks, BK checks, and IRF comparison are deferred by instruction.

## Translation Status

- English derivation drafted first.
- Chinese derivation translated from the English draft.
- Equation numbering `(F1)` through `(F31)` is preserved across both files.
