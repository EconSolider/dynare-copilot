# EA_VI16gk - Derivation

> Purpose: source-backed derivation for a future Dynare implementation. Runtime validation was not performed. First-pass status: `needs_review`.

## 1. Model Overview

- **Model ID**: `EA_VI16gk`.
- **Source**: Stefania Villa (2016), "Financial frictions in the Euro Area and the United States: a Bayesian assessment", *Macroeconomic Dynamics*, 20(05), 1313-1340, DOI `10.1017/s1365100514000881`.
- **Variant**: Euro Area SWGK model, a Smets-Wouters economy with Gertler-Karadi financial-intermediary frictions. The paper estimates the model on quarterly EA data for 1983Q1-2008Q3.
- **Agents and blocks**: households, labor unions, labor packers, retailers, final-good firms, intermediate-good firms, capital producers, financial intermediaries, and the monetary authority.
- **Form**: log-linearized model. Variables with hats are percentage deviations from steady state; variables without time subscripts are steady-state values. The Rep-MMB implementation uses `model(linear)`.
- **Source scope**: the equations below extract the paper's Table 1 SW model equations plus the SWGK financial-intermediary block. Formula quality is mostly readable, but several OCR artifacts in Table 1 are marked `needs_review`.

## 2. Optimization Problems

### Households

Households consume, save, and supply labor. With external habit, the marginal utility object used in the linear model is:

```math
\hat{\mu}_t = \frac{h}{1-h}\hat{C}_{t-1} - \frac{1}{1-h}\hat{C}_t,
\qquad
\hat{\Lambda}_{t,t+1} = \hat{\mu}_{t+1} - \hat{\mu}_t.
```

The Euler equation is recorded in Section 3. Households also contain workers and bankers in the SWGK variant: bankers survive with probability $`\theta`$, exiting bankers become workers, and entering bankers receive a start-up transfer equal to a fraction $`\chi`$ of total assets.

### Labor Unions and Labor Packers

Unions differentiate labor and set wages under Calvo wage stickiness with indexation. Competitive labor packers aggregate differentiated labor and sell the composite input to intermediate-good firms.

### Retailers and Final-Good Firms

Retailers differentiate goods and set prices under Calvo price stickiness with indexation. Final-good firms aggregate intermediate goods. The paper presents the log-linear price Phillips curve directly.

### Intermediate-Good Firms and Capital Producers

Intermediate-good firms rent effective capital and labor to produce output. Capital producers transform investment and depreciated capital into capital sold for use in production, with investment adjustment costs. In the SWGK variant, intermediate-good firms finance capital purchases through financial intermediaries.

### Financial Intermediaries

Each banker manages a financial intermediary. The moral-hazard friction is that bankers can divert a fraction $`\lambda`$ of available funds. Depositors therefore impose an incentive constraint, so assets acquired by the intermediary depend positively on banker net worth. The linearized asset-value, net-worth-value, leverage, and net-worth equations are listed in Section 3.

## 3. First-Order Conditions

**(F1) Consumption Euler equation**

```math
\frac{1+h}{1-h}\hat{C}_t =
\frac{1}{1-h}E_t[\hat{C}_{t+1}]
+ \frac{h}{1-h}\hat{C}_{t-1}
- \hat{R}_t.
```

**(F2) Wage Phillips curve**

```math
\hat{W}_t =
\frac{\beta}{1+\beta}E_t[\hat{W}_{t+1}]
+ \frac{1}{1+\beta}\hat{W}_{t-1}
+ \frac{\beta}{1+\beta}E_t[\hat{\Pi}_{t+1}]
- \frac{1+\beta\sigma_{wi}}{1+\beta}\hat{\Pi}_t
+ \frac{\sigma_{wi}}{1+\beta}\hat{\Pi}_{t-1}
+ \frac{1}{1+\beta}
\frac{(1-\beta\sigma_w)(1-\sigma_w)}
{(1+\varepsilon_w\phi)\sigma_w}
\left[
\phi\hat{L}_t - \frac{h}{1-h}\hat{C}_{t-1}
+ \frac{1}{1-h}\hat{C}_t - \hat{W}_t
\right]
+ \varepsilon_t^w.
```

**(F3) Capital accumulation**

```math
\hat{K}_{t+1}
= \delta(\hat{I}_t + \varepsilon_t^x)
+ (1-\delta)(\hat{K}_t + \varepsilon_t^k).
```

**(F4) Optimal capital utilization**

```math
\hat{Z}^k_t = \frac{\zeta}{1-\zeta}\hat{U}_t.
```

**(F5) Investment Euler equation**

```math
\hat{I}_t =
\frac{1}{\xi(1+\beta)}(\hat{Q}_t+\varepsilon_t^x)
+ \frac{1}{1+\beta}\hat{I}_{t-1}
+ \frac{\beta}{1+\beta}E_t[\hat{I}_{t+1}].
```

**(F6) Production-side factor FOC**

```math
\hat{W}_t = \hat{Z}^k_t - \hat{L}_t + \hat{K}_t + \hat{U}_t.
```

**(F7) Price Phillips curve**

```math
\hat{\Pi}_t =
\frac{\sigma_{pi}}{1+\sigma_{pi}\beta}\hat{\Pi}_{t-1}
+ \frac{\beta}{1+\sigma_{pi}\beta}E_t[\hat{\Pi}_{t+1}]
- \frac{(1-\beta\sigma_p)(1-\sigma_p)}
{(1+\sigma_{pi}\beta)\sigma_p}
\left[
\varepsilon_t^a - \alpha\hat{Z}^k_t - (1-\alpha)\hat{W}_t
\right]
+ \varepsilon_t^p.
```

**(F8) Price of capital in the SWGK block**

```math
\hat{R}^k_t =
\frac{Z^k}{R^k}\hat{Z}^k_t
+ \frac{1-\delta}{R^k}(\hat{Q}_t+\varepsilon_t^k)
- \hat{Q}_{t-1}.
```

**(F9) Gain from expanding assets**

```math
\hat{V}_t =
\frac{(1-\theta)\beta}{V}(R^k-R)E_t[\hat{\Lambda}_{t,t+1}]
+ \frac{(1-\theta)\beta}{V}
\left[
R^k E_t[\hat{R}^k_{t+1}] - R\hat{R}_t
\right]
+ \theta\beta X E_t[
\hat{X}_{t,t+1}+\hat{V}_{t+1}+\hat{\Lambda}_{t,t+1}
].
```

**(F10) Value of expanding net worth**

```math
\hat{D}_t =
\theta\beta Z E_t[
\hat{\Lambda}_{t,t+1}+\hat{Z}_{t,t+1}+\hat{D}_{t+1}
].
```

**(F11) Gross growth rate of net worth**

```math
\hat{Z}_{t,t+1} =
\frac{1}{Z}
\left[
\operatorname{lev} R^k E_t[\hat{R}^k_{t+1}]
+ R(1-\operatorname{lev})\hat{R}_t
+ (R^k-R)\operatorname{lev}\,\widehat{\operatorname{lev}}_t
\right].
```

**(F12) Gross growth rate in assets**

```math
\hat{X}_{t,t+1}
= E_t[\widehat{\operatorname{lev}}_{t+1}]
+ \hat{Z}_{t,t+1}
- \widehat{\operatorname{lev}}_t.
```

The source OCR renders this equation as `lev t+1`; the expression above follows the equation label and implementation cross-check. Status: `needs_review`.

**(F13) Leverage**

```math
\widehat{\operatorname{lev}}_t =
\hat{D}_t + \frac{V}{\lambda-V}\hat{V}_t.
```

The Rep-MMB file shifts this relation one period forward for determinacy; the paper table states it at $`t`$. Status: `needs_review` for runtime timing.

**(F14) FI incentive/balance-sheet constraint**

```math
\hat{K}_{t+1} + \hat{Q}_t =
\widehat{\operatorname{lev}}_t + \hat{N}_t.
```

The source OCR splits `lev`; the implementation confirms the intended leverage variable.

**(F15) Net worth of existing financial intermediaries**

```math
\hat{N}^e_t =
\hat{N}_{t-1}
+ \frac{1}{Z}
\left[
\operatorname{lev} R^k E_t[\hat{R}^k_{t+1}]
+ R(1-\operatorname{lev})\hat{R}_t
+ (R^k-R)\operatorname{lev}\,\widehat{\operatorname{lev}}_t
\right].
```

**(F16) Net worth of new financial intermediaries**

```math
\hat{N}^n_t = \hat{Q}_t + \hat{K}_t.
```

**(F17) Total net worth**

```math
\hat{N}_t =
\frac{N^e}{Y}\frac{Y}{N}\hat{N}^e_t
+ \frac{N^n}{Y}\frac{Y}{N}\hat{N}^n_t.
```

**(F18) External finance premium / spread**

```math
\widehat{EP}_t = E_t[\hat{R}^k_{t+1}] - \hat{R}_t.
```

## 4. Market Clearing & Identities

**(F19) Resource constraint**

```math
\hat{Y}_t =
\frac{C}{Y}\hat{C}_t
+ \frac{I}{Y}\hat{I}_t
+ \frac{G}{Y}\varepsilon_t^g
+ Z^k\frac{K}{Y}\hat{U}_t.
```

**(F20) Production function**

```math
\hat{Y}_t =
\Theta
\left[
\varepsilon_t^a
+ \alpha(\varepsilon_t^k+\hat{K}_t+\hat{U}_t)
+ (1-\alpha)\hat{L}_t
\right].
```

**(F21) Taylor rule**

```math
\hat{R}^n_t =
\rho_i\hat{R}^n_{t-1}
+ (1-\rho_i)
\left[
\rho_\pi\hat{\Pi}_t
+ \rho_y(\hat{Y}_t-\hat{Y}^p_t)
\right]
+ \rho_{\Delta y}
\left[
\hat{Y}_t-\hat{Y}^p_t-(\hat{Y}_{t-1}-\hat{Y}^p_{t-1})
\right]
+ \varepsilon_t^r.
```

**(F22) Fisher equation**

```math
\hat{R}^n_t = \hat{R}_t + E_t[\hat{\Pi}_{t+1}].
```

**(F23) Employment Phillips curve**

```math
\hat{E}_t =
\frac{1}{1+\beta}\hat{E}_{t-1}
+ \frac{\beta}{1+\beta}E_t[\hat{E}_{t+1}]
- \frac{(1-\beta\sigma_E)(1-\sigma_E)}
{(1+\beta)\sigma_E}
(\hat{L}_t-\hat{E}_t).
```

The Rep-MMB implementation places this equation with measurement equations. It is retained here because the paper's Table 1 lists it as model equation (12).

## 5. Exogenous Processes

The paper states seven orthogonal AR(1) shocks: technology, investment-specific technology, monetary policy, capital quality, government spending, price mark-up, and wage mark-up. The process equations are not printed in full in the main text; the Rep-MMB implementation cross-check uses:

```math
\varepsilon^a_t = \rho_a \varepsilon^a_{t-1} + \eta^a_t,\quad
\varepsilon^x_t = \rho_x \varepsilon^x_{t-1} + \eta^x_t,\quad
\varepsilon^g_t = \rho_g \varepsilon^g_{t-1} + \eta^g_t,
```

```math
\varepsilon^r_t = \rho_{ri}\varepsilon^r_{t-1} + \eta^r_t,\quad
\varepsilon^p_t = \rho_p\varepsilon^p_{t-1} + \eta^p_t,\quad
\varepsilon^w_t = \rho_w\varepsilon^w_{t-1} + \eta^w_t,\quad
\varepsilon^k_t = \rho_k\varepsilon^k_{t-1} + \eta^k_t.
```

Because the main paper text does not print each AR(1) equation, this block is `implementation_cross_check` and `needs_review` against the online appendix.

## 6. Steady-State Solution

For the linearized model, all hatted endogenous variables are zero in deterministic steady state. Steady-state constants are used as coefficients:

1. Set $`\hat{C}=\hat{I}=\hat{Y}=\hat{L}=\hat{W}=\hat{\Pi}=\hat{R}=\hat{R}^n=\hat{Q}=\hat{K}=\hat{U}=0`$ and all shock innovations to zero.
2. Common calibration from the paper: $`\beta=0.99`$, $`\alpha=0.33`$, $`\delta=0.025`$, $`G/Y=0.20`$, goods and wage elasticities target markups of 1.20.
3. SWGK financial calibration: survival rate $`\theta=0.972`$, annualized steady-state spread of 150 basis points, leverage ratio $`K/N=4`$, $`\chi=0.001`$, and $`\lambda=0.515`$.
4. EA SWGK posterior means used as estimated coefficients include $`\sigma_p=0.84`$, $`\sigma_w=0.78`$, $`\sigma_{pi}=0.15`$, $`\sigma_{wi}=0.39`$, $`\sigma_E=0.80`$, $`\xi=4.95`$, $`\zeta=0.95`$, $`h=0.65`$, $`\Theta=1.40`$, $`\phi=1.49`$, $`\rho_\pi=1.73`$, $`\rho_y=0.09`$, $`\rho_{\Delta y}=0.08`$, $`\rho_i=0.89`$, trend growth $`0.30`$, steady inflation $`0.63`$, and shock persistence/standard-deviation estimates listed in Table 5.
5. The Rep-MMB implementation computes derived constants such as $`R=1/\beta`$, $`Z^k=R^k-(1-\delta)`$, factor ratios, expenditure shares, banker net-worth shares, leverage, $`Z`$, $`X`$, and $`V`$ before the `model(linear)` block.

No nonlinear steady-state solve or Dynare validation was performed for this derivation.

## 7. Timing & Form Conventions

- Variables with hats denote log or percentage deviations from steady state; the main text explicitly states this convention after Table 1.
- The model is linearized and suitable for Dynare `model(linear)`.
- Capital in the paper table is written with $`\hat{K}_{t+1}`$ in the accumulation equation and $`\hat{K}_t`$ in production. The Rep-MMB file shifts some indices to match its internal timing, including a note that equation 18b is shifted forward for determinacy and equation 19 uses static capital instead of forward-looking capital. These are `needs_review` runtime timing issues.
- The SWGK financial block uses expected next-period capital returns in spread, net-worth-growth, and asset-value equations.
- Measurement equations map observed GDP, consumption, investment, real wage growth, employment/hours, inflation, and nominal interest rate to model variables; they are not counted in F1-F23.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Main equation(s) |
|---|---|---|---|
| Endogenous | $`\hat{C}_t`$ / `c` | Consumption | (F1), (F19) |
| Endogenous | $`\hat{\mu}_t`$ / `mu` | Marginal utility object | Section 2 |
| Endogenous | $`\hat{\Lambda}_{t,t+1}`$ / `Lambda` | Stochastic discount factor change | (F9), (F10) |
| Endogenous | $`\hat{W}_t`$ / `w` | Real wage | (F2), (F6), (F7) |
| Endogenous | $`\hat{L}_t`$ / `l` | Labor input | (F2), (F6), (F20), (F23) |
| Endogenous | $`\hat{E}_t`$ / `emp` | Employment observable state | (F23) |
| Endogenous | $`\hat{I}_t`$ / `i` | Investment | (F5), (F19) |
| Endogenous | $`\hat{K}_t`$ / `k` | Capital stock | (F3), (F14), (F16), (F20) |
| Endogenous | $`\hat{U}_t`$ / `u` | Utilization | (F4), (F19), (F20) |
| Endogenous | $`\hat{Z}^k_t`$ / `zk` | Marginal product/user cost of capital | (F4), (F6), (F7), (F8) |
| Endogenous | $`\hat{Q}_t`$ / `q` | Price of capital | (F5), (F8), (F14), (F16) |
| Endogenous | $`\hat{Y}_t`$ / `y` | Output | (F19), (F20), (F21) |
| Endogenous | $`\hat{\Pi}_t`$ / `pi` | Inflation | (F7), (F22) |
| Endogenous | $`\hat{R}_t`$ / `r` | Real interest rate | (F1), (F9), (F11), (F18), (F22) |
| Endogenous | $`\hat{R}^n_t`$ / `rn` | Nominal interest rate | (F21), (F22) |
| Endogenous | $`\hat{R}^k_t`$ / `rk` | Return on capital | (F8), (F9), (F11), (F15), (F18) |
| Endogenous | $`\hat{V}_t`$ / `v` | Gain from expanding assets | (F9), (F13) |
| Endogenous | $`\hat{D}_t`$ / `d` | Value of expanding net worth | (F10), (F13) |
| Endogenous | $`\widehat{lev}_t`$ / `lev` | Financial intermediary leverage | (F11), (F12), (F13), (F14), (F15) |
| Endogenous | $`\hat{X}_{t,t+1}`$ / `x` | Gross growth rate of assets | (F9), (F12) |
| Endogenous | $`\hat{Z}_{t,t+1}`$ / `z` | Gross growth rate of net worth | (F10), (F11), (F15) |
| Endogenous | $`\hat{N}_t`$ / `n` | Total FI net worth | (F14), (F15), (F17) |
| Endogenous | $`\hat{N}^e_t`$ / `ne` | Existing FI net worth | (F15), (F17) |
| Endogenous | $`\hat{N}^n_t`$ / `nn` | New FI net worth | (F16), (F17) |
| Endogenous | $`\widehat{EP}_t`$ / `ext_pr` | Spread / external finance premium | (F18) |
| Endogenous | $`\hat{Y}^p_t`$ / `yf` | Flexible-price output | (F21), flexible-price block |
| Exogenous state | $`\varepsilon^a_t`$ / `eps_a`, `a` | Technology shock/state | (F20), Section 5 |
| Exogenous state | $`\varepsilon^x_t`$ / `eps_x` | Investment-specific shock/state | (F3), (F5), Section 5 |
| Exogenous state | $`\varepsilon^g_t`$ / `g` | Government spending shock/state | (F19), Section 5 |
| Exogenous state | $`\varepsilon^r_t`$ / `eps_r` | Monetary policy shock/state | (F21), Section 5 |
| Exogenous state | $`\varepsilon^p_t`$ / `eps_p` | Price mark-up shock/state | (F7), Section 5 |
| Exogenous state | $`\varepsilon^w_t`$ / `eps_w` | Wage mark-up shock/state | (F2), Section 5 |
| Exogenous state | $`\varepsilon^k_t`$ / `eps_k` | Capital quality shock/state | (F3), (F8), (F20), Section 5 |
| Parameters | $`\beta,\alpha,\delta,G/Y,\varepsilon,\varepsilon_w`$ | Common calibration | Section 6 |
| Parameters | $`\sigma_p,\sigma_w,\sigma_{pi},\sigma_{wi},\sigma_E,\xi,\zeta,h,\Theta,\phi`$ | Nominal, real, and preference frictions | (F2), (F4), (F5), (F7), (F23) |
| Parameters | $`\rho_\pi,\rho_y,\rho_{\Delta y},\rho_i`$ | Monetary policy coefficients | (F21) |
| Parameters | $`\theta,\chi,\lambda,\operatorname{lev},R^k,R,Z,X,V,N^e/Y,N^n/Y`$ | SWGK financial-intermediary constants | (F9)-(F18) |
| Parameters | $`\rho_a,\rho_x,\rho_g,\rho_{ri},\rho_p,\rho_w,\rho_k`$ | Shock persistence | Section 5 |
