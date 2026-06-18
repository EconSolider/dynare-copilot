# NK_CDK24 - Energy Prices and Household Heterogeneity: Monetary Policy in a Gas-TANK

> Model archive derivation for `NK_CDK24`. Source: Chan, Diz, and Kanngiesser (2024), "Energy prices and household heterogeneity: Monetary policy in a Gas-TANK", Journal of Monetary Economics, DOI `10.1016/j.jmoneco.2024.103620`. Primary extraction source: `raw/mmb_mineru/runs/nk_cdk24__energy_prices_and_household_heterogeneity_monetary_policy_in_a_gas_tank__9fe20b52/full.md`.
>
> Status: `needs_review`. MinerU OCR uses placeholder glyphs in several household-share and multiplier passages; equations below preserve the paper-side structure and mark uncertain items explicitly.

## 1. Model Overview

- **Model**: Small open-economy two-agent New Keynesian model with imported energy in production, labeled Gas-TANK.
- **Experiment**: Energy price, TFP, and markup shocks under Taylor-rule policy; the paper also studies Ramsey policy, but this derivation records the private-sector equilibrium and the baseline Taylor rule.
- **Agents and sectors**: Unconstrained households, constrained hand-to-mouth households, final good packers, monopolistically competitive final good producers, labor unions with sticky wages, energy importers, exporters/retailers, and a monetary authority.
- **Model form**: Log-linear summary around a steady state, with nonlinear source equations for household budgets, production, pricing, imports, exports, and policy. Implementation form should be treated as linear/log-deviation unless a later source-level reconstruction of the full nonlinear Ramsey system is performed.
- **Key mechanism**: Imported energy and labor are imperfect substitutes. When energy and labor are complements, higher imported energy prices reduce the labor share and raise the consumption gap between unconstrained and constrained households, creating a direct demand contraction.

## 2. Optimization Problems

### 2.1 Unconstrained Households

A fraction $`1-\omega`$ of households has access to domestic and foreign bonds and receives labor income plus firm and labor-union dividends. They choose consumption, labor, and bond holdings:

```math
\max_{\{C_{u,t},N^h_{u,t},B_{u,t},B^{\ast}_{u,t}\}}
E_0\sum_{t=0}^{\infty}\beta^t
\left[
\frac{C_{u,t}^{1-\sigma}-1}{1-\sigma}
-\chi\frac{(N^h_{u,t})^{1+\varphi}}{1+\varphi}
\right]
```

subject to the nominal budget constraint:

```math
W_t^h N^h_{u,t}+R_{t-1}B_{u,t-1}+\mathcal{E}_t\bar R^{\ast}B^{\ast}_{u,t-1}
+DIV^F_{u,t}+DIV^L_{u,t}
=P_tC_{u,t}+B_{u,t}+\mathcal{E}_tB^{\ast}_{u,t}+T_{u,t}+P_t\mathcal{T}_u.
\tag{F1}
```

### 2.2 Constrained Households

A fraction $`\omega`$ of households is hand-to-mouth. They receive labor income and labor-union dividends but do not trade bonds:

```math
P_tC_{c,t}=W_t^hN^h_{c,t}+DIV^L_{c,t}-T_{c,t}+P_t\mathcal{T}_c.
\tag{F2}
```

The paper assumes equal labor allocation across household types:

```math
N^h_{u,t}=N^h_{c,t}.
\tag{F3}
```

### 2.3 Final Good Packers

Competitive packers aggregate differentiated varieties into the final good:

```math
Z_t=\left(\int_0^1 Z_t(i)^{\frac{\epsilon_z-1}{\epsilon_z}}\,di\right)^{\frac{\epsilon_z}{\epsilon_z-1}},
\qquad
P_t=\left(\int_0^1 P_t(i)^{1-\epsilon_z}\,di\right)^{\frac{1}{1-\epsilon_z}}.
\tag{F4}
```

Cost minimization yields variety demand:

```math
Z_t(i)=\left(\frac{P_t(i)}{P_t}\right)^{-\epsilon_z}Z_t.
\tag{F5}
```

### 2.4 Final Good Producers

Each monopolistically competitive producer uses labor and imported energy:

```math
Z_t(i)=\varepsilon_t^{TFP}
\left[
(1-\alpha_{ez})^{\frac{1}{\psi_{ez}}}N_t(i)^{\frac{\psi_{ez}-1}{\psi_{ez}}}
+\alpha_{ez}^{\frac{1}{\psi_{ez}}}E_t^z(i)^{\frac{\psi_{ez}-1}{\psi_{ez}}}
\right]^{\frac{\psi_{ez}}{\psi_{ez}-1}}.
\tag{F6}
```

They minimize input costs taking the wage $`W_t`$, domestic energy price $`P_t^E`$, and marginal cost $`MC_t^Z`$ as given. The OCR labels the production wedge as $`\tau_t^Z=\tau^Z\varepsilon_t^{\mathcal M_z}`$; this entry keeps that notation but marks it `needs_review`.

### 2.5 Calvo Price Setters

With probability $`1-\phi_z`$, a final good producer resets its price $`P_t^\#`$. It solves:

```math
\max_{P_t^\#} E_t\sum_{s=0}^{\infty}\phi_z^s
\left\{\Lambda_{u,t,t+s}\left(P_t^\#Z_{t+s|t}-MC_{t+s}^ZZ_{t+s|t}\right)\right\}
\quad\text{s.t.}\quad
Z_{t+s|t}=\left(\frac{P_t^\#}{P_{t+s}}\right)^{-\epsilon_z}Z_{t+s}.
\tag{F7}
```

### 2.6 Energy Importers, Export Demand, and Retailers

Energy importers buy the foreign energy good at $`P_t^{E,\ast}`$ and sell it domestically. Export demand for domestic non-energy goods depends on the foreign-currency price of domestic goods. Retailers convert final goods into domestic consumption and export goods without adding an optimization wedge in the extracted model summary.

## 3. First-Order Conditions

**(F8) Unconstrained household Euler equation**:

```math
1=E_t\left[\Lambda_{u,t,t+1}\frac{R_t}{\Pi_{t+1}}\right],
\qquad
\Lambda_{u,t,t+1}=\beta\left(\frac{C_{u,t}}{C_{u,t+1}}\right)^\sigma.
\tag{F8}
```

**(F9) Aggregate log-linear consumption Euler equation**:

```math
\hat c_t=E_t[\hat c_{t+1}]+E_t[\omega\Delta\hat\gamma_{t+1}]
-\frac{1}{\sigma}\left(\hat r_t-E_t[\hat\pi_{t+1}]\right).
\tag{F9}
```

**(F10) Consumption gap and aggregate consumption**:

```math
\hat\gamma_t\equiv\hat c_{u,t}-\hat c_{c,t},
\qquad
\hat c_t=\omega\hat c_{c,t}+(1-\omega)\hat c_{u,t}.
\tag{F10}
```

**(F11) Labor and energy factor demand from cost minimization**:

```math
W_t=(1-\alpha_{ez})^{\frac{1}{\psi_{ez}}}
\frac{MC_t^Z}{\tau_t^Z}
\left(\frac{Z_t(i)}{N_t(i)}\right)^{\frac{1}{\psi_{ez}}}
\left(\varepsilon_t^{TFP}\right)^{\frac{\psi_{ez}-1}{\psi_{ez}}},
\quad
P_t^E=\alpha_{ez}^{\frac{1}{\psi_{ez}}}
\frac{MC_t^Z}{\tau_t^Z}
\left(\frac{Z_t(i)}{E_t^z(i)}\right)^{\frac{1}{\psi_{ez}}}
\left(\varepsilon_t^{TFP}\right)^{\frac{\psi_{ez}-1}{\psi_{ez}}}.
\tag{F11}
```

`needs_review`: the paper/OCR notation around $`\tau_t^Z`$ and the marginal-cost multiplier is noisy, but the factor-demand structure is clear.

**(F12) Calvo optimal price condition**:

```math
E_t\sum_{s=0}^{\infty}\phi_z^s
\left\{
\Lambda_{u,t,t+s}Z_{t+s|t}
\left(P_t^\#-\mathcal{M}_zMC_{t+s|t}^Z\right)
\right\}=0,
\qquad
\mathcal{M}_z=\frac{\epsilon_z}{\epsilon_z-1}.
\tag{F12}
```

**(F13) Sticky wage Phillips curve**:

```math
\hat\pi_t^W=
\frac{(1-\phi_w\beta)(1-\phi_w)}{\phi_w}
\left(\hat w_t^h-\hat w_t\right)
+\beta E_t[\hat\pi_{t+1}^W],
\qquad
\hat\pi_t^W=\hat w_t-\hat w_{t-1}+\hat\pi_t.
\tag{F13}
```

**(F14) Sticky price Phillips curve**:

```math
\hat\pi_t=
\frac{(1-\phi_z\beta)(1-\phi_z)}{\phi_z}\hat{mc}_t^Z
+\beta E_t[\hat\pi_{t+1}].
\tag{F14}
```

**(F15) Log-linear marginal cost, labor demand side**:

```math
\hat{mc}_t^Z=\hat w_t+\hat\varepsilon_t^{\mathcal M_z}
-\psi_{ez}^{-1}\left(\alpha_{ez}\hat e_t^z-\alpha_{ez}\hat n_t\right)
-\hat\varepsilon_t^{TFP}.
\tag{F15}
```

**(F16) Log-linear marginal cost, energy demand side**:

```math
\hat{mc}_t^Z=\hat p_t^E+\hat\varepsilon_t^{\mathcal M_z}
-\psi_{ez}^{-1}\left((1-\alpha_{ez})\hat n_t-(1-\alpha_{ez})\hat e_t^z\right)
-\hat\varepsilon_t^{TFP}.
\tag{F16}
```

## 4. Market Clearing & Identities

**(F17) Aggregate consumption and consumption gap in levels**:

```math
C_t=(1-\omega)C_{u,t}+\omega C_{c,t},
\qquad
\Gamma_t\equiv\frac{C_{u,t}}{C_{c,t}}.
\tag{F17}
```

**(F18) Imported energy law of one price**:

```math
p_t^E=Q_tp_t^{E,\ast}.
\tag{F18}
```

**(F19) Export demand**:

```math
X_t=\kappa^{\ast}
\left(\frac{P_t^{EXP}}{P_{ss}^{X\ast}}\right)^{-\zeta^{\ast}}
Y_{ss}^{\ast}.
\tag{F19}
```

**(F20) Log-linear goods market clearing and production identity**:

```math
\hat c_t=\frac{Z_{ss}}{C_{ss}}\hat z_t-\frac{X_{ss}}{C_{ss}}\hat x_t,
\qquad
\hat z_t=\hat\varepsilon_t^{TFP}+(1-\alpha_{ez})\hat n_t+\alpha_{ez}\hat e_t^z.
\tag{F20}
```

**(F21) Export, domestic energy price, and UIP identities**:

```math
\hat x_t=\zeta^{\ast}\hat q_t,\qquad
\hat p_t^E=\hat p_t^{E,\ast}+\hat q_t,\qquad
\hat q_t=E_t[\hat q_{t+1}]-\left(\hat r_t-E_t[\hat\pi_{t+1}]\right).
\tag{F21}
```

**(F22) Taylor rule**:

```math
\hat r_t=\theta_R\hat r_{t-1}
+(1-\theta_R)\left[
\frac{\theta_\pi}{4}\hat\pi_t^{CPI,a}
+\theta_Y(\hat n_t-\hat n_t^{flex})
\right],
\qquad
\hat\pi_t^{CPI,a}\equiv\sum_{j=0}^{3}\hat\pi_{t-j}^{CPI},
\qquad
\hat\pi_t^{CPI}=\hat\pi_t.
\tag{F22}
```

**(F23) Dynamic IS channel decomposition**:

```math
\hat n_t=
-\frac{1}{\sigma}\frac{C_{ss}}{Z_{ss}}E_t\sum_{k=0}^{\infty}
\left(\hat r_{t+k}-\hat\pi_{t+k+1}\right)
-\omega\frac{C_{ss}}{Z_{ss}}\hat\gamma_t
+\psi_{ez}\alpha_{ez}(\hat p_t^E-\hat w_t)
+\frac{X_{ss}}{Z_{ss}}\zeta^{\ast}\hat q_t
-\hat\varepsilon_t^{TFP}.
\tag{F23}
```

**(F24) Consumption-gap decomposition**:

```math
\Gamma_t=\Gamma_t^{inc}
+\frac{\mathcal E_t(\bar R^{\ast}-1)B^{\ast}_{u,t-1}-\mathcal E_t\Delta B^{\ast}_{u,t}}
{INC_{c,t}}.
\tag{F24}
```

**(F25) Consumption gap using trade balance**:

```math
\Gamma_t=\Gamma_t^{inc}
-\frac{1}{1-\omega}\frac{TB_t}{INC_{c,t}},
\qquad
TB_t=P_t^XX_t-P_t^EE_t^z.
\tag{F25}
```

**(F26) Consumption gap by income gap and borrowing terms**:

```math
\Gamma_t=
1+\frac{1}{1-\omega}\frac{\mathcal M_t^Z-1}{\Xi_t^N}
+\frac{1}{1-\omega}
\left(
\frac{1}{\Xi_t^N}-1-\frac{P_t^XX_t}{INC_{c,t}}
\right),
\qquad
\frac{\partial\Gamma_t}{\partial\mathcal M_t^Z}>0,\quad
\frac{\partial\Gamma_t}{\partial\Xi_t^N}<0.
\tag{F26}
```

**(F27) Markup and labor-share identities**:

```math
\mathcal M_t^Z=
\frac{\varepsilon_t^{TFP}P_t}
{\left((1-\alpha_{ez})W_t^{1-\psi_{ez}}
+\alpha_{ez}(P_t^E)^{1-\psi_{ez}}\right)^{\frac{1}{1-\psi_{ez}}}},
\qquad
\Xi_t^N=
\left[
1+\frac{\alpha_{ez}}{1-\alpha_{ez}}
\left(\frac{P_t^E}{W_t}\right)^{1-\psi_{ez}}
\right]^{-1}.
\tag{F27}
```

## 5. Exogenous Processes

**(F28) TFP shock**:

```math
\log\varepsilon_t^{TFP}
=\rho_{TFP}\log\varepsilon_{t-1}^{TFP}
-\varsigma_{TFP}\eta_t^{TFP},
\qquad
\eta_t^{TFP}\sim N(0,1).
\tag{F28}
```

**(F29) Price-markup shock**:

```math
\log\varepsilon_t^{\mathcal M_z}
=\rho_{\mathcal M_z}\log\varepsilon_{t-1}^{\mathcal M_z}
-\varsigma_{\mathcal M_z}\eta_t^{\mathcal M_z},
\qquad
\eta_t^{\mathcal M_z}\sim N(0,1).
\tag{F29}
```

**(F30) Energy price shock**:

```math
\log\varepsilon_t^E=\varsigma_E\eta_t^E,
\qquad
\eta_t^E\sim N(0,1).
\tag{F30}
```

**(F31) Foreign energy price level**:

```math
p_t^{E,\ast}=(p_{ss}^{E,\ast})^{1-\rho_E}(p_{t-1}^{E,\ast})^{\rho_E}\varepsilon_t^E.
\tag{F31}
```

## 6. Steady-State Solution

The archive entry does not run a Dynare steady-state validation. For the log-linear block, all hatted variables are deviations from steady state:

```math
\hat x_t=\log(X_t/X_{ss}) \quad \text{for positive level variables,}
\qquad
\hat r_t,\hat\pi_t,\hat q_t,\hat\gamma_t
\text{ are steady-state deviations as defined in the paper.}
\tag{F32}
```

Baseline calibration targets reported in the paper include:

```math
\beta=0.9994,\quad
\epsilon_z=\epsilon_w=11,\quad
\phi_z=0.66,\quad
\phi_w=0.92,\quad
\theta_\pi=1.5,\quad
\theta_Y=0.125,\quad
\theta_R=0.9,
\tag{F33}
```

```math
\rho_{TFP}=0.93,\quad
\varsigma_{TFP}=0.07,\quad
\rho_E=0.8,\quad
\varsigma_E=1,\quad
\rho_{\mathcal M_z}\approx0.9,\quad
\varsigma_{\mathcal M_z}=0.1,
\tag{F34}
```

```math
\omega=0.25,\quad
\psi_{ez}=0.15,\quad
\alpha_{ez}=0.05,\quad
\zeta^{\ast}=0.35.
\tag{F35}
```

`needs_review`: the source Markdown says the appendix contains the full key-parameter table, but the appendix table is not present in the extracted Markdown. A future pass should recover the supplementary data or inspect the PDF appendix if required.

## 7. Timing & Form Conventions

- **Linearization**: The operative summary equations are log-linear in hatted variables. The nonlinear household, production, import, export, and Calvo equations document the source equilibrium behind the linear block.
- **Interest rates and inflation**: The Euler equation uses $`R_t/\Pi_{t+1}`$, and the log-linear Euler equation uses the expected real rate $`\hat r_t-E_t[\hat\pi_{t+1}]`$.
- **Open-economy timing**: The real exchange rate is forward-looking through UIP, $`\hat q_t=E_t[\hat q_{t+1}]-(\hat r_t-E_t[\hat\pi_{t+1}])`$.
- **Households**: Constrained households consume current disposable labor income; unconstrained households can smooth through domestic and foreign bonds.
- **No capital stock in baseline extracted block**: Production uses labor and imported energy. There is no physical capital accumulation equation in the baseline paper-side model block.
- **Runtime validation**: Not performed. No `.mod` cross-check file was present at `.agents/skills/dynare-copilot/references/examples/NK_CDK24_rep.mod`.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII name | Meaning | Main equation(s) |
|---|---|---|---|
| Endogenous | $`C_{u,t}`$ / `c_u` | Unconstrained consumption | (F1), (F8), (F10), (F17) |
| Endogenous | $`C_{c,t}`$ / `c_c` | Constrained consumption | (F2), (F10), (F17) |
| Endogenous | $`C_t`$ / `c` | Aggregate consumption | (F9), (F10), (F17), (F20) |
| Endogenous | $`\Gamma_t,\hat\gamma_t`$ / `gamma_gap` | Consumption gap | (F10), (F17), (F24)-(F26) |
| Endogenous | $`N_t,N^h_{j,t}`$ / `n` | Labor/employment | (F3), (F6), (F11), (F20), (F22), (F23) |
| Endogenous | $`W_t,W_t^h`$ / `w`, `w_h` | Producer wage and household wage | (F1)-(F3), (F11), (F13), (F15), (F27) |
| Endogenous | $`Z_t`$ / `z` | Final output | (F4)-(F6), (F20), (F23) |
| Endogenous | $`E_t^z`$ / `e_z` | Imported energy input | (F6), (F11), (F16), (F20), (F25) |
| Endogenous | $`MC_t^Z,\hat{mc}_t^Z`$ / `mc_z` | Marginal cost | (F7), (F11), (F12), (F14)-(F16) |
| Endogenous | $`\mathcal M_t^Z`$ / `markup_z` | Average final-good markup | (F26), (F27) |
| Endogenous | $`\Xi_t^N`$ / `labor_share` | Labor share of firm expenditure | (F26), (F27) |
| Endogenous | $`P_t^E,p_t^E`$ / `p_e` | Domestic energy price | (F11), (F18), (F21), (F27) |
| Endogenous | $`Q_t,\hat q_t`$ / `q` | Real exchange rate | (F18), (F21), (F23) |
| Endogenous | $`X_t,\hat x_t`$ / `x` | Exports | (F19), (F20), (F21), (F25) |
| Endogenous | $`TB_t`$ / `tb` | Trade balance | (F25) |
| Endogenous | $`R_t,\hat r_t`$ / `r` | Nominal policy rate in paper notation/log deviation | (F8), (F9), (F21), (F22), (F23) |
| Endogenous | $`\Pi_t,\hat\pi_t`$ / `pi` | Inflation | (F8), (F13), (F14), (F21), (F22), (F23) |
| Exogenous | $`\eta_t^{TFP}`$ / `eta_tfp` | TFP innovation | (F28) |
| Exogenous | $`\eta_t^{\mathcal M_z}`$ / `eta_markup` | Markup innovation | (F29) |
| Exogenous | $`\eta_t^E`$ / `eta_e` | Energy price innovation | (F30), (F31) |
| Parameter | $`\beta`$ / `beta` | Discount factor | (F8), (F13), (F14), (F33) |
| Parameter | $`\sigma`$ / `sigma` | Intertemporal elasticity/risk-aversion parameter | (F8), (F9), (F23) |
| Parameter | $`\chi`$ / `chi` | Labor disutility scale | §2.1 |
| Parameter | $`\varphi`$ / `varphi` | Inverse Frisch elasticity | §2.1 |
| Parameter | $`\omega`$ / `omega` | Constrained household share | (F9), (F10), (F17), (F23), (F26), (F35) |
| Parameter | $`\alpha_{ez}`$ / `alpha_ez` | Energy share in production | (F6), (F11), (F15), (F16), (F20), (F27), (F35) |
| Parameter | $`\psi_{ez}`$ / `psi_ez` | Energy-labor substitution elasticity | (F6), (F11), (F15), (F16), (F23), (F27), (F35) |
| Parameter | $`\epsilon_z`$ / `epsilon_z` | Elasticity across final varieties | (F4), (F5), (F12), (F33) |
| Parameter | $`\phi_z`$ / `phi_z` | Calvo price non-reset probability | (F7), (F12), (F14), (F33) |
| Parameter | $`\phi_w`$ / `phi_w` | Calvo wage non-reset probability | (F13), (F33) |
| Parameter | $`\theta_R,\theta_\pi,\theta_Y`$ | Taylor-rule coefficients | (F22), (F33) |
| Parameter | $`\zeta^{\ast}`$ / `zeta_star` | Export-demand elasticity | (F19), (F21), (F23), (F35) |
| Parameter | $`\rho_{TFP},\rho_{\mathcal M_z},\rho_E`$ | Shock persistence parameters | (F28), (F29), (F31), (F34) |
| Parameter | $`\varsigma_{TFP},\varsigma_{\mathcal M_z},\varsigma_E`$ | Shock standard deviations | (F28)-(F30), (F34) |
