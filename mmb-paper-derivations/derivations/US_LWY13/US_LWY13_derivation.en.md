# US_LWY13 - Derivation (Optimization Problems + First-Order Conditions)

> Source-backed first-pass derivation for the MMB model archive. Status: `needs_review`.

## 1. Model Overview

- **Model**: `US_LWY13`, based on Leeper, Walker, and Yang (2013), "Fiscal foresight and information flows," *Econometrica* 81(3), 1115-1145, DOI `10.3982/ecta8337`.
- **Archive scope**: the paper studies fiscal foresight and information-flow assumptions. It first gives a transparent analytical growth model, then embeds tax news in RBC and New Keynesian data-generating models. This entry records the model structure relevant to the MMB `US_LWY13` implementation.
- **Agents and blocks**: households, firms, government/fiscal authority, monetary authority in the NK application, and exogenous news/shock processes.
- **Form**: `model(linear)` in the MMB implementation cross-check. Paper-side equations mix nonlinear primitives with log-linearized equilibrium conditions. Formula-level status is `needs_review` because the paper text gives only summary descriptions for the full NK model and points full details to supplemental material not normalized here.
- **Runtime validation**: not performed. Dynare was not run.

## 2. Optimization Problems

### 2.1 Analytical Growth Model Household

The representative household in the analytical example chooses consumption and next-period capital under log utility, complete depreciation, inelastic labor, and a tax-distorted production return:

$$
\max_{\{C_t,K_t\}} E_0\sum_{t=0}^{\infty}\beta^t\log C_t
\quad\text{s.t.}\quad
C_t+K_t+T_t \le (1-\tau_t)A_tK_{t-1}^{\alpha}.
$$

The government balances the budget with lump-sum transfers:

$$
T_t=\tau_tY_t,\qquad G_t=0.
$$

### 2.2 Quantitative RBC Household and Firm

The RBC model is described as a Chari-Kehoe-McGrattan-style representative-agent economy. The household maximizes time-separable utility over consumption and leisure, supplies labor and capital, and faces distorting labor and capital taxes. The representative firm rents labor and capital and produces with Cobb-Douglas technology.

The full FOCs are not printed in the paper-side Markdown; this block is therefore summarized as `needs_review` pending supplemental-formula review.

### 2.3 Quantitative New Keynesian Model

The NK model extends the RBC model with external habit formation, differentiated labor, monopolistically competitive intermediate producers, variable capital utilization, sticky wages, sticky prices, and a Taylor-type monetary policy rule. Fiscal financing allows government spending and transfers to react to debt. The paper describes this model at block level and refers full details to supplemental material.

The Rep-MMB `.mod` file was used only as `implementation_cross_check` and indicates that `US_LWY13` is a linearized NK implementation with Ricardian/non-Ricardian consumption blocks, investment adjustment, capital utilization, wage and price markup shocks, tax rules, spending and transfer rules, and flexible-price counterparts used for the output gap.

## 3. First-Order Conditions

- **(F1) Analytical household Euler equation**:

$$
\frac{1}{C_t}
=
\alpha\beta E_t\left[
(1-\tau_{t+1})\frac{1}{C_{t+1}}\frac{Y_{t+1}}{K_t}
\right].
$$

- **(F2) Analytical resource and production condition**:

$$
C_t+K_t=Y_t=A_tK_{t-1}^{\alpha}.
$$

- **(F3) Log-linearized capital difference equation**:

$$
E_tk_{t+1}-(\theta^{-1}+\alpha)k_t+\alpha\theta^{-1}k_{t-1}
=
E_t\left[a_{t+1}-\theta^{-1}a_t\right]
+\left\{\theta^{-1}(1-\theta)\frac{\tau}{1-\tau}\right\}E_t\hat{\tau}_{t+1},
$$

where

$$
\theta=\alpha\beta(1-\tau).
$$

- **(F4) Analytical capital solution under fiscal foresight**:

$$
k_t=\alpha k_{t-1}+a_t
-(1-\theta)\frac{\tau}{1-\tau}
\sum_{i=0}^{\infty}\theta^i E_t\hat{\tau}_{t+i+1}.
$$

- **(F5) Real interest / Ricardian consumption Euler block (`implementation_cross_check`)**:

$$
c^r_t-\frac{1}{1+\theta_h}c^r_{t+1}
+\frac{1-\theta_h}{\gamma(1+\theta_h)}(R_t-\pi_{t+1}-u^b_t+u^b_{t+1})
=\frac{\theta_h}{1+\theta_h}c^r_{t-1}.
$$

This equation is adapted from the MMB linear implementation; notation is marked `implementation_cross_check`.

- **(F6) Investment adjustment equation (`implementation_cross_check`)**:

$$
i_t-\frac{\beta}{1+\beta}i_{t+1}
-\frac{1}{(1+\beta)s}q_t-\beta u^i_{t+1}+u^i_t
=\frac{1}{1+\beta}i_{t-1}.
$$

- **(F7) Q equation with capital-tax wedge (`implementation_cross_check`)**:

$$
q_t+R_t-\pi_{t+1}-\beta(1-\delta)q_{t+1}
-\beta r^k(1-\tau^K)(1+\tau^C)r^k_{t+1}
+\tau^K\beta r^k(1+\tau^C)\tau^K_{t+1}=0.
$$

- **(F8) Capital accumulation (`implementation_cross_check`)**:

$$
k_t-\delta i_t=(1-\delta)k_{t-1}.
$$

- **(F9) Wage-setting / labor-supply block (`implementation_cross_check`, compressed)**:

$$
\mathcal{W}(w_t,w_{t+1},w_{t-1},\pi_t,\pi_{t+1},\pi_{t-1},l_t,c^r_t,c^r_{t-1},c^{nr}_t,\tau^L_t,u^w_t)=0.
$$

The exact coefficient-heavy linear wage equation comes from the `.mod` file and needs paper-side supplemental review.

- **(F10) Capital demand (`implementation_cross_check`)**:

$$
\bar{k}_t-y_t-(1-\alpha)w_t+(1-\alpha)r^k_t+u^a_t=0.
$$

- **(F11) Production function (`implementation_cross_check`)**:

$$
y_t-u^a_t-\alpha\bar{k}_t-(1-\alpha)l_t=0.
$$

- **(F12) Taylor-type monetary policy rule (`implementation_cross_check`)**:

$$
R_t-\left[(1-\rho_R)\phi_{\pi}+\phi_{\pi d}\right]\pi_t
-\left[(1-\rho_R)\phi_y+\phi_{yd}\right]y_t
+\phi_a u^a_t-u^m_t
=-\phi_{\pi d}\pi_{t-1}-\phi_{yd}y_{t-1}+\rho_RR_{t-1}.
$$

## 4. Market Clearing & Identities

- **(F13) Aggregate consumption identity (`implementation_cross_check`)**:

$$
c\,c_t-(1-\mu)c^r c^r_t-\mu c^{nr}c^{nr}_t=0.
$$

- **(F14) Non-Ricardian household budget (`implementation_cross_check`)**:

$$
c^{nr}c^{nr}_t
-w l(1-\tau^L)w_t-w l(1-\tau^L)l_t
+w l\tau^L\tau^L_t-z z_t=0.
$$

- **(F15) Debt-output share definition (`implementation_cross_check`)**:

$$
s^B_t+y_t-b_t=0.
$$

- **(F16) Aggregate resource constraint (`implementation_cross_check`)**:

$$
y_t-c_yc_t-\delta k_y i_t-s_g g_t-\psi_1 k_y v_t=0.
$$

- **(F17) Government budget constraint (`implementation_cross_check`, compressed)**:

$$
\mathcal{B}(b_t,g_t,\tau^K_t,r^k_t,v_t,\tau^L_t,w_t,l_t,z_t,\pi_t,R_{t-1},b_{t-1},k_{t-1})=0.
$$

The full linearized government budget identity is visible in the `.mod` file; this first pass preserves it as a compressed `needs_review` equation rather than copying a coefficient-heavy implementation equation as paper evidence.

- **(F18) Capital utilization relation (`implementation_cross_check`)**:

$$
\frac{\psi}{1-\psi}v_t-r^k_t+\frac{\tau^K}{1-\tau^K}\tau^K_t=0.
$$

- **(F19) Effective capital definition (`implementation_cross_check`)**:

$$
\bar{k}_t-v_t=k_{t-1}.
$$

- **(F20) Fisher equation (`implementation_cross_check`)**:

$$
r_t-R_t+\pi_{t+1}=0.
$$

- **(F21) Real marginal cost (`implementation_cross_check`)**:

$$
mc_t-(1-\alpha)w_t-\alpha r^k_t+u^a_t=0.
$$

- **(F22) Capital tax revenue (`implementation_cross_check`)**:

$$
T^K_t-\tau^K_t-r^k_t-\bar{k}_t=0.
$$

- **(F23) Labor tax revenue (`implementation_cross_check`)**:

$$
T^L_t-\tau^L_t-w_t-l_t=0.
$$

## 5. Exogenous Processes

- **(F24) Simple analytical tax-news process**:

$$
\hat{\tau}_t=\varepsilon_{\tau,t-q}.
$$

- **(F25) Simple analytical technology process**:

$$
a_t=\varepsilon_{A,t}.
$$

- **(F26) General labor-tax information-flow process**:

$$
\hat{\tau}^L_t
=\rho\hat{\tau}^L_{t-1}
+\sum_{j=0}^{J}\phi_j\left[
\sigma^L\varepsilon^L_{\tau,t-j}
+\xi\sigma^K\varepsilon^K_{\tau,t-j}
\right].
$$

- **(F27) Government spending and transfer feedback process in the NK model**:

$$
\hat{X}_t=\rho_X\hat{X}_{t-1}+\gamma_X\hat{s}^B_{t-1}+\sigma_X\varepsilon^X_t,
\qquad
\hat{X}\in\{\hat{G},\hat{Z}\},\quad \gamma_X<0.
$$

- **(F28) Technology shock (`implementation_cross_check`)**:

$$
u^a_t=\rho_a u^a_{t-1}+\sigma_a\varepsilon^a_t.
$$

- **(F29) Preference shock (`implementation_cross_check`)**:

$$
u^b_t=\rho_b u^b_{t-1}+\sigma_b\varepsilon^b_t.
$$

- **(F30) Investment shock (`implementation_cross_check`)**:

$$
u^i_t=\rho_i u^i_{t-1}+\sigma_i\varepsilon^i_t.
$$

- **(F31) Wage markup shock (`implementation_cross_check`)**:

$$
u^w_t=\rho_w u^w_{t-1}+\sigma_w\varepsilon^w_t.
$$

- **(F32) Price markup shock (`implementation_cross_check`)**:

$$
u^p_t=\rho_p u^p_{t-1}+\sigma_p\varepsilon^p_t.
$$

- **(F33) Capital tax shock (`implementation_cross_check`)**:

$$
u^{\tau K}_t=\sigma_{\tau K}\varepsilon^{\tau K}_t.
$$

- **(F34) Labor tax shock (`implementation_cross_check`)**:

$$
u^{\tau L}_t=\sigma_{\tau L}\varepsilon^{\tau L}_t.
$$

- **(F35) Transfer shock (`implementation_cross_check`)**:

$$
u^z_t=\sigma_z\varepsilon^z_t.
$$

## 6. Steady-State Solution

- Analytical example: the steady-state capital stock is

$$
K=\left[\alpha\beta(1-\tau)A\right]^{1/(1-\alpha)}.
$$

- The analytical example uses log deviations from steady state:

$$
k_t=\log K_t-\log K,\qquad a_t=\log A_t-\log A,\qquad
\hat{\tau}_t=\log\tau_t-\log\tau.
$$

- The NK MMB implementation is linearized around a steady state computed in the `.mod` file from parameters loaded from `paramfile_leeper`. The implementation defines ratios and levels such as `Rss`, `rkss`, `wss`, `kyss`, `lyss`, `cyss`, `yss`, `crss`, `cnrss`, `kss`, `ivss`, `lss`, `css`, `zss`, `bss`, `gss`, `lambrss`, and `lambnrss`.
- The paper-side Markdown does not provide a full steady-state derivation for the NK model. Steady-state quality is therefore `implementation_cross_check_only` and `needs_review`.

## 7. Timing & Form Conventions

- The analytical example has complete depreciation and uses $K_t$ as the post-decision stock that appears in next period production as $K_{t}$ in $Y_{t+1}$.
- The simple news process $\hat{\tau}_t=\varepsilon_{\tau,t-q}$ means agents at date $t$ observe news that maps into taxes $q$ periods ahead.
- In the generalized information-flow process, coefficients $\phi_j$ describe how news about tax rates is distributed across inside and outside lags. Table I in the paper gives four specifications, including smooth six-quarter inside-lag news and two- or eight-quarter outside-lag perfect foresight.
- The MMB implementation uses `model(linear)`, lagged capital in production, and flexible-price counterparts to define the output gap.
- Dynare runtime validation was not performed.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Equation coverage |
|---|---|---|---|
| Endogenous | $C_t$, `cr`, `cnr`, `c` | consumption; Ricardian/non-Ricardian components in implementation | (F1), (F5), (F13), (F14) |
| Endogenous | $K_t$, `k`, `kbar` | capital stock and effective capital | (F2), (F4), (F8), (F19) |
| Endogenous | $Y_t$, `y` | output | (F2), (F11), (F16) |
| Endogenous | $l_t$ | labor | (F9), (F11), (F14), (F23) |
| Endogenous | $q_t$ | Tobin's Q | (F6), (F7) |
| Endogenous | $R_t$, $r_t$ | nominal and real interest rates | (F5), (F12), (F20) |
| Endogenous | $\pi_t$ | inflation | (F5), (F12), (F20) |
| Endogenous | $w_t$, $r^k_t$, $mc_t$ | wage, capital return, real marginal cost | (F9), (F10), (F18), (F21) |
| Endogenous | $b_t$, $s^B_t$ | government debt and debt-output ratio | (F15), (F17), (F27) |
| Endogenous | $g_t$, $z_t$ | government spending and transfers | (F14), (F16), (F17), (F27) |
| Endogenous | $\tau^K_t$, $\tau^L_t$, $T^K_t$, $T^L_t$ | capital/labor tax rates and revenues | (F22), (F23), (F26), (F33), (F34) |
| Endogenous | $v_t$ | capital utilization | (F16), (F18), (F19) |
| Exogenous | $\varepsilon_A$, `epsilona` | technology innovation | (F25), (F28) |
| Exogenous | $\varepsilon_{\tau}$, `epsilontk`, `epsilontl` | tax news/innovations | (F24), (F26), (F33), (F34) |
| Exogenous | `epsilonb`, `epsiloni`, `epsilonw`, `epsilonp`, `epsilonz` | preference, investment, wage markup, price markup, transfer shocks | (F29)-(F32), (F35) |
| Exogenous | `interest_`, `fiscal_` | MMB policy shocks | (F12), (F27) |
| Parameters | $\alpha$, $\beta$, $\tau$, $\theta$ | production share, discount factor, tax rate, analytical discounting coefficient | (F1)-(F4) |
| Parameters | $\rho$, $\phi_j$, $\sigma^L$, $\sigma^K$, $\xi$ | information-flow parameters for fiscal foresight | (F26) |
| Parameters | $\rho_X$, $\gamma_X$, $\sigma_X$ | fiscal feedback parameters | (F27) |
| Parameters | `gamm`, `kappa`, `omegaw`, `omegap`, `etaw`, `etap`, `mu`, `phipi`, `phiy`, `delt` | NK implementation preference, rigidity, policy, and depreciation parameters | `implementation_cross_check` |
