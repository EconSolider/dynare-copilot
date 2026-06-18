# EA_GNSS10 - Derivation (Optimization Problems and First-Order Conditions)

> First-pass private archive entry. Status: `needs_review`. Source: Gerali, Neri, Sessa, and Signoretti (2010), "Credit and Banking in a DSGE Model of the Euro Area", DOI `10.1111/j.1538-4616.2010.00331.x`.

## 1. Model Overview

- **Model**: Euro-area DSGE model with patient households, impatient households, entrepreneurs, monopolistically competitive banks, capital producers, retailers, unions, and a Taylor-rule central bank.
- **Archive model id**: `EA_GNSS10`.
- **Main financial mechanism**: impatient households and entrepreneurs borrow from banks against collateral; banks fund loans with deposits and bank capital, set sticky retail rates, and face a cost when their capital-to-assets ratio deviates from target.
- **Form**: the paper states that the model is log-linearized around the steady state. The equations below keep the paper's nonlinear levels for constraints and the implementable equilibrium form where useful, but this first-pass archive entry should be treated as a log-linear model entry until source-level review is completed.
- **Implementation cross-check**: `.agents/skills/dynare-copilot/references/examples/EA_GNSS10_rep.mod` confirms the implemented blocks and shock names, but is not used as paper-side evidence.

## 2. Optimization Problems

### Patient Households

Patient households choose consumption, housing, deposits, and labor:

```math
\max_{\{c_t^P,h_t^P,d_t^P,l_t^P\}} E_0\sum_{t=0}^{\infty}\beta_P^t
\left[(1-a^P)\varepsilon_t^z\log(c_t^P-a^P c_{t-1}^P)+\varepsilon_t^h\log h_t^P-\frac{(l_t^P)^{1+\phi}}{1+\phi}\right]
```

subject to

```math
c_t^P+q_t^h(h_t^P-h_{t-1}^P)+d_t^P
=w_t^P l_t^P+\frac{(1+r_{t-1}^d)d_{t-1}^P}{\pi_t}+t_t^P .
```

### Impatient Households

Impatient households choose consumption, housing, bank borrowing, and labor:

```math
\max_{\{c_t^I,h_t^I,b_t^I,l_t^I\}} E_0\sum_{t=0}^{\infty}\beta_I^t
\left[(1-a^I)\varepsilon_t^z\log(c_t^I-a^I c_{t-1}^I)+\varepsilon_t^h\log h_t^I-\frac{(l_t^I)^{1+\phi}}{1+\phi}\right]
```

subject to the budget constraint

```math
c_t^I+q_t^h(h_t^I-h_{t-1}^I)+\frac{(1+r_{t-1}^{bH})b_{t-1}^I}{\pi_t}
=w_t^I l_t^I+b_t^I+t_t^I
```

and the collateral constraint

```math
(1+r_t^{bH})b_t^I \le m_t^I E_t[q_{t+1}^h h_t^I\pi_{t+1}] .
```

### Entrepreneurs

Entrepreneurs choose consumption, capital, bank borrowing, capital utilization, and labor inputs:

```math
\max_{\{c_t^E,k_t^E,b_t^E,u_t,l_t^{E,P},l_t^{E,I}\}} E_0\sum_{t=0}^{\infty}\beta_E^t
\log(c_t^E-a^E c_{t-1}^E)
```

subject to

```math
\begin{aligned}
c_t^E+w_t^P l_t^{E,P}+w_t^I l_t^{E,I}+\frac{(1+r_{t-1}^{bE})b_{t-1}^E}{\pi_t}
+q_t^k k_t^E+\psi(u_t)k_{t-1}^E
=\frac{y_t^E}{x_t}+b_t^E+q_t^k(1-\delta)k_{t-1}^E ,
\end{aligned}
```

production technology

```math
y_t^E=A_t^E(u_t k_{t-1}^E)^\alpha\left[(l_t^{E,P})^\mu(l_t^{E,I})^{1-\mu}\right]^{1-\alpha},
```

and the firm-loan collateral constraint

```math
(1+r_t^{bE})b_t^E \le m_t^E E_t[q_{t+1}^k\pi_{t+1}(1-\delta)k_t^E] .
```

### Banks

The wholesale bank chooses loans and deposits subject to the balance-sheet identity:

```math
B_t=D_t+K_t^b .
```

Given bank capital, the wholesale problem reduces to

```math
\max_{\{B_t,D_t\}} R_t^bB_t-R_t^dD_t-\frac{\kappa_{Kb}}{2}\left(\frac{K_t^b}{B_t}-\nu^b\right)^2K_t^b .
```

Retail loan branches choose household and entrepreneur lending rates subject to CES loan demand and quadratic rate-adjustment costs. The retail deposit branch chooses the deposit rate subject to CES deposit demand and a quadratic rate-adjustment cost.

### Capital Producers, Retailers, and Unions

Capital producers transform final goods into effective capital with investment adjustment costs. Retailers set differentiated goods prices subject to Rotemberg-style adjustment costs and indexation. Patient and impatient unions set differentiated wages subject to wage adjustment costs and indexation.

## 3. First-Order Conditions

- **(F1) Patient marginal utility of consumption**:

```math
\lambda_t^P=(1-a^P)\varepsilon_t^z(c_t^P-a^P c_{t-1}^P)^{-1}.
```

- **(F2) Patient deposit Euler equation**:

```math
\lambda_t^P=\beta_P E_t\left[\lambda_{t+1}^P\frac{1+r_t^d}{\pi_{t+1}}\right].
```

- **(F3) Patient housing demand**:

```math
\frac{\varepsilon_t^h}{h_t^P}-\lambda_t^P q_t^h+\beta_P E_t[\lambda_{t+1}^P q_{t+1}^h]=0.
```

- **(F4) Impatient borrowing Euler wedge**:

```math
\lambda_t^I-\beta_I E_t\left[\lambda_{t+1}^I\frac{1+r_t^{bH}}{\pi_{t+1}}\right]=s_t^I(1+r_t^{bH}).
```

- **(F5) Impatient housing demand with collateral value**:

```math
\frac{\varepsilon_t^h}{h_t^I}-\lambda_t^I q_t^h+\beta_I E_t[\lambda_{t+1}^I q_{t+1}^h]+s_t^I m_t^I E_t[q_{t+1}^h\pi_{t+1}]=0.
```

- **(F6) Entrepreneur capital demand**:

```math
\lambda_t^E q_t^k=s_t^E m_t^E E_t[q_{t+1}^k\pi_{t+1}(1-\delta)]
+\beta_E E_t\left[\lambda_{t+1}^E\left(q_{t+1}^k(1-\delta)+r_{t+1}^k u_{t+1}-\psi(u_{t+1})\right)\right].
```

- **(F7) Entrepreneur credit demand wedge**:

```math
\lambda_t^E-s_t^E(1+r_t^{bE})
=\beta_E E_t\left[\lambda_{t+1}^E\frac{1+r_t^{bE}}{\pi_{t+1}}\right].
```

- **(F8) Capital utilization**:

```math
r_t^k=\psi'(u_t),\qquad \psi(u_t)=\xi_1(u_t-1)+\frac{\xi_2}{2}(u_t-1)^2 .
```

- **(F9) Labor demand by entrepreneurs**:

```math
w_t^P=\mu(1-\alpha)\frac{y_t^E}{x_t l_t^{E,P}},
\qquad
w_t^I=(1-\mu)(1-\alpha)\frac{y_t^E}{x_t l_t^{E,I}}.
```

- **(F10) Wholesale bank spread and leverage condition**:

```math
S_t^W\equiv R_t^b-r_t=-\kappa_{Kb}\left(\frac{K_t^b}{B_t}-\nu^b\right)\left(\frac{K_t^b}{B_t}\right)^2 .
```

- **(F11) Sticky retail loan-rate setting** for borrower type $`s\in\{H,E\}`$:

```math
\begin{aligned}
0=&1-\varepsilon_t^{bs}+\varepsilon_t^{bs}\frac{R_t^b}{r_t^{bs}}
-\kappa_{bs}\left(\frac{r_t^{bs}}{r_{t-1}^{bs}}-1\right)\frac{r_t^{bs}}{r_{t-1}^{bs}}\\
&+\beta_P E_t\left[\frac{\lambda_{t+1}^P}{\lambda_t^P}\kappa_{bs}
\left(\frac{r_{t+1}^{bs}}{r_t^{bs}}-1\right)
\left(\frac{r_{t+1}^{bs}}{r_t^{bs}}\right)^2
\frac{b_{t+1}^s}{b_t^s}\right].
\end{aligned}
```

- **(F12) Sticky deposit-rate setting**:

```math
\begin{aligned}
0=&-1+\varepsilon_t^d-\varepsilon_t^d\frac{r_t}{r_t^d}
-\kappa_d\left(\frac{r_t^d}{r_{t-1}^d}-1\right)\frac{r_t^d}{r_{t-1}^d}\\
&+\beta_P E_t\left[\frac{\lambda_{t+1}^P}{\lambda_t^P}\kappa_d
\left(\frac{r_{t+1}^d}{r_t^d}-1\right)
\left(\frac{r_{t+1}^d}{r_t^d}\right)^2
\frac{d_{t+1}}{d_t}\right].
\end{aligned}
```

- **(F13) Capital accumulation and Tobin's $`q`$**:

```math
k_t=(1-\delta)k_{t-1}+\left[1-\frac{\kappa_i}{2}\left(\frac{i_t\varepsilon_t^{qk}}{i_{t-1}}-1\right)^2\right]i_t ,
```

with the associated $`q_t^k`$ FOC from the capital producer. The OCR/source equation should be formula-checked before review promotion: `needs_review`.

- **(F14) Price and wage Phillips curves**:

```math
\text{Rotemberg price FOC and two wage-union FOCs with indexation to lagged and steady-state inflation.}
```

The paper and implementation both include these blocks, but exact coefficient normalization requires source-level formula review: `needs_review`.

## 4. Market Clearing & Identities

- **(F15) Household collateral constraint**:

```math
(1+r_t^{bH})b_t^I=m_t^I E_t[q_{t+1}^h h_t^I\pi_{t+1}].
```

- **(F16) Entrepreneur collateral constraint**:

```math
(1+r_t^{bE})b_t^E=m_t^E E_t[q_{t+1}^k\pi_{t+1}(1-\delta)k_t^E].
```

- **(F17) Bank balance sheet and bank capital accumulation**:

```math
B_t=B_t^H+B_t^E=D_t+K_t^b,\qquad
\pi_tK_t^b=(1-\delta^b)K_{t-1}^b+j_{t-1}^b .
```

- **(F18) Bank profits**:

```math
j_t^b=r_t^{bH}b_t^H+r_t^{bE}b_t^E-r_t^d d_t
-\frac{\kappa_{Kb}}{2}\left(\frac{K_t^b}{B_t}-\nu^b\right)^2K_t^b-Adj_t^B .
```

- **(F19) Aggregate quantities**:

```math
C_t=c_t^P+c_t^I+c_t^E,\qquad
B_t^H=b_t^I,\qquad B_t^E=b_t^E,\qquad D_t=d_t^P .
```

- **(F20) Labor, housing, and capital aggregation**:

```math
l_t^{E,P}=l_t^P,\qquad l_t^{E,I}=l_t^I,\qquad
\bar h=h_t^P+h_t^I,\qquad K_t=k_t^E .
```

- **(F21) Goods-market resource constraint**:

```math
y_t=c_t+q_t^k[k_t-(1-\delta)k_{t-1}]+k_{t-1}\psi(u_t)+\delta^b\frac{K_{t-1}^b}{\pi_t}+Adj_t .
```

- **(F22) Monetary policy rule**:

```math
(1+r_t)=(1+r)^{1-\phi_R}(1+r_{t-1})^{\phi_R}
\left(\frac{\pi_t}{\pi}\right)^{\phi_\pi(1-\phi_R)}
\left(\frac{y_t}{y_{t-1}}\right)^{\phi_y(1-\phi_R)}
\varepsilon_t^r .
```

## 5. Exogenous Processes

The paper states a generic AR(1) form for persistent shocks:

- **(F23) Generic persistent process**:

```math
\varepsilon_t=(1-\rho_\varepsilon)\bar{\varepsilon}+\rho_\varepsilon\varepsilon_{t-1}+\eta_t^\varepsilon .
```

The implementation cross-check confirms 13 innovations: consumption preference, technology, housing preference, household LTV, entrepreneur LTV, deposit markdown, household-loan markup, firm-loan markup, investment efficiency, monetary policy, price markup, wage markup, and bank-capital/balance-sheet shock.

## 6. Steady-State Solution

The paper estimates a log-linearized model around the deterministic steady state. First-pass steady-state anchors from the source include:

- **(F24) Discount and rate anchors**:

```math
\beta_P=0.9943,\qquad \beta_I=\beta_E=0.975,\qquad \pi=1.
```

- **(F25) Collateral and banking anchors**:

```math
m^I=0.7,\qquad m^E=0.35,\qquad \nu^b=0.09 .
```

- **(F26) Production and depreciation anchors**:

```math
\alpha=0.25,\qquad \delta=0.025,\qquad \phi=1.
```

- **(F27) Markup/markdown anchors**:

```math
\varepsilon^d=-1.46,\qquad \varepsilon^{bH}\approx 2.79,\qquad \varepsilon^{bE}\approx 3.12,\qquad
\varepsilon^y=6,\qquad \varepsilon^l=5 .
```

The full nonlinear steady-state recursion is not source-level verified in this first-pass archive entry. Runtime validation was not performed.

## 7. Timing & Form Conventions

- The model is log-linearized around the steady state in the paper.
- Loans and deposits are one-period instruments. Repayment of last-period debt and deposits is indexed by current inflation.
- Housing chosen at date $`t`$ collateralizes impatient-household debt through expected next-period real housing value.
- Entrepreneur capital $`k_t^E`$ is chosen at date $`t`$ and becomes collateral through expected next-period capital value net of depreciation.
- Bank capital $`K_t^b`$ is predetermined in the balance sheet and evolves from retained bank profits.
- In the MMB implementation cross-check, model variables are often stored as logs and equations are written in `exp(...)` form; this is an implementation convention, not independent source evidence.

## 8. Variable & Parameter Reference Table

| Category | Symbol / implementation name | Meaning | Main equation(s) |
|---|---|---|---|
| Endogenous | $`c^P,c^I,c^E`$ / `c_p,c_i,c_e` | Consumption by patient households, impatient households, entrepreneurs | (F1), (F4), (F7), (F19) |
| Endogenous | $`h^P,h^I`$ / `h_p,h_i` | Housing stocks | (F3), (F5), (F15), (F20) |
| Endogenous | $`d^P,D`$ / `d_p,D,d_b` | Deposits | (F2), (F12), (F17), (F19) |
| Endogenous | $`b^I,b^E,B^H,B^E,B`$ / `b_i,b_ee,BH,BE,B` | Household and firm loans | (F4), (F7), (F15), (F16), (F17) |
| Endogenous | $`k^E,K,q^k,u,r^k`$ / `k_e,K,q_k,u,r_k` | Capital, Tobin's q, utilization, rental rate | (F6), (F8), (F13), (F20), (F21) |
| Endogenous | $`l^P,l^I,l^{E,P},l^{E,I}`$ / `l_p,l_i,l_pd,l_id` | Labor supply and demand | (F9), (F14), (F20) |
| Endogenous | $`w^P,w^I,\pi^{wP},\pi^{wI}`$ / `w_p,w_i,pie_wp,pie_wi` | Wages and wage inflation | (F9), (F14) |
| Endogenous | $`r^d,r^{bH},r^{bE},R^b,r`$ / `r_d,r_bh,r_be,R_b,r_ib` | Deposit, loan, wholesale, and policy rates | (F10), (F11), (F12), (F22) |
| Endogenous | $`K^b,j^b`$ / `K_b,j_B` | Bank capital and bank profits | (F17), (F18) |
| Endogenous | $`y^E,Y,C,x,\pi`$ / `y_e,Y,C,x,pie` | Production, output, aggregate consumption, markup, inflation | (F14), (F19), (F21), (F22) |
| Exogenous | `e_z,e_A_e,e_j,e_mi,e_me,e_mk_d,e_mk_bh,e_mk_be,e_qk,e_r_ib,e_y,e_l,e_eps_K_b` | Innovations to preferences, technology, collateral, spreads, investment, policy, markups, and bank capital | (F23) |
| Parameters | $`\beta_P,\beta_I,\beta_E,\alpha,\delta,\phi,\mu`$ | Preferences and technology | (F1)-(F9), (F24), (F26) |
| Parameters | $`m^I,m^E,\nu^b,\delta^b,\kappa_{Kb}`$ | Collateral and bank capital parameters | (F10), (F15)-(F18), (F25) |
| Parameters | $`\kappa_i,\kappa_d,\kappa_{bH},\kappa_{bE},\kappa_p,\kappa_w`$ | Adjustment costs | (F11)-(F14), (F21) |
| Parameters | $`\varepsilon^d,\varepsilon^{bH},\varepsilon^{bE},\varepsilon^y,\varepsilon^l`$ | Banking, goods, and labor elasticities | (F11), (F12), (F14), (F27) |
| Parameters | $`\rho_\cdot,\sigma_\cdot`$ | Shock persistence and standard deviations | (F23) |
