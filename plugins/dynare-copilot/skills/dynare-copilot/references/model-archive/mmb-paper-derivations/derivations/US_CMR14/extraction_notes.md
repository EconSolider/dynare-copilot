# US_CMR14 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` selects `raw/mmb_mineru/runs/us_cmr14_us_cmr14nofa__risk_shocks__d33971b2/full.md`.
- The selected row has `mineru_match_score=1.0000`, `model_title_match_score=1.0000`, and no `model_match_notes`.
- First Markdown lines match the expected title "Risk Shocks" and authors Lawrence J. Christiano, Roberto Motto, and Massimo Rostagno.
- Raw PDF exists at `raw/mmb_papers/Risk shocks.pdf`.
- No appendix normalization file exists at `docs/mmb_appendix_full_normalizations/US_CMR14.md`.

## Extraction Scope

- English derivation was drafted first using the eight required sections.
- Chinese derivation is a translation of the English draft and preserves every `(F#)` marker.
- The entry targets the paper's baseline risk-shock model with BGG financial frictions and risk-news signals.
- The `.mod` file `.agents/skills/dynare-copilot/references/examples/US_CMR14_rep.mod` was read only as `implementation_cross_check`.
- Shared `catalog.csv` and `status.csv` were not edited, per user instruction.

## Formula Quality

- Overall formula status: `needs_review`.
- The article body gives the main model blocks: final-good aggregator, production technology, Calvo price and wage indexation, household preferences and budget, raw-capital accumulation, BGG financial contract, monetary policy rule, resource constraint, adjustment costs, and news-shock process.
- The article explicitly says a detailed list of equations is in the online Appendix and code. That detailed paper-side appendix is not present as a normalized local source for `US_CMR14`.
- Stationary-scaled FOCs for price/wage auxiliaries, marginal cost, investment, and bond Euler equations were cross-checked against `.agents/skills/dynare-copilot/references/examples/US_CMR14_rep.mod`; these are marked `needs_review` because `.mod` is not paper-side authority.
- The household budget equation in the Markdown has visible OCR damage around long-bond notation and tax symbols.
- The resource constraint and monitoring-cost expression are source-backed but have possible scaling/price-normalization ambiguity in OCR.
- No PDF body was opened because the Markdown supplied enough structure for a first-pass `needs_review` draft and the task contract says not to read the PDF body by default.

## Implementation Cross-Check

- The implementation names active endogenous variables including `c`, `g`, `h`, `i`, `kbar`, `lambdaf`, `lambdaz`, `muup`, `muzstar`, `n`, `omegabar`, `phi`, `pi`, `pitarget`, `pstar`, `q`, `Re`, `rL`, `rk`, `Rk`, `RL`, `s`, `sigma`, `u`, `wtilde`, `wstar`, `zetac`, `zetai`, and risk-news signal variables `xi0` through `xi8`.
- It includes shocks for monetary policy, price markup, inflation target, investment-specific price, government demand, persistent growth, equity transfer, transitory technology, risk, consumption preference, marginal efficiency of investment, term premium, and risk news.
- The implementation confirms the MMB variant keeps the financial accelerator and risk-news block and uses lagged capital in production.
- Dynare was not run.

## Deferred Issues

- Full source-level formula review against the online technical appendix or PDF is required before promoting this entry beyond `needs_review`.
- The exact stationary scaling of several conditions should be checked, especially price/wage auxiliary recursions, marginal cost, investment FOC, resource constraint, and monitoring cost.
- The steady-state section records source-backed targets and implementation cross-check values, but it does not reconstruct the full numerical steady-state algorithm.
- The active equation count should be reviewed when a runnable `.mod` is built.
- Runtime validation, residual checks, Blanchard-Kahn checks, and IRF checks were not performed.

## Translation Status

- Chinese translation completed after the English draft.
- English and Chinese `(F#)` counts match in validation.
