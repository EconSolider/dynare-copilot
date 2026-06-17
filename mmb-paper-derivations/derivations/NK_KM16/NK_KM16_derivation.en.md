# NK_KM16 - Public Debt and Changing Inflation Targets

> Model archive derivation for `NK_KM16`. Source: Krause and Moyen (2016), "Public Debt and Changing Inflation Targets," *American Economic Journal: Macroeconomics*, 8(4): 142-176, DOI `10.1257/mac.20130014`. Primary source Markdown: `raw/mmb_mineru/runs/nk_km16__public_debt_and_changing_inflation_targets__e715ef78/full.md`; raw PDF recorded at `raw/mmb_papers/Public Debt and Changing Inflation Targets.pdf`. Runtime validation: not performed.

## 1. Model Overview

- **Model**: New Keynesian closed-economy model with Calvo price setting, stochastic long-term nominal public debt, a fiscal tax feedback rule, and a stochastic inflation target.
- **Agents**: representative household, monopolistically competitive intermediate firms, fiscal authority, and monetary authority.
- **Key nonstandard mechanisms**: a callable-perpetuity approximation to government debt maturity and an imperfect-information signal extraction problem for the central bank inflation target.
- **Form**: the paper solves a linearized rational-expectations system. The MMB implementation uses nonlinear levels with `steady_state_model` and first-order simulation; the archive entry records the paper-side nonlinear equilibrium conditions plus linear policy/observation definitions where stated.
- **Source status**: the MinerU Markdown is mostly readable, but some formulas contain OCR damage. Equations marked `needs_review` should be checked against the PDF or author code before promotion.

## 2. Optimization Problems

### Representative Household

The household chooses consumption, real money balances, labor, one-period nominal bonds, and the portfolio of stochastic long-term bonds:

$$
\max_{\{C_t,M_t,N_t,B_t,B_t^L,i_t^L\}} E_0 \sum_{t=0}^{\infty}\beta^t
\left[
\frac{C_t^{1-\sigma_c}}{1-\sigma_c}
+ \chi\frac{(M_t/P_t)^{1-\sigma_m}}{1-\sigma_m}
- \varphi\frac{N_t^{1+\phi}}{1+\phi}
\right].
$$

The nominal budget constraint is:

$$
\begin{aligned}
\frac{B_t}{P_t}+\frac{B_t^{L,n}}{P_t}+\frac{M_t}{P_t}+C_t
&=(1+i_{t-1})\frac{B_{t-1}}{P_t}
+(\alpha+i_{t-1}^L)\frac{B_{t-1}^L}{P_t}
+\frac{M_{t-1}}{P_t} \\
&\quad +(1-\tau_t)\frac{W_t}{P_t}N_t
+\int_0^1\frac{\Pi_t(z)}{P_t}\,dz .
\end{aligned}
$$

The household also internalizes the law of motion for the stock and average interest rate of stochastic long-term bonds.

### Intermediate Firms

Each differentiated firm faces demand from the CES final-good aggregator and produces with labor only:

$$
Y_t(z)=A N_t(z).
$$

With Calvo probability `theta`, a firm cannot reset its price. Non-reset prices are indexed to the actual or perceived inflation target. A resetting firm chooses \(P_t^*(z)\) to maximize expected discounted profits subject to demand and the indexation rule.

### Fiscal and Monetary Authorities

The fiscal authority does not solve an optimization problem in the paper-side model. It follows a tax rule and a consolidated budget constraint. The monetary authority follows a Taylor-type nominal interest-rate rule with a stochastic inflation target. Under imperfect information, private agents estimate the target and policy shock from a monetary-policy signal.

## 3. First-Order Conditions

- **(F1) Short-term bond Euler equation**:

$$
1=E_t\left[\beta\frac{\lambda_{t+1}}{\lambda_t}\frac{P_t}{P_{t+1}}(1+i_t)\right].
$$

- **(F2) Long-term bond Euler equation** (`needs_review`: OCR is damaged around the capital-loss term):

$$
1=E_t\left[
\beta\frac{\lambda_{t+1}}{\lambda_t}\frac{P_t}{P_{t+1}}
\left(1+i_t^{L,n}-\mu_{t+1}(1-\alpha)\Delta i_{t+1}^{L,n}\right)
\right].
$$

- **(F3) Marginal utility of wealth**:

$$
\lambda_t=C_t^{-\sigma_c}.
$$

- **(F4) Stochastic bond price recursion**:

$$
\mu_t=E_t\left[
\beta\frac{\lambda_{t+1}}{\lambda_t}\frac{P_t}{P_{t+1}}
\left(1+(1-\alpha)\mu_{t+1}\right)
\right].
$$

- **(F5) Money demand**:

$$
\frac{M_t}{P_t}=
\left[
\chi C_t^{\sigma_c}\frac{1+i_t}{i_t}
\right]^{1/\sigma_m}.
$$

- **(F6) Labor supply**:

$$
\varphi N_t^{\phi}=C_t^{-\sigma_c}(1-\tau_t)\frac{W_t}{P_t}.
$$

- **(F7) Demand for differentiated goods**:

$$
C_t(z)=\left(\frac{P_t(z)}{P_t}\right)^{-\epsilon}C_t.
$$

- **(F8) Relative reset price**:

$$
\frac{P_t^*}{P_t}=\frac{\epsilon}{\epsilon-1}\frac{\mathcal{Z}_{1,t}}{\mathcal{Z}_{2,t}}.
$$

- **(F9) Calvo numerator recursion**:

$$
\mathcal{Z}_{1,t}
=\lambda_t mc_t C_t
+\theta\beta E_t\left[
\left(\frac{\pi_{t+1}}{\pi_{t+1}^*}\right)^{-\epsilon}
\mathcal{Z}_{1,t+1}
\right].
$$

- **(F10) Calvo denominator recursion**:

$$
\mathcal{Z}_{2,t}
=\lambda_t C_t
+\theta\beta E_t\left[
\left(\frac{\pi_{t+1}}{\pi_{t+1}^*}\right)^{1-\epsilon}
\mathcal{Z}_{2,t+1}
\right].
$$

- **(F11) Real marginal cost**:

$$
mc_t=\frac{W_t/P_t}{A}.
$$

## 4. Market Clearing & Identities

- **(F12) Long-term debt stock law of motion**:

$$
B_t^L=(1-\alpha)B_{t-1}^L+B_t^{L,n}.
$$

- **(F13) Average interest rate on outstanding long-term debt**:

$$
i_t^L B_t^L=(1-\alpha)i_{t-1}^L B_{t-1}^L+i_t^{L,n}B_t^{L,n}.
$$

- **(F14) Aggregate price index**:

$$
1=\theta(\pi_t^*)^{1-\epsilon}\pi_t^{-(1-\epsilon)}
+(1-\theta)\left(
\frac{\epsilon}{\epsilon-1}\frac{\mathcal{Z}_{1,t}}{\mathcal{Z}_{2,t}}
\right)^{1-\epsilon}.
$$

- **(F15) Fiscal tax rule**:

$$
\tau_t-\tau=\rho_{\tau}(\tau_{t-1}-\tau)+\phi_{\tau}\hat{b}_t^L.
$$

- **(F16) Government budget constraint in real terms**:

$$
\tau_t w_t N_t+m_t-\frac{m_{t-1}}{\pi_t}+b_t^{L,n}
=g+(\alpha+i_{t-1}^L)\frac{b_{t-1}^L}{\pi_t}.
$$

- **(F17) Real long-term debt law of motion**:

$$
b_t^L=(1-\alpha)\frac{b_{t-1}^L}{\pi_t}+b_t^{L,n}.
$$

- **(F18) Taylor rule with time-varying inflation target**:

$$
i_t=\rho_i i_{t-1}
+(1-\rho_i)\left[
i+\hat{\pi}_t^*
+\phi_{\pi}(\hat{\pi}_t-\hat{\pi}_t^*)
+\phi_y(\hat{Y}_t-\hat{Y}_t^n)
\right]
+\eta_t.
$$

- **(F19) Aggregate demand**:

$$
Y_t=C_t+g.
$$

- **(F20) Labor market / production aggregation with price dispersion**:

$$
\Delta_{p,t}Y_t=A N_t.
$$

- **(F21) Price-dispersion law of motion**:

$$
\Delta_{p,t}
=\theta\Delta_{p,t-1}\left(\frac{\pi_t}{\pi_t^*}\right)^{\epsilon}
+(1-\theta)\left(
\frac{\epsilon}{\epsilon-1}\frac{\mathcal{Z}_{1,t}}{\mathcal{Z}_{2,t}}
\right)^{-\epsilon}.
$$

## 5. Exogenous Processes

- **(F22) Inflation-target process**:

$$
\hat{\pi}_t^*=\rho_{\pi}\hat{\pi}_{t-1}^*+\eta_t^{\pi}.
$$

- **(F23) Monetary-policy signal under imperfect information**:

$$
\varepsilon_t^{\pi}\equiv(1-\rho_i)(1-\phi_{\pi})\hat{\pi}_t^*+\eta_t.
$$

- **(F24) Perceived inflation-target update** (`needs_review`: OCR is readable but the surrounding state-space notation is compressed):

$$
\tilde{E}_t\hat{\pi}_t^*
=\tilde{E}_{t-1}\hat{\pi}_t^*
+\frac{k}{\rho_{\pi}}
\left(\varepsilon_t^{\pi}-\tilde{E}_{t-1}\varepsilon_t^{\pi}\right).
$$

- **(F25) Perceived monetary-policy shock**:

$$
\tilde{E}_t\eta_t
=\varepsilon_t^{\pi}
-(1-\rho_i)(1-\phi_{\pi})
\tilde{E}_{t-1}\hat{\pi}_t^*.
$$

- **(F26) Forecasts under the Kalman filter**:

$$
\begin{bmatrix}
\tilde{E}_t\hat{\pi}_{t+i}^*\\
\tilde{E}_t\eta_{t+i}
\end{bmatrix}
=
\begin{bmatrix}
\rho_{\pi} & 0\\
0 & 0
\end{bmatrix}^{i}
\begin{bmatrix}
\tilde{E}_t\hat{\pi}_{t}^*\\
\tilde{E}_t\eta_t
\end{bmatrix}.
$$

The paper also studies a zero-lower-bound extension with a preference shock, but that extension is not part of the baseline `NK_KM16` archive extraction.

## 6. Steady-State Solution

The paper calibrates a quarterly steady state and solves the dynamics from a linearized system. The MMB cross-check file provides explicit steady-state assignments consistent with the paper calibration:

1. Set steady-state inflation to the target, \(\pi=\pi^*=1.005\), and \(R=1/\beta\).
2. The short nominal rate satisfies \(i=R\pi-1\).
3. Normalize hours to \(N=1/3\). With a 20 percent markup, \(w=mc=1/1.2\) in the sticky-price block; output is \(Y=N/\Delta_p\) and \(\Delta_p=1\).
4. Government spending is \(g=0.2Y\), consumption is \(C=Y-g\), and long-term public debt is \(b^L=0.5Y\).
5. Money balances are \(m=[\chi C^{\sigma_c}(1+i)/i]^{1/\sigma_m}\).
6. The bond-price multiplier is \(\mu=\frac{\beta/\pi}{1-(\beta/\pi)(1-\alpha)}\).
7. Newly issued long-term debt is \(b^{L,n}=[1-(1-\alpha)/\pi]b^L\), and \(i^{L,n}=\pi/\beta-1\). In steady state the average long-term rate equals the new-issue rate.
8. The tax rate \(\tau\) is residually determined from the government budget constraint.
9. Calvo recursions imply \(\mathcal{Z}_1=\lambda mcY/(1-\theta\beta)\) and \(\mathcal{Z}_2=\lambda Y/(1-\theta\beta)\), with reset price equal to the indexed steady-state price.

Runtime validation of these steady-state assignments was not performed for this archive entry.

## 7. Timing & Form Conventions

- **Debt stock timing**: \(B_t^L\) and \(b_t^L\) are end-of-period stocks after survival of \((1-\alpha)B_{t-1}^L\) and new issuance \(B_t^{L,n}\). The government budget pays redemption and interest on \(t-1\) debt, divided by current inflation in real terms.
- **Long-bond pricing**: \(i_t^{L,n}\) is the rate on newly issued stochastic bonds. \(i_t^L\) is the average rate on outstanding long-term debt and evolves recursively with the surviving stock.
- **Price setting**: non-reset prices are indexed to \(\pi_t^*\) under full information and to the perceived inflation target under imperfect information.
- **Natural and sticky blocks**: the MMB implementation contains a flexible-price natural block and a sticky-price block for output-gap policy; the paper equilibrium description lists \(Y_t^n\) in the Taylor rule but does not fully restate the natural block equations in Section II.
- **Model form**: paper-side equilibrium is linearized for solution; implementation cross-check uses nonlinear level equations and first-order Dynare simulation.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Main equation(s) |
|---|---|---|---|
| Endogenous | `C`, `c` | consumption | (F1), (F19) |
| Endogenous | `M/P`, `m` | real money balances | (F5), (F16) |
| Endogenous | `N`, `h` | labor / hours | (F6), (F20) |
| Endogenous | `B_L`, `D` | real/nominal long-term debt stock | (F12), (F17) |
| Endogenous | `B_L_n`, `Dnew` | newly issued long-term debt | (F12), (F16), (F17) |
| Endogenous | `i_L`, `i_D` | average long-term debt rate | (F13) |
| Endogenous | `i_L_n`, `i_Dnew` | new-issue long-term debt rate | (F2), (F13) |
| Endogenous | `i`, `R` | short-term nominal policy rate / real return convention | (F1), (F18) |
| Endogenous | `pi` | gross inflation | (F14), (F18), (F21) |
| Endogenous | `lambda`, `lamda` | marginal utility of wealth | (F3) |
| Endogenous | `mu` | stochastic-bond multiplier / price | (F4) |
| Endogenous | `tau` | labor tax rate | (F15), (F16) |
| Endogenous | `w`, `MC` | real wage / marginal cost | (F6), (F11) |
| Endogenous | `Y`, `y` | output | (F19), (F20) |
| Endogenous | `Delta_p`, `Disp` | price dispersion | (F21) |
| Endogenous | `Z1`, `Z2` | Calvo auxiliary recursions | (F9), (F10) |
| Endogenous | `P_t^*/P_t` | relative reset price | (F8), (F14), (F21) |
| Endogenous | `pi_star`, `PIESTAR` | inflation target / target deviation | (F18), (F22) |
| Endogenous | `Y_n`, `yn` | flexible-price natural output | (F18); implementation cross-check |
| Exogenous | `eta_PIESTAR` | inflation-target innovation | (F22) |
| Exogenous | `eta_r` / `eta_t` | monetary-policy innovation | (F18), (F23) |
| Exogenous | `epsi_D` | debt shock in MMB implementation | implementation cross-check |
| Exogenous | `epsi_G` | government spending shock in MMB implementation | implementation cross-check |
| Parameter | `beta` / `betta` | discount factor | calibration |
| Parameter | `sigma_c`, `sigma_m` | consumption and money curvature | (F1), (F5) |
| Parameter | `chi` | money utility weight | (F5) |
| Parameter | `phi`, `varphi` | labor disutility curvature and scale | (F6) |
| Parameter | `alpha` / `alphaa` | quarterly maturity probability for stochastic debt | (F12), (F13), (F17) |
| Parameter | `epsilon`, `theta` | goods elasticity and Calvo stickiness | (F8)-(F10), (F14), (F21) |
| Parameter | `rho_tau`, `phi_tau` | fiscal tax feedback parameters | (F15) |
| Parameter | `rho_i`, `phi_pi`, `phi_y` | Taylor-rule parameters | (F18) |
| Parameter | `rho_pi` | inflation-target persistence | (F22), (F24), (F26) |
| Parameter | `k`, `P`, `sigma`, `sigma_pi` | Kalman-filter gain components | (F24)-(F26) |
