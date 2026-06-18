# US_KK14 -- Derivation (optimization problems + first-order conditions)

> Model archive draft for `US_KK14`. Status: `needs_review`.
> Source: Kliem and Kriwoluzky (2014), "Toward a Taylor rule for fiscal policy", Review of Economic Dynamics 17(2), 294-302. DOI: `10.1016/j.red.2013.08.003`.
> Main source Markdown: `raw/mmb_mineru/runs/us_kk14__toward_a_taylor_rule_for_fiscal_policy__db8507f5/full.md`.
> The paper states that household/firm FOCs, steady-state solution, and the complete log-linear equation list are in online supplementary material. No local appendix normalization file exists, so source-incomplete blocks are marked `needs_review`.

## 1. Model Overview

- **Model**: Estimated US New Keynesian DSGE model in the Smets-Wouters tradition, extended with a fiscal sector for government purchases, transfers, government debt, and distortionary taxes on labor and capital income.
- **Purpose**: Compare conventional fiscal feedback rules in which tax rates react to output with alternative rules in which labor taxes react to hours and capital taxes react to investment.
- **Agents and sectors**: Households with internal consumption habit, differentiated labor, wage setting, bond and capital accumulation decisions; final-good firms; monopolistically competitive intermediate-good firms with Calvo price setting; monetary authority; fiscal authority.
- **Frictions**: Internal habit, variable capital utilization, investment adjustment costs, Calvo wage and price rigidity, fixed production cost, distortionary labor and capital income taxes.
- **Economy**: United States, estimated on quarterly data from 1983:1 to 2008:3.
- **Form**: The paper's solution is log-linear. The MMB implementation cross-check is `model(linear)`. This derivation therefore treats the archive target as a linearized DSGE entry. Exact appendix log-linear equations are not locally available and are marked `needs_review`.
- **Runtime validation**: Not performed. Dynare was not run.

## 2. Optimization Problems

### 2.1 Households

Household $`i \in [0,1]`$ chooses consumption, investment, bonds, capital, capital utilization, and wage-setting decisions. The source states the period utility and budget constraint, while full FOCs are deferred to the online appendix.

**(F1) Household lifetime utility**:

```math
E_t \sum_{s=0}^{\infty}\beta^s
\left[
\varepsilon_{q,t+s}
\frac{(c_{t+s}-h c_{t+s-1})^{1-\sigma_c}}{1-\sigma_c}
-\psi_l \frac{l_{t+s}(i)^{1+\sigma_l}}{1+\sigma_l}
\right].
```

Here $`\varepsilon_{q,t}`$ is the intertemporal preference shock.

**(F2) Household flow budget constraint**:

```math
c_t+I_t+b_t
=
(1-\tau_t^w)\frac{W_t(i)}{P_t}l_t(i)
+\left((1-\tau_t^k)r_t^k u_t-\phi_t(u_t)\right)k_{t-1}
+\frac{R_{t-1}b_{t-1}}{\pi_t}
+(1-\tau_t^k)d_t+\iota_t(i)+\tau_t^T.
```

**(F3) Capital accumulation with investment-specific efficiency shock**:

```math
k_t=(1-\delta)k_{t-1}
+\varepsilon_{i,t}\left[1-s\left(\frac{I_t}{I_{t-1}}\right)\right]I_t.
```

### 2.2 Wage Setting

Households supply differentiated labor. A competitive labor contractor aggregates differentiated labor services with a Dixit-Stiglitz technology. Each household can reset its wage with probability $`1-\gamma_w`$; otherwise wages are indexed to steady-state inflation.

**(F4) Wage-setting block placeholder** (`needs_review`):

```math
\text{Calvo wage reset FOC and wage Phillips curve: online appendix required.}
```

The MMB implementation cross-check contains a linear wage Phillips relation and wage-inflation identity, but those equations are not treated as paper-side sources.

### 2.3 Final- and Intermediate-Good Firms

Final-good firms aggregate intermediate goods under Dixit-Stiglitz demand with elasticity $`\theta_p>1`$. Intermediate producers use capital services and labor services with labor-augmenting productivity.

**(F5) Intermediate-good production function**:

```math
y_t(j)=\left(u_t k_{t-1}(j)\right)^\alpha
\left(l_t^d(j)\varepsilon_{z,t}\right)^{1-\alpha}
-\Omega.
```

Intermediate firms are allowed to reset prices with probability $`1-\gamma_p`$; non-reset prices are indexed to steady-state inflation.

**(F6) Price-setting block placeholder** (`needs_review`):

```math
\text{Calvo price reset FOC and price Phillips curve: online appendix required.}
```

### 2.4 Fiscal Authority

The fiscal authority finances wasteful government consumption $`c_t^g`$ and transfers $`\tau_t^T`$ using tax revenues $`x_t`$ and one-period government bonds.

**(F7) Government budget constraint**:

```math
b_t-\frac{R_{t-1}b_{t-1}}{\pi_t}=c_t^g+\tau_t^T-x_t.
```

**(F8) Tax revenue identity**:

```math
x_t=\tau_t^w w_t\frac{l_t}{w_t^+}
+\tau_t^k\left[y_t-w_t\frac{l_t}{w_t^+}\right].
```

## 3. First-Order Conditions

The source paper does not print the full household, firm, wage-setting, and price-setting FOCs in the article body. It explicitly points to online supplementary material for the maximization problems, FOCs, steady state, and complete log-linear equations. Since no local appendix normalization is present, this section records only first-pass normalized conditions needed to describe the model architecture; all formulas in this section are `needs_review`.

**(F9) Consumption Euler equation** (`needs_review`):

```math
\chi_t
=E_t\chi_{t+1}+R_t-E_t\pi_{t+1},
```

where $`\chi_t`$ denotes the linearized marginal utility of consumption and $`R_t-E_t\pi_{t+1}`$ is the ex-ante real return.

**(F10) Habit-adjusted marginal utility** (`needs_review`):

```math
(1-\beta h)\chi_t
=\varepsilon_{q,t}
-\frac{\sigma_c}{1-h}(c_t-hc_{t-1})
-h\beta E_t\varepsilon_{q,t+1}
+h\beta\frac{\sigma_c}{1-h}E_t(c_{t+1}-hc_t).
```

**(F11) Labor marginal disutility** (`needs_review`):

```math
MUL_t=\sigma_l l_t.
```

**(F12) Marginal rate of substitution between labor and consumption** (`needs_review`):

```math
MRS_t=MUL_t-\chi_t.
```

**(F13) Capital Euler condition** (`needs_review`):

```math
\chi_t+q_t
=E_t\chi_{t+1}
+\beta E_t\left[(1-\bar{\tau}^k) \bar{r}^k r_{t+1}^k
-\bar{\tau}^k \bar{r}^k \tau_{t+1}^k
+(1-\delta)q_{t+1}\right].
```

**(F14) Investment adjustment-cost condition** (`needs_review`):

```math
I_t=\frac{1}{1+\beta}I_{t-1}
+\frac{\beta}{1+\beta}E_t I_{t+1}
+\frac{1}{\nu(1+\beta)}q_t
+\frac{1}{\nu(1+\beta)}\varepsilon_{i,t}.
```

**(F15) Capital-utilization condition** (`needs_review`):

```math
\sigma_u u_t=r_t^k-\frac{\bar{\tau}^k}{1-\bar{\tau}^k}\tau_t^k.
```

**(F16) Wage Phillips curve** (`needs_review`):

```math
\pi_t^w
=\beta E_t\pi_{t+1}^w
+\frac{(1-\gamma_w)(1-\gamma_w\beta)}
{\gamma_w(1+\theta_w\sigma_l)}
\left(MRS_t-w_t+\frac{\bar{\tau}^w}{1-\bar{\tau}^w}\tau_t^w\right).
```

**(F17) Wage inflation identity** (`needs_review`):

```math
\pi_t^w=w_t-w_{t-1}+\pi_t.
```

**(F18) Price Phillips curve** (`needs_review`):

```math
\pi_t=\beta E_t\pi_{t+1}
+\frac{(1-\gamma_p)(1-\gamma_p\beta)}{\gamma_p}mc_t.
```

## 4. Market Clearing & Identities

**(F19) Marginal-cost/labor-price relation** (`needs_review`):

```math
mc_t+(1-\alpha)\varepsilon_{z,t}+\alpha(u_t+k_{t-1})
-\alpha l_t=w_t.
```

**(F20) Marginal-cost/rental-rate relation** (`needs_review`):

```math
mc_t+(1-\alpha)\varepsilon_{z,t}+(\alpha-1)(u_t+k_{t-1})
+(1-\alpha)l_t=r_t^k.
```

**(F21) Aggregate production** (`needs_review`):

```math
\bar{y}y_t
=\bar{k}^{\alpha}\bar{l}^{1-\alpha}
\left(\alpha u_t+\alpha k_{t-1}+(1-\alpha)l_t+(1-\alpha)\varepsilon_{z,t}\right).
```

**(F22) Aggregate resource constraint** (`needs_review`):

```math
\bar{y}y_t=\bar{c}c_t+\bar{I}I_t+\bar{c}^g c_t^g
+\bar{r}^k(1-\bar{\tau}^k)\bar{k}u_t.
```

**(F23) Measured GDP identity**:

```math
y_t^m=y_t-\phi(u_t)k_{t-1}.
```

The paper's Taylor rule uses measured output $`y_t^m`$.

**(F24) Government budget constraint, linearized form** (`needs_review`):

```math
\bar{b}b_t-\frac{\bar{b}}{\beta}
\left(R_{t-1}-\pi_t+b_{t-1}\right)
=\bar{c}^g c_t^g+\bar{\tau}^T\tau_t^T-\bar{x}x_t.
```

**(F25) Tax revenue, linearized form** (`needs_review`):

```math
\bar{x}x_t
=\bar{\tau}^w\bar{w}\bar{l}\left(\tau_t^w+w_t+l_t\right)
+\bar{\tau}^k\bar{r}^k\bar{k}\left(\tau_t^k+r_t^k+u_t+k_{t-1}\right)
+\bar{\tau}^k\left(\bar{y}y_t-\bar{r}^k\bar{k}(r_t^k+u_t+k_{t-1})-\bar{w}\bar{l}(w_t+l_t)\right).
```

**(F26) Monetary-policy rule**:

```math
\hat{R}_t=\rho_R\hat{R}_{t-1}
+(1-\rho_R)\left(\rho_\pi\hat{\pi}_t+\rho_y\hat{y}_t^m\right)
+\hat{\epsilon}_t^m.
```

**(F27) Baseline labor-income tax rule**:

```math
\hat{\tau}_t^w=\rho_w\hat{\tau}_{t-1}^w
+(1-\rho_w)\left(\eta_{wb}\hat{b}_{t-1}+\eta_{wy}\hat{y}_t^m\right)
+\hat{\epsilon}_{t,\tau^w}.
```

**(F28) Baseline capital-income tax rule**:

```math
\hat{\tau}_t^k=\rho_k\hat{\tau}_{t-1}^k
+(1-\rho_k)\left(\eta_{kb}\hat{b}_{t-1}+\eta_{ky}\hat{y}_t^m\right)
+\hat{\epsilon}_{t,\tau^k}.
```

**(F29) Recommended labor-income tax rule**:

```math
\hat{\tau}_t^w=\rho_w\hat{\tau}_{t-1}^w
+(1-\rho_w)\left(\eta_{wb}\hat{b}_{t-1}+\eta_{wh}\hat{l}_t\right)
+\epsilon_{t,\tau^w}.
```

**(F30) Recommended capital-income tax rule**:

```math
\hat{\tau}_t^k=\rho_k\hat{\tau}_{t-1}^k
+(1-\rho_k)\left(\eta_{kb}\hat{b}_{t-1}+\eta_{kI}\hat{I}_t\right)
+\epsilon_{t,\tau^k}.
```

## 5. Exogenous Processes

The paper states that government consumption, transfers, the intertemporal preference shock, the investment-specific shock, and labor-augmenting technology are AR(1) processes. The implementation cross-check also contains AR(1) processes for these shocks.

**(F31) Government consumption process** (`needs_review`):

```math
c_t^g=\rho_{cg}c_{t-1}^g+\epsilon_t^{cg}.
```

**(F32) Transfer process** (`needs_review`):

```math
\tau_t^T=\rho_T\tau_{t-1}^T+\epsilon_t^{T}.
```

**(F33) Investment-specific efficiency shock** (`needs_review`):

```math
\varepsilon_{i,t}=\rho_i\varepsilon_{i,t-1}+e_{i,t}.
```

**(F34) Labor-augmenting technology shock** (`needs_review`):

```math
\varepsilon_{z,t}=\rho_z\varepsilon_{z,t-1}+e_{z,t}.
```

**(F35) Intertemporal preference shock** (`needs_review`):

```math
\varepsilon_{q,t}=\rho_q\varepsilon_{q,t-1}+e_{q,t}.
```

**(F36) Monetary-policy innovation**:

```math
\epsilon_t^m \sim \text{i.i.d.}
```

**(F37) Fiscal-rule innovations**:

```math
\epsilon_{t,\tau^w}\sim \text{i.i.d.}, \qquad
\epsilon_{t,\tau^k}\sim \text{i.i.d.}
```

## 6. Steady-State Solution

The article body gives selected calibration targets but says that the full steady-state solution is in the online appendix. The following is therefore a source-backed target inventory plus implementation cross-check, not a reviewed steady-state derivation.

- Steady-state capital tax rate: $`\bar{\tau}^k=0.1929`$ in the estimated-data calibration.
- Steady-state labor tax rate: $`\bar{\tau}^w=0.2088`$ in the estimated-data calibration.
- Gross nominal interest-rate target: $`\bar{R}=1.013`$ in the implementation cross-check.
- Government purchases-to-output target: $`\bar{c}^g/\bar{y}=0.085`$.
- Transfers-to-output target: $`\bar{\tau}^T/\bar{y}=0.105`$.
- Steady-state hours target: $`\bar{l}=1/3`$.
- Capital share and depreciation in the implementation cross-check: $`\alpha=0.36`$, $`\delta=0.025`$.
- For the Ramsey optimal-policy steady state discussed in the article body, the paper reports $`\bar{\tau}^k=-0.1523`$, $`\bar{\tau}^w=0.3945`$, and $`\bar{b}/\bar{y}=0.3`$.

`needs_review`: The exact recursive steady-state solution and all auxiliary steady-state definitions should be reconstructed from the online appendix or source-level checked implementation equations before this entry is promoted beyond first-pass archive status.

## 7. Timing & Form Conventions

- **Linearized form**: Equations are expressed as deviations from steady state where hats or lowercase linearized variables appear. The MMB file uses `model(linear)`.
- **Capital timing**: Production uses predetermined $`k_{t-1}`$ and utilization $`u_t`$; capital accumulation determines $`k_t`$ at the end of period $`t`$.
- **Debt timing**: Fiscal feedback rules respond to lagged debt $`b_{t-1}`$.
- **Tax timing**: Labor and capital taxes are contemporaneous fiscal instruments with autoregressive feedback-rule dynamics.
- **Monetary timing**: The Taylor rule responds to current inflation and measured output and includes lagged nominal interest rate smoothing.
- **Implementation cross-check only**: The `.mod` file confirms variables and shock names but is not used as paper-side mathematical evidence.
- **Runtime validation**: Not performed; no `steady`, `check`, or `stoch_simul` run was executed for this archive entry.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII name | Meaning | Determined by |
|---|---|---|---|
| Endogenous | `c` / $`c_t`$ | Consumption | (F9), (F10), (F22) |
| Endogenous | `I` / $`I_t`$ | Investment | (F14), (F22), (F30) |
| Endogenous | `b` / $`b_t`$ | Government debt | (F7), (F24), (F27)-(F30) |
| Endogenous | `k` / $`k_t`$ | Private capital stock | (F3), (F13), (F21) |
| Endogenous | `u` / $`u_t`$ | Capital utilization | (F15), (F21), (F22) |
| Endogenous | `q` / $`q_t`$ | Tobin's Q | (F13), (F14) |
| Endogenous | `rk` / $`r_t^k`$ | Rental rate of capital | (F13), (F15), (F20), (F25) |
| Endogenous | `w` / $`w_t`$ | Real wage | (F16), (F17), (F19), (F25) |
| Endogenous | `lp` / $`l_t`$ | Hours/labor services | (F1), (F11), (F12), (F19), (F21), (F29) |
| Endogenous | `MUL` | Marginal labor disutility | (F11) |
| Endogenous | `MRS` | Labor-consumption marginal rate of substitution | (F12), (F16) |
| Endogenous | `chi` / $`\chi_t`$ | Marginal utility of consumption | (F9), (F10), (F13) |
| Endogenous | `inf_p` / $`\pi_t`$ | Price inflation | (F17), (F18), (F24), (F26) |
| Endogenous | `inf_w` / $`\pi_t^w`$ | Wage inflation | (F16), (F17) |
| Endogenous | `R` / $`R_t`$ | Nominal policy rate deviation in implementation notation | (F9), (F24), (F26) |
| Endogenous | `Rb` | Ex-ante real bond return | (F9) |
| Endogenous | `mc` / $`mc_t`$ | Real marginal cost | (F18)-(F20) |
| Endogenous | `y` / $`y_t`$ | Output | (F21), (F22), (F25) |
| Endogenous | `GDP` / $`y_t^m`$ | Measured output/GDP | (F23), (F26)-(F30) |
| Endogenous | `tax` / $`x_t`$ | Total tax revenue | (F8), (F25) |
| Endogenous | `tax_rev_tauw` | Labor-tax revenue reporting variable | (F8), (F25) |
| Endogenous | `tax_rev_tauk` | Capital-tax revenue reporting variable | (F8), (F25) |
| Endogenous | `tau_w` / $`\tau_t^w`$ | Labor income tax rate | (F27), (F29) |
| Endogenous | `tau_k` / $`\tau_t^k`$ | Capital income tax rate | (F28), (F30) |
| Endogenous | `cg` / $`c_t^g`$ | Government consumption | (F7), (F22), (F24), (F31) |
| Endogenous | `tr` / $`\tau_t^T`$ | Transfers | (F7), (F24), (F32) |
| Endogenous | `eps_i` / $`\varepsilon_{i,t}`$ | Investment-specific efficiency state | (F3), (F14), (F33) |
| Endogenous | `eps_z` / $`\varepsilon_{z,t}`$ | Labor-augmenting technology state | (F5), (F19)-(F21), (F34) |
| Endogenous | `eps_q` / $`\varepsilon_{q,t}`$ | Preference shock state | (F1), (F10), (F35) |
| Exogenous | `e_i` | Investment-efficiency innovation | (F33) |
| Exogenous | `e_z` | Technology innovation | (F34) |
| Exogenous | `e_q` | Preference-shock innovation | (F35) |
| Exogenous | `eps_m` | Monetary-policy innovation | (F26), (F36) |
| Exogenous | `eps_cg` | Government-consumption innovation | (F31) |
| Exogenous | `eps_tr` | Transfer innovation | (F32) |
| Exogenous | `eps_tauk` | Capital-tax innovation | (F28), (F30), (F37) |
| Exogenous | `eps_tauw` | Labor-tax innovation | (F27), (F29), (F37) |
| Parameter | `nbeta` / $`\beta`$ | Discount factor | -- |
| Parameter | `nalpha` / $`\alpha`$ | Capital share | -- |
| Parameter | `sigma_c` | Inverse intertemporal substitution elasticity | -- |
| Parameter | `sigma_l` | Inverse labor-supply elasticity | -- |
| Parameter | `h` | Internal habit persistence | -- |
| Parameter | `delta` | Depreciation rate | -- |
| Parameter | `nu` | Investment adjustment-cost curvature | -- |
| Parameter | `sigma_u` | Utilization-cost curvature | -- |
| Parameter | `gamma_w`, `theta_w` | Wage Calvo and labor elasticity parameters | -- |
| Parameter | `gamma_p`, `theta_p` | Price Calvo and goods elasticity parameters | -- |
| Parameter | `rho_R`, `rho_pi`, `rho_y` | Taylor-rule smoothing and responses | -- |
| Parameter | `rho_w`, `rho_k` | Fiscal-rule persistence parameters | -- |
| Parameter | `etaW*`, `etaK*` | Fiscal feedback coefficients | -- |
| Parameter | `rho_cg`, `rho_tr`, `rho_eps_i`, `rho_eps_z`, `rho_eps_q` | Exogenous persistence parameters | -- |
| Parameter | `tau_k_SS`, `tau_w_SS`, `R_SS`, `cgy`, `tr_o_y`, `l_SS` | Steady-state targets | -- |
