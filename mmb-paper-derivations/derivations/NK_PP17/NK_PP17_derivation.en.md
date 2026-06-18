# NK_PP17 - Coordinating Monetary and Macroprudential Policies

> Archive status: first-pass source-backed derivation; `needs_review`.
> Runtime validation: not performed. The Rep-MMB `.mod` file was read only as `implementation_cross_check`; Dynare was not run.

Provenance: `NK_PP17`, De Paoli and Paustian (2017), "Coordinating monetary and macroprudential policies," Journal of Money, Credit and Banking 49(2-3), 319-349, DOI `10.1111/jmcb.12381`. Primary source Markdown is `raw/mmb_mineru/runs/nk_pp17__coordinating_monetary_and_macroprudential_policies__7a9fb3e4/full.md`; raw PDF is `raw/mmb_papers/Coordinating monetary and macroprudential policies.pdf`; MinerU run id `7a9fb3e4-aa53-43fb-8193-d10c6ee867a1`.

## 1. Model Overview

- **Model**: New Keynesian sticky-price cashless economy with financial intermediaries, a costly-enforcement friction, fixed capital, and variable utilization.
- **Paper purpose**: compare cooperative and noncooperative monetary and macroprudential policy under discretion and commitment.
- **Rep-MMB closure**: the implementation uses a linearized equilibrium system with a simple Taylor rule and an inactive macroprudential instrument, `S_t=0`.
- **Agents**: representative household, intermediate good producers, monopolistically competitive final good firms with Rotemberg price adjustment, financial intermediaries, monetary authority, and macroprudential authority.
- **Form**: `model(linear)` in the implementation cross-check. Hatted variables are deviations from steady state; `\widehat{\phi}_t`, `\widehat{S}_t`, and `\widehat{R}_t` are level deviations as stated near paper equation (26).
- **Key distortions**: nominal rigidity, markup shocks, a working-capital cost channel, endogenous credit spreads, and an always-binding bank incentive constraint.

## 2. Optimization Problems

### 2.1 Households

Households choose consumption, deposits, labor, and utilization services. Preferences are

```math
U(c_t,L_t,u_t)=\frac{c_t^{1-\sigma}}{1-\sigma}
-\frac{L_t^{1+\theta}}{1+\theta}
-\frac{u_t^{1+\theta}}{1+\theta}.
```

The real budget constraint is

```math
c_t+A_t=\Omega_w w_t L_t+\Omega_r r_t u_t+\frac{R_{t-1}}{\pi_t}A_{t-1}+T_t+\Pi_t.
```

### 2.2 Intermediate Good Producers

Intermediate firms hire labor and utilization services to produce

```math
x_t=L_t^{\alpha}u_t^{1-\alpha}.
```

They borrow the wage bill in advance from banks. Profits are

```math
\text{profits}_t=p_t x_t-R_t^B w_t L_t-r_t u_t.
```

The spread is defined by the loan rate relative to the deposit rate; the log-linear system uses `\phi_t` as the credit spread.

### 2.3 Final Good Firms

Final good firms aggregate differentiated goods with elasticity `\varepsilon_t`; productivity maps intermediate output into final output, and real marginal cost is

```math
z_t=\frac{p_t}{a_t}.
```

Rotemberg price adjustment costs are

```math
\frac{\varphi}{2}(\pi_t-1)^2y_t.
```

### 2.4 Financial Intermediaries

Banks lend to firms, receive deposits, and face a subsidy/tax on funding costs. The banker value is recursively represented by continuation values on loans and net worth. The bank incentive constraint is

```math
V_{jt}\geq \lambda_t B_{jt}.
```

With a binding constraint and leverage `\delta_t=B_{jt}/N_{jt}`, bank net worth evolves from retained banker wealth and shocks. The paper sets the startup-fund term `\omega=0` to obtain a simple log-linear system.

### 2.5 Policy Authorities

The monetary instrument is the nominal interest rate deviation `\widehat{R}_t`; the benchmark macroprudential instrument is the bank funding subsidy `\widehat{S}_t`. The paper studies optimal policy games, but the Rep-MMB file closes the model with a Taylor rule and `S_t=0`.

## 3. First-Order Conditions

The following equations are the source-backed equilibrium conditions used for the `NK_PP17` archive entry. Paper equation numbers are noted where available.

- **(F1) Household labor supply**:

```math
\frac{L_t^\theta}{c_t^{-\sigma}}=\Omega_w w_t.
```

- **(F2) Household utilization supply**:

```math
\frac{u_t^\theta}{c_t^{-\sigma}}=\Omega_r r_t.
```

- **(F3) Household Euler equation**:

```math
c_t^{-\sigma}=\beta E_t\left(c_{t+1}^{-\sigma}\frac{R_t}{\pi_{t+1}}\right).
```

- **(F4) Intermediate producer labor demand with working-capital finance**:

```math
\alpha p_t x_t=(1+\phi_t)R_t w_t L_t.
```

- **(F5) Intermediate producer utilization demand**:

```math
(1-\alpha)p_t x_t=r_t u_t.
```

- **(F6) Rotemberg Phillips curve in nonlinear source form**:

```math
0=(1-\varepsilon_t)+\varepsilon_t z_t-\varphi(\pi_t-1)\pi_t
-\beta E_t\left[
\frac{c_{t+1}^{-\sigma}}{c_t^{-\sigma}}
\varphi(\pi_{t+1}-1)\pi_{t+1}\frac{y_{t+1}}{y_t}
\right].
```

- **(F7) Bank value of loans**:

```math
v_{b,t}=(1-\gamma)(\phi_t+S_t)
+E_t\gamma\beta\Lambda_{t,t+1}\pi_{b,t+1}v_{b,t+1}.
```

- **(F8) Bank value of net worth**:

```math
v_{n,t}=(1-\gamma)(1-S_t)
+E_t\gamma\beta\Lambda_{t,t+1}\pi_{n,t+1}v_{n,t+1}.
```

- **(F9) Binding incentive constraint / leverage**:

```math
\delta_t=\frac{v_{n,t}}{\lambda_t-v_{b,t}}.
```

- **(F10) Aggregate bank net worth source equation**:

```math
N_t=\gamma\left[\phi_{t-1}\delta_{t-1}+1-S_{t-1}(1-\delta_{t-1})\right]R_{t-1}N_{t-1}
+\omega B_{t-1}+N_t^s.
```

For the simplified linear system, the paper sets `\omega=0`.

- **(F11) Linear Phillips curve, paper equation (22)**:

```math
\widehat{\pi}_t=\kappa\left[
(\sigma+\theta)\widehat{y}_t^g
+\alpha(\widehat{R}_t+b\widehat{\phi}_t)
+\widehat{\varepsilon}_t
\right]+\beta E_t\widehat{\pi}_{t+1}.
```

- **(F12) Linear Euler / IS equation, paper equation (23)**:

```math
\widehat{R}_t=\sigma E_t\Delta\widehat{y}_{t+1}^g
+\frac{\theta+1}{\sigma+\theta}\sigma E_t\Delta\widehat{a}_{t+1}
+E_t\widehat{\pi}_{t+1}.
```

- **(F13) Linear net worth evolution, paper equation (24); `needs_review` OCR tag spacing**:

```math
\widehat{n}_t=\widehat{n}_{t-1}+\widehat{R}_{t-1}-\widehat{\pi}_t
+\frac{1}{\phi\delta+1}\left[
\phi\delta\widehat{\delta}_{t-1}
+\delta\widehat{\phi}_{t-1}
+(\delta-1)\widehat{S}_{t-1}
\right]+\widehat{n}_t^s.
```

- **(F14) Firm labor demand and bank-sector balance relation, paper equation (25)**:

```math
\widehat{\delta}_t+\widehat{n}_t
=(1+\sigma+\theta)\widehat{y}_t^g
+\frac{\theta+1}{\sigma+\theta}\widehat{a}_t
-(1-\alpha)(\widehat{R}_t+b\widehat{\phi}_t).
```

- **(F15) Incentive compatibility in linear form, paper equation (26)**:

```math
\widehat{\delta}_t+\widehat{\lambda}_t
=\delta\widehat{\phi}_t+(\delta-1)\widehat{S}_t
+\beta E_t\left[
(\phi\delta+1)\widehat{\delta}_{t+1}
+\widehat{\lambda}_{t+1}
\right].
```

## 4. Market Clearing & Identities

- **(F16) Final-good market clearing with Rotemberg costs**:

```math
y_t=c_t+\frac{\varphi}{2}(\pi_t-1)^2y_t.
```

- **(F17) Output gap definition**:

```math
\widehat{y}_t^g=\widehat{y}_t-\frac{1+\theta}{\sigma+\theta}\widehat{a}_t.
```

- **(F18) Effective borrowing-cost / credit-distortion index**:

```math
\widehat{f}_t=\widehat{R}_t+b\widehat{\phi}_t,
\qquad b=\frac{1}{1+\phi}.
```

- **(F19) Marginal-cost expression used by the implementation cross-check**:

```math
\widehat{z}_t=\kappa\left[(\sigma+\theta)\widehat{y}_t^g
+\alpha(\widehat{R}_t+b\widehat{\phi}_t)\right].
```

- **(F20) Macroprudential closure in the Rep-MMB implementation**:

```math
\widehat{S}_t=0.
```

- **(F21) Taylor-rule closure in the Rep-MMB implementation**:

```math
\widehat{R}_t=\tau\widehat{\pi}_t+\tau_g\widehat{y}_t^g+\widehat{\varepsilon}_{R,t}.
```

## 5. Exogenous Processes

The paper states autoregressive shocks for productivity, markup, net worth, and moral hazard. The Rep-MMB implementation adds an autoregressive monetary policy shock:

- **(F22) Technology shock**:

```math
\widehat{a}_t=\rho_a\widehat{a}_{t-1}+\eta_{a,t}.
```

- **(F23) Markup shock**:

```math
\widehat{\varepsilon}_t=\rho_m\widehat{\varepsilon}_{t-1}+\eta_{m,t}.
```

- **(F24) Net worth shock**:

```math
\widehat{n}^s_t=\rho_n\widehat{n}^s_{t-1}+\eta_{n,t}.
```

- **(F25) Monetary policy shock, implementation cross-check closure**:

```math
\widehat{\varepsilon}_{R,t}=\rho_R\widehat{\varepsilon}_{R,t-1}+\eta_{R,t}.
```

- **(F26) Moral-hazard shock**:

```math
\widehat{\lambda}_t=\rho_l\widehat{\lambda}_{t-1}+\eta_{l,t}.
```

The Rep-MMB `.mod` uses sign conventions `a=rho_a*a(-1)-eta_a`, `ns=rho_n*ns(-1)-eta_n`, and `eps_R=rho_R*eps_R(-1)-eta_R`; these are implementation conventions, not separate paper-side formulas.

## 6. Steady-State Solution

Because the archived implementation is `model(linear)`, the operational steady state is zero for all hatted endogenous variables:

```math
\widehat{y}=\widehat{y}^g=\widehat{R}=\widehat{\pi}=\widehat{\phi}
=\widehat{n}=\widehat{\delta}=\widehat{S}=\widehat{z}=0.
```

Steady-state levels and calibration targets from the paper and implementation cross-check:

1. `\beta=0.99`, `\sigma=1`.
2. Labor/input share `\alpha=0.50`.
3. Steady-state leverage `\delta=9`.
4. Steady-state credit spread `\phi=0.02`, so `b=1/(1+\phi)`.
5. Elasticity of substitution `\epsilon=10`.
6. Price adjustment cost `\varphi=211` in the Rep-MMB file; the paper text reports `173.08`, so this is a calibration discrepancy to review.
7. `\kappa=(\epsilon-1)/\varphi`.
8. Shock persistence: `\rho_a=0.95`, `\rho_m=0.95`, `\rho_n=0`; the Rep-MMB file supplies `\rho_R=0.5` and `\rho_l=0.5` because those are not given in the paper.

No nonlinear steady-state reconstruction or Dynare validation was performed.

## 7. Timing & Form Conventions

- **Form**: `model(linear)`; variables represent log deviations from steady state except `\widehat{\phi}_t`, `\widehat{S}_t`, and `\widehat{R}_t`, which are level deviations.
- **Predetermined states**: bank net worth, leverage, spread, subsidy, and the nominal rate appear lagged in the net worth law of motion.
- **Forward-looking variables**: inflation, output gap growth, productivity growth, leverage, and moral-hazard terms appear with expectations in (F11), (F12), and (F15).
- **Financial convention**: bank leverage is loans relative to banker net worth, `\delta_t=B_{jt}/N_{jt}`.
- **Capital convention**: there is no capital accumulation; the model has fixed capital and variable utilization services.
- **Policy convention**: paper policy analysis studies optimal cooperative and noncooperative choices of `R_t` and `S_t`; Rep-MMB closes the model with a Taylor rule and `S_t=0`.
- **Runtime validation**: not performed.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Determined by |
|---|---|---|---|
| Endogenous | `y` / `\widehat{y}_t` | output deviation | (F17), implementation identity |
| Endogenous | `yg` / `\widehat{y}^g_t` | output gap | (F17) |
| Endogenous | `R` / `\widehat{R}_t` | nominal interest rate deviation | (F12), (F21) |
| Endogenous | `pi` / `\widehat{\pi}_t` | inflation deviation | (F11) |
| Endogenous | `phi` / `\widehat{\phi}_t` | credit spread deviation | (F15), (F18) |
| Endogenous | `n` / `\widehat{n}_t` | real bank net worth | (F13) |
| Endogenous | `del` / `\widehat{\delta}_t` | bank leverage | (F14), (F15) |
| Endogenous | `S` / `\widehat{S}_t` | macroprudential subsidy | (F20), or optimal-policy problem outside Rep-MMB closure |
| Endogenous | `z` / `\widehat{z}_t` | marginal-cost index | (F19) |
| Endogenous shock state | `a` / `\widehat{a}_t` | technology state | (F22) |
| Endogenous shock state | `eps_m` / `\widehat{\varepsilon}_t` | markup shock state | (F23) |
| Endogenous shock state | `ns` / `\widehat{n}^s_t` | net worth shock state | (F24) |
| Endogenous shock state | `eps_R` / `\widehat{\varepsilon}_{R,t}` | monetary policy shock state | (F25) |
| Endogenous shock state | `lam` / `\widehat{\lambda}_t` | moral-hazard shock state | (F26) |
| Exogenous | `eta_a` | technology innovation | -- |
| Exogenous | `eta_m` | markup innovation | -- |
| Exogenous | `eta_n` | net worth innovation | -- |
| Exogenous | `eta_R` | monetary-policy innovation | -- |
| Exogenous | `eta_l` | moral-hazard innovation | -- |
| Parameter | `betta` / `\beta` | discount factor | -- |
| Parameter | `sig` / `\sigma` | risk aversion / intertemporal substitution parameter | -- |
| Parameter | `alfa` / `\alpha` | share of inputs requiring working-capital finance | -- |
| Parameter | `thet` / `\theta` | inverse labor supply elasticity | -- |
| Parameter | `eps` / `\epsilon` | goods substitution elasticity | -- |
| Parameter | `del_ss` / `\delta` | steady-state leverage | -- |
| Parameter | `phi_ss` / `\phi` | steady-state credit spread | -- |
| Parameter | `varphi` / `\varphi` | Rotemberg adjustment cost | -- |
| Parameter | `b` | `1/(1+\phi)` | -- |
| Parameter | `kap` / `\kappa` | Phillips-curve slope, `(eps-1)/varphi` | -- |
| Parameter | `rho_a, rho_m, rho_n, rho_R, rho_l` | shock persistence coefficients | -- |
| Parameter | `tau, tau_g` | Taylor-rule coefficients | -- |
