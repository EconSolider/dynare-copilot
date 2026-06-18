# NK_NS14 -- Derivation (Optimization Problems + Equilibrium Conditions)

> Status: `needs_review`. This first-pass archive entry is extracted from the MinerU Markdown source for Nakamura and Steinsson (2014). The paper describes the two-region monetary-union framework in the main text and refers variable-capital details to online appendices F/G. The MMB implementation cross-check is `model(linear)` and was not run.

Source: Emi Nakamura and Jon Steinsson (2014), "Fiscal stimulus in a monetary union: Evidence from US regions," *American Economic Review* 104(3), 753-792. DOI: `10.1257/aer.104.3.753`.

## 1. Model Overview

- **Model**: `NK_NS14`, a two-region open-economy New Keynesian monetary-union model for interpreting regional government-spending multipliers.
- **Regions**: home region of size \(n\) and foreign region of size \(1-n\); home receives the focal government-spending shock.
- **Agents and blocks**: complete-markets households, CES final-consumption aggregators, monopolistically competitive firms with Calvo pricing, a federal fiscal authority, a common monetary authority, and, in the MMB implementation, variable capital and investment adjustment costs.
- **Shocks**: home government spending, foreign government spending, and a common monetary-policy shock.
- **Form**: `model(linear)` in percentage/log deviations from the deterministic steady state. Hatted variables in the paper correspond to the MMB lower-case linear variables. Runtime validation: not performed.

## 2. Optimization Problems

### 2.1 Households

Home households of labor type \(x\) maximize:

\[
E_0\sum_{t=0}^{\infty}\beta^t u(C_t,L_t(x)).
\]

The consumption aggregate is:

\[
C_t=\left[\phi_H^{1/\eta}C_{Ht}^{(\eta-1)/\eta}
+\phi_F^{1/\eta}C_{Ft}^{(\eta-1)/\eta}\right]^{\eta/(\eta-1)}.
\]

Home and foreign goods aggregates are CES composites over varieties:

\[
C_{Ht}=\left[\int_0^1 c_{ht}(z)^{(\theta-1)/\theta}dz\right]^{\theta/(\theta-1)},
\qquad
C_{Ft}=\left[\int_0^1 c_{ft}(z)^{(\theta-1)/\theta}dz\right]^{\theta/(\theta-1)}.
\]

The household budget constraint is:

\[
P_tC_t+E_t[M_{t,t+1}B_{t+1}(x)]
\leq B_t(x)+(1-\tau_t)W_t(x)L_t(x)+\int_0^1\Xi_{ht}(z)dz-T_t.
\]

The paper considers both separable and GHH preferences:

\[
u(C_t,L_t)=\frac{C_t^{1-\sigma^{-1}}}{1-\sigma^{-1}}
-\chi\frac{L_t^{1+\nu^{-1}}}{1+\nu^{-1}},
\]

\[
u(C_t,L_t)=
\frac{\left(C_t-\chi L_t^{1+\nu^{-1}}/(1+\nu^{-1})\right)^{1-\sigma^{-1}}}
{1-\sigma^{-1}}.
\]

The MMB implementation uses the reduced linear equations calibrated from the paper's GHH/variable-capital specification.

### 2.2 Government

Government demand for differentiated goods uses the same CES form as private demand:

\[
g_{ht}(z)=G_{Ht}\left(\frac{p_{ht}(z)}{P_{Ht}}\right)^{-\theta},
\qquad
g_{ft}(z)=G_{Ft}\left(\frac{p_{ft}(z)}{P_{Ft}}\right)^{-\theta}.
\]

Home and foreign government spending follow AR(1) processes. The common central bank sets one economy-wide nominal interest rate using an augmented Taylor rule.

### 2.3 Firms

In the main-text baseline, home firm \(z\) produces differentiated output with labor:

\[
y_{ht}(z)=f(L_t(z)).
\]

The firm maximizes:

\[
E_t\sum_{j=0}^{\infty}M_{t,t+j}
\left[p_{ht+j}(z)y_{ht+j}(z)-W_{t+j}(x)L_{t+j}(z)\right],
\]

subject to demand:

\[
y_{ht}(z)=\left(nC_{Ht}+(1-n)C_{Ht}^{\ast}+nG_{Ht}\right)
\left(\frac{p_{ht}(z)}{P_{Ht}}\right)^{-\theta}.
\]

For the variable-capital MMB version, the paper says the online appendices add capital accumulation and investment; the implementation cross-check confirms home and foreign capital stocks, investment, and optimal investment equations.

## 3. First-Order Conditions

The equations below give the MMB linear equilibrium system, using the paper equations as source where available and `.mod` only to cross-check coverage, timing, and names. Variables are deviations from steady state.

- **(F1) Home consumption Euler equation**:

\[
c_t=c_{t+1}-\sigma_c(r_t-\pi_{t+1})
+\frac{\sigma_c}{\sigma_l}l_t-\frac{\sigma_c}{\sigma_l}l_{t+1}.
\]

- **(F2) Complete-markets Backus-Smith condition**:

\[
c_t-c_t^{\ast}=\sigma_c q_t+\frac{\sigma_c}{\sigma_l}(l_t-l_t^{\ast}).
\]

- **(F3) Home Phillips curve**:

\[
\pi_{H,t}=\beta E_t\pi_{H,t+1}+\kappa\zeta s_{H,t}.
\]

- **(F4) Foreign Phillips curve**:

\[
\pi_{F,t}=\beta E_t\pi_{F,t+1}+\kappa\zeta s_{F,t}.
\]

- **(F5) Home CPI inflation aggregator**:

\[
\pi_t=\phi_H\pi_{H,t}+\phi_F\pi_{F,t}.
\]

- **(F6) Foreign CPI inflation aggregator**:

\[
\pi_t^{\ast}=\phi_H^{\ast}\pi_{H,t}+\phi_F^{\ast}\pi_{F,t}.
\]

- **(F7) Home production function with predetermined capital**:

\[
y_t=a\,l_t+(1-a)k_{t-1}.
\]

- **(F8) Foreign production function with predetermined capital**:

\[
y_t^{\ast}=a\,l_t^{\ast}+(1-a)k_{t-1}^{\ast}.
\]

- **(F9) Home real wage / labor supply relation**:

\[
w_t=\nu^{-1}l_t.
\]

- **(F10) Foreign real wage / labor supply relation**:

\[
w_t^{\ast}=\nu^{-1}l_t^{\ast}.
\]

- **(F11) Home real marginal cost**:

\[
s_{H,t}+p_{H,t}=\bar\omega y_t-(\bar\omega-\nu^{-1})k_{t-1}.
\]

- **(F12) Foreign real marginal cost**:

\[
s_{F,t}-\frac{\phi_H}{\phi_F}\phi_F^{\ast}p_{H,t}
=\bar\omega y_t^{\ast}-(\bar\omega-\nu^{-1})k_{t-1}^{\ast}+q_t.
\]

- **(F13) Home capital accumulation**:

\[
k_t=(1-\delta)k_{t-1}+\delta i_t.
\]

- **(F14) Foreign capital accumulation**:

\[
k_t^{\ast}=(1-\delta)k_{t-1}^{\ast}+\delta i_t^{\ast}.
\]

- **(F15) Home optimal investment condition** (`needs_review`: sourced from implementation cross-check because the online appendix formulas are not present in the MinerU main-text Markdown):

\[
\sigma_c^{-1}c_t-\sigma_c^{-1}E_tc_{t+1}
-\sigma_l^{-1}l_t+\sigma_l^{-1}E_tl_{t+1}
-(1+\beta)\varepsilon_\phi k_t
-(1-\beta(1-\delta))\rho_k k_t
+\beta\varepsilon_\phi E_tk_{t+1}
+(1-\beta(1-\delta))\rho_yE_ty_{t+1}
=-\varepsilon_\phi k_{t-1}.
\]

- **(F16) Foreign optimal investment condition** (`needs_review`: same source limitation as F15):

\[
\sigma_c^{-1}c_t^{\ast}-\sigma_c^{-1}E_tc_{t+1}^{\ast}
-\sigma_l^{-1}l_t^{\ast}+\sigma_l^{-1}E_tl_{t+1}^{\ast}
-(1+\beta)\varepsilon_\phi k_t^{\ast}
-(1-\beta(1-\delta))\rho_k k_t^{\ast}
+\beta\varepsilon_\phi E_tk_{t+1}^{\ast}
+(1-\beta(1-\delta))\rho_yE_ty_{t+1}^{\ast}
=-\varepsilon_\phi k_{t-1}^{\ast}.
\]

## 4. Market Clearing & Identities

- **(F17) Home resource constraint**:

\[
\begin{aligned}
y_t={}&\phi_H\bar C c_t+\frac{1-n}{n}\phi_H^{\ast}\bar C c_t^{\ast}
+\bar I\phi_H i_t+\frac{1-n}{n}\phi_H^{\ast}\bar I i_t^{\ast} \\
&-\eta(\bar C+\bar I)\left(\phi_H+\frac{1-n}{n}\phi_H^{\ast}\right)p_{H,t}
+\eta(\bar C+\bar I)\frac{1-n}{n}\phi_H^{\ast}q_t+g_t.
\end{aligned}
\]

- **(F18) Foreign resource constraint**:

\[
\begin{aligned}
y_t^{\ast}={}&\phi_F^{\ast}\bar C c_t^{\ast}+\frac{n}{1-n}\phi_F\bar C c_t
+\bar I\phi_F^{\ast} i_t^{\ast}+\frac{n}{1-n}\bar I\phi_F i_t \\
&+\eta(\bar C+\bar I)\left(\phi_F^{\ast}+\frac{n}{1-n}\phi_F\right)
\frac{\phi_H}{\phi_F}p_{H,t}
+\eta(\bar C+\bar I)\phi_F^{\ast}q_t+g_t^{\ast}.
\end{aligned}
\]

- **(F19) Home relative-price law of motion**:

\[
p_{H,t}-p_{H,t-1}=\pi_{H,t}-\pi_t.
\]

- **(F20) Real exchange-rate identity**:

\[
\phi_H^{\ast}p_{H,t}-\frac{\phi_H}{\phi_F}\phi_F^{\ast}p_{H,t}=q_t.
\]

- **(F21) Home nominal output identity**:

\[
ny_t=y_t+p_t.
\]

- **(F22) Foreign nominal output identity**:

\[
ny_t^{\ast}=y_t^{\ast}+p_t^{\ast}.
\]

- **(F23) Home producer price index**:

\[
p_t=\pi_{H,t}+p_{t-1}.
\]

- **(F24) Foreign producer price index**:

\[
p_t^{\ast}=\pi_{F,t}+p_{t-1}^{\ast}.
\]

## 5. Exogenous Processes

- **(F25) Common monetary policy rule**:

\[
r_t=\rho_i r_{t-1}+(1-\rho_i)
\left[\phi_\pi(n\pi_t+(1-n)\pi_t^{\ast})+\phi_y(ny_t+(1-n)y_t^{\ast})
+\phi_g(ng_t+(1-n)g_t^{\ast})\right]+\varepsilon^r_t.
\]

- **(F26) Government spending processes**:

\[
g_t=\rho_G g_{t-1}+\varepsilon^g_t,\qquad
g_t^{\ast}=\rho_G g_{t-1}^{\ast}+\varepsilon^{g\ast}_t.
\]

## 6. Steady-State Solution

Because the MMB model is `model(linear)`, all endogenous variables are deviations from the deterministic steady state and have zero steady state in the Dynare model block:

\[
\bar c=\bar c^{\ast}=\bar r=\bar\pi=\bar\pi^{\ast}=\bar y=\bar y^{\ast}=\bar g=\bar g^{\ast}=0.
\]

The nonzero levels used to construct the linear coefficients are calibrated outside the model block:

\[
\beta=0.99,\quad \nu=1,\quad a=0.67,\quad \eta=2,\quad \theta=7,\quad
\delta=0.012,\quad n=0.1,\quad \phi_H=0.69,\quad \rho_G=0.933.
\]

Key steady-state ratios are:

\[
\bar K/\bar L=\left[(1-a)\frac{\beta}{1-\beta(1-\delta)}
\frac{\theta-1}{\theta}\right]^{1/a},
\]

\[
\bar I=\delta(\bar K/\bar L)^a,\qquad
\bar G=0.2,\qquad \bar C=1-\bar G-\bar I.
\]

The implementation cross-check computes reduced-form coefficients \(\sigma_c\), \(\sigma_l\), \(\kappa\), \(\bar\omega\), \(\rho_y\), \(\rho_k\), and \(\zeta\) from these calibrated primitives. These coefficient formulas should be reviewed against the online appendix before upgrading the status.

## 7. Timing & Form Conventions

- The archive entry is linear: all variables in F1-F26 are log/percentage deviations from deterministic steady state.
- Capital is predetermined in production and marginal-cost equations: \(k_{t-1}\) and \(k_{t-1}^{\ast}\) enter F7, F8, F11, and F12.
- Capital accumulation equations define end-of-period capital \(k_t\) and \(k_t^{\ast}\) from previous capital and current investment.
- Inflation and price indices use producer-price and CPI aggregators; \(p_{H,t}\) is the home relative price used to build the real exchange rate.
- Complete markets imply the Backus-Smith condition. The incomplete-markets extension in the paper is not the MMB baseline equation set.
- Runtime validation, Blanchard-Kahn checks, and IRF replication were not performed.

## 8. Variable & Parameter Reference Table

| Category | Symbol / MMB name | Meaning | Main equations |
|---|---|---|---|
| Endogenous | \(c\), \(c^{\ast}\) / `c`, `cf` | home and foreign consumption | F1, F2, F17, F18 |
| Endogenous | \(r\) / `r` | common nominal interest-rate deviation | F1, F25 |
| Endogenous | \(\pi\), \(\pi^{\ast}\) / `pi`, `pif` | home and foreign CPI inflation | F5, F6, F25 |
| Endogenous | \(\pi_H\), \(\pi_F\) / `piH`, `piF` | home-good and foreign-good inflation | F3, F4, F23, F24 |
| Endogenous | \(l\), \(l^{\ast}\) / `l`, `lf` | home and foreign labor | F1, F2, F7, F8, F9, F10 |
| Endogenous | \(p_H\), \(q\) / `pH`, `q` | home relative price and real exchange rate | F19, F20 |
| Endogenous | \(p\), \(p^{\ast}\) / `p`, `pf` | producer price indices | F21, F22, F23, F24 |
| Endogenous | \(s_H\), \(s_F\) / `sH`, `sF` | home and foreign real marginal cost | F3, F4, F11, F12 |
| Endogenous | \(y\), \(y^{\ast}\) / `y`, `yf` | home and foreign output | F7, F8, F17, F18, F25 |
| Endogenous | \(g\), \(g^{\ast}\) / `g`, `gf` | home and foreign government spending | F17, F18, F25, F26 |
| Endogenous | \(w\), \(w^{\ast}\) / `w`, `wf` | home and foreign real wages | F9, F10 |
| Endogenous | \(i\), \(i^{\ast}\) / `i`, `if` | home and foreign investment | F13, F14, F15, F16 |
| Endogenous | \(k\), \(k^{\ast}\) / `k`, `kf` | home and foreign capital | F7, F8, F11-F16 |
| Endogenous | \(ny\), \(ny^{\ast}\) / `ny`, `nyf` | home and foreign nominal output | F21, F22 |
| Exogenous | \(\varepsilon^g\), \(\varepsilon^{g\ast}\) / `eg`, `egf` | government-spending innovations | F26 |
| Exogenous | \(\varepsilon^r\) / `er` | monetary-policy innovation | F25 |
| Parameters | `sigma_c`, `sigma_l`, `beta`, `kappa`, `zeta` | reduced utility and Phillips-curve coefficients | F1-F4 |
| Parameters | `phiH`, `phiF`, `phiHstar`, `phiFstar`, `eta`, `nn` | home-bias, trade elasticity, and region size | F5, F6, F17, F18, F20 |
| Parameters | `Cbar`, `Ibar`, `delta`, `eps_phi`, `rho_y`, `rho_k` | steady ratios, depreciation, investment adjustment cost | F13-F18 |
| Parameters | `rhoii`, `phiPi`, `phiY`, `phiG`, `rhoG` | policy and fiscal-shock persistence | F25, F26 |
| Parameters | `aa`, `nu`, `omegaBar` | production/labor and marginal-cost coefficients | F7-F12 |
