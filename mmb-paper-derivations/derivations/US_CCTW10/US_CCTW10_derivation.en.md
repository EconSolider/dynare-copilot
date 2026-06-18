# US_CCTW10 - Derivation (optimization problems + first-order conditions)

> This derivation is for the private MMB model archive. It extracts the Cogan, Cwik, Taylor, and Wieland (2010) fiscal-stimulus model entry from the paper-side source. The paper states that the core model is the Smets-Wouters (2007) US model and only restates the rule-of-thumb household and fiscal-policy extension; the remaining Smets-Wouters equations below are therefore marked as implementation_cross_check/needs_review where they come from the MMB `.mod` cross-check rather than from equations printed in the CCTW paper.

## 1. Model Overview

- **Model ID**: `US_CCTW10`.
- **Paper**: John F. Cogan, Tobias Cwik, John B. Taylor, and Volker Wieland (2010), "New Keynesian versus old Keynesian government spending multipliers," Journal of Economic Dynamics and Control 34(3), 281-295, DOI `10.1016/j.jedc.2010.01.010`.
- **Source files**: `raw/mmb_mineru/runs/us_cctw10__new_keynesian_versus_old_keynesian_government_spending_multipliers__da0c2db2/full.md`; raw PDF `raw/mmb_papers/New keynesian versus old keynesian government spending multipliers.pdf`; MMB implementation cross-check `.agents/skills/dynare-copilot/references/examples/US_CCTW10_rep.mod`.
- **Experiment**: ARRA government-purchases path, with a dummy monetary-policy peg for the first four quarters in the MMB file. The fiscal impulse `fiscal_` is imposed directly as the exogenous government-spending path.
- **Agents and blocks**: Ricardian households, rule-of-thumb households, labor unions/sticky wages, intermediate/final goods firms with sticky prices, capital accumulation with utilization and investment adjustment costs, government debt/taxes, and a monetary policy rule.
- **Form**: log-linearized/detrended model in deviations from steady state. The CCTW appendix explicitly log-linearizes the added rule-of-thumb and fiscal equations. The MMB cross-check uses linear equations in Dynare without `model(linear)`, so this entry records the mathematical form as log-linear and the runtime form as needs_review.
- **Status**: first-pass `needs_review`. Runtime validation was not performed.

## 2. Optimization Problems

### 2.1 Ricardian households

A share $1-\omega$ of households, indexed by $j$, has access to financial markets, accumulates physical capital, rents it to firms, receives wage and dividend income, and pays lump-sum taxes. CCTW states that their problem is the Smets-Wouters household problem. In compact archive notation:

$$
\max_{\{C_{j,t},L_{j,t},B_{j,t},K_{j,t},I_{j,t}\}} E_0 \sum_{t=0}^{\infty}\beta^t
U(C_{j,t},C_{j,t-1},L_{j,t})
$$

subject to an intertemporal budget constraint, capital accumulation, and capital-utilization costs. The exact Smets-Wouters utility and constraints are not restated in the CCTW paper; the corresponding log-linear Euler, investment, capital-price, wage, and resource equations below are `implementation_cross_check` and `needs_review` against Smets-Wouters (2007).

### 2.2 Rule-of-thumb households

A share $\omega$ of households, indexed by $i$, does not trade assets and consumes disposable labor income each period:

$$
C_{i,t} = \frac{W_t^h L_t}{P_t} - \frac{T_{i,t}}{P_t}.
$$

### 2.3 Firms and wage setters

Firms and unions follow the Smets-Wouters sticky-price/sticky-wage structure with Kimball aggregators, price indexation, wage indexation, capital utilization, and investment adjustment costs. CCTW does not reproduce the full firm and wage-setting optimization system; the equations in Sections 3 and 4 for these blocks are cross-checked from the MMB implementation and require source-level review against Smets-Wouters (2007).

### 2.4 Government and monetary authority

The government buys the final good $G_t$, issues one-period bonds $B_t$, and raises lump-sum taxes $T_t$. The government budget constraint is:

$$
P_t G_t + B_{t-1} = T_t + \frac{B_t}{R_t}.
$$

Taxes follow a log-linear fiscal rule responding to debt and government spending. The monetary authority follows the MMB policy rule except during periods when `dummy_MP=1`, when the nominal interest-rate observable is pegged.

## 3. First-Order Conditions

The following equations are written in detrended/log-linear notation. Hatted variables denote percentage or log deviations from steady state where the CCTW appendix uses hats. The MMB cross-check uses ASCII variable names without hats.

- **(F1) Flexible-economy marginal-cost relation** (`implementation_cross_check`, needs_review):

$$
a_t = \alpha r^k_{f,t} + (1-\alpha) w_{f,t}.
$$

- **(F2) Flexible-economy capital utilization** (`implementation_cross_check`, needs_review):

$$
z^k_{f,t} = \frac{1-\zeta}{\zeta} r^k_{f,t},
$$

where the MMB file implements the coefficient as $1/(\zeta/(1-\zeta))$.

- **(F3) Flexible-economy rental rate of capital** (`implementation_cross_check`, needs_review):

$$
r^k_{f,t} = w_{f,t} + l_{f,t} - k_{f,t}.
$$

- **(F4) Flexible-economy installed capital used in production** (`implementation_cross_check`, needs_review):

$$
k_{f,t} = k^p_{f,t-1} + z^k_{f,t}.
$$

- **(F5) Flexible-economy investment Euler equation** (`implementation_cross_check`, needs_review):

$$
i_{f,t} =
\frac{1}{1+\bar{\beta}\gamma}
\left(i_{f,t-1}+\bar{\beta}\gamma E_t i_{f,t+1}
+\frac{1}{\gamma^2 S''}\,p^k_{f,t}\right)+q^s_t.
$$

- **(F6) Flexible-economy value of capital** (`implementation_cross_check`, needs_review):

$$
p^k_{f,t} =
-r^r_{f,t}
+\frac{1}{\eta_c} b_t
+\frac{\bar{r}^k}{\bar{r}^k+1-\delta}E_t r^k_{f,t+1}
+\frac{1-\delta}{\bar{r}^k+1-\delta}E_t p^k_{f,t+1},
$$

with $\eta_c=(1-h/\gamma)/[\sigma_c(1+h/\gamma)]$.

- **(F7) Flexible-economy Ricardian consumption Euler equation** (`implementation_cross_check`, needs_review):

$$
c_{j,f,t} =
\frac{h/\gamma}{1+h/\gamma}c_{j,f,t-1}
+\frac{1}{1+h/\gamma}E_t c_{j,f,t+1}
+\frac{(\sigma_c-1)\bar{w}\bar{l}/\bar{c}}{\sigma_c(1+h/\gamma)}
(l_{f,t}-E_t l_{f,t+1})
-\frac{1-h/\gamma}{\sigma_c(1+h/\gamma)}r^r_{f,t}+b_t.
$$

- **(F8) Flexible-economy rule-of-thumb consumption**:

$$
c_{i,f,t} =
\frac{\bar{W}^h\bar{L}}{\bar{C}}(w_{f,t}+l_{f,t})
-\frac{\bar{Y}}{\bar{C}}t_{f,t}.
$$

- **(F9) Flexible-economy aggregate consumption**:

$$
c_{f,t}=(1-\omega)c_{j,f,t}+\omega c_{i,f,t}.
$$

- **(F10) Flexible-economy wage/labor supply condition** (`implementation_cross_check`, needs_review):

$$
w_{f,t} =
\sigma_l l_{f,t}
+\frac{1}{1-h/\gamma}c_{j,f,t}
-\frac{h/\gamma}{1-h/\gamma}c_{j,f,t-1}.
$$

- **(F11) Sticky-economy marginal cost** (`implementation_cross_check`, needs_review):

$$
mc_t = \alpha r^k_t + (1-\alpha)w_t - a_t.
$$

- **(F12) Sticky-economy capital utilization** (`implementation_cross_check`, needs_review):

$$
z^k_t = \frac{1-\zeta}{\zeta}r^k_t.
$$

- **(F13) Sticky-economy rental rate of capital** (`implementation_cross_check`, needs_review):

$$
r^k_t = w_t + l_t - k_t.
$$

- **(F14) Sticky-economy installed capital used in production** (`implementation_cross_check`, needs_review):

$$
k_t = k^p_{t-1}+z^k_t.
$$

- **(F15) Sticky-economy investment Euler equation** (`implementation_cross_check`, needs_review):

$$
i_t =
\frac{1}{1+\bar{\beta}\gamma}
\left(i_{t-1}+\bar{\beta}\gamma E_t i_{t+1}
+\frac{1}{\gamma^2 S''}p^k_t\right)+q^s_t.
$$

- **(F16) Sticky-economy value of capital/arbitrage** (`implementation_cross_check`, needs_review):

$$
p^k_t =
-r_t+E_t\pi_{t+1}
+\frac{1}{\eta_c}b_t
+\frac{\bar{r}^k}{\bar{r}^k+1-\delta}E_t r^k_{t+1}
+\frac{1-\delta}{\bar{r}^k+1-\delta}E_t p^k_{t+1}.
$$

- **(F17) Sticky-economy Ricardian consumption Euler equation** (`implementation_cross_check`, needs_review):

$$
c_{j,t} =
\frac{h/\gamma}{1+h/\gamma}c_{j,t-1}
+\frac{1}{1+h/\gamma}E_t c_{j,t+1}
+\frac{(\sigma_c-1)\bar{w}\bar{l}/\bar{c}}{\sigma_c(1+h/\gamma)}
(l_t-E_t l_{t+1})
-\frac{1-h/\gamma}{\sigma_c(1+h/\gamma)}(r_t-E_t\pi_{t+1})
+b_t.
$$

- **(F18) Sticky-economy rule-of-thumb consumption**:

$$
c_{i,t} =
\frac{\bar{W}^h\bar{L}}{\bar{C}}(w_t+l_t)
-\frac{\bar{Y}}{\bar{C}}t_t.
$$

- **(F19) Sticky-economy aggregate consumption**:

$$
c_t=(1-\omega)c_{j,t}+\omega c_{i,t}.
$$

- **(F20) Price Phillips curve** (`implementation_cross_check`, needs_review):

$$
\pi_t =
\frac{1}{1+\bar{\beta}\gamma\iota_p}
\left[
\bar{\beta}\gamma E_t\pi_{t+1}
+\iota_p\pi_{t-1}
+\kappa_p mc_t
\right]+s^\pi_t.
$$

- **(F21) Wage Phillips curve** (`implementation_cross_check`, needs_review):

$$
w_t =
\frac{1}{1+\bar{\beta}\gamma}w_{t-1}
+\frac{\bar{\beta}\gamma}{1+\bar{\beta}\gamma}E_t w_{t+1}
+\frac{\iota_w}{1+\bar{\beta}\gamma}\pi_{t-1}
-\frac{1+\bar{\beta}\gamma\iota_w}{1+\bar{\beta}\gamma}\pi_t
+\frac{\bar{\beta}\gamma}{1+\bar{\beta}\gamma}E_t\pi_{t+1}
+\kappa_w\left(\sigma_l l_t+\frac{c_{j,t}}{1-h/\gamma}
-\frac{h/\gamma}{1-h/\gamma}c_{j,t-1}-w_t\right)+s^w_t.
$$

## 4. Market Clearing & Identities

- **(F22) Flexible-economy resource constraint** (`implementation_cross_check`, needs_review):

$$
y_{f,t} = c_y c_{f,t}+i_y i_{f,t}+g_t+\bar{r}^k k_y z^k_{f,t}.
$$

- **(F23) Flexible-economy production function** (`implementation_cross_check`, needs_review):

$$
y_{f,t} = \Phi\left(\alpha k_{f,t}+(1-\alpha)l_{f,t}+a_t\right).
$$

- **(F24) Flexible-economy installed-capital accumulation** (`implementation_cross_check`, needs_review):

$$
k^p_{f,t}=(1-\bar{i}/\bar{k})k^p_{f,t-1}
+(\bar{i}/\bar{k})i_{f,t}
+(\bar{i}/\bar{k})\gamma^2 S''q^s_t.
$$

- **(F25) Flexible-economy government budget constraint**:

$$
b_{f,t}=R_\ast\left(\frac{b_{f,t-1}}{\pi_\ast}+g_t-t_{f,t}\right).
$$

- **(F26) Flexible-economy fiscal rule**:

$$
t_{f,t}=\phi_b b_{f,t-1}+\phi_g g_t.
$$

- **(F27) Sticky-economy aggregate resource constraint** (`implementation_cross_check`, needs_review):

$$
y_t = c_y c_t+i_y i_t+g_t+\bar{r}^k k_y z^k_t.
$$

- **(F28) Sticky-economy production function** (`implementation_cross_check`, needs_review):

$$
y_t = \Phi\left(\alpha k_t+(1-\alpha)l_t+a_t\right).
$$

- **(F29) Sticky-economy installed-capital accumulation** (`implementation_cross_check`, needs_review):

$$
k^p_t=(1-\bar{i}/\bar{k})k^p_{t-1}
+(\bar{i}/\bar{k})i_t
+(\bar{i}/\bar{k})\gamma^2 S''q^s_t.
$$

- **(F30) Sticky-economy government budget constraint**:

$$
b_t=R_\ast\left(\frac{b_{t-1}}{\pi_\ast}+g_t-t_t\right).
$$

- **(F31) Sticky-economy fiscal rule**:

$$
t_t=\phi_b b_{t-1}+\phi_g g_t.
$$

- **(F32) Monetary policy rule with peg dummy**:

$$
i_t^{obs} =
d^{MP}_t\cdot 0+(1-d^{MP}_t)
\left(\rho_i i_{t-1}^{obs}+\phi_{\pi,0}\pi^{(4)}_t+\phi_y(y_t-y_{f,t})+\phi_{y,-1}(y_{t-1}-y_{f,t-1})\right).
$$

- **(F33) Modelbase output gap identity**:

$$
gap_t=y_t-y_{f,t}.
$$

- **(F34) Inflation and interest observables** (`implementation_cross_check`, needs_review):

$$
\pi^{obs}_t=\pi_t+\bar{\pi},\quad
\pi^{(4)}_t=\pi_t+\pi_{t-1}+\pi_{t-2}+\pi_{t-3},\quad
r^{obs}_t=r_t+\bar{r}.
$$

- **(F35) Growth observables** (`implementation_cross_check`, needs_review):

$$
\Delta y_t=y_t-y_{t-1}+\bar{\gamma},\quad
\Delta c_t=c_t-c_{t-1}+\bar{\gamma},\quad
\Delta i_t=i_t-i_{t-1}+\bar{\gamma},\quad
\Delta w_t=w_t-w_{t-1}+\bar{\gamma}.
$$

## 5. Exogenous Processes

- **(F36) Technology shock** (`implementation_cross_check`, needs_review):

$$
a_t=\rho_a a_{t-1}+\varepsilon^a_t.
$$

- **(F37) Preference/risk-premium shock** (`implementation_cross_check`, needs_review):

$$
b_t^{pref}=\rho_b b_{t-1}^{pref}+\varepsilon^b_t.
$$

- **(F38) Government purchases path**:

$$
g_t=fiscal_t.
$$

- **(F39) Investment-specific shock** (`implementation_cross_check`, needs_review):

$$
q^s_t=\rho_{qs}q^s_{t-1}+\varepsilon^{qs}_t.
$$

- **(F40) Monetary-policy shock process** (`implementation_cross_check`, needs_review):

$$
m_t=\rho_m m_{t-1}+\varepsilon^m_t.
$$

- **(F41) Price markup shock** (`implementation_cross_check`, needs_review):

$$
s^\pi_t=\rho_\pi s^\pi_{t-1}+\varepsilon^\pi_t-\mu_\pi\varepsilon^\pi_{t-1}.
$$

- **(F42) Wage markup shock** (`implementation_cross_check`, needs_review):

$$
s^w_t=\rho_w s^w_{t-1}+\varepsilon^w_t-\mu_w\varepsilon^w_{t-1}.
$$

- **(F43) Policy peg dummy path**:

$$
d^{MP}_t =
\begin{cases}
1, & t=1,\ldots,4,\\
0, & \text{otherwise.}
\end{cases}
$$

## 6. Steady-State Solution

Because the archived model is log-linear/detrended, steady-state deviations are zero for the endogenous model variables:

$$
\bar{a}=\bar{b}^{pref}=\bar{g}=\bar{q}^s=\bar{m}=\bar{s}^{\pi}=\bar{s}^{w}=0,
\quad
\bar{c}_{i}=\bar{c}_{j}=\bar{c},\quad
\bar{b}^{gov}=0.
$$

The paper states the simplifying equal-consumption and zero-debt steady-state assumptions for the rule-of-thumb extension:

$$
C_i=C_j=C,\qquad B=0.
$$

The MMB implementation computes the nonzero steady-state ratios and constants before the model block. The source-backed calculation order is:

1. Set quarterly steady inflation and trend growth:

$$
\pi_\ast = 1+\frac{\bar{\pi}^{obs}}{100},\qquad
\gamma = 1+\frac{\bar{\gamma}^{obs}}{100}.
$$

2. Set discounting and the trend-adjusted discount factor:

$$
\beta=\frac{1}{1+\bar{\beta}^{obs}/100},\qquad
\bar{\beta}=\beta\gamma^{-\sigma_c}.
$$

3. Compute steady nominal and rental returns:

$$
R_\ast=\frac{\pi_\ast}{\beta\gamma^{-\sigma_c}},\qquad
\bar{r}^k=\beta^{-1}\gamma^{\sigma_c}-(1-\delta).
$$

4. Compute wage, capital-output, investment-output, and consumption-output ratios:

$$
\bar{w} =
\left[
\frac{\alpha^\alpha(1-\alpha)^{1-\alpha}}{\lambda_p(\bar{r}^k)^\alpha}
\right]^{1/(1-\alpha)},\quad
\frac{\bar{k}}{\bar{y}}=\lambda_p\left(\frac{(1-\alpha)\bar{r}^k}{\alpha\bar{w}}\right)^{\alpha-1},
$$

$$
\frac{\bar{i}}{\bar{y}}=
\left(1-\frac{1-\delta}{\gamma}\right)\frac{\bar{k}}{\bar{y}},\qquad
\frac{\bar{c}}{\bar{y}}=1-\frac{\bar{g}}{\bar{y}}-\frac{\bar{i}}{\bar{y}}.
$$

5. Set the CCTW extension parameters from the paper estimates: $\omega=0.2651$, $\phi_b=0.0531$, and $\phi_g=0.1242$ in the MMB implementation. These values correspond to the posterior mean row in Table A1.

All other variables in the linear model are deviations around these steady objects. Runtime steady-state validation was not performed.

## 7. Timing & Form Conventions

- The archive equations are in log-linear/deviation form. Variables such as $c_t$, $y_t$, $i_t$, $w_t$, $\pi_t$, and $r_t$ are deviations from trend/steady state, not nonlinear levels.
- Installed capital $k^p_t$ is a predetermined stock. Production uses installed capital carried from the previous period plus current utilization: $k_t=k^p_{t-1}+z^k_t$.
- Flexible-economy variables carry an `f` suffix in the MMB file and define natural output/interest/labor objects used in gaps.
- There are two household consumption concepts: Ricardian/non-liquidity-constrained $c_{j,t}$ (`c_nlc`) and rule-of-thumb/liquidity-constrained $c_{i,t}$ (`c_lc`).
- Government debt and taxes are expressed as percentages of steady-state output in the CCTW appendix.
- The policy dummy `dummy_MP` pegs the modelbase interest observable during periods 1:4 in the MMB scenario. The CCTW paper discusses finite federal-funds-rate accommodation in 2009 and/or through 2010; the exact MMB dummy path belongs to the implementation scenario, not the paper's general derivation.
- The CCTW paper source is incomplete for the full Smets-Wouters block because it refers readers to Smets and Wouters (2007). Equations marked `implementation_cross_check` require source-level checking before promotion.

## 8. Variable & Parameter Reference Table

### Endogenous variables

| ASCII name | Symbol | Description | Main equation |
|---|---|---|---|
| `labobs` | $l^{obs}_t$ | observed labor | measurement block |
| `robs` | $r^{obs}_t$ | observed annualized nominal/interest variable | (F34) |
| `pinfobs` | $\pi^{obs}_t$ | observed quarterly inflation | (F34) |
| `dy` | $\Delta y_t$ | output growth observable | (F35) |
| `dc` | $\Delta c_t$ | consumption growth observable | (F35) |
| `dinve` | $\Delta i_t$ | investment growth observable | (F35) |
| `dw` | $\Delta w_t$ | wage growth observable | (F35) |
| `ewma`, `epinfma` | $\varepsilon^w_t,\varepsilon^\pi_t$ lags | MA shock auxiliaries | (F41), (F42) |
| `zcapf`, `zcap` | $z^k_{f,t},z^k_t$ | capital utilization | (F2), (F12) |
| `rkf`, `rk` | $r^k_{f,t},r^k_t$ | rental rate of capital | (F3), (F13) |
| `kf`, `k` | $k_{f,t},k_t$ | utilized capital in production | (F4), (F14) |
| `pkf`, `pk` | $p^k_{f,t},p^k_t$ | value of installed capital | (F6), (F16) |
| `cf`, `c` | $c_{f,t},c_t$ | aggregate consumption | (F9), (F19) |
| `invef`, `inve` | $i_{f,t},i_t$ | investment | (F5), (F15) |
| `yf`, `y` | $y_{f,t},y_t$ | flexible and sticky output | (F22)-(F23), (F27)-(F28) |
| `labf`, `lab` | $l_{f,t},l_t$ | labor | (F10), (F21) |
| `wf`, `w` | $w_{f,t},w_t$ | real wage | (F10), (F21) |
| `rrf` | $r^r_{f,t}$ | flexible real return | (F6) |
| `mc`, `mcf` | $mc_t,mc_{f,t}$ | marginal cost | (F11) |
| `r` | $r_t$ | policy interest-rate deviation | (F16), (F34) |
| `a` | $a_t$ | technology | (F36) |
| `b` | $b^{pref}_t$ | preference/risk-premium shock state | (F37) |
| `g` | $g_t$ | government purchases | (F38) |
| `qs` | $q^s_t$ | investment-specific shock | (F39) |
| `ms` | $m_t$ | monetary-policy shock state | (F40) |
| `spinf`, `sw` | $s^\pi_t,s^w_t$ | price and wage markup shock states | (F41), (F42) |
| `kpf`, `kp` | $k^p_{f,t},k^p_t$ | installed capital stock | (F24), (F29) |
| `pinf4`, `pinfobs4`, `robs4` | $\pi^{(4)}_t,\pi^{obs,4}_t,r^{obs,4}_t$ | annualized observables | (F34) |
| `c_lc`, `c_lcf` | $c_{i,t},c_{i,f,t}$ | rule-of-thumb consumption | (F8), (F18) |
| `c_nlc`, `c_nlcf` | $c_{j,t},c_{j,f,t}$ | Ricardian consumption | (F7), (F17) |
| `debt`, `debtf` | $b_t,b_{f,t}$ | government debt | (F25), (F30) |
| `t`, `tf` | $t_t,t_{f,t}$ | taxes | (F26), (F31) |
| `interest`, `inflation`, `inflationq`, `outputgap`, `output` | modelbase reporting variables | MMB reporting variables | (F32)-(F35) |
| `pinflag1`, `pinflag2`, `dlab`, `realinterest`, `gry` | lag/reporting auxiliaries | measurement auxiliaries | (F34)-(F35) |

### Exogenous shocks

| ASCII name | Symbol | Description |
|---|---|---|
| `ea` | $\varepsilon^a_t$ | technology innovation |
| `eb` | $\varepsilon^b_t$ | preference/risk-premium innovation |
| `eqs` | $\varepsilon^{qs}_t$ | investment-specific innovation |
| `em` | $\varepsilon^m_t$ | monetary-policy innovation |
| `epinf` | $\varepsilon^\pi_t$ | price markup innovation |
| `ew` | $\varepsilon^w_t$ | wage markup innovation |
| `fiscal_` | $fiscal_t$ | deterministic fiscal purchases path |
| `dummy_MP` | $d^{MP}_t$ | deterministic monetary-policy peg dummy |

### Parameters

| ASCII name | Symbol | Description |
|---|---|---|
| `omega` | $\omega$ | share of rule-of-thumb households |
| `phi_b` | $\phi_b$ | tax response to government debt |
| `phi_g` | $\phi_g$ | tax response to government spending |
| `csigma` | $\sigma_c$ | inverse intertemporal elasticity |
| `chabb` | $h$ | habit persistence |
| `cprobp`, `cprobw` | $\xi_p,\xi_w$ | Calvo price and wage stickiness |
| `cindp`, `cindw` | $\iota_p,\iota_w$ | price and wage indexation |
| `calfa` | $\alpha$ | capital share parameter in the MMB code |
| `ctou` | $\delta$ | depreciation rate |
| `czcap` | $\zeta$ | capital-utilization curvature parameter |
| `csadjcost` | $S''$ | investment adjustment cost |
| `crpi`, `crr`, `cry`, `crdy` | policy-rule coefficients | inflation, smoothing, and output-gap responses |
| `crhoa`, `crhob`, `crhoqs`, `crhoms`, `crhopinf`, `crhow` | shock persistence/MA parameters | exogenous process parameters |
| `cg`, `cgy`, `ccy`, `ciy`, `cky`, `crkky`, `cwhlc` | steady-state ratios | resource and household-income weights |
| `constepinf`, `constebeta`, `constelab`, `ctrend` | steady observed constants | inflation, discounting, labor, and growth constants |

The endogenous equation count is not asserted as validated because the MMB file includes reporting identities and scenario dummies in addition to core equilibrium equations. Equation coverage is `needs_review`.
