# NK_LWW03 - Derivation (optimization problems + first-order conditions)

> This first-pass archive entry is source-backed by the MinerU Markdown for Levin, Wieland, and Williams (2003). It records the small optimizing AD-AS model used in the paper and the MMB implementation cross-check for `NK_LWW03`. Runtime validation was not performed.

## 1. Model Overview

- **Model ID**: `NK_LWW03`.
- **Paper**: Andrew Levin, Volker Wieland, and John C. Williams (2003), "The Performance of Forecast-Based Monetary Policy Rules under Model Uncertainty," *American Economic Review* 93(3), 622-645.
- **DOI**: `10.1257/000282803322157016`.
- **Source Markdown**: `raw/mmb_mineru/runs/nk_lww03_nk_lww03al_us_frb03__the_performance_of_forecast_based_monetary_policy_rules_under_model_unce__c97e3d2f/full.md`.
- **Raw PDF**: `raw/mmb_papers/The Performance of Forecast-Based Monetary Policy Rules under Model Uncertainty.pdf`.
- **MinerU run id**: `c97e3d2f-7a9e-4264-94c8-b3429b587455`.
- **Model family**: small rational-expectations New Keynesian / optimizing AD-AS model with nominal inertia and monetary neutrality.
- **Agents and blocks**: the paper describes a stylized system derived from optimizing behavior: a price-setting / aggregate-supply block, an expectational IS / aggregate-demand block, a monetary-policy rule, and exogenous disturbances to the natural real rate and inflation.
- **Form**: linearized model. The MMB implementation cross-check uses `model(linear)` with variables in annualized percentage-point or gap units.
- **Status**: `needs_review`. The paper states that the two structural equations are derived from optimizing agents but does not provide the full household and firm primitive problems in the extracted Markdown; this entry therefore stays at reduced-form equilibrium depth.

## 2. Optimization Problems

The source paper does not present a full primitive household problem, final-goods aggregator, Calvo-price-setting problem, or central-bank loss-minimization problem for the small optimizing AD-AS model. It states that the first model is a small stylized model, related to Bernanke-Woodford, Clarida-Gali-Gertler, and Woodford, consisting of two equations derived from optimizing behavior. Therefore the archive entry records the reduced-form equilibrium system rather than inventing missing primitives.

- **Representative demand side**: summarized by an expectational IS curve. The underlying optimization is the intertemporal consumption/saving margin, with the output gap falling when the ex-ante real policy rate rises above the natural real rate.
- **Price-setting side**: summarized by a forward-looking Phillips curve. The underlying optimization is staggered nominal price setting, with current inflation depending on expected future inflation, the output gap, and a cost-push disturbance.
- **Policy authority**: the paper evaluates time-invariant simple instrument rules. The MMB `NK_LWW03` implementation cross-check fixes a current-inflation rule, while the paper also reports forecast-based rules.

`needs_review`: A future source-level review should decide whether to supplement this entry with primitive objectives from the cited Woodford / Clarida-Gali-Gertler sources rather than only the paper's reduced-form equations.

## 3. First-Order Conditions

The paper's structural model is already written in linearized equilibrium-condition form, so the conditions below are the F-numbered archive equations corresponding to the reduced-form FOCs/equilibrium equations.

- **(F1) Forward-looking Phillips curve / aggregate supply**:

\[
\pi_t = \delta E_t \pi_{t+1} + \phi y_t + \varepsilon_t.
\]

Current inflation depends on expected next-period inflation, the output gap, and an aggregate-supply disturbance.

- **(F2) Expectational IS curve / aggregate demand**:

\[
y_t = E_t y_{t+1} - \sigma\left(i_t - E_t \pi_{t+1} - r_t^{\ast}\right).
\]

The output gap falls when the short nominal rate exceeds expected inflation plus the natural real interest rate.

- **(F3) General forecast-based instrument rule from the paper**:

\[
i_t =
\rho i_{t-1}
+ (1-\rho)\left(r^{\ast} + E_t\tilde{\pi}_{t+\theta}\right)
+ \alpha\left(E_t\tilde{\pi}_{t+\theta}-\pi^{\ast}\right)
+ \beta E_t y_{t+\kappa}.
\]

Here `theta` is the inflation forecast horizon and `kappa` is the output-gap forecast horizon, both measured in quarters. The source paper uses this as the rule class for robustness experiments.

- **(F4) Source benchmark forecast-based rule**:

\[
i_t = 1.0\,i_{t-1} + 0.4\,E_t\left(\tilde{\pi}_{t+4}-\pi^{\ast}\right) + 0.4\,y_t.
\]

This is the paper's benchmark rule for robust performance across the five models. `implementation_cross_check`: the MMB `NK_LWW03_rep.mod` does not implement this exact forecast-based rule; it instead uses the simple current-inflation rule in (F5).

- **(F5) MMB implementation policy-rule variant**:

\[
i_t = 1.5\,\pi_t.
\]

This equation comes from the `.mod` implementation cross-check (`rff = 1.5*pdot`) and is not treated as the paper's benchmark rule. It is included to explain the specific MMB `NK_LWW03` variant.

## 4. Market Clearing & Identities

- **(F6) Output-gap definition**:

\[
y_t \equiv \log Y_t - \log Y_t^{pot}.
\]

The paper describes `y` as the output gap, i.e. the deviation of output from potential.

- **(F7) Policy-rate-change identity used by the implementation**:

\[
\Delta i_t = i_t - i_{t-1}.
\]

`implementation_cross_check`: the MMB implementation includes `drff = rff - rff(-1)` for the change in the federal funds rate. This identity is useful for model outputs but is not a separate behavioral block in the paper.

## 5. Exogenous Processes

- **(F8) Natural real-rate process**:

\[
r_t^{\ast} = \rho_r r_{t-1}^{\ast} + \eta^r_t.
\]

The paper calibrates the autocorrelation of `rstar` to 0.35 and the innovation standard deviation to 3.72 in annualized percentage-point units. The `.mod` cross-check uses `rhorstar = 0.35`.

- **(F9) Aggregate-supply / inflation shock process**:

\[
\varepsilon_t = \rho_{\varepsilon}\varepsilon_{t-1} + \eta^\pi_t.
\]

The source text states the aggregate-supply disturbance is i.i.d. for the optimizing AD-AS calibration, while the MMB implementation cross-check keeps a parameter `rhopish` and sets it to 0. This entry therefore records the AR(1) envelope with `\rho_{\varepsilon}=0` for the source-calibrated baseline.

## 6. Steady-State Solution

Because the model is linearized in gap / deviation form, the deterministic steady state is the zero vector for endogenous gap variables and zero-mean shocks:

\[
\bar{y}=0,\qquad \bar{\pi}=0,\qquad \bar{i}=0,\qquad \overline{\Delta i}=0,
\qquad \bar{r}^{\ast}=0,\qquad \bar{\varepsilon}=0.
\]

For the MMB implementation cross-check:

1. Set `rstar = 0` and `pdotsh = 0`.
2. From (F1), `pdot = discountt*pdot + 4*phi*ygap`; with `discountt < 1`, the zero-inflation, zero-gap steady state solves the equation.
3. From (F2), `ygap = ygap - 0.25*sigma*(rff - pdot - rstar)`, so `rff = 0` when `pdot = rstar = 0`.
4. From (F5), `rff = 1.5*pdot = 0`.
5. From (F7), `drff = 0`.

Runtime validation was not performed.

## 7. Timing & Form Conventions

- **Linearization**: the paper equations and MMB implementation are linear / gap-form equations, not nonlinear levels.
- **Frequency and scaling**: quarterly timing; inflation and interest rates are in annualized percentage-point units in the source discussion and implementation.
- **Expectations**: `E_t` denotes a rational expectation using information available at time `t`.
- **Forward-looking variables**: inflation and output gap enter with one-period-ahead expectations in (F1)-(F2); forecast-based policy rules can use multi-quarter forecast horizons.
- **Stock variables**: no capital or other physical stock state appears in the `NK_LWW03` reduced-form model. The lagged nominal interest rate is predetermined in the forecast-based policy-rule class.
- **Implementation policy distinction**: the source paper's benchmark forecast-based rule (F4) should not be confused with the MMB implementation's simple current-inflation rule (F5).

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII name | Meaning | Equation coverage |
|---|---|---|---|
| Endogenous | `ygap`, \(y_t\) | Output gap | (F1), (F2), (F3), (F4), (F6) |
| Endogenous | `pdot`, \(\pi_t\) | Inflation rate | (F1), (F2), (F3), (F4), (F5) |
| Endogenous | `rff`, \(i_t\) | Short-term nominal policy rate / federal funds rate | (F2), (F3), (F4), (F5) |
| Endogenous | `drff`, \(\Delta i_t\) | Change in the policy rate | (F7) |
| Endogenous / exogenous state | `rstar`, \(r_t^{\ast}\) | Natural real interest rate | (F2), (F8) |
| Endogenous / exogenous state | `pdotsh`, \(\varepsilon_t\) | Inflation / aggregate-supply disturbance | (F1), (F9) |
| Exogenous innovation | `rstar_`, \(\eta^r_t\) | Natural-rate innovation | (F8) |
| Exogenous innovation | `pdotsh_`, \(\eta^\pi_t\) | Inflation-shock innovation | (F9) |
| Parameter | `discountt`, \(\delta\) | Inflation-expectations discount coefficient | (F1) |
| Parameter | `sigma`, \(\sigma\) | IS-curve real-rate sensitivity | (F2) |
| Parameter | `phi`, \(\phi\) | Phillips-curve slope before annualization adjustment | (F1) |
| Parameter | `wtrl` | MMB policy-rule cross-check parameter; not active in `NK_LWW03_rep.mod` model block | needs_review |
| Parameter | `rhorstar`, \(\rho_r\) | Natural-rate AR coefficient | (F8) |
| Parameter | `rhopish`, \(\rho_{\varepsilon}\) | Inflation-shock AR coefficient | (F9) |
| Policy parameter | \(\rho\) | Interest-rate smoothing in the paper's rule class | (F3), (F4) |
| Policy parameter | \(\alpha\) | Response to forecast inflation gap | (F3), (F4) |
| Policy parameter | \(\beta\) | Response to the output-gap forecast/current output gap | (F3), (F4) |
| Policy parameter | \(\theta\) | Inflation forecast horizon | (F3), (F4) |
| Policy parameter | \(\kappa\) | Output-gap forecast horizon | (F3) |
