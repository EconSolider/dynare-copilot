# EA_VI16gk Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row for `EA_VI16gk` has `mineru_match_status=matched`, `mineru_match_score=1.0000`, and `model_title_match_score=1.0000`.
- Primary Markdown: `raw/mmb_mineru/runs/ea_vi16bgg_ea_vi16gk_us_vi16bgg_us_vi16gk__financial_frictions_in_the_euro_area_and_the_united_states_a_bayesian_as__ed2f2b1d/full.md`.
- Raw PDF path exists: `raw/mmb_papers/Financial frictions in the Euro Area and the United States- a Bayesian assessment.pdf`.
- Optional appendix normalization was not present at `docs/mmb_appendix_full_normalizations/EA_VI16gk.md`.
- Raw PDF body was not read because the main equations were available in the MinerU Markdown.

## Formula Quality

- Main extraction source is Table 1, "Linearized model equations", plus Table 1 Continued for SWGK equations (19b)-(23b).
- The source table is readable enough for a first-pass derivation, but several OCR artifacts remain:
  - Equation (17b) appears as `E_t [ lev t + 1 ]`; this was normalized to expected next-period leverage using the equation label and implementation cross-check. Status: `needs_review`.
  - Equation (19b) splits `lev` as `l\hat{ev}`; this was normalized to \(\widehat{lev}_t\). Status: `needs_review`.
  - The note defining \(\hat{\Lambda}_{t,t+1}\) and \(\hat{\mu}_t\) contains malformed OCR; the derivation uses the readable structure plus implementation cross-check. Status: `needs_review`.
- The paper says all shocks follow AR(1), but the main text does not print each AR(1) equation. The process block uses the Rep-MMB implementation as `implementation_cross_check` and should be checked against the online appendix.

## Implementation Cross-Check

- Cross-check file: `.agents/skills/dynare-copilot/references/examples/EA_VI16gk_rep.mod`.
- Used only to check:
  - `model(linear)` form;
  - variable names for the EA SWGK variant;
  - seven shocks: `e_a`, `e_x`, `e_g`, `e_k`, `e_r`, `e_p`, `e_w`;
  - Rep-MMB timing comments for equation 18b and equation 19;
  - flexible-price counterpart variables used in the output-gap Taylor rule.
- The `.mod` was not treated as a paper-side mathematical source.

## Deferred Issues

- `needs_review`: verify the SWGK financial block against the online appendix or original PDF if a source-level final review is required.
- `needs_review`: decide whether the archive should record the paper timing for equation (18b), the Rep-MMB shifted timing, or both in any future runnable `.mod` implementation.
- `needs_review`: equation (19b) capital timing differs between the paper notation and Rep-MMB comment; future runtime validation should decide the implementation timing.
- `deferred_runtime_validation`: Dynare `resid`, `steady`, `check`, estimation, and IRF replication were not run.

## Proposed Shared Index Rows

Do not apply these rows from this worker. They are proposed for the main agent to merge if desired.

### catalog.csv

```csv
ModelID,Task,Paper,Year,ModelType,Economy,Category,KeyFeatures,DateAdded,SourceFullMD,RawPDF,DOI,Status
EA_VI16gk,model_derivation,Financial frictions in the Euro Area and the United States: a Bayesian assessment,2016,Estimated linearized DSGE,Euro Area,Financial frictions,Smets-Wouters economy with Gertler-Karadi financial intermediary friction,2026-06-17,raw/mmb_mineru/runs/ea_vi16bgg_ea_vi16gk_us_vi16bgg_us_vi16gk__financial_frictions_in_the_euro_area_and_the_united_states_a_bayesian_as__ed2f2b1d/full.md,raw/mmb_papers/Financial frictions in the Euro Area and the United States- a Bayesian assessment.pdf,10.1017/s1365100514000881,needs_review
```

### status.csv

```csv
model_id,paper_title,source_full_md,raw_pdf_path,status,formula_quality,steady_state_quality,needs_human_review,notes
EA_VI16gk,Financial frictions in the Euro Area and the United States: a Bayesian assessment,raw/mmb_mineru/runs/ea_vi16bgg_ea_vi16gk_us_vi16gk__financial_frictions_in_the_euro_area_and_the_united_states_a_bayesian_as__ed2f2b1d/full.md,raw/mmb_papers/Financial frictions in the Euro Area and the United States- a Bayesian assessment.pdf,needs_review,mostly_readable_with_ocr_issues,linear_model_zero_hatted_steady_state,true,SWGK Euro Area variant; AR(1) shocks and timing issues need appendix/runtime review
```
