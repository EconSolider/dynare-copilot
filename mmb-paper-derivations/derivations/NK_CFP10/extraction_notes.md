# NK_CFP10 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row: `NK_CFP10`.
- Primary title match is exact (`model_title_match_score = 1.0000`).
- Primary Markdown: `raw/mmb_mineru/runs/nk_cfp10__optimal_monetary_policy_in_a_model_with_agency_costs__381a62e0/full.md`.
- Raw PDF exists at `raw/mmb_papers/Optimal monetary policy in a model with agency costs.pdf`; PDF body was not read because Markdown was sufficient for a first-pass extraction.
- No optional normalization file was present at `docs/mmb_appendix_full_normalizations/NK_CFP10.md`.

## Formula Quality

- Overall status: `needs_review`.
- The main model equations (1)-(13), output-gap transformations (16)-(26), policy constraints (32)-(35), and appendix equations (A1)-(A11) are present in MinerU Markdown.
- OCR issue: appendix equation (A4) appears with an inconsistent current-output term. The derivation uses the economically standard Euler/asset-pricing form `E_t y_{t+1} - y_t`, but marks (F12) as `needs_review`.
- OCR issue: some appendix notation around \(\Lambda=F'/F\), the CSV distribution functions, and the optimal targeting criterion contains duplicated or malformed symbols. These are not central to the reduced simulation model but should be checked against the PDF before review status is upgraded.
- The derivation emphasizes the MMB `model(linear)` version rather than reproducing every optimal-policy condition from the paper.

## Implementation Cross-Check

- Cross-check file: `.agents/skills/dynare-copilot/references/examples/NK_CFP10_rep.mod`.
- Used only for variable names, shock names, timing, and equation coverage.
- The `.mod` confirms the linear variables `y, yeff, yg, R, pi, z, phi, e, q, d, L, u, r, w, a, eps_pi, n, eps_R`.
- The `.mod` confirms four innovations: `eta_a`, `eta_pi`, `eta_n`, and `eta_R`.
- The `.mod` confirms calibration choices including `b = 0.20`, `Lam = b-1`, `lam = (eps-1)/varphi`, and Taylor-rule coefficients `tau`, `tau_g`.

## Deferred Issues

- Runtime validation was not performed.
- Equation (F12) should be checked against the PDF image/body before final review.
- The derivation does not include the full optimal commitment targeting criterion as an archive equation because it is a policy-analysis result rather than the MMB simulation closure.
- The CSV appendix mapping is summarized only for calibration and interpretation; full CSV contract equations are not included in the main F-numbered system.
- The paper's nonlinear household budget constraint is not explicitly printed in the model section; the archive records the source-reported household optimality conditions instead.

## Translation Status

- English derivation drafted first.
- Chinese derivation translated from the English artifact.
- F-number counts match: 26 in English and 26 in Chinese.
