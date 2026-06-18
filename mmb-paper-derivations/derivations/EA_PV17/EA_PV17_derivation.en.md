# EA_PV17 - Derivation Archive Entry

> First-pass status: `needs_review`. Source is the MinerU Markdown appendix for Priftis and Vogel (2017); the raw PDF body was not opened. The implementation `.mod` was used only as `implementation_cross_check` for coverage and naming.

## 1. Model Overview

- **Model ID**: `EA_PV17`
- **Paper**: Romanos Priftis and Lukas Vogel (2017), "The macroeconomic effects of the ECB's evolving QE programme: a model-based analysis", *Open Economies Review*, 28(5), 823-845.
- **DOI**: `10.1007/s11079-017-9460-1`
- **Economy and experiment**: two-region EA and rest-of-world QUEST III DSGE model with ECB purchases of long-term government bonds used to study the January 2015 QE programme and later extensions.
- **Agents and blocks**: monopolistically competitive firms, Ricardian households, liquidity-constrained households, wage-setting unions, fiscal authorities, central banks, short-term and long-term bond markets, trade/current-account block, and symmetric RoW block.
- **Model form**: nonlinear level model with adjustment costs, habit persistence, nominal and real rigidities, and optionally dynamic difference variables in the Rep-MMB implementation. Runtime validation was not performed.
- **Key QE mechanism**: long-term bonds are imperfect substitutes for short-term domestic bonds and foreign long-term bonds. Central-bank purchases reduce privately held long-term bonds, alter term premia, asset prices, exchange rates, and saving/investment decisions.

## 2. Optimization Problems

### Firms

Firms choose goods prices, labour, capital services, and capacity utilisation to maximize real profits subject to a Cobb-Douglas production technology and convex adjustment costs:

$$
\max_{\{P_t,N_t,K_t,ucap_t\}} Pr_t
= p_tY_t-w_tN_t-i_t^k p_t^I K_t
-\left(adj^P(P_t)+adj^N(N_t)+adj^{ucap}(ucap_t)\right).
$$

$$
Y_t=(ucap_tK_t)^{1-\alpha}(N_t-LO_t)^\alpha KG_t^{\alpha_g}.
$$

The adjustment-cost functions are:

$$
adj^N(N_t)=\frac{\gamma_N}{2}w_t(\Delta N_t)^2,\quad
adj^P(P_t)=\frac{\gamma_P}{2}\left(\frac{P_t-P_{t-1}}{P_{t-1}}\right)^2Y_t,
$$

$$
adj^{ucap}(ucap_t)=p_t^IK_t\left[\gamma_{ucap,1}(ucap_t-1)+\frac{\gamma_{ucap,2}}{2}(ucap_t-1)^2\right].
$$

### Ricardian households

Ricardian households maximize expected discounted utility over consumption and leisure with habit persistence:

$$
\max L^r=E_0\sum_{t=0}^{\infty}\beta^t U(C_t^r,N_t^r),
\qquad
U(C_t^h,N_t^h)=\log(C_t^h-hC_{t-1})+\omega(1-N_t^h)^{1-\kappa}.
$$

The budget constraint includes consumption taxes, investment in physical capital, short-term bonds, domestic long-term bonds, foreign short-term bonds, foreign long-term bonds, portfolio adjustment costs, transfers, coupons, depreciating long-bond values, labour income, capital income net of risk premia, taxes, and dividends. The Markdown OCR of the multi-line Lagrangian is usable but needs source-level checking; the budget block is therefore `needs_review`.

Physical investment is subject to adjustment costs:

$$
I_t=J_t\left(1+\frac{\gamma_KJ_t}{2K_t}\right)+\frac{\gamma_I}{2}(\Delta J_t)^2.
$$

### Liquidity-constrained households and unions

Liquidity-constrained households do not optimize intertemporally; they consume current disposable income. Unions set wages by equating a weighted average of marginal utilities of leisure to the weighted marginal utility of consumption times the after-tax real consumption wage and a wage markup.

### Policy authorities

Fiscal policy follows a debt-stabilizing labour-tax rule. Monetary policy follows a Taylor rule in normal times. In QE simulations, central-bank holdings of long-term bonds follow an exogenous purchase path rather than an endogenous feedback rule.

## 3. First-Order Conditions

**(F1) Firm production technology**

$$
Y_t=(ucap_tK_t)^{1-\alpha}(N_t-LO_t)^\alpha KG_t^{\alpha_g}.
$$

**(F2) Labour CES aggregator**

$$
N_t=\left(\int_0^1 (N_t^h)^{\frac{\theta-1}{\theta}}dh\right)^{\frac{\theta}{\theta-1}}.
$$

**(F3) Firm labour demand with employment adjustment costs**

$$
\frac{\partial Y_t}{\partial N_t}\eta_t-\gamma_Nw_t\Delta N_t
+\gamma_NE_t\!\left(\beta\lambda_{t,t+1}^rw_{t+1}\Delta N_{t+1}\right)=w_t.
$$

**(F4) Firm capital rental condition**

$$
\frac{\partial Y_t}{\partial K_t}\eta_t=i_t^k p_t^I.
$$

**(F5) Capacity-utilisation condition**

$$
\frac{\partial Y_t}{\partial ucap_t}\eta_t
=p_t^IK_t\left[\gamma_{ucap,1}+\gamma_{ucap,2}(ucap_t-1)\right].
$$

**(F6) Price-markup condition with partial backward indexation**

$$
\eta_t=1-\frac{1}{\sigma}
-\gamma_pE_t\!\left(\beta\lambda_{t,t+1}^r\left(sfp\,\pi_{t+1}+(1-sfp)\pi_{t-1}\right)-\pi_t\right).
$$

**(F7) Short-term domestic bond Euler condition**

$$
\beta E_t\left(\frac{\lambda_{t+1}}{\lambda_t}\right)
=E_t\left(\frac{P_{t+1}}{P_t}\right)
\left[\frac{1}{1+i_t}+\gamma_b\kappa P_t^N\left(\kappa\frac{B_t^S}{B_t^{L,H}}-1\right)\right].
$$

**(F8) Domestic long-term bond Euler condition (`needs_review`: OCR tag and superscripts malformed in source)**

$$
\beta E_t\left(\frac{\lambda_{t+1}P_t}{\lambda_tP_{t+1}}\right)
=E_t\left(\frac{P_t^N}{\delta_bP_{t+1}^N+c}\right)
\left[
1+\frac{\gamma_b}{2}\left(\kappa\frac{B_t^S}{B_t^{L,H}}-1\right)^2
-\gamma_b\kappa\left(\kappa\frac{B_t^S}{B_t^{L,H}}-1\right)\frac{B_t^S}{B_t^{L,H}}
+\gamma_b^{\ast}\kappa^{\ast}\left(\kappa^{\ast}\frac{B_t^{L,H}}{B_t^{L,H\ast}}-1\right)\frac{e_tP_t^{N\ast}}{P_t^N}
\right].
$$

**(F9) Foreign long-term bond Euler condition (`needs_review`)**

$$
\beta E_t\left(\frac{\lambda_{t+1}P_te_{t+1}}{\lambda_tP_{t+1}e_t}\right)
=E_t\left(\frac{P_t^{N\ast}}{\delta_b^{\ast}P_{t+1}^{N\ast}+c^{\ast}}\right)
\left[
1+\frac{\gamma_b^{\ast}}{2}\left(\kappa^{\ast}\frac{B_t^{L,H}}{B_t^{L,H\ast}}-1\right)^2
-\gamma_b^{\ast}\kappa^{\ast}\left(\kappa^{\ast}\frac{B_t^{L,H}}{B_t^{L,H\ast}}-1\right)\frac{B_t^{L,H}}{B_t^{L,H\ast}}
\right].
$$

**(F10) Foreign short-term bond/UIP condition**

$$
\beta E_t\left(\frac{\lambda_{t+1}}{\lambda_t}\right)
=E_t\left(\frac{e_tP_{t+1}}{e_{t+1}P_t}\right)
\left[\frac{1}{1+i_t^{\ast}}+\gamma_f\frac{e_t(B_t^{\ast}-\bar{B}^{\ast})}{P_t}\right].
$$

**(F11) Capital Euler condition**

$$
\beta E_t\left(\frac{\lambda_{t+1}}{\lambda_t}\right)
=E_t\left(\frac{P_{t+1}}{P_t}\frac{P_t^C}{P_{t+1}^C}\right)
\frac{1}{(1+i_t^k-\varphi_t-\delta_k)-t_t^k(i_t^k-\delta_k)}.
$$

**(F12) Consumption marginal utility condition**

$$
U_t^C=\frac{(1+t_t^c)P_t^C}{P_t}\lambda_t.
$$

**(F13) Labour supply condition**

$$
U_t^N=\frac{(1-t_t^w)W_t}{P_t}\lambda_t.
$$

**(F14) Investment arbitrage rule**

$$
\left(\gamma_K\frac{J_t^K}{K_{t-1}}+\gamma_I\Delta J_t^K\right)
-E_t\left(\frac{1}{1+r_t+\pi_{t+1}^{GDP}-\pi_{t+1}^I}\Delta J_{t+1}^K\right)
=\frac{\xi_t}{p_t^I}-1.
$$

**(F15) Shadow value of capital (`needs_review`: source equation ends with an ambiguous `=0`)**

$$
\frac{\xi_t}{p_t^I}
=E_t\left(\frac{1}{1+r_t+\pi_{t+1}^{GDP}-\pi_{t+1}^I}\frac{\xi_{t+1}}{p_{t+1}^I}(1-\delta_k)\right)
+(1-t_t^k)i_t^k+t_t^k\delta_k.
$$

**(F16) Liquidity-constrained consumption**

$$
(1+t_t^c)P_t^C C_t^l=(1-t_t^w)W_tN_t^l+TR_t^l-T_t^{LS,l}.
$$

**(F17) Wage-setting condition**

$$
\frac{(1-s^l)U_{1-N,t}^r+s^lU_{1-N,t}^l}
{(1-s^l)U_{c,t}^r+s^lU_{c,t}^l}
=\frac{1-t_t^w}{1+t_t^c}\frac{W_t}{P_t^C}\eta_t^W.
$$

**(F18) Wage-markup dynamics**

$$
\eta_t^W=1-\frac{1}{\theta}
-\frac{\gamma_W}{\theta}E_t\left(\beta\lambda_{t,t+1}^r(\pi_{t+1}^W-(1-sfw)\pi_t)-(\pi_t^W-(1-sfw)\pi_{t-1})\right).
$$

## 4. Market Clearing & Identities

**(F19) Aggregate consumption**

$$
C_t=(1-s^l)C_t^r+s^lC_t^l.
$$

**(F20) Aggregate employment**

$$
N_t=(1-s^l)N_t^r+s^lN_t^l,\qquad N_t^r=N_t^l.
$$

**(F21) Long-term bond pricing: new issue**

$$
P_t^N=\sum_{n=0}^{T}\frac{\delta_b^n}{(1+i)^{1+n}}c.
$$

**(F22) Long-term bond pricing: outstanding bond**

$$
P_t^O=\sum_{n=0}^{T-1}\frac{\delta_b^{1+n}}{(1+i)^{1+n}}c.
$$

**(F23) Approximate depreciation of outstanding long-term bond value**

$$
P_t^O=\delta_bP_t^N.
$$

**(F24) Government debt composition with cross-border and central-bank holdings**

$$
B_t=B_t^{L,H}+B_t^{L,F}+B_t^{L,CB}+B_t^S.
$$

**(F25) Public capital accumulation**

$$
KG_t=IG_t+(1-\delta^g)KG_{t-1}.
$$

**(F26) Transfers**

$$
TR_t=try\,P_t^C.
$$

**(F27) Government budget constraint**

$$
\begin{aligned}
\frac{B_t^S}{1+i_t}+P_t^NB_t^L
&=B_{t-1}^S+(\delta_bP_t^N+c)B_{t-1}^L+P_t^C(G_t+IG_t)+TR_t\\
&\quad-t_t^cP_t^cC_t-t_t^wW_tN_t-t_t^k(P_tY_t-W_tN_t-\delta_kP_t^IK_{t-1})-T_t^{LS}.
\end{aligned}
$$

**(F28) Fiscal closure rule**

$$
\Delta t_t^w=\tau^B\left(\frac{B_{t-1}}{P_{t-1}Y_{t-1}}-b^{tar}\right)
+\tau^{DEF}\Delta\left(\frac{B_t}{Y_tP_t}\right).
$$

**(F29) CPI aggregator**

$$
P_t^C=\left((1-s_m)P_t^{1-\sigma_m}+s_m(e_tP_t^F)^{1-\sigma_m}\right)^{\frac{1}{1-\sigma_m}}.
$$

**(F30) Imports**

$$
M_t=s_m\left(\frac{e_tP_t^{\ast}}{P_t^C}\right)^{-\sigma_m}Z_t.
$$

**(F31) Exports**

$$
X_t=s_m^{\ast}\left(\frac{P_t}{e_tP_t^{C\ast}}\right)^{-\sigma_x}Z_t^{\ast}.
$$

**(F32) Trade balance**

$$
TB_t=P_tX_t-e_tP_t^{\ast}M_t.
$$

## 5. Exogenous Processes

**(F33) Central-bank operating profit**

$$
PR_t^{CB}=\Delta M_t+cB_{t-1}^{L,CB}-\left(P_t^NB_t^{L,CB}-\delta_bP_t^NB_{t-1}^{L,CB}\right).
$$

**(F34) Exogenous QE purchase path**

$$
B_t^{L,CB}=\rho_LB_{t-1}^{L,CB}+F(\cdot)+\varepsilon_t^{CB},\qquad F(\cdot)=0\ \text{in the paper simulations}.
$$

**(F35) Taylor rule**

$$
i_t=\rho_i i_{t-1}+(1-\rho_i)\left(\bar{r}+\pi^{tar}+\tau_\pi(\pi_t^C-\pi^{tar})+\tau_y\,ygap_t\right).
$$

**(F36) Output gap**

$$
ygap_t=\alpha\ln(N_t/N_t^{ss})+(1-\alpha)\ln(ucap_t/ucap_t^{ss}).
$$

**(F37) Employment trend**

$$
N_t^{ss}=\rho^NN_{t-1}^{ss}+(1-\rho^N)N_t.
$$

**(F38) Capacity-utilisation trend**

$$
ucap_t^{ss}=\rho^{ucap}ucap_{t-1}^{ss}+(1-\rho^{ucap})ucap_t.
$$

The implementation cross-check also includes shocks to government spending, public investment, consumption, markup, labour supply, TFP, monetary policy, QE, bond risk premia, currency risk premia, investment risk premia, labour-tax closure, transfers, utilisation, firm value, wages, and import demand. Many are implementation-level disturbance processes not fully derived in the paper appendix and remain `needs_review` as source-backed equations.

## 6. Steady-State Solution

The paper appendix gives a calibration table rather than a full analytic steady-state derivation. First-pass steady-state reconstruction is therefore `needs_review`.

1. Set trend inflation, population growth, TFP growth, target public-debt ratios, steady tax rates, import shares, and preference/friction parameters from the calibration table.
2. Normalize prices and long-term bond prices in the implementation steady state: `ea_py=ea_pc=EA_pbl=1` and symmetric RoW counterparts.
3. Set long-bond maturity parameter $\delta_b=0.975$, long-bond share in total debt $s_{bl}=0.5$, and portfolio adjustment cost $\gamma_b=0.00015$ from the paper calibration.
4. Choose steady output shares for EA: private consumption 0.58, investment 0.20, government purchases 0.18, government investment 0.04, exports 0.23, imports 0.23.
5. Solve production and factor blocks jointly using (F1), (F3)-(F5), public capital accumulation, capacity utilisation at trend, and calibrated tax/risk-premium wedges.
6. Solve Ricardian and liquidity-constrained consumption from (F12), (F16), and (F19), with the LC household share calibrated at 0.40.
7. Solve bond stocks and government debt from (F24), (F27), (F28), and calibrated debt target.
8. Set the QE shock path to zero in baseline steady state: $\varepsilon_t^{CB}=0$, with central-bank long-bond holdings at their baseline stock before policy simulations.

No Dynare `steady` or `check` run was executed for this archive entry.

## 7. Timing & Form Conventions

- The model is nonlinear and solved/simulated as a dynamic DSGE model; the Rep-MMB file contains level variables plus first-difference helper variables controlled by a `dyn` switch.
- Capital in the implementation is effectively predetermined through equations using `ea_k-ea_dk` and lagged capital differences; the paper states $K_t=I_t+(1-\delta_k)K_{t-1}$.
- Long-term bonds are declining-coupon assets. Outstanding values depreciate at $\delta_b$, and the price of old bonds is approximately $\delta_bP_t^N$.
- QE is represented by the central bank's stock of long-term bonds, not by a short-rate rule innovation. In the paper simulations the purchase path is exogenous and calibrated to ECB announcements.
- The two-region model is symmetric in structure for EA and RoW, with EA/RoW prefixes in the implementation (`ea_`, `r_`, `EA_`, `R_`).
- Formula quality: the appendix OCR is mostly usable for displayed equations, but F8, F9, F15, and the full household Lagrangian require source-level review against the PDF or original paper.

## 8. Variable & Parameter Reference Table

### Core endogenous variables

| Category | Symbol / implementation hint | Meaning | Main equations |
|---|---|---|---|
| Endogenous | $Y_t$ / `ea_y` | Output | (F1), (F27), (F30)-(F32) |
| Endogenous | $N_t$ / `ea_l` | Employment | (F2), (F3), (F20), (F36)-(F37) |
| Endogenous | $K_t$ / `ea_k` | Private capital | (F4), (F11), (F14)-(F15) |
| Endogenous | $ucap_t$ / `ea_ucap` | Capacity utilisation | (F5), (F36), (F38) |
| Endogenous | $\eta_t$ / `ea_eta` | Goods markup or marginal-cost wedge | (F3)-(F6) |
| Endogenous | $C_t,C_t^r,C_t^l$ / `ea_c`, `ea_cnlc`, `ea_clc` | Aggregate, Ricardian, and LC consumption | (F12), (F16), (F19) |
| Endogenous | $W_t$ / `ea_wr` | Real wage | (F13), (F17)-(F18) |
| Endogenous | $B_t^S,B_t^L,B_t^{L,CB}$ / `EA_bs`, `EA_bl`, `EA_blcb` | Short bonds, long bonds, central-bank long-bond holdings | (F7)-(F10), (F24), (F27), (F33)-(F34) |
| Endogenous | $P_t^N$ / `EA_pbl` | Long-term bond price | (F21)-(F23) |
| Endogenous | $i_t$ / `ea_inom` | Short nominal policy rate | (F7), (F35) |
| Endogenous | $e_t$ / `ea_e` | Exchange rate | (F9), (F10), (F29)-(F32) |
| Endogenous | $M_t,X_t,TB_t$ / `ea_im`, `ea_ex`, `ea_tby` | Imports, exports, trade balance | (F29)-(F32) |

### Exogenous shocks and paths

| Category | Implementation hint | Meaning | Source status |
|---|---|---|---|
| Exogenous | `EA_eps_qe` | ECB long-bond purchase path | Source stated in QE block |
| Exogenous | `ea_eps_m` | Monetary policy shock | Implementation cross-check |
| Exogenous | `ea_eps_ltfp` | TFP shock | Implementation cross-check |
| Exogenous | `ea_eps_g`, `ea_eps_ig` | Government purchases and investment shocks | Implementation cross-check |
| Exogenous | `ea_eps_rpremb`, `ea_eps_rpreme`, `ea_eps_rpremk` | Government bond, currency, and capital-risk premia shocks | Implementation cross-check |
| Exogenous | many `ea_ex_*` variables | Steady-state or target values | Implementation cross-check |

### Parameters

| Category | Symbol / implementation hint | Meaning | Calibration cue |
|---|---|---|---|
| Parameter | $\beta$ / `ea_theta` in implementation discounting expression | Time discounting | Model equations |
| Parameter | $\alpha$ / `ea_alpha` | Labour share in production | 0.65 |
| Parameter | $\alpha_g$ / `ea_alphag` | Public capital production parameter | Calibration table |
| Parameter | $\delta_k$ / `ea_delta` | Private capital depreciation | 0.015 |
| Parameter | $\delta_b$ / `EA_deltabl` | Long-bond coupon depreciation | 0.975 |
| Parameter | $\gamma_b$ / `EA_gamb` | Short-vs-long bond portfolio adjustment cost | 0.00015 approximately |
| Parameter | $\gamma_b^{\ast}$ / `EA_gambd` | Domestic-vs-foreign long-bond adjustment cost | 0.0013 in table |
| Parameter | $\gamma_K,\gamma_I$ / `ea_gami`, `ea_gami2` | Capital and investment adjustment costs | 20.0 and 75.0 |
| Parameter | $\gamma_N,\gamma_P,\gamma_W$ / `ea_gaml`, `ea_gamp`, `ea_gamw` | Labour, price, and wage adjustment costs | Calibration table |
| Parameter | $s^l$ / `ea_slc` | Liquidity-constrained household share | 0.40 |
| Parameter | $\rho_i,\tau_\pi,\tau_y$ / `ea_ilag`, `ea_tinf`, `ea_ty` | Taylor-rule smoothing, inflation response, output-gap response | 0.82, 1.50, 0.05 |
| Parameter | $\rho^N,\rho^{ucap}$ / `ea_llag`, `ea_ucaplag` | Employment and utilisation trend smoothness | 0.95, 0.99 |
