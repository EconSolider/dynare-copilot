# US_VGMP15 -- Derivation (Optimization Problems + First-Order Conditions)

> First-pass private archive entry. Status: `needs_review`. Runtime validation was not performed.

## 1. Model Overview

- **Model ID**: `US_VGMP15`.
- **Source**: Veronica Acurio Vasconez, Gael Giraud, Florent Mc Isaac, and Ngoc-Sang Pham (2015), "The effects of oil price shocks in a new-Keynesian framework with capital accumulation," *Energy Policy* 86, 844-854, DOI `10.1016/j.enpol.2015.04.016`.
- **Source files**: primary OCR Markdown `raw/mmb_mineru/runs/us_vgmp15__the_effects_of_oil_price_shocks_in_a_new_keynesian_framework_with_capita__b2b0e207/full.md`; raw PDF `raw/mmb_papers/The effects of oil price shocks in a new-Keynesian framework with capital accumulation.pdf`.
- **Agents**: representative household, final-good bundler, Calvo intermediate-good firms, central bank, and government.
- **Core mechanism**: imported oil enters household consumption and intermediate-good production. The model adds capital accumulation and an exogenous real capital price to a New Keynesian oil-shock framework, allowing energy output elasticity and cost share to differ.
- **Economy**: U.S. quarterly model estimated on 1984:Q1-2007:Q1 data.
- **Model form**: source states that estimation uses a log-linear version around steady state in the online appendix. The local archive lacks that appendix normalization, so this derivation records source-stated nonlinear/static relations plus normalized first-pass equilibrium conditions. Appendix-only log-linear equations are marked `needs_review`.
- **Experiments**: Bayesian estimation and oil-price shock simulations; six potential shocks are real oil price, real capital price, government spending, monetary policy, price markup, and technology.

## 2. Optimization Problems

### Household

The representative household chooses final-good consumption, oil consumption, labor, capital accumulation, and bonds. Period utility is source-stated as

```math
u(C_t,L_t)=\ln C_t-\frac{L_t^{1+\phi}}{1+\phi}.
```

Composite consumption combines oil and domestic final consumption:

```math
C_t=\Theta_x C_{e,t}^{x}C_{q,t}^{1-x},\qquad
\Theta_x=x^{-x}(1-x)^{-(1-x)}.
```

The nominal budget constraint is

```math
P_{e,t}C_{e,t}+P_{q,t}C_{q,t}+P_{k,t}\bigl(K_{t+1}-(1-\delta)K_t\bigr)+B_t
\leq (1+i_{t-1})B_{t-1}+W_tL_t+D_t+r_t^k P_{k,t}K_t+T_t.
```

Capital accumulation is source-stated as

```math
I_t=K_{t+1}-(1-\delta)K_t.
```

### Final-Good Firm

The final-good firm buys differentiated intermediate goods and produces a composite final good:

```math
Q_t=\left(\int_0^1 Q_t(i)^{(\epsilon-1)/\epsilon}\,di\right)^{\epsilon/(\epsilon-1)}.
```

It chooses the continuum of inputs $`Q_t(i)`$ to minimize expenditure for a given $`Q_t`$.

### Intermediate-Good Firms

Intermediate firm $`i`$ produces with imported oil, labor, and capital:

```math
Q_t(i)=A_t E_t(i)^{\alpha_e}L_t(i)^{\alpha_l}K_t(i)^{\alpha_k},\qquad
\alpha_e,\alpha_l,\alpha_k\geq0.
```

Because returns to scale may exceed one, the paper uses marginal-cost pricing rather than relying on profit maximization as a sufficient condition. Conditional factor demands satisfy the source-stated marginal-cost equalities.

The second stage is Calvo price setting. The paper says the full pricing-rule derivation is in the online appendix; the local MinerU Markdown does not include that appendix. The Phillips curve below is therefore `needs_review`.

### Central Bank and Government

The central bank sets the nominal short rate with a Taylor rule. The government issues bonds, taxes households, and follows an exogenous real-spending process.

## 3. First-Order Conditions

- **(F1) Household oil/final-good expenditure split**:

```math
P_{e,t}C_{e,t}=xP_{c,t}C_t.
```

- **(F2) Household domestic final-good expenditure split**:

```math
P_{q,t}C_{q,t}=(1-x)P_{c,t}C_t.
```

- **(F3) CPI aggregator**:

```math
P_{c,t}=P_{e,t}^{x}P_{q,t}^{1-x}.
```

- **(F4) Bond Euler equation, normalized first-pass condition (`needs_review`)**:

```math
\frac{1}{P_{c,t}C_t}
=\beta E_t\left[\frac{1+i_t}{P_{c,t+1}C_{t+1}}\right].
```

- **(F5) Labor supply, normalized first-pass condition (`needs_review`)**:

```math
L_t^{\phi}=\frac{W_t}{P_{c,t}C_t}.
```

- **(F6) Capital Euler / no-arbitrage condition, normalized first-pass condition (`needs_review`)**:

```math
S_{k,t}
=\beta E_t\left[\frac{C_t}{C_{t+1}}\frac{P_{c,t}}{P_{c,t+1}}
\left(r_{t+1}^{k}S_{k,t+1}+(1-\delta)S_{k,t+1}\right)\right],
\qquad S_{k,t}=\frac{P_{k,t}}{P_{q,t}}.
```

- **(F7) Final-good demand for variety $`i`$, source-implied CES demand**:

```math
Q_t(i)=\left(\frac{P_t(i)}{P_{q,t}}\right)^{-\epsilon}Q_t.
```

- **(F8) Final-good price index, source-implied CES dual**:

```math
P_{q,t}=\left(\int_0^1 P_t(i)^{1-\epsilon}\,di\right)^{1/(1-\epsilon)}.
```

- **(F9) Intermediate-firm oil demand / marginal-cost pricing**:

```math
mc_t(i)=\frac{P_{e,t}}{\alpha_e Q_t(i)/E_t(i)}.
```

- **(F10) Intermediate-firm labor demand / marginal-cost pricing**:

```math
mc_t(i)=\frac{W_t}{\alpha_l Q_t(i)/L_t(i)}.
```

- **(F11) Intermediate-firm capital demand / marginal-cost pricing**:

```math
mc_t(i)=\frac{r_t^k P_{k,t}}{\alpha_k Q_t(i)/K_t(i)}.
```

- **(F12) Calvo price-setting / New Keynesian Phillips relation (`needs_review`)**:

```math
\hat{\Pi}_{q,t}
=\beta E_t[\hat{\Pi}_{q,t+1}]
\kappa\widehat{mc}_t+\varepsilon_{p,t}.
```

The source states that the full pricing rule is in the online appendix; this local entry records the generic log-linear representation only for review.

## 4. Market Clearing & Identities

- **(F13) Capital accumulation**:

```math
I_t=K_{t+1}-(1-\delta)K_t.
```

- **(F14) Domestic output production**:

```math
Q_t(i)=A_t E_t(i)^{\alpha_e}L_t(i)^{\alpha_l}K_t(i)^{\alpha_k}.
```

- **(F15) Real GDP definition with imported oil subtraction**:

```math
P_{y,t}Y_t=P_{q,t}Q_t-P_{e,t}E_t.
```

- **(F16) GDP deflator convention**:

```math
P_{y,t}=P_{c,t}.
```

- **(F17) Government budget constraint**:

```math
(1+i_{t-1})B_{t-1}+G_t=B_t+T_t.
```

## 5. Exogenous Processes

- **(F18) Real oil price process**:

```math
\ln S_{e,t}=(1-\rho_{se})\ln \bar{S}_e+\rho_{se}\ln S_{e,t-1}+e_{se,t},
\qquad S_{e,t}=\frac{P_{e,t}}{P_{q,t}}.
```

- **(F19) Real capital price process**:

```math
\ln S_{k,t}=(1-\rho_{sk})\ln \bar{S}_k+\rho_{sk}\ln S_{k,t-1}+e_{sk,t}.
```

- **(F20) TFP process**:

```math
\ln A_t=\rho_a\ln A_{t-1}+e_{a,t}.
```

- **(F21) Monetary policy rule**:

```math
\frac{1+i_t}{1+\bar{i}}
=\left(\frac{\Pi_{q,t}}{\bar{\Pi}}\right)^{\phi_{\pi}}
\left(\frac{Y_t}{\bar{Y}}\right)^{\phi_y}\varepsilon_{i,t}.
```

- **(F22) Monetary policy shock process**:

```math
\ln\varepsilon_{i,t}=\rho_i\ln\varepsilon_{i,t-1}+e_{i,t}.
```

- **(F23) Real government spending process**:

```math
\ln G_{r,t}=(1-\rho_g)\ln(\omega\bar{Q})+\rho_g\ln G_{r,t-1}+\rho_{ag}e_{a,t}+e_{g,t}.
```

The simulation section also mentions a price-markup shock. Its exact equation is Appendix-only in the available sources and is `needs_review`.

## 6. Steady-State Solution

The paper estimates a log-linear version around steady state but the local Markdown does not contain the full appendix steady-state block. First-pass steady-state information is therefore partial and `needs_review`.

- Set exogenous means: $`\bar{A}=1`$, $`\bar{S}_e`$ and $`\bar{S}_k`$ as estimated/calibrated steady-state real prices, and shocks $`e_{se}=e_{sk}=e_a=e_i=e_g=0`$.
- Government spending satisfies $`\bar{G}_r=\omega\bar{Q}`$, with source calibration $`\omega=0.18`$.
- Capital evolves with $`\bar{I}=\delta\bar{K}`$ from (F13), with source calibration $`\delta=0.025`$.
- The steady-state markup implied by $`\epsilon=8`$ is approximately $`8/7\simeq1.14`$.
- Steady-state GDP obeys $`\bar{P}_y\bar{Y}=\bar{P}_q\bar{Q}-\bar{P}_e\bar{E}`$ and $`\bar{P}_y=\bar{P}_c`$.
- Household oil and domestic-final expenditure shares are $`x`$ and $`1-x`$ from (F1)-(F3).
- Estimation reports two relevant parameter regimes: $`\theta`$ estimated, with high posterior price stickiness near 0.96-0.98, and $`\theta`$ calibrated at 0.65.
- Source calibrations include $`\beta=0.99`$, $`\delta=0.025`$, $`\omega=0.18`$, and $`\epsilon=8`$.

## 7. Timing & Form Conventions

- **Capital timing**: the paper writes $`I_t=K_{t+1}-(1-\delta)K_t`$, so $`K_t`$ is the capital stock entering period-$`t`$ rental income and $`K_{t+1}`$ is chosen at $`t`$.
- **Prices**: $`S_{e,t}=P_{e,t}/P_{q,t}`$ and $`S_{k,t}=P_{k,t}/P_{q,t}`$ are exogenous real relative prices.
- **Inflation**: monetary policy responds to core inflation $`\Pi_{q,t}`$.
- **GDP deflator**: the model sets $`P_{y,t}=P_{c,t}`$ and defines GDP as domestic output net of imported oil cost.
- **Form**: estimated model is log-linear around steady state; this first pass keeps source nonlinear identities where stated and marks missing log-linear appendix equations as `needs_review`.
- **Runtime validation**: Dynare was not run.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Main equation(s) |
|---|---|---|---|
| Endogenous | `C`, $`C_t`$ | composite consumption | (F1)-(F5) |
| Endogenous | `Ce`, $`C_{e,t}`$ | household oil consumption | (F1) |
| Endogenous | `Cq`, $`C_{q,t}`$ | domestic final-good consumption | (F2) |
| Endogenous | `L`, $`L_t`$ | labor | (F5), (F10), (F14) |
| Endogenous | `K`, $`K_t`$ | capital stock | (F6), (F11), (F13), (F14) |
| Endogenous | `I`, $`I_t`$ | investment | (F13) |
| Endogenous | `B`, $`B_t`$ | government bonds | (F4), (F17) |
| Endogenous | `Q`, $`Q_t`$ | domestic final output | (F7), (F14), (F15) |
| Endogenous | `Y`, $`Y_t`$ | real GDP | (F15), (F21) |
| Endogenous | `mc`, $`mc_t`$ | marginal cost | (F9)-(F12) |
| Endogenous | `rk`, $`r_t^k`$ | real rental rate of capital | (F6), (F11) |
| Endogenous | `Pc`, $`P_{c,t}`$ | CPI | (F3), (F16) |
| Endogenous | `Pq`, $`P_{q,t}`$ | core/final-good price | (F3), (F8), (F18), (F19) |
| Endogenous | `Py`, $`P_{y,t}`$ | GDP deflator | (F15), (F16) |
| Endogenous | `Pi_q`, $`\Pi_{q,t}`$ | core inflation | (F12), (F21) |
| Endogenous | `i`, $`i_t`$ | nominal short rate | (F4), (F17), (F21) |
| Endogenous | `T`, $`T_t`$ | taxes | (F17) |
| Endogenous | `G_r`, $`G_{r,t}`$ | real government spending | (F23) |
| Exogenous/state | `Se`, $`S_{e,t}`$ | real oil price | (F18) |
| Exogenous/state | `Sk`, $`S_{k,t}`$ | real capital price | (F6), (F19) |
| Exogenous/state | `A`, $`A_t`$ | TFP | (F20) |
| Exogenous shock | `e_se` | oil price innovation | (F18) |
| Exogenous shock | `e_sk` | capital price innovation | (F19) |
| Exogenous shock | `e_a` | TFP innovation | (F20), (F23) |
| Exogenous shock | `e_i` | monetary policy innovation | (F22) |
| Exogenous shock | `e_g` | government spending innovation | (F23) |
| Exogenous shock | `eps_p` | price markup innovation | (F12), `needs_review` |
| Parameter | `beta`, $`\beta`$ | discount factor; calibrated 0.99 | (F4), (F6), (F12) |
| Parameter | `delta`, $`\delta`$ | depreciation; calibrated 0.025 | (F6), (F13) |
| Parameter | `omega`, $`\omega`$ | government output share; calibrated 0.18 | (F23) |
| Parameter | `epsilon`, $`\epsilon`$ | substitution elasticity; calibrated 8 | (F7), (F8) |
| Parameter | `x`, $`x`$ | oil share in household consumption | (F1)-(F3) |
| Parameter | `phi`, $`\phi`$ | inverse Frisch elasticity | (F5) |
| Parameter | `alpha_e`, $`\alpha_e`$ | oil output elasticity | (F9), (F14) |
| Parameter | `alpha_l`, $`\alpha_l`$ | labor output elasticity | (F10), (F14) |
| Parameter | `alpha_k`, $`\alpha_k`$ | capital output elasticity | (F11), (F14) |
| Parameter | `theta`, $`\theta`$ | Calvo non-reset probability | (F12) |
| Parameter | `phi_pi`, $`\phi_\pi`$ | Taylor response to inflation | (F21) |
| Parameter | `phi_y`, $`\phi_y`$ | Taylor response to output | (F21) |
| Parameter | `rho_se`, $`\rho_{se}`$ | oil price persistence | (F18) |
| Parameter | `rho_sk`, $`\rho_{sk}`$ | capital price persistence | (F19) |
| Parameter | `rho_a`, $`\rho_a`$ | TFP persistence | (F20) |
| Parameter | `rho_i`, $`\rho_i`$ | monetary policy shock persistence | (F22) |
| Parameter | `rho_g`, $`\rho_g`$ | government spending persistence | (F23) |
| Parameter | `rho_ag`, $`\rho_{ag}`$ | government spending response to TFP innovation | (F23) |
