# EA_DKR11 - Macroeconomic Propagation under Different Regulatory Regimes

> First-pass private archive derivation for `EA_DKR11`. Status: `needs_review`.
> Source: Matthieu Darracq Pariès, Christoffer Kok Sørensen, and Diego Rodriguez-Palenzuela (2011), "Macroeconomic propagation under different regulatory regimes: Evidence from an estimated DSGE model for the euro area", International Journal of Central Banking 7(4), 49-113. DOI: `10.2139/ssrn.1682085`.
> Primary Markdown: `raw/mmb_mineru/runs/ea_dkr11__macroeconomic_propagation_under_different_regulatory_regimes_evidence_fr__5f88c84d/full.md`.
> Raw PDF path exists for provenance, but the PDF body was not opened.

## 1. Model Overview

- **Model**: closed-economy euro-area DSGE model with patient savers, impatient household borrowers, entrepreneurs, two real sectors, nominal price and wage rigidities, and a banking sector with capital-ratio frictions.
- **Paper-side source match**: the first Markdown line reports the expected title and line 3 reports the expected authors. No title/author mismatch was detected in the first 80 Markdown lines.
- **Real sectors**: non-residential intermediate goods use capital and labor; residential intermediate goods use capital, labor, and fixed land. Retailers differentiate goods and set prices à la Calvo.
- **Credit frictions**: borrowers and entrepreneurs face costly-state-verification/default contracts with idiosyncratic collateral shocks. Commercial lending branches break even; default thresholds determine repayment, collateral seizure, and lending premia.
- **Banking sector**: wholesale bank branches fund household and entrepreneurial credit with deposits and bank capital. A quadratic cost penalizes deviations of the bank capital ratio from a target. Retail deposit and loan-book financing branches set deposit and lending rates under Calvo-style interest-rate rigidity.
- **Policy experiments**: the benchmark regime is Basel I-like fixed risk weights; the paper also studies risk-sensitive Basel II-like requirements, higher capital requirements, and countercyclical macroprudential rules.
- **Model form**: nonlinear structural model estimated with Bayesian methods. The MMB implementation cross-check is a nonlinear Dynare model with levels, ratios, and observation equations rather than `model(linear)`.
- **Runtime validation**: not performed. Dynare was not run, and this derivation was not promoted to the runnable skill archive.

## 2. Optimization Problems

### Patient Savers

Patient households maximize expected lifetime utility over a composite of non-residential consumption and housing services, less sectoral labor disutility:

$$
E_t\sum_{j=0}^{\infty}\beta^j\varepsilon_{t+j}^{\beta}
\left[
\frac{(X_{t+j}^{s})^{1-\sigma_X}}{1-\sigma_X}
-\sum_{m\in\{C,D\}}\frac{\varepsilon_{t+j}^{L}\bar L_m}{1+\sigma_{Lm}}
(N_{m,t+j}^{s})^{1+\sigma_{Lm}}
\right].
$$

The consumption-service aggregator is

$$
X_t^s=\left[(1-\varepsilon_t^D\omega_D)^{1/\eta_D}
(C_t^s-h_SC_{t-1}^s)^{(\eta_D-1)/\eta_D}
+(\varepsilon_t^D\omega_D)^{1/\eta_D}(D_t^s)^{(\eta_D-1)/\eta_D}
\right]^{\eta_D/(\eta_D-1)}.
$$

The saver budget constraint is

$$
C_t^s+Q_{D,t}T_{D,t}\big(D_t^s-(1-\delta)D_{t-1}^s\big)+Dep_t^s
=\frac{1+R_{D,t-1}}{1+\pi_t}Dep_{t-1}^s
+(1-\tau_{w,t})(w_{C,t}^sN_{C,t}^s+w_{D,t}^sN_{D,t}^s)+\Pi_t^s+TT_t^s.
$$

### Impatient Borrowers

Impatient households have the same aggregator structure but a lower discount factor. They choose non-residential consumption, housing, household debt, default threshold, and labor supplies subject to a budget constraint and a zero-profit condition for lending banks:

$$
\widetilde C_t+\widetilde Q_{D,t}T_{D,t}\big(\widetilde D_t-(1-\delta)\widetilde D_{t-1}\big)
+H(\bar\varpi_{HH,t})\widetilde A_{HH,t}
=B_{HH,t}+\widetilde TT_t+\widetilde w_{C,t}\widetilde N_{C,t}
+\widetilde w_{D,t}\widetilde N_{D,t}.
$$

Borrowers' enforceable collateral is

$$
\widetilde A_{HH,t}=(1-\chi_{HH})\widetilde Q_{D,t}T_{D,t}(1-\delta)\widetilde D_{t-1}.
$$

### Entrepreneurs

Entrepreneurs maximize utility from non-residential consumption with habit:

$$
E_t\sum_{j=0}^{\infty}\beta_E^j
\varepsilon_{t+j}^{\beta}
\frac{(C_{t+j}^E-h_EC_{t+j-1}^E)^{1-\sigma_{CE}}}{1-\sigma_{CE}},
$$

subject to production technologies

$$
Z_t(e)=\varepsilon_t^A(u_t^C(e)K_{t-1}^C(e))^{\alpha_C}
L_t^C(e)^{1-\alpha_C}-\Omega_C,
$$

$$
Z_{D,t}(e)=\varepsilon_t^{A_D}(u_t^D(e)K_{t-1}^D(e))^{\alpha_D}
L_t^D(e)^{1-\alpha_D-\alpha_{\mathcal L}}\mathcal L_t(e)^{\alpha_{\mathcal L}}-\Omega_D,
$$

and an aggregate budget constraint:

$$
\begin{aligned}
C_t^E&+Q_t^C(K_t^C-(1-\delta_K)K_{t-1}^C)
+Q_t^D(K_t^D-(1-\delta_K)K_{t-1}^D)
+H^E(\bar\varpi_{E,t})\widetilde A_{E,t} \\
&=B_{E,t}+MC_tZ_t+MC_{D,t}Z_{D,t}-W_{C,t}^rL_{C,t}-W_{D,t}^rL_{D,t}
-p_{\ell,t}\mathcal L_t-\Phi(u_t^C)K_{t-1}^C-\Phi(u_t^D)K_{t-1}^D+TT_t^E.
\end{aligned}
$$

The entrepreneur collateral value is

$$
\widetilde A_{E,t}=(1-\chi_E)(1-\delta_K)(Q_t^CK_{t-1}^C+Q_t^DK_{t-1}^D).
$$

### Retailers, Stock Producers, and Banks

Retailers buy homogeneous intermediate goods and set differentiated prices under Calvo frictions. Capital and housing-stock producers transform final goods into new capital and housing stocks subject to investment adjustment costs. Wholesale banks solve a static profit problem under a balance-sheet identity and a quadratic bank-capital-ratio cost; retail deposit and loan-book branches choose reset interest rates under Calvo-type stickiness.

## 3. First-Order Conditions

The paper does not print a compact full set of all FOCs; this first-pass archive records the structural equilibrium conditions visible in the Markdown and marks compacted or implementation-confirmed blocks as `needs_review`.

**(F1) Saver consumption-service marginal utility**

$$
UC_t=\varepsilon_t^\beta (X_t^s)^{-\sigma_X}
(1-\varepsilon_t^D\omega_D)^{1/\eta_D}
(X_t^s)^{1/\eta_D}(C_t^s-h_SC_{t-1}^s)^{-1/\eta_D}
-\beta h_S E_t[\cdots] .
$$

The forward habit term is OCR-abbreviated here and needs source-level review.

**(F2) Saver housing Euler condition**

$$
Q_{D,t}T_{D,t}UC_t=UC_{D,t}+\beta(1-\delta)E_t[UC_{t+1}Q_{D,t+1}T_{D,t+1}].
$$

**(F3) Saver deposit Euler condition**

$$
UC_t=\beta E_t\left[UC_{t+1}\frac{1+R_{D,t}}{1+\pi_{t+1}}\right].
$$

**(F4) Borrower default cutoff**

$$
\bar\varpi_{HH,t}\widetilde A_{HH,t}
=\frac{1+R_{HH,t}^L}{1+\pi_t}B_{HH,t-1}.
$$

**(F5) Borrower repayment/default share**

$$
H(\bar\varpi_{HH,t})=
\left(1-F_t(\bar\varpi_{HH,t})\right)\bar\varpi_{HH,t}
+\int_0^{\bar\varpi_{HH,t}}\varpi\,dF_t(\varpi).
$$

**(F6) Household-credit bank break-even condition**

$$
G(\bar\varpi_{HH,t})\widetilde A_{HH,t}
=\frac{1+R_{HH,t-1}}{1+\pi_t}B_{HH,t-1},
$$

where

$$
G(\bar\varpi_{HH,t})=
\left(1-F_t(\bar\varpi_{HH,t})\right)\bar\varpi_{HH,t}
+(1-\mu_{HH})\int_0^{\bar\varpi_{HH,t}}\varpi\,dF_t(\varpi).
$$

**(F7) Borrower modified Euler condition**

$$
1=\beta_B E_t\left[\frac{UCNR_{t+1}}{UCNR_t}
\frac{1+R_{L,t}}{1+\pi_{t+1}}\Psi_{HH,t+1}\right].
$$

Here $\Psi_{HH,t}$ is the external-finance-premium term induced by the default contract; this compact notation is `needs_review`.

**(F8) Borrower housing Euler condition**

$$
Q_{H,t}^{NR}T_{D,t}
=\frac{UC_{D,t}^{NR}}{UCNR_t}
+\beta_B(1-\delta)E_t\left[\frac{UCNR_{t+1}}{UCNR_t}Q_{H,t+1}^{NR}T_{D,t+1}
\left(1-\chi_{HH}\right)(H_{HH,t+1}+G_{HH,t+1}\Psi_{HH,t+1})Q_{H,t+1}^{NR}T_{D,t+1}\right].
$$

**(F9) Entrepreneur default cutoff**

$$
\bar\varpi_{E,t}\widetilde A_{E,t}
=\frac{1+R_{E,t}^L}{1+\pi_t}B_{E,t-1}.
$$

**(F10) Entrepreneur repayment/default share**

$$
H^E(\bar\varpi_{E,t})=
\left(1-F_t^E(\bar\varpi_{E,t})\right)\bar\varpi_{E,t}
+\int_0^{\bar\varpi_{E,t}}\varpi\,dF_t^E(\varpi).
$$

**(F11) Entrepreneur-credit bank break-even condition**

$$
G^E(\bar\varpi_{E,t})\widetilde A_{E,t}
=\frac{1+R_{E,t-1}}{1+\pi_t}B_{E,t-1},
$$

where

$$
G^E(\bar\varpi_{E,t})=
\left(1-F_t^E(\bar\varpi_{E,t})\right)\bar\varpi_{E,t}
+(1-\mu_E)\int_0^{\bar\varpi_{E,t}}\varpi\,dF_t^E(\varpi).
$$

**(F12) Entrepreneur consumption Euler with external-finance premium**

$$
1=\beta_E E_t\left[\frac{UC^E_{t+1}}{UC^E_t}
\frac{1+R_{L,E,t}}{1+\pi_{t+1}}\Psi_{E,t+1}\right].
$$

**(F13) Entrepreneur non-residential capital Euler**

$$
Q_t^C=\beta_E E_t\left[\frac{UC^E_{t+1}}{UC^E_t}
\left(Q_{t+1}^C(1-\delta_K)+u_{t+1}^C\Phi'(u_{t+1}^C)-\Phi(u_{t+1}^C)\right)\right]
+\text{collateral-premium term}.
$$

The collateral-premium term follows the paper's default-contract wedge and is `needs_review`.

**(F14) Entrepreneur residential capital Euler**

$$
Q_t^D=\beta_E E_t\left[\frac{UC^E_{t+1}}{UC^E_t}
\left(Q_{t+1}^D(1-\delta_K)+u_{t+1}^D\Phi'(u_{t+1}^D)-\Phi(u_{t+1}^D)\right)\right]
+\text{collateral-premium term}.
$$

**(F15) Capacity utilization condition**

$$
\Phi'(u_t^C)=R_{K,t}^C,\qquad \Phi'(u_t^D)=R_{K,t}^D.
$$

**(F16) Marginal cost in the non-residential sector**

$$
MC_t=\left(\frac{R_{K,t}^C}{\alpha_C}\right)^{\alpha_C}
\left(\frac{W_{C,t}}{1-\alpha_C}\right)^{1-\alpha_C}
(\varepsilon_t^A)^{-1}.
$$

**(F17) Marginal cost in the residential sector**

$$
MC_{D,t}T_{D,t}=
\left(\frac{R_{K,t}^D}{\alpha_D}\right)^{\alpha_D}
\left(\frac{W_{D,t}}{1-\alpha_D-\alpha_{\mathcal L}}\right)^{1-\alpha_D-\alpha_{\mathcal L}}
\left(\frac{p_{\ell,t}}{\alpha_{\mathcal L}}\right)^{\alpha_{\mathcal L}}
(\varepsilon_t^{A_D})^{-1}.
$$

**(F18) Capital-stock producer FOC**

$$
Q_t^C\left[1-S_t^C-\frac{I_t^C}{I_{t-1}^C}S_{1,t}^C\right]\varepsilon_t^I
+\beta E_t\left[Q_{t+1}^C\frac{UC_{t+1}}{UC_t}S_{1,t+1}^C
\left(\frac{I_{t+1}^C}{I_t^C}\right)^2\varepsilon_{t+1}^I\right]=1.
$$

**(F19) Housing-stock producer FOC**

$$
Q_{H,t}\left[1-S_{H,t}-\frac{I_{H,t}}{I_{H,t-1}}S_{H1,t}\right]
+\beta E_t\left[Q_{H,t+1}\frac{T_{D,t+1}}{T_{D,t}}\frac{UC_{t+1}}{UC_t}
S_{H1,t+1}\left(\frac{I_{H,t+1}}{I_{H,t}}\right)^2\right]=1.
$$

**(F20) Calvo price reset: non-residential sector**

$$
\left(\mu(1-subv)\frac{ZP1_t}{ZP2_t}\right)^{1/(1-\mu)}(1-\xi_p)
+1-\xi_p AP_t^{1/(\mu-1)}=0.
$$

**(F21) Calvo price recursion: non-residential numerator**

$$
ZP1_t=UC_tMC_tY_t+\beta\xi_p E_t[AP_{t+1}^{\mu/(\mu-1)}ZP1_{t+1}].
$$

**(F22) Calvo price recursion: non-residential denominator**

$$
ZP2_t=(1-\tau)UC_tY_t+\beta\xi_p E_t[AP_{t+1}^{1/(\mu-1)}ZP2_{t+1}].
$$

**(F23) Calvo wage reset: sector/type block**

$$
W_{j,i,t}^{1/(1-\mu_w)}
=(1-\xi_{w,j,i})\left(\mu_w(1-subw)\frac{ZW1_{j,i,t}}{ZW2_{j,i,t}}\right)^{-1/(\mu_w-1)}
+\xi_{w,j,i}W_{j,i,t-1}^{1/(1-\mu_w)}AW_{j,i,t}^{-1/(1-\mu_w)}.
$$

This summarizes the four wage-setting blocks for saver/borrower labor in non-residential and residential sectors; each block needs formula-level review before promotion.

**(F24) Wholesale bank balance sheet**

$$
B_{HH,t}^{wb}+B_{E,t}^{wb}=Dep_t^{wb}+Bankcap_t.
$$

**(F25) Basel I household-loan wholesale spread**

$$
R_{HH,t}^{wb}-R_t=
-\chi_{wb}\left(\frac{Bankcap_t}{0.5B_{HH,t}^{wb}+B_{E,t}^{wb}}-0.11\right)
\left(\frac{Bankcap_t}{0.5B_{HH,t}^{wb}+B_{E,t}^{wb}}\right)^2 0.5.
$$

**(F26) Basel I entrepreneur-loan wholesale spread**

$$
R_{E,t}^{wb}-R_t=
-\chi_{wb}\left(\frac{Bankcap_t}{0.5B_{HH,t}^{wb}+B_{E,t}^{wb}}-0.11\right)
\left(\frac{Bankcap_t}{0.5B_{HH,t}^{wb}+B_{E,t}^{wb}}\right)^2.
$$

**(F27) Bank capital accumulation**

$$
Bankcap_t=(1-\delta^{wb})Bankcap_{t-1}+\nu^b\Pi_t^b.
$$

**(F28) Retail deposit-rate reset**

$$
\hat R_{D,t}
=\arg\max_{\hat R}
E_t\sum_{k=0}^{\infty}(\beta\xi_D^R)^k
\frac{\Lambda_{t+k}}{\Lambda_t}
\left(R_{t+k}-\hat R\right)Dep_{t+k}(j).
$$

**(F29) Retail loan-rate reset**

$$
\hat R_{i,t}
=\arg\max_{\hat R}
E_t\sum_{k=0}^{\infty}(\beta\xi_i^R)^k
\frac{\Lambda_{t+k}}{\Lambda_t}
\left(\hat R-R_{i,t+k}^{wb}\right)B_{i,t+k}(j),
\qquad i\in\{HH,E\}.
$$

**(F30) Retail rate dispersion/index equation**

$$
R_{i,t}^{1/(1-\mu_i^R)}
=(1-\xi_i^R)\hat R_{i,t}^{1/(1-\mu_i^R)}
+\xi_i^R R_{i,t-1}^{1/(1-\mu_i^R)},\qquad i\in\{D,HH,E\}.
$$

## 4. Market Clearing & Identities

**(F31) Non-residential resource constraint**

$$
Y_t=C_t^E+\omega C_t^B+(1-\omega)C_t^S+I_t+G_t+\Phi(u_t^C)K_{t-1}^C+\Phi(u_t^D)K_{t-1}^D.
$$

**(F32) Residential resource constraint**

$$
Z_{D,t}=(1-\omega)I_{H,t}^S+\omega I_{H,t}^B+G_D.
$$

**(F33) Aggregate capital, labor, and investment identities**

$$
K_t=K_t^C+K_t^D,\qquad L_t=L_{C,t}+L_{D,t},\qquad I_t=I_t^C+I_t^D.
$$

**(F34) Bank loan/deposit aggregation**

$$
Debt_t^{TOT}=\omega B_{HH,t}+B_{E,t},\qquad Dep_t+Bankcap_t=Debt_t^{TOT}.
$$

**(F35) Monetary policy rule**

$$
r_t=\rho r_{t-1}+(1-\rho)(r_{\pi}\pi_{t-1}+r_y y_{t-1})
+r_{\Delta\pi}\Delta\pi_t+r_{\Delta y}\Delta y_t+r_{T_D}\Delta t_{D,t}
+\log(\varepsilon_t^R).
$$

**(F36) Countercyclical capital-requirement rule**

$$
cap_t=\rho^{bc}cap_{t-1}+r_y^{bc}y_t+r_{\Delta y}^{bc}\Delta y_t
+r_{\Delta h}^{bc}\Delta b_{HH,t}+r_{\Delta e}^{bc}\Delta b_{E,t}
+r_{T_D}^{bc}\Delta t_{D,t}+r_Q^{bc}\Delta q_t.
$$

## 5. Exogenous Processes

The paper states that the main structural disturbances are AR(1) unless otherwise noted. The implementation cross-check confirms the following process families and shock names.

**(F37) Technology shocks**

$$
\log\varepsilon_t^A=\rho_A\log\varepsilon_{t-1}^A+\xi_{A,t},\qquad
\log\varepsilon_t^{A_D}=\rho_{A_D}\log\varepsilon_{t-1}^{A_D}+\xi_{A_D,t}.
$$

**(F38) Preference, housing-preference, government, and labor shocks**

$$
\log\varepsilon_t^j=\rho_j\log\varepsilon_{t-1}^j+\xi_{j,t},
\qquad j\in\{\beta,D,G,L\}.
$$

**(F39) Investment-specific and housing-investment shocks**

$$
\log\varepsilon_t^I=\rho_I\log\varepsilon_{t-1}^I+\xi_{I,t},\qquad
\log\varepsilon_t^{IH}=\rho_{IH}\log\varepsilon_{t-1}^{IH}+\xi_{IH,t}.
$$

**(F40) Retail rate markup shocks**

$$
\log\varepsilon_{i,t}^{R}=\rho_i^R\log\varepsilon_{i,t-1}^{R}+\xi_{i,t}^{R},
\qquad i\in\{D,HH,E\}.
$$

**(F41) Borrower riskiness shocks**

$$
\log\sigma_{i,t}=\rho_{\sigma_i}\log\sigma_{i,t-1}+\xi_{\sigma_i,t},
\qquad i\in\{HH,E\}.
$$

**(F42) Bank capital and monetary policy shocks**

$$
\log\varepsilon_t^{Bankcap}=\rho_{Bankcap}\log\varepsilon_{t-1}^{Bankcap}+\xi_{Bankcap,t},
\qquad \log\varepsilon_t^R=\xi_{R,t}.
$$

## 6. Steady-State Solution

The archive status is `needs_review`: the paper gives calibration targets and descriptive steady-state restrictions, while the full algebra is lengthy and partly encoded in the MMB implementation. No Dynare steady-state validation was run.

1. Set zero inflation and normalize the stationary shocks at their means: $\bar\pi=0$, $\bar\varepsilon^A=\bar\varepsilon^{A_D}=\bar\varepsilon^\beta=\bar\varepsilon^D=\bar\varepsilon^G=\bar\varepsilon^L=1$.
2. The patient discount factor pins down the real deposit rate. The paper calibrates patient $\beta=0.995$, implying an annual real deposit rate near 2 percent.
3. Set capital and housing depreciation from Appendix 2: housing depreciation $\delta=0.01$ quarterly and capital depreciation $\delta_K=0.1$ annually in the paper notation.
4. Use goods-market markups of 1.3 and labor-market markups of 1.5 for both sectors.
5. Set the residential utility share $\omega_D$ to match the residential-investment-to-GDP ratio; set $\eta_D=1$ and entrepreneur intertemporal elasticity $\sigma_{CE}=1$.
6. Determine loan and deposit markups so that the loan-deposit margin is 100 annual basis points, with household and entrepreneur lending spreads of 200 and 120 annual basis points.
7. Solve steady-state default cutoffs $\bar\varpi_{HH}$ and $\bar\varpi_E$ from the modified Euler equations and zero-profit conditions. With monitoring costs $\mu_E=0.2$ and $\mu_{HH}=0.15$, choose idiosyncratic risk variances to reproduce default frequencies of 0.7 percent for firms and 0.3 percent for impatient households.
8. Calibrate borrower share $\omega=0.25$. Choose loan-to-value terms $(1-\chi_E)=0.6$ and $(1-\chi_{HH})=0.2$ to match corporate loans near 33 percent of annual GDP and household housing loans near 25 percent of annual GDP.
9. For the bank block, target an 11 percent bank capital ratio in the Basel I benchmark; retained earnings and bank profit close bank capital accumulation.
10. The full sequential closed-form steady-state assignment is `needs_review`; the implementation cross-check contains many back-solved steady-state aliases, but those are not treated as paper-side mathematical evidence.

## 7. Timing & Form Conventions

- Capital and housing stocks are predetermined in production and collateral terms: period `t` production uses $K_{t-1}^C$, $K_{t-1}^D$, and $D_{t-1}$.
- Default cutoffs use debt issued in the previous period and realized collateral values in the current period.
- Borrower and entrepreneur lending rates are one-period rates. Retail loan and deposit rates are sticky composite rates set by Calvo-like branches.
- Bank capital is a state variable accumulated from lagged bank capital and retained bank profits.
- The policy rule is written in deviations from deterministic steady state. Lowercase variables in the policy-rule block denote log deviations.
- The model is nonlinear in the structural paper and in the MMB implementation cross-check. Observation equations convert model levels and rates into data units.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Main equation(s) |
|---|---|---|---|
| Endogenous | `C`, `CNR`, $C^S$, $C^B$ | saver and borrower non-residential consumption | (F1), (F7), (F31) |
| Endogenous | `D`, `DNR` | saver and borrower housing stock | (F2), (F8), (F32) |
| Endogenous | `Debt`, `Debt_E` | household and entrepreneur debt | (F4), (F6), (F9), (F11), (F34) |
| Endogenous | `OMEG_HH`, `OMEG` | household and entrepreneur default cutoffs | (F4), (F9) |
| Endogenous | `H_OMEG_HH`, `G_OMEG_HH`, `H_OMEG`, `G_OMEG` | repayment and bank recovery shares | (F5), (F6), (F10), (F11) |
| Endogenous | `PSI`, `PSI_E` | external finance premium terms | (F7), (F8), (F12)-(F14) |
| Endogenous | `C_E` | entrepreneur consumption | (F12), (F31) |
| Endogenous | `K_C`, `K_D`, `Q`, `Q_D` | sectoral capital and asset prices | (F13), (F14), (F18), (F33) |
| Endogenous | `TCU`, `TCU_D`, `R_K` | capacity utilization and rental return | (F15) |
| Endogenous | `Z`, `Z_D`, `Y` | intermediate and final output | (F16), (F17), (F31), (F32) |
| Endogenous | `MC`, `MC_D` | sectoral marginal costs | (F16), (F17), (F21), (F22) |
| Endogenous | `Dp`, `Dp_D`, `ZP1`, `ZP2` | Calvo price dispersion/recursions | (F20)-(F22) |
| Endogenous | `W_C`, `W_D`, `Dw_C`, `Dw_D` | wages and wage dispersion | (F23) |
| Endogenous | `R`, `R_D`, `R_L`, `R_L_E` | policy, deposit, household-loan, and entrepreneur-loan rates | (F3), (F28)-(F30), (F35) |
| Endogenous | `Bankcap`, `Debt_TOT`, `Depo`, `LEV` | bank capital, aggregate loans, deposits, leverage | (F24), (F27), (F34) |
| Endogenous | `RB_L`, `RB_L_E`, `SB_L`, `SB_L_E` | wholesale lending rates and spreads | (F25), (F26) |
| Exogenous | `E_A`, `E_A_D` | technology innovations | (F37) |
| Exogenous | `E_B`, `E_G`, `E_L`, `E_H` | preference, public spending, labor, housing preference innovations | (F38) |
| Exogenous | `E_I` | investment-specific innovation | (F39) |
| Exogenous | `E_R_D`, `E_R_L`, `E_R_L_E` | retail deposit and lending-rate markup innovations | (F40) |
| Exogenous | `E_SIG_HH`, `E_SIG` | household and entrepreneur riskiness innovations | (F41) |
| Exogenous | `E_Bankcap`, `E_R` | bank capital and monetary policy innovations | (F42) |
| Parameter | `betta`, `betta_NR`, `betta_NR_E` | saver, borrower, and entrepreneur discount factors | steady state |
| Parameter | `omega_NR`, `omega_D` | borrower share and housing preference share | (F1), (F31), (F32) |
| Parameter | `alph`, `alph_D`, `alph_LAN` | production shares | (F16), (F17) |
| Parameter | `tau`, `tau_D` | capital/housing depreciation notation in implementation | (F13), (F14), (F18), (F19) |
| Parameter | `mu_NFC`, `mu_HH`, `chi_NR_E`, `chi_NR` | monitoring costs and collateral exemptions | (F4)-(F11) |
| Parameter | `xi_p`, `xi_p_D`, `xi_w_C`, `xi_w_D` | price and wage Calvo probabilities | (F20)-(F23) |
| Parameter | `xi_R_D`, `xi_R_L`, `xi_R_L_E` | retail rate Calvo probabilities | (F28)-(F30) |
| Parameter | `kappa_b`, `nu_b`, `omega_B` | bank capital cost, target/retention parameters | (F25)-(F27) |
| Parameter | `rho`, `r_PI`, `r_y`, `r_dpi`, `r_dy`, `r_dtd` | monetary policy rule parameters | (F35) |
| Parameter | `rho_*` | shock persistence parameters | (F37)-(F42) |

The table is intentionally broad because the MMB model is large. Formula-level reconciliation with the full `.mod` equation count is deferred; this entry is a first-pass, source-backed derivation and remains `needs_review`.
