# ESREA_FIMOD12 -- Derivation (Optimization Problems + First-Order Conditions)

> This first-pass derivation is for private model-archive extraction. It summarizes equations and model structure from Stahler and Thomas (2012), "FiMod--A DSGE model for fiscal policy simulations." Formula-level status: `needs_review`.

## 1. Model Overview

- **Model**: `ESREA_FIMOD12`, FiMod, a medium-scale DSGE model for fiscal policy simulations in a two-country monetary union.
- **Source**: Stahler, Nikolai; Thomas, Carlos (2012), *Economic Modelling* 29, 239-261, DOI `10.1016/j.econmod.2011.10.001`.
- **Economy**: home country calibrated to Spain and foreign block calibrated to the rest of the euro area. Population shares are $\omega$ and $1-\omega$.
- **Agents and blocks**: optimizing and rule-of-thumb households, retailers, monopolistically competitive intermediate goods producers, labor firms with search and matching frictions, national fiscal authorities, and a union-wide monetary authority.
- **Fiscal detail**: public purchases, public investment, public wages, public employment, transfers/subsidies, public debt, and taxes on consumption, labor income, social security contributions, capital income, and bond returns.
- **Form**: nonlinear DSGE. The MMB implementation is written as a nonlinear Dynare model with symmetric foreign-country equations prefixed by `f`. Runtime validation was not performed.
- **Source note**: the first 80 Markdown lines match the expected title and authors. No source-index mismatch was found.

## 2. Optimization Problems

### 2.1 Households

Both household types have period utility over habit-adjusted private consumption and government services:

$$
E_0\sum_{t=0}^{\infty}\beta^t u(c_t^i,c_{t-1}^i,\tilde g_t),\qquad i\in\{o,r\}.
$$

For $\sigma_c\ne 1$,

$$
u(c_t^i,c_{t-1}^i,\tilde g_t)=
\frac{(c_t^i-hc_{t-1}^i)^{1-\sigma_c}-1}{1-\sigma_c}
+\zeta\frac{\tilde g_t^{1-\sigma_c}-1}{1-\sigma_c}.
$$

Optimizing households choose consumption, investment, capital, domestic bonds, and international bonds subject to their real budget constraint, capital accumulation, and no-Ponzi conditions. Rule-of-thumb households cannot save or borrow and consume disposable labor and unemployment income each period.

### 2.2 Retailers and Intermediate Goods Producers

Retailers bundle differentiated intermediate goods under CES technology and choose input demand. Intermediate producers minimize factor costs subject to a Cobb-Douglas technology using private capital, public capital, and labor services. Price-setting firms reoptimize under Calvo pricing.

### 2.3 Labor Firms and Wage Bargaining

Labor firms post vacancies, match with searching workers, and produce homogeneous labor services. Private wages are set by staggered union-firm Nash bargaining. Government wages and employment are fiscal instruments rather than private optimizing choices.

### 2.4 Fiscal and Monetary Authorities

Fiscal authorities obey government budget constraints and instrument rules. The union monetary authority follows a nonlinear Taylor-type rule for the common ECB rate using union-weighted inflation and output growth.

## 3. First-Order Conditions

The equations below record the home-country block. The foreign country is structurally analogous, with starred notation in the paper and `f` prefixes in the implementation cross-check.

- **(F1) Optimizing household marginal utility of income**:
$$
\lambda_t^o=
\frac{(c_t^o-hc_{t-1}^o)^{-\sigma_c}
-\beta h E_t[(c_{t+1}^o-hc_t^o)^{-\sigma_c}]}
{1+\tau_t^c}.
$$

- **(F2) Domestic bond Euler equation**:
$$
\lambda_t^o=\beta E_t\left[
\lambda_{t+1}^o
\frac{R_t(1-\tau_{t+1}^b)+\tau_{t+1}^b}{\pi_{t+1}}
\right].
$$

- **(F3) Capital Euler equation**:
$$
Q_t=\beta E_t\left[
\frac{\lambda_{t+1}^o}{\lambda_t^o}
\left((1-\delta^k)Q_{t+1}+(1-\tau_{t+1}^k)r_{t+1}^k+\tau_{t+1}^k\delta^k\right)
\right].
$$

- **(F4) Investment/Tobin's Q condition** (`needs_review`: MinerU OCR drops part of the exponent in the adjustment-cost term):
$$
1=Q_t\left[1-S(I_t^o/I_{t-1}^o)-I_t^o S'(I_t^o/I_{t-1}^o)\right]
+\beta E_t\left[
\frac{\lambda_{t+1}^o}{\lambda_t^o}Q_{t+1}
\left(\frac{I_{t+1}^o}{I_t^o}\right)^2
S'(I_{t+1}^o/I_t^o)
\right].
$$

- **(F5) International bond Euler equation**:
$$
\lambda_t^o=\beta R_t^{ecb}\exp\left[-\psi_d(d_t-\bar d)/Y_t\right]
E_t\left[\frac{\lambda_{t+1}^o}{\pi_{t+1}}\right].
$$

- **(F6) Rule-of-thumb household budget constraint**:
$$
(1+\tau_t^c)c_t^r=(1-\tau_t^w)(w_t^p n_t^{p,r}+w_t^g n_t^{g,r})
+(1-n_t^{p,r}-n_t^{g,r})\kappa^B.
$$

- **(F7) Rule-of-thumb marginal utility**:
$$
\lambda_t^r=
\frac{(c_t^r-hc_{t-1}^r)^{-\sigma_c}
-\beta h E_t[(c_{t+1}^r-hc_t^r)^{-\sigma_c}]}
{1+\tau_t^c}.
$$

- **(F8) Retail CES demand for intermediate variety $j$**:
$$
y_t(j)=\left(\frac{P_{At}(j)}{P_{At}}\right)^{-\varepsilon}Y_t.
$$

- **(F9) Producer price index**:
$$
P_{At}=\left(\int_0^\omega \frac{1}{\omega}P_{At}(j)^{1-\varepsilon}dj\right)^{1/(1-\varepsilon)}.
$$

- **(F10) Intermediate-goods production and price dispersion**:
$$
Y_tD_t=A_t(k_{t-1}^g)^\eta k_{t-1}^{\alpha}L_t^{1-\alpha}.
$$

- **(F11) Rental rate of private capital**:
$$
r_t^k=mc_t\alpha\frac{Y_t}{k_{t-1}}.
$$

- **(F12) Labor-service price**:
$$
x_t=mc_t(1-\alpha)\frac{Y_t}{L_t}.
$$

- **(F13) Calvo optimal-price condition** (`needs_review`: compact infinite-sum condition summarized into recursive implementation form):
$$
\tilde p_t=\frac{\varepsilon}{\varepsilon-1}\frac{q_{1,t}}{q_{2,t}}.
$$

- **(F14) Calvo numerator recursion**:
$$
q_{1,t}=\lambda_t^oY_tmc_t+\theta_P\beta E_t[\pi_{A,t+1}^{\varepsilon}q_{1,t+1}].
$$

- **(F15) Calvo denominator recursion**:
$$
q_{2,t}=\lambda_t^oY_tp_{B,t}^{-(1-\omega-\psi)}
+\theta_P\beta E_t[\pi_{A,t+1}^{\varepsilon-1}q_{2,t+1}].
$$

- **(F16) PPI inflation law**:
$$
1=\theta_P\pi_{A,t}^{\varepsilon-1}+(1-\theta_P)\tilde p_t^{1-\varepsilon}.
$$

- **(F17) Price dispersion law**:
$$
D_t=(1-\theta_P)\tilde p_t^{-\varepsilon}
+\theta_P\pi_{A,t}^{\varepsilon}D_{t-1}.
$$

- **(F18) CPI inflation from PPI inflation and terms of trade**:
$$
\pi_t=\pi_{A,t}\left(\frac{p_{B,t}}{p_{B,t-1}}\right)^{1-\omega-\psi}.
$$

- **(F19) Searching-worker pool**:
$$
\tilde U_t=U_{t-1}+s^pN_{t-1}^p+s^gN_{t-1}^g.
$$

- **(F20) Sectoral matching functions**:
$$
M_t^f=\kappa_e^f(\tilde U_t)^{\phi^f}(v_t^f)^{1-\phi^f},\qquad f\in\{p,g\}.
$$

- **(F21) Job-finding and vacancy-filling probabilities**:
$$
p_t^f=\frac{M_t^f}{\tilde U_t},\qquad q_t^f=\frac{M_t^f}{v_t^f}.
$$

- **(F22) Sectoral employment law of motion**:
$$
N_t^f=(1-s^f)N_{t-1}^f+p_t^f\tilde U_t,\qquad f\in\{p,g\}.
$$

- **(F23) Unemployment identity**:
$$
U_t=1-N_t^{tot},\qquad N_t^{tot}=N_t^p+N_t^g.
$$

- **(F24) Vacancy free-entry condition**:
$$
\frac{\kappa_v^p}{q_t^p}+\kappa_{tc}
=(1-\theta_w^n)J_t(\tilde W_t^p)+\theta_w^nJ_t(W_{t-1}^p).
$$

- **(F25) Union-firm Nash sharing rule** (`needs_review`: source expression has OCR noise in tax-rate notation):
$$
\Omega_t=\frac{\xi}{1-\xi}\cdot
\frac{\mathcal A_t^w}{\mathcal A_t^{sc}}\cdot J_t(\tilde W_t^p),
$$
where $\mathcal A_t^w$ and $\mathcal A_t^{sc}$ are the expected discounted labor-tax and social-security tax wedges appearing in the paper's Eq. (58).

- **(F26) Average private real wage law**:
$$
w_t^p=
\frac{(1-s^p)N_{t-1}^p}{N_t^p}
\left[(1-\theta_w)\tilde w_t^p+\theta_w\frac{w_{t-1}^p}{\pi_t}\right]
+\frac{M_t^p}{N_t^p}
\left[(1-\theta_w^n)\tilde w_t^p+\theta_w^n\frac{w_{t-1}^p}{\pi_t}\right].
$$

## 4. Market Clearing & Identities

- **(F27) Aggregate consumption**:
$$
C_t=(1-\mu)c_t^o+\mu c_t^r.
$$

- **(F28) Optimizer-only aggregate stocks and investment**:
$$
k_t=(1-\mu)k_t^o,\qquad I_t=(1-\mu)I_t^o,\qquad b_t=(1-\mu)b_t^o,\qquad d_t=(1-\mu)d_t^o.
$$

- **(F29) Private capital accumulation**:
$$
k_t=(1-\delta^k)k_{t-1}+[1-S(I_t/I_{t-1})]I_t,\qquad
S(x)=\frac{\kappa_I}{2}(x-1)^2.
$$

- **(F30) Private output absorption**:
$$
Y_t=C_t^g+C_{A,t}^{tot}+I_{A,t}^{tot}+I_t^g+\frac{1-\omega}{\omega}(C_{A,t}^{*,tot}+I_{A,t}^{*,tot}).
$$

- **(F31) Total GDP definition**:
$$
Y_t^{tot}=Y_t+g_t^g.
$$

- **(F32) Government spending decomposition**:
$$
G_t=C_t^g+I_t^g+\left[(1+\tau_t^{sc})w_t^gN_t^g\right]p_{B,t}^{1-\omega-\psi}.
$$

- **(F33) Government budget constraint / debt accumulation**:
$$
b_t=\frac{R_{t-1}}{\pi_t}b_{t-1}+PD_t.
$$

- **(F34) Primary deficit**:
$$
PD_t=
\left[\frac{G_t}{p_{B,t}^{1-\omega-\psi}}+\kappa^BU_t+Sub_t\right]
-\left[(\tau_t^w+\tau_t^{sc})(w_t^pN_t^p+w_t^gN_t^g)
+\tau_t^b\frac{R_{t-1}-1}{\pi_t}b_{t-1}
+\tau_t^cC_t+\tau_t^k(r_t^k-\delta^k)k_{t-1}+T_t\right].
$$

- **(F35) Public capital accumulation**:
$$
k_t^g=(1-\delta^g)k_{t-1}^g+I_t^g.
$$

- **(F36) Terms of trade law**:
$$
p_{B,t}=\frac{\pi_{B,t}}{\pi_{A,t}}p_{B,t-1}.
$$

- **(F37) Home current account / net foreign asset identity** (`needs_review`: verify price-deflator convention against PDF before code generation):
$$
d_t=\frac{R_{t-1}^{ecb}\exp[-\psi_d(d_{t-1}-\bar d)/Y_{t-1}]}{\pi_{A,t}}d_{t-1}
+\frac{1-\omega}{\omega}(C_{A,t}^{*,tot}+I_{A,t}^{*,tot})
-p_{B,t}(C_{B,t}^{tot}+I_{B,t}^{tot}).
$$

## 5. Exogenous Processes

- **(F38) Technology process**:
$$
\log A_t=\rho_A\log A_{t-1}+\varepsilon_t^A.
$$

- **(F39) Fiscal instrument rules**:
$$
X_t=\bar X+\rho_X(X_{t-1}-\bar X)
+(1-\rho_X)\varphi_X e_X^{aux}
\left(\frac{b_{t-1}}{Y_{t-1}^{tot}}p_{B,t-1}^{1-\omega-\psi}-\omega^b\right)
+\varepsilon_t^X,
$$
for tax-rate instruments $X\in\{\tau^w,\tau^{sc},\tau^b,\tau^c,\tau^k\}$.

- **(F40) Expenditure and transfer instrument rules**:
$$
\frac{X_t}{\bar X}=
\left(\frac{X_{t-1}}{\bar X}\right)^{\rho_X}
\left(\frac{b_{t-1}}{\omega^bY_{t-1}^{tot}}p_{B,t-1}^{1-\omega-\psi}\right)^{(1-\rho_X)\varphi_X}
\exp(\varepsilon_t^X),
$$
for $X\in\{C^g,I^g,w^g,N^g,Sub,T\}$.

- **(F41) Union-wide Taylor rule**:
$$
\frac{R_t^{ecb}}{\bar R^{ecb}}=
\left(\frac{R_{t-1}^{ecb}}{\bar R^{ecb}}\right)^{\rho_i}
\left[
\left(\frac{\pi_t}{\bar\pi}\right)^{\omega\phi_\pi}
\left(\frac{\pi_t^*}{\bar\pi^*}\right)^{(1-\omega)\phi_\pi}
\left(\frac{Y_t^{tot}}{Y_{t-1}^{tot}}\right)^{\omega\phi_y}
\left(\frac{Y_t^{*,tot}}{Y_{t-1}^{*,tot}}\right)^{(1-\omega)\phi_y}
\right]^{1-\rho_i}\exp(\varepsilon_t^i).
$$

## 6. Steady-State Solution

The paper calibrates the model to match steady-state ratios for Spain and the rest of the euro area rather than presenting a compact closed-form solution for all variables. For this first-pass archive entry, the steady state is therefore `needs_review`.

Useful source-backed steady-state relationships are:

1. Set shocks to zero and fix inflation at the common target, with symmetric price-dispersion values under zero inflation.
2. Use fiscal targets $\bar C^g=\omega_{Cg}\bar Y^{tot}$, $\bar I^g=\omega_{IG}\bar Y^{tot}$, $\bar w^g=\omega_{wg}\bar w^p$, $\bar N^g=\omega_{ng}\bar N^{tot}$, and debt target $\omega^b$.
3. Public capital satisfies $\bar k^g=\bar I^g/\delta^g$ from (F35).
4. Private capital satisfies $\bar k=\bar I/\delta^k$ from (F29).
5. The marginal product equations (F11)-(F12), production equation (F10), and Calvo markup pin down steady marginal cost, factor prices, and output for the calibrated employment and capital ratios.
6. The labor matching block pins down matching efficiency and vacancy costs from target employment, unemployment, separation rates, and training costs.
7. The government budget constraint and primary deficit equations pin down the required residual fiscal instrument.

Open item: reconstructing a complete `steady_state_model` from the paper alone requires checking the implementation calibration block and selected PDF formulas; this was not assigned as runtime validation.

## 7. Timing & Form Conventions

- Capital is predetermined: production in $t$ uses $k_{t-1}$ and $k_{t-1}^g$; accumulation determines end-of-period $k_t$ and $k_t^g$.
- Matching occurs at the beginning of the period. Newly matched workers produce immediately; separations from $t-1$ enter the searching pool in $t$.
- Domestic bonds and public debt are paid at $R_{t-1}/\pi_t$.
- The terms of trade $p_{B,t}$ converts between home and foreign PPIs and between CPI- and PPI-deflated fiscal aggregates.
- The model is nonlinear. The implementation cross-check uses first-order stochastic simulation but does not make the archive derivation a hand-linearized model.
- Foreign-country equations are symmetric but not identical in home-bias and size weights.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII cue | Meaning | Main equations |
|---|---|---|---|
| Endogenous | `Ct`, $C_t$ | aggregate private consumption | (F27) |
| Endogenous | `Crt`, $c_t^r$ | rule-of-thumb consumption | (F6), (F7) |
| Endogenous | `lambdat`, $\lambda_t^o$ | optimizer marginal utility of income | (F1) |
| Endogenous | `lambdart`, $\lambda_t^r$ | RoT marginal utility of income | (F7) |
| Endogenous | `Qt`, $Q_t$ | Tobin's Q | (F3), (F4) |
| Endogenous | `It`, $I_t$ | private investment | (F4), (F29) |
| Endogenous | `kt`, $k_t$ | private capital | (F29) |
| Endogenous | `Yt`, $Y_t$ | private output | (F10), (F30) |
| Endogenous | `Ytot`, $Y_t^{tot}$ | GDP including government production | (F31) |
| Endogenous | `mct`, $mc_t$ | marginal cost | (F11), (F12) |
| Endogenous | `rt`, $r_t^k$ | rental rate of private capital | (F11) |
| Endogenous | `xt`, $x_t$ | labor-service price | (F12) |
| Endogenous | `piet`, $\pi_t$ | CPI inflation | (F18) |
| Endogenous | `pieAt`, $\pi_{A,t}$ | home PPI inflation | (F16) |
| Endogenous | `Dt`, $D_t$ | price dispersion | (F17) |
| Endogenous | `q1t`, `q2t`, `ptildt` | Calvo pricing auxiliaries and reset price | (F13)-(F15) |
| Endogenous | `npt`, `ngt`, $N_t^p,N_t^g$ | private and public employment | (F22), (F23) |
| Endogenous | `utot`, $U_t$ | unemployment | (F23) |
| Endogenous | `Mpt`, `Mgt`, $M_t^p,M_t^g$ | sectoral matches | (F20) |
| Endogenous | `qpt`, `qgt`, `ppt`, `pgt` | matching probabilities | (F21) |
| Endogenous | `wpt`, `wopt` | average and newly bargained private wage | (F25), (F26) |
| Endogenous | `Jt`, `Jot`, `Wpt`, `Wgt` | firm and worker surplus/value objects | (F24), (F25) |
| Endogenous | `Debt`, $b_t$ | real public debt | (F33), (F34) |
| Endogenous | `G_t`, `Cgt`, `Igt`, `ggt` | government spending components | (F32), (F35), (F40) |
| Endogenous | `kgt`, $k_t^g$ | public capital | (F35) |
| Endogenous | `pBt`, $p_{B,t}$ | terms of trade / relative PPI | (F36) |
| Endogenous | `ddt`, $d_t$ | net foreign asset position | (F37) |
| Endogenous | `RECBt`, $R_t^{ecb}$ | union monetary policy rate | (F41) |
| Exogenous | `epsiA`, $\varepsilon_t^A$ | technology shock | (F38) |
| Exogenous | `epsiG`, `epsiIg`, `epsiwg`, `epsing` | fiscal spending, investment, wage, employment shocks | (F40) |
| Exogenous | `epsic`, `epsitw`, `epsisc`, `epsik`, `epsib` | tax-rate shocks | (F39) |
| Exogenous | `epsii` | monetary policy shock | (F41) |
| Parameter | $\beta,h,\sigma_c,\mu$ | discounting, habits, risk aversion, RoT share | (F1), (F7), (F27) |
| Parameter | $\alpha,\eta,\delta^k,\delta^g,\kappa_I$ | production, public capital, depreciation, investment costs | (F10), (F29), (F35) |
| Parameter | $\theta_P,\varepsilon$ | Calvo price rigidity and goods elasticity | (F13)-(F17) |
| Parameter | $s^p,s^g,\kappa_e^f,\phi^f,\kappa_v^p,\kappa_{tc}$ | labor search and matching | (F19)-(F24) |
| Parameter | $\theta_w,\theta_w^n,\xi$ | wage rigidity and bargaining power | (F25), (F26) |
| Parameter | $\rho_X,\varphi_X,\omega^b$ | fiscal rule smoothing, debt feedback, target debt ratio | (F39), (F40) |
| Parameter | $\rho_i,\phi_\pi,\phi_y,\omega$ | monetary rule smoothing, feedback coefficients, country size | (F41) |
