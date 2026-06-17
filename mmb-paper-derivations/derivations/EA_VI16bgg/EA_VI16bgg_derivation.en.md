# EA_VI16bgg - Derivation (Optimization Problems + First-Order Conditions)

> Status: needs_review. This first-pass archive entry is source-backed by the MinerU Markdown extraction of Villa (2016), Table 1, and cross-checked against the Rep-MMB implementation only for variable coverage and timing conventions. Runtime validation was not performed.

## 1. Model Overview

- **Model ID**: `EA_VI16bgg`.
- **Paper**: Stefania Villa (2016), "Financial frictions in the Euro Area and the United States: a Bayesian assessment", *Macroeconomic Dynamics*, 20(05), 1313-1340. DOI: `10.1017/s1365100514000881`.
- **Economy and variant**: Euro Area estimated Smets-Wouters model with Bernanke-Gertler-Gilchrist (BGG) financial frictions originating in nonfinancial firms.
- **Agents and sectors**: households, labor unions, labor packers, retailers, final-good firms, intermediate-goods firms, capital producers, and the policy maker. In the SWBGG variant, intermediate-goods firms buy capital with net worth and external borrowing under a costly-state-verification contract.
- **Form**: `model(linear)`. Variables with hats are percentage or log deviations from steady state; variables without time subscripts are steady-state constants.
- **Primary source**: `raw/mmb_mineru/runs/ea_vi16bgg_ea_vi16gk_us_vi16bgg_us_vi16gk__financial_frictions_in_the_euro_area_and_the_united_states_a_bayesian_as__ed2f2b1d/full.md`.
- **Formula quality**: Table 1 is present in the Markdown and matches the implementation block closely. The employment Phillips curve is shown in the paper but is omitted in the Rep-MMB implementation because the EA/US observables differ; this draft follows the `EA_VI16bgg` implementation coverage and marks the omission as `needs_review`.

## 2. Optimization Problems

### Households

Households consume, save, and supply labor. The paper states the linearized Euler equation and wage Phillips curve rather than a full nonlinear household problem. A compact representation consistent with the SW habit block is:

$$
\max_{\{C_t,L_t,B_t\}} E_0 \sum_{t=0}^{\infty}\beta^t
U(C_t-h C_{t-1},L_t)
$$

subject to the household budget constraint and the labor-union wage-setting environment. The resulting linearized conditions used in the model are (F1) and (F2).

### Labor unions, labor packers, retailers, and goods producers

Labor unions and retailers set differentiated wages and prices under Calvo frictions with partial indexation. Competitive packers aggregate differentiated labor, final-good firms aggregate intermediate goods, and intermediate-goods firms choose labor, installed capital, and utilization. The paper reports the resulting wage Phillips curve, price Phillips curve, production function, and factor condition directly in Table 1.

### Capital producers

Capital producers transform investment and depreciated capital into new capital. Investment adjustment costs deliver the investment Euler equation (F5). Installed capital utilization is chosen so that utilization and the marginal product of capital satisfy (F4).

### SWBGG intermediate-goods firms with external finance

At the end of period $t$, firms acquire $K_{t+1}$ at price $Q_t$. Acquisition cost $Q_tK_{t+1}$ is financed by net worth $N_{t+1}$ and borrowing. Firms survive with probability $\theta$, so finite expected life prevents full self-financing. The costly-state-verification contract implies an external finance premium increasing in leverage. The paper's linearized BGG block is (F12)-(F15).

## 3. First-Order Conditions

- **(F1) Consumption Euler equation with habit**

$$
\frac{1+h}{1-h}\hat{C}_t =
\frac{1}{1-h}E_t\hat{C}_{t+1}
+ \frac{h}{1-h}\hat{C}_{t-1}
- \hat{R}_t .
$$

- **(F2) Wage Phillips curve**

$$
\hat{W}_t =
\frac{\beta}{1+\beta}E_t\hat{W}_{t+1}
+\frac{1}{1+\beta}\hat{W}_{t-1}
+\frac{\beta}{1+\beta}E_t\hat{\Pi}_{t+1}
-\frac{1+\beta\sigma_{wi}}{1+\beta}\hat{\Pi}_t
+\frac{\sigma_{wi}}{1+\beta}\hat{\Pi}_{t-1}
+\frac{1}{1+\beta}
\frac{(1-\beta\sigma_w)(1-\sigma_w)}{(1+\varepsilon_w\phi)\sigma_w}
\left[
\phi\hat{L}_t-\frac{h}{1-h}\hat{C}_{t-1}
+\frac{1}{1-h}\hat{C}_t-\hat{W}_t
\right]
+\varepsilon_t^w .
$$

- **(F3) Capital accumulation**

$$
\hat{K}_{t+1} =
\delta(\hat{I}_t+\varepsilon_t^x)
+(1-\delta)(\hat{K}_t+\varepsilon_t^k).
$$

- **(F4) Optimal capital utilization**

$$
\hat{Z}_t^k = \frac{\zeta}{1-\zeta}\hat{U}_t .
$$

- **(F5) Investment Euler equation**

$$
\hat{I}_t =
\frac{1}{\xi(1+\beta)}(\hat{Q}_t+\varepsilon_t^x)
+\frac{1}{1+\beta}\hat{I}_{t-1}
+\frac{\beta}{1+\beta}E_t\hat{I}_{t+1}.
$$

- **(F6) Firms' factor condition**

$$
\hat{W}_t = \hat{Z}_t^k-\hat{L}_t+\hat{K}_t+\hat{U}_t .
$$

- **(F7) Price of capital under SWBGG financial frictions**

$$
\hat{R}_t^k =
\frac{Z^k}{R^k}\hat{Z}_t^k
+\frac{1-\delta}{R^k}(\hat{Q}_t+\varepsilon_t^k)
-\hat{Q}_{t-1}.
$$

- **(F8) External finance premium**

$$
\hat{E}P_t =
\varkappa\left(\hat{Q}_t+E_t\hat{K}_{t+1}-E_t\hat{N}_{t+1}\right).
$$

- **(F9) Spread relation**

$$
E_t\hat{R}_{t+1}^k=\hat{R}_t+\hat{E}P_t .
$$

- **(F10) Firms' net worth accumulation**

$$
\frac{1}{\theta R^k}E_t\hat{N}_{t+1}
=
\frac{K}{N}\hat{R}_t^k
-\left(\frac{K}{N}-1\right)\hat{R}_{t-1}
-\varkappa\left(\frac{K}{N}-1\right)(\hat{K}_t+\hat{Q}_{t-1})
+\left[\left(\frac{K}{N}-1\right)\varkappa+1\right]\hat{N}_t .
$$

## 4. Market Clearing & Identities

- **(F11) Resource constraint**

$$
\hat{Y}_t =
\frac{C}{Y}\hat{C}_t
+\frac{I}{Y}\hat{I}_t
+\frac{G}{Y}\varepsilon_t^g
+Z^k\frac{K}{Y}\hat{U}_t .
$$

- **(F12) Production function**

$$
\hat{Y}_t =
\Theta\left[
\varepsilon_t^a
+\alpha(\varepsilon_t^k+\hat{K}_t+\hat{U}_t)
+(1-\alpha)\hat{L}_t
\right].
$$

- **(F13) Price Phillips curve**

$$
\hat{\Pi}_t =
\frac{\sigma_{pi}}{1+\sigma_{pi}\beta}\hat{\Pi}_{t-1}
+\frac{\beta}{1+\sigma_{pi}\beta}E_t\hat{\Pi}_{t+1}
-\frac{(1-\beta\sigma_p)(1-\sigma_p)}
{(1+\sigma_{pi}\beta)\sigma_p}
\left[
\varepsilon_t^a-\alpha\hat{Z}_t^k-(1-\alpha)\hat{W}_t
\right]
+\varepsilon_t^p .
$$

- **(F14) Taylor rule**

$$
\hat{R}_t^n =
\rho_i\hat{R}_{t-1}^n
+(1-\rho_i)\left[
\rho_{\pi}\hat{\Pi}_t
+\rho_y(\hat{Y}_t-\hat{Y}_t^p)
\right]
+\rho_{\Delta y}\left[
\hat{Y}_t-\hat{Y}_t^p-(\hat{Y}_{t-1}-\hat{Y}_{t-1}^p)
\right]
+\varepsilon_t^r .
$$

- **(F15) Fisher equation**

$$
\hat{R}_t^n = \hat{R}_t + E_t\hat{\Pi}_{t+1}.
$$

## 5. Exogenous Processes

The paper states seven orthogonal structural shocks. The signs below follow the Rep-MMB implementation cross-check; sign conventions should be source-reviewed before promotion.

- **(F16) Technology shock**

$$
\varepsilon_t^a = \rho_a\varepsilon_{t-1}^a - e_t^a .
$$

- **(F17) Government-spending shock**

$$
\varepsilon_t^g = \rho_g\varepsilon_{t-1}^g - e_t^g .
$$

- **(F18) Investment-specific technology shock**

$$
\varepsilon_t^x = \rho_x\varepsilon_{t-1}^x - e_t^x .
$$

- **(F19) Monetary-policy shock**

$$
\varepsilon_t^r = \rho_{ri}\varepsilon_{t-1}^r + e_t^r .
$$

- **(F20) Price mark-up shock**

$$
\varepsilon_t^p = \rho_p\varepsilon_{t-1}^p + e_t^p .
$$

- **(F21) Wage mark-up shock**

$$
\varepsilon_t^w = \rho_w\varepsilon_{t-1}^w + e_t^w .
$$

- **(F22) Capital-quality shock**

$$
\varepsilon_t^k = \rho_k\varepsilon_{t-1}^k - e_t^k .
$$

## 6. Steady-State Solution

Because `EA_VI16bgg` is a linearized model, the dynamic variables in the model block are deviations from steady state and have zero deterministic steady state:

$$
\hat{C}=\hat{I}=\hat{Y}=\hat{W}=\hat{L}=\hat{\Pi}=\hat{R}=\hat{R}^n
=\hat{Z}^k=\hat{U}=\hat{K}=\hat{Q}=\hat{R}^k
=\hat{E}P=\hat{N}=0 .
$$

The steady-state constants used to scale the linear equations are:

$$
R=\frac{1}{\beta},\qquad
Z^k=R-(1-\delta),\qquad
R^k=S R .
$$

$$
\frac{K}{N}=2,\qquad
\frac{G}{Y}=0.20,\qquad
\frac{I}{K}=\delta .
$$

Calibration from the paper: $\beta=0.99$, $\alpha=0.33$, $\delta=0.025$, $G/Y=0.20$, goods and labor elasticities chosen to target gross markups of 1.20, firm survival $\theta=0.972$, annual steady-state spread target $S=150$ basis points, and $K/N=2$. The Rep-MMB implementation derives additional ratios such as $C/Y$, $I/Y$, $K/Y$, $Z^k$, $W$, and $R^k$ from these primitives before entering `model(linear)`.

The employment Phillips curve appears in the source table, but the `EA_VI16bgg` implementation omits employment. Its steady-state and equation-count implications remain `needs_review`.

## 7. Timing & Form Conventions

- **Linear form**: the archive entry should be implemented as `model(linear)`.
- **Hats**: hatted variables are deviations from steady state; the paper notes that variables without time subscripts denote steady-state values.
- **Capital timing**: the paper describes end-of-period capital purchases $K_{t+1}$ at price $Q_t$ for production in $t+1$. The Rep-MMB implementation stores the predetermined stock as `k(-1)` in production and writes accumulation as current `k` depending on lagged `k`, which is the same convention shifted into Dynare timing.
- **Financial timing**: net worth enters the BGG premium as expected next-period net worth in the source equation; the implementation uses current `n` with the model's shifted timing. This timing normalization is an implementation cross-check and remains `needs_review`.
- **Output gap**: the policy rule uses $\hat{Y}_t-\hat{Y}_t^p$; the implementation obtains $\hat{Y}_t^p$ from a parallel flexible-price block.
- **Runtime validation**: not performed.

Flexible-price auxiliary block used for $\hat{Y}^p$ in the implementation:

- **(F23) Flexible marginal product condition**

$$
\alpha\hat{Z}_{t}^{k,p}=\varepsilon_t^a-(1-\alpha)\hat{W}_t^p .
$$

- **(F24) Flexible utilization**

$$
\hat{U}_t^p=\frac{1-\zeta}{\zeta}\hat{Z}_t^{k,p}.
$$

- **(F25) Flexible firms' factor condition**

$$
\hat{Z}_t^{k,p}=\hat{W}_t^p+\hat{L}_t^p-\hat{K}_{t-1}^p-\hat{U}_t^p .
$$

- **(F26) Flexible investment Euler equation**

$$
\hat{I}_t^p =
\frac{1}{1+\beta}\left[
\hat{I}_{t-1}^p+\beta\hat{I}_{t+1}^p+\frac{1}{\xi}(\hat{Q}_t^p+\varepsilon_t^x)
\right].
$$

- **(F27) Flexible price of capital**

$$
\hat{R}_t^{k,p} =
\frac{Z^k}{R^k}\hat{Z}_t^{k,p}
+\frac{1-\delta}{R^k}(\hat{Q}_t^p+\varepsilon_t^k)
-\hat{Q}_{t-1}^p .
$$

- **(F28) Flexible external finance premium**

$$
\hat{E}P_t^p=\varkappa(\hat{Q}_t^p+\hat{K}_t^p-\hat{N}_t^p).
$$

- **(F29) Flexible spread relation**

$$
E_t\hat{R}_{t+1}^{k,p}=\hat{E}P_t^p+\hat{R}_t^p .
$$

- **(F30) Flexible net worth accumulation**

$$
\frac{1}{\theta R^k}\hat{N}_t^p
=
\frac{K}{N}\hat{R}_t^{k,p}
-\left(\frac{K}{N}-1\right)\hat{R}_{t-1}^p
-\varkappa\left(\frac{K}{N}-1\right)(\hat{K}_{t-1}^p+\hat{Q}_{t-1}^p)
+\left[\left(\frac{K}{N}-1\right)\varkappa+1\right]\hat{N}_{t-1}^p .
$$

- **(F31) Flexible consumption Euler equation**

$$
\hat{C}_t^p =
\frac{1}{1+h}\hat{C}_{t+1}^p
+\frac{h}{1+h}\hat{C}_{t-1}^p
-\frac{1-h}{1+h}\hat{R}_t^p .
$$

- **(F32) Flexible resource constraint**

$$
\hat{Y}_t^p =
\frac{C}{Y}\hat{C}_t^p
+\frac{I}{Y}\hat{I}_t^p
+\frac{G}{Y}\varepsilon_t^g
+Z^k\frac{K}{Y}\hat{U}_t^p .
$$

- **(F33) Flexible production function**

$$
\hat{Y}_t^p =
\Theta\left[
\varepsilon_t^a+\alpha(\hat{K}_{t-1}^p+\varepsilon_t^k+\hat{U}_t^p)
+(1-\alpha)\hat{L}_t^p
\right].
$$

- **(F34) Flexible labor supply / wage condition**

$$
\hat{W}_t^p =
\phi\hat{L}_t^p+\frac{1}{1-h}\hat{C}_t^p-\frac{h}{1-h}\hat{C}_{t-1}^p .
$$

- **(F35) Flexible capital accumulation**

$$
\hat{K}_t^p=(1-\delta)(\hat{K}_{t-1}^p+\varepsilon_t^k)+\frac{I}{K}\hat{I}_t^p+\frac{I}{K}\xi\varepsilon_t^x .
$$

## 8. Variable & Parameter Reference Table

### Endogenous variables

| ASCII name | Mathematical symbol | Meaning | Main equation |
|---|---|---|---|
| `y` | $\hat{Y}_t$ | output | (F11), (F12) |
| `c` | $\hat{C}_t$ | consumption | (F1) |
| `i` | $\hat{I}_t$ | investment | (F5) |
| `w` | $\hat{W}_t$ | real wage | (F2), (F6) |
| `l` | $\hat{L}_t$ | labor | (F2), (F12) |
| `pi` | $\hat{\Pi}_t$ | inflation | (F13) |
| `r` | $\hat{R}_t$ | real interest rate | (F15) |
| `rn` | $\hat{R}_t^n$ | nominal policy rate | (F14) |
| `zk` | $\hat{Z}_t^k$ | marginal product/rental return component of capital | (F4), (F7) |
| `u` | $\hat{U}_t$ | capital utilization | (F4) |
| `k` | $\hat{K}_t$ | capital stock | (F3) |
| `q` | $\hat{Q}_t$ | price of capital / Tobin's Q | (F5), (F7) |
| `rk` | $\hat{R}_t^k$ | capital return / external financing cost | (F7), (F9) |
| `ext_pr` | $\hat{E}P_t$ | external finance premium / spread | (F8), (F9) |
| `n` | $\hat{N}_t$ | firms' net worth | (F10) |
| `yf, cf, if, wf, lf, rf, zkf, uf, kf, qf, rkf, ext_prf, nf` | flexible-price counterparts | auxiliary natural-rate system for output gap | (F23)-(F35) |
| `a, g, eps_x, eps_r, eps_p, eps_w, eps_k` | $\varepsilon_t^a,\varepsilon_t^g,\varepsilon_t^x,\varepsilon_t^r,\varepsilon_t^p,\varepsilon_t^w,\varepsilon_t^k$ | endogenous shock states | (F16)-(F22) |

### Exogenous innovations

| ASCII name | Meaning |
|---|---|
| `e_a` | technology innovation |
| `e_g` | government-spending innovation |
| `e_x` | investment-specific technology innovation |
| `e_r` | monetary-policy innovation |
| `e_p` | price mark-up innovation |
| `e_w` | wage mark-up innovation |
| `e_k` | capital-quality innovation |

### Parameters

| ASCII name | Meaning | Source value or role |
|---|---|---|
| `beta` | discount factor $\beta$ | 0.99 |
| `alpha` | capital income share $\alpha$ | 0.33 |
| `delta` | depreciation rate $\delta$ | 0.025 |
| `epsilon`, `epsilon_w` | goods and labor substitution elasticities | target gross markups 1.20 |
| `G_Y` | government-spending-to-GDP ratio | 0.20 |
| `theta` | firm survival probability | 0.972 |
| `N_K` | net-worth-to-capital ratio | 0.500, so $K/N=2$ |
| `kappa` | elasticity of external finance premium | EA posterior mean about 0.04 |
| `h` | habit parameter | EA posterior mean about 0.69 |
| `ksi` | investment adjustment cost | EA posterior mean about 4.59 |
| `zeta` | capital-utilization elasticity transform | EA posterior mean about 0.95 |
| `sigma_p`, `sigma_w` | Calvo price and wage parameters | EA posterior means about 0.82 and 0.77 |
| `sigma_pi`, `sigma_wi` | price and wage indexation | EA posterior means about 0.15 and 0.37 |
| `phi` | inverse Frisch elasticity | EA posterior mean about 1.34 |
| `Theta` | fixed-cost/production scale parameter | EA posterior mean about 1.33 |
| `rho_pi`, `rho_y`, `rho_dy`, `rho_r` | Taylor-rule parameters | EA posterior means about 1.80, 0.09, 0.06, 0.88 |
| `rho_a`, `rho_k`, `rho_g`, `rho_x`, `rho_ri`, `rho_p`, `rho_w` | shock persistence parameters | estimated AR coefficients |
| `bas_point`, `s_coef` | steady-state spread transform | implementation target 150 annual basis points |

Proposed catalog row: `EA_VI16bgg,Derivation,Financial frictions in the Euro Area and the United States: a Bayesian assessment,2016,Linearized DSGE,Euro Area,Financial frictions,Smets-Wouters with BGG firm balance-sheet channel,2026-06-17,raw/mmb_mineru/runs/ea_vi16bgg_ea_vi16gk_us_vi16bgg_us_vi16gk__financial_frictions_in_the_euro_area_and_the_united_states_a_bayesian_as__ed2f2b1d/full.md,raw/mmb_papers/Financial frictions in the Euro Area and the United States- a Bayesian assessment.pdf,10.1017/s1365100514000881,needs_review`
