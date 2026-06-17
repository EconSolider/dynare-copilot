# US_ACELswt - Derivation (optimization problems and equilibrium conditions)

> Archive status: `needs_review`. This first-pass derivation is source-backed by the MinerU Markdown of Altig, Christiano, Eichenbaum, and Linde (2005). The local MMB `.mod` is used only as `implementation_cross_check`; Dynare runtime validation was not performed.

Provenance: model ID `US_ACELswt`; paper "Firm-specific capital, nominal rigidities"; authors David Altig, Lawrence J. Christiano, Martin Eichenbaum, and Jesper Linde; year 2005; DOI `10.3386/w11034`; source Markdown `raw/mmb_mineru/runs/us_acelm_us_acelswm_us_acelswt_us_acelt__firm_specific_capital_nominal_rigidities__e0fac58f/full.md`; raw PDF `raw/mmb_papers/Firm-specific capital, nominal rigidities.pdf`; MinerU run id `e0fac58f-0dfb-476b-b2df-8712e57d9ce4`.

## 1. Model Overview

- **Model**: U.S. estimated medium-scale New Keynesian model with firm-specific capital and nominal rigidities. The paper compares homogeneous and firm-specific capital variants; `US_ACELswt` corresponds to the sticky-price/wage MMB implementation with firm-specific capital as the target interpretation.
- **Agents and blocks**: final-good aggregator; monopolistically competitive intermediate-good firms; households with habit persistence, money demand, variable capital utilization, investment adjustment costs, and Calvo wage setting; financial intermediaries that finance the wage bill; monetary authority; lump-sum fiscal authority.
- **Shocks**: monetary-base growth shock, neutral technology growth shock, capital-embodied technology growth shock, and an additional transitory neutral technology shock in the MMB implementation cross-check.
- **Form**: the paper states that the computational strategy uses a linear approximation about the non-stochastic steady state. The MMB file is `model(linear)`, so the archive form is **log-linear / linear-deviation**. All `F#` equations below should be read as linearized equilibrium restrictions unless explicitly marked as nonlinear source primitives.
- **Central firm-specific-capital mechanism**: a firm's capital is predetermined within the period and cannot be reallocated instantly across firms. This makes firm marginal cost increasing in firm output and reduces the slope of the aggregate inflation equation for a given frequency of price re-optimization.

## 2. Optimization Problems

### 2.1 Final-good firm

The competitive final-good firm combines differentiated intermediate goods:

$$
Y_t=\left[\int_0^1 y_t(i)^{1/\lambda_f}\,di\right]^{\lambda_f},
\qquad 1\leq \lambda_f<\infty .
$$

It chooses inputs to maximize final-good profit taking all prices as given.

### 2.2 Intermediate-good firms

For the homogeneous-capital benchmark, intermediate producer \(i\) uses:

$$
y_t(i)=K_t(i)^\alpha\left(z_t h_t(i)\right)^{1-\alpha}-\phi z_t^*,
\qquad
z_t^*=\Upsilon_t^{\alpha/(1-\alpha)}z_t .
$$

The firm sets prices under Calvo frictions. If it cannot re-optimize, it indexes to lagged inflation. Its discounted nominal profit objective is:

$$
E_t\sum_{j=0}^{\infty}\beta^j v_{t+j}\left[
P_{t+j}(i)y_{t+j}(i)
-P_{t+j}\left(w_{t+j}R_{t+j}h_{t+j}(i)+r^k_{t+j}K_{t+j}(i)\right)
\right].
$$

For the firm-specific-capital model, each firm owns predetermined physical capital. It chooses price, employment, utilization, and investment to maximize:

$$
E_t\sum_{j=0}^{\infty}\beta^j v_{t+j}\left\{
P_{t+j}(i)y_{t+j}(i)
-P_{t+j}R_{t+j}w_{t+j}h_{t+j}(i)
-P_{t+j}\Upsilon_{t+j}^{-1}\left[I_{t+j}(i)+a(u_{t+j}(i))\bar K_{t+j}(i)\right]
\right\}.
$$

### 2.3 Households

Household \(j\) has habit preferences over consumption and hours:

$$
E_t^j\sum_{\ell=0}^{\infty}\beta^{\ell-t}
\left[
\log(C_{t+\ell}-bC_{t+\ell-1})
-\psi_L\frac{h_{j,t+\ell}^2}{2}
\right].
$$

The nominal asset accumulation constraint is:

$$
\begin{aligned}
M_{t+1}={}&R_t\left[M_t-Q_t+(x_t-1)M_t^a\right]+A_{j,t}+Q_t+W_{j,t}h_{j,t} \\
&+P_t r_t^k u_t\bar K_t+D_t-(1+\eta(V_t))P_tC_t
-P_t\Upsilon_t^{-1}\left[I_t+a(u_t)\bar K_t\right].
\end{aligned}
$$

Households also choose wage offers subject to Calvo wage frictions and wage indexation.

## 3. First-Order Conditions

- **(F1) Final-good demand for variety \(i\)**:

$$
\frac{y_t(i)}{Y_t}=\left(\frac{P_t}{P_t(i)}\right)^{\lambda_f/(\lambda_f-1)} .
$$

- **(F2) Aggregate final-good price index**:

$$
P_t=\left[\int_0^1 P_t(i)^{1/(1-\lambda_f)}\,di\right]^{1-\lambda_f}.
$$

- **(F3) Price indexation for non-reoptimizing firms**:

$$
P_t(i)=\pi_{t-1}P_{t-1}(i).
$$

- **(F4) Capital-service definition**:

$$
K_t=u_t\bar K_t .
$$

- **(F5) Money-demand FOC**:

$$
R_t=1+\eta'\left(\frac{P_tC_t}{Q_t}\right)\left(\frac{P_tC_t}{Q_t}\right)^2 .
$$

- **(F6) Steady-state Fisher relation on the balanced-growth path**:

$$
R=\frac{\pi\mu_{z^*}}{\beta}.
$$

- **(F7) Wage-services aggregator**:

$$
H_t=\left[\int_0^1 h_{j,t}^{1/\lambda_w}\,dj\right]^{\lambda_w},
\qquad 1\leq\lambda_w<\infty .
$$

- **(F8) Demand for household labor type \(j\)**:

$$
h_{j,t}=\left(\frac{W_t}{W_{j,t}}\right)^{\lambda_w/(\lambda_w-1)}H_t .
$$

- **(F9) Aggregate wage index**:

$$
W_t=\left[\int_0^1 W_{j,t}^{1/(1-\lambda_w)}\,dj\right]^{1-\lambda_w}.
$$

- **(F10) Wage indexation for non-reoptimizing households**:

$$
W_{j,t}=\pi_{t-1}\mu_{z^*}W_{j,t-1}.
$$

- **(F11) Inflation equation, paper reduced form**:

$$
\Delta\hat\pi_t=E\left[\beta\Delta\hat\pi_{t+1}+\gamma\hat s_t\mid\Omega_t\right],
\qquad
\gamma=\frac{(1-\xi_p)(1-\beta\xi_p)}{\xi_p}\chi .
$$

For homogeneous capital, \(\chi=1\). For firm-specific capital, \(\chi\) is a nonlinear function of structural parameters and is `needs_review` because the exact appendix expression is not present in the source Markdown.

### 3.1 Linear MMB implementation cross-check equations

The MMB implementation uses the following sticky-price linear restrictions. These are not treated as paper-side mathematical sources; they are recorded to make the MMB variable and equation coverage auditable.

- **(F12) Capital Euler equation** (`implementation_cross_check`, `needs_review` against technical appendix):

$$
\hat\lambda_{z^*,t+1}
+\frac{1-\delta}{\tilde r+1-\delta}\hat{\tilde\mu}_{t+1}
+\frac{\tilde r}{\tilde r+1-\delta}\hat{\tilde r}_{t+1}
-\hat\lambda_{z^*,t}-\hat{\tilde\mu}_t
=\hat\mu_{z,t+1}+\frac{1}{1-\alpha}\hat\mu_{\Upsilon,t+1}.
$$

- **(F13) Investment Euler equation** (`implementation_cross_check`, `needs_review`):

$$
\begin{aligned}
&-\beta\kappa(\mu_{z^*}\mu_\Upsilon)^2\hat i_{t+1}-\hat{\tilde\mu}_t
+\kappa(\mu_{z^*}\mu_\Upsilon)^2(1+\beta)\hat i_t
-\kappa(\mu_{z^*}\mu_\Upsilon)^2\hat i_{t-1} \\
&=\beta\kappa(\mu_{z^*}\mu_\Upsilon)^2\hat\mu_{z,t+1}
+\frac{\beta\kappa(\mu_{z^*}\mu_\Upsilon)^2}{1-\alpha}\hat\mu_{\Upsilon,t+1}
-\kappa(\mu_{z^*}\mu_\Upsilon)^2\hat\mu_{z,t}
-\frac{\kappa(\mu_{z^*}\mu_\Upsilon)^2}{1-\alpha}\hat\mu_{\Upsilon,t}.
\end{aligned}
$$

- **(F14) Shadow rental rate on capital** (`implementation_cross_check`, `needs_review`):

$$
\hat{\tilde w}_t+\frac{1}{1-\alpha}\frac{\tilde y}{\tilde y+\phi}\hat{\tilde y}_t
+\frac{\nu R}{\nu R+1-\nu}\hat R_t-\hat{\tilde r}_t
-\frac{1}{1-\alpha}\hat u_t-\frac{1}{1-\alpha}\hat{\bar k}_{t-1}
=-\frac{1}{1-\alpha}\hat\mu_{z,t}
-\frac{1}{(1-\alpha)^2}\hat\mu_{\Upsilon,t}
+\frac{1}{1-\alpha}\hat\epsilon_t .
$$

- **(F15) Linear capital evolution** (`implementation_cross_check`):

$$
(\mu_{z^*}\mu_\Upsilon-(1-\delta))\hat i_t
-\mu_\Upsilon\mu_{z^*}\hat{\bar k}_t
+(1-\delta)\hat{\bar k}_{t-1}
=(1-\delta)\hat\mu_{z,t}
+\frac{1-\delta}{1-\alpha}\hat\mu_{\Upsilon,t}.
$$

- **(F16) Sticky-price inflation equation in MMB file** (`implementation_cross_check`):

$$
\beta\hat\pi_{t+1}-(1+\beta\varsigma)\hat\pi_t+\gamma\hat s_t
=-\varsigma\hat\pi_{t-1}.
$$

- **(F17) Linear marginal-cost equation** (`implementation_cross_check`, `needs_review`):

$$
\hat{\tilde w}_t-\hat s_t+\frac{\alpha}{1-\alpha}\frac{\tilde y}{\tilde y+\phi}\hat{\tilde y}_t
+\frac{\nu R}{\nu R+1-\nu}\hat R_t
-\frac{\alpha}{1-\alpha}\hat u_t
-\frac{\alpha}{1-\alpha}\hat{\bar k}_{t-1}
=-\frac{\alpha}{1-\alpha}\hat\mu_{z,t}
-\frac{\alpha}{(1-\alpha)^2}\hat\mu_{\Upsilon,t}
+\frac{1}{1-\alpha}\hat\epsilon_t .
$$

- **(F18) Linear money demand** (`implementation_cross_check`):

$$
\hat c_t-\hat q_t=\frac{R}{R-1}\frac{1}{2+\varphi}\hat R_t .
$$

- **(F19) Linear consumption Euler equation** (`implementation_cross_check`, `needs_review`):

$$
\text{linear habit Euler restriction in }(\hat c_{t+1},\hat c_t,\hat c_{t-1},\hat\lambda_{z^*,t},\hat q_t,\hat\mu_{z,t+1},\hat\mu_{\Upsilon,t+1},\hat\mu_{z,t},\hat\mu_{\Upsilon,t}).
$$

The exact coefficient-level expression is available in the implementation cross-check and should be verified against the technical appendix before promotion.

- **(F20) Monetary-base FOC** (`implementation_cross_check`):

$$
\hat\lambda_{z^*,t+1}-\hat\pi_{t+1}+\hat R_{t+1}-\hat\lambda_{z^*,t}
=\hat\mu_{z,t+1}+\frac{\alpha}{1-\alpha}\hat\mu_{\Upsilon,t+1}.
$$

- **(F21) Linear wage FOC** (`implementation_cross_check`, `needs_review`):

$$
\eta_3\hat{\tilde w}_{t+1}+\eta_6\hat\pi_{t+1}
+\eta_2\hat{\tilde w}_t+\eta_5\hat\pi_t+\eta_7\hat h_t+\eta_8\hat\lambda_{z^*,t}
+\eta_1\hat{\tilde w}_{t-1}+\eta_4\hat\pi_{t-1}
=-\eta_{10}\frac{\alpha}{1-\alpha}\hat\mu_{\Upsilon,t+1}-\eta_{10}\hat\mu_{z,t+1}
-\eta_9\frac{\alpha}{1-\alpha}\hat\mu_{\Upsilon,t}-\eta_9\hat\mu_{z,t}.
$$

- **(F22) Capital-utilization FOC** (`implementation_cross_check`):

$$
\frac{1}{\sigma_a}\hat{\tilde r}_t=\hat u_t .
$$

## 4. Market Clearing & Identities

- **(F23) Technology scaling for balanced growth**:

$$
\mu_{z^*,t}=\mu_{\Upsilon,t}^{\alpha/(1-\alpha)}\mu_{z,t}.
$$

- **(F24) Investment-to-capital transformation, homogeneous capital**:

$$
\bar K_{t+1}=(1-\delta)\bar K_t+\left[1-S\left(\frac{I_t}{I_{t-1}}\right)\right]I_t .
$$

- **(F25) Firm-specific capital accumulation**:

$$
\bar K_{t+1}(i)=(1-\delta)\bar K_t(i)
+\left[1-S\left(\frac{I_t(i)}{I_{t-1}(i)}\right)\right]I_t(i).
$$

- **(F26) Loan-market clearing**:

$$
W_tH_t=x_tM_t-Q_t .
$$

- **(F27) Final-goods resource constraint**:

$$
(1+\eta(V_t))C_t+\Upsilon_t^{-1}\left[I_t+a(u_t)\bar K_t\right]\leq Y_t .
$$

- **(F28) Linear production function** (`implementation_cross_check`):

$$
(\tilde y+\phi)(1-\alpha)\hat h_t-\tilde y\hat{\tilde y}_t
+\left((\tilde y+\phi)\alpha-\frac{\tilde r\bar k}{\mu_{z^*}\mu_\Upsilon}\right)\hat u_t
+(\tilde y+\phi)\alpha\hat{\bar k}_{t-1}
=(\tilde y+\phi)\alpha\hat\mu_{z,t}
+\frac{(\tilde y+\phi)\alpha}{1-\alpha}\hat\mu_{\Upsilon,t}
-(\tilde y+\phi)\hat\epsilon_t .
$$

- **(F29) Linear resource constraint** (`implementation_cross_check`, `needs_review`):

$$
\begin{aligned}
&\left((1+\eta)c+\eta'c^2/q\right)\hat c_t
+\left(1-\frac{1-\delta}{\mu_\Upsilon\mu_{z^*}}\right)\bar k\,\hat i_t
-(\tilde y+\phi)(1-\alpha)\hat h_t-\eta'c^2/q\,\hat q_t \\
&+\left(\frac{\tilde r\bar k}{\mu_{z^*}\mu_\Upsilon}-(\tilde y+\phi)\alpha\right)\hat u_t
-(\tilde y+\phi)\alpha\hat{\bar k}_{t-1}
+(\tilde y+\phi)\alpha\hat\mu_{z,t}
+\frac{(\tilde y+\phi)\alpha}{1-\alpha}\hat\mu_{\Upsilon,t}
-(\tilde y+\phi)\hat\epsilon_t=0 .
\end{aligned}
$$

- **(F30) Money-market clearing** (`implementation_cross_check`):

$$
\hat{\tilde w}_t-\frac{x m}{xm-q}\hat m_t+\hat h_t+\frac{q}{xm-q}\hat q_t
=\frac{x m}{xm-q}\hat x_t .
$$

- **(F31) Monetary-base accumulation identity** (`implementation_cross_check`):

$$
-\hat m_t-\hat\pi_t+\hat m_{t-1}+\hat x_{t-1}
=\hat\mu_{z,t}+\frac{\alpha}{1-\alpha}\hat\mu_{\Upsilon,t}.
$$

## 5. Exogenous Processes

- **(F32) Money-growth policy decomposition**:

$$
\hat x_t=\hat x_{z,t}+\hat x_{\Upsilon,t}+\hat x_{M,t}.
$$

- **(F33) Monetary shock process**:

$$
\hat x_{M,t}=\rho_{xM}\hat x_{M,t-1}+\varepsilon_{M,t}.
$$

- **(F34) Neutral technology growth**:

$$
\hat\mu_{z,t}=\rho_{\mu_z}\hat\mu_{z,t-1}+\varepsilon_{\mu_z,t}.
$$

- **(F35) Policy response to neutral technology innovation**:

$$
\hat x_{z,t}=\rho_{xz}\hat x_{z,t-1}+c_z\varepsilon_{z,t}+c_z^p\varepsilon_{z,t-1}.
$$

- **(F36) Capital-embodied technology growth**:

$$
\hat\mu_{\Upsilon,t}=\rho_{\mu_\Upsilon}\hat\mu_{\Upsilon,t-1}+\varepsilon_{\mu_\Upsilon,t}.
$$

- **(F37) Policy response to embodied-technology innovation**:

$$
\hat x_{\Upsilon,t}=\rho_{x\Upsilon}\hat x_{\Upsilon,t-1}+c_\Upsilon\varepsilon_{\Upsilon,t}+c_\Upsilon^p\varepsilon_{\Upsilon,t-1}.
$$

- **(F38) Transitory neutral technology process in MMB implementation** (`implementation_cross_check`):

$$
\hat\epsilon_t=\rho_\epsilon\hat\epsilon_{t-1}+\sigma_\epsilon\varepsilon_{\epsilon,t}.
$$

## 6. Steady-State Solution

The source paper describes a non-stochastic steady state on a balanced-growth path. The MMB implementation supplies a concrete steady-state normalization for the linear model:

1. Compute \(\mu_{z^*}=\mu_\Upsilon^{\alpha/(1-\alpha)}\mu_z\).
2. Compute the steady-state capital rental term:

$$
\tilde r=\frac{\mu_\Upsilon\mu_{z^*}}{\beta}-(1-\delta).
$$

3. Compute steady-state inflation and nominal gross interest:

$$
\pi=\frac{x}{\mu_{z^*}},
\qquad
R=\frac{\pi\mu_{z^*}}{\beta}.
$$

4. Compute the money-demand transaction-cost slope from velocity:

$$
\eta'=\frac{R-1}{V^2},
\qquad
\varphi=\frac{1}{4\epsilon(R-1)}-2.
$$

5. Set \(s=1/\lambda_f\), \(R_\nu=\nu R+1-\nu\), and solve the steady-state real wage, capital-hours ratio, capital, hours, consumption, real balances, output, fixed cost, investment, and marginal utility using the recursive formulas in `US_ACELswt_rep.mod`.

Because the archive entry is for a `model(linear)` implementation, steady-state values are parameters around which deviations are taken; all dynamic variables in the model block have zero deterministic steady state. The exact coefficient-level steady-state recursion is marked `implementation_cross_check` and should be reviewed against the technical appendix before any runnable promotion.

## 7. Timing & Form Conventions

- **Information timing**: technology shocks are observed before price/wage and real decisions; the monetary policy shock occurs after price/wage setting and before demand realization.
- **Firm-specific capital timing**: firm \(i\) enters period \(t\) with predetermined \(\bar K_t(i)\). It can adjust future capital only through current investment \(I_t(i)\), so output after the monetary shock is met through labor demand and utilization rather than same-period capital reallocation.
- **Capital stock**: the MMB variable `kbar_t1` denotes the physical capital stock available from the previous period in production equations and the stock updated by the capital law.
- **Wages and prices**: prices and wages are Calvo with lagged-inflation indexation; the paper's inflation equation uses \(\Delta\hat\pi_t\), while the MMB linear cross-check writes the sticky-price equation in terms of \(\hat\pi_t,\hat\pi_{t+1},\hat\pi_{t-1}\).
- **Model form**: `model(linear)`. Hats denote log deviations or stationary percentage deviations from the balanced-growth steady state. This entry does not run Dynare and does not certify Blanchard-Kahn or IRF behavior.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII name | Meaning | Main equation(s) |
|---|---|---|---|
| Endogenous | `c_t` | consumption deviation | (F18), (F19), (F29) |
| Endogenous | `wtilde_t` | stationary real wage deviation | (F17), (F21), (F30) |
| Endogenous | `lambda_zstar_t` | marginal utility / multiplier deviation | (F12), (F19), (F20), (F21) |
| Endogenous | `m_t` | money stock deviation | (F30), (F31) |
| Endogenous | `pi_t` | inflation deviation | (F16), (F21), (F31) |
| Endogenous | `x_t` | money growth deviation | (F32), (F33), (F35), (F37) |
| Endogenous | `s_t` | marginal cost deviation | (F16), (F17) |
| Endogenous | `i_t` | investment deviation | (F13), (F15), (F29) |
| Endogenous | `h_t` | hours deviation | (F21), (F28), (F29), (F30) |
| Endogenous | `kbar_t1` | predetermined capital stock deviation | (F15), (F28), (F29) |
| Endogenous | `q_t` | real cash balances deviation | (F18), (F19), (F29), (F30) |
| Endogenous | `ytilde_t` | stationary output deviation | (F14), (F17), (F28) |
| Endogenous | `R_t` | nominal/short-rate deviation in implementation | (F14), (F18), (F20) |
| Endogenous | `mutilde_t` | shadow value of installed capital | (F12), (F13) |
| Endogenous | `rhotilde_t` | rental return on capital | (F12), (F14), (F22) |
| Endogenous | `u_t` | utilization deviation | (F14), (F17), (F22), (F28), (F29) |
| Endogenous | `x_M_t`, `eps_M_t` | monetary shock state and innovation copy | (F33) |
| Endogenous | `mu_z_t`, `eps_muz_t`, `x_z_t` | neutral technology growth and policy response states | (F34), (F35) |
| Endogenous | `mu_ups_t`, `eps_muups_t`, `x_ups_t` | embodied technology growth and policy response states | (F36), (F37) |
| Endogenous | `epsilon_t` | transitory neutral technology state | (F38) |
| Endogenous | `*_f` variables | flexible-price counterparts of the sticky-price block | flexible-price implementation cross-check |
| Exogenous | `epsilon_M_` | monetary policy innovation | (F33) |
| Exogenous | `eps_muz_` | neutral technology growth innovation | (F34) |
| Exogenous | `eps_muups_` | embodied technology growth innovation | (F36) |
| Exogenous | `epsilon_t_` | transitory neutral technology innovation | (F38) |
| Parameter | `alpha` | capital share | (F12)-(F17), (F23), (F28)-(F31) |
| Parameter | `b` | habit persistence | (F19), steady state |
| Parameter | `beta` | discount factor | (F6), (F11)-(F13), (F16), (F19) |
| Parameter | `delta` | depreciation | (F15), (F24), (F25) |
| Parameter | `eta`, `eta_pr`, `V`, `sig_eta` | transaction-cost and velocity parameters | (F5), (F18), (F29) |
| Parameter | `lambda_f`, `lambda_w` | goods and labor markup parameters | (F1), (F7)-(F9), steady state |
| Parameter | `xi_w`, `xif_w` | sticky/flexible wage Calvo parameters in implementation | (F21) |
| Parameter | `gamma`, `squig` | inflation slope and indexation coefficient | (F11), (F16) |
| Parameter | `sigma_a` | utilization-cost curvature | (F22) |
| Parameter | `kappa` | investment adjustment-cost curvature | (F13) |
| Parameter | `rho_*`, `theta_*`, `c_*`, `cp_*` | shock persistence and ARMA response parameters | (F33)-(F38) |

Runtime validation: not performed. Formula quality: `needs_review` for coefficient-level linear equations that require the separate technical appendix.
