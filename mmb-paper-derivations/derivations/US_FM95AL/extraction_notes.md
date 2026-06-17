# US_FM95AL Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` maps `US_FM95AL` to Fuhrer and Moore (1995), "Inflation persistence," DOI `10.2307/2118513`.
- Title/author sniff from the first Markdown page matched the index row: `Inflation Persistence`, Jeff Fuhrer and George Moore, *Quarterly Journal of Economics* 110(1), 127-159.
- Raw PDF exists at `raw/mmb_papers/Inflation persistence.pdf`. It was not opened because the main model equations were legible in MinerU Markdown.

## Formula Quality

- Main theoretical equations (paper equations 1-8), empirical contract equations (9-18), Phillips-curve representation (19-25), policy experiment rule (26), and solution representation (27-31) were visible in Markdown.
- The entry is marked `needs_review` rather than `draft_extracted` because the exact mapping from paper-side reduced-form VAR equations for the bill rate/output gap to the local MMB policy-rule interface is not fully paper-side provenance.
- No long prose from the paper was copied into the derivation.

## Implementation Cross-Check

- Local implementation inspected: `raw/mmb/mmci-cli/models/US_FM95AL/US_FM95AL.mod`.
- Dynare was not run.
- The `.mod` confirms `model(linear)`, four contract weights `f0`-`f3`, variables `p`, `x`, `ytilde`, `ypsilon`, `infl`, `rho`, `f`, shocks `epsilon_p`, `epsilon_y`, and the MMB policy shock `interest_`.
- The `.mod` uses `z = x - p` and a weighted index `ypsilon`, matching the paper's relative real contract-price structure.
- Parameters in the MMB implementation are implementation-side values, not treated as source equations. The paper reports relative-contracting estimates around `s = 0.08225` and `gamma = 0.00435`; the local implementation uses its own MMB calibration values.

## Deferred Issues

- Human review should decide whether to include the local MMB policy-rule interface as part of the archived model definition or keep it as an MMB wrapper around the Fuhrer-Moore contract block.
- Future validation phase should run Dynare only if assigned separately.
- Future source audit may compare a few formulas against the PDF images, although Markdown quality was adequate for first-pass extraction.

## Translation Status

- English derivation written first.
- Chinese derivation translated from the English core with equation numbering preserved.
- English and Chinese F-number counts were checked.
