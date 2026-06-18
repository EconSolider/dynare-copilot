# CL_MS07 - Source-Backed Model Derivation

> First-pass extraction for the private MMB model archive. Status: `needs_review`.
> Runtime validation was not performed.

## 1. Model Overview

- **Model ID**: `CL_MS07`.
- **Paper**: Juan Pablo Medina and Claudio Soto (2007), "The Chilean business cycles through the lens of a stochastic general equilibrium model", Central Bank of Chile Working Paper 457.
- **Source**: `raw/mmb_mineru/runs/cl_ms07__the_chilean_business_cycles_through_the_lens_of_a_stochastic_general_equ__ba200544/full.md`; raw PDF provenance only, not read by default: `raw/mmb_papers/The Chilean business cycles through the lens of a stochastic general equilibrium model.pdf`.
- **DOI**: not listed in `raw/mmb_mineru/model_index.csv`.
- **Economy and purpose**: estimated open-economy DSGE model for Chile, using quarterly data from 1987:Q1 to 2005:Q4 to decompose business-cycle fluctuations.
- **Main agents and sectors**: Ricardian households, non-Ricardian households, wage setters, capital/investment firm, domestic intermediate producers, import retailers, commodity export sector, fiscal authority, monetary authority, and foreign sector.
- **Model form**: log-linearized rational expectations system. The implementation cross-check file uses `model(linear)`. Equations below are expressed as log deviations unless a nonlinear source equation is explicitly shown.
- **Major frictions and shocks**: external borrowing premium, habit formation, Calvo wages, Calvo domestic and import prices with indexation, investment adjustment costs, structural fiscal rule, two monetary-policy regimes, copper and oil shocks, permanent and transitory productivity shocks, foreign demand/inflation/interest shocks, preference, labor, fiscal, investment, and monetary shocks.

## 2. Optimization Problems

### Ricardian households

Ricardian households maximize expected utility with habit formation, labor disutility, and real money balances:

\[
E_t \sum_{i=0}^{\infty}\beta^i \zeta_{C,t+i}
\left[
\log(C_{t+i}(j)-\tilde h C_{t+i-1})
-\zeta_{L,t+i}\frac{l_{t+i}(j)^{1+\sigma_L}}{1+\sigma_L}
+\frac{\zeta_{\mathcal M}}{\mu}\left(\frac{\mathcal M_{t+i}(j)}{P_{C,t+i}}\right)^\mu
\right].
\]

They choose consumption, money, foreign bonds, and state-contingent domestic claims subject to the nominal budget constraint with labor income, profits, taxes, domestic contingent claims, money, and foreign-bond positions. The external premium is a function of aggregate net foreign assets:

\[
\mathcal B_t^{\ast}=\frac{\mathcal E_t B_t^{\ast}}{P_{Y,t}Y_t}, \qquad \Theta=\Theta(\mathcal B_t^{\ast}).
\]

### Wage setters

Households are monopolistic suppliers of differentiated labor services. A labor aggregator forms:

\[
l_t=\left(\int_0^1 l_t(j)^{(\epsilon_L-1)/\epsilon_L}\,dj\right)^{\epsilon_L/(\epsilon_L-1)}.
\]

With probability \(1-\phi_L\), a household reoptimizes its nominal wage; otherwise wages are updated using a rule based on past CPI inflation and the inflation target.

### Non-Ricardian households

Non-Ricardian households have no asset access and consume current after-tax disposable labor income.

### Capital and investment firm

The investment firm assembles home and foreign investment goods,

\[
I_t=\left[\gamma_I^{1/\eta_I}I_{H,t}^{1-1/\eta_I}+(1-\gamma_I)^{1/\eta_I}I_{F,t}^{1-1/\eta_I}\right]^{\eta_I/(\eta_I-1)},
\]

chooses investment and capital, and faces adjustment costs in the capital accumulation law:

\[
K_{t+1}=(1-\delta)K_t+\zeta_{I,t}S\left(\frac{I_t}{I_{t-1}}\right)I_t.
\]

### Domestic producers and import retailers

Domestic producers assemble differentiated home varieties and use a CES technology over value added and oil. Value added combines labor and capital. Domestic-price and export-price setting are Calvo problems. Import retailers buy foreign varieties abroad, sell differentiated import varieties domestically, and set local-currency prices subject to Calvo stickiness.

### Government and foreign sector

The fiscal authority chooses debt, taxes, and government expenditure subject to a consolidated budget and a structural balance rule. The monetary authority follows separate feedback rules for 1987-1999 and 2000-2005. Foreign demand for Chilean home goods depends on the foreign relative price and foreign aggregate demand; copper and oil obey law-of-one-price relations.

## 3. First-Order Conditions

- **(F1) Ricardian consumption Euler equation**:

\[
\hat c_t^R =
-\frac{1-h}{1+h}E_t[\hat i_t-\hat\pi_{C,t+1}]
+\frac{1}{1+h}E_t[\hat c_{t+1}^R]
+\frac{h}{1+h}\hat c_{t-1}^R
+\frac{1-h}{1+h}[\hat\zeta_{C,t}-E_t\hat\zeta_{C,t+1}]
-\frac{1}{1+h}[h\hat\zeta_{T,t}-E_t\hat\zeta_{T,t+1}].
\]

- **(F2) Non-Ricardian consumption**:

\[
\hat c_t^{NR}=\frac{W}{P_CC}(\widehat{wr}_t+\hat l_t)-\frac{\mathcal T_p}{P_CC}\hat\tau_{p,t}.
\]

- **(F3) Aggregate consumption**:

\[
\hat c_t=(1-\lambda)\hat c_t^R+\lambda\hat c_t^{NR}.
\]

- **(F4) Uncovered interest parity**:

\[
\hat i_t=\hat i_t^{\ast}+\varrho\hat{\mathbf b}_t^{\ast}+E_t[\Delta\hat e_{t+1}].
\]

- **(F5) Wage/labor supply Phillips condition**:

\[
[\kappa_L+(1+\beta)]\widehat{wr}_t
=\kappa_L\left(\sigma_L\hat l_t+\frac{\hat c_t}{1-h}-\frac{h\hat c_{t-1}}{1-h}+\hat\zeta_{L,t}\right)
+\widehat{wr}_{t-1}+\beta E_t\widehat{wr}_{t+1}
-(1+\beta\chi_L)\hat\pi_{C,t}+\chi_L\hat\pi_{C,t-1}+\beta E_t\hat\pi_{C,t+1}.
\]

- **(F6) Capital accumulation**:

\[
\hat k_{t+1}=\frac{1-\delta}{(1+n)(1+g_y)}\hat k_t+
\left(1-\frac{1-\delta}{(1+n)(1+g_y)}\right)(\widehat{inv}_t+\hat\zeta_{I,t}).
\]

- **(F7) Investment home-good demand**:

\[
\widehat{inv}_{H,t}=\widehat{inv}_t-\theta_I(\widehat{pr}_{H_D,t}-\widehat{pr}_{I,t}).
\]

- **(F8) Investment foreign-good demand**:

\[
\widehat{inv}_{F,t}=\widehat{inv}_t-\theta_I(\widehat{pr}_{F,t}-\widehat{pr}_{I,t}).
\]

- **(F9) Investment price index**:

\[
\widehat{pr}_{I,t}=\gamma_I\widehat{pr}_{H_D,t}+(1-\gamma_I)\widehat{pr}_{F,t}.
\]

- **(F10) Investment adjustment condition**:

\[
\widehat{pr}_{I,t}=\frac{Qr}{Pr_I}(\widehat{qr}_t+\varepsilon_{I,t})
-\frac{Qr}{Pr_I}\left(1+\frac{1}{1+r}\right)\mu_S(1+g_y)^2\widehat{inv}_t
+\frac{Qr}{Pr_I}\mu_S(1+g_y)^2\widehat{inv}_{t-1}
+\frac{Qr}{Pr_I}\frac{\mu_S(1+g_y)^2}{1+r}E_t\widehat{inv}_{t+1}.
\]

- **(F11) Capital price condition**:

\[
\widehat{qr}_t=E_t[\hat\pi_{C,t+1}-\hat i_t]
+\frac{1}{1+r}\frac{Zr}{Qr}E_t[\widehat{zr}_{t+1}]
+\frac{1-\delta}{1+r}E_t[\widehat{qr}_{t+1}].
\]

- **(F12) Capital-labor cost minimization**:

\[
\hat k_t-\hat\zeta_{T,t}-\hat l_t=\widehat{wr}_t-\widehat{zr}_t.
\]

- **(F13) Oil input cost minimization**:

\[
\frac{1}{\omega_H}\widehat{o}_{H,t}
-\left[\left(\frac{1}{\omega_H}+\frac{1}{\theta_H}\right)\eta_H-\frac{1}{\theta_H}\right]\hat l_t
-\left(\frac{1}{\omega_H}+\frac{1}{\theta_H}\right)(1-\eta_H)(\hat k_{t-1}-\hat\zeta_{T,t})
+\widehat{pr}_{O,t}-\widehat{wr}_t=0.
\]

- **(F14) Marginal cost for home-good producers**:

\[
\widehat{mcr}_{H,t}=
\frac{Zrk}{MCr_HY_H}(\widehat{zr}_t+\hat k_t)
+\frac{Wrl}{MCr_HY_H}(\widehat{wr}_t+\hat l_t)
+\frac{P_OO_H}{MCr_HY_H}(\widehat{pr}_{O,t}+\widehat{o}_{H,t})
-\widehat y_{H,t}.
\]

- **(F15) Phillips curve for domestic home goods**:

\[
\hat\pi_{H_D,t}=
\frac{\beta}{1+\beta\chi_{H_D}}E_t\hat\pi_{H_D,t+1}
+\frac{\chi_{H_D}}{1+\beta\chi_{H_D}}\hat\pi_{H_D,t-1}
+\frac{\kappa_{H_D}}{1+\beta\chi_{H_D}}(\widehat{mcr}_{H,t}-\widehat{pr}_{H_D,t}).
\]

- **(F16) Phillips curve for exported home goods**:

\[
\hat\pi_{H_F,t}=
\frac{\beta}{1+\beta\chi_{H_F}}E_t\hat\pi_{H_F,t+1}
+\frac{\chi_{H_F}}{1+\beta\chi_{H_F}}\hat\pi_{H_F,t-1}
+\frac{\kappa_{H_F}}{1+\beta\chi_{H_F}}(\widehat{mcr}_{H,t}-\widehat{rer}_t-\widehat{pr}_{H_F,t}).
\]

- **(F17) Phillips curve for imported goods**:

\[
\hat\pi_{F,t}=
\frac{\beta}{1+\beta\chi_F}E_t\hat\pi_{F,t+1}
+\frac{\chi_F}{1+\beta\chi_F}\hat\pi_{F,t-1}
+\frac{\kappa_F}{1+\beta\chi_F}(\widehat{rer}_t+\hat\zeta^{\ast}_{F,t}-\widehat{pr}_{F,t}).
\]

## 4. Market Clearing & Identities

- **(F18) Consumption demand for core goods**:

\[
\hat c_{Z,t}=\hat c_t-\omega_C\widehat{pr}_{Z,t}.
\]

- **(F19) Consumption demand for oil**:

\[
\hat c_{O,t}=\hat c_t-\omega_C\widehat{pr}_{O,t}.
\]

- **(F20) Consumption price normalization**:

\[
0=\alpha_C\widehat{pr}_{Z,t}+(1-\alpha_C)\widehat{pr}_{O,t}.
\]

- **(F21) Consumption demand for home goods**:

\[
\hat c_{H,t}=\hat c_{Z,t}-\eta_C\widehat{pr}_{H_D,t}.
\]

- **(F22) Consumption demand for foreign goods**:

\[
\hat c_{F,t}=\hat c_{Z,t}-\eta_C\widehat{pr}_{F,t}.
\]

- **(F23) Core consumption price index**:

\[
\widehat{pr}_{Z,t}=\gamma_C\widehat{pr}_{H_D,t}+(1-\gamma_C)\widehat{pr}_{F,t}.
\]

- **(F24) Fiscal structural balance rule**:

\[
\frac{P_GG}{P_YY}\hat g_t=
\frac{\mathcal T_p}{P_YY}(\hat\tau_{p,t}-\hat y_t)
+\chi\frac{P_SY_S}{P_YY}(\widehat{\overline{pr}}_{S,t}+\hat y_{S,t}-\widehat{pr}_{Y,t}-\hat y_t)
+\cdots
+\frac{P_GG}{P_YY}(\hat\zeta_{G,t}+\widehat{pr}_{H_D,t}-\widehat{pr}_{Y,t}-\hat y_t).
\]

`needs_review`: the long debt and exchange-rate terms in the OCR source are readable but lengthy; this first-pass derivation abbreviates them here and records the full source location in `extraction_notes.md`.

- **(F25) Fiscal policy instrument choice**:

\[
\hat g_t-\widehat{pr}_{H_D,t}+\widehat{pr}_{Y,t}+\hat y_t=0.
\]

- **(F26) Fiscal net asset position**:

\[
\frac{\mathcal EB_G^{\ast}}{P_YY}\frac{1}{\Theta(1+i^{\ast})}\hat b_{G,t}
=\frac{1}{(1+\pi^{\ast})(1+g_y)(1+n)}\frac{\mathcal EB_G^{\ast}}{P_YY}
(\Delta\hat e_t-\hat\pi_{C,t}+\hat b_{G,t-1}-\Delta\widehat{pr}_{Y,t}-\Delta\hat y_t-\hat\zeta_{T,t})
+\cdots .
\]

`needs_review`: OCR line wrapping makes this equation a first-pass transcription.

- **(F27) Monetary policy rule, 1987-1999**:

\[
\hat r_t=\psi_{i,1}\hat r_{t-1}
+(1-\psi_{i,1})(\psi_{\pi,1}-1)\hat\pi_{Z,t}
+(1-\psi_{i,1})\psi_{y,1}\Delta\hat y_t
+(1-\psi_{i,1})\psi_{rer,1}\widehat{rer}_t+\zeta_{m,t}.
\]

- **(F28) Monetary policy rule, 2000-2005**:

\[
\hat i_t=\psi_{i,2}\hat i_{t-1}
+(1-\psi_{i,2})\psi_{\pi,2}\hat\pi_{Z,t}
+(1-\psi_{i,2})\psi_{y,2}\Delta\hat y_t+\zeta_{m,t}.
\]

- **(F29) Foreign demand for home goods**:

\[
\widehat y^{\ast}_{H,t}=\hat y^{\ast}_t-\eta^{\ast}\widehat{pr}_{H_F,t}.
\]

- **(F30) Commodity law of one price**:

\[
\widehat{pr}_{S,t}=\widehat{rer}_t+\widehat{pr}^{\ast}_{S,t}.
\]

- **(F31) Oil law of one price**:

\[
\widehat{pr}_{O,t}=\widehat{rer}_t+\widehat{pr}^{\ast}_{O,t}.
\]

- **(F32) Relative-price laws of motion**:

\[
\hat\pi_{Z,t}=\widehat{pr}_{Z,t}-\widehat{pr}_{Z,t-1}+\hat\pi_{C,t}, \quad
\hat\pi_{H_D,t}=\widehat{pr}_{H_D,t}-\widehat{pr}_{H_D,t-1}+\hat\pi_{C,t},
\]

\[
\hat\pi_{H_F,t}=\widehat{pr}_{H_F,t}-\widehat{pr}_{H_F,t-1}+\hat\pi^{\ast}_t, \quad
\hat\pi_{F,t}=\widehat{pr}_{F,t}-\widehat{pr}_{F,t-1}+\hat\pi_{C,t}.
\]

- **(F33) Nominal exchange-rate depreciation**:

\[
\Delta\hat e_t=\widehat{rer}_t-\widehat{rer}_{t-1}+\hat\pi_{C,t}-\hat\pi^{\ast}_t.
\]

- **(F34) Real interest rate**:

\[
\hat r_t=\hat i_t-\hat\pi_t.
\]

- **(F35) Home-good demand**:

\[
\frac{P_HY_H}{P_YY}\hat y_{H,t}
=\gamma_C\frac{P_CC}{P_YY}\hat c_{H,t}
+\frac{P_GG}{P_YY}(\hat g_t-\widehat{pr}_{H_D,t}+\widehat{pr}_{Y,t}+\hat y_t)
+\gamma_I\frac{P_II}{P_YY}\widehat{inv}_{H,t}
+\frac{P_HY_H^{\ast}}{P_YY}\hat y^{\ast}_{H,t}.
\]

- **(F36) Home-good supply**:

\[
\hat y_{H,t}=\hat a_{H,t}+\Xi_O\widehat{o}_{H,t}+\Xi_L\hat l_t+\Xi_K(\hat k_{t-1}-\hat\zeta_{T,t}),
\]

where the \(\Xi\) coefficients are steady-state CES weights from the source appendix.

- **(F37) Real GDP identity**:

\[
\hat y_t=\frac{P_CC}{P_YY}\hat c_t
+\frac{P_GG}{P_YY}(\hat g_t-\widehat{pr}_{H_D,t}+\widehat{pr}_{Y,t}+\hat y_t)
+\frac{P_II}{P_YY}\widehat{inv}_t
+\frac{P_XX}{P_YY}\hat x_t
-\frac{P_MM}{P_YY}\hat m_t.
\]

- **(F38) Balance of payments / net foreign asset position**:

\[
\frac{(1-\varrho)\mathbf B^{\ast}}{(1+i^{\ast})\Theta(\mathbf B^{\ast})}\hat{\mathbf b}_t^{\ast}
=\frac{\mathbf B^{\ast}}{(1+i^{\ast})\Theta(\mathbf B^{\ast})}\hat i_t^{\ast}
-(1-\chi)\frac{\mathcal EP_S^{\ast}Y_S}{P_YY}(\widehat{pr}_{S,t}+\hat y_{S,t}-\widehat{pr}_{Y,t}-\hat y_t)
+\cdots .
\]

`needs_review`: OCR line wrapping prevents a fully audited first-pass transcription.

- **(F39) Export and import blocks**:

\[
\hat x_t=\frac{\mathcal EP_S^{\ast}Y_S}{P_XX}\hat y_{S,t}
+\left(1-\frac{\mathcal EP_S^{\ast}Y_S}{P_XX}\right)\hat c^{\ast}_{H,t},
\]

\[
\hat m_t=(1-\gamma_C)\frac{P_CC}{P_MM}\hat c_{F,t}
+(1-\gamma_I)\frac{P_II}{P_MM}\widehat{inv}_{F,t}
+\frac{P_O(C_O+O_H)}{P_MM}\left(\frac{C_O}{C_O+O_H}\hat c_{O,t}+\frac{O_H}{C_O+O_H}\widehat{o}_{H,t}\right).
\]

## 5. Exogenous Processes

- **(F40) Shock processes**:

\[
\hat\xi_t=\rho_\xi\hat\xi_{t-1}+\varepsilon_{\xi,t}, \qquad
\varepsilon_{\xi,t}\sim N(0,\sigma_\xi^2),
\]

with

\[
\xi\in\{a_H,\zeta_T,y_S,y^{\ast},i^{\ast},\pi^{\ast},\zeta_m,\zeta_L,\zeta_C,\zeta_G,\zeta_I,\zeta_F^{\ast},p_O^{\ast},p_S^{\ast}\}.
\]

The implementation cross-check lists the corresponding innovations as `eps_ah`, `eps_st`, `eps_ys`, `eps_yF`, `eps_iF`, `eps_piF`, `eps_sh_m`, `eps_sh_w`, `eps_sh_c`, `eps_gex`, `eps_sh_i`, `eps_prfF`, `eps_proF`, and `eps_prsF`.

## 6. Steady-State Solution

The paper calibrates steady-state ratios and growth rates rather than providing a compact analytical `steady_state_model`. The implementation cross-check computes steady-state objects before the linear model block. Source-backed first-pass values include:

- annual steady-state labor productivity growth \(g_y=3.5\%\);
- annual steady-state inflation target \(\bar\pi=3\%\);
- discount factor \(\beta=0.999\);
- non-Ricardian share \(\lambda=0.5\);
- commodity-sector value-added share \(Y_S/Y=10\%\);
- public copper share \(\chi=40\%\);
- steady current-account/GDP ratio \(CA/Y=-1.8\%\);
- annual depreciation rate \(\delta=5.8\%\);
- labor share in home value added \(\eta_H=0.66\);
- oil share in home gross production near 1 percent;
- CES markups based on \(\epsilon_L=\epsilon_{H_D}=\epsilon_{H_F}=\epsilon_F=11\).

Steady-state computational sequence used as an implementation cross-check:

1. Set long-run growth, inflation, shares, and foreign trend variables.
2. Compute steady-state interest-rate and relative-price objects (`r`, `iF`, `Theta_ss`, `Zr`, `Prh`, `Prf`, `RER`, `Pri`).
3. Solve production ratios (`Kh_Lh`, `Oh_Lh`, `Yh_Lh`, `Y_Lh`, `Yh_Y`) and demand shares (`I_Y`, `C_Y`, `M_Y`, `X_Y`).
4. Compute government, tax, public debt, and external-balance ratios.
5. Use log-linear form, so deviations have zero deterministic steady state in the Dynare `model(linear)` representation.

`needs_review`: steady-state algebra is source-supported by the calibration section and `.mod` cross-check, but the full paper-side steady-state derivation was not independently reconstructed.

## 7. Timing & Form Conventions

- The archive entry treats CL_MS07 as a log-linearized model. Variables with hats are deviations from steady state or balanced-growth path values.
- The implementation cross-check confirms `model(linear)`.
- Capital in the replication equations is predetermined in production: production and marginal-cost equations use `k_hat(-1)` or `k_{t-1}`; the nonlinear paper writes capital accumulation as \(K_{t+1}\) from \(K_t\) and \(I_t\).
- The permanent productivity process creates a stochastic trend. Quantities are expressed in per-capita terms and detrended before the appendix equations.
- The policy instrument changes across regimes: 1987-1999 uses a real-rate rule with a real-exchange-rate response; 2000-2005 uses a nominal-rate rule without the direct real-exchange-rate response.
- The raw PDF was not opened; formula quality is based on MinerU Markdown and implementation cross-check only.
- Runtime validation: not performed. Dynare was not run.

## 8. Variable & Parameter Reference Table

| Category | Symbol or ASCII name | Meaning | Main equation(s) |
|---|---|---|---|
| Endogenous | `c_hat`, \(\hat c_t\) | aggregate consumption | (F3) |
| Endogenous | `cR`, \(\hat c_t^R\) | Ricardian consumption | (F1) |
| Endogenous | `cNR`, \(\hat c_t^{NR}\) | non-Ricardian consumption | (F2) |
| Endogenous | `bF_hat`, \(\hat{\mathbf b}_t^{\ast}\) | net foreign assets | (F4), (F38) |
| Endogenous | `i_hat`, \(\hat i_t\) | nominal interest rate | (F4), (F28), (F34) |
| Endogenous | `r_hat`, \(\hat r_t\) | real interest rate | (F27), (F34) |
| Endogenous | `wr_hat` | real wage | (F5), (F12) |
| Endogenous | `l_hat` | labor | (F5), (F12), (F36) |
| Endogenous | `k_hat` | capital | (F6), (F12), (F36) |
| Endogenous | `inv_hat` | investment | (F6), (F10), (F37) |
| Endogenous | `qr_hat` | real capital price | (F10), (F11) |
| Endogenous | `zr_hat` | rental rate of capital | (F11), (F12), (F14) |
| Endogenous | `mcrh_hat` | home-sector real marginal cost | (F14)-(F17) |
| Endogenous | `pic_hat`, `picz_hat` | CPI and core inflation | (F15)-(F17), (F27), (F28), (F32) |
| Endogenous | `rer_hat` | real exchange rate | (F16), (F17), (F30), (F31), (F33) |
| Endogenous | `yh_hat`, `y_hat` | home output and real GDP | (F35)-(F37) |
| Endogenous | `x_hat`, `m_hat` | exports and imports | (F37), (F39) |
| Endogenous | `g_hat`, `tau_hat`, `bg_hat` | fiscal expenditure, taxes, public assets | (F24)-(F26) |
| Exogenous | `eps_ah` | transitory productivity innovation | (F40) |
| Exogenous | `eps_st` | permanent productivity innovation | (F40) |
| Exogenous | `eps_ys` | commodity production innovation | (F40) |
| Exogenous | `eps_yF` | foreign output innovation | (F40) |
| Exogenous | `eps_iF` | foreign interest-rate innovation | (F40) |
| Exogenous | `eps_piF` | foreign inflation innovation | (F40) |
| Exogenous | `eps_sh_m` | monetary-policy innovation | (F40) |
| Exogenous | `eps_sh_w` | labor-supply innovation | (F40) |
| Exogenous | `eps_sh_c` | preference innovation | (F40) |
| Exogenous | `eps_gex` | fiscal-expenditure innovation | (F40) |
| Exogenous | `eps_sh_i` | investment-adjustment innovation | (F40) |
| Exogenous | `eps_prfF` | foreign import-price innovation | (F40) |
| Exogenous | `eps_proF` | oil-price innovation | (F40) |
| Exogenous | `eps_prsF` | copper-price innovation | (F40) |
| Parameter | \(\beta\), `beta` | discount factor | (F1), steady state |
| Parameter | \(\lambda\), `lambda` | non-Ricardian household share | (F3) |
| Parameter | \(h\) | habit persistence | (F1), (F5) |
| Parameter | \(\sigma_L\) | inverse Frisch elasticity | (F5) |
| Parameter | \(\phi_L,\chi_L\) | wage Calvo and indexation parameters | (F5) |
| Parameter | \(\gamma_C,\gamma_I,\alpha_C\) | final-good CES shares | (F18)-(F23) |
| Parameter | \(\theta_I,\mu_S\) | investment substitution and adjustment costs | (F7)-(F10) |
| Parameter | \(\phi_{H_D},\phi_{H_F},\phi_F\) | Calvo price probabilities | (F15)-(F17) |
| Parameter | \(\chi_{H_D},\chi_{H_F},\chi_F\) | price indexation parameters | (F15)-(F17) |
| Parameter | \(\psi_{i,1},\psi_{\pi,1},\psi_{y,1},\psi_{rer,1}\) | 1987-1999 policy rule coefficients | (F27) |
| Parameter | \(\psi_{i,2},\psi_{\pi,2},\psi_{y,2}\) | 2000-2005 policy rule coefficients | (F28) |
| Parameter | \(\rho_\xi,\sigma_\xi\) | shock persistence and innovation scale | (F40) |
