# US_DG08 -- Derivation (optimization problems + first-order conditions)

> Archive entry for `US_DG08`. Runtime validation was not performed. The paper presents the estimated system directly in log-linearized form, so the optimization problems below are source-backed economic primitives rather than complete nonlinear programs.

## 1. Model Overview

- **Model**: De Graeve (2008), "The external finance premium and the macroeconomy: US post-WWII evidence."
- **Authors/year**: Ferre De Graeve, 2008.
- **DOI**: `10.1016/j.jedc.2008.02.008`.
- **Source**: `raw/mmb_mineru/runs/us_dg08__the_external_finance_premium_and_the_macroeconomy_us_post_wwii_evidence__6112c2c0/full.md`; raw PDF `raw/mmb_papers/The external finance premium and the macroeconomy- US post-WWII evidence..pdf`.
- **MMB implementation cross-check**: `.agents/skills/dynare-copilot/references/examples/US_DG08_rep.mod`.
- **Purpose**: Estimate a US post-WWII medium-scale DSGE model with a Bernanke-Gertler-Gilchrist financial accelerator and infer a model-consistent external finance premium from macro data.
- **Agents**: households with habit and differentiated labor, monopolistically competitive intermediate-goods firms with sticky prices, final-goods firms, capital-goods producers with investment adjustment costs, entrepreneurs financed by internal net worth and bank loans, financial intermediaries with costly state verification, and a monetary authority.
- **Form**: log-linearized `model(linear)`. Variables with hats are log or level deviations from steady state as in the paper and implementation. First-pass formula status is `needs_review` because several OCR symbols and implementation normalizations require paper-level checking.

## 2. Optimization Problems

### Households

Households choose consumption, bond holdings, and differentiated labor services. The paper does not print the full household objective, but equations (1) and (2) imply external habit, non-separability between consumption and labor, differentiated labor supply, Calvo wage setting, partial wage indexation, a discount-factor shock, a labor-supply shock, and a wage-markup shock.

Source-backed reduced-form primitives:

```math
U_t = U(C_t, C_{t-1}, L_t; h, \sigma_c, \sigma_l, \varepsilon_t^B, \varepsilon_t^L),
\qquad
W_t(j)\ \text{is reset only with probability}\ 1-\xi_w .
```

### Firms

Final-goods firms aggregate differentiated intermediate goods. Intermediate-goods firms rent capital services and labor, use Cobb-Douglas production with fixed costs and variable capital utilization, and reset prices only with probability $`1-\xi_p`$.

```math
Y_t = F(\varepsilon_t^A, K_{t-1}, u_t, L_t;\alpha,\phi),
\qquad
P_t(i)\ \text{is partially indexed with parameter}\ \gamma_p .
```

### Capital-Goods Producers

Capital-goods producers transform investment goods into installed capital subject to investment adjustment costs and an investment-specific technology shock:

```math
K_{t+1}=(1-\tau)K_t+\tau I_t+\text{investment-technology disturbance}.
```

### Entrepreneurs And Financial Intermediaries

Entrepreneurs buy capital $`K_{t+1}`$ at price $`Q_t`$ using net worth $`N_{t+1}`$ and external borrowing. Costly state verification implies an external finance premium that rises with leverage, summarized in log-linear form by equation (F9).

### Monetary Authority

The monetary authority follows an empirical Taylor rule with interest-rate smoothing, response to inflation and output-gap levels, speed-limit terms, a temporary monetary-policy shock, and a persistent inflation-target shock.

## 3. First-Order Conditions

The paper's Section 2 prints the estimated log-linear system. Equations (F1)-(F12) correspond to paper equations (1)-(12), except where noted.

- **(F1) Consumption Euler equation with habit and preference shock**:

```math
\hat C_t =
\frac{h}{1+h}\hat C_{t-1}
+\frac{1}{1+h}E_t\hat C_{t+1}
+\frac{\sigma_c-1}{(1+\lambda_w)(1+h)\sigma_c}
(\hat L_t-E_t\hat L_{t+1})
-\frac{1-h}{(1+h)\sigma_c}\hat R_t
+\frac{1-h}{(1+h)\sigma_c}
(\hat\varepsilon_t^B-E_t\hat\varepsilon_{t+1}^B).
```

- **(F2) Sticky-wage equation**:

```math
\begin{aligned}
\hat w_t={}&
\frac{\beta}{1+\beta}E_t\hat w_{t+1}
+\frac{1}{1+\beta}\hat w_{t-1}
+\frac{\beta}{1+\beta}(E_t\hat\pi_{t+1}-\bar\pi_t)
-\frac{1+\beta\gamma_w}{1+\beta}(\hat\pi_t-\bar\pi_t) \\
&+\frac{\gamma_w}{1+\beta}(\hat\pi_{t-1}-\bar\pi_t)
-\frac{1}{1+\beta}
\frac{(1-\beta\xi_w)(1-\xi_w)}
{(1+(1+\lambda_w)\sigma_l/\lambda_w)\xi_w}
\left[
\hat w_t-\sigma_l\hat L_t-\frac{\sigma_c}{1-h}(\hat C_t-h\hat C_{t-1})
-\hat\varepsilon_t^L
\right]
+\eta_t^W .
\end{aligned}
```

- **(F3) Aggregate supply / production**:

```math
\hat Y_t =
\phi\hat\varepsilon_t^A
+\phi\alpha\hat K_{t-1}
+\frac{\phi\alpha}{\psi}\hat r_t^k
+\phi(1-\alpha)\hat L_t .
```

- **(F4) Labor demand**:

```math
\hat L_t =
-\hat w_t+\left(1+\frac{1}{\psi}\right)\hat r_t^k+\hat K_{t-1}.
```

- **(F5) Sticky-price Phillips curve**:

```math
\begin{aligned}
\hat\pi_t-\bar\pi_t={}&
\frac{\beta}{1+\beta\gamma_p}(E_t\hat\pi_{t+1}-\bar\pi_t)
+\frac{\gamma_p}{1+\beta\gamma_p}(\hat\pi_{t-1}-\bar\pi_t)\\
&+\frac{1}{1+\beta\gamma_p}
\frac{(1-\beta\xi_p)(1-\xi_p)}{\xi_p}
\left[\alpha\hat r_t^k+(1-\alpha)\hat w_t-\hat\varepsilon_t^A\right]
+\eta_t^P .
\end{aligned}
```

- **(F6) Capital accumulation**:

```math
\hat K_{t+1}=(1-\tau)\hat K_t+\tau\hat I_t+\tau\hat\varepsilon_t^I .
```

- **(F7) Investment adjustment-cost condition**:

```math
\hat I_t=
\frac{1}{1+\beta}\hat I_{t-1}
+\frac{\beta}{1+\beta}E_t\hat I_{t+1}
+\frac{1/\varphi}{1+\beta}(\hat Q_t+\hat\varepsilon_t^I).
```

- **(F8) Expected real return to capital**:

```math
E_t\hat R_{t+1}^K =
\frac{1-\tau}{\bar R^K}E_t\hat Q_{t+1}
+\frac{\bar r^k}{\bar R^K}E_t\hat r_{t+1}^k
-\hat Q_t .
```

- **(F9) External-finance premium / capital-arbitrage condition**:

```math
E_t\hat R_{t+1}^K =
-\varepsilon E_t[\hat N_{t+1}-\hat Q_t-\hat K_{t+1}]
+\hat R_t .
```

- **(F10) Entrepreneurial net worth**:

```math
\hat N_{t+1} =
\gamma\bar R^K
\left[
\frac{\bar K}{\bar N}
(\hat R_t^K-E_{t-1}\hat R_t^K)
+E_{t-1}\hat R_t^K+\hat N_t
\right].
```

## 4. Market Clearing & Identities

- **(F11) Goods-market resource constraint**:

```math
\hat Y_t =
c_y\hat C_t+\tau k_y\hat I_t+\varepsilon_t^G
+c_{\mathrm{util},t}
+c_{\mathrm{bankrupt},t}.
```

The implementation cross-check expands the utilization and bankruptcy-cost terms as:

```math
c_{\mathrm{util},t}+c_{\mathrm{bankrupt},t}
\approx
(\bar R^K+\tau-1)\frac{1}{\psi}k_y\hat r_t^k
+(\bar R^K-1/\beta)
\left(1-\frac{\bar N}{\bar K}\right)
k_y(\hat R_t^K+\hat Q_{t-1}+\hat K_t).
```

- **(F12) Monetary policy rule**:

```math
\begin{aligned}
\hat R_t^n={}&
\rho\hat R_{t-1}^n
+(1-\rho)\left\{\bar\pi_t+r_\pi(\hat\pi_t-\bar\pi_t)
+r_Y(\hat Y_t-\hat Y_t^p)\right\}\\
&+r_{\Delta\pi}(\hat\pi_t-\hat\pi_{t-1})
+r_{\Delta Y}\left[\hat Y_t-\hat Y_t^p-(\hat Y_{t-1}-\hat Y_{t-1}^p)\right]
+\eta_t^R .
\end{aligned}
```

- **(F13) Fisher relation / real interest-rate identity**:

```math
\hat R_t^n=\hat R_t+E_t\hat\pi_{t+1}.
```

- **(F14) External finance premium definition**:

```math
\widehat{\mathrm{Prem}}_t=E_t\hat R_{t+1}^K-\hat R_t.
```

- **(F15) Flexible-price output objective**:

```math
\hat Y_t^p
\quad\text{is the flexible-price, flexible-wage, frictionless-credit-market equilibrium.}
```

The `.mod` cross-check represents this target with a parallel flexible-price block for $`C^f,L^f,w^f,Y^f,K^f,r^{k,f},I^f,Q^f,R^f`$; these equations are implementation_cross_check, not printed as paper equations.

## 5. Exogenous Processes

- **(F16) Inflation target**:

```math
\bar\pi_t=\bar\pi_{t-1}+\eta_t^\pi .
```

- **(F17) Discount-factor shock**:

```math
\hat\varepsilon_t^B=\rho_B\hat\varepsilon_{t-1}^B+\epsilon_t^B .
```

- **(F18) Labor-supply shock**:

```math
\hat\varepsilon_t^L=\rho_L\hat\varepsilon_{t-1}^L+\epsilon_t^L .
```

- **(F19) Productivity shock**:

```math
\hat\varepsilon_t^A=\rho_A\hat\varepsilon_{t-1}^A+\epsilon_t^A .
```

- **(F20) Investment-specific technology shock**:

```math
\hat\varepsilon_t^I=\rho_I\hat\varepsilon_{t-1}^I+\epsilon_t^I .
```

- **(F21) Government-spending shock**:

```math
\hat\varepsilon_t^G=\rho_G\hat\varepsilon_{t-1}^G+\epsilon_t^G .
```

The AR(1) shock notation and innovation names are cross-checked against `US_DG08_rep.mod`. The paper discusses the structural shocks and prints the inflation-target law; the exact implementation names are not treated as paper-side derivation evidence.

## 6. Steady-State Solution

Because the model is log-linearized, all hatted endogenous variables and persistent shock states have zero steady-state deviations:

```math
\hat C=\hat L=\hat R=\hat w=\hat\pi=\hat Y=\hat K=\hat r^k=\hat I=\hat Q
=\hat R^K=\hat N=\widehat{\mathrm{Prem}}=0.
```

The nonzero steady-state ratios and levels needed by the linear system are calibrated or estimated:

```math
\bar R=1/\beta,\qquad
\bar R^K\ \text{estimated},\qquad
\bar r^k=\bar R^K-1+\tau,\qquad
c_y=\bar C/\bar Y,\qquad
k_y=\bar K/\bar Y,\qquad
\bar K/\bar N\ \text{estimated}.
```

For the baseline MMB implementation, posterior-mode cross-check values include $`\beta=0.99`$, $`\tau=0.025`$, $`\bar R^K=1.0131`$, $`\varepsilon=0.1005`$, $`\gamma=0.9923`$, $`\bar K/\bar N=1.4202`$, $`c_y=0.65`$, and $`k_y=0.17/\tau`$. These are implementation_cross_check calibration values.

## 7. Timing & Form Conventions

- **Form**: `model(linear)` log-linear deviations from steady state.
- **Capital timing**: the paper writes accumulation as $`\hat K_{t+1}`$ depending on $`\hat K_t`$ and $`\hat I_t`$; the `.mod` shifts this to `K = (1-tau)K(-1)+...`, so current implementation capital is predetermined and corresponds to installed capital chosen in the previous period.
- **Return timing**: entrepreneurs buy $`K_{t+1}`$ at $`Q_t`$ and the expected return is $`E_t\hat R_{t+1}^K`$. The `.mod` uses `Rkforward = Rk(+1)` to express this expectation timing.
- **Financial friction**: the external finance premium depends negatively on net worth relative to capital expenditures, equivalently positively on leverage $`\hat Q_t+\hat K_{t+1}-\hat N_{t+1}`$.
- **Flexible target**: the policy output gap uses flexible-price output $`Y^p`$, implemented as `Yf`.
- **Runtime validation**: not performed; no Dynare execution was run for this archive entry.
- **Formula caveats**: paper OCR renders the elasticity symbol as a dash in some prose; this derivation uses $`\varepsilon`$ following the formula and implementation. The investment-shock normalization differs between paper equation (6) and the MMB implementation and is marked `needs_review`.

## 8. Variable & Parameter Reference Table

| Category | Symbol / Dynare name | Meaning | Main equation |
|---|---|---|---|
| Endogenous | $`\hat C_t`$ / `C` | Consumption deviation | (F1) |
| Endogenous | $`\hat L_t`$ / `L` | Labor deviation | (F2), (F4) |
| Endogenous | $`\hat R_t`$ / `R` | Real interest-rate deviation | (F1), (F13) |
| Endogenous | $`\hat w_t`$ / `w` | Real wage deviation | (F2), (F4) |
| Endogenous | $`\hat\pi_t`$ / `pi` | Inflation deviation | (F5), (F12) |
| Endogenous | $`\bar\pi_t`$ / `pibar` | Inflation target | (F12), (F16) |
| Endogenous | $`\hat Y_t`$ / `Y` | Output deviation | (F3), (F11) |
| Endogenous | $`\hat K_t`$ / `K` | Installed capital deviation | (F6) |
| Endogenous | $`\hat r_t^k`$ / `ren` | Rental rate of capital | (F3), (F4), (F8) |
| Endogenous | $`\hat I_t`$ / `I` | Investment deviation | (F7), (F11) |
| Endogenous | $`\hat Q_t`$ / `Q` | Price of installed capital | (F7), (F8), (F9) |
| Endogenous | $`\hat R_t^K`$ / `Rk`, `Rkforward` | Return to capital | (F8), (F9), (F10) |
| Endogenous | $`\hat N_t`$ / `N` | Entrepreneurial net worth | (F10) |
| Endogenous | $`\hat R_t^n`$ / `Rn` | Nominal policy rate | (F12), (F13) |
| Endogenous | $`\widehat{\mathrm{Prem}}_t`$ / `Prem` | External finance premium | (F14) |
| Endogenous | `Cf,Lf,Rf,wf,Yf,Kf,renf,If,Qf` | Flexible-price counterparts | (F15) |
| Exogenous state | $`\hat\varepsilon_t^B`$ / `eps_B` | Discount-factor shock state | (F17) |
| Exogenous state | $`\hat\varepsilon_t^L`$ / `eps_L` | Labor-supply shock state | (F18) |
| Exogenous state | $`\hat\varepsilon_t^A`$ / `eps_A` | Productivity shock state | (F19) |
| Exogenous state | $`\hat\varepsilon_t^I`$ / `eps_I` | Investment-specific shock state | (F20) |
| Exogenous state | $`\hat\varepsilon_t^G`$ / `eps_G` | Government-spending shock state | (F21) |
| Innovation | `eta_w`, `eta_p`, `eta_R`, `etapi` | Wage markup, price markup, rate, target shocks | (F2), (F5), (F12), (F16) |
| Innovation | `epsinno_B`, `epsinno_L`, `epsinno_A`, `epsinno_I`, `epsinno_G` | Persistent shock innovations | (F17)-(F21) |
| Parameter | $`h,\sigma_c,\lambda_w,\beta,\gamma_w,\xi_w,\sigma_l`$ | Household and wage-setting parameters | (F1), (F2) |
| Parameter | $`\alpha,\psi,\gamma_p,\xi_p,\tau,\phi`$ | Production, utilization, price, depreciation, investment-cost parameters | (F3)-(F8) |
| Parameter | $`\bar R^K,\varepsilon,\gamma,\bar K/\bar N`$ | Financial accelerator parameters | (F8)-(F10) |
| Parameter | $`c_y,k_y`$ | Steady-state expenditure and capital-output ratios | (F11) |
| Parameter | $`\rho,r_\pi,r_Y,r_{\Delta\pi},r_{\Delta Y}`$ | Policy-rule parameters | (F12) |
| Parameter | $`\rho_B,\rho_L,\rho_A,\rho_I,\rho_G`$ | Shock persistence parameters | (F17)-(F21) |
