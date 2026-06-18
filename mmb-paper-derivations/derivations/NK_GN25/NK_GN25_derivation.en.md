# NK_GN25 - Derivation (Optimization Problems + Equilibrium Conditions)

> Source-backed first-pass archive derivation for MMB model `NK_GN25`. Runtime validation was not performed. Status: `needs_review`.

Provenance: Gnocato, Nicolo (2025), "Energy price shocks, unemployment, and monetary policy", *Journal of Monetary Economics*, DOI `10.1016/j.jmoneco.2025.103734`. Primary source Markdown: `raw/mmb_mineru/runs/nk_gn25__energy_price_shocks_unemployment_and_monetary_policy__ca6f092e/full.md`. Raw PDF path checked: `raw/mmb_papers/Energy price shocks, unemployment, and monetary policy.pdf`. MinerU run id: `ca6f092e-7214-4c3a-be67-f019e816eacc`. No appendix-normalization file or implementation `.mod` cross-check was found.

## 1. Model Overview

- **Model**: heterogeneous-agent New Keynesian model with uninsured unemployment risk, search-and-matching labor frictions, non-homothetic energy consumption, and energy as a non-produced production input.
- **Main experiment**: a real energy price shock with persistence; compare strict non-energy inflation targeting, stable-unemployment policy, optimized simple rules, and optimal policy.
- **Agents and sectors**: employed and unemployed workers, risk-neutral firm owners, competitive final-good aggregators, Calvo wholesale firms, labor intermediaries, fiscal authority, and monetary authority.
- **Model form**: `model(linear)` for the quantitative MMB-style dynamic system. The paper first states nonlinear household, production, pricing, and labor-market equations, then gives the first-order approximate system in Section 5. The F-numbered simulation block below records the linearized model and the source nonlinear definitions needed to interpret it.
- **Review status**: `needs_review`; MinerU OCR contains several `??` placeholders in parameter names and some appendix/optimal-policy expressions.

## 2. Optimization Problems

### Workers

Workers are either employed, $i=n$, or unemployed, $i=u$. They choose non-energy consumption $g_t^i$, energy $e_t^i$, and nominal one-period bonds $B_t^i$ subject to a zero-debt constraint. Their Stone-Geary consumption basket is:

$$
c_t^i = (g_t^i)^{1-\omega_e}(e_t^i-\xi)^{\omega_e}, \qquad i\in\{n,u\}.
$$

The recursive utilities are:

$$
U_t^n=\ln(c_t^n)+\beta E_t\left[(1-\lambda_{t+1})U_{t+1}^n+\lambda_{t+1}U_{t+1}^u\right],
$$

$$
U_t^u=\ln(c_t^u)+\beta E_t\left[f_{t+1}U_{t+1}^n+(1-f_{t+1})U_{t+1}^u\right].
$$

Their nominal budget and borrowing constraint are:

$$
P_{g,t}g_t^i+P_{e,t}e_t^i+B_t^i={\cal Y}_t^i+(1+i_{t-1})B_{t-1}^i,\qquad B_t^i\ge 0,
$$

with ${\cal Y}_t^n=W_t$ and ${\cal Y}_t^u=\Delta_t$.

### Final-Good Aggregator

A competitive aggregator combines differentiated non-energy wholesale varieties:

$$
Y_t=\left(\int_0^1 y_t(k)^{\frac{\varepsilon-1}{\varepsilon}}dk\right)^{\frac{\varepsilon}{\varepsilon-1}}.
$$

### Wholesale Firms

Each wholesaler uses labor services and energy in fixed proportions:

$$
y_t(k)=\min\left\{\frac{l_t(k)}{1-\gamma_e},\frac{e_t(k)}{\gamma_e}\right\}.
$$

Wholesale firms set prices subject to Calvo friction $\theta$. The source reports recursive auxiliary variables for the optimal reset price; these are recorded in Section 3.

### Labor Intermediaries

Intermediaries post vacancies at flow cost $\kappa$ and hire labor from a frictional matching market. A match has value:

$$
J_t=(1-\tau_z)(\varphi_t-w_t+S)+\beta(1-\rho)E_t[J_{t+1}].
$$

Free entry in vacancy posting yields the job-creation condition recorded below.

### Policy Authorities

The fiscal authority uses subsidies/taxes $\tau_y$, $\tau_z$, and $S$ to offset steady-state distortions. Monetary policy is represented either by a simple interest-rate rule or by the optimal-policy target conditions derived from the linear-quadratic problem.

## 3. First-Order Conditions

- **(F1) Non-energy demand of worker type $i$**:
$$
g_t^i=(1-\omega_e)\left(\frac{P_t}{P_{g,t}}\right)c_t^i.
$$

- **(F2) Energy demand of worker type $i$**:
$$
e_t^i=\omega_e\left(\frac{P_t}{P_{e,t}}\right)c_t^i+\xi.
$$

- **(F3) CPI aggregator**:
$$
P_t=\left(\frac{P_{g,t}}{1-\omega_e}\right)^{1-\omega_e}
\left(\frac{P_{e,t}}{\omega_e}\right)^{\omega_e}.
$$

`needs_review`: the source prints (4) as a Cobb-Douglas price index; this equation should be checked against the PDF before final review.

- **(F4) Employed-worker Euler inequality**:
$$
\frac{1}{c_t^n}\geq \beta E_t\left\{\left(\frac{1+i_t}{1+\pi_{t+1}}\right)
\left[(1-\lambda_{t+1})\frac{1}{c_{t+1}^n}+\lambda_{t+1}\frac{1}{c_{t+1}^u}\right]\right\}.
$$

`needs_review`: multiplication inside the expectation is source-intended; OCR spacing may obscure it.

- **(F5) Unemployed-worker Euler inequality**:
$$
\frac{1}{c_t^u}\geq \beta E_t\left\{\left(\frac{1+i_t}{1+\pi_{t+1}}\right)
\left[f_{t+1}\frac{1}{c_{t+1}^n}+(1-f_{t+1})\frac{1}{c_{t+1}^u}\right]\right\}.
$$

`needs_review`: multiplication inside the expectation is source-intended; OCR spacing may obscure it.

- **(F6) Zero-liquidity employed consumption**:
$$
c_t^n=w_t-p_{e,t}\xi.
$$

- **(F7) Zero-liquidity unemployed consumption**:
$$
c_t^u=\delta_t-p_{e,t}\xi.
$$

- **(F8) Variety demand**:
$$
y_t(k)=Y_t\left[\frac{P_t(k)}{P_{g,t}}\right]^{-\varepsilon}.
$$

- **(F9) Input demand for labor services**:
$$
l_t(k)=(1-\gamma_e)y_t(k).
$$

- **(F10) Input demand for energy**:
$$
e_t(k)=\gamma_e y_t(k).
$$

- **(F11) Wholesale real marginal cost**:
$$
mc_{g,t}=(1-\gamma_e)\frac{\Phi_t}{P_{g,t}}+\gamma_e\frac{P_{e,t}}{P_{g,t}}.
$$

- **(F12) Optimal reset price ratio**:
$$
\bar p_{g,t}=\frac{\bar P_t}{P_{g,t}}=\frac{{\cal Y}_t}{{\cal Z}_t}.
$$

- **(F13) Calvo numerator recursion**:
$$
{\cal Y}_t=(1-\tau_y)\left(\frac{\varepsilon}{\varepsilon-1}\right)\frac{P_{g,t}}{P_t}mc_{g,t}Y_t
+\theta\beta E_t\left[(1+\pi_{g,t+1})^{\varepsilon}{\cal Y}_{t+1}\right].
$$

- **(F14) Calvo denominator recursion**:
$$
{\cal Z}_t=\frac{P_{g,t}}{P_t}Y_t+\theta\beta E_t\left[(1+\pi_{g,t+1})^{\varepsilon-1}{\cal Z}_{t+1}\right].
$$

- **(F15) Non-energy inflation law from the Calvo price index**:
$$
1+\pi_{g,t}=\left[\frac{1}{\theta}-\left(\frac{1-\theta}{\theta}\right)(\bar p_{g,t})^{1-\varepsilon}\right]^{\frac{1}{\varepsilon-1}}.
$$

- **(F16) Price dispersion law**:
$$
{\cal D}_t=(1-\theta)(\bar p_{g,t})^{-\varepsilon}+\theta(1+\pi_{g,t})^{\varepsilon}{\cal D}_{t-1}.
$$

- **(F17) Matching function**:
$$
m_t=s_t^{\alpha}v_t^{1-\alpha},\qquad s_t=u_{t-1}+\rho n_{t-1}.
$$

- **(F18) Job-finding and vacancy-filling rates**:
$$
f_t=\frac{m_t}{s_t},\qquad q_t=\frac{m_t}{v_t}=f_t^{\frac{\alpha}{\alpha-1}}.
$$

- **(F19) Job creation / free entry**:
$$
f_t^{\frac{\alpha}{1-\alpha}}=\frac{1-\tau_z}{\kappa}(\varphi_t-w_t+S)
+\beta(1-\rho)E_t\left[f_{t+1}^{\frac{\alpha}{1-\alpha}}\right].
$$

- **(F20) Wage schedule for the linearized model**:
$$
\widetilde w_t=-\chi\widetilde p_{e,t}.
$$

## 4. Market Clearing & Identities

- **(F21) Employment law of motion**:
$$
n_{t+1}=(1-\lambda_{t+1})n_t+f_{t+1}u_t.
$$

- **(F22) Unemployment law of motion**:
$$
u_{t+1}=(1-f_{t+1})u_t+\lambda_{t+1}n_t.
$$

- **(F23) Separation and unemployment identity**:
$$
u_t=1-n_t,\qquad \lambda_{t+1}=\rho(1-f_{t+1}).
$$

- **(F24) Labor-market clearing**:
$$
n_t=(1-\gamma_e)Y_t{\cal D}_t.
$$

- **(F25) Firm-owner consumption**:
$$
c_t^o=\left(\frac{p_{g,t}{\cal D}_t^{-1}-\gamma_e p_{e,t}}{1-\gamma_e}-w_t\right)n_t
-\kappa\left\{\frac{n_t-(1-\rho)n_{t-1}}{[1-(1-\rho)n_{t-1}]^{\alpha}}\right\}^{\frac{1}{1-\alpha}}.
$$

- **(F26) Linearized unemployment dynamics**:
$$
\widehat u_t=(1-\rho)(1-f)\widehat u_{t-1}
-\frac{\rho}{f+\rho(1-f)}\widehat f_t.
$$

- **(F27) Linearized job creation**:
$$
\widehat f_t=\frac{qf}{\kappa}\left(\frac{1-\alpha}{\alpha}\right)(1-\tau_z)(\widehat\varphi_t-\widehat w_t)
+\beta(1-\rho)E_t(\widehat f_{t+1}).
$$

- **(F28) Linearized real marginal cost**:
$$
\widehat{mc}_{g,t}=(1-\gamma_e)\frac{1}{p_g}\widehat\varphi_t
+\left(\gamma_e\frac{p_e}{p_g}+\frac{\omega_e}{1-\omega_e}\right)\widetilde p_{e,t}.
$$

- **(F29) New Keynesian Phillips curve**:
$$
\pi_{g,t}=\beta E_t(\pi_{g,t+1})+\Theta\widehat{mc}_{g,t}.
$$

- **(F30) CPI inflation identity**:
$$
\pi_t=\pi_{g,t}+\frac{\omega_e}{1-\omega_e}(\widetilde p_{e,t}-\widetilde p_{e,t-1}).
$$

- **(F31) Dynamic IS condition**:
$$
\widetilde I_t-E_t(\pi_{t+1})
=E_t(\widetilde w_{t+1}-\widetilde w_t)
+\frac{\Lambda}{1-f}E_t(\widehat f_{t+1})
+\Xi_w\frac{(1+\Lambda\Psi)E_t(\widetilde w_{t+1}-\widetilde p_{e,t+1})-(\widetilde w_t-\widetilde p_{e,t})}{1-\Xi_w}.
$$

- **(F32) Simple interest-rate rule**:
$$
\widetilde I_t=\phi_{\pi}\pi_{g,t}+\phi_f\widehat f_t.
$$

- **(F33) Natural-minus-efficient unemployment wedge, analytical case**:
$$
\widehat u_t^n-\widehat u_t^{\ast}
=\frac{w}{2\kappa}\left(\frac{\zeta\Xi_w}{1-\zeta-\Xi_w}\right)(1+\chi)\widetilde p_{e,t}.
$$

- **(F34) Welfare-relevant NKPC, analytical case**:
$$
\pi_{g,t}=\beta E_t(\pi_{g,t+1})
-\Theta\frac{2\kappa}{p_g}(1-\gamma_e){\cal V}_t
+\Theta\frac{w}{p_g}(1-\gamma_e)\left(\frac{\zeta\Xi_w}{1-\zeta-\Xi_w}\right)(1+\chi)\widetilde p_{e,t}.
$$

- **(F35) Linear-quadratic loss**:
$$
E_t\sum_{j=0}^{\infty}\beta^j\left({\cal V}_{t+j}^2+\Omega\pi_{g,t+j}^2\right).
$$

## 5. Exogenous Processes

- **(F36) Real energy price shock**:
$$
\widetilde p_{e,t}=\rho_e\widetilde p_{e,t-1}+\varepsilon^e_t.
$$

The paper sets the steady-state real energy price at $p_e=1$ and considers a one-off 40 percent shock with persistence $\rho_e=0.95$ in the quantitative exercises.

## 6. Steady-State Solution

- The constrained-efficient steady state has zero non-energy inflation, $\pi_g=0$, and therefore $\bar p_g=1$ and ${\cal D}=1$.
- The real energy price mean is $p_e=1$.
- The wholesale production subsidy offsets the steady-state markup:
$$
\tau_y=\frac{1}{\varepsilon}.
$$
- The efficient wage is:
$$
w^{\ast}=\frac{1}{\nu}+\xi p_e.
$$
- The steady-state fiscal instruments reported by the source are:
$$
\tau_y=\frac{1}{\varepsilon},\qquad
S=\frac{1}{\nu}\ln\left(\frac{w^{\ast}-\xi p_e}{\delta-\xi p_e}\right),\qquad
\tau_z=1-\frac{(1-\alpha)[1-\beta(1-\rho)]}{1-\beta(1-\rho)(1-\alpha f^{\ast})}.
$$
- The steady-state efficient job-finding rate satisfies:
$$
f^{\ast}=\left[\frac{1-\tau_z}{\kappa[1-\beta(1-\rho)]}
\left(\frac{p_g-\gamma_e p_e}{1-\gamma_e}-w^{\ast}+S\right)\right]^{\frac{1-\alpha}{\alpha}}.
$$
- The quantitative calibration targets a quarterly model with $\beta=0.98$, $\omega_e=0.08$, $\Xi_w=0.11$, $f=0.25$, $u=0.10$, $\rho=0.037$, $\alpha=0.6$, $\chi=0.1$, $\gamma_e=0.04$, $\theta=3/4$, and $\varepsilon=4$.
- For the linearized model, steady states are normalized as deviations from the constrained-efficient steady state: hatted level deviations and tilded proportional deviations are zero in steady state.

## 7. Timing & Form Conventions

- Timing is quarterly.
- $n_t$ and $u_t$ are employment and unemployment stocks; the paper uses $s_t=u_{t-1}+\rho n_{t-1}$ for searchers, so matching and vacancy posting use lagged labor-market stocks.
- $\lambda_{t+1}=\rho(1-f_{t+1})$ is the transition rate from employment to unemployment between $t$ and $t+1$.
- ${\cal D}_t$ is a stock-like price dispersion state depending on ${\cal D}_{t-1}$.
- Energy is non-produced; its real price $p_{e,t}=P_{e,t}/P_t$ is exogenous.
- The quantitative MMB archive form is `model(linear)`: hats denote level deviations from constrained-efficient steady state and tildes denote proportional deviations. The nonlinear equations above are retained as source definitions for demands, pricing recursions, and market clearing.
- Runtime validation: not performed.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Main equation(s) |
|---|---|---|---|
| Endogenous | `c_n`, `c_u` | employed and unemployed consumption baskets | (F6), (F7) |
| Endogenous | `g_n`, `g_u` | non-energy consumption by worker type | (F1) |
| Endogenous | `e_n`, `e_u` | energy consumption by worker type | (F2) |
| Endogenous | `P`, `P_g`, `P_e`, `p_e` | CPI, non-energy price, energy price, real energy price | (F3), (F36) |
| Endogenous | `pi`, `pi_g` | CPI and non-energy inflation | (F15), (F29), (F30) |
| Endogenous | `Y`, `y_k` | final output and variety output | (F8), (F24) |
| Endogenous | `l_k`, `e_k` | labor services and energy used by wholesalers | (F9), (F10) |
| Endogenous | `mc_g` | non-energy real marginal cost | (F11), (F28) |
| Endogenous | `Ycal`, `Zcal`, `pbar_g` | Calvo price-setting auxiliaries | (F12)-(F15) |
| Endogenous | `D` | price dispersion | (F16) |
| Endogenous | `n`, `u`, `s`, `m`, `v` | employment, unemployment, searchers, matches, vacancies | (F17), (F21)-(F24), (F26) |
| Endogenous | `f`, `q`, `lambda` | job-finding, vacancy-filling, separation-to-unemployment transition | (F18), (F19), (F23), (F27) |
| Endogenous | `w`, `varphi` | real wage and real price of labor services | (F19), (F20), (F27), (F28) |
| Endogenous | `I` | nominal interest rate in deviations | (F31), (F32) |
| Endogenous | `V` / `mathcal_V` | welfare-relevant unemployment gap | (F34), (F35) |
| Exogenous | `eps_e` | energy price innovation | (F36) |
| Parameter | `beta` | discount factor | (F4), (F5), (F13), (F14), (F19), (F27), (F29), (F35) |
| Parameter | `omega_e` | energy quasi-share in consumption | (F1)-(F3), (F30) |
| Parameter | `xi` | subsistence energy requirement | (F2), (F6), (F7) |
| Parameter | `gamma_e` | energy input share in fixed-proportion production | (F9)-(F11), (F24), (F28), (F34) |
| Parameter | `epsilon` | elasticity of substitution among varieties | (F8), (F13)-(F16) |
| Parameter | `theta` | Calvo non-reset probability | (F13)-(F16) |
| Parameter | `alpha` | matching elasticity | (F17)-(F19), (F27) |
| Parameter | `rho` | separation probability | (F19), (F21)-(F23), (F26), (F27) |
| Parameter | `kappa` | vacancy posting cost | (F19), (F25), (F27), (F33), (F34) |
| Parameter | `tau_y`, `tau_z`, `S` | fiscal instruments/subsidies | (F13), (F19), steady state |
| Parameter | `chi` | real-wage response to energy price | (F20), (F33), (F34) |
| Parameter | `zeta` | consumption/income loss upon unemployment | (F33), (F34) |
| Parameter | `Xi_w`, `Lambda`, `Psi`, `Theta`, `Omega` | linearized composite coefficients | (F29), (F31), (F33)-(F35) |
| Parameter | `phi_pi`, `phi_f` | simple-rule feedback coefficients | (F32) |
| Parameter | `rho_e` | persistence of the real energy price shock | (F36) |
