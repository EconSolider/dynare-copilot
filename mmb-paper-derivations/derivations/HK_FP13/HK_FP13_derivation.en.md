# HK_FP13 -- Derivation (Optimization Problems + Equilibrium Conditions)

> Status: `needs_review` first-pass extraction from MinerU Markdown. Runtime validation was not performed.
> Source: Funke and Paetz (2013), "Housing prices and the business cycle: An empirical application to Hong Kong", Journal of Housing Economics 22(1), 62-76, DOI: `10.1016/j.jhe.2012.11.001`.

## 1. Model Overview

- **Model**: HK_FP13, a two-agent, two-sector, small open-economy DSGE model for Hong Kong with housing services, housing investment, and a collateral constraint.
- **Agents**: impatient borrowers, patient savers, non-residential and residential goods firms, foreign/rest-of-world blocks, government, and a currency-board monetary authority.
- **Sectors**: non-residential consumption goods \(C\) and residential/housing goods \(D\).
- **Core frictions**: habit in non-durable consumption, housing in utility, borrower collateral constraint, sector-specific openness, nominal rigidities with forward- and backward-looking price setters, and exogenous loan-to-value, preference, technology, mark-up, foreign-demand, foreign-price, and government shocks.
- **Form**: the paper derives nonlinear household problems but estimates a first-order log-linearized model. The MMB implementation uses `model(linear)`, so this archive entry records log-linear equilibrium conditions where the source gives them and flags OCR-heavy nonlinear FOCs as `needs_review`.
- **Experiment**: Bayesian estimation on Hong Kong quarterly data, 1985Q1-2010Q2. Runtime validation is deferred.

## 2. Optimization Problems

### 2.1 Borrower Household

The representative impatient borrower chooses non-durable consumption, residential stock, domestic debt, and labor in both sectors:

\[
\max_{\{C_t^b,D_t^b,B_{H,t}^b,N_{C,t}^b,N_{D,t}^b\}} E_0\sum_{t=0}^{\infty}\beta_b^t
\left[
\frac{(X_t^b)^{1-\sigma}}{1-\sigma}
- \sum_{j=C,D}\frac{(N_{j,t}^b)^{1+\varphi}}{1+\varphi}
\right].
\]

The welfare consumption index and habit-adjusted non-durable consumption are:

\[
X_t^b=(\widetilde C_t^b)^{1-\gamma \mathcal E_t^{D,b}}(D_t^b)^{\gamma \mathcal E_t^{D,b}},
\qquad
\widetilde C_t^b=C_t^b-h_c C_{t-1}^b.
\]

The budget constraint is:

\[
C_t^b+P_{D/C,t}I_{D,t}^b-B_{H,t}^b
=-R_{t-1}\frac{B_{H,t-1}^b}{\Pi_{C,t}}
+\sum_{j=C,D}\frac{W_{j,t}^bN_{j,t}^b}{P_{C,t}},
\qquad
I_{D,t}^b=D_t^b-(1-\delta)D_{t-1}^b.
\]

Borrowers face a binding collateral constraint:

\[
R_tB_{H,t}^b\le (1-\chi)(1-\delta)E_t\left[P_{D/C,t+1}D_t^b\Pi_{C,t+1}\right]\epsilon_t^{LTV}.
\]

### 2.2 Saver Household

The representative patient saver has the same period utility and consumption aggregator but can trade domestic and foreign bonds:

\[
\max_{\{C_t^s,D_t^s,B_{H,t}^s,B_{F,t}^s,N_{C,t}^s,N_{D,t}^s\}} E_0\sum_{t=0}^{\infty}\beta_s^t
\left[
\frac{(X_t^s)^{1-\sigma}}{1-\sigma}
- \sum_{j=C,D}\frac{(N_{j,t}^s)^{1+\varphi}}{1+\varphi}
\right].
\]

Its budget constraint is:

\[
C_t^s+P_{D/C,t}I_{D,t}^s-B_{H,t}^s-\mathfrak E_tB_{F,t}^s
=-R_{t-1}\frac{B_{H,t-1}^s}{\Pi_{C,t}}
-\frac{R_{t-1}^{\ast}\mathfrak E_tB_{F,t-1}^s}{\Pi_{C,t}}
+\sum_{j=C,D}\frac{W_{j,t}^sN_{j,t}^s}{P_{C,t}}.
\]

### 2.3 Firms and Price Setting

Final-good retailers aggregate differentiated intermediate goods in each sector:

\[
Y_{j,t}=\left(\int_0^1Y_{j,t}(k)^{-1/(1+\mu_t^j)}dk\right)^{1+\mu_t^j},
\qquad j=C,D.
\]

Intermediate producers use linear labor technology \(Y_{j,t}(k)=A_{j,t}N_{j,t}(k)\). Sectoral marginal costs combine household labor supply, habit-adjusted consumption, housing, terms of trade, sectoral productivity, and the relative housing price.

Price adjustment follows hybrid Calvo pricing. A fraction \(1-\theta_j\) resets prices; a fraction \(\tau_j\) of resetters is backward-looking.

### 2.4 Government and Monetary Authority

Government purchases a time-varying fraction of sectoral output and finances it with lump-sum taxation. Monetary policy is represented by a credible exchange-rate peg, so the exchange-rate change is set to zero and sectoral terms of trade absorb foreign and domestic inflation differentials.

## 3. First-Order Conditions

**Borrower household**

- **(F1) Borrower labor supply, both sectors**:

\[
\frac{W_{j,t}^b}{P_{C,t}}=
\frac{(X_t^b)^\sigma (N_{j,t}^b)^\varphi(\widetilde C_t^b)^{\gamma\mathcal E_t^{D,b}}}
{(1-\gamma\mathcal E_t^{D,b})(D_t^b)^{\gamma\mathcal E_t^{D,b}}},
\qquad j=C,D.
\]

- **(F2) Borrower housing Euler condition** (`needs_review`: OCR around powers and expectation term is fragile):

\[
\begin{aligned}
P_{D/C,t}={}&
\left(\frac{\gamma\mathcal E_t^{D,b}}{1-\gamma\mathcal E_t^{D,b}}\right)
\frac{\widetilde C_t^b}{D_t^b}
+(1-\chi)(1-\delta)\psi_tP_{D/C,t}E_t[\Pi_{D,t+1}]\epsilon_t^{LTV} \\
&+\beta_b(1-\delta)E_t\left[
\left(\frac{1-\gamma\mathcal E_{t+1}^{D,b}}{1-\gamma\mathcal E_t^{D,b}}\right)
\left(\frac{X_{t+1}^b}{X_t^b}\right)^{-\sigma}
\left(\frac{D_{t+1}^b}{\widetilde C_{t+1}^b}\right)^{\gamma\mathcal E_{t+1}^{D,b}}
(\widetilde C_t^b)^{\gamma\mathcal E_t^{D,b}}P_{D/C,t+1}
\right].
\end{aligned}
\]

- **(F3) Borrower Euler equation with collateral shadow value** (`needs_review`: OCR alternates between \(\mathcal E\) and \(\varepsilon\) in preference terms):

\[
R_t\psi_t=
1-\beta_bE_t\left[
\left(\frac{1-\gamma\mathcal E_{t+1}^{D,b}}{1-\gamma\mathcal E_t^{D,b}}\right)
\left(\frac{X_{t+1}^b}{X_t^b}\right)^{-\sigma}
\left(\frac{D_{t+1}^b}{\widetilde C_{t+1}^b}\right)^{\gamma\mathcal E_{t+1}^{D,b}}
\left(\frac{\widetilde C_t^b}{D_t^b}\right)^{\gamma\mathcal E_t^{D,b}}
\frac{R_t}{\Pi_{C,t+1}}
\right].
\]

**Saver household**

- **(F4) Saver labor supply, both sectors**:

\[
\frac{W_{j,t}^s}{P_{C,t}}=
\frac{(X_t^s)^\sigma (N_{j,t}^s)^\varphi(\widetilde C_t^s)^{\gamma\mathcal E_t^{D,s}}}
{(1-\gamma\mathcal E_t^{D,s})(D_t^s)^{\gamma\mathcal E_t^{D,s}}},
\qquad j=C,D.
\]

- **(F5) Saver housing Euler condition** (`needs_review`: MinerU formula contains malformed ratios):

\[
\begin{aligned}
P_{D/C,t}={}&
\left(\frac{\gamma\mathcal E_t^{D,s}}{1-\gamma\mathcal E_t^{D,s}}\right)
\frac{\widetilde C_t^s}{D_t^s} \\
&+\beta_s(1-\delta)E_t\left[
\left(\frac{1-\gamma\mathcal E_{t+1}^{D,s}}{1-\gamma\mathcal E_t^{D,s}}\right)
\left(\frac{X_{t+1}^s}{X_t^s}\right)^{-\sigma}
\left(\frac{D_{t+1}^s}{\widetilde C_{t+1}^s}\right)^{\gamma\mathcal E_{t+1}^{D,s}}
\left(\frac{\widetilde C_t^s}{D_t^s}\right)^{\gamma\mathcal E_t^{D,s}}
P_{D/C,t+1}
\right].
\end{aligned}
\]

- **(F6) Saver domestic-bond Euler equation**:

\[
1=\beta_sE_t\left[
\left(\frac{1-\gamma\mathcal E_{t+1}^{D,s}}{1-\gamma\mathcal E_t^{D,s}}\right)
\left(\frac{X_{t+1}^s}{X_t^s}\right)^{-\sigma}
\left(\frac{D_{t+1}^s}{\widetilde C_{t+1}^s}\right)^{\gamma\mathcal E_{t+1}^{D,s}}
\left(\frac{\widetilde C_t^s}{D_t^s}\right)^{\gamma\mathcal E_t^{D,s}}
\frac{R_t}{\Pi_{C,t+1}}
\right].
\]

- **(F7) Saver foreign-bond Euler/risk-sharing condition** (`needs_review`: source OCR has malformed exchange-rate notation):

\[
1=\beta_sE_t\left[
\left(\frac{1-\gamma\mathcal E_{t+1}^{D,s}}{1-\gamma\mathcal E_t^{D,s}}\right)
\left(\frac{X_{t+1}^s}{X_t^s}\right)^{-\sigma}
\left(\frac{D_{t+1}^s}{\widetilde C_{t+1}^s}\right)^{\gamma\mathcal E_{t+1}^{D,s}}
\left(\frac{\widetilde C_t^s}{D_t^s}\right)^{\gamma\mathcal E_t^{D,s}}
\frac{\mathfrak E_{t+1}}{\mathfrak E_t}\frac{R_t^{\ast}}{\Pi_{C,t+1}}
\right].
\]

## 4. Market Clearing & Identities

- **(F8) Non-durable Armington aggregator**:

\[
C_t=\left[
(1-\alpha_C)^{1/\eta_C}C_{H,t}^{(\eta_C-1)/\eta_C}
+\alpha_C^{1/\eta_C}C_{F,t}^{(\eta_C-1)/\eta_C}
\right]^{\eta_C/(\eta_C-1)}.
\]

- **(F9) Durable Armington aggregator**:

\[
D_t=\left[
(1-\alpha_D)^{1/\eta_D}D_{H,t}^{(\eta_D-1)/\eta_D}
+\alpha_D^{1/\eta_D}D_{F,t}^{(\eta_D-1)/\eta_D}
\right]^{\eta_D/(\eta_D-1)}.
\]

- **(F10) Sectoral price indexes**:

\[
P_{C,t}=\left[(1-\alpha_C)P_{C,H,t}^{1-\eta_C}+\alpha_CP_{C,F,t}^{1-\eta_C}\right]^{1/(1-\eta_C)},
\quad
P_{D,t}=\left[(1-\alpha_D)P_{D,H,t}^{1-\eta_D}+\alpha_DP_{D,F,t}^{1-\eta_D}\right]^{1/(1-\eta_D)}.
\]

- **(F11) Relative terms-of-trade identity**:

\[
(1-\alpha_C)\widehat s_{C,t}-(1-\alpha_D)\widehat s_{D,t}
=\widehat p_{D/C,t}-\widehat p_{D/C,t}^{\ast}.
\]

- **(F12) International risk-sharing condition for patient households**:

\[
\left(\frac{X_t^s}{X_t^{s,\ast}}\right)^{-\sigma}
\left(\frac{(\widetilde C_t^s)^{\mathcal E_t^{D,s}}}{(\widetilde C_t^{s,\ast})^{\mathcal E_t^{D,\ast}}}\right)^\gamma
\left(\frac{(D_t^s)^{\mathcal E_t^{D,s}}}{(D_t^{s,\ast})^{\mathcal E_t^{D,\ast}}}\right)^\gamma
=\mathcal R_t.
\]

- **(F13) Retail aggregation technology**:

\[
Y_{j,t}=\left(\int_0^1Y_{j,t}(k)^{-1/(1+\mu_t^j)}dk\right)^{1+\mu_t^j},
\qquad j=C,D.
\]

- **(F14) Sectoral marginal cost, consumption sector**:

\[
MC_{C,t}=
\frac{X_t^\sigma N_{C,t}^\varphi \widetilde C_t^{\gamma\mathcal E_t^D}S_{C,t}^{\alpha_C}}
{(1-\gamma\mathcal E_t^D)D_t^{\gamma\mathcal E_t^D}A_{C,t}}.
\]

- **(F15) Sectoral marginal cost, housing sector**:

\[
MC_{D,t}=
\frac{X_t^\sigma N_{D,t}^\varphi \widetilde C_t^{\gamma\mathcal E_t^D}S_{D,t}^{\alpha_D}}
{(1-\gamma\mathcal E_t^D)D_t^{\gamma\mathcal E_t^D}A_{D,t}P_{D/C,t}}.
\]

- **(F16) Hybrid Calvo mark-up rule**:

\[
\bar p_{j,H,t}^{n}=
\widehat\mu_t^j+(1-\beta_s\theta_j)
\sum_{k=0}^{\infty}(\beta_s\theta_j)^kE_t(mc_{j,t+k}+p_{j,H,t}).
\]

- **(F17) Consumption-goods market clearing, log-linearized**:

\[
\widehat y_{C,t}=(1-\alpha_C)\widehat c_t+\alpha_C\widehat c_t^{\ast}
+\alpha_C\vartheta_C\widehat s_{C,t}+g_t.
\]

- **(F18) Housing-goods market clearing, log-linearized**:

\[
\widehat y_{D,t}=(1-\alpha_D)\widehat i_{D,t}+\alpha_D\widehat i_{D,t}^{\ast}
+\alpha_D\vartheta_D\widehat s_{D,t}+g_t.
\]

- **(F19) Aggregate real output identity, log-linearized**:

\[
\widehat y_t=
\frac{P_{D/C}^{-\xi}C}{Y}\widehat y_{C,t}
+\frac{\delta P_{D/C}^{1-\xi}D}{Y}\widehat y_{D,t}
+\Xi\widehat p_{D/C,H,t}
-\xi\ln(P_{D/C})(\varepsilon_t^D+\varepsilon_t^{D,\ast}).
\]

- **(F20) Currency-board peg and terms-of-trade adjustment**:

\[
\widehat e_t=0,\qquad
\Delta\widehat s_{C,t}=\widehat\pi_{C,F,t}-\widehat\pi_{C,H,t},\qquad
\Delta\widehat s_{D,t}=\widehat\pi_{D,F,t}-\widehat\pi_{D,H,t}.
\]

## 5. Exogenous Processes

- **(F21) Sectoral technology shocks**:

\[
a_{j,t}=\rho_{a_j}a_{j,t-1}+\varepsilon_t^{a_j},\qquad j=C,D.
\]

- **(F22) Sectoral mark-up shocks, ARMA(1,1)**:

\[
\epsilon_t^{\mu_j}=\rho_{\mu_j}^{+}\epsilon_{t-1}^{\mu_j}
+\varepsilon_t^{\mu_j}-\rho_{\mu_j}^{-}\varepsilon_{t-1}^{\mu_j},
\qquad j=C,D.
\]

- **(F23) Loan-to-value shock**:

\[
\epsilon_t^{LTV}=\rho_{LTV}\epsilon_{t-1}^{LTV}+\varepsilon_t^{LTV}.
\]

- **(F24) Housing preference shocks**:

\[
\epsilon_t^{d,j}=\rho_{d,j}\epsilon_{t-1}^{d,j}+\varepsilon_t^{d,j},
\qquad j=s,b,\ast.
\]

- **(F25) Government expenditure shock**:

\[
g_t=\rho_g g_{t-1}+\varepsilon_t^g.
\]

- **(F26) Foreign non-durable consumption demand**:

\[
\widehat c_t^{\ast}=\rho_{c^{\ast}}\widehat c_{t-1}^{\ast}+\varepsilon_t^{c^{\ast}}.
\]

- **(F27) Foreign housing investment demand**:

\[
\widehat i_{D,t}^{\ast}=\rho_{d^{\ast}}\widehat d_{t-1}^{\ast}+\varepsilon_t^{d^{\ast}}.
\]

- **(F28) Foreign housing-price disturbance**:

\[
\widehat p_{D,t}^{\ast}=\rho_{p_D^{\ast}}\widehat p_{D,t-1}^{\ast}+\varepsilon_t^{p_D^{\ast}}.
\]

- **(F29) Foreign consumption-price disturbance**:

\[
\widehat p_{C,t}^{\ast}=\rho_{p_C^{\ast}}\widehat p_{C,t-1}^{\ast}+\varepsilon_t^{p_C^{\ast}}.
\]

## 6. Steady-State Solution

- The MMB implementation is `model(linear)`. Endogenous model variables are deviations from the deterministic steady state, so the Dynare `initval` block sets inflation variables such as `pi_c_h` and `pi_d_h` to zero and uses implicit zero steady states for the remaining linear variables.
- Calibration constants are computed before the `model(linear)` block. Key source-implied values include \(\beta_s=0.99\), \(\beta_b=0.96\), \(\delta=0.01\), a 60 percent LTV calibration through \(\chi=0.4\), sectoral mark-ups \(\mu_C=\mu_D=0.1\), steady-state hours \(N=0.3\), and a housing-sector output share \(\xi=0.1\).
- Relative steady-state quantities in the implementation include \(PDC=(1+\mu_D)/(1+\mu_C)\), borrower and saver consumption-housing ratios, borrower debt-to-consumption, sectoral labor allocations, and aggregation weights such as `CBC`, `CSC`, `DBD`, and `DSD`.
- The nonlinear paper equations imply the steady state is pinned down by the patient discount factor, sectoral price markups, depreciation, collateral parameters, and the housing/non-housing expenditure shares. Exact reproduction of all steady-state algebra is deferred to runtime replication because the archive task does not execute Dynare.

## 7. Timing & Form Conventions

- **Timing**: residential stock \(D_t^q\) is a stock held by household type \(q\in\{b,s\}\); housing investment is \(I_{D,t}^q=D_t^q-(1-\delta)D_{t-1}^q\).
- **Debt timing**: \(B_{H,t}^b\) is borrower domestic debt chosen in period \(t\) and repaid next period; the collateral constraint ties \(R_tB_{H,t}^b\) to expected future collateral value.
- **Prices**: \(P_{D/C,t}\) is the relative price of residential goods in units of non-residential goods; CPI inflation is \(\Pi_{C,t}\); sectoral home inflation appears as \(\pi_{C,H,t}\) and \(\pi_{D,H,t}\) in the linear implementation.
- **Open economy**: savers trade foreign bonds and satisfy an international risk-sharing condition; borrowers cannot finance expenditures in international markets.
- **Currency board**: the nominal exchange rate is fixed, \(\widehat e_t=0\), and monetary conditions are transmitted through terms of trade and foreign variables rather than a Taylor rule.
- **Model form**: final implementation form is log-linear `model(linear)`. Lower-case hatted variables in the paper correspond to log deviations; variables such as interest and inflation are deviations from trend/steady state.
- **Implementation cross-check**: `.agents/skills/dynare-copilot/references/examples/HK_FP13_rep.mod` contains 33 endogenous variables and 13 exogenous innovations; it confirms the linear form, borrower/saver split, sectoral shocks, foreign blocks, and two active shock standard deviations for `epsd_s` and `epsd_b` in the Rep-MMB run.

## 8. Variable & Parameter Reference Table

### Endogenous variables

| Symbol / ASCII | Meaning | Main condition(s) |
|---|---|---|
| \(c\), \(c_b\), \(c_s\) | aggregate, borrower, and saver consumption | (F1)-(F7), (F17), implementation aggregation |
| \(d\), \(d_b\), \(d_s\) | aggregate, borrower, and saver housing stocks | (F2), (F5), (F9), (F18) |
| \(b_b\) | borrower domestic debt | (F3), collateral constraint |
| \(\psi\) | borrower marginal value of borrowing | (F2), (F3) |
| \(n\), \(n_C\), \(n_D\) | aggregate and sectoral labor | (F1), (F4), (F14), (F15) |
| \(n_C^b,n_D^b,n_C^s,n_D^s\) | type-sector labor supplies | (F1), (F4), implementation wage equations |
| \(y\), \(y_C\), \(y_D\) | aggregate and sectoral output | (F13), (F17)-(F19) |
| \(mc_C\), \(mc_D\) | sectoral real marginal costs | (F14), (F15), (F16) |
| \(p_{D/C}\) | relative housing price | (F2), (F5), (F10), (F11), (F19) |
| \(\pi_C\), \(\pi_{C,H}\), \(\pi_{D,H}\) | CPI and sectoral domestic inflation | (F10), (F16), (F20) |
| \(r\) | domestic nominal interest-rate deviation in implementation | (F3), (F6), (F7) |
| \(s_C\), \(s_D\) | sectoral terms of trade | (F11), (F17), (F18), (F20) |
| \(wp_C\), \(wp_D\) | real wages by sector in implementation | (F1), (F4), marginal-cost equations |
| \(a_C\), \(a_D\) | sectoral technology states | (F21) |
| `shock_mu_c`, `shock_mu_d` | sectoral mark-up states | (F22) |
| `LTV` | loan-to-value state | (F23) |
| `shock_d_b`, `shock_d_s`, `shock_d_stern` | housing preference states | (F24) |
| \(c^{\ast}\), \(i_D^{\ast}\), \(p_C^{\ast}\), \(p_D^{\ast}\), \(p_{D/C}^{\ast}\) | foreign demand and price states | (F26)-(F29), (F11) |
| \(g\) | government spending state | (F25) |

### Exogenous innovations

| ASCII | Meaning |
|---|---|
| `epsa_c`, `epsa_d` | sectoral technology innovations |
| `epsmu_c`, `epsmu_d` | sectoral mark-up innovations |
| `epsLTV` | loan-to-value innovation |
| `epsd_b`, `epsd_s`, `epsd_stern` | borrower, saver, and foreign housing-preference innovations |
| `epsc_ast`, `epsd_ast` | foreign non-durable consumption and housing-investment innovations |
| `epsg` | government expenditure innovation |
| `epsp_c_ast`, `epsp_d_ast` | foreign price innovations |

### Parameters and calibration constants

| ASCII / Symbol | Meaning | Source note |
|---|---|---|
| \(\beta_b\), \(\beta_s\) | borrower and saver discount factors | paper calibration; implementation `beta_b=0.96`, `beta_s=0.99` |
| \(\sigma\), \(\varphi\) | consumption curvature and labor curvature | estimated/calibrated |
| \(\gamma\) | housing weight in utility | estimated |
| \(h_c\) | habit in non-durable consumption | estimated |
| \(\delta\) | housing depreciation | calibrated at 0.01 quarterly |
| \(\chi\) | non-collateralizable housing fraction | maps to LTV \(1-\chi\) |
| \(\alpha_C\), \(\alpha_D\) | sectoral openness parameters | estimated/calibrated |
| \(\eta_C,\eta_D,\zeta_C,\zeta_D\) | Armington and rest-of-world substitution elasticities | calibrated at 2 in paper/implementation |
| \(\mu_C,\mu_D\) | steady-state mark-ups | calibrated at 0.1 |
| \(\theta_C,\theta_D,\tau_C,\tau_D\) | hybrid Calvo parameters | estimated |
| \(\rho\) parameters | persistence/ARMA coefficients for shocks | estimated |
| `CBDB`, `CSDS`, `BHCB`, `CBC`, `CSC`, `DBD`, `DSD` | steady-state ratios and aggregation weights | implementation cross-check constants |

**Equation count**: 29 numbered conditions, (F1)-(F29). The Chinese translation must preserve the same count.
