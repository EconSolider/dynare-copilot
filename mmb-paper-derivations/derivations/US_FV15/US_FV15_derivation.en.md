# US_FV15 - Derivation (Business Cycle Model with Stochastic Volatility)

> Model archive entry for `US_FV15`. Status: `needs_review`. Runtime validation was not performed; Dynare was not run.

## 1. Model Overview

- **Model**: Fernandez-Villaverde, Guerron-Quintana, and Rubio-Ramirez (2015), "Estimating dynamic equilibrium models with stochastic volatility."
- **Model ID**: `US_FV15`.
- **Source**: `raw/mmb_mineru/runs/us_fv15__estimating_dynamic_equilibrium_models_with_stochastic_volatility__ae6b2e5b/full.md`; DOI `10.1016/j.jeconom.2014.08.010`.
- **Purpose**: Estimate a medium-size US business cycle economy with stochastic volatility in structural shocks and drifting monetary-policy coefficients.
- **Agents/blocks**: Households with habits, money-in-utility, capital utilization, investment adjustment costs, differentiated labor and Calvo wage setting; final-good and intermediate-good firms with Calvo price setting; monetary authority with a Taylor rule, stochastic policy shock volatility, and drifting inflation/output responses.
- **Shocks**: Preference, labor-disutility, investment-specific technology, neutral technology, and monetary policy shocks have time-varying volatilities. Policy-rule response coefficients also drift as structural shocks with fixed innovation variances.
- **Form**: Nonlinear stationary-rescaled DSGE model solved in the paper by second-order approximation. The Rep-MMB implementation solves a first-order Dynare representation, but that implementation is used here only as `implementation_cross_check`.

## 2. Optimization Problems

### 2.1 Households

Household \(j\) chooses consumption \(c_{jt}\), money balances \(m_{jt}/p_t\), bond holdings, investment \(x_{jt}\), capital \(k_{jt}\), utilization \(u_{jt}\), and wage-setting decisions to maximize:

\[
E_0\sum_{t=0}^{\infty}\beta^t d_t
\left[
\log(c_{jt}-h c_{j,t-1})
+\nu\log\left(\frac{m_{jt}}{p_t}\right)
-\varphi_t\psi\frac{l_{jt}^{1+\vartheta}}{1+\vartheta}
\right].
\]

The nominal bond/money budget constraint is:

\[
c_{jt}+x_{jt}+\frac{m_{jt}}{p_t}+\frac{b_{j,t+1}}{p_t}
= w_{jt}l_{jt}
+\left(r_tu_{jt}-\mu_t^{-1}\Phi(u_{jt})\right)k_{j,t-1}
+\frac{m_{j,t-1}}{p_t}
+R_{t-1}\frac{b_{jt}}{p_t}
+T_t+F_t.
\]

Capital evolves as:

\[
k_{jt}=(1-\delta)k_{j,t-1}
+\mu_t\left[
1-\frac{\kappa}{2}\left(\frac{x_{jt}}{x_{j,t-1}}-\Lambda_x\right)^2
\right]x_{jt}.
\]

The utilization cost function is quadratic around \(u=1\) on the balanced growth path. The OCR text around this function is garbled; normalized formulas involving \(\Phi(u)\) are marked `needs_review`.

Households supply differentiated labor. A competitive labor packer forms aggregate labor demand:

\[
l_t^d=\left(\int_0^1 l_{jt}^{\frac{\eta-1}{\eta}}dj\right)^{\frac{\eta}{\eta-1}},
\]

and households reset wages with Calvo probability \(1-\theta_w\) while non-reset wages are indexed to past inflation with parameter \(\chi_w\).

### 2.2 Firms

A competitive final-good producer aggregates intermediate goods:

\[
y_t=\left(\int_0^1 y_{it}^{\frac{\varepsilon-1}{\varepsilon}}di\right)^{\frac{\varepsilon}{\varepsilon-1}}.
\]

Intermediate-good firm \(i\) produces:

\[
y_{it}=A_t k_{i,t-1}^{\alpha}(l^d_{it})^{1-\alpha},
\]

rents capital and packed labor at \(r_t\) and \(w_t\), and sets prices under Calvo rigidity with reset probability \(1-\theta_p\) and indexation \(\chi\) for non-reset prices.

### 2.3 Monetary Authority

The monetary authority sets the nominal gross rate according to:

\[
\frac{R_t}{R}
=\left(\frac{R_{t-1}}{R}\right)^{\gamma_R}
\left[
\left(\frac{\Pi_t}{\Pi}\right)^{\gamma_{\Pi}\gamma_{\Pi t}}
\left(
\frac{y_t^d/y_{t-1}^d}{\exp(\Lambda_{y^d})}
\right)^{\gamma_y\gamma_{yt}}
\right]^{1-\gamma_R}\xi_t.
\]

The policy shock \(\xi_t\) has stochastic volatility, and \(\gamma_{\Pi t}\) and \(\gamma_{yt}\) drift over time.

## 3. First-Order Conditions

The paper states the household and firm problems but refers the full stationary equilibrium system to the appendix. The numbered equations below are a first-pass normalized equilibrium inventory from the paper-side model description, with implementation coverage checked against `.agents/skills/dynare-copilot/references/examples/US_FV15_rep.mod`. Conditions depending on appendix-only algebra remain `needs_review`.

- **(F1) Marginal utility with habits**:

\[
\lambda_t
=d_t(c_t-hc_{t-1}\mu_{z,t}^{-1})^{-1}
-h\beta E_t\left[d_{t+1}(c_{t+1}\mu_{z,t+1}-hc_t)^{-1}\right].
\]

- **(F2) Bond Euler equation**:

\[
\lambda_t
=\beta E_t\left[
\lambda_{t+1}\mu_{z,t+1}^{-1}\frac{R_t}{\Pi_{t+1}}
\right].
\]

- **(F3) Utilization FOC** (`needs_review` from OCR normalization):

\[
r_t=\Phi'(u_t), \qquad
\Phi'(u_t)=\phi_1+\phi_2(u_t-1).
\]

- **(F4) Capital Euler equation**:

\[
q_t=\beta E_t\left[
\frac{\lambda_{t+1}}{\lambda_t}\mu_{z,t+1}^{-1}\mu_{I,t+1}^{-1}
\left((1-\delta)q_{t+1}+r_{t+1}u_{t+1}-\Phi(u_{t+1})\right)
\right].
\]

- **(F5) Investment-adjustment FOC**:

\[
1=q_t\left[
1-\frac{\kappa}{2}\left(\frac{x_t}{x_{t-1}}\mu_{z,t}-\Lambda_x\right)^2
-\kappa\left(\frac{x_t}{x_{t-1}}\mu_{z,t}-\Lambda_x\right)\frac{x_t}{x_{t-1}}\mu_{z,t}
\right]
\]

\[
+\beta E_t\left[
q_{t+1}\frac{\lambda_{t+1}}{\lambda_t}\mu_{z,t+1}^{-1}
\kappa\left(\frac{x_{t+1}}{x_t}\mu_{z,t+1}-\Lambda_x\right)
\left(\frac{x_{t+1}}{x_t}\mu_{z,t+1}\right)^2
\right].
\]

- **(F6) Wage-setting recursion, marginal-benefit side** (`needs_review`, appendix algebra not in local normalization):

\[
f_t=\frac{\eta-1}{\eta}w_t^{\ast\,1-\eta}\lambda_t w_t^\eta l_t^d
+\beta\theta_w E_t\left[
\left(\frac{\Pi_t^{\chi_w}}{\Pi_{t+1}}\right)^{1-\eta}
\left(\frac{w^{\ast}_{t+1}}{w^{\ast}_t}\mu_{z,t+1}\right)^{\eta-1}
f_{t+1}
\right].
\]

- **(F7) Wage-setting recursion, marginal-cost side** (`needs_review`):

\[
f_t=\psi d_t\varphi_t(\Pi^{\ast}_{w,t})^{-\eta(1+\vartheta)}(l_t^d)^{1+\vartheta}
+\beta\theta_w E_t\left[
\left(\frac{\Pi_t^{\chi_w}}{\Pi_{t+1}}\right)^{-\eta(1+\vartheta)}
\left(\frac{w^{\ast}_{t+1}}{w^{\ast}_t}\mu_{z,t+1}\right)^{\eta(1+\vartheta)}
f_{t+1}
\right].
\]

- **(F8) Price-setting recursion \(g_1\)**:

\[
g_{1t}=\lambda_t mc_t y_t^d
+\beta\theta_p E_t\left[
\left(\frac{\Pi_t^{\chi}}{\Pi_{t+1}}\right)^{-\varepsilon}g_{1,t+1}
\right].
\]

- **(F9) Price-setting recursion \(g_2\)**:

\[
g_{2t}=\lambda_t\Pi^{\ast}_t y_t^d
+\beta\theta_p E_t\left[
\left(\frac{\Pi_t^{\chi}}{\Pi_{t+1}}\right)^{1-\varepsilon}
\frac{\Pi^{\ast}_t}{\Pi^{\ast}_{t+1}}g_{2,t+1}
\right].
\]

- **(F10) Optimal reset price condition**:

\[
\varepsilon g_{1t}=(\varepsilon-1)g_{2t}.
\]

- **(F11) Cost-minimizing input ratio**:

\[
\frac{u_t k_{t-1}}{l_t^d}
=\frac{\alpha}{1-\alpha}\frac{w_t}{r_t}\mu_{z,t}\mu_{I,t}.
\]

- **(F12) Real marginal cost**:

\[
mc_t=\left(\frac{1}{1-\alpha}\right)^{1-\alpha}
\left(\frac{1}{\alpha}\right)^{\alpha}
w_t^{1-\alpha}r_t^{\alpha}.
\]

- **(F13) Wage-index law of motion**:

\[
1=\theta_w\left(\frac{\Pi_{t-1}^{\chi_w}}{\Pi_t}\right)^{1-\eta}
\left(\frac{w_{t-1}}{w_t}\mu_{z,t}^{-1}\right)^{1-\eta}
+(1-\theta_w)(\Pi^{\ast}_{w,t})^{1-\eta}.
\]

- **(F14) Price-index law of motion**:

\[
1=\theta_p\left(\frac{\Pi_{t-1}^{\chi}}{\Pi_t}\right)^{1-\varepsilon}
+(1-\theta_p)(\Pi^{\ast}_t)^{1-\varepsilon}.
\]

- **(F15) Taylor rule with drifting coefficients**:

\[
\frac{R_t}{R}
=\left(\frac{R_{t-1}}{R}\right)^{\gamma_R}
\left[
\left(\frac{\Pi_t}{\Pi}\right)^{\gamma_{\Pi}\gamma_{\Pi t}}
\left(\frac{(y_t^d/y_{t-1}^d)\mu_{z,t}}{\exp(\Lambda_{y^d})}\right)^{\gamma_y\gamma_{yt}}
\right]^{1-\gamma_R}
\exp(\varepsilon_{\xi t})^{\sigma_{\xi}\sigma_{\xi t}}.
\]

## 4. Market Clearing & Identities

- **(F16) Aggregate demand / resource constraint**:

\[
y_t^d=c_t+x_t
+\mu_{z,t}^{-1}\mu_{I,t}^{-1}\Phi(u_t)k_{t-1}.
\]

- **(F17) Aggregate production with price dispersion**:

\[
y_t^d=\frac{\mu_{A,t}\mu_{z,t}^{-1}(u_tk_{t-1})^{\alpha}(l_t^d)^{1-\alpha}-\Phi}{v^p_t}.
\]

- **(F18) Labor aggregation with wage dispersion**:

\[
l_t=v^w_t l_t^d.
\]

- **(F19) Price dispersion**:

\[
v^p_t=\theta_p\left(\frac{\Pi_{t-1}^{\chi}}{\Pi_t}\right)^{-\varepsilon}v^p_{t-1}
+(1-\theta_p)(\Pi^{\ast}_t)^{-\varepsilon}.
\]

- **(F20) Wage dispersion**:

\[
v^w_t=\theta_w\left(\frac{w_{t-1}}{w_t}\mu_{z,t}^{-1}
\frac{\Pi_{t-1}^{\chi_w}}{\Pi_t}\right)^{-\eta}v^w_{t-1}
+(1-\theta_w)(\Pi^{\ast}_{w,t})^{-\eta}.
\]

- **(F21) Capital accumulation in stationary variables**:

\[
k_{t+1}\mu_{z,t}\mu_{I,t}
=(1-\delta)k_t
+\mu_{z,t}\mu_{I,t}
\left[
1-\frac{\kappa}{2}\left(\frac{x_t}{x_{t-1}}\mu_{z,t}-\Lambda_x\right)^2
\right]x_t.
\]

- **(F22) Firm profits**:

\[
F_t=y_t^d-\frac{1}{1-\alpha}w_tl_t^d.
\]

- **(F23) Optimal wage inflation definition**:

\[
\Pi^{\ast}_{w,t}=\frac{w^{\ast}_t}{w_t}.
\]

## 5. Exogenous Processes

- **(F24) Intertemporal preference shock**:

\[
\log d_t=\rho_d\log d_{t-1}+\sigma_d\sigma_{dt}\varepsilon_{dt}.
\]

- **(F25) Labor-disutility shock**:

\[
\log\varphi_t=\rho_{\varphi}\log\varphi_{t-1}
+\sigma_{\varphi}\sigma_{\varphi t}\varepsilon_{\varphi t}.
\]

- **(F26) Investment-specific technology growth**:

\[
\log\mu_{I,t}=\Lambda_{\mu}+\sigma_{\mu}\sigma_{\mu t}\varepsilon_{\mu t}.
\]

- **(F27) Neutral technology growth**:

\[
\log\mu_{A,t}=\Lambda_A+\sigma_A\sigma_{At}\varepsilon_{At}.
\]

- **(F28) Composite growth rate**:

\[
\mu_{z,t}=\mu_{A,t}^{1/(1-\alpha)}\mu_{I,t}^{\alpha/(1-\alpha)}.
\]

- **(F29) Preference-volatility process**:

\[
\log\sigma_{dt}
=\rho_{\sigma_d}\log\sigma_{d,t-1}
+(1-\rho_{\sigma_d}^2)^{1/2}\eta_d u_{dt}.
\]

- **(F30) Labor-disutility-volatility process**:

\[
\log\sigma_{\varphi t}
=\rho_{\sigma_{\varphi}}\log\sigma_{\varphi,t-1}
+(1-\rho_{\sigma_{\varphi}}^2)^{1/2}\eta_{\varphi}u_{\varphi t}.
\]

- **(F31) Investment-specific-volatility process**:

\[
\log\sigma_{\mu t}
=\rho_{\sigma_{\mu}}\log\sigma_{\mu,t-1}
+(1-\rho_{\sigma_{\mu}}^2)^{1/2}\eta_{\mu}u_{\mu t}.
\]

- **(F32) Neutral-technology-volatility process**:

\[
\log\sigma_{At}
=\rho_{\sigma_A}\log\sigma_{A,t-1}
+(1-\rho_{\sigma_A}^2)^{1/2}\eta_Au_{At}.
\]

- **(F33) Monetary-policy-volatility process**:

\[
\log\sigma_{\xi t}
=\rho_{\sigma_{\xi}}\log\sigma_{\xi,t-1}
+(1-\rho_{\sigma_{\xi}}^2)^{1/2}\eta_{\xi}u_{\xi t}.
\]

- **(F34) Inflation-response drift**:

\[
\log\gamma_{\Pi t}
=\rho_{\gamma_{\Pi}}\log\gamma_{\Pi,t-1}
+\sigma_{\pi}\varepsilon_{\pi t}.
\]

- **(F35) Output-growth-response drift**:

\[
\log\gamma_{yt}
=\rho_{\gamma_y}\log\gamma_{y,t-1}
+\sigma_y\varepsilon_{yt}.
\]

- **(F36) Output growth observable**:

\[
y^g_t=\frac{(y_t^d/y_{t-1}^d)\mu_{z,t}}{\exp(\Lambda_{y^d})}.
\]

## 6. Steady-State Solution

The paper rescale variables by:

\[
z_t=A_t^{1/(1-\alpha)}\mu_t^{\alpha/(1-\alpha)},\quad
\widetilde{k}_t=\frac{k_t}{z_t\mu_t},\quad
\widetilde{c}_t=\frac{c_t}{z_t},\quad
\widetilde{x}_t=\frac{x_t}{z_t},\quad
\widetilde{y}_t=\frac{y_t}{z_t},\quad
\widetilde{w}_t=\frac{w_t}{z_t},\quad
\widetilde{r}_t=\mu_t r_t.
\]

In the balanced-growth stationary representation:

- \(\sigma_{dt}=\sigma_{\varphi t}=\sigma_{\mu t}=\sigma_{At}=\sigma_{\xi t}=1\) in log-deviation terms.
- \(\gamma_{\Pi t}=\gamma_{yt}=1\) in drift-deviation terms.
- \(\mu_A=\exp(\Lambda_A)\) and \(\mu_I=\exp(\Lambda_{\mu})\); \(\mu_z=\mu_A^{1/(1-\alpha)}\mu_I^{\alpha/(1-\alpha)}\).
- Utilization is normalized to \(u=1\), implying \(\Phi(1)=0\) and \(\Phi'(1)=\widetilde r\).
- Price and wage dispersion are \(v^p=v^w=1\) when inflation and wage inflation are at their balanced-growth values.
- The full closed-form steady-state sequence is not fully spelled out in the local paper Markdown and is therefore `needs_review`. A future review should check the paper appendix or original computational files before marking steady-state quality above first pass.

## 7. Timing & Form Conventions

- **Capital timing**: The paper uses capital rented from the previous period in production. In Dynare cross-check form, `predetermined_variables k` is declared and production uses \(k_{t-1}\) while the stationary capital law solves for \(k_{t+1}\).
- **Stationarization**: Variables with unit-root technology trends are rescaled by \(z_t\) and, for capital/rental terms, by \(\mu_t\) as stated in section 5.4 of the source.
- **Approximation form**: The paper's estimation requires a second-order approximation because stochastic volatility and policy-parameter drift are absent from certainty-equivalent first-order decision rules. Runtime validation was not performed.
- **Source status**: Equations (F6), (F7), and some utilization/dispersion algebra are `needs_review` because the local MinerU text does not include a clean appendix normalization.
- **Implementation cross-check**: The Rep-MMB `.mod` confirms 36 model equations, 36 endogenous variables, 12 exogenous innovations, and predetermined capital. This information is recorded only as `implementation_cross_check`.

## 8. Variable & Parameter Reference Table

### Endogenous Variables

| ASCII name | Mathematical symbol | Meaning | Main equation(s) |
|---|---|---|---|
| `d` | \(d_t\) | Intertemporal preference shock | (F24) |
| `c` | \(c_t\) | Consumption | (F1), (F16) |
| `mu_z` | \(\mu_{z,t}\) | Composite growth rate | (F28) |
| `mu_I` | \(\mu_{I,t}\) | Investment-specific technology growth | (F26) |
| `mu_A` | \(\mu_{A,t}\) | Neutral technology growth | (F27) |
| `lambda` | \(\lambda_t\) | Marginal utility/Lagrange multiplier | (F1), (F2) |
| `R` | \(R_t\) | Nominal gross interest rate | (F2), (F15) |
| `PI` | \(\Pi_t\) | Inflation | (F14), (F15) |
| `r` | \(r_t\) | Rental rate of capital | (F3), (F11), (F12) |
| `x` | \(x_t\) | Investment | (F5), (F16), (F21) |
| `u` | \(u_t\) | Capacity utilization | (F3), (F17) |
| `q` | \(q_t\) | Tobin's marginal q | (F4), (F5) |
| `f` | \(f_t\) | Wage-setting recursion variable | (F6), (F7) |
| `ld` | \(l_t^d\) | Aggregate labor demand | (F11), (F17), (F18) |
| `w` | \(w_t\) | Real wage | (F11), (F12), (F13) |
| `wstar` | \(w^{\ast}_t\) | Optimal reset wage | (F6), (F23) |
| `PIstarw` | \(\Pi^{\ast}_{w,t}\) | Optimal wage inflation | (F7), (F13), (F20), (F23) |
| `PIstar` | \(\Pi^{\ast}_t\) | Optimal reset price inflation | (F9), (F14), (F19) |
| `g1` | \(g_{1t}\) | Price-setting recursion variable | (F8), (F10) |
| `g2` | \(g_{2t}\) | Price-setting recursion variable | (F9), (F10) |
| `yd` | \(y_t^d\) | Aggregate demand/output | (F15), (F16), (F17), (F36) |
| `mc` | \(mc_t\) | Real marginal cost | (F8), (F12) |
| `k` | \(k_t\) | Capital stock | (F4), (F17), (F21) |
| `vp` | \(v^p_t\) | Price dispersion | (F17), (F19) |
| `vw` | \(v^w_t\) | Wage dispersion | (F18), (F20) |
| `l` | \(l_t\) | Aggregate labor bundle | (F18) |
| `phi` | \(\varphi_t\) | Labor-disutility shock | (F25) |
| `F` | \(F_t\) | Firm profits | (F22) |
| `sigma_dt` | \(\sigma_{dt}\) | Preference-shock volatility | (F29) |
| `sigma_phit` | \(\sigma_{\varphi t}\) | Labor-disutility-shock volatility | (F30) |
| `sigma_mut` | \(\sigma_{\mu t}\) | Investment-specific-shock volatility | (F31) |
| `sigma_At` | \(\sigma_{At}\) | Neutral-technology-shock volatility | (F32) |
| `sigma_mt` | \(\sigma_{\xi t}\) | Monetary-policy-shock volatility | (F33) |
| `gammaPIt` | \(\gamma_{\Pi t}\) | Drifting inflation response | (F34) |
| `gammayt` | \(\gamma_{yt}\) | Drifting output-growth response | (F35) |
| `yg` | \(y^g_t\) | Output growth observable | (F36) |

### Exogenous Innovations

| ASCII name | Meaning |
|---|---|
| `epsd` | Preference-shock innovation |
| `epsphi` | Labor-disutility-shock innovation |
| `epsmu_I` | Investment-specific-technology innovation |
| `epsA` | Neutral-technology innovation |
| `epsm` | Monetary-policy innovation |
| `ud` | Preference-volatility innovation |
| `uphi` | Labor-disutility-volatility innovation |
| `umu` | Investment-specific-volatility innovation |
| `uA` | Neutral-technology-volatility innovation |
| `um` | Monetary-policy-volatility innovation |
| `epspi` | Inflation-response drift innovation |
| `epsy` | Output-growth-response drift innovation |

### Main Parameters

| ASCII name | Meaning |
|---|---|
| `h`, `betta` | Habit persistence and discount factor |
| `gammma1`, `gammma2` | Utilization-cost linear/quadratic terms |
| `delta`, `kappa` | Depreciation and investment adjustment cost |
| `eta`, `epsilon` | Labor and goods substitution elasticities |
| `varpsi`, `gammma` | Labor disutility scale and inverse Frisch elasticity |
| `chiw`, `chi` | Wage and price indexation |
| `thetaw`, `thetap` | Calvo wage and price stickiness |
| `alppha` | Capital share |
| `Rbar`, `PIbar` | Balanced-growth nominal rate and inflation |
| `gammmaR`, `gammmaPI`, `gammmay` | Taylor-rule smoothing, inflation response, output-growth response |
| `Phi` | Fixed cost in intermediate production |
| `rhod`, `rhophi` | Preference and labor-disutility shock persistence |
| `Lambdamu`, `LambdaA`, `Lambdax`, `LambdaYd` | Growth-rate constants |
| `sigma_d`, `sigma_phi`, `sigma_mu`, `sigma_A`, `sigma_m` | Mean innovation standard deviations |
| `rhosigd`, `rhosigphi`, `rhosigmu`, `rhosigA`, `rhosigm` | Volatility-shock persistence |
| `rhogammaPI`, `rhogammay` | Policy-drift persistence |
| `eta_d`, `eta_phi`, `eta_mu`, `eta_A`, `eta_m` | Volatility-shock innovation scales |
| `sigma_pi`, `sigma_y` | Policy-drift innovation scales |
