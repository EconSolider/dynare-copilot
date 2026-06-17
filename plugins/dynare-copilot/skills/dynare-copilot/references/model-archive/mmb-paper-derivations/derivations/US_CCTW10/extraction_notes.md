# Extraction Notes: US_CCTW10

## Source Match

- `raw/mmb_mineru/model_index.csv` row 106 maps `US_CCTW10` to "New keynesian versus old keynesian government spending multipliers" with title match score `1.0000`.
- The first Markdown heading and author block in `raw/mmb_mineru/runs/us_cctw10__new_keynesian_versus_old_keynesian_government_spending_multipliers__da0c2db2/full.md` match the indexed paper.
- Raw PDF exists at `raw/mmb_papers/New keynesian versus old keynesian government spending multipliers.pdf`.
- No `docs/mmb_appendix_full_normalizations/US_CCTW10.md` file exists.

## Formula Quality

- CCTW Appendix A directly provides the rule-of-thumb household consumption equation, aggregate consumption equation, government budget constraint, log-linearized versions A.4-A.6, and fiscal rule A.7.
- The paper explicitly says the remaining Smets-Wouters model equations are not repeated and refers the reader to Smets and Wouters (2007).
- For this reason, the full Smets-Wouters core in the English and Chinese derivations is marked `implementation_cross_check` and `needs_review` rather than source-complete.
- MinerU OCR quality is adequate for Appendix A formulas, but it renders the Greek omega in prose as `o` in a few places. The derivation normalizes this to `\omega` based on the printed equations and Table A1.

## Implementation Cross-Check

- Read `.agents/skills/dynare-copilot/references/examples/US_CCTW10_rep.mod` only as an implementation cross-check.
- Cross-check observations:
  - The model is a log-linear Smets-Wouters implementation with flexible and sticky economy blocks.
  - It includes Ricardian consumption (`c_nlc`, `c_nlcf`) and rule-of-thumb consumption (`c_lc`, `c_lcf`).
  - Government debt and taxes are represented by `debt`, `debtf`, `t`, and `tf`.
  - The ARRA fiscal purchases path enters through deterministic exogenous `fiscal_`.
  - `dummy_MP` pegs the policy observable for periods 1:4 in the archived scenario.
  - The MMB file uses parameter values `omega=0.2651`, `phi_b=0.0531`, and `phi_g=0.1242`, consistent with the posterior mean estimates reported in Table A1.
- The `.mod` was not run, copied, or treated as a paper-side mathematical source.

## Deferred Issues

- Source-level review against Smets and Wouters (2007) is needed for the full household, firm, wage, price, capital, and shock blocks.
- Equation count and endogenous-variable count are not asserted as validated because the implementation includes reporting identities and deterministic scenario variables.
- The MMB file does not use an explicit `model(linear)` declaration, even though equations are in log-linear/deviation form. Runtime form should be reviewed before promotion.
- Runtime validation, Dynare residual checks, steady-state checks, BK checks, and IRF replication were not performed by instruction.

## Translation Status

- English derivation drafted first.
- Chinese derivation translated from the English derivation with the same eight sections and the same `(F#)` numbering.
- Formula numbering count matched during validation.
