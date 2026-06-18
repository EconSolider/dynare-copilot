# G2_SIGMA08 -- Derivation (optimization problems + equilibrium conditions)

> Status: `needs_review`. This first-pass archive entry is source-backed by the MinerU Markdown for Erceg, Guerrieri, and Gust (2008). It records the paper's stated SIGMA structure and the Rep-MMB implementation coverage, but runtime validation was not performed.

## 1. Model Overview

- **Model**: `G2_SIGMA08`, "Trade adjustment and the composition of trade", Christopher J. Erceg, Luca Guerrieri, and Christopher J. Gust, *Journal of Economic Dynamics and Control* 32(8), 2622-2650, 2008, DOI `10.1016/j.jedc.2007.09.015`.
- **Purpose**: compare two open-economy trade specifications in SIGMA. The benchmark disaggregated-trade (DT) specification separates consumption- and investment-goods imports; the absorption-trade (AT) specification uses one private-absorption import aggregator.
- **Economies**: two-country DSGE model. The foreign economy mirrors the home economy except for size and foreign trade-share calibration.
- **Agents and blocks**: intermediate-goods firms with Calvo domestic and export prices, final consumption/investment distributors, forward-looking (FL) households, hand-to-mouth (HM) households, wage setters, fiscal authority, monetary authority, foreign-bond intermediation, and exogenous shock processes.
- **Form**: log-linearized model around a balanced-growth steady state. The Rep-MMB implementation cross-check uses `model(linear)`.
- **Main archive limitation**: the paper gives an abbreviated model description and points to Erceg et al. (2006) for the full SIGMA system. Equations not explicitly printed in the paper or visible in the implementation are marked `needs_review`.

## 2. Optimization Problems

### 2.1 Intermediate-Goods Firms

Intermediate-goods producers are monopolistic competitors. Each firm rents labor and capital in competitive factor markets and sells differentiated goods domestically and abroad. Domestic and export prices are set under Calvo contracts with lagged-inflation indexation for firms not allowed to reoptimize. Local currency pricing applies to export sales.

The production side is summarized in the source paper rather than fully written as firm-level optimization. The Rep-MMB implementation cross-check uses the linear production and marginal-cost block:

```math
(1-q_K)(\ell_t+a_t)=y_t-q_K k_{t-1},
```

with an analogous foreign equation. The underlying firm problem is therefore recorded as `needs_review` pending source-level verification of the full CES production/cost-minimization system from the companion SIGMA documentation.

### 2.2 Final Consumption and Investment Distributors: DT Specification

For each final use $`V_t \in \{C_t,I_t\}`$, a representative distributor chooses domestically produced input $`V_{Dt}`$ and imported input $`M_{Vt}`$ to minimize cost subject to the CES technology:

```math
\min_{\{V_{Dt},M_{Vt}\}} \; P_{Dt}V_{Dt}+P_{Mt}M_{Vt}
\quad\text{s.t.}\quad
V_t =
\left(
\omega_V^{\frac{\rho_V}{1+\rho_V}} V_{Dt}^{\frac{1}{1+\rho_V}}
+(1-\omega_V)^{\frac{\rho_V}{1+\rho_V}}
(\varphi_{Vt}M_{Vt})^{\frac{1}{1+\rho_V}}
\right)^{1+\rho_V}.
```

The import-adjustment term is quadratic in the import-to-domestic-input ratio relative to the lagged aggregate ratio:

```math
\varphi_{Vt} =
1-\frac{\varphi_{M_V}\omega_V}{2}
\left(
\frac{M_{Vt}/V_{Dt}}{M^A_{V,t-1}/V^A_{D,t-1}}-1
\right)^2 .
```

### 2.3 Final Absorption Distributor: AT Specification

In the AT variant, one private-absorption good $`A_t \equiv C_t+I_t`$ is produced from a domestic input $`A_{Dt}`$ and aggregate imports $`M_t`$:

```math
\min_{\{A_{Dt},M_t\}} \; P_{Dt}A_{Dt}+P_{Mt}M_t
\quad\text{s.t.}\quad
A_t =
\left(
\omega_A^{\frac{\rho_A}{1+\rho_A}} A_{Dt}^{\frac{1}{1+\rho_A}}
+(1-\omega_A)^{\frac{\rho_A}{1+\rho_A}}
(\varphi_{At}M_t)^{\frac{1}{1+\rho_A}}
\right)^{1+\rho_A},
```

where

```math
\varphi_{At} =
1-\frac{\varphi_{M_A}\omega_A}{2}
\left(
\frac{M_t/A_{Dt}}{M^A_{t-1}/A^A_{D,t-1}}-1
\right)^2 .
```

### 2.4 Forward-Looking Households

Each member of an FL household chooses consumption, labor, money balances, investment, capital, and financial assets. The paper states the per-member expected utility:

```math
\widetilde{E}_t \sum_{j=0}^{\infty}\beta^j
\left\{
\frac{(C_{t+j}(h)-\varkappa C^O_{t+j-1}-\nu_{c,t+j})^{1-\sigma}}{1-\sigma}
+\frac{\chi_0}{1-\chi}(1-N_{t+j}(h))^{1-\chi}
+\frac{\mu_0}{1-\mu}
\left(\frac{MB_{t+j+1}(h)}{P_{C,t+j}}\right)^{1-\mu}
\right\}.
```

Investment has an adjustment-cost wedge:

```math
\phi_{It}(h)=\frac{1}{2}\phi_I
\frac{(I_t(h)-I_{t-1}(h))^2}{I_{t-1}(h)}.
```

Capital evolves according to:

```math
K_{t+1}(h)=(1-\delta)K_t(h)+I_t(h).
```

The full intertemporal budget constraint is described in prose: households receive after-tax capital income, wage income, firm profits, and transfers; pay capital taxes net of depreciation writeoffs; hold domestic money, government bonds, state-contingent domestic bonds, and a non-state-contingent foreign bond subject to an intermediation cost. The complete paper-side budget equation is `needs_review`.

### 2.5 Hand-to-Mouth Households and Wage Setting

HM households consume current after-tax disposable labor income net of lump-sum taxes and set their wage equal to the average FL wage. Labor demand is common across household types.

Households are monopolistic competitors in the labor market. Wage setting follows Calvo contracts with lagged wage-inflation indexation for non-reoptimizing households. The full wage-reset objective and FOC are not printed in the source paper and are `needs_review`.

## 3. First-Order Conditions

The source paper prints selected structural equations rather than a complete FOC system. The equations below number the paper-extracted conditions and selected implementation-visible linear conditions continuously. Implementation-visible conditions are marked as `implementation_cross_check`.

- **(F1) DT final-goods aggregator**:

```math
V_t =
\left(
\omega_V^{\frac{\rho_V}{1+\rho_V}} V_{Dt}^{\frac{1}{1+\rho_V}}
+(1-\omega_V)^{\frac{\rho_V}{1+\rho_V}}
(\varphi_{Vt}M_{Vt})^{\frac{1}{1+\rho_V}}
\right)^{1+\rho_V}, \quad V\in\{C,I\}.
```

- **(F2) DT import-adjustment factor**:

```math
\varphi_{Vt} =
1-\frac{\varphi_{M_V}\omega_V}{2}
\left(
\frac{M_{Vt}/V_{Dt}}{M^A_{V,t-1}/V^A_{D,t-1}}-1
\right)^2 .
```

- **(F3) DT consumption-import demand, linearized implementation cross-check**:

```math
m^C_t = r^C_t + c_t .
```

- **(F4) DT investment-import demand, linearized implementation cross-check**:

```math
m^I_t = r^I_t+i_t .
```

- **(F5) DT aggregate imports, implementation cross-check**:

```math
s_M m_t=s_{MC}s_C m^C_t+s_{MI}s_I m^I_t .
```

- **(F6) AT final absorption aggregator**:

```math
A_t =
\left(
\omega_A^{\frac{\rho_A}{1+\rho_A}} A_{Dt}^{\frac{1}{1+\rho_A}}
+(1-\omega_A)^{\frac{\rho_A}{1+\rho_A}}
(\varphi_{At}M_t)^{\frac{1}{1+\rho_A}}
\right)^{1+\rho_A}.
```

- **(F7) AT import-adjustment factor**:

```math
\varphi_{At} =
1-\frac{\varphi_{M_A}\omega_A}{2}
\left(
\frac{M_t/A_{Dt}}{M^A_{t-1}/A^A_{D,t-1}}-1
\right)^2 .
```

- **(F8) AT import-demand ratio, paper log-linear equation**:

```math
\tilde{x}_t =
-\frac{\varepsilon_A}{1+\varepsilon_A\varphi_{M_A}}\tilde{\psi}_t
+\frac{\varepsilon_A\varphi_{M_A}}{1+\varepsilon_A\varphi_{M_A}}\tilde{x}_{t-1}.
```

- **(F9) AT aggregate import demand, paper log-linear equation**:

```math
\tilde{M}_t =
\tilde{A}_t
-\frac{\frac{\varepsilon_A}{1+\varepsilon_A\varphi_{M_A}}}
{1-\left(\frac{\varepsilon_A\varphi_{M_A}}{1+\varepsilon_A\varphi_{M_A}}\right)L}
\tilde{\psi}_t .
```

- **(F10) DT aggregate import demand, paper log-linear equation**:

```math
\tilde{M}_t =
\tilde{A}^{DT}_t
-\frac{\frac{\varepsilon_A}{1+\varepsilon_A\varphi_{M_A}}}
{1-\left(\frac{\varepsilon_A\varphi_{M_A}}{1+\varepsilon_A\varphi_{M_A}}\right)L}
\tilde{\psi}^{DT}_t .
```

- **(F11) DT activity measure**:

```math
\tilde{A}^{DT}_t =
\left(\frac{M_C}{M}\right)\tilde{C}_t
+\left(\frac{M_I}{M}\right)\tilde{I}_t .
```

- **(F12) AT activity measure**:

```math
\tilde{A}_t =
\left(\frac{C}{A}\right)\tilde{C}_t
+\left(\frac{I}{A}\right)\tilde{I}_t .
```

- **(F13) FL household Euler equation, implementation cross-check**:

```math
\lambda^C_t=\lambda^C_{t+1}+r^s_t-\Delta p^C_{t+1}+\varepsilon^\beta_t .
```

- **(F14) Habit-adjusted marginal utility, implementation cross-check**:

```math
\lambda^C_t =
-\sigma \frac{c^{FL}_t-(\varkappa/g_z)c^{FL}_{t-1}-\xi_C(\varepsilon^C_t+a_t)}
{1-\varkappa/g_z-\xi_C}.
```

- **(F15) Hand-to-mouth consumption rule, implementation cross-check**:

```math
c^{HM}_t =
-rp^C_t
+\Omega_y(\zeta^p_t+\ell_t-\tau^L_t-y_t)
+y_t+\Omega_T(tr_t-tax_t).
```

The exact coefficients $`\Omega_y`$ and $`\Omega_T`$ are composite calibration ratios in the Rep-MMB implementation; source-level verification is `needs_review`.

- **(F16) Tobin's Q / investment adjustment condition, implementation cross-check**:

```math
q_t =
rp^I_t+\phi_K\frac{\hat{\delta}}{1+n} (i_t-k_{t-1})
+\phi_I g_z(i_t-i_{t-1})
-\frac{g_z^2(1+n)}{1+\bar r}\phi_I(i_{t+1}-i_t).
```

- **(F17) Capital valuation equation, implementation cross-check**:

```math
q_t =
\frac{1-\delta}{1+\bar r}q_{t+1}
-\frac{r^s_t-\Delta p_{t+1}}{1+\bar r}
+\frac{\bar r+\delta-\bar{\delta}\tau_K}{1+\bar r}r^K_{t+1}
-\frac{\bar r+\delta-\bar{\delta}}{(1+\bar r)(1-\tau_K)}\tau^K_{t+1}
+\tau_K\bar{\delta}\,rp^I_{t+1}
+\frac{\phi_K\hat{\delta}^2}{(1+\bar r)(1+n)}(i_{t+1}-k_t).
```

- **(F18) Labor-market wedge and marginal rate of substitution, implementation cross-check**:

```math
wmark_t=mrs_t-\zeta^C_t+\frac{1}{1-\tau_L}\tau^L_t,
\qquad
mrs_t=\chi s_L\ell_t-\lambda^C_t .
```

- **(F19) Domestic-price Phillips curve, implementation cross-check**:

```math
\Delta p^Q_t =
\iota_p \Delta p^Q_{t-1}
+\frac{(1+n)g_z}{1+\bar r}\left(\Delta p^Q_{t+1}-\iota_p\Delta p^Q_t\right)
+\kappa_p mc^Q_t .
```

- **(F20) Export-price Phillips curve under local-currency pricing, implementation cross-check**:

```math
\Delta p^M_t =
\iota_m \Delta p^M_{t-1}
+\frac{(1+n)g_z}{1+\bar r}\left(\Delta p^M_{t+1}-\iota_m\Delta p^M_t\right)
+\kappa_x(mc^Q_t-rp^X_t).
```

- **(F21) Wage Phillips curve, implementation cross-check**:

```math
\Delta w_t =
\iota_w \Delta w_{t-1}
+\frac{(1+n)g_z}{1+\bar r}\left(\Delta w_{t+1}-\iota_w\Delta w_t\right)
+\kappa_w wmark_t .
```

- **(F22) Monetary policy rule, paper equation**:

```math
i_t =
\gamma_i i_{t-1}+\bar r+\bar{\pi}_t
+\gamma_{\pi}\left(\pi^{(4)}_t-\bar{\pi}\right)
+\gamma_y\left(y_t-y_{t-4}-g_y\right)
+\varepsilon^i_t .
```

## 4. Market Clearing & Identities

- **(F23) Domestic-good resource constraint, paper equation**:

```math
Y_{Dt}=C_{Dt}+I_{Dt}+G_t+\phi_{It}.
```

- **(F24) GDP identity, implementation cross-check**:

```math
y_t=s_C c_t+s_I i_t+s_G g_t+s_M(m^{\ast}_t-m_t).
```

- **(F25) Capital accumulation, implementation cross-check**:

```math
\left(1-\frac{1-\delta}{g_z(1+n)}\right)i_t
=k_t-\frac{1-\delta}{g_z(1+n)}k_{t-1}.
```

- **(F26) Production function and flexible-price output, implementation cross-check**:

```math
(1-q_K)(\ell_t+a_t)=y_t-q_K k_{t-1},
\qquad
y^{pot}_t=q_K k_{t-1}+(1-q_K)a_t .
```

- **(F27) Fisher real-rate identity, implementation cross-check**:

```math
r^{1}_t=r^s_t-\Delta p^Q_{t+1}.
```

- **(F28) Uncovered interest parity with stationarity premium, implementation cross-check**:

```math
e_t=e_{t+1}+r^s_{f,t}-r^s_t+risk_t-\phi_b nfa_t .
```

- **(F29) Net foreign assets, implementation cross-check**:

```math
nfa_t=\frac{1+\bar r}{g_z(1+n)}
\left[nfa_{t-1}+0.25\,s_M(rp^X_t+m^{\ast}_t-rp^M_t-m_t)\right].
```

- **(F30) Real exchange rates, implementation cross-check**:

```math
rer^C_t=e_t+p^C_{f,t}-p^C_t,
\qquad
rer^Q_t=e_t+p^Q_{f,t}-p^Q_t .
```

- **(F31) Government budget constraint, implementation cross-check**:

```math
b^G_t =
\frac{1+\bar r}{g_z(1+n)}b^G_{t-1}
+s_G(g_t-y_t)+tr_t-tax_t
-\tau_L s_L(\zeta^p_t+\ell_t-y_t)
-\tau_K q_K(k_{t-1}+r^K_t-y_t-\bar{\delta}rp^I_t/\bar r_K)
+\text{tax-wedge terms}.
```

The displayed budget condition is a compact linearized representation of the implementation. Full source-level fiscal accounting is `needs_review`.

## 5. Exogenous Processes

The paper and implementation include persistent home and foreign processes for technology, government spending, inflation target, consumption preference, capital tax, transfers, risk premium, discount factor, import demand, and labor tax wedges. The implementation splits several shocks into permanent and transitory components.

- **(F32) Home technology growth decomposition, implementation cross-check**:

```math
a_t=a_{t-1}+g^p_{A,t}+g^T_{A,t},
\qquad
g^p_{A,t}=\rho^p_A g^p_{A,t-1}+\varepsilon^p_{A,t},
\qquad
g^T_{A,t}=\rho^T_A g^T_{A,t-1}+\varepsilon^T_{A,t}.
```

- **(F33) Foreign technology growth decomposition, implementation cross-check**:

```math
a^{\ast}_t=a^{\ast}_{t-1}+g^{p,\ast}_{A,t}+g^{T,\ast}_{A,t},
\qquad
g^{p,\ast}_{A,t}=\rho^p_A g^{p,\ast}_{A,t-1}+\varepsilon^{p,\ast}_{A,t},
\qquad
g^{T,\ast}_{A,t}=\rho^T_A g^{T,\ast}_{A,t-1}+\varepsilon^{T,\ast}_{A,t}.
```

- **(F34) Government spending rule, implementation cross-check**:

```math
g_t=\mathbb{1}_{switch} y_t+g^p_t+g^T_t,
\qquad
g^p_t=\rho^p_G g^p_{t-1}+\varepsilon^p_{G,t}/s_G,
\qquad
g^T_t=\rho^T_G g^T_{t-1}+\varepsilon^T_{G,t}/s_G .
```

- **(F35) Inflation target process, implementation cross-check**:

```math
\pi^{tar}_t=\pi^{tar,p}_t+\pi^{tar,T}_t,
\qquad
\pi^{tar,p}_t=\rho^p_\pi\pi^{tar,p}_{t-1}+\varepsilon^p_{\pi,t},
\qquad
\pi^{tar,T}_t=\rho^T_\pi\pi^{tar,T}_{t-1}+\varepsilon^T_{\pi,t}.
```

- **(F36) Consumption preference shocks, implementation cross-check**:

```math
\nu^C_t=\nu^{C,p}_t+\nu^{C,T}_t,
\qquad
\nu^{C,p}_t=\rho^p_C\nu^{C,p}_{t-1}+\varepsilon^p_{C,t}/\xi_C,
\qquad
\nu^{C,T}_t=\rho^T_C\nu^{C,T}_{t-1}+\varepsilon^T_{C,t}/\xi_C .
```

- **(F37) Capital-tax shocks, implementation cross-check**:

```math
\tau^K_t=\tau^{K,p}_t+\tau^{K,T}_t,
\qquad
\tau^{K,T}_t=\rho^T_K\tau^{K,T}_{t-1}-5.5\,\varepsilon^T_{K,t}.
```

The persistent capital-tax process contains an implementation switch with additional lags; source-level interpretation is `needs_review`.

- **(F38) Risk-premium shock, implementation cross-check**:

```math
risk_t=risk^p_t+risk^T_t,
\qquad
risk^p_t=\rho^p_R risk^p_{t-1}+(1-\rho^p_R)(10/6)14.5\,\varepsilon^p_{R,t},
\qquad
risk^T_t=\rho^T_R risk^T_{t-1}+\varepsilon^T_{R,t}.
```

- **(F39) Discount-factor and import-demand shocks, implementation cross-check**:

```math
\varepsilon^\beta_t=\rho_\beta\varepsilon^\beta_{t-1}-u^\beta_t,
\qquad
imp_t=\rho_M imp_{t-1}+u^M_t .
```

- **(F40) Labor-tax wedge process, implementation cross-check**:

```math
\tau^L_t=\rho_L\tau^L_{t-1}+\phi_{d3}b^G_t+\phi_{d4}(b^G_t-b^G_{t-1})
-u^L_t/s_L .
```

Foreign analogues of (F34)-(F40) are present in the Rep-MMB implementation for the corresponding foreign shocks.

## 6. Steady-State Solution

The paper states that the model is solved after transforming real variables by deterministic technology growth and nominal variables by the corresponding growth and steady-state inflation trends. The reduced-form solution is obtained by log-linearizing around the steady state associated with common technology growth in the two countries.

For the first-pass archive, the steady-state structure is:

1. Set common deterministic technology growth $`g_z=1.0037`$ and population growth $`n=0.0025`$.
2. Set calibration targets: $`s_I=0.25`$, $`s_G=0.18`$, aggregate import share $`s_M=0.12`$, $`\omega_C=0.052`$, $`\omega_I=0.36`$, foreign $`\omega^{\ast}_C=0.01`$, foreign $`\omega^{\ast}_I=0.07`$, $`\delta=0.025`$, $`\beta=0.997`$, $`\tau_K=0.30`$.
3. Compute the steady real interest rate as in the implementation:

```math
\bar r=\frac{g_z^\sigma}{\beta}-1.
```

4. Compute the steady rental return on capital:

```math
\bar r_K=\frac{\bar r+\delta-\tau_K\bar{\delta}}{1-\tau_K}.
```

5. Compute the import shares and final-use shares:

```math
s_C=1-s_I-s_G,\qquad
s_M=s_{MC}s_C+s_{MI}s_I.
```

6. For the log-linear implementation, all transformed variables are expressed as deviations from steady state, so the model variables have zero steady-state values in `model(linear)`.

Full nonlinear steady-state accounting, including all tax, debt, wage, money, and foreign-asset levels, is `needs_review` because the paper does not print the full SIGMA steady-state system.

## 7. Timing & Form Conventions

- **Form**: `model(linear)` in the Rep-MMB implementation. Equations are log deviations or linearized ratios around a balanced-growth steady state after detrending.
- **Capital timing**: implementation equations use $`k_{t-1}`$ in production and capital-return equations; $`k_t`$ is the end-of-period stock chosen by current investment.
- **Growth adjustment**: capital accumulation and discounting terms include $`g_z(1+n)`$, matching deterministic technology and population growth.
- **Price and wage inflation**: domestic price inflation, consumption price inflation, export/import price inflation, and wage inflation are separate linear variables with lag-indexation.
- **Foreign assets**: net foreign assets are stationary because the UIP condition includes an intermediation/stationarity premium.
- **Local currency pricing**: export-price Phillips curves use relative export prices, consistent with local-currency pricing in the paper.
- **Runtime validation**: not performed. No Dynare execution, residual check, or BK check was run for this archive entry.

## 8. Variable & Parameter Reference Table

### Endogenous Variables

| Category | Symbol | Meaning | Mainly tied to |
|---|---|---|---|
| Endogenous | $`c_t,c^{FL}_t,c^{HM}_t`$ | aggregate, forward-looking, and hand-to-mouth consumption | (F13)-(F15), (F24) |
| Endogenous | $`i_t,q_t,k_t,k_{t-1}`$ | investment, Tobin's Q, capital stock | (F16), (F17), (F25), (F26) |
| Endogenous | $`\ell_t,wmark_t,mrs_t`$ | labor, wage markup, marginal rate of substitution | (F18), (F21), (F26) |
| Endogenous | $`y_t,y^{pot}_t,gap_t`$ | output, potential output, output gap | (F24), (F26) |
| Endogenous | $`m^C_t,m^I_t,m_t`$ | consumption, investment, and total imports | (F3)-(F5), (F8)-(F12) |
| Endogenous | $`m^{\ast}_t`$ | foreign imports / home exports | Foreign analogues of (F3)-(F12), (F24) |
| Endogenous | $`\Delta p^Q_t,\Delta p^C_t,\Delta p^M_t,\Delta w_t`$ | domestic, consumption, import/export, and wage inflation | (F19)-(F21), (F27) |
| Endogenous | $`r^s_t,r^1_t,i_t`$ | policy rate and real short rate | (F22), (F27) |
| Endogenous | $`e_t,rer^C_t,rer^Q_t,nfa_t`$ | nominal exchange rate, real exchange rates, net foreign assets | (F28)-(F30) |
| Endogenous | $`b^G_t,tax_t,tr_t`$ | government debt, taxes, transfers | (F31), (F34), (F40) |
| Endogenous | $`a_t,g^p_{A,t},g^T_{A,t}`$ | technology level and growth shocks | (F32) |
| Endogenous | Foreign starred analogues | foreign economy variables | (F33) and foreign analogues |

### Exogenous Shocks

| Symbol / implementation name | Meaning |
|---|---|
| `erratp`, `erratt`, `erratpf`, `errattf` | home and foreign permanent/transitory technology innovations |
| `errgcxp`, `fiscal_`, `errgcxpf`, `errgcxtf` | home and foreign government-spending innovations |
| `errpitarp`, `errpitart`, `errpitarpf`, `errpitartf` | home and foreign inflation-target innovations |
| `errconshkp`, `errconshkt`, `errconshkpf`, `errconshktf` | consumption preference innovations |
| `errtaxkp`, `errtaxkt`, `errtaxkpf`, `errtaxktf` | capital-tax innovations, including investment-demand experiments |
| `errtranshkp`, `errtranshkt`, `errtranshkpf`, `errtranshktf` | transfer innovations |
| `errriskpp`, `errriskpt` | risk-premium innovations |
| `errbetashk`, `errbetashkf` | discount-factor innovations |
| `errimpshk`, `errimpshkf` | import-demand innovations |
| `errtaxlshk`, `errtaxlshkpf`, `errtaxlshktf` | labor-tax wedge innovations |
| `interest_`, `fiscal_` | MMB-facing monetary and fiscal shock aliases |

### Parameters

| Parameter | Meaning / calibration cue |
|---|---|
| $`\beta=0.997`$ | discount factor |
| $`\sigma=2`$ | inverse intertemporal elasticity |
| $`\varkappa=0.8`$ | external habit persistence |
| $`\varsigma=0.5`$ | share of FL households in paper notation; implementation uses `popkey` for HM share |
| $`\chi=10`$ | labor supply curvature |
| $`\phi_I=3`$ | investment adjustment cost |
| $`\phi_b=0.001`$ | foreign-bond intermediation cost |
| $`g_z=1.0037`$, $`n=0.0025`$ | technology and population growth |
| $`\delta=0.025`$ | depreciation |
| $`\theta_p=0.20`$, $`\theta_w=0.20`$ | price and wage markup parameters in paper table |
| $`\xi_p=0.75`$, $`\xi_w=0.75`$, $`\xi_{p,x}=0.5`$ | Calvo domestic price, wage, and export-price stickiness |
| $`\tau_K=0.30`$, $`\tau_L=0.20`$ | capital and labor tax rates |
| $`\gamma_\pi=0.6`$, $`\gamma_y=0.28`$, $`\gamma_i=0.8`$ | monetary-rule coefficients |
| $`s_I=0.25`$, $`s_G=0.18`$, $`s_M=0.12`$ | investment, government, and import shares |
| $`\omega_A=0.15`$, $`\rho_A=2`$, $`\varphi_{M_A}=10`$ | AT trade parameters |
| $`\omega_C=0.052`$, $`\omega_I=0.36`$, $`\rho_C=\rho_I=2`$, $`\varphi_{M_C}=\varphi_{M_I}=10`$ | DT trade parameters |
| $`\omega_C^{\ast}=0.01`$, $`\omega_I^{\ast}=0.07`$ | foreign DT import-share calibration |
