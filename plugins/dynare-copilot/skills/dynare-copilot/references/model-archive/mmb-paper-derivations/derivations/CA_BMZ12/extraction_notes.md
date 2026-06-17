# CA_BMZ12 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row for `CA_BMZ12` points to `raw/mmb_mineru/runs/ca_bmz12__macroprudential_rules_and_monetary_policy_when_financial_frictions_matte__aa2f7a66/full.md`.
- First-page/first-80-line sniff matched the expected title and authors: "Macroprudential rules and monetary policy when financial frictions matter"; Jeannine Bailliu, Cesaire Meh, Yahong Zhang.
- `raw_pdf_path` exists at `raw/mmb_papers/Macroprudential rules and monetary policy when financial frictions matter.pdf`. The PDF body was not opened because Markdown was sufficient for a first-pass `needs_review` draft.
- `docs/mmb_appendix_full_normalizations/CA_BMZ12.md` does not exist.
- `.agents/skills/dynare-copilot/references/examples/CA_BMZ12_rep.mod` exists and was used only as `implementation_cross_check`.

## Formula Quality

- Overall formula quality: `needs_review`.
- Household equations, entrepreneur premium equations, capital accumulation, policy rules, macroprudential rule, and shock processes are readable in Markdown.
- Retailer pricing equations contain OCR issues around the stochastic discount factor and optimal reset-price FOC.
- Entrepreneurial net worth equations are readable enough for draft extraction, but the final wage-income term should be checked against the PDF because OCR may have dropped powers or labor-share terms.
- Price-index and price-dispersion text has small notation issues: Markdown renders one integral with `dz` and the price-dispersion definition appears incomplete.

## Implementation Cross-Check

- The Rep-MMB implementation confirms the main endogenous blocks: consumption, hours, capital, investment, net worth, nominal credit, external finance premium, risk premium/macroprudential multiplier, Calvo price block, flexible-price comparison block, and shock processes.
- The implementation uses `kt(-1)` in production and return equations, supporting the timing note that productive capital is predetermined.
- The implementation includes several auxiliary variables and a flexible-price block not fully documented as separate paper-side derivation equations in this first-pass archive entry.
- No equations were copied from the `.mod` file as paper-side source evidence.

## Deferred Issues

- PDF-check Eqs. (18)-(19), (28)-(29), and the price-dispersion definition before upgrading from `needs_review`.
- Decide whether a reviewed archive entry should include the flexible-price block as a separate model subsystem or keep it as an implementation comparison object.
- Reconcile paper annual inflation calibration with the implementation's quarterly `mub = 1.005` convention.
- Confirm whether the DOI/year in `model_index.csv` should be represented as the working-paper year 2012, the article year 2015, or both in shared catalog rows.
- Runtime validation, Dynare equation count, steady-state residuals, BK checks, and IRF checks were not performed.

## Translation Status

- `CA_BMZ12_derivation.zh.md` is a translation of the checked English draft.
- Equation numbers `(F1)` through `(F37)` and LaTeX formulas were preserved.
