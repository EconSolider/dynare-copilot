# US_JPT11 - Derivation (Optimization Problems + First-Order Conditions)

> Status: needs_review. This is a first-pass archive extraction from MinerU Markdown plus an implementation cross-check. Dynare runtime validation was not performed.

Provenance: `US_JPT11`, Alejandro Justiniano, Giorgio E. Primiceri, and Andrea Tambalotti (2011), "Investment shocks and the relative price of investment," *Review of Economic Dynamics* 14, 102-121, DOI `10.1016/j.red.2010.08.004`. Primary Markdown source: `raw/mmb_mineru/runs/us_jpt11__investment_shocks_and_the_relative_price_of_investment__8d6c49b8/full.md`. Raw PDF: `raw/mmb_papers/Investment shocks and the relative price of investment.pdf`. MinerU run id: `8d6c49b8-f6bc-490f-8ddf-6ab7756b73bc`.

## 1. Model Overview

- **Model**: Medium-scale U.S. New-Neoclassical Synthesis DSGE model with two investment shocks.
- **Economy**: Closed U.S. economy with final consumption goods, differentiated intermediate goods, investment goods, installed capital, households, government, and a monetary authority.
- **Core distinction**: Investment-specific technology (IST) $`\Upsilon_t`$ transforms final goods into investment goods and pins down the relative price of investment. Marginal efficiency of investment (MEI) $`\mu_t`$ transforms investment goods into installed productive capital.
- **Nominal frictions**: Calvo sticky prices with price indexation and Calvo sticky wages with wage indexation.
- **Real frictions**: External habit formation, variable capital utilization, investment adjustment costs, fixed costs in intermediate production, government spending shocks, and intertemporal preference shocks.
- **Shocks**: Neutral technology growth, IST growth, MEI, price markup, wage markup, intertemporal preference, government spending, and monetary policy.
- **Form**: The paper states that the stationary transformed model is log-linearly approximated around the nonstochastic steady state. The implementation cross-check `.agents/skills/dynare-copilot/references/examples/US_JPT11_rep.mod` uses `model(linear)`. This `.mod` file was used only as `implementation_cross_check`, not as a paper-side source.

## 2. Optimization Problems

### 2.1 Final-Good Producers

Competitive final-good firms aggregate differentiated intermediate goods:

```math
Y_t=\left[\int_0^1 Y_t(i)^{\frac{1}{1+\lambda_{p,t}}}\,di\right]^{1+\lambda_{p,t}}.
```

They purchase intermediate goods at prices $`P_t(i)`$ and sell the aggregate at price $`P_t`$.

### 2.2 Intermediate-Goods Producers

Intermediate firm $`i`$ produces with effective capital and labor:

```math
Y_t(i)=\max\left\{A_t^{1-\alpha}K_t(i)^\alpha L_t(i)^{1-\alpha}
-A_t\Upsilon_t^{\frac{\alpha}{1-\alpha}}F,\;0\right\}.
```

Only a fraction $`1-\xi_p`$ can reoptimize its price in a period. Non-reoptimizing firms index prices according to:

```math
P_t(i)=P_{t-1}(i)\pi_{t-1}^{\iota_p}\pi^{1-\iota_p}.
```

A reoptimizing firm chooses $`\tilde P_t(i)`$ to maximize expected discounted profits subject to intermediate-good demand and the production technology:

```math
\max_{\tilde P_t(i)} E_t\sum_{s=0}^{\infty}\xi_p^s
\frac{\beta^s\lambda_{t+s}}{\lambda_t}
\left\{
\tilde P_t(i)\left(\prod_{j=0}^{s}\pi_{t-1+j}^{\iota_p}\pi^{1-\iota_p}\right)Y_{t+s}(i)
-W_{t+s}L_{t+s}(i)-r^k_{t+s}K_{t+s}(i)
\right\}.
```

### 2.3 Investment-Good Producers

Competitive investment-good producers buy $`Y_t^I`$ units of the final good and transform them into investment goods:

```math
\max_{\{I_t,Y_t^I\}} P_{I,t}I_t-P_tY_t^I
\quad\text{s.t.}\quad
I_t=\Upsilon_tY_t^I.
```

### 2.4 Capital-Good Producers

Competitive capital-good producers buy investment goods and transform them into newly installed capital:

```math
i_t=\mu_t\left(1-S\left(\frac{I_t}{I_{t-1}}\right)\right)I_t.
```

They maximize the expected discounted value of profits:

```math
\max_{\{I_t,i_t\}} E_t\sum_{s=0}^{\infty}\beta^s\lambda_{t+s}
\left[P_{k,t+s}i_{t+s}-P_{I,t+s}I_{t+s}\right].
```

### 2.5 Households

Household $`j`$ maximizes:

```math
\max_{\{C_t,L_t(j),B_t,\bar K_t,u_t,W_t(j)\}} E_t\sum_{s=0}^{\infty}\beta^s b_{t+s}
\left[
\log(C_{t+s}-hC_{t+s-1})
-\varphi\frac{L_{t+s}(j)^{1+\nu}}{1+\nu}
\right].
```

The nominal budget constraint is:

```math
P_tC_t+P_{k,t}i_t+T_t+B_t
\le R_{t-1}B_{t-1}+Q_t(j)+\Pi_t+W_t(j)L_t(j)
+r_t^k u_t\bar K_{t-1}
-P_t\frac{a(u_t)}{\Upsilon_t}\bar K_{t-1}.
```

Capital services and physical capital evolve as:

```math
K_t=u_t\bar K_{t-1},
\qquad
\bar K_t=(1-\delta)\bar K_{t-1}+i_t.
```

Households are monopolistic suppliers of specialized labor. Employment agencies aggregate labor:

```math
L_t=\left[\int_0^1 L_t(j)^{\frac{1}{1+\lambda_{w,t}}}\,dj\right]^{1+\lambda_{w,t}}.
```

Non-reoptimizing wages follow:

```math
W_t(j)=W_{t-1}(j)
\left(\pi_{t-1}e^{z_{t-1}+\frac{\alpha}{1-\alpha}\upsilon_t}\right)^{\iota_w}
\left(\pi e^{\gamma_z+\frac{\alpha}{1-\alpha}\gamma_\upsilon}\right)^{1-\iota_w}.
```

### 2.6 Government and Monetary Authority

Government spending is an exogenous time-varying fraction of GDP:

```math
G_t=\left(1-\frac{1}{g_t}\right)Y_t.
```

The monetary authority follows a Taylor-type rule:

```math
\frac{R_t}{R}
=\left(\frac{R_{t-1}}{R}\right)^{\rho_R}
\left[
\left(\frac{\pi_t}{\pi}\right)^{\phi_\pi}
\left(\frac{X_t}{X_t^{\ast}}\right)^{\phi_X}
\right]^{1-\rho_R}
\left[
\frac{X_t/X_{t-1}}{X_t^{\ast}/X_{t-1}^{\ast}}
\right]^{\phi_{dX}}
\varepsilon_{mp,t}.
```

## 3. First-Order Conditions

- **(F1) Final-good price index**:

```math
P_t=\left[\int_0^1 P_t(i)^{-\frac{1}{\lambda_{p,t}}}\,di\right]^{-\lambda_{p,t}}.
```

- **(F2) Demand for intermediate good $`i`$**:

```math
Y_t(i)=\left(\frac{P_t(i)}{P_t}\right)^{-\frac{1+\lambda_{p,t}}{\lambda_{p,t}}}Y_t.
```

- **(F3) Intermediate-firm capital-labor cost condition** needs_review:

```math
\frac{r_t^k}{W_t}
=\frac{\alpha}{1-\alpha}\frac{L_t(i)}{K_t(i)}.
```

This is the standard cost-minimization implication of the production function; the paper gives the optimization problem, while the extracted Markdown does not print this condition in the main model section.

- **(F4) Real marginal cost from factor prices** needs_review:

```math
s_t=\left(\frac{r_t^k}{\alpha}\right)^\alpha
\left(\frac{W_t}{1-\alpha}\right)^{1-\alpha}
A_t^{-(1-\alpha)}.
```

The exact stationary scaling of $`s_t`$ with $`A_t`$ and $`\Upsilon_t`$ should be source-level checked.

- **(F5) Calvo price-setting condition** needs_review:

```math
\tilde P_t(i)\;\text{solves the discounted profit problem in Section 2.2 subject to }(F2).
```

The paper-side Markdown provides the objective but not the explicit recursive Phillips-curve representation. The implementation cross-check uses the log-linear price Phillips curve with price indexation and a price markup shock.

- **(F6) Investment-goods zero-profit / relative price condition**:

```math
\frac{P_{I,t}}{P_t}=\Upsilon_t^{-1}.
```

- **(F7) Installed-capital producer zero-profit condition**:

```math
P_{k,t}i_t=P_t\tilde I_t,
\qquad
\tilde I_t\equiv \frac{P_{I,t}}{P_t}I_t.
```

- **(F8) Capital-good producer intertemporal $`Q`$ condition** needs_review:

```math
P_{I,t}
=P_{k,t}\mu_t
\left[
1-S\left(\frac{I_t}{I_{t-1}}\right)
-S'\left(\frac{I_t}{I_{t-1}}\right)\frac{I_t}{I_{t-1}}
\right]
+E_t\left[
\beta\frac{\lambda_{t+1}}{\lambda_t}
P_{k,t+1}\mu_{t+1}
S'\left(\frac{I_{t+1}}{I_t}\right)
\left(\frac{I_{t+1}}{I_t}\right)^2
\right].
```

The exact normalization of the $`Q`$ condition is first-pass and should be checked against the PDF.

- **(F9) Household marginal utility of consumption with habit** needs_review:

```math
\lambda_t
=b_t(C_t-hC_{t-1})^{-1}
-\beta h\,E_t\left[b_{t+1}(C_{t+1}-hC_t)^{-1}\right].
```

- **(F10) Bond Euler equation** needs_review:

```math
\lambda_t
=\beta E_t\left[\lambda_{t+1}\frac{R_t}{\pi_{t+1}}\right].
```

- **(F11) Capital utilization condition** needs_review:

```math
r_t^k=P_t\frac{a'(u_t)}{\Upsilon_t}.
```

In real terms this equates the marginal rental value of effective capital services to the marginal utilization cost. The paper records utilization cost scaling but the OCR text is noisy around the $`\Upsilon_t`$ symbol.

- **(F12) Physical capital accumulation**:

```math
\bar K_t=(1-\delta)\bar K_{t-1}+i_t.
```

- **(F13) Labor demand for specialized labor $`j`$**:

```math
L_t(j)=\left(\frac{W_t(j)}{W_t}\right)^{-\frac{1+\lambda_{w,t}}{\lambda_{w,t}}}L_t.
```

- **(F14) Aggregate wage index**:

```math
W_t=\left[\int_0^1 W_t(j)^{-\frac{1}{\lambda_{w,t}}}\,dj\right]^{-\lambda_{w,t}}.
```

- **(F15) Optimal reset wage condition** needs_review:

```math
\tilde W_t(j)\;\text{solves the household wage-setting problem subject to }(F13).
```

The paper describes the problem but the MinerU Markdown does not provide a closed-form wage Phillips curve in the model section. The implementation cross-check confirms a log-linear wage Phillips curve with wage markup shocks and indexation.

## 4. Market Clearing & Identities

- **(F16) Effective capital services**:

```math
K_t=u_t\bar K_{t-1}.
```

- **(F17) Investment-goods technology**:

```math
I_t=\Upsilon_tY_t^I.
```

- **(F18) Newly installed capital technology**:

```math
i_t=\mu_t\left(1-S\left(\frac{I_t}{I_{t-1}}\right)\right)I_t.
```

- **(F19) One-sector capital accumulation representation**:

```math
\bar K_t=(1-\delta)\bar K_{t-1}+\mu_t\Upsilon_t(1-S_t)\tilde I_t,
\qquad
S_t\equiv S\left(\frac{I_t}{I_{t-1}}\right).
```

- **(F20) Government spending identity**:

```math
G_t=\left(1-\frac{1}{g_t}\right)Y_t.
```

- **(F21) GDP/output-gap target identity** needs_review:

```math
X_t^{\ast}=\text{flexible-price/wage counterpart of }X_t.
```

The Taylor rule refers to the GDP gap $`X_t/X_t^{\ast}`$. The paper uses the flexible-economy object in the policy rule, while the implementation cross-check includes starred variables for the flexible counterpart.

## 5. Exogenous Processes

- **(F22) Price markup shock**:

```math
\log\lambda_{p,t}
=(1-\rho_p)\log\lambda_p+\rho_p\log\lambda_{p,t-1}
+\varepsilon_{p,t}-\theta_p\varepsilon_{p,t-1}.
```

- **(F23) Neutral technology growth**:

```math
z_t=(1-\rho_z)\gamma_z+\rho_z z_{t-1}+\varepsilon_{z,t}.
```

- **(F24) IST growth**:

```math
\upsilon_t=(1-\rho_\upsilon)\gamma_\upsilon+\rho_\upsilon\upsilon_{t-1}
+\varepsilon_{\upsilon,t}.
```

- **(F25) MEI shock**:

```math
\log\mu_t=\rho_\mu\log\mu_{t-1}+\varepsilon_{\mu,t}.
```

- **(F26) Intertemporal preference shock**:

```math
\log b_t=\rho_b\log b_{t-1}+\varepsilon_{b,t}.
```

- **(F27) Wage markup shock**:

```math
\log\lambda_{w,t}
=(1-\rho_w)\log\lambda_w+\rho_w\log\lambda_{w,t-1}
+\varepsilon_{w,t}-\theta_w\varepsilon_{w,t-1}.
```

- **(F28) Government spending shock**:

```math
\log g_t=(1-\rho_g)\log g+\rho_g\log g_{t-1}+\varepsilon_{g,t}.
```

- **(F29) Monetary policy rule**:

```math
\frac{R_t}{R}
=\left(\frac{R_{t-1}}{R}\right)^{\rho_R}
\left[
\left(\frac{\pi_t}{\pi}\right)^{\phi_\pi}
\left(\frac{X_t}{X_t^{\ast}}\right)^{\phi_X}
\right]^{1-\rho_R}
\left[
\frac{X_t/X_{t-1}}{X_t^{\ast}/X_{t-1}^{\ast}}
\right]^{\phi_{dX}}
\varepsilon_{mp,t}.
```

## 6. Steady-State Solution

The paper solves the model by detrending nonstationary variables, computing the nonstochastic steady state of the transformed model, and log-linearly approximating around that steady state. The full analytic steady-state system is not printed in the main Markdown source, so this section is `needs_review`.

Known steady-state restrictions from the source:

```math
\gamma_\ast=\gamma_z+\frac{\alpha}{1-\alpha}\gamma_\upsilon.
```

```math
S=0,\qquad S'=0,\qquad S''>0.
```

```math
u=1,\qquad a(1)=0,\qquad
\chi=\frac{a''(1)}{a'(1)}.
```

```math
\frac{P_I}{P}=\Upsilon^{-1},
\qquad
\mu=1,
\qquad
\log\lambda_p=\log\lambda_p,
\qquad
\log\lambda_w=\log\lambda_w.
```

The implementation cross-check computes a linear-model steady state internally with calibrated values for $`\alpha`$, $`\delta`$, price and wage indexation, habit, markups, growth rates, policy coefficients, shock persistence, and adjustment-cost parameters. Dynare was not run, and those implementation steady-state definitions are not promoted to paper-side source status.

## 7. Timing & Form Conventions

- **Capital timing**: Physical installed capital $`\bar K_t`$ is a period-end stock. Production at $`t`$ uses effective capital $`K_t=u_t\bar K_{t-1}`$.
- **Investment timing**: $`I_t/I_{t-1}`$ enters adjustment costs, so lagged investment is a state for the capital-producer problem.
- **Technology trends**: Neutral technology $`A_t`$ and IST $`\Upsilon_t`$ are nonstationary in levels. The stationary transformed model uses growth rates $`z_t=\Delta\log A_t`$ and $`\upsilon_t=\Delta\log\Upsilon_t`$.
- **Composite trend**: The balanced-growth trend is $`A_t\Upsilon_t^{\alpha/(1-\alpha)}`$ with steady growth $`\gamma_\ast`$.
- **Relative price convention**: In the competitive baseline, $`P_{I,t}/P_t=\Upsilon_t^{-1}`$. Appendix A shows this equality can fail with sticky prices in both consumption and investment production sectors.
- **Form**: The archive entry is classified as `model(linear)` because the paper says the detrended model is log-linearly approximated and the Rep-MMB implementation uses `model(linear)`.
- **Runtime validation**: Not performed by instruction.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Main equation(s) |
|---|---|---|---|
| Endogenous | $`Y_t`$, `y` | Final output | (F1), (F2), (F20) |
| Endogenous | $`Y_t(i)`$ | Intermediate good variety | (F2) |
| Endogenous | $`P_t`$, `p` | Final-good price index / inflation base | (F1), (F29) |
| Endogenous | $`P_t(i)`$ | Intermediate good price | (F2), (F5) |
| Endogenous | $`s_t`$, `s` | Real marginal cost | (F4), (F5) |
| Endogenous | $`K_t`$, `k` | Effective capital services | (F3), (F16) |
| Endogenous | $`\bar K_t`$, `kbar` | Installed physical capital stock | (F12), (F19) |
| Endogenous | $`L_t`$, `L` | Aggregate labor | (F13), (F14) |
| Endogenous | $`W_t`$, `w` | Aggregate nominal/real wage after normalization | (F13), (F14), (F15) |
| Endogenous | $`C_t`$, `c` | Consumption | (F9), (F10) |
| Endogenous | $`\lambda_t`$, `lambda` | Marginal utility / stochastic discount factor | (F8), (F9), (F10) |
| Endogenous | $`I_t`$, `i` | Investment goods | (F6), (F8), (F17), (F18) |
| Endogenous | $`i_t`$ | Newly installed capital | (F7), (F18) |
| Endogenous | $`\tilde I_t`$ | Real investment in consumption units | (F7), (F19) |
| Endogenous | $`P_{I,t}`$ | Investment-good price | (F6), (F7), (F8) |
| Endogenous | $`P_{k,t}`$, `q` | Price of installed capital / Tobin's Q | (F7), (F8) |
| Endogenous | $`u_t`$, `u` | Capital utilization | (F11), (F16) |
| Endogenous | $`r_t^k`$, `mpk` / `Rk` | Rental rate or return on capital | (F3), (F11) |
| Endogenous | $`G_t`$, `g` | Government spending | (F20), (F28) |
| Endogenous | $`R_t`$, `R` | Gross nominal policy rate | (F10), (F29) |
| Endogenous | $`\pi_t`$, `p` | Gross inflation / log inflation in linear form | (F5), (F29) |
| Endogenous | $`X_t/X_t^{\ast}`$, `gdp-gap` | GDP gap relative to flexible counterpart | (F21), (F29) |
| Exogenous | $`\varepsilon_{z,t}`$, `zs` | Neutral technology growth innovation | (F23) |
| Exogenous | $`\varepsilon_{\upsilon,t}`$, `upsilons` | IST growth innovation | (F24) |
| Exogenous | $`\varepsilon_{\mu,t}`$, `mius` | MEI innovation | (F25) |
| Exogenous | $`\varepsilon_{p,t}`$, `lambdaps` | Price markup innovation | (F22) |
| Exogenous | $`\varepsilon_{w,t}`$, `lambdaws` | Wage markup innovation | (F27) |
| Exogenous | $`\varepsilon_{b,t}`$, `bs` | Intertemporal preference innovation | (F26) |
| Exogenous | $`\varepsilon_{g,t}`$, `gs` | Government spending innovation | (F28) |
| Exogenous | $`\varepsilon_{mp,t}`$, `Rs` | Monetary policy innovation | (F29) |
| Parameter | $`\alpha`$ | Capital share | (F3), (F4), (F23) |
| Parameter | $`\beta`$ | Discount factor | (F5), (F8), (F10) |
| Parameter | $`\delta`$ | Depreciation rate | (F12), (F19) |
| Parameter | $`h`$ | Habit parameter | (F9) |
| Parameter | $`\xi_p,\iota_p`$ | Price rigidity and indexation | (F5) |
| Parameter | $`\xi_w,\iota_w`$ | Wage rigidity and indexation | (F15) |
| Parameter | $`\lambda_p,\lambda_w`$ | Desired price and wage markups | (F22), (F27) |
| Parameter | $`\rho_z,\rho_\upsilon,\rho_\mu,\rho_b,\rho_g,\rho_p,\rho_w`$ | Shock persistence parameters | (F22)-(F28) |
| Parameter | $`\phi_\pi,\phi_X,\phi_{dX},\rho_R`$ | Monetary policy coefficients | (F29) |
| Parameter | $`S(\cdot)`$, $`S'(\cdot)`$ | Investment adjustment-cost function | (F8), (F18), (F19) |
| Parameter | $`\chi`$ | Capital utilization curvature | (F11), Section 6 |
