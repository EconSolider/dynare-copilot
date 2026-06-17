# US_ACELswm -- Derivation (optimization problems + first-order conditions)

> Archive status: `needs_review`. This first-pass derivation is based on the MinerU Markdown for Altig, Christiano, Eichenbaum, and Linde (2005), with `.agents/skills/dynare-copilot/references/examples/US_ACELswm_rep.mod` used only as `implementation_cross_check`. Runtime validation was not performed.

> Equation labels run continuously from (F1) through (F53); formulas use matching LaTeX `\tag{F#}` labels.

## 1. Model Overview

- **Model**: `US_ACELswm`, Altig, Christiano, Eichenbaum, and Linde, "Firm-Specific Capital, Nominal Rigidities and the Business Cycle" (2005 working paper; DOI `10.3386/w11034`).
- **Archive source**: `raw/mmb_mineru/runs/us_acelm_us_acelswm_us_acelswt_us_acelt__firm_specific_capital_nominal_rigidities__e0fac58f/full.md`; raw PDF `raw/mmb_papers/Firm-specific capital, nominal rigidities.pdf`.
- **Economy**: estimated U.S. medium-scale New Keynesian model with habit formation, money/transactions services, sticky wages, sticky prices, variable capital utilization, investment adjustment costs, neutral technology shocks, capital-embodied technology shocks, and monetary shocks.
- **Model variant**: `US_ACELswm` is the sticky-wage monetary-shock MMB implementation. The implementation cross-check notes a version without the cost channel (`\nu` approximately zero) and a parallel flexible-price allocation block.
- **Form**: `model(linear)`. Variables in the MMB implementation are log deviations or scaled linear deviations around a balanced-growth steady state. The paper provides nonlinear primitives and a reduced inflation equation; the technical-appendix linear system is not fully present in the OCR and is therefore marked `needs_review` where reconstructed from cross-check evidence.
- **Core timing**: technology shocks are observed first; households and firms make real decisions; wage setting occurs before the monetary policy shock; the monetary shock and product demand are then realized. Capital is predetermined within the period, and in the firm-specific-capital interpretation each intermediate firm begins the period with its own physical capital stock.

## 2. Optimization Problems

### 2.1 Final-good firm

The competitive final-good producer aggregates intermediate goods:

$$
Y_t=\left[\int_0^1 y_t(i)^{1/\lambda_f}\,di\right]^{\lambda_f},
\qquad 1\leq \lambda_f<\infty .
\tag{F1}
$$

Profit maximization implies the demand curve for intermediate good $i$:

$$
\frac{y_t(i)}{Y_t}=\left(\frac{P_t}{P_t(i)}\right)^{\lambda_f/(\lambda_f-1)} .
\tag{F2}
$$

The associated aggregate price index is:

$$
P_t=\left[\int_0^1 P_t(i)^{1/(1-\lambda_f)}\,di\right]^{1-\lambda_f}.
\tag{F3}
$$

### 2.2 Intermediate-good firms

Intermediate firm $i$ produces with neutral technology, embodied technology scaling, and fixed costs:

$$
y_t(i)=K_t(i)^\alpha\left(z_t h_t(i)\right)^{1-\alpha}-\phi z_t^\*,
\qquad
z_t^\*=\Upsilon_t^{\alpha/(1-\alpha)}z_t .
\tag{F4}
$$

For the homogeneous-capital benchmark the firm rents capital and labor and maximizes expected discounted nominal profits subject to demand and Calvo pricing. For the firm-specific-capital model, firm $i$ owns its capital and chooses price, labor, investment, and utilization:

$$
E_t\sum_{j=0}^{\infty}\beta^j v_{t+j}
\left\{
P_{t+j}(i)y_{t+j}(i)
-P_{t+j}R_{t+j}w_{t+j}h_{t+j}(i)
-P_{t+j}\Upsilon_{t+j}^{-1}\left[I_{t+j}(i)+a(u_{t+j}(i))\bar K_{t+j}(i)\right]
\right\}.
\tag{F5}
$$

Firm-specific capital evolves as:

$$
\bar K_{t+1}(i)=(1-\delta)\bar K_t(i)+
\left[1-S\left(\frac{I_t(i)}{I_{t-1}(i)}\right)\right]I_t(i).
\tag{F6}
$$

Calvo price setting: with probability $1-\xi_p$ the firm reoptimizes its price; otherwise:

$$
P_t(i)=\pi_{t-1}P_{t-1}(i).
\tag{F7}
$$

### 2.3 Households

Household $j$ maximizes habit preferences:

$$
E_t^j\sum_{\ell=0}^{\infty}\beta^{\ell-t}
\left[
\log(C_{t+\ell}-bC_{t+\ell-1})
-\psi_L\frac{h_{j,t+\ell}^2}{2}
\right].
\tag{F8}
$$

The nominal asset accumulation equation is:

$$
\begin{aligned}
M_{t+1}={}&R_t\left[M_t-Q_t+(x_t-1)M_t^a\right]+A_{j,t}+Q_t+W_{j,t}h_{j,t}\\
&+P_t r_t^k u_t\bar K_t+D_t
-(1+\eta(V_t))P_tC_t
-P_t\Upsilon_t^{-1}\left[I_t+a(u_t)\bar K_t\right].
\end{aligned}
\tag{F9}
$$

Transactions velocity and money-service costs are:

$$
V_t=\frac{P_tC_t}{Q_t},\qquad \eta'(V_t)>0,\qquad \eta''(V_t)>0.
\tag{F10}
$$

Capital services, utilization, and investment adjustment are:

$$
K_t=u_t\bar K_t,\qquad
\bar K_{t+1}=(1-\delta)\bar K_t+\left[1-S\left(\frac{I_t}{I_{t-1}}\right)\right]I_t .
\tag{F11}
$$

### 2.4 Wage setters

Differentiated labor services are aggregated as:

$$
H_t=\left[\int_0^1 h_{j,t}^{1/\lambda_w}\,dj\right]^{\lambda_w}.
\tag{F12}
$$

Labor demand and the wage index are:

$$
h_{j,t}=\left(\frac{W_t}{W_{j,t}}\right)^{\lambda_w/(\lambda_w-1)}H_t,
\qquad
W_t=\left[\int_0^1 W_{j,t}^{1/(1-\lambda_w)}\,dj\right]^{1-\lambda_w}.
\tag{F13}
$$

With probability $1-\xi_w$ the household reoptimizes its wage; otherwise:

$$
W_{j,t}=\pi_{t-1}\mu_{z^\*}W_{j,t-1}.
\tag{F14}
$$

## 3. First-Order Conditions

### 3.1 Price and marginal-cost block

The paper states that the homogeneous- and firm-specific-capital aggregate systems differ only in the mapping from structural parameters to the slope of the inflation equation. The reduced inflation equation is:

$$
\Delta\hat\pi_t
=E_t\left[\beta\Delta\hat\pi_{t+1}+\gamma\hat s_t\mid\Omega_t\right].
\tag{F15}
$$

For homogeneous capital:

$$
\gamma=\frac{(1-\xi_p)(1-\beta\xi_p)}{\xi_p}\chi,
\qquad \chi=1.
\tag{F16}
$$

For firm-specific capital, $\chi$ is a nonlinear function of structural parameters; the exact function is referred to the technical appendix and is `needs_review` in this archive entry.

### 3.2 Linear equilibrium conditions from technical-appendix cross-check

The MMB implementation labels the sticky-price block equations as technical-appendix equations (1)-(16). Because the OCR source does not include the full technical appendix, equations `(F17)` through `(F32)` are recorded as implementation-cross-checked formulas and should receive paper/PDF verification before promotion.

**(F17) Capital Euler equation (`needs_review`, implementation_cross_check):**

$$
\hat\lambda_{z^\*,t+1}
\frac{1-\delta}{\tilde\rho+1-\delta}\hat{\tilde\mu}_{t+1}
\frac{\tilde\rho}{\tilde\rho+1-\delta}\hat{\tilde\rho}_{t+1}
-\hat\lambda_{z^\*,t}-\hat{\tilde\mu}_t
=\hat\mu_{z,t+1}+\frac{1}{1-\alpha}\hat\mu_{\Upsilon,t+1}.
\tag{F17}
$$

**(F18) Investment Euler equation (`needs_review`, implementation_cross_check):**

$$
\begin{aligned}
&-\beta\kappa(\mu_{z^\*}\mu_\Upsilon)^2\hat i_{t+1}
-\hat{\tilde\mu}_{t-1|t}
+\kappa(\mu_{z^\*}\mu_\Upsilon)^2(1+\beta)\hat i_t
-\kappa(\mu_{z^\*}\mu_\Upsilon)^2\hat i_{t-1}\\
&=\beta\kappa(\mu_{z^\*}\mu_\Upsilon)^2\hat\mu_{z,t+1}
+\frac{\beta\kappa(\mu_{z^\*}\mu_\Upsilon)^2}{1-\alpha}\hat\mu_{\Upsilon,t+1}
-\kappa(\mu_{z^\*}\mu_\Upsilon)^2\hat\mu_{z,t}
-\frac{\kappa(\mu_{z^\*}\mu_\Upsilon)^2}{1-\alpha}\hat\mu_{\Upsilon,t}.
\end{aligned}
\tag{F18}
$$

**(F19) Shadow rental rate on capital (`needs_review`, implementation_cross_check):**

$$
\begin{aligned}
\hat{\tilde w}_{t-1|t}
+\frac{1}{1-\alpha}\frac{\tilde y}{\tilde y+\phi}\hat{\tilde y}_t
+\frac{\nu R}{\nu R+1-\nu}\hat R_t
-\hat{\tilde\rho}_t
-\frac{1}{1-\alpha}\hat u_{t-1|t}
-\frac{1}{1-\alpha}\hat{\bar k}_{t}
=-\frac{1}{1-\alpha}\hat\mu_{z,t}
-\frac{1}{(1-\alpha)^2}\hat\mu_{\Upsilon,t}
+\frac{1}{1-\alpha}\epsilon_t .
\end{aligned}
\tag{F19}
$$

**(F20) Capital evolution (`needs_review`, implementation_cross_check):**

$$
(\mu_{z^\*}\mu_\Upsilon-(1-\delta))\hat i_{t-1|t}
-\mu_\Upsilon\mu_{z^\*}\hat{\bar k}_{t+1}
+(1-\delta)\hat{\bar k}_{t}
=(1-\delta)\hat\mu_{z,t}
+\frac{1-\delta}{1-\alpha}\hat\mu_{\Upsilon,t}.
\tag{F20}
$$

**(F21) Sticky-price inflation equation (`needs_review`, implementation_cross_check):**

$$
\beta\hat\pi_{t+1}-(1+\beta\varsigma)\hat\pi_t+\gamma\hat s_t
=-\varsigma\hat\pi_{t-1}.
\tag{F21}
$$

**(F22) Marginal-cost equation (`needs_review`, implementation_cross_check):**

$$
\begin{aligned}
\hat{\tilde w}_{t-1|t}-\hat s_t
+\frac{\alpha}{1-\alpha}\frac{\tilde y}{\tilde y+\phi}\hat{\tilde y}_t
+\frac{\nu R}{\nu R+1-\nu}\hat R_t
-\frac{\alpha}{1-\alpha}\hat u_{t-1|t}
-\frac{\alpha}{1-\alpha}\hat{\bar k}_t\\
=-\frac{\alpha}{1-\alpha}\hat\mu_{z,t}
-\frac{\alpha}{(1-\alpha)^2}\hat\mu_{\Upsilon,t}
+\frac{1}{1-\alpha}\epsilon_t .
\end{aligned}
\tag{F22}
$$

**(F23) Money demand (`needs_review`, implementation_cross_check):**

$$
\hat c_{t-1|t}-\hat q_t=\frac{R}{(R-1)(2+\varphi_\eta)}\hat R_t .
\tag{F23}
$$

**(F24) Consumption Euler equation (`needs_review`, implementation_cross_check):**

$$
\mathcal A_c E_t\hat c_{t+1}+\mathcal B_c\hat c_t+\mathcal C_c\hat\lambda_{z^\*,t}
\mathcal D_c\hat q_t+\mathcal E_c\hat c_{t-1}
=\mathcal F_cE_t\hat\mu_{z,t+1}+\mathcal G_cE_t\hat\mu_{\Upsilon,t+1}
\mathcal H_c\hat\mu_{z,t}+\mathcal J_c\hat\mu_{\Upsilon,t}.
\tag{F24}
$$

The coefficients $\mathcal A_c,\ldots,\mathcal J_c$ are functions of $(\beta,b,\mu_{z^\*},c,\lambda_{z^\*},\eta,\eta',V,\alpha)$ as in the implementation cross-check; this compact form is marked `needs_review`.

**(F25) Monetary-base first-order condition (`needs_review`, implementation_cross_check):**

$$
\hat\lambda_{z^\*,t+1}-\hat\pi_{t+1}+\hat R_{t+1}-\hat\lambda_{z^\*,t}
=\hat\mu_{z,t+1}+\frac{\alpha}{1-\alpha}\hat\mu_{\Upsilon,t+1}.
\tag{F25}
$$

**(F26) Wage first-order condition (`needs_review`, implementation_cross_check):**

$$
\begin{aligned}
\eta_2\hat{\tilde w}_{t+1}+\eta_4\hat\pi_{t+1}
+\eta_1\hat{\tilde w}_{t}+\eta_3\hat\pi_t
+\eta_5\hat h_t+\eta_6\hat\lambda_{z^\*,t}
+\eta_0\hat{\tilde w}_{t-1}+\bar\eta_3\hat\pi_{t-1}\\
=-\eta_8\frac{\alpha}{1-\alpha}\hat\mu_{\Upsilon,t+1}
-\eta_8\hat\mu_{z,t+1}
-\eta_7\frac{\alpha}{1-\alpha}\hat\mu_{\Upsilon,t}
-\eta_7\hat\mu_{z,t}.
\end{aligned}
\tag{F26}
$$

### 3.3 Utilization and household steady-state FOCs

The paper-side steady-state nominal return and money FOC are:

$$
R=\frac{\pi\mu_{z^\*}}{\beta}.
\tag{F27}
$$

$$
R_t=1+\eta'\left(\frac{P_tC_t}{Q_t}\right)
\left(\frac{P_tC_t}{Q_t}\right)^2.
\tag{F28}
$$

The interest semi-elasticity of money demand is:

$$
\epsilon=\frac{1}{4}\left(\frac{1}{R-1}\right)\left(\frac{1}{2+\varphi_\eta}\right),
\qquad
\varphi_\eta=\frac{\eta''V}{\eta'} .
\tag{F29}
$$

Linearized utilization satisfies:

$$
E_t\left[\frac{1}{\sigma_a}\hat r_t^k-\hat u_t\mid\Omega_t\right]=0.
\tag{F30}
$$

The investment-adjustment-cost FOC can be summarized as:

$$
\hat i_t=\hat i_{t-1}
+\frac{1}{S''}\sum_{j=0}^{\infty}\beta^j
E_t\hat P_{k',t+j}.
\tag{F31}
$$

## 4. Market Clearing & Identities

Loan market clearing requires financial intermediaries to lend the funds used by firms to pay the wage bill:

$$
W_tH_t=x_tM_t-Q_t.
\tag{F32}
$$

The aggregate resource constraint is:

$$
(1+\eta(V_t))C_t+\Upsilon_t^{-1}\left[I_t+a(u_t)\bar K_t\right]\leq Y_t .
\tag{F33}
$$

The linear resource constraint used in the implementation cross-check is:

$$
\begin{aligned}
&\left((1+\eta)c+\eta'c^2/q\right)\hat c_{t-1|t}
+\left(1-\frac{1-\delta}{\mu_\Upsilon\mu_{z^\*}}\right)\bar k\,\hat i_{t-1|t}
-(\tilde y+\phi)(1-\alpha)\hat h_t
-\eta'c^2/q\,\hat q_t\\
&+\left(\frac{\tilde\rho\bar k}{\mu_{z^\*}\mu_\Upsilon}-(\tilde y+\phi)\alpha\right)\hat u_{t-1|t}
-(\tilde y+\phi)\alpha\hat{\bar k}_t
+(\tilde y+\phi)\alpha\hat\mu_{z,t}
+\frac{(\tilde y+\phi)\alpha}{1-\alpha}\hat\mu_{\Upsilon,t}
-(\tilde y+\phi)\epsilon_t=0 .
\end{aligned}
\tag{F34}
$$

Money-base accumulation links money growth, money balances, and inflation:

$$
-\hat m_t-\hat\pi_{t-1}+\hat m_{t-1}+\hat x_{t-1}
=\hat\mu_{z,t}+\frac{\alpha}{1-\alpha}\hat\mu_{\Upsilon,t}.
\tag{F35}
$$

The linearized production function is:

$$
\begin{aligned}
(\tilde y+\phi)(1-\alpha)\hat h_t-\tilde y\hat{\tilde y}_t
+\left((\tilde y+\phi)\alpha-\frac{\tilde\rho\bar k}{\mu_{z^\*}\mu_\Upsilon}\right)\hat u_{t-1|t}
+(\tilde y+\phi)\alpha\hat{\bar k}_t\\
=(\tilde y+\phi)\alpha\hat\mu_{z,t}
+\frac{(\tilde y+\phi)\alpha}{1-\alpha}\hat\mu_{\Upsilon,t}
-(\tilde y+\phi)\epsilon_t .
\end{aligned}
\tag{F36}
$$

Capital utilization in the implementation cross-check is:

$$
\hat u_t=\frac{1}{\sigma_a}\hat{\tilde\rho}_t .
\tag{F37}
$$

## 5. Exogenous Processes

Neutral technology growth:

$$
\hat\mu_{z,t}=\rho_{\mu_z}\hat\mu_{z,t-1}+\varepsilon_{\mu_z,t}.
\tag{F38}
$$

Capital-embodied technology growth:

$$
\hat\mu_{\Upsilon,t}=\rho_{\mu_\Upsilon}\hat\mu_{\Upsilon,t-1}+\varepsilon_{\mu_\Upsilon,t}.
\tag{F39}
$$

Monetary growth decomposes into a monetary-policy component and technology-response components:

$$
\hat x_t=\hat x_{M,t}+\hat x_{z,t}+\hat x_{\Upsilon,t}.
\tag{F40}
$$

The monetary-policy component is:

$$
\hat x_{M,t}=\rho_{xM}\hat x_{M,t-1}+\varepsilon_{M,t}.
\tag{F41}
$$

The policy response to neutral technology is ARMA(1,1):

$$
\hat x_{z,t}=\rho_{xz}\hat x_{z,t-1}+c_z\varepsilon_{\mu_z,t}
+c_z^p\varepsilon_{\mu_z,t-1}.
\tag{F42}
$$

The policy response to embodied technology is ARMA(1,1):

$$
\hat x_{\Upsilon,t}=\rho_{x\Upsilon}\hat x_{\Upsilon,t-1}
+c_\Upsilon\varepsilon_{\mu_\Upsilon,t}
+c_\Upsilon^p\varepsilon_{\mu_\Upsilon,t-1}.
\tag{F43}
$$

The MMB implementation also includes an additional transitory neutral technology shock not in the original code:

$$
\epsilon_t=\rho_\epsilon\epsilon_{t-1}+\sigma_\epsilon\varepsilon_{\epsilon,t}.
\tag{F44}
$$

## 6. Steady-State Solution

Because `US_ACELswm` is implemented as `model(linear)`, the dynamic equations are written for deviations around the balanced-growth steady state; the linearized steady states of hatted variables are zero. The nonstochastic levels used for scaling are:

$$
\mu_{z^\*}=\mu_\Upsilon^{\alpha/(1-\alpha)}\mu_z .
\tag{F45}
$$

$$
\tilde\rho=\frac{\mu_\Upsilon\mu_{z^\*}}{\beta}-(1-\delta),
\qquad
\pi=\frac{x}{\mu_{z^\*}},
\qquad
R=\frac{\pi\mu_{z^\*}}{\beta}.
\tag{F46}
$$

Money-service calibration:

$$
\eta'=\frac{R-1}{V^2},
\qquad
\varphi_\eta=\frac{1}{4\epsilon(R-1)}-2,
\qquad
q=\frac{c}{V}.
\tag{F47}
$$

Marginal cost and factor ratios:

$$
s=\frac{1}{\lambda_f},
\qquad
R_\nu=\nu R+1-\nu,
\qquad
\tilde w=\frac{1-\alpha}{R_\nu}s
\left(\frac{\tilde\rho}{\alpha s}\right)^{\alpha/(\alpha-1)}.
\tag{F48}
$$

$$
\frac{h}{\bar k}
=\left[
\frac{\tilde\rho}
{\alpha s(\mu_{z^\*}\mu_\Upsilon)^{1-\alpha}}
\right]^{1/(1-\alpha)} .
\tag{F49}
$$

The remaining steady-state levels are solved recursively from the household labor condition, consumption, money, production, fixed-cost zero-profit condition, investment, and marginal utility:

$$
\bar k=
\left[
\frac{(1+\eta)\tilde w}{\psi_L(h/\bar k)^{\sigma_L}}
\frac{\mu_{z^\*}-b\beta}{\lambda_w(\mu_{z^\*}-b)(1+\eta+\eta'V)}
\bigg/
\left(
\frac{1}{\lambda_f}(\mu_{z^\*}\mu_\Upsilon)^{-\alpha}(h/\bar k)^{1-\alpha}
-\left[1-\frac{1-\delta}{\mu_\Upsilon\mu_{z^\*}}\right]
\right)
\right]^{1/(1+\sigma_L)} .
\tag{F50}
$$

$$
h=(h/\bar k)\bar k,\qquad
c=\bar k^{-\sigma_L}\frac{\tilde w}{\psi_L(h/\bar k)^{\sigma_L}}
\frac{\mu_{z^\*}-\beta b}{\lambda_w(\mu_{z^\*}-b)(1+\eta+\eta'V)} .
\tag{F51}
$$

$$
m=\frac{\nu\tilde w h+q}{x},
\qquad
\tilde y=\frac{\tilde\rho\bar k}{\mu_\Upsilon\mu_{z^\*}}+\tilde w R_\nu h,
\qquad
\phi=\tilde y(\lambda_f-1).
\tag{F52}
$$

$$
i=\left(1-\frac{1-\delta}{\mu_\Upsilon\mu_{z^\*}}\right)\bar k,
\qquad
\lambda_{z^\*}=
\frac{\mu_{z^\*}-b\beta}{\mu_{z^\*}c-bc}
\frac{1}{1+\eta+\eta'V}.
\tag{F53}
$$

Steady-state values and formulas above are implementation-cross-checked and marked `needs_review` until the technical appendix or original replication package is source-level verified.

## 7. Timing & Form Conventions

- The model is a linear deviation system: all hatted variables and MMB variables such as `c_t`, `pi_t`, `i_t`, and `mu_z_t` are deviations around the balanced-growth steady state.
- Capital stock is predetermined within the period. The implementation variable `kbar_t1` represents the physical capital stock available next period; production equations use the predetermined stock.
- Timing in the implementation uses auxiliary lead/pred variables such as `c_tlead`, `c_tpred`, `i_tlead`, and `i_tpred` to represent variables decided before the monetary policy shock. This is central for the MMB file's warning that technology-shock IRFs are not reliable in that file.
- Technology shocks are observed before real decisions; the monetary shock arrives after price/wage and real allocation decisions.
- The sticky-price block and a flexible-price allocation block are both present in the MMB implementation. Flexible-price variables carry the `f` suffix.
- Runtime validation: not performed. Dynare was not run.

## 8. Variable & Parameter Reference Table

### Endogenous variables

| Category | Symbol / ASCII | Meaning | Main equation(s) |
|---|---|---|---|
| Endogenous | `c_t` | consumption deviation | (F24), (F34) |
| Endogenous | `wtilde_t` | scaled real wage | (F26), (F22) |
| Endogenous | `lambda_zstar_t` | scaled marginal utility | (F24), (F25) |
| Endogenous | `m_t` | money balances | (F35) |
| Endogenous | `pi_t` | inflation | (F21) |
| Endogenous | `x_t` | money growth | (F40) |
| Endogenous | `s_t` | average marginal cost | (F21), (F22) |
| Endogenous | `i_t` | investment | (F18), (F20), (F34) |
| Endogenous | `h_t` | hours | (F26), (F34), (F36) |
| Endogenous | `kbar_t1` | physical capital stock for next period | (F20), (F36) |
| Endogenous | `q_t` | real cash balances / liquidity | (F23), (F34) |
| Endogenous | `ytilde_t` | scaled output | (F19), (F36) |
| Endogenous | `R_t` | nominal/monetary return deviation | (F23), (F25) |
| Endogenous | `mutilde_t` | shadow value of installed capital | (F17), (F18) |
| Endogenous | `rhotilde_t` | scaled rental return on capital | (F17), (F19), (F37) |
| Endogenous | `u_t` | utilization | (F30), (F37) |
| Endogenous | `*_tlead`, `*_tpred` | timing auxiliaries for leads and predetermined decisions | (F17)-(F37) |
| Endogenous | `cf_t`, `pif_t`, `xf_t`, etc. | flexible-price allocation counterparts | flexible-price implementation block |
| Endogenous | `x_M_t`, `eps_M_t` | monetary-policy state and innovation proxy | (F41) |
| Endogenous | `mu_z_t`, `eps_muz_t` | neutral technology growth state and innovation proxy | (F38) |
| Endogenous | `x_z_t` | policy response to neutral technology | (F42) |
| Endogenous | `mu_ups_t`, `eps_muups_t` | embodied technology growth state and innovation proxy | (F39) |
| Endogenous | `x_ups_t` | policy response to embodied technology | (F43) |
| Endogenous | `epsilon_t` | transitory neutral technology state in MMB file | (F44) |

### Exogenous shocks

| ASCII | Meaning |
|---|---|
| `epsilon_M_` | monetary-policy innovation |
| `eps_muz_` | neutral-technology growth innovation |
| `eps_muups_` | embodied-technology growth innovation |
| `epsilon_t_` | added transitory neutral technology innovation in MMB implementation |

### Parameters

| ASCII | Meaning |
|---|---|
| `alpha` | capital share |
| `b` | habit parameter |
| `beta` | discount factor |
| `delta` | depreciation |
| `epsilon` | money-demand interest semi-elasticity target |
| `eta`, `eta_pr`, `sig_eta` | transactions-cost level/slope/curvature objects |
| `lambda_f` | intermediate-good markup parameter |
| `lambda_w` | wage markup parameter |
| `mu_ups`, `mu_z`, `mu_zstar` | embodied, neutral, and composite trend growth |
| `nu` | working-capital/cost-channel parameter; MMB variant sets it near zero |
| `psi_L`, `sigma_L` | labor-disutility level and curvature |
| `x` | steady-state money growth |
| `xi_w`, `xif_w`, `xif_p` | wage and flexible-price Calvo parameters |
| `V` | steady-state velocity |
| `kappa` | investment adjustment-cost curvature |
| `sigma_a` | utilization-cost curvature |
| `gamma` | reduced-form inflation slope |
| `squig` | price-indexation/inflation-lag coefficient |
| `rho_M`, `theta_M` | monetary shock persistence/MA term |
| `rho_muz`, `theta_muz`, `c_z`, `cp_z`, `rho_xz` | neutral-shock and policy-response parameters |
| `rho_muups`, `theta_muups`, `c_ups`, `cp_ups`, `rho_xups` | embodied-shock and policy-response parameters |
| `rho_epsilon` | persistence of added transitory technology shock |
| `ETA1`-`ETA10`, `ETA1f`-`ETA10f` | wage-equation coefficient bundles |
