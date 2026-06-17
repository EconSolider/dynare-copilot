# US_FV10 -- Derivation (Optimization Problems + First-Order Conditions)

> Archive status: `needs_review`. This first-pass derivation is source-backed by the MinerU Markdown for Fernández-Villaverde (2010). Equations from the local `.mod` implementation are used only as `implementation_cross_check`; Dynare runtime validation was not performed.

## 1. Model Overview

- **Model**: `US_FV10`, the benchmark estimated DSGE application in Jesús Fernández-Villaverde (2010), "The Econometrics of DSGE Models", DOI `10.1007/s13209-009-0014-7`.
- **Purpose**: estimated U.S. medium-scale New Keynesian DSGE model with real and nominal rigidities, used in the paper to illustrate Bayesian DSGE estimation.
- **Agents and blocks**: households with external habits, money in utility, complete markets, capital accumulation, utilization, differentiated labor and Calvo wage setting; final-good aggregator; intermediate-good firms with Cobb-Douglas production, fixed costs, Calvo price setting and indexation; monetary authority with a Taylor rule.
- **Shocks**: preference, labor-disutility, neutral technology, investment-specific technology, and monetary-policy shocks.
- **Model form**: the paper presents nonlinear equilibrium conditions, then rescales nonstationary variables by stochastic trends and solves by log-linearizing around the deterministic steady state. The Rep-MMB `.mod` cross-check implements stationary nonlinear equations and calls first-order perturbation, not `model(linear)`.
- **Source caveat**: the MMB implementation comments say the equations are described in more detail in Fernández-Villaverde and Rubio-Ramírez (2006), while the 2010 paper supplies the model summary and estimated calibration. This archive entry does not treat the `.mod` file as a paper-side source.

## 2. Optimization Problems

### 2.1 Household

The household chooses consumption, money, bonds, Arrow securities, investment, utilization, capital, labor, and its reset wage. Its period utility has habit-adjusted log consumption, money services, and labor disutility:

$$
E_0 \sum_{t=0}^{\infty}\beta^t d_t
\left[
\log(c_{jt}-h c_{j,t-1})
+ \upsilon\log\left(\frac{m_{jt}}{p_t}\right)
-\varphi_t\psi\frac{l_{jt}^{1+\vartheta}}{1+\vartheta}
\right].
$$

The budget constraint is:

$$
\begin{aligned}
c_{jt}+x_{jt}+\frac{m_{jt}}{p_t}+\frac{b_{jt+1}}{p_t}
+\int q_{j,t+1,t}a_{j,t+1}\,d\omega_{j,t+1,t}
&=w_{jt}l_{jt}+\left(r_tu_{jt}-\mu_t^{-1}\Phi[u_{jt}]\right)k_{j,t-1}\\
&\quad+\frac{m_{j,t-1}}{p_t}+R_{t-1}\frac{b_{jt}}{p_t}
+a_{jt}+T_t+F_t .
\end{aligned}
$$

Capital evolves according to:

$$
k_{jt}=(1-\delta)k_{j,t-1}
+\mu_t\left(1-S\left[\frac{x_{jt}}{x_{j,t-1}}\right]\right)x_{jt}.
$$

Wage setters face Calvo rigidity. A household resetting its wage solves:

$$
\max_{w_{jt}} E_t\sum_{\tau=0}^{\infty}(\beta\theta_w)^\tau
\left[
-d_{t+\tau}\varphi_{t+\tau}\psi\frac{l_{j,t+\tau}^{1+\vartheta}}{1+\vartheta}
+\lambda_{t+\tau}
\prod_{s=1}^{\tau}\frac{\Pi_{t+s-1}^{\chi_w}}{\Pi_{t+s}}
w_{jt}l_{j,t+\tau}
\right],
$$

subject to labor demand:

$$
l_{j,t+\tau}=
\left(
\prod_{s=1}^{\tau}\frac{\Pi_{t+s-1}^{\chi_w}}{\Pi_{t+s}}
\frac{w_{jt}}{w_{t+\tau}}
\right)^{-\eta}l^d_{t+\tau}.
$$

### 2.2 Labor Packer

The competitive labor packer aggregates differentiated labor:

$$
l_t^d=\left(\int_0^1 l_{jt}^{\frac{\eta-1}{\eta}}\,dj\right)^{\frac{\eta}{\eta-1}},
$$

and maximizes:

$$
\max_{\{l_{jt}\}} w_tl_t^d-\int_0^1 w_{jt}l_{jt}\,dj.
$$

### 2.3 Final-Good Producer

The final-good producer aggregates intermediate goods:

$$
y_t^d=\left(\int_0^1 y_{it}^{\frac{\varepsilon-1}{\varepsilon}}\,di\right)^{\frac{\varepsilon}{\varepsilon-1}},
$$

and maximizes profits taking intermediate prices and the final-good price as given.

### 2.4 Intermediate-Good Producers

Given input prices, each intermediate producer first minimizes cost:

$$
\min_{l^d_{it},k_{i,t-1}} w_tl^d_{it}+r_tk_{i,t-1}
$$

subject to:

$$
y_{it}=A_t k_{i,t-1}^{\alpha}(l^d_{it})^{1-\alpha}-\phi z_t .
$$

The same firm then sets prices under Calvo rigidity with price indexation:

$$
\max_{p_{it}} E_t\sum_{\tau=0}^{\infty}(\beta\theta_p)^\tau
\frac{\lambda_{t+\tau}}{\lambda_t}
\left[
\left(
\prod_{s=1}^{\tau}\Pi_{t+s-1}^{\chi}\frac{p_{it}}{p_{t+\tau}}
-mc_{t+\tau}
\right)y_{i,t+\tau}
\right],
$$

subject to:

$$
y_{i,t+\tau}=
\left(
\prod_{s=1}^{\tau}\Pi_{t+s-1}^{\chi}\frac{p_{it}}{p_{t+\tau}}
\right)^{-\varepsilon}y^d_{t+\tau}.
$$

### 2.5 Monetary Authority

The monetary authority is mechanical, not optimizing. Its Taylor rule is listed in Section 5.

## 3. First-Order Conditions

- **(F1) Habit-adjusted marginal utility of consumption** (`needs_review`: the later repeated aggregate equation in the OCR appears to drop the `t+1` subscript inside the habit term; the earlier household FOC is internally coherent):

$$
d_t(c_t-hc_{t-1})^{-1}
-h\beta E_t\left[d_{t+1}(c_{t+1}-hc_t)^{-1}\right]
=\lambda_t .
$$

- **(F2) Nominal bond Euler equation**:

$$
\lambda_t=\beta E_t\left[\lambda_{t+1}\frac{R_t}{\Pi_{t+1}}\right].
$$

- **(F3) Capital utilization**:

$$
r_t=\mu_t^{-1}\Phi'[u_t].
$$

- **(F4) Tobin's Q / capital Euler equation**:

$$
q_t=\beta E_t\left[
\frac{\lambda_{t+1}}{\lambda_t}
\left((1-\delta)q_{t+1}+r_{t+1}u_{t+1}-\mu_{t+1}^{-1}\Phi[u_{t+1}]\right)
\right].
$$

- **(F5) Investment adjustment-cost FOC**:

$$
\begin{aligned}
1&=q_t\mu_t
\left(
1-S\left[\frac{x_t}{x_{t-1}}\right]
-S'\left[\frac{x_t}{x_{t-1}}\right]\frac{x_t}{x_{t-1}}
\right)\\
&\quad+\beta E_t\left[
q_{t+1}\mu_{t+1}\frac{\lambda_{t+1}}{\lambda_t}
S'\left[\frac{x_{t+1}}{x_t}\right]\left(\frac{x_{t+1}}{x_t}\right)^2
\right].
\end{aligned}
$$

- **(F6) Wage-recursion pricing side**:

$$
f^1_t=\frac{\eta-1}{\eta}(w_t^*)^{1-\eta}\lambda_t w_t^\eta l^d_t
+\beta\theta_w E_t\left[
\left(\frac{\Pi_t^{\chi_w}}{\Pi_{t+1}}\right)^{1-\eta}
\left(\frac{w^*_{t+1}}{w^*_t}\right)^{\eta-1}f^1_{t+1}
\right].
$$

- **(F7) Wage-recursion labor-disutility side**:

$$
f^2_t=\psi d_t\varphi_t\left(\frac{w_t}{w_t^*}\right)^{\eta(1+\vartheta)}(l^d_t)^{1+\vartheta}
+\beta\theta_w E_t\left[
\left(\frac{\Pi_t^{\chi_w}}{\Pi_{t+1}}\right)^{-\eta(1+\vartheta)}
\left(\frac{w^*_{t+1}}{w^*_t}\right)^{\eta(1+\vartheta)}f^2_{t+1}
\right].
$$

- **(F8) Optimal wage condition**:

$$
f^1_t=f^2_t.
$$

- **(F9) Intermediate-firm cost-minimizing input ratio**:

$$
\frac{k_{i,t-1}}{l^d_{it}}=\frac{\alpha}{1-\alpha}\frac{w_t}{r_t}.
$$

- **(F10) Real marginal cost**:

$$
mc_t=
\left(\frac{1}{1-\alpha}\right)^{1-\alpha}
\left(\frac{1}{\alpha}\right)^\alpha
\frac{w_t^{1-\alpha}r_t^\alpha}{A_t}.
$$

- **(F11) Calvo price recursion 1**:

$$
g^1_t=\lambda_tmc_ty^d_t+
\beta\theta_p E_t\left[
\left(\frac{\Pi_t^\chi}{\Pi_{t+1}}\right)^{-\varepsilon}g^1_{t+1}
\right].
$$

- **(F12) Calvo price recursion 2**:

$$
g^2_t=\lambda_t\Pi^*_t y^d_t+
\beta\theta_p E_t\left[
\left(\frac{\Pi_t^\chi}{\Pi_{t+1}}\right)^{1-\varepsilon}
\left(\frac{\Pi^*_t}{\Pi^*_{t+1}}\right)g^2_{t+1}
\right].
$$

- **(F13) Optimal reset price condition**:

$$
\varepsilon g^1_t=(\varepsilon-1)g^2_t.
$$

## 4. Market Clearing & Identities

- **(F14) Capital accumulation**:

$$
k_t=(1-\delta)k_{t-1}
+\mu_t\left(1-S\left[\frac{x_t}{x_{t-1}}\right]\right)x_t .
$$

- **(F15) Labor demand for differentiated labor**:

$$
l_{jt}=\left(\frac{w_{jt}}{w_t}\right)^{-\eta}l^d_t.
$$

- **(F16) Aggregate wage index**:

$$
w_t=\left(\int_0^1 w_{jt}^{1-\eta}\,dj\right)^{\frac{1}{1-\eta}}.
$$

- **(F17) Real wage law of motion**:

$$
w_t^{1-\eta}=
\theta_w\left(\frac{\Pi_{t-1}^{\chi_w}}{\Pi_t}\right)^{1-\eta}w_{t-1}^{1-\eta}
+(1-\theta_w)(w_t^*)^{1-\eta}.
$$

- **(F18) Final-good demand for intermediate goods**:

$$
y_{it}=\left(\frac{p_{it}}{p_t}\right)^{-\varepsilon}y^d_t.
$$

- **(F19) Aggregate price index**:

$$
p_t=\left(\int_0^1 p_{it}^{1-\varepsilon}\,di\right)^{\frac{1}{1-\varepsilon}}.
$$

- **(F20) Calvo price-index law**:

$$
1=\theta_p\left(\frac{\Pi_{t-1}^{\chi}}{\Pi_t}\right)^{1-\varepsilon}
+(1-\theta_p)(\Pi^*_t)^{1-\varepsilon}.
$$

- **(F21) Taylor rule**:

$$
\frac{R_t}{R}=
\left(\frac{R_{t-1}}{R}\right)^{\gamma_R}
\left[
\left(\frac{\Pi_t}{\Pi}\right)^{\gamma_\Pi}
\left(\frac{(y^d_t/y^d_{t-1})}{\Lambda_z}\right)^{\gamma_y}
\right]^{1-\gamma_R}
\exp(m_t).
$$

- **(F22) Aggregate demand**:

$$
y^d_t=c_t+x_t+\mu_t^{-1}\Phi[u_t]k_{t-1}.
$$

- **(F23) Aggregate supply with price dispersion**:

$$
y_t=
\frac{A_t(u_tk_{t-1})^\alpha(l^d_t)^{1-\alpha}-\phi z_t}{v^p_t}.
$$

- **(F24) Labor packing and wage dispersion**:

$$
l^d_t=\frac{l_t}{v^w_t}.
$$

- **(F25) Price dispersion**:

$$
v^p_t=
\theta_p\left(\frac{\Pi_{t-1}^{\chi}}{\Pi_t}\right)^{-\varepsilon}v^p_{t-1}
+(1-\theta_p)(\Pi^*_t)^{-\varepsilon}.
$$

- **(F26) Wage dispersion**:

$$
v^w_t=
\theta_w\left(\frac{w_{t-1}}{w_t}\frac{\Pi_{t-1}^{\chi_w}}{\Pi_t}\right)^{-\eta}v^w_{t-1}
+(1-\theta_w)(\Pi^{*w}_t)^{-\eta}.
$$

- **(F27) Composite stochastic trend** (`needs_review`: OCR includes a duplicated exponent fragment in the prose; formula is reconstructed from the adjacent displayed equation and `.mod` cross-check):

$$
z_t=A_t^{\frac{1}{1-\alpha}}\mu_t^{\frac{\alpha}{1-\alpha}}.
$$

- **(F28) Composite growth rate**:

$$
z_t=z_{t-1}\exp(\Lambda_z+z_{z,t}),\qquad
z_{z,t}=\frac{z_{A,t}+\alpha z_{\mu,t}}{1-\alpha},\qquad
\Lambda_z=\frac{\Lambda_A+\alpha\Lambda_\mu}{1-\alpha}.
$$

## 5. Exogenous Processes

- **(F29) Neutral technology**:

$$
A_t=A_{t-1}\exp(\Lambda_A+z_{A,t}),\qquad
z_{A,t}=\sigma_A\varepsilon_{A,t},\qquad
\varepsilon_{A,t}\sim\mathcal{N}(0,1).
$$

- **(F30) Investment-specific technology** (`needs_review`: the 2010 Markdown implies the process for $\mu_t$ through the composite trend and Table 1/Table 3, but the displayed law is not as explicit as the law for $A_t$):

$$
\mu_t=\mu_{t-1}\exp(\Lambda_\mu+z_{\mu,t}),\qquad
z_{\mu,t}=\sigma_\mu\varepsilon_{\mu,t}.
$$

- **(F31) Monetary policy innovation**:

$$
m_t=\sigma_m\varepsilon_{m,t},\qquad \varepsilon_{m,t}\sim\mathcal{N}(0,1).
$$

- **(F32) Preference shock** (`implementation_cross_check`; the paper lists $\rho_d$ and $\sigma_d$ in tables, while the local `.mod` implements this stationary AR(1)):

$$
\log d_t=\rho_d\log d_{t-1}+\sigma_d\varepsilon_{d,t}.
$$

- **(F33) Labor-disutility shock** (`implementation_cross_check`; the paper lists $\rho_\varphi$ and $\sigma_\varphi$ in tables, while the local `.mod` implements this stationary AR(1)):

$$
\log\varphi_t=\rho_\varphi\log\varphi_{t-1}+\sigma_\varphi\varepsilon_{\varphi,t}.
$$

## 6. Steady-State Solution

The paper states that variables are rescaled by the stochastic trend before solving the model. For any variable $x_t$ growing with the composite trend, define $\tilde{x}_t=x_t/z_t$. The paper also notes exceptions:

$$
\tilde r_t=r_t\mu_t,\qquad \tilde q_t=q_t\mu_t,\qquad
\tilde k_t=\frac{k_t}{z_t\mu_t}.
$$

At the deterministic steady state of the stationary system:

$$
E[\varepsilon_{A,t}]=E[\varepsilon_{\mu,t}]=E[\varepsilon_{m,t}]
=E[\varepsilon_{d,t}]=E[\varepsilon_{\varphi,t}]=0,
\qquad d=\varphi=1.
$$

The balanced-growth rates are:

$$
\Lambda_z=\frac{\Lambda_A+\alpha\Lambda_\mu}{1-\alpha}.
$$

The estimated/fixed values recorded in the paper and used by the MMB implementation include:

$$
\delta=0.025,\quad \varepsilon=10,\quad \eta=10,\quad \phi=0,\quad \Phi_2=0.001,
$$

and posterior medians such as:

$$
\beta=0.998,\; h=0.97,\; \psi=8.92,\; \vartheta=1.17,\;
\kappa=9.51,\; \alpha=0.21,\; \theta_p=0.82,\; \chi=0.63,\;
\theta_w=0.68,\; \chi_w=0.62.
$$

For a future `steady_state_model`, solve the stationary nonlinear system implied by (F1)-(F33) after replacing each variable by its rescaled counterpart and setting shocks to zero. The paper does not provide a complete closed-form steady-state algorithm in the extracted Markdown, so this first-pass archive records the closed-form steady state as `needs_review`. The local `.mod` indicates that several steady-state objects are assigned in an external steady-state file rather than in this `.mod`: $\gamma_1$, $R$, $\Lambda_{Yd}$, and $\Lambda_x$.

Runtime validation: not performed. Dynare was not run.

## 7. Timing & Form Conventions

- **Capital timing**: the paper's production function uses $k_{i,t-1}$, and the capital law maps current investment into $k_t$; capital is a predetermined stock used in production with one-period lag.
- **Growth and stationarization**: neutral technology $A_t$ and investment-specific technology $\mu_t$ generate unit roots. Variables are rescaled by $z_t=A_t^{1/(1-\alpha)}\mu_t^{\alpha/(1-\alpha)}$, with exceptions for rental rates, Tobin's Q, and capital.
- **Nominal rigidities**: wages and prices are Calvo with partial indexation to lagged inflation. Wage and price dispersion are state variables.
- **Interest-rate timing**: the Taylor rule uses lagged nominal interest rate, current inflation, and output-demand growth relative to trend growth.
- **Solution form**: nonlinear stationary equilibrium conditions are solved by log-linearization around the deterministic steady state; the archive should not be read as a hand-linearized `model(linear)` specification.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Main equation(s) |
|---|---|---|---|
| Endogenous | `c`, $c_t$ | consumption | (F1), (F22) |
| Endogenous | `lambda`, $\lambda_t$ | marginal utility / budget multiplier | (F1), (F2) |
| Endogenous | `R`, $R_t$ | nominal gross interest rate | (F2), (F21) |
| Endogenous | `PI`, $\Pi_t$ | gross inflation | (F2), (F20), (F21) |
| Endogenous | `r`, $r_t$ | rental rate of capital | (F3), (F9), (F10) |
| Endogenous | `u`, $u_t$ | capital utilization | (F3), (F23) |
| Endogenous | `q`, $q_t$ | Tobin's marginal Q | (F4), (F5) |
| Endogenous | `x`, $x_t$ | investment | (F5), (F14), (F22) |
| Endogenous | `k`, $k_t$ | capital stock | (F14), (F23) |
| Endogenous | `f`, $f^1_t/f^2_t$ | wage-recursion auxiliary variables | (F6)-(F8) |
| Endogenous | `w`, $w_t$ | real wage | (F16), (F17) |
| Endogenous | `wstar`, $w^*_t$ | reset real wage | (F6)-(F8), (F17) |
| Endogenous | `PIstarw`, $\Pi^{*w}_t$ | optimal wage inflation/reset wage ratio | (F7), (F26) |
| Endogenous | `yd`, $y^d_t$ | aggregate demand/output demand | (F11), (F12), (F18), (F21), (F22) |
| Endogenous | `mc`, $mc_t$ | real marginal cost | (F10), (F11) |
| Endogenous | `g1`, $g^1_t$ | price-setting recursion 1 | (F11), (F13) |
| Endogenous | `g2`, $g^2_t$ | price-setting recursion 2 | (F12), (F13) |
| Endogenous | `PIstar`, $\Pi^*_t$ | reset price inflation | (F12), (F20), (F25) |
| Endogenous | `vp`, $v^p_t$ | price dispersion | (F23), (F25) |
| Endogenous | `vw`, $v^w_t$ | wage dispersion | (F24), (F26) |
| Endogenous | `ld`, $l^d_t$ | aggregate labor demand / packed labor | (F15), (F24) |
| Endogenous | `l`, $l_t$ | aggregate labor bundle | (F24) |
| Endogenous | `mu_z`, $z_t/z_{t-1}$ | composite trend growth | (F28) |
| Endogenous | `mu_I`, $\mu_t/\mu_{t-1}$ | investment-specific technology growth | (F30) |
| Endogenous | `mu_A`, $A_t/A_{t-1}$ | neutral technology growth | (F29) |
| Endogenous | `d`, $d_t$ | preference shock level | (F32) |
| Endogenous | `phi`, $\varphi_t$ | labor-disutility shock level | (F33) |
| Endogenous | `F`, $F_t$ | firm profits / transfers in household budget | budget constraint |
| Endogenous | `yg` | output-growth observable | (F21), cross-check `.mod` |
| Exogenous | `epsd` | preference innovation | (F32) |
| Exogenous | `epsphi` | labor-disutility innovation | (F33) |
| Exogenous | `epsmu_I` | investment-specific technology innovation | (F30) |
| Exogenous | `epsA` | neutral technology innovation | (F29) |
| Exogenous | `epsm` | monetary-policy innovation | (F31) |
| Parameter | `h` | habit parameter | (F1) |
| Parameter | `betta`, $\beta$ | discount factor | (F1)-(F7), (F11)-(F12) |
| Parameter | `delta`, $\delta$ | depreciation rate | (F4), (F14) |
| Parameter | `kappa`, $\kappa$ | investment adjustment-cost scale | via $S(\cdot)$ |
| Parameter | `eta`, $\eta$ | labor-variety elasticity | (F6)-(F8), (F15)-(F17), (F26) |
| Parameter | `epsilon`, $\varepsilon$ | goods-variety elasticity | (F11)-(F13), (F18)-(F20), (F25) |
| Parameter | `varpsi`, $\psi$ | labor-disutility scale | (F7) |
| Parameter | `gammma`, $\vartheta$ | inverse Frisch elasticity | (F7) |
| Parameter | `chiw`, $\chi_w$ | wage indexation | (F6), (F7), (F17), (F26) |
| Parameter | `chi`, $\chi$ | price indexation | (F11), (F12), (F20), (F25) |
| Parameter | `thetap`, $\theta_p$ | Calvo price stickiness | (F11), (F12), (F20), (F25) |
| Parameter | `thetaw`, $\theta_w$ | Calvo wage stickiness | (F6), (F7), (F17), (F26) |
| Parameter | `alppha`, $\alpha$ | capital share | (F9), (F10), (F23), (F28) |
| Parameter | `gammmaR`, $\gamma_R$ | interest-rate smoothing | (F21) |
| Parameter | `gammmaPI`, $\gamma_\Pi$ | inflation response | (F21) |
| Parameter | `gammmay`, $\gamma_y$ | output-growth response | (F21) |
| Parameter | `PIbar`, $\Pi$ | inflation target | (F21) |
| Parameter | `rhod`, `rhophi` | shock persistence | (F32), (F33) |
| Parameter | `sigma_A`, `sigma_d`, `sigma_phi`, `sigma_mu`, `sigma_m` | shock standard deviations | (F29)-(F33) |
| Parameter | `LambdaA`, `Lambdamu`, `Lambdax`, `LambdaYd` | trend growth terms | (F28)-(F30), cross-check `.mod` |
