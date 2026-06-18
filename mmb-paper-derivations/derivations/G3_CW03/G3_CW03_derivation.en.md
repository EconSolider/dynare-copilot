# G3_CW03 -- Derivation (model equations and first-pass source extraction)

> Archive status: `needs_review`. This first-pass derivation is extracted from the MinerU Markdown of Coenen and Wieland (2003/2002 working paper version). Dynare runtime validation was not performed.

## 1. Model Overview

- **Model**: `G3_CW03`, a three-country semi-structural rational-expectations model of the United States, the euro area, and Japan.
- **Source**: Gunter Coenen and Volker Wieland, "Inflation dynamics and international linkages: A model of the United States, the Euro Area and Japan", ECB Working Paper Series No. 181, September 2002; indexed year 2003; DOI `10.17016/ifdp.2002.0745`.
- **Source files**: `raw/mmb_mineru/runs/g3_cw03__inflation_dynamics_and_international_linkages_a_model_of_the_united_stat__b76bbb9e/full.md`; raw PDF `raw/mmb_papers/Inflation dynamics and international linkages- A model of the United States, the Euro Area and Japan.pdf`.
- **Form**: linear rational-expectations macroeconometric model (`model(linear)` in the implementation cross-check). Variables are gaps, rates, or deviations from target/steady state.
- **Regions**: euro area (`eu`), Japan (`ja`), United States (`us`).
- **Core blocks**: staggered-contract wage/price block, aggregate-demand output-gap block, monetary-policy rule, term structure, long-term real-rate definition, trade-weighted real exchange rates, and bilateral open interest parity.
- **Country-specific supply side**: the euro area and Japan use Taylor-style fixed-duration contracts; the United States uses Fuhrer-Moore relative-real-wage contracts in the final model.

## 2. Optimization Problems

This paper does not present a full DSGE optimization problem for the complete three-country model. It explicitly describes the model as semi-structural on the demand side, with rational expectations for future interest rates, inflation, and exchange rates, while giving priority to empirical fit.

### 2.1 Staggered nominal contracts

The supply-side equations are motivated by overlapping nominal contracts. For Taylor-style contracts, workers or price setters choose a current nominal contract wage/price with reference to expected price levels and expected output gaps over the contract life:

```math
x_t = E_t\left[\sum_{i=0}^{\eta(x)} f_i p_{t+i} + \gamma \sum_{i=0}^{\eta(x)} f_i q_{t+i}\right] + \sigma_{\epsilon_x}\epsilon_{x,t}.
```

For Fuhrer-Moore-style contracts, wage setters compare the implied real wage to overlapping real wage contracts:

```math
x_t - p_t = E_t\left[\sum_{i=0}^{\eta(x)} f_i v_{t+i} + \gamma \sum_{i=0}^{\eta(x)} f_i q_{t+i}\right] + \sigma_{\epsilon_x}\epsilon_{x,t}.
```

### 2.2 Aggregate demand and policy

The demand side is not derived from an explicit household-firm optimization problem in the source. It is an estimated open-economy aggregate-demand equation with lagged output gaps, a lagged long-term real interest rate, and a trade-weighted real exchange rate. Monetary policy is specified by an estimated interest-rate rule.

## 3. First-Order Conditions

The following numbered equations are the equilibrium/dynamic conditions used for the archive draft. They are not all first-order conditions in a strict optimization sense; the source combines overlapping-contract conditions, estimated behavioral equations, identities, and arbitrage conditions.

### 3.1 Generic supply-side contract equations

- **(F1) Taylor contract price/wage aggregator**:

```math
p_t = \sum_{i=0}^{\eta(x)} f_i x_{t-i}, \qquad \sum_{i=0}^{\eta(x)} f_i = 1.
```

- **(F2) Taylor contract wage/price setting**:

```math
x_t = E_t\left[\sum_{i=0}^{\eta(x)} f_i p_{t+i} + \gamma\sum_{i=0}^{\eta(x)} f_i q_{t+i}\right] + \sigma_{\epsilon_x}\epsilon_{x,t}.
```

- **(F3) Fuhrer-Moore real contract wage setting**:

```math
x_t - p_t = E_t\left[\sum_{i=0}^{\eta(x)} f_i v_{t+i} + \gamma\sum_{i=0}^{\eta(x)} f_i q_{t+i}\right] + \sigma_{\epsilon_x}\epsilon_{x,t}.
```

- **(F4) Fuhrer-Moore overlapping real wage index**:

```math
v_t = \sum_{i=0}^{\eta(x)} f_i\left(x_{t-i}-p_{t-i}\right).
```

### 3.2 Country-level linearized supply equations used by `G3_CW03`

For the MMB implementation, the maximum contract length is four quarters. The equations below use the country suffix `j \in \{eu, ja, us\}` where applicable.

- **(F5) Taylor-style contract equation for euro area/Japan**:

```math
cwp_{j,t} =
(f_{1,j}+f_{2,j}+f_{3,j})\pi1_{j,t+1}
+(f_{2,j}+f_{3,j})\pi1_{j,t+2}
+f_{3,j}\pi1_{j,t+3}
+\gamma_j\sum_{i=0}^{3} f_{i,j} q_{j,t+i}
+\sigma_{e\_cw,j}e\_cw_{j,t}.
```

- **(F6) Taylor-style quarterly inflation identity for euro area/Japan**:

```math
\pi1_{j,t} =
\frac{f_{0,j}cwp_{j,t}+f_{1,j}cwp_{j,t-1}+f_{2,j}cwp_{j,t-2}+f_{3,j}cwp_{j,t-3}
-(f_{2,j}+f_{3,j})\pi1_{j,t-1}-f_{3,j}\pi1_{j,t-2}}
{f_{1,j}+f_{2,j}+f_{3,j}}.
```

- **(F7) Fuhrer-Moore contract equation for the United States**:

```math
cwp_{us,t} =
f_{0,us}index_{us,t}+f_{1,us}index_{us,t+1}+f_{2,us}index_{us,t+2}+f_{3,us}index_{us,t+3}
+\gamma_{us}\sum_{i=0}^{3} f_{i,us} q_{us,t+i}
+\sigma_{e\_cw,us}e\_cw_{us,t}.
```

- **(F8) Fuhrer-Moore contract index for the United States**:

```math
index_{us,t}=f_{0,us}cwp_{us,t}+f_{1,us}cwp_{us,t-1}+f_{2,us}cwp_{us,t-2}+f_{3,us}cwp_{us,t-3}.
```

- **(F9) U.S. quarterly inflation identity**:

```math
\pi1_{us,t} =
\frac{f_{0,us}cwp_{us,t}+f_{1,us}cwp_{us,t-1}+f_{2,us}cwp_{us,t-2}+f_{3,us}cwp_{us,t-3}
-(f_{2,us}+f_{3,us})\pi1_{us,t-1}-f_{3,us}\pi1_{us,t-2}}
{f_{1,us}+f_{2,us}+f_{3,us}}.
```

## 4. Market Clearing & Identities

- **(F10) Four-quarter inflation**:

```math
\pi4_{j,t}=\pi1_{j,t}+\pi1_{j,t-1}+\pi1_{j,t-2}+\pi1_{j,t-3}.
```

- **(F11) Aggregate demand / output-gap dynamics**:

```math
q_{j,t}=\delta_{1,j}q_{j,t-1}+\delta_{2,j}q_{j,t-2}+\delta_{3,j}q_{j,t-3}
+\delta_{4,j}(rl_{j,t-1}-\bar{r}_{l,j})
+\delta_{5,j}reer_{j,t}
+\sigma_{e\_d,j}e\_d_{j,t}.
```

For Japan, the source and implementation set the second and third output-gap lag coefficients to zero.

- **(F12) Short-term nominal interest-rate rule**:

```math
is_{j,t}=(1-\rho_j)(\bar{r}_{l,j}+\pi4_{j,t})
+\rho_j is_{j,t-1}
+\alpha_j(\pi4_{j,t}-\pi^{\ast}_{j})
+\beta_j q_{j,t}.
```

The source's general rule also allows forecast horizons, higher-order interest smoothing, and a monetary-policy shock. The implementation cross-check uses the contemporaneous annual inflation term and no active policy-shock term in the model equation.

- **(F13) Long-term nominal interest rate, 8-quarter maturity**:

```math
il_{j,t}=\frac{1}{8}\sum_{h=0}^{7}is_{j,t+h}, \qquad j\in\{eu,us\}.
```

- **(F14) Long-term nominal interest rate, 12-quarter maturity for Japan**:

```math
il_{ja,t}=\frac{1}{12}\sum_{h=0}^{11}is_{ja,t+h}.
```

- **(F15) Long-term real interest rate, 8-quarter maturity**:

```math
rl_{j,t}=il_{j,t}-\frac{1}{2}\sum_{h=1}^{8}\pi1_{j,t+h}, \qquad j\in\{eu,us\}.
```

- **(F16) Long-term real interest rate, 12-quarter maturity for Japan**:

```math
rl_{ja,t}=il_{ja,t}-\frac{1}{3}\sum_{h=1}^{12}\pi1_{ja,t+h}.
```

- **(F17) Euro-area trade-weighted real exchange rate**:

```math
reer_{eu,t}=w_{eu,ja}rer_{euja,t}+w_{eu,us}rer_{euus,t}.
```

- **(F18) Japanese trade-weighted real exchange rate**:

```math
reer_{ja,t}=-w_{ja,eu}rer_{euja,t}+w_{ja,us}rer_{jaus,t}.
```

- **(F19) U.S. trade-weighted real exchange rate**:

```math
reer_{us,t}=-w_{us,eu}rer_{euus,t}-w_{us,ja}rer_{jaus,t}.
```

- **(F20) Euro-area/Japan bilateral real exchange-rate parity**:

```math
rer_{euja,t}=rer_{euja,t+1}+4\pi1_{eu,t+1}-4\pi1_{ja,t+1}-is_{eu,t}+is_{ja,t}.
```

- **(F21) Euro-area/U.S. bilateral real exchange-rate parity**:

```math
rer_{euus,t}=rer_{euus,t+1}+4\pi1_{eu,t+1}-4\pi1_{us,t+1}-is_{eu,t}+is_{us,t}.
```

- **(F22) Japan/U.S. triangular real exchange-rate identity**:

```math
rer_{jaus,t}=rer_{euus,t}-rer_{euja,t}.
```

- **(F23) Constant unit process**:

```math
one_t=one_{t-1}.
```

## 5. Exogenous Processes

- **(F24) Structural innovations**:

```math
e\_d_{j,t},\ e\_cw_{j,t}\ \text{are serially uncorrelated innovations with zero mean,}
```

with country-specific scale parameters in the demand and contract equations. The source's general policy rule includes $`\sigma_{\epsilon_p}\epsilon_{p,t}`$; the MMB implementation declares `interest_` but does not include it in an active model equation.

## 6. Steady-State Solution

Because `G3_CW03` is a linear model in gaps, rates, and deviations, the deterministic steady state is normalized rather than solved from nonlinear household and firm conditions.

1. Set output gaps to zero:

```math
\bar{q}_{eu}=\bar{q}_{ja}=\bar{q}_{us}=0.
```

2. Set contract-wage/price deviations, quarterly inflation deviations, four-quarter inflation deviations, and contract indexes to zero:

```math
\bar{cwp}_j=\bar{\pi1}_j=\bar{\pi4}_j=0,\qquad \bar{index}_{us}=0.
```

3. Set real exchange rates and effective real exchange rates to zero:

```math
\bar{rer}_{euja}=\bar{rer}_{euus}=\bar{rer}_{jaus}=0,\qquad \bar{reer}_j=0.
```

4. Set the unit constant:

```math
\bar{one}=1.
```

5. Compute each country's equilibrium long real rate from the demand intercept normalization:

```math
\bar{r}_{l,j}=-\frac{\delta_{0,j}}{\delta_{4,j}}.
```

In the implementation cross-check, `delta0_j = 0`, so $`\bar{r}_{l,j}=0`$ for all three countries.

6. Set policy targets to zero in deviation form:

```math
\pi^{\ast}_j=0.
```

7. In steady state, `is_j`, `il_j`, and `rl_j` equal their normalized values implied by the policy rule, term structure, and real-rate definition. With the implementation's zero inflation target and zero equilibrium long real rate, these rates are zero in model units.

## 7. Timing & Form Conventions

- **Model form**: `model(linear)`; all equations should be interpreted as linear relations in gaps/rates/deviations, not nonlinear levels.
- **Expectations timing**: forward terms such as $`\pi1_{j,t+h}`$, $`is_{j,t+h}`$, and $`rer_{i,t+1}`$ are rational-expectations forecasts in the source.
- **Output dynamics**: demand responds to lagged output gaps and the lagged long-term real interest-rate gap, giving monetary policy a transmission lag.
- **Term structure timing**: long rates are averages of expected future short rates. The euro area and U.S. blocks use an 8-quarter horizon; Japan uses a 12-quarter horizon.
- **Exchange-rate sign convention**: bilateral real exchange rates are defined in domestic-over-foreign terms in the source; the implementation cross-check uses `rer_euja`, `rer_euus`, and `rer_jaus` with sign conventions embedded in (F17)-(F22).
- **Stock variables**: there are no physical capital or net-worth stock variables in this semi-structural model.
- **Runtime validation**: not performed.

## 8. Variable & Parameter Reference Table

### Endogenous variables

| Category | Symbol / ASCII name | Meaning | Main determining equation |
|---|---|---|---|
| Endogenous | `q_eu`, `q_ja`, `q_us` | Output gaps | (F11) |
| Endogenous | `cwp_eu`, `cwp_ja` | Taylor-style contract wage/price terms | (F5) |
| Endogenous | `cwp_us` | Fuhrer-Moore contract wage/price term | (F7) |
| Endogenous | `index_us` | Fuhrer-Moore contract index | (F8) |
| Endogenous | `pi1_eu`, `pi1_ja` | Quarterly inflation | (F6) |
| Endogenous | `pi1_us` | Quarterly U.S. inflation | (F9) |
| Endogenous | `pi4_eu`, `pi4_ja`, `pi4_us` | Four-quarter inflation | (F10) |
| Endogenous | `is_eu`, `is_ja`, `is_us` | Short-term nominal interest rates | (F12) |
| Endogenous | `il_eu`, `il_us` | 8-quarter long nominal rates | (F13) |
| Endogenous | `il_ja` | 12-quarter long nominal rate | (F14) |
| Endogenous | `rl_eu`, `rl_us` | 8-quarter long real rates | (F15) |
| Endogenous | `rl_ja` | 12-quarter long real rate | (F16) |
| Endogenous | `reer_eu`, `reer_ja`, `reer_us` | Trade-weighted real exchange rates | (F17)-(F19) |
| Endogenous | `rer_euja`, `rer_euus`, `rer_jaus` | Bilateral real exchange rates | (F20)-(F22) |
| Endogenous | `one` | Constant unit process | (F23) |

### Exogenous shocks

| Category | ASCII name | Meaning | Main equation |
|---|---|---|---|
| Exogenous | `e_d_eu`, `e_d_ja`, `e_d_us` | Aggregate-demand innovations | (F11), (F24) |
| Exogenous | `e_cw_eu`, `e_cw_ja`, `e_cw_us` | Contract wage/price innovations | (F5), (F7), (F24) |
| Exogenous | `interest_` | Declared policy shock in implementation cross-check; not active in model equation | needs_review |

### Parameters

| Category | ASCII name | Meaning |
|---|---|---|
| Parameter | `f0_j`, `f1_j`, `f2_j`, `f3_j` | Contract weights by country |
| Parameter | `gamma_j` | Contract sensitivity to output gap |
| Parameter | `sigma_e_cw_j` | Contract shock scale |
| Parameter | `delta0_j`, `delta1_j`, `delta2_j`, `delta3_j`, `delta4_j`, `delta5_j` | Aggregate-demand intercept and coefficients |
| Parameter | `sigma_e_d_j` | Demand shock scale |
| Parameter | `rho_j` | Interest-rate smoothing coefficient |
| Parameter | `alpha_j` | Inflation response in policy rule |
| Parameter | `beta_j` | Output-gap response in policy rule |
| Parameter | `pitarget_j` | Inflation target in deviation units |
| Parameter | `rlbar_j` | Equilibrium long real rate |
| Parameter | `w_euja`, `w_euus`, `w_jaeu`, `w_jaus`, `w_useu`, `w_usja` | Bilateral trade weights used in effective real exchange rates |

First-pass equation count: (F1)-(F24). Formula quality remains `needs_review` because the source's generic equations, table equations, and MMB implementation use slightly different normalizations for policy shocks, country suffixes, and contract blocks.
