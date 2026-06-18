# US_PM08 - Derivation (Small Quarterly Projection Model)

> Archive status: `needs_review`. This first-pass derivation is based on the MinerU Markdown and targeted PDF text checks. Dynare runtime validation was not performed.

Provenance: `US_PM08`, Carabenciov, Ermolaev, Freedman, Juillard, Kamenik, Korshunov, and Laxton (2008), "A small quarterly projection model of the US economy," IMF Working Paper 08/278, DOI `10.5089/9781451871364.001`. Source Markdown: `raw/mmb_mineru/runs/gpm6_imf13_us_pm08_us_pm08fl__a_small_quarterly_projection_model_of_the_us_economy__a2e8676b/full.md`.

## 1. Model Overview

- **Model**: A small quarterly projection model for the U.S. economy in the IMF Global Projection Model family.
- **Purpose**: Bayesian-estimated semi-structural forecasting and policy-analysis model for output, inflation, unemployment, the federal funds rate, equilibrium real rates, and financial-real linkages.
- **Agents and blocks**: The model is not a micro-founded household-firm DSGE model. It is organized around behavioral equations for the output gap, inflation, monetary policy, Okun's law, latent potential output, NAIRU, equilibrium real rate, and bank-lending-tightening conditions.
- **Variant boundary**: The paper first gives a benchmark model without financial-real linkages and then extends it with the BLT variable. The `US_PM08` MMB implementation is a stationary `model(linear)` version with the BLT shock-lag effect represented directly, so this entry records the BLT-inclusive version and notes where the benchmark equation is nested by setting the BLT term to zero.
- **Form**: Linear/stationary gap model, represented in MMB as `model(linear)`. Levels such as potential output and NAIRU are described in the paper, while the implementation cross-check uses stationary deviations/gaps.

## 2. Optimization Problems

This is a small semi-structural projection model. The paper does not state household, firm, bank, or government optimization problems from which the equations are derived. Instead:

- aggregate demand is governed by a hybrid forward/backward output-gap relation;
- inflation is governed by a hybrid Phillips-curve relation;
- monetary policy is governed by a Taylor-type interest-rate rule with smoothing;
- unemployment follows a dynamic Okun-law relation;
- potential output, NAIRU, equilibrium real rates, and BLT equilibrium components follow stochastic trend/gap processes.

`needs_review`: No optimization problem is inferred beyond the paper's behavioral equations.

## 3. First-Order Conditions

Because the source is semi-structural, this section records behavioral conditions rather than FOCs from explicit optimization.

- **(F1) Output gap / aggregate demand, benchmark form**:

$$
y_t = \beta_1 y_{t-1} + \beta_2 y_{t+1} - \beta_3 rrgap_{t-1} + \varepsilon_t^y .
$$

- **(F2) Output gap with financial-real linkage**:

$$
y_t = \beta_1 y_{t-1} + \beta_2 y_{t+1} - \beta_3 rrgap_{t-1} - \theta \eta_t + \varepsilon_t^y .
$$

The benchmark model is nested when the BLT distributed-lag component is absent or has zero loading.

- **(F3) Inflation equation**:

$$
\pi_t = \lambda_1 \pi4_{t+4} + (1-\lambda_1)\pi4_{t-1} + \lambda_2 y_{t-1} - \varepsilon_t^\pi .
$$

`needs_review`: the paper states the inflation residual with a negative sign; this sign is preserved.

- **(F4) Taylor-type policy rule**:

$$
rs_t = (1-\gamma_1)\left[
\overline{rr}_t + \pi4_{t+3}
+ \gamma_2\left(\pi4_{t+3}-\pi^{tar}\right)
+ \gamma_4 y_t
\right] + \gamma_1 rs_{t-1} + \varepsilon_t^{rs}.
$$

- **(F5) Dynamic Okun's law**:

$$
u_t = \alpha_1 u_{t-1} + \alpha_2 y_t + \varepsilon_t^u .
$$

- **(F6) Bank-lending-tightening equation**:

$$
BLT_t = \overline{BLT}_t - \kappa y_{t+4} + \varepsilon_t^{BLT}.
$$

`needs_review`: targeted PDF text confirms the equation structure, but the overbar on the BLT trend/equilibrium term is OCR-sensitive.

- **(F7) BLT shock distributed lag entering demand**:

$$
\eta_t =
0.04\varepsilon_{t-1}^{BLT}
+0.08\varepsilon_{t-2}^{BLT}
+0.12\varepsilon_{t-3}^{BLT}
+0.16\varepsilon_{t-4}^{BLT}
+0.20\varepsilon_{t-5}^{BLT}
+0.16\varepsilon_{t-6}^{BLT}
+0.12\varepsilon_{t-7}^{BLT}
+0.08\varepsilon_{t-8}^{BLT}
+0.04\varepsilon_{t-9}^{BLT}.
$$

## 4. Market Clearing & Identities

- **(F8) Output gap definition**:

$$
y_t = Y_t - \overline{Y}_t .
$$

The paper defines $Y_t$ and $\overline{Y}_t$ as 100 times the logs of real GDP and potential output, respectively.

- **(F9) Unemployment gap definition**:

$$
u_t = U_t - \overline{U}_t .
$$

- **(F10) Real interest rate definition**:

$$
rr_t = rs_t - \pi_{t+1}.
$$

- **(F11) Real interest rate gap definition**:

$$
rrgap_t = rr_t - \overline{rr}_t .
$$

- **(F12) Year-on-year inflation definition**:

$$
\pi4_t = \frac{\pi_t+\pi_{t-1}+\pi_{t-2}+\pi_{t-3}}{4}.
$$

`needs_review`: the paper defines quarterly annualized inflation and year-on-year inflation from CPI logs; this average is the stationary implementation identity and is consistent with the `.mod` cross-check.

- **(F13) Reporting expectation for four-quarter inflation**:

$$
E4\_\pi4_t = \pi4_{t+4}.
$$

- **(F14) Reporting expectation for next-quarter inflation**:

$$
E1\_\pi_t = \pi_{t+1}.
$$

- **(F15) Reporting expectation for next-period output gap**:

$$
E1\_y_t = y_{t+1}.
$$

## 5. Exogenous Processes

- **(F16) Potential output stochastic trend**:

$$
\overline{Y}_t = \overline{Y}_{t-1} + \frac{g_t^{\overline{Y}}}{4} + \varepsilon_t^{\overline{Y}}.
$$

- **(F17) Potential output growth process**:

$$
g_t^{\overline{Y}} = \tau g^{\overline{Y},ss} + (1-\tau)g_{t-1}^{\overline{Y}} + \varepsilon_t^{g^{\overline{Y}}}.
$$

- **(F18) NAIRU stochastic trend**:

$$
\overline{U}_t = \overline{U}_{t-1} + g_t^{\overline{U}} + \varepsilon_t^{\overline{U}}.
$$

- **(F19) NAIRU growth process**:

$$
g_t^{\overline{U}} = (1-\alpha_3)g_{t-1}^{\overline{U}} + \varepsilon_t^{g^{\overline{U}}}.
$$

- **(F20) Equilibrium real interest rate process**:

$$
\overline{rr}_t = \rho \overline{rr}^{ss} + (1-\rho)\overline{rr}_{t-1} + \varepsilon_t^{\overline{rr}}.
$$

`needs_review`: the MinerU Markdown shows the same structure as the targeted PDF text, but the coefficient placement is visually noisy in PDF extraction.

- **(F21) BLT equilibrium process**:

$$
\overline{BLT}_t = \overline{BLT}_{t-1} + \varepsilon_t^{\overline{BLT}}.
$$

`needs_review`: the Markdown/PDF text around equation 13 loses a subscript on the left-hand side in some extraction output.

The MMB implementation cross-check for `US_PM08` uses exogenous innovations `RES_RR_US_BAR`, `RES_UNR_US_GAP`, `RES_Y_US`, `RES_PIE_US`, `RES_BLT_US`, and `RES_RS_US`; it omits the paper-level stochastic-trend innovations for potential output and NAIRU growth in favor of a stationary implemented state vector.

## 6. Steady-State Solution

The paper is expressed in gaps, growth rates, and annualized rates rather than a nonlinear resource-allocation steady state. For the stationary MMB implementation, the natural deterministic steady state is:

1. Set all innovations to zero.
2. Gap variables satisfy $y=0$, $u=0$, $rrgap=0$, and the reporting expectation variables equal their corresponding leads.
3. Inflation is anchored at the target $\pi4=\pi=\pi^{tar}$ in the non-demeaned paper notation; in the stationary implementation cross-check, `PIE_USh` and `PIE_US4h` are deviations, so their steady states are zero.
4. The equilibrium real rate is at its steady component $\overline{rr}^{ss}$ in the paper notation; in the stationary implementation cross-check, `RR_US_BARh` is a deviation state with zero steady state.
5. The policy rate satisfies $rs=\overline{rr}^{ss}+\pi^{tar}$ in the paper notation, while implemented deviations such as `RS_USh` are zero in steady state.
6. Potential output and NAIRU levels are stochastic trends in the paper and are not pinned down by a finite deterministic level steady state; their stationary deviations are zero.
7. BLT and its equilibrium trend are random-walk components in the paper. The stationary implementation uses the BLT innovation/distributed-lag effect directly, so its implemented steady value is zero.

`needs_review`: A complete steady-state mapping between the paper-level stochastic-trend system and the MMB stationary variables requires review of the replication package conventions.

## 7. Timing & Form Conventions

- **Timing**: Quarterly model. The output-gap equation includes $y_{t+1}$ and lagged $rrgap_{t-1}$. The inflation equation includes $\pi4_{t+4}$ and $\pi4_{t-1}$. The policy rule responds to expected year-on-year inflation three quarters ahead, $\pi4_{t+3}$, and current output gap. The BLT equation uses $y_{t+4}$; the BLT shock affects demand through lags $t-1$ through $t-9$.
- **Stocks**: There is no physical capital stock. Potential output, NAIRU, equilibrium real rate, and BLT equilibrium are latent state/trend variables.
- **Inflation units**: Quarterly inflation is annualized; year-on-year inflation is a four-quarter log difference. The implemented stationary identity uses the average of four quarterly annualized rates.
- **Form**: Linear/stationary `model(linear)`. No nonlinear Dynare execution was performed.
- **Implementation cross-check**: `.agents/skills/dynare-copilot/references/examples/US_PM08_rep.mod` confirms a stationary `model(linear)` block with variables `RR_USh`, `RR_US_BARh`, `UNR_US_GAP`, `PIE_USh`, `PIE_US4h`, `Y_US`, `RS_USh`, expectation-reporting variables, and BLT shock-distribution auxiliaries. This was used only as `implementation_cross_check`.

## 8. Variable & Parameter Reference Table

| Category | Symbol / implementation name | Meaning | Main equation |
|---|---|---|---|
| Endogenous | $y_t$ / `Y_US` | Output gap | (F2), (F8) |
| Endogenous | $u_t$ / `UNR_US_GAP` | Unemployment gap | (F5), (F9) |
| Endogenous | $\pi_t$ / `PIE_USh` | Quarterly annualized inflation | (F3) |
| Endogenous | $\pi4_t$ / `PIE_US4h` | Four-quarter inflation | (F12) |
| Endogenous | $rr_t$ / `RR_USh` | Real interest rate | (F10) |
| Endogenous | $\overline{rr}_t$ / `RR_US_BARh` | Equilibrium real interest rate | (F20) |
| Endogenous | $rrgap_t$ | Real interest rate gap | (F11) |
| Endogenous | $rs_t$ / `RS_USh` | Short-term nominal policy rate | (F4) |
| Endogenous | $\eta_t$ / `E2` | Distributed lag of BLT shocks entering demand | (F7) |
| Endogenous | $BLT_t$ | Bank-lending-tightening variable | (F6) |
| Endogenous | $\overline{BLT}_t$ | Equilibrium BLT component | (F21) |
| Endogenous | $E4\_\pi4_t$ / `E4_PIE_US4h` | Reporting expectation for four-quarter inflation | (F13) |
| Endogenous | $E1\_\pi_t$ / `E1_PIE_USh` | Reporting expectation for next-quarter inflation | (F14) |
| Endogenous | $E1\_y_t$ / `E1_Y_USh` | Reporting expectation for output gap | (F15) |
| Latent/state | $\overline{Y}_t$ | Potential output level | (F16) |
| Latent/state | $g_t^{\overline{Y}}$ | Potential-output growth | (F17) |
| Latent/state | $\overline{U}_t$ | NAIRU level | (F18) |
| Latent/state | $g_t^{\overline{U}}$ | NAIRU growth | (F19) |
| Exogenous innovation | $\varepsilon_t^y$ / `RES_Y_US` | Output-gap shock | (F1), (F2) |
| Exogenous innovation | $\varepsilon_t^\pi$ / `RES_PIE_US` | Inflation shock | (F3) |
| Exogenous innovation | $\varepsilon_t^{rs}$ / `RES_RS_US` | Policy-rate shock | (F4) |
| Exogenous innovation | $\varepsilon_t^u$ / `RES_UNR_US_GAP` | Unemployment-gap shock | (F5) |
| Exogenous innovation | $\varepsilon_t^{BLT}$ / `RES_BLT_US` | BLT shock | (F6), (F7) |
| Exogenous innovation | $\varepsilon_t^{\overline{rr}}$ / `RES_RR_US_BAR` | Equilibrium real-rate shock | (F20) |
| Exogenous innovation | $\varepsilon_t^{\overline{Y}}$ | Potential-output level shock | (F16) |
| Exogenous innovation | $\varepsilon_t^{g^{\overline{Y}}}$ | Potential-output growth shock | (F17) |
| Exogenous innovation | $\varepsilon_t^{\overline{U}}$ | NAIRU level shock | (F18) |
| Exogenous innovation | $\varepsilon_t^{g^{\overline{U}}}$ | NAIRU growth shock | (F19) |
| Exogenous innovation | $\varepsilon_t^{\overline{BLT}}$ | Equilibrium BLT shock | (F21) |
| Parameter | $\alpha_1,\alpha_2,\alpha_3$ / `alpha_us1`, `alpha_us2`, `alpha_us3` | Okun-law and NAIRU-growth parameters | (F5), (F19) |
| Parameter | $\beta_1,\beta_2,\beta_3$ / `beta_us1`, `beta_us2`, `beta_us3` | Output-gap dynamics and real-rate-gap loading | (F1), (F2) |
| Parameter | $\lambda_1,\lambda_2$ / `lambda_us1`, `lambda_us2` | Inflation persistence/forward-looking weight and output-gap slope | (F3) |
| Parameter | $\gamma_1,\gamma_2,\gamma_4$ / `gamma_us1`, `gamma_us2`, `gamma_us4` | Policy smoothing and Taylor-rule responses | (F4) |
| Parameter | $\rho$ / `rho_us` | Equilibrium real-rate persistence/loading convention | (F20) |
| Parameter | $\tau$ / `tau_us` | Potential-output-growth return speed | (F17) |
| Parameter | $\kappa$ / `kappa_us` | Output-gap effect on BLT | (F6) |
| Parameter | $\theta$ / `theta` | BLT distributed-lag loading in demand | (F2), (F7) |
| Parameter | $\pi^{tar}$ / `pietar_us_ss` | Inflation target | (F4) |
| Parameter | $\overline{rr}^{ss}$ / `rr_us_bar_ss` | Steady-state equilibrium real rate | (F20) |
| Parameter | $g^{\overline{Y},ss}$ / `growth_us_ss` | Steady-state potential-output growth | (F17) |
