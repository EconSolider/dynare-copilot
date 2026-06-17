# NK_GM07 -- Derivation (Optimization Problems + First-Order Conditions)

> Model archive entry for MMB model `NK_GM07`.
> Source: Goodfriend and McCallum (2007), "Banking and interest rates in monetary policy analysis: A quantitative exploration", Journal of Monetary Economics 54(5), 1480-1507, DOI `10.1016/j.jmoneco.2007.06.009`.
> Runtime validation: not performed.

## 1. Model Overview

- **Model**: quantitative New Keynesian monetary model with a goods sector, an explicit competitive banking sector, transaction-facilitating deposits, collateral, and multiple short-term interest rates.
- **Agents and sectors**: a representative household consumes a Dixit-Stiglitz bundle, supplies labor to goods production and loan monitoring, saves in capital, bonds, and money, produces a differentiated good, and operates a competitive bank. The government/central bank supplies money, bonds, taxes/transfers, and policy rules.
- **Banking mechanism**: deposits finance transactions; loans/deposits are produced using monitoring labor and collateral services from bonds and capital. This generates a wedge between the benchmark intertemporal rate, the government bond rate, the interbank policy rate, and loan rates.
- **Model form**: the paper presents a nonlinear optimizing core and then uses a log-linear dynamic system around a calibrated deterministic steady state. The MMB implementation is `model(linear)` in deviations from steady state.
- **Provenance**: the derivation uses `raw/mmb_mineru/runs/nk_gm07__banking_and_interest_rates_in_monetary_policy_analysis_a_quantitative_ex__cb4ea347/full.md`. The raw PDF path exists but was not read beyond existence checks. No appendix normalization file exists. `.agents/skills/dynare-copilot/references/examples/NK_GM07_rep.mod` was used only as an implementation cross-check.
- **Source quality**: MinerU formulas are mostly readable, but several OCR tokens in the PDF-to-Markdown conversion are malformed. Equations that rely on these areas are marked `needs_review`.

## 2. Optimization Problems

### Representative Household / Goods Producer / Bank Owner

The paper folds household consumption-saving, goods production, and banking ownership into one representative household problem. The household chooses consumption, labor supplies, factor demands, capital, bonds, money, and its differentiated price.

$$
\max E_0 \sum_{t=0}^{\infty}\beta^t
\left[
\phi \log c_t + (1-\phi)\log(1-n_t^s-m_t^s)
\right].
$$

The household faces a real budget constraint:

$$
\begin{aligned}
0={}&q_t(1-\delta)K_t+\frac{B_t}{P_t^A}+\frac{H_{t-1}}{P_t^A}
+w_t(n_t^s+m_t^s)+c_t^A\left(\frac{P_t}{P_t^A}\right)^{1-\theta} \\
&-w_t(n_t+m_t)-\frac{H_t}{P_t^A}-tax_t-q_tK_{t+1}
-\frac{B_{t+1}}{P_t^A(1+R_t^B)}-c_t .
\end{aligned}
$$

The sales/net-production constraint is:

$$
K_t^\eta(A1_t n_t)^{1-\eta}
-c_t^A\left(\frac{P_t}{P_t^A}\right)^{-\theta}=0.
$$

The transaction technology requires deposits to finance consumption:

$$
c_t=\frac{V D_t}{P_t^A}.
$$

### Competitive Banking Sector

The bank balance sheet and loan-management technology are:

$$
H_t+L_t=D_t,
$$

$$
\frac{L_t}{P_t^A}
=F\left(b_{t+1}+A3_t k q_tK_{t+1}\right)^\alpha
\left(A2_t m_t\right)^{1-\alpha},
\qquad 0<\alpha<1 .
$$

Collateral combines government bonds and capital, with capital discounted by collateral-efficiency parameter $k$. Monitoring effort $m_t$ is the labor input to loan management.

### Price Setting and Monetary Policy

The flexible-price core implies a markup condition. The dynamic version replaces that condition with a Calvo-style New Keynesian Phillips curve. Monetary policy is represented either by an interbank-rate Taylor rule or by a high-powered-money growth rule.

## 3. First-Order Conditions

- **(F1) Liquidity/collateral shadow value definition**:

$$
\Omega_t
=\frac{\alpha c_t}{b_{t+1}+A3_t k q_tK_{t+1}} .
$$

- **(F2) Leisure-labor condition**:

$$
\frac{1-\phi}{1-n_t-m_t}=w_t\lambda_t .
$$

- **(F3) Banking monitoring labor condition**:

$$
w_t
=\left(\frac{\phi}{c_t\lambda_t}-1\right)
\frac{(1-\alpha)c_t}{m_t}.
$$

- **(F4) Goods labor demand / marginal product condition**:

$$
w_t
=\frac{\xi_t}{\lambda_t}A1_t(1-\eta)
\left(\frac{K}{n_tA1_t}\right)^\eta .
$$

- **(F5) Capital Euler condition** (`needs_review`: OCR around the second expectation is noisy, but the economic structure and MMB cross-check agree on the capital-price equation):

$$
\begin{aligned}
0={}&
\left(\frac{\phi}{c_t\lambda_t}-1\right)k\Omega_t q_t-q_t
+\beta(1-\delta)E_t\left(\frac{\lambda_{t+1}}{\lambda_t}q_{t+1}\right) \\
&+\beta\eta E_t\left[
\frac{\lambda_{t+1}\xi_{t+1}}{\lambda_t\lambda_{t+1}}
\left(\frac{A1_{t+1}n_{t+1}}{K}\right)^{1-\eta}
\right].
\end{aligned}
$$

- **(F6) Government-bond Euler / liquidity-service condition**:

$$
\left(\frac{\phi}{c_t\lambda_t}-1\right)\Omega_t-1
+\beta E_t\left[
\frac{\lambda_{t+1}P_t}{\lambda_tP_{t+1}}(1+R_t^B)
\right]=0 .
$$

- **(F7) Flexible-price markup condition**:

$$
\frac{\xi_t}{\lambda_t}=\frac{\theta-1}{\theta}.
$$

- **(F8) Real bond stock definition**:

$$
b_{t+1}=\frac{B_{t+1}}{P_t^A(1+R_t^B)} .
$$

- **(F9) Government budget constraint** (`needs_review`: OCR ambiguity around the bond denominator is preserved in notes):

$$
g_t-tax_t
=\frac{H_t}{P_t^A}-\frac{H_{t-1}}{P_t^A}
+\frac{B_{t+1}}{(1+R_t^B)P_t^A}
-\frac{B_t}{P_t^A}.
$$

- **(F10) Benchmark intertemporal rate**:

$$
1+R_t^T
=E_t\frac{\lambda_tP_{t+1}}{\beta\lambda_{t+1}P_t}.
$$

- **(F11) Bond rate versus benchmark rate**:

$$
\frac{1+R_t^B}{1+R_t^T}
=1-\left(\frac{\phi}{c_t\lambda_t}-1\right)\Omega_t .
$$

- **(F12) Liquidity-service yield approximation**:

$$
R_t^T-R_t^B=LSY_t^B .
$$

- **(F13) Capital collateral service yield approximation**:

$$
LSY_t^K=k\,LSY_t^B .
$$

- **(F14) Interbank spread / uncollateralized loan production cost**:

$$
(1+R_t^{IB})
\left[
1+\frac{Vw_tm_t}{(1-\alpha)(1-rr)c_t}
\right]
=1+R_t^T .
$$

- **(F15) Uncollateralized external finance premium approximation**:

$$
R_t^T-R_t^{IB}
=\frac{Vw_tm_t}{(1-\alpha)(1-rr)c_t}.
$$

- **(F16) Collateralized loan rate spread**:

$$
(1+R_t^{IB})
\left[
1+\frac{Vw_tm_t}{(1-rr)c_t}
\right]
=1+R_t^L .
$$

- **(F17) Collateralized EFP approximation**:

$$
R_t^L-R_t^{IB}
=\frac{Vw_tm_t}{(1-rr)c_t}.
$$

- **(F18) Deposit rate relation**:

$$
R_t^D=(1-rr)R_t^{IB}.
$$

## 4. Market Clearing & Identities

- **(F19) Bank balance sheet**:

$$
H_t+L_t=D_t.
$$

- **(F20) Transaction/deposit identity**:

$$
c_t=\frac{V D_t}{P_t^A}.
$$

- **(F21) Loan production technology**:

$$
\frac{L_t}{P_t^A}
=F\left(b_{t+1}+A3_t k q_tK_{t+1}\right)^\alpha
\left(A2_t m_t\right)^{1-\alpha}.
$$

- **(F22) Goods production / symmetric demand identity**:

$$
K_t^\eta(A1_t n_t)^{1-\eta}
=c_t^A\left(\frac{P_t}{P_t^A}\right)^{-\theta}.
$$

- **(F23) New Keynesian Phillips curve used in the dynamic linear model**:

$$
\Delta p_t=\beta E_t\Delta p_{t+1}+\kappa mc_t+u_t .
$$

- **(F24) Real marginal cost definition in the sticky-price model**:

$$
mc_t=\frac{\xi_t}{\lambda_t}.
$$

- **(F25) Price inflation identity**:

$$
\Delta \hat p_t=\hat P_t-\hat P_{t-1}.
$$

- **(F26) High-powered-money identity in the linear dynamic system**:

$$
\hat H_t=\hat c_t+\hat P_t.
$$

- **(F27) Linearized EFP definition**:

$$
EFP_t=\hat w_t+\hat m_t-\hat c_t.
$$

- **(F28) Constant bonds-to-consumption policy closure used in the MMB implementation**:

$$
\hat b_t=0.
$$

## 5. Exogenous Processes

- **(F29) Interbank-rate Taylor rule**:

$$
R_t^{IB}
=(1-\mu_3)\left[
\mu_0+(1+\mu_1)\Delta p_t+\mu_2 mc_t
\right]
+\mu_3R_{t-1}^{IB}+e_t .
$$

- **(F30) Alternative high-powered-money growth rule**:

$$
\Delta h_t=\rho^H\Delta h_{t-1}+e_t^H .
$$

- **(F31) Goods productivity shock**:

$$
a1_t=\rho_{a1}a1_{t-1}+\varepsilon_{a1,t}.
$$

- **(F32) Banking monitoring productivity shock**:

$$
a2_t=\rho_{a2}a2_{t-1}+\varepsilon_{a2,t}.
$$

- **(F33) Effective-collateral shock**:

$$
a3_t=\rho_{a3}a3_{t-1}-\varepsilon_{a3,t}.
$$

- **(F34) Monetary policy shock**:

$$
e_t=\varepsilon_{i,t}.
$$

- **(F35) Optional base-money shock**:

$$
e_t^H=\varepsilon_{h,t}.
$$

## 6. Steady-State Solution

The deterministic steady state has zero inflation, detrended productivity growth $\gamma$, $q=1$, and policy-fixed bonds-to-consumption ratio `boc`. The paper reduces the core steady-state block to seven equations in $c,m,n,w,\lambda,\Omega,K$.

- **(F36) Steady-state broad-liquidity / loan-production condition**:

$$
1=\frac{VF}{1-rr}
\left(boc+\frac{kqK}{c}\right)^\alpha
\left(\frac{m}{c}\right)^{1-\alpha}.
$$

- **(F37) Steady-state collateral shadow value**:

$$
\Omega=\frac{\alpha}{boc+kqK/c}.
$$

- **(F38) Steady-state leisure-labor condition**:

$$
\frac{1-\phi}{1-n-m}=w\lambda .
$$

- **(F39) Steady-state monitoring labor condition**:

$$
w=\left(\frac{\phi}{\lambda c}-1\right)\frac{(1-\alpha)c}{m}.
$$

- **(F40) Steady-state goods labor condition**:

$$
w=\frac{(\theta-1)(1-\eta)}{\theta}
\left(\frac{K}{n}\right)^\eta .
$$

- **(F41) Steady-state capital condition**:

$$
\left(\frac{\phi}{c\lambda}-1\right)k\Omega-1
+\frac{\beta}{1+\gamma}
\left[
1-\delta+\frac{\eta(\theta-1)}{\theta}
\left(\frac{K}{n}\right)^{\eta-1}
\right]=0 .
$$

- **(F42) Steady-state resource relation**:

$$
1=\left(\frac{K}{c}\right)^\eta
\left(\frac{n}{c}\right)^{1-\eta}
-\frac{\delta K}{c}.
$$

- **(F43) Steady-state benchmark rate**:

$$
R^T=\frac{1}{\beta(1+\gamma)}-1.
$$

- **(F44) Steady-state interest-rate recovery**:

$$
R^B,\;R^{IB},\;R^L,\;R^D
\quad\text{are recovered from (F11), (F15), (F17), and (F18).}
$$

Benchmark calibration values reported by the source include $c=0.8409$, $m=0.0063$, $n=0.3195$, $w=1.949$, $\lambda=0.457$, $\Omega=0.237$, $K=9.19$, $R^T=0.015$, $R^{IB}=0.0021$, $R^L=0.0066$, $R^B=0.0052$, and $CEFP=0.0045$.

## 7. Timing & Form Conventions

- Capital $K_t$ is installed at the start of period $t$ in the nonlinear production equation; the dynamic implementation uses a fixed detrended steady-state capital stock plus a forward-looking capital price $q_t$.
- Bonds $B_{t+1}$ and real bond collateral $b_{t+1}$ are end-of-period asset choices entering next-period collateral services.
- Deposits $D_t$ and high-powered money $H_t$ support current-period transactions through the binding deposit-consumption relation.
- The paper's dynamic system is written in hatted log deviations around the calibrated steady state, except interest rates and spreads, which are treated as deviations/rate variables in the implementation.
- The sticky-price version replaces the flexible-price labor demand/markup condition with the New Keynesian Phillips curve and real marginal cost definition.
- Runtime validation, Dynare residual checks, and Blanchard-Kahn diagnostics were not performed for this archive entry.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Main source equation |
|---|---|---|---|
| Endogenous | `dp` / $\Delta p_t$ | Inflation | (F23), (F25) |
| Endogenous | `mc` / $mc_t$ | Real marginal cost | (F24) |
| Endogenous | `omega` / $\Omega_t$ | Collateral/liquidity shadow value | (F1), (F37) |
| Endogenous | `lambda` / $\lambda_t$ | Budget multiplier / marginal utility of wealth | (F2), (F6) |
| Endogenous | `xi` / $\xi_t$ | Production constraint multiplier | (F4), (F7) |
| Endogenous | `w` / $w_t$ | Real wage | (F2), (F3), (F4) |
| Endogenous | `n` / $n_t$ | Goods-production labor | (F2), (F4), (F22) |
| Endogenous | `m` / $m_t$ | Banking monitoring labor | (F3), (F21) |
| Endogenous | `c` / $c_t$ | Consumption | (F20), (F42) |
| Endogenous | `q` / $q_t$ | Real price of capital | (F5) |
| Endogenous | `p` / $P_t$ | Price level/log price | (F25), (F26) |
| Endogenous | `h` / $H_t$ | High-powered money | (F19), (F26) |
| Endogenous | `b` / $b_t$ | Real bonds/collateral ratio | (F8), (F28) |
| Endogenous | `a1` | Goods productivity state | (F31) |
| Endogenous | `a2` | Banking productivity state | (F32) |
| Endogenous | `a3` | Effective-collateral state | (F33) |
| Endogenous | `EFP` | External finance premium | (F15), (F17), (F27) |
| Endogenous | `rT` / $R^T$ | Benchmark intertemporal rate | (F10), (F43) |
| Endogenous | `rIB` / $R^{IB}$ | Interbank policy rate | (F14), (F29) |
| Endogenous | `rL` / $R^L$ | Collateralized loan rate | (F16), (F17) |
| Endogenous | `rB` / $R^B$ | Government bond rate | (F6), (F11) |
| Exogenous | `eps_h` | Base-money growth shock | (F35) |
| Exogenous | `eps_a1` | Goods productivity innovation | (F31) |
| Exogenous | `eps_a2` | Banking productivity innovation | (F32) |
| Exogenous | `eps_a3` | Effective-collateral innovation | (F33) |
| Exogenous | `eps_i` | Interbank policy shock | (F34) |
| Parameter | `phi` / $\phi$ | Consumption weight in utility | utility |
| Parameter | `eta` / $\eta$ | Capital share in goods production | (F22) |
| Parameter | `theta` / $\theta$ | Demand elasticity / markup parameter | (F7), (F40) |
| Parameter | `beta` / $\beta$ | Discount factor | (F5), (F6), (F43) |
| Parameter | `kappa` / $\kappa$ | Phillips curve slope | (F23) |
| Parameter | `alpha` / $\alpha$ | Collateral share in loan production | (F1), (F21) |
| Parameter | `k` / $k$ | Capital collateral efficiency | (F1), (F13), (F21) |
| Parameter | `delta` / $\delta$ | Capital depreciation | (F5), (F41), (F42) |
| Parameter | `gamma` / $\gamma$ | Trend productivity growth | (F41), (F43) |
| Parameter | `rr` | Reserve ratio | (F14), (F16), (F36) |
| Parameter | `V` | Deposit velocity parameter | (F20), (F36) |
| Parameter | `boc` | Bonds-to-consumption steady-state ratio | (F36), (F37) |
| Parameter | `F` | Loan production scale | (F21), (F36) |
| Parameter | `mu_0, mu_1, mu_2, mu_3` | Policy-rule constants | (F29) |
| Parameter | `rho_h, rho_a1, rho_a2, rho_a3` | Shock persistence parameters | (F30)-(F33) |
