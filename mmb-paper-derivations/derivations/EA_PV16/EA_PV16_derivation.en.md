# EA_PV16 -- Derivation Notes (First-Pass Model Archive)

Provenance: model `EA_PV16`, Priftis and Vogel (2016), "The Portfolio Balance Mechanism and QE in the Euro Area", DOI `10.1111/manc.12162`. Primary source: `raw/mmb_mineru/runs/ea_pv16__the_portfolio_balance_mechanism_and_qe_in_the_euro_area__1dbe823d/full.md`. Raw PDF existence was checked for provenance only; the PDF body was not read. Status: `needs_review`.

## 1. Model Overview

EA_PV16 is a euro-area version of the QUEST open-economy DSGE model augmented with a central-bank balance sheet, short-term government debt, long-term government bonds, and imperfect substitutability across assets. QE is represented as purchases of long-term government bonds by the central bank, financed by liquidity provision to the private sector.

The paper states that each regional block has Ricardian and liquidity-constrained households, firms, a government, sticky prices and wages, capital accumulation, trade, and financial links to the rest of the world. The printed source focuses on the QE portfolio-balance block; the complete QUEST baseline is referred to external model documentation and the paper appendix. Therefore the baseline production, wage, and price-setting equations are listed as source-context items and remain `needs_review` for full equation-level extraction.

Model form: nonlinear DSGE in levels and ratios, solved by local approximation in the implementation. Implementation cross-check `EA_PV16_rep.mod` uses a large nonlinear model block with many first-difference auxiliaries and stochastic simulation; it was used only to verify variable names and QE-block coverage.

## 2. Optimization Problems

### Ricardian household

The Ricardian household chooses consumption, labour, physical capital, short-term domestic bonds, long-term domestic bonds, and foreign bonds:

\[
\max L^r = E_0\sum_{t=0}^{\infty}\beta^t U(C_t^r,1-N_t^r)
\]

subject to the source budget constraint that includes consumption taxes, capital accumulation, short-term bond purchases, long-term bond purchases with portfolio adjustment costs, foreign bond purchases with external-position adjustment costs, transfers, coupons and depreciated long-bond principal, inherited short-term and foreign bonds, wage income, capital income, and dividends:

\[
\begin{aligned}
0={}&
\frac{(1+t_t^c)P_t^C}{P_t}C_t^r
+\frac{P_t^C(K_t-(1-\delta_k)K_{t-1})}{P_t}
+\frac{P_t^N B_t^{L,H}}{P_t}
\left[1+\frac{\gamma_b}{2}\left(\kappa\frac{B_t^S}{B_t^{L,H}}-1\right)^2\right]
+\frac{B_t^S}{(1+i_t)P_t}
+\frac{e_t B_t^{\ast}}{(1+i_t^{\ast})P_t} \\
&+\frac{\gamma_f}{2}\left(\frac{e_t(B_t^{\ast}-\bar B^{\ast})}{P_t}\right)^2
-\frac{TR_t}{P_t}
-\frac{cB_{t-1}^{L,H}}{P_t}
-\frac{\delta_b P_t^N B_{t-1}^{L,H}}{P_t}
-\frac{B_{t-1}^S}{P_t}
-\frac{e_tB_{t-1}^{\ast}}{P_t} \\
&-\frac{(1-t_t^w)W_tN_t^r}{P_t}
-\left(i_{t-1}^k-(i_{t-1}^k-\delta_k)t_{t-1}^k-\varphi_{t-1}\right)
\frac{P_t^C}{P_t}K_{t-1}
-\frac{D_t}{P_t}.
\end{aligned}
\]

The cross-border extension adds holdings of foreign long-term bonds \(B_t^{L,H\ast}\) and a quadratic adjustment cost around the domestic/foreign long-bond mix:

\[
\frac{e_t P_t^{N\ast}B_t^{L,H\ast}}{P_t}
\left[1+\frac{\gamma_b^{\ast}}{2}\left(\kappa^{\ast}\frac{B_t^{L,H}}{B_t^{L,H\ast}}-1\right)^2\right].
\]

### Liquidity-constrained household, firms, and government

The paper states that liquidity-constrained households consume current disposable wage and transfer income, intermediate producers use local labour and capital, final-good firms combine domestic and imported intermediates, wages are set by monopolistic trade unions, and governments purchase goods, transfer income, levy taxes, and issue debt. The printed Markdown does not include the full optimization systems for these QUEST blocks; this omission is `needs_review`.

## 3. First-Order Conditions

The following F-conditions are the source-backed QE and portfolio-balance equations. They are numbered continuously for archive review; equations marked `needs_review` reflect OCR or appendix-coverage limits.

- **(F1) Short-term domestic bond Euler equation**:

\[
\beta E_t\left(\frac{\lambda_{t+1}}{\lambda_t}\right)
=E_t\left(\frac{P_{t+1}}{P_t}\right)
\left[
\frac{1}{1+i_t}
+\gamma_b\kappa P_t^N\left(\kappa\frac{B_t^S}{B_t^{L,H}}-1\right)
\right].
\]

- **(F2) Long-term domestic bond Euler equation**:

\[
\beta E_t\left(\frac{\lambda_{t+1}}{\lambda_t}\right)
=E_t\left\{
\frac{P_t^N}{\delta_bP_{t+1}^N+c}
\frac{P_{t+1}}{P_t}
\left[
1+\frac{\gamma_b}{2}\left(\kappa\frac{B_t^S}{B_t^{L,H}}-1\right)^2
-\gamma_b\kappa\left(\kappa\frac{B_t^S}{B_t^{L,H}}-1\right)\frac{B_t^S}{B_t^{L,H}}
\right]\right\}.
\]

- **(F3) Foreign short-term bond Euler equation**:

\[
\beta E_t\left(\frac{\lambda_{t+1}}{\lambda_t}\right)
=E_t\left(\frac{e_t}{e_{t+1}}\frac{P_{t+1}}{P_t}\right)
\left[
\frac{1}{1+i_t^{\ast}}
+\gamma_f\frac{e_t(B_t^{\ast}-\bar B^{\ast})}{P_t}
\right].
\]

- **(F4) Physical-capital return condition**:

\[
\beta E_t\left(\frac{\lambda_{t+1}}{\lambda_t}\right)
=E_t\left(\frac{P_{t+1}}{P_t}\frac{P_t^C}{P_{t+1}^C}\right)
\frac{1}{(1+i_t^k-\varphi_t-\delta_k)-t_t^k(i_t^k-\delta_k)}.
\]

- **(F5) Consumption marginal utility condition**:

\[
U_t^C=\frac{(1+t_t^c)P_t^C}{P_t}\lambda_t.
\]

- **(F6) Labour marginal condition**:

\[
U_t^N=\frac{(1-t_t^w)W_t}{P_t}\lambda_t.
\]

- **(F7) QE channel: domestic versus foreign short-term assets**:

\[
\frac{1}{1+i_t}
+\gamma_b\kappa P_t^N\left(\kappa\frac{B_t^S}{B_t^{L,H}}-1\right)
=E_t\left(\frac{e_t}{e_{t+1}}\right)
\left[
\frac{1}{1+i_t^{\ast}}
+\gamma_f\frac{e_t(B_t^{\ast}-\bar B^{\ast})}{P_t}
\right].
\]

- **(F8) QE channel: domestic assets versus capital**:

\[
\frac{1}{1+i_t}
+\gamma_b\kappa P_t^N\left(\kappa\frac{B_t^S}{B_t^{L,H}}-1\right)
=E_t\left(\frac{P_t^C}{P_{t+1}^C}\right)
\frac{1}{(1+i_t^k-\varphi_t-\delta_k)-t_t^k(i_t^k-\delta_k)}.
\]

- **(F9) QE channel: domestic assets versus consumption saving**:

\[
\frac{1}{1+i_t}
+\gamma_b\kappa P_t^N\left(\kappa\frac{B_t^S}{B_t^{L,H}}-1\right)
=
\beta
\frac{(1+t_t^c)P_t^C U_{t+1}^C}
{(1+t_{t+1}^c)P_{t+1}^C U_t^C}.
\]

- **(F10) Cross-border extension: domestic long-bond Euler condition**:

\[
\beta E_t\left(\frac{\lambda_{t+1}}{\lambda_t}\frac{P_t}{P_{t+1}}\right)
=E_t\left(\frac{P_t^N}{\delta_bP_{t+1}^N+c}\right)
\left[
1+\frac{\gamma_b}{2}\left(\kappa\frac{B_t^S}{B_t^{L,H}}-1\right)^2
-\gamma_b\kappa\left(\kappa\frac{B_t^S}{B_t^{L,H}}-1\right)\frac{B_t^S}{B_t^{L,H}}
+\gamma_b^{\ast}\kappa^{\ast}\left(\kappa^{\ast}\frac{B_t^{L,H}}{B_t^{L,H\ast}}-1\right)
\frac{e_tP_t^{N\ast}}{P_t^N}
\right].
\]

- **(F11) Cross-border extension: foreign long-bond Euler condition**:

\[
\beta E_t\left(\frac{\lambda_{t+1}}{\lambda_t}\frac{P_t}{P_{t+1}}\frac{e_{t+1}}{e_t}\right)
=E_t\left(\frac{P_t^{N\ast}}{\delta_b^{\ast}P_{t+1}^{N\ast}+c^{\ast}}\right)
\left[
1+\frac{\gamma_b^{\ast}}{2}\left(\kappa^{\ast}\frac{B_t^{L,H}}{B_t^{L,H\ast}}-1\right)^2
-\gamma_b^{\ast}\kappa^{\ast}\left(\kappa^{\ast}\frac{B_t^{L,H}}{B_t^{L,H\ast}}-1\right)
\frac{B_t^{L,H}}{B_t^{L,H\ast}}
\right].
\]

## 4. Market Clearing & Identities

- **(F12) Price of a newly issued long-term bond**:

\[
P_t^N=\sum_{n=0}^{T}\frac{\delta_b^n}{(1+i)^{1+n}}c.
\]

- **(F13) Price of an old long-term bond**:

\[
P_t^O=\sum_{n=0}^{T-1}\frac{\delta_b^{1+n}}{(1+i)^{1+n}}c.
\]

- **(F14) Approximate old/new long-bond price relation**:

\[
P_t^O=\delta_b P_t^N.
\]

- **(F15) Total government debt split**:

\[
B_t=B_t^L+B_t^S.
\]

- **(F16) Constant long-bond share in government debt**:

\[
B_t^L=s^L B_t.
\]

- **(F17) Domestic split of long-term bonds**:

\[
B_t^L=B_t^{L,H}+B_t^{L,CB}.
\]

- **(F18) Government budget with short- and long-term debt**:

\[
\frac{B_t^S}{(1+i_t)P_t}+\frac{P_t^N}{P_t}B_t^L
=\frac{B_{t-1}^S}{P_t}
+\frac{(\delta_bP_t^N+c)B_{t-1}^L}{P_t}
+\frac{PGE_t}{P_t}
-\frac{TAX_t}{P_t}
-\frac{PR_t^{CB}}{P_t}.
\]

- **(F19) Central-bank operating profit**:

\[
PR_t^{CB}=\Delta M_t+cB_{t-1}^{L,CB}
-\left(P_t^N B_t^{L,CB}-\delta_bP_t^N B_{t-1}^{L,CB}\right).
\]

- **(F20) Cross-border government-bond split**:

\[
B_t=B_t^{L,H}+B_t^{L,F}+B_t^{L,CB}+B_t^S.
\]

- **(F21) Net foreign asset identity with foreign long bonds**:

\[
\begin{aligned}
e_t(B_t^{\ast}+P_t^{N\ast}B_t^{L,H\ast})-P_t^N B_t^{L,F}
={}&(1+i_{t-1}^{\ast})e_tB_{t-1}^{\ast}
+(c^{\ast}+\delta_b^{\ast}P_t^{N\ast})e_tB_{t-1}^{L,H\ast} \\
&-(c+\delta_bP_t^N)e_tB_{t-1}^{L,F}
+P_t^X X_t-P_t^M M_t.
\end{aligned}
\]

Baseline QUEST market clearing for final output, imports, exports, capital, labour, sticky prices, sticky wages, and fiscal closure is present in the implementation cross-check but not fully printed in the Markdown source. Those equations are `needs_review` for paper-side extraction.

## 5. Exogenous Processes

- **(F22) QE purchase path**:

\[
B_t^{L,CB}=\rho_{qe}B_{t-1}^{L,CB}+\tau_{qe}\,\widetilde{Y}_t+\varepsilon_t^{qe}
\]

This rule is not printed as a numbered paper equation; it is an implementation cross-check from `EA_PV16_rep.mod`, where `EA_blcb` follows an autoregressive/policy rule with shock `EA_eps_qe`. Marked `needs_review` until checked against the paper appendix.

- **(F23) Normal-times policy rule / ZLB simulation convention**:

\[
i_t=\mathcal{T}(\pi_t,\widetilde{Y}_t,i_{t-1},\varepsilon_t^m)
\]

The paper states that normal-times monetary policy follows a Taylor rule and that simulations freeze the short-term policy rate for an initial ZLB period. The exact Taylor-rule equation is not printed in the extracted Markdown and is `needs_review`.

Other exogenous processes in the implementation cross-check include shocks to government spending, investment, imports, labour supply, TFP, monetary policy, bond risk premia, currency risk premia, investment risk premia, fiscal closure, transfers, utilization, firm value, and wages. These names are recorded in `source_manifest.json` as implementation coverage, not paper-side equations.

## 6. Steady-State Solution

The source provides calibration anchors rather than a full analytic steady-state solution. The long-bond depreciation parameter is set from a 10-year quarterly maturity assumption:

\[
\delta_b=0.975.
\]

The long-term bond share in government debt is set to:

\[
s^L=0.5.
\]

The benchmark portfolio adjustment parameter is calibrated to reproduce a 6 basis point initial term-premium decline:

\[
\gamma_b=0.0005.
\]

In the cross-border extension, the source reports:

\[
\gamma_b=0.0001,\qquad \gamma_b^{\ast}=0.0013.
\]

Implementation cross-check steady-state values include `EA_deltabl=0.975`, `EA_gamb=0.0005`, `EA_sbl=0.5`, `EA_kbl=1`, `EA_pbl=1`, `EA_bl=EA_bs=1.20388124742112`, and `EA_blcb=0`. These values are recorded only as implementation cross-checks. A complete steady-state derivation for the full QUEST model is `needs_review` because it is not contained in the paper Markdown.

## 7. Timing & Form Conventions

Long-term bonds pay a declining coupon stream. A newly issued bond in period \(t\) has price \(P_t^N\); a bond issued in \(t-1\) has price \(P_t^O\) and is approximately \(\delta_bP_t^N\). Central-bank holdings \(B_t^{L,CB}\), private long-bond holdings \(B_t^{L,H}\), short bonds \(B_t^S\), capital \(K_t\), and foreign assets \(B_t^{\ast}\) are stock variables. In the household budget, period-\(t\) purchases appear as current uses of funds, while inherited stocks and coupon/depreciated-principal payments appear with \(t-1\) lags.

The model is nonlinear. The implementation cross-check uses levels, ratios, inflation rates, and first-difference auxiliary variables; it is not a hand log-linear `model(linear)` file. QE in the paper simulations is an exogenous balance-sheet path matching the ECB 2015 announcement, with the short-term rate frozen during the ZLB interval.

## 8. Variable & Parameter Reference Table

| Category | Symbol / implementation name | Meaning | Main source-backed equation(s) |
|---|---|---|---|
| Endogenous | \(C_t^r\), `ea_cnlc` | Ricardian consumption | (F5), (F9) |
| Endogenous | \(N_t^r\), `ea_l` | Labour / employment | (F6) |
| Endogenous | \(\lambda_t\), `ea_lamnlc` | Marginal value of wealth | (F1)-(F6) |
| Endogenous | \(B_t^S\), `EA_bs` | Short-term government bonds | (F1), (F15), (F18) |
| Endogenous | \(B_t^L\), `EA_bl` | Long-term government bonds | (F15)-(F18), (F20) |
| Endogenous | \(B_t^{L,H}\), `EA_blnlc` | Long-term bonds held by private sector | (F2), (F10), (F17), (F20) |
| Endogenous | \(B_t^{L,CB}\), `EA_blcb` | Long-term bonds held by central bank | (F17), (F19), (F22) |
| Endogenous | \(P_t^N\), `EA_pbl` | Price of long-term bond | (F12)-(F14), (F18), (F19) |
| Endogenous | \(M_t\), `ea_m` | Liquidity / money | (F19) |
| Endogenous | \(B_t^{\ast}\), `ea_bw` | Foreign short-term asset position | (F3), (F21) |
| Endogenous | \(e_t\), `ea_e` | Nominal exchange rate | (F3), (F7), (F10), (F11), (F21) |
| Endogenous | \(K_t\), `ea_k` | Private capital stock | (F4), (F8) |
| Endogenous | \(i_t\), `ea_inom` | Short-term nominal interest rate | (F1), (F7)-(F9), (F23) |
| Endogenous | \(PR_t^{CB}\), `EA_profcb` | Central-bank operating profit | (F18), (F19) |
| Exogenous shock | \(\varepsilon_t^{qe}\), `EA_eps_qe` | QE purchase shock | (F22) |
| Exogenous shock | \(\varepsilon_t^m\), `ea_eps_m` | Monetary policy shock | (F23) |
| Parameters | \(\beta,\theta\), `ea_theta` | Discounting / implementation discount parameter | (F1)-(F4), (F10), (F11) |
| Parameters | \(\gamma_b\), `EA_gamb` | Domestic long/short bond portfolio adjustment cost | (F1), (F2), (F7)-(F10) |
| Parameters | \(\gamma_b^{\ast}\) | Domestic/foreign long-bond adjustment cost | (F10), (F11) |
| Parameters | \(\gamma_f\) | Foreign asset position adjustment cost | (F3), (F7) |
| Parameters | \(\kappa,\kappa^{\ast}\), `EA_kbl` | Target asset-ratio parameters | (F1), (F2), (F7), (F10), (F11) |
| Parameters | \(\delta_b,\delta_b^{\ast}\), `EA_deltabl` | Long-bond coupon depreciation | (F12)-(F14), (F18), (F21) |
| Parameters | \(s^L\), `EA_sbl` | Long-bond share of government debt | (F16) |
| Parameters | \(\rho_{qe},\tau_{qe}\), `EA_rhoqe`, `EA_tqe` | QE purchase persistence and response | (F22) |

Runtime validation was not performed.
