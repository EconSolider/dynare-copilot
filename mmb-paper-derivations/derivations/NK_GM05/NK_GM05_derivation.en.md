# NK_GM05 -- Derivation

> Runtime validation was not performed. This first-pass archive entry is source-backed by MinerU Markdown and is marked `needs_review` where formulas or implementation choices should be checked against the published PDF in a later review.

Provenance: `NK_GM05`, Galí and Monacelli (2005), "Monetary policy and exchange rate volatility in a small open economy", Review of Economic Studies 72, 707-734, DOI `10.1111/j.1467-937x.2005.00349.x`. Source Markdown: `raw/mmb_mineru/runs/nk_gm05_nk_gmas25cpi_nk_gmas25ppi__monetary_policy_and_exchange_rate_volatility_in_a_small_open_economy__6f92413a/full.md`. Raw PDF path checked: `raw/mmb_papers/Monetary policy and exchange rate volatility in a small open economy.pdf`.

## 1. Model Overview

- **Model**: Small open economy New Keynesian model with complete international financial markets, Calvo domestic price setting, producer-price inflation, CPI inflation, terms of trade, and nominal exchange rate dynamics.
- **Source focus**: The paper derives the household/firms model and then uses the log-linear canonical system for policy-regime experiments. The MMB implementation cross-check uses the log-linear `model(linear)` representation.
- **Agents and blocks**: Representative household, domestic differentiated-good firms, the rest of the world as exogenous to the small economy, and a monetary authority choosing either strict domestic inflation targeting, a domestic-inflation Taylor rule, a CPI-inflation Taylor rule, or an exchange-rate peg.
- **Form**: Log-linear. Lower-case variables are log deviations or log levels around a symmetric zero-inflation steady state. The MMB example uses `model(linear)`.
- **Main exogenous drivers**: Domestic productivity $a_t$ and world output $y_t^*$.

## 2. Optimization Problems

### Representative Household

The household chooses consumption, labor, and a complete-contingent-claims portfolio:

$$
\max_{\{C_t,N_t,D_{t+1}\}} E_0 \sum_{t=0}^{\infty}\beta^t
\left(\frac{C_t^{1-\sigma}}{1-\sigma}-\frac{N_t^{1+\varphi}}{1+\varphi}\right)
$$

subject to the nominal budget constraint

$$
P_t C_t + E_t\{Q_{t,t+1}D_{t+1}\} \le D_t + W_t N_t + T_t.
$$

Consumption is a CES bundle of domestic and imported goods:

$$
C_t=\left[(1-\alpha)^{1/\eta}C_{H,t}^{(\eta-1)/\eta}
+\alpha^{1/\eta}C_{F,t}^{(\eta-1)/\eta}\right]^{\eta/(\eta-1)}.
$$

Within each country-of-origin bundle, varieties are CES aggregates with elasticity $\varepsilon$; imported goods are also aggregated across foreign countries with elasticity $\gamma$.

### Domestic Firms

Each domestic firm produces a differentiated good with linear technology:

$$
Y_t(j)=A_t N_t(j), \qquad a_t \equiv \log A_t.
$$

Firms that can reset prices under Calvo probability $1-\theta$ choose $\overline P_{H,t}$ to maximize the expected discounted dividend stream:

$$
\max_{\overline P_{H,t}} \sum_{k=0}^{\infty}\theta^k E_t
\left\{Q_{t,t+k}Y_{t+k}(\overline P_{H,t})
\left[\overline P_{H,t}-MC^n_{t+k}\right]\right\},
$$

subject to demand for the variety. The MinerU OCR around Appendix B is readable in structure, but this objective should be checked against the PDF before promotion because the demand argument is compressed in the OCR output (`needs_review`).

### Monetary Authority

The paper studies strict domestic inflation targeting and three simple policy regimes. Policy is represented by interest-rate or exchange-rate rules rather than by money demand.

## 3. First-Order Conditions

- **(F1) Intratemporal labor condition**:

$$
C_t^{\sigma}N_t^{\varphi}=\frac{W_t}{P_t}.
$$

- **(F2) Nominal stochastic discount factor**:

$$
Q_{t,t+1}=\beta\left(\frac{C_{t+1}}{C_t}\right)^{-\sigma}
\left(\frac{P_t}{P_{t+1}}\right).
$$

- **(F3) Consumption Euler equation, log-linear form**:

$$
c_t=E_t\{c_{t+1}\}-\frac{1}{\sigma}
\left(r_t-E_t\{\pi_{t+1}\}-\rho\right).
$$

- **(F4) International risk sharing**:

$$
c_t=c_t^*+\frac{1}{\sigma}q_t
=c_t^*+\frac{1-\alpha}{\sigma}s_t.
$$

- **(F5) Uncovered interest parity**:

$$
r_t-r_t^*=E_t\{\Delta e_{t+1}\}.
$$

- **(F6) Terms-of-trade interest-rate relation**:

$$
s_t=(r_t^*-E_t\{\pi_{t+1}^*\})-(r_t-E_t\{\pi_{H,t+1}\})+E_t\{s_{t+1}\}.
$$

- **(F7) Aggregate production**:

$$
y_t=a_t+n_t.
$$

- **(F8) Real marginal cost in domestic-price units**:

$$
mc_t=-\nu+(w_t-p_{H,t})-a_t.
$$

- **(F9) Domestic-inflation Phillips curve in marginal cost**:

$$
\pi_{H,t}=\beta E_t\{\pi_{H,t+1}\}+\lambda \widehat{mc}_t,
\qquad
\lambda=\frac{(1-\beta\theta)(1-\theta)}{\theta}.
$$

- **(F10) Marginal cost as a function of domestic output**:

$$
mc_t=-\nu+(\sigma_{\alpha}+\varphi)y_t+(\sigma-\sigma_{\alpha})y_t^*
-(1+\varphi)a_t.
$$

- **(F11) Natural output**:

$$
\overline y_t=\Omega+\Gamma a_t+\alpha\Psi y_t^*,
\quad
\Gamma=\frac{1+\varphi}{\sigma_{\alpha}+\varphi},
\quad
\Psi=-\frac{\Theta\sigma_{\alpha}}{\sigma_{\alpha}+\varphi}.
$$

- **(F12) Output gap definition**:

$$
x_t=y_t-\overline y_t.
$$

- **(F13) NK Phillips curve in output gap**:

$$
\pi_{H,t}=\beta E_t\{\pi_{H,t+1}\}+\kappa_{\alpha}x_t,
\qquad
\kappa_{\alpha}=\lambda(\sigma_{\alpha}+\varphi).
$$

- **(F14) Dynamic IS equation**:

$$
x_t=E_t\{x_{t+1}\}-\frac{1}{\sigma_{\alpha}}
\left(r_t-E_t\{\pi_{H,t+1}\}-\overline{rr}_t\right).
$$

- **(F15) Natural real interest rate**:

$$
\overline{rr}_t=\rho-\sigma_{\alpha}\Gamma(1-\rho_a)a_t
+\alpha\sigma_{\alpha}(\Theta+\Psi)E_t\{\Delta y_{t+1}^*\}.
$$

- **(F16) Strict domestic inflation targeting / optimal special case**:

$$
x_t=\pi_{H,t}=0.
$$

- **(F17) Implementing rule for the optimal allocation**:

$$
r_t=\overline{rr}_t+\phi_{\pi}\pi_{H,t}+\phi_x x_t.
$$

- **(F18) Determinacy condition for the implementing rule**:

$$
\kappa_{\alpha}(\phi_{\pi}-1)+(1-\beta)\phi_x>0.
$$

## 4. Market Clearing & Identities

- **(F19) CPI price index, first-order form**:

$$
p_t=p_{H,t}+\alpha s_t.
$$

- **(F20) CPI inflation identity**:

$$
\pi_t=\pi_{H,t}+\alpha\Delta s_t.
$$

- **(F21) Terms of trade definition**:

$$
s_t=e_t+p_t^*-p_{H,t}.
$$

- **(F22) Effective real exchange rate**:

$$
q_t=(1-\alpha)s_t.
$$

- **(F23) Small open economy demand-output relation**:

$$
y_t=c_t+\frac{\alpha\omega}{\sigma}s_t,
\qquad
\omega=\sigma\gamma+(1-\alpha)(\sigma\eta-1).
$$

- **(F24) World goods-market clearing**:

$$
y_t^*=c_t^*.
$$

- **(F25) Output and terms-of-trade relation**:

$$
y_t=y_t^*+\frac{1}{\sigma_{\alpha}}s_t,
\qquad
\sigma_{\alpha}=\frac{\sigma}{(1-\alpha)+\alpha\omega}.
$$

- **(F26) Net exports relation**:

$$
nx_t=\alpha\left(\frac{\omega}{\sigma}-1\right)s_t.
$$

- **(F27) CPI inflation-based Taylor rule**:

$$
r_t=\rho+\phi_{\pi}\pi_t.
$$

- **(F28) Domestic inflation-based Taylor rule**:

$$
r_t=\rho+\phi_{\pi}\pi_{H,t}.
$$

- **(F29) Exchange-rate peg**:

$$
e_t=0.
$$

- **(F30) Welfare loss approximation in the special case**:

$$
\mathbb{W}=-\frac{1-\alpha}{2}\sum_{t=0}^{\infty}\beta^t
\left[\frac{\varepsilon}{\lambda}\pi_{H,t}^2+(1+\varphi)x_t^2\right].
$$

## 5. Exogenous Processes

- **(F31) Domestic productivity**:

$$
a_t=\rho_a a_{t-1}+\varepsilon_t^a.
$$

- **(F32) World output**:

$$
y_t^*=\rho_y y_{t-1}^*+\varepsilon_t^*.
$$

The calibration section estimates $\rho_a=0.66$, $\rho_y=0.86$, standard deviations $0.0071$ and $0.0078$, and innovation correlation $0.3$. The MMB example uses shocks `a_` and `ystar_`.

## 6. Steady-State Solution

The derivation is log-linear around a symmetric perfect-foresight steady state. In that steady state:

1. $A=1$ for the symmetric foreign economies; domestic $A=1$ in the symmetric baseline.
2. Purchasing power parity holds and $S=1$, so $s=0$ and $q=0$.
3. Domestic and foreign output coincide, $Y=Y^*$, in the symmetric case.
4. Zero inflation implies $\pi_H=\pi=0$ and constant domestic and CPI price levels.
5. The riskless gross real return is pinned down by $\beta$, with $\rho=\beta^{-1}-1$ in the log-linear notation used by the paper.
6. In the special optimal-policy calibration, $\sigma=\eta=\gamma=1$ and the subsidy satisfies $(1-\tau)(1-\alpha)=1-1/\varepsilon$, making the flexible-price allocation efficient.
7. Under `model(linear)` implementation, all endogenous log-deviation steady states are zero; this is the steady-state convention used in the Rep-MMB example.

The source gives an Appendix A steady-state argument for uniqueness of the terms of trade. The OCR for a few Appendix A algebra lines is noisy but not needed for the MMB log-linear model block (`needs_review` for a full nonlinear derivation).

## 7. Timing & Form Conventions

- Variables are dated at period $t$ and are forward-looking through expectations $E_t\{\cdot\}$.
- The model contains no capital stock, so there is no capital-in-production timing convention.
- Domestic price inflation is $\pi_{H,t}=p_{H,t}-p_{H,t-1}$; CPI inflation is $\pi_t=p_t-p_{t-1}$.
- The terms of trade are $s_t=p_{F,t}-p_{H,t}=e_t+p_t^*-p_{H,t}$, where a higher $s_t$ is a depreciation of the home terms of trade in the paper's convention.
- The MMB example fixes the policy regime to DIT (`pih = 0`) and comments out DITR, CITR, and PEG alternatives. It also sets foreign inflation to zero and omits the UIP equation from the active model block.
- Runtime validation was not performed; equation-count/BK checks are deferred.

## 8. Variable & Parameter Reference Table

| Category | Symbol / Dynare name | Meaning | Main equation(s) |
|---|---|---|---|
| Endogenous | $c_t$ | CPI consumption | (F3), (F4), (F23) |
| Endogenous | $n_t$ | Labor | (F1), (F7) |
| Endogenous | $w_t$ | Nominal wage log | (F1), (F8) |
| Endogenous | $y_t$ / `y` | Domestic output | (F10), (F12), (F25) |
| Endogenous | $\overline y_t$ / `ynat` | Natural output | (F11) |
| Endogenous | $x_t$ / `x` | Output gap | (F12), (F14) |
| Endogenous | $\pi_{H,t}$ / `pih` | Domestic inflation | (F13), (F20), (F28) |
| Endogenous | $\pi_t$ / `pi` | CPI inflation | (F20), (F27) |
| Endogenous | $r_t$ / `r` | Nominal policy rate in log-linear notation | (F14), (F17), (F27), (F28) |
| Endogenous | $\overline{rr}_t$ / `rnat` | Natural real interest rate | (F15) |
| Endogenous | $s_t$ / `s` | Terms of trade | (F21), (F25) |
| Endogenous | $q_t$ | Effective real exchange rate | (F22) |
| Endogenous | $e_t$ / `e` | Nominal effective exchange rate | (F21), (F29) |
| Endogenous | $p_t$ / `p` | CPI price level | (F19) |
| Endogenous | $p_{H,t}$ / `ph` | Domestic price level | (F19), (F21) |
| Endogenous | $a_t$ / `a` | Domestic productivity | (F31) |
| Endogenous | $y_t^*$ / `ystar` | World output | (F32) |
| Endogenous | $\pi_t^*$ / `pistar` | World inflation | MMB sets zero |
| Exogenous | $\varepsilon_t^a$ / `a_` | Domestic productivity innovation | (F31) |
| Exogenous | $\varepsilon_t^*$ / `ystar_` | World-output innovation | (F32) |
| Parameter | $\beta$ / `beta` | Discount factor | (F2), (F9), (F13) |
| Parameter | $\sigma$ / `sigma` | Consumption risk aversion / inverse intertemporal elasticity | (F3), (F4), (F23) |
| Parameter | $\varphi$ / `varphi` or `tau` in MMB code | Inverse Frisch elasticity | (F1), (F10), (F11) |
| Parameter | $\alpha$ / `alpha` | Openness/import share | (F19), (F20), (F25) |
| Parameter | $\eta$ | Home/foreign elasticity | (F23) |
| Parameter | $\gamma$ | Elasticity across foreign-country goods | (F23) |
| Parameter | $\theta$ / `theta` | Calvo non-reset probability | (F9) |
| Parameter | $\varepsilon$ | Variety elasticity | (F30) |
| Parameter | $\lambda$ | Phillips-curve marginal-cost coefficient | (F9), (F30) |
| Parameter | $\kappa_{\alpha}$ / `kappa` | Open-economy NKPC slope | (F13), (F18) |
| Parameter | $\rho$ / `rho` | Steady-state real interest rate in log-linear notation | (F3), (F15), (F27), (F28) |
| Parameter | $\rho_a$ / `rhoa` | Productivity persistence | (F31) |
| Parameter | $\rho_y$ / `rhoy` | World-output persistence | (F32) |
| Parameter | $\phi_{\pi}$ / `phipi` | Taylor-rule inflation coefficient | (F17), (F27), (F28) |
| Parameter | $\phi_x$ | Taylor-rule output-gap coefficient | (F17), (F18) |
| Parameter | $\omega$, $\Theta$, $\sigma_{\alpha}$, $\Gamma$, $\Psi$, $\Omega$ | Composite open-economy coefficients | (F10), (F11), (F15), (F23), (F25) |
