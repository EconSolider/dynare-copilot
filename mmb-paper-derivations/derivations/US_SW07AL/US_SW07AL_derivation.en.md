# US_SW07AL -- Derivation (first-pass source extraction)

> Archive status: `needs_review`. This first-pass derivation is source-backed by the MinerU Markdown for Slobodyan and Wouters (2012). Runtime validation was not performed; Dynare was not run.

## 1. Model Overview

- **Model**: `US_SW07AL`, "Learning in an estimated medium-scale DSGE model" by Sergey Slobodyan and Raf Wouters (2012), Journal of Economic Dynamics and Control.
- **Source relationship**: the paper replaces rational expectations in the Smets-Wouters (2007) US medium-scale DSGE model with adaptive learning. The structural DSGE block is summarized in Appendix B; the model-specific contribution is the expectation-formation layer in Section 3.
- **Economy**: United States, quarterly data, 1966-2005 estimation sample, seven observables: real GDP growth, real consumption growth, real investment growth, real wage growth, log hours, GDP-deflator inflation, and the federal funds rate.
- **Agents and blocks**: optimizing households with external habit and labor supply, firms with capital/labor demand and Calvo-Kimball price setting, wage setters/unions with Calvo-Kimball wage setting, capital accumulation with investment adjustment costs and variable utilization, a monetary authority with an inertial Taylor rule, and exogenous technology, risk-premium, government spending, investment, monetary policy, price-markup, and wage-markup shocks.
- **Learning layer**: private agents forecast forward-looking variables from a perceived law of motion (PLM). The paper studies MSV learning, MSV learning with constants, and VAR learning based on observed variables, with beliefs updated through constant-gain recursive least squares.
- **Model form**: log-linear equations around the stationary steady state of detrended variables. The paper says the nonlinear detrended system is linearized around the stationary steady state; this archive entry therefore treats the MMB implementation target as `model(linear)` / log-linear.
- **First-pass uncertainty**: `needs_review` applies to OCR-sensitive symbols in the appendix equations, the full flexible-price/wage companion system for the output-gap rule, and exact shock ARMA conventions for markup shocks.

## 2. Optimization Problems

### 2.1 Households

The paper states that households maximize a nonseparable utility function over consumption and labor effort, with consumption entering relative to an external habit stock. In the log-linear appendix this optimization appears through the consumption Euler equation, habit-adjusted parameters, and labor/wage markup condition rather than through a full nonlinear household Lagrangian.

Let $\widehat{c}_t$ denote detrended log consumption, $\widehat{L}_t$ labor, $\widehat{R}_t$ the nominal interest-rate deviation, $\widehat{\pi}_t$ inflation, and $\widehat{\varepsilon}^b_t$ the risk-premium shock. The household-side structure is summarized by a habit-adjusted Euler equation and wage markup condition in Section 3.

### 2.2 Firms and Wage Setters

Final-good and intermediate-good producers use capital services and differentiated labor. Firms set prices under Calvo pricing with partial indexation, Kimball curvature, and price-markup shocks. Wage setters/unions create wage monopoly power and sticky nominal wages under a parallel Calvo/indexation structure.

The paper appendix gives log-linear price and wage Phillips-curve equations rather than full nonlinear Calvo optimization recursions. This is retained as source-stated form.

### 2.3 Capital Accumulation and Utilization

Households rent capital services to firms and choose capital accumulation subject to investment adjustment costs. Utilization is chosen in response to the rental rate of capital, with increasing utilization costs.

The paper appendix gives the investment Euler equation, capital-value equation, capital accumulation, utilization condition, and capital/labor input condition in log-linear form.

### 2.4 Expectations Under Learning

Agents do not impose rational model-consistent expectations in the adaptive-learning variants. They forecast forward-looking variables from a linear perceived law of motion:

$$
y^f_t = \alpha_{t-1} + \beta_{t-1}^{T}
\begin{bmatrix}
y^s_{t-1}\\
w_t
\end{bmatrix}.
$$

The belief coefficients are updated each period using constant-gain recursive least squares. This learning block is not a standard private optimization problem but is the defining behavioral mechanism of `US_SW07AL`.

## 3. First-Order Conditions

- **(F1) Consumption Euler equation with external habit**:
$$
\widehat{c}_t =
c_1 E_t[\widehat{c}_{t+1}]
+(1-c_1)\widehat{c}_{t-1}
+c_2\left(\widehat{L}_t-E_t[\widehat{L}_{t+1}]\right)
-c_3\left(\widehat{R}_t-E_t[\widehat{\pi}_{t+1}]+\widehat{\varepsilon}^b_t\right).
$$
with
$$
c_1=\frac{1}{1+\bar{\eta}},\qquad
c_2=\frac{c_1(\sigma_c-1)(wL/C)}{\sigma_c},\qquad
c_3=\frac{c_1(1-\bar{\eta})}{\sigma_c},\qquad
\bar{\eta}=\eta/\gamma.
$$

- **(F2) Investment Euler equation**:
$$
\widehat{i}_t =
i_1\widehat{i}_{t-1}
+(1-i_1)\widehat{i}_{t+1}
+i_2\widehat{Q}^k_t
+\widehat{\varepsilon}^q_t.
$$
with
$$
i_1=\frac{1}{1+\bar{\beta}\gamma},\qquad
i_2=\frac{i_1}{\gamma^2\varphi},\qquad
\bar{\beta}=\beta\gamma^{1-\sigma_c}.
$$

- **(F3) Value of installed capital**:
$$
\widehat{Q}^k_t =
-\left(\widehat{R}_t-E_t[\widehat{\pi}_{t+1}]+\widehat{\varepsilon}^b_t\right)
+q_1 E_t[\widehat{r}^k_{t+1}]
+(1-q_1)E_t[\widehat{Q}^k_{t+1}].
$$
with
$$
q_1=\frac{r^k_*}{r^k_*+(1-\delta)}.
$$

- **(F4) Price-setting under Calvo pricing with indexation**:
$$
\widehat{\pi}_t-\iota_p\widehat{\pi}_{t-1}
=\pi_1\left(E_t[\widehat{\pi}_{t+1}]-\iota_p\widehat{\pi}_t\right)
-\pi_2\widehat{\mu}^p_t
+\widehat{\varepsilon}^p_t.
$$
with
$$
\pi_1=\bar{\beta}\gamma,\qquad
\pi_2=\frac{(1-\xi_p\bar{\beta}\gamma)(1-\xi_p)}
{\xi_p(1+(\phi_p-1)\varepsilon_p)}.
$$

- **(F5) Price markup / real marginal cost relation**:
$$
\widehat{\mu}^p_t=-\widehat{mc}_t,\qquad
\widehat{mc}_t=(1-\alpha)\widehat{w}_t+\alpha\widehat{r}^k_t-\widehat{\varepsilon}^a_t.
$$

- **(F6) Wage-setting under Calvo wages with indexation**:
$$
\widehat{\pi}^w_t-\iota_w\widehat{\pi}_{t-1}
=\pi_1\left(E_t[\widehat{\pi}^w_{t+1}]-\iota_w\widehat{\pi}_t\right)
-\pi_3\widehat{\mu}^w_t
+\widehat{\varepsilon}^w_t.
$$
with
$$
\pi_3=\frac{(1-\xi_w\bar{\beta}\gamma)(1-\xi_w)}
{\xi_w(1+(\phi_w-1)\varepsilon_w)}.
$$

- **(F7) Wage markup relation**:
$$
\widehat{\mu}^w_t
=\widehat{w}_t
-w_1\widehat{c}_t
+(1-w_1)\widehat{c}_{t-1}
-\sigma_l\widehat{L}_t,
\qquad
w_1=\frac{1}{1-\bar{\eta}}.
$$

- **(F8) Optimal capital utilization condition**:
$$
\widehat{u}_t=\frac{1-\psi}{\psi}\widehat{r}^k_t.
$$

- **(F9) Optimal capital/labor input condition**:
$$
\widehat{k}_t=\widehat{w}_t-\widehat{r}^k_t+\widehat{L}_t.
$$

## 4. Market Clearing & Identities

- **(F10) Aggregate demand equals aggregate supply / production identity**:
$$
\widehat{y}_t
=\frac{c_*}{y_*}\widehat{c}_t
+\frac{i_*}{y_*}\widehat{i}_t
+\widehat{\varepsilon}^g_t
+\frac{r^k_*k_*}{y_*}\widehat{u}_t
=\Phi_p\left(\alpha\widehat{k}_t+(1-\alpha)\widehat{L}_t+\widehat{\varepsilon}^a_t\right).
$$

- **(F11) Capital accumulation**:
$$
\widehat{\bar{k}}_t
=k_1\widehat{\bar{k}}_{t-1}
+(1-k_1)\widehat{i}_t
+k_2\widehat{\varepsilon}^q_t.
$$
with
$$
k_1=1-\frac{i_*}{\bar{k}_*},\qquad
k_2=\frac{i_*}{\bar{k}_*}(1+\bar{\beta}\gamma)\gamma^2 S''.
$$

- **(F12) Capital services identity**:
$$
\widehat{k}_t=\widehat{u}_t+\widehat{\bar{k}}_{t-1}.
$$

- **(F13) Output-gap definition for the policy rule**:
$$
\widehat{ygap}_t=\widehat{y}_t-\widehat{y}^{flex}_t.
$$
`needs_review`: the paper notes that the flexible economy is solved simultaneously and abstracts from markup shocks, but the Appendix B OCR does not provide the complete companion flexible-price/wage block.

- **(F14) Monetary policy rule**:
$$
\widehat{R}_t
=\rho_R\widehat{R}_{t-1}
+(1-\rho_R)\left(
r_\pi\widehat{\pi}_t
+r_y\widehat{ygap}_t
+r_{\Delta y}\Delta\widehat{ygap}_t
\right)
+\widehat{\varepsilon}^r_t.
$$

## 5. Exogenous Processes

- **(F15) Generic ARMA exogenous process**:
$$
x_t=\rho x_{t-1}+\varepsilon_t+\theta\varepsilon_{t-1}.
$$

- **(F16) Stacked AR(1) representation used in the learning solution**:
$$
w_t=\Gamma w_{t-1}+\Pi\varepsilon_t,\qquad
w_t=(x_t^T,\varepsilon_t^T)^T.
$$

- **(F17) Structural linear system before substituting beliefs**:
$$
A_0
\begin{bmatrix}
y_{t-1}\\
w_{t-1}
\end{bmatrix}
+A_1
\begin{bmatrix}
y_t\\
w_t
\end{bmatrix}
+A_2E_t y_{t+1}
+B_0\varepsilon_t
=const.
$$

- **(F18) Rational-expectations/MSV solution form**:
$$
\begin{bmatrix}
y_t\\
w_t
\end{bmatrix}
=\mu+T
\begin{bmatrix}
y_{t-1}\\
w_{t-1}
\end{bmatrix}
+R\varepsilon_t,
\qquad
y_t=a+by_{t-1}+cw_t.
$$

- **(F19) Perceived law of motion for forward-looking variables**:
$$
y^f_t=\alpha_{t-1}+\beta_{t-1}^T
\begin{bmatrix}
y^s_{t-1}\\
w_t
\end{bmatrix}.
$$
In the MSV case, the regressors are endogenous state variables and exogenous driving processes; in the VAR-learning case, the regressors are restricted to observed macro variables and a constant.

- **(F20) Constant-gain belief update**:
$$
\phi_t=\phi_{t-1}
+gR_t^{-1}Z_{t-1}
\left(y^f_t-\phi_{t-1}^TZ_{t-1}\right)^T.
$$

- **(F21) Constant-gain second-moment update**:
$$
R_t=R_{t-1}+g\left(Z_{t-1}Z_{t-1}^T-R_{t-1}\right).
$$
where
$$
Z_t=\left(1,(y^s_{t-1})^T,w_t^T\right)^T,\qquad
\phi^T=(\alpha,\beta^T).
$$
`needs_review`: Appendix text/OCR states 12 forward-looking variables, 11 endogenous state variables, and 9 exogenous stochastic processes, but the rendered dimension for $\alpha_{t-1}$ is garbled.

- **(F22) Initial beliefs from REE moments**:
$$
\phi_0
=E[Z_{t-1}Z_{t-1}^T]^{-1}
E[Z_{t-1}(y^f_t)^T],
\qquad
R_0=E[Z_{t-1}Z_{t-1}^T].
$$

## 6. Steady-State Solution

The Appendix B equations are log-linear around the stationary steady state of detrended variables. The relevant steady-state solution for a `model(linear)` archive entry is therefore:

1. Detrend real quantities by deterministic labor-augmenting technological growth.
2. Normalize log deviations of stationary real variables and inflation/rate deviations to zero at the steady state:
$$
\widehat{c}_*=\widehat{i}_*=\widehat{y}_*=\widehat{w}_*=\widehat{L}_*
=\widehat{\pi}_*=\widehat{R}_*=\widehat{Q}^k_*
=\widehat{r}^k_*=\widehat{u}_*=0.
$$
3. Set innovations and exogenous deviations to zero:
$$
\widehat{\varepsilon}^a_*=\widehat{\varepsilon}^b_*=\widehat{\varepsilon}^g_*=\widehat{\varepsilon}^q_*=\widehat{\varepsilon}^r_*=\widehat{\varepsilon}^p_*=\widehat{\varepsilon}^w_*=0.
$$
4. For the learning state, if beliefs are initialized from an REE moment matrix, use (F22). Under model-consistent beliefs and zero innovations, the PLM produces steady expectations equal to the zero-deviation steady state.
5. Structural steady-state ratios and calibrated constants appearing in the log-linear coefficients include $c_*/y_*$, $i_*/y_*$, $r^k_*k_*/y_*$, $\bar{k}_*$, $r^k_*$, $\bar{\eta}$, $\bar{\beta}$, and $\gamma$. The paper appendix does not provide a complete nonlinear steady-state derivation; this first-pass archive records those coefficients as source-stated inputs and marks full nonlinear reconstruction as `needs_review`.

Runtime validation status: not performed. Dynare was not run.

## 7. Timing & Form Conventions

- **Form**: log-linear / `model(linear)` equations in deviations from the stationary steady state of detrended variables.
- **Capital timing**: $\widehat{\bar{k}}_t$ is the installed capital stock evolving through (F11). Capital services used in production satisfy $\widehat{k}_t=\widehat{u}_t+\widehat{\bar{k}}_{t-1}$, so production uses predetermined installed capital chosen before period $t$ utilization.
- **Expectations timing**: lead variables $y^f_t$ are forecast with beliefs known at $t-1$ and information in $Z_t$ / $Z_{t-1}$ as specified in the learning recursion. The paper uses Kalman-filtered model variables when the variables are not observed.
- **Learning variants**: MSV learning uses the model's state and exogenous variables; MSV-plus-constant also learns constants; VAR learning restricts the belief equations to observed variables and a constant.
- **Projection facility**: when learning dynamics imply explosive temporary transition matrices, the paper follows the learning literature by excluding those updates.
- **Implementation cross-check**: no `.agents/skills/dynare-copilot/references/examples/US_SW07AL_rep.mod` file exists. A related `US_SW07_rep.mod` exists but was not used as assigned cross-check evidence for this model.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Equation(s) |
|---|---|---|---|
| Endogenous | `c` / $\widehat{c}$ | Consumption deviation | (F1) |
| Endogenous | `i` / $\widehat{i}$ | Investment deviation | (F2), (F10), (F11) |
| Endogenous | `qk` / $\widehat{Q}^k$ | Value of installed capital | (F2), (F3) |
| Endogenous | `rk` / $\widehat{r}^k$ | Rental rate of capital | (F3), (F5), (F8), (F9) |
| Endogenous | `pi` / $\widehat{\pi}$ | Price inflation | (F1), (F4), (F6), (F14) |
| Endogenous | `piw` / $\widehat{\pi}^w$ | Wage inflation | (F6) |
| Endogenous | `mc` / $\widehat{mc}$ | Real marginal cost | (F5) |
| Endogenous | `mup` / $\widehat{\mu}^p$ | Price markup | (F4), (F5) |
| Endogenous | `muw` / $\widehat{\mu}^w$ | Wage markup | (F6), (F7) |
| Endogenous | `w` / $\widehat{w}$ | Real wage | (F5), (F7), (F9) |
| Endogenous | `lab` / $\widehat{L}$ | Labor | (F1), (F7), (F9), (F10) |
| Endogenous | `y` / $\widehat{y}$ | Output | (F10), (F13) |
| Endogenous | `ygap` / $\widehat{ygap}$ | Output gap | (F13), (F14) |
| Endogenous | `yflex` / $\widehat{y}^{flex}$ | Flexible-price/wage output | (F13) |
| Endogenous | `kbar` / $\widehat{\bar{k}}$ | Installed capital stock | (F11), (F12) |
| Endogenous | `k` / $\widehat{k}$ | Capital services in production | (F9), (F10), (F12) |
| Endogenous | `u` / $\widehat{u}$ | Utilization | (F8), (F10), (F12) |
| Endogenous | `R` / $\widehat{R}$ | Nominal interest rate deviation | (F1), (F3), (F14) |
| Learning state | `phi` / $\phi$ | Belief coefficient matrix | (F20), (F22) |
| Learning state | `Rbel` / $R_t$ | Belief second-moment matrix | (F21), (F22) |
| Learning state | `yf` / $y^f$ | Forward-looking variables forecast under PLM | (F19), (F20), (F22) |
| Exogenous shock | `eps_a` / $\varepsilon^a$ | Technology shock | (F5), (F10), (F15) |
| Exogenous shock | `eps_b` / $\varepsilon^b$ | Risk-premium shock | (F1), (F3), (F15) |
| Exogenous shock | `eps_g` / $\varepsilon^g$ | Government/exogenous demand shock | (F10), (F15) |
| Exogenous shock | `eps_q` / $\varepsilon^q$ | Investment-specific technology shock | (F2), (F11), (F15) |
| Exogenous shock | `eps_r` / $\varepsilon^r$ | Monetary policy shock | (F14), (F15) |
| Exogenous shock | `eps_p` / $\varepsilon^p$ | Price-markup shock | (F4), (F15) |
| Exogenous shock | `eps_w` / $\varepsilon^w$ | Wage-markup shock | (F6), (F15) |
| Parameter | `eta` / $\eta$ | External habit parameter | (F1), (F7) |
| Parameter | `gamma` / $\gamma$ | Trend growth adjustment in appendix coefficients | (F1), (F2), (F4), (F6), (F11) |
| Parameter | `sigmac` / $\sigma_c$ | Inverse intertemporal elasticity | (F1), (F2), (F7) |
| Parameter | `varphi` / $\varphi$ | Investment adjustment-cost elasticity | (F2) |
| Parameter | `beta` / $\beta$ | Discount factor | (F2), (F4), (F6), (F11) |
| Parameter | `delta` / $\delta$ | Depreciation rate, calibrated at 0.025 | (F3) |
| Parameter | `alpha` / $\alpha$ | Capital share | (F5), (F9), (F10) |
| Parameter | `xip`, `xiw` / $\xi_p,\xi_w$ | Calvo price/wage stickiness | (F4), (F6) |
| Parameter | `iotap`, `iotaw` / $\iota_p,\iota_w$ | Price/wage indexation | (F4), (F6) |
| Parameter | `phip`, `phiw` / $\phi_p,\phi_w$ | Kimball curvature; $\phi_w$ calibrated at 1.5 | (F4), (F6) |
| Parameter | `epsp`, `epsw` / $\varepsilon_p,\varepsilon_w$ | Price/wage substitution curvature, calibrated at 10 each | (F4), (F6) |
| Parameter | `psi` / $\psi$ | Utilization cost elasticity | (F8) |
| Parameter | `rhoR` / $\rho_R$ | Interest-rate smoothing | (F14) |
| Parameter | `rpi`, `ry`, `rdy` | Policy response to inflation, output gap, output-gap growth | (F14) |
| Parameter | `g` | Constant gain in learning recursion | (F20), (F21) |
| Parameter | `rho`, `theta` | Persistence and MA term for exogenous processes | (F15), (F16) |
