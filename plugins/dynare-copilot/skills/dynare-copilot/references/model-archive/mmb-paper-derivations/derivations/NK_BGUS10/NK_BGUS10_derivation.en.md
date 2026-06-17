# NK_BGUS10 - Derivation (Optimization Problems + First-Order Conditions)

> First-pass archive extraction status: `needs_review`. Runtime validation was not performed.

Source: Blanchard, Olivier, and Jordi Gali (2010), "Labor markets and monetary policy: A New Keynesian model with unemployment," *American Economic Journal: Macroeconomics* 2(2), 1-30, DOI `10.1257/mac.2.2.1`.

## 1. Model Overview

- **Model**: MMB `NK_BGUS10`, the United States fluid-labor-market calibration of the Blanchard-Gali New Keynesian model with unemployment.
- **Purpose**: analyze productivity shocks and monetary policy trade-offs when price stickiness, labor-market hiring frictions, and real wage rigidity make unemployment inefficiently cyclical.
- **Agents and blocks**: a representative household, intermediate goods firms with hiring costs, monopolistically competitive final goods firms with Calvo pricing, and a monetary authority.
- **Form**: log-linear `model(linear)` system around a zero-inflation steady state. Lower-case hatted variables are log deviations except unemployment, which is a deviation from its steady-state rate.
- **Variant**: the MMB implementation uses the US/fluid labor-market calibration, with steady-state unemployment `u = 0.05` and job-finding rate `x = 0.7`.

## 2. Optimization Problems

### Representative Household

The household maximizes expected utility over consumption and employment:

$$
E_0 \sum_{t=0}^{\infty} \beta^t
\left(\log C_t - \chi \frac{N_t^{1+\phi}}{1+\phi}\right),
\qquad 0 \le N_t \le 1.
$$

The log-linear Euler condition used in the MMB entry is the consumption FOC of this household.

### Labor-Market Flows and Hiring Costs

At the start of period `t`, the unemployment pool is

$$
U_t = 1 - (1-\delta)N_{t-1}.
$$

Aggregate hires and labor-market tightness are

$$
H_t = N_t - (1-\delta)N_{t-1}, \qquad
x_t = \frac{H_t}{U_t}.
$$

Hiring costs per hire are proportional to productivity and increasing in tightness:

$$
G_t = A_t B x_t^\alpha.
$$

### Firms and Price Setting

Intermediate goods production is linear in employment:

$$
X_t(j) = A_t N_t(j).
$$

The real marginal cost combines the wage component, current hiring costs, and the expected continuation value of lower future hiring costs:

$$
MC_t =
\Theta A_t^{-\gamma}
+ B x_t^\alpha
- \beta(1-\delta)E_t\left[
\frac{C_t}{C_{t+1}}\frac{A_{t+1}}{A_t}B x_{t+1}^\alpha
\right].
$$

Final goods firms set prices under Calvo staggering. Log-linearization around a zero-inflation steady state gives the New Keynesian Phillips curve in Section 3.

### Monetary Authority

For the MMB `NK_BGUS10` entry, the policy rule is the optimized simple rule reported for the US calibration:

$$
i_t = \rho + \phi_\pi \pi_t + \phi_u \hat u_t,
$$

with implementation cross-check values `phi_pi = 5` and `phi_u = -0.8`.

## 3. First-Order Conditions

The following linearized equilibrium conditions are the model equations used by the MMB US calibration. Equation (F2) follows the paper's equation (25); the OCR line break was normalized and should be checked against the PDF if this entry is promoted beyond first-pass status.

- **(F1) New Keynesian Phillips curve**:

$$
\pi_t = \beta E_t\{\pi_{t+1}\} + \lambda \widehat{mc}_t.
$$

- **(F2) Real marginal cost under hiring costs and real wage rigidity** (`needs_review` OCR normalization):

$$
\widehat{mc}_t =
\alpha g\mathcal{M}\hat{x}_t
- \beta(1-\delta)g\mathcal{M}E_t\left[
(\hat{c}_t-\hat{a}_t)-(\hat{c}_{t+1}-\hat{a}_{t+1})+\alpha\hat{x}_{t+1}
\right]
- \Phi\gamma\hat{a}_t.
$$

- **(F3) Flexible-price marginal-cost counterpart**:

$$
\alpha g\mathcal{M}\hat{x}^f_t =
\beta(1-\delta)g\mathcal{M}E_t\left[
(\hat{c}^f_t-\hat{a}_t)-(\hat{c}^f_{t+1}-\hat{a}_{t+1})+\alpha\hat{x}^f_{t+1}
\right]
+ \Phi\gamma\hat{a}_t.
$$

- **(F4) Household Euler equation**:

$$
\hat{c}_t = E_t\{\hat{c}_{t+1}\} - \left(i_t - E_t\{\pi_{t+1}\} - \rho\right).
$$

- **(F5) Flexible-price household Euler equation**:

$$
\hat{c}^f_t = E_t\{\hat{c}^f_{t+1}\} - (r_t-\rho).
$$

## 4. Market Clearing & Identities

- **(F6) Labor-market tightness from employment dynamics**:

$$
\delta\hat{x}_t =
\hat{n}_t - (1-\delta)(1-x)\hat{n}_{t-1}.
$$

- **(F7) Flexible-price tightness from employment dynamics**:

$$
\delta\hat{x}^f_t =
\hat{n}^f_t - (1-\delta)(1-x)\hat{n}^f_{t-1}.
$$

- **(F8) Goods-market resource relation**:

$$
\hat{c}_t =
\hat{a}_t
+ \frac{1-g}{1-\delta g}\hat{n}_t
+ \frac{g(1-\delta)}{1-\delta g}\hat{n}_{t-1}
- \frac{\alpha g}{1-\delta g}\delta\hat{x}_t.
$$

- **(F9) Flexible-price resource relation**:

$$
\hat{c}^f_t =
\hat{a}_t
+ \frac{1-g}{1-\delta g}\hat{n}^f_t
+ \frac{g(1-\delta)}{1-\delta g}\hat{n}^f_{t-1}
- \frac{\alpha g}{1-\delta g}\delta\hat{x}^f_t.
$$

- **(F10) Optimized simple monetary policy rule, US calibration**:

$$
i_t = \rho + 5\pi_t - 0.8\hat{u}_t.
$$

- **(F11) Unemployment deviation and employment**:

$$
\hat{u}_t = -(1-u)\hat{n}_t.
$$

- **(F12) Flexible-price unemployment deviation and employment**:

$$
\hat{u}^f_t = -(1-u)\hat{n}^f_t.
$$

- **(F13) Output identity**:

$$
\hat{y}_t = \hat{a}_t + \hat{n}_t.
$$

- **(F14) Flexible-price output identity**:

$$
\hat{y}^f_t = \hat{a}_t + \hat{n}^f_t.
$$

## 5. Exogenous Processes

- **(F15) Technology process**:

$$
\hat{a}_t = \rho_a\hat{a}_{t-1} + \varepsilon^a_t.
$$

The MMB implementation writes the innovation with a negative sign, `a = ra*a(-1) - a_`; this sign convention is recorded as an implementation cross-check rather than a paper-side equation.

## 6. Steady-State Solution

Because the archived MMB entry is `model(linear)`, all endogenous model variables are expressed as deviations around steady state, so the steady state of the linear system is zero:

$$
\pi = \widehat{mc} = \hat{x} = \hat{c} = \hat{a} = \hat{n} = \hat{u} = i-\rho = 0,
$$

and likewise for the flexible-price counterparts.

The nonzero calibration objects underlying those deviations are:

$$
\mathcal{M}=\frac{\epsilon}{\epsilon-1}, \qquad
\lambda=\frac{(1-\beta\theta)(1-\theta)}{\theta}, \qquad
\rho=-\log\beta.
$$

For the US/fluid-labor-market calibration:

$$
u=0.05,\qquad x=0.7,\qquad
\delta=\frac{ux}{(1-u)(1-x)},\qquad
g=Bx^\alpha.
$$

The paper chooses `B` so that steady-state hiring costs are about one percent of GDP under the US calibration, sets `gamma = 0.5`, `alpha = 1`, `beta = 0.99`, `phi = 1`, `epsilon = 6`, and uses the constrained-efficient condition to pin down `chi`.

## 7. Timing & Form Conventions

- **Form**: linearized model, implemented with Dynare `model(linear)`.
- **Expectations**: forward-looking terms in (F1)-(F5) are dated with `E_t`.
- **Employment timing**: employment `N_t` includes workers hired during period `t`; beginning-of-period unemployment depends on `N_{t-1}`.
- **Tightness timing**: `x_t` is the period-`t` job-finding rate, defined from hires during period `t` divided by the beginning-of-period unemployment pool.
- **Shock sign**: the paper-side technology law is written as a standard AR(1); the Rep-MMB file uses `a = ra*a(-1) - a_`, so impulse signs should be checked before runtime comparisons.
- **Runtime validation**: not performed.

## 8. Variable & Parameter Reference Table

### Endogenous Variables

| ASCII name | Mathematical symbol | Meaning | Equation |
|---|---|---|---|
| `pi` | $\pi_t$ | Inflation | (F1) |
| `mc` | $\widehat{mc}_t$ | Real marginal cost | (F2) |
| `xhat` | $\hat{x}_t$ | Labor-market tightness | (F6) |
| `c` | $\hat{c}_t$ | Consumption | (F4), (F8) |
| `a` | $\hat{a}_t$ | Technology | (F15) |
| `n` | $\hat{n}_t$ | Employment | (F6), (F11) |
| `uhat` | $\hat{u}_t$ | Unemployment deviation | (F11) |
| `i` | $i_t$ | Nominal interest rate | (F10) |
| `xhatf` | $\hat{x}^f_t$ | Flexible-price tightness | (F7) |
| `cf` | $\hat{c}^f_t$ | Flexible-price consumption | (F5), (F9) |
| `nf` | $\hat{n}^f_t$ | Flexible-price employment | (F7), (F12) |
| `uhatf` | $\hat{u}^f_t$ | Flexible-price unemployment deviation | (F12) |
| `r` | $r_t$ | Natural/flexible-price real rate | (F5) |
| `y` | $\hat{y}_t$ | Output | (F13) |
| `yf` | $\hat{y}^f_t$ | Flexible-price output | (F14) |

### Exogenous Shock

| ASCII name | Mathematical symbol | Meaning |
|---|---|---|
| `a_` | $\varepsilon^a_t$ | Technology innovation |

### Parameters

| ASCII name | Mathematical symbol | Meaning / value cue |
|---|---|---|
| `gam` | $\gamma$ | Degree of real wage rigidity; baseline 0.5 |
| `alf` | $\alpha$ | Hiring-cost elasticity; baseline 1 |
| `the` | $\theta$ | Calvo price stickiness |
| `bet` | $\beta$ | Discount factor; 0.99 |
| `phi` | $\phi$ | Inverse Frisch elasticity; 1 |
| `eps` | $\epsilon$ | Elasticity of substitution; 6 |
| `lam` | $\lambda$ | Phillips-curve slope |
| `M` | $\mathcal{M}$ | Desired gross markup |
| `gdel` | $\delta g$ | Hiring-cost GDP share target |
| `ra` | $\rho_a$ | Technology persistence |
| `x_` | $x$ | Steady-state job-finding rate; US value 0.7 |
| `u` | $u$ | Steady-state unemployment; US value 0.05 |
| `del` | $\delta$ | Separation rate implied by `u` and `x_` |
| `g` | $g$ | Steady-state hiring-cost component |
| `B` | $B$ | Hiring-cost scale |
| `chi` | $\chi$ | Utility weight pinned by efficient steady state |
| `bphi` | $\Phi$ | Wage-rigidity composite in marginal cost |
| `alfux` | $\alpha_u$ | Welfare-loss unemployment weight |
| `gmu`, `xi0`, `xi1`, `k0`, `kl`, `kf` | composites | Policy-equation composite coefficients in the paper/implementation |
| `rho` | $\rho$ | $-\log\beta$ |
