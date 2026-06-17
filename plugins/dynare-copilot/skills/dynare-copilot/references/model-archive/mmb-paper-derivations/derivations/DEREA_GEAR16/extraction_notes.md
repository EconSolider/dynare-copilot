# DEREA_GEAR16 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row has `mineru_match_status=matched`, `mineru_match_score=1.0000`, and `model_title_match_score=1.0000`.
- The first Markdown lines identify the expected title, "Fiscal policy during the crisis: A look on Germany and the Euro area with GEAR", and authors Niklas Gadatsch, Klemens Hauzenberger, and Nikolai Stahler/Hauzenberger/Stahler spelling as OCR-rendered.
- Raw PDF path exists: `raw/mmb_papers/Fiscal policy during the crisis- A look on Germany and the Euro area with GEAR.pdf`.
- PDF body was not read. No targeted PDF checks were performed.
- No appendix normalization file exists at `docs/mmb_appendix_full_normalizations/DEREA_GEAR16.md`.

## Formula Quality

- Status: `needs_review`.
- The main article prints a model overview and many core equations, but it explicitly says that most derivations and first-order conditions are in a detailed equation summary available upon request.
- The source also says the complete analytical steady-state derivation is available upon request.
- Visible source equations are enough for a structured first-pass archive entry, but not enough for reviewed equation-level coverage.
- OCR issues remain in:
  - the production function around the public-input multiplier;
  - the marginal-cost denominator;
  - the optimizer budget constraint;
  - the Rotemberg price-adjustment indexing;
  - the real-exchange-rate identities;
  - the risk-premium steady-state denominator.

## Implementation Cross-Check

- Read `.agents/skills/dynare-copilot/references/examples/DEREA_GEAR16_rep.mod`.
- Used only as `implementation_cross_check`, not as a paper-side source.
- Cross-check confirms:
  - large country-`a`/country-`b` symmetric blocks;
  - nonlinear model form;
  - private capital in production enters with lagged timing;
  - end-of-period government debt and public capital;
  - RoT and optimizing household split;
  - fiscal instruments for public consumption, public investment, transfers, lump-sum taxes, labor taxes, social contributions, consumption taxes, capital taxes, public employment, and public wages;
  - a common Euro-area policy rule plus country rates;
  - a rest-of-world VAR block.
- Equations marked `implementation_cross_check needs_review` in the English derivation should not be promoted to reviewed source formulas until the equation summary or targeted PDF checks support them.

## Deferred Issues

- Obtain the detailed equation summary and complete steady-state derivation if available.
- Review OCR formulas against the PDF only in targeted locations if the equation summary is unavailable.
- Extract calibration and steady-state target values from table images or a cleaner source before promoting the entry.
- Check exact wage-setting FOC and price Phillips/Rotemberg FOC against a source-side equation summary.
- Do not run Dynare during this first-pass archive extraction; runtime validation remains deferred.

## Translation Status

- English derivation drafted first.
- Chinese derivation is a translation of the checked English draft.
- Equation labels and LaTeX formulas are intended to be preserved exactly across English and Chinese versions.
