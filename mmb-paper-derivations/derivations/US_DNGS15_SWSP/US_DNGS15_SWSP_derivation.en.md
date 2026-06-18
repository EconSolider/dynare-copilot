# US_DNGS15_SWSP -- Derivation (optimization problems + equilibrium conditions)

> Private MMB archive draft. Runtime validation was not performed. Status: `needs_review`.

Provenance: model `US_DNGS15_SWSP`, Del Negro, Giannoni, and Schorfheide (2015), "Inflation in the Great Recession and New Keynesian Models," *American Economic Journal: Macroeconomics* 7(1), 168-196, DOI `10.1257/mac.20140097`. Primary source Markdown: `raw/mmb_mineru/runs/us_dngs15_us_dngs15_sw_us_dngs15_swsp_us_dngs15__infation_in_the_great_recession_and_new_keynesian_models__c8e184ab/full.md`; raw PDF: `raw/mmb_papers/Infation in the Great recession and New Keynesian models.pdf`; MinerU run id `c8e184ab-3624-4257-9ea5-7ec1cf904fbb`. The file `.agents/skills/dynare-copilot/references/examples/US_DNGS15_SWSP_rep.mod` was used only as `implementation_cross_check`.

## 1. Model Overview

- **Model**: SWFF, an estimated U.S. Smets-Wouters (2007) medium-scale New Keynesian model extended with time-varying target inflation and financial frictions.
- **MMB variant**: `US_DNGS15_SWSP`, described in the implementation cross-check as the DNGS15 SW model estimated with the same observables as Smets-Wouters plus credit spread data.
- **Agents and blocks**: households with external habit, investment/capital accumulation with adjustment costs, monopolistically competitive price and wage setters with nominal rigidities and indexation, intermediate goods producers, entrepreneurs/banks generating a spread over the riskless rate, a monetary authority, and exogenous processes.
- **Form**: `model(linear)`. The paper states that all listed equations are log deviations from the nonstochastic steady state. Steady-state constants enter as parameters.
- **Source caveat**: the paper itself summarizes log-linear equilibrium conditions and refers steady-state formulas to Del Negro and Schorfheide (2013). This entry records the paper-side equations and marks full primitive optimization recovery as `needs_review`.

## 2. Optimization Problems

The paper does not restate the full nonlinear optimization problems; it summarizes the log-linear equilibrium system and notes that the SW model follows Christiano, Eichenbaum, and Evans (2005). The implied optimization sources are:

- **Household**: chooses consumption, labor, and bond holdings with external habit. The log-linear Euler equation and wage/MRS condition imply preferences over habit-adjusted consumption and labor disutility.
- **Capital/investment block**: chooses investment subject to an adjustment-cost technology and marginal-efficiency-of-investment shock.
- **Price and wage setters**: choose reset prices and wages under Calvo frictions, indexation, and Kimball-style curvature terms.
- **Entrepreneurs and banks**: entrepreneurs use net worth and bank loans to acquire capital. Banks pool idiosyncratic default risk and charge a spread that depends on leverage and riskiness.
- **Central bank**: follows a feedback rule rather than optimizing.

`needs_review`: the primary Markdown contains equilibrium conditions but not enough primitive detail to reconstruct every original Lagrangian without importing CEE/SW/BGG derivations from outside the assigned source set.

## 3. First-Order Conditions

All variables are log deviations from the nonstochastic steady state unless noted. Let $\bar{\beta}=\beta e^{(1-\sigma_c)\gamma}$.

- **(F1) Consumption Euler equation**:
$$
c_t =
-\frac{1-h e^{-\gamma}}{\sigma_c(1+h e^{-\gamma})}
\left(R_t-E_t[\pi_{t+1}]+b_t\right)
+\frac{h e^{-\gamma}}{1+h e^{-\gamma}}(c_{t-1}-z_t)
+\frac{1}{1+h e^{-\gamma}}E_t[c_{t+1}+z_{t+1}]
+\frac{\sigma_c-1}{\sigma_c(1+h e^{-\gamma})}\frac{w_\astl_\ast}{c_\ast}
\left(l_t-E_t[l_{t+1}]\right).
$$

- **(F2) Investment Euler / Tobin's Q condition**:
$$
q_t^k=S'' e^{2\gamma}(1+\bar{\beta})
\left(i_t-\frac{1}{1+\bar{\beta}}(i_{t-1}-z_t)
-\frac{\bar{\beta}}{1+\bar{\beta}}E_t[i_{t+1}+z_{t+1}]
-\mu_t\right).
$$

- **(F3) Capital accumulation**:
$$
\bar{k}_t=
\left(1-\frac{i_\ast}{\bar{k}_\ast}\right)(\bar{k}_{t-1}-z_t)
+\frac{i_\ast}{\bar{k}_\ast}i_t
+\frac{i_\ast}{\bar{k}_\ast}S''e^{2\gamma}(1+\bar{\beta})\mu_t.
$$

- **(F4) Effective capital services**:
$$
k_t=u_t-z_t+\bar{k}_{t-1}.
$$

- **(F5) Utilization condition**:
$$
u_t=\frac{1-\psi}{\psi}r_t^k.
$$

- **(F6) Real marginal cost**:
$$
mc_t=w_t+\alpha l_t-\alpha k_t.
$$

- **(F7) Common capital-labor ratio**:
$$
k_t=w_t-r_t^k+l_t.
$$

- **(F8) Price Phillips curve**:
$$
\pi_t=\kappa mc_t+
\frac{\iota_p}{1+\iota_p\bar{\beta}}\pi_{t-1}
+\frac{\bar{\beta}}{1+\iota_p\bar{\beta}}E_t[\pi_{t+1}]
+\lambda_{f,t}.
$$

- **(F9) Price Phillips slope**:
$$
\kappa=
\frac{(1-\zeta_p\bar{\beta})(1-\zeta_p)}
{(1+\iota_p\bar{\beta})\zeta_p((\Phi_p-1)\epsilon_p+1)}.
$$

- **(F10) Wage Phillips curve**:
$$
\begin{aligned}
w_t={}&
\frac{(1-\zeta_w\bar{\beta})(1-\zeta_w)}
{(1+\bar{\beta})\zeta_w((\lambda_w-1)\epsilon_w+1)}
(w_t^h-w_t)
-\frac{1+\iota_w\bar{\beta}}{1+\bar{\beta}}\pi_t \\
&+\frac{1}{1+\bar{\beta}}(w_{t-1}-z_t+\iota_w\pi_{t-1})
+\frac{\bar{\beta}}{1+\bar{\beta}}E_t[w_{t+1}+z_{t+1}+\pi_{t+1}]
+\lambda_{w,t}.
\end{aligned}
$$

- **(F11) Household marginal rate of substitution wage**:
$$
w_t^h=\frac{1}{1-h e^{-\gamma}}
(c_t-h e^{-\gamma}c_{t-1}+h e^{-\gamma}z_t)+\nu_l l_t.
$$

- **(F12) Financial-friction spread condition**:
$$
E_t[\tilde{R}_{t+1}^k-R_t]
=b_t+\zeta_{sp,b}(q_t^k+\bar{k}_t-n_t)+\tilde{\sigma}_{\omega,t}.
$$

- **(F13) Nominal return on capital**:
$$
\tilde{R}_t^k-\pi_t=
\frac{r_\ast^k}{r_\ast^k+(1-\delta)}r_t^k
+\frac{1-\delta}{r_\ast^k+(1-\delta)}q_t^k
-q_{t-1}^k.
$$

- **(F14) Entrepreneurial net worth**:
$$
\begin{aligned}
n_t={}&
\zeta_{n,\tilde{R}^k}(\tilde{R}_t^k-\pi_t)
-\zeta_{n,R}(R_{t-1}-\pi_t)
+\zeta_{n,qK}(q_{t-1}^k+\bar{k}_{t-1})
+\zeta_{n,n}n_{t-1} \\
&-\frac{\zeta_{n,\sigma_\omega}}{\zeta_{sp,\sigma_\omega}}
\tilde{\sigma}_{\omega,t-1}
-\gamma_\ast\frac{v_\ast}{n_\ast}z_t.
\end{aligned}
$$

## 4. Market Clearing & Identities

- **(F15) Aggregate production**:
$$
y_t=\Phi_p(\alpha k_t+(1-\alpha)l_t)
+\mathcal{I}\{\rho_z<1\}(\Phi_p-1)\frac{1}{1-\alpha}\tilde{z}_t.
$$

- **(F16) Resource constraint**:
$$
y_t=g_t+\frac{c_\ast}{y_\ast}c_t+\frac{i_\ast}{y_\ast}i_t
+\frac{r_\ast^k k_\ast}{y_\ast}u_t
-\mathcal{I}\{\rho_z<1\}\frac{1}{1-\alpha}\tilde{z}_t.
$$

- **(F17) Time-varying-target Taylor rule**:
$$
\begin{aligned}
R_t={}&\rho_R R_{t-1}
+(1-\rho_R)\left(\psi_1(\pi_t-\pi_t^{\ast})+\psi_2(y_t-y_t^f)\right) \\
&+\psi_3\left((y_t-y_t^f)-(y_{t-1}-y_{t-1}^f)\right)+r_t^m.
\end{aligned}
$$

- **(F18) Flexible-price/wage counterpart**:
$$
y_t^f=\mathcal{F}^{flex}(c_t^f,i_t^f,l_t^f,k_t^f,u_t^f,\bar{k}_t^f,w_t^f,r_t^f,q_t^{k,f}; \Theta),
$$
where $\mathcal{F}^{flex}$ denotes the flexible price/wage version of equations (F1)-(F7), (F11), and (F15)-(F16). The paper defines $y_t^f$ by solving the model without nominal rigidities; the implementation cross-check expands this as a parallel block.

## 5. Exogenous Processes

- **(F19) Detrended productivity**:
$$
\tilde{z}_t=\rho_z\tilde{z}_{t-1}+\sigma_z\varepsilon_{z,t}.
$$

- **(F20) Growth-rate effect of productivity**:
$$
z_t=\frac{1}{1-\alpha}(\rho_z-1)\tilde{z}_{t-1}
+\frac{1}{1-\alpha}\sigma_z\varepsilon_{z,t}.
$$

- **(F21) Government spending**:
$$
g_t=\rho_g g_{t-1}+\sigma_g\varepsilon_{g,t}
+\eta_{gz}\sigma_z\varepsilon_{z,t}.
$$

- **(F22) Price markup process**:
$$
\lambda_{f,t}=\rho_{\lambda_f}\lambda_{f,t-1}
+\sigma_{\lambda_f}\varepsilon_{\lambda_f,t}
-\eta_{\lambda_f}\sigma_{\lambda_f}\varepsilon_{\lambda_f,t-1}.
$$

- **(F23) Wage markup process**:
$$
\lambda_{w,t}=\rho_{\lambda_w}\lambda_{w,t-1}
+\sigma_{\lambda_w}\varepsilon_{\lambda_w,t}
-\eta_{\lambda_w}\sigma_{\lambda_w}\varepsilon_{\lambda_w,t-1}.
$$

- **(F24) Time-varying target inflation**:
$$
\pi_t^{\ast}=\rho_{\pi^{\ast}}\pi_{t-1}^{\ast}+\sigma_{\pi^{\ast}}\varepsilon_{\pi^{\ast},t}.
$$

- **(F25) Discount-rate wedge**:
$$
b_t=\rho_b b_{t-1}+\sigma_b\varepsilon_{b,t}.
$$

- **(F26) Marginal efficiency of investment**:
$$
\mu_t=\rho_\mu\mu_{t-1}+\sigma_\mu\varepsilon_{\mu,t}.
$$

- **(F27) Monetary policy residual**:
$$
r_t^m=\rho_{r^m}r_{t-1}^m+\sigma_{r^m}\varepsilon_{r^m,t}.
$$

- **(F28) Financial risk/spread shock**:
$$
\tilde{\sigma}_{\omega,t}=\rho_{\sigma_\omega}\tilde{\sigma}_{\omega,t-1}
+\sigma_{\sigma_\omega}\varepsilon_{\sigma_\omega,t}.
$$

## 6. Steady-State Solution

Because the archive source is a log-linear system, the model variables in (F1)-(F28) are deviations from the nonstochastic steady state. Therefore:

- endogenous log-deviation steady states are zero: $c=l=R=\pi=q^k=i=r^k=\bar{k}=n=y=k=u=mc=w=w^h=z=\tilde{z}=\mu=\tilde{\sigma}_\omega=\lambda_f=\lambda_w=g=b=r^m=\pi^{\ast}=0$;
- flexible-price/wage counterpart deviations are also zero: $c^f=l^f=q^{k,f}=i^f=r^{k,f}=y^f=k^f=u^f=\bar{k}^f=w^f=r^f=0$;
- nonzero steady-state levels enter as parameters, including $\gamma$, $r_\ast$, $r_\ast^k$, $c_\ast$, $w_\ast$, $l_\ast$, $k_\ast$, $\bar{k}_\ast$, $i_\ast$, $y_\ast$, $g_\ast$, $v_\ast$, and $n_\ast$.

`needs_review`: the paper points steady-state formulas to the technical appendix of Del Negro and Schorfheide (2013). This archive entry did not import that external appendix, so primitive steady-state derivations are deferred.

## 7. Timing & Form Conventions

- **Linear form**: equations are log deviations from the nonstochastic steady state; the MMB implementation uses `model(linear)`.
- **Capital timing**: $\bar{k}_t$ is installed capital stock at the end of period $t$; production uses effective capital services $k_t=u_t-z_t+\bar{k}_{t-1}$.
- **Expectations**: variables with $E_t[\cdot]$ are one-period-ahead rational expectations; the implementation cross-check uses Dynare leads for these terms.
- **Financial block**: $\tilde{R}_{t+1}^k$ enters the spread equation in expectation; net worth $n_t$ depends on realized current capital returns and lagged net worth.
- **Policy variant**: the paper's SWFF time-varying-target rule uses (F17). The MMB `US_DNGS15_SWSP` implementation replaces the compact Taylor rule with a model-base policy-rule interface and keeps spread data in the estimation variant; this is implementation-specific cross-check evidence.
- **Runtime validation**: not performed; Dynare was not run.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Main equation |
|---|---|---|---|
| Endogenous | `c` | consumption | (F1), (F16) |
| Endogenous | `L` / $l$ | labor supply | (F1), (F7), (F10), (F15) |
| Endogenous | `R` | nominal policy rate deviation | (F1), (F17) |
| Endogenous | `pi` | inflation | (F8), (F10), (F17) |
| Endogenous | `qk` / $q^k$ | value of capital | (F2), (F12), (F13) |
| Endogenous | `i` | investment | (F2), (F3), (F16) |
| Endogenous | `kbar` / $\bar{k}$ | installed capital | (F3), (F4), (F12) |
| Endogenous | `k` | effective capital services | (F4), (F7), (F15) |
| Endogenous | `u` | utilization | (F5), (F16) |
| Endogenous | `rk` / $r^k$ | rental rate of capital | (F5), (F7), (F13) |
| Endogenous | `mc` | real marginal cost | (F6), (F8) |
| Endogenous | `w` | real wage | (F6), (F7), (F10) |
| Endogenous | `wh` / $w^h$ | household MRS wage | (F10), (F11) |
| Endogenous | `y` | output | (F15), (F16) |
| Endogenous | `y_f` | flexible-price/wage output | (F17), (F18) |
| Endogenous | `Rktil` / $\tilde{R}^k$ | nominal return on capital for entrepreneurs | (F12), (F13), (F14) |
| Endogenous | `n` | entrepreneurial net worth | (F12), (F14) |
| Endogenous | `z`, `ztil` | productivity components | (F19), (F20) |
| Endogenous | `g`, `b`, `mu`, `laf`, `law`, `rm`, `pist`, `sigw` | exogenous state processes represented as endogenous AR states in Dynare | (F21)-(F28) |
| Endogenous | `c_f`, `r_f`, `L_f`, `qk_f`, `i_f`, `rk_f`, `k_f`, `u_f`, `kbar_f`, `w_f` | flexible-price/wage counterpart variables | (F18) |
| Varexo | `psi_b` | discount-rate wedge innovation | (F25) |
| Varexo | `psi_mu` | marginal-efficiency innovation | (F26) |
| Varexo | `psi_z` | productivity innovation | (F19), (F20), (F21) |
| Varexo | `psi_laf` | price-markup innovation | (F22) |
| Varexo | `psi_law` | wage-markup innovation | (F23) |
| Varexo | `psi_sigw` | financial risk/spread innovation | (F28) |
| Varexo | `psi_pist` | target-inflation innovation | (F24) |
| Varexo | `psi_rm` | monetary policy residual innovation | (F27) |
| Varexo | `interest_`, `fiscal_` | MMB policy-rule interface shocks | implementation_cross_check |
| Parameter | `alp`, `zeta_p`, `iota_p`, `del`, `Bigphi`, `s2`, `h`, `ppsi`, `nu_l`, `zeta_w`, `iota_w`, `bet`, `psi1`, `psi2`, `psi3`, `sigmac`, `rho`, `epsp`, `epsw` | SW preference, nominal rigidity, production, policy, and adjustment-cost parameters | (F1)-(F17) |
| Parameter | `rho_g`, `rho_b`, `rho_mu`, `rho_z`, `rho_laf`, `rho_law`, `rho_rm`, `rho_sigw`, `rho_pist`, `eta_gz`, `eta_laf`, `eta_law` | exogenous-process persistence and MA/correlation parameters | (F19)-(F28) |
| Parameter | `zstar`, `rstar`, `rkstar`, `wl_c`, `cstar`, `wstar`, `Lstar`, `kstar`, `kbarstar`, `istar`, `ystar`, `gstar` | steady-state constants | (F1)-(F16) |
| Parameter | `zeta_spb`, `gammstar`, `vstar`, `nstar`, `zeta_nRk`, `zeta_nR`, `zeta_nsigw`, `zeta_spsigw`, `zeta_nqk`, `zeta_nn` | financial-friction and net-worth coefficients | (F12), (F14), (F28) |
