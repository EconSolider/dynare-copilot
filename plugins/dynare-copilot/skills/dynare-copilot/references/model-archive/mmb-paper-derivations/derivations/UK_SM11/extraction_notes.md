# UK_SM11 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row `UK_SM11` is matched with score `1.0000`.
- Primary source title is "An estimated DSGE model of energy, costs and inflation in the United Kingdom", matching the first-page Markdown title and Stephen Millard author line.
- Raw PDF exists at `raw/mmb_papers/An estimated DSGE model of energy, costs and inflation in the United Kingdom.pdf`.
- No `docs/mmb_appendix_full_normalizations/UK_SM11.md` file exists in the current checkout.
- Alternate MinerU run id listed in the index: `7c46224e-727a-48ed-950c-97f2f1810d7d`; the primary selected run was used.

## Formula Quality

- Status: `needs_review`.
- The Markdown source is usable for a first-pass log-linear extraction, but several OCR artifacts are visible, including malformed prose around "eats up", missing/malformed symbols near depreciation and indexation descriptions, and noisy symbols in foreign-shock descriptions.
- Equations (1)-(55) in the paper were mapped to archive numbers (F1)-(F55), except the government budget expression is recorded without an F-number because it is a fiscal closure relation and the log-linear domestic-demand disturbance enters the non-energy market-clearing equation.
- Foreign-shock estimates (paper equations (56)-(60)) are recorded in prose under Section 5 rather than assigned new F-numbers because they parameterize the generic AR(1) shock laws already listed as (F51)-(F55).

## Implementation Cross-Check

- Cross-check file: `.agents/skills/dynare-copilot/references/examples/UK_SM11_rep.mod`.
- Dynare was not run.
- The implementation confirms `model(linear)`, the 12 exogenous innovations, the core variable names, and the existence of a flexible-price auxiliary block used for gaps.
- Differences from paper notation are implementation-level:
  - `rg` is the policy-rate variable corresponding to the paper's nominal interest-rate deviation.
  - `pdot`, `pcdot`, `ppbdot`, and `pudot` implement non-energy, consumer, petrol, and utilities inflation definitions.
  - The `.mod` includes additional reporting definitions such as annualized inflation, cost contributions, gaps, and shares; these are not treated as paper-side derivation equations.

## Deferred Issues

- Full primitive household, firm, wage-setting, and price-setting optimization problems require the cited Harrison et al. (2011) technical appendix.
- A source-level PDF formula check should verify the OCR-sensitive equations: household capital accumulation, wage Phillips curve, import-price Phillips curve, and foreign price shocks.
- The Taylor-rule output-gap notation should be checked against the PDF because the Markdown reports `\hat{y}_t`, while the `.mod` uses `va-vaf`.
- The paper text says utilities producers can optimally change price with probability `\chi_u`, but the NKPC and implementation use `\chi_u` as the non-reoptimization/stickiness parameter. This convention should be reviewed against the PDF/appendix.
- The exact mapping between `\varepsilon_p`, `\xi_p`, and `\iota_pm` indexation/pass-through notation should be reviewed before any promotion to a runnable archive.

## Translation Status

- English derivation drafted first.
- Chinese derivation created as a formula-preserving translation.
- F-number count is intended to match exactly between English and Chinese.
