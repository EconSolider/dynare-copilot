# NK_ST13 - Derivation (Optimization Problems + First-Order Conditions)

> Model archive draft for `NK_ST13`. Runtime validation was not performed. Paper-side equations come from the MinerU Markdown for Stracca (2013); the MMB `.mod` file was used only as an implementation cross-check.

## 1. Model Overview

- **Model**: Livio Stracca (2013), "Inside money in general equilibrium: Does it matter for monetary policy?", *Macroeconomic Dynamics* 17(3), 563-590, DOI `10.1017/s1365100511000368`.
- **Archive ID**: `NK_ST13`.
- **Agents**: representative household, final-good producer, continuum of intermediate-good firms, competitive financial intermediary, monetary authority, passive fiscal authority.
- **Core mechanism**: deposits are inside money and enter a deposit-in-advance constraint for consumption. Banks issue deposits, bonds, and central-bank borrowing while holding loans and reserves. Deposit production costs make the inside-money premium, $`R_t-R_t^d`$, endogenous.
- **Shocks**: technology $`\varepsilon_{\theta t}`$, monetary policy $`\varepsilon_t^R`$, inside-money demand $`q_t`$, and inside-money supply/intermediation-cost shock $`j_t`$.
- **Form**: nonlinear equilibrium conditions with Rotemberg price adjustment and quadratic capital/deposit adjustment costs; MMB implementation solves by first-order approximation. A parallel frictionless/reference block appears in the implementation, but the paper-side baseline archive entry below focuses on the inside-money model.
- **Source quality**: first-pass extraction from OCR Markdown. Equations are legible enough for a draft, but several expectation/timing normalizations require source-level review before promotion.

## 2. Optimization Problems

### 2.1 Household

The household chooses $`\{c_t,n_t,b_t,d_t\}`$ to maximize expected lifetime utility

```math
E_t\sum_{j=0}^{\infty}\beta^j U_{t+j},
\qquad
U_t=\ln c_t-\phi n_t-\frac{\phi_d}{2}\left(\frac{D_t-D_{t-1}}{P_t}\right)^2,
```

subject to the real budget constraint and deposit-in-advance constraint

```math
c_t+b_t+d_t=w_t n_t+\frac{d_{t-1}R_{t-1}^d}{\pi_t}
+\frac{b_{t-1}R_{t-1}}{\pi_t}+g_t,
```

```math
\alpha_t c_t\le d_t.
```

The Lagrange multipliers are $`\lambda_t`$ for the budget constraint and $`\xi_t`$ for the deposit-in-advance constraint.

### 2.2 Final-Good Producer

A competitive final-good producer aggregates differentiated goods $`y_t(z)`$ using

```math
y_t=\left(\int_0^1 y_t(z)^{\frac{\mu-1}{\mu}}\,dz\right)^{\frac{\mu}{\mu-1}},
```

and chooses demands for each variety taking prices as given.

### 2.3 Intermediate-Good Firms

Each intermediate firm uses Cobb-Douglas technology

```math
y_t(z)=A_t k_t(z)^\gamma n_t(z)^{1-\gamma},
```

borrows one period in advance to finance the wage bill and investment,

```math
L_t(z)=W_t n_t(z)+P_t i_t(z),
```

and maximizes discounted dividends net of Rotemberg price adjustment costs and quadratic capital adjustment costs. The adjustment costs are

```math
C_p(P_t(z))=\frac{\phi_p}{2}\left(\frac{P_t(z)}{P_{t-1}(z)}-1\right)^2 y_t(z),
```

```math
C_k(k_t(z))=\frac{\phi_k}{2}\left(k_t(z)-k_{t-1}(z)\right)^2.
```

### 2.4 Financial Intermediary

The representative competitive bank chooses lending and deposit rates and reserves, taking the policy rate as given, subject to the balance-sheet constraint

```math
L_t+M_t=B_t+D_t+\widetilde B_t.
```

Real profits are

```math
\begin{aligned}
g_t^f={}&d_t+b_t+\widetilde b_t+\frac{m_{t-1}}{\pi_t}
+l_{t-1}\frac{R_{t-1}^l}{\pi_t}
-\frac{d_{t-1}R_{t-1}^d}{\pi_t}
-\frac{b_{t-1}R_{t-1}}{\pi_t} \\
&-\frac{\widetilde b_{t-1}R_{t-1}}{\pi_t}
-(1+\sigma)l_t-m_t-\frac{\omega_t d_t}{m_t}.
\end{aligned}
```

Financial intermediation costs are

```math
f_t=\sigma l_t+\frac{\omega_t d_t}{m_t}.
```

### 2.5 Monetary Authority

The central bank exchanges bank reserves for bonds,

```math
\widetilde B_t=M_t,
```

and sets the gross risk-free nominal interest rate using an interest-rate smoothing rule.

## 3. First-Order Conditions

**Household**

- **(F1) Deposit-in-advance constraint**:

```math
\alpha_t c_t=d_t.
```

- **(F2) Consumption FOC**:

```math
\frac{1}{c_t}-\lambda_t-\xi_t\alpha_t=0.
```

- **(F3) Labor FOC**:

```math
\lambda_t=\frac{\phi}{w_t}.
```

- **(F4) Bond Euler equation**:

```math
\lambda_t=\beta R_t E_t\left(\frac{\lambda_{t+1}}{\pi_{t+1}}\right).
```

- **(F5) Deposit FOC / inside-money demand with adjustment cost**:

```math
\beta E_t\left[\frac{\lambda_{t+1}(R_t-R_t^d)}{\pi_{t+1}}\right]
+\phi_d\left(d_t-\frac{d_{t-1}}{\pi_t}\right)
=\beta\phi_d E_t\left[\frac{1}{\pi_{t+1}}\left(d_{t+1}-\frac{d_t}{\pi_{t+1}}\right)\right]-\xi_t.
```

`needs_review`: the Rep-MMB `.mod` comments that the sign on $`\xi_t`$ differs from the paper; the formula above follows the paper OCR.

- **(F6) Stochastic discount factor**:

```math
\psi_{t,t+1}=\beta E_t\left(\frac{\lambda_{t+1}}{\lambda_t}\right).
```

**Final-Good Producer**

- **(F7) Demand for each intermediate variety**:

```math
y_t(z)=\left(\frac{P_t(z)}{P_t}\right)^{-\mu}y_t.
```

- **(F8) Aggregate price index**:

```math
P_t=\left(\int_0^1 P_t(z)^{1-\mu}\,dz\right)^{-\frac{1}{1-\mu}}.
```

**Intermediate-Good Firms**

- **(F9) Production function**:

```math
y_t(z)=A_t k_t(z)^\gamma n_t(z)^{1-\gamma}.
```

- **(F10) Capital accumulation**:

```math
k_t=i_t+(1-\delta)k_{t-1}.
```

- **(F11) Marginal product of capital**:

```math
y_t^k=\gamma\frac{y_t}{k_{t-1}}.
```

- **(F12) Marginal product of labor**:

```math
y_t^n=(1-\gamma)\frac{y_t}{n_t}.
```

- **(F13) Real marginal cost with financing costs**:

```math
\operatorname{rmc}_t(z)
=E_t\left[\frac{\psi_{t,t+1}w_t R_t^l}{y_t^n(z)\pi_{t+1}}\right]
=\frac{R_{t-1}^l}{y_t^k(z)\pi_t}
-E_t\left[\frac{\psi_{t,t+1}R_t^l(1-\delta)}{y_{t+1}^k(z)\pi_{t+1}}\right]
+\phi_k\left(\frac{\Delta k_t(z)}{y_t^k(z)}
-E_t\left[\psi_{t,t+1}\frac{\Delta k_{t+1}(z)}{y_t^k(z)}\right]\right).
```

`needs_review`: the OCR formula carries both labor-cost and capital-cost expressions in one displayed equation; this entry preserves the relationship but should be checked against the PDF.

- **(F14) Labor demand**:

```math
w_t=E_t\left[\frac{\psi_{t,t+1}y_t^n(z)P_t(z)\pi_{t+1}}{P_t R_t^l}\right].
```

- **(F15) Capital FOC**:

```math
\frac{R_{t-1}^l}{\pi_t}+\phi_k\Delta k_t(z)
=\frac{P_t(z)}{P_t}y_t^k(z)
+\phi_k E_t\left[\psi_{t,t+1}\Delta k_{t+1}(z)\right]
+E_t\left[\frac{\psi_{t,t+1}R_t^l(1-\delta)}{\pi_{t+1}}\right].
```

- **(F16) Rotemberg New Keynesian Phillips curve**:

```math
\lambda_t(\pi_t-1)\pi_t
=\frac{\lambda_t}{\phi_p}(1-\mu+\mu\,\operatorname{rmc}_t)
+\beta E_t\left[\lambda_{t+1}(\pi_{t+1}-1)\pi_{t+1}\frac{y_{t+1}}{y_t}\right].
```

**Financial Intermediary**

- **(F17) Bank balance-sheet identity**:

```math
l_t+m_t=b_t+d_t+\widetilde b_t.
```

- **(F18) Loan supply / external finance premium**:

```math
E_t\left[\psi_{t,t+1}\frac{R_t^l-R_t}{\pi_{t+1}}\right]=\sigma.
```

- **(F19) Deposit-rate FOC / inside-money premium**:

```math
E_t\left[\psi_{t,t+1}\frac{R_t-R_t^d}{\pi_{t+1}}\right]=\frac{\omega_t}{m_t}.
```

- **(F20) Bank reserve demand**:

```math
m_t=E_t\left[\frac{\omega_t d_t\pi_{t+1}}{\beta\lambda_{t+1}(R_t-1)}\right]^{1/2}.
```

**Monetary Authority**

- **(F21) Central-bank balance sheet**:

```math
\widetilde B_t=M_t.
```

- **(F22) Interest-rate rule**:

```math
R_t=(1-\rho)\left[\frac{1}{\beta}+\varphi_\pi(\pi_t-1)\right]+\rho R_{t-1}+\varepsilon_t^R.
```

## 4. Market Clearing & Identities

- **(F23) Economywide resource constraint**:

```math
y_t=c_t+i_t+\frac{\phi_k}{2}\Delta k_t^2
+\frac{\phi_p}{2}\left(\frac{P_t}{P_{t-1}}-1\right)^2y_t
+\frac{\omega_t d_t}{m_t}+\sigma l_t.
```

- **(F24) Loan demand by firms**:

```math
l_t=i_t+w_t n_t.
```

- **(F25) Financial intermediation cost definition**:

```math
f_t=\sigma l_t+\frac{\omega_t d_t}{m_t}.
```

- **(F26) Interest-rate spreads**:

```math
EFP_t=R_t^l-R_t,\qquad IMP_t=R_t-R_t^d.
```

- **(F27) Capital change definition**:

```math
\Delta k_t=k_t-k_{t-1}.
```

## 5. Exogenous Processes

- **(F28) Deposit-in-advance tightness / inside-money demand shock**:

```math
\alpha_t=\rho_\alpha\alpha_{t-1}+(1-\rho_\alpha)\alpha+q_t.
```

- **(F29) Technology process**:

```math
A_t=\exp(\chi t+\theta_t),
\qquad
\theta_t=\rho_\theta\theta_{t-1}+\varepsilon_{\theta t}.
```

- **(F30) Inside-money supply cost process**:

```math
\omega_t=(1-\rho_\omega)\omega+\rho_\omega\omega_{t-1}+j_t.
```

- **(F31) Optional banking-distress variant**:

```math
\sigma_t=\sigma+\omega_t-\omega.
```

The variant in (F31) is discussed as a banking-distress experiment, not the baseline model block.

## 6. Steady-State Solution

The paper uses a zero-inflation, nonstochastic steady state. Set $`\pi=1`$, shocks to zero, $`A=1`$ when $`\chi=0`$ in the MMB calibration, and $`\Delta k=0`$.

1. Bond Euler equation:

```math
R=\frac{1}{\beta}.
```

2. Deposit-in-advance constraint:

```math
d=\alpha c.
```

3. Household steady-state money demand from the appendix:

```math
\ln d=-\ln\left[\frac{\lambda}{\alpha}+\beta(R-R^d)\right].
```

`needs_review`: Appendix equation (A.5) in the OCR includes an apparent trailing `=0`; the logged expression above follows the paper's equation (14)/(A.6).

4. Labor FOC and consumption FOC:

```math
\lambda=\frac{\phi}{w},
\qquad
\xi=\frac{1}{c\alpha}-\frac{\lambda}{\alpha}.
```

5. Financial-intermediary spreads:

```math
R^l=R+\frac{\sigma}{\psi},
\qquad
R^d=R-\frac{\omega}{m\psi}.
```

6. Reserve demand:

```math
m=\left[\frac{\omega d}{\beta\lambda(R-1)}\right]^{1/2}.
```

7. Firm-side steady state with zero capital adjustment:

```math
k=i+(1-\delta)k,\qquad i=\delta k.
```

```math
y=A k^\gamma n^{1-\gamma},\qquad
y^k=\gamma\frac{y}{k},\qquad
y^n=(1-\gamma)\frac{y}{n}.
```

8. Zero-inflation marginal cost from the Phillips curve:

```math
\operatorname{rmc}=\frac{\mu-1}{\mu}.
```

9. Resource constraint:

```math
y=c+i+\frac{\omega d}{m}+\sigma l,
\qquad
l=i+wn.
```

10. Calibration values used by the MMB implementation include $`\beta=0.995`$, $`\phi=3`$, $`\gamma=0.35`$, $`\delta=0.025`$, $`\sigma=0.00675`$, $`\omega=0.0009`$, $`\alpha=0.7`$, $`\phi_d=10`$, $`\rho_\alpha=0.88`$, $`\phi_p=58.25`$, $`\phi_k=4`$, $`\rho=0.75`$, $`\rho_\pi=1.5`$, $`\rho_\omega=0.9`$, and $`\rho_\theta=0.95`$.

## 7. Timing & Form Conventions

- Deposits, bank bonds, and firm loans are one-period nominal claims. Household assets chosen at $`t`$ pay at $`t+1`$ and enter the real budget through division by current inflation.
- The household lends deposits and bank bonds at the beginning of period $`t`$; the bank then lends to firms, which use loans to pay wages and investment. Firms repay loans at the beginning of $`t+1`$.
- Productive capital is predetermined in production. The MMB implementation uses $`k_{t-1}`$ in production and marginal products, with $`k_t=i_t+(1-\delta)k_{t-1}`$.
- Inflation is gross inflation, $`\pi_t=P_t/P_{t-1}`$.
- The paper equations are nonlinear. Dynare/Rep-MMB approximates them around the zero-inflation steady state. Do not treat this archive draft as a hand-log-linearized model.
- Runtime validation was not performed, and Dynare was not run.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Main equation(s) |
| --- | --- | --- | --- |
| Endogenous | $`c_t`$ / `c` | consumption | (F1), (F2), (F23) |
| Endogenous | $`i_t`$ / `i` | investment | (F10), (F23), (F24) |
| Endogenous | $`y_t`$ / `y` | output | (F7), (F9), (F23) |
| Endogenous | $`n_t`$ / `n` | labor | (F3), (F12), (F14) |
| Endogenous | $`w_t`$ / `w` | real wage | (F3), (F14), (F24) |
| Endogenous | $`k_t`$ / `k` | capital stock | (F10), (F15), (F27) |
| Endogenous | $`\Delta k_t`$ / `delta_k` | capital change | (F27) |
| Endogenous | $`m_t`$ / `m` | real outside money / bank reserves | (F20), (F23) |
| Endogenous | $`d_t`$ / `d` | real deposits / inside money | (F1), (F5), (F19) |
| Endogenous | $`b_t`$ / `b` | bank bonds held by households | (F17) |
| Endogenous | $`l_t`$ / `l` | bank loans to firms | (F17), (F18), (F24) |
| Endogenous | $`R_t`$ / `R` | risk-free gross nominal rate | (F4), (F22) |
| Endogenous | $`R_t^d`$ / `Rd` | gross deposit rate | (F5), (F19), (F26) |
| Endogenous | $`R_t^l`$ / `Rl` | gross loan rate | (F13), (F18), (F26) |
| Endogenous | $`\lambda_t`$ / `lambda` | budget multiplier | (F2)-(F6) |
| Endogenous | $`\xi_t`$ / `xi` | deposit-in-advance multiplier | (F2), (F5) |
| Endogenous | $`\psi_{t,t+1}`$ / `psi` | stochastic discount factor | (F6), (F13), (F18)-(F20) |
| Endogenous | $`\pi_t`$ / `pi` | gross inflation | (F4), (F16), (F22), (F23) |
| Endogenous | $`\operatorname{rmc}_t`$ / `rmc` | real marginal cost | (F13), (F16) |
| Endogenous | $`y_t^k`$ / `yk` | marginal product of capital | (F11), (F13), (F15) |
| Endogenous | $`y_t^n`$ / `yn` | marginal product of labor | (F12), (F13), (F14) |
| Endogenous | $`f_t`$ / `f` | financial intermediation costs | (F25) |
| Endogenous | $`EFP_t`$ / `EFP` | external finance premium | (F26) |
| Endogenous | $`IMP_t`$ / `IMP` | inside-money premium | (F26) |
| Endogenous | $`\alpha_t`$ / `alpha` | deposit-in-advance tightness | (F1), (F28) |
| Endogenous | $`\omega_t`$ / `omega` | deposit intermediation cost shifter | (F19), (F20), (F30) |
| Endogenous | $`A_t,\theta_t`$ / `A`, `theta` | productivity level and technology state | (F9), (F29) |
| Exogenous | $`q_t`$ / `q` | inside-money demand innovation | (F28) |
| Exogenous | $`\varepsilon_{\theta t}`$ / `epsilon_theta` | technology innovation | (F29) |
| Exogenous | $`j_t`$ / `j` | inside-money supply/cost innovation | (F30) |
| Exogenous | $`\varepsilon_t^R`$ / `epsilon_r` | monetary policy innovation | (F22) |
| Parameter | $`\beta`$ / `beta` | discount factor | (F4)-(F6), (F16), (F20), (F22) |
| Parameter | $`\phi`$ / `phi` | labor disutility weight | (F3) |
| Parameter | $`\phi_d`$ / `phi_d` | deposit adjustment cost | (F5) |
| Parameter | $`\gamma`$ / `gamma` | capital share | (F9), (F11), (F12) |
| Parameter | $`\delta`$ / `delta` | capital depreciation | (F10), (F15) |
| Parameter | $`\phi_p`$ / `phi_p` | Rotemberg price adjustment cost | (F16), (F23) |
| Parameter | $`\phi_k`$ / `phi_k` | capital adjustment cost | (F13), (F15), (F23) |
| Parameter | $`\mu`$ / `mu` | elasticity of substitution / markup parameter | (F7), (F8), (F16) |
| Parameter | $`\sigma`$ / `sigma` | loan intermediation cost | (F18), (F23), (F25) |
| Parameter | $`\omega`$ / `omega_ss` | steady deposit-service cost shifter | (F19), (F20), (F30) |
| Parameter | $`\rho,\varphi_\pi`$ / `rho`, `rho_pi` | policy smoothing and inflation response | (F22) |
| Parameter | $`\rho_\alpha,\rho_\theta,\rho_\omega`$ | shock persistence | (F28)-(F30) |
