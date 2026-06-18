# NK_ET14 Extraction Notes

## Source Match

- Model index row: `NK_ET14`.
- Paper: Ellison and Tischbirek (2014), "Unconventional government debt purchases as a supplement to conventional monetary policy."
- DOI: `10.1016/j.jedc.2014.03.012`.
- Match status: `matched`; MinerU match score `1.0000`; model-title match score `1.0000`.
- Primary Markdown: `raw/mmb_mineru/runs/nk_et14__unconventional_government_debt_purchases_as_a_supplement_to_conventional__f7e430ba/full.md`.
- Raw PDF path exists: `raw/mmb_papers/Unconventional government debt purchases as a supplement to conventional monetary policy.pdf`.
- PDF body was not read. No targeted PDF check was needed for this draft because the main text plus Appendix B supplied the stationary model and steady-state formulas.

## Formula Quality

- Main equations were extracted from Section 2 and Appendix B.1.
- Appendix B is compact and maps directly to the MMB implementation, but MinerU OCR introduced artifacts:
  - B.4 dropped needed parentheses in the exponent; the main-text equation (7) was used instead.
  - B.6 rendered `theta_t, phi`; the main-text equation (9) was used instead.
  - B.28 and B.42 include likely OCR denominator/case artifacts and remain `needs_review`.
  - The inflation-response coefficient sometimes appears as `gamma_II`; it was normalized to `gamma_\Pi`.
- Equations are numbered continuously as `(F1)` through `(F25)` in both English and Chinese drafts.

## Implementation Cross-Check

- Cross-check file: `.agents/skills/dynare-copilot/references/examples/NK_ET14_rep.mod`.
- Used only as `implementation_cross_check`, not as a paper-side source.
- The `.mod` confirmed the variable set: `Y C s G Pi L ChiC Ps PQ PB w ChiL F K A b q qbar qCB i iQ D theta nu ksi Pss`.
- The `.mod` confirmed seven innovations: `epsC epsL epsA epsthet epsG epsnu epsksi`.
- The `.mod` uses negative signs in the `nu` and `ksi` shock equations to make positive shocks expansionary. The derivation records the paper-side AR(1) laws and notes this implementation convention separately.
- The `.mod` includes an additional accounting variable `Pss = Ps*s`; the derivation treats it as implementation accounting, not a separate paper-side equilibrium condition.

## Deferred Issues

- `needs_review`: verify B.28 steady-state output expression and B.42 steady-state long-bond demand against the PDF or publisher source before marking reviewed.
- `needs_review`: confirm whether the long-bond yield formula should be rendered as a product of the two factors after `1/tau`; the expression follows the paper and `.mod` intent but should be source-level checked before promotion.
- Runtime validation, residual checks, Blanchard-Kahn checks, and IRF replication were not performed.
- Shared `catalog.csv` and `status.csv` were intentionally not updated per user scope restriction.

## Translation Status

- English derivation drafted first.
- Chinese derivation translated from the English derivation.
- Equation numbers and formulas were preserved across translations.
