# US_RE09 - Derivation (Optimization Problems + First-Order Conditions)

> Status: needs_review. This is a first-pass archive extraction from MinerU Markdown and an implementation cross-check. Dynare runtime validation was not performed.

Provenance: `US_RE09`, Robert Reis (2009), "A sticky-information general-equilibrium model for policy analysis," NBER working paper/report, DOI `10.3386/w14732`. Primary Markdown source: `raw/mmb_mineru/runs/us_re09__a_sticky_information_general_equilibrium_model_for_policy_analysis__492aea55/full.md`. Raw PDF: `raw/mmb_papers/A sticky-information general-equilibrium model for policy analysis.pdf`. The primary Markdown first-page title is "Optimal Monetary Policy Rules in an Estimated Sticky-Information Model"; the MMB index maps it to the NBER sticky-information policy-analysis report. This version/title issue is recorded in `extraction_notes.md`.

## 1. Model Overview

- **Model**: Sticky-information general-equilibrium model (SIGE) for U.S. policy analysis.
- **Economy**: Closed-economy log-linear DSGE model with goods, labor, and savings markets.
- **Agents**: Households contain consumers and workers; firms produce differentiated goods; government introduces fiscal demand shocks; the central bank follows a Taylor-type interest-rate rule.
- **Key rigidities**: Sticky information is pervasive. Consumers update information with probability $\delta$, workers with probability $\omega$, and firms with probability $\lambda$.
- **Shocks**: Productivity growth, aggregate demand, goods markup, wage markup, and monetary policy shocks.
- **Form**: `model(linear)` / log-linear reduced-form system around the nonstochastic Pareto-optimum steady state. Variables such as $y_t$, $p_t$, $w_t$, $l_t$, $i_t$, and shocks are log levels, log deviations, or differences as defined in the paper-side reduced-form section.
- **Implementation cross-check**: `.agents/skills/dynare-copilot/references/examples/US_RE09_rep.mod` confirms the MMB replication uses a finite 16-lag approximation to the infinite sticky-information expectations sums. This `.mod` file was not used as a paper-side mathematical source.

## 2. Optimization Problems

### 2.1 Household: consumer-worker unit

The household has a consumer $j$ and worker $k$. The paper-side utility problem is:

$$
\max_{\{C_{t,j},L_{t,k},M_{t+1,j},W_{t,k}\}} E_t\sum_{s=0}^{\infty}\xi^s
\left[\log C_{t+s,j}
-\frac{\varkappa L_{t+s,k}^{1+1/\psi}}{1+1/\psi}\right].
$$

The budget constraint is:

$$
M_{t+1,j}
=\Pi_{t+1}\left[
M_{t,j}-C_{t,j}
+(1-\tau_w)\frac{W_{t,k}L_{t,k}}{P_t}
+T_{t,j}
\right].
$$

Consumption is a Dixit-Stiglitz aggregator over goods varieties with stochastic elasticity $\tilde{\nu}_t$:

$$
C_{t,j}
=\left(\int_0^1 C_{t,j}(i)^{\frac{\tilde{\nu}_t}{\tilde{\nu}_t-1}}\,di\right)^{\frac{\tilde{\nu}_t-1}{\tilde{\nu}_t}}.
$$

Labor supplied by worker $k$ faces a Dixit-Stiglitz demand schedule induced by firms' aggregation of differentiated labor services with stochastic elasticity $\tilde{\gamma}_t$.

### 2.2 Firms

Firm $i$ hires a composite labor input $N_{t,i}$ and produces:

$$
Y_{t,i}=A_t N_{t,i}^{\beta}.
$$

The firm chooses price $P_{t,i}$ under monopolistic competition. Its real profit expression is:

$$
\frac{(1-\tau_p)P_{t,i}Y_{t,i}-W_tN_{t,i}}{P_t}.
$$

Goods demand for variety $i$ is:

$$
Y_{t,i}
=\left(\frac{P_{t,i}}{P_t}\right)^{-\tilde{\nu}_t}
G_t\int_0^1 C_{t,j}\,dj.
$$

### 2.3 Government and Central Bank

Government purchases are wasteful and summarized by the aggregate demand shock $g_t$. Fiscal surpluses or deficits are rebated to households lump-sum.

The central bank targets the nominal interest rate according to a Taylor rule:

$$
i_t=\varphi_p\Delta p_t+\varphi_y(y_t-y_t^c)-\varepsilon_t.
$$

## 3. First-Order Conditions

The archive equations below are the reduced-form equilibrium conditions emphasized by the paper for the SIGE model. Numbering is continuous across Sections 3-5.

**(F1) Consumption Euler equation, flexible-information benchmark**:

$$
C_{t,j}^{-1/\theta}
=\xi E_t\left(\Pi_{t+1}C_{t+1,j}^{-1/\theta}\right).
$$

needs_review: The OCR/paper notation uses both $\theta$ and parameters later denoted $\vartheta$-style in prose; the implementation uses `theta` for the intertemporal elasticity term.

**(F2) Firm desired price / static pricing FOC**:

$$
p_t^{\ast}
=p_t+\frac{\beta(w_t-p_t)+(1-\beta)y_t-a_t}{\beta+\nu(1-\beta)}
-\frac{\beta\nu_t}{(\nu-1)[\beta+\nu(1-\beta)]}.
$$

**(F3) Household desired wage / labor-supply condition**:

$$
(\gamma+\psi)(w_t^{\ast}-p_t)
=\gamma(w_t-p_t)+l_t-\psi(y_t-g_t)
-\frac{\psi\gamma_t}{\gamma-1}.
$$

**(F4) Sticky-information Phillips curve**:

$$
p_t
=\lambda\sum_{i=0}^{\infty}(1-\lambda)^i E_{t-i}
\left[
p_t+\frac{\beta(w_t-p_t)+(1-\beta)y_t-a_t}{\beta+\nu(1-\beta)}
-\frac{\beta\nu_t}{(\nu-1)[\beta+\nu(1-\beta)]}
\right].
$$

**(F5) Long real interest-rate definition**:

$$
R_t=E_t\sum_{\tau=0}^{\infty}\left(i_{t+\tau}-\Delta p_{t+1+\tau}\right).
$$

**(F6) Sticky-information IS curve**:

$$
y_t
=\delta\sum_{j=0}^{\infty}(1-\delta)^j E_{t-j}\left(y_\infty^c-R_t\right)
+g_t.
$$

needs_review: The OCR source line for the superscript in $y_\infty^c$ appears once as $y_\infty^n$ in the rendered equation; surrounding text defines the wealth measure as $y_\infty^c$. The derivation keeps $c$ and records this as a formula issue.

**(F7) Sticky-information wage curve**:

$$
w_t
=\omega\sum_{k=0}^{\infty}(1-\omega)^k E_{t-k}
\left[
p_t+\frac{\gamma(w_t-p_t)}{\gamma+\psi}
+\frac{l_t}{\gamma+\psi}
+\frac{\psi(y_\infty^c-R_t)}{\gamma+\psi}
-\frac{\psi\gamma_t}{(\gamma+\psi)(\gamma-1)}
\right].
$$

## 4. Market Clearing & Identities

**(F8) Aggregate production function**:

$$
y_t=a_t+\beta l_t.
$$

**(F9) Classical output**:

$$
y_t^c
=a_t+\Xi\left[g_t+\frac{\gamma_t}{\gamma-1}+\frac{\nu_t}{\nu-1}\right],
\qquad
\Xi=\frac{\beta\psi}{1+\psi}.
$$

**(F10) Classical labor**:

$$
l_t^c=\frac{y_t^c-a_t}{\beta}.
$$

**(F11) Classical real wage**:

$$
(w_t-p_t)^c
=y_t^c-l_t^c+\frac{\nu_t}{\nu-1}.
$$

**(F12) Classical inflation path**:

$$
\Delta p_t^c
=\sum_{j=0}^{\infty}\varphi_p^{-j-1}
E_t\left(\Delta y_{t+1+j}^c-\Delta g_{t+1+j}+\varepsilon_{t+j}\right).
$$

**(F13) Inflation definition**:

$$
\pi_t=p_t-p_{t-1}.
$$

**(F14) Output gap definition**:

$$
\text{outputgap}_t=y_t-y_t^c.
$$

## 5. Exogenous Processes

**(F15) Monetary policy rule**:

$$
i_t=\varphi_p\Delta p_t+\varphi_y(y_t-y_t^c)-\varepsilon_t.
$$

**(F16) Monetary policy shock**:

$$
\varepsilon_t=\rho_\varepsilon\varepsilon_{t-1}+e_{\varepsilon,t}.
$$

**(F17) Productivity growth shock**:

$$
\Delta a_t=\rho_{\Delta a}\Delta a_{t-1}+e_{\Delta a,t}.
$$

**(F18) Aggregate demand shock**:

$$
g_t=\rho_g g_{t-1}+e_{g,t}.
$$

**(F19) Goods-markup shock**:

$$
\nu_t=\rho_\nu\nu_{t-1}+e_{\nu,t}.
$$

**(F20) Wage-markup shock**:

$$
\gamma_t=\rho_\gamma\gamma_{t-1}+e_{\gamma,t}.
$$

## 6. Steady-State Solution

The model is expressed as a log-linear reduced-form system around the nonstochastic Pareto-optimum steady state. For the derivation archive:

- Steady-state deviations are zero for log-linear variables: $\bar{a}=\bar{g}=\bar{\nu}=\bar{\gamma}=\bar{\varepsilon}=0$ and $\Delta\bar{a}=0$.
- The price level normalization is $p_{-1}=0$ in the reduced-form discussion; the implementation cross-check uses $p_t$ as the log price level and $\pi_t=p_t-p_{t-1}$.
- The long real rate satisfies $\bar{R}=0$ in deviation form.
- Classical output and labor deviations satisfy $\bar{y}^c=\bar{l}^c=0$ when shocks are at zero.
- With sticky information and zero shocks, the expectations sums in (F4), (F6), and (F7) collapse to the same zero-deviation steady state.

needs_review: The paper emphasizes reduced-form log-linear dynamics rather than a nonlinear steady-state block. No `steady_state_model` equivalent was source-level checked, and runtime validation was not performed.

## 7. Timing & Form Conventions

- **Form**: `model(linear)` in the MMB replication; paper-side equations are log-linearized around a nonstochastic Pareto-optimum steady state.
- **Information timing**: Sticky-information expectations use dated expectations $E_{t-i}$, $E_{t-j}$, and $E_{t-k}$ over plans chosen by agents whose information was last updated in earlier periods.
- **Finite-lag approximation**: The paper states infinite sums for sticky-information price, consumption/output, and wage equations. The MMB `.mod` implementation truncates the sums at 16 lagged information sets as `implementation_cross_check`.
- **Price timing**: Inflation is $\Delta p_t=p_t-p_{t-1}$; the Taylor rule responds to contemporaneous inflation and the output gap.
- **Long-rate timing**: $R_t$ is forward-looking and sums expected future nominal rates less future inflation.
- **Stocks/capital**: There is no capital stock in this model; production uses labor with decreasing returns.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Equation source |
|---|---:|---|---|
| Endogenous | `y`, $y_t$ | Output | (F6), (F8) |
| Endogenous | `a`, $a_t$ | Productivity level | (F8), (F17) |
| Endogenous | `l`, $l_t$ | Hours/labor | (F7), (F8) |
| Endogenous | `p`, $p_t$ | Log price level | (F4), (F13) |
| Endogenous | `w`, $w_t$ | Log nominal wage | (F7) |
| Endogenous | `i`, $i_t$ | Nominal interest rate | (F15) |
| Endogenous | `R`, $R_t$ | Long real interest rate | (F5), (F6), (F7) |
| Endogenous | `pi`, $\pi_t$ | Inflation / price-level change | (F13) |
| Endogenous | `outputgap` | Output gap | (F14) |
| Endogenous | `yclas`, $y_t^c$ | Classical output | (F9) |
| Endogenous | `yinfn`, $y_\infty^c$ | Long-run/classical wealth measure | (F6), (F7) |
| Endogenous | `deltaa`, $\Delta a_t$ | Productivity growth | (F17) |
| Endogenous | `g`, $g_t$ | Aggregate demand shock state | (F18) |
| Endogenous | `nuu`, $\nu_t$ | Goods-markup shock state | (F19) |
| Endogenous | `gam`, $\gamma_t$ | Wage-markup shock state | (F20) |
| Endogenous | `eps`, $\varepsilon_t$ | Monetary policy shock state | (F16) |
| Auxiliary | `z` | Finite-lag sticky-price target in `.mod` | implementation_cross_check for (F4) |
| Auxiliary | `zwage` | Finite-lag sticky-wage target in `.mod` | implementation_cross_check for (F7) |
| Auxiliary | `zoutput` | Finite-lag sticky-output target in `.mod` | implementation_cross_check for (F6) |
| Exogenous | `e_deltaa` | Productivity-growth innovation | (F17) |
| Exogenous | `e_g` | Aggregate-demand innovation | (F18) |
| Exogenous | `e_nuu` | Goods-markup innovation | (F19) |
| Exogenous | `e_gam` | Wage-markup innovation | (F20) |
| Exogenous | `e_eps` | Monetary-policy innovation | (F16) |
| Parameter | `beta`, $\beta$ | Labor share / production curvature in paper notation | (F8) |
| Parameter | `psi`, $\psi$ | Frisch elasticity / labor-supply term | (F3), (F7), (F9) |
| Parameter | `nu`, $\nu$ | Steady-state goods elasticity | (F2), (F4), (F9), (F11) |
| Parameter | `gamma`, $\gamma$ | Steady-state labor elasticity | (F3), (F7), (F9) |
| Parameter | `theta` | Intertemporal substitution/rate-sensitivity parameter in implementation | (F1), (F6), (F7) |
| Parameter | `delta`, $\delta$ | Consumer information updating probability | (F6) |
| Parameter | `omega`, $\omega$ | Worker information updating probability | (F7) |
| Parameter | `lambda`, $\lambda$ | Firm information updating probability | (F4) |
| Parameter | `phi_pi`, $\varphi_p$ | Taylor-rule inflation response | (F15) |
| Parameter | `phi_y`, $\varphi_y$ | Taylor-rule output-gap response | (F15) |
| Parameter | `rho_deltaa` | Productivity-growth persistence | (F17) |
| Parameter | `rho_eps` | Monetary-policy shock persistence | (F16) |
| Parameter | `rho_g` | Aggregate-demand shock persistence | (F18) |
| Parameter | `rho_nuu` | Goods-markup shock persistence | (F19) |
| Parameter | `rho_gam` | Wage-markup shock persistence | (F20) |
| Parameter | `T` | Finite lag count in MMB implementation | implementation_cross_check |

Equation count: 20 numbered conditions are documented. The `.mod` implementation cross-check has 19 endogenous variables because it combines infinite-sum targets into finite-lag auxiliary equations and adds implementation-specific auxiliary variables; this mismatch is deferred for review rather than treated as runtime validation.
