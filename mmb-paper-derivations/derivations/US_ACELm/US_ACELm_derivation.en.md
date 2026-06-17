# US_ACELm -- Firm-Specific Capital, Nominal Rigidities

> First-pass private archive derivation for the MMB model `US_ACELm`. Runtime validation was not performed. Exact technical-appendix linear equations are marked `needs_review` where the paper-side Markdown only cites an appendix available on request.

## 1. Model Overview

- **Model**: `US_ACELm`, Altig, Christiano, Eichenbaum, and Linde (2005), "Firm-Specific Capital, Nominal Rigidities and the Business Cycle."
- **Provenance**: source Markdown `raw/mmb_mineru/runs/us_acelm_us_acelswm_us_acelswt_us_acelt__firm_specific_capital_nominal_rigidities__e0fac58f/full.md`; raw PDF `raw/mmb_papers/Firm-specific capital, nominal rigidities.pdf`; DOI `10.3386/w11034`; MinerU run `e0fac58f-0dfb-476b-b2df-8712e57d9ce4`.
- **Economy**: closed U.S. medium-scale DSGE model with monopolistic intermediate firms, Calvo prices, Calvo wages, habit formation, money demand, variable capital utilization, investment adjustment costs, neutral technology growth, capital-embodied technology growth, and money-growth monetary policy.
- **Capital structure**: this MMB entry is the firm-specific-capital variant. Firms own their own capital and begin each period with a predetermined capital stock; investment changes future firm-level capital.
- **Form**: `model(linear)` in the Rep-MMB implementation. The paper describes nonlinear primitives and then solves a log-linear approximation around a balanced-growth steady state. The exact implementation equations should be treated as a technical-appendix cross-check, not as paper-source derivation.

## 2. Optimization Problems

### Final-good firm

The perfectly competitive final-good firm aggregates differentiated intermediate goods:

**(F1) Final-good aggregator**
$$
Y_t=\left[\int_0^1 y_t(i)^{1/\lambda_f}\,di\right]^{\lambda_f},\qquad 1\leq \lambda_f<\infty .
$$

Profit maximization with respect to each intermediate input gives demand:

**(F2) Intermediate-good demand**
$$
\left(\frac{P_t}{P_t(i)}\right)^{\lambda_f/(\lambda_f-1)}
=\frac{y_t(i)}{Y_t}.
$$

### Intermediate-good firms

Each intermediate firm is a monopolist using neutral technology and capital services:

**(F3) Intermediate production technology**
$$
y_t(i)=K_t(i)^\alpha\big(z_t h_t(i)\big)^{1-\alpha}-\phi z_t^\ast ,
\qquad
z_t^\ast=\Upsilon_t^{\alpha/(1-\alpha)}z_t .
$$

Under firm-specific capital, firm `i` accumulates its own physical capital:

**(F4) Firm-specific investment technology**
$$
F(I_t(i),I_{t-1}(i))=
\left[1-S\left(\frac{I_t(i)}{I_{t-1}(i)}\right)\right]I_t(i),
$$

**(F5) Firm-specific capital accumulation**
$$
\bar K_{t+1}(i)=(1-\delta)\bar K_t(i)+F(I_t(i),I_{t-1}(i)).
$$

The firm maximizes expected discounted nominal cash flow:

**(F6) Firm objective**
$$
E_t\sum_{j=0}^{\infty}\beta^j v_{t+j}
\left\{
P_{t+j}(i)y_{t+j}(i)
-P_{t+j}R_{t+j}w_{t+j}h_{t+j}(i)
-P_{t+j}\Upsilon_{t+j}^{-1}\big[I_{t+j}(i)+a(u_{t+j}(i))\bar K_{t+j}(i)\big]
\right\}.
$$

The firm chooses price, labor, utilization, and investment subject to Calvo pricing and the timing convention that technology shocks arrive before the firm's price/investment/utilization choices, while the monetary-policy shock and final demand are realized afterward.

### Households

Households consume, supply differentiated labor, hold money/cash balances, own capital in the homogeneous benchmark, and set wages subject to Calvo frictions. Preferences are:

**(F7) Household utility**
$$
E_t^j\sum_{l=0}^{\infty}\beta^{l-t}
\left[
\log(C_{t+l}-bC_{t+l-1})
-\psi_L\frac{h_{j,t+l}^2}{2}
\right].
$$

The nominal asset evolution equation is:

**(F8) Household asset evolution**
$$
\begin{aligned}
M_{t+1}={}&R_t\big[M_t-Q_t+(x_t-1)M_t^a\big]+A_{j,t}+Q_t+W_{j,t}h_{j,t}\\
&+P_t r_t^k u_t\bar K_t+D_t-(1+\eta(V_t))P_tC_t
-P_t\Upsilon_t^{-1}\big[I_t+a(u_t)\bar K_t\big].
\end{aligned}
$$

Cash velocity and transactions technology are:

**(F9) Velocity definition**
$$
V_t=\frac{P_tC_t}{Q_t}.
$$

Households supply differentiated labor through an aggregate labor packer:

**(F10) Labor aggregator**
$$
H_t=\left[\int_0^1 h_{j,t}^{1/\lambda_w}\,dj\right]^{\lambda_w}.
$$

## 3. First-Order Conditions

The paper-side Markdown reports primitive optimization problems and selected FOCs, but not the full technical-appendix linear system. The following first-order and equilibrium conditions are therefore a source-backed derivation skeleton; exact coefficient-level linear equations are `needs_review` pending source-level appendix verification.

**(F11) Aggregate price index**
$$
P_t=\left[\int_0^1 P_t(i)^{1/(1-\lambda_f)}\,di\right]^{1-\lambda_f}.
$$

**(F12) Calvo price updating for non-reoptimizing firms**
$$
P_t(i)=\pi_{t-1}P_{t-1}(i).
$$

**(F13) Inflation dynamics, reduced form**
$$
\Delta\hat\pi_t
=E\left[\beta\Delta\hat\pi_{t+1}+\gamma\hat s_t\mid\Omega_t\right].
$$

**(F14) Slope parameter mapping**
$$
\gamma=\frac{(1-\xi_p)(1-\beta\xi_p)}{\xi_p}\chi ,
$$
where $\chi=1$ in the homogeneous-capital model and is a nonlinear function of structural parameters in the firm-specific-capital model.

**(F15) Wage demand curve**
$$
h_{j,t}=\left(\frac{W_t}{W_{j,t}}\right)^{\lambda_w/(\lambda_w-1)}H_t.
$$

**(F16) Aggregate wage index**
$$
W_t=\left[\int_0^1 W_{j,t}^{1/(1-\lambda_w)}\,dj\right]^{1-\lambda_w}.
$$

**(F17) Calvo wage updating for non-reoptimizing households**
$$
W_{j,t}=\pi_{t-1}\mu_{z^\ast}W_{j,t-1}.
$$

**(F18) Money demand FOC**
$$
R_t=1+\eta'\left(\frac{P_tC_t}{Q_t}\right)\left(\frac{P_tC_t}{Q_t}\right)^2 .
$$

**(F19) Interest semi-elasticity of money demand**
$$
\epsilon=\frac{1}{4}\left(\frac{1}{R-1}\right)\left(\frac{1}{2+\varphi}\right),
\qquad
\varphi=\frac{\eta''V}{\eta'} .
$$

**(F20) Capital services**
$$
K_t=u_t\bar K_t .
$$

**(F21) Capital-utilization log-linear FOC, needs_review**
$$
E\left[\frac{1}{\sigma_a}\hat r_t^k-\hat u_t\mid\Omega_t\right]=0.
$$

**(F22) Investment-adjustment log-linear response, needs_review**
$$
\hat i_t=\hat i_{t-1}+\frac{1}{S''}\sum_{j=0}^{\infty}\beta^j
E\left[\hat P_{k',t+j}\mid\Omega_t\right].
$$

**(F23) Steady-state Fisher relation**
$$
R=\frac{\pi\mu_{z^\ast}}{\beta}.
$$

## 4. Market Clearing & Identities

**(F24) Growth of balanced-growth technology**
$$
\mu_{z^\ast,t}=\mu_{\Upsilon,t}^{\alpha/(1-\alpha)}\mu_{z,t}.
$$

**(F25) Loan-market clearing**
$$
W_tH_t=x_tM_t-Q_t.
$$

**(F26) Aggregate resource constraint**
$$
(1+\eta(V_t))C_t+\Upsilon_t^{-1}\big[I_t+a(u_t)\bar K_t\big]\leq Y_t.
$$

**(F27) Money base identity, implementation_cross_check needs_review**
$$
\hat m_t+\hat\pi_t-\hat m_{t-1}-\hat x_{t-1}
=-\hat\mu_{z,t}-\frac{\alpha}{1-\alpha}\hat\mu_{\Upsilon,t}.
$$

**(F28) Output-gap definition, implementation_cross_check**
$$
\widehat{outputgap}_t=\hat y_t-\hat y_t^{flex}.
$$

## 5. Exogenous Processes

**(F29) Neutral technology growth**
$$
\hat\mu_{z,t}=\rho_{\mu_z}\hat\mu_{z,t-1}+\varepsilon_{\mu_z,t}.
$$

**(F30) Capital-embodied technology growth**
$$
\hat\mu_{\Upsilon,t}=\rho_{\mu_\Upsilon}\hat\mu_{\Upsilon,t-1}+\varepsilon_{\mu_\Upsilon,t}.
$$

**(F31) Money-growth policy decomposition**
$$
\hat x_t=\hat x_{z,t}+\hat x_{\Upsilon,t}+\hat x_{M,t}.
$$

**(F32) Monetary policy shock process**
$$
\hat x_{M,t}=\rho_{xM}\hat x_{M,t-1}+\varepsilon_{M,t}.
$$

**(F33) Monetary response to neutral technology**
$$
\hat x_{z,t}=\rho_{xz}\hat x_{z,t-1}+c_z\varepsilon_{z,t}+c_z^p\varepsilon_{z,t-1}.
$$

**(F34) Monetary response to embodied technology**
$$
\hat x_{\Upsilon,t}=\rho_{x\Upsilon}\hat x_{\Upsilon,t-1}
c_{\Upsilon}\varepsilon_{\Upsilon,t}+c_{\Upsilon}^p\varepsilon_{\Upsilon,t-1}.
$$

**(F35) Transitory neutral technology shock, implementation_cross_check**
$$
\epsilon_t=\rho_\epsilon\epsilon_{t-1}+\sigma_\epsilon\varepsilon_{\epsilon,t}.
$$

## 6. Steady-State Solution

The model is solved around a balanced-growth steady state. The paper sets several steady-state relationships directly and estimates the dynamic parameters.

1. Choose calibrated long-run parameters:
$$
\beta=1.03^{-0.25},\qquad \alpha=0.36,\qquad \delta=0.025,\qquad \lambda_w=1.05.
$$

2. Set embodied-technology growth and infer neutral growth from average output growth:
$$
\mu_y=\mu_\Upsilon^{\alpha/(1-\alpha)}\mu_z,\qquad
\mu_\Upsilon=1.0042,\qquad \mu_y=1.0045.
$$

3. Define balanced-growth technology:
$$
\mu_{z^\ast}=\mu_\Upsilon^{\alpha/(1-\alpha)}\mu_z.
$$

4. Use the steady-state Fisher relation:
$$
R=\frac{\pi\mu_{z^\ast}}{\beta}.
$$

5. Set average money growth:
$$
x=1.017.
$$

6. Parameterize transactions costs through steady-state velocity and cost share:
$$
V=0.45,\qquad \eta=0.036,\qquad V=\frac{PC}{Q}.
$$

7. Choose fixed costs $\phi$ so steady-state profits are zero. The source states this normalization but does not provide a complete closed-form steady-state block in the main paper Markdown.

8. For the Rep-MMB `model(linear)` file, all hatted implementation variables are deviations from the balanced-growth steady state; runtime validation and exact steady-state residual checks were not performed.

## 7. Timing & Form Conventions

- **Timing within the period**: technology shocks are observed before household real decisions and firm price/investment/utilization decisions; the monetary policy shock arrives later; then final demand is realized and firms choose labor to meet demand.
- **Firm-specific capital**: each intermediate firm starts period `t` with predetermined $\bar K_t(i)$. Investment $I_t(i)$ changes $\bar K_{t+1}(i)$, so firm-level capital is a state variable.
- **Capital services**: $K_t=u_t\bar K_t$; utilization is variable and costly.
- **Prices and wages**: Calvo non-reoptimizers index prices to lagged inflation and wages to lagged inflation plus steady-state productivity growth.
- **Model form**: Rep-MMB uses `model(linear)`. The paper's primitive model is nonlinear with balanced growth, then approximated around the non-stochastic steady state.
- **Runtime validation**: not performed; Dynare was not run.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Main equation(s) |
|---|---|---|---|
| Endogenous | `Y`, `ytilde_t` | output / scaled output | (F1), (F3), (F26) |
| Endogenous | `y(i)` | intermediate output | (F2), (F3) |
| Endogenous | `P`, `pi_t` | price level / inflation | (F11)-(F14) |
| Endogenous | `s_t` | average real marginal cost | (F13), (F14) |
| Endogenous | `W`, `wtilde_t` | aggregate wage / scaled wage | (F15)-(F17), (F25) |
| Endogenous | `H`, `h_t` | aggregate hours | (F10), (F25) |
| Endogenous | `C`, `c_t` | consumption | (F7)-(F9), (F26) |
| Endogenous | `Q`, `q_t` | cash balances / money-demand object | (F8), (F9), (F18), (F25) |
| Endogenous | `M`, `m_t` | money balances | (F8), (F25), (F27) |
| Endogenous | `x`, `x_t` | gross money growth | (F31)-(F34) |
| Endogenous | `R`, `R_t` | gross interest rate | (F18), (F23), (F32) |
| Endogenous | `K`, `kbar_t1` | capital services / physical capital stock | (F5), (F20) |
| Endogenous | `I`, `i_t` | investment | (F4), (F5), (F22), (F26) |
| Endogenous | `u_t` | capital utilization | (F20), (F21), (F26) |
| Endogenous | `lambda_zstar_t` | marginal utility / multiplier object in implementation | (F7), implementation cross-check |
| Endogenous | `rhotilde_t` | scaled rental return on capital | (F21), implementation cross-check |
| Exogenous | `eps_M_t`, `epsilon_M_` | monetary policy innovation | (F32) |
| Exogenous | `eps_muz_t`, `eps_muz_` | neutral technology growth innovation | (F29), (F33) |
| Exogenous | `eps_muups_t`, `eps_muups_` | embodied technology growth innovation | (F30), (F34) |
| Exogenous | `epsilon_t` | transitory neutral technology shock in Rep-MMB | (F35) |
| Parameter | `alpha` | capital share | (F3), (F24) |
| Parameter | `beta` | discount factor | (F6), (F13), (F23) |
| Parameter | `delta` | depreciation | (F5) |
| Parameter | `lambda_f` | intermediate-goods markup parameter | (F1), (F2), (F14) |
| Parameter | `lambda_w` | wage markup parameter | (F10), (F15), (F16) |
| Parameter | `xi_p`, `gamma` | Calvo price probability / reduced-form Phillips slope | (F13), (F14) |
| Parameter | `xi_w` | Calvo wage probability | (F17) |
| Parameter | `b` | habit parameter | (F7) |
| Parameter | `psi_L` | labor disutility scale | (F7) |
| Parameter | `sigma_a` | utilization-cost curvature | (F21) |
| Parameter | `S''`, `kappa` | investment-adjustment curvature | (F22) |
| Parameter | `mu_z`, `mu_ups`, `mu_zstar` | steady-state growth rates | (F23), (F24) |
| Parameter | `rho_*`, `c_*`, `cp_*` | shock and policy-process coefficients | (F29)-(F35) |

The implementation cross-check contains sticky-price and flexible-price copies of the same linearized block. The flexible-price copy is used to define the output gap; the source paper states that homogeneous and firm-specific capital models differ only in the inflation-equation mapping through $\gamma$.
