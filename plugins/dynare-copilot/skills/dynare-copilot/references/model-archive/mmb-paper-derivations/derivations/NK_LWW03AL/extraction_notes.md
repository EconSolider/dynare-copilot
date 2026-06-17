# NK_LWW03AL Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` line 82 maps `NK_LWW03AL` to Levin, Wieland, and Williams (2003), DOI `10.1257/000282803322157016`, with `mineru_match_status=matched`, `mineru_match_score=1.0000`, and `model_title_match_score=1.0000`.
- The first Markdown lines of `raw/mmb_mineru/runs/nk_lww03_nk_lww03al_us_frb03__the_performance_of_forecast_based_monetary_policy_rules_under_model_unce__c97e3d2f/full.md` show the expected title and authors Andrew Levin, Volker Wieland, and John C. Williams.
- The raw PDF exists at `raw/mmb_papers/The Performance of Forecast-Based Monetary Policy Rules under Model Uncertainty.pdf`. The PDF body was not read because the Markdown was sufficient for the targeted core equations.
- No appendix normalization file exists at `docs/mmb_appendix_full_normalizations/NK_LWW03AL.md`.

## Formula Quality

- The core paper equations used here are legible in the MinerU Markdown: the forecast-based policy rule (paper equation 1), optimizing AD-AS equations (paper equations 2 and 3), the estimated benchmark rule (paper equation 4), the loss function (paper equation 5), the average-loss rule (paper equation 6), and the robust benchmark rule (paper equation 7).
- MinerU OCR is noisy in some table notes and symbols, but Tables 3, 9, and 10 are usable for first-pass extraction.
- The paper states that the small AD-AS equations are derived from optimizing agents, but it does not print the underlying household and firm optimization problems. Those missing primitives are marked `needs_review`.
- The adaptive-learning (`AL`) variant is not derived in the paper-side Markdown. It is identified from local MMB implementation metadata and remains `needs_review`.

## Implementation Cross-Check

- `raw/mmb/mmci-cli/models/NK_LWW03AL/NK_LWW03AL.mod` and `.json` were read only as `implementation_cross_check`.
- The `.json` metadata marks `"al": true`, category `Adaptive learning model`, variables including `ygap`, `pdot`, `rff`, `rstar`, `drff`, `pdotsh`, `pinf4`, and shocks `interest_`, `pdotsh_`, and `rstar_`.
- The `.mod` implements the same small linear AD-AS core as `NK_LWW03`, adds a Modelbase policy-rule interface, and saves `AL_Info` with forward variables `ygap`, `pdot`, `inflationq`, long states `rstar`, `interest`, `inflationq`, `inflationql`, `inflationql2`, and short states `interest`, `outputgap`.
- `.agents/skills/dynare-copilot/references/examples/NK_LWW03_rep.mod` exists only for sibling `NK_LWW03`; no `NK_LWW03AL_rep.mod` exists in the skill examples. The sibling file was used only to confirm the rational-expectations core and not as a paper source.
- Dynare was not run.

## Deferred Issues

- Source-level review should identify whether a paper appendix, replication note, or MMB documentation states the adaptive-learning law and initial-belief conventions for `NK_LWW03AL`.
- The exact mapping from the paper's benchmark rule coefficients to the MMB general policy-rule vector should be reviewed against `policy_param.mat` and the Modelbase documentation before promotion.
- The model's steady state is straightforward for the linearized gap system, but the adaptive-learning state initialization remains deferred.
- Runtime validation, BK checks, AL simulation checks, and IRF checks are deferred to a later implementation-validation phase.

## Translation Status

- English derivation drafted first at `data/model_archive/mmb_derivations/NK_LWW03AL/NK_LWW03AL_derivation.en.md`.
- Chinese translation drafted second at `data/model_archive/mmb_derivations/NK_LWW03AL/NK_LWW03AL_derivation.zh.md`.
- The Chinese translation preserves the eight-section order, equation numbering, paths, DOI, model ID, and status markers.

## Shared Indexes

- `data/model_archive/mmb_derivations/catalog.csv` was not edited by instruction.
- `data/model_archive/mmb_derivations/status.csv` was not edited by instruction.
- Proposed index rows are recorded in `worker_report.json` for later main-agent merge work.
