# US_BR13 -- Derivation

> Source-backed archive draft for the MMB model `US_BR13`. Runtime validation was not performed.

## 1. Model Overview

- **Model**: Blanchard and Riggi (2013), "Why are the 2000s so different from the 1970s?"
- **Model family**: United States log-linear New Keynesian model used for minimum-distance matching of oil-price-shock IRFs across 1960:Q1-1983:Q4 and 1984:Q1-2007:Q3.
- **Agents and blocks**: households with habit formation, monopolistically competitive firms using labor and imported oil, Calvo domestic-goods price setting, a monetary authority with a Taylor rule, and an exogenous real oil-price process.
- **Core mechanisms**: oil in production and consumption, real wage rigidity, imperfect credibility in inflation expectations, and nominal price rigidity.
- **Source provenance**: primary Markdown `raw/mmb_mineru/runs/us_br13__why_are_the_2000s_so_different_from_the_1970s__5227bf28/full.md`; raw PDF `raw/mmb_papers/Why are the 2000s so different from the 1970s?.pdf`; MinerU run id `5227bf28-1ed1-42e5-9235-36552bd5505b`; DOI not recorded in `raw/mmb_mineru/model_index.csv`.
- **Form**: log-linear. The paper states that lowercase variables are deviations from steady state and hatted variables are proportional deviations from steady state. This entry records the benchmark Cobb-Douglas technology; robustness variants are noted but not folded into the benchmark equation count.

## 2. Optimization Problems

The local paper Markdown gives the implied log-linear equations, not full nonlinear optimization problems. The paper says the full derivation is in the Online Appendix, which is not present as a separate local normalization for `US_BR13`. The following problems therefore summarize the optimization structure implied by the model equations and are marked `needs_review` for source-level appendix confirmation.

### 2.1 Households

Households choose consumption and labor with external habit formation. The implied intertemporal problem is:

```math
\max_{\{C_t,N_t,B_t\}} E_0\sum_{t=0}^{\infty}\beta^t
U(C_t-hC_{t-1},N_t)
```

subject to a standard intertemporal budget constraint. The local source reports the resulting log-linear Euler equation and the real supply wage relation rather than the primitive nonlinear budget constraint.

### 2.2 Firms

Domestic firms are monopolistic competitors and use labor and imported oil. Production is Cobb-Douglas:

```math
\hat q_t=\alpha_n\hat n_t+\alpha_m\hat m_t.
```

Cost minimization yields oil demand and a factor-price frontier. Calvo price setting yields a log-linear New Keynesian Phillips curve in domestic-goods inflation.

### 2.3 Monetary Authority and Expectations

The central bank follows an inertial Taylor rule responding to domestic inflation and a welfare-relevant output gap. Agents' inflation expectations combine model-consistent expectations and current inflation, with credibility parameter $`\lambda`$.

## 3. First-Order Conditions

- **(F1) Gross production technology**:

```math
\hat q_t=\alpha_n\hat n_t+\alpha_m\hat m_t.
```

- **(F2) Consumption aggregator**:

```math
\hat c_t=(1-\chi)\hat c_{q,t}+\chi\hat c_{m,t}.
```

- **(F3) Consumption price index**:

```math
\hat p_{c,t}=\hat p_{q,t}+\chi\hat s_t,
\qquad
\hat s_t\equiv \hat p_{m,t}-\hat p_{q,t}.
```

- **(F4) Household Euler equation with habit**:

```math
\hat c_t=\frac{h}{1+h}\hat c_{t-1}
+\frac{1}{1+h}E_t\hat c_{t+1}
-\frac{1-h}{(1+h)\sigma}
\left(i_t-\hat\pi^e_{c,t+1}+\log\beta\right).
```

- **(F5) Real supply wage / labor supply with real wage rigidity**:

```math
\hat w_t-\hat p_{c,t}
=\gamma(\hat w_{t-1}-\hat p_{c,t-1})
+(1-\gamma)\left\{\varphi\hat n_t+
\frac{\sigma}{1-h}(\hat c_t-h\hat c_{t-1})\right\}.
```

- **(F6) Firm oil demand from cost minimization**:

```math
\hat m_t=-\hat\mu_t-\hat s_t+\hat q_t.
```

- **(F7) Reduced-form production after eliminating oil**:

```math
\hat q_t=\frac{1}{1-\alpha_m}
\left(\alpha_n\hat n_t-\alpha_m\hat s_t-\alpha_m\hat\mu_t\right).
```

- **(F8) Factor-price frontier**:

```math
(1-\alpha_m)(\hat w_t-\hat p_{c,t})
+[\alpha_m+(1-\alpha_m)\chi]\hat s_t
+(1-\alpha_n-\alpha_m)\hat n_t+\hat\mu_t=0.
```

- **(F9) Domestic-goods Phillips curve**:

```math
\hat\pi_{q,t}=\beta\hat\pi^e_{q,t+1}-\lambda_p\hat\mu_t,
```

with

```math
\lambda_p=
\frac{(1-\theta)(1-\beta\theta)}{\theta}
\frac{\alpha_m+\alpha_n}
{1+(1-\alpha_m-\alpha_n)(\epsilon-1)}.
```

## 4. Market Clearing & Identities

- **(F10) Balanced-trade relation between consumption and gross output**:

```math
\hat c_t=\hat q_t-\chi\hat s_t+\eta\hat\mu_t,
\qquad
\eta\equiv\frac{\alpha_m}{\mathcal M-\alpha_m}.
```

- **(F11) Consumption-employment relation**:

```math
\hat c_t=
\frac{\alpha_n}{1-\alpha_m}\hat n_t
-\left(\chi+\frac{\alpha_m}{1-\alpha_m}\right)\hat s_t
+\left(\eta-\frac{\alpha_m}{1-\alpha_m}\right)\hat\mu_t.
```

- **(F12) Value-added deflator identity**:

```math
\hat p_{y,t}=\hat p_{q,t}-\frac{\alpha_m}{1-\alpha_m}\hat s_t.
```

- **(F13) GDP and gross-output identity**:

```math
\hat y_t=\hat q_t+\frac{\alpha_m}{1-\alpha_m}\hat s_t+\eta\hat\mu_t.
```

- **(F14) Taylor rule**:

```math
i_t=\rho_i i_{t-1}+
(1-\rho_i)\left(-\log\beta+\varphi_\pi\hat\pi_{q,t}
+\varphi_x\hat x^f_t\right).
```

- **(F15) Domestic inflation expectations and credibility**:

```math
\hat\pi^e_{q,t+1}=(1-\lambda)\hat\pi_{q,t}
+\lambda E_t\hat\pi_{q,t+1}.
```

- **(F16) Consumption inflation expectations**:

```math
\hat\pi^e_{c,t+1}
=\hat\pi^e_{q,t+1}+\chi E_t(\hat s_{t+1}-\hat s_t).
```

- **(F17) Flexible-price employment law of motion**:

```math
\hat n_t=\Gamma_1\hat s_t+\Gamma_2\hat s_{t-1}+\Gamma_3\hat n_{t-1}.
```

where

```math
\Gamma_1=
\frac{[\sigma(1-\gamma)-(1-h)][\alpha_m+\chi(1-\alpha_m)]}
{\varphi(1-\gamma)(1-h)(1-\alpha_m)+\sigma\alpha_n(1-\gamma)+(1-h)(1-\alpha_m-\alpha_n)},
```

```math
\Gamma_2=
\frac{[(1-h)\gamma-\sigma h(1-\gamma)][\alpha_m+\chi(1-\alpha_m)]}
{\varphi(1-\gamma)(1-h)(1-\alpha_m)+\sigma\alpha_n(1-\gamma)+(1-h)(1-\alpha_m-\alpha_n)},
```

```math
\Gamma_3=
\frac{\gamma(1-\alpha_m-\alpha_n)(1-h)+\sigma h\alpha_n(1-\gamma)}
{\varphi(1-\gamma)(1-h)(1-\alpha_m)+\sigma\alpha_n(1-\gamma)+(1-h)(1-\alpha_m-\alpha_n)}.
```

The welfare-relevant output gap $`\hat x^f_t`$ in (F14) is the wedge between actual output and efficient output. The source points to Online Appendix C for its derivation; the appendix is not locally available, so the precise implementation of $`\hat x^f_t`$ is `needs_review`.

## 5. Exogenous Processes

- **(F18) Real oil-price process**:

```math
\hat s_t=\rho_s\hat s_{t-1}+\varepsilon^s_t.
```

The empirical exercise treats the real oil-price shock as exogenous relative to contemporaneous domestic variables. The paper calibrates $`\rho_s=0.999`$ so the real oil price is close to a random walk while stationary.

## 6. Steady-State Solution

Because the model is log-linear, the steady state for all deviation variables is zero:

```math
\hat q=\hat n=\hat m=\hat c=\hat c_q=\hat c_m=\hat p_c=\hat p_q
=\hat p_m=\hat s=\hat w=\hat\mu=\hat\pi_q=\hat\pi_c=\hat y=i-\bar i=0.
```

The nominal interest-rate intercept in the Taylor rule is chosen so that zero inflation is consistent with:

```math
\bar i=-\log\beta.
```

The benchmark calibration and estimates reported in the source are:

| Parameter | Pre-1984 | Post-1984 | Source role |
|---|---:|---:|---|
| $`\alpha_m`$ | 0.015 | 0.012 | oil share in production, calibrated |
| $`\chi`$ | 0.023 | 0.017 | oil share in consumption, calibrated |
| $`\alpha_n`$ | $`1-\alpha_m`$ | $`1-\alpha_m`$ | short-run constant returns to labor and oil |
| $`\rho_s`$ | 0.999 | 0.999 | oil-price persistence |
| $`\beta`$ | 0.99 | 0.99 | discount factor |
| $`\epsilon`$ | 6.0 | 6.0 | substitution elasticity / 20 percent desired markup |
| $`\varphi`$ | 1.0 | 1.0 | inverse Frisch elasticity |
| $`h`$ | 0.8 | 0.8 | habit |
| $`\sigma`$ | 0.39 | 0.26 | estimated risk aversion |
| $`\gamma`$ | 0.97 | 0.00 | estimated real wage rigidity |
| $`\theta`$ | 0.96 | 0.59 | estimated price stickiness |
| $`\varphi_\pi`$ | 1.33 | 1.08 | Taylor coefficient on inflation |
| $`\varphi_x`$ | 0.00 | 0.00 | Taylor coefficient on output gap |
| $`\rho_i`$ | 0.49 | 0.54 | policy inertia |
| $`\lambda`$ | 0.00 | 1.00 | central-bank credibility |

## 7. Timing & Form Conventions

- **Frequency**: quarterly.
- **Samples**: pre-1984 sample is 1960:Q1-1983:Q4; post-1984 sample is 1984:Q1-2007:Q3 in the structural estimation paragraph, while the VAR discussion describes 1984:Q1-2007:Q4. This discrepancy is recorded as `needs_review`.
- **Linearization**: all equations are log-linear or deviations from steady state. Hatted variables are proportional deviations from steady state; lowercase non-hatted variables are deviations from steady state.
- **Expectations**: $`E_t`$ denotes model-consistent expectations; $`\hat\pi^e`$ variables are perceived expectations that can combine current inflation with rational expectations through $`\lambda`$.
- **Stocks**: the benchmark model has no capital stock. The main persistent states are lagged consumption, lagged real consumption wage, lagged nominal interest rate, lagged real oil price, and lagged flexible-price employment.
- **Implementation cross-check**: no `.agents/skills/dynare-copilot/references/examples/US_BR13_rep.mod` file exists in this checkout, so no `.mod` cross-check was used.
- **Runtime validation**: not performed; Dynare was not run.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII name | Meaning | Equation reference |
|---|---|---|---|
| Endogenous | `q_hat` / $`\hat q_t`$ | gross domestic output | (F1), (F7), (F10), (F13) |
| Endogenous | `n_hat` / $`\hat n_t`$ | employment / labor | (F1), (F5), (F7), (F8), (F11), (F17) |
| Endogenous | `m_hat` / $`\hat m_t`$ | imported oil used in production | (F1), (F6) |
| Endogenous | `c_hat` / $`\hat c_t`$ | aggregate consumption | (F2), (F4), (F10), (F11) |
| Endogenous | `cq_hat` / $`\hat c_{q,t}`$ | domestic-good consumption component | (F2) |
| Endogenous | `cm_hat` / $`\hat c_{m,t}`$ | imported-oil consumption component | (F2) |
| Endogenous | `pc_hat` / $`\hat p_{c,t}`$ | consumption price | (F3), (F5), (F16) |
| Endogenous | `pq_hat` / $`\hat p_{q,t}`$ | domestic output price | (F3), (F12) |
| Endogenous | `pm_hat` / $`\hat p_{m,t}`$ | imported oil price | (F3) |
| Endogenous | `s_hat` / $`\hat s_t`$ | real price of oil | (F3), (F6)-(F8), (F10)-(F13), (F16)-(F18) |
| Endogenous | `w_hat` / $`\hat w_t`$ | nominal wage | (F5), (F8) |
| Endogenous | `mu_hat` / $`\hat\mu_t`$ | price markup deviation | (F6)-(F13) |
| Endogenous | `piq_hat` / $`\hat\pi_{q,t}`$ | domestic-goods inflation | (F9), (F14), (F15) |
| Endogenous | `pic_exp_hat` / $`\hat\pi^e_{c,t+1}`$ | expected consumption inflation | (F4), (F16) |
| Endogenous | `piq_exp_hat` / $`\hat\pi^e_{q,t+1}`$ | expected domestic inflation | (F9), (F15), (F16) |
| Endogenous | `y_hat` / $`\hat y_t`$ | GDP / value added | (F13) |
| Endogenous | `py_hat` / $`\hat p_{y,t}`$ | value-added deflator | (F12) |
| Endogenous | `i` / $`i_t`$ | nominal interest rate | (F4), (F14) |
| Endogenous | `xf_hat` / $`\hat x^f_t`$ | welfare-relevant output gap | (F14), `needs_review` |
| Exogenous | `eps_s` / $`\varepsilon^s_t`$ | real oil-price innovation | (F18) |
| Parameter | `alpha_n` / $`\alpha_n`$ | labor share in production | (F1), (F7), (F8), (F11), (F17) |
| Parameter | `alpha_m` / $`\alpha_m`$ | oil share in production | (F1), (F7), (F8), (F10)-(F13), (F17) |
| Parameter | `chi` / $`\chi`$ | oil share in consumption | (F2), (F3), (F8), (F10), (F11), (F16), (F17) |
| Parameter | `beta` / $`\beta`$ | discount factor | (F4), (F9), (F14) |
| Parameter | `sigma` / $`\sigma`$ | risk aversion | (F4), (F5), (F17) |
| Parameter | `h` / $`h`$ | habit parameter | (F4), (F5), (F17) |
| Parameter | `gamma` / $`\gamma`$ | real wage rigidity | (F5), (F17) |
| Parameter | `varphi` / $`\varphi`$ | inverse Frisch elasticity | (F5), (F17) |
| Parameter | `theta` / $`\theta`$ | Calvo price stickiness | (F9) |
| Parameter | `epsilon` / $`\epsilon`$ | elasticity of substitution | (F9) |
| Parameter | `lambda_p` / $`\lambda_p`$ | Phillips-curve slope | (F9) |
| Parameter | `eta` / $`\eta`$ | balanced-trade markup coefficient | (F10), (F11), (F13) |
| Parameter | `markup_ss` / $`\mathcal M`$ | desired gross markup | (F10) |
| Parameter | `rho_i` / $`\rho_i`$ | interest-rate smoothing | (F14) |
| Parameter | `phi_pi` / $`\varphi_\pi`$ | Taylor response to inflation | (F14) |
| Parameter | `phi_x` / $`\varphi_x`$ | Taylor response to output gap | (F14) |
| Parameter | `lambda_cred` / $`\lambda`$ | monetary-policy credibility | (F15) |
| Parameter | `rho_s` / $`\rho_s`$ | real oil-price persistence | (F18) |
