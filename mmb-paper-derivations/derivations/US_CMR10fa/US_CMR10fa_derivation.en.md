# US_CMR10fa -- Derivation (optimization problems + first-order conditions)

> First-pass MMB archive extraction. Formula status: `needs_review`; equations are based on MinerU Markdown OCR and have not been checked against the PDF body or run in Dynare.

## 1. Model Overview

- **Model ID**: `US_CMR10fa`.
- **Paper**: Christiano, Lawrence J.; Motto, Roberto; Rostagno, Massimo (2010), "Financial factors in economic fluctuations - small version with financial accelerator", DOI `10.2139/ssrn.1600166`.
- **Primary source**: `raw/mmb_mineru/runs/us_cmr10_us_cmr10fa__financial_factors_in_economic_fluctuations__7ef56ea6/full.md`; raw PDF recorded at `raw/mmb_papers/Financial factors in economic fluctuations - small version with financial accelerator.pdf`.
- **Variant**: the paper's "Financial Accelerator Model" variant, which preserves the BGG-style entrepreneurial financial accelerator and removes the bank-funding channel: bank liability issuance, liquidity utility, monetary aggregates, working-capital financing, risk-news signals, and long-bond terms are shut down in the variant definition.
- **Agents**: final-good aggregator, monopolistically competitive intermediate-good producers, capital producers, entrepreneurs, a reduced banking/financial contract block for entrepreneurial credit, households with Calvo wage setting, government demand, and a monetary authority.
- **Form**: source equations are stated in stationary scaled nonlinear form in Appendix A, while the paper solves and estimates a log-linear approximation around the non-stochastic steady state. This entry records the stationary nonlinear equilibrium conditions and marks formula details as `needs_review` where OCR is damaged.
- **Runtime validation**: not performed; Dynare was not run.

## 2. Optimization Problems

### Final-good aggregator

The representative final-good firm combines differentiated intermediate goods and chooses demands for \(Y_{jt}\):

\[
Y_t=\left[\int_0^1 Y_{jt}^{1/\lambda_{f,t}}\,dj\right]^{\lambda_{f,t}},\qquad 1\leq\lambda_{f,t}<\infty .
\]

### Intermediate-good firms

Intermediate producers rent capital services and hire homogeneous labor to produce:

\[
Y_{jt}=\epsilon_t K_{jt}^{\alpha}(z_t l_{jt})^{1-\alpha}-\Phi z_t^{\ast}
\]

when the right side is positive. They face working-capital finance in the baseline paper, but `US_CMR10fa` switches off working-capital financing in the financial-accelerator variant. Price setting follows Calvo adjustment with indexation:

\[
P_{it}=\tilde{\pi}_t P_{i,t-1},\qquad
\tilde{\pi}_t=(\pi_t^{target})^\iota(\pi_{t-1})^{1-\iota}.
\]

### Capital producers

Capital producers buy investment goods and undepreciated capital, transform investment into installed capital, and maximize discounted profits:

\[
x'=x+F(I_t,I_{t-1},\zeta_{i,t})
=x+\left[1-S\left(\zeta_{i,t}I_t/I_{t-1}\right)\right]I_t.
\]

\[
\max_{\{I_{t+j},x_{t+j}\}}E_t\sum_{j=0}^{\infty}\beta^j\lambda_{t+j}\Pi^k_{t+j}.
\]

### Entrepreneurs

Entrepreneurs buy installed capital using net worth and bank loans. Their payoff is exposed to an idiosyncratic lognormal shock \(\omega\) with time-varying dispersion \(\sigma_t\). The standard debt contract chooses a cutoff \(\bar{\omega}_{t+1}\) and capital purchase \(\bar{K}_{t+1}\) subject to bank zero profit.

\[
\bar{\omega}_{t+1}(1+R^k_{t+1})Q_{\bar K',t}\bar K_{t+1}=Z_{t+1}B_{t+1},\qquad
B_{t+1}=Q_{\bar K',t}\bar K_{t+1}-N_{t+1}.
\]

### Households

Households consume, save, hold assets, and supply differentiated labor. In the full model they receive liquidity services from monetary assets; in this financial-accelerator variant those liquidity terms are set to zero. Wage setting follows Calvo adjustment with wage indexation:

\[
W_{j,t}=\tilde{\pi}_{w,t}(\mu_{z^{\ast}})^{1-\vartheta}(\mu_{z^{\ast},t})^\vartheta W_{j,t-1},
\qquad
\tilde{\pi}_{w,t}=(\pi_t^{target})^{\iota_w}(\pi_{t-1})^{1-\iota_w}.
\]

## 3. First-Order Conditions

**Goods production and pricing**

- **(F1) Marginal cost measure** (`needs_review`, source A.1):

\[
s_t=\left(\frac{1}{1-\alpha}\right)^{1-\alpha}\left(\frac{1}{\alpha}\right)^\alpha
\frac{(r_t^k[1+\psi_k R_t])^\alpha(\tilde w_t[1+\psi_l R_t])^{1-\alpha}}{\epsilon_t}.
\]

- **(F2) Alternative marginal cost measure** (`needs_review`, source A.2):

\[
s_t=\frac{r_t^k[1+\psi_kR_t]}{\alpha\epsilon_t\left(\Upsilon\frac{\mu_{z,t}^{\ast}l_t}{u_tk_t}\right)^{1-\alpha}}.
\]

- **(F3) Calvo price index recursion for reset price** (`needs_review`, source A.3):

\[
p_t^{\ast}-\left[(1-\xi_p)\left(\frac{1-\xi_p(\tilde\pi_t/\pi_t)^{1/(1-\lambda_{f,t})}}{1-\xi_p}\right)^{\lambda_{f,t}}
+\xi_p\left((\tilde\pi_t/\pi_t)p_{t-1}^{\ast}\right)^{\lambda_{f,t}/(1-\lambda_{f,t})}\right]^{(1-\lambda_{f,t})/\lambda_{f,t}}=0.
\]

- **(F4) Price auxiliary recursion \(F_p\)** (`needs_review`, source A.4):

\[
E_t\left\{\lambda_{z,t}Y_{z,t}
+\left(\frac{\tilde\pi_{t+1}}{\pi_{t+1}}\right)^{1/(1-\lambda_{f,t})}\beta\xi_pF_{p,t+1}-F_{p,t}\right\}=0.
\]

- **(F5) Price auxiliary recursion \(K_p\)** (`needs_review`, source A.5):

\[
E_t\left\{\lambda_{f,t}\lambda_{z,t}Y_{z,t}s_t
+\beta\xi_p\left(\frac{\tilde\pi_{t+1}}{\pi_{t+1}}\right)^{-\lambda_{f,t}/(\lambda_{f,t}-1)}K_{p,t+1}-K_{p,t}\right\}=0.
\]

- **(F6) Scaled output definition** (`needs_review`, source A.6):

\[
Y_{z,t}=(p_t^{\ast})^{\lambda_f/(\lambda_f-1)}
\left\{\epsilon_t\nu_t^l\left(u_t\frac{\bar k_t}{\Upsilon\mu_{z,t}^{\ast}}\right)^\alpha
\left[(w_t^{\ast})^{\lambda_w/(\lambda_w-1)}H_t\right]^{1-\alpha}-\phi\right\}.
\]

**Capital producers and entrepreneurs**

- **(F7) Supply price of capital** (`needs_review`, source A.7):

\[
E_t\left[\lambda_{z,t}q_tF_{1,t}-\lambda_{z,t}\frac{1}{\mu_{\Upsilon,t}}
+\beta\frac{\lambda_{z,t+1}}{\mu_{z,t+1}^{\ast}\Upsilon}q_{t+1}F_{2,t+1}\right]=0.
\]

- **(F8) Capital accumulation** (`needs_review`, source A.8):

\[
\bar k_{t+1}=(1-\delta)\frac{1}{\mu_{z,t}^{\ast}\Upsilon}\bar k_t+
\left[1-S\left(\frac{\zeta_{i,t}i_t\mu_{z,t}^{\ast}\Upsilon}{i_{t-1}}\right)\right]i_t.
\]

- **(F9) Capital utilization** (`needs_review`, source A.9):

\[
r_t^k=\tau_t^{oil}a'(u_t).
\]

- **(F10) Return on capital** (`needs_review`, source A.10):

\[
R_t^k=\frac{[u_tr_t^k-\tau_t^{oil}a(u_t)]+(1-\delta)q_t}{\Upsilon q_{t-1}}\pi_t+\tau^k\delta-1.
\]

- **(F11) Standard debt contract optimality** (`needs_review`, OCR damaged in source A.11):

\[
E_t\left\{[1-\Gamma_t(\bar\omega_{t+1})]\frac{1+R_{t+1}^k}{1+R_{t+1}^e}
+\frac{\Gamma_t'(\bar\omega_{t+1})}{\Gamma_t'(\bar\omega_{t+1})-\mu G_t'(\bar\omega_{t+1})}
\left[\frac{1+R_{t+1}^k}{1+R_{t+1}^e}\big(\Gamma_t(\bar\omega_{t+1})-\mu G_t(\bar\omega_{t+1})\big)-1\right]\right\}=0.
\]

- **(F12) Bank zero profit on entrepreneurial loans** (`needs_review`, source A.12 appears dimensionally damaged by OCR):

\[
(1+R_{t+1}^k)\left[\Gamma_t(\bar\omega_{t+1})-\mu G_t(\bar\omega_{t+1})\right]
=1+R_{t+1}^e\left(q_t\bar k_{t+1}-n_{t+1}\right).
\]

- **(F13) Net worth law of motion** (`needs_review`, source A.13):

\[
n_{t+1}=\frac{\gamma_t}{\pi_t\mu_{z,t}^{\ast}}
\left\{(1+R_t^k)\bar k_tq_{t-1}
-\left[1+R_t^e+
\frac{\mu\int_0^{\bar\omega_t}\omega\,dF_t(\omega_t)(1+R_t^k)\bar k_tq_{t-1}}{\bar k_tq_{t-1}-n_t}\right]
(\bar k_tq_{t-1}-n_t)\right\}+w^e.
\]

**Households and wage setting**

- **(F14) Marginal utility of consumption** (`needs_review`, source A.19):

\[
E_t\left\{u_{c,t}^z-\frac{\mu_{z,t}^{\ast}\zeta_{c,t}}{c_t\mu_{z,t}^{\ast}-bc_{t-1}}
+b\beta\frac{\zeta_{c,t+1}}{c_{t+1}\mu_{z,t+1}^{\ast}-bc_t}\right\}=0.
\]

- **(F15) Consumption decision** (`needs_review`, liquidity term inactive in `US_CMR10fa`; source A.20):

\[
E_t\{u_{c,t}^z-(1+\tau^C)\lambda_{z,t}-\text{liquidity-service marginal utility term}\}=0.
\]

- **(F16) Calvo wage reset index** (`needs_review`, source A.21):

\[
w_t^{\ast}=\left[(1-\xi_w)\left(\frac{1-\xi_w\left(\frac{\tilde\pi_{w,t}}{\pi_{w,t}}(\mu_{z^{\ast}})^{1-\vartheta}(\mu_{z^{\ast},t})^\vartheta\right)^{1/(1-\lambda_w)}}{1-\xi_w}\right)^{\lambda_w}
+\xi_w\left(\frac{\tilde\pi_{w,t}}{\pi_{w,t}}(\mu_{z^{\ast}})^{1-\vartheta}(\mu_{z^{\ast},t})^\vartheta w_{t-1}^{\ast}\right)^{\lambda_w/(1-\lambda_w)}\right]^{(1-\lambda_w)/\lambda_w}.
\]

- **(F17) Wage auxiliary recursion \(F_w\)** (`needs_review`, source A.22):

\[
E_t\left\{(w_t^{\ast})^{\lambda_w/(\lambda_w-1)}H_t\frac{(1-\tau^l)\lambda_{z,t}}{\lambda_w}
+\beta\xi_w(\mu_{z^{\ast}})^{(1-\vartheta)/(1-\lambda_w)}
(\mu_{z^{\ast},t+1})^{\vartheta/(1-\lambda_w)-1}
\left(\frac{1}{\pi_{w,t+1}}\right)^{\lambda_w/(1-\lambda_w)}
\frac{\tilde\pi_{w,t+1}^{1/(1-\lambda_w)}}{\pi_{t+1}}F_{w,t+1}-F_{w,t}\right\}=0.
\]

- **(F18) Wage auxiliary recursion \(K_w\)** (`needs_review`, source A.23):

\[
E_t\left\{\left[(w_t^{\ast})^{\lambda_w/(\lambda_w-1)}H_t\right]^{1+\sigma_L}\zeta_{c,t}
+\beta\xi_wE_t\left(\frac{\tilde\pi_{w,t+1}}{\pi_{w,t+1}}(\mu_{z^{\ast}})^{1-\vartheta}(\mu_{z^{\ast},t+1})^\vartheta\right)^{\lambda_w(1+\sigma_L)/(1-\lambda_w)}K_{w,t+1}-K_{w,t}\right\}=0.
\]

- **(F19) Risk-free illiquid asset Euler equation** (`needs_review`, source A.24):

\[
E_t\left\{-\lambda_{z,t}+\frac{\beta}{\mu_{z,t+1}^{\ast}\pi_{t+1}}\lambda_{z,t+1}(1+R_{t+1}^T)\right\}=0.
\]

The source also lists money-choice FOCs A.25-A.27. They are part of the full baseline model but are inactive in `US_CMR10fa` because the financial-accelerator variant eliminates liquidity utility and monetary aggregate choice.

## 4. Market Clearing & Identities

- **(F20) Resource constraint** (`needs_review`, source A.30):

\[
\frac{\mu G_t(\bar\omega_t)(1+R_t^k)q_{t-1}\bar k_t}{\mu_{z,t}^{\ast}}\frac{1}{\pi_t}
+\tau_t^{oil}a(u_t)\frac{\bar k_t}{\Upsilon\mu_{z,t}^{\ast}}
+g_t+c_t+\frac{i_t}{\mu_{\Upsilon,t}}
+\Theta\frac{1-\gamma_t}{\gamma_t}(n_{t+1}-w^e)
=Y_{z,t}.
\]

- **(F21) Total bank loans / credit definition** (`needs_review`, source A.32):

\[
b_t^{Tot}=\psi_lw_tl_t+\psi_k\frac{r_t^ku_t\bar k_t}{\mu_{z,t}^{\ast}\Upsilon}
+(q_t\bar k_{t+1}-n_{t+1}).
\]

- **(F22) Average credit spread** (`needs_review`, source A.33):

\[
P_t^e=\frac{\mu\int_0^{\bar\omega_t}\omega\,dF_t(\omega_t)(1+R_t^k)\bar k_tq_{t-1}}
{\bar k_tq_{t-1}-n_t}.
\]

- **(F23) Capital demand schedule from Appendix E** (`needs_review`, source E.7):

\[
\hat q_t=-\widehat{\bar k}_{t+1}+\hat n_{t+1}
+A\left(\frac{\bar k-n}{n}\right)E_t\left(\frac{R^k\hat R_{t+1}^k}{1+R^k}-\frac{R^e\hat R_{t+1}^e}{1+R^e}\right)
-B\left(\frac{\bar k-n}{n}\right)\sigma\hat\sigma_t.
\]

- **(F24) Credit demand schedule from Appendix E** (`needs_review`, source E.10):

\[
\hat P_{t+1}^{e,D}=-\frac{n}{\bar k}\hat b_{t+1}+\frac{n}{\bar k}\hat n_{t+1}
+E_t\left[H\left(\frac{R^k\hat R_{t+1}^k}{1+R^k}\right)
-(H-1)\frac{R^e\hat R_{t+1}^e}{1+R^e}+J\sigma\hat\sigma_t\right].
\]

- **(F25) Credit supply schedule from Appendix E** (`needs_review`, source E.11):

\[
\hat P_{t+1}^{e,S}=S\frac{n}{\bar k}\hat b_{t+1}-S\frac{n}{\bar k}\hat n_{t+1}
-E_t\left[S\left(\frac{R^k\hat R_{t+1}^k}{1+R^k}\right)
+(1+S)\frac{R^e\hat R_{t+1}^e}{1+R^e}-T\sigma\hat\sigma_t\right].
\]

Baseline-only money and reserves identities A.29, A.31, A.34, and A.35 are excluded from the active `US_CMR10fa` variant because the financial-accelerator variant removes the bank-funding channel.

## 5. Exogenous Processes

- **(F26) Persistent technology trend** (`needs_review`, source equation 3 and Appendix scaling):

\[
z_t=\mu_{z,t}z_{t-1},\qquad
\mu_{z^{\ast},t}=\mu_{z,t}\Upsilon^{\alpha/(1-\alpha)}.
\]

- **(F27) Government spending scaling** (`needs_review`, source section 2.6):

\[
G_t=z_t^{\ast}g_t.
\]

- **(F28) Inflation target process** (`needs_review`, source section 2.9):

\[
\hat\pi_t^{target}=\rho_\pi\hat\pi_{t-1}^{target}+\varepsilon_t^{target}.
\]

- **(F29) Risk shock with unexpected component only in this variant** (`needs_review`, source section 2.10.1 disables risk-news signals):

\[
\hat\sigma_t=\rho_\sigma\hat\sigma_{t-1}+\xi_{\sigma,t}^{0}.
\]

- **(F30) Other first-order autoregressive shocks** (`needs_review`, source section 2.9):

\[
\hat x_t=\rho_x\hat x_{t-1}+\varepsilon_t^x,\qquad
x\in\{\mu_{\Upsilon},g,\mu_{z^{\ast}},\gamma,\epsilon,\zeta_c,\zeta_i,\tau^{oil},\lambda_f\}.
\]

- **(F31) Monetary policy shock** (`needs_review`, source section 2.9):

\[
\varepsilon_t\sim iid.
\]

## 6. Steady-State Solution

The source paper reports that the model is first rewritten in stationary variables and then solved around the non-stochastic steady state. The first-pass archive entry does not reconstruct the full numerical steady-state algorithm; the following conditions are the source-backed steady-state restrictions required for a later implementation pass.

- **(F32) Balanced-growth stationarization** (`needs_review`, source Appendix A):

\[
\bar k_{t+1}=\frac{\bar K_{t+1}}{z_t^{\ast}\Upsilon^t},\quad
i_t=\frac{I_t}{z_t^{\ast}\Upsilon^t},\quad
Y_{z,t}=\frac{Y_t}{z_t^{\ast}},\quad
c_t=\frac{C_t}{z_t^{\ast}},\quad
q_t=\Upsilon^t\frac{Q_{\bar K',t}}{P_t}.
\]

- **(F33) Zero steady-state installation cost conditions** (`needs_review`, source section 2.2):

\[
S(\mu_z^{\ast}\Upsilon)=0,\qquad S'(\mu_z^{\ast}\Upsilon)=0,\qquad S''>0.
\]

- **(F34) Utilization cost normalization** (`needs_review`, source section 2.3):

\[
u=1,\qquad a(1)=0,\qquad a'(u)=r^k,\qquad a''(u)=\sigma_a r^k.
\]

- **(F35) US financial-accelerator steady-state targets** (`needs_review`, source Tables 1-3):

\[
\beta=0.9966,\quad \delta=0.025,\quad \alpha=0.40,\quad
\lambda_f=1.20,\quad \lambda_w=1.05,\quad \gamma=0.9762,\quad \mu=0.94.
\]

The source tables also report US target ratios including \(i/y=0.22\), \(c/y=0.58\), \(g/y=0.20\), \(k/y=6.98\), and \(N/(K-N)=3.40\). These are recorded as calibration targets, not as an independently checked steady-state solution.

## 7. Timing & Form Conventions

- The derivation uses the paper's stationary scaled variables: output and consumption scale by \(z_t^{\ast}\), while capital and investment scale by \(z_t^{\ast}\Upsilon^t\).
- Capital purchased at the end of period \(t\) is \(\bar K_{t+1}\); production at date \(t\) uses previously installed capital services. The scaled accumulation equation therefore determines \(\bar k_{t+1}\) from \(\bar k_t\) and \(i_t\).
- Entrepreneurial net worth \(n_{t+1}\) is the end-of-period purchasing power used in the time-\(t\) capital market and is affected by the financial wealth shock \(\gamma_t\) and by credit losses tied to the earlier risk shock realization.
- The contract cutoff \(\bar\omega_{t+1}\) is dated by the period in which the loan payoff is observed; the risk dispersion governing the contract is known when the loan is originated.
- The model is solved by log-linear approximation around the stationary steady state. Appendix E equations are therefore presented in hatted percent-deviation form.
- `US_CMR10fa` removes the bank-funding/liquidity block from the baseline model, so full-model money/reserve FOCs are recorded as excluded rather than active equations.
- Runtime validation, Blanchard-Kahn checks, and IRF checks are deferred.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII hint | Meaning | Equation reference |
|---|---|---|---|
| Endogenous | \(s_t\) / `sU` | Real marginal cost | (F1), (F2) |
| Endogenous | \(r_t^k\) / `rkU` | Rental rate of capital services | (F2), (F9) |
| Endogenous | \(\tilde w_t\) / `wU` | Scaled real wage | (F1), (F17) |
| Endogenous | \(p_t^{\ast}\) / `pstarU` | Relative reset price | (F3) |
| Endogenous | \(F_{p,t}\) / `FpXU` | Price Calvo auxiliary | (F4) |
| Endogenous | \(K_{p,t}\) | Price Calvo auxiliary | (F5) |
| Endogenous | \(Y_{z,t}\) / `YU` | Scaled output | (F6), (F20) |
| Endogenous | \(q_t\) / `qU` | Relative price of installed capital | (F7), (F23) |
| Endogenous | \(\bar k_{t+1}\) / `kbarU` | Scaled installed capital stock | (F8), (F23) |
| Endogenous | \(i_t\) / `iU` | Scaled investment | (F8), (F20) |
| Endogenous | \(u_t\) / `uU` | Capital utilization | (F9), (F10) |
| Endogenous | \(R_t^k\) / `RkXU` | Gross return on entrepreneurial capital | (F10), (F11), (F13) |
| Endogenous | \(\bar\omega_t\) / `omegabarU` | Debt-contract default cutoff | (F11), (F12) |
| Endogenous | \(n_{t+1}\) / `nU` | Entrepreneurial net worth | (F13), (F21), (F23) |
| Endogenous | \(u_{c,t}^z\) / `uzcU` | Scaled marginal utility of consumption | (F14), (F15) |
| Endogenous | \(\lambda_{z,t}\) / `lambdazU` | Scaled household multiplier | (F15), (F19) |
| Endogenous | \(c_t\) / `cU` | Scaled consumption | (F14), (F20) |
| Endogenous | \(w_t^{\ast}\) / `wstarU` | Relative reset wage | (F16), (F17), (F18) |
| Endogenous | \(F_{w,t}\) / `FwXU` | Wage Calvo auxiliary | (F17) |
| Endogenous | \(K_{w,t}\) | Wage Calvo auxiliary | (F18) |
| Endogenous | \(R_{t+1}^T,R_{t+1}^e\) / `ReXU` | Risk-free / deposit opportunity return | (F11), (F19), (F23) |
| Endogenous | \(g_t\) / `gU` | Scaled government consumption | (F20), (F27), (F30) |
| Endogenous | \(b_t^{Tot}\) / `BU` | Total bank loans / credit | (F21), (F24), (F25) |
| Endogenous | \(P_t^e\) / `PrU` | Average credit spread / premium | (F22), (F24), (F25) |
| Exogenous shock | \(\mu_{\Upsilon,t}\) / `muupU` | Investment-specific technology / relative investment price | (F7), (F20), (F30) |
| Exogenous shock | \(\mu_{z^{\ast},t}\) / `muzstarU` | Persistent balanced-growth shock | (F26), (F30) |
| Exogenous shock | \(\gamma_t\) / `gammaU` | Financial wealth / entrepreneur survival shock | (F13), (F30) |
| Exogenous shock | \(\epsilon_t\) / `epsilU` | Transitory technology shock | (F1), (F6), (F30) |
| Exogenous shock | \(\sigma_t\) / `sigmaU` | Entrepreneurial risk shock | (F11), (F29) |
| Exogenous shock | \(\zeta_{c,t}\) / `zetacU` | Consumption preference shock | (F14), (F30) |
| Exogenous shock | \(\zeta_{i,t}\) / `zetaiU` | Marginal efficiency of investment shock | (F7), (F8), (F30) |
| Exogenous shock | \(\tau_t^{oil}\) / `tauoU` | Oil/utilization cost shock | (F9), (F10), (F30) |
| Exogenous shock | \(\lambda_{f,t}\) / `lambdafU` | Price markup shock | (F3), (F30) |
| Exogenous shock | \(\pi_t^{target}\) / `pitargetU` | Inflation target shock | (F28) |
| Exogenous shock | \(\varepsilon_t\) / `e_xpU` | Monetary policy shock | (F31) |
| Parameter | \(\beta,\delta,\alpha\) / `betaUU, deltaUU, alphaUU` | Discount factor, depreciation, capital share | (F7), (F8), (F35) |
| Parameter | \(\xi_p,\xi_w,\iota,\iota_w\) / `xipUU, xiwUU, iota1UU, iotaw1UU` | Calvo and indexation parameters | (F3), (F16) |
| Parameter | \(\lambda_f,\lambda_w\) / `lambdafUU, lambdawUU` | Goods and labor markups | (F1), (F16) |
| Parameter | \(\psi_k,\psi_l\) / `psi_k, psi_l` | Working-capital finance fractions; set to zero in variant | (F1), (F21) |
| Parameter | \(\mu,\Theta,w^e\) / `muUU, bigthetaUU, weUU` | Monitoring cost, exiting entrepreneur consumption share, startup transfer | (F13), (F20), (F22) |
| Parameter | \(\rho_x\) | Shock persistence parameters | (F28), (F29), (F30) |
