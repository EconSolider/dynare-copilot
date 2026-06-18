# NK_RW06 - Optimal Monetary Policy with the Cost Channel

> Archive status: `needs_review`. Runtime validation was not performed. The MMB `.mod` file was used only as `implementation_cross_check`.

## 1. Model Overview

- **Model**: Ravenna and Walsh (2006), "Optimal monetary policy with the cost channel," `NK_RW06`.
- **Source**: `raw/mmb_mineru/runs/nk_rw06_nk_rw06al__optimal_monetary_policy_with_the_cost_channel__59aa85a1/full.md`; raw PDF `raw/mmb_papers/Optimal monetary policy with the cost channel.pdf`.
- **Core mechanism**: a New Keynesian sticky-price model with a cost channel. Firms borrow working capital to pay the wage bill, so the nominal interest rate enters real marginal cost and the Phillips curve directly.
- **Agents and blocks**: representative household, monopolistically competitive Calvo price setters, financial intermediaries, government/fiscal demand, and the monetary authority.
- **Form**: log-linear/linearized equilibrium conditions around steady state. The MMB implementation uses `model(linear)` with variables `x`, `pi`, and `R`, and one composite demand shock `u`.
- **Policy experiment represented in MMB**: a simple interest-rate rule cross-checked from `.agents/skills/dynare-copilot/references/examples/NK_RW06_rep.mod`, not the paper's full commitment/discretion optimal-control system.

## 2. Optimization Problems

### Household

The representative household chooses consumption, labor, deposits, and money balances. Preferences are

$$
E_t \sum_{i=0}^{\infty}\beta^i
\left[
\frac{\xi_{t+i} C_{t+i}^{1-\sigma}}{1-\sigma}
- \chi\frac{N_{t+i}^{1+\eta}}{1+\eta}
\right].
$$

The period cash and budget structure in the source implies an Euler equation, an intratemporal labor condition, and a cash-in-advance condition. In equilibrium with a positive nominal rate these conditions are recorded in Section 3.

### Final-Goods Demand Aggregator

The composite good is a Dixit-Stiglitz aggregate,

$$
C_t =
\left[
\int_0^1 c_{jt}^{(\theta-1)/\theta}dj
\right]^{\theta/(\theta-1)}, \qquad \theta>1.
$$

Cost minimization over differentiated goods gives individual demand and the aggregate price index.

### Firms and Cost Channel

Each firm produces with linear labor technology in the baseline theoretical model,

$$
y_{jt}=A_t N_{jt}.
$$

Under the cost channel, firms borrow working capital to pay labor before sales revenue arrives. The nominal cost of labor is therefore $R_t W_t$, so real marginal cost contains the nominal interest rate.

### Policy Maker

For the optimal-policy analysis, the policy maker minimizes a welfare-based quadratic loss in inflation and the welfare-relevant output gap, subject to the expectational IS relation and the cost-channel Phillips curve. The MMB implementation cross-check instead uses a simple Taylor-style rule, reported in Section 5 as `implementation_cross_check`.

## 3. First-Order Conditions

- **(F1) Household Euler equation**:

$$
\xi_t C_t^{-\sigma}
=
\beta E_t\left[
\frac{R_t P_t}{P_{t+1}}\xi_{t+1} C_{t+1}^{-\sigma}
\right].
$$

- **(F2) Household labor supply**:

$$
\frac{\chi N_t^\eta}{\xi_t C_t^{-\sigma}}
=
\frac{W_t}{P_t}.
$$

- **(F3) Cash-in-advance condition**:

$$
P_t C_t = M_t + W_t N_t - D_t.
$$

- **(F4) Flexible-price firm condition with the cost channel**:

$$
R_t^f w_t^f = \frac{A_t}{\Phi},
\qquad
\Phi \equiv \frac{\theta}{\theta-1}.
$$

- **(F5) Flexible-price output**:

$$
Y_t^f =
\left[
\frac{\xi_t \gamma_t^{-\sigma} A_t^{1+\eta}}
{\chi \Phi R_t^f}
\right]^{1/(\sigma+\eta)}.
$$

- **(F6) Log-linear flexible-price output**:

$$
\hat{Y}_t^f =
\frac{1}{\sigma+\eta}
\left[
(1+\eta)\hat{A}_t
-\sigma\hat{\gamma}_t
+\hat{\xi}_t
-\hat{R}_t^f
\right].
$$

- **(F7) Efficient output**:

$$
\hat{Y}_t^e =
\frac{(1+\eta)\hat{A}_t+\hat{\xi}_t+(1-\sigma)\hat{\gamma}_t}
{\sigma+\eta}.
$$

- **(F8) Constant-rate potential output**:

$$
\hat{Y}_t^{\ast} =
\frac{(1+\eta)\hat{A}_t-\sigma\hat{\gamma}_t+\hat{\xi}_t}
{\sigma+\eta}.
$$

- **(F9) Output gap definition**:

$$
x_t \equiv \hat{Y}_t-\hat{Y}_t^{\ast}.
$$

- **(F10) Welfare gap relation**:

$$
\hat{Y}_t-\hat{Y}_t^e =
x_t-\frac{1}{\sigma+\eta}\hat{\gamma}_t,
\qquad \text{when } z^{\ast}=0.
$$

## 4. Market Clearing & Identities

- **(F11) Differentiated-goods demand**:

$$
c_{jt} =
\left(\frac{p_{jt}}{P_t}\right)^{-\theta} C_t.
$$

- **(F12) Aggregate price index**:

$$
P_t =
\left[
\int_0^1 p_{jt}^{1-\theta}dj
\right]^{1/(1-\theta)}.
$$

- **(F13) Aggregate resource constraint**:

$$
Y_t = C_t + G_t.
$$

- **(F14) Government-purchase share identity**:

$$
G_t=(1-\gamma_t)Y_t,
\qquad
C_t=\gamma_t Y_t.
$$

- **(F15) Real marginal cost with the cost channel**:

$$
\varphi_t \equiv \frac{R_t w_t}{A_t}=R_t S_t.
$$

- **(F16) Log-linear marginal cost identity**:

$$
\hat{\varphi}_t \approx \hat{R}_t+\hat{s}_t.
$$

- **(F17) Marginal cost in output-gap form**:

$$
\hat{\varphi}_t =
(\sigma+\eta)x_t+\hat{R}_t.
$$

- **(F18) Expectational IS curve**:

$$
x_t =
E_t x_{t+1}
-\frac{1}{\sigma}\left(\hat{R}_t-E_t\pi_{t+1}\right)
+u_t.
$$

- **(F19) Cost-channel Phillips curve**:

$$
\pi_t =
\beta E_t\pi_{t+1}
+\kappa(\sigma+\eta)x_t
+\kappa\hat{R}_t.
$$

- **(F20) Calvo slope parameter**:

$$
\kappa=\frac{(1-\omega)(1-\omega\beta)}{\omega}.
$$

## 5. Exogenous Processes

- **(F21) Composite demand disturbance**:

$$
u_t \equiv
\frac{1+\eta}{\sigma+\eta}
\left[
(E_t\hat{A}_{t+1}-\hat{A}_t)
-\frac{\eta}{\sigma}(E_t\hat{\xi}_{t+1}-\hat{\xi}_t)
+\frac{\eta}{1+\eta}(E_t\hat{\gamma}_{t+1}-\hat{\gamma}_t)
\right].
$$

- **(F22) Productivity shock example used in the paper's discussion**:

$$
\hat{A}_t=\rho_a \hat{A}_{t-1}+a_t,
\qquad 0<\rho_a<1.
$$

- **(F23) Fiscal-share shock example used in the paper's calibration discussion**:

$$
\hat{\gamma}_t=\rho_\gamma \hat{\gamma}_{t-1}+\varepsilon^\gamma_t,
\qquad \rho_\gamma=0.9 \text{ in the reported fiscal-shock calibration.}
$$

- **(F24) Monetary-policy rule, implementation_cross_check**:

$$
\hat{R}_t = \phi_\pi \pi_t+\phi_x x_t.
$$

The paper's optimal-policy sections solve either commitment or discretion problems. The MMB `NK_RW06_rep.mod` uses (F24) instead, with `phipi=1.1` and `phix=1`; this rule is cross-check evidence for the MMB implementation, not a paper-side replacement for the optimal-policy derivation.

## 6. Steady-State Solution

Because the MMB implementation is linear, steady-state deviations are zero:

$$
\bar{x}=0,\qquad \bar{\pi}=0,\qquad \bar{\hat{R}}=0,\qquad \bar{u}=0.
$$

The paper's underlying nonlinear model uses positive steady-state gross nominal interest $\bar{R}$ and steady-state output

$$
\bar{Y} =
\left[
\frac{\bar{\gamma}^{-\sigma}}
{\chi\Phi\bar{R}}
\right]^{1/(\sigma+\eta)}
$$

when productivity and taste shocks are at their normalized steady values. For the welfare analysis, the source sets average efficiency distortions to zero through subsidies so that $z^{\ast}=0$ and the welfare gap is represented by (F10). `needs_review`: the paper references an appendix for the second-order welfare derivation; no local appendix normalization file exists for `NK_RW06`.

## 7. Timing & Form Conventions

- The archive entry is linear/log-linear; hatted variables are deviations around steady state, while `x_t` is the output gap relative to $\hat{Y}_t^{\ast}$.
- The nominal rate in the Phillips curve is a current-period policy rate deviation, $\hat{R}_t$.
- Inflation is forward-looking through $E_t\pi_{t+1}$.
- The IS equation uses $E_t x_{t+1}$ and $E_t\pi_{t+1}$; the composite shock `u_t` summarizes productivity, taste, and fiscal innovations as in (F21).
- There is no capital stock in the baseline theoretical model used for `NK_RW06`; no capital timing convention applies.
- Runtime validation was not performed, and Dynare was not run.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII name | Meaning | Determined by |
|---|---|---|---|
| Endogenous | $x_t$ / `x` | Output gap relative to constant-rate potential output | (F18), with policy rule (F24) in MMB |
| Endogenous | $\pi_t$ / `pi` | Inflation deviation | (F19) |
| Endogenous | $\hat{R}_t$ / `R` | Nominal interest-rate deviation | (F24) in MMB; policy instrument in optimal-policy analysis |
| Exogenous | $u_t$ / `u` | Composite demand disturbance | (F21); implemented as one exogenous shock in MMB |
| Auxiliary/source concept | $\hat{Y}_t^f$ | Flexible-price output | (F6) |
| Auxiliary/source concept | $\hat{Y}_t^e$ | Efficient output | (F7) |
| Auxiliary/source concept | $\hat{Y}_t^{\ast}$ | Constant-rate potential output | (F8) |
| Auxiliary/source concept | $\hat{A}_t$ | Productivity shock | (F21), (F22) |
| Auxiliary/source concept | $\hat{\xi}_t$ | Taste/preference shock | (F21) |
| Auxiliary/source concept | $\hat{\gamma}_t$ | Consumption/output share, inverse fiscal-demand share | (F14), (F21), (F23) |
| Parameter | $\sigma$ / `sigma` | Intertemporal elasticity inverse / CRRA coefficient | Source calibration: 1.5 |
| Parameter | $\eta$ / `eta` | Labor supply curvature | Source calibration: 1 |
| Parameter | $\beta$ / `beta` | Discount factor | Source calibration: 0.99 |
| Parameter | $\omega$ / `omega` | Calvo non-adjustment probability | Source calibration: 0.75 |
| Parameter | $\theta$ | Elasticity across differentiated goods | Source calibration: 11 for markup 1.1 |
| Parameter | $\kappa$ / `kappa` | Phillips curve slope | (F20) |
| Parameter | $\lambda$ | Welfare-gap weight | Source formula in Section 4 |
| Parameter | $\phi_\pi$ / `phipi` | Policy response to inflation | MMB cross-check: 1.1 |
| Parameter | $\phi_x$ / `phix` | Policy response to output gap | MMB cross-check: 1 |
| Parameter | $\rho_a$ | Productivity persistence | Paper example |
| Parameter | $\rho_\gamma$ | Fiscal-share persistence | Source calibration: 0.9 |

Equation count for the MMB implementation subset is three endogenous equations for `x`, `pi`, and `R`: (F18), (F19), and (F24). The broader paper-side derivation above records source equations and identities needed to understand how the reduced MMB system is obtained.
