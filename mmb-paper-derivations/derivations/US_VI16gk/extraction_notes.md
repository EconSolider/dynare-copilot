# US_VI16gk Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row 166 lists `US_VI16gk` as Villa (2016), "Financial frictions in the Euro Area and the United States: a Bayesian assessment."
- The row's `primary_full_md_path` begins with the expected title, `FINANCIAL FRICTIONS IN THE EURO AREA AND THE UNITED STATES: A BAYESIAN ASSESSMENT`, and author, `STEFANIA VILLA`.
- The row lists a single MinerU run id, `ed2f2b1d-60d9-4da9-a9c6-b57af3b7e740`; no alternate run inspection was needed.
- The row's raw PDF path exists: `raw/mmb_papers/Financial frictions in the Euro Area and the United States- a Bayesian assessment.pdf`. Per instructions, the PDF body was not read.
- No `docs/mmb_appendix_full_normalizations/US_VI16gk.md` file exists.

## Formula Quality

- Status: `needs_review`.
- The derivation uses the paper's main-text Table 1 as the equation backbone for the SWGK model: common SW equations (1)-(12), the capital-return equation (13a), and SWGK equations (14b)-(23b).
- The source Markdown table is usable but OCR-sensitive. I did not invent missing nonlinear optimization problems or a nonlinear steady state; where the paper gives only linearized conditions, the derivation says so.
- Equations marked `needs_review`:
  - (F16) leverage condition, because Rep-MMB shifts equation 18b one period forward for determinacy while the paper table prints the contemporaneous equation.
  - (F17) FI balance-sheet constraint, because the paper table uses $`K_{t+1}+Q_t`$ while Rep-MMB changes capital to a static `k` convention.
  - (F26)-(F32) shock-process sign conventions, because the Rep-MMB implementation uses negative signs for some innovations while the derivation preserves a paper-side AR(1) convention.
- The full flexible-price/wage reference block is summarized rather than numbered equation-by-equation. It should be expanded if the later runnable replication requires exact flexible-block equation parity.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/US_VI16gk_rep.mod` exists and was read only as `implementation_cross_check`.
- The `.mod` confirms:
  - `model(linear)` form;
  - US SWGK variable set with `ext_pr`, `lev`, `Lambda`, `v`, `d`, `z`, `x`, `n`, `ne`, `nn`, and flexible counterparts with `f` suffixes;
  - seven innovations: `e_x`, `e_r`, `e_k`, `e_g`, `e_a`, `e_w`, and `e_p`;
  - Rep-MMB timing notes for equations 13, 18b, and 19;
  - US posterior/calibrated parameter values used by the implementation.
- The `.mod` was not treated as paper-side equation evidence and was not run.

## Deferred Issues

- Targeted PDF checks should verify all Table 1 equations before review status is upgraded.
- The exact mapping between paper-side hatted variables and Rep-MMB variable timing should be reviewed for equations 13a, 18b, 19b, and 20b.
- A full steady-state constant derivation is deferred. The current entry records source calibration targets and implementation transformed constants only.
- The flexible-price/wage reference economy should be expanded if the archive entry later needs one equation per implementation variable.
- Dynare runtime validation was explicitly not performed.

## Translation Status

- English derivation was drafted first.
- Chinese derivation was translated from the English draft.
- Equation numbers `(F1)` through `(F32)` are preserved in both files.
