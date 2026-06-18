# US_LTW17rot -- Derivation (Optimization Problems + First-Order Conditions)

> Status: needs_review. This first-pass archive entry extracts the paper-side model structure from MinerU Markdown and uses `.agents/skills/dynare-copilot/references/examples/US_LTW17rot_rep.mod` only as an implementation_cross_check. Runtime validation was not performed.

Provenance: `US_LTW17rot`, Leeper, Traum, and Walker (2017), "Clearing Up the Fiscal Multiplier Morass," American Economic Review 107(8): 2409-2454, DOI `10.1257/aer.20111196`. Source Markdown: `raw/mmb_mineru/runs/us_ltw17_us_ltw17gz_us_ltw17nu_us_ltw17rot__clearing_up_the_fiscal_multiplier_morass__f1cc32b3/full.md`. Raw PDF: `raw/mmb_papers/Clearing Up the Fiscal Multiplier Morass.pdf`.

## 1. Model Overview

- **Model**: Medium-scale fiscal/monetary DSGE model for US government spending multipliers, with fiscal detail layered onto the Christiano-Eichenbaum-Evans and Smets-Wouters class.
- **MMB variant**: `US_LTW17rot` is the rule-of-thumb-consumer implementation variant. The paper's final estimated model sets the non-saver share to zero and uses government spending in utility; this archive entry records the broader paper model and flags the `rot` implementation differences as implementation_cross_check evidence.
- **Agents**: final-good firms, monopolistically competitive intermediate firms, labor agency/unions, saver households, non-saver households, fiscal authority, and monetary authority.
- **Frictions**: Calvo prices, Calvo wages, price and wage indexation, external habit in consumption, investment adjustment costs, variable capital utilization, long-maturity nominal government debt, and steady-state distorting taxes.
- **Policy regimes**: regime M is active monetary/passive fiscal; regime F is passive monetary/active fiscal.
- **Form**: the MMB implementation is `model(linear)` and all equations below are written as source-level nonlinear definitions or log-linear equilibrium conditions as indicated. Formula OCR is first-pass and needs_review where the source text was malformed.

## 2. Optimization Problems

### Final-Good Producer

The final-good producer aggregates differentiated intermediate goods:

$$Y_t = \left(\int_0^1 Y_t(i)^{\frac{1}{1+\eta_t^p}}\,di\right)^{1+\eta_t^p} \tag{(F1)}$$

Demand for intermediate good \(i\) is:

$$Y_t(i)=Y_t\left(\frac{P_t(i)}{P_t}\right)^{-\frac{1+\eta_t^p}{\eta_t^p}} \tag{(F2)}$$

### Intermediate-Goods Firms

Intermediate firms rent capital and labor and produce:

$$Y_t(i)=K_t(i)^\alpha\big(A_t L_t(i)\big)^{1-\alpha}-A_t\Omega \tag{(F3)}$$

Cost minimization gives nominal marginal cost:

$$MC_t=(1-\alpha)^{\alpha-1}\alpha^{-\alpha}(R_t^k)^\alpha W_t^{1-\alpha}A_t^{-1+\alpha} \tag{(F4)}$$

Firms that can reset prices maximize:

$$E_t\sum_{s=0}^{\infty}(\beta\omega_p)^s\frac{\lambda_{t+s}}{\lambda_t}
\left[\left(\prod_{k=1}^{s}\pi_{t+k-1}^{\chi_p}\pi^{1-\chi_p}\right)P_t^{\ast}(i)Y_{t+s}(i)-MC_{t+s}Y_{t+s}(i)\right] \tag{(F5), needs_review}$$

The plus sign before the profit bracket in (F5) follows the OCR text but should likely be read as multiplication of the discount factor and profit term; review against the PDF.

### Labor Agency And Wage Setters

The competitive labor agency aggregates differentiated labor:

$$L_t=\left(\int_0^1 L_t(l)^{\frac{1}{1+\eta_t^w}}\,dl\right)^{1+\eta_t^w} \tag{(F6)}$$

Labor demand for type \(l\) is:

$$L_t(l)=L_t^d\left(\frac{W_t(l)}{W_t}\right)^{-\frac{1+\eta_t^w}{\eta_t^w}} \tag{(F7)}$$

Wage setters face Calvo resetting with indexation:

$$W_t(l)=W_{t-1}(l)\big(\pi_{t-1}e^{u^a_{t-1}}\big)^{\chi_w}(\pi e^\gamma)^{1-\chi_w} \tag{(F8), needs_review}$$

### Saver Households

Saver household \(j\) maximizes:

$$E_0\sum_{t=0}^{\infty}\beta^t u_t^b\left[\log\left(C_t^{\astS}(j)-\theta\widetilde C_{t-1}^{\astS}\right)-\frac{(L_t^S(j))^{1+\xi}}{1+\xi}\right] \tag{(F9)}$$

Composite consumption in utility is:

$$C_t^{\astS}(j)=C_t^S(j)+\alpha_G G_t \tag{(F10)}$$

The nominal saver budget constraint is:

$$\begin{aligned}
P_t(1+\tau_t^C)C_t^S(j)+P_tI_t^S(j)+P_t^B B_t(j)+R_t^{-1}B_{s,t}(j)
&=(1+\rho P_t^B)B_{t-1}(j)+B_{s,t-1}(j)\\
&\quad +(1-\tau_t^L)\int_0^1 W_t(l)L_t^S(j,l)\,dl\\
&\quad +(1-\tau_t^K)R_t^k v_t(j)\bar K_{t-1}^S(j)-\psi(v_t)\bar K_{t-1}^S(j)\\
&\quad +P_tZ_t^S(j)+D_t(j).
\end{aligned} \tag{(F11)}$$

Capital evolves according to:

$$\bar K_t^S(j)=(1-\delta)\bar K_{t-1}^S(j)+u_t^i\left[1-s\left(\frac{I_t^S(j)}{I_{t-1}^S(j)}\right)\right]I_t^S(j) \tag{(F12)}$$

Effective capital is:

$$K_t^S(j)=v_t(j)\bar K_{t-1}^S(j) \tag{(F13)}$$

### Non-Saver Households

Non-savers consume current disposable income:

$$P_t(1+\tau_t^C)C_t^N(j)=(1-\tau_t^L)\int_0^1 W_t(l)L_t^N(j,l)\,dl+P_tZ_t^N(j) \tag{(F14)}$$

## 3. First-Order Conditions

The source paper does not list every nonlinear FOC in a single appendix block in the OCR text. The following conditions combine directly visible source formulas with the implemented `model(linear)` equations used only as implementation_cross_check.

**(F15) Saver marginal utility of wealth, log-linear implementation_cross_check**:

$$\lambda_t+\frac{\theta}{e^\gamma-\theta}u_t^a+\frac{e^\gamma}{e^\gamma-\theta}c_t^{\ast} -u_t^b+\frac{\tau^C}{1+\tau^C}\tau_t^C
=\frac{\theta}{e^\gamma-\theta}c_{t-1}^{\ast}$$

**(F16) Saver Euler equation, log-linear implementation_cross_check**:

$$\lambda_t-R_t+\pi_{t+1}-\lambda_{t+1}+\rho_a u_t^a=0$$

**(F17) Capital utilization condition, log-linear implementation_cross_check**:

$$\frac{1-\psi}{\psi}r_t^k-v_t-\frac{1-\psi}{\psi}\frac{\tau^K}{1-\tau^K}\tau_t^K=0$$

**(F18) Capital FOC, log-linear implementation_cross_check**:

$$q_t+R_t-\pi_{t+1}-\beta e^{-\gamma}(1-\delta)q_{t+1}
-\beta e^{-\gamma}R^K(1-\tau^K)r_{t+1}^k
+\tau^K e^{-\gamma}\beta R^K\tau_{t+1}^K=0$$

**(F19) Investment FOC, log-linear implementation_cross_check**:

$$-\frac{1}{(1+\beta)s e^{2\gamma}}q_t+i_t-\frac{\beta}{1+\beta}i_{t+1}
+\frac{1-\beta\rho_a}{1+\beta}u_t^a-u_t^i=\frac{1}{1+\beta}i_{t-1}$$

**(F20) Wage Phillips curve, log-linear implementation_cross_check, needs_review**:

$$\begin{aligned}
(1+\lambda_w)w_t-\lambda_w\frac{\beta}{1+\beta}w_{t+1}
+\lambda_w\frac{1+\beta\chi_w}{1+\beta}\pi_t
-\lambda_w\frac{\beta}{1+\beta}\pi_{t+1}
-\xi l_t+\lambda_t
+\lambda_w\frac{1+\beta\chi_w-\rho_a\beta}{1+\beta}u_t^a
-\frac{\tau^L}{1-\tau^L}\tau_t^L-\lambda_w u_t^w-u_t^b\\
=\frac{\lambda_w}{1+\beta}w_{t-1}
+\frac{\lambda_w\chi_w}{1+\beta}\pi_{t-1}
+\frac{\lambda_w\chi_w}{1+\beta}u_{t-1}^a .
\end{aligned}$$

**(F21) New Keynesian price Phillips curve, log-linear implementation_cross_check**:

$$\lambda_p\pi_t-\lambda_p\frac{\beta}{1+\beta\chi_p}\pi_{t+1}-mc_t-\lambda_p u_t^p
=\lambda_p\frac{\chi_p}{1+\beta\chi_p}\pi_{t-1}$$

## 4. Market Clearing & Identities

Aggregate consumption:

$$C_t=(1-\mu)C_t^S+\mu C_t^N \tag{(F22)}$$

Goods market clearing:

$$Y_t=C_t+I_t+G_t+\psi(v_t)\bar K_{t-1} \tag{(F23)}$$

Debt-to-output ratio:

$$s_t^b=\frac{P_t^B B_t}{P_tY_t} \tag{(F24)}$$

Long-maturity nominal bond pricing, log-linear implementation_cross_check:

$$R_t-\frac{\rho_B P^B}{1+\rho_B P^B}P^B_{t+1}+P^B_t=0 \tag{(F25)}$$

Government budget constraint, source-level identity:

$$P_t^B B_t+\tau_t^K R_t^K K_t+\tau_t^L W_tL_t+P_t\tau_t^C C_t=(1+\rho P_t^B)B_{t-1}+P_tG_t+P_tZ_t \tag{(F26), needs_review}$$

Primary surplus:

$$S_t=\tau_t^K R_t^kK_t+\tau_t^L W_tL_t+\tau_t^C C_t-G_t-Z_t \tag{(F27)}$$

Tax revenue definitions:

$$T_t^C=\tau_t^C C_t,\qquad T_t^K=\tau_t^K R_t^kK_t,\qquad T_t^L=\tau_t^L W_tL_t \tag{(F28)}$$

Fisher equation:

$$r_t-R_t+\pi_{t+1}=0 \tag{(F29)}$$

## 5. Exogenous Processes

Technology growth:

$$u_t^a=(1-\rho_a)\gamma+\rho_a u_{t-1}^a+\epsilon_t^a,\qquad \epsilon_t^a\sim N(0,\sigma_a^2) \tag{(F30)}$$

Monetary policy:

$$\widehat R_t=\rho_r\widehat R_{t-1}+(1-\rho_r)\left(\phi_\pi\widehat\pi_t+\phi_y\widehat y_t\right)+u_t^m \tag{(F31)}$$

Monetary policy shock:

$$u_t^m=\rho_{em}u_{t-1}^m+\epsilon_t^m,\qquad \epsilon_t^m\sim N(0,\sigma_m^2) \tag{(F32)}$$

Fiscal rules for government consumption and transfers:

$$\widehat g_t=\rho_G\widehat g_{t-1}-(1-\rho_G)\gamma_G\widehat s_{t-1}^b+u_t^G \tag{(F33)}$$

$$\widehat z_t=\rho_Z\widehat z_{t-1}-(1-\rho_Z)\gamma_Z\widehat s_{t-1}^b+u_t^Z \tag{(F34)}$$

Fiscal rules for tax instruments:

$$\widehat\tau_t^J=\rho_J\widehat\tau_{t-1}^J+(1-\rho_J)\gamma_J\widehat s_{t-1}^b,\qquad J\in\{K,L,C\} \tag{(F35)}$$

Fiscal shocks:

$$u_t^s=\rho_{es}u_{t-1}^s+\epsilon_t^s,\qquad s\in\{G,Z\},\qquad \epsilon_t^s\sim N(0,\sigma_s^2) \tag{(F36)}$$

Other implementation_cross_check shocks:

$$u_t^b=\rho_bu_{t-1}^b+\epsilon_t^b,\quad
u_t^i=\rho_iu_{t-1}^i+\epsilon_t^i,\quad
u_t^w=\rho_wu_{t-1}^w+\epsilon_t^w,\quad
u_t^p=\rho_pu_{t-1}^p+\epsilon_t^p \tag{(F37)}$$

## 6. Steady-State Solution

The implementation computes a balanced-growth steady state and then solves a linear model in deviations. Runtime validation was not performed.

1. Set calibrated steady-state targets: \(\beta=0.99\), \(\delta=0.025\), \(\alpha=0.33\), \(\eta_w=\eta_p=0.14\), \(g_c/Y=0.11\), \(b/Y=1.47\), \(\tau^L=0.186\), \(\tau^K=0.218\), \(\tau^C=0.023\), \(\pi=1\), and government bond duration \(AD=20\).
2. Compute growth and interest rates: \(\gamma=gamm100/100\), \(e^\gamma\), \(R=e^\gamma/\beta\), and \(\rho_B=(1-1/AD)/\beta\).
3. Price long debt: \(P^B=1/(R-\rho_B)\).
4. Compute capital rental return and marginal cost: \(R^K=(e^\gamma/\beta-1+\delta)/(1-\tau^K)\), \(mc=1/(1+\eta_p)\).
5. Solve factor prices and ratios: \(w=[mc(1-\alpha)^{1-\alpha}\alpha^\alpha(R^K)^{-\alpha}]^{1/(1-\alpha)}\), \(K/L=(w/R^K)\alpha/(1-\alpha)\), and fixed cost \(\Omega/L=(K/L)^\alpha-R^K(K/L)-w\).
6. Compute output, investment, and consumption per labor unit; then solve transfers and saver/non-saver consumption from fiscal accounting and household budgets.
7. Solve labor from the saver intratemporal condition and scale all aggregate levels by \(l\).
8. In the `US_LTW17rot` `.mod`, \(\mu=0.3\) and the model is `model(linear)`, so the dynamic steady state for log-deviation variables is zero after these level constants are set.

## 7. Timing & Form Conventions

- The implemented MMB file declares `model(linear)`: variables are log or percentage deviations around the computed balanced-growth steady state.
- Physical capital \(\bar K_t\) is an end-of-period stock; production uses effective capital \(K_t=v_t\bar K_{t-1}\).
- Long government debt is a portfolio with geometric maturity decay \(\rho\); bond prices \(P_t^B\) are forward-looking and revaluation enters the government budget.
- The Taylor rule uses the nominal interest rate and current inflation/output deviations.
- Fiscal rules respond to lagged debt-to-output, \(\widehat s_{t-1}^b\).
- The paper estimates a government-spending-in-utility model with \(\mu=0\); `US_LTW17rot` implements the rule-of-thumb version with \(\mu=0.3\). This variant distinction needs_review against MMB catalog metadata.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Main equation(s) |
|---|---|---|---|
| Endogenous | `cs`, \(C_t^S\) | Saver consumption | F9-F12, F15-F16 |
| Endogenous | `cn`, \(C_t^N\) | Non-saver consumption | F14 |
| Endogenous | `c`, \(C_t\) | Aggregate consumption | F22 |
| Endogenous | `cstar`, \(C_t^{\ast}\) | Consumption entering utility | F10 |
| Endogenous | `R` | Nominal interest-rate deviation | F31 |
| Endogenous | `r` | Real interest-rate deviation | F29 |
| Endogenous | `i`, \(I_t\) | Investment | F12, F19, F23 |
| Endogenous | `k`, \(K_t\) | Effective capital | F13 |
| Endogenous | `kbar`, \(\bar K_t\) | Physical capital stock | F12 |
| Endogenous | `v`, \(v_t\) | Capital utilization | F13, F17 |
| Endogenous | `l`, \(L_t\) | Labor | F6-F8, F20 |
| Endogenous | `y`, \(Y_t\) | Output | F1-F3, F23 |
| Endogenous | `gc`, \(G_t\) | Government consumption | F23, F33 |
| Endogenous | `q`, \(q_t\) | Investment-good multiplier/Tobin's q | F18-F19 |
| Endogenous | `rk`, \(R_t^k\) | Real capital return | F4, F18 |
| Endogenous | `w`, \(W_t\) | Real wage | F7-F8, F20 |
| Endogenous | `pi`, \(\pi_t\) | Inflation | F21, F29, F31 |
| Endogenous | `b`, \(B_t\) | Government debt | F24-F26 |
| Endogenous | `sb`, \(s_t^b\) | Debt-to-output ratio | F24 |
| Endogenous | `tauk`, \(\tau_t^K\) | Capital tax rate | F26-F28, F35 |
| Endogenous | `taul`, \(\tau_t^L\) | Labor tax rate | F14, F26-F28, F35 |
| Endogenous | `tauc`, \(\tau_t^C\) | Consumption tax rate | F11, F14, F26-F28, F35 |
| Endogenous | `z`, \(Z_t\) | Transfers | F11, F14, F26-F27, F34 |
| Endogenous | `mc`, \(MC_t\) | Marginal cost | F4, F21 |
| Endogenous | `lambda`, \(\lambda_t\) | Saver marginal utility of wealth | F5, F15-F16 |
| Endogenous | `Pb`, \(P_t^B\) | Long-bond price | F25-F26 |
| Endogenous | `piL`, `rL` | Long-run inflation and real rate | implementation_cross_check |
| Endogenous | `S`, `Tk`, `Tl`, `Tc`, `rb` | Fiscal accounting variables | F27-F28 |
| Exogenous | `eugc`, `euz` | Government consumption and transfer innovations | F33-F36 |
| Exogenous | `eua`, `eub`, `eui` | Technology, preference, investment innovations | F30, F37 |
| Exogenous | `eum`, `euw`, `eup` | Monetary, wage-markup, price-markup innovations | F32, F37 |
| Parameters | `bet`, `delt`, `alph` | Discount factor, depreciation, capital share | F3-F23 |
| Parameters | `etaw`, `etap` | Wage and price markup parameters | F1-F8 |
| Parameters | `xi`, `thet`, `alphag`, `muHH` | Labor elasticity, habit, public/private consumption parameter, non-saver share | F9-F22 |
| Parameters | `omegaw`, `omegap`, `chiw`, `chip` | Calvo and indexation parameters | F5, F8, F20-F21 |
| Parameters | `gpsi`, `s` | Utilization and investment adjustment parameters | F12, F17-F19 |
| Parameters | `phipi`, `phiy`, `rhor` | Monetary rule parameters | F31 |
| Parameters | `gammgc`, `gammtk`, `gammtl`, `gammz` | Fiscal debt responses | F33-F35 |
| Parameters | `rho*`, `sig*` | Persistence and innovation standard deviations | F30-F37 |
