# US_FRB03 - Derivation (FRB-US Forecast-Based Policy Rule Archive Entry)

> Model archive entry for `US_FRB03`. Status: `needs_review`. Runtime validation was not performed; Dynare was not run.

## 1. Model Overview

- **Model**: Levin, Wieland, and Williams (2003), "The Performance of Forecast-Based Monetary Policy Rules under Model Uncertainty."
- **Model ID**: `US_FRB03`.
- **Source**: `raw/mmb_mineru/runs/nk_lww03_nk_lww03al_us_frb03__the_performance_of_forecast_based_monetary_policy_rules_under_model_unce__c97e3d2f/full.md`; DOI `10.1257/000282803322157016`.
- **Purpose**: Evaluate forecast-based monetary policy rules across five U.S. macroeconomic models and identify robust rule characteristics under model uncertainty.
- **FRB-US role**: One of the four estimated U.S. macroeconometric models. The paper describes the FRB model as having higher-order adjustment costs in prices and spending and a detailed supply side.
- **Agents/blocks**: The article does not provide agent optimization problems for FRB-US. For `US_FRB03`, the usable paper-side structure is the forecast-based policy-rule family, the loss function, determinacy/performance restrictions, and the FRB-US macroeconometric model summary. The `.mod` cross-check confirms a large linearized FRB-US implementation with consumption, investment, housing, labor, prices, fiscal, financial, expectations, and policy blocks.
- **Form**: Linear rational-expectations macroeconometric model. The MMB implementation is a linearized FRB-US model; this entry treats detailed `.mod` equations only as `implementation_cross_check`.

## 2. Optimization Problems

The paper does not state household, firm, government, or financial-intermediary optimization problems for the FRB-US model. The policy maker's optimization problem is stated explicitly:

$$
\min_{\rho,\alpha,\beta,\theta,\kappa}\; \mathcal{L}
\quad\text{s.t.}\quad
\sigma_{\Delta i}\leq \bar{\sigma}_{\Delta i}
\quad\text{and the selected rule yields a unique stationary rational-expectations equilibrium.}
$$

The loss function is the unconditional variance criterion:

$$
\mathcal{L}=\operatorname{Var}(\pi)+\lambda\operatorname{Var}(y).
$$

The robust-rule exercise also minimizes average loss across the five models:

$$
\overline{\mathcal{L}}=\frac{1}{5}\left(\mathcal{L}_{OPT}+\mathcal{L}_{FM}+\mathcal{L}_{FRB}+\mathcal{L}_{MSR}+\mathcal{L}_{TMCM}\right).
$$

No private-sector FOCs are recoverable from the paper-side Markdown for the full FRB-US model. Therefore the numbered equations below are model restrictions, identities, and policy conditions rather than agent-level first-order conditions.

## 3. First-Order Conditions

- **(F1) Forecast-based policy-rule family**:

$$
i_t=\rho i_{t-1}+(1-\rho)\left(r^{\ast}+E_t\tilde{\pi}_{t+\theta}\right)
+\alpha\left(E_t\tilde{\pi}_{t+\theta}-\pi^{\ast}\right)
+\beta E_t y_{t+\kappa}.
$$

Here $i_t$ is the short-term nominal interest rate, $\tilde{\pi}_t$ is the four-quarter average inflation rate, $y_t$ is the output gap, $r^{\ast}$ is the unconditional mean short-term real interest rate, and $\pi^{\ast}$ is the inflation target.

- **(F2) Benchmark estimated federal funds rule**:

$$
i_t=-0.28+0.76 i_{t-1}+0.60\tilde{\pi}_t+0.21y_t+0.97\Delta y_t.
$$

This rule is estimated over U.S. quarterly data for 1980:1-1998:4 and is used to generate the interest-rate volatility bound in the policy optimization.

- **(F3) Policy-maker loss function**:

$$
\mathcal{L}=\operatorname{Var}(\pi)+\lambda\operatorname{Var}(y),\qquad \lambda\in\left\{0,\frac{1}{3},1,3\right\}.
$$

- **(F4) Interest-rate volatility constraint**:

$$
\sigma_{\Delta i}\leq \bar{\sigma}_{\Delta i}.
$$

The paper chooses $\bar{\sigma}_{\Delta i}$ from the volatility induced by the estimated benchmark rule.

- **(F5) Cross-model average-loss criterion**:

$$
\overline{\mathcal{L}}=\frac{1}{5}\left(\mathcal{L}_{OPT}+\mathcal{L}_{FM}+\mathcal{L}_{FRB}+\mathcal{L}_{MSR}+\mathcal{L}_{TMCM}\right).
$$

- **(F6) Robust benchmark forecast-based rule**:

$$
i_t=1.0\,i_{t-1}+0.4\,E_t\left(\tilde{\pi}_{t+4}-\pi^{\ast}\right)+0.4\,y_t.
$$

This is the paper's simple robust benchmark rule, calibrated to be close to the average-loss optimum for $\lambda=1/3$.

- **(F7) FRB optimized-rule rows reported in the paper**:

$$
(\theta,\kappa,\rho,\alpha,\beta)=
\begin{cases}
(4,1,1.28,5.47,0.02), & \lambda=0,\\
(0,2,1.16,1.63,1.46), & \lambda=1/3,\\
(0,2,1.19,1.21,1.97), & \lambda=1,\\
(0,2,1.19,0.74,2.16), & \lambda=3.
\end{cases}
$$

These rows summarize the FRB-US model's optimized forecast horizons and coefficients in the paper's Table 3.

## 4. Market Clearing & Identities

- **(F8) Four-quarter average inflation identity**:

$$
\tilde{\pi}_t=\frac{1}{4}\left(\pi_t+\pi_{t-1}+\pi_{t-2}+\pi_{t-3}\right).
$$

The `.mod` cross-check implements this as the `inflation` modelbase variable from quarterly `picnia`.

- **(F9) Output gap definition**:

$$
y_t=Y_t-Y_t^{pot}.
$$

The paper defines $y_t$ as the deviation of output from potential. The `.mod` cross-check maps the modelbase output gap to `xgap2`, a percent deviation of actual output from trend/potential output.

- **(F10) Change in the output gap**:

$$
\Delta y_t=y_t-y_{t-1}.
$$

This term enters the estimated benchmark rule (F2).

- **(F11) Model-consistent forecasts**:

$$
E_t z_{t+h}=\mathbb{E}\left[z_{t+h}\mid\mathcal{I}_t,\mathcal{M}\right].
$$

The policy-rule forecasts are generated using the information set at time $t$ and the relevant model, with separate model-consistent and model-inconsistent robustness exercises.

- **(F12) FRB-US implementation aggregate-output accounting**:

$$
xgdp_t=s_C\,C_t+s_H\,H_t+s_{E_d}E^d_t+s_{E_s}E^s_t+s_I I_t+s_X X_t+s_M M_t+s_{G_f}G^f_t+s_{G_s}G^s_t.
$$

This compact aggregation is `implementation_cross_check` only. The article does not print the full FRB-US accounting block; the `.mod` confirms a large linearized expenditure aggregation equation for `xgdp`.

## 5. Exogenous Processes

- **(F13) Policy-rule innovation in the implementation**:

$$
i_t=\text{systematic policy rule}_t+\varepsilon^i_t.
$$

The `.mod` cross-check uses `interest_` as the active monetary policy shock for the archived stochastic simulation setup.

- **(F14) Serial-correlation structure for most shocks**:

$$
\varepsilon^j_t \sim \text{i.i.d.},\qquad j\in\mathcal{J}.
$$

The paper states that nearly all shocks used for unconditional moments in the four macroeconometric models are serially uncorrelated.

- **(F15) Term-premium shock exceptions**:

$$
s^b_t=\rho_b s^b_{t-1}+\varepsilon^b_t.
$$

The paper notes exceptions for term-premium shocks in some financial variables in FRB and TMCM. The `.mod` cross-check has AR coefficients for bond/equity residual states such as `rg5es`, `rg10es`, `rcbes`, and `lwpss`.

- **(F16) Trend inflation and equilibrium real-rate persistence in the implementation**:

$$
\pi^{\ast}_t=\rho_{\pi^{\ast}}\pi^{\ast}_{t-1}+(1-\rho_{\pi^{\ast}})\bar{\pi}^{\ast}_t,\qquad
r^{\ast}_t=\rho_{r^{\ast}}r^{\ast}_{t-1}+(1-\rho_{r^{\ast}})(i_t-\pi_t)+\text{optional gap term}.
$$

This condition is `implementation_cross_check` only. The paper-side benchmark rule uses constant $r^{\ast}$ and $\pi^{\ast}$ notation, while the `.mod` includes persistent `pitarg`, `ptr`, `rstar`, and `rtr` blocks.

## 6. Steady-State Solution

Because the FRB-US model is used in linearized form, the derivation-level steady state is expressed as deviations from the model baseline.

1. Set all innovations to zero:

$$
\varepsilon^i_t=0,\qquad \varepsilon^j_t=0\quad\forall j.
$$

2. Set gap variables to their baseline values:

$$
y_t=\Delta y_t=0,\qquad \pi_t=\tilde{\pi}_t=\pi^{\ast},\qquad i_t=r^{\ast}+\pi^{\ast}.
$$

3. For the benchmark rule (F2), the intercept and historical-data units imply that the numerical steady state must be checked against the original FRB-US baseline and the paper's annual-rate convention:

$$
i=(1-0.76)^{-1}\left[-0.28+0.60\pi^{\ast}+0.21y+0.97\Delta y\right].
$$

4. For the robust benchmark rule (F6), if $y_t=0$ and $\tilde{\pi}_{t+4}=\pi^{\ast}$, the rule preserves the inherited steady nominal interest rate:

$$
i_t=i_{t-1}=r^{\ast}+\pi^{\ast}.
$$

5. For `.mod` implementation variables, use the Rep-MMB calibration and linear model baseline. Exact steady-state constants for all FRB-US internal variables are deferred to a source-level review of the FRB-US documentation and implementation files; no Dynare `steady` check was run.

## 7. Timing & Form Conventions

- **Frequency and units**: Quarterly data; interest rates and inflation are measured at annual rates in percentage points in the paper.
- **Expectations**: $E_t$ denotes forecasts conditional on information available at time $t$.
- **Forecast horizons**: $\theta$ and $\kappa$ are measured in quarters. The robust benchmark uses $\theta=4$ and $\kappa=0$.
- **Model form**: Linear rational-expectations macroeconometric model. The MMB implementation is a linearized FRB-US model and is not a nonlinear optimization-based DSGE system in this source.
- **Stock/timing convention**: The paper-side Markdown does not print stock timing for the full FRB-US model. The `.mod` cross-check contains many lagged stocks and forward-looking expectation terms, but those details remain `needs_review` until checked against FRB-US documentation.
- **Source boundary**: `.agents/skills/dynare-copilot/references/examples/US_FRB03_rep.mod` was used only to identify coverage, naming, timing clues, and implementation conventions. It is not treated as the paper-side mathematical source.
- **Runtime validation**: Not performed. No Dynare run, BK check, residual check, or IRF validation was executed.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII name | Meaning | Source role | Determined by |
|---|---|---|---|---|
| Endogenous policy variable | $i_t$ / `interest`, `rffe` | Short-term nominal interest rate / federal funds rate | Paper and implementation | (F1), (F2), (F6), (F13) |
| Endogenous macro variable | $\pi_t$ / `inflationq`, `picnia` | One-quarter annualized inflation | Paper and implementation | (F3), (F8) |
| Endogenous macro variable | $\tilde{\pi}_t$ / `inflation` | Four-quarter average inflation | Paper and implementation | (F1), (F8) |
| Endogenous macro variable | $y_t$ / `outputgap`, `xgap2` | Output gap | Paper and implementation | (F1), (F2), (F9), (F10) |
| Endogenous macro variable | $\Delta y_t$ | Change in output gap | Paper | (F2), (F10) |
| Endogenous aggregate | $Y_t$ / `output`, `xgdp` | Output / real GDP aggregate | Implementation cross-check | (F12) |
| Policy target | $\pi^{\ast}$ / `pitarg`, `ptr` | Inflation target / trend inflation | Paper and implementation | (F1), (F6), (F16) |
| Policy baseline | $r^{\ast}$ / `rstar`, `rtr` | Unconditional mean short-term real rate | Paper and implementation | (F1), (F16) |
| Expectation object | $E_t\tilde{\pi}_{t+\theta}$ | Inflation forecast used in the policy rule | Paper | (F1), (F11) |
| Expectation object | $E_t y_{t+\kappa}$ | Output-gap forecast used in the policy rule | Paper | (F1), (F11) |
| Exogenous shock | $\varepsilon^i_t$ / `interest_` | Monetary-policy innovation | Implementation cross-check | (F13) |
| Exogenous shocks | $\varepsilon^j_t$ | Other model innovations | Paper and implementation | (F14), (F15) |
| Parameter | $\rho$ / `tayr1` | Interest-rate smoothing | Paper and implementation | (F1), (F7) |
| Parameter | $\alpha$ / `tayp*` | Inflation-forecast response | Paper and implementation | (F1), (F7) |
| Parameter | $\beta$ / `tayx*` | Output-gap response | Paper and implementation | (F1), (F7) |
| Parameter | $\theta$ | Inflation forecast horizon in quarters | Paper | (F1), (F7) |
| Parameter | $\kappa$ | Output-gap forecast horizon in quarters | Paper | (F1), (F7) |
| Parameter | $\lambda$ | Output-variance weight in loss function | Paper | (F3), (F5) |
| Parameter | $\bar{\sigma}_{\Delta i}$ | Interest-rate volatility upper bound | Paper | (F4) |
| Status marker | `needs_review` | First-pass extraction; formula and source coverage not fully checked | Archive | - |
