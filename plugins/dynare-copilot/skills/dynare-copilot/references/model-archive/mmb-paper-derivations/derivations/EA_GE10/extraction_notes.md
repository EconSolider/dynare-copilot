# EA_GE10 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` maps `EA_GE10` to Gelain (2010), "The external finance premium in the euro area: A dynamic stochastic general equilibrium analysis".
- The first 80 lines of `raw/mmb_mineru/runs/ea_ge10__the_external_finance_premium_in_the_euro_area_a_dynamic_stochastic_gener__718b56bc/full.md` show the expected title and author, Paolo Gelain.
- The raw PDF exists at `raw/mmb_papers/The external finance premium in the euro area- A dynamic stochastic general equilibrium analysis.pdf`; the PDF body was not read.
- No appendix normalization file exists at `docs/mmb_appendix_full_normalizations/EA_GE10.md`.

## Formula Quality

- Status: `needs_review`.
- The main model equations are readable in Markdown, especially Sections 2.1-2.5 and Appendix A.
- OCR artifacts remain in some symbols: the real-rate definition, `theta`/markup notation, investment variable glyphs, `r e^k`, and Appendix A's wage/steady-state notation.
- Equations were normalized into a consistent log-linear notation. They should be checked against the PDF in a later review pass before promotion.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/EA_GE10_rep.mod` was read only as `implementation_cross_check`.
- The `.mod` confirms the Rep-MMB variable set: `r c l inv q k nw rk y pi z mc a x eb el S g rn wp EMP ypot cf invf qf rkf rf kf wpf lf zf mcf`.
- The `.mod` confirms exogenous shocks: `ux ub ul ua ur ug ulambdapi uw`.
- The `.mod` implements sticky-price/sticky-wage equations and a flexible-price counterpart for `ypot`.
- The `.mod` shifts the paper's `nw_{t+1}` relationship into current-period implementation timing using lags. This is recorded in the timing section but not used as paper-side mathematical evidence.

## Deferred Issues

- `needs_review`: verify every normalized equation against the PDF or another source-level reference, especially (F2), (F9), (F12), (F15), and the Appendix A steady-state expressions.
- `needs_review`: determine whether the employment block `EMP` has a paper-side equation outside the extracted model summary or is an implementation-specific addition.
- `needs_review`: confirm whether the policy-rule inflation term should use current or lagged inflation in the archive equation; the paper Markdown and implementation both emphasize lagged inflation/output-gap terms, but OCR around notation is noisy.
- Runtime validation was not performed.

## Translation Status

- English derivation drafted first.
- Chinese derivation is a translation of the English core and preserves equation numbers, file paths, DOI, and `needs_review` markers.
