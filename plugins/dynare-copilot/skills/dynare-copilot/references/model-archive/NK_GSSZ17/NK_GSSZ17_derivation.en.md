# NK_GSSZ17 - Inflation Dynamics during the Financial Crisis

Provenance: `NK_GSSZ17`, Gilchrist, Schoenle, Sim, and Zakrajsek (2017), "Inflation Dynamics during the Financial Crisis," American Economic Review 107(3): 785-823, DOI `10.1257/aer.20150248`. Source Markdown: `raw/mmb_mineru/runs/nk_gssz17__inflation_dynamics_during_the_financial_crisis__85a7350a/full.md`. Raw PDF path checked: `raw/mmb_papers/Inflation Dynamics during the Financial Crisis.pdf`. MinerU run id: `85a7350a-a6d9-40e9-8065-b8a924aa1887`.

This is a first-pass archive derivation. Runtime validation was not performed. Several paper formulas are taken from MinerU OCR and marked `needs_review` where notation was visibly damaged.

## 1. Model Overview

- **Model**: New Keynesian customer-market model with financial frictions, deep habits, Rotemberg price adjustment costs, and costly external equity finance.
- **Purpose**: Explain why financially weak firms can raise prices in a crisis while financially strong firms cut prices, and why customer markets plus financial frictions attenuate disinflation.
- **Agents and blocks**: households with good-specific external habits, monopolistically competitive firms that choose prices before idiosyncratic cost shocks are realized, costly equity issuance, aggregate productivity, demand, financial, and monetary-policy shocks, and a Taylor-type monetary authority.
- **Form**: the paper derives a nonlinear model and then uses local/log-linear equilibrium objects such as the Phillips curve. The Rep-MMB implementation cross-check is a nonlinear Dynare `model` block solved at first order, not `model(linear)`.
- **Baseline simulation focus**: homogeneous-firm model with financial frictions and nominal rigidities; the paper also extends to heterogeneous operating costs.

## 2. Optimization Problems

### 2.1 Households

Household $`j`$ maximizes expected discounted utility over the habit-adjusted consumption bundle and labor:

```math
E_t \sum_{s=0}^{\infty} \beta^s U(x_{t+s}^j-\psi_{t+s},h_{t+s}^j),
\qquad 0<\beta<1.
\tag{F1} % (F1)
```

The demand shock $`\psi_t`$ shifts current marginal utility of consumption. The good-specific consumption/habit aggregator is:

```math
x_t^j =
\left[
\int_0^1
\left(\frac{c_{it}^j}{s_{i,t-1}^{\theta}}\right)^{1-\frac{1}{\eta}} di
\right]^{\frac{1}{1-\frac{1}{\eta}}},
\qquad \theta<0,\ \eta>0.
\tag{F2} % (F2)
```

The external good-specific habit stock evolves as:

```math
s_{it}=\rho s_{i,t-1}+(1-\rho)c_{it},
\qquad 0<\rho<1.
\tag{F3} % (F3)
```

Cost minimization over differentiated goods gives demand for variety $`i`$:

```math
c_{it}^j =
\left(\frac{p_{it}}{\tilde p_t}\right)^{-\eta}
s_{i,t-1}^{\theta(1-\eta)}x_t^j.
\tag{F4} % (F4)
```

The externality-adjusted composite price index is:

```math
\tilde p_t =
\left[
\int_0^1
\left(p_{it}s_{i,t-1}^{\theta}\right)^{1-\eta}di
\right]^{\frac{1}{1-\eta}}.
\tag{F5} % (F5)
```

### 2.2 Firms

Firm $`i`$ produces a differentiated good with labor, aggregate technology, idiosyncratic cost risk, and fixed operating costs:

```math
y_{it}=\left(\frac{A_t}{a_{it}}h_{it}\right)^{\alpha}-\phi,
\qquad 0<\alpha\le 1,\ \phi>0.
\tag{F6} % (F6)
```

Firms maximize the expected present value of real dividends:

```math
E_0\sum_{t=0}^{\infty}m_{0,t}d_{it}.
\tag{F7} % (F7)
```

The flow-of-funds constraint with per-unit equity dilution cost $`\varphi_t`$ is:

```math
0=p_{it}c_{it}-w_t h_{it}-d_{it}
+\varphi_t\min\{0,d_{it}\}.
\tag{F8} % (F8)
```

The firm chooses dividends, labor, consumption/sales, price, and habit stock subject to production, flow of funds, demand, and habit accumulation. A compact Lagrangian representation is:

```math
\begin{aligned}
\mathcal L
=E_0\sum_{t=0}^{\infty}m_{0,t}\{&
d_{it}
+\kappa_{it}[(A_t h_{it}/a_{it})^{\alpha}-\phi-c_{it}]\\
&+\xi_{it}[p_{it}c_{it}-w_t h_{it}-d_{it}+\varphi_t\min\{0,d_{it}\}]\\
&+\nu_{it}[(p_{it}/\tilde p_t)^{-\eta}s_{i,t-1}^{\theta(1-\eta)}x_t-c_{it}]\\
&+\lambda_{it}[\rho s_{i,t-1}+(1-\rho)c_{it}-s_{it}]\}.
\end{aligned}
\tag{F9} % (F9)
```

### 2.3 Monetary Authority

The monetary authority sets the nominal interest rate with smoothing and responses to inflation and output gaps:

```math
r_t=(1+r_{t-1})^{\tau_r}
\left[
(1+\bar r)
\left(\frac{\pi_t}{\pi^{\ast}}\right)^{\tau_\pi}
\left(\frac{y_t}{y_t^{\ast}}\right)^{\tau_y}
\right]^{1-\tau_r}-1.
\tag{F10} % (F10)
```

`needs_review`: The paper's printed equation (29) appears multiplicative inside the bracket, while the MinerU OCR joined terms with line breaks. The Rep-MMB implementation uses a multiplicative gross-rate rule.

## 3. First-Order Conditions

### 3.1 Firm Conditions

The shadow value of internal funds follows from the dividend/equity issuance choice:

```math
\xi_{it}=
\begin{cases}
1, & d_{it}\ge 0,\\
1/(1-\varphi_t), & d_{it}<0.
\end{cases}
\tag{F11} % (F11)
```

The labor/production condition is:

```math
\kappa_{it}
=\xi_{it}a_{it}
\left(\frac{w_t}{\alpha A_t}\right)
(c_{it}+\phi)^{\frac{1-\alpha}{\alpha}}.
\tag{F12} % (F12)
```

The expected marginal value of sales satisfies:

```math
E_t^a[\nu_{it}]
=E_t^a[\xi_{it}]p_{it}
-E_t^a[\kappa_{it}]
+(1-\rho)E_t^a[\lambda_{it}].
\tag{F13} % (F13)
```

The expected value of the habit/customer base satisfies:

```math
E_t^a[\lambda_{it}]
=\rho E_t^a[m_{t,t+1}\lambda_{i,t+1}]
+\theta(1-\eta)E_t\left[
m_{t,t+1}E_{t+1}^a[\nu_{i,t+1}]
\left(\frac{c_{i,t+1}}{s_{it}}\right)
\right].
\tag{F14} % (F14)
```

The optimal relative price condition is:

```math
0=E_t^a[\xi_{it}]
-\eta\frac{E_t^a[\nu_{it}]}{p_{it}}.
\tag{F15} % (F15)
```

### 3.2 Financing Trigger and Markup

The equity issuance trigger is:

```math
a_t^E=
\frac{c_t}{(c_t+\phi)^{1/\alpha}}\frac{A_t}{w_t}.
\tag{F16} % (F16)
```

The realized shadow value of internal funds can be written against that trigger:

```math
\xi_{it}=
\begin{cases}
1, & a_{it}\le a_t^E,\\
1/(1-\varphi_t), & a_{it}>a_t^E.
\end{cases}
\tag{F17} % (F17)
```

With $`z_t^E=\sigma^{-1}(\log a_t^E+0.5\sigma^2)`$, the expected shadow value is:

```math
E_t^a[\xi_{it}]
=1+\left[\frac{\varphi_t}{1-\varphi_t}\right]
[1-\Phi(z_t^E)]\ge 1.
\tag{F18} % (F18)
```

In the no-customer-habit case, the pricing rule is:

```math
p_{it}
=\frac{\eta}{\eta-1}
\frac{E_t^a[\xi_{it}a_{it}]}{E_t^a[\xi_{it}]}
\left[
\frac{w_t}{\alpha A_t}(c_{it}+\phi)^{\frac{1-\alpha}{\alpha}}
\right].
\tag{F19} % (F19)
```

The financially adjusted markup is:

```math
\tilde\mu_t
=
\frac{1}{
\frac{E_t^a[\xi_{it}a_{it}]}{E_t^a[\xi_{it}]}
\left[
\frac{w_t}{\alpha A_t}(c_{it}+\phi)^{\frac{1-\alpha}{\alpha}}
\right]
}.
\tag{F20} % (F20)
```

With customer markets, the value of marginal sales relative to internal funds satisfies:

```math
\frac{E_t^a[\nu_{it}]}{E_t^a[\xi_{it}]}
=
\frac{\tilde\mu_t-1}{\tilde\mu_t}
+(1-\rho)\frac{E_t^a[\lambda_{it}]}{E_t^a[\xi_{it}]}.
\tag{F21} % (F21)
```

Let $`g_t\equiv c_t/s_{t-1}=(s_t/s_{t-1}-\rho)/(1-\rho)`$ and define the growth-adjusted discount factor:

```math
\tilde\beta_{t,s+1}
\equiv
m_{s,s+1}g_{s+1}
\prod_{j=1}^{s-t}
[\rho+\theta(1-\eta)(1-\rho)g_{t+j}]m_{t+j-1,t+j}.
\tag{F22} % (F22)
```

The forward solution for marginal sales is:

```math
\frac{E_t^a[\nu_{it}]}{E_t^a[\xi_{it}]}
=
\frac{\tilde\mu_t-1}{\tilde\mu_t}
+\chi E_t\left[
\sum_{s=t+1}^{\infty}
\tilde\beta_{t,s}
\frac{E_s^a[\xi_{is}]}{E_t^a[\xi_{it}]}
\left(\frac{\tilde\mu_s-1}{\tilde\mu_s}\right)
\right],
\quad
\chi=(1-\rho)\theta(1-\eta)>0.
\tag{F23} % (F23)
```

`needs_review`: The paper's equation (23) uses the same symbol $`\chi`$ for the customer-market coefficient even though the implementation example does not use `chi`; the OCR was clear enough for structure but should be checked against the journal PDF before a final entry.

### 3.3 Nominal Rigidities

Rotemberg price adjustment costs are:

```math
\frac{\gamma_p}{2}
\left(\frac{P_{it}}{P_{i,t-1}}-\bar\pi\right)^2c_t
=
\frac{\gamma_p}{2}
\left(\pi_t\frac{p_{it}}{p_{i,t-1}}-\bar\pi\right)^2c_t.
\tag{F24} % (F24)
```

The local inflation condition is:

```math
\hat\pi_t
=
\frac{1}{\gamma_p}(\hat\xi_t-\hat\nu_t)
+\beta E_t[\hat\pi_{t+1}].
\tag{F25} % (F25)
```

The paper's log-linear Phillips curve is:

```math
\begin{aligned}
\hat\pi_t
=&-\frac{\omega(\eta-1)}{\gamma_p}
\left[
\hat\mu_t
+E_t\sum_{s=t}^{\infty}
\chi\tilde\delta^{s-t+1}\hat\mu_{s+1}
\right]
+\beta E_t[\hat\pi_{t+1}]\\
&+\frac{1}{\gamma_p}[\eta-\omega(\eta-1)]
E_t\sum_{s=t}^{\infty}
\chi\tilde\delta^{s-t+1}
\left[
(\hat\xi_t-\hat\xi_{s+1})-\hat\beta_{t,s+1}
\right].
\end{aligned}
\tag{F26} % (F26)
```

where $`\omega=1-\beta\theta(1-\rho)/(1-\rho\beta)`$ and $`\tilde\delta=\beta[\rho+\theta(1-\eta)(1-\rho)]`$.

`needs_review`: This entry records the OCR formula as a structural Phillips curve, but detailed signs and hats should be source-level checked before review status is upgraded.

## 4. Market Clearing & Identities

The stochastic discount factor implied by household consumption-savings is:

```math
m_{t,t+1}
=
\beta
\frac{U_x(x_{t+1}-\psi_{t+1},h_{t+1})}
{U_x(x_t-\psi_t,h_t)}
\frac{s_{t-1}^{\theta}}{s_t^{\theta}}.
\tag{F27} % (F27)
```

The Fisher equation is:

```math
1=E_t\left[
m_{t,t+1}
\left(\frac{1+r_t}{1+\pi_{t+1}}\right)
\right].
\tag{F28} % (F28)
```

The household labor-consumption efficiency condition is:

```math
\frac{w_t}{\tilde p_t}
=
-\frac{U_h(x_t-\psi_t,h_t)}{U_x(x_t-\psi_t,h_t)}.
\tag{F29} % (F29)
```

The aggregate habit stock is:

```math
s_t=\rho s_{t-1}+(1-\rho)c_t.
\tag{F30} % (F30)
```

The aggregate consumption index relation is:

```math
x_t=\frac{c_t}{s_t^\theta}.
\tag{F31} % (F31)
```

The labor demand/production relation in the homogeneous model is:

```math
h_t=
\left[
\frac{c_t+\phi}{\exp[0.5\alpha(1+\alpha)\sigma^2]}
\right]^{1/\alpha}.
\tag{F32} % (F32)
```

For heterogeneous operating costs, the paper modifies production to:

```math
y_{it}=
\left(\frac{A_t}{a_{it}}h_{it}\right)^{\alpha}
-\phi_i.
\tag{F33} % (F33)
```

Aggregate inflation with firm categories $`k=1,\ldots,N`$ is:

```math
\pi_t=
\left[
\sum_{k=1}^N
\Xi_k(p_{k,t-1}\pi_{kt})^{1-\eta}
\right]^{\frac{1}{1-\eta}}.
\tag{F34} % (F34)
```

## 5. Exogenous Processes

The aggregate technology shock is treated as persistent in the implementation cross-check:

```math
\log A_t=\rho_A\log A_{t-1}+\sigma_A\varepsilon^A_t.
\tag{F35} % (F35)
```

The demand shock is persistent:

```math
\psi_t=\rho_D\psi_{t-1}+\sigma_D\varepsilon^D_t.
\tag{F36} % (F36)
```

The financial shock scales equity dilution costs:

```math
\varphi_t=\bar\varphi f_t,
\qquad
\log f_t=0.90\log f_{t-1}+\varepsilon^f_t.
\tag{F37} % (F37)
```

The implementation cross-check also includes a monetary-policy innovation:

```math
R_t=\mathcal R(R_{t-1},\pi_t,\pi_t^f,y_t/y_t^{ss})\exp(\sigma_R\varepsilon^R_t).
\tag{F38} % (F38)
```

`needs_review`: The paper-side source states the Taylor rule and financial shock clearly, but exact implementation notation differs (`R`, `F`, `D`, `eR`, `eF`, `eD`).

## 6. Steady-State Solution

The paper uses a quarterly calibration and local simulations around a symmetric equilibrium. The source does not provide a full `steady_state_model`; the following steady-state restrictions are source-derived first-pass conditions, with implementation details deferred.

1. Set innovation means to zero: $`\varepsilon^A=\varepsilon^D=\varepsilon^f=\varepsilon^R=0`$.
2. Normalize the symmetric equilibrium with $`p_i=1`$, $`c_i=c`$, $`s_i=s`$, and common expected shadow values across ex ante identical firms.
3. From habit accumulation, $`\bar s=\bar c`$ when $`\bar c`$ is constant and $`0<\rho<1`$.
4. With zero steady inflation, $`\bar\pi=\pi^{\ast}`$ and Rotemberg adjustment costs vanish.
5. The household SDF satisfies the steady Fisher relation $`1=\bar m(1+\bar r)/(1+\bar\pi)`$.
6. The financing trigger is $`\bar a^E=\bar c(\bar A/\bar w)/(\bar c+\phi)^{1/\alpha}`$.
7. The expected internal-funds wedge is $`\bar\xi=1+[\bar\varphi/(1-\bar\varphi)][1-\Phi(\bar z^E)]`$ with $`\bar z^E=\sigma^{-1}(\log\bar a^E+0.5\sigma^2)`$.
8. The financially adjusted markup $`\bar{\tilde\mu}`$ follows (F20); with customer markets it is tied to the marginal-sales value by (F21)-(F23).
9. Baseline calibration values stated in the source include $`\beta=0.99`$, $`\theta=-0.8`$, $`\rho=0.95`$, CRRA parameter $`1`$, labor-supply elasticity $`5`$, $`\eta=2`$, $`\alpha=0.8`$, $`\phi=0.3`$, $`\bar\varphi=0.3`$, $`\rho_f=0.9`$, $`\rho_D=0.9`$, $`\sigma=0.05`$, $`\gamma_p=10`$, $`\gamma_w=30`$, $`\tau_r=0.75`$, and $`\tau_\pi=1.5`$.

`needs_review`: The Rep-MMB example uses related but not identical calibration names and values (`beta=0.985`, `theta=-0.75`, `rho_s=0.95`, `alpha=0.85`, `varrhobar=0.5`). These differences were recorded as implementation cross-check evidence, not paper-side calibration.

## 7. Timing & Form Conventions

- Firms choose prices and production plans after aggregate information is observed but before idiosyncratic cost shocks are realized.
- Labor hiring, dividends, and equity issuance are realized after the idiosyncratic cost shock.
- The customer base/habit stock is predetermined: demand for $`c_{it}`$ depends on $`s_{i,t-1}`$, and $`s_{it}`$ evolves from current consumption.
- Financial frictions enter through the current equity dilution cost $`\varphi_t`$ and the probability that realized profits are negative.
- The homogeneous model is symmetric in relative prices and scale ex ante, but idiosyncratic shocks generate nondegenerate labor and dividend outcomes.
- The paper contains both nonlinear equilibrium conditions and local/log-linear Phillips-curve expressions. The Rep-MMB implementation is a nonlinear `model` block run with first-order perturbation, not declared `model(linear)`.
- There is no physical capital stock in this model. The key predetermined stock is the customer habit stock $`s_{i,t-1}`$.
- Runtime validation was not performed.

## 8. Variable & Parameter Reference Table

### Endogenous Variables

| Symbol | Meaning | Main equation(s) |
|---|---|---|
| $`x_t`$ | habit-adjusted aggregate consumption bundle | (F2), (F31) |
| $`c_{it}, c_t`$ | variety and aggregate consumption/sales | (F4), (F30), (F31) |
| $`s_{it}, s_t`$ | good-specific/aggregate habit stock | (F3), (F30) |
| $`p_{it}`$ | relative price of variety $`i`$ | (F4), (F15), (F19) |
| $`\tilde p_t`$ | externality-adjusted price index | (F5), (F29) |
| $`y_{it}, y_t`$ | output | (F6), (F33) |
| $`h_{it}, h_t`$ | labor input | (F6), (F29), (F32) |
| $`d_{it}`$ | dividends or equity issuance when negative | (F8), (F11) |
| $`\xi_{it}`$ | shadow value of internal funds | (F11), (F17), (F18) |
| $`\kappa_{it}`$ | production multiplier / marginal cost object | (F12) |
| $`\nu_{it}`$ | marginal value of sales | (F13), (F21), (F23) |
| $`\lambda_{it}`$ | value of customer base/habit stock | (F14), (F21) |
| $`\tilde\mu_t`$ | financially adjusted markup | (F20), (F21), (F26) |
| $`\pi_t`$ | inflation | (F24), (F25), (F26), (F34) |
| $`m_{t,t+1}`$ | stochastic discount factor | (F22), (F27), (F28) |
| $`r_t`$ | nominal interest rate | (F10), (F28) |
| $`a_t^E, z_t^E`$ | financing trigger and standardized trigger | (F16), (F18) |
| $`\varphi_t, f_t`$ | equity dilution cost and financial shock state | (F37) |
| $`A_t`$ | aggregate productivity | (F6), (F35) |
| $`\psi_t`$ | demand shock | (F1), (F36) |

### Exogenous Shocks

| Symbol | Meaning | Main equation(s) |
|---|---|---|
| $`\varepsilon^A_t`$ | productivity innovation | (F35) |
| $`\varepsilon^D_t`$ | demand innovation | (F36) |
| $`\varepsilon^f_t`$ | financial shock innovation | (F37) |
| $`\varepsilon^R_t`$ | monetary-policy innovation in implementation | (F38) |

### Parameters

| Symbol | Meaning |
|---|---|
| $`\beta`$ | discount factor |
| $`\theta`$ | good-specific deep-habit parameter |
| $`\rho`$ | habit persistence |
| $`\eta`$ | elasticity of substitution across varieties |
| $`\alpha`$ | returns-to-scale/labor technology parameter |
| $`\phi`$ | fixed operating cost |
| $`\sigma`$ | idiosyncratic cost-shock volatility |
| $`\varphi_t,\bar\varphi`$ | equity dilution cost and steady/baseline value |
| $`\gamma_p`$ | Rotemberg price-adjustment cost |
| $`\gamma_w`$ | wage-adjustment cost in implementation |
| $`\tau_r,\tau_\pi,\tau_y`$ | Taylor-rule smoothing, inflation, and output-gap coefficients |
| $`\rho_A,\rho_D,\rho_f`$ | shock persistence parameters |
| $`\Xi_k,\phi_k`$ | mass and operating cost of firm category $`k`$ in heterogeneous extension |
