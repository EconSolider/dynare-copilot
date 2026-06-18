# HK_FPP11 -- Derivation (Optimization Problems + First-Order Conditions)

> Archive status: `needs_review`. This first-pass derivation is based on MinerU Markdown from Funke, Paetz, and Pytlarczyk (2011) and has not been runtime validated in Dynare.
> Provenance: model_id `HK_FPP11`; paper "Stock market wealth effects in an estimated DSGE model for Hong Kong"; authors Michael Funke, Michael Paetz, Ernest Pytlarczyk; year 2011; DOI `10.1016/j.econmod.2010.08.016`; source Markdown `raw/mmb_mineru/runs/hk_fpp11__stock_market_wealth_effects_in_an_estimated_dsge_model_for_hong_kong__24bfe42d/full.md`; raw PDF `raw/mmb_papers/Stock market wealth effects in an estimated DSGE model for Hong Kong.pdf`; MinerU run id `24bfe42d-832c-4187-85cd-31bab6f55223`.

## 1. Model Overview

- **Model**: Estimated small open-economy New Keynesian DSGE model for Hong Kong with stock-market wealth effects and an exchange-rate peg.
- **Experiment**: Bayesian estimation and stochastic simulation of a linearized system for quarterly Hong Kong output, stock prices, CPI inflation, and foreign demand over 1981Q1-2007Q3.
- **Agents and blocks**: Perpetual-youth households choose consumption, labor, state-contingent bonds, and equity; monopolistically competitive intermediate firms set staggered prices; final-goods firms aggregate differentiated goods; monetary policy is the interest-rate adjustment required to keep the exchange rate fixed.
- **Form**: `model(linear)` / log-linear canonical representation. Lowercase variables are deviations from a symmetric zero-inflation steady state. The derivation records the nonlinear foundations where they feed the linear equilibrium.
- **First-pass uncertainty**: `needs_review` for several OCR-sensitive parameter definitions in the Markdown, especially the exact Greek symbols in the canonical coefficients.

## 2. Optimization Problems

### 2.1 Perpetual-Youth Household

Each cohort $`j`$ faces death probability $`\gamma`$ and chooses consumption, labor, domestic and foreign state-contingent bonds, and equity shares:

```math
\max_{\{C_t(j),N_t(j),B_{t+1}(j),B^i_{t+1}(j),Z_{t+1}(k,j)\}}
E_0\sum_{t=0}^{\infty}\beta^t(1-\gamma)^t
\left[\log C_t(j)+\log(1-N_t(j))\right].
```

The real budget constraint is

```math
\begin{aligned}
C_t(j)&+\frac{1}{P_t}E_t\{F_{t,t+1}B_{t+1}(j)\}
+\int_0^1\frac{\Xi_t^i}{P_t}E_t\{F_{t,t+1}B^i_{t+1}(j)\}\,di \\
&+\frac{1}{P_t}\int_0^1 Q_t(k)Z_{t+1}(k,j)\,dk
=\frac{W_t}{P_t}N_t(j)-T_t(j)+\frac{\Omega_t(j)}{P_t}.
\end{aligned}
```

Nominal financial wealth is

```math
\Omega_t(j)=\frac{1}{1-\gamma}
\left[
B_t(j)+\int_0^1\Xi_t^iB_t^i(j)\,di
+\int_0^1\big(Q_t(k)+D_t(k)\big)Z_t(k,j)\,dk
\right].
```

### 2.2 Intratemporal Consumption Allocation

Households consume a CES aggregate of domestic and foreign goods:

```math
C_t(j)=\left[(1-\alpha)^{1/\varpi}C_{H,t}(j)^{(\varpi-1)/\varpi}
+\alpha^{1/\varpi}C_{F,t}(j)^{(\varpi-1)/\varpi}\right]^{\varpi/(\varpi-1)}.
```

The associated CPI is

```math
P_t=\left[(1-\alpha)P_{H,t}^{1-\varpi}+\alpha P_{F,t}^{1-\varpi}\right]^{1/(1-\varpi)}.
```

### 2.3 Intermediate Firms

Intermediate firm $`k`$ has linear technology

```math
Y_t(k)=A_tN_t(k),
```

and real marginal cost

```math
MC_t=(1-\vartheta)\frac{W_t}{P_{H,t}A_t}\exp(\mu_t^p).
```

Forward-looking price setters solve the Calvo problem

```math
\max_{\{P_{H,t}(k)\}}\;
E_t\sum_{i=0}^{\infty}\theta^i\Delta_{i,t+i}
\left[
\frac{P_{H,t}(k)}{P_{H,t+i}}Y_{t+i}(k)-MC_{t+i}Y_{t+i}(k)
\right].
```

Backward-looking price setters use the rule of thumb

```math
p^{bl}_{H,t}=\bar p^n_{H,t-1}+\pi_{H,t-1}.
```

## 3. First-Order Conditions

- **(F1) Household labor-leisure margin**:

```math
\frac{C_t(j)}{1-N_t(j)}=\frac{W_t}{P_t}.
```

- **(F2) Stochastic discount factor / Euler condition**:

```math
F_{t,t+1}=\beta E_t\left[
\frac{P_t}{P_{t+1}}\frac{C_t(j)}{C_{t+1}(j)}
\right].
```

- **(F3) Equity pricing condition**:

```math
Q_t(k)=E_t\left\{F_{t,t+1}\left[Q_{t+1}(k)+D_{t+1}(k)\right]\right\}.
```

- **(F4) No-arbitrage condition for a domestic one-period bond**:

```math
(1+r_t)E_t\{F_{t,t+1}\}=1.
```

- **(F5) Aggregate wealth-consumption condition**:

```math
P_tC_t=\left[1-\beta(1-\gamma)\right](\Omega_t+H_t).
```

- **(F6) Aggregate consumption law with wealth effects**:

```math
\beta P_tC_t=\frac{\gamma}{1-\gamma}E_t\{F_{t,t+1}\Omega_{t+1}\}
+\left[1-\beta(1-\gamma)\right]E_t\{F_{t,t+1}P_{t+1}C_{t+1}\}.
```

- **(F7) Canonical dynamic IS equation with stock-price wealth effect**:

```math
x_t=\frac{\sigma_{\alpha}}{\Gamma_0}E_tx_{t+1}
+\frac{\Psi}{\Gamma_0}\widehat q_t
-\frac{1}{\Gamma_0}\left(r_t-E_t\pi_{H,t+1}-rr_t^n\right).
```

- **(F8) Stock-price gap dynamics**:

```math
\widehat q_t=\frac{\tilde\beta}{1+\epsilon}E_t\widehat q_{t+1}
-\frac{\lambda_q}{1+\epsilon}E_tx_{t+1}
-\left(r_t-E_t\pi_{H,t+1}-rr_t^n\right)+\eta_t.
```

- **(F9) Hybrid New Keynesian Phillips curve**:

```math
\pi_{H,t}=\phi\left(\theta\tilde\beta E_t\pi_{H,t+1}+\tau\pi_{H,t-1}\right)
+\kappa_{\alpha}x_t+\varepsilon_t^{\mu}.
```

- **(F10) Monetary-policy closure under exchange-rate peg**:

```math
r_t=\phi_{\pi}\pi_{H,t}+\phi_xx_t.
```

The paper states an exchange-rate peg, $`e_t=0`$, as the policy objective; the MMB implementation cross-check uses the simple estimated reaction rule above with $`\phi_x=0`$.

## 4. Market Clearing & Identities

- **(F11) Terms-of-trade/output relationship from risk sharing and demand aggregation**:

```math
s_t=\sigma_{\alpha}(y_t-y_t^{\ast}).
```

- **(F12) Natural output**:

```math
y_t^n=\Gamma_a a_t-\alpha\Gamma_{y^{\ast}}y_t^{\ast}.
```

- **(F13) Output gap definition**:

```math
x_t=y_t-y_t^n.
```

- **(F14) CPI inflation identity**:

```math
\pi_t=\pi_{H,t}+\alpha(s_t-s_{t-1}).
```

- **(F15) Exchange-rate/terms-of-trade identity under PPP and the peg**:

```math
e_t-e_{t-1}=s_t-s_{t-1}+\pi_{H,t}.
```

With the peg $`e_t=0`$, this implies $`\Delta s_t=-\pi_{H,t}`$.

- **(F16) Natural interest rate**:

```math
\begin{aligned}
rr_t^n={}&\rho+\left[\sigma_{\alpha}\rho_a+\Psi-\Gamma_0\right]\Gamma_a a_t \\
&+\left[\left(\sigma_{\alpha}\rho_{y^{\ast}}+\Psi-\Gamma_0\right)\Gamma_{y^{\ast}}
+\Theta\sigma_{\alpha}(\rho_{y^{\ast}}-1)\right]\alpha y_t^{\ast}.
\end{aligned}
```

## 5. Exogenous Processes

- **(F17) Domestic productivity**:

```math
a_t=\rho_a a_{t-1}+\varepsilon_t^a.
```

- **(F18) Foreign demand**:

```math
y_t^{\ast}=\rho_{y^{\ast}}y_{t-1}^{\ast}+\varepsilon_t^{y^{\ast}}.
```

- **(F19) Stock-price-gap disturbance**:

```math
\eta_t=\rho_{\eta}\eta_{t-1}+\varepsilon_t^{\eta}.
```

- **(F20) Cost-push shock**:

```math
\mu_t^p=\varepsilon_t^{\mu}.
```

## 6. Steady-State Solution

The implemented system is linearized around a symmetric zero-inflation steady state:

```math
\bar e=0,\quad \bar s=0,\quad \bar \pi_H=0,\quad \bar \pi=0,\quad
\bar x=0,\quad \bar{\widehat q}=0,\quad \bar a=0,\quad \bar y^{\ast}=0,\quad
\bar \eta=0,\quad \bar \mu^p=0.
```

The paper's steady-state relations include:

```math
Q+D=(1+r)Q(1+\epsilon),
```

```math
Y=AN,
```

```math
MC=\frac{1}{1+\mu},
```

```math
D=\frac{\mu}{1+\mu}\frac{P_H}{P}Y.
```

For the MMB linear implementation, the steady-state values of the modeled deviations are zero. Runtime validation was not performed.

## 7. Timing & Form Conventions

- The archive entry is for a `model(linear)` representation.
- $`x_t`$, $`\widehat q_t`$, $`r_t`$, $`rr_t^n`$, $`\pi_{H,t}`$, $`s_t`$, $`e_t`$, $`y_t`$, $`y_t^n`$, $`a_t`$, $`y_t^{\ast}`$, and $`\eta_t`$ are log or percentage deviations from steady state.
- The stock-price gap is $`\widehat q_t=q_t-q_t^n`$ and the natural stock price satisfies $`q_t^n=y_t^n`$.
- The Phillips curve contains one lead and one lag of producer-price inflation.
- The dynamic IS equation and stock-price-gap equation are forward-looking.
- Shock processes are first-order autoregressions except the cost-push innovation, which enters the Phillips curve directly.
- The raw PDF exists but was not opened for body-level formula checks; uncertain OCR symbols are marked for review in `extraction_notes.md`.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII name | Meaning | Equation |
|---|---|---|---|
| Endogenous | `x`, $`x_t`$ | Domestic output gap | (F7), (F13) |
| Endogenous | `q_dach`, $`\widehat q_t`$ | Stock-price gap | (F8) |
| Endogenous | `r`, $`r_t`$ | Nominal policy interest-rate deviation | (F10) |
| Endogenous | `rr`, $`rr_t^n`$ | Natural real interest rate | (F16) |
| Endogenous | `pi_H`, $`\pi_{H,t}`$ | Producer-price inflation | (F9) |
| Endogenous | `pi`, $`\pi_t`$ | Consumer-price inflation | (F14) |
| Endogenous | `s`, $`s_t`$ | Effective terms of trade | (F11), (F15) |
| Endogenous | `e`, $`e_t`$ | Nominal effective exchange rate | (F15) |
| Endogenous | `y`, $`y_t`$ | Domestic output | (F13) |
| Endogenous | `y_n`, $`y_t^n`$ | Natural output | (F12) |
| Endogenous | `a`, $`a_t`$ | Productivity state | (F17) |
| Endogenous | `y_stern`, $`y_t^{\ast}`$ | Foreign demand/output | (F18) |
| Endogenous | `shock_eta`, $`\eta_t`$ | Stock-price-gap state | (F19) |
| Exogenous | `epsa`, $`\varepsilon_t^a`$ | Productivity innovation | (F17) |
| Exogenous | `epsy`, $`\varepsilon_t^{y^{\ast}}`$ | Foreign-demand innovation | (F18) |
| Exogenous | `epseta`, $`\varepsilon_t^{\eta}`$ | Stock-price-gap innovation | (F19) |
| Exogenous | `mu_p`, $`\varepsilon_t^{\mu}`$ | Cost-push innovation | (F9), (F20) |
| Parameter | $`\gamma`$ | Death probability / wealth-effect parameter | (F5)-(F8) |
| Parameter | $`\alpha`$ | Openness / import share | (F11), (F12), (F14), (F16) |
| Parameter | $`\theta`$ | Calvo non-reoptimization probability | (F9) |
| Parameter | $`\tau`$ | Backward-looking price-setting share | (F9) |
| Parameter | $`\beta`$, $`\tilde\beta`$ | Household discount factor / steady-state discount factor | (F2), (F8), (F9) |
| Parameter | $`\epsilon`$ | Stock-return risk premium covariance | (F8) |
| Parameter | $`\Psi`$ | Wealth-effect coefficient | (F7), (F16) |
| Parameter | $`\Gamma_0,\Gamma_a,\Gamma_{y^{\ast}},\Theta`$ | Open-economy composite coefficients | (F7), (F12), (F16) |
| Parameter | $`\lambda_q,\kappa_{\alpha},\phi`$ | Stock-price and Phillips-curve slopes | (F8), (F9) |
| Parameter | $`\phi_{\pi},\phi_x`$ | Interest-rate response coefficients | (F10) |
| Parameter | $`\rho_a,\rho_{y^{\ast}},\rho_{\eta}`$ | Shock persistence parameters | (F16)-(F19) |

Equation count: 20 numbered conditions, (F1)-(F20). Runtime validation: not performed.
