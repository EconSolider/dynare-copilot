# NK_RW97AL -- Derivation (Optimization Problems and First-Order Conditions)

> This derivation is a source-backed archive draft for the MMB entry `NK_RW97AL`. It is not a runtime-validated Dynare replication. The paper-side source is Rotemberg and Woodford (1997), "An Optimization-Based Econometric Framework for the Evaluation of Monetary Policy," NBER Macroeconomics Annual 12, pp. 297-346, DOI `10.1086/654340`.

## 1. Model Overview

- **Model**: a small closed-economy New Keynesian model for evaluating monetary policy rules, estimated around U.S. quarterly output, inflation, and the federal funds rate.
- **Core mechanism**: intertemporal aggregate demand with interest-sensitive purchases chosen in advance, monopolistic competition, and Calvo-style staggered price adjustment with one- and two-quarter pricing decision lags.
- **Agents**: representative households choose consumption and financial claims; differentiated suppliers set prices subject to exogenous adjustment opportunities and decision lags; the monetary authority sets the short nominal interest rate; autonomous spending and natural-output disturbances summarize real shocks.
- **Form**: log-linear approximation around a zero-inflation steady state. Runtime validation is not performed.
- **Variant note**: the MMB implementation cross-check file is `NK_RW97_rep.mod`, which implements a compact Woodford-style linear version. It is used only as `implementation_cross_check`.

Equation labels used below: (F1), (F2), (F3), (F4), (F5), (F6), (F7), (F8), (F9), (F10), (F11), (F12), (F13), (F14), (F15), (F16), (F17), (F18), (F19), (F20), (F21), (F22), (F23), (F24), (F25), (F26), (F27), (F28), (F29), (F30), (F31), (F32), (F33), (F34), (F35), (F36), (F37), (F38), (F39), (F40), and (F41).

## 2. Optimization Problems

### 2.1 Households

The representative household has period utility from the composite consumption index and disutility from producing differentiated goods. A compact source-consistent statement is:

$$
\max_{\{C_t^i,\{y_t^i(z)\}_{z \in [0,1]},\text{claims}\}}
E_0 \sum_{t=0}^{\infty} \beta^t
\left[u(C_t^i;\xi_t)-\int_0^1 v(y_t^i(z);\xi_t)\,dz\right].
$$

The consumption aggregator is

$$
C_t^i=\left(\int_0^1 c_t^i(z)^{(\theta-1)/\theta}\,dz\right)^{\theta/(\theta-1)}.
\tag{F1}
$$

Cost minimization for a given consumption index gives the demand for good $z$:

$$
c_t^i(z)=C_t^i\left(\frac{p_t(z)}{P_t}\right)^{-\theta}.
\tag{F2}
$$

The corresponding price index is

$$
P_t=\left(\int_0^1 p_t(z)^{1-\theta}\,dz\right)^{1/(1-\theta)}.
\tag{F3}
$$

Households trade state-contingent financial claims. If $\delta_{t,T}$ is the stochastic discount factor between dates $t$ and $T$, the one-period nominal interest rate satisfies

$$
R_t=(E_t \delta_{t,t+1})^{-1}.
\tag{F4}
$$

Interest-sensitive purchases $C_t^i$ are predetermined two quarters in advance in the paper's timing convention. The optimal purchase condition is

$$
E_t u'(C_{t+2}^i;\xi_{t+2})
=E_t(\lambda_{t+2}^i P_{t+2}).
\tag{F5}
$$

Marginal utility of nominal income satisfies the intertemporal asset-pricing condition

$$
\lambda_t^i\delta_{t,T}=\beta^{T-t}\lambda_T^i,\qquad T\ge t.
\tag{F6}
$$

With complete insurance against idiosyncratic price-setting income risk, households share the same $\lambda_t$, and the one-period Euler restriction is

$$
\lambda_t=\beta E_t(R_t\lambda_{t+1}).
\tag{F7}
$$

### 2.2 Price-Setting Suppliers

Each supplier faces total demand

$$
y_t(i)=Y_t\left(\frac{p_t(i)}{P_t}\right)^{-\theta}.
\tag{F8}
$$

A fraction $1-\alpha$ can choose a new price each period. Among price changers, fraction $\gamma$ charge the new price in the current period and fraction $1-\gamma$ charge it with an additional one-quarter delay. If a price effective in period $t$ is chosen using period $t-i$ information, the supplier chooses $p_t^i$ to maximize

$$
E_{t-i}\Phi_t(p),
\quad
\Phi_t(p)=\sum_{j=0}^{\infty}(\alpha\beta)^j
\left[
\lambda_{t+j}(1-\tau)pY_{t+j}\left(\frac{p}{P_{t+j}}\right)^{-\theta}
-v\!\left(Y_{t+j}\left(\frac{p}{P_{t+j}}\right)^{-\theta};\xi_{t+j}\right)
\right].
\tag{F9}
$$

The price-setting first-order condition is

$$
E_{t-i}\Phi_t'(p_t^i)=0,\qquad i\in\{1,2\}.
\tag{F10}
$$

## 3. First-Order Conditions

The paper works with log-linear approximations. Hats denote log deviations from the zero-inflation steady state unless otherwise noted.

From (F7), the log-linear marginal-utility condition is

$$
\hat{\lambda}_t=E_t(\hat{R}_t-\hat{\pi}_{t+1}+\hat{\lambda}_{t+1}).
\tag{F11}
$$

Solving forward defines the long real rate:

$$
\hat{r}_t^l\equiv
\sum_{T=t}^{\infty}E_t(\hat{R}_T-\hat{\pi}_{T+1}).
\tag{F12}
$$

Log-linearizing the predetermined purchase condition gives

$$
-\tilde{\sigma}\,E_t(\hat{C}_{t+2}-\bar{C}_{t+2})
=E_t\hat{r}_{t+2}^l.
\tag{F13}
$$

Aggregate demand is

$$
Y_t=C_t+G_t.
\tag{F14}
$$

Combining (F13) and (F14) yields the source IS equation:

$$
\hat{Y}_t=-\sigma^{-1}E_{t-2}\hat{r}_t^l+\hat{G}_t.
\tag{F15}
$$

The price index with two types of newly effective prices is

$$
P_t=\left[
\alpha P_{t-1}^{1-\theta}
+(1-\alpha)\gamma(p_t^1)^{1-\theta}
+(1-\alpha)(1-\gamma)(p_t^2)^{1-\theta}
\right]^{1/(1-\theta)}.
\tag{F16}
$$

After log-linearization, aggregate inflation satisfies

$$
\hat{\pi}_t=\gamma \hat{X}_t^1+(1-\gamma)\hat{X}_t^2,
\quad
\hat{X}_t^i\equiv\frac{1-\alpha}{\alpha}\log\left(\frac{p_t^i}{P_t}\right).
\tag{F17}
$$

The relation between the one-quarter-ahead and two-quarter-ahead price setters is

$$
\hat{X}_t^2=E_{t-2}\hat{X}_t^1
-\frac{1-\alpha}{\alpha}(\hat{\pi}_t-E_{t-2}\hat{\pi}_t).
\tag{F18}
$$

Let $\hat{X}_t\equiv\hat{X}_t^1$ and $\psi\equiv(1-\gamma)/(\gamma\alpha)$. The aggregate price relation becomes

$$
\hat{\pi}_t=\frac{1}{1+\psi}\hat{X}_t
+\frac{\psi}{1+\psi}E_{t-2}\hat{\pi}_t.
\tag{F19}
$$

Log-linearizing the price-setting FOC for prices chosen using period $t-1$ information gives the present-value pricing condition:

$$
\begin{aligned}
E_{t-1}\sum_{j=0}^{\infty}(\alpha\beta)^j
\Bigg[
&(1+\omega\theta)
\left(\frac{\alpha}{1-\alpha}\hat{X}_t-\sum_{s=1}^j\hat{\pi}_{t+s}\right)\\
&-(\omega+\sigma)(\hat{Y}_{t+j}-\hat{Y}_{t+j}^s)
\Bigg]
=-\phi_{t-1}.
\end{aligned}
\tag{F20}
$$

The interest-rate/marginal-utility correction term is

$$
\phi_t=E_t\left[
\hat{R}_{t+1}-\hat{\pi}_{t+2}
-\sigma(\hat{Y}_{t+2}-\hat{G}_{t+2}-\hat{Y}_{t+1}+\hat{G}_{t+1})
\right].
\tag{F21}
$$

The source defines the natural-output disturbance as

$$
\hat{Y}_t^s=
\frac{\omega}{\omega+\sigma}E_{t-1}\bar{Y}_t
+\frac{\sigma}{\omega+\sigma}\hat{G}_t.
\tag{F22}
$$

Quasi-differencing (F20) gives the aggregate supply relation:

$$
\hat{X}_t=\beta E_{t-1}\hat{X}_{t+1}
+\kappa(\hat{Y}_t-\hat{Y}_t^s)
-\frac{\kappa}{\omega+\sigma}\phi_{t-1}.
\tag{F23}
$$

The slope coefficient is

$$
\kappa=
\frac{(1-\alpha)(1-\alpha\beta)(\omega+\sigma)}
{\alpha(1+\omega\theta)}.
\tag{F24}
$$

Conditional on information at $t-2$, (F19) and (F23) imply the New Keynesian Phillips-curve form:

$$
E_{t-2}\hat{\pi}_t
=\kappa E_{t-2}(\hat{Y}_t-\hat{Y}_t^s)
+\beta E_{t-2}\hat{\pi}_{t+1}.
\tag{F25}
$$

## 4. Market Clearing & Identities

The goods market identity is aggregate demand (F14). There is no investment or capital accumulation in the source model; the paper explicitly notes the absence of investment and capital as a limitation.

The monetary policy feedback rule used to characterize historical policy is

$$
r_t=r^*
+\sum_{k=1}^{n_r}\mu_k(r_{t-k}-r^*)
+\sum_{k=0}^{n_\pi}\phi_k(\pi_{t-k}-\pi^*)
+\sum_{k=0}^{n_y}\theta_k y_{t-k}
+\epsilon_t.
\tag{F26}
$$

The paper also evaluates simple Taylor-style rules of the form

$$
r_t=\theta_\pi\pi_t+\theta_y y_t.
\tag{F27}
$$

The VAR state vector used for policy-shock identification is

$$
Z_t=[r_t,\pi_{t+1},y_{t+1}]'.
\tag{F28}
$$

The estimated recursive VAR representation is

$$
T\bar{Z}_t=A\bar{Z}_{t-1}+\bar{e}_t.
\tag{F29}
$$

The monetary policy shock is recovered as

$$
\epsilon_t=i_1'(\bar{Z}_t-B\bar{Z}_{t-1}).
\tag{F30}
$$

For the compact MMB implementation cross-check, the implemented linear state uses output gap $x_t=y_t-y_t^{nat}$:

$$
x_t=y_t-y_t^{nat}.
\tag{F31}
$$

This identity is from the `.mod` implementation and is recorded only as `implementation_cross_check`, not as an additional paper-side source equation.

## 5. Exogenous Processes

The paper constructs real disturbances from the VAR representation rather than imposing simple scalar AR(1) laws in the paper-side model. The two structural real disturbances are autonomous spending $\hat{G}_t$ and natural output $\hat{Y}_t^s$.

After substitution of the structural equations into the VAR notation, the source writes the structural restrictions as

$$
M'\tilde{Z}_t-N'\sum_{j=1}^{\infty}E_{t-1}\tilde{Z}_{t+j}
=\hat{G}_{t+1}.
\tag{F32}
$$

The natural-output restriction is

$$
P'E_{t-1}\tilde{Z}_t+R'E_t\tilde{Z}_{t+1}
=\hat{Y}_{t+1}^s
+\frac{\sigma}{\sigma+\omega}E_t(\hat{G}_{t+2}-\hat{G}_{t+1}).
\tag{F33}
$$

The real-shock vector is reconstructed as

$$
s_t\equiv[\hat{G}_{t+1},\hat{Y}_{t+1}^s]'
=C\bar{Z}_{t-1}+D\bar{e}_t.
\tag{F34}
$$

The compact MMB implementation instead uses two AR(1) processes:

$$
u_t=\rho_u u_{t-1}+\varepsilon^u_t.
\tag{F35}
$$

$$
g_t=\rho_g g_{t-1}+\varepsilon^g_t.
\tag{F36}
$$

Equations (F35)-(F36) are implementation cross-check equations only. They help document the simplified `model(linear)` MMB representation but are not treated as paper-side shock-process statements.

## 6. Steady-State Solution

The derivation is in log-linear form. Therefore the steady state for the Dynare-style linear implementation is zero for all hatted variables and the output gap:

$$
\bar{\pi}=\bar{y}=\bar{y}^{nat}=\bar{r}^{nat}=\bar{i}=\bar{x}=\bar{u}=\bar{g}=0.
\tag{F37}
$$

The source's non-hatted steady state is a zero-inflation stationary equilibrium. Key source normalizations are:

$$
\Pi=1,\qquad \hat{\pi}_t=0,\qquad \hat{Y}_t=0,\qquad \hat{G}_t=0,\qquad \hat{Y}_t^s=0.
\tag{F38}
$$

The discount factor pins down the steady real return:

$$
\beta^{-1}=1+\rho.
\tag{F39}
$$

For the implementation cross-check, the natural-rate and natural-output formulas are:

$$
r_t^{nat}
=\sigma^{-1}\left[(g_t-y_t^{nat})-(g_{t+1}-y_{t+1}^{nat})\right].
\tag{F40}
$$

$$
y_t^{nat}
=\frac{\sigma^{-1}g_t}{\sigma^{-1}+\omega}.
\tag{F41}
$$

These last two equations align with the implementation file and with the source's compact natural-rate logic, but the paper-side derivation of real disturbances is richer than the two-AR implementation.

## 7. Timing & Form Conventions

- **Form**: log-linear, `model(linear)` in the implementation cross-check.
- **Inflation timing**: the paper's VAR state is $Z_t=[r_t,\pi_{t+1},y_{t+1}]'$, reflecting the decision-lag timing. Some variables observed in period $t+1$ are treated as determined with period-$t$ information.
- **Household purchases**: the composite interest-sensitive purchase $C_t^i$ is chosen two quarters in advance; individual goods purchases needed to implement that index depend later on individual prices.
- **Price setting**: a fraction $1-\alpha$ of firms can choose a new price. Among those, fraction $\gamma$ charge the price in the current period and fraction $1-\gamma$ post one quarter in advance.
- **Stocks and capital**: there are no capital-stock state variables in the source model or the compact implementation.
- **Rates**: the paper's data discussion uses annualized interest and inflation rates in places, while the structural equations are quarterly log-linear equations.
- **Uncertainty marker**: equations (F32)-(F34) are transcribed from OCR-heavy matrix expressions and are marked `needs_review` for a source-level formula audit.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Equation reference |
|---|---|---|---|
| Endogenous | `pi`, $\hat{\pi}_t$ | Inflation | (F17), (F19), (F25) |
| Endogenous | `y`, $\hat{Y}_t$ | Output deviation | (F15), (F23) |
| Endogenous | `ynat`, $\hat{Y}_t^s$ | Natural-output / supply disturbance | (F22), implementation (F41) |
| Endogenous | `rnat`, $r_t^{nat}$ | Natural real rate | implementation (F40) |
| Endogenous | `i` / `r`, $r_t$ | Short nominal policy rate | (F26), (F27) |
| Endogenous | `x`, $x_t$ | Output gap | implementation (F31) |
| Endogenous | $\hat{r}_t^l$ | Long real rate | (F12), (F15) |
| Endogenous | $\lambda_t$ | Marginal utility of nominal income | (F7), (F11) |
| Endogenous | $\hat{X}_t$ | Relative reset-price index | (F19), (F23) |
| Exogenous | `u`, $u_t$ | Cost-push / inflation disturbance in implementation | implementation (F35) |
| Exogenous | `g`, $g_t$ / $\hat{G}_t$ | Autonomous spending disturbance | (F15), (F32), implementation (F36) |
| Exogenous | `u_`, $\varepsilon^u_t$ | Inflation/cost-push innovation | implementation (F35) |
| Exogenous | `g_`, $\varepsilon^g_t$ | Autonomous-spending innovation | implementation (F36) |
| Exogenous | $\epsilon_t$ | Monetary policy shock | (F26), (F30) |
| Parameter | `beta`, $\beta$ | Discount factor | (F6), (F7), (F39) |
| Parameter | `sigma`, $\sigma$ | Interest sensitivity / inverse intertemporal elasticity composite | (F13), (F15) |
| Parameter | `alpha`, $\alpha$ | Calvo probability that a price remains fixed | (F16), (F24) |
| Parameter | `theta`, $\theta$ | Elasticity of substitution / demand elasticity | (F1)-(F3), (F8), (F24) |
| Parameter | `omega`, $\omega$ | Elasticity of marginal disutility / marginal cost with respect to output | (F20), (F22), (F24) |
| Parameter | `kappa`, $\kappa$ | Phillips-curve slope | (F23), (F24), (F25) |
| Parameter | `rhou`, $\rho_u$ | Persistence of implementation cost-push shock | (F35) |
| Parameter | `rhog`, $\rho_g$ | Persistence of implementation spending shock | (F36) |
| Parameter | `phipi`, $\phi_\pi$ | Policy response to inflation | (F27) |
| Parameter | `phix`, $\phi_x$ | Policy response to output gap | implementation policy rule |

First-pass status: `needs_review`. Main unresolved issues are source-level checking of OCR matrix equations (F32)-(F34), separation of paper-side VAR shock reconstruction from the compact MMB AR(1) implementation, and no runtime validation.
