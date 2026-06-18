# NK_BGEU10 Extraction Notes

## Source Match

- `model_id`: `NK_BGEU10`
- Paper: Blanchard and Gali (2010), "Labor markets and monetary policy: A New Keynesian model with unemployment"
- DOI: `10.1257/mac.2.2.1`
- MinerU run id: `297a65c4-580f-44c8-a1e3-657eb40a7a1f`
- Match status: `matched`
- Model title match score: `1.0000`
- Raw PDF path exists: yes
- Appendix normalization: none found at `docs/mmb_appendix_full_normalizations/NK_BGEU10.md`

## Formula Quality

- Status: `needs_review`
- Core linear equations were extracted from the MinerU Markdown around paper equations (24)-(28), (34), (38)-(39), and the productivity process.
- The derivation intentionally records the nonlinear setup only as background and uses the paper's linearized monetary-policy system as the archived operative model form.
- The coefficient definitions for $`h_0`$ and $`h_F`$ are marked `needs_review`; the OCR is readable but may have dropped grouping around multiplicative factors. A targeted PDF formula check is recommended before this entry is promoted to reviewed.

## Implementation Cross-Check

- Checked `.agents/skills/dynare-copilot/references/examples/NK_BGEU10_rep.mod`.
- Cross-check confirms `model(linear)`, endogenous variables `pi`, `uhat`, `a`, `eta`, `inflation`, exogenous shock `a_`, and Europe calibration values `x=0.25`, `u=0.1`, `B=5/42`, `ra=0.9`.
- The `.mod` file uses `a = ra*a(-1) - a_`, so the named innovation has the opposite sign from a generic productivity innovation.
- The `.mod` file was not used as paper-side mathematical evidence.

## Deferred Issues

- Runtime validation was not performed.
- No PDF body was read; only the path existence was checked.
- A future reviewer should verify coefficient groupings for the exact unemployment Phillips curve against the source PDF.
- Shared `catalog.csv` and `status.csv` were not edited per worker assignment; proposed rows are recorded in `worker_report.json`.

## Translation Status

- English derivation was drafted first.
- Chinese derivation is a matched translation preserving all `(F#)` equation labels and section order.
