# EA_CW05fm Derivation

> First-pass private archive derivation. Status: `needs_review`.
> Runtime validation was not performed. Source formulas are taken from MinerU Markdown and cross-checked against the local Rep-MMB implementation only for coverage and timing.

## 1. Model Overview

- **Model ID**: `EA_CW05fm`.
- **Paper**: Coenen and Wieland (2005), "A small estimated euro area model with rational expectations and nominal rigidities", *European Economic Review* 49(5), 1081-1104, DOI `10.1016/j.euroecorev.2003.05.001`.
- **Variant**: the MMB implementation comment identifies `EA_CW05fm` as the relative real wage contracting version associated with Buiter-Jewitt / Fuhrer-Moore. The companion `EA_CW05ta` is the Taylor nominal wage contracting version.
- **Purpose**: a small estimated euro area policy model linking inflation, output gaps, interest rates, and overlapping wage contracts. The paper estimates several contracting specifications and closes the preferred euro-area model with an aggregate demand equation, a Taylor-type policy rule, a term-structure equation, and an ex ante long real rate.
- **Agents/blocks**: wage setters sign overlapping contracts; aggregate demand is a reduced-form IS equation; the central bank sets the short nominal rate; the long nominal and real rates follow expectations/term-structure definitions.
- **Form**: linear rational-expectations model. The Rep-MMB file uses `model(linear)`. Variables are deviations or rates, not levels of a nonlinear DSGE allocation.
- **Source sniff**: first page/first 80 Markdown lines match the expected title and authors, with OCR noise in names and words such as inflation. No title/source mismatch was found.

## 2. Optimization Problems

The paper does not provide micro-founded utility or profit maximization problems. The structural wage-price block is a reduced-form overlapping-contract model. The "choice" object is the newly negotiated contract wage or contract price, conditional on expected prices, real contract wage comparisons, and the output gap.

For the `EA_CW05fm` Fuhrer-Moore relative real wage variant, wage setters choose the current nominal contract wage $x_t$ so that the expected real wage over the contract life is tied to expected overlapping real contract wages and the average output gap:

$${x_t - E_t[\bar p_t] = E_t\left[\sum_{i=0}^{3} f_i v_{t+i} + \gamma \bar q_t\right] + \sigma_{\varepsilon_x}\varepsilon_{x,t}} \qquad \text{(source M-3)}$$

where the paper defines the contract-life averages

$${\bar p_t = \sum_{i=0}^{3} f_i p_{t+i}, \qquad \bar q_t = \sum_{i=0}^{3} f_i q_{t+i}}$$

and, for the baseline RW case,

$${v_t = \sum_{i=0}^{3} f_i\left(x_{t-i} - E_t[\bar p_{t-i}]\right)}.$$

The full model is then closed with estimated behavioral equations rather than explicit household, firm, or government optimization problems.

## 3. First-Order Conditions

Because the paper's model is estimated as a linear contracting system, this section records the structural equilibrium conditions that take the place of explicit FOCs. Numbering is continuous across Sections 3-5.

**(F1) Contract weights**

$$f_i = 0.25 + (1.5-i)s,\qquad i=0,1,2,3,\qquad 0<s\leq \frac{1}{6}.$$

**(F2) Aggregate price index from active contracts**

$$p_t = \sum_{i=0}^{3} f_i x_{t-i}.$$

**(F3) Average expected price over the contract life**

$$\bar p_t = \sum_{i=0}^{3} f_i p_{t+i}.$$

**(F4) Average expected output gap over the contract life**

$$\bar q_t = \sum_{i=0}^{3} f_i q_{t+i}.$$

**(F5) Real contract wage index for the baseline RW specification**

$$v_t = \sum_{i=0}^{3} f_i\left(x_{t-i} - E_t[\bar p_{t-i}]\right).$$

**(F6) Relative real wage contract equation for `EA_CW05fm`**

$$x_t - E_t[\bar p_t] = E_t\left[\sum_{i=0}^{3} f_i v_{t+i} + \gamma \bar q_t\right] + \sigma_{\varepsilon_x}\varepsilon_{x,t}.$$

**(F7) Annualized quarterly inflation definition**

$$\pi_t = p_t - p_{t-1}.$$

`needs_review`: the paper notes that the wage-price block can be rewritten in terms of quarterly inflation and the real contract wage, while the Rep-MMB code uses auxiliary lag/lead variables and a four-quarter inflation measure. The exact algebraic transformation from $(p_t,x_t)$ to the implementation's `pi1`, `infl`, and lag variables was cross-checked against the `.mod`, not fully re-derived from the paper.

## 4. Market Clearing & Identities

The model does not include goods, labor, or asset market clearing from a fully micro-founded DSGE allocation. Its closing identities are reduced-form definitions for the output gap, inflation measure, and interest rates.

**(F8) Aggregate demand / IS equation**

$$q_t = \delta_0 + \delta_1 q_{t-1} + \delta_2 q_{t-2} + \delta_3 r^l_{t-1} + \sigma_{\varepsilon_d}\varepsilon_{d,t}.$$

**(F9) Four-quarter inflation used in the policy rule**

$$\pi_t^{(4)} = p_t - p_{t-4}.$$

**(F10) Taylor-type short nominal interest-rate rule**

$$i_t^s = r^{\ast} + \pi_t^{(4)} + \alpha_{\pi}\left(\pi_t^{(4)}-\pi^{\ast}\right) + \alpha_q q_t.$$

**(F11) Long nominal interest rate from expectations hypothesis**

$$i_t^l = E_t\left[\frac{1}{8}\sum_{j=0}^{7} i_{t+j}^s\right].$$

**(F12) Long ex ante real interest rate**

$$r_t^l = i_t^l - E_t\left[\frac{1}{2}(p_{t+8}-p_t)\right].$$

**(F13) Deterministic steady-state real-rate relation**

$$r^{\ast} = -\frac{\delta_0}{\delta_3}.$$

**(F14) Policy target pins down steady-state inflation**

$$\pi = \pi^{\ast}.$$

`needs_review`: the Rep-MMB implementation uses a smoothed Gerdesmeier-Roffia-style policy rule for `interest`, with `interest = (0.87^3) interest_{t-1} + (1-0.87^3)1.93 inflation + (1-0.87^3)0.28 outputgap + interest_`. This appears to be implementation-specific relative to the paper's Table 4 Taylor rule.

## 5. Exogenous Processes

The paper treats the contract-wage shock and demand shock as serially uncorrelated, zero-mean, unit-variance innovations scaled by standard-deviation parameters.

**(F15) Contract-wage shock**

$$\varepsilon_{x,t}\sim iid(0,1),\qquad \text{contract block scale } \sigma_{\varepsilon_x}.$$

**(F16) Demand shock**

$$\varepsilon_{d,t}\sim iid(0,1),\qquad \text{aggregate-demand scale } \sigma_{\varepsilon_d}.$$

**(F17) Monetary policy shock in the Rep-MMB policy rule**

$$\varepsilon_{i,t}\sim iid(0,\sigma_i^2).$$

`needs_review`: the paper's Table 4 policy rule is deterministic apart from the model simulations, while the Rep-MMB file includes a policy innovation named `interest_`.

## 6. Steady-State Solution

This is a linear model in gaps/rates. The deterministic steady state is characterized by zero output gap and policy-determined inflation.

**(F18) Output-gap steady state**

$$q = 0.$$

**(F19) Long real-rate steady state**

$$r^l = r^{\ast} = -\frac{\delta_0}{\delta_3}.$$

**(F20) Inflation steady state**

$$\pi = \pi^{\ast}.$$

**(F21) Shock steady states**

$$\varepsilon_x = \varepsilon_d = \varepsilon_i = 0.$$

For a Dynare `model(linear)` implementation, steady states for deviation-style auxiliary variables are zero unless the variable represents a level/rate around a nonzero target that has already been demeaned by the model equations. Runtime steady-state validation was not performed.

## 7. Timing & Form Conventions

- **Contract timing**: four-quarter overlapping contracts. Current aggregate price depends on current and three lagged contract wages; current contract setting depends on expected prices and output gaps over the current and next three quarters.
- **Relative real wage baseline**: `EA_CW05fm` corresponds to the paper's RW case, where the real contract wage index uses expectations conditioned at time $t$.
- **Interest-rate timing**: aggregate demand responds to the lagged long ex ante real interest rate $r^l_{t-1}$. The long nominal rate averages expected short nominal rates over eight quarters. The long real rate subtracts expected inflation over the following eight quarters.
- **Implementation timing cross-check**: the Rep-MMB file introduces lead/lag auxiliary variables (`ldq1`, `ldq2`, `ldvindex1`, `ldvindex2`, `ldis1`-`ldis6`, `ldpi1`-`ldpi7`) to express forward-looking averages inside `model(linear)`.
- **Form**: linear rational-expectations model, not a nonlinear model to be log-linearized by Dynare.

## 8. Variable & Parameter Reference Table

### Endogenous Variables

| Symbol / ASCII | Meaning | Main equation(s) |
|---|---|---|
| $p_t$ / `p` | log aggregate price level | (F2), (F7), (F9), (F12) |
| $x_t$ / `cwp` | newly negotiated contract wage/price | (F2), (F6) |
| $v_t$ / `vindex` | real contract wage index | (F5), (F6) |
| $q_t$ / `q`, `outputgap` | output gap | (F4), (F8), (F10) |
| $\pi_t$ / `pi1`, `infl`, `inflation` | quarterly or four-quarter inflation measure | (F7), (F9), (F10) |
| $i_t^s$ / `is`, `interest` | short nominal interest rate | (F10), implementation policy rule |
| $i_t^l$ / `il` | long nominal interest rate | (F11) |
| $r_t^l$ / `rl` | long ex ante real interest rate | (F8), (F12), (F19) |
| auxiliary lags/leads | lagged or expected future variables used by `model(linear)` | implementation_cross_check |

### Exogenous Shocks

| Symbol / ASCII | Meaning | Source |
|---|---|---|
| $\varepsilon_{x,t}$ / `e_cw` | contract-wage shock | paper Table 1, implementation |
| $\varepsilon_{d,t}$ / `fiscal_` | aggregate-demand shock | paper Table 4, implementation names it `fiscal_` |
| $\varepsilon_{i,t}$ / `interest_` | monetary policy shock | implementation_cross_check |

### Parameters

| Symbol / ASCII | Meaning | Notes |
|---|---|---|
| $s$ / `s` | slope parameter determining contract weights | paper Table 1; Rep-MMB value for `EA_CW05fm` is `0.0742`, matching RW-S estimates rather than the paper's baseline RW estimate, `needs_review` |
| $f_i$ / `f0`-`f3` | contract wage weights | (F1) |
| $\gamma$ / `gamma1` | output-gap sensitivity in contract wage equation | paper Table 1; Rep-MMB value `0.0212` |
| $\sigma_{\varepsilon_x}$ / `sigma_e_cw` | contract shock scale | paper Table 2; Rep-MMB normalizes to `1.00` and puts variances in `shocks` |
| $\delta_0,\delta_1,\delta_2,\delta_3$ / `delta0`-`delta3` | aggregate-demand parameters | (F8); Rep-MMB values use the euro-area German-rate row |
| $\sigma_{\varepsilon_d}$ / `sigma_e_d` | demand shock scale | (F8) |
| $r^{\ast}$ | equilibrium long real rate | (F13), (F19) |
| $\pi^{\ast}$ | inflation target | (F10), (F14), (F20) |
| $\alpha_{\pi},\alpha_q$ | policy response coefficients | paper Table 4 policy rule |
| policy smoothing coefficients | implementation policy-rule coefficients | implementation_cross_check |

### Implementation Cross-Check Summary

The local `.mod` confirms `model(linear)`, the modelbase variables `interest`, `inflation`, and `outputgap`, shocks `interest_`, `fiscal_`, and `e_cw`, and the auxiliary lead/lag structure used to implement the relative wage contracting and interest-rate blocks. No Dynare run was performed.
