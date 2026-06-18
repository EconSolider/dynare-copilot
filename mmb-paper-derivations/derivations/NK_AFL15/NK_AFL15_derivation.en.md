# NK_AFL15 - Monetary policy and risk taking derivation

> First-pass archive extraction for Dynare-oriented review. Status: `needs_review`.

Source: Angeloni, Ignazio; Faia, Ester; Lo Duca, Marco (2015), "Monetary policy and risk taking," Journal of Economic Dynamics & Control 52, 285-307, DOI `10.1016/j.jedc.2014.12.001`.

## 1. Model Overview

- **Model**: New Keynesian model with endogenous bank funding risk and fundamental bank runs.
- **MMB ID**: `NK_AFL15`.
- **Agents**: representative household, bank managers/capitalists/depositors, intermediate-good firms, capital producers, final-good aggregator, government, and monetary authority.
- **Mechanism**: banks finance capital projects with demand deposits and bank capital. Deposit funding is short-term and run-prone; the bank manager chooses the deposit share. Low policy rates reduce the cost of deposit funding, raise leverage, and increase the endogenous probability of bank runs.
- **Form**: nonlinear equilibrium model. The paper reports first-order approximation for IRFs and second-order approximation for volatility/long-run risk exercises. The MMB implementation cross-check uses a nonlinear Dynare `model` block solved around steady state.
- **Runtime validation**: not performed for this archive entry.

## 2. Optimization Problems

### 2.1 Household

The representative household consumes, supplies labor, and saves in risky demand deposits. The source states utility as

```math
E_0 \sum_{t=0}^{\infty}\beta^t U(C_t,N_t).
```

The budget constraint is

```math
P_t C_t + T_t + D_t
\leq W_t N_t + \Theta_t + \Xi_t
+ R_{t-1}(1-\phi_{t-1}g_{t-1})D_{t-1}.
```

For calibration the paper uses

```math
U(C_t,N_t)=\frac{C_t^{1-\sigma}-1}{1-\sigma}+\nu\log(1-N_t),
```

with `needs_review` on the exact OCR sign/normalization of labor disutility because the Markdown text is noisy but the implied marginal utility is consistent with the implementation cross-check.

### 2.2 Bank Manager

The bank manager chooses the deposit ratio

```math
d_t=\frac{D_t}{L_t}
```

to maximize the expected payoff to outside financiers. Total funds satisfy

```math
L_t=Q_t K_{t+1}=D_t+K_t^B.
```

Project returns are $`R_t^A+x_t`$, where $`x_t`$ is uniformly distributed on $`[-h,h]`$. Runs occur when the realization is too low to satisfy promised deposit payments. The source gives the expected-payoff objective as a piecewise integral over run and no-run regions; the closed-form optimum is used below.

### 2.3 Intermediate-Good Firms

Intermediate producers choose labor, capital, and price paths to maximize discounted nominal profits:

```math
E_0\sum_{t=0}^{\infty}\Lambda_{0,t}
\left[
P_t(i)Y_t(i)-W_tN_t(i)-Z_tK_t(i)
-\frac{\vartheta}{2}\left(\frac{P_t(i)}{P_{t-1}(i)}-\pi\right)^2P_t
\right],
```

subject to

```math
Y_t(i)=\left(\frac{P_t(i)}{P_t}\right)^{-\varepsilon}Y_t,
\qquad
Y_t(i)=A_tF(N_t(i),K_t(i)).
```

### 2.4 Capital Producers

Capital producers transform final goods into installed capital and choose investment to maximize

```math
Q_t\chi\left(\frac{I_t}{K_t}\right)K_t-P_tI_t,
```

with capital accumulation

```math
K_{t+1}=(1-\delta)K_t+\chi\left(\frac{I_t}{K_t}\right)K_t.
```

The quantitative specification uses quadratic adjustment costs in the investment-capital ratio.

## 3. First-Order Conditions

- **(F1) Household labor supply**:

```math
\frac{W_t}{P_t}=-\frac{U_{n,t}}{U_{c,t}}.
```

- **(F2) Household Euler equation for demand deposits**:

```math
U_{c,t}=\beta E_t\left[
\frac{R_t}{\pi_{t+1}}(1-\phi_t g_t)U_{c,t+1}
\right].
```

- **(F3) Bank balance-sheet identity**:

```math
L_t=Q_tK_{t+1}=D_t+K_t^B.
```

- **(F4) Optimal deposit ratio**:

```math
d_t=z\frac{R_t^A+h}{R_t},
\qquad
z=\frac{1}{2-\lambda+c(1+\lambda)}.
```

- **(F5) Bank capital implied by funding structure**:

```math
K_t^B=\left(1-z\frac{R_t^A+h}{R_t}\right)Q_tK_{t+1}.
```

- **(F6) Probability of bank run**:

```math
\phi_t=\frac{1}{2h}\int_{-h}^{R_td_t-R_t^A}dx_t
=\frac{1}{2}\left(1-\frac{R_t^A-R_td_t}{h}\right).
```

- **(F7) Reduced-form run probability after substituting the optimal deposit ratio**:

```math
\phi_t=\frac{1}{2}\left(1-\frac{R_t^A(1-z)-zh}{h}\right).
```

- **(F8) Expected bank-capital return in no-run states**:

```math
R_t^{BK}
=\frac{1}{2h}\int_{R_td_t-R_t^A}^{h}
\frac{(R_t^A+x_t)-R_td_t}{2}\,dx_t
=\frac{(R_t^A+h-R_td_t)^2}{8h}.
```

- **(F9) Bank capital accumulation**:

```math
K_t^B=\frac{\theta}{\pi_t}
\left[
K_{t-1}^B+\frac{(R_t^A+h-R_td_t)^2}{8h}L_t
\right].
```

- **(F10) Firm factor demand**:

```math
\frac{W_t}{P_t}=mc_tA_tF_{n,t},
\qquad
\frac{Z_t}{P_t}=mc_tA_tF_{k,t}.
```

- **(F11) Nonlinear Phillips curve with quadratic price adjustment costs**:

```math
U_{c,t}(\pi_t-1)\pi_t
=\beta E_t\left[
U_{c,t+1}(\pi_{t+1}-1)\pi_{t+1}
\right]
+U_{c,t}A_tF_t(\bullet)\frac{\varepsilon}{\vartheta}
\left(mc_t-\frac{\varepsilon-1}{\varepsilon}\right).
```

- **(F12) Labor-market equilibrium combining household and firm conditions**:

```math
-\frac{U_{n,t}}{U_{c,t}}=mc_tA_tF_{n,t}.
```

- **(F13) Capital accumulation**:

```math
K_{t+1}=(1-\delta)K_t+\chi\left(\frac{I_t}{K_t}\right)K_t.
```

- **(F14) Tobin's Q / installed-capital price condition**:

```math
Q_t\chi'\left(\frac{I_t}{K_t}\right)=P_t.
```

- **(F15) Nominal return on capital**:

```math
Y_t^k
=Z_t+Q_t\left[
(1-\delta)-\chi'\left(\frac{I_t}{K_t}\right)\frac{I_t}{K_t}
+\chi\left(\frac{I_t}{K_t}\right)
\right].
```

- **(F16) Real return to bank-financed capital**:

```math
\frac{R_{t+1}^A}{\pi_{t+1}}
=\frac{
mc_{t+1}A_{t+1}F_{k,t+1}
+Q_{t+1}\left[
(1-\delta)-\chi'\left(\frac{I_{t+1}}{K_{t+1}}\right)\frac{I_{t+1}}{K_{t+1}}
+\chi\left(\frac{I_{t+1}}{K_{t+1}}\right)
\right]
}{Q_t}.
```

`needs_review`: the OCR text prints one term in Eq. (26) as `\phi(\cdot)` rather than `\chi(\cdot)`; the surrounding capital-producer notation and implementation cross-check indicate this is the adjustment-cost technology.

## 4. Market Clearing & Identities

- **(F17) Production technology**:

```math
Y_t=A_tF(N_t,K_t).
```

For the quantitative specification:

```math
F(N_t,K_t)=K_t^{\alpha}N_t^{1-\alpha}.
```

- **(F18) Government budget**:

```math
T_t=G_t.
```

- **(F19) Final-goods resource constraint with run and price-adjustment costs**:

```math
Y_t-\Omega_t=C_t+I_t+G_t+\frac{\vartheta}{2}(\pi_t-1)^2.
```

- **(F20) Expected resource cost of bank runs**:

```math
\Omega_t
=\frac{1}{2h}\int_{-h}^{R_td_t-R_t^A}
cR_t^AQ_tK_{t+1}\,dx_t.
```

- **(F21) Monetary policy rule**:

```math
\ln\left(\frac{1+R_t}{1+R}\right)
=\phi_{\pi}\ln\left(\frac{\pi_t}{\pi}\right)
+\phi_y\ln\left(\frac{Y_t}{Y}\right)+m_t.
```

The MMB implementation cross-check uses a gross nominal-rate rule with optional interest smoothing and a policy response to Tobin's Q; these features are not explicit in the paper's displayed Eq. (27) and are recorded as implementation-only details.

## 5. Exogenous Processes

- **(F22) Productivity process**:

```math
A_t=A_{t-1}^{\rho_a}\exp(\varepsilon_t^a),
\qquad \bar A=1.
```

- **(F23) Government spending process**:

```math
\ln\left(\frac{G_t}{G}\right)
=\rho_g\ln\left(\frac{G_{t-1}}{G}\right)+\varepsilon_t^g,
\qquad \frac{G}{Y}=0.2.
```

- **(F24) Monetary policy shock process**:

```math
m_t=\rho_m m_{t-1}+\varepsilon_t^m.
```

The calibration text says the monetary policy shock is moderately persistent with coefficient 0.2. The implementation cross-check uses `rsh=0.2*rsh(-1)+ur`.

## 6. Steady-State Solution

The source states that the model is approximated around a stochastic steady state characterized by the long-run distribution of project idiosyncratic returns. The first-pass deterministic steady-state map below is enough for later implementation review but remains `needs_review`.

1. Normalize $`\bar A=1`$, set $`\bar\pi=\pi`$, and set shocks to zero.
2. From household Euler:

```math
1=\beta\frac{\bar R}{\bar\pi}(1-\bar\phi\bar g),
```

with `needs_review` on whether the implementation treats the risky deposit loss wedge in the steady-state deposit return or absorbs it into `rd`.

3. Desired markup gives

```math
\bar{mc}=\frac{\varepsilon-1}{\varepsilon}.
```

4. For Cobb-Douglas production, compute marginal products:

```math
\bar F_k=\alpha\frac{\bar Y}{\bar K},
\qquad
\bar F_n=(1-\alpha)\frac{\bar Y}{\bar N}.
```

5. Capital-rental pricing:

```math
\bar Z/P=\bar{mc}\,\bar A\,\bar F_k,
\qquad
\bar W/P=\bar{mc}\,\bar A\,\bar F_n.
```

6. With quadratic adjustment costs, $`\bar I/\bar K=\delta`$, $`\bar Q=1`$, and the return equation pins down $`\bar R^A`$ from marginal product plus undepreciated capital value.
7. Bank funding and risk:

```math
\bar d=z\frac{\bar R^A+h}{\bar R},\qquad
\bar K^B=(1-\bar d)\bar Q\bar K,\qquad
\bar\phi=\frac{1}{2}\left(1-\frac{\bar R^A-\bar R\bar d}{h}\right).
```

8. Bank capital supply:

```math
\bar K^B=\frac{\theta}{\bar\pi}
\left[
\bar K^B+\frac{(\bar R^A+h-\bar R\bar d)^2}{8h}\bar L
\right],
\qquad
\bar L=\bar Q\bar K.
```

This equation is `needs_review` for exact timing because the paper's displayed Eq. (17) and the MMB implementation index bank capital and loan stocks differently.

9. Set $`\bar G=0.2\bar Y`$ and use the resource constraint to solve household consumption:

```math
\bar C=\bar Y-\bar I-\bar G-\bar\Omega.
```

10. Use the labor supply condition to choose $`\nu`$ or match the calibration target $`\bar N\approx0.3`$.

Calibration values from the paper include $`\sigma=1`$, $`\beta=0.99`$, $`\alpha=0.3`$, $`\delta=0.025`$, $`\varepsilon=6`$, $`\lambda=0.45`$, $`\theta=0.97`$, $`c=0.1`$, $`\rho_a=0.95`$, $`\rho_g=0.9`$, $`\phi_{\pi}=1.5`$, $`\phi_y=0.5/4`$, and $`h=0.4`$. The MMB file uses `BETTA=0.995`, `ALFA=1/3`, and other close but not identical calibration names; this difference is left for review.

## 7. Timing & Form Conventions

- Capital chosen in period $`t`$ is written as $`K_{t+1}`$ in the paper's bank balance-sheet and capital-producer equations; the implementation cross-check stores production capital as `k(-1)` and current accumulation as `k`.
- Bank capital $`K_t^B`$ is a state variable accumulated from surviving bank capitalists' retained earnings.
- Demand deposits promise a nominal contractual return chosen before next-period project returns and run outcomes are realized.
- The real return to capital between $`t`$ and $`t+1`$ is $`R_{t+1}^A/\pi_{t+1}`$.
- The paper model is nonlinear; do not treat the derivation as `model(linear)`.
- `needs_review`: source OCR contains several noisy symbols in equations (especially Eq. (26), the resource-cost integral, and the definition of $`g_t`$ in Appendix A). They were normalized only where the surrounding notation made the correction clear.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Main equation |
|---|---|---|---|
| Endogenous | $`C_t`$ / `c` | household consumption | (F2), (F19) |
| Endogenous | $`N_t`$ / `n` | labor hours | (F1), (F12), (F17) |
| Endogenous | $`D_t`$ / `demand_deposits` | demand deposits | (F3), (F4) |
| Endogenous | $`d_t`$ / `deprat` | deposit ratio | (F4) |
| Endogenous | $`K_t^B`$ / `bk` | bank capital | (F5), (F9) |
| Endogenous | $`L_t`$ / `loans` | bank loans / funds | (F3) |
| Endogenous | $`\phi_t`$ / `br` | probability of bank run / riskiness | (F6), (F7) |
| Endogenous | $`R_t^{BK}`$ / `rbk` | bank-capital return | (F8) |
| Endogenous | $`Y_t`$ / `y` | output | (F17), (F19) |
| Endogenous | $`I_t`$ / `inv` | investment | (F13), (F19) |
| Endogenous | $`K_t`$ / `k` | physical capital stock | (F13), (F17) |
| Endogenous | $`Q_t`$ / `q` | Tobin's Q / asset price | (F14), (F16) |
| Endogenous | $`R_t^A`$ / `ra` | project / bank asset return | (F16) |
| Endogenous | $`\pi_t`$ / `pai` | gross inflation | (F11), (F21) |
| Endogenous | $`mc_t`$ / `mc` | real marginal cost | (F10), (F11) |
| Endogenous | $`W_t/P_t`$ / `w_real` | real wage | (F1), (F10) |
| Endogenous | $`Z_t/P_t`$ / `z` | real rental rate of capital | (F10) |
| Endogenous | $`\Omega_t`$ / `crun` | resource cost of bank runs | (F20) |
| Endogenous | $`G_t`$ / `g` | government consumption | (F23), (F19) |
| Endogenous | $`R_t`$ / `rn` or `rd` | policy/deposit return, notation differs by source and implementation | (F2), (F21) |
| Exogenous | $`\varepsilon_t^a`$ / `ua` | productivity innovation | (F22) |
| Exogenous | $`\varepsilon_t^g`$ / `ug` | government-spending innovation | (F23) |
| Exogenous | $`\varepsilon_t^m`$ / `ur` | monetary policy innovation | (F24) |
| Parameter | $`\beta`$ / `BETTA` | discount factor | (F2) |
| Parameter | $`\sigma`$ / `SIG` | inverse intertemporal elasticity | preferences |
| Parameter | $`\nu`$ or `PHI` | labor utility weight | (F1) |
| Parameter | $`\alpha`$ / `ALFA` | capital share | (F17) |
| Parameter | $`\delta`$ / `DELTA` | depreciation rate | (F13) |
| Parameter | $`\varepsilon`$ / `EPSI` | demand elasticity | (F11) |
| Parameter | $`\vartheta`$ / `OMP` | price adjustment cost | (F11), (F19) |
| Parameter | $`\lambda`$ | relationship-lending recovery parameter | (F4) |
| Parameter | $`c`$ / `CR` | run liquidation cost | (F4), (F20) |
| Parameter | $`h`$ / `HH` | half-width of project idiosyncratic return shock | (F4), (F6) |
| Parameter | $`\theta`$ / `THETA` | bank survival rate | (F9) |
| Parameter | $`\rho_a,\rho_g,\rho_m`$ | shock persistence | (F22)-(F24) |
| Parameter | $`\phi_{\pi},\phi_y`$ / `vP`, `vY` | Taylor-rule coefficients | (F21) |

Equation count: (F1)-(F24), 24 numbered conditions.
