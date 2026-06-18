# EA_CKL09 -- Derivation

Status: `needs_review` first-pass extraction from MinerU Markdown. Dynare/runtime validation was not performed.

Source: Kai Christoffel, Keith Kuester, and Tobias Linzert (2009), "The role of labor markets for euro area monetary policy", European Economic Review 53(8), 908-936, DOI `10.1016/j.euroecorev.2009.04.007`.

## 1. Model Overview

- **Model ID**: `EA_CKL09`.
- **Economy and purpose**: closed-economy euro-area New Keynesian DSGE model with Mortensen-Pissarides search and matching frictions, right-to-manage hours choice, Calvo price rigidity, and Calvo wage bargaining rigidity.
- **Implementation form**: `model(linear)` in the MMB replication cross-check. The paper gives nonlinear equilibrium objects and an Appendix A linearized economy; this archive records the linearized system used by the estimated-section implementation.
- **Main agents and blocks**: representative large family, retail aggregators, wholesale Calvo price setters, labor-good firms, matched workers, vacancy-posting firms, fiscal authority, and monetary authority.
- **Source sniff**: the first Markdown lines match the expected title and authors. No title/author mismatch was found.

## 2. Optimization Problems

### Representative Large Family

The family pools employed and unemployed members and chooses consumption, bond holdings, and vacancy posting while internalizing members' utility:

\[
E_0\sum_{t=0}^{\infty}\beta^t
\left[
\frac{(c_{i,t}-\varrho c_{t-1})^{1-\sigma}}{1-\sigma}
-\kappa^L\frac{h_{i,t}^{1+\varphi}}{1+\varphi}
\right].
\]

The family budget constraint is:

\[
c_t+t_t+\kappa_t\nu_t
=\int_0^{1-u_t}w_{i,t}h_{i,t}\,di+u_tb
+\frac{D_{t-1}}{P_t}R_{t-1}\varepsilon^b_{t-1}
-\frac{D_t}{P_t}
+\Psi_t+n_t\Phi^K .
\]

Marginal utility is \(\lambda_t=(c_t-\varrho c_{t-1})^{-\sigma}\).

### Retail Aggregator

Competitive retailers aggregate differentiated wholesale goods:

\[
y_t=\left(\int_0^1 y_{j,t}^{(\varepsilon-1)/\varepsilon}\,dj\right)^{\varepsilon/(\varepsilon-1)}.
\]

Cost minimization implies the price index and demand schedule:

\[
P_t=\left(\int_0^1P_{j,t}^{1-\varepsilon}\,dj\right)^{1/(1-\varepsilon)},\qquad
y_{j,t}=\left(\frac{P_{j,t}}{P_t}\right)^{-\varepsilon}y_t .
\]

### Wholesale Price Setters

Wholesale firm \(j\) uses one unit of the labor good per unit of output:

\[
y_{j,t}=l^d_{j,t}.
\]

A firm that can reset price chooses \(P^{\ast}_t\) to maximize discounted expected profits under Calvo price rigidity \(\omega\) and price indexation \(\xi_p\):

\[
\max_{P_{j,t}}E_t\sum_{s=0}^{\infty}\omega^s\beta_{t,t+s}
\left[
\frac{P_{j,t}\left(\Pi_{t-1,t-1+s}^{\xi_p}\Pi^{1-\xi_p}\right)^s}{P_{t+s}}
-mc_{t+s}
\right]y_{j,t+s}.
\]

### Labor-Good Firms And Wage Bargaining

Each matched labor-good firm produces:

\[
l_{i,t}=z_t h_{i,t}^{\alpha},\qquad \alpha\in(0,1).
\]

Given an hourly wage, the firm chooses hours under right-to-manage. Wage resetters solve a Nash bargaining problem over worker surplus \(\Delta_t(W_{i,t})\) and firm value \(J_t(W_{i,t})\):

\[
\arg\max_{W_{i,t}}\left[\Delta_t(W_{i,t})\right]^{\eta_t}
\left[J_t(W_{i,t})\right]^{1-\eta_t}\Rightarrow W_t^{\ast} .
\]

Vacancy posting is governed by free entry, so the real cost of a vacancy equals the discounted expected value of a filled job.

## 3. First-Order Conditions

**(F1) Consumption Euler equation**

\[
1=E_t\left\{\beta\frac{\lambda_{t+1}}{\lambda_t}
\frac{R_t\varepsilon^b_t}{\Pi_{t+1}}\right\}.
\]

Linearized form:

\[
\hat{\lambda}_t=E_t\{\hat{\lambda}_{t+1}+\hat{R}_t+\hat{\varepsilon}^b_t-\hat{\Pi}_{t+1}\}.
\]

**(F2) Marginal utility of consumption**

\[
\hat{\lambda}_t=-\frac{\sigma}{1-\varrho}(\hat{c}_t-\varrho\hat{c}_{t-1}).
\]

**(F3) Wholesale Calvo pricing FOC**

\[
E_t\sum_{s=0}^{\infty}\omega^s\beta_{t,t+s}
\left[
\frac{P_t^{\ast}\left(\Pi_{t-1,t-1+s}^{\xi_p}\Pi^{1-\xi_p}\right)^s}{P_{t+s}}
-\frac{\varepsilon}{\varepsilon-1}mc_{t+s}
\right]y_{j,t+s}=0.
\]

Linearized Phillips curve:

\[
\hat{\Pi}_t=
\frac{\xi_p}{1+\beta\xi_p}\hat{\Pi}_{t-1}
+\frac{\beta}{1+\beta\xi_p}E_t\hat{\Pi}_{t+1}
+\frac{(1-\omega)(1-\omega\beta)}{\omega(1+\beta\xi_p)}\hat{mc}_t.
\]

**(F4) Marginal cost**

\[
\hat{mc}_t=\hat{e}^C_t+\hat{x}^L_t.
\]

The paper also reports the wage channel:

\[
\hat{mc}_t=\hat{e}^C_t+\hat{w}_t+(1-\alpha)\hat{h}_t .
\]

**(F5) Labor-good firm hours condition**

\[
x^L_t\,z_t\alpha h_{i,t}^{\alpha-1}=\frac{W_{i,t}}{P_t}.
\]

Linearized aggregate-hours condition:

\[
\hat{w}_t=\hat{x}^L_t+\hat{z}_t+(\alpha-1)\hat{h}_t.
\]

**(F6) Worker employment value**

\[
\begin{aligned}
V_t^E(W_{i,t})={}&\frac{W_{i,t}}{P_t}h_{i,t}
-\kappa^L\frac{h_{i,t}^{1+\varphi}}{(1+\varphi)\lambda_t}\\
&+E_t\{\beta_{t,t+1}(1-\vartheta_{t+1})
[\gamma V_{t+1}^E(W_{i,t}\Pi_t^{\xi_w}\Pi^{1-\xi_w})
+(1-\gamma)V_{t+1}^E(W^{\ast}_{t+1})]\}\\
&+E_t\{\beta_{t,t+1}\vartheta_{t+1}U_{t+1}\}.
\end{aligned}
\]

**(F7) Worker unemployment value**

\[
\begin{aligned}
U_t={}&b+E_t\{\beta_{t,t+1}s_t[
\gamma V_{t+1}^E(W_t\Pi_t^{\xi_w}\Pi^{1-\xi_w})
+(1-\gamma)V_{t+1}^E(W^{\ast}_{t+1})]\}\\
&+E_t\{\beta_{t,t+1}(1-s_t)U_{t+1}\}.
\end{aligned}
\]

**(F8) Worker surplus**

\[
\Delta_t(W_{i,t})=V_t^E(W_{i,t})-U_t.
\]

The expanded expression in the OCR source is lengthy and contains minor OCR noise; the identity above is retained and marked `needs_review` for source-level formula checking before promotion.

**(F9) Firm value for a matched labor-good firm**

\[
J_t(W_{i,t})=\Psi^L_t(W_{i,t})
+E_t\{\beta_{t,t+1}(1-\vartheta_{t+1})
[\gamma J_{t+1}(W_{i,t}\Pi_t^{\xi_w}\Pi^{1-\xi_w})
+(1-\gamma)J_{t+1}(W^{\ast}_{t+1})]\}.
\]

**(F10) Period profit of a labor-good firm**

\[
\Psi^L_t(W_{i,t})=x^L_tz_t h_{i,t}^{\alpha}
-\frac{W_{i,t}}{P_t}h_{i,t}-\Phi.
\]

**(F11) Nash wage reset condition**

\[
\eta_t J_t(W_t^{\ast})\,\frac{\partial \Delta_t(W_t^{\ast})}{\partial W_t}
+(1-\eta_t)\Delta_t(W_t^{\ast})\,\frac{\partial J_t(W_t^{\ast})}{\partial W_t}=0.
\]

Linearized implementation form:

\[
\hat{J}^{\ast}_t+\hat{\delta}^W_t
=\hat{\Delta}^{\ast}_t+\hat{\delta}^F_t-\frac{1}{1-\eta}\hat{\eta}_t .
\]

The derivative notation and the linearized equation are `needs_review` against the Appendix OCR.

**(F12) Aggregate real wage law of motion**

\[
\hat{w}_t=\gamma(\hat{w}_{t-1}-\hat{\Pi}_t+\xi_w\hat{\Pi}_{t-1})
+(1-\gamma)\hat{w}^{\ast}_t.
\]

**(F13) Firm wage-derivative auxiliary**

\[
\begin{aligned}
\hat{\delta}^F_t={}&[1-\beta(1-\vartheta)\gamma]
\left[-\frac{\alpha}{1-\alpha}\hat{w}^{\ast}_t
+\frac{1}{1-\alpha}(\hat{x}^L_t+\hat{z}_t)\right]\\
&+\beta(1-\vartheta)\gamma E_t\left\{
-\frac{\alpha}{1-\alpha}(\hat{w}^{\ast}_t-\hat{\Pi}_{t+1}
+\xi_w\hat{\Pi}_t-\hat{w}^{\ast}_{t+1})
+\hat{\delta}^F_{t+1}
+\hat{\lambda}_{t+1}-\hat{\lambda}_t
-\frac{\vartheta}{1-\vartheta}\hat{\vartheta}_{t+1}
\right\}.
\end{aligned}
\]

**(F14) Worker wage-derivative auxiliary**

\[
\begin{aligned}
\delta^W\hat{\delta}^W_t={}&
-\frac{\alpha}{1-\alpha}wh
\left[-\frac{\alpha}{1-\alpha}\hat{w}^{\ast}_t
+\frac{1}{1-\alpha}(\hat{x}^L_t+\hat{z}_t)\right]\\
&+\frac{1}{1-\alpha}mrsh
\left[-\frac{1+\varphi}{1-\alpha}\hat{w}^{\ast}_t-\hat{\lambda}_t
+\frac{1+\varphi}{1-\alpha}(\hat{x}^L_t+\hat{z}_t)\right]\\
&+\frac{\beta(1-\vartheta)\gamma}{1-\beta(1-\vartheta)\gamma}
\left[\left(\frac{\alpha}{1-\alpha}\right)^2wh
-\frac{1+\varphi}{(1-\alpha)^2}mrsh\right]
E_t(\hat{w}^{\ast}_t-\hat{\Pi}_{t+1}+\xi_w\hat{\Pi}_t-\hat{w}^{\ast}_{t+1})\\
&+\beta(1-\vartheta)\gamma\delta^W
E_t(\hat{\lambda}_{t+1}-\hat{\lambda}_t+\hat{\delta}^W_{t+1}
-\frac{\vartheta}{1-\vartheta}\hat{\vartheta}_{t+1}).
\end{aligned}
\]

This OCR-derived appendix equation is `needs_review`.

**(F15) Vacancy posting free-entry condition**

\[
\kappa_t=q_tE_t\{\beta_{t,t+1}[
\gamma J_{t+1}(W_t\Pi_t^{\xi_w}\Pi^{1-\xi_w})
+(1-\gamma)J_{t+1}(W^{\ast}_{t+1})]\}.
\]

Linearized form:

\[
\frac{\kappa}{q}(\hat{\kappa}_t-\hat{q}_t)
=\frac{\beta\gamma}{1-\beta(1-\vartheta)\gamma}wh
E_t(\hat{w}^{\ast}_{t+1}+\hat{\Pi}_{t+1}-\hat{w}_t-\xi_w\hat{\Pi}_t)
+\beta J E_t(\hat{\lambda}_{t+1}-\hat{\lambda}_t+\hat{J}^{\ast}_{t+1}).
\]

**(F16) Value of reset-wage firm**

\[
\begin{aligned}
J\hat{J}^{\ast}_t={}&\frac{wh}{\alpha}(-\alpha\hat{w}^{\ast}_t+\hat{x}^L_t+\hat{z}_t)\\
&+\frac{\beta(1-\vartheta)\gamma}{1-\beta(1-\vartheta)\gamma}wh
E_t(\hat{w}^{\ast}_{t+1}+\hat{\Pi}_{t+1}-\hat{w}^{\ast}_t-\xi_w\hat{\Pi}_t)\\
&+\beta(1-\vartheta)J
E_t(\hat{\lambda}_{t+1}-\hat{\lambda}_t+\hat{J}^{\ast}_{t+1}
-\frac{\vartheta}{1-\vartheta}\hat{\vartheta}_{t+1}).
\end{aligned}
\]

This Appendix OCR equation is `needs_review`.

**(F17) Value of reset-wage worker surplus**

\[
\begin{aligned}
\Delta\hat{\Delta}^{\ast}_t={}&
wh\frac{1}{1-\alpha}(-\alpha\hat{w}^{\ast}_t+\hat{x}^L_t+\hat{z}_t)\\
&-\frac{1}{1+\varphi}mrsh
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

This Appendix OCR equation is `needs_review`.

## 4. Market Clearing & Identities

**(F18) Matching function**

\[
m_t=\sigma_m u_t^{\xi}\nu_t^{1-\xi}.
\]

Linearized:

\[
\hat{m}_t=\xi\hat{u}_t+(1-\xi)\hat{\nu}_t.
\]

**(F19) Labor-market tightness**

\[
\theta_t=\frac{\nu_t}{u_t}.
\]

**(F20) Vacancy filling probability**

\[
q_t=\frac{m_t}{\nu_t}=\sigma_m\theta_t^{-\xi},\qquad
\hat{q}_t=\hat{m}_t-\hat{\nu}_t.
\]

**(F21) Job finding probability**

\[
s_t=\frac{m_t}{u_t}=\sigma_m\theta_t^{1-\xi},\qquad
\hat{s}_t=\hat{m}_t-\hat{u}_t.
\]

**(F22) Employment law of motion**

\[
n_t=(1-\vartheta_t)n_{t-1}+m_{t-1}.
\]

Linearized:

\[
\hat{n}_t=(1-\vartheta)\hat{n}_{t-1}+\frac{m}{n}\hat{m}_{t-1}
-\vartheta\hat{\vartheta}_t.
\]

**(F23) Unemployment identity**

\[
n_t=1-u_t,\qquad
\hat{n}_t=-\frac{u}{1-u}\hat{u}_t.
\]

**(F24) Retail resource constraint**

\[
y^d_t=c_t+g_t+\kappa_t\nu_t+n_t\Phi^L.
\]

Linearized:

\[
y\hat{y}_t=c\hat{c}_t+g\hat{g}_t+\kappa\nu(\hat{\kappa}_t+\hat{\nu}_t)+\Phi^L n\hat{n}_t.
\]

**(F25) Aggregate production**

\[
y_t=n_t z_t h_t^\alpha,\qquad
\hat{y}_t=\hat{z}_t+\alpha\hat{h}_t+\hat{n}_t.
\]

**(F26) Government budget constraint**

\[
t_t+\frac{D_t}{P_t}+(e^C_t-1)x^L_t
=u_tb+\frac{D_{t-1}}{P_t}R_{t-1}\varepsilon^b_{t-1}+g_t.
\]

**(F27) Year-on-year inflation identity**

\[
\hat{\Pi}^{yoy}_t=\hat{\Pi}_t+\hat{\Pi}_{t-1}+\hat{\Pi}_{t-2}+\hat{\Pi}_{t-3}.
\]

**(F28) Average labor-firm profits**

\[
\hat{\Psi}^L_t=A(\hat{w}_t+\hat{h}_t),\qquad
A=\frac{\frac{1-\alpha}{\alpha}wh}{\frac{1-\alpha}{\alpha}wh-\Phi}.
\]

**(F29) Average wholesale profits**

\[
\Psi^C\hat{\Psi}^C_t=(1-mc)y\hat{y}_t-ymc\hat{mc}_t.
\]

## 5. Exogenous Processes

**(F30) Risk-premium shock**

\[
\log(\varepsilon^b_t)=\rho_b\log(\varepsilon^b_{t-1})+e^b_t.
\]

Linearized implementation cross-check:

\[
\hat{\varepsilon}^b_t=\rho_b\hat{\varepsilon}^b_{t-1}+\sigma_b\epsilon^b_t.
\]

**(F31) Technology**

\[
\log(z_t)=(1-\rho_z)\log(z)+\rho_z\log(z_{t-1})+e^z_t.
\]

**(F32) Separation rate**

\[
\log(\vartheta_t)=(1-\rho_\vartheta)\log(\vartheta)
+\rho_\vartheta\log(\vartheta_{t-1})+e^\vartheta_t.
\]

**(F33) Bargaining power**

\[
\log(\eta_t)=(1-\rho_\eta)\log(\eta)+\rho_\eta\log(\eta_{t-1})+e^\eta_t.
\]

**(F34) Vacancy posting cost**

\[
\log(\kappa_t)=(1-\rho_\kappa)\log(\kappa)+\rho_\kappa\log(\kappa_{t-1})+e^\kappa_t.
\]

**(F35) Government spending**

\[
\log(g_t)=(1-\rho_g)\bar{g}+\rho_g\log(g_{t-1})+e^g_t.
\]

**(F36) Monetary policy rule**

\[
\begin{aligned}
\log(R_t)={}&(1-\gamma_R)\log\left(\frac{\bar{\Pi}}{\beta}\right)
+\gamma_R\log(R_{t-1})
+\gamma_{\Delta y}\log\left(\frac{y_t}{y_{t-1}}\right)\\
&+(1-\gamma_R)\left[
\frac{\gamma_\pi}{4}\log\left(\frac{(\Pi^{yoy}_t)}{\bar{\Pi}^4}\right)
+\frac{\gamma_y}{4}\log\left(\frac{y_t}{y^{flex}_t}\right)
\right]
+\log(e^{money}_t).
\end{aligned}
\]

Linearized:

\[
\hat{R}_t=\gamma_R\hat{R}_{t-1}
+(1-\gamma_R)\left[\frac{\gamma_\pi}{4}\hat{\Pi}^{yoy}_t
+\frac{\gamma_y}{4}(\hat{y}_t-\hat{y}^{flex}_t)\right]
+\gamma_{\Delta y}(\hat{y}_t-\hat{y}_{t-1})+\hat{e}^{money}_t.
\]

**(F37) Cost-push shock**

\[
\hat{e}^C_t=\rho_C\hat{e}^C_{t-1}+\sigma_C\epsilon^C_t.
\]

## 6. Steady-State Solution

The steady state reported in Appendix A is used for the log-linearization. The model normalizes output and uses hats for percentage deviations from this steady state.

1. Interest rate:

\[
R=\frac{1}{\beta}.
\]

2. Marginal utility:

\[
\lambda=(c-\varrho c)^{-\sigma}.
\]

3. Marginal cost and price of the labor good:

\[
mc=x^L=\frac{\varepsilon-1}{\varepsilon}.
\]

4. Matching and stocks:

\[
m=\sigma_m u^\xi\nu^{1-\xi},\qquad
\vartheta n=m,\qquad
u=1-n,\qquad
q=\frac{m}{\nu},\qquad
s=\frac{m}{u}.
\]

5. Wage-bargaining steady-state auxiliary conditions:

\[
\eta J\delta^W=(1-\eta)\Delta\delta^F,
\]

\[
\delta^F=\frac{1}{1-\beta(1-\vartheta)\gamma}wh,
\]

\[
\delta^W=\frac{1}{1-\beta(1-\vartheta)\gamma}h
\left[-\frac{\alpha}{1-\alpha}w+\frac{1}{1-\alpha}mrs\right].
\]

6. Labor-firm objects:

\[
mrs=\frac{\kappa^L h^\varphi}{\lambda},\qquad
J=\frac{\Psi^L}{1-\beta(1-\vartheta)},\qquad
\Psi^L=x^Lzh^\alpha-wh-\Phi.
\]

7. Worker surplus, hours, and vacancy posting:

\[
\Delta=\frac{1}{1-\beta(1-\vartheta-s)}
\left[wh-\frac{mrs\,h}{1+\varphi}-b\right],
\]

\[
w=x^Lz\alpha h^{\alpha-1},\qquad
\kappa=q\beta J.
\]

8. Resource and production:

\[
y=c+g+\kappa\nu+n\Phi^L,\qquad
y=nzh^\alpha.
\]

9. Wholesale profits:

\[
\Psi^C=(1-mc)y.
\]

Calibration targets recorded in the paper include \(y=1\), \(h=1/3\), \(u\simeq 0.091\), \(q=0.7\), government spending near 20 percent of GDP, and a replacement-rate target \(b/(wh)=0.65\). The estimated-section `.mod` cross-check uses posterior/calibrated values from Section 5 where applicable; steady-state formulas above remain paper-side evidence.

## 7. Timing & Form Conventions

- **Form**: `model(linear)`; variables in the linearized system are hat/log-deviation objects around the deterministic steady state.
- **Matching timing**: matches formed in \(t\) become productive in \(t+1\); employment uses \(n_t=(1-\vartheta_t)n_{t-1}+m_{t-1}\).
- **Wage timing**: incumbent and newly formed matches are subject to Calvo wage reset probability. Non-reset wages are indexed to lagged/steady-state inflation through \(\xi_w\).
- **Policy target**: the Taylor rule reacts to year-on-year inflation and the output gap relative to the flexible-price/flexible-wage economy.
- **No capital accumulation block**: the model imputes a fixed capital-income share through \(\Phi^K\) rather than modeling physical capital accumulation.
- **Runtime validation**: not performed.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Main equations |
|---|---|---|---|
| Endogenous | \(\hat{c}_t\) / `ct` | consumption | (F1), (F2), (F24) |
| Endogenous | \(\hat{\lambda}_t\) / `lambdat` | marginal utility | (F1), (F2) |
| Endogenous | \(\hat{\Pi}_t\) / `Pit` | inflation | (F3), (F27) |
| Endogenous | \(\hat{\Pi}^{yoy}_t\) / `Piannt` | year-on-year inflation | (F27), (F36) |
| Endogenous | \(\hat{R}_t\) / `Rt` | nominal policy rate | (F1), (F36) |
| Endogenous | \(\hat{mc}_t\) / `mct` | marginal cost | (F3), (F4) |
| Endogenous | \(\hat{x}^L_t\) / `xLt` | real price of labor good | (F4), (F5) |
| Endogenous | \(\hat{w}_t\) / `wt` | aggregate real wage | (F5), (F12) |
| Endogenous | \(\hat{w}^{\ast}_t\) / `wstart` | reset wage | (F11)-(F17) |
| Endogenous | \(\hat{h}_t\) / `ht` | hours per worker | (F5), (F25) |
| Endogenous | \(\hat{y}_t\) / `yt` | output | (F24), (F25), (F36) |
| Endogenous | \(\hat{m}_t\) / `mt` | matches | (F18), (F22) |
| Endogenous | \(\hat{n}_t\) / `nt` | employment | (F22), (F23), (F25) |
| Endogenous | \(\hat{u}_t\) / `ut` | unemployment | (F18), (F23) |
| Endogenous | \(\hat{\nu}_t\) / `vt` | vacancies | (F18), (F20), (F24) |
| Endogenous | \(\hat{q}_t\) / `qt` | vacancy filling probability | (F20), (F15) |
| Endogenous | \(\hat{s}_t\) / `st` | job finding probability | (F21), (F17) |
| Endogenous | \(\hat{J}^{\ast}_t\) / `Jstart` | value of reset-wage firm | (F11), (F16) |
| Endogenous | \(\hat{\Delta}^{\ast}_t\) / `Deltastart` | reset-wage worker surplus | (F11), (F17) |
| Endogenous | \(\hat{\delta}^F_t\) / `deltaFt` | firm wage-derivative auxiliary | (F11), (F13) |
| Endogenous | \(\hat{\delta}^W_t\) / `deltaWt` | worker wage-derivative auxiliary | (F11), (F14) |
| Endogenous | \(\hat{y}^{flex}_t\) and flex variables | flexible-price/flexible-wage counterpart | (F36) |
| Exogenous | \(\epsilon^b_t\) / `inno_ebt` | risk-premium innovation | (F30) |
| Exogenous | \(\epsilon^z_t\) / `inno_zt` | technology innovation | (F31) |
| Exogenous | \(\epsilon^\eta_t\) / `inno_ebargaint` | bargaining-power innovation | (F33) |
| Exogenous | \(\epsilon^\kappa_t\) / `inno_ekappat` | vacancy-cost innovation | (F34) |
| Exogenous | \(\epsilon^\vartheta_t\) / `inno_esept` | separation-rate innovation | (F32) |
| Exogenous | \(\epsilon^C_t\) / `inno_eCt` | cost-push innovation | (F37) |
| Exogenous | \(\epsilon^{money}_t\) / `interest_` | monetary-policy innovation | (F36) |
| Exogenous | \(\epsilon^g_t\) / `g_` | government-spending innovation | (F35) |
| Parameter | \(\beta,\sigma,\varrho,\varphi,\kappa^L\) | preferences | (F1), (F2), steady state |
| Parameter | \(\varepsilon,\omega,\xi_p\) | demand elasticity and price rigidity | (F3) |
| Parameter | \(\alpha,z,\Phi,\Phi^K,\Phi^L\) | labor-good production and fixed costs | (F5), (F10), (F24), (F25) |
| Parameter | \(\xi,\sigma_m,\vartheta,\eta,\gamma,\xi_w\) | matching, separations, bargaining, wage rigidity | (F18)-(F23), (F11)-(F17) |
| Parameter | \(\gamma_R,\gamma_\pi,\gamma_y,\gamma_{\Delta y}\) | policy-rule coefficients | (F36) |
| Parameter | \(\rho_b,\rho_z,\rho_\vartheta,\rho_\eta,\rho_\kappa,\rho_g,\rho_C\) | shock persistence | (F30)-(F37) |
