# US_IR11 -- A New Keynesian Perspective on the Great Recession

> Archive status: `needs_review`. Runtime validation was not performed. The MMB `.mod` file was used only as `implementation_cross_check`, not as a paper-side source.

Source provenance: Peter N. Ireland (2011), "A New Keynesian Perspective on the Great Recession," Journal of Money, Credit and Banking 43(1), 31-54, DOI `10.1111/j.1538-4616.2010.00364.x`. Primary MinerU Markdown: `raw/mmb_mineru/runs/us_ir11__a_new_keynesian_perspective_on_the_great_recession__fee43648/full.md`. Raw PDF: `raw/mmb_papers/A New Keynesian perspective on the Great Recession.pdf`.

## 1. Model Overview

US_IR11 is an estimated small-scale New Keynesian model for the United States, designed to compare the 2007-09 Great Recession with the 1990-91 and 2001 recessions. The model has a representative household, a representative finished-goods producer, a continuum of monopolistically competitive intermediate-goods producers with Rotemberg price adjustment costs, a central bank following a first-difference Taylor rule, and a social planner block used to define the efficient level of output and the output gap.

The empirical model is the paper's log-linear stationary system. It has habit formation in consumption, partial indexation in price adjustment, a preference shock, a renormalized cost-push shock, a technology growth shock, and a monetary policy shock. The paper derives the nonlinear household, firm, policy, and planner equations first, then transforms real variables by the nonstationary technology level and log-linearizes the stationary system.

Model form: `model(linear)` / log-linear percentage-deviation system. Steady-state deviations are zero in the MMB implementation. The source-level nonlinear model is present in the paper, but the archive entry follows the log-linear system (paper equations 21-30) because that is the model solved and estimated.

## 2. Optimization Problems

### Representative Household

The household chooses consumption, labor, nominal bonds, and money balances subject to a nominal budget constraint. Preferences include external habit formation in consumption and additively separable real balances and labor:

$$
E_0 \sum_{t=0}^{\infty} \beta^t a_t
\left[\ln(C_t-\gamma C_{t-1})+\ln(M_t/P_t)-h_t\right].
$$

The budget constraint is:

$$
\frac{M_{t-1}+T_t+B_{t-1}+W_t h_t+D_t}{P_t}
\ge C_t+\frac{M_t+B_t/r_t}{P_t}.
$$

### Finished-Goods Producer

The finished-goods producer chooses differentiated intermediate inputs $Y_t(i)$ to maximize static profits under the CES aggregator:

$$
\left[\int_0^1 Y_t(i)^{(\theta_t-1)/\theta_t}\,di\right]^{\theta_t/(\theta_t-1)}
\ge Y_t.
$$

The markup parameter $\theta_t$ is stochastic and later renormalized into the cost-push shock used in the linear system.

### Intermediate-Goods Producer

Each intermediate-goods producer hires labor and produces with a linear technology:

$$
Z_t h_t(i) \ge Y_t(i).
$$

The firm sets its nominal price subject to demand from the finished-goods producer and Rotemberg price adjustment costs:

$$
\frac{\phi}{2}
\left[
\frac{P_t(i)}{\pi_{t-1}^{\alpha}\pi^{1-\alpha}P_{t-1}(i)}-1
\right]^2Y_t.
$$

The firm's dynamic objective is proportional to expected discounted real dividends:

$$
E_0\sum_{t=0}^{\infty}\beta^t\Lambda_t[D_t(i)/P_t].
$$

### Social Planner for Efficient Output

The social planner chooses efficient output $Q_t$ and labor allocations $n_t(i)$, using the same household preference ordering over consumption and labor, subject to the aggregate production feasibility constraint. This block is not the competitive equilibrium allocation; it defines $Q_t$ and the output gap.

## 3. First-Order Conditions

The equilibrium conditions below are numbered continuously as archive equations. They combine the source model's nonlinear equations with the paper's estimated log-linear system. Entries marked `needs_review` should be source-checked against the PDF before promotion.

### Household and Static Production Conditions

**(F1) Household marginal utility of wealth from consumption and habit**

$$
\Lambda_t =
\frac{a_t}{C_t-\gamma C_{t-1}}
-\beta\gamma E_t\left[
\frac{a_{t+1}}{C_{t+1}-\gamma C_t}
\right].
$$

**(F2) Labor supply condition**

$$
a_t=\Lambda_t(W_t/P_t).
$$

**(F3) Nominal bond Euler equation**

$$
\Lambda_t=\beta r_t E_t\left(\Lambda_{t+1}/\pi_{t+1}\right).
$$

**(F4) Money demand condition**

$$
M_t/P_t=(a_t/\Lambda_t)\left[r_t/(r_t-1)\right].
$$

**(F5) Finished-goods demand for intermediate input**

$$
Y_t(i)=\left[P_t(i)/P_t\right]^{-\theta_t}Y_t.
$$

**(F6) Aggregate price index**

$$
P_t=\left[\int_0^1 P_t(i)^{1-\theta_t}\,di\right]^{1/(1-\theta_t)}.
$$

**(F7) Intermediate-goods production**

$$
Z_t h_t(i)=Y_t(i).
$$

**(F8) Rotemberg pricing FOC (`needs_review`: OCR formula is long and should be PDF-checked)**

$$
\begin{aligned}
0={}&(1-\theta_t)\left[\frac{P_t(i)}{P_t}\right]^{-\theta_t}
+\theta_t\left[\frac{P_t(i)}{P_t}\right]^{-\theta_t-1}
\left(\frac{W_t}{P_tZ_t}\right)\\
&-\phi
\left[
\frac{P_t(i)}{\pi_{t-1}^{\alpha}\pi^{1-\alpha}P_{t-1}(i)}-1
\right]
\left[
\frac{P_t(i)}{\pi_{t-1}^{\alpha}\pi^{1-\alpha}P_{t-1}(i)}
\right]\\
&+\beta\phi E_t\left\{
\left(\frac{\Lambda_{t+1}}{\Lambda_t}\right)
\left[
\frac{P_{t+1}(i)}{\pi_t^{\alpha}\pi^{1-\alpha}P_t(i)}-1
\right]
\left[
\frac{P_{t+1}(i)}{\pi_t^{\alpha}\pi^{1-\alpha}P_t(i)}
\right]
\left[
\frac{P_tY_{t+1}}{P_t(i)Y_t}
\right]\right\}.
\end{aligned}
$$

### Log-Linear Estimated System

Variables with hats denote log deviations from the steady-state growth path after the transformations $y_t=Y_t/Z_t$, $c_t=C_t/Z_t$, $q_t=Q_t/Z_t$, $\lambda_t=Z_t\Lambda_t$, and $z_t=Z_t/Z_{t-1}$.

**(F9) Preference shock**

$$
\hat a_t=\rho_a\hat a_{t-1}+\varepsilon_{at}.
$$

**(F10) Marginal utility / habit relation**

$$
\begin{aligned}
(z-\beta\gamma)(z-\gamma)\hat\lambda_t
={}&\gamma z\hat y_{t-1}
-(z^2+\beta\gamma^2)\hat y_t
+\beta\gamma z E_t\hat y_{t+1}\\
&+(z-\beta\gamma\rho_a)(z-\gamma)\hat a_t
-\gamma z\hat z_t.
\end{aligned}
$$

**(F11) New Keynesian IS curve**

$$
\hat\lambda_t=\hat r_t+E_t\hat\lambda_{t+1}-E_t\hat\pi_{t+1}.
$$

**(F12) Renormalized cost-push shock (`needs_review`: renormalization should be checked against paper equation text and implementation notes)**

$$
\hat e_t=\rho_e\hat e_{t-1}+\varepsilon_{et}.
$$

**(F13) Technology growth shock**

$$
\hat z_t=\varepsilon_{zt}.
$$

**(F14) New Keynesian Phillips curve**

$$
(1+\beta\alpha)\hat\pi_t
=\alpha\hat\pi_{t-1}
+\beta E_t\hat\pi_{t+1}
-\psi\hat\lambda_t
+\psi\hat a_t
+\hat e_t.
$$

**(F15) First-difference Taylor rule**

$$
\hat r_t-\hat r_{t-1}
=\rho_{\pi}\hat\pi_t+\rho_g\hat g_t+\varepsilon_{rt}.
$$

**(F16) Output growth identity**

$$
\hat g_t=\hat y_t-\hat y_{t-1}+\hat z_t.
$$

**(F17) Efficient output relation**

$$
0=\gamma z\hat q_{t-1}
-(z^2+\beta\gamma^2)\hat q_t
+\beta\gamma zE_t\hat q_{t+1}
+\beta\gamma(z-\gamma)(1-\rho_a)\hat a_t
-\gamma z\hat z_t.
$$

**(F18) Output gap**

$$
\hat x_t=\hat y_t-\hat q_t.
$$

## 4. Market Clearing & Identities

Money and bond markets clear as:

$$
M_t=M_{t-1}+T_t,\qquad B_t=B_{t-1}=0.
$$

The paper states that after imposing symmetry and using the household and firm conditions to solve out wages, money balances, labor, and dividends, the remaining equilibrium system determines output, consumption, inflation, the nominal interest rate, output growth, efficient output, the output gap, marginal utility, and the three structural shocks.

To first order, price adjustment costs are second order, so the transformed resource identity implies:

$$
\hat c_t=\hat y_t.
$$

This condition is present in the paper's derivation but is commented out in the implementation cross-check because consumption is not kept as a separate MMB endogenous variable.

The price-level aggregator and intermediate-good demand are retained as source-level identities in (F5)-(F6), while the estimated linear system uses aggregate inflation directly.

## 5. Exogenous Processes

The paper-side nonlinear shocks are:

$$
\ln(a_t)=\rho_a\ln(a_{t-1})+\varepsilon_{at},
$$

$$
\ln(\theta_t)=(1-\rho_{\theta})\ln(\theta)+\rho_{\theta}\ln(\theta_{t-1})+\varepsilon_{\theta t},
$$

$$
\ln(Z_t)=\ln(z)+\ln(Z_{t-1})+\varepsilon_{zt}.
$$

In the estimated linear system, the markup shock is renormalized to $\hat e_t=-(1/\phi)\hat\theta_t$, with $\rho_e=\rho_{\theta}$ and $\psi=(\theta-1)/\phi$. The model also includes the monetary policy innovation $\varepsilon_{rt}$ in the Taylor rule (F15).

The implementation cross-check declares four innovations: `epsa`, `epse`, `epsz`, and `epsr`, matching preference, renormalized cost-push, technology, and monetary policy shocks.

## 6. Steady-State Solution

Because US_IR11 is implemented and estimated as a log-linear `model(linear)` system, all hatted variables are zero in deterministic steady state:

$$
\hat a=\hat\lambda=\hat y=\hat r=\hat\pi=\hat e=\hat z=\hat g=\hat q=\hat x=0.
$$

The balanced-growth steady-state levels in the paper satisfy:

$$
g=z,\qquad r=z\pi/\beta,
$$

where $z$ is the gross quarterly technology drift and $\pi$ is gross quarterly trend inflation. The paper fixes $z=1.0046$, $\pi=1.0062$, $\beta=0.9987$, and $\psi=0.10$ before estimating the remaining parameters. These level relationships are not required as a nonzero `steady_state_model` for the MMB linear implementation.

Estimated and calibrated parameter values visible in the paper and cross-check implementation:

| Parameter | Meaning | Value / status |
|---|---|---|
| $\gamma$ | habit formation | 0.3904 |
| $\alpha$ | price indexation | 0 |
| $\rho_{\pi}$ | Taylor-rule inflation response | 0.4153 |
| $\rho_g$ | Taylor-rule output-growth response | 0.1270 |
| $\rho_a$ | preference-shock persistence | 0.9797 |
| $\rho_e$ | renormalized cost-push persistence | 0 |
| $z$ | technology drift | 1.0046 |
| $\beta$ | discount factor | 0.9987 |
| $\psi$ | Phillips-curve parameter | 0.10 |
| $\sigma_a,\sigma_e,\sigma_z,\sigma_r$ | innovation standard deviations | 0.0868, 0.0017, 0.0095, 0.0014 |

Runtime validation: not performed.

## 7. Timing & Form Conventions

The estimated system is quarterly and log-linear around a balanced-growth path. Hats denote log deviations from steady-state transformed variables. The technology level $Z_t$ has a unit root with drift, so real variables are stationarized by $Z_t$ before log-linearization.

There is no capital stock in this model. The main predetermined endogenous variables in the linear system are lagged output, lagged nominal interest, and lagged efficient output, appearing as $\hat y_{t-1}$, $\hat r_{t-1}$, and $\hat q_{t-1}$. The preference and cost-push shocks are AR(1), while the technology growth and monetary policy shocks enter as innovations in the baseline specification.

Inflation and the nominal interest rate are quarterly model variables; the implementation adds annualized reporting variables by multiplying by four. Output level reporting is reconstructed by cumulating technology growth and adding stationary output.

## 8. Variable & Parameter Reference Table

### Endogenous Variables

| Category | Symbol | ASCII name | Meaning | Main equation |
|---|---|---|---|---|
| Endogenous | $\hat a_t$ | `a` | preference shock state | (F9) |
| Endogenous | $\hat\lambda_t$ | `lambda` | marginal utility / IS state | (F10), (F11) |
| Endogenous | $\hat y_t$ | `y` | stationary output deviation | (F10), (F16) |
| Endogenous | $\hat z_t$ | `z` | technology growth deviation | (F13) |
| Endogenous | $\hat r_t$ | `r` | nominal interest-rate deviation | (F15) |
| Endogenous | $\hat\pi_t$ | `pi` | inflation deviation | (F14) |
| Endogenous | $\hat e_t$ | `e` | renormalized cost-push shock | (F12) |
| Endogenous | $\hat g_t$ | `g` | output growth deviation | (F16), (F15) |
| Endogenous | $\hat q_t$ | `q` | efficient output deviation | (F17) |
| Endogenous | $\hat x_t$ | `x` | output gap | (F18) |
| Endogenous | $4\hat\pi_t$ | `inflationq` | annualized inflation reporting variable | implementation_cross_check |
| Endogenous | $4\hat r_t$ | `interest` | annualized interest reporting variable | implementation_cross_check |
| Endogenous | output level | `output` | output level reporting variable | implementation_cross_check |
| Endogenous | technology level accumulator | `Z_au` | accumulated technology reporting state | implementation_cross_check |

### Exogenous Shocks

| Symbol | ASCII name | Meaning |
|---|---|---|
| $\varepsilon_{at}$ | `epsa` | preference innovation |
| $\varepsilon_{et}$ | `epse` | renormalized cost-push innovation |
| $\varepsilon_{zt}$ | `epsz` | technology growth innovation |
| $\varepsilon_{rt}$ | `epsr` | monetary policy innovation |

### Parameters

| Symbol | ASCII name | Meaning |
|---|---|---|
| $\gamma$ | `gamma` | habit formation |
| $\alpha$ | `alfa` | price indexation |
| $\rho_{\pi}$ | `rhopi` | Taylor-rule inflation response |
| $\rho_g$ | `rhog` | Taylor-rule output-growth response |
| $\rho_a$ | `rhoa` | preference-shock persistence |
| $\rho_e$ | `rhoe` | renormalized cost-push persistence |
| $z$ | `zeta` | technology drift |
| $\beta$ | `beta` | discount factor |
| $\psi$ | `psi` | Phillips-curve slope / nominal rigidity parameter |
| $\sigma_a,\sigma_e,\sigma_z,\sigma_r$ | shock variances in `shocks` block | innovation standard deviations used for simulation |
