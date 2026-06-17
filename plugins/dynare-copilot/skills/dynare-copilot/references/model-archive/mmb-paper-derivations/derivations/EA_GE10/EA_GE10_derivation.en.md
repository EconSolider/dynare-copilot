# EA_GE10 -- Derivation (optimization problems + first-order conditions)

> First-pass archive status: `needs_review`. This entry is based on the MinerU Markdown extraction, with the Rep-MMB `.mod` file used only as an `implementation_cross_check`.

## 1. Model Overview

- **Model ID**: `EA_GE10`.
- **Paper**: Paolo Gelain (2010), "The external finance premium in the euro area: A dynamic stochastic general equilibrium analysis", DOI `10.1016/j.najef.2009.11.004`.
- **Source**: `raw/mmb_mineru/runs/ea_ge10__the_external_finance_premium_in_the_euro_area_a_dynamic_stochastic_gener__718b56bc/full.md`; raw PDF recorded for provenance but not read by default.
- **Purpose**: estimated Euro-area New Keynesian DSGE model with a BGG-style financial accelerator, used to construct and analyze the unobserved external finance premium.
- **Agents and blocks**: households with habit, monopolistic labor supply and Calvo wage setting; retailers/intermediate firms with Calvo price setting; entrepreneurs with capital demand, utilization, net worth, and optimal financial contracts; capital producers with investment adjustment costs; monetary authority; exogenous fiscal authority.
- **Model form**: log-linear paper-side presentation. Hatted variables are percentage or log deviations from steady state. The Rep-MMB implementation cross-check uses `model;` equations that are already linearized in deviations.
- **Runtime validation**: not performed.

## 2. Optimization Problems

### 2.1 Households

Household `i` chooses consumption, labor, and bank deposits subject to an intertemporal budget constraint. The paper reports the resulting log-linear Euler equation rather than the full nonlinear Lagrangian. Utility has external habit with parameter `h`, consumption curvature `\sigma_c`, and labor curvature `\sigma_l`.

### 2.2 Wage setters

Each household supplies a differentiated labor service. A labor aggregator converts differentiated services into homogeneous labor input. With Calvo wage rigidity, only a fraction `1-\xi_w` can re-optimize each period; non-reoptimizing wages are indexed to past CPI inflation with indexation parameter `\tau_w`.

### 2.3 Final-good retailers and intermediate producers

Retailers aggregate differentiated intermediate goods with Dixit-Stiglitz elasticity `\theta`. Intermediate producers face Calvo price rigidity: only a fraction `1-\xi_\pi` can reset prices each period, while other prices are indexed to past inflation with parameter `\tau_\pi`.

### 2.4 Capital producers

Capital producers buy final goods and transform them into investment goods sold to entrepreneurs. Production of investment goods is subject to investment adjustment costs `S(I_t/I_{t-1})` and an investment-specific shock `x_t`, with `S(1)=S'(1)=0` and `S''(1)>0`.

### 2.5 Entrepreneurs and financial contract

Entrepreneurs produce wholesale/intermediate goods, rent labor, use capital, choose utilization, and borrow from intermediaries to finance capital purchases beyond net worth. The optimal contract follows the BGG costly-state-verification setup: the aggregate external finance premium depends negatively on entrepreneurial net worth relative to the value of capital.

## 3. First-Order Conditions

**(F1) Household Euler equation with habit and preference shock**:

$$
\hat c_t =
\frac{h}{1+h}\hat c_{t-1}
+ \frac{1}{1+h}E_t\hat c_{t+1}
- \frac{1-h}{\sigma_c(1+h)}\hat r_t
+ \frac{1-h}{\sigma_c(1+h)}\hat\varepsilon^\beta_t .
$$

**(F2) Real interest rate definition**:

$$
\hat r_t = \hat r^n_t - E_t \pi^c_{t+1}.
$$

**(F3) Calvo wage equation**:

$$
\begin{aligned}
\hat w_t ={}&
\frac{\beta}{1+\beta}E_t\hat w_{t+1}
+ \frac{1}{1+\beta}\hat w_{t-1}
+ \frac{\beta}{1+\beta}E_t\pi^c_{t+1}
- \frac{1+\beta\tau_w}{1+\beta}\pi^c_t
+ \frac{\tau_w}{1+\beta}\pi^c_{t-1} \\
&- \frac{1}{1+\beta}
\frac{(1-\beta\xi_w)(1-\xi_w)}
{\left[1+((1+\lambda_w)\sigma_l/\lambda_w)\right]\xi_w}
\left[
\hat w_t-\sigma_l\hat l_t-\frac{\sigma_c}{1-h}(\hat c_t-h\hat c_{t-1})+\hat\varepsilon^L_t
\right]
+ u^w_t .
\end{aligned}
$$

**(F4) Investment dynamics from capital-producer optimality**:

$$
\hat I_t =
\frac{1}{1+\beta}\hat I_{t-1}
+ \frac{\beta}{1+\beta}E_t\hat I_{t+1}
+ \frac{1}{\varphi(1+\beta)}\hat q_t
+ \hat x_t .
$$

**(F5) Capital accumulation**:

$$
\hat k_t = \delta(\hat I_t+\varphi\hat x_t)+(1-\delta)\hat k_{t-1}.
$$

**(F6) Production function with fixed cost and utilization**:

$$
\hat y_t =
(1+\phi)\left[
\hat a_t+\alpha\hat k_{t-1}+\alpha\psi\hat r e^k_t+(1-\alpha)\hat l_t
\right].
$$

**(F7) Real marginal cost from cost minimization**:

$$
\widehat{mc}_t = \alpha\widehat{r e}^k_t+(1-\alpha)\hat w_t-\hat a_t .
$$

**(F8) Factor-demand condition for the marginal product of capital**:

$$
(1+\psi)\widehat{r e}^k_t = \hat l_t+\hat w_t-\hat k_{t-1}.
$$

**(F9) Capital-utilization condition**:

$$
\widehat{r e}^k_t = \psi z_t .
$$

**(F10) Ex-post aggregate return on capital**:

$$
\hat r^k_{t+1} =
\frac{R e^k}{R^k}\widehat{r e}^k_{t+1}
+ \frac{1-\delta}{R^k}\hat q_{t+1}
- \hat q_t .
$$

**(F11) External finance premium / financial accelerator relation**:

$$
\hat s_t =
-\varkappa\left(\widehat{nw}_{t+1}-\hat q_t-\hat k_{t+1}\right),
\qquad
\hat s_t \equiv E_t\hat r^k_{t+1}-\hat r_t .
$$

**(F12) Entrepreneurial net worth**:

$$
\widehat{nw}_{t+1} =
\vartheta^e\left[
\frac{K}{NW}R^n(S\hat r^k_t-\hat r_t)
+ \frac{K}{NW}R^n(S-1)(\hat q_{t-1}+\hat k_t)
+ R^n(\hat r_t+\widehat{nw}_t)
\right].
$$

**(F13) New Keynesian Phillips curve with price indexation**:

$$
\pi^c_t =
\frac{\beta}{1+\beta\tau_\pi}E_t\pi^c_{t+1}
+ \frac{\tau_\pi}{1+\beta\tau_\pi}\pi^c_{t-1}
+ \frac{1}{1+\beta\tau_\pi}
\frac{(1-\beta\xi_\pi)(1-\xi_\pi)}{\xi_\pi}\widehat{mc}_t
+ u^{\lambda^\pi}_t .
$$

## 4. Market Clearing & Identities

**(F14) Dixit-Stiglitz demand for differentiated goods**:

$$
y_t(j)=\left(\frac{P^c_t}{P_t(j)}\right)^{-\theta}Y_t .
$$

**(F15) Aggregate resource constraint**:

$$
\hat y_t =
\frac{C}{Y}\hat c_t
+ \frac{I}{Y}\hat I_t
+ \frac{G}{Y}\hat g_t
+ \frac{K}{Y}\psi R e^k \widehat{r e}^k_t
+ \frac{K}{Y}S\left(1-\frac{NW}{K}\right)(\hat r^k_t+\hat q_{t-1}+\hat k_t).
$$

**(F16) Government budget/equilibrium condition**:

$$
G_t=T_t .
$$

**(F17) Monetary policy rule**:

$$
\begin{aligned}
\hat r^n_t ={}&
\phi_m\hat r^n_{t-1}
+(1-\phi_m)\left[
r_\pi\pi_{t-1}+r_y(\hat y_{t-1}-\hat y^*_{t-1})
\right] \\
&+ r_{\Delta\pi}(\pi_t-\pi_{t-1})
+ r_{\Delta y}\left[
\hat y_t-\hat y^*_t-(\hat y_{t-1}-\hat y^*_{t-1})
\right]
+ u^{ru}_t .
\end{aligned}
$$

## 5. Exogenous Processes

**(F18) Preference shock**:

$$
\hat\varepsilon^\beta_t=\rho_\beta\hat\varepsilon^\beta_{t-1}+u^\beta_t .
$$

**(F19) Labor-supply shock**:

$$
\hat\varepsilon^L_t=\rho_L\hat\varepsilon^L_{t-1}+u^L_t .
$$

**(F20) Investment-specific shock**:

$$
\hat x_t=\rho_x\hat x_{t-1}+u^x_t .
$$

**(F21) Technology shock**:

$$
\hat a_t=\rho_a\hat a_{t-1}+u^a_t .
$$

**(F22) Government-spending shock**:

$$
\hat g_t=\rho_g\hat g_{t-1}+u^g_t .
$$

**(F23) Monetary-policy shock**:

$$
u^{ru}_t \sim N(0,\sigma_{ru}^2).
$$

**(F24) Wage-markup shock**:

$$
u^w_t\sim N(0,\sigma_w^2).
$$

**(F25) Price-markup shock**:

$$
u^{\lambda^\pi}_t\sim N(0,\sigma_{\lambda^\pi}^2).
$$

## 6. Steady-State Solution

The paper gives Appendix A steady-state relationships. Because the model is presented in log-linear deviations, steady-state deviations are zero. The following levels define the expansion point and calibration targets.

1. Finance and capital returns:
   $R^k=SR^n$, $R^k=R e^k+1-\delta$, $R^n=1/\beta$, and therefore $R e^k=S/\beta-1+\delta$.
2. Price markup and marginal cost:
   $MC=(\theta-1)/\theta$.
3. Wage from marginal cost:
   $W=\left[MC(1-\alpha)^{1-\alpha}\alpha^\alpha/(R e^k)^\alpha\right]^{1/(1-\alpha)}$.
4. Factor ratios:
   $R e^k=\alpha MC\,Y/K$, $W=(1-\alpha)MC\,Y/L$, and $L/K=((1-\alpha)/\alpha)(R e^k/W)$.
5. Fixed cost and output:
   with steady profits zero, $F=(\lambda_d-1)Y$ and $Y=(1/(1+F/Y))(K/L)^\alpha L$.
6. Capital-output and investment-output:
   $K/Y=(L/K)^{\alpha-1}(1+F/Y)$ and $I/Y=\delta K/Y$.
7. Resource allocation:
   $g=1-(C/Y+I/Y)$ and $C/K=(1-g)(1/(1+F/Y))(L/K)^{1-\alpha}-\delta$.
8. Capital, consumption, investment, output, labor, and net worth:
   $K=W(\theta^w-1)/\theta^w\{[(1-h)C/K]^{-\sigma_c}(L/K)^{-\sigma_L}\}^{1/(\sigma_c+\sigma_L)}$,
   then $C=(C/K)K$, $I=\delta K$, $Y=(C+I)/(1-g)$, $L=(L/K)K$, and $NW=(NW/K)K$.

`needs_review`: Appendix A uses some OCR-damaged symbols (`theta^w`, `sigma_L`, and markup notation). The relationships above are normalized from the Markdown and cross-checked against the Rep-MMB steady-state definitions, but they have not been checked against the PDF body.

## 7. Timing & Form Conventions

- The paper-side model is log-linear. Hatted variables denote deviations from steady state.
- The capital stock entering production is predetermined: production uses `k_{t-1}`, and capital accumulation determines `k_t`.
- Investment adjustment costs make investment forward-looking and backward-looking.
- The financial contract is signed before the idiosyncratic shock is realized; the premium condition links expected capital returns to current leverage/net worth.
- Entrepreneurial net worth is written in the paper as `nw_{t+1}`; the Rep-MMB implementation shifts this into current-period linear equations using lags, e.g. `nw=...rk(-1)...q(-2)+k(-1)...`.
- The Rep-MMB implementation includes sticky-price/sticky-wage equations and a flexible-price counterpart used to define potential output `ypot`; this is an implementation cross-check, not additional paper-side evidence.
- Runtime validation, Dynare residual checks, and Blanchard-Kahn checks were not performed.

## 8. Variable & Parameter Reference Table

| Category | Symbol / implementation name | Meaning | Main equation(s) |
|---|---|---|---|
| Endogenous | `c`, $\hat c_t$ | consumption | (F1), (F15) |
| Endogenous | `r`, $\hat r_t$ | real interest rate | (F2), (F11) |
| Endogenous | `rn`, $\hat r^n_t$ | nominal policy rate | (F2), (F17) |
| Endogenous | `wp`, $\hat w_t$ | real wage | (F3), (F7), (F8) |
| Endogenous | `l`, $\hat l_t$ | labor | (F3), (F6), (F8) |
| Endogenous | `inv`, $\hat I_t$ | investment | (F4), (F5), (F15) |
| Endogenous | `q`, $\hat q_t$ | price of capital / Tobin q | (F4), (F10), (F11), (F12) |
| Endogenous | `k`, $\hat k_t$ | capital stock | (F5), (F6), (F11), (F12) |
| Endogenous | `y`, $\hat y_t$ | output | (F6), (F15), (F17) |
| Endogenous | `mc`, $\widehat{mc}_t$ | real marginal cost | (F7), (F13) |
| Endogenous | `z`, $\widehat{re}^k_t$ / utilization proxy | marginal product/rental service of capital; implementation uses `z` | (F8), (F9) |
| Endogenous | `rk`, $\hat r^k_t$ | return on capital | (F10), (F11), (F12) |
| Endogenous | `nw`, $\widehat{nw}_t$ | entrepreneurial net worth | (F11), (F12) |
| Endogenous | `pi`, $\pi^c_t$ | CPI inflation | (F2), (F13), (F17) |
| Endogenous | `S`, $\hat s_t$ | log finance premium | (F11) |
| Endogenous | `g`, $\hat g_t$ | government spending | (F15), (F22) |
| Endogenous | `ypot` | flexible-price output gap reference | (F17) |
| Endogenous | `EMP` | employment smoothing block in implementation | implementation_cross_check |
| Exogenous | `ub`, $u^\beta_t$ | preference innovation | (F18) |
| Exogenous | `ul`, $u^L_t$ | labor-supply innovation | (F19) |
| Exogenous | `ux`, $u^x_t$ | investment-specific innovation | (F20) |
| Exogenous | `ua`, $u^a_t$ | technology innovation | (F21) |
| Exogenous | `ug`, $u^g_t$ | government-spending innovation | (F22) |
| Exogenous | `ur`, $u^{ru}_t$ | monetary-policy innovation | (F23), (F17) |
| Exogenous | `uw`, $u^w_t$ | wage-markup innovation | (F24), (F3) |
| Exogenous | `ulambdapi`, $u^{\lambda^\pi}_t$ | price-markup innovation | (F25), (F13) |
| Parameter | `beta` | discount factor | (F1), steady state |
| Parameter | `h` | habit parameter | (F1), (F3) |
| Parameter | `sigmac`, `sigmal` | consumption/labor curvature | (F1), (F3) |
| Parameter | `delta` | depreciation rate | (F5), steady state |
| Parameter | `alpha` | capital share | (F6)-(F8), steady state |
| Parameter | `theta`, `thetaest` | Calvo price parameter / goods elasticity in implementation | (F13), (F14) |
| Parameter | `cw`, `lambdaw`, `gammaw` | wage Calvo, wage markup, wage indexation | (F3) |
| Parameter | `gammapi` | price indexation | (F13) |
| Parameter | `pis`, `varphi` | inverse investment adjustment cost | (F4), (F5) |
| Parameter | `FI`, `psi` | inverse utilization-cost elasticity | (F6), (F9), (F15) |
| Parameter | `vkappa`, `varkappa` | premium elasticity with respect to leverage | (F11) |
| Parameter | `thetae`, $\vartheta^e$ | entrepreneur survival probability | (F12) |
| Parameter | `S_ss`, `S` | steady-state finance premium | (F11), steady state |
| Parameter | `KNW`, `NWK` | capital-net worth ratios | (F12), steady state |
| Parameter | `phim`, `rpi`, `ry`, `rdeltapi`, `rdeltay` | policy-rule coefficients | (F17) |
| Parameter | `rho*` | AR(1) persistence parameters | (F18)-(F22) |
