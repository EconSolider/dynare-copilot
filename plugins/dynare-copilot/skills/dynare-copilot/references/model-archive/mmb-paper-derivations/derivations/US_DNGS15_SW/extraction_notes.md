# US_DNGS15_SW Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row for `US_DNGS15_SW` points to `raw/mmb_mineru/runs/us_dngs15_us_dngs15_sw_us_dngs15_swsp_us_dngs15__infation_in_the_great_recession_and_new_keynesian_models__c8e184ab/full.md`.
- First-page/first-80-line sniff matched the expected title and authors: "Inflation in the Great Recession and New Keynesian Models"; Marco Del Negro, Marc P. Giannoni, Frank Schorfheide.
- The row's `raw_pdf_path` exists at `raw/mmb_papers/Infation in the Great recession and New Keynesian models.pdf`. The PDF body was not opened because the Markdown was sufficient for a first-pass `needs_review` draft and the user did not request targeted PDF checking.
- `docs/mmb_appendix_full_normalizations/US_DNGS15_SW.md` does not exist.
- `.agents/skills/dynare-copilot/references/examples/US_DNGS15_SW_rep.mod` exists and was used only as `implementation_cross_check`.

## Formula Quality

- Overall formula quality: `needs_review`.
- The SW log-linear equations in Section I.A are mostly readable in the MinerU Markdown, especially the productivity, consumption Euler, investment, capital, utilization, marginal-cost, production, resource, Phillips-curve, policy, and shock-process equations.
- OCR issues remain in some equation typography: extra spaces, occasional malformed subscripts, the consumption Euler line break, and the wage Phillips curve denominator/markup notation.
- The model-index title and raw PDF filename contain `Infation`, while the Markdown heading has the corrected `Inflation`.
- The derivation preserves the paper's displayed linear equations but does not source-check them against the PDF images.

## Implementation Cross-Check

- `US_DNGS15_SW_rep.mod` confirms `model(linear)`.
- The implementation confirms the main endogenous variables: `c`, `R`, `pi`, `L`, `qk`, `i`, `Rktil`, `rk`, `kbar`, `y`, `k`, `u`, `mc`, `w`, `wh`, `z`, `ztil`, `mu`, `sigw`, `laf`, `law`, `g`, `b`, plus `rm`, `pist`, and flexible-price counterparts.
- The implementation confirms capital timing: current production uses `kbar(-1)` through `k = u-z+kbar(-1)`.
- The implementation includes a financial-spread equation with `sigw` but no entrepreneurial net-worth state `n`; this differs from the paper's full financial-friction extension and from `US_DNGS15_SWSP_rep.mod`.
- No equations were copied from the `.mod` file as paper-side source evidence.

## Deferred Issues

- Review the exact MMB variant boundary among `US_DNGS15`, `US_DNGS15_SW`, `US_DNGS15_SWSP`, and `US_DNGS15_SWpi`.
- PDF-check the SW equations before upgrading from `needs_review`, especially the wage Phillips curve and consumption Euler equation.
- Decide whether a reviewed archive entry should expand the flexible-price comparison block equation-by-equation or keep it as a compact auxiliary system.
- Add a local appendix normalization or source-backed steady-state appendix if the technical appendix becomes available.
- Runtime validation, Dynare equation count, steady-state residuals, BK checks, and IRF checks were not performed.

## Translation Status

- `US_DNGS15_SW_derivation.zh.md` is a translation of the English draft.
- Equation numbers `(F1)` through `(F28)` and LaTeX formulas were preserved.
