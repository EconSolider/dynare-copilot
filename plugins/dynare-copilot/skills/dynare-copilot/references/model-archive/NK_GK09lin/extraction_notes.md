# NK_GK09lin Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row for `NK_GK09lin` has `mineru_match_status=matched`, `mineru_match_score=1.0000`, and `model_title_match_score=1.0000`.
- Primary Markdown: `raw/mmb_mineru/runs/nk_gk09lin_nk_gk11__a_model_of_unconvetional_monetary_policy__e6192938/full.md`.
- Raw PDF path exists and was checked for provenance only: `raw/mmb_papers/A Model of Unconvetional Monetary Policy.pdf`.
- No `docs/mmb_appendix_full_normalizations/NK_GK09lin.md` file exists.

## Formula Quality

- The main model section of the Markdown exposes the household, intermediary, credit-policy, production, capital-production, retail-pricing, resource, government-budget, Fisher, Taylor-rule, and credit-policy-feedback equations.
- The paper source is nonlinear. `NK_GK09lin_rep.mod` is a compact `model(linear)` implementation. The derivation records the nonlinear paper-side ancestors and marks equation-by-equation linearization parity as `needs_review`.
- The MinerU OCR has visible notation noise in several places, including the household occupational-switching paragraph, Eq. (23), Eq. (25), and Greek-letter rendering in the policy rule discussion. The archive formula choices were made from the readable Markdown equations, not from the raw PDF body.
- Marked `needs_review`: exact mapping between paper $`K_t/K_{t+1}`$ timing notation and each lag/lead in the MMB linear implementation; exact auxiliary-variable recursions for Calvo pricing as implemented by `f`, `f1`, and `d`; the linear net-worth shock `e_n`, which is implementation-specific rather than a separately named paper shock.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/NK_GK09lin_rep.mod` exists and was used only as an implementation cross-check.
- The `.mod` confirms `model(linear)`, the four shocks `e_rn`, `e_a`, `e_epsilon`, and `e_n`, and core variables including `nu`, `eta`, `x`, `z`, `phi`, `n`, `ne`, `nn`, `q`, `k`, `delta`, `u`, `l`, `y`, `i`, `c`, `pmn`, `pi`, `rn`, `epsilon`, `a`, `efp`, `lambda`, `rk`, `psi`, `phic`, `f`, `f1`, `pistar`, `ym`, `mc`, `d`, and `in`.
- The `.mod` steady-state calculations were used to identify implementation normalization and parameter names, but were not treated as paper-side mathematical source.

## Deferred Issues

- Runtime validation was not performed.
- A targeted source review should check the exact linearization of the intermediary value recursions and Calvo auxiliary equations against the implementation.
- The raw PDF body was not read; it may be useful only for targeted checks of OCR-noisy equations if this entry is promoted beyond first-pass status.
- Shared archive indexes (`catalog.csv`, `status.csv`) were intentionally not touched for this task.

## Translation Status

- English derivation drafted first.
- Chinese derivation translated from the English core.
- F-number parity checked: English and Chinese both contain equation-definition bullets `(F1)` through `(F35)`.
