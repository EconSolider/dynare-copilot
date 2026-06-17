# NK_GHP16 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row found for `NK_GHP16`.
- Match status: `matched`.
- MinerU match score: `1.0000`.
- Model title match score: `1.0000`.
- Primary Markdown: `raw/mmb_mineru/runs/nk_ghp16__housework_and_fiscal_expansions__abf81d2a/full.md`.
- Raw PDF exists: `raw/mmb_papers/Housework and Fiscal Expansions.pdf`.
- PDF body was not opened, per task rule. It is recorded for provenance only.
- No appendix normalization file exists at `docs/mmb_appendix_full_normalizations/NK_GHP16.md`.

## Formula Quality

The primary Markdown prints the main Section 2 model equations for households, firms, policy, market clearing, price dispersion, and the steady-state calibration system.

Consequences:

- The first-pass derivation is substantially source-backed by the Markdown.
- The compact Calvo auxiliary recursions are marked `needs_review` because the paper gives the firm profit problem but not the exact recursive MMB variables.
- The exact MMB restriction of the Taylor rule is marked as implementation-specific because the paper's general rule includes interest-rate smoothing, output gap, and output-gap growth terms.
- No formula was silently filled in from the PDF body.
- No targeted PDF formula check was performed.

## Implementation Cross-Check

Read `.agents/skills/dynare-copilot/references/examples/NK_GHP16_rep.mod` only as `implementation_cross_check`.

Used for:

- Dynare variable names: `C`, `C_m`, `C_n`, `K`, `K_m`, `K_n`, `I`, `W`, `h_m`, `h_n`, `r_k`, `r`, `lambda`, `infl`, `inflstar`, `x_1`, `x_2`, `RMC`, `G`, `g`, `Y`, `D`;
- exogenous shock name: `e_g`;
- KPR utility specialization and marginal utility expression;
- log-variable convention for positive variables;
- Calvo recursive auxiliary variables `x_1` and `x_2`;
- restricted Taylor rule `exp(1+r)=beta^(-1)*exp(infl)^phi_infl`;
- predetermined-capital timing in Dynare notation.

Not used for:

- claiming paper-side equations when the Markdown did not print them;
- runtime validation;
- promotion to `.agents/skills/dynare-copilot/references/model-archive/`.

## Deferred Issues

- Calvo auxiliary recursions should be checked against the online appendix or targeted PDF equations before moving beyond `needs_review`.
- The implementation's factor FOCs include `taup`, while the paper discusses a production subsidy `tau`; this wedge needs source-level reconciliation.
- The Taylor rule in the implementation is a restricted version of the paper's general rule; the archive records both, but the exact MMB variant remains implementation-specific.
- The capital adjustment cost expression in the paper is transcribed from OCR and should be targeted-checked if this entry is promoted to runnable replication work.
- Runtime validation, Dynare residual checks, Blanchard-Kahn checks, and IRF checks were not performed.

## Translation Status

- English draft was written first.
- Chinese draft is a translation of the checked English draft.
- Equation numbers `(F1)` through `(F25)` are preserved in both files.
