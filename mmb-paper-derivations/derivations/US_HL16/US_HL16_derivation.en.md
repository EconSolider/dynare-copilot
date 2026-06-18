# US_HL16 -- Derivation (Optimization Problems + First-Order Conditions)

> First-pass archive extraction. Status: `needs_review`. Runtime validation: not performed.

Provenance: `US_HL16`, Hollander and Liu (2016), "The equity price channel in a New-Keynesian DSGE model with financial frictions and banking", DOI `10.1016/j.econmod.2015.09.015`. Source Markdown: `raw/mmb_mineru/runs/us_hl16__the_equity_price_channel_in_a_new_keynesian_dsge_model_with_financial_fr__e3259b88/full.md`. Raw PDF: `raw/mmb_papers/The equity price channel in a New-Keynesian DSGE model with financial frictions and banking.pdf`. MinerU run id: `e3259b88-d1fa-4daa-af29-40e129c1367e`.

## 1. Model Overview

- **Model**: U.S. medium-scale New-Keynesian DSGE model with heterogeneous households, equity demand, financial frictions, and bank capital.
- **Paper setting**: Bayesian estimation with U.S. quarterly data, 1982Q01-2015Q01.
- **Agents**: saver households, borrower households, entrepreneurs, monopolistically competitive retailers, banks with wholesale/deposit/loan branches, and a monetary authority.
- **Equity price channel**: equity prices enter household wealth, borrower and entrepreneur collateral values, and bank capital accumulation.
- **Model form**: the paper gives nonlinear equilibrium conditions in Appendix A; the Rep-MMB implementation cross-check uses `model(linear)`. This archive entry records the nonlinear paper-side equations and notes the linear MMB implementation as `implementation_cross_check`.
- **First-pass status**: `needs_review` because Appendix A has OCR corruption in several equations and no Dynare runtime validation was requested or performed.

## 2. Optimization Problems

### 2.1 Households

There are saver (`s`) and borrower (`b`) households. For type $\Gamma \in \{b,s\}$, the lifetime objective is:

**(F1) Household utility objective**

$$
E_0 \sum_{t=0}^{\infty} \beta_\Gamma^t
\left[
\frac{(C_t^\Gamma-\phi C_{t-1}^\Gamma)^{1-\gamma^\Gamma}}{1-\gamma^\Gamma}
- \frac{(H_t^\Gamma)^{1+\eta}}{1+\eta}
+ a \ln\left(\frac{D_t^\Gamma}{P_t}\right)
+ \xi_{\psi,t}\ln\left(\frac{Q_t^\psi\Psi_t^\Gamma}{P_t}\right)
\right].
$$

Here $a=1$ for savers and $a=0$ for borrowers.

### 2.2 Savers

Savers choose consumption, deposits, labor, and equity holdings subject to:

**(F2) Saver budget constraint**

$$
C_t^s+\frac{D_t^s}{P_t}+\frac{Q_t^\psi}{P_t}\Psi_t^s
=
\frac{W_t}{P_t}H_t^s+\frac{I_{t-1}^dD_{t-1}^s}{P_t}
+\frac{Q_t^\psi+\Pi_{\psi,t}}{P_t}\Psi_{t-1}^s.
$$

### 2.3 Borrowers

Borrowers choose consumption, labor, household loans, and equity holdings subject to:

**(F3) Borrower budget constraint**

$$
C_t^b+\frac{I_{t-1}^hL_{t-1}^h}{P_t}+\frac{Q_t^\psi}{P_t}\Psi_t^b
=
\frac{W_t}{P_t}H_t^b+\frac{L_t^h}{P_t}
+\frac{Q_t^\psi+\Pi_{\psi,t}}{P_t}\Psi_{t-1}^b.
$$

**(F4) Borrower binding collateral constraint**

$$
I_t^hL_t^h
=
\nu_{h,t}\left[
\phi_w W_{t+1}H_t^b
+(1-\phi_w)(Q_{t+1}^\psi+\Pi_{\psi,t+1})\Psi_t^b
\right].
$$

### 2.4 Retailers

Retailers set prices under Calvo rigidity. A re-optimizing retailer chooses $P_{k,t}^{\ast}$:

**(F5) Retailer Calvo pricing problem**

$$
\max_{\{P_{k,t}^{\ast}\}} E_t\sum_{z=0}^{\infty}\theta_R^z\Lambda_{t,z}
\left[P_{k,t}^{\ast}Y_{k,t+z}-P_{j,t+z}^WXY_{k,t+z}\right],
$$

subject to:

**(F6) Demand for a differentiated retail good**

$$
Y_{k,t+z}
=
\left(\frac{P_{k,t}^{\ast}}{P_{t+z}}\right)^{-\varepsilon_t^p}Y_{t+z}.
$$

### 2.5 Entrepreneurs

Entrepreneurs produce wholesale goods and choose capital, loans, and labor:

**(F7) Entrepreneur objective**

$$
E_0\sum_{t=0}^{\infty}\beta_e^t\Omega_{j,t}^e.
$$

**(F8) Entrepreneur production technology**

$$
Y_{j,t}=\xi_{z,t}K_{j,t-1}^{\alpha}H_{j,t}^{1-\alpha}.
$$

**(F9) Entrepreneur flow of funds**

$$
\Omega_{j,t}^e
=
\frac{Y_{j,t}}{X_{j,t}}+\frac{L_{j,t}^e}{P_t}
-\frac{I_{j,t-1}^eL_{j,t-1}^e}{P_t}
-\frac{W_t}{P_t}H_{j,t}
-\left(K_{j,t}-(1-\delta_e)K_{j,t-1}\right)
-Adj_{j,t}^e-\Pi_{\psi,jt}^e.
$$

**(F10) Capital installation cost**

$$
Adj_{j,t}^e
=
\kappa_v\left(\frac{V_{j,t}}{K_{j,t-1}}-\delta_e\right)^2
\frac{K_{j,t-1}}{2\delta_e}.
$$

**(F11) Entrepreneur binding borrowing constraint**

$$
I_{j,t}^eL_{j,t}^e
=
\nu_{e,jt}\left[
\phi_kQ_{j,t+1}^kK_{j,t}
+(1-\phi_k)Q_{j,t+1}^{\psi}\Psi_j^e
\right].
$$

### 2.6 Banks

The wholesale branch chooses loans and deposits:

**(F12) Wholesale bank objective**

$$
E_0\sum_{t=0}^{\infty}\beta_B^t
\left[
i_t^lL_t-i_t^dD_t
-\frac{\kappa_k}{2}\left(\frac{K_t^B}{L_t}-\tau\right)^2K_t^B
\right],
$$

subject to:

**(F13) Bank balance sheet**

$$
L_t=K_t^B+D_t.
$$

Retail loan branches choose household and entrepreneur loan rates:

**(F14) Retail loan branch objective**

$$
\max_{\{i_t^h,i_t^e\}} E_0\sum_{t=0}^{\infty}\beta_B^t
\left[
i_t^hL_t^h+i_t^eL_t^e-i_t^lL_t
-\frac{\kappa_h}{2}\left(\frac{i_t^h}{i_{t-1}^h}-1\right)^2i_t^hL_t^h
-\frac{\kappa_e}{2}\left(\frac{i_t^e}{i_{t-1}^e}-1\right)^2i_t^eL_t^e
\right].
$$

## 3. First-Order Conditions

Let $\tilde C_t^\Gamma=C_t^\Gamma-\phi C_{t-1}^\Gamma$ and $U_{c,t}^\Gamma=(\tilde C_t^\Gamma)^{-\gamma^\Gamma}$.

**(F15) Saver deposit demand**

$$
\frac{P_t}{D_t^s}
=
U_{c,t}^s-\beta_sE_t\left[
U_{c,t+1}^s\frac{I_t^d}{P_{t+1}/P_t}
\right].
$$

**(F16) Saver labor supply**

$$
\frac{W_t}{P_t}=\frac{(H_t^s)^\eta}{U_{c,t}^s}.
$$

**(F17) Saver equity demand**

$$
\xi_{\psi,t}\frac{P_t}{Q_t^\psi\Psi_t^s}
=
U_{c,t}^s-\beta_sE_t\left[
U_{c,t+1}^s
\left(\frac{Q_{t+1}^{\psi}+\Pi_{\psi,t+1}}{Q_t^\psi}\right)
\frac{P_t}{P_{t+1}}
\right].
$$

**(F18) Saver consumption-based equity pricing relation**

$$
1=
\beta_sE_t\left[
\frac{U_{c,t}^s}{U_{c,t+1}^s}
\left(\frac{Q_{t+1}^{\psi}+\Pi_{\psi,t+1}}{Q_t^\psi}\right)
\frac{P_t}{P_{t+1}}
\right].
$$

**(F19) Borrower labor supply**

$$
(H_t^b)^\eta
=
U_{c,t}^b\frac{W_t}{P_t}
+\lambda_t^h\nu_{h,t}\phi_wE_t\left[\frac{W_{t+1}}{P_t}\right].
$$

**(F20) Borrower consumption Euler equation**

$$
U_{c,t}^b
=
\beta_bE_t\left[
U_{c,t+1}^b\frac{I_t^h}{P_{t+1}/P_t}
\right]+\lambda_t^hI_t^h.
$$

**(F21) Borrower equity demand**

$$
\xi_{\psi,t}\frac{P_t}{Q_t^\psi\Psi_t^b}
=
U_{c,t}^b
-E_t\left[
\beta_bU_{c,t+1}^b
\frac{R_{t+1}^{\psi}}{P_{t+1}/P_t}
+\lambda_t^h\nu_{h,t}(1-\phi_w)
\frac{R_{t+1}^{\psi}}{P_{t+1}/P_t}
\right].
$$

**(F22) Retail price index**

$$
P_t^{1-\varepsilon_t^p}
=
\theta_R
\left[\left(\frac{P_{t-1}}{P_{t-2}}\right)^{\gamma_p}P_{t-1}\right]^{1-\varepsilon_t^p}
+(1-\theta_R)(P_t^{\ast})^{1-\varepsilon_t^p}.
$$

**(F23) Retailer optimal reset price, needs_review**

$$
\frac{P_t^{\ast}}{P_t}
=
\left(\frac{\varepsilon_t^p}{\varepsilon_t^p-1}\right)
\frac{
E_t\sum_{z=0}^{\infty}\theta_R^z\Lambda_{t,z}
\left[\frac{X}{X_{t+z}}\left(\frac{P_{t+z}}{P_t}\right)^{\varepsilon_t^p}Y_{t+z}\right]
}{
E_t\sum_{z=0}^{\infty}\theta_R^z\Lambda_{t,z}
\left[\left(\frac{P_{t+z}}{P_t}\right)^{\varepsilon_t^p-1}Y_{t+z}\right]
}.
$$

**(F24) Entrepreneur labor demand**

$$
\frac{W_t}{P_t}=\frac{(1-\alpha)Y_{j,t}}{H_{j,t}X_{j,t}}.
$$

**(F25) Entrepreneur loan Euler equation**

$$
\lambda_{j,t}^e
=
\frac{1}{I_{j,t}^e}
-\beta_eE_t\left[\frac{P_t}{P_{t+1}}\right].
$$

**(F26) Entrepreneur capital demand, needs_review**

$$
\frac{Q_{j,t}^k}{P_t}
=
\beta_eE_t\left[
\frac{\kappa_v}{\delta_e}
\left(\frac{V_{j,t+1}}{K_{j,t}}-\delta_e\right)
\frac{V_{j,t+1}}{K_{j,t}}
-\frac{\kappa_v}{2\delta_e}
\left(\frac{V_{j,t+1}}{K_{j,t}}-\delta_e\right)^2
+\frac{Q_{j,t+1}^k}{P_{t+1}}(1-\delta_e)
+\frac{\alpha Y_{j,t+1}}{X_{j,t+1}K_{j,t}}
+\lambda_{j,t}^e\nu_{e,jt}\phi_k\frac{Q_{j,t+1}^k}{P_{t+1}}
\right].
$$

**(F27) Wholesale loan-deposit spread**

$$
i_t^l
=
i_t^d-\kappa_k\left(\frac{K_t^B}{L_t}-\tau\right)
\left(\frac{K_t^B}{L_t}\right)^2.
$$

**(F28) Entrepreneur retail loan-rate setting, needs_review**

$$
0=
1-\varepsilon_t^e+\varepsilon_t^e\frac{i_t^l}{i_t^e}
-\kappa_e\left(\frac{i_t^e}{i_{t-1}^e}-1\right)\frac{i_t^e}{i_{t-1}^e}
+\beta_BE_t\left[
\kappa_e\left(\frac{i_{t+1}^e}{i_t^e}-1\right)
\left(\frac{i_{t+1}^e}{i_t^e}\right)^2
\frac{L_{t+1}^e}{L_t^e}
\right].
$$

**(F29) Household retail loan-rate setting, needs_review**

$$
0=
1-\varepsilon_t^h+\varepsilon_t^h\frac{i_t^l}{i_t^h}
-\kappa_h\left(\frac{i_t^h}{i_{t-1}^h}-1\right)\frac{i_t^h}{i_{t-1}^h}
+\beta_BE_t\left[
\kappa_h\left(\frac{i_{t+1}^h}{i_t^h}-1\right)
\left(\frac{i_{t+1}^h}{i_t^h}\right)^2
\frac{L_{t+1}^h}{L_t^h}
\right].
$$

## 4. Market Clearing & Identities

**(F30) Aggregate production**

$$
Y_t=\xi_{z,t}K_{t-1}^{\alpha}H_t^{1-\alpha}.
$$

**(F31) Aggregate resource constraint**

$$
Y_t=C_t+V_t+\delta_B\frac{K_{t-1}^B}{\Pi_t}.
$$

**(F32) Equity market clearing**

$$
\Psi_t^s+\Psi_t^b=\Psi^B+\Psi^e.
$$

**(F33) Aggregate consumption**

$$
C_t=C_t^s+C_t^b.
$$

**(F34) Aggregate loans**

$$
L_t=L_t^h+L_t^e.
$$

**(F35) Aggregate labor, needs_review**

$$
H_t=H_t^h+H_t^e.
$$

The Appendix states $H_t^h+H_t^e$ although the main text uses saver and borrower household labor plus entrepreneur labor demand. This aggregation should be checked against the PDF and implementation.

**(F36) Capital accumulation**

$$
K_t=(1-\delta_e)K_{t-1}+V_t.
$$

**(F37) Capital shadow price, needs_review**

$$
\frac{Q_t^k}{P_t}
=
1+\frac{\kappa_v}{\delta_e}\left(\frac{V_t}{K_{t-1}}-\delta_e\right).
$$

**(F38) Equity dividend from entrepreneurs**

$$
\Pi_{\psi,t}^e=r^\psi Q_t^\psi\Psi^e.
$$

**(F39) Equity dividend from banks**

$$
\Pi_t^{\psi B}=\phi_\psi\omega_{B,t}.
$$

**(F40) Aggregate equity dividend, needs_review**

$$
\Pi_t^\psi=\frac{\Pi_t^{\psi e}}{\Psi^e}+\frac{\Pi_t^{\psi B}}{\Psi^B}.
$$

**(F41) Household borrowing constraint in equality form**

$$
L_t^h
=
\frac{\nu_{h,t}}{I_t^h}
\left[
\phi_wW_{t+1}H_t^b
+(1-\phi_w)(Q_{t+1}^{\psi}+\Pi_{t+1}^{\psi})\Psi_t^b
\right].
$$

**(F42) Entrepreneur borrowing constraint in equality form**

$$
L_t^e
=
\frac{\nu_{e,t}}{I_t^e}
\left[
\phi_kQ_{t+1}^kK_t
+(1-\phi_k)Q_{t+1}^{\psi}\Psi^e
\right].
$$

**(F43) Bank capital accumulation**

$$
K_t^B
=
(1-\delta_B)K_{t-1}^B
+\phi_B(Q_t^\psi-Q_{t-1}^{\psi})\Psi^B
+(1-\phi_\psi)\omega_{B,t-1}.
$$

**(F44) Bank balance sheet identity**

$$
L_t=K_t^B+D_t.
$$

**(F45) Saver flow of funds**

$$
C_t^s
=
\frac{W_t}{P_t}H_t^s+\frac{I_{t-1}^dD_{t-1}^s}{P_t}
+\frac{Q_t^\psi+\Pi_{\psi,t}}{P_t}\Psi_{t-1}^s
-\frac{D_t^s}{P_t}
-\frac{Q_t^\psi}{P_t}\Psi_t^s.
$$

**(F46) Bank profits**

$$
\begin{aligned}
\omega_{B,t}={}&i_t^hL_t^h+i_t^eL_t^e-i_t^dD_t
-\frac{\kappa_K}{2}\left(\frac{K_t^B}{L_t}-\tau\right)^2K_t^B \\
&-\frac{\kappa_h}{2}\left(\frac{i_t^h}{i_{t-1}^h}-1\right)^2i_t^hL_t^h
-\frac{\kappa_e}{2}\left(\frac{i_t^e}{i_{t-1}^e}-1\right)^2i_t^eL_t^e
-\Pi_t^{\psi B}.
\end{aligned}
$$

**(F47) Monetary policy rule**

$$
I_t
=
(I_{t-1})^{\kappa_i}
\left(\frac{\Pi_t}{\Pi^{target}}\right)^{\kappa_\pi(1-\kappa_i)}
\left(\frac{Y_t}{Y_{t-1}}\right)^{\kappa_y(1-\kappa_i)}
\xi_{i,t}.
$$

The paper's main text writes the policy shock multiplicatively; the MMB implementation cross-check log-linearizes it additively.

## 5. Exogenous Processes

**(F48) Price markup process**

$$
\varepsilon_t^p=\rho_p\varepsilon_{t-1}^p+\epsilon_{p,t}.
$$

**(F49) Technology process**

$$
\xi_{z,t}=\rho_z\xi_{z,t-1}+\epsilon_{z,t}.
$$

**(F50) Monetary policy shock process, needs_review**

$$
\xi_{i,t}=\rho_i\xi_{i,t-1}+\epsilon_{i,t}.
$$

Appendix A OCR shows $\rho_z$ in this equation; the model text and implementation indicate $\rho_i$.

**(F51) Deposit shock process**

$$
\xi_{d,t}=\rho_d\xi_{d,t-1}+\epsilon_{d,t}.
$$

**(F52) Household loan-markup process**

$$
\varepsilon_t^h=\rho_h\varepsilon_{t-1}^h+\epsilon_{h,t}.
$$

**(F53) Entrepreneur loan-markup process**

$$
\varepsilon_t^e=\rho_e\varepsilon_{t-1}^e+\epsilon_{e,t}.
$$

**(F54) Household LTV process**

$$
\nu_{h,t}=\rho_{\nu h}\nu_{h,t-1}+\epsilon_{\nu h,t}.
$$

**(F55) Entrepreneur LTV process**

$$
\nu_{e,t}=\rho_{\nu e}\nu_{e,t-1}+\epsilon_{\nu e,t}.
$$

**(F56) Equity demand shock process**

$$
\xi_{\psi,t}=\rho_{\psi}\xi_{\psi,t-1}+\epsilon_{\psi,t}.
$$

## 6. Steady-State Solution

The paper estimates a linearized model and provides calibrated steady-state ratios rather than a full closed-form nonlinear steady-state algorithm. The Rep-MMB implementation cross-check uses `model(linear)` with zero steady states for the transformed model variables and measurement equations with observed steady-state offsets.

For source-backed nonlinear restrictions:

1. Set all AR(1) innovations to zero and hold exogenous processes at their deterministic means.
2. Use calibrated steady-state gross rates and ratios from Table 1: $\beta_s=0.99$, $\beta_b=0.96$, $\beta_e=0.95$, $\alpha=0.33$, $\delta_e=0.025$, $\varepsilon^p=11$, $R^\psi=1.035$, $\tau=0.11$, $L^h/L=0.45$, $L^e/L=0.55$, $L/Y=1.5$, $C/Y=0.653$, and $Q^\psi\Psi/Y=0.816$.
3. Use the balance-sheet identities $L=K^B+D$, $L=L^h+L^e$, and aggregate constraints to pin down ratios.
4. Use the implementation cross-check steady-state offsets for observables only as implementation evidence: `pi_ss`, `i_h_ss`, `i_e_ss`, and `i_d_ss`.

`needs_review`: a complete nonlinear steady-state sequence suitable for a future `steady_state_model` was not source-verified in this first pass.

## 7. Timing & Form Conventions

- **Capital timing**: $K_t$ is end-of-period physical capital; production uses $K_{t-1}$.
- **Bank capital timing**: $K_t^B$ depends on $K_{t-1}^B$, changes in equity prices from $t-1$ to $t$, and lagged retained earnings.
- **Loans**: borrower and entrepreneur borrowing constraints are binding and use expected/collateral values dated at $t+1$.
- **Equity supply**: aggregate equity share supply is fixed; households reallocate holdings across saver and borrower types.
- **Prices**: Calvo price setting includes indexation with parameter $\gamma_p$.
- **Form**: paper-side equilibrium conditions are nonlinear; the MMB implementation cross-check is a log-linear `model(linear)` system.
- **Runtime validation**: not performed; no Dynare command was run.

## 8. Variable & Parameter Reference Table

### Endogenous Variables

| Category | Symbol | Meaning | Main determining equations |
|---|---|---|---|
| Endogenous | $Y_t$ | Output | (F30), (F31) |
| Endogenous | $C_t$ | Aggregate consumption | (F33) |
| Endogenous | $C_t^s$ | Saver consumption | (F2), (F45) |
| Endogenous | $C_t^b$ | Borrower consumption | (F3), (F20) |
| Endogenous | $K_t$ | Entrepreneur physical capital | (F36), (F37) |
| Endogenous | $H_t$ | Aggregate labor | (F35) |
| Endogenous | $H_t^s$ | Saver labor | (F16) |
| Endogenous | $H_t^b$ | Borrower labor | (F19) |
| Endogenous | $V_t$ | Investment/capital accumulation flow | (F31), (F36), (F37) |
| Endogenous | $D_t$ | Deposits | (F13), (F15), (F44) |
| Endogenous | $L_t$ | Aggregate loans | (F34), (F44) |
| Endogenous | $L_t^h$ | Household loans | (F41) |
| Endogenous | $L_t^e$ | Entrepreneur loans | (F42) |
| Endogenous | $K_t^B$ | Bank capital | (F43), (F44) |
| Endogenous | $\Psi_t^s$ | Saver equity holdings | (F17), (F32) |
| Endogenous | $\Psi_t^b$ | Borrower equity holdings | (F21), (F32) |
| Endogenous | $P_t$ | Aggregate price level | (F22) |
| Endogenous | $P_t^{\ast}$ | Reset price | (F23) |
| Endogenous | $Q_t^k$ | Price of physical capital | (F26), (F37) |
| Endogenous | $X_t$ | Retail markup | (F23), (F24) |
| Endogenous | $W_t$ | Nominal wage | (F16), (F19), (F24) |
| Endogenous | $I_t$ | Policy rate | (F47) |
| Endogenous | $I_t^l$ | Wholesale loan rate | (F27) |
| Endogenous | $I_t^h$ | Household loan rate | (F28), (F41) |
| Endogenous | $I_t^e$ | Entrepreneur loan rate | (F29), (F42) |
| Endogenous | $Q_t^\psi$ | Equity price | (F17), (F21), (F43) |
| Endogenous | $\Pi_{\psi,t}$ | Aggregate equity dividends | (F40) |
| Endogenous | $\Pi_{\psi,t}^e$ | Entrepreneur dividends | (F38) |
| Endogenous | $\Pi_{\psi,t}^B$ | Bank dividends | (F39) |
| Endogenous | $\omega_{B,t}$ | Bank profits | (F46) |
| Endogenous | $\lambda_t^h$ | Household collateral multiplier | (F19), (F20), (F21) |
| Endogenous | $\lambda_t^e$ | Entrepreneur collateral multiplier | (F25), (F26) |

### Exogenous Shocks

| Symbol | Meaning | Process |
|---|---|---|
| $\epsilon_{p,t}$ | Price markup innovation | (F48) |
| $\epsilon_{z,t}$ | Technology innovation | (F49) |
| $\epsilon_{i,t}$ | Monetary policy innovation | (F50) |
| $\epsilon_{d,t}$ | Deposit innovation | (F51) |
| $\epsilon_{h,t}$ | Household loan-markup innovation | (F52) |
| $\epsilon_{e,t}$ | Entrepreneur loan-markup innovation | (F53) |
| $\epsilon_{\nu h,t}$ | Household LTV innovation | (F54) |
| $\epsilon_{\nu e,t}$ | Entrepreneur LTV innovation | (F55) |
| $\epsilon_{\psi,t}$ | Equity demand innovation | (F56) |

### Main Parameters

| Symbol | Meaning | Source notes |
|---|---|---|
| $\beta_s,\beta_b,\beta_e$ | Saver, borrower, and entrepreneur discount factors | Table 1 |
| $\beta_B,\beta_R$ | Bank and retailer discount factors | Equal to $\beta_s$ in Table 1 note |
| $\gamma^s,\gamma^b$ | Saver and borrower risk aversion | Estimated |
| $\phi$ | Habit formation | Estimated |
| $\eta$ | Inverse Frisch elasticity | Table 1 |
| $\alpha$ | Capital share | Table 1 |
| $\delta_e$ | Physical capital depreciation | Table 1 |
| $\kappa_v$ | Capital installation cost | Table 1 |
| $\theta_R,\gamma_p$ | Calvo price stickiness and indexation | Estimated |
| $\varepsilon^p$ | Price elasticity of demand | Table 1 |
| $R^\psi$ | Steady-state equity return | Table 1 |
| $\nu_h,\nu_e$ | Household and entrepreneur LTV ratios | Estimated |
| $\phi_w,\phi_k$ | Collateral weights | Estimated |
| $\kappa_k,\kappa_h,\kappa_e$ | Bank capital and retail-rate adjustment costs | Estimated |
| $\tau$ | Bank capital requirement | Table 1 |
| $\delta_B$ | Sunk bank-capital management cost | Table 1 |
| $\phi_\psi,\phi_B$ | Bank dividend share and equity-price pass-through | Table 1 / estimated |
| $\kappa_i,\kappa_\pi,\kappa_y$ | Taylor-rule coefficients | Estimated |
| $\rho_\cdot$ | AR(1) persistence parameters | Table 3 |
