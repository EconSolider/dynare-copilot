# BRA_SAMBA08 Extraction Notes

## Source Match

- Model index row: `BRA_SAMBA08`.
- Primary Markdown: `raw/mmb_mineru/runs/bra_samba08__samba_stochastic_analytical_model_with_a_bayesian_approach__8681ba38/full.md`.
- Raw PDF path checked and exists: `raw/mmb_papers/Stochastic analytical model with a bayesian approach 2011.pdf`.
- Appendix normalization: none found at `docs/mmb_appendix_full_normalizations/BRA_SAMBA08.md`.
- Implementation cross-check found: `.agents/skills/dynare-copilot/references/examples/BRA_SAMBA08_rep.mod`.
- Source-review issue: the model index row is labeled 2008, but the primary source title is the 2011 Banco Central do Brasil working paper. The row also contains `primary source title differs from model title; review variant mapping`.

## Formula Quality

- The English derivation uses the paper's Appendix C log-linear system as the operational model, because the MMB implementation is `model(linear)`.
- The nonlinear household, firm, policy, market-clearing, BGP, and steady-state equations were used for structure and provenance.
- Several MinerU OCR equations contain malformed fragments, especially around Appendix A price-setting equations `(A.21)` and `(A.31)` and adjustment-cost derivative terms. These are marked `needs_review` rather than silently normalized.
- The PDF body was not read. The raw PDF path was only checked for existence, per instruction.

## Implementation Cross-Check

- The example file declares `model(linear)`.
- MMB variables cross-checked include `co`, `crot`, `c`, `n`, `q`, `wr`, `k`, `fii`, `qi`, `i`, `x`, `m`, `rk`, `mc`, `pi`, `bystar`, `nxy`, `r`, `gy`, `syhat`, `bby`, `g`, `y`, `yva`, `piva`, `pibar`, `sgbar`, and foreign/shock states.
- The `.mod` collapses the richer paper-side sectoral pricing system into a compact 39-endogenous-variable linear representation. I did not use the `.mod` as a mathematical source; it was used only to check coverage and naming.

## Deferred Issues

- Human review should confirm whether the 2011 working paper is the intended source for the 2008 MMB model row.
- Exact nonlinear formulas in Appendix A should be checked against the PDF before any promotion to a reviewed or runnable model archive.
- The wage Phillips curve and sectoral price-setting system are fuller in the paper than in the compact MMB implementation; future work should decide whether archive promotion tracks the paper's full system or the MMB reduction.
- Runtime validation, Dynare residual checks, steady-state code, BK checks, and IRF comparison were not performed.

## Translation Status

- English derivation was drafted first.
- Chinese derivation was translated from the English derivation.
- Equation numbering parity was validated: both files contain `(F1)` through `(F50)`.
