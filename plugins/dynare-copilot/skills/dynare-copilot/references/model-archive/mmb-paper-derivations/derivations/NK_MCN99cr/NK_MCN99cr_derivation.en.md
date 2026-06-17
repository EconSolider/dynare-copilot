# NK_MCN99cr - Derivation

> Source-backed draft for the MMB model archive. Runtime validation was not performed. Formula status: `needs_review` for PDF-level checking and for the exact mapping between the paper's simulation variants and the Rep-MMB Calvo-Rotemberg implementation.

## 1. Model Overview

- **Model ID**: `NK_MCN99cr`.
- **Paper**: Bennett T. McCallum and Edward Nelson, "Performance of Operational Policy Rules in an Estimated Semiclassical Structural Model," NBER Working Paper 6599 / *Monetary Policy Rules*, 1999.
- **DOI**: `10.3386/w6599`.
- **Source Markdown**: `raw/mmb_mineru/runs/nk_mcn99cr__performance_of_operational_policy_rules_in_an_estimated_semiclassical_st__b43633f6/full.md`.
- **Raw PDF**: `raw/mmb_papers/Performance of Operational Policy Rules in an Estimated Semiclassical Structural Model.pdf`.
- **MinerU run id**: `b43633f6-1141-457a-af12-8edc3db54f79`.
- **Model form**: log-linear `model(linear)` in the Rep-MMB implementation. Lower-case variables are logs or log deviations; the nominal interest rate is in quarterly fractional units. The implemented variant is the Calvo-Rotemberg aggregate-supply version, not the paper's P-bar variant.
- **Agents and blocks**: infinitely lived households that consume, hold real money balances, bonds, and capital, and also produce differentiated goods; demand aggregation; exogenous investment/capacity-output processes; Calvo-Rotemberg price adjustment; monetary policy rule.
- **Implementation cross-check**: `.agents/skills/dynare-copilot/references/examples/NK_MCN99cr_rep.mod` is used only to identify the Rep-MMB variable set and selected policy-rule variant. It was not used as a paper-side mathematical source.

## 2. Optimization Problems

### Household consumption, money, capital, and bonds

The household maximizes expected discounted utility over consumption and real money balances:

$$
E_t \sum_{j=0}^{\infty} \beta^j U\!\left(C_{t+j}, \frac{M_{t+j}}{P^A_{t+j}}\right)
$$

with separable period utility

$$
U\!\left(C_t,\frac{M_t}{P^A_t}\right)
= \frac{\sigma}{\sigma-1} C_t^{(\sigma-1)/\sigma} e^{\omega_t}
+ \frac{1}{1-\gamma}\left(\frac{M_t}{P^A_t}\right)^{1-\gamma} e^{\chi_t}.
$$

The household also owns a differentiated-producing unit. Given demand for its good, it hires labor and uses capital:

$$
A_t K_t^{\alpha}(N^d_t)^{1-\alpha}
= \left(\frac{P_t}{P^A_t}\right)^{-\theta} Y^A_t.
$$

The period budget constraint is:

$$
\begin{aligned}
0={}&
\left(\frac{P_t}{P^A_t}\right)^{1-\theta}Y^A_t
- C_t - K_{t+1} + (1-\delta)K_t
+ \frac{W_t}{P^A_t}N^S_t
- \frac{W_t}{P^A_t}N^d_t \\
&+ TR_t
- \frac{M_t}{P^A_t} + \frac{M_{t-1}}{P^A_t}
- \frac{B_{t+1}}{1+r_t} + B_t .
\end{aligned}
$$

Leisure is absent from utility, so desired labor supply is inelastic, $N^S_t=1$. The realized labor input is demand-determined when prices are sticky.

### Producer price setting

For the Calvo-Rotemberg variant, a producer chooses the price path to minimize expected deviations from its frictionless desired price and quadratic price-adjustment costs:

$$
E_t \sum_{j=0}^{\infty}\beta^j
\left[
(p_{t+j}-\bar p_{t+j})^2
+ c_1(p_{t+j}-p_{t+j-1})^2
\right].
$$

The paper also develops a P-bar alternative in which output-gap changes enter the adjustment-cost term. That variant is not the `NK_MCN99cr` Rep-MMB cross-check model and is not treated as the active implementation here.

## 3. First-Order Conditions

- **(F1) Consumption marginal utility**:

$$
C_t^{-1/\sigma} e^{\omega_t} = \lambda_t .
$$

- **(F2) Real-money marginal condition**:

$$
\left(\frac{M_t}{P^A_t}\right)^{-\gamma} e^{\chi_t}
= \lambda_t
- \beta E_t\!\left[
\lambda_{t+1}\frac{P^A_t}{P^A_{t+1}}
\right].
$$

- **(F3) Capital Euler condition**:

$$
\lambda_t
= \beta(1-\delta)E_t\lambda_{t+1}
+ \alpha\beta E_t\!\left[
\xi_{t+1}A_{t+1}K_{t+1}^{\alpha-1}(N^d_{t+1})^{1-\alpha}
\right].
$$

- **(F4) Bond Euler condition**:

$$
\lambda_t = \beta E_t\!\left[\lambda_{t+1}(1+r_t)\right].
$$

- **(F5) Labor-demand condition**:

$$
\lambda_t\frac{W_t}{P^A_t}
= (1-\alpha)\xi_t A_tK_t^{\alpha}(N^d_t)^{-\alpha}.
$$

- **(F6) Optimizing IS relation, log-linearized**:

$$
y_t
= E_t y_{t+1}
- \sigma\frac{C^{ss}}{Y^{ss}}
\left(R_t-E_t\Delta p_{t+1}-\bar r\right)
+ \frac{C^{ss}}{Y^{ss}} v_t .
$$

The paper later replaces $E_t y_{t+1}$ with $E_{t-1}y_{t+1}$ in simulations to improve inflation variability. The Rep-MMB implementation uses the forward-looking implemented form:

$$
y_t
= y_{t+1}
- \sigma\frac{C^{ss}}{Y^{ss}}\left(R_t-\pi_{t+1}\right)
+ \frac{C^{ss}}{Y^{ss}} v_t .
$$

- **(F7) Money-demand relation, log-linearized**:

$$
m_t-p_t
= (\sigma\gamma)^{-1}\frac{Y^{ss}}{C^{ss}}y_t
- (\sigma\gamma)^{-1}\frac{I^{ss}}{C^{ss}}i_t
- (\gamma R^{ss})^{-1}(R_t-R^{ss})
+ \eta_t .
$$

The implemented linear model omits constants and writes this as:

$$
m_t-p_t
= \frac{1}{\sigma\gamma}\frac{Y^{ss}}{C^{ss}}
\left(y_t-\frac{I^{ss}}{Y^{ss}}i_t\right)
- \frac{1}{\gamma R^{ss}}R_t + \eta_t .
$$

- **(F8) Calvo-Rotemberg price-setting condition**:

$$
\Delta p_t
= \beta E_t\Delta p_{t+1}
+ \frac{\theta}{c_1}(y_t-\bar y_t).
$$

The Rep-MMB implementation maps this to:

$$
\pi_t = \beta \pi_{t+1} + \theta_{c1}\tilde y_t .
$$

## 4. Market Clearing & Identities

- **(F9) Inflation definition**:

$$
\pi_t = p_t-p_{t-1}.
$$

- **(F10) Output gap definition**:

$$
\tilde y_t = y_t-\bar y_t.
$$

- **(F11) Log-linear resource identity embedded in aggregate demand**:

$$
y_t \approx \frac{C^{ss}}{Y^{ss}}c_t+\frac{I^{ss}}{Y^{ss}}i_t .
$$

The explicit consumption variable is eliminated in the Rep-MMB implementation. The source paper fixes $C^{ss}/Y^{ss}=0.81$ and $I^{ss}/Y^{ss}=0.19$ for estimation and simulation.

- **(F12) Capacity-output measurement relation**:

$$
\tilde y_t = y_t-\bar y_t = (1-\alpha)(n_t-\bar n_t).
$$

With inelastic flexible-price labor, $\bar n_t$ is treated as constant.

- **(F13) Taylor-style policy rule used in the Rep-MMB cross-check**:

$$
R_t = \mu_1\pi_t+\mu_2\tilde y_t+\mu_3 R_{t-1}.
$$

The `.mod` file's active calibration sets $\mu_1=1.5$, $\mu_2=0$, and $\mu_3=0`; alternative rule lines are comments and are not treated as active equations.

## 5. Exogenous Processes

- **(F14) Investment process**:

$$
i_t = g_k+i_{t-1}+e_{it}.
$$

The implementation cross-check sets `gk = 0` and includes innovation `e_`; the paper estimates $g_k=0.0073$ for the general model.

- **(F15) Capacity-output process**:

$$
\bar y_t = \varsigma+\rho_{\bar y}\bar y_{t-1}+e_{yt}.
$$

The implementation cross-check sets `stigma = 0`, `rhoybar = 1`, and includes innovation `ey_`; the paper's estimation gives a random-walk capacity process with drift $0.0073$.

- **(F16) Preference-demand shock process**:

$$
v_t = \rho_v v_{t-1}+e_{vt}.
$$

- **(F17) Money-demand disturbance process**:

$$
\eta_t = \rho_{\eta}\eta_{t-1}+u_t .
$$

- **(F18) Correlated-demand-shock decomposition**:

$$
e_{vt}=\psi_u u_t+\varepsilon_{vt}.
$$

The paper reports near-zero residual correlation and sets $\psi_u=0$ for simulation. The Rep-MMB `.mod` implements independent innovations `ev_` and `u_`.

## 6. Steady-State Solution

The active archive object is linearized, so Dynare steady states for declared variables are zero unless a variable represents a level ratio or fixed parameter. The source paper's estimation fixes or implies the following levels/ratios before log-linearization:

1. Set $C^{ss}/Y^{ss}=0.81$, so $Y^{ss}/C^{ss}=1/0.81$.
2. Set $I^{ss}/Y^{ss}=0.19$.
3. Set $R^{ss}=0.014$ in quarterly fractional units.
4. Use estimated $\sigma=0.203$ in the Rep-MMB implementation.
5. Use the money-demand estimate $(\sigma\gamma)^{-1}=0.753$, which implies $\gamma \approx 1/(\sigma\cdot0.753)$. The Rep-MMB file stores this as `gam = 6.579`.
6. For the Calvo-Rotemberg slope, use $\beta=0.99$ and $\theta_{c1}=0.30$ in the implementation. The paper motivates $\theta/c_1=0.30$ for the Calvo-Rotemberg simulation variant.
7. Set exogenous innovations to zero in steady state: $e_{it}=e_{yt}=e_{vt}=u_t=\varepsilon_{vt}=0$.
8. For the linear state variables in the active `.mod`, use:

$$
\pi=p=y=R=v=m=i=\eta=\tilde y=\bar y=0 .
$$

Runtime validation status: `not_performed`. No `resid`, `steady`, `check`, or stochastic simulation was run.

## 7. Timing & Form Conventions

- **Form**: log-linear `model(linear)`. Lower-case variables are log-levels or log deviations; `R` is a quarterly fractional nominal interest-rate deviation in the implemented linear model.
- **Expectations**: the paper's structural IS and LM equations include $E_t y_{t+1}$ and $E_t\Delta p_{t+1}$; simulation discussion notes a modified timing using $E_{t-1}y_{t+1}$. The Rep-MMB implementation uses `y(+1)` and `pi(+1)`.
- **Inflation**: `pi` is defined as the price-level difference, $\pi_t=p_t-p_{t-1}$.
- **Stocks**: money balances are end-of-period in the household problem. Capital is present in the source household problem, but quarter-to-quarter capital dynamics are not used in the implemented aggregate demand system; investment follows an exogenous random walk.
- **Output gap**: $\tilde y_t=y_t-\bar y_t$; source measurement links it to hours relative to constant flexible-price labor.
- **Policy rule**: the active Rep-MMB rule is contemporaneous in inflation and output gap with optional lagged interest smoothing. The active calibration has no output-gap response and no smoothing.
- **Variants**: P-bar equations in the source are documented as a paper-side alternative but excluded from this implementation-specific derivation.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Determined by |
|---|---|---|---|
| Endogenous | `pi`, $\pi_t$ | Inflation, price-level difference | (F8), (F9) |
| Endogenous | `p`, $p_t$ | Log aggregate price level | (F9) |
| Endogenous | `y`, $y_t$ | Log output | (F6), (F7) |
| Endogenous | `R`, $R_t$ | Nominal interest rate | (F13) |
| Endogenous | `v`, $v_t$ | IS/preference disturbance | (F16) |
| Endogenous | `m`, $m_t$ | Log nominal money stock | (F7) |
| Endogenous | `i`, $i_t$ | Log investment | (F14) |
| Endogenous | `eta`, $\eta_t$ | Money-demand disturbance | (F17) |
| Endogenous | `ytilde`, $\tilde y_t$ | Output gap | (F10) |
| Endogenous | `ybar`, $\bar y_t$ | Capacity output | (F15) |
| Exogenous | `u_`, $u_t$ | Money-demand innovation | (F17) |
| Exogenous | `e_`, $e_{it}$ | Investment innovation | (F14) |
| Exogenous | `ey_`, $e_{yt}$ | Capacity-output innovation | (F15) |
| Exogenous | `ev_`, $e_{vt}$ | IS/preference innovation | (F16), (F18) |
| Parameter | `sigm`, $\sigma$ | Intertemporal elasticity parameter in IS and utility curvature notation | (F1), (F6), (F7) |
| Parameter | `CssYss` | $C^{ss}/Y^{ss}$ | (F6), (F11) |
| Parameter | `YssCss` | $Y^{ss}/C^{ss}$ | (F7) |
| Parameter | `gam`, $\gamma$ | Money-demand curvature / inverse interest-elasticity component | (F2), (F7) |
| Parameter | `IssYss` | $I^{ss}/Y^{ss}$ | (F7), (F11) |
| Parameter | `Rss` | Steady-state quarterly nominal interest rate | (F7) |
| Parameter | `rhov` | Persistence of $v_t$ | (F16) |
| Parameter | `rhoeta` | Persistence of $\eta_t$ | (F17) |
| Parameter | `gk` | Drift in investment process | (F14) |
| Parameter | `stigma` | Drift in capacity-output process | (F15) |
| Parameter | `rhoybar` | Persistence of capacity output | (F15) |
| Parameter | `bet` | Discount factor $\beta$ | (F3), (F4), (F8) |
| Parameter | `thetac1` | Calvo-Rotemberg slope $\theta/c_1$ | (F8) |
| Parameter | `mu1` | Inflation response in policy rule | (F13) |
| Parameter | `mu2` | Output-gap response in policy rule | (F13) |
| Parameter | `mu3` | Interest-rate smoothing in policy rule | (F13) |

First-pass status: `needs_review`. The equations above extract the paper's structural relations and the active Rep-MMB linear implementation, but the source PDF was not opened for targeted formula proofreading and the alternative P-bar variant remains documented only as an excluded variant.
