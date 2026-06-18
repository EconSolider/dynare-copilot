# US_BR13 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row 106 maps `US_BR13` to Blanchard and Riggi (2013), "Why are the 2000s so different from the 1970s?"
- `primary_full_md_path` exists and its header/title/authors match the index row.
- `raw_pdf_path` exists and is recorded for provenance. The PDF body was not read because the Markdown contained the benchmark model equations needed for this first-pass extraction.
- No `docs/mmb_appendix_full_normalizations/US_BR13.md` file exists.
- No `.agents/skills/dynare-copilot/references/examples/US_BR13_rep.mod` file exists, so no implementation cross-check was available.

## Formula Quality

- Status: `needs_review`.
- The main text states that Section 3 presents only the implied log-linear equations and leaves the full derivation to the Online Appendix. Because no local appendix normalization exists for this model, primitive optimization problems and the welfare-relevant output-gap derivation should be checked later against the online appendix.
- The benchmark Cobb-Douglas equations (paper equations 1-18) were extracted into (F1)-(F18).
- The source OCR has minor artifacts, including broken subscripts and a stray non-English character near the discussion of Figure 2. These did not affect the extracted benchmark equations but should be reviewed if a runnable `.mod` is later produced.
- The Leontief technology and variable desired markup robustness variants are not included in the benchmark equation count. They can become separate variant notes or separate archive entries if needed.

## Implementation Cross-Check

- `.mod` file: not found at `.agents/skills/dynare-copilot/references/examples/US_BR13_rep.mod`.
- Cross-check status: not performed.
- Dynare runtime validation: not performed, per user instruction.

## Deferred Issues

- Confirm the Online Appendix equations for the household problem, budget constraint, firm problem, and the welfare-relevant output gap \(\hat x^f_t\).
- Resolve the sample endpoint discrepancy: the VAR discussion says the post-1984 sample is 1984:Q1-2007:Q4, while the structural estimation paragraph says 1984:Q1-2007:Q3.
- Decide whether robustness variants should be represented as separate variant derivations or only as notes under `US_BR13`.
- If implementing in Dynare later, choose a clear state/control set because several equations are identities used to map theoretical variables to observed IRFs rather than a minimal model block.

## Translation Status

- English derivation drafted first.
- Chinese derivation translated from the English derivation with matching (F1)-(F18) numbering and preserved paths/status markers.
