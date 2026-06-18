# EA_CW05ta -- Derivation (Taylor Nominal Wage Contracts)

> First-pass model-archive derivation for `EA_CW05ta`. Status: `needs_review`.
> Runtime validation was not performed. The raw PDF body was not read; the PDF path was checked for provenance only.

Source: Coenen and Wieland (2005), "A small estimated euro area model with rational expectations and nominal rigidities," European Economic Review 49(5), 1081-1104, DOI `10.1016/j.euroecorev.2003.05.001`.

## 1. Model Overview

- **Model**: a small estimated euro area model with rational expectations, overlapping nominal wage contracts, an aggregate-demand equation, a term-structure block, and a Taylor-type policy rule.
- **MMB variant**: `EA_CW05ta`, the Taylor nominal wage-contract version. The implementation cross-check file states that the sibling Fuhrer-Moore relative real wage-contract version is a different variant.
- **Economy**: euro area aggregate data; the model is built for policy-rule simulations and inflation-output variability exercises.
- **Agents/blocks**: wage setters negotiate overlapping contracts; aggregate demand is an empirical IS equation; the central bank sets the short nominal rate; financial markets map expected short rates into a long nominal rate and long ex-ante real rate.
- **Form**: linear rational-expectations model, implemented as `model(linear)` in the MMB example. Variables are gap/rate objects, not levels of household utility or production.
- **Source quality**: MinerU Markdown title/authors match the index row, with minor OCR noise (`Gunter` vs. Guenther/Gunther; `in1ation`, `2t`, `di@erent`). Equations are usable but first-pass formulas remain `needs_review`.

## 2. Optimization Problems

The paper does not present a household or firm micro-optimization problem for `EA_CW05ta`. The model is an estimated semi-structural rational-expectations system.

### 2.1 Wage-setter contract problem

For the Taylor nominal-contract variant, wage setters choose the current contract wage with reference to expected average prices and expected average output gaps over the four-quarter contract life. The objective is represented directly by the contract-wage condition rather than by a utility maximization problem:

\[
x_t = E_t\left[\bar p_t + \gamma \bar q_t\right] + \sigma_{\varepsilon_x}\varepsilon_{x,t}.
\]

### 2.2 Aggregate demand and policy blocks

Aggregate demand, the term structure, and the monetary policy rule are not optimization problems in the source. They are estimated or imposed equilibrium relationships and therefore appear in Sections 3-5.

## 3. First-Order Conditions

There are no literal first-order conditions from optimizing households or firms in the source. The numbered conditions below are the behavioral and equilibrium equations that define the linear rational-expectations model.

- **(F1) Contract-price aggregation**:

\[
p_t = \sum_{i=0}^{3} f_i x_{t-i}.
\]

- **(F2) Contract-weight schedule**:

\[
f_i = 0.25 + (1.5-i)s,\qquad i=0,1,2,3,\qquad s\in(0,1/6].
\]

- **(F3) Average expected price over the contract life**:

\[
\bar p_t = \sum_{i=0}^{3} f_i p_{t+i}.
\]

- **(F4) Average expected output gap over the contract life**:

\[
\bar q_t = \sum_{i=0}^{3} f_i q_{t+i}.
\]

- **(F5) Taylor nominal wage-contract condition**:

\[
x_t = E_t\left[\bar p_t + \gamma \bar q_t\right] + \sigma_{\varepsilon_x}\varepsilon_{x,t}.
\]

- **(F6) Quarterly inflation definition**:

\[
\pi_t = p_t-p_{t-1}.
\]

- **(F7) Four-quarter inflation used in policy**:

\[
\pi_t^{(4)} = p_t-p_{t-4} = \sum_{j=0}^{3}\pi_{t-j}.
\]

- **(F8) Aggregate demand / IS equation**:

\[
q_t = \delta_0 + \delta_1 q_{t-1} + \delta_2 q_{t-2} + \delta_3 r^l_{t-1} + \sigma_{\varepsilon_d}\varepsilon_{d,t}.
\]

- **(F9) Taylor-type short-rate rule**:

\[
i^s_t = r^{\ast} + \pi_t^{(4)} + \alpha_{\pi}\left(\pi_t^{(4)}-\pi^{\ast}\right) + \alpha_q q_t + \varepsilon_{i,t}.
\]

The additive monetary-policy shock is from the MMB implementation cross-check; the paper equation lists the deterministic rule without an explicit shock term. Status: `needs_review`.

- **(F10) Expectations-hypothesis long nominal rate**:

\[
i^l_t = E_t\left[\frac{1}{8}\sum_{j=0}^{7} i^s_{t+j}\right].
\]

- **(F11) Long ex-ante real rate**:

\[
r^l_t = i^l_t - E_t\left[\frac{1}{2}(p_{t+8}-p_t)\right].
\]

- **(F12) Deterministic steady-state real-rate identity**:

\[
r^{\ast} = -\frac{\delta_0}{\delta_3}.
\]

## 4. Market Clearing & Identities

This small model is specified in terms of output gaps and inflation/interest-rate relationships. It does not include goods-market clearing, factor-market clearing, capital accumulation, or household budget constraints.

- **(F13) Output-gap normalization**:

\[
q_t = y_t-y^{\ast}_t.
\]

Here \(y_t\) is log output and \(y^{\ast}_t\) is a trend or potential-output measure. The paper uses log-linear trend output gaps for estimation and discusses OECD output-gap comparisons. Status: `needs_review` because the exact MMB data transformation is not rechecked from raw data.

- **(F14) Implementation inflation/output/interest aliases**:

\[
\text{outputgap}_t=q_t,\qquad \text{inflation}_t=\pi_t^{(4)},\qquad \text{interest}_t=i^s_t.
\]

These aliases are from the `.mod` implementation cross-check and are not separate paper-side equations.

## 5. Exogenous Processes

- **(F15) Contract-wage shock**:

\[
\varepsilon_{x,t}\sim iid(0,1).
\]

- **(F16) Aggregate-demand shock**:

\[
\varepsilon_{d,t}\sim iid(0,1).
\]

- **(F17) Monetary-policy shock for MMB simulations**:

\[
\varepsilon_{i,t}\sim iid(0,\sigma_i^2).
\]

The source simulations discuss cost-push and disinflation experiments; the explicit policy-shock innovation is an implementation cross-check item. Status: `needs_review`.

## 6. Steady-State Solution

The model is linear and uses gap/rate variables. The deterministic steady state is characterized by zero output gap and policy-determined inflation target.

1. Set shocks to zero:

\[
\varepsilon_{x,t}=\varepsilon_{d,t}=\varepsilon_{i,t}=0.
\]

2. Set the output gap to zero:

\[
\bar q=0.
\]

3. The policy target pins down inflation:

\[
\bar\pi^{(4)}=\pi^{\ast}.
\]

4. The long ex-ante real rate equals the equilibrium real rate:

\[
\bar r^l=r^{\ast}=-\frac{\delta_0}{\delta_3}.
\]

5. The short and long nominal rates satisfy:

\[
\bar i^s=\bar i^l=r^{\ast}+\pi^{\ast}.
\]

6. Contract-price levels are not pinned down in absolute level. A normalization such as \(\bar p=0\) can be used; then \(\bar x=\bar p\) in a zero-gap, constant-inflation representation after detrending. Status: `needs_review` because the archive has not reconstructed the exact level normalization used by the MMB conversion.

## 7. Timing & Form Conventions

- **Form**: linear rational-expectations model; MMB implementation uses `model(linear)`.
- **Contract timing**: current contract wage \(x_t\) affects current and future aggregate prices through four-quarter overlapping contracts; aggregate price \(p_t\) averages current and three lagged contract wages.
- **Forward-looking terms**: contract wage setting uses \(E_t p_{t+i}\) and \(E_t q_{t+i}\) for \(i=0,\dots,3\); the long nominal rate uses expected short rates from \(t\) through \(t+7\); the long real rate subtracts expected inflation from \(t\) to \(t+8\).
- **Policy timing**: aggregate demand responds to the lagged long real rate \(r^l_{t-1}\), capturing a monetary transmission lag.
- **Implementation cross-check**: `EA_CW05ta_rep.mod` uses helper lag variables and finite leads to express the same Taylor-contract block in Dynare-safe linear form. It also uses a smoothed Gerdesmeier-Roffia-style policy rule, so exact rule coefficients in that file should be treated as implementation calibration, not paper-side derivation.
- **Runtime validation**: not performed.

## 8. Variable & Parameter Reference Table

### Endogenous variables

| Symbol / ASCII | Meaning | Main equation |
|---|---|---|
| \(p_t\) / `p` | aggregate log price level | (F1) |
| \(x_t\) / `x`, `cwp` | current nominal contract wage/price | (F5) |
| \(q_t\) / `q`, `outputgap` | output gap | (F8), (F13) |
| \(\pi_t\) / `pi1` | quarterly inflation | (F6) |
| \(\pi_t^{(4)}\) / `infl`, `inflation` | four-quarter inflation | (F7), (F14) |
| \(i^s_t\) / `is`, `interest` | short nominal policy rate | (F9) |
| \(i^l_t\) / `il` | long nominal rate | (F10) |
| \(r^l_t\) / `rl` | long ex-ante real rate | (F11) |
| \(\bar p_t\) | expected average price over contract life | (F3) |
| \(\bar q_t\) | expected average output gap over contract life | (F4) |

### Exogenous shocks

| Symbol / ASCII | Meaning | Main equation |
|---|---|---|
| \(\varepsilon_{x,t}\) / `e_cw` | contract-wage/cost-push shock | (F15) |
| \(\varepsilon_{d,t}\) / `fiscal_` in MMB file | aggregate-demand shock | (F16) |
| \(\varepsilon_{i,t}\) / `interest_` | monetary-policy shock | (F17) |

### Parameters

| Symbol / ASCII | Meaning | Source cue |
|---|---|---|
| \(s\) / `s` | slope parameter for contract weights | Table 1, Table 2 |
| \(f_i\) / `f0`-`f3` | contract weights | (F2) |
| \(\gamma\) / `gamma1` | output-gap sensitivity in wage contract | Table 1, Table 2 |
| \(\sigma_{\varepsilon_x}\) / `sigma_e_cw` | contract-wage shock scale | Table 2 |
| \(\delta_0,\delta_1,\delta_2,\delta_3\) / `delta0`-`delta3` | aggregate-demand coefficients | Table 4, Table 5 |
| \(\sigma_{\varepsilon_d}\) / `sigma_e_d` | demand-shock scale | Table 5 |
| \(\alpha_\pi,\alpha_q\) | policy-rule response coefficients | Table 4 |
| \(\pi^{\ast}\) | policy inflation target | Table 4 / Section 5 |
| \(r^{\ast}\) | equilibrium real rate | (F12) |

First-pass equation count: 17 numbered conditions. Formula fidelity and exact MMB transformation details remain `needs_review`.
