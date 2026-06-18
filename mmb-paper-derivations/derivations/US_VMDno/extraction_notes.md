# US_VMDno Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row for `US_VMDno` reports a matched primary source with `model_title_match_score=1.0000`.
- The first 80 Markdown lines of the primary `full.md` show the expected title, authors, and abstract for Verona, Martins, and Drumond.
- The source row lists an alternate MinerU run id, but no source mismatch was detected in the primary source sniff, so the alternate was not inspected further.
- Raw PDF path exists and was recorded for provenance. The PDF body was not read.
- `docs/mmb_appendix_full_normalizations/US_VMDno.md` does not exist.

## Formula Quality

- Status: `needs_review`.
- The article directly exposes the shadow-banking block and normal/optimistic spread equations, but states that the rest of the CMR-FA model is set out in Verona, Martins, and Drumond (2012), Appendix A.
- That appendix is not included in the current MinerU Markdown, so the standard household, sticky price/wage, riskier entrepreneur, and full steady-state system remain incomplete from paper-side sources.
- MinerU OCR shows visible math artifacts around superscripts, bars, and equation text. Equations copied into the derivation were normalized conservatively, but should be checked against the PDF or original appendix before promotion.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/US_VMDno_rep.mod` exists and was read only as `implementation_cross_check`.
- It confirms the `US_VMDno` normal-times switch: implementation sets the optimism sensitivity parameter corresponding to paper $`\alpha_2`$ to zero, while retaining the normal-times output-gap sensitivity.
- It also confirms a large nonlinear sticky-price block and a duplicated flexible-price block. The derivation records the main sticky-price block only at a high level and flags implementation-derived standard equations as `needs_review`.
- The implementation exposes one exogenous policy shock, `e_xpU`.

## Deferred Issues

- Check all shadow-banking equations against the raw PDF or a cleaner source because the OCR around equations (1)-(11) is imperfect.
- Locate Verona, Martins, and Drumond (2012), Appendix A or a normalized appendix source before attempting a reviewed full derivation.
- Review the mapping between paper notation for HR/LR entrepreneurs and MMB implementation names `S`/`B`; the `.mod` appears to use `kbarBU`/`nBU` for the safer bond-finance block and `kbarSU`/`nSU` for the retail-bank/financial-accelerator block.
- Complete the steady-state solution from the source-side appendix or the MMB steady-state data file before marking anything beyond first-pass.
- Runtime validation was not performed.

## Translation Status

- English derivation was drafted first.
- Chinese derivation is a translation of the English artifact and preserves the same eight section headings and `(F#)` numbering.
