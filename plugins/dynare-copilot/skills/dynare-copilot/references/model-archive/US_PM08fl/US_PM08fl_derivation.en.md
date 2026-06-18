# US_PM08fl -- Derivation (Semi-Structural Projection Model)

> Archive status: needs_review. This first-pass derivation is extracted from the MinerU Markdown for Carabenciov et al. (2008), "A small quarterly projection model of the US economy," IMF Working Paper 08/278, DOI 10.5089/9781451871364.001. The `.mod` file was used only as an implementation_cross_check for the stationarized financial-linkages variant.

## 1. Model Overview

- **Model**: US_PM08fl, the financial-real-linkages version of the small quarterly projection model of the U.S. economy.
- **Source**: Carabenciov, Ermolaev, Freedman, Juillard, Kamenik, Korshunov, and Laxton (2008), IMF Working Paper 08/278.
- **Purpose**: a Bayesian-estimated forecasting and policy-analysis model for output, unemployment, inflation, the federal funds rate, equilibrium real rates, and bank lending tightness.
- **Agents and blocks**: this is not a micro-founded optimization DSGE. It is a semi-structural gap model with stochastic trend blocks, behavioral output/inflation/policy/unemployment equations, and a financial-real-linkage proxy based on bank lending tightening (BLT).
- **Form**: linear/stationarized gap form. The MMB implementation uses `model(linear)`, confirmed only as implementation_cross_check. Most variables are percentage-point gaps, annualized rates, or deviations from equilibrium values.
- **Runtime validation**: not performed; Dynare was not run.

## 2. Optimization Problems

No explicit household, firm, bank, or government optimization problem is provided in the paper for this MMB model. The source describes a small quarterly projection model with reduced-form behavioral equations and stochastic equilibrium processes.

The operative "problems" are therefore policy/measurement relationships rather than private optimization:

- potential output and NAIRU are latent stochastic equilibrium concepts;
- aggregate demand is a forward/backward-looking output-gap relation;
- inflation is a hybrid Phillips-curve relation;
- the monetary authority follows a Taylor-type short-rate rule;
- BLT is a survey-based proxy for financial-real linkages.

Because there are no source-stated optimization problems, all equilibrium conditions below are classified as behavioral equations, definitions, identities, or exogenous/stochastic processes.

## 3. First-Order Conditions

No first-order conditions are source-stated. The paper's model equations are not derived from explicit optimization. For archive continuity, this section records the behavioral conditions that play the role of dynamic model equations.

**(F1) Output-gap equation with financial-real linkages**:

```math
y_t
= \beta_1 y_{t-1}
+ \beta_2 y_{t+1}
- \beta_3 rrgap_{t-1}
- \theta \eta_t
+ \varepsilon_t^y .
```

This is equation (14) in the source. It extends the benchmark output-gap equation by adding the distributed BLT shock term $`\eta_t`$.

**(F2) Inflation equation**:

```math
\pi_t
= \lambda_1 \pi4_{t+4}
+ (1-\lambda_1)\pi4_{t-1}
+ \lambda_2 y_{t-1}
- \varepsilon_t^\pi .
```

This is equation (9) in the source. The negative sign on $`\varepsilon_t^\pi`$ is source-stated; a positive residual is interpreted as downward pressure on inflation. needs_review: the OCR text around inflation symbols contains corrupted characters, but the displayed equation is readable.

**(F3) Monetary policy rule**:

```math
rs_t
= (1-\gamma_1)
\left[
\overline{rr}_t
+ \pi4_{t+3}
+ \gamma_2\left(\pi4_{t+3}-\pi^{tar}\right)
+ \gamma_4 y_t
\right]
+ \gamma_1 rs_{t-1}
+ \varepsilon_t^{rs}.
```

This is equation (10) in the source. The rule targets the equilibrium nominal rate implied by the equilibrium real rate and expected year-on-year inflation, with smoothing and responses to inflation-target and output gaps.

**(F4) Dynamic Okun's-law unemployment gap**:

```math
u_t
= \alpha_1 u_{t-1}
+ \alpha_2 y_t
+ \varepsilon_t^u .
```

This is equation (11) in the source. The paper says this equation mainly helps measure the output gap in real time rather than being a fundamental structural block.

## 4. Market Clearing & Identities

The model has no explicit goods, labor, asset, or government budget clearing conditions. Its accounting relationships are measurement identities for gaps and rates.

**(F5) Output gap definition**:

```math
y_t = Y_t - \overline{Y}_t .
```

The source text defines $`Y`$ as 100 times log real GDP and $`\overline{Y}`$ as 100 times log potential output; OCR renders the printed relation poorly. needs_review: the Markdown line shows a damaged expression, so this identity is normalized from the surrounding definition.

**(F6) Unemployment gap definition**:

```math
u_t = U_t - \overline{U}_t .
```

The source defines the unemployment gap as the difference between actual unemployment and equilibrium unemployment/NAIRU.

**(F7) Real interest rate definition**:

```math
rr_t = rs_t - \pi_{t+1}.
```

This is equation (5) in the source.

**(F8) Real interest rate gap definition**:

```math
rrgap_t = rr_t - \overline{rr}_t .
```

This is equation (6) in the source.

**(F9) Year-on-year inflation identity**:

```math
\pi4_t = \frac{\pi_t+\pi_{t-1}+\pi_{t-2}+\pi_{t-3}}{4}.
```

The source defines quarterly inflation at annual rates and year-on-year inflation from the CPI level. The MMB implementation gives this exact stationarized identity; use is recorded as implementation_cross_check, not as an independent paper-side source.

## 5. Exogenous Processes

**(F10) Potential output level**:

```math
\overline{Y}_t
= \overline{Y}_{t-1}
+ \frac{g_t^{\overline{Y}}}{4}
+ \varepsilon_t^{\overline{Y}} .
```

This is equation (1) in the source.

**(F11) Potential output growth**:

```math
g_t^{\overline{Y}}
= \tau g^{\overline{Y}ss}
+ (1-\tau) g_{t-1}^{\overline{Y}}
+ \varepsilon_t^{g^{\overline{Y}}}.
```

This is equation (2) in the source.

**(F12) Equilibrium unemployment/NAIRU level**:

```math
\overline{U}_t
= \overline{U}_{t-1}
+ g_t^{\overline{U}}
+ \varepsilon_t^{\overline{U}} .
```

This is equation (3) in the source.

**(F13) Equilibrium unemployment/NAIRU growth**:

```math
g_t^{\overline{U}}
= (1-\alpha_3)g_{t-1}^{\overline{U}}
+ \varepsilon_t^{g^{\overline{U}}}.
```

This is equation (4) in the source.

**(F14) Equilibrium real interest rate**:

```math
\overline{rr}_t
= \rho \overline{rr}^{ss}
+ (1-\rho)\overline{rr}_{t-1}
+ \varepsilon_t^{\overline{rr}} .
```

This is equation (7) in the source. needs_review: the source prose says it can diverge from steady state in response to shocks, but the persistence weights differ from a more common $`(1-\rho)\overline{rr}^{ss}+\rho\overline{rr}_{t-1}`$ convention. The MMB implementation uses the printed equation's unusual ordering.

**(F15) Bank lending tightening equation**:

```math
BLT_t
= \overline{BLT}_t
- \kappa y_{t+4}
+ \varepsilon_t^{BLT}.
```

This is equation (12) in the source.

**(F16) Equilibrium BLT random walk**:

```math
\overline{BLT}_t
= \overline{BLT}_{t-1}
+ \varepsilon_t^{\overline{BLT}} .
```

This is equation (13) in the source. needs_review: the OCR equation omits the left-hand time subscript in one place, but the intended random walk is clear from the prose and implementation.

**(F17) Distributed BLT shock index**:

```math
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
```

This is equation (15) in the source. The hump-shaped weights are source-stated.

**(F18) Cross-correlation structure**:

```math
\operatorname{corr}\!\left(\varepsilon_t^{g^{\overline{Y}}},\varepsilon_t^y\right)>0,
\qquad
\operatorname{corr}\!\left(\varepsilon_t^{\overline{Y}},\varepsilon_t^\pi\right)>0 .
```

The source states two positive cross correlations in the BLT model. The posterior modes reported in Table 6 are approximately 0.1944 and 0.0422, respectively.

## 6. Steady-State Solution

The model is linear/stationarized in the MMB implementation. The steady state for hatted/gap variables is zero unless a variable is defined as a steady-state level or target.

Sequential steady-state conventions:

1. Set all structural shocks to zero: $`\varepsilon_t^j=0`$ for each innovation.
2. Set gap variables to zero: $`y=0`$, $`u=0`$, $`rrgap=0`$, $`\eta=0`$, and the implementation's hatted variables $`RR\_USh`$, $`RR\_US\_BARh`$, $`PIE\_USh`$, $`PIE\_US4h`$, $`Y\_US`$, and $`RS\_USh`$ are zero.
3. Potential output growth converges to $`g^{\overline{Y}ss}`$ under (F11).
4. Equilibrium unemployment growth converges to zero under (F13).
5. The equilibrium real rate is anchored by $`\overline{rr}^{ss}`$ in levels; in stationary deviations, $`\overline{rr}`$ is zero.
6. The inflation target is $`\pi^{tar}`$ in levels; in stationary deviations, inflation variables are zero.
7. The equilibrium BLT level is a random walk in the source model. For the stationarized implementation, the innovation representation sets the reported BLT shock state to zero in steady state.

needs_review: the paper reports posterior modes and shock standard deviations, not a full deterministic steady-state algorithm for the original level model. Runtime steady-state validation was not performed.

## 7. Timing & Form Conventions

- **Form**: linear/stationarized gap model; the implementation uses `model(linear)`.
- **Expectations and leads**: the output gap depends on $`y_{t+1}`$; inflation depends on $`\pi4_{t+4}`$; monetary policy depends on $`\pi4_{t+3}`$; BLT depends on expected output conditions $`y_{t+4}`$.
- **Lags**: demand uses $`y_{t-1}`$ and $`rrgap_{t-1}`$; unemployment uses $`u_{t-1}`$; inflation uses $`\pi4_{t-1}`$ and $`y_{t-1}`$; monetary policy smooths with $`rs_{t-1}`$.
- **Distributed financial effect**: $`\eta_t`$ is a nine-quarter weighted lag polynomial in the BLT innovation, peaking at $`t-5`$.
- **Stock variables**: there is no physical capital or net-worth stock in this semi-structural entry. Latent equilibrium levels $`\overline{Y}_t`$, $`\overline{U}_t`$, $`\overline{rr}_t`$, and $`\overline{BLT}_t`$ are predetermined stochastic states.
- **Annualization**: quarterly inflation $`\pi_t`$ is annualized; $`\pi4_t`$ is the four-quarter average of quarterly annualized inflation in the implementation.
- **Implementation cross-check**: `US_PM08fl_rep.mod` implements a reduced stationarized subset with BLT innovation `E = RES_BLT_US`, output effect `E2`, and no explicit level equations for potential output, NAIRU, or BLT level.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Determined by |
|---|---|---|---|
| Endogenous | $`y_t`$ / `Y_US` | Output gap | (F1), (F5) |
| Endogenous | $`\pi_t`$ / `PIE_USh` | Quarterly inflation, annualized | (F2) |
| Endogenous | $`rs_t`$ / `RS_USh` | Short nominal/policy rate | (F3) |
| Endogenous | $`u_t`$ / `UNR_US_GAP` | Unemployment gap | (F4), (F6) |
| Endogenous | $`rr_t`$ / `RR_USh` | Real interest rate | (F7) |
| Endogenous | $`rrgap_t`$ | Real interest rate gap | (F8) |
| Endogenous | $`\pi4_t`$ / `PIE_US4h` | Year-on-year inflation measure | (F9) |
| Endogenous | $`\overline{Y}_t`$ | Potential output level | (F10) |
| Endogenous | $`g_t^{\overline{Y}}`$ | Potential output growth | (F11) |
| Endogenous | $`\overline{U}_t`$ | Equilibrium unemployment / NAIRU | (F12) |
| Endogenous | $`g_t^{\overline{U}}`$ | NAIRU growth component | (F13) |
| Endogenous | $`\overline{rr}_t`$ / `RR_US_BARh` | Equilibrium real interest rate | (F14) |
| Endogenous | $`BLT_t`$ | Bank lending tightening index | (F15) |
| Endogenous | $`\overline{BLT}_t`$ | Equilibrium BLT level | (F16) |
| Endogenous | $`\eta_t`$ / `E2` | Distributed BLT innovation effect | (F17) |
| Endogenous | `E` | BLT innovation state in implementation | implementation_cross_check |
| Endogenous | `E4_PIE_US4h` | Reporting expectation $`\pi4_{t+4}`$ | implementation_cross_check |
| Endogenous | `E1_PIE_USh` | Reporting expectation $`\pi_{t+1}`$ | implementation_cross_check |
| Endogenous | `E1_Y_USh` | Reporting expectation $`y_{t+1}`$ | implementation_cross_check |
| Exogenous | $`\varepsilon_t^{\overline{rr}}`$ / `RES_RR_US_BAR` | Equilibrium real-rate shock | (F14) |
| Exogenous | $`\varepsilon_t^u`$ / `RES_UNR_US_GAP` | Unemployment-gap shock | (F4) |
| Exogenous | $`\varepsilon_t^y`$ / `RES_Y_US` | Output-gap shock | (F1) |
| Exogenous | $`\varepsilon_t^\pi`$ / `RES_PIE_US` | Inflation shock | (F2) |
| Exogenous | $`\varepsilon_t^{BLT}`$ / `RES_BLT_US` | BLT shock | (F15), (F17) |
| Exogenous | $`\varepsilon_t^{rs}`$ / `RES_RS_US` | Monetary-policy shock | (F3) |
| Exogenous | $`\varepsilon_t^{\overline{Y}}`$ | Potential-output level shock | (F10) |
| Exogenous | $`\varepsilon_t^{g^{\overline{Y}}}`$ | Potential-growth shock | (F11) |
| Exogenous | $`\varepsilon_t^{\overline{U}}`$ | NAIRU level shock | (F12) |
| Exogenous | $`\varepsilon_t^{g^{\overline{U}}}`$ | NAIRU-growth shock | (F13) |
| Exogenous | $`\varepsilon_t^{\overline{BLT}}`$ | Equilibrium BLT shock | (F16) |
| Parameter | $`\alpha_1`$, `alpha_us1` | Unemployment-gap persistence | (F4) |
| Parameter | $`\alpha_2`$, `alpha_us2` | Okun response to output gap | (F4) |
| Parameter | $`\alpha_3`$, `alpha_us3` | NAIRU-growth persistence complement | (F13) |
| Parameter | $`\rho`$, `rho_us` | Equilibrium real-rate persistence/weight | (F14) |
| Parameter | $`\overline{rr}^{ss}`$, `rr_us_bar_ss` | Steady-state equilibrium real rate | (F14) |
| Parameter | $`\tau`$, `tau_us` | Potential-growth convergence weight | (F11) |
| Parameter | $`g^{\overline{Y}ss}`$, `growth_us_ss` | Steady-state potential output growth | (F11) |
| Parameter | $`\beta_1`$, `beta_us1` | Output-gap lag coefficient | (F1) |
| Parameter | $`\beta_2`$, `beta_us2` | Output-gap lead coefficient | (F1) |
| Parameter | $`\beta_3`$, `beta_us3` | Real-rate-gap demand coefficient | (F1) |
| Parameter | $`\lambda_1`$, `lambda_us1` | Inflation forward/backward weight | (F2) |
| Parameter | $`\lambda_2`$, `lambda_us2` | Phillips-curve output-gap coefficient | (F2) |
| Parameter | $`\gamma_1`$, `gamma_us1` | Monetary-policy smoothing | (F3) |
| Parameter | $`\gamma_2`$, `gamma_us2` | Inflation-gap policy response | (F3) |
| Parameter | $`\gamma_4`$, `gamma_us4` | Output-gap policy response | (F3) |
| Parameter | $`\pi^{tar}`$, `pietar_us_ss` | Inflation target | (F3) |
| Parameter | $`\kappa`$, `kappa_us` | BLT response to future output | (F15) |
| Parameter | $`\theta`$, `theta` | Output effect of $`\eta_t`$ | (F1), (F17) |

The MMB implementation contains 11 endogenous variables and 6 exogenous innovations after stationarization; the paper-side full conceptual system above includes additional latent levels/growth states and shocks.
