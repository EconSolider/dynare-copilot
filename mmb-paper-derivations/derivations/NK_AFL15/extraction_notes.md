# NK_AFL15 extraction notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row for `NK_AFL15` has `mineru_match_status=matched`, `mineru_match_score=1.0000`, `model_title_match_score=1.0000`, and no match notes.
- Primary source: `raw/mmb_mineru/runs/nk_afl15__monetary_policy_and_risk_taking__00cda0fc/full.md`.
- Raw PDF path exists: `raw/mmb_papers/Monetary policy and risk taking.pdf`.
- No model-specific appendix normalization file exists at `docs/mmb_appendix_full_normalizations/NK_AFL15.md`.

## Formula Quality

- First-pass status is `needs_review`.
- Section 5 equations are mostly readable from MinerU Markdown.
- OCR noise remains in several places:
  - Eq. (26) prints one capital-adjustment term as `\phi(\cdot)` although the surrounding notation uses `\chi(\cdot)`.
  - The resource-cost integral after Eq. (28) has noisy superscripts around $R_t^A$.
  - Appendix A's definition of the conditional loss term $g_t$ is noisy and was not promoted to a numbered core equation.
  - The household preference text has OCR artifacts around the labor term, so the derivation records the implied calibration form and marks the exact normalization for review.

## Implementation Cross-Check

- Read `.agents/skills/dynare-copilot/references/examples/NK_AFL15_rep.mod` only as implementation cross-check.
- Cross-check confirms the core MMB variables: `c`, `pai`, `rn`, `k`, `z`, `y`, `mc`, `n`, `q`, `inv`, `rok`, `a`, `g`, `uc`, `un`, `Fk`, `Fn`, `bk`, `d`, `deprat`, `ra`, `br`, `fai`, `rd`, `crun`, `cpai`, `rsh`.
- The implementation uses production capital as `k(-1)` and current accumulation as `k`, which is consistent with the paper's $K_{t+1}$ chosen at time $t$ convention after an index shift.
- Implementation-only differences were not treated as paper-side source facts: `vR`, `vQ`, gross-rate normalization, and calibration values such as `BETTA=0.995` and `ALFA=1/3`.

## Deferred Issues

- Confirm exact steady-state treatment of the risky deposit loss wedge $1-\phi_t g_t$ versus the implementation's `rd`.
- Confirm exact timing of bank capital accumulation and loan stocks between Eq. (17) and the MMB implementation's `bk(+1)` equation.
- Confirm whether the Taylor rule in the source should be represented as the displayed no-smoothing rule only, or whether implementation variants should be separately documented later.
- Confirm resource-cost term $\Omega_t$ against the PDF if a later source-level formula audit is required.
- Runtime validation, Dynare residual checks, BK checks, and IRF checks were not performed.

## Translation Status

- English derivation drafted first.
- Chinese derivation translated from the English version with the same eight sections and the same `(F1)` through `(F24)` equation numbers.
