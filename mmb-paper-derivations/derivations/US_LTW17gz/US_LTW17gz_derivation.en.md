# US_LTW17gz -- Derivation (optimization problems + equilibrium conditions)

> Archive status: `needs_review`. This is a first-pass bilingual MMB archive extraction from the paper-side Markdown. Runtime validation was not performed.

Provenance: Leeper, Traum, and Walker (2017), "Clearing Up the Fiscal Multiplier Morass," American Economic Review 107(8), 2409-2454, DOI `10.1257/aer.20111196`. Primary source: `raw/mmb_mineru/runs/us_ltw17_us_ltw17gz_us_ltw17nu_us_ltw17rot__clearing_up_the_fiscal_multiplier_morass__f1cc32b3/full.md`. Raw PDF: `raw/mmb_papers/Clearing Up the Fiscal Multiplier Morass.pdf`. MinerU run id: `f1cc32b3-a1c8-4473-bab4-edca5aaeb37e`.

## 1. Model Overview

- Model: Estimated U.S. monetary-fiscal DSGE model with savers, non-savers, long-term nominal government debt, fiscal rules, steady-state tax distortions, sticky prices, sticky wages, habit, investment adjustment costs, capital utilization, and government consumption in utility.
- MMB variant: `US_LTW17gz`. The implementation cross-check describes this as the fiscal-rule variant with `gammgc=0` and `gammz=0.2`: government consumption does not respond to debt, while transfers do.
- Agents: final-goods firms, intermediate-goods firms, a labor agency, saver households, non-saver households, monetary authority, and fiscal authority.
- Form: paper model is nonlinear but taken to data in log-linearized form. The MMB implementation is a linearized model block with variables measured as deviations from steady state; this first-pass derivation records log-linear equilibrium conditions where the implementation clarifies coverage. Conditions copied only from `.mod` are tagged `implementation_cross_check`.
- Main uncertainty: the paper Markdown contains OCR damage in several displayed equations, especially wage aggregation/indexation and the government budget identity. These items are marked `needs_review`.

## 2. Optimization Problems

### Final-goods producer

The final-good firm chooses intermediate inputs $Y_t(i)$ to produce $Y_t$ under a Dixit-Stiglitz aggregator with time-varying price markup $\eta_t^p$:

$$
Y_t \leq \left(\int_0^1 Y_t(i)^{1/(1+\eta_t^p)}\,di\right)^{1+\eta_t^p}.
$$

Profit maximization implies the intermediate-good demand schedule:

$$
Y_t(i)=Y_t\left(\frac{\bar P_t(i)}{\bar P_t}\right)^{-(1+\eta_t^p)/\eta_t^p}.
$$

### Intermediate-goods firms

Intermediate firm $i$ produces with effective capital and labor:

$$
\bar Y_t(i)=K_t(i)^\alpha \left(A_t L_t(i)\right)^{1-\alpha}-A_t\Omega.
$$

Cost minimization gives a common nominal marginal cost. Price setters face Calvo reoptimization: with probability $1-\omega_p$ a firm resets its price; otherwise its price is indexed to lagged inflation with indexation $\chi_p$. A resetting firm maximizes expected discounted nominal profits:

$$
E_t\sum_{s=0}^{\infty}(\beta\omega_p)^s\frac{\lambda_{t+s}}{\lambda_t}
\left[
\left(\prod_{k=1}^{s}\pi_{t+k-1}^{\chi_p}\pi^{1-\chi_p}\right)P_t^{\ast}(i)Y_{t+s}(i)
-MC_{t+s}Y_{t+s}(i)
\right].
$$

### Labor agency and wage setters

A competitive labor agency aggregates differentiated labor services:

$$
L_t \leq \left(\int_0^1 L_t(l)^{1/(1+\eta_t^w)}\,dl\right)^{1+\eta_t^w}.
$$

Its demand for labor variety $l$ is:

$$
L_t(l)=L_t^d\left(\frac{W_t(l)}{W_t}\right)^{-(1+\eta_t^w)/\eta_t^w}.
$$

Saver households reset wages with probability $1-\omega_w$. Non-reset wages are indexed to lagged inflation and trend growth. The exact wage-indexation expression in the Markdown is `needs_review`.

### Saver households

Saver household $j$ has utility over composite consumption and labor:

$$
E_0\sum_{t=0}^{\infty}\beta^t u_t^b
\left[
\log\left(C_t^{\astS}(j)-\theta\tilde C_{t-1}^{\astS}\right)
-\frac{\left(L_t^S(j)\right)^{1+\xi}}{1+\xi}
\right],
$$

where

$$
C_t^{\astS}(j)=C_t^S(j)+\alpha_G G_t.
$$

The saver budget constraint is:

$$
\begin{aligned}
P_t(1+\tau_t^C)C_t^S(j)+P_t I_t^S(j)+P_t^B B_t(j)+R_t^{-1}B_{s,t}(j)
&=(1+\rho P_t^B)B_{t-1}(j)+B_{s,t-1}(j)\\
&\quad +(1-\tau_t^L)\int_0^1 W_t(l)L_t^S(j,l)\,dl\\
&\quad +(1-\tau_t^K)R_t^k v_t(j)\bar K_{t-1}^S(j)\\
&\quad -\Psi(v_t)\bar K_{t-1}^S(j)+P_t Z_t^S(j)+D_t(j).
\end{aligned}
$$

Effective capital and physical capital evolve as:

$$
K_t^S(j)=v_t(j)\bar K_{t-1}^S(j),
$$

$$
\bar K_t^S(j)=(1-\delta)\bar K_{t-1}^S(j)
+u_t^i\left[1-s\left(\frac{I_t^S(j)}{I_{t-1}^S(j)}\right)\right]I_t^S(j).
$$

### Non-saver households

Non-savers consume current disposable income. Their budget constraint is:

$$
(1+\tau_t^C)P_t C_t^N(j)
=(1-\tau_t^L)\int_0^1 W_t(l)L_t^N(j,l)\,dl+P_t Z_t^N(j).
$$

## 3. First-Order Conditions

The following conditions are a source-backed, first-pass log-linear equilibrium map. Conditions (F1)-(F18) are paper-backed in structure; where the exact log-linear coefficient form comes from `US_LTW17gz_rep.mod`, this is an `implementation_cross_check` and remains `needs_review` against paper/appendix equations.

- **(F1) Production function**:
$$
\hat y_t=\frac{\bar Y+\Omega}{\bar Y}\alpha\hat k_t+\frac{\bar Y+\Omega}{\bar Y}(1-\alpha)\hat l_t.
$$

- **(F2) Factor price relation**:
$$
\hat r_t^k-\hat w_t+\hat k_t-\hat l_t=0.
$$

- **(F3) Marginal cost**:
$$
\hat{mc}_t-\alpha\hat r_t^k+(\alpha-1)\hat w_t=0.
$$

- **(F4) New Keynesian price Phillips curve** (`needs_review`, implementation_cross_check):
$$
\lambda_p\hat\pi_t-\frac{\lambda_p\beta}{1+\beta\chi_p}E_t\hat\pi_{t+1}
-\hat{mc}_t-\lambda_p\hat u_t^p
=\frac{\lambda_p\chi_p}{1+\beta\chi_p}\hat\pi_{t-1}.
$$

- **(F5) Marginal utility of wealth for savers**:
$$
\hat\lambda_t+\frac{\theta}{e^\gamma-\theta}\hat u_t^a
+\frac{e^\gamma}{e^\gamma-\theta}\hat c_t^{\ast}
-\hat u_t^b+\frac{\tau^C}{1+\tau^C}\hat\tau_t^C
=\frac{\theta}{e^\gamma-\theta}\hat c_{t-1}^{\ast}.
$$

- **(F6) Long-run real interest rate and long-bond price relation** (`needs_review`, implementation_cross_check):
$$
\hat r_t^L+\hat P_t^B-\frac{\beta\rho}{e^\gamma}E_t\hat r_{t+1}^L
-\frac{\beta\rho}{e^\gamma}E_t\hat P_{t+1}^B+E_t\hat\pi_{t+1}=0.
$$

- **(F7) Long-run inflation definition** (`needs_review`, implementation_cross_check):
$$
\hat\pi_t^L+\hat P_t^B+\hat r_t^L=0.
$$

- **(F8) Consumption composite**:
$$
\hat c_t^{\ast}-\frac{C^S}{C^S+\alpha_G G}\hat c_t^S
-\frac{\alpha_G G}{C^S+\alpha_G G}\hat g_t=0.
$$

- **(F9) Saver Euler equation**:
$$
\hat\lambda_t-\hat R_t+E_t\hat\pi_{t+1}-E_t\hat\lambda_{t+1}
+\rho_a\hat u_t^a=0.
$$

- **(F10) Capacity utilization**:
$$
\frac{1-\psi}{\psi}\hat r_t^k-\hat v_t
-\frac{1-\psi}{\psi}\frac{\tau^K}{1-\tau^K}\hat\tau_t^K=0.
$$

- **(F11) Capital FOC**:
$$
\hat q_t+\hat R_t-E_t\hat\pi_{t+1}
-\beta e^{-\gamma}(1-\delta)E_t\hat q_{t+1}
-\beta e^{-\gamma}R^k(1-\tau^K)E_t\hat r_{t+1}^k
+\tau^K\beta e^{-\gamma}R^k E_t\hat\tau_{t+1}^K=0.
$$

- **(F12) Investment FOC**:
$$
-\frac{1}{(1+\beta)s e^{2\gamma}}\hat q_t+\hat i_t
-\frac{\beta}{1+\beta}E_t\hat i_{t+1}
+\frac{1-\beta\rho_a}{1+\beta}\hat u_t^a-\hat u_t^i
=\frac{1}{1+\beta}\hat i_{t-1}.
$$

- **(F13) Effective capital**:
$$
\hat k_t-\hat v_t+\hat u_t^a=\hat{\bar K}_{t-1}.
$$

- **(F14) Physical capital law of motion**:
$$
\hat{\bar K}_t-\left(1-(1-\delta)e^{-\gamma}\right)(1+\beta)s e^{2\gamma}\hat u_t^i
-\left(1-(1-\delta)e^{-\gamma}\right)\hat i_t
+(1-\delta)e^{-\gamma}\hat u_t^a
=(1-\delta)e^{-\gamma}\hat{\bar K}_{t-1}.
$$

- **(F15) Wage Phillips curve** (`needs_review`, implementation_cross_check):
$$
\begin{aligned}
(1+\lambda_w)\hat w_t&-\lambda_w\frac{\beta}{1+\beta}E_t\hat w_{t+1}
+\lambda_w\frac{1+\beta\chi_w}{1+\beta}\hat\pi_t
-\lambda_w\frac{\beta}{1+\beta}E_t\hat\pi_{t+1}\\
&-\xi\hat l_t+\hat\lambda_t
+\lambda_w\frac{1+\beta\chi_w-\rho_a\beta}{1+\beta}\hat u_t^a
-\frac{\tau^L}{1-\tau^L}\hat\tau_t^L
-\lambda_w\hat u_t^w-\hat u_t^b\\
&=\frac{\lambda_w}{1+\beta}\hat w_{t-1}
+\frac{\lambda_w\chi_w}{1+\beta}\hat\pi_{t-1}
+\frac{\lambda_w\chi_w}{1+\beta}\hat u_{t-1}^a.
\end{aligned}
$$

- **(F16) Monetary policy rule**:
$$
\hat R_t=(1-\rho_r)\phi_\pi\hat\pi_t+(1-\rho_r)\phi_y\hat y_t+\rho_r\hat R_{t-1}+\hat u_t^m.
$$

- **(F17) Non-saver budget condition**:
$$
C^N(1+\tau^C)\hat c_t^N+\tau^C C^N\hat\tau_t^C
-W L(1-\tau^L)\hat w_t-WL(1-\tau^L)\hat l_t
+WL\tau^L\hat\tau_t^L-Z\hat z_t=0.
$$

- **(F18) Consumption aggregation**:
$$
C\hat c_t-(1-\mu)C^S\hat c_t^S-\mu C^N\hat c_t^N=0.
$$

## 4. Market Clearing & Identities

- **(F19) Goods-market clearing**:
$$
C\hat c_t+I\hat i_t-Y\hat y_t+G\hat g_t+\Psi'(1)K\hat v_t=0.
$$

- **(F20) Long-bond pricing / maturity structure**:
$$
\hat R_t-\frac{\rho P^B}{1+\rho P^B}E_t\hat P_{t+1}^B+\hat P_t^B=0.
$$

- **(F21) Government budget constraint** (`needs_review`, paper OCR damaged; implementation_cross_check):
$$
\begin{aligned}
s^b\hat b_t&-\frac{G}{Y}\hat g_t-\frac{Z}{Y}\hat z_t
+\tau^K r^k\frac{K}{Y}(\hat\tau_t^K+\hat r_t^k+\hat k_t)
+\frac{s^b}{\beta}\hat u_t^a\\
&+\tau^L w\frac{L}{Y}(\hat\tau_t^L+\hat w_t+\hat l_t)
+\tau^C\frac{C}{Y}(\hat c_t+\hat\tau_t^C)
-s^b\rho e^{-\gamma}\hat P_t^B+\frac{s^b}{\beta}\hat\pi_t\\
&=\frac{s^b}{\beta}\hat b_{t-1}-\frac{s^b}{\beta}\hat P_{t-1}^B.
\end{aligned}
$$

- **(F22) Debt-output ratio definition**:
$$
\hat s_t^b+\hat y_t-\hat b_t=0.
$$

- **(F23) Consumption tax revenue identity**:
$$
\hat T_t^C-\hat\tau_t^C-\hat c_t=0.
$$

- **(F24) Capital tax revenue identity**:
$$
\hat T_t^K-\hat\tau_t^K-\hat r_t^k-\hat k_t=0.
$$

- **(F25) Ex-post bond return identity** (`needs_review`, implementation_cross_check):
$$
\hat r_t^b-\frac{\rho\beta}{e^\gamma}\hat P_t^B+\hat\pi_t=-\hat P_{t-1}^B.
$$

- **(F26) Primary surplus identity**:
$$
\hat S_t-\frac{\tau^K r^k K}{S}(\hat\tau_t^K+\hat r_t^k+\hat k_t)
-\frac{\tau^L w L}{S}(\hat\tau_t^L+\hat w_t+\hat l_t)
-\frac{\tau^C C}{S}(\hat\tau_t^C+\hat c_t)
+\frac{Z}{S}\hat z_t+\frac{G}{S}\hat g_t=0.
$$

- **(F27) Labor tax revenue identity**:
$$
\hat T_t^L-\hat\tau_t^L-\hat w_t-\hat l_t=0.
$$

- **(F28) Fisher equation**:
$$
\hat r_t-\hat R_t+E_t\hat\pi_{t+1}=0.
$$

## 5. Exogenous Processes

- **(F29) Government consumption rule, `US_LTW17gz` variant**:
$$
\hat g_t-\hat u_t^G=\rho_G\hat g_{t-1}-(1-\rho_G)\gamma_G\hat s_{t-1}^b,\qquad \gamma_G=0\ \text{in }US\_LTW17gz.
$$

- **(F30) Capital tax rule**:
$$
\hat\tau_t^K=(1-\rho_K)\gamma_K\hat s_{t-1}^b+\rho_K\hat\tau_{t-1}^K.
$$

- **(F31) Labor tax rule**:
$$
\hat\tau_t^L=(1-\rho_L)\gamma_L\hat s_{t-1}^b+\rho_L\hat\tau_{t-1}^L.
$$

- **(F32) Consumption tax rule**:
$$
\hat\tau_t^C=\rho_C\hat\tau_{t-1}^C.
$$

- **(F33) Transfer rule, `US_LTW17gz` variant**:
$$
\hat z_t-\hat u_t^Z=-(1-\rho_Z)\gamma_Z\hat s_{t-1}^b+\rho_Z\hat z_{t-1},\qquad \gamma_Z=0.2\ \text{in }US\_LTW17gz.
$$

- **(F34) Fiscal and structural shock processes**:
$$
\hat u_t^s=\rho_{es}\hat u_{t-1}^s+\epsilon_t^s,\qquad s\in\{Z,a,b,m,i,w,p\}.
$$

The paper also states a government-consumption shock $u_t^G=\rho_{eG}u_{t-1}^G+\epsilon_t^G$. The checked `US_LTW17gz_rep.mod` declares `ugc` as endogenous but leaves the government-consumption innovation commented out; this mismatch is `needs_review`.

## 6. Steady-State Solution

The source paper calibrates the steady-state fiscal variables to U.S. data: $G/Y=0.11$, $B/Y=1.47$, $\tau^L=0.186$, $\tau^K=0.218$, and $\tau^C=0.023$. The discount factor is $\beta=0.99$, depreciation is $\delta=0.025$, capital share is $\alpha=0.33$, steady-state inflation is $\pi=1$, and price/wage markups are calibrated with $\eta_p=\eta_w=0.14$.

For the log-linear implementation, all hatted endogenous variables have zero steady state. The level steady state used to scale the linear equations follows this sequence (`implementation_cross_check`):

1. Set $\pi=1$, $e^\gamma=\exp(\gamma)$, $R=e^\gamma/\beta$, and long-bond price $P^B=(R-\rho)^{-1}$ with duration parameter implied by average debt duration.
2. Compute after-tax rental return $R^k=(e^\gamma/\beta-1+\delta)/(1-\tau^K)$ and marginal cost $mc=1/(1+\eta_p)$.
3. Recover the wage, capital-labor ratio, fixed cost per labor unit, output per labor unit, investment per labor unit, and consumption per labor unit from production, zero-profit, and capital-accumulation restrictions.
4. Use the government budget in steady state to compute transfers, then compute non-saver and saver consumption per labor unit.
5. Compute composite consumption $C^{\ast}=C^S+\alpha_G G$ and solve labor from the saver intratemporal condition.
6. Scale $C^S,C^N,Y,K,I,Z,B,G$ and tax revenues by steady-state labor.

Steady-state formulas remain `needs_review` until checked against the paper's online appendix or replication documentation.

## 7. Timing & Form Conventions

- Hatted variables denote percentage or log deviations from steady state; observables are differences or levels of these transformed variables.
- $K_t$ is effective capital used in production; $\bar K_t$ is physical capital. Production in period $t$ uses $\bar K_{t-1}$ through utilization $v_t$.
- Government debt is a long-term nominal portfolio. Bonds issued in $t$ sell at $P_t^B$ and surviving coupons decay at rate $\rho$.
- The MMB implementation includes a flexible-price comparison economy with parallel variables ending in `f`; it is a counterfactual block and not a separate paper model.
- `US_LTW17gz` fixes the fiscal-rule variant by setting government-consumption response to debt to zero and transfer response to debt to `0.2`.
- No Dynare run, residual check, Blanchard-Kahn check, estimation, or IRF validation was performed.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Main equation(s) |
|---|---|---|---|
| Endogenous | `cs`, $C^S$ | saver consumption | (F5), (F8), (F9), (F18) |
| Endogenous | `cn`, $C^N$ | non-saver consumption | (F17), (F18) |
| Endogenous | `c`, $C$ | aggregate consumption | (F18), (F19) |
| Endogenous | `cstar`, $C^{\ast}$ | consumption in utility | (F8) |
| Endogenous | `R`, $R^n$ | nominal policy rate | (F16), (F28) |
| Endogenous | `r`, $r$ | real rate | (F28) |
| Endogenous | `i`, $I$ | investment | (F12), (F14), (F19) |
| Endogenous | `k`, $K$ | effective capital | (F1), (F13) |
| Endogenous | `kbar`, $\bar K$ | physical capital | (F13), (F14) |
| Endogenous | `v`, $v$ | utilization | (F10), (F13), (F19) |
| Endogenous | `l`, $L$ | labor | (F1), (F15), (F17), (F27) |
| Endogenous | `y`, $Y$ | output | (F1), (F19), (F22) |
| Endogenous | `gc`, $G$ | government consumption | (F19), (F29) |
| Endogenous | `q`, $q$ | Tobin's Q | (F11), (F12) |
| Endogenous | `rk`, $R^k$ | capital return | (F2), (F3), (F10), (F11) |
| Endogenous | `w`, $W$ | real wage | (F2), (F3), (F15), (F17) |
| Endogenous | `pi`, $\pi$ | inflation | (F4), (F16), (F21), (F28) |
| Endogenous | `b`, $B$ | government debt | (F21), (F22) |
| Endogenous | `sb`, $s^b$ | debt-output ratio | (F22), fiscal rules |
| Endogenous | `tauk`, $\tau^K$ | capital tax rate | (F11), (F21), (F30) |
| Endogenous | `taul`, $\tau^L$ | labor tax rate | (F15), (F17), (F31) |
| Endogenous | `tauc`, $\tau^C$ | consumption tax rate | (F5), (F17), (F32) |
| Endogenous | `z`, $Z$ | transfers | (F17), (F21), (F33) |
| Endogenous | `mc` | marginal cost | (F3), (F4) |
| Endogenous | `lambda` | saver marginal utility of wealth | (F5), (F9), (F15) |
| Endogenous | `Pb` | long-bond price | (F6), (F7), (F20), (F21), (F25) |
| Endogenous | `piL`, `rL` | long-run inflation/rate variables | (F6), (F7) |
| Endogenous | `S`, `Tk`, `Tl`, `Tc`, `rb` | fiscal accounting variables | (F23)-(F27) |
| Endogenous | `ugc`, `uz`, `ua`, `ub`, `um`, `ui`, `uw`, `up` | shock states | (F29), (F33), (F34) |
| Exogenous | `euz`, `eua`, `eub`, `eum`, `eui`, `euw`, `eup` | innovations in transfer, technology/growth, preference, monetary, investment, wage-markup, price-markup shocks | (F34) |
| Parameter | `bet`, $\beta$ | discount factor | steady state, FOCs |
| Parameter | `alph`, $\alpha$ | capital share | (F1), (F3) |
| Parameter | `delt`, $\delta$ | depreciation | (F11), (F14) |
| Parameter | `etap`, `etaw` | price and wage markup parameters | (F4), (F15) |
| Parameter | `omegap`, `omegaw` | Calvo non-reset probabilities | (F4), (F15) |
| Parameter | `chip`, `chiw` | price and wage indexation | (F4), (F15) |
| Parameter | `thet`, $\theta$ | habit | (F5) |
| Parameter | `alphag`, $\alpha_G$ | public/private consumption substitutability | (F8) |
| Parameter | `gammgc`, `gammz` | government-consumption and transfer debt responses | (F29), (F33) |
| Parameter | `gammtk`, `gammtl` | capital and labor tax debt responses | (F30), (F31) |
| Parameter | `rho*` | autoregressive parameters | (F29)-(F34) |
