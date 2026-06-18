# US_RE09 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row 161 maps `US_RE09` to "A sticky-information general-equilibrium model for policy analysis" with DOI `10.3386/w14732`, match status `matched`, and title match score `1.0000`.
- The primary Markdown path exists: `raw/mmb_mineru/runs/us_re09__a_sticky_information_general_equilibrium_model_for_policy_analysis__492aea55/full.md`.
- The raw PDF path exists: `raw/mmb_papers/A sticky-information general-equilibrium model for policy analysis.pdf`.
- The first 80 lines of both MinerU runs (`492aea55` and `e6aa6b2a`) begin with "Optimal Monetary Policy Rules in an Estimated Sticky-Information Model" by Ricardo Reis, not the indexed title. The document content is the SIGE policy-analysis paper and includes the sticky-information model equations used here, but this version/title mismatch is a `source_index_issue` and the entry remains `needs_review`.
- No `docs/mmb_appendix_full_normalizations/US_RE09.md` file exists.

## Formula Quality

- Core paper-side formulas extracted from the Markdown include the household problem, budget constraint, goods and labor aggregators, firm profit problem, Taylor rule, flexible-information reduced-form equations, sticky-information Phillips/IS/wage curves, and AR(1) shock processes.
- First-pass uncertain formulas are explicitly marked `needs_review` in the derivations:
  - The Euler-equation notation uses $`C_{t,j}^{-1/\theta}`$ in the OCR while the surrounding parameter list in the paper emphasizes $`\xi`$, $`\psi`$, $`\nu`$, $`\gamma`$, $`\beta`$, and related terms. The implementation uses `theta` in output and wage sticky-information target equations.
  - The sticky-information IS equation appears with $`y_\infty^n`$ in the rendered equation but the surrounding text defines the wealth measure as $`y_\infty^c`$; the derivation uses $`y_\infty^c`$ and records the issue.
- The paper is a reduced-form log-linear system. It does not provide a nonlinear steady-state system comparable to a Dynare `steady_state_model`; steady-state notes are therefore `needs_review`.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/US_RE09_rep.mod` was read only as `implementation_cross_check`.
- Cross-check observations:
  - The implementation uses `model(linear)`.
  - The implementation declares endogenous variables `y a l p w yinfn i R pi outputgap yclas deltaa g nuu gam eps z zwage zoutput`.
  - The implementation uses exogenous innovations `e_deltaa e_g e_nuu e_gam e_eps`.
  - The implementation truncates the paper's infinite sticky-information expectations sums at 16 lagged information sets.
  - The implementation defines `pi = p - p(-1)` and `outputgap = y - yclas`.
- Dynare was not run.

## Deferred Issues

- Review the title/version mismatch between `model_index.csv`, raw PDF filename, and MinerU Markdown title before promoting this entry out of first-pass status.
- Review the equation count mapping between the paper's 20 documented archive conditions and the MMB replication's 19 endogenous variables plus auxiliary sticky-information targets.
- Source-level check the ambiguous $`y_\infty^c`$ versus $`y_\infty^n`$ OCR rendering against the PDF if exact formula fidelity is required.
- Source-level check the intertemporal elasticity notation around the Euler equation and the implementation's `theta` usage.
- Runtime validation, BK checks, steady-state checks, and IRF checks are deferred by instruction.

## Translation Status

- English derivation was drafted first.
- Chinese derivation was translated from the English derivation second.
- Equation numbers `(F1)` through `(F20)`, file paths, model IDs, DOI values, and `needs_review` markers were preserved.
