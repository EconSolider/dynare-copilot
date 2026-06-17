# EA_SW03 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row read for `EA_SW03`.
- Primary source title: "An estimated dynamic stochastic general equilibrium model of the euro area".
- Primary Markdown first-page sniff matches expected title and authors: Frank Smets and Raf Wouters.
- `model_title_match_score`: `1.0000`.
- `mineru_run_ids`: `244ad381-274c-4050-99e1-38d38ebaabf7`; `22b8bb79-81e8-4a35-b7c0-41aec144b83d`.
- No unambiguous source-index issue found; primary run was used.
- Raw PDF exists at `raw/mmb_papers/An estimated dynamic stochastic general equilibrium model of the euro area.pdf`. PDF body was not read.

## Formula Quality

- Overall formula quality: `needs_review`.
- Structural equations (household utility, budget constraint, capital accumulation, price/wage setting, goods market clearing) are mostly legible in MinerU Markdown.
- The productivity shock text near the production function contains severe OCR repetition/noise and should be checked against the PDF before review promotion.
- The investment adjustment-cost FOC around paper equation (16) is split across display blocks; it is included with `needs_review`.
- The paper's linearized equations (28)-(36) are usable as a first-pass estimate-system extraction, but several notation choices should be checked against PDF before marking reviewed.

## Implementation Cross-Check

- Read `.agents/skills/dynare-copilot/references/examples/EA_SW03_rep.mod` only as `implementation_cross_check`.
- Cross-check confirmed `model(linear)`.
- Cross-check confirmed major variables: `c`, `inve`, `pk`, `kp`, `pinf`, `w`, `r`, `rk`, `lab`, `y`, `empl`, `mc`, plus flexible-price counterparts.
- Cross-check confirmed capital timing through lagged installed capital terms such as `kp(-1)` and `kpf(-1)`.
- Cross-check confirmed MMB reporting and policy-rule variables are implementation-specific and not paper-side derivation.

## Deferred Issues

- Source-level PDF check needed for paper equation (16), shock-process notation, and any OCR-corrupted formula spans.
- Nonlinear steady-state level reconstruction is not complete; current steady-state section records the linearized zero-deviation convention and selected calibrated ratios.
- Runtime validation was not performed by assignment.
- Shared `catalog.csv` and `status.csv` were not edited; proposed row values are in `worker_report.json` and `source_manifest.json`.

## Translation Status

- English derivation written first as `EA_SW03_derivation.en.md`.
- Chinese derivation written second as `EA_SW03_derivation.zh.md`.
- Both versions preserve the same eight section headings and the same `(F1)` through `(F21)` numbering.
