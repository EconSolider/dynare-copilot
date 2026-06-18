# NK_MI14 -- Derivation (Optimization Problems + First-Order Conditions)

> This private-archive derivation summarizes the source-backed model structure for later review and possible Dynare work. Runtime validation was not performed.
> Source: Pascal Michaillat (2014), "A Theory of Countercyclical Government Multiplier," American Economic Journal: Macroeconomics, 6(1): 190-217, DOI `10.1257/mac.6.1.190`.

## 1. Model Overview

- **Model**: New Keynesian search-and-matching model with public employment, mapped to MMB model `NK_MI14`.
- **Core mechanism**: Government hires from the same job-seeker pool as private firms. Public hiring raises labor-market tightness and crowds out private hiring, but crowding-out is weaker when unemployment is high.
- **Agents and blocks**: large household, final-good firm, monopolistically competitive intermediate-good firms, government, and monetary authority.
- **Policy experiment**: technology shocks plus a public-employment hiring shock. The paper studies public-employment multipliers over expansions and recessions.
- **Form**: nonlinear dynamic model with Rotemberg price adjustment. The paper simulates a nonlinear perfect-foresight approximation rather than a log-linear approximation. The MMB implementation uses a nonlinear Dynare `model` block with piecewise `min`/`max` guards.
- **Provenance**: primary Markdown `raw/mmb_mineru/runs/nk_mi14__a_theory_of_countercyclical_government_multiplier__afea0443/full.md`; raw PDF `raw/mmb_papers/A Theory of Countercyclical Government Multiplier.pdf`; MinerU run IDs `afea0443-0728-45fc-b048-6add939d19ec` and `ee399d61-9d94-4794-ba44-4a43691caddf`.

## 2. Optimization Problems

### 2.1 Household

The large household pools worker income, consumes the final good and public good, and chooses consumption and one-period nominal bonds:

```math
\max_{\{c_t,b_t\}} E_0 \sum_{t=0}^{\infty}\beta^t\left[\ln(c_t)+\chi\ln(z_t)\right]
```

subject to

```math
p_t c_t+b_t=p_t n_t(1-\tau_t)w_t+R_{t-1}b_{t-1}+p_tT_t .
```

The household does not choose hours; employment is governed by search-and-matching flows.

### 2.2 Final-Good Firm

The representative final-good firm combines differentiated intermediate goods:

```math
y_t=\left[\int_0^1 y_t(i)^{(\epsilon-1)/\epsilon}\,di\right]^{\epsilon/(\epsilon-1)}
```

and chooses $`\{y_t(i)\}_{i\in[0,1]}`$ to maximize

```math
p_t\left[\int_0^1 y_t(i)^{(\epsilon-1)/\epsilon}\,di\right]^{\epsilon/(\epsilon-1)}
-\int_0^1 p_t(i)y_t(i)\,di .
```

### 2.3 Intermediate-Good Firm

Intermediate producer $`i`$ chooses employment and its nominal price:

```math
\max_{\{l_t(i),p_t(i)\}} E_0\sum_{t=0}^{\infty}\frac{\beta^t}{c_t}
\left\{
\frac{p_t(i)}{p_t}y_t(i)-w_tl_t(i)
-\frac{\phi}{2}\left(\frac{p_t(i)}{p_{t-1}(i)}-1\right)^2c_t
-\frac{r a_t}{q(\theta_t)}\left[l_t(i)-(1-s)l_{t-1}(i)\right]
\right\}
```

subject to final-good demand and production:

```math
y_t(i)=y_t\left(\frac{p_t(i)}{p_t}\right)^{-\epsilon},\qquad
y_t(i)=a_t l_t(i)^\alpha .
```

The recruitment cost is proportional to technology and inversely related to the vacancy-filling rate $`q(\theta_t)`$.

### 2.4 Government and Monetary Authority

The government employs $`g_t`$ workers, pays wages and hiring costs, and finances expenditures with labor taxes and debt. Its budget constraint is recorded as an equilibrium condition in Section 4. Monetary policy sets the gross nominal interest rate using an interest-rate-smoothing Taylor rule.

## 3. First-Order Conditions

**(F1) Household Euler equation**:

```math
1=\beta E_t\left[\frac{R_t}{1+\pi_{t+1}}\frac{c_t}{c_{t+1}}\right].
```

**(F2) Final-good demand for each intermediate good**:

```math
y_t(i)=y_t\left(\frac{p_t(i)}{p_t}\right)^{-\epsilon}.
```

**(F3) Final-good price index**:

```math
p_t=\left[\int_0^1 p_t(i)^{1-\epsilon}\,di\right]^{1/(1-\epsilon)}.
```

**(F4) Intermediate-good production technology**:

```math
y_t(i)=a_t l_t(i)^\alpha .
```

**(F5) Intermediate-firm labor demand / hiring-cost FOC**:

```math
\Lambda_t(i)\alpha l_t(i)^{\alpha-1}
=\frac{w_t}{a_t}+\frac{r}{q(\theta_t)}
-\beta(1-s)E_t\left[\frac{c_t}{c_{t+1}}\frac{a_{t+1}}{a_t}\frac{r}{q(\theta_{t+1})}\right].
```

**(F6) Intermediate-firm price-setting FOC**:

```math
\frac{p_t(i)}{p_t}
=\frac{\epsilon}{\epsilon-1}\Lambda_t(i)
+\frac{\phi}{\epsilon-1}\frac{c_t}{y_t}
\left(\frac{p_t(i)}{p_t}\right)^\epsilon
\left[
\beta E_t\left[\left(\frac{p_{t+1}(i)}{p_t(i)}-1\right)\frac{p_{t+1}(i)}{p_t(i)}\right]
-\left(\frac{p_t(i)}{p_{t-1}(i)}-1\right)\frac{p_t(i)}{p_{t-1}(i)}
\right].
```

**(F7) Symmetric labor demand**:

```math
\Lambda_t\alpha l_t^{\alpha-1}
=\frac{w_t}{a_t}+\frac{r}{q(\theta_t)}
-\beta(1-s)E_t\left[\frac{c_t}{c_{t+1}}\frac{a_{t+1}}{a_t}\frac{r}{q(\theta_{t+1})}\right].
```

**(F8) Symmetric Rotemberg Phillips curve**:

```math
\pi_t(1+\pi_t)=\frac{1}{\phi}\frac{y_t}{c_t}\left[\epsilon\Lambda_t-(\epsilon-1)\right]
+\beta E_t\left[\pi_{t+1}(1+\pi_{t+1})\right].
```

**needs_review**: MinerU OCR prints the firm price-setting condition over two displayed equations. The symmetric Phillips curve is clear, but the unsymmetrized price FOC should be checked against the PDF before use as implementation source.

## 4. Market Clearing & Identities

**(F9) Matching function**:

```math
h_t=m u_t^\eta \nu_t^{1-\eta}.
```

**(F10) Labor-market tightness**:

```math
\theta_t=\frac{\nu_t}{u_t}.
```

**(F11) Job-finding probability**:

```math
f(\theta_t)=\frac{h_t}{u_t}=m\theta_t^{1-\eta}.
```

**(F12) Vacancy-filling probability**:

```math
q(\theta_t)=\frac{h_t}{\nu_t}=m\theta_t^{-\eta}.
```

**(F13) Unemployment at the start of period**:

```math
u_t=1-(1-s)n_{t-1}.
```

**(F14) Aggregate employment law of motion**:

```math
n_t=(1-s)n_{t-1}+\left[1-(1-s)n_{t-1}\right]f(\theta_t).
```

**(F15) New hires identity**:

```math
h_t=n_t-(1-s)n_{t-1}.
```

**(F16) Aggregate employment identity**:

```math
n_t=l_t+g_t.
```

**(F17) Symmetric production function**:

```math
y_t=a_t l_t^\alpha.
```

**(F18) Inflation definition**:

```math
\pi_t=\frac{p_t}{p_{t-1}}-1.
```

**(F19) Government budget constraint**:

```math
n_t\tau_t w_t+\frac{b_t}{p_t}
=g_t w_t+\frac{r a_t}{q(\theta_t)}\left[g_t-(1-s)g_{t-1}\right]
+\frac{R_{t-1}}{p_t}b_{t-1}.
```

**(F20) Resource constraint**:

```math
y_t=c_t\left(1+\frac{\phi}{2}\pi_t^2\right)
+\frac{r a_t}{q(\theta_t)}\left[n_t-(1-s)n_{t-1}\right].
```

**(F21) Public-good production**:

```math
z_t=\sigma g_t^\alpha.
```

**(F22) GDP accounting measure used in simulations**:

```math
GDP_t=y_t+w_tg_t+\left[g_t-(1-s)g_{t-1}\right]\frac{r a_t}{q(\theta_t)}.
```

## 5. Exogenous Processes

**(F23) Real-wage schedule**:

```math
w_t=\omega a_t^\gamma.
```

**(F24) Monetary policy rule**:

```math
R_t=\frac{1}{\beta}(1+\pi_t)^{\mu_\pi(1-\mu_R)}(\beta R_{t-1})^{\mu_R}.
```

**(F25) Technology process**:

```math
\log(a_{t+1})=\rho\log(a_t)+\nu_{t+1}.
```

**(F26) Public employment baseline in the main simulation**:

```math
g_t=\bar{g}
```

unless the government intervention adds public workers.

**(F27) One-time intervention path for public employment**:

```math
g_1^{\ast}=\hat{g}_1+\Delta g,\qquad
g_t^{\ast}-(1-s)g_{t-1}^{\ast}=s\bar{g}\quad\text{for }t\ge 2.
```

The MMB implementation cross-check represents this policy with an exogenous public-hiring shock `hireg` and an endogenous stock `gendo`.

## 6. Steady-State Solution

The zero-inflation steady state is isomorphic to the comparative steady-state model in Section I.

**(F28) Steady-state quasi-labor supply**:

```math
n^s(\theta)=\frac{f(\theta)}{s+(1-s)f(\theta)}.
```

**(F29) Steady-state private labor demand**:

```math
l^d(\theta,w)=
\left[
\frac{1}{\alpha}
\left\{
w+\left[1-\beta(1-s)\right]\frac{r}{q(\theta)}
\right\}
\right]^{-1/(1-\alpha)}.
```

In the New Keynesian steady state, monopoly power and technology scaling modify the same object: zero inflation implies $`\Lambda=(\epsilon-1)/\epsilon`$, so the real marginal labor cost is scaled by the markup and $`w`$ is replaced by $`w/a`$ in the dynamic production block.

**(F30) Steady-state aggregate labor demand**:

```math
n^d(\theta,w,g)=g+l^d(\theta,w).
```

**(F31) Labor-market steady-state equilibrium**:

```math
n^s(\theta)=n^d(\theta,w,g).
```

**(F32) Aggregate employment in steady state**:

```math
n=n^d(\theta,w,g).
```

**(F33) Public-employment multiplier**:

```math
\lambda\equiv\frac{\partial n}{\partial g}
=1-\frac{1}{1+(\epsilon^s/\epsilon^d)}.
```

**(F34) Supply elasticity used in multiplier formula**:

```math
\epsilon^s=(1-\eta)u.
```

**(F35) Demand elasticity used in multiplier formula**:

```math
\epsilon^d=\frac{\eta}{(1+\zeta)(1-\alpha)}\Omega,\qquad
\Omega=\frac{[1-\beta(1-s)]r/q(\theta)}
{[1-\beta(1-s)]r/q(\theta)+w}.
```

**Calibration sequence recorded from the source and MMB cross-check**:

1. Normalize $`\bar{a}=1`$ and impose zero steady-state inflation, $`\bar{\pi}=0`$.
2. Set $`\bar{u}=0.064`$, $`\bar{\theta}\approx0.43`$, and $`s\approx0.009`$.
3. Solve $`\bar{n}=(1-\bar{u})/(1-s)`$, $`\bar{g}=0.167\bar{n}`$, and $`\bar{l}=\bar{n}-\bar{g}`$.
4. Set $`m=s\bar{n}\bar{\theta}^{\eta-1}/\bar{u}`$.
5. Zero inflation implies $`\bar{\Lambda}=(\epsilon-1)/\epsilon`$.
6. Calibrate $`\omega`$ from the steady-state labor-demand condition and set $`r=0.32\omega`$.
7. Set $`\bar{R}=1/\beta`$, $`\bar{w}=\omega\bar{a}^\gamma`$, $`\bar{y}=\bar{a}\bar{l}^{\alpha}`$, and solve $`\bar{c}`$ from the resource constraint.

**needs_review**: The MMB `.mod` uses `delta` where the paper writes $`\beta`$ in several dynamic expressions. This appears to be a parameter naming convention in the implementation, not paper-side evidence.

## 7. Timing & Form Conventions

- **Frequency**: weekly.
- **Employment timing**: $`n_t`$ is employment after current-period matches; beginning-of-period unemployment is $`u_t=1-(1-s)n_{t-1}`$.
- **Hiring timing**: new hires are $`n_t-(1-s)n_{t-1}`$; public-sector hires analogously use $`g_t-(1-s)g_{t-1}`$.
- **Tightness timing**: $`\theta_t`$ is current vacancies per current job seeker and determines both $`f(\theta_t)`$ and $`q(\theta_t)`$.
- **Price timing**: Rotemberg cost uses $`p_t(i)/p_{t-1}(i)`$ and the inflation rate is $`\pi_t=p_t/p_{t-1}-1`$.
- **Interest timing**: $`R_t`$ is the gross nominal rate set in period $`t`$ and pays between $`t`$ and $`t+1`$ in the Euler equation.
- **Form**: nonlinear. Do not treat the derivation as a source-validated log-linear system.
- **Runtime validation**: not performed; no Dynare run, residual check, BK check, or IRF replication was executed.

## 8. Variable & Parameter Reference Table

### Endogenous Variables

| Symbol | ASCII / MMB cue | Meaning | Main equation(s) |
|---|---|---|---|
| $`a_t`$ | `a` | technology | (F25) |
| $`c_t`$ | `c` | household consumption | (F1), (F20) |
| $`\pi_t`$ | `pie` | inflation rate | (F8), (F18) |
| $`l_t`$ | `l` | private employment | (F7), (F16), (F17) |
| $`n_t`$ | `n` | aggregate employment | (F14), (F16) |
| $`\theta_t`$ | `th` | labor-market tightness | (F10)-(F12), (F14) |
| $`R_t`$ | `R` | gross nominal interest rate | (F1), (F24) |
| $`g_t`$ | `g`, `gendo` | public employment | (F16), (F19), (F26)-(F27) |
| $`y_t`$ | `y` | final output | (F17), (F20) |
| $`u_t`$ | `u` | job seekers / unemployment measure | (F13) |
| $`h_t`$ | `h` | new matches / hires | (F9), (F15) |
| $`w_t`$ | `w` | real wage | (F23) |
| $`\Lambda_t`$ | `mpl` in implementation cue | real marginal revenue / marginal-cost object | (F7), (F8) |
| $`f(\theta_t)`$ | `f` | job-finding probability | (F11), (F14) |
| $`b_t`$ | not explicit in MMB `.mod` | nominal bonds | (F1), (F19) |
| $`\tau_t`$ | not explicit in MMB `.mod` | labor tax rate | (F19) |
| $`z_t`$ | not explicit in MMB `.mod` | public good | (F21) |

### Exogenous Innovations

| Symbol | ASCII / MMB cue | Meaning |
|---|---|---|
| $`\nu_t`$ | `epsa` | technology innovation |
| $`\Delta g_t`$ | `hireg` | public hiring intervention shock |

### Parameters

| Symbol | ASCII / MMB cue | Meaning |
|---|---|---|
| $`\beta`$ | `delta` in `.mod` cue | discount factor |
| $`\alpha`$ | `alpha` | diminishing returns to labor |
| $`\epsilon`$ | `epsilon` | substitution elasticity across goods |
| $`s`$ | `s` | job-destruction rate |
| $`\eta`$ | `eta` | matching elasticity with respect to unemployment |
| $`m`$ | `omegah` in `.mod` cue | matching effectiveness |
| $`r`$ | `r` | recruiting cost |
| $`\gamma`$ | `gamma` | elasticity of real wage to technology |
| $`\omega`$ | `omega` | real-wage level |
| $`\phi`$ | `phi` | Rotemberg price-adjustment cost |
| $`\mu_\pi`$ | `phipi` | Taylor-rule inflation response |
| $`\mu_R`$ | `phir` | interest-rate smoothing |
| $`\rho`$ | `rhoa` | technology persistence |
| $`\chi`$ | not implemented as utility object | taste for public good |
| $`\sigma`$ | not implemented as production object | public-good productivity scale |
| $`\zeta`$ | `zeta` | public/private employment ratio cue |
| $`\bar{g}`$ | `gexo`, `g_ss` | baseline public employment |

**Coverage note**: The source paper states the symmetric equilibrium as ten processes and ten relationships, while the MMB implementation augments the system with auxiliary variables (`u`, `h`, `w`, `mpl`, `f`, `gendo`, `y`) for transparent simulation. The table records both source-side concepts and implementation cross-check cues.
