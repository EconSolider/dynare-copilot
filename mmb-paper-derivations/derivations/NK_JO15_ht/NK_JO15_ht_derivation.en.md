# NK_JO15_ht - Derivation (Optimization Problems + First-Order Conditions)

> Model archive draft for `NK_JO15_ht`. Runtime validation was not performed. Formula extraction is based on the MinerU Markdown source and is marked `needs_review` where OCR or paper-code differences affect exact transcription.

## 1. Model Overview

- **Model**: `NK_JO15_ht`, the high-trade calibration of Jang and Okano (2015), "Productivity Shocks and Monetary Policy in a Two-Country Model".
- **Source and provenance**: primary Markdown `raw/mmb_mineru/runs/nk_jo15_ht_nk_jo15_lt__productivity_shocks_and_monetary_policy_in_a_two_country_model__f031feec/full.md`; raw PDF `raw/mmb_papers/Productivity Shocks and Monetary Policy in a Two-Country Model.pdf`; MinerU run id `f031feec-a81e-43ec-ac7a-f89bd2d73785`; DOI `10.1016/j.jpolmod.2015.03.017`.
- **Variant**: high level of trade, with trade openness `\alpha=0.9` in the MMB implementation. The paper studies multiple trade-openness cases `\alpha \in \{0,0.1,0.6,0.9\}`; this entry records the high-trade case.
- **Agents**: representative households in countries H and F; monopolistically competitive differentiated-goods firms with Calvo-Yun price setting and a Ravenna-Walsh cost channel; national monetary authorities following Taylor rules.
- **Model form**: log-linear `model(linear)` system around a deterministic steady state. Lowercase variables are percentage deviations or log deviations from steady state, except interest-rate variables written as deviations of gross nominal rates.
- **Core mechanism**: foreign productivity affects natural output, terms of trade, CPI/PPI inflation, real exchange rates, and monetary policy through international risk sharing and the cost channel.
- **Status**: `needs_review`; paper-side Markdown is usable, but several OCR equations in Appendix C and the embedded Dynare listing contain spacing/subscript damage.

## 2. Optimization Problems

### 2.1 Households

Households in both countries maximize expected lifetime utility:

**(F1) Household objectives**
$$
\mathcal{U}=E_0\sum_{t=0}^{\infty}\beta^t
\left[\frac{C_t^{1-\sigma}}{1-\sigma}-\frac{N_t^{1+\varphi}}{1+\varphi}\right],
\qquad
\mathcal{U}^{*}=E_0\sum_{t=0}^{\infty}\beta^t
\left[\frac{(C_t^{*})^{1-\sigma}}{1-\sigma}-\frac{(N_t^{*})^{1+\varphi}}{1+\varphi}\right].
$$

**(F2) Home and foreign consumption aggregators**
$$
C_t=\left[(1-\alpha)^{1/\eta}C_{H,t}^{(\eta-1)/\eta}
+\alpha^{1/\eta}C_{F,t}^{(\eta-1)/\eta}\right]^{\eta/(\eta-1)},
$$
$$
C_t^{*}=\left[(1-\alpha)^{1/\eta}(C_{F,t}^{*})^{(\eta-1)/\eta}
+\alpha^{1/\eta}(C_{H,t}^{*})^{(\eta-1)/\eta}\right]^{\eta/(\eta-1)}.
$$

**(F3) Household nominal budget constraints**
$$
P_t C_t+E_t(Q_{t,t+1}D_{t+1}^{n})\le D_t^n+W_tN_t+TR_t,
$$
$$
P_t^{*}C_t^{*}+E_t(Q_{t,t+1}^{*}D_{t+1}^{n*})\le D_t^{n*}+W_t^{*}N_t^{*}+TR_t^{*}.
$$

### 2.2 Goods Demand And Price Indices

**(F4) Within-origin differentiated-goods demand**
$$
C_t(h)=\left(\frac{P_t(h)}{P_{H,t}}\right)^{-\varepsilon}C_{H,t},
\quad
C_t(f)=\left(\frac{P_t(f)}{P_{F,t}}\right)^{-\varepsilon}C_{F,t},
$$
$$
C_t^{*}(h)=\left(\frac{P_t^{*}(h)}{P_{H,t}^{*}}\right)^{-\varepsilon}C_{H,t}^{*},
\quad
C_t^{*}(f)=\left(\frac{P_t^{*}(f)}{P_{F,t}^{*}}\right)^{-\varepsilon}C_{F,t}^{*}.
$$

**(F5) Home/foreign-good allocation**
$$
C_{H,t}=(1-\alpha)\left(\frac{P_{H,t}}{P_t}\right)^{-\eta}C_t,
\quad
C_{F,t}=\alpha\left(\frac{P_{F,t}}{P_t}\right)^{-\eta}C_t,
$$
$$
C_{H,t}^{*}=\alpha\left(\frac{P_{H,t}^{*}}{P_t^{*}}\right)^{-\eta}C_t^{*},
\quad
C_{F,t}^{*}=(1-\alpha)\left(\frac{P_{F,t}^{*}}{P_t^{*}}\right)^{-\eta}C_t^{*}.
$$

**(F6) CPI indices**
$$
P_t=\left[(1-\alpha)P_{H,t}^{1-\eta}+\alpha P_{F,t}^{1-\eta}\right]^{1/(1-\eta)},
$$
$$
P_t^{*}=\left[(1-\alpha)(P_{F,t}^{*})^{1-\eta}+\alpha(P_{H,t}^{*})^{1-\eta}\right]^{1/(1-\eta)}.
$$

### 2.3 Firms

A typical firm in each country produces differentiated output with linear labor technology:

**(F7) Firm production technologies**
$$
Y_t(h)=A_tN_t(h),
\qquad
Y_t^{*}(f)=A_t^{*}N_t^{*}(f).
$$

Calvo-Yun price setters maximize the expected discounted value of profits when they are allowed to reset prices. The source gives the optimal reset prices directly:

**(F8) Calvo reset-price optimality, needs_review**
$$
\widetilde{P}_{H,t}
=E_t\left[
\frac{\sum_{k=0}^{\infty}\theta^k Q_{t,t+k}Y_{t+k}
\frac{\varepsilon}{\varepsilon-1}P_{H,t+k}MC_{H,t+k}}
{\sum_{k=0}^{\infty}\theta^k Q_{t,t+k}Y_{t+k}}
\right],
$$
$$
\widetilde{P}_{F,t}^{*}
=E_t\left[
\frac{\sum_{k=0}^{\infty}\theta^k Q_{t,t+k}^{*}Y_{F,t+k}
\frac{\varepsilon}{\varepsilon-1}P_{F,t+k}^{*}MC_{F,t+k}^{*}}
{\sum_{k=0}^{\infty}\theta^k Q_{t,t+k}^{*}Y_{F,t+k}}
\right].
$$

The `needs_review` marker reflects OCR ambiguity around the foreign output term and the paper's overloaded use of `Q` for the stochastic discount factor and real exchange rate.

## 3. First-Order Conditions

**(F9) Intertemporal Euler equations**
$$
\beta E_t\left(\frac{C_{t+1}^{-\sigma}P_t}{C_t^{-\sigma}P_{t+1}}\right)=\frac{1}{R_t},
\qquad
\beta E_t\left(\frac{(C_{t+1}^{*})^{-\sigma}P_t^{*}}{(C_t^{*})^{-\sigma}P_{t+1}^{*}}\right)=\frac{1}{R_t^{*}}.
$$

**(F10) Intratemporal labor supply**
$$
C_t^{\sigma}N_t^{\varphi}=\frac{W_t}{P_t},
\qquad
(C_t^{*})^{\sigma}(N_t^{*})^{\varphi}=\frac{W_t^{*}}{P_t^{*}}.
$$

**(F11) Log-linear consumption Euler equations**
$$
c_t=E_t(c_{t+1})-\frac{1}{\sigma}\left\{\hat r_t-E_t(\pi_{t+1})\right\},
\qquad
c_t^{*}=E_t(c_{t+1}^{*})-\frac{1}{\sigma}\left\{\hat r_t^{*}-E_t(\pi_{t+1}^{*})\right\}.
$$

**(F12) Log-linear New Keynesian IS curves in output**
$$
y_t=E_t(y_{t+1})-\frac{1}{\sigma_{\omega}}\left\{\hat r_t-E_t(\pi_{H,t+1})\right\}
+\frac{\omega_2}{\omega_2+1}E_t(y_{t+1}^{*}-y_t^{*}),
$$
$$
y_t^{*}=E_t(y_{t+1}^{*})-\frac{1}{\sigma_{\omega}}\left\{\hat r_t^{*}-E_t(\pi_{F,t+1}^{*})\right\}
+\frac{\omega_2}{\omega_2+1}E_t(y_{t+1}-y_t).
$$

**(F13) Output-gap IS curves**
$$
x_t=E_t(x_{t+1})-\frac{1}{\sigma_{\omega}}\left\{\hat r_t-E_t(\pi_{H,t+1})\right\}
+\frac{\omega_2}{\omega_2+1}\left\{E_t(x_{t+1}^{*})-x_t^{*}\right\}
+\frac{1}{\sigma_{\omega}}\bar r_t,
$$
$$
x_t^{*}=E_t(x_{t+1}^{*})-\frac{1}{\sigma_{\omega}}\left\{\hat r_t^{*}-E_t(\pi_{F,t+1}^{*})\right\}
+\frac{\omega_2}{\omega_2+1}\left\{E_t(x_{t+1})-x_t\right\}
+\frac{1}{\sigma_{\omega}}\bar r_t^{*}.
$$

**(F14) Real marginal costs**
$$
mc_{H,t}=\frac{\varsigma}{\omega_4+1}x_t+\frac{\omega_2\sigma}{\omega_4+1}x_t^{*}+r_t,
\qquad
mc_{F,t}^{*}=\frac{\varsigma}{\omega_4+1}x_t^{*}+\frac{\omega_2\sigma}{\omega_4+1}x_t+r_t^{*}.
$$

**(F15) PPI Phillips curves**
$$
\pi_{H,t}=\beta E_t(\pi_{H,t+1})+\kappa_H\frac{\varsigma}{\omega_4+1}x_t
+\kappa_H\frac{\omega_2\sigma}{\omega_4+1}x_t^{*}
+\kappa_H r_t,
$$
$$
\pi_{F,t}^{*}=\beta E_t(\pi_{F,t+1}^{*})+\kappa_F\frac{\varsigma}{\omega_4+1}x_t^{*}
+\kappa_F\frac{\omega_2\sigma}{\omega_4+1}x_t
+\kappa_F r_t^{*}.
$$

The paper also reports a compact symmetric form with `\kappa_{\omega}`; the MMB implementation uses country-specific `\kappa_H` and `\kappa_F`, consistent with `\theta_H \ne \theta_F`.

## 4. Market Clearing & Identities

**(F16) Goods-market clearing**
$$
Y_t(h)=C_t(h)+C_t^{*}(h),
\qquad
Y_t^{*}(f)=C_t(f)+C_t^{*}(f).
$$

**(F17) Aggregate output and consumption**
$$
y_t=c_t+\frac{\alpha[2(1-\alpha)(\sigma\eta-1)+1]}{\sigma}s_t,
\qquad
y_t^{*}=c_t^{*}-\frac{\alpha[2(1-\alpha)(\sigma\eta-1)+1]}{\sigma}s_t.
$$

**(F18) Terms of trade and real exchange rate**
$$
s_t=\frac{\sigma}{\omega_4+1}(y_t-y_t^{*}),
\qquad
q_t=(1-2\alpha)s_t.
$$

**(F19) CPI/PPI inflation identities**
$$
\pi_t=\pi_{H,t}+\frac{\alpha\sigma}{\omega_4+1}(x_t-x_{t-1})
-\frac{\alpha\sigma}{\omega_4+1}(x_t^{*}-x_{t-1}^{*})
+\Omega_2(a_t-a_{t-1})-\Omega_2(a_t^{*}-a_{t-1}^{*}),
$$
$$
\pi_t^{*}=\pi_{F,t}^{*}+\frac{\alpha\sigma}{\omega_4+1}(x_t^{*}-x_{t-1}^{*})
-\frac{\alpha\sigma}{\omega_4+1}(x_t-x_{t-1})
+\Omega_2(a_t^{*}-a_{t-1}^{*})-\Omega_2(a_t-a_{t-1}).
$$

**(F20) Natural output and output gaps**
$$
x_t=y_t-\bar y_t,
\qquad
x_t^{*}=y_t^{*}-\bar y_t^{*},
$$
$$
\bar y_t=\frac{\varsigma\psi}{\delta}a_t-\frac{\omega_2\sigma\psi}{\delta}a_t^{*},
\qquad
\bar y_t^{*}=\frac{\varsigma\psi}{\delta}a_t^{*}-\frac{\omega_2\sigma\psi}{\delta}a_t.
$$

**(F21) Natural real interest rates**
$$
\bar r_t=-\Theta a_t-\Omega_1 a_t^{*},
\qquad
\bar r_t^{*}=-\Theta a_t^{*}-\Omega_1 a_t.
$$

**(F22) Price-level and exchange-rate accounting**
$$
p_t=p_{t-1}+\pi_t,
\qquad
p_t^{*}=p_{t-1}^{*}+\pi_t^{*},
\qquad
e_t=q_t-p_t^{*}+p_t.
$$

## 5. Exogenous Processes

**(F23) Productivity processes**
$$
a_t=\rho a_{t-1}+\xi_t,
\qquad
a_t^{*}=\rho^{*}a_{t-1}^{*}+\xi_t^{*}.
$$

**(F24) Monetary policy rules**
$$
\hat r_t=\varrho \hat r_{t-1}+(1-\varrho)(\phi_{\pi}\pi_t+\phi_x x_t)+m_t,
$$
$$
\hat r_t^{*}=\varrho^{*}\hat r_{t-1}^{*}+(1-\varrho^{*})(\phi_{\pi}^{*}\pi_t^{*}+\phi_x^{*}x_t^{*})+m_t^{*}.
$$

The MMB high-trade simulation shocks `\xi_t^{*}` and sets monetary policy innovations to zero in the reported foreign-productivity experiment.

## 6. Steady-State Solution

The deterministic steady state in the paper sets producer inflation rates to one, productivity levels to one, and all log-deviation variables to zero:

$$
\Pi_H=\Pi_F=1,
\qquad
A_H=A_N=A_F=A_N^{*}=1.
$$

Gross nominal interest rates satisfy:

$$
R=R^{*}=\beta^{-1}.
$$

Firm FONCs imply steady-state marginal cost:

$$
MC_H=MC_F=\frac{\varepsilon-1}{\varepsilon}.
$$

With `\vartheta=1`, the risk-sharing condition gives:

$$
C=C^{*},
\qquad
Q=1.
$$

PPP holds in this deterministic steady state, the two price levels are equal, and terms of trade are constant:

$$
P_H=P_F,
\qquad
S=1.
$$

Market clearing implies:

$$
Y=C=Y^{*}=C^{*}.
$$

For the log-linear MMB implementation, the operational steady state is zero for endogenous state/control variables:

$$
x=\pi_H=r=\pi=x^{*}=\pi_F^{*}=r^{*}=\pi^{*}=\bar r=\bar r^{*}=a=a^{*}=mc=mc^{*}=y=y^{*}=\bar y=\bar y^{*}=p=p^{*}=e=s=q=0.
$$

## 7. Timing & Form Conventions

- **Linearization**: `model(linear)`; variables in the implementation are stationary deviations from steady state.
- **Expectations**: forward-looking variables use `E_t(\cdot)` in the derivation and `(+1)` in the implementation.
- **Stock variables**: the paper model has no capital stock or bond stock state in the reduced-form model. Predetermined states are lagged interest rates, lagged price levels, lagged output gaps in CPI identities, and AR(1) productivity states.
- **Trade openness**: `NK_JO15_ht` fixes `\alpha=0.9`; the low-trade paired entry would use the same equations with `\alpha=0.1`.
- **Inflation conventions**: `\pi_H` and `\pi_F^{*}` are PPI inflation rates; `\pi` and `\pi^{*}` are CPI inflation rates. The MMB `.mod` names `pi_F_star` for foreign PPI inflation and `pi_star` for foreign CPI inflation.
- **Runtime validation**: not performed for this archive entry.

## 8. Variable & Parameter Reference Table

### Endogenous Variables

| ASCII name | Mathematical symbol | Meaning | Main equation(s) |
|---|---:|---|---|
| `x` | $x_t$ | home output gap | (F13), (F20) |
| `pi_H` | $\pi_{H,t}$ | home PPI inflation | (F15) |
| `r` | $\hat r_t$ | home nominal interest-rate deviation | (F24) |
| `pi` | $\pi_t$ | home CPI inflation | (F19) |
| `x_star` | $x_t^{*}$ | foreign output gap | (F13), (F20) |
| `pi_F_star` | $\pi_{F,t}^{*}$ | foreign PPI inflation | (F15) |
| `r_star` | $\hat r_t^{*}$ | foreign nominal interest-rate deviation | (F24) |
| `pi_star` | $\pi_t^{*}$ | foreign CPI inflation | (F19) |
| `r_bar` | $\bar r_t$ | home natural real interest rate | (F21) |
| `r_bar_star` | $\bar r_t^{*}$ | foreign natural real interest rate | (F21) |
| `a` | $a_t$ | home productivity deviation | (F23) |
| `a_star` | $a_t^{*}$ | foreign productivity deviation | (F23) |
| `mc` | $mc_{H,t}$ | home real marginal cost | (F14) |
| `mc_star` | $mc_{F,t}^{*}$ | foreign real marginal cost | (F14) |
| `y` | $y_t$ | home output deviation | (F17), (F20) |
| `y_star` | $y_t^{*}$ | foreign output deviation | (F17), (F20) |
| `y_bar` | $\bar y_t$ | home natural output | (F20) |
| `y_bar_star` | $\bar y_t^{*}$ | foreign natural output | (F20) |
| `p` | $p_t$ | home CPI price level deviation | (F22) |
| `p_star` | $p_t^{*}$ | foreign CPI price level deviation | (F22) |
| `e` | $e_t$ | nominal exchange-rate log deviation | (F22) |
| `s` | $s_t$ | terms of trade | (F18) |
| `q` | $q_t$ | real exchange rate | (F18) |

### Exogenous Shocks

| ASCII name | Mathematical symbol | Meaning |
|---|---:|---|
| `m` | $m_t$ | home monetary policy innovation |
| `m_star` | $m_t^{*}$ | foreign monetary policy innovation |
| `xi` | $\xi_t$ | home productivity innovation |
| `xi_star` | $\xi_t^{*}$ | foreign productivity innovation |

### Parameters

| ASCII name | Symbol | Meaning | High-trade value or definition |
|---|---:|---|---|
| `sigma` | $\sigma$ | relative risk aversion | 4.5 |
| `eta` | $\eta$ | home/foreign goods substitution elasticity | 2.5 |
| `beta` | $\beta$ | discount factor | 0.99 |
| `theta_H` | $\theta_H$ | home Calvo non-reset probability | 0.9 |
| `theta_F` | $\theta_F$ | foreign Calvo non-reset probability | 0.75 |
| `alpha` | $\alpha$ | trade openness | 0.9 |
| `varphi` | $\varphi$ | inverse Frisch/labor disutility curvature | 3 |
| `kappa_H` | $\kappa_H$ | home Phillips slope primitive | $(1-\theta_H)(1-\theta_H\beta)/\theta_H$ |
| `kappa_F` | $\kappa_F$ | foreign Phillips slope primitive | $(1-\theta_F)(1-\theta_F\beta)/\theta_F$ |
| `omega_2` | $\omega_2$ | trade composite | $2\alpha(1-\alpha)(\sigma\eta-1)$ |
| `omega_4` | $\omega_4$ | trade composite | $4\alpha(1-\alpha)(\sigma\eta-1)$ |
| `psi` | $\psi$ | natural-output composite | $(\omega_4+1)(1+\varphi)$ |
| `varsigma` | $\varsigma$ | marginal-cost composite | $(\omega_2+1)\sigma+(\omega_4+1)\varphi$ |
| `delta` | $\delta$ | natural-output denominator | $\sigma^2(2\omega_2+1)+2\sigma\varphi(\omega_2+1)(\omega_4+1)+(\omega_4+1)^2\varphi^2$ |
| `sigma_omega` | $\sigma_{\omega}$ | open-economy IS elasticity composite | $(\omega_2+1)\sigma/(\omega_4+1)$ |
| `oomega_2` | $\Omega_2$ | CPI inflation/productivity composite | $\alpha\sigma(1+\varphi)(\varsigma+\omega_2\sigma)/\delta$ |
| `rho` | $\rho$ | home productivity persistence | 0.55 in implementation cross-check |
| `rho_star` | $\rho^{*}$ | foreign productivity persistence | 0.55 |
| `phi_pi` | $\phi_{\pi}$ | home inflation response | 1.5 |
| `phi_pi_star` | $\phi_{\pi}^{*}$ | foreign inflation response | 1.5 |
| `phi_x` | $\phi_x$ | home output-gap response | 0.5 |
| `phi_x_star` | $\phi_x^{*}$ | foreign output-gap response | 0.5 |
| `varrho` | $\varrho$ | home interest-rate smoothing | 0.4 |
| `varrho_star` | $\varrho^{*}$ | foreign interest-rate smoothing | 0.4 |
