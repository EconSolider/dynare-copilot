# GPM6_IMF13 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row `GPM6_IMF13` points to `raw/mmb_mineru/runs/gpm6_imf13_us_pm08_us_pm08fl__a_small_quarterly_projection_model_of_the_us_economy__a2e8676b/full.md`.
- First-page sniff of the primary Markdown shows "A Small Quarterly Projection Model of the US Economy", December 2008, with authors Ioan Carabenciov, Igor Ermolaev, Charles Freedman, Michel Juillard, Ondra Kamenik, Dmitry Korshunov, and Douglas Laxton.
- The indexed model is `GPM6_IMF13`, but `.agents/skills/dynare-copilot/references/examples/GPM6_IMF13_rep.mod` identifies the implementation as the six-region 2013 GPM6 model. This is a high-priority `source_index_issue`.
- Alternate MinerU run `86500816-7954-4f67-b157-79058ffc0fde` was inspected through the run index and path search; it is the same U.S. small quarterly projection model source, not an unambiguous 2013 GPM6 source.
- Raw PDF exists at `raw/mmb_papers/A small quarterly projection model of the US economy.pdf`; per task instructions, the PDF body was not read.
- No `docs/mmb_appendix_full_normalizations/GPM6_IMF13.md` file was present.

## Formula Quality

- Status: `needs_review`.
- The linked Markdown contains clear OCR for source equations 1-15, which were normalized into archive equations (F1)-(F16).
- The source is semi-structural, so (F1)-(F16) are behavioral equations, identities, and stochastic processes, not optimization FOCs.
- The source Markdown has visible OCR defects in prose and variable descriptions, but the main displayed equations are readable enough for first-pass extraction.
- Formula coverage for the six-region GPM6 implementation is not source-supported. The `.mod` contains regional exchange-rate, foreign-activity, spillover, and long-rate equations that require paper-side confirmation.

## Implementation Cross-Check

- Existing file: `.agents/skills/dynare-copilot/references/examples/GPM6_IMF13_rep.mod`.
- Use level: `implementation_cross_check` only.
- It identifies regions `EA6`, `EU`, `JA`, `LA6`, `RC6`, and `US`.
- It repeats the U.S. small projection block and extends similar blocks to other regions, adding real effective exchange-rate measures, trade/spillover factors, long real-rate averages, regional residual processes, and steady-state assignments.
- These implementation details were used to detect mismatch and omissions, not as paper-side provenance.

## Deferred Issues

- Find or convert the correct 2013 GPM6 paper/source for `GPM6_IMF13`; the current source is shared with `US_PM08` and `US_PM08fl`.
- Decide whether `GPM6_IMF13` should be re-indexed separately from the 2008 U.S. SQPM paper.
- Check whether the indexed metadata year/authors/journal are internally inconsistent: the row lists year `2013` and `IMF Working Paper 08/278`, while the sniffed source is December 2008.
- Confirm exact equation mapping from the corrected paper to the six-region `.mod`.
- Runtime validation was not performed.

## Translation Status

- English derivation written first.
- Chinese derivation translated second from the English core.
- Both files preserve the same eight-section structure and (F1)-(F16) numbering.
