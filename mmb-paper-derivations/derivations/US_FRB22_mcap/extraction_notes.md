# US_FRB22_mcap Extraction Notes

Status: `needs_review`

## Source Match

- `raw/mmb_mineru/model_index.csv` row 131 maps `US_FRB22_mcap` to "LINVER: The Linear Version of FRB/US".
- Primary source title in the index is "LINVER- The Linear Version of FRB:US" with `model_title_match_score = 1.0000`.
- First Markdown lines show the expected title, authors, date, and DOI citation.
- Raw PDF exists at `raw/mmb_papers/LINVER- The Linear Version of FRB:US.pdf`.
- No `docs/mmb_appendix_full_normalizations/US_FRB22_mcap.md` file exists.

## Formula Quality

- The paper is primarily a LINVER overview and simulation-method paper, not a full equation appendix.
- Some printed policy-rule formulas in the MinerU Markdown include OCR placeholder characters around ELB expressions.
- The derivation therefore records high-level linearization, expectation, policy-rule, and simulation relationships and marks source-level equation recovery as `needs_review`.
- Full equation-level reconciliation against official LINVER package documentation is deferred.

## Implementation Cross-Check

Implementation files were used only as `implementation_cross_check`:

- `raw/mmb/mmci-cli/models/US_FRB22_mcap/US_FRB22_mcap.mod`
- `raw/mmb/mmci-cli/models/US_FRB22_mcap/US_FRB22_mcap.json`
- `.agents/skills/dynare-copilot/references/examples/US_FRB22_rep.mod`

The local `US_FRB22_mcap.mod` header identifies this as the variant in which financial market expectations are model consistent, while other expectations are based on a small VAR. A non-runtime text count found 309 endogenous `var` tokens, 120 `varexo` tokens, and 274 named model equations.

No Dynare run was performed.

## Deferred Issues

- Source-level full equation extraction requires official LINVER package/manual equations or direct reconciliation of the generated `.mod` with package documentation.
- The paper does not provide primitive optimization problems or FOCs.
- The steady state is a 2018-2019 linearization baseline, not a standard DSGE deterministic steady state; exact baseline values are not reconstructed here.
- Policy-rule formulas with ELB and threshold constraints need targeted checking against the PDF/package because OCR has placeholder characters.
- Variant-specific differences among `US_FRB22_mcap`, `US_FRB22_mcapwp`, `US_FRB22_mceall`, and `US_FRB22_var` should be reconciled against official Modelbase/LINVER documentation before review promotion.

## Translation Status

- English derivation written first.
- Chinese derivation translated second from the English core.
- F-number counts were kept aligned.
