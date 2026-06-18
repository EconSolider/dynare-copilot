# US_DNGS15 -- Derivation (Log-Linear Equilibrium Conditions)

> Source-backed first-pass archive entry for Del Negro, Giannoni, and Schorfheide (2015), "Inflation in the Great Recession and New Keynesian Models." Runtime validation was not performed.

## 1. Model Overview

- **Model ID**: `US_DNGS15`.
- **Paper**: Marco Del Negro, Marc P. Giannoni, and Frank Schorfheide (2015), "Inflation in the Great Recession and New Keynesian Models," *American Economic Journal: Macroeconomics*, 7(1), 168-196. DOI: `10.1257/mac.20140097`.
- **Source files**: `raw/mmb_mineru/runs/us_dngs15_us_dngs15_sw_us_dngs15_swsp_us_dngs15__infation_in_the_great_recession_and_new_keynesian_models__c8e184ab/full.md`; raw PDF `raw/mmb_papers/Infation in the Great recession and New Keynesian models.pdf`.
- **MinerU run id**: `c8e184ab-3624-4257-9ea5-7ec1cf904fbb`.
- **Model family**: medium-scale U.S. New Keynesian DSGE model. The paper starts from Smets and Wouters (2007), based on Christiano, Eichenbaum, and Evans (2005), and adds a time-varying inflation target plus financial frictions in the spirit of Bernanke, Gertler, and Gilchrist (1999), Christiano, Motto, and Rostagno (2003, 2014), and De Graeve (2008).
- **Agents and blocks**: households with external habit, investment/capital accumulation with adjustment costs and variable utilization, monopolistically competitive goods and labor suppliers with nominal rigidities and indexation, entrepreneurs and banks generating an external finance spread, government spending, and a monetary authority.
- **Form**: log-linear equilibrium conditions, implemented as `model(linear)` in the MMB cross-check file. All variables in the extracted equilibrium block are log deviations from the nonstochastic steady state unless stated otherwise. Steady-state values use star subscripts.
- **Scope note**: the paper explicitly summarizes log-linear equilibrium conditions rather than deriving every primitive optimization problem. Primitive household, firm, and financial-contract derivations are therefore marked `needs_review` and should be checked against the cited CEE/SW/CMR technical sources before promotion.

## 2. Optimization Problems

The paper states that the SW model derivation is discussed in Christiano, Eichenbaum, and Evans (2005) and presents the log-linearized equilibrium conditions directly. The following optimization blocks are reconstructed only to identify the economic origin of the listed equilibrium conditions; they are not a full source-level primitive derivation.

### 2.1 Household

The representative household chooses consumption, labor, and nominal bonds subject to a budget constraint. Preferences include external habit in consumption and disutility from labor. The paper-side equations imply the following source-backed objects:

- consumption Euler condition with habit and an intertemporal wedge `b_t`;
- wage-setting block with a household marginal rate of substitution `w_t^h`;
- labor supply curvature governed by `nu_l`.

Primitive utility and budget equations are not printed in the paper and remain `needs_review`.

### 2.2 Capital and Goods-Producing Firms

The production side contains installed capital, variable utilization, investment adjustment costs, marginal efficiency of investment shocks, marginal cost, and a Kimball/Calvo price-setting block. The paper reports the resulting linear conditions for Tobin's Q, capital accumulation, utilization, marginal cost, factor ratios, production, resource use, and the price Phillips curve.

### 2.3 Wage Setters

Nominal wage rigidity is represented through a wage Phillips curve with Calvo parameter `zeta_w`, indexation `iota_w`, Kimball curvature `epsilon_w`, and wage markup shock `lambda_w,t`.

### 2.4 Entrepreneurs and Banks

Banks collect deposits from households and lend to entrepreneurs. Entrepreneurs purchase physical capital using net worth and borrowing. Idiosyncratic risk and monitoring/default considerations generate an external finance spread that depends on leverage and the dispersion shock `tilde sigma_omega,t`. The paper reports the log-linear spread, capital-return, and net-worth equations rather than the full contract problem.

### 2.5 Monetary Authority

The monetary authority follows a generalized feedback rule with interest-rate smoothing, inflation response, output-gap response, output-gap-growth response, and a policy shock. In the extended model the rule responds to inflation relative to the time-varying inflation target.

## 3. First-Order Conditions

Let `bar beta = beta exp((1-sigma_c) gamma)`. The archive equations below preserve the paper-side log-linear structure and use continuous archive numbering.

- **(F1) Consumption Euler equation**:
$$
c_t =
-\frac{1-h e^{-\gamma}}{\sigma_c(1+h e^{-\gamma})}
\big(R_t - E_t[\pi_{t+1}] + b_t\big)
+ \frac{h e^{-\gamma}}{1+h e^{-\gamma}}(c_{t-1}-z_t)
+ \frac{1}{1+h e^{-\gamma}}E_t[c_{t+1}+z_{t+1}]
+ \frac{\sigma_c-1}{\sigma_c(1+h e^{-\gamma})}
\frac{w_\ast l_\ast}{c_\ast}(l_t-E_t[l_{t+1}]).
$$

- **(F2) Investment/Tobin's Q condition**:
$$
q_t^k = S'' e^{2\gamma}(1+\bar\beta)
\left(i_t-\frac{1}{1+\bar\beta}(i_{t-1}-z_t)
-\frac{\bar\beta}{1+\bar\beta}E_t[i_{t+1}+z_{t+1}]
-\mu_t\right).
$$

- **(F3) Capital accumulation**:
$$
\bar{k}_t =
\left(1-\frac{i_\ast}{\bar{k}_\ast}\right)(\bar{k}_{t-1}-z_t)
+\frac{i_\ast}{\bar{k}_\ast}i_t
+\frac{i_\ast}{\bar{k}_\ast}S''e^{2\gamma}(1+\bar\beta)\mu_t.
$$

- **(F4) Effective capital rented to firms**:
$$
k_t = u_t - z_t + \bar{k}_{t-1}.
$$

- **(F5) Utilization condition**:
$$
u_t = \frac{1-\psi}{\psi}r_t^k.
$$

- **(F6) Real marginal cost**:
$$
mc_t = w_t+\alpha l_t-\alpha k_t.
$$

- **(F7) Common capital-labor ratio**:
$$
k_t = w_t-r_t^k+l_t.
$$

- **(F8) Production function**:
$$
y_t = \Phi_p\big(\alpha k_t+(1-\alpha)l_t\big)
+\mathcal{I}\{\rho_z<1\}\frac{\Phi_p-1}{1-\alpha}\tilde{z}_t.
$$

- **(F9) Resource constraint**:
$$
y_t = g_t+\frac{c_\ast}{y_\ast}c_t+\frac{i_\ast}{y_\ast}i_t
+\frac{r_\ast^k k_\ast}{y_\ast}u_t
-\mathcal{I}\{\rho_z<1\}\frac{1}{1-\alpha}\tilde{z}_t.
$$

- **(F10) Price Phillips curve**:
$$
\pi_t = \kappa mc_t
+\frac{\iota_p}{1+\iota_p\bar\beta}\pi_{t-1}
+\frac{\bar\beta}{1+\iota_p\bar\beta}E_t[\pi_{t+1}]
+\lambda_{f,t},
$$
where
$$
\kappa =
\frac{(1-\zeta_p\bar\beta)(1-\zeta_p)}
{(1+\iota_p\bar\beta)\zeta_p((\Phi_p-1)\epsilon_p+1)}.
$$

- **(F11) Wage Phillips curve**:
$$
\begin{aligned}
w_t={}&
\frac{(1-\zeta_w\bar\beta)(1-\zeta_w)}
{(1+\bar\beta)\zeta_w((\lambda_w-1)\epsilon_w+1)}
(w_t^h-w_t)
-\frac{1+\iota_w\bar\beta}{1+\bar\beta}\pi_t \\
&+\frac{1}{1+\bar\beta}(w_{t-1}-z_t+\iota_w\pi_{t-1})
+\frac{\bar\beta}{1+\bar\beta}E_t[w_{t+1}+z_{t+1}+\pi_{t+1}]
+\lambda_{w,t}.
\end{aligned}
$$

- **(F12) Household marginal rate of substitution**:
$$
w_t^h =
\frac{1}{1-h e^{-\gamma}}(c_t-h e^{-\gamma}c_{t-1}+h e^{-\gamma}z_t)
+\nu_l l_t.
$$

- **(F13) Baseline monetary policy rule**:
$$
R_t = \rho_R R_{t-1}
+(1-\rho_R)\big(\psi_1\pi_t+\psi_2(y_t-y_t^f)\big)
+\psi_3\big((y_t-y_t^f)-(y_{t-1}-y_{t-1}^f)\big)
+r_t^m.
$$

- **(F14) Time-varying-target monetary policy rule**:
$$
R_t = \rho_R R_{t-1}
+(1-\rho_R)\big(\psi_1(\pi_t-\pi_t^{\ast})+\psi_2(y_t-y_t^f)\big)
+\psi_3\big((y_t-y_t^f)-(y_{t-1}-y_{t-1}^f)\big)
+r_t^m.
$$
The extended model uses (F14) in place of (F13).

- **(F15) External finance spread**:
$$
E_t[\tilde{R}_{t+1}^k-R_t] =
b_t+\zeta_{sp,b}(q_t^k+\bar{k}_t-n_t)+\tilde{\sigma}_{\omega,t}.
$$

- **(F16) Entrepreneurial return on capital**:
$$
\tilde{R}_t^k-\pi_t =
\frac{r_\ast^k}{r_\ast^k+(1-\delta)}r_t^k
+\frac{1-\delta}{r_\ast^k+(1-\delta)}q_t^k
-q_{t-1}^k.
$$

- **(F17) Entrepreneurial net worth**:
$$
\begin{aligned}
n_t={}&
\zeta_{n,\tilde{R}^k}(\tilde{R}_t^k-\pi_t)
-\zeta_{n,R}(R_{t-1}-\pi_t)
+\zeta_{n,qK}(q_{t-1}^k+\bar{k}_{t-1})
+\zeta_{n,n}n_{t-1} \\
&-\frac{\zeta_{n,\sigma_\omega}}{\zeta_{sp,\sigma_\omega}}
\tilde{\sigma}_{\omega,t-1}
-\gamma_\ast\frac{v_\ast}{n_\ast}\hat{z}_t.
\end{aligned}
$$

## 4. Market Clearing & Identities

- **(F18) Output gap definition**:
$$
og_t = y_t-y_t^f.
$$

- **(F19) Flexible-price consumption Euler equation**:
$$
c_t^f =
-\frac{1-h e^{-\gamma}}{\sigma_c(1+h e^{-\gamma})}r_t^f
+b_t+\frac{h e^{-\gamma}}{1+h e^{-\gamma}}(c_{t-1}^f-z_t)
+\frac{1}{1+h e^{-\gamma}}E_t[c_{t+1}^f+z_{t+1}]
+\frac{\sigma_c-1}{\sigma_c(1+h e^{-\gamma})}
\frac{w_\ast l_\ast}{c_\ast}(l_t^f-E_t[l_{t+1}^f]).
$$

- **(F20) Flexible-price investment/Tobin's Q condition**:
$$
q_t^{k,f} = S'' e^{2\gamma}(1+\bar\beta)
\left(i_t^f-\frac{1}{1+\bar\beta}(i_{t-1}^f-z_t)
-\frac{\bar\beta}{1+\bar\beta}E_t[i_{t+1}^f+z_{t+1}]
-\mu_t\right).
$$

- **(F21) Flexible-price capital accumulation**:
$$
\bar{k}_t^f =
\left(1-\frac{i_\ast}{\bar{k}_\ast}\right)(\bar{k}_{t-1}^f-z_t)
+\frac{i_\ast}{\bar{k}_\ast}i_t^f
+\frac{i_\ast}{\bar{k}_\ast}S''e^{2\gamma}(1+\bar\beta)\mu_t.
$$

- **(F22) Flexible-price production-side identities**:
$$
k_t^f=u_t^f-z_t+\bar{k}_{t-1}^f,\quad
u_t^f=\frac{1-\psi}{\psi}r_t^{k,f},\quad
w_t^f=-\alpha l_t^f+\alpha k_t^f,\quad
k_t^f=w_t^f-r_t^{k,f}+l_t^f.
$$

- **(F23) Flexible-price output and resource constraint**:
$$
y_t^f=\Phi_p\big(\alpha k_t^f+(1-\alpha)l_t^f\big)
+\frac{\Phi_p-1}{1-\alpha}\tilde{z}_t,
$$
$$
y_t^f=g_\ast\;g_t+\frac{c_\ast}{y_\ast}c_t^f+\frac{i_\ast}{y_\ast}i_t^f
+\frac{r_\ast^k k_\ast}{y_\ast}u_t^f
-g_\ast\frac{1}{1-\alpha}\tilde{z}_t.
$$

- **(F24) Flexible-price wage/MRS condition**:
$$
w_t^f =
\frac{1}{1-h e^{-\gamma}}(c_t^f-h e^{-\gamma}c_{t-1}^f+h e^{-\gamma}z_t)
+\nu_l l_t^f.
$$

- **(F25) Flexible-price arbitrage condition without financial frictions**:
$$
q_t^{k,f} =
\frac{r_\ast^k}{r_\ast^k+1-\delta}E_t[r_{t+1}^{k,f}]
+\frac{1-\delta}{r_\ast^k+1-\delta}E_t[q_{t+1}^{k,f}]
-r_t^f
+\frac{\sigma_c(1+h e^{-\gamma})}{1-h e^{-\gamma}}b_t.
$$

## 5. Exogenous Processes

- **(F26) Detrended productivity growth**:
$$
z_t=\frac{1}{1-\alpha}(\rho_z-1)\tilde{z}_{t-1}
+\frac{1}{1-\alpha}\sigma_z\varepsilon_{z,t}.
$$

- **(F27) Detrended log productivity**:
$$
\tilde{z}_t=\rho_z\tilde{z}_{t-1}+\sigma_z\varepsilon_{z,t}.
$$

- **(F28) Government spending**:
$$
g_t=\rho_g g_{t-1}+\sigma_g\varepsilon_{g,t}
+\eta_{gz}\sigma_z\varepsilon_{z,t}.
$$

- **(F29) Intertemporal wedge**:
$$
b_t=\rho_b b_{t-1}+\sigma_b\varepsilon_{b,t}.
$$

- **(F30) Marginal efficiency of investment**:
$$
\mu_t=\rho_\mu\mu_{t-1}+\sigma_\mu\varepsilon_{\mu,t}.
$$

- **(F31) Price markup shock**:
$$
\lambda_{f,t}=\rho_{\lambda_f}\lambda_{f,t-1}
+\sigma_{\lambda_f}\varepsilon_{\lambda_f,t}
-\eta_{\lambda_f}\sigma_{\lambda_f}\varepsilon_{\lambda_f,t-1}.
$$

- **(F32) Wage markup shock**:
$$
\lambda_{w,t}=\rho_{\lambda_w}\lambda_{w,t-1}
+\sigma_{\lambda_w}\varepsilon_{\lambda_w,t}
-\eta_{\lambda_w}\sigma_{\lambda_w}\varepsilon_{\lambda_w,t-1}.
$$

- **(F33) Monetary policy residual**:
$$
r_t^m=\rho_{r^m}r_{t-1}^m+\sigma_{r^m}\varepsilon_{r^m,t}.
$$

- **(F34) Financial risk/spread shock**:
$$
\tilde{\sigma}_{\omega,t}=
\rho_{\sigma_\omega}\tilde{\sigma}_{\omega,t-1}
+\sigma_{\sigma_\omega}\varepsilon_{\sigma_\omega,t}.
$$

- **(F35) Time-varying inflation target**:
$$
\pi_t^{\ast}=\rho_{\pi^{\ast}}\pi_{t-1}^{\ast}
+\sigma_{\pi^{\ast}}\varepsilon_{\pi^{\ast},t}.
$$

## 6. Steady-State Solution

Because the paper presents the model in log deviations from the nonstochastic steady state, all endogenous and exogenous deviation variables in the linear system have zero steady state:

$$
c=i=l=R=\pi=q^k=r^k=\bar{k}=k=u=mc=w=w^h=y=n=\tilde{R}^k=z=\tilde z=\mu=\lambda_f=\lambda_w=r^m=g=b=\tilde\sigma_\omega=\pi^{\ast}=og=0.
$$

The source states that steady-state formulas are provided in the technical Appendix of Del Negro and Schorfheide (2013), not in this paper. For implementation cross-checking, the MMB `.mod` file uses calibrated steady-state levels such as `zstar`, `rstar`, `rkstar`, `wstar`, `Lstar`, `kstar`, `kbarstar`, `istar`, `ystar`, and `cstar`; these values are recorded as implementation evidence, not as paper-side derivations.

Deferred `needs_review` steady-state issues:

- confirm the full nonlinear steady-state formulas against Del Negro and Schorfheide (2013);
- confirm how financial-friction steady-state coefficients map from `SP_*`, default probability, entrepreneur survival, and the `zeta_*` parameters into (F15)-(F17);
- confirm whether fixed costs are proportional to the trend in the stochastic-trend case.

## 7. Timing & Form Conventions

- **Linear form**: `model(linear)`; variables are log deviations from the nonstochastic steady state.
- **Trends**: nonstationary variables are detrended by `Z_t`; `z_t` is the growth-rate deviation of `Z_t`, and `tilde z_t` is linearly detrended log productivity.
- **Predetermined capital**: production uses effective capital `k_t`, which depends on utilization and installed capital chosen in the previous period, `bar{k}_{t-1}`.
- **Capital return timing**: the entrepreneurial return condition uses `q_{t-1}^k` in the realized return (F16), while the spread condition is forward-looking in `E_t[tilde R_{t+1}^k-R_t]`.
- **Nominal rigidities**: price and wage Phillips curves include lagged indexation and forward-looking terms.
- **Policy rule**: the extended model uses inflation relative to the time-varying target `pi_t^*`; the MMB implementation includes both sticky and flexible price/wage output to compute `y_t-y_t^f`.
- **Runtime validation**: not performed; no Dynare execution was run for this archive pass.

## 8. Variable & Parameter Reference Table

### Endogenous variables

| Symbol | ASCII / MMB name | Meaning | Main equation(s) |
|---|---|---|---|
| $c_t$ | `c` | consumption deviation | (F1) |
| $R_t$ | `R` | nominal policy-rate deviation | (F14) |
| $\pi_t$ | `pi` | inflation deviation | (F10) |
| $l_t$ | `L` | labor deviation | (F1), (F7), (F11), (F12) |
| $q_t^k$ | `qk` | value of installed capital | (F2) |
| $i_t$ | `i` | investment deviation | (F2), (F3), (F9) |
| $\tilde{R}_t^k$ | `Rktil` | nominal entrepreneurial return | (F15), (F16), (F17) |
| $r_t^k$ | `rk` | rental rate of capital | (F5), (F7), (F16) |
| $\bar{k}_t$ | `kbar` | installed capital stock | (F3) |
| $n_t$ | `n` | entrepreneurial net worth | (F17) |
| $y_t$ | `y` | output deviation | (F8), (F9) |
| $k_t$ | `k` | effective capital services | (F4), (F7) |
| $u_t$ | `u` | utilization | (F5) |
| $mc_t$ | `mc` | real marginal cost | (F6), (F10) |
| $w_t$ | `w` | real wage | (F6), (F7), (F11) |
| $w_t^h$ | `wh` | household MRS wage | (F11), (F12) |
| $z_t$ | `z` | trend-growth deviation | (F26) |
| $\tilde z_t$ | `ztil` | detrended log productivity | (F27) |
| $\mu_t$ | `mu` | MEI shock state | (F30) |
| $\tilde{\sigma}_{\omega,t}$ | `sigw` | financial-risk dispersion shock state | (F34) |
| $\lambda_{f,t}$ | `laf` | price markup shock state | (F31) |
| $\lambda_{w,t}$ | `law` | wage markup shock state | (F32) |
| $r_t^m$ | `rm` | monetary policy residual | (F33) |
| $g_t$ | `g` | government spending deviation | (F28) |
| $b_t$ | `b` | intertemporal wedge state | (F29) |
| $\pi_t^{\ast}$ | `pist` | time-varying inflation target | (F35) |
| $og_t$ | `og` | output gap | (F18) |
| flexible block | `c_f`, `r_f`, `L_f`, `qk_f`, `i_f`, `rk_f`, `y_f`, `k_f`, `u_f`, `kbar_f`, `w_f` | flexible-price/wage auxiliary economy | (F19)-(F25) |

### Exogenous innovations

| ASCII / MMB name | Meaning |
|---|---|
| `psi_g` | government spending innovation |
| `psi_b` | intertemporal wedge innovation |
| `psi_mu` | marginal efficiency of investment innovation |
| `psi_z` | productivity innovation |
| `psi_laf` | price markup innovation |
| `psi_law` | wage markup innovation |
| `psi_rm` | policy residual innovation |
| `psi_sigw` | financial risk/spread innovation |
| `psi_pist` | inflation-target innovation |

### Parameters

| ASCII / MMB name | Meaning |
|---|---|
| `alp` | capital share parameter $\alpha$ |
| `zeta_p`, `iota_p`, `epsp` | price Calvo, price indexation, Kimball price curvature |
| `zeta_w`, `iota_w`, `epsw` | wage Calvo, wage indexation, Kimball wage curvature |
| `del` | depreciation rate |
| `Bigphi` | fixed-cost / production scaling parameter $\Phi_p$ |
| `s2` | investment adjustment-cost curvature $S''$ |
| `h` | habit persistence |
| `ppsi` | utilization-cost parameter $\psi$ |
| `nu_l` | labor disutility curvature |
| `bet`, `sigmac`, `zstar` | discount factor, risk aversion, steady growth |
| `psi1`, `psi2`, `psi3`, `rho` | monetary policy coefficients and smoothing |
| `gstar`, `rho_g`, `eta_gz` | government-spending process parameters |
| `rho_b`, `rho_mu`, `rho_z`, `rho_laf`, `rho_law`, `rho_rm`, `rho_sigw`, `rho_pist` | exogenous persistence parameters |
| `eta_laf`, `eta_law` | ARMA markup-shock moving-average parameters |
| `rkstar`, `wl_c`, `cstar`, `wstar`, `Lstar`, `kstar`, `kbarstar`, `istar`, `rstar`, `ystar` | steady-state levels/ratios used by the linear system |
| `zeta_spb`, `gammstar`, `vstar`, `nstar`, `zeta_nRk`, `zeta_nR`, `zeta_nsigw`, `zeta_spsigw`, `zeta_nqk`, `zeta_nn` | financial-friction spread and net-worth coefficients |
