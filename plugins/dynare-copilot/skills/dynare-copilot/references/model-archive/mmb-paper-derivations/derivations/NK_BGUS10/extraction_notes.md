# NK_BGUS10 Extraction Notes

## Source Match

- `raw/mmb_mineru/model_index.csv` row for `NK_BGUS10` is matched with score `1.0000`.
- Primary source title: "Labor markets and monetary policy- A New Keynesian model with unemployment".
- DOI: `10.1257/mac.2.2.1`.
- Raw PDF path exists. The PDF body was not read; extraction used MinerU Markdown.
- No optional appendix normalization file exists at `docs/mmb_appendix_full_normalizations/NK_BGUS10.md`.

## Formula Quality

- Core equations were extracted from the paper's model sections and log-linearized equilibrium block, especially equations (24)-(28), plus the US optimized simple policy rule.
- Formula (F2) is marked `needs_review` because MinerU split the paper's marginal-cost equation (25) across two displayed formulas; the derivation normalizes the line break.
- The technology process in the derivation is written as a standard AR(1). The implementation cross-check uses `a = ra*a(-1) - a_`, so shock signs should be reviewed before IRF comparisons.

## Implementation Cross-Check

- `.agents/skills/dynare-copilot/references/examples/NK_BGUS10_rep.mod` confirms:
  - `model(linear)` form;
  - endogenous variables `pi, mc, xhat, c, a, n, uhat, i, xhatf, cf, nf, uhatf, r, y, yf`;
  - one technology innovation `a_`;
  - US/fluid-labor-market calibration with `x_ = 0.7` and `u = 0.05`;
  - optimized simple rule `i = 5*pi - 0.8*uhat` with `rho` added in the paper-side notation.
- Information learned only from the `.mod` file was treated as implementation cross-check, not as independent paper-side source evidence.

## Deferred Issues

- `needs_review`: verify the normalized marginal-cost equation (F2) against the raw PDF if this draft is promoted.
- `needs_review`: confirm whether future archive entries should include the optimal-policy FOCs (paper equations (38)-(39)) or keep the MMB simulation entry focused on the optimized simple rule.
- Runtime validation, Dynare residual checks, BK checks, and IRF replication were not performed.

## Translation Status

- English derivation drafted first.
- Chinese derivation translated from the English derivation.
- English and Chinese files both contain 15 unique `(F#)` equation numbers.
