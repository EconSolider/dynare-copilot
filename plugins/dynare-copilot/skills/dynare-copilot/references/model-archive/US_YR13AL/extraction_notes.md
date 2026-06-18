# US_YR13AL Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row for `US_YR13AL` has `mineru_match_status=matched`, `mineru_match_score=1.0000`, and `model_title_match_score=1.0000`.
- First-page / first-80-line sniff of the primary Markdown matched the expected title and author: "The implications of financial frictions and imperfect knowledge in the estimated DSGE model of the U.S. economy", Yuliya Rychalovska.
- `raw_pdf_path` exists and was recorded for provenance. The PDF body was not read because the Markdown source was sufficient for the first-pass extraction.
- No alternate MinerU run was inspected because the model-index row lists a single run id and the title/author sniff was unambiguous.
- No `source_index_issue` was found.

## Formula Quality

- Printed equations (1)-(25) in the Markdown were used as the source for the archive equations.
- Financial-sector equations (capital-goods producer FOC, utilization, capital return, external finance premium, net worth), policy rule, resource constraint, learning equations, and measurement equations are readable enough for a first-pass draft.
- OCR artifacts remain in prose around entrepreneurs and in several figure/table transcriptions. Those artifacts did not determine the extracted equations.
- The paper explicitly refers to Smets and Wouters (2007) for much of the formal micro-foundation. The household Euler equation, price Phillips curve, wage Phillips curve, production/labor block, and several exogenous processes are therefore marked `needs_review` instead of being reconstructed from memory.

## Appendix Normalization

- `docs/mmb_appendix_full_normalizations/US_YR13AL.md` does not exist.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/US_YR13AL_rep.mod` does not exist.
- No `.mod` implementation was used as evidence.

## Deferred Issues

- Complete Smets-Wouters inherited equation block needs source-level checking against the relevant SW equations or an implementation file before this can become `reviewed_derivation`.
- The learning block in the paper is algorithmic; a future model implementation must decide whether to implement the time-varying learning mechanism or use a reduced-form/estimated representation.
- Steady-state ratios and full steady-state construction are incomplete in the source Markdown and need review before runtime validation.
- No Dynare run was performed.

## Translation Status

- English derivation was drafted first.
- Chinese derivation was translated from the English derivation and preserves the same eight-section structure and `(F#)` numbering.
