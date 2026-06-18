# US_FM95 -- Derivation (Source-Backed Model Archive Entry)

> Archive status: `needs_review`. This is a first-pass derivation from the MinerU Markdown source. Dynare was not run. The Rep-MMB `.mod` was used only as `implementation_cross_check`.

Source: Jeff Fuhrer and George Moore (1995), "Inflation Persistence," *The Quarterly Journal of Economics*, 110(1), 127-159. DOI: `10.2307/2118513`.

## 1. Model Overview

- **Model**: `US_FM95`, the Fuhrer-Moore relative contracting model of inflation persistence.
- **Core mechanism**: Four-quarter overlapping nominal contracts. Contract setters care about relative real contract prices, which makes inflation itself persistent rather than leaving persistence only to the output-gap process.
- **Agents/blocks**: Contract setters choose nominal contract prices; a price index aggregates active contracts; reduced-form output-gap and interest-rate equations provide the forecasting system; policy experiments use a nominal-output-growth reaction function.
- **Form**: Linear forward-looking model. The Rep-MMB implementation uses `model(linear)`.
- **Scope note**: The QJE source estimates standard and relative contracting specifications. `US_FM95` corresponds to the relative-contracting version used in Rep-MMB. The `.mod` adds an LWW policy rule and parameterization from later implementation sources; those items are recorded as cross-check evidence, not as paper-side source equations.

## 2. Optimization Problems

The paper does not derive the contract equation from a complete household or firm optimization problem. It specifies a behavioral wage/price-contracting rule. With prices assumed to be a fixed markup over wages, the archive writes the model directly as a system of contract-setting equilibrium conditions.

Contract setters negotiate nominal contract prices $`x_t`$ for contracts active over four quarters. In the relative specification, they choose the current real contract price $`x_t-p_t`$ to match the expected average real contract-price index over the contract life plus excess-demand pressure:

```math
x_t - p_t
= \sum_{i=0}^{3} f_i E_t\left(v_{t+i}+\gamma \tilde y_{t+i}\right)+\epsilon^p_t .
```

The implied object of choice is the current nominal contract price $`x_t`$, given the price index $`p_t`$, expected future real contract-price indexes, expected output gaps, and a contracting disturbance.

## 3. First-Order Conditions

- **(F1) Price index aggregation**:

```math
p_t=\sum_{i=0}^{3} f_i x_{t-i}.
```

- **(F2) Contract-weight schedule**:

```math
f_i=0.25+(1.5-i)s,\qquad 0<s\leq \frac{1}{6},\qquad i=0,\ldots,3.
```

- **(F3) Weight normalization and admissibility**:

```math
\sum_{i=0}^{3} f_i=1,\qquad f_i\geq 0.
```

- **(F4) Real contract-price index**:

```math
v_t=\sum_{i=0}^{3} f_i\left(x_{t-i}-p_{t-i}\right).
```

- **(F5) Relative contracting equation**:

```math
x_t-p_t
=\sum_{i=0}^{3} f_i E_t\left(v_{t+i}+\gamma \tilde y_{t+i}\right)+\epsilon^p_t.
```

- **(F6) Relative contracting equation after substituting the real contract-price index**:

```math
x_t-p_t
=\sum_{i=1}^{3}\beta_i\left(x_{t-i}-p_{t-i}\right)
+\sum_{i=1}^{3}\beta_i E_t\left(x_{t+i}-p_{t+i}\right)
+\gamma^{\ast}\sum_{i=0}^{3} f_i E_t\left(\tilde y_{t+i}\right)+\epsilon^p_t.
```

- **(F7) Overlap weights in the two-sided representation**:

```math
\beta_i=
\frac{\sum_j f_j f_{i+j}}{1-\sum_j f_j^2},
\qquad
\gamma^{\ast}=\frac{\gamma}{1-\sum_j f_j^2}.
```

- **(F8) Inflation definition**:

```math
\pi_t=p_t-p_{t-1}.
```

The paper's data table uses annualized quarterly inflation, $`\pi_t=4\Delta p_t`$. The Rep-MMB cross-check uses `infl = 4*(p-p(-1))`.

- **(F9) Contract-price inflation and price-index inflation**:

```math
\theta_t=x_t-x_{t-1},\qquad \pi_t=f(L)\theta_t,\qquad \theta_t=f(L)^{-1}\pi_t,
```

where $`f(L)=f_0+f_1L+f_2L^2+f_3L^3`$.

- **(F10) Distributed-lag map from inflation to real contract price**:

```math
x_t-p_t
=f_1\theta_t+f_2(\theta_t+\theta_{t-1})+f_3(\theta_t+\theta_{t-1}+\theta_{t-2})
=g(L)\theta_t
=g(L)f(L)^{-1}\pi_t.
```

- **(F11) Real contract-price index as a distributed lag of inflation**:

```math
v_t=g(L)\pi_t.
```

- **(F12) Two-sided Phillips-curve representation of the relative contracting model**:

```math
\pi_t=f(L)f(L^{-1})\left[\pi_t+\gamma g(L)^{-1}y_t\right].
```

- **(F13) Nested standard/relative contract-price index**:

```math
v_t=\sum_{i=0}^{3}f_i\left(x_{t-i}-\delta p_{t-i}\right),\qquad 0\leq \delta\leq 1.
```

- **(F14) Nested standard/relative contracting equation**:

```math
x_t-\delta p_t
=\sum_{i=0}^{3}f_iE_t\left(v_{t+i}+\gamma\tilde y_{t+i}\right)+\epsilon^p_t.
```

Here $`\delta=0`$ gives the standard nominal-contract model and $`\delta=1`$ gives the relative real-contract model. The paper reports that the data reject $`\delta=0`$ and do not reject $`\delta=1`$.

## 4. Market Clearing & Identities

- **(F15) Observable log price index identity**:

```math
p_t=f(L)x_t.
```

- **(F16) Real contract price definition**:

```math
q^x_t=x_t-p_t.
```

- **(F17) Nominal-output identity for the paper's policy experiments**:

```math
\Delta Y_t=\Delta y_t+\pi_t.
```

- **(F18) Nominal-output-growth policy experiment rule**:

```math
\Delta Y_t=\alpha_\pi(\pi_t-\bar\pi)+\alpha_y\tilde y_t.
```

The paper abstracts from the instrument channel that lets monetary policy control nominal output. In Rep-MMB, this policy-experiment rule is replaced by a separate LWW-style interest-rate rule; that replacement is implementation-specific.

## 5. Exogenous Processes

- **(F19) Contracting disturbance**:

```math
\epsilon^p_t\sim \text{i.i.d. }N(0,\sigma_p^2).
```

- **(F20) Reduced-form output-gap equation, represented generically**:

```math
\tilde y_t=a_0+a_1\tilde y_{t-1}+a_2\tilde y_{t-2}+a_\rho\rho_{t-1}+\epsilon^y_t.
```

This specific lag structure and naming are confirmed by the implementation cross-check. The QJE paper states that reduced-form equations for the bill rate and output gap from the VAR are combined with the contracting equations, but the compact coefficient form in (F20) is implementation-side and therefore `needs_review` as a paper-source equation.

- **(F21) General forward-looking model form from Appendix A**:

```math
\sum_{i=-\tau}^{0}H_i x_{t+i}+\sum_{i=1}^{\theta}H_iE_t(x_{t+i})=\epsilon_t.
```

- **(F22) Forecast equation used in the solution method**:

```math
\sum_{i=-\tau}^{\theta}H_iE_t(x_{t+k+i})=0,\qquad k>0.
```

- **(F23) VAR representation of the solution path**:

```math
E_t(x_{t+k})=\sum_{i=-\tau}^{-1}B_iE_t(x_{t+k+i}),\qquad k>0.
```

## 6. Steady-State Solution

Because the archive form is linear/log-deviation based, the operational steady state is a zero-gap state:

```math
\tilde y=0,\qquad \epsilon^p=\epsilon^y=0,\qquad \pi=\bar\pi,\qquad \Delta Y=0
```

for an unchanged inflation target, with $`p_t`$ and $`x_t`$ growing at the common steady inflation rate.

The paper gives the steady real contract-price relation under constant inflation:

- **(F24) Steady real contract price under trend inflation**:

```math
\bar x_t-\bar p_t=\bar\pi\sum_{i=1}^{3}i f_i.
```

Under the Rep-MMB zero-inflation linearization, $`\bar\pi=0`$, so:

```math
\bar x-\bar p=0,\qquad \bar v=0,\qquad \bar{\tilde y}=0,\qquad \bar{\pi}=0.
```

The Rep-MMB implementation initializes `f` and `rho` using the output-gap equation constants, but this steady-state normalization is from implementation code and should be source-checked against later Fuhrer/LWW documentation before promotion beyond `needs_review`.

## 7. Timing & Form Conventions

- Time is quarterly.
- Contracts last four quarters and are indexed by current and three lagged contract prices.
- Expectations $`E_t(\cdot)`$ are rational expectations conditional on information through period $`t`$.
- $`x_t`$ is the contract price negotiated in period $`t`$; $`p_t`$ is the aggregate log price index.
- Leads up to $`t+3`$ enter the contracting equation because the current contract overlaps expected future contract and output-gap conditions.
- Lags up to $`t-3`$ enter price aggregation because four cohorts of contracts are active.
- The model is linear in log levels, inflation rates, gaps, and contract-price deviations. Rep-MMB implements it in Dynare as `model(linear)`.
- Stock-capital timing is not applicable; this is a wage/price-contracting and reduced-form monetary model, not a capital accumulation model.
- Runtime validation was not performed.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII name | Meaning | Source / equation |
|---|---|---|---|
| Endogenous | $`p_t`$ / `p` | aggregate log price index | (F1), (F15) |
| Endogenous | $`x_t`$ / `x` | log nominal contract price | (F1), (F5) |
| Endogenous | $`v_t`$ / `ypsilon` | real contract-price index | (F4), implementation naming |
| Endogenous | $`\pi_t`$ / `infl` | inflation rate | (F8), (F9) |
| Endogenous | $`\theta_t`$ | contract-price inflation | (F9), (F10) |
| Endogenous | $`\tilde y_t`$ / `ytilde` | output gap | (F5), (F20) |
| Endogenous | $`\Delta Y_t`$ | nominal output growth in policy experiments | (F17), (F18) |
| Endogenous | $`\rho_t`$ / `rho` | real/long-rate state in implementation | implementation_cross_check, needs_review |
| Endogenous | $`r_t`$ / `interest` | short nominal interest rate in VAR / policy rule | paper VAR and implementation_cross_check |
| Exogenous | $`\epsilon^p_t`$ / `epsilon_p` | contracting or price disturbance | (F5), (F19) |
| Exogenous | $`\epsilon^y_t`$ / `epsilon_y` | output-gap disturbance | (F20), implementation_cross_check |
| Exogenous | `interest_` | monetary policy shock in Rep-MMB rule | implementation_cross_check |
| Parameter | $`s`$ / `s` | slope of four-quarter contract-weight distribution | (F2) |
| Parameter | $`f_i`$ / `f0`-`f3` | contract-weight coefficients | (F1), (F2) |
| Parameter | $`\gamma`$ / `gamma` | output-gap effect in contract setting | (F5) |
| Parameter | $`\beta_i`$ | overlap weights in two-sided representation | (F6), (F7) |
| Parameter | $`\gamma^{\ast}`$ | scaled output-gap coefficient | (F6), (F7) |
| Parameter | $`\delta`$ | nesting index: standard vs relative contracts | (F13), (F14) |
| Parameter | $`\alpha_\pi,\alpha_y`$ | nominal-output policy-experiment responses | (F18) |
| Parameter | $`\bar\pi`$ | inflation target | (F18), (F24) |
| Parameter | $`a_0,a_1,a_2,a_\rho`$ | reduced-form output-gap coefficients | (F20), implementation_cross_check |
| Parameter | $`D`$ | duration/term-structure parameter in implementation | implementation_cross_check, needs_review |
