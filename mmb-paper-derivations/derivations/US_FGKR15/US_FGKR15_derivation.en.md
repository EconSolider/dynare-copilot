# US_FGKR15 -- Derivation (Optimization Problems + Equilibrium Conditions)

> First-pass private archive extraction. Status: `needs_review`. Runtime validation was not performed; Dynare was not run.

Provenance: `US_FGKR15`, Fernandez-Villaverde, Guerron-Quintana, Kuester, and Rubio-Ramirez (2015), "Fiscal volatility shocks and economic activity," *American Economic Review* 105(11), 3352-3384, DOI `10.1257/aer.20121236`. Main source: `raw/mmb_mineru/runs/us_fgkr15__fiscal_volatility_shocks_and_economic_activity__c11fd284/full.md`. Raw PDF: `raw/mmb_papers/Fiscal volatility shocks and economic activity.pdf`. Online appendix source: `raw/theory_sources/mmb_appendix_us_fgkr15/files/20121236_app.pdf`. MinerU run id: `c11fd284-6f64-4c88-bb10-440da7196eef`.

## 1. Model Overview

- **Model**: medium-scale U.S. New Keynesian DSGE model with fiscal rules and stochastic fiscal volatility shocks.
- **Purpose**: quantify the real effects of unexpected increases in the volatility of fiscal instruments, especially capital-income-tax volatility.
- **Agents and blocks**: representative household with habit, investment, utilization, government bonds, differentiated labor and Rotemberg wage adjustment; final-good bundler; monopolistically competitive intermediate-good firms with Rotemberg price adjustment; monetary authority; fiscal authority.
- **Fiscal instruments**: government spending share $`\tilde g_t`$, labor tax $`\tau_{l,t}`$, capital tax $`\tau_{k,t}`$, and consumption tax $`\tau_{c,t}`$. Each instrument has a fiscal shock and a separate stochastic-volatility shock.
- **Core mechanism**: fiscal volatility changes risk around future distortionary policy; with nominal rigidities, markups move endogenously and amplify the contraction.
- **Form**: nonlinear balanced-growth DSGE solved in the paper by third-order perturbation. The Rep-MMB cross-check uses exponentiated log variables in a nonlinear `model` block; its active `stoch_simul` line is first order, but the paper's published IRFs use higher-order/pruned simulation. Runtime validation is deferred.

## 2. Optimization Problems

### 2.1 Household

The household maximizes expected utility over consumption, differentiated labor, bonds, utilization, capital, book capital, and investment:

```math
\max E_0\sum_{t=0}^{\infty}\beta^t d_t
\left[
\frac{(c_t-b_h c_{t-1})^{1-\omega}}{1-\omega}
+v(g_t)
-\psi A_t^{1-\omega}\int_0^1\frac{l_{j,t}^{1+\vartheta}}{1+\vartheta}\,dj
\right].
```

The real budget constraint is:

```math
\begin{aligned}
(1+\tau_{c,t})c_t+i_t+b_t+\Omega_t+\int_0^1 AC^w_{j,t}\,dj
=&(1-\tau_{l,t})\int_0^1 w_{j,t}l_{j,t}\,dj
+(1-\tau_{k,t})r_{k,t}u_t k_{t-1}\\
&+\tau_{k,t}\delta k^b_{t-1}
+b_{t-1}\frac{R_{t-1}}{\Pi_t}+F_t .
\end{aligned}
```

Wage adjustment costs are quadratic:

```math
AC^w_{j,t}=\frac{\phi_w}{2}
\left(\frac{w_{j,t}}{w_{j,t-1}}-g_A\right)^2 y_t.
```

Capital and book capital evolve according to:

```math
k_t=(1-\delta(u_t))k_{t-1}
+\left[1-S\left(\frac{i_t}{i_{t-1}}\right)\right]i_t,
```

```math
\delta(u_t)=\delta+\phi_1(u_t-1)+\frac{1}{2}\phi_2(u_t-1)^2,\qquad
S\left(\frac{i_t}{i_{t-1}}\right)=\frac{\kappa}{2}\left(\frac{i_t}{i_{t-1}}-g_A\right)^2,
```

```math
k^b_t=(1-\delta)k^b_{t-1}+i_t.
```

### 2.2 Labor Packer

A competitive labor packer aggregates differentiated labor types:

```math
l_t=\left(\int_0^1 l_{j,t}^{(\epsilon_w-1)/\epsilon_w}\,dj\right)^{\epsilon_w/(\epsilon_w-1)}.
```

Cost minimization implies demand for each type:

```math
l_{j,t}=\left(\frac{w_{j,t}}{w_t}\right)^{-\epsilon_w}l_t.
```

### 2.3 Final-Good Producer

The final-good producer aggregates differentiated intermediate goods:

```math
y_t=\left(\int_0^1 y_{i,t}^{(\epsilon-1)/\epsilon}\,di\right)^{\epsilon/(\epsilon-1)}.
```

Cost minimization implies:

```math
y_{i,t}=\left(\frac{P_{i,t}}{P_t}\right)^{-\epsilon}y_t.
```

### 2.4 Intermediate-Good Firms

Intermediate firm $`i`$ produces:

```math
y_{i,t}=k_{i,t}^{\alpha}(A_t l_{i,t})^{1-\alpha}.
```

Cost minimization implies common real marginal cost:

```math
mc_t=\left(\frac{1}{1-\alpha}\right)^{1-\alpha}
\left(\frac{1}{\alpha}\right)^{\alpha}
\frac{w_t^{1-\alpha}r_{k,t}^{\alpha}}{A_t^{1-\alpha}}.
```

Each monopolistic firm sets prices subject to demand and Rotemberg price adjustment costs:

```math
\max_{\{P_{i,t+s}\}} E_t\sum_{s=0}^{\infty}
\beta^s\frac{\lambda_{t+s}}{\lambda_t}
\left[
\frac{P_{i,t+s}}{P_{t+s}}y_{i,t+s}
-mc_{t+s}y_{i,t+s}
-AC^p_{i,t+s}
\right],
```

```math
AC^p_{i,t}=\frac{\phi_p}{2}
\left(\frac{P_{i,t}}{P_{i,t-1}}-\Pi\right)^2y_{i,t}.
```

### 2.5 Government and Monetary Authority

The monetary authority follows a Taylor rule in the baseline economy and may also react to fiscal volatility in the extended economy. The fiscal authority chooses distortionary tax rates and spending according to stochastic fiscal rules, and lump-sum taxes stabilize the debt-output ratio.

## 3. First-Order Conditions

The following conditions are source-backed from the paper and online appendix. Equations marked `needs_review` are algebraically normalized using the implementation cross-check because the extracted PDF text is not fully LaTeX-clean.

- **(F1) Household marginal utility of consumption with habit**:

```math
\frac{d_t}{(c_t-b_h c_{t-1})^\omega}
-E_t\left[\frac{\beta b_h d_{t+1}}{(c_{t+1}-b_h c_t)^\omega}\right]
=\lambda_t(1+\tau_{c,t}).
```

- **(F2) Wage-setting condition** (`needs_review`):

```math
\begin{aligned}
&\phi_w y_t\left(\frac{w_t}{w_{t-1}}-g_A\right)\frac{w_t}{w_{t-1}}\\
&=E_t\Bigg[
\beta\frac{\lambda_{t+1}}{\lambda_t}\phi_w y_{t+1}
\left(\frac{w_{t+1}}{w_t}-g_A\right)\frac{w_{t+1}}{w_t}
+\frac{(1-\epsilon_w)d_t}{\lambda_t}\psi A_t^{1-\omega}l_t^{1+\vartheta}
+(\epsilon_w-1)(1-\tau_{l,t})w_t l_t
\Bigg].
\end{aligned}
```

- **(F3) Bond Euler equation**:

```math
\lambda_t=\beta E_t\left[\lambda_{t+1}\frac{R_t}{\Pi_{t+1}}\right].
```

- **(F4) Utilization condition**:

```math
r_{k,t}(1-\tau_{k,t})=q_t\delta'(u_t).
```

- **(F5) Capital Euler equation**:

```math
q_t=E_t\left\{\beta\frac{\lambda_{t+1}}{\lambda_t}
\left[(1-\delta(u_{t+1}))q_{t+1}+(1-\tau_{k,t+1})r_{k,t+1}u_{t+1}\right]\right\}.
```

- **(F6) Book-capital Euler equation for depreciation allowances**:

```math
q^b_t=E_t\left\{\beta\frac{\lambda_{t+1}}{\lambda_t}
\left[(1-\delta)q^b_{t+1}+\delta\tau_{k,t+1}\right]\right\}.
```

- **(F7) Investment FOC** (`needs_review`):

```math
1=q_t\left[
1-S\left(\frac{i_t}{i_{t-1}}\right)
-S'\left(\frac{i_t}{i_{t-1}}\right)\frac{i_t}{i_{t-1}}
\right]
+\beta E_t\left[
q_{t+1}\frac{\lambda_{t+1}}{\lambda_t}
S'\left(\frac{i_{t+1}}{i_t}\right)
\left(\frac{i_{t+1}}{i_t}\right)^2
\right]+q^b_t.
```

- **(F8) Intermediate-good marginal cost**:

```math
mc_t=\left(\frac{w_t}{1-\alpha}\right)^{1-\alpha}
\left(\frac{r_{k,t}}{\alpha}\right)^\alpha A_t^{\alpha-1}.
```

- **(F9) Factor-input ratio**:

```math
\frac{u_t k_{t-1}}{l_t}
=\frac{\alpha}{1-\alpha}\frac{A_t w_t}{r_{k,t}}.
```

- **(F10) Rotemberg Phillips curve**:

```math
\begin{aligned}
0=&(1-\epsilon)+\epsilon mc_t-\phi_p\Pi_t(\Pi_t-\Pi)
+\frac{\epsilon\phi_p}{2}(\Pi_t-\Pi)^2\\
&+\phi_p\beta E_t\left[
\frac{\lambda_{t+1}}{\lambda_t}\Pi_{t+1}(\Pi_{t+1}-\Pi)
\frac{y_{t+1}}{y_t}
\right].
\end{aligned}
```

- **(F11) Baseline Taylor rule**:

```math
\frac{R_t}{R}=
\left(\frac{R_{t-1}}{R}\right)^{\phi_R}
\left(\frac{\Pi_t}{\Pi}\right)^{(1-\phi_R)\gamma_\Pi}
\left(\frac{y_t}{yA_t}\right)^{(1-\phi_R)\gamma_y}
\exp(\sigma_m\xi_t).
```

- **(F12) Extended Taylor rule with fiscal-volatility response**:

```math
\frac{R_t}{R}=
\left(\frac{R_{t-1}}{R}\right)^{\phi_R}
\left(\frac{\Pi_t}{\Pi}\right)^{(1-\phi_R)\gamma_\Pi}
\left(\frac{y_t}{yA_t}\right)^{(1-\phi_R)\gamma_y}
\left(\frac{e^{\sigma_{\tau_k,t}}}{e^{\sigma_{\tau_k}}}\right)^{\gamma_\sigma(1-\phi_R)}
\exp(\sigma_m\xi_t).
```

- **(F13) Government budget constraint**:

```math
b_t=b_{t-1}\frac{R_{t-1}}{\Pi_t}+g_t
-\left(c_t\tau_{c,t}+w_tl_t\tau_{l,t}+r_{k,t}u_tk_{t-1}\tau_{k,t}
-\delta k^b_{t-1}\tau_{k,t}+\Omega_t\right).
```

- **(F14) Lump-sum tax feedback rule**:

```math
\Omega_t=A_t\left[
\Omega+\phi_{\Omega,b}\left(\frac{b_{t-1}}{A_{t-1}y}-\frac{b}{y}\right)
\right].
```

- **(F15) Capital accumulation**:

```math
k_t=(1-\delta(u_t))k_{t-1}
+\left[1-S\left(\frac{i_t}{i_{t-1}}\right)\right]i_t.
```

- **(F16) Book-capital accumulation**:

```math
k^b_t=(1-\delta)k^b_{t-1}+i_t.
```

## 4. Market Clearing & Identities

- **(F17) Aggregate resource constraint and supply identity**:

```math
y_t=c_t+i_t+g_t+\frac{\phi_p}{2}(\Pi_t-\Pi)^2y_t
+\frac{\phi_w}{2}\left(\frac{w_t}{w_{t-1}}-g_A\right)^2y_t
=(u_tk_{t-1})^\alpha(A_tl_t)^{1-\alpha}.
```

- **(F18) Aggregate profits**:

```math
F_t=y_t-w_tl_t-r_{k,t}u_tk_{t-1}
-\frac{\phi_p}{2}(\Pi_t-\Pi)^2y_t.
```

- **(F19) Government spending level**:

```math
g_t=\tilde g_t y_t.
```

- **(F20) Gross inflation definition**:

```math
\Pi_t=\frac{P_t}{P_{t-1}}.
```

- **(F21) Depreciation and investment-adjustment functions**:

```math
\delta'(u_t)=\phi_1+\phi_2(u_t-1),\qquad
S'(x)=\kappa(x-g_A).
```

## 5. Exogenous Processes

- **(F22) Labor-augmenting technology with unit root**:

```math
\log A_t=g_A+\log A_{t-1}+\sigma_A\epsilon_{A,t},\qquad
\epsilon_{A,t}\sim\mathcal N(0,1).
```

- **(F23) Preference shock**:

```math
\log d_t=\rho_d\log d_{t-1}+\sigma_d\epsilon_{d,t},\qquad
\epsilon_{d,t}\sim\mathcal N(0,1).
```

- **(F24) Fiscal instrument rule for $`x\in\{\tilde g,\tau_l,\tau_k,\tau_c\}`$**:

```math
x_t-x=\rho_x(x_{t-1}-x)
+\phi_{x,y}\tilde y_{t-1}
+\phi_{x,b}\left(\frac{b_{t-1}}{y_{t-1}}-\frac{b}{y}\right)
+\exp(\sigma_{x,t})\epsilon_{x,t},
\qquad \epsilon_{x,t}\sim\mathcal N(0,1).
```

- **(F25) Fiscal volatility process for $`x\in\{\tilde g,\tau_l,\tau_k,\tau_c\}`$**:

```math
\sigma_{x,t}=(1-\rho_{\sigma_x})\sigma_x
+\rho_{\sigma_x}\sigma_{x,t-1}
+(1-\rho_{\sigma_x}^2)^{1/2}\eta_x u_{x,t},
\qquad u_{x,t}\sim\mathcal N(0,1).
```

- **(F26) Monetary policy shock innovation**:

```math
\xi_t\sim\mathcal N(0,1).
```

## 6. Steady-State Solution

The paper works with a balanced-growth path. Let stationary variables be normalized by $`A_t`$ where needed, and set shocks to their unconditional means.

1. Set $`u=1`$, $`\delta(u)=\delta`$, $`\delta'(1)=\phi_1`$, $`S(g_A)=S'(g_A)=0`$.
2. Set $`\Pi`$ to the inflation target, $`g_A=1.005`$, and choose $`R`$ from the steady-state Fisher/Euler condition adjusted for growth and habit as in the implementation cross-check.
3. From (F4), pin down the utilization-cost slope: $`r_k(1-\tau_k)=q\phi_1`$.
4. From (F5), solve the steady-state user cost of capital with $`q=1`$:

```math
1=\beta \frac{\lambda_{t+1}}{\lambda_t}\left[(1-\delta)+r_k(1-\tau_k)\right],
```

with growth normalization handled by the stationary transformation.

5. From (F8) and (F9), solve the capital-labor ratio and real wage for given $`mc=(\epsilon-1)/\epsilon`$.
6. Normalize hours to the calibration target $`l=1/3`$ and compute $`k`$, $`y`$, and $`i=[1-(1-\delta)/g_A]k`$.
7. Compute book capital from (F16): $`k^b=i/(1-(1-\delta)/g_A)`$ under the implementation's growth-adjusted convention.
8. Use the resource constraint (F17) with zero adjustment costs to get consumption: $`c=y-i-\tilde g y`$.
9. Use (F1) and (F2) to back out $`\lambda`$ and the labor disutility scale $`\psi`$.
10. Use the government budget constraint (F13) and lump-sum rule (F14) to back out the steady-state lump-sum tax level $`\Omega`$.

`needs_review`: the exact growth-normalized steady-state formulas for $`\lambda`$, $`q`$, and $`q^b`$ are implementation-normalized in `US_FGKR15_rep.mod`; this entry records the source logic but does not certify a runnable steady-state block.

## 7. Timing & Form Conventions

- **Capital timing**: production at $`t`$ uses $`k_{t-1}`$ and utilization $`u_t`$; investment determines end-of-period $`k_t`$.
- **Book-capital timing**: depreciation allowances use $`k^b_{t-1}`$, and investment updates $`k^b_t`$.
- **Debt timing**: government bonds $`b_t`$ are end-of-period real debt; the budget constraint carries $`b_{t-1}R_{t-1}/\Pi_t`$ into period $`t`$.
- **Fiscal shocks**: $`\epsilon_{x,t}`$ move fiscal instruments; $`u_{x,t}`$ move the log standard deviations $`\sigma_{x,t}`$. The main experiment shocks $`u_{\tau_k,t}`$.
- **Model form**: nonlinear stationary equilibrium with balanced growth. Paper-side quantitative results use third-order perturbation because volatility shocks matter directly at higher order.
- **Implementation cross-check**: `.agents/skills/dynare-copilot/references/examples/US_FGKR15_rep.mod` uses log/exponentiated variables including `ct`, `yt`, `invt`, `kt`, `kbt`, `ht`, `mct`, `wt`, `inflt`, `Rt`, tax rates, and volatility states. It was not run.

## 8. Variable & Parameter Reference Table

### Endogenous variables

| Symbol | ASCII / implementation cue | Meaning | Main equations |
|---|---|---|---|
| $`c_t`$ | `ct` | consumption | (F1), (F17) |
| $`i_t`$ | `invt` | investment | (F7), (F15), (F17) |
| $`y_t`$ | `yt` | output | (F17) |
| $`l_t`$ | `ht` | aggregate hours | (F2), (F9), (F17) |
| $`w_t`$ | `wt` | real wage | (F2), (F8), (F9) |
| $`\lambda_t`$ | `lamt` | budget multiplier | (F1), (F3), (F5), (F7), (F10) |
| $`b_t`$ | `bdt` | real government debt | (F13), (F14), (F24) |
| $`u_t`$ | `utilt` | capital utilization | (F4), (F15), (F17) |
| $`k_t`$ | `kt` | productive capital stock | (F15), (F17) |
| $`k^b_t`$ | `kbt` | tax book capital | (F6), (F16) |
| $`q_t`$ | `miut / lamt` | Tobin's Q multiplier normalized by $`\lambda_t`$ | (F5), (F7) |
| $`q^b_t`$ | `miubt / lamt` | book-capital multiplier normalized by $`\lambda_t`$ | (F6), (F7) |
| $`r_{k,t}`$ | `rkt` | rental rate of capital | (F4), (F8), (F9) |
| $`mc_t`$ | `mct` | real marginal cost | (F8), (F10) |
| $`\Pi_t`$ | `inflt` | gross inflation | (F10), (F11), (F20) |
| $`R_t`$ | `Rt` | gross nominal interest rate | (F3), (F11), (F12), (F13) |
| $`F_t`$ | `proft` | aggregate firm profits | (F18) |
| $`\tilde g_t`$ | `gt` | government spending share | (F19), (F24) |
| $`\tau_{k,t}`$ | `taukt` | capital income tax rate | (F4), (F13), (F24) |
| $`\tau_{l,t}`$ | `tauwt` | labor income tax rate | (F2), (F13), (F24) |
| $`\tau_{c,t}`$ | `tauct` | consumption tax rate | (F1), (F13), (F24) |
| $`\sigma_{k,t},\sigma_{l,t},\sigma_{c,t},\sigma_{g,t}`$ | `sigkt`, `sigwt`, `sigct`, `siggt` | fiscal volatility states | (F25) |
| $`A_t`$ | `gzt` growth state | labor-augmenting technology level/growth | (F22) |
| $`d_t`$ | `dt` | preference shock | (F23) |

### Exogenous innovations

| Symbol | ASCII / implementation cue | Meaning |
|---|---|---|
| $`\epsilon_{A,t}`$ | `ezt` | technology innovation |
| $`\epsilon_{d,t}`$ | `edt` | preference innovation |
| $`\xi_t`$ | `emt` | monetary policy innovation |
| $`\epsilon_{\tau_k,t}`$ | `ekt` | capital-tax fiscal innovation |
| $`\epsilon_{\tau_c,t}`$ | `ect` | consumption-tax fiscal innovation |
| $`\epsilon_{\tilde g,t}`$ | `egt` | government-spending fiscal innovation |
| $`\epsilon_{\tau_l,t}`$ | `ewt` | labor-tax fiscal innovation |
| $`u_{\tau_k,t}`$ | `ukt` | capital-tax volatility innovation |
| $`u_{\tau_c,t}`$ | `uct` | consumption-tax volatility innovation |
| $`u_{\tilde g,t}`$ | `ugt` | spending volatility innovation |
| $`u_{\tau_l,t}`$ | `uwt` | labor-tax volatility innovation |

### Parameters

| Parameter | Meaning |
|---|---|
| $`\beta,\omega,b_h,\psi,\vartheta`$ | household discounting, risk aversion, habit, labor disutility scale, inverse Frisch elasticity |
| $`\alpha,\delta,\phi_1,\phi_2,\kappa,g_A`$ | production share, depreciation, utilization cost, investment adjustment, trend growth |
| $`\epsilon,\epsilon_w,\phi_p,\phi_w`$ | goods/labor demand elasticities and Rotemberg price/wage adjustment costs |
| $`\Pi,R,\phi_R,\gamma_\Pi,\gamma_y,\gamma_\sigma,\sigma_m`$ | inflation target, nominal rate, Taylor-rule parameters, fiscal-volatility response, monetary shock scale |
| $`\rho_x,\phi_{x,y},\phi_{x,b},\sigma_x,\rho_{\sigma_x},\eta_x`$ | fiscal rule persistence, feedbacks, average volatility, volatility persistence and innovation scale |
| $`\rho_d,\sigma_d,\sigma_A,\phi_{\Omega,b},\Omega,b/y`$ | preference and technology shock parameters, debt-stabilization and fiscal steady-state targets |
