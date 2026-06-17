# US_VI16gk -- Derivation (Optimization Problems + First-Order Conditions)

> This draft is for the private MMB derivation archive. Runtime validation was not performed. Formula quality is `needs_review` because the equations were extracted from MinerU Markdown OCR and cross-checked only against the Rep-MMB implementation, not against the PDF body.

Source: Stefania Villa (2016), "Financial frictions in the Euro Area and the United States: a Bayesian assessment," *Macroeconomic Dynamics*, 20(05), 1313-1340. DOI: `10.1017/s1365100514000881`. Model `US_VI16gk` is the US-estimated Smets-Wouters/Gertler-Karadi financial-intermediary variant.

## 1. Model Overview

- **Model**: US SWGK model from Villa (2016). The model embeds Gertler-Karadi financial intermediaries into a Smets-Wouters style medium-scale New Keynesian economy.
- **Economy and experiment**: United States quarterly estimation over the paper's 1983Q1-2008Q3 sample. Observables are output growth, consumption growth, investment growth, hours, inflation, wage growth, and the nominal interest rate.
- **Agents and blocks**: households, labor unions, labor packers, retailers, final-good firms, intermediate-good firms, capital producers, financial intermediaries, and the monetary authority. The implementation also includes a flexible-price/wage reference economy used to form output gaps.
- **Financial friction**: bankers manage financial intermediaries. They survive with probability $\theta$, receive a start-up transfer equal to fraction $\chi$ of assets when newly entering, and face a moral-hazard incentive constraint because they can divert fraction $\lambda$ of assets.
- **Form**: log-linear `model(linear)`. Variables with hats denote log deviations or percentage deviations from steady state. The Rep-MMB `.mod` implements the US GK branch with `model(linear)`.

## 2. Optimization Problems

### 2.1 Household

The paper does not print the full nonlinear household problem in the main text, but Table 1 gives the linearized Euler equation and marginal-utility definition. The household has external habit in consumption, supplies differentiated labor through unions, deposits funds with financial intermediaries, and owns worker/banker members.

In archive notation, the consumption-saving block is summarized by marginal utility $\hat{\mu}_t$ and stochastic discount factor $\hat{\Lambda}_{t,t+1}$:

$$
(1-h)\hat{\mu}_t = h\hat{C}_{t-1}-\hat{C}_t .
$$

### 2.2 Labor Unions

Labor unions set differentiated wages under Calvo wage stickiness and partial wage indexation. Their optimization yields the wage Phillips curve in Section 3. The full nonlinear recursive union problem is not in the main-paper Markdown; the linearized condition is source-stated in Table 1.

### 2.3 Retailers and Intermediate-Good Firms

Retailers set differentiated goods prices under Calvo price stickiness and partial price indexation. Intermediate-good firms rent effective capital and labor, choose utilization, and produce with fixed-cost/scale parameter $\Theta$. The source prints the linearized price Phillips curve, utilization condition, factor FOC, production function, and capital-return equation.

### 2.4 Capital Producers

Capital producers transform investment and depreciated capital into installed capital subject to investment adjustment costs and investment-specific technology shocks. Their linearized optimality condition is the investment Euler equation in Section 3.

### 2.5 Financial Intermediaries

Bankers choose assets and liabilities subject to an incentive constraint. The paper states the resulting linearized GK conditions for the gain from expanding assets, the value of expanding net worth, the growth rates of net worth/assets, leverage, net worth aggregation, and spread. The incentive constraint has the standard GK interpretation: assets can expand only as a multiple of bank net worth, with the multiplier tied to continuation values and the divertible-asset parameter $\lambda$.

## 3. First-Order Conditions

**Household and wage-setting block**

- **(F1) Habit-adjusted marginal utility**:

$$
(1-h)\hat{\mu}_t = h\hat{C}_{t-1}-\hat{C}_t .
$$

- **(F2) Stochastic discount factor**:

$$
\hat{\Lambda}_{t,t+1} = \hat{\mu}_{t+1}-\hat{\mu}_t .
$$

- **(F3) Consumption Euler equation**:

$$
\frac{1+h}{1-h}\hat{C}_t
= \frac{1}{1-h}E_t\hat{C}_{t+1}
+ \frac{h}{1-h}\hat{C}_{t-1}
- \hat{R}_t .
$$

- **(F4) Wage Phillips curve**:

$$
\begin{aligned}
\hat{W}_t
=&\frac{\beta}{1+\beta}E_t\hat{W}_{t+1}
+\frac{1}{1+\beta}\hat{W}_{t-1}
+\frac{\beta}{1+\beta}E_t\hat{\Pi}_{t+1}
-\frac{1+\beta\sigma_{wi}}{1+\beta}\hat{\Pi}_t
+\frac{\sigma_{wi}}{1+\beta}\hat{\Pi}_{t-1} \\
&+\frac{1}{1+\beta}
\frac{(1-\beta\sigma_w)(1-\sigma_w)}
{\sigma_w(1+\varepsilon_w\phi)}
\left[\phi\hat{L}_t-\frac{h}{1-h}\hat{C}_{t-1}
+\frac{1}{1-h}\hat{C}_t-\hat{W}_t\right]
+\varepsilon_t^w .
\end{aligned}
$$

**Capital, production, and pricing**

- **(F5) Capital accumulation**:

$$
\hat{K}_{t+1}=\delta(\hat{I}_t+\varepsilon_t^x)
+(1-\delta)(\hat{K}_t+\varepsilon_t^k) .
$$

- **(F6) Optimal capital utilization**:

$$
\hat{Z}^k_t=\frac{\zeta}{1-\zeta}\hat{U}_t .
$$

- **(F7) Investment Euler equation**:

$$
\hat{I}_t
=\frac{1}{\xi(1+\beta)}(\hat{Q}_t+\varepsilon_t^x)
+\frac{1}{1+\beta}\hat{I}_{t-1}
+\frac{\beta}{1+\beta}E_t\hat{I}_{t+1}.
$$

- **(F8) Production function**:

$$
\hat{Y}_t=\Theta\left[
\varepsilon_t^a+\alpha(\hat{K}_t+\varepsilon_t^k+\hat{U}_t)
+(1-\alpha)\hat{L}_t
\right].
$$

- **(F9) Intermediate-firm factor FOC**:

$$
\hat{W}_t=\hat{Z}^k_t-\hat{L}_t+\hat{K}_t+\hat{U}_t .
$$

- **(F10) Price Phillips curve**:

$$
\hat{\Pi}_t
=\frac{\sigma_{\pi}}{1+\beta\sigma_{\pi}}\hat{\Pi}_{t-1}
+\frac{\beta}{1+\beta\sigma_{\pi}}E_t\hat{\Pi}_{t+1}
-\frac{(1-\beta\sigma_p)(1-\sigma_p)}
{(1+\beta\sigma_{\pi})\sigma_p}
\left[\varepsilon_t^a-\alpha\hat{Z}^k_t-(1-\alpha)\hat{W}_t\right]
+\varepsilon_t^p .
$$

- **(F11) Capital return**:

$$
\hat{R}^k_t
=\frac{Z^k}{R^k}\hat{Z}^k_t
+\frac{1-\delta}{R^k}(\hat{Q}_t+\varepsilon_t^k)
-\hat{Q}_{t-1}.
$$

**Financial intermediary block**

- **(F12) Gain from expanding assets**:

$$
\hat{V}_t
=\frac{(1-\theta)\beta}{V}(R^k-R)E_t\hat{\Lambda}_{t,t+1}
+\frac{(1-\theta)\beta}{V}\left(R^kE_t\hat{R}^k_{t+1}-R\hat{R}_t\right)
+\theta\beta X E_t(\hat{X}_{t,t+1}+\hat{V}_{t+1}+\hat{\Lambda}_{t,t+1}) .
$$

- **(F13) Value of expanding net worth**:

$$
\hat{D}_t=\theta\beta Z E_t(\hat{\Lambda}_{t,t+1}+\hat{Z}_{t,t+1}+\hat{D}_{t+1}) .
$$

- **(F14) Gross growth rate of net worth**:

$$
\hat{Z}_{t,t+1}
=\frac{1}{Z}\left[
\mathrm{lev}\,R^k E_t\hat{R}^k_{t+1}
+R(1-\mathrm{lev})\hat{R}_t
+(R^k-R)\mathrm{lev}\,\widehat{\mathrm{lev}}_t
\right].
$$

- **(F15) Gross growth rate of assets**:

$$
\hat{X}_{t,t+1}=E_t\widehat{\mathrm{lev}}_{t+1}+\hat{Z}_{t,t+1}-\widehat{\mathrm{lev}}_t .
$$

- **(F16) Leverage condition from the banker incentive constraint** (`needs_review`: the paper table gives the contemporaneous equation, while Rep-MMB shifts it one period forward for determinacy):

$$
\widehat{\mathrm{lev}}_t=\hat{D}_t+\frac{V}{\lambda-V}\hat{V}_t .
$$

- **(F17) FI balance-sheet constraint** (`needs_review`: the source table uses $K_{t+1}+Q_t$; the Rep-MMB implementation uses a static $k+q$ convention):

$$
\hat{K}_{t+1}+\hat{Q}_t=\widehat{\mathrm{lev}}_t+\hat{N}_t .
$$

- **(F18) Net worth of existing financial intermediaries**:

$$
\hat{N}^e_t=\hat{N}_{t-1}+\hat{Z}_{t,t+1}.
$$

- **(F19) Net worth of new financial intermediaries**:

$$
\hat{N}^n_t=\hat{Q}_t+\hat{K}_t .
$$

- **(F20) Total intermediary net worth**:

$$
\hat{N}_t
=\frac{N^e}{Y}\frac{Y}{N}\hat{N}^e_t
+\frac{N^n}{Y}\frac{Y}{N}\hat{N}^n_t .
$$

- **(F21) External finance premium / spread**:

$$
\widehat{EP}_t=E_t\hat{R}^k_{t+1}-\hat{R}_t .
$$

## 4. Market Clearing & Identities

- **(F22) Resource constraint**:

$$
\hat{Y}_t=\frac{C}{Y}\hat{C}_t+\frac{I}{Y}\hat{I}_t+\frac{G}{Y}\hat{G}_t+\frac{Z^kK}{Y}\hat{U}_t .
$$

- **(F23) Taylor rule with output-gap and output-gap-growth responses**:

$$
\hat{R}^n_t
=\rho_i\hat{R}^n_{t-1}
+(1-\rho_i)\left[\rho_{\pi}\hat{\Pi}_t+\rho_y(\hat{Y}_t-\hat{Y}^p_t)\right]
+\rho_{\Delta y}\left[(\hat{Y}_t-\hat{Y}^p_t)-(\hat{Y}_{t-1}-\hat{Y}^p_{t-1})\right]
+\varepsilon_t^r .
$$

- **(F24) Fisher equation**:

$$
\hat{R}^n_t=\hat{R}_t+E_t\hat{\Pi}_{t+1}.
$$

- **(F25) Measurement equations**:

$$
\begin{bmatrix}
\Delta Y_t^o\\ \Delta C_t^o\\ \Delta I_t^o\\ \Delta W_t^o\\ L_t^o\\ \pi_t^o\\ r_t^{n,o}
\end{bmatrix}
=
\begin{bmatrix}
\gamma\\ \gamma\\ \gamma\\ \gamma\\ 0\\ \bar{\pi}\\ \bar{r}^n
\end{bmatrix}
+
\begin{bmatrix}
\hat{Y}_t-\hat{Y}_{t-1}\\
\hat{C}_t-\hat{C}_{t-1}\\
\hat{I}_t-\hat{I}_{t-1}\\
\hat{W}_t-\hat{W}_{t-1}\\
\hat{L}_t\\
\hat{\Pi}_t\\
\hat{R}^n_t
\end{bmatrix}.
$$

The flexible-price/wage reference economy uses the same real and financial blocks, but sets price/wage mark-up distortions aside so that $\hat{Y}^p_t$ can enter the policy rule. The Rep-MMB cross-check names the corresponding variables with an `f` suffix (`yf`, `cf`, `kf`, `qf`, `nf`, and related variables).

## 5. Exogenous Processes

- **(F26) Technology shock**:

$$
\varepsilon_t^a=\rho_A\varepsilon_{t-1}^a+e_t^a .
$$

- **(F27) Investment-specific technology shock**:

$$
\varepsilon_t^x=\rho_X\varepsilon_{t-1}^x+e_t^x .
$$

- **(F28) Government-spending shock**:

$$
\hat{G}_t=\rho_G\hat{G}_{t-1}+e_t^g .
$$

- **(F29) Monetary-policy shock**:

$$
\varepsilon_t^r=\rho_{ri}\varepsilon_{t-1}^r+e_t^r .
$$

- **(F30) Price mark-up shock**:

$$
\varepsilon_t^p=\rho_P\varepsilon_{t-1}^p+e_t^p .
$$

- **(F31) Wage mark-up shock**:

$$
\varepsilon_t^w=\rho_W\varepsilon_{t-1}^w+e_t^w .
$$

- **(F32) Capital-quality shock**:

$$
\varepsilon_t^k=\rho_k\varepsilon_{t-1}^k+e_t^k .
$$

The Rep-MMB implementation uses negative signs for several innovation terms. This archive keeps the paper-side AR(1) sign convention above and marks the sign mapping as an implementation-cross-check item.

## 6. Steady-State Solution

Because the model is linearized, the endogenous hatted variables have zero steady state:

$$
\hat{C}=\hat{I}=\hat{Y}=\hat{K}=\hat{Q}=\hat{L}=\hat{W}=\hat{\Pi}=\hat{R}=\hat{R}^n=\hat{N}=\widehat{EP}=0 .
$$

Source-stated calibration targets and steady-state definitions:

$$
\beta=0.99,\quad \alpha=0.33,\quad \delta=0.025,\quad G/Y=0.20,\quad
\varepsilon=\varepsilon_w=6 .
$$

For the SWGK financial block, Villa (2016) calibrates:

$$
\theta=0.972,\quad \chi=0.001,\quad \lambda=0.515,\quad \mathrm{lev}=4,
$$

with a target annual spread of 150 basis points. The Rep-MMB US implementation cross-check uses posterior/calibrated values including $\theta=0.9715$, $\lambda=0.5152$, $\chi=0.001$, $RK=1.013860066271978$, $h=0.44$, $\xi=4.27$, $\sigma_p=0.89$, $\sigma_w=0.84$, $\rho_r=0.85$, $\rho_{\pi}=1.89$, $\rho_y=0.09$, $\rho_{\Delta y}=0.20$, trend $=0.32$, and steady inflation `picbar = 0.64`.

`needs_review`: a full nonlinear steady-state derivation is not printed in the main Markdown and was not reconstructed. The implementation defines transformed steady-state constants (`R`, `ZK`, `W`, `K_L`, `Y_K`, `I_Y`, `C_Y`, `LEV`, `Z`, `X`, `V`) before the linear model block; those definitions should be reviewed if this entry is promoted toward runnable replication.

## 7. Timing & Form Conventions

- **Form**: `model(linear)`; hatted variables are deviations from steady state. The Chinese and English derivations keep the same equation numbering.
- **Capital timing**: The paper states capital bought at the end of period $t$ is $K_{t+1}$ and is used in $t+1$. The Rep-MMB implementation notes that equation 19b was changed from forward-looking capital to a static `k` convention.
- **Capital return timing**: Rep-MMB note 1 says equation 13 is shifted one period backward, consistent with Gertler-Karadi notation.
- **Leverage timing**: Rep-MMB note 2 says equation 18b is shifted one period forward to guarantee determinacy; the original contemporaneous equation is left commented in the implementation.
- **Flexible reference model**: Variables with an `f` suffix in the implementation represent the flexible-price/wage counterpart used in policy-rule gaps.
- **Runtime validation**: Not performed. No Dynare commands were run for this archive task.

## 8. Variable & Parameter Reference Table

### Endogenous Variables

| ASCII name | Mathematical symbol | Meaning | Main equation |
|---|---|---|---|
| `y` | $\hat{Y}_t$ | output | (F8), (F22) |
| `i` | $\hat{I}_t$ | investment | (F7), (F22) |
| `c` | $\hat{C}_t$ | consumption | (F3), (F22) |
| `l` | $\hat{L}_t$ | labor | (F4), (F8), (F9) |
| `w` | $\hat{W}_t$ | real wage | (F4), (F9) |
| `pi` | $\hat{\Pi}_t$ | inflation | (F10), (F24) |
| `r` | $\hat{R}_t$ | real interest rate | (F3), (F24) |
| `rn` | $\hat{R}^n_t$ | nominal interest rate | (F23), (F24) |
| `k` | $\hat{K}_t$ | capital | (F5), (F17) |
| `u` | $\hat{U}_t$ | utilization | (F6), (F8), (F22) |
| `zk` | $\hat{Z}^k_t$ | marginal product/rental return component | (F6), (F9), (F11) |
| `q` | $\hat{Q}_t$ | price of capital | (F7), (F11), (F17) |
| `rk` | $\hat{R}^k_t$ | capital return | (F11), (F21) |
| `mu` | $\hat{\mu}_t$ | marginal utility | (F1), (F2) |
| `Lambda` | $\hat{\Lambda}_{t,t+1}$ | stochastic discount factor | (F2), (F12), (F13) |
| `v` | $\hat{V}_t$ | value of expanding intermediary assets | (F12), (F16) |
| `d` | $\hat{D}_t$ | value of expanding net worth | (F13), (F16) |
| `z` | $\hat{Z}_{t,t+1}$ | net-worth growth | (F14), (F18) |
| `x` | $\hat{X}_{t,t+1}$ | asset growth | (F15), (F12) |
| `lev` | $\widehat{\mathrm{lev}}_t$ | leverage | (F15), (F16), (F17) |
| `n` | $\hat{N}_t$ | total FI net worth | (F20) |
| `ne` | $\hat{N}^e_t$ | existing FI net worth | (F18), (F20) |
| `nn` | $\hat{N}^n_t$ | new FI net worth | (F19), (F20) |
| `ext_pr` | $\widehat{EP}_t$ | external finance premium/spread | (F21) |
| `yf`, `cf`, `if`, `kf`, `qf`, `nf`, ... | superscript $p$ or flexible counterpart | flexible-price/wage reference variables | analogous flexible block |
| `dy`, `dc`, `dfi`, `dw`, `hobsgm`, `piobs`, `robs` | observable mappings | measurement variables | (F25) |

### Exogenous Innovations

| ASCII name | Meaning | Process |
|---|---|---|
| `e_a` | technology innovation | (F26) |
| `e_x` | investment-specific technology innovation | (F27) |
| `e_g` | government-spending innovation | (F28) |
| `e_r` | monetary-policy innovation | (F29) |
| `e_p` | price mark-up innovation | (F30) |
| `e_w` | wage mark-up innovation | (F31) |
| `e_k` | capital-quality innovation | (F32) |

### Parameters

| ASCII name | Meaning | Source value or role |
|---|---|---|
| `beta` | discount factor | 0.99 |
| `alpha` | capital share | 0.33 |
| `delta` | depreciation | 0.025 |
| `epsilon`, `epsilon_w` | goods/labor substitution elasticities | set to target markups of 1.20 |
| `G_Y` | government spending share | 0.20 |
| `h` | habit | estimated/posterior for US GK |
| `phi` | inverse Frisch elasticity | estimated/posterior for US GK |
| `lambda` | divertible-asset fraction | 0.515 baseline; 0.5152 in Rep-MMB US implementation |
| `theta` | banker survival probability | 0.972 baseline; 0.9715 in Rep-MMB US implementation |
| `chi` | fraction of assets transferred to new bankers | 0.001 |
| `zeta` | utilization elasticity parameter | estimated/posterior |
| `ksi` | investment adjustment cost | estimated/posterior |
| `sig_p`, `sig_pi` | price stickiness and indexation | estimated/posterior |
| `sig_w`, `sig_wi` | wage stickiness and indexation | estimated/posterior |
| `rho_r`, `rho_PI`, `rho_Y`, `rho_DY` | Taylor-rule parameters | estimated/posterior |
| `rho_A`, `rho_X`, `rho_G`, `rho_ri`, `rho_P`, `rho_W`, `rho_k` | shock persistence parameters | (F26)-(F32) |
| `RK`, `picbar`, `trend`, `constelab` | steady-state/measurement constants | Rep-MMB implementation cross-check |
