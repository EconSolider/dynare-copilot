# US_AJ16 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row for `US_AJ16` is matched with `mineru_match_score=1.0000` and `model_title_match_score=1.0000`.
- Primary Markdown title sniff matches the expected paper title: "Financial Intermediation, Investment Dynamics, and Business Cycle Fluctuations".
- Raw PDF exists at `raw/mmb_papers/Financial intermediation, investment dynamics, and business cycle fluctuations.pdf`; the PDF body was not read because the Markdown source was sufficient for a first-pass derivation.
- No appendix normalization file exists at `docs/mmb_appendix_full_normalizations/US_AJ16.md`.

## Formula Quality

- Status: `needs_review`.
- The article body contains the main model equations, but several derivations are delegated to online appendices that are not present in this source packet.
- The heterogeneous-agent equity and bond Euler equations are source-backed but OCR-sensitive, especially conditional expectations and payoff weights over seller/keeper/buyer regions.
- The steady-state section is partial because the paper states the model is stationarized and log-linearized but does not provide a complete closed-form steady-state derivation in the extracted article body.
- The intermediation wedge appears as $`Q_t^B=(1+\tau_t^q)Q_t^A`$ in the paper text, while the MMB implementation uses `exp(Q_t_B) = exp(Q_t_A)*exp(tau_q_t)`. This is recorded as a notation/implementation convention requiring review.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/US_AJ16_rep.mod` was read only as `implementation_cross_check`.
- Cross-check confirmed the implemented surface includes:
  - endogenous variables for equity prices `Q_t_A`, `Q_t_B`, investment price `QK`, capital/equity `Kbar`/`N_t`, financing observables `FGS`, `Spread_t`, seller/keeper shares `chi_s`, `chi_k`, `chi_w`, and financial shocks `etau_q_t`, `ctau_q_t`, `tau_q_t`;
  - exogenous shocks `eps_z`, `eps_g`, `eps_i`, `eps_tau`, `eps_tau_trans`, `eps_beta`, `eps_p`, `eps_w`, and measurement errors `eps_meas`, `eps_meas_sp`;
  - log-linear price and wage blocks, investment adjustment cost block, fiscal rule, Taylor rule, financing-gap and spread observation equations.
- No Dynare command was run.

## Deferred Issues

- Source-level check against online appendices is needed before promoting this entry beyond `needs_review`.
- The exact closed-form steady-state recursion for all lognormal integrals should be rebuilt from the paper appendix or original replication package before implementation.
- The wedge notation difference between paper text and MMB `.mod` should be reconciled.
- OCR introduced some malformed symbols in the household Euler equations; the extracted archive equations preserve the core structure but should be checked against PDF/appendix formulas.

## Translation Status

- English derivation drafted first.
- Chinese derivation translated from the English core.
- Equation numbers `(F1)` through `(F62)` are preserved in both versions.
