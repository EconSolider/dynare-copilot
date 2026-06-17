# NK_CK08 -- Derivation (Optimization Problems + First-Order Conditions)

> First-pass archive extraction for `NK_CK08`. Status: `needs_review`. Runtime validation was not performed.

Provenance: Kai Christoffel and Keith Kuester (2008), "Resuscitating the wage channel in models with unemployment fluctuations", Journal of Monetary Economics 55(5), 865-887, DOI `10.1016/j.jmoneco.2008.03.009`. Source Markdown: `raw/mmb_mineru/runs/nk_ck08__resuscitating_the_wage_channel_in_models_with_unemployment__9824f7f5/full.md`. Raw PDF: `raw/mmb_papers/Resuscitating the wage channel in models with unemployment.pdf`. MinerU run id: `9824f7f5-cffe-47c7-8bf0-1ade5a06c243`.

## 1. Model Overview

- **Model**: New Keynesian model with search-and-matching unemployment, right-to-manage wage bargaining, Calvo nominal wage setting, Calvo price setting, and fixed job-related costs.
- **Archive form**: linearized equilibrium system, `model(linear)`, around a monthly steady state. Variables with hats denote log deviations from steady state, except rate/inflation variables following the paper's appendix and the MMB implementation.
- **Main agents and blocks**: representative family, retail bundlers, wholesale price setters, labor-good firms, matched workers, vacancy-posting firms, monetary authority, and Ricardian fiscal authority.
- **Key mechanism**: wages affect the labor-good price and hence marginal cost directly; fixed costs make labor-firm profits small and amplify vacancy/unemployment responses.
- **Implementation cross-check**: `.agents/skills/dynare-copilot/references/examples/NK_CK08_rep.mod` is a quarterly recalibration of the monthly paper model. It confirms a `model(linear)` block and variable coverage, but it is not used as a paper-side source.

## 2. Optimization Problems

### 2.1 Representative family

The family pools income across employed and unemployed members, chooses consumption and nominal bond holdings, and internalizes habit in marginal utility:

$$
\max_{\{c_t,D_t\}} E_0 \sum_{t=0}^{\infty}\beta^t
U(c_t,c_{t-1},u_t,\{h_{i,t}\})
$$

subject to:

$$
c_t+t_t=\int_0^{1-u_t} w_{i,t}h_{i,t}di+u_tb+
\frac{D_{t-1}}{P_t}R_{t-1}\varepsilon^b_{t-1}
-\frac{D_t}{P_t}+\Psi_t .
$$

Marginal utility is:

$$
\lambda_t=(c_t-\varrho c_{t-1})^{-\sigma}.
$$

### 2.2 Retail and wholesale firms

Retailers aggregate differentiated goods:

$$
y_t=\left(\int_0^1 y_{j,t}^{(\varepsilon-1)/\varepsilon}dj\right)^{\varepsilon/(\varepsilon-1)} .
$$

Wholesale firms use the homogeneous labor good one-for-one:

$$
y_{j,t}=y_{j,t}^{L,d},
$$

and firms that can reoptimize choose $P^*_{t}$ to maximize:

$$
E_t\sum_{s=0}^{\infty}\omega^s\beta_{t,t+s}
\left[\frac{P^*_t}{P_{t+s}}-mc_{t+s}\right]y_{j,t+s}.
$$

### 2.3 Labor-good firms, matches, and wage bargaining

A labor-good firm is one matched worker-firm pair:

$$
y^L_{i,t}=z_t h_{i,t}^{\alpha},\qquad \alpha\in(0,1).
$$

Given a negotiated nominal hourly wage, right-to-manage firms choose hours from marginal profitability:

$$
x^L_t z_t\alpha h_{i,t}^{\alpha-1}=\frac{W_{i,t}}{P_t}.
$$

The worker surplus and firm value entering Nash bargaining are:

$$
\Delta_t(W_{i,t})=V_t^E(W_{i,t})-U_t,
$$

$$
J_t(W_{i,t})=\Psi_t^L(W_{i,t})+(1-\vartheta)E_t\{\beta_{t,t+1}[\gamma J_{t+1}(W_{i,t})+(1-\gamma)J_{t+1}(W^*_{t+1})]\}.
$$

The reset wage solves:

$$
\max_{W_{i,t}}\,[\Delta_t(W_{i,t})]^{\eta_t}[J_t(W_{i,t})]^{1-\eta_t}.
$$

### 2.4 Vacancy posting and government

Free entry sets the value of vacancies to zero:

$$
\kappa=q_tE_t\{\beta_{t,t+1}[\gamma J_{t+1}(W_t)+(1-\gamma)J_{t+1}(W^*_{t+1})]\}.
$$

The monetary authority follows a Taylor-type rule for the nominal rate, and the government finances unemployment benefits, debt service, and exogenous spending through lump-sum taxes and debt.

## 3. First-Order Conditions

The linearized system below is the paper's RTM model economy in appendix A.2, with equation numbering assigned for this archive. Several long wage-surplus recursions are marked `needs_review` because the MinerU source has OCR ambiguity in symbols such as $\vartheta$ versus `9`; the intended economics is cross-checked against the replication `.mod`.

- **(F1) Consumption Euler equation**:
$$
\widehat{\lambda}_t=E_t\{\widehat{\lambda}_{t+1}+\widehat R_t+\widehat\varepsilon^b_t-\widehat\Pi_{t+1}\}.
$$

- **(F2) Marginal utility of consumption**:
$$
\widehat{\lambda}_t=-\frac{\sigma}{1-\varrho}\left(\widehat c_t-\varrho\widehat c_{t-1}\right).
$$

- **(F3) New Keynesian Phillips curve**:
$$
\widehat\Pi_t=\beta E_t\{\widehat\Pi_{t+1}\}+
\frac{(1-\omega)(1-\omega\beta)}{\omega}\widehat{mc}_t .
$$

- **(F4) Marginal cost equals the labor-good price**:
$$
\widehat{mc}_t=\widehat{x}^L_t .
$$

- **(F5) Wage-bargaining FOC**:
$$
\widehat J^*_t+\widehat\delta^W_t=
\widehat\Delta^*_t+\widehat\delta^F_t-\frac{1}{1-\eta}\widehat\eta_t .
$$

- **(F6) Hours FOC under right-to-manage**:
$$
\widehat{x}^L_t+\widehat z_t+(\alpha-1)\widehat h_t=\widehat w_t .
$$

- **(F7) Aggregate real wage evolution**:
$$
\widehat w_t=\gamma(\widehat w_{t-1}-\widehat\Pi_t)+(1-\gamma)\widehat w^*_t .
$$

- **(F8) Firm-side marginal wage-surplus recursion** (`needs_review`, OCR-sensitive long formula):
$$
\begin{aligned}
\widehat\delta^F_t={}&[1-\beta(1-\vartheta)\gamma]\left[
-\frac{\alpha}{1-\alpha}\widehat w^*_t+
\frac{1}{1-\alpha}(\widehat{x}^L_t+\widehat z_t)\right] \\
&+\beta(1-\vartheta)\gamma E_t\left\{
-\frac{\alpha}{1-\alpha}(\widehat w^*_t-\widehat w^*_{t+1}-\widehat\Pi_{t+1})
+\widehat\delta^F_{t+1}+\widehat\lambda_{t+1}-\widehat\lambda_t\right\}.
\end{aligned}
$$

- **(F9) Worker-side marginal wage-surplus recursion** (`needs_review`, OCR-sensitive long formula):
$$
\begin{aligned}
\delta^W\widehat\delta^W_t={}&-\frac{\alpha}{1-\alpha}wh
\left[-\frac{\alpha}{1-\alpha}\widehat w^*_t+
\frac{1}{1-\alpha}(\widehat{x}^L_t+\widehat z_t)\right] \\
&+\frac{1}{1-\alpha}mrsh
\left[-\frac{1+\varphi}{1-\alpha}\widehat w^*_t-\widehat\lambda_t+
\frac{1+\varphi}{1-\alpha}(\widehat{x}^L_t+\widehat z_t)\right] \\
&+\frac{\beta(1-\vartheta)\gamma}{1-\beta(1-\vartheta)\gamma}
\left[\left(\frac{\alpha}{1-\alpha}\right)^2wh-
\frac{1+\varphi}{(1-\alpha)^2}mrsh\right]
E_t\{\widehat w^*_t-\widehat w^*_{t+1}-\widehat\Pi_{t+1}\} \\
&+\beta(1-\vartheta)\gamma\delta^W
E_t\{\widehat\lambda_{t+1}-\widehat\lambda_t+\widehat\delta^W_{t+1}\}.
\end{aligned}
$$

- **(F10) Value of a resetting labor firm** (`needs_review`):
$$
\begin{aligned}
J\widehat J^*_t={}&\frac{wh}{\alpha}
[-\alpha\widehat w^*_t+\widehat{x}^L_t+\widehat z_t] \\
&+\frac{\beta(1-\vartheta)\gamma}{1-\beta(1-\vartheta)\gamma}wh
E_t\{\widehat w^*_{t+1}+\widehat\Pi_{t+1}-\widehat w^*_t\} \\
&+\beta(1-\vartheta)J
E_t\{\widehat\lambda_{t+1}-\widehat\lambda_t+\widehat J^*_{t+1}\}.
\end{aligned}
$$

- **(F11) Worker surplus at a resetting wage** (`needs_review`):
$$
\begin{aligned}
\Delta\widehat\Delta^*_t={}&\frac{wh}{1-\alpha}
[-\alpha\widehat w^*_t+\widehat{x}^L_t+\widehat z_t]\\
&-\frac{mrsh}{1+\varphi}\left[
\frac{1+\varphi}{1-\alpha}(-\widehat w^*_t+\widehat{x}^L_t+\widehat z_t)
-\widehat\lambda_t\right] \\
&+\frac{\beta(1-\vartheta)\gamma}{1-\beta(1-\vartheta)\gamma}
\left[\frac{\alpha}{1-\alpha}wh-\frac{1}{1-\alpha}mrsh\right]
E_t\{\widehat w^*_{t+1}+\widehat\Pi_{t+1}-\widehat w^*_t\}\\
&-\frac{\beta\gamma s}{1-\beta(1-\vartheta)\gamma}
\left[\frac{\alpha}{1-\alpha}wh-\frac{1}{1-\alpha}mrsh\right]
E_t\{\widehat w^*_{t+1}+\widehat\Pi_{t+1}-\widehat w_t\}\\
&+\beta(1-\vartheta-s)\Delta
E_t\{\widehat\lambda_{t+1}-\widehat\lambda_t+\widehat\Delta^*_{t+1}\}
-\beta\Delta s\widehat s_t .
\end{aligned}
$$

- **(F12) Vacancy posting condition**:
$$
-\frac{\kappa}{q}\widehat q_t=
\frac{\beta\gamma}{1-\beta(1-\vartheta)\gamma}wh
E_t\{\widehat w^*_{t+1}+\widehat\Pi_{t+1}-\widehat w_t\}
+\beta J E_t\{\widehat\lambda_{t+1}-\widehat\lambda_t+\widehat J^*_{t+1}\}.
$$

## 4. Market Clearing & Identities

- **(F13) Cobb-Douglas matching function**:
$$
\widehat m_t=\xi\widehat u_t+(1-\xi)\widehat v_t .
$$

- **(F14) Employment law of motion**:
$$
\widehat n_t=(1-\vartheta)\widehat n_{t-1}+\frac{m}{n}\widehat m_{t-1}.
$$

- **(F15) Employment-unemployment link**:
$$
\widehat n_t=-\frac{u}{1-u}\widehat u_t .
$$

- **(F16) Worker-filling probability**:
$$
\widehat q_t=\widehat m_t-\widehat v_t .
$$

- **(F17) Job-finding probability**:
$$
\widehat s_t=\widehat m_t-\widehat u_t .
$$

- **(F18) Resource constraint**:
$$
y\widehat y_t=c\widehat c_t+g\widehat g_t+\kappa v\widehat v_t+\Phi n\widehat n_t .
$$

- **(F19) Aggregate production**:
$$
\widehat y_t=\widehat z_t+\alpha\widehat h_t+\widehat n_t .
$$

- **(F20) Average labor-good profit**:
$$
\widehat\Psi^L_t=
\frac{\frac{1-\alpha}{\alpha}wh}{\frac{1-\alpha}{\alpha}wh-\Phi}
(\widehat w_t+\widehat h_t).
$$

- **(F21) Annual inflation identity**:
$$
\widehat\Pi^a_t=\widehat\Pi_t+\widehat\Pi_{t-1}+\widehat\Pi_{t-2}+\widehat\Pi_{t-3}.
$$

## 5. Exogenous Processes

- **(F22) Taylor rule with interest-rate smoothing**:
$$
\widehat R_t=\gamma_R\widehat R_{t-1}
+(1-\gamma_R)\left[\frac{\gamma_\pi}{12}\widehat\Pi^a_{t-1}
+\frac{\gamma_y}{12}\widehat y_t\right]
+\widehat\varepsilon^{money}_t .
$$

- **(F23) Preference/risk-premium shock**:
$$
\widehat\varepsilon^b_t=\rho_b\widehat\varepsilon^b_{t-1}+\zeta^b_t,\qquad
\zeta^b_t\sim iid\,N(0,\sigma_b^2).
$$

- **(F24) Technology shock**:
$$
\widehat z_t=\rho_z\widehat z_{t-1}+\zeta^z_t,\qquad
\zeta^z_t\sim iid\,N(0,\sigma_z^2).
$$

- **(F25) Government spending shock**:
$$
\widehat g_t=\rho_g\widehat g_{t-1}+\zeta^g_t,\qquad
\zeta^g_t\sim iid\,N(0,\sigma_g^2).
$$

- **(F26) Monetary policy innovation**:
$$
\widehat\varepsilon^{money}_t=\zeta^{money}_t,\qquad
\zeta^{money}_t\sim iid\,N(0,\sigma_{money}^2).
$$

## 6. Steady-State Solution

The archive form is linearized, so simulated variables are deviations around a nonzero monthly steady state. The paper gives the following steady-state system for the RTM model:

1. Set $\Pi=1$, $\Pi^a=4\Pi$ in the paper's monthly notation, $R=\Pi/\beta$, and $mc=x^L=(\varepsilon-1)/\varepsilon$.
2. Labor market:
$$
m=\sigma_m u^\xi v^{1-\xi},\qquad \vartheta n=m,\qquad u=1-n,\qquad q=m/v,\qquad s=m/u.
$$
3. Marginal utility and hours:
$$
\lambda=(c-\varrho c)^{-\sigma},\qquad
w=x^Lz\alpha h^{\alpha-1},\qquad
mrs=\frac{\kappa^L h^\varphi}{\lambda}.
$$
4. Bargaining and marginal wage-surplus terms:
$$
\eta J\delta^W=(1-\eta)\Delta\delta^F,
$$
$$
\delta^F=\frac{wh}{1-\beta(1-\vartheta)\gamma},
\qquad
\delta^W=\frac{h}{1-\beta(1-\vartheta)\gamma}
\left[-\frac{\alpha}{1-\alpha}w+\frac{1}{1-\alpha}mrs\right].
$$
5. Firm and worker values:
$$
J=\frac{\frac{1-\alpha}{\alpha}wh-\Phi}{1-\beta(1-\vartheta)},\qquad
\Delta=\frac{wh-b-\frac{mrs\,h}{1+\varphi}}{1-\beta(1-\vartheta-s)}.
$$
6. Vacancy and resource equations:
$$
\kappa=q\beta J,\qquad
y=c+g+\kappa v+\Phi n,\qquad
y=nzh^\alpha.
$$

Calibration targets in the source include $y=1$, $h=1/3$, $u=0.0588$, quarterly worker-filling probability 0.70, replacement rate $b/(wh)=0.4$, and $c/(c+g)\approx0.65$. The MMB replication cross-check uses a quarterly recalibration, so numerical steady states differ from the monthly paper calibration.

## 7. Timing & Form Conventions

- **Form**: linearized `model(linear)` in hat variables.
- **Frequency**: paper model is monthly; the available MMB replication file states that it is recalibrated to quarterly frequency.
- **Stocks and flows**: new matches $m_t$ become productive in $t+1$, so employment depends on lagged employment and lagged matches in (F14).
- **Nominal contracts**: Calvo price non-reoptimization probability is $\omega$; Calvo wage non-rebargaining probability is $\gamma$.
- **Wage timing**: the aggregate wage evolves from lagged real wages adjusted by current inflation plus newly reset wages in (F7).
- **Runtime validation**: not performed in this archive pass.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII hint | Meaning | Main equation(s) |
|---|---|---|---|
| Endogenous | $\widehat c_t$ / `ct` | Consumption deviation | (F2), (F18) |
| Endogenous | $\widehat\lambda_t$ / `lambdat` | Marginal utility deviation | (F1), (F2) |
| Endogenous | $\widehat R_t$ / `Rt` | Nominal policy-rate deviation | (F1), (F22) |
| Endogenous | $\widehat\Pi_t$ / `Pit` | Inflation deviation | (F1), (F3), (F7) |
| Endogenous | $\widehat\Pi^a_t$ / `Piannt` | Annual inflation deviation | (F21), (F22) |
| Endogenous | $\widehat{mc}_t$ / `mct` | Marginal cost deviation | (F3), (F4) |
| Endogenous | $\widehat{x}^L_t$ / `xLt` | Labor-good price deviation | (F4), (F6) |
| Endogenous | $\widehat w_t$ / `wt` | Aggregate real wage deviation | (F6), (F7) |
| Endogenous | $\widehat w^*_t$ / `wstart` | Newly reset wage deviation | (F5), (F7)-(F11) |
| Endogenous | $\widehat h_t$ / `ht` | Hours per worker deviation | (F6), (F19) |
| Endogenous | $\widehat J^*_t$ / `Jstart` | Value of resetting labor firm | (F5), (F10), (F12) |
| Endogenous | $\widehat\Delta^*_t$ / `Deltastart` | Worker surplus at reset wage | (F5), (F11) |
| Endogenous | $\widehat\delta^F_t$ / `deltaFt` | Firm-side wage derivative | (F5), (F8) |
| Endogenous | $\widehat\delta^W_t$ / `deltaWt` | Worker-side wage derivative | (F5), (F9) |
| Endogenous | $\widehat m_t$ / `mt` | New matches deviation | (F13), (F14) |
| Endogenous | $\widehat n_t$ / `nt` | Employment deviation | (F14), (F15), (F19) |
| Endogenous | $\widehat u_t$ / `ut` | Unemployment deviation | (F13), (F15), (F17) |
| Endogenous | $\widehat v_t$ / `vt` | Vacancies deviation | (F13), (F16), (F18) |
| Endogenous | $\widehat q_t$ / `qt` | Worker-filling rate deviation | (F12), (F16) |
| Endogenous | $\widehat s_t$ / `st` | Job-finding rate deviation | (F11), (F17) |
| Endogenous | $\widehat y_t$ / `yt` | Output deviation | (F18), (F19), (F22) |
| Endogenous | $\widehat\Psi^L_t$ | Average labor-good profit deviation | (F20) |
| Exogenous/state | $\widehat\varepsilon^b_t$ / `ebt` | Preference/risk-premium shock state | (F1), (F23) |
| Exogenous/state | $\widehat z_t$ / `zt` | Technology shock state | (F6), (F19), (F24) |
| Exogenous/state | $\widehat g_t$ / `gt` | Government spending shock state | (F18), (F25) |
| Exogenous/state | $\widehat\varepsilon^{money}_t$ / `emoneyt` | Monetary-policy shock state | (F22), (F26) |
| Innovation | $\zeta^b_t$ / `inno_ebt` | Preference/risk-premium innovation | (F23) |
| Innovation | $\zeta^z_t$ / `inno_zt` | Technology innovation | (F24) |
| Innovation | $\zeta^g_t$ / `g_` | Government spending innovation | (F25) |
| Innovation | $\zeta^{money}_t$ / `interest_` | Monetary policy innovation | (F26) |
| Parameter | $\beta,\sigma,\varrho,\varphi,\kappa^L$ | Preference parameters | (F1), (F2), (F9), steady state |
| Parameter | $\varepsilon,\omega$ | Price markup and Calvo price stickiness | (F3), steady state |
| Parameter | $\xi,\sigma_m,\vartheta,\kappa$ | Matching, separation, vacancy cost | (F12)-(F17), steady state |
| Parameter | $\eta,\gamma,\alpha,\Phi,b$ | Bargaining, wage rigidity, labor production, fixed cost, benefits | (F5)-(F12), (F18)-(F20) |
| Parameter | $\gamma_R,\gamma_\pi,\gamma_y$ | Taylor-rule coefficients | (F22) |
| Parameter | $\rho_b,\rho_z,\rho_g,\sigma_b,\sigma_z,\sigma_g,\sigma_{money}$ | Shock persistence and innovation scales | (F23)-(F26) |
