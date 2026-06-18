# US_CD08 -- Derivation (Optimization Problems + First-Order Conditions)

> First-pass private archive entry. Status: `needs_review`. Runtime validation was not performed.

## 1. Model Overview

- **Model ID**: `US_CD08`.
- **Source**: Ian Christensen and Ali Dib (2008), "The financial accelerator in an estimated New Keynesian model," *Review of Economic Dynamics* 11(1), 155-178, DOI `10.1016/j.red.2007.04.006`.
- **Source files**: primary OCR Markdown `raw/mmb_mineru/runs/us_cd08__the_financial_accelerator_in_an_estimated_new_keynesian_model__a324933c/full.md`; raw PDF `raw/mmb_papers/The financial accelerator in an estimated New Keynesian model.pdf`.
- **MinerU run id**: `a324933c-651a-412e-ae68-97c765d22004`.
- **Agents**: representative household, entrepreneurs, financial intermediary, capital producers, Calvo retailers, and a monetary authority.
- **Core mechanism**: entrepreneurs borrow with nominal debt contracts. The external finance premium increases with leverage, so net-worth movements change capital demand and amplify selected shocks.
- **Model form**: log-linearized `model(linear)` in the MMB implementation cross-check. The paper provides nonlinear equilibrium conditions in Appendix A, steady-state formulas in Appendix B, and the log-linearized system in Appendix C.
- **Shocks**: preference, money demand, technology, investment-efficiency, and monetary policy shocks.

## 2. Optimization Problems

### Households

The household chooses consumption, real money balances, labor, and deposits:

\[
\max_{\{c_t,m_t,h_t,D_t\}} E_0\sum_{t=0}^{\infty}\beta^t
\left[
\frac{\gamma e_t}{\gamma-1}\log\left(c_t^{\frac{\gamma-1}{\gamma}}+
b_t^{1/\gamma}m_t^{\frac{\gamma-1}{\gamma}}\right)
+\eta\log(1-h_t)
\right],
\]

where \(m_t=M_t/P_t\), subject to the nominal budget constraint

\[
P_tc_t+M_t+D_t\le W_th_t+R_{t-1}D_{t-1}+M_{t-1}+T_t+\Omega_t.
\]

### Entrepreneurs

Entrepreneurs buy capital at the end of period \(t\) for use in period \(t+1\). The purchase cost is \(q_tk_{t+1}\), financed by net worth \(n_{t+1}\) and borrowing \(q_tk_{t+1}-n_{t+1}\). Their capital-demand condition equates the expected return on capital to the expected external funds rate. The external premium is a reduced-form implication of a Bernanke-Gertler-Gilchrist costly-state-verification contract:

\[
S(\cdot)=S\left(\frac{n_{t+1}}{q_tk_{t+1}}\right),\qquad S'(\cdot)<0,\qquad S(1)=1.
\]

Entrepreneurs also rent capital and hire labor to produce wholesale goods:

\[
\max_{\{k_t,h_t\}}\; p_t^wy_t-W_th_t-Z_tk_t
\quad\text{s.t.}\quad
y_t=k_t^{\alpha}(A_th_t)^{1-\alpha},
\]

where \(p_t^w/P_t=\xi_t\) is real marginal cost and \(z_t=Z_t/P_t\) is the real marginal product of capital.

### Capital Producers

Capital producers choose investment to maximize real profits:

\[
\max_{i_t} E_t\left[
q_tx_ti_t-i_t-\frac{\chi}{2}\left(\frac{i_t}{k_t}-\delta\right)^2k_t
\right].
\]

The capital law of motion is

\[
k_{t+1}=x_ti_t+(1-\delta)k_t.
\]

### Retailers

Retailers buy wholesale goods, differentiate them, and set prices subject to Calvo-Yun staggered adjustment. A retailer that can reoptimize chooses \(\tilde p_t(j)\) to maximize discounted expected real profits:

\[
\max_{\{\tilde p_t(j)\}} E_t\sum_{l=0}^{\infty}(\beta\phi)^l
\lambda_{t+l}\frac{\Omega_{t+l}(j)}{p_{t+l}},
\]

subject to demand

\[
y_{t+l}(j)=\left(\frac{\tilde p_t(j)}{p_{t+l}}\right)^{-\theta}y_{t+l}.
\]

## 3. First-Order Conditions

- **(F1) Consumption marginal utility**:

\[
\frac{e_tc_t^{-1/\gamma}}
{c_t^{\frac{\gamma-1}{\gamma}}+b_t^{1/\gamma}m_t^{\frac{\gamma-1}{\gamma}}}
=\lambda_t.
\]

- **(F2) Money demand**:

\[
\left(\frac{b_tc_t}{m_t}\right)^{1/\gamma}=\frac{R_t-1}{R_t}.
\]

- **(F3) Labor supply**:

\[
\frac{\eta}{1-h_t}=\lambda_tw_t.
\]

- **(F4) Household Euler equation**:

\[
\frac{\lambda_t}{R_t}=\beta E_t\left(\frac{\lambda_{t+1}}{\pi_{t+1}}\right).
\]

- **(F5) Entrepreneurial capital return**:

\[
E_tf_{t+1}=E_t\left[\frac{z_{t+1}+(1-\delta)q_{t+1}}{q_t}\right].
\]

- **(F6) External financing cost**:

\[
E_tf_{t+1}=E_t\left[
S\left(\frac{n_{t+1}}{q_tk_{t+1}}\right)\frac{R_t}{\pi_{t+1}}
\right].
\]

- **(F7) Log-linear external funds rate**:

\[
\hat f_{t+1}=\hat R_t-\hat\pi_{t+1}
+\psi(\hat q_t+\hat k_{t+1}-\hat n_{t+1}).
\]

- **(F8) Entrepreneurial net worth**:

\[
n_{t+1}=\nu v_t+(1-\nu)g_t.
\]

- **(F9) Surviving entrepreneurs' equity**:

\[
v_t=f_tq_{t-1}k_t-E_{t-1}f_t(q_{t-1}k_t-n_t).
\]

- **(F10) Capital rental condition**:

\[
z_t=\alpha\xi_t\frac{y_t}{k_t}.
\]

- **(F11) Labor demand**:

\[
w_t=(1-\alpha)\xi_t\frac{y_t}{h_t}.
\]

- **(F12) Wholesale production**:

\[
y_t=k_t^{\alpha}(A_th_t)^{1-\alpha}.
\]

- **(F13) Capital producer Tobin's Q condition**:

\[
q_tx_t=1+\chi\left(\frac{i_t}{k_t}-\delta\right).
\]

- **(F14) Calvo reset price**:

\[
\tilde p_t(j)=\frac{\theta}{\theta-1}
\frac{E_t\sum_{l=0}^{\infty}(\beta\phi)^l\lambda_{t+l}y_{t+l}(j)\xi_{t+l}}
{E_t\sum_{l=0}^{\infty}(\beta\phi)^l\lambda_{t+l}y_{t+l}(j)\pi^l/p_{t+l}}.
\]

- **(F15) Aggregate price index**:

\[
p_t^{1-\theta}=\phi(\pi p_{t-1})^{1-\theta}+(1-\phi)\tilde p_t^{1-\theta}.
\]

- **(F16) New Keynesian Phillips curve**:

\[
\hat\pi_t=\beta E_t\hat\pi_{t+1}
+\frac{(1-\beta\phi)(1-\phi)}{\phi}\hat\xi_t.
\]

- **(F17) Household multiplier law of motion, log-linearized**:

\[
\hat\lambda_{t+1}=\hat\lambda_t-\hat R_t+\hat\pi_{t+1}.
\]

## 4. Market Clearing & Identities

- **(F18) Final-goods resource constraint**:

\[
y_t=c_t+i_t.
\]

- **(F19) Money growth identity**:

\[
\mu_t=\frac{m_t\pi_t}{m_{t-1}}.
\]

- **(F20) Log-linear nominal money growth**:

\[
\hat\mu_t=\hat m_t-\hat m_{t-1}+\hat\pi_t.
\]

- **(F21) Capital accumulation**:

\[
k_{t+1}=x_ti_t+(1-\delta)k_t.
\]

The MMB implementation writes (F21) in log-linear form as

\[
\hat k_{t+1}=\delta\hat i_t+\delta\hat x_t+(1-\delta)\hat k_t.
\]

## 5. Exogenous Processes

- **(F22) Preference shock**:

\[
\log(e_t)=\rho_e\log(e_{t-1})+\varepsilon_{et}.
\]

- **(F23) Money-demand shock**:

\[
\log(b_t)=(1-\rho_b)\log(b)+\rho_b\log(b_{t-1})+\varepsilon_{bt}.
\]

- **(F24) Technology shock**:

\[
\log(A_t)=(1-\rho_A)\log(A)+\rho_A\log(A_{t-1})+\varepsilon_{At}.
\]

- **(F25) Investment-efficiency shock**:

\[
\log(x_t)=\rho_x\log(x_{t-1})+\varepsilon_{xt}.
\]

- **(F26) Monetary policy rule**:

\[
\frac{R_t}{R}=
\left(\frac{\pi_t}{\pi}\right)^{\varrho_{\pi}}
\left(\frac{y_t}{y}\right)^{\varrho_y}
\left(\frac{\mu_t}{\mu}\right)^{\varrho_{\mu}}
\exp(\varepsilon_{Rt}).
\]

In the log-linear equilibrium, (F26) becomes

\[
\hat R_t=\varrho_{\pi}\hat\pi_t+\varrho_{\mu}\hat\mu_t+\varrho_y\hat y_t+\varepsilon_{Rt}.
\]

## 6. Steady-State Solution

The steady state uses constant values with no shocks. Appendix B gives the following solution blocks:

- **(F27) Capital price**:

\[
q=1.
\]

- **(F28) Real marginal cost**:

\[
\xi=\frac{\theta-1}{\theta}.
\]

- **(F29) Nominal interest rate**:

\[
R=\frac{\pi}{\beta}.
\]

- **(F30) External funds rate**:

\[
f=\frac{SR}{\pi}.
\]

- **(F31) Return decomposition**:

\[
f=z+1-\delta.
\]

- **(F32) Consumption marginal-utility product**:

\[
\lambda c=\left[1+b\left(\frac{\pi}{\pi-\beta}\right)^{\gamma-1}\right]^{-1}.
\]

- **(F33) Money marginal-utility product**:

\[
\lambda m=\lambda c\,b\left(\frac{\pi}{\pi-\beta}\right)^{\gamma}.
\]

- **(F34) Capital-output ratio**:

\[
\frac{k}{y}=\alpha\frac{\xi}{z}.
\]

- **(F35) Consumption-output ratio**:

\[
\frac{c}{y}=1-\delta\frac{k}{y}.
\]

- **(F36) Labor share condition**:

\[
wh\lambda=\frac{(1-\alpha)(\lambda c)\xi}{c/y}.
\]

- **(F37) Hours**:

\[
h=\frac{wh\lambda}{\eta+wh\lambda}.
\]

- **(F38) Output**:

\[
y=Ah\left(\frac{k}{y}\right)^{\alpha/(1-\alpha)}.
\]

- **(F39) Investment**:

\[
i=\delta k.
\]

The implementation cross-check also records calibrated values such as \(\beta=0.9928\), \(\delta=0.025\), \(\pi=1.0079\), \(S=1.0075\), \(\nu=0.9728\), and \(k/n=2\). Runtime validation and reconciliation of every implementation steady-state helper were not performed.

## 7. Timing & Form Conventions

- **Form**: the paper's computational system is log-linearized around the deterministic steady state; the MMB file uses `model(linear)`.
- **Hats**: \(\hat x_t\) denotes a log deviation from steady state.
- **Capital timing**: the paper writes entrepreneurs purchasing \(k_{t+1}\) at the end of period \(t\) for use next period. The MMB implementation shifts the index so production uses lagged capital `k(-1)`.
- **Nominal debt**: loan contracts specify nominal repayments; realized inflation affects the real cost of debt repayment and thus net worth.
- **External funds rate**: (F7) links expected real borrowing cost to nominal risk-free rates, expected inflation, and leverage.
- **Runtime validation**: not performed; no Dynare commands were run.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Main equation(s) |
|---|---|---|---|
| Endogenous | \(\lambda_t\) / `lambda` | household budget multiplier | (F1), (F4), (F17) |
| Endogenous | \(c_t\) / `c` | consumption | (F1), (F18), (F32), (F35) |
| Endogenous | \(b_t\) / `b` | money-demand shifter | (F2), (F23) |
| Endogenous | \(m_t\) / `m` | real money balances | (F2), (F19), (F20) |
| Endogenous | \(e_t\) / `e` | preference shifter | (F1), (F22) |
| Endogenous | \(R_t\) / `r` | gross nominal risk-free rate | (F4), (F26), (F29) |
| Endogenous | \(h_t\) / `h` | hours | (F3), (F11), (F37) |
| Endogenous | \(w_t\) / `w` | real wage | (F3), (F11), (F36) |
| Endogenous | \(y_t\) / `y` | output | (F12), (F18), (F38) |
| Endogenous | \(k_t\) / `k` | capital stock | (F10), (F12), (F21), (F34) |
| Endogenous | \(A_t\) / `a` | technology level | (F12), (F24), (F38) |
| Endogenous | \(i_t\) / `i` | investment | (F13), (F18), (F21), (F39) |
| Endogenous | \(\xi_t\) / `cost` | real marginal cost | (F10), (F11), (F16), (F28) |
| Endogenous | \(z_t\) / `z` | marginal product of capital | (F5), (F10), (F31) |
| Endogenous | \(\mu_t\) / `mu` | money growth | (F19), (F20), (F26) |
| Endogenous | \(\pi_t\) / `pi` | gross inflation | (F4), (F16), (F19), (F26) |
| Endogenous | \(q_t\) / `q` | price of capital | (F5), (F6), (F13), (F27) |
| Endogenous | \(x_t\) / `x` | investment-efficiency shifter | (F13), (F21), (F25) |
| Endogenous | \(f_t\) / `f` | external funds rate / return on capital | (F5), (F6), (F7), (F30) |
| Endogenous | \(n_t\) / `n` | entrepreneurial net worth | (F6), (F7), (F8), (F9) |
| Endogenous | `rp` | risk premium, implementation helper | (F6), (F7) |
| Exogenous | `e_r` / \(\varepsilon_{Rt}\) | monetary policy innovation | (F26) |
| Exogenous | `u_x` / \(\varepsilon_{xt}\) | investment-efficiency innovation | (F25) |
| Exogenous | `u_a` / \(\varepsilon_{At}\) | technology innovation | (F24) |
| Exogenous | `u_e` / \(\varepsilon_{et}\) | preference innovation | (F22) |
| Exogenous | `u_b` / \(\varepsilon_{bt}\) | money-demand innovation | (F23) |
| Parameter | \(\beta\) / `beta` | discount factor | (F4), (F29) |
| Parameter | \(\gamma\) / `gamma` | consumption-money CES parameter | (F1), (F2), (F32), (F33) |
| Parameter | \(\eta\) / `eta` | leisure weight; called `eta` in paper, omitted from parameter list in the cross-check header | (F3), (F37) |
| Parameter | \(\alpha\) / `alpha` | capital share | (F10), (F12), (F34) |
| Parameter | \(\delta\) / `delta` | depreciation rate | (F13), (F21), (F31), (F39) |
| Parameter | \(\chi\) / `chi` | capital adjustment-cost parameter | (F13) |
| Parameter | \(\psi\) / `psi` | elasticity of external finance premium to leverage | (F7) |
| Parameter | \(\nu\) / `nu` | entrepreneur survival probability | (F8) |
| Parameter | \(\phi\) / `phi` | Calvo non-reoptimization probability | (F14), (F15), (F16) |
| Parameter | \(\theta\) / `theta` | substitution elasticity / desired markup | (F14), (F15), (F28) |
| Parameter | \(\varrho_{\pi},\varrho_y,\varrho_{\mu}\) / `rho_pi`, `rho_y`, `rho_mu` | policy responses | (F26) |
| Parameter | \(\rho_A,\rho_x,\rho_e,\rho_b\) / `rho_a`, `rho_x`, `rho_e`, `rho_b` | shock persistence | (F22)-(F25) |
| Parameter | \(S\) / `S` | steady-state gross external finance premium | (F30) |
