# EAUS_NAWM08 Derivation

> First-pass private model-archive draft. Formula status: `needs_review`. The derivation is based on MinerU Markdown of Coenen, McAdam, and Straub (2008); the raw PDF path was checked for provenance, but the PDF body was not read. `EAUS_NAWM08_rep.mod` was used only as an `implementation_cross_check`.

## 1. Model Overview

- **Model**: `EAUS_NAWM08`, a calibrated two-country New Area-Wide Model (NAWM) for the euro area and the United States.
- **Source**: Coenen, Guenther; McAdam, Peter; Straub, Roland (2008), "Tax reform and labour-market performance in the euro area: A simulation-based analysis using the New Area-Wide Model", *Journal of Economic Dynamics & Control*, DOI `10.1016/j.jedc.2007.09.007`.
- **Economy**: two asymmetric-size countries. The home block is the euro area and the foreign block is the United States/rest of the industrialized world. Each country has households, firms, a fiscal authority, and a monetary authority.
- **Core agents**: asset-market household I, limited-asset-market household J, monopolistically competitive intermediate-good firms, final consumption/investment/public-good firms, fiscal authorities, and Taylor-rule monetary authorities.
- **Key mechanisms**: external habit, money transaction costs, capital accumulation and utilization, Calvo wage setting for two household types, Calvo local-currency pricing in domestic/export markets, import adjustment costs, fiscal tax wedges, government debt feedback, and international bond risk premium.
- **Model form**: nonlinear DSGE in levels/relative prices. The MMB implementation solves the nonlinear model and lets Dynare linearize for stochastic simulation; this archive draft does not convert it into `model(linear)`.
- **Scope convention**: the equations below write a generic country block without a country superscript. The foreign country has the same structure with starred variables. International clearing conditions link the two blocks.

## 2. Optimization Problems

### 2.1 Asset-Market Household I

Household member \(i \in [0,1-\omega]\) chooses consumption, investment, next-period physical capital, utilization, domestic bonds, foreign bonds, and money:

$$
\max_{\{C_{i,t},I_{i,t},K_{i,t+1},u_{i,t},B_{i,t+1},B^F_{i,t+1},M_{i,t}\}}
E_t\sum_{k=0}^{\infty}\beta^k
\left[
\frac{(C_{i,t+k}-\kappa C_{I,t+k-1})^{1-\sigma}}{1-\sigma}
-\frac{N_{i,t+k}^{1+\zeta}}{1+\zeta}
\right].
$$

The period budget constraint is:

$$
\begin{aligned}
&(1+\tau_t^C+\Gamma_v(v_{i,t}))P_{C,t}C_{i,t}+P_{I,t}I_{i,t}
+R_t^{-1}B_{i,t+1}
+((1-\Gamma_{B^F}(B_t^F))R_{F,t})^{-1}S_tB^F_{i,t+1}+M_{i,t}+\Xi_{i,t}+\Phi_{i,t} \\
&=(1-\tau_t^N-\tau_t^{W_h})W_{i,t}N_{i,t}
+(1-\tau_t^K)(R_{K,t}u_{i,t}-\Gamma_u(u_{i,t})P_{I,t})K_{i,t}
+\tau_t^K\delta P_{I,t}K_{i,t} \\
&\quad +(1-\tau_t^D)D_{i,t}+TR_{i,t}-T_{i,t}+B_{i,t}+S_tB^F_{i,t}+M_{i,t-1}.
\end{aligned}
$$

Capital evolves as:

$$
K_{i,t+1}=(1-\delta)K_{i,t}+\left(1-\Gamma_I(I_{i,t}/I_{i,t-1})\right)I_{i,t}.
$$

### 2.2 Limited-Asset-Market Household J

Household member \(j \in (1-\omega,1]\) has the same period utility but chooses consumption and money only, subject to:

$$
(1+\tau_t^C+\Gamma_v(v_{j,t}))P_{C,t}C_{j,t}+M_{j,t}
=(1-\tau_t^N-\tau_t^{W_h})W_{j,t}N_{j,t}+TR_{j,t}-T_{j,t}+M_{j,t-1}+\Phi_{j,t}.
$$

Both household types set differentiated wages under Calvo contracts. Resetters choose \(\widetilde W_{I,t}\) or \(\widetilde W_{J,t}\), taking the demand for their labor variety as given.

### 2.3 Intermediate-Good Firms

Each monopolistically competitive intermediate producer minimizes factor cost subject to:

$$
Y_{f,t}=\max\left[z_t K_{f,t}^{\alpha}N_{f,t}^{1-\alpha}-\psi,0\right].
$$

The firm rents capital services and a composite labor bundle, pays the employer payroll tax \(\tau_t^{W_f}\), and sets domestic and export prices under Calvo local-currency pricing.

### 2.4 Final-Good Firms

Final consumption and investment goods are CES bundles of domestic and imported intermediate-good bundles, with import adjustment costs. The public consumption good is a domestic intermediate-good bundle. Final-good firms minimize input cost subject to the CES technologies.

## 3. First-Order Conditions

### Household I

- **(F1) Marginal utility of consumption**:

$$
\Lambda_{i,t}=
\frac{(C_{i,t}-\kappa C_{I,t-1})^{-\sigma}}
{1+\tau_t^C+\Gamma_v(v_{i,t})+\Gamma_v'(v_{i,t})v_{i,t}}.
$$

- **(F2) Investment FOC / Tobin's Q**:

$$
\frac{P_{I,t}}{P_{C,t}}
=Q_{i,t}\left[1-\Gamma_I(s_{i,t})-\Gamma_I'(s_{i,t})I_{i,t}\right]
+\beta E_t\left[
\frac{\Lambda_{i,t+1}}{\Lambda_{i,t}}Q_{i,t+1}\Gamma_I'(s_{i,t+1})
\frac{I_{i,t+1}^2}{I_{i,t}}
\right],
\quad s_{i,t}=\frac{I_{i,t}}{I_{i,t-1}}.
$$

The source formula is transcribed by MinerU and should be checked because the derivative notation is compact; `needs_review`.

- **(F3) Capital Euler equation**:

$$
Q_{i,t}=\beta E_t\left[
\frac{\Lambda_{i,t+1}}{\Lambda_{i,t}}
\left(
(1-\delta)Q_{i,t+1}
+(1-\tau_{t+1}^K)\frac{R_{K,t+1}}{P_{C,t+1}}u_{i,t+1}
+(\tau_{t+1}^K\delta-(1-\tau_{t+1}^K)\Gamma_u(u_{i,t+1}))
\frac{P_{I,t+1}}{P_{C,t+1}}
\right)\right].
$$

- **(F4) Utilization FOC**:

$$
R_{K,t}=\Gamma_u'(u_{i,t})P_{I,t}.
$$

- **(F5) Domestic-bond Euler equation**:

$$
\beta R_t E_t\left[
\frac{\Lambda_{i,t+1}}{\Lambda_{i,t}}
\frac{P_{C,t}}{P_{C,t+1}}
\right]=1.
$$

- **(F6) Foreign-bond Euler equation with risk premium**:

$$
\beta(1-\Gamma_{B^F}(B_t^F))R_{F,t}E_t\left[
\frac{\Lambda_{i,t+1}}{\Lambda_{i,t}}
\frac{P_{C,t}}{P_{C,t+1}}\frac{S_{t+1}}{S_t}
\right]=1.
$$

- **(F7) Money FOC**:

$$
\beta E_t\left[
\frac{\Lambda_{i,t+1}}{\Lambda_{i,t}}
\frac{P_{C,t}}{P_{C,t+1}}
\right]=1-\Gamma_v'(v_{i,t})v_{i,t}^2.
$$

- **(F8) Household-I wage reset FOC**:

$$
E_t\sum_{k=0}^{\infty}(\xi_I\beta)^k
\left[
\Lambda_{i,t+k}(1-\tau_{t+k}^N-\tau_{t+k}^{W_h})
\frac{\widetilde W_{I,t}}{P_{C,t+k}}
\left(\frac{P_{C,t+k-1}}{P_{C,t-1}}\right)^{\chi_I}
\pi_C^{(1-\chi_I)k}
-\frac{\eta_I}{\eta_I-1}N_{i,t+k}^{\zeta}
\right]N_{i,t+k}=0.
$$

This compact infinite-sum formula follows the paper; the implementation rewrites it with recursive auxiliaries \(F_I,G_I\).

- **(F9) Household-I wage indexation**:

$$
W_{I,t}=\left[
(1-\xi_I)\widetilde W_{I,t}^{1-\eta_I}
+\xi_I\left(\left(\frac{P_{C,t-1}}{P_{C,t-2}}\right)^{\chi_I}
\pi_C^{1-\chi_I}W_{I,t-1}\right)^{1-\eta_I}
\right]^{1/(1-\eta_I)}.
$$

### Household J

- **(F10) Household-J budget constraint**:

$$
(1+\tau_t^C+\Gamma_v(v_{j,t}))P_{C,t}C_{j,t}+M_{j,t}
=(1-\tau_t^N-\tau_t^{W_h})W_{j,t}N_{j,t}+TR_{j,t}-T_{j,t}+M_{j,t-1}+\Phi_{j,t}.
$$

- **(F11) Household-J marginal utility of consumption**:

$$
\Lambda_{j,t}=
\frac{(C_{j,t}-\kappa C_{J,t-1})^{-\sigma}}
{1+\tau_t^C+\Gamma_v(v_{j,t})+\Gamma_v'(v_{j,t})v_{j,t}}.
$$

- **(F12) Household-J money FOC**:

$$
\beta E_t\left[
\frac{\Lambda_{j,t+1}}{\Lambda_{j,t}}
\frac{P_{C,t}}{P_{C,t+1}}
\right]=1-\Gamma_v'(v_{j,t})v_{j,t}^2.
$$

- **(F13) Household-J wage reset FOC**:

$$
E_t\sum_{k=0}^{\infty}(\xi_J\beta)^k
\left[
\Lambda_{j,t+k}(1-\tau_{t+k}^N-\tau_{t+k}^{W_h})
\frac{\widetilde W_{J,t}}{P_{C,t+k}}
\left(\frac{P_{C,t+k-1}}{P_{C,t-1}}\right)^{\chi_J}
\pi_C^{(1-\chi_J)k}
-\frac{\eta_J}{\eta_J-1}N_{j,t+k}^{\zeta}
\right]N_{j,t+k}=0.
$$

- **(F14) Household-J wage indexation**:

$$
W_{J,t}=\left[
(1-\xi_J)\widetilde W_{J,t}^{1-\eta_J}
+\xi_J\left(\left(\frac{P_{C,t-1}}{P_{C,t-2}}\right)^{\chi_J}
\pi_C^{1-\chi_J}W_{J,t-1}\right)^{1-\eta_J}
\right]^{1/(1-\eta_J)}.
$$

### Intermediate-Good Firms

- **(F15) Production function**:

$$
Y_{f,t}=z_tK_{f,t}^{\alpha}N_{f,t}^{1-\alpha}-\psi.
$$

- **(F16) Capital demand condition**:

$$
R_{K,t}=\alpha\frac{Y_{f,t}+\psi}{K_{f,t}}MC_t.
$$

- **(F17) Marginal cost**:

$$
MC_t=\frac{1}{z_t\alpha^{\alpha}(1-\alpha)^{1-\alpha}}
(R_{K,t})^{\alpha}\left((1+\tau_t^{W_f})W_t\right)^{1-\alpha}.
$$

- **(F18) Composite labor aggregator**:

$$
N_{f,t}=\left[
(1-\omega)^{1/\eta}(N_{f,t}^I)^{1-1/\eta}
+\omega^{1/\eta}(N_{f,t}^J)^{1-1/\eta}
\right]^{\eta/(\eta-1)}.
$$

- **(F19) Household-specific labor demand**:

$$
N_{f,t}^I=(1-\omega)\left(\frac{W_{I,t}}{W_t}\right)^{-\eta}N_{f,t},
\quad
N_{f,t}^J=\omega\left(\frac{W_{J,t}}{W_t}\right)^{-\eta}N_{f,t}.
$$

- **(F20) Domestic-price reset FOC**:

$$
E_t\sum_{k=0}^{\infty}\xi_H^k\Lambda_{I,t,t+k}
\left[
\widetilde P_{H,t}
\left(\frac{P_{H,t+k-1}}{P_{H,t-1}}\right)^{\chi_H}\pi_H^{(1-\chi_H)k}
-\frac{\theta}{\theta-1}MC_{t+k}
\right]H_{f,t+k}=0.
$$

- **(F21) Domestic price index**:

$$
P_{H,t}=\left[
(1-\xi_H)\widetilde P_{H,t}^{1-\theta}
+\xi_H\left(\left(\frac{P_{H,t-1}}{P_{H,t-2}}\right)^{\chi_H}
\pi_H^{1-\chi_H}P_{H,t-1}\right)^{1-\theta}
\right]^{1/(1-\theta)}.
$$

- **(F22) Export-price reset FOC**:

$$
E_t\sum_{k=0}^{\infty}\xi_X^k\Lambda_{I,t,t+k}
\left[
\widetilde P_{X,t}
\left(\frac{P_{X,t+k-1}}{P_{X,t-1}}\right)^{\chi_X}\pi_X^{(1-\chi_X)k}
-\frac{\theta}{\theta-1}\frac{MC_{t+k}}{S_{t+k}}
\right]X_{f,t+k}=0.
$$

The export-price expression is the source-stated analogue of (F20); its exact discounting and currency conversion should be formula-checked against the PDF or implementation auxiliaries; `needs_review`.

### Final-Good Firms

- **(F23) Consumption-good CES technology**:

$$
Q_t^C=\left[
\nu_C^{1/\mu_C}(H_t^C)^{1-1/\mu_C}
+(1-\nu_C)^{1/\mu_C}
\left((1-\Gamma_{IM^C}(IM_t^C/Q_t^C))IM_t^C\right)^{1-1/\mu_C}
\right]^{\mu_C/(\mu_C-1)}.
$$

- **(F24) Consumption-good domestic-input demand**:

$$
H_t^C=\nu_C\left(\frac{P_{H,t}}{P_{C,t}}\right)^{-\mu_C}Q_t^C.
$$

- **(F25) Consumption-good import demand**:

$$
IM_t^C=(1-\nu_C)
\left(\frac{P_{IM,t}}{P_{C,t}\Gamma_{IM^C,t}^{\dagger}}\right)^{-\mu_C}
\frac{Q_t^C}{1-\Gamma_{IM^C}(IM_t^C/Q_t^C)}.
$$

The \(\Gamma^\dagger\) OCR around the source definition is damaged; `needs_review`.

- **(F26) Consumption-good price index**:

$$
P_{C,t}=\left[
\nu_C P_{H,t}^{1-\mu_C}
+(1-\nu_C)\left(\frac{P_{IM,t}}{\Gamma_{IM^C,t}^{\dagger}}\right)^{1-\mu_C}
\right]^{1/(1-\mu_C)}.
$$

- **(F27) Investment-good CES technology**:

$$
Q_t^I=\left[
\nu_I^{1/\mu_I}(H_t^I)^{1-1/\mu_I}
+(1-\nu_I)^{1/\mu_I}
\left((1-\Gamma_{IM^I}(IM_t^I/Q_t^I))IM_t^I\right)^{1-1/\mu_I}
\right]^{\mu_I/(\mu_I-1)}.
$$

- **(F28) Investment-good price and demand system**:

$$
H_t^I=\nu_I\left(\frac{P_{H,t}}{P_{I,t}}\right)^{-\mu_I}Q_t^I,
\quad
P_{I,t}=\left[
\nu_I P_{H,t}^{1-\mu_I}
+(1-\nu_I)\left(\frac{P_{IM,t}}{\Gamma_{IM^I,t}^{\dagger}}\right)^{1-\mu_I}
\right]^{1/(1-\mu_I)}.
$$

The import-demand companion for investment goods is analogous to (F25) and should be checked if promoted to runnable code; `needs_review`.

## 4. Market Clearing & Identities

- **(F29) Per-capita aggregation**:

$$
X_t=(1-\omega)X_{i,t}+\omega X_{j,t}.
$$

- **(F30) Aggregate capital and investment**:

$$
K_t=(1-\omega)K_{i,t},\quad I_t=(1-\omega)I_{i,t},\quad M_t=(1-\omega)M_{i,t}+\omega M_{j,t}.
$$

- **(F31) Public-good and intermediate demand aggregation**:

$$
H_t=H_t^C+H_t^I+G_t,\quad IM_t=IM_t^C+IM_t^I.
$$

- **(F32) Aggregate resource constraint**:

$$
\begin{aligned}
P_{Y,t}Y_t
&=P_{C,t}(C_t+\Gamma_{v,t})
+P_{I,t}(I_t+\Gamma_u(u_t)K_t)
+P_{G,t}G_t+S_tP_{X,t}X_t \\
&\quad -P_{IM,t}\left[
IM_t^C\frac{1-\Gamma_{IM^C}(IM_t^C/Q_t^C)}
{\Gamma_{IM^C}^{\dagger}(IM_t^C/Q_t^C)}
+IM_t^I\frac{1-\Gamma_{IM^I}(IM_t^I/Q_t^I)}
{\Gamma_{IM^I}^{\dagger}(IM_t^I/Q_t^I)}
\right].
\end{aligned}
$$

The OCR uses \(T\) and \(\Gamma\) inconsistently for transaction/import costs; formula needs source-level review.

- **(F33) Fiscal authority budget constraint**:

$$
\begin{aligned}
P_{G,t}G_t+TR_t+B_t+M_{t-1}
&=\tau_t^CP_{C,t}C_t
+(\tau_t^N+\tau_t^{W_h})(W_{I,t}N_{t}^I+W_{J,t}N_t^J)
+\tau_t^{W_f}W_tN_t \\
&\quad+\tau_t^K(R_{K,t}u_t-(\Gamma_u(u_t)+\delta)P_{I,t})K_t
+\tau_t^DD_t+T_t+R_t^{-1}B_{t+1}+M_t.
\end{aligned}
$$

- **(F34) Lump-sum tax feedback rule**:

$$
\tau_t=\phi_{B_Y}\left(\frac{B_t}{P_YY}-B_Y\right).
$$

- **(F35) Monetary policy rule**:

$$
R_t^4=\phi_RR_{t-1}^4+(1-\phi_R)
\left[R^4+\phi_{\Pi}\left(\frac{P_{C,t}}{P_{C,t-4}}-\Pi\right)\right]
+\phi_{g_Y}\left(\frac{Y_t}{Y_{t-1}}-g_Y\right)+\varepsilon_{R,t}.
$$

- **(F36) Net foreign asset law of motion**:

$$
R_{F,t}^{-1}B_{t+1}^F=B_t^F+\frac{TB_t}{S_t},
\quad
TB_t=S_tP_{X,t}X_t-P_{IM,t}IM_t.
$$

- **(F37) World foreign-bond clearing**:

$$
sB_t^F+(1-s)B_t^{F,\ast}=0.
$$

## 5. Exogenous Processes

- **(F38) Total factor productivity**:

$$
\log z_t=(1-\rho_z)\log z+\rho_z\log z_{t-1}+\varepsilon_{z,t}.
$$

- **(F39) Fiscal and tax processes**:

$$
x_t=(1-\rho_x)\bar x+\rho_xx_{t-1}+\varepsilon_{x,t},
\quad
x_t\in\{g_t,tr_t,\tau_t^C,\tau_t^D,\tau_t^K,\tau_t^N,\tau_t^{W_h},\tau_t^{W_f}\}.
$$

The published article states constant distortionary tax rates unless otherwise stated, while the MMB implementation includes AR(1) shock processes for each tax rate as implementation coverage.

## 6. Steady-State Solution

The model is calibrated around a non-stochastic steady state with positive trend-free levels. This first-pass archive does not reconstruct a full analytic `steady_state_model`; status is `needs_review`.

Steady-state restrictions recorded from the source and cross-check:

- Set innovations to zero and \(z=\bar z=1\).
- Gross annual inflation target is \(\Pi=1.02\); quarterly consumer inflation is consistent with \(\Pi^{1/4}\).
- The equilibrium gross policy rate satisfies \(R^4=\beta^{-4}\Pi\).
- Import and investment adjustment costs are zero in steady state: \(\Gamma_I(1)=0\), \(\Gamma_{IM^C}=0\), \(\Gamma_{IM^I}=0\).
- Capital utilization is normalized to \(u=1\); \(\Gamma_u(1)=0\) and \(\Gamma_u'(1)\) pins down the steady rental rate of capital.
- Net foreign assets are zero worldwide by the international transaction-cost specification and world bond clearing.
- Public spending, transfers, imports, consumption, investment, government debt, and money are calibrated to steady-state ratios in Appendix B.
- The fixed cost \(\psi\) is chosen to support zero profits in steady state.
- Country-specific steady-state ratios differ for euro area and United States; the MMB file initializes country blocks separately.

## 7. Timing & Form Conventions

- The derivation is nonlinear and uses time subscripts, not Dynare `(+1)` syntax.
- Household I chooses \(K_{i,t+1}\) at date \(t\). The MMB implementation stores capital as a predetermined stock and writes capital accumulation with lagged investment and lagged capital.
- Bonds in the paper are written as next-period holdings \(B_{t+1}\) and \(B^F_{t+1}\) in date-\(t\) budget constraints. The implementation maps this into current stock variables with lagged returns.
- Money carried from \(t-1\) enters current budget constraints; the implementation has timing shifts in the government budget constraint and should be reviewed before code promotion.
- Prices are in levels and relative-price indexes. Consumer inflation, home-goods inflation, import-price inflation, and annual CPI inflation are distinct.
- The country blocks are symmetric in structure but not in calibration: `EA_` and `US_` variables have separate home bias, tax, money-demand, transfer, and trade-ratio calibrations.
- Runtime validation was not performed. Dynare was not run.

## 8. Variable & Parameter Reference Table

| Category | Symbols / implementation names | Meaning | Main equations |
|---|---|---|---|
| Endogenous | \(C_I,C_J,C,I\) / `EA_CI`, `EA_CJ`, `EA_C`, `EA_I` | household and aggregate consumption/investment | (F1)-(F3), (F10)-(F12), (F29)-(F30) |
| Endogenous | \(K,u,Q,R_K\) / `EA_K`, `EA_U`, `EA_Q`, `EA_RK` | capital, utilization, Tobin's Q, rental rate | (F3)-(F4), (F16), (F30) |
| Endogenous | \(M,v,\Gamma_v,\Lambda\) / `EA_M`, `EA_VI`, `EA_VJ`, `EA_LAMBDAI`, `EA_LAMBDAJ` | money, velocity, transaction cost, marginal utility | (F1), (F7), (F11), (F12), (F29)-(F30) |
| Endogenous | \(W_I,W_J,\widetilde W_I,\widetilde W_J,N_I,N_J,N\) / `EA_WI`, `EA_WJ`, `EA_WITILDE`, `EA_WJTILDE`, `EA_NDI`, `EA_NDJ`, `EA_ND` | wage setting and labor demand | (F8)-(F9), (F13)-(F14), (F18)-(F19) |
| Endogenous | \(Y,Y_s,MC,D\) / `EA_Y`, `EA_YS`, `EA_MC`, `EA_D` | output, supply, marginal cost, dividends | (F15)-(F17), (F32) |
| Endogenous | \(P_H,\widetilde P_H,P_X,\widetilde P_X\) / `EA_PH`, `EA_PHTILDE`, `US_PIM`, `US_PIMTILDE` | local-currency price setting | (F20)-(F22) |
| Endogenous | \(Q^C,Q^I,H^C,H^I,IM^C,IM^I,P_C,P_I,P_{IM}\) / `EA_QC`, `EA_QI`, `EA_HC`, `EA_HI`, `EA_IMC`, `EA_IMI`, `EA_PIC`, `EA_PI`, `EA_PIM` | final-good production and price indexes | (F23)-(F28), (F31)-(F32) |
| Endogenous | \(G,TR,T,B,B^F,TB,ToT,R,S\) / `EA_G`, `EA_TR`, `EA_T`, `EA_B`, `EA_BF`, `EA_TB`, `EA_TOT`, `EA_R`, `EA_RER` | fiscal, external, and monetary variables | (F33)-(F37) |
| Exogenous shocks | \(\varepsilon_z,\varepsilon_R,\varepsilon_g,\varepsilon_{tr},\varepsilon_{\tau^C},\varepsilon_{\tau^D},\varepsilon_{\tau^K},\varepsilon_{\tau^N},\varepsilon_{\tau^{W_h}},\varepsilon_{\tau^{W_f}}\) / `EA_EPSZ`, `EA_EPSR`, `EA_EPSG`, `EA_EPSTR`, tax shocks | productivity, policy, fiscal, and tax shocks | (F35), (F38)-(F39) |
| Parameters | \(\beta,\sigma,\kappa,\zeta,\delta,\omega,\alpha,\psi\) | preferences, depreciation, household share, production | (F1)-(F19) |
| Parameters | \(\xi_I,\xi_J,\chi_I,\chi_J,\eta,\eta_I,\eta_J\) | wage stickiness, wage indexation, labor substitution | (F8)-(F14), (F18)-(F19) |
| Parameters | \(\xi_H,\xi_X,\chi_H,\chi_X,\theta,\nu_C,\nu_I,\mu_C,\mu_I\) | price stickiness, price indexation, final-good CES parameters | (F20)-(F28) |
| Parameters | \(\gamma_v,\gamma_u,\gamma_I,\gamma_{IM^C},\gamma_{IM^I},\gamma_{B^F}\) | transaction, utilization, investment, import, and international bond costs | (F1)-(F7), (F23)-(F28), (F36) |
| Parameters | \(\tau^C,\tau^D,\tau^K,\tau^N,\tau^{W_h},\tau^{W_f},B_Y,\phi_{B_Y},\phi_R,\phi_{\Pi},\phi_{g_Y},s\) | tax, fiscal feedback, monetary rule, country size | (F1)-(F7), (F33)-(F39) |
