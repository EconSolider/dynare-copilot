# RBC_DTT11 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row for `RBC_DTT11` is matched with `mineru_match_score=1.0000` and `model_title_match_score=1.0000`.
- Primary Markdown title sniff: `Monetary Policy and the Financing of Firms`.
- Raw PDF exists at `raw/mmb_papers/Monetary policy and the financing of firms.pdf`.
- No appendix normalization file exists at `docs/mmb_appendix_full_normalizations/RBC_DTT11.md`.

## Formula Quality

- Main paper equations for households, production, contract conditions, entrepreneur funds accumulation, market clearing, and Appendix B equilibrium conditions were readable in the MinerU Markdown.
- The formula extraction is marked `needs_review` because the implementability condition combining the contract and wedge has OCR-sensitive grouping. In particular, the multiplier involving `f(\bar{\omega}_t)` and the fraction with `\mu_t\bar{\omega}_t\phi(\bar{\omega}_t)` should be checked against the PDF before mechanical use.
- The steady-state implementability denominator has the same grouping concern.
- The raw PDF body was not read because the Markdown was sufficient for a first-pass derivation; a targeted PDF formula check is deferred.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/RBC_DTT11_rep.mod` exists and was read only as `implementation_cross_check`.
- The implementation is labeled as a replication of simple Taylor-rule outcomes with constant government spending share and no entrepreneurial consumption.
- The `.mod` notes that `fo_t`, `CapG_t`, `co_t`, `ho_t`, `dumnum_t`, `dumden_t`, `Util`, and `Welf` are linearized while other variables are log-linearized.
- Endogenous variable and shock coverage from the `.mod` was used to fill the reference table and exogenous-process section.
- Dynare was not run.

## Deferred Issues

- Check Appendix B equations (51), (52), and the combined condition (30)/(37) against the raw PDF for exact grouping.
- Decide whether the policy-shock persistence in the implementation should be documented as `rho_pol` or as the implementation's `rho_a` reuse.
- Confirm whether `mu=0.12` in the Rep-MMB implementation intentionally differs from the paper text calibration statement around monitoring costs.
- Confirm whether the archive should keep the paper-side entrepreneur-consumption condition (23) only as provenance for the MMB no-entrepreneur-consumption variant.
- Runtime validation, steady-state solve verification, BK checks, and IRF replication are deferred by task instruction.

## Translation Status

- English derivation drafted first.
- Chinese derivation translated from the English derivation.
- Equation numbers `(F1)` through `(F26)` are preserved in both versions.
