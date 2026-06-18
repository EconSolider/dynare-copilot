# EAUS_NAWMctww Derivation

> Status: `needs_review`. This is a first-pass paper-side extraction from MinerU Markdown, with the MMB replication file used only as `implementation_cross_check`. Dynare runtime validation was not performed.

Source provenance: Cogan, John F.; Taylor, John B.; Wieland, Volker; Wolters, Maik H. (2013), "Fiscal consolidation strategy", Journal of Economic Dynamics and Control 37, 404-421, DOI `10.1016/j.jedc.2012.10.004`. Main source: `raw/mmb_mineru/runs/eaus_nawmctww__fiscal_consolidation_strategy__97cf0e5f/full.md`; raw PDF recorded at `raw/mmb_papers/Fiscal consolidation strategy.pdf`.

## 1. Model Overview

- **Model**: `EAUS_NAWMctww`, the Cogan-Taylor-Wieland-Wolters fiscal-consolidation calibration of the Coenen-McAdam-Straub New Area-Wide Model (NAWM/CMS).
- **Purpose**: evaluate U.S. fiscal consolidation in a two-region United States/euro-area DSGE model with forward-looking agents, nominal rigidities, fiscal instruments, and government debt.
- **Agents and authorities**: two household types in each economy, intermediate-good firms, final-good firms, fiscal authorities, monetary authorities, and a foreign bond market linking the two regions.
- **Form**: nonlinear equilibrium system solved around a deterministic steady state. The paper presents structural nonlinear equations and simulations; the MMB `.mod` cross-check also uses a nonlinear `model;` block, not `model(linear)`.
- **Source coverage**: the Markdown includes the main structural equations for the fiscal sector, households, firms, and monetary rule. Some first-order recursions and implementation variables are documented more fully in the `.mod`; where that source is used, it is marked as implementation-only cross-check evidence.

## 2. Optimization Problems

### 2.1 Household I

Household I members can choose consumption, investment, next-period capital, capital utilization, domestic bonds, foreign-currency bonds, and money. Their period utility has external habit in consumption and separable disutility from labor:

```math
E_t \sum_{k=0}^{\infty}\beta^k\left[
\frac{(C_{i,t+k}-\kappa C_{I,t+k-1})^{1-\sigma}}{1-\sigma}
-\frac{N_{i,t+k}^{1+\theta}}{1+\theta}
\right].
```

Their nominal budget constraint is:

```math
\begin{aligned}
&(1+\tau_t^C+\Gamma_v(v_{i,t}))P_{C,t}C_{i,t}+P_{I,t}I_{i,t}
+R_t^{-1}B_{i,t+1}
+\big((1-\Gamma_{B^F}(B_t^F))R_{F,t}\big)^{-1}S_tB_{i,t+1}^F
+M_{i,t}+\phi_{i,t} \\
&=(1-\tau_t^N-\tau_t^{W_h})W_{i,t}N_{i,t}
+(1-\tau_t^K)(R_{K,t}u_{i,t}-\Gamma_u(u_{i,t})P_{I,t})K_{i,t}
+\tau_t^K\delta P_{I,t}K_{i,t} \\
&\quad +(1-\tau_t^D)D_{i,t}+TR_{i,t}-T_{i,t}
+B_{i,t}+S_tB_{i,t}^{F}+M_{i,t-1}.
\end{aligned}
```

Capital accumulation is:

```math
K_{i,t+1}=(1-\delta)K_{i,t}+\left[1-\Gamma_I\left(\frac{I_{i,t}}{I_{i,t-1}}\right)\right]I_{i,t}.
```

Household I also supplies differentiated labor under Calvo wage setting with indexation when the wage cannot be reset.

### 2.2 Household J

Household J has the same utility kernel as Household I but cannot access bond markets or accumulate physical capital. It chooses consumption, money, and labor subject to:

```math
(1+\tau_t^C+\Gamma_v(v_{j,t}))P_{C,t}C_{j,t}+M_{j,t}
=(1-\tau_t^N-\tau_t^{W_h})W_{j,t}N_{j,t}+TR_{j,t}-T_{j,t}+M_{j,t-1}+\phi_{j,t}.
```

Household J also sets differentiated wages with the same Calvo-indexation structure. The fiscal-consolidation calibration distributes transfers and lump-sum taxes equally across household types rather than using the unequal CMS baseline distribution.

### 2.3 Intermediate-Good Firms

Intermediate firms produce tradable differentiated goods with capital services and a labor aggregate:

```math
Y_{f,t}=\max\left[z_tK_{f,t}^{\alpha}N_{f,t}^{1-\alpha}-\psi,0\right].
```

They minimize input cost and set domestic and export prices under Calvo contracts and indexation. Firms able to reset prices maximize expected discounted profits over the domestic and export markets.

### 2.4 Final-Good Firms

Final-good firms combine domestic intermediate goods and imported intermediate bundles into private consumption and investment goods using CES technologies with import adjustment costs. The public consumption good uses domestic intermediate goods.

### 2.5 Authorities

The fiscal authority sets government purchases, transfers, debt targets, and distortionary tax rates, while lump-sum taxes respond to the debt gap. The monetary authority sets the nominal interest rate through a Taylor-type rule with interest-rate smoothing.

## 3. First-Order Conditions

The equations below are a compact source-backed derivation. Some full implementation recursions are marked `needs_review` because the paper gives abbreviated structural equations and the `.mod` contains the operational recursive form.

**Household I**

- **(F1) Marginal utility of consumption with transaction cost wedge**:

```math
\lambda_{I,t}\left(1+\tau_t^C+\Gamma_v(v_{I,t})+v_{I,t}\Gamma_v'(v_{I,t})\right)
= (C_{I,t}-\kappa C_{I,t-1})^{-\sigma}.
```

- **(F2) Domestic bond Euler equation**:

```math
R_t=\beta^{-1}\frac{\lambda_{I,t}}{\lambda_{I,t+1}}\Pi_{C,t+1}.
```

- **(F3) Money demand / velocity condition**:

```math
v_{I,t}^2\Gamma_v'(v_{I,t})
=1-\beta\frac{\lambda_{I,t+1}}{\lambda_{I,t}\Pi_{C,t+1}}.
```

- **(F4) Consumption velocity definition**:

```math
v_{I,t}=\frac{(1+\tau_t^C)C_{I,t}}{M_{I,t}}.
```

- **(F5) Investment adjustment cost**:

```math
\Gamma_I\left(\frac{I_{I,t}}{I_{I,t-1}}\right)
=\frac{\gamma_I}{2}\left(\frac{I_{I,t}}{I_{I,t-1}}-1\right)^2.
```

- **(F6) Capital accumulation**:

```math
K_{I,t+1}=(1-\delta)K_{I,t}+\left[1-\Gamma_I\left(\frac{I_{I,t}}{I_{I,t-1}}\right)\right]I_{I,t}.
```

- **(F7) Capital-utilization condition**:

```math
R_{K,t}=P_{I,t}\Gamma_u'(u_t).
```

- **(F8) Investment FOC for the price of installed capital**:

```math
P_{I,t}=Q_t\left[1-\Gamma_I(s_t)-\Gamma_I'(s_t)s_t\right]
+\beta E_t\left[\frac{\lambda_{I,t+1}}{\lambda_{I,t}}Q_{t+1}\Gamma_I'(s_{t+1})s_{t+1}^2\right],
\quad s_t=\frac{I_{I,t}}{I_{I,t-1}}.
```

- **(F9) Capital Euler equation with capital income taxes**:

```math
Q_t=\beta E_t\left[\frac{\lambda_{I,t+1}}{\lambda_{I,t}}
\left((1-\tau_{t+1}^K)(R_{K,t+1}u_{t+1}-\Gamma_u(u_{t+1})P_{I,t+1})
+\tau_{t+1}^K\delta P_{I,t+1}+(1-\delta)Q_{t+1}\right)\right].
```

- **(F10) Household I optimal reset wage** (`needs_review`, paper states Calvo wage problem but not the full recursion):

```math
\widetilde W_{I,t}^{1+\eta_I\theta}
=\frac{\eta_I}{\eta_I-1}\frac{F_{I,t}}{G_{I,t}}.
```

**Household J**

- **(F11) Household J budget constraint**:

```math
(1+\tau_t^C+\Gamma_v(v_{J,t}))P_{C,t}C_{J,t}+M_{J,t}
=(1-\tau_t^N-\tau_t^{W_h})W_{J,t}N_{J,t}+TR_{J,t}-T_{J,t}+M_{J,t-1}.
```

- **(F12) Household J marginal utility of consumption**:

```math
\lambda_{J,t}\left(1+\tau_t^C+\Gamma_v(v_{J,t})+v_{J,t}\Gamma_v'(v_{J,t})\right)
=(C_{J,t}-\kappa C_{J,t-1})^{-\sigma}.
```

- **(F13) Household J money demand**:

```math
v_{J,t}^2\Gamma_v'(v_{J,t})
=1-\beta\frac{\lambda_{J,t+1}}{\lambda_{J,t}\Pi_{C,t+1}}.
```

- **(F14) Household J optimal reset wage** (`needs_review`):

```math
\widetilde W_{J,t}^{1+\eta_J\theta}
=\frac{\eta_J}{\eta_J-1}\frac{F_{J,t}}{G_{J,t}}.
```

**Firms**

- **(F15) Production technology**:

```math
Y_{s,t}=z_tK_{d,t}^{\alpha}N_{d,t}^{1-\alpha}-\psi.
```

- **(F16) Capital demand condition**:

```math
R_{K,t}=\alpha\frac{Y_{s,t}+\psi}{K_{d,t}}MC_t.
```

- **(F17) Marginal cost**:

```math
MC_t=\frac{R_{K,t}^{\alpha}\left((1+\tau_t^{W_f})W_t\right)^{1-\alpha}}
{z_t\alpha^{\alpha}(1-\alpha)^{1-\alpha}}.
```

- **(F18) Labor aggregation and labor demands**:

```math
N_{d,t}^{1-1/\eta}
=(1-\omega)^{1/\eta}N_{dI,t}^{1-1/\eta}
+\omega^{1/\eta}N_{dJ,t}^{1-1/\eta},
```

```math
N_{dI,t}=(1-\omega)\left(\frac{W_{I,t}}{W_t}\right)^{-\eta}N_{d,t},
\quad
N_{dJ,t}=\omega\left(\frac{W_{J,t}}{W_t}\right)^{-\eta}N_{d,t}.
```

- **(F19) Domestic-price Calvo reset condition** (`needs_review`):

```math
\frac{\widetilde P_{H,t}}{P_{H,t}}
=\frac{\theta_p}{\theta_p-1}\frac{F_{H,t}}{G_{H,t}}.
```

- **(F20) Domestic-price indexation law**:

```math
P_{H,t}^{1-\theta_p}
=(1-\xi_H)\widetilde P_{H,t}^{1-\theta_p}
+\xi_H\left(P_{H,t-1}\Pi_{H,t-1}^{\chi_H}\bar\Pi_H^{1-\chi_H}/\Pi_{C,t}\right)^{1-\theta_p}.
```

- **(F21) Export-price Calvo reset condition** (`needs_review`):

```math
\frac{\widetilde P_{X,t}}{P_{X,t}}
=\frac{\theta_p}{\theta_p-1}\frac{F_{X,t}}{G_{X,t}}.
```

- **(F22) Consumption-good CES technology**:

```math
Q_{C,t}^{(\mu_C-1)/\mu_C}
=\nu_C^{1/\mu_C}H_{C,t}^{1-1/\mu_C}
+(1-\nu_C)^{1/\mu_C}\left[(1-\Gamma_{IM,C,t})IM_{C,t}\right]^{1-1/\mu_C}.
```

- **(F23) Investment-good CES technology**:

```math
Q_{I,t}^{(\mu_I-1)/\mu_I}
=\nu_I^{1/\mu_I}H_{I,t}^{1-1/\mu_I}
+(1-\nu_I)^{1/\mu_I}\left[(1-\Gamma_{IM,I,t})IM_{I,t}\right]^{1-1/\mu_I}.
```

## 4. Market Clearing & Identities

- **(F24) Government budget constraint**:

```math
\begin{aligned}
P_{G,t}G_t+TR_t+B_t+M_{t-1}
&=\tau_t^CP_{C,t}C_t+\tau_t^N(W_{I,t}N_t^I+W_{J,t}N_t^J)
+\tau_t^{W_h}(W_{I,t}N_t^I+W_{J,t}N_t^J) \\
&\quad+\tau_t^{W_f}W_tN_t
+\tau_t^K\left(R_{K,t}u_t-(\Gamma_u(u_t)+\delta)P_{I,t}\right)K_t
+T_t+R_t^{-1}B_{t+1}+M_t.
\end{aligned}
```

- **(F25) Lump-sum tax/debt feedback rule**:

```math
\frac{T_t}{P_{Y,t}Y_t}
=\phi_{B_Y}\left(\frac{B_t}{P_{Y,t}Y_t}-B^{\ast}\right).
```

- **(F26) Fiscal expenditure shares**:

```math
P_{H,t}G_t=GY_t\,\bar P_Y\bar Y,
\quad
TR_t=TRY_t\,\bar P_Y\bar Y.
```

- **(F27) Aggregate consumption, money, capital, and investment**:

```math
C_t=(1-\omega)C_{I,t}+\omega C_{J,t},\quad
M_t=(1-\omega)M_{I,t}+\omega M_{J,t},
```

```math
K_t=(1-\omega)K_{I,t},\quad I_t=(1-\omega)I_{I,t}.
```

- **(F28) Domestic absorption and trade resource identity**:

```math
P_{Y,t}Y_t
=Q_{C,t}+P_{I,t}Q_{I,t}+P_{H,t}G_t
+RER_tP_{M,t}^{\ast}\frac{SIZE^{\ast}}{SIZE}IM_t^{\ast}
-P_{M,t}\left(\frac{IM_{C,t}(1-\Gamma_{IM,C,t})}{\Gamma_{IM,C,t}^{\dagger}}
+\frac{IM_{I,t}(1-\Gamma_{IM,I,t})}{\Gamma_{IM,I,t}^{\dagger}}\right).
```

- **(F29) Output identity**:

```math
Y_t=Y_{s,t}.
```

- **(F30) Capital services identity**:

```math
u_tK_t=K_{d,t}.
```

- **(F31) Domestic intermediate-use identity**:

```math
H_t=H_{C,t}+H_{I,t}+G_t.
```

- **(F32) Import-use identity**:

```math
IM_t=IM_{C,t}+IM_{I,t}.
```

- **(F33) Net foreign asset and trade-balance identities** (`needs_review` for exact timing in the paper-side source):

```math
TB_t=RER_tP_{M,t}^{\ast}\frac{SIZE^{\ast}}{SIZE}IM_t^{\ast}-P_{M,t}IM_t,
\quad
\frac{B_t^F}{R_{t-1}^{\ast}}=B_{t-1}^F+\frac{TB_{t-1}}{RER_{t-1}}.
```

- **(F34) World foreign-bond clearing**:

```math
SIZE\cdot B_t^F+SIZE^{\ast}\cdot B_t^{F,\ast}=0.
```

## 5. Exogenous Processes

- **(F35) Total factor productivity**:

```math
\log z_t=(1-\rho_z)\log \bar z+\rho_z\log z_{t-1}+\varepsilon^z_t.
```

- **(F36) Government-purchases ratio**:

```math
GY_t=(1-\rho_G)\bar{GY}+\rho_GGY_{t-1}+\varepsilon^G_t.
```

- **(F37) Transfer ratio**:

```math
TRY_t=(1-\rho_{TR})\bar{TRY}+\rho_{TR}TRY_{t-1}+\varepsilon^{TR}_t.
```

- **(F38) Tax-rate processes**:

```math
\tau_t^x=(1-\rho_x)\bar\tau^x+\rho_x\tau_{t-1}^x+\varepsilon_t^x,
\quad x\in\{C,D,K,N,W_h,W_f\}.
```

- **(F39) Monetary policy rule**:

```math
R_t^4-1=\phi_R(R_{t-1}^4-1)
+(1-\phi_R)\left[R_{\star}^4\bar\Pi_4-1+\phi_\Pi(\Pi_{C,t}^{(4)}-\bar\Pi_4)\right]
+\phi_{g_Y}\left(\frac{Y_t}{Y_{t-1}}-1\right)+\varepsilon^R_t.
```

- **(F40) Four-quarter CPI inflation and real interest rate**:

```math
\Pi_{C,t}^{(4)}=\Pi_{C,t}\Pi_{C,t-1}\Pi_{C,t-2}\Pi_{C,t-3},
\quad
RR_t-1=\frac{R_t}{\Pi_{C,t+1}}-1.
```

## 6. Steady-State Solution

The paper reports calibration targets and the `.mod` cross-check stores a numerical `initval` block, but this first-pass entry does not re-solve the full two-country steady state. Runtime validation was not performed.

Steady-state restrictions:

```math
z=\bar z,\quad GY=\bar{GY},\quad TRY=\bar{TRY},\quad \tau^x=\bar\tau^x.
```

```math
RR-1=\beta^{-1}-1,\quad \Pi_C^{(4)}=\bar\Pi_4,\quad R=\beta^{-1}\bar\Pi_4^{1/4}.
```

```math
\Gamma_I(1)=0,\quad \Gamma_I'(1)=0,\quad u=1,\quad K_d=K.
```

```math
\frac{T}{P_YY}=\phi_{B_Y}\left(\frac{B}{P_YY}-B^{\ast}\right).
```

The reported U.S. calibration uses `US_BETA=0.992638`, `US_SIGMA=1`, `US_KAPPA=0.67`, `US_OMEGA=0.2651`, `US_ALPHA=0.30`, `US_DELTA=0.025`, `US_GYBAR=0.16`, `US_TRYBAR=0.079732`, `US_TAUCBAR=0.077`, `US_TAUKBAR=0.184123`, `US_TAUNBAR=0.154`, `US_TAUWHBAR=0.071`, and `US_TAUWFBAR=0.071` in the implementation cross-check. These parameter values are implementation evidence, not independent paper-side formulas.

Deferred issue: a reviewed archive pass should either derive the full steady-state system from the paper and NAWM source equations or record an accepted reference steady-state file. This first pass therefore remains `needs_review`.

## 7. Timing & Form Conventions

- Capital in the paper is written as next-period capital in the household accumulation equation, while the MMB `.mod` implements `K_t` as a stock carried from prior investment with production services `K_{d,t}=u_tK_t`.
- Household I holds domestic and foreign bonds chosen for the next period; Household J cannot hold bonds and smooths only through money.
- Prices and wages use Calvo reset probabilities with indexation to lagged inflation and the steady-state inflation target when not reset.
- The model is two-region open economy. The `EAUS_NAWMctww` implementation uses U.S. variables as common comparison variables while retaining euro-area spillovers and foreign-bond clearing.
- Fiscal consolidation paths set autocorrelation for several fiscal instruments to zero in the implementation so that announced government-purchase, transfer, and tax-rate paths can be imposed directly.
- Form convention: nonlinear levels, ratios, and gross inflation/interest rates; no hand log-linearization and no `model(linear)` flag.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII hint | Meaning | Main equation(s) |
|---|---|---|---|
| Endogenous | `C_I`, `C_J`, `C` | Household I/J and aggregate consumption | (F1), (F11), (F12), (F27) |
| Endogenous | `lambda_I`, `lambda_J` | Marginal utilities / multipliers | (F1), (F12) |
| Endogenous | `M_I`, `M_J`, `M`, `v_I`, `v_J` | Money and consumption velocity | (F3), (F4), (F13), (F27) |
| Endogenous | `K_I`, `K`, `K_d`, `I_I`, `I`, `u` | Capital, investment, utilization | (F6), (F7), (F8), (F9), (F27), (F30) |
| Endogenous | `R`, `RR`, `R_K`, `Q` | Nominal/real rates, rental rate, Tobin's Q | (F2), (F7), (F8), (F9), (F40) |
| Endogenous | `W_I`, `W_J`, `W`, `N_I`, `N_J`, `N_d` | Wages and labor aggregates | (F10), (F14), (F18) |
| Endogenous | `Y_s`, `Y`, `MC`, `D` | Production, output, marginal cost, dividends | (F15), (F16), (F17), (F29) |
| Endogenous | `P_H`, `P_X`, `P_C`, `P_I`, `Pi_C` | Domestic/export/final-good prices and inflation | (F19), (F20), (F21), (F40) |
| Endogenous | `Q_C`, `Q_I`, `H_C`, `H_I`, `IM_C`, `IM_I` | Final goods and import bundles | (F22), (F23), (F31), (F32) |
| Endogenous | `G`, `TR`, `T`, `B`, `BY`, `GY`, `TRY` | Fiscal variables and debt ratios | (F24), (F25), (F26), (F36), (F37) |
| Endogenous | `RER`, `TB`, `B_F` | Real exchange rate, trade balance, foreign bonds | (F28), (F33), (F34) |
| Exogenous | `eps_z`, `eps_g`, `eps_tr`, `eps_r` | TFP, government-purchase, transfer, monetary innovations | (F35), (F36), (F37), (F39) |
| Exogenous | `eps_tauc`, `eps_taud`, `eps_tauk`, `eps_taun`, `eps_tauwh`, `eps_tauwf` | Tax-rate innovations | (F38) |
| Parameters | `beta`, `sigma`, `kappa`, `theta`, `omega` | Preferences and household shares | (F1), (F10), (F12), (F14), (F27) |
| Parameters | `alpha`, `delta`, `psi`, `eta`, `theta_p` | Technology, depreciation, fixed cost, substitution elasticities | (F15), (F16), (F18), (F19) |
| Parameters | `xi_H`, `xi_X`, `chi_H`, `chi_X`, `xi_I`, `xi_J`, `chi_I`, `chi_J` | Price and wage Calvo/indexation parameters | (F10), (F14), (F20), (F21) |
| Parameters | `rho_z`, `rho_G`, `rho_TR`, `rho_x`, `phi_R`, `phi_Pi`, `phi_gY`, `phi_BY` | Persistence and policy feedback parameters | (F25), (F35), (F36), (F37), (F38), (F39) |
