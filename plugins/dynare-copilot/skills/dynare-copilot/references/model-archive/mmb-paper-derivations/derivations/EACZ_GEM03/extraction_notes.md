# EACZ_GEM03 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row for `EACZ_GEM03` has `mineru_match_status=matched`, `mineru_match_score=1.0000`, `model_title_match_score=1.0000`, and a single MinerU run id `7512f0ea-fa74-4a87-a6a7-25f1c080f429`.
- First-page Markdown sniff showed the expected Laxton/Pesenti title/authors and abstract. The Markdown title has plural "rules" while the model-index title has singular "rule"; this appears to be a local metadata normalization issue, not a source mismatch.
- Raw PDF exists at `raw/mmb_papers/Monetary rule for small, open, emerging economies.pdf`. The PDF body was not read.
- No appendix normalization file exists at `docs/mmb_appendix_full_normalizations/EACZ_GEM03.md`.

## Formula Quality

- Status: `needs_review`.
- The MinerU Markdown contains the main paper-side structural equations in Section 2, but OCR damage appears in the nested final-good CES technology and in several notation-heavy policy and asset-market equations.
- The paper states several FOC outcomes in prose rather than printing full implementable equilibrium conditions, especially for money demand, capital FOCs, wage-setting FOCs, and full Rotemberg pricing FOCs.
- The English derivation therefore records a compact structural map rather than a complete one-equation-per-Dynare-line implementation.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/EACZ_GEM03_rep.mod` exists and was read only as `implementation_cross_check`.
- Cross-check evidence used:
  - Home variables use suffix `H`; Foreign variables use suffix `F`.
  - The MMB file is a nonlinear `model` block, not `model(linear)`.
  - The Home policy rule uses optimized Table 4 row-2-style parameters in the implementation comments.
  - The implementation includes large Home/Foreign shock and calibration blocks consistent with the paper's GEM structure.
  - Capital timing in code uses predetermined capital, e.g. `K = K(-1)*(1-delta)+PSI(-1)*K(-1)`.
- Cross-check evidence not used as paper-side source:
  - Full equation list in the `.mod`.
  - Numeric `initval` entries.
  - Implementation-specific reporting variables.

## Deferred Issues

- Verify the nested final-good CES formula against PDF or publisher source.
- Verify the stochastic discount factor Eq. (34), especially the discount exponent and shopping-cost timing.
- Reconstruct or verify full Rotemberg price- and wage-setting FOCs before promoting beyond `needs_review`.
- Decide whether a future archive revision should expand the compact structural map into the full Rep-MMB equation inventory.
- Confirm whether the archive should use the model-index title singular "Monetary rule..." or the observed paper title plural "Monetary rules...".
- Runtime validation was intentionally not performed.

## Translation Status

- `EACZ_GEM03_derivation.zh.md` was created as a translation of the checked English draft.
- Equation labels and LaTeX formulas were preserved.
- English and Chinese F-number counts should match before merging.
