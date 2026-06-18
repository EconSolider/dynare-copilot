# EA_BF17 - Money And Monetary Policy In The Eurozone: An Empirical Analysis During Crises

> First-pass private archive derivation for `EA_BF17`. Status: `needs_review`.
> Source: Jonathan Benchimol and Andre Fourcans (2017), "Money And Monetary Policy In The Eurozone: An Empirical Analysis During Crises", Macroeconomic Dynamics 21(03), 677-707. DOI: `10.1017/s1365100515000644`.
> Primary Markdown: `raw/mmb_mineru/runs/ea_bf17__money_and_monetary_policy_in_the_eurozone_an_empirical_analysis_during_c__c4e7b84e/full.md`.
> Raw PDF path exists for provenance, but the PDF body was not opened.

## 1. Model Overview

- **Model**: Eurozone small New Keynesian DSGE model used to compare a separable baseline model with a nonseparable money-in-utility model over crisis windows.
- **Paper-side source match**: the first Markdown lines report the expected title and the authors Jonathan Benchimol and Andre Fourcans. OCR has accent artifacts in the author names but no source-title mismatch.
- **Agents**: representative household, monopolistically competitive firms with Calvo pricing, and a central bank setting a smoothed Taylor-type nominal interest-rate rule.
- **Money block**: Model 2 includes nonseparability between consumption and real money balances and a money-augmented monetary policy rule. Model 1 sets the money-related parameters and shocks to zero.
- **Estimated/implemented form**: log-linear `model(linear)` around zero/trend steady states. The article states that the detailed model is in the Online Appendix, which is not present in the MinerU Markdown; therefore the reduced equation block below is `needs_review` and is cross-checked against the MMB implementation only.
- **Runtime validation**: not performed. Dynare was not run, and this derivation was not promoted to the runnable skill archive.

## 2. Optimization Problems

### Household

The source describes two household preference cases. Model 1 omits money from utility. Model 2 uses nonseparable preferences between consumption and real money balances, with relative money weight `b`, inverse substitution parameter `\nu`, and risk-aversion/intertemporal-substitution parameter `\sigma`.

A compact paper-consistent representation for the Model 2 household problem is:

```math
\max_{\{C_t,M_t,B_t,N_t\}} E_0\sum_{t=0}^{\infty}\beta^t
U(C_t,M_t/P_t,N_t;\varepsilon_t^p,\varepsilon_t^m)
```

subject to a nominal budget constraint with consumption, real money balances, one-period nominal bonds, labor income, profits, and transfers:

```math
P_t C_t + M_t + Q_t B_t
\le B_{t-1}+M_{t-1}+W_tN_t+\Pi_t^{div}-T_t.
```

The exact Online Appendix utility aggregator is not in the Markdown and is `needs_review`. The MMB implementation cross-check implies a reduced IS curve and a money-demand relation in which expected output growth, the nominal interest-rate gap, and a money shock affect real money balances.

### Firms

Final output is produced by monopolistically competitive firms using labor and technology. The parameter table identifies `\alpha` as the labor share and `\theta` as the Calvo probability that prices remain unchanged. The source describes a standard New Keynesian sticky-price block and flexible-price counterparts.

The paper-side Markdown does not include the firm's full optimization problem or Calvo reset-price FOC, so the slope formulas in the Phillips curve are `needs_review`.

### Central Bank

The monetary authority follows a smoothed Taylor-type rule with interest-rate smoothing `\lambda_i`, an inflation coefficient `\lambda_\pi`, an output-gap coefficient `\lambda_x`, and, in Model 2, a money-gap coefficient `\lambda_{mp}`.

## 3. First-Order Conditions

The archived system is the nonseparable Model 2 reduced form. Equations are written in log deviations or detrended observable units. Coefficient aliases are functions of the structural parameters in the Online Appendix and are `needs_review` because the Online Appendix equations are not present in the Markdown.

**(F1) Flexible-price output**

```math
y_t^f =
\frac{1+\eta}{D}a_t
+ \frac{(1-\alpha)(\nu-\sigma)(1-a_1)}{D}mp_t^f
- \frac{(1-\alpha)\log\left(\frac{\varepsilon}{\varepsilon-1}\right)}{D}
+ \frac{(1-\alpha)(\nu-\sigma)(1-a_1)}{(1-\nu)D}e_t^m,
```

where

```math
D=\bigl(\nu-(\nu-\sigma)a_1\bigr)(1-\alpha)+\eta+\alpha.
```

The formula follows the reduced flexible-price block indicated by the Markdown's money-shock coefficient discussion and the MMB implementation; source-level coefficient review is required.

**(F2) Flexible-price real money balances**

```math
mp_t^f =
-\frac{a_2\bigl(\nu-(\nu-\sigma)a_1\bigr)}{\nu}E_t[y_{t+1}^f]
+ \left(1+\frac{a_2\bigl(\nu-(\nu-\sigma)a_1\bigr)}{\nu}\right)y_t^f
+ \frac{1}{\nu}e_t^m.
```

**(F3) New Keynesian Phillips curve**

```math
\pi_t=\beta E_t[\pi_{t+1}]
+ \kappa_y(y_t-y_t^f)
+ \kappa_m(mp_t-mp_t^f).
```

The implementation cross-check expands the slopes as functions of `\alpha`, `\theta`, `\beta`, `\nu`, `\sigma`, `a_1`, `\eta`, and the markup shock `e_t^p`; these denominator terms are `needs_review` against the Online Appendix.

**(F4) Dynamic IS curve**

```math
y_t=E_t[y_{t+1}]
-\frac{1}{\nu-a_1(\nu-\sigma)}(r_t-\bar r-E_t[\pi_{t+1}])
+\frac{(\sigma-\nu)(1-a_1)}{\nu-a_1(\nu-\sigma)}E_t[mp_{t+1}-mp_t]
-\frac{(1-a_1)(\nu-\sigma)}{(1-\nu)(\nu-a_1(\nu-\sigma))}E_t[e_{t+1}^m-e_t^m].
```

**(F5) Real money demand**

```math
mp_t=y_t-\frac{a_2}{\nu}(r_t-\bar r)+\frac{1}{\nu}e_t^m.
```

**(F6) Smoothed Taylor rule**

```math
r_t-\bar r=(1-\lambda_i)\left[\lambda_\pi(\pi_t-\bar\pi)+\lambda_x(y_t-y_t^f)+\lambda_{mp}(mp_t-mp_t^f)\right]
+\lambda_i(r_{t-1}-\bar r)+e_t^i.
```

The source text states that Model 2 includes money in the policy rule. The implementation cross-check comments out the money term, so the exact MMB rule variant is `needs_review`.

## 4. Market Clearing & Identities

**(F7) Output gap identity**

```math
ygap_t=y_t-y_t^f.
```

The aggregate resource constraint is not separately reported in the article's Markdown; the reduced log-linear system embeds goods-market clearing in the IS and flexible-output equations. This is a first-pass limitation and remains `needs_review`.

## 5. Exogenous Processes

The source identifies markup, technology, monetary-policy, and money shocks. The MMB cross-check uses AR(1) state variables `ep`, `ei`, `em`, and `at` with innovations `up`, `ui`, `um`, and `ua`.

**(F8) Technology shock**

```math
a_t=\rho_a a_{t-1}+\varepsilon_t^a.
```

**(F9) Markup shock**

```math
e_t^p=\rho_p e_{t-1}^p+\varepsilon_t^p.
```

**(F10) Monetary policy shock**

```math
e_t^i=\rho_i e_{t-1}^i+\varepsilon_t^i.
```

**(F11) Money shock**

```math
e_t^m=\rho_m e_{t-1}^m+\varepsilon_t^m.
```

## 6. Steady-State Solution

Because the implemented model is log-linear, steady-state deviations are zero after subtracting deterministic means or trends:

```math
\bar y=\bar y^f=\overline{mp}=\overline{mp^f}=\bar\pi-\pi^{\ast}=\bar r-r^{\ast}=\overline{ygap}=0.
```

The implementation cross-check sets stationary constants separately:

```math
\bar\pi=pb,\qquad \bar y=yb,\qquad \overline{mp}=mpb,\qquad \bar r=rb.
```

For the active MMB calibration observed in the cross-check:

```math
pb=0.92,\qquad yb=0,\qquad mpb=0,\qquad rb=0.
```

Structural coefficient definitions observed in the implementation are:

```math
a_1=\frac{1}{1+\left(\frac{b}{1-b}\right)^{1-\nu}\left(\frac{1}{1-\exp(-1/\beta)}\right)^{(1-\nu)/\nu}},
\qquad
a_2=\frac{1}{\exp(1/\beta)-1}.
```

The exponential definitions above should be checked against the paper/Online Appendix before moving beyond `needs_review`.

## 7. Timing & Form Conventions

- **Form**: log-linear `model(linear)` reduced system.
- **Expectations**: `E_t[y_{t+1}]`, `E_t[\pi_{t+1}]`, and `E_t[mp_{t+1}]` correspond to Dynare leads in the implementation cross-check.
- **Stocks**: the reduced model has no physical capital stock. Real money balances are jump/state variables governed by the money-demand equation and money shock process rather than by a separate accumulation law.
- **Policy timing**: the Taylor rule includes lagged nominal-rate smoothing through `r_{t-1}`.
- **Shocks**: structural shock states are persistent AR(1) variables, with innovations entering in percentage-scaled form in the implementation cross-check.
- **Source limitation**: because the Online Appendix equations are absent from the Markdown, coefficient-level timing and sign conventions remain `needs_review`.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Determined by |
|---|---|---|---|
| Endogenous | `y`, $`y_t`$ | Output gap/detrended output | (F4) |
| Endogenous | `pi`, $`\pi_t`$ | Inflation | (F3) |
| Endogenous | `r`, $`r_t`$ | Short-term nominal interest rate in deviation form | (F6) |
| Endogenous | `mp`, $`mp_t`$ | Real money balances | (F5) |
| Endogenous | `yf`, $`y_t^f`$ | Flexible-price output | (F1) |
| Endogenous | `mpf`, $`mp_t^f`$ | Flexible-price real money balances | (F2) |
| Endogenous | `ygap`, $`ygap_t`$ | Output gap relative to flexible-price output | (F7) |
| Endogenous shock state | `at`, $`a_t`$ | Technology state | (F8) |
| Endogenous shock state | `ep`, $`e_t^p`$ | Markup/preference state | (F9) |
| Endogenous shock state | `ei`, $`e_t^i`$ | Monetary policy shock state | (F10) |
| Endogenous shock state | `em`, $`e_t^m`$ | Money shock state | (F11) |
| Exogenous innovation | `ua`, $`\varepsilon_t^a`$ | Technology innovation | -- |
| Exogenous innovation | `up`, $`\varepsilon_t^p`$ | Markup/preference innovation | -- |
| Exogenous innovation | `ui`, $`\varepsilon_t^i`$ | Monetary policy innovation | -- |
| Exogenous innovation | `um`, $`\varepsilon_t^m`$ | Money innovation | -- |
| Parameter | `alpha`, $`\alpha`$ | Labor share in production | -- |
| Parameter | `beta`, $`\beta`$ | Discount factor | -- |
| Parameter | `teta`, $`\theta`$ | Calvo no-reset probability | -- |
| Parameter | `vega`, $`\nu`$ | Inverse substitution between consumption and real money balances | -- |
| Parameter | `sigma`, $`\sigma`$ | Risk aversion / inverse intertemporal elasticity | -- |
| Parameter | `b` | Relative weight of real money balances in utility | -- |
| Parameter | `neta`, $`\eta`$ | Inverse Frisch elasticity | -- |
| Parameter | `epsilon`, $`\varepsilon`$ | Elasticity of substitution across goods | -- |
| Parameter | `li1`, $`\lambda_i`$ | Interest-rate smoothing | -- |
| Parameter | `li2`, $`\lambda_\pi`$ | Inflation response | -- |
| Parameter | `li3`, $`\lambda_x`$ | Output-gap response | -- |
| Parameter | `li4`, $`\lambda_{mp}`$ | Money-gap response | -- |
| Parameter | `rhoa`, `rhop`, `rhoi`, `rhom` | Shock persistence parameters | -- |
| Parameter | `pb`, `yb`, `mpb`, `rb` | Linear-model constants / stationary values | -- |
