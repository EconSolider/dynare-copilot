# NK_FLMF18 - Derivation

> Model archive draft for `NK_FLMF18`. Runtime validation was not performed. Status: `needs_review`.

Source: Filardo, Andrew; Lombardi, Marco; Montoro, Carlos; Ferrari, Massimo (2018), "Monetary policy spillovers, global commoditiy prices and cooperation", BIS Working Paper No. 696. DOI recorded in `raw/mmb_mineru/model_index.csv`: `10.5089/9781513519357.001`.

## 1. Model Overview

- **Model**: A multi-country New Keynesian commodity-price spillover model based on Nakov and Pescatori (2010). The MMB replication is `NK_FLMF18`.
- **Regions**: One commodity-importing region with sticky final-goods prices and monetary policy; one dominant commodity exporter with market power; and a competitive fringe of commodity exporters.
- **Key mechanism**: The real commodity price is endogenous. Commodity demand comes from importer household consumption and final-goods production; commodity supply comes from a dominant exporter and a competitive fringe. Monetary policy may misdiagnose commodity-price changes as supply or demand driven.
- **Policy experiments**: Efficient/natural/benchmark policy rules, commodity supply and aggregate demand shocks, and misdiagnosis exercises.
- **Form**: The paper presents nonlinear equilibrium conditions and log-linear benchmark equations. The MMB implementation uses nonlinear level equations plus log transformations and first-order `stoch_simul`; the operational decision rules are linearized around steady state. This entry records both source nonlinear blocks and the log-linear policy/benchmark form.
- **Main sources**: `raw/mmb_mineru/runs/nk_flmf18__monetary_policy_spillovers_global_commoditiy_prices_and_cooperation__837579b4/full.md`; implementation cross-check only: `.agents/skills/dynare-copilot/references/examples/NK_FLMF18_rep.mod`.

## 2. Optimization Problems

### Commodity-importing household

The representative household chooses consumption, labor, and nominal bonds:

\[
\max_{\{C_t,L_t,B_t\}} E_{t_0}\sum_{t=t_0}^{\infty}\beta^{t-t_0}\exp(g_t)
\left[\ln C_t-\frac{L_t^{1+\nu}}{1+\nu}\right].
\]

Composite consumption combines final goods and the commodity:

\[
C_t=(C_{Y,t})^{1-\gamma}(\mathfrak{M}_{C,t})^\gamma.
\]

The nominal budget constraint is:

\[
C_t=\frac{W_tL_t}{P_t}+\frac{B_{t-1}}{P_t}-\frac{1}{R_t}\frac{B_t}{P_t}
+\frac{\Gamma_t}{P_t}+\frac{T_t}{P_t}.
\]

### Final-goods producers

Each differentiated final-goods producer uses labor and commodity inputs:

\[
Y_t(z)=A_tL_t(z)^{1-\alpha}\mathfrak{M}_{Y,t}(z)^\alpha.
\]

Under Calvo pricing, a firm that can reset its price chooses \(\hat P_{Y,t}(z)\) to maximize expected discounted profits:

\[
E_t\sum_{k=0}^{\infty}\theta^k\zeta_{t,t+k}F_{t+k}^{-1}\Gamma_{t+k}(z),
\]

where after-tax nominal profit is:

\[
\Gamma_t(z)=\left[(1-\tau)P_{Y,t}(z)-P_tMC_t\right]
\left(\frac{P_{Y,t}(z)}{P_{Y,t}}\right)^{-\varepsilon}Y_t.
\]

### Dominant commodity exporter

The dominant exporter produces the commodity using final goods bought from the importing region:

\[
\mathfrak{M}_t=Z_t I_t^{\ast,D}.
\]

Its household consumes final goods and owns the exporting firm. The period real profit expression is:

\[
\frac{\Gamma_t^{\ast,D}}{P_{Y,t}}=Q_t^{1/(1-\gamma)}\mathfrak{M}_t-I_t^{\ast,D}.
\]

The dominant exporter chooses commodity output, taking importer macro variables and fringe supply as given:

\[
\max_{\{\mathfrak{M}_t\}}E_{t_0}\sum_{t=t_0}^{\infty}\beta^{t-t_0}
\ln\left(Q_t^{1/(1-\gamma)}\mathfrak{M}_t-\mathfrak{M}_t/Z_t\right).
\]

### Competitive commodity fringe

Each fringe producer \(j\) chooses commodity output subject to capacity:

\[
\max_{X_t(j)\in[0,\bar X]}
\left[Q_tX_t(j)-\frac{(P_{Y,t}/P_t)X_t(j)}{\xi(j)Z_t}\right].
\]

## 3. First-Order Conditions

**(F1) Household Euler equation**

\[
1=\beta E_t\left[
R_t\left(\frac{P_t}{P_{t+1}}\right)
\left(\frac{C_{t+1}}{C_t}\right)^{-1}
\exp(g_{t+1}-g_t)
\right].
\]

**(F2) Household labor supply**

\[
\frac{W_t}{P_t}=C_tL_t^\nu.
\]

**(F3) Commodity consumption demand**

\[
\mathfrak{M}_{C,t}=\gamma\frac{P_t}{P_{\mathfrak{M},t}}C_t
=\gamma\frac{C_t}{Q_t}.
\]

**(F4) Final-goods consumption demand**

\[
C_{Y,t}=(1-\gamma)\frac{P_t}{P_{Y,t}}C_t.
\]

**(F5) Differentiated final-goods demand**

\[
C_{Y,t}(z)=\left(\frac{P_{Y,t}(z)}{P_{Y,t}}\right)^{-\varepsilon}C_{Y,t}.
\]

**(F6) Headline price index**

\[
P_t=(P_{Y,t})^{1-\gamma}(P_{\mathfrak{M},t})^\gamma.
\]

**(F7) Headline inflation relation**

\[
\Pi_t=(\Pi_{Y,t})^{1-\gamma}(\Pi_{\mathfrak{M},t})^\gamma.
\]

**(F8) Final-goods price index**

\[
P_{Y,t}=\left[\int_0^1P_{Y,t}(z)^{1-\varepsilon}dz\right]^{1/(1-\varepsilon)}.
\]

**(F9) Real marginal cost**

\[
MC_t=\frac{(W_t/P_t)^{1-\alpha}Q_t^\alpha}
{A_t(1-\alpha)^{1-\alpha}\alpha^\alpha}.
\]

**(F10) Labor demand by final-goods firms**

\[
L_t(z)=(1-\alpha)\frac{MC_t}{W_t/P_t}Y_t(z).
\]

**(F11) Commodity input demand by final-goods firms**

\[
\mathfrak{M}_{Y,t}(z)=\alpha\frac{MC_t}{Q_t}Y_t(z).
\]

**(F12) Calvo optimal relative reset price**

\[
\frac{\hat P_{Y,t}(z)}{P_{Y,t}}=
\frac{\mu E_t\sum_{k=0}^{\infty}\theta^k\zeta_{t,t+k}MC_{t+k}F_{t+k}^{\varepsilon}Y_{t+k}}
{E_t\sum_{k=0}^{\infty}\theta^k\zeta_{t,t+k}F_{t+k}^{\varepsilon-1}Y_{t+k}}.
\]

**(F13) Recursive denominator for core inflation**

\[
D_t=\frac{Y_t}{C_t}+\theta\beta E_t\left[(\Pi_{Y,t+1})^{\varepsilon-1}D_{t+1}\right].
\]

**(F14) Recursive numerator for core inflation**

\[
N_t=\mu\frac{Y_t}{C_t}MC_t+\theta\beta E_t\left[(\Pi_{Y,t+1})^\varepsilon N_{t+1}\right].
\]

**(F15) Nonlinear core Phillips curve / price aggregation**

\[
\theta(\Pi_{Y,t})^{\varepsilon-1}
=1-(1-\theta)\left(\frac{N_t}{D_t}\right)^{1-\varepsilon}.
\]

**(F16) Price dispersion**

\[
\Delta_t=(1-\theta)\left(\frac{N_t}{D_t}\right)^{-\varepsilon}
+\theta\Delta_{t-1}(\Pi_{Y,t})^\varepsilon.
\]

**(F17) Aggregate labor demand**

\[
L_t=(1-\alpha)\frac{MC_t}{W_t/P_t}Y_t\Delta_t.
\]

**(F18) Aggregate commodity input demand**

\[
\mathfrak{M}_{Y,t}=\alpha\frac{MC_t}{Q_t}Y_t\Delta_t.
\]

**(F19) Aggregate production**

\[
Y_t=\frac{A_tL_t^{1-\alpha}\mathfrak{M}_{Y,t}^{\alpha}}{\Delta_t}.
\]

**(F20) Dominant exporter commodity demand residual**

\[
\mathfrak{M}_t=\mathfrak{M}_{C,t}+\mathfrak{M}_{Y,t}-X_t.
\]

**(F21) Fringe commodity supply**

\[
X_t=\Omega_tZ_tQ_t.
\]

**(F22) Dominant exporter price-setting condition**

\[
Q_t=\Psi_tZ_t^{-1}.
\]

**(F23) Commodity markup**

\[
\Psi_t=\frac{1}{1-\eta_t}=1+\frac{\mathfrak{M}_t}{2X_t}.
\]

**(F24) Commodity demand elasticity**

\[
\eta_t=\frac{\mathfrak{M}_t}{\mathfrak{M}_t+2X_t}.
\]

**(F25) Policy rule, general nonlinear form**

\[
R_t=\bar R(\Pi_t)^{\varphi_{head}}(\Pi_{Y,t})^{\varphi_{core}}
\left(\frac{Q_t}{Q_{t-1}}\right)^{\varphi_{com}}.
\]

**(F26) Efficient-benchmark policy rule used in the main simulations**

\[
r_t=E_{t|t-1}\left[r_t^e+\varphi_{core}\pi_{Y,t}+\varphi_y\hat y_t^e\right]
+\varphi_{com}\Delta q_t.
\]

**(F27) Signal-extraction observation equation**

\[
q_t=-z_t+\psi_t=H'\xi_t,\qquad H'=[-1\;\;1],\qquad \xi_t=[z_t\;\;\psi_t]'.
\]

**(F28) Signal-extraction update**

\[
E_t^{ma}\left([z_t\;\;\psi_t]'\right)=Mq_t,\qquad
M=PH(H'PH)^{-1}.
\]

**(F29) Misdiagnosis-augmented policy rule**

\[
r_t=E_{t|t-1}^{ma}\left[r_t^e+\varphi_{core}\pi_{Y,t}+\varphi_y\hat y_t^e\right]
+\varphi_{com}\Delta q_t.
\]

## 4. Market Clearing & Identities

**(F30) Bond-market clearing**

\[
B_t=0.
\]

**(F31) Commodity-market clearing**

\[
\mathfrak{M}_{C,t}+\mathfrak{M}_{Y,t}=\mathfrak{M}_t+X_t.
\]

**(F32) Importer aggregate resource constraint**

\[
\frac{P_{Y,t}}{P_t}C_{Y,t}
=\frac{P_{Y,t}}{P_t}Y_t-Q_t(\mathfrak{M}_t+X_t).
\]

**(F33) World final-goods market clearing**

\[
Y_t=C_{Y,t}+C_t^{\ast,D}+I_t^{\ast,D}+C_t^{\ast,F}+I_t^{\ast,F}.
\]

**(F34) Natural output gap**

\[
\hat y_t^n=\left(\frac{\alpha}{1-\alpha}-\frac{1}{1+\nu}\Upsilon\right)mc_t.
\]

**(F35) Efficient output gap relation**

\[
\hat y_t^e=\hat y_t^n
-\left(\frac{\alpha}{1-\alpha}-\frac{1}{1+\nu}\frac{\gamma}{1-\gamma}\Upsilon\right)\psi_t
-\frac{1}{1+\nu}\frac{\gamma}{1-\gamma}(\Upsilon-\Upsilon^e)z_t.
\]

**(F36) Headline inflation in log-linear form**

\[
\pi_t=\pi_{Y,t}+\frac{\gamma}{1-\gamma}\Delta q_t.
\]

**(F37) Core inflation in log-linear form**

\[
\pi_{Y,t}=\kappa_y\hat y_t^n+E_t\pi_{Y,t+1}.
\]

## 5. Exogenous Processes

**(F38) Commodity productivity / supply shock**

\[
\ln Z_t=(1-\rho_z)\ln\bar Z+\rho_z\ln Z_{t-1}+\varepsilon_t^z.
\]

**(F39) Fringe-size shock**

\[
\omega_t=\rho_\omega\omega_{t-1}+\varepsilon_t^\omega.
\]

**(F40) Importer TFP shock**

\[
a_t=\rho_a a_{t-1}+\varepsilon_t^a.
\]

**(F41) Preference shock**

\[
g_t=\rho_g g_{t-1}+\varepsilon_t^g.
\]

**(F42) Monetary policy shock**

\[
err_t=\rho_{err}err_{t-1}+\varepsilon_t^{err}.
\]

**(F43) Aggregate demand / government spending shock**

\[
gg_t=\rho_{gg}gg_{t-1}+\varepsilon_t^{gg}.
\]

## 6. Steady-State Solution

The source appendix gives the steady-state commodity-sector system:

\[
\Psi=1+\frac{\mathfrak{M}/Y}{2X/Y},\qquad Q=\Psi Z^{-1}.
\]

\[
\frac{P_Y}{P}=Q^{-\gamma/(1-\gamma)},\qquad
\frac{X}{Y}=\frac{\Omega Z}{Y}Q.
\]

\[
\frac{\mathfrak{M}}{Y}=
\left[\gamma\frac{P_Y}{P}+(1-\gamma)\frac{\alpha}{\mu}\right]\frac{1}{Q}
-\frac{X}{Y}.
\]

Given \((\alpha,\gamma,\Omega Z/Y,\mu,Z)\), solve the above system for \((\Psi,Q,P_Y/P,X/Y,\mathfrak{M}/Y)\). With zero steady-state inflation:

\[
\Pi=1,\qquad MC=\frac{1}{\mu},\qquad \Delta=1.
\]

The remaining steady-state ratios are:

\[
\frac{C}{Y}=\frac{P_Y}{P}-\frac{\alpha}{\mu}.
\]

\[
L=\left[\frac{(1-\alpha)/\mu}{C/Y}\right]^{1/(1-\nu)}.
\]

\[
Y=\left[A\left(\frac{\alpha}{\mu}\frac{1}{Q}\right)^\alpha\right]^{1/(1-\alpha)}L.
\]

Baseline calibration in the paper/MMB implementation includes:

| Parameter | Value | Role |
|---|---:|---|
| \(\Pi\), \(MC\), \(\Delta\) | \(1\), \(1/\mu\), \(1\) | normalized steady-state values |

The remaining steady-state ratios are:

\[
\frac{C}{Y}=\frac{P_Y}{P}-\frac{\alpha}{\mu}.
\]

\[
L=\left[\frac{(1-\alpha)/\mu}{C/Y}\right]^{1/(1-\nu)}.
\]

\[
Y=\left[A\left(\frac{\alpha}{\mu}\frac{1}{Q}\right)^\alpha\right]^{1/(1-\alpha)}L.
\]

Baseline calibration in the paper/MMB implementation includes:

| Parameter | Value | Role |
|---|---:|---|
| \(\gamma\) | 0.1 | commodity share in consumption basket |
| \(\alpha\) | 0.1 | commodity share in production |
| \(\nu\) | 0.5 | inverse Frisch labor-supply elasticity |
| \(\varepsilon\) | 7.66 or 7.67 | goods substitution elasticity; OCR/table and `.mod` differ by rounding |
| \(\beta\) | 0.99 | discount factor |
| \(\theta\) | 0.75 | Calvo non-reset probability |
| \(A,Z\) | 1 | steady-state productivity normalizations |
| \(X/Y\) | 0.1 | competitive commodity sector size relative to GDP |

needs_review: The source Markdown contains OCR corruption in parts of the appendix and one `.mod` cross-check line references `RHO_GG` without listing it in the displayed parameter declaration excerpt. Runtime validation was not performed.

## 7. Timing & Form Conventions

- **Timing**: Bonds are end-of-period nominal holdings and clear in zero net supply. Price dispersion \(\Delta_t\) is a state variable with lag \(\Delta_{t-1}\). Commodity price changes use \(Q_t/Q_{t-1}\).
- **Inflation**: \(\Pi_t=P_t/P_{t-1}\) is headline inflation, \(\Pi_{Y,t}=P_{Y,t}/P_{Y,t-1}\) is core/final-goods inflation, and commodity inflation is embedded through the commodity price and headline price index.
- **Real commodity price**: \(Q_t=P_{\mathfrak{M},t}/P_t\); using the price-index identity, it is tied to the importer terms of trade.
- **Form**: Paper equations are nonlinear where possible; benchmark and policy-analysis blocks are log-linear. The MMB `.mod` uses level variables with `N` prefixes plus logged reporting variables such as `Y=ln(NY)`, `Q=ln(NQ)`, and first-order simulation.
- **Runtime validation**: Not performed for this archive entry.

## 8. Variable & Parameter Reference Table

### Endogenous variables

| Symbol / MMB name | Meaning | Main equation(s) |
|---|---|---|
| \(C_t\) / `NC`, `C` | aggregate consumption | (F1), (F3), (F4) |
| \(C_{Y,t}\) / `NCY`, `CY` | final-goods consumption | (F4), (F32) |
| \(\mathfrak{M}_{C,t}\) / `NOC`, `OC` | commodity consumption | (F3), (F31) |
| \(L_t\) / `NL`, `L` | labor | (F2), (F17) |
| \(W_t/P_t\) / `NWP`, `WP` | real wage | (F2), (F17) |
| \(Y_t\) / `NY`, `Y` | final output | (F19), (F33) |
| \(MC_t\) / `NMC`, `MC` | real marginal cost | (F9), (F37) |
| \(\Pi_t\) / `NPI`, `PI` | headline inflation | (F7), (F36) |
| \(\Pi_{Y,t}\) / `NPIY`, `PIY` | core inflation | (F15), (F37) |
| \(\Delta_t\) / `DELTA` | price dispersion | (F16) |
| \(D_t\) / `DD` | Calvo denominator | (F13) |
| \(N_t\) / `NN` | Calvo numerator | (F14) |
| \(R_t\) / `NR`, `R` | policy rate | (F25), (F26), (F29) |
| \(Q_t\) / `NQ`, `Q` | real commodity price | (F22), (F23) |
| \(\mathfrak{M}_{Y,t}\) / `NOY`, `OY` | commodity input demand | (F18) |
| \(\mathfrak{M}_t\) / `NO`, `O` | dominant-exporter commodity supply/residual demand | (F20) |
| \(X_t\) / `NX`, `X` | competitive fringe supply | (F21) |
| \(\Psi_t\), \(\eta_t\) / `NETA`, `ETA` | commodity markup and demand elasticity | (F23), (F24) |
| \(y_t^n,\hat y_t^n\) / `Yn`, `Yn_gap` | natural output and gap | (F34) |
| \(y_t^e,\hat y_t^e\) / `Ye`, `Y_gap` | efficient output and gap | (F35) |
| \(r_t^n,r_t^e\) / `Rn`, `Re`, `Rfe` | natural/efficient rates | policy benchmark block |

### Exogenous shocks

| Symbol / MMB name | Meaning | Process |
|---|---|---|
| \(\varepsilon_t^z\) / `EZ` | commodity productivity/supply innovation | (F38) |
| \(\varepsilon_t^\omega\) / `EOMEGA` | competitive-fringe size innovation | (F39) |
| \(\varepsilon_t^a\) / `EA` | importer TFP innovation | (F40) |
| \(\varepsilon_t^g\) / `EG` | preference innovation | (F41) |
| \(\varepsilon_t^{err}\) / `EERR` | monetary policy innovation | (F42) |
| \(\varepsilon_t^{gg}\) / `EGG` | aggregate-demand/government-spending innovation | (F43) |

### Parameters

| Symbol / MMB name | Meaning |
|---|---|
| \(\beta\) / `BETA` | discount factor |
| \(\gamma\) / `GAMMA` | commodity share in consumption basket |
| \(\xi=1-\gamma\) / `XI` | final-goods share in the CPI aggregator |
| \(\alpha\) / `ALPHA` | commodity share in production |
| \(\nu\) / `NU` | inverse Frisch elasticity |
| \(\varepsilon\) / `EPS` | substitution elasticity across differentiated goods |
| \(\mu\) / `MU` | gross final-goods markup |
| \(\theta\) / `THETA` | Calvo non-reset probability |
| \(\kappa\) / `KAPPA` | linearized Phillips-curve slope in implementation |
| \(\varphi_{head},\varphi_{core},\varphi_{com},\varphi_y\) / `PHI_*` | policy-rule coefficients |
| \(\rho_z,\rho_\omega,\rho_a,\rho_g,\rho_{err},\rho_{gg}\) / `RHO_*` | shock persistence parameters |
| \(A,Z\) / `AS`, `ZS` | steady-state productivity normalizations |
| \(\Omega\) / `NOMEGAS` | steady-state fringe size |
| `PHI_BENCH`, `PHI_NAT`, `PHI_EFF` | switches for benchmark, natural, and efficient policy rules |
| `M1`, `M2`, `PHI_MISP_*` | signal-extraction/misdiagnosis weights and switches |
