# US_CFOP14 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row for `US_CFOP14` is matched with score `1.0000`.
- First Markdown page matches the expected paper title, authors, journal, year, and DOI metadata.
- Raw PDF exists at `raw/mmb_papers/Estimating contract indexation in a financial accelerator model.pdf`.
- No `docs/mmb_appendix_full_normalizations/US_CFOP14.md` file exists.
- Source index issue: none detected.

## Formula Quality

- Status: `needs_review`.
- The main source is MinerU OCR Markdown. It captures the core Section 3 and Appendix A equations, but some notation has OCR damage.
- Marked uncertain in the derivation:
  - (F6): consumption/marginal-utility FOC has noisy notation around coefficients and MEI growth terms in equation (A5).
  - (F14): wage Phillips curve has noisy growth-indexation notation and inconsistent OCR rendering of $`v`$ versus $`\nu`$ in equation (A12).
- The appendix equation label for agency-cost replacement appears as malformed `{A8 prime}` in OCR; it is normalized in prose as the agency-cost expected capital-return condition and marked through the source context.
- The paper-side Appendix A presents only a compact subset of equations relative to the Rep-MMB implementation, which includes potential-output `star` counterparts and auxiliary expectation variables.

## Implementation Cross-Check

- Cross-check file: `.agents/skills/dynare-copilot/references/examples/US_CFOP14_rep.mod`.
- Used only for variable coverage, timing conventions, shock names, and confirmation that the MMB implementation is `model(linear)`.
- Not used as a paper-side mathematical source.
- Dynare was not run.
- The `.mod` confirms:
  - endogenous financial variables: `Rk`, `Rl`, `Rd`, `nw`, `spr`, `promz`, `credit`, and their `star` counterparts where present;
  - shocks: `Rs`, `zs`, `gs`, `mius`, `lambdaps`, `lambdaws`, `bs`, `efps`, `upsilons`, `nws`;
  - financial shock states: `lamefp` and `lamnw`;
  - contract-indexation parameters: `cnu`, `ckappa`, `ctheta`, `cchi`, `cb`.

## Deferred Issues

- Formula-level PDF verification was not performed. A future reviewer should compare F6 and F14 directly against the PDF appendix.
- The English derivation does not attempt to enumerate every `star` equation separately; it records their implementation role and the source-side mapping.
- Runtime validation, Blanchard-Kahn checks, residual checks, and IRF reproduction are out of scope for this entry.
- The calibration table in the OCR Markdown contains table parsing artifacts; parameter values in the derivation are therefore limited to values corroborated by the `.mod` cross-check or clean source prose.

## Translation Status

- English derivation was drafted first.
- Chinese derivation was translated from the English version.
- Equation numbering `(F1)` through `(F33)` is preserved in both versions.
- LaTeX formulas are preserved except for surrounding explanatory prose.
