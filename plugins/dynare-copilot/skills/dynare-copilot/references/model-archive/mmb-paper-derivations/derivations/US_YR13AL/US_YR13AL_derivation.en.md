# US_YR13AL - Derivation (optimization problems and equilibrium conditions)

> Model archive draft for later Dynare implementation. Status: `needs_review`; runtime validation was not performed.

Provenance: `US_YR13AL`, Yuliya Rychalovska (2016), "The implications of financial frictions and imperfect knowledge in the estimated DSGE model of the U.S. economy", *Journal of Economic Dynamics and Control* 73, 259-282, DOI `10.1016/j.jedc.2016.09.014`. Source Markdown: `raw/mmb_mineru/runs/us_yr13_us_yr13al__the_implications_of_financial_frictions_and_imperfect_knowledge_in_the_e__235aee23/full.md`. Raw PDF: `raw/mmb_papers/The implications of financial frictions and imperfect knowledge in the estimated dsge model of the U.S. economy.pdf`. MinerU run id: `235aee23-e4aa-4a58-8e02-dbb3676a7975`.

## 1. Model Overview

- **Model**: U.S. medium-scale DSGE model based on Smets and Wouters (2007), augmented with a Bernanke-Gertler-Gilchrist financial accelerator and adaptive learning.
- **Experiment**: Bayesian estimation and shock-transmission comparison under rational expectations and Kalman-filter adaptive learning. `US_YR13AL` corresponds to the adaptive-learning financial-accelerator specification.
- **Agents**: households; final-good, intermediate-good, labor-packaging, and capital-goods firms; entrepreneurs; banks; monetary authority; exogenous fiscal/spending sector.
- **Financial accelerator**: entrepreneurs finance capital with net worth and bank loans. Agency frictions produce an external finance premium that depends on financial conditions and an exogenous risk-premium shock.
- **Learning block**: agents forecast seven forward-looking variables: consumption, investment, hours, price inflation, wage inflation, return on capital, and asset prices. The baseline learning specification uses AR(2) forecasting functions with a constant.
- **Form**: detrended nonlinear model, then log-linearized around the stationary steady state. Lower-case hatted variables are log deviations or stationary deviations. The archive equations below are therefore a `model(linear)`-style first-pass representation.
- **Source limitation**: the paper prints the financial accelerator, learning, policy, resource, and measurement equations. It refers readers to Smets and Wouters (2007) for the rest of the micro-foundations; those inherited household, price, wage, production, and shock equations are marked `needs_review` where the source does not print them.

## 2. Optimization Problems

### 2.1 Capital-Goods Producers

Competitive capital-goods producers choose investment and sell new capital to entrepreneurs at price $Q_t$. They face investment adjustment costs $S(I_t/I_{t-1})$ and an investment-specific shock $\varepsilon_t^i$:

$$
\max_{\{I_t\}} E_t\sum_{s=0}^{\infty}\beta^s\frac{\lambda_{t+s}}{\lambda_t}
\left[
Q_{t+s} I_{t+s}\varepsilon_{t+s}^i
- I_{t+s}
- Q_{t+s} I_{t+s}\varepsilon_{t+s}^i
S\left(\frac{I_{t+s}}{I_{t+s-1}}\right)
\right].
$$

### 2.2 Entrepreneurs and Banks

Entrepreneurs are risk neutral and survive with probability $\varkappa$. At the end of period $t$, they buy capital $K_{t+1}$ at price $Q_t$ using net worth $N_{t+1}$ and bank borrowing:

$$
B_{t+1}=Q_tK_{t+1}-N_{t+1}.
$$

After observing the next-period shock, entrepreneurs choose utilization $U_{t+1}$:

$$
\max_{U_{t+1}}\left[r^k_{t+1}U_{t+1}-a(U_{t+1})\right]\omega K_{t+1}.
$$

Banks obtain deposits from households at the risk-free rate and lend to entrepreneurs. Costly state verification generates an external finance premium.

### 2.3 Adaptive Learning

The structural system has the form:

$$
A_0
\begin{bmatrix} y_{t-1}\\ w_{t-1}\end{bmatrix}
+ A_1
\begin{bmatrix} y_t\\ w_t\end{bmatrix}
+ A_2 E_t y_{t+1}
+ B_0\epsilon_t
= \text{const.}
$$

Agents do not know the RE law of motion. They use perceived laws of motion for each forward-looking variable $j$:

$$
y^f_{j,t}=\beta_{j,t-1}X_{j,t-1}+u_{j,t}.
$$

The belief vector is updated with a Kalman filter and then used to compute expectations in the structural equations.

## 3. First-Order Conditions

- **(F1) Capital-goods producer Tobin's Q condition**:

$$
\varepsilon_t^i Q_t\left(1-S\left(\frac{I_t}{I_{t-1}}\right)\right)
= 1
+ \varepsilon_t^i Q_t S'\left(\frac{I_t}{I_{t-1}}\right)\frac{I_t}{I_{t-1}}
- E_t\left[
\beta\frac{\lambda_{t+1}}{\lambda_t}
\varepsilon_{t+1}^i Q_{t+1}
S'\left(\frac{I_{t+1}}{I_t}\right)
\left(\frac{I_{t+1}}{I_t}\right)^2
\right].
$$

- **(F2) Log-linear investment dynamics implied by (F1)**:

$$
\widehat{i}_t =
\frac{1}{1+\bar{\beta}\gamma}
\left(
\widehat{i}_{t-1}
+\bar{\beta}\gamma E_t\widehat{i}_{t+1}
+\frac{1}{\gamma^2 S''}\widehat{Q}_t
\right)
+\widehat{q}_t.
$$

- **(F3) Capital accumulation, log-linearized**:

$$
\widehat{k}_t
=
\left(1-\frac{i_*}{\bar{k}_*}\right)\widehat{k}_{t-1}
+\frac{i_*}{\bar{k}_*}\widehat{i}_t
+\frac{i_*}{\bar{k}_*}(1+\bar{\beta}\gamma)\gamma^2 S''\widehat{q}_t.
$$

- **(F4) Utilization choice**:

$$
r^k_{t+1}=a'(U_{t+1}).
$$

- **(F5) Utilization condition, log-linearized**:

$$
\widehat{u}_t=\frac{1-\psi}{\psi}\widehat{r}^k_t.
$$

- **(F6) Capital services**:

$$
\widehat{k}^S_{t+1}=\widehat{u}_{t+1}+\widehat{k}_{t+1}.
$$

- **(F7) Expected return on capital**:

$$
E_t R^k_{t+1}
=E_t\left[
\frac{
r^k_{t+1}U_{t+1}-a(U_{t+1})+Q_{t+1}(1-\tau)
}{Q_t}
\right].
$$

- **(F8) Expected return on capital, log-linearized**:

$$
E_t\widehat{R}^K_{t+1}
=
\frac{1-\tau}{\bar{R}^K}E_t\widehat{Q}_{t+1}
+\frac{\bar{r}^k}{\bar{R}^K}E_t\widehat{r}^k_{t+1}
-\widehat{Q}_t.
$$

- **(F9) Financial contract / external finance premium**:

$$
E_t R^k_{t+1}
=
E_t\left[
s\left(\frac{N_{t+1}}{Q_tK_{t+1}}\right)
\varepsilon_t^b R_t
\right].
$$

- **(F10) External finance premium, log-linearized**:

$$
E_t\widehat{R}^K_{t+1}
=
-el\,E_t\left[\widehat{N}_{t+1}-\widehat{Q}_t-\widehat{k}_{t+1}\right]
+\widehat{R}_t+\widehat{b}_t.
$$

- **(F11) Entrepreneurial net worth accumulation**:

$$
N_{t+1}
=
\varkappa\left[
R_t^KQ_{t-1}K_t
-E_{t-1}R_t^K(Q_{t-1}K_t-N_t)
\right]
+W_t^e.
$$

- **(F12) Net worth, log-linearized**:

$$
\widehat{N}_{t+1}
=
\varkappa\bar{R}^K
\left[
\frac{\bar{K}}{\bar{N}}
\left(\widehat{R}_t^K-E_{t-1}\widehat{R}_t^K\right)
+E_{t-1}\widehat{R}_t^K
+\widehat{N}_t
\right].
$$

- **(F13) Net worth with finance-premium substitution**:

$$
\widehat{N}_{t+1}
=
\varkappa\bar{R}^K
\left[
\frac{\bar{K}}{\bar{N}}\widehat{R}_t^K
-\left(\frac{\bar{K}}{\bar{N}}-1\right)(\widehat{R}_{t-1}+\widehat{b}_{t-1})
-el\left(\frac{\bar{K}}{\bar{N}}-1\right)
(\widehat{k}_t+\widehat{Q}_{t-1}-\widehat{N}_t)
+\widehat{N}_t
\right].
$$

- **(F14) Monetary policy rule**:

$$
\widehat{R}^n_t
=
\rho_R\widehat{R}^n_{t-1}
+(1-\rho_R)(r_\pi\widehat{\pi}_t+r_y\widehat{ygap}_t)
+r_{\Delta y}(\widehat{ygap}_t-\widehat{ygap}_{t-1})
+\epsilon_{r,t}.
$$

- **(F15) Output gap definition**:

$$
\widehat{ygap}_t=\widehat{y}_t-\widehat{A}_t.
$$

- **(F16) Risk-free real interest rate definition**:

$$
\widehat{R}_t=\widehat{R}^n_t-E_t\widehat{\pi}_{t+1}.
$$

- **(F17) Household Euler equation inherited from Smets-Wouters (`needs_review`)**:

$$
E_t\widehat{c}_{t+1}=\mathcal{E}_c(\widehat{c}_t,\widehat{c}_{t-1},\widehat{R}_t,\widehat{g}_t,\widehat{\varepsilon}^b_t;\Theta_{SW}).
$$

- **(F18) Price Phillips curve inherited from Smets-Wouters (`needs_review`)**:

$$
\widehat{\pi}_t=\mathcal{P}(\widehat{\pi}_{t-1},E_t\widehat{\pi}_{t+1},\widehat{mc}_t,\widehat{\varepsilon}^p_t;\Theta_{SW}).
$$

- **(F19) Wage Phillips curve inherited from Smets-Wouters (`needs_review`)**:

$$
\widehat{\pi}^w_t=\mathcal{W}(\widehat{\pi}^w_{t-1},E_t\widehat{\pi}^w_{t+1},\widehat{w}_t,\widehat{l}_t,\widehat{\varepsilon}^w_t;\Theta_{SW}).
$$

- **(F20) Labor supply/demand and production block inherited from Smets-Wouters (`needs_review`)**:

$$
(\widehat{y}_t,\widehat{l}_t,\widehat{w}_t,\widehat{mc}_t,\widehat{r}^k_t)
=\mathcal{S}(\widehat{k}^S_t,\widehat{A}_t,\widehat{u}_t;\Theta_{SW}).
$$

## 4. Market Clearing & Identities

- **(F21) Resource constraint, log-linearized**:

$$
\widehat{y}_t
=
\frac{(\bar{R}^K-1+\tau)k_*}{y_*}\widehat{u}_t
+\widehat{\mu}^{bank}_t
+\frac{c_*}{y_*}\widehat{c}_t
+\frac{i_*}{y_*}\widehat{i}_t
+\widehat{g}_t.
$$

- **(F22) Banking resource wedge**:

$$
\widehat{\mu}^{bank}_t
=
\frac{k_*}{y_*}(\bar{R}^K-\bar{R})
\left(1-\frac{\bar{N}}{\bar{K}}\right)
(\widehat{R}^K_t+\widehat{Q}_{t-1}+\widehat{k}_t).
$$

- **(F23) Measurement equations**:

$$
\begin{bmatrix}
dlGdp_t\\ dlCons_t\\ dlInv_t\\ dlWage_t\\ lHours_t\\ dlP_t\\ FedFundsR_t
\end{bmatrix}
=
\begin{bmatrix}
\bar{\gamma}_y\\ \bar{\gamma}_c\\ \bar{\gamma}_i\\ \bar{\gamma}_w\\ \bar{l}\\ \bar{\pi}\\ \bar{r}
\end{bmatrix}
+
\begin{bmatrix}
\widehat{y}_t-\widehat{y}_{t-1}\\
\widehat{c}_t-\widehat{c}_{t-1}\\
\widehat{i}_t-\widehat{i}_{t-1}\\
\widehat{w}_t-\widehat{w}_{t-1}\\
\widehat{l}_t\\
\widehat{\pi}_t\\
\widehat{R}^n_t
\end{bmatrix}.
$$

## 5. Exogenous Processes

- **(F24) General exogenous state vector**:

$$
w_t=\Gamma w_{t-1}+\Pi\epsilon_t.
$$

- **(F25) Investment-specific technology shock**:

$$
\widehat{q}_t=\rho_q\widehat{q}_{t-1}+\epsilon^i_t.
$$

- **(F26) Government spending shock**:

$$
\widehat{g}_t=\rho_g\widehat{g}_{t-1}+\rho_{ga}\epsilon^a_t+\epsilon^g_t.
$$

- **(F27) Remaining Smets-Wouters shocks (`needs_review`)**:

$$
(\widehat{A}_t,\widehat{b}_t,\widehat{\varepsilon}^p_t,\widehat{\varepsilon}^w_t)
=\mathcal{X}((\widehat{A}_{t-1},\widehat{b}_{t-1},\widehat{\varepsilon}^p_{t-1},\widehat{\varepsilon}^w_{t-1}),\epsilon_t;\Theta_{SW}).
$$

- **(F28) Perceived law of motion for forward variables under learning**:

$$
y^f_{j,t}=\beta_{j,t-1}X_{j,t-1}+u_{j,t}.
$$

- **(F29) Kalman belief update**:

$$
\beta_{t/t}=\beta_{t/t-1}+K_t\widetilde{z}_t,
\qquad
P_{t/t}=(I-K_tX_{t-1})P_{t/t-1}.
$$

- **(F30) Belief prediction step**:

$$
(\beta_t-\bar{\beta})=F(\beta_{t-1}-\bar{\beta})+v_t.
$$

- **(F31) Actual law of motion under adaptive learning**:

$$
\begin{bmatrix}y_t\\w_t\end{bmatrix}
=
\mu_t+
T_t\begin{bmatrix}y_{t-1}\\w_{t-1}\end{bmatrix}
+R_t\epsilon_t.
$$

## 6. Steady-State Solution

The paper works with detrended variables and then log-linearizes around the stationary steady state. For the linearized archive representation, all hatted endogenous variables and shocks have zero steady state:

$$
\widehat{x}=0
\quad\text{for}\quad
x\in\{c,i,k,u,k^S,Q,R^K,R^n,R,\pi,\pi^w,l,w,mc,y,N,b,q,g,A\}.
$$

The source reports these steady-state objects or relationships:

1. The deterministic trend is $\gamma$ and $\bar{\beta}=\beta/\gamma^{\sigma_c}$.
2. The steady-state nominal interest rate in the measurement equation is $\bar{r}=100(\bar{\gamma}^{\sigma_c}II_*/\beta-1)`.
3. Financial-friction parameters governing steady-state leverage and premium dynamics are $\bar{K}/\bar{N}$, $\varkappa$, and $el$.
4. The learning model starts from REE-consistent initial beliefs. At the initial steady state, the learning ALM coincides with the RE solution; subsequent dynamics come from belief updates.

Needs review: the paper does not print the complete Smets-Wouters steady-state construction for consumption, labor, wages, marginal cost, price and wage markup blocks, or the full calibrated/estimated steady-state ratios $c_*/y_*$, $i_*/y_*$, $k_*/y_*$.

## 7. Timing & Form Conventions

- Capital is bought at the end of period $t$ as $K_{t+1}$ at price $Q_t$; services in $t+1$ are $K^S_{t+1}=U_{t+1}K_{t+1}$.
- Entrepreneurial net worth $N_{t+1}$ finances the purchase of $K_{t+1}$; the loan is $B_{t+1}=Q_tK_{t+1}-N_{t+1}$.
- Net worth evolves from realized and expected returns carried from the previous contract, so (F12) and (F13) mix $t+1$, $t$, and $t-1$ timing.
- $R^n_t$ is the nominal risk-free rate; $R_t=R^n_t-E_t\pi_{t+1}$ in log-linear terms.
- Variables are detrended by deterministic labor-augmenting growth $\gamma$ before log-linearization.
- Hatted variables are deviations around the stationary steady state. Lower-case variables in the source denote detrended real variables.
- `US_YR13AL` should be implemented as a linearized model. A future runtime implementation must decide whether to encode the adaptive-learning system directly or to use a fixed reduced-form representation generated by the learning toolbox.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII candidate | Meaning | Equation coverage |
|---|---|---|---|
| Endogenous | `c` / $\widehat{c}_t$ | consumption | (F17), (F23), needs_review |
| Endogenous | `i` / $\widehat{i}_t$ | investment | (F2), (F21), (F23) |
| Endogenous | `k` / $\widehat{k}_t$ | capital stock | (F3), (F13), (F22) |
| Endogenous | `u` / $\widehat{u}_t$ | utilization | (F5), (F21) |
| Endogenous | `ks` / $\widehat{k}^S_t$ | capital services | (F6), (F20) |
| Endogenous | `q` / $\widehat{Q}_t$ | asset price / Tobin's Q | (F1), (F2), (F8), (F10), (F13) |
| Endogenous | `rk` / $\widehat{R}^K_t$ | return on capital | (F7), (F8), (F10), (F12), (F13) |
| Endogenous | `r` / $\widehat{R}_t$ | real risk-free rate | (F10), (F13), (F16) |
| Endogenous | `rn` / $\widehat{R}^n_t$ | nominal policy rate | (F14), (F16), (F23) |
| Endogenous | `n` / $\widehat{N}_t$ | entrepreneurial net worth | (F9), (F11), (F12), (F13) |
| Endogenous | `y` / $\widehat{y}_t$ | output | (F15), (F21), (F23) |
| Endogenous | `ygap` / $\widehat{ygap}_t$ | output gap | (F14), (F15) |
| Endogenous | `pi` / $\widehat{\pi}_t$ | price inflation | (F14), (F16), (F18), (F23), needs_review |
| Endogenous | `piw` / $\widehat{\pi}^w_t$ | wage inflation | (F19), needs_review |
| Endogenous | `w` / $\widehat{w}_t$ | real wage | (F19), (F20), (F23), needs_review |
| Endogenous | `l` / $\widehat{l}_t$ | hours worked | (F19), (F20), (F23), needs_review |
| Endogenous | `mc` / $\widehat{mc}_t$ | marginal cost | (F18), (F20), needs_review |
| Endogenous | `mubank` / $\widehat{\mu}^{bank}_t$ | banking resource wedge | (F21), (F22) |
| Exogenous / shock | `eps_i`, `q` | investment-specific technology innovation/process | (F25) |
| Exogenous / shock | `eps_g`, `g` | government spending innovation/process | (F26) |
| Exogenous / shock | `eps_a`, `a` | productivity innovation/process | (F15), (F20), (F26), (F27), needs_review |
| Exogenous / shock | `eps_b`, `b` | exogenous risk-premium innovation/process | (F9), (F10), (F13), (F27), needs_review |
| Exogenous / shock | `eps_r` | monetary policy innovation | (F14) |
| Exogenous / shock | `eps_p` | price markup innovation | (F18), (F27), needs_review |
| Exogenous / shock | `eps_w` | wage markup innovation | (F19), (F27), needs_review |
| Parameter | `betta`, `gammma`, `sigma_c` | discounting, trend growth, consumption curvature | (F1), (F2), (F6) |
| Parameter | `Spp`, `tau`, `psi` | adjustment cost elasticity, depreciation, utilization-cost elasticity | (F2), (F3), (F5), (F7) |
| Parameter | `kappa`, `K_N`, `el` | survival rate, capital-to-net-worth ratio, premium elasticity | (F10), (F12), (F13) |
| Parameter | `rho_R`, `r_pi`, `r_y`, `r_Dy` | Taylor-rule coefficients | (F14) |
| Parameter | `rho_q`, `rho_g`, `rho_ga` | exogenous-process persistence/loading | (F25), (F26) |
| Learning | `beta_j`, `X_j`, `P`, `K_gain`, `rho` | perceived-law and Kalman-filter belief objects | (F28), (F29), (F30), (F31) |

Equation count in this draft: 31 numbered equations. Several inherited Smets-Wouters blocks remain placeholders and are intentionally marked `needs_review`.
