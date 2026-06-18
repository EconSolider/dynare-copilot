# US_CMR14noFA -- Derivation (optimization problems + first-order conditions)

> First-pass MMB archive extraction. Formula status: `needs_review`; equations are based on the paper Markdown and the no-financial-frictions implementation cross-check. The PDF body was not opened and Dynare was not run.

## 1. Model Overview

- **Model ID**: `US_CMR14noFA`.
- **Paper**: Christiano, Lawrence J.; Motto, Roberto; Rostagno, Massimo (2014), "Risk shocks," *American Economic Review* 104(1), 27-65, DOI `10.1257/aer.104.1.27`.
- **Primary source**: `raw/mmb_mineru/runs/us_cmr14_us_cmr14nofa__risk_shocks__d33971b2/full.md`; raw PDF recorded at `raw/mmb_papers/Risk shocks.pdf`.
- **Variant**: CEE-style model without financial frictions. The paper states that this version is obtained by adding the household intertemporal capital Euler equation and dropping the entrepreneurial contract optimality condition, bank zero-profit condition, entrepreneurial net-worth law, and monitoring costs in the resource constraint.
- **Agents**: final-good aggregator, monopolistically competitive intermediate-good producers with Calvo price setting, households that consume, save, build raw capital, and supply differentiated labor through Calvo wage setting, government demand, and a monetary authority.
- **Form**: stationary scaled nonlinear equilibrium conditions used for a first-order log-linear solution/estimation. This entry records nonlinear stationary conditions where available and marks source/implementation normalization issues as `needs_review`.
- **Runtime validation**: not performed; Dynare was not run.

## 2. Optimization Problems

### Final-good aggregator

The competitive final-good producer chooses differentiated inputs $Y_{jt}$ to produce homogeneous output:

$$
Y_t=\left[\int_0^1Y_{jt}^{1/\lambda_{f,t}}\,dj\right]^{\lambda_{f,t}},\qquad 1\leq \lambda_{f,t}<\infty .
$$

### Intermediate-good firms

Intermediate producers rent effective capital services and hire homogeneous labor:

$$
Y_{jt}=\epsilon_t K_{jt}^{\alpha}(z_t l_{jt})^{1-\alpha}-\Phi z_t^{\ast} .
$$

Each firm sets its price subject to Calvo frictions. Non-reoptimizing firms index to the target and lagged inflation term:

$$
\tilde{\pi}_t=(\pi_t^{target})^{\iota}(\pi_{t-1})^{1-\iota}.
$$

### Households and capital producers

Households choose consumption, one-period bonds, long bonds, investment, and raw capital. They build end-of-period raw capital:

$$
\bar K_{t+1}=(1-\delta)\bar K_t+\left[1-S\left(\zeta_{I,t}I_t/I_{t-1}\right)\right]I_t .
$$

Preferences are:

$$
E_0\sum_{t=0}^{\infty}\beta^t\zeta_{c,t}
\left[
\log(C_t-bC_{t-1})
-\psi_L\int_0^1\frac{h_{it}^{1+\sigma_L}}{1+\sigma_L}\,di
\right].
$$

The household budget contains consumption taxes, wage taxes, one-period bonds, long bonds, investment goods priced by the investment-specific technology, capital purchases/sales, and lump-sum profits/transfers:

$$
\begin{aligned}
(1+\tau^c)P_tC_t+B_{t+1}+B^L_{t+40}
+\frac{P_t}{\Upsilon^t\mu_{\Upsilon,t}}I_t+Q_{\bar K,t}(1-\delta)\bar K_t
\leq {} &(1-\tau^l)\int_0^1W^i_th_{it}\,di+R_tB_t \\
&+(R_t^L)^{40}B_t^L+Q_{\bar K,t}\bar K_{t+1}+\Pi_t .
\end{aligned}
$$

### Labor unions

Each household contains all differentiated labor types. Monopoly unions set wages subject to Calvo wage frictions. Non-reoptimizing wages follow:

$$
W_{it}=(\mu_{z^{\ast},t})^{\iota_\mu}(\mu_{z^{\ast}})^{1-\iota_\mu}\tilde{\pi}_{w,t}W_{i,t-1},
\qquad
\tilde{\pi}_{w,t}=(\pi_t^{target})^{\iota_w}(\pi_{t-1})^{1-\iota_w}.
$$

## 3. First-Order Conditions

**Price setting and production**

- **(F1) Reset-price index recursion** (`needs_review`; implementation cross-check Eqn 1):

$$
p_t^{\ast}=
\left[
(1-\xi_p)\left(\frac{K_{p,t}}{F_{p,t}}\right)^{\lambda_{f,t}/(1-\lambda_{f,t})}
+\xi_p\left(\frac{\tilde{\pi}_t}{\pi_t}p_{t-1}^{\ast}\right)^{\lambda_{f,t}/(1-\lambda_{f,t})}
\right]^{(1-\lambda_{f,t})/\lambda_{f,t}} .
$$

- **(F2) Price auxiliary recursion $F_p$** (`needs_review`; implementation cross-check Eqn 2):

$$
F_{p,t}=\zeta_{c,t}\lambda_{z,t}Y_{z,t}
+\beta\xi_pE_t\left[
\left(\frac{\tilde{\pi}_{t+1}}{\pi_{t+1}}\right)^{1/(1-\lambda_{f,t+1})}F_{p,t+1}
\right].
$$

- **(F3) Price auxiliary recursion $K_p$** (`needs_review`; implementation cross-check Eqn 3):

$$
K_{p,t}=\zeta_{c,t}\lambda_{f,t}\lambda_{z,t}Y_{z,t}s_t
+\beta\xi_pE_t\left[
\left(\frac{\tilde{\pi}_{t+1}}{\pi_{t+1}}\right)^{\lambda_{f,t+1}/(1-\lambda_{f,t+1})}K_{p,t+1}
\right].
$$

- **(F4) Scaled output definition** (`needs_review`; source production equation and implementation cross-check auxiliary `yz`):

$$
Y_{z,t}=(p_t^{\ast})^{\lambda_{f,t}/(\lambda_{f,t}-1)}
\left[
\epsilon_t\left(u_t\frac{\bar k_{t-1}}{\mu_{z^{\ast},t}\Upsilon}\right)^{\alpha}
\left(H_t(w_t^{\ast})^{\lambda_w/(\lambda_w-1)}\right)^{1-\alpha}
-\phi
\right].
$$

- **(F5) Capital utilization condition** (`needs_review`; implementation cross-check Eqn 9):

$$
r^k_t=\tau_t^{oil}r^k_{ss}\exp\{\sigma_a(u_t-1)\}.
$$

- **(F6) Rental rate on capital services** (`needs_review`; implementation cross-check Eqn 10):

$$
r^k_t=\alpha\epsilon_t
\left(\frac{\Upsilon\mu_{z^{\ast},t}H_t(w_t^{\ast})^{\lambda_w/(\lambda_w-1)}}{u_t\bar k_{t-1}}\right)^{1-\alpha}s_t .
$$

- **(F7) Marginal cost** (`needs_review`; implementation cross-check Eqn 11):

$$
s_t=\frac{(r^k_t/\alpha)^\alpha(\tilde w_t/(1-\alpha))^{1-\alpha}}{\epsilon_t}.
$$

**Households, capital, and investment**

- **(F8) Capital accumulation** (`needs_review`; source equation 6 and implementation cross-check Eqn 13):

$$
\bar k_t=(1-\delta)\frac{\bar k_{t-1}}{\mu_{z^{\ast},t}\Upsilon}
+\left[1-S\left(\zeta_{I,t}\mu_{z^{\ast},t}\Upsilon I_t/I_{t-1}\right)\right]I_t .
$$

- **(F9) Risk-free bond Euler equation** (`needs_review`; implementation cross-check Eqn 14):

$$
\zeta_{c,t}\lambda_{z,t}
=\beta E_t\left[
\frac{\zeta_{c,t+1}\lambda_{z,t+1}}{\mu_{z^{\ast},t+1}\pi_{t+1}}
\left(1+(1-\tau^d)R_t^e\right)
\right].
$$

- **(F10) Marginal utility of consumption with habit** (`needs_review`; implementation cross-check Eqn 15):

$$
(1+\tau^c)\zeta_{c,t}\lambda_{z,t}
=\frac{\mu_{z^{\ast},t}\zeta_{c,t}}{C_t\mu_{z^{\ast},t}-bC_{t-1}}
-\beta bE_t\left[\frac{\zeta_{c,t+1}}{C_{t+1}\mu_{z^{\ast},t+1}-bC_t}\right].
$$

- **(F11) No-financial-frictions capital Euler equation** (`needs_review`; paper states this replaces the financial accelerator block; implementation cross-check Eqn 16):

$$
\zeta_{c,t}\lambda_{z,t}
=\beta E_t\left[
\frac{\zeta_{c,t+1}\lambda_{z,t+1}}{\mu_{z^{\ast},t+1}\pi_{t+1}}
(1+R^k_{t+1})
\right].
$$

- **(F12) Return on capital** (`needs_review`; source equation 10 and implementation cross-check Eqn 17):

$$
1+R^k_t=
\frac{\left[(1-\tau^k)\left(u_tr^k_t-\tau_t^{oil}a(u_t)\right)+(1-\delta)q_t\right]\pi_t}
\{\Upsilon q_{t-1}\}
+\tau^k\delta .
$$

- **(F13) Investment/Tobin's Q condition** (`needs_review`; implementation cross-check Eqn 18):

$$
0=-\frac{\zeta_{c,t}\lambda_{z,t}}{\mu_{\Upsilon,t}}
+\zeta_{c,t}\lambda_{z,t}q_t
\left[
1-S_t-S'_t\frac{\zeta_{I,t}\mu_{z^{\ast},t}\Upsilon I_t}{I_{t-1}}
\right]
+\beta E_t\left[
\frac{\zeta_{c,t+1}\lambda_{z,t+1}q_{t+1}S'_{t+1}}{\mu_{z^{\ast},t+1}\Upsilon}
\left(\frac{\zeta_{I,t+1}\mu_{z^{\ast},t+1}\Upsilon I_{t+1}}{I_t}\right)^2
\right].
$$

**Wage setting**

- **(F14) Wage reset recursion** (`needs_review`; implementation cross-check Eqn 8):

$$
w_t^{\ast}=
\left[
(1-\xi_w)A_{w,t}^{\lambda_w}
+\xi_w\left(\frac{\tilde{\pi}_{w,t}}{\pi_{w,t}}
\mu_{z^{\ast}}^{1-\iota_\mu}\mu_{z^{\ast},t}^{\iota_\mu}w_{t-1}^{\ast}\right)^{\lambda_w/(1-\lambda_w)}
\right]^{(1-\lambda_w)/\lambda_w},
$$

where $A_{w,t}$ is the standard Calvo wage adjustment term implied by the wage aggregator. Its exact OCR-normalized expression is `needs_review`.

- **(F15) Wage auxiliary recursion $F_w$** (`needs_review`; implementation cross-check Eqn 5):

$$
F_{w,t}=\zeta_{c,t}\lambda_{z,t}(w_t^{\ast})^{\lambda_w/(\lambda_w-1)}H_t\frac{1-\tau^l}{\lambda_w}
+\beta\xi_wE_t\left[\mathcal I^F_{w,t+1}F_{w,t+1}\right].
$$

- **(F16) Wage auxiliary recursion $K_w$** (`needs_review`; implementation cross-check Eqn 6):

$$
K_{w,t}=\zeta_{c,t}\left[(w_t^{\ast})^{\lambda_w/(\lambda_w-1)}H_t\right]^{1+\sigma_L}
+\beta\xi_wE_t\left[\mathcal I^K_{w,t+1}K_{w,t+1}\right].
$$

The indexation kernels $\mathcal I^F_{w,t+1}$ and $\mathcal I^K_{w,t+1}$ depend on wage inflation, target inflation, and $\mu_{z^{\ast},t+1}$; exact normalization remains `needs_review`.

## 4. Market Clearing & Identities

- **(F17) Resource constraint without monitoring costs** (`needs_review`; implementation cross-check Eqn 12):

$$
Y_{z,t}=g_t+C_t+\frac{I_t}{\mu_{\Upsilon,t}}
+\tau_t^{oil}a(u_t)\frac{\bar k_{t-1}}{\mu_{z^{\ast},t}\Upsilon}.
$$

- **(F18) Final-output accounting identity** (`needs_review`; implementation cross-check auxiliary `y`):

$$
Y_t=g_t+C_t+\frac{I_t}{\mu_{\Upsilon,t}}.
$$

- **(F19) GDP growth observable identity** (`needs_review`; implementation cross-check observation equation):

$$
gdp\_obs_t=
\frac{C_t+I_t/\mu_{\Upsilon,t}+g_t}{C_{t-1}+I_{t-1}/\mu_{\Upsilon,t-1}+g_{t-1}}
\frac{\mu_{z^{\ast},t}}{\mu_{z^{\ast}}} .
$$

- **(F20) Consumption growth observable identity** (`needs_review`; implementation cross-check observation equation):

$$
consumption\_obs_t=\frac{C_t}{C_{t-1}}\frac{\mu_{z^{\ast},t}}{\mu_{z^{\ast}}} .
$$

- **(F21) Investment growth observable identity** (`needs_review`; implementation cross-check observation equation):

$$
investment\_obs_t=\frac{I_t}{I_{t-1}}\frac{\mu_{z^{\ast},t}}{\mu_{z^{\ast}}} .
$$

- **(F22) Relative investment price observable identity** (`needs_review`; implementation cross-check observation equation):

$$
pinvest\_obs_t=\frac{\mu_{\Upsilon,t-1}}{\mu_{\Upsilon,t}} .
$$

- **(F23) Real risk-free rate observable identity** (`needs_review`; implementation cross-check observation equation):

$$
RealRe\_obs_t=
\frac{(1+R^e_t)/\pi_{t+1}}{(1+R^e)/\pi}.
$$

## 5. Exogenous Processes

- **(F24) Monetary policy rule** (`needs_review`; paper equation 18 and implementation cross-check Eqn 20):

$$
\log\left(\frac{R^e_t}{R^e}\right)
=\rho_p\log\left(\frac{R^e_{t-1}}{R^e}\right)
+\frac{1-\rho_p}{R^e}\left[
\alpha_\pi\pi\log\left(\frac{\pi_{t+1}}{\pi_t^{target}}\right)
+\frac{\alpha_{\Delta y}}{4}\mu_{z^{\ast}}\log(gdp\_obs_t)
\right].
$$

- **(F25) Transitory technology shock**:

$$
\log(\epsilon_t/\epsilon)=\rho_\epsilon\log(\epsilon_{t-1}/\epsilon)+e_{\epsilon,t}.
$$

- **(F26) Government demand**:

$$
\log(g_t/g)=\rho_g\log(g_{t-1}/g)+e_{g,t}.
$$

- **(F27) Price markup shock**:

$$
\log(\lambda_{f,t}/\lambda_f)=\rho_{\lambda_f}\log(\lambda_{f,t-1}/\lambda_f)+e_{\lambda_f,t}.
$$

- **(F28) Investment-specific technology shock**:

$$
\log(\mu_{\Upsilon,t}/\mu_\Upsilon)=\rho_{\mu_\Upsilon}\log(\mu_{\Upsilon,t-1}/\mu_\Upsilon)+e_{\mu_\Upsilon,t}.
$$

- **(F29) Persistent growth shock**:

$$
\log(\mu_{z^{\ast},t}/\mu_{z^{\ast}})=\rho_{\mu_z}\log(\mu_{z^{\ast},t-1}/\mu_{z^{\ast}})+e_{\mu_z,t}.
$$

- **(F30) Inflation target shock**:

$$
\log(\pi_t^{target}/\pi^{target})=\rho_{\pi^{\ast}}\log(\pi_{t-1}^{target}/\pi^{target})+e_{\pi^{\ast},t}.
$$

- **(F31) Consumption preference shock**:

$$
\log(\zeta_{c,t}/\zeta_c)=\rho_{\zeta_c}\log(\zeta_{c,t-1}/\zeta_c)+e_{\zeta_c,t}.
$$

- **(F32) Marginal efficiency of investment shock**:

$$
\log(\zeta_{I,t}/\zeta_I)=\rho_{\zeta_I}\log(\zeta_{I,t-1}/\zeta_I)+e_{\zeta_I,t}.
$$

The risk shock $\sigma_t$, equity shock $\gamma_t$, credit-spread observable, credit observable, net-worth observable, and term-premium shock are not active in `US_CMR14noFA`; the `.mod` keeps only the nonfinancial shock set above.

## 6. Steady-State Solution

The source fixes steady-state growth and calibration targets rather than providing a full hand-solvable `steady_state_model` in the article body. This first-pass entry records the source-backed order:

1. Set normalized shocks at their means:
   $\epsilon=1$, $\mu_\Upsilon=1$, $\zeta_c=1$, $\zeta_I=1$, $\lambda_f=1.2$, $\pi^{target}=\pi=1.006010795406775$, and $\mu_{z^{\ast}}=1.004124413586981$.
2. Fix calibrated parameters:
   $\beta=0.998704208591811$, $\delta=0.025$, $\alpha=0.4$, $\lambda_w=1.05$, $\tau^c=0.047$, $\tau^l=0.241$, $\tau^k=0.32$, $\psi_L=0.7705$.
3. Normalize utilization and capital price:
   $u=1$, $q=1$, $p^{\ast}=1$, $w^{\ast}=1$.
4. Use the bond Euler equation and inflation target to pin down the steady-state nominal net risk-free rate $R^e$.
5. Use utilization, rental-rate, marginal-cost, production, and zero-profit fixed-cost conditions to solve $r^k$, $s$, $\bar k$, $H$, $Y_z$, and $\phi$.
6. Use capital accumulation with $S=0$ and $S'=0$ at the steady state to solve investment:

   $$
   I=\left[1-\frac{1-\delta}{\mu_{z^{\ast}}\Upsilon}\right]\bar k.
   $$

7. Set government spending so that $g/(C+I)=\eta_g/(1-\eta_g)$, equivalently $g/Y=0.20$ in the calibrated steady state.
8. Use the resource constraint and consumption FOC to determine $C$, $\lambda_z$, and the wage block auxiliary values $F_w,K_w,F_p,K_p$.

Implementation cross-check steady-state values include $C=1.72001$, $I=1.28368$, $g=0.771211$, $\bar k=38.7956$, $H=1.08818$, $Y=3.7749$, $q=1$, $u=1$, $R^e=0.0114707$, $R^k=0.0114707$, $r^k=0.0392464$, and $s=0.833333$. These numbers are recorded as `implementation_cross_check`, not paper-side derivation evidence.

## 7. Timing & Form Conventions

- $\bar k_t$ is end-of-period raw capital. Production in period $t$ uses $\bar k_{t-1}$ scaled by $\mu_{z^{\ast},t}\Upsilon$ and adjusted by utilization $u_t$.
- The no-financial-frictions model uses a household capital Euler equation for $R^k_{t+1}$; it does not include entrepreneurial leverage, default cutoff, credit spread, or net-worth dynamics.
- Price and wage setting are Calvo with indexation to lagged inflation and the inflation target; wage indexation also uses steady-state and current growth terms.
- The model is solved as a first-order approximation around a stationary scaled nonlinear equilibrium. Observation equations report growth rates and level deviations consistent with the data transformations.
- Runtime validation, residual checks, BK checks, IRFs, and equation-count reconciliation are deferred.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII name | Meaning | Determined by |
|---|---|---|---|
| Endogenous | `c`, $C_t$ | Consumption | (F10), (F17) |
| Endogenous | `i`, $I_t$ | Investment | (F13), (F17) |
| Endogenous | `kbar`, $\bar k_t$ | End-of-period raw capital | (F8) |
| Endogenous | `q`, $q_t$ | Price of installed/raw capital | (F13) |
| Endogenous | `u`, $u_t$ | Capital utilization | (F5) |
| Endogenous | `rk`, $r_t^k$ | Rental rate on capital services | (F5), (F6) |
| Endogenous | `Rk`, $R_t^k$ | Gross/net return on capital convention | (F11), (F12) |
| Endogenous | `Re`, $R_t^e$ | Risk-free policy/bond rate | (F9), (F24) |
| Endogenous | `pi`, $\pi_t$ | Inflation | (F1)-(F3), (F24) |
| Endogenous | `pitarget`, $\pi_t^{target}$ | Inflation target | (F30) |
| Endogenous | `pstar`, $p_t^{\ast}$ | Reset-price relative price | (F1) |
| Endogenous | `Fp`, $F_{p,t}$ | Price-setting auxiliary | (F2) |
| Endogenous | `s`, $s_t$ | Marginal cost | (F7) |
| Endogenous | `h`, $H_t$ | Hours / homogeneous labor | (F4), (F15)-(F16) |
| Endogenous | `wstar`, $w_t^{\ast}$ | Reset wage | (F14) |
| Endogenous | `wtilde`, $\tilde w_t$ | Scaled real wage | (F7), wage block |
| Endogenous | `Fw`, $F_{w,t}$ | Wage-setting auxiliary | (F15) |
| Endogenous | `g`, $g_t$ | Government demand | (F26) |
| Endogenous | `y`, $Y_t$ | Output identity | (F18) |
| Endogenous | `epsil`, $\epsilon_t$ | Transitory technology level | (F25) |
| Endogenous | `lambdaf`, $\lambda_{f,t}$ | Price markup shock | (F27) |
| Endogenous | `muup`, $\mu_{\Upsilon,t}$ | Investment-specific technology | (F28) |
| Endogenous | `muzstar`, $\mu_{z^{\ast},t}$ | Stationary growth factor | (F29) |
| Endogenous | `zetac`, $\zeta_{c,t}$ | Consumption preference shifter | (F31) |
| Endogenous | `zetai`, $\zeta_{I,t}$ | Marginal efficiency of investment | (F32) |
| Endogenous | `*_obs` | Measurement equations for observables | (F19)-(F23) |
| Exogenous | `e_epsil` | Innovation to transitory technology | (F25) |
| Exogenous | `e_lambdaf` | Innovation to price markup | (F27) |
| Exogenous | `e_muup` | Innovation to investment-specific technology | (F28) |
| Exogenous | `e_muzstar` | Innovation to persistent growth | (F29) |
| Exogenous | `e_pitarget` | Innovation to inflation target | (F30) |
| Exogenous | `e_zetac` | Innovation to preference shock | (F31) |
| Exogenous | `e_zetai` | Innovation to marginal efficiency shock | (F32) |
| Exogenous | `e_g` | Innovation to government demand | (F26) |
| Parameter | `beta_p`, $\beta$ | Discount factor | -- |
| Parameter | `alpha_p`, $\alpha$ | Capital share | -- |
| Parameter | `delta_p`, $\delta$ | Depreciation | -- |
| Parameter | `xip_p`, $\xi_p$ | Calvo price stickiness | -- |
| Parameter | `xiw_p`, $\xi_w$ | Calvo wage stickiness | -- |
| Parameter | `lambdaf_p`, $\lambda_f$ | Steady-state price markup | -- |
| Parameter | `lambdaw_p`, $\lambda_w$ | Steady-state wage markup | -- |
| Parameter | `b_p`, $b$ | Habit persistence | -- |
| Parameter | `sigmaL_p`, $\sigma_L$ | Labor disutility curvature | -- |
| Parameter | `Sdoupr_p`, $S''$ | Investment adjustment cost curvature | -- |
| Parameter | `rhotil_p`, $\rho_p$ | Policy smoothing | -- |
| Parameter | `aptil_p`, $\alpha_\pi$ | Policy inflation response | -- |
| Parameter | `adytil_p`, $\alpha_{\Delta y}$ | Policy output-growth response | -- |
| Parameter | `rho*`, `std*` | Shock persistence and innovation scales | -- |
