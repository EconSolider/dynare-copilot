# EA_SR07 - Derivation Archive Entry

> Status: needs_review. This first-pass entry is based on the MinerU Markdown source, not on the PDF body. The paper Markdown contains the compact published model description but not the separate 2006 appendix referenced by the paper, so several appendix-level FOCs are recorded as deferred source checks. The `.mod` file is used only as an implementation cross-check for variable names and linear form.

Source: Adolfson, Malin; Laseen, Stefan; Linde, Jesper; Villani, Mattias (2007), "Bayesian estimation of an open economy DSGE model with incomplete pass-through," *Journal of International Economics* 72, 481-511. DOI: `10.1016/j.jinteco.2007.01.003`.

## 1. Model Overview

- **Model ID**: `EA_SR07`.
- **Economy**: estimated Euro-area small open economy DSGE model.
- **Core structure**: Christiano-Eichenbaum-Evans-style medium-scale DSGE model extended with imported consumption and investment goods, export demand, incomplete exchange-rate pass-through, sticky domestic/import/export prices, sticky wages, habit persistence, investment adjustment costs, variable capital utilization, money balances, working-capital financing, fiscal and foreign VAR blocks, and a time-varying inflation target.
- **Form**: log-linearized model. The paper explicitly presents several relations in hat variables, and the MMB implementation cross-check uses `model(linear)`.
- **Shocks**: unit-root technology growth, stationary technology, investment-specific technology, consumption preference, labor supply, domestic/import/export markup, risk premium, monetary policy, inflation target, asymmetric foreign technology, fiscal VAR innovations, and foreign VAR innovations.
- **Runtime validation**: not performed.

## 2. Optimization Problems

### Final Domestic-Good Aggregator

The final domestic good is a CES composite of differentiated intermediate goods:

**(F1) Domestic CES aggregator**
$$
Y_t=\left[\int_0^1 (Y_{i,t})^{1/\lambda_t^d}\,di\right]^{\lambda_t^d},
\qquad 1\leq \lambda_t^d<\infty .
$$

### Intermediate Domestic Firms

Intermediate firm `i` produces with capital services and homogeneous labor:

**(F2) Intermediate production**
$$
Y_{i,t}=z_t^{1-\alpha}\epsilon_t K_{i,t}^{\alpha}H_{i,t}^{1-\alpha}-z_t\phi .
$$

Working capital requires firms to finance a fraction `nu` of the wage bill before production. Cost minimization gives nominal marginal cost:

**(F3) Domestic nominal marginal cost**
$$
MC_t^d=
\frac{1}{(1-\alpha)^{1-\alpha}\alpha^\alpha}
\,(R_t^k)^\alpha
\left[W_t\left(1+\nu(R_{t-1}-1)\right)\right]^{1-\alpha}
\frac{1}{z_t^{1-\alpha}}
\frac{1}{\epsilon_t}.
$$

needs_review: the Markdown OCR/source equation uses multiplicative factors; the displayed formula above keeps the source ordering but should be checked against the PDF because line breaks can obscure multiplication.

### Importers And Exporters

Importing firms buy the homogeneous foreign good and brand it into differentiated import-consumption or import-investment goods. Exporting firms buy the domestic final good and brand it into differentiated export goods. Their local-currency pricing problems are Calvo problems analogous to the domestic-price problem.

**(F4) Import and export CES aggregators**
$$
C_t^m=\left[\int_0^1(C_{i,t}^m)^{1/\lambda_t^{mc}}\,di\right]^{\lambda_t^{mc}},
\quad
I_t^m=\left[\int_0^1(I_{i,t}^m)^{1/\lambda_t^{mi}}\,di\right]^{\lambda_t^{mi}},
\quad
X_t=\left[\int_0^1(X_{i,t})^{1/\lambda_t^x}\,di\right]^{\lambda_t^x}.
$$

### Households

Household `j` chooses consumption, labor, money balances, domestic bonds, foreign bonds, investment, capital, and utilization subject to a standard budget constraint and the capital accumulation law. The source states the utility function:

**(F5) Household utility**
$$
E_0^j\sum_{t=0}^{\infty}\beta^t
\left[
\zeta_t^c\ln(C_{j,t}-bC_{j,t-1})
-\zeta_t^h A_L\frac{h_{j,t}^{1+\sigma_L}}{1+\sigma_L}
+A_q\frac{\left(Q_{j,t}/(z_tP_t^d)\right)^{1-\sigma_q}}{1-\sigma_q}
\right].
$$

Aggregate consumption and investment combine domestic and imported goods:

**(F6) Consumption aggregator**
$$
C_t=\left[
(1-\omega_c)^{1/\eta_c}(C_t^d)^{(\eta_c-1)/\eta_c}
+\omega_c^{1/\eta_c}(C_t^m)^{(\eta_c-1)/\eta_c}
\right]^{\eta_c/(\eta_c-1)}.
$$

**(F7) Investment aggregator**
$$
I_t=\left[
(1-\omega_i)^{1/\eta_i}(I_t^d)^{(\eta_i-1)/\eta_i}
+\omega_i^{1/\eta_i}(I_t^m)^{(\eta_i-1)/\eta_i}
\right]^{\eta_i/(\eta_i-1)}.
$$

Physical capital becomes productive with a one-period delay, while utilization converts physical capital into capital services:

**(F8) Capital accumulation**
$$
\bar K_{t+1}=(1-\delta)\bar K_t+\mathcal{Y}_t\left(1-\tilde S(I_t/I_{t-1})\right)I_t,
\qquad K_t=u_t\bar K_t .
$$

Foreign bond holdings face a debt-elastic risk premium:

**(F9) Foreign bond premium**
$$
\Phi(a_t,\tilde\phi_t)=
\exp\left[-\tilde\phi_a(a_t-\bar a)+\tilde\phi_t\right],
\qquad
a_t\equiv \frac{S_tB_t^*}{P_tz_t}.
$$

### Wage Setting

Households are monopoly suppliers of differentiated labor services. Wages follow Calvo stickiness and indexation to lagged CPI inflation, the current inflation target, and permanent technology growth. The source describes the wage-setting problem but does not print the full wage Phillips curve in Section 2; the MMB `.mod` cross-check labels it as equation B5.

### Central Bank

The central bank follows an empirical instrument rule rather than an optimizing loss function.

## 3. First-Order Conditions

### Price Setting

The domestic Calvo pricing FOC is given in log-linearized form:

**(F10) Domestic-price Phillips curve**
$$
\begin{aligned}
\hat\pi_t^d-\hat{\bar\pi}_t^c
&=\frac{\beta}{1+\kappa_d\beta}\left(E_t\hat\pi_{t+1}^d-\rho_\pi\hat{\bar\pi}_t^c\right)
+\frac{\kappa_d}{1+\kappa_d\beta}\left(\hat\pi_{t-1}^d-\hat{\bar\pi}_t^c\right) \\
&\quad-\frac{\kappa_d\beta(1-\rho_\pi)}{1+\kappa_d\beta}\hat{\bar\pi}_t^c
+\frac{(1-\xi_d)(1-\beta\xi_d)}{\xi_d(1+\kappa_d\beta)}
\left(\widehat{mc}_t^d+\hat\lambda_t^d\right).
\end{aligned}
$$

Import-consumption, import-investment, and export price Phillips curves are stated to have the same structure as the domestic curve:

**(F11) Generic local-currency Phillips curve for sector `j`**
$$
\begin{aligned}
\hat\pi_t^j-\hat{\bar\pi}_t^c
&=\frac{\beta}{1+\kappa_j\beta}\left(E_t\hat\pi_{t+1}^j-\rho_\pi\hat{\bar\pi}_t^c\right)
+\frac{\kappa_j}{1+\kappa_j\beta}\left(\hat\pi_{t-1}^j-\hat{\bar\pi}_t^c\right) \\
&\quad-\frac{\kappa_j\beta(1-\rho_\pi)}{1+\kappa_j\beta}\hat{\bar\pi}_t^c
+\frac{(1-\xi_j)(1-\beta\xi_j)}{\xi_j(1+\kappa_j\beta)}
\left(\widehat{mc}_t^j+\hat\lambda_t^j\right),
\qquad j\in\{mc,mi,x\}.
\end{aligned}
$$

needs_review: the published article states the analogous structure but does not print three separate sector equations; sector-specific marginal-cost definitions were cross-checked against `.mod` names only.

### Household And Capital FOCs

The paper refers to the household budget constraint as standard but does not print all household FOCs in Section 2. The following FOCs are therefore source-backed at the block level and require appendix/PDF review for formula-level confirmation:

**(F12) Consumption Euler equation, log-linear implementation form**
$$
\hat c_t =
-\frac{1}{\mu_z^2+b^2\beta}
\left[
-b\beta\mu_z\hat c_{t+1}
-b\mu_z\hat c_{t-1}
+b\mu_z(\hat\mu_{z,t}-\beta\hat\mu_{z,t+1})
+(\mu_z-b\beta)(\mu_z-b)\hat\psi_{z,t}
+\frac{\tau_c}{1+\tau_c}(\mu_z-b\beta)(\mu_z-b)\hat\tau_{c,t}
+(\mu_z-b\beta)(\mu_z-b)\hat\gamma_{cd,t}
\right]+\zeta_{c,t}.
$$

needs_review: formula is from implementation cross-check B6 and should be verified against the paper appendix before review status is upgraded.

**(F13) Investment FOC with adjustment costs, log-linear implementation form**
$$
\hat i_t=
\frac{\mu_z^2\tilde S(\hat i_{t-1}+\beta\hat i_{t+1}-\hat\mu_{z,t}+\beta\hat\mu_{z,t+1})
+\hat P_{k,t}-\hat\gamma_{id,t}}
{\mu_z^2\tilde S(1+\beta)}
+\Upsilon_t .
$$

needs_review: formula is from implementation cross-check B7 and should be verified against the paper appendix.

**(F14) Capital-return FOC, log-linear implementation form**
$$
\hat\psi_{z,t}+\hat\mu_{z,t+1}-\hat\psi_{z,t+1}
-\frac{\beta(1-\delta)}{\mu_z}\hat P_{k,t+1}
+\hat P_{k,t}
-\frac{\mu_z-\beta(1-\delta)}{\mu_z}\hat r^k_{t+1}
+\frac{\tau_k}{1-\tau_k}\frac{\mu_z-\beta(1-\delta)}{\mu_z}\hat\tau_{k,t+1}=0 .
$$

needs_review: formula is from implementation cross-check B9 and should be verified against the paper appendix.

**(F15) Real-balances FOC, log-linear implementation form**
$$
-\mu\hat\psi_{z,t}+\mu\hat\psi_{z,t+1}-\mu\hat\mu_{z,t+1}
+(\mu-\beta\tau_k)\hat R_t-\mu\hat\pi_{t+1}
+\frac{\tau_k}{1-\tau_k}(\beta-\mu)\hat\tau_{k,t+1}=0 .
$$

needs_review: formula is from implementation cross-check B8 and should be verified against the paper appendix.

**(F16) Wage Phillips curve, implementation cross-check placeholder**
$$
\hat{\bar w}_t=\mathcal{W}\left(
\hat{\bar w}_{t-1},E_t\hat{\bar w}_{t+1},\hat\pi_t,\hat\pi_{t+1},
\hat\pi_t^c,\hat\pi_{t-1}^c,\hat{\bar\pi}_t^c,\hat\psi_{z,t},\hat H_t,
\hat\tau_{y,t},\hat\tau_{w,t},\zeta_{h,t}
\right).
$$

needs_review: the Section 2 Markdown describes Calvo wage setting but not the printed wage equation; the placeholder records the state variables identified by the `.mod` B5 equation without asserting source-level formula verification.

### Monetary Policy And Open-Economy Arbitrage

**(F17) Monetary policy rule**
$$
\hat R_t=\rho_R\hat R_{t-1}
+(1-\rho_R)\left[
\hat{\pi}_t^c+r_\pi(\hat{\pi}_{t-1}^c-\hat{\bar{\pi}}_t^c)
+r_y\hat y_{t-1}+r_x\hat x_{t-1}
\right]
+r_{\Delta\pi}\Delta\hat\pi_t^c
+r_{\Delta y}\Delta\hat y_t+\varepsilon_{R,t}.
$$

needs_review: the source OCR around the inflation-target term is imperfect; compare with PDF before final review.

**(F18) UIP condition with debt-elastic premium**
$$
E_t\Delta \hat S_{t+1}-(\hat R_t-\hat R_t^*)-\phi_a\hat a_t+\tilde\phi_t=0 .
$$

needs_review: the paper states the premium and describes the arbitrage condition but does not print the UIP equation in Section 2; this expression follows the implementation cross-check B10.

## 4. Market Clearing & Identities

**(F19) Export demand**
$$
C_t^x=\left(\frac{P_t^x}{P_t^*}\right)^{-\eta_f}C_t^*,
\qquad
I_t^x=\left(\frac{P_t^x}{P_t^*}\right)^{-\eta_f}I_t^* .
$$

**(F20) Relative import/export prices, log-linear implementation form**
$$
\hat\gamma_{mcd,t}=\hat\gamma_{mcd,t-1}+\hat\pi_t^{mc}-\hat\pi_t^d,
\quad
\hat\gamma_{mid,t}=\hat\gamma_{mid,t-1}+\hat\pi_t^{mi}-\hat\pi_t^d,
\quad
\hat\gamma_{x*,t}=\hat\gamma_{x*,t-1}+\hat\pi_t^x-\hat\pi_t^* .
$$

**(F21) Real exchange rate and export marginal cost identities**
$$
\widehat{mc}_{x,t}=\widehat{mc}_{x,t-1}+\hat\pi_t^d-\hat\pi_t^x-\Delta\hat S_t,
\qquad
\hat x_t=-\omega_c\gamma_{cmc}^{-(1-\eta_c)}\hat\gamma_{mcd,t}
-\hat\gamma_{x*,t}-\widehat{mc}_{x,t}.
$$

**(F22) CPI inflation**
$$
\hat\pi_t^c=
(1-\omega_c)\gamma_{dc}^{1-\eta_c}\hat\pi_t^d
+\omega_c\gamma_{mcc}^{1-\eta_c}\hat\pi_t^{mc}.
$$

**(F23) Output definition**
$$
\hat y_t=\lambda_d\left[\epsilon_t+\alpha(\hat k_t-\hat\mu_{z,t})+(1-\alpha)\hat H_t\right].
$$

**(F24) Aggregate resource constraint, log-linear implementation form**
$$
\begin{aligned}
&(1-\omega_c)\gamma_{cd}^{\eta_c}\frac{c}{\bar y}(\hat c_t+\eta_c\hat\gamma_{cd,t})
+(1-\omega_i)\gamma_{id}^{\eta_i}\frac{i}{\bar y}(\hat i_t+\eta_i\hat\gamma_{id,t})
+g_r\hat g_t \\
&\quad+\frac{y^*}{\bar y}(\hat y_t^*-\eta_f\hat\gamma_{x*,t}+\tilde z_t^*)
=\lambda_d\left[\epsilon_t+\alpha(\hat k_t-\hat\mu_{z,t})+(1-\alpha)\hat H_t\right]
-\frac{(1-\tau_k)r_k\bar k}{\bar y\mu_z}(\hat k_t-\hat{\bar k}_{t-1}) .
\end{aligned}
$$

needs_review: formula is from implementation cross-check B11 and should be verified against the appendix.

## 5. Exogenous Processes

The paper states a univariate AR(1) representation for structural shocks:

**(F25) Generic structural shock process**
$$
\hat\varsigma_t=\rho_\varsigma\hat\varsigma_{t-1}+\varepsilon_{\varsigma,t},
\qquad
\varepsilon_{\varsigma,t}\stackrel{iid}{\sim}N(0,\sigma_\varsigma^2),
$$
where
$$
\varsigma_t\in\{\mu_{z,t},\epsilon_t,\lambda_t^j,\zeta_t^c,\zeta_t^h,\gamma_t,
\tilde\phi_t,\varepsilon_{R,t},\hat{\bar\pi}_t^c,\hat z_t^*\},
\qquad j\in\{d,mc,mi,x\}.
$$

**(F26) Fiscal VAR block**
$$
\hat f_t=A_{f,1}\hat f_{t-1}+A_{f,2}\hat f_{t-2}+B_f\varepsilon_{f,t},
\qquad
\hat f_t=(\hat\tau_t^k,\hat\tau_t^w,\hat\tau_t^y,\hat\tau_t^c,\hat g_t)' .
$$

needs_review: the paper states that fiscal variables follow an identified two-lag VAR; coefficient matrices are implementation/calibration data rather than paper-side equation extraction.

**(F27) Foreign VAR block**
$$
\hat f_t^*=A_{*,1}\hat f_{t-1}^*+A_{*,2}\hat f_{t-2}^*
+A_{*,3}\hat f_{t-3}^*+A_{*,4}\hat f_{t-4}^*+B_*\varepsilon_{*,t},
\qquad
\hat f_t^*=(\hat\pi_t^*,\hat y_t^*,\hat R_t^*)' .
$$

needs_review: the paper states that foreign prices, output, and interest rate are exogenous and follow an identified four-lag VAR.

## 6. Steady-State Solution

The paper calibrates steady-state-related parameters to observed sample means and reports implied steady-state values, but the Markdown source does not include the appendix derivation. The following relationships were identified from the implementation cross-check and remain `needs_review` until checked against the appendix/PDF.

1. Inflation, technology growth, and nominal interest:
$$
\pi=\frac{\mu}{\mu_z},
\qquad
R=\frac{\pi\mu_z-\tau_k\beta}{(1-\tau_k)\beta},
\qquad
R_f=\nu R+1-\nu .
$$

2. Import-sector substitution elasticities and relative-price constants:
$$
\eta_{mc}=\frac{\lambda_{mc}}{\lambda_{mc}-1},
\qquad
\eta_{mi}=\frac{\lambda_{mi}}{\lambda_{mi}-1}.
$$

3. Consumption and investment composite constants:
$$
\gamma_{id}=\left[(1-\omega_i)+\omega_i\left(\frac{\eta_{mi}}{\eta_{mi}-1}\right)^{1-\eta_i}\right]^{1/(1-\eta_i)},
\quad
\gamma_{cd}=\left[(1-\omega_c)+\omega_c\left(\frac{\eta_{mc}}{\eta_{mc}-1}\right)^{1-\eta_c}\right]^{1/(1-\eta_c)}.
$$

4. Capital rental, wage, capital-labor ratio, and quantities are then solved recursively from the steady-state capital FOC, firm cost minimization, labor supply, resource constraint, and accumulation equations.

5. For the linearized model, the solved steady state is the expansion point; hatted variables have zero steady-state deviation.

## 7. Timing & Form Conventions

- **Linear form**: hatted variables are log deviations from steady state. The MMB implementation confirms `model(linear)`.
- **Trend handling**: the unit-root technology level `z_t` induces common growth; stationary transformed variables use `mu_z,t=z_t/z_{t-1}`.
- **Capital timing**: physical capital chosen in period `t` becomes productive with a one-period delay in the accumulation equation for `\bar K_{t+1}`. Capital services satisfy `K_t=u_t\bar K_t`, and the implementation cross-check uses lagged physical capital in utilization and resource identities.
- **Open-economy timing**: UIP uses expected exchange-rate change and contemporaneous domestic/foreign interest-rate differentials; exact dating requires appendix/PDF verification.
- **Price-setting timing**: Calvo price and wage equations include expected future inflation and lagged indexed prices/wages.
- **Review status**: formulas derived only from the `.mod` implementation are marked `needs_review` and should not be treated as source-level paper equations.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII name | Meaning | Main equation(s) |
|---|---|---|---|
| Endogenous | `Y`, `y_hat` | domestic output | F1, F2, F23, F24 |
| Endogenous | `C`, `c_hat` | aggregate consumption | F5, F6, F12, F24 |
| Endogenous | `I`, `i_hat` | aggregate investment | F7, F8, F13, F24 |
| Endogenous | `C_d`, `C_m` | domestic and imported consumption | F6 |
| Endogenous | `I_d`, `I_m` | domestic and imported investment | F7 |
| Endogenous | `X`, `C_x`, `I_x` | exports and foreign demand components | F4, F19 |
| Endogenous | `K`, `k_hat`, `k_barhat`, `u` | capital services, physical capital, utilization | F2, F8, F14 |
| Endogenous | `H`, `H_hat`, `E` | labor input and employment | F2, F16 |
| Endogenous | `W`, `w_barhat` | wage | F3, F16 |
| Endogenous | `MC_d`, `mc` | domestic marginal cost | F3, F10 |
| Endogenous | `mc_mc`, `mc_mi`, `mc_x` | import/export marginal costs | F11, F21 |
| Endogenous | `pi_hat`, `pi_mc`, `pi_mi`, `pi_x`, `pi_c` | domestic, import, export, CPI inflation | F10, F11, F22 |
| Endogenous | `R_hat`, `Rstar_hat`, `dS`, `x` | policy rate, foreign rate, exchange rate change, real exchange rate | F17, F18, F21 |
| Endogenous | `a` | net foreign assets | F9, F18 |
| Endogenous | `P_k`, `rk_hat`, `psi_zhat`, `q_hat`, `m_barhat`, `mu_hat` | capital price, rental rate, marginal utility, money and balances | F14, F15 |
| Exogenous | `epsilon_muz`, `epsilon_epsilon`, `epsilon_Upsilon` | technology-growth, stationary technology, investment-specific shocks | F25 |
| Exogenous | `epsilon_lambdad`, `epsilon_lambdamc`, `epsilon_lambdami`, `epsilon_lambdax` | markup innovations | F25 |
| Exogenous | `epsilon_zetac`, `epsilon_zetah`, `epsilon_phitilde`, `epsilon_R`, `epsilon_pibar` | preference, labor, risk-premium, monetary, inflation-target innovations | F17, F25 |
| Exogenous | `epsilon_tauk`, `epsilon_tauw`, `epsilon_tauc`, `epsilon_tauy`, `epsilon_rhog` | fiscal shocks | F26 |
| Exogenous | `epsilon_pistar`, `epsilon_ystar`, `epsilon_Rstar` | foreign VAR shocks | F27 |
| Parameter | `beta`, `alpha`, `delta`, `b`, `sigma_L`, `A_L`, `A_q` | discounting, production, depreciation, habit, labor/money preference | F2, F5, F8, F12 |
| Parameter | `omega_c`, `omega_i`, `eta_c`, `eta_i`, `eta_f` | import shares and substitution elasticities | F6, F7, F19 |
| Parameter | `xi_d`, `xi_mc`, `xi_mi`, `xi_x`, `xi_w`, `kappa_d`, `kappa_mc`, `kappa_mi`, `kappa_x`, `kappa_w` | Calvo and indexation parameters | F10, F11, F16 |
| Parameter | `lambda_d`, `lambda_mc`, `lambda_mi`, `lambda_x`, `lambda_w` | steady markups | F1, F4, F10, F11 |
| Parameter | `rho_R`, `rho_pi`, `rho_y`, `rho_x`, `rho_dpi`, `rho_dy`, `rho_pibar` | policy-rule and inflation-target parameters | F17 |
| Parameter | `rho_*`, `sigma_*` | AR coefficients and shock standard deviations | F25, F26, F27 |
| Parameter | `tau_k`, `tau_y`, `tau_c`, `tau_w`, `nu`, `phi_a`, `mu_z`, `mu` | taxes, working capital, risk-premium slope, growth and money growth | F3, F9, F15, F18 |
