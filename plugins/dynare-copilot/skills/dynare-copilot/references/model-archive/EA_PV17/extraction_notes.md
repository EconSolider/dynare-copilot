# EA_PV17 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` has a clean `matched` row for `EA_PV17`, with `model_title_match_score=1.0000`.
- First 80 lines of `raw/mmb_mineru/runs/ea_pv17__the_macroeconomic_effects_of_the_ecb_s_evolving_qe_programme_a_model_bas__dca27de6/full.md` show the expected title and authors.
- Raw PDF exists at `raw/mmb_papers/The macroeconomic effects of the ECB's evolving QE programme- a model-based analysis.pdf`; the PDF body was not opened.
- No appendix-normalization file exists at `docs/mmb_appendix_full_normalizations/EA_PV17.md`.

## Formula Quality

- The MinerU Markdown includes the paper's model appendix and displayed equations for firms, households, long-term bonds, policy, and trade.
- First-pass uncertain formulas are marked `needs_review` in the English and Chinese derivations.
- Known OCR issues:
  - Household Lagrangian Eq. (14) is multi-line and should be checked against the PDF before review promotion.
  - Domestic long-term bond Euler Eq. (17) has a malformed OCR tag and superscripts.
  - Foreign long-term bond Euler Eq. (18) has OCR ambiguity in the foreign long-bond superscripts.
  - Shadow capital value Eq. (24) ends with an ambiguous `=0` in the Markdown.
- The derivation intentionally extracts a compact source-backed core rather than every equation in the Rep-MMB implementation.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/EA_PV17_rep.mod` was used only as `implementation_cross_check`.
- Cross-check findings:
  - EA and RoW are implemented symmetrically with `ea_`/`r_` and `EA_`/`R_` prefixes.
  - QE appears through `EA_blcb`, `EA_eps_qe`, `EA_rhoqe`, and `EA_tqe`, consistent with the paper's central-bank long-bond purchase block.
  - Implementation includes many shocks and steady-state target variables not fully derived in the appendix; these remain cross-check-only evidence.
  - Long-term bond composition and central-bank profit equations match the appendix at a structural level.

## Deferred Issues

- Source-level formula review against the PDF or publisher version is needed before status can move beyond `needs_review`.
- Full steady-state derivation is not provided in the paper appendix and was not reconstructed from the full `.mod` initial values.
- Runtime validation was not performed: no Dynare `steady`, `check`, or stochastic simulation was run.
- Shared `catalog.csv` and `status.csv` were not edited by request.

## Translation Status

- English derivation was drafted first.
- Chinese derivation was translated from the English version.
- Equation numbers `(F1)` through `(F38)` are preserved with matching counts.
