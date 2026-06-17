# US_RS99 Extraction Notes

Status: `needs_review`

## Source Match

- `raw/mmb_mineru/model_index.csv` row for `US_RS99` points to `raw/mmb_mineru/runs/us_rs99__policy_rules_for_inflation_targeting__d61abd68/full.md`.
- The first page/first 80 Markdown lines show the expected title, "Policy Rules for Inflation Targeting", and authors Glenn D. Rudebusch and Lars E.O. Svensson.
- The raw PDF exists at `raw/mmb_papers/Policy rules for inflation targeting   .pdf`.
- No local appendix normalization exists at `docs/mmb_appendix_full_normalizations/US_RS99.md`.

## Formula Quality

- Core paper equations (2.1) and (2.2), the quadratic loss, the state-space representation, and the simple policy-rule families are readable in the OCR Markdown.
- OCR has visible mojibake and symbol damage in prose and some variable glyphs, especially around inflation notation. The formula extraction is therefore first-pass only.
- The raw PDF body was not opened because the Markdown was sufficient for a first-pass model equation inventory. Equation-level PDF review remains deferred.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/US_RS99_rep.mod` exists and was read only as `implementation_cross_check`.
- Cross-check findings:
  - Endogenous variables: `pi`, `y`, `i`, `pibar`, `ibar`.
  - Exogenous shocks: `eps`, `eta`.
  - Model form: `model(linear)`.
  - Parameter values match the estimated coefficients reported in the source.
  - The MMB implementation selects `i = 2.34*pibar + 1.03*y + 0.30*i(-1)`, matching the source table entry for the smoothing rule `S(pibar_t,y_t)`.
- No `.mod` equation was treated as a paper-side mathematical source.

## Deferred Issues

- Status remains `needs_review` until the source PDF is checked against equations (2.1), (2.2), the policy-rule table entry, and the shock standard errors.
- The source row lists "Svennson" in one metadata field; the first-page source and common citation spell the name "Svensson".
- The paper allows a covariance between inflation and output shocks in its general setup, but the MMB implementation specifies only separate variances. This was recorded as an implementation-specific simplification.
- Dynare/runtime validation was not performed by request.

## Translation Status

- English derivation was drafted first.
- Chinese derivation was translated second from the English file.
- Equation numbering `(F1)` through `(F7)` and file paths/model IDs/status markers were preserved.
