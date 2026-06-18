# US_MR07 - Sticky Information in General Equilibrium

> First-pass archive derivation for MMB model `US_MR07`. Status: `needs_review`.
> Runtime validation was not performed. The `.mod` file was used only as
> `implementation_cross_check` evidence for variables, truncation conventions,
> and shock names.

## 1. Model Overview

- **Model**: Mankiw and Reis (2007), "Sticky information in general equilibrium.", Journal of the European Economic Association 5(2-3), pp. 603-613, DOI `10.1162/jeea.2007.5.2-3.603`.
- **Core mechanism**: the only rigidity is sticky information. Consumers, workers, and firms update information sporadically before setting consumption, wages, and prices.
- **Agents and blocks**: consumers choose spending, workers choose wages in segmented labor markets, firms set prices under monopolistic competition, production uses labor with decreasing returns, and monetary policy follows a Taylor rule.
- **Form**: log-linear / `model(linear)`. The paper-side Markdown gives five reduced-form equilibrium relations for price level, output, wages, production, and the nominal interest rate. The implementation cross-check approximates the infinite sticky-information sums with 30 lagged expectation terms and uses a long-run output proxy at a 150-quarter lead.
- **Shocks**: aggregate productivity growth, aggregate demand, goods markup, labor markup, and monetary policy shocks.
- **Formula quality**: the main five equations are legible in the MinerU Markdown, but appendix equations and the full algorithmic coefficient definitions are not present in this source. Those omissions are marked `needs_review`.

## 2. Optimization Problems

The article states the underlying microeconomic environment but leaves the detailed optimization problems and equilibrium definition to an appendix available in the working-paper version. The available MinerU Markdown contains only the journal article body, so this section records the source-stated problems at the level supported by the paper and flags missing details.

### Consumers

Households live forever, have additively separable isoelastic utility in consumption and leisure, and trade bonds. A fraction \(\delta\) of consumers updates information each period and chooses spending using the newly updated information set. The full lifetime problem and bond budget constraint are not printed in the available Markdown source (`needs_review`).

### Workers

Workers supply differentiated labor varieties in segmented markets. Each worker is the sole supplier of a labor variety and sets wages under monopolistic competition. A fraction \(\omega\) of workers updates information each period. The source-stated wage relation is recorded as (F3); the detailed worker optimization problem is in the unavailable appendix (`needs_review`).

### Firms

Firms sell differentiated goods under monopolistic competition and use a decreasing-returns technology in aggregate labor. A fraction \(\lambda\) of firms updates information each period before setting prices. The source-stated price-setting relation is recorded as (F1); the detailed firm pricing problem is in the unavailable appendix (`needs_review`).

### Monetary Authority

The central bank follows a Taylor rule. This is a policy rule, not an optimization problem.

## 3. First-Order Conditions

The paper presents the model through five key log-linear equilibrium relations rather than through primitive FOCs. Equations (F1)-(F5) preserve those source-stated reduced forms.

- **(F1) Sticky-information price-setting / aggregate supply relation**:

\[
p_t =
\lambda \sum_{j=0}^{\infty}(1-\lambda)^j E_{t-j}\left[
p_t + \frac{\beta(w_t-p_t)+(1-\beta)y_t-a_t}{\beta+\nu(1-\beta)}
- \frac{\beta v_t}{(\nu-1)[\beta+\nu(1-\beta)]}
\right].
\]

Here \(p_t\) is the price level, \(w_t-p_t\) is the real wage, \(y_t\) is output, \(a_t\) is productivity, \(v_t\) is the goods-markup shock, \(\nu\) is the elasticity of substitution across goods, and \(\lambda\) is the fraction of firms updating information. This equation is source-stated, but it is a reduced-form relation; primitive Calvo-like or sticky-information firm FOCs are `needs_review`.

- **(F2) Sticky-information IS relation**:

\[
y_t =
\delta \sum_{j=0}^{\infty}(1-\delta)^j E_{t-j}\left(y_\infty^n-\theta R_t\right)
+ g_t.
\]

The long-run equilibrium output term is

\[
y_\infty^n = \lim_{i\to\infty} E_t[y_{t+i}],
\]

and the long real interest rate is source-stated as

\[
R_t = E_t\left[\sum_{i=0}^{\infty}(i_{t+i}-\Delta p_{t+1+i})\right].
\]

The Markdown OCR around the long-rate notation is imperfect but the economic object is legible (`needs_review` for exact index notation).

- **(F3) Sticky-information wage-setting relation**:

\[
w_t =
\omega \sum_{j=0}^{\infty}(1-\omega)^j E_{t-j}\left[
p_t + \frac{\gamma(w_t-p_t)}{\gamma+\psi}
+ \frac{l_t}{\gamma+\psi}
+ \frac{\psi(y_\infty^n-\theta R_t)}{\theta(\gamma+\psi)}
- \frac{\psi\gamma_t}{(\gamma+\psi)(\gamma-1)}
\right].
\]

Here \(w_t\) is the nominal wage, \(l_t\) is labor, \(\gamma_t\) is the labor-markup shock, \(\gamma\) is the average labor substitutability parameter, \(\psi\) is the Frisch-elasticity parameter used in the paper, and \(\omega\) is the fraction of workers updating information.

## 4. Market Clearing & Identities

- **(F4) Production function**:

\[
y_t = a_t + \beta l_t.
\]

The parameter \(\beta\) measures decreasing returns to labor in production. The model has no capital accumulation.

- **(F5) Natural output / output gap definition**:

The Taylor rule uses the output gap \(y_t-y_t^n\). The source text defines \(y_t^n\) as the level of output if all agents were attentive, but the closed-form relation used by the `.mod` is from implementation cross-check, not paper-side source:

\[
y_t^n =
\frac{1+1/\psi}{1+1/\psi+\beta/\theta-\beta}a_t
+ \frac{\beta/\theta}{1+1/\psi+\beta/\theta-\beta}g_t
+ \frac{\beta/(\gamma-1)}{1+1/\psi+\beta/\theta-\beta}\gamma_t
+ \frac{\beta/(\nu-1)}{1+1/\psi+\beta/\theta-\beta}v_t.
\]

Status: `needs_review`; this expression is consistent with the implementation but is not directly printed in the available Markdown source.

- **(F6) Output gap identity**:

\[
x_t = y_t-y_t^n.
\]

- **(F7) Inflation identity**:

\[
\pi_t = p_t-p_{t-1}.
\]

## 5. Exogenous Processes

The source states that each shock follows an AR(1) process. The `.mod` cross-check uses productivity in levels with a separate productivity-growth term. The exact appendix-level timing should be checked against the working-paper appendix.

- **(F8) Aggregate demand shock**:

\[
g_t = \rho_g g_{t-1}+e_t^g.
\]

- **(F9) Aggregate productivity level and growth shock**:

\[
a_t = (1+\rho_{\Delta a})a_{t-1}-\rho_{\Delta a}a_{t-2}+e_t^{\Delta a},
\qquad
\Delta a_t = a_t-a_{t-1}.
\]

Status: `needs_review`; the paper text describes productivity-growth shocks, while the implementation expresses this as a second-order law for the productivity level.

- **(F10) Monetary policy disturbance**:

\[
\varepsilon_t = \rho_\varepsilon \varepsilon_{t-1}+e_t^\varepsilon.
\]

- **(F11) Goods-markup shock**:

\[
v_t = \rho_\nu v_{t-1}+e_t^\nu.
\]

- **(F12) Labor-markup shock**:

\[
\gamma_t = \rho_\gamma \gamma_{t-1}+e_t^\gamma.
\]

- **(F13) Taylor rule**:

\[
i_t = \varphi_y(y_t-y_t^n)+\varphi_p\Delta p_t-\varepsilon_t.
\]

The negative sign on the monetary-policy disturbance is source-stated and matches the implementation.

## 6. Steady-State Solution

Because this archive entry is for a log-linear / `model(linear)` representation, steady-state values for endogenous model variables are zero in deviation form:

\[
\bar{x}=\bar{\pi}=\bar{y}=\bar{y}^n=\bar{i}=\bar{l}=\bar{p}=\bar{w}=\bar{R}
=\bar{g}=\bar{a}=\bar{\varepsilon}=\bar{v}=\bar{\gamma}=\overline{\Delta a}=0.
\]

The shock innovations also have zero mean:

\[
\bar{e}^g=\bar{e}^{\Delta a}=\bar{e}^{\varepsilon}=\bar{e}^{\nu}=\bar{e}^{\gamma}=0.
\]

Finite-lag auxiliary expectation variables used in the implementation, such as \(p_j,w_j,l_j,R_j,y_j\) for \(j=1,\ldots,30\), also have zero steady states. Runtime validation was not performed.

## 7. Timing & Form Conventions

- **Linear form**: the model is implemented as `model(linear)`; variables are log deviations or linearized levels around steady state.
- **Information timing**: firms, consumers, and workers that last updated information \(j\) periods ago use \(E_{t-j}[\cdot]\) when setting current actions.
- **Finite approximation**: the paper equations use infinite sums over \(j=0,\ldots,\infty\). The implementation cross-check truncates sticky-information sums at 30 lags and approximates \(y_\infty^n\) with `y(+150)`.
- **Capital timing**: no capital accumulation appears in the source-stated model.
- **Long real rate**: \(R_t\) is the expected discounted sum of future ex-ante real short rates; exact index notation in the OCR source is `needs_review`.
- **Runtime validation**: not performed; no Dynare run was executed.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Main relation |
|---|---|---|---|
| Endogenous | `x`, \(x_t\) | output gap | (F6) |
| Endogenous | `pi`, \(\pi_t\) | inflation | (F7) |
| Endogenous | `y`, \(y_t\) | output | (F2), (F4) |
| Endogenous | `yn`, \(y_t^n\) | natural output | (F5) |
| Endogenous | `i`, \(i_t\) | nominal interest rate | (F13) |
| Endogenous | `l`, \(l_t\) | labor | (F3), (F4) |
| Endogenous | `p`, \(p_t\) | price level | (F1) |
| Endogenous | `w`, \(w_t\) | nominal wage | (F3) |
| Endogenous | `R`, \(R_t\) | long real interest rate | (F2) |
| Endogenous | `g`, \(g_t\) | aggregate demand shock state | (F8) |
| Endogenous | `a`, \(a_t\) | productivity level | (F9) |
| Endogenous | `e`, \(\varepsilon_t\) | monetary policy disturbance state | (F10), (F13) |
| Endogenous | `v`, \(v_t\) | goods-markup shock state | (F11) |
| Endogenous | `gam`, \(\gamma_t\) | labor-markup shock state | (F12) |
| Endogenous | `da`, \(\Delta a_t\) | productivity growth | (F9) |
| Endogenous auxiliary | `p1`-`p30`, `w1`-`w30`, `l1`-`l30`, `R1`-`R30`, `y1`-`y30` | finite-lag expectation auxiliaries in the implementation | implementation_cross_check |
| Endogenous auxiliary | `y100` | long-run output proxy, implemented as `y(+150)` | implementation_cross_check |
| Exogenous | `g_e`, \(e_t^g\) | aggregate demand innovation | (F8) |
| Exogenous | `a_e`, \(e_t^{\Delta a}\) | productivity-growth innovation | (F9) |
| Exogenous | `e_e`, \(e_t^\varepsilon\) | monetary policy innovation | (F10) |
| Exogenous | `v_e`, \(e_t^\nu\) | goods-markup innovation | (F11) |
| Exogenous | `gam_e`, \(e_t^\gamma\) | labor-markup innovation | (F12) |
| Parameter | `delta`, \(\delta\) | consumer updating probability | (F2) |
| Parameter | `lambda`, \(\lambda\) | firm updating probability | (F1) |
| Parameter | `omega`, \(\omega\) | worker updating probability | (F3) |
| Parameter | `beta`, \(\beta\) | labor share / production curvature in this paper notation | (F1), (F4), (F5) |
| Parameter | `phi_p`, \(\varphi_p\) | Taylor-rule inflation coefficient | (F13) |
| Parameter | `phi_y`, \(\varphi_y\) | Taylor-rule output-gap coefficient | (F13) |
| Parameter | `mu`, \(\nu\) | average goods substitutability in implementation naming | (F1), (F5) |
| Parameter | `theta`, \(\theta\) | intertemporal elasticity of substitution | (F2), (F3), (F5) |
| Parameter | `psi`, \(\psi\) | Frisch elasticity parameter | (F3), (F5) |
| Parameter | `gamma`, \(\gamma\) | average labor substitutability | (F3), (F5) |
| Parameter | `rho_g`, \(\rho_g\) | aggregate demand persistence | (F8) |
| Parameter | `rho_a`, \(\rho_{\Delta a}\) | productivity-growth persistence | (F9) |
| Parameter | `rho_e`, \(\rho_\varepsilon\) | monetary policy shock persistence | (F10) |
| Parameter | `rho_v`, \(\rho_\nu\) | goods-markup shock persistence | (F11) |
| Parameter | `rho_gam`, \(\rho_\gamma\) | labor-markup shock persistence | (F12) |
