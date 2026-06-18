# NK_GMAS25ppi -- Derivation (Optimization Problems + Equilibrium Conditions)

> Status: `needs_review`. This first-pass archive entry is extracted from the MinerU Markdown source for Gali and Monacelli (2005). The paper develops nonlinear household/firm primitives and then works with a log-linear small-open-economy New Keynesian system. `NK_GMAS25ppi` is treated here as the producer-price/domestic-inflation Taylor-rule variant. Runtime validation was not performed.

Source: Jordi Gali and Tommaso Monacelli (2005), "Monetary policy and exchange rate volatility in a small open economy," *Review of Economic Studies* 72, 707-734. DOI: `10.1111/j.1467-937x.2005.00349.x`.

## 1. Model Overview

- **Model**: `NK_GMAS25ppi`, a small open economy Calvo sticky-price model with complete international financial markets and an interest-rate rule that responds to producer-price/domestic inflation.
- **Agents**: a representative household, monopolistically competitive domestic firms, a continuum of foreign economies taken as exogenous by the home economy, and a monetary authority.
- **Goods structure**: domestic and imported consumption bundles are CES aggregates. Openness is indexed by $`\alpha`$; $`\eta`$ governs substitution between home and foreign bundles; $`\gamma`$ governs substitution across foreign origins; $`\epsilon`$ governs substitution across varieties.
- **Policy variant**: the model-archive entry is for the PPI/domestic-inflation Taylor rule, $`r_t=\rho+\phi_\pi\pi_{H,t}`$, not the CPI rule or exchange-rate peg variants.
- **Form**: log-linear `model(linear)` equilibrium around a symmetric zero-inflation steady state with PPP. Lowercase variables are logs or log deviations; hatted marginal cost is a deviation from its steady-state markup value.
- **Runtime validation**: not performed. No Dynare residual, steady-state, BK, or IRF check was run.

## 2. Optimization Problems

### 2.1 Household

The representative home household maximizes:

```math
E_0\sum_{t=0}^{\infty}\beta^t U(C_t,N_t),
\qquad
U(C_t,N_t)=\frac{C_t^{1-\sigma}}{1-\sigma}-\frac{N_t^{1+\varphi}}{1+\varphi}.
```

The composite consumption bundle is:

```math
C_t=\left[(1-\alpha)^{1/\eta}C_{H,t}^{(\eta-1)/\eta}
+\alpha^{1/\eta}C_{F,t}^{(\eta-1)/\eta}\right]^{\eta/(\eta-1)}.
```

Domestic and imported variety bundles are CES aggregates:

```math
C_{H,t}=\left(\int_0^1 C_{H,t}(j)^{(\epsilon-1)/\epsilon}dj\right)^{\epsilon/(\epsilon-1)},
\qquad
C_{i,t}=\left(\int_0^1 C_{i,t}(j)^{(\epsilon-1)/\epsilon}dj\right)^{\epsilon/(\epsilon-1)}.
```

Imported consumption is aggregated across countries:

```math
C_{F,t}=\left(\int_0^1 C_{i,t}^{(\gamma-1)/\gamma}di\right)^{\gamma/(\gamma-1)}.
```

The nominal budget constraint after expenditure aggregation is:

```math
P_tC_t+E_t\{Q_{t,t+1}D_{t+1}\}\leq D_t+W_tN_t+T_t.
```

### 2.2 Expenditure Minimization

Cost minimization within domestic and foreign variety bundles gives:

```math
C_{H,t}(j)=\left(\frac{P_{H,t}(j)}{P_{H,t}}\right)^{-\epsilon}C_{H,t},
\qquad
C_{i,t}(j)=\left(\frac{P_{i,t}(j)}{P_{i,t}}\right)^{-\epsilon}C_{i,t}.
```

Allocation across foreign countries and between home and foreign bundles gives:

```math
C_{i,t}=\left(\frac{P_{i,t}}{P_{F,t}}\right)^{-\gamma}C_{F,t},
```

```math
C_{H,t}=(1-\alpha)\left(\frac{P_{H,t}}{P_t}\right)^{-\eta}C_t,
\qquad
C_{F,t}=\alpha\left(\frac{P_{F,t}}{P_t}\right)^{-\eta}C_t.
```

The CPI is:

```math
P_t=\left[(1-\alpha)P_{H,t}^{1-\eta}+\alpha P_{F,t}^{1-\eta}\right]^{1/(1-\eta)}.
```

### 2.3 Domestic Firms

A domestic firm $`j`$ produces with linear technology:

```math
Y_t(j)=A_tN_t(j),
\qquad
a_t=\rho_a a_{t-1}+\varepsilon_t^a.
```

Nominal marginal cost is $`MC_t^n=(1-\tau)W_t/A_t`$. Real marginal cost in domestic-good units is:

```math
mc_t=-\nu+w_t-p_{H,t}-a_t,
\qquad
\nu\equiv-\log(1-\tau).
```

Under Calvo pricing, a firm that can reset in period $`t`$ chooses $`\overline{P}_{H,t}`$ to maximize the discounted value of profits while the price remains effective:

```math
\max_{\overline{P}_{H,t}}\sum_{k=0}^{\infty}\theta^k
E_t\left\{Q_{t,t+k}Y_{t+k}\left(\overline{P}_{H,t}-MC_{t+k}^n\right)\right\},
```

subject to the demand sequence:

```math
Y_{t+k}(j)\leq
\left(\frac{\overline{P}_{H,t}}{P_{H,t+k}}\right)^{-\epsilon}
\left(C_{H,t+k}+\int_0^1 C_{H,t+k}^i\,di\right).
```

### 2.4 Monetary Authority

For this `NK_GMAS25ppi` archive entry, the simple policy rule is the domestic-inflation/PPI Taylor rule:

```math
r_t=\rho+\phi_\pi\pi_{H,t}.
```

The paper also analyzes CPI inflation targeting and an exchange-rate peg, but those are separate variants and are not used as the closure for this entry.

## 3. First-Order Conditions

- **(F1) Intratemporal household labor condition**:

```math
C_t^{\sigma}N_t^{\varphi}=\frac{W_t}{P_t}.
```

- **(F2) Nominal stochastic discount factor**:

```math
\beta\left(\frac{C_{t+1}}{C_t}\right)^{-\sigma}
\left(\frac{P_t}{P_{t+1}}\right)=Q_{t,t+1}.
```

- **(F3) Household Euler equation**:

```math
\beta R_tE_t\left[
\left(\frac{C_{t+1}}{C_t}\right)^{-\sigma}
\left(\frac{P_t}{P_{t+1}}\right)
\right]=1.
```

- **(F4) Log-linear consumption Euler equation**:

```math
c_t=E_t c_{t+1}-\frac{1}{\sigma}
\left(r_t-E_t\pi_{t+1}-\rho\right).
```

- **(F5) Complete-markets international risk sharing**:

```math
C_t=C_t^i\mathcal{Q}_{i,t}^{1/\sigma}
\quad\Rightarrow\quad
c_t=c_t^{\ast}+\frac{1}{\sigma}q_t.
```

- **(F6) Risk-sharing relation in terms of the effective terms of trade**:

```math
c_t=c_t^{\ast}+\frac{1-\alpha}{\sigma}s_t.
```

- **(F7) Uncovered interest parity**:

```math
r_t-r_t^{\ast}=E_t\Delta e_{t+1}.
```

- **(F8) Terms-of-trade difference equation**:

```math
s_t=(r_t^{\ast}-E_t\pi_{t+1}^{\ast})-(r_t-E_t\pi_{H,t+1})+E_ts_{t+1}.
```

- **(F9) Calvo optimal reset-price condition, log-linear form**:

```math
\overline{p}_{H,t}=\mu+(1-\beta\theta)
\sum_{k=0}^{\infty}(\beta\theta)^kE_t\{mc_{t+k}+p_{H,t+k}\},
\qquad
\mu\equiv\log\left(\frac{\epsilon}{\epsilon-1}\right).
```

- **(F10) Domestic Phillips curve in marginal-cost form**:

```math
\pi_{H,t}=\beta E_t\pi_{H,t+1}+\lambda\widehat{mc}_t,
\qquad
\lambda=\frac{(1-\beta\theta)(1-\theta)}{\theta}.
```

- **(F11) Real marginal cost as a function of output, world output, and productivity**:

```math
mc_t=-\nu+(\sigma_\alpha+\varphi)y_t
+(\sigma-\sigma_\alpha)y_t^{\ast}-(1+\varphi)a_t.
```

- **(F12) Domestic natural output**:

```math
\overline{y}_t=\Omega+\Gamma a_t+\alpha\Psi y_t^{\ast},
```

where:

```math
\Omega=\frac{\nu-\mu}{\sigma_\alpha+\varphi},
\qquad
\Gamma=\frac{1+\varphi}{\sigma_\alpha+\varphi},
\qquad
\Psi=-\frac{\Theta\sigma_\alpha}{\sigma_\alpha+\varphi}.
```

- **(F13) Output gap definition**:

```math
x_t=y_t-\overline{y}_t.
```

- **(F14) Marginal cost and output-gap relation**:

```math
\widehat{mc}_t=(\sigma_\alpha+\varphi)x_t.
```

- **(F15) Small-open-economy New Keynesian Phillips curve**:

```math
\pi_{H,t}=\beta E_t\pi_{H,t+1}+\kappa_\alpha x_t,
\qquad
\kappa_\alpha=\lambda(\sigma_\alpha+\varphi).
```

- **(F16) Natural real interest rate**:

```math
\overline{rr}_t=\rho-\sigma_\alpha\Gamma(1-\rho_a)a_t
+\alpha\sigma_\alpha(\Theta+\Psi)E_t\Delta y_{t+1}^{\ast}.
```

- **(F17) Dynamic IS equation in output-gap form**:

```math
x_t=E_tx_{t+1}
-\frac{1}{\sigma_\alpha}
\left(r_t-E_t\pi_{H,t+1}-\overline{rr}_t\right).
```

- **(F18) PPI/domestic-inflation Taylor rule for `NK_GMAS25ppi`**:

```math
r_t=\rho+\phi_\pi\pi_{H,t}.
```

## 4. Market Clearing & Identities

- **(F19) Effective terms of trade**:

```math
s_t=p_{F,t}-p_{H,t}.
```

- **(F20) CPI/domestic-price identity**:

```math
p_t=p_{H,t}+\alpha s_t.
```

- **(F21) CPI inflation identity**:

```math
\pi_t=\pi_{H,t}+\alpha\Delta s_t.
```

- **(F22) Nominal exchange-rate and terms-of-trade identity**:

```math
s_t=e_t+p_t^{\ast}-p_{H,t}.
```

- **(F23) Real exchange-rate relation**:

```math
q_t=(1-\alpha)s_t.
```

- **(F24) Aggregate production, first-order approximation**:

```math
y_t=a_t+n_t.
```

- **(F25) Goods-market clearing / output-demand relation**:

```math
y_t=c_t+\frac{\alpha\omega}{\sigma}s_t.
```

- **(F26) World resource condition**:

```math
y_t^{\ast}=c_t^{\ast}.
```

- **(F27) Terms of trade and relative output**:

```math
y_t=y_t^{\ast}+\frac{1}{\sigma_\alpha}s_t,
\qquad
\sigma_\alpha=\frac{\sigma}{(1-\alpha)+\alpha\omega}.
```

- **(F28) Net exports relation**:

```math
nx_t=\alpha\left(\frac{\omega}{\sigma}-1\right)s_t.
```

- **(F29) Auxiliary open-economy parameter**:

```math
\omega=\sigma\gamma+(1-\alpha)(\sigma\eta-1),
\qquad
\Theta=\omega-1.
```

## 5. Exogenous Processes

- **(F30) Domestic technology process**:

```math
a_t=\rho_a a_{t-1}+\varepsilon_t^a.
```

- **(F31) World output process used in calibration**:

```math
y_t^{\ast}=\rho_{y^{\ast}}y_{t-1}^{\ast}+\varepsilon_t^{\ast}.
```

- **(F32) Innovation correlation used in calibration**:

```math
\operatorname{corr}(\varepsilon_t^a,\varepsilon_t^{\ast})=0.3.
```

The calibrated example in the paper estimates $`\rho_a\approx0.66`$ and $`\rho_{y^{\ast}}\approx0.86`$ from Canadian productivity and U.S. GDP data. These empirical values are recorded as source context, not as runtime validation.

## 6. Steady-State Solution

The archive entry is a log-linear `model(linear)` representation. The deterministic symmetric steady state is normalized so that all logged deviations are zero:

```math
a=y^{\ast}=x=\pi_H=\pi=s=e=q=nx=0.
```

The symmetric steady state has PPP and unit terms of trade:

```math
\mathcal{S}=1,
\qquad
\mathcal{Q}=1,
\qquad
C=C^{\ast}=Y=Y^{\ast}.
```

Domestic inflation, CPI inflation, and expected depreciation are zero in steady state:

```math
\pi_H=\pi=\Delta e=0.
```

The gross discount relation implies the steady nominal/real rate in log terms:

```math
\rho=\beta^{-1}-1
```

as stated in the paper's notation. In a Dynare `model(linear)` implementation, the steady state for the logged deviation of $`r_t`$ is zero if $`r_t`$ is measured relative to $`\rho`$.

For the welfare/optimal-policy special case, the paper imposes:

```math
\sigma=\eta=\gamma=1.
```

With the employment subsidy chosen to offset monopoly and terms-of-trade distortions:

```math
(1-\tau)(1-\alpha)=1-\frac{1}{\epsilon},
```

the flexible-price allocation is efficient, and strict domestic-price stability implies:

```math
x_t=0,
\qquad
\pi_{H,t}=0.
```

This steady-state and optimal-policy discussion is source-extracted. No numerical steady-state file was built or checked.

## 7. Timing & Form Conventions

- **Timing**: the reduced model has no capital stock or other predetermined private stock. The state variables are exogenous $`a_t`$, $`y_t^{\ast}`$, and price-level/terms-of-trade objects when a level representation is retained.
- **Information set**: expectations are $`E_t`$ conditional on period-$`t`$ information. Forward-looking terms include $`E_t\pi_{H,t+1}`$, $`E_tx_{t+1}`$, and $`E_t\Delta y_{t+1}^{\ast}`$.
- **Inflation measure**: `NK_GMAS25ppi` uses producer-price/domestic inflation $`\pi_{H,t}`$ in the Taylor rule. CPI inflation is retained as an identity, $`\pi_t=\pi_{H,t}+\alpha\Delta s_t`$, but is not the policy feedback variable for this variant.
- **Form**: log-linear `model(linear)` around a symmetric zero-inflation steady state. Lowercase variables denote logs or log deviations; $`\widehat{mc}_t`$ is real marginal cost relative to its steady-state value $`-\mu`$.
- **No raw PDF body review**: the raw PDF path was checked for existence and hashed; the body was not opened because the Markdown source was sufficient for this first-pass extraction.

## 8. Variable & Parameter Reference Table

### Endogenous variables

| Symbol | Meaning | Main determining equation |
|---|---|---|
| $`x_t`$ | domestic output gap | (F17) |
| $`\pi_{H,t}`$ | domestic/PPI inflation | (F15) |
| $`r_t`$ | domestic short-term nominal interest rate in log terms | (F18) |
| $`y_t`$ | domestic output | (F27) |
| $`\overline{y}_t`$ | natural output | (F12) |
| $`\overline{rr}_t`$ | natural real interest rate | (F16) |
| $`s_t`$ | effective terms of trade | (F27) |
| $`p_t`$ | CPI level | (F20) |
| $`p_{H,t}`$ | domestic producer-price level | (F22) |
| $`\pi_t`$ | CPI inflation | (F21) |
| $`e_t`$ | nominal effective exchange rate | (F22) |
| $`q_t`$ | real effective exchange rate | (F23) |
| $`c_t`$ | domestic consumption | (F6), (F25) |
| $`n_t`$ | labor input | (F24) |
| $`mc_t,\widehat{mc}_t`$ | real marginal cost and its deviation | (F11), (F14) |
| $`nx_t`$ | net exports share approximation | (F28) |

### Exogenous variables

| Symbol | Meaning | Process |
|---|---|---|
| $`a_t`$ | domestic technology | (F30) |
| $`y_t^{\ast}`$ | world output | (F31) |
| $`\varepsilon_t^a`$ | domestic technology innovation | (F30) |
| $`\varepsilon_t^{\ast}`$ | world-output innovation | (F31) |

### Parameters

| Symbol | Meaning |
|---|---|
| $`\beta`$ | household discount factor |
| $`\sigma`$ | inverse intertemporal elasticity/risk-aversion parameter |
| $`\varphi`$ | inverse labor-supply elasticity |
| $`\alpha`$ | openness/import-share parameter |
| $`\eta`$ | elasticity between home and foreign bundles |
| $`\gamma`$ | elasticity across foreign-country bundles |
| $`\epsilon`$ | elasticity across differentiated varieties |
| $`\theta`$ | Calvo non-reset probability |
| $`\lambda`$ | Phillips-curve marginal-cost slope |
| $`\kappa_\alpha`$ | open-economy Phillips-curve output-gap slope |
| $`\rho`$ | steady-state real-rate term, $`\beta^{-1}-1`$ |
| $`\rho_a`$ | domestic technology persistence |
| $`\rho_{y^{\ast}}`$ | world-output persistence |
| $`\phi_\pi`$ | domestic-inflation Taylor-rule coefficient |
| $`\tau`$ | employment subsidy |
| $`\mu`$ | log desired markup, $`\log(\epsilon/(\epsilon-1))`$ |
| $`\nu`$ | subsidy term, $`-\log(1-\tau)`$ |
| $`\omega,\Theta,\sigma_\alpha,\Omega,\Gamma,\Psi`$ | composite open-economy coefficients defined in (F12), (F27), and (F29) |

Formula count: F1-F32. Runtime validation: not performed.
