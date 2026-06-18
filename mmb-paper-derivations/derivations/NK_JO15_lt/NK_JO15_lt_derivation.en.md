# NK_JO15_lt - Derivation (Optimization Problems + First-Order Conditions)

> Archive draft for source-backed model extraction. Runtime validation was not performed.

Provenance: `NK_JO15_lt`, Jang and Okano (2015), "Productivity Shocks and Monetary Policy in a Two-Country Model", Front. Econ. China, 10(1), 7-37, DOI `10.1016/j.jpolmod.2015.03.017`. Primary source Markdown: `raw/mmb_mineru/runs/nk_jo15_ht_nk_jo15_lt__productivity_shocks_and_monetary_policy_in_a_two_country_model__f031feec/full.md`. Raw PDF path checked: `raw/mmb_papers/Productivity Shocks and Monetary Policy in a Two-Country Model.pdf`. MinerU run id: `f031feec-a81e-43ec-ac7a-f89bd2d73785`. Appendix normalization: none found. Implementation cross-check: `.agents/skills/dynare-copilot/references/examples/NK_JO15_lt_rep.mod`.

## 1. Model Overview

- **Model**: symmetric two-country New Keynesian open-economy model with home bias, incomplete PPP away from the symmetric trade share, Calvo-Yun price setting, monopolistic competition, complete financial markets, and a Ravenna-Walsh cost channel in firms' marginal cost.
- **MMB variant**: `NK_JO15_lt`, low level of trade openness. The paper studies several openness cases; this entry records the low-trade case with $\alpha=0.1$.
- **Experiment**: the MMB implementation simulates the dynamic response of the domestic economy to a foreign productivity shock. Runtime validation is not performed in this archive pass.
- **Agents and blocks**: representative households in countries H and F, differentiated-goods firms in each country, complete international asset markets, and Taylor-rule central banks in both countries.
- **Form**: log-linear `model(linear)`. Lowercase variables denote percentage deviations from deterministic steady state, except the implementation-level levels/indices such as $p_t$, $p_t^{\ast}$, $e_t$, $s_t$, and $q_t$ are linearized log variables. All steady-state deviations are zero.
- **Source quality**: the model equations are readable in the MinerU Markdown, but several OCR equation tags and symbols are malformed (`needs_review` for exact paper equation labels and for the CPI inflation expression that includes a cost-channel term in the OCR text).

## 2. Optimization Problems

### 2.1 Households

Country H and F households maximize separable utility:

$$(F1)\qquad
\mathcal{U}=E_0\sum_{t=0}^{\infty}\beta^t
\left(\frac{C_t^{1-\sigma}}{1-\sigma}-\frac{N_t^{1+\varphi}}{1+\varphi}\right),
\quad
\mathcal{U}^{\ast}=E_0\sum_{t=0}^{\infty}\beta^t
\left(\frac{(C_t^{\ast})^{1-\sigma}}{1-\sigma}-\frac{(N_t^{\ast})^{1+\varphi}}{1+\varphi}\right).
$$

The composite consumption indexes are:

$$(F2)\qquad
C_t=\left[(1-\alpha)^{1/\eta}C_{H,t}^{(\eta-1)/\eta}
\alpha^{1/\eta}C_{F,t}^{(\eta-1)/\eta}\right]^{\eta/(\eta-1)},
$$

$$(F3)\qquad
C_t^{\ast}=\left[(1-\alpha)^{1/\eta}(C_{F,t}^{\ast})^{(\eta-1)/\eta}
\alpha^{1/\eta}(C_{H,t}^{\ast})^{(\eta-1)/\eta}\right]^{\eta/(\eta-1)}.
$$

The domestic household budget constraint after within-category aggregation is:

$$(F4)\qquad
P_t C_t+E_t(Q_{t,t+1}D_{t+1}^n)\leq D_t^n+W_tN_t+TR_t,
$$

with the analogous foreign constraint:

$$(F5)\qquad
P_t^{\ast} C_t^{\ast}+E_t(Q_{t,t+1}^{\ast}D_{t+1}^{n\ast})\leq D_t^{n\ast}+W_t^{\ast}N_t^{\ast}+TR_t^{\ast}.
$$

### 2.2 Goods Demand And Price Aggregators

Within-country demand for differentiated varieties is:

$$(F6)\qquad
C_t(h)=\left(\frac{P_t(h)}{P_{H,t}}\right)^{-\varepsilon}C_{H,t},\quad
C_t(f)=\left(\frac{P_t(f)}{P_{F,t}}\right)^{-\varepsilon}C_{F,t},
$$

$$(F7)\qquad
C_t^{\ast}(h)=\left(\frac{P_t^{\ast}(h)}{P_{H,t}^{\ast}}\right)^{-\varepsilon}C_{H,t}^{\ast},\quad
C_t^{\ast}(f)=\left(\frac{P_t^{\ast}(f)}{P_{F,t}^{\ast}}\right)^{-\varepsilon}C_{F,t}^{\ast}.
$$

Allocation between home and imported goods is:

$$(F8)\qquad
C_{H,t}=(1-\alpha)\left(\frac{P_{H,t}}{P_t}\right)^{-\eta}C_t,\quad
C_{F,t}=\alpha\left(\frac{P_{F,t}}{P_t}\right)^{-\eta}C_t,
$$

$$(F9)\qquad
C_{H,t}^{\ast}=\alpha\left(\frac{P_{H,t}^{\ast}}{P_t^{\ast}}\right)^{-\eta}C_t^{\ast},\quad
C_{F,t}^{\ast}=(1-\alpha)\left(\frac{P_{F,t}^{\ast}}{P_t^{\ast}}\right)^{-\eta}C_t^{\ast}.
$$

Consumer price indexes are:

$$(F10)\qquad
P_t=\left[(1-\alpha)P_{H,t}^{1-\eta}+\alpha P_{F,t}^{1-\eta}\right]^{1/(1-\eta)}.
$$

$$(F11)\qquad
P_t^{\ast}=\left[(1-\alpha)(P_{F,t}^{\ast})^{1-\eta}+\alpha(P_{H,t}^{\ast})^{1-\eta}\right]^{1/(1-\eta)}.
$$

### 2.3 Firms

Each country has a continuum of monopolistically competitive firms with linear production:

$$(F12)\qquad
Y_t(h)=A_tN_t(h),\quad Y_t^{\ast}(f)=A_t^{\ast}N_t^{\ast}(f).
$$

Variety demand implies:

$$(F13)\qquad
Y_t(h)=\left(\frac{P_t(h)}{P_{H,t}}\right)^{-\varepsilon}Y_t,\quad
Y_t^{\ast}(f)=\left(\frac{P_t^{\ast}(f)}{P_{F,t}^{\ast}}\right)^{-\varepsilon}Y_t^{\ast}.
$$

Aggregate employment and production satisfy:

$$(F14)\qquad
N_t=\frac{Y_tD_t}{A_t},\quad N_t^{\ast}=\frac{Y_t^{\ast}D_t^{\ast}}{A_t^{\ast}},
$$

and, to first order around the deterministic steady state:

$$(F15)\qquad
y_t=a_t+n_t,\quad y_t^{\ast}=a_t^{\ast}+n_t^{\ast}.
$$

Firms reset prices with probability $1-\theta$. Their Calvo-Yun reset-price conditions are:

$$(F16)\qquad
\tilde P_{H,t}=E_t\left(
\frac{\sum_{k=0}^{\infty}\theta^k Q_{t,t+k}Y_{t+k}
\frac{\varepsilon}{\varepsilon-1}P_{H,t+k}MC_{H,t+k}}
{\sum_{k=0}^{\infty}\theta^k Q_{t,t+k}Y_{t+k}}
\right),
$$

$$(F17)\qquad
\tilde P_{F,t}^{\ast}=E_t\left(
\frac{\sum_{k=0}^{\infty}\theta^k Q_{t,t+k}^{\ast}Y_{F,t+k}
\frac{\varepsilon}{\varepsilon-1}P_{F,t+k}^{\ast}MC_{F,t+k}^{\ast}}
{\sum_{k=0}^{\infty}\theta^k Q_{t,t+k}^{\ast}Y_{F,t+k}}
\right).
$$

Real marginal cost includes the cost channel:

$$(F18)\qquad
MC_{H,t}=\frac{P_t}{P_{H,t}}\frac{(1-\tau)C_t^\sigma N_t^\varphi R_t}{A_t},\quad
MC_{F,t}^{\ast}=\frac{P_t^{\ast}}{P_{F,t}^{\ast}}\frac{(1-\tau)(C_t^{\ast})^\sigma (N_t^{\ast})^\varphi R_t^{\ast}}{A_t^{\ast}}.
$$

## 3. First-Order Conditions

Household Euler equations:

$$(F19)\qquad
\beta E_t\left(\frac{C_{t+1}^{-\sigma}P_t}{C_t^{-\sigma}P_{t+1}}\right)=\frac{1}{R_t},\quad
\beta E_t\left(\frac{(C_{t+1}^{\ast})^{-\sigma}P_t^{\ast}}{(C_t^{\ast})^{-\sigma}P_{t+1}^{\ast}}\right)=\frac{1}{R_t^{\ast}}.
$$

Labor supply conditions:

$$(F20)\qquad
C_t^\sigma N_t^\varphi=\frac{W_t}{P_t},\quad
(C_t^{\ast})^\sigma(N_t^{\ast})^\varphi=\frac{W_t^{\ast}}{P_t^{\ast}}.
$$

Log-linear Euler equations:

$$(F21)\qquad
c_t=E_t(c_{t+1})-\frac{1}{\sigma}\{r_t-E_t(\pi_{t+1})\},\quad
c_t^{\ast}=E_t(c_{t+1}^{\ast})-\frac{1}{\sigma}\{r_t^{\ast}-E_t(\pi_{t+1}^{\ast})\}.
$$

The log-linear Calvo reset-price condition yields the PPI Phillips curves:

$$(F22)\qquad
\pi_{H,t}=\beta E_t(\pi_{H,t+1})+\kappa_H mc_{H,t},\quad
\pi_{F,t}^{\ast}=\beta E_t(\pi_{F,t+1}^{\ast})+\kappa_F mc_{F,t}^{\ast},
$$

where $\kappa_H=(1-\theta_H)(1-\theta_H\beta)/\theta_H$ and $\kappa_F=(1-\theta_F)(1-\theta_F\beta)/\theta_F$ in the MMB implementation.

Natural-output definitions:

$$(F23)\qquad
x_t\equiv y_t-\bar y_t,\quad x_t^{\ast}\equiv y_t^{\ast}-\bar y_t^{\ast}.
$$

Natural output under flexible prices and constant marginal cost:

$$(F24)\qquad
\bar y_t=\frac{\varsigma\psi}{\delta}a_t-\frac{\omega_2\sigma\psi}{\delta}a_t^{\ast},\quad
\bar y_t^{\ast}=\frac{\varsigma\psi}{\delta}a_t^{\ast}-\frac{\omega_2\sigma\psi}{\delta}a_t.
$$

Open-economy IS curves in output gaps:

$$(F25)\qquad
x_t=E_t(x_{t+1})-\frac{1}{\sigma_\omega}\{r_t-E_t(\pi_{H,t+1})\}
\frac{\omega_2}{\omega_2+1}\{E_t(x_{t+1}^{\ast})-x_t^{\ast}\}
\frac{1}{\sigma_\omega}\bar r_t.
$$

$$(F26)\qquad
x_t^{\ast}=E_t(x_{t+1}^{\ast})-\frac{1}{\sigma_\omega}\{r_t^{\ast}-E_t(\pi_{F,t+1}^{\ast})\}
\frac{\omega_2}{\omega_2+1}\{E_t(x_{t+1})-x_t\}
\frac{1}{\sigma_\omega}\bar r_t^{\ast}.
$$

Natural real interest rates:

$$(F27)\qquad
\bar r_t=-\Theta a_t-\Omega_1a_t^{\ast},\quad
\bar r_t^{\ast}=-\Theta a_t^{\ast}-\Omega_1a_t.
$$

Marginal cost in output gaps:

$$(F28)\qquad
mc_{H,t}=\frac{\varsigma}{\omega_4+1}x_t+\frac{\omega_2\sigma}{\omega_4+1}x_t^{\ast}+r_t,\quad
mc_{F,t}^{\ast}=\frac{\varsigma}{\omega_4+1}x_t^{\ast}+\frac{\omega_2\sigma}{\omega_4+1}x_t+r_t^{\ast}.
$$

The paper's compact New Keynesian Phillips curve is:

$$(F29)\qquad
\pi_{H,t}=\beta E_t(\pi_{H,t+1})+\kappa_\omega(x_t+x_t^{\ast})+r_t,\quad
\pi_{F,t}^{\ast}=\beta E_t(\pi_{F,t+1}^{\ast})+\kappa_\omega(x_t^{\ast}+x_t)+r_t^{\ast}.
$$

`needs_review`: the MMB `.mod` implements the domestic and foreign PPI equations with separate coefficients on $x_t$ and $x_t^{\ast}$, consistent with combining (F22) and (F28), rather than the single $\kappa_\omega(x_t+x_t^{\ast})$ coefficient written in the OCR source.

## 4. Market Clearing & Identities

Goods market clearing for each country's differentiated goods:

$$(F30)\qquad
Y_t(h)=C_t(h)+C_t^{\ast}(h),\quad Y_t^{\ast}(f)=C_t(f)+C_t^{\ast}(f).
$$

Aggregate demand after substitution and log-linearization:

$$(F31)\qquad
y_t=c_t+\frac{\alpha[2(1-\alpha)(\sigma\eta-1)+1]}{\sigma}s_t,\quad
y_t^{\ast}=c_t^{\ast}-\frac{\alpha[2(1-\alpha)(\sigma\eta-1)+1]}{\sigma}s_t.
$$

CPI inflation and PPI inflation:

$$(F32)\qquad
\pi_t=\pi_{H,t}+\alpha(s_t-s_{t-1}),\quad
\pi_t^{\ast}=\pi_{F,t}^{\ast}-\alpha(s_t-s_{t-1}).
$$

Complete-markets UIP:

$$(F33)\qquad
r_t-r_t^{\ast}=E_t(e_{t+1})-e_t.
$$

International risk sharing:

$$(F34)\qquad
C_t=\vartheta C_t^{\ast}Q_t^{1/\sigma}.
$$

Real exchange rate and terms of trade:

$$(F35)\qquad
q_t=(1-2\alpha)s_t.
$$

Log-linear risk sharing:

$$(F36)\qquad
c_t=c_t^{\ast}+\frac{1-2\alpha}{\sigma}s_t.
$$

Terms of trade in output:

$$(F37)\qquad
s_t=\frac{\sigma}{\omega_4+1}(y_t-y_t^{\ast}).
$$

Output level identities:

$$(F38)\qquad
y_t=x_t+\bar y_t,\quad y_t^{\ast}=x_t^{\ast}+\bar y_t^{\ast}.
$$

Domestic and foreign CPI inflation identities used in the MMB implementation:

$$(F39)\qquad
\pi_t=\pi_{H,t}+\frac{\alpha\sigma}{\omega_4+1}(x_t-x_{t-1})
-\frac{\alpha\sigma}{\omega_4+1}(x_t^{\ast}-x_{t-1}^{\ast})
+\Omega_2(a_t-a_{t-1})-\Omega_2(a_t^{\ast}-a_{t-1}^{\ast}).
$$

$$(F40)\qquad
\pi_t^{\ast}=\pi_{F,t}^{\ast}+\frac{\alpha\sigma}{\omega_4+1}(x_t^{\ast}-x_{t-1}^{\ast})
-\frac{\alpha\sigma}{\omega_4+1}(x_t-x_{t-1})
+\Omega_2(a_t^{\ast}-a_{t-1}^{\ast})-\Omega_2(a_t-a_{t-1}).
$$

`needs_review`: MinerU OCR for the source equation equivalent to (F39)-(F40) displays an extra $r_t$ and $r_t^{\ast}$ term in the CPI-inflation formulas. The appendix Dynare code and MMB implementation omit those terms.

Price, nominal exchange rate, real exchange rate, and terms-of-trade identities:

$$(F41)\qquad
p_t=p_{t-1}+\pi_t,\quad p_t^{\ast}=p_{t-1}^{\ast}+\pi_t^{\ast}.
$$

$$(F42)\qquad
e_t=q_t-p_t^{\ast}+p_t.
$$

## 5. Exogenous Processes

Taylor rules with interest-rate smoothing:

$$(F43)\qquad
r_t=\varrho r_{t-1}+(1-\varrho)(\phi_\pi\pi_t+\phi_xx_t)+m_t.
$$

$$(F44)\qquad
r_t^{\ast}=\varrho^{\ast} r_{t-1}^{\ast}+(1-\varrho^{\ast})(\phi_\pi^{\ast}\pi_t^{\ast}+\phi_x^{\ast}x_t^{\ast})+m_t^{\ast}.
$$

Productivity processes:

$$(F45)\qquad
a_t=\rho a_{t-1}+\xi_t,\quad a_t^{\ast}=\rho^{\ast}a_{t-1}^{\ast}+\xi_t^{\ast}.
$$

The MMB simulation for `NK_JO15_lt` shocks the foreign productivity innovation $\xi_t^{\ast}$ with stderr 1. Monetary policy innovations $m_t,m_t^{\ast}$ and domestic productivity innovation $\xi_t$ are declared but not shocked in the checked implementation example.

## 6. Steady-State Solution

Because the model is log-linear, the deterministic steady state used in the `model(linear)` block is zero for all deviation variables:

$$(F46)\qquad
x=\pi_H=r=\pi=x^{\ast}=\pi_F^{\ast}=r^{\ast}=\pi^{\ast}=\bar r=\bar r^{\ast}=a=a^{\ast}=mc=mc^{\ast}=y=y^{\ast}=\bar y=\bar y^{\ast}=p=p^{\ast}=e=s=q=0.
$$

The paper's level steady-state restrictions are:

$$(F47)\qquad
R=R^{\ast}=\beta^{-1},\quad MC_H=MC_F^{\ast}=\frac{\varepsilon-1}{\varepsilon}.
$$

$$(F48)\qquad
C=C^{\ast},\quad Q=1,\quad S=1,\quad Y=C=Y^{\ast}=C^{\ast}.
$$

Calibration for the low-trade MMB variant:

$$(F49)\qquad
\alpha=0.1,\quad \beta=0.99,\quad \sigma=4.5,\quad \eta=2.5,\quad
\theta_H=0.9,\quad \theta_F=0.75,\quad \varphi=3.
$$

$$(F50)\qquad
\rho=\rho^{\ast}=0.55,\quad \phi_\pi=\phi_\pi^{\ast}=1.5,\quad
\phi_x=\phi_x^{\ast}=0.5,\quad \varrho=\varrho^{\ast}=0.4.
$$

Derived coefficients in the implementation:

$$(F51)\qquad
\omega_2=2\alpha(1-\alpha)(\sigma\eta-1),\quad
\omega_4=4\alpha(1-\alpha)(\sigma\eta-1),\quad
\psi=(\omega_4+1)(1+\varphi).
$$

$$(F52)\qquad
\varsigma=(\omega_2+1)\sigma+(\omega_4+1)\varphi,
\quad
\delta=\sigma^2(2\omega_2+1)+2\sigma\varphi(\omega_2+1)(\omega_4+1)+\varphi^2(\omega_4+1)^2.
$$

$$(F53)\qquad
\sigma_\omega=\frac{(\omega_2+1)\sigma}{\omega_4+1},\quad
\Omega_2=\frac{\alpha\sigma(1+\varphi)(\varsigma+\omega_2\sigma)}{\delta}.
$$

## 7. Timing & Form Conventions

- The model is linear and first-order in deviations; all state/control variables are centered at zero steady state in the Dynare `model(linear)` representation.
- There is no capital stock in this model. Stock-timing concerns are limited to predetermined nominal interest rates and price levels: $r_{t-1}$ and $r_{t-1}^{\ast}$ enter Taylor rules; $p_{t-1}$ and $p_{t-1}^{\ast}$ enter price-level accumulation; lagged output gaps and lagged productivity enter CPI inflation identities.
- Expectations are one period ahead in the IS curves and Phillips curves.
- The cost channel enters marginal cost through the nominal interest rate and propagates into Phillips-curve dynamics.
- Foreign variables carry a star in the paper and `_star` in Dynare-safe names.
- The low-trade variant is identified by $\alpha=0.1$; the same paper also contains no-trade, intermediate-trade, and high-trade simulations.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII name | Meaning | Main equation(s) |
|---|---|---|---|
| Endogenous | $x_t$ / `x` | domestic output gap | (F23), (F25), (F43) |
| Endogenous | $\pi_{H,t}$ / `pi_H` | domestic PPI inflation | (F22), (F29) |
| Endogenous | $r_t$ / `r` | domestic nominal interest-rate deviation | (F43) |
| Endogenous | $\pi_t$ / `pi` | domestic CPI inflation | (F32), (F39) |
| Endogenous | $x_t^{\ast}$ / `x_star` | foreign output gap | (F23), (F26), (F44) |
| Endogenous | $\pi_{F,t}^{\ast}$ / `pi_F_star` | foreign PPI inflation | (F22), (F29) |
| Endogenous | $r_t^{\ast}$ / `r_star` | foreign nominal interest-rate deviation | (F44) |
| Endogenous | $\pi_t^{\ast}$ / `pi_star` | foreign CPI inflation | (F32), (F40) |
| Endogenous | $\bar r_t$ / `r_bar` | domestic natural real interest rate | (F27) |
| Endogenous | $\bar r_t^{\ast}$ / `r_bar_star` | foreign natural real interest rate | (F27) |
| Endogenous | $a_t$ / `a` | domestic productivity deviation | (F45) |
| Endogenous | $a_t^{\ast}$ / `a_star` | foreign productivity deviation | (F45) |
| Endogenous | $mc_{H,t}$ / `mc` | domestic real marginal cost | (F28) |
| Endogenous | $mc_{F,t}^{\ast}$ / `mc_star` | foreign real marginal cost | (F28) |
| Endogenous | $y_t$ / `y` | domestic output deviation | (F38) |
| Endogenous | $y_t^{\ast}$ / `y_star` | foreign output deviation | (F38) |
| Endogenous | $\bar y_t$ / `y_bar` | domestic natural output | (F24) |
| Endogenous | $\bar y_t^{\ast}$ / `y_bar_star` | foreign natural output | (F24) |
| Endogenous | $p_t$ / `p` | domestic price level | (F41) |
| Endogenous | $p_t^{\ast}$ / `p_star` | foreign price level | (F41) |
| Endogenous | $e_t$ / `e` | nominal exchange rate | (F42) |
| Endogenous | $s_t$ / `s` | terms of trade | (F35), (F37) |
| Endogenous | $q_t$ / `q` | real exchange rate | (F35), (F42) |
| Exogenous | $m_t$ / `m` | domestic monetary policy innovation | (F43) |
| Exogenous | $m_t^{\ast}$ / `m_star` | foreign monetary policy innovation | (F44) |
| Exogenous | $\xi_t$ / `xi` | domestic productivity innovation | (F45) |
| Exogenous | $\xi_t^{\ast}$ / `xi_star` | foreign productivity innovation | (F45) |
| Parameter | $\sigma$ / `sigma` | coefficient of relative risk aversion | (F1), (F21) |
| Parameter | $\eta$ / `eta` | elasticity between home and foreign goods | (F2), (F3) |
| Parameter | $\beta$ / `beta` | discount factor | (F1), (F19), (F47) |
| Parameter | $\theta_H,\theta_F$ / `theta_H`, `theta_F` | Calvo price-stickiness probabilities | (F16), (F17), (F22) |
| Parameter | $\alpha$ / `alpha` | trade openness; low-trade value 0.1 | (F2), (F8), (F49) |
| Parameter | $\varphi$ / `varphi` | inverse Frisch/labor curvature | (F1), (F20) |
| Parameter | $\kappa_H,\kappa_F$ / `kappa_H`, `kappa_F` | Phillips-curve slopes | (F22) |
| Parameter | $\omega_2,\omega_4$ / `omega_2`, `omega_4` | openness composites | (F51) |
| Parameter | $\psi,\varsigma,\delta,\sigma_\omega,\Omega_2$ / `psi`, `varsigma`, `delta`, `sigma_omega`, `oomega_2` | derived composites | (F51)-(F53) |
| Parameter | $\rho,\rho^{\ast}$ / `rho`, `rho_star` | productivity persistence | (F45), (F50) |
| Parameter | $\phi_\pi,\phi_\pi^{\ast},\phi_x,\phi_x^{\ast}$ / `phi_pi`, `phi_pi_star`, `phi_x`, `phi_x_star` | Taylor-rule responses | (F43), (F44) |
| Parameter | $\varrho,\varrho^{\ast}$ / `varrho`, `varrho_star` | interest-rate smoothing | (F43), (F44) |
