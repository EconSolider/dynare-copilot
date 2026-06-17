# US_FRB22_mceall Extraction Notes

Status: `needs_review`

## Source Match

- `raw/mmb_mineru/model_index.csv` row 133 maps `US_FRB22_mceall` to Brayton and Reifschneider (2022), "LINVER: The Linear Version of FRB/US."
- Primary Markdown path exists: `raw/mmb_mineru/runs/us_frb22_mcap_us_frb22_mcapwp_us_frb22_mceall_us__linver_the_linear_version_of_frb_us__a8780356/full.md`.
- Raw PDF path exists: `raw/mmb_papers/LINVER- The Linear Version of FRB:US.pdf`.
- The first-page/title sniff matched the expected title and authors.
- No source-index mismatch was found for this row. The same source supports sibling model IDs `US_FRB22_mcap`, `US_FRB22_mcapwp`, and `US_FRB22_var`, so variant-specific claims need care.

## Formula Quality

- Formula quality is `needs_review`.
- The source paper is an overview of LINVER construction, expectations cases, stochastic simulations, ELB solution routines, and fiscal-stabilization options. It does not list the complete FRB/US/LINVER equation system.
- Source-stated formulas retained in the English and Chinese derivations:
  - generic inertial federal-funds-rate rule;
  - ECFS fiscal process, `FISCAL_t = 0.97 FISCAL_{t-1} + epsilon_t`;
  - linearization/baseline conventions.
- All detailed equation templates and variable groups learned from the MMB `.mod` are marked `implementation_cross_check`.

## Implementation Cross-Check

- No skill-example file exists at `.agents/skills/dynare-copilot/references/examples/US_FRB22_mceall_rep.mod`.
- Cross-check files used:
  - `raw/mmb/mmci-cli/models/US_FRB22_mceall/US_FRB22_mceall.mod`
  - `raw/mmb/mmci-cli/models/US_FRB22_mceall/US_FRB22_mceall.json`
- The `.mod` identifies the model variant as one in which all expectations are model consistent.
- The `.mod` exposes Modelbase variables `interest`, `inflation`, `inflationq`, `outputgap`, `output`, and `fispol`.
- The `.mod` includes a high-dimensional policy rule with lagged, contemporaneous, and forward-looking inflation/output terms and a monetary-policy shock.
- The `.mod` includes fiscal stabilization equations for `fiscal` and `fiscalav`.
- The implementation appears linear but uses a plain `model;` block, not explicit `model(linear)`. This is marked for review.

## Deferred Issues

- Obtain official LINVER package documentation or equations before attempting a source-level full equation derivation.
- Generate a complete variable/shock/parameter inventory from the implementation in a later audit.
- Verify baseline transformations, offsets, and coefficient provenance against the official LINVER package or MMB build scripts.
- Do not promote this entry to the runnable dynare-copilot model archive until a separate implementation and runtime-validation phase is assigned.
- Dynare was not run.

## Translation Status

- English derivation was drafted first.
- Chinese derivation was created second as a translation of the English core.
- The Chinese file preserves section order, equation numbers `(F1)` through `(F18)`, file paths, model ID, DOI, and status markers.
