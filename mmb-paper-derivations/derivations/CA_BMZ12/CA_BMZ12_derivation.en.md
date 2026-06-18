# CA_BMZ12 -- Derivation (Optimization Problems + First-Order Conditions)

> First-pass private archive draft for review. Formula status: `needs_review`; equations are extracted from MinerU Markdown and cross-checked against the Rep-MMB implementation only for coverage and naming, not as paper-side source evidence.

## 1. Model Overview

- **Model ID**: `CA_BMZ12`.
- **Source paper**: Bailliu, Jeannine; Zhang, Yahong; Meh, Cesaire A. (2012/2015), "Macroprudential rules and monetary policy when financial frictions matter," Bank of Canada Working Paper 2012-6 / *Economic Modelling*. DOI recorded in the MMB index as `10.1016/j.econmod.2015.06.012`.
- **Main source**: `raw/mmb_mineru/runs/ca_bmz12__macroprudential_rules_and_monetary_policy_when_financial_frictions_matte__aa2f7a66/full.md`; raw PDF path exists at `raw/mmb_papers/Macroprudential rules and monetary policy when financial frictions matter.pdf`.
- **Agents**: representative household, entrepreneurs with Bernanke-Gertler-Gilchrist financial frictions, capital producers, monopolistically competitive Calvo retailers, monetary authority, and a macroprudential authority/tool.
- **Experiment**: estimated Canadian DSGE model used to compare standard Taylor, augmented Taylor, macroprudential, and augmented macroprudential regimes under financial and technology shocks.
- **Model form**: nonlinear DSGE equations with Calvo pricing, financial accelerator, and exogenous shock processes. The available Rep-MMB file implements a nonlinear `model` block and uses first-order stochastic simulation; this derivation does not run Dynare.
- **First-pass status**: `needs_review`. The paper Markdown is mostly readable, but the Calvo stochastic discount factor, retailer FOC, and entrepreneurial net-worth wage term have OCR artifacts and should be checked against the PDF before promotion.

## 2. Optimization Problems

### 2.1 Household

The representative household chooses consumption, hours, and deposits to maximize expected utility:

\[
\max_{\{C_t,H_t,D_t\}} E_0 \sum_{t=0}^{\infty} \beta^t
\left(e_t \log C_t - \theta \frac{H_t^{1+\gamma}}{1+\gamma}\right)
\]

subject to the nominal-deposit budget constraint:

\[
C_t + \frac{D_t}{P_t}
= \frac{W_t}{P_t}H_t + \Pi_t + \frac{R_{t-1}^n D_{t-1}}{P_t}.
\]

### 2.2 Entrepreneurs

Entrepreneur \(j\) produces a homogeneous intermediate good using capital purchased in the previous period and composite labor:

\[
F(K_t^j,L_t^j)=\omega_t^j (K_t^j)^\alpha (z_t L_t^j)^{1-\alpha}.
\]

Composite labor combines household and entrepreneurial labor:

\[
L_t^j=(H_t^j)^{1-\Omega}(H_t^{ej})^\Omega.
\]

The balance-sheet constraint for capital purchased at the end of period \(t\) is:

\[
Q_t K_{t+1}^j = N_{t+1}^j + \frac{B_t^j}{P_t}.
\]

Financial frictions follow a costly-state-verification contract. The external finance premium is an increasing function of leverage and is shifted by a financial shock. In policy regimes with the macroprudential tool, it is also multiplied by \(\tau_t\).

### 2.3 Capital Producers

Capital producers transform final goods into installed capital with investment-specific efficiency \(x_t\) and quadratic installation costs. The period objective in the paper is:

\[
\Pi_t^k = E_t\left[
Q_t x_t I_t - I_t - \frac{\xi}{2}\left(\frac{I_t}{K_t}-\delta\right)^2 K_t
\right].
\]

### 2.4 Retailers

Monopolistically competitive retailers buy intermediate goods, differentiate them at no cost, and face CES final-good demand. Retailer \(j\) maximizes expected real profits while its price remains fixed under Calvo pricing:

\[
E_t \sum_{i=0}^{\infty} \nu^i \Delta_{i,t+i}
\left[
\left(\frac{P_{jt}}{P_{t+i}}\right)Y_{j,t+i}
- mc_{t+i}Y_{j,t+i}
\right].
\]

`needs_review`: the Markdown OCR for \(\Delta_{i,t+i}\) and the retailer FOC has malformed subscripts and should be PDF-checked before treating the exact recursive representation as final.

## 3. First-Order Conditions

- **(F1) Household Euler equation**:

\[
\frac{e_t}{C_t}\frac{1}{R_t^n}
= \beta E_t\left[\frac{e_{t+1}}{C_{t+1}}\frac{P_t}{P_{t+1}}\right].
\]

- **(F2) Household labor supply**:

\[
\frac{e_t}{C_t}\frac{W_t}{P_t} = \theta H_t^\gamma.
\]

- **(F3) Entrepreneur production function**:

\[
Y_t^W = F(K_t,L_t)=K_t^\alpha(z_t L_t)^{1-\alpha}.
\]

- **(F4) Labor aggregator**:

\[
L_t=(H_t)^{1-\Omega}(H_t^e)^\Omega.
\]

- **(F5) Household-labor demand condition**:

\[
(1-\Omega)F_{H_t}=\frac{W_t}{P_{W,t}}.
\]

- **(F6) Entrepreneurial-labor demand condition**:

\[
\Omega F_{H_t^e}=\frac{W_t^e}{P_{W,t}}.
\]

- **(F7) Entrepreneur balance sheet**:

\[
Q_tK_{t+1}=N_{t+1}+\frac{B_t}{P_t}.
\]

- **(F8) External finance premium definition**:

\[
s_t=\frac{E_tR_{t+1}^k}{E_t\left[R_t^n\frac{P_t}{P_{t+1}}\right]}.
\]

- **(F9) Leverage-based premium with financial shock**:

\[
s_t=f_t\,s\left(\frac{Q_tK_{t+1}}{N_{t+1}}\right).
\]

- **(F10) Capital-arbitrage condition**:

\[
E_tR_{t+1}^k=s_t R_t^n E_t\left[\frac{P_t}{P_{t+1}}\right].
\]

- **(F11) Expected gross return on capital**:

\[
E_tR_{t+1}^k
=E_t\left[
\frac{\frac{P_{t+1}^W}{P_{t+1}}F_K+Q_{t+1}(1-\delta)}{Q_t}
\right].
\]

- **(F12) Entrepreneur net worth** (`needs_review` for OCR in the wage-income term):

\[
\begin{aligned}
N_{t+1}
=&\ \eta\left[
R_t^k Q_{t-1}K_t
- E_{t-1}(R_t^k)(Q_{t-1}K_t-N_t)
\right] \\
&+ (1-\alpha)(1-\Omega)z_tK_t^\alpha L_t^{(1-\alpha)\Omega}.
\end{aligned}
\]

- **(F13) Net worth after substituting nominal-debt repayment** (`needs_review`):

\[
\begin{aligned}
N_{t+1}
=&\ \eta\left[
R_t^k Q_{t-1}K_t
- s_{t-1}R_{t-1}^n E_{t-1}\left(\frac{P_{t-1}}{P_t}\right)(Q_{t-1}K_t-N_t)
\right] \\
&+ (1-\alpha)(1-\Omega)z_tK_t^\alpha L_t^{(1-\alpha)\Omega}.
\end{aligned}
\]

- **(F14) Consumption of exiting entrepreneurs**:

\[
C_t^e=(1-\eta)\left[
R_t^kQ_{t-1}K_t
-E_{t-1}(R_t^k)(Q_{t-1}K_t-N_t)
\right].
\]

- **(F15) Capital accumulation**:

\[
K_{t+1}=x_tI_t+(1-\delta)K_t.
\]

- **(F16) Capital-producer FOC / Tobin's \(Q\)**:

\[
E_t\left[
Q_t x_t - 1 - \xi\left(\frac{I_t}{K_t}-\delta\right)
\right]=0.
\]

- **(F17) Final-good CES aggregator**:

\[
Y_t=\left[\int_0^1 Y_{jt}^{\frac{\varepsilon-1}{\varepsilon}}dj\right]^{\frac{\varepsilon}{\varepsilon-1}}.
\]

- **(F18) Final-good price index** (`needs_review`: Markdown uses \(dz\) where \(dj\) is expected):

\[
P_t=\left[\int_0^1 P_t(j)^{1-\varepsilon}dj\right]^{\frac{1}{1-\varepsilon}}.
\]

- **(F19) Retail-good demand**:

\[
Y_{jt}=\left(\frac{P_{jt}}{P_t}\right)^{-\varepsilon}Y_t.
\]

- **(F20) Optimal reset price** (`needs_review` for OCR around \(mc\), time subscripts, and discount factor):

\[
P_t^{\ast}=\left(\frac{\varepsilon}{\varepsilon-1}\right)
\frac{
E_t\sum_{i=0}^{\infty}\nu^i\Delta_{i,t+i}mc_{t+i}Y_{t+i}
\left(\frac{1}{P_{t+i}}\right)^{-\varepsilon}
}{
E_t\sum_{i=0}^{\infty}\nu^i\Delta_{i,t+i}Y_{t+i}
\left(\frac{1}{P_{t+i}}\right)^{1-\varepsilon}
}.
\]

- **(F21) Aggregate price index under Calvo adjustment**:

\[
P_t=\left[\nu P_{t-1}^{1-\varepsilon}+(1-\nu)(P_t^{\ast})^{1-\varepsilon}\right]^{\frac{1}{1-\varepsilon}}.
\]

## 4. Market Clearing & Identities

- **(F22) Basic final-goods resource constraint**:

\[
K_t^\alpha(z_tL_t)^{1-\alpha}
=C_t+C_t^e+I_t+\frac{\xi}{2}\left(\frac{I_t}{K_t}-\delta\right)^2K_t.
\]

- **(F23) Firm-level resource condition with price dispersion**:

\[
F(K_{jt},L_{jt})
=\left(C_t+C_t^e+I_t+\frac{\xi}{2}\left(\frac{I_t}{K_t}-\delta\right)^2K_t\right)
\left(\frac{P_{jt}}{P_t}\right)^{-\varepsilon}.
\]

- **(F24) Aggregate production/resource condition with dispersion**:

\[
F(K_t,L_t)
=\left(C_t+C_t^e+I_t+\frac{\xi}{2}\left(\frac{I_t}{K_t}-\delta\right)^2K_t\right)\Gamma_t.
\]

- **(F25) Price-dispersion law of motion** (`needs_review`: Markdown omits the price ratio inside the integral definition of \(\Gamma_t\)):

\[
\Gamma_t=(1-\nu)\left(\frac{P_t^{\ast}}{P_t}\right)^{-\varepsilon}
+\nu \pi_t^\varepsilon \Gamma_{t-1}.
\]

- **(F26) Deposit-debt clearing**:

\[
D_t=B_t.
\]

- **(F27) Nominal credit growth**:

\[
cg_t=\frac{B_t}{B_{t-1}}.
\]

- **(F28) Augmented Taylor rule**:

\[
\frac{R_t^n}{R^n}
=\left(\frac{R_{t-1}^n}{R^n}\right)^{\phi_R}
\left[
\left(\frac{\pi_t}{\pi}\right)^{\phi_\pi}
\left(\frac{Y_t}{Y}\right)^{\phi_Y}
\left(\frac{cg_t}{cg_{ss}}\right)^{\phi_c}
\right]^{1-\phi_R}
e^{\epsilon_t^m}.
\]

- **(F29) Standard Taylor rule**:

\[
\frac{R_t^n}{R^n}
=\left(\frac{R_{t-1}^n}{R^n}\right)^{\phi_R}
\left[
\left(\frac{\pi_t}{\pi}\right)^{\phi_\pi}
\left(\frac{Y_t}{Y}\right)^{\phi_Y}
\right]^{1-\phi_R}
e^{\epsilon_t^m}.
\]

- **(F30) Macroprudential premium rule**:

\[
s_t=f_t\,s\left(\frac{Q_tK_{t+1}}{N_{t+1}}\right)\tau_t.
\]

- **(F31) Macroprudential instrument**:

\[
\tau_t=\left(\frac{cg_t}{cg_{ss}}\right)^{\rho_\tau}.
\]

- **(F32) Price-level-targeting rule, optional regime in the paper**:

\[
\frac{R_t^n}{R^n}
=\left(\frac{R_{t-1}^n}{R^n}\right)^{\phi_R}
\left[
\left(\frac{P_t}{\overline{P}_t}\right)^{\phi_P}
\left(\frac{Y_t}{Y_{ss}}\right)^{\phi_Y}
\right]^{1-\phi_R}
e^{\epsilon_t^m}.
\]

## 5. Exogenous Processes

- **(F33) Preference shock**:

\[
\log e_t=\rho_e\log e_{t-1}+\epsilon_t^e,
\qquad \epsilon_t^e\sim i.i.d.\ N(0,\sigma_{\epsilon^e}^2).
\]

- **(F34) Technology shock**:

\[
\log z_t=\rho_z\log z_{t-1}+\epsilon_t^z,
\qquad \epsilon_t^z\sim i.i.d.\ N(0,\sigma_{\epsilon^z}^2).
\]

- **(F35) Financial shock**:

\[
\log f_t=\rho_f\log f_{t-1}+\epsilon_t^f,
\qquad \epsilon_t^f\sim i.i.d.\ N(0,\sigma_{\epsilon^f}^2).
\]

- **(F36) Investment-specific shock**:

\[
\log x_t=\rho_x\log x_{t-1}+\epsilon_t^x,
\qquad \epsilon_t^x\sim i.i.d.\ N(0,\sigma_{\epsilon^x}^2).
\]

- **(F37) Monetary policy shock**:

\[
\epsilon_t^m\sim i.i.d.\ N(0,\sigma_{\epsilon^m}).
\]

## 6. Steady-State Solution

The paper reports calibrated steady-state targets and estimated posterior modes rather than a complete closed-form steady-state derivation. A first-pass steady-state construction is:

1. Set deterministic shocks at their means: \(\bar e=\bar z=\bar x=\bar f=1\), innovations zero, and \(\bar \tau=1\) when \(cg_t=cg_{ss}\).
2. Use the household Euler equation:

\[
1=\beta R^n/\pi.
\]

3. Set steady-state gross inflation from calibration. The paper states annual \(\pi=1.02\); the Rep-MMB file uses a quarterly gross target `mub = 1.005`.
4. Use markup pricing to pin down steady-state marginal cost from the elasticity of substitution, adjusted for Calvo inflation terms in the implementation.
5. Use \(Q=1\) and the capital-return equation to solve the capital-labor ratio from:

\[
\bar R^k=\frac{\bar{mc}\,F_K+(1-\delta)}{\bar Q}.
\]

6. Use labor supply with the calibration target that households spend one-third of time working to pin down \(\theta\) or verify the chosen \(\theta=5.75\).
7. Use the net-worth-to-capital target \(N/K=0.6\), capital accumulation \(\bar I=\delta \bar K/\bar x\), and the resource constraint to solve \(\bar C\), \(\bar C^e\), \(\bar I\), and \(\bar Y\).
8. Use \(B=QK-N\) and \(cg_{ss}=1\) or the nominal-growth-adjusted implementation convention to initialize credit and macroprudential variables.

`needs_review`: the paper does not provide enough clean Markdown equations for a fully source-checked steady-state block. The Rep-MMB implementation contains a concrete steady-state calibration, but it is treated here as `implementation_cross_check` only.

## 7. Timing & Form Conventions

- Capital \(K_t\) is predetermined in production: entrepreneurs buy \(K_{t+1}\) at the end of period \(t\), while production at \(t\) uses capital purchased earlier. The Rep-MMB implementation uses `kt(-1)` in production and capital-return equations, consistent with this timing.
- Debt contracts are nominal. The real repayment burden depends on unexpected inflation through \(R_{t-1}^n P_{t-1}/P_t\).
- \(Q_t\) is the relative price of installed capital.
- \(s_t\) is the external finance premium; \(f_t\) is the financial shock; \(\tau_t\) is the macroprudential multiplier.
- Calvo price rigidity uses non-adjustment probability \(\nu\). Price dispersion \(\Gamma_t\) enters aggregate resource feasibility.
- Model form is nonlinear. The Rep-MMB cross-check uses a nonlinear Dynare `model` and first-order simulation, not a hand log-linear `model(linear)` block.
- Runtime validation was not performed.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII hint | Meaning | Main equation(s) |
|---|---|---|---|
| Endogenous | \(C_t\) / `ct` | Household consumption | (F1), (F22) |
| Endogenous | \(C_t^e\) / `ce` | Exiting entrepreneurs' consumption | (F14), (F22) |
| Endogenous | \(H_t\) / `ht` | Household labor hours | (F2), (F4), (F5) |
| Endogenous | \(H_t^e\) | Entrepreneurial labor | (F4), (F6) |
| Endogenous | \(L_t\) / `llt` | Composite labor / price-dispersion-adjusted labor block in implementation | (F4), (F24) |
| Endogenous | \(K_t\) / `kt` | Capital stock | (F7), (F15) |
| Endogenous | \(I_t\) / `it` | Investment | (F15), (F16), (F22) |
| Endogenous | \(Q_t\) / `qt` | Relative price of capital | (F7), (F11), (F16) |
| Endogenous | \(N_t\) / `nt` | Entrepreneur net worth | (F7), (F12), (F13) |
| Endogenous | \(B_t,D_t\) / `bt` | Entrepreneur debt and household deposits | (F7), (F26), (F27) |
| Endogenous | \(R_t^n\) / `rnt` | Nominal policy/deposit rate | (F1), (F28), (F29), (F32) |
| Endogenous | \(R_t^k\) / `rkt` | Gross return on capital | (F8), (F10), (F11) |
| Endogenous | \(s_t\) / `st` | External finance premium | (F8), (F9), (F30) |
| Endogenous | \(\tau_t\) / `taut` | Macroprudential multiplier | (F30), (F31) |
| Endogenous | \(cg_t\) / `cgn`, `cg` | Nominal credit growth | (F27), (F28), (F31) |
| Endogenous | \(Y_t\) / `yt` | Final output | (F17), (F22), (F24) |
| Endogenous | \(P_t,P_t^{\ast},\pi_t\) / `pit`, `pstart` | Aggregate price, reset price, inflation | (F18), (F20), (F21), (F25) |
| Endogenous | \(mc_t\) / `mct` | Real marginal cost | (F20), markup/return equations |
| Endogenous | \(\Gamma_t\) / `llt` in paper notation differs from implementation | Price dispersion | (F25) |
| Exogenous | \(e_t\) / `pref` | Preference shock | (F33) |
| Exogenous | \(z_t\) / `zt` | Technology shock | (F34) |
| Exogenous | \(f_t\) / `ft` | Financial shock | (F35) |
| Exogenous | \(x_t\) / `xt` | Investment-specific shock | (F36) |
| Exogenous | \(\epsilon_t^m\) / `epset` in implementation policy shock slot | Monetary-policy shock | (F37) |
| Parameter | \(\beta\) / `b` | Discount factor | (F1) |
| Parameter | \(\theta,\gamma\) / `te`, `g` | Utility labor weight and inverse labor-supply elasticity | (F2) |
| Parameter | \(\alpha\) / `a` | Capital share | (F3), (F11) |
| Parameter | \(\Omega\) | Entrepreneurial labor share in composite labor | (F4)-(F6) |
| Parameter | \(\eta\) / `eta` | Entrepreneur survival probability | (F12)-(F14) |
| Parameter | \(\delta\) / `d` | Depreciation rate | (F11), (F15), (F22) |
| Parameter | \(\xi\) / `xi` | Capital adjustment cost | (F16), (F22) |
| Parameter | \(\varepsilon\) / `veps` | Retail-good elasticity of substitution | (F17)-(F21) |
| Parameter | \(\nu\) / `nu` | Calvo non-adjustment probability | (F20), (F21), (F25) |
| Parameter | \(\phi_R,\phi_\pi,\phi_Y,\phi_c,\phi_P\) / `r_r`, `r_p`, `r_y`, `r_c` | Monetary-policy rule coefficients | (F28), (F29), (F32) |
| Parameter | \(\rho_\tau\) / `rhotau` | Macroprudential rule coefficient | (F31) |
| Parameter | \(\rho_e,\rho_z,\rho_f,\rho_x\) | Shock persistence | (F33)-(F36) |
