# US_YR13 Derivation

> Source-backed first-pass archive entry for Yuliya Rychalovska (2016), "The implications of financial frictions and imperfect knowledge in the estimated DSGE model of the U.S. economy." Status: `needs_review`.
> Runtime validation: not performed. Dynare was not run.

## 1. Model Overview

- **Model ID**: `US_YR13`.
- **Paper**: Yuliya Rychalovska (2016), "The implications of financial frictions and imperfect knowledge in the estimated DSGE model of the U.S. economy," *Journal of Economic Dynamics and Control* 73, 259-282. DOI: `10.1016/j.jedc.2016.09.014`.
- **Source used**: `raw/mmb_mineru/runs/us_yr13_us_yr13al__the_implications_of_financial_frictions_and_imperfect_knowledge_in_the_e__235aee23/full.md`.
- **Economy and variant**: estimated U.S. medium-scale Smets-Wouters-style DSGE model augmented with a Bernanke-Gertler-Gilchrist financial accelerator and adaptive learning. The MMB implementation file identifies `US_YR13` as the adaptive-learning version.
- **Core agents**: households, monopolistically competitive intermediate/final goods producers with Calvo prices, Calvo wage setters, competitive capital-goods producers, entrepreneurs, banks, fiscal authority, and monetary authority.
- **Form**: log-linearized around the stationary steady state of detrended variables. Lower-case implementation variables are log deviations or growth-normalized real variables. The `.mod` cross-check uses `model(linear)`.
- **Source scope**: the paper gives detailed equations for capital producers, entrepreneurs/banks, monetary policy, resource constraint, measurement equations, and the adaptive-learning mechanism. It refers the remaining Smets-Wouters household, wage, price, and production microfoundations to Smets and Wouters (2007); those inherited blocks are included as `needs_review` when not fully printed in this paper.

## 2. Optimization Problems

### Capital-Goods Producers

Competitive capital-goods producers choose investment to maximize discounted real profits, using household marginal utility as the stochastic discount factor:

$$
\max_{\{I_{t+s}\}} E_t\sum_{s=0}^{\infty}\beta^s
\frac{\lambda_{t+s}}{\lambda_t}
\left[
Q_{t+s} I_{t+s}\varepsilon^i_{t+s}
- I_{t+s}
- Q_{t+s} I_{t+s}\varepsilon^i_{t+s}
S\left(\frac{I_{t+s}}{I_{t+s-1}}\right)
\right].
$$

### Entrepreneurs and Banks

Entrepreneurs are risk neutral, survive with probability $\varkappa$, and buy capital at the end of period $t$ with net worth and bank loans:

$$
B_{t+1}=Q_tK_{t+1}-N_{t+1}.
$$

After observing idiosyncratic productivity $\omega$, the entrepreneur chooses utilization for next period:

$$
\max_{U_{t+1}} \left[r^k_{t+1}U_{t+1}-a(U_{t+1})\right]\omega K_{t+1}.
$$

Banks finance loans with household deposits at the risk-free rate. The optimal debt contract embeds monitoring costs and generates an external finance premium that depends on entrepreneurial financial health.

### Households, Price Setters, and Wage Setters

The paper states that the nonfinancial private sector follows Smets and Wouters (2007): households choose consumption, labor, and bond positions with external habit; intermediate goods firms face Calvo price frictions with indexation; and households or labor unions set differentiated wages under Calvo wage frictions. The specific Euler, price Phillips curve, and wage Phillips curve used in the implementation are marked as inherited-SW07 `needs_review` because this paper does not reprint the complete microfoundation.

### Adaptive-Learning Forecasting Problem

Agents do not know the rational-expectations reduced form. For each forward-looking variable $y^f_{j,t}$, they use a perceived law of motion:

$$
y^f_{j,t}=\beta_{j,t-1}X_{j,t-1}+u_{j,t}.
$$

The baseline learning specification is an AR(2) model with a constant for each forecast variable. The paper identifies seven forecast variables: consumption, investment, hours worked, price inflation, wage inflation, return on capital, and asset prices.

## 3. First-Order Conditions

- **(F1) Capital-goods producer FOC for investment adjustment**:

$$
\varepsilon^i_t Q_t\left(1-S\left(\frac{I_t}{I_{t-1}}\right)\right)
=1+\varepsilon^i_t Q_tS'\left(\frac{I_t}{I_{t-1}}\right)\frac{I_t}{I_{t-1}}
-E_t\left[
\beta\frac{\lambda_{t+1}}{\lambda_t}\varepsilon^i_{t+1}Q_{t+1}
S'\left(\frac{I_{t+1}}{I_t}\right)
\left(\frac{I_{t+1}}{I_t}\right)^2
\right].
$$

- **(F2) Linearized investment equation**:

$$
\hat i_t=\frac{1}{1+\bar\beta\gamma}
\left(\hat i_{t-1}+\bar\beta\gamma E_t\hat i_{t+1}
+\frac{1}{\gamma^2S''}\hat Q_t\right)+\hat q_t.
$$

- **(F3) Capital accumulation**:

$$
\hat k_t=\left(1-\frac{i_\ast}{k_\ast}\right)\hat k_{t-1}
+\frac{i_\ast}{k_\ast}\hat i_t
+\frac{i_\ast}{k_\ast}(1+\bar\beta\gamma)\gamma^2S''\hat q_t.
$$

- **(F4) Utilization FOC**:

$$
r^k_{t+1}=a'(U_{t+1}).
$$

- **(F5) Linearized capital utilization**:

$$
\hat u_t=\frac{1-\psi}{\psi}\hat r^k_t.
$$

- **(F6) Capital services**:

$$
\hat k^S_{t+1}=\hat u_{t+1}+\hat k_{t+1}.
$$

- **(F7) Expected return on capital**:

$$
E_tR^k_{t+1}
=E_t\left[
\frac{r^k_{t+1}U_{t+1}-a(U_{t+1})+Q_{t+1}(1-\tau)}
{Q_t}
\right].
$$

- **(F8) Linearized expected return on capital**:

$$
E_t\hat R^K_{t+1}
=\frac{1-\tau}{\bar R^K}E_t\hat Q_{t+1}
+\frac{\bar r^k}{\bar R^K}E_t\hat r^k_{t+1}
-\hat Q_t.
$$

- **(F9) External finance premium condition**:

$$
E_tR^k_{t+1}
=E_t\left[
s\left(\frac{N_{t+1}}{Q_tK_{t+1}}\right)\varepsilon^b_tR_t
\right].
$$

- **(F10) Linearized external finance premium**:

$$
E_t\hat R^K_{t+1}
=-el\left\{E_t\left[\hat N_{t+1}-\hat Q_t-\hat k_{t+1}\right]\right\}
+\hat R_t+\hat b_t.
$$

- **(F11) Entrepreneurial net worth law**:

$$
N_{t+1}
=\varkappa\left[
R^K_tQ_{t-1}K_t
-E_{t-1}R^K_t(Q_{t-1}K_t-N_t)
\right]+W^e_t.
$$

- **(F12) Linearized net worth law**:

$$
\hat N_{t+1}
=\varkappa\bar R^K\left[
\frac{\bar K}{\bar N}(\hat R^K_t-E_{t-1}\hat R^K_t)
+E_{t-1}\hat R^K_t+\hat N_t
\right].
$$

- **(F13) Net worth with premium components**:

$$
\hat N_{t+1}
=\varkappa\bar R^K\left[
\frac{\bar K}{\bar N}\hat R^K_t
-\left(\frac{\bar K}{\bar N}-1\right)(\hat R_{t-1}+\hat b_{t-1})
-el\left(\frac{\bar K}{\bar N}-1\right)(\hat k_t+\hat Q_{t-1}-\hat N_t)
+\hat N_t
\right].
$$

- **(F14) Linearized consumption Euler equation, inherited SW07 block, needs_review**:

$$
\hat c_t=a_c\hat c_{t-1}+(1-a_c)\,E_t\hat c_{t+1}
+a_l(\hat l_t-E_t\hat l_{t+1})
-a_r(\hat r_t-E_t\hat\pi_{t+1}+\hat b_t).
$$

- **(F15) Production and marginal-cost relation, inherited SW07 block, needs_review**:

$$
\hat y_t=\Phi\left[\alpha\hat k^S_t+(1-\alpha)\hat l_t+\hat a_t\right],
\qquad
\hat{mc}_t=\alpha\hat r^k_t+(1-\alpha)\hat w_t-\hat a_t.
$$

- **(F16) Price Phillips curve, inherited SW07 block, needs_review**:

$$
\hat\pi_t=b_pE_t\hat\pi_{t+1}+i_p\hat\pi_{t-1}+k_p\hat{mc}_t+\hat\varepsilon^p_t.
$$

- **(F17) Wage Phillips curve, inherited SW07 block, needs_review**:

$$
\hat w_t=b_wE_t\hat w_{t+1}+i_w\hat w_{t-1}
+\chi_w\left(\sigma_l\hat l_t+\hat\lambda_t-\hat w_t\right)
+\text{inflation-indexation terms}+\hat\varepsilon^w_t.
$$

- **(F18) Monetary policy rule**:

$$
\hat R^n_t=\rho_R\hat R^n_{t-1}
+(1-\rho_R)(r_\pi\hat\pi_t+r_y\widehat{ygap}_t)
+r_{\Delta y}(\widehat{ygap}_t-\widehat{ygap}_{t-1})
+\epsilon^r_t.
$$

- **(F19) Output gap approximation**:

$$
\widehat{ygap}_t=\hat y_t-\hat A_t.
$$

- **(F20) Fisher relation for real rate**:

$$
\hat R_t=\hat R^n_t-E_t\hat\pi_{t+1}.
$$

## 4. Market Clearing & Identities

- **(F21) Resource constraint**:

$$
\hat y_t
=\frac{(\bar R^K-1+\tau)k_\ast}{y_\ast}\hat u_t
+\hat\mu^{bank}_t
+\frac{c_\ast}{y_\ast}\hat c_t
+\frac{i_\ast}{y_\ast}\hat i_t
+\hat g_t.
$$

- **(F22) Banking spread contribution in resource constraint, needs_review OCR**:

$$
\hat\mu^{bank}_t
=\frac{k_\ast}{y_\ast}(\bar R^K-\bar R)\left(1-\frac{\bar N}{\bar K}\right)
(\hat R^K_t+\hat Q_{t-1}+\hat k_t).
$$

- **(F23) Loan-financed capital purchase identity**:

$$
B_{t+1}=Q_tK_{t+1}-N_{t+1}.
$$

- **(F24) Annual inflation identity from implementation cross-check**:

$$
\hat\pi^{(4)}_t=\frac{1}{4}\left(4\hat\pi_t+4\hat\pi_{t-1}+4\hat\pi_{t-2}+4\hat\pi_{t-3}\right).
$$

## 5. Exogenous Processes

- **(F25) Exogenous risk-premium shock**:

$$
\hat b_t=\rho_b\hat b_{t-1}+\epsilon^b_t.
$$

- **(F26) Investment-specific technology shock**:

$$
\hat q_t=\rho_q\hat q_{t-1}+\epsilon^i_t.
$$

- **(F27) Government spending shock with productivity spillover**:

$$
\hat g_t=\rho_g\hat g_{t-1}+\rho_{ga}\epsilon^a_t+\epsilon^g_t.
$$

- **(F28) Productivity shock**:

$$
\hat a_t=\rho_a\hat a_{t-1}+\epsilon^a_t.
$$

- **(F29) Price markup shock with moving-average term**:

$$
\hat\varepsilon^p_t=\rho_p\hat\varepsilon^p_{t-1}+\eta^p_t-\mu_p\eta^p_{t-1}.
$$

- **(F30) Wage markup shock with moving-average term**:

$$
\hat\varepsilon^w_t=\rho_w\hat\varepsilon^w_{t-1}+\eta^w_t-\mu_w\eta^w_{t-1}.
$$

- **(F31) Monetary policy shock**:

$$
\epsilon^r_t=\eta^r_t.
$$

- **(F32) Learning perceived law of motion**:

$$
y^f_{j,t}=\beta_{j,t-1}X_{j,t-1}+u_{j,t}.
$$

- **(F33) Kalman belief update**:

$$
\beta_{t/t}=\beta_{t/t-1}+K_t\tilde z_t,
\qquad
P_{t/t}=(I-K_tX_{t-1})P_{t/t-1}.
$$

- **(F34) Belief prediction law**:

$$
(\beta_t-\bar\beta)=F(\beta_{t-1}-\bar\beta)+v_t.
$$

- **(F35) Actual law of motion under learning**:

$$
\begin{bmatrix}y_t\\w_t\end{bmatrix}
=\mu_t+T_t\begin{bmatrix}y_{t-1}\\w_{t-1}\end{bmatrix}+R_t\epsilon_t.
$$

## 6. Steady-State Solution

The paper states that the nonlinear system is detrended by a deterministic labor-augmenting growth rate $\gamma$ and then linearized around the stationary steady state of detrended variables. For the archive, steady-state reconstruction is `needs_review` because the paper does not print a complete self-contained steady-state algorithm.

- Set all hatted variables and innovations to zero in the stationary log-linear system.
- The discounting object used in the investment equation is $\bar\beta=\beta/\gamma^{\sigma_c}$.
- The steady-state capital return and rental rate enter (F8), and the financial friction block depends on $\bar K/\bar N$, $\varkappa$, and $el$.
- The model estimates separate trend growth rates for output, consumption, investment, and wages in the measurement equations rather than imposing a single observed trend on all real series.
- Implementation cross-check: `US_YR13_rep.mod` computes derived steady-state parameters such as `cgamma`, `cbetabar`, `cr`, `crk`, `cw`, `cik`, `cky`, `ciy`, `ccy`, `crkky`, `cwhlc`, and `cwly` before entering the linear model block.

## 7. Timing & Form Conventions

- **Capital timing**: entrepreneurs buy $K_{t+1}$ at the end of period $t$; installed capital services next period use utilization $U_{t+1}$. The implementation writes production capital with lagged physical capital plus utilization.
- **Net worth timing**: $N_{t+1}$ is determined by realized and expected returns from contracts signed earlier; (F12) and (F13) include $E_{t-1}\hat R^K_t$.
- **Expectations**: under rational expectations, forward terms use model-consistent $E_t$. Under adaptive learning, seven forward variables are forecast through the PLM (F32), updated by the Kalman filter (F33), and substituted into the structural system.
- **Form**: `model(linear)` in the MMB implementation; all hatted variables are deviations from the stationary detrended steady state.
- **Runtime validation**: not performed.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII cross-check | Meaning | Main equation |
|---|---|---|---|
| Endogenous | $\hat c_t$ / `c` | consumption | (F14) |
| Endogenous | $\hat i_t$ / `inve` | investment | (F2) |
| Endogenous | $\hat y_t$ / `y` | output | (F21) |
| Endogenous | $\hat l_t$ / `lab` | hours/labor | (F15), (F17) |
| Endogenous | $\hat\pi_t$ / `pinf` | inflation | (F16) |
| Endogenous | $\hat w_t$ / `w` | real wage | (F17) |
| Endogenous | $\hat R^n_t$ / `r` in implementation | policy rate | (F18) |
| Endogenous | $\hat R_t$ / `rr` or real-rate object | risk-free real rate | (F20) |
| Endogenous | $\hat Q_t$ / `pk` | asset price / Tobin's Q | (F1), (F8) |
| Endogenous | $\hat k_t$ / `k`, `kp` | physical capital | (F3) |
| Endogenous | $\hat u_t$ / `zcap` | utilization | (F5) |
| Endogenous | $\hat k^S_t$ | capital services | (F6) |
| Endogenous | $\hat r^k_t$ / `rk` | rental/return on capital | (F4), (F8) |
| Endogenous | $\hat N_t$ / `nw` | entrepreneurial net worth | (F12), (F13) |
| Endogenous | `prem` | external finance premium | (F10) |
| Endogenous | `pinf4` | annual inflation identity | (F24) |
| Endogenous | `ewma`, `epinfma`, `spinf`, `sw` | markup shock auxiliaries | (F29), (F30) |
| Exogenous | $\epsilon^a_t$ / `ea` | productivity innovation | (F28) |
| Exogenous | $\epsilon^b_t$ / `eb` | exogenous risk-premium innovation | (F25) |
| Exogenous | $\epsilon^i_t$ / `eqs` | investment-specific innovation | (F26) |
| Exogenous | $\epsilon^g_t$ / `eg` | government-spending innovation | (F27) |
| Exogenous | $\eta^p_t$ / `epinf` | price markup innovation | (F29) |
| Exogenous | $\eta^w_t$ / `ew` | wage markup innovation | (F30) |
| Exogenous | $\eta^r_t$ / `em` | monetary policy innovation | (F31) |
| Parameter | $\beta$, `cbeta`, `cbetabar` | household discounting and trend-adjusted discounting | (F1), (F2) |
| Parameter | $\gamma$, `cgamma` | deterministic trend growth | (F2), section 6 |
| Parameter | $S''$, `csadjcost` | investment adjustment-cost curvature | (F2), (F3) |
| Parameter | $\tau$, `ctou` | depreciation | (F7), (F8) |
| Parameter | $\psi$, `czcap` | utilization cost elasticity object | (F5) |
| Parameter | $\varkappa$, `cv` | entrepreneurial survival rate | (F11), (F12) |
| Parameter | $\bar K/\bar N$, `clev` | capital-to-net-worth ratio | (F12), (F13) |
| Parameter | $el$, `elast` | premium elasticity | (F10), (F13) |
| Parameter | $\rho_R,r_\pi,r_y,r_{\Delta y}$ | monetary policy rule | (F18) |
| Parameter | shock persistence and MA parameters | AR and MA shock coefficients | (F25)-(F31) |
| Parameter | learning gain $\rho$ / `ro` | belief-persistence parameter | (F34) |
