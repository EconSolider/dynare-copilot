# US_MI07 -- Derivation (Optimization Problems + First-Order Conditions)

> Private MMB archive entry. Runtime validation was not performed. First-pass formula status: `needs_review`.

Source: Fabio Milani (2007), "Expectations, learning and macroeconomic persistence," Journal of Monetary Economics 54(7), 2065-2082. DOI: `10.1016/j.jmoneco.2006.11.007`.

## 1. Model Overview

- **Model**: `US_MI07`, an estimated small New Keynesian model for the United States with subjective expectations and constant-gain learning.
- **Experiment**: Bayesian estimation and state-space likelihood evaluation on quarterly U.S. output gap, inflation, and nominal interest rate data. The archive entry records the structural model and the learning expectations block; no Dynare run was executed.
- **Agents and blocks**: representative households generate a dynamic IS relation with internal habit formation; Calvo price-setting firms generate an indexed Phillips curve; the central bank follows an interest-rate smoothing Taylor rule; private agents forecast inflation, output gap, and the policy rate using a perceived law of motion updated by constant-gain recursive least squares.
- **Form**: log-linear state-space model. The paper's learning model is linear in deviations; the Rep-MMB implementation cross-check is a rational-expectations `model(linear)` version of the same aggregate equations and does not implement the learning recursion.
- **Core variables**: output gap \(x_t\), inflation \(\pi_t\), nominal rate \(i_t\), natural-rate/demand shock \(r_t^n\), cost-push shock \(u_t\), subjective expectation operator \(\widehat{E}_t\), and learning coefficients \((a_t,b_t,c_t,d_t)\).

## 2. Optimization Problems

The paper presents the aggregate log-linear equilibrium conditions rather than a full nonlinear household-firm derivation. The optimizing foundations are therefore recorded at the block level.

### 2.1 Households

Households have intertemporal preferences with internal habit formation in private expenditures. Linearizing the Euler condition around steady state yields the dynamic IS equation in Section 3. The habit stock enters through the transformed output-gap term \(\widetilde{x}_t\).

### 2.2 Price-Setting Firms

Firms set prices under Calvo frictions. Non-reoptimizing firms may index to lagged inflation. Linearizing optimal price-setting yields the New Keynesian Phillips curve in Section 3, where \(\xi_p\) is inversely related to price stickiness, \(\omega\) controls real marginal-cost sensitivity to output, and \(\gamma\) is the indexation parameter.

### 2.3 Central Bank

The monetary authority follows a mechanical Taylor rule with interest-rate smoothing. It is not an optimizing block and is listed with equilibrium conditions rather than as a private optimization problem.

### 2.4 Expectations and Learning

Private agents behave as econometricians. They estimate a perceived law of motion for \(Z_t=[\pi_t,x_t,i_t]'\) using lagged endogenous variables and current structural shocks. Coefficients are updated by constant-gain recursive least squares and then used to form subjective forecasts.

## 3. First-Order Conditions

- **(F1) Dynamic IS relation with habit formation**:

\[
\widetilde{x}_t
= \widehat{E}_t\widetilde{x}_{t+1}
- (1-\beta\eta)\sigma\left(i_t-\widehat{E}_t\pi_{t+1}-r_t^n\right)
\]

- **(F2) Indexed New Keynesian Phillips curve**:

\[
\widetilde{\pi}_t
= \xi_p\left[\omega x_t+\left((1-\eta\beta)\sigma\right)^{-1}\widetilde{x}_t\right]
+\beta\widehat{E}_t\widetilde{\pi}_{t+1}+u_t
\]

- **(F3) Taylor rule with interest-rate smoothing**:

\[
i_t
= \rho i_{t-1}
+(1-\rho)\left(\chi_{\pi}\pi_t+\chi_x x_t\right)
+\varepsilon_t
\]

The paper also studies a rational-expectations comparison model by replacing \(\widehat{E}_t\) in (F1)-(F2) with \(E_t\). That comparison is not the primary `US_MI07` learning entry but is recorded in the notes because the Rep-MMB `.mod` implements a rational-expectations linear version.

## 4. Market Clearing & Identities

- **(F4) Inflation indexation transformation**:

\[
\widetilde{\pi}_t \equiv \pi_t-\gamma\pi_{t-1}
\]

- **(F5) Habit-adjusted output-gap transformation**:

\[
\widetilde{x}_t
\equiv (x_t-\eta x_{t-1})
-\beta\eta\widehat{E}_t(x_{t+1}-\eta x_t)
\]

- **(F6) Perceived law of motion for forecast variables**:

\[
Z_t=a_t+b_t Z_{t-1}+c_t u_t+d_t r_t^n+\varepsilon_t,\qquad
Z_t\equiv[\pi_t,x_t,i_t]'
\]

- **(F7) Constant-gain coefficient update**:

\[
\widehat{\boldsymbol{\phi}}_t
=\widehat{\boldsymbol{\phi}}_{t-1}
+\bar{g}R_{t-1}^{-1}X_t
\left(Z_t-X_t'\widehat{\boldsymbol{\phi}}_{t-1}\right)
\]

- **(F8) Second-moment matrix update**:

\[
R_t=R_{t-1}+\bar{g}\left(X_{t-1}X_{t-1}'-R_{t-1}\right)
\]

- **(F9) Subjective multi-step forecast formula** (`needs_review`: the OCR/source formula uses an \(I_5\) identity although \(Z_t\) is defined as three-dimensional; preserve this for review):

\[
\begin{aligned}
\widehat{E}_t Z_T
&=(I_5-b_t)^{-1}(I_5-b_t^{T-t})a_t+b_t^{T-t}E_tZ_t \\
&\quad+\phi_u u_t(\phi_u I_5-b_t)^{-1}(\phi_u^{T-t}I_5-b_t^{T-t})c_t \\
&\quad+\phi_r r_t^n(\phi_r I_5-b_t)^{-1}(\phi_r^{T-t}I_5-b_t^{T-t})d_t,\qquad T>t .
\end{aligned}
\]

- **(F10) State-space actual law of motion**:

\[
\xi_t=A_t+F_t\xi_{t-1}+G_t w_t,\qquad Y_t=H\xi_t
\]

with \(\xi_t=[x_t,\pi_t,i_t,u_t,r_t^n]\) and \(w_t\sim N(0,Q)\).

## 5. Exogenous Processes

- **(F11) Natural real interest rate / demand shock**:

\[
r_t^n=\phi^r r_{t-1}^n+v_t^r,\qquad v_t^r\sim iid(0,\sigma_r^2)
\]

- **(F12) Cost-push shock**:

\[
u_t=\phi^u u_{t-1}+v_t^u,\qquad v_t^u\sim iid(0,\sigma_u^2)
\]

- **(F13) Monetary-policy innovation**:

\[
\varepsilon_t\sim iid(0,\sigma_{\varepsilon}^2)
\]

The robust time-varying-policy extension adds an inflation target process, but that extension is not the baseline archive equation set.

## 6. Steady-State Solution

The model is log-linear/state-space. Steady state is the zero-deviation point for endogenous gaps and shocks:

\[
\bar{x}=0,\quad \bar{\pi}=0,\quad \bar{i}=0,\quad \bar{r}^n=0,\quad \bar{u}=0,
\quad \bar{\widetilde{x}}=0,\quad \bar{\widetilde{\pi}}=0 .
\]

At zero shock innovations:

\[
\bar{v}^r=\bar{v}^u=\bar{\varepsilon}=0 .
\]

The perceived-law coefficients and second-moment matrix have no closed-form steady-state solution in the paper-side derivation. The paper notes that learning beliefs converge asymptotically toward rational-expectations beliefs as \(\bar{g}\to0\), but finite-sample learning is not identical to rational expectations. This belief steady state is marked `needs_review` for future source-level or implementation-level reconstruction.

Posterior mean estimates from the paper's learning baseline include:

| Parameter | Posterior mean |
|---|---:|
| \(\eta\) | 0.117 |
| \(\beta\) | 0.990 |
| \(\sigma\) | 0.748 |
| \(\gamma\) | 0.032 |
| \(\xi_p\) | 0.016 |
| \(\omega\) | 0.865 |
| \(\rho\) | 0.914 |
| \(\chi_{\pi}\) | 1.484 |
| \(\chi_x\) | 0.801 |
| \(\phi_r\) | 0.845 |
| \(\phi_u\) | 0.854 |
| \(\sigma_{\varepsilon}\) | 0.860 |
| \(\sigma_r\) | 1.670 |
| \(\sigma_u\) | 1.150 |
| \(\bar{g}\) | 0.0183 |

The implementation cross-check file instead calibrates the rational-expectations comparison model with large habit/indexation values; those values are not used as paper-side evidence for the learning entry.

## 7. Timing & Form Conventions

- Variables are log deviations or rates used in a linear state-space system; the Rep-MMB cross-check uses `model(linear)`.
- \(x_t\), \(\pi_t\), and \(i_t\) are contemporaneous output gap, inflation, and nominal interest rate.
- \(\widetilde{x}_t\) depends on \(x_t\), \(x_{t-1}\), and the subjective forecast of \(x_{t+1}\).
- \(\widetilde{\pi}_t\) depends on current inflation and lagged inflation.
- Agents observe endogenous variables through \(t-1\), current shocks at \(t\), and use parameter estimates from \(t-1\) when forming forecasts for \(t+1\) and \(t+2\).
- There are no capital stocks or production-side physical stocks in this small log-linear aggregate model.
- Runtime validation: not performed; Dynare was not run.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Equation reference |
|---|---|---|---|
| Endogenous | \(x_t\) / `x` | Output gap | (F1), (F2), (F3), (F5), (F10) |
| Endogenous | \(\pi_t\) / `pi` | Inflation | (F2), (F3), (F4), (F10) |
| Endogenous | \(i_t\) / `i` | Nominal interest rate | (F1), (F3), (F10) |
| Endogenous | \(\widetilde{x}_t\) / `x_tilde` | Habit-adjusted output-gap term | (F1), (F2), (F5) |
| Endogenous | \(\widetilde{\pi}_t\) / `pi_tilde` | Indexed inflation term | (F2), (F4) |
| Endogenous/state | \(r_t^n\) / `r_n` | Natural real interest rate / demand shock | (F1), (F6), (F9), (F10), (F11) |
| Endogenous/state | \(u_t\) / `u` | Cost-push shock | (F2), (F6), (F9), (F10), (F12) |
| Learning object | \(Z_t\) | Forecast-variable vector \([\pi_t,x_t,i_t]'\) | (F6), (F9) |
| Learning object | \(a_t,b_t,c_t,d_t\) | PLM coefficients | (F6)-(F9) |
| Learning object | \(R_t\) | Regressor second-moment matrix | (F7), (F8) |
| Exogenous shock | \(v_t^r\) / `v_r` | Natural-rate/demand innovation | (F11) |
| Exogenous shock | \(v_t^u\) / `v_u` | Cost-push innovation | (F12) |
| Exogenous shock | \(\varepsilon_t\) | Monetary-policy innovation | (F3), (F13) |
| Parameter | \(\eta\) / `eta` | Habit formation | (F1), (F5) |
| Parameter | \(\beta\) / `beta` | Discount factor | (F1), (F2), (F5) |
| Parameter | \(\sigma\) / `sigma` | Intertemporal-substitution coefficient | (F1), (F2) |
| Parameter | \(\gamma\) / `gamma` | Inflation indexation | (F4) |
| Parameter | \(\xi_p\) / `xi_p` | Price-stickiness slope parameter | (F2) |
| Parameter | \(\omega\) / `omega` | Marginal-cost/output elasticity term | (F2) |
| Parameter | \(\rho\) / `rho_i` | Interest-rate smoothing | (F3) |
| Parameter | \(\chi_{\pi}\) / `rho_pi` | Taylor-rule inflation response | (F3) |
| Parameter | \(\chi_x\) / `rho_x` | Taylor-rule output-gap response | (F3) |
| Parameter | \(\phi_r\) / `phi_r` | Natural-rate shock persistence | (F9), (F11) |
| Parameter | \(\phi_u\) / `phi_u` | Cost-push shock persistence | (F9), (F12) |
| Parameter | \(\bar{g}\) | Constant learning gain | (F7), (F8) |
| Parameter | \(\sigma_{\varepsilon},\sigma_r,\sigma_u\) | Shock standard deviations | (F11)-(F13) |
