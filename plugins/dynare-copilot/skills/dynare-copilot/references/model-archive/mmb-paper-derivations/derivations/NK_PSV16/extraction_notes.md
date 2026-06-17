# NK_PSV16 Extraction Notes

## Source Match

- `model_index.csv` row is an exact title match for `NK_PSV16`.
- `primary_source_title`: "The price of capital and the financial accelerator".
- `model_title_match_score`: `1.0000`.
- MinerU run id: `a468e7e7-073f-4a72-a489-1ee9eba05671`.
- First-page Markdown title and authors match the model index.
- Raw PDF exists at `raw/mmb_papers/The price of capital and the financial accelerator.pdf`.
- No appendix normalization file exists at `docs/mmb_appendix_full_normalizations/NK_PSV16.md`.

## Formula Quality

- The paper formally derives the capital-producing firm problem and the equilibrium prices of newly installed and previously installed capital.
- The source-stated equations used directly are the capital demand return equation, investment finance schedule, capital-production technology, capital-producer profit problem, price FOCs, and the two linearized altered equilibrium conditions.
- The paper explicitly omits formal household, policy, entrepreneur, and retailer derivations because they are not central to its result. Those baseline BGG conditions in the archive derivation are therefore marked `implementation_cross_check`.
- `needs_review`: paper equation (9), represented as derivation (F15), is uncertain. The Markdown/OCR has noise in the definition of `varphi`, and the `.mod` cross-check writes `qtilde = delta*psi/(1-delta)*i - delta*psi/(1-delta)*k(-1) + q`, which differs from the Markdown-rendered sign on investment and from the source equation's capital timing.
- `needs_review`: the source has a noisy rendering of `epsilon` and `varphi` definitions after equations (8)-(9). `epsilon` is readable and matches the `.mod` calibration formula; `varphi` requires source-level review.

## Implementation Cross-Check

- Cross-check file: `.agents/skills/dynare-copilot/references/examples/NK_PSV16_rep.mod`.
- Used only to identify the implemented variable set, calibration constants, linearized BGG baseline equations, and timing conventions.
- Dynare was not run.
- The `.mod` confirms endogenous variables: `y c i g ce n rk r q k x a h pi rn qtilde`.
- The `.mod` confirms exogenous shocks: `eM eG eA`.
- The `.mod` labels the model as "BGG model augmented with the Equilibrium Price of Capital".

## Deferred Issues

- Source-level formula review is needed for paper equation (9) against the PDF image or publisher source.
- The broader BGG baseline was not re-derived from BGG (1999); it was reconstructed from the PSV16 paper description plus the implementation cross-check.
- Runtime validation, residual checks, steady-state checks, BK checks, and IRF reproduction are deferred.

## Translation Status

- English derivation drafted first.
- Chinese derivation translated from the English derivation with matching section order and F-numbering.
- English and Chinese equation-number counts should match.
