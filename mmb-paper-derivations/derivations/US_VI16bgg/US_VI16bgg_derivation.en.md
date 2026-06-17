# US_VI16bgg -- Derivation (Optimization Problems + First-Order Conditions)

> Model archive entry for `US_VI16bgg`. Runtime validation was not performed. Formula status: `needs_review`, because Table 1 is extracted from MinerU OCR/HTML and the online appendix was not available in this pass.

Source: Stefania Villa (2016), "Financial frictions in the Euro Area and the United States: a Bayesian assessment", *Macroeconomic Dynamics*, 20(05), 1313-1340. DOI: `10.1017/s1365100514000881`.

## 1. Model Overview

- **Model**: United States SWBGG model from Villa (2016), combining a Smets-Wouters medium-scale DSGE core with Bernanke-Gertler-Gilchrist financial frictions in nonfinancial intermediate goods firms.
- **Economy and sample**: United States, estimated on quarterly data for 1983Q1-2008Q3.
- **Experiment**: Bayesian estimated linear DSGE model with seven shocks; this archive entry records the derivation-level model equations, not a runtime-validated Dynare implementation.
- **Agents and blocks**: households, labor union and labor packers, retailers and final good firms, intermediate goods firms, capital producers, and the monetary authority. In the SWBGG variant, intermediate goods firms borrow externally and face a costly-state-verification financial contract.
- **Form**: `model(linear)`. Variables with hats are log-deviations from steady state, while steady-state ratios and levels enter as constants.
- **Source scope**: The main paper says the online appendix gives full details, but the source Markdown contains Table 1 with the linearized model equations. Missing optimization primitives and any appendix-only derivations are marked `needs_review`.

## 2. Optimization Problems

### 2.1 Households

Households choose consumption, bond holdings, and labor supply with external habit. The source Table 1 reports the resulting Euler equation and wage Phillips curve rather than a complete household Lagrangian; the underlying optimization problem is therefore recorded as:

$$
\max_{\{C_t,L_t,B_t\}} E_0 \sum_{t=0}^{\infty} \beta^t
\left[ U(C_t-h C_{t-1}) - V(L_t) \right]
\quad\text{s.t.}\quad
P_t C_t + B_t \le W_t L_t + R^n_{t-1}B_{t-1} + \Pi_t^{div}.
$$

`needs_review`: The exact utility normalization is appendix-dependent; the linearized Euler and wage equations below are source-stated in Table 1.

### 2.2 Labor Union and Labor Packers

A labor union differentiates labor and sets wages under Calvo wage stickiness with partial wage indexation. Competitive labor packers aggregate differentiated labor and sell composite labor to intermediate goods firms. The optimization details are not printed in the main text, but Table 1 gives the wage Phillips curve.

### 2.3 Retailers and Final Good Firms

Retailers differentiate goods and set prices in monopolistic competition with Calvo price stickiness and partial price indexation. Final good firms assemble intermediate goods competitively. Table 1 gives the resulting price Phillips curve.

### 2.4 Intermediate Goods Firms with BGG Financial Contract

Intermediate goods firms choose factors for production and finance capital purchases through net worth and external borrowing. At the end of period `t`, a firm purchases capital `K_{t+1}` at price `Q_t`, so the capital purchase is `Q_t K_{t+1}`. Net worth `N_{t+1}` finances part of this purchase; the remainder is borrowed. Firms survive to the next period with probability `theta`.

Because the project return is subject to an idiosyncratic shock observed costlessly by the firm but only at monitoring cost by the lender, the optimal contract creates an external finance premium:

$$
EP_t = EP\!\left(Q_t + E_t[\hat{K}_{t+1}] - E_t[\hat{N}_{t+1}]\right),
$$

linearized in Table 1 as equation (F14).

### 2.5 Capital Producers

Capital producers transform investment and depreciated capital into new capital sold to intermediate goods firms. Table 1 reports the linear investment Euler equation and capital accumulation law.

### 2.6 Monetary Authority

The policy maker follows an interest-rate rule with smoothing, inflation response, output-gap response, output-gap-growth response, and a monetary policy shock.

## 3. First-Order Conditions

**(F1) Euler equation with habit**

$$
\frac{1+h}{1-h}\hat{C}_{t}
= \frac{1}{1-h}E_t[\hat{C}_{t+1}]
+ \frac{h}{1-h}\hat{C}_{t-1}
- \hat{R}_{t}.
$$

**(F2) Wage Phillips curve**

$$
\hat{W}_{t}
= \frac{\beta}{1+\beta}E_t[\hat{W}_{t+1}]
+ \frac{1}{1+\beta}\hat{W}_{t-1}
+ \frac{\beta}{1+\beta}E_t[\hat{\Pi}_{t+1}]
- \frac{1+\beta\sigma_{wi}}{1+\beta}\hat{\Pi}_{t}
+ \frac{\sigma_{wi}}{1+\beta}\hat{\Pi}_{t-1}
+ \frac{1}{1+\beta}
\frac{(1-\beta\sigma_w)(1-\sigma_w)}{(1+\varepsilon_w\phi)\sigma_w}
\left[\phi\hat{L}_{t}-\frac{h}{1-h}\hat{C}_{t-1}
+\frac{1}{1-h}\hat{C}_{t}-\hat{W}_{t}\right]
+\varepsilon_t^w.
$$

**(F3) Capital accumulation**

$$
\hat{K}_{t+1}
= \delta(\hat{I}_{t}+\varepsilon_t^x)
+ (1-\delta)(\hat{K}_{t}+\varepsilon_t^k).
$$

**(F4) Optimal capital utilization**

$$
\hat{Z}_t^k = \frac{\zeta}{1-\zeta}\hat{U}_t.
$$

**(F5) Investment Euler equation**

$$
\hat{I}_t
= \frac{1}{\xi(1+\beta)}(\hat{Q}_t+\varepsilon_t^x)
+ \frac{1}{1+\beta}\hat{I}_{t-1}
+ \frac{\beta}{1+\beta}E_t[\hat{I}_{t+1}].
$$

**(F6) Production-side factor FOC**

$$
\hat{W}_t = \hat{Z}_t^k - \hat{L}_t + \hat{K}_t + \hat{U}_t.
$$

**(F7) Price Phillips curve**

$$
\hat{\Pi}_t
= \frac{\sigma_{pi}}{1+\sigma_{pi}\beta}\hat{\Pi}_{t-1}
+ \frac{\beta}{1+\sigma_{pi}\beta}E_t[\hat{\Pi}_{t+1}]
- \frac{(1-\beta\sigma_p)(1-\sigma_p)}{(1+\sigma_{pi}\beta)\sigma_p}
\left[\varepsilon_t^a-\alpha\hat{Z}_t^k-(1-\alpha)\hat{W}_t\right]
+ \varepsilon_t^p.
$$

**(F8) Taylor rule**

$$
\hat{R}_t^n
= \rho_i\hat{R}_{t-1}^n
+ (1-\rho_i)\left[\rho_\pi\hat{\Pi}_t
+ \rho_y(\hat{Y}_t-\hat{Y}_t^p)\right]
+ \rho_{\Delta y}\left[\hat{Y}_t-\hat{Y}_t^p
- (\hat{Y}_{t-1}-\hat{Y}_{t-1}^p)\right]
+ \varepsilon_t^r.
$$

**(F9) Fisher equation**

$$
\hat{R}_t^n = \hat{R}_t + E_t[\hat{\Pi}_{t+1}].
$$

**(F10) Price of capital / return on capital in SWBGG**

$$
\hat{R}_t^k
= \frac{Z^k}{R^k}\hat{Z}_t^k
+ \frac{1-\delta}{R^k}(\hat{Q}_t+\varepsilon_t^k)
- \hat{Q}_{t-1}.
$$

**(F11) External finance premium**

$$
\hat{EP}_t
= \varkappa\left(\hat{Q}_t + E_t[\hat{K}_{t+1}]
- E_t[\hat{N}_{t+1}]\right).
$$

**(F12) Spread / capital-return arbitrage**

$$
E_t[\hat{R}_{t+1}^k] = \hat{R}_t + \hat{EP}_t.
$$

**(F13) Firms' net worth accumulation**

$$
\frac{1}{\theta R^k}E_t[\hat{N}_{t+1}]
= \frac{K}{N}\hat{R}_t^k
- \left(\frac{K}{N}-1\right)\hat{R}_{t-1}
- \varkappa\left(\frac{K}{N}-1\right)(\hat{K}_t+\hat{Q}_{t-1})
+ \left[\left(\frac{K}{N}-1\right)\varkappa+1\right]\hat{N}_t.
$$

## 4. Market Clearing & Identities

**(F14) Resource constraint**

$$
\hat{Y}_t
= \frac{C}{Y}\hat{C}_t
+ \frac{I}{Y}\hat{I}_t
+ \frac{G}{Y}\varepsilon_t^g
+ Z^k\frac{K}{Y}\hat{U}_t.
$$

**(F15) Production function**

$$
\hat{Y}_t
= \Theta\left[\varepsilon_t^a
+ \alpha(\varepsilon_t^k+\hat{K}_t+\hat{U}_t)
+ (1-\alpha)\hat{L}_t\right].
$$

**(F16) Optional employment Phillips curve**

$$
\hat{E}_t
= \frac{1}{1+\beta}\hat{E}_{t-1}
+ \frac{\beta}{1+\beta}E_t[\hat{E}_{t+1}]
- \frac{(1-\beta\sigma_E)(1-\sigma_E)}{(1+\beta)\sigma_E}
(\hat{L}_t-\hat{E}_t).
$$

`needs_review`: The implementation cross-check comments out employment for the US replication because US hours are available; this archive keeps the source-stated Table 1 equation but marks it optional for the US MMB implementation.

## 5. Exogenous Processes

The paper states that seven orthogonal shocks follow AR(1) processes. The signs below follow the implementation cross-check for `US_VI16bgg_rep.mod`; because Table 1 itself does not print all AR(1) laws, these signs are `implementation_cross_check`.

**(F17) Technology shock**

$$
\varepsilon_t^a = \rho_a\varepsilon_{t-1}^a - e_t^a.
$$

**(F18) Government shock**

$$
\varepsilon_t^g = \rho_g\varepsilon_{t-1}^g - e_t^g.
$$

**(F19) Investment-specific technology shock**

$$
\varepsilon_t^x = \rho_x\varepsilon_{t-1}^x - e_t^x.
$$

**(F20) Monetary policy shock**

$$
\varepsilon_t^r = \rho_{ri}\varepsilon_{t-1}^r + e_t^r.
$$

**(F21) Price mark-up shock**

$$
\varepsilon_t^p = \rho_p\varepsilon_{t-1}^p + e_t^p.
$$

**(F22) Wage mark-up shock**

$$
\varepsilon_t^w = \rho_w\varepsilon_{t-1}^w + e_t^w.
$$

**(F23) Capital quality shock**

$$
\varepsilon_t^k = \rho_k\varepsilon_{t-1}^k - e_t^k.
$$

## 6. Steady-State Solution

Because the model is linearized, all hatted endogenous variables and zero-mean shocks have steady state zero:

$$
\hat{C}=\hat{I}=\hat{Y}=\hat{W}=\hat{L}=\hat{\Pi}=\hat{R}=\hat{R}^n
=\hat{K}=\hat{Q}=\hat{R}^k=\hat{EP}=\hat{N}=\hat{U}=\hat{Z}^k=0.
$$

The source and implementation cross-check define the steady-state constants:

$$
R=\frac{1}{\beta},\qquad
Z^k=R-(1-\delta),\qquad
R^k=S R,\qquad
\frac{K}{N}=2.
$$

Additional ratios used in the linear equations are computed from calibrated constants:

$$
\frac{I}{K}=\delta,\qquad
\frac{G}{Y}=0.20,\qquad
\frac{C}{Y}=1-\frac{I}{Y}-\frac{G}{Y}.
$$

`needs_review`: The source Table 1 does not print every steady-state ratio formula. The implementation cross-check computes `W`, `K_L`, `Y_K`, `K_Y`, `I_Y`, and `C_Y`; these are recorded in `extraction_notes.md` as implementation evidence, not independent paper-side derivation.

## 7. Timing & Form Conventions

- **Linear form**: The MMB implementation uses `model(linear)`. Hatted variables are log-deviations or percentage deviations from steady state.
- **Capital timing**: The paper describes capital purchased at the end of `t` as `K_{t+1}` for use in `t+1`; the implementation rewrites this with predetermined capital as `k(-1)` in production and return equations, and `k` as next-period/end-of-period capital.
- **Financial timing**: External finance premium depends on expected next-period capital and net worth. The implementation cross-check writes `ext_pr = kappa*(q + k - n)` after shifting expectations into current model timing.
- **Output gap**: The Taylor rule reacts to sticky-price output relative to flexible-price output, `Y_t - Y_t^p`.
- **US-specific implementation convention**: The employment Phillips curve is source-stated but commented out in the US MMB `.mod`; hours worked enter instead of an employment block.
- **Runtime validation**: Not performed.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Equation coverage |
|---|---|---|---|
| Endogenous | `c`, `C_t` | Consumption deviation | (F1), (F14) |
| Endogenous | `i`, `I_t` | Investment deviation | (F5), (F14) |
| Endogenous | `y`, `Y_t` | Output deviation | (F14), (F15), (F8) |
| Endogenous | `w`, `W_t` | Real wage deviation | (F2), (F6), (F7) |
| Endogenous | `l`, `L_t` | Labor or hours deviation | (F2), (F6), (F15) |
| Endogenous | `pi`, `Pi_t` | Inflation deviation | (F2), (F7), (F8), (F9) |
| Endogenous | `r`, `R_t` | Real interest rate deviation | (F1), (F9), (F12) |
| Endogenous | `rn`, `R_t^n` | Nominal interest rate deviation | (F8), (F9) |
| Endogenous | `zk`, `Z_t^k` | Rental rate / marginal product of capital deviation | (F4), (F6), (F10), (F15) |
| Endogenous | `u`, `U_t` | Capital utilization deviation | (F4), (F14), (F15) |
| Endogenous | `k`, `K_t` | Capital stock deviation | (F3), (F11), (F13), (F15) |
| Endogenous | `q`, `Q_t` | Price of capital deviation | (F5), (F10), (F11), (F13) |
| Endogenous | `rk`, `R_t^k` | Return on capital deviation | (F10), (F12), (F13) |
| Endogenous | `ext_pr`, `EP_t` | External finance premium / spread | (F11), (F12) |
| Endogenous | `n`, `N_t` | Net worth deviation | (F11), (F13) |
| Endogenous | `yf, cf, if, wf, lf, rf, zkf, uf, kf, qf, rkf, ext_prf, nf` | Flexible-price counterparts for output-gap and natural-rate blocks | mirrors (F1), (F3)-(F6), (F10)-(F13), (F14), (F15) |
| Optional endogenous | `E_t` | Employment deviation | (F16), optional for US implementation |
| Exogenous state | `a` | Technology shock state | (F17) |
| Exogenous state | `g` | Government shock state | (F18), (F14) |
| Exogenous state | `eps_x` | Investment-specific technology shock state | (F19), (F3), (F5) |
| Exogenous state | `eps_r` | Monetary policy shock state | (F20), (F8) |
| Exogenous state | `eps_p` | Price mark-up shock state | (F21), (F7) |
| Exogenous state | `eps_w` | Wage mark-up shock state | (F22), (F2) |
| Exogenous state | `eps_k` | Capital quality shock state | (F23), (F3), (F10), (F15) |
| Innovations | `e_a, e_g, e_x, e_r, e_p, e_w, e_k` | Orthogonal innovations | (F17)-(F23) |
| Parameters | `alpha, beta, delta` | Capital share, discount factor, depreciation | steady state, (F3), (F7), (F10), (F15) |
| Parameters | `epsilon, epsilon_w, M` | Goods/labor substitution and markup targets | price and wage blocks |
| Parameters | `G_Y, N_K, theta, bas_point, s_coef` | Government share, net-worth-to-capital ratio, firm survival, spread calibration | (F11)-(F14), steady state |
| Parameters | `ksi, h, zeta, phi, Theta, kappa` | Investment adjustment, habit, utilization, labor supply, fixed costs, external finance elasticity | (F1)-(F7), (F11), (F13), (F15) |
| Parameters | `sigma_w, sigma_p, sigma_wi, sigma_pi` | Wage and price Calvo/indexation parameters | (F2), (F7) |
| Parameters | `rho_pi, rho_dy, rho_y, rho_r` | Taylor rule coefficients | (F8) |
| Parameters | `rho_a, rho_k, rho_g, rho_x, rho_ri, rho_p, rho_w` | Shock persistence | (F17)-(F23) |
