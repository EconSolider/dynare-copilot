# NK_MM10 -- Derivation (Optimization Problems + Equilibrium Conditions)

> Model archive entry for `NK_MM10`. Status: `needs_review`. Runtime validation was not performed; Dynare was not run.

Source: Cesaire A. Meh and Kevin Moran (2010), "The role of bank capital in the propagation of shocks," *Journal of Economic Dynamics and Control* 34(3), 555-576. DOI: `10.1016/j.jedc.2009.10.009`.

## 1. Model Overview

- **Model**: `NK_MM10`, a medium-scale New Keynesian DSGE model with bank capital, entrepreneurial net worth, double moral hazard in capital-good production, sticky prices, sticky wages, habit formation, money/deposits, variable capital utilization, and a Taylor-style monetary policy rule.
- **Agents and blocks**: households, entrepreneurs, bankers, intermediate-good firms, final-good firms, labor aggregators, and a monetary authority.
- **Financial friction**: entrepreneurs need outside finance to run capital-good projects. Banks monitor entrepreneurs, but monitoring is costly and not publicly observable. Bank capital therefore mitigates moral hazard between banks and households who supply deposits.
- **Shocks**: aggregate technology, monetary policy, and an exogenous shock to bank capital through accelerated depreciation of bank assets.
- **Form**: the paper states nonlinear equilibrium conditions and says the dynamics are solved by linearizing around the deterministic steady state. The MMB implementation cross-check is a nonlinear Dynare `model` solved at first order, not `model(linear)`.
- **Source quality**: the MinerU Markdown has readable core equations, but several superscripts/subscripts in equations (4), (7)-(10), (13), (27), and the wage-setting expression contain OCR artifacts. Those formulas are marked `needs_review` where used.

## 2. Optimization Problems

### 2.1 Final-Good Firms

Competitive final-good firms aggregate differentiated intermediate goods:

\[
Y_t=\left(\int_0^1 y_{jt}^{(\xi_p-1)/\xi_p}\,dj\right)^{\xi_p/(\xi_p-1)},\qquad \xi_p>1.
\]

### 2.2 Intermediate-Good Firms

Intermediate-good firm \(j\) minimizes production cost subject to a fixed-cost production technology:

\[
\min_{\{k_{jt},h_{jt},h^e_{jt},h^b_{jt}\}}
r_t k_{jt}+w_t h_{jt}+w^e_t h^e_{jt}+w^b_t h^b_{jt}
\]

subject to:

\[
y_{jt}=z_t k_{jt}^{\theta_k}h_{jt}^{\theta_h}(h^e_{jt})^{\theta_e}(h^b_{jt})^{\theta_b}-\Theta.
\]

Firms are monopolistically competitive and face Calvo-style price setting with indexation to lagged aggregate inflation.

### 2.3 Financial Contract Between Entrepreneurs, Banks, and Households

An entrepreneur with net worth \(n_t\) seeks project size \(i_t>n_t\). A bank contributes own net worth \(a_t\) and raises household deposits \(d_t\). The contract chooses:

\[
\max_{\{i_t,a_t,d_t,R^e_t,R^b_t,R^h_t\}}
q_t\alpha^g R^e_t i_t
\]

subject to entrepreneur incentive compatibility, banker monitoring incentive compatibility, banker and household participation, financing feasibility, and return splitting:

\[
q_t\alpha^g R^e_t i_t \ge q_t\alpha^b R^e_t i_t+q_t b i_t,
\]

\[
q_t\alpha^g R^b_t i_t-\mu i_t \ge q_t\alpha^b R^b_t i_t,
\]

\[
q_t\alpha^g R^b_t i_t \ge (1+r^a_t)a_t,\qquad
q_t\alpha^g R^h_t i_t \ge (1+r^d_t)d_t,
\]

\[
a_t+d_t-\mu i_t \ge i_t-n_t,\qquad
R^e_t+R^b_t+R^h_t=R.
\]

### 2.4 Households

Households maximize expected utility with external habit, labor disutility, and real-currency services:

\[
E_0\sum_{t=0}^{\infty}\beta^t
U(c^h_t-\gamma c^h_{t-1},l_{it},M^c_t/P_t).
\]

They allocate money between deposits and currency, choose capital utilization, buy capital goods, supply differentiated labor, and face the budget constraint:

\[
c^h_t+q_t i^h_t+\frac{M_{t+1}}{P_t}
=(1+r^d_t)\frac{D_t}{P_t}+r_tu_tk^h_t-v(u_t)k^h_t
\frac{W_{it}}{P_t}l_{it}+\Pi_t+\frac{M^c_t}{P_t}.
\]

Household capital evolves as:

\[
k^h_{t+1}=(1-\delta)k^h_t+i^h_t.
\]

### 2.5 Wage Setters

Labor aggregators combine specialized household labor:

\[
H_t=\left(\int_0^{\eta^h}l_{it}^{(\xi_w-1)/\xi_w}\,di\right)^{\xi_w/(\xi_w-1)}.
\]

Households reoptimize nominal wages with probability \(1-\phi_w\) and otherwise index their wage to lagged inflation.

### 2.6 Entrepreneurs and Bankers

Entrepreneurs and bankers are risk neutral. Fractions \(1-\tau^e\) and \(1-\tau^b\) exit each period. Surviving agents retain all returns as next-period assets; exiting agents consume accumulated wealth.

## 3. First-Order Conditions

The conditions below are the paper-side equilibrium conditions, normalized into a single continuous archive numbering. Items explicitly tagged `needs_review` require source-level formula checking against the PDF because the OCR contains visible math artifacts.

- **(F1) Final-good demand for intermediate variety**:

\[
y_{jt}=\left(\frac{p_{jt}}{P_t}\right)^{-\xi_p}Y_t.
\]

- **(F2) Final-good price index**:

\[
P_t=\left(\int_0^1 p_{jt}^{1-\xi_p}\,dj\right)^{1/(1-\xi_p)}.
\]

- **(F3) Intermediate-good production technology, needs_review for OCR superscripts**:

\[
y_{jt}=z_t k_{jt}^{\theta_k}h_{jt}^{\theta_h}(h^e_{jt})^{\theta_e}(h^b_{jt})^{\theta_b}-\Theta.
\]

- **(F4) Technology process**:

\[
\log z_t=\rho_z\log z_{t-1}+\varepsilon^z_t.
\]

- **(F5) Capital rental demand**:

\[
r_t=s_t z_t\theta_k k_{jt}^{\theta_k-1}h_{jt}^{\theta_h}(h^e_{jt})^{\theta_e}(h^b_{jt})^{\theta_b}.
\]

- **(F6) Household-labor demand**:

\[
w_t=s_t z_t\theta_h k_{jt}^{\theta_k}h_{jt}^{\theta_h-1}(h^e_{jt})^{\theta_e}(h^b_{jt})^{\theta_b}.
\]

- **(F7) Entrepreneur-labor demand, needs_review for OCR exponent placement**:

\[
w^e_t=s_t z_t\theta_e k_{jt}^{\theta_k}h_{jt}^{\theta_h}(h^e_{jt})^{\theta_e-1}(h^b_{jt})^{\theta_b}.
\]

- **(F8) Banker-labor demand**:

\[
w^b_t=s_t z_t\theta_b k_{jt}^{\theta_k}h_{jt}^{\theta_h}(h^e_{jt})^{\theta_e}(h^b_{jt})^{\theta_b-1}.
\]

- **(F9) Indexed price path for non-reoptimizing firms**:

\[
p_{j,t+k}=\left(\prod_{s=0}^{k-1}\pi_{t+s}\right)p_{jt}.
\]

- **(F10) Optimal reset price, needs_review for sign/markup convention in OCR**:

\[
\tilde p_t=
\frac{\xi_p}{\xi_p-1}
\frac{E_t\sum_{k=0}^{\infty}(\beta\phi_p)^k\lambda_{t+k}s_{t+k}Y_{t+k}\pi_{t+k}^{\xi_p}}
{E_t\sum_{k=0}^{\infty}(\beta\phi_p)^k\lambda_{t+k}Y_{t+k}\pi_{t+k}^{\xi_p-1}}.
\]

- **(F11) Entrepreneur incentive-compatible project share**:

\[
R^e_t=\frac{b}{\Delta\alpha},\qquad \Delta\alpha=\alpha^g-\alpha^b>0.
\]

- **(F12) Bank monitoring incentive-compatible project share**:

\[
R^b_t=\frac{\mu}{q_t\Delta\alpha}.
\]

- **(F13) Household depositor project share**:

\[
R^h_t=R-\frac{b}{\Delta\alpha}-\frac{\mu}{q_t\Delta\alpha}.
\]

- **(F14) Household participation in project finance**:

\[
(1+r^d_t)d_t=q_t\alpha^g
\left(R-\frac{b}{\Delta\alpha}-\frac{\mu}{q_t\Delta\alpha}\right)i_t.
\]

- **(F15) Financing-feasibility form of the contract**:

\[
(1+r^d_t)\left[(1+\mu)-\frac{a_t}{i_t}-\frac{n_t}{i_t}\right]
=q_t\alpha^g\left(R-\frac{b}{\Delta\alpha}-\frac{\mu}{\Delta\alpha q_t}\right).
\]

- **(F16) Project size / aggregate investment supply**:

\[
i_t=\frac{a_t+n_t}{G_t},\qquad
G_t=1+\mu-\frac{q_t\alpha^g}{1+r^d_t}
\left(R-\frac{b}{\Delta\alpha}-\frac{\mu}{\Delta\alpha q_t}\right)
\,\,\text{needs_review}.
\]

- **(F17) Capital-asset ratio, needs_review for OCR in denominator**:

\[
\kappa_t=\frac{a_t}{a_t+d_t}.
\]

- **(F18) Household marginal utility of wealth**:

\[
U_1(\cdot_t)-\beta\gamma E_tU_1(\cdot_{t+1})=\lambda_t.
\]

- **(F19) Currency/deposit margin**:

\[
U_3(\cdot_t)=r^d_t\lambda_t.
\]

- **(F20) Utilization FOC**:

\[
r_t=v'(u_t).
\]

- **(F21) Nominal deposit Euler equation**:

\[
\lambda_t=\beta E_t\left[\lambda_{t+1}(1+r^d_{t+1})\frac{P_t}{P_{t+1}}\right].
\]

- **(F22) Household capital Euler equation**:

\[
\lambda_t q_t=\beta E_t\left\{\lambda_{t+1}
\left[q_{t+1}(1-\delta)+r_{t+1}u_{t+1}-v(u_{t+1})\right]\right\}.
\]

- **(F23) Specialized labor demand**:

\[
l_{it}=\left(\frac{W_{it}}{W_t}\right)^{-\xi_w}H_t.
\]

- **(F24) Aggregate wage index**:

\[
W_t=\left(\int_0^{\eta^h}W_{it}^{1-\xi_w}\,di\right)^{1/(1-\xi_w)}.
\]

- **(F25) Optimal reset wage, needs_review for OCR and sign convention**:

\[
\tilde W_t=P_{t-1}\frac{\xi_w}{\xi_w-1}
\frac{E_t\sum_{k=0}^{\infty}(\beta\phi_w)^k U_2(\cdot_{t+k})H_{t+k}w_{t+k}^{\xi_w}\pi_{t+k}^{\xi_w}}
{E_t\sum_{k=0}^{\infty}(\beta\phi_w)^k\lambda_{t+k}w_{t+k}^{\xi_w}\pi_{t+k}^{\xi_w-1}}.
\]

- **(F26) Entrepreneur net worth**:

\[
n_t=[r_t+q_t(1-\delta)]k^e_t+w^e_t.
\]

- **(F27) Banker net worth**:

\[
a_t=[r_t+q_t(1-\delta)]k^b_t+w^b_t.
\]

- **(F28) Monetary policy rule**:

\[
r^d_t=(1-\rho_r)r^d+\rho_r r^d_{t-1}
+(1-\rho_r)\left[\rho_{\pi}(\pi_t-\bar\pi)+\rho_y\hat y_t\right]
+\varepsilon^{mp}_t.
\]

- **(F29) Aggregate investment from aggregate bank and entrepreneurial net worth**:

\[
I_t=\frac{A_t+N_t}{G_t}.
\]

- **(F30) Aggregate return on bank net worth**:

\[
1+r^a_t=\frac{q_t\alpha^g R^b_t I_t}{A_t}.
\]

- **(F31) Aggregate entrepreneurial net worth**:

\[
N_t=[r_t+q_t(1-\delta)]K^e_t+\eta^e w^e_t.
\]

- **(F32) Aggregate bank net worth**:

\[
A_t=[r_t+q_t(1-\delta)]K^b_t+\eta^b w^b_t.
\]

- **(F33) Entrepreneur capital holding law of motion**:

\[
K^e_{t+1}=\tau^e\alpha^g R^e_t I_t.
\]

- **(F34) Banker capital holding law of motion**:

\[
K^b_{t+1}=\tau^b\alpha^g R^b_t I_t.
\]

- **(F35) Entrepreneurial net-worth law of motion**:

\[
N_{t+1}=[r_{t+1}+q_{t+1}(1-\delta)]
\tau^e\alpha^g R^e_t\left(\frac{A_t+N_t}{G_t}\right)
+\eta^e w^e_{t+1}.
\]

- **(F36) Bank net-worth law of motion**:

\[
A_{t+1}=[r_{t+1}+q_{t+1}(1-\delta)]
\tau^b\alpha^g R^b_t\left(\frac{A_t+N_t}{G_t}\right)
+\eta^b w^b_{t+1}.
\]

- **(F37) Entrepreneur consumption**:

\[
C^e_t=(1-\tau^e)q_t\alpha^gR^e_tI_t.
\]

- **(F38) Banker consumption**:

\[
C^b_t=(1-\tau^b)q_t\alpha^gR^b_tI_t.
\]

- **(F39) Aggregate household consumption**:

\[
C^h_t=\eta^h c^h_t.
\]

- **(F40) Bank-capital shock variant**:

\[
A_t=[r_t+q_t(1-\delta x_t)]K^b_t+\eta^b w^b_t.
\]

## 4. Market Clearing & Identities

- **(F41) Total capital stock**:

\[
K_t=K^h_t+K^e_t+K^b_t.
\]

- **(F42) Capital services market clearing**:

\[
u_tK^h_t+K^e_t+K^b_t=\int_0^1 k_{jt}\,dj.
\]

- **(F43) Composite household labor market clearing**:

\[
H_t=\int_0^1 h_{jt}\,dj.
\]

- **(F44) Aggregate resource constraint**:

\[
Y_t=C^h_t+C^e_t+C^b_t+I_t+\mu I_t.
\]

- **(F45) Aggregate capital accumulation**:

\[
K_{t+1}=(1-\delta)K_t+\alpha^g R I_t.
\]

- **(F46) Deposit market clearing**:

\[
\eta^b d_t=\eta^h\frac{D_t}{P_t}.
\]

- **(F47) Money market clearing**:

\[
\bar M_t=\eta^h M_t.
\]

- **(F48) Aggregate output identity with fixed cost, needs_review for price-dispersion aggregation**:

\[
Y_t=z_t K_t^{\theta_k}H_t^{\theta_h}(\eta^e)^{\theta_e}(\eta^b)^{\theta_b}-\Theta.
\]

- **(F49) Bank capital adequacy ratio in aggregate implementation terms**:

\[
CA_t=\frac{A_t}{(1+\mu)I_t-N_t}.
\]

- **(F50) Aggregate bank lending**:

\[
TL_t=I_t-N_t.
\]

- **(F51) Aggregate consumption**:

\[
C_t=C^h_t+C^e_t+C^b_t.
\]

## 5. Exogenous Processes

- **(F52) Technology shock**:

\[
\log z_t=\rho_z\log z_{t-1}+\varepsilon^z_t.
\]

- **(F53) Monetary-policy disturbance**:

\[
\varepsilon^{mp}_t=\rho_{mp}\varepsilon^{mp}_{t-1}+u^{mp}_t.
\]

- **(F54) Bank-capital depreciation disturbance**:

\[
x_t=\rho_x x_{t-1}+u^x_t.
\]

The MMB implementation cross-check names the three innovations `z_shk`, `mp_shk`, and `bk_shk`, and writes their log state variables as `lz`, `lmp`, and `lbk`. That naming is implementation evidence only.

## 6. Steady-State Solution

The deterministic steady state is normalized around quarterly frequency with \(u=1\), \(z=1\), and constant gross inflation \(\bar\pi\). The paper calibrates the remaining financial-contract parameters to match selected steady-state ratios, and the MMB implementation computes those ratios explicitly.

1. Set exogenous steady states:

\[
\bar z=1,\qquad \bar x=0,\qquad \varepsilon^z=\varepsilon^{mp}=u^x=0.
\]

2. Household intertemporal pricing gives:

\[
1+\bar r^d=\frac{\bar\pi}{\beta}.
\]

3. Utilization is normalized at \(\bar u=1\) and the utilization-cost function is calibrated so that:

\[
\bar r=v'(1).
\]

4. Production-side calibration sets the steady-state markup:

\[
\bar s=\frac{1}{\text{gross price markup}},\qquad
\bar Y=\bar z\,\bar K^{\theta_k}\bar H^{\theta_h}(\eta^e)^{\theta_e}(\eta^b)^{\theta_b}-\Theta.
\]

5. The financial contract sets project scale and leverage from:

\[
\bar I=\frac{\bar A+\bar N}{\bar G},\qquad
\bar G=1+\mu-\frac{\bar q\alpha^g}{1+\bar r^d}
\left(R-\frac{b}{\Delta\alpha}-\frac{\mu}{\Delta\alpha\bar q}\right)
\,\,\text{needs_review}.
\]

6. Baseline calibration targets include:

\[
\bar\kappa=0.14,\qquad \bar I/\bar N=2.0,\qquad \bar I/\bar Y=0.2,\qquad \bar K/\bar Y\approx 12.
\]

7. Aggregate capital evolves in steady state according to:

\[
\delta\bar K=\alpha^g R\bar I.
\]

8. Entrepreneur and banker capital holdings satisfy:

\[
\bar K^e=\tau^e\alpha^g\bar R^e\bar I,\qquad
\bar K^b=\tau^b\alpha^g\bar R^b\bar I.
\]

9. Entrepreneurial and bank consumption are:

\[
\bar C^e=(1-\tau^e)\bar q\alpha^g\bar R^e\bar I,\qquad
\bar C^b=(1-\tau^b)\bar q\alpha^g\bar R^b\bar I.
\]

10. Household consumption closes the resource constraint:

\[
\bar C^h=\bar Y-\bar C^e-\bar C^b-\bar I-\mu\bar I.
\]

This steady-state block is `draft_extracted`: the paper gives calibration targets and the implementation supplies an explicit computational sequence, but no Dynare run or independent steady-state residual check was performed.

## 7. Timing & Form Conventions

- One period is one quarter.
- Aggregate shocks are realized at the beginning of the period before production and financing decisions.
- Capital stocks \(K^h_t\), \(K^e_t\), and \(K^b_t\) are beginning-of-period holdings for production/use decisions; aggregate accumulation maps period-\(t\) investment into \(K_{t+1}\).
- Bank and entrepreneur net worth are accumulated from retained earnings and affect the next financing cycle; this sluggishness is central to the propagation mechanism.
- Prices and wages have Calvo-type non-reoptimization with indexation to lagged inflation.
- The model is nonlinear in paper-side equilibrium form and solved by linearization around steady state. The local MMB `.mod` cross-check implements a nonlinear model block and requests first-order `stoch_simul`; Dynare was not run for this archive entry.
- Stock variables in the implementation cross-check use lagged capital in production (`K(-1)`, `Ke(-1)`, `Kb(-1)`) and current net worth variables for financing.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Main equation(s) |
|---|---|---|---|
| Endogenous | \(Y_t\) / `Y` | Final output | (F1), (F44), (F48) |
| Endogenous | \(y_{jt}\) | Intermediate variety output | (F1), (F3) |
| Endogenous | \(P_t,\pi_t\) / `infl` | Price level and gross inflation | (F2), (F9), (F10), (F28) |
| Endogenous | \(\tilde p_t\) / `ptilde` | Reset price | (F10) |
| Endogenous | \(s_t\) / `s` | Real marginal cost | (F5)-(F8), (F10) |
| Endogenous | \(K_t,K^h_t,K^e_t,K^b_t\) / `K`, `Ke`, `Kb` | Aggregate and sectoral capital | (F33), (F34), (F41), (F45) |
| Endogenous | \(u_t\) / `u` | Utilization | (F20), (F42) |
| Endogenous | \(H_t,l_{it}\) / `H` | Composite and specialized labor | (F23), (F24), (F43) |
| Endogenous | \(w_t,w^e_t,w^b_t\) / `w_h`, `w_e`, `w_b` | Household, entrepreneur, and banker wages | (F6)-(F8), (F25) |
| Endogenous | \(q_t\) / `q` | Relative price of capital goods | (F15), (F16), (F22), (F31)-(F40) |
| Endogenous | \(I_t\) / `I` | Aggregate capital-good investment | (F29), (F44), (F45) |
| Endogenous | \(A_t,N_t\) / `bigA`, `bigN` | Bank and entrepreneur net worth | (F31), (F32), (F35), (F36), (F40) |
| Endogenous | \(G_t\) / `G` | Inverse leverage from financial contract | (F16), (F29) |
| Endogenous | \(\kappa_t\) / `CA` | Capital-asset ratio | (F17), (F49) |
| Endogenous | \(d_t,D_t\) / `smalld` | Bank deposits / household deposit funds | (F14), (F46) |
| Endogenous | \(R^e_t,R^b_t,R^h_t\) | Contract return shares | (F11)-(F13) |
| Endogenous | \(C^h_t,C^e_t,C^b_t,C_t\) / `ch`, `Ce`, `Cb`, `totC` | Household, entrepreneur, banker, and aggregate consumption | (F37)-(F39), (F44), (F51) |
| Endogenous | \(\lambda_t\) / `lam` | Marginal utility of wealth | (F18), (F21), (F22) |
| Endogenous | \(r_t,r^d_t,r^a_t\) / `rk`, `Rd`, `Ra` | Rental rate, nominal deposit/policy rate, bank-capital return | (F20), (F21), (F28), (F30) |
| Endogenous | \(M_t,M^c_t\) / `p`, `mc` | Money and currency-related variables | (F19), (F47) |
| Endogenous | \(TL_t\) / `TL` | Aggregate bank lending | (F50) |
| Exogenous | \(\varepsilon^z_t\) / `z_shk` | Technology innovation | (F4), (F52) |
| Exogenous | \(u^{mp}_t\) / `mp_shk` | Monetary-policy innovation | (F28), (F53) |
| Exogenous | \(u^x_t\) / `bk_shk` | Bank-capital shock innovation | (F40), (F54) |
| Parameter | \(\beta,\gamma,\psi,\zeta\) / `bet`, `habit`, `psi_l`, `reta` | Preferences, habits, money utility | (F18)-(F22) |
| Parameter | \(\xi_p,\phi_p,\xi_w,\phi_w\) | Price/wage elasticity and Calvo probabilities | (F1), (F2), (F9), (F10), (F23)-(F25) |
| Parameter | \(\theta_k,\theta_h,\theta_e,\theta_b,\Theta\) | Production shares and fixed cost | (F3), (F5)-(F8), (F48) |
| Parameter | \(\alpha^g,\alpha^b,\Delta\alpha,R,b,\mu\) / `alphag`, `delalpha`, `bigR`, `smallb`, `mu` | Financial-contract technology and moral-hazard parameters | (F11)-(F17), (F29) |
| Parameter | \(\tau^e,\tau^b\) / `tau_e`, `tau_b` | Survival/retention probabilities | (F33)-(F38) |
| Parameter | \(\rho_r,\rho_\pi,\rho_y\) / `lam_r`, `lam_pi`, `lam_y` | Monetary policy coefficients | (F28) |
| Parameter | \(\rho_z,\rho_{mp},\rho_x\) / `rhoz`, `rhomp`, `rhobk` | Shock persistence | (F52)-(F54) |
