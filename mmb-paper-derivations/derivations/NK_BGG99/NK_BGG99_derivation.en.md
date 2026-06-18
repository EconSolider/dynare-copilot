# NK_BGG99 -- Derivation (Optimization Problems + First-Order Conditions)

> First-pass private archive entry. Status: `needs_review`. Runtime validation was not performed.

## 1. Model Overview

- **Model ID**: `NK_BGG99`.
- **Source**: Ben S. Bernanke, Mark Gertler, and Simon Gilchrist (1999), "The financial accelerator in a quantitative business cycle framework," *Handbook of Macroeconomics*, DOI `10.1016/s1574-0048(99)10034-x`.
- **Source files**: primary OCR Markdown `raw/mmb_mineru/runs/nk_bgg99_nk_bgg99al__the_financial_accelerator_in_a_quantitative_business__e6291ccb/full.md`; raw PDF `raw/mmb_papers/The financial accelerator in a quantitative business.pdf`.
- **Agents**: households, entrepreneurs, competitive financial intermediaries, wholesale producers, monopolistically competitive retailers, and a fiscal/monetary authority.
- **Core mechanism**: costly-state-verification contracting makes the external finance premium decrease with entrepreneurial net worth relative to the value of installed capital.
- **Model form**: log-linearized `model(linear)` in the MMB implementation cross-check. The source paper also states the complete macro model directly in log-linearized form, with nonlinear contracting and household/retail appendices used as derivation support.
- **Experiments**: monetary policy, technology, government spending, and wealth-transfer shocks; the MMB implementation keeps technology, government spending, and monetary policy innovations.

## 2. Optimization Problems

### Households

Households choose consumption, deposits, labor, and real money balances:

\[
\max_{\{C_{t+k},D_{t+k+1},H_{t+k},M_{t+k}/P_{t+k}\}} E_t\sum_{k=0}^{\infty}\beta^k
\left[\ln C_{t+k}+\xi\ln(M_{t+k}/P_{t+k})+\xi\ln(1-H_{t+k})\right]
\]

subject to

\[
C_t = W_tH_t-T_t+\Pi_t+R_tD_t-D_{t+1}+\frac{M_{t-1}-M_t}{P_t}.
\]

### Entrepreneurs and Financial Intermediaries

Entrepreneur \(j\) buys capital for use next period. Borrowing is

\[
B_{t+1}^j = Q_tK_{t+1}^j-N_{t+1}^j.
\]

The costly-state-verification contract chooses capital and a cutoff idiosyncratic return:

\[
\max_{K,\bar\omega}\;(1-\Gamma(\bar\omega))R^kQK
\]

subject to the lender break-even condition

\[
\left[\Gamma(\bar\omega)-\mu G(\bar\omega)\right]R^kQK=R(QK-N).
\]

The paper defines

\[
\Gamma(\bar\omega)=\int_0^{\bar\omega}\omega f(\omega)d\omega+\bar\omega\int_{\bar\omega}^{\infty}f(\omega)d\omega,
\qquad
\mu G(\bar\omega)=\mu\int_0^{\bar\omega}\omega f(\omega)d\omega.
\]

### Capital Goods / Investment Technology

Investment produces new capital through an adjustment-cost technology:

\[
K_{t+1}=\Phi\!\left(\frac{I_t}{K_t}\right)K_t+(1-\delta)K_t.
\]

The price of new capital is pinned down by the marginal transformation rate:

\[
Q_t=\left[\Phi'\!\left(\frac{I_t}{K_t}\right)\right]^{-1}.
\]

### Retailers

Retailers aggregate differentiated goods,

\[
Y_t^f=\left[\int_0^1Y_t(z)^{(\epsilon-1)/\epsilon}dz\right]^{\epsilon/(\epsilon-1)},
\]

face demand

\[
Y_t(z)=\left(\frac{P_t(z)}{P_t}\right)^{-\epsilon}Y_t^f,
\]

and choose an optimal reset price under Calvo rigidity:

\[
\max_{P_t^{\ast}}\sum_{k=0}^{\infty}\theta^kE_{t-1}\left[
\Lambda_{t,k}\frac{P_t^{\ast}-P_{t+k}^w}{P_{t+k}}Y_{t+k}^{\ast}(z)
\right].
\]

## 3. First-Order Conditions

- **(F1) Household Euler equation**:

\[
\frac{1}{C_t}=E_t\left\{\beta\frac{1}{C_{t+1}}\right\}R_{t+1}.
\]

- **(F2) Household labor supply**:

\[
W_t\frac{1}{C_t}=\xi\frac{1}{1-H_t}.
\]

- **(F3) Household money demand**:

\[
\frac{M_t}{P_t}=\zeta C_t\left(\frac{R_{t+1}^n-1}{R_{t+1}^n}\right)^{-1}.
\]

- **(F4) Contract lender break-even condition**:

\[
\left[\Gamma(\bar\omega)-\mu G(\bar\omega)\right]R^kQK=R(QK-N).
\]

- **(F5) Contract cutoff condition**:

\[
s=\rho(\bar\omega),\qquad s\equiv\frac{R^k}{R}.
\]

- **(F6) Capital/wealth ratio from optimal contract**:

\[
\frac{QK}{N}=\psi(s),\qquad \psi'(s)>0.
\]

- **(F7) External finance premium in general equilibrium**:

\[
E_t\{R_{t+1}^k\}=s\!\left(\frac{N_{t+1}}{Q_tK_{t+1}}\right)R_{t+1},\qquad s'(\cdot)<0.
\]

- **(F8) Expected return to capital**:

\[
E_t\{R_{t+1}^k\}=E_t\left\{\frac{\frac{1}{X_{t+1}}\frac{\alpha Y_{t+1}}{K_{t+1}}+Q_{t+1}(1-\delta)}{Q_t}\right\}.
\]

- **(F9) Capital-price/investment condition**:

\[
Q_t=\left[\Phi'\!\left(\frac{I_t}{K_t}\right)\right]^{-1}.
\]

- **(F10) Entrepreneurial equity**:

\[
V_t=R_t^kQ_{t-1}K_t-
\left(R_t+\frac{\mu\int_0^{\bar\omega_t}\omega R_t^kQ_{t-1}K_t\,dF(\omega)}
{Q_{t-1}K_t-N_{t-1}}\right)(Q_{t-1}K_t-N_{t-1}).
\]

- **(F11) Entrepreneurial net worth**:

\[
N_{t+1}=\gamma V_t+W_t^e.
\]

- **(F12) Wholesale production**:

\[
Y_t=A_tK_t^{\alpha}L_t^{1-\alpha},\qquad L_t=H_t^{\Omega}(H_t^e)^{1-\Omega}.
\]

- **(F13) Household labor demand**:

\[
(1-\alpha)\Omega\frac{Y_t}{H_t}=X_tW_t.
\]

- **(F14) Entrepreneurial labor demand**:

\[
(1-\alpha)(1-\Omega)\frac{Y_t}{H_t^e}=X_tW_t^e.
\]

- **(F15) Retail optimal reset price**:

\[
\sum_{k=0}^{\infty}\theta^kE_{t-1}\left\{
\Lambda_{t,k}\left(\frac{P_t^{\ast}}{P_{t+k}}\right)^{-\epsilon}Y_{t+k}^{\ast}(z)
\left[\frac{P_t^{\ast}}{P_{t+k}}-\left(\frac{\epsilon}{\epsilon-1}\right)\frac{P_{t+k}^w}{P_{t+k}}\right]\right\}=0.
\]

- **(F16) Aggregate price index under Calvo pricing**:

\[
P_t=\left[\theta P_{t-1}^{1-\epsilon}+(1-\theta)(P_t^{\ast})^{1-\epsilon}\right]^{1/(1-\epsilon)}.
\]

## 4. Market Clearing & Identities

- **(F17) Final-goods resource constraint**:

\[
Y_t^f=C_t+C_t^e+I_t+G_t+\mu\int_0^{\bar\omega_t}\omega\,dF(\omega)R_t^kQ_{t-1}K_t.
\]

- **(F18) Deposit/loanable-funds clearing**:

\[
D_t=B_t.
\]

- **(F19) Government budget identity**:

\[
G_t=\frac{M_t-M_{t-1}}{P_t}+T_t.
\]

- **(F20) Nominal-real interest relation**:

\[
r_{t+1}^n=r_{t+1}+E_t(p_{t+1}-p_t).
\]

The source's computational block log-linearizes the main equilibrium as:

\[
y_t=\frac{C}{Y}c_t+\frac{I}{Y}i_t+\frac{G}{Y}g_t+\frac{C^e}{Y}c_t^e+\cdots+\phi_t^v,
\]

\[
c_t=-r_{t+1}+E_t\{c_{t+1}\},
\]

\[
c_t^e=n_{t+1}+\cdots+\phi_t^{c^e},
\]

\[
E_t\{r_{t+1}^k\}-r_{t+1}=-\nu\left[n_{t+1}-(q_t+k_{t+1})\right],
\]

\[
r_{t+1}^k=(1-\epsilon)(y_{t+1}-k_{t+1}-x_{t+1})+\epsilon q_{t+1}-q_t,
\]

\[
q_t=\varphi(i_t-k_t),
\]

\[
y_t=a_t+\alpha k_t+(1-\alpha)\Omega h_t,
\]

\[
y_t-h_t-x_t-c_t=\eta^{-1}h_t,
\]

\[
\pi_t=E_{t-1}\{\kappa(-x_t)+\beta\pi_{t+1}\},
\]

\[
k_{t+1}=\delta i_t+(1-\delta)k_t,
\]

\[
n_{t+1}=\frac{\gamma RK}{N}(r_t^k-r_t)+r_t+n_t+\cdots+\phi_t^n.
\]

These log-linear equations are source-stated, but some omitted second-order or monitoring-cost terms are represented by ellipses in the paper OCR; status: `needs_review`.

## 5. Exogenous Processes

- **(F21) Monetary policy rule**:

\[
r_t^n=\rho r_{t-1}^n+\varsigma\pi_{t-1}+\varepsilon_t^{rn}.
\]

- **(F22) Government spending shock**:

\[
g_t=\rho_g g_{t-1}+\varepsilon_t^g.
\]

- **(F23) Technology shock**:

\[
a_t=\rho_a a_{t-1}+\varepsilon_t^a.
\]

The implementation cross-check uses `e_a`, `e_g`, and `e_rn` as the three exogenous innovations.

## 6. Steady-State Solution

The MMB implementation is linearized, so the dynamic variables in the `model(linear)` block are deviations from steady state. The implementation cross-check therefore uses zero steady states for the endogenous deviation variables after calibrating steady-state ratios and constants.

Steady-state calibration relationships recorded in the implementation cross-check include:

1. Set \(\beta=0.99\), \(\alpha=0.35\), \(\delta=0.025\), \(\rho=0.9\), \(\rho_a=1\), \(\rho_g=0.95\), \(\theta=0.75\), \(\eta=3\), \(\varphi=0.25\).
2. Set \(R=1/\beta\).
3. Set the steady external finance premium \(s=1.005\) and \(R^K=sR\).
4. Set \(K/N=2\), \(G/Y=0.2\), gross markup \(X=1.1\), and household labor \(H=0.25\).
5. Compute \(Y/K=(X/\alpha)(R^K-(1-\delta))\) from the capital-return condition.
6. Compute income-share ratios such as \(C/Y\), \(I/Y\), \(C^e/Y\), \(N/Y\), and \(D/Y\) from the paper-side identities and the implementation formulas.

The paper-side contract calibration targets a two-hundred-basis-point annual risk spread, a three-percent annualized business failure rate, and a capital-to-net-worth ratio of 2. Formula-by-formula reconciliation between the appendix contract and the implementation calibration remains `needs_review`.

## 7. Timing & Form Conventions

- The computational model is log-linearized; lowercase variables denote percent deviations from steady state in the paper, while the implementation appends `H` to variable names.
- Capital timing in the paper: capital purchased in period \(t\) is used in period \(t+1\); in the MMB implementation, production and return equations use `kH(-1)`, while the law of motion sets current `kH`.
- Net worth timing in the paper: \(N_{t+1}\) is end-of-period net worth after period-\(t\) returns and entrepreneurial wage income; the implementation expresses the current linearized `nH` using lagged `nH(-1)`, lagged capital/price terms, and current returns.
- Calvo price setters choose reset prices before current aggregate uncertainty in the source's timing convention; the implementation represents the Phillips curve with a one-period expectation/realization timing device through `pi_t1H`.
- The source includes real money balances in the household problem but the MMB implementation omits money demand from the linear model, retaining only the interest-rate rule and Fisher relation.
- Runtime validation was not run.

## 8. Variable & Parameter Reference Table

### Endogenous Variables

| Category | Symbol / ASCII | Meaning | Primary equation(s) |
|---|---|---|---|
| endogenous | `cH`, \(c_t\) | household consumption deviation | (F1), log-linear demand |
| endogenous | `hH`, \(h_t\) | household labor deviation | (F2), labor market |
| endogenous | `piH`, \(\pi_t\) | inflation | (F16), Phillips curve, (F21) |
| endogenous | `rH`, \(r_t\) | real risk-free rate | (F1), (F20) |
| endogenous | `r_nH`, \(r_t^n\) | nominal risk-free rate | (F20), (F21) |
| endogenous | `qH`, \(q_t\) | price of capital | (F9), investment link |
| endogenous | `kH`, \(k_t\) | capital stock | capital law of motion |
| endogenous | `nH`, \(n_t\) | entrepreneurial net worth | (F10), (F11) |
| endogenous | `r_kH`, \(r_t^k\) | return on capital | (F8) |
| endogenous | `yH`, \(y_t\) | output | (F12), resource constraint |
| endogenous | `xH`, \(x_t\) | retail markup | labor market, Phillips curve |
| endogenous | `iH`, \(i_t\) | investment | (F9), capital law of motion |
| endogenous | `aH`, \(a_t\) | technology state | (F23) |
| endogenous | `c_eH`, \(c_t^e\) | entrepreneurial consumption | resource constraint, net worth |
| endogenous | `gH`, \(g_t\) | government spending | (F22) |
| endogenous | `pi_t1H` | one-period-forward inflation helper | Phillips timing helper |
| endogenous | `premiumH` | external finance premium | (F7) |

### Exogenous Shocks

| Category | ASCII | Meaning |
|---|---|---|
| exogenous | `e_a` | technology innovation |
| exogenous | `e_g` | government spending innovation |
| exogenous | `e_rn` | monetary policy innovation |

### Parameters

| Category | ASCII / Symbol | Meaning |
|---|---|---|
| parameter | `betav`, \(\beta\) | discount factor |
| parameter | `alphav`, \(\alpha\) | capital share |
| parameter | `omegav`, \(\Omega\) | household-labor share parameter |
| parameter | `deltav`, \(\delta\) | depreciation |
| parameter | `phiv`, \(\varphi\) | elasticity of capital price with respect to investment-capital ratio |
| parameter | `thetav`, \(\theta\) | Calvo non-reset probability |
| parameter | `kappav`, \(\kappa\) | Phillips-curve slope composite |
| parameter | `etav`, \(\eta\) | labor supply elasticity parameter |
| parameter | `rhov`, \(\rho\) | policy-rule smoothing |
| parameter | `rhov_a`, \(\rho_a\) | technology persistence |
| parameter | `rhov_g`, \(\rho_g\) | government-spending persistence |
| parameter | `zetav`, \(\varsigma\) | inflation coefficient in policy rule |
| parameter | `muv`, \(\mu\) | monitoring/auditing cost |
| parameter | `gammav`, \(\gamma\) | entrepreneur survival probability |
| parameter | `sigmav` | lognormal idiosyncratic-shock variance parameter |
| parameter | `X` | steady-state gross markup |
| parameter | `R`, \(R\) | steady-state real risk-free gross rate |
| parameter | `R_K`, \(R^K\) | steady-state return on capital |
| parameter | `s` | steady-state external finance premium |
| parameter | `KN` | capital-to-net-worth ratio |
| parameter | `CY`, `GY`, `C_EY`, `IY` | expenditure shares |
| parameter | `YK`, `NY`, `DY`, `YN` | steady-state output/capital/net-worth/deposit ratios |
| parameter | `niv`, \(\nu\) | elasticity of external finance premium with respect to leverage |
