# EA_QUEST3 -- QUEST III Derivation

> First-pass private model-archive derivation for `EA_QUEST3`. Status: `needs_review`.
> Runtime validation was not performed.

Source: Ratto, Marco; Roeger, Werner; Veld, Jan (2009), "QUEST III: An estimated open-economy DSGE model of the euro area with fiscal and monetary policy", *Economic Modelling* 26(1), 222-233, DOI `10.1016/j.econmod.2008.06.014`.

## 1. Model Overview

- **Model**: QUEST III estimated open-economy DSGE model of the euro area.
- **Purpose**: Bayesian estimation and impulse-response analysis for euro-area monetary and fiscal stabilization policy.
- **Economy**: small open economy facing exogenous world interest rates, world inflation, world demand, and foreign prices.
- **Agents and institutions**: monopolistically competitive domestic firms, investment-goods producers, Ricardian households, liquidity-constrained households, wage-setting unions, import/export price setters, fiscal authority, and monetary authority.
- **Frictions**: price adjustment costs with indexation, wage adjustment costs with indexation, labor adjustment costs, variable capacity utilization, investment adjustment costs, foreign-bond risk premium, equity premium on capital, liquidity-constrained households, and fiscal policy rules.
- **Form**: source paper is nonlinear in levels/growth rates and then estimated in stationary growth rates and nominal ratios. The MMB implementation cross-check is a linearized/log-growth Dynare implementation using variables such as `E_GY`, `E_LCSN`, `E_INOM`, and `E_LYGAP`. This archive entry records the paper-side equations and flags OCR-sensitive formulas as `needs_review`.

## 2. Optimization Problems

### Domestic Final-Goods Firms

Firm \(j\) faces demand for its differentiated domestic variety:

**(F1) Domestic-variety demand**:

\[
Y_t^j =
\frac{1-s^M-u_t^M}{n}
\left(\frac{P_t}{P_t^j}\right)^{\sigma^d}
\left(\frac{P_t^C}{P_t}\right)^{\sigma^M}
\left(C_t+C_t^G+I_t^G+I_t^{inp}+X_t\right).
\]

Production uses utilized private capital, labor net of overhead labor, technology, and public capital:

**(F2) Production function**:

\[
Y_t^j =
\left(ucap_t^j K_t^j\right)^{1-\alpha}
\left(L_t^j-LO_t^j\right)^\alpha
\left(U_t^Y\right)^\alpha
\left(K_t^G\right)^{1-\alpha_G}.
\]

Total firm labor is a CES aggregate of household labor types:

**(F3) Labor aggregation**:

\[
L_t^j =
\left[\int_0^1 \left(L_t^{i,j}\right)^{(\theta-1)/\theta}\,di\right]^{\theta/(\theta-1)}.
\]

The representative firm chooses labor, capital services, utilization, and price to maximize period real profit:

**(F4) Firm profit objective**:

\[
Pr_t^j =
\frac{P_t^j}{P_t}Y_t^j
-\frac{W_t}{P_t}L_t^j
-i_t^K\frac{P_t^I}{P_t}K_t^j
-\frac{adj^P(P_t^j)+adj^L(L_t^j)+adj^{UCAP}(ucap_t^j)}{P_t}.
\]

Adjustment costs are:

**(F5) Labor adjustment cost**:

\[
adj^L(L_t^j)=W_t\left(L_t^j u_t^L+\frac{\gamma_L}{2}(\Delta L_t^j)^2\right).
\]

**(F6) Price adjustment cost**:

\[
adj^P(P_t^j)=\frac{\gamma_P}{2}\frac{(\Delta P_t^j)^2}{P_{t-1}^j}.
\]

**(F7) Capacity-utilization adjustment cost**:

\[
adj^{UCAP}(ucap_t^j)=P_t^I K_t\left[\gamma_{ucap,1}(ucap_t^j-1)+\frac{\gamma_{ucap,2}}{2}(ucap_t^j-1)^2\right].
\]

### Investment-Goods Producers

The investment-goods sector combines domestic and foreign final goods into an investment input and transforms it linearly:

**(F8) Investment-goods technology**:

\[
I_t=I_t^{inp}U_t^I.
\]

**(F9) Investment-goods price**:

\[
P_t^I=\frac{P_t^C}{U_t^I}.
\]

### Ricardian Households

Non-liquidity-constrained households choose consumption, domestic and foreign bonds, physical capital, cash balances, and investment. The paper writes their problem as:

**(F10) Ricardian household objective**:

\[
\max E_0\sum_{t=0}^{\infty}\beta^t U(C_t^i,1-L_t^i).
\]

The period utility is:

**(F11) Habit utility**:

\[
U(C_t^i,1-L_t^i)=
\frac{
\exp(\varepsilon_t^C)
\left[
\left(C_t^i-h^C C_{t-1}\right)
\left(1-\exp(\varepsilon_t^L)\omega(L_t^i-h^L L_{t-1})^\kappa\right)
\right]^{1-\rho}-1
}{1-\rho}.
\]

Physical investment expenditure with adjustment costs is:

**(F12) Investment adjustment cost for household capital**:

\[
I_t^i=
J_t^i\left(1+\frac{\gamma_K}{2}\frac{J_t^i}{K_{t-1}^i}\right)
+\frac{\gamma_I}{2}(\Delta J_t^i)^2.
\]

### Liquidity-Constrained Households

Liquidity-constrained households do not optimize over assets; they consume current disposable income:

**(F13) Liquidity-constrained consumption**:

\[
(1+t_t^c)P_t^C C_t^k=(1-t_t^w)W_t L_t+\mathrm{TR}_t^k-T_t^{LS,k}.
\]

### Trade Aggregators

Private consumption, investment, government consumption, and government investment use the same domestic/foreign CES aggregator:

**(F14) Domestic/foreign absorption aggregator**:

\[
Z^i=
\left[
(1-s^M-u_t^M)^{1/\sigma^M}(Z^{d,i})^{(\sigma^M-1)/\sigma^M}
+(s^M+u_t^M)^{1/\sigma^M}(Z^{f,i})^{(\sigma^M-1)/\sigma^M}
\right]^{\sigma^M/(\sigma^M-1)}.
\]

## 3. First-Order Conditions

### Firms

**(F15) Labor demand condition** (`needs_review`: OCR parentheses around the forward labor-adjustment term are damaged):

\[
\alpha\frac{Y_t^j}{L_t^j-LO_t^j}\eta_t^j
-\frac{W_t}{P_t^j}u_t^L
-\frac{W_t}{P_t^j}\gamma_L\Delta L_t^j
+E_t\left[\frac{W_{t+1}}{P_{t+1}^j}\frac{\gamma_L}{1+r_t}\Delta L_{t+1}^j\right]
=\frac{W_t}{P_t^j}.
\]

**(F16) Capital-services demand**:

\[
(1-\alpha)\frac{Y_t^j}{K_t^j}\eta_t^j
=i_t^K\frac{P_t^{I,j}}{P_t^j}.
\]

**(F17) Capacity-utilization condition**:

\[
(1-\alpha)\frac{Y_t^j}{K_t^j ucap_t^j}\eta_t^j
=
\frac{P_t^{I,j}}{P_t^j}
\left(\gamma_{ucap,1}+\gamma_{ucap,2}(ucap_t^j-1)\right).
\]

**(F18) Firm markup condition** (`needs_review`: source OCR mangles the prime on Eq. 7d):

\[
\eta_t =
1-\frac{1}{\sigma^d}
-\gamma_P\left[
\beta\left(sfp\,E_t\pi_{t+1}+(1-sfp)\pi_{t-1}\right)-\pi_t
\right]
-u_t^p.
\]

### Ricardian Households

**(F19) Consumption marginal utility condition**:

\[
U_{C,t}^i-\lambda_t\frac{(1+t_t^c)P_t^C}{P_t}=0.
\]

**(F20) Domestic bond Euler equation**:

\[
-\lambda_t+
E_t\left[
\lambda_{t+1}\beta
\left(1+(1-t_t^i)i_t\right)
\frac{P_t}{P_{t+1}}
\right]=0.
\]

**(F21) Foreign bond Euler equation with risk premium**:

\[
-\lambda_t+
E_t\left[
\lambda_{t+1}\beta
\left(1+(1-t_t^i)i_t^F\right)
\left(1-risk\!\left(\frac{E_tB_t^F}{P_tY_t}\right)-u_t^{B^F}\right)
\frac{P_t}{P_{t+1}}\frac{E_{t+1}}{E_t}
\right]=0.
\]

**(F22) Capital Euler equation**:

\[
-\xi_t+
E_t\left[
\xi_{t+1}\beta(1-\delta)
+\lambda_{t+1}\beta
\left((1-t_t^K)(i_t^K-rp_t^K)+t_t^K\delta\right)
\frac{P_t^I}{P_{t+1}}
\right]=0.
\]

**(F23) Physical-investment FOC** (`needs_review`: source OCR uses inconsistent capital timing in Eq. 13 vs Eq. 15a):

\[
\gamma_K\frac{J_t^i}{K_{t-1}^i}
+\gamma_I\Delta J_t^i
-\frac{\gamma_I}{1+r_t}E_t(\Delta J_{t+1}^i)
=Q_t-1,
\qquad
Q_t=\frac{\xi_t}{\lambda_t}\frac{P_t}{P_t^I}.
\]

**(F24) Tobin-Q asset value equation**:

\[
Q_t=
E_t\left[
\frac{1-\delta}{(1-t_t^i)(1+i_t)/(1+{}_{t}\pi_{t+1}^I)}
Q_{t+1}
\right]
+(1-t_t^K)(i_t^K-rp_t^K)+t_t^K\delta.
\]

### Wage Setting

**(F25) Wage rule**:

\[
\frac{W_t}{P_t^C}
=
\gamma_{WR}\frac{W_{t-1}}{P_{t-1}^C}
+(1-\gamma_{WR})
\frac{1}{\eta_t^W}
\frac{1+t_t^C}{1-t_t^W}
\frac{(1-slc)U_{1-L,t}^i+slc\,U_{1-L,t}^k}
{(1-slc)U_{c,t}^i+slc\,U_{c,t}^k}.
\]

**(F26) Wage markup with indexation** (`needs_review`: OCR bracket is damaged):

\[
\eta_t^W=
1-\frac{1}{\theta}
-\frac{\gamma_W}{\theta}
\left[
\beta\left(\pi_{t+1}^W-(1-sfw)\pi_t\right)
-\left(\pi_t^W-(1-sfw)\pi_{t-1}\right)
\right]
+u_t^W.
\]

## 4. Market Clearing & Identities

**(F27) Aggregate consumption**:

\[
C_t=(1-slc)C_t^i+slc\,C_t^k.
\]

**(F28) Aggregate employment**:

\[
L_t=(1-slc)L_t^i+slc\,L_t^k,
\qquad L_t^i=L_t^k=L_t.
\]

**(F29) Import demand**:

\[
M_t=(s^M+u_t^M)
\left[
\rho^{PCPM}\frac{P_{t-1}^C}{P_{t-1}^M}
+(1-\rho^{PCPM})\frac{P_t^C}{P_t^M}
\right]^{\sigma^M}
\left(C_t+I_t^{inp}+C_t^G+I_t^G\right).
\]

**(F30) Export demand**:

\[
X_t=(s^{M,W}+u_t^X)
\left[
\rho^{PWPX}\frac{P_{t-1}^{C,F}E_{t-1}}{P_{t-1}^X}
+(1-\rho^{PWPX})\frac{P_t^{C,F}E_t}{P_t^X}
\right]^{\sigma^X}
Y_t^F.
\]

**(F31) Export-price markup**:

\[
\eta_t^X P_t^X=P_t.
\]

**(F32) Import-price markup**:

\[
\eta_t^M P_t^M=E_tP_t^F.
\]

**(F33) Import/export markup dynamics**:

\[
\eta_t^k=
1-\frac{1}{\sigma^{v,k}}
-\gamma_{Pk}
\left[
\beta\left(sfp^k E_t\pi_{t+1}^k+(1-sfp^k)\pi_{t-1}^k\right)-\pi_t^k
\right]
+u_t^{P,k},
\qquad k\in\{X,M\}.
\]

**(F34) Net foreign assets**:

\[
E_tB_t^F=(1+i_t^F)E_tB_{t-1}^F+P_t^X X_t-P_t^M M_t.
\]

**(F35) Output gap indicator**:

\[
YGAP_t=
\left(\frac{ucap_t}{ucap_t^{ss}}\right)^{1-\alpha}
\left(\frac{L_t}{L_t^{ss}}\right)^\alpha.
\]

**(F36) Smoothed capacity-utilization reference**:

\[
ucap_t^{ss}=(1-\rho^{ucap})ucap_{t-1}^{ss}+\rho^{ucap}ucap_t.
\]

**(F37) Smoothed employment reference**:

\[
L_t^{ss}=(1-\rho^{Lss})L_{t-1}^{ss}+\rho^{Lss}L_t.
\]

**(F38) Government revenues**:

\[
R_t^G=t_t^w W_tL_t+t_t^cP_t^C C_t+t_t^K i_t^K P_t^I K_{t-1}.
\]

**(F39) Labor-income tax schedule**:

\[
t_t^w=\tau_0^w Y_t^{\tau_1^w}U_t^{TW}.
\]

**(F40) Linearized labor-income tax response**:

\[
t_t^w=\tau_0^w+\tau_0^w\tau_1^w ygap_t.
\]

**(F41) Government debt law of motion**:

\[
B_t=(1+i_t)B_{t-1}+P_t^C C_t^G+P_t^C I_t^G+\mathrm{TR}_t-R_t^G-T_t^{LS}.
\]

**(F42) Lump-sum tax/debt feedback**:

\[
\Delta T_t^{LS}
=\tau^B\left(\frac{B_{t-1}}{Y_{t-1}P_{t-1}}-b^T\right)
+\tau^{DEF}\Delta\left(\frac{B_t}{Y_tP_t}\right).
\]

## 5. Exogenous Processes

**(F43) TFP stochastic trend**:

\[
u_t^Y=g_t^U+u_{t-1}^Y+\varepsilon_t^Y.
\]

**(F44) Overhead-labor share**:

\[
lol_t^j=(1-\rho^{LOL})lol+\rho^{LOL}lol_{t-1}^j+\varepsilon_t^{LOL}.
\]

**(F45) Investment-technology stochastic trend**:

\[
u_t^I=g^{UI}+u_{t-1}^I+\varepsilon_t^{UI}.
\]

**(F46) Fiscal rule for government consumption**:

\[
\Delta c_t^G=
(1-\tau_{Lag}^{CG})\overline{\Delta c^G}
+\tau_{Lag}^{CG}\Delta c_{t-1}^G
+\tau_{Adj}^{CG}(cgy_{t-1}-\overline{cgy})
+\sum_i\tau_i^{CG}ygap_{t-i}
+u_t^{CG}.
\]

**(F47) Fiscal rule for government investment**:

\[
\Delta i_t^G=
(1-\tau_{Lag}^{IG})\overline{\Delta i^G}
+\tau_{Lag}^{IG}\Delta i_{t-1}^G
+\tau_{Adj}^{IG}(igy_{t-1}-\overline{igy})
+\sum_i\tau_i^{IG}ygap_{t-i}
+u_t^{IG}.
\]

**(F48) Transfer rule**:

\[
\mathrm{TR}_t=
b^U W_t(POP_t^W-POP_t^{NPART}-L_t)
+b^R W_tPOP_t^P
+u_t^{TR}.
\]

**(F49) Monetary policy rule**:

\[
i_t=
\tau_{lag}^{INOM}i_{t-1}
+(1-\tau_{lag}^{INOM})
\left[
r^{EQ}+\pi^T+\tau_\pi^{INOM}(\pi_t^C-\pi^T)
+\tau_{y,1}^{INOM}ygap_{t-1}
\right]
+\tau_{y,2}^{INOM}(ygap_t-ygap_{t-1})
+u_t^{INOM}.
\]

**(F50) Generic autocorrelated structural shock**:

\[
\log U_t^k=\rho^k\log U_{t-1}^k+\varepsilon_t^k.
\]

## 6. Steady-State Solution

QUEST III is estimated in growth rates and stationary nominal ratios. The paper states that domestic and foreign GDP components are stationary in growth rates, while nominal ratios such as consumption-to-GDP, investment-to-GDP, government-spending-to-GDP, transfers-to-wages, trade-balance-to-GDP, wage share, employment, and real exchange rate are stationary.

For this first-pass archive entry:

- Steady state is a balanced-growth/stationary-ratio system, not a single level steady state for all real quantities.
- Trend technology processes (F43) and (F45) imply permanent components in productivity and investment-specific technology.
- Stationary nominal ratios and growth rates are pinned down by the estimated/calibrated parameter block and steady-state shares reported in the paper appendix and the MMB implementation.
- Implementation cross-check values include `BETAE = 0.996`, `DELTAE = 0.025`, `GSN = 0.203`, `IGSN = 0.025`, `BGTAR = 2.4`, `SLC = 0.3507`, `L0 = 0.65`, `UCAP0 = 1`, `E_Q = 1`, `E_LYGAP = 0`, `E_BWRY = 0`, and quarterly inflation/growth baselines such as `GP0 = 0.005` and `GY0 = 0.003`.
- `needs_review`: the paper references complete steady-state relationships in Appendix 1, but the MinerU Markdown did not expose an appendix table with enough formula detail to source-check a full recursive steady-state block without targeted PDF inspection.

## 7. Timing & Form Conventions

- Capital used in production is predetermined relative to current investment; the implementation cross-check uses state variables such as `E_GK` and investment-capital ratios such as `E_LIK`.
- The paper distinguishes physical investment \(J_t\) from investment expenditure \(I_t\) because of capital adjustment costs.
- Capacity utilization is a current control, with a slowly moving reference utilization rate used in the output-gap indicator.
- Employment and capacity utilization trend/reference variables are smoothed states.
- Net foreign assets are denominated in domestic currency and evolve with foreign interest payments and the trade balance.
- Monetary policy uses contemporaneous and lagged output-gap terms plus lagged nominal interest-rate smoothing.
- Fiscal rules use lagged expenditure growth, error correction in spending-to-GDP ratios, and output-gap responses.
- Model form is paper-side nonlinear/growth-rate DSGE; MMB implementation is a linearized/log-growth Dynare representation. Do not treat `.mod` equations as independent paper evidence.

## 8. Variable & Parameter Reference Table

| Category | Symbol / implementation name | Meaning | Main equation(s) |
|---|---|---|---|
| Endogenous | \(Y_t^j\), `E_GY` | domestic output/growth | (F1), (F2), (F35) |
| Endogenous | \(L_t\), `E_LL`, `E_GL` | employment and employment growth | (F3), (F15), (F28), (F37) |
| Endogenous | \(K_t\), `E_GK` | private capital stock/growth | (F16), (F22), (F24) |
| Endogenous | \(ucap_t\), `E_UCAP` | capacity utilization | (F17), (F35), (F36) |
| Endogenous | \(P_t^j\), \(\pi_t\), `E_PHI` | domestic price inflation/markup | (F6), (F18) |
| Endogenous | \(I_t\), \(J_t\), `E_GI`, `E_LIK` | investment and physical investment | (F8), (F12), (F23) |
| Endogenous | \(Q_t\), `E_Q` | Tobin's Q | (F23), (F24) |
| Endogenous | \(C_t^i\), `E_LCNLCSN` | Ricardian consumption | (F10), (F11), (F19), (F27) |
| Endogenous | \(C_t^k\), `E_LCLCSN` | liquidity-constrained consumption | (F13), (F27) |
| Endogenous | \(C_t\), `E_LCSN` | aggregate consumption | (F27) |
| Endogenous | \(W_t/P_t^C\), `E_LYWR`, `E_WS` | real consumption wage/wage share | (F25), (F26) |
| Endogenous | \(M_t\), `E_LIMYN` | imports | (F29), (F32), (F33) |
| Endogenous | \(X_t\), `E_LEXYN` | exports | (F30), (F31), (F33) |
| Endogenous | \(B_t^F\), `E_BWRY` | net foreign assets | (F21), (F34) |
| Endogenous | \(B_t\), `E_LBGYN` | government debt | (F41), (F42) |
| Endogenous | \(YGAP_t\), `E_LYGAP` | output gap | (F35) |
| Endogenous | \(i_t\), `E_INOM` | nominal interest rate | (F49) |
| Exogenous shock | \(\varepsilon_t^Y\), `E_EPS_Y` | TFP innovation | (F43) |
| Exogenous shock | \(\varepsilon_t^{UI}\) | investment-technology innovation | (F45) |
| Exogenous shock | \(u_t^{CG}\), `E_EPS_G` / `fiscal_` | government-consumption shock | (F46) |
| Exogenous shock | \(u_t^{IG}\), `E_EPS_IG` | government-investment shock | (F47) |
| Exogenous shock | \(u_t^{TR}\), `E_EPS_TR` | transfer shock | (F48) |
| Exogenous shock | \(u_t^{INOM}\), `E_EPS_M` / `interest_` | monetary-policy shock | (F49) |
| Exogenous shock | \(u_t^M\), `E_EPS_EX` | import/trade preference shock | (F14), (F29), (F30) |
| Exogenous shock | \(u_t^p\), `E_EPS_ETA` | domestic price-markup shock | (F18) |
| Exogenous shock | \(u_t^W\), `E_EPS_W` | wage-markup shock | (F26) |
| Exogenous shock | \(u_t^{P,k}\), `E_EPS_ETAM`, `E_EPS_ETAX` | import/export markup shocks | (F33) |
| Parameter | \(\beta\), `BETAE` | discount factor | (F10), (F20)-(F24) |
| Parameter | \(\alpha\), `ALPHAE` | labor/capital production share convention | (F2), (F15)-(F17) |
| Parameter | \(\alpha_G\), `ALPHAGE` | public-capital production elasticity | (F2) |
| Parameter | \(\gamma_L\), `GAMLE` | labor adjustment cost | (F5), (F15) |
| Parameter | \(\gamma_P\), `GAMPE` | domestic price adjustment cost | (F6), (F18) |
| Parameter | \(\gamma_{ucap,1}\), \(\gamma_{ucap,2}\), `A1E`, `A2E` | utilization cost | (F7), (F17) |
| Parameter | \(\gamma_K\), \(\gamma_I\), `GAMIE`, `GAMI2E` | investment adjustment costs | (F12), (F23) |
| Parameter | \(slc\), `SLC` | share of liquidity-constrained households | (F13), (F27), (F28) |
| Parameter | \(\tau\) coefficients | fiscal and monetary rule coefficients | (F46), (F47), (F49) |
| Parameter | \(\rho\) coefficients | persistence parameters | (F36), (F37), (F43)-(F50) |
