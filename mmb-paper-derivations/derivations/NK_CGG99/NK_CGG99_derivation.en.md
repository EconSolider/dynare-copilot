# NK_CGG99 - Derivation (Optimization Problems + First-Order Conditions)

> Status: needs_review. This first-pass archive entry is source-backed by the MinerU Markdown for Clarida, Gali, and Gertler (1999) and cross-checked against the MMB `NK_CGG99_rep.mod` implementation only for variable coverage and the hybrid specification used by Rep-MMB.

## 1. Model Overview

- **Model**: `NK_CGG99`, based on Clarida, Gali, and Gertler, "The Science of Monetary Policy: A New Keynesian Perspective," *Journal of Economic Literature* 37(4), 1999, DOI `10.1257/jel.37.4.1661`.
- **Source form**: small log-linear New Keynesian monetary policy model with an output gap, inflation, nominal interest rate, demand disturbance, and cost-push disturbance.
- **MMB implementation variant**: the Rep-MMB file uses the paper's Section 6 hybrid extension with lagged output-gap and lagged-inflation terms, and closes it with the forward-looking interest-rate rule estimated for the Volcker-Greenspan period in Section 7.
- **Agents and blocks**: households generate the log-linear IS relation from the consumption Euler equation and goods-market clearing; monopolistically competitive Calvo price setters generate the New Keynesian Phillips curve; the central bank sets the short nominal rate by an expected-inflation/output-gap rule with interest-rate smoothing.
- **Model form**: `model(linear)`. Variables are deviations from long-run levels or gaps, so the steady state is zero for endogenous and exogenous state variables.
- **Runtime validation**: not performed in this archive-building pass.

## 2. Optimization Problems

The paper does not present a full primitive household-firm problem for the compact policy model; it states the aggregate relationships and cites standard derivations. This entry therefore records the source-stated reduced-form optimality conditions and marks the missing primitive derivation as `needs_review`.

### 2.1 Representative Household

The household-side saving problem implies, after log-linearizing the Euler equation and imposing goods-market clearing, an IS curve in which the output gap depends on the expected future output gap and the ex ante real interest rate. For the hybrid MMB variant, lagged output also enters as an endogenous persistence term.

### 2.2 Price-Setting Firms

Monopolistically competitive firms face Calvo nominal rigidity. Aggregating optimal reset-price decisions yields a New Keynesian Phillips curve linking inflation to the output gap, expected future inflation, and a cost-push disturbance. The hybrid MMB variant adds lagged inflation.

### 2.3 Central Bank

The central bank uses the short nominal interest rate as the policy instrument. The implementation cross-check maps `NK_CGG99` to the post-1979 estimated forward-looking rule with partial adjustment.

## 3. First-Order Conditions

**(F1) Hybrid IS curve / Euler equation representation**:

\[
x_t =
\sigma\big(i_t - E_t \pi_{t+1}\big)
+ \theta x_{t-1}
+ (1-\theta)E_t x_{t+1}
+ \varepsilon^d_t
\]

In the paper's notation, the interest-elasticity coefficient is positive in

\[
x_t=-\varphi(i_t-E_t\pi_{t+1})+\theta x_{t-1}+(1-\theta)E_t x_{t+1}+g_t.
\]

The MMB implementation uses `sigma = -6.25`, so the sign convention is embedded in the calibrated parameter.

**(F2) Hybrid New Keynesian Phillips curve / Calvo price-setting relation**:

\[
\pi_t =
\lambda x_t
+ \phi \pi_{t-1}
+ (1-\phi)\beta E_t \pi_{t+1}
+ \varepsilon^u_t
\]

The source-stated baseline is nested at `needs_review`: \(\theta=0\) and \(\phi=0\) give the forward-looking baseline model except for the implementation's shock naming and persistence treatment.

**(F3) Forward-looking desired interest-rate rule**:

\[
i^{\ast}_t =
\bar{i}
+ \gamma_{\pi}\big(E_t\pi_{t+1}-\bar{\pi}\big)
+ \gamma_x x_t
\]

The paper reports the Volcker-Greenspan estimates \(\gamma_{\pi}=2.15\), \(\gamma_x=0.93\), and smoothing \(\rho_i=0.79\). The MMB implementation sets \(\bar{i}=0\) and divides the output coefficient by 4 because the source estimates use annualized quarterly inflation and interest-rate data.

**(F4) Interest-rate partial adjustment**:

\[
i_t =
\rho_i i_{t-1}
+ (1-\rho_i)i^{\ast}_t
\]

Combining (F3) and (F4) gives the implemented policy rule

\[
i_t =
0.79 i_{t-1}
+ (1-0.79)\left(2.15 E_t\pi_{t+1}+\frac{0.93}{4}x_t\right).
\]

## 4. Market Clearing & Identities

**(F5) Output gap definition**:

\[
x_t \equiv y_t-z_t
\]

Here \(y_t\) is the stochastic component of output and \(z_t\) is the natural level of output that would obtain under flexible prices. The paper's footnote derivation also uses goods-market clearing to rewrite the log-linearized consumption Euler equation in output-gap form.

There is no separate money-market clearing equation when the nominal short rate is the policy instrument. The central bank supplies money endogenously to support the chosen interest-rate target, so an LM equation is intentionally omitted.

## 5. Exogenous Processes

**(F6) Shock processes used by the MMB implementation**:

\[
\varepsilon^d_t \sim \operatorname{i.i.d.}(0,\sigma_d^2),
\qquad
\varepsilon^u_t \sim \operatorname{i.i.d.}(0,\sigma_u^2)
\]

The source baseline writes AR(1) demand and cost-push processes,

\[
g_t=\mu g_{t-1}+\hat{g}_t,\quad u_t=\rho_u u_{t-1}+\hat{u}_t.
\]

For the Section 6 hybrid model, the paper explicitly sets these serial-correlation coefficients to zero for simplicity; the MMB file implements shocks as innovations `demand_` and `inflation_`.

## 6. Steady-State Solution

Because `NK_CGG99` is linearized around long-run values, the steady state is:

\[
\bar{x}=\bar{\pi}=\bar{i}=0,\qquad
\bar{\varepsilon}^d=\bar{\varepsilon}^u=0.
\]

The expected future and lagged variables equal the same zero steady-state values. The desired rate rule has \(\bar{i}=0\) in implementation units. No nonlinear steady-state system or `steady_state_model` derivation is required for this first-pass linear archive entry.

## 7. Timing & Form Conventions

- **Timing**: \(x_{t-1}\), \(\pi_{t-1}\), and \(i_{t-1}\) are predetermined lagged variables. \(E_t x_{t+1}\) and \(E_t\pi_{t+1}\) are one-period-ahead rational expectations.
- **Inflation**: \(\pi_t\) is period-\(t\) inflation, measured as a deviation from its long-run target/trend.
- **Interest rate**: \(i_t\) is the short nominal rate deviation. The ex ante real-rate gap in the IS curve is \(i_t-E_t\pi_{t+1}\).
- **Capital and stocks**: there is no capital stock in this compact model; the paper abstracts from investment and capital accumulation for the policy-analysis framework.
- **Linear form**: all equations are in log-linear/deviation form and correspond to Dynare `model(linear)`.
- **Uncertainty**: the exact mapping from the paper's broad survey equations to the Rep-MMB `NK_CGG99` calibration is marked `needs_review`, especially the coefficient choices for \(\theta\), \(\phi\), and \(\sigma\) that are described in the implementation comments as borrowed from Rotemberg-Woodford style calibration choices.

## 8. Variable & Parameter Reference Table

### Endogenous Variables

| ASCII name | Symbol | Meaning | Determined by |
|---|---|---|---|
| `x` | \(x_t\) | Output gap | (F1), (F5) |
| `pi` | \(\pi_t\) | Inflation deviation | (F2) |
| `i` | \(i_t\) | Short nominal interest-rate deviation | (F3), (F4) |

### Exogenous Shocks

| ASCII name | Symbol | Meaning | Equation |
|---|---|---|---|
| `demand_` | \(\varepsilon^d_t\) | Demand/IS innovation | (F6) |
| `inflation_` | \(\varepsilon^u_t\) | Cost-push/inflation innovation | (F6) |

### Parameters

| ASCII name | Symbol | Meaning | Source/cross-check value |
|---|---|---|---|
| `theta` | \(\theta\) | Lagged-output weight in hybrid IS curve | 0.44 in MMB implementation |
| `sigma` | \(\sigma\) | Implemented real-rate coefficient | -6.25 in MMB implementation; sign convention differs from paper's \(\varphi>0\) |
| `phi` | \(\phi\) | Lagged-inflation weight in hybrid Phillips curve | 0.48 in MMB implementation |
| `lambda` | \(\lambda\) | Output-gap slope in Phillips curve | 0.0244 in MMB implementation |
| `beta` | \(\beta\) | Discount factor in forward inflation term | \(1/(1+0.035/4)\) in MMB implementation |
| `gamma_pi` | \(\gamma_{\pi}\) | Desired-rate response to expected inflation | 2.15 from source Table 1 |
| `gamma_x` | \(\gamma_x\) | Desired-rate response to output gap | 0.93 source estimate; MMB uses \(0.93/4\) |
| `rho_i` | \(\rho_i\) | Interest-rate smoothing | 0.79 from source Table 1 |

Equation count: F1-F6. Runtime validation: not performed.
