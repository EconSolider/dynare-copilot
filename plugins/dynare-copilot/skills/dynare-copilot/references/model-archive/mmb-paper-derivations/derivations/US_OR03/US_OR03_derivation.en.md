# US_OR03 - Derivation (Optimization Problems + First-Order Conditions)

> Source-backed first-pass archive entry for the MMB model `US_OR03`. Status: `needs_review`. Runtime validation was not performed.

## 1. Model Overview

- **Model**: Orphanides (2003), "The quest for prosperity without inflation"; MMB model ID `US_OR03`.
- **Source**: MinerU Markdown at `raw/mmb_mineru/runs/us_or03__the_quest_for_prosperity_without_inflation__1b77d67e/full.md`; raw PDF at `raw/mmb_papers/The quest for prosperity without inflation.pdf`.
- **Paper metadata**: Athanasios Orphanides, 2003, DOI `10.1016/s0304-3932(03)00028-x`.
- **Model class**: small U.S. macroeconometric policy model, interpretable as a mildly restricted structural VAR with four lags.
- **Core variables**: quarterly inflation $\pi_t$, output gap $y_t$, and federal funds rate / policy instrument $f_t$ or $R_t$.
- **Form**: linear estimated system. The Rep-MMB implementation uses `model(linear)` with variables `y`, `pi`, and `f`.
- **Purpose**: counterfactual simulations of Taylor-type policy rules under perfect-information and real-time-data information assumptions.

## 2. Optimization Problems

The paper is not a micro-founded DSGE model with household, firm, capital, or government optimization. It estimates a reduced-form macroeconomic system and imposes alternative policy rules in counterfactual simulations.

The policy authority is represented by simple interest-rate feedback rules rather than by a solved Ramsey or discretionary optimization problem. The general activist rule family is:

$$
R_t-R_t^*=\gamma(\pi_t^a-\pi^*)+\delta y_t.
$$

The information problem enters because the policymaker observes real-time measures $\tilde{\pi}_t^a$ and $\tilde{y}_t$, not final-data values. The paper evaluates the macroeconomic performance implied by those rule choices; it does not derive private-agent FOCs.

## 3. First-Order Conditions

There are no private-agent FOCs. The following numbered equations are the equilibrium, policy, and information equations needed for the linear MMB archive representation.

- **(F1) Output-gap equation**:

$$
y_t =
b_0
+ \sum_{i=1}^{4} b_i^\pi \pi_{t-i}
+ \sum_{i=1}^{4} b_i^y y_{t-i}
+ \sum_{i=1}^{4} b_i^f f_{t-i}
+ u_t.
$$

- **(F2) Inflation equation**:

$$
\pi_t =
\sum_{i=1}^{4} a_i^\pi \pi_{t-i}
+ \sum_{i=0}^{4} a_i^y y_{t-i}
+ e_t.
$$

The OCR source prints the second coefficient superscript in (9) as $\nu$ rather than $y$ in one location. This entry follows the surrounding text and implementation cross-check by treating those terms as output-gap coefficients; this normalization remains `needs_review`.

- **(F3) Neutral nominal rate identity**:

$$
R_t^* = r^*+\pi_t^a.
$$

- **(F4) General activist policy rule**:

$$
R_t-R_t^*=\gamma(\pi_t^a-\pi^*)+\delta y_t.
$$

- **(F5) Taylor rule**:

$$
R_t = 2+\pi_t^a+0.5(\pi_t^a-2)+0.5y_t.
$$

- **(F6) Revised Taylor rule**:

$$
R_t = 2+\pi_t^a+0.5(\pi_t^a-2)+1.0y_t.
$$

- **(F7) Real-time measurement equations**:

$$
\pi_t^a=\tilde{\pi}_t^a+x_t,
\qquad
y_t=\tilde{y}_t+z_t.
$$

- **(F8) Real-time implementable policy rule**:

$$
R_t-\tilde{R}_t^*
=\gamma(\tilde{\pi}_t^a-\pi^*)+\delta\tilde{y}_t,
\qquad
\tilde{R}_t^* \equiv r^*+\tilde{\pi}_t^a.
$$

- **(F9) Equivalent true-data expression of the real-time rule**:

$$
R_t-R_t^*
=\gamma(\pi_t^a-\pi^*)+\delta y_t
-\big((1+\gamma)x_t+\delta z_t\big).
$$

- **(F10) Inflation-only rule**:

$$
R_t=2+\pi_t^a+0.5(\pi_t^a-2).
$$

- **(F11) Natural-growth targeting rule**:

$$
R_t=2+\pi_t^a+0.5\big(\pi_t^a-2+\Delta^a y_t\big),
\qquad
\Delta^a y_t \equiv y_t-y_{t-4}.
$$

The Rep-MMB implementation selects the original Taylor rule and writes it with implementation variable `f`:

$$
f_t = 2+\pi_t+0.5(\pi_t-2)+0.5y_t+\varepsilon^f_t.
$$

This selected rule is recorded as `implementation_cross_check` evidence because it comes from `.agents/skills/dynare-copilot/references/examples/US_OR03_rep.mod`, not from a paper-side mathematical source.

## 4. Market Clearing & Identities

The model has no goods-market resource constraint, asset-market clearing equation, capital accumulation law, labor market, or government budget identity. It is a three-equation empirical policy model.

The main identities are embedded in the policy and measurement definitions above:

- neutral nominal-rate identity (F3);
- real-time measurement identities (F7);
- real-time neutral-rate definition in (F8);
- annual output-gap change definition in (F11).

The paper reports two restrictions imposed to enforce a classical-dichotomy property. MinerU OCR damages the formula line. The readable content supports:

$$
\sum_{i=1}^{4}a_i^\pi = 1
\qquad\text{and}\qquad
\sum_{i=1}^{4} b_i^\pi + \sum_{i=1}^{4} b_i^f = 0,
$$

but these restrictions are marked `needs_review` pending PDF-level equation checking.

## 5. Exogenous Processes

- **(F12) Output-gap innovation**:

$$
u_t \sim (0,\sigma_u^2).
$$

- **(F13) Inflation innovation**:

$$
e_t \sim (0,\sigma_e^2).
$$

- **(F14) Policy-rule innovation used by the MMB implementation** (`implementation_cross_check`):

$$
\varepsilon^f_t \sim (0,\sigma_f^2).
$$

The Rep-MMB file names these shocks `u`, `e`, and `interest_`. Its shock variances are `0.771025149^2`, `1.4069906748^2`, and `0`, respectively. Those values are implementation cross-check evidence only.

## 6. Steady-State Solution

Because the paper's system is linear in percentage-point macro variables, the steady state is defined by setting shocks to zero and holding variables constant.

For the paper-side estimated system:

$$
\bar{y}
= b_0
+ \left(\sum_{i=1}^{4}b_i^\pi\right)\bar{\pi}
+ \left(\sum_{i=1}^{4}b_i^y\right)\bar{y}
+ \left(\sum_{i=1}^{4}b_i^f\right)\bar{f},
$$

$$
\bar{\pi}
= \left(\sum_{i=1}^{4}a_i^\pi\right)\bar{\pi}
+ \left(\sum_{i=0}^{4}a_i^y\right)\bar{y}.
$$

For the selected Taylor rule:

$$
\bar{f}=2+\bar{\pi}^a+0.5(\bar{\pi}^a-2)+0.5\bar{y}.
$$

With the paper's benchmark target values $r^*=2$ and $\pi^*=2$, the Taylor-rule steady policy rate is $\bar{R}=4$ when $\bar{y}=0$ and $\bar{\pi}^a=2$. In the Rep-MMB implementation, `model(linear)` is used even though constants appear in the output and policy equations; the exact implementation steady-state convention is therefore `needs_review` until checked against the intended MMB preprocessing/runtime behavior.

Runtime validation status: not performed; Dynare was not run.

## 7. Timing & Form Conventions

- **Lag structure**: output and inflation are backward-looking four-lag equations. The output equation uses lags of $\pi_t$, $y_t$, and $f_t$; the inflation equation uses four inflation lags and current plus lagged output gaps.
- **Policy timing**: in simulations, the policy instrument is set recursively using available current-quarter information and lagged simulated values.
- **Information timing**: real-time simulations use perceived variables $\tilde{\pi}_t^a$ and $\tilde{y}_t$ when the policy decision is made; final-data simulations use ex post values.
- **Stocks**: no predetermined capital, bond, or other stock variable appears.
- **Form**: linear reduced-form / restricted-SVAR model; Rep-MMB uses `model(linear)`.
- **Uncertainty marker**: `needs_review` because the OCR damaged the classical-dichotomy restriction line and the source PDF body was not opened for formula-by-formula verification.

## 8. Variable & Parameter Reference Table

| Category | Symbol / Dynare name | Meaning | Determined by |
|---|---|---|---|
| Endogenous | $y_t$ / `y` | Output gap | (F1) |
| Endogenous | $\pi_t$ / `pi` | Quarterly inflation | (F2) |
| Endogenous | $f_t$ or $R_t$ / `f` | Federal funds rate / policy instrument | (F5), implementation selected rule |
| Policy concept | $R_t^*$ | Neutral nominal interest rate | (F3) |
| Policy concept | $\tilde{R}_t^*$ | Real-time neutral nominal interest rate | (F8) |
| Observed real-time variable | $\tilde{\pi}_t^a$ | Policymaker's real-time annual inflation measure | (F7) |
| Observed real-time variable | $\tilde{y}_t$ | Policymaker's real-time output-gap measure | (F7) |
| Measurement error | $x_t$ | Annual-inflation measurement noise | (F7), (F9) |
| Measurement error | $z_t$ | Output-gap measurement noise | (F7), (F9) |
| Exogenous | $u_t$ / `u` | Output-gap equation innovation | (F12) |
| Exogenous | $e_t$ / `e` | Inflation equation innovation | (F13) |
| Exogenous | $\varepsilon^f_t$ / `interest_` | Policy-rule shock in MMB implementation | (F14) |
| Parameter | $b_0$ / `b0` | Output equation intercept | - |
| Parameter | $b_i^\pi$ / `bpi1`-`bpi4` | Inflation-lag coefficients in output equation | - |
| Parameter | $b_i^y$ / `by1`-`by4` | Output-gap lag coefficients in output equation | - |
| Parameter | $b_i^f$ / `bf1`-`bf4` | Federal-funds-rate lag coefficients in output equation | - |
| Parameter | $a_i^\pi$ / `api1`-`api4` | Inflation-lag coefficients in inflation equation | - |
| Parameter | $a_i^y$ / `ay0`-`ay4` | Output-gap coefficients in inflation equation | - |
| Policy coefficient | $\gamma$ | Inflation response in general rule | - |
| Policy coefficient | $\delta$ | Output-gap response in general rule | - |
| Policy target | $\pi^*$ | Inflation target, `2` in Taylor parameterization | - |
| Policy parameter | $r^*$ | Natural real rate, `2` in Taylor parameterization | - |
