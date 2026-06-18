# EA_SW03 -- Derivation (optimization problems + first-order conditions)

> First-pass private archive extraction. Formula status: `needs_review` where noted. Runtime validation was not performed.

Source: Frank Smets and Rafael Wouters (2003), "An estimated dynamic stochastic general equilibrium model of the euro area", Journal of the European Economic Association, 1(5), 1123-1175. DOI: `10.1162/154247603770383415`.

## 1. Model Overview

- **Model**: `EA_SW03`, an estimated medium-scale euro-area DSGE model with sticky prices, sticky wages, external habit formation, investment adjustment costs, variable capital utilization, monopolistic competition, and a generalized Taylor-type monetary policy rule.
- **Economy**: closed euro area model estimated on GDP, consumption, investment, prices, real wages, employment, and the nominal short-term interest rate.
- **Agents and blocks**: differentiated households supply monopolistic labor, consume, save, rent capital services, choose investment and utilization; final-good firms aggregate intermediate goods; intermediate firms rent capital and labor and set Calvo prices with partial indexation; the monetary authority sets the short nominal rate; government spending is exogenous.
- **Shocks**: technology, labor supply, preference/discount-factor, investment adjustment cost, government spending, price markup, wage markup, equity/risk-premium, persistent inflation objective, and temporary monetary policy shocks.
- **Form**: paper-side structural setup is nonlinear, but the estimated model is explicitly summarized as log-linear deviations around the nonstochastic steady state. The MMB implementation cross-check uses `model(linear)`. This archive entry records both the structural source equations and the linearized estimating system; first-pass formula quality is `needs_review`.

## 2. Optimization Problems

### Households

Each household type \(\tau\) chooses consumption, bond holdings, wage-setting when allowed, capital accumulation, and utilization:

\[
\max E_0\sum_{t=0}^{\infty}\beta^t U_t^\tau
\]

\[
U_t^\tau=\varepsilon_t^b\left[
\frac{(C_t^\tau-H_t)^{1-\sigma_c}}{1-\sigma_c}
-\frac{\varepsilon_t^L(\ell_t^\tau)^{1+\sigma_l}}{1+\sigma_l}
\right]
\]

subject to the budget constraint

\[
b_t\frac{B_t^\tau}{P_t}
=\frac{B_{t-1}^\tau}{P_t}+Y_t^\tau-C_t^\tau-I_t^\tau
\]

and income

\[
Y_t^\tau=(w_t^\tau l_t^\tau+A_t^\tau)
+\left(r_t^k z_t^\tau K_{t-1}^\tau-\Psi(z_t^\tau)K_{t-1}^\tau\right)
+Div_t^\tau.
\]

External habit is

\[
H_t=hC_{t-1}.
\]

When a household can reoptimize its nominal wage, it chooses \(\tilde W_t^\tau\) subject to labor demand and Calvo non-reoptimization risk. Non-reoptimized wages are partially indexed to lagged inflation:

\[
W_t^\tau=\left(\frac{P_{t-1}}{P_{t-2}}\right)^{\gamma_w}W_{t-1}^\tau.
\]

The household also chooses investment and utilization subject to capital accumulation:

\[
K_t=(1-\tau)K_{t-1}
+\left[1-S\left(\frac{\varepsilon_t^I I_t}{I_{t-1}}\right)\right]I_t.
\]

### Final-good firms

Perfectly competitive final-good producers aggregate differentiated intermediate goods:

\[
Y_t=\left[\int_0^1(y_t^j)^{1/(1+\lambda_{p,t})}dj\right]^{1+\lambda_{p,t}}.
\]

### Intermediate-good firms

Intermediate firm \(j\) produces

\[
y_t^j=\varepsilon_t^a\tilde K_{j,t}^{\alpha}L_{j,t}^{1-\alpha}-\Phi,
\qquad \tilde K_{j,t}=z_tK_{j,t-1}.
\]

It minimizes cost given \(W_t\) and \(r_t^k\), then sets prices under Calvo pricing with partial indexation. The reoptimized price \(\tilde p_t^j\) maximizes the expected discounted value of future profits while the price cannot be reset.

### Monetary authority and government

The monetary authority follows a generalized Taylor-type reaction function. Government spending is exogenous and enters the resource constraint.

## 3. First-Order Conditions

- **(F1) Consumption Euler equation**:

\[
E_t\left[\beta\frac{\lambda_{t+1}}{\lambda_t}\frac{R_tP_t}{P_{t+1}}\right]=1.
\]

- **(F2) Marginal utility of consumption**:

\[
\lambda_t=\varepsilon_t^b(C_t-H_t)^{-\sigma_c}.
\]

- **(F3) Wage indexation and wage-setting condition**:

\[
W_t^\tau=\left(\frac{P_{t-1}}{P_{t-2}}\right)^{\gamma_w}W_{t-1}^\tau,
\]

\[
\frac{\tilde w_t}{P_t}E_t\sum_{i=0}^{\infty}\beta^i\xi_w^i
\left(\frac{(P_t/P_{t-1})^{\gamma_w}}{P_{t+i}/P_{t+i-1}}\right)
\frac{l_{t+i}^\tau U_{t+i}^C}{1+\lambda_{w,t+i}}
=E_t\sum_{i=0}^{\infty}\beta^i\xi_w^i l_{t+i}^\tau U_{t+i}^{\ell}.
\]

- **(F4) Aggregate wage index law of motion**:

\[
W_t^{-1/\lambda_{w,t}}
=\xi_w\left(W_{t-1}\left(\frac{P_{t-1}}{P_{t-2}}\right)^{\gamma_w}\right)^{-1/\lambda_{w,t}}
+(1-\xi_w)(\tilde w_t)^{-1/\lambda_{w,t}}.
\]

- **(F5) Installed capital value**:

\[
Q_t=E_t\left[\beta\frac{\lambda_{t+1}}{\lambda_t}
\left(Q_{t+1}(1-\tau)+z_{t+1}r_{t+1}^k-\Psi(z_{t+1})\right)\right].
\]

- **(F6) Investment adjustment-cost FOC** (`needs_review`: OCR split across display lines):

\[
Q_t S'\left(\frac{\varepsilon_t^I I_t}{I_{t-1}}\right)
\frac{\varepsilon_t^I I_t}{I_{t-1}}
-\beta E_t Q_{t+1}\frac{\lambda_{t+1}}{\lambda_t}
S'\left(\frac{\varepsilon_{t+1}^I I_{t+1}}{I_t}\right)
\left(\frac{\varepsilon_{t+1}^I I_{t+1}}{I_t}\right)\frac{I_{t+1}}{I_t}
+1
=Q_t\left[1-S\left(\frac{\varepsilon_t^I I_t}{I_{t-1}}\right)\right].
\]

- **(F7) Capital utilization FOC**:

\[
r_t^k=\Psi'(z_t).
\]

- **(F8) Cost minimization factor condition**:

\[
\frac{W_tL_{j,t}}{r_t^k\tilde K_{j,t}}=\frac{1-\alpha}{\alpha}.
\]

- **(F9) Real marginal cost**:

\[
MC_t=\frac{1}{\varepsilon_t^a}W_t^{1-\alpha}(r_t^k)^\alpha
\alpha^{-\alpha}(1-\alpha)^{-(1-\alpha)}.
\]

- **(F10) Price-setting FOC**:

\[
E_t\sum_{i=0}^{\infty}\beta^i\xi_p^i\lambda_{t+i}y_{t+i}^j
\left[
\frac{\tilde p_t^j}{P_t}
\left(\frac{(P_{t-1+i}/P_{t-1})^{\gamma_p}}{P_{t+i}/P_t}\right)
-(1+\lambda_{p,t+i})mc_{t+i}
\right]=0.
\]

- **(F11) Price index law of motion**:

\[
P_t^{-1/\lambda_{p,t}}
=\xi_p\left(P_{t-1}\left(\frac{P_{t-1}}{P_{t-2}}\right)^{\gamma_p}\right)^{-1/\lambda_{p,t}}
+(1-\xi_p)(\tilde p_t^j)^{-1/\lambda_{p,t}}.
\]

The paper then linearizes the system. The following equations are the estimating form.

- **(F12) Linearized consumption equation**:

\[
\hat C_t=\frac{h}{1+h}\hat C_{t-1}
+\frac{1}{1+h}E_t\hat C_{t+1}
-\frac{1-h}{(1+h)\sigma_c}(\hat R_t-E_t\hat\pi_{t+1})
+\frac{1-h}{(1+h)\sigma_c}(\hat\varepsilon_t^b-E_t\hat\varepsilon_{t+1}^b).
\]

- **(F13) Linearized investment equation**:

\[
\hat I_t=\frac{1}{1+\beta}\hat I_{t-1}
+\frac{\beta}{1+\beta}E_t\hat I_{t+1}
+\frac{\varphi}{1+\beta}\hat Q_t
-\frac{\beta E_t\hat\varepsilon_{t+1}^I-\hat\varepsilon_t^I}{1+\beta}.
\]

- **(F14) Linearized Q equation**:

\[
\hat Q_t=-(\hat R_t-\hat\pi_{t+1})
+\frac{1-\tau}{1-\tau+\bar r^k}E_t\hat Q_{t+1}
+\frac{\bar r^k}{1-\tau+\bar r^k}E_t\hat r_{t+1}^k+\eta_t^Q.
\]

- **(F15) Linearized capital accumulation**:

\[
\hat K_t=(1-\tau)\hat K_{t-1}+\tau\hat I_{t-1}.
\]

- **(F16) Linearized inflation equation**:

\[
\hat\pi_t=\frac{\beta}{1+\beta\gamma_p}E_t\hat\pi_{t+1}
+\frac{\gamma_p}{1+\beta\gamma_p}\hat\pi_{t-1}
+\frac{1}{1+\beta\gamma_p}\frac{(1-\beta\xi_p)(1-\xi_p)}{\xi_p}
\left[\alpha\hat r_t^k+(1-\alpha)\hat w_t-\hat\varepsilon_t^a+\eta_t^p\right].
\]

- **(F17) Linearized real wage equation**:

\[
\begin{aligned}
\hat w_t={}&\frac{\beta}{1+\beta}E_t\hat w_{t+1}
+\frac{1}{1+\beta}\hat w_{t-1}
+\frac{\beta}{1+\beta}E_t\hat\pi_{t+1}
-\frac{1+\beta\gamma_w}{1+\beta}\hat\pi_t
+\frac{\gamma_w}{1+\beta}\hat\pi_{t-1} \\
&-\frac{1}{1+\beta}
\frac{(1-\beta\xi_w)(1-\xi_w)}
{\left(1+\frac{(1+\lambda_w)\sigma_L}{\lambda_w}\right)\xi_w}
\left[
\hat w_t-\sigma_L\hat L_t
-\frac{\sigma_c}{1-h}(\hat C_t-h\hat C_{t-1})
-\hat\varepsilon_t^L-\eta_t^w
\right].
\end{aligned}
\]

- **(F18) Labor demand / marginal-cost equalization**:

\[
\hat L_t=-\hat w_t+(1+\psi)\hat r_t^k+\hat K_{t-1}.
\]

## 4. Market Clearing & Identities

- **(F19) Goods market equilibrium and production identity**:

\[
\hat Y_t=(1-\tau k_y-g_y)\hat C_t+\tau k_y\hat I_t+g_y\varepsilon_t^G
=\phi\hat\varepsilon_t^a+\phi\alpha\hat K_{t-1}
+\phi\alpha\psi\hat r_t^k+\phi(1-\alpha)\hat L_t.
\]

- **(F20) Employment adjustment auxiliary equation**:

\[
\hat E_t=\beta\hat E_{t+1}
+\frac{(1-\beta\xi_e)(1-\xi_e)}{\xi_e}(\hat L_t-\hat E_t).
\]

- **(F21) Monetary policy reaction function**:

\[
\begin{aligned}
\hat R_t={}&\rho\hat R_{t-1}
+(1-\rho)\left\{\bar\pi_t
+r_\pi(\hat\pi_{t-1}-\bar\pi_t)
+r_Y(\hat Y_t-\hat Y_t^p)\right\}\\
&+r_{\Delta\pi}(\hat\pi_t-\hat\pi_{t-1})
+r_{\Delta y}\left[(\hat Y_t-\hat Y_t^p)
-(\hat Y_{t-1}-\hat Y_{t-1}^p)\right]
+\eta_t^R.
\end{aligned}
\]

## 5. Exogenous Processes

The source states that the persistent technology/preference shocks follow independent first-order autoregressive processes and that cost-push shocks plus the temporary monetary policy shock are i.i.d. In first-pass notation:

\[
\hat\varepsilon_t^a=\rho_a\hat\varepsilon_{t-1}^a+\eta_t^a,\quad
\hat\varepsilon_t^b=\rho_b\hat\varepsilon_{t-1}^b+\eta_t^b,\quad
\hat\varepsilon_t^L=\rho_L\hat\varepsilon_{t-1}^L+\eta_t^L.
\]

\[
\hat\varepsilon_t^I=\rho_I\hat\varepsilon_{t-1}^I+\eta_t^I,\quad
\varepsilon_t^G=\rho_G\varepsilon_{t-1}^G+\eta_t^G,\quad
\bar\pi_t=\rho_\pi\bar\pi_{t-1}+\eta_t^\pi.
\]

\[
\eta_t^p,\quad \eta_t^w,\quad \eta_t^Q,\quad \eta_t^R
\quad\text{are white-noise shocks in the paper's estimating system.}
\]

Implementation cross-check: `EA_SW03_rep.mod` includes AR(1) states for `a`, `as`, `b`, `g`, `ls`, `qs`, and an MMB policy shock replacement `interest_`; it also keeps additional MMB bookkeeping shocks and variables. These are recorded as `implementation_cross_check`, not paper-side derivation.

## 6. Steady-State Solution

The paper linearizes around a nonstochastic steady state; hatted variables are log deviations from that steady state. Hence the operational steady state for the linearized archive entry is:

\[
\hat C=\hat I=\hat Q=\hat K=\hat\pi=\hat w=\hat R=\hat r^k=\hat L=\hat Y=\hat E=0.
\]

Selected calibrated or fixed steady-state relationships reported in the source:

\[
\beta=0.99,\qquad \tau=0.025,\qquad \alpha=0.30,\qquad C/Y=0.60,\qquad I/Y=0.22.
\]

The steady-state capital-output ratio is about \(2.2\) from \(I/Y=0.22\) and \(\tau=0.025\) at quarterly frequency. The source also sets the wage markup parameter to \(\lambda_w=0.5\) because it is not identified. Full nonlinear steady-state reconstruction is deferred and marked `needs_review` because this first-pass entry does not solve the level system from the source PDF.

## 7. Timing & Form Conventions

- **Capital timing**: \(K_t\) is installed through investment and appears in production with lagged installed capital; the paper's linearized accumulation equation uses \(\hat I_{t-1}\) in (F15), and the MMB implementation uses `kp(-1)`/`kpf(-1)` in capital-service definitions.
- **Utilization**: capital services are \(\tilde K_{j,t}=z_tK_{j,t-1}\); utilization responds to the rental rate through (F7).
- **Nominal rigidities**: Calvo wage and price probabilities are \(\xi_w\) and \(\xi_p`; non-reoptimized wages and prices are partially indexed to lagged inflation through \)\gamma_w\( and \)\gamma_p`.
- **Form**: estimating equations are linearized log deviations around the nonstochastic steady state; the implementation cross-check confirms `model(linear)`.
- **Potential output**: the policy rule uses the output gap relative to potential output, defined by the flexible price-and-wage model excluding the markup shocks.
- **Runtime validation**: not performed by assignment.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Main source equation |
|---|---|---|---|
| Endogenous | `c`, \(\hat C_t\) | consumption | (F12) |
| Endogenous | `inve`, \(\hat I_t\) | investment | (F13) |
| Endogenous | `pk`, \(\hat Q_t\) | real value of installed capital / Tobin Q | (F14) |
| Endogenous | `kp`, \(\hat K_t\) | installed capital stock | (F15) |
| Endogenous | `pinf`, \(\hat\pi_t\) | inflation | (F16) |
| Endogenous | `w`, \(\hat w_t\) | real wage | (F17) |
| Endogenous | `r`, \(\hat R_t\) | nominal short rate in linearized rule / MMB quarterly interest | (F21) |
| Endogenous | `rk`, \(\hat r_t^k\) | rental rate of capital | (F18), (F14) |
| Endogenous | `lab`, \(\hat L_t\) | labor input | (F18) |
| Endogenous | `y`, \(\hat Y_t\) | output | (F19) |
| Endogenous | `empl`, \(\hat E_t\) | employment auxiliary variable | (F20) |
| Endogenous | `mc`, `mcf` | marginal cost, cross-checked in implementation | (F9), (F16) |
| Exogenous | \(\eta_t^a\), `ea` | productivity innovation | Section 5 |
| Exogenous | \(\eta_t^b\), `eb` | preference/discount innovation | Section 5 |
| Exogenous | \(\eta_t^L\), `els` | labor supply innovation | Section 5 |
| Exogenous | \(\eta_t^I\), `eqs` / investment shock proxy | investment-adjustment innovation | Section 5 |
| Exogenous | \(\eta_t^G\), `fiscal_` / `g` innovation | government spending innovation | Section 5 |
| Exogenous | \(\eta_t^p\), `epinf` / `ps` | price markup shock | Section 5 |
| Exogenous | \(\eta_t^w\), `ew` / `sw` | wage markup shock | Section 5 |
| Exogenous | \(\eta_t^Q\), `eqs` | equity/risk-premium shock | (F14), Section 5 |
| Exogenous | \(\eta_t^\pi\), `eas` | inflation objective innovation | Section 5 |
| Exogenous | \(\eta_t^R\), `interest_` / `em` | temporary monetary policy innovation | (F21), Section 5 |
| Parameter | \(\beta\) / `cbeta` | discount factor | Section 6 |
| Parameter | \(\tau\) / `ctou` | depreciation rate | Section 6 |
| Parameter | \(\alpha\) / `calfa` | capital share | (F8), (F9) |
| Parameter | \(h\) / `chabb` | external habit | (F12) |
| Parameter | \(\sigma_c\) / `csigma` | inverse intertemporal elasticity | (F12) |
| Parameter | \(\sigma_L\) / `csigl` | inverse labor supply elasticity | (F17) |
| Parameter | \(\xi_p,\xi_w\) / `cprobp,cprobw` | Calvo price and wage probabilities | (F16), (F17) |
| Parameter | \(\gamma_p,\gamma_w\) / `cindp,cindw` | price and wage indexation | (F16), (F17) |
| Parameter | \(\rho, r_\pi, r_Y, r_{\Delta\pi}, r_{\Delta y}\) / `crr, crpi, cry, crdpi, crdy` | policy rule coefficients | (F21) |
| Parameter | \(\rho_a,\rho_b,\rho_L,\rho_I,\rho_G,\rho_\pi\) | persistence parameters | Section 5 |

Equation-count note: (F1)-(F21) are archive equation labels, not a guarantee of one-to-one Dynare equation parity for the full MMB implementation. The paper explicitly says equations (28)-(36) determine nine core endogenous variables; the implementation adds flexible-price blocks, employment adjustment, MMB reporting variables, and policy-rule variants.
