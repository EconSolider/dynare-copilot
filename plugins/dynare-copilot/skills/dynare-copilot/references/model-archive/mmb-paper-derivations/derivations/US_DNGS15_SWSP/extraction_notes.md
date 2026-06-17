# Extraction Notes -- US_DNGS15_SWSP

## Source Match

- `raw/mmb_mineru/model_index.csv` maps `US_DNGS15_SWSP` to MinerU run `c8e184ab-3624-4257-9ea5-7ec1cf904fbb`.
- The index `primary_source_title` contains the typo `Infation`, but the first page of `full.md` has the expected title, "Inflation in the Great Recession and New Keynesian Models."
- Raw PDF exists at `raw/mmb_papers/Infation in the Great recession and New Keynesian models.pdf`; the PDF body was not read because the Markdown model section contained the target equations.
- No normalized appendix file exists at `docs/mmb_appendix_full_normalizations/US_DNGS15_SWSP.md`.

## Formula Quality

- The paper reports log-linear equilibrium conditions rather than primitive nonlinear optimization problems.
- Equations (3)-(21) from the paper-side Markdown were used for the core model block; equations (22)-(27) on fundamental inflation were not included as model equilibrium conditions.
- OCR quality is broadly usable, but some typography around bars, stars, and expectation brackets needed normalization. This is why the first-pass status remains `needs_review`.
- Full steady-state derivation remains `needs_review` because the paper refers steady-state formulas to the technical appendix of Del Negro and Schorfheide (2013), which was not part of the assigned source set.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/US_DNGS15_SWSP_rep.mod` confirms `model(linear)`, spread observables, the financial-friction variables `Rktil`, `n`, and `sigw`, and the parallel flexible-price/wage block.
- `raw/mmb/mmci-cli/models/US_DNGS15_SWSP/US_DNGS15_SWSP.mod` confirms the MMB policy-rule interface variables `interest`, `inflation`, `inflationq`, `outputgap`, `output`, and `fispol`.
- The `.mod` files were not treated as paper-side mathematical sources and Dynare was not run.

## Deferred Issues

- Recovering primitive household, investment, Calvo wage/price, and entrepreneur/bank Lagrangians would require importing external CEE/SW/BGG/CMR derivations.
- The compact paper Taylor rule differs from the MMB implementation's model-base policy-rule interface; this entry records the paper rule and notes the implementation variant.
- The flexible-price/wage block is summarized as a counterpart system rather than fully duplicating every equation in the English and Chinese derivations.
- Runtime validation, equation-count validation against Dynare, and BK checks are deferred.

## Translation Status

- English derivation drafted first.
- Chinese derivation translated from the English version with matching section structure and F-numbering.
