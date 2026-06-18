# NK_RW06AL Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row 92 maps `NK_RW06AL` to Ravenna and Walsh (2006), "Optimal monetary policy with the cost channel", DOI `10.1016/j.jmoneco.2005.01.004`.
- Match status is `matched`; MinerU match score and model title match score are both `1.0000`.
- The first Markdown lines show the expected title and authors. No alternate MinerU source was inspected because the primary source was unambiguous.
- Raw PDF exists at `raw/mmb_papers/Optimal monetary policy with the cost channel.pdf`; the PDF body was not opened because the Markdown source had the necessary equations.

## Formula Quality

- Core nonlinear primitives and linear policy equations were extracted from the paper Markdown: household utility, CES demand, cash-in-advance constraint, household FOCs, cost-channel marginal cost, flexible-price output, efficient output, welfare loss, IS curve, Phillips curve, composite demand disturbance, and the discretionary optimality condition.
- MinerU formula OCR is mostly usable, but several surrounding text passages contain malformed accents, stray control characters, and imperfect hat notation. These were normalized only where the mathematical intent was clear from equation labels.
- `needs_review`: the welfare appendix mentioned by the paper was not available as `docs/mmb_appendix_full_normalizations/NK_RW06AL.md`; the second-order welfare derivation should be source-checked before this entry is promoted beyond first-pass status.
- `needs_review`: the MMB adaptive-learning policy-rule block is implementation-specific and not a separate paper-side derivation.

## Implementation Cross-Check

- Used `raw/mmb/mmci-cli/models/NK_RW06AL/NK_RW06AL.mod` only as `implementation_cross_check`.
- The `.mod` confirms `model(linear)`, variables `x`, `pi`, `R`, shock `u`, calibration `sigma=1.5`, `eta=1`, `beta=0.99`, `omega=0.75`, and the compact equations:
  - `x=x(+1)-(1/sigma)*(R-pi(+1))+u;`
  - `pi=beta*pi(+1)+kappa*(sigma+eta)*x+kappa*R;`
- The `.mod` also confirms adaptive-learning metadata and modelbase reporting identities for `interest`, `inflationq`, `pinf4`, `outputgap`, and `output`.
- No Dynare execution was performed.

## Deferred Issues

- Check the paper PDF or the unavailable appendix for the full welfare approximation and optimal-policy derivation before marking `reviewed_derivation`.
- Decide later whether `NK_RW06` and `NK_RW06AL` should share a paper-side derivation with variant-specific implementation appendices, or remain separate archive entries.
- Validate adaptive-learning policy-rule behavior in a future runtime-validation phase if that becomes in scope.

## Translation Status

- English derivation drafted first.
- Chinese derivation translated from the English version with the same eight-section structure and same equation numbering.
- English and Chinese F-number counts should be kept synchronized during review.
