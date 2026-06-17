# US_MI07AL Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row for `US_MI07AL` has `mineru_match_status=matched`, `mineru_match_score=1.0000`, `model_title_match_score=1.0000`, and no `model_match_notes`.
- First 80 Markdown lines show the expected title, `Expectations, learning and macroeconomic persistence`, and author, Fabio Milani.
- Raw PDF path exists and was hashed. Per task instruction and skill default, the PDF body was not read.
- No `docs/mmb_appendix_full_normalizations/US_MI07AL.md` file exists.

## Formula Quality

- The main model equations are printed in the Markdown source: modified IS/Euler equation, Phillips curve, policy rule, transformed inflation/output-gap definitions, shock processes, PLM, constant-gain updates, subjective forecast formula, and state-space representation.
- First-pass formula status is `needs_review`.
- `needs_review`: the Markdown forecast formula uses $I_5$ while $Z_t=[\pi_t,x_t,i_t]'$ is defined as three-dimensional. This may refer to the augmented five-dimensional state including $u_t$ and $r_t^n$, but the dimensioning should be source-checked.
- `needs_review`: the paper reports reduced-form log-linear equilibrium conditions, not the full nonlinear household and price-setting FOCs. The derivation states generic optimization problems only as background and treats the source-stated log-linear equations as the core extracted conditions.
- `needs_review`: the state-space matrices $A_t$, $F_t$, $G_t$, and $H$ are not printed in the Markdown and were not reconstructed.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/US_MI07AL_rep.mod` does not exist.
- `raw/mmb/mmci-cli/models/US_MI07AL/US_MI07AL.mod` exists and was read only as `implementation_cross_check`.
- The implementation confirms a `model(linear)` structure with core variables `i`, `pi`, `pi_tilde`, `x`, `x_tilde`, `r_n`, and `u`.
- The implementation adds Modelbase reporting variables and policy-rule aliases: `interest`, `inflation`, `inflationq`, `inflationql`, `inflationql2`, `inflationqls`, `outputgap`, and `output`.
- The implementation uses `interest_` for the Modelbase monetary-policy shock and retains `v_r`, `v_u` as structural shock innovations.
- Dynare was not run.

## Deferred Issues

- Source-check the dimension and notation of the subjective forecast formula (paper Eq. 11).
- Recover or verify the entries of the state-space matrices if a reviewed implementation-level derivation later requires them.
- Decide how to present the MMB policy-rule substitution relative to the paper's simple Taylor rule in a future reviewed archive pass.
- Confirm initial learning beliefs and pre-sample initialization if this entry is extended from derivation extraction to replication.

## Translation Status

- English derivation was written first.
- Chinese derivation is a direct translation of the English core and preserves `(F#)` numbering, paths, DOI values, model id, and `needs_review` markers.
