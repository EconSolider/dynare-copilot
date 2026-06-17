# NK_GS14 - Derivation

> Model archive draft for `NK_GS14`. Runtime validation was not performed. The source equations are taken from the MinerU Markdown for Gambacorta and Signoretti (2014), especially Appendix A, with the MMB replication file used only as an implementation cross-check.

## 1. Model Overview

- **Model**: `NK_GS14`, based on Leonardo Gambacorta and Federico M. Signoretti (2014), "Should monetary policy lean against the wind? An analysis based on a DSGE model with banking", *Journal of Economic Dynamics and Control*, 43, 146-174, DOI `10.1016/j.jedc.2014.01.016`.
- **Source**: `raw/mmb_mineru/runs/nk_gs14__should_monetary_policy_lean_against_the_wind_an_analysis_based_on_a_dsge__0f9b3acb/full.md`; raw PDF path checked at `raw/mmb_papers/Should monetary policy lean against the wind? An analysis based on a DSGE model with banking.pdf`.
- **Agents**: patient households, impatient entrepreneurs, banks with wholesale and retail loan branches, capital-good producers, retailers, and a central bank.
- **Core frictions**: entrepreneurs face a collateral/borrowing constraint tied to the value of capital; banks face a target capital-to-asset ratio and adjust loan spreads with bank leverage.
- **Shocks and policy experiments**: the paper studies technology and cost-push shocks under standard and augmented Taylor rules that can respond to output, credit, and the asset price of capital.
- **Model form**: source Appendix A gives a full nonlinear equilibrium system. The paper solves the model by log-linearization around a non-stochastic zero-inflation steady state, and the MMB implementation uses log-level nonlinear equations with `exp(...)` variables and first-order `stoch_simul`; it is not written as a Dynare `model(linear)` block.
- **Status**: `needs_review`, because several Appendix C formulas in the MinerU Markdown contain OCR artifacts, and no Dynare runtime validation was executed.

## 2. Optimization Problems

### Patient households

Household $i$ chooses consumption, labor supply, and deposits:

$$
\max_{\{c_t^p(i),l_t^p(i),d_t^p(i)\}}
E_0\sum_{t=0}^{\infty}\beta_P^t
\left[\log c_t^p(i)-\frac{(l_t^p(i))^{1+\phi}}{1+\phi}\right].
$$

The budget constraint is:

$$
c_t^P(i)+d_t^P(i)
\leq w_t l_t^P(i)+(1+r_{t-1}^{ib})d_{t-1}^P(i)+J_t^R(i).
$$

### Entrepreneurs

Entrepreneur $i$ chooses consumption, labor demand, loans, and capital:

$$
\max_{\{c_t^E(i),l_t^{P,d}(i),b_t^{EE}(i),k_t^E(i)\}}
E_0\sum_{t=0}^{\infty}\beta_E^t\log c_t^E(i).
$$

The budget constraint is:

$$
c_t^E(i)+(1+r_{t-1}^b)b_{t-1}^{EE}(i)+w_t l_t^{P,d}(i)+q_t^k k_t^E(i)
\leq \frac{y_t^e(i)}{x_t}+b_t^{EE}(i)+q_t^k(1-\delta^k)k_{t-1}^e(i).
$$

The collateral constraint is:

$$
b_t^{EE}(i)\leq
\frac{m^E q_{t+1}^k k_t^e(i)(1-\delta^k)}{1+r_t^b}.
$$

Entrepreneurs produce wholesale output:

$$
y_t^E(i)=A_t^E(k_{t-1}^E(i))^{\xi}(l_t^{P,d}(i))^{1-\xi}.
$$

The source equation A.7 prints $k_t^E$ in the production function, while both the return-to-capital equation and MMB implementation use predetermined capital $k_{t-1}^E$; this timing normalization is marked `needs_review`.

### Wholesale bank branch

Bank $j$ chooses loans and deposits:

$$
\max_{\{b_t(j),d_t(j)\}}
R_t^b b_t(j)-r_t^{ib}d_t(j)
-\frac{\theta}{2}\left(\frac{K_t^b(j)}{b_t(j)}-\nu\right)^2K_t^b(j)
$$

subject to:

$$
b_t(j)=d_t(j)+K_t^b(j).
$$

### Capital-good producers and retailers

Capital-good producers convert final goods into new capital with investment adjustment costs. Retailers imply a Rotemberg-style New Keynesian Phillips curve with markup shock $mk_t^y$ and marginal cost $mc_t^E=1/x_t$.

## 3. First-Order Conditions

- **(F1) Household marginal utility**:

$$
\lambda_t^P=\frac{1}{c_t^p}.
$$

- **(F2) Household Euler equation**:

$$
\frac{1}{c_t^p}
=E_t\left[\frac{\beta_P(1+r_t^{ib})}{c_{t+1}^p}\right].
$$

- **(F3) Household labor supply**:

$$
(l_t^p)^\phi=\frac{w_t}{c_t^p}.
$$

- **(F4) Household budget constraint**:

$$
c_t^p+d_t^p=w_t l_t^p+(1+r_{t-1}^{ib})d_{t-1}^p+J_t^R/\gamma_p.
$$

- **(F5) Entrepreneur marginal utility**:

$$
\lambda_t^E=\frac{1}{c_t^E}.
$$

- **(F6) Entrepreneur labor demand**:

$$
w_t=\frac{(1-\xi)y_t^e}{l_t^{P,d}x_t}.
$$

- **(F7) Entrepreneur investment Euler equation**:

$$
s_t^E\frac{m^E q_{t+1}^k(1-\delta^k)}{1+r_t^b}
\beta_E E_t\left[\lambda_{t+1}^E\left(q_{t+1}^k(1-\delta^k)+r_{t+1}^k\right)\right]
=\lambda_t^E q_t^k.
$$

- **(F8) Entrepreneur consumption Euler equation with collateral multiplier**:

$$
\lambda_t^E-s_t^E
=\beta_E E_t\left[\lambda_{t+1}^E(1+r_t^b)\right].
$$

- **(F9) Entrepreneur budget constraint**:

$$
c_t^E+(1+r_{t-1}^b)b_{t-1}^{EE}+w_t l_t^{P,d}+q_t^k k_t^E
=\frac{y_t^e}{x_t}+b_t^{EE}+q_t^k(1-\delta^k)k_{t-1}^e.
$$

- **(F10) Entrepreneur production function**:

$$
y_t^e=A_t^E(k_{t-1}^E)^\xi(l_t^{P,d})^{1-\xi}.
$$

- **(F11) Borrowing constraint**:

$$
(1+r_t^b)b_t^{EE}=m^E q_{t+1}^k k_t^e(1-\delta^k).
$$

- **(F12) Return to capital**:

$$
r_t^k=\xi\frac{A_t^E(k_{t-1}^E)^{\xi-1}(l_t^{P,d})^{1-\xi}}{x_t}.
$$

- **(F13) Capital accumulation with adjustment costs**:

$$
K_t=(1-\delta^k)K_{t-1}
+\left[1-\frac{\kappa^i}{2}\left(\frac{I_t}{I_{t-1}}-1\right)^2\right]I_t.
$$

- **(F14) Capital-good producer FOC for $q_t^k$**:

$$
1=q_t^k\left[
1-\frac{\kappa^i}{2}\left(\frac{I_t}{I_{t-1}}-1\right)^2
-\kappa^i\left(\frac{I_t}{I_{t-1}}-1\right)\frac{I_t}{I_{t-1}}
\right]
+\beta_E E_t\left[
\frac{\lambda_{t+1}^E}{\lambda_t^E}q_{t+1}^k\kappa^i
\left(\frac{I_{t+1}}{I_t}-1\right)
\left(\frac{I_{t+1}}{I_t}\right)^2
\right].
$$

- **(F15) New Keynesian Phillips curve**:

$$
1-\frac{mk_t^y}{mk_t^y-1}
+\frac{mk_t^y}{mk_t^y-1}mc_t^E
-\kappa_p(\pi_t-1)\pi_t
+\beta_P E_t\left[
\frac{\lambda_{t+1}^P}{\lambda_t^P}\kappa_p(\pi_{t+1}-1)\pi_{t+1}
\frac{Y_{t+1}}{Y_t}
\right]=0.
$$

- **(F16) Retail marginal cost / markup identity**:

$$
mc_t^E=\frac{1}{x_t}.
$$

- **(F17) Wholesale bank FOC for the loan rate**:

$$
R_t^b=r_t^{ib}
-\theta\left(\frac{K_t^b}{B_t}-\nu\right)\left(\frac{K_t^b}{B_t}\right)^2.
$$

- **(F18) Retail loan rate with additive markup**:

$$
r_t^b=R_t^b+\overline{\mu}^b.
$$

- **(F19) Loan spread definition**:

$$
spread_t=r_t^b-r_t^{ib}.
$$

- **(F20) Aggregate bank profits**:

$$
J_t^B=r_t^bB_t-r_t^{ib}D_t
-\frac{\theta}{2}\left(\frac{K_t^b}{B_t}-\nu\right)^2K_t^b.
$$

- **(F21) Bank capital accumulation**:

$$
K_t^b=(1-\delta^b)K_{t-1}^b+J_{t-1}^B.
$$

## 4. Market Clearing & Identities

- **(F22) Aggregate consumption**:

$$
C_t=\gamma_p c_t^p+\gamma_e c_t^e.
$$

- **(F23) Labor market clearing**:

$$
\gamma_e l_t^{P,d}=\gamma_p l_t^p.
$$

- **(F24) Aggregate loans**:

$$
B_t=\gamma_e b_t^{EE}.
$$

- **(F25) Aggregate deposits**:

$$
D_t=\gamma_p d_t^p.
$$

- **(F26) Aggregate capital**:

$$
K_t=\gamma_e k_t^e.
$$

- **(F27) Aggregate bank balance sheet / credit-market equilibrium**:

$$
B_t=D_t+K_t^b.
$$

- **(F28) Aggregate output**:

$$
Y_t=\gamma_e y_t^e.
$$

- **(F29) Resource constraint**:

$$
Y_t=C_t+q_t^k\left(K_t-(1-\delta^k)K_{t-1}\right)
+\frac{\delta^b K_{t-1}^b}{\pi_t}.
$$

- **(F30) Auxiliary output used in the MMB policy rule cross-check**:

$$
Y1_t=C_t+I_t.
$$

- **(F31) Bank leverage**:

$$
lev_t=\frac{B_t}{K_t^b}.
$$

- **(F32) Real-rate diagnostic used in the implementation**:

$$
rr_t=r_t^b-\pi_t.
$$

- **(F33) General augmented Taylor rule**:

$$
\tilde r_t^{ib}=\rho^{ib}\tilde r_{t-1}^{ib}
+(1-\rho^{ib})
\left[
\phi_\pi\widehat{\pi}_t+\phi_y\widehat{Y}_t+\phi_B\widehat{B}_t+\phi_q\widehat{q}_t^k
\right].
$$

The nonlinear MMB implementation cross-check writes this as a gross-rate rule with steady-state-normalized inflation, the auxiliary output aggregate $Y1_t$, asset prices, and credit. This implementation detail is recorded as `implementation_cross_check`, not as a separate paper-side source equation.

## 5. Exogenous Processes

- **(F34) Technology shock**:

$$
A_t^E=\rho^A A_{t-1}^E+\varepsilon_t^A.
$$

The MMB file implements the positive-level process as
$A_t^E=1-\rho_A+\rho_A A_{t-1}^E+e_t^A$ inside `exp(A_e)`. The paper's source expression is the linearized AR(1) in deviations.

- **(F35) Goods markup / cost-push shock**:

$$
mk_t^y=(1-\rho_{mk})mk^y+\rho_{mk}mk_{t-1}^y+\varepsilon_t^{mk}.
$$

This equation is reconstructed from the MMB implementation and the paper's statement that the cost-push shock enters the Phillips curve through $mk_t^y$ / $\widehat{\varepsilon}_t^y$; mark `needs_review` for source-level formula review.

## 6. Steady-State Solution

The paper uses a non-stochastic zero-inflation steady state and solves the model by log-linearization around that point. The implementation cross-check supplies numerical initial values rather than a closed-form `steady_state_model`; runtime validation was not performed.

Steady-state normalization and sequence:

1. Set $\bar{\pi}=1$, $\bar{A}^E=1$, $\bar{mk}^y=mk^y$, and zero innovations.
2. The household Euler equation implies

$$
1=\beta_P(1+\bar r^{ib}).
$$

3. The calibrated bank spread implies $\bar r^b=\bar r^{ib}+\overline{\mu}^b$ when bank capital is at target, $\bar K^b/\bar B=\nu$.
4. Capital price is normalized at $\bar q^k=1$ in the implementation cross-check.
5. The target capital ratio, bank balance sheet, and aggregate loan/deposit definitions imply:

$$
\bar K^b=\nu\bar B,\qquad \bar D=(1-\nu)\bar B,\qquad \bar B=\gamma_e\bar b^{EE}.
$$

6. The binding borrowing constraint gives:

$$
(1+\bar r^b)\bar b^{EE}=m^E\bar k^e(1-\delta^k).
$$

7. The production, labor-demand, labor-supply, and resource equations jointly pin down $\bar y^e,\bar l^{P,d},\bar l^p,\bar w,\bar c^p,\bar c^e,\bar I,\bar K,\bar Y$ under the calibration and steady-state ratios reported in the paper.
8. The banking capital law requires:

$$
\delta^b\bar K^b=\bar J^B.
$$

9. The paper reports steady-state ratios including $C/Y=0.90$, $I/Y=0.11$, $c^E/C=0.05$, $B/K=0.33$, $K^b/B=0.09$, and a 2 percent annual bank loan spread. These are calibration targets/checks, not a verified analytic steady-state derivation.

Deferred issue: a future implementation pass should derive or reproduce the exact steady-state construction used by the MMB file and run `resid; steady; check;`.

## 7. Timing & Form Conventions

- Capital is predetermined in production and returns: the implementation uses $k_{t-1}^E$ in production and $K_{t-1}$ in capital accumulation/resource equations. The printed Appendix A production equation is normalized to this timing, with `needs_review` noted above.
- Deposits and loans chosen in period $t-1$ pay rates in period $t$: household and entrepreneur budgets include $(1+r_{t-1}^{ib})d_{t-1}^p$ and $(1+r_{t-1}^b)b_{t-1}^{EE}$.
- The collateral constraint uses next-period capital price $q_{t+1}^k$ and current loan rate $r_t^b$.
- Bank capital follows a lagged-profit law, $K_t^b=(1-\delta^b)K_{t-1}^b+J_{t-1}^B$.
- The policy rule in the source is log-linear in deviations. The MMB implementation maps variables to log levels using `exp(...)` and simulates to first order.
- Debt is indexed to current inflation in the baseline. Appendix D gives a nominal-debt variant; this archive entry records it as a deferred variant, not part of the baseline `NK_GS14` equation list.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII name | Meaning | Main equation(s) |
|---|---|---|---|
| Endogenous | $c^p$ / `c_p` | patient-household consumption | (F1), (F2), (F4), (F22) |
| Endogenous | $d^p$ / `d_p` | patient-household deposits | (F4), (F25) |
| Endogenous | $\lambda^P$ / `lam_p` | household marginal utility | (F1), (F15) |
| Endogenous | $l^p$ / `l_p` | household labor supply | (F3), (F23) |
| Endogenous | $c^E$ / `c_e` | entrepreneur consumption | (F5), (F8), (F9), (F22) |
| Endogenous | $k^E$ / `k_e` | entrepreneur capital | (F9), (F10), (F11), (F26) |
| Endogenous | $b^{EE}$ / `b_ee` | entrepreneur loans | (F9), (F11), (F24) |
| Endogenous | $\lambda^E$ / `lam_e` | entrepreneur marginal utility | (F5), (F7), (F14) |
| Endogenous | $s^E$ / `s_e` | borrowing-constraint multiplier | (F7), (F8) |
| Endogenous | $l^{P,d}$ / `l_pd` | entrepreneur labor demand | (F6), (F10), (F23) |
| Endogenous | $y^e$ / `y_e` | entrepreneur wholesale output | (F10), (F28) |
| Endogenous | $r^k$ / `r_k` | return to capital | (F12) |
| Endogenous | $\pi$ / `pie` | gross inflation | (F15), (F29), (F33) |
| Endogenous | $mc^E$ / `mc_E` | marginal cost | (F15), (F16) |
| Endogenous | $J^R$ / `J_R` | retailer profits | (F4) |
| Endogenous | $q^k$ / `q_k` | capital price | (F7), (F11), (F14), (F29), (F33) |
| Endogenous | $x$ / `x` | retailer markup | (F6), (F10), (F12), (F16) |
| Endogenous | $I$ / `I` | investment | (F13), (F14), (F30) |
| Endogenous | $C$ / `C` | aggregate consumption | (F22), (F29), (F30) |
| Endogenous | $Y$ / `Y` | aggregate output | (F28), (F29), (F33) |
| Endogenous | $w$ / `w_p` | real wage | (F3), (F4), (F6), (F9) |
| Endogenous | $B$ / `B` | aggregate loans/credit | (F24), (F27), (F31), (F33) |
| Endogenous | $D$ / `D` | aggregate deposits | (F25), (F27) |
| Endogenous | $K$ / `K` | aggregate capital | (F13), (F26), (F29) |
| Endogenous | $r^{ib}$ / `r_ib` | policy/deposit rate | (F2), (F17), (F19), (F33) |
| Endogenous | $J^B$ / `J_B` | bank profits | (F20), (F21) |
| Endogenous | $r^b$ / `r_b` | retail loan rate | (F8), (F9), (F11), (F18), (F19) |
| Endogenous | $spread$ / `spread` | loan-policy spread | (F19) |
| Endogenous | $K^b$ / `K_b` | bank capital | (F20), (F21), (F27), (F31) |
| Endogenous | $R^b$ / `R_b` | wholesale loan rate | (F17), (F18) |
| Endogenous | $lev$ / `lev` | bank leverage | (F31) |
| Endogenous | $rr$ / `rr` | real-rate diagnostic | (F32) |
| Endogenous | $Y1$ / `Y1` | auxiliary output aggregate in MMB policy rule | (F30) |
| Endogenous | $mk^y$ / `mk_y` | goods markup / cost-push state | (F15), (F35) |
| Endogenous | $A^E$ / `A_e` | technology state | (F10), (F12), (F34) |
| Exogenous | `e_A_e` | technology innovation | (F34) |
| Exogenous | `e_mk_y` | markup/cost-push innovation | (F35) |
| Parameter | $\beta_P,\beta_E$ / `beta_p`, `beta_e` | discount factors | (F2), (F7), (F8), (F14), (F15) |
| Parameter | $\phi$ / `phi` | inverse Frisch elasticity | (F3) |
| Parameter | $m^E$ / `m_e_ss` | entrepreneur loan-to-value ratio | (F7), (F11) |
| Parameter | $\gamma_p,\gamma_e$ / `gamma_p`, `gamma_e` | population/aggregation weights | (F4), (F22)-(F28) |
| Parameter | $\theta,\nu,\overline{\mu}^b,\delta^b$ / `theta`, `vi`, `mcspread`, `delta_b` | banking spread, target capital ratio, markup, bank capital cost | (F17)-(F21) |
| Parameter | $\xi,\kappa_p,\kappa^i,\delta^k,\pi^{ss},mk^y$ / `ksi`, `kappa_p`, `kappa_i`, `deltak`, `piss`, `mk_y_ss` | production, price, investment, and steady-state markup parameters | (F10), (F13)-(F16), (F29), (F35) |
| Parameter | $\rho^{ib},\phi_\pi,\phi_y,\phi_q,\phi_B$ / `rho_ib`, `phi_pie`, `phi_y`, `phi_AP`, `phi_B` | monetary-policy rule coefficients | (F33) |
| Parameter | $\rho_A,\rho_{mk}$ / `rho_A_e`, `rho_mk_y` | shock persistence | (F34), (F35) |
