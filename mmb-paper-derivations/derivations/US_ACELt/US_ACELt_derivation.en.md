# US_ACELt Derivation

> Source-backed first-pass archive entry for Altig, Christiano, Eichenbaum, and Linde (2005), "Firm-Specific Capital, Nominal Rigidities and the Business Cycle." Status: `needs_review`.
> Runtime validation: not performed. Dynare was not run.

## 1. Model Overview

- **Model ID**: `US_ACELt`.
- **Paper**: David Altig, Lawrence J. Christiano, Martin Eichenbaum, and Jesper Linde (2005), "Firm-Specific Capital, Nominal Rigidities and the Business Cycle," CEPR Discussion Paper 4858. DOI recorded in `model_index.csv`: `10.3386/w11034`.
- **Source used for equations**: `raw/mmb_mineru/runs/us_acelm_us_acelswm_us_acelswt_us_acelt__firm_specific_capital_nominal_rigidities__e0fac58f/full.md`.
- **Economy and variant**: Estimated United States medium-scale DSGE model with neutral technology, capital-embodied technology, sticky prices, sticky wages, habit formation, variable capital utilization, money demand, and working-capital finance of the wage bill. The MMB `US_ACELt` implementation is the technology-shock timing variant: the implementation comments state that technology shocks are realized before agents' decisions and the monetary policy shock is realized after those decisions.
- **Core agents**: final-good aggregator, monopolistically competitive intermediate-goods firms, households that consume, set differentiated wages, hold money, supply capital services, and invest, financial intermediaries that lend money balances to firms for wage bills, government, and monetary authority.
- **Form**: `model(linear)` in the MMB implementation. The paper derives a nonlinear growing economy and estimates linearized equilibrium dynamics around the non-stochastic balanced-growth path. This archive records the paper-side structure and the implementation-level linear equilibrium equations as a cross-check, with OCR-sensitive formulas marked `needs_review`.

## 2. Optimization Problems

### Final-Good Firm

The competitive final-good firm aggregates differentiated intermediate goods:

$$
Y_t=\left[\int_0^1 y_t(i)^{1/\lambda_f}\,di\right]^{\lambda_f}.
$$

It chooses intermediate inputs to minimize cost subject to the aggregator.

### Intermediate-Goods Firms

In the homogeneous-capital presentation, intermediate firm \(i\) produces with capital services and labor:

$$
y_t(i)=K_t(i)^\alpha\left(z_t h_t(i)\right)^{1-\alpha}-\phi z_t^{\ast},
\qquad
z_t^{\ast}=\Upsilon_t^{\alpha/(1-\alpha)}z_t.
$$

Firms rent capital and labor in competitive factor markets and must finance the wage bill in advance at the gross rate \(R_t\). Price setting follows Calvo frictions with indexation for non-reoptimizing prices:

$$
P_t(i)=\pi_{t-1}P_{t-1}(i).
$$

The nominal price-setting objective is the expected discounted value of sales net of wage-financing and capital rental costs:

$$
E_t\sum_{j=0}^{\infty}\beta^j v_{t+j}
\left[P_{t+j}(i)y_{t+j}(i)-P_{t+j}\left(w_{t+j}R_{t+j}h_{t+j}(i)+r_{t+j}^kK_{t+j}(i)\right)\right].
$$

In the firm-specific capital variant, each intermediate firm owns predetermined beginning-of-period capital and chooses firm-level investment and utilization:

$$
\bar K_{t+1}(i)=(1-\delta)\bar K_t(i)+\left[1-S\left(\frac{I_t(i)}{I_{t-1}(i)}\right)\right]I_t(i).
$$

Its cash-flow objective subtracts labor costs including working-capital interest and investment/utilization costs:

$$
E_t\sum_{j=0}^{\infty}\beta^jv_{t+j}
\left\{P_{t+j}(i)y_{t+j}(i)-P_{t+j}R_{t+j}w_{t+j}h_{t+j}(i)
-P_{t+j}\Upsilon_{t+j}^{-1}\left[I_{t+j}(i)+a(u_{t+j}(i))\bar K_{t+j}(i)\right]\right\}.
$$

### Households

Each household \(j\) has habit preferences over consumption and disutility of hours:

$$
E_t^j\sum_{\ell=0}^{\infty}\beta^{\ell-t}
\left[\log(C_{t+\ell}-bC_{t+\ell-1})-\psi_L\frac{h_{j,t+\ell}^2}{2}\right].
$$

Households allocate beginning-of-period money between deposits and transaction cash, supply capital services through utilization, invest in physical capital, receive profits, and set wages subject to Calvo wage stickiness. Their asset evolution is:

$$
\begin{aligned}
M_{t+1}={}&R_t\left[M_t-Q_t+(x_t-1)M_t^a\right]+A_{j,t}+Q_t+W_{j,t}h_{j,t}\\
&+P_tr_t^ku_t\bar K_t+D_t-(1+\eta(V_t))P_tC_t
-P_t\Upsilon_t^{-1}\left(I_t+a(u_t)\bar K_t\right).
\end{aligned}
$$

Transaction velocity is:

$$
V_t=\frac{P_tC_t}{Q_t}.
$$

Capital services and physical capital accumulation are:

$$
K_t=u_t\bar K_t,\qquad
\bar K_{t+1}=(1-\delta)\bar K_t+\left[1-S\left(\frac{I_t}{I_{t-1}}\right)\right]I_t.
$$

### Wage Setting

Differentiated labor services are aggregated by:

$$
H_t=\left[\int_0^1 h_{j,t}^{1/\lambda_w}\,dj\right]^{\lambda_w}.
$$

The implied demand for household \(j\)'s labor is:

$$
h_{j,t}=\left(\frac{W_t}{W_{j,t}}\right)^{\lambda_w/(\lambda_w-1)}H_t.
$$

Households reoptimize wages with probability \(1-\xi_w\); otherwise:

$$
W_{j,t}=\pi_{t-1}\mu_{z^{\ast}}W_{j,t-1}.
$$

## 3. First-Order Conditions

The paper states the equilibrium in terms of a linear approximation around the non-stochastic balanced-growth path. The following numbered conditions use the MMB `US_ACELt` implementation only as `implementation_cross_check` for the technical-appendix equation backbone and variable naming; they are not treated as paper-side source text.

- **(F1) Capital Euler equation, sticky-price block, needs_review**:

$$
\lambda_{z^{\ast},t+1}+\frac{1-\delta}{\tilde\rho+1-\delta}\tilde\mu_{t+1}
+\frac{\tilde\rho}{\tilde\rho+1-\delta}\tilde\rho_{t+1}
-\lambda_{z^{\ast},t}-\tilde\mu_t
=\mu_{z,t+1}+\frac{1}{1-\alpha}\mu_{\Upsilon,t+1}.
$$

- **(F2) Investment Euler equation, sticky-price block, needs_review**:

$$
-\beta\kappa(\mu_{z^{\ast}}\mu_\Upsilon)^2 i_{t+1}-\tilde\mu_t
+\kappa(\mu_{z^{\ast}}\mu_\Upsilon)^2(1+\beta)i_t
-\kappa(\mu_{z^{\ast}}\mu_\Upsilon)^2i_{t-1}
=\beta\kappa(\mu_{z^{\ast}}\mu_\Upsilon)^2\left(\mu_{z,t+1}+\frac{\mu_{\Upsilon,t+1}}{1-\alpha}\right)
-\kappa(\mu_{z^{\ast}}\mu_\Upsilon)^2\left(\mu_{z,t}+\frac{\mu_{\Upsilon,t}}{1-\alpha}\right).
$$

- **(F3) Shadow rental rate on capital, sticky-price block, needs_review**:

$$
\tilde w_t+\frac{1}{1-\alpha}\frac{\tilde y}{\tilde y+\phi}\tilde y_t
+\frac{\nu R}{\nu R+1-\nu}R_t-\tilde\rho_t-\frac{1}{1-\alpha}u_t
-\frac{1}{1-\alpha}\bar k_{t-1}
=-\frac{1}{1-\alpha}\mu_{z,t}-\frac{1}{(1-\alpha)^2}\mu_{\Upsilon,t}
+\frac{1}{1-\alpha}\epsilon_t.
$$

- **(F4) Capital evolution, sticky-price block**:

$$
(\mu_{z^{\ast}}\mu_\Upsilon-(1-\delta))i_t-\mu_\Upsilon\mu_{z^{\ast}}\bar k_t
+(1-\delta)\bar k_{t-1}
=(1-\delta)\mu_{z,t}+\frac{1-\delta}{1-\alpha}\mu_{\Upsilon,t}.
$$

- **(F5) Inflation equation with reduced-form slope \(\gamma\)**:

$$
\beta\pi_{t+1}-(1+\beta\varsigma)\pi_t+\gamma s_t=-\varsigma\pi_{t-1}.
$$

- **(F6) Marginal cost equation, sticky-price block, needs_review**:

$$
\tilde w_t-s_t+\frac{\alpha}{1-\alpha}\frac{\tilde y}{\tilde y+\phi}\tilde y_t
+\frac{\nu R}{\nu R+1-\nu}R_t-\frac{\alpha}{1-\alpha}u_t
-\frac{\alpha}{1-\alpha}\bar k_{t-1}
=-\frac{\alpha}{1-\alpha}\mu_{z,t}-\frac{\alpha}{(1-\alpha)^2}\mu_{\Upsilon,t}
+\frac{1}{1-\alpha}\epsilon_t.
$$

- **(F7) Money demand**:

$$
c_t-q_t=\frac{R}{R-1}\frac{1}{2+\sigma_\eta}R_t.
$$

- **(F8) Consumption Euler equation with habit and liquidity services, needs_review**:

$$
\begin{aligned}
&-\beta b\left(\frac{1}{\mu_{z^{\ast}}c-bc}\right)^2\mu_{z^{\ast}}c\,c_{t+1}
+A_c c_t+\lambda_{z^{\ast}}(1+\eta+\eta'V)\lambda_{z^{\ast},t}\\
&-\lambda_{z^{\ast}}(2+\sigma_\eta)\eta'V q_t
-\left(\frac{1}{c(1-b/\mu_{z^{\ast}})}\right)^2\frac{bc}{\mu_{z^{\ast}}}c_{t-1}\\
&=\beta b\left(\frac{1}{\mu_{z^{\ast}}c-bc}\right)^2\mu_{z^{\ast}}c
\left(\mu_{z,t+1}+\frac{\alpha}{1-\alpha}\mu_{\Upsilon,t+1}\right)
-B_c\left(\mu_{z,t}+\frac{\alpha}{1-\alpha}\mu_{\Upsilon,t}\right).
\end{aligned}
$$

- **(F9) Monetary-base FOC**:

$$
\lambda_{z^{\ast},t+1}-\pi_{t+1}+R_{t+1}-\lambda_{z^{\ast},t}
=\mu_{z,t+1}+\frac{\alpha}{1-\alpha}\mu_{\Upsilon,t+1}.
$$

- **(F10) Wage FOC, needs_review**:

$$
\eta_2\tilde w_{t+1}+\eta_5\pi_{t+1}
+\eta_1\tilde w_t+\eta_4\pi_t+\eta_6 h_t+\eta_7\lambda_{z^{\ast},t}
+\eta_0\tilde w_{t-1}+\bar\eta_3\pi_{t-1}
=-\eta_8\left(\mu_{z,t+1}+\frac{\alpha}{1-\alpha}\mu_{\Upsilon,t+1}\right)
-\eta_7^\mu\left(\mu_{z,t}+\frac{\alpha}{1-\alpha}\mu_{\Upsilon,t}\right).
$$

- **(F11) Capital utilization**:

$$
\frac{1}{\sigma_a}\tilde\rho_t=u_t.
$$

The flexible-price block in `US_ACELt` repeats the capital, investment, rental-rate, capital-accumulation, marginal-cost, money-demand, consumption-Euler, monetary-base, wage, production, and utilization conditions with flexible-price variables \((c_t^f,\tilde w_t^f,\lambda_{z^{\ast},t}^f,\ldots)\). Its price block sets \(s_t^f=0\), and its money-growth process is fixed at \(x_t^f=0\). Those duplicate equations are used to define the natural-output/output-gap counterpart in the implementation and are recorded in the variable table rather than re-numbered as separate paper-side FOCs.

## 4. Market Clearing & Identities

- **(F12) Loan-market clearing**:

$$
W_tH_t=x_tM_t-Q_t.
$$

- **(F13) Resource constraint, nonlinear paper form**:

$$
(1+\eta(V_t))C_t+\Upsilon_t^{-1}\left[I_t+a(u_t)\bar K_t\right]\leq Y_t.
$$

- **(F14) Resource constraint, implementation linear form, needs_review**:

$$
\begin{aligned}
&\left((1+\eta)c+\eta'c^2/q\right)c_t
+\left(1-\frac{1-\delta}{\mu_\Upsilon\mu_{z^{\ast}}}\right)\bar k\,i_t
-(\tilde y+\phi)(1-\alpha)h_t-\eta'c^2q^{-1}q_t\\
&+\left(\frac{\tilde\rho\bar k}{\mu_{z^{\ast}}\mu_\Upsilon}-(\tilde y+\phi)\alpha\right)u_t
-(\tilde y+\phi)\alpha\bar k_{t-1}
+(\tilde y+\phi)\alpha\mu_{z,t}
+\frac{(\tilde y+\phi)\alpha}{1-\alpha}\mu_{\Upsilon,t}
-(\tilde y+\phi)\epsilon_t=0.
\end{aligned}
$$

- **(F15) Money-market clearing, implementation linear form**:

$$
\tilde w_t-\frac{xm}{xm-q}m_t+h_t+\frac{q}{xm-q}q_t
=\frac{xm}{xm-q}x_t.
$$

- **(F16) Linking money-base growth to money balances**:

$$
-m_t-\pi_t+m_{t-1}+x_{t-1}
=\mu_{z,t}+\frac{\alpha}{1-\alpha}\mu_{\Upsilon,t}.
$$

- **(F17) Production function, implementation linear form, needs_review**:

$$
(\tilde y+\phi)(1-\alpha)h_t-\tilde y\,\tilde y_t
+\left((\tilde y+\phi)\alpha-\frac{\tilde\rho\bar k}{\mu_{z^{\ast}}\mu_\Upsilon}\right)u_t
+(\tilde y+\phi)\alpha\bar k_{t-1}
=(\tilde y+\phi)\alpha\mu_{z,t}
+\frac{(\tilde y+\phi)\alpha}{1-\alpha}\mu_{\Upsilon,t}
-(\tilde y+\phi)\epsilon_t.
$$

- **(F18) Final-good demand for intermediate input**:

$$
\frac{y_t(i)}{Y_t}=\left(\frac{P_t}{P_t(i)}\right)^{\lambda_f/(\lambda_f-1)}.
$$

- **(F19) Price index**:

$$
P_t=\left[\int_0^1P_t(i)^{1/(1-\lambda_f)}\,di\right]^{1-\lambda_f}.
$$

- **(F20) Aggregate wage index**:

$$
W_t=\left[\int_0^1W_{j,t}^{1/(1-\lambda_w)}\,dj\right]^{1-\lambda_w}.
$$

- **(F21) Modelbase interest-rate rule, implementation substitution**:

$$
\begin{aligned}
interest_t={}&\sum_{\ell=1}^{4}a_\ell interest_{t-\ell}
+\sum_{\ell=0}^{4}b_\ell inflationq_{t-\ell}
+\sum_{\ell=1}^{4}b^f_\ell inflationq_{t+\ell}\\
&+\sum_{\ell=0}^{4}c_\ell outputgap_{t-\ell}
+\sum_{\ell=1}^{4}c^f_\ell outputgap_{t+\ell}
+\sum_{\ell=0}^{4}d_\ell output_{t-\ell}
+\sum_{\ell=1}^{4}d^f_\ell output_{t+\ell}
+\sigma_R\varepsilon^R_t.
\end{aligned}
$$

The modelbase observables are:

$$
interest_t=4R_t,\quad inflationq_t=4\pi_t,\quad
inflation_t=\pi_t+\pi_{t-1}+\pi_{t-2}+\pi_{t-3},\quad
outputgap_t=\tilde y_t-\tilde y_t^f,\quad output_t=\tilde y_t.
$$

## 5. Exogenous Processes

- **(F22) Neutral technology growth**:

$$
\hat\mu_{z,t}=\rho_{\mu_z}\hat\mu_{z,t-1}+\varepsilon_{\mu_z,t}.
$$

- **(F23) Capital-embodied technology growth**:

$$
\hat\mu_{\Upsilon,t}=\rho_{\mu_\Upsilon}\hat\mu_{\Upsilon,t-1}+\varepsilon_{\mu_\Upsilon,t}.
$$

- **(F24) Balanced-growth technology composite**:

$$
\mu_{z^{\ast},t}=(\mu_{\Upsilon,t})^{\alpha/(1-\alpha)}\mu_{z,t}.
$$

- **(F25) Monetary growth decomposition, paper form**:

$$
\hat x_t=\hat x_{z,t}+\hat x_{\Upsilon,t}+\hat x_{M,t}.
$$

- **(F26) Monetary policy shock process, paper form**:

$$
\hat x_{M,t}=\rho_{xM}\hat x_{M,t-1}+\varepsilon_{M,t}.
$$

- **(F27) Monetary response to neutral technology, paper form**:

$$
\hat x_{z,t}=\rho_{xz}\hat x_{z,t-1}+c_z\varepsilon_{z,t}+c_z^p\varepsilon_{z,t-1}.
$$

- **(F28) Monetary response to embodied technology, paper form**:

$$
\hat x_{\Upsilon,t}=\rho_{x\Upsilon}\hat x_{\Upsilon,t-1}
+c_{\Upsilon}\varepsilon_{\Upsilon,t}+c_{\Upsilon}^p\varepsilon_{\Upsilon,t-1}.
$$

- **(F29) Additional transitory technology shock in MMB implementation, implementation_cross_check**:

$$
\epsilon_t=\rho_\epsilon\epsilon_{t-1}+\sigma_\epsilon\varepsilon^\epsilon_t.
$$

## 6. Steady-State Solution

The paper works with a balanced-growth path. Let steady-state variables omit time subscripts. The implementation cross-check uses the following steady-state ordering; it was not runtime-validated here.

1. Set calibrated growth and preference/technology parameters \(\alpha,\beta,\delta,b,\lambda_f,\lambda_w,\mu_\Upsilon,\mu_z,\nu,\psi_L,\sigma_L,x,V,\eta\).
2. Compute balanced-growth technology:

$$
\mu_{z^{\ast}}=\mu_\Upsilon^{\alpha/(1-\alpha)}\mu_z.
$$

3. Compute rental return and nominal rate:

$$
\tilde\rho=\frac{\mu_\Upsilon\mu_{z^{\ast}}}{\beta}-(1-\delta),\qquad
\pi=\frac{x}{\mu_{z^{\ast}}},\qquad
R=\frac{\pi\mu_{z^{\ast}}}{\beta}.
$$

4. Parameterize transaction costs:

$$
\eta'=\frac{R-1}{V^2},\qquad
\sigma_\eta=\frac{1}{4\epsilon(R-1)}-2.
$$

5. Compute marginal-cost and working-capital objects:

$$
s=\frac{1}{\lambda_f},\qquad
R_\nu=\nu R+1-\nu.
$$

6. Compute steady wages, capital-hours ratio, capital, hours, consumption, money balances, output, fixed cost, investment, and marginal utility using the implementation formulas:

$$
\tilde w=\frac{1-\alpha}{R_\nu}s\left(\frac{\tilde\rho}{\alpha s}\right)^{\alpha/(\alpha-1)},
\qquad
\frac{h}{\bar k}=\left(\frac{\tilde\rho}{\alpha s(\mu_{z^{\ast}}\mu_\Upsilon)^{1-\alpha}}\right)^{1/(1-\alpha)}.
$$

7. Set flexible-price steady states equal to sticky-price steady states for shared levels; flexible-price deviations are zero in the linear model.

The full algebra for \(c,\bar k,h,q,m,\tilde y,\phi,i,\lambda_{z^{\ast}}\) follows the MMB implementation and should be rechecked against the original technical appendix before any runnable promotion. Runtime validation is recorded as not performed.

## 7. Timing & Form Conventions

- **Form**: MMB implementation is `model(linear)`. Variables such as `c_t`, `pi_t`, `i_t`, and `ytilde_t` are deviations from the stationary balanced-growth representation, not nonlinear levels.
- **Technology timing for `US_ACELt`**: implementation comments state "Technology shock, agents' decisions, monetary policy shock." This is the reason `US_ACELt` is appropriate for neutral and investment-specific technology shocks but not for monetary policy shocks.
- **Capital timing**: physical capital is predetermined within the period. In the implementation, `kbar_t1(-1)` enters production, rental-rate, marginal-cost, and resource equations, while `kbar_t1` is determined by the capital accumulation equation.
- **Firm-specific capital**: the paper's preferred micro interpretation is that each intermediate firm owns its beginning-of-period capital and adjusts it over time via firm-level investment.
- **Flexible-price counterpart**: variables with suffix `f` define the flexible-price allocation used for output gap construction.
- **Policy rule**: the paper's money-growth process is replaced in the MMB modelbase file by a modelbase interest-rate rule. This is an implementation substitution, not a paper-side derivation result.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII name | Meaning | Equation reference |
|---|---|---|---|
| Endogenous | `c_t`, `cf_t` | sticky/flexible consumption deviation | (F8), (F13), flexible block |
| Endogenous | `wtilde_t`, `wtildef_t` | scaled real wage | (F3), (F6), (F10), (F15) |
| Endogenous | `lambda_zstar_t`, `lambda_zstarf_t` | marginal utility/shadow value scaled by \(z^{\ast}\) | (F1), (F8), (F9) |
| Endogenous | `m_t`, `mf_t` | money balances | (F15), (F16) |
| Endogenous | `pi_t`, `pif_t` | inflation deviation | (F5), (F9), (F16), (F21) |
| Endogenous | `x_t`, `xf_t` | money growth / policy process | (F16), (F25)-(F28) |
| Endogenous | `s_t`, `sf_t` | marginal cost | (F5), (F6) |
| Endogenous | `i_t`, `if_t` | investment deviation | (F2), (F4), (F14) |
| Endogenous | `h_t`, `hf_t` | hours | (F10), (F14), (F15), (F17) |
| Endogenous | `kbar_t1`, `kbarf_t1` | end-of-period physical capital stock | (F4), (F17) |
| Endogenous | `q_t`, `qf_t` | real transaction balances / liquidity variable | (F7), (F8), (F15) |
| Endogenous | `ytilde_t`, `ytildef_t` | output deviation | (F3), (F6), (F17), (F21) |
| Endogenous | `R_t`, `Rf_t` | interest-rate deviation | (F3), (F7), (F9), (F21) |
| Endogenous | `mutilde_t`, `mutildef_t` | shadow value of installed capital | (F1), (F2) |
| Endogenous | `rhotilde_t`, `rhotildef_t` | rental return on capital | (F1), (F3), (F11) |
| Endogenous | `u_t`, `uf_t` | capital utilization | (F3), (F6), (F11), (F14), (F17) |
| Endogenous | `x_M_t`, `x_z_t`, `x_ups_t` | monetary-policy and technology-response money-growth components | (F25)-(F28) |
| Endogenous | `eps_M_t`, `eps_muz_t`, `eps_muups_t` | one-period shock states in implementation | (F22), (F23), (F26)-(F28) |
| Endogenous | `mu_z_t`, `mu_ups_t` | neutral and embodied technology growth deviations | (F22), (F23) |
| Endogenous | `epsilon_t` | additional transitory technology state in MMB implementation | (F29) |
| Modelbase | `interest`, `inflation`, `inflationq`, `outputgap`, `output` | observable/modelbase variables | (F21) |
| Exogenous | `epsilon_M_` | monetary policy innovation | (F26) |
| Exogenous | `eps_muz_` | neutral technology innovation | (F22), (F27) |
| Exogenous | `eps_muups_` | capital-embodied technology innovation | (F23), (F28) |
| Exogenous | `epsilon_t_` | transitory technology innovation in MMB implementation | (F29) |
| Parameter | `alpha`, `beta`, `delta`, `b`, `lambda_f`, `lambda_w` | capital share, discounting, depreciation, habit, goods and labor markups | (F1)-(F24) |
| Parameter | `mu_ups`, `mu_z`, `mu_zstar`, `x` | balanced-growth and money-growth steady states | (F24), steady state |
| Parameter | `nu`, `psi_L`, `sigma_L`, `V`, `eta`, `eta_pr`, `sig_eta` | working-capital, labor, velocity, and transaction-cost parameters | (F7), (F8), (F10) |
| Parameter | `kappa`, `sigma_a`, `gamma`, `squig` | investment adjustment cost, utilization curvature, Phillips-curve slope, price-indexation coefficient | (F2), (F5), (F11) |
| Parameter | `rho_M`, `theta_M`, `rho_muz`, `theta_muz`, `rho_muups`, `theta_muups`, `rho_epsilon` | shock persistence and moving-average coefficients | (F22), (F23), (F26)-(F29) |
| Parameter | `c_z`, `cp_z`, `rho_xz`, `c_ups`, `cp_ups`, `rho_xups` | money-growth responses to technology shocks | (F27), (F28) |
| Parameter | `cofint*`, `std_r_` | modelbase interest-rule coefficients loaded from `policy_param.mat` | (F21) |
