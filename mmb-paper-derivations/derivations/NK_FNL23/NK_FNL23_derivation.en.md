# NK_FNL23 Derivation: Ferrari and Nispi Landi (2023)

> Archive status: `needs_review`. This first-pass derivation is extracted from the MinerU Markdown for Ferrari and Nispi Landi, "Towards a Green Economy: The Role of the Central Bank's Asset Purchases" (IJCB, 2023; DOI `10.2139/ssrn.4357535`). Runtime validation was not performed.

## 1. Model Overview

- **Model ID**: `NK_FNL23`.
- **Source**: Alessandro Ferrari and Valerio Nispi Landi, "Towards a Green Economy: The Role of the Central Bank's Asset Purchases".
- **Purpose**: medium-scale New Keynesian model with green and brown production sectors, household preferences over green and brown bonds, carbon taxation, pollution accumulation, and central-bank green asset purchases.
- **Agents and blocks**: representative household; final-good firm; intermediate-good firms with price adjustment costs; green and brown basic firms; capital producers; government and central bank.
- **Form**: nonlinear, detrended by labor-augmenting productivity \(z_t\), with Dynare-style first-order stochastic simulation in the MMB implementation cross-check. The paper appendix lists a 29-equation detrended equilibrium with policy paths \(\tau_t\) and \(\widetilde{re}_t\) treated as exogenous.
- **Source caveat**: the appendix equations are recoverable, but MinerU OCR has minor notation errors in several policy/balance-sheet lines; those equations are marked `needs_review`.

## 2. Optimization Problems

### 2.1 Household

The representative household chooses consumption, labor, public/reserve bond holdings, green bond holdings, and brown bond holdings:

\[
\max E_0\sum_{t=0}^{\infty}\beta^t\left[
\log(c_t-\varsigma c_{t-1})-\frac{h_t^{1+\varphi}}{1+\varphi}
+\frac{\nu_G}{1-\kappa_G}\left(\frac{B^G_{Ht}}{P_tz_t}\right)^{1-\kappa_G}
-\frac{\nu_B}{1+\kappa_B}\left(\frac{B^B_{Ht}}{P_tz_t}\right)^{1+\kappa_B}
\right]
\]

subject to the nominal budget constraint

\[
c_t+\frac{D_{Ht}+B^G_{Ht}+B^B_{Ht}}{P_t}
=\frac{r_{t-1}D_{H,t-1}+R^G_tB^G_{H,t-1}+R^B_tB^B_{H,t-1}}{P_t}
+w_th_t-t_t+\Gamma_t .
\]

Green bonds enter utility positively and brown bonds negatively, which makes these assets imperfect substitutes and allows central-bank portfolio composition to affect spreads.

### 2.2 Final-Good Firm

The final-good firm combines differentiated intermediate goods:

\[
y_t=\left[\int_0^1 y_t(i)^{\frac{\varepsilon-1}{\varepsilon}}\,di\right]^{\frac{\varepsilon}{\varepsilon-1}},
\]

and chooses each input subject to its relative price.

### 2.3 Intermediate-Good Firms

Intermediate firms combine green and brown sectoral output:

\[
y^I_t(i)=\left[(1-\zeta)^{1/\xi}y^G_t(i)^{\frac{\xi-1}{\xi}}+\zeta^{1/\xi}y^B_t(i)^{\frac{\xi-1}{\xi}}\right]^{\frac{\xi}{\xi-1}}.
\]

They minimize \(p^G_ty^G_t(i)+p^B_ty^B_t(i)\) subject to this CES aggregator and set prices under quadratic adjustment costs

\[
AC_t(i)=\frac{\kappa_P}{2}\left(\frac{P_t(i)}{P_{t-1}(i)}-\bar{\pi}\right)^2P_ty_t .
\]

### 2.4 Green and Brown Firms

Each sector \(j\in\{G,B\}\) produces with capital and labor:

\[
y^j_t=a_t(k^j_{t-1})^\alpha(z_th^j_t)^{1-\alpha}.
\]

Green firms do not pollute. Brown firms face an emissions tax and choose abatement \(\mu_t\), with net brown price

\[
p^{Bnet}_t=p^B_t-\tau_t(1-\mu_t)\nu_E-\frac{\nu_M}{1+\chi}\mu_t^{1+\chi}.
\]

### 2.5 Capital Producers

Capital producers choose investment and aggregate capital:

\[
\max E_0\sum_{t=0}^{\infty}\beta^t\frac{\lambda_t}{\lambda_0}
\left[q_tk_t-(1-\delta)q_tk_{t-1}-i_t\right]
\]

subject to

\[
k_t=(1-\delta)k_{t-1}+\left[1-\frac{\kappa_I}{2}\left(\frac{i_t}{i_{t-1}}-\theta\right)^2\right]i_t .
\]

### 2.6 Policy Authorities

The central bank holds green corporate bonds, brown corporate bonds, and public bonds/reserves:

\[
b^G_{Ct}+b^B_{Ct}+d_{Ct}=re_t .
\]

The government levies an emissions tax and rebates through the consolidated budget. The paper treats \(\tau_t\) and \(re_t\) as policy paths in the transition exercises.

## 3. First-Order Conditions

The following equations use the paper appendix's detrended notation. Tildes denote variables divided by \(z_t\); \(\theta\) is gross trend growth.

- **(F1) Labor supply**:

\[
h_t^\varphi=\widetilde{w}_t\widetilde{\lambda}_t .
\]

- **(F2) Euler equation for public bonds/reserves**:

\[
1=\beta E_t\left(\frac{\widetilde{\lambda}_{t+1}}{\widetilde{\lambda}_t\theta}\frac{r_t}{\pi_{t+1}}\right).
\]

- **(F3) Euler equation for green bonds**:

\[
1=\beta E_t\left[\frac{\widetilde{\lambda}_{t+1}}{\widetilde{\lambda}_t\theta}r^G_{t+1}\right]
+\frac{\nu_G}{\widetilde{\lambda}_t}\left(\widetilde{b}^G_{Ht}\right)^{-\kappa_G}.
\]

- **(F4) Euler equation for brown bonds**:

\[
1=\beta E_t\left[\frac{\widetilde{\lambda}_{t+1}}{\widetilde{\lambda}_t\theta}r^B_{t+1}\right]
-\frac{\nu_B}{\widetilde{\lambda}_t}\left(\widetilde{b}^B_{Ht}\right)^{\kappa_B}.
\]

- **(F5) CES production of the intermediate bundle**:

\[
\widetilde{y}_t=\left[(1-\zeta)^{1/\xi}(\widetilde{y}^G_t)^{\frac{\xi-1}{\xi}}
+\zeta^{1/\xi}(\widetilde{y}^B_t)^{\frac{\xi-1}{\xi}}\right]^{\frac{\xi}{\xi-1}}.
\]

- **(F6) Demand for green output**:

\[
\widetilde{y}^G_t=(1-\zeta)\left(\frac{p^G_t}{p^I_t}\right)^{-\xi}\widetilde{y}_t .
\]

- **(F7) Demand for brown output**:

\[
\widetilde{y}^B_t=\zeta\left(\frac{p^B_t}{p^I_t}\right)^{-\xi}\widetilde{y}_t .
\]

- **(F8) Nonlinear Phillips curve**:

\[
\pi_t(\pi_t-\bar{\pi})=\beta E_t\left[
\frac{\widetilde{\lambda}_{t+1}}{\widetilde{\lambda}_t}
\frac{\widetilde{y}_{t+1}}{\widetilde{y}_t}
\pi_{t+1}(\pi_{t+1}-\bar{\pi})\right]
+\frac{\varepsilon}{\kappa_P}\left(p^I_t-\frac{\varepsilon-1}{\varepsilon}\right).
\]

- **(F9) Green production**:

\[
\widetilde{y}^G_t=\left(\frac{\widetilde{k}^G_{t-1}}{\theta}\right)^\alpha(h^G_t)^{1-\alpha}.
\]

- **(F10) Brown production**:

\[
\widetilde{y}^B_t=\left(\frac{\widetilde{k}^B_{t-1}}{\theta}\right)^\alpha(h^B_t)^{1-\alpha}.
\]

- **(F11) Green labor demand**:

\[
\widetilde{w}_t h^G_t=(1-\alpha)p^G_t\widetilde{y}^G_t .
\]

- **(F12) Brown labor demand**:

\[
\widetilde{w}_t h^B_t=(1-\alpha)\left[p^B_t-\tau_t(1-\mu_t)\nu_E-\frac{\nu_M}{1+\chi}\mu_t^{1+\chi}\right]\widetilde{y}^B_t .
\]

- **(F13) Green capital demand**:

\[
r^G_{kt}\frac{\widetilde{k}^G_{t-1}}{\theta}=\alpha p^G_t\widetilde{y}^G_t .
\]

- **(F14) Brown capital demand**:

\[
r^B_{kt}\frac{\widetilde{k}^B_{t-1}}{\theta}
=\alpha\left[p^B_t-\tau_t(1-\mu_t)\nu_E-\frac{\nu_M}{1+\chi}\mu_t^{1+\chi}\right]\widetilde{y}^B_t .
\]

- **(F15) Green rental rate**:

\[
r^G_{kt}=r^G_tq_{t-1}-(1-\delta)q_t .
\]

- **(F16) Brown rental rate**:

\[
r^B_{kt}=r^B_tq_{t-1}-(1-\delta)q_t .
\]

- **(F17) Optimal abatement**:

\[
\mu_t=\left(\frac{\nu_E\tau_t}{\nu_M}\right)^{1/\chi}.
\]

- **(F18) Capital-producer Tobin's Q condition**:

\[
\begin{aligned}
1={}&q_t\left[1-\frac{\kappa_I}{2}\left(\frac{\widetilde{i}_t}{\widetilde{i}_{t-1}}\theta-\theta\right)^2
-\kappa_I\frac{\widetilde{i}_t}{\widetilde{i}_{t-1}}\theta\left(\frac{\widetilde{i}_t}{\widetilde{i}_{t-1}}\theta-\theta\right)\right]\\
&+\beta E_t\left[
\frac{\widetilde{\lambda}_{t+1}}{\widetilde{\lambda}_t\theta}q_{t+1}
\left(\frac{\widetilde{i}_{t+1}}{\widetilde{i}_t}\theta\right)^2
\kappa_I\left(\frac{\widetilde{i}_{t+1}}{\widetilde{i}_t}\theta-\theta\right)
\right].
\end{aligned}
\]

- **(F19) Marginal utility with external habits**:

\[
\widetilde{\lambda}_t=\frac{\theta}{\theta\widetilde{c}_t-\varsigma\widetilde{c}_{t-1}}
-\beta\varsigma E_t\left(\frac{1}{\theta\widetilde{c}_{t+1}-\varsigma\widetilde{c}_t}\right).
\]

## 4. Market Clearing & Identities

- **(F20) Emission function**:

\[
\widetilde{e}_t=(1-\mu_t)\nu_E\widetilde{y}^B_t .
\]

- **(F21) Pollution accumulation**:

\[
\widetilde{x}_t=(1-\delta^x)\frac{\widetilde{x}_{t-1}}{\theta}+\widetilde{e}_t+\widetilde{e}^{row}.
\]

- **(F22) Capital accumulation**:

\[
\widetilde{k}_t=(1-\delta)\frac{\widetilde{k}_{t-1}}{\theta}
+\left[1-\frac{\kappa_I}{2}\left(\frac{\widetilde{i}_t}{\widetilde{i}_{t-1}}\theta-\theta\right)^2\right]\widetilde{i}_t .
\]

- **(F23) Resource constraint**:

\[
\widetilde{y}_t=\widetilde{c}_t+\widetilde{i}_t+\widetilde{g}
+\widetilde{y}^B_t\frac{\nu_M}{1+\chi}\mu_t^{1+\chi}
+\frac{\kappa_P}{2}(\pi_t-\bar{\pi})^2\widetilde{y}_t .
\]

- **(F24) Labor market clearing**:

\[
h_t=h^B_t+h^G_t .
\]

- **(F25) Capital market clearing**:

\[
\widetilde{k}_t=\widetilde{k}^B_t+\widetilde{k}^G_t .
\]

- **(F26) Green bond market clearing**:

\[
q_t\widetilde{k}^G_t=\widetilde{b}^G_{Ht}+\widetilde{b}^G_{Ct}.
\]

- **(F27) Brown bond market clearing** (`needs_review`: appendix OCR omits the time subscript on central-bank brown bonds):

\[
q_t\widetilde{k}^B_t=\widetilde{b}^B_{Ht}+\widetilde{b}^B_{Ct}.
\]

- **(F28) Central-bank balance sheet** (`needs_review`: MinerU renders real reserves ambiguously):

\[
\widetilde{b}^G_{Ct}+\widetilde{b}^B_{Ct}+\widetilde{d}_{Ct}=\widetilde{re}_t .
\]

- **(F29) Carbon price conversion**:

\[
p^C_t=\frac{s_1s_2}{s_3}\tau_t .
\]

- **(F30) Euro-area pollution stock**:

\[
\widetilde{x}^{ea}_t=(1-\delta^x)\frac{\widetilde{x}^{ea}_{t-1}}{\theta}+\widetilde{e}_t .
\]

## 5. Exogenous Processes

- **(F31) TFP process**:

\[
\log(a_t)=\log(\bar{a})+\rho_a\log(a_{t-1})+v^a_t .
\]

- **Policy paths**: the paper's appendix treats \(\tau_t\) and \(\widetilde{re}_t\) as exogenous policy instruments for transition and Green QE scenarios rather than stationary shock processes.
- **Implementation cross-check only**: `NK_FNL23_rep.mod` adds stochastic processes for \(a_t\), investment-specific productivity \(\varepsilon^I_t\), government spending \(G_t\), and a monetary policy shock in the Taylor rule. Those additions are useful for MMB simulation coverage but are not treated here as paper-side source equations.

## 6. Steady-State Solution

The paper provides initial and final steady-state construction steps rather than closed-form values for every variable.

Initial steady state:

1. Set \(\tau=0\), implying \(\mu=0\).
2. Use the bond Euler equation to set \(\beta=\theta/rr\), with \(rr=r/\pi\).
3. Set \(\pi=\bar{\pi}\), \(r=\bar{\pi}\theta/\beta\), \(r^G=rr+\gamma^G\), \(r^B=rr+\gamma^B\), \(q=1\), \(r^G_k=r^G-(1-\delta)\), and \(r^B_k=r^B-(1-\delta)\).
4. From the Phillips curve, \(p^I=(\varepsilon-1)/\varepsilon\).
5. Given \(p^B\), compute \(p^G\) from

\[
p^G=\left\{\frac{(p^I)^{1-\xi}-\zeta(p^B)^{1-\xi}}{1-\zeta}\right\}^{1/(1-\xi)}.
\]

6. Determine sectoral outputs from (F6) and (F7), pollution from (F20)-(F21), investment and aggregate capital from the investment-output ratio and (F22), and sectoral capital from (F13)-(F14).
7. Determine sectoral labor from (F9)-(F10), wage from (F11), government spending from the \(g/y\) calibration, consumption from (F23), and aggregate labor from (F24).
8. Household bond holdings follow from (F26)-(F27), and \(\kappa_G,\kappa_B,\nu_G,\nu_B\) are backed out from the steady-state spread and bond Euler equations.

The remaining initial steady-state system is:

\[
\widetilde{w}h^B=(1-\alpha)\left[p^B-\tau(1-\mu)\nu_E-\frac{\nu_M}{1+\chi}\mu^{1+\chi}\right]\widetilde{y}^B,
\]

\[
\widetilde{\lambda}\widetilde{w}=h^\varphi,
\]

\[
\widetilde{e}=(1-\mu)\nu_E\widetilde{y}^B.
\]

Final steady state:

- Set \(\mu=1\), so \(\widetilde{e}=0\).
- Solve a four-variable system in \(\{\widetilde{y},p^B,r^G,r^B\}\): brown labor demand, aggregate labor supply, and the two bond Euler equations.

Runtime validation: not performed.

## 7. Timing & Form Conventions

- Variables are detrended by labor-augmenting productivity \(z_t\); tildes in the appendix indicate detrended levels.
- \(k_t\), \(k^G_t\), and \(k^B_t\) are end-of-period capital stocks. Production at \(t\) uses \(k^j_{t-1}/\theta\).
- Bonds \(b^G_t\) and \(b^B_t\) finance sectoral capital purchases and clear with household plus central-bank holdings.
- The model is nonlinear in levels. The MMB `.mod` implementation uses first-order perturbation after a nonlinear steady-state block; it also introduces additional stochastic shocks for business-cycle simulation.
- The paper's transition exercises use exogenous policy paths for the carbon tax and central-bank reserves.

## 8. Variable & Parameter Reference Table

### Endogenous Variables

| Symbol | Description | Main determining equations |
|---|---|---|
| \(\widetilde{c}\) | detrended consumption | F19, F23 |
| \(\widetilde{i}\) | detrended investment | F18, F22, F23 |
| \(\widetilde{y}\) | detrended final output | F5, F23 |
| \(\widetilde{k}\) | aggregate capital | F22, F25 |
| \(h\) | aggregate labor | F1, F24 |
| \(\widetilde{w}\) | detrended wage | F1, F11, F12 |
| \(q\) | capital price | F15, F16, F18 |
| \(p^I\) | intermediate-bundle price / real marginal cost | F6, F7, F8 |
| \(\pi\) | gross inflation | F2, F8 |
| \(r\) | nominal public/reserve rate | F2 |
| \(r^G,r^B\) | green and brown real bond rates | F3, F4, F15, F16 |
| \(\widetilde{b}^G_H,\widetilde{b}^B_H\) | household green/brown bonds | F3, F4, F26, F27 |
| \(\widetilde{b}^G_C,\widetilde{b}^B_C\) | central-bank green/brown bonds | F26, F27, F28 |
| \(\mu\) | brown-sector abatement share | F17 |
| \(p^G,p^B\) | green and brown sector prices | F6, F7, F11-F14 |
| \(\widetilde{k}^G,\widetilde{k}^B\) | sectoral capital | F13-F16, F25 |
| \(h^G,h^B\) | sectoral labor | F9-F12, F24 |
| \(r^G_k,r^B_k\) | rental rates of green/brown capital | F13-F16 |
| \(\widetilde{e}\) | emissions | F20 |
| \(\widetilde{x},\widetilde{x}^{ea}\) | global and euro-area pollution stocks | F21, F30 |
| \(\widetilde{y}^G,\widetilde{y}^B\) | green and brown output | F5-F7, F9-F10 |
| \(\widetilde{\lambda}\) | marginal utility of consumption | F19 |

### Exogenous / Policy Variables

| Symbol | Description | Source status |
|---|---|---|
| \(v^a\) | TFP innovation | paper appendix |
| \(\tau\) | carbon-tax policy path | paper appendix |
| \(\widetilde{re}\) | real central-bank reserve policy path | paper appendix |
| \(v^i,v^m,v^g\) | investment, monetary, and government-spending innovations | implementation cross-check only |

### Parameters

| Symbol | Description |
|---|---|
| \(\beta\), \(\varsigma\), \(\varphi\) | discount factor, habit, inverse Frisch elasticity |
| \(\nu_G,\nu_B,\kappa_G,\kappa_B\) | green/brown bond utility levels and curvatures |
| \(\varepsilon,\kappa_P,\bar{\pi}\) | differentiated-good elasticity, price adjustment cost, inflation target |
| \(\zeta,\xi\) | brown-good weight and green-brown elasticity of substitution |
| \(\alpha,\delta,\kappa_I,\theta\) | capital share, depreciation, investment adjustment cost, trend growth |
| \(\nu_E,\nu_M,\chi,\delta^x,e^{row}\) | emissions intensity, abatement cost, abatement curvature, pollution decay, rest-of-world emissions |
| \(\rho_a\) | TFP persistence |
| \(s_1,s_2,s_3\) | carbon-price conversion factors |
