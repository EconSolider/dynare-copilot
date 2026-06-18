# NK_ADE25cpi -- Derivation (Optimization Problems + First-Order Conditions)

> Archive status: `needs_review`. This first-pass derivation is source-backed by the main paper Markdown and the author-site online appendix. Runtime validation was not performed.

Source: Auray, Stephane; Devereux, Micheal; Eyquem, Aurelien (2025), "Trade Wars and the Optimal Design of Monetary Rules," *Journal of Monetary Economics*, DOI `10.1016/j.jmoneco.2024.103726`.

Model ID: `NK_ADE25cpi`. The MMB implementation cross-check indicates the CPI-targeting variant of `NK_ADE25`, with the PPI-targeting sibling stored as `NK_ADE25ppi`.

## 1. Model Overview

- **Model**: Two-country New Keynesian open-economy model with endogenous import tariffs, producer-currency pricing, Rotemberg price adjustment costs, home bias in consumption and intermediate inputs, internationally traded bonds, and monopoly distortions.
- **Policy experiment**: Trade-policy authorities set discretionary Nash tariffs. Monetary policy follows inflation-targeting interest-rate rules. In `NK_ADE25cpi`, the target inflation index is CPI inflation.
- **Agents**: Home and Foreign households consume domestic and imported goods, supply labor, and trade bonds; monopolistically competitive producers set domestic-currency prices; governments rebate tariff revenue and set tariffs; central banks set nominal interest rates.
- **Form**: Nonlinear equilibrium system solved around steady state and used for first-order simulation/optimal-control comparisons. The equations below are not hand-log-linearized.
- **Provenance note**: The main paper states that the full two-country equilibrium is in Online Appendix C. The appendix PDF supplies equations (C.1)-(C.54); formulas marked `needs_review` should be checked against the PDF typeset equations before promotion.

## 2. Optimization Problems

### 2.1 Home Household

The Home household chooses consumption of domestic and imported goods, labor, and bond positions:

```math
\max_{\{C_{h,t},C_{f,t},H_t,B_t,B_t^{\ast}\}} E_t\sum_{j=0}^{\infty}\beta^j
\left(\frac{C_{t+j}^{1-\sigma}}{1-\sigma}-\chi\frac{H_{t+j}^{1+\psi}}{1+\psi}\right)
```

subject to the CES consumption aggregator and budget constraint:

```math
C_t=\left[\gamma^{1/\lambda}C_{h,t}^{1-1/\lambda}+(1-\gamma)^{1/\lambda}C_{f,t}^{1-1/\lambda}\right]^{1/(1-1/\lambda)}
```

```math
S_tB_t^{\ast}+B_t+P_{h,t}C_{h,t}+(1+\tau_t)S_tP_{f,t}^{\ast}C_{f,t}+P_t\Lambda_t
=S_tB_{t-1}^{\ast}R_{t-1}^{\ast}+B_{t-1}R_{t-1}+W_tH_t+\Pi_t+TR_t .
```

### 2.2 Foreign Household

The Foreign household has symmetric preferences over $`C_t^{\ast}`$ and $`H_t^{\ast}`$, with consumption aggregator:

```math
C_t^{\ast}=\left[\gamma^{\ast1/\lambda}C_{f,t}^{\ast1-1/\lambda}+(1-\gamma^{\ast})^{1/\lambda}C_{h,t}^{\ast1-1/\lambda}\right]^{1/(1-1/\lambda)} .
```

In Appendix C, Foreign households hold local bonds without the Home adjustment cost. Appendix D modifies the bond-denomination structure for the US-China exercise; this is recorded as a variant-specific issue in `extraction_notes.md`.

### 2.3 Home Firms

Each Home producer chooses factor inputs and a price $`P_{h,t}(i)`$ under demand
$`Y_t(i)=(P_{h,t}(i)/P_{h,t})^{-\epsilon}Y_t`$ and production:

```math
Y_t(i)=A_tH_t(i)^{1-\alpha}X_t(i)^\alpha .
```

The intermediate-input aggregator is:

```math
X_t(i)=\left[\gamma_x^{1/\lambda}X_{h,t}(i)^{1-1/\lambda}
+(1-\gamma_x)^{1/\lambda}X_{f,t}(i)^{1-1/\lambda}\right]^{1/(1-1/\lambda)} .
```

The Rotemberg pricing problem maximizes expected discounted profits net of price-adjustment costs:

```math
E_t\sum_{j=0}^{\infty}\omega_{t+j}
\left[\Pi_{t+j}(i)-\frac{\phi}{2}\left(\frac{P_{h,t+j}(i)}{P_{h,t+j-1}(i)}-1\right)^2P_{h,t+j}(i)Y_{t+j}(i)\right].
```

Foreign firms solve the symmetric problem.

### 2.4 Trade And Monetary Authorities

Under discretionary trade policy, Home chooses $`\tau_t`$ to maximize household welfare subject to the equilibrium system, taking future policy as given; Foreign chooses $`\tau_t^{\ast}`$ symmetrically. In the `NK_ADE25cpi` variant, each central bank targets CPI inflation through an interest-rate rule rather than PPI inflation.

## 3. First-Order Conditions

### Households And Demand

- **(F1) Home consumption price index**:

```math
P_t=\left[\gamma P_{h,t}^{1-\lambda}+(1-\gamma)\left((1+\tau_t)S_tP_{f,t}^{\ast}\right)^{1-\lambda}\right]^{1/(1-\lambda)} .
```

- **(F2) Home demand for domestic goods**:

```math
C_{h,t}=\gamma\left(\frac{P_{h,t}}{P_t}\right)^{-\lambda}C_t .
```

- **(F3) Home demand for imported goods**:

```math
C_{f,t}=(1-\gamma)\left(\frac{(1+\tau_t)S_tP_{f,t}^{\ast}}{P_t}\right)^{-\lambda}C_t .
```

- **(F4) Home Euler equation for local-currency bonds**:

```math
\beta E_t\left[\frac{R_tP_tC_t^\sigma}{\pi_{h,t+1}P_{t+1}C_{t+1}^\sigma}\right]=1 .
```

- **(F5) Home labor supply**:

```math
\chi H_t^\psi C_t^\sigma=\frac{W_t}{P_t}.
```

- **(F6) Foreign consumption price index**:

```math
P_t^{\ast}=\left[\gamma^{\ast}P_{f,t}^{\ast1-\lambda}+(1-\gamma^{\ast})\left(\frac{(1+\tau_t^{\ast})P_{h,t}}{S_t}\right)^{1-\lambda}\right]^{1/(1-\lambda)} .
```

- **(F7) Foreign Euler equation**:

```math
\beta E_t\left[\frac{R_t^{\ast}P_t^{\ast}C_t^{\ast\sigma}}{\pi_{f,t+1}^{\ast}P_{t+1}^{\ast}C_{t+1}^{\ast\sigma}}\right]=1 .
```

- **(F8) Foreign labor supply**:

```math
\chi H_t^{\ast\psi}C_t^{\ast\sigma}=\frac{W_t^{\ast}}{P_t^{\ast}}.
```

### Firms

- **(F9) Home intermediate-input price index**:

```math
P_{x,t}=\left[\gamma_xP_{h,t}^{1-\lambda}+(1-\gamma_x)\left((1+\tau_t)S_tP_{f,t}^{\ast}\right)^{1-\lambda}\right]^{1/(1-\lambda)} .
```

- **(F10) Home factor demands**:

```math
(1-\alpha)MC_tY_t=W_tH_t,\qquad \alpha MC_tY_t=P_{x,t}X_t .
```

- **(F11) Home real marginal cost**:

```math
MC_t=\frac{W_t^{1-\alpha}P_{x,t}^{\alpha}}{A_t\alpha^\alpha(1-\alpha)^{1-\alpha}P_{h,t}} .
```

- **(F12) Home Rotemberg Phillips curve**:

```math
\theta+\frac{\phi}{\epsilon}\left[\pi_{h,t}(\pi_{h,t}-1)-E_t\left\{\omega_{t+1}\pi_{h,t+1}(\pi_{h,t+1}-1)\frac{Y_{t+1}}{Y_t}\right\}\right]=MC_t .
```

- **(F13) Foreign intermediate-input price index**:

```math
P_{x,t}^{\ast}=\left[\gamma_x^{\ast}P_{f,t}^{\ast1-\lambda}+(1-\gamma_x^{\ast})\left(\frac{(1+\tau_t^{\ast})P_{h,t}}{S_t}\right)^{1-\lambda}\right]^{1/(1-\lambda)} .
```

- **(F14) Foreign Rotemberg Phillips curve** (`needs_review`: Appendix OCR alternates between $`MC_t^{\ast}`$ and $`\epsilon MC_t^{\ast}`$ in the reduced display):

```math
\theta+\frac{\phi}{\epsilon}\left[\pi_{f,t}^{\ast}(\pi_{f,t}^{\ast}-1)-E_t\left\{\omega_{t+1}^{\ast}\pi_{f,t+1}^{\ast}(\pi_{f,t+1}^{\ast}-1)\frac{Y_{t+1}^{\ast}}{Y_t^{\ast}}\right\}\right]=MC_t^{\ast} .
```

- **(F15) Home production**:

```math
Y_t=A_tH_t^{1-\alpha}X_t^\alpha .
```

- **(F16) Foreign production**:

```math
Y_t^{\ast}=A_t^{\ast}H_t^{\ast1-\alpha}X_t^{\ast\alpha}.
```

### Monetary And Trade Policy

- **(F17) Home CPI inflation definition**:

```math
\pi_{cpi,t}=\pi_{h,t}\frac{\mathcal{P}_t}{\mathcal{P}_{t-1}},\qquad
\mathcal{P}_t=P_t/P_{h,t}.
```

- **(F18) Foreign CPI inflation definition**:

```math
\pi_{cpi,t}^{\ast}=\pi_{f,t}^{\ast}\frac{\mathcal{P}_t^{\ast}}{\mathcal{P}_{t-1}^{\ast}},\qquad
\mathcal{P}_t^{\ast}=P_t^{\ast}/P_{f,t}^{\ast} .
```

- **(F19) Home CPI-targeting monetary rule**:

```math
R_t=\beta^{-1}\left(\frac{\pi_{cpi,t}}{\Pi_h^{tar}}\right)^{\mu_\pi}\exp(\varepsilon_{R,t}) .
```

- **(F20) Foreign CPI-targeting monetary rule**:

```math
R_t^{\ast}=\beta^{-1}\left(\frac{\pi_{cpi,t}^{\ast}}{\Pi_f^{tar}}\right)^{\mu_\pi^{\ast}}\exp(\varepsilon_{R,t}^{\ast}) .
```

- **(F21) Home tariff process in the MMB cross-check**:

```math
\tau_t=\bar{\tau}+e_{\tau,t}.
```

- **(F22) Foreign tariff process in the MMB cross-check**:

```math
\tau_t^{\ast}=\bar{\tau}^{\ast}+e_{\tau,t}^{\ast}.
```

## 4. Market Clearing & Identities

- **(F23) Home goods market clearing with Rotemberg resource cost**:

```math
Y_t\left[1-\frac{\phi}{2}(\pi_{h,t}-1)^2\right]=D_t+D_{x,t}^{\ast} .
```

- **(F24) Foreign goods market clearing with Rotemberg resource cost**:

```math
Y_t^{\ast}\left[1-\frac{\phi}{2}(\pi_{f,t}^{\ast}-1)^2\right]=D_t^{\ast}+D_{x,t}.
```

- **(F25) Home absorption of Home goods**:

```math
D_t=\gamma\mathcal{P}_t^\lambda(C_t+\Lambda_t)+\gamma_x\mathcal{P}_{x,t}^\lambda X_t .
```

- **(F26) Foreign absorption of Foreign goods**:

```math
D_t^{\ast}=\gamma^{\ast}\mathcal{P}_t^{\ast\lambda}C_t^{\ast}+\gamma_x^{\ast}\mathcal{P}_{x,t}^{\ast\lambda}X_t^{\ast} .
```

- **(F27) Home exports to Foreign**:

```math
D_{x,t}^{\ast}=\frac{1-n}{n}\left(\frac{S_t}{1+\tau_t^{\ast}}\right)^\lambda
\left[(1-\gamma^{\ast})\mathcal{P}_t^{\ast\lambda}C_t^{\ast}+(1-\gamma_x^{\ast})\mathcal{P}_{x,t}^{\ast\lambda}X_t^{\ast}\right].
```

- **(F28) Foreign exports to Home**:

```math
D_{x,t}=\frac{n}{1-n}\left(\frac{1}{S_t(1+\tau_t)}\right)^\lambda
\left[(1-\gamma)\mathcal{P}_t^\lambda(C_t+\Lambda_t)+(1-\gamma_x)\mathcal{P}_{x,t}^\lambda X_t\right].
```

- **(F29) Net foreign asset market clearing**:

```math
nb_t+(1-n)\frac{S_tP_t^{\ast}}{P_t}b_t^{\ast}=0 .
```

- **(F30) UIP with portfolio-adjustment cost**:

```math
E_t\left[\frac{S_{t+1}\omega_{t+1}}{S_t\omega_{t+1}^{\ast}(1+\nu(b_t-\bar{b}))}-1\right]=0 .
```

- **(F31) Home net foreign asset accumulation**:

```math
b_t-\frac{S_tP_{t-1}}{S_{t-1}P_t\omega_t^{\ast}}b_{t-1}-P_t^{-1}\left(D_{x,t}^{\ast}-\frac{1-n}{n}S_tD_{x,t}\right)=0 .
```

## 5. Exogenous Processes

- **(F32) Home productivity**:

```math
\log A_t=\rho_a\log A_{t-1}+\varepsilon_{A,t}.
```

- **(F33) Foreign productivity**:

```math
\log A_t^{\ast}=\rho_a^{\ast}\log A_{t-1}^{\ast}+\varepsilon_{A,t}^{\ast}.
```

- **(F34) Home monetary-policy shock**:

```math
\varepsilon_{R,t}=\rho_R\varepsilon_{R,t-1}+u_{R,t}.
```

- **(F35) Foreign monetary-policy shock**:

```math
\varepsilon_{R,t}^{\ast}=\rho_R^{\ast}\varepsilon_{R,t-1}^{\ast}+u_{R,t}^{\ast}.
```

## 6. Steady-State Solution

The paper reports calibrated and estimated steady states; the archive entry does not recompute them. For the symmetric annual calibration in the main text, the relevant conditions are:

1. Set $`\bar{A}=\bar{A}^{\ast}=1`$, $`\bar{b}=\bar{b}^{\ast}=0`$, $`\bar{\pi}_h=\bar{\pi}_f^{\ast}=\bar{\pi}_{cpi}=\bar{\pi}_{cpi}^{\ast}=1`$, and zero policy innovations.
2. From (F4) and (F7), $`\bar{R}=\bar{R}^{\ast}=1/\beta`$ when inflation targets equal one.
3. With zero inflation, Rotemberg costs vanish and (F23)-(F24) reduce to $`\bar{Y}=\bar{D}+\bar{D}_x^{\ast}`$ and $`\bar{Y}^{\ast}=\bar{D}^{\ast}+\bar{D}_x`$.
4. With monopoly distortions not offset by subsidies, the steady-state markup wedge is governed by $`\theta=(1+s)(\epsilon-1)/\epsilon<1`$; when the first-best subsidy is used, $`\theta=1`$.
5. In the symmetric trade-war steady state, $`\bar{S}=1`$, $`\bar{\tau}=\bar{\tau}^{\ast}`$, and the CPI rule affects the discretionary tariff equilibrium through the tariff-adjusted relative price $`\mathcal{P}_t`$.
6. The MMB `NK_ADE25cpi.mod` cross-check stores one symmetric steady state with $`\beta=0.99`$, $`\lambda=5`$, $`\epsilon=6`$, $`\alpha=0.4`$, $`\phi=40`$, and CPI inflation as the modelbase inflation variable. These values are implementation evidence, not independent paper-source equations.

`needs_review`: The exact MMB steady-state values should be reconciled against the model-specific `.json`/`.mod` files in a later implementation validation phase.

## 7. Timing & Form Conventions

- Bonds are stock variables decided for payoffs between $`t`$ and $`t+1`$; Appendix C includes both Home and Foreign bond positions and a portfolio-adjustment wedge.
- $`S_t`$ is the nominal exchange rate / terms-of-trade object after normalization; Home terms of trade are represented by the relative price of the Foreign good in Home goods.
- $`P_t/P_{h,t}`$ and $`P_t^{\ast}/P_{f,t}^{\ast}`$ are tariff-adjusted relative CPI terms. The `cpi` variant targets CPI inflation, so monetary policy reacts to $`\pi_h`$ plus movement in this relative CPI component.
- Prices are producer-currency prices. Price stickiness enters through Rotemberg costs and Phillips curves, not through Calvo auxiliary recursions.
- The model is nonlinear. Dynare or optimal-control routines should linearize/approximate the system rather than using hand-derived log-linear equations.
- Appendix D changes the international bond denomination for the US-China quantitative exercise; that block is not fully merged into the compact equations above.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Main equation(s) |
|---|---|---|---|
| Endogenous | $`C_t,C_t^{\ast}`$ / `C,Cs` | Home and Foreign aggregate consumption | (F1)-(F8) |
| Endogenous | $`C_{h,t},C_{f,t},C_{f,t}^{\ast},C_{h,t}^{\ast}`$ | Bilateral consumption demands | (F2), (F3), (F6) |
| Endogenous | $`H_t,H_t^{\ast}`$ / `L,Ls` | Labor | (F5), (F8), (F15), (F16) |
| Endogenous | $`Y_t,Y_t^{\ast}`$ / `Y,Ys` | Output | (F15), (F16), (F23), (F24) |
| Endogenous | $`X_t,X_t^{\ast}`$ / `X,Xs` | Intermediate inputs | (F9), (F10), (F13) |
| Endogenous | $`P_t,P_t^{\ast}`$ / `P,Ps` | CPI price indexes relative to producer prices in implementation | (F1), (F6) |
| Endogenous | $`P_{x,t},P_{x,t}^{\ast}`$ / `Px,Pxs` | Intermediate-input price indexes | (F9), (F13) |
| Endogenous | $`\pi_{h,t},\pi_{f,t}^{\ast}`$ / `Pih,Pif` | PPI inflation | (F12), (F14), (F17), (F18) |
| Endogenous | $`\pi_{cpi,t},\pi_{cpi,t}^{\ast}`$ / `Pih_cpi,Pif_cpi` | CPI inflation target variables | (F17), (F18) |
| Endogenous | $`MC_t,MC_t^{\ast}`$ / `Mc,Mcs` | Real marginal cost | (F11), (F12), (F14) |
| Endogenous | $`D_t,D_t^{\ast},D_{x,t},D_{x,t}^{\ast}`$ / `D,Ds,Dx,Dxs` | Domestic absorption and export demand | (F23)-(F28) |
| Endogenous | $`S_t`$ / `S` | Terms of trade / exchange-rate object | (F27), (F28), (F30), (F31) |
| Endogenous | $`b_t,b_t^{\ast}`$ / `nfa` | Net foreign assets | (F29)-(F31) |
| Endogenous | $`R_t,R_t^{\ast}`$ / `R,Rs` | Nominal interest rates | (F19), (F20) |
| Endogenous / policy | $`\tau_t,\tau_t^{\ast}`$ / `T,Ts` | Import tariffs | (F21), (F22), demand equations |
| Exogenous | $`\varepsilon_{A,t},\varepsilon_{A,t}^{\ast}`$ / `eA,eAs` | Productivity innovations | (F32), (F33) |
| Exogenous | $`u_{R,t},u_{R,t}^{\ast}`$ / `epsR,epsRs` | Monetary-policy innovations | (F34), (F35) |
| Exogenous | $`e_{\tau,t},e_{\tau,t}^{\ast}`$ / `eT,eTs` | Tariff innovations in MMB cross-check | (F21), (F22) |
| Parameter | $`\beta`$ / `bet` | Discount factor | (F4), (F7), (F19), (F20) |
| Parameter | $`\sigma`$ / `sigma` | Risk aversion | (F4), (F5), (F7), (F8) |
| Parameter | $`\chi,\psi`$ / `chi,psi` | Labor disutility and Frisch parameter | (F5), (F8) |
| Parameter | $`n`$ / `size` | Home population/economic size | (F27)-(F29), (F31) |
| Parameter | $`\gamma,\gamma^{\ast},\gamma_x,\gamma_x^{\ast}`$ / `gamh,gamf,gamxh,gamxf` | Home-bias weights | (F1), (F6), (F9), (F13), (F25)-(F28) |
| Parameter | $`\lambda`$ / `lamb` | Trade elasticity | Demand equations |
| Parameter | $`\epsilon`$ / `elas` | Elasticity across varieties | (F12), (F14) |
| Parameter | $`\alpha`$ / `alpha` | Intermediate-input share | (F10), (F15), (F16) |
| Parameter | $`\phi`$ / `phi` | Rotemberg price-adjustment parameter | (F12), (F14), (F23), (F24) |
| Parameter | $`\nu`$ / `adj` | Portfolio-adjustment cost | (F30), (F31) |
| Parameter | $`\mu_\pi,\mu_\pi^{\ast}`$ / `mu` | Inflation-rule response | (F19), (F20) |
| Parameter | $`\rho_a,\rho_R,\rho_R^{\ast}`$ | Shock persistence | (F32)-(F35) |

Equation count: (F1)-(F35), 35 numbered conditions.
