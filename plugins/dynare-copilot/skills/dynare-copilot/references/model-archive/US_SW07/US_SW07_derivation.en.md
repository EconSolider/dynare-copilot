# US_SW07 -- Derivation (Optimization Problems + First-Order Conditions)

> This derivation is for source-backed organization in the private model archive. It is not yet intended to generate a runnable Dynare `.mod` file directly. Current status: `needs_review`. Equations are based on the published full-text MinerU Markdown and the appendix normalization; `US_SW07_rep.mod` is used only as an implementation cross-check.

## 1. Model Overview

- Model: Smets and Wouters (2007), "Shocks and Frictions in US Business Cycles: A Bayesian DSGE Approach".
- MMB code: `US_SW07`.
- Paper metadata: Frank Smets and Rafael Wouters, 2007, *American Economic Review* 97(3), 586-606, DOI `10.1257/aer.97.3.586`.
- Form: estimated log-linear DSGE. Section I of the paper gives the linearized system around a balanced-growth steady state; the online appendix gives the nonlinear source-level optimization problems, steady state, and linearization targets.
- Agents: final-good producer, differentiated intermediate-good firms, representative household, labor union, government/central bank.
- Main frictions: external habit formation, investment adjustment costs, variable capital utilization, fixed costs, Kimball goods/labor aggregators, Calvo price and wage stickiness, and price and wage indexation.
- Shocks: technology, risk premium, investment efficiency, government spending, monetary policy, price markup, and wage markup.
- Observables: output growth, consumption growth, investment growth, real wage growth, hours, inflation, and the federal funds rate.

## 2. Optimization Problems

### 2.1 Final-Good Producer

The final-good producer aggregates differentiated intermediate goods with a Kimball aggregator. Taking intermediate-good prices as given, it chooses intermediate-good demand to minimize the cost of producing a given quantity of the final good. The online appendix records the source-level final-good demand FOC and the demand/price-index relation driven by the price-markup shock.

The source-level price-markup shock process is:

```math
\log \varepsilon^p_t
= (1-\rho_p)\log \varepsilon^p
  + \rho_p \log \varepsilon^p_{t-1}
  - \mu_p \eta^p_{t-1}
  + \eta^p_t .
```

### 2.2 Intermediate-Good Firms

Intermediate-good firms produce differentiated goods using capital services and labor, subject to fixed costs:

```math
Y_t(i)=\varepsilon^a_t \left(K^s_t(i)\right)^\alpha
\left(\gamma_t L_t(i)\right)^{1-\alpha}
- \gamma_t \Phi .
```

The technology shock is:

```math
\log \varepsilon^a_t
= (1-\rho_a)\log \varepsilon^a
  + \rho_a \log \varepsilon^a_{t-1}
  + \eta^a_t .
```

Static cost minimization chooses $`K^s_t(i)`$ and $`L_t(i)`$. The source-level FOCs imply the relationship among wages, capital rental rates, and marginal cost:

```math
W_t
= MC_t(i)(1-\alpha)\varepsilon^a_t
\left(K^s_t(i)\right)^\alpha
\left(\gamma_t L_t(i)\right)^{-\alpha}\gamma_t^{1-\alpha},
```

```math
R^k_t
= MC_t(i)\alpha\varepsilon^a_t
\left(K^s_t(i)\right)^{\alpha-1}
\left(\gamma_t L_t(i)\right)^{1-\alpha}.
```

These conditions imply the common capital-labor ratio:

```math
K^s_t
= \frac{\alpha W_t L_t}{(1-\alpha)R^k_t}.
```

Price setting follows a Calvo mechanism. Firms that cannot reset prices index to past inflation and steady-state inflation. Firms that can reset prices choose $`\widetilde P_t(i)`$ to maximize discounted profits while the reset price remains in force. The Kimball curvature term enters the reset-price FOC; that FOC is kept as `needs_review` in this draft. See `extraction_notes.md`.

### 2.3 Representative Household

The household chooses consumption, labor, bonds, investment, capital, and capital utilization, with external habit formation. The source-level budget constraint is:

```math
\begin{aligned}
C_t(j)+I_t(j)+\frac{B_t(j)}{\varepsilon^b_t R_t P_t}+T_t
&= \frac{B_{t-1}(j)}{P_t}
 + \frac{W^h_t(j)L_t(j)}{P_t} \\
&\quad + \frac{R^k_t Z_t(j)K_{t-1}(j)}{P_t}
 - a(Z_t(j))K_{t-1}(j)
 + \frac{Div_t}{P_t}.
\end{aligned}
```

The risk-premium shock and investment-efficiency shock are:

```math
\log \varepsilon^b_t=\rho_b\log \varepsilon^b_{t-1}+\eta^b_t,
```

```math
\log \varepsilon^i_t=\rho_i\log \varepsilon^i_{t-1}+\eta^i_t.
```

Capital services are:

```math
K^s_t(j)=Z_t(j)K_{t-1}(j).
```

The household source-level FOCs include marginal utility, labor supply, the bond Euler equation, investment adjustment costs, the capital Euler equation, and the utilization condition. This draft uses the paper's estimated log-linear system in Section 3; the complete TeX form of the source-level nonlinear FOCs still requires review.

### 2.4 Labor Union

The labor union aggregates differentiated labor and sets nominal wages. The source layer includes labor demand, the wage index, the Calvo wage-reset FOC, and the wage-markup shock:

```math
L_t=\left[\int_0^1 L_t(l)^{1/(1+\lambda^w_t)}dl\right]^{1+\lambda^w_t},
```

```math
L_t(l)=\left(\frac{W_t(l)}{W_t}\right)^{-(1+\lambda^w_t)/\lambda^w_t}L_t,
```

```math
W_t=\left[\int_0^1 W_t(l)^{-1/\lambda^w_t}dl\right]^{-\lambda^w_t}.
```

The wage-markup shock is:

```math
\log \lambda^w_t
= (1-\rho_w)\log \lambda^w
  + \rho_w\log \lambda^w_{t-1}
  - \mu_w \eta^w_{t-1}
  + \eta^w_t .
```

The Calvo wage-reset FOC is inventoried in the appendix normalization, but its TeX remains marked as `needs_review`.

## 3. First-Order Conditions

This section records the log-linear equilibrium system used for estimation in the published paper. Variables are log deviations or linearized variables around the balanced-growth steady state; starred variables or parameter subscripts denote steady-state objects.

**(F1) Resource constraint**

```math
y_t=c_y c_t+i_y i_t+z_y z_t+\varepsilon^g_t .
```

Here $`c_y`$, $`i_y`$, and $`z_y`$ are the steady-state output shares of consumption, investment, and capital-utilization costs.

**(F2) Consumption Euler equation**

```math
c_t=c_1 c_{t-1}+(1-c_1)E_t c_{t+1}
  +c_2(l_t-E_tl_{t+1})
  -c_3(r_t-E_t\pi_{t+1}+\varepsilon^b_t).
```

The coefficients are:

```math
c_1=\frac{\lambda/\gamma}{1+\lambda/\gamma},\qquad
c_2=\frac{(\sigma_c-1)(W^h_\astL_\ast/C_\ast)}{\sigma_c(1+\lambda/\gamma)},\qquad
c_3=\frac{1-\lambda/\gamma}{\sigma_c(1+\lambda/\gamma)}.
```

**(F3) Investment Euler equation**

```math
i_t=i_1 i_{t-1}+(1-i_1)E_t i_{t+1}+i_2 q_t+\varepsilon^i_t.
```

where:

```math
i_1=\frac{1}{1+\beta\gamma^{1-\sigma_c}},\qquad
i_2=\frac{1}{(1+\beta\gamma^{1-\sigma_c})\gamma^2\varphi}.
```

**(F4) Arbitrage equation for the value of capital**

```math
q_t=q_1E_tq_{t+1}+(1-q_1)E_t r^k_{t+1}
  -(r_t-E_t\pi_{t+1}+\varepsilon^b_t).
```

where:

```math
q_1=\beta\gamma^{-\sigma_c}(1-\delta)
=\frac{1-\delta}{R^k_\ast+1-\delta}.
```

**(F5) Aggregate production function**

```math
y_t=\phi_p\left(\alpha k^s_t+(1-\alpha)l_t+\varepsilon^a_t\right).
```

**(F6) Capital services**

```math
k^s_t=k_{t-1}+z_t.
```

**(F7) Capital utilization**

```math
z_t=z_1 r^k_t,\qquad z_1=\frac{1-\psi}{\psi}.
```

**(F8) Capital accumulation**

```math
k_t=k_1k_{t-1}+(1-k_1)i_t+k_2\varepsilon^i_t,
```

where:

```math
k_1=\frac{1-\delta}{\gamma},\qquad
k_2=\left(1-\frac{1-\delta}{\gamma}\right)(1+\beta\gamma^{1-\sigma_c})\gamma^2\varphi.
```

**(F9) Price markup / marginal-cost relation**

```math
\mu^p_t=mpl_t-w_t=\alpha(k^s_t-l_t)+\varepsilon^a_t-w_t.
```

Equivalently, the log deviation of real marginal cost can be written as:

```math
mc_t=(1-\alpha)w_t+\alpha r^k_t-\varepsilon^a_t.
```

**(F10) Price Phillips curve**

```math
\pi_t=\pi_1\pi_{t-1}+\pi_2E_t\pi_{t+1}-\pi_3\mu^p_t+\varepsilon^p_t.
```

The coefficients $`\pi_1`$, $`\pi_2`$, and $`\pi_3`$ are functions of price indexation, discounting, Calvo price stickiness, and Kimball goods-market curvature. This draft does not expand the Kimball curvature term in $`\pi_3`$; it requires source-level TeX review.

**(F11) Capital rental rate**

```math
r^k_t=-(k_t-l_t)+w_t.
```

**(F12) Wage markup / MRS**

```math
\mu^w_t=w_t-mrs_t,
```

```math
mrs_t=\sigma_l l_t+\frac{1}{1-\lambda/\gamma}
\left(c_t-\frac{\lambda}{\gamma}c_{t-1}\right).
```

**(F13) Wage Phillips curve**

```math
\begin{aligned}
w_t
&=w_1w_{t-1}+(1-w_1)(E_tw_{t+1}+E_t\pi_{t+1})
  -w_2\pi_t+w_3\pi_{t-1} \\
&\quad -w_4\mu^w_t+\varepsilon^w_t .
\end{aligned}
```

The coefficients $`w_1`$, $`w_2`$, $`w_3`$, and $`w_4`$ are functions of discounting, wage indexation, Calvo wage stickiness, and Kimball labor-market curvature. The corresponding expression in `full.md` has OCR line loss; this draft uses appendix normalization and the implementation cross-check to recover the structure, but it still requires manual TeX review.

**(F14) Monetary policy rule**

```math
r_t=\rho r_{t-1}
 +(1-\rho)\left[r_\pi\pi_t+r_y(y_t-y^p_t)\right]
 +r_{\Delta y}\left[(y_t-y^p_t)-(y_{t-1}-y^p_{t-1})\right]
 +\varepsilon^r_t .
```

Here $`y^p_t`$ is potential output: output under flexible prices and wages and without the price/wage markup shocks.

## 4. Market Clearing & Identities

**(F15) Source-level counterpart of the resource constraint**

```math
C_t+I_t+G_t+a(u_t)K_{t-1}=Y_t.
```

This corresponds to (F1) in the log-linear system. The capital-utilization cost term $`a(u_t)K_{t-1}`$ maps to $`z_yz_t`$ in the linear system.

**(F16) Government budget constraint**

```math
P_tG_t+B_{t-1}=T_t+\frac{B_t}{R_t}.
```

In the estimated closed system, government spending enters the resource constraint through an exogenous process; debt and taxes are not main state variables in `US_SW07_rep.mod`.

**(F17) Measurement equations**

```math
\begin{bmatrix}
dlGDP_t\\
dlCONS_t\\
dlINV_t\\
dlWAG_t\\
lHOURS_t\\
dlP_t\\
FEDFUNDS_t
\end{bmatrix}
=
\begin{bmatrix}
\bar\gamma\\
\bar\gamma\\
\bar\gamma\\
\bar\gamma\\
\bar l\\
\bar\pi\\
\bar r
\end{bmatrix}
+
\begin{bmatrix}
y_t-y_{t-1}\\
c_t-c_{t-1}\\
i_t-i_{t-1}\\
w_t-w_{t-1}\\
l_t\\
\pi_t\\
r_t
\end{bmatrix}.
```

**(F18) Flexible-economy potential-output block**

The paper defines the output gap as actual output relative to potential output. The `US_SW07_rep.mod` implementation cross-check shows flexible-economy counterparts: `yf, cf, invef, labf, wf, rkf, kf, pkf, zcapf, rrf, kpf`. This draft does not promote those `.mod` equations to source-stated equations; later review must align them with the appendix sections on the natural output level and the flexible-price/wage economy.

## 5. Exogenous Processes

**(F19) Technology shock**

```math
\varepsilon^a_t=\rho_a\varepsilon^a_{t-1}+\eta^a_t.
```

**(F20) Risk-premium shock**

```math
\varepsilon^b_t=\rho_b\varepsilon^b_{t-1}+\eta^b_t.
```

**(F21) Investment-efficiency shock**

```math
\varepsilon^i_t=\rho_i\varepsilon^i_{t-1}+\eta^i_t.
```

**(F22) Government-spending shock**

```math
\varepsilon^g_t=\rho_g\varepsilon^g_{t-1}+\eta^g_t+\rho_{ga}\eta^a_t.
```

**(F23) Monetary policy shock**

```math
\varepsilon^r_t=\rho_r\varepsilon^r_{t-1}+\eta^r_t.
```

**(F24) Price-markup shock**

```math
\varepsilon^p_t=\rho_p\varepsilon^p_{t-1}+\eta^p_t-\mu_p\eta^p_{t-1}.
```

**(F25) Wage-markup shock**

```math
\varepsilon^w_t=\rho_w\varepsilon^w_{t-1}+\eta^w_t-\mu_w\eta^w_{t-1}.
```

Implementation cross-check: `US_SW07_rep.mod` maps these innovations to `ea`, `eb`, `eqs`, `eg`, `em`, `epinf`, and `ew`, with MA auxiliaries `epinfma` and `ewma`.

## 6. Steady-State Solution

Because the estimated system is log-linear, the main variables in Sections 3-5 have deterministic steady state equal to zero:

```math
y=c=i=q=k^s=k=z=r^k=\mu^p=\pi=\mu^w=w=l=r=0,
```

and all innovations have zero steady state.

The underlying balanced-growth steady state still relies on the following source-level relationships for parameter back-solving:

```math
k=\frac{\alpha}{1-\alpha}\frac{w}{r^k}L,
```

```math
R=\frac{\gamma^{\sigma_c}}{\beta},
```

```math
i=\left(1-\frac{1-\delta}{\gamma}\right)k,
```

```math
1=\beta\gamma^{-\sigma_c}(r^k+1-\delta),
```

```math
y=Zk^\alpha L^{1-\alpha}-\Phi,
```

```math
\frac{c}{y}+\frac{i}{y}+g=1.
```

The `US_SW07_rep.mod` parameter initialization further back-solves:

```math
\bar R=\frac{\bar\Pi}{\beta\gamma^{-\sigma_c}},\qquad
R^k=\beta^{-1}\gamma^{\sigma_c}-(1-\delta),
```

as well as consumption, investment, government-spending, and capital-income shares. The current archive does not treat these implementation details as a source-stated steady-state proof; later review must cross-check them against the appendix steady-state section.

## 7. Timing & Form Conventions

- Model form: linearized `model(linear)` around a balanced-growth steady state.
- Capital timing: newly installed capital enters production with a one-quarter lag, $`k^s_t=k_{t-1}+z_t`$.
- Investment adjustment costs: depend on investment growth or investment ratios, generating lagged and forward-looking investment dynamics.
- Price setting: Calvo price stickiness; non-reset prices are indexed to past inflation and steady-state inflation.
- Wage setting: Calvo wage stickiness; non-reset wages are indexed to past inflation, steady-state inflation, and trend growth.
- Output gap: relative to flexible-price/wage potential output, not a statistically filtered output gap.
- Notation: the body uses paper notation; ASCII names in the reference table are aligned with `US_SW07_rep.mod`, but the `.mod` file is only a cross-check.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Main equations |
| --- | --- | --- | --- |
| Endogenous | `y` / $`y_t`$ | Output | (F1), (F5), (F14), (F17) |
| Endogenous | `c` / $`c_t`$ | Consumption | (F1), (F2), (F12), (F17) |
| Endogenous | `inve` / $`i_t`$ | Investment | (F1), (F3), (F8), (F17) |
| Endogenous | `pk` / $`q_t`$ | Value of capital / Tobin's Q | (F3), (F4) |
| Endogenous | `k` / $`k^s_t`$ | Current capital services | (F5), (F6), (F11) |
| Endogenous | `kp` / $`k_t`$ | Installed capital stock | (F8) |
| Endogenous | `zcap` / $`z_t`$ | Capital utilization | (F1), (F6), (F7) |
| Endogenous | `rk` / $`r^k_t`$ | Capital rental rate | (F4), (F7), (F11) |
| Endogenous | `mc` / $`mc_t`$ | Real marginal cost | (F9), (F10) |
| Endogenous | `pinf` / $`\pi_t`$ | Inflation | (F10), (F13), (F14), (F17) |
| Endogenous | `w` / $`w_t`$ | Real wage | (F11), (F12), (F13), (F17) |
| Endogenous | `lab` / $`l_t`$ | Hours worked | (F2), (F5), (F9), (F12), (F17) |
| Endogenous | `r` / $`r_t`$ | Nominal policy-rate deviation | (F2), (F4), (F14), (F17) |
| Endogenous | `a` / $`\varepsilon^a_t`$ | Technology state | (F5), (F9), (F19) |
| Endogenous | `b` / $`\varepsilon^b_t`$ | Risk-premium state | (F2), (F4), (F20) |
| Endogenous | `g` / $`\varepsilon^g_t`$ | Government-spending state | (F1), (F22) |
| Endogenous | `qs` / $`\varepsilon^i_t`$ | Investment-efficiency state | (F3), (F8), (F21) |
| Endogenous | `ms` / $`\varepsilon^r_t`$ | Monetary-policy state | (F14), (F23) |
| Endogenous | `spinf` / $`\varepsilon^p_t`$ | Price-markup state | (F10), (F24) |
| Endogenous | `sw` / $`\varepsilon^w_t`$ | Wage-markup state | (F13), (F25) |
| Endogenous | `dy`, `dc`, `dinve`, `dw`, `labobs`, `pinfobs`, `robs` | Measurement-equation variables | (F17) |
| Exogenous | `ea` | Technology innovation | (F19) |
| Exogenous | `eb` | Risk-premium innovation | (F20) |
| Exogenous | `eqs` | Investment-efficiency innovation | (F21) |
| Exogenous | `eg` | Government-spending innovation | (F22) |
| Exogenous | `em` | Monetary-policy innovation | (F23) |
| Exogenous | `epinf` | Price-markup innovation | (F24) |
| Exogenous | `ew` | Wage-markup innovation | (F25) |
| Parameter | `cbeta`, $`\beta`$ | Discount factor | (F2), (F4), (F10), (F13) |
| Parameter | `cgamma`, $`\gamma`$ | Trend growth | (F2), (F3), (F8), Section 6 |
| Parameter | `csigma`, $`\sigma_c`$ | Consumption risk aversion / IES parameter | (F2), (F12), Section 6 |
| Parameter | `chabb`, $`\lambda`$ or $`h`$ | External habit | (F2), (F12) |
| Parameter | `calfa`, $`\alpha`$ | Capital share | (F5), (F9), (F11), Section 6 |
| Parameter | `ctou`, $`\delta`$ | Depreciation rate | (F8), Section 6 |
| Parameter | `csadjcost`, $`\varphi`$ | Investment adjustment-cost curvature | (F3), (F8) |
| Parameter | `czcap`, $`\psi`$ | Capital-utilization adjustment-cost parameter | (F7) |
| Parameter | `cprobp`, $`\xi_p`$ | Calvo price non-adjustment probability | (F10) |
| Parameter | `cindp`, $`\iota_p`$ | Price indexation | (F10) |
| Parameter | `cprobw`, $`\xi_w`$ | Calvo wage non-adjustment probability | (F13) |
| Parameter | `cindw`, $`\iota_w`$ | Wage indexation | (F13) |
| Parameter | `crr`, $`\rho`$ | Interest-rate smoothing | (F14) |
| Parameter | `crpi`, $`r_\pi`$ | Response to inflation | (F14) |
| Parameter | `cry`, $`r_y`$ | Response to the output gap | (F14) |
| Parameter | `crdy`, $`r_{\Delta y}`$ | Response to output-gap change | (F14) |
| Parameter | `crhoa`, `crhob`, `crhoqs`, `crhog`, `crhoms`, `crhopinf`, `crhow` | Shock persistence | (F19)-(F25) |
| Parameter | `cmap`, `cmaw` | Price/wage markup MA coefficients | (F24), (F25) |

### Self-Check Status

- Eight-section structure: complete.
- Model form: declared as a log-linear estimated DSGE.
- Timing convention: one-quarter lag from installed capital to production is recorded.
- Source provenance: see `source_manifest.json`.
- Formula quality: `needs_review`, especially the Kimball/Calvo reset-price and wage-reset FOCs.
- Runtime validation: not performed and out of scope for the current phase.
