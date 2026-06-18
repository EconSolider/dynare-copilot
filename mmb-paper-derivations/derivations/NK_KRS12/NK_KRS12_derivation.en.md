# NK_KRS12 -- Derivation (Optimization Problems + First-Order Conditions)

> Private model-archive draft for Dynare-oriented review. Runtime validation was not performed.

Provenance: `NK_KRS12`, Kannan, Prakash; Rabanal, Pau; Scott, Alasdair M. (2012), "Monetary and macroprudential policy rules in a model with house price booms," DOI `10.1515/1935-1690.2268`. Primary source Markdown: `raw/mmb_mineru/runs/nk_krs12__monetary_and_macroprudential_policy_rules_in_a_model_with_house_price_bo__fb846d59/full.md`. Raw PDF: `raw/mmb_papers/Monetary and macroprudential policy rules in a model with house price booms.pdf`. MinerU run id: `fb846d59-b45c-4f6d-96d6-d7fb0f6fd4dc`.

## 1. Model Overview

- **Model**: Two-sector New Keynesian housing model with savers, borrowers, financial intermediaries, durable and nondurable goods producers, monetary policy, and a macroprudential spread instrument.
- **Core mechanism**: Borrowers finance housing through intermediaries. The lending spread depends on borrower leverage, a financial shock, and, in selected regimes, a macroprudential instrument tied to nominal credit growth.
- **Sectors**: Nondurable goods use labor and a TFP shock; durable goods/housing use labor. Prices in both sectors are sticky with Calvo pricing and lagged indexation.
- **Policy regimes**: Taylor rule, augmented Taylor rule with credit growth, and augmented Taylor rule plus macroprudential policy.
- **Model form**: `model(linear)`. Lowercase variables in the appendix and MMB implementation are log-linear deviations from steady state; growth-rate variables are first differences such as `deltac` and `deltapC`.
- **Status**: `needs_review`. The paper appendix provides a compact log-linear system, but OCR damages several symbols and equation numbers.

## 2. Optimization Problems

### 2.1 Savers

Each saver \(j \in [0,\lambda]\) maximizes expected discounted utility over nondurable consumption, housing services, and labor:

\[
E_0 \sum_{t=0}^{\infty} \beta^t
\left[
\gamma \log(C_t^j-\varepsilon C_{t-1})
+(1-\gamma)\xi_t^D \log(D_t^j)
-\frac{(L_t^j)^{1+\varphi}}{1+\varphi}
\right].
\]

Labor is a CES-like aggregate across nondurable and durable sectors:

\[
L_t^j =
\left[
\alpha^{-\iota_L}(L_t^{C,j})^{1+\iota_L}
+(1-\alpha)^{-\iota_L}(L_t^{D,j})^{1+\iota_L}
\right]^{1/(1+\iota_L)}.
\]

The nominal budget constraint is

\[
P_t^C C_t^j + P_t^D I_t^j + B_t^j
\leq
R_{t-1}B_{t-1}^j + W_t^C L_t^{C,j} + W_t^D L_t^{D,j} + \Pi_t^j.
\]

Housing evolves according to

\[
D_t^j = (1-\delta)D_{t-1}^j
+ \left[1-S\left(\frac{I_t^j}{I_{t-1}^j}\right)\right] I_t^j.
\]

### 2.2 Borrowers

Each borrower \(j \in [\lambda,1]\) solves the analogous problem with discount factor \(\beta^B < \beta\):

\[
E_0 \sum_{t=0}^{\infty} (\beta^B)^t
\left[
\gamma \log(C_t^{B,j}-\varepsilon C_{t-1}^B)
+(1-\gamma)\xi_t^D \log(D_t^{B,j})
-\frac{(L_t^{B,j})^{1+\varphi}}{1+\varphi}
\right].
\]

The borrower budget constraint is

\[
P_t^C C_t^{B,j}+P_t^D I_t^{B,j}+R_{t-1}^L B_{t-1}^{B,j}
\leq
B_t^{B,j}+W_t^C L_t^{C,B,j}+W_t^D L_t^{D,B,j}.
\]

Borrower housing and labor aggregators have the same functional forms as savers. Borrower Euler conditions use the lending rate \(R_t^L\) rather than the saver deposit rate \(R_t\).

### 2.3 Financial Intermediaries

Intermediaries take deposits from savers and lend to borrowers. The lending spread is assumed rather than derived from intermediary optimization:

\[
\frac{R_t^L}{R_t}
= v_t F\left(\frac{B_t^B}{P_t^D D_t^B}\right)\tau_t.
\]

Here \(v_t\) is a financial shock, \(F(\cdot)\) is increasing in the loan-to-value ratio, and \(\tau_t\) is the macroprudential instrument.

### 2.4 Producers

Final-goods producers aggregate differentiated intermediate goods in each sector using CES technology. For durable goods,

\[
Y_t^D =
\left[
\int_0^1 Y_t^D(i)^{(\sigma_D-1)/\sigma_D}\,di
\right]^{\sigma_D/(\sigma_D-1)}.
\]

Intermediate goods producers set prices subject to Calvo restrictions. Production is labor-only:

\[
Y_t^C(i)=A_t^C L_t^C(i), \qquad
Y_t^D(i)=L_t^D(i).
\]

The durable-sector pricing problem chooses \(\hat P_t^D\) to maximize discounted expected profits under Calvo non-adjustment probability \(\theta_D\) and indexation \(\varphi_D\); the nondurable sector has the analogous problem with sector-\(C\) notation.

## 3. First-Order Conditions

The following equilibrium conditions are the paper appendix's log-linear form, renumbered continuously as `(F1)` through `(F29)` for this archive entry. Lowercase variables are log deviations. `needs_review` flags reflect OCR-damaged symbols or equation labels in the Markdown source.

- **(F1) Saver residential-investment FOC**:

\[
q_t - \frac{c_t-\varepsilon c_{t-1}}{1-\varepsilon}
+ \eta(i_t-i_{t-1})
= \mu_t + \beta\eta(E_t i_{t+1}-i_t).
\]

- **(F2) Saver housing-stock shadow value**:

\[
\left[1-\beta(1-\delta)\right](\xi_t^D-d_t)
= \mu_t-\beta(1-\delta)E_t\mu_{t+1}.
\]

- **(F3) Saver Euler equation for nondurable consumption**:

\[
\varepsilon \Delta c_t
= E_t\Delta c_{t+1}
-(1-\varepsilon)(r_t-E_t\Delta p_{t+1}^C).
\]

- **(F4) Saver labor supply, nondurable sector**:

\[
\frac{c_t-\varepsilon c_{t-1}}{1-\varepsilon}
+[(\varphi-\iota_L)\alpha+\iota_L]l_t^C
+(\varphi-\iota_L)(1-\alpha)l_t^D
= \omega_t^C.
\]

- **(F5) Saver labor supply, durable sector**:

\[
\frac{c_t-\varepsilon c_{t-1}}{1-\varepsilon}
+[(\varphi-\iota_L)(1-\alpha)+\iota_L]l_t^D
+(\varphi-\iota_L)\alpha l_t^C
= \omega_t^D.
\]

- **(F6) Borrower residential-investment FOC**:

\[
q_t - \frac{c_t^B-\varepsilon c_{t-1}^B}{1-\varepsilon}
+ \eta(i_t^B-i_{t-1}^B)
= \mu_t^B + \beta^B\eta(E_t i_{t+1}^B-i_t^B).
\]

- **(F7) Borrower housing-stock shadow value**:

\[
\left[1-\beta^B(1-\delta)\right](\xi_t^D-d_t^B)
= \mu_t^B-\beta^B(1-\delta)E_t\mu_{t+1}^B.
\]

- **(F8) Borrower Euler equation with lending rate**:

\[
\varepsilon \Delta c_t^B
= E_t\Delta c_{t+1}^B
-(1-\varepsilon)(r_t^L-E_t\Delta p_{t+1}^C).
\]

- **(F9) Borrower labor supply, nondurable sector**:

\[
\frac{c_t^B-\varepsilon c_{t-1}^B}{1-\varepsilon}
+[(\varphi-\iota_L)\alpha+\iota_L]l_t^{B,C}
+(\varphi-\iota_L)(1-\alpha)l_t^{B,D}
= \omega_t^C.
\]

- **(F10) Borrower labor supply, durable sector**:

\[
\frac{c_t^B-\varepsilon c_{t-1}^B}{1-\varepsilon}
+[(\varphi-\iota_L)(1-\alpha)+\iota_L]l_t^{B,D}
+(\varphi-\iota_L)\alpha l_t^{B,C}
= \omega_t^D.
\]

- **(F11) Borrower budget constraint**:

\[
C^B c_t^B + I^B(q_t+i_t^B)
+R^L B^B(r_{t-1}^L+b_{t-1}^B-\Delta p_t^C)
=
B^B b_t^B
+\alpha W L^B(\omega_t^C+l_t^{C,B})
+(1-\alpha)W L^B(\omega_t^D+l_t^{D,B}).
\]

- **(F12) Effective lending rate / spread with macroprudential rule**:

\[
r_t^L
= r_t+\kappa(b_t^B-d_t^B-q_t)-v_t
+\tau(b_{t-1}^B-b_{t-2}^B+\Delta p_{t-1}^C).
\]

- **(F13) Relative price of housing**:

\[
q_t=q_{t-1}+\Delta p_t^D-\Delta p_t^C.
\]

- **(F14) Nondurable production**:

\[
y_t^C=a_t^C+l_t^{C,tot}.
\]

- **(F15) Durable production**:

\[
y_t^D=l_t^{D,tot}.
\]

- **(F16) Nondurable-sector New Keynesian Phillips curve**:

\[
\Delta p_t^C-\varphi_C\Delta p_{t-1}^C
=\beta E_t(\Delta p_{t+1}^C-\varphi_C\Delta p_t^C)
+\kappa^C(\omega_t^C-a_t^C).
\]

- **(F17) Durable-sector New Keynesian Phillips curve** (`needs_review`: paper OCR shows an extra `a_t^D`; implementation omits a durable TFP shock and uses \(\omega_t^D-q_t\)):

\[
\Delta p_t^D-\varphi_D\Delta p_{t-1}^D
=\beta E_t(\Delta p_{t+1}^D-\varphi_D\Delta p_t^D)
+\kappa^D(\omega_t^D-q_t).
\]

## 4. Market Clearing & Identities

- **(F18) Nondurable goods market clearing**:

\[
y_t^C=
\frac{\lambda C c_t+(1-\lambda)C^B c_t^B}
{\lambda C+(1-\lambda)C^B}.
\]

- **(F19) Durable goods market clearing**:

\[
y_t^D=
\frac{\lambda\delta D i_t+(1-\lambda)\delta D^B i_t^B}
{\lambda\delta D+(1-\lambda)\delta D^B}.
\]

- **(F20) Saver housing stock law of motion**:

\[
d_t=(1-\delta)d_{t-1}+\delta i_t.
\]

- **(F21) Borrower housing stock law of motion**:

\[
d_t^B=(1-\delta)d_{t-1}^B+\delta i_t^B.
\]

- **(F22) Nondurable-sector total labor**:

\[
l_t^{C,tot}=
\frac{\lambda L l_t^C+(1-\lambda)L^B l_t^{C,B}}
{\lambda L+(1-\lambda)L^B}.
\]

- **(F23) Durable-sector total labor**:

\[
l_t^{D,tot}=
\frac{\lambda L l_t^D+(1-\lambda)L^B l_t^{D,B}}
{\lambda L+(1-\lambda)L^B}.
\]

- **(F24) Credit-market clearing**:

\[
\lambda b_t+(1-\lambda)b_t^B=0.
\]

- **(F25) Borrower nominal-credit growth identity**:

\[
\Delta b_t^B=b_t^B-b_{t-1}^B+\Delta p_t^C.
\]

- **(F26) Aggregate real GDP**:

\[
y_t=\alpha y_t^C+(1-\alpha)y_t^D.
\]

- **(F27) Taylor rule with credit-growth augmentation**:

\[
r_t=\gamma_r r_{t-1}
+(1-\gamma_r)\left[
\gamma_\pi \Delta p_{t-1}^C
+\gamma_y(y_{t-1}-y_{t-1}^{\ast})
+\gamma_b(b_{t-1}^B-b_{t-2}^B+\Delta p_{t-1}^C)
\right].
\]

`needs_review`: Appendix equation (53) places the factor \((1-\gamma_r)\) ambiguously in the OCR; the implementation applies it to all non-lagged policy responses.

## 5. Exogenous Processes

- **(F28) Nondurable-sector TFP shock**:

\[
a_t^C=\rho_a a_{t-1}^C+\varepsilon_t^a.
\]

- **(F29) Housing demand and financial shocks**:

\[
\xi_t^D=\rho_d\xi_{t-1}^D+\varepsilon_t^d,
\qquad
v_t=\rho_v v_{t-1}+\varepsilon_t^v.
\]

## 6. Steady-State Solution

Because `NK_KRS12` is represented in `model(linear)` form, the dynamic variables in the equilibrium system are log deviations or growth-rate deviations around the calibrated deterministic steady state. The steady state used by the linear model is therefore zero for endogenous deviations and shock innovations:

\[
\bar q=\bar c=\bar i=\bar \mu=\bar d=\bar r=\bar b=\bar p^C=\bar p^D
=\bar y=\bar y^{\ast}=\bar a^C=\bar \xi^D=\bar v=0.
\]

The level steady-state constants appearing in the linear equations are calibrated rather than solved in this archive entry. The implementation cross-check reports:

\[
\beta=0.99,\quad \beta^B=0.98,\quad \delta=0.025,\quad
\lambda=0.5,\quad \alpha=0.9,\quad \gamma=0.5378.
\]

Selected level constants are

\[
C=1.5893,\quad C^B=1.3705,\quad D=7.8610,\quad D^B=5.2936,\quad
I^B=0.1323,\quad B^B=4.2349,\quad R^L=1.0204,\quad W=0.9.
\]

Runtime validation, residual checks, and Dynare execution were not performed.

## 7. Timing & Form Conventions

- The model is linearized around steady state; lowercase variables denote log-linear deviations, and `Delta` variables denote first differences.
- Housing stocks \(d_t\) and \(d_t^B\) are predetermined stock variables in laws of motion (F20)-(F21), with production/investment choices affecting the current-period stock.
- Borrower debt \(b_t^B\) is a stock chosen in the current period; borrower budget costs include lagged debt and lagged lending rates.
- The policy rule reacts to lagged CPI inflation, lagged output gap, and lagged nominal credit growth.
- The `.mod` file used for implementation cross-check is the augmented Taylor plus macroprudential regime. Other policy regimes in the paper set \(\gamma_b=0\) and/or \(\tau=0\), or optimize the coefficients.
- Potential output \(y_t^{\ast}\) is defined in the paper as GDP dynamics under flexible prices, no financial constraints, and homogeneous agents. The MMB implementation supplies auxiliary laws for `yCstar`, `yDstar`, and `dstar`; these are implementation details and remain cross-check evidence, not paper-side derivation equations.

## 8. Variable & Parameter Reference Table

### Endogenous Variables

| ASCII name | Mathematical symbol | Meaning | Main equation |
|---|---|---|---|
| `q` | \(q_t\) | Relative price of housing, \(P_t^D/P_t^C\) | (F13) |
| `c` | \(c_t\) | Saver nondurable consumption | (F3) |
| `i` | \(i_t\) | Saver residential investment | (F1) |
| `mu` | \(\mu_t\) | Saver housing shadow value | (F2) |
| `d` | \(d_t\) | Saver housing stock | (F20) |
| `r` | \(r_t\) | Deposit/policy rate deviation | (F27) |
| `deltac` | \(\Delta c_t\) | Saver consumption growth | (F3) |
| `deltap` | \(\Delta p_t\) | Aggregate inflation | identity/cross-check |
| `deltapC` | \(\Delta p_t^C\) | CPI/nondurable inflation | (F16) |
| `b` | \(b_t\) | Saver deposits | (F24) |
| `p`, `pC`, `pD` | \(p_t,p_t^C,p_t^D\) | Price-level deviations | (F13), identities |
| `deltapD` | \(\Delta p_t^D\) | Durable/house-price inflation | (F17) |
| `lC`, `lD` | \(l_t^C,l_t^D\) | Saver labor by sector | (F4), (F5) |
| `wC`, `wD` | \(\omega_t^C,\omega_t^D\) | Real wage deviations | (F4), (F5), (F16), (F17) |
| `cB` | \(c_t^B\) | Borrower consumption | (F8) |
| `deltacB` | \(\Delta c_t^B\) | Borrower consumption growth | (F8) |
| `iB` | \(i_t^B\) | Borrower residential investment | (F6) |
| `muB` | \(\mu_t^B\) | Borrower housing shadow value | (F7) |
| `dB` | \(d_t^B\) | Borrower housing stock | (F21) |
| `lCB`, `lDB` | \(l_t^{C,B},l_t^{D,B}\) | Borrower labor by sector | (F9), (F10) |
| `rL` | \(r_t^L\) | Borrower lending rate | (F12) |
| `bB` | \(b_t^B\) | Borrower debt | (F11), (F24), (F25) |
| `aC` | \(a_t^C\) | Nondurable TFP | (F28) |
| `xiD` | \(\xi_t^D\) | Housing preference shock state | (F29) |
| `v` | \(v_t\) | Financial shock state | (F29) |
| `lCtot`, `lDtot` | \(l_t^{C,tot},l_t^{D,tot}\) | Total labor by sector | (F22), (F23) |
| `y` | \(y_t\) | Aggregate GDP | (F26) |
| `ystar` | \(y_t^{\ast}\) | Potential output | policy-rule input |
| `yC`, `yD` | \(y_t^C,y_t^D\) | Sectoral output | (F14), (F15), (F18), (F19) |
| `yCstar`, `yDstar`, `dstar` | \(y_t^{C,\ast},y_t^{D,\ast},d_t^{\ast}\) | Potential-output auxiliaries | implementation cross-check |
| `deltabB` | \(\Delta b_t^B\) | Nominal credit growth | (F25) |

### Exogenous Shocks

| ASCII name | Mathematical symbol | Meaning |
|---|---|---|
| `eps_A` | \(\varepsilon_t^a\) | Nondurable-sector TFP innovation |
| `eps_D` | \(\varepsilon_t^d\) | Housing demand innovation |
| `eps_v` | \(\varepsilon_t^v\) | Financial/lending-spread innovation |

### Parameters

| ASCII name | Mathematical symbol | Meaning |
|---|---|---|
| `epsilon` | \(\varepsilon\) | Habit formation |
| `eta` | \(\eta\) | Residential investment adjustment cost curvature |
| `beta` | \(\beta\) | Saver discount factor |
| `betaB` | \(\beta^B\) | Borrower discount factor |
| `delta` | \(\delta\) | Housing depreciation |
| `lL` | \(\iota_L\) | Labor reallocation/switching cost |
| `phi` | \(\varphi\) | Inverse Frisch elasticity |
| `alpha` | \(\alpha\) | Nondurable sector share in GDP / labor aggregator share |
| `gamma` | \(\gamma\) | Nondurable utility weight |
| `lambda` | \(\lambda\) | Share of savers |
| `kappa` | \(\kappa\) | Spread elasticity to loan-to-value |
| `kappaC`, `kappaD` | \(\kappa^C,\kappa^D\) | Phillips-curve slopes |
| `phiC`, `phiD` | \(\varphi_C,\varphi_D\) | Sectoral inflation indexation |
| `thetaC`, `thetaD` | \(\theta_C,\theta_D\) | Calvo non-adjustment probabilities |
| `gammaR` | \(\gamma_r\) | Interest-rate smoothing |
| `gammapi` | \(\gamma_\pi\) | Policy response to CPI inflation |
| `gammay` | \(\gamma_y\) | Policy response to output gap |
| `gammab` | \(\gamma_b\) | Policy response to nominal credit growth |
| `tau` | \(\tau\) | Macroprudential response to nominal credit growth |
| `rhoC`, `rhoD`, `rhov` | \(\rho_a,\rho_d,\rho_v\) | Shock persistence |
| `C`, `D`, `CB`, `DB`, `IB`, `RL`, `BB`, `W`, `L`, `LB` | level constants | Linearization steady-state constants |
