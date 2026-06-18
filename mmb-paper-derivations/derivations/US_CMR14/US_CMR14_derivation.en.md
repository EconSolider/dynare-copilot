# US_CMR14 -- Derivation (optimization problems + first-order conditions)

> First-pass MMB archive extraction. Formula status: `needs_review`; equations are based on the MinerU Markdown for the AER article and an implementation cross-check, but the online technical appendix/PDF formulas were not source-level checked and Dynare was not run.

## 1. Model Overview

- **Model ID**: `US_CMR14`.
- **Paper**: Christiano, Lawrence J.; Motto, Roberto; Rostagno, Massimo (2014), "Risk Shocks", *American Economic Review* 104(1), 27-65, DOI `10.1257/aer.104.1.27`.
- **Primary source**: `raw/mmb_mineru/runs/us_cmr14_us_cmr14nofa__risk_shocks__d33971b2/full.md`; raw PDF recorded at `raw/mmb_papers/Risk shocks.pdf`.
- **MMB variant**: baseline risk-shock model with CEE-style nominal rigidities and BGG-style entrepreneurial financial frictions. The article also discusses a CEE version without the three financial-friction equations; `US_CMR14` keeps the financial accelerator and risk-news block.
- **Agents**: final-good aggregator, monopolistically competitive intermediate-good producers, labor contractor and Calvo wage unions, representative household, capital producer/household capital builder, entrepreneurs, mutual funds, government demand, and a monetary authority.
- **Form**: the article states nonlinear and stationary-scaled equilibrium blocks but estimates a log-linear perturbation around a nonstochastic steady state. The MMB file is nonlinear Dynare syntax solved and simulated locally by Dynare; this archive entry records source-side nonlinear conditions plus paper-stated linear policy/news equations. Overall formula quality is `needs_review`.
- **Runtime validation**: not performed; Dynare was not run.

## 2. Optimization Problems

### Final-good aggregator

The competitive final-good firm combines differentiated intermediate goods:

```math
Y_t=\left[\int_0^1Y_{jt}^{1/\lambda_{f,t}}\,dj\right]^{\lambda_{f,t}},\qquad 1\leq \lambda_{f,t}<\infty .
```

### Intermediate-good producers

Intermediate firm $`j`$ rents effective capital services and homogeneous labor:

```math
Y_{jt}=
\begin{cases}
\epsilon_tK_{jt}^{\alpha}(z_tl_{jt})^{1-\alpha}-\Phi z_t^{\ast},&
\epsilon_tK_{jt}^{\alpha}(z_tl_{jt})^{1-\alpha}>\Phi z_t^{\ast},\\
0,&\text{otherwise},
\end{cases}
\qquad 0<\alpha<1.
```

Prices are set under Calvo friction. A fraction $`1-\xi_p`$ can reset prices, while non-resetters index according to:

```math
\tilde{\pi}_t=(\pi_t^{target})^\iota(\pi_{t-1})^{1-\iota}.
```

### Labor contractor and monopoly unions

The labor contractor aggregates differentiated labor services:

```math
l_t=\left[\int_0^1h_{it}^{1/\lambda_w}\,di\right]^{\lambda_w},\qquad 1\leq\lambda_w .
```

Each labor type is supplied by a monopoly union with Calvo wage setting. Non-resetting wages are indexed using:

```math
\tilde{\pi}_{w,t}=(\pi_t^{target})^{\iota_w}(\pi_{t-1})^{1-\iota_w}.
```

### Representative household and capital construction

The household chooses consumption, bond holdings, investment, and raw capital. It has preferences:

```math
E_0\sum_{t=0}^{\infty}\beta^t\zeta_{c,t}
\left[
\log(C_t-bC_{t-1})-\psi_L\int_0^1\frac{h_{it}^{1+\sigma_L}}{1+\sigma_L}\,di
\right].
```

It builds end-of-period raw capital according to:

```math
\bar K_{t+1}=(1-\delta)\bar K_t+\left[1-S\left(\zeta_{I,t}I_t/I_{t-1}\right)\right]I_t.
```

The budget constraint allocates nominal resources to consumption, one-period bonds, long bonds, investment goods, and existing capital, financed by labor income, bond returns, sales of raw capital, and lump-sum payments. The OCR version of the budget line is usable but bracket-damaged; exact tax and long-bond placement is marked `needs_review`.

### Entrepreneurs and mutual funds

An entrepreneur with net worth $`N`$ borrows $`B_{t+1}^N`$ and buys raw capital:

```math
Q_{\bar K,t}\bar K_{t+1}^N=N+B_{t+1}^N.
```

Idiosyncratic productivity $`\omega`$ is lognormal with unit mean and time-varying cross-sectional standard deviation $`\sigma_t`$ for $`\log\omega`$. The debt contract is represented by leverage $`L_t`$ and default cutoff $`\bar\omega_{t+1}`$:

```math
L_t=\frac{Q_{\bar K,t}\bar K_{t+1}^N}{N}.
```

Entrepreneurs maximize expected next-period net worth subject to mutual-fund zero profit and costly monitoring. Mutual funds are competitive and pay the household risk-free nominal return.

### Government and monetary authority

Government consumption is exogenous after scaling by the economy-wide trend. The monetary authority follows the paper's linearized short-rate rule with interest-rate smoothing, expected inflation-target gap, output growth, and a monetary policy innovation.

## 3. First-Order Conditions

**Production, prices, and wages**

- **(F1) Final-good demand for intermediate input** (`needs_review`; implied by source equation 1):

```math
Y_{jt}=\left(\frac{P_{jt}}{P_t}\right)^{-\lambda_{f,t}/(\lambda_{f,t}-1)}Y_t .
```

- **(F2) Effective capital demand / rental rate** (`needs_review`; paper states technology, implementation cross-check supplies stationary condition):

```math
r_t^k=\alpha\epsilon_t
\left(\frac{\Upsilon\mu_{z,t}^{\ast}h_t(w_t^{\ast})^{\lambda_w/(\lambda_w-1)}}{u_t\bar k_{t-1}}\right)^{1-\alpha}s_t .
```

- **(F3) Marginal cost** (`needs_review`; implementation cross-check only for stationary scaling):

```math
s_t=\frac{(r_t^k/\alpha)^\alpha(\tilde w_t/(1-\alpha))^{1-\alpha}}{\epsilon_t}.
```

- **(F4) Price-index recursion for reset price** (`needs_review`; paper states Calvo/indexation, formula checked against `.mod` only):

```math
p_t^{\ast}=\left[(1-\xi_p)\left(\frac{K_{p,t}}{F_{p,t}}\right)^{\lambda_{f,t}/(1-\lambda_{f,t})}
\xi_p\left(\frac{\tilde\pi_t}{\pi_t}p_{t-1}^{\ast}\right)^{\lambda_{f,t}/(1-\lambda_{f,t})}\right]^{(1-\lambda_{f,t})/\lambda_{f,t}} .
```

- **(F5) Price auxiliary recursion $`F_p`$** (`needs_review`; implementation cross-check):

```math
F_{p,t}=\zeta_{c,t}\lambda_{z,t}Y_{z,t}
\left(\frac{\tilde\pi_{t+1}}{\pi_{t+1}}\right)^{1/(1-\lambda_{f,t+1})}\beta\xi_pF_{p,t+1}.
```

- **(F6) Price auxiliary recursion $`K_p`$** (`needs_review`; implementation cross-check):

```math
K_{p,t}=\zeta_{c,t}\lambda_{f,t}\lambda_{z,t}Y_{z,t}s_t
\beta\xi_p\left(\frac{\tilde\pi_{t+1}}{\pi_{t+1}}\right)^{\lambda_{f,t+1}/(1-\lambda_{f,t+1})}K_{p,t+1}.
```

- **(F7) Stationary output definition** (`needs_review`; source production equation plus implementation scaling):

```math
Y_{z,t}=(p_t^{\ast})^{\lambda_f/(\lambda_f-1)}
\left[
\epsilon_t\left(\frac{u_t\bar k_{t-1}}{\mu_{z,t}^{\ast}\Upsilon}\right)^\alpha
\left(h_t(w_t^{\ast})^{\lambda_w/(\lambda_w-1)}\right)^{1-\alpha}
-\phi
\right].
```

- **(F8) Wage reset index** (`needs_review`; paper states Calvo wage setup, implementation cross-check supplies recursion):

```math
w_t^{\ast}=\left[(1-\xi_w)A_{w,t}^{\lambda_w}
\xi_w\left(\frac{\tilde\pi_{w,t}}{\pi_{w,t}}(\mu_{z^{\ast}})^{1-\iota_\mu}(\mu_{z^{\ast},t})^{\iota_\mu}w_{t-1}^{\ast}\right)^{\lambda_w/(1-\lambda_w)}\right]^{(1-\lambda_w)/\lambda_w}.
```

- **(F9) Wage auxiliary recursion $`F_w`$** (`needs_review`; implementation cross-check):

```math
F_{w,t}=\zeta_{c,t}\lambda_{z,t}(w_t^{\ast})^{\lambda_w/(\lambda_w-1)}h_t\frac{1-\tau^l}{\lambda_w}
\beta\xi_wE_t[\mathcal I^F_{w,t+1}F_{w,t+1}].
```

- **(F10) Wage auxiliary recursion $`K_w`$** (`needs_review`; implementation cross-check):

```math
K_{w,t}=\zeta_{c,t}\left[(w_t^{\ast})^{\lambda_w/(\lambda_w-1)}h_t\right]^{1+\sigma_L}
\beta\xi_wE_t[\mathcal I^K_{w,t+1}K_{w,t+1}].
```

**Household, capital, and utilization**

- **(F11) Household marginal utility of consumption** (`needs_review`; source preference equation 7 and `.mod`):

```math
(1+\tau^c)\zeta_{c,t}\lambda_{z,t}
=\frac{\mu_{z,t}^{\ast}\zeta_{c,t}}{c_t\mu_{z,t}^{\ast}-bc_{t-1}}
-b\beta E_t\left[\frac{\zeta_{c,t+1}}{c_{t+1}\mu_{z,t+1}^{\ast}-bc_t}\right].
```

- **(F12) One-period bond Euler equation** (`needs_review`; source budget equation 8 and `.mod`):

```math
\zeta_{c,t}\lambda_{z,t}
=\beta E_t\left[\frac{\zeta_{c,t+1}\lambda_{z,t+1}}{\mu_{z,t+1}^{\ast}\pi_{t+1}}\left(1+(1-\tau^d)R_t^e\right)\right].
```

- **(F13) Capital utilization condition** (`needs_review`; source utilization cost function):

```math
r_t^k=\tau_t^{oil}a'(u_t),\qquad
a(u)=r^k\frac{\exp[\sigma_a(u-1)]-1}{\sigma_a}.
```

- **(F14) Return on capital** (`needs_review`; source equation 10, stationary scaling from implementation):

```math
1+R_t^k=
\frac{\left[(1-\tau^k)(u_tr_t^k-\tau_t^{oil}a(u_t))+(1-\delta)q_t\right]\pi_t}{\Upsilon q_{t-1}}
+\tau^k\delta .
```

- **(F15) Capital accumulation** (`needs_review`; source equation 6, stationary scaling from implementation):

```math
\bar k_t=(1-\delta)\frac{\bar k_{t-1}}{\mu_{z,t}^{\ast}\Upsilon}
+\left[1-S\left(\zeta_{I,t}\mu_{z,t}^{\ast}\Upsilon I_t/I_{t-1}\right)\right]I_t .
```

- **(F16) Investment FOC / supply price of capital** (`needs_review`; source adjustment-cost function and `.mod`):

```math
0=-\frac{\zeta_{c,t}\lambda_{z,t}}{\mu_{\Upsilon,t}}
+\zeta_{c,t}\lambda_{z,t}q_t\left[1-S_t-S_t'x_t\right]
+\beta E_t\left[\frac{\zeta_{c,t+1}\lambda_{z,t+1}q_{t+1}S_{t+1}'x_{t+1}^2}{\mu_{z,t+1}^{\ast}\Upsilon}\right].
```

**Financial contract**

- **(F17) Net worth aggregation** (source equation 9):

```math
N_{t+1}=\int_0^\infty N f_t(N)\,dN.
```

- **(F18) Default cutoff** (source equation 11):

```math
R_{t+1}^k\bar\omega_{t+1}Q_{\bar K,t}\bar K_{t+1}^N=B_{t+1}^NZ_{t+1}.
```

- **(F19) Entrepreneur objective value** (source equation 12):

```math
E_t\left[1-\Gamma_t(\bar\omega_{t+1})\right]R_{t+1}^kL_tN .
```

- **(F20) Contract share functions** (source after equation 12):

```math
\Gamma_t(\bar\omega_{t+1})=[1-F_t(\bar\omega_{t+1})]\bar\omega_{t+1}+G_t(\bar\omega_{t+1}),\qquad
G_t(\bar\omega_{t+1})=\int_0^{\bar\omega_{t+1}}\omega\,dF_t(\omega).
```

- **(F21) Mutual-fund zero-profit constraint** (source equation 14):

```math
\Gamma_t(\bar\omega_{t+1})-\mu G_t(\bar\omega_{t+1})
=\frac{L_t-1}{L_t}\frac{R_t}{R_{t+1}^k}.
```

- **(F22) Standard debt contract optimality** (`needs_review`; paper states it exists, online appendix/code contain detailed list):

```math
0=E_t\left\{
[1-\Gamma_t(\bar\omega_{t+1})]\frac{1+R_{t+1}^k}{1+R_t^e}
+\frac{\Gamma_t'(\bar\omega_{t+1})}{\Gamma_t'(\bar\omega_{t+1})-\mu G_t'(\bar\omega_{t+1})}
\left[
\frac{1+R_{t+1}^k}{1+R_t^e}\left(\Gamma_t(\bar\omega_{t+1})-\mu G_t(\bar\omega_{t+1})\right)-1
\right]
\right\}.
```

- **(F23) Aggregate capital purchased by entrepreneurs** (source equation 15):

```math
\bar K_{t+1}=\int_0^\infty \bar K_{t+1}^N f_t(N)\,dN.
```

- **(F24) Aggregate capital services** (source equation 16):

```math
K_t=\int_0^\infty\int_0^\infty u_t^N\omega\bar K_t^N f_{t-1}(N)\,dF(\omega)\,dN
=u_t\bar K_t.
```

- **(F25) Entrepreneurial net worth law of motion** (source equation 17):

```math
N_{t+1}=\gamma_t\left[1-\Gamma_{t-1}(\bar\omega_t)\right]R_t^kQ_{\bar K,t-1}\bar K_t+W_t^e.
```

- **(F26) Aggregate credit to entrepreneurs** (source text after equation 17):

```math
B_{t+1}=Q_{\bar K,t}\bar K_{t+1}-N_{t+1}.
```

- **(F27) Entrepreneur loan rate** (source text after equation 17):

```math
Z_{t+1}=R_{t+1}^k\bar\omega_{t+1}L_t.
```

## 4. Market Clearing & Identities

- **(F28) Resource constraint** (`needs_review`; paper-side formula, stationarity/scaling not fully repaired):

```math
Y_t=D_t+G_t+C_t+\frac{I_t}{\Upsilon^t\mu_{\Upsilon,t}}+a(u_t)\Upsilon^{-t}\bar K_t.
```

- **(F29) Monitoring resource cost** (`needs_review`; paper-side notation has price/scaling ambiguity in OCR):

```math
D_t=\mu G(\bar\omega_t)(1+R_t^k)\frac{Q_{\bar K,t-1}\bar K_t}{P_t}.
```

- **(F30) Government consumption scaling** (source equation 19):

```math
G_t=z_t^{\ast}g_t.
```

- **(F31) Long-term nominal bond measurement relation** (source Section ID):

```math
(R_t^L)^{40}=(\tilde R_t^L)^{40}\eta_{t+1}\cdots\eta_{t+40}.
```

## 5. Exogenous Processes

- **(F32) Generic shock process with news** (source equation 20):

```math
x_t=\rho_xx_{t-1}+\xi_{0,t}+\xi_{1,t-1}+\cdots+\xi_{p,t-p}.
```

For `US_CMR14`, the baseline information structure puts news on risk $`\sigma_t`$ with horizons 0 through 8 in the MMB implementation.

- **(F33) News-shock correlation structure** (source equation 21):

```math
\rho_{x,n}^{|i-j|}
=\frac{E[\xi_{i,t}\xi_{j,t}]}
{\sqrt{E[\xi_{i,t}^2]E[\xi_{j,t}^2]}},
\qquad i,j=0,\ldots,p.
```

- **(F34) Monetary policy rule** (source equation 18; linearized):

```math
R_t-R=\rho_p(R_{t-1}-R)
+(1-\rho_p)\left[
\alpha_\pi(\pi_{t+1}-\pi_t^{\ast})
+\alpha_{\Delta y}\frac{1}{4}(g_{y,t}-\mu_{z^{\ast}})
\right]
+\frac{1}{400}\varepsilon_t^p.
```

- **(F35) Idiosyncratic-risk distribution** (`needs_review`; source text):

```math
\log\omega\sim\mathcal N\left(-\frac{\sigma_t^2}{2},\sigma_t^2\right),\qquad E[\omega]=1.
```

Other exogenous processes in the estimated model are first-order AR processes for the log deviations of term premium, transitory technology, persistent growth, price markup, inflation target, consumption preference, investment-specific technology, marginal efficiency of investment, equity transfer rate, government spending, and risk. The article states these as AR(1) processes but only displays the generic representation and selected parameter values.

## 6. Steady-State Solution

The source is an estimated, growing-economy model. A full numerical steady-state reconstruction is deferred. Source-backed steady-state restrictions and targets are:

1. The model is stationary after scaling by $`z_t^{\ast}`$, where the balanced-growth object combines neutral technology growth and investment-specific growth.
2. Investment adjustment satisfies $`S(x)=S'(x)=0`$ at steady state, and utilization is normalized so that $`u=1`$.
3. The calibrated quarterly parameters include $`\beta=0.9987`$, $`\delta=0.025`$, $`\alpha=0.40`$, $`\lambda_f=1.20`$, $`\lambda_w=1.05`$, $`\psi_L=0.7705`$, $`\tau^c=0.05`$, $`\tau^k=0.32`$, $`\tau^l=0.24`$, $`1-\gamma=1-0.985`$, and $`W^e=0.005`$.
4. The government-spending-to-GDP ratio target is $`\eta_g=0.20`$.
5. Steady-state annual inflation target is 2.43 percent, and the short-term risk-free rate target is about 4.67 percent APR in the paper's Table 3.
6. The steady-state default probability $`F(\bar\omega)`$ is estimated, with posterior mode 0.0056, and the steady-state risk level implied at the posterior mode is approximately $`\sigma=0.26`$.
7. The implementation cross-check reports steady-state values such as `q=1`, `u=1`, `gamma=0.985`, `sigma=0.259199`, `omegabar=0.500971`, `muzstar=1.00412`, and `pi=1.00601`. These values are recorded only as `implementation_cross_check`.

Status: `needs_review`. A reviewer should reconstruct the full stationary steady state from the online appendix/code before using this entry for a runnable implementation.

## 7. Timing & Form Conventions

- Capital timing: $`\bar K_{t+1}`$ is built after period-$`t`$ production and used in period $`t+1`$; in the MMB implementation, `kbar(-1)` appears in period-$`t`$ production and returns.
- Entrepreneurial net worth timing: $`N_{t+1}`$ is determined after period-$`t`$ returns, transfers, and contract settlement; it constrains credit and raw-capital purchases for the next period.
- Risk timing: entrepreneurs buying capital in period $`t`$ face idiosyncratic dispersion $`\sigma_t`$ over $`\omega`$ realized in the subsequent production/payoff period. The MMB implementation uses lagged `sigma(-1)` in several default-share functions and future $`\sigma`$ in contract optimality.
- Monetary policy rule: displayed by the paper directly in linearized net-interest-rate form.
- Model form: source equilibrium is nonlinear/stationary-scaled; estimation and many reported experiments use first-order perturbation. Marked `needs_review` because several conditions are only fully listed in the online appendix/code, not in the article body.
- `.mod` use: `.agents/skills/dynare-copilot/references/examples/US_CMR14_rep.mod` was used only to cross-check variable coverage, timing, and shock names. Dynare was not run.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Main equation(s) |
|---|---|---|---|
| Endogenous | `Y`, `yz` | final output / stationary output | (F1), (F7), (F28) |
| Endogenous | `Y_j` | intermediate output | (F1), (F7) |
| Endogenous | `P_j`, `pstar`, `pi` | individual/reset prices and inflation | (F4)-(F6), (F34) |
| Endogenous | `s` | real marginal cost | (F2), (F3) |
| Endogenous | `l`, `h`, `wstar`, `wtilde` | labor aggregate, hours, reset wage, wage index | (F8)-(F10) |
| Endogenous | `c` | consumption | (F11), (F28) |
| Endogenous | `lambdaz` | marginal utility multiplier | (F11), (F12) |
| Endogenous | `i` | investment | (F15), (F16), (F28) |
| Endogenous | `q` | price of raw capital | (F16), (F18), (F25), (F26) |
| Endogenous | `kbar`, `K` | raw capital and effective capital services | (F15), (F23), (F24) |
| Endogenous | `u` | utilization | (F13), (F14), (F24) |
| Endogenous | `rk`, `Rk` | rental and total return on capital | (F13), (F14), (F18), (F22) |
| Endogenous | `n` | entrepreneurial net worth | (F17), (F25), (F26) |
| Endogenous | `omegabar` | default cutoff | (F18), (F20)-(F22), (F27) |
| Endogenous | `B`, `credit_obs` | entrepreneurial credit | (F26) |
| Endogenous | `Re`, `R`, `Z` | risk-free and entrepreneurial debt returns | (F12), (F21), (F27), (F34) |
| Endogenous | `RL`, `rL` | long-term nominal/real rates | (F31) |
| Endogenous | `D` | monitoring resource cost | (F28), (F29) |
| Endogenous | `premium_obs`, `Spread1_obs` | credit spread observables | (F21), (F27) |
| Exogenous | `e_sigma`, `e_xi1`...`e_xi8` | unanticipated and anticipated risk-news innovations | (F32), (F33) |
| Exogenous | `e_epsil` | transitory technology innovation | (F2), (F7), AR(1) |
| Exogenous | `e_g` | government spending innovation | (F30), AR(1) |
| Exogenous | `e_gamma` | equity/entrepreneur transfer shock | (F25), AR(1) |
| Exogenous | `e_lambdaf` | price-markup shock | (F1), (F4)-(F7), AR(1) |
| Exogenous | `e_muup` | investment-specific price shock | (F15), (F16), AR(1) |
| Exogenous | `e_muzstar` | balanced-growth shock | (F7), (F11), (F12), (F15) |
| Exogenous | `e_pitarget` | inflation-target shock | (F3), (F8), (F34) |
| Exogenous | `e_term` | term premium measurement shock | (F31) |
| Exogenous | `e_zetac`, `e_zetai` | preference and marginal-efficiency investment shocks | (F11), (F15), (F16) |
| Exogenous | `e_xp` | monetary policy innovation | (F34) |
| Parameter | `beta`, `b`, `psiL`, `sigmaL` | household discounting, habit, labor disutility | (F11), (F12) |
| Parameter | `alpha`, `delta`, `lambda_f`, `lambda_w` | production, depreciation, goods/labor markups | (F1)-(F10), (F15) |
| Parameter | `xi_p`, `xi_w`, `iota`, `iota_w`, `iota_mu` | Calvo price/wage and indexation parameters | (F4)-(F10) |
| Parameter | `mu`, `gamma`, `we`, `sigma_a`, `Sdoupr` | monitoring cost, entrepreneur survival/transfer, utilization and investment adjustment costs | (F13), (F16), (F20)-(F25) |
| Parameter | `rho_*`, `std*`, `signal_corr` | shock persistence, standard deviations, risk-news correlations | (F32), (F33) |
| Parameter | `rho_p`, `alpha_pi`, `alpha_Delta_y` | monetary policy smoothing and response coefficients | (F34) |
| Parameter | `tau_c`, `tau_k`, `tau_l`, `tau_d`, `tau_o` | tax and utilization/oil wedges | (F11)-(F14) |
