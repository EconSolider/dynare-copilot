# NK_GHP16 -- Derivation (Optimization Problems + First-Order Conditions)

> Private MMB archive draft. Runtime validation was not performed.

Source: Gnocci, Stefano; Hauser, Daniela; Pappa, Evi (2016), "Housework and Fiscal Expansions", Journal of Monetary Economics 79, 94-108, DOI `10.1016/j.jmoneco.2016.04.003`.

## 1. Model Overview

- **Model**: New Keynesian model with home production/housework, market production, Calvo price rigidity, capital accumulation, and fiscal purchases of market goods.
- **Experiment**: government-consumption expenditure shock with persistent AR(1) government spending; MMB implementation simulates a first-order approximation.
- **Agents and blocks**: representative household, monopolistically competitive market-good firms, fiscal authority, and central bank.
- **Form**: nonlinear equilibrium conditions in levels with an MMB log-variable implementation. The paper also presents simplified log-linear mechanisms, but this archive entry records the full nonlinear Section 2 model as the primary derivation.
- **Source quality**: the MinerU Markdown contains the main model equations. Calvo auxiliary recursions and the exact MMB simplification of the Taylor rule are cross-checked against `.agents/skills/dynare-copilot/references/examples/NK_GHP16_rep.mod` as `implementation_cross_check` only.

## 2. Optimization Problems

### 2.1 Household

The household chooses market consumption varieties, investment, next-period contingent assets, market hours, home hours, the allocation of capital between market and home production, and next-period aggregate capital. Capital can be rented to firms or kept for home production.

\[
\max E_0\sum_{t=0}^{\infty}\beta^t U(C_t,l_t)
\]

subject to the time, home-production, CES consumption, budget, and capital-accumulation relations:

\[
K_{m,t}+K_{n,t}=K_t,\qquad h_{m,t}+h_{n,t}=h_t,\qquad l_t=1-h_t.
\]

\[
C_{n,t}=K_{n,t}^{\alpha_2}h_{n,t}^{1-\alpha_2}.
\]

\[
C_t=\left[\alpha_1 C_{m,t}^{b_1}+(1-\alpha_1)C_{n,t}^{b_1}\right]^{1/b_1}.
\]

\[
B_t+W_tP_t h_{m,t}+r_t^kP_tK_{m,t}+T_t
\ge E_t\{Q_{t,t+1}B_{t+1}\}+P_t(C_{m,t}+I_t).
\]

\[
K_{t+1}=(1-\delta)K_t+I_t-\frac{\xi}{2}\left(\frac{K_{t+1}}{K_t}-1\right)^2.
\]

For the quantitative baseline the paper specifies KPR preferences:

\[
U(C_t,l_t)=\frac{\left(C_t^b l_t^{1-b}\right)^{1-\sigma}-1}{1-\sigma}.
\]

### 2.2 Market-Good Firms

Each firm produces a differentiated market good using market capital and market labor:

\[
Y_t(i)=K_{m,t}(i)^{\alpha_3}h_{m,t}(i)^{1-\alpha_3}.
\]

Demand under CES aggregation is:

\[
Y_t(i)=\left[\frac{P_t(i)}{P_t}\right]^{-\varepsilon}Y_t^d.
\]

With Calvo probability \(\theta\) of not resetting the price, a resetting firm maximizes discounted nominal profits:

\[
E_t\sum_{j=0}^{\infty}\theta^j Q_{t,t+j}
\left[P_t(i)Y_{t+j}(i)-P_{t+j}(1-\tau)RMC_{t+j}Y_{t+j}(i)\right].
\]

### 2.3 Policy Authorities

The fiscal authority purchases market varieties to produce aggregate public consumption \(G_t\) and finances purchases with lump-sum taxes/transfers. The central bank sets the nominal interest rate with a Taylor-type rule.

## 3. First-Order Conditions

**(F1) Aggregate capital allocation**

\[
K_{m,t}+K_{n,t}=K_t.
\]

**(F2) Time allocation**

\[
h_{m,t}+h_{n,t}=h_t,\qquad l_t=1-h_t.
\]

**(F3) Home-good production**

\[
C_{n,t}=K_{n,t}^{\alpha_2}h_{n,t}^{1-\alpha_2}.
\]

**(F4) Market/home consumption aggregator**

\[
C_t=\left[\alpha_1 C_{m,t}^{b_1}+(1-\alpha_1)C_{n,t}^{b_1}\right]^{1/b_1}.
\]

**(F5) Marginal utility of market consumption**

\[
\lambda_t=U_C(C_t,l_t)\alpha_1\left(\frac{C_{m,t}}{C_t}\right)^{b_1-1}.
\]

With KPR preferences, the MMB implementation cross-check uses:

\[
\lambda_t=b\alpha_1 l_t^{(1-b)(1-\sigma)}C_{m,t}^{b_1-1}C_t^{b(1-\sigma)-b_1}.
\]

**(F6) Leisure/market-hours condition**

\[
W_t=\frac{U_l(C_t,l_t)}{\lambda_t}.
\]

**(F7) Leisure/home-production condition**

\[
\frac{U_l(C_t,l_t)}{(1-\alpha_1)U_C(C_t,l_t)}
\left(\frac{C_{n,t}}{C_t}\right)^{1-b_1}
=\frac{(1-\alpha_2)C_{n,t}}{h_{n,t}}.
\]

**(F8) Capital allocation between home and market sectors**

\[
\frac{\alpha_1}{1-\alpha_1}
\left(\frac{C_{m,t}}{C_{n,t}}\right)^{b_1-1}
=\frac{\alpha_2 C_{n,t}}{r_t^k K_{n,t}}.
\]

**(F9) Capital accumulation**

\[
K_{t+1}=(1-\delta)K_t+I_t-\frac{\xi}{2}\left(\frac{K_{t+1}}{K_t}-1\right)^2.
\]

**(F10) Euler equation for capital**

\[
\beta E_t\left\{\frac{\lambda_{t+1}}{\lambda_t}
\frac{
1-\delta+r_{t+1}^k+\xi\left(\frac{K_{t+2}}{K_{t+1}}-1\right)\left(\frac{K_{t+2}}{K_{t+1}^2}\right)
}{
1+\frac{\xi}{K_t}\left(\frac{K_{t+1}}{K_t}-1\right)
}\right\}=1.
\]

**(F11) Euler equation for financial assets**

\[
\beta E_t\left\{\frac{\lambda_{t+1}}{\lambda_t}(1+R_t)\Pi_{t+1}^{-1}\right\}=1.
\]

**(F12) Market-good production**

\[
Y_t(i)=K_{m,t}(i)^{\alpha_3}h_{m,t}(i)^{1-\alpha_3}.
\]

**(F13) Firm-level demand**

\[
Y_t(i)=\left[\frac{P_t(i)}{P_t}\right]^{-\varepsilon}Y_t^d.
\]

**(F14) Real marginal cost**

\[
RMC_t=\frac{r_t^kK_{m,t}(i)}{\alpha_3Y_t(i)}
=\frac{W_t h_{m,t}(i)}{(1-\alpha_3)Y_t(i)}.
\]

**(F15) Optimal reset price, needs_review**

The paper gives the Calvo profit problem but not the compact recursive implementation. The MMB implementation uses auxiliary variables:

\[
\frac{P_t^{\ast}}{P_t}=\frac{x_{1,t}}{x_{2,t}}.
\]

**(F16) Calvo numerator recursion, implementation_cross_check, needs_review**

\[
x_{1,t}=Y_t\frac{\varepsilon(1-\tau)}{\varepsilon-1}RMC_t
\beta\theta E_t\left[\frac{\lambda_{t+1}}{\lambda_t}\Pi_{t+1}^{\varepsilon}x_{1,t+1}\right].
\]

**(F17) Calvo denominator recursion, implementation_cross_check, needs_review**

\[
x_{2,t}=Y_t+\beta\theta E_t\left[\frac{\lambda_{t+1}}{\lambda_t}\Pi_{t+1}^{\varepsilon-1}x_{2,t+1}\right].
\]

**(F18) Price-index relation**

\[
1=\theta\Pi_t^{\varepsilon-1}+(1-\theta)\left(\frac{P_t^{\ast}}{P_t}\right)^{1-\varepsilon}.
\]

**(F19) Price dispersion**

\[
\Delta_t=(1-\theta)\left(\frac{P_t^{\ast}}{P_t}\right)^{-\varepsilon}+\theta\Pi_t^{\varepsilon}\Delta_{t-1}.
\]

## 4. Market Clearing & Identities

**(F20) Government-good aggregator**

\[
G_t=\left[\int_0^1 G_t(i)^{(\varepsilon-1)/\varepsilon}di\right]^{\varepsilon/(\varepsilon-1)}.
\]

**(F21) Aggregate output**

\[
Y_t=\left[\int_0^1 Y_t(i)^{(\varepsilon-1)/\varepsilon}di\right]^{\varepsilon/(\varepsilon-1)}.
\]

**(F22) Market clearing**

\[
Y_t=Y_t^d=C_{m,t}+I_t+G_t,\qquad
h_{m,t}=\int_0^1h_{m,t}(i)di,\qquad
K_{m,t}=\int_0^1K_{m,t}(i)di.
\]

**(F23) Aggregate market production with price dispersion**

\[
Y_t=\Delta_t^{-1}K_{m,t}^{\alpha_3}h_{m,t}^{1-\alpha_3}.
\]

## 5. Exogenous Processes

**(F24) Government spending process**

\[
\log G_t=(1-\rho_g)\log \bar{G}+\rho_g\log G_{t-1}+\varepsilon^g_t.
\]

The MMB implementation writes this as \(G_t=\bar{G}\exp(g_t)\) and:

\[
g_t=\rho_g g_{t-1}+\varepsilon^g_t.
\]

**(F25) Monetary policy rule**

The paper's general Taylor rule is:

\[
(1+R_t)=(1+R_{t-1})^{\rho_m}
\cdot\left(\beta^{-1}\Pi_t^{\phi_\pi}\left(\frac{Y_t}{Y_t^n}\right)^{\phi_y}\right)^{1-\rho_m}
\cdot\left(\frac{Y_t/Y_t^n}{Y_{t-1}/Y_{t-1}^n}\right)^{\phi_{dy}}.
\]

The MMB implementation restricts this to no smoothing and no output-gap terms:

\[
1+R_t=\beta^{-1}\Pi_t^{\phi_\pi}.
\]

## 6. Steady-State Solution

The paper reports the baseline steady-state calibration system. Let \(i=I/K\), \(k_m=K_m/Y\), \(k_n=K_n/Y\), \(g=G/Y\), and set \(\Pi=1\).

1. Choose the data targets \(\beta\), \(i\), \(k_m\), \(k_n\), \(h_m\), \(h_n\), and \(g\).
2. Determine depreciation and returns:

\[
\delta=i,\qquad r^k=\frac{1-\beta(1-\delta)}{\beta}.
\]

3. Determine market-sector production parameters and market quantities:

\[
\alpha_3=r^k k_m,\qquad
Y=k_m^{\alpha_3/(1-\alpha_3)}h_m.
\]

\[
C_m=Y\left[1-g-\delta(k_m+k_n)\right],\qquad
G=gY,\qquad
W=\frac{(1-\alpha_3)Y}{h_m}.
\]

4. Determine home-sector parameters and non-market quantities:

\[
\alpha_2=\frac{k_nr^kY}{k_nr^kY+Wh_n},\qquad
C_n=(k_nY)^{\alpha_2}h_n^{1-\alpha_2}.
\]

\[
\alpha_1=
\frac{(1-\alpha_2)C_n^{b_1}/(Wh_n)}
{C_m^{b_1-1}+(1-\alpha_2)C_n^{b_1}/(Wh_n)}.
\]

\[
h=h_m+h_n,\qquad l=1-h,\qquad
b=\frac{(1-\alpha_2)C_m+Wh_n}{(1-\alpha_2)(Wl+C_m)+Wh_n}.
\]

5. Remaining steady-state objects used by the MMB implementation include:

\[
C=\left[\alpha_1C_m^{b_1}+(1-\alpha_1)C_n^{b_1}\right]^{1/b_1},\qquad
I=\delta(k_m+k_n)Y.
\]

\[
RMC=\frac{\varepsilon-1}{\varepsilon(1-\tau)},\qquad
\lambda=b\alpha_1l^{(1-b)(1-\sigma)}C_m^{b_1-1}C^{b(1-\sigma)-b_1}.
\]

The steady-state formulas are source-backed, but the entry remains `needs_review` because no Dynare residual or BK validation was run.

## 7. Timing & Form Conventions

- **Capital timing**: the paper writes households entering period \(t\) with \(K_t\) and choosing \(K_{t+1}\). The MMB implementation shifts this to Dynare timing with `K(-1)` predetermined and current `K` as end-of-period capital.
- **Home capital and market capital**: \(K_{n,t}\) and \(K_{m,t}\) are the within-period allocation of aggregate capital between home and market production.
- **Inflation**: \(\Pi_t=P_t/P_{t-1}\); the MMB code stores log inflation as `infl`.
- **Interest rate**: the paper uses \(1+R_t\) in the Euler equation and rule; the MMB code stores `r` so that `exp(1+r)` is the gross nominal return.
- **Form**: nonlinear source equations with an MMB first-order perturbation around the deterministic steady state. The `.mod` uses logs for positive variables.
- **Runtime validation**: not performed.

## 8. Variable & Parameter Reference Table

| Category | Symbol / Dynare name | Meaning | Main equation(s) |
|---|---|---|---|
| Endogenous | \(C_t\) / `C` | aggregate consumption composite | (F4), (F5) |
| Endogenous | \(C_{m,t}\) / `C_m` | market consumption | (F4), (F22) |
| Endogenous | \(C_{n,t}\) / `C_n` | home-produced consumption | (F3), (F7), (F8) |
| Endogenous | \(K_t\) / `K` | aggregate capital | (F1), (F9), (F10) |
| Endogenous | \(K_{m,t}\) / `K_m` | market-sector capital | (F1), (F14), (F22), (F23) |
| Endogenous | \(K_{n,t}\) / `K_n` | home-sector capital | (F1), (F3), (F8) |
| Endogenous | \(I_t\) / `I` | investment | (F9), (F22) |
| Endogenous | \(W_t\) / `W` | real wage | (F6), (F14) |
| Endogenous | \(h_{m,t}\) / `h_m` | market hours | (F2), (F22), (F23) |
| Endogenous | \(h_{n,t}\) / `h_n` | home hours | (F2), (F3), (F7) |
| Endogenous | \(r_t^k\) / `r_k` | rental return on capital | (F8), (F10), (F14) |
| Endogenous | \(R_t\) / `r` | nominal policy rate net of one in paper notation | (F11), (F25) |
| Endogenous | \(\lambda_t\) / `lambda` | marginal utility of market consumption | (F5), (F10), (F11) |
| Endogenous | \(\Pi_t\) / `infl` | gross inflation | (F11), (F18), (F19), (F25) |
| Endogenous | \(P_t^{\ast}/P_t\) / `inflstar` | optimal reset relative price | (F15), (F18), (F19) |
| Endogenous | \(x_{1,t}\) / `x_1` | Calvo numerator auxiliary | (F16) |
| Endogenous | \(x_{2,t}\) / `x_2` | Calvo denominator auxiliary | (F17) |
| Endogenous | \(RMC_t\) / `RMC` | real marginal cost | (F14), (F16) |
| Endogenous | \(G_t\) / `G` | government purchases | (F20), (F22), (F24) |
| Endogenous | \(g_t\) / `g` | log government spending deviation | (F24) |
| Endogenous | \(Y_t\) / `Y` | aggregate output | (F21), (F22), (F23) |
| Endogenous | \(\Delta_t\) / `D` | price dispersion | (F19), (F23) |
| Exogenous | \(\varepsilon^g_t\) / `e_g` | government-spending innovation | (F24) |
| Parameter | \(\beta\) / `beta` | discount factor | (F10), (F11), (F25) |
| Parameter | \(\varepsilon\) / `eps` | elasticity across varieties | (F13), (F18), (F20), (F21) |
| Parameter | \(\theta\) / `theta` | Calvo non-reset probability | (F16), (F17), (F18), (F19) |
| Parameter | \(\xi\) / `xi` | capital adjustment cost | (F9), (F10) |
| Parameter | \(\sigma\) / `sigma` | risk aversion in KPR utility | (F5), steady state |
| Parameter | \(\rho_g\) / `rho_g` | government-spending persistence | (F24) |
| Parameter | \(\delta\) / `delta` | depreciation rate | (F9), (F10), steady state |
| Parameter | \(\tau\) / `tau` | production subsidy | (F16), steady state |
| Parameter | \(\tau_p\) / `taup` | implementation tax/subsidy wedge on factor FOCs | (F14), implementation_cross_check |
| Parameter | \(\phi_\pi\) / `phi_infl` | Taylor-rule inflation coefficient | (F25) |
| Parameter | \(\alpha_1,\alpha_2,\alpha_3\) / `alpha_1`, `alpha_2`, `alpha_3` | consumption, home-production, and market-production shares | (F3), (F4), (F8), (F12), (F23) |
| Parameter | \(b_1,b\) / `b_1`, `b` | home/market substitutability and KPR consumption-leisure share | (F4), (F5), steady state |
