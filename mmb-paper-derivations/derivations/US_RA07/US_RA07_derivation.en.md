# US_RA07 - Derivation (Optimization Problems + First-Order Conditions)

> Model archive entry for `US_RA07`. Source: Pau Rabanal (2007), "Does inflation increase after a monetary policy tightening? Answers based on an estimated DSGE model", *Journal of Economic Dynamics & Control* 31(3), 906-937, DOI `10.1016/j.jedc.2006.01.008`.

## 1. Model Overview

- **Model**: estimated U.S. medium-scale New Keynesian DSGE model with a working-capital cost channel of monetary policy.
- **Purpose**: evaluate whether inflation can rise after a contractionary monetary policy shock when the nominal interest rate enters production costs.
- **Agents and blocks**: differentiated households, intermediate-goods firms, final-goods firms, fiscal authority, and monetary authority.
- **Rigidities**: Calvo price and wage setting, backward-looking price and wage indexation, external habit formation in consumption, variable capital utilization, and investment adjustment costs.
- **Shocks**: monetary policy, technology, fiscal spending, and price-markup shocks.
- **Form**: `model(linear)`. The paper presents nonlinear primitives, then uses log-linear equilibrium conditions around a zero-inflation symmetric steady state. Lowercase variables are log deviations except the real wage variable, denoted \(\omega_t\) in the paper.
- **Runtime validation**: not performed. Dynare was not run for this archive entry.

## 2. Optimization Problems

### Intermediate-Goods Producers

Intermediate firm \(i\) produces with capital services and differentiated labor:

\[
Y^i_t = A_t (u_t K_{i,t})^\alpha N_{i,t}^{1-\alpha}.
\]

Labor is a CES aggregate of household-specific labor types:

\[
N_{i,t} =
\left[\int_0^1 (N^j_{i,t})^{(\phi-1)/\phi}\,dj\right]^{\phi/(\phi-1)}.
\]

The cost-channel assumption applies to a fraction \(\gamma\) of firms: these firms borrow at the gross nominal interest rate to pay the wage bill before selling output. This makes the nominal rate a component of effective labor cost.

### Final-Goods Producers

Competitive final-goods firms aggregate differentiated intermediate goods:

\[
Y_t =
\left[\int_0^1 (Y^i_t)^{(\lambda_t-1)/\lambda_t}\,di\right]^{\lambda_t/(\lambda_t-1)}.
\]

Profit maximization implies the standard CES demand curve for each intermediate good.

### Households

Household \(j\) maximizes external-habit utility:

\[
E_0\sum_{t=0}^{\infty}\beta^t
\left[
\frac{(C^j_t-bC_{t-1})^{1-\sigma}}{1-\sigma}
-\frac{(N^j_t)^{1+\eta}}{1+\eta}
\right],
\]

subject to a nominal bond, capital, utilization, investment, wage-income, transfer, and profit-income budget constraint:

\[
C^j_t + I^j_t + \frac{B^j_t}{P_tR_t}
= \frac{W^j_tN^j_t}{P_t}+\frac{B^j_{t-1}}{P_t}
+[R^k_tu_t-\Psi(u_t)]K^j_{t-1}+T^j_t+\int_0^1\Pi^j_t(i)\,di.
\]

Capital evolves according to the investment-adjustment-cost law:

\[
K_t=(1-\delta)K_{t-1}+\left[1-S\left(\frac{I_t}{I_{t-1}}\right)\right]I_t.
\]

### Price and Wage Setters

Intermediate firms reset prices with Calvo probability \(1-\theta_p\); non-resetting firms index to lagged inflation with weight \(\omega_p\). Households reset wages with probability \(1-\theta_w\); non-resetting wage setters index to lagged price inflation with weight \(\omega_w\).

### Policy Authorities

Fiscal policy is Ricardian and clears government purchases through lump-sum transfers and bond issuance. Monetary policy follows an interest-rate rule reacting to inflation and output deviations, with interest-rate smoothing.

## 3. First-Order Conditions

- **(F1) Price Phillips curve**:

\[
\Delta p_t =
\gamma_b\Delta p_{t-1}
+\gamma_f E_t\Delta p_{t+1}
+\kappa_p mc_t
+\kappa_p\varepsilon^p_t.
\]

with \(\gamma_b=\omega_p/(1+\beta\omega_p)\), \(\gamma_f=\beta/(1+\beta\omega_p)\), and
\(\kappa_p=(1-\theta_p\beta)(1-\theta_p)/[(1+\beta\omega_p)\theta_p]\).

- **(F2) Real marginal cost with cost channel**:

\[
mc_t=\alpha r^k_t+(1-\alpha)(\omega_t+\gamma r_t)-a_t.
\]

Here \(\gamma r_t\) is the working-capital component. This is source-stated in the linearized model and is the key cost-channel term.

- **(F3) Capital utilization condition**:

\[
u_t=\psi r^k_t.
\]

The paper defines \(\psi=\Psi'(1)/\Psi''(1)\) under steady-state utilization equal to one. `needs_review`: the OCR renders some utilization-cost notation imperfectly in the nonlinear primitive.

- **(F4) Wage Phillips curve**:

\[
\begin{aligned}
(1+\beta)\omega_t
=&\ \omega_{t-1}+\beta E_t\omega_{t+1}
+\omega_w\Delta p_{t-1}
-(1+\beta\omega_w)\Delta p_t
+\beta E_t\Delta p_{t+1} \\
&-\kappa_w\left[
\omega_t-\frac{\sigma}{1-b}(c_t-bc_{t-1})-\eta n_t
\right].
\end{aligned}
\]

with \(\kappa_w=(1-\theta_w\beta)(1-\theta_w)/\{[1+\phi(\eta-1)]\theta_w\}\). `needs_review`: the OCR uses \(\omega_{\mathrm{w}}\) and \(\omega_t\) close together; the normalized notation follows the paper's intended wage-indexation and real-wage variables.

- **(F5) Optimal capital-labor ratio**:

\[
l_t-u_t-k_{t-1}=r^k_t-(\omega_t+\gamma r_t).
\]

The cost-channel term increases the effective marginal cost of labor for the affected firms.

- **(F6) Consumption Euler equation with external habit**:

\[
(1+b)c_t=bc_{t-1}+E_tc_{t+1}
-(1-b)\sigma^{-1}\left(r_t-E_t\Delta p_{t+1}\right).
\]

- **(F7) Tobin's Q equation**:

\[
q_t=\beta(1-\delta)E_tq_{t+1}
+[1-\beta(1-\delta)]E_tr^k_{t+1}
-\left(r_t-E_t\Delta p_{t+1}\right).
\]

- **(F8) Capital accumulation**:

\[
k_t=(1-\delta)k_{t-1}+\delta i_t.
\]

- **(F9) Investment adjustment-cost condition**:

\[
i_t=\frac{1}{1+\beta}\left(\beta E_ti_{t+1}+i_{t-1}+\varphi q_t\right).
\]

The paper defines \(\varphi=1/\bar S''\).

- **(F10) Production function**:

\[
y_t=a_t+\alpha(u_t+k_{t-1})+(1-\alpha)n_t.
\]

- **(F11) Monetary policy rule**:

\[
r_t=\rho_r r_{t-1}
+(1-\rho_r)\gamma_p\Delta p_t
+(1-\rho_r)\gamma_y y_t
+\varepsilon^z_t.
\]

The policy shock \(\varepsilon^z_t\) is iid and enters the rule directly.

## 4. Market Clearing & Identities

- **(F12) Aggregate resource constraint**:

\[
y_t=(1-\bar I-\bar G)c_t+\bar I i_t+\bar G g_t
+\alpha\frac{\bar\lambda}{\bar\lambda-1}u_t.
\]

where

\[
\bar I=
\frac{\delta\alpha\bar\lambda}
{(\bar\lambda-1)[1/\beta-(1-\delta)]}.
\]

- **Labor notation identity** (`implementation_cross_check`) :

\[
n_t=l_t.
\]

This identity is not a separate paper-side equilibrium equation in the published linearized list. The MMB implementation adds it because the paper uses inconsistent notation for labor in the capital-labor-ratio condition. It is recorded here only as an implementation cross-check.

## 5. Exogenous Processes

- **(F13) Technology shock**:

\[
a_t=\rho_a a_{t-1}+\varepsilon^a_t.
\]

- **(F14) Fiscal spending shock**:

\[
g_t=\rho_g g_{t-1}+\varepsilon^g_t.
\]

- **(F15) Price-markup shock**:

\[
\varepsilon^p_t \sim iid,\qquad E[\varepsilon^p_t]=0.
\]

The monetary policy shock \(\varepsilon^z_t\) is iid and appears in (F11). The paper states that monetary and price-markup shocks are serially uncorrelated; technology and fiscal shocks follow AR(1) processes.

## 6. Steady-State Solution

Because `US_RA07` is represented as a log-linear `model(linear)` entry, steady-state deviations are zero:

\[
\Delta p = mc = r^k = \omega = r = a = u = n = c = l = q = i = k = y = g = 0.
\]

Source-backed fixed steady-state/calibration values include:

- \(\beta=0.99\) in estimation and \(\beta=0.9926\) in the CEE-style calibration exercise and MMB implementation baseline.
- \(\delta=0.025\) quarterly depreciation.
- \(\alpha=0.36\) capital share.
- \(\bar G=0.2\) government consumption-output ratio.
- \(\bar\lambda=6\) steady-state elasticity of substitution.
- \(\bar I=\delta\alpha\bar\lambda/\{(\bar\lambda-1)[1/\beta-(1-\delta)]\}\).

`needs_review`: exact alignment between the paper's fixed values, the posterior baseline values in Table 2, and the MMB implementation's figure-specific parameter blocks should be reviewed before any runtime validation.

## 7. Timing & Form Conventions

- **Linear form**: all equilibrium equations above are log-linear deviations around the symmetric zero-inflation steady state.
- **Inflation**: \(\Delta p_t\) is inflation, not the price level.
- **Real wage**: the paper uses \(\omega_t\) for real wage; the MMB implementation maps this to `w`.
- **Capital timing**: \(k_{t-1}\) is predetermined beginning-of-period capital used in production; \(k_t\) is the end-of-period capital stock after investment.
- **Capital utilization**: \(u_t\) is chosen in the period and affects current capital services.
- **Interest rate**: \(r_t\) is the nominal policy-rate deviation in the linearized rule and enters real rates through expected inflation terms.
- **Implementation cross-check**: `.agents/skills/dynare-copilot/references/examples/US_RA07_rep.mod` confirms a 15-variable `model(linear)` implementation with shocks `epsp`, `epsz`, `epsa`, and `epsg`. This `.mod` was not used as a paper-side mathematical source and Dynare was not run.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Equation reference |
|---|---|---|---|
| Endogenous | `pi`, \(\Delta p_t\) | inflation | (F1), (F11) |
| Endogenous | `mc`, \(mc_t\) | real marginal cost | (F1), (F2) |
| Endogenous | `rk`, \(r^k_t\) | rental rate of capital | (F2), (F3), (F5), (F7) |
| Endogenous | `w`, \(\omega_t\) | real wage | (F2), (F4), (F5) |
| Endogenous | `r`, \(r_t\) | nominal policy interest rate deviation | (F2), (F6), (F7), (F11) |
| Endogenous | `a`, \(a_t\) | technology state | (F2), (F10), (F13) |
| Endogenous | `u`, \(u_t\) | capital utilization | (F3), (F5), (F10), (F12) |
| Endogenous | `n`, \(n_t\) | labor input | (F4), (F10), implementation identity |
| Endogenous | `c`, \(c_t\) | consumption | (F4), (F6), (F12) |
| Endogenous | `l`, \(l_t\) | labor notation used in capital-labor ratio | (F5), implementation identity |
| Endogenous | `q`, \(q_t\) | Tobin's Q | (F7), (F9) |
| Endogenous | `i`, \(i_t\) | investment | (F8), (F9), (F12) |
| Endogenous | `k`, \(k_t\) | capital stock | (F5), (F8), (F10) |
| Endogenous | `y`, \(y_t\) | output | (F10), (F11), (F12) |
| Endogenous | `g`, \(g_t\) | government spending | (F12), (F14) |
| Exogenous | `epsp`, \(\varepsilon^p_t\) | price-markup innovation | (F1), (F15) |
| Exogenous | `epsz`, \(\varepsilon^z_t\) | monetary policy innovation | (F11) |
| Exogenous | `epsa`, \(\varepsilon^a_t\) | technology innovation | (F13) |
| Exogenous | `epsg`, \(\varepsilon^g_t\) | fiscal innovation | (F14) |
| Parameter | \(\beta\) / `beta` | discount factor | (F1), (F4), (F6), (F7), (F9) |
| Parameter | \(\omega_p\) / `omegap` | price indexation | (F1) |
| Parameter | \(\theta_p\) / `thetap` | Calvo price non-reset probability | (F1) |
| Parameter | \(\bar\lambda\) / `lambdaSS` | steady-state substitution elasticity | (F12) |
| Parameter | \(\alpha\) / `alpha` | capital share | (F2), (F10), (F12) |
| Parameter | \(\gamma\) / `gamma` | cost-channel share/elasticity | (F2), (F5) |
| Parameter | \(\psi\) / `psi` | utilization elasticity parameter | (F3) |
| Parameter | \(\omega_w\) / `omegaw` | wage indexation | (F4) |
| Parameter | \(\theta_w\) / `thetaw` | Calvo wage non-reset probability | (F4) |
| Parameter | \(\sigma\) / `sigma` | intertemporal substitution/utility curvature | (F4), (F6) |
| Parameter | \(b\) / `b` | external habit parameter | (F4), (F6) |
| Parameter | \(\eta\) / `eta` | inverse labor-supply elasticity | (F4) |
| Parameter | \(\phi\) / `phi` | labor substitution elasticity | (F4) |
| Parameter | \(\delta\) / `delta` | depreciation rate | (F7), (F8), (F12) |
| Parameter | \(\varphi\) / `vaphi` | investment response to Tobin's Q | (F9) |
| Parameter | \(\rho_r\) / `rhor` | interest-rate smoothing | (F11) |
| Parameter | \(\gamma_p\) / `gammap` | Taylor-rule inflation response | (F11) |
| Parameter | \(\gamma_y\) / `gammay` | Taylor-rule output response | (F11) |
| Parameter | \(\bar I\) / `ISS` | investment-output steady-state ratio | (F12) |
| Parameter | \(\bar G\) / `GSS` | government-output steady-state ratio | (F12) |
| Parameter | \(\rho_a\) / `rhoa` | technology persistence | (F13) |
| Parameter | \(\rho_g\) / `rhog` | fiscal-spending persistence | (F14) |
