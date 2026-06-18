# US_RS99 - Derivation (Optimization Problems + First-Order Conditions)

> Source-backed first-pass archive entry for the MMB model `US_RS99`. Status: `needs_review`. Runtime validation was not performed.

## 1. Model Overview

- **Model**: Rudebusch and Svensson (1999), "Policy rules for inflation targeting"; MMB model ID `US_RS99`.
- **Source**: MinerU Markdown at `raw/mmb_mineru/runs/us_rs99__policy_rules_for_inflation_targeting__d61abd68/full.md`; raw PDF at `raw/mmb_papers/Policy rules for inflation targeting   .pdf`.
- **Paper metadata**: Glenn D. Rudebusch and Lars E.O. Svensson, 1999, DOI `10.3386/w6512`.
- **Model class**: small U.S. macroeconometric policy model with a backward-looking Phillips curve, a backward-looking IS/output-gap equation, and an interest-rate feedback rule.
- **Form**: linear model. The Rep-MMB implementation uses `model(linear)` with demeaned inflation, output gap, and federal-funds-rate variables, so the deterministic steady state is zero.
- **Policy experiment represented in `US_RS99`**: the implementation cross-check selects the smoothing instrument rule
  \(S(\bar{\pi}_t,y_t)\) with coefficients \(g_\pi=2.34\), \(g_y=1.03\), and \(h=0.30\), matching the source table entry for that rule. This `.mod` evidence is used only as `implementation_cross_check`.

## 2. Optimization Problems

The paper is not a micro-founded household-firm DSGE model. It evaluates policy rules in a linear empirical system. Therefore, there are no household, firm, capital, or market-clearing optimization problems to extract.

The policy authority's benchmark problem is stated as a quadratic stabilization problem. For discount factor \(0<\delta<1\), the intertemporal objective is:

\[
\min_{\{i_{t+\tau}\}}\; E_t \sum_{\tau=0}^{\infty}\delta^\tau L_{t+\tau},
\qquad
L_t=\bar{\pi}_t^2+\lambda y_t^2+\nu(i_t-i_{t-1})^2.
\]

For the main comparisons, the paper also uses the limiting unconditional loss

\[
E[L_t]=\operatorname{Var}(\bar{\pi}_t)+\lambda\operatorname{Var}(y_t)+\nu\operatorname{Var}(i_t-i_{t-1}).
\]

The MMB `US_RS99` implementation does not solve the regulator problem at runtime. It hard-codes one optimized simple smoothing rule from the paper's results table.

## 3. First-Order Conditions

There are no private-agent FOCs. The following numbered equations are the equilibrium and policy equations needed for the linear MMB implementation.

- **(F1) Phillips curve / inflation equation**:

\[
\pi_t =
\alpha_{\pi 1}\pi_{t-1}
+\alpha_{\pi 2}\pi_{t-2}
+\alpha_{\pi 3}\pi_{t-3}
+\alpha_{\pi 4}\pi_{t-4}
+\alpha_y y_{t-1}
+\varepsilon_t.
\]

- **(F2) IS/output-gap equation**:

\[
y_t =
\beta_{y1}y_{t-1}
+\beta_{y2}y_{t-2}
-\beta_r(\bar{i}_{t-1}-\bar{\pi}_{t-1})
+\eta_t.
\]

- **(F3) Four-quarter inflation identity**:

\[
\bar{\pi}_t=\frac{1}{4}\left(\pi_t+\pi_{t-1}+\pi_{t-2}+\pi_{t-3}\right).
\]

- **(F4) Four-quarter funds-rate identity**:

\[
\bar{i}_t=\frac{1}{4}\left(i_t+i_{t-1}+i_{t-2}+i_{t-3}\right).
\]

- **(F5) MMB-selected smoothing instrument rule** (`implementation_cross_check`; source table match):

\[
i_t = h i_{t-1}+g_\pi \bar{\pi}_t+g_y y_t,
\qquad
h=0.30,\quad g_\pi=2.34,\quad g_y=1.03.
\]

The paper defines the general smoothing rule as \(i_t=h i_{t-1}+gX_t\), with a common restriction \(gX_t=g_\pi\bar{\pi}_t+g_y y_t\). The chosen coefficient triplet is identified by cross-checking the Rep-MMB `.mod` file against the source table.

## 4. Market Clearing & Identities

The model is a reduced-form macroeconometric system, not a full general-equilibrium resource-allocation model. There is no goods-market resource constraint, asset-market clearing condition, labor market, capital accumulation equation, or government budget constraint to extract.

The accounting identities used by the MMB implementation are already represented by (F3) and (F4). The paper's state vector can also be represented as

\[
X_t =
\begin{bmatrix}
\pi_t & \pi_{t-1} & \pi_{t-2} & \pi_{t-3} &
y_t & y_{t-1} &
i_{t-1} & i_{t-2} & i_{t-3}
\end{bmatrix}'.
\]

The state-space transition in the paper is:

\[
X_{t+1}=AX_t+B i_t+v_{t+1},
\]

where the model shocks enter through the inflation and output equations.

## 5. Exogenous Processes

- **(F6) Inflation-equation disturbance**:

\[
\varepsilon_t \sim \text{i.i.d.}(0,\sigma_\varepsilon^2),
\qquad
\sigma_\varepsilon=1.009.
\]

- **(F7) Output-equation disturbance**:

\[
\eta_t \sim \text{i.i.d.}(0,\sigma_\eta^2),
\qquad
\sigma_\eta=0.819.
\]

The paper allows a covariance between \(\varepsilon_t\) and \(\eta_t\) in the general state-space presentation. The MMB implementation cross-check specifies only the two variances and no covariance term.

## 6. Steady-State Solution

Because the variables are demeaned deviations and the Rep-MMB file uses `model(linear)`, the deterministic steady state is:

\[
\pi=\bar{\pi}=y=i=\bar{i}=0,
\qquad
\varepsilon=\eta=0.
\]

The coefficient restriction

\[
\sum_{j=1}^{4}\alpha_{\pi j}=1
\]

is source-stated for the accelerationist Phillips curve. With zero shocks and all lagged variables at zero, equations (F1)-(F5) are satisfied at the zero steady state.

Parameter values used by the implementation are:

\[
\alpha_{\pi1}=0.70,\quad
\alpha_{\pi2}=-0.10,\quad
\alpha_{\pi3}=0.28,\quad
\alpha_{\pi4}=0.12,\quad
\alpha_y=0.14,
\]

\[
\beta_{y1}=1.16,\quad
\beta_{y2}=-0.25,\quad
\beta_r=0.10.
\]

Runtime validation status: not performed; Dynare was not run.

## 7. Timing & Form Conventions

- **Timing**: the MMB implementation writes the paper's \(t+1\) equations with current dated left-hand-side variables and lags on the right-hand side. Thus paper equation \(\pi_{t+1}\) maps to implementation variable `pi`, with lags `pi(-1)` through `pi(-4)`.
- **Interest-rate averaging**: \(\bar{i}_{t-1}\) in (F2) is the four-quarter average through \(t-1\), so the current policy rate \(i_t\) affects output with lagged transmission.
- **Inflation averaging**: \(\bar{\pi}_t\) is four-quarter inflation, while \(\pi_t\) is quarterly inflation at an annual rate. Both are deviations from a constant inflation target in the policy-rule analysis.
- **Stocks**: no stock variables, capital, bonds, or predetermined physical assets appear.
- **Form**: `model(linear)`; variables are demeaned percentage-point deviations, not log levels.
- **Uncertainty marker**: `needs_review` because equations were extracted from OCR Markdown and cross-checked against the `.mod` implementation but not checked against the PDF body equation-by-equation.

## 8. Variable & Parameter Reference Table

| Category | Symbol / Dynare name | Meaning | Determined by |
|---|---|---|---|
| Endogenous | \(\pi_t\) / `pi` | Quarterly inflation deviation, annualized percentage points | (F1) |
| Endogenous | \(y_t\) / `y` | Output gap deviation | (F2) |
| Endogenous | \(\bar{\pi}_t\) / `pibar` | Four-quarter inflation deviation | (F3) |
| Endogenous | \(\bar{i}_t\) / `ibar` | Four-quarter average funds-rate deviation | (F4) |
| Endogenous | \(i_t\) / `i` | Federal funds-rate deviation / policy instrument | (F5) |
| Exogenous | \(\varepsilon_t\) / `eps` | Inflation-equation innovation | (F6) |
| Exogenous | \(\eta_t\) / `eta` | Output-equation innovation | (F7) |
| Parameter | \(\alpha_{\pi1}\) / `alphapi1` | First inflation lag coefficient | - |
| Parameter | \(\alpha_{\pi2}\) / `alphapi2` | Second inflation lag coefficient | - |
| Parameter | \(\alpha_{\pi3}\) / `alphapi3` | Third inflation lag coefficient | - |
| Parameter | \(\alpha_{\pi4}\) / `alphapi4` | Fourth inflation lag coefficient | - |
| Parameter | \(\alpha_y\) / `alphay` | Output-gap coefficient in Phillips curve | - |
| Parameter | \(\beta_{y1}\) / `betay1` | First output-gap lag coefficient | - |
| Parameter | \(\beta_{y2}\) / `betay2` | Second output-gap lag coefficient | - |
| Parameter | \(\beta_r\) / `betar` | Real-rate transmission coefficient | - |
| Policy coefficient | \(h\) | Interest-rate smoothing coefficient, `0.30` in selected rule | - |
| Policy coefficient | \(g_\pi\) | Response to four-quarter inflation, `2.34` in selected rule | - |
| Policy coefficient | \(g_y\) | Response to output gap, `1.03` in selected rule | - |
| Shock scale | \(\sigma_\varepsilon\) | Inflation disturbance standard error, `1.009` in implementation | - |
| Shock scale | \(\sigma_\eta\) | Output disturbance standard error, `0.819` in implementation | - |
