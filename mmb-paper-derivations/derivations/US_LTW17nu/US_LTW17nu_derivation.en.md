# US_LTW17nu -- Derivation (Optimization Problems + First-Order Conditions)

> Archive status: `needs_review`. This first-pass derivation is source-backed by MinerU Markdown and checked against the MMB `.mod` only as `implementation_cross_check`; Dynare runtime validation was not performed.

Provenance: `US_LTW17nu`, Leeper, Traum, and Walker (2017), "Clearing Up the Fiscal Multiplier Morass," DOI `10.1257/aer.20111196`. Source Markdown: `raw/mmb_mineru/runs/us_ltw17_us_ltw17gz_us_ltw17nu_us_ltw17rot__clearing_up_the_fiscal_multiplier_morass__f1cc32b3/full.md`; raw PDF: `raw/mmb_papers/Clearing Up the Fiscal Multiplier Morass.pdf`; MinerU run id: `f1cc32b3-a1c8-4473-bab4-edca5aaeb37e`.

## 1. Model Overview

- **Model**: US medium-scale New Keynesian fiscal multiplier model with nominal rigidities, real frictions, fiscal feedback rules, long-maturity nominal government debt, and steady-state distortionary taxes.
- **Variant**: `US_LTW17nu`, the no-government-spending-in-utility variant. The paper nests a model with government spending in utility, but the MMB implementation sets `alphag = 0` and `thet = 0.8`; this variant-specific restriction comes from `.agents/skills/dynare-copilot/references/examples/US_LTW17nu_rep.mod` as `implementation_cross_check`.
- **Agents and blocks**: savers, optionally non-savers in the paper-side general model, final-good and intermediate-good firms, labor agency and wage setters, monetary authority, and fiscal authority.
- **Form**: log-linearized `model(linear)` implementation. Paper equations are presented in levels and hatted percentage deviations; the MMB `.mod` implements the `nu` variant as linear equations around a deterministic steady state.
- **Review status**: first-pass formula quality is `needs_review` because several OCR equations in the source Markdown are malformed and the variant-specific `nu` restrictions are inferred from the implementation cross-check rather than from a standalone paper subsection.

## 2. Optimization Problems

### 2.1 Final-Good Producer

The final-good firm aggregates differentiated intermediate goods:

\[
Y_t \leq \left(\int_0^1 Y_t(i)^{\frac{1}{1+\eta_t^p}}\,di\right)^{1+\eta_t^p}.
\]

It chooses input demands to maximize final-good revenue net of payments to intermediate firms. The implied Dixit-Stiglitz demand is recorded as (F1).

### 2.2 Intermediate-Good Firms

Intermediate firm \(i\) operates the technology:

\[
Y_t(i)=K_t(i)^\alpha \big(A_t L_t(i)\big)^{1-\alpha}-A_t\Omega.
\]

Cost minimization gives common nominal marginal cost. Firms reset prices with Calvo probability \(1-\omega_p\); non-reset prices are partially indexed to lagged inflation and steady-state inflation.

The reoptimizing firm maximizes expected discounted profits:

\[
E_t\sum_{s=0}^{\infty}(\beta\omega_p)^s\frac{\lambda_{t+s}}{\lambda_t}
\left[\left(\prod_{k=1}^{s}\pi_{t+k-1}^{\chi_p}\pi^{1-\chi_p}\right)P_t(i)Y_{t+s}(i)-MC_{t+s}Y_{t+s}(i)\right].
\]

`needs_review`: the Markdown formula for the price-setting problem is readable in structure but should be checked against the PDF for exact nominal/relative-price notation.

### 2.3 Labor Agency and Wage Setters

A labor agency combines differentiated labor services:

\[
L_t=\left(\int_0^1 L_t(l)^{\frac{1}{1+\eta_t^w}}\,dl\right)^{1+\eta_t^w}.
\]

Households supply differentiated labor services. Saver households reset nominal wages with probability \(1-\omega_w\) and otherwise index wages to lagged inflation and trend growth. The wage-reset problem is the household analogue of the Calvo price problem.

### 2.4 Saver Households

Saver household \(j\) maximizes:

\[
E_0\sum_{t=0}^{\infty}\beta^t u_t^b
\left[
\log\big(C_t^{\astS}(j)-\theta \widetilde C_{t-1}^{\astS}\big)
-\frac{(L_t^S(j))^{1+\xi}}{1+\xi}
\right],
\]

with composite consumption:

\[
C_t^{\astS}(j)=C_t^S(j)+\alpha_G G_t.
\]

For `US_LTW17nu`, `implementation_cross_check` sets \(\alpha_G=0\), so \(C_t^{\astS}=C_t^S\). The nominal budget constraint is:

\[
\begin{aligned}
P_t(1+\tau_t^C)C_t^S(j)+P_t I_t^S(j)+P_t^B B_t(j)+R_t^{-1}B_{s,t}(j)
&=(1+\rho P_t^B)B_{t-1}(j)+B_{s,t-1}(j)\\
&\quad +(1-\tau_t^L)\int_0^1 W_t(l)L_t^S(j,l)\,dl\\
&\quad +(1-\tau_t^K)R_t^k\nu_t(j)\bar K_{t-1}^S(j)-\Psi(\nu_t)\bar K_{t-1}^S(j)\\
&\quad +P_t Z_t^S(j)+D_t(j).
\end{aligned}
\]

Physical capital evolves according to:

\[
\bar K_t^S(j)=(1-\delta)\bar K_{t-1}^S(j)+u_t^i\left[1-s\left(\frac{I_t^S(j)}{I_{t-1}^S(j)}\right)\right]I_t^S(j).
\]

### 2.5 Non-Saver Households

The paper-side general model allows a fraction \(\mu\) of non-savers. They consume disposable income each period:

\[
(1+\tau_t^C)P_t C_t^N(j)=(1-\tau_t^L)\int_0^1 W_t(l)L_t^N(j,l)\,dl+P_t Z_t^N(j).
\]

For `US_LTW17nu`, `implementation_cross_check` sets `muHH = 0`; the non-saver block is inactive in the numerical variant but retained here for source coverage.

### 2.6 Government and Monetary Authority

The monetary authority follows a Taylor-type feedback rule. The fiscal authority chooses government consumption, transfers, and tax instruments subject to the government budget identity and feedback rules tied to the market-value debt-output ratio.

## 3. First-Order Conditions

- **(F1) Intermediate-good demand**:

\[
Y_t(i)=Y_t\left(\frac{P_t(i)}{P_t}\right)^{-\frac{1+\eta_t^p}{\eta_t^p}}.
\]

- **(F2) Production function, stationary/log-linear implementation form**:

\[
\hat y_t-\frac{\bar Y+\bar\Omega}{\bar Y}\alpha \hat k_t-\frac{\bar Y+\bar\Omega}{\bar Y}(1-\alpha)\hat l_t=0.
\]

- **(F3) Factor-price relation**:

\[
\hat r_t^k-\hat w_t+\hat k_t-\hat l_t=0.
\]

- **(F4) Real marginal cost**:

\[
\widehat{mc}_t-\alpha\hat r_t^k+(\alpha-1)\hat w_t=0.
\]

- **(F5) Price Phillips curve**:

\[
\Lambda_p\pi_t-\frac{\Lambda_p\beta}{1+\beta\chi_p}\pi_{t+1}-\widehat{mc}_t-\Lambda_p u_t^p
=\frac{\Lambda_p\chi_p}{1+\beta\chi_p}\pi_{t-1}.
\]

`needs_review`: the structural Calvo FOC is source-stated, while this compact linear Phillips curve is cross-checked from the `.mod` implementation.

- **(F6) Saver marginal utility of wealth**:

\[
\lambda_t+\frac{\theta}{e^\gamma-\theta}u_t^a+\frac{e^\gamma}{e^\gamma-\theta}\hat c_t^{\ast}
-u_t^b+\frac{\bar\tau^C}{1+\bar\tau^C}\hat\tau_t^C
=\frac{\theta}{e^\gamma-\theta}\hat c_{t-1}^{\ast}.
\]

- **(F7) Long-run real interest rate and bond price**:

\[
\hat r_t^L+\widehat P_t^B-\frac{\beta\rho}{e^\gamma}\hat r_{t+1}^L
-\frac{\beta\rho}{e^\gamma}\widehat P_{t+1}^B+\pi_{t+1}=0.
\]

- **(F8) Long-run inflation relation**:

\[
\hat\pi_t^L+\widehat P_t^B+\hat r_t^L=0.
\]

- **(F9) Consumption in utility, `nu` variant**:

\[
\hat c_t^{\ast}-\hat c_t^S=0,\qquad \alpha_G=0.
\]

- **(F10) Saver Euler equation**:

\[
\lambda_t-\hat R_t+\pi_{t+1}-\lambda_{t+1}+\rho_a u_t^a=0.
\]

- **(F11) Capacity utilization**:

\[
\frac{1-\psi}{\psi}\hat r_t^k-\hat\nu_t
-\frac{1-\psi}{\psi}\frac{\bar\tau^K}{1-\bar\tau^K}\hat\tau_t^K=0.
\]

- **(F12) Capital FOC**:

\[
\hat q_t+\hat R_t-\pi_{t+1}
-\beta e^{-\gamma}(1-\delta)\hat q_{t+1}
-\beta e^{-\gamma}\bar R^k(1-\bar\tau^K)\hat r_{t+1}^k
+\bar\tau^K\beta e^{-\gamma}\bar R^k\hat\tau_{t+1}^K=0.
\]

- **(F13) Investment FOC**:

\[
-\frac{1}{(1+\beta)s e^{2\gamma}}\hat q_t+\hat i_t-\frac{\beta}{1+\beta}\hat i_{t+1}
+\frac{1-\beta\rho_a}{1+\beta}u_t^a-u_t^i
=\frac{1}{1+\beta}\hat i_{t-1}.
\]

- **(F14) Effective capital**:

\[
\hat k_t-\hat\nu_t+u_t^a=\hat{\bar k}_{t-1}.
\]

- **(F15) Physical capital accumulation**:

\[
\hat{\bar k}_t-\left[1-(1-\delta)e^{-\gamma}\right](1+\beta)s e^{2\gamma}u_t^i
-\left[1-(1-\delta)e^{-\gamma}\right]\hat i_t
+(1-\delta)e^{-\gamma}u_t^a
=(1-\delta)e^{-\gamma}\hat{\bar k}_{t-1}.
\]

- **(F16) Wage Phillips curve**:

\[
\begin{aligned}
(1+\Lambda_w)\hat w_t-\frac{\Lambda_w\beta}{1+\beta}\hat w_{t+1}
+\frac{\Lambda_w(1+\beta\chi_w)}{1+\beta}\pi_t
-\frac{\Lambda_w\beta}{1+\beta}\pi_{t+1}
-\xi\hat l_t+\lambda_t\\
+\frac{\Lambda_w(1+\beta\chi_w-\rho_a\beta)}{1+\beta}u_t^a
-\frac{\bar\tau^L}{1-\bar\tau^L}\hat\tau_t^L
-\Lambda_w u_t^w-u_t^b\\
=\frac{\Lambda_w}{1+\beta}\hat w_{t-1}
+\frac{\Lambda_w\chi_w}{1+\beta}\pi_{t-1}
+\frac{\Lambda_w\chi_w}{1+\beta}u_{t-1}^a.
\end{aligned}
\]

`needs_review`: the paper states the Calvo wage problem, but this linear wage equation is taken from the implementation cross-check.

- **(F17) Monetary policy rule**:

\[
\hat R_t-\left(1-\rho_R\right)\phi_\pi\pi_t-\left(1-\rho_R\right)\phi_y\hat y_t-u_t^m
=\rho_R\hat R_{t-1}.
\]

## 4. Market Clearing & Identities

- **(F18) Aggregate resource constraint**:

\[
\bar C\hat c_t+\bar I\hat i_t-\bar Y\hat y_t+\bar s_G\bar Y\hat g_t+\Psi'(1)\bar K\hat\nu_t=0.
\]

- **(F19) Non-saver budget constraint, inactive when \(\mu=0\)**:

\[
\bar C^N(1+\bar\tau^C)\hat c_t^N+\bar\tau^C\bar C^N\hat\tau_t^C
-\bar W\bar L(1-\bar\tau^L)(\hat w_t+\hat l_t)
+\bar W\bar L\bar\tau^L\hat\tau_t^L-\bar Z\hat z_t=0.
\]

- **(F20) Consumption aggregation**:

\[
\bar C\hat c_t-(1-\mu)\bar C^S\hat c_t^S-\mu\bar C^N\hat c_t^N=0.
\]

- **(F21) Long-maturity bond pricing**:

\[
\hat R_t-\frac{\rho\bar P^B}{1+\rho\bar P^B}\widehat P_{t+1}^B+\widehat P_t^B=0.
\]

- **(F22) Government budget constraint**:

\[
\begin{aligned}
\bar s_b\hat b_t-\bar s_G\hat g_t-\frac{\bar Z}{\bar Y}\hat z_t
+\bar\tau^K\bar r^k\bar k_y(\hat\tau_t^K+\hat r_t^k+\hat k_t)
+\frac{\bar s_b}{\beta}u_t^a\\
+\bar\tau^L\bar w\bar l_y(\hat\tau_t^L+\hat w_t+\hat l_t)
+\bar\tau^C\bar c_y(\hat c_t+\hat\tau_t^C)
-\bar s_b\rho e^{-\gamma}\widehat P_t^B+\frac{\bar s_b}{\beta}\pi_t\\
=\frac{\bar s_b}{\beta}\hat b_{t-1}-\frac{\bar s_b}{\beta}\widehat P_{t-1}^B.
\end{aligned}
\]

`needs_review`: OCR for the paper's government budget identity is noisy; this log-linear version is from the implementation cross-check.

- **(F23) Government consumption rule**:

\[
\hat g_t-u_t^G=\rho_G\hat g_{t-1}-(1-\rho_G)\gamma_G\hat s_{t-1}^b.
\]

- **(F24) Capital tax rule**:

\[
\hat\tau_t^K=(1-\rho_K)\gamma_K\hat s_{t-1}^b+\rho_K\hat\tau_{t-1}^K.
\]

- **(F25) Labor tax rule**:

\[
\hat\tau_t^L=(1-\rho_L)\gamma_L\hat s_{t-1}^b+\rho_L\hat\tau_{t-1}^L.
\]

- **(F26) Consumption tax rule**:

\[
\hat\tau_t^C=\rho_C\hat\tau_{t-1}^C.
\]

- **(F27) Transfer rule**:

\[
\hat z_t-u_t^Z=-(1-\rho_Z)\gamma_Z\hat s_{t-1}^b+\rho_Z\hat z_{t-1}.
\]

- **(F28) Fisher equation**:

\[
\hat r_t-\hat R_t+\pi_{t+1}=0.
\]

- **(F29) Debt-output ratio definition**:

\[
\hat s_t^b+\hat y_t-\hat b_t=0.
\]

- **(F30) Consumption tax revenue**:

\[
\widehat T_t^C-\hat\tau_t^C-\hat c_t=0.
\]

- **(F31) Capital tax revenue**:

\[
\widehat T_t^K-\hat\tau_t^K-\hat r_t^k-\hat k_t=0.
\]

- **(F32) Real bond return definition**:

\[
\widehat r_t^b-\rho\beta e^{-\gamma}\widehat P_t^B+\pi_t=-\widehat P_{t-1}^B.
\]

- **(F33) Primary surplus definition**:

\[
\widehat S_t-\frac{\bar\tau^K\bar r^k\bar k}{\bar S}(\hat\tau_t^K+\hat r_t^k+\hat k_t)
-\frac{\bar\tau^L\bar w\bar l}{\bar S}(\hat\tau_t^L+\hat w_t+\hat l_t)
-\frac{\bar\tau^C\bar c}{\bar S}(\hat\tau_t^C+\hat c_t)
+\frac{\bar Z}{\bar S}\hat z_t+\frac{\bar G}{\bar S}\hat g_t=0.
\]

- **(F34) Labor tax revenue**:

\[
\widehat T_t^L-\hat\tau_t^L-\hat w_t-\hat l_t=0.
\]

## 5. Exogenous Processes

- **(F35) Government consumption shock**:

\[
u_t^G=\rho_{eG}u_{t-1}^G+\epsilon_t^G.
\]

- **(F36) Transfer shock**:

\[
u_t^Z=\rho_{eZ}u_{t-1}^Z+\epsilon_t^Z.
\]

- **(F37) Technology growth shock**:

\[
u_t^a=\rho_a u_{t-1}^a+\epsilon_t^a.
\]

- **(F38) Preference shock**:

\[
u_t^b=\rho_b u_{t-1}^b+\epsilon_t^b.
\]

- **(F39) Monetary policy shock**:

\[
u_t^m=\rho_{em}u_{t-1}^m+\epsilon_t^m.
\]

- **(F40) Investment shock**:

\[
u_t^i=\rho_i u_{t-1}^i+\epsilon_t^i.
\]

- **(F41) Wage markup shock**:

\[
u_t^w=\rho_w u_{t-1}^w+\epsilon_t^w.
\]

- **(F42) Price markup shock**:

\[
u_t^p=\rho_p u_{t-1}^p+\epsilon_t^p.
\]

## 6. Steady-State Solution

The MMB implementation computes the deterministic steady state in levels, then uses `model(linear)` for deviations. Let \(\bar\pi=1\), \(\bar\nu=1\), and \(e^\gamma\) be the gross trend growth rate.

1. Calibrate fiscal steady states \(\bar s_b\), \(\bar\tau^L\), \(\bar\tau^K\), \(\bar\tau^C\), and \(\bar s_G\) from US averages.
2. Set \(\bar R=e^\gamma/\beta\) and the long-bond price \(\bar P^B=1/(\bar R-\rho)\).
3. Set after-tax private capital return:

\[
\bar R^k=\frac{e^\gamma/\beta-1+\delta}{1-\bar\tau^K}.
\]

4. Set real marginal cost \(\overline{mc}=1/(1+\eta^p)\) and recover \(\bar W\), \(\bar K/\bar L\), \(\bar Y/\bar L\), \(\bar I/\bar L\), and aggregate consumption per labor unit from production, investment, and resource constraints.
5. For `US_LTW17nu`, set \(\alpha_G=0\), \(\mu=0\), and \(\theta=0.8\) from implementation cross-check. Then \(C^{\ast S}=C^S\) in steady state.
6. Recover labor from the saver intratemporal condition and scale level variables by \(\bar L\).
7. Compute tax revenues, primary surplus, transfers, debt, and government consumption from the fiscal steady-state ratios.

`needs_review`: steady-state formulas are summarized from the paper structure and implementation cross-check. No independent algebraic verification or Dynare steady-state validation was performed.

## 7. Timing & Form Conventions

- **Form**: `model(linear)`; variables in (F2)-(F42) are hatted or implementation-style deviations around the deterministic steady state.
- **Technology trend**: permanent technology \(A_t\) has stationary growth shock \(u_t^a=\log A_t-\log A_{t-1}\).
- **Capital timing**: physical capital \(\bar K_t\) is the end-of-period stock; effective capital used in production is tied to utilization and lagged physical capital.
- **Debt timing**: long-term nominal debt pays a decaying coupon stream with maturity parameter \(\rho\); market-value debt-to-output ratio \(s_t^b\) uses bond prices and outstanding debt.
- **Variant restriction**: `US_LTW17nu` removes government consumption from utility, \(\alpha_G=0`, and lowers habit formation to \)\theta=0.8` in the MMB implementation.
- **Runtime validation**: not performed; no Dynare command was run.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Equation source |
|---|---|---|---|
| Endogenous | `cs`, \(C^S\) | saver consumption | (F6), (F9), (F10), (F20) |
| Endogenous | `cn`, \(C^N\) | non-saver consumption, inactive if \(\mu=0\) | (F19), (F20) |
| Endogenous | `R` | nominal interest rate | (F17), (F28) |
| Endogenous | `i` | investment | (F13), (F18) |
| Endogenous | `k` | effective capital | (F2), (F14) |
| Endogenous | `v` | utilization | (F11), (F14), (F18) |
| Endogenous | `l` | labor | (F2), (F3), (F16) |
| Endogenous | `y` | output | (F2), (F18), (F29) |
| Endogenous | `gc` | government consumption | (F18), (F23), (F33) |
| Endogenous | `c` | aggregate consumption | (F18), (F20), (F30) |
| Endogenous | `q` | investment-goods multiplier / Tobin's Q | (F12), (F13) |
| Endogenous | `rk` | real return on capital | (F3), (F12), (F31) |
| Endogenous | `w` | real wage | (F3), (F4), (F16) |
| Endogenous | `pi` | inflation | (F5), (F17), (F28) |
| Endogenous | `b`, `sb` | government debt and debt-output ratio | (F22), (F29) |
| Endogenous | `tauk`, `taul`, `tauc` | tax rates | (F24)-(F26) |
| Endogenous | `r` | real interest rate | (F28) |
| Endogenous | `z` | transfers | (F27), (F33) |
| Endogenous | `mc` | real marginal cost | (F4), (F5) |
| Endogenous | `kbar` | physical capital stock | (F15) |
| Endogenous | `lambda` | saver marginal utility of wealth | (F6), (F10), (F16) |
| Endogenous | `Pb` | long-bond price | (F7), (F8), (F21), (F22), (F32) |
| Endogenous | `cstar` | consumption in utility | (F9) |
| Endogenous | `piL`, `rL` | long-run inflation and real rate | (F7), (F8) |
| Endogenous | `S`, `rb`, `Tk`, `Tl`, `Tc` | fiscal accounting variables | (F30)-(F34) |
| Exogenous shock | `eugc`, `euz`, `eua`, `eub`, `eum`, `eui`, `euw`, `eup` | innovations to government consumption, transfers, technology, preference, monetary policy, investment, wage markup, and price markup shocks | (F35)-(F42) |
| Parameter | `bet`, `delt`, `alph`, `etaw`, `etap` | discount, depreciation, capital share, wage and price markup parameters | all model blocks |
| Parameter | `omegaw`, `omegap`, `chiw`, `chip` | Calvo wage/price stickiness and indexation | (F5), (F16) |
| Parameter | `phipi`, `phiy`, `rhor` | Taylor rule coefficients | (F17) |
| Parameter | `gammgc`, `gammtk`, `gammtl`, `gammz` | fiscal feedback to debt | (F23)-(F27) |
| Parameter | `rhoa`, `rhob`, `rhoi`, `rhow`, `rhop`, `rhogc`, `rhoz`, `rhoem`, `rhoeg`, `rhoez` | persistence parameters | (F35)-(F42) |
| Parameter | `alphag`, `thet`, `muHH` | government consumption in utility, habits, non-saver share | (F9), variant restrictions |

Equation count in the documentation: (F1)-(F42). The implementation contains additional flex-price shadow-economy equations and observable equations; those are noted in `extraction_notes.md` but not fully re-derived in this first-pass archive entry.
