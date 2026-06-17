# US_FU19 -- Derivation (Optimization Problems + First-Order Conditions)

> This derivation is for source-backed organization in the private model archive. It is not yet intended to generate a runnable Dynare `.mod` file directly. Current status: `needs_review`. The Fratto-Uhlig paper states that the benchmark is the original Smets-Wouters (2007) model and gives selected accounting equations; it does not reproduce the full source-level derivation. `US_FU19_rep.mod` is used only as an `implementation_cross_check`.

## 1. Model Overview

- Model: Fratto and Uhlig (2019), "Accounting for Post Crisis Inflation: A Retro Analysis".
- MMB code: `US_FU19`.
- Paper metadata: Chiara Fratto and Harald Uhlig, *Review of Economic Dynamics*, DOI `10.1016/j.red.2019.05.005`.
- Form: estimated log-linear medium-scale New Keynesian DSGE, using the original Smets-Wouters (2007) benchmark model for the inflation-accounting exercise. The local implementation uses `model(linear)`.
- Agents: representative household, final-good producer, intermediate-good firms, labor/wage-setting block, capital accumulation and utilization block, government/central bank.
- Main frictions: external habit formation, investment adjustment costs, variable capital utilization, fixed costs, Calvo price and wage setting, and price and wage indexation.
- Shocks: technology, preference/risk-premium, government spending, investment-specific technology, price markup, wage markup, and monetary policy.
- Observables: output growth, consumption growth, investment growth, real wage growth, labor/hours, inflation, and the federal funds rate.

Source limitation: the paper-side Markdown describes the Smets-Wouters structure and prints the hybrid Phillips curve, the ZLB monetary-surprise mapping, the time-varying inflation-target extension, and selected Del Negro et al. financial-friction extension equations. The complete Smets-Wouters model equations are not printed in this paper body and require review against the cited Smets-Wouters source/online appendix.

## 2. Optimization Problems

### 2.1 Representative Household

The household has external habit in consumption, supplies labor, holds bonds, and invests in physical capital with variable utilization. A source-complete utility and budget constraint are not printed in the Fratto-Uhlig paper body; the intended benchmark is the Smets-Wouters household block. A generic source-level problem to be verified is:

$$
\max E_0\sum_{t=0}^{\infty}\beta^t
\left[
U(C_t-hC_{t-1},L_t)
\right]
$$

subject to the real budget constraint that allocates resources among consumption, bond holdings, investment, capital utilization costs, taxes, wage income, rental income, bond returns, and profits. `needs_review`: the exact nonlinear household problem is not in the US_FU19 Markdown.

### 2.2 Final-Good Producer

The final-good producer aggregates differentiated intermediate goods and chooses intermediate-good demand given relative prices. `needs_review`: US_FU19 identifies the Smets-Wouters benchmark and Calvo/Kimball-style price setting but does not print the full final-good aggregation problem.

### 2.3 Intermediate-Good Firms

Intermediate firms rent effective capital and labor, produce differentiated goods, and set prices subject to Calvo stickiness with partial indexation. The paper's accounting discussion focuses on the price-markup channel. `needs_review`: the paper gives the reduced hybrid Phillips curve but not the full firm objective and reset-price FOC.

### 2.4 Wage-Setting Block

Households or labor unions set differentiated wages subject to Calvo wage rigidity and partial indexation. Wage-markup shocks are central to the paper's inflation accounting. `needs_review`: the paper describes wage markups and the wage Phillips-curve role but does not print the full wage-setting objective.

### 2.5 Policy and Accounting Blocks

The monetary authority follows a linear Taylor-type rule. The benchmark retro analysis treats the difference between the linear Taylor-rule rate and the observed zero lower bound as a sequence of surprise monetary shocks when the rule-implied nominal rate is negative.

## 3. First-Order Conditions

The following conditions are a source-backed skeleton for the US_FU19 archive entry. Equations that come directly from the Fratto-Uhlig Markdown are marked `source_stated`; equations inferred from the Smets-Wouters benchmark and checked against `US_FU19_rep.mod` are marked `needs_review`.

**(F1) Consumption Euler equation with habit and risk-premium wedge** (`needs_review`):

$$
c_t =
\frac{h/\gamma}{1+h/\gamma}c_{t-1}
+\frac{1}{1+h/\gamma}E_t c_{t+1}
+\frac{(\sigma_c-1)w_L^c}{\sigma_c(1+h/\gamma)}(L_t-E_tL_{t+1})
-\frac{1-h/\gamma}{\sigma_c(1+h/\gamma)}(R_t-E_t\pi_{t+1})
+b^2_t .
$$

**(F2) Investment Euler equation / investment-adjustment-cost FOC** (`needs_review`):

$$
i_t =
\frac{1}{1+\bar{\beta}\gamma}
\left(i_{t-1}+\bar{\beta}\gamma E_t i_{t+1}
+\frac{1}{\gamma^2\varphi_i}Q_t\right)+\mu_t .
$$

**(F3) Value of installed capital / Tobin's Q** (`needs_review`):

$$
Q_t =
\frac{1}{\chi_c}b^2_t
-(R_t-E_t\pi_{t+1})
+\frac{r_k^\ast}{r_k^\ast+1-\delta}E_t r^k_{t+1}
+\frac{1-\delta}{r_k^\ast+1-\delta}E_tQ_{t+1}.
$$

where $\chi_c=(1-h/\gamma)/[\sigma_c(1+h/\gamma)]$.

**(F4) Capital utilization condition** (`needs_review`):

$$
u_t=\frac{1-c_z}{c_z}r^k_t .
$$

**(F5) Effective capital services** (`needs_review`):

$$
k_t=u_t+\bar{k}_{t-1}.
$$

**(F6) Physical-capital accumulation** (`needs_review`):

$$
\bar{k}_t=(1-\iota_k)\bar{k}_{t-1}+\iota_k(\gamma^2\varphi_i\mu_t+i_t).
$$

**(F7) Production function** (`needs_review`):

$$
y_t=\Phi Z_t+\alpha\Phi k_t+(1-\alpha)\Phi L_t .
$$

**(F8) Capital-labor demand relation** (`needs_review`):

$$
k_t=w_t-r^k_t+L_t .
$$

**(F9) Real marginal cost** (`needs_review`):

$$
mc_t=\alpha r^k_t+(1-\alpha)w_t-Z_t .
$$

**(F10) Hybrid price Phillips curve** (`source_stated`, paper equation (1), notation harmonized):

$$
\pi_t=\pi_1\pi_{t-1}+\pi_2E_t\pi_{t+1}-\pi_3\mu^p_t+\epsilon^p_t .
$$

Here $\mu^p_t$ is the price markup, defined in the paper as the difference between the marginal product of labor and the real wage.

**(F11) Wage Phillips curve** (`needs_review`):

$$
w_t=
\frac{1}{1+\bar{\beta}\gamma}
\left[
w_{t-1}+\bar{\beta}\gamma E_tw_{t+1}
+\kappa_w
\left(
\frac{1}{1-h/\gamma}c_t-\frac{h/\gamma}{1-h/\gamma}c_{t-1}
+\nu_LL_t-w_t
\right)
-(1+\bar{\beta}\gamma\iota_w)\pi_t
+\iota_w\pi_{t-1}
+\bar{\beta}\gamma E_t\pi_{t+1}
\right]+\lambda^w_t .
$$

**(F12) Monetary policy rule** (`source_stated` for the rule form; benchmark uses constant target):

$$
R_t=\rho_RR_{t-1}+(1-\rho_R)\left(\psi_1\pi_t+\psi_2(y_t-y^{flex}_t)\right)
+\psi_3\left[(y_t-y_{t-1})-(y^{flex}_t-y^{flex}_{t-1})\right]+ms_t .
$$

**(F13) Aggregate resource constraint** (`needs_review`):

$$
y_t=c_yc_t+i_yi_t+g_t+r_k^\ast k_yu_t .
$$

**(F14) Flexible-price consumption Euler equation** (`implementation_cross_check`, `needs_review`):

$$
c^{flex}_t =
\frac{h/\gamma}{1+h/\gamma}c^{flex}_{t-1}
+\frac{1}{1+h/\gamma}E_t c^{flex}_{t+1}
+\frac{(\sigma_c-1)w_L^c}{\sigma_c(1+h/\gamma)}(L^{flex}_t-E_tL^{flex}_{t+1})
-\frac{1-h/\gamma}{\sigma_c(1+h/\gamma)}R^{flex}_t
+b^2_t .
$$

**(F15) Flexible-price investment equation** (`implementation_cross_check`, `needs_review`):

$$
i^{flex}_t =
\frac{1}{1+\bar{\beta}\gamma}
\left(i^{flex}_{t-1}+\bar{\beta}\gamma E_ti^{flex}_{t+1}
+\frac{1}{\gamma^2\varphi_i}Q^{flex}_t\right)+\mu_t .
$$

**(F16) Flexible-price Tobin's Q** (`implementation_cross_check`, `needs_review`):

$$
Q^{flex}_t =
\frac{1}{\chi_c}b^2_t
-R^{flex}_t
+\frac{r_k^\ast}{r_k^\ast+1-\delta}E_tr^{k,flex}_{t+1}
+\frac{1-\delta}{r_k^\ast+1-\delta}E_tQ^{flex}_{t+1}.
$$

**(F17) Flexible-price capital utilization** (`implementation_cross_check`, `needs_review`):

$$
u^{flex}_t=\frac{1-c_z}{c_z}r^{k,flex}_t .
$$

**(F18) Flexible-price effective capital** (`implementation_cross_check`, `needs_review`):

$$
k^{flex}_t=u^{flex}_t+\bar{k}^{flex}_{t-1}.
$$

**(F19) Flexible-price capital accumulation** (`implementation_cross_check`, `needs_review`):

$$
\bar{k}^{flex}_t=(1-\iota_k)\bar{k}^{flex}_{t-1}+\iota_k(\gamma^2\varphi_i\mu_t+i^{flex}_t).
$$

**(F20) Flexible-price production** (`implementation_cross_check`, `needs_review`):

$$
y^{flex}_t=\Phi Z_t+\alpha\Phi k^{flex}_t+(1-\alpha)\Phi L^{flex}_t .
$$

**(F21) Flexible-price capital-labor demand relation** (`implementation_cross_check`, `needs_review`):

$$
k^{flex}_t=w^{flex}_t-r^{k,flex}_t+L^{flex}_t .
$$

**(F22) Flexible-price marginal cost normalization** (`implementation_cross_check`, `needs_review`):

$$
0=\alpha r^{k,flex}_t+(1-\alpha)w^{flex}_t-Z_t .
$$

**(F23) Flexible-price wage/labor condition** (`implementation_cross_check`, `needs_review`):

$$
w^{flex}_t=\frac{1}{1-h/\gamma}c^{flex}_t-\frac{h/\gamma}{1-h/\gamma}c^{flex}_{t-1}+\nu_LL^{flex}_t .
$$

**(F24) Flexible-price resource constraint** (`implementation_cross_check`, `needs_review`):

$$
y^{flex}_t=c_yc^{flex}_t+i_yi^{flex}_t+g_t+r_k^\ast k_yu^{flex}_t .
$$

## 4. Market Clearing & Identities

Market clearing is encoded in the aggregate resource constraints (F13) and (F24), factor-demand relations (F8) and (F21), and the definition of the output gap used in monetary policy (F12).

The paper's accounting exercise uses seven observables:

**(F25) Measurement equations** (`implementation_cross_check`, `needs_review`):

$$
\Delta y^{obs}_t=y_t-y_{t-1},\quad
\Delta c^{obs}_t=c_t-c_{t-1},\quad
\Delta i^{obs}_t=i_t-i_{t-1},\quad
\Delta w^{obs}_t=w_t-w_{t-1}.
$$

$$
\pi^{obs}_t=\pi_t,\quad R^{obs}_t=R_t,\quad L^{obs}_t=L_t .
$$

The paper reports inflation and employment shock decompositions based on the solved linear system and these observables.

## 5. Exogenous Processes

**(F26) Technology shock** (`needs_review`):

$$
Z_t=\rho_ZZ_{t-1}+\epsilon^Z_t .
$$

**(F27) Preference/risk-premium shock** (`needs_review`):

$$
b^2_t=\rho_{b2}b^2_{t-1}+\epsilon^{b2}_t .
$$

**(F28) Government spending shock with technology innovation spillover** (`implementation_cross_check`, `needs_review`):

$$
g_t=\rho_gg_{t-1}+\epsilon^g_t+\rho_{gZ}\epsilon^Z_t .
$$

**(F29) Investment-specific technology shock** (`needs_review`):

$$
\mu_t=\rho_\mu\mu_{t-1}+\epsilon^\mu_t .
$$

**(F30) Price-markup shock** (`source_stated` concept, `needs_review` for exact process):

$$
\lambda^p_t=\rho_p\lambda^p_{t-1}+\epsilon^p_t-\theta_p\epsilon^p_{t-1}.
$$

**(F31) Wage-markup shock** (`source_stated` concept, `needs_review` for exact process):

$$
\lambda^w_t=\rho_w\lambda^w_{t-1}+\epsilon^w_t-\theta_w\epsilon^w_{t-1}.
$$

**(F32) Monetary policy shock** (`source_stated` concept, `needs_review` for exact process):

$$
ms_t=\rho_{ms}ms_{t-1}+\epsilon^{ms}_t .
$$

For the ZLB accounting exercise, the paper states:

**(F33) ZLB monetary-surprise mapping** (`source_stated`, paper equation (7)):

$$
\epsilon^m_t=\max\{-\tilde{i}_t,0\},
$$

where $\tilde{i}_t$ is the interest rate implied by the linear Taylor rule.

For the optional time-varying inflation-target extension, the paper states:

**(F34) Time-varying inflation target extension** (`source_stated`, not part of baseline MMB implementation):

$$
i_t=\bar{i}+\rho_Ri_{t-1}+(1-\rho_R)\left[\psi_1(\pi_t-\pi_t^\ast)+\psi_2x_t\right]
+\psi_3(x_t-x_{t-1})+\epsilon^r_t,
$$

$$
\hat{\pi}^\ast_t=\rho_{\pi^\ast}\hat{\pi}^\ast_{t-1}+\sigma_{\pi^\ast}\epsilon^{\pi^\ast}_t .
$$

## 6. Steady-State Solution

Because the MMB implementation is `model(linear)`, the dynamic variables are deviations from the balanced-growth steady state and the model block is solved around zero:

$$
\bar{c}=\bar{i}=\bar{Q}=\bar{u}=\bar{k}=\bar{y}=\bar{\pi}=\bar{R}=\bar{L}=0 .
$$

Derived steady-state ratios and constants are calibrated or computed before the linear model is evaluated:

$$
\beta=\frac{1}{1+\mathrm{constebeta}/100},
\qquad
\bar{\beta}=\beta\gamma^{-\sigma_c},
\qquad
r_k^\ast=\beta^{-1}\gamma^{\sigma_c}-(1-\delta).
$$

$$
w^\ast=
\left[
\frac{\alpha^\alpha(1-\alpha)^{1-\alpha}}{\Phi(r_k^\ast)^\alpha}
\right]^{1/(1-\alpha)},
\qquad
\frac{K}{L}=\frac{\alpha}{1-\alpha}\frac{w^\ast}{r_k^\ast}.
$$

$$
k_y=\Phi\left(\frac{K}{L}\right)^{1-\alpha},
\qquad
i_y=\left[1-\frac{1-\delta}{\gamma}\right]\gamma k_y,
\qquad
c_y=1-g^\ast-i_y .
$$

`needs_review`: these formulas are cross-checked against `US_FU19_rep.mod`; the US_FU19 paper body does not print the complete steady-state derivation.

## 7. Timing & Form Conventions

- Form convention: `model(linear)`; all model variables in (F1)-(F34) are log deviations or linear deviations around the balanced-growth steady state unless otherwise stated.
- Capital timing: production uses effective capital services $k_t=u_t+\bar{k}_{t-1}$; physical capital $\bar{k}_t$ is a predetermined stock chosen by end of period.
- Expectations: equations are written with $E_t$ for one-period-ahead terms; the `.mod` cross-check uses Dynare leads such as `(+1)`.
- Output gap: monetary policy responds to $y_t-y^{flex}_t$ and the change in that gap.
- ZLB treatment: the baseline retro analysis does not impose an occasionally binding constraint in the benchmark linear model; it treats the gap between the negative Taylor-rule shadow rate and zero as a sequence of surprise monetary shocks.
- Runtime validation: not performed; Dynare was not run.

## 8. Variable & Parameter Reference Table

| Category | Symbol | Meaning | Equation coverage |
|---|---|---|---|
| Endogenous | `c` | consumption | (F1), (F13), (F25) |
| Endogenous | `i` | investment | (F2), (F6), (F13), (F25) |
| Endogenous | `Q` | Tobin's Q | (F3), (F6) |
| Endogenous | `u` | capital utilization | (F4), (F5), (F13) |
| Endogenous | `k` | effective capital services | (F5), (F7), (F8) |
| Endogenous | `k_bar` | physical capital stock | (F6) |
| Endogenous | `y` | output | (F7), (F12), (F13), (F25) |
| Endogenous | `L` | labor/hours | (F1), (F7), (F8), (F11), (F25) |
| Endogenous | `w` | real wage | (F8), (F9), (F11), (F25) |
| Endogenous | `r_k` | rental rate/return on capital | (F3), (F4), (F8), (F9) |
| Endogenous | `mc` | real marginal cost | (F9), (F10) |
| Endogenous | `pi` | inflation | (F10), (F11), (F12), (F25) |
| Endogenous | `R` | nominal policy rate | (F1), (F12), (F25) |
| Endogenous | `*_flex` | flexible-price counterparts | (F14)-(F24) |
| Endogenous | `Z` | technology state | (F7), (F20), (F26) |
| Endogenous | `b2` | preference/risk-premium wedge | (F1), (F3), (F14), (F16), (F27) |
| Endogenous | `mu` | investment-specific technology wedge | (F2), (F6), (F15), (F19), (F29) |
| Endogenous | `g` | government spending | (F13), (F24), (F28) |
| Endogenous | `lambda_p` | price-markup shock state | (F10), (F30) |
| Endogenous | `lambda_w` | wage-markup shock state | (F11), (F31) |
| Endogenous | `ms` | monetary policy shock state | (F12), (F32) |
| Endogenous | `dy, dc, dinve, dw, pinfobs, robs, labobs` | observables | (F25) |
| Exogenous | `eZ` | technology innovation | (F26), (F28) |
| Exogenous | `eb2` | preference/risk-premium innovation | (F27) |
| Exogenous | `eg` | government-spending innovation | (F28) |
| Exogenous | `emu` | investment-specific innovation | (F29) |
| Exogenous | `ep` | price-markup innovation | (F10), (F30) |
| Exogenous | `ew` | wage-markup innovation | (F11), (F31) |
| Exogenous | `ems` | monetary-policy innovation | (F32) |
| Parameter | `h` | habit persistence | (F1), (F11), (F14), (F23) |
| Parameter | `gamma` | trend growth factor | (F1)-(F3), (F6), (F14)-(F16), (F19) |
| Parameter | `sigma_c` | consumption curvature | (F1), (F3), (F11), (F14), (F16), steady state |
| Parameter | `beta, beta_bar` | discount factors | (F2), (F3), (F15), (F16), steady state |
| Parameter | `delta` | depreciation | (F3), (F16), steady state |
| Parameter | `inv_adj_cost` | investment adjustment cost | (F2), (F6), (F15), (F19) |
| Parameter | `alpha, Phi` | production share and fixed-cost/markup term | (F7), (F9), (F20), (F22), steady state |
| Parameter | `zeta_p, iota_p, lambda_pSS, curvp` | price rigidity/indexation/curvature parameters | (F10) |
| Parameter | `zeta_w, iota_w, lambda_wSS, curvw, nu_L` | wage rigidity/indexation/labor parameters | (F11), (F23) |
| Parameter | `rhoR, psi1, psi2, psi3` | monetary policy rule parameters | (F12), (F34) |
| Parameter | `rhoZ, rhob2, rhog, rhogZ, rhomu, rhop, rhow, rhoms, thetap, thetaw` | shock process parameters | (F26)-(F32) |
| Parameter | `gSS, consumpt_ratioSS, invest_ratioSS, capital_ratioSS, r_kSS, wLc, czcap` | steady-state ratios and utilization constants | (F1)-(F25), steady state |
