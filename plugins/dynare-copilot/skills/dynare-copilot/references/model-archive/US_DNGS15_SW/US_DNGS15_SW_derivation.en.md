# US_DNGS15_SW -- Derivation (Optimization Problems + First-Order Conditions)

> This derivation is for the private MMB model archive. Runtime validation was not performed. Primary paper source: Del Negro, Giannoni, and Schorfheide (2015), "Inflation in the Great Recession and New Keynesian Models," DOI `10.1257/mac.20140097`. Model ID: `US_DNGS15_SW`.

## 1. Model Overview

- **Model**: DNGS15 implementation of the Smets-Wouters (2007) medium-scale New Keynesian model, based on the SW block summarized in Section I.A of Del Negro, Giannoni, and Schorfheide (2015).
- **Source mapping**: `raw/mmb_mineru/model_index.csv` maps `US_DNGS15_SW` to `raw/mmb_mineru/runs/us_dngs15_us_dngs15_sw_us_dngs15_swsp_us_dngs15__infation_in_the_great_recession_and_new_keynesian_models__c8e184ab/full.md`; the first-page sniff matches the title and authors.
- **Agents and blocks**: habit-formation household, investment-adjustment-cost capital/investment block, variable utilization, monopolistically competitive price and wage setters with indexation, central bank with a generalized feedback rule, government spending, and exogenous structural shocks.
- **Model form**: `model(linear)`. The paper states that all variables in the displayed system are log deviations from the nonstochastic steady state, with steady-state values denoted by star subscripts. The Rep-MMB file `.agents/skills/dynare-copilot/references/examples/US_DNGS15_SW_rep.mod` confirms `model(linear)`.
- **Variant note**: the implementation cross-check for `US_DNGS15_SW` includes a spread-style equation with `sigw` but no entrepreneurial net-worth state `n`. The source paper's richer financial-friction block, including net worth, is therefore recorded as a source-side neighboring block and marked `needs_review` for exact variant assignment.

## 2. Optimization Problems

### 2.1 Household

The paper does not restate the full nonlinear household problem, but identifies the SW household block inherited from Christiano, Eichenbaum, and Evans (2005) and Smets-Wouters (2007). The household has external habit in consumption and chooses consumption, labor, and one-period nominal bonds. A compact source-consistent representation is:

```math
\max_{\{C_t,L_t,B_t\}} E_0 \sum_{t=0}^{\infty} \beta^t
\left[
U(C_t-h C_{t-1}) - V(L_t)
\right]
```

subject to a nominal budget constraint with wage income, bond returns, transfers, and profits. The log-linear Euler condition and labor wedge are taken directly from the paper equations below.

### 2.2 Capital And Investment Block

Households own the installed capital used by intermediate firms. Investment transforms consumption goods into installed capital subject to adjustment costs and a marginal efficiency of investment disturbance, producing the log-linear Tobin's-Q condition and capital law of motion in Section 3.

### 2.3 Goods Producers And Price Setters

Intermediate firms rent effective capital and labor, produce with fixed costs/markup parameter $`\Phi_p`$, and face sticky prices with indexation. The log-linear price Phillips curve summarizes the reset-price optimality condition.

### 2.4 Labor Packagers And Wage Setters

Households supply differentiated labor services. Wage setters face Calvo rigidity with indexation, generating the wage Phillips curve. The household marginal rate of substitution between consumption and labor is an input into wage setting.

### 2.5 Monetary Authority And Exogenous Processes

The central bank follows a generalized feedback rule in inflation, the flexible-price output gap, the change in the gap, and a monetary policy residual. The DNGS15 extension replaces the constant inflation target with a persistent time-varying target inflation process.

## 3. First-Order Conditions

All variables below are log deviations unless noted otherwise. The notation follows the paper: $`c_t`$ consumption, $`l_t`$ labor, $`R_t`$ nominal rate, $`\pi_t`$ inflation, $`q_t^k`$ value of capital, $`i_t`$ investment, $`\bar{k}_t`$ installed capital, $`k_t`$ effective capital, $`u_t`$ utilization, $`r_t^k`$ rental rate, $`mc_t`$ marginal cost, $`w_t`$ real wage, and $`w_t^h`$ household MRS wage.

**(F1) Productivity-growth detrending process**:

```math
z_t = \frac{1}{1-\alpha}(\rho_z-1)\tilde z_{t-1}+\frac{1}{1-\alpha}\sigma_z\varepsilon_{z,t}
```

**(F2) Consumption Euler equation with habit and intertemporal wedge**:

```math
c_t =
-\frac{1-h e^{-\gamma}}{\sigma_c(1+h e^{-\gamma})}
\left(R_t-E_t[\pi_{t+1}]+b_t\right)
+\frac{h e^{-\gamma}}{1+h e^{-\gamma}}(c_{t-1}-z_t)
+\frac{1}{1+h e^{-\gamma}}E_t[c_{t+1}+z_{t+1}]
+\frac{\sigma_c-1}{\sigma_c(1+h e^{-\gamma})}\frac{w_\astl_\ast}{c_\ast}
\left(l_t-E_t[l_{t+1}]\right)
```

**(F3) Investment/Tobin's-Q condition**:

```math
q_t^k =
S'' e^{2\gamma}(1+\bar\beta)
\left(
i_t-\frac{1}{1+\bar\beta}(i_{t-1}-z_t)
-\frac{\bar\beta}{1+\bar\beta}E_t[i_{t+1}+z_{t+1}]
-\mu_t
\right)
```

**(F4) Installed capital law of motion**:

```math
\bar{k}_t =
\left(1-\frac{i_\ast}{\bar{k}_\ast}\right)(\bar{k}_{t-1}-z_t)
+\frac{i_\ast}{\bar{k}_\ast}i_t
+\frac{i_\ast}{\bar{k}_\ast}S''e^{2\gamma}(1+\bar\beta)\mu_t
```

**(F5) Baseline SW no-financial-friction capital arbitrage condition**:

```math
\frac{r_\ast^k}{r_\ast^k+(1-\delta)}E_t[r_{t+1}^k]
+\frac{1-\delta}{r_\ast^k+(1-\delta)}E_t[q_{t+1}^k]
-q_t^k
=R_t+b_t-E_t[\pi_{t+1}]
```

**(F6) Effective capital from utilization and predetermined installed capital**:

```math
k_t=u_t-z_t+\bar{k}_{t-1}
```

**(F7) Utilization optimality condition**:

```math
\frac{1-\psi}{\psi}r_t^k=u_t
```

**(F8) Real marginal cost**:

```math
mc_t=w_t+\alpha l_t-\alpha k_t
```

**(F9) Common capital-labor ratio condition**:

```math
k_t=w_t-r_t^k+l_t
```

**(F10) Household marginal rate of substitution wage**:

```math
w_t^h=
\frac{1}{1-h e^{-\gamma}}
\left(c_t-h e^{-\gamma}c_{t-1}+h e^{-\gamma}z_t\right)
+\nu_l l_t
```

**(F11) Price Phillips curve**:

```math
\pi_t =
\kappa mc_t
+\frac{\iota_p}{1+\iota_p\bar\beta}\pi_{t-1}
+\frac{\bar\beta}{1+\iota_p\bar\beta}E_t[\pi_{t+1}]
+\lambda_{f,t}
```

with

```math
\kappa=
\frac{(1-\zeta_p\bar\beta)(1-\zeta_p)}
{(1+\iota_p\bar\beta)\zeta_p((\Phi_p-1)\epsilon_p+1)}
```

**(F12) Wage Phillips curve**:

```math
w_t =
\frac{(1-\zeta_w\bar\beta)(1-\zeta_w)}
{(1+\bar\beta)\zeta_w((\lambda_w-1)\epsilon_w+1)}
(w_t^h-w_t)
-\frac{1+\iota_w\bar\beta}{1+\bar\beta}\pi_t
+\frac{1}{1+\bar\beta}(w_{t-1}-z_t+\iota_w\pi_{t-1})
+\frac{\bar\beta}{1+\bar\beta}E_t[w_{t+1}+z_{t+1}+\pi_{t+1}]
+\lambda_{w,t}
```

**(F13) Financial-spread return condition used by the `US_DNGS15_SW` implementation, needs_review**:

```math
E_t[\tilde R_{t+1}^k-R_t]
=b_t+\tilde\sigma_{\omega,t}
```

This is the source-side financial-spread condition with leverage sensitivity suppressed. The Rep-MMB cross-check implements this variant as a forward equation for `Rktil(+1)` with the intertemporal-wedge term and `sigw`; it does not include net worth `n`.

**(F14) Nominal return on capital definition**:

```math
\tilde R_t^k-\pi_t
=
\frac{r_\ast^k}{r_\ast^k+(1-\delta)}r_t^k
+\frac{1-\delta}{r_\ast^k+(1-\delta)}q_t^k
-q_{t-1}^k
```

## 4. Market Clearing & Identities

**(F15) Production function**:

```math
y_t=
\Phi_p\left(\alpha k_t+(1-\alpha)l_t\right)
+\mathcal I\{\rho_z<1\}(\Phi_p-1)\frac{1}{1-\alpha}\tilde z_t
```

**(F16) Resource constraint**:

```math
y_t=
g_t+\frac{c_\ast}{y_\ast}c_t+\frac{i_\ast}{y_\ast}i_t
+\frac{r_\ast^k k_\ast}{y_\ast}u_t
-\mathcal I\{\rho_z<1\}\frac{1}{1-\alpha}\tilde z_t
```

**(F17) Flexible-price output gap definition**:

```math
x_t=y_t-y_t^f
```

**(F18) Flexible-price comparison system**:

```math
y_t^f=\mathcal F(c_t^f,l_t^f,q_t^{k,f},i_t^f,k_t^f,u_t^f,w_t^f,r_t^{k,f},\tilde z_t,z_t,g_t,b_t,\mu_t)
```

The paper states that $`y_t^f`$ is obtained by solving the version of equations corresponding to the real SW block without nominal rigidities. The implementation cross-check expands this into parallel flexible-price equations; the compact notation above is `needs_review` if equation-by-equation archive coverage is required.

## 5. Exogenous Processes

**(F19) Detrended log productivity**:

```math
\tilde z_t=\rho_z\tilde z_{t-1}+\sigma_z\varepsilon_{z,t}
```

**(F20) Government spending**:

```math
g_t=\rho_g g_{t-1}+\sigma_g\varepsilon_{g,t}+\eta_{gz}\sigma_z\varepsilon_{z,t}
```

**(F21) Intertemporal preference wedge**:

```math
b_t=\rho_b b_{t-1}+\sigma_b\varepsilon_{b,t}
```

**(F22) Marginal efficiency of investment**:

```math
\mu_t=\rho_\mu\mu_{t-1}+\sigma_\mu\varepsilon_{\mu,t}
```

**(F23) Price-markup shock, ARMA(1,1)**:

```math
\lambda_{f,t}=\rho_{\lambda_f}\lambda_{f,t-1}
+\sigma_{\lambda_f}\varepsilon_{\lambda_f,t}
-\eta_{\lambda_f}\sigma_{\lambda_f}\varepsilon_{\lambda_f,t-1}
```

**(F24) Wage-markup shock, ARMA(1,1)**:

```math
\lambda_{w,t}=\rho_{\lambda_w}\lambda_{w,t-1}
+\sigma_{\lambda_w}\varepsilon_{\lambda_w,t}
-\eta_{\lambda_w}\sigma_{\lambda_w}\varepsilon_{\lambda_w,t-1}
```

**(F25) Monetary policy rule with time-varying inflation target**:

```math
R_t=\rho_R R_{t-1}
+(1-\rho_R)\left(\psi_1(\pi_t-\pi_t^{\ast})+\psi_2(y_t-y_t^f)\right)
+\psi_3\left((y_t-y_t^f)-(y_{t-1}-y_{t-1}^f)\right)
+r_t^m
```

**(F26) Monetary policy residual**:

```math
r_t^m=\rho_{r^m}r_{t-1}^m+\sigma_{r^m}\varepsilon_{r^m,t}
```

**(F27) Time-varying inflation target**:

```math
\pi_t^{\ast}=\rho_{\pi^{\ast}}\pi_{t-1}^{\ast}+\sigma_{\pi^{\ast}}\varepsilon_{\pi^{\ast},t}
```

**(F28) Financial-risk/spread shock, needs_review for this variant**:

```math
\tilde\sigma_{\omega,t}=\rho_{\sigma_\omega}\tilde\sigma_{\omega,t-1}
+\sigma_{\sigma_\omega}\varepsilon_{\sigma_\omega,t}
```

In `US_DNGS15_SW_rep.mod`, the corresponding `sigw` innovation has zero standard error and no net-worth state; the shock is retained in the archive because the source paper and implementation name it.

## 6. Steady-State Solution

Because the model is linearized around the nonstochastic steady state, the dynamic variables in Sections 3-5 have zero steady-state log deviations:

```math
c=i=y=l=k=\bar{k}=u=mc=w=w^h=\pi=q^k=r^k=R=b=\mu=g=\lambda_f=\lambda_w=r^m=\pi^{\ast}=\tilde\sigma_\omega=0
```

Steady-state constants are not solved from the Markdown body in this first pass. The paper states that steady-state formulas are provided in the technical appendix of Del Negro and Schorfheide (2013), and the online appendix is not present as a local normalization file for this model. The implementation cross-check records calibrated/implicit steady-state values such as:

```math
\gamma=0.0037,\quad R_\ast=1.0069,\quad r_\ast^k=0.0319,\quad
c_\ast=0.4796,\quad y_\ast=0.7102,\quad i_\ast=0.1028,\quad \bar{k}_\ast=3.5897
```

These values are `implementation_cross_check`, not paper-side derivation evidence.

## 7. Timing & Form Conventions

- **Form**: log-linear `model(linear)`; variables are deviations from the nonstochastic steady state.
- **Growth detrending**: nonstationary variables are detrended by the technology trend $`Z_t`$; $`z_t`$ is the growth rate of $`Z_t`$ in deviation from $`\gamma`$.
- **Capital timing**: $`\bar{k}_{t-1}`$ is predetermined installed capital available for period-$`t`$ production. Effective capital is $`k_t=u_t-z_t+\bar{k}_{t-1}`$.
- **Forward-looking terms**: consumption, investment, capital returns, price inflation, wage inflation, and policy-gap dynamics include expectations or leads.
- **Nominal rigidities**: sticky prices and wages enter through log-linear Phillips curves with indexation.
- **Flexible-price comparison**: $`y_t^f`$ is solved from a parallel flexible-price/wage version of the model and enters the policy rule as the output gap.
- **Runtime validation**: not performed; no Dynare run, residual check, BK check, or IRF generation was executed.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Main equation |
|---|---|---|---|
| Endogenous | `c` / $`c_t`$ | Consumption | (F2) |
| Endogenous | `R` / $`R_t`$ | Nominal policy rate | (F25) |
| Endogenous | `pi` / $`\pi_t`$ | Inflation | (F11) |
| Endogenous | `L` / $`l_t`$ | Labor | (F2), (F10), (F12) |
| Endogenous | `qk` / $`q_t^k`$ | Value of installed capital | (F3), (F14) |
| Endogenous | `i` / $`i_t`$ | Investment | (F3), (F16) |
| Endogenous | `Rktil` / $`\tilde R_t^k`$ | Nominal return on capital | (F13), (F14) |
| Endogenous | `rk` / $`r_t^k`$ | Rental rate of capital | (F7), (F9), (F14) |
| Endogenous | `kbar` / $`\bar{k}_t`$ | Installed capital stock | (F4) |
| Endogenous | `y` / $`y_t`$ | Output | (F15), (F16) |
| Endogenous | `k` / $`k_t`$ | Effective capital services | (F6), (F9) |
| Endogenous | `u` / $`u_t`$ | Capacity utilization | (F7), (F16) |
| Endogenous | `mc` / $`mc_t`$ | Real marginal cost | (F8), (F11) |
| Endogenous | `w` / $`w_t`$ | Real wage | (F8), (F9), (F12) |
| Endogenous | `wh` / $`w_t^h`$ | Household MRS wage | (F10), (F12) |
| Endogenous | `z` / $`z_t`$ | Growth-rate deviation of trend | (F1) |
| Endogenous | `ztil` / $`\tilde z_t`$ | Detrended log productivity | (F19) |
| Endogenous | `mu` / $`\mu_t`$ | Marginal efficiency of investment | (F22) |
| Endogenous | `sigw` / $`\tilde\sigma_{\omega,t}`$ | Financial-risk/spread shock state | (F28) |
| Endogenous | `laf` / $`\lambda_{f,t}`$ | Price markup shock state | (F23) |
| Endogenous | `law` / $`\lambda_{w,t}`$ | Wage markup shock state | (F24) |
| Endogenous | `g` / $`g_t`$ | Government spending | (F20) |
| Endogenous | `b` / $`b_t`$ | Intertemporal preference wedge | (F21) |
| Endogenous | `rm` / $`r_t^m`$ | Monetary policy residual | (F26) |
| Endogenous | `pist` / $`\pi_t^{\ast}`$ | Time-varying inflation target | (F27) |
| Endogenous | flexible-price variables | $`c_t^f,\ldots,y_t^f`$ | Parallel no-nominal-rigidity system | (F18), (F25) |
| Exogenous | `psi_b` | Preference-wedge innovation | (F21) |
| Exogenous | `psi_mu` | MEI innovation | (F22) |
| Exogenous | `psi_z` | Productivity innovation | (F1), (F19), (F20) |
| Exogenous | `psi_laf` | Price-markup innovation | (F23) |
| Exogenous | `psi_law` | Wage-markup innovation | (F24) |
| Exogenous | `psi_sigw` | Spread/risk innovation | (F28) |
| Exogenous | `psi_rm` | Monetary-policy innovation | (F26) |
| Exogenous | `psi_g` | Government-spending innovation | (F20) |
| Parameter | `alp` / $`\alpha`$ | Capital share | (F1), (F8), (F15) |
| Parameter | `zeta_p`, `iota_p`, `epsp` | Price Calvo/indexation/Kimball parameters | (F11) |
| Parameter | `zeta_w`, `iota_w`, `epsw` | Wage Calvo/indexation/Kimball parameters | (F12) |
| Parameter | `del` / $`\delta`$ | Depreciation | (F5), (F14) |
| Parameter | `Bigphi` / $`\Phi_p`$ | Fixed-cost/markup production parameter | (F15), (F16) |
| Parameter | `s2` / $`S''`$ | Investment-adjustment-cost curvature | (F3), (F4) |
| Parameter | `h` | Habit persistence | (F2), (F10) |
| Parameter | `ppsi` / $`\psi`$ | Utilization cost parameter | (F7) |
| Parameter | `nu_l` | Labor disutility curvature | (F10) |
| Parameter | `bet` / $`\beta`$ | Discount factor | (F3), (F11), (F12) |
| Parameter | `psi1`, `psi2`, `psi3`, `rho` | Policy rule coefficients | (F25) |
| Parameter | `sigmac` / $`\sigma_c`$ | Relative risk aversion | (F2) |
| Parameter | `rho_*`, `eta_*`, `sigma_*` | Shock persistence, MA, and scale parameters | (F19)-(F28) |
| Parameter | starred steady-state constants | $`c_\ast,i_\ast,y_\ast,\bar{k}_\ast,r_\ast^k,\gamma`$ | (F2)-(F16) |

Status: `needs_review`. The core SW log-linear equations are readable in the MinerU Markdown; the exact `US_DNGS15_SW` boundary relative to SWFF/SWSP variants and the technical-appendix steady state should be checked before review upgrade.
