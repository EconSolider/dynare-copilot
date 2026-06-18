# DEREA_GEAR16 - Derivation (Optimization Problems + First-Order Conditions)

> First-pass archive extraction for the MMB model `DEREA_GEAR16`.
> Status: `needs_review`.
> Runtime validation: not performed.

Source: Gadatsch, Niklas; Hauzenberger, Klemens; Stahler, Nikolai (2016), "Fiscal policy during the crisis: A look on Germany and the Euro area with GEAR", *Economic Modelling*, 52, 997-1016, DOI `10.1016/j.econmod.2015.10.038`.

Main source Markdown: `raw/mmb_mineru/runs/derea_gear16__fiscal_policy_during_the_crisis_a_look_on_germany_and_the_euro_area_with__0124e095/full.md`.

Raw PDF provenance: `raw/mmb_papers/Fiscal policy during the crisis- A look on Germany and the Euro area with GEAR.pdf`.

Important limitation: the paper-side Markdown states that most derivations, first-order conditions, the equation summary, and the complete steady-state derivation are available upon request rather than printed in the article. The equations below are therefore a source-backed structural extraction from the visible model section, with several `needs_review` markers where the missing equation summary is required.

## 1. Model Overview

- **Model**: GEAR, a three-region DSGE model for Germany (`a`), the rest of the Euro area (`b`), and the rest of the world (`c`).
- **Purpose**: estimated fiscal-policy analysis for Germany and the Euro area during and after the global financial crisis.
- **Regional structure**: Germany and the rest of the Euro area form a monetary union with one common monetary authority. The rest of the world is represented by a compact VAR block.
- **Agents in regions `a` and `b`**: optimizing households, rule-of-thumb households, monopolistically competitive firms, a fiscal authority, and the common monetary authority. The production block contains private capital, private employment, public capital, and public employment.
- **Key frictions/features**: external habits, optimizing and RoT households, involuntary unemployment, monopolistic competition, Rotemberg price and wage adjustment costs, public capital and public employment productivity spillovers, distortionary taxes, public debt, fiscal feedback rules, international trade, net foreign asset risk premia, and common monetary policy.
- **Form**: large-scale nonlinear DSGE model estimated in Dynare. The implementation cross-check uses level variables and nonlinear equations. Some rest-of-world VAR variables are log/level deviations from steady state.
- **Scope of this entry**: country `a` equations are written explicitly where the source prints them; country `b` is analogous with the index changed from `a` to `b`; country `c` is the source's VAR block.

## 2. Optimization Problems

### 2.1 Final-goods bundler

The representative final goods firm in country `a` purchases differentiated intermediate inputs and chooses quantities to maximize nominal revenue net of intermediate input costs:

```math
\max_{\{\tilde y_t^a(z):z\in[0,1]\}}
P_t^{a,a}Y_t^a-\int_0^1 P_t^{a,a}(z)\tilde y_t^a(z)\,dz .
\tag{F1}
```

The CES aggregator is:

```math
Y_t^a=\left(\int_0^1 \tilde y_t^a(z)^{(\theta_{a,t}-1)/\theta_{a,t}}\,dz\right)^{\theta_{a,t}/(\theta_{a,t}-1)} .
\tag{F2}
```

### 2.2 Intermediate-goods firms

Intermediate firm `z` produces with private capital, private employment, public capital, public employment, domestic and global technology, and fixed costs:

```math
y_t^a(z)=e^{\varepsilon_t^{A_a}}e^{\varepsilon_t^{A_g}}
\zeta_a\left(K_t^{G,a}\right)^{\eta^{K^G,a}}
\left(N_t^{G,a}\right)^{\eta^{N^G,a}}
\left[K_{t-1}^a(z)\right]^{\alpha_a}
\left[N_t^{P,a}(z)\right]^{1-\alpha_a}
-\Omega_a .
\tag{F3 needs_review}
```

`needs_review`: OCR around the public-input productivity multiplier in the source is visibly damaged. The intended structure is multiplicative, and the implementation cross-check uses `yG_a_t = z_a*kG_a_t^eta_kG_a*nG_a_t^eta_nG_a` multiplying the private production function.

Price setters choose their own price path subject to demand and Rotemberg adjustment costs:

```math
\max_{\{P_{t+s}^{a,a}(z)\}}
E_t\sum_{s=0}^{\infty}\beta_a^s
\frac{\lambda_{o,t+s}^a}{\lambda_{o,t}^a}
\left[
\left(\frac{P_{t+s}^{a,a}(z)}{P_{t+s}^a}-mc_{t+s}^a\right)y_{t+s}^a(z)
-adj_t^{p,a}Y_{t+s}^a
\right].
\tag{F4}
```

The Rotemberg price-adjustment term is:

```math
adj_t^{P,a}
=\frac{\gamma_a}{2}
\left(
\frac{P_{t+s}^{a,a}(z)}
{(\pi_{t+s-1}^{a,a})^{\xi_a}(\bar\pi^{a,a})^{1-\xi_a}P_{t+s-1}^{a,a}(z)}
-1
\right)^2
\frac{P_{t+s}^{a,a}}{P_{t+s}^a}.
\tag{F5 needs_review}
```

`needs_review`: the adjustment-cost equation is printed inside a price-setter problem and uses both `t` and `t+s`; the exact time indexing should be checked against the unavailable equation summary.

### 2.3 Households

Each region has optimizing households (`o`) and rule-of-thumb households (`r`). The type-`x` household utility, with external habits and labor-force participation costs, is:

```math
U(C_{x,t+s}^a,N_{x,t+s}^a)
=e^{\varepsilon_{t+s}^{\beta_a}}
\left[
\frac{(C_{x,t+s}^a-h_a\bar C_{x,t+s-1}^a)^{1-\sigma_a}}{1-\sigma_a}
-\kappa_a^w e^{\varepsilon_{t+s}^{N_a}}
\int_0^1
\frac{N_{x,t+s}^a(\mathfrak h_x)^{1+\varphi_a}}{1+\varphi_a}
d\mathfrak h_x
\right].
\tag{F6}
```

The country-`a` private consumption aggregator is:

```math
C_{x,t}^a=\left[
(n_a^a)^{1/\eta_a}(C_{x,t}^{a,a})^{(\eta_a-1)/\eta_a}
+(n_b^a e^{\varepsilon_t^{b,a}})^{1/\eta_a}(C_{x,t}^{a,b})^{(\eta_a-1)/\eta_a}
+(n_c^a)^{1/\eta_a}(C_{x,t}^{a,c})^{(\eta_a-1)/\eta_a}
\right]^{\eta_a/(\eta_a-1)} .
\tag{F7}
```

RoT households consume current after-tax labor income, unemployment benefits, and transfers:

```math
0=(1+\tau_t^{c,a})C_{r,t}^a
-(1-\tau_t^{w,a})(w_t^aN_t^{P,a}+w_t^{G,a}N_t^{G,a})
-UB^a(L_{r,t}^a-N_t^a)-TR_{r,t}^a .
\tag{F8}
```

Optimizing households choose consumption, investment, private bonds, foreign bonds, government bonds, and capital subject to a large intertemporal budget constraint. The printed source formula is partly OCR-damaged but implies the optimizer budget:

```math
0=(1+\tau_t^{c,a})C_{o,t}^a+I_{o,t}^a+B_{o,t}^{a,a}
+\sum_{j=b,c}S_t^{a,j}B_{o,t}^{a,j}+B_{o,t}^{G,a}+T_{o,t}^a
-\text{after-tax labor income}
-\text{benefits and transfers}
-\text{real bond payoffs}
-\text{after-tax capital income}
-D_{o,t}^a .
\tag{F9 needs_review}
```

Optimizer-owned capital evolves as:

```math
k_{o,t}^a=(1-\delta_a)k_{o,t-1}^a+
\left[
I_{o,t}^a-I_{o,t}^a\frac{\psi_a^i}{2}
\left(\frac{I_{o,t}^a}{I_{o,t-1}^a}-1\right)^2
\right]e^{\varepsilon_t^{I_a}} .
\tag{F10}
```

### 2.4 Labor agency and union

The labor aggregator chooses differentiated labor services subject to a wage bill:

```math
\max_{\{N_t^{P,a}(\mathfrak h):\mathfrak h\in[0,1]\}}
N_t^{P,a}
=\left(\int_0^1(N_t^{P,a}(\mathfrak h))^{(\theta_{a,t}^w-1)/\theta_{a,t}^w}\,d\mathfrak h\right)^{\theta_{a,t}^w/(\theta_{a,t}^w-1)} .
\tag{F11}
```

The union wage-setting problem is only summarized in the paper; the detailed FOCs are stated to be in the equation summary. The source identifies Rotemberg wage adjustment and union bargaining across both household types.

```math
\text{Union chooses } W_t^a(\mathfrak h)\text{ taking labor demand, labor supply, wage adjustment costs, and household weights as constraints.}
\tag{F12 needs_review}
```

## 3. First-Order Conditions

### 3.1 Final-goods demand and price index

The final-goods bundler yields demand for variety `z`:

```math
\tilde y_t^a(z)=\left(\frac{P_t^{a,a}(z)}{P_t^{a,a}}\right)^{-\theta_{a,t}}Y_t^a .
\tag{F13}
```

The corresponding PPI aggregator is:

```math
P_t^{a,a}=\left(\int_0^1 P_t^{a,a}(z)^{1-\theta_{a,t}}\,dz\right)^{1/(1-\theta_{a,t})}.
\tag{F14}
```

### 3.2 Firm cost minimization

The source prints the country-`a` capital-labor ratio condition:

```math
\frac{r_{k,t}^a}{w_t^a(1+\tau_t^{sc,a})}
=\frac{N_t^{P,a}(z)}{K_{t-1}^a(z)}\frac{\alpha_a}{1-\alpha_a}.
\tag{F15}
```

Real CPI-deflated marginal cost is:

```math
mc_t^a=
\frac{
(r_{k,t}^a)^{\alpha_a}
\left(w_t^a(1+\tau_t^{sc,a})\right)^{1-\alpha_a}
}{
e^{\varepsilon_t^{A_a}}e^{\varepsilon_t^{A_g}}
\zeta_a(K_t^{G,a})^{\eta^{K^G,a}}(N_t^{G,a})^{\eta^{N^G,a}}
\alpha_a^{\alpha_a}(1-\alpha_a)^{1-\alpha_a}
}.
\tag{F16 needs_review}
```

`needs_review`: OCR damage affects the denominator exponent and the placement of the public-input multiplier. The mathematical relationship should be checked against the equation summary or PDF formula.

### 3.3 Household FOCs

The paper states that optimizer Euler equations for private and public bonds, physical-capital investment, and marginal utility are relegated to the appendix/equation summary. The implementation cross-check indicates the following Euler relationship for domestic private bonds in country `a`:

```math
\lambda_{o,t}^a\pi_{t+1}^a
=\beta_a e^{\varepsilon_t^{RP,EA}}(1+i_t^a)\lambda_{o,t+1}^a .
\tag{F17 implementation_cross_check needs_review}
```

The implementation cross-check indicates the analogous government-bond Euler equation:

```math
\lambda_{o,t}^a\pi_{t+1}^a
=\beta_a(1+i_t^{G,a})\lambda_{o,t+1}^a .
\tag{F18 implementation_cross_check needs_review}
```

The marginal utility of optimizing and RoT consumption follows from the printed utility and the implementation cross-check:

```math
\lambda_{x,t}^a
=\frac{e^{\varepsilon_t^{\beta_a}}(C_{x,t}^a-h_aC_{x,t-1}^a)^{-\sigma_a}}{1+\tau_t^{c,a}},
\quad x\in\{o,r\}.
\tag{F19 implementation_cross_check needs_review}
```

The optimizer capital-return Euler equation appears in the implementation cross-check as:

```math
1=\beta_a\frac{\lambda_{o,t+1}^a}{\lambda_{o,t}^a}
\frac{1+Rk_{t+1}^a}{\pi_{t+1}^a}.
\tag{F20 implementation_cross_check needs_review}
```

The effective capital return appears in the implementation cross-check as:

```math
Rk_t^a
=\frac{\pi_t^a\left(q_t^a(1-\delta_a)+(1-\tau_t^{k,a})rk_t^a+\tau_t^{k,a}\delta_a\right)}{q_{t-1}^a}-1 .
\tag{F21 implementation_cross_check needs_review}
```

The Tobin's Q condition implied by investment adjustment costs appears in the implementation cross-check as:

```math
\begin{aligned}
1={}&q_t^a\left[1-\frac{\upsilon_a}{2}\left(\frac{I_{o,t}^a}{I_{o,t-1}^a}-1\right)^2
-\upsilon_a\frac{I_{o,t}^a}{I_{o,t-1}^a}\left(\frac{I_{o,t}^a}{I_{o,t-1}^a}-1\right)\right]e^{\varepsilon_t^{I_a}}\\
&+\beta_a\frac{\lambda_{o,t+1}^a}{\lambda_{o,t}^a}q_{t+1}^a
\upsilon_a\left(\frac{I_{o,t+1}^a}{I_{o,t}^a}\right)^2
\left(\frac{I_{o,t+1}^a}{I_{o,t}^a}-1\right)e^{\varepsilon_{t+1}^{I_a}} .
\end{aligned}
\tag{F22 implementation_cross_check needs_review}
```

`needs_review`: F17-F22 are not printed in the main article. They are included to document coverage against the existing MMB implementation only.

### 3.4 Labor supply and wage setting

The household labor-force participation condition printed by the source is:

```math
\lambda_{x,t}^a
\left[
(1-\tau_t^{w,a})(w_t^aN_t^{P,a}+w_t^{G,a}N_t^{G,a})
+UB^a(L_{x,t}^a-N_t^a)
\right]
=N_t^a\kappa_a^w e^{\varepsilon_t^{N_a}}(L_{x,t}^a)^{\varphi_a},
\quad x\in\{o,r\}.
\tag{F23}
```

The labor agency yields variety demand:

```math
N_t^{P,a}(\mathfrak h)
=\left(\frac{W_t^a(\mathfrak h)}{W_t^a}\right)^{-\theta_{a,t}^w}N_t^{P,a}.
\tag{F24}
```

The wage-setting FOC is not printed in the paper and is marked:

```math
\text{Rotemberg union wage FOC linking } \pi_{w,t}^a,\,\lambda_{o,t}^a,\,\lambda_{r,t}^a,\,N_t^{P,a},\,L_{o,t}^a,\,L_{r,t}^a,\text{ and wage-adjustment costs.}
\tag{F25 needs_review}
```

### 3.5 Price setting

The Rotemberg price-setting FOC is not fully derived in the paper. The implementation cross-check uses:

```math
\begin{aligned}
&(1-\theta_{a,t})+\theta_{a,t}mc_t^a(pr_{aa,t})^{-1}
+\beta_a\frac{\lambda_{o,t+1}^a}{\lambda_{o,t}}
\upsilon_p^a
\left(\frac{\pi_{aa,t+1}}{\pi_{aa,t}^{\xi_a^p}\pi_{ss}^{1-\xi_a^p}}-1\right)
\frac{\pi_{aa,t+1}^2}{\pi_{t+1}^a y_t^a}
\frac{y_{t+1}^a}{\pi_{aa,t}^{\xi_a^p}\pi_{ss}^{1-\xi_a^p}}\\
&\quad=
\upsilon_p^a
\left(\frac{\pi_{aa,t}}{\pi_{aa,t-1}^{\xi_a^p}\pi_{ss}^{1-\xi_a^p}}-1\right)
\frac{\pi_{aa,t}}{\pi_{aa,t-1}^{\xi_a^p}\pi_{ss}^{1-\xi_a^p}} .
\end{aligned}
\tag{F26 implementation_cross_check needs_review}
```

`needs_review`: the exact source-level price Phillips curve must be verified against the equation summary; the formula above records the available implementation shape only.

## 4. Market Clearing & Identities

Aggregate household variables combine optimizers and RoT households:

```math
X_t^a=(1-\mu^a)X_{o,t}^a+\mu^aX_{r,t}^a,
\quad X\in\{C,L\}.
\tag{F27}
```

For optimizer-only stocks and flows, the source states:

```math
X_t^a=(1-\mu^a)X_{o,t}^a,
\quad X\in\{K,I,B^{G}\}.
\tag{F28}
```

Total employment, labor force, and unemployment are:

```math
N_t^a=N_t^{P,a}+N_t^{G,a},\qquad
L_t^a=(1-\mu^a)L_{o,t}^a+\mu^aL_{r,t}^a,\qquad
UR_t^a=\frac{L_t^a-N_t^a}{L_t^a}.
\tag{F29}
```

Government debt evolves as:

```math
B_t^{G,a}=\frac{1+i_{t-1}^{G,a}}{\pi_t^a}B_{t-1}^{G,a}+PD_t^a.
\tag{F30}
```

Primary government expenditures are:

```math
\begin{aligned}
G_t^a={}&R_t^{a,a}(C_t^{G,a}+I_t^{G,a})
+UB^a\left[\mu^a(L_{r,t}^a-N_t^a)+(1-\mu^a)(L_{o,t}^a-N_t^a)\right]\\
&+(1+\tau_t^{sc,a})N_t^{G,a}w_t^{G,a}+TR_t^a .
\end{aligned}
\tag{F31}
```

Primary revenues are:

```math
\begin{aligned}
Rev_t^a={}&(\tau_t^{w,a}+\tau_t^{sc,a})(w_t^aN_t^{P,a}+w_t^{G,a}N_t^{G,a})
+\tau_t^{k,a}(r_t^{k,a}-\delta_a)K_{t-1}^a\\
&+\tau_t^{c,a}C_t^a+T_{o,t}^a .
\end{aligned}
\tag{F32}
```

Public capital and public-good productivity are:

```math
K_t^{G,a}=(1-\delta_a^G)K_{t-1}^{G,a}+I_t^{G,a},
\qquad
yG_t^a=z_a(K_t^{G,a})^{\eta_k^G,a}(N_t^{G,a})^{\eta_n^G,a}.
\tag{F33 needs_review}
```

Transfer distribution between household types is:

```math
\bar\mu^a\left(\frac{TR_{o,t}^a}{\overline{TR}_o^a}-1\right)
=(1-\bar\mu^a)\left(\frac{TR_{r,t}^a}{\overline{TR}_r^a}-1\right).
\tag{F34}
```

Country-`a` market clearing for goods produced in `a` is:

```math
\begin{aligned}
Y_t^a={}&C_t^{G,a}+I_t^{G,a}+C_t^{a,a}+I_t^{a,a}
+\frac{n_b^a}{n_a^b}(C_t^{b,a}+I_t^{b,a})\\
&+\frac{n_c^a}{n_a^c}(C_t^{c,a}+I_t^{c,a})+ADJ_t^a .
\end{aligned}
\tag{F35}
```

National-accounting GDP adds public employment wage costs to private-sector output:

```math
GDP_t^a=Y_t^a+\frac{(1+\tau_t^{sc,a})w_t^{G,a}n_t^{G,a}}{R_t^{a,a}}.
\tag{F36}
```

Rest-of-world demand for goods from country `j` is approximated by:

```math
C_t^{c,j}+I_t^{c,j}
=n_j^cR_t^{c,j}(g^{c,c}+g^{c,i})e^{\varepsilon_t^{c,j}}Y_t^c,
\quad j\in\{a,b\}.
\tag{F37}
```

Country-`a` net foreign assets are:

```math
\begin{aligned}
nfa_t^a={}&rer_t^{a,c}B_t^{a,c}+B_t^a\\
={}&(1+i_{t-1}^{a,c})\frac{rer_t^{a,c}B_{t-1}^{a,c}}{\pi_t^c}
+(1+i_{t-1}^{b,a})\frac{B_{t-1}^a}{\pi_t^a}
+R_t^{a,a}Y_t^a-C_t^a-I_t^a-C_t^{G,a}-I_t^{G,a}.
\end{aligned}
\tag{F38}
```

Country-`b` net foreign assets are analogous:

```math
\begin{aligned}
nfa_t^b={}&rer_t^{b,c}B_t^{b,c}+rer_t^{b,a}B_t^{b,a}\\
={}&(1+i_{t-1}^{b,c})\frac{rer_t^{b,c}B_{t-1}^{b,c}}{\pi_t^c}
+(1+i_{t-1}^{b,a})\frac{rer_t^{b,a}B_{t-1}^{b,a}}{\pi_t^a}
+R_t^{b,b}Y_t^b-C_t^b-I_t^b-C_t^{G,b}-I_t^{G,b}.
\end{aligned}
\tag{F39}
```

Bond-market clearing for the rest-of-world bond position is:

```math
B_t^c=-\left(\frac{\mathcal P^a}{\mathcal P^c}B_t^{a,c}
+\frac{\mathcal P^b}{\mathcal P^c}B_t^{b,c}\right).
\tag{F40}
```

Relative real exchange rates and nominal exchange-rate changes satisfy:

```math
rer_t^{c,a}=\frac{1}{rer_t^{a,c}},
\qquad
rer_t^{b,c}=\frac{rer_t^{b,a}}{rer_t^{c,a}},
\qquad
\Delta S_t^{a,c}=\frac{\pi_t^a(rer_t^{a,c}/rer_{t-1}^{a,c})}{\pi_t^c}.
\tag{F41 needs_review}
```

`needs_review`: the source line contains duplicated/malformed `rer` notation and should be checked against the equation summary.

## 5. Exogenous Processes

The source describes 41 structural shocks. Except fiscal and monetary policy shocks, all non-policy shocks follow AR(1) processes:

```math
\varepsilon_t^{X,i}=\rho^X\varepsilon_{t-1}^{X,i}+\nu_t^X,\quad i\in\{a,b\}.
\tag{F42}
```

Markup shocks follow AR(1) processes in transformed markups:

```math
\frac{\theta_{a,t}}{\theta_{a,t}-1}
=\rho_{\theta_a}\frac{\theta_{a,t-1}}{\theta_{a,t-1}-1}
+(1-\rho_{\theta_a})\frac{\bar\theta_a}{\bar\theta_a-1}
+\nu_t^{\theta_a}.
\tag{F43 needs_review}
```

Fiscal spending instruments follow log rules:

```math
\begin{aligned}
\log\left(\frac{X_t}{\bar X}\right)
={}&\rho^{X,a}\log\left(\frac{X_{t-1}}{\bar X}\right)
-\xi^{X,B^{G,a},a}\log\left(\frac{B_{t-1}^{G,a}}{\bar B^{G,a}}\right)
-\xi^{X,y,a}\log\left(\frac{Y_{t-1}^a}{\bar Y^a}\right)\\
&+\psi^{X,a}\nu_t^{X,a}+(1-\psi^{X,a})\nu_{t-1}^{X,a},
\end{aligned}
\tag{F44}
```

for:

```math
X\in\{C^{G,a},I^{G,a},TR^a,w^{G,a}\}.
\tag{F45}
```

Fiscal revenue/employment instruments follow level-deviation rules:

```math
\begin{aligned}
X_t-\bar X
={}&\rho^{X,a}(X_{t-1}-\bar X)
+\xi^{X,B^{G,a},a}\log\left(\frac{B_{t-1}^{G,a}}{\bar B^{G,a}}\right)
+\xi^{X,y,a}\log\left(\frac{Y_{t-1}^a}{\bar Y^a}\right)\\
&+\psi^{X,a}\nu_t^{X,a}+(1-\psi^{X,a})\nu_{t-1}^{X,a},
\end{aligned}
\tag{F46}
```

for:

```math
X\in\{\tau^{w,a},\tau^{sc,a},\tau^{k,a},T_o^a,N^{G,a}\}.
\tag{F47 needs_review}
```

The monetary authority sets one Euro-area policy rate:

```math
\begin{aligned}
\log\left(\frac{1+i_t^{EA}}{1+\bar i^{EA}}\right)
={}&\rho_i^a\log\left(\frac{1+i_{t-1}^{EA}}{1+\bar i^{EA}}\right)
+(1-\rho_i^a)\phi_\pi^{EA}
\left[
s\log\left(\frac{\pi_t^a}{\bar\pi^a}\right)
+(1-s)\log\left(\frac{\pi_t^b}{\bar\pi^b}\right)
\right]\\
&+(1-\rho_i^a)\phi_y^{EA}
\left[
s\log\left(\frac{Y_t^a}{\bar Y^a}\right)
+(1-s)\log\left(\frac{Y_t^b}{\bar Y^b}\right)
\right]
+\nu_t^{M^{EA}} .
\end{aligned}
\tag{F48}
```

The policy rate is linked to country rates by:

```math
\log\left(\frac{1+i_t^{EA}}{1+\bar i^{EA}}\right)
=s\log\left(\frac{1+i_t^a}{1+\bar i^a}\right)
+(1-s)\log\left(\frac{1+i_t^b}{1+\bar i^b}\right).
\tag{F49}
```

International risk premia satisfy:

```math
1+i_t^{i,j}
=(1+i_t^j)
\left[
1-\phi\left(
\exp\left(\frac{rer_t^{i,j}B_t^{i,j}}{R_t^{i,i}Y_t^i}
-\frac{\bar B^{i,j}}{\bar R^{i,i}\bar Y^i}\right)-1
\right)
\right],
\quad i\ne j.
\tag{F50 needs_review}
```

`needs_review`: the source text around the steady-state denominator has OCR damage and inconsistent `Y^j`/`Y^i` rendering.

The rest-of-world SVAR is:

```math
\begin{pmatrix}
\hat Y_t^c\\
\hat\pi_t^c\\
\hat i_t^c\\
\varepsilon_t^{A_g}
\end{pmatrix}
=
A
\begin{pmatrix}
\hat Y_{t-1}^c\\
\hat\pi_{t-1}^c\\
\hat i_{t-1}^c\\
\varepsilon_{t-1}^{A_g}
\end{pmatrix}
+C
\begin{pmatrix}
\nu_t^{Y,c}\\
\nu_t^{\pi,c}\\
\nu_t^{i,c}\\
\nu_t^{A_g}
\end{pmatrix}.
\tag{F51}
```

## 6. Steady-State Solution

The source says that the model has an analytically solved asymmetric steady state, but the complete derivation is available upon request and is not printed in the Markdown. Therefore this section records source-backed steady-state restrictions rather than a full computable `steady_state_model`.

At steady state, policy shocks and non-policy innovations are zero:

```math
\nu^X=0,\qquad \varepsilon^X=0 \text{ for stationary AR(1) shocks}.
\tag{F52 needs_review}
```

Investment pins down private capital from the capital accumulation equation:

```math
\bar I_o^a=\delta_a\bar k_o^a
\quad\text{when } \varepsilon^{I_a}=0 \text{ and adjustment costs are zero}.
\tag{F53 needs_review}
```

Public capital is pinned down by public investment:

```math
\bar I^{G,a}=\delta_a^G\bar K^{G,a}.
\tag{F54 needs_review}
```

Government debt is stationary only if fiscal rules satisfy the source condition that at least one debt-feedback coefficient is positive:

```math
\exists X:\xi^{X,B^{G,a},a}>0 .
\tag{F55 needs_review}
```

The long-run relative price and inflation targets are embedded in the CPI/PPI blocks, fiscal rules, and Taylor rule. Tables 1 and 2 in the source contain calibrated parameters and targeted steady-state values, but the OCR Markdown mainly stores these tables as images, so the numeric steady-state calibration is not source-extracted here.

## 7. Timing & Form Conventions

- **Capital timing**: private production uses `K_{t-1}` while the law of motion determines `K_t`; public capital follows the same end-of-period stock convention.
- **Government debt timing**: `B_t^{G,a}` is the end-of-period real government debt stock; the budget law uses `B_{t-1}^{G,a}` and `i_{t-1}^{G,a}`.
- **Households**: optimizers carry private domestic bonds, foreign bonds, government bonds, and physical capital; RoT households do not save or borrow.
- **Monetary union**: countries `a` and `b` have one common policy rate but separate country rates linked by the population-weighted relation in (F49).
- **Rest of world**: `c` is a VAR block rather than a fully micro-founded DSGE region in this paper version.
- **Price/wage adjustment**: source text specifies Rotemberg adjustment costs with indexation to lagged and steady-state inflation. Exact wage FOCs require the unavailable equation summary.
- **Model form**: nonlinear levels with selected log-deviation policy and VAR processes; not a pure `model(linear)` derivation.
- **Implementation cross-check**: `.agents/skills/dynare-copilot/references/examples/DEREA_GEAR16_rep.mod` confirms broad variable coverage, country-`a`/country-`b` symmetry, fiscal shocks, and nonlinear timing. It is not used as paper-side mathematical evidence.

## 8. Variable & Parameter Reference Table

### Endogenous variables and equation coverage

| Category | Symbol / ASCII hint | Meaning | Main equation(s) |
|---|---|---|---|
| Endogenous | `y_a_t`, `y_b_t` | private-sector output in Germany/rest of Euro area | (F3), (F35) |
| Endogenous | `GDP_a_t`, `GDP_b_t` | national-accounting GDP including public wage bill | (F36) |
| Endogenous | `c_o_a_t`, `c_r_a_t`, `c_a_t` | optimizer, RoT, and aggregate consumption | (F7), (F8), (F27) |
| Endogenous | `in_o_a_t`, `in_a_t` | optimizer and aggregate private investment | (F10), (F22), (F28) |
| Endogenous | `k_o_a_t`, `k_a_t` | optimizer and aggregate private capital | (F10), (F28) |
| Endogenous | `lambda_o_a_t`, `lambda_r_a_t` | marginal utilities of consumption | (F19) |
| Endogenous | `nP_a_t`, `nG_a_t`, `n_a_t` | private, public, and total employment | (F29) |
| Endogenous | `l_o_a_t`, `l_r_a_t`, `l_a_t`, `ur_a_t` | labor force by type, aggregate labor force, unemployment rate | (F23), (F29) |
| Endogenous | `wr_a_t`, `wrG_a_t`, `pi_w_a_t` | private wage, public wage, wage inflation | (F12), (F25) |
| Endogenous | `rk_a_t`, `Rk_a_t`, `q_a_t` | rental rate, effective capital return, Tobin's Q | (F15), (F20), (F21), (F22) |
| Endogenous | `mcr_a_t` | real marginal cost | (F16), (F26) |
| Endogenous | `pi_a_t`, `pi_aa_t` | CPI and producer inflation | (F14), (F26), (F48) |
| Endogenous | `pr_aa_t`, `pr_ab_t`, `pr_ac_t` | relative prices | (F7), (F35), (F41) |
| Endogenous | `cG_a_t`, `inG_a_t`, `TR_a_t`, `T_a_t` | fiscal spending, investment, transfers, lump-sum taxes | (F31), (F34), (F44), (F46) |
| Endogenous | `tauw_a_t`, `tausc_a_t`, `tauk_a_t`, `tauc_a_t` | labor, social contribution, capital, and consumption taxes | (F32), (F46), (F47) |
| Endogenous | `BG_a_t`, `i_Ga_t` | government debt and government bond rate | (F18), (F30) |
| Endogenous | `kG_a_t`, `yG_a_t` | public capital and public-good productivity term | (F33) |
| Endogenous | `i_policy_t`, `i_a_t`, `i_b_t` | common policy rate and country rates | (F48), (F49) |
| Endogenous | `B_ac_t`, `B_bc_t`, `B_ba_t`, `nfa_a_t`, `nfa_b_t`, `nfa_c_t` | international bond positions and net foreign assets | (F38), (F39), (F40), (F50) |
| Endogenous | `rer_ba_t`, `rer_ca_t`, `rer_bc_t`, `Del_S_ac_t`, `Del_S_bc_t` | real exchange rates and nominal exchange-rate changes | (F41) |
| Endogenous | `y_c_var_t`, `pi_c_var_t`, `i_c_var_t`, `y_c_t` | rest-of-world VAR variables | (F51) |

### Exogenous shocks

| Category | ASCII hint | Meaning | Main equation(s) |
|---|---|---|---|
| Exogenous | `nua_a`, `nub_a`, `eps_z_g` | domestic and global technology innovations | (F42), (F51) |
| Exogenous | `nua_etheta`, `nub_etheta` | price markup innovations | (F43) |
| Exogenous | `nua_ethetaw`, `nub_ethetaw` | wage markup innovations | (F42) |
| Exogenous | `nua_eb`, `nub_eb` | preference innovations | (F6), (F42) |
| Exogenous | `nua_en`, `nub_en` | labor supply innovations | (F23), (F42) |
| Exogenous | `nua_ein`, `nub_ein` | private investment innovations | (F10), (F22), (F42) |
| Exogenous | `nua_erp`, `nub_erp` | risk-premium/UIP innovations | (F17), (F42), (F50) |
| Exogenous | `nua_ecG`, `nub_ecG` | public consumption shocks | (F44) |
| Exogenous | `nua_einG`, `nub_einG` | public investment shocks | (F44), (F54) |
| Exogenous | `nua_eTR`, `nub_eTR`, `nua_eT`, `nub_eT` | transfer and lump-sum tax shocks | (F44), (F46) |
| Exogenous | `nua_etauw`, `nub_etauw`, `nua_etausc`, `nub_etausc`, `nua_etauc`, `nub_etauc`, `nua_etauk`, `nub_etauk` | tax-rate and social-contribution shocks | (F46), (F47) |
| Exogenous | `nua_enG`, `nub_enG`, `nua_emg`, `nub_emg` | public employment and public wage shocks | (F44), (F46) |
| Exogenous | `nua_RoW`, `nub_RoW`, `nua_RoE`, `nub_RoE` | foreign demand/trade-preference shocks | (F37), (F42) |
| Exogenous | `eps_y_c`, `eps_i_c`, `eps_pi_c` | rest-of-world VAR shocks | (F51) |
| Exogenous | `nua_eM` | monetary policy shock | (F48) |

### Parameters

| Category | ASCII hint | Meaning | Source status |
|---|---|---|---|
| Parameter | `mu_a`, `mu_b` | share of RoT households | source and implementation cross-check |
| Parameter | `betta_a`, `betta_b` | subjective discount factors | source and implementation cross-check |
| Parameter | `delta_a`, `delta_b` | private capital depreciation | source and implementation cross-check |
| Parameter | `sigma_a`, `sigma_b` | consumption curvature | source and implementation cross-check |
| Parameter | `hab_a`, `hab_b` | external habit persistence | source and implementation cross-check |
| Parameter | `rho_a`, `rho_b` / `alpha_a`, `alpha_b` | private capital share | source and implementation cross-check naming differs |
| Parameter | `eta_kG_a`, `eta_nG_a` | public capital/public employment productivity elasticities | source and implementation cross-check |
| Parameter | `upsilon_a`, `upsilon_b` | private investment adjustment costs | source and implementation cross-check |
| Parameter | `upsilon_p_a`, `upsilon_w_a` | price and wage Rotemberg costs | source and implementation cross-check |
| Parameter | `theta_a`, `thetaw_a` | goods and labor substitution/markup parameters | source and implementation cross-check |
| Parameter | `xip_a`, `xiw_a` | price and wage indexation | source and implementation cross-check |
| Parameter | `tauw_a`, `tausc_a`, `tauk_a`, `tauc_a` | steady-state tax/social-contribution rates | source and implementation cross-check |
| Parameter | `rho_*`, `xi_*`, `psi_*` | persistence, debt/output feedback, and anticipation parameters in fiscal rules | source and implementation cross-check |
| Parameter | `rho_a_i`, `phi_a_pi`, `phi_a_y` | Taylor-rule smoothing and response coefficients | source and implementation cross-check |
| Parameter | `phi` | international bond risk-premium parameter | source and implementation cross-check |
| Parameter | `a11...a44`, `c11...c44` | rest-of-world VAR coefficients | source and implementation cross-check |

First-pass equation coverage is incomplete by design because the article does not print the complete equation summary, FOCs, or steady-state derivation. The entry should remain `needs_review` until those source-side documents or targeted PDF checks are incorporated.
