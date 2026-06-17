# NK_MCN99cr Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row 83 maps `NK_MCN99cr` to "Performance of Operational Policy Rules in an Estimated Semiclassical Structural Model" with `mineru_match_score=1.0000` and `model_title_match_score=1.0000`.
- The first Markdown page identifies the NBER working paper title, Bennett T. McCallum and Edward Nelson as authors, and NBER Working Paper 6599.
- The raw PDF path exists and was recorded for provenance. The PDF body was not opened because the Markdown contained the main formula sequence needed for a first-pass draft.
- No appendix normalization file exists at `docs/mmb_appendix_full_normalizations/NK_MCN99cr.md`.

## Formula Quality

- The central equations in Sections 3-5 of the MinerU Markdown are readable enough for a first-pass extraction: household utility and budget constraints, FOCs, log-linear IS and LM equations, Calvo-Rotemberg price adjustment, output-gap measurement, and estimated shock processes.
- Some OCR spacing is noisy in numeric estimates and equation tags, but the mathematical content is legible. First-pass status remains `needs_review` until PDF-level formula proofreading confirms the exact coefficients and signs.
- The paper presents two aggregate-supply variants. The derivation focuses on the Calvo-Rotemberg variant because the Rep-MMB `.mod` cross-check implements `pi = bet*pi(+1) + thetac1*ytilde`; the P-bar variant is recorded as excluded from this model-specific implementation.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/NK_MCN99cr_rep.mod` declares endogenous variables `pi p y R v m i eta ytilde ybar`, exogenous shocks `u_ e_ ey_ ev_`, and parameters matching the source estimates and policy-rule coefficients.
- The `.mod` file uses `model(linear)` and an active Taylor-type rule `R = mu1*pi + mu2*ytilde + mu3*R(-1)`.
- The active implementation calibration is `sigm=.203`, `CssYss=.81`, `IssYss=.19`, `Rss=.014`, `rhov=.3233`, `rhoeta=.9346`, `bet=.99`, `thetac1=.3`, `mu1=1.5`, `mu2=0`, and `mu3=0`.
- The `.mod` file was not run and was not treated as a source for paper equations.

## Deferred Issues

- Confirm from PDF pages that equation (F6) should be represented with the exact expectation timing used in the archive: the source text has the paper equation with $E_t y_{t+1}$ and later simulation discussion mentions replacing it with $E_{t-1}y_{t+1}$.
- Confirm the paper-to-implementation mapping for the `cr` suffix. The current inference is that `cr` corresponds to the Calvo-Rotemberg aggregate-supply variant, based on the `.mod` implementation.
- Check whether catalog merge should use paper year 1999 from the MMB row or 1998 from the NBER working-paper cover page. The worker report proposes 1999 to match `model_index.csv`.
- Runtime validation is explicitly deferred: no Dynare `resid`, `steady`, `check`, or `stoch_simul` was run.

## Translation Status

- English derivation drafted first.
- Chinese derivation translated from the English version with section order and equation numbering preserved.
- English and Chinese F-number counts should match during validation.
