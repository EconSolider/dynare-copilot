# US_DNGS15_SWpi -- Derivation (Optimization Problems + First-Order Conditions)

> First-pass private archive draft for review. Formula status: `needs_review`; equations are extracted from MinerU Markdown and cross-checked against the Rep-MMB implementation only for coverage and naming, not as paper-side source evidence.

## 1. Model Overview

- **Model ID**: `US_DNGS15_SWpi`.
- **Source paper**: Del Negro, Marco; Giannoni, Marc P.; Schorfheide, Frank (2015), "Inflation in the Great Recession and New Keynesian Models," *American Economic Journal: Macroeconomics* 7(1), 168-196. DOI: `10.1257/mac.20140097`.
- **Main source**: `raw/mmb_mineru/runs/us_dngs15_us_dngs15_sw_us_dngs15_swsp_us_dngs15__infation_in_the_great_recession_and_new_keynesian_models__c8e184ab/full.md`; raw PDF path exists at `raw/mmb_papers/Infation in the Great recession and New Keynesian models.pdf`.
- **Variant**: SWpi variant, described by the implementation cross-check as the Del Negro-Giannoni-Schorfheide model with a time-varying inflation target and without the full financial-frictions net-worth block.
- **Agents and blocks**: representative household with habit formation, final/intermediate goods producers, capital accumulation with investment adjustment costs, variable capital utilization, Calvo price and wage setting with indexation, fiscal spending, monetary policy, drifting inflation target, and flexible-price/wage counterfactual variables.
- **Experiment**: estimated US medium-scale New Keynesian DSGE model for Great Recession inflation forecasts and fundamental-inflation analysis. The Rep-MMB file implements `model(linear)` and first-order simulation; this archive entry does not run Dynare.
- **Model form**: log-linear equilibrium system. All variables in the model equations are log deviations from the nonstochastic steady state unless explicitly marked as steady-state constants.
- **First-pass status**: `needs_review`. The core equations are readable in the Markdown; the source references technical appendix formulas for steady states, which are not present as a separate local normalization file for this model.

## 2. Optimization Problems

The paper states that the SW model is based on Christiano, Eichenbaum, and Evans (2005) and presents log-linearized equilibrium conditions rather than the full nonlinear household, firm, and wage-setter Lagrangians. The following optimization statements are therefore structural reconstructions of the standard SW blocks, with the exact archive equations taken from the paper-side log-linear conditions in Section 3.

### 2.1 Household

The representative household chooses consumption, labor, and nominal bond/deposit positions with external habit in consumption. A generic nonlinear problem consistent with the displayed Euler and wage equations is:

```math
\max_{\{C_t,L_t,B_t\}} E_0 \sum_{t=0}^{\infty} \beta^t
\left[
\frac{(C_t-h C_{t-1})^{1-\sigma_c}}{1-\sigma_c}
- \chi_L \frac{L_t^{1+\nu_l}}{1+\nu_l}
\right]
```

subject to an intertemporal budget constraint with nominal gross interest rate, wage income, profits/transfers, and the preference wedge $`b_t`$ that affects the Euler equation.

### 2.2 Capital and Investment

The capital/investment block chooses investment and installed capital subject to adjustment costs and an investment-specific efficiency shock $`\mu_t`$. In log-linear form the paper gives the investment Euler equation, capital accumulation equation, and return-arbitrage condition. Installed capital $`\bar{k}_t`$ is predetermined for next-period production, and effective capital services $`k_t`$ depend on utilization $`u_t`$.

### 2.3 Goods Producers

Intermediate goods producers rent capital and labor services. Cost minimization gives real marginal cost, capital-labor equalization, and the aggregate production function. The production block includes fixed-cost/markup scaling through $`\Phi_p`$ and a term for linearly detrended productivity when technology is trend stationary.

### 2.4 Price and Wage Setters

Retail price setters and wage setters face Calvo adjustment frictions with indexation. The paper reports the resulting price Phillips curve and wage Phillips curve directly. The household marginal rate of substitution $`w_t^h`$ enters the wage-setting condition.

### 2.5 Monetary Authority

The baseline rule reacts to inflation and the output gap relative to the flexible-price/wage counterfactual. The SWpi variant replaces the constant inflation target with a drifting target $`\pi_t^{\ast}`$; the Rep-MMB cross-check fixes `pist` as a parameter and comments out its shock process, so the time-varying-target law is retained here as paper-side source structure but marked as an implementation difference.

## 3. First-Order Conditions

- **(F1) Detrended productivity level**:

```math
\tilde{z}_t = \rho_z \tilde{z}_{t-1} + \sigma_z \varepsilon_{z,t}.
```

- **(F2) Growth-rate component of the trend**:

```math
z_t = \frac{1}{1-\alpha}(\rho_z-1)\tilde{z}_{t-1}
+ \frac{1}{1-\alpha}\sigma_z \varepsilon_{z,t}.
```

- **(F3) Consumption Euler equation with habit**:

```math
\begin{aligned}
c_t ={}& -\frac{1-h e^{-\gamma}}{\sigma_c(1+h e^{-\gamma})}
\big(R_t-E_t[\pi_{t+1}]+b_t\big)
+\frac{h e^{-\gamma}}{1+h e^{-\gamma}}(c_{t-1}-z_t) \\
&+\frac{1}{1+h e^{-\gamma}}E_t[c_{t+1}+z_{t+1}]
+\frac{\sigma_c-1}{\sigma_c(1+h e^{-\gamma})}
\frac{w_\astl_\ast}{c_\ast}(l_t-E_t[l_{t+1}]).
\end{aligned}
```

- **(F4) Investment Euler equation / Tobin's $`q`$**:

```math
q_t^k = S''e^{2\gamma}(1+\bar{\beta})
\left[
i_t-\frac{1}{1+\bar{\beta}}(i_{t-1}-z_t)
-\frac{\bar{\beta}}{1+\bar{\beta}}E_t[i_{t+1}+z_{t+1}]
-\mu_t
\right].
```

- **(F5) Installed-capital accumulation**:

```math
\bar{k}_t =
\left(1-\frac{i_\ast}{\bar{k}_\ast}\right)(\bar{k}_{t-1}-z_t)
+\frac{i_\ast}{\bar{k}_\ast}i_t
+\frac{i_\ast}{\bar{k}_\ast}S''e^{2\gamma}(1+\bar{\beta})\mu_t.
```

- **(F6) Riskless-return arbitrage without the full financial-frictions block**:

```math
\frac{r_\ast^k}{r_\ast^k+(1-\delta)}E_t[r_{t+1}^k]
+\frac{1-\delta}{r_\ast^k+(1-\delta)}E_t[q_{t+1}^k]
-q_t^k
= R_t+b_t-E_t[\pi_{t+1}].
```

- **(F7) Effective capital services**:

```math
k_t = u_t-z_t+\bar{k}_{t-1}.
```

- **(F8) Utilization condition**:

```math
u_t = \frac{1-\psi}{\psi}r_t^k.
```

- **(F9) Real marginal cost**:

```math
mc_t = w_t+\alpha l_t-\alpha k_t.
```

- **(F10) Common capital-labor ratio condition**:

```math
k_t = w_t-r_t^k+l_t.
```

- **(F11) Aggregate production**:

```math
y_t =
\Phi_p\big(\alpha k_t+(1-\alpha)l_t\big)
+\mathcal{I}\{\rho_z<1\}(\Phi_p-1)\frac{1}{1-\alpha}\tilde{z}_t.
```

- **(F12) Resource constraint**:

```math
y_t =
g_t+\frac{c_\ast}{y_\ast}c_t+\frac{i_\ast}{y_\ast}i_t
+\frac{r_\ast^k k_\ast}{y_\ast}u_t
-\mathcal{I}\{\rho_z<1\}\frac{1}{1-\alpha}\tilde{z}_t.
```

- **(F13) Price Phillips curve**:

```math
\pi_t =
\kappa mc_t
+\frac{\iota_p}{1+\iota_p\bar{\beta}}\pi_{t-1}
+\frac{\bar{\beta}}{1+\iota_p\bar{\beta}}E_t[\pi_{t+1}]
+\lambda_{f,t}.
```

where

```math
\kappa=
\frac{(1-\zeta_p\bar{\beta})(1-\zeta_p)}
{(1+\iota_p\bar{\beta})\zeta_p((\Phi_p-1)\epsilon_p+1)}.
```

- **(F14) Wage Phillips curve**:

```math
\begin{aligned}
w_t ={}&
\frac{(1-\zeta_w\bar{\beta})(1-\zeta_w)}
{(1+\bar{\beta})\zeta_w((\lambda_w-1)\epsilon_w+1)}
\big(w_t^h-w_t\big)
-\frac{1+\iota_w\bar{\beta}}{1+\bar{\beta}}\pi_t \\
&+\frac{1}{1+\bar{\beta}}(w_{t-1}-z_t+\iota_w\pi_{t-1})
+\frac{\bar{\beta}}{1+\bar{\beta}}E_t[w_{t+1}+z_{t+1}+\pi_{t+1}]
+\lambda_{w,t}.
\end{aligned}
```

- **(F15) Household marginal rate of substitution for wage setting**:

```math
w_t^h =
\frac{1}{1-h e^{-\gamma}}
\big(c_t-h e^{-\gamma}c_{t-1}+h e^{-\gamma}z_t\big)
+\nu_l l_t.
```

- **(F16) Monetary policy rule with output gap**:

```math
R_t =
\rho_R R_{t-1}
+(1-\rho_R)\big(\psi_1\pi_t+\psi_2(y_t-y_t^f)\big)
+\psi_3\big((y_t-y_t^f)-(y_{t-1}-y_{t-1}^f)\big)
+r_t^m.
```

- **(F17) Monetary policy rule with drifting inflation target**:

```math
R_t =
\rho_R R_{t-1}
+(1-\rho_R)\big(\psi_1(\pi_t-\pi_t^{\ast})+\psi_2(y_t-y_t^f)\big)
+\psi_3\big((y_t-y_t^f)-(y_{t-1}-y_{t-1}^f)\big)
+r_t^m.
```

- **(F18) Time-varying inflation target process**:

```math
\pi_t^{\ast}=\rho_{\pi^{\ast}}\pi_{t-1}^{\ast}+\sigma_{\pi^{\ast}}\varepsilon_{\pi^{\ast},t}.
```

`needs_review`: the Rep-MMB `US_DNGS15_SWpi_rep.mod` uses `pist` as a fixed parameter and comments out the $`\pi_t^{\ast}`$ shock process, while the paper-side SWpi section defines the process in (F18).

- **(F19) Gross nominal return on capital definition used in the implementation cross-check**:

```math
\tilde{R}_t^k-\pi_t =
\frac{r_\ast^k}{r_\ast^k+(1-\delta)}r_t^k
+\frac{1-\delta}{r_\ast^k+(1-\delta)}q_t^k
-q_{t-1}^k.
```

- **(F20) Spread/arbitrage equation used in the implementation cross-check**:

```math
E_t[\tilde{R}_{t+1}^k]
= R_t-\frac{\sigma_c(1+h e^{-\gamma})}{1-h e^{-\gamma}}b_t+\sigma_{\omega,t}.
```

`needs_review`: (F19)-(F20) appear in the Rep-MMB SWpi file under a "Financial Frictions" comment, but the file states this variant has no financial frictions. They are retained as implementation-cross-check equations, not as evidence that the full entrepreneurial net-worth block is active.

## 4. Market Clearing & Identities

- **(F21) Flexible-price/wage consumption Euler equation**:

```math
\begin{aligned}
c_t^f ={}&
-\frac{1-h e^{-\gamma}}{\sigma_c(1+h e^{-\gamma})}r_t^f+b_t
+\frac{h e^{-\gamma}}{1+h e^{-\gamma}}(c_{t-1}^f-z_t) \\
&+\frac{1}{1+h e^{-\gamma}}E_t[c_{t+1}^f+z_{t+1}]
+\frac{\sigma_c-1}{\sigma_c(1+h e^{-\gamma})}
\frac{w_\astl_\ast}{c_\ast}(l_t^f-E_t[l_{t+1}^f]).
\end{aligned}
```

- **(F22) Flexible-price/wage investment equation**:

```math
q_t^{k,f}=S''e^{2\gamma}(1+\bar{\beta})
\left[
i_t^f-\frac{1}{1+\bar{\beta}}(i_{t-1}^f-z_t)
-\frac{\bar{\beta}}{1+\bar{\beta}}E_t[i_{t+1}^f+z_{t+1}]
-\mu_t
\right].
```

- **(F23) Flexible-price/wage capital accumulation**:

```math
\bar{k}_t^f=
\left(1-\frac{i_\ast}{\bar{k}_\ast}\right)(\bar{k}_{t-1}^f-z_t)
+\frac{i_\ast}{\bar{k}_\ast}i_t^f
+\frac{i_\ast}{\bar{k}_\ast}S''e^{2\gamma}(1+\bar{\beta})\mu_t.
```

- **(F24) Flexible-price/wage effective capital**:

```math
k_t^f=u_t^f-z_t+\bar{k}_{t-1}^f.
```

- **(F25) Flexible-price/wage utilization**:

```math
u_t^f=\frac{1-\psi}{\psi}r_t^{k,f}.
```

- **(F26) Flexible-price/wage marginal-cost normalization**:

```math
w_t^f=-\alpha l_t^f+\alpha k_t^f.
```

- **(F27) Flexible-price/wage capital-labor ratio**:

```math
k_t^f=w_t^f-r_t^{k,f}+l_t^f.
```

- **(F28) Flexible-price/wage production**:

```math
y_t^f=\Phi_p\alpha k_t^f+\Phi_p(1-\alpha)l_t^f
+\frac{\Phi_p-1}{1-\alpha}\tilde{z}_t.
```

- **(F29) Flexible-price/wage resource constraint**:

```math
y_t^f=g_\astg_t+\frac{c_\ast}{y_\ast}c_t^f+\frac{i_\ast}{y_\ast}i_t^f
+\frac{r_\ast^k k_\ast}{y_\ast}u_t^f
-g_\ast\frac{1}{1-\alpha}\tilde{z}_t.
```

- **(F30) Flexible-price/wage labor supply / MRS**:

```math
w_t^f=
\frac{1}{1-h e^{-\gamma}}
\big(c_t^f-h e^{-\gamma}c_{t-1}^f+h e^{-\gamma}z_t\big)
+\nu_l l_t^f.
```

- **(F31) Flexible-price/wage arbitrage condition**:

```math
q_t^{k,f}=
\frac{r_\ast^k}{r_\ast^k+(1-\delta)}E_t[r_{t+1}^{k,f}]
+\frac{1-\delta}{r_\ast^k+(1-\delta)}E_t[q_{t+1}^{k,f}]
-r_t^f
+\frac{\sigma_c(1+h e^{-\gamma})}{1-h e^{-\gamma}}b_t.
```

The output gap used in policy is $`y_t-y_t^f`$. Flexible-price/wage variables are included in the Rep-MMB implementation and in the paper's definition of $`y_t^f`$; they are not a separate welfare model.

## 5. Exogenous Processes

- **(F32) Government spending**:

```math
g_t=\rho_g g_{t-1}+\sigma_g\varepsilon_{g,t}+\eta_{gz}\sigma_z\varepsilon_{z,t}.
```

- **(F33) Preference wedge / intertemporal wedge**:

```math
b_t=\rho_b b_{t-1}+\sigma_b\varepsilon_{b,t}.
```

- **(F34) Marginal efficiency of investment**:

```math
\mu_t=\rho_\mu\mu_{t-1}+\sigma_\mu\varepsilon_{\mu,t}.
```

- **(F35) Price markup shock**:

```math
\lambda_{f,t}=
\rho_{\lambda_f}\lambda_{f,t-1}
+\sigma_{\lambda_f}\varepsilon_{\lambda_f,t}
-\eta_{\lambda_f}\sigma_{\lambda_f}\varepsilon_{\lambda_f,t-1}.
```

- **(F36) Wage markup shock**:

```math
\lambda_{w,t}=
\rho_{\lambda_w}\lambda_{w,t-1}
+\sigma_{\lambda_w}\varepsilon_{\lambda_w,t}
-\eta_{\lambda_w}\sigma_{\lambda_w}\varepsilon_{\lambda_w,t-1}.
```

- **(F37) Monetary-policy residual**:

```math
r_t^m=\rho_{r^m}r_{t-1}^m+\sigma_{r^m}\varepsilon_{r^m,t}.
```

- **(F38) Spread shock retained by the implementation cross-check**:

```math
\sigma_{\omega,t}=\rho_{\sigma_\omega}\sigma_{\omega,t-1}+\sigma_{\sigma_\omega}\varepsilon_{\sigma_\omega,t}.
```

In the Rep-MMB SWpi file, `rho_sigw = 0` and the standard deviation for `psi_sigw` is zero, so this shock is present in the variable list but inactive under the recorded calibration.

## 6. Steady-State Solution

Because the paper presents a log-linear system, the state variables in Sections 3-5 are deviations from the nonstochastic steady state. The paper states that steady-state formulas are provided in the technical appendix of Del Negro and Schorfheide (2013), but no local `docs/mmb_appendix_full_normalizations/US_DNGS15_SWpi.md` file exists.

- **Log-deviation steady state**:

```math
c=i=l=q^k=\bar{k}=y=k=u=mc=w=w^h=z=\tilde{z}=\mu=\lambda_f=\lambda_w=g=b=r^m=0.
```

- **Inflation-target convention**:

```math
\pi=0,\qquad R=0,\qquad \pi^{\ast}=0
```

when the target is represented as a deviation from its mean. The Rep-MMB file instead calibrates `pist = 1.0069` and uses `pi - pist` in the policy rule despite `model(linear)`, which should be reviewed before promotion.

- **Steady-state constants from implementation cross-check**:

The Rep-MMB calibration records `zstar`, `rstar`, `rkstar`, `wstar`, `Lstar`, `kstar`, `kbarstar`, `istar`, `ystar`, `cstar`, and `gstar`. These are implementation constants used to scale the log-linear equations, not newly derived here.

- **Deferred steady-state review**:

`steady_state_quality = partial_from_paper_and_implementation_cross_check`. A reviewed archive entry should check the missing technical appendix or another source-backed normalization before marking the steady-state block complete.

Runtime validation was not performed. No `resid`, `steady`, `check`, or `stoch_simul` command was run.

## 7. Timing & Form Conventions

- **Form**: `model(linear)` log-deviation system.
- **Trend treatment**: nonstationary variables are detrended by $`Z_t`$; $`z_t`$ is the growth-rate component and $`\tilde{z}_t`$ is the linearly detrended log productivity level.
- **Capital timing**: $`\bar{k}_t`$ is installed capital at the end of period $`t`$; production in period $`t`$ uses $`\bar{k}_{t-1}`$ through effective capital $`k_t=u_t-z_t+\bar{k}_{t-1}`$.
- **Forward-looking controls**: consumption, investment, inflation, wages, and asset prices include expected future terms.
- **Policy gap**: the Taylor rule reacts to $`y_t-y_t^f`$, where $`y_t^f`$ is generated by the flexible-price/wage comparison block.
- **Variant caveat**: the paper-side SWpi extension is the drifting inflation target. The available Rep-MMB file also retains an inactive spread-shock equation and fixes `pist`; those items are documented as implementation cross-checks and `needs_review`.

## 8. Variable & Parameter Reference Table

### Endogenous variables

| Symbol | Meaning | Main equation |
|---|---|---|
| `c` | Consumption $`c_t`$ | (F3) |
| `R` | Nominal interest rate deviation $`R_t`$ | (F17) |
| `pi` | Inflation $`\pi_t`$ | (F13) |
| `L` | Labor $`l_t`$ | (F3), (F10), (F15) |
| `qk` | Value of installed capital $`q_t^k`$ | (F4) |
| `i` | Investment $`i_t`$ | (F4), (F5) |
| `Rktil` | Gross nominal return on capital $`\tilde{R}_t^k`$ | (F19), (F20) |
| `rk` | Rental rate of capital $`r_t^k`$ | (F8), (F10), (F19) |
| `kbar` | Installed capital $`\bar{k}_t`$ | (F5) |
| `y` | Output $`y_t`$ | (F11), (F12) |
| `k` | Effective capital $`k_t`$ | (F7) |
| `u` | Utilization $`u_t`$ | (F8) |
| `mc` | Real marginal cost $`mc_t`$ | (F9), (F13) |
| `w` | Real wage $`w_t`$ | (F9), (F14) |
| `wh` | Household MRS wage $`w_t^h`$ | (F15) |
| `z` | Trend-growth component $`z_t`$ | (F2) |
| `ztil` | Detrended productivity $`\tilde{z}_t`$ | (F1) |
| `mu` | MEI shock state $`\mu_t`$ | (F34) |
| `sigw` | Spread/dispersion shock state $`\sigma_{\omega,t}`$ | (F38) |
| `laf` | Price markup shock $`\lambda_{f,t}`$ | (F35) |
| `law` | Wage markup shock $`\lambda_{w,t}`$ | (F36) |
| `g` | Government spending $`g_t`$ | (F32) |
| `b` | Preference/intertemporal wedge $`b_t`$ | (F33) |
| `c_f` | Flexible-price/wage consumption | (F21) |
| `r_f` | Flexible-price/wage real return | (F31) |
| `L_f` | Flexible-price/wage labor | (F21), (F27), (F30) |
| `qk_f` | Flexible-price/wage capital value | (F22), (F31) |
| `i_f` | Flexible-price/wage investment | (F22), (F23) |
| `rk_f` | Flexible-price/wage rental rate | (F25), (F27), (F31) |
| `y_f` | Flexible-price/wage output | (F28), (F29) |
| `k_f` | Flexible-price/wage effective capital | (F24) |
| `u_f` | Flexible-price/wage utilization | (F25) |
| `kbar_f` | Flexible-price/wage installed capital | (F23) |
| `w_f` | Flexible-price/wage wage/MRS | (F26), (F30) |

### Exogenous shocks

| Symbol | Meaning |
|---|---|
| `psi_b` | Innovation to $`b_t`$ |
| `psi_mu` | Innovation to $`\mu_t`$ |
| `psi_z` | Innovation to $`\tilde{z}_t`$ and $`z_t`$ |
| `psi_laf` | Innovation to $`\lambda_{f,t}`$ |
| `psi_law` | Innovation to $`\lambda_{w,t}`$ |
| `psi_sigw` | Innovation to $`\sigma_{\omega,t}`$, inactive in the cross-check calibration |
| `psi_g` | Innovation to $`g_t`$ |
| `psi_pist` | Paper-side innovation to $`\pi_t^{\ast}`$; commented out in the Rep-MMB cross-check |
| `psi_rm` | Paper-side monetary-policy residual innovation; commented out in the Rep-MMB cross-check |

### Parameters

| Symbol | Meaning |
|---|---|
| `alp` | Capital share $`\alpha`$ |
| `zeta_p`, `iota_p`, `epsp` | Price Calvo stickiness, price indexation, price aggregator curvature |
| `zeta_w`, `iota_w`, `epsw` | Wage Calvo stickiness, wage indexation, wage aggregator curvature |
| `del` | Depreciation rate $`\delta`$ |
| `Bigphi` | Fixed-cost/markup production scale $`\Phi_p`$ |
| `s2` | Investment adjustment cost curvature $`S''`$ |
| `h` | Habit parameter |
| `ppsi` | Utilization-cost parameter $`\psi`$ |
| `nu_l` | Labor disutility curvature $`\nu_l`$ |
| `bet` | Discount factor $`\beta`$ |
| `psi1`, `psi2`, `psi3`, `rho` | Policy-rule reaction and smoothing parameters |
| `sigmac` | Relative-risk-aversion parameter $`\sigma_c`$ |
| `rho_g`, `rho_b`, `rho_mu`, `rho_z`, `rho_laf`, `rho_law`, `rho_rm`, `rho_sigw`, `rho_pist` | Shock persistence parameters |
| `eta_gz`, `eta_laf`, `eta_law` | Shock spillover / moving-average coefficients |
| `zstar`, `rkstar`, `rstar`, `wstar`, `Lstar`, `kstar`, `kbarstar`, `istar`, `ystar`, `cstar`, `gstar`, `wl_c`, `pist` | Steady-state constants used to scale the linear model |

Equation count note: (F1)-(F38) include source equations, flexible-price/wage comparison equations, and implementation-cross-check equations. The paper presents the system as log-linearized equilibrium conditions rather than a direct nonlinear FOC-to-variable count.
