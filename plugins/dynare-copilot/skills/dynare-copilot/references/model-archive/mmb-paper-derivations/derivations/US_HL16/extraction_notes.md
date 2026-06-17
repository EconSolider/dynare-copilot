# US_HL16 Extraction Notes

Status: `needs_review`

## Source Match

- `raw/mmb_mineru/model_index.csv` row for `US_HL16` is matched with title score `1.0000`.
- Primary Markdown title and authors match the index: "The equity price channel in a New-Keynesian DSGE model with financial frictions and banking", Hylton Hollander and Guangling Liu.
- Raw PDF exists at `raw/mmb_papers/The equity price channel in a New-Keynesian DSGE model with financial frictions and banking.pdf`.
- No appendix normalization file exists at `docs/mmb_appendix_full_normalizations/US_HL16.md`.

## Formula Quality

- Main model extraction used Section 3 and Appendix A from the MinerU Markdown.
- Appendix A states a complete 32-variable, 32-equation nonlinear system, but several equations contain OCR artifacts.
- Marked as `needs_review` in the derivation:
  - capital shadow-price and capital-demand equations, because Appendix A mixes time subscripts and has punctuation/OCR damage;
  - retail reset-price and retail loan-rate equations, because OCR disrupts exponents and continuation text;
  - aggregate labor identity, because Appendix A says $H_t=H_t^h+H_t^e$ while the main text distinguishes saver/borrower household labor and entrepreneur labor demand;
  - aggregate equity-dividend equation, because Appendix A repeats $\Pi_t^\psi$ in the numerator where entrepreneur dividends appear intended;
  - monetary policy shock AR coefficient, because Appendix A prints $\rho_z$ for $\xi_{i,t}$ while the text and implementation point to $\rho_i$.
- Long prose from the paper was not copied into the derivation; equations and concise model structure were extracted.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/US_HL16_rep.mod` exists and was read only as `implementation_cross_check`.
- The implementation uses `model(linear)`, 32 core endogenous variables plus observables, and nine innovations: `epsilon_p`, `epsilon_z`, `epsilon_i`, `epsilon_d`, `epsilon_h`, `epsilon_e`, `epsilon_nu_h`, `epsilon_nu_e`, and `epsilon_psi`.
- The `.mod` confirms log-linear implementation variables such as `c_b`, `c_s`, `q_psi`, `k_B`, `l_h`, `l_e`, `i_h`, `i_e`, `i_d`, and shock processes, but no paper-side equation was sourced solely from the `.mod`.
- Dynare was not run.

## Deferred Issues

- Source-level PDF review is needed for the corrupted Appendix A formulas before any `draft_extracted` or reviewed status.
- A complete nonlinear steady-state derivation is deferred; the paper provides calibrated ratios and the implementation uses `model(linear)`.
- Runtime validation, BK checks, and equation-count checks against a runnable `.mod` are deferred to a future phase.

## Translation Status

- English derivation was drafted first.
- Chinese derivation was translated second and preserves the same section order, equation numbers, file paths, DOI, and `needs_review` markers.
