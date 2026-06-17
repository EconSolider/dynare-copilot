# US_FMS134 Derivation - Feve, Matheron, and Sahuc (2013)

Source: Patrick Feve, Julien Matheron, and Jean-Guillaume Sahuc (2013), "A Pitfall with Estimated DSGE-Based Government Spending Multipliers," *American Economic Journal: Macroeconomics* 5(4), 141-178. DOI: `10.1257/mac.5.4.141`.

Model ID: `US_FMS134`. Status: `needs_review`.

## 1. Model Overview

- **Model**: Medium-scale New Keynesian DSGE model used for the Smets-Wouters-type robustness exercise in Feve, Matheron, and Sahuc (2013). The core mechanism is Edgeworth complementarity/substitutability between private consumption and government spending, combined with an endogenous countercyclical government-spending rule.
- **Agents and sectors**: households, final goods producers, intermediate goods producers, employment agencies/wage setters, and a government/monetary authority.
- **Frictions**: external habit in consumption services, investment adjustment costs, variable capital utilization, monopolistic competition, Calvo price and wage rigidities with indexation, seven structural shocks, and endogenous government spending.
- **Form**: `model(linear)`. The paper states that the estimated model is log-linearized and cast in state-space form; the MMB implementation cross-check confirms a linear Dynare model. Variables below are stationary log deviations or observation equations unless a steady-state object is explicitly named.
- **Runtime validation**: not performed. Dynare was not run.
- **Provenance boundary**: paper-side Markdown is the source. `.agents/skills/dynare-copilot/references/examples/US_FMS134_rep.mod` is used only as `implementation_cross_check`.

## 2. Optimization Problems

### Household

The quantitative source model extends the simple analytical household by adding capital, investment, preference shocks, and labor habit. In level notation before stationarization, the representative household maximizes:

$$
E_t\sum_{i=0}^{\infty}\beta^i
\left[
e^{\epsilon_{c,t+i}}\log(C_{t+i}+\alpha_g G_{t+i})
-e^{\epsilon_{n,t+i}}\frac{\eta}{1+\nu}
\left(\frac{N_{t+i}}{N_{t+i-1}^{\phi}}\right)^{1+\nu}
\right].
$$

subject to the budget constraint:

$$
C_t+X_t+E_t\{q_{t,t+1}B_{t+1}\}
=W_tN_t+R^k_tK_t-T_t+B_t .
$$

and physical capital accumulation:

$$
K_{t+1}=(1-\delta)K_t+X_t .
$$

For the medium-scale robustness model, the MMB implementation adds habit-adjusted consumption services, investment adjustment costs, and variable utilization. These details are used as `implementation_cross_check` because the paper describes the medium-scale model compactly.

### Firms

The quantitative benchmark production side in the paper has a final good:

$$
Y_t=K_t^{\theta}\left(e^{Z_t}N_t\right)^{1-\theta},
$$

with factor prices under perfect competition:

$$
R^k_t=\theta\frac{Y_t}{K_t}, \qquad
W_t=(1-\theta)\frac{Y_t}{N_t}.
$$

The medium-scale robustness model follows a Christiano-Eichenbaum-Evans / Smets-Wouters structure with final goods producers, intermediate goods producers, Calvo price setting, and wage setting. The precise linear price/wage blocks below are `needs_review` because the local Markdown summarizes the block but does not print all medium-scale FOCs.

### Government and Policy Authorities

Government purchases are financed by lump-sum taxes in the source benchmark:

$$
T_t=G_t.
$$

The stationary government-spending component follows an endogenous feedback rule:

$$
G_t e^{-Z_t}=\bar{G}^s\widetilde{G}_t e^{\epsilon_{g,t}},
$$

$$
\log\widetilde{G}_t=-\varphi_g\left(\Delta\log Y_t-\log\gamma_z\right).
$$

In the MMB medium-scale implementation the same mechanism appears as a linear rule for `g` and `gf`, where government spending responds to output growth relative to trend.

## 3. First-Order Conditions

The following equations use the implementation variable names for the medium-scale MMB entry. The paper supports the model family, log-linear form, fiscal-rule mechanism, shock set, and measurement strategy; equations marked `implementation_cross_check` are taken from the MMB implementation for coverage and must be paper/appendix checked before review promotion.

### Flexible-Price Block

- **(F1) Flexible effective capital** (`implementation_cross_check`):

$$
k^f_t=u^f_t+\bar{k}^f_{t-1}-e^z_t .
$$

- **(F2) Flexible physical capital accumulation** (`implementation_cross_check`):

$$
\bar{k}^f_t=\frac{1-\delta}{e^\gamma}(\bar{k}^f_{t-1}-e^z_t)
\left(1-\frac{1-\delta}{e^\gamma}\right)
\left[x^f_t+\eta_k e^{2\gamma}(1+\beta)e^x_t\right].
$$

- **(F3) Flexible marginal utility of consumption services** (`needs_review`, `implementation_cross_check`):

$$
\lambda^f_t =
a_1 c^{*f}_{t+1}-a_2 c^{*f}_t+a_3 c^{*f}_{t-1}
a_4 e^z_t+a_5 e^b_t .
$$

- **(F4) Flexible consumption Euler equation** (`needs_review`, `implementation_cross_check`):

$$
c^{*f}_t=b_1c^{*f}_{t+1}-b_2c^{*f}_{t+2}
b_3c^{*f}_{t-1}+b_4e^z_t-b_5r^f_t+e^b_t .
$$

- **(F5) Flexible consumption services with Edgeworth term**:

$$
c^{*f}_t=\frac{c_{ss}}{c_{ss}+\alpha_g g_{ss}}c^f_t
\frac{\alpha_g g_{ss}}{c_{ss}+\alpha_g g_{ss}}g^f_t .
$$

- **(F6) Flexible investment equation** (`implementation_cross_check`):

$$
x^f_t=\frac{1}{1+\beta}(x^f_{t-1}-e^z_t)
\frac{1}{\eta_k e^{2\gamma}(1+\beta)}q^f_t
\frac{\beta}{1+\beta}(x^f_{t+1}+e^z_{t+1})+e^x_t .
$$

- **(F7) Flexible Tobin's Q** (`implementation_cross_check`):

$$
q^f_t=\frac{\beta(1-\delta)}{e^\gamma}q^f_{t+1}
\left(1-\frac{\beta(1-\delta)}{e^\gamma}\right)r^{k,f}_{t+1}-r^f_t .
$$

- **(F8) Flexible utilization** (`implementation_cross_check`):

$$
u^f_t=\eta_u r^{k,f}_t .
$$

- **(F9) Flexible production** (`implementation_cross_check`):

$$
y^f_t=(1+f_{ss}/y_{ss})\left[\alpha k^f_t+(1-\alpha)n^f_t\right].
$$

- **(F10) Flexible labor demand** (`implementation_cross_check`):

$$
w^f_t=\alpha k^f_t-\alpha n^f_t .
$$

- **(F11) Flexible capital rental rate** (`implementation_cross_check`):

$$
r^{k,f}_t=(1-\alpha)n^f_t-(1-\alpha)k^f_t .
$$

- **(F12) Flexible wage curve** (`needs_review`, `implementation_cross_check`):

$$
w^f_t=\omega n^f_t+a_5 e^b_t-\lambda^f_t .
$$

- **(F13) Flexible government spending rule**:

$$
g^f_t=-\varphi_g(y^f_t-y^f_{t-1}+e^z_t)+e^g_t .
$$

### Sticky-Price/Sticky-Wage Block

- **(F14) Sticky effective capital** (`implementation_cross_check`):

$$
k_t=u_t+\bar{k}_{t-1}-e^z_t .
$$

- **(F15) Sticky physical capital accumulation** (`implementation_cross_check`):

$$
\bar{k}_t=\frac{1-\delta}{e^\gamma}(\bar{k}_{t-1}-e^z_t)
\left(1-\frac{1-\delta}{e^\gamma}\right)
\left[x_t+\eta_k e^{2\gamma}(1+\beta)e^x_t\right].
$$

- **(F16) Sticky marginal utility of consumption services** (`needs_review`, `implementation_cross_check`):

$$
\lambda_t =
a_1 c^{*}_{t+1}-a_2 c^{*}_t+a_3 c^{*}_{t-1}
a_4 e^z_t+a_5 e^b_t .
$$

- **(F17) Sticky consumption Euler equation** (`needs_review`, `implementation_cross_check`):

$$
c^{*}_t=b_1c^{*}_{t+1}-b_2c^{*}_{t+2}
b_3c^{*}_{t-1}+b_4e^z_t-b_5(r_t-\pi_{t+1})+e^b_t .
$$

- **(F18) Sticky consumption services with Edgeworth term**:

$$
c^*_t=\frac{c_{ss}}{c_{ss}+\alpha_g g_{ss}}c_t
\frac{\alpha_g g_{ss}}{c_{ss}+\alpha_g g_{ss}}g_t .
$$

- **(F19) Sticky investment equation** (`implementation_cross_check`):

$$
x_t=\frac{1}{1+\beta}(x_{t-1}-e^z_t)
\frac{1}{\eta_k e^{2\gamma}(1+\beta)}q_t
\frac{\beta}{1+\beta}(x_{t+1}+e^z_{t+1})+e^x_t .
$$

- **(F20) Sticky Tobin's Q** (`implementation_cross_check`):

$$
q_t=\frac{\beta(1-\delta)}{e^\gamma}q_{t+1}
\left(1-\frac{\beta(1-\delta)}{e^\gamma}\right)r^k_{t+1}
-(r_t-\pi_{t+1}) .
$$

- **(F21) Sticky utilization** (`implementation_cross_check`):

$$
u_t=\eta_u r^k_t .
$$

- **(F22) Sticky production** (`implementation_cross_check`):

$$
y_t=(1+f_{ss}/y_{ss})\left[\alpha k_t+(1-\alpha)n_t\right].
$$

- **(F23) Sticky labor demand** (`implementation_cross_check`):

$$
w_t=mc_t+\alpha k_t-\alpha n_t .
$$

- **(F24) Sticky capital rental rate** (`implementation_cross_check`):

$$
r^k_t=mc_t-(1-\alpha)k_t+(1-\alpha)n_t .
$$

- **(F25) Price Phillips curve** (`needs_review`, `implementation_cross_check`):

$$
\pi_t=\frac{\beta}{1+\gamma_p\beta}\pi_{t+1}
\frac{\gamma_p}{1+\gamma_p\beta}\pi_{t-1}
\kappa mc_t+e^p_t .
$$

- **(F26) Wage Phillips curve** (`needs_review`, `implementation_cross_check`):

$$
w_t=\frac{
\frac{1}{1+\beta}w_{t-1}+\frac{\beta}{1+\beta}w_{t+1}
\kappa_w mrs_t+\frac{\gamma_w}{1+\beta}\pi_{t-1}
-\frac{1+\beta\gamma_w}{1+\beta}\pi_t
\frac{\beta}{1+\beta}\pi_{t+1}
-\frac{1-\rho_z\beta}{1+\beta}e^z_t
}{1+\kappa_w}+e^w_t .
$$

- **(F27) Marginal rate of substitution** (`implementation_cross_check`):

$$
mrs_t=\omega n_t+a_5e^b_t-\lambda_t .
$$

- **(F28) Sticky government spending rule**:

$$
g_t=-\varphi_g(y_t-y_{t-1}+e^z_t)+e^g_t .
$$

- **(F29) Monetary policy rule** (`implementation_cross_check`):

$$
r_t=\rho_s r_{t-1}
(1-\rho_s)\left[\rho_{\pi}\pi_t+\rho_y(y_t-y^f_t)\right]
\rho_{\Delta y}\left[(y_t-y_{t-1})+(y^f_{t-1}-y^f_t)\right]
\zeta^r_t .
$$

## 4. Market Clearing & Identities

- **(F30) Flexible resource constraint** (`implementation_cross_check`):

$$
y^f_t=c_{ss}/y_{ss}\,c^f_t+x_{ss}/y_{ss}\,x^f_t
g_{ss}/y_{ss}\,g^f_t+\bar{r}^k k_{ss}/y_{ss}\,u^f_t .
$$

- **(F31) Sticky resource constraint** (`implementation_cross_check`):

$$
y_t=c_{ss}/y_{ss}\,c_t+x_{ss}/y_{ss}\,x_t
g_{ss}/y_{ss}\,g_t+\bar{r}^k k_{ss}/y_{ss}\,u_t .
$$

- **(F32) Government budget identity**:

$$
T_t=G_t .
$$

- **(F33) Observation equation for output growth**:

$$
dyobs_t=y_t-y_{t-1}+\gamma_z+e^z_t .
$$

- **(F34) Observation equation for consumption growth**:

$$
dcobs_t=c_t-c_{t-1}+\gamma_z+e^z_t .
$$

- **(F35) Observation equation for investment growth**:

$$
dxobs_t=x_t-x_{t-1}+\gamma_z+e^z_t .
$$

- **(F36) Observation equation for government-spending growth**:

$$
dgobs_t=g_t-g_{t-1}+\gamma_z+e^z_t .
$$

- **(F37) Observation equation for wage growth**:

$$
dwobs_t=w_t-w_{t-1}+\gamma_z+e^z_t .
$$

- **(F38) Observation equation for inflation**:

$$
inflobs_t=\pi_t+\bar{\pi}_{obs}.
$$

- **(F39) Observation equation for nominal interest**:

$$
robs_t=r_t+\bar{r}_{obs}.
$$

- **(F40) Observation equation for hours**:

$$
labobs2_t=n_t+\bar{n}_{obs}.
$$

## 5. Exogenous Processes

- **(F41) Technology shock**:

$$
e^z_t=\rho_z e^z_{t-1}+\zeta^z_t .
$$

- **(F42) Preference/risk-premium shock** (`implementation_cross_check`):

$$
e^b_t=\rho_b e^b_{t-1}+\zeta^b_t .
$$

- **(F43) Investment shock** (`implementation_cross_check`):

$$
e^x_t=\rho_x e^x_{t-1}+\zeta^x_t .
$$

- **(F44) Price-markup shock** (`implementation_cross_check`):

$$
e^p_t=\rho_p e^p_{t-1}+\zeta^p_t .
$$

- **(F45) Government-spending shock**:

$$
e^g_t=\rho_g e^g_{t-1}+\zeta^g_t .
$$

- **(F46) Wage-markup shock** (`implementation_cross_check`):

$$
e^w_t=\rho_w e^w_{t-1}+\zeta^w_t .
$$

- **(F47) Monetary-policy shock** (`implementation_cross_check`):

$$
\zeta^r_t \sim iid(0,\sigma_r^2).
$$

## 6. Steady-State Solution

Because `US_FMS134` is implemented as `model(linear)`, all dynamic variables in the model block are zero in deterministic steady state. The implementation computes steady-state ratios and linearization coefficients before the model block:

$$
e^\gamma=\exp(\gamma_z/100), \qquad
\bar{r}^k=\frac{e^\gamma}{\beta}-(1-\delta).
$$

The production-side steady-state ratios are:

$$
\bar{w}=
\left[
\frac{1}{1+\lambda_p}
\frac{\alpha^\alpha(1-\alpha)^{1-\alpha}}{(\bar{r}^k)^\alpha}
\right]^{1/(1-\alpha)},
$$

$$
k/y=\frac{k/l}{y/l}, \qquad
x/y=\frac{\left(1-\frac{1-\delta}{e^\gamma}\right)e^\gamma k/l}{y/l},
\qquad c/y=1-x/y-g/y.
$$

The linear Phillips coefficients are:

$$
\kappa=\frac{(1-\beta\theta_p)(1-\theta_p)}{\theta_p(1+\beta\gamma_p)},
$$

$$
\kappa_w=
\frac{(1-\beta\theta_w)(1-\theta_w)}
{\theta_w(1+\beta)(1+\omega(1+1/\lambda_w))}.
$$

Utility/complementarity steady-state terms enter through `csy`, `gsy`, and `alphag` in (F5) and (F18). Runtime steady-state verification is deferred.

## 7. Timing & Form Conventions

- **Linear form**: all model equations are linear in stationary log deviations or observed growth rates. The MMB implementation declares `model(linear)`.
- **Trend handling**: real variables are stationarized around deterministic technology growth `egamma`; measurement equations add `gammaz` and the technology state `ez`.
- **Capital timing**: `kp` and `kpf` are physical capital stocks carried from the previous period; effective capital uses `kp(-1)` and `kpf(-1)`.
- **Policy timing**: government spending responds contemporaneously to output growth relative to trend, `y_t-y_{t-1}+e^z_t`. The monetary rule responds to inflation, the output gap relative to the flexible block, output-growth changes, and a monetary-policy innovation.
- **Source uncertainty**: the paper prints the benchmark neoclassical model more fully than the medium-scale SW-type robustness block. Price/wage equations and several dynamic FOCs are therefore first-pass `needs_review`.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Equation |
|---|---|---|---|
| Endogenous | `y`, `yf` | sticky/flexible output | (F22), (F30), (F31) |
| Endogenous | `c`, `cf` | sticky/flexible consumption | (F5), (F18), (F30), (F31) |
| Endogenous | `x`, `xf` | sticky/flexible investment | (F6), (F19) |
| Endogenous | `w`, `wf` | sticky/flexible real wage | (F10), (F12), (F23), (F26) |
| Endogenous | `infl` | inflation | (F25), (F38) |
| Endogenous | `r`, `rf` | nominal/policy or flexible real rate in implementation convention | (F4), (F17), (F29) |
| Endogenous | `labor`, `laborf` | sticky/flexible labor | (F9), (F22), (F27) |
| Endogenous | `cstar`, `cstarf` | consumption services including government spending | (F5), (F18) |
| Endogenous | `k`, `kf` | effective capital | (F1), (F14) |
| Endogenous | `u`, `uf` | capital utilization | (F8), (F21) |
| Endogenous | `kp`, `kpf` | physical capital stock | (F2), (F15) |
| Endogenous | `lambda`, `lambdaf` | marginal utility | (F3), (F16) |
| Endogenous | `q`, `qf` | Tobin's Q | (F7), (F20) |
| Endogenous | `rk`, `rkf` | rental rate of capital | (F11), (F24) |
| Endogenous | `mc` | real marginal cost | (F23), (F25) |
| Endogenous | `g`, `gf` | government spending | (F13), (F28), (F30), (F31) |
| Endogenous | `mrs` | marginal rate of substitution | (F27) |
| Endogenous | `dyobs`, `dcobs`, `dxobs`, `dgobs`, `dwobs`, `inflobs`, `robs`, `labobs2` | observables | (F33)-(F40) |
| Exogenous state | `ez`, `eb`, `ex`, `ep`, `eg`, `ew` | structural shock states | (F41)-(F46) |
| Exogenous innovation | `zetaz`, `zetab`, `zetax`, `zetap`, `zetaw`, `zetar`, `zetag` | innovations | (F41)-(F47) |
| Parameter | `beta`, `delta`, `alpha`, `gsy` | discounting, depreciation, capital share, government share | steady state |
| Parameter | `alphag`, `phig` | Edgeworth complementarity and government feedback | (F5), (F13), (F18), (F28) |
| Parameter | `hab`, `etak`, `psiu`, `omega` | habit, investment adjustment, utilization, labor curvature | (F3)-(F8), (F16)-(F21), (F27) |
| Parameter | `thetap`, `thetaw`, `gammap`, `gammaw`, `lambdap`, `lambdaw` | nominal rigidities and markups | (F25), (F26), steady state |
| Parameter | `rhoz`, `rhob`, `rhox`, `rhop`, `rhog`, `rhow`, `rhos`, `rhoinfl`, `rhoy`, `rhody` | persistence and policy responses | (F29), (F41)-(F46) |
| Parameter | `consteinfl`, `conster`, `constelabor`, `gammaz` | measurement constants and trend growth | (F33)-(F40) |
