# US_FM95 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` line 125 lists `US_FM95` as Fuhrer and Moore (1995), "Inflation persistence."
- The row's `primary_full_md_path`, `raw/mmb_mineru/runs/us_fm95_us_fm95al__inflation_persistence__c66e898c/full.md`, begins with the expected title and authors.
- The row's `raw_pdf_path`, `raw/mmb_papers/Inflation persistence.pdf`, exists. Per instructions, the PDF body was not read.
- No appendix normalization file exists at `docs/mmb_appendix_full_normalizations/US_FM95.md`.

## Formula Quality

- Status: `needs_review`.
- Main QJE equations for the two-period illustration, four-quarter empirical contracting model, nested standard/relative model, two-sided Phillips-curve representation, policy experiment rule, and Appendix A solution form are readable in MinerU Markdown.
- The archive focuses on the relative-contracting version because the Rep-MMB `US_FM95` implementation uses the real-contract/relative-contract block.
- Equation (F20), the compact output-gap equation, is marked as implementation-supported rather than cleanly paper-side: the QJE paper says reduced-form equations for the bill rate and output gap are combined with the contracting equations, but the exact compact coefficient form is taken from implementation cross-check.
- No missing formulas were silently invented.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/US_FM95_rep.mod` exists and was read only as `implementation_cross_check`.
- The `.mod` confirms endogenous names `p`, `x`, `ytilde`, `ypsilon`, `f`, `infl`, and `rho`; shocks `epsilon_p`, `epsilon_y`, and `interest_`; parameters `s`, `f0`-`f3`, `D`, `a0`, `a1`, `a2`, `arho`, and `gamma`; and `model(linear)`.
- The `.mod` includes an LWW-style interest-rate rule and parameterization attributed to later Fuhrer/LWW sources, while the QJE paper uses a nominal-output-growth reaction function for policy experiments. The archive records both but treats the QJE rule as paper-side and the LWW rule as implementation-side.
- The `.mod` was not run.

## Deferred Issues

- Targeted source review should reconcile the Rep-MMB LWW interest-rate rule with the QJE nominal-output-growth policy experiment before marking this entry as reviewed.
- Targeted source review should confirm whether the output-gap/term-structure block in the `.mod` comes from Fuhrer and Moore (1995 AER), Fuhrer (1997), or LWW implementation documentation.
- The covariance matrix and exact reduced-form VAR equations from the QJE estimation are not reconstructed in this first pass.
- Dynare runtime validation was not performed.

## Translation Status

- English derivation drafted first.
- Chinese derivation translated from the English draft.
- Equation numbers `(F1)` through `(F24)` are preserved in both files.
