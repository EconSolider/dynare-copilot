# NK_DT12 - Derivation

> Purpose: private MMB model-archive derivation for later Dynare replication. Runtime validation was not performed.

Source: Fiorella De Fiore and Oreste Tristani, "Optimal Monetary Policy in a Model of the Credit Channel", *The Economic Journal* 123(571), 906-931, DOI `10.1111/j.1468-0297.2012.02558.x`.

Provenance: model id `NK_DT12`; MinerU run `286bd0e5-2870-46db-bfc4-1f7b2fbf2f3c`; source Markdown `raw/mmb_mineru/runs/nk_dt12__optimal_monetary_policy_in_a_model_of_the_credit_channel__286bd0e5/full.md`; raw PDF `raw/mmb_papers/Optimal Monetary Policy in a Model of the Credit Channel.pdf`.

## 1. Model Overview

- **Model**: small New Keynesian model with a credit channel, nominal debt contracts, costly state verification, and Calvo price setting.
- **Agents**: representative household, risk-neutral entrepreneurs/wholesale firms, perfectly competitive financial intermediaries, monopolistically competitive retail firms, and a monetary authority.
- **Core mechanism**: wholesale firms must finance wage bills before production; idiosyncratic default risk and monitoring costs generate an endogenous loan-deposit spread.
- **Policy object**: the paper studies Taylor-rule dynamics and Ramsey optimal policy under commitment using a linearized equilibrium system and a second-order welfare approximation.
- **Model form**: paper-side equilibrium is nonlinear, then log-linearized around a zero-inflation steady state and written in gaps relative to the efficient equilibrium. The MMB implementation uses logged variables in nonlinear `exp(.)` equations rather than Dynare `model(linear)`.
- **Capital**: absent in the benchmark model. Production is linear in labor; firms receive exogenous internal funds $\tau_t$ each period. An extension with endogenous internal funds is separate from the benchmark `NK_DT12` core.

## 2. Optimization Problems

### 2.1 Household

At the beginning of period $t$, the household allocates nominal wealth $W_t$ among money, state-contingent bonds, and one-period deposits. Nominal wealth evolves as:

**(F1) Household nominal wealth accumulation**
$$
W_{t+1}=Z_{t+1}+R_t^dD_t+R_t^m\left(M_t+P_tw_th_t+V_t-P_tc_t-T_t\right).
$$

The household maximizes:

**(F2) Household preferences**
$$
E_0\sum_{t=0}^{\infty}\beta^t\left[u(c_t)+\kappa(m_t)-v(h_t)\right],
$$

subject to:

**(F3) Household portfolio budget**
$$
M_t+D_t+E_t(Q_{t,t+1}Z_{t+1})\leq W_t.
$$

For the reduced-form system, the paper adopts:

**(F4) Functional form for household utility**
$$
U(c_t,h_t)=\frac{c_t^{1-\sigma^{-1}}}{1-\sigma^{-1}}-\psi\frac{h_t^{1+\varphi}}{1+\varphi}.
$$

Money demand is made recursive by assuming a constant spread between the deposit return and the money return, so the household Euler equations match the benchmark NK structure in the reduced system.

### 2.2 Wholesale Firms and Entrepreneurs

Wholesale firm $i$ uses labor and idiosyncratic productivity:

**(F5) Wholesale production**
$$
y_{i,t}=A_t\omega_{i,t}l_{i,t}.
$$

The firm must borrow before production to finance labor costs. Total funds $P_tx_{i,t}$ satisfy:

**(F6) Working-capital financing constraint**
$$
x_{i,t}\geq w_tl_{i,t}.
$$

The firm chooses labor/funds subject to the financing constraint. With equality in (F6), optimality implies:

**(F7) Financial markup and real wage relation**
$$
q_t=\frac{A_t}{w_t\chi_t}.
$$

**(F8) Expected wholesale revenue condition**
$$
\mathcal{E}(y_{i,t})=\chi_tq_tx_{i,t}.
$$

Entrepreneurs have linear utility over consumption and consume final goods after loan repayment.

### 2.3 Financial Intermediary and Debt Contract

The bank collects household deposits and lends to firms. The idiosyncratic shock is privately observed by the entrepreneur and can be monitored by the intermediary at cost $\mu P_tx_{i,t}$. Let $\bar{\omega}_t$ be the default threshold. Define the entrepreneur and lender output shares:

**(F9) Entrepreneur share under the debt contract**
$$
f(\bar{\omega}_t)=\int_{\bar{\omega}_t}^{\infty}\omega\,\Phi(d\omega)-\bar{\omega}_t\left[1-\Phi(\bar{\omega}_t)\right].
$$

**(F10) Lender share under the debt contract**
$$
g(\bar{\omega}_t)=\int_{0}^{\bar{\omega}_t}\omega\,\Phi(d\omega)-\mu\Phi(\bar{\omega}_t)+\bar{\omega}_t\left[1-\Phi(\bar{\omega}_t)\right].
$$

The paper states that the online appendix derives the optimal contract. The contract optimality conditions reported in the Markdown are:

**(F11) Financial markup from costly state verification**
$$
q_t=\frac{R_t}{1-\mu\Phi(\bar{\omega}_t)+\frac{\mu f(\bar{\omega}_t)\phi(\bar{\omega}_t)}{f_{\bar{\omega}}(\bar{\omega}_t)}}.
$$

**(F12) Total production funds**
$$
x_t=\frac{R_t\tau_t}{R_t-q_tg(\bar{\omega}_t)}.
$$

The gross loan rate is backed out from the debt repayment condition and summarized by:

**(F13) Loan-deposit spread**
$$
\Delta_t=\frac{\bar{\omega}_t}{g(\bar{\omega}_t)}.
$$

### 2.4 Retail Firms

Retailers buy homogeneous wholesale output, differentiate it at no cost, and set prices subject to Calvo rigidity. The Markdown states that price setting is characterized in the online Appendix B; the main text uses the resulting Phillips curve in the reduced-form system.

## 3. First-Order Conditions

The first-order and optimality conditions available in the paper-side Markdown are (F7)-(F13), plus the reduced-form conditions below. The Calvo reset-price recursions are appendix-dependent and marked `needs_review` for source-level recovery before promotion.

Define inflation $\pi_{t+1}=\log(P_{t+1}/P_t)$, productivity $a_t=\log A_t$, and the internal-funds shock $\hat{\tau}_t=\log\tau_t$. Let $\tilde{Y}_t$ denote the output gap relative to efficient output. The log-linearized benchmark equilibrium is:

**(F14) Credit-spread relation**
$$
\delta_1\hat{\Delta}_t=\left(1+\varphi+\sigma^{-1}\frac{Y}{c}\right)\tilde{Y}_t-\sigma^{-1}\frac{e}{c}\hat{R}_t+\xi_{1,t}.
$$

**(F15) IS curve with credit channel**
$$
\tilde{Y}_t=E_t\tilde{Y}_{t+1}-\sigma\left(\frac{1+\sigma^{-1}\frac{e}{c}}{1-\varphi\frac{e}{c}}\right)(\hat{R}_t-E_t\pi_{t+1})
-\left(\frac{\alpha_1-\alpha_2\frac{e}{c}}{1-\varphi\frac{e}{c}}\right)(\hat{\Delta}_t-E_t\hat{\Delta}_{t+1})
+\frac{\frac{e}{c}}{1-\varphi\frac{e}{c}}(\hat{R}_t-E_t\hat{R}_{t+1})+\xi_{2,t}.
$$

**(F16) Phillips curve with nominal-rate and spread terms**
$$
\pi_t=\bar{\kappa}\left[(\sigma^{-1}\alpha_1+\alpha_2)\hat{\Delta}_t+(\sigma^{-1}+\varphi)\tilde{Y}_t+\hat{R}_t+\xi_{3,t}\right]+\beta E_t\pi_{t+1}.
$$

For empirical comparison, the paper rewrites the Phillips curve in terms of average real marginal cost $u_t$:

**(F17) Marginal-cost Phillips curve**
$$
\hat{\pi}_t=\lambda(\hat{u}_t+\hat{R}_t+\alpha_2\hat{\Lambda}_t)+\beta E_t\hat{\pi}_{t+1}.
$$

The GMM moment condition for that empirical equation is:

**(F18) GMM orthogonality condition**
$$
E_t\left\{\left[\theta\hat{\pi}_t-(1-\theta)(1-\theta\beta)\left(\frac{\hat{u}_t}{\zeta}+\eta\frac{\hat{R}_t}{\zeta}+\alpha_2\frac{\hat{\Delta}_t}{\zeta}\right)-\theta\beta\hat{\pi}_{t+1}\right]\mathbf{z}_t\right\}=0.
$$

## 4. Market Clearing & Identities

The paper-side Markdown implies the following aggregate conditions:

**(F19) Aggregate entrepreneurial consumption**
$$
e_t=f(\bar{\omega}_t)q_tx_t.
$$

Using the contract equations, entrepreneurial consumption can be written as:

**(F20) Entrepreneurial consumption in reduced form**
$$
e_t=\tau_tR_t\left[1+\frac{\mu\phi(\bar{\omega}_t)}{f_{\bar{\omega}}(\bar{\omega}_t)}\right]^{-1}.
$$

Final retail output is used for household and entrepreneurial consumption:

**(F21) Resource identity**
$$
Y_t=c_t+e_t.
$$

Average real marginal cost for wholesale goods is:

**(F22) Average wholesale real marginal cost**
$$
u_t=\frac{w_th_t}{y_t}.
$$

Retail marginal cost can be written using wholesale marginal cost and the financial markup:

**(F23) Retail marginal-cost identity**
$$
\chi_t^{-1}=u_tq_t.
$$

For the capital-augmented empirical extension discussed in Section 2, this becomes:

**(F24) Capital-extension marginal-cost identity**
$$
\chi_t^{-1}=\frac{q_tu_t}{a}.
$$

## 5. Exogenous Processes

The benchmark paper-side text identifies aggregate productivity and firms' internal funds as shocks. The Taylor-rule simulation adds a monetary policy shock. The MMB implementation additionally includes shocks to monitoring cost and idiosyncratic-risk dispersion; these are recorded as implementation cross-check variables, not as separately derived paper-side equations in this first pass.

**(F25) Productivity process**
$$
a_t=\rho_a a_{t-1}+\varepsilon^A_t.
$$

**(F26) Internal-funds shock process**
$$
\hat{\tau}_t=\rho_{\tau}\hat{\tau}_{t-1}+\varepsilon^{\tau}_t.
$$

For the Taylor-rule experiment:

**(F27) Monetary policy shock process**
$$
u_t^p=\rho_pu_{t-1}^p+\varepsilon^p_t.
$$

The monetary policy rule used for benchmark impulse responses is:

**(F28) Taylor-type policy rule**
$$
R_t=-\ln\beta+1.5\hat{\pi}_t+0.5\tilde{Y}_t+u_t^p.
$$

The endogenous-internal-funds extension, not the benchmark core, has:

**(F29) Endogenous internal-funds extension**
$$
\pi_tb_t=(1-\gamma)\left[1+\frac{\mu\phi(\bar{\omega}_t)}{f_{\bar{\omega}}(\bar{\omega}_t)}\right]^{-1}R_tb_{t-1}\varepsilon_t^v.
$$

## 6. Steady-State Solution

The source states that the nonlinear system is log-linearized around a zero-inflation steady state and then expressed in deviations from the efficient equilibrium. Detailed steady-state formulas are assigned to online Appendix C, which is not present as a normalized local source for this entry; this section is therefore `needs_review`.

Steady-state restrictions directly visible from the main text are:

**(F30) Zero-inflation steady state**
$$
\pi=0.
$$

**(F31) Deposit-rate steady state from the Taylor rule**
$$
R=-\ln\beta.
$$

**(F32) Steady-state spread target**
$$
\Delta=\frac{\bar{\omega}}{g(\bar{\omega})}.
$$

**(F33) Steady-state financial markup**
$$
q=\frac{R}{1-\mu\Phi(\bar{\omega})+\frac{\mu f(\bar{\omega})\phi(\bar{\omega})}{f_{\bar{\omega}}(\bar{\omega})}}.
$$

**(F34) Steady-state funds**
$$
x=\frac{R\tau}{R-qg(\bar{\omega})}.
$$

**(F35) Steady-state entrepreneurial consumption**
$$
e=\tau R\left[1+\frac{\mu\phi(\bar{\omega})}{f_{\bar{\omega}}(\bar{\omega})}\right]^{-1}.
$$

Calibration notes from the main text: $\mu=0.12$; idiosyncratic shocks are lognormal; $\sigma_{\omega}$ and the subsidy are calibrated so the annualized steady-state spread is about 2 percent and bankruptcy is about 1 percent quarterly; $\varepsilon=11$; $\theta=0.66$; $\rho_a=0.9$; $\rho_{\tau}=0.7317$.

## 7. Timing & Form Conventions

- Financial markets open at the beginning of the period after aggregate shocks. Firms borrow before production to pay labor costs.
- Goods markets open after financial contracts. Wholesale output is realized, sold to retailers, and loan repayment/default occurs at the end of the period.
- Loans are nominal one-period contracts; the deposit rate and loan rate are gross nominal rates in the source notation.
- No benchmark capital stock is present, so there is no productive-capital timing convention in the core model.
- $x_t$ is predetermined within the period before idiosyncratic productivity is observed but after aggregate shocks.
- $\bar{\omega}_t$ is the default threshold chosen in the same-period financial contract.
- The derivation combines nonlinear paper-side contract equations with log-linear reduced-form equations (F14)-(F16). This mixed presentation follows the paper. A final Dynare replication should choose a single implementation convention and document it.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Equation reference |
|---|---|---|---|
| Endogenous | $W_t$ / `wealth` | household nominal wealth | (F1) |
| Endogenous | $c_t$ / `cons_h` | household consumption | (F2), (F21) |
| Endogenous | $h_t$ / `labor` | household labor | (F4), (F6) |
| Endogenous | $D_t$ / `deposits` | household deposits | (F3) |
| Endogenous | $y_{i,t}$ / `y_i` | wholesale firm output | (F5) |
| Endogenous | $Y_t$ / `y_t` | aggregate final output | (F14)-(F16), (F21) |
| Endogenous | $x_t$ / `credit` | production funds / credit | (F6), (F12) |
| Endogenous | $q_t$ / `q_t` | financial markup | (F7), (F11), (F23) |
| Endogenous | $\chi_t$ / `chi_t` | retail markup term | (F7), (F23) |
| Endogenous | $\bar{\omega}_t$ / `omeg_t` | bankruptcy threshold | (F9)-(F13) |
| Endogenous | $\Delta_t$ / `spread` | loan-deposit spread | (F13), (F14) |
| Endogenous | $e_t$ / `cons_e` | entrepreneurial consumption | (F19), (F20) |
| Endogenous | $\pi_t$ / `infl` | inflation | (F16), (F17), (F18) |
| Endogenous | $\tilde{Y}_t$ / `ygap` | output gap | (F14)-(F16), (F28) |
| Endogenous | $R_t$ / `i_dep` | deposit/policy nominal rate | (F11), (F15), (F28) |
| Endogenous | $u_t$ / `mon_cost` or `u` | average real marginal cost / monitoring cost notation depends on context | (F22), (F17) |
| Exogenous | $A_t$ / `a_t` | aggregate productivity | (F5), (F25) |
| Exogenous | $\tau_t$ / `tau_t` | firms' internal funds | (F12), (F20), (F26) |
| Exogenous | $u_t^p$ / `pol_t` | monetary policy shock | (F27), (F28) |
| Exogenous | $\varepsilon_t^A$ / `epsA` | productivity innovation | (F25) |
| Exogenous | $\varepsilon_t^\tau$ / `epstau` | internal-funds innovation | (F26) |
| Exogenous | $\varepsilon_t^p$ / `epspol` | monetary policy innovation | (F27) |
| Parameter | $\beta$ / `bet` | discount factor | (F2), (F28) |
| Parameter | $\sigma$ / `sig` | intertemporal elasticity notation in utility | (F4), (F14)-(F18) |
| Parameter | $\varphi$ / `phi` | labor-disutility curvature | (F4), (F14)-(F16) |
| Parameter | $\psi$ / `psai` | labor-disutility weight | (F4) |
| Parameter | $\mu$ / `mu_hat` | monitoring-cost share | (F10), (F11), (F20) |
| Parameter | $\theta$ / `thet` | Calvo non-reset probability | (F18) |
| Parameter | $\varepsilon$ / `epsil` | elasticity of substitution | model overview / Calvo block |
| Parameter | $\alpha_1,\alpha_2,\delta_1$ | coefficients from appendix gap definitions | (F14)-(F16) |
| Parameter | $\bar{\kappa}$ | Phillips-curve slope composite | (F16) |
| Parameter | $\rho_a,\rho_{\tau},\rho_p$ | shock persistence | (F25)-(F27) |

Implementation cross-check: `.agents/skills/dynare-copilot/references/examples/NK_DT12_rep.mod` uses logged MMB variables including `cons_h`, `i_dep`, `infl`, `omeg_t`, `s_t`, `chi_t`, `thet1_t`, `thet2_t`, `y_t`, `spread`, `q_t`, `ygap`, `cons_e`, `mon_cost`, `Bankrupt`, `fo_t`, `ho_t`, `i_l`, `credit`, `stdoi_t`, `i_e`, `y_e`, `a_t`, `mu_t`, `pol_t`, and `tau_t`. These names are used here only to align coverage; equations above are sourced from the paper-side Markdown except where explicitly flagged as implementation cross-check.
