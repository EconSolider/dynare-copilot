# EA_PV15 -- Derivation (Optimization Problems + First-Order Conditions)

> Status: `needs_review`. This first-pass archive entry is based on the MinerU Markdown source, with `.agents/skills/dynare-copilot/references/examples/EA_PV15_rep.mod` used only as `implementation_cross_check`. Runtime validation was not performed.

Source: Jean-Christophe Poutineau and Gauthier Vermandel (2015), "Cross-border banking flows spillovers in the eurozone: Evidence from an estimated DSGE model", *Journal of Economic Dynamics and Control* 51, 378-403. DOI: `10.1016/j.jedc.2014.11.006`.

## 1. Model Overview

- **Model**: `EA_PV15`, a two-country monetary-union DSGE model for Eurozone core (`h`) and periphery (`f`) with cross-border corporate and interbank lending.
- **Purpose**: quantify how cross-border bank flows affect asymmetric shock transmission, investment cycles, credit quantities, interest-rate spreads, and current-account dynamics.
- **Agents**: households, labor unions, intermediate and final goods producers, capital suppliers, entrepreneurs, liquid and illiquid banks, national fiscal authorities, and a common central bank.
- **Frictions**: external habits in consumption and loan demand, investment adjustment costs, capital utilization costs, portfolio adjustment costs, sticky goods prices, sticky wages, sticky loan rates, financial accelerator risk, bank balance-sheet constraints, and cross-border CES aggregators for goods, corporate loans, and interbank loans.
- **Model form**: the paper derives a nonlinear model and then works with log-linear equilibrium conditions. The MMB implementation cross-check uses `model(linear)`.

Notation: country index $`i \in \{h,f\}`$ and $`j \neq i`$. Variables are country-specific unless written without a country subscript. OCR quality is uneven in several formulas; formulas marked `needs_review` should be checked against the PDF before promotion.

## 2. Optimization Problems

### 2.1 Illiquid Banks

Illiquid bank $`b \in [0,\lambda]`$ supplies one-period corporate loans to entrepreneurs and funds them with interbank borrowing, bank capital, and other liabilities. Its balance sheet is:

**(F1) Illiquid bank balance sheet**:

```math
L_{i,t+1}^{s}(b)=IB_{i,t+1}^{H}(b)+BK_{i,t+1}(b)+liab_{i,t}.
```

It chooses loan supply to maximize expected profits:

**(F2) Illiquid bank profit problem**:

```math
\max_{L_{i,t+1}^{s}(b)}
E_t\left[
\eta_{i,t+1} MC_{i,t}^{ill}(b)L_{i,t+1}^{s}(b)
-P_{i,t}^{IB}\left(L_{i,t+1}^{s}(b)-BK_{i,t+1}(b)-liab_{i,t}(b)\right)
\right].
```

### 2.2 Liquid Banks

Liquid bank $`b \in [\lambda,1]`$ supplies loans to entrepreneurs and interbank loans to illiquid banks, financed by ECB borrowing, bank capital, and other liabilities:

**(F3) Liquid bank balance sheet**:

```math
L_{i,t+1}^{s}(b)+IB_{i,t+1}^{s}(b)=L_{i,t+1}^{ECB}(b)+BK_{i,t+1}(b)+liab_t(b).
```

Its objective includes loan income, interbank loan income, ECB funding costs, and convex monitoring/intermediation costs:

**(F4) Liquid bank profit problem**:

```math
\max_{\{L_{i,t+1}^{s}(b),IB_{i,t+1}^{s}(b)\}}
E_t\left[
\eta_{i,t+1}MC_{i,t}^{liq}(b)L_{i,t+1}^{s}(b)
+R_{i,t}^{IB}(b)IB_{i,t+1}^{s}(b)
-R_tL_{i,t+1}^{ECB}(b)-AC_{i,t+1}^{IB}(b)
\right].
```

### 2.3 Sticky Loan-Rate Setting Banks

The representative national banking system sets differentiated corporate loan rates under Calvo stickiness. A bank allowed to reset chooses $`R_{i,t}^{L\ast}(b)`$:

**(F5) Loan-rate reset problem (`needs_review`)**:

```math
\max_{\{R_{i,t}^{L\ast}(b)\}}
E_t\sum_{\tau=0}^{\infty}(\theta_i^L\beta)^\tau
\frac{\lambda_{i,t+\tau}^{c}}{\lambda_{i,t}^{c}}\eta_{i,t+1+\tau}
\left[(1-\tau^L)R_{i,t}^{L\ast}(b)\Xi_{i,t,\tau}^{L}-MC_{i,t+\tau}^{L}\right]
L_{i,t+1+\tau}(b).
```

The Markdown OCR garbles parts of the demand constraint, but the paper states that non-reset loan rates are indexed to past loan-rate growth.

### 2.4 Entrepreneurs

Entrepreneur $`e`$ finances capital projects with net worth and corporate loans:

**(F6) Entrepreneur balance sheet**:

```math
Q_{i,t}K_{i,t+1}(e)-N_{i,t+1}(e)=L_{i,t+1}^{H}(e).
```

The entrepreneur chooses capital after accounting for the risky project return and perceived profitability:

**(F7) Entrepreneur capital-choice problem**:

```math
\max_{\{K_{i,t+1}(e)\}}
E_t\left\{
\eta_{i,t+1}^{E}
\left[
g(\bar{\omega}_{i,t+1},\varepsilon_{i,t}^{Q})R_{i,t+1}^{k}Q_{i,t}K_{i,t+1}(e)
-P_{i,t}^{L}(e)L_{i,t+1}^{H}(e)
\right]
\right\}.
```

### 2.5 Households

The representative household chooses consumption, hours, and bond holdings:

**(F8) Household utility maximization**:

```math
\max_{\{C_{i,t}(j),H_{i,t}(j),B_{i,t+1}(j)\}}
E_t\sum_{\tau=0}^{\infty}\beta^\tau e^{\varepsilon_{i,t+\tau}^{\beta}}
\left[
\frac{(C_{i,t+\tau}(j)-h_i^c C_{i,t-1+\tau})^{1-\sigma_i^c}}{1-\sigma_i^c}
-\chi_i\frac{H_{i,t+\tau}(j)^{1+\sigma_i^L}}{1+\sigma_i^L}
\right].
```

**(F9) Household budget constraint**:

```math
\frac{W_{i,t}^{h}}{P_{i,t}^{c}}H_{i,t}(j)+R_{t-1}\frac{B_{i,t}(j)}{P_{i,t}^{c}}+\frac{\Pi_{i,t}(j)}{P_{i,t}^{c}}
=C_{i,t}(j)+\frac{B_{i,t+1}(j)}{P_{i,t}^{c}}+\frac{T_{i,t}(j)}{P_{i,t}^{c}}+\frac{P_{i,t}}{P_{i,t}^{c}}AC_{i,t}^{B}(j).
```

### 2.6 Labor Unions, Firms, and Capital Suppliers

Labor unions set differentiated wages with Calvo stickiness and partial indexation. Intermediate firms rent labor and utilized capital, minimize cost, and set sticky prices. Capital suppliers produce installed capital subject to investment adjustment costs.

**(F10) Capital supplier problem**:

```math
\max_{\{I_{i,t}(k)\}}E_t\sum_{\tau=0}^{\infty}\beta^\tau
\frac{\lambda_{i,t+\tau}^{c}}{\lambda_{i,t}^{c}}
\left[Q_{i,t}\left(1-AC_{i,t}^{I}(k)\right)-P_{i,t}^{I}\right]I_{i,t}(k).
```

## 3. First-Order Conditions

### 3.1 Banking and Loan Aggregation

**(F11) Illiquid-bank marginal cost of loans**:

```math
MC_{i,t}^{ill}=\frac{P_{i,t}^{IB}}{E_t\eta_{i,t+1}}.
```

**(F12) Interbank CES demand aggregator**:

```math
IB_{i,t+1}^{d}(b)=
\left[
(1-\alpha_i^{IB})^{1/\xi}IB_{h,i,t+1}^{d}(b)^{(\xi-1)/\xi}
+(\alpha_i^{IB})^{1/\xi}IB_{f,i,t+1}^{d}(b)^{(\xi-1)/\xi}
\right]^{\xi/(\xi-1)}.
```

**(F13) Interbank price index**:

```math
P_{i,t}^{IB}=
\left[
(1-\alpha_i^{IB})(R_{h,t}^{IB})^{1-\xi}
+\alpha_i^{IB}(R_{f,t}^{IB})^{1-\xi}
\right]^{1/(1-\xi)}.
```

**(F14) Interbank demand by origin**:

```math
IB_{h,i,t+1}^{d}(b)=(1-\alpha_i^{IB})
\left(\frac{R_{h,t}^{IB}}{P_{i,t}^{IB}}\right)^{-\xi}IB_{i,t+1}^{d}(b),
\quad
IB_{f,i,t+1}^{d}(b)=\alpha_i^{IB}
\left(\frac{R_{f,t}^{IB}}{P_{i,t}^{IB}}\right)^{-\xi}IB_{i,t+1}^{d}(b).
```

**(F15) Bank capital accumulation**:

```math
BK_{i,t+1}(b)=(1-\tau^B)\Pi_{i,t}^{B}(b).
```

**(F16) Liquid-bank marginal cost of loans**:

```math
MC_{i,t}^{liq}=\frac{R_t}{E_t\eta_{i,t+1}}.
```

**(F17) Interbank rate from monitoring cost**:

```math
R_{i,t}^{IB}(b)=\chi_i^{IB}\left(IB_{i,t+1}^{s}(b)-\bar{IB}_{i}^{s}(b)\right)+R_t.
```

**(F18) Aggregate marginal cost of corporate loans**:

```math
MC_{i,t}^{L}=(MC_{i,t}^{ill})^\lambda(MC_{i,t}^{liq})^{1-\lambda}
=\frac{(P_{i,t}^{IB})^\lambda R_t^{1-\lambda}}{E_t\eta_{i,t+1}}.
```

**(F19) Log-linear loan marginal cost (`needs_review`)**:

```math
\widehat{mc}_{i,t}^{L}=
\frac{(1-\alpha_i^L)(1-\varkappa_i)\widehat{kn}_{i,t}
+\alpha_i^L(1-\varkappa_j)\widehat{kn}_{j,t}}{1-\bar{N}/\bar{K}}
+(1-\lambda)\widehat{r}_t+\lambda\widehat{p}_{i,t}^{IB}.
```

**(F20) Sticky real loan-rate equation (`needs_review`)**:

```math
\hat{r}_{i,t}^{L}=
\frac{
(1+\xi_i^L(1+\beta))\hat{r}_{i,t-1}^{L}
-\xi_i^L\hat{r}_{i,t-2}^{L}
+\beta E_t\hat{r}_{i,t+1}^{L}
+\frac{(1-\theta_i^L)(1-\theta_i^L\beta)}{\theta_i^L}(\widehat{mc}_{i,t}^{L}-\hat{r}_{i,t}^{L})
}{1+\beta(1+\xi_i^L)}
+\varepsilon_{i,t}^{L}.
```

### 3.2 Entrepreneurs and Financial Accelerator

**(F21) Corporate loan CES aggregator**:

```math
L_{i,t+1}^{d}(e)=
\left[
(1-\alpha_i^L)^{1/\nu}L_{h,i,t+1}^{d}(e)^{(\nu-1)/\nu}
+(\alpha_i^L)^{1/\nu}L_{f,i,t+1}^{d}(e)^{(\nu-1)/\nu}
\right]^{\nu/(\nu-1)}.
```

**(F22) Corporate loan price index**:

```math
P_{i,t}^{L}(e)=
\left[
(1-\alpha_i^L)R_{h,t}^{L}(e)^{1-\nu}
+\alpha_i^LR_{f,t}^{L}(e)^{1-\nu}
\right]^{1/(1-\nu)}.
```

**(F23) Corporate loan demand by origin**:

```math
L_{h,i,t+1}^{d}(e)=(1-\alpha_i^L)
\left(\frac{R_{h,t}^{L}(e)}{P_{i,t}^{L}(e)}\right)^{-\nu}L_{i,t+1}^{d}(e),
\quad
L_{f,i,t+1}^{d}(e)=\alpha_i^L
\left(\frac{R_{f,t}^{L}(e)}{P_{i,t}^{L}(e)}\right)^{-\nu}L_{i,t+1}^{d}(e).
```

**(F24) Entrepreneur one-period profit**:

```math
\Pi_{i,t+1}^{E}(e)=
\begin{cases}
\bar{\omega}_{i,t+1}R_{i,t+1}^{k}Q_{i,t}K_{i,t+1}(e)-P_{i,t}^{L}(e)L_{i,t+1}^{H}(e), & \text{with probability }\eta_{i,t+1}^{E},\\
0, & \text{with probability }1-\eta_{i,t+1}^{E}.
\end{cases}
```

**(F25) Perceived profitability function**:

```math
g(\bar{\omega}_{i,t+1},\varepsilon_{i,t}^{Q})
=\gamma_i(\bar{\omega}_{i,t+1})^{\varkappa_i/(\varkappa_i-1)}
\left(e^{\varepsilon_{i,t}^{Q}}\right)^{1/(\varkappa_i-1)}.
```

**(F26) External finance premium**:

```math
S_{i,t}(e)=\frac{E_tR_{i,t+1}^{k}}{P_{i,t}^{L}(e)}
=\gamma_i^{\varkappa_i-1}
\left[
\frac{\kappa}{\kappa-1}
\left(1-\frac{N_{i,t+1}(e)}{Q_{i,t}K_{i,t+1}(e)}\right)
\right]^{\varkappa_i}e^{\varepsilon_{i,t}^{Q}}.
```

**(F27) Entrepreneur net worth accumulation**:

```math
N_{i,t+1}(e)=(1-\tau^E)\frac{\Pi_{i,t}^{E}(e)}{e^{\varepsilon_{i,t}^{N}}}.
```

**(F28) Log-linear spread equation**:

```math
\hat{s}_{i,t}=E_t\hat{r}_{i,t+1}^{k}-\hat{p}_{i,t}^{L}
=\varkappa_i\left(\hat{q}_{i,t}+\hat{k}_{i,t+1}-\hat{n}_{i,t+1}\right)+\varepsilon_{i,t}^{Q}.
```

**(F29) Default threshold from Pareto appendix**:

```math
\omega_{i,t}^{C}(e)R_{i,t}^{k}Q_{i,t-1}K_{i,t}(e,\omega_{i,t}^{C})
=P_{i,t-1}^{L}(e)L_{i,t}^{H}(e,\omega_{i,t}^{C}).
```

### 3.3 Households, Wages, Firms, and Capital

**(F30) Household Euler equation (`needs_review`)**:

```math
C_{i,t+1}-(1+h_i^c)C_{i,t}+h_i^cC_{i,t-1}
=\frac{1-h_i^c}{\sigma_i^c}
\left(R_t-\pi_{i,t+1}^{c}+\varepsilon_{i,t+1}^{\beta}-\varepsilon_{i,t}^{\beta}-\chi^B B_{i,t+1}\right).
```

**(F31) Household labor supply**:

```math
\widehat{W}_{i,t}^{h}=\sigma_i^L\widehat{H}_{i,t}
+\frac{\sigma_i^c}{1-h_i^c}\left(\widehat{C}_{i,t}-h_i^c\widehat{C}_{i,t-1}\right).
```

**(F32) Sticky wage condition (`needs_review`)**:

```math
(1+\beta)\widehat{W}_{i,t}
=\xi_i^w\pi_{i,t-1}^{c}+\widehat{W}_{i,t-1}
-(1+\beta\xi_i^w)\pi_{i,t}^{c}
+\beta(\widehat{W}_{i,t+1}+\pi_{i,t+1}^{c})
+\frac{(1-\theta_i^w\beta)(1-\theta_i^w)}{\theta_i^w}
(\widehat{W}_{i,t}^{h}-\widehat{W}_{i,t})
+\varepsilon_{i,t}^{W}.
```

**(F33) Intermediate firm marginal cost**:

```math
MC_{i,t}=\frac{1}{e^{\varepsilon_{i,t}^{A}}}
\left(\frac{Z_{i,t}}{\alpha}\right)^\alpha
\left(\frac{W_{i,t}}{1-\alpha}\right)^{1-\alpha}.
```

**(F34) Sticky price reset condition (`needs_review`)**:

```math
P_{i,t}^{\ast}=
\frac{\epsilon_p}{(\epsilon_p-1)(1-\tau^y)}
\frac{
E_t\sum_{\tau=0}^{\infty}(\theta_i^p\beta)^\tau
\frac{\lambda_{i,t+\tau}^{c}}{\lambda_{i,t}^{c}}MC_{i,t+\tau}Y_{i,t+\tau}
}{
E_t\sum_{\tau=0}^{\infty}(\theta_i^p\beta)^\tau
\frac{\lambda_{i,t+\tau}^{c}}{\lambda_{i,t}^{c}}
\prod_{k=1}^{\tau}\pi_{i,t+k-1}^{\xi_i^p}Y_{i,t+\tau}
}.
```

**(F35) Tobin's Q investment condition**:

```math
Q_{i,t}=P_{i,t}^{I}
+Q_{i,t}\frac{\partial(I_{i,t}AC_{i,t}^{I})}{\partial I_{i,t}}
+\beta E_t\frac{\lambda_{i,t+1}^{c}}{\lambda_{i,t}^{c}}Q_{i,t+1}
\frac{\partial(I_{i,t+1}AC_{i,t+1}^{I})}{\partial I_{i,t}}.
```

**(F36) Expected return on capital (`needs_review`)**:

```math
\frac{E_tR_{i,t+1}^{k}}{1+P_{i,t}\chi^B(B_{i,t+1}(j)-B_i(j))}
=E_t\left[
\frac{Z_{i,t+1}u_{i,t+1}-P_{i,t+1}\Phi(u_{i,t+1})+(1-\delta)Q_{i,t+1}}{Q_{i,t}}
\right].
```

**(F37) Capital utilization condition**:

```math
\frac{\psi_i}{1-\psi_i}\hat{u}_{i,t}=\hat{z}_{i,t}.
```

## 4. Market Clearing & Identities

**(F38) Government budget identity**:

```math
P_{i,t}\bar{G}\varepsilon_{i,t}^{G}
=\int_0^1T_{i,t}(j)\,dj+\tau^y\int_0^1P_{i,t}(m)Y_{i,t}(m)\,dm
+\tau^w\int_0^1W_{i,t}(j)H_{i,t}(j)\,dj
+\tau^L\int_0^1L_{i,t+1}^{s}(b)R_{i,t}^{L}(b)\,db
+\tau^E\int_0^1N_{i,t}^{E}(e)\,de
+\tau^B\int_0^1BK_{i,t}(b)\,db.
```

**(F39) Monetary policy rule**:

```math
\frac{R_t}{\bar{R}}=
\left(\frac{R_{t-1}}{\bar{R}}\right)^\rho
\left[
(\pi_{h,t}^{c}\pi_{f,t}^{c})^{\phi^\pi}
\left(\frac{Y_{h,t}Y_{f,t}}{Y_{h,t-1}Y_{f,t-1}}\right)^{\phi^{\Delta y}}
\right]^{\frac{1}{2}(1-\rho)}
e^{\varepsilon_t^R}.
```

**(F40) Home resource constraint (`needs_review`)**:

```math
\frac{Y_{h,t}}{\Delta_{h,t}^{p}}
=(1-\alpha^C)\left(\frac{P_{h,t}}{P_{h,t}^{c}}\right)^{-\mu}C_{h,t}
+\alpha^C\left(\frac{P_{h,t}}{P_{f,t}^{c}}\right)^{-\mu}C_{f,t}
+(1-\alpha^I)\left(\frac{P_{h,t}}{P_{h,t}^{I}}\right)^{-\mu}(1+AC_{h,t}^{I})I_{h,t}
+\alpha^I\left(\frac{P_{h,t}}{P_{f,t}^{I}}\right)^{-\mu}(1+AC_{f,t}^{I})I_{f,t}
+\bar{G}\varepsilon_{h,t}^{G}+AC_{h,t}^{B}
+(1-\eta_{h,t}^{E})\underline{\omega}_{h,t}Q_{h,t}K_{h,t}
+\Phi(u_{h,t})K_{h,t-1}.
```

**(F41) Price index aggregation**:

```math
P_{i,t}^{1-\epsilon_p}
=\theta_i^p(P_{i,t-1}\pi_{i,t-1}^{\xi_i^p})^{1-\epsilon_p}
+(1-\theta_i^p)(P_{i,t}^{\ast})^{1-\epsilon_p}.
```

**(F42) Wage index aggregation**:

```math
W_{i,t}^{1/(1-\mu_{i,t}^{w})}
=\theta_i^w\left[W_{i,t-1}(\pi_{i,t-1}^{C})^{\xi_i^w}\right]^{1/(1-\mu_{i,t}^{w})}
+(1-\theta_i^w)(W_{i,t}^{\ast})^{1/(1-\mu_{i,t}^{w})}.
```

**(F43) Corporate credit market clearing**:

```math
L_{h,t+1}^{s}=
\left[
(1-\alpha^L)\left(\frac{R_{h,t}^{L}}{P_{h,t}^{L}}\right)^{-\nu}L_{h,t+1}^{d}
+\alpha^L\left(\frac{R_{h,t}^{L}}{P_{f,t}^{L}}\right)^{-\nu}L_{f,t+1}^{d}
\right]\Delta_{h,t}^{L}.
```

**(F44) Interbank market clearing**:

```math
IB_{h,t+1}^{s}=
\frac{\lambda}{1-\lambda}
\left[
(1-\alpha^{IB})\left(\frac{R_{h,t}^{IB}}{P_{h,t}^{IB}}\right)^{-\xi}IB_{h,t+1}^{d}
+\alpha^{IB}\left(\frac{R_{h,t}^{IB}}{P_{f,t}^{IB}}\right)^{-\xi}IB_{f,t+1}^{d}
\right].
```

**(F45) International asset market clearing**:

```math
B_{h,t+1}+B_{f,t+1}=0,\qquad CA_{h,t}+CA_{f,t}=0.
```

**(F46) Home current-account identity**:

```math
CA_{h,t}=(B_{h,t+1}-B_{h,t})
+[(L_{h,f,t+1}-L_{h,f,t})-(L_{f,h,t+1}-L_{f,h,t})]
+[(IB_{h,f,t+1}-IB_{h,f,t})-(IB_{f,h,t+1}-IB_{f,h,t})].
```

## 5. Exogenous Processes

For country-specific disturbances $`s \in \{\beta,A,Q,N,L,B\}`$:

**(F47) Country shock processes**:

```math
\varepsilon_{i,t}^{s}=\rho_i^s\varepsilon_{i,t-1}^{s}+\eta_{i,t}^{s}.
```

The common monetary-policy disturbance is:

**(F48) Monetary-policy shock**:

```math
\varepsilon_t^R=\rho^R\varepsilon_{t-1}^R+\eta_t^R.
```

Government spending is linked to productivity innovations:

**(F49) Spending shock process**:

```math
\varepsilon_{i,t}^{G}=\rho_i^G\varepsilon_{i,t-1}^{G}+\eta_{i,t}^{G}+\rho_i^{ag}\eta_{i,t}^{A}.
```

Wage markup disturbances have an ARMA component:

**(F50) Wage markup shock process**:

```math
\varepsilon_{i,t}^{W}=\rho_i^W\varepsilon_{i,t-1}^{W}+\eta_{i,t}^{W}-u_i^W\eta_{i,t-1}^{W}.
```

Common financial innovations are added for $`s \in \{Q,N,L,B\}`$ in the implementation cross-check.

## 6. Steady-State Solution

The paper reports quarterly calibration targets rather than a complete analytic steady-state derivation. The first-pass steady-state reconstruction below follows the paper's calibration discussion and the implementation cross-check; it is `needs_review` until checked against the original code or a runtime steady-state file.

1. Set $`\bar{R}=1/\beta`$, with $`\beta=0.995`$.
2. Set calibrated real-side targets: $`\delta=0.02`$, $`\alpha=0.25`$, $`\bar{H}=1/3`$, $`\bar{G}/\bar{Y}=0.24`$, and portfolio adjustment cost $`\chi^B=0.0007`$.
3. Set financial targets: $`\bar{N}/\bar{K}=0.40`$, $`\bar{IB}/\bar{L}=0.20`$, $`\bar{BK}/\bar{L}=0.10`$, and loan spread $`\bar{R}^L-\bar{R}=0.02/4`$.
4. Normalize $`\bar{Q}=1`$ and derive $`\bar{R}^L=\bar{R}+0.02/4`$.
5. Use the Pareto distribution conditions $`E[\omega]=1`$ and $`\omega_{\min}=(\kappa-1)/\kappa=1-\bar{N}/\bar{K}`$ to pin down the riskiness parameters used in (F24)-(F29).
6. Compute $`\bar{K}`$ from the capital-return relation using $`\bar{R}^k`$, $`\delta`$, $`\alpha`$, and $`\bar{H}`$; then set $`\bar{N}=0.40\bar{K}`$ and $`\bar{L}=\bar{Q}\bar{K}-\bar{N}`$.
7. Set $`\bar{Y}=(\bar{Z}/\alpha)\bar{K}`$, $`\bar{I}=\delta\bar{K}`$, and $`\bar{C}=(1-\bar{G}/\bar{Y})\bar{Y}-\delta\bar{K}`$.
8. Set $`\bar{BK}=0.11\bar{L}`$ and $`\bar{IB}=0.20\bar{L}`$ in the implementation cross-check; this differs slightly from the paper table's rounded $`\bar{BK}/\bar{L}=0.10`$ and is a deferred reconciliation item.
9. In log-linear form, steady states of hatted variables are zero, while levels and calibration ratios above anchor the linearized coefficients.

## 7. Timing & Form Conventions

- The paper's equilibrium used for estimation is log-linear; the `.mod` implementation declares `model(linear)`.
- Core-country variables use suffix `_h`; peripheral-country variables use suffix `_f`; Euro-area aggregates average the two country blocks.
- Capital requires one period to be installed. The implementation uses `ku_i = k_i(-1) + u_i`; production uses utilized lagged capital, while investment determines next-period capital.
- Entrepreneur loans and capital are dated $`t+1`$ in the paper balance sheet $`Q_{i,t}K_{i,t+1}-N_{i,t+1}=L_{i,t+1}^{H}`$.
- Corporate and interbank loan demand include external habits, which appear as lagged loan-demand terms in the linear implementation.
- The common central bank sets a union-wide nominal rate responding to average consumption-price inflation and output growth.
- The source Markdown was sufficient for a first-pass derivation, so the raw PDF body was not opened.

## 8. Variable & Parameter Reference Table

| Category | Symbol / implementation name | Meaning | Main equation(s) |
|---|---|---|---|
| Endogenous | $`Y_i`$ / `y_h`, `y_f` | output | (F33), (F40) |
| Endogenous | $`C_i`$ / `c_h`, `c_f` | consumption | (F8), (F30), (F40) |
| Endogenous | $`R`$ / `r` | common central bank rate | (F39), (F48) |
| Endogenous | $`\pi_i`$, $`\pi_i^c`$ / `pi_h`, `pi_f`, `pic_h`, `pic_f` | producer and consumption inflation | (F34), (F41) |
| Endogenous | $`W_i`$, $`W_i^h`$ / `w_h`, `w_f`, `wh_h`, `wh_f` | wage and desired household wage | (F31), (F32), (F42) |
| Endogenous | $`H_i`$ / `h_h`, `h_f` | hours | (F31), (F33) |
| Endogenous | $`MC_i`$ / `mc_h`, `mc_f` | goods marginal cost | (F33), (F34) |
| Endogenous | $`K_i`$, $`K_i^u`$, $`u_i`$ / `k_h`, `k_f`, `ku_h`, `ku_f`, `u_h`, `u_f` | capital, utilized capital, utilization | (F35), (F36), (F37) |
| Endogenous | $`I_i`$ / `i_h`, `i_f` | investment | (F10), (F35), (F40) |
| Endogenous | $`Z_i`$ / `z_h`, `z_f` | rental cost of capital | (F33), (F36), (F37) |
| Endogenous | $`Q_i`$ / `q_h`, `q_f` | shadow value of capital | (F6), (F26), (F35) |
| Endogenous | $`B_h`$, $`CA`$ / `b_h`, `CA` | net foreign assets and current account | (F45), (F46) |
| Endogenous | $`N_i^E`$ / `n_E_h`, `n_E_f` | entrepreneur net wealth | (F6), (F27), (F28) |
| Endogenous | $`R_i^k`$ / `r_K_h`, `r_K_f` | return on capital | (F24), (F26), (F36) |
| Endogenous | $`L_i^d`$, $`L_i^s`$ / `ld_h`, `ld_f`, `ls_h`, `ls_f` | corporate loan demand and supply | (F21), (F43) |
| Endogenous | $`R_i^L`$, $`P_i^L`$ / `r_L_h`, `r_L_f`, `pl_h`, `pl_f` | corporate lending rates and CES borrowing cost | (F20), (F22), (F23) |
| Endogenous | $`MC_i^L`$ / `mcL_h`, `mcL_f` | marginal cost of loans | (F18), (F19) |
| Endogenous | $`BK_i`$ / `bk_h`, `bk_f` | bank capital | (F15) |
| Endogenous | $`IB_i^d`$, $`IB_i^s`$ / `IBd_h`, `IBd_f`, `IBs_h`, `IBs_f` | interbank demand and supply | (F12), (F44) |
| Endogenous | $`R_i^{IB}`$, $`P_i^{IB}`$ / `r_IB_h`, `r_IB_f`, `p_IB_h`, `p_IB_f` | interbank rates and CES interbank price | (F13), (F17) |
| Endogenous | $`\omega_i^C`$ / `omega_h`, `omega_f` | default threshold | (F29) |
| Endogenous | $`s_i`$, $`kn_i`$ / `s_h`, `s_f`, `nk_h`, `nk_f` | external finance spread and capital-net-worth ratio | (F26), (F28) |
| Endogenous | $`ToT`$ / `ToT` | terms of trade | (F40), (F46) |
| Exogenous state | $`\varepsilon_i^A`$, $`\varepsilon_i^G`$, $`\varepsilon_i^\beta`$, $`\varepsilon_i^N`$, $`\varepsilon_i^Q`$, $`\varepsilon_i^L`$, $`\varepsilon_i^W`$, $`\varepsilon_i^B`$, $`\varepsilon^R`$ | productivity, spending, preference, net-worth, riskiness, bank-rate markup, wage-markup, bank-liability, and monetary-policy shocks | (F47)-(F50) |
| Innovations | `e_a_*`, `e_g_*`, `e_beta_*`, `e_n_*`, `e_q_*`, `e_rL_*`, `e_w_*`, `e_ib_*`, `e_r` | country, common financial, and monetary innovations | (F47)-(F50) |
| Parameters | $`\beta,\alpha,\delta,\theta^p,\xi^p,\theta^w,\xi^w,\theta^L,\xi^L,\chi^I,\chi^{IB},\psi,\varkappa,\lambda,\rho,\phi^\pi,\phi^{\Delta y},\alpha^C,\alpha^I,\alpha^L,\alpha^{IB},\mu,\nu,\xi`$ | preference, technology, nominal, financial, openness, and substitution parameters | throughout |
