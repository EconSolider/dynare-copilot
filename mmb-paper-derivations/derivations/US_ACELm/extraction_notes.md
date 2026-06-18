# US_ACELm Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row 99 maps `US_ACELm` to Altig, Christiano, Eichenbaum, and Linde (2005), "Firm-Specific Capital, Nominal Rigidities."
- `mineru_match_status` is `matched`; `mineru_match_score` and `model_title_match_score` are both `1.0000`.
- First-page sniff of `full.md` found the expected title and authors.
- Raw PDF exists at `raw/mmb_papers/Firm-specific capital, nominal rigidities.pdf`.
- No appendix normalization file exists at `docs/mmb_appendix_full_normalizations/US_ACELm.md`.

## Formula Quality

- The paper-side Markdown contains the primitive model equations in Section 2 and selected log-linear/steady-state relations in Sections 5 and 6.
- The paper states that the full computational strategy is in a technical appendix available on request. That appendix is not available in the checked source paths.
- Exact coefficient-level Rep-MMB `model(linear)` equations are therefore marked `needs_review` where they go beyond equations visible in the paper-side Markdown.
- OCR quality is generally usable for the main model equations, but some table/math OCR in parameter tables contains spacing artifacts.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/US_ACELm_rep.mod` was read only as `implementation_cross_check`.
- The `.mod` confirms `model(linear)`, sticky-price and flexible-price blocks, money-growth policy, neutral technology, embodied technology, and an added transitory neutral technology shock.
- The `.mod` comments identify technical-appendix equations 1 through 16, but these were not treated as paper-side source equations.
- Dynare was not run.

## Deferred Issues

- Obtain or parse the Altig et al. (2004) technical appendix before promoting exact linear implementation equations from `needs_review`.
- Verify whether the transitory neutral technology shock in the Rep-MMB file is an MMB addition rather than part of the original paper code.
- Source-check the exact mapping from firm-specific capital primitives to the reduced-form \(\gamma\) used in the MMB calibration.
- Review steady-state formulas against the original code package or appendix before marking `draft_extracted`.

## Translation Status

- English derivation drafted first.
- Chinese derivation translated from the English version with equation numbers and formulas preserved.
