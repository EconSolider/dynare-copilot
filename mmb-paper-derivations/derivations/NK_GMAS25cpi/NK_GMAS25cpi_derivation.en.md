# NK_GMAS25cpi -- Derivation

> Archive status: `needs_review`. This first-pass derivation is source-backed by the MinerU Markdown for Gali and Monacelli (2005). No appendix normalization or implementation `.mod` cross-check was available for this model id.

## 1. Model Overview

- **Model**: `NK_GMAS25cpi`, the CPI-inflation Taylor-rule variant associated with Gali and Monacelli (2005), "Monetary policy and exchange rate volatility in a small open economy."
- **Source**: `raw/mmb_mineru/runs/nk_gm05_nk_gmas25cpi_nk_gmas25ppi__monetary_policy_and_exchange_rate_volatility_in_a_small_open_economy__6f92413a/full.md`; DOI `10.1111/j.1467-937x.2005.00349.x`.
- **Agents and markets**: a representative household in a measure-zero small open economy; a continuum of monopolistically competitive domestic firms with Calvo price setting; complete international securities markets; and a central bank setting the short nominal interest rate.
- **Model form**: log-linear small-open-economy New Keynesian model. The nonlinear household, goods aggregator, budget, technology, and Calvo problems are recorded as primitives, but the operative equilibrium conditions are the paper's first-order approximations.
- **Variant note**: `NK_GMAS25cpi` identifies the CPI-inflation Taylor rule. The same source paper also discusses domestic-inflation Taylor and exchange-rate peg regimes; those are not this entry's policy closure.
- **Runtime validation**: not performed.

## 2. Optimization Problems

### Household

The representative household chooses consumption, labor, and a complete contingent-claims portfolio:

$$
\max_{\{C_t,N_t,D_{t+1}\}} E_0\sum_{t=0}^{\infty}\beta^t
\left(\frac{C_t^{1-\sigma}}{1-\sigma}-\frac{N_t^{1+\varphi}}{1+\varphi}\right)
$$

subject to the nominal budget constraint

$$
P_t C_t + E_t\{Q_{t,t+1}D_{t+1}\}
\le D_t + W_tN_t + T_t.
$$

Composite consumption combines domestic and imported goods:

$$
C_t =
\left[(1-\alpha)^{1/\eta}C_{H,t}^{(\eta-1)/\eta}
+\alpha^{1/\eta}C_{F,t}^{(\eta-1)/\eta}\right]^{\eta/(\eta-1)}.
$$

Demand for domestic and imported bundles is

$$
C_{H,t}=(1-\alpha)\left(\frac{P_{H,t}}{P_t}\right)^{-\eta}C_t,\qquad
C_{F,t}=\alpha\left(\frac{P_{F,t}}{P_t}\right)^{-\eta}C_t.
$$

### Firms

Each domestic firm produces one differentiated good with linear technology:

$$
Y_t(j)=A_tN_t(j).
$$

Nominal rigidity follows Calvo pricing. A measure $1-\theta$ of firms can reset price $\overline{P}_{H,t}$ each period. The source gives the log-linear reset-price rule:

$$
\overline{p}_{H,t}
=\mu +(1-\beta\theta)\sum_{k=0}^{\infty}(\beta\theta)^k
E_t\{mc^n_{t+k}\},
$$

where $\mu=\log(\varepsilon/(\varepsilon-1))$ is the desired steady-state markup in logs.

### Monetary Authority

For this MMB variant, the policy instrument is the short nominal interest rate and the rule reacts to CPI inflation:

$$
r_t=\rho+\phi_{\pi}\pi_t.
$$

This is the source paper's CPI-inflation Taylor rule, not the domestic-inflation rule and not the exchange-rate peg.

## 3. First-Order Conditions

- **(F1) Household intratemporal labor condition**:

$$
C_t^\sigma N_t^\varphi=\frac{W_t}{P_t},
\qquad
w_t-p_t=\sigma c_t+\varphi n_t.
$$

- **(F2) Household stochastic discount factor**:

$$
Q_{t,t+1}=
\beta\left(\frac{C_{t+1}}{C_t}\right)^{-\sigma}
\left(\frac{P_t}{P_{t+1}}\right).
$$

- **(F3) Riskless-bond Euler equation**:

$$
c_t=E_t\{c_{t+1}\}
-\frac{1}{\sigma}\left(r_t-E_t\{\pi_{t+1}\}-\rho\right).
$$

- **(F4) International risk sharing under complete markets**:

$$
c_t=c_t^*+\frac{1}{\sigma}q_t
=c_t^*+\frac{1-\alpha}{\sigma}s_t.
$$

- **(F5) Uncovered interest parity / terms-of-trade law of motion**:

$$
s_t=(r_t^*-E_t\{\pi_{t+1}^*\})
-(r_t-E_t\{\pi_{H,t+1}\})+E_t\{s_{t+1}\}.
$$

- **(F6) Firm real marginal cost in domestic-price terms**:

$$
mc_t=-\nu+w_t-p_{H,t}-a_t.
$$

- **(F7) Domestic marginal cost as a function of output, world output, and productivity**:

$$
mc_t=-\nu+(\sigma_\alpha+\varphi)y_t
+(\sigma-\sigma_\alpha)y_t^*-(1+\varphi)a_t.
$$

- **(F8) Domestic natural output**:

$$
\overline{y}_t=\Omega+\Gamma a_t+\alpha\Psi y_t^*,
$$

with

$$
\Gamma=\frac{1+\varphi}{\sigma_\alpha+\varphi},\qquad
\Psi=-\frac{\Theta\sigma_\alpha}{\sigma_\alpha+\varphi}.
$$

- **(F9) Output gap definition**:

$$
x_t=y_t-\overline{y}_t.
$$

- **(F10) New Keynesian Phillips curve for domestic inflation**:

$$
\pi_{H,t}=\beta E_t\{\pi_{H,t+1}\}+\kappa_\alpha x_t,
\qquad
\kappa_\alpha=\lambda(\sigma_\alpha+\varphi).
$$

- **(F11) Dynamic IS equation for the output gap**:

$$
x_t=E_t\{x_{t+1}\}
-\frac{1}{\sigma_\alpha}
\left(r_t-E_t\{\pi_{H,t+1}\}-\overline{rr}_t\right).
$$

- **(F12) Natural real interest rate**:

$$
\overline{rr}_t
=\rho-\sigma_\alpha\Gamma(1-\rho_a)a_t
+\alpha\sigma_\alpha(\Theta+\Psi)E_t\{\Delta y_{t+1}^*\}.
$$

- **(F13) CPI-inflation Taylor rule for `NK_GMAS25cpi`**:

$$
r_t=\rho+\phi_{\pi}\pi_t.
$$

## 4. Market Clearing & Identities

- **(F14) CPI and domestic prices**:

$$
p_t=p_{H,t}+\alpha s_t.
$$

- **(F15) CPI inflation and domestic inflation**:

$$
\pi_t=\pi_{H,t}+\alpha\Delta s_t.
$$

- **(F16) Effective terms of trade and the nominal exchange rate**:

$$
s_t=e_t+p_t^*-p_{H,t}.
$$

- **(F17) Effective real exchange rate**:

$$
q_t=(1-\alpha)s_t.
$$

- **(F18) Goods-market clearing / output-demand relation**:

$$
y_t=c_t+\frac{\alpha\omega}{\sigma}s_t,
\qquad
\omega=\sigma\gamma+(1-\alpha)(\sigma\eta-1).
$$

- **(F19) Output and terms of trade**:

$$
y_t=y_t^*+\frac{1}{\sigma_\alpha}s_t,\qquad
\sigma_\alpha=\frac{\sigma}{(1-\alpha)+\alpha\omega}.
$$

- **(F20) Linear production function**:

$$
y_t=a_t+n_t.
$$

- **(F21) Net exports, when tracked**:

$$
nx_t=\alpha\left(\frac{\omega}{\sigma}-1\right)s_t.
$$

## 5. Exogenous Processes

- **(F22) Domestic productivity**:

$$
a_t=\rho_a a_{t-1}+\varepsilon_t^a.
$$

- **(F23) World output process**:

$$
y_t^*=\rho_{y^*}y_{t-1}^*+\varepsilon_t^*.
$$

The numerical section estimates the two AR(1) processes from quarterly Canadian productivity and U.S. GDP data and allows positive contemporaneous correlation between the innovations. The entry does not impose the paper's reported innovation standard deviations as structural derivation requirements.

## 6. Steady-State Solution

Because the operative system is log-linear, all stationary lower-case variables are deviations around a symmetric perfect-foresight steady state.

- Set zero-inflation steady state: $\pi_H=\pi=0$.
- Set PPP/relative-price normalization: $s=q=e=0$ and $p=p_H=p_F=p^*$.
- Set exogenous deviations: $a=0$ and $y^*=0$.
- Set output at its natural level: $x=0$ and $y=\overline{y}$.
- Set the steady real rate to the discount-rate constant: $r=\rho=\beta^{-1}-1$ in the paper's log-linear notation.
- With the special welfare case $\sigma=\eta=\gamma=1$, the source reports $\omega=1$ and the balanced-trade condition $nx_t=0$.

The constant component $\Omega$ in natural output depends on the markup and subsidy wedge. The OCR line around $\Omega=(\nu-\mu)/(\sigma_\alpha+\varphi)$ is readable enough for a first pass but remains `needs_review` before reviewed status.

## 7. Timing & Form Conventions

- **Form**: `model(linear)`-style log-linear representation. Lower-case variables are logs or log deviations unless explicitly rates.
- **Inflation timing**: $\pi_t=p_t-p_{t-1}$ and $\pi_{H,t}=p_{H,t}-p_{H,t-1}$.
- **Expectations**: $E_t\{\cdot\}$ conditions on information at time $t$.
- **Stocks**: there is no capital stock in this model; production is linear in labor.
- **Policy rate**: $r_t$ is the short nominal rate in the source's log-linear policy-rule notation; the natural real rate $\overline{rr}_t$ enters the IS equation.
- **Open-economy prices**: the terms of trade are the price of foreign goods in home goods, so a higher $s_t$ is a deterioration of home terms of trade in the paper's convention.
- **CPI variant**: `NK_GMAS25cpi` closes the system with (F13), where the policy rule responds to $\pi_t$ rather than $\pi_{H,t}$.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Main equation |
|---|---|---|---|
| Endogenous | $c_t$ / `c` | consumption | (F3), (F4), (F18) |
| Endogenous | $n_t$ / `n` | labor | (F1), (F20) |
| Endogenous | $y_t$ / `y` | domestic output | (F18), (F19), (F20) |
| Endogenous | $x_t$ / `x` | output gap | (F9), (F10), (F11) |
| Endogenous | $\pi_{H,t}$ / `piH` | domestic-goods inflation | (F10), (F15) |
| Endogenous | $\pi_t$ / `pi` | CPI inflation | (F13), (F15) |
| Endogenous | $r_t$ / `r` | short nominal policy rate in log-linear notation | (F11), (F13) |
| Endogenous | $s_t$ / `s` | effective terms of trade | (F4), (F5), (F14)-(F19) |
| Endogenous | $q_t$ / `q` | real exchange rate | (F4), (F17) |
| Endogenous | $e_t$ / `e` | nominal effective exchange rate | (F16) |
| Endogenous | $mc_t$ / `mc` | real marginal cost | (F6), (F7), (F10) |
| Endogenous | $\overline{y}_t$ / `ybar` | natural output | (F8), (F9) |
| Endogenous | $\overline{rr}_t$ / `rrbar` | natural real interest rate | (F11), (F12) |
| Optional endogenous | $nx_t$ / `nx` | net exports share | (F21) |
| Exogenous | $a_t$ / `a` | domestic productivity | (F22) |
| Exogenous | $y_t^*$ / `ystar` | world output | (F23) |
| Shock | $\varepsilon_t^a$ / `eps_a` | domestic productivity innovation | (F22) |
| Shock | $\varepsilon_t^*$ / `eps_ystar` | world-output innovation | (F23) |
| Parameter | $\beta$ / `beta` | discount factor | (F2), (F10) |
| Parameter | $\sigma$ / `sigma` | inverse intertemporal elasticity / risk aversion | (F1), (F3), (F4) |
| Parameter | $\varphi$ / `phi_n` | inverse Frisch elasticity | (F1), (F7), (F10) |
| Parameter | $\alpha$ / `alpha` | openness/import-share parameter | (F14), (F15), (F18), (F19) |
| Parameter | $\eta$ / `eta` | domestic vs. foreign bundle elasticity | (F18) |
| Parameter | $\gamma$ / `gamma` | elasticity across foreign goods | (F18) |
| Parameter | $\theta$ / `theta` | Calvo non-reset probability | (F10) |
| Parameter | $\varepsilon$ / `epsilon` | variety elasticity / markup determinant | section 2, section 6 |
| Parameter | $\lambda$ / `lambda` | Calvo slope component | (F10) |
| Parameter | $\kappa_\alpha$ / `kappa_alpha` | open-economy Phillips-curve slope | (F10) |
| Parameter | $\phi_\pi$ / `phi_pi` | CPI inflation response in Taylor rule | (F13) |
| Parameter | $\rho_a$ / `rho_a` | domestic productivity persistence | (F22) |
| Parameter | $\rho_{y^*}$ / `rho_ystar` | world output persistence | (F23) |
| Parameter | $\nu,\mu,\tau$ / `nu`, `mu`, `tau` | subsidy and markup terms | (F6), section 6 |

First-pass equation labels are continuous from (F1) through (F23). The archive keeps `needs_review` because some coefficient definitions around $\Omega$, $\Theta$, and OCR-rendered appendix formulas should be checked against the PDF before promotion.
