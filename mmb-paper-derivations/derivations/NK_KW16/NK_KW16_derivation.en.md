# NK_KW16 -- Derivation (Optimization Problems + First-Order Conditions)

> Archive status: `needs_review`. This first-pass derivation is source-backed by the MinerU Markdown extraction and cross-checked against the MMB implementation. The paper states that the full formal structure is in online supplementary data, which is not present in the local MinerU Markdown; equations whose detailed source is only the implementation cross-check are marked `needs_review`. The raw PDF path was checked for existence only.

Source: Markus Kirchner and Sweder van Wijnbergen (2016), "Fiscal deficits, financial fragility, and the effectiveness of government policies", *Journal of Monetary Economics* 80, 51-68. DOI: `10.1016/j.jmoneco.2016.04.007`.

## 1. Model Overview

- **Model**: Closed-economy New Keynesian DSGE model with sticky prices, capital accumulation, habit formation, financial intermediaries, government debt, and two government-debt financing channels.
- **MMB implementation**: `NK_KW16`, a Rep-MMB implementation of the bank-financing case used for Figure 1 in the article.
- **Agents**: households with workers and bankers; intermediate goods producers; capital goods producers; retailers/final goods producers; banks subject to an agency problem; Money Management Funds (MMFs) without that agency problem; fiscal and monetary authorities.
- **Policy experiments**: deficit-financed government purchases, pre-announced spending, bank recapitalization, capital-quality shocks, and ZLB variants in the paper. The archived MMB file implements the stochastic bank-financing model without running the ZLB perfect-foresight experiment.
- **Form**: nonlinear/log-level implementation using `exp()` transformations around a nonstochastic steady state. It is not declared as `model(linear)` in the MMB `.mod`.
- **Source boundary**: Equations (2)-(15) and the Taylor/Fisher/fiscal equations are visible in the MinerU Markdown. The standard non-financial structure and complete FOC list are said by the paper to be in the online supplementary appendix; because that appendix is absent locally, the non-financial and full equilibrium equation set below remains `needs_review`.

## 2. Optimization Problems

### 2.1 Households

The representative household maximizes expected utility with external habit in consumption and disutility from labor:

$$
\max_{\{c_t,h_t,d_t\}} E_t\sum_{s=0}^{\infty}\beta^s
\left[
\log(c_{t+s}-\nu c_{t-1+s})-\frac{h_{t+s}^{1+\varphi}}{1+\varphi}
\right].
$$

The period budget constraint in the paper is:

$$
c_t+d_t+\tau_t \leq w_t h_t + (1+r_t^d)d_{t-1}+\Sigma_t.
$$

Households hold deposits at banks or MMFs and own the firms/intermediary family members through transfers. The `.mod` cross-check uses the marginal utility variable `U_c` and stochastic discount factor `Lambda`.

### 2.2 Intermediate Goods Producers

Intermediate producers rent labor, use effective capital, and issue claims financed through banks. The production technology is:

$$
Y^m_t = a_t(\xi_tK_{t-1})^\alpha L_t^{1-\alpha}.
$$

They choose capital and labor demands taking the real marginal cost/intermediate goods price $P^m_t$, wage $w_t$, capital price $Q_t$, and capital return $R^k_t$ as given.

### 2.3 Capital Goods Producers

Capital producers combine undepreciated effective capital with investment goods and face convex investment adjustment costs. With $S(I_t/I_{t-1})=\frac{\eta_i}{2}(I_t/I_{t-1}-1)^2$, their optimal investment condition pins down Tobin's $Q_t$.

### 2.4 Retailers and Final Goods Producers

Retailers face Calvo price rigidity with probability $\gamma$ of not resetting prices. The equilibrium uses auxiliary variables $F_t$ and $Z_t$, optimal reset inflation $\pi^\ast_t$, inflation $\pi_t$, and price dispersion $Dis_t$.

### 2.5 Banks

Bank $j$ holds private claims and government bonds:

$$
p^B_{j,t}=q_t s^k_{j,t}+s^b_{j,t}.
$$

Its balance sheet is:

$$
p^B_{j,t}=d^B_{j,t}+n_{j,t}.
$$

Net worth evolves with portfolio returns:

$$
n_{j,t+1}=(1+r^p_{t+1}-r^d_{t+1})p^B_{j,t}+(1+r^d_{t+1})n_{j,t}.
$$

Portfolio weights satisfy:

$$
1+r^p_t=(1+r^k_t)\omega_{j,t-1}+(1+r^{b,B}_t)(1-\omega_{j,t-1}).
$$

Bankers maximize discounted terminal wealth subject to an incentive constraint:

$$
\max_{\{s^k_{j,t},s^b_{j,t}\}} V_{j,t}
\quad\text{s.t.}\quad
V_{j,t}\geq \lambda^\ast p^B_{j,t}.
$$

The binding incentive constraint generates an endogenous leverage ratio $\phi_t$ and portfolio-choice conditions for private claims and government bonds.

### 2.6 MMFs

MMFs are frictionless pass-through intermediaries for government bonds. Their balance sheet is $p_t^{MMF}=d_t^{MMF}$, and their bond return equals the deposit return:

$$
r_t^{b,MMF}=r_t^d.
$$

### 2.7 Government and Monetary Authority

The monetary authority follows a Taylor rule for the nominal deposit rate and the Fisher relation defines the ex-post real deposit return. Fiscal policy sets purchases, taxes, possible bank transfers, and the allocation share $\Delta_t$ of new debt placed with leverage-constrained banks.

## 3. First-Order Conditions

The F-numbered system below follows the MMB implementation as `implementation_cross_check`; formulas not visible in the paper body should be checked against the online supplementary appendix before review status is upgraded.

**Households**

- **(F1) Marginal utility of consumption** (`needs_review`):

$$
U_{c,t}=(C_t-hC_{t-1})^{-1}-\beta h(C_{t+1}-hC_t)^{-1}.
$$

- **(F2) Stochastic discount factor** (`needs_review`):

$$
\Lambda_t=\frac{U_{c,t}}{U_{c,t-1}}.
$$

- **(F3) Deposit Euler equation** (`needs_review`):

$$
1=\beta R^d_{t+1}\Lambda_{t+1}.
$$

- **(F4) Labor supply** (`needs_review`):

$$
L_t^\varphi=U_{c,t}w_t.
$$

**Intermediate goods producers**

- **(F5) Gross real capital return** (`needs_review`):

$$
R^k_t=\frac{P^m_t\alpha Y^m_t/K_{t-1}+\xi_tQ_t(1-\delta)}{Q_{t-1}}.
$$

- **(F6) Production function** (`needs_review`):

$$
Y^m_t=a_t(\xi_tK_{t-1})^\alpha L_t^{1-\alpha}.
$$

- **(F7) Real wage** (`needs_review`):

$$
w_t=P^m_t(1-\alpha)\frac{Y^m_t}{L_t}.
$$

**Capital goods producers**

- **(F8) Tobin's Q / investment adjustment condition** (`needs_review`):

$$
\frac{1}{Q_t}=1-\frac{\eta_i}{2}\left(\frac{I_t}{I_{t-1}}-1\right)^2
-\eta_i\left(\frac{I_t}{I_{t-1}}-1\right)\frac{I_t}{I_{t-1}}
+\beta\Lambda_{t+1}\eta_i\left(\frac{I_{t+1}}{I_t}-1\right)
\left(\frac{I_{t+1}}{I_t}\right)^2\frac{Q_t}{Q_{t+1}}.
$$

- **(F9) Capital accumulation** (`needs_review`):

$$
K_t=(1-\delta)\xi_tK_{t-1}
+\left[1-\frac{\eta_i}{2}\left(\frac{I_t}{I_{t-1}}-1\right)^2\right]I_t.
$$

**Retail pricing**

- **(F10) Retail output and dispersion** (`needs_review`):

$$
Y^m_t=Y_t Dis_t.
$$

- **(F11) Price dispersion law** (`needs_review`):

$$
Dis_t=\gamma Dis_{t-1}\pi_t^\epsilon
+(1-\gamma)\left(\frac{1-\gamma\pi_t^{\epsilon-1}}{1-\gamma}\right)^{-\epsilon/(1-\epsilon)}.
$$

- **(F12) Calvo auxiliary variable F** (`needs_review`):

$$
F_t=Y_tP^m_t+\beta\gamma\Lambda_{t+1}\pi_{t+1}^{\epsilon}F_{t+1}.
$$

- **(F13) Calvo auxiliary variable Z** (`needs_review`):

$$
Z_t=Y_t+\beta\gamma\Lambda_{t+1}\pi_{t+1}^{\epsilon-1}Z_{t+1}.
$$

- **(F14) Optimal reset price/inflation** (`needs_review`):

$$
\pi^\ast_t=\frac{\epsilon}{\epsilon-1}\frac{F_t}{Z_t}\pi_t.
$$

- **(F15) Price index** (`needs_review`):

$$
\pi_t^{1-\epsilon}=\gamma+(1-\gamma)(\pi^\ast_t)^{1-\epsilon}.
$$

**Financial intermediaries**

- **(F16) Shadow value of private claims** (`needs_review`):

$$
\nu^k_t=\beta\Lambda_{t+1}\left[(R^k_{t+1}-R^d_{t+1})(1-\theta)
+\theta\frac{Q_{t+1}K_{t+1}}{Q_tK_t}\nu^k_{t+1}\right].
$$

- **(F17) Shadow value of bank-held bonds** (`needs_review`):

$$
\nu^b_t=\beta\Lambda_{t+1}\left[(R^b_{t+1}-R^d_{t+1})(1-\theta)
+\theta\frac{B_{t+1}}{B_t}\nu^b_{t+1}\right].
$$

- **(F18) Shadow value of net worth** (`needs_review`):

$$
\nu^n_t=\beta\Lambda_{t+1}\left[R^d_{t+1}(1-\theta)
+\theta\frac{N_{t+1}}{N_t}\nu^n_{t+1}\right].
$$

- **(F19) Portfolio arbitrage between private claims and bonds** (`needs_review`):

$$
\nu^k_t=\nu^b_t.
$$

- **(F20) Endogenous leverage ratio** (`needs_review`):

$$
\Phi_t=\frac{\nu^n_t}{\lambda-\nu^k_t}.
$$

- **(F21) Aggregate bank net worth** (`needs_review`):

$$
N_t=\theta\left[(R^p_t-R^d_t)\Phi_{t-1}+R^d_t\right]N_{t-1}
+\chi N_{t-1}.
$$

- **(F22) Bank balance sheet identity**:

$$
N_t+D_t=Q_tK_t+B_t.
$$

- **(F23) Bank portfolio size**:

$$
portf^B_t=Q_tK_t+B_t.
$$

- **(F24) Private-claim portfolio share**:

$$
Q_tK_t=\Omega_t\Phi_tN_t.
$$

- **(F25) Bank-held bond portfolio share**:

$$
B_t=(1-\Omega_t)\Phi_tN_t.
$$

- **(F26) Expected private-claim return**:

$$
ER^k_t=R^k_{t+1}.
$$

- **(F27) Expected bank-held bond return**:

$$
ER^b_t=R^b_{t+1}.
$$

- **(F28) Private credit spread**:

$$
prem_t=R^k_{t+1}-R^d_{t+1}.
$$

- **(F29) Bank-held bond spread**:

$$
prem2_t=R^b_{t+1}-R^d_{t+1}.
$$

- **(F30) Portfolio return**:

$$
R^p_t=R^k_t\Omega_{t-1}+R^b_t(1-\Omega_{t-1}).
$$

## 4. Market Clearing & Identities

- **(F31) Government budget constraint for bank-held debt**:

$$
B_t=R^b_tB_{t-1}+G_t-T_t.
$$

- **(F32) Government purchases level**:

$$
G_t=\bar{G}\,g_t.
$$

- **(F33) Taxes in the MMB bank-financing implementation**:

$$
T_t=\bar{T}.
$$

- **(F34) Government spending share**:

$$
Gy_t=\frac{G_t}{\bar{Y}}.
$$

- **(F35) Aggregate resource constraint**:

$$
Y_t=C_t+G_t+I_t.
$$

- **(F36) Fisher relation**:

$$
i_{t-1}=R^d_t\pi_t.
$$

- **(F37) Taylor rule**:

$$
i_t=i_{t-1}^{\rho_i}
\left[\bar{i}\,\pi_t^{\kappa_\pi}\left(\frac{Y_t}{Y_{t-1}}\right)^{\kappa_y}\right]^{1-\rho_i}
\exp(-\varepsilon^i_t)\quad\text{in gross-rate form}.
$$

The paper's printed rule is in net-rate additive form:

$$
r^n_t=(1-\rho_r)\left[r^n+\kappa_\pi(\pi_t-\bar{\pi})+\kappa_y\log(y_t/y_{t-1})\right]
+\rho_r r^n_{t-1}+\varepsilon_{r,t}.
$$

## 5. Exogenous Processes

- **(F38) TFP shock**:

$$
\log a_t=\rho_a\log a_{t-1}-\varepsilon^a_t.
$$

- **(F39) Capital quality shock**:

$$
\log \xi_t=\rho_\xi\log \xi_{t-1}-\varepsilon^\xi_t.
$$

- **(F40) Government purchases shock**:

$$
\log g_t=\rho_g\log g_{t-1}+\varepsilon^g_t.
$$

The paper also discusses unanticipated and four-quarter-ahead government-spending news innovations, fiscal responses to capital-quality shocks, bank transfers, and MMF-vs-bank financing shares:

$$
\log(\tilde{g}_t/\bar{g})=\rho_g\log(\tilde{g}_{t-1}/\bar{g})+\varepsilon^u_{g,t}+\varepsilon^a_{g,t-4},
$$

$$
n_{g,t}=\varkappa(\xi_{t-l}-\xi),
$$

$$
s^b_t=\Delta_t(g_t-\tau_t+n_{g,t}-\tilde{n}_{g,t})+(1+r^{b,B}_t)s^b_{t-1}.
$$

These policy variants are paper-side equations but are not all active in the archived Rep-MMB `.mod` closure.

## 6. Steady-State Solution

Runtime validation was not performed. The implementation cross-check contains a closed-form calibration sequence. Let $\bar{\pi}=1$, $\bar{\xi}=1$, $\bar{a}=1$, $\bar{Q}=1$, $\overline{Dis}=1$, and $\bar{\Lambda}=1$.

1. Deposit return and policy rate:

$$
\bar{R}^d=\frac{1}{\beta},\qquad \bar{i}=\bar{R}^d.
$$

2. Spreads and intermediary returns:

$$
\overline{prem}=\overline{prem2}=0.01/4,\qquad
\bar{R}^k=\bar{R}^b=\bar{R}^p=\bar{R}^d+\overline{prem}.
$$

3. Marginal cost and bank shadow values:

$$
\bar{P}^m=\frac{\epsilon-1}{\epsilon},
$$

$$
\bar{\nu}^n=\frac{(1-\theta)\beta\bar{R}^d}{1-\theta\beta},\qquad
\bar{\nu}^k=\bar{\nu}^b=\frac{(1-\theta)\beta(\bar{R}^k-\bar{R}^d)}{1-\theta\beta}.
$$

4. Incentive-constraint and entry-transfer parameters:

$$
\lambda=\bar{\nu}^k+\frac{\bar{\nu}^n}{\bar{\Phi}},
$$

$$
\chi=1-\theta\left[(\bar{R}^k-\bar{R}^d)\bar{\Phi}+\bar{R}^d\right].
$$

5. Real-side ratios:

$$
\bar{w}=\left[\alpha^\alpha(1-\alpha)^{1-\alpha}\bar{P}^m(\bar{R}^k-1+\delta)^{-\alpha}\right]^{1/(1-\alpha)},
$$

$$
\frac{\bar{Y}}{\bar{K}}=\frac{\bar{R}^k-1+\delta}{\alpha\bar{P}^m},
\qquad
\frac{\bar{L}}{\bar{K}}=\left(\frac{\bar{Y}}{\bar{K}}\right)^{1/(1-\alpha)}.
$$

6. Expenditure and stocks:

$$
\bar{I}/\bar{Y}=\delta(\bar{Y}/\bar{K})^{-1},\qquad
\bar{C}/\bar{Y}=1-\bar{G}/\bar{Y}-\bar{I}/\bar{Y}.
$$

With the implementation's calibration, $\bar{G}/\bar{Y}=0.2$, $\bar{B}/\bar{Y}=2.4$, and $\bar{\Phi}=4$:

$$
\bar{B}=2.4\bar{Y},\qquad
\bar{N}=\frac{\bar{K}+\bar{B}}{\bar{\Phi}},\qquad
\bar{D}=\bar{K}+\bar{B}-\bar{N}.
$$

7. Calvo auxiliaries and fiscal variables:

$$
\bar{Z}=\frac{\bar{Y}}{1-\beta\gamma},\qquad
\bar{F}=\bar{P}^m\bar{Z},\qquad
\bar{T}=(\bar{R}^b-1)\bar{B}+\bar{G}.
$$

The steady-state sequence is `draft_extracted`; it should be checked against the online supplementary appendix before review.

## 7. Timing & Form Conventions

- **Capital timing**: $K_t$ is an end-of-period stock. Production and capital returns use $K_{t-1}$.
- **Capital quality**: $\xi_t$ scales effective beginning-of-period capital and appears in both production and capital accumulation.
- **Bank balance sheet timing**: bank net worth $N_t$, debt/deposits $D_t$, portfolio size, and shares are end-of-period objects. Portfolio return $R^p_t$ uses lagged portfolio share $\Omega_{t-1}$.
- **Government debt timing**: the archived bank-financing model uses $B_t=R^b_tB_{t-1}+G_t-T_t$ for bank-held debt.
- **Rates**: the `.mod` uses gross rates inside `exp()` variables. Some paper equations are printed in net rates; the derivation records both where relevant.
- **Form**: nonlinear/log-level Dynare implementation, not `model(linear)`. Variables in the `.mod` are logs except shocks written directly as AR(1) log deviations.
- **Validation**: Dynare was not run, by instruction.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Main equation |
|---|---|---|---|
| Endogenous | `Y` | final output $Y_t$ | (F35) |
| Endogenous | `Ym` | intermediate output $Y^m_t$ | (F6), (F10) |
| Endogenous | `L` | labor $L_t$ | (F4) |
| Endogenous | `w` | real wage $w_t$ | (F7) |
| Endogenous | `C` | consumption $C_t$ | (F1), (F35) |
| Endogenous | `U_c` | marginal utility $U_{c,t}$ | (F1) |
| Endogenous | `Lambda` | stochastic discount factor $\Lambda_t$ | (F2) |
| Endogenous | `I` | investment $I_t$ | (F8), (F35) |
| Endogenous | `K` | capital stock $K_t$ | (F9) |
| Endogenous | `Q` | capital price $Q_t$ | (F8) |
| Endogenous | `a` | technology $a_t$ | (F38) |
| Endogenous | `ksi` | capital quality $\xi_t$ | (F39) |
| Endogenous | `Pm` | real marginal cost / intermediate price $P^m_t$ | (F5), (F7) |
| Endogenous | `infl` | inflation $\pi_t$ | (F15), (F36) |
| Endogenous | `inflstar` | optimal reset inflation $\pi^\ast_t$ | (F14) |
| Endogenous | `F`, `Z` | price-setting auxiliaries | (F12), (F13) |
| Endogenous | `Dis` | price dispersion | (F11) |
| Endogenous | `Rd`, `i` | deposit and nominal policy rates | (F3), (F36), (F37) |
| Endogenous | `Rk`, `Rb`, `Rp` | capital, bank-bond, portfolio returns | (F5), (F30), (F31) |
| Endogenous | `ERk`, `ERb` | expected asset returns | (F26), (F27) |
| Endogenous | `prem`, `prem2` | private and public credit spreads | (F28), (F29) |
| Endogenous | `Phi` | bank leverage | (F20) |
| Endogenous | `portf_B`, `N`, `Om`, `D`, `B` | bank balance-sheet variables | (F21)-(F25), (F31) |
| Endogenous | `nu_k`, `nu_b`, `nu_n` | bank shadow values | (F16)-(F18) |
| Endogenous | `G`, `g`, `Gy`, `T` | fiscal variables | (F31)-(F34), (F40) |
| Exogenous | `e_ksi`, `e_g`, `e_i`, `e_a`, `e_n` | capital quality, spending, policy, TFP, and net-worth innovations | (F37)-(F40); `e_n` is declared but not active in the displayed model block |
| Parameters | `beta`, `hh`, `delta`, `varphi`, `eta_i`, `alpha`, `gam`, `epsilon` | preferences, capital, production, and Calvo parameters | -- |
| Parameters | `kappa_pi`, `kappa_y`, `rho_i` | Taylor-rule coefficients | (F37) |
| Parameters | `G_over_Y`, `B_over_Y`, `theta`, `lambda`, `chi`, `Phi_ss` | fiscal ratios and bank-friction parameters | (F16)-(F25), steady state |
| Parameters | `rho_ksi`, `rho_a`, `rho_g`, `sigma_*` | shock persistence and standard deviations | (F38)-(F40) |

Equation count: 40 F-numbered conditions in this first-pass archive equation list. Formula quality: `needs_review` because the online supplementary appendix is not available in the local source set.
