# NK_RW06AL - Derivation (Optimization Problems + First-Order Conditions)

> Model archive entry for `NK_RW06AL`. Source: Federico Ravenna and Carl E. Walsh (2006), "Optimal monetary policy with the cost channel", *Journal of Monetary Economics* 53(2), 199-216, DOI `10.1016/j.jmoneco.2005.01.004`.

## 1. Model Overview

- **Model**: linearized New Keynesian cost-channel model, archived here for the MMB adaptive-learning variant `NK_RW06AL`.
- **Paper-side purpose**: study optimal monetary policy when firms borrow working capital to pay wages before selling output, so the nominal interest rate enters real marginal cost directly.
- **Implementation variant**: the MMB `NK_RW06AL` `.mod` is an adaptive-learning implementation of the compact policy model. The `.mod` is used only as `implementation_cross_check`, not as a paper-side equation source.
- **Agents and blocks**: representative household, monopolistically competitive final-goods firms with Calvo price setting, competitive financial intermediaries, fiscal authority, and monetary authority.
- **Rigidities and wedges**: Calvo sticky prices, monopolistic competition, government-purchase wedge through $C_t=\gamma_tY_t$, preference/taste shock $\xi_t$, productivity shock $A_t$, and working-capital cost channel.
- **Form**: `model(linear)`. The paper derives nonlinear primitives, then works with log deviations around steady state. The MMB implementation has endogenous variables `x`, `pi`, and `R` plus modelbase reporting variables.
- **Runtime validation**: not performed. Dynare was not run for this archive entry.

## 2. Optimization Problems

### Representative Household

The household chooses consumption, labor, deposits, and money holdings to maximize expected utility:

$$
E_t\sum_{i=0}^{\infty}\beta^i\left[
\frac{\xi_{t+i}C_{t+i}^{1-\sigma}}{1-\sigma}
-\chi\frac{N_{t+i}^{1+\eta}}{1+\eta}
\right].
$$

Composite consumption aggregates differentiated goods:

$$
C_t=\left[\int_0^1 c_{jt}^{(\theta-1)/\theta}\,dj\right]^{\theta/(\theta-1)},\qquad \theta>1.
$$

The household faces a cash-in-advance constraint and a money-accumulation equation:

$$
P_tC_t\le M_t+W_tN_t-D_t,
$$

$$
M_{t+1}=M_t+W_tN_t-D_t-P_tC_t+R_tD_t+\Pi_t-T_t.
$$

### Goods Demand and Price Index

Cost minimization for the composite good implies demand for firm $j$ and the aggregate price index:

$$
c_{jt}=\left(\frac{p_{jt}}{P_t}\right)^{-\theta}C_t,
$$

$$
P_t=\left[\int_0^1 p_{jt}^{1-\theta}\,dj\right]^{1/(1-\theta)}.
$$

### Firms and the Cost Channel

Firm $j$ produces with linear labor technology:

$$
y_{jt}=A_tN_{jt}.
$$

The working-capital assumption is that the firm borrows the wage bill before production revenue is received. If $R_t$ is the gross nominal interest rate and $w_t=W_t/P_t$, real marginal cost is:

$$
\varphi_t\equiv \frac{R_tw_t}{A_t}=R_tS_t.
$$

Under flexible prices, the firm sets marginal cost equal to the inverse markup:

$$
\frac{R_tw_t}{A_t}=\frac{\theta-1}{\theta}=\frac{1}{\Phi},\qquad \Phi\equiv\frac{\theta}{\theta-1}.
$$

### Calvo Price Setting

A fraction $1-\omega$ of firms can reset prices each period; the remaining fraction updates previous prices by the steady-state inflation rate. The first-order condition for price setting implies the linear New Keynesian Phillips curve used by the paper.

### Fiscal and Policy Environment

Goods-market clearing and the government-purchase share are:

$$
Y_t=C_t+G_t,\qquad G_t=(1-\gamma_t)Y_t,\qquad C_t=\gamma_tY_t.
$$

The paper's policy problem uses the nominal interest rate as the policy instrument and derives a welfare loss in inflation and a welfare-relevant output gap.

## 3. First-Order Conditions

- **(F1) Household Euler equation**:

$$
\xi_tC_t^{-\sigma}
=\beta E_t\left(\frac{R_tP_t}{P_{t+1}}\right)\xi_{t+1}C_{t+1}^{-\sigma}.
$$

- **(F2) Household labor supply**:

$$
\frac{\chi N_t^{\eta}}{\xi_tC_t^{-\sigma}}=\frac{W_t}{P_t}=w_t.
$$

- **(F3) Cash-in-advance condition**:

$$
P_tC_t=M_t+W_tN_t-D_t.
$$

- **(F4) Flexible-price output**:

$$
Y_t^f=\left[
\frac{\xi_t\gamma_t^{-\sigma}A_t^{1+\eta}}{\chi\Phi R_t^f}
\right]^{1/(\sigma+\eta)}.
$$

- **(F5) Flexible-price output in log deviations**:

$$
\hat Y_t^f=\frac{1}{\sigma+\eta}
\left[(1+\eta)\hat A_t-\sigma\hat\gamma_t+\hat\xi_t-\hat R_t^f\right].
$$

- **(F6) Efficient output**:

$$
Y_t^e=\left[
\frac{\xi_t\gamma_t^{1-\sigma}A_t^{1+\eta}}{\chi}
\right]^{1/(\sigma+\eta)}.
$$

- **(F7) Real marginal cost with cost channel**:

$$
\hat\varphi_t\approx \hat R_t+\hat s_t,
$$

where $\hat s_t$ is the log deviation of labor's share around steady state.

- **(F8) Inflation adjustment equation**:

$$
\pi_t=\beta E_t\pi_{t+1}+\kappa\hat\varphi_t,\qquad
\kappa=\frac{(1-\omega)(1-\omega\beta)}{\omega}.
$$

- **(F9) Cost-channel Phillips curve in marginal-cost form**:

$$
\pi_t=\beta E_t\pi_{t+1}+\kappa(\hat R_t+\hat s_t).
$$

- **(F10) IS curve in gap form**:

$$
\hat Y_t-\hat Y_t^f
=E_t(\hat Y_{t+1}-\hat Y_{t+1}^f)
-\frac{1}{\sigma}\left[
(\hat R_t-E_t\pi_{t+1})-\hat r_t^f
\right].
$$

- **(F11) Phillips curve in flexible-price-gap form**:

$$
\pi_t=\beta E_t\pi_{t+1}
+\kappa(\sigma+\eta)(\hat Y_t-\hat Y_t^f)
+\kappa(\hat R_t-\hat R_t^f).
$$

- **(F12) Welfare output gap and loss**:

$$
L_t=\pi_t^2+\lambda(\hat Y_t-\hat Y_t^e-z^{\ast})^2,
$$

with

$$
\hat Y_t^e=\frac{(1+\eta)\hat A_t+\hat\xi_t+(1-\sigma)\hat\gamma_t}{\sigma+\eta}.
$$

- **(F13) Constant-interest flexible output reference**:

$$
\hat Y_t^{\ast}=\frac{(1+\eta)\hat A_t-\sigma\hat\gamma_t+\hat\xi_t}{\sigma+\eta}.
$$

- **(F14) Cost-channel marginal cost in terms of $x_t$**:

$$
\hat\varphi_t=(\sigma+\eta)x_t+\hat R_t,\qquad
x_t\equiv \hat Y_t-\hat Y_t^{\ast}.
$$

- **(F15) Policy-model IS curve**:

$$
x_t=E_tx_{t+1}-\frac{1}{\sigma}(\hat R_t-E_t\pi_{t+1})+u_t.
$$

- **(F16) Policy-model Phillips curve**:

$$
\pi_t=\beta E_t\pi_{t+1}+\kappa(\sigma+\eta)x_t+\kappa\hat R_t.
$$

- **(F17) Composite demand disturbance**:

$$
u_t\equiv \frac{1+\eta}{\sigma+\eta}
\left[
(E_t\hat A_{t+1}-\hat A_t)
-\frac{\eta}{\sigma}(E_t\hat\xi_{t+1}-\hat\xi_t)
+\frac{\eta}{1+\eta}(E_t\hat\gamma_{t+1}-\hat\gamma_t)
\right].
$$

- **(F18) Discretionary optimality condition**:

$$
\pi_t=-\frac{\lambda}{\kappa\eta}
\left[x_t-\frac{1}{\sigma+\eta}\hat\gamma_t\right].
$$

`needs_review`: (F18) is source-stated for discretionary optimal policy; the MMB `NK_RW06AL` adaptive-learning implementation uses a policy-rule block rather than this optimality condition.

## 4. Market Clearing & Identities

- **(F19) Aggregate resource constraint**:

$$
Y_t=C_t+G_t.
$$

- **(F20) Government-purchase share**:

$$
G_t=(1-\gamma_t)Y_t,\qquad C_t=\gamma_tY_t.
$$

- **(F21) Firm loan-market identity**:

$$
W_tN_t^d=D_t+X_t.
$$

- **(F22) Cash injection identity**:

$$
X_t=M_{t+1}-M_t=(G_{t+1}^M-1)M_t.
$$

- **(F23) MMB reporting identity for annualized interest** (`implementation_cross_check`):

$$
\text{interest}_t=4R_t.
$$

- **(F24) MMB reporting identity for annualized inflation** (`implementation_cross_check`):

$$
\text{inflationq}_t=4\pi_t.
$$

- **(F25) MMB four-quarter inflation identity** (`implementation_cross_check`):

$$
\text{pinf4}_t=\frac{1}{4}
\left(\text{inflationq}_t+\text{inflationq}_{t-1}
+\text{inflationqls}_{t-1}\right).
$$

- **(F26) MMB output-gap reporting identity** (`implementation_cross_check`):

$$
\text{outputgap}_t=x_t,\qquad \text{output}_t=x_t.
$$

## 5. Exogenous Processes

The paper defines the composite demand disturbance in (F17) from productivity, taste, and fiscal shocks. It illustrates productivity shocks with an AR(1):

- **(F27) Productivity process**:

$$
\hat A_t=\rho_a\hat A_{t-1}+\varepsilon^a_t,\qquad 0<\rho_a<1.
$$

The fiscal share $\gamma_t$ is calibrated in the policy exercise as a persistent shock:

- **(F28) Fiscal-share process**:

$$
\hat\gamma_t=\rho_\gamma\hat\gamma_{t-1}+\varepsilon^\gamma_t.
$$

For `NK_RW06AL`, the implementation keeps a single structural demand shock and one modelbase monetary-policy shock:

- **(F29) MMB demand shock** (`implementation_cross_check`):

$$
u_t=\varepsilon^u_t.
$$

- **(F30) MMB policy-rule shock** (`implementation_cross_check`):

$$
\text{interest}_t=\text{policy rule terms}+\text{std\_r\_}\,\varepsilon^{R}_t.
$$

## 6. Steady-State Solution

The archive entry is for a linearized model. All variables in the compact policy model are log deviations or percentage-point deviations around the deterministic steady state:

$$
\bar x=\bar\pi=\bar R=\bar u=0.
$$

The nonlinear primitives imply these normalizations:

$$
\bar A=1,\qquad \bar\xi=1,\qquad \bar\gamma\in(0,1),\qquad
\bar R=\frac{1}{\beta}\quad\text{in gross nominal steady-state terms}.
$$

The steady-state output level in the flexible-price economy is:

$$
\bar Y=\left[
\frac{\bar\gamma^{-\sigma}}{\chi\Phi\bar R}
\right]^{1/(\sigma+\eta)}.
$$

The efficient output level differs because government purchases are proportional to output:

$$
\bar Y^e=\left[
\frac{\bar\gamma^{1-\sigma}}{\chi}
\right]^{1/(\sigma+\eta)}.
$$

For the MMB adaptive-learning implementation, the calibrated parameters reported in the `.mod` are:

$$
\sigma=1.5,\qquad \eta=1,\qquad \beta=0.99,\qquad \omega=0.75,
\qquad \kappa=\frac{(1-\omega)(1-\omega\beta)}{\omega}.
$$

Runtime validation, Blanchard-Kahn checks, and adaptive-learning solution checks are deferred.

## 7. Timing & Form Conventions

- **Timing**: the compact MMB model is forward-looking and linear. The IS curve uses $x_{t+1}$ and $\pi_{t+1}$ expectations; the Phillips curve uses expected inflation.
- **Stocks**: the paper model used here abstracts from capital, so there is no capital-in-production timing convention to resolve.
- **Interest rate notation**: the paper's $R_t$ is the gross nominal interest rate; in the linearized equations $\hat R_t$ is the deviation of the nominal interest rate. The MMB `.mod` variable `R` is the linear deviation used in the compact equations.
- **Output gap**: $x_t=\hat Y_t-\hat Y_t^{\ast}$ is the gap from the flexible-price output level under a constant-interest policy, not necessarily the gap from the efficient output level.
- **Adaptive learning**: `NK_RW06AL` adds adaptive-learning metadata (`AL_Info`) and restricts the policy-rule lead/lag structure. This is implementation metadata, not a separate paper-side optimization problem.
- **Form**: `model(linear)`; all steady-state deviations are zero in the `.mod` model block.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII name | Meaning | Determined by |
|---|---|---|---|
| Endogenous | $x_t$ / `x` | Output gap relative to $\hat Y_t^{\ast}$ | (F15), policy rule |
| Endogenous | $\pi_t$ / `pi` | Inflation deviation | (F16) |
| Endogenous | $\hat R_t$ / `R` | Nominal interest-rate deviation | policy rule / (F30) |
| Reporting endogenous | `interest` | Annualized interest rate | (F23), policy rule |
| Reporting endogenous | `inflationq` | Annualized quarterly inflation | (F24) |
| Reporting endogenous | `inflation`, `pinf4` | Four-quarter inflation measures | (F25) |
| Reporting endogenous | `outputgap`, `output` | MMB output/output-gap report variables | (F26) |
| Exogenous | $u_t$ / `u` | Composite demand disturbance | (F17), (F29) |
| Exogenous | $\varepsilon^R_t$ / `interest_` | Modelbase monetary-policy shock | (F30) |
| Exogenous primitive | $\hat A_t$ | Productivity shock | (F27) |
| Exogenous primitive | $\hat\gamma_t$ | Fiscal-share shock | (F28) |
| Exogenous primitive | $\hat\xi_t$ | Taste/preference shock | (F17) |
| Parameter | $\sigma$ / `sigma` | Inverse intertemporal elasticity / CRRA coefficient | - |
| Parameter | $\eta$ / `eta` | Inverse Frisch labor-supply elasticity | - |
| Parameter | $\beta$ / `beta` | Discount factor | - |
| Parameter | $\omega$ / `omega` | Calvo non-adjustment probability | - |
| Parameter | $\kappa$ / `kappa` | Phillips-curve slope | (F8) |
| Parameter | $\theta$ | Elasticity of substitution across goods | - |
| Parameter | $\Phi$ | Gross markup $\theta/(\theta-1)$ | - |
| Parameter | $\chi$ | Labor-disutility scale in paper primitives | - |
| Parameter | $\lambda$ | Welfare-gap weight in loss function | (F12) |
| Parameter | `cofint*`, `std_r_` | Modelbase policy-rule coefficients | (F30) |

Equation coverage note: the paper-side compact policy model is represented by (F15)-(F16) plus either an optimal-policy condition such as (F18) or an implementation policy rule such as (F30). The additional identities record source primitives and MMB reporting variables for audit.
