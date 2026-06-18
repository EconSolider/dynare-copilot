# US_IR15 - Derivation (Affine Macro-Finance State-Space Model)

> Model archive entry for `US_IR15`. Status: `needs_review`. Runtime validation was not performed; Dynare was not run.

## 1. Model Overview

- **Model**: Ireland (2015), "Monetary policy, bond risk premia, and the economy."
- **Model ID**: `US_IR15`.
- **Source**: `raw/mmb_mineru/runs/us_ir15__monetary_policy_bond_risk_premia_and_the_economy__eb56aade/full.md`; DOI `10.1016/j.jmoneco.2015.09.003`.
- **Purpose**: Estimate an affine term-structure model with macroeconomic factors to study two-way links between monetary policy, bond risk premia, output, and inflation.
- **Agents/blocks**: A reduced-form central bank rule, a macroeconomic VAR-style state transition, an affine nominal pricing kernel, no-arbitrage bond-pricing recursions, and a measurement equation for observed macro variables and bond yields.
- **State vector**: $`X_t=[g^r_t,\ g^\pi_t,\ g^y_t,\ \tau_t,\ \nu_t]'`$, where $`g^r_t`$ is the interest-rate gap, $`g^\pi_t`$ is the inflation gap, $`g^y_t`$ is the output gap, $`\tau_t`$ is the inflation target, and $`\nu_t`$ is the unobserved risk-premium factor.
- **Form**: Linear state-space / affine term-structure model. The MMB implementation is `model(linear)`.

## 2. Optimization Problems

The paper does not state household, firm, or intermediary optimization problems. Its structural restrictions are imposed through no-arbitrage in an affine term-structure model and through timing restrictions in the macro state equations.

The closest optimization-based object is the stochastic discount factor used for no-arbitrage pricing:

```math
m_{t+1}=-r_t-\frac{1}{2}\lambda_t'\lambda_t-\lambda_t'\varepsilon_{t+1}.
```

Prices of risk are affine in the state vector, with time variation restricted to the risk factor column:

```math
\lambda_t=\lambda+\Lambda X_t,\qquad
\Lambda=
\begin{bmatrix}
0&0&0&0&\Lambda^r\\
0&0&0&0&\Lambda^\pi\\
0&0&0&0&\Lambda^y\\
0&0&0&0&\Lambda^\tau\\
0&0&0&0&\Lambda^\nu
\end{bmatrix}.
```

The estimation imposes $`\sigma_\nu=0.01`$, $`\Lambda^\pi<0`$, $`\Lambda^\nu=0`$, $`\rho_\tau=0.999`$, and stability of both $`P`$ and $`P-\Sigma\Lambda`$.

## 3. First-Order Conditions

No agent-level FOCs are stated in the source. The numbered conditions below are the equilibrium/state-space restrictions that define the implemented linear model.

- **(F1) Inflation-target process**:

```math
\tau_t=(1-\rho_\tau)\tau+\rho_\tau\tau_{t-1}+\sigma_\tau\varepsilon_{\tau t}.
```

- **(F2) Interest-rate and inflation gap definitions**:

```math
g^r_t=r_t-\tau_t,\qquad g^\pi_t=\pi_t-\tau_t.
```

- **(F3) Monetary policy rule for the interest-rate gap**:

```math
g^r_t-g^r=\rho_r(g^r_{t-1}-g^r)
+(1-\rho_r)\left[\rho_\pi g^\pi_t+\rho_y(g^y_t-g^y)+\rho_\nu\nu_t\right]
+\sigma_r\varepsilon_{rt}.
```

- **(F4) Inflation-gap law of motion**:

```math
g^\pi_t=\rho_{\pi r}(g^r_{t-1}-g^r)+\rho_{\pi\pi}g^\pi_{t-1}
+\rho_{\pi y}(g^y_{t-1}-g^y)+\rho_{\pi\nu}\nu_{t-1}
+\sigma_{\pi\tau}\sigma_\tau\varepsilon_{\tau t}
+\sigma_\pi\varepsilon_{\pi t}.
```

- **(F5) Output-gap law of motion**:

```math
g^y_t-g^y=\rho_{yr}(g^r_{t-1}-g^r)+\rho_{y\pi}g^\pi_{t-1}
+\rho_{yy}(g^y_{t-1}-g^y)+\rho_{y\nu}\nu_{t-1}
+\sigma_{y\pi}\sigma_\pi\varepsilon_{\pi t}
+\sigma_{y\tau}\sigma_\tau\varepsilon_{\tau t}
+\sigma_y\varepsilon_{yt}.
```

- **(F6) Risk-factor law of motion**:

```math
\nu_t=\rho_{\nu\nu}\nu_{t-1}
+\sigma_{\nu r}\sigma_r\varepsilon_{rt}
+\sigma_{\nu\pi}\sigma_\pi\varepsilon_{\pi t}
+\sigma_{\nu y}\sigma_y\varepsilon_{yt}
+\sigma_{\nu\tau}\sigma_\tau\varepsilon_{\tau t}
+\sigma_\nu\varepsilon_{\nu t}.
```

- **(F7) Compact state transition**:

```math
X_t=\mu+P X_{t-1}+\Sigma\varepsilon_t,\qquad
\varepsilon_t=[\varepsilon_{rt},\varepsilon_{\pi t},\varepsilon_{yt},\varepsilon_{\tau t},\varepsilon_{\nu t}]'.
```

- **(F8) Short-rate loading on the state vector**:

```math
r_t=\delta'X_t,\qquad \delta=[1,\ 0,\ 0,\ 1,\ 0]'.
```

- **(F9) Log nominal pricing kernel**:

```math
m_{t+1}=-r_t-\frac{1}{2}\lambda_t'\lambda_t-\lambda_t'\varepsilon_{t+1}.
```

- **(F10) Prices of risk**:

```math
\lambda_t=\lambda+\Lambda X_t.
```

- **(F11) Discount-bond log price**:

```math
p^n_t=\overline{A}_n+\overline{B}'_nX_t.
```

- **(F12) No-arbitrage bond-pricing condition**:

```math
\exp(p^{n+1}_t)=E_t\left[\exp(m_{t+1})\exp(p^n_{t+1})\right].
```

- **(F13) Bond-price constant recursion**:

```math
\overline{A}_{n+1}=\overline{A}_n+\overline{B}'_n(\mu-\Sigma\lambda)
+\frac{1}{2}\overline{B}'_n\Sigma\Sigma'\overline{B}_n.
```

- **(F14) Bond-price loading recursion**:

```math
\overline{B}'_{n+1}=\overline{B}'_n(P-\Sigma\Lambda)-\delta'.
```

- **(F15) Yield on an $`n`$-period discount bond**:

```math
y^n_t=-\frac{p^n_t}{n}=A_n+B'_nX_t,\qquad
A_n=-\frac{\overline{A}_n}{n},\quad B_n=-\frac{\overline{B}_n}{n}.
```

- **(F16) Bond risk premium**:

```math
q^n_t=y^n_t-\frac{1}{n}E_t(r_t+r_{t+1}+\cdots+r_{t+n-1}).
```

- **(F17) Expected future short rate**:

```math
E_t r_{t+j}=\delta'\overline{\mu}+\delta'P^j(X_t-\overline{\mu}),\qquad
\overline{\mu}=(I-P)^{-1}\mu.
```

- **(F18) Closed-form risk-premium decomposition**:

```math
q^n_t=A_n-\delta'\left(I-\frac{1}{n}\sum_{j=0}^{n-1}P^j\right)\overline{\mu}
+\left(B'_n-\delta'\frac{1}{n}\sum_{j=0}^{n-1}P^j\right)X_t.
```

- **(F19) Measurement equation for demeaned observables**:

```math
d_t=UX_t+V\eta_t.
```

- **(F20) Observable and measurement-error vectors**:

```math
d_t=[r_t,\ \pi_t,\ g^y_t,\ y^4_t,\ y^8_t,\ y^{12}_t,\ y^{16}_t,\ y^{20}_t]',
\qquad
\eta_t=[\eta^4_t,\ \eta^8_t,\ \eta^{16}_t]'.
```

## 4. Market Clearing & Identities

This empirical macro-finance model does not include goods, labor, asset-supply, or government budget-clearing conditions. The operative identities are transformations and observables:

- **(F21) Interest rate and inflation levels from gaps**:

```math
r_t=g^r_t+\tau_t,\qquad \pi_t=g^\pi_t+\tau_t.
```

- **(F22) Annualized implementation observables**:

```math
\text{inflation}_t=4\pi_t,\qquad \text{output}_t=g^y_t.
```

- **(F23) MMB implementation yield and premium observables**:

```math
P^y_{n,t}=4y^n_t-r_t,\qquad y^a_{n,t}=4y^n_t,\qquad n\in\{4,8,12,16,20\}.
```

The `.mod` file implements $`P^y_{n,t}`$ and annualized yields through precomputed loading matrices rather than deriving them endogenously from recursions (F13)-(F15) inside Dynare. This statement is an `implementation_cross_check`, not a paper-side source.

## 5. Exogenous Processes

The fundamental shocks are mutually and serially uncorrelated standard-normal innovations:

```math
\varepsilon_t=[\varepsilon_{rt},\varepsilon_{\pi t},\varepsilon_{yt},\varepsilon_{\tau t},\varepsilon_{\nu t}]'.
```

They enter the system through (F1), (F3), (F4), (F5), and (F6). Measurement errors enter the observable equation:

```math
\eta_t=[\eta^4_t,\eta^8_t,\eta^{16}_t]'.
```

MMB implementation cross-check:

```math
\{\epsilon_r,\epsilon_\pi,\epsilon_y,\epsilon_\tau,\epsilon_\nu,\eta_4,\eta_8,\eta_{16}\}.
```

The MMB `.mod` labels the risk-factor innovation as `epsilon_v`, uses `eta_4`, `eta_8`, and `eta_16` as measurement errors, and sets shock variances to large numerical values for Rep-MMB simulation scaling. These numerical shock variances are implementation conventions, not paper-side formula evidence.

## 6. Steady-State Solution

The paper estimates the system on demeaned data and sets $`\mu=0`$ in the empirical state equation. Hence the linear state vector has zero steady state in demeaned form:

```math
\bar{X}=0.
```

The level steady states used to demean the data are:

```math
\tau=\bar{\pi},\qquad
g^r=\bar{r}-\tau,\qquad
g^y=\overline{g^y}.
```

Steady-state long-term yields are matched by choosing the constant risk-price vector $`\lambda`$:

```math
\bar{y}^n=A_n+B'_n\bar{X}=A_n,\qquad n\in\{4,8,12,16,20\}.
```

For the MMB linear implementation, steady states are stored as calibration constants:

```math
\pi^{SS}=0.89,\quad r^{SS}=5.47,\quad \tau^{SS}=\pi^{SS},\quad
g_r^{SS}=r^{SS}-\pi^{SS},\quad g_y^{SS}=-0.526,
```

```math
y_4^{SS}=5.96,\quad y_8^{SS}=6.166,\quad y_{12}^{SS}=6.337,\quad
y_{16}^{SS}=6.4683,\quad y_{20}^{SS}=6.5447.
```

`needs_review`: the source text says supplementary appendix parts 3 and 4 describe construction of $`U`$, $`V`$, and steady-state yield matching. No local appendix normalization file was available, so the archive records these as first-pass formulas.

## 7. Timing & Form Conventions

- Period length is quarterly.
- The model is linear/affine and implemented as `model(linear)`.
- The state vector $`X_t`$ is predetermined by one-period lags plus current shocks, except the policy rule uses contemporaneous $`g^\pi_t`$, $`g^y_t`$, and $`\nu_t`$.
- Timing restrictions identify shocks: monetary-policy and risk-premium shocks have no contemporaneous effects on the inflation and output gaps; the output-gap innovation has no contemporaneous effect on the inflation gap.
- Bond maturities in the estimation are $`n=4,8,12,16,20`$ quarters.
- One-, two-, and four-year yields include measurement errors; the short rate, inflation, output gap, three-year yield, and five-year yield are treated as exactly observed.
- No stock-capital timing convention applies because the model has no physical capital accumulation block.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Determined by |
|---|---|---|---|
| Endogenous state | `g_r`, $`g^r_t`$ | Interest-rate gap | (F3), (F7) |
| Endogenous state | `g_pi`, $`g^\pi_t`$ | Inflation gap | (F4), (F7) |
| Endogenous state | `g_y`, $`g^y_t`$ | Output gap | (F5), (F7) |
| Endogenous state | `tau`, $`\tau_t`$ | Inflation target | (F1), (F7) |
| Endogenous state | `v`, $`\nu_t`$ | Risk-premium factor | (F6), (F7) |
| Observable | `r`, $`r_t`$ | Short-term nominal rate | (F8), (F21) |
| Observable | `pi`, $`\pi_t`$ | Inflation | (F21) |
| Observable | `g_y_obs` | Output-gap observable | (F19), (F20) |
| Observable | `y_4`, $`y^4_t`$ | One-year discount-bond yield | (F15), (F19) |
| Observable | `y_8`, $`y^8_t`$ | Two-year discount-bond yield | (F15), (F19) |
| Observable | `y_12`, $`y^{12}_t`$ | Three-year discount-bond yield | (F15), (F19) |
| Observable | `y_16`, $`y^{16}_t`$ | Four-year discount-bond yield | (F15), (F19) |
| Observable | `y_20`, $`y^{20}_t`$ | Five-year discount-bond yield | (F15), (F19) |
| Derived observable | `P_y_4`, `P_y_8`, `P_y_12`, `P_y_16`, `P_y_20` | Annualized yield less short rate | (F23) |
| Derived observable | `y_4_a`, `y_8_a`, `y_12_a`, `y_16_a`, `y_20_a` | Annualized yields | (F23) |
| Derived observable | `output` | Output-gap reporting variable | (F22) |
| Derived observable | `inflation` | Annualized inflation reporting variable | (F22) |
| Exogenous shock | `epsilon_r` | Monetary-policy shock | (F3) |
| Exogenous shock | `epsilon_pi` | Inflation shock | (F4) |
| Exogenous shock | `epsilon_y` | Output shock | (F5) |
| Exogenous shock | `epsilon_tau` | Inflation-target shock | (F1), (F4), (F5), (F6) |
| Exogenous shock | `epsilon_v` | Risk-premium-factor shock | (F6) |
| Measurement error | `eta_4`, `eta_8`, `eta_16` | Yield measurement errors | (F19), (F20) |
| Parameter group | $`\rho`$ coefficients | Persistence and dynamic spillovers in (F1), (F3)-(F6) | - |
| Parameter group | $`\sigma`$ coefficients | Shock volatilities, contemporaneous impact loadings, measurement-error volatilities | - |
| Parameter group | $`\lambda,\Lambda`$ | Constant and state-varying prices of risk | (F10), (F13), (F14) |
| Parameter group | `Uij`, `Pij`, `Qij`, `Sij` | Implementation matrices for observables, state transition, yield loadings, and shock loadings | `implementation_cross_check` |

Status: `needs_review` because the derivation is a first-pass extraction from MinerU Markdown and the supplementary appendix formulas for matrix construction were not locally normalized.
