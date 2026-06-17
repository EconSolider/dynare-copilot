# US_ACELt Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` line 101 lists `US_ACELt` as Altig, Christiano, Eichenbaum, and Linde (2005), "Firm-specific capital, nominal rigidities."
- The linked MinerU Markdown, `raw/mmb_mineru/runs/us_acelm_us_acelswm_us_acelswt_us_acelt__firm_specific_capital_nominal_rigidities__e0fac58f/full.md`, begins with the expected paper title and authors.
- The row's raw PDF path, `raw/mmb_papers/Firm-specific capital, nominal rigidities.pdf`, exists. Per the task contract, the PDF body was not read because the Markdown source was sufficient for a first-pass structural extraction.
- No `docs/mmb_appendix_full_normalizations/US_ACELt.md` file exists.

## Formula Quality

- Status: `needs_review`.
- The paper describes the nonlinear model economy and states that the computational strategy uses a linear approximation around the non-stochastic steady state. It references a technical appendix for full computational detail.
- The English derivation uses the paper-side model description for objectives, timing, market clearing, and shock processes. It uses `US_ACELt.mod` only as `implementation_cross_check` for the technical-appendix-style linear equation backbone.
- Several equations are marked `needs_review` because they are implementation-level linear conditions whose exact source-level appendix formulas were not independently checked against a local appendix normalization:
  - capital Euler equation;
  - investment Euler equation;
  - shadow rental-rate equation;
  - marginal-cost equation;
  - consumption Euler equation;
  - wage FOC;
  - implementation linear resource constraint;
  - implementation linear production function.
- The flexible-price block is not re-numbered as separate paper-side FOCs because it duplicates the sticky-price block with `f` variables and is primarily used to construct the output gap in the implementation.

## Implementation Cross-Check

- `raw/mmb/mmci-cli/models/US_ACELt/US_ACELt.mod` and `.agents/skills/dynare-copilot/references/examples/US_ACELt_rep.mod` were read only as `implementation_cross_check`.
- The `.mod` confirms:
  - `model(linear)` form;
  - sticky-price and flexible-price blocks;
  - modelbase variables `interest`, `inflation`, `inflationq`, `outputgap`, and `output`;
  - exogenous shocks `epsilon_M_`, `eps_muz_`, `eps_muups_`, and `epsilon_t_`;
  - technology-shock timing comments: technology shock, agents' decisions, monetary policy shock;
  - `US_ACELt` is intended for neutral and investment-specific technology shocks and is not the appropriate monetary-policy-shock version.
- Dynare was not run.

## Deferred Issues

- Locate or build a local technical-appendix normalization for the Altig et al. paper before promoting this derivation toward a reviewed or runnable entry.
- Perform targeted PDF checks for all equations marked `needs_review`.
- Decide whether the four ACEL variants (`US_ACELm`, `US_ACELswm`, `US_ACELswt`, `US_ACELt`) should share a common paper-side derivation core with variant-specific timing/policy appendices.
- Confirm whether the MMB modelbase interest-rule substitution should be represented as the primary `US_ACELt` policy block or as a separate MMB implementation overlay.
- Reconstruct a full steady-state ordering from source-level appendix material before any runnable `.mod` promotion.

## Translation Status

- English derivation drafted first.
- Chinese derivation translated from the English draft.
- Equation numbers `(F1)` through `(F29)` are preserved in both files.
