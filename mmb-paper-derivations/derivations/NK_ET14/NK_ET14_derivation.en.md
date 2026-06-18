# NK_ET14 -- Derivation

> This derivation is a source-backed draft for later Dynare implementation. Runtime validation was not performed.

Source: Ellison, Martin, and Andreas Tischbirek (2014), "Unconventional government debt purchases as a supplement to conventional monetary policy," *Journal of Economic Dynamics and Control* 43, 199-217. DOI: `10.1016/j.jedc.2014.03.012`.

Provenance: `raw/mmb_mineru/runs/nk_et14__unconventional_government_debt_purchases_as_a_supplement_to_conventional__f7e430ba/full.md`; raw PDF checked for existence at `raw/mmb_papers/Unconventional government debt purchases as a supplement to conventional monetary policy.pdf`; MinerU run id `f7e430ba-7c77-4633-ba23-6e943c335622`. The MMB implementation `.mod` was used only as an implementation cross-check.

## 1. Model Overview

- **Model**: New Keynesian DSGE model with fully flexible wages, Calvo price rigidity, a representative bank with preferred-habitat demand for short- and long-term government bonds, a treasury, and a central bank that uses both a short-rate rule and a long-term government-bond purchase rule.
- **Experiment**: First-order stochastic simulation around a trend-stationary steady state. The paper studies whether long-term government debt purchases supplement conventional short-rate policy outside the zero lower bound.
- **Agents**: households choose consumption, labor, and deposits in a bank savings device; firms set prices under Calvo frictions and produce with labor; banks allocate deposits across short and long government bonds using Generalised Translog asset demands; the treasury issues debt and finances spending with taxes; the central bank sets the short nominal rate and purchases long-term debt.
- **Form**: nonlinear stationary equilibrium equations, then first-order approximation in Dynare. This is not a hand log-linear model. Nominal levels are trend-stationary when steady-state inflation differs from one; Appendix B works with real stationary variables.
- **Status**: `needs_review`. Appendix B OCR contains a few formula artifacts; where possible, the main-text equations were used to resolve them without opening the PDF body.

## 2. Optimization Problems

### 2.1 Representative Household

The household maximizes expected utility

```math
\max_{\{C_t,L_t,S_{t,t+1}\}} E_0\sum_{t=0}^{\infty}\beta^t
\left[
\chi_t^C\frac{C_t^{1-\delta}}{1-\delta}
-\chi_t^L\frac{L_t^{1+\psi}}{1+\psi}
\right]
```

subject to the nominal budget constraint

```math
P_t C_t+T_t+P_t^S S_{t,t+1}
=S_{t-1,t}+W_tL_t+(1-t_{\mathcal P})(P_tY_t-W_tL_t).
```

Here $`S_{t,t+1}`$ is the bank-provided savings device purchased at price $`P_t^S`$, and households receive the after-tax share of firm profits.

### 2.2 Price-Setting Firms

Each firm has technology $`Y_t(i)=A_tL_t(i)^{1/\phi}`$. Firms that can reset prices choose $`P_t^{\ast}(i)`$ to maximize discounted profits

```math
\max_{P_t^{\ast}(i)} E_t\sum_{T=t}^{\infty}\alpha^{T-t}M_{t,T}
\left[P_t^{\ast}(i)Y_T(i)-W_TL_T(i)\right]
```

subject to demand

```math
Y_T(i)=Y_T\left(\frac{P_t^{\ast}(i)}{P_T}\right)^{-\theta_t}
```

and discount factor

```math
M_{t,T}=\beta^{T-t}
\frac{\chi_T^C C_T^{-\delta}P_t}{\chi_t^C C_t^{-\delta}P_T}.
```

### 2.3 Representative Bank

The bank collects nominal deposits $`P_t^SS_{t,t+1}`$ and allocates them between short bonds $`B_{t,t+1}`$ and long bonds $`Q_{t,t+\tau}`$:

```math
P_t^SS_{t,t+1}=P_t^BB_{t,t+1}+P_t^QQ_{t,t+\tau}.
```

It solves a preferred-habitat allocation problem,

```math
\max_{B_{t,t+1},Q_{t,t+\tau}}
V\left(\frac{B_{t,t+1}}{P_t},\frac{Q_{t,t+\tau}}{P_t}\right),
```

subject to the flow constraint. Under the paper's Generalised Translog restrictions, this produces closed-form demand schedules for short and long bonds.

### 2.4 Treasury and Central Bank

The treasury issues short debt and a fixed real flow of long debt. Government consumption is exogenous and financed with lump-sum taxes. The central bank sets the short nominal rate and the share of long debt left to the private sector through Taylor-type rules.

## 3. First-Order Conditions

- **(F1) Household Euler equation for the bank savings device**:

```math
1=\beta E_t\left[
\frac{\chi_{t+1}^C}{\chi_t^C}
\left(\frac{C_{t+1}}{C_t}\right)^{-\delta}
\frac{1}{\Pi_{t+1}}
\right]\frac{1}{P_t^S}.
```

- **(F2) Household intratemporal labor condition**:

```math
w_t=\frac{\chi_t^L}{\chi_t^C}L_t^\psi C_t^\delta.
```

- **(F3) Calvo price-index relation / reset-price condition**:

```math
\frac{1-\alpha\Pi_t^{\theta_t-1}}{1-\alpha}
=\left(\frac{F_t}{K_t}\right)^{\frac{\theta_t-1}{\theta_t(\phi-1)+1}}.
```

- **(F4) Calvo auxiliary recursion $`F_t`$**:

```math
F_t=\chi_t^C C_t^{-\delta}Y_t
+\alpha\beta E_t\left[\Pi_{t+1}^{\theta_t-1}F_{t+1}\right].
```

- **(F5) Calvo auxiliary recursion $`K_t`$**:

```math
K_t=\frac{\theta_t\phi}{\theta_t-1}\chi_t^LL_t^\psi
\left(\frac{Y_t}{A_t}\right)^\phi
+\alpha\beta E_t\left[\Pi_{t+1}^{\theta_t\phi}K_{t+1}\right].
```

The Appendix B OCR version of (F3) and (F5) is `needs_review`; the formulas above use the cleaner main-text equations (7)-(9).

- **(F6) Bank return to the savings device**:

```math
s_t=b_t+\frac{1}{\tau}\left(q_t+\sum_{k=1}^{\tau-1}
\frac{q_{t-k}}{\prod_{j=0}^{k-1}\Pi_{t-j}}\right).
```

- **(F7) Short-bond price and nominal interest rate**:

```math
1+i_t=\frac{1}{P_t^B}.
```

- **(F8) Long-bond yield definition**:

```math
P_t^Q=\frac{1}{\tau}\frac{1}{1+i_t^Q}
\frac{1-\left(\frac{1}{1+i_t^Q}\right)^\tau}
{1-\frac{1}{1+i_t^Q}}.
```

- **(F9) Short-bond demand from the bank allocation problem**:

```math
b_t=g^B+\frac{P_t^Ss_t-P_t^Bg^B-P_t^Qg^Q}{P_t^B}
\left[
a_1+a_2\log\left(\frac{P_t^B}{P_t^Q}\right)
\right].
```

- **(F10) Long-bond demand from the bank allocation problem**:

```math
q_t=g^Q+\frac{P_t^Ss_t-P_t^Bg^B-P_t^Qg^Q}{P_t^Q}
\left[
1-a_1-a_2\log\left(\frac{P_t^B}{P_t^Q}\right)
\right].
```

- **(F11) Long-term bond issuance rule**:

```math
\bar q_t=fY.
```

- **(F12) Conventional monetary policy rule**:

```math
\frac{1+i_t}{1+i}
=\left(\frac{\Pi_t}{\Pi}\right)^{\gamma_\Pi}
\left(\frac{Y_t}{Y}\right)^{\gamma_Y}\nu_t.
```

- **(F13) Unconventional asset-purchase rule**:

```math
\frac{\bar q_t-q_t^{CB}}{\bar q_t}
=\left(\frac{\Pi_t}{\Pi}\right)^{\gamma_\Pi^{QE}}
\left(\frac{Y_t}{Y}\right)^{\gamma_Y^{QE}}\xi_t.
```

In the source OCR, $`\gamma_\Pi`$ sometimes appears as `gamma_II`; this derivation normalizes it to the inflation-response coefficient and records the OCR issue in the notes.

## 4. Market Clearing & Identities

- **(F14) Long-bond market clearing**:

```math
\bar q_t=q_t+q_t^{CB}.
```

- **(F15) Goods market clearing**:

```math
Y_t=C_t+G_t.
```

- **(F16) Aggregate production with price dispersion**:

```math
Y_t=A_t\left(\frac{L_t}{D_t}\right)^{1/\phi}.
```

- **(F17) Price dispersion law of motion**:

```math
D_t=(1-\alpha)
\left(\frac{1-\alpha\Pi_t^{\theta_t-1}}{1-\alpha}\right)^{\frac{\theta_t\phi}{\theta_t-1}}
+\alpha\Pi_t^{\theta_t\phi}D_{t-1}.
```

- **(F18) Real household budget / stationary resource identity**:

```math
C_t+P_t^Ss_t+G_t
=\frac{s_{t-1}}{\Pi_t}+t_{\mathcal P}w_tL_t+(1-t_{\mathcal P})Y_t.
```

This identity is the stationary counterpart of the household budget after combining government funding and bank returns. The consolidated government budget is implied by household, bank, market-clearing, and tax relations rather than treated as an independent equation in the stationary model.

## 5. Exogenous Processes

- **(F19) Consumption preference shock**:

```math
\log(\chi_t^C)=\rho_C\log(\chi_{t-1}^C)+\varepsilon_t^C.
```

- **(F20) Labor preference shock**:

```math
\log(\chi_t^L)=\rho_L\log(\chi_{t-1}^L)+\varepsilon_t^L.
```

- **(F21) Technology shock**:

```math
\log(A_t)=\rho_A\log(A_{t-1})+\varepsilon_t^A.
```

- **(F22) Elasticity-of-substitution shock**:

```math
\log\left(\frac{\theta_t}{\theta}\right)
=\rho_\theta\log\left(\frac{\theta_{t-1}}{\theta}\right)+\varepsilon_t^\theta.
```

- **(F23) Government spending shock**:

```math
\log\left(\frac{G_t}{G}\right)
=\rho_G\log\left(\frac{G_{t-1}}{G}\right)+\varepsilon_t^G.
```

- **(F24) Interest-rate rule shock**:

```math
\log(\nu_t)=\rho_\nu\log(\nu_{t-1})+\varepsilon_t^\nu.
```

- **(F25) Asset-purchase rule shock**:

```math
\log(\xi_t)=\rho_\xi\log(\xi_{t-1})+\varepsilon_t^\xi.
```

The MMB implementation uses a negative sign on `epsnu` and `epsksi` so positive reported shocks are expansionary; this is an implementation convention, not a separate paper-side equation.

## 6. Steady-State Solution

Steady-state variables omit time subscripts. The paper provides a stationary steady state in Appendix B.2. Runtime validation was not performed.

1. Normalize exogenous states:

```math
A=\chi^C=\chi^L=\nu=\xi=1.
```

2. Given calibrated $`\Pi,\alpha,\theta,\phi`$, compute dispersion:

```math
D=\frac{1-\alpha}{1-\alpha\Pi^{\theta\phi}}
\left(\frac{1-\alpha\Pi^{\theta-1}}{1-\alpha}\right)^{\frac{\theta\phi}{\theta-1}}.
```

3. Compute output from the stationary steady-state expression:

```math
Y=\left[
\frac{1-\alpha\beta\Pi^{\theta-1}}
{1-\alpha\beta\Pi^{\theta\phi}}
\frac{\theta\phi}{\theta-1}
D^\psi(1-\bar g)^\delta
\left(\frac{1-\alpha\Pi^{\theta-1}}{1-\alpha}\right)^{\frac{\theta(\phi-1)+1}{\theta-1}}
\right]^{\frac{1}{1-\delta-\phi(\psi+1)}}.
```

The Appendix B OCR version of this formula is `needs_review`; the MMB implementation steady-state expression was used only as an implementation cross-check for the intended multiplicative structure.

4. Set fiscal aggregates and consumption:

```math
G=\bar gY,\qquad C=Y-G.
```

5. Compute Calvo auxiliaries, labor, and wage:

```math
F=\frac{YC^{-\delta}}{1-\alpha\beta\Pi^{\theta-1}},\qquad
K=\frac{1}{1-\alpha\beta\Pi^{\theta\phi}}\frac{\theta\phi}{\theta-1}D^\psi Y^{\phi(\psi+1)},
```

```math
L=DY^\phi,\qquad w=L^\psi C^\delta.
```

6. Compute savings-device and long-bond quantities:

```math
P^S=\frac{\beta}{\Pi},\qquad
q^{CB}=0,\qquad
\bar q=fY,\qquad
q=\bar q.
```

7. Compute total savings and short bond holdings:

```math
s=\frac{\Pi}{1-\beta}\left[C+G-t_{\mathcal P}wL-(1-t_{\mathcal P})Y\right],
```

```math
b=s-\frac{q}{\tau}\left(1-\frac{1}{\Pi^\tau}\right)\frac{\Pi}{\Pi-1}.
```

8. Solve the two steady-state asset-demand equations jointly for $`P^B`$ and $`P^Q`$:

```math
b=g^B+\frac{P^Ss-P^Bg^B-P^Qg^Q}{P^B}
\left[a_1+a_2\log\left(\frac{P^B}{P^Q}\right)\right],
```

```math
q=g^Q+\frac{P^Ss-P^Bg^B-P^Qg^Q}{P^Q}
\left[1-a_1-a_2\log\left(\frac{P^B}{P^Q}\right)\right].
```

9. Recover interest rates:

```math
i=\frac{1}{P^B}-1,
```

and solve $`i^Q`$ implicitly from

```math
P^Q=\frac{1}{\tau}\frac{1}{1+i^Q}
\frac{1-\left(\frac{1}{1+i^Q}\right)^\tau}
{1-\frac{1}{1+i^Q}}.
```

## 7. Timing & Form Conventions

- **Stationary variables**: $`w_t=W_t/P_t`$, $`s_t=S_{t,t+1}/P_t`$, $`b_t=B_{t,t+1}/P_t`$, $`q_t=Q_{t,t+\tau}/P_t`$, $`\bar q_t=\bar Q_{t,t+\tau}/P_t`$, and $`q_t^{CB}=Q_{t,t+\tau}^{CB}/P_t`$.
- **Long bond timing**: a long bond issued in $`t`$ pays $`1/\tau`$ in each period from $`t+1`$ through $`t+\tau`$. The return to deposits at $`t`$ depends on short-bond payoff and coupon payments from the previous $`\tau`$ long-bond vintages.
- **No secondary market for long bonds**: long bonds are purchased at issuance and held to maturity, so the state vector includes lagged long-bond quantities through the return identity.
- **Price dispersion**: $`D_t`$ is predetermined through $`D_{t-1}`$ in (F17).
- **Policy shocks**: $`\nu_t`$ enters the short-rate rule; $`\xi_t`$ enters the asset-purchase rule. The implementation may sign shocks so that positive innovations are expansionary.
- **Model form**: nonlinear stationary equations solved with first-order approximation; not `model(linear)`.
- **Runtime validation**: not performed in this archive-entry pass.

## 8. Variable & Parameter Reference Table

### Endogenous Variables

| Symbol | Meaning | Main equation |
|---|---|---|
| $`Y_t`$ | output | (F15), (F16) |
| $`C_t`$ | consumption | (F1), (F15) |
| $`s_t`$ | real savings-device quantity | (F6), (F18) |
| $`G_t`$ | government consumption | (F23), (F15) |
| $`\Pi_t`$ | gross inflation | (F3), (F12), (F13) |
| $`L_t`$ | labor | (F2), (F16) |
| $`\chi_t^C`$ | consumption preference state | (F19) |
| $`P_t^S`$ | price of savings device | (F1), (F18) |
| $`P_t^Q`$ | long-bond price | (F8), (F10) |
| $`P_t^B`$ | short-bond price | (F7), (F9) |
| $`w_t`$ | real wage | (F2), (F18) |
| $`\chi_t^L`$ | labor preference state | (F20) |
| $`F_t`$ | Calvo auxiliary numerator | (F4) |
| $`K_t`$ | Calvo auxiliary denominator | (F5) |
| $`A_t`$ | technology | (F21), (F16) |
| $`b_t`$ | real short-bond holdings | (F9), (F6) |
| $`q_t`$ | real private long-bond holdings | (F10), (F14) |
| $`\bar q_t`$ | real total long-bond issuance | (F11), (F14) |
| $`q_t^{CB}`$ | central-bank long-bond purchases | (F13), (F14) |
| $`i_t`$ | short nominal interest rate | (F7), (F12) |
| $`i_t^Q`$ | long-bond yield | (F8) |
| $`D_t`$ | price dispersion | (F17), (F16) |
| $`\theta_t`$ | time-varying substitution elasticity | (F22), (F3)-(F5) |
| $`\nu_t`$ | interest-rate policy state | (F24), (F12) |
| $`\xi_t`$ | asset-purchase policy state | (F25), (F13) |

### Exogenous Innovations

| Symbol | Meaning |
|---|---|
| $`\varepsilon_t^C`$ | consumption preference innovation |
| $`\varepsilon_t^L`$ | labor preference innovation |
| $`\varepsilon_t^A`$ | technology innovation |
| $`\varepsilon_t^\theta`$ | elasticity-of-substitution innovation |
| $`\varepsilon_t^G`$ | government spending innovation |
| $`\varepsilon_t^\nu`$ | short-rate rule innovation |
| $`\varepsilon_t^\xi`$ | asset-purchase rule innovation |

### Parameters

| Symbol | Meaning |
|---|---|
| $`\beta`$ | discount factor |
| $`\delta`$ | inverse intertemporal substitution elasticity |
| $`\psi`$ | inverse Frisch labor elasticity |
| $`\theta`$ | steady-state elasticity of substitution |
| $`\phi`$ | inverse returns-to-scale parameter in production |
| $`\alpha`$ | Calvo non-adjustment probability |
| $`\Pi`$ | steady-state gross inflation |
| $`\tau`$ | long-bond maturity |
| $`\bar g`$ | government-spending-to-output ratio |
| $`t_{\mathcal P}`$ | tax/share of firm profits received by government |
| $`f`$ | long-bond issuance rule parameter |
| $`a_1,a_2,g^B,g^Q`$ | preferred-habitat asset-demand parameters |
| $`\gamma_\Pi,\gamma_Y`$ | short-rate rule coefficients |
| $`\gamma_\Pi^{QE},\gamma_Y^{QE}`$ | asset-purchase rule coefficients |
| $`\rho_C,\rho_L,\rho_A,\rho_\theta,\rho_G,\rho_\nu,\rho_\xi`$ | shock persistences |
| $`\sigma_C,\sigma_L,\sigma_A,\sigma_\theta,\sigma_G,\sigma_\nu,\sigma_\xi`$ | innovation standard deviations |
