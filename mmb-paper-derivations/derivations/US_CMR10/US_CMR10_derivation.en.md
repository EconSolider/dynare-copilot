# US_CMR10 Derivation

> Source-backed first-pass archive entry for the US baseline version of Christiano, Motto, and Rostagno (2010), "Financial Factors in Economic Fluctuations." Status: `needs_review`.
> Runtime validation: not performed. Dynare was not run.

## 1. Model Overview

- **Model ID**: `US_CMR10`.
- **Paper**: Lawrence J. Christiano, Roberto Motto, and Massimo Rostagno (2010), "Financial Factors in Economic Fluctuations," ECB Working Paper Series No. 1192. DOI recorded in `model_index.csv`: `10.2139/ssrn.1600166`.
- **Source used for equations**: `raw/mmb_mineru/runs/us_cmr10_us_cmr10fa__financial_factors_in_economic_fluctuations__7ef56ea6/full.md`. The row's `primary_full_md_path` points to a different Furlanetto-Ravazzolo-Sarferaz VAR paper and is therefore recorded as a source-index issue, not used as mathematical evidence.
- **Economy and variant**: United States estimated baseline model with the full financial accelerator and bank funding channel. The paper also estimates Euro Area and smaller variants; this entry records the US baseline implementation family.
- **Core agents**: final-good aggregators, monopolistically competitive intermediate-goods firms with Calvo price setting, capital producers, entrepreneurs with BGG-style costly state verification, a representative bank with working-capital and entrepreneurial lending, households with money/deposit choice and Calvo wage setting, government, and monetary authority.
- **Form**: stationary nonlinear equilibrium conditions solved after first-order perturbation. The monetary policy rule is reported in the paper in linearized form. This first-pass archive preserves the paper's scaled equations and marks OCR-sensitive formulas as `needs_review`.

## 2. Optimization Problems

### Intermediate-Goods Firms

Intermediate producers rent capital services and labor, finance fractions of both factor bills in advance, and set prices under Calvo stickiness with indexation to the inflation target and lagged inflation.

\[
Y_{j,t}=\epsilon_t z_t^{1-\alpha}K_{j,t}^{\alpha}l_{j,t}^{1-\alpha}-\Phi z_t^{\ast} .
\]

Given working-capital financing requirements, real marginal cost is defined by:

\[
s_t=\left(\frac{1}{1-\alpha}\right)^{1-\alpha}\left(\frac{1}{\alpha}\right)^{\alpha}
\frac{\left(\tilde r_t^k[1+\psi_k R_t]\right)^{\alpha}
\left(\frac{W_t}{P_t}[1+\psi_l R_t]\right)^{1-\alpha}}{\epsilon_t z_t^{1-\alpha}} .
\]

Price non-reoptimizers index according to:

\[
\tilde\pi_t=(\pi_t^{target})^{\iota}(\pi_{t-1})^{1-\iota}.
\]

### Capital Producers

The competitive capital producer converts investment goods and undepreciated capital into installed capital:

\[
x' = x + F(I_t,I_{t-1},\zeta_{i,t})
=x+\left[1-S\left(\zeta_{i,t}I_t/I_{t-1}\right)\right]I_t .
\]

The capital producer solves:

\[
\max_{\{I_{t+j},x_{t+j}\}} E_t\sum_{j=0}^{\infty}\beta^j\lambda_{t+j}\Pi^k_{t+j}.
\]

### Entrepreneurs

At the end of period \(t\), entrepreneurs combine net worth \(N_{t+1}\) with bank loans \(B_{t+1}\) to buy installed capital. Idiosyncratic project productivity \(\omega\) is lognormal and has time-varying dispersion \(\sigma_t\), the model's risk shock. The standard debt contract chooses the loan size and default cutoff \(\bar\omega_{t+1}\) subject to the bank subsidiary's zero-profit condition.

The cutoff satisfies:

\[
\bar\omega_{t+1}(1+R^k_{t+1})Q_{\bar K',t}\bar K_{t+1}=Z_{t+1}B_{t+1}.
\]

### Banks

The representative bank supplies working-capital loans and entrepreneurial loans. Working-capital loans satisfy:

\[
(1+R_t)S_t^w=(1+R_t)(\psi_l W_t l_t+\psi_k P_t\tilde r_t^k K_t).
\]

Entrepreneurial lending is governed by a costly-state-verification contract with monitoring cost \(\mu\), default share \(G_t(\bar\omega)\), and bank revenue share \(\Gamma_t(\bar\omega)-\mu G_t(\bar\omega)\).

### Households

Households consume, supply differentiated labor, and allocate wealth across deposits and securities with different liquidity services. The appendix reports household optimality conditions for marginal utility, consumption, wage setting, time deposits, money, marketable deposits, and base money.

## 3. First-Order Conditions

The following equations are the paper's scaled equilibrium conditions, renumbered continuously for archive use. OCR-damaged equations are marked `needs_review`.

- **(F1) Marginal cost, cost-share expression**:

\[
s_t=\left(\frac{1}{1-\alpha}\right)^{1-\alpha}\left(\frac{1}{\alpha}\right)^{\alpha}
\frac{(r_t^k[1+\psi_kR_t])^{\alpha}(\tilde w_t[1+\psi_lR_t])^{1-\alpha}}{\epsilon_t}.
\]

- **(F2) Marginal cost, capital rental expression**:

\[
s_t=\frac{r_t^k[1+\psi_kR_t]}{\alpha\epsilon_t\left(\Upsilon\frac{\mu_{z,t}^{\ast}l_t}{u_t k_t}\right)^{1-\alpha}}.
\]

- **(F3) Calvo price reset index**:

\[
p_t^{\ast}-\left[(1-\xi_p)\left(\frac{1-\xi_p(\tilde\pi_t/\pi_t)^{1/(1-\lambda_{f,t})}}{1-\xi_p}\right)^{\lambda_{f,t}}
\xi_p\left((\tilde\pi_t/\pi_t)p_{t-1}^{\ast}\right)^{\lambda_{f,t}/(1-\lambda_{f,t})}\right]^{(1-\lambda_{f,t})/\lambda_{f,t}}=0.
\]

- **(F4) Price-setting auxiliary \(F_{p,t}\), needs_review**:

\[
E_t\left\{\lambda_{z,t}Y_{z,t}+\left(\frac{\tilde\pi_{t+1}}{\pi_{t+1}}\right)^{1/(1-\lambda_{f,t})}\beta\xi_pF_{p,t+1}-F_{p,t}\right\}=0.
\]

- **(F5) Price-setting auxiliary \(K_{p,t}\), needs_review**:

\[
E_t\left\{\lambda_{f,t}\lambda_{z,t}Y_{z,t}s_t+\beta\xi_p
\left(\frac{\tilde\pi_{t+1}}{\pi_{t+1}}\right)^{-\lambda_{f,t}/(\lambda_{f,t}-1)}
K_{p,t+1}-K_{p,t}\right\}=0.
\]

- **(F6) Production and price-dispersion condition**:

\[
Y_{z,t}=(p_t^{\ast})^{\lambda_f/(\lambda_f-1)}
\left\{\epsilon_t\nu_t^l\left(u_t\frac{\bar k_t}{\Upsilon\mu_{z,t}^{\ast}}\right)^\alpha
\left[(w_t^{\ast})^{\lambda_w/(\lambda_w-1)}H_t\right]^{1-\alpha}-\phi\right\}.
\]

- **(F7) Capital supply FOC**:

\[
E_t\left[\lambda_{z,t}q_tF_{1,t}-\lambda_{z,t}\frac{1}{\mu_{\Upsilon,t}}
+\beta\frac{\lambda_{z,t+1}}{\mu_{z,t+1}^{\ast}\Upsilon}q_{t+1}F_{2,t+1}\right]=0.
\]

- **(F8) Capital utilization**:

\[
r_t^k=\tau_t^{oil}a'(u_t).
\]

- **(F9) Return on capital**:

\[
R_t^k=\frac{[u_t r_t^k-\tau_t^{oil}a(u_t)]+(1-\delta)q_t}{\Upsilon q_{t-1}}\pi_t+\tau^k\delta-1.
\]

- **(F10) Standard debt contract optimality, needs_review**:

\[
E_t\left\{[1-\Gamma_t(\bar\omega_{t+1})]\frac{1+R_{t+1}^k}{1+R_{t+1}^e}
+\frac{\Gamma_t'(\bar\omega_{t+1})}{\Gamma_t'(\bar\omega_{t+1})-\mu G_t'(\bar\omega_{t+1})}
\left[\frac{1+R_{t+1}^k}{1+R_{t+1}^e}\left(\Gamma_t(\bar\omega_{t+1})-\mu G_t(\bar\omega_{t+1})\right)-1\right]\right\}=0.
\]

- **(F11) Entrepreneurial-loan zero-profit condition, needs_review**:

\[
(1+R_{t+1}^k)[\Gamma_t(\bar\omega_{t+1})-\mu G_t(\bar\omega_{t+1})]=
(1+R_{t+1}^e)\frac{q_t\bar k_{t+1}-n_{t+1}}{q_t\bar k_{t+1}}.
\]

- **(F12) Net-worth law of motion, needs_review**:

\[
n_{t+1}=\frac{\gamma_t}{\pi_t\mu_{z,t}^{\ast}}\left\{(1+R_t^k)\bar k_tq_{t-1}
-\left[1+R_t^e+\frac{\mu\int_0^{\bar\omega_t}\omega\,dF_t(\omega)(1+R_t^k)\bar k_tq_{t-1}}{\bar k_tq_{t-1}-n_t}\right](\bar k_tq_{t-1}-n_t)\right\}+w^e.
\]

- **(F13) Banking services production, needs_review**:

\[
x_t^b(e_{v,t})^{-\xi_t}e_{z,t}^r=
\frac{m_t^b(1-m_t+\varsigma d_{m,t})}{\pi_t\mu_{z,t}^{\ast}}
+\psi_lw_tl_t+\psi_k\frac{r_t^kk_t}{\mu_{z,t}^{\ast}\Upsilon}.
\]

- **(F14) Ratio of excess reserves to bank value added**:

\[
e_{v,t}=\frac{(1-\tau)\frac{m_t^b}{\pi_t\mu_{z,t}^{\ast}}(1-m_t)-\tau\left(\psi_lw_tl_t+\frac{\psi_kr_t^k}{\mu_{z,t}^{\ast}\Upsilon}k_t\right)}
{\left(\frac{1}{\mu_{z,t}^{\ast}\Upsilon}(1-\nu_t^k)k_t\right)^\alpha((1-\nu_t^l)l_t)^{1-\alpha}}.
\]

- **(F15) Banking efficiency condition**:

\[
R_{a,t}=\frac{(1-\tau)h_{e^r,t}-1}{\tau h_{e^r,t}+1}R_t,\qquad
h_{e^r,t}=(1-\xi_t)x_t^b(e_{v,t})^{-\xi_t}.
\]

- **(F16) Intertemporal banking efficiency condition**:

\[
E_t\left\{\frac{\lambda_{z,t+1}}{\mu_{z,t+1}^{\ast}\pi_{t+1}}
\left[R_{t+1}^T-R_{t+1}^m-\frac{\varsigma R_{t+1}}{h_{e^r,t+1}\tau+1}\right]\right\}=0.
\]

- **(F17) Bank labor choice**:

\[
w_t=\frac{R_t}{1+\psi_lR_t}
\frac{(1-\alpha)\xi_tx_t^b(e_{v,t})^{1-\xi_t}
\left(\frac{\mu_{z,t}^{\ast}\Upsilon(1-\nu_t^l)l_t}{(1-\nu_t^k)k_t}\right)^{-\alpha}}{1+\tau h_{e^r,t}}.
\]

- **(F18) Marginal utility of consumption**:

\[
E_t\left\{u_{c,t}^z-\frac{\mu_{z,t}^{\ast}\zeta_{c,t}}{c_t\mu_{z,t}^{\ast}-bc_{t-1}}
+b\beta\frac{\zeta_{c,t+1}}{c_{t+1}\mu_{z,t+1}^{\ast}-bc_t}\right\}=0.
\]

- **(F19) Consumption-deposit choice, needs_review**:

\[
0=E_t\left\{u_{c,t}^z-(1+\tau^C)\lambda_{z,t}
-\zeta_{c,t}vc_t^{-\sigma_q}\left(\frac{\pi_t\mu_{z,t}^{\ast}}{m_t^b}\right)^{1-\sigma_q}
\left[(1+\tau^C)\left(\frac{1}{m_t}\right)^{(1-\chi_t)\theta}
\left(\frac{1}{1-m_t}\right)^{(1-\chi_t)(1-\theta)}
\left(\frac{1}{dm_t}\right)^{\chi_t}\right]^{1-\sigma_q}\right\}.
\]

- **(F20) Calvo wage reset index, needs_review**:

\[
w_t^{\ast}=\left[(1-\xi_w)\left(\frac{1-\xi_w\left(\frac{\tilde\pi_{w,t}}{\pi_{w,t}}(\mu_{z^{\ast}})^{1-\vartheta}(\mu_{z^{\ast},t})^\vartheta\right)^{1/(1-\lambda_w)}}{1-\xi_w}\right)^{\lambda_w}
+\xi_w\left(\frac{\tilde\pi_{w,t}}{\pi_{w,t}}(\mu_{z^{\ast}})^{1-\vartheta}(\mu_{z^{\ast},t})^\vartheta w_{t-1}^{\ast}\right)^{\lambda_w/(1-\lambda_w)}\right]^{(1-\lambda_w)/\lambda_w}.
\]

- **(F21) Wage-setting auxiliary \(F_{w,t}\), needs_review**:

\[
E_t\left\{(w_t^{\ast})^{\lambda_w/(\lambda_w-1)}H_t\frac{(1-\tau^l)\lambda_{z,t}}{\lambda_w}
+\beta\xi_w(\mu_{z^{\ast}})^{(1-\vartheta)/(1-\lambda_w)}
(\mu_{z^{\ast},t+1})^{\vartheta/(1-\lambda_w)-1}
\left(\frac{1}{\pi_{w,t+1}}\right)^{\lambda_w/(1-\lambda_w)}
\frac{\tilde\pi_{w,t+1}^{1/(1-\lambda_w)}}{\pi_{t+1}}F_{w,t+1}-F_{w,t}\right\}=0.
\]

- **(F22) Wage-setting auxiliary \(K_{w,t}\), needs_review**:

\[
E_t\left\{\left[(w_t^{\ast})^{\lambda_w/(\lambda_w-1)}H_t\right]^{1+\sigma_L}\zeta_{c,t}
+\beta\xi_w\left(\frac{\tilde\pi_{w,t+1}}{\pi_{w,t+1}}(\mu_{z^{\ast}})^{1-\vartheta}(\mu_{z^{\ast},t+1})^\vartheta\right)^{\lambda_w(1+\sigma_L)/(1-\lambda_w)}K_{w,t+1}
-K_{w,t}\right\}=0.
\]

- **(F23) Time-deposit Euler equation**:

\[
E_t\left\{-\lambda_{z,t}+\frac{\beta}{\mu_{z,t+1}^{\ast}\pi_{t+1}}\lambda_{z,t+1}(1+R_{t+1}^T)\right\}=0.
\]

- **(F24) Choice of money \(M_t\), needs_review**:

\[
E_t\left\{\zeta_{c,t}v\mathcal L_t^{1-\sigma_q}
\left(\frac{\pi_t\mu_{z,t}^{\ast}}{m_t^b}\right)^{2-\sigma_q}
\left[\frac{(1-\chi_t)\theta}{m_t}-\frac{(1-\chi_t)(1-\theta)}{1-m_t}\right]
-\lambda_{z,t}R_t^a+\text{adjustment-cost terms}\right\}=0.
\]

- **(F25) Choice of marketable deposits \(D_{t+1}^m\), needs_review**:

\[
E_t\left\{\beta\zeta_{c,t+1}v\chi_{t+1}\mathcal L_{t+1}^{1-\sigma_q}
\frac{1}{d_{t+1}^m}\left(\frac{1}{m_{t+1}^b}\right)^{2-\sigma_q}
(\pi_{t+1}\mu_{z,t+1}^{\ast})^{1-\sigma_q}
+\frac{\beta}{\pi_{t+1}\mu_{z,t+1}^{\ast}}\lambda_{z,t+1}(1+R_{t+1}^m)-\lambda_{z,t}\right\}=0.
\]

- **(F26) Choice of base money \(M_{t+1}^b\), needs_review**:

\[
E_t\left\{\beta\zeta_{c,t+1}v(1-\theta)(1-\chi_{t+1})\mathcal L_{t+1}^{1-\sigma_q}
\left(\frac{1}{m_{t+1}^b}\right)^{2-\sigma_q}(\pi_{t+1}\mu_{z,t+1}^{\ast})^{1-\sigma_q}\frac{1}{1-m_{t+1}}
+\frac{\beta}{\pi_{t+1}\mu_{z,t+1}^{\ast}}\lambda_{z,t+1}(1+R_{t+1}^a)-\lambda_{z,t}\right\}=0.
\]

## 4. Market Clearing & Identities

- **(F27) Capital accumulation**:

\[
\bar k_{t+1}=(1-\delta)\frac{1}{\mu_{z,t}^{\ast}\Upsilon}\bar k_t+
\left[1-S\left(\frac{\zeta_{i,t}i_t\mu_{z,t}^{\ast}\Upsilon}{i_{t-1}}\right)\right]i_t.
\]

- **(F28) Monetary policy rule, linearized**:

\[
\hat R_{t+1}^e=\rho_i\hat R_t^e+(1-\rho_i)\alpha_\pi\frac{\pi}{R^e}
\left[E_t(\hat\pi_{t+1})-\hat\pi_t^{target}\right]
+(1-\rho_i)\frac{\alpha_{\Delta y}}{4R^e}\log\left(\frac{GDP_t}{\mu_{z^{\ast}}GDP_{t-1}}\right)
+(1-\rho_i)\alpha_{\Delta\pi}\frac{\pi}{R^e}(\hat\pi_t-\hat\pi_{t-1})
+(1-\rho_i)\frac{\alpha_{\Delta c}}{R^e}\log\left(\frac{B_t^{Tot}}{\mu_{z^{\ast}}B_{t-1}^{Tot}}\right)
+(1-\rho_i)\frac{\alpha_\xi}{R^e}\hat\xi_t+\frac{1}{400R^e}\varepsilon_t.
\]

- **(F29) Monetary-base law of motion**:

\[
m_{t+1}^b=\frac{1}{\pi_t\mu_{z,t}^{\ast}}m_t^b(1+x_t).
\]

- **(F30) Resource constraint, needs_review**:

\[
\frac{\mu G_t(\bar\omega_t)(1+R_t^k)q_{t-1}\bar k_t}{\mu_{z,t}^{\ast}\pi_t}
+\tau_t^{oil}a(u_t)\frac{\bar k_t}{\Upsilon\mu_{z,t}^{\ast}}+g_t+c_t+\frac{i_t}{\mu_{\Upsilon,t}}
+\Theta\frac{1-\gamma_t}{\gamma_t}(n_{t+1}-w^e)
=Y_{z,t}.
\]

- **(F31) Broad money**:

\[
m_t^{Broad}=m_{t+1}^b(1+d_{t+1}^m)+\psi_lw_tl_t+
\psi_k\frac{r_t^ku_t}{\Upsilon\mu_{z,t}^{\ast}}\bar k_t.
\]

- **(F32) Total bank loans**:

\[
b_t^{Tot}=\psi_lw_tl_t+\psi_k\frac{r_t^ku_t\bar k_t}{\mu_{z,t}^{\ast}\Upsilon}
+(q_t\bar k_{t+1}-n_{t+1}).
\]

- **(F33) Average credit spread / external finance premium**:

\[
P_t^e=\frac{\mu\int_0^{\bar\omega_t}\omega\,dF_t(\omega_t)(1+R_t^k)\bar k_tq_{t-1}}
{\bar k_tq_{t-1}-n_t}.
\]

- **(F34) Narrow money**:

\[
m_t^{Narrow}=m_{t+1}^b+\psi_lw_tl_t+
\psi_k\frac{r_t^ku_t\bar k_t}{\Upsilon\mu_{z,t}^{\ast}}.
\]

- **(F35) Reserves**:

\[
res_t=\frac{m_t^b}{\pi_t}(1-m_t+x_t).
\]

## 5. Exogenous Processes

The paper estimates stochastic processes for markup, banking technology, bank reserve demand/liquidity preference, term premium, investment-specific technology, money demand, government consumption, permanent and transitory productivity, financial wealth, risk, consumption preference, marginal efficiency of investment, oil price, monetary policy, and price markup shocks. The Rep-MMB implementation cross-check uses first-order AR(1) processes of the form:

- **(F36) Generic AR(1) shock process**:

\[
x_t=\bar x(1+\varepsilon_{x,t})+\rho_x(x_{t-1}-\bar x).
\]

For example, the implementation cross-check records processes for \(\lambda_{f,t},\pi_t^{target},x_t^b,\mu_{\Upsilon,t},\chi_t,g_t,\mu_{z,t}^{\ast},\gamma_t,\epsilon_t,\sigma_t,\zeta_{i,t},\tau_t^{oil}\).

The paper gives a signal representation for the risk shock:

- **(F37) Risk shock with news signals**:

\[
\hat\sigma_t=\rho\hat\sigma_{t-1}+\xi_t^0+\xi_{t-1}^1+\xi_{t-2}^2+\cdots+\xi_{t-p}^p.
\]

- **(F38) Risk-signal state vector, compact form**:

\[
\Psi_{\hat\sigma,t}=P_{\hat\sigma}\Psi_{\hat\sigma,t-1}+\varepsilon_{\hat\sigma,t}.
\]

## 6. Steady-State Solution

The paper reports steady-state calibration and targets in Appendix C but does not provide a full closed-form `steady_state_model` ordering in the Markdown source. This first pass therefore records only source-backed steady-state relationships and marks a full executable ordering as `needs_review`.

- Variables are scaled by the stochastic neutral-technology trend \(z_t^{\ast}\) and the deterministic investment-specific trend \(\Upsilon^t\). Capital and investment grow faster than consumption/output because of embodied investment-specific technical change.
- The balanced-growth scaling is:

\[
z_t^{\ast}=z_t\Upsilon^{\alpha t/(1-\alpha)}.
\]

- Capital, investment, consumption, government spending, money, credit, and net worth are transformed into stationary variables using \(z_t^{\ast}\), \(P_t\), and \(\Upsilon^t\).
- The steady state is calibrated to match return spreads, equity-to-debt ratios, tax rates, velocity measures, and financial-friction targets. The US model uses higher equity-to-debt and a higher external-finance spread than the Euro Area calibration.
- The appendix notes \(S=S'=0\) and \(S''>0\) at steady state; \(u=1\), \(a(1)=0\), \(a'(u)=r^k\), and \(a''(u)=\sigma_a r^k\).
- **Needs review**: reconstruct a Dynare-compatible steady-state ordering from the original replication files and associated `.mat` steady-state values; this was not attempted.

## 7. Timing & Form Conventions

- Variables are stationary scaled variables unless explicitly stated otherwise. The model has a stochastic neutral-technology trend and deterministic embodied investment-specific trend.
- \(\bar k_{t+1}\) is the installed physical capital stock purchased at the end of period \(t\) and used in the following production cycle; production equations use beginning-of-period capital inherited from the previous period after scaling.
- Entrepreneurial net worth \(n_{t+1}\) is determined after period-\(t\) returns, debt settlement, exit, entry, and startup transfer.
- The debt contract is signed at the end of period \(t\) and paid after period-\(t+1\) shocks. The entrepreneurial loan rate \(R_{t+1}^e\) is non-state-contingent in nominal terms in the baseline specification, generating the Fisher deflation channel.
- Risk \(\sigma_t\) affects the cross-sectional dispersion of entrepreneurial returns. In the baseline model it has realized and anticipated signal components.
- The monetary policy rule is reported in linearized hat notation, while most other appendix equilibrium conditions are in stationary nonlinear scaled form.
- The Rep-MMB `US_CMR10_rep.mod` cross-check confirms a nonlinear Dynare `model;` block with a parallel flexible-price block and AR(1)-style shock equations; no runtime validation was performed.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII cross-check | Meaning | Main equations |
|---|---|---|---|
| Endogenous | `sU`, \(s_t\) | marginal cost | (F1), (F2) |
| Endogenous | `piU`, \(\pi_t\) | gross inflation | (F3)-(F5), (F20)-(F22), (F28) |
| Endogenous | `pstarU`, \(p_t^{\ast}\) | reset-price aggregate | (F3), (F6) |
| Endogenous | `FpXU`, \(F_{p,t}\) | price-setting auxiliary | (F4), (F5) |
| Endogenous | `YU`, \(Y_{z,t}\) | scaled output | (F6), (F30) |
| Endogenous | `qU`, \(q_t\) | installed capital price | (F7), (F9), (F27), (F32) |
| Endogenous | `iU`, \(i_t\) | investment | (F7), (F27), (F30) |
| Endogenous | `kbarU`, \(\bar k_t\) | installed capital stock | (F27) |
| Endogenous | `uU`, \(u_t\) | utilization | (F8), (F9) |
| Endogenous | `rkU`, \(r_t^k\) | rental rate of capital | (F8), (F9) |
| Endogenous | `RkXU`, \(R_t^k\) | return on capital | (F9)-(F12), (F33) |
| Endogenous | `omegabarU`, \(\bar\omega_t\) | default cutoff | (F10), (F11), (F33) |
| Endogenous | `nU`, \(n_t\) | entrepreneurial net worth | (F12), (F32), (F33) |
| Endogenous | `evU`, \(e_{v,t}\) | excess reserves/value-added ratio | (F13)-(F15) |
| Endogenous | `mbU`, \(m_t^b\) | monetary base | (F13), (F14), (F29), (F31), (F34), (F35) |
| Endogenous | `RXU`, \(R_t\) | bank/short policy rate object | (F15), (F17), (F28) |
| Endogenous | `RaXU`, \(R_t^a\) | return on base-money asset | (F15), (F24), (F26) |
| Endogenous | `ReXU`, \(R_t^e\) | entrepreneurial-loan funding rate / policy target object | (F10), (F11), (F28) |
| Endogenous | `RmXU`, \(R_t^m\) | marketable-deposit return | (F16), (F25) |
| Endogenous | `uzcU`, \(u_{c,t}^z\) | scaled marginal utility | (F18), (F19) |
| Endogenous | `lambdazU`, \(\lambda_{z,t}\) | scaled budget multiplier | (F7), (F16), (F18), (F23)-(F26) |
| Endogenous | `cU`, \(c_t\) | consumption | (F18), (F19), (F30) |
| Endogenous | `wU`, \(\tilde w_t\) | real wage | (F17), (F20)-(F22), (F31), (F32) |
| Endogenous | `hU`, `wstarU`, \(H_t,w_t^{\ast}\) | labor and wage reset objects | (F20)-(F22) |
| Endogenous | `dmU`, \(d_t^m\) | marketable deposits ratio | (F25), (F31) |
| Endogenous | `btotU`, \(b_t^{Tot}\) | total bank loans | (F28), (F32) |
| Endogenous | `mU`, \(m_t\) | money composition share | (F14), (F19), (F24)-(F26), (F35) |
| Endogenous | `xU`, \(x_t\) | monetary-base growth component | (F29), (F35) |
| Exogenous | `e_lambdafU`, \(\varepsilon_{\lambda_f,t}\) | price markup innovation | (F36) |
| Exogenous | `e_pitargetU`, \(\varepsilon_{\pi^{\ast},t}\) | inflation target innovation | (F36) |
| Exogenous | `e_xbU`, \(\varepsilon_{x^b,t}\) | banking technology innovation | (F36) |
| Exogenous | `e_muupU`, \(\varepsilon_{\mu_\Upsilon,t}\) | investment-specific technology innovation | (F36) |
| Exogenous | `e_chiiU`, \(\varepsilon_{\chi,t}\) | money demand/liquidity innovation | (F36) |
| Exogenous | `e_gU`, \(\varepsilon_{g,t}\) | government spending innovation | (F36) |
| Exogenous | `e_muzstarU`, \(\varepsilon_{\mu_z^{\ast},t}\) | permanent technology innovation | (F36) |
| Exogenous | `e_gammaU`, \(\varepsilon_{\gamma,t}\) | financial wealth innovation | (F36) |
| Exogenous | `e_epsilU`, \(\varepsilon_{\epsilon,t}\) | transitory productivity innovation | (F36) |
| Exogenous | `e_sigmaU`, \(\varepsilon_{\sigma,t}\) | risk shock innovation | (F36)-(F38) |
| Exogenous | `e_zetaiU`, \(\varepsilon_{\zeta_i,t}\) | marginal efficiency of investment innovation | (F36) |
| Exogenous | `e_tauoU`, \(\varepsilon_{\tau^{oil},t}\) | oil price innovation | (F36) |
| Exogenous | `e_xpU`, \(\varepsilon_t\) | monetary policy innovation | (F28) |
| Parameter | \(\alpha,\beta,\delta,\Upsilon,\mu,\gamma,\xi_p,\xi_w,\lambda_f,\lambda_w,\psi_k,\psi_l,\tau,\Theta,\rho_i,\alpha_\pi,\alpha_{\Delta y},\alpha_{\Delta\pi}\) | technology, preference, financial-friction, Calvo, working-capital, and policy parameters | all |
