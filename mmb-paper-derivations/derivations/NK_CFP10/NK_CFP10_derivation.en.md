# NK_CFP10 -- Derivation (Optimization Problems + Equilibrium Conditions)

> Status: `needs_review`. This first-pass archive entry is extracted from the MinerU Markdown source for Carlstrom, Fuerst, and Paustian (2010). MinerU OCR is readable for the core model, but several appendix formulas remain noisy and runtime validation was not performed.

Source: Charles T. Carlstrom, Timothy S. Fuerst, and Matthias Paustian (2010), "Optimal monetary policy in a model with agency costs," *Journal of Money, Credit and Banking* 42(s1), 37-70. DOI: `10.1111/j.1538-4616.2010.00329.x`.

## 1. Model Overview

- **Model**: `NK_CFP10`, a small log-linear New Keynesian model with agency costs represented by a collateral constraint on one productive labor input.
- **Agents**: households, entrepreneurs producing an intermediate good, monopolistically competitive final-good firms with Rotemberg price adjustment costs, and a monetary authority.
- **Financial friction**: entrepreneurs must back the wage bill for constrained input $L_t$ with net worth and operating-profit collateral. The multiplier $b\phi_t$ is interpreted as a credit distortion or risk-premium proxy.
- **Shocks**: technology, markup, entrepreneurial net worth, and monetary-policy shocks.
- **Form**: the paper develops nonlinear primitives but the MMB implementation and reduced system are `model(linear)` in percentage deviations from the deterministic steady state. Hatted variables denote log deviations. Runtime validation: not performed.

## 2. Optimization Problems

### 2.1 Households

Households choose consumption, two labor inputs, one-period bonds, and equity shares. Their period utility is:

$$
U(C_t,L_t,u_t)=\frac{C_t^{1-\sigma}}{1-\sigma}
-B_1\frac{L_t^{1+\theta}}{1+\theta}
-B_2\frac{u_t^{1+\theta}}{1+\theta}.
$$

The paper reports household optimality conditions rather than a full budget constraint in the model section. Households supply constrained labor $L_t$ and unconstrained labor $u_t$ at prices $w_t$ and $r_t$, price the nominal bond with gross nominal return $R_t$, and price equity shares $Q_t$ that pay dividends $D_t$.

### 2.2 Entrepreneurs

Entrepreneurs have linear consumption preferences and use two labor inputs in a CRS intermediate-goods technology:

$$
x_t=L_t^\alpha u_t^{1-\alpha}.
$$

Their operating profit is:

$$
\text{profits}_t=p_t x_t-w_tL_t-r_tu_t.
$$

Hiring of constrained input $L_t$ is subject to the binding collateral constraint:

$$
w_tL_t \leq nw_t^b\left(p_tx_t-r_tu_t\right)^{1-b},
$$

where net worth is $nw_t=e_{t-1}(Q_t+D_t)$. The Lagrange multiplier on this constraint is $\phi_t$.

The entrepreneur budget constraint is:

$$
c_t^e+e_tQ_t \leq e_{t-1}(Q_t+D_t)+\text{profits}_t.
$$

Because entrepreneurs have linear preferences and value internal funds for relaxing future constraints, the equilibrium considered in the paper has zero entrepreneurial consumption before unexpected death/exit transfers.

### 2.3 Sticky-Price Final-Good Firms

Final-good firms aggregate differentiated goods and use the intermediate good linearly, $y_{t,j}=a_tx_{t,j}$. Real marginal cost is:

$$
z_t=\frac{p_t}{a_t}.
$$

Rotemberg price adjustment costs generate the linear New Keynesian Phillips curve in equilibrium. Final-good-firm dividends are:

$$
D_t=a_tx_t(1-z_t).
$$

### 2.4 Monetary Authority

The paper studies optimal commitment policy and simple interest-rate rules. The MMB implementation uses a Taylor rule with inflation and output-gap responses, plus a persistent monetary-policy shock.

## 3. First-Order Conditions

The archive equations below combine the paper's nonlinear model conditions and the log-linear reduced system used by `NK_CFP10`. All equations should be treated as `needs_review` where OCR artifacts are noted in `extraction_notes.md`.

- **(F1) Household labor supply for constrained input**:

$$
\frac{U_L(t)}{U_c(t)}=w_t(1+w_{\mathrm{sub}}).
$$

- **(F2) Household labor supply for unconstrained input**:

$$
\frac{U_u(t)}{U_c(t)}=r_t(1+r_{\mathrm{sub}}).
$$

- **(F3) Household bond Euler / Fisher condition**:

$$
U_c(t)=E_t\left[\beta U_c(t+1)\frac{R_t}{\pi_{t+1}}\right].
$$

- **(F4) Household equity-pricing condition**:

$$
Q_tU_c(t)=E_t\left[\beta U_c(t+1)(Q_{t+1}+D_{t+1})\right].
$$

- **(F5) Entrepreneur FOC for constrained labor**:

$$
\alpha p_tx_t=w_tL_t(1+b\phi_t).
$$

- **(F6) Entrepreneur FOC for unconstrained labor**:

$$
(1-\alpha)p_tx_t=r_tu_t.
$$

- **(F7) Binding collateral constraint, rewritten as a credit distortion**:

$$
1+b\phi_t=\left(\frac{\alpha p_tx_t}{nw_t}\right)^b.
$$

- **(F8) Entrepreneur profit identity**:

$$
\text{profits}_t=\alpha p_tx_t-w_tL_t
=\alpha p_tx_t\left(\frac{b\phi_t}{1+b\phi_t}\right).
$$

- **(F9) Linear household labor condition for $L_t$**:

$$
\sigma\hat y_t+\theta\hat L_t=\hat w_t.
$$

- **(F10) Linear household labor condition for $u_t$**:

$$
\sigma\hat y_t+\theta\hat u_t=\hat r_t.
$$

- **(F11) Linear intertemporal Euler condition**:

$$
\sigma(E_t\hat y_{t+1}-\hat y_t)=\hat R_t-E_t\hat\pi_{t+1}.
$$

- **(F12) Linear equity pricing equation** (`needs_review`: OCR shows an inconsistent current-output term in the last bracket):

$$
\hat q_t=\beta E_t\hat q_{t+1}+(1-\beta)E_t\hat d_{t+1}
-\sigma(E_t\hat y_{t+1}-\hat y_t).
$$

- **(F13) Entrepreneur share-value identity**:

$$
\hat e_t+\hat q_t=\hat z_t+\hat y_t+\Lambda\hat\phi_t,
\qquad \Lambda\equiv\frac{F'}{F}\approx b-1\leq 0.
$$

- **(F14) Linear collateral constraint**:

$$
\hat w_t+\hat L_t
=b(\hat e_{t-1}+\beta\hat q_t+(1-\beta)\hat d_t+\hat n_t)
+(1-b)(\hat z_t+\hat y_t).
$$

- **(F15) Linear production function**:

$$
\hat y_t=\hat a_t+(1-\alpha)\hat u_t+\alpha\hat L_t.
$$

- **(F16) Rotemberg Phillips curve**:

$$
\hat\pi_t=\lambda\hat z_t+\beta E_t\hat\pi_{t+1}+\lambda\epsilon_t^\pi,
\qquad \lambda=\frac{\varepsilon-1}{\varphi}.
$$

- **(F17) Dividend equation**:

$$
\hat d_t=\hat y_t-(\varepsilon-1)\hat z_t.
$$

- **(F18) Linear credit-distortion identity**:

$$
b\hat\phi_t=\hat z_t+\hat y_t-\hat w_t-\hat L_t.
$$

## 4. Market Clearing & Identities

- **(F19) Efficient output and output gap**:

$$
\hat y_t^{\mathrm{eff}}=\frac{1+\theta}{\sigma+\theta}\hat a_t,
\qquad
\hat y_t^g=\hat y_t-\hat y_t^{\mathrm{eff}}.
$$

- **(F20) Output-gap relation to marginal cost and credit distortion**:

$$
\hat y_t^g=\frac{1}{\sigma+\theta}\hat z_t
-\frac{\alpha}{\sigma+\theta}b\hat\phi_t.
$$

- **(F21) Phillips curve in output-gap form**:

$$
\hat\pi_t=\lambda(\sigma+\theta)\hat y_t^g
+\alpha\lambda b\hat\phi_t
+\beta E_t\hat\pi_{t+1}
+\lambda\epsilon_t^\pi.
$$

- **(F22) Taylor rule used in the MMB implementation**:

$$
\hat R_t=\tau\hat\pi_t+\tau_g\hat y_t^g+\epsilon_t^R.
$$

The model has no capital accumulation block. Share ownership, equity prices, dividends, and entrepreneur net worth are the state variables through which agency costs propagate.

## 5. Exogenous Processes

- **(F23) Technology process**:

$$
\hat a_t=\rho_a\hat a_{t-1}-\eta_t^a.
$$

- **(F24) Markup shock process**:

$$
\epsilon_t^\pi=\rho_\pi\epsilon_{t-1}^\pi+\eta_t^\pi.
$$

- **(F25) Net-worth shock process**:

$$
\hat n_t=\rho_n\hat n_{t-1}-\eta_t^n.
$$

- **(F26) Monetary-policy shock process**:

$$
\epsilon_t^R=\rho_R\epsilon_{t-1}^R-\eta_t^R.
$$

## 6. Steady-State Solution

The reduced model is log-linear around an efficient deterministic steady state. Therefore all hatted endogenous variables and innovations have zero steady state:

$$
\hat y=\hat y^{\mathrm{eff}}=\hat y^g=\hat R=\hat\pi=\hat z=\hat\phi=\hat e=\hat q=\hat d
=\hat L=\hat u=\hat r=\hat w=\hat a=\epsilon^\pi=\hat n=\epsilon^R=0.
$$

The nonlinear steady-state relationships reported in the appendix are:

$$
B_1C_{ss}^{\sigma}L_{ss}^{\theta}=w_{ss}(1+w_{\mathrm{sub}}),\qquad
B_2C_{ss}^{\sigma}u_{ss}^{\theta}=r_{ss}(1+r_{\mathrm{sub}}).
$$

$$
Q_{ss}=\frac{\beta}{1-\beta}D_{ss},\qquad
z_{ss}=\frac{\varepsilon-1}{\varepsilon},\qquad
D_{ss}=x_{ss}(1-z_{ss}).
$$

$$
z_{ss}MPL_{ss}=w_{ss}(1+b\phi_{ss}),\qquad
z_{ss}MPU_{ss}=r_{ss}.
$$

Subsidies are chosen so that:

$$
B_1C_{ss}^{\sigma}L_{ss}^{\theta}
=MPL_{ss}\frac{z_{ss}}{1+b\phi_{ss}}(1+w_{\mathrm{sub}})
=MPL_{ss},
$$

$$
B_2C_{ss}^{\sigma}u_{ss}^{\theta}
=MPU_{ss}z_{ss}(1+r_{\mathrm{sub}})
=MPU_{ss}.
$$

The appendix also reports a calibration link to a CSV model: for $\mu=0.15$, a 1 percent bankruptcy rate, and a 330/4 basis point quarterly risk premium, $\xi=4$, implying $b=1/(1+\xi)=0.2$ and $b\phi_{ss}=0.026$. These calibration details are `implementation_cross_check`-consistent with the `.mod` parameter `b = 0.20`.

## 7. Timing & Form Conventions

- **Form**: `model(linear)`; hatted variables are percentage/log deviations from the deterministic steady state. In the `.mod`, hats are omitted because all variables are already deviations.
- **Expectations**: equations use $E_t$ timing. In Dynare form, future expectations appear as leads, e.g. $\hat\pi_{t+1}$ and $\hat y_{t+1}$.
- **State variables**: entrepreneur equity/share holdings $\hat e_t$ and net-worth shocks carry the agency-cost dynamics. The source defines $nw_t=e_{t-1}(Q_t+D_t)$, so net worth depends on lagged entrepreneur share holdings and current equity payoff.
- **No capital stock**: $u_t$ can be read as unconstrained labor input or as a capital-utilization-like service, but the model archive should not introduce a capital accumulation equation.
- **Policy closure**: optimal policy is analyzed in the paper, but the MMB implementation closes the simulation model with a Taylor rule.

## 8. Variable & Parameter Reference Table

| Category | Symbol / name | Meaning | Primary equations |
|---|---|---|---|
| Endogenous | `y`, $\hat y_t$ | Output | (F15), (F19)-(F21) |
| Endogenous | `yeff`, $\hat y_t^{\mathrm{eff}}$ | Efficient output | (F19) |
| Endogenous | `yg`, $\hat y_t^g$ | Output gap | (F19)-(F21), (F22) |
| Endogenous | `R`, $\hat R_t$ | Nominal interest rate deviation | (F11), (F22) |
| Endogenous | `pi`, $\hat\pi_t$ | Inflation deviation | (F16), (F21) |
| Endogenous | `z`, $\hat z_t$ | Real marginal cost | (F16), (F18), (F20) |
| Endogenous | `phi`, $\hat\phi_t$ | Agency-cost multiplier / credit distortion | (F7), (F18), (F20)-(F21) |
| Endogenous | `e`, $\hat e_t$ | Entrepreneur equity share holdings | (F13), (F14) |
| Endogenous | `q`, $\hat q_t$ | Equity/share price | (F4), (F12)-(F14) |
| Endogenous | `d`, $\hat d_t$ | Dividends | (F17) |
| Endogenous | `L`, $\hat L_t$ | Constrained labor input | (F1), (F5), (F9), (F14)-(F15) |
| Endogenous | `u`, $\hat u_t$ | Unconstrained labor input | (F2), (F6), (F10), (F15) |
| Endogenous | `r`, $\hat r_t$ | Price of unconstrained labor input | (F2), (F6), (F10) |
| Endogenous | `w`, $\hat w_t$ | Wage for constrained labor input | (F1), (F5), (F9), (F14), (F18) |
| Endogenous shock state | `a`, $\hat a_t$ | Technology | (F19), (F23) |
| Endogenous shock state | `eps_pi`, $\epsilon_t^\pi$ | Markup shock state | (F16), (F21), (F24) |
| Endogenous shock state | `n`, $\hat n_t$ | Net-worth shock state | (F14), (F25) |
| Endogenous shock state | `eps_R`, $\epsilon_t^R$ | Monetary-policy shock state | (F22), (F26) |
| Exogenous | `eta_a` | Technology innovation | (F23) |
| Exogenous | `eta_pi` | Markup innovation | (F24) |
| Exogenous | `eta_n` | Net-worth innovation | (F25) |
| Exogenous | `eta_R` | Monetary-policy innovation | (F26) |
| Parameter | `betta`, $\beta$ | Discount factor | (F3), (F4), (F12), (F16) |
| Parameter | `sig`, $\sigma$ | Inverse intertemporal elasticity / CRRA parameter | (F9)-(F12), (F19)-(F21) |
| Parameter | `thet`, $\theta$ | Inverse Frisch elasticity | (F9), (F10), (F19)-(F21) |
| Parameter | `eps`, $\varepsilon$ | Dixit-Stiglitz elasticity | (F16), (F17) |
| Parameter | `alfa`, $\alpha$ | Constrained-input share | (F5), (F15), (F20), (F21) |
| Parameter | `b` | Collateral-constraint elasticity | (F7), (F14), (F18), (F20), (F21) |
| Parameter | `Lam`, $\Lambda$ | Derivative of $F(\phi)$ around steady state | (F13) |
| Parameter | `varphi`, $\varphi$ | Rotemberg adjustment-cost parameter | (F16) |
| Parameter | `lam`, $\lambda$ | Phillips-curve slope | (F16), (F21) |
| Parameter | `rho_a`, `rho_pi`, `rho_n`, `rho_R` | Shock persistence parameters | (F23)-(F26) |
| Parameter | `tau`, `tau_g` | Taylor-rule coefficients | (F22) |
