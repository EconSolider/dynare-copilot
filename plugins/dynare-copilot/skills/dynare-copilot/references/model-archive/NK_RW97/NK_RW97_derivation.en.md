# NK_RW97 - Derivation (Rotemberg-Woodford New Keynesian Model)

> Model archive entry for `NK_RW97`. Status: `needs_review`. Runtime validation was not performed; Dynare was not run.

## 1. Model Overview

- **Model**: Rotemberg and Woodford (1997), "An Optimization-Based Econometric Framework for the Evaluation of Monetary Policy."
- **Model ID**: `NK_RW97`.
- **Source**: `raw/mmb_mineru/runs/nk_rw97_nk_rw97al__an_optimization_based_econometric_framework_for_the_evaluation_of_moneta__af3fb04e/full.md`; DOI `10.1086/654340`.
- **Purpose**: A small optimization-based econometric model for evaluating monetary policy rules using output, inflation, and the federal funds rate.
- **Agents/blocks**: Representative households that consume a CES aggregate and produce differentiated goods, Calvo-style price setters with decision lags, a monetary authority following an estimated interest-rate feedback rule, and exogenous autonomous-spending and natural-output disturbances.
- **Core variables**: inflation $`\hat{\pi}_t`$, output $`\hat{Y}_t`$, nominal interest rate $`\hat{R}_t`$, long real rate $`\hat{r}^l_t`$, relative reset-price variable $`\hat{X}_t`$, autonomous-spending disturbance $`\hat{G}_t`$, and natural-output disturbance $`\hat{Y}^s_t`$.
- **Form**: Log-linear approximation around a zero-inflation steady state. The MMB cross-check implementation is `model(linear)`.

## 2. Optimization Problems

### 2.1 Representative Household

Household $`i`$ chooses purchases of a CES aggregate and production of its differentiated good to maximize expected utility:

```math
E_0\sum_{t=0}^{\infty}\beta^t\left[u(C^i_t;\xi_t)-v(y^i_t;\xi_t)\right].
```

The CES consumption aggregate is:

```math
C^i_t=\left(\int_0^1 c^i_t(z)^{(\theta-1)/\theta}\,dz\right)^{\theta/(\theta-1)}.
```

Given nominal spending $`S^i_t`$, expenditure minimization across differentiated goods implies the Dixit-Stiglitz price index:

```math
P_t=\left(\int_0^1 p_t(z)^{1-\theta}\,dz\right)^{1/(1-\theta)}.
```

The intertemporal budget constraint is:

```math
E_t\sum_{T=t}^{\infty}\delta_{t,T}S^i_T
\leq
E_t\sum_{T=t}^{\infty}\delta_{t,T}\left[p_T(i)y^i_T-T_T\right]+A^i_t.
```

The riskless nominal gross interest rate satisfies:

```math
R_t=\left(E_t\delta_{t,t+1}\right)^{-1}.
```

### 2.2 Demand Aggregation

Total aggregate demand is the sum of interest-sensitive private purchases and autonomous spending:

```math
Y_t=C_t+G_t.
```

Autonomous spending is also treated as a CES aggregate over goods, so an individual supplier faces demand:

```math
y^i_t=Y_t\left(\frac{p_t(i)}{P_t}\right)^{-\theta}.
```

### 2.3 Price-Setting Problem

A fraction $`1-\alpha`$ of sellers can choose a new price each period. Among those, a fraction $`\gamma`$ begins charging the new price in the same period, while $`1-\gamma`$ posts a price one quarter in advance. Let $`p^i_t`$ be the new price charged from period $`t`$ when chosen with period $`t-i`$ information, for $`i=1,2`$.

The objective for a reset price $`p`$ is:

```math
\Phi_t(p)=\sum_{j=0}^{\infty}(\alpha\beta)^j
\left[
\lambda_{t+j}(1-\tau)pY_{t+j}\left(\frac{p}{P_{t+j}}\right)^{-\theta}
-v\left(Y_{t+j}\left(\frac{p}{P_{t+j}}\right)^{-\theta};\xi_{t+j}\right)
\right].
```

The optimal reset price satisfies:

```math
E_{t-i}\Phi'_t(p^i_t)=0,\qquad i=1,2.
```

## 3. First-Order Conditions

The paper's maintained implementation is the log-linear equilibrium system. The following numbered conditions are the source-backed equilibrium restrictions and definitions used for the archive entry.

- **(F1) Household intratemporal purchase condition with decision lag**:

```math
E_t u'(C^i_{t+2};\xi_{t+2})=E_t\left(\lambda^i_{t+2}P_{t+2}\right).
```

- **(F2) Marginal utility of nominal income across states and dates**:

```math
\lambda^i_t\delta_{t,T}=\beta^{T-t}\lambda^i_T,\qquad T\geq t.
```

- **(F3) Marginal utility of income Euler relation**:

```math
\lambda_t=\beta E_t\left(R_t\lambda_{t+1}\right).
```

- **(F4) Long real rate / marginal utility in log-linear form**:

```math
\hat{\lambda}_t=\hat{r}^l_t
\equiv
\sum_{T=t}^{\infty}E_t\left(\hat{R}_T-\hat{\pi}_{T+1}\right).
```

- **(F5) Log-linear consumption decision condition**:

```math
-\tilde{\sigma}E_t\left(\hat{C}_{t+2}-\bar{C}_{t+2}\right)
=E_t\hat{r}^l_{t+2}.
```

- **(F6) IS equation with two-period decision lag**:

```math
\hat{Y}_t=-\sigma^{-1}E_{t-2}\hat{r}^l_t+\hat{G}_t.
```

- **(F7) New-price contribution to inflation**:

```math
\hat{\pi}_t=\gamma\hat{X}^1_t+(1-\gamma)\hat{X}^2_t.
```

- **(F8) Predetermined new-price relation**:

```math
\hat{X}^2_t=E_{t-2}\hat{X}^1_t-\frac{1-\alpha}{\alpha}
\left(\hat{\pi}_t-E_{t-2}\hat{\pi}_t\right).
```

- **(F9) Inflation and same-period reset price**:

```math
\hat{\pi}_t=\frac{1}{1+\psi}\hat{X}_t+
\frac{\psi}{1+\psi}E_{t-2}\hat{\pi}_t,
\qquad
\psi\equiv\frac{1-\gamma}{\gamma\alpha}.
```

- **(F10) Log-linear price-setting condition before quasidifferencing**:

```math
\begin{aligned}
E_{t-1}\sum_{j=0}^{\infty}(\alpha\beta)^j
\Bigg[
&(1+\omega\theta)
\left(\frac{\alpha}{1-\alpha}\hat{X}_t-\sum_{s=1}^{j}\hat{\pi}_{t+s}\right)\\
&-(\omega+\sigma)\left(\hat{Y}_{t+j}-\hat{Y}^s_{t+j}\right)
\Bigg]
=-\phi_{t-1}.
\end{aligned}
```

- **(F11) Real-rate correction term in price setting**:

```math
\phi_t\equiv
E_t\left[
\hat{R}_{t+1}-\hat{\pi}_{t+2}
-\sigma\left(\hat{Y}_{t+2}-\hat{G}_{t+2}-\hat{Y}_{t+1}+\hat{G}_{t+1}\right)
\right].
```

- **(F12) Natural-output disturbance definition**:

```math
\hat{Y}^s_t\equiv
\frac{\omega}{\omega+\sigma}E_{t-1}\bar{Y}_t
+\frac{\sigma}{\omega+\sigma}\hat{G}_t.
```

- **(F13) Quasidifferenced aggregate-supply / reset-price equation**:

```math
\hat{X}_t=\beta E_{t-1}\hat{X}_{t+1}
+\kappa(\hat{Y}_t-\hat{Y}^s_t)
-\frac{\kappa}{\omega+\sigma}\phi_{t-1}.
```

- **(F14) Slope of the aggregate-supply relation**:

```math
\kappa=
\frac{(1-\alpha)(1-\alpha\beta)(\omega+\sigma)}
{\alpha(1+\omega\theta)}.
```

- **(F15) Conditional-expectation New Keynesian Phillips curve**:

```math
E_{t-2}\hat{\pi}_t
=\kappa E_{t-2}\left(\hat{Y}_t-\hat{Y}^s_t\right)
+\beta E_{t-2}\hat{\pi}_{t+1}.
```

- **(F16) Estimated historical interest-rate feedback rule**:

```math
r_t=r^{\ast}
+\sum_{k=1}^{n_r}\mu_k(r_{t-k}-r^{\ast})
+\sum_{k=0}^{n_\pi}\phi_k(\pi_{t-k}-\pi^{\ast})
+\sum_{k=0}^{n_y}\theta_k y_{t-k}
+\epsilon_t.
```

## 4. Market Clearing & Identities

- **(F17) Aggregate resource identity**:

```math
Y_t=C_t+G_t.
```

- **(F18) Log-linear aggregate demand identity**:

```math
\hat{Y}_t=s_C\hat{C}_t+\tilde{G}_t,
\qquad
\hat{G}_t\equiv \tilde{G}_t+s_CE_{t-2}\bar{C}_t.
```

- **(F19) Dixit-Stiglitz demand for good $`i`$**:

```math
y^i_t=Y_t\left(\frac{p_t(i)}{P_t}\right)^{-\theta}.
```

- **(F20) Price index with same-period and one-period-delayed reset prices**:

```math
P_t=
\left[
\alpha P_{t-1}^{1-\theta}
+(1-\alpha)\gamma(p^1_t)^{1-\theta}
+(1-\alpha)(1-\gamma)(p^2_t)^{1-\theta}
\right]^{1/(1-\theta)}.
```

## 5. Exogenous Processes

- **(F21) VAR state vector used for policy-shock identification**:

```math
Z_t=\left[r_t,\ \pi_{t+1},\ y_{t+1}\right]'.
```

- **(F22) Estimated VAR representation**:

```math
T\bar{Z}_t=A\bar{Z}_{t-1}+\bar{e}_t.
```

- **(F23) Companion-form VAR law of motion**:

```math
\bar{Z}_t=B\bar{Z}_{t-1}+U\bar{e}_t.
```

- **(F24) Monetary policy shock recovered from the VAR**:

```math
\epsilon_t=i_1'\left(\bar{Z}_t-B\bar{Z}_{t-1}\right).
```

- **(F25) Compact autonomous-spending shock equation**:

```math
M'\tilde{Z}_t-N'\sum_{j=1}^{\infty}E_{t-1}\tilde{Z}_{t+j}
=\hat{G}_{t+1}.
```

- **(F26) Compact natural-output shock equation**:

```math
P'E_{t-1}\tilde{Z}_t+R'E_t\tilde{Z}_{t+1}
=\hat{Y}^s_{t+1}
+\frac{\sigma}{\sigma+\omega}
E_t\left(\hat{G}_{t+2}-\hat{G}_{t+1}\right).
```

- **(F27) Real-disturbance vector reconstructed from VAR objects**:

```math
s_t\equiv
\begin{bmatrix}
\hat{G}_{t+1}\\
\hat{Y}^s_{t+1}
\end{bmatrix}
=C\bar{Z}_{t-1}+D\bar{e}_t.
```

## 6. Steady-State Solution

The model archive entry follows the paper's log-linear approximation around a steady state with zero inflation and stationary variables written as deviations from steady state.

1. Set all hatted variables and innovations to zero:

```math
\hat{Y}=\hat{C}=\hat{G}=\hat{Y}^s=\hat{\pi}=\hat{R}=\hat{r}^l=\hat{X}=0.
```

2. Zero inflation is the expansion point:

```math
\pi=0,\qquad P_t/P_{t+1}=1.
```

3. The real gross return pins down the discount factor:

```math
\beta^{-1}=R/\Pi.
```

The paper calibrates $`\beta=0.99`$ for the main estimation, while the Rep-MMB implementation uses $`\beta=1/(1+0.035/4)`$. This difference is recorded as an `implementation_cross_check` discrepancy rather than silently normalized.

4. In the MMB `model(linear)` cross-check, steady states are zero for the declared endogenous variables:

```math
\pi=y=y^{nat}=r^{nat}=i=x=u=g=0.
```

## 7. Timing & Form Conventions

- **Form**: Log-linear model. The MMB file declares `model(linear)`.
- **Decision timing**: Aggregate purchases for period $`t`$ are determined with date $`t-2`$ information. Autonomous spending is known by the beginning of period $`t`$, i.e. in the date $`t-1`$ information set.
- **Price timing**: Only a fraction $`1-\alpha`$ can reset each period. Fraction $`\gamma`$ of resetters charges the new price immediately; fraction $`1-\gamma`$ posts one quarter in advance.
- **Information sets**: $`E_{t-2}`$ appears in aggregate demand and inflation because of purchase and price decision lags. $`E_{t-1}`$ appears in the reset-price equation.
- **Stock variables**: The model abstracts from capital accumulation; no capital-in-production timing is present.
- **Shocks**: The paper constructs three stochastic disturbances: monetary policy shock $`\epsilon_t`$, autonomous-spending disturbance $`\hat{G}_t`$, and natural-output/supply disturbance $`\hat{Y}^s_t`$. The MMB implementation keeps two exogenous innovations, `u_` and `g_`, for cost-push and fiscal/autonomous-spending disturbances, and uses a simple policy rule without a separate monetary-policy innovation.
- **Implementation cross-check**: The local `.mod` cites Woodford (2003, p. 246) for the implemented reduced form and uses equations
  $`\pi_t=\beta E_t\pi_{t+1}+\kappa x_t+u_t`$,
  $`x_t=E_tx_{t+1}-\sigma(i_t-E_t\pi_{t+1}-r^{nat}_t)`$,
  $`x_t=y_t-y^{nat}_t`$,
  $`u_t=\rho_u u_{t-1}+\varepsilon^u_t`$,
  $`g_t=\rho_g g_{t-1}+\varepsilon^g_t`$,
  and $`i_t=\phi_\pi\pi_t+\phi_xx_t`$.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Determined by |
|---|---|---|---|
| Endogenous | $`\hat{\pi}_t`$ / `pi` | Inflation deviation | (F9), (F15), implementation NKPC |
| Endogenous | $`\hat{Y}_t`$ / `y` | Output deviation | (F6), (F17), (F18) |
| Endogenous | $`\hat{R}_t`$ / `i` | Nominal interest-rate deviation | (F16), implementation Taylor rule |
| Endogenous | $`\hat{r}^l_t`$ | Long real rate | (F4) |
| Endogenous | $`\hat{X}_t`$ / `x` in implementation | Reset-price or output-gap state, depending on source vs implementation notation | (F9), (F13); implementation `x=y-ynat` |
| Endogenous | $`\hat{C}_t`$ | Interest-sensitive purchases | (F5), (F18) |
| Endogenous | $`P_t`$ | Dixit-Stiglitz price index | (F20) |
| Endogenous | $`p^1_t,p^2_t`$ | Same-period and advance reset prices | (F7)-(F10), (F20) |
| Endogenous | $`y^i_t`$ | Demand for producer $`i`$ | (F19) |
| Endogenous | $`\lambda_t`$ | Marginal utility of nominal income | (F2), (F3) |
| Endogenous | $`\hat{Y}^{nat}_t`$ / `ynat` | Natural output in implementation | implementation cross-check |
| Endogenous | $`\hat{r}^{nat}_t`$ / `rnat` | Natural real rate in implementation | implementation cross-check |
| Exogenous/state | $`\epsilon_t`$ | Monetary policy shock in paper VAR system | (F16), (F24) |
| Exogenous/state | $`\hat{G}_t`$ / `g` | Autonomous-spending disturbance | (F6), (F18), (F25), implementation AR(1) |
| Exogenous/state | $`\hat{Y}^s_t`$ | Natural-output/supply disturbance | (F12), (F26) |
| Exogenous/state | $`u_t`$ / `u` | Cost-push disturbance in MMB implementation | implementation cross-check |
| Varexo | `u_` | Cost-push innovation | implementation cross-check |
| Varexo | `g_` | Autonomous-spending innovation | implementation cross-check |
| Parameter | $`\beta`$ / `beta` | Discount factor | (F2)-(F4) |
| Parameter | $`\sigma`$ / `sigma` | Interest sensitivity / inverse elasticity parameter | (F5), (F6), (F11), (F12), (F26) |
| Parameter | $`\alpha`$ / `alpha` | Calvo non-reset probability | (F7), (F8), (F10), (F14), (F20) |
| Parameter | $`\gamma`$ | Share of resetters charging immediately | (F7)-(F9), (F20) |
| Parameter | $`\psi`$ | Advance-price timing composite $`(1-\gamma)/(\gamma\alpha)`$ | (F9) |
| Parameter | $`\theta`$ / `theta` | CES demand elasticity | (F10), (F14), (F19), (F20) |
| Parameter | $`\omega`$ / `omega` | Elasticity of marginal disutility / marginal cost with respect to output | (F10)-(F14), (F26) |
| Parameter | $`\kappa`$ / `kappa` | NK aggregate-supply slope | (F13)-(F15) |
| Parameter | $`\rho_u,\rho_g`$ / `rhou`, `rhog` | Implementation shock persistence | implementation cross-check |
| Parameter | $`\phi_\pi,\phi_x`$ / `phipi`, `phix` | Implementation Taylor-rule coefficients | implementation cross-check |

**Equation count note**: The source-backed archive conditions are (F1)-(F27). The Rep-MMB implementation is a reduced `model(linear)` cross-check with 8 endogenous variables and 8 implemented equations; it is not treated as the paper-side source.
