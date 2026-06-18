# NK_LWW03AL - Derivation (Adaptive-Learning Optimizing AD-AS Entry)

> Model archive entry for `NK_LWW03AL`. Status: `needs_review`. This first-pass derivation extracts the small optimizing AD-AS model and the adaptive-learning implementation clues from Levin, Wieland, and Williams (2003). Runtime validation was not performed; Dynare was not run.

## 1. Model Overview

- **Model**: `NK_LWW03AL`, the adaptive-learning version of the small optimizing AD-AS model used in Levin, Wieland, and Williams (2003), "The performance of forecast-based monetary policy rules under model uncertainty."
- **Paper**: Andrew Levin, Volker Wieland, and John C. Williams (2003), *American Economic Review* 93(3), 622-645, DOI `10.1257/000282803322157016`.
- **Primary source**: `raw/mmb_mineru/runs/nk_lww03_nk_lww03al_us_frb03__the_performance_of_forecast_based_monetary_policy_rules_under_model_unce__c97e3d2f/full.md`; raw PDF recorded at `raw/mmb_papers/The Performance of Forecast-Based Monetary Policy Rules under Model Uncertainty.pdf`.
- **Purpose**: The paper compares forecast-based monetary policy rules across five U.S. models. The `NK_LWW03AL` archive entry corresponds to the small stylized optimizing AD-AS model, with MMB metadata marking this implementation as the adaptive-learning (`AL`) variant.
- **Agents/blocks**: The paper-side model is a two-equation rational-expectations New Keynesian AD-AS system: a forward-looking Phillips curve, an expectational IS curve, a natural-real-rate process, an aggregate-supply disturbance, and an interest-rate rule. The adaptive-learning specifics are not derived in the paper text; they are recorded below only from MMB implementation cross-check files.
- **Form**: Linearized quarterly New Keynesian model (`model(linear)` in the MMB implementation). Variables are annual-rate percentage-point deviations or gaps. The `AL` variant remains `needs_review` because the paper-side Markdown states the rational-expectations model, while the local MMB files identify the adaptive-learning setup.

## 2. Optimization Problems

The paper states that the two private-sector structural equations are derived from optimizing-agent behavior, but it does not print household and firm problems. A source-faithful archive entry therefore records the implied optimization blocks at a reduced-form level:

- **Representative household / aggregate demand block**: intertemporal consumption-saving choice implies an expectational IS curve in the output gap, the real policy rate, and the natural real rate.
- **Price-setting / aggregate supply block**: staggered nominal price setting implies a forward-looking Phillips curve linking current inflation to expected future inflation, the output gap, and a supply disturbance.
- **Policy maker**: chooses policy-rule horizons and coefficients to minimize unconditional inflation and output-gap variance subject to an interest-rate-volatility bound and determinacy.

The policy-maker problem is:

```math
\min_{\rho,\alpha,\beta,\theta,\kappa}\; \mathcal{L}
\quad\text{s.t.}\quad
\sigma_{\Delta i}\leq \bar{\sigma}_{\Delta i}
\quad\text{and a unique stationary rational-expectations equilibrium.}
```

The loss function is:

```math
\mathcal{L}=\operatorname{Var}(\pi)+\lambda\operatorname{Var}(y).
```

The cross-model robust-rule exercise uses:

```math
\overline{\mathcal{L}}=\frac{1}{5}\left(\mathcal{L}_{OPT}+\mathcal{L}_{FM}+\mathcal{L}_{FRB}+\mathcal{L}_{MSR}+\mathcal{L}_{TMCM}\right).
```

## 3. First-Order Conditions

- **(F1) Forward-looking aggregate supply / New Keynesian Phillips curve**:

```math
\pi_t=\delta E_t\pi_{t+1}+\phi y_t+\varepsilon_t.
```

The paper labels this equation as aggregate supply for the optimizing AD-AS model. In the local implementation, `pdot` is quarterly inflation and `pdotsh` is the markup/supply disturbance.

- **(F2) Expectational IS curve / aggregate demand**:

```math
y_t=E_t y_{t+1}-\sigma\left(i_t-E_t\pi_{t+1}-r_t^{\ast}\right).
```

The policy rate, expected inflation, and natural real rate determine the output gap.

- **(F3) Forecast-based policy-rule family**:

```math
i_t=\rho i_{t-1}+(1-\rho)\left(r^{\ast}+E_t\tilde{\pi}_{t+\theta}\right)
+\alpha\left(E_t\tilde{\pi}_{t+\theta}-\pi^{\ast}\right)
+\beta E_t y_{t+\kappa}.
```

The variables are annual-rate percentage points. $`\theta`$ and $`\kappa`$ are forecast horizons in quarters.

- **(F4) Estimated benchmark federal-funds rule**:

```math
i_t=-0.28+0.76 i_{t-1}+0.60\tilde{\pi}_t+0.21y_t+0.97\Delta y_t.
```

The MMB `NK_LWW03AL` cross-check maps this rule into the general policy-rule coefficient vector with interest-rate smoothing, four-quarter inflation averaging, and a change-in-output-gap term.

- **(F5) Policy-maker loss function**:

```math
\mathcal{L}=\operatorname{Var}(\pi)+\lambda\operatorname{Var}(y),\qquad
\lambda\in\left\{0,\frac{1}{3},1,3\right\}.
```

- **(F6) Interest-rate-volatility constraint**:

```math
\sigma_{\Delta i}\leq \bar{\sigma}_{\Delta i}.
```

- **(F7) Cross-model average-loss criterion**:

```math
\overline{\mathcal{L}}=\frac{1}{5}\left(\mathcal{L}_{OPT}+\mathcal{L}_{FM}+\mathcal{L}_{FRB}+\mathcal{L}_{MSR}+\mathcal{L}_{TMCM}\right).
```

- **(F8) Robust benchmark forecast-based rule**:

```math
i_t=1.0\,i_{t-1}+0.4\,E_t\left(\tilde{\pi}_{t+4}-\pi^{\ast}\right)+0.4\,y_t.
```

- **(F9) Optimizing AD-AS optimized-rule rows from Table 3**:

```math
(\theta,\kappa,\rho,\alpha,\beta)=
\begin{cases}
(0,1,0.78,16.55,-0.64), & \lambda=0,\\
(0,0,1.57,7.27,6.12), & \lambda=1/3,\\
(0,0,1.55,3.04,6.23), & \lambda=1,\\
(0,0,1.55,1.49,6.26), & \lambda=3.
\end{cases}
```

These rows summarize the paper's optimized forecast horizons and coefficients for the optimizing AD-AS model. They are not an adaptive-learning law of motion.

## 4. Market Clearing & Identities

- **(F10) Four-quarter average inflation identity**:

```math
\tilde{\pi}_t=\frac{1}{4}\left(\pi_t+\pi_{t-1}+\pi_{t-2}+\pi_{t-3}\right).
```

The MMB `NK_LWW03AL` implementation introduces `pinf4`, `inflationql`, and `inflationql2` to support this identity and the adaptive-learning information set.

- **(F11) Output-gap change**:

```math
\Delta y_t=y_t-y_{t-1}.
```

This term enters the benchmark rule.

- **(F12) Modelbase variable mapping, implementation_cross_check**:

```math
\text{interest}_t=rff_t,\qquad
\text{inflationq}_t=pdot_t,\qquad
\text{outputgap}_t=ygap_t,\qquad
\text{output}_t=ygap_t.
```

The final equality is an MMB interface convention for this small gap model, not an additional paper-side resource constraint.

## 5. Exogenous Processes

- **(F13) Natural real-rate process**:

```math
r_t^{\ast}=\rho_{r^{\ast}}r_{t-1}^{\ast}+\eta_t^r,\qquad \rho_{r^{\ast}}=0.35.
```

The paper states that the natural real-rate innovation has standard deviation 3.72.

- **(F14) Aggregate-supply disturbance**:

```math
\varepsilon_t=\rho_{\varepsilon}\varepsilon_{t-1}+\eta_t^{\pi}.
```

The paper says the aggregate-supply disturbance is i.i.d. and calibrated to match inflation variance under the benchmark estimated rule. The MMB implementation sets $`\rho_{\varepsilon}=0`$ and uses a price-markup shock `pdotsh_`.

- **(F15) Policy-rule innovation, implementation_cross_check**:

```math
i_t=\text{systematic policy rule}_t+\eta_t^i.
```

The MMB `NK_LWW03AL` files expose `interest_` as the modelbase monetary-policy shock, although the checked stochastic specification sets its variance to zero in the archived model file.

## 6. Steady-State Solution

Because the model is linearized, the derivation-level steady state sets all gaps, deviations, and innovations to zero except for exogenous policy targets embedded in annual-rate constants.

1. Set shocks to zero:

```math
\eta_t^r=0,\qquad \eta_t^{\pi}=0,\qquad \eta_t^i=0.
```

2. Set gap variables and inflation deviations at baseline:

```math
y_t=0,\qquad \Delta y_t=0,\qquad \pi_t=\tilde{\pi}_t=\pi^{\ast}.
```

3. The natural real-rate process implies:

```math
r_t^{\ast}=0
```

when it is represented as a deviation from its unconditional mean.

4. For the robust benchmark rule, if $`y_t=0`$ and $`\tilde{\pi}_{t+4}=\pi^{\ast}`$, the rule preserves the inherited nominal-interest-rate baseline:

```math
i_t=i_{t-1}.
```

5. For the estimated benchmark rule, the constant and annual-rate units require source-level baseline review:

```math
i=(1-0.76)^{-1}\left[-0.28+0.60\pi^{\ast}+0.21y+0.97\Delta y\right].
```

The exact adaptive-learning steady-state and initial-belief conventions are deferred because no Dynare run or AL simulation validation was performed.

## 7. Timing & Form Conventions

- **Frequency and units**: Quarterly model; interest rates and inflation are annual-rate percentage points in the paper.
- **Expectations**: $`E_t`$ denotes forecasts conditional on information at time $`t`$. In the paper equations this is rational expectations; the MMB `AL` implementation adds an adaptive-learning information set.
- **Forecast horizons**: $`\theta`$ and $`\kappa`$ are measured in quarters. The robust benchmark uses $`\theta=4`$ and $`\kappa=0`$.
- **Model form**: Linearized New Keynesian AD-AS model (`model(linear)` in the implementation).
- **Stock variables**: The small paper-side model has no explicit capital or other physical stock accumulation. Lagged interest rates, lagged inflation terms, and lagged output gaps are policy-rule and information-state lags rather than capital-in-production timing.
- **Adaptive-learning convention, implementation_cross_check**: `raw/mmb/mmci-cli/models/NK_LWW03AL/NK_LWW03AL.json` marks `"al": true`; the `.mod` saves `AL_Info` with forward variables `ygap`, `pdot`, and `inflationq`, long states `rstar`, `interest`, `inflationq`, `inflationql`, and `inflationql2`, and short states `interest` and `outputgap`.
- **Source boundary**: `raw/mmb/mmci-cli/models/NK_LWW03AL/NK_LWW03AL.mod` and `.json` were read only as `implementation_cross_check`. They were not treated as paper-side mathematical sources, and Dynare was not run.
- **Runtime validation**: Not performed. No residual, steady-state, Blanchard-Kahn, adaptive-learning, or IRF validation was executed.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII name | Meaning | Source role | Determined by |
|---|---|---|---|---|
| Endogenous gap | $`y_t`$ / `ygap`, `outputgap`, `output` | Output gap | Paper and implementation | (F2), (F4), (F8), (F11), (F12) |
| Endogenous inflation | $`\pi_t`$ / `pdot`, `inflationq` | Quarterly annualized inflation | Paper and implementation | (F1), (F2), (F10), (F12), (F14) |
| Endogenous smoothed inflation | $`\tilde{\pi}_t`$ / `pinf4`, `inflation` | Four-quarter average inflation | Paper and implementation | (F3), (F4), (F8), (F10) |
| Endogenous policy rate | $`i_t`$ / `rff`, `interest` | Short-term nominal interest rate | Paper and implementation | (F2), (F3), (F4), (F8), (F12), (F15) |
| Endogenous change | $`\Delta y_t`$ | Change in output gap | Paper and implementation | (F4), (F11) |
| Endogenous change | $`\Delta i_t`$ / `drff` | Change in policy rate | Implementation cross-check | (F6) |
| Exogenous state | $`r_t^{\ast}`$ / `rstar` | Natural real interest rate | Paper and implementation | (F2), (F13) |
| Exogenous shock | $`\eta_t^r`$ / `rstar_` | Natural-rate innovation | Paper and implementation | (F13) |
| Exogenous shock | $`\eta_t^\pi`$ / `pdotsh_` | Aggregate-supply / markup innovation | Paper and implementation | (F1), (F14) |
| Exogenous shock | $`\eta_t^i`$ / `interest_` | Monetary-policy innovation | Implementation cross-check | (F15) |
| Parameter | $`\delta`$ / `discountt` | Inflation-expectation discount coefficient | Paper and implementation | (F1) |
| Parameter | $`\sigma`$ / `sigma` | IS-curve real-rate sensitivity | Paper and implementation | (F2) |
| Parameter | $`\phi`$ / `phi` | Output-gap slope in Phillips curve | Paper and implementation | (F1) |
| Parameter | $`\rho`$ | Interest-rate smoothing in policy rule | Paper and implementation | (F3), (F4), (F8), (F9) |
| Parameter | $`\alpha`$ | Inflation-response coefficient in policy rule | Paper and implementation | (F3), (F8), (F9) |
| Parameter | $`\beta`$ | Output-gap response coefficient in policy rule | Paper and implementation | (F3), (F8), (F9) |
| Parameter | $`\theta`$ | Inflation forecast horizon | Paper | (F3), (F9) |
| Parameter | $`\kappa`$ | Output-gap forecast horizon | Paper | (F3), (F9) |
| Parameter | $`\lambda`$ | Output-variance weight in loss function | Paper | (F5), (F7), (F9) |
| Parameter | $`\bar{\sigma}_{\Delta i}`$ | Interest-rate-volatility bound | Paper | (F6) |
| Status marker | `needs_review` | First-pass source and adaptive-learning variant review is incomplete | Archive | - |
