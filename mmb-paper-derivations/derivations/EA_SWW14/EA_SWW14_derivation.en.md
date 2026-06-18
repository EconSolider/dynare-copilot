# EA_SWW14 - Derivation (optimization problems + equilibrium conditions)

> This first-pass archive derivation is for source review before any Dynare implementation work. Runtime validation was not performed.

Source: Frank Smets, Anders Warne, and Rafael Wouters (2014), "Professional forecasters and real-time forecasting with a DSGE model", *International Journal of Forecasting*, 30, 981-995. DOI: `10.1016/j.ijforecast.2014.03.018`.

## 1. Model Overview

- **Model**: Euro-area Galí-Smets-Wouters (GSW) medium-scale New Keynesian DSGE model used for real-time forecasting and SPF-conditioning experiments.
- **Archive ID**: `EA_SWW14`.
- **Economy**: Euro area.
- **Experiment**: Real-time forecasting with eight observed macro series, compared across the benchmark GSW model and SPF-conditioned noise/news variants. The archive derivation below records the benchmark structural GSW model block; SPF noise/news conditioning is a forecasting and measurement extension rather than a different private-sector equilibrium.
- **Agents and blocks**: habit-formation households, investment/capital accumulation with adjustment costs and variable utilization, monopolistically competitive price and wage setters with Calvo frictions and indexation, an unemployment/labor-force block, a Taylor-type monetary authority, and eight exogenous structural shocks.
- **Form**: log-linearized equilibrium system around a balanced growth path; the implementation cross-check uses `model(linear)`.
- **Status**: `needs_review`. The source Markdown gives the main equilibrium equations, but several OCR artifacts remain in shock notation and markup definitions.

## 2. Optimization Problems

The paper presents log-linearized equilibrium conditions rather than full nonlinear household and firm programs. The underlying optimization blocks are inferred from the GSW/Smets-Wouters structure and should be treated as derivation context, not as separately source-stated nonlinear equations.

### 2.1 Household consumption-saving problem

Households have external habit in consumption and choose consumption and nominal bond holdings. The paper states the resulting log-linear Euler equation directly. The implied objective has habit-adjusted marginal utility and the intertemporal wedge/risk-premium shock \(\widehat{\varepsilon}^b_t\) in the Euler equation.

### 2.2 Investment and capital services

Capital-goods decisions imply a forward-looking investment Euler equation in investment and the value of installed capital \(\widehat{q}^k_t\). Capital evolves with investment-specific technology shocks, and capital services used in production combine lagged installed capital and utilization.

### 2.3 Price and wage setting

Intermediate goods and labor varieties face Calvo nominal rigidities with partial indexation. The paper gives log-linear price and wage Phillips curves in terms of average and natural markups.

### 2.4 Monetary policy and forecasting/measurement layer

The monetary authority follows an interest-rate rule with smoothing, inflation, output-gap and output-gap-growth responses. The real-time forecast exercise adds measurement and conditioning equations for observed macro variables and SPF forecasts. These are not optimization problems and are placed in Sections 4 and 5.

## 3. First-Order Conditions

Equations are numbered continuously across Sections 3-5. Hatted variables are deviations from the steady-state balanced-growth path.

- **(F1) Consumption Euler equation with habit and risk premium**:

\[
\widehat{c}_t
= c_1 E_t\widehat{c}_{t+1}
+ (1-c_1)\widehat{c}_{t-1}
- c_2\left(\widehat{r}_t-E_t\widehat{\pi}_{t+1}-\widehat{\varepsilon}^b_t\right),
\]

where \(c_1=1/(1+h/\tau)\) and \(c_2=(1-h/\tau)/(1+h/\tau)\).

- **(F2) Investment Euler equation**:

\[
\widehat{i}_t
= i_1\widehat{i}_{t-1}
+ (1-i_1)E_t\widehat{i}_{t+1}
+ i_2\widehat{q}^k_t
+ \widehat{\varepsilon}^q_t,
\]

with \(i_1=1/(1+\beta)\) and \(i_2=i_1/(\tau^2\varphi)\).

- **(F3) Value of installed capital**:

\[
\widehat{q}^k_t
= -\left(\widehat{r}_t-E_t\widehat{\pi}_{t+1}-\widehat{\varepsilon}^b_t\right)
+ q_1E_t\widehat{r}^k_{t+1}
+ (1-q_1)E_t\widehat{q}^k_{t+1},
\]

where \(q_1=r^k/(r^k+1-\delta)\).

- **(F4) Price Phillips curve with indexation**:

\[
\widehat{\pi}_t-\gamma_p\widehat{\pi}_{t-1}
= \pi_1\left(E_t\widehat{\pi}_{t+1}-\gamma_p\widehat{\pi}_t\right)
-\pi_2\left(\widehat{\mu}_{p,t}-\widehat{\mu}^n_{p,t}\right),
\]

where \(\pi_1=\beta\) and \(\pi_2=(1-\theta_p\beta)(1-\theta_p)/[\theta_p(1+(\phi_p-1)\varepsilon_p)]\).

- **(F5) Average price markup / real marginal cost relation**:

\[
\widehat{mc}_t
= (1-\alpha)(\widehat{w}_t-\widehat{p}_t)
+\alpha\widehat{r}^k_t
+\widehat{\varepsilon}^a_t,
\qquad
\widehat{\mu}_{p,t}\approx-\widehat{mc}_t.
\]

The sign and markup normalization are marked `needs_review` because the Markdown has OCR noise around the inverse marginal-cost sentence.

- **(F6) Natural price markup shock**:

\[
\widehat{\mu}^n_{p,t}=100\,\widehat{\varepsilon}^p_t.
\]

- **(F7) Wage Phillips curve with indexation**:

\[
\Delta\widehat{w}_t
= \gamma_w\widehat{\pi}_{t-1}
+\beta E_t\left(\Delta\widehat{w}_{t+1}-\gamma_w\widehat{\pi}_t\right)
-w_1\left(\widehat{\mu}_{w,t}-\widehat{\mu}^n_{w,t}\right),
\]

where \(w_1=(1-\beta\theta_w)(1-\theta_w)/[\theta_w(1+\epsilon_w\omega)]\).

- **(F8) Average wage markup and unemployment**:

\[
\widehat{\mu}_{w,t}
= \widehat{w}_t-\widehat{p}_t-\left(\widehat{z}_t+\widehat{\varepsilon}^s_t+\omega\widehat{e}_t\right)
= \omega\widehat{u}_t.
\]

- **(F9) Natural wage markup / natural unemployment**:

\[
\widehat{\mu}^n_{w,t}=100\,\widehat{\varepsilon}^w_t
=\omega\widehat{u}^n_t.
\]

- **(F10) Smoothed trend of consumption entering labor supply**:

\[
\widehat{z}_t
=(1-\upsilon)\widehat{z}_{t-1}
+\frac{\upsilon}{1-h/\tau}
\left(\widehat{c}_t-\frac{h}{\tau}\widehat{c}_{t-1}\right).
\]

- **(F11) Capital utilization condition**:

\[
\widehat{v}_t=\frac{1-\psi}{\psi}\widehat{r}^k_t.
\]

- **(F12) Optimal capital-labor input condition**:

\[
\widehat{k}_t
=\widehat{w}_t-\widehat{p}_t-\widehat{r}^k_t+\widehat{n}_t.
\]

## 4. Market Clearing & Identities

- **(F13) Aggregate demand / resource constraint**:

\[
\widehat{y}_t
=c_y\widehat{c}_t+i_y\widehat{i}_t+v_y\widehat{v}_t+\widehat{\varepsilon}^g_t.
\]

- **(F14) Aggregate supply / production function**:

\[
\widehat{y}_t
=\phi_p\left(\alpha\widehat{k}_t+(1-\alpha)\widehat{n}_t+\widehat{\varepsilon}^a_t\right).
\]

- **(F15) Capital accumulation**:

\[
\widehat{\bar{k}}_t
=\kappa_1\widehat{\bar{k}}_{t-1}
+(1-\kappa_1)\widehat{i}_t
+\kappa_2\widehat{\varepsilon}^q_t,
\]

where \(\kappa_1=(1-\delta)/\tau\) and \(\kappa_2=(\tau+\delta-1)(1+\beta)\tau\varphi\).

- **(F16) Capital services**:

\[
\widehat{k}_t=\widehat{v}_t+\widehat{\bar{k}}_{t-1}.
\]

- **(F17) Labor force identity**:

\[
\widehat{l}_t=\widehat{e}_t+\widehat{u}_t.
\]

- **(F18) Employment adjustment / productivity link**:

\[
\widehat{e}_t-\widehat{e}_{t-1}
=E_t\widehat{e}_{t+1}-\widehat{e}_t
+\frac{(1-\beta\theta_e)(1-\theta_e)}{\theta_e}
\left(\widehat{n}_t-\widehat{e}_t\right).
\]

- **(F19) Output gap definition**:

\[
\widehat{y}^{gap}_t=\widehat{y}_t-\widehat{y}^{flex}_t.
\]

The flexible-price-and-wage block mirrors the structural equations without nominal markup distortions; the paper defines the gap as output relative to the flexible-price/wage economy but does not print every flexible-block equation.

- **(F20) Measurement equations for the eight observed variables**:

\[
\begin{bmatrix}
\Delta y_t\\
\Delta c_t\\
\Delta i_t\\
\pi_{y,t}\\
\Delta w_t-\pi_{y,t}\\
\Delta e_t\\
u_t\\
r_t
\end{bmatrix}
=
\begin{bmatrix}
\bar{\tau}+\bar{e}\\
\bar{\tau}+\bar{e}\\
\bar{\tau}+\bar{e}\\
\bar{\pi}\\
\bar{\tau}\\
\bar{e}\\
\bar{u}\\
4\bar{r}
\end{bmatrix}
+
\begin{bmatrix}
\Delta\widehat{y}_t\\
\Delta\widehat{c}_t\\
\Delta\widehat{i}_t\\
\widehat{\pi}_t\\
\Delta\widehat{w}_t-\Delta\widehat{\pi}_t\\
\Delta\widehat{e}_t\\
\widehat{u}_t\\
4\widehat{r}_t
\end{bmatrix}.
\]

The fifth row is `needs_review`: the paper's printed measurement vector and the implementation cross-check differ in whether the wage observation subtracts inflation or the change in inflation.

- **(F21) SPF noise measurement example for annual inflation**:

\[
\pi^a_{t+3|t}
=4\bar{\pi}
+E_t\left[\widehat{\pi}_{t+3}+\widehat{\pi}_{t+2}+\widehat{\pi}_{t+1}+\widehat{\pi}_{t}\right]
+\eta_{\pi,t}.
\]

Analogous noisy measurement equations are added for SPF unemployment three quarters ahead and annual real GDP growth two quarters ahead. Under the news interpretation, the SPF path is imposed as conditioning information through expected future shocks rather than as noisy measurement.

## 5. Exogenous Processes

The paper states the shock list and AR/ARMA classes, and Table 2 reports persistence and MA parameters. The implementation cross-check makes the following process equations explicit:

- **(F22) Risk-premium shock**:

\[
\widehat{\varepsilon}^b_t=\rho_b\widehat{\varepsilon}^b_{t-1}+\eta^b_t.
\]

- **(F23) Investment-specific technology shock**:

\[
\widehat{\varepsilon}^q_t=\rho_q\widehat{\varepsilon}^q_{t-1}+\eta^q_t.
\]

- **(F24) Exogenous spending shock with productivity innovation spillover**:

\[
\widehat{\varepsilon}^g_t=\rho_g\widehat{\varepsilon}^g_{t-1}+\eta^g_t+\rho_{ga}\eta^a_t.
\]

- **(F25) Productivity shock**:

\[
\widehat{\varepsilon}^a_t=\rho_a\widehat{\varepsilon}^a_{t-1}+\eta^a_t.
\]

- **(F26) Price-markup ARMA(1,1) shock**:

\[
\widehat{\varepsilon}^p_t
=\rho_p\widehat{\varepsilon}^p_{t-1}+\eta^p_t-\mu_p\eta^p_{t-1}.
\]

- **(F27) Wage-markup ARMA(1,1) shock**:

\[
\widehat{\varepsilon}^w_t
=\rho_w\widehat{\varepsilon}^w_{t-1}+\eta^w_t-\mu_w\eta^w_{t-1}.
\]

- **(F28) Labor-supply shock**:

\[
\widehat{\varepsilon}^s_t=\rho_s\widehat{\varepsilon}^s_{t-1}+\eta^s_t.
\]

- **(F29) Monetary-policy shock process**:

\[
\widehat{\varepsilon}^r_t=\rho_r\widehat{\varepsilon}^r_{t-1}+\eta^r_t.
\]

- **(F30) Monetary policy rule**:

\[
\widehat{r}_t
=\rho_R\widehat{r}_{t-1}
+(1-\rho_R)
\left(r_\pi\widehat{\pi}_t+r_y\widehat{y}^{gap}_t
+r_{\Delta y}\Delta\widehat{y}^{gap}_t\right)
+\widehat{\varepsilon}^r_t.
\]

The implementation cross-check uses a minus sign before `epsilonr`; this sign convention is `needs_review` against the authors' state-space shock definition.

## 6. Steady-State Solution

Because the model is log-linearized around a balanced growth path, all hatted structural variables have zero steady state:

\[
\widehat{x}=0
\quad\text{for}\quad
x\in\{c,i,q^k,r,\pi,r^k,y,v,k,n,mc,w,z,u,e,l,\bar{k},y^{gap}\}.
\]

The paper reports the steady-state transformations used in measurement equations:

\[
\bar{\tau}=100(\tau-1),\qquad
\bar{\pi}=100(\pi-1),
\]

\[
\bar{r}=100\left(\frac{\pi\tau}{\beta}-1\right),\qquad
\bar{u}=100\left(\frac{\phi_w-1}{\omega}\right).
\]

Calibrated non-estimated parameters include:

\[
g_y=0.18,\qquad \delta=0.025,\qquad \varepsilon_p=10.
\]

Derived ratios used by the implementation cross-check include:

\[
i_y=(\tau+\delta-1)k_y,\qquad
c_y=1-i_y-g_y,\qquad
v_y=r^k k_y.
\]

No nonlinear steady-state solver or Dynare check was run for this archive pass.

## 7. Timing & Form Conventions

- **Linear form**: All model equations are written in log deviations or level deviations from the balanced-growth path and are suitable for `model(linear)`.
- **Capital stock timing**: Installed capital stock \(\widehat{\bar{k}}_t\) is predetermined; production capital services use \(\widehat{\bar{k}}_{t-1}\) plus current utilization \(\widehat{v}_t\).
- **Expectations**: \(E_t\) is conditional on information at time \(t\).
- **Nominal interest and inflation**: The policy rate and inflation variables are deviations; the observed interest rate is annualized in measurement as \(4\widehat{r}_t\) plus its steady-state annual rate.
- **Output gap**: \(\widehat{y}^{gap}_t\) is the difference between actual output and the flexible-price-and-wage counterpart.
- **SPF conditioning**: Noise variants add forecast measurement errors; news variants condition forecasts on expected future structural shocks. These are estimation/forecasting extensions, not a different private-sector equilibrium block.

## 8. Variable & Parameter Reference Table

### Endogenous variables

| Symbol | Meaning | Main equations |
|---|---|---|
| `c` | Consumption deviation \(\widehat{c}_t\) | (F1), (F13), (F20) |
| `r` | Short-term nominal interest-rate deviation \(\widehat{r}_t\) | (F1), (F3), (F30), (F20) |
| `pi` | Inflation deviation \(\widehat{\pi}_t\) | (F1), (F4), (F20), (F30) |
| `i` | Investment deviation \(\widehat{i}_t\) | (F2), (F13), (F15), (F20) |
| `q` | Value of capital \(\widehat{q}^k_t\) | (F2), (F3) |
| `rk` | Rental return on capital \(\widehat{r}^k_t\) | (F3), (F5), (F11), (F12) |
| `y` | Output deviation \(\widehat{y}_t\) | (F13), (F14), (F19), (F20) |
| `v` | Capital utilization \(\widehat{v}_t\) | (F11), (F13), (F16) |
| `k` | Capital services \(\widehat{k}_t\) | (F12), (F14), (F16) |
| `n` | Hours worked \(\widehat{n}_t\) | (F12), (F14), (F18) |
| `mc` | Real marginal cost \(\widehat{mc}_t\) | (F5) |
| `w` | Real wage deviation | (F7), (F8), (F12), (F20) |
| `z` | Smoothed consumption trend | (F8), (F10) |
| `u` | Unemployment deviation | (F8), (F17), (F20) |
| `un` | Natural unemployment deviation | (F9) |
| `e` | Employment deviation | (F8), (F17), (F18), (F20) |
| `l` | Labor force deviation | (F17) |
| `kbar` | Installed capital stock | (F15), (F16) |
| `ygap` | Output gap | (F19), (F30) |
| `dyobs`, `dcobs`, `diobs`, `piobs`, `dwobs`, `deobs`, `uobs`, `robs` | Observed data equations | (F20) |
| `epsilonb`, `epsilonq`, `epsilong`, `epsilona`, `epsilonp`, `epsilons`, `epsilonw`, `epsilonr` | Structural shock states | (F22)-(F29) |
| `cf`, `rf`, `invf`, `qf`, `rkf`, `vf`, `kf`, `nf`, `wf`, `zf`, `ef`, `kbarf`, `yf` | Flexible-price/wage counterparts | (F19), implementation cross-check |

### Exogenous innovations

| Symbol | Meaning |
|---|---|
| `etab` | Risk-premium innovation \(\eta^b_t\) |
| `etaq` | Investment-specific technology innovation \(\eta^q_t\) |
| `etag` | Exogenous-spending innovation \(\eta^g_t\) |
| `etaa` | Productivity innovation \(\eta^a_t\) |
| `etap` | Price-markup innovation \(\eta^p_t\) |
| `etas` | Labor-supply innovation \(\eta^s_t\) |
| `etaw` | Wage-markup innovation \(\eta^w_t\) |
| `etar` | Monetary-policy innovation \(\eta^r_t\) |

### Parameters

| Symbol | Meaning |
|---|---|
| `h` / `ch` | Habit parameter |
| `tau` / `ctau` | Trend growth rate |
| `beta` / `cbeta` | Discount factor |
| `varphi` / `cphi` | Capital adjustment-cost elasticity |
| `delta` / `cdelta` | Depreciation |
| `phi_p` / `cpsip` | Fixed-cost/production scale parameter |
| `alpha` / `calpha` | Cobb-Douglas capital share |
| `gamma_p`, `theta_p`, `epsilon_p` | Price indexation, Calvo price stickiness, price aggregator curvature |
| `gamma_w`, `theta_w`, `epsilon_w` | Wage indexation, Calvo wage stickiness, wage aggregator curvature |
| `omega` / `comega` | Inverse labor-supply elasticity |
| `upsilon` / `cv` | Short-run wealth-effect smoothing parameter |
| `psi` / `cpsi` | Capital-utilization cost elasticity |
| `rho_R`, `r_pi`, `r_y`, `r_Delta_y` | Monetary policy rule coefficients |
| `theta_e` | Employment adjustment parameter |
| `rho_*`, `mu_p`, `mu_w` | Shock persistence and MA parameters |
| `bar_tau`, `bar_pi`, `bar_r`, `bar_u`, `bar_e` | Measurement steady-state constants |
