# BRA_SAMBA08 - SAMBA: Stochastic Analytical Model with a Bayesian Approach

Provenance: `BRA_SAMBA08`, Gouvea, Minella, Santos, and Souza-Sobrinho, 2008 model row; primary paper source is Banco Central do Brasil Working Paper 239, "SAMBA: Stochastic Analytical Model with a Bayesian Approach", April/June 2011. DOI recorded in the MMB index: `10.12660/bre.v35n22015.57573`. Source Markdown: `raw/mmb_mineru/runs/bra_samba08__samba_stochastic_analytical_model_with_a_bayesian_approach__8681ba38/full.md`. Raw PDF path exists: `raw/mmb_papers/Stochastic analytical model with a bayesian approach 2011.pdf`. MinerU run ids: `8681ba38-3d6a-453b-8229-c524e9fde18e`; secondary matched run `c6e497b6-b09e-4a9e-9c91-8b913af49f93`.

Status: `needs_review`. The MMB index flags a title/source-date mismatch: the model row is `BRA_SAMBA08`, while the primary source title is "Stochastic analytical model with a bayesian approach 2011". The extraction below uses the paper-side Markdown and the paper appendix log-linear system; the MMB `.mod` is used only as an implementation cross-check.

## 1. Model Overview

SAMBA is a medium-scale small open economy DSGE model for Brazil. It combines optimizing and rule-of-thumb households, wage rigidity, sectoral price rigidity, administered prices, domestic and imported production inputs, external finance of imports, incomplete international asset markets, a fiscal authority with a primary-surplus rule, and a monetary authority following a forward-looking Taylor rule.

The paper gives the nonlinear problems, a stationary balanced-growth-path system, deterministic steady-state relations, and the log-linear model used for estimation. The MMB implementation cross-check is `model(linear)`, so this archive entry records the log-linear equilibrium as the operational model form while retaining the optimizing problems and nonlinear/BGP provenance.

Main agents and blocks:

- Optimizing households choose consumption, domestic bonds, foreign bonds, capital, investment, and wages.
- Rule-of-thumb households consume current after-tax labor income.
- Domestic input producers use capital and labor.
- Importers set local-currency import prices with Calvo rigidity.
- Sectoral intermediate producers combine domestic and imported inputs for consumption, government, investment, and export goods.
- Consumption goods split into freely-set and administered price components.
- Government follows fiscal and monetary policy rules.
- Foreign output, foreign prices, foreign interest rate, import prices, and investor risk aversion are exogenous.

## 2. Optimization Problems

Optimizing household problem:

$$
\max_{\{C_{j,t},B_{j,t+1},B^{\ast}_{j,t+1},K_{j,t+1},I_{j,t}\}}
E_0\sum_{t=0}^{\infty}\beta^t u(C_{j,t},N_{j,t})
$$

subject to the nominal flow budget constraint, capital accumulation, and wage-setting constraints. Utility has external habit and a labor-disutility term:

$$
u(C_{j,t},N_{j,t})
=Z_t^C\left[
\frac{(C_{j,t}-\kappa C^O_{t-1})^{1-\sigma}}{1-\sigma}
-Z_t^{1-\sigma}\frac{\psi}{1+\eta}N_{j,t}^{1+\eta}
\right].
$$

Rule-of-thumb household constraint:

$$
C^{RT}_t=(1-T_t)W_tN_t.
$$

Domestic input producer cost minimization:

$$
\min_{\{K_t,N_t\}}\; R_t^{K,n}K_t+W_t^nN_t
\quad\text{s.t.}\quad
Y_t^D=Z_t^D K_t^\alpha\bigl(Z_t(N_t-\bar N)\bigr)^{1-\alpha}.
$$

Importers and sectoral producers solve Calvo pricing problems. For sectoral goods $H\in\{C,I,G,X\}$, sectoral assemblers use Dixit-Stiglitz aggregators and intermediate firms combine domestic and imported inputs. Export prices are set in foreign currency. Administered-price firms do not optimize prices; they update according to a rule driven by lagged CPI inflation, real exchange rate movements, marginal costs, freely-set prices, and an administered-price shock.

## 3. First-Order Conditions

The following equations are the paper's log-linear system used for estimation, with notation aligned to Appendix C and cross-checked against the MMB `model(linear)` implementation. Equations marked `needs_review` contain OCR-sensitive symbols or a paper-to-MMB reduction that should be checked before promotion.

- **(F1) Optimizing household consumption Euler equation**:
$$
c_t^O=\frac{\tilde\kappa}{1+\tilde\kappa}c_{t-1}^O
+\frac{1}{1+\tilde\kappa}E_tc_{t+1}^O
-\frac{1-\tilde\kappa}{\sigma(1+\tilde\kappa)}
\left(r_t+s_t^B-E_t\pi_{t+1}^C\right)
+\frac{\rho_Z-\tilde\kappa}{1+\tilde\kappa}z_t^Z
-\frac{(1-\rho_C)(1-\tilde\kappa)}{\sigma(1+\tilde\kappa)}z_t^C.
$$

- **(F2) Rule-of-thumb consumption**:
$$
c_t^{RT}=w_t+n_t-\frac{T}{1-T}\tau_t.
$$

- **(F3) Aggregate consumption**:
$$
c_t=\tilde\varpi_C c_t^{RT}+(1-\tilde\varpi_C)c_t^O.
$$

- **(F4) Real exchange rate UIP condition**:
$$
q_t=E_tq_{t+1}-(r_t+s_t^B-E_t\pi_{t+1}^C)
+(r_t^{\ast}+s_t^{B^{\ast}}-E_t\pi_{t+1}^{C^{\ast}})+z_t^Q.
$$

- **(F5) Shadow value of capital**:
$$
q_t^K=\tilde\beta\frac{1-\delta}{Z^Z}E_tq_{t+1}^K
+\left(1-\tilde\beta\frac{1-\delta}{Z^Z}\right)E_tr_{t+1}^K
-(r_t+s_t^B-E_t\pi_{t+1}^C).
$$

- **(F6) Investment Euler equation**:
$$
i_t=\frac{1}{1+\tilde\beta}i_{t-1}
+\frac{\tilde\beta}{1+\tilde\beta}E_ti_{t+1}
+\frac{q_t^K-q_t^I}{\vartheta_I(Z^Z)^2(1+\tilde\beta)}
-\frac{1-\rho_I\tilde\beta}{1+\tilde\beta}z_t^Z
+\frac{1-\rho_I\tilde\beta}{1+\tilde\beta}z_t^I.
$$

- **(F7) Capital accumulation**:
$$
k_{t+1}=\frac{1-\delta}{Z^Z}(k_t-z_t^Z)
+\left(1-\frac{1-\delta}{Z^Z}\right)i_t.
$$

- **(F8) Country risk premium**:
$$
s_t^{B^{\ast}}=-\varphi_B^{\ast} b_{t+1}^{\asty}+\varphi_V^{\ast}v_t^{\ast}+z_t^{B^{\ast}}.
$$

- **(F9) Domestic risk premium**:
$$
s_t^B=\rho_Bs_{t-1}^B+\varepsilon_t^B.
$$

- **(F10) Wage Phillips curve**:
$$
\Delta w_t=\frac{\omega_W}{1+\tilde\beta\omega_W}\Delta w_{t-1}
+\frac{\tilde\beta}{1+\tilde\beta\omega_W}E_t\Delta w_{t+1}
+\lambda_W(mrs_t-w_t)+z_t^W+\text{indexation terms}.
$$
`needs_review`: the compact MMB implementation uses a static labor supply relation instead of the full wage Phillips curve.

- **(F11) Marginal rate of substitution**:
$$
mrs_t=\eta n_t+\frac{\sigma}{1-\tilde\kappa}
\left[c_t^O-\tilde\kappa(c_{t-1}^O-z_t^Z)\right].
$$

- **(F12) Rental rate of capital**:
$$
r_t^K=q_t^D+y_t^D-k_t+z_t^Z.
$$

- **(F13) Relative price of domestic input**:
$$
q_t^D=\alpha r_t^K+(1-\alpha)w_t-z_t^D.
$$

- **(F14) Labor demand**:
$$
n_t=\alpha_N(q_t^D+y_t^D-w_t).
$$

- **(F15) Import-price Phillips curve**:
$$
\pi_t^M-v_t^M=\lambda_M(q_t+q_t^{M^{\ast}}-q_t^M)
+\tilde\beta E_t(\pi_{t+1}^M-v_{t+1}^M).
$$

- **(F16) Sectoral marginal cost**:
$$
mc_t^H=\varpi_Hq_t^D+(1-\varpi_H)\left[
q_t^M+\varpi_H^{\ast}(r_t^{\ast}+s_t^{B^{\ast}})
+\vartheta_H^M\bigl((m_t^H-y_t^H)-(m_{t-1}^H-y_{t-1}^H)\bigr)-z_t^M
\right].
$$

- **(F17) Sectoral domestic-input demand**:
$$
y_{H,t}^D=y_t^H-\epsilon_H(q_t^D-mc_t^H).
$$

- **(F18) Sectoral imported-input demand**:
$$
m_t^H=y_t^H-\frac{\epsilon_H}{1+\epsilon_H\vartheta_H^M}
\left[q_t^M+\varpi_H^{\ast}(r_t^{\ast}+s_t^{B^{\ast}})-mc_t^H\right]
+\frac{\epsilon_H}{1+\epsilon_H\vartheta_H^M}
\left[\vartheta_H^M(m_{t-1}^H-y_{t-1}^H)+z_t^M\right].
$$

- **(F19) Price Phillips curve for government and investment goods**:
$$
\pi_t^H-v_t^H=\lambda_H(mc_t^H-q_t^H)
+\tilde\beta E_t(\pi_{t+1}^H-v_{t+1}^H)+z_t^P,\quad H\in\{G,I\}.
$$

- **(F20) Sectoral relative-price law of motion**:
$$
q_t^H=q_{t-1}^H+\pi_t^H-\pi_t^C.
$$

- **(F21) Freely-set consumption-price Phillips curve**:
$$
\pi_t^F-v_t^F=\lambda_F(mc_t^C-q_t^F)
+\tilde\beta E_t(\pi_{t+1}^F-v_{t+1}^F)+z_t^P.
$$

- **(F22) Freely-set relative-price law of motion**:
$$
q_t^F=q_{t-1}^F+\pi_t^F-\pi_t^C.
$$

- **(F23) Administered-price inflation**:
$$
\pi_t^A=\theta_Av_t^A+(1-\theta_A)\bar\pi_t^C.
$$

- **(F24) Administered-price rule**:
$$
v_t^A=\chi_A\left[\pi_{t-1,t-5}^C+v_A^1(q_{t-1}-q_{t-5})
+v_A^2(mc_{t-1}^C-mc_{t-5}^C)\right]
+(1-\chi_A)q_t^F+\frac{1}{\theta_A}z_t^A.
$$

- **(F25) CPI inflation aggregation**:
$$
\pi_t^C=\varpi_A\pi_t^A+(1-\varpi_A)\pi_t^F.
$$

- **(F26) Export-price Phillips curve**:
$$
\pi_t^X-v_t^X=\lambda_X(mc_t^X-q_t^{X^{\ast}}-q_t)
+\tilde\beta E_t(\pi_{t+1}^X-v_{t+1}^X)+z_t^{P^X}.
$$

- **(F27) Export relative-price law of motion**:
$$
q_t^{X^{\ast}}=q_{t-1}^{X^{\ast}}+\pi_t^X-\pi_t^{C^{\ast}}.
$$

- **(F28) World demand for Brazilian exports**:
$$
x_t=y_t^{\ast}+\frac{\epsilon^{\ast}}{1+\epsilon^{\ast}\vartheta^{M^{\ast}}}
\left[\vartheta^{M^{\ast}}(x_{t-1}-y_{t-1}^{\ast})-q_t^{X^{\ast}}+z_t^{M^{\ast}}\right].
$$

## 4. Market Clearing & Identities

- **(F29) Final goods clearing**:
$$
y_t^C=c_t,\qquad y_t^G=g_t,\qquad y_t^I=i_t,\qquad y_t^X=x_t.
$$

- **(F30) Domestic-input market clearing**:
$$
y_t^D=s_C^D y_{C,t}^D+s_G^D y_{G,t}^D+s_I^D y_{I,t}^D+s_X^D y_{X,t}^D.
$$

- **(F31) Imported-input market clearing**:
$$
m_t=s_C^M m_t^C+s_I^M m_t^I+s_X^M m_t^X.
$$

- **(F32) External loans-to-GDP ratio**:
$$
l_t^{\asty}=\sum_{H=C,I,X}\iota_Hs_{M,H}
\left[
R^{\ast}S^{B^{\ast}}(r_t^{\ast}+s_t^{B^{\ast}})
+(R^{\ast}S^{B^{\ast}}-1)(q_t^M+m_t^H-q_t^Y-y_t)
\right].
$$

- **(F33) Net exports-to-GDP ratio**:
$$
nx_t^y=s_X(q_t+q_t^{X^{\ast}}+x_t)
-s_M(q_t+q_t^{M^{\ast}}+m_t)
-(s_X-s_M)(q_t^Y+y_t).
$$

- **(F34) Net foreign assets-to-GDP law of motion**:
$$
b_{t+1}^{\asty}=\lambda_{B^{\ast}}b_t^{\asty}
+R^{\ast}S^{B^{\ast}}(nx_t^y-l_t^{\asty})
+\tilde B^{\asty}(r_t^{\ast}+s_t^{B^{\ast}})
+\lambda_{B^{\ast}}\tilde B^{\asty}
(y_{t-1}-y_t-\pi_t^Y-z_t^Z+q_t-q_{t-1}+\pi_t^C-\pi_t^{\ast}).
$$

- **(F35) Real GDP**:
$$
y_t=s_Cc_t+s_Ii_t+s_Gg_t+s_Xx_t-s_Mm_t.
$$

- **(F36) Relative GDP deflator**:
$$
q_t^Y=s_Gq_t^G+s_Iq_t^I+s_X(q_t+q_t^{X^{\ast}})
-s_M(q_t+q_t^{M^{\ast}}).
$$

- **(F37) GDP-deflator inflation**:
$$
\pi_t^Y=\pi_t^C+q_t^Y-q_{t-1}^Y.
$$

## 5. Exogenous Processes

- **(F38) Monetary policy rule**:
$$
r_t=\gamma_Rr_{t-1}+(1-\gamma_R)
\left[\frac{1}{4}\bar\pi_{t-3,t+1}^C
+\gamma_\Pi E_t\left(\frac{1}{4}\pi_{t,t+4}^C-\frac{1}{4}\bar\pi_{t,t+4}^C\right)
+\gamma_Yy_t\right]+z_t^R.
$$

- **(F39) Inflation target**:
$$
\frac{1}{4}\bar\pi_{t,t+4}^C
=\rho_{\bar\Pi^C}\frac{1}{4}\bar\pi_{t-4,t}^C
+\varepsilon_t^{\bar\Pi^C}.
$$

- **(F40) Fiscal primary-surplus rule**:
$$
s_t^y=\phi_Ss_{t-1}^y+\phi_{\bar S}\bar s_t^y-s_Gz_t^G.
$$

- **(F41) Primary-surplus target**:
$$
\bar s_t^y=\rho_{\bar S}\bar s_{t-1}^y+\phi_Bb_t^y+\varepsilon_t^{\bar S}.
$$

- **(F42) Tax-rate process**:
$$
\tau_t=\rho_T\tau_{t-1}+\varepsilon_t^T.
$$

- **(F43) Government consumption**:
$$
g_t=\frac{1}{s_G}(\tau_t-s_t^y)+y_t+q_t^Y-q_t^G.
$$

- **(F44) Government debt law of motion**:
$$
b_t^y=\lambda_Bb_{t-1}^y+B^yr_t-Rs_t^y
+\lambda_BB^y(y_{t-1}-y_t-\pi_t^Y-z_t^Z).
$$

- **(F45) Foreign output**:
$$
y_t^{\ast}=\rho_{Y^{\ast}}y_{t-1}^{\ast}+\varepsilon_t^{Y^{\ast}}.
$$

- **(F46) Foreign import-price process**:
$$
q_t^{M^{\ast}}=\rho_{Q^{M^{\ast}}}q_{t-1}^{M^{\ast}}+\varepsilon_t^{Q^{M^{\ast}}}.
$$

- **(F47) Foreign inflation**:
$$
\pi_t^{C^{\ast}}=\rho_{\Pi^{C^{\ast}}}\pi_{t-1}^{C^{\ast}}+\varepsilon_t^{\Pi^{C^{\ast}}}.
$$

- **(F48) Foreign investor risk aversion**:
$$
v_t^{\ast}=\rho_{V^{\ast}}v_{t-1}^{\ast}+\varepsilon_t^{V^{\ast}}.
$$

- **(F49) Foreign interest rate**:
$$
r_t^{\ast}=\rho_{R^{\ast}}r_{t-1}^{\ast}+\varepsilon_t^{R^{\ast}}.
$$

- **(F50) Domestic structural shock processes**:
$$
z_t^S=\rho_Sz_{t-1}^S+\varepsilon_t^S,\quad
S\in\{C,Q,B^{\ast},D,Z,I,M,M^{\ast},W,P,A,P^X,R,G\}.
$$
For the paper's estimation specification, $\rho_R=0$ and $\rho_G=0$.

## 6. Steady-State Solution

The paper derives the deterministic steady state after stationarizing all growing real variables by technology $Z_t$ and nominal variables by $P_t^C$. In steady state all domestic inflation rates equal the CPI inflation target and price/wage distortions vanish.

Key price relations:

$$
MC^C=\frac{\epsilon_C^P-1}{\epsilon_C^P},\qquad
Q^M=Q^{M^\star}=\frac{\epsilon_M}{\epsilon_M-1}QQ^{M^{\ast}}.
$$

$$
R=\frac{\bar\Pi^C(Z^Z)^\sigma}{\beta},\qquad
Q^K=Q^I,\qquad
R^K=\left(\frac{(Z^Z)^\sigma}{\beta}-(1-\delta)\right)Q^K.
$$

$$
\tilde W=(1-\alpha)(Q^D)^{1/(1-\alpha)}
\left(\frac{\alpha}{R^K}\right)^{\alpha/(1-\alpha)},\qquad
S^{B^{\ast}}=\frac{R/\bar\Pi^C}{R^{\ast}/\Pi^{C^{\ast}}}.
$$

Allocation relations include exports from foreign demand, government spending from the tax and primary-surplus target, capital accumulation, household consumption aggregation, production input conditions, and imported-input shares. The paper also calibrates steady-state ratios used directly in the linear model, including $s_C,s_I,s_G,s_X,s_M$, debt ratios, inflation target, domestic and foreign gross interest rates, and the country-risk premium.

Runtime validation: not performed. This entry is a derivation/archive extraction, not a Dynare run.

## 7. Timing & Form Conventions

- Model form: `model(linear)` for the MMB operational implementation. The paper also presents nonlinear and BGP equations.
- Time unit: quarterly.
- Linear variables are deviations or log deviations from steady state; ratios to GDP such as $b_t^y,b_{t+1}^{\asty},nx_t^y,l_t^{\asty}$ are deviations from steady state.
- In the paper's nonlinear timing convention, flow variables decided in period $t$ are indexed by $t$, while stock variables chosen in $t$ are indexed by $t+1$. Capital holdings $K_t$ and bonds $B_t,B_t^{\ast}$ mature from prior choices; $K_{t+1},B_{t+1},B_{t+1}^{\ast}$ are chosen at $t$.
- The MMB `.mod` maps this to Dynare timing with predetermined capital as `k(-1)` in production and `k` as next-period/installed stock after current investment.
- CPI inflation is the numeraire inflation; relative-price laws of motion use sectoral inflation minus CPI inflation.
- OCR issues: equations (A.21), (A.31), and some adjustment-cost derivative terms contain malformed symbols in the MinerU Markdown and are marked `needs_review` for formula-level checking against the PDF if later promotion requires exact nonlinear equations.

## 8. Variable & Parameter Reference Table

| Category | Symbol | Meaning | Main equation(s) |
|---|---|---|---|
| Endogenous | `co`, $c_t^O$ | Optimizing-household consumption | (F1) |
| Endogenous | `crot`, $c_t^{RT}$ | Rule-of-thumb consumption | (F2) |
| Endogenous | `c`, $c_t$ | Aggregate consumption | (F3) |
| Endogenous | `q`, $q_t$ | Real exchange rate | (F4) |
| Endogenous | `qi`, $q_t^K$ | Shadow value of capital / Tobin Q | (F5) |
| Endogenous | `i`, $i_t$ | Investment | (F6) |
| Endogenous | `k`, $k_t$ | Capital stock | (F7) |
| Endogenous | `fii`, $s_t^{B^{\ast}}$ | Country risk premium | (F8) |
| Endogenous | `wr`, $w_t$ | Real wage | (F10) |
| Endogenous | `rk`, $r_t^K$ | Rental rate of capital | (F12) |
| Endogenous | `mc`, $q_t^D$ or marginal cost proxy | Domestic input price / marginal cost | (F13), (F16) |
| Endogenous | `n`, $n_t$ | Aggregate labor | (F14) |
| Endogenous | `m`, $m_t$ | Imports | (F18), (F31) |
| Endogenous | `pi`, $\pi_t^C$ | CPI/free-price inflation proxy in MMB reduction | (F21), (F25) |
| Endogenous | `x`, $x_t$ | Exports | (F28) |
| Endogenous | `nxy`, $nx_t^y$ | Net exports-to-GDP ratio | (F33) |
| Endogenous | `bystar`, $b_{t+1}^{\asty}$ | Net foreign assets-to-GDP | (F34) |
| Endogenous | `y`, $y_t$ | Real GDP | (F35) |
| Endogenous | `yva`, $y_t^Y$ | Value-added output / GDP measure | (F35)-(F37) |
| Endogenous | `piva`, $\pi_t^Y$ | GDP-deflator inflation | (F37) |
| Endogenous | `r`, $r_t$ | Domestic policy rate | (F38) |
| Endogenous | `pibar`, $\bar\pi_t^C$ | Inflation target | (F39) |
| Endogenous | `syhat`, $s_t^y$ | Primary surplus-to-GDP ratio | (F40) |
| Endogenous | `sgbar`, $\bar s_t^y$ | Primary-surplus target | (F41) |
| Endogenous | `gy`, fiscal gap | Fiscal rule helper | (F40)-(F43) |
| Endogenous | `bby`, $b_t^y$ | Government debt-to-GDP ratio | (F44) |
| Endogenous | `g`, $g_t$ | Government consumption | (F43) |
| Endogenous | `mstar`, $y_t^{\ast}$ or world demand | Foreign demand process | (F45) |
| Endogenous | `pistar`, $\pi_t^{C^{\ast}}$ | Foreign inflation | (F47) |
| Endogenous | `rstar`, $r_t^{\ast}$ | Foreign interest rate | (F49) |
| Exogenous | `c_` | Household preference innovation | (F50) |
| Exogenous | `n_` | Wage/labor markup innovation | (F50) |
| Exogenous | `i_` | Investment innovation | (F50) |
| Exogenous | `fii_` | Country risk premium innovation | (F50) |
| Exogenous | `a_` | Technology innovation | (F50) |
| Exogenous | `r_` | Monetary policy innovation | (F50) |
| Exogenous | `g_`, `gbar_` | Fiscal/government target innovations | (F40)-(F44), (F50) |
| Exogenous | `mstar_`, `pistar_`, `rstar_` | Foreign demand, inflation, and interest-rate innovations | (F45)-(F49) |
| Parameters | $\beta,\alpha,\sigma,\kappa,h,\delta,\theta,\omega,\rho,\gamma,\phi,s_j$ | Preferences, technology, nominal rigidity, policies, shares, and shock persistence | all blocks |

Implementation cross-check: the MMB example has 39 endogenous variables and 13 innovations. It compresses the paper's fuller sectoral system into a reduced linear representation with variables `co crot c no nrot n q wr k u fii qi i x m rk mc pi bystar nxy r gy syhat bby g y yva piva pibar sgbar zc zn zi zfiistar zfii a zr zg mstar pistar rstar`.
