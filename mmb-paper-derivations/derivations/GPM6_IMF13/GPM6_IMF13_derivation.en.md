# GPM6_IMF13 - Derivation (source-limited first pass)

> Status: `needs_review`. The indexed paper-side source is a 2008 U.S. small quarterly projection model paper, while the implementation cross-check identifies `GPM6_IMF13` as a six-region 2013 Global Projection Model. This entry records the paper-side equations that are actually supported by the linked source and flags the model/source mismatch as a `source_index_issue`.
>
> Provenance: `raw/mmb_mineru/model_index.csv` row `GPM6_IMF13`; source Markdown `raw/mmb_mineru/runs/gpm6_imf13_us_pm08_us_pm08fl__a_small_quarterly_projection_model_of_the_us_economy__a2e8676b/full.md`; raw PDF `raw/mmb_papers/A small quarterly projection model of the US economy.pdf`; MinerU run `a2e8676b-943b-4810-bcb5-d716951a7fa4`. Optional appendix normalization was not present. Implementation cross-check: `.agents/skills/dynare-copilot/references/examples/GPM6_IMF13_rep.mod`.

## 1. Model Overview

- **Archive model ID**: `GPM6_IMF13`.
- **Indexed paper title**: "A small quarterly projection model of the US economy".
- **Indexed authors/year/DOI**: Carabenciov, Freedman, Garcia-Saltos, Laxton, Kamenik, and Manchev; 2013 in the index row; DOI `10.5089/9781451871364.001`.
- **Source-title issue**: the linked Markdown title page gives "A Small Quarterly Projection Model of the US Economy", prepared by Ioan Carabenciov, Igor Ermolaev, Charles Freedman, Michel Juillard, Ondra Kamenik, Dmitry Korshunov, and Douglas Laxton, December 2008. The same source is also assigned to `US_PM08` and `US_PM08fl`.
- **Implementation cross-check**: the local `.mod` describes `GPM6_IMF13` as "GPM6 - The Global Projection Model with 6 Regions", with regions `EA6`, `EU`, `JA`, `LA6`, `RC6`, and `US`. Those six-region equations are not paper-side source evidence in the linked Markdown.
- **Model family supported by the linked paper**: semi-structural small quarterly projection model for the U.S. economy, with output, unemployment, inflation, policy-rate, latent-potential, NAIRU, equilibrium-real-rate, and optional bank-lending-tightening (`BLT`) blocks.
- **Form**: linear gap/deviation system with forward-looking terms and persistent shocks. In Dynare terms this is a `model(linear)`-style semi-structural model, though the checked implementation file uses a plain `model;` block.

## 2. Optimization Problems

No optimizing household, firm, banking, or fiscal problems are stated in the linked paper-side source. The model is a projection model made of behavioral equations, identities, stochastic trend processes, and estimated policy/financial equations. Therefore this section records no objective functions or constraints.

`needs_review`: a corrected 2013 GPM6 paper source may contain further multi-country structure or derivation details not present in the linked 2008 U.S. paper.

## 3. First-Order Conditions

Because the linked source is semi-structural, the following are behavioral/equilibrium equations rather than FOCs from explicit optimization. They are numbered continuously for archive and future `.mod` cross-checking.

- **(F1) Potential output level**:

```math
\overline{Y}_t = \overline{Y}_{t-1} + \frac{g^{\overline{Y}}_t}{4} + \varepsilon^{\overline{Y}}_t
```

- **(F2) Potential-output growth process**:

```math
g^{\overline{Y}}_t = \tau g^{\overline{Y},ss} + (1-\tau)g^{\overline{Y}}_{t-1} + \varepsilon^{g^{\overline{Y}}}_t
```

- **(F3) NAIRU level**:

```math
\overline{U}_t = \overline{U}_{t-1} + g^{\overline{U}}_t + \varepsilon^{\overline{U}}_t
```

- **(F4) NAIRU-growth process**:

```math
g^{\overline{U}}_t = (1-\alpha_3)g^{\overline{U}}_{t-1} + \varepsilon^{g^{\overline{U}}}_t
```

- **(F5) Output-gap equation, benchmark model**:

```math
y_t = \beta_1 y_{t-1} + \beta_2 y_{t+1} - \beta_3 rrgap_{t-1} + \varepsilon^y_t
```

- **(F6) Inflation equation**:

```math
\pi_t = \lambda_1 \pi4_{t+4} + (1-\lambda_1)\pi4_{t-1} + \lambda_2 y_{t-1} - \varepsilon^\pi_t
```

- **(F7) Taylor-type policy-rate equation**:

```math
rs_t = (1-\gamma_1)\left[\overline{rr}_t + \pi4_{t+3}
+ \gamma_2\left(\pi4_{t+3}-\pi^{tar}\right) + \gamma_4 y_t\right]
+ \gamma_1 rs_{t-1} + \varepsilon^{rs}_t
```

- **(F8) Dynamic Okun equation**:

```math
u_t = \alpha_1 u_{t-1} + \alpha_2 y_t + \varepsilon^u_t
```

- **(F9) Bank-lending-tightening equation in the financial-linkage extension**:

```math
BLT_t = \overline{BLT}_t - \kappa y_{t+4} + \varepsilon^{BLT}_t
```

- **(F10) Output-gap equation with financial linkages**:

```math
y_t = \beta_1 y_{t-1} + \beta_2 y_{t+1} - \beta_3 rrgap_{t-1}
- \theta\eta_t + \varepsilon^y_t
```

`needs_review`: (F9)-(F10) are source-supported for the U.S. financial-linkage extension. Their country-by-country and cross-border use in the six-region `.mod` is implementation-only evidence until a corrected GPM6 paper source is linked.

## 4. Market Clearing & Identities

- **(F11) Real interest rate definition**:

```math
rr_t = rs_t - \pi_{t+1}
```

- **(F12) Real interest-rate gap**:

```math
rrgap_t = rr_t - \overline{rr}_t
```

- **(F13) Bank-lending distributed lag**:

```math
\eta_t = 0.04\varepsilon^{BLT}_{t-1}
+ 0.08\varepsilon^{BLT}_{t-2}
+ 0.12\varepsilon^{BLT}_{t-3}
+ 0.16\varepsilon^{BLT}_{t-4}
+ 0.20\varepsilon^{BLT}_{t-5}
+ 0.16\varepsilon^{BLT}_{t-6}
+ 0.12\varepsilon^{BLT}_{t-7}
+ 0.08\varepsilon^{BLT}_{t-8}
+ 0.04\varepsilon^{BLT}_{t-9}
```

- **(F14) Measurement definitions stated in the source**:

```math
y_t = Y_t-\overline{Y}_t,\qquad
u_t = \overline{U}_t-U_t,\qquad
\pi_t = 400\Delta\log(CPI_t),\qquad
\pi4_t = 100\left[\log(CPI_t)-\log(CPI_{t-4})\right]
```

The checked implementation generalizes identities to six regions: output gap as `LGDP_i-LGDP_BAR_i`, real rates as `RS_i-PIE_i(+1)`, four-quarter inflation averages, real effective exchange-rate measures, and foreign-activity factors. These are recorded only as `implementation_cross_check`.

## 5. Exogenous Processes

- **(F15) Equilibrium real interest rate**:

```math
\overline{rr}_t = \rho\overline{rr}^{ss} + (1-\rho)\overline{rr}_{t-1} + \varepsilon^{\overline{rr}}_t
```

- **(F16) Equilibrium BLT random walk**:

```math
\overline{BLT}_t = \overline{BLT}_{t-1} + \varepsilon^{\overline{BLT}}_t
```

The source also estimates shocks to potential-output level and growth, NAIRU level and growth, output, inflation, unemployment, policy rate, equilibrium real rate, BLT, and equilibrium BLT. It reports two cross correlations in the financial-linkage model: a positive relation between the potential-output-growth shock and output-gap shock, and a positive relation between the potential-output-level shock and inflation shock. Exact covariance-matrix implementation is left `needs_review`.

## 6. Steady-State Solution

The paper-side source is a linearized/gap projection model, so the natural steady state sets gap variables and innovations to zero and anchors trend levels by the latent processes:

1. Set all shocks to zero.
2. Set $`y=0`$, $`u=0`$, $`rrgap=0`$, and $`\eta=0`$.
3. Set $`\pi4=\pi=\pi^{tar}`$ and $`rs=\overline{rr}^{ss}+\pi^{tar}`$.
4. Set $`g^{\overline{Y}}=g^{\overline{Y},ss}`$ and keep $`\overline{Y}`$ on its stochastic trend.
5. Set $`g^{\overline{U}}=0`$ and keep $`\overline{U}`$ constant absent level shocks.
6. Set $`BLT=\overline{BLT}`$ in the financial-linkage block.

Implementation cross-check: the six-region `.mod` uses explicit `steady_state_model` assignments for regional CPI levels, GDP trends, exchange-rate levels, BLT levels, inflation targets, output gaps, and shocks. These values are implementation-side calibration, not paper-side derivation evidence from the linked Markdown.

## 7. Timing & Form Conventions

- **Form**: linear semi-structural projection system with variables measured as rates, log levels, gaps, and trend deviations.
- **Expectations/timing**: output and inflation equations use leads ($`y_{t+1}`$, $`\pi4_{t+4}`$); monetary policy responds to expected year-on-year inflation three quarters ahead ($`\pi4_{t+3}`$); BLT responds to the expected output gap four quarters ahead ($`y_{t+4}`$).
- **Real-rate timing**: the real rate uses the current nominal rate less next-quarter inflation, $`rr_t=rs_t-\pi_{t+1}`$.
- **Financial-lag timing**: the BLT impulse enters output through a nine-quarter hump-shaped distributed lag.
- **No capital stock timing**: the paper-side model has no capital accumulation or household/firm stock variable timing.
- **Six-region timing from implementation only**: the `.mod` uses regional trade/exchange-rate identities, long real-rate weighted averages, foreign-activity factors, and spillover residuals. These require paper-side confirmation.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII name | Meaning | Main equation |
|---|---|---|---|
| Endogenous | `Y`, `LGDP` | 100 times log real GDP / log GDP level | (F14) |
| Endogenous | `Y_BAR`, `LGDP_BAR` | potential output / trend GDP | (F1) |
| Endogenous | `g_Y_BAR`, `G` | potential-output growth | (F2) |
| Endogenous | `y`, `Y_US` | output gap | (F5), (F10), (F14) |
| Endogenous | `U`, `UNR` | unemployment rate | (F14) |
| Endogenous | `U_BAR`, `UNR_BAR` | NAIRU | (F3) |
| Endogenous | `g_U_BAR`, `UNR_G` | NAIRU drift | (F4) |
| Endogenous | `u`, `UNR_GAP` | unemployment gap | (F8), (F14) |
| Endogenous | `pi`, `PIE` | quarterly annualized inflation | (F6), (F14) |
| Endogenous | `pi4`, `PIE4` | year-on-year inflation | (F6), (F7), (F14) |
| Endogenous | `rs`, `RS` | short nominal policy rate | (F7) |
| Endogenous | `rr`, `RR` | real interest rate | (F11) |
| Endogenous | `rr_bar`, `RR_BAR` | equilibrium real interest rate | (F15) |
| Endogenous | `rrgap`, `LRR_GAP` | real-rate gap | (F12) |
| Endogenous | `BLT` | bank lending tightening | (F9) |
| Endogenous | `BLT_BAR` | equilibrium BLT | (F16) |
| Endogenous | `eta`, `E2` | distributed BLT effect | (F13) |
| Exogenous | `eps_Y_BAR`, `RES_LGDP_BAR` | potential-output level shock | (F1) |
| Exogenous | `eps_g_Y_BAR`, `RES_G` | potential-output-growth shock | (F2) |
| Exogenous | `eps_U_BAR`, `RES_UNR_BAR` | NAIRU level shock | (F3) |
| Exogenous | `eps_g_U_BAR`, `RES_UNR_G` | NAIRU-growth shock | (F4) |
| Exogenous | `eps_y`, `RES_Y` | output-gap shock | (F5), (F10) |
| Exogenous | `eps_pi`, `RES_PIE` | inflation shock | (F6) |
| Exogenous | `eps_rs`, `RES_RS` | policy-rate shock | (F7) |
| Exogenous | `eps_rr_bar`, `RES_RR_BAR` | equilibrium-real-rate shock | (F15) |
| Exogenous | `eps_BLT`, `RES_BLT` | BLT shock | (F9), (F13) |
| Exogenous | `eps_BLT_BAR`, `RES_BLT_BAR` | equilibrium-BLT shock | (F16) |
| Parameter | `alpha1`, `alpha2`, `alpha3` | unemployment/NAIRU dynamics | (F4), (F8) |
| Parameter | `beta1`, `beta2`, `beta3` | output-gap dynamics and real-rate response | (F5), (F10) |
| Parameter | `lambda1`, `lambda2` | inflation expectations and gap response | (F6) |
| Parameter | `gamma1`, `gamma2`, `gamma4` | policy smoothing and reaction coefficients | (F7) |
| Parameter | `rho`, `tau` | equilibrium-rate and trend-growth persistence | (F2), (F15) |
| Parameter | `kappa`, `theta` | BLT response and output effect | (F9), (F10), (F13) |
| Parameter | `pi_tar` | inflation target | (F7) |

`implementation_cross_check`: the `GPM6_IMF13_rep.mod` variable list expands the one-country block to six regions and adds exchange-rate levels/gaps (`LZ`, `REER_M`, `REER_T`), foreign activity (`FACT`), long real rates (`LRR`), trade/spillover weights, regional policy targets, and many regional residuals. Because the linked paper is not the six-region GPM6 paper, those details remain `needs_review`.
