# US_BKM12 -- Derivation (Optimization Problems + First-Order Conditions)

> This derivation is for source-backed organization in the private model archive. It is not yet intended to generate a runnable Dynare `.mod` file directly. Current status: `needs_review`. The published paper is a reset-price-inflation application built around a modified and reestimated Smets-Wouters model; the local `US_BKM12_rep.mod` is used only as an implementation cross-check.

## 1. Model Overview

- Model: Bils, Klenow, and Malin (2012), "Reset Price Inflation and the Impact of Monetary Policy Shocks".
- MMB code: `US_BKM12`.
- Paper metadata: Mark Bils, Peter J. Klenow, and Benjamin A. Malin, 2012, *American Economic Review* 102(6), 2798-2825, DOI `10.1257/aer.102.6.2798`.
- Form: reestimated bimonthly Smets-Wouters DSGE in log-linear `model(linear)` form. The paper states that it removes price indexation when evaluating reset price inflation because CPI micro data do not show the small nominal changes implied by indexation.
- Frequency and sample: bimonthly model estimated for the modern 1989/1990-2009 sample and evaluated against CPI Research Database reset-price statistics.
- Agents: final-good aggregator, differentiated intermediate-goods firms, representative household, wage-setting labor union, fiscal authority, and central bank.
- Main frictions: external habit, investment adjustment costs, variable capital utilization, Calvo prices and wages, Kimball goods/labor curvature, sticky wages, monetary-policy smoothing, and seven structural shocks.
- Reset-price layer: the paper constructs empirical and model-consistent reset inflation $`\pi^{\ast}_t`$ from price changers and Calvo timing; this measurement object is central to the archive entry even though it is not a standard DSGE optimization condition.

## 2. Optimization Problems

### 2.1 Final-Good Aggregator

The final-good sector aggregates differentiated intermediate goods. Strategic complementarities enter through a Kimball-style demand curvature, so the price Phillips curve is flatter than in a simple Dixit-Stiglitz/Calvo model. The paper describes the model as a Smets-Wouters environment with a Kimball kink and emphasizes that removing that kink steepens the short-run Phillips curve. The exact source-level Kimball aggregator is not printed in the article body and remains `needs_review`.

### 2.2 Intermediate-Goods Firms

Intermediate-goods firms rent capital services and labor and produce differentiated goods:

```math
y_t=\phi_p\left[\alpha k_t+(1-\alpha)l_t+a_t\right].
```

In log-linear form, marginal cost combines factor prices and technology:

```math
mc_t=\alpha r^k_t+(1-\alpha)w_t-a_t.
```

Price setting follows Calvo timing. For the one-sector model used in the main comparison with reset inflation, the paper imposes a bimonthly price-change frequency of 31.2 percent and removes price indexation for nonadjusting prices. With markup shocks removed, the implementation cross-check sets the price-markup innovation variance to zero in simulations, but the state remains in the linear system for coverage.

### 2.3 Representative Household

The household chooses consumption, investment, bonds, capital, capital utilization, and labor supply in a Smets-Wouters environment with external habit. The source-side nonlinear problem is not printed in full in the article body; the archive therefore records the log-linear equilibrium conditions and marks the nonlinear FOC derivation as `needs_review`.

The linearized consumption Euler equation uses habit-adjusted consumption, expected consumption, expected labor, the ex ante real policy rate, and the stochastic discount-factor shock:

```math
c_t=c_1c_{t-1}+(1-c_1)E_tc_{t+1}
 +c_2(l_t-E_tl_{t+1})
 -c_3(r_t-E_t\pi_{t+1})+b_t.
```

Investment adjustment costs generate a forward- and backward-looking investment equation with Tobin's $`q`$ and the investment-specific technology shock.

### 2.4 Labor Union

Wage setting follows Calvo timing with a wage-markup shock and Kimball labor-market curvature. The paper's model-comparison section identifies sticky wages and wage indexation as important strategic complementarities. The `US_BKM12_rep.mod` cross-check includes wage indexation (`cindw`) and a wage markup process (`sw`), while price indexation is set to zero in the reset-inflation variant (`cindp=0.671` appears in the implementation but the paper-side reset-price exercise removes nominal price indexation; this discrepancy is marked `needs_review`).

## 3. First-Order Conditions

The following equations record the linear equilibrium system used for the archive draft. Variables are deviations from the balanced-growth steady state. The flexible-economy block is included because the policy rule responds to the output gap relative to flexible-price output.

**(F1) Flexible-economy factor-price relation**

```math
a_t=\alpha r^k_{f,t}+(1-\alpha)w_{f,t}.
```

**(F2) Flexible capital utilization**

```math
z_{f,t}=\frac{1-c_z}{c_z}r^k_{f,t}.
```

**(F3) Flexible rental-rate condition**

```math
r^k_{f,t}=w_{f,t}+l_{f,t}-k_{f,t}.
```

**(F4) Flexible capital services**

```math
k_{f,t}=kp_{f,t-1}+z_{f,t}.
```

**(F5) Flexible investment equation**

```math
i_{f,t}=\frac{1}{1+\bar\beta\gamma}\left(i_{f,t-1}+\bar\beta\gamma E_ti_{f,t+1}
+\frac{1}{\gamma^2\varphi}q_{f,t}\right)+q^s_t.
```

**(F6) Flexible value of capital**

```math
q_{f,t}=-rr_{f,t}+b_t\frac{\sigma_c(1+h/\gamma)}{1-h/\gamma}
+\frac{r^k_\ast}{r^k_\ast+1-\delta}E_tr^k_{f,t+1}
+\frac{1-\delta}{r^k_\ast+1-\delta}E_tq_{f,t+1}.
```

**(F7) Flexible consumption Euler equation**

```math
c_{f,t}=\frac{h/\gamma}{1+h/\gamma}c_{f,t-1}
+\frac{1}{1+h/\gamma}E_tc_{f,t+1}
+\frac{(\sigma_c-1)c_{whlc}}{\sigma_c(1+h/\gamma)}(l_{f,t}-E_tl_{f,t+1})
-\frac{1-h/\gamma}{\sigma_c(1+h/\gamma)}rr_{f,t}+b_t.
```

**(F8) Flexible resource constraint**

```math
y_{f,t}=c_yc_{f,t}+i_yi_{f,t}+g_t+r^k_\astk_yz_{f,t}.
```

**(F9) Flexible production function**

```math
y_{f,t}=c_{fc}\left(\alpha k_{f,t}+(1-\alpha)l_{f,t}+a_t\right).
```

**(F10) Flexible wage/MRS condition**

```math
w_{f,t}=\sigma_l l_{f,t}+\frac{1}{1-h/\gamma}c_{f,t}
-\frac{h/\gamma}{1-h/\gamma}c_{f,t-1}.
```

**(F11) Flexible installed-capital law**

```math
kp_{f,t}=(1-\bar i_k)kp_{f,t-1}+\bar i_k i_{f,t}+\bar i_k\gamma^2\varphi q^s_t.
```

**(F12) Sticky-economy marginal cost**

```math
mc_t=\alpha r^k_t+(1-\alpha)w_t-a_t.
```

**(F13) Sticky capital utilization**

```math
z_t=\frac{1-c_z}{c_z}r^k_t.
```

**(F14) Sticky rental-rate condition**

```math
r^k_t=w_t+l_t-k_t.
```

**(F15) Sticky capital services**

```math
k_t=kp_{t-1}+z_t.
```

**(F16) Sticky investment equation**

```math
i_t=\frac{1}{1+\bar\beta\gamma}\left(i_{t-1}+\bar\beta\gamma E_ti_{t+1}
+\frac{1}{\gamma^2\varphi}q_t\right)+q^s_t.
```

**(F17) Sticky value of capital**

```math
q_t=-r_t+E_t\pi_{t+1}+b_t\frac{\sigma_c(1+h/\gamma)}{1-h/\gamma}
+\frac{r^k_\ast}{r^k_\ast+1-\delta}E_tr^k_{t+1}
+\frac{1-\delta}{r^k_\ast+1-\delta}E_tq_{t+1}.
```

**(F18) Sticky consumption Euler equation**

```math
c_t=\frac{h/\gamma}{1+h/\gamma}c_{t-1}
+\frac{1}{1+h/\gamma}E_tc_{t+1}
+\frac{(\sigma_c-1)c_{whlc}}{\sigma_c(1+h/\gamma)}(l_t-E_tl_{t+1})
-\frac{1-h/\gamma}{\sigma_c(1+h/\gamma)}(r_t-E_t\pi_{t+1})+b_t.
```

**(F19) Sticky resource constraint**

```math
y_t=c_yc_t+i_yi_t+g_t+r^k_\astk_yz_t.
```

**(F20) Sticky production function**

```math
y_t=c_{fc}\left(\alpha k_t+(1-\alpha)l_t+a_t\right).
```

**(F21) Price Phillips curve**

```math
\pi_t=\frac{1}{1+\bar\beta\gamma\iota_p}
\left(\bar\beta\gamma E_t\pi_{t+1}+\iota_p\pi_{t-1}
+\kappa_p mc_t\right)+s^p_t.
```

The paper-side reset-price exercise removes nominal indexation for nonadjusters, so the exact $`\iota_p`$ treatment must be reconciled against the implementation in later review.

**(F22) Wage Phillips curve**

```math
\begin{aligned}
w_t&=\frac{1}{1+\bar\beta\gamma}w_{t-1}
+\frac{\bar\beta\gamma}{1+\bar\beta\gamma}E_tw_{t+1}
+\frac{\iota_w}{1+\bar\beta\gamma}\pi_{t-1} \\
&\quad-\frac{1+\bar\beta\gamma\iota_w}{1+\bar\beta\gamma}\pi_t
+\frac{\bar\beta\gamma}{1+\bar\beta\gamma}E_t\pi_{t+1}
+\kappa_w\left[mrs_t-w_t\right]+s^w_t .
\end{aligned}
```

where:

```math
mrs_t=\sigma_l l_t+\frac{1}{1-h/\gamma}c_t-\frac{h/\gamma}{1-h/\gamma}c_{t-1}.
```

**(F23) Monetary policy rule**

```math
r_t=\rho_R r_{t-1}+(1-\rho_R)\left[\phi_\pi\pi_t+\phi_y(y_t-y_{f,t})\right]
+\phi_{\Delta y}\left[(y_t-y_{f,t})-(y_{t-1}-y_{f,t-1})\right]+m_t.
```

**(F24) Sticky installed-capital law**

```math
kp_t=(1-\bar i_k)kp_{t-1}+\bar i_k i_t+\bar i_k\gamma^2\varphi q^s_t.
```

## 4. Market Clearing & Identities

**(F25) Actual-price growth measurement**

```math
\pi^{obs}_t=\pi_t+\bar\pi.
```

**(F26) Observed real growth rates**

```math
\Delta y^{obs}_t=y_t-y_{t-1}+\bar\gamma,\quad
\Delta c^{obs}_t=c_t-c_{t-1}+\bar\gamma,\quad
\Delta i^{obs}_t=i_t-i_{t-1}+\bar\gamma,\quad
\Delta w^{obs}_t=w_t-w_{t-1}+\bar\gamma.
```

**(F27) Reset-price inflation statistic**

For item $`i`$, let $`I_{i,t}`$ indicate a price change and let $`p^{\ast}_{i,t}`$ be the reset price. The paper defines:

```math
p^{\ast}_{i,t}=
\begin{cases}
p_{i,t}, & p_{i,t}\ne p_{i,t-1},\\
p^{\ast}_{i,t-1}+\pi^{\ast}_t, & p_{i,t}=p_{i,t-1},
\end{cases}
```

and aggregate reset inflation:

```math
\pi^{\ast}_t=
\frac{\sum_i\omega_{i,t}(p_{i,t}-p^{\ast}_{i,t-1})I_{i,t}}
{\sum_i\omega_{i,t}I_{i,t}}.
```

**(F28) Calvo mapping from actual to reset inflation**

Under Calvo timing with price-change frequency $`\lambda`$, the reset-price statistic satisfies:

```math
\pi^{\ast}_t=\frac{\pi_t-(1-\lambda)\pi_{t-1}}{\lambda}.
```

**(F29) Calvo reset-to-actual volatility ratio**

The paper uses the following implication to test time-dependent pricing:

```math
\frac{\sigma_{\pi^{\ast}}}{\sigma_{\pi}}
=\sqrt{1+\frac{2(1-\rho)(1-\lambda)}{\lambda^2}}.
```

## 5. Exogenous Processes

The bimonthly implementation cross-check contains seven structural innovations:

**(F30) Technology shock**

```math
a_t=\rho_a a_{t-1}+\varepsilon^a_t.
```

**(F31) Risk-premium or preference shock**

```math
b_t=\rho_b b_{t-1}+\varepsilon^b_t.
```

**(F32) Government spending shock**

```math
g_t=\rho_g g_{t-1}+\varepsilon^g_t+c_{gy}\varepsilon^a_t.
```

**(F33) Investment-specific technology shock**

```math
q^s_t=\rho_{qs}q^s_{t-1}+\varepsilon^{qs}_t.
```

**(F34) Monetary policy shock**

```math
m_t=\rho_m m_{t-1}+\varepsilon^m_t.
```

**(F35) Price-markup shock with MA term**

```math
s^p_t=\rho_p s^p_{t-1}+\varepsilon^p_t-\mu_p\varepsilon^p_{t-1}.
```

**(F36) Wage-markup shock with MA term**

```math
s^w_t=\rho_w s^w_{t-1}+\varepsilon^w_t-\mu_w\varepsilon^w_{t-1}.
```

## 6. Steady-State Solution

Because `US_BKM12` is archived as a linearized bimonthly Smets-Wouters implementation, all model variables in Sections 3-5 are zero in deterministic steady state:

```math
y_f=c_f=i_f=q_f=k_f=kp_f=z_f=r^k_f=l_f=w_f=rr_f=0,
```

```math
y=c=i=q=k=kp=z=r^k=l=w=mc=\pi=r=0,
```

```math
a=b=g=q^s=m=s^p=s^w=0.
```

The implementation cross-check back-solves balanced-growth constants from calibrated and estimated parameters:

```math
\Pi=1+\frac{\bar\pi}{100},\qquad
\gamma=1+\frac{\bar\gamma}{100},\qquad
\beta=\frac{1}{1+\bar\beta_{obs}/100}.
```

```math
\bar R=\frac{\Pi}{\beta\gamma^{-\sigma_c}},\qquad
\bar R^k=\beta^{-1}\gamma^{\sigma_c}-(1-\delta).
```

```math
\bar i_k=1-\frac{1-\delta}{\gamma},\qquad
\frac{I}{K}=\bar i_k\gamma,\qquad
\frac{K}{Y}=c_{fc}\left(\frac{K}{L}\right)^{\alpha-1}.
```

The article body does not provide a complete nonlinear steady-state derivation; this section is therefore `needs_review` and records only the linear steady-state convention plus implementation cross-check constants.

## 7. Timing & Form Conventions

- Model form: `model(linear)`, bimonthly frequency.
- Capital timing: production uses predetermined installed capital services, with $`k_t=kp_{t-1}+z_t`$ and the installed-capital law determining $`kp_t`$.
- Policy rule: the nominal rate responds to inflation and the output gap relative to flexible-price output.
- Price setting: the paper's reset-price analysis requires no nominal price indexation for nonadjusting prices; exact implementation alignment is `needs_review`.
- Reset inflation: $`\pi^{\ast}_t`$ is a measurement/statistical object built from changing prices, not a separate optimizing agent's FOC.
- Runtime validation: not performed; no Dynare run was executed.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Main equations |
| --- | --- | --- | --- |
| Endogenous | `yf`, $`y_{f,t}`$ | Flexible-output deviation | (F8), (F9), (F23) |
| Endogenous | `cf`, $`c_{f,t}`$ | Flexible consumption | (F7), (F8), (F10) |
| Endogenous | `invef`, $`i_{f,t}`$ | Flexible investment | (F5), (F8), (F11) |
| Endogenous | `pkf`, $`q_{f,t}`$ | Flexible value of capital | (F5), (F6) |
| Endogenous | `kf`, $`k_{f,t}`$ | Flexible capital services | (F3), (F4), (F9) |
| Endogenous | `kpf`, $`kp_{f,t}`$ | Flexible installed capital | (F4), (F11) |
| Endogenous | `zcapf`, $`z_{f,t}`$ | Flexible capital utilization | (F2), (F4), (F8) |
| Endogenous | `rkf`, $`r^k_{f,t}`$ | Flexible capital rental rate | (F1), (F2), (F3), (F6) |
| Endogenous | `labf`, $`l_{f,t}`$ | Flexible labor | (F3), (F7), (F9), (F10) |
| Endogenous | `wf`, $`w_{f,t}`$ | Flexible real wage | (F1), (F3), (F10) |
| Endogenous | `rrf`, $`rr_{f,t}`$ | Flexible real rate | (F6), (F7) |
| Endogenous | `y`, $`y_t`$ | Sticky-output deviation | (F19), (F20), (F23), (F26) |
| Endogenous | `c`, $`c_t`$ | Sticky consumption | (F18), (F19), (F22), (F26) |
| Endogenous | `inve`, $`i_t`$ | Sticky investment | (F16), (F19), (F24), (F26) |
| Endogenous | `pk`, $`q_t`$ | Sticky value of capital | (F16), (F17) |
| Endogenous | `k`, $`k_t`$ | Sticky capital services | (F14), (F15), (F20) |
| Endogenous | `kp`, $`kp_t`$ | Sticky installed capital | (F15), (F24) |
| Endogenous | `zcap`, $`z_t`$ | Sticky capital utilization | (F13), (F15), (F19) |
| Endogenous | `rk`, $`r^k_t`$ | Sticky capital rental rate | (F12), (F13), (F14), (F17) |
| Endogenous | `lab`, $`l_t`$ | Sticky labor | (F14), (F18), (F20), (F22) |
| Endogenous | `w`, $`w_t`$ | Sticky real wage | (F12), (F14), (F22), (F26) |
| Endogenous | `mc`, $`mc_t`$ | Real marginal cost | (F12), (F21) |
| Endogenous | `pinf`, $`\pi_t`$ | Inflation | (F17), (F18), (F21), (F22), (F25), (F28) |
| Endogenous | `r`, $`r_t`$ | Policy rate | (F17), (F18), (F23) |
| Endogenous | `dy`, `dc`, `dinve`, `dw`, `pinfobs`, `robs`, `labobs` | Observables | (F25), (F26) |
| Endogenous | `a`, `b`, `g`, `qs`, `ms`, `spinf`, `sw` | Shock states | (F30)-(F36) |
| Endogenous | `epinfma`, `ewma` | MA auxiliaries in implementation | (F35), (F36) |
| Exogenous | `ea`, `eb`, `eg`, `eqs`, `em`, `epinf`, `ew` | Structural innovations | (F30)-(F36) |
| Measurement | $`\pi^{\ast}_t`$ | Reset-price inflation statistic | (F27), (F28), (F29) |
| Parameter | `cbeta`, $`\beta`$ | Discount factor | (F5)-(F7), (F16)-(F18), Section 6 |
| Parameter | `cgamma`, $`\gamma`$ | Trend growth | (F5)-(F7), (F16)-(F18), Section 6 |
| Parameter | `csigma`, $`\sigma_c`$ | Consumption curvature | (F6), (F7), (F10), (F17), (F18), (F22) |
| Parameter | `chabb`, $`h`$ | External habit | (F7), (F10), (F18), (F22) |
| Parameter | `calfa`, $`\alpha`$ | Capital share | (F1), (F3), (F9), (F12), (F14), (F20) |
| Parameter | `ctou`, $`\delta`$ | Depreciation | (F6), (F17), Section 6 |
| Parameter | `csadjcost`, $`\varphi`$ | Investment adjustment-cost curvature | (F5), (F11), (F16), (F24) |
| Parameter | `czcap`, $`c_z`$ | Utilization-cost curvature | (F2), (F13) |
| Parameter | `cprobp`, $`\lambda`$ | Price nonadjustment probability / price-change frequency counterpart | (F21), (F28), (F29) |
| Parameter | `cprobw` | Wage nonadjustment probability | (F22) |
| Parameter | `crr`, `crpi`, `cry`, `crdy` | Monetary policy rule coefficients | (F23) |
| Parameter | `crhoa`, `crhob`, `crhog`, `crhoqs`, `crhoms`, `crhopinf`, `crhow` | Shock persistence parameters | (F30)-(F36) |
| Parameter | `cmap`, `cmaw` | Price/wage markup MA coefficients | (F35), (F36) |

### Self-Check Status

- Eight-section structure: complete.
- Model form: declared as bimonthly log-linear `model(linear)`.
- Timing convention: predetermined installed capital is recorded.
- Source provenance: see `source_manifest.json`.
- Formula quality: `needs_review`, especially Kimball curvature, exact price-indexation treatment, and nonlinear FOC provenance.
- Runtime validation: not performed and out of scope for this request.
