# NK_CW09 - Credit Frictions and Optimal Monetary Policy Derivation

> Status: `needs_review`. This first-pass archive entry is extracted from the MinerU Markdown of Curdia and Woodford (2009), with the MMB replication file used only as an implementation cross-check. Runtime validation was not performed.

Source: Vasco Curdia and Michael Woodford, "Credit frictions and optimal monetary policy", BIS Working Paper No. 278, 2009, DOI `10.2139/ssrn.1440289`.

## 1. Model Overview

- **Model**: `NK_CW09`, a cashless New Keynesian model with heterogeneous households, financial intermediation, and a spread between deposit and borrowing rates.
- **Agents**: households that switch between borrower (`b`) and saver (`s`) types, competitive financial intermediaries, monopolistically competitive goods producers with Calvo pricing, a fiscal authority, and a monetary authority.
- **Core friction**: borrowers pay the loan rate \(i_t^b\), savers receive the deposit/policy rate \(i_t^d\), and the spread reflects intermediation resource costs and possibly an intermediation markup.
- **Form**: the paper presents a nonlinear equilibrium and then log-linearizes around a zero-inflation steady state. The MMB implementation is a nonlinear level system plus auxiliary log-deviation definitions, solved at first order; this derivation records both the nonlinear structural equations and the log-linear policy block where the source emphasizes it.
- **Provenance**: primary Markdown `raw/mmb_mineru/runs/nk_cw09__credit_frictions_and_optimal_monetary_policy__763a743f/full.md`; raw PDF `raw/mmb_papers/Credit frictions and optimal monetary policy 2009.pdf`; MinerU run IDs `763a743f-88d3-48b0-a1c5-d85aa1904cdd` and `8a203c25-5728-480d-b422-aa5185c8e7af`.

## 2. Optimization Problems

### 2.1 Households

Household \(i\) maximizes expected discounted utility with type-dependent consumption utility and common labor disutility:

\[
E_0\sum_{t=0}^{\infty}\beta^t\left[
u^{\tau_t(i)}(\mathbf{c}_t(i);\xi_t)
-\int_0^1 v(h_t(j;i);\xi_t)\,dj
\right].
\]

The type \(\tau_t(i)\in\{b,s\}\) follows a two-state Markov process. With probability \(1-\delta\) a new type is drawn, with probabilities \(\pi_b\) and \(\pi_s\); otherwise the household keeps its previous type. Type `b` households have higher current marginal utility of consumption over the relevant range than type `s` households.

Beginning-of-period nominal wealth and end-of-period nominal wealth are:

\[
A_t(i)=[B_{t-1}(i)]^+(1+i_{t-1}^d)+[B_{t-1}(i)]^-(1+i_{t-1}^b)+D_t^{int}+T_t(i),
\]

\[
B_t(i)=A_t(i)-P_tc_t(i)+\int W_t(j)h_t(j;i)\,dj+D_t+T_t^g.
\]

### 2.2 Financial Intermediaries

Intermediaries transform deposits into loans using a reduced-form technology:

\[
d_t=b_t+\Xi_t(b_t),
\]

where \(\Xi_t(0)=0\), \(\Xi_t'(b)\ge 0\), and \(\Xi_t''(b)\ge 0\). Competitive intermediation with possible markup \(\mu_t^b(b_t)\) implies a wedge between the lending and deposit rates:

\[
1+i_t^b=(1+i_t^d)(1+\omega_t),\qquad
1+\omega_t=\mu_t^b(b_t)\left[1+\Xi_t'(b_t)\right].
\]

### 2.3 Labor Supply and Goods Producers

Households supply differentiated labor types. With the isoelastic labor disutility

\[
v(h;\xi_t)=\frac{1}{1+\nu}h^{1+\nu}\bar{H}_t^{-\nu},
\]

aggregate labor supply can be summarized by the marginal-utility aggregator

\[
\tilde{\lambda}_t=\left[\pi_b(\lambda_t^b)^{1/\nu}+\pi_s(\lambda_t^s)^{1/\nu}\right]^\nu.
\]

Goods producers use isoelastic production \(y_t(i)=A_t h_t(i)^{1/\phi}\) and Calvo price setting. Price dispersion \(\Delta_t\) affects aggregate labor demand and evolves with inflation.

## 3. First-Order Conditions

- **(F1) Borrower Euler equation**:

\[
\lambda_t^b=\beta E_t\left[
\frac{1+i_t^b}{\Pi_{t+1}}
\left\{[\delta+(1-\delta)\pi_b]\lambda_{t+1}^b+(1-\delta)\pi_s\lambda_{t+1}^s\right\}
\right].
\]

- **(F2) Saver Euler equation**:

\[
\lambda_t^s=\beta E_t\left[
\frac{1+i_t^d}{\Pi_{t+1}}
\left\{(1-\delta)\pi_b\lambda_{t+1}^b+[\delta+(1-\delta)\pi_s]\lambda_{t+1}^s\right\}
\right].
\]

- **(F3) Consumption demand by type**:

\[
c_t^b=c^b(\lambda_t^b;\xi_t),\qquad
c_t^s=c^s(\lambda_t^s;\xi_t).
\]

- **(F4) Labor supply wage schedule**:

\[
\frac{W_t(j)}{P_t}=\mu_t^w\tilde{\lambda}_t^{-1}\left(\frac{h_t(j)}{\bar{H}_t}\right)^\nu.
\]

- **(F5) Marginal utility aggregator**:

\[
\tilde{\lambda}_t=\left[\pi_b(\lambda_t^b)^{1/\nu}+\pi_s(\lambda_t^s)^{1/\nu}\right]^\nu.
\]

- **(F6) Total wage bill**:

\[
\int W_t(j)h_t(j)\,dj
=\mu_t^w\frac{P_t}{\tilde{\lambda}_t\bar{H}_t^\nu}
\left(\frac{Y_t}{A_t}\right)^{1+\omega_y}\Delta_t,
\qquad \omega_y=\phi(1+\nu)-1.
\]

- **(F7) New Keynesian price-setting block** (`needs_review`: source states recursive functions \(G\) and \(g\) are in the Appendix, not fully expanded in the extracted Markdown):

\[
\Pi_t=\Pi(Z_t),\qquad
Z_t=G(Y_t,\lambda_t^b,\lambda_t^s;\tilde{\xi}_t)+E_t[g(\Pi_{t+1},Z_{t+1})].
\]

- **(F8) Log-linear borrower marginal utility equation**:

\[
\hat{\lambda}_t^b=\hat{i}_t^b-E_t\pi_{t+1}
+[\delta+(1-\delta)\pi_b]E_t\hat{\lambda}_{t+1}^b
+(1-\delta)\pi_sE_t\hat{\lambda}_{t+1}^s.
\]

- **(F9) Log-linear saver marginal utility equation**:

\[
\hat{\lambda}_t^s=\hat{i}_t^d-E_t\pi_{t+1}
+(1-\delta)\pi_bE_t\hat{\lambda}_{t+1}^b
+[\delta+(1-\delta)\pi_s]E_t\hat{\lambda}_{t+1}^s.
\]

- **(F10) Average marginal utility relation**:

\[
\hat{\lambda}_t=\hat{i}_t^{avg}-E_t\pi_{t+1}+E_t\hat{\lambda}_{t+1},
\qquad
\hat{i}_t^{avg}\equiv\pi_b\hat{i}_t^b+\pi_s\hat{i}_t^d.
\]

- **(F11) Marginal-utility gap relation**:

\[
\hat{\Omega}_t=\hat{\omega}_t+\delta E_t\hat{\Omega}_{t+1},
\qquad
\hat{\Omega}_t\equiv\hat{\lambda}_t^b-\hat{\lambda}_t^s.
\]

- **(F12) Intertemporal IS relation** (`needs_review`: OCR corrupts some rate hats in the source, but the displayed relation and implementation agree on the average-rate object):

\[
\hat{Y}_t=-\bar{\sigma}(\hat{i}_t^{avg}-E_t\pi_{t+1})
+E_t\hat{Y}_{t+1}
-E_t\left[\Delta g_{t+1}+\Delta\hat{\Xi}_{t+1}
-\bar{\sigma}s_\Omega\Delta\hat{\Omega}_{t+1}\right].
\]

- **(F13) New Keynesian Phillips curve with credit-friction terms**:

\[
\pi_t=\kappa(\hat{Y}_t-\hat{Y}_t^n)+u_t
+\xi(s_\Omega+\pi_b-\gamma_b)\hat{\Omega}_t
-\xi\bar{\sigma}^{-1}\hat{\Xi}_t
+\beta E_t\pi_{t+1}.
\]

## 4. Market Clearing & Identities

- **(F14) Goods market clearing**:

\[
Y_t=\pi_b c^b(\lambda_t^b;\xi_t)+\pi_s c^s(\lambda_t^s;\xi_t)+G_t+\Xi_t(b_t).
\]

- **(F15) Government debt law of motion**:

\[
b_t^g=b_{t-1}^g\frac{1+i_{t-1}^d}{\Pi_t}+G_t+\frac{T_t^g}{P_t}-\tau_tY_t.
\]

- **(F16) Financial intermediation spread identity**:

\[
1+i_t^b=(1+i_t^d)(1+\omega_t),\qquad
1+\omega_t=\mu_t^b(b_t)\left[1+\Xi_t'(b_t)\right].
\]

- **(F17) Aggregate private debt law of motion** (`needs_review`: retained from the paper's displayed aggregate equation; check Appendix if a runnable model requires the full \(B(\cdot)\) definition):

\[
\begin{aligned}
b_t={}&\delta\left[b_{t-1}+\pi_s\omega_{t-1}(b_{t-1})b_{t-1}
+\pi_b\Xi_{t-1}(b_{t-1})\right]\frac{1+i_{t-1}^d}{\Pi_t}
-\pi_b\Xi_t(b_t)\\
&+\pi_b\left[\delta b_{t-1}^g\frac{1+i_{t-1}^d}{\Pi_t}-b_t^g\right]
+\pi_b\pi_sB(Y_t,\lambda_t^b,\lambda_t^s,\Delta_t;\tilde{\xi}_t).
\end{aligned}
\]

- **(F18) Price dispersion law of motion** (`needs_review`: source delegates the function \(h\) to the Appendix):

\[
\Delta_t=h(\Delta_{t-1},\Pi_t).
\]

## 5. Exogenous Processes

- **(F19) Generic AR(1) disturbance processes used in the MMB cross-check**:

\[
x_t=(1-\rho_x)\bar{x}+\rho_x x_{t-1}+\varepsilon_t^x,
\qquad
x\in\{\bar{C}^b,\bar{C}^s,G,\bar{H},\mu^w,\tau,\epsilon^m,\tilde{\Xi},\tilde{\chi},Z,b^g\}.
\]

- **(F20) Taylor rule for the deposit/policy rate and optional spread adjustment**:

\[
\hat{i}_t^d=\phi_\pi\pi_t+\phi_y\hat{Y}_t+\epsilon_t^m
\quad\text{or}\quad
\hat{i}_t^d=\phi_\pi\pi_t+\phi_y\hat{Y}_t-\phi_\omega\hat{\omega}_t.
\]

The paper also emphasizes the identity

\[
\hat{i}_t^{avg}=\hat{i}_t^d+\pi_b\hat{\omega}_t,
\]

so policy-rate movements must be interpreted through the average interest rate relevant for aggregate demand.

## 6. Steady-State Solution

The paper log-linearizes around a deterministic zero-inflation steady state. The full nonlinear steady state is not completely expanded in the main text, and several calibration formulas used by the MMB replication are implementation evidence rather than paper-side derivation evidence. First-pass status for this section is therefore `needs_review`.

Steady-state restrictions recorded from the source and implementation cross-check:

1. Set \(\Pi=1\), exogenous innovations to zero, and normalize output/productivity objects as in the implementation cross-check: \(\bar{Y}=1\), \(\bar{Z}=1\), \(\bar{\Delta}=1\).
2. Choose household type shares \(\pi_b=\pi_s=0.5\) in the calibration.
3. Choose type persistence \(\delta=0.975\).
4. Set the deposit rate steady state \(\bar{i}^d\) and the annualized spread target; the paper's calibration uses a 2 percentage point annual steady-state spread.
5. Choose \(\bar{b}/\bar{Y}\) and calibrate the intermediation function. For the convex case, \(\Xi(b)=\tilde{\Xi}b^\eta\).
6. Solve the type Euler equations (F1)-(F2) jointly for steady-state marginal utilities \(\bar{\lambda}^b,\bar{\lambda}^s\) and the marginal-utility gap implied by the spread.
7. Use type consumption demand (F3), aggregate demand (F14), and government spending to recover \(\bar{c}^b,\bar{c}^s,\bar{G}\).
8. Use the labor-supply aggregator (F5), wage schedule (F4), and goods pricing block (F7)/(F18) to recover \(\bar{\tilde{\lambda}}\), wage costs, and steady-state price-dispersion objects.

The MMB implementation cross-check defines steady-state constants such as `lambda_b_bar`, `lambda_s_bar`, `lambda_tilde_bar`, `Lambda_bar`, `K_bar`, `F_bar`, `B_bar`, and `Xi_tilde_bar`. These are useful for a future runnable validation pass, but they should be checked against the paper Appendix before being promoted as source-stated derivations.

## 7. Timing & Form Conventions

- The structural paper model is nonlinear; Section 2 uses log-linearized equilibrium relations around \(\bar{\Pi}=1\).
- Deposits and loans are one-period nominal contracts chosen at the end of period \(t\) and repaid at the beginning of \(t+1\).
- \(i_t^d\) is the saver/deposit rate and policy-rate object in the basic setup; \(i_t^b\) is the borrower/lending rate.
- \(b_t\) is end-of-period real borrowing from intermediaries; \(b_t^g\) is real government debt.
- \(\Delta_t\) is a stock-like price dispersion object with dependence on \(\Delta_{t-1}\).
- The MMB replication uses level variables and separate hat variables for log deviations/annualizations. This is an implementation convention, not a paper-side requirement.
- Runtime validation was not performed.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Main equation |
|---|---|---|---|
| Endogenous | \(\lambda_t^b\) / `lambda_b` | borrower marginal utility of income | (F1), (F8) |
| Endogenous | \(\lambda_t^s\) / `lambda_s` | saver marginal utility of income | (F2), (F9) |
| Endogenous | \(c_t^b,c_t^s\) / `C_bar_b`, `C_bar_s` | type-specific consumption demand | (F3), (F14) |
| Endogenous | \(\tilde{\lambda}_t\) / `lambda_tilde` | labor-supply marginal-utility aggregator | (F5) |
| Endogenous | \(\Lambda_t\) / `Lambda` | average marginal utility aggregator in implementation | (F10) |
| Endogenous | \(Y_t\) / `Y` | aggregate output | (F12), (F14) |
| Endogenous | \(\Pi_t\) / `Pi` | gross inflation | (F7), (F13) |
| Endogenous | \(i_t^d\) / `i_d` | deposit/policy rate | (F2), (F16), (F20) |
| Endogenous | \(i_t^b\) / `i_b_hat` | borrower loan-rate object/spread-adjusted rate | (F1), (F16) |
| Endogenous | \(\omega_t\) / `omega` | credit spread | (F11), (F16) |
| Endogenous | \(b_t\) / `b` | private borrowing/intermediated credit | (F17) |
| Endogenous | \(b_t^g\) / `b_g` | government debt | (F15), (F19) |
| Endogenous | \(\Delta_t\) / `Delta` | price dispersion | (F18) |
| Endogenous | \(Z_t\) / `Z` | productivity or Calvo auxiliary context depending on notation | (F7), (F19) |
| Endogenous | \(K_t,F_t\) / `K`, `F` | Calvo recursive auxiliary variables in implementation | (F7) |
| Exogenous | \(\epsilon_t^m\) / `e_epsilon_m` | monetary policy disturbance | (F19), (F20) |
| Exogenous | \(\varepsilon_t^x\) | shocks to taste, government spending, labor supply, markups, productivity, financial frictions, debt | (F19) |
| Parameter | \(\beta\) / `beta` | discount factor | (F1), (F2), (F13) |
| Parameter | \(\delta\) / `delta` | type persistence probability | (F1), (F2), (F11), (F17) |
| Parameter | \(\pi_b,\pi_s\) / `pi_b`, `pi_s` | type shares | (F1)-(F5), (F10), (F14), (F17) |
| Parameter | \(\nu\) / `nu` | inverse labor-supply elasticity parameter | (F4)-(F6) |
| Parameter | \(\phi,\omega_y\) / `phi`, `omega_y` | production curvature and induced marginal-cost elasticity | (F6), (F13) |
| Parameter | \(\theta,\alpha\) / `theta`, `alpha` | demand elasticity / Calvo price stickiness notation | (F7), (F13), (F18) |
| Parameter | \(\mu_t^w,\mu_t^b\) / `mu_w`, financial markup | labor and intermediation markups | (F4), (F16), (F19) |
| Parameter | \(\Xi_t,\tilde{\Xi},\eta\) / `Xi_tilde` | intermediation resource cost function | (F12), (F14), (F16), (F17), (F19) |
| Parameter | \(\phi_\pi,\phi_y,\phi_\omega\) / `phi_pi`, `phi_y` | policy rule coefficients | (F20) |
