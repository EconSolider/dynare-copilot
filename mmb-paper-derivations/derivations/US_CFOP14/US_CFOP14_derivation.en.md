# US_CFOP14 -- Derivation (Optimization Problems + First-Order Conditions)

> Status: `needs_review`. This first-pass archive entry is source-backed by MinerU Markdown and an implementation cross-check. Runtime validation was not performed.

Provenance: `US_CFOP14`, Carlstrom, Charles T.; Fuerst, Timothy S.; Ortiz, Alberto; Paustian, Matthias (2014), "Estimating contract indexation in a financial accelerator model", Journal of Economic Dynamics & Control 46, pp. 130-194, DOI `10.1016/j.jedc.2014.06.009`. Source Markdown: `raw/mmb_mineru/runs/us_cfop14__estimating_contract_indexation_in_a_financial_accelerator_model__06425d65/full.md`; raw PDF: `raw/mmb_papers/Estimating contract indexation in a financial accelerator model.pdf`; MinerU run id: `06425d65-581e-4e92-98d4-a90b7f9fa804`. No appendix-normalization file was found. Implementation cross-check: `.agents/skills/dynare-copilot/references/examples/US_CFOP14_rep.mod`.

## 1. Model Overview

- **Model**: Estimated U.S. medium-scale New Keynesian model based on Justiniano, Primiceri and Tambalotti (2011), augmented with BGG financial accelerator agency costs and CFP contract indexation to the aggregate return on capital.
- **Experiment**: Bayesian estimated linearized model. The MMB implementation uses `model(linear)` and simulates first-order dynamics.
- **Agents and blocks**: households with habit and Calvo wage setting; intermediate-good firms with Calvo prices and wage/price mark-up shocks; final-good producers; capital producers with investment adjustment costs and MEI shocks; entrepreneurs who buy installed capital using net worth plus external finance; lenders with zero expected excess return; monetary and fiscal authorities.
- **Financial mechanism**: loan repayment can be indexed to surprises in the aggregate return on capital. The estimated `R^k` indexation parameter changes how shocks to capital returns pass through to borrower net worth and the external finance premium.
- **Form**: log-linearized system, implemented as Dynare `model(linear)`. Hatted variables in the paper are log deviations or linear deviations around the balanced-growth steady state.

## 2. Optimization Problems

### 2.1 Lender

The representative lender accepts household deposits paying the risk-free real return $`R_t^d`$ and extends one-period loans to entrepreneurs. Dividends equal the realized spread on the loan portfolio times deposits. The equity value is

```math
Q_t^L = E_t \sum_{j=1}^{\infty}\frac{\beta^j\Lambda_{t+j}}{\Lambda_t}\,\mathrm{Div}_{t+j}.
```

### 2.2 Entrepreneur And Contract

Entrepreneurs purchase the aggregate capital stock at the end of period $`t`$ using net worth and credit:

```math
\mathrm{Credit}_t \equiv Q_t\overline{K}_t - NW_t,
\qquad
\bar{\kappa}_t \equiv \frac{Q_t\overline{K}_t}{NW_t}.
```

The gross return on capital is

```math
R_{t+1}^k \equiv \frac{Q_{t+1}^{beg}}{Q_t},
\qquad
Q_{t+1}^{beg}=Q_{t+1}(1-\delta)+\rho_{t+1}u_{t+1}-a(u_{t+1}).
```

The risky-debt contract sets a default cutoff $`\varpi_{t+1}`$ and promised return $`R_{t+1}^p`$:

```math
R_{t+1}^p(Q_t\overline{K}_t-NW_t)
= \varpi_{t+1}R_{t+1}^k Q_t\overline{K}_t.
```

With entrepreneur and lender shares

```math
f(\varpi)=\int_{\varpi}^{\infty}\omega\phi(\omega)d\omega-[1-\Phi(\varpi)]\varpi,
```

```math
g(\varpi)=[1-\Phi(\varpi)]\varpi+(1-\mu_{mc})\int_0^{\varpi}\omega\phi(\omega)d\omega,
```

the entrepreneur solves

```math
\max_{\bar{\kappa}_t,\varpi_{t+1}}
E_t\left[V_{t+1}R_{t+1}^k\bar{\kappa}_t f(\varpi_{t+1})\right]
```

subject to the lender participation constraint

```math
E_t R_{t+1}^k \frac{\bar{\kappa}_t}{\bar{\kappa}_t-1}\Lambda_{t+1}g(\varpi_{t+1})
\ge R_t^d E_t\Lambda_{t+1}.
```

Entrepreneurial net worth evolves from retained project payoffs:

```math
NW_t = \gamma NW_{t-1}\bar{\kappa}_{t-1}R_t^k f(\varpi_t)\eta_{nw,t}.
```

### 2.3 Final-Good And Intermediate-Good Firms

Final-good producers combine differentiated goods:

```math
Y_t=\left[\int_0^1Y_t(i)^{1/(1+\lambda_{p,t})}di\right]^{1+\lambda_{p,t}}.
```

Intermediate-good producers use

```math
Y_t(i)=\max\left\{A_t^{1-\alpha}K_t(i)^\alpha L_t(i)^{1-\alpha}
-A_t\Upsilon_t^{\alpha/(1-\alpha)}F,0\right\}
```

and face Calvo price rigidity with price indexation.

### 2.4 Capital Producers

Capital producers choose investment to maximize the value of transformed investment goods,

```math
\max_{\{I_t\}}\;E_t\sum_{s\ge0}\beta^s\frac{\Lambda_{t+s}}{\Lambda_t}
\left[Q_{t+s}\mu_{t+s}\left(1-S\left(\frac{I_{t+s}}{I_{t+s-1}}\right)\right)I_{t+s}
-P^I_{t+s}I_{t+s}\right].
```

### 2.5 Households

Household $`j`$ maximizes

```math
E_t\sum_{s=0}^{\infty}\beta^s b_{t+s}
\left[\log(C_{t+s}-hC_{t+s-1})
-\varphi\frac{L_{t+s}(j)^{1+\psi}}{1+\psi}\right]
```

subject to a flow budget constraint containing consumption, taxes, deposits, nominal bonds, wages, deposit returns, and firm profits. A Calvo wage-setter chooses $`W_t(j)`$ subject to labor demand; non-reoptimizing wages are indexed to lagged inflation and balanced-growth terms.

## 3. First-Order Conditions

The MMB implementation includes each baseline equation and a potential-output counterpart marked with `star`. The equations below give the source-side core; star equations follow by replacing variables with their `star` analogues and removing financial frictions where the implementation does so.

- **(F1) Lender zero-profit condition**:

```math
E_t\frac{\Lambda_{t+1}}{\Lambda_t}\left(R_{t+1}^L-R_t^d\right)=0.
```

- **(F2) Production function**:

```math
\hat{y}_t=\frac{y+F}{y}\left[\alpha\hat{k}_t+(1-\alpha)\hat{L}_t\right].
```

- **(F3) Cost minimization**:

```math
\hat{\rho}_t-\hat{w}_t=\hat{L}_t-\hat{k}_t.
```

- **(F4) Real marginal cost**:

```math
\hat{s}_t=\alpha\hat{\rho}_t+(1-\alpha)\hat{w}_t.
```

- **(F5) Price Phillips curve with indexation**:

```math
\hat{\pi}_t=\frac{\beta}{1+\beta\iota_p}E_t\hat{\pi}_{t+1}
+\frac{\iota_p}{1+\beta\iota_p}\hat{\pi}_{t-1}
+\frac{(1-\beta\xi_p)(1-\xi_p)}{(1+\beta\iota_p)\xi_p}\hat{s}_t
+\hat{\lambda}_{p,t}.
```

- **(F6) Household marginal utility / consumption FOC** (`needs_review`: OCR notation around the MEI growth term is noisy):

```math
\hat{\lambda}_t =
a_c E_t\hat{c}_{t+1}-b_c\hat{c}_t+d_c\hat{c}_{t-1}
+a_z\hat{z}_t+a_b\hat{b}_t+a_{\mu}\hat{v}_t,
```

where the coefficients are functions of $`\beta,h,\gamma_z,\rho_z,\rho_b,\rho_v,\alpha`$ as in paper equation (A5).

- **(F7) Euler equation for the risk-free nominal return**:

```math
\hat{\lambda}_t=\hat{R}_t+E_t\left(\hat{\lambda}_{t+1}-\hat{z}_{t+1}
-\hat{\pi}_{t+1}-\frac{\alpha}{1-\alpha}\hat{v}_{t+1}\right).
```

- **(F8) Capital utilization FOC**:

```math
\hat{\rho}_t=\vartheta\hat{u}_t.
```

- **(F9) Frictionless expected capital-return condition**:

```math
E_t\hat{r}_{t+1}^k=\hat{\lambda}_t-E_t\hat{\lambda}_{t+1}
+E_t\hat{z}_{t+1}
+\frac{\alpha}{1-\alpha}E_t\hat{v}_{t+1}.
```

- **(F10) Agency-cost expected capital-return condition**:

```math
E_t\hat{r}_{t+1}^k=\hat{\lambda}_t-E_t\hat{\lambda}_{t+1}
+E_t\hat{z}_{t+1}
+\frac{\alpha}{1-\alpha}E_t\hat{v}_{t+1}
+\nu(\hat{q}_t+\hat{\bar{k}}_t-\hat{n}_t)+\hat{\sigma}_t.
```

- **(F11) Investment FOC / Tobin's q**:

```math
\hat{q}_t=-\hat{\mu}_t+e^{2(\gamma_z+\gamma_v)}S''\left(\hat{i}_t-\hat{i}_{t-1}
+\hat{z}_t+\frac{1}{1-\alpha}\hat{v}_t\right)
-\beta e^{2(\gamma_z+\gamma_v)}S''E_t\left(\hat{i}_{t+1}-\hat{i}_t
+\hat{z}_{t+1}+\frac{1}{1-\alpha}\hat{v}_{t+1}\right).
```

- **(F12) Capital services input**:

```math
\hat{k}_t=\hat{u}_t+\hat{\bar{k}}_{t-1}-\hat{z}_t-\frac{1}{1-\alpha}\hat{v}_t.
```

- **(F13) Capital accumulation**:

```math
\hat{\bar{k}}_t=(1-\delta)e^{-(\gamma_z+\gamma_v)}
\left(\hat{\bar{k}}_{t-1}-\hat{z}_t-\frac{1}{1-\alpha}\hat{v}_t\right)
+\left[1-(1-\delta)e^{-(\gamma_z+\gamma_v)}\right](\hat{\mu}_t+\hat{i}_t).
```

- **(F14) Wage Phillips curve** (`needs_review`: OCR uses both $`v`$ and $`\nu`$ in growth notation):

```math
\hat{w}_t=\frac{1}{1+\beta}\hat{w}_{t-1}
+\frac{\beta}{1+\beta}E_t\hat{w}_{t+1}
-\kappa_w\hat{g}_{w,t}
+\frac{\iota_w}{1+\beta}\hat{\pi}_{t-1}
-\frac{1+\beta\iota_w}{1+\beta}\hat{\pi}_t
+\frac{\beta}{1+\beta}E_t\hat{\pi}_{t+1}
+\text{growth-indexation terms}
+\hat{\lambda}_{w,t}.
```

- **(F15) Wage gap**:

```math
\hat{g}_{w,t}=\hat{w}_t-(\psi\hat{L}_t+\hat{b}_t-\hat{\lambda}_t).
```

- **(F16) Monetary policy rule**:

```math
\hat{R}_t=\rho_R\hat{R}_{t-1}
+(1-\rho_R)\left[\phi_{\pi}\hat{\pi}_t+\phi_x(\hat{x}_t-\hat{x}_t^{\ast})\right]
+\phi_{dx}\left[(\hat{x}_t-\hat{x}_{t-1})-(\hat{x}_t^{\ast}-\hat{x}_{t-1}^{\ast})\right]
+\hat{\eta}_{mp,t}.
```

- **(F17) GDP gap definition**:

```math
\hat{x}_t=\hat{y}_t-\frac{\rho k}{y}\hat{u}_t.
```

- **(F18) Real deposit return / Fisher equation**:

```math
\hat{r}_t^d=\hat{R}_t-E_t\hat{\pi}_{t+1}.
```

- **(F19) Realized return to capital**:

```math
\hat{r}_t^k=\beta e^{-(\gamma_z+\gamma_v)}(1-\delta)\hat{q}_t
+\left[1-\beta e^{-(\gamma_z+\gamma_v)}(1-\delta)\right]\hat{\rho}_t
-\hat{q}_{t-1}.
```

- **(F20) Net worth accumulation**:

```math
\hat{n}_t=\kappa\frac{\gamma}{\beta}(\hat{r}_t^k-\hat{r}_t^l)
+\frac{\gamma}{\beta}(\hat{r}_t^l+\hat{n}_{t-1})
+\gamma\kappa\frac{rp}{\beta}(\hat{\bar{k}}_{t-1}+\hat{q}_{t-1}+\hat{r}_t^k)
-\hat{z}_t-\frac{1}{1-\alpha}\hat{v}_t+\hat{\eta}_{nw,t}.
```

- **(F21) Lender return with contract indexation**:

```math
\hat{r}_t^l=\hat{r}_{t-1}^d+\left[1+\theta_g(\chi_k-1)\right]
\left(\hat{r}_t^k-E_{t-1}\hat{r}_t^k\right).
```

- **(F22) Expected return auxiliary**:

```math
\hat{r}_{t}^{ke}=E_t\hat{r}_{t+1}^k.
```

- **(F23) Marginal-utility expectation auxiliary**:

```math
\hat{\lambda}_t^e=E_t\hat{\lambda}_{t+1}.
```

- **(F24) Promised repayment rule**:

```math
\hat{r}_t^p=\hat{r}_{t-1}^d
+\frac{(1-\theta_g)[1-\nu(\kappa-1)]}{\theta_g(\kappa-1)}
(\hat{q}_{t-1}+\hat{\bar{k}}_{t-1}-\hat{n}_{t-1})
+\chi_k(\hat{r}_t^k-E_{t-1}\hat{r}_t^k)
+c_b(\hat{\lambda}_t-E_{t-1}\hat{\lambda}_t).
```

- **(F25) Spread**:

```math
\widehat{spr}_t=E_t\hat{r}_{t+1}^k-\hat{r}_t^d.
```

- **(F26) Credit**:

```math
\widehat{credit}_t=\frac{\kappa}{\kappa-1}\hat{q}_t
+\frac{\kappa}{\kappa-1}\hat{\bar{k}}_t
-\frac{1}{\kappa-1}\hat{n}_t.
```

## 4. Market Clearing & Identities

- **(F27) Resource constraint**:

```math
\frac{1}{g}\hat{y}_t=\frac{1}{g}\hat{g}_t+\frac{c}{y}\hat{c}_t
+\frac{i}{y}\hat{i}_t+\frac{\rho k}{y}\hat{u}_t.
```

- **(F28) Aggregate capital law from the nonlinear source model**:

```math
\overline{K}_t=(1-\delta)
\left(1-\mu_{mc}\int_0^{\varpi_t}\omega\phi(\omega)d\omega\right)\overline{K}_{t-1}
+\mu_t\left[1-S\left(\frac{I_t}{I_{t-1}}\right)\right]I_t.
```

- **(F29) Government spending share identity**:

```math
G_t=\left(1-\frac{1}{g_t}\right)Y_t.
```

The implementation cross-check also defines `gdp`, `gdpstar`, potential-output counterparts, and separate `star` versions of production, cost minimization, marginal cost, consumption, investment, capital, wages, and financial variables.

## 5. Exogenous Processes

- **(F30) Net worth shock**:

```math
\hat{\eta}_{nw,t}=\rho_{nw}\hat{\eta}_{nw,t-1}+\varepsilon_{nw,t}.
```

- **(F31) Idiosyncratic variance / external finance premium shock**:

```math
\hat{\sigma}_t=\rho_{\sigma}\hat{\sigma}_{t-1}+\varepsilon_{\sigma,t}.
```

- **(F32) Nonfinancial AR and ARMA shocks**:

```math
\begin{aligned}
\hat{z}_t &= \rho_z\hat{z}_{t-1}+\varepsilon_{z,t},\\
\hat{g}_t &= \rho_g\hat{g}_{t-1}+\varepsilon_{g,t},\\
\hat{\mu}_t &= \rho_{\mu}\hat{\mu}_{t-1}+\varepsilon_{\mu,t},\\
\hat{b}_t &= \rho_b\hat{b}_{t-1}+\varepsilon_{b,t},\\
\hat{\eta}_{mp,t} &= \rho_{mp}\hat{\eta}_{mp,t-1}+\varepsilon_{mp,t},\\
\hat{\lambda}_{p,t} &= \rho_p\hat{\lambda}_{p,t-1}+\varepsilon_{p,t}-\theta_p\varepsilon_{p,t-1},\\
\hat{\lambda}_{w,t} &= \rho_w\hat{\lambda}_{w,t-1}+\varepsilon_{w,t}-\theta_w\varepsilon_{w,t-1}.
\end{aligned}
```

- **(F33) Investment-specific technology growth shock in the implementation**:

```math
\hat{\upsilon}_t=\rho_{\upsilon}\hat{\upsilon}_{t-1}+\varepsilon_{\upsilon,t}.
```

## 6. Steady-State Solution

Because `US_CFOP14` is a linearized balanced-growth model, all model variables in the Dynare `model(linear)` block are deviations from steady state; the operational steady state is zero for those variables:

```math
\hat{y}=\hat{k}=\hat{L}=\hat{c}=\hat{q}=\hat{n}=\hat{R}=\hat{r}^k=\hat{spr}=0,
\qquad
\varepsilon_{\cdot}=0.
```

The implementation computes required steady-state ratios and coefficients before the model block. The cross-check file defines:

```math
\beta=\frac{100}{Fbeta+100},\quad
r_{ss}=e^{\gamma}/\beta-1,\quad
\pi_{ss}=pss100/100,
```

```math
R^k_{ss}=e^{\gamma+\gamma_{\mu}}/\beta-1+\delta,\quad
s_{ss}=\frac{1}{1+\lambda_{p,ss}},
```

and then constructs steady-state wages, capital-labor ratios, output, investment, fixed costs, consumption, and the Calvo wage coefficient from calibrated or estimated parameters. Financial steady-state targets include leverage $`\kappa=1.95`$, quarterly risk premium $`rp=0.02/4`$, entrepreneurial survival $`\gamma=0.94`$, and agency-cost elasticity $`\nu=0.19`$ in the baseline indexation model.

## 7. Timing & Form Conventions

- **Form**: log-linearized; Dynare implementation uses `model(linear)`.
- **Capital timing**: installed capital stock $`\bar{k}_t`$ is predetermined through $`\bar{k}_{t-1}`$ in production services; current capital services combine utilization, lagged installed capital, and growth terms.
- **Loans**: loans are made at the end of period $`t`$ and repaid in period $`t+1`$; the realized lender return in period $`t`$ depends on the previous period's deposit return and surprises in the realized return to capital.
- **Net worth**: $`\hat{n}_t`$ is a state variable propagated from $`\hat{n}_{t-1}`$ and realized capital/lender returns, plus a net-worth redistribution shock.
- **Expectations**: the implementation uses lead notation such as `Rk(+1)` and auxiliaries `Rke = Rk(+1)`, `lambdae = lambda(+1)` for expected one-period-ahead objects.
- **Potential-output system**: `star` variables represent the corresponding frictionless or potential-output block used in the policy rule and output gap.
- **Runtime validation**: not performed; no Dynare command was run.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII name | Meaning | Main equation(s) |
|---|---|---|---|
| Endogenous | `y`, `ystar` | output and potential output | (F2), (F27) |
| Endogenous | `k`, `kstar` | capital services | (F12) |
| Endogenous | `L`, `Lstar` | labor | (F2), (F3), (F15) |
| Endogenous | `mpk`, `mpkstar` | marginal product/rental return of capital | (F3), (F8) |
| Endogenous | `w`, `wstar` | real wage | (F3), (F14), (F15) |
| Endogenous | `p` | inflation | (F5) |
| Endogenous | `s`, `sstar` | real marginal cost | (F4), (F5) |
| Endogenous | `lambda`, `lambdastar` | household marginal utility | (F6), (F7), (F23) |
| Endogenous | `c`, `cstar` | consumption | (F6), (F27) |
| Endogenous | `R`, `Rstar` | nominal policy rate | (F16), (F18) |
| Endogenous | `u`, `ustar` | utilization | (F8), (F12), (F17), (F27) |
| Endogenous | `i`, `istar` | investment | (F11), (F27) |
| Endogenous | `kbar`, `kbarstar` | installed capital | (F13), (F28) |
| Endogenous | `wgap`, `wgapstar` | wage gap | (F15) |
| Endogenous | `gdp`, `gdpstar` | GDP gap measures | (F17) |
| Endogenous | `z`, `g`, `miu`, `b`, `mp`, `lambdap`, `lambdaw`, `upsilon` | exogenous state variables inside `var` | (F32), (F33) |
| Endogenous | `Rk`, `Rkstar`, `q`, `qstar` | capital return and price of capital | (F10), (F11), (F19), (F22) |
| Endogenous | `Rl`, `Rlstar`, `Rd`, `Rdstar` | lender and deposit returns | (F18), (F21) |
| Endogenous | `nw`, `nwstar` | entrepreneurial net worth | (F20) |
| Endogenous | `lamefp`, `lamnw` | financial shock states | (F30), (F31) |
| Endogenous | `spr`, `sprstar` | spread | (F25) |
| Endogenous | `promz`, `promzstar` | promised repayment | (F24) |
| Endogenous | `credit` | credit aggregate | (F26) |
| Exogenous | `Rs`, `zs`, `gs`, `mius`, `lambdaps`, `lambdaws`, `bs`, `efps`, `upsilons`, `nws` | innovations to monetary, technology, fiscal, MEI, mark-up, preference, financial, IST, and net-worth shocks | (F30)-(F33) |
| Parameter | `alpha`, `delta`, `h`, `Fbeta`, `gamma100`, `gammamiu100` | production, depreciation, habit, discounting, trend growth | steady state, (F2), (F6), (F11)-(F13) |
| Parameter | `iotap`, `iotaw`, `xip`, `xiw`, `lambdapss`, `lambdawss`, `niu` | price/wage indexation, Calvo parameters, markups, labor curvature | (F5), (F14), (F15) |
| Parameter | `Sadj`, `chi` | investment adjustment and utilization cost elasticities | (F8), (F11) |
| Parameter | `fp`, `fy`, `fdy`, `rhoR` | monetary policy response and smoothing | (F16) |
| Parameter | `cnu`, `cgamma`, `crp`, `ckappa`, `ctheta`, `cchi`, `cb` | financial accelerator and contract-indexation parameters | (F10), (F20), (F21), (F24), (F26) |
| Parameter | `rhoz`, `rhog`, `rhomiu`, `rholambdap`, `rholambdaw`, `rhob`, `rhomp`, `rhoefp`, `rhonw`, `rhoupsilon` | shock persistence parameters | (F30)-(F33) |
