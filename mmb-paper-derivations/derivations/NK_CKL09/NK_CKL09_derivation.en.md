# NK_CKL09 - Derivation

> First-pass private archive extraction for later Dynare implementation review. Status: `needs_review`.

Source: Kai Christoffel, Keith Kuester, and Tobias Linzert (2009), "The role of labor markets for euro area monetary policy," *European Economic Review* 53(8), 908-936. DOI: `10.1016/j.euroecorev.2009.04.007`.

## 1. Model Overview

- **Model ID**: `NK_CKL09`.
- **Model type**: calibrated euro-area New Keynesian model with Mortensen-Pissarides search and matching frictions, right-to-manage hours choice, Calvo price rigidity, and Calvo nominal wage bargaining.
- **Primary experiment**: monetary-policy transmission and labor-market counterfactuals in the calibrated Section 3 economy; the Rep-MMB implementation cross-check is a `model(linear)` file.
- **Agents and sectors**: a representative large family, retail final-good aggregators, Calvo wholesale firms, labor-good firms, matched workers, government, and a Taylor-rule monetary authority.
- **Form**: log-linear / hat-variable system around a zero-inflation steady state. Equations below use hats for log deviations from steady state unless a variable is already a rate/share in the source appendix. Several OCR equations from the MinerU Markdown are readable but not source-level verified against the PDF; those are marked `needs_review`.
- **Implementation cross-check**: `.agents/skills/dynare-copilot/references/examples/NK_CKL09_rep.mod` confirms the Rep-MMB file is the calibrated Section 3 version and uses variables such as `ct`, `lambdat`, `Pit`, `Rt`, `nt`, `ut`, `vt`, `wt`, `wstart`, `Jstart`, `Deltastart`, `deltaFt`, and `deltaWt`.

## 2. Optimization Problems

### 2.1 Representative Large Family

The family maximizes pooled expected utility over its members:

\[
E_0\sum_{t=0}^{\infty}\beta^t\left[
\frac{(c_{i,t}-\varrho c_{t-1})^{1-\sigma}}{1-\sigma}
-\kappa^L\frac{h_{i,t}^{1+\varphi}}{1+\varphi}
\right].
\]

The family chooses consumption, bond holdings, vacancy posting, and labor-supply decisions subject to the aggregate budget constraint:

\[
c_t+t_t+\kappa_t\nu_t
=\int_0^{1-u_t} w_{i,t}h_{i,t}\,di
+u_t b+\frac{D_{t-1}}{P_t}R_{t-1}\varepsilon^b_{t-1}
-\frac{D_t}{P_t}+\Psi_t+n_t\Phi^K.
\]

### 2.2 Retail and Wholesale Firms

Retailers aggregate differentiated wholesale goods:

\[
y_t=\left(\int_0^1 y_{j,t}^{(\varepsilon-1)/\varepsilon}\,dj\right)^{\varepsilon/(\varepsilon-1)},
\qquad
y_{j,t}=\left(\frac{P_{j,t}}{P_t}\right)^{-\varepsilon}y_t.
\]

Wholesale firms set prices subject to Calvo frictions. A resetting firm chooses \(P^{\ast}_t\) to maximize discounted expected profits:

\[
\max_{P^{\ast}_t} E_t\sum_{s=0}^{\infty}\omega^s\beta_{t,t+s}
\left[
\frac{P^{\ast}_t\Pi_{t-1,t-1+s}^{\xi_p}\Pi^{(1-\xi_p)s}}{P_{t+s}}
-mc_{t+s}
\right]y_{j,t+s}.
\]

### 2.3 Labor-Good Firms and Wage Bargaining

A matched labor-good firm produces:

\[
l_{i,t}=z_t h_{i,t}^{\alpha}.
\]

Under right-to-manage, the firm chooses hours after the wage is fixed:

\[
x^L_t z_t\alpha h_{i,t}^{\alpha-1}=\frac{W_{i,t}}{P_t}.
\]

Workers and firms bargain over the reset wage \(W^{\ast}_t\) by Nash bargaining:

\[
\max_{W_{i,t}}\left[\Delta_t(W_{i,t})\right]^{\eta_t}
\left[J_t(W_{i,t})\right]^{1-\eta_t}.
\]

The firm value and family surplus objects are recursively defined by the paper's value equations. Their log-linear counterparts are included as equilibrium conditions below; the OCR for the nonlinear value equations is usable but `needs_review` for exact punctuation and discounting notation.

### 2.4 Vacancy Posting

Free entry into vacancy posting equates vacancy cost with the discounted expected value of a filled job:

\[
\kappa_t=q_t E_t\left\{\beta_{t,t+1}\left[
\gamma J_{t+1}\!\left(W_t\Pi_t^{\xi_w}\Pi^{1-\xi_w}\right)
+(1-\gamma)J_{t+1}(W^{\ast}_{t+1})
\right]\right\}.
\]

## 3. First-Order Conditions

The archive equation set follows the paper's linearized Appendix A and the Rep-MMB `model(linear)` cross-check.

**(F1) Consumption Euler equation**

\[
\hat{\lambda}_t
=E_t\left[\hat{\lambda}_{t+1}+\hat{R}_t+\hat{\varepsilon}^b_t-\hat{\Pi}_{t+1}\right].
\]

**(F2) Marginal utility of consumption with external habit**

\[
\hat{\lambda}_t
=-\frac{\sigma}{1-\varrho}\left(\hat{c}_t-\varrho\hat{c}_{t-1}\right).
\]

**(F3) New Keynesian Phillips curve with indexation**

\[
\hat{\Pi}_t
=\frac{\xi_p}{1+\beta\xi_p}\hat{\Pi}_{t-1}
+\frac{\beta}{1+\beta\xi_p}E_t\hat{\Pi}_{t+1}
+\frac{(1-\omega)(1-\omega\beta)}{\omega(1+\beta\xi_p)}\widehat{mc}_t.
\]

**(F4) Marginal cost**

\[
\widehat{mc}_t=\hat{e}^C_t+\hat{x}^L_t.
\]

**(F5) Matching technology**

\[
\hat{m}_t=\xi\hat{u}_t+(1-\xi)\hat{\nu}_t.
\]

**(F6) Employment law of motion**

\[
\hat{n}_t=(1-\vartheta)\hat{n}_{t-1}+\frac{m}{n}\hat{m}_{t-1}-\vartheta\hat{\vartheta}_t.
\]

**(F7) Employment-unemployment identity**

\[
\hat{n}_t=-\frac{u}{1-u}\hat{u}_t.
\]

**(F8) Job-filling rate**

\[
\hat{q}_t=\hat{m}_t-\hat{\nu}_t.
\]

**(F9) Job-finding rate**

\[
\hat{s}_t=\hat{m}_t-\hat{u}_t.
\]

**(F10) Reset-wage bargaining condition**

\[
\hat{J}^{\ast}_t+\hat{\delta}^W_t
=\hat{\Delta}^{\ast}_t+\hat{\delta}^F_t-\frac{1}{1-\eta}\hat{\eta}_t.
\]

**(F11) Right-to-manage hours condition**

\[
\hat{w}_t=\hat{x}^L_t+\hat{z}_t+(\alpha-1)\hat{h}_t.
\]

**(F12) Aggregate real wage evolution**

\[
\hat{w}_t
=\gamma\left(\hat{w}_{t-1}-\hat{\Pi}_t+\xi_w\hat{\Pi}_{t-1}\right)
+(1-\gamma)\hat{w}^{\ast}_t.
\]

**(F13) Firm surplus derivative recursion** `needs_review`

\[
\begin{aligned}
\hat{\delta}^F_t
=&\left[1-\beta(1-\vartheta)\gamma\right]
\left[-\frac{\alpha}{1-\alpha}\hat{w}^{\ast}_t
+\frac{1}{1-\alpha}(\hat{x}^L_t+\hat{z}_t)\right] \\
&+\beta(1-\vartheta)\gamma E_t\left[
-\frac{\alpha}{1-\alpha}
(\hat{w}^{\ast}_t+\xi_w\hat{\Pi}_t-\hat{w}^{\ast}_{t+1}-\hat{\Pi}_{t+1})
+\hat{\delta}^F_{t+1}+\hat{\lambda}_{t+1}-\hat{\lambda}_t
-\frac{\vartheta}{1-\vartheta}\hat{\vartheta}_{t+1}
\right].
\end{aligned}
\]

**(F14) Worker surplus derivative recursion** `needs_review`

\[
\begin{aligned}
\delta^W\hat{\delta}^W_t
=&-\frac{\alpha}{1-\alpha}wh
\left[-\frac{\alpha}{1-\alpha}\hat{w}^{\ast}_t
+\frac{1}{1-\alpha}(\hat{x}^L_t+\hat{z}_t)\right] \\
&+\frac{1}{1-\alpha}mrsh
\left[-\frac{1+\varphi}{1-\alpha}\hat{w}^{\ast}_t
-\hat{\lambda}_t
+\frac{1+\varphi}{1-\alpha}(\hat{x}^L_t+\hat{z}_t)\right] \\
&+\frac{\beta(1-\vartheta)\gamma}{1-\beta(1-\vartheta)\gamma}
\left[\left(\frac{\alpha}{1-\alpha}\right)^2wh
-\frac{1+\varphi}{(1-\alpha)^2}mrsh\right]
E_t(\hat{w}^{\ast}_t+\xi_w\hat{\Pi}_t-\hat{w}^{\ast}_{t+1}-\hat{\Pi}_{t+1})\\
&+\beta(1-\vartheta)\gamma\delta^W
E_t\left[\hat{\lambda}_{t+1}-\hat{\lambda}_t+\hat{\delta}^W_{t+1}
-\frac{\vartheta}{1-\vartheta}\hat{\vartheta}_{t+1}\right].
\end{aligned}
\]

**(F15) Value of a firm with a reset wage** `needs_review`

\[
\begin{aligned}
J\hat{J}^{\ast}_t
=&\frac{wh}{\alpha}\left[-\alpha\hat{w}^{\ast}_t+\hat{x}^L_t+\hat{z}_t\right]\\
&+\frac{\beta(1-\vartheta)\gamma}{1-\beta(1-\vartheta)\gamma}wh
E_t(\hat{w}^{\ast}_{t+1}+\hat{\Pi}_{t+1}-\hat{w}^{\ast}_t-\xi_w\hat{\Pi}_t)\\
&+\beta(1-\vartheta)J
E_t\left[\hat{\lambda}_{t+1}-\hat{\lambda}_t+\hat{J}^{\ast}_{t+1}
-\frac{\vartheta}{1-\vartheta}\hat{\vartheta}_{t+1}\right].
\end{aligned}
\]

**(F16) Worker surplus with a reset wage** `needs_review`

\[
\begin{aligned}
\Delta\hat{\Delta}^{\ast}_t
=&\frac{wh}{1-\alpha}\left[-\alpha\hat{w}^{\ast}_t+\hat{x}^L_t+\hat{z}_t\right]\\
&-\frac{mrsh}{1+\varphi}
\left[\frac{1+\varphi}{1-\alpha}(-\hat{w}^{\ast}_t+\hat{x}^L_t+\hat{z}_t)-\hat{\lambda}_t\right]\\
&+\frac{\beta(1-\vartheta)\gamma}{1-\beta(1-\vartheta)\gamma}
\left[\frac{\alpha}{1-\alpha}wh-\frac{1}{1-\alpha}mrsh\right]
E_t(\hat{w}^{\ast}_{t+1}+\hat{\Pi}_{t+1}-\hat{w}^{\ast}_t-\xi_w\hat{\Pi}_t)\\
&-\frac{\beta\gamma s}{1-\beta(1-\vartheta)\gamma}
\left[\frac{\alpha}{1-\alpha}wh-\frac{1}{1-\alpha}mrsh\right]
E_t(\hat{w}^{\ast}_{t+1}+\hat{\Pi}_{t+1}-\hat{w}_t-\xi_w\hat{\Pi}_t)\\
&+\beta(1-\vartheta-s)\Delta
E_t(\hat{\lambda}_{t+1}-\hat{\lambda}_t+\hat{\Delta}^{\ast}_{t+1})
-\beta\Delta s\hat{s}_t-\beta\Delta\vartheta E_t\hat{\vartheta}_{t+1}.
\end{aligned}
\]

**(F17) Vacancy posting condition**

\[
\begin{aligned}
\frac{\kappa}{q}(\hat{\kappa}_t-\hat{q}_t)
=&\frac{\beta\gamma}{1-\beta(1-\vartheta)\gamma}wh
E_t(\hat{w}^{\ast}_{t+1}+\hat{\Pi}_{t+1}-\hat{w}_t-\xi_w\hat{\Pi}_t)\\
&+\beta J E_t(\hat{\lambda}_{t+1}-\hat{\lambda}_t+\hat{J}^{\ast}_{t+1}).
\end{aligned}
\]

## 4. Market Clearing & Identities

**(F18) Retail resource constraint**

\[
y\hat{y}_t=c\hat{c}_t+g\hat{g}_t+\kappa\nu(\hat{\kappa}_t+\hat{\nu}_t)+\Phi^L n\hat{n}_t.
\]

**(F19) Aggregate production**

\[
\hat{y}_t=\hat{z}_t+\alpha\hat{h}_t+\hat{n}_t.
\]

**(F20) Annualized / year-on-year inflation identity**

\[
\hat{\Pi}^{yoy}_t=\hat{\Pi}_t+\hat{\Pi}_{t-1}+\hat{\Pi}_{t-2}+\hat{\Pi}_{t-3}.
\]

**(F21) Average labor-firm profit**

\[
\widehat{\Psi}^L_t
=A(\hat{w}_t+\hat{h}_t),
\qquad
A=\frac{\frac{1-\alpha}{\alpha}wh}{\frac{1-\alpha}{\alpha}wh-\Phi}.
\]

**(F22) Wholesale-sector profit**

\[
\Psi^C\widehat{\Psi}^C_t=(1-mc)y\hat{y}_t-ymc\widehat{mc}_t.
\]

**(F23) Monetary policy rule**

\[
\hat{R}_t
=\gamma_R\hat{R}_{t-1}
+(1-\gamma_R)\left[
\frac{\gamma_{\pi}}{4}\hat{\Pi}^{yoy}_t
+\frac{\gamma_y}{4}(\hat{y}_t-\hat{y}^{flex}_t)
\right]
+\gamma_{\Delta y}(\hat{y}_t-\hat{y}_{t-1})
+\hat{e}^{money}_t.
\]

**(F24) Flexible-price/flexible-wage output block**

\[
\hat{y}^{flex}_t=\hat{z}_t+\alpha\hat{h}^{flex}_t+\hat{n}_t.
\]

The source states that the flex economy duplicates the actual system with price and wage rigidity set to zero while keeping the actual economy's states. The Rep-MMB file implements explicit flex analogues for consumption, marginal utility, matching, job-filling/job-finding rates, wage bargaining, hours, vacancy posting, resource clearing, and production. Full one-for-one flex equations are deferred as `needs_review` because this first-pass archive entry focuses on the baseline paper equations.

## 5. Exogenous Processes

**(F25) Risk-premium / preference shock**

\[
\hat{\varepsilon}^b_t=\rho_b\hat{\varepsilon}^b_{t-1}+e^b_t.
\]

**(F26) Government spending**

\[
\hat{g}_t=\rho_g\hat{g}_{t-1}+e^g_t.
\]

**(F27) Monetary policy shock**

\[
\hat{e}^{money}_t=\rho_{money}\hat{e}^{money}_{t-1}+e^{money}_t.
\]

**(F28) Technology shock**

\[
\hat{z}_t=\rho_z\hat{z}_{t-1}+e^z_t.
\]

**(F29) Bargaining-power shock**

\[
\hat{\eta}_t=\rho_{\eta}\hat{\eta}_{t-1}+e^{\eta}_t.
\]

**(F30) Vacancy-posting-cost shock**

\[
\hat{\kappa}_t=\rho_{\kappa}\hat{\kappa}_{t-1}+e^{\kappa}_t.
\]

**(F31) Separation-rate shock**

\[
\hat{\vartheta}_t=\rho_{\vartheta}\hat{\vartheta}_{t-1}+e^{\vartheta}_t.
\]

**(F32) Cost-push shock**

\[
\hat{e}^C_t=\rho_C\hat{e}^C_{t-1}+e^C_t.
\]

## 6. Steady-State Solution

The calibrated paper and Rep-MMB file normalize the steady state for the log-linear model. With zero inflation target, all hatted endogenous and shock deviations are zero in steady state. The steady-state levels are used to scale the linear equations:

1. Set \(y=1\), \(h=1/3\), \(u=0.0916\), \(q=0.7\), and \(\bar{g}/y=0.2\).
2. Employment and matching:

\[
n=1-u,\qquad m=\vartheta n,\qquad \nu=\frac{m}{q},\qquad s=\frac{m}{u},
\qquad \sigma_m=m(u^{\xi}\nu^{1-\xi})^{-1}.
\]

3. Pricing and discounting:

\[
mc=x^L=\frac{\varepsilon-1}{\varepsilon},\qquad R=\frac{1}{\beta}.
\]

4. Production and wage:

\[
z=\frac{y}{nh^\alpha},\qquad w=x^L z\alpha h^{\alpha-1}.
\]

5. Labor-firm profits, values, and vacancy costs:

\[
\Psi^L=x^L z h^\alpha-wh-\Phi,\qquad
J=\frac{\Psi^L}{1-\beta(1-\vartheta)},\qquad
\kappa=q\beta J.
\]

6. Marginal utility and MRS:

\[
\lambda=[c(1-\varrho)]^{-\sigma},\qquad
mrs=\frac{\kappa^L h^{\varphi}}{\lambda}.
\]

7. Resource constraint:

\[
y=c+g+\kappa\nu+n\Phi^L.
\]

The paper's Table 6 reports the resulting steady state: \(y=1\), \(c=0.79\), labor share \(whn/y=0.6\), \(u=0.091\), \(\nu=0.039\), \(s=0.3\), \(q=0.7\), \(b/(wh)=0.65\), \(\kappa\nu/y=0.0023\), \(J=0.084\), and \(\Delta=0.070\). Runtime validation was not performed.

## 7. Timing & Form Conventions

- The model is implemented in log-linear form; variables in the Rep-MMB file are deviations from steady state.
- New matches formed in period \(t\) become productive in \(t+1\), so employment uses lagged matches in (F6).
- The separation shock enters the current employment stock and future value recursions.
- The Taylor rule reacts to annual inflation and the output gap relative to a flexible-price/flexible-wage economy.
- Nominal wage rigidity follows a Calvo scheme; non-reset wages are indexed by lagged inflation with parameter \(\xi_w\).
- Price rigidity follows a Calvo scheme; non-reset prices are indexed by lagged inflation with parameter \(\xi_p\).
- The model has no physical capital accumulation. `PhiK` is an imputed share of labor-firm revenue paid to capital income, not a capital stock law.
- The first-pass equations (F13)-(F16) are marked `needs_review` because the MinerU appendix OCR has several symbol corruptions even though the Rep-MMB implementation provides a consistent linearized counterpart.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Main equation |
|---|---|---|---|
| Endogenous | `ct`, \(\hat{c}_t\) | consumption | (F2), (F18) |
| Endogenous | `lambdat`, \(\hat{\lambda}_t\) | marginal utility of consumption | (F1), (F2) |
| Endogenous | `Pit`, \(\hat{\Pi}_t\) | quarterly inflation | (F3), (F20) |
| Endogenous | `Piannt`, \(\hat{\Pi}^{yoy}_t\) | year-on-year inflation | (F20), (F23) |
| Endogenous | `Rt`, \(\hat{R}_t\) | nominal policy rate | (F1), (F23) |
| Endogenous | `mct`, \(\widehat{mc}_t\) | marginal cost | (F3), (F4) |
| Endogenous | `xLt`, \(\hat{x}^L_t\) | real price of labor good | (F4), (F11) |
| Endogenous | `mt`, \(\hat{m}_t\) | new matches | (F5) |
| Endogenous | `nt`, \(\hat{n}_t\) | employment | (F6), (F7), (F19) |
| Endogenous | `ut`, \(\hat{u}_t\) | unemployment | (F5), (F7), (F9) |
| Endogenous | `vt`, \(\hat{\nu}_t\) | vacancies | (F5), (F8), (F18) |
| Endogenous | `qt`, \(\hat{q}_t\) | job-filling rate | (F8), (F17) |
| Endogenous | `st`, \(\hat{s}_t\) | job-finding rate | (F9), (F16) |
| Endogenous | `wt`, \(\hat{w}_t\) | average real wage | (F11), (F12) |
| Endogenous | `wstart`, \(\hat{w}^{\ast}_t\) | reset wage | (F10), (F13)-(F16) |
| Endogenous | `deltaFt`, \(\hat{\delta}^F_t\) | firm surplus derivative | (F10), (F13) |
| Endogenous | `deltaWt`, \(\hat{\delta}^W_t\) | worker surplus derivative | (F10), (F14) |
| Endogenous | `Jstart`, \(\hat{J}^{\ast}_t\) | value of reset-wage firm | (F10), (F15), (F17) |
| Endogenous | `Deltastart`, \(\hat{\Delta}^{\ast}_t\) | worker surplus at reset wage | (F10), (F16) |
| Endogenous | `ht`, \(\hat{h}_t\) | hours per worker | (F11), (F19) |
| Endogenous | `yt`, \(\hat{y}_t\) | output | (F18), (F19), (F23) |
| Endogenous | `yflext`, \(\hat{y}^{flex}_t\) | flexible-price/flexible-wage output | (F23), (F24) |
| Endogenous shock state | `ebt`, \(\hat{\varepsilon}^b_t\) | risk-premium / preference wedge | (F25) |
| Endogenous shock state | `gt`, \(\hat{g}_t\) | government spending | (F26) |
| Endogenous shock state | `emoneyt`, \(\hat{e}^{money}_t\) | monetary-policy shock | (F27) |
| Endogenous shock state | `zt`, \(\hat{z}_t\) | technology | (F28) |
| Endogenous shock state | `ebargaint`, \(\hat{\eta}_t\) | bargaining-power shock | (F29) |
| Endogenous shock state | `ekappat`, \(\hat{\kappa}_t\) | vacancy-cost shock | (F30) |
| Endogenous shock state | `esept`, \(\hat{\vartheta}_t\) | separation shock | (F31) |
| Endogenous shock state | `eCt`, \(\hat{e}^C_t\) | cost-push shock | (F32) |
| Exogenous innovation | `inno_ebt` | innovation to risk-premium shock | (F25) |
| Exogenous innovation | `g_` | innovation to government spending | (F26) |
| Exogenous innovation | `interest_` | innovation to monetary-policy shock | (F27) |
| Exogenous innovation | `inno_zt` | innovation to technology | (F28) |
| Exogenous innovation | `inno_ebargaint` | innovation to bargaining power | (F29) |
| Exogenous innovation | `inno_ekappat` | innovation to vacancy costs | (F30) |
| Exogenous innovation | `inno_esept` | innovation to separation | (F31) |
| Exogenous innovation | `inno_eCt` | innovation to cost-push shock | (F32) |
| Parameter | `bet`, \(\beta\) | discount factor | steady state, (F1) |
| Parameter | `epsilon`, \(\varepsilon\) | elasticity of substitution | (F3), steady state |
| Parameter | `habit`, \(\varrho\) | external habit | (F2) |
| Parameter | `sig`, \(\sigma\) | risk aversion | (F2) |
| Parameter | `vphi`, \(\varphi\) | inverse Frisch elasticity | (F14), (F16) |
| Parameter | `omega`, \(\omega\) | Calvo price stickiness | (F3) |
| Parameter | `price_index`, \(\xi_p\) | price indexation | (F3) |
| Parameter | `xi`, \(\xi\) | matching elasticity on unemployment | (F5) |
| Parameter | `eta`, \(\eta\) | worker bargaining power | (F10) |
| Parameter | `gamma`, \(\gamma\) | Calvo wage stickiness | (F10), (F12)-(F17) |
| Parameter | `wage_index`, \(\xi_w\) | wage indexation | (F12)-(F17) |
| Parameter | `vtheta`, \(\vartheta\) | separation rate | (F6), (F13)-(F17) |
| Parameter | `alp`, \(\alpha\) | labor elasticity in labor-good production | (F11), (F19) |
| Parameter | `gamma_R`, `gamma_Pi`, `gamma_y`, `gamma_dy` | Taylor-rule coefficients | (F23) |
| Parameter | `rho_*`, `sig_inno*` | shock persistence and innovation scales | (F25)-(F32) |
| Parameter / steady state | `cbar`, `gbar`, `hbar`, `Jbar`, `Deltabar`, `mbar`, `nbar`, `qbar`, `sbar`, `vbar`, `wbar`, `ybar` | steady-state scalars | section 6 |
