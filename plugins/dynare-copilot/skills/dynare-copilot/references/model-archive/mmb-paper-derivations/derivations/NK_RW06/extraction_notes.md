# NK_RW06 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row for `NK_RW06` maps to Ravenna and Walsh (2006), "Optimal monetary policy with the cost channel."
- First-page Markdown sniff matches the expected title and authors.
- Raw PDF exists at `raw/mmb_papers/Optimal monetary policy with the cost channel.pdf`.
- No `docs/mmb_appendix_full_normalizations/NK_RW06.md` file exists.

## Formula Quality

- Formula extraction is a first-pass MinerU Markdown extraction and remains `needs_review`.
- Core paper-side equations used: household conditions, cost-channel real marginal cost, flexible-price output, welfare gap, IS curve, Phillips curve, composite demand shock, and discretionary-policy FOC.
- OCR artifacts were visible in prose and some symbols, but the central equations used in the derivation were legible enough for a draft archive entry.
- The second-order welfare approximation cites an appendix that is not locally normalized; this is the main deferred source issue.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/NK_RW06_rep.mod` exists and was read only as `implementation_cross_check`.
- The MMB implementation is `model(linear)` with endogenous variables `x`, `pi`, and `R`; exogenous variable `u`; and parameters `sigma`, `eta`, `beta`, `omega`, `kappa`, `phipi`, and `phix`.
- The implementation equations correspond to the reduced IS curve, cost-channel Phillips curve, and simple policy rule:
  - `x=x(+1)-(1/sigma)*(R-pi(+1))+u`
  - `pi=beta*pi(+1)+kappa*(sigma+eta)*x+kappa*R`
  - `R = phipi*pi+phix*x`
- Dynare was not run.

## Deferred Issues

- `needs_review`: verify the welfare-loss derivation against the unavailable author appendix or another source if the archive later requires reviewed status.
- `needs_review`: confirm whether the archive should represent the optimal-policy commitment/discretion system, the MMB simple-rule simulation system, or both as separate variants.
- `needs_review`: formulas involving the fiscal share `gamma_t` and demand shock `u_t` should be source-level checked against the PDF before promotion beyond draft.

## Translation Status

- English derivation was drafted first.
- Chinese derivation was translated from the English version and preserves the same `(F#)` numbering and eight-section structure.
