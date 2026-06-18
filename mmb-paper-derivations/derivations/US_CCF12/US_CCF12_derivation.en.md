# US_CCF12 - Derivation (Optimization Problems + First-Order Conditions)

> Archive entry status: `needs_review`. This first-pass derivation is source-backed by the paper Markdown for Chen, Curdia, and Ferrero (2012). The paper body states that the normalized nonlinear equations, steady state, and full log-linear system are in an online Technical Appendix, but that appendix is not present in the available MinerU source.

## 1. Model Overview

- **Model ID**: `US_CCF12`
- **Paper**: Han Chen, Vasco Curdia, and Andrea Ferrero (2012), "The Macroeconomic Effects of Large-scale Asset Purchase Programmes", *The Economic Journal*, 122, F289-F315.
- **DOI**: `10.1111/j.1468-0297.2012.02549.x`
- **Core mechanism**: an estimated US medium-scale New Keynesian DSGE model with nominal and real rigidities plus segmented short- and long-term government bond markets. LSAPs are modeled as shocks to the private-sector market value of long-term debt.
- **Agents**: unrestricted and restricted households, labor agencies, capital producers, final goods producers, monopolistically competitive intermediate-goods firms, financial intermediaries, and a government/central bank.
- **Form**: first-order log-linear approximation around a balanced-growth steady state with variables normalized by productivity. The MMB implementation uses `model(linear)`.
- **Runtime validation**: not performed. The `.mod` file was used only as `implementation_cross_check`; Dynare was not run.

## 2. Optimization Problems

### 2.1 Households

For each type \(j \in \{u,r\}\), the household maximizes expected utility over consumption and differentiated labor:

\[
E_t \sum_{s=0}^{\infty} \beta_j^s b_{t+s}^j
\left[
\frac{1}{1-\sigma_j}
\left(
\frac{C_{t+s}^j}{Z_{t+s}} - h\frac{C_{t+s-1}^j}{Z_{t+s-1}}
\right)^{1-\sigma_j}
-
\frac{\varphi_{t+s}^j [L_{t+s}^j(i)]^{1+\nu}}{1+\nu}
\right].
\]

Unrestricted households trade one-period bonds and long-term perpetuities but pay transaction costs on long bonds:

\[
P_t C_t^u + B_t^u + (1+\zeta_t)P_{L,t}B_t^{L,u}
\leq R_{t-1}B_{t-1}^u + \sum_{s=1}^{\infty}\kappa^{s-1}B_{t-s}^{L,u}
+ W_t^u(i)L_t^u(i) + \mathcal{P}_t+\mathcal{P}_t^{cp}+\mathcal{P}_t^{fi}-T_t^u .
\]

Restricted households trade only long-term securities and pay no transaction costs:

\[
P_t C_t^r + P_{L,t}B_t^{L,r}
\leq \sum_{s=1}^{\infty}\kappa^{s-1}B_{t-s}^{L,r}
+ W_t^r(i)L_t^r(i) + \mathcal{P}_t+\mathcal{P}_t^{cp}+\mathcal{P}_t^{fi}-T_t^r .
\]

### 2.2 Wage Setters

Households are monopolistic suppliers of differentiated labor. A household of type \(j\) that can reset wages at time \(t\) chooses \(\tilde W_t^j(i)\) to maximize discounted wage income net of labor disutility, subject to labor demand and Calvo wage non-adjustment.

### 2.3 Capital Producers

Capital producers choose investment \(I_t\), utilization \(u_t\), and capital services to maximize expected discounted dividends:

\[
E_t\sum_{s=0}^{\infty}\Xi_{t+s}^p
\left[
R_{t+s}^k u_{t+s}\bar K_{t+s-1}
- P_{t+s}a(u_{t+s})\bar K_{t+s-1}
- P_{t+s}I_{t+s}
\right],
\]

subject to effective capital and capital accumulation:

\[
K_t = u_t \bar K_{t-1},
\qquad
\bar K_t = (1-\delta)\bar K_{t-1}
+ \mu_t\left[1-S\left(\frac{I_t}{I_{t-1}}\right)\right]I_t .
\]

### 2.4 Final and Intermediate Goods Producers

Final goods producers aggregate differentiated goods:

\[
Y_t = \left[\int_0^1 Y_t(f)^{1/(1+\lambda_f)}\,df\right]^{1+\lambda_f}.
\]

Intermediate firms rent capital and labor to produce:

\[
Y_t(f)=K_t(f)^\alpha [Z_t L_t(f)]^{1-\alpha}.
\]

They set prices under Calvo rigidity and steady-state inflation indexation, choosing \(\tilde P_t(f)\) to maximize expected discounted profits subject to final-good demand.

## 3. First-Order Conditions

The paper body provides selected nonlinear optimality conditions and states that the full normalized and log-linear systems appear in the online Technical Appendix. Equations below are therefore source-backed from the paper body unless explicitly marked `needs_review`.

- **(F1) Unrestricted household short-bond Euler equation**:

\[
1 = \beta_u E_t\left[
e^{-\gamma-z_{t+1}}\frac{\Xi_{t+1}^u}{\Xi_t^u}
\frac{R_t}{\Pi_{t+1}}
\right].
\]

- **(F2) Unrestricted household long-bond Euler equation**:

\[
1+\zeta_t =
\beta_u E_t\left[
e^{-\gamma-z_{t+1}}\frac{\Xi_{t+1}^u}{\Xi_t^u}
\frac{P_{L,t+1}}{P_{L,t}}\frac{R_{L,t+1}}{\Pi_{t+1}}
\right].
\]

- **(F3) Restricted household long-bond Euler equation**:

\[
1 =
\beta_r E_t\left[
e^{-\gamma-z_{t+1}}\frac{\Xi_{t+1}^r}{\Xi_t^r}
\frac{P_{L,t+1}}{P_{L,t}}\frac{R_{L,t+1}}{\Pi_{t+1}}
\right].
\]

- **(F4) Labor demand for differentiated labor**:

\[
L_t(i)=\left[\frac{W_t(i)}{W_t}\right]^{-(1+\lambda_w)/\lambda_w}L_t .
\]

- **(F5) Wage index**:

\[
W_t=\left[\int_0^1 W_t(i)^{-1/\lambda_w}\,di\right]^{-\lambda_w}.
\]

- **(F6) Effective capital services**:

\[
K_t = u_t\bar K_{t-1}.
\]

- **(F7) Capital accumulation**:

\[
\bar K_t=(1-\delta)\bar K_{t-1}
+\mu_t\left[1-S\left(\frac{I_t}{I_{t-1}}\right)\right]I_t .
\]

- **(F8) Final-good demand for intermediate good \(f\)**:

\[
Y_t(f)=\left[\frac{P_t(f)}{P_t}\right]^{-(1+\lambda_f)/\lambda_f}Y_t .
\]

- **(F9) Aggregate price index**:

\[
P_t=\left[\int_0^1 P_t(f)^{-1/\lambda_f}\,df\right]^{-\lambda_f}.
\]

- **(F10) Intermediate-goods production**:

\[
Y_t(f)=K_t(f)^\alpha [Z_t L_t(f)]^{1-\alpha}.
\]

- **(F11) Real marginal cost**:

\[
MC_t=\frac{(R_t^k)^\alpha W_t^{1-\alpha}}
{\alpha^\alpha(1-\alpha)^{1-\alpha}Z_t^{1-\alpha}}.
\]

- **(F12) Calvo price-setting FOC** (`needs_review`: the paper body gives the optimization problem; the recursive normalized FOC is in the missing online appendix):

\[
\tilde P_t(f)\ \text{solves}
\max E_t\sum_{s=0}^{\infty}\zeta_p^s\Xi_{t+s}^p
\left[\tilde P_t(f)\Pi^s-\lambda_{f,t+s}MC_{t+s}\right]Y_{t+s}(f).
\]

- **(F13) Calvo wage-setting FOC** (`needs_review`: recursive normalized FOC absent from paper body):

\[
\tilde W_t^j(i)\ \text{solves the Calvo wage problem for } j\in\{u,r\}
\text{ subject to labor demand and indexation by } \Pi e^\gamma .
\]

## 4. Market Clearing & Identities

- **(F14) Aggregate resource constraint**:

\[
Y_t=\omega_u C_t^u+\omega_r C_t^r+I_t+G_t+a(u_t)\bar K_{t-1}.
\]

- **(F15) Government budget constraint with perpetuity bonds**:

\[
B_t+P_{L,t}B_t^L
=R_{t-1,t}B_{t-1}+(1+\kappa P_{L,t})B_{t-1}^L+P_tG_t-T_t .
\]

- **(F16) Long-term debt supply rule**:

\[
\frac{P_{L,t}B_t^L}{P_tZ_t}
=
\left(\frac{P_{L,t-1}B_{t-1}^L}{P_{t-1}Z_{t-1}}\right)^{\rho_B}
e^{\epsilon_{B,t}}.
\]

- **(F17) Fiscal surplus rule**:

\[
\frac{T_t}{P_tZ_t}-\frac{G_t}{Z_t}
=
\Phi
\left(\frac{P_{L,t-1}B_{t-1}^L}{P_{t-1}Z_{t-1}}\right)^{\phi_T}
e^{\epsilon_{T,t}}.
\]

- **(F18) Risk premium as discounted transaction costs**:

\[
\hat R_{L,t}-\hat R_{L,t}^{EH}
=
\frac{1}{D_L}\sum_{s=0}^{\infty}
\left(\frac{D_L-1}{D_L}\right)^s E_t\zeta_{t+s}.
\]

- **(F19) Transaction-cost function**:

\[
\zeta_t \equiv
\zeta\left(\frac{P_{L,t}B_{z,t}^L}{B_{z,t}},\epsilon_{\zeta,t}\right).
\]

- **(F20) Monetary policy rule**:

\[
\frac{R_t}{R}=
\left(\frac{R_{t-1}}{R}\right)^{\rho_m}
\left[
\left(\frac{\Pi_t}{\Pi}\right)^{\phi_\pi}
\left(\frac{Y_t/Y_{t-4}}{e^{4\gamma}}\right)^{\phi_y}
\right]^{1-\rho_m}
e^{\epsilon_{m,t}}.
\]

## 5. Exogenous Processes

- **(F21) Technology growth**:

\[
\log\left(\frac{Z_t}{Z_{t-1}}\right)
=(1-\rho_z)\gamma
+\rho_z\log\left(\frac{Z_{t-1}}{Z_{t-2}}\right)
+\epsilon_{z,t}.
\]

- **(F22) Investment-specific technology shock**:

\[
\log\mu_t = \rho_\mu\log\mu_{t-1}+\epsilon_{\mu,t}.
\]

- **(F23) Preference and labor-supply shocks**:

\[
\log b_t^j=\rho_b\log b_{t-1}^j+\epsilon_{b^j,t},
\qquad
\log\varphi_t^j=\rho_\varphi\log\varphi_{t-1}^j+\epsilon_{\varphi^j,t}.
\]

- **(F24) Risk-premium, fiscal, monetary, markup, and debt innovations**:

\[
\epsilon_{\zeta,t},\ \epsilon_{T,t},\ \epsilon_{m,t},\ \epsilon_{\lambda,t},\ \epsilon_{B,t}
\text{ enter the corresponding rules as innovations.}
\]

## 6. Steady-State Solution

The source states that the model is solved after a first-order log-linear approximation around a steady state with quantities normalized by productivity \(Z_t\) and relative prices expressed relative to \(P_t\). It also states that the online Appendix characterizes the steady-state solution.

First-pass steady-state information available from the paper body and implementation cross-check:

- Balanced-growth normalization uses \(C_t^j/Z_t\), \(B_t/(P_tZ_t)\), \(B_t^L/(P_tZ_t)\), \(G_t/Z_t\), and related real quantities.
- The productivity growth steady state is governed by \(\gamma\).
- Steady-state inflation is \(\Pi\); the estimated posterior median in the paper's Table 2 is reported for \(400\pi\).
- Long-bond cash-flow parameter \(\kappa\) is calibrated to imply a 30-quarter duration.
- Steady-state risk premium is positive, with transaction-cost level \(\zeta>0\) and positive slope \(\zeta'>0\).
- The MMB implementation derives `betar`, `RL`, `kappa`, `Bz_SS`, `BzL_SS`, `BLMVz_SS`, `beta_av`, `rk_SS`, `Kz_SS`, `Iz_SS`, `Tz_SS`, `Czu_SS`, and `Czr_SS` from the calibrated and posterior parameters. These formulas are recorded as implementation cross-check evidence only.

`needs_review`: The full analytic steady-state derivation from online Appendix C was not available in the paper Markdown. This entry should not be marked reviewed until that appendix is added or checked against the PDF/supporting material.

## 7. Timing & Form Conventions

- **Form**: linearized estimation model; MMB implementation uses `model(linear)`.
- **Normalization**: quantities are detrended by productivity \(Z_t\).
- **Capital timing**: \(\bar K_t\) is the end-of-period physical capital stock; current effective capital services use \(K_t=u_t\bar K_{t-1}\).
- **Bonds**: short-term bonds are one-period nominal securities paying \(R_t\) at \(t+1\); long-term bonds are perpetuities bought at \(P_{L,t}\) and paying geometrically decaying coupons.
- **Segmentation timing**: unrestricted households price both short and long bonds; restricted households price only long bonds.
- **LSAP convention**: asset purchases are represented as shocks to the rule for the private-sector market value of long-term debt.
- **Implementation cross-check**: the `.mod` file uses log-linear variables such as `Kz(-1)`, `z(+1)`, `pi(+1)`, `rL(+1)`, and `BLMVz(-1)`, consistent with predetermined capital and debt stocks plus forward-looking Euler/pricing equations.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII name | Meaning | Main equation(s) |
|---|---|---|---|
| Endogenous | \(C_t^u\), `Czu` | Unrestricted consumption, productivity-normalized in implementation | (F1), (F14) |
| Endogenous | \(C_t^r\), `Czr` | Restricted consumption, productivity-normalized in implementation | (F3), (F14) |
| Endogenous | \(\Xi_t^u,\Xi_t^r\), `Xiu`, `Xir` | Real marginal utilities | (F1)-(F3) |
| Endogenous | \(L_t\), `L` | Aggregate labor | (F4), (F10) |
| Endogenous | \(W_t\), `wz` | Aggregate real wage | (F5), (F11), (F13) |
| Endogenous | \(Y_t\), `Yz` | Output | (F8), (F10), (F14) |
| Endogenous | \(K_t\), `Kz_eff` | Effective capital services | (F6), (F10) |
| Endogenous | \(\bar K_t\), `Kz` | End-of-period capital stock | (F7) |
| Endogenous | \(I_t\), `Iz` | Investment | (F7), (F14) |
| Endogenous | \(u_t\), `u` | Capital utilization | (F6), (F14) |
| Endogenous | \(MC_t\), `marc` | Real marginal cost | (F11), (F12) |
| Endogenous | \(\Pi_t\), `pi` | Inflation | (F20) |
| Endogenous | \(R_t\), `r` | Short nominal policy rate in the paper and implementation linear variable | (F1), (F20) |
| Endogenous | \(R_{L,t}\), `rL` | Long-term yield | (F2), (F3), (F18) |
| Endogenous | \(B_t\), `Bz` | Short-term government debt, normalized | (F15), (F19) |
| Endogenous | \(B_t^L\), `BzL` | Long-term government debt, normalized | (F15), (F16), (F19) |
| Endogenous | \(P_{L,t}B_t^L/(P_tZ_t)\), `BLMVz` | Market value of long-term debt | (F16), (F19) |
| Endogenous | \(T_t\), `Tz` | Taxes or primary surplus component | (F17) |
| Endogenous | \(G_t\), `Gz` | Government purchases | (F14), (F17) |
| Endogenous | \(\zeta_t\), `zeta_h` | Long-bond transaction cost / risk premium component | (F2), (F18), (F19) |
| Exogenous | \(\epsilon_{z,t}\), `eps_z` | Technology-growth innovation | (F21) |
| Exogenous | \(\epsilon_{\mu,t}\), `eps_mu` | Investment-specific technology innovation | (F22) |
| Exogenous | \(\epsilon_{b^u,t},\epsilon_{b^r,t}\), `eps_bu`, `eps_br` | Preference innovations | (F23) |
| Exogenous | \(\epsilon_{\varphi,t}\), `eps_phi` | Labor-supply preference innovation | (F23) |
| Exogenous | \(\epsilon_{\lambda,t}\), `eps_lambda` | Markup innovation | (F24) |
| Exogenous | \(\epsilon_{\zeta,t}\), `eps_zeta` | Risk-premium innovation | (F19), (F24) |
| Exogenous | \(\epsilon_{m,t}\), `eps_m` | Monetary policy innovation | (F20) |
| Exogenous | \(\epsilon_{T,t}\), `eps_T` | Fiscal rule innovation | (F17) |
| Exogenous | \(\epsilon_{B,t}\), `eps_B` | Long-term bond supply / LSAP innovation | (F16) |
| Parameter | \(\beta_u,\beta_r\) | Discount factors for unrestricted/restricted households | (F1)-(F3) |
| Parameter | \(\omega_u,\omega_r\) | Population shares; \(\omega_r=1-\omega_u\) | (F14) |
| Parameter | \(\sigma_u,\sigma_r,h,\nu\) | Preference curvature, habit, inverse labor elasticity | Section 2 |
| Parameter | \(\lambda_w,\lambda_f\) | Wage and price steady-state markups | (F4), (F8), (F11) |
| Parameter | \(\zeta_w,\zeta_p\) | Wage and price Calvo non-adjustment probabilities | (F12), (F13) |
| Parameter | \(\alpha,\delta,\gamma\) | Capital share, depreciation, trend growth | (F7), (F10), (F21) |
| Parameter | \(\kappa,D_L\) | Long-bond coupon decay and duration | (F2), (F18) |
| Parameter | \(\zeta,\zeta'\) | Steady transaction cost and risk-premium elasticity | (F18), (F19) |
| Parameter | \(\rho_m,\phi_\pi,\phi_y,\rho_B,\phi_T\) | Policy rule parameters | (F16), (F17), (F20) |
| Parameter | \(\rho_z,\rho_\mu,\rho_b,\rho_\varphi\) | Shock persistence parameters | (F21)-(F23) |
