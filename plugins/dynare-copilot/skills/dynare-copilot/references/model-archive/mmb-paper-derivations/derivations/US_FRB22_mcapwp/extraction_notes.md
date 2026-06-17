# Extraction Notes - US_FRB22_mcapwp

Status: `needs_review`

## Source Match

- `raw/mmb_mineru/model_index.csv` row 132 maps `US_FRB22_mcapwp` to "LINVER: The Linear Version of FRB/US".
- Primary source title in the index is "LINVER- The Linear Version of FRB:US" with `model_title_match_score = 1.0000`.
- First Markdown lines show the expected title, authors, date, and DOI citation.
- Raw PDF exists at `raw/mmb_papers/LINVER- The Linear Version of FRB:US.pdf`.
- No `docs/mmb_appendix_full_normalizations/US_FRB22_mcapwp.md` file exists.

## Formula Quality

- The paper is primarily a LINVER overview and simulation-method paper, not a full equation appendix.
- Some printed policy-rule formulas in the MinerU Markdown include OCR placeholder characters around `max{..., ELB}` expressions.
- The derivation therefore records only high-level policy/reduced-form relationships and marks them `needs_review`.
- Full equation-level reconciliation against official LINVER package documentation is deferred.

## Implementation Cross-Check

Implementation files were used only as `implementation_cross_check`:

- `raw/mmb/mmci-cli/models/US_FRB22_mcapwp/US_FRB22_mcapwp.mod`
- `raw/mmb/mmci-cli/models/US_FRB22_mcapwp/US_FRB22_mcapwp.json`
- `.agents/skills/dynare-copilot/references/examples/US_FRB22_rep.mod`

The local `US_FRB22_mcapwp.mod` identifies the variant as model-consistent expectations in financial markets and wage-price setting, with other expectations based on small VAR predictions. It also confirms a large linear implementation with 319 endogenous `var` tokens, 124 `varexo` tokens, and 274 named model equations.

No Dynare run was performed.

## Deferred Issues

- Source-level full equation extraction requires official LINVER package/manual equations or direct reconciliation of the generated `.mod` with the package documentation.
- The paper does not provide primitive optimization problems or FOCs.
- The steady state is a 2018-2019 linearization baseline, not a standard DSGE deterministic steady state; exact baseline values are not reconstructed here.
- Policy-rule formulas with ELB and threshold constraints need targeted checking against the PDF/package because OCR has placeholder characters.

## Translation Status

- English derivation written first.
- Chinese derivation translated second from the English core.
- F-number counts were kept aligned.
