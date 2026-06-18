# NK_CGG99AL - Derivation (Optimization Problems + First-Order Conditions)

> First-pass archive status: `needs_review`. This entry is source-backed by the MinerU Markdown for Clarida, Gali, and Gertler (1999). The article deliberately presents a compact log-linear policy model rather than a fully enumerated primitive household/firm economy, so primitive optimization details are summarized only where the paper states their source.

## 1. Model Overview

- **Model**: `NK_CGG99AL`, based on Clarida, Gali, and Gertler (1999), "The Science of Monetary Policy: A New Keynesian Perspective."
- **Purpose**: Monetary-policy design in a baseline New Keynesian model with a forward-looking IS curve, a forward-looking Phillips curve, exogenous demand and cost-push disturbances, and central-bank policy under discretion or commitment.
- **Agents and blocks**: A representative household saving problem underlying the IS relation; monopolistically competitive firms with Calvo-style staggered price setting underlying the Phillips curve; a central bank choosing the short nominal interest rate; exogenous demand and cost-push shock processes.
- **Form**: Log-linear, reduced-form New Keynesian model. Variables are deviations from long-run levels or stochastic components in logs. There is no capital accumulation in the baseline formulation.
- **Core source cues**: The baseline framework and equations are in the paper's Section 2.1; the policy objective is in Section 2.2; discretion is in Section 3; commitment rules are in Section 4.2.

## 2. Optimization Problems

### 2.1 Household saving problem behind aggregate demand

The paper states that the IS curve is obtained by log-linearizing the household consumption Euler equation and imposing the goods-market condition that consumption equals output net of government purchases. The primitive household utility function is not written in the article. A generic representation consistent with the source statement is:

$$\max_{\{C_t,B_t\}} E_0 \sum_{t=0}^{\infty}\beta^t U(C_t) \quad\text{s.t.}\quad P_t C_t + Q_t B_t \leq B_{t-1}+Y_t^{h}-P_t T_t.$$

This primitive problem is an interpretation of the paper's stated Euler-equation origin, not a source-printed equation; it is therefore `needs_review` before use as a structural derivation.

### 2.2 Firms' staggered pricing problem

The paper describes monopolistically competitive firms that choose a nominal price when allowed to reset, subject to Calvo-style restrictions on future adjustment opportunities. It does not spell out the full reset-price objective in primitive notation. A source-consistent generic problem is:

$$\max_{P_t^{\ast}} E_t \sum_{j=0}^{\infty}(\beta\theta)^j \Lambda_{t,t+j}\left[P_t^{\ast}Y_{t+j|t}-P_{t+j}MC_{t+j}Y_{t+j|t}\right],$$

subject to the demand schedule for the firm's differentiated good. This generic reset-price problem is marked `needs_review` because the article uses it only to motivate the log-linear Phillips curve.

### 2.3 Central-bank policy problem

The central bank chooses paths or feedback rules for the output gap, inflation, and the nominal policy rate to maximize the quadratic objective:

$$\max -\frac{1}{2}E_t\left\{\sum_{i=0}^{\infty}\beta^i\left[\alpha x_{t+i}^2+\pi_{t+i}^2\right]\right\}.$$

Under discretion, the central bank reoptimizes each period and takes private-sector expectations as given. Under commitment, it chooses a state-contingent sequence or rule recognizing that the rule influences expectations.

## 3. First-Order Conditions

**Private-sector equilibrium conditions**

- **(F1) Output gap definition**:
$$x_t \equiv y_t-z_t.$$

- **(F2) Forward-looking IS curve**:
$$x_t=-\varphi\left(i_t-E_t\pi_{t+1}\right)+E_t x_{t+1}+g_t.$$

- **(F3) Forward-looking Phillips curve**:
$$\pi_t=\lambda x_t+\beta E_t\pi_{t+1}+u_t.$$

- **(F4) Euler-equation source expression for output demand**:
$$y_t-e_t=-\varphi\left(i_t-E_t\pi_{t+1}\right)+E_t\left(y_{t+1}-e_{t+1}\right).$$

- **(F5) Demand shock definition from potential output and government purchases**:
$$g_t=E_t\left(\Delta z_{t+1}-\Delta e_{t+1}\right).$$

- **(F6) Forward solution for aggregate demand**:
$$x_t=E_t\sum_{i=0}^{\infty}\left\{-\varphi\left(i_{t+i}-\pi_{t+1+i}\right)+g_{t+i}\right\}.$$

- **(F7) Marginal-cost Phillips curve representation**:
$$\pi_t=\beta E_t\pi_{t+1}+\delta mc_t.$$

- **(F8) Output-gap mapping for marginal cost**:
$$mc_t=\kappa x_t.$$

- **(F9) Forward solution for inflation**:
$$\pi_t=E_t\sum_{i=0}^{\infty}\beta^i\left(\lambda x_{t+i}+u_{t+i}\right).$$

**Discretionary policy conditions**

- **(F10) Static discretionary target problem**:
$$\max_{x_t,\pi_t}-\frac{1}{2}\left(\alpha x_t^2+\pi_t^2\right)+F_t \quad\text{s.t.}\quad \pi_t=\lambda x_t+f_t.$$

- **(F11) Discretionary optimality condition**:
$$x_t=-\frac{\lambda}{\alpha}\pi_t.$$

- **(F12) Discretionary output-gap solution**:
$$x_t=-\lambda q u_t,\qquad q=\frac{1}{\lambda^2+\alpha(1-\beta\rho)}.$$

- **(F13) Discretionary inflation solution**:
$$\pi_t=\alpha q u_t.$$

- **(F14) Interest-rate rule implementing discretion**:
$$i_t=\gamma_\pi E_t\pi_{t+1}+\frac{1}{\varphi}g_t.$$

- **(F15) Inflation response coefficient under discretion**:
$$\gamma_\pi=1+\frac{(1-\rho)\lambda}{\rho\varphi\alpha}>1.$$

**Commitment policy conditions**

- **(F16) Restricted commitment output-gap rule**:
$$x_t^c=-\omega u_t.$$

- **(F17) Restricted commitment inflation solution**:
$$\pi_t^c=\frac{1-\lambda\omega}{1-\beta\rho}u_t.$$

- **(F18) Restricted commitment trade-off representation**:
$$\pi_t^c=\frac{\lambda}{1-\beta\rho}x_t^c+\frac{1}{1-\beta\rho}u_t.$$

- **(F19) Restricted commitment optimality condition**:
$$x_t^c=-\frac{\lambda}{\alpha^c}\pi_t^c,\qquad \alpha^c=\alpha(1-\beta\rho).$$

- **(F20) Restricted commitment output-gap solution**:
$$x_t^c=-\lambda q^c u_t,\qquad q^c=\frac{1}{\lambda^2+\alpha^c(1-\beta\rho)}.$$

- **(F21) Restricted commitment inflation solution**:
$$\pi_t^c=\alpha^c q^c u_t.$$

- **(F22) Interest-rate rule implementing restricted commitment**:
$$i_t=\gamma_\pi^c E_t\pi_{t+1}+\frac{1}{\varphi}g_t.$$

- **(F23) Inflation response coefficient under restricted commitment**:
$$\gamma_\pi^c=1+\frac{(1-\rho)\lambda}{\rho\varphi\alpha^c}>\gamma_\pi.$$

- **(F24) Unconstrained commitment difference rule**:
$$x_{t+i}-x_{t+i-1}=-\frac{\lambda}{\alpha}\pi_{t+i},\qquad i=1,2,3,\ldots.$$

- **(F25) Initial-period condition for unconstrained commitment**:
$$x_t=-\frac{\lambda}{\alpha}\pi_t.$$

- **(F26) Interest-rate rule associated with the unconstrained commitment discussion**:
$$i_t=\left(1-\frac{\lambda}{\alpha\varphi}\right)E_t\pi_{t+1}+\frac{1}{\varphi}g_t.$$

## 4. Market Clearing & Identities

- **(F27) Goods-market condition used to obtain the IS curve**:
$$Y_t=C_t+E_t^{g}.$$

- **(F28) Log government-purchase transformation**:
$$e_t\equiv-\log\left(1-\frac{E_t^{g}}{Y_t}\right).$$

- **(F29) Output decomposition**:
$$y_t=x_t+z_t.$$

The paper abstracts from investment and capital accumulation in the baseline model. It also treats the nominal interest rate as the policy instrument, so a separate money-market equilibrium condition is not required; the money supply adjusts to support the interest-rate target.

## 5. Exogenous Processes

- **(F30) Demand shock process**:
$$g_t=\mu g_{t-1}+\hat{g}_t,\qquad 0\leq\mu\leq 1.$$

- **(F31) Cost-push shock process**:
$$u_t=\rho u_{t-1}+\hat{u}_t,\qquad 0\leq\rho\leq 1.$$

- **(F32) Shock moments**:
$$E[\hat{g}_t]=E[\hat{u}_t]=0,\qquad Var(\hat{g}_t)=\sigma_g^2,\qquad Var(\hat{u}_t)=\sigma_u^2.$$

The MinerU OCR for the innovation on the demand shock is visibly damaged in the source text, so the conventional notation `\hat{g}_t` is used here with `needs_review`.

## 6. Steady-State Solution

Because the model is already log-linear and variables are expressed as deviations from long-run levels, the deterministic steady state is normalized to zero for the gap, inflation deviation, policy-rate deviation, and shocks:

$$\bar{x}=0,\qquad \bar{\pi}=0,\qquad \bar{i}=0,\qquad \bar{g}=0,\qquad \bar{u}=0.$$

The natural-output component and actual-output stochastic component satisfy:

$$\bar{y}=\bar{z},\qquad \bar{x}=\bar{y}-\bar{z}=0.$$

The demand and cost-push AR(1) processes imply zero steady-state disturbances when innovations have zero mean:

$$\bar{g}=\mu\bar{g}=0,\qquad \bar{u}=\rho\bar{u}=0.$$

The policy objective is centered on zero inflation deviation and zero output gap. No nonlinear steady-state calibration or Dynare `steady_state_model` was run for this first-pass archive entry.

## 7. Timing & Form Conventions

- **Information timing**: Expectations are conditional on information at time `t`, written as `E_t`.
- **Interest-rate timing**: `i_t` is the short nominal interest rate chosen at time `t`; the real-rate term in the IS curve is `i_t-E_t\pi_{t+1}`.
- **Inflation timing**: `\pi_t` is inflation from `t-1` to `t`, expressed as a deviation from trend.
- **State variables**: The baseline model has no capital stock or endogenous predetermined stock variable. Persistence enters through the exogenous AR(1) processes for `g_t` and `u_t`; the unconstrained commitment rule creates dependence on lagged output gap.
- **Model form**: Log-linear reduced form. A Dynare implementation would normally use `model(linear)`.
- **Uncertainty**: Equations (F4), (F5), (F7), (F8), and (F32) should be source-checked before promotion because the article states the primitive derivations compactly and the OCR has visible symbol damage.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII name | Meaning | Equation reference |
|---|---|---|---|
| Endogenous | `x` / $x_t$ | Output gap | (F1), (F2), (F3), (F10)-(F26), (F29) |
| Endogenous | `y` / $y_t$ | Stochastic component of output, log deviation | (F1), (F4), (F27), (F29) |
| Endogenous | `pi` / $\pi_t$ | Inflation deviation | (F3), (F7), (F9)-(F26) |
| Endogenous | `i` / $i_t$ | Short nominal policy interest rate deviation | (F2), (F6), (F14), (F22), (F26) |
| Endogenous/reference | `mc` / $mc_t$ | Real marginal cost deviation | (F7), (F8) |
| Exogenous/state | `z` / $z_t$ | Natural level of output, stochastic component in logs | (F1), (F5), (F29) |
| Exogenous/state | `g` / $g_t$ | Demand shock | (F2), (F5), (F6), (F14), (F22), (F26), (F30) |
| Exogenous/state | `u` / $u_t$ | Cost-push shock | (F3), (F9), (F12), (F13), (F16)-(F21), (F31) |
| Exogenous innovation | `eps_g` / $\hat{g}_t$ | Demand-shock innovation | (F30), (F32) |
| Exogenous innovation | `eps_u` / $\hat{u}_t$ | Cost-push innovation | (F31), (F32) |
| Exogenous/reference | `eg` / $E_t^g$ | Government purchases in the goods-market identity | (F27), (F28) |
| Parameter | `beta` / $\beta$ | Discount factor in objective and Phillips curve | (F3), (F9), (F17)-(F23) |
| Parameter | `varphi` / $\varphi$ | Interest elasticity of aggregate demand / intertemporal substitution channel | (F2), (F4), (F6), (F14), (F15), (F22), (F23), (F26) |
| Parameter | `lambda` / $\lambda$ | Phillips-curve slope with respect to the output gap | (F3), (F9), (F11)-(F26) |
| Parameter | `alpha` / $\alpha$ | Relative weight on output-gap stabilization in the policy objective | (F10)-(F15), (F24)-(F26) |
| Parameter | `alpha_c` / $\alpha^c$ | Effective output-gap weight under restricted commitment | (F19)-(F23) |
| Parameter | `rho` / $\rho$ | Cost-push shock persistence | (F15), (F17)-(F23), (F31) |
| Parameter | `mu` / $\mu$ | Demand shock persistence | (F30) |
| Parameter | `delta_mc` / $\delta$ | Coefficient on marginal cost in the marginal-cost Phillips relation | (F7) |
| Parameter | `kappa` / $\kappa$ | Elasticity mapping marginal cost to output gap | (F8) |
| Parameter | `omega` / $\omega$ | Restricted commitment feedback coefficient on the cost-push shock | (F16), (F17) |
| Parameter | `q`, `q_c` / $q,q^c$ | Reduced-form policy-solution coefficients | (F12), (F20) |
| Parameter | `gamma_pi`, `gamma_pi_c` / $\gamma_\pi,\gamma_\pi^c$ | Inflation response coefficients in interest-rate rules | (F14), (F15), (F22), (F23) |
| Parameter | `sigma_g`, `sigma_u` / $\sigma_g,\sigma_u$ | Innovation standard deviations | (F32) |

Equation count: (F1)-(F32). Runtime validation: not performed.
