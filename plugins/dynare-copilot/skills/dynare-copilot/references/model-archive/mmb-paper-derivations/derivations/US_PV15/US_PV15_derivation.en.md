# US_PV15 -- Derivation

> First-pass archive extraction. Status: `needs_review`. Runtime validation: not performed. Source formulas are taken from the MinerU Markdown for Poutineau and Vermandel (2015); the representative `.mod` file is used only as `implementation_cross_check`.

## 1. Model Overview

- **Model**: `US_PV15`, Poutineau and Vermandel (2015), "Financial frictions and the extensive margin of activity."
- **Paper and provenance**: Jean-Christophe Poutineau and Gauthier Vermandel, *Research in Economics* 69(4), 525-554, DOI `10.1016/j.rie.2015.09.005`.
- **Economy**: estimated US DSGE model for 1993Q1-2012Q3 with endogenous firm entry, financial accelerator frictions, sticky wages, sticky prices, sticky lending rates, capital adjustment costs, variable utilization, and multiple exogenous shocks.
- **Agents and blocks**: households, labor unions, installed firms, startups/entrants, entrepreneurs, financial intermediaries, capital suppliers, and a monetary authority.
- **Model form**: nonlinear equilibrium system written in levels. The implementation cross-check uses a nonlinear Dynare `model` block and first-order stochastic simulation, not `model(linear)`.
- **Variant note**: the paper-side archive entry records the financial-friction model. The `.mod` implementation also contains a natural/flexible counterpart for output-gap construction; that counterpart is noted only as `implementation_cross_check`.

## 2. Optimization Problems

### Households

Households consume, supply labor, hold deposits, and value shares in installed firms. The paper summary gives the household marginal utility, deposit Euler equation, share Euler equation, labor-supply condition, and free-entry valuation rather than a single full budget constraint:

$$
\lambda_t^c = (C_t - h C_{t-1})^{-\sigma_c}.
$$

The stochastic discount factor used by households, financial intermediaries, and capital suppliers is

$$
M_{t,t+1} = \beta\,\frac{\lambda_{t+1}^c}{\lambda_t^c}.
$$

### Labor Unions

Labor unions set wages under monopolistic competition and Rotemberg-style wage adjustment costs. Their optimality condition links the real wage to the household marginal rate of substitution and expected wage-adjustment terms.

### Installed Firms

Installed firms produce differentiated intermediate goods with capital services and labor, choose inputs to minimize cost, and set prices with a time-varying markup and price-adjustment costs.

### Startups

Startups transform entry labor into new productive varieties. Entrants face a sunk labor requirement and their entry cost is partly affected by the lending rate through the wage-bill-in-advance channel.

### Entrepreneurs

Entrepreneurs finance both the intensive margin, capital for installed firms, and the extensive margin, entry labor costs. The balance-sheet constraint is

$$
L_{t+1} + NW_{t+1} = Q_t K_{t+1} + \gamma W_t H_t^E.
$$

Entrepreneurs choose investment finance before project idiosyncratic returns are realized. Project productivity follows a Pareto distribution with cutoff $\omega_t^C$, and optimistic beliefs generate an external finance premium increasing in leverage.

### Financial Intermediaries

Banks collect deposits, lend to entrepreneurs, bear monitoring losses in default states, and set lending rates subject to monopolistic competition and Rotemberg adjustment costs.

### Capital Suppliers

Capital suppliers transform investment goods into installed capital subject to investment adjustment costs, choose the shadow value of capital, and determine utilization.

## 3. First-Order Conditions

- **(F1) Marginal utility of consumption**:
$$
\lambda_t^c = (C_t - h C_{t-1})^{-\sigma_c}.
$$

- **(F2) Deposit Euler equation**:
$$
\beta E_t\left[\frac{\lambda_{t+1}^c}{\lambda_t^c}\right] e^{\varepsilon_t^B}(1+r_t)=1.
$$

- **(F3) Share Euler equation**:
$$
v_t=(1-\delta)\beta E_t\left[\frac{\lambda_{t+1}^c}{\lambda_t^c}\left(d_{t+1}+v_{t+1}+\theta d_{t+1}^E\right)\right].
$$

- **(F4) Labor supply**:
$$
\lambda_t^c w_t^h=\chi H_{jt}^{\sigma_H}.
$$

- **(F5) Free entry condition**:
$$
f_E mc_t^E
=v_t\frac{\partial[(1-AC_t^E)n_t^E]}{\partial n_t^E}e^{\varepsilon_t^E}
+\beta E_t\left[
v_{t+1}\frac{\partial(1-AC_{t+1}^E)}{\partial n_t^E}n_{t+1}^E e^{\varepsilon_{t+1}^E}
\right].
$$

- **(F6) Wage-setting condition**:
$$
\frac{W_t}{P_t^C}
=\mu_t^W\frac{W_t^h}{P_t^C}
-(\mu_t^W-1)W_t\left[
AC_t^{W\prime}
+\beta E_t\left\{\frac{\lambda_{t+1}^c}{\lambda_t^c}\frac{H_{t+1}}{H_t}AC_{t+1}^{W\prime}\right\}
\right].
$$

- **(F7) Installed-firm production function**:
$$
n_tY_t=e^{\varepsilon_t^A}(K_{t+1}^u)^\alpha(H_t^d)^{1-\alpha}.
$$

- **(F8) Utilized capital**:
$$
K_{t+1}^u=u_tK_t.
$$

- **(F9) Real marginal cost**:
$$
mc_t=\frac{1}{e^{\varepsilon_t^A}}
\left(\frac{z_t}{\alpha}\right)^\alpha
\left(\frac{w_t}{1-\alpha}\right)^{1-\alpha}.
$$

- **(F10) Cost-minimizing input mix**:
$$
\alpha H_t^d w_t=(1-\alpha)K_{t+1}^u z_t.
$$

- **(F11) Relative price markup relation**:
$$
\rho_t=\mu_t mc_t.
$$

- **(F12) Time-varying goods markup** (`needs_review`: MinerU OCR around the auxiliary $\Psi_t$ expression is noisy):
$$
\mu_t=e^{\varepsilon_t^P}
\frac{\epsilon_P}{(\epsilon_P-1)\left(1-\frac{P_t^C}{P_t}AC_t^P\right)+\kappa_P\Psi_t}.
$$

- **(F13) Price-adjustment auxiliary term** (`needs_review`):
$$
\Psi_t =
\left(\pi_t-[\xi_P\pi_{t-1}+(1-\xi_P)]\right)\pi_t
-\beta E_t\left\{
\frac{\lambda_{t+1}^c}{\lambda_t^c}
\left[
\left(\pi_t-[\xi_P\pi_{t-1}+(1-\xi_P)]\right)
\pi_{t+1}\frac{Y_{t+1}}{Y_t}
\right]\right\}.
$$

- **(F14) Installed-firm dividends**:
$$
d_t=(\rho_t-mc_t-AC_t^P)Y_t.
$$

- **(F15) Startup production technology**:
$$
n_t^E f_E=e^{\varepsilon_t^A}H_t^E.
$$

- **(F16) Marginal cost of a new firm**:
$$
mc_t^E=\frac{w_t}{e^{\varepsilon_t^A}}(1+\gamma r_t^L).
$$

- **(F17) Entrepreneur balance sheet**:
$$
L_{t+1}+NW_{t+1}=Q_tK_{t+1}+\gamma W_tH_t^E.
$$

- **(F18) Default cutoff**:
$$
\omega_t^C(1+r_t^k)Q_{t-1}K_t=(1+r_{t-1}^L)L_t.
$$

- **(F19) External finance premium / entrepreneur FOC** (`needs_review`: paper notation mixes $\chi$ and $\varkappa$ in nearby equations):
$$
\frac{1+E_t r_{t+1}^k}{1+r_t^L}
=\frac{\kappa-1}{\kappa\bar{\omega}^C}
\left[
\frac{\kappa}{\kappa-1}\left(\frac{L_{t+1}}{Q_tK_{t+1}}\right)
\right]^\chi.
$$

- **(F20) Entrepreneur net-worth law of motion**:
$$
NW_{t+1}=(1-\delta)(1-\theta)d_t^E+T^E.
$$

- **(F21) Entrepreneurial dividends**:
$$
n_td_t^E=\eta_t(\bar{\omega}_t-\omega_t^C)(1+R_t^k)Q_{t-1}K_t e^{\varepsilon_t^N}.
$$

- **(F22) Marginal cost of loans**:
$$
1+MC_t^L=(1+R_t)E_t\left[
\eta_{t+1}+(1-\mu^B)(1-\eta_{t+1})\frac{\omega_{t+1}}{\omega_{t+1}^C}
\right]^{-1}.
$$

- **(F23) Nominal lending-rate setting**:
$$
R_t^L=\mu_t^LMC_t^L
-(\mu_t^L-1)R_t^L
\left(
\frac{\partial AC_t^L}{\partial R_t^L}
+\beta E_t\left\{
\frac{\lambda_{t+1}^c}{\lambda_t^c}
\frac{\partial AC_{t+1}^L}{\partial R_t^L}
\frac{L_{t+2}}{L_{t+1}}
\right\}
\right).
$$

- **(F24) Real lending rate**:
$$
1+r_t^L=\frac{1+R_t^L}{E_t\pi_{t+1}^C}.
$$

- **(F25) Capital accumulation**:
$$
K_{t+1}=e^{\varepsilon_t^I}(1-AC_t^I)I_t+(1-\delta)K_t.
$$

- **(F26) Shadow value of installed capital** (`needs_review`: source equation begins with $\varepsilon_t^I q_t$; implementation cross-check uses $e^{\varepsilon_t^I}q_t$):
$$
\varepsilon_t^I q_t
=1+e^{\varepsilon_t^I}q_t
\frac{\partial(I_{kt}AC_{kt}^I)}{\partial I_{kt}}
+\beta E_t\left\{
\frac{\lambda_{t+1}^c}{\lambda_t^c}e^{\varepsilon_{t+1}^I}\pi_{t+1}^Cq_{t+1}
\frac{\partial(I_{k,t+1}AC_{k,t+1}^I)}{\partial I_{kt}}
\right\}.
$$

- **(F27) Utilization condition**:
$$
z_t=\bar{Z}\exp\left[\frac{\psi}{1-\psi}(u_t-1)\right].
$$

- **(F28) Return on capital**:
$$
1+r_t^k=\frac{z_tu_t-\Phi(u_t)+(1-\delta)q_t}{q_{t-1}}.
$$

## 4. Market Clearing & Identities

- **(F29) Monetary policy rule** (`needs_review`: source uses both $\rho$ and $\rho_R$ in the same equation):
$$
R_t-\bar{R}
=\rho(R_{t-1}-\bar{R})
+(1-\rho_R)\left[\phi_\pi(\pi_t-1)+\phi_Y(Y_t-\bar{Y})\right]
+\phi_{\Delta Y}(Y_t-Y_{t-1})+\varepsilon_t^R.
$$

- **(F30) Fisher equation**:
$$
1+r_t=\frac{1+R_t}{E_t\pi_{t+1}^C}.
$$

- **(F31) Aggregate demand / resource constraint**:
$$
Y_t^d=C_t+I_t+\bar{G}\varepsilon_t^G+\Phi(u_t)K_{t-1}
+n_tAC_t^PY_t+AC_t^WH_t+AC_t^LL_{t+1}.
$$

- **(F32) Variety price relation**:
$$
n_t\rho_t^{1-\epsilon_P}=1.
$$

- **(F33) Relative-price inflation identity**:
$$
\frac{\rho_t}{\rho_{t-1}}=\frac{\pi_t}{\pi_t^C}.
$$

- **(F34) Goods-market equilibrium**:
$$
n_tY_t=\rho_t^{-\epsilon_P}Y_t^d.
$$

- **(F35) Labor-market equilibrium**:
$$
H_t=H_t^d+H_t^E.
$$

- **(F36) Law of motion for firm varieties** (`needs_review`: paper uses $n_{jt}$ notation in Appendix B; aggregate interpretation follows the model text):
$$
n_t=(1-\delta)\left[n_{t-1}+e^{\varepsilon_{t-1}^E}(1-AC_{t-1}^E)n_{t-1}^E\right].
$$

## 5. Exogenous Processes

The paper estimates shocks to productivity, government spending, preferences, investment, bank markup, net worth, price markup, wage markup, entry, and monetary policy. Appendix B embeds the innovations in the equilibrium equations above rather than listing all shock laws in a separate equation block. The implementation cross-check uses:

- **(F37) Productivity shock**:
$$
\varepsilon_t^A=\rho_A\varepsilon_{t-1}^A+e_t^A.
$$

- **(F38) Government spending shock, with productivity innovation spillover in the implementation**:
$$
\varepsilon_t^G=\rho_G\varepsilon_{t-1}^G+e_t^G+\rho_{AG}e_t^A.
$$

- **(F39) Preference shock**:
$$
\varepsilon_t^B=\rho_B\varepsilon_{t-1}^B+e_t^B.
$$

- **(F40) Investment shock**:
$$
\varepsilon_t^I=\rho_I\varepsilon_{t-1}^I+e_t^I.
$$

- **(F41) Bank-markup shock**:
$$
\varepsilon_t^L=\rho_L\varepsilon_{t-1}^L+e_t^L.
$$

- **(F42) Net-worth shock**:
$$
\varepsilon_t^N=\rho_N\varepsilon_{t-1}^N+e_t^N.
$$

- **(F43) Price-markup shock**:
$$
\varepsilon_t^P=\rho_P\varepsilon_{t-1}^P+e_t^P-u_Pe_{t-1}^P.
$$

- **(F44) Wage-markup shock**:
$$
\varepsilon_t^W=\rho_W\varepsilon_{t-1}^W+e_t^W-u_We_{t-1}^W.
$$

- **(F45) Entry shock**:
$$
\varepsilon_t^E=\rho_E\varepsilon_{t-1}^E+e_t^E.
$$

- **(F46) Monetary-policy shock**:
$$
\varepsilon_t^R=\rho_R\varepsilon_{t-1}^R+e_t^R.
$$

These process equations are marked as `implementation_cross_check` because the paper text describes AR(1) markup and financial shocks but the concise equation list in Appendix B does not provide all AR laws in display form.

## 6. Steady-State Solution

The paper provides a constructive steady-state sequence in Appendix B.2. The following equations preserve that sequence while marking OCR issues.

1. Set zero steady-state inflation and compute the real policy rate:
$$
\bar{\pi}^C=\bar{\pi}=1,\qquad \bar{r}=\bar{R}=\beta^{-1}-1.
$$

2. Calibrate the steady-state lending rate:
$$
\bar{R}^L=\bar{r}^L=\left(1+\frac{0.98}{100}\right)\bar{R}-1.
$$

3. Use the target loan-capital ratio:
$$
\omega_{\min}=\frac{\bar{L}}{\bar{K}}=0.50,\qquad
\kappa=\frac{1}{1-\omega_{\min}}=\frac{\bar{K}}{\bar{L}}=2.
$$

4. With the default-rate target:
$$
\bar{\omega}^C=\omega_{\min}\bar{\eta}^{-\kappa}.
$$

5. Recover the steady-state return to capital and marginal product:
$$
\bar{r}^K=\frac{1+\bar{r}^L}{\bar{\omega}^C}\left(1-\frac{\bar{L}}{\bar{K}}\right)-1,\qquad
\bar{z}=\bar{r}^K+\delta.
$$

6. Compute the conditional means of the Pareto project return and loan marginal cost:
$$
1=\bar{\eta}\bar{\omega}+(1-\bar{\eta})\underline{\omega},\qquad
\underline{\omega}=\frac{1-\bar{\eta}\bar{\omega}}{1-\bar{\eta}},
$$
$$
\overline{mc}^L=(1+\bar{r})\left[\bar{\eta}+(1-\mu^B)(1-\bar{\eta})\frac{\underline{\omega}}{\bar{\omega}^C}\right]^{-1}-1.
$$

7. Compute the lending markup (`needs_review`: paper OCR around B.43 is ambiguous; implementation sets `mu_L=rL/mcL`):
$$
\mu_L \approx \frac{\bar{r}^L}{\overline{mc}^L}.
$$

8. Use the free-entry/share valuation equation to solve the steady-state number of firms:
$$
\bar{n}=\bar{H}
\left[
\frac{(1-(1-\delta)\beta)f_E(1-\alpha)(1+\gamma\bar{r}^L)}
{(1-\delta)\beta\left((\bar{\mu}-1)+d^K\frac{\alpha}{\bar{z}}\right)}
+f_E\frac{\delta}{1-\delta}
\right]^{-1},
$$
where
$$
d^K=\theta\bar{\eta}\bar{\omega}^C(\kappa-1)^{-1}(1+\bar{r}^K).
$$

9. Complete the real allocation:
$$
\bar{\rho}=\bar{n}^{1/(\epsilon_P-1)},\qquad
\overline{mc}=\frac{\bar{\rho}}{\bar{\mu}},
$$
$$
\bar{n}^E=\bar{n}\frac{\delta}{1-\delta},\qquad
\bar{H}^E=f_E\bar{n}\frac{\delta}{1-\delta},\qquad
\bar{H}^d=\bar{H}-\bar{H}^E,
$$
$$
\bar{w}=(1-\alpha)\left[\overline{mc}\left(\frac{\alpha}{\bar{z}}\right)^\alpha\right]^{1/(1-\alpha)},
$$
$$
\bar{K}=\frac{\alpha}{\bar{z}(1-\alpha)}\bar{H}^d\bar{w}.
$$

The source reports approximate values including $\bar{r}=0.0081$, $\bar{r}^L=0.0179$, $\mu_L=2.1248$, $\bar{n}=1.0726$, $\bar{\rho}=1.0254$, $\bar{K}=5.6037$, $\bar{r}^K=0.0154$, $\bar{\omega}^C=0.5013$, $\bar{Y}=0.6983$, $\bar{Y}^d=0.8238$, and $\bar{C}=0.5354$. The last displayed sentence in the MinerU source contains repeated fragments, so the steady-state value list remains `needs_review`.

## 7. Timing & Form Conventions

- The model is nonlinear in levels and is solved by perturbation; no hand log-linearization is recorded in the source archive entry.
- Capital is predetermined in production. Appendix B writes production with $K_{t+1}^u=u_tK_t$, while the implementation cross-check uses `ku = u*k(-1)` and capital return with `q(-1)`, indicating installed capital used at time $t$ is inherited from the previous period under Dynare timing.
- Firm entry has a one-period time-to-build structure: entrants chosen in period $t-1$ affect the number of operating firms in period $t$.
- Entrepreneur balance sheets finance next-period capital and current entry labor; the paper and implementation mix $K_{t+1}$ paper notation with Dynare predetermined `k` timing.
- Inflation has a goods inflation rate $\pi_t$, consumption-goods inflation $\pi_t^C$, and relative price $\rho_t=P_t/P_t^C$.
- The financial block distinguishes the nominal policy rate $R_t$, real policy/deposit rate $r_t$, nominal lending rate $R_t^L$, and real lending rate $r_t^L$.
- Runtime validation was not performed; Dynare was not run.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII cross-check | Meaning | Main equation(s) |
|---|---|---|---|
| Endogenous | $\lambda_t^c$ / `uc` | Marginal utility of consumption | (F1) |
| Endogenous | $C_t$ / `c` | Consumption | (F1), (F31) |
| Endogenous | $r_t$ / `rr`, `r` | Real policy/deposit rate | (F2), (F30) |
| Endogenous | $v_t$ / `v` | Value of shares / entry value | (F3), (F5) |
| Endogenous | $H_t$, $H_t^d$, $H_t^E$ / `h`, `hc`, `he` | Total, installed-firm, and startup labor | (F4), (F15), (F35) |
| Endogenous | $w_t^h$, $w_t$ / `wh`, `w` | Household desired wage and real wage | (F4), (F6) |
| Endogenous | $n_t$, $n_t^E$ / `n`, `ne` | Operating firms and entrants | (F15), (F36) |
| Endogenous | $Y_t$, $Y_t^d$ / `y`, `yd` | Installed-firm output and aggregate demand | (F7), (F31), (F34) |
| Endogenous | $K_t$, $K_t^u$ / `k`, `ku` | Capital stock and utilized capital | (F7), (F8), (F25) |
| Endogenous | $mc_t$, $\rho_t$, $\mu_t$ / `mc`, `p`, `mk` | Marginal cost, relative price, markup | (F9), (F11), (F12), (F32), (F33) |
| Endogenous | $d_t$ / `d` | Installed-firm dividends | (F14) |
| Endogenous | $L_t$, $NW_t$ / `l`, `nn` | Entrepreneur loans and net worth | (F17), (F20) |
| Endogenous | $\omega_t^C$, $\eta_t$, $\bar{\omega}_t$, $\underline{\omega}_t$ / `omega`, `eta`, `w_sup`, `w_inf` | Project cutoff, survival share, conditional project returns | (F18), (F21), (F22) |
| Endogenous | $r_t^k$, $q_t$, $z_t$, $u_t$ / `rK`, `q`, `z`, `u` | Capital return, Tobin's q, rental rate, utilization | (F25)-(F28) |
| Endogenous | $R_t^L$, $r_t^L$, $MC_t^L$, $\mu_t^L$ / `rL`, `mcL`, `mut_L` | Nominal/real lending rates, credit marginal cost, loan markup | (F22)-(F24) |
| Endogenous | $R_t$, $\pi_t$, $\pi_t^C$ / `r`, `pi`, `pic` | Policy rate and inflation rates | (F29), (F30), (F33) |
| Exogenous | $e_t^A,e_t^G,e_t^B,e_t^I,e_t^L,e_t^N,e_t^P,e_t^W,e_t^E,e_t^R$ / `e_a` etc. | Innovations to productivity, spending, preferences, investment, bank markup, net worth, price markup, wage markup, entry, and policy | (F37)-(F46) |
| Parameter | $\beta,h,\sigma_c,\chi,\sigma_H$ | Household discounting, habits, risk aversion, labor preference | (F1)-(F4) |
| Parameter | $\alpha,\epsilon_P,\kappa_P,\xi_P,\delta$ | Production, goods substitution, price adjustment/indexation, exit/depreciation | (F7)-(F14), (F25) |
| Parameter | $f_E,\gamma,\theta$ | Entry sunk cost, wage-bill-in-advance share, entrepreneurial dividend policy | (F5), (F15), (F16), (F20) |
| Parameter | $\kappa,\omega_{\min},\mu_B,\chi/\varkappa$ | Pareto shape/minimum, monitoring cost, external-finance-premium elasticity | (F18), (F19), (F22) |
| Parameter | $\kappa_L,\mu_L$ | Lending-rate adjustment and loan markup | (F23) |
| Parameter | $\rho,\rho_R,\phi_\pi,\phi_Y,\phi_{\Delta Y}$ | Monetary policy smoothing and response coefficients | (F29) |
| Parameter | $\rho_A,\rho_G,\rho_B,\rho_I,\rho_L,\rho_N,\rho_P,\rho_W,\rho_E,\rho_R,u_P,u_W$ | Shock persistence and ARMA terms | (F37)-(F46) |
