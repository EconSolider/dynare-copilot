# EA_BE15 - Money in the Production Function: A New Keynesian DSGE Perspective

> First-pass private archive derivation for `EA_BE15`. Status: `needs_review`.
> Source: Jonathan Benchimol (2015), "Money in the Production Function: A New Keynesian DSGE Perspective", Southern Economic Journal 82(1), 152-184. DOI: `10.4284/0038-4038-2011.197`.
> Primary Markdown: `raw/mmb_mineru/runs/ea_be15__money_in_the_production_function_a_new_keynesian_dsge_perspective__1c7666dc/full.md`.
> Raw PDF path exists for provenance, but the PDF body was not opened.

## 1. Model Overview

- **Model**: Euro-area New Keynesian DSGE model with real money balances in the production function.
- **Paper-side source match**: first Markdown lines report "Money in the Production Function: A New Keynesian DSGE Perspective" and "Author(s): Jonathan Benchimol", matching the `EA_BE15` model-index row.
- **Agents**: a representative household, monopolistically competitive firms with Calvo pricing, and a central bank setting a smoothed nominal interest-rate rule.
- **Money blocks**: households hold real balances for nonproductive use, while firms use real money balances as a productive input. A quantity/velocity equation links total real money to output.
- **Estimated/implemented form**: log-linear `model(linear)`. The paper states the DSGE model in eight equations for sticky- and flexible-price variables; the MMB implementation cross-check also uses `model(linear)`.
- **Runtime validation**: not performed. No Dynare run was executed, and this derivation was not promoted to the runnable skill archive.

## 2. Optimization Problems

### Household

The representative household maximizes expected discounted utility,

$$
E_t\sum_{k=0}^{\infty}\beta^k U_{t+k},
$$

with period utility

$$
U_t=e^{\varepsilon_t^u}\left[
\frac{C_t^{1-\sigma}}{1-\sigma}
+\frac{\gamma e^{\varepsilon_t^n}}{1-\nu}\left(\frac{M_{n,t}}{P_t}\right)^{1-\nu}
-\frac{\chi N_t^{1+\eta}}{1+\eta}
\right],
$$

subject to the nominal budget constraint

$$
P_t C_t+M_{n,t}+M_{p,t}+Q_tB_t
\le B_{t-1}+W_tN_t+M_{n,t-1}+M_{p,t-1}.
$$

The appendix Lagrangian rewrites the constraint in real terms with money changes and real bond positions. The household chooses consumption, labor, nonproductive money balances, productive money carried in the aggregate budget, and bonds. The paper's active household money FOC is for nonproductive money balances.

### Firms

Each firm produces differentiated goods with productive money balances:

$$
Y_t(i)=e^{\varepsilon_t^a}
\left(e^{\varepsilon_t^p}\frac{M_{p,t}}{P_t}\right)^{\alpha_m}
N_t(i)^{1-\alpha_n}.
$$

Firms face isoelastic demand and Calvo price setting. In period `t`, only a fraction `1-\theta` can reset its price. A resetting firm chooses `P_t^*` to maximize the expected discounted value of profits while that price remains effective. The paper then works with a first-order Taylor expansion around zero inflation.

### Central Bank

The central bank is represented by a smoothed Taylor-type rule. The paper tests five variants according to which money gap, if any, enters the rule. The `EA_BE15` MMB implementation uses the productive-money-gap variant.

## 3. First-Order Conditions

The primitive household FOCs in the appendix are:

$$
\lambda_t=e^{\varepsilon_t^u}C_t^{-\sigma},
$$

$$
\lambda_t Q_t=\beta E_t\left[\lambda_{t+1}\frac{P_t}{P_{t+1}}\right],
$$

$$
\gamma e^{\varepsilon_t^u}e^{\varepsilon_t^n}
\left(\frac{M_{n,t}}{P_t}\right)^{-\nu}
=\lambda_t-\beta E_t\left[\lambda_{t+1}\frac{P_t}{P_{t+1}}\right],
$$

$$
\chi e^{\varepsilon_t^u}N_t^{\eta}
=\lambda_t\frac{W_t}{P_t}.
$$

These imply the log-linear IS curve, household real-money demand, and labor-supply relation used in the aggregate model. The reduced DSGE conditions below are the model equations that define the archived `EA_BE15` system.

**(F1) Flexible-price output**

$$
y_t^f=v_a^y\varepsilon_t^a+v_p^y\varepsilon_t^p+v_m^y mp_{p,t}^f+v_c^y.
$$

The coefficients are functions of `sigma`, `eta`, `alpha_n`, `alpha_m`, markup terms, and steady-state constants. OCR and implementation notation agree on the functional form; coefficient formulas are `needs_review` at source level before review promotion.

**(F2) Flexible-price household money demand**

$$
mp_{n,t}^f=\frac{\sigma}{\nu}y_t^f-\frac{a_2}{\nu}\sigma E_t[\Delta y_{t+1}^f]
-\frac{\rho_m+\rho_c a_2}{\nu}+\frac{1}{\nu}\varepsilon_t^n.
$$

**(F3) Flexible-price productive money identity**

$$
mp_{p,t}^f=y_t^f-mp_{n,t}^f-\zeta_t.
$$

**(F4) New Keynesian Phillips curve with productive money gap**

$$
\pi_t=\beta E_t[\pi_{t+1}]
+\psi_x(y_t-y_t^f)
+\psi_m(mp_{p,t}-mp_{p,t}^f).
$$

The money term comes from the production-function channel and the marginal-cost gap. The paper defines

$$
\psi_x=
\frac{\eta+\alpha_n-(1-\alpha_n)(1-\sigma)}
{1-\alpha_n+\varepsilon(2\alpha_n-1)}
(1-\theta)\left(\frac{1}{\theta}-\beta\right),
$$

$$
\psi_m=
\frac{1-\alpha_n-\alpha_m(1+\eta)}
{1-\alpha_n+\varepsilon(2\alpha_n-1)}
(1-\theta)\left(\frac{1}{\theta}-\beta\right).
$$

The OCR is readable, but these coefficient formulas should be checked against the PDF or author source before any reviewed status.

**(F5) Dynamic IS equation**

$$
y_t=E_t[y_{t+1}]
-\sigma^{-1}\left(i_t-E_t[\pi_{t+1}]-\rho_c\right)
-\sigma^{-1}E_t[\Delta\varepsilon_{t+1}^u].
$$

**(F6) Household nonproductive money demand**

$$
mp_{n,t}=\frac{\sigma}{\nu}y_t-\frac{a_2}{\nu}i_t-\frac{\rho_m}{\nu}
+\frac{1}{\nu}\varepsilon_t^n.
$$

**(F7) Productive money identity**

$$
mp_{p,t}=y_t-mp_{n,t}-\zeta_t.
$$

**(F8) Smoothed Taylor rule**

$$
i_t=(1-\lambda_i)
\left[\lambda_\pi(\pi_t-\pi^*)+\lambda_x(y_t-y_t^f)+M_{k,t}\right]
+\lambda_i i_{t-1}+\varepsilon_t^i.
$$

For the MMB `EA_BE15` implementation, the cross-check uses

$$
M_{k,t}=\lambda_2(mp_{p,t}-mp_{p,t}^f),
$$

matching the paper's `k=2` rule variant. This variant identification is from the implementation cross-check and should be reviewed against the intended MMB experiment metadata.

## 4. Market Clearing & Identities

Goods-market clearing gives `Y_t=C_t` in the aggregate log-linear model. The productive-money block uses the paper's quantity/velocity closure:

$$
P_tY_t=e^{\zeta_t}M_t,
$$

which implies

$$
y_t=mp_t+\zeta_t=mp_{n,t}+mp_{p,t}+\zeta_t.
$$

The flexible-price analogue is already recorded as (F3), and the sticky-price identity is recorded as (F7). Labor-market clearing is used in the derivation of aggregate production and marginal cost:

$$
y_t=\varepsilon_t^a+\alpha_m\varepsilon_t^p+(1-\alpha_n)n_t+\alpha_m mp_{p,t}.
$$

The Calvo price-index relation and resetting-price FOC are intermediate equations used to derive (F4), not additional model equations in the final eight-equation DSGE block.

## 5. Exogenous Processes

**(F9) Velocity process**

$$
\zeta_t=\zeta+\lambda_s\left[\lambda_{ms}\varepsilon_{n,t}+(1-\lambda_{ms})\varepsilon_{p,t}\right].
$$

**(F10) Technology shock**

$$
\varepsilon_{a,t}=\rho_a\varepsilon_{a,t-1}+\xi_{a,t}.
$$

**(F11) Household money-demand shock**

$$
\varepsilon_{n,t}=\rho_n\varepsilon_{n,t-1}+\xi_{n,t}.
$$

**(F12) Firm money-demand shock**

$$
\varepsilon_{p,t}=\rho_p\varepsilon_{p,t-1}+\xi_{p,t}.
$$

**(F13) Monetary-policy shock**

$$
\varepsilon_{i,t}=\rho_i\varepsilon_{i,t-1}+\xi_{i,t}.
$$

**(F14) Preference shock**

$$
\varepsilon_{u,t}=\rho_u\varepsilon_{u,t-1}+\xi_{u,t}.
$$

Each innovation is normal i.i.d. with mean zero and standard deviation `sigma_j` in the paper. The MMB implementation names the innovations `ua`, `un`, `up`, `ui`, and `uu`.

## 6. Steady-State Solution

Because `EA_BE15` is archived as a linearized `model(linear)` system, the dynamic variables in (F1)-(F8) are log deviations or transformed observable gaps around the approximation point. The implementation sets the linear model directly, so no nonlinear `steady_state_model` was extracted.

Steady-state and coefficient definitions needed for the linear system:

1. `beta` fixes the steady real rate with `rho_c=-ln(beta)`.
2. `rho_m=-ln(gamma)+a_1`, with
   $a_1=\ln(1-\exp(-1/\beta))-\frac{1/\beta}{\exp(1/\beta)-1}$ and
   $a_2=\frac{1}{\exp(1/\beta)-1}$ in the implementation cross-check.
3. The flexible-price coefficients `v_a^y`, `v_p^y`, `v_m^y`, and `v_c^y` are functions of `alpha_n`, `alpha_m`, `eta`, `sigma`, markup terms, and constants from the marginal-cost expression.
4. Inflation target `pi^*` is explicit in (F8); the implementation cross-check uses `cible` for this target.
5. Shock steady states are zero for the AR(1) deviations; velocity has mean `zeta`.

Steady-state quality is `needs_review`: the derivation records the linear system and coefficient formulas, but it does not independently reconstruct or validate all macroparameter transformations.

## 7. Timing & Form Conventions

- **Form**: log-linear `model(linear)`.
- **Expectations**: `E_t[x_{t+1}]` corresponds to Dynare `x(+1)` in the implementation.
- **Policy timing**: the Taylor rule contains lagged nominal interest rate `i_{t-1}` / `ir(-1)`.
- **Stock variables**: there is no capital stock in this model. Money balances enter as real balances, separated into nonproductive household balances `mp_n` and productive firm balances `mp_p`.
- **Output gaps**: `y_t-y_t^f` and `mp_{p,t}-mp_{p,t}^f` are central state gaps in the Phillips curve and Taylor-rule variants.
- **Implementation cross-check**: the `.mod` file confirms variables `y, pi, ir, mp, mn, yf, mpf, mnf, ea, eu, ei, ep, en, vel, rr, ygap`; exogenous shocks `ua, uu, ui, up, un`; and the `k=2` productive-money Taylor-rule variant.

## 8. Variable & Parameter Reference Table

| Category | Symbol / implementation name | Meaning | Main equation |
|---|---|---|---|
| Endogenous | `yf`, $y_t^f$ | flexible-price output | (F1) |
| Endogenous | `mnf`, $mp_{n,t}^f$ | flexible-price nonproductive real money balances | (F2) |
| Endogenous | `mpf`, $mp_{p,t}^f$ | flexible-price productive real money balances | (F3) |
| Endogenous | `pi`, $\pi_t$ | inflation | (F4) |
| Endogenous | `y`, $y_t$ | output | (F5) |
| Endogenous | `mn`, $mp_{n,t}$ | nonproductive real money balances | (F6) |
| Endogenous | `mp`, $mp_{p,t}$ | productive real money balances | (F7) |
| Endogenous | `ir`, $i_t$ | nominal interest rate | (F8) |
| Endogenous | `vel`, $\zeta_t$ | time-varying velocity | (F9) |
| Endogenous | `ea` | technology shock state | (F10) |
| Endogenous | `en` | household money-demand shock state | (F11) |
| Endogenous | `ep` | firm money-demand shock state | (F12) |
| Endogenous | `ei` | monetary-policy shock state | (F13) |
| Endogenous | `eu` | preference shock state | (F14) |
| Auxiliary endogenous | `rr` | ex-post real interest-rate expression, `ir-pi(+1)` | identity, implementation cross-check |
| Auxiliary endogenous | `ygap` | output gap, `y-yf` | identity, implementation cross-check |
| Exogenous | `ua`, $\xi_{a,t}$ | technology innovation | (F10) |
| Exogenous | `un`, $\xi_{n,t}$ | household money-demand innovation | (F11) |
| Exogenous | `up`, $\xi_{p,t}$ | firm money-demand innovation | (F12) |
| Exogenous | `ui`, $\xi_{i,t}$ | monetary-policy innovation | (F13) |
| Exogenous | `uu`, $\xi_{u,t}$ | preference innovation | (F14) |
| Parameter | `alphan`, $\alpha_n$ | labor exponent / returns parameter | (F1), (F4) |
| Parameter | `alpham`, $\alpha_m$ | productive money exponent | (F1), (F4) |
| Parameter | `beta`, $\beta$ | discount factor | (F2), (F4), (F5) |
| Parameter | `teta`, $\theta$ | Calvo price stickiness | (F4) |
| Parameter | `nu`, $\nu$ | inverse elasticity of money holdings | (F2), (F6) |
| Parameter | `sigma`, $\sigma$ | risk aversion / inverse IES | (F2), (F5), (F6) |
| Parameter | `gamma`, $\gamma$ | household money utility scale | (F2), (F6) |
| Parameter | `khi`, $\chi$ | labor disutility scale | household FOC |
| Parameter | `neta`, $\eta$ | inverse Frisch elasticity | (F1), (F4) |
| Parameter | `epsilon`, $\varepsilon$ | demand elasticity / markup parameter | (F4) |
| Parameter | `a1`, `a2` | Taylor approximation constants for money demand | (F2), (F6) |
| Parameter | `li1`, $\lambda_i$ | interest-rate smoothing | (F8) |
| Parameter | `li2`, $\lambda_\pi$ | inflation response | (F8) |
| Parameter | `li3`, $\lambda_x$ | output-gap response | (F8) |
| Parameter | `cible`, $\pi^*$ | inflation target | (F8) |
| Parameter | `rhoa1`, `rhon1`, `rhop1`, `rhoi1`, `rhou1` | AR(1) persistence parameters | (F10)-(F14) |
| Parameter | `vel0`, $\zeta$ | velocity mean | (F9) |
| Parameter | `vel1`, $\lambda_s$ | velocity shock loading | (F9) |
| Parameter | `vel2`, $\lambda_{ms}$ | velocity mix between household and firm money shocks | (F9) |
| Parameter | `vym`, `vyc`, `vya`, `vyp` | flexible-output coefficient aliases | (F1) |
| Parameter | `mnf1`, `mnf2`, `mnf3`, `mnf4` | flexible nonproductive-money coefficient aliases | (F2) |
| Parameter | `pi1`, `pi2` | Phillips curve coefficient aliases | (F4) |
