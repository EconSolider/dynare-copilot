# US_IN10 -- Derivation (Optimization Problems + First-Order Conditions)

> Model archive draft for source-backed review. Runtime validation was not performed. Status: `needs_review`.

Provenance: `US_IN10`, Iacoviello and Neri (2010), "Housing Market Spillovers: Evidence from an Estimated DSGE Model," DOI `10.1257/mac.2.2.125`. Primary source: `raw/mmb_mineru/runs/us_in10__housing_market_spillovers_evidence_from_an_estimated_dsge_model__eac0da74/full.md`; raw PDF: `raw/mmb_papers/Housing market spillovers- Evidence from an estimated dsge model.pdf`; MinerU run id `eac0da74-ce5a-44ed-87f4-f7ac437abbaf`.

## 1. Model Overview

- Model: estimated U.S. two-sector DSGE model with housing-market spillovers.
- Purpose: Bayesian estimation and counterfactual analysis of housing demand, housing technology, monetary shocks, and collateral effects over 1965:Q1-2006:Q4.
- Agents and blocks: patient households, impatient collateral-constrained households, wholesale firms in consumption and housing production, sticky-price retailers in the consumption sector, labor unions with sticky wages in both sectors and household types, and a Taylor-rule central bank.
- Core mechanisms: heterogeneous discount factors, binding housing collateral constraint for impatient households, housing as durable utility stock, two capital stocks, land and intermediate inputs in housing production, investment-specific technology, capital utilization, price and wage Phillips curves, and multiple persistent shocks.
- Form: paper states that the equilibrium is detrended by balanced-growth trends and then linearized around the nonstochastic steady state. The Rep-MMB implementation uses log variables around trends with separate flexible-price/flexible-wage and sticky-price/wage blocks; this `.mod` observation is recorded only as `implementation_cross_check`.
- Formula quality: first-pass extraction from MinerU Markdown. Equations (B1)-(B36) are usable, but several OCR artifacts remain; uncertain points are marked `needs_review`.

## 2. Optimization Problems

### Patient households

Patient households maximize expected utility over consumption, housing, and hours in the consumption and housing sectors:

$$
E_0 \sum_{t=0}^{\infty}(\beta G_C)^t z_t\left[
\Gamma_c\ln(c_t-\varepsilon c_{t-1})+j_t\ln h_t
-\frac{\tau_t}{1+\eta}\left(n_{c,t}^{1+\xi}+n_{h,t}^{1+\xi}\right)^{\frac{1+\eta}{1+\xi}}
\right].
$$

They choose consumption, housing, loans, land, capital in both sectors, intermediate inputs for housing production, sectoral hours, and utilization rates subject to the budget constraint in (F1). Patient households own capital and land, receive dividends, and lend to impatient households.

### Impatient households

Impatient households have the analogous objective

$$
E_0 \sum_{t=0}^{\infty}({\beta}'G_C)^t z_t\left[
{\Gamma}'_c\ln({c}'_t-{\varepsilon}'{c}'_{t-1})+j_t\ln {h}'_t
-\frac{\tau_t}{1+{\eta}'}\left(({n}'_{c,t})^{1+{\xi}'}+({n}'_{h,t})^{1+{\xi}'}\right)^{\frac{1+{\eta}'}{1+{\xi}'}}
\right],
$$

with ${\beta}'<\beta$. They choose consumption, housing, sectoral hours, and borrowing subject to (F12) and the binding collateral constraint (F13).

### Wholesale firms

Competitive wholesale firms produce nonhousing output and new houses. They choose labor, capital services, land, and intermediate goods to maximize current profits:

$$
\max \; \frac{Y_t}{X_t}+q_t IH_t
-\left(\sum_{i=c,h}w_{i,t}n_{i,t}+\sum_{i=c,h}{w}'_{i,t}{n}'_{i,t}
+\sum_{i=c,h}R_{i,t}z_{i,t}k_{i,t-1}+R_{l,t}l_{t-1}+p_{b,t}k_{b,t}\right),
$$

subject to the production technologies in (F18)-(F19).

### Retailers, unions, and policy

Retailers in the consumption sector set prices under Calvo contracts with indexation, producing the Phillips curve (F28). Labor unions set four sector/type nominal wages under analogous Calvo contracts, producing (F29)-(F32). The central bank follows the Taylor rule in (F33). These blocks are equilibrium conditions rather than static optimization problems in this archive draft.

## 3. First-Order Conditions

**Patient households**

- **(F1) Patient budget constraint**:

$$
\begin{aligned}
c_t+\frac{k_{c,t}}{A_{k,t}}+k_{h,t}+k_{b,t}+q_t h_t+p_{l,t}l_t-b_t
&=\frac{w_{c,t}}{X_{wc,t}}n_{c,t}+\frac{w_{h,t}}{X_{wh,t}}n_{h,t}-\phi_t\\
&\quad+\left(R_{c,t}z_{c,t}+\frac{1-\delta_{kc}}{A_{k,t}}\right)k_{c,t-1}
+\left(R_{h,t}z_{h,t}+1-\delta_{kh}\right)k_{h,t-1}\\
&\quad+p_{b,t}k_{b,t}-\frac{R_{t-1}b_{t-1}}{\pi_t}
+(p_{l,t}+R_{l,t})l_{t-1}+q_t(1-\delta_h)h_{t-1}\\
&\quad+Div_t-\frac{a(z_{c,t})}{A_{k,t}}k_{c,t-1}-a(z_{h,t})k_{h,t-1}.
\end{aligned}
$$

needs_review: the Appendix OCR shows `q_l h_t` in (B1), but the main-text budget and economic meaning imply `q_t h_t`; this draft uses `q_t h_t`.

- **(F2) Patient housing Euler equation**:

$$
u_{c,t}q_t=u_{h,t}+\beta G_C E_t\left[u_{c,t+1}q_{t+1}(1-\delta_h)\right].
$$

- **(F3) Patient bond Euler equation**:

$$
u_{c,t}=\beta G_C E_t\left(u_{c,t+1}\frac{R_t}{\pi_{t+1}}\right).
$$

- **(F4) Patient capital Euler, consumption-sector capital**:

$$
u_{c,t}\left(\frac{1}{A_{k,t}}+\frac{\partial\phi_{c,t}}{\partial k_{c,t}}\right)
=\beta G_C E_t u_{c,t+1}\left(R_{c,t+1}z_{c,t+1}-\frac{a(z_{c,t+1})+1-\delta_{kc}}{A_{k,t+1}}-\frac{\partial\phi_{c,t+1}}{\partial k_{c,t}}\right).
$$

- **(F5) Patient capital Euler, housing-sector capital**:

$$
u_{c,t}\left(1+\frac{\partial\phi_{h,t}}{\partial k_{h,t}}\right)
=\beta G_C E_t u_{c,t+1}\left(R_{h,t+1}z_{h,t+1}-a(z_{h,t+1})+1-\delta_{kh}-\frac{\partial\phi_{h,t+1}}{\partial k_{h,t}}\right).
$$

- **(F6) Patient consumption-sector labor supply**:

$$
u_{c,t}w_{c,t}=u_{nc,t}X_{wc,t}.
$$

- **(F7) Patient housing-sector labor supply**:

$$
u_{c,t}w_{h,t}=u_{nh,t}X_{wh,t}.
$$

- **(F8) Intermediate-input price condition**:

$$
u_{c,t}(p_{b,t}-1)=0.
$$

- **(F9) Utilization, consumption-sector capital**:

$$
R_{c,t}A_{k,t}=a'(z_{c,t}).
$$

- **(F10) Utilization, housing-sector capital**:

$$
R_{h,t}=a'(z_{h,t}).
$$

- **(F11) Land asset Euler equation**:

$$
u_{c,t}p_{l,t}=\beta G_C E_t u_{c,t+1}(p_{l,t+1}+R_{l,t+1}).
$$

**Impatient households**

- **(F12) Impatient budget constraint**:

$$
{c}'_t+q_t{h}'_t=\frac{{w}'_{c,t}}{{X}'_{wc,t}}{n}'_{c,t}
+\frac{{w}'_{h,t}}{{X}'_{wh,t}}{n}'_{h,t}
+{b}'_t-\frac{R_{t-1}}{\pi_t}{b}'_{t-1}+q_t(1-\delta_h){h}'_{t-1}+{Div}'_t.
$$

- **(F13) Binding housing collateral constraint**:

$$
{b}'_t=mE_t\left(\frac{q_{t+1}{h}'_t\pi_{t+1}}{R_t}\right).
$$

- **(F14) Impatient housing Euler equation**:

$$
u_{{c}',t}q_t=u_{{h}',t}+{\beta}'G_CE_t\left[u_{{c}',t+1}q_{t+1}(1-\delta_h)\right]
+E_t\left(\lambda_t\frac{m q_{t+1}\pi_{t+1}}{R_t}\right).
$$

- **(F15) Impatient bond Euler equation with collateral multiplier**:

$$
u_{{c}',t}={\beta}'G_CE_t\left(u_{{c}',t+1}\frac{R_t}{\pi_{t+1}}\right)+\lambda_t.
$$

- **(F16) Impatient consumption-sector labor supply**:

$$
u_{{c}',t}{w}'_{c,t}=u_{{n_c}',t}{X}'_{wc,t}.
$$

- **(F17) Impatient housing-sector labor supply**:

$$
u_{{c}',t}{w}'_{h,t}=u_{{n_h}',t}{X}'_{wh,t}.
$$

**Wholesale firms**

- **(F18) Nonhousing production technology**:

$$
Y_t=\left(A_{c,t}(n_{c,t}^{\alpha}{n}'_{c,t}{}^{1-\alpha})\right)^{1-\mu_c}(z_{c,t}k_{c,t-1})^{\mu_c}.
$$

- **(F19) Housing production technology**:

$$
IH_t=\left(A_{h,t}(n_{h,t}^{\alpha}{n}'_{h,t}{}^{1-\alpha})\right)^{1-\mu_h-\mu_l-\mu_b}
k_{b,t}^{\mu_b}(z_{h,t}k_{h,t-1})^{\mu_h}l_{t-1}^{\mu_l}.
$$

- **(F20) Patient labor demand, consumption sector**:

$$
(1-\mu_c)\alpha Y_t=X_t w_{c,t}n_{c,t}.
$$

- **(F21) Impatient labor demand, consumption sector**:

$$
(1-\mu_c)(1-\alpha)Y_t=X_t {w}'_{c,t}{n}'_{c,t}.
$$

- **(F22) Patient labor demand, housing sector**:

$$
(1-\mu_h-\mu_l-\mu_b)\alpha q_t IH_t=w_{h,t}n_{h,t}.
$$

- **(F23) Impatient labor demand, housing sector**:

$$
(1-\mu_h-\mu_l-\mu_b)(1-\alpha)q_t IH_t={w}'_{h,t}{n}'_{h,t}.
$$

- **(F24) Consumption-sector capital demand**:

$$
\mu_c Y_t=X_t R_{c,t}z_{c,t}k_{c,t-1}.
$$

- **(F25) Housing-sector capital demand**:

$$
\mu_h q_t IH_t=R_{h,t}z_{h,t}k_{h,t-1}.
$$

- **(F26) Land demand**:

$$
\mu_l q_t IH_t=R_{l,t}l_{t-1}.
$$

- **(F27) Intermediate-input demand**:

$$
\mu_b q_t IH_t=p_{b,t}k_{b,t}.
$$

**Price and wage setting**

- **(F28) Consumption-sector price Phillips curve**:

$$
\ln\pi_t-\iota_{\pi}\ln\pi_{t-1}
=\beta G_C(E_t\ln\pi_{t+1}-\iota_{\pi}\ln\pi_t)-\varepsilon_{\pi}\ln(X_t/X)+u_{p,t}.
$$

- **(F29) Patient consumption-sector wage Phillips curve**:

$$
\ln\omega_{c,t}-\iota_{wc}\ln\pi_{t-1}
=\beta G_C(E_t\ln\omega_{c,t+1}-\iota_{wc}\ln\pi_t)-\varepsilon_{wc}\ln(X_{wc,t}/X_{wc}).
$$

- **(F30) Impatient consumption-sector wage Phillips curve**:

$$
\ln{\omega}'_{c,t}-\iota_{wc}\ln\pi_{t-1}
={\beta}'G_C(E_t\ln{\omega}'_{c,t+1}-\iota_{wc}\ln\pi_t)-{\varepsilon}'_{wc}\ln({X}'_{wc,t}/X_{wc}).
$$

- **(F31) Patient housing-sector wage Phillips curve**:

$$
\ln\omega_{h,t}-\iota_{wh}\ln\pi_{t-1}
=\beta G_C(E_t\ln\omega_{h,t+1}-\iota_{wh}\ln\pi_t)-\varepsilon_{wh}\ln(X_{wh,t}/X_{wh}).
$$

- **(F32) Impatient housing-sector wage Phillips curve**:

$$
\ln{\omega}'_{h,t}-\iota_{wh}\ln\pi_{t-1}
={\beta}'G_C(E_t\ln{\omega}'_{h,t+1}-\iota_{wh}\ln\pi_t)-{\varepsilon}'_{wh}\ln({X}'_{wh,t}/X_{wh}).
$$

needs_review: Appendix B's text defining wage Phillips-curve slopes appears to repeat `theta_wc` in the housing-wage expression and has inconsistent prime notation; this draft preserves the intended sector/type structure.

- **(F33) Taylor rule**:

$$
R_t=(R_{t-1})^{r_R}\pi_t^{r_{\pi}(1-r_R)}
\left(\frac{GDP_t}{G_CGDP_{t-1}}\right)^{r_Y(1-r_R)}
\overline{rr}^{\,1-r_R}\frac{u_{R,t}}{s_t}.
$$

## 4. Market Clearing & Identities

- **(F34) Goods-market clearing**:

$$
C_t+\frac{IK_{c,t}}{A_{k,t}}+IK_{h,t}+k_{b,t}=Y_t-\phi_t.
$$

- **(F35) Aggregate housing accumulation**:

$$
h_t+{h}'_t-(1-\delta_h)(h_{t-1}+{h}'_{t-1})=IH_t.
$$

- **(F36) Land supply**:

$$
l_t=1.
$$

Additional identities from Appendix B:

$$
b_t+{b}'_t=0,
$$

$$
GDP_t=Y_t-k_{b,t}+\bar{q}IH_t.
$$

$$
Div_t=\frac{X_t-1}{X_t}Y_t+\frac{X_{wc,t}-1}{X_{wc,t}}w_{c,t}n_{c,t}
+\frac{X_{wh,t}-1}{X_{wh,t}}w_{h,t}n_{h,t}.
$$

$$
{Div}'_t=\frac{{X}'_{wc,t}-1}{{X}'_{wc,t}}{w}'_{c,t}{n}'_{c,t}
+\frac{{X}'_{wh,t}-1}{{X}'_{wh,t}}{w}'_{h,t}{n}'_{h,t}.
$$

Investment and adjustment-cost definitions:

$$
IK_{c,t}=k_{c,t}-(1-\delta_{kc})k_{c,t-1},\qquad
IK_{h,t}=k_{h,t}-(1-\delta_{kh})k_{h,t-1}.
$$

$$
\phi_t=\frac{\phi_{kc}}{2G_{IKc}}\left(\frac{k_{c,t}}{k_{c,t-1}}-G_{IKc}\right)^2
\frac{k_{c,t-1}}{(1+\gamma_{AK})^t}
+\frac{\phi_{kh}}{2G_{IKh}}\left(\frac{k_{h,t}}{k_{h,t-1}}-G_{IKh}\right)^2k_{h,t-1}.
$$

needs_review: the adjustment-cost formula is particularly vulnerable to OCR line-breaking; the first term's multiplication by lagged capital and trend scaling should be checked against the PDF before implementation.

Utilization cost functions:

$$
a(z_{c,t})=R_c\left(\varpi z_{c,t}^2/2+(1-\varpi)z_{c,t}+(\varpi/2-1)\right),
$$

$$
a(z_{h,t})=R_h\left(\varpi z_{h,t}^2/2+(1-\varpi)z_{h,t}+(\varpi/2-1)\right).
$$

## 5. Exogenous Processes

Preference and policy shocks:

- **(F37) Intertemporal preference shock**:

$$
\ln z_t=\rho_z\ln z_{t-1}+u_{z,t}.
$$

- **(F38) Labor-supply shock**:

$$
\ln\tau_t=\rho_{\tau}\ln\tau_{t-1}+u_{\tau,t}.
$$

- **(F39) Housing-preference shock**:

$$
\ln j_t=(1-\rho_j)\ln j+\rho_j\ln j_{t-1}+u_{j,t}.
$$

- **(F40) Inflation-target shock**:

$$
\ln s_t=\rho_s\ln s_{t-1}+u_{s,t}.
$$

Trend-stationary technology processes:

- **(F41) Consumption-sector productivity**:

$$
\ln A_{c,t}=t\ln(1+\gamma_{AC})+\ln Z_{c,t},\qquad
\ln Z_{c,t}=\rho_{AC}\ln Z_{c,t-1}+u_{C,t}.
$$

- **(F42) Housing-sector productivity**:

$$
\ln A_{h,t}=t\ln(1+\gamma_{AH})+\ln Z_{h,t},\qquad
\ln Z_{h,t}=\rho_{AH}\ln Z_{h,t-1}+u_{H,t}.
$$

- **(F43) Investment-specific technology**:

$$
\ln A_{k,t}=t\ln(1+\gamma_{AK})+\ln Z_{k,t},\qquad
\ln Z_{k,t}=\rho_{AK}\ln Z_{k,t-1}+u_{K,t}.
$$

The price-markup shock `u_{p,t}` is the innovation in (F28), and the monetary policy shock `u_{R,t}` enters (F33). The Rep-MMB implementation cross-check lists exogenous innovations `eps_c`, `eps_h`, `eps_j`, `eps_k`, `eps_t`, `eps_s`, `eps_z`, `eps_p`, and `eps_e`.

## 6. Steady-State Solution

The paper solves the model after detrending by balanced-growth trends and linearizes around a nonstochastic steady state. A full numeric steady-state reconstruction is deferred because this archive pass does not run the model and because Appendix B relies on several auxiliary steady-state ratios.

Balanced-growth rates reported by the paper:

$$
G_C=G_{IKh}=G_{q\times IH}=1+\gamma_{AC}+\frac{\mu_c}{1-\mu_c}\gamma_{AK}.
$$

$$
G_{IKc}=1+\gamma_{AC}+\frac{1}{1-\mu_c}\gamma_{AK}.
$$

$$
G_{IH}=1+(\mu_h+\mu_b)\gamma_{AC}
+\frac{\mu_c(\mu_h+\mu_b)}{1-\mu_c}\gamma_{AK}
+(1-\mu_h-\mu_l-\mu_b)\gamma_{AH}.
$$

$$
G_q=1+(1-\mu_h-\mu_b)\gamma_{AC}
+\frac{\mu_c(1-\mu_h-\mu_b)}{1-\mu_c}\gamma_{AK}
-(1-\mu_h-\mu_l-\mu_b)\gamma_{AH}.
$$

Calibration and steady-state targets from the paper:

- $\beta=0.9925$, ${\beta}'=0.97$, $j=0.12$, $\mu_c=0.35$, $\mu_h=0.10$, $\mu_l=0.10$, $\mu_b=0.10$, $\delta_h=0.01$, $\delta_{kc}=0.025$, $\delta_{kh}=0.03$, $X=X_{wc}=X_{wh}=1.15$, $m=0.85$, $\rho_s=0.975$.
- Steady-state ratios: annual real interest rate 3 percent, $C/GDP=67$ percent, $IK/GDP=27$ percent, $qIH/GDP=6$ percent, $qH/(4GDP)=1.36$, $k_c/(4GDP)=2.05$, $k_h/(4GDP)=0.04$, $p_l/(4GDP)=0.50$.
- Posterior mean trend parameters used by the MMB implementation cross-check: `TREND_AC = 0.0032`, `TREND_AH = 0.0008`, and `TREND_AK = 0.00275`.

needs_review: this is a steady-state map, not an executable `steady_state_model`. A later implementation phase should source-check auxiliary ratios such as `IK_c`, `IK_h`, `GDP_t`, dividends, and adjustment costs before deriving a complete recursive steady-state routine.

## 7. Timing & Form Conventions

- Timing: physical capital stocks $k_{c,t}$ and $k_{h,t}$ are end-of-period stocks; production at $t$ uses $k_{c,t-1}$ and $k_{h,t-1}$ with utilization $z_{c,t}$ and $z_{h,t}$.
- Housing: household housing stocks enter utility at $t$ and evolve through (F35); existing housing depreciates at $\delta_h$.
- Loans: nominal one-period loans pay $R_{t-1}/\pi_t$ in real terms; impatient borrowing is collateralized by expected next-period nominal housing value divided by $R_t$.
- Land: total land is fixed and normalized to one; production uses $l_{t-1}$.
- Form: the paper detrends real variables by balanced-growth rates and linearizes around a nonstochastic steady state. The Rep-MMB `.mod` implements many variables in logs and has a separate flexible-price/flexible-wage block for output-gap construction; this is `implementation_cross_check` only.
- Runtime validation: not performed; Dynare was not run.

## 8. Variable & Parameter Reference Table

| Category | Symbol | Meaning | Main equation(s) |
|---|---|---|---|
| Endogenous | $c_t,{c}'_t$ | patient and impatient consumption | F1, F12, F15 |
| Endogenous | $h_t,{h}'_t,H_t$ | household and aggregate housing stock | F2, F13, F14, F35 |
| Endogenous | $k_{c,t},k_{h,t},k_{b,t}$ | capital in consumption, capital in housing, intermediate input | F4, F5, F8, F24, F25, F27 |
| Endogenous | $n_{c,t},n_{h,t},{n}'_{c,t},{n}'_{h,t}$ | hours by sector and household type | F6, F7, F16, F17, F20-F23 |
| Endogenous | $b_t,{b}'_t,\lambda_t$ | loans and borrowing-constraint multiplier | F3, F12, F13, F15 |
| Endogenous | $Y_t,IH_t,GDP_t$ | nonhousing output, new houses, GDP measure | F18, F19, F34, F35 |
| Endogenous | $q_t,p_{l,t},R_t,\pi_t$ | house price, land price, nominal rate, inflation | F2, F3, F11, F28, F33 |
| Endogenous | $w_{c,t},w_{h,t},{w}'_{c,t},{w}'_{h,t}$ | real wages by sector/type | F6, F7, F16, F17, F20-F23, F29-F32 |
| Endogenous | $X_t,X_{wc,t},X_{wh,t},{X}'_{wc,t},{X}'_{wh,t}$ | price and wage markups | F20-F23, F28-F32 |
| Endogenous | $R_{c,t},R_{h,t},R_{l,t},z_{c,t},z_{h,t}$ | rental rates and utilization | F9, F10, F24-F26 |
| Endogenous | $Div_t,{Div}'_t,\phi_t,a(z)$ | dividends and costs | identities in section 4 |
| Exogenous | $u_{C,t},u_{H,t},u_{K,t}$ | technology innovations | F41-F43 |
| Exogenous | $u_{z,t},u_{\tau,t},u_{j,t}$ | preference, labor-supply, housing-preference innovations | F37-F39 |
| Exogenous | $u_{p,t},u_{R,t},u_{s,t}$ | price-markup, monetary policy, inflation-target innovations | F28, F33, F40 |
| Parameter | $\beta,{\beta}',G_C,j,\varepsilon,{\varepsilon}'$ | preferences and growth scaling | sections 2 and 6 |
| Parameter | $\mu_c,\mu_h,\mu_l,\mu_b,\alpha,\delta_h,\delta_{kc},\delta_{kh}$ | technology and depreciation | F18-F27, F35 |
| Parameter | $m$ | loan-to-value ratio | F13-F15 |
| Parameter | $\theta_{\pi},\theta_{wc},\theta_{wh},\iota_{\pi},\iota_{wc},\iota_{wh}$ | Calvo and indexation parameters | F28-F32 |
| Parameter | $r_R,r_{\pi},r_Y,\overline{rr}$ | Taylor-rule parameters | F33 |
| Parameter | $\rho_z,\rho_{\tau},\rho_j,\rho_s,\rho_{AC},\rho_{AH},\rho_{AK}$ | shock persistence | F37-F43 |
