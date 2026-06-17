# NK_BGG99AL - Derivation (Optimization Problems + Equilibrium Conditions)

> Archive status: `needs_review`. This first-pass entry is source-backed by MinerU Markdown only. The raw PDF path was checked for existence but the PDF body was not read. No `NK_BGG99AL` appendix-normalization file or implementation example was present for variant-level cross-checking.

## 1. Model Overview

- **Model ID**: `NK_BGG99AL`.
- **Paper**: Bernanke, Ben; Gertler, Mark; Gilchrist, Simon (1999), "The financial accelerator in a quantitative business cycles framework", DOI `10.1016/s1574-0048(99)10034-x`.
- **Source Markdown**: `raw/mmb_mineru/runs/nk_bgg99_nk_bgg99al__the_financial_accelerator_in_a_quantitative_business__e6291ccb/full.md`.
- **Raw PDF**: `raw/mmb_papers/The financial accelerator in a quantitative business.pdf`.
- **MinerU run id**: `e6291ccb-176a-4258-bb8d-4ad10594377a`.
- **Source-review note**: `raw/mmb_mineru/model_index.csv` reports `model_title_match_score=0.8595` and `primary source title differs from model title; review variant mapping`. This derivation therefore records the paper's BGG financial-accelerator model and flags the `AL` variant as unresolved.
- **Agents**: households, entrepreneurs, financial intermediaries, retailers, capital producers through adjustment costs, and a fiscal/monetary authority.
- **Core mechanism**: costly state verification makes the external finance premium decline with entrepreneurial net worth relative to capital purchases. Capital-price movements therefore feed back into net worth and investment.
- **Model form**: log-linearized dynamic New Keynesian financial-accelerator model for the computational block. The paper also gives nonlinear household, contract, production, capital-accumulation, resource, and retail-pricing primitives. Equations below preserve both layers and mark log-linear equations where applicable.
- **Runtime validation**: not performed.

## 2. Optimization Problems

### Households

Households choose consumption, deposits, labor, and real money balances:

$$
\max_{\{C_t,D_{t+1},H_t,M_t/P_t\}} E_t\sum_{k=0}^{\infty}\beta^k
\left[\ln C_{t+k}+\xi\ln(M_{t+k}/P_{t+k})+\xi\ln(1-H_{t+k})\right]
$$

subject to

$$
C_t=W_tH_t-T_t+\Pi_t+R_tD_t-D_{t+1}+\frac{M_{t-1}-M_t}{P_t}.
$$

### Entrepreneurs and Financial Contract

Entrepreneur $j$ buys capital at the end of period $t$ for use in $t+1$. Borrowing is

$$
B_{t+1}^j=Q_tK_{t+1}^j-N_{t+1}^j.
$$

The costly-state-verification contract chooses capital and a cutoff $\bar{\omega}^j$. If $\omega^j\geq\bar{\omega}^j$, the borrower repays the promised amount; otherwise the lender monitors and receives net residual claims. The cutoff satisfies

$$
\bar{\omega}^j R_{t+1}^k Q_tK_{t+1}^j=Z_{t+1}^jB_{t+1}^j.
$$

The lender break-even condition is

$$
[1-F(\bar{\omega}^j)]Z_{t+1}^jB_{t+1}^j
+(1-\mu)\int_0^{\bar{\omega}^j}\omega R_{t+1}^kQ_tK_{t+1}^j\,dF(\omega)
=R_{t+1}B_{t+1}^j.
$$

In the appendix formulation, with $s=R^k/R$ and $k=QK/N$, the normalized contract problem is

$$
\max_{K,\bar{\omega}}\;(1-\Gamma(\bar{\omega}))R^kQK
\quad\text{s.t.}\quad
[\Gamma(\bar{\omega})-\mu G(\bar{\omega})]R^kQK=R(QK-N).
$$

### Retailers

Retailer $z$ faces CES demand and chooses a reset price when allowed to reprice:

$$
\max_{P_t^*}\sum_{k=0}^{\infty}\theta^kE_{t-1}\left[
\Lambda_{t,k}\frac{P_t^*-P_{t+k}^w}{P_{t+k}}Y_{t+k}^*(z)
\right],
$$

where $\Lambda_{t,k}=\beta C_t/C_{t+k}$ and $P_t^w=P_t/X_t$.

## 3. First-Order Conditions

- **(F1) Household Euler equation**:

$$
\frac{1}{C_t}=E_t\left\{\beta\frac{1}{C_{t+1}}\right\}R_{t+1}.
$$

- **(F2) Household labor supply**:

$$
W_t\frac{1}{C_t}=\xi\frac{1}{1-H_t}.
$$

- **(F3) Money demand**:

$$
\frac{M_t}{P_t}=\zeta C_t\left(\frac{R_{t+1}^n-1}{R_{t+1}^n}\right)^{-1}.
$$

- **(F4) Financial contract lender break-even after substitution**:

$$
\left([1-F(\bar{\omega}^j)]\bar{\omega}^j+(1-\mu)\int_0^{\bar{\omega}^j}\omega\,dF(\omega)\right)
R_{t+1}^kQ_tK_{t+1}^j
=R_{t+1}(Q_tK_{t+1}^j-N_{t+1}^j).
$$

- **(F5) Capital demand/net-worth relation**:

$$
Q_tK_{t+1}^j=\psi(s_t)N_{t+1}^j,\qquad \psi(1)=1,\quad\psi'(\cdot)>0.
$$

- **(F6) External finance premium relation**:

$$
E_t\{R_{t+1}^k\}=s\left(\frac{N_{t+1}^j}{Q_tK_{t+1}^j}\right)R_{t+1},\qquad s'(\cdot)<0.
$$

- **(F7) Appendix cutoff-premium mapping**:

$$
s=\rho(\bar{\omega}).
$$

- **(F8) Appendix leverage-premium mapping**:

$$
k=\psi(s),\qquad \psi'(s)>0,\qquad k=\frac{QK}{N}.
$$

- **(F9) Production technology**:

$$
Y_t=A_tK_t^{\alpha}L_t^{1-\alpha}.
$$

- **(F10) Capital accumulation with adjustment costs**:

$$
K_{t+1}=\Phi\left(\frac{I_t}{K_t}\right)K_t+(1-\delta)K_t.
$$

- **(F11) Price of capital**:

$$
Q_t=\left[\Phi'\left(\frac{I_t}{K_t}\right)\right]^{-1}.
$$

- **(F12) Expected gross return to capital**:

$$
E_t\{R_{t+1}^k\}
=E_t\left\{\frac{\frac{1}{X_{t+1}}\frac{\alpha Y_{t+1}}{K_{t+1}}+Q_{t+1}(1-\delta)}{Q_t}\right\}.
$$

- **(F13) Aggregate investment finance supply**:

$$
E_t\{R_{t+1}^k\}=s\left(\frac{N_{t+1}}{Q_tK_{t+1}}\right)R_{t+1}.
$$

- **(F14) Composite labor input**:

$$
L_t=H_t^{\Omega}(H_t^e)^{1-\Omega}.
$$

- **(F15) Entrepreneurial net worth**:

$$
N_{t+1}=\gamma V_t+W_t^e.
$$

- **(F16) Entrepreneurial equity**:

$$
V_t=R_t^kQ_{t-1}K_t-\left(R_t+
\frac{\mu\int_0^{\bar{\omega}_t}\omega R_t^kQ_{t-1}K_t\,dF(\omega)}
{Q_{t-1}K_t-N_t}\right)(Q_{t-1}K_t-N_t).
$$

`needs_review`: the paper text around this expression also contains adjacent timing notation with $N_{t-1}$ in the denominator in one displayed equation before presenting the aggregate difference equation with $N_t$; the final equation above follows the aggregate difference equation but should be source-checked against the PDF before implementation.

- **(F17) Entrepreneurial consumption**:

$$
C_t^e=(1-\gamma)V_t.
$$

- **(F18) Household labor demand**:

$$
(1-\alpha)\Omega\frac{Y_t}{H_t}=X_tW_t.
$$

- **(F19) Entrepreneurial labor demand**:

$$
(1-\alpha)(1-\Omega)\frac{Y_t}{H_t^e}=X_tW_t^e.
$$

- **(F20) Aggregate net-worth transition**:

$$
\begin{aligned}
N_{t+1}={}&\gamma\left[
R_t^kQ_{t-1}K_t-\left(R_t+
\frac{\mu\int_0^{\bar{\omega}_t}\omega\,dF(\omega)R_t^kQ_{t-1}K_t}
{Q_{t-1}K_t-N_t}\right)(Q_{t-1}K_t-N_t)\right] \\
&+(1-\alpha)(1-\Omega)A_tK_t^{\alpha}H_t^{(1-\alpha)\Omega}.
\end{aligned}
$$

- **(F21) Retail demand curve**:

$$
Y_t(z)=\left(\frac{P_t(z)}{P_t}\right)^{-\epsilon}Y_t^f.
$$

- **(F22) Calvo reset-price condition**:

$$
\sum_{k=0}^{\infty}\theta^kE_{t-1}\left\{
\Lambda_{t,k}\left(\frac{P_t^*}{P_{t+k}}\right)^{-\epsilon}Y_{t+k}^*(z)
\left[\frac{P_t^*}{P_{t+k}}-\left(\frac{\epsilon}{\epsilon-1}\right)\frac{P_{t+k}^w}{P_{t+k}}\right]\right\}=0.
$$

- **(F23) Aggregate price index evolution**:

$$
P_t=\left[\theta P_{t-1}^{1-\epsilon}+(1-\theta)(P_t^*)^{1-\epsilon}\right]^{1/(1-\epsilon)}.
$$

- **(F24) Log-linear resource constraint**:

$$
y_t=\frac{C}{Y}c_t+\frac{I}{Y}i_t+\frac{G}{Y}g_t+\frac{C^e}{Y}c_t^e+\cdots+\phi_t^v.
$$

- **(F25) Log-linear household consumption Euler equation**:

$$
c_t=-r_{t+1}+E_t\{c_{t+1}\}.
$$

- **(F26) Log-linear entrepreneurial consumption**:

$$
c_t^e=n_{t+1}+\cdots+\phi_t^{c^e}.
$$

- **(F27) Log-linear external finance premium**:

$$
E_t\{r_{t+1}^k\}-r_{t+1}=-\nu[n_{t+1}-(q_t+k_{t+1})].
$$

- **(F28) Log-linear return to capital**:

$$
r_{t+1}^k=(1-\epsilon)(y_{t+1}-k_{t+1}-x_{t+1})+\epsilon q_{t+1}-q_t.
$$

- **(F29) Log-linear capital price/investment relation**:

$$
q_t=\varphi(i_t-k_t).
$$

- **(F30) Log-linear aggregate production**:

$$
y_t=a_t+\alpha k_t+(1-\alpha)\Omega h_t.
$$

- **(F31) Log-linear labor-market equilibrium**:

$$
y_t-h_t-x_t-c_t=\eta^{-1}h_t.
$$

- **(F32) Log-linear Phillips curve**:

$$
\pi_t=E_{t-1}\{\kappa(-x_t)+\beta\pi_{t+1}\}.
$$

- **(F33) Log-linear capital transition**:

$$
k_{t+1}=\delta i_t+(1-\delta)k_t.
$$

- **(F34) Log-linear net-worth transition**:

$$
n_{t+1}=\frac{\gamma RK}{N}(r_t^k-r_t)+r_t+n_t+\cdots+\phi_t^n.
$$

## 4. Market Clearing & Identities

- **(F35) Household deposits equal entrepreneurial borrowing**:

$$
D_t=B_t.
$$

- **(F36) CES final-good aggregator**:

$$
Y_t^f=\left[\int_0^1Y_t(z)^{(\epsilon-1)/\epsilon}\,dz\right]^{\epsilon/(\epsilon-1)}.
$$

- **(F37) Retail price index**:

$$
P_t=\left[\int_0^1P_t(z)^{1-\epsilon}\,dz\right]^{1/(1-\epsilon)}.
$$

- **(F38) Nonlinear resource constraint with monitoring costs**:

$$
Y_t^f=C_t+C_t^e+I_t+G_t+\mu\int_0^{\bar{\omega}_t}\omega\,dF(\omega)R_t^kQ_{t-1}K_t.
$$

- **(F39) Government budget constraint**:

$$
G_t=\frac{M_t-M_{t-1}}{P_t}+T_t.
$$

- **(F40) Gross nominal interest definition**:

$$
i_{t+1}\equiv R_{t+1}^n\frac{P_{t+1}}{P_t}-1.
$$

## 5. Exogenous Processes

- **(F41) Monetary policy rule**:

$$
r_t^n=\rho r_{t-1}^n+\varsigma\pi_{t-1}+\varepsilon_t^{rn}.
$$

- **(F42) Government-spending process**:

$$
g_t=\rho_g g_{t-1}+\varepsilon_t^g.
$$

- **(F43) Technology process**:

$$
a_t=\rho_a a_{t-1}+\varepsilon_t^a.
$$

- **(F44) Investment-delay extension, if the `AL` variant uses the paper's one-period planning lag**:

$$
E_t\left\{q_{t+j}-\varphi(i_{t+j}-k_{t+j})\right\}=0,\qquad j=1\ \text{in the simulations}.
$$

`needs_review`: the source paper contains this extension, but the model-index row alone does not prove that `NK_BGG99AL` is exactly the investment-delay variant. This equation is included as a variant candidate rather than as a confirmed baseline replacement for (F29).

## 6. Steady-State Solution

The computational system is log-linearized around a deterministic steady state. Thus the log-deviation variables have zero steady state:

$$
\bar{a}=\bar{g}=\bar{c}=\bar{i}=\bar{y}=\bar{k}=\bar{n}=\bar{q}=\bar{x}=\bar{\pi}=0.
$$

The nonlinear normalization and calibration targets stated in the paper are:

$$
\bar{R}=\beta^{-1},\qquad \bar{Q}=1,\qquad \bar{G}/\bar{Y}=0.2,\qquad \bar{K}/\bar{N}=2.
$$

The steady-state external finance premium target is

$$
\bar{R}^k-\bar{R}=200\ \text{annual basis points}.
$$

The steady-state default/failure target is

$$
F(\bar{\omega})=0.03\ \text{annualized}.
$$

The paper calibrates the entrepreneurial death rate, idiosyncratic-risk dispersion, and monitoring cost as

$$
1-\gamma=0.0272,\qquad \operatorname{Var}(\log\omega)=0.28,\qquad \mu=0.12.
$$

Other baseline calibrations reported in the source include

$$
\beta=0.99,\quad \eta=3.0,\quad \alpha=0.35,\quad (1-\alpha)(1-\Omega)=0.64,\quad \delta=0.025,\quad \varphi=0.25.
$$

Shock and policy parameters reported in the source include

$$
\rho_a=1.0,\qquad \rho_g=0.95,\qquad \theta=0.75,\qquad \rho=0.9,\qquad \varsigma=0.11.
$$

`needs_review`: the source gives calibration targets and log-linear steady-state implications, not a full nonlinear `steady_state_model` ordering. A later implementation pass should reconstruct exact steady-state levels from the chosen MMB `.mod` variant.

## 7. Timing & Form Conventions

- Capital purchased in period $t$ is denoted $K_{t+1}$ because it is used in production in $t+1$.
- The production function in period $t$ uses the capital stock purchased in the preceding period.
- Entrepreneurial net worth $N_{t+1}$ is the end-of-period state carried into capital purchases and borrowing.
- Retailers set prices before period-$t$ aggregate uncertainty is realized in the Bernanke-Woodford timing used for the Phillips curve.
- The computational block is log-linearized. Lower-case variables denote percent deviations from steady state, except inflation and interest-rate notation as defined in the paper.
- The baseline capital-price equation is (F29). The investment-delay extension replaces it with expected future relation (F44) when the lagged-investment variant is confirmed.
- The model is not a `model(linear)` source file here; it is a paper-side log-linear system to be mapped to implementation later.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII hint | Meaning | Main equation(s) |
|---|---|---|---|
| Endogenous | $C_t$, `c` | household consumption | (F1), (F24), (F25) |
| Endogenous | $D_t$, `d` | household deposits / loanable funds | (F35) |
| Endogenous | $H_t$, `h` | household labor | (F2), (F18), (F30), (F31) |
| Endogenous | $M_t/P_t$, `m` | real money balances | (F3), (F39) |
| Endogenous | $B_t$, `b` | entrepreneurial borrowing | (F4), (F35) |
| Endogenous | $K_t$, `k` | capital stock | (F10), (F33) |
| Endogenous | $I_t$, `i` | investment | (F10), (F29), (F44) |
| Endogenous | $Q_t$, `q` | relative price of capital | (F11), (F29), (F44) |
| Endogenous | $N_t$, `n` | entrepreneurial net worth | (F15), (F20), (F34) |
| Endogenous | $V_t$, `v` | entrepreneurial equity | (F16) |
| Endogenous | $C_t^e$, `ce` | entrepreneurial consumption | (F17), (F26), (F38) |
| Endogenous | $Y_t$, `y` | wholesale/final output, depending on context | (F9), (F24), (F30), (F38) |
| Endogenous | $L_t$, `l` | composite labor input | (F14) |
| Endogenous | $W_t$, `w` | household real wage | (F18) |
| Endogenous | $W_t^e$, `we` | entrepreneurial wage | (F19) |
| Endogenous | $X_t$, `x` | retail markup over wholesale goods | (F12), (F18), (F19), (F31), (F32) |
| Endogenous | $R_t$, `r` | riskless real gross return / log real rate | (F1), (F4), (F13), (F40) |
| Endogenous | $R_t^k$, `rk` | gross return to capital | (F12), (F16), (F20), (F28), (F34) |
| Endogenous | $R_t^n$, `rn` | gross nominal return / policy instrument | (F3), (F40), (F41) |
| Endogenous | $\pi_t$, `pi` | inflation | (F32), (F41) |
| Endogenous | $\bar{\omega}_t$, `omega_bar` | default cutoff | (F4), (F7), (F16), (F20), (F38) |
| Endogenous | $P_t^*$, `pstar` | Calvo reset price | (F22), (F23) |
| Endogenous | $Y_t(z)$, `yz` | retailer-level demand/output | (F21) |
| Exogenous | $a_t$, `a` | technology log-deviation | (F30), (F43) |
| Exogenous | $g_t$, `g` | government-spending log-deviation | (F24), (F42) |
| Exogenous shock | $\varepsilon_t^{rn}$, `eps_rn` | monetary policy innovation | (F41) |
| Exogenous shock | $\varepsilon_t^g$, `eps_g` | government-spending innovation | (F42) |
| Exogenous shock | $\varepsilon_t^a$, `eps_a` | technology innovation | (F43) |
| Parameter | $\beta$ | household discount factor | (F1), (F22), (F32) |
| Parameter | $\xi$ | utility weight on real balances/leisure | (F2), (F3) |
| Parameter | $\zeta$ | money-demand scale parameter | (F3) |
| Parameter | $\alpha$ | capital share | (F9), (F12), (F18), (F19), (F20), (F30) |
| Parameter | $\delta$ | depreciation rate | (F10), (F12), (F33) |
| Parameter | $\gamma$ | entrepreneurial survival probability | (F15), (F17), (F20), (F34) |
| Parameter | $\mu$ | monitoring cost share | (F4), (F16), (F20), (F38) |
| Parameter | $\Omega$ | household-labor share in composite labor | (F14), (F18), (F19), (F30) |
| Parameter | $\theta$ | Calvo non-repricing probability | (F22), (F23), (F32) |
| Parameter | $\epsilon$ | demand elasticity / return-weight parameter in OCR source | (F21), (F22), (F23), (F28) |
| Parameter | $\eta$ | labor supply elasticity parameter | (F31) |
| Parameter | $\nu$ | financial accelerator elasticity | (F27) |
| Parameter | $\varphi$ | capital-price/investment elasticity | (F29), (F44) |
| Parameter | $\kappa$ | Phillips-curve slope | (F32) |
| Parameter | $\rho$, $\varsigma$ | policy-rule persistence and inflation response | (F41) |
| Parameter | $\rho_g$, $\rho_a$ | shock persistence | (F42), (F43) |
