# FI_AINO16 -- Derivation (optimization problems + equilibrium conditions)

> Purpose: first-pass source-backed derivation for the private MMB model archive. Runtime validation was not performed. Formula status is `needs_review` because the paper-level Markdown/OCR source is clear for the model blocks but the full linearized appendix equations were not exhaustively checked against the PDF body.

Source: Kilponen, Juha; Orjasniemi, Seppo; Ripatti, Antti; Verona, Fabio (2016), "The Aino 2.0 model", Bank of Finland Research Discussion Paper 16/2016, DOI `10.2139/ssrn.2795479`.

## 1. Model Overview

- **Model**: Aino 2.0, a quarterly estimated small open economy DSGE model for Finland with monopolistic banking, nominal rigidities, fiscal detail, and external-sector shocks.
- **MMB ID**: `FI_AINO16`.
- **Experiment/use**: Bayesian-estimated linear rational-expectations model used for forecasting, policy analysis, variance decompositions, and impulse responses. The Rep-MMB implementation uses `model(linear)` and simulates selected shocks.
- **Agents and blocks**: households, domestic intermediate-good firms, final consumption and investment retailers, exporters, importers, fiscal authority, entrepreneurs, competitive capital producer, banks with wholesale and retail loan branches, and exogenous foreign/technology/fiscal/financial processes.
- **Form**: `model(linear)` in the implementation cross-check. The paper describes nonlinear structural problems and reports/log-linearizes the state-space representation; this entry records the structural equations and key linearized banking relations. Full appendix-by-appendix equation coverage is `needs_review`.
- **Source match**: The index title is "The AINO II model"; the primary Markdown first page reads "The Aino 2.0 model" with the expected authors. This is treated as a title-normalization issue, not a different source.

## 2. Optimization Problems

### Domestic Intermediate-Good Producers

Intermediate-good firm \(j\) combines capital services and private labor under Harrod-neutral CES technology:

\[
Y_t(j)=\left[\delta_Y(\Lambda_{k,t}K_t)^{-\rho_Y}+(1-\delta_Y)(\Lambda_{l,t}L_t^F)^{-\rho_Y}\right]^{-1/\rho_Y}. \tag{F1}
\]

It minimizes nominal factor cost subject to (F1):

\[
\min_{\{K_t,L_t^F\}}\; R_t^K K_t+(1+\tau_t^F)W_tL_t^F
\quad\text{s.t.}\quad Y_t(j)\text{ given by (F1)}. \tag{F2}
\]

### Price-Setting Intermediate-Good Firms

With Calvo probability \(1-\zeta\) of reoptimization and partial indexation for non-reoptimizers, a firm that can reset solves:

\[
\max_{\{P_t^\circ(j)\}}\;E_t\sum_{s=0}^{\infty}\zeta^s M_{t,t+s}
\left[P^\circ_{t+s|t}(j)-\mathcal{MC}_{t+s}(j)\right]Y_{t+s|t}(j). \tag{F3}
\]

### Final-Good Retailers

Competitive consumption and investment retailers choose domestic and imported inputs to produce:

\[
C_t^H=\left\{\delta_c(\Lambda_{cy,t}Y_t^C)^{-\rho_c}
+(1-\delta_c)\left[(1-\Gamma_{cm})\Lambda_{cm,t}M_t^C\right]^{-\rho_c}\right\}^{-1/\rho_c}. \tag{F4}
\]

\[
I_t=\left\{\delta_i(\Lambda_{iy,t}Y_t^I)^{-\rho_i}
+(1-\delta_i)\left[(1-\Gamma_{im})\Lambda_{im,t}M_t^I\right]^{-\rho_i}\right\}^{-1/\rho_i}. \tag{F5}
\]

The adjustment costs are:

\[
\Gamma_{cm}=\frac{\gamma_{cm}}{2}\left(\frac{M_t^C/C_t^H}{M_{t-1}^C/C_{t-1}^H}-1\right)^2,\qquad
\Gamma_{im}=\frac{\gamma_{im}}{2}\left(\frac{M_t^I/I_t}{M_{t-1}^I/I_{t-1}}-1\right)^2. \tag{F6}
\]

### Exporters and Importers

Export producers combine domestic and imported inputs:

\[
X_t(i)=\left[\delta_x(\Lambda_{xy,t}Y_t^X)^{-\rho_x}
+(1-\delta_x)(\Lambda_{xm,t}M_t^X)^{-\rho_x}\right]^{-1/\rho_x}. \tag{F7}
\]

An exporting firm that can reset its foreign-currency price solves a Calvo problem:

\[
\max_{\{P_t^{\circ X}(i)\}}\sum_{s=0}^{\infty}\zeta_x^s E_t\left\{M_{t,t+s}
\left[P_{t+s|t}^{\circ X}(i)-S_{t+s}^{-1}\mathcal{MC}_{x,t+s}(i)\right]X_{t+s|t}(i)\right\}. \tag{F8}
\]

Foreign importers choose euro- or foreign-currency prices under Calvo frictions and face demand for FCP and PCP varieties. Their generic reset problem is:

\[
\max_{\{P_t^{\circ M,j}(k)\}}\sum_{s=0}^{\infty}\zeta_m^sE_t\left[R^{\ast}_{t,t+s}\mathcal{D}_{t+s|t}^j(k)\right],
\qquad j\in\{FCP,PCP\}. \tag{F9}
\]

### Households

Household \(h\) maximizes lifetime utility with external habit and labor disutility:

\[
E_t\sum_{s=t}^{\infty}\beta^{s-t}
\left[\zeta_s^C\log(C_{h,s}-b_cC_{s-1})-\frac{(H_{h,s})^{1+\sigma_l}}{1+\sigma_l}\right]. \tag{F10}
\]

The nominal budget constraint is:

\[
\begin{aligned}
(1+\tau_s^C)P_s^CC_{h,s}+P_s^II_{h,s}+B_{h,s+1}+B_{h,s+1}^E+S_sB_{h,s+1}^{\ast}
&=(1-\tau_s^W)W_sH_{h,s}+(1-\tau_s^K)R_s^KK_{h,s}\\
&\quad+\delta\tau_s^KP_s^IK_{h,s}+\mathcal{D}_{h,s}+R_{s-1}B_{h,s}\\
&\quad+\Gamma_{A^{\ast}}(A_s^{\ast},\zeta_{s-1}^E)(R_{s-1}^EB_{h,s}^E+R_{s-1}^{\ast}S_sB_{h,s}^{\ast})\\
&\quad-\mathcal{TR}_{h,s}+\mathcal{S}_{h,s}.
\end{aligned} \tag{F11}
\]

Capital accumulation is:

\[
K_{h,t+1}=(1-\delta)K_{h,t}+\zeta_t^I F(I_{h,t},I_{h,t-1}). \tag{F12}
\]

Households set differentiated wages under Calvo wage contracts. A reoptimizing household chooses \(W^{\ast}_{h,t}\) to maximize the discounted after-tax labor revenue net of labor disutility subject to labor demand and indexation; this is the source of the wage Phillips curve.

### Capital Producer and Entrepreneurs

The competitive capital producer chooses investment to maximize the value of new installed capital:

\[
\max_{\{I_t^{CGP}\}}\;E_0\sum_{t=0}^{\infty}\beta^t\phi_t
\left\{P_t^K\left[(1-\delta)K_t+\zeta_t^IF(I_t^{CGP},I_{t-1}^{CGP})\right]\right\}
-P_t^K(1-\delta)K_t-P_t^II_t^{CGP}. \tag{F13}
\]

Entrepreneurs finance capital expenditures with own net worth and bank loans:

\[
BL_{t+1}=P_t^K K_{t+1}-N_{t+1}. \tag{F14}
\]

Entrepreneurial equity is:

\[
V_t=\left[(1-\tau_t^K)\frac{R_t^K}{P_t^C}+(1-\delta+\delta\tau_t^K)Q_t\right]P_t^CK_t
-(1+r_{t-1}^b)(Q_{t-1}P_{t-1}^CK_t-N_t). \tag{F15}
\]

Net worth evolves as:

\[
N_{t+1}=\gamma V_t+W^e. \tag{F16}
\]

### Banks

The wholesale branch chooses loans and deposits subject to its balance sheet and a capital-ratio deviation cost:

\[
\max_{\{BL_{t+1},D_{t+1}\}}\;R_t^bBL_{t+1}-R_t^dD_{t+1}
-\frac{\kappa_{K^b}}{2}\left(\frac{K_{t+1}^b}{BL_{t+1}}-v_t^b\right)^2K_{t+1}^b
\quad\text{s.t.}\quad BL_{t+1}=D_{t+1}+K_{t+1}^b. \tag{F17}
\]

Retail loan branches choose differentiated loan rates with quadratic adjustment costs:

\[
\max_{\{r_{t+\tau}^b(z)\}}\;E_0\sum_{\tau=0}^{\infty}\beta^\tau\phi_{t+\tau}
\left[(r_{t+\tau}^b(z)-R_{t+\tau}^b)bl_{t+1+\tau}(z)
-\frac{\kappa_b}{2}\left(\frac{r_{t+\tau}^b(z)}{r_{t-1+\tau}^b(z)}-1\right)^2r_{t+\tau}^bBL_{t+1+\tau}\right]. \tag{F18}
\]

## 3. First-Order Conditions

The Rep-MMB file implements a linearized system. Equations below are structural FOCs or paper-reported/log-linearized conditions; several appendix-level mappings remain `needs_review`.

- **(F19) Nominal marginal cost for CES intermediate production**:

\[
\mathcal{MC}_t=\left[
\delta_Y^{1/(1+\rho_Y)}\left(\frac{R_t^K}{\Lambda_{k,t}}\right)^{\rho_Y/(1+\rho_Y)}
+(1-\delta_Y)^{1/(1+\rho_Y)}\left(\frac{(1+\tau_t^F)W_t}{\Lambda_{l,t}}\right)^{\rho_Y/(1+\rho_Y)}
\right]^{(1+\rho_Y)/\rho_Y}. \tag{F19}
\]

- **(F20) Intratemporal labor supply without wage rigidity**:

\[
\psi_{\Lambda,t}(1-\tau_t^W)\frac{W_{h,t}}{P_t^C\Lambda_{l,t}^P}
=\lambda_{w,t}H_{h,t}^{\sigma_l}. \tag{F20}
\]

- **(F21) Capital producer/Tobin's Q FOC**:

\[
\frac{P_t^I}{P_t^C}=
\frac{P_t^K}{P_t^C}\zeta_t^IF'(I_t^{CGP},I_{t-1}^{CGP})
+\beta E_t\frac{\psi_{t+1}}{\psi_t}\frac{P_{t+1}^K}{P_{t+1}^C}
\zeta_{t+1}^IF'(I_{t+1}^{CGP},I_t^{CGP}). \tag{F21}
\]

- **(F22) Entrepreneur capital Euler equation**:

\[
P_t^K=\beta E_t\left\{(1-\tau_{t+1}^K)R_{t+1}^K
+(1-\delta+\delta\tau_{t+1}^K)P_{t+1}^K-r_t^bP_t^K\right\}. \tag{F22}
\]

- **(F23) Real-price version of entrepreneur capital Euler equation**:

\[
Q_t=\frac{\beta}{1+\beta r_t^b}E_t\left[
(1-\tau_{t+1}^K)\frac{R_{t+1}^K}{P_t^C}
+\frac{(1-\delta+\delta\tau_{t+1}^K)Q_{t+1}P_{t+1}^C}{P_t^C}
\right]. \tag{F23}
\]

- **(F24) Wholesale loan spread condition**:

\[
S_t^w\equiv R_t^b-r_t^{FI}
=-\kappa_{K^b}\left(\frac{K_{t+1}^b}{BL_{t+1}}-v_t^b\right)
\left(\frac{K_{t+1}^b}{BL_{t+1}}\right)^2. \tag{F24}
\]

- **(F25) Retail loan-rate equation, log-linearized**:

\[
\tilde r_t^b=
\frac{\varepsilon^b-1}{\varepsilon^b-1+(1+\beta)\kappa_b}\tilde R_t^b
-\frac{1}{\varepsilon^b-1+(1+\beta)\kappa_b}\tilde\varepsilon_t^b
+\frac{\kappa_b}{\varepsilon^b-1+(1+\beta)\kappa_b}\tilde r_{t-1}^b
+\frac{\beta\kappa_b}{\varepsilon^b-1+(1+\beta)\kappa_b}E_t\tilde r_{t+1}^b. \tag{F25}
\]

- **(F26) Net wholesale loan rate, log-linearized**:

\[
\tilde R_t^b=\tilde R_t-\frac{\kappa_{K^b}}{R^b}(v^b)^3
\left(\tilde k_{t+1}^b-\tilde{bl}_{t+1}-\tilde v_t^b\right). \tag{F26}
\]

## 4. Market Clearing & Identities

- **(F27) Domestic intermediate-good market clearing**:

\[
\int_0^1Y_t(j)\,dj=Y_t^C+Y_t^I+Y_t^X. \tag{F27}
\]

- **(F28) Price-dispersion aggregation**:

\[
\int_0^1Y_t(j)\,dj=\Delta_{p,t}Y_t. \tag{F28}
\]

- **(F29) Export demand**:

\[
X_t=\exp(\epsilon_{x,t})\left(\frac{P_t^X}{P_t^W}\right)^{-1/(1+\rho_w)}M_t^W. \tag{F29}
\]

- **(F30) Import market clearing**:

\[
M_t=M_t^C+M_t^I+M_t^X. \tag{F30}
\]

- **(F31) Final consumption and investment market clearing**:

\[
C_t=C_t^H=\int_0^1C_{h,t}\,dh,\qquad
I_t=I_t^H+I_t^G=\int_0^1I_{h,t}\,dh+I_t^G. \tag{F31}
\]

- **(F32) Domestic bond-market clearing**:

\[
B_t=\int_0^1B_{h,t}\,dh=0. \tag{F32}
\]

- **(F33) Nominal aggregate resource constraint**:

\[
P_tY_t=P_t^CC_t^H+P_t^II_t^H+P_tC_t^G+P_t^II_t^G+S_tP_t^XX_t
-P_t^M(M_t^C+M_t^I+M_t^X). \tag{F33}
\]

- **(F34) Net foreign assets**:

\[
NFA_{t+1}^{\ast}=R_t^EB_t^E+R_t^{\ast}S_tB_t^{\ast}+TB_t. \tag{F34}
\]

- **(F35) Trade balance**:

\[
TB_t=S_tP_t^XX_t-P_t^M(M_t^C+M_t^I+M_t^X). \tag{F35}
\]

- **(F36) Terms of trade**:

\[
ToT_t=\frac{S_tP_t^X}{P_t^M}. \tag{F36}
\]

- **(F37) Bank capital accumulation**:

\[
K_{t+1}^b=(1-\delta^b)\frac{K_t^b}{\varepsilon_t^{Kb}}+J_t^b. \tag{F37}
\]

- **(F38) Bank profits**:

\[
J_t^B=r_{t-1}^bBL_t-r_{t-1}^{FI}D_t
-\frac{\kappa_{K^b}}{2}\left(\frac{K_{t+1}^b}{BL_{t+1}}-v_t^b\right)^2K_{t+1}^b
-\frac{\kappa_b}{2}\left(\frac{r_t^b}{r_{t-1}^b}-1\right)^2r_t^bBL_{t+1}. \tag{F38}
\]

## 5. Exogenous Processes

The source and implementation include many AR(1) shocks. The following list follows the paper's structural categories and the Rep-MMB shock names.

- **(F39) Permanent labor productivity growth**:

\[
\mu_t=\rho_\mu\mu_{t-1}+\varepsilon_{\mu,t}. \tag{F39}
\]

- **(F40) Temporary productivity shifters**:

\[
\lambda_{k,t}=\rho_{\lambda k}\lambda_{k,t-1}+\varepsilon_{\lambda k,t},\qquad
\lambda_{l,t}^T=\rho_{\lambda l}\lambda_{l,t-1}^T+\varepsilon_{\lambda l,t}. \tag{F40}
\]

- **(F41) Consumption and investment technology/preference shifters**:

\[
\lambda_{cy,t}=\rho_{cy}\lambda_{cy,t-1}+\varepsilon_{cy,t},\quad
\lambda_{cm,t}=\rho_{cm}\lambda_{cm,t-1}+\varepsilon_{cm,t},\quad
\lambda_{iy,t}=\rho_{iy}\lambda_{iy,t-1}+\varepsilon_{iy,t}. \tag{F41}
\]

- **(F42) Markup shocks**:

\[
\upsilon_t=\rho_\upsilon\upsilon_{t-1}+\varepsilon_{\upsilon,t},\quad
\upsilon_{m,t}=\rho_{\upsilon m}\upsilon_{m,t-1}+\varepsilon_{\upsilon m,t},\quad
\upsilon_{x,t}=\rho_{\upsilon x}\upsilon_{x,t-1}+\varepsilon_{\upsilon x,t}. \tag{F42}
\]

- **(F43) Demand, fiscal, external, and financial shocks**:

\[
zeta_{C,t},\ zeta_{E,t},\ \lambda_{W,t},\ i_t^G,\ h_t^G,\ c_t^{GF},\ p_t^{OIL},\ p_t^{RAW},\ m_t^W,\ \pi_t^W,\ \Delta s_t,\ \epsilon_{b,t},\ \epsilon_{Kb,t},\ r_t^{EUR}
\quad\text{follow AR(1) or exogenous processes in the linearized system.} \tag{F43}
\]

## 6. Steady-State Solution

The source states that the estimation uses the model's linear or log-linear state-space representation, with calibration and steady-state ratios reported in the tables. The Rep-MMB implementation computes a deterministic nonlinear steady state through a long set of auxiliary definitions before the `model(linear)` block.

For this first-pass derivation:

1. Normalize all linearized variables in the `model(linear)` block as deviations from the non-stochastic steady state; steady-state deviations are zero.
2. Use calibrated/estimated steady-state objects for relative prices, markups, taxes, spending shares, banking ratios, and foreign/external steady-state values.
3. Determine the deterministic steady-state ratios from the implementation's auxiliary definitions only as `implementation_cross_check`, not as paper-side proof.
4. Mark the full analytic steady-state reconstruction as `needs_review` because the paper tables and appendix equations were not manually reconciled with the `.mat` calibration file.

Key steady-state targets visible in the source include quarterly calibration, sample-average inflation, public consumption/investment/labor shares, tax rates, external import/export ratios, bank capital-to-asset ratio, loans-to-GDP, and loan spread. The implementation cross-check additionally uses constants such as `ssnuBank`, `BYSS_data`, and `spread_data` to construct `NWSS`, `BTOTSS`, bank capital, deposits, leverage, and loan ratios.

## 7. Timing & Form Conventions

- **Form**: Linearized/log-linearized system; Rep-MMB uses `model(linear)`.
- **Capital timing**: The paper writes household capital as \(K_{h,t+1}\) chosen at time \(t\); the implementation uses predetermined capital with `k(-1)` in production and capital-return equations.
- **Entrepreneur balance-sheet timing**: Entrepreneurs repay old loans and choose \(K_{t+1}\) at the end of period \(t\); net worth \(N_{t+1}\) finances next-period capital, while equity \(V_t\) is realized from period-\(t\) returns.
- **Bank balance-sheet timing**: Loans \(BL_{t+1}\) are assets chosen with deposits and bank capital. Bank profits use lagged loan/deposit returns, while bank capital accumulates into \(K_{t+1}^b\).
- **Nominal and relative prices**: The paper defines many nominal prices; the implementation works with log deviations of relative prices and inflation rates (`pC`, `pI`, `pM`, `pX`, `pieC`, `pieI`, `pieM`, `pieY`, `pieX`, `pieW`).
- **Source caution**: OCR has several notation corruptions (`rho_t^2` for markup-like terms, euro/foreign asset symbols, and equation numbering artifacts). These are retained only where interpretable and flagged in `extraction_notes.md`.

## 8. Variable & Parameter Reference Table

### Endogenous variables

| Category | Symbol / Rep-MMB name | Meaning | Main equation(s) |
|---|---|---|---|
| Endogenous | `y`, \(Y_t\) | domestic intermediate output | (F1), (F27), (F28), (F33) |
| Endogenous | `hF`, `hG`, `h`, \(H_t^F,H_t^G,H_t\) | private/public/total hours | (F20), market clearing |
| Endogenous | `k`, \(K_t\) | capital stock | (F12), (F21), (F22) |
| Endogenous | `cH`, `c`, \(C_t^H,C_t\) | household and total consumption | (F4), (F10), (F31), (F33) |
| Endogenous | `iH`, `iG`, `iT`, \(I_t^H,I_t^G,I_t\) | private, public, and total investment | (F5), (F12), (F21), (F31) |
| Endogenous | `q`, \(Q_t\) | real price of installed capital | (F21), (F23) |
| Endogenous | `rK`, \(R_t^K\) | rental return on capital | (F19), (F22) |
| Endogenous | `wF`, `wG`, `w`, \(W_t\) | private/public/average wages | (F20), wage setting |
| Endogenous | `mcY`, `mcX`, \(\mathcal{MC}_t,\mathcal{MC}_{x,t}\) | marginal costs | (F19), (F7), (F8) |
| Endogenous | `pieY`, `pieX`, `pieMC`, `pieM`, `pieC`, `pieI` | inflation rates | Calvo pricing (F3), (F8), (F9) |
| Endogenous | `pC`, `pI`, `pM`, `pX`, `pOILS`, `pRAWS` | relative prices | price identities |
| Endogenous | `yC`, `mC`, `yI`, `mI`, `yX`, `mX`, `m` | domestic/import input demands | (F4), (F5), (F7), (F30) |
| Endogenous | `x`, \(X_t\) | exports | (F7), (F29), (F33), (F35) |
| Endogenous | `rs`, `ds`, \(S_t\) | real/nominal exchange-rate objects | (F8), (F9), (F36) |
| Endogenous | `tbY`, `bstar`, `astar`, `ToT` | trade balance, NFA, terms of trade | (F34), (F35), (F36) |
| Endogenous | `rFI`, `rEUR`, `rs` | domestic/euro/external rates | household bond FOCs, implementation cross-check |
| Endogenous | `nwe`, \(N_t\) | entrepreneur net worth | (F15), (F16) |
| Endogenous | `btot`, \(BL_t\) | total loans | (F14), (F17) |
| Endogenous | `rb`, \(r_t^b\) | retail loan rate | (F18), (F25) |
| Endogenous | `RB`, \(R_t^b\) | wholesale loan rate | (F24), (F26) |
| Endogenous | `kbank`, \(K_t^b\) | bank capital | (F17), (F37) |
| Endogenous | `deposits`, \(D_t\) | bank deposits | (F17) |
| Endogenous | `bankprofits`, \(J_t^B\) | bank profits | (F38) |
| Endogenous | `bka`, `lev_e`, `by` | bank capital ratio, entrepreneur leverage, credit/output | banking identities |
| Endogenous | `psi`, `mu`, `lamK`, `lamLT`, `lamCY`, `lamCM`, `lamIY`, `upsilon*`, `zeta*`, `eps*` | shock states and preference/technology/markup wedges | (F39)-(F43) |

### Exogenous shocks

| Rep-MMB name | Meaning |
|---|---|
| `epsMU` | permanent labor productivity innovation |
| `epsLAMBDAK`, `epsLAMBDALT` | temporary capital and labor productivity innovations |
| `epsLAMBDACY`, `epsLAMBDACM`, `epsLAMBDAIY` | final-good technology/preference shifter innovations |
| `epsUPSILON`, `epsUPSILONMC`, `epsUPSILONX` | domestic/import/export markup innovations |
| `epsZETACH`, `epsZETAEUR`, `epsLAMW` | consumption preference, domestic risk premium, wage markup/labor innovation |
| `epsIG`, `epshG`, `epsGF` | government investment, government labor, government consumption innovations |
| `epsPOILS`, `epsPRAWS`, `epsMW`, `epsPIEW`, `epsdS`, `epsXX` | oil, raw material, world demand, foreign inflation, exchange-rate, export-share innovations |
| `epsEPSB`, `epsnuB`, `epsBankCapital`, `epsrEUR` | bank markup, capital requirement, bank capital, euro-area interest-rate innovations |

### Parameters

| Parameter group | Symbols / Rep-MMB names | Meaning |
|---|---|---|
| Preferences | `bet`, `bC`, `sigmaL`, `lambdaW`, `xiW` | discounting, habit, labor curvature, wage markup, wage Calvo |
| Production | `rhoY`, `deltaY`, `ssLAMBDAK`, `ssLAMBDALT`, `delta`, `ssMU` | CES production, factor shifters, depreciation, growth |
| Final goods | `rhoC`, `deltaC`, `gamCM`, `rhoI`, `deltaI`, `gamI`, `gamIM` | CES and adjustment costs for consumption/investment goods |
| Trade | `rhoX`, `deltaX`, `thetaX`, `zetaX`, `sigmaW`, `RMCX`, `omegaOIL`, `omegaRAW` | export/import CES, Calvo, demand elasticity, import composition |
| Prices | `zeta`, `theta`, `thetaMC`, `omegaMC` | domestic and import price Calvo/indexation/pass-through |
| Taxes/fiscal | `ssTAXWR`, `ssTAXFR`, `ssTAXCR`, `ssTAXKR`, `ssGCF`, `ssIG`, `ssHG` | labor, firm, consumption, capital taxes and public shares |
| Banking | `ssnuBank`, `kappaB`, `kappaKB`, `deltaBank`, `spread_data`, `BYSS_data` | bank capital ratio, loan-rate adjustment, capital-ratio cost, bank depreciation, steady ratios |
| Shock persistence | `rho*` parameters | AR(1) coefficients for technology, demand, markup, external, and financial shocks |
