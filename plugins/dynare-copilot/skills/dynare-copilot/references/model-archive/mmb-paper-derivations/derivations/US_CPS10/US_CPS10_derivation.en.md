# US_CPS10 - Derivation (optimization problems and linear equilibrium system)

> Archive status: needs_review. Runtime validation was not performed. The paper-side source prints the structural primitives and estimation targets; the full Rep-MMB `model(linear)` equations are cross-checked against `.agents/skills/dynare-copilot/references/examples/US_CPS10_rep.mod` as implementation evidence only.

## 1. Model Overview

- **Model**: Cogley, Primiceri, and Sargent (2010), "Inflation-gap persistence in the US," AEJ: Macroeconomics, DOI `10.1257/mac.2.1.43`.
- **MMB ID**: `US_CPS10`.
- **Purpose**: a simple estimated New-Keynesian model used to interpret changes in US inflation-gap volatility and predictability across the 1960:Q1-1979:Q3 and 1982:Q4-2006:Q4 subsamples.
- **Agents**: a representative household, a continuum of monopolistically competitive firms, and a monetary/fiscal authority.
- **Key mechanisms**: internal habit formation, Calvo price stickiness, steady-state inflation indexation for non-reoptimizing firms, stochastic technology growth, preference, desired-markup, monetary-policy, and inflation-target shocks.
- **Form**: log-linear `model(linear)` around a nonstochastic steady state after scaling consumption, output, and real wages by the unit-root technology process. The paper states this solution approach but does not print all reduced log-linear equations; the MMB implementation supplies the cross-check system.

## 2. Optimization Problems

### 2.1 Representative Household

The household chooses differentiated consumption, labor supplies, and bond holdings to maximize expected discounted utility with internal habit:

$$
E_t \sum_{s=0}^{\infty}\delta^s b_{t+s}
\left[
\log(C_{t+s}-h C_{t+s-1})
-\varphi\int_0^1 \frac{L_{t+s}(i)^{1+\nu}}{1+\nu}\,di
\right].
$$

The nominal budget constraint is:

$$
\int_0^1 P_t(i) C_t(i)\,di + B_t + T_t
\le R_{t-1} B_{t-1} + \Pi_t + \int_0^1 W_t(i)L_t(i)\,di.
$$

Differentiated consumption is aggregated by:

$$
C_t =
\left[\int_0^1 C_t(i)^{1/(1+\theta_t)}\,di\right]^{1+\theta_t}.
$$

Here `needs_review`: the paper uses $\delta$ for the discount factor, while the Rep-MMB file uses `betta = 100/(Fbeta+100)` with `Fbeta` denoting the estimated annualized percentage discount-rate parameter.

### 2.2 Firms

Each monopolistically competitive firm produces one differentiated good with linear labor technology:

$$
Y_t(i)=A_t L_t(i).
$$

With Calvo probability $\xi$, a firm cannot reoptimize and indexes its price to the steady-state gross inflation rate $\pi$. A reoptimizing firm chooses $\tilde P_t(i)$ to maximize:

$$
E_t \sum_{s=0}^{\infty}\xi^s\delta^s\lambda_{t+s}
\left\{
\tilde P_t(i)\pi^s Y_{t+s}(i)-W_{t+s}(i)L_{t+s}(i)
\right\}.
$$

The desired-markup shock $\theta_t$ enters the elasticity embedded in the Dixit-Stiglitz aggregator and therefore the New-Keynesian Phillips curve slope and cost-push term.

### 2.3 Government and Monetary Authority

Fiscal policy closes through lump-sum taxes/transfers and bond supply. The monetary authority sets the gross nominal short rate by a smoothed Taylor rule:

$$
\frac{R_t}{R} =
\left(\frac{R_{t-1}}{R}\right)^{\rho_R}
\left[
\left(\frac{\bar\pi_{4,t}}{(\pi_t^*)^4}\right)^{\varphi_\pi/4}
\left(\frac{Y_t}{Y_t^*}\right)^{\varphi_Y}
\right]^{1-\rho_R}
e^{\varepsilon_{R,t}}.
$$

The rule responds to annual inflation relative to the time-varying inflation target and to the output gap relative to flexible-price output.

## 3. First-Order Conditions

The paper's primitives imply the usual consumption Euler equation, labor supply condition, flexible-price benchmark, and Calvo pricing condition. The following log-linear equilibrium system is the Rep-MMB implementation cross-check. Variables are deviations or transformed objects as in the `.mod` file; all equations in this subsection are `needs_review` as paper-to-implementation transformations because the paper does not print them as a complete block.

- **(F1) New-Keynesian Phillips curve for inflation-gap inflation `p`**:

$$
p_t-\frac{\beta}{1+\iota_p\beta}p_{t+1}-\lambda^p_t
-\frac{(1-\beta\xi_p)(1-\xi_p)}
{(1+\iota_p\beta)\xi_p\left[1+\nu(1+1/\bar\lambda^p)\right]}w_t
=\frac{\iota_p}{1+\iota_p\beta}p_{t-1}.
$$

- **(F2) Flexible-price real wage gap normalization**:

$$
w^*_t=0.
$$

- **(F3) Marginal utility and output with habit**:

$$
(g-h\beta)(g-h)\lambda_t
-(g-h\beta\rho_b)(g-h)b_t
-(\beta h g\rho_z-hg)z_t
(g^2+\beta h^2)y_t
-\beta hg\,y_{t+1}
=gh\,y_{t-1}.
$$

- **(F4) Flexible-price counterpart of marginal utility and output**:

$$
(g-h\beta)(g-h)\lambda^*_t
-(g-h\beta\rho_b)(g-h)b_t
-(\beta h g\rho_z-hg)z_t
(g^2+\beta h^2)y^*_t
-\beta hg\,y^*_{t+1}
=gh\,y^*_{t-1}.
$$

- **(F5) Euler equation**:

$$
\lambda_t-R_t-\lambda_{t+1}+p_{t+1}+\rho_z z_t=0.
$$

- **(F6) Flexible-price Euler equation**:

$$
\lambda^*_t-R^*_t-\lambda^*_{t+1}+\rho_z z_t=0.
$$

- **(F7) Labor supply / real wage relation**:

$$
w_t-b_t-\nu y_t+\lambda_t=0.
$$

- **(F8) Flexible-price labor supply / real wage relation**:

$$
w^*_t-b_t-\nu y^*_t+\lambda^*_t=0.
$$

## 4. Market Clearing & Identities

- **(F9) Monetary policy rule**:

$$
R_t-(1-\rho_R)\frac{\varphi_\pi}{4}p_t
+(1-\rho_R)\varphi_\pi\pi^*_t
-(1-\rho_R)\varphi_y y_t
+(1-\rho_R)\varphi_y y^*_t
=\rho_R R_{t-1}
+(1-\rho_R)\frac{\varphi_\pi}{4}(p_{t-1}+p_{t-2}+p_{t-3})
+\varepsilon_{R,t}.
$$

- **(F10) Inflation gap definition**:

$$
\text{inflgap}_t=p_t-\pi^*_t.
$$

- **(F11) Ex-post real interest rate definition**:

$$
\text{realR}_t=R_t-p_t.
$$

- **(F12) Output gap definition**:

$$
\text{outpgap}_t=y_t-y^*_t.
$$

## 5. Exogenous Processes

- **(F13) Technology-growth shock**:

$$
z_t=\rho_z z_{t-1}+\varepsilon_{z,t}.
$$

- **(F14) Desired-markup shock**:

$$
\lambda^p_t=\rho_{\lambda^p}\lambda^p_{t-1}+\varepsilon_{\lambda^p,t}.
$$

- **(F15) Inflation-target process**:

$$
\pi^*_t=\rho_{\pi^*}\pi^*_{t-1}+\varepsilon_{\pi^*,t}.
$$

Paper OCR note: equation (21) in the MinerU Markdown repeats $\log\pi_t^*$ on both sides; the intended persistent target process uses the lagged target, matching the Rep-MMB implementation and the surrounding paper discussion. This normalization is marked `needs_review`.

- **(F16) Preference shock**:

$$
b_t=\rho_b b_{t-1}+\varepsilon_{b,t}.
$$

## 6. Steady-State Solution

Because the archive target is the Rep-MMB linear implementation, the steady state of all model variables in the `model(linear)` block is zero:

$$
\bar p=\bar y=\bar\lambda=\bar w=\bar R=\bar z=\bar\lambda^p=\bar\pi^*
=\bar b=\bar y^*=\bar\lambda^*=\bar w^*=\bar R^*
=\overline{\text{inflgap}}=\overline{\text{realR}}=\overline{\text{outpgap}}=0.
$$

The nonstochastic levels behind the log-linearization are pinned down by:

$$
g=e^\gamma,\qquad
\beta=\frac{100}{100+F_\beta},\qquad
r^{ss}=e^\gamma/\beta-1,\qquad
100r^{ss}=100\,r^{ss}.
$$

The MMB calibration uses `gamma100/100` for $\gamma$ and `pss100/100` for the quarterly gross inflation steady-state deviation measure. The paper estimates the model on two subsamples; the Rep-MMB file activates the 1960-1979 posterior medians by default and leaves the 1982-2006 and counterfactual values commented.

## 7. Timing & Form Conventions

- **Timing**: forward-looking variables appear as $p_{t+1}$, $y_{t+1}$, $\lambda_{t+1}$, and flexible-price counterparts. The policy rule contains $R_{t-1}$ and four-quarter inflation terms $p_t,p_{t-1},p_{t-2},p_{t-3}$.
- **Stock variables**: the paper's DSGE section has no capital stock. Bonds enter the household budget, but the log-linear MMB implementation has no explicit bond-state equation.
- **Trend scaling**: because technology has a unit root, consumption, output, and real wages are scaled by technology before log-linearization.
- **Inflation target**: the target is highly persistent, with $\rho_{\pi^*}=0.995$ in the baseline.
- **Runtime validation**: not performed; Dynare was not run.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII name | Meaning | Equation |
|---|---|---|---|
| Endogenous | `p` | Inflation-gap inflation term used in the Phillips curve | (F1), (F9) |
| Endogenous | `y` | Output, technology-scaled/log-linear | (F3), (F7), (F9) |
| Endogenous | `lambdda` | Marginal utility of consumption | (F3), (F5), (F7) |
| Endogenous | `w` | Real wage | (F1), (F7) |
| Endogenous | `R` | Nominal policy rate deviation | (F5), (F9) |
| Endogenous | `z` | Technology growth state | (F13) |
| Endogenous | `lambddap` | Desired-markup/cost-push shock | (F1), (F14) |
| Endogenous | `pit` | Inflation target | (F9), (F10), (F15) |
| Endogenous | `b` | Preference shock | (F3), (F4), (F7), (F8), (F16) |
| Endogenous | `ystar` | Flexible-price output | (F4), (F8), (F9), (F12) |
| Endogenous | `lambddastar` | Flexible-price marginal utility | (F4), (F6), (F8) |
| Endogenous | `wstar` | Flexible-price real wage | (F2), (F8) |
| Endogenous | `Rstar` | Flexible-price nominal/real-rate counterpart | (F6) |
| Endogenous | `inflgap` | Inflation gap | (F10) |
| Endogenous | `realR` | Ex-post real interest rate | (F11) |
| Endogenous | `outpgap` | Output gap | (F12) |
| Exogenous shock | `Rs` | Monetary-policy innovation $\varepsilon_{R,t}$ | (F9) |
| Exogenous shock | `zs` | Technology-growth innovation $\varepsilon_{z,t}$ | (F13) |
| Exogenous shock | `lambddaps` | Desired-markup innovation $\varepsilon_{\lambda^p,t}$ | (F14) |
| Exogenous shock | `pits` | Inflation-target innovation $\varepsilon_{\pi^*,t}$ | (F15) |
| Exogenous shock | `bs` | Preference innovation $\varepsilon_{b,t}$ | (F16) |
| Parameter | `niu` / $\nu$ | Inverse Frisch elasticity; calibrated at 2 | - |
| Parameter | `lambddapss` / $\bar\lambda^p$ | Steady-state markup parameter; calibrated at 0.1 | - |
| Parameter | `iotap` / $\iota_p$ | Price-indexation coefficient in implemented Phillips curve; default 0 | - |
| Parameter | `rhopit` / $\rho_{\pi^*}$ | Inflation-target persistence; baseline 0.995 | (F15) |
| Parameter | `gamma100`, `gamma` | Technology growth estimate and quarterly value | - |
| Parameter | `pss100` | Steady-state inflation estimate | - |
| Parameter | `Fbeta`, `betta` | Discount-rate estimate and discount factor | (F1), (F3)-(F6) |
| Parameter | `hparam` | Internal habit parameter $h$ | (F3), (F4) |
| Parameter | `xip` / $\xi_p$ | Calvo price stickiness | (F1) |
| Parameter | `fp`, `fy`, `rhoR` | Taylor-rule coefficients $\varphi_\pi,\varphi_y,\rho_R$ | (F9) |
| Parameter | `rhoz`, `rholambddap`, `rhob` | Shock persistence parameters | (F13), (F14), (F16) |
| Parameter | `sdr`, `sdz`, `sdlambddap`, `sdpit`, `sdb` | Shock standard deviations | shocks block |
| Parameter | `rss`, `rss100`, `expg` | Steady-state rate and growth transformations | steady state |
