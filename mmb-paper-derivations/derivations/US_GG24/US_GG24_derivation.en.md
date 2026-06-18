# US_GG24 -- Derivation (Optimization Problems + First-Order Conditions)

> Model archive draft for `US_GG24`. Runtime validation was not performed. First-pass formula status: `needs_review`.

## 1. Model Overview

- **Model**: Gagliardone and Gertler (2024), "Oil Prices, Monetary Policy and Inflation Surges"; MMB model ID `US_GG24`.
- **Purpose**: an estimated monthly New Keynesian model used to study oil shocks, monetary-policy accommodation, demand shocks, and labor-market tightness during the recent U.S. inflation surge.
- **Agents and blocks**: representative household, Mortensen-Pissarides labor market, competitive wholesale firms using labor and oil, workers, Nash wage benchmark with real wage rigidity, Calvo retail firms, oil endowment sector, central bank, and a lump-sum-tax fiscal authority.
- **Model form**: source equations are written mostly in nonlinear levels, while the quantitative model is estimated through log-linearized equilibrium conditions and impulse-response matching. Treat this archive entry as a `needs_review` linearized DSGE derivation until source-level code/equation validation is completed.
- **Main shocks**: oil supply shock `eps_o`, discount-factor/demand shock `eps_b`, matching-efficiency shock `eps_phi`, monetary-policy shock `eps_r`, and an oil-price speculation/noise shock `eps_m` used in the historical-decomposition measurement equation.
- **Provenance**: extracted from `raw/mmb_mineru/runs/us_gg24__oil_prices_monetary_policy_and_inflation_surges__65e1c546/full.md`; raw PDF recorded at `raw/mmb_papers/Oil Prices, Monetary Policy and Inflation Surges.pdf`; DOI `10.3386/w31263`; MinerU run id `65e1c546-8764-48d5-8571-e080685b9992`.

## 2. Optimization Problems

### 2.1 Household

The representative household provides consumption insurance to employed and unemployed members. Conditional on employment \(n_t\), it chooses composite consumption \(c_t\), nominal bond holdings \(B_t\), final-goods consumption \(c_{qt}\), and oil consumption \(c_{ot}\).

\[
\max_{\{c_t,B_t,c_{qt},c_{ot}\}} E_t \sum_{i=0}^{\infty} \beta^i \varepsilon_{bt}
\ln(c_{t+i}-h c_{t-1+i})
\]

subject to the consumption aggregator and budget constraint

\[
c_t =
\left(\chi^{1/\psi} c_{ot}^{1-1/\psi}
+ (1-\chi)^{1/\psi} c_{qt}^{1-1/\psi}\right)^{1/(1-1/\psi)},
\]

\[
c_t = w_{ct} n_t + b_t(1-n_t)
+ R^n_{t-1}\frac{p_{c,t-1}}{p_{ct}}B_{t-1} - B_t + \Pi_t.
\]

`needs_review`: the paper's printed marginal utility line is OCR-noisy; the intended habit marginal utility is recorded in Section 3.

### 2.2 Wholesale Firms

Competitive wholesale firms choose vacancies, employment, and oil input to maximize the discounted value of profits, subject to CES production and employment accumulation:

\[
\max_{\{v_t,n_t,o_t\}} F_t
= p_{wt}y_t - w_{qt}n_t - c_v v_t - s_{qt}o_t
+ E_t\{\Lambda^q_{t,t+1}F_{t+1}\},
\]

\[
y_t =
\left(\alpha^{1/\epsilon} n_t^{1-1/\epsilon}
+(1-\alpha)^{1/\epsilon} o_t^{1-1/\epsilon}\right)^{1/(1-1/\epsilon)},
\]

\[
n_t = \rho n_{t-1}+q_t v_t.
\]

### 2.3 Nash Wage Benchmark

The Nash benchmark wage solves

\[
\max_{w^o_{qt}} H_t^{\varsigma}J_t^{1-\varsigma},
\]

where \(H_t\) is worker surplus and \(J_t\) is the firm value of a filled job. The implemented wage is a real-wage-rigidity transformation of this benchmark rather than the flexible Nash wage itself.

### 2.4 Retail Firms

Retailers face Calvo pricing. A firm that can reset its price chooses \(p^{\ast}_{jt}\) and demand \(y_{j,t+i}\) to maximize expected discounted profits:

\[
\max_{\{p^{\ast}_{jt},y_{j,t+i}\}} E_t\left\{\sum_{i=0}^{\infty}\lambda^i
\Lambda^q_{t,t+i}\left(\frac{p^{\ast}_{jt}}{p_{qt}}-p_{w,t+i}\right)y_{j,t+i}\right\},
\]

subject to the demand schedule

\[
y_{jt}=\left(\frac{p_{jt}}{p_{qt}}\right)^{-\eta}c_{qt}.
\]

### 2.5 Oil Producer, Government, and Policy Authority

The oil producer receives an exogenous endowment and pays profits to households. The fiscal authority finances unemployment insurance with lump-sum taxes. The central bank follows a Taylor rule rather than solving an optimization problem.

## 3. First-Order Conditions

- **(F1) Household stochastic discount factor and Euler equation**:

\[
\Lambda_{t,t+1}=\beta\frac{u_{c,t+1}}{u_{ct}}, \qquad
E_t\left\{\Lambda_{t,t+1} R^n_t\frac{p_{ct}}{p_{c,t+1}}\right\}=1.
\]

with habit marginal utility

\[
u_{ct}=\frac{1}{c_t-hc_{t-1}}-\frac{\beta h}{c_{t+1}-hc_t}.
\]

- **(F2) Household demand for final consumption goods and oil**:

\[
c_{qt}=(1-\chi)\left(\frac{p_{qt}}{p_{ct}}\right)^{-\psi}c_t,
\qquad
c_{ot}=\chi s_t^{-\psi}c_t.
\]

- **(F3) Consumption price index**:

\[
p_{ct}=\left(\chi p_{ot}^{1-\psi}+(1-\chi)p_{qt}^{1-\psi}\right)^{1/(1-\psi)}.
\]

- **(F4) Wholesale production function**:

\[
y_t =
\left(\alpha^{1/\epsilon} n_t^{1-1/\epsilon}
+(1-\alpha)^{1/\epsilon} o_t^{1-1/\epsilon}\right)^{1/(1-1/\epsilon)}.
\]

- **(F5) Employment accumulation**:

\[
n_t=\rho n_{t-1}+q_t v_t.
\]

- **(F6) Hiring condition**:

\[
\frac{c_v}{q_t}
= p_{wt}a_{nt}-w_{qt}
+\rho E_t\left\{\Lambda^q_{t,t+1}\frac{c_v}{q_{t+1}}\right\}.
\]

- **(F7) Marginal product of labor**:

\[
a_{nt}=\left(\alpha\frac{y_t}{n_t}\right)^{1/\epsilon}.
\]

- **(F8) Oil demand condition**:

\[
p_{wt}a_{ot}=s_{qt}.
\]

- **(F9) Marginal product of oil**:

\[
a_{ot}=\left((1-\alpha)\frac{y_t}{o_t}\right)^{1/\epsilon}.
\]

- **(F10) Firm value of a filled job**:

\[
J_t=p_{wt}a_{nt}-w_{qt}
+\rho E_t\{\Lambda^q_{t,t+1}J_{t+1}\}.
\]

- **(F11) Worker surplus**:

\[
H_t=w_{ct}-b_t
+E_t\{\Lambda_{t,t+1}(\rho-f_{t+1})H_{t+1}\}.
\]

- **(F12) Nash benchmark product wage**:

\[
w^o_{qt} =
\frac{\varsigma\left(p_{wt}a_{nt}
+\rho E_t\left\{\frac{c_v}{q_{t+1}}(\Lambda^q_{t,t+1}-\Lambda_{t,t+1})\right\}
+E_t\{\Lambda_{t,t+1}c_v\theta_{t+1}\}\right)
+(1-\varsigma)\frac{p_{qt}}{p_{ct}}b}
{\varsigma+(1-\varsigma)\frac{p_{qt}}{p_{ct}}}.
\]

`needs_review`: formula normalized from OCR around the Nash wage expression.

- **(F13) Real wage rigidity**:

\[
w_{qt}=(w^o_{qt})^{1-\gamma}(\bar w^o_q)^\gamma.
\]

- **(F14) Retail demand for differentiated goods**:

\[
y_{jt}=\left(\frac{p_{jt}}{p_{qt}}\right)^{-\eta}c_{qt}.
\]

- **(F15) Calvo reset-price FOC**:

\[
E_t\left\{\sum_{i=0}^{\infty}\lambda^i\Lambda^q_{t,t+i}
\left(\frac{p^{\ast}_{jt}}{p_{q,t+i}}-(1+\mu)p_{w,t+i}\right)y_{j,t+i}\right\}=0.
\]

- **(F16) Goods price index under Calvo pricing**:

\[
p_{qt}=\left((1-\lambda)(p^{\ast}_t)^{1-\eta}
+\lambda p_{q,t-1}^{1-\eta}\right)^{1/(1-\eta)}.
\]

- **(F17) Linearized New Keynesian Phillips curve**:

\[
\pi_{qt}=\kappa\widehat p_{wt}+E_t\{\pi_{q,t+1}\},
\qquad
\kappa=\frac{(1-\lambda)(1-\lambda\beta)}{\lambda}.
\]

- **(F18) Present-value inflation representation**:

\[
\pi_{qt}=\kappa\sum_{i=0}^{\infty}E_t\{\widehat p_{w,t+i}\}.
\]

- **(F19) Marginal-cost identity**:

\[
p_{wt}=\frac{w_{qt}+\omega_t}{a_{nt}}.
\]

- **(F20) Net hiring cost**:

\[
\omega_t=\frac{c_v}{q_t}
-\rho E_t\left\{\Lambda^q_{t,t+1}\frac{c_v}{q_{t+1}}\right\}.
\]

- **(F21) Log-linear marginal-cost decomposition**:

\[
\widehat p_{wt}=\zeta\widehat w_{qt}+(1-\zeta)\widehat\omega_t-\widehat a_{nt},
\qquad
\zeta=\frac{\bar w_q}{\bar w_q+\bar\omega}.
\]

- **(F22) Log-linear marginal product of labor approximation**:

\[
\widehat a_{nt}=\frac{1}{\epsilon}(1-\bar\alpha)(\widehat o_t-\widehat n_t),
\]

with

\[
\bar\alpha =
\frac{\alpha}
{\alpha+\alpha^{1-1/\epsilon}(1-\alpha)^{1/\epsilon}(\bar o/\bar n)^{1-1/\epsilon}}
\approx \alpha.
\]

## 4. Market Clearing & Identities

- **(F23) Unemployment identity**:

\[
u_t=1-n_{t-1}.
\]

- **(F24) Matching function**:

\[
\Phi_t=\varepsilon_{\Phi t}u_t^\sigma v_t^{1-\sigma}.
\]

- **(F25) Vacancy-filling and job-finding probabilities**:

\[
q_t=\frac{\Phi_t}{v_t}, \qquad f_t=\frac{\Phi_t}{u_t}.
\]

- **(F26) Labor-market tightness**:

\[
\theta_t=\frac{v_t}{u_t}.
\]

- **(F27) Oil-market clearing**:

\[
o_t+c_{ot}=S\exp(-\varepsilon_{ot}).
\]

- **(F28) Produced-goods resource constraint**:

\[
c_{qt}=y_{qt}-c_v v_t.
\]

- **(F29) Bond-market clearing**:

\[
B_t=0.
\]

- **(F30) Product-wage and oil-price unit conversions**:

\[
w_{qt}=w_{ct}\frac{p_{ct}}{p_{qt}},
\qquad
s_{qt}=s_t\frac{p_{ct}}{p_{qt}},
\qquad
s_t=\frac{p_{ot}}{p_{ct}}.
\]

- **(F31) Fiscal budget**:

\[
b_t u_t=\tau_t.
\]

## 5. Exogenous Processes

- **(F32) Monetary policy rule**:

\[
R^n_t =
\left(R^n(1+\pi_{qt})^{\phi_\pi}\right)^{1-\rho^R}
(R^n_{t-1})^{\rho^R}e^{\varepsilon_{rt}}.
\]

`needs_review`: the source's Taylor rule is multiplicative; this line preserves the printed form's plus sign between the two components, but a standard Dynare implementation may use multiplication.

- **(F33) Monetary-policy shock**:

\[
\varepsilon_{rt}=\rho^m\varepsilon_{r,t-1}+\sigma^m e^r_t.
\]

`needs_review`: AR(1) form inferred from the text and parameter table; exact innovation notation is not printed as a numbered paper equation.

- **(F34) Persistent oil shock**:

\[
\varepsilon_{ot}=\rho^o\varepsilon_{o,t-1}+\sigma^o e^o_t.
\]

`needs_review`: AR(1) form inferred from the text and parameter table.

- **(F35) Discount-factor/demand shock**:

\[
\varepsilon_{bt}=\rho^b\varepsilon_{b,t-1}+\sigma^b e^b_t.
\]

`needs_review`: persistence and volatility are reported in Appendix B, but the process is not printed in the main model block.

- **(F36) Matching-efficiency shock**:

\[
\varepsilon_{\Phi t}=\rho^\Phi\varepsilon_{\Phi,t-1}+\sigma^\Phi e^\Phi_t.
\]

`needs_review`: persistence and volatility are reported in Appendix B, but the process is not printed in the main model block.

- **(F37) Oil-price measurement/noise equation**:

\[
\pi_{ot}=\bar\pi_{ot}+\varepsilon_{mt}.
\]

## 6. Steady-State Solution

The paper reports steady-state targets and parameter restrictions rather than a full analytic `steady_state_model`. The following source-backed steady-state structure should be treated as `needs_review` until checked against implementation files or author code.

1. Set zero-inflation steady state for final-goods inflation: \(\pi_q=0\) and constant relative prices.
2. Choose \(\beta=0.998\) to generate an annual real interest rate of about 2 percent.
3. Choose \(\eta=4\), implying a steady-state gross markup of about 1.3 through \(\mu=1/(1-1/\eta)\).
4. Set labor-market steady-state targets: \(\rho=0.96\), \(\sigma=\varsigma=0.5\), unemployment \(u=0.05\), and outside option \(b=0.7\).
5. Use the unemployment identity \(u=1-n_{-1}\) to pin down steady-state employment near \(n=0.95\).
6. Use steady-state matching, vacancy filling, and job finding to solve vacancies, matches, \(q\), \(f\), and tightness \(\theta=v/u\) once one matching normalization is selected.
7. Use oil-sector targets \(o/y=0.03\) and \(o/c_o=1.5\) to pin down the labor share parameter \(\alpha=0.97\) and the household oil share \(\chi=0.02\).
8. Estimate the remaining parameters from impulse-response matching: \(\epsilon=0.370\), \(\psi=0.020\), \(h=0.906\), \(\lambda=0.946\), \(\gamma=0.705\), \(\phi_\pi=2.16\), \(\rho^R=0.063\), \(\rho^m=0.946\), \(\rho^o=0.964\), \(\sigma^m=0.023\), and \(\sigma^o=0.062\).
9. Appendix B reports Bayesian estimates for historical-decomposition shock processes: \(\rho^b=0.298\), \(\rho^\Phi=0.515\), \(\sigma^b=0.0577\), \(\sigma^\Phi=0.157\), oil-shock volatility about \(0.052\), and money-shock volatility about \(0.042\).

## 7. Timing & Form Conventions

- **Frequency**: monthly calibration and estimation; some table entries also give quarterly equivalents.
- **Employment timing**: unemployment is \(u_t=1-n_{t-1}\), so workers unemployed at the beginning of period \(t\) are determined by lagged employment. New hires work immediately in period \(t\), and employment evolves as \(n_t=\rho n_{t-1}+q_t v_t\).
- **Oil endowment timing**: oil supply in period \(t\) is \(S\exp(-\varepsilon_{ot})\) and the relative oil price clears contemporaneous household and firm oil demand.
- **Inflation convention**: core inflation is net log inflation \(\pi_{qt}=\ln(p_{qt}/p_{q,t-1})\) in the policy rule and linearized Phillips curve.
- **Policy rate**: the baseline empirical implementation uses a proxy funds rate rather than the raw Federal funds rate.
- **Model form**: paper-side equilibrium combines nonlinear conditions and log-linear approximations; this entry classifies `US_GG24` as a linearized estimated NK model for archive purposes.
- **Runtime validation**: not performed; Dynare was not run.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII name | Meaning | Main equation |
|---|---|---|---|
| Endogenous | `c` / \(c_t\) | composite consumption | (F1)-(F3) |
| Endogenous | `c_q` / \(c_{qt}\) | final consumption goods | (F2), (F28) |
| Endogenous | `c_o` / \(c_{ot}\) | household oil consumption | (F2), (F27) |
| Endogenous | `B` / \(B_t\) | nominal bonds | (F1), (F29) |
| Endogenous | `n` / \(n_t\) | employment | (F5), (F23) |
| Endogenous | `u` / \(u_t\) | unemployment | (F23) |
| Endogenous | `v` / \(v_t\) | vacancies | (F24)-(F26) |
| Endogenous | `Phi` / \(\Phi_t\) | new matches | (F24) |
| Endogenous | `q` / \(q_t\) | vacancy-filling probability | (F25) |
| Endogenous | `f` / \(f_t\) | job-finding probability | (F25) |
| Endogenous | `theta` / \(\theta_t\) | labor-market tightness | (F26) |
| Endogenous | `y` / \(y_t\) | wholesale output | (F4) |
| Endogenous | `o` / \(o_t\) | firm oil input | (F8), (F27) |
| Endogenous | `a_n` / \(a_{nt}\) | marginal product of labor | (F7), (F22) |
| Endogenous | `a_o` / \(a_{ot}\) | marginal product of oil | (F9) |
| Endogenous | `p_w` / \(p_{wt}\) | real marginal cost / wholesale relative price | (F19), (F21) |
| Endogenous | `w_q` / \(w_{qt}\) | product wage | (F12), (F13), (F30) |
| Endogenous | `w_c` / \(w_{ct}\) | consumption wage | (F30) |
| Endogenous | `J` / \(J_t\) | firm value of a match | (F10) |
| Endogenous | `H` / \(H_t\) | worker surplus | (F11) |
| Endogenous | `p_q` / \(p_{qt}\) | final-goods price index | (F16) |
| Endogenous | `pi_q` / \(\pi_{qt}\) | core inflation | (F17), (F32) |
| Endogenous | `p_star` / \(p^{\ast}_t\) | reset price | (F15), (F16) |
| Endogenous | `R_n` / \(R^n_t\) | nominal policy rate | (F1), (F32) |
| Endogenous | `s` / \(s_t\) | relative oil price in consumption units | (F2), (F30) |
| Endogenous | `s_q` / \(s_{qt}\) | oil price in final-good units | (F8), (F30) |
| Exogenous | `eps_o` / \(\varepsilon_{ot}\) | oil supply shock | (F27), (F34) |
| Exogenous | `eps_b` / \(\varepsilon_{bt}\) | discount-factor/demand shock | (F35) |
| Exogenous | `eps_phi` / \(\varepsilon_{\Phi t}\) | matching-efficiency shock | (F24), (F36) |
| Exogenous | `eps_r` / \(\varepsilon_{rt}\) | monetary-policy shock | (F32), (F33) |
| Exogenous | `eps_m` / \(\varepsilon_{mt}\) | oil-price speculation/noise shock | (F37) |
| Parameter | `beta` / \(\beta\) | discount factor | 0.998 |
| Parameter | `eta` / \(\eta\) | differentiated-goods elasticity | 4 |
| Parameter | `rho` / \(\rho\) | job survival rate | 0.96 |
| Parameter | `sigma` / \(\sigma\) | matching elasticity | 0.5 |
| Parameter | `varsigma` / \(\varsigma\) | worker bargaining power | 0.5 |
| Parameter | `b` / \(b\) | worker outside option | 0.7 |
| Parameter | `alpha` / \(\alpha\) | labor share in production CES | 0.97 |
| Parameter | `chi` / \(\chi\) | household oil share | 0.02 |
| Parameter | `epsilon` / \(\epsilon\) | oil-labor substitution elasticity | 0.370 |
| Parameter | `psi` / \(\psi\) | oil-consumption substitution elasticity | 0.020 |
| Parameter | `h` / \(h\) | habit persistence | 0.906 |
| Parameter | `lambda` / \(\lambda\) | Calvo non-adjustment probability | 0.946 |
| Parameter | `gamma` / \(\gamma\) | real wage rigidity | 0.705 |
| Parameter | `phi_pi` / \(\phi_\pi\) | Taylor-rule inflation feedback | 2.16 |
| Parameter | `rho_R` / \(\rho^R\) | interest-rate smoothing | 0.063 |
| Parameter | `rho_m` / \(\rho^m\) | monetary-shock persistence | 0.946 |
| Parameter | `rho_o` / \(\rho^o\) | oil-shock persistence | 0.964 |

First-pass equation and variable coverage is intentionally broader than a final Dynare `model(linear)` block because the paper does not provide a complete runnable equation list. Status remains `needs_review`.
