# NK_ADE25ppi - Derivation (Optimization Problems + First-Order Conditions)

> Archive status: needs_review. This first-pass derivation is based on the MinerU Markdown of Auray, Devereux, and Eyquem (2025). The paper states that the full two-country equilibrium is given by Online Appendix C equations (C40)-(C48), but that appendix is not available as a normalized Markdown source in this folder. Equations below therefore preserve the paper-side structure and mark appendix-dependent formulas as needs_review.

Provenance: model_id `NK_ADE25ppi`; paper title "Trade Wars and the Optimal Design of Monetary Rules"; authors Stéphane Auray, Micheal Devereux, and Aurélien Eyquem; year 2025; DOI `10.1016/j.jmoneco.2024.103726`; source Markdown `raw/mmb_mineru/runs/nk_ade25cpi_nk_ade25ppi__trade_wars_and_the_optimal_design_of_monetary_rules__2eb96dcd/full.md`; raw PDF `raw/mmb_papers/Trade Wars and the Optimal Design of Monetary Rules.pdf`; MinerU run id `2eb96dcd-d16e-4f63-85f3-a8572fc7a9dd`.

## 1. Model Overview

- **Model**: two-country New Keynesian open-economy trade-war model with producer-currency pricing, monopolistic competition, Rotemberg price adjustment costs, non-contingent bonds, and discretionary tariff setting.
- **MMB variant**: `NK_ADE25ppi`, the PPI-targeting version. The local MMB implementation cross-check uses producer-price inflation in the monetary-policy feedback variable, unlike `NK_ADE25cpi`, which defines CPI inflation as domestic-goods inflation times the CPI-price-index change.
- **Policy experiment**: non-cooperative tariffs interact with monetary rules. The paper compares PPI targeting, CPI targeting, fixed exchange rates, and more general rules that stabilize tariff-adjusted terms of trade. This archive entry records the PPI-targeting baseline.
- **Agents and policy authorities**: Home and Foreign households consume Home and Foreign goods, supply labor, and hold bonds; monopolistically competitive firms set producer-currency prices; governments choose import tariffs and rebate revenue; central banks set nominal interest rates.
- **Model form**: nonlinear equilibrium conditions solved around a deterministic steady state; the MMB implementation later log-linearizes/simulates, but this derivation keeps nonlinear paper formulas. Runtime validation was not performed.

## 2. Optimization Problems

### 2.1 Home Household

The Home household chooses consumption of Home goods, consumption of Foreign goods, hours, and bond holdings:

$$
\max_{\{C_{h,t},C_{f,t},H_t,B_t\}} E_0\sum_{t=0}^{\infty}\beta^t
\left[u(C_{h,t},C_{f,t})-\ell(H_t)\right]
$$

subject to the nominal budget constraint

$$
B_t+P_{h,t}C_{h,t}+(1+\tau_t)S_tP_{f,t}^{*}C_{f,t}
=R_{t-1}B_{t-1}+W_tH_t+\Pi_t+TR_t .
$$

The paper's quantitative model uses aggregate consumption $C_t$, labor $H_t$ (or $L_t$ in the MMB implementation), and a CES price index over domestic and imported goods. The exact Appendix C aggregation is needs_review.

### 2.2 Foreign Household

The Foreign household solves the symmetric problem:

$$
\max_{\{C_{f,t}^{*},C_{h,t}^{*},H_t^{*},B_t^{*}\}} E_0\sum_{t=0}^{\infty}\beta^t
\left[u^{*}(C_{f,t}^{*},C_{h,t}^{*})-\ell(H_t^{*})\right],
$$

with the Foreign import tariff $\tau_t^{*}$ applied to Home goods and with bond denomination following the model variant. The US-China extension changes bond denomination to dollars; this archive entry does not reconstruct that extension as a separate model.

### 2.3 Firms

A continuum of monopolistically competitive Home firms produces differentiated varieties under producer-currency pricing. In the simple model, output of variety $i$ is

$$
Y_t(i)=A_tH_t(i).
$$

In the full quantitative model, production also uses intermediate goods with share $\alpha$:

$$
Y_t=A_tL_t^{1-\alpha}X_t^\alpha,
$$

with a symmetric Foreign production function. Firms choose prices subject to demand curves and Rotemberg adjustment costs. The resulting Phillips curves are listed in Section 3.

### 2.4 Governments And Central Banks

The Home and Foreign tariff authorities choose discretionary Nash tariffs. Under flexible exchange rates, the Home problem is summarized in the paper as

$$
\max_{\{C_t,C_t^{*},Y_t,Y_t^{*},b_t,b_t^{*},S_t,\pi_{h,t},\pi_{f,t}^{*},\tau_t\}}
V(b_{t-1})=U(C_t,H_t)+\beta E_t[V(b_t)]
$$

subject to the full equilibrium constraints and the monetary policy rules. The Foreign problem is symmetric for $\tau_t^{*}$. These tariff FOCs are not printed in the main text and are therefore needs_review against Online Appendix C.

For `NK_ADE25ppi`, central banks target producer-price inflation rather than CPI inflation.

## 3. First-Order Conditions

- **(F1) Home intratemporal labor condition**:
$$
\ell'(H_t)=A_t\,u_{c_h,t}\,E_t\{\Omega_{t,t+1}\}.
$$

- **(F2) Home optimal import spending condition**:
$$
u_{c_h,t}(1+\tau_t)S_t=u_{c_f,t}.
$$

- **(F3) Home Euler equation in Home-goods units, combined with PPI monetary policy**:
$$
E_t\left[
\frac{\pi_{h,t}^{\mu_\pi}}{\pi_{h,t+1}}
\frac{u_{c_h,t+1}}{u_{c_h,t}}
\right]=1.
$$

- **(F4) Home Rotemberg Phillips curve from firm price setting**:
$$
E_t\{\Omega_{t,t+1}\}
=\mathcal{W}_t A_t^{-1}
=E_t\left\{\theta+\frac{\phi}{\epsilon}
\left[\pi_{h,t}(\pi_{h,t}-1)-\beta\pi_{h,t+1}(\pi_{h,t+1}-1)\right]\right\}.
$$

- **(F5) Home marginal-cost representation used in the quantitative model** needs_review:
$$
MC_t=
\frac{\left(\chi P_t C_t^\sigma L_t^\psi\right)^{1-\alpha}P_{x,t}^{\alpha}}
{A_t\alpha^\alpha(1-\alpha)^{1-\alpha}}.
$$

- **(F6) Home intermediate-input demand condition** needs_review:
$$
X_t=
\left(
\frac{\chi P_t C_t^\sigma L_t^{\alpha+\psi}}
{(1-\alpha)MC_tA_t}
\right)^{1/\alpha}.
$$

- **(F7) Home production function**:
$$
Y_t=A_tL_t^{1-\alpha}X_t^\alpha.
$$

- **(F8) Foreign intratemporal labor condition** needs_review:
$$
\ell^{*'}(H_t^{*})=A_t^{*}\,u_{c_f^{*},t}^{*}\,E_t\{\Omega_{t,t+1}^{*}\}.
$$

- **(F9) Foreign optimal import spending condition** needs_review:
$$
u_{c_f^{*},t}^{*}\frac{1+\tau_t^{*}}{S_t}=u_{c_h^{*},t}^{*}.
$$

- **(F10) Foreign Euler equation in Foreign-goods units, combined with PPI monetary policy** needs_review:
$$
E_t\left[
\frac{(\pi_{f,t}^{*})^{\mu_\pi^{*}}}{\pi_{f,t+1}^{*}}
\frac{u_{c_f^{*},t+1}^{*}}{u_{c_f^{*},t}^{*}}
\right]=1.
$$

- **(F11) Foreign Rotemberg Phillips curve** needs_review:
$$
E_t\{\Omega_{t,t+1}^{*}\}
=\mathcal{W}_t^{*}(A_t^{*})^{-1}
=E_t\left\{\theta^{*}+\frac{\phi^{*}}{\epsilon}
\left[\pi_{f,t}^{*}(\pi_{f,t}^{*}-1)-\beta\pi_{f,t+1}^{*}(\pi_{f,t+1}^{*}-1)\right]\right\}.
$$

- **(F12) Foreign production function**:
$$
Y_t^{*}=A_t^{*}(L_t^{*})^{1-\alpha}(X_t^{*})^\alpha.
$$

## 4. Market Clearing & Identities

- **(F13) Home goods market clearing in the simple model**:
$$
A_tH_t\Phi_t=C_{h,t}+C_{h,t}^{*},\qquad
\Phi_t=1-\frac{\phi}{2}(\pi_{h,t}-1)^2.
$$

- **(F14) Balanced trade in the simple model**:
$$
\bar{A}S_t^\eta=S_tC_{f,t}.
$$

- **(F15) Home resource constraint in the quantitative model** needs_review:
$$
Y_t\left[1-\frac{\phi}{2}(\pi_{h,t}-1)^2\right]=D_t+D_{x,t}^{*}.
$$

- **(F16) Foreign resource constraint in the quantitative model** needs_review:
$$
Y_t^{*}\left[1-\frac{\phi^{*}}{2}(\pi_{f,t}^{*}-1)^2\right]=D_t^{*}+D_{x,t}.
$$

- **(F17) Home CPI and import-price index** needs_review:
$$
P_t=\left[\gamma_h+(1-\gamma_h)\left((1+\tau_t)S_t\right)^{1-\lambda}\right]^{1/(1-\lambda)}.
$$

- **(F18) Foreign CPI and import-price index** needs_review:
$$
P_t^{*}=\left[\gamma_f+(1-\gamma_f)\left(\frac{1+\tau_t^{*}}{S_t}\right)^{1-\lambda}\right]^{1/(1-\lambda)}.
$$

- **(F19) Net foreign asset accumulation and UIP condition** needs_review:
$$
b_t=\mathcal{B}(b_{t-1},S_t,P_t,P_t^{*},D_{x,t},D_{x,t}^{*}),\qquad
E_t\left[\frac{S_{t+1}\Omega_t}{S_t\Omega_t^{*}(1+\nu(b_t-\bar{b}))}\right]=1.
$$

## 5. Exogenous Processes

- **(F20) Home PPI monetary policy rule for `NK_ADE25ppi`**:
$$
R_t=\beta^{-1}\left(\frac{\pi_{h,t}}{\bar{\pi}_h}\right)^{\mu_\pi}\exp(e^R_t).
$$

- **(F21) Foreign PPI monetary policy rule**:
$$
R_t^{*}=\beta^{-1}\left(\frac{\pi_{f,t}^{*}}{\bar{\pi}_f^{*}}\right)^{\mu_\pi^{*}}\exp(e^{R^{*}}_t).
$$

- **(F22) Productivity processes**:
$$
\log A_t=\rho_a\log A_{t-1}+\varepsilon^A_t,\qquad
\log A_t^{*}=\rho_a^{*}\log A_{t-1}^{*}+\varepsilon^{A^{*}}_t.
$$

- **(F23) Tariff and monetary shocks used in the MMB implementation cross-check**:
$$
\tau_t=\bar{\tau}+e^T_t,\qquad
\tau_t^{*}=\bar{\tau}^{*}+e^{T^{*}}_t,\qquad
e^R_t=\rho_R e^R_{t-1}+\varepsilon^R_t,\qquad
e^{R^{*}}_t=\rho_{R^{*}} e^{R^{*}}_{t-1}+\varepsilon^{R^{*}}_t.
$$

## 6. Steady-State Solution

The deterministic steady state sets shocks to zero and keeps tariffs constant. The paper's calibrated examples use symmetric countries in the baseline Section 5 calibration, while the Section 8 US-China exercise uses asymmetric size, productivity, home bias, and tariff levels.

1. Set $A=A^{*}=1$ for the symmetric calibration, or use $A^{*}/A=1/3$ in the US-China application.
2. Set $\pi_h=\pi_f^{*}=1$ and, under the PPI rule, $R=R^{*}=\beta^{-1}$ when monetary-policy shocks are zero.
3. Set net foreign assets to the target, commonly $b=\bar{b}=0$.
4. Given tariffs $\tau,\tau^{*}$, compute the CPI/import price indices $P,P^{*},P_x,P_x^{*}$ from (F17)-(F18) and the analogous intermediate-input price indices.
5. Use the steady-state firm conditions to solve marginal costs. With zero inflation and no sales subsidy, the distorted steady state has the monopoly markup distortion; with the first-best subsidy, $\theta=1$.
6. Solve labor, intermediate inputs, output, and demands from (F5)-(F16). The full closed-form sequence is needs_review because the main Markdown refers to Appendix C equations (C40)-(C48) rather than printing them.
7. For the simple small-economy PPI case, the paper gives the steady-state optimal tariff:
$$
1+\tau^{ppi}=\frac{\eta}{\eta-1}\frac{1-\theta\Delta_1}{1-\Delta_1},
$$
where
$$
\Delta_1=\frac{A^2u_{c_hc_h}}{\ell''(H)}
\left(\theta+\frac{\phi}{\mu_\pi\epsilon}\right)<0.
$$

## 7. Timing & Form Conventions

- The derivation is nonlinear. Do not treat these equations as a hand log-linearization.
- Producer-currency pricing is used: sticky prices are in domestic producer prices, so the `ppi` variant targets $\pi_{h,t}$ and $\pi_{f,t}^{*}$.
- CPI inflation differs from PPI inflation by changes in tariff-adjusted terms of trade. For Home, the paper writes
$$
\pi_{cpi,t}=\pi_{h,t}
\frac{\mathcal{P}((1+\tau_t)S_t)}{\mathcal{P}((1+\tau_{t-1})S_{t-1})}.
$$
This formula is not the target in `NK_ADE25ppi`, but it identifies the paired CPI variant.
- Bonds/net foreign assets are state variables. The MMB implementation uses lagged net foreign assets and a debt-elastic UIP wedge; exact Appendix C notation is needs_review.
- Tariff policy is discretionary: tariff setters take future policy functions as given when choosing current tariffs.
- Runtime validation was not performed.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII name | Meaning | Main equation(s) |
|---|---|---|---|
| Endogenous | $C_{h,t},C_{f,t},C_t$ / `C` | Home household consumption components / aggregate consumption | (F2), (F3), (F17) |
| Endogenous | $C_t^{*}$ / `Cs` | Foreign aggregate consumption | (F9), (F10), (F18) |
| Endogenous | $H_t,L_t$ / `L` | Home labor | (F1), (F7) |
| Endogenous | $H_t^{*},L_t^{*}$ / `Ls` | Foreign labor | (F8), (F12) |
| Endogenous | $Y_t,Y_t^{*}$ / `Y`, `Ys` | Home and Foreign output | (F7), (F12), (F15), (F16) |
| Endogenous | $X_t,X_t^{*}$ / `X`, `Xs` | Intermediate goods | (F6), (F12) |
| Endogenous | $MC_t,MC_t^{*}$ / `Mc`, `Mcs` | Marginal costs | (F5), (F11) |
| Endogenous | $\pi_{h,t},\pi_{f,t}^{*}$ / `Pih`, `Pif` | PPI inflation rates | (F4), (F11), (F20), (F21) |
| Endogenous | $P_t,P_t^{*}$ / `P`, `Ps` | CPI price indices | (F17), (F18) |
| Endogenous | $S_t$ / `S` | Terms of trade / relative price | (F2), (F9), (F17), (F18), (F19) |
| Endogenous | $b_t$ / `nfa` | Net foreign assets | (F19) |
| Endogenous | $R_t,R_t^{*}$ / `R`, `Rs` | Nominal interest rates | (F20), (F21) |
| Endogenous policy | $\tau_t,\tau_t^{*}$ / `T`, `Ts` | Import tariffs | (F2), (F9), (F23) |
| Exogenous | $\varepsilon^A_t,\varepsilon^{A^{*}}_t$ / `eA`, `eAs` | Productivity innovations | (F22) |
| Exogenous | $\varepsilon^T_t,\varepsilon^{T^{*}}_t$ / `eT`, `eTs` | Tariff shocks / tariff shifters in MMB implementation | (F23) |
| Exogenous | $\varepsilon^R_t,\varepsilon^{R^{*}}_t$ / `epsR`, `epsRs`, `interest_` | Monetary policy shocks | (F20), (F21), (F23) |
| Parameter | $\beta$ / `bet` | Discount factor | (F3), (F20), (F21) |
| Parameter | $\sigma,\chi,\psi$ / `sigma`, `chi`, `psi` | Utility curvature and labor disutility parameters | (F1), (F5), (F6) |
| Parameter | $\lambda$ / `lamb` | Trade elasticity | (F17), (F18) |
| Parameter | $\epsilon$ / `elas` | Elasticity across varieties / markup parameter | (F4), (F11) |
| Parameter | $\phi,\phi^{*}$ / `phi` | Rotemberg price adjustment costs | (F4), (F11), (F15), (F16) |
| Parameter | $\alpha$ / `alpha` | Intermediate-input share | (F5), (F7), (F12) |
| Parameter | $\gamma_h,\gamma_f,\gamma_{xh},\gamma_{xf}$ / `gamh`, `gamf`, `gamxh`, `gamxf` | Home-bias weights | (F17), (F18) |
| Parameter | $\mu_\pi,\mu_\pi^{*}$ / `mu` | Inflation response in monetary rule | (F20), (F21) |
| Parameter | $\rho_a,\rho_R,\rho_{R^{*}}$ / `rhoa`, `rhoR`, `rhoRs` | Shock persistence | (F22), (F23) |
