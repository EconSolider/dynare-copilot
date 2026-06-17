# NK_RA16 -- Derivation (Optimization Problems + First-Order Conditions)

> Model archive entry for `NK_RA16`. Runtime validation was not performed. Formula status: `needs_review`, because the source is MinerU OCR and the paper itself states that the derivation is relegated to Appendix A, where several formulas contain OCR damage.

Source: Ansgar Rannenberg (2016), "Bank leverage cycles and the external finance premium", *Journal of Money, Credit and Banking*, 48(8), 1569-1612. DOI: `10.1111/jmcb.12359`.

## 1. Model Overview

- **Model**: Full Rannenberg (2016) closed-economy New Keynesian DSGE model combining Gertler-Karadi bank leverage frictions with Bernanke-Gertler-Gilchrist/Christiano-Motto-Rostagno costly-state-verification frictions for nonfinancial entrepreneurs.
- **MMB implementation target**: `NK_RA16`, which the implementation cross-check describes as the full model used for Figures 1 and 2, including variable capital utilization.
- **Economy and experiment**: U.S.-calibrated quarterly model. The paper compares the full model with BGG-type, GK-type, and no-financial-sector variants under monetary policy, technology, government-spending, bank-net-worth, and entrepreneurial-net-worth disturbances. The Rep-MMB file keeps the conventional shocks for simulation.
- **Agents and blocks**: representative household, capital-goods producers, monopolistically competitive retailers with Calvo pricing and indexation, banks subject to a depositor moral-hazard constraint, entrepreneurs subject to a CSV debt contract, government, and monetary authority.
- **Form**: `model(linear)` in the implementation cross-check. The paper presents nonlinear primitives and several first-order/log-deviation conditions. Variables with hats denote log deviations from steady state; the Rep-MMB implementation stores deviations directly without hats.
- **Source scope**: Equations below are extracted from the paper-side Markdown, especially Sections 1.1-1.6 and Appendix A. The `.mod` files were used only as `implementation_cross_check`.

## 2. Optimization Problems

### 2.1 Households

Households choose consumption, one-period risk-free assets, and labor effort:

$$
\max_{\{C_t,l_t,B_t,B_t^g\}} E_t \sum_{i=0}^{\infty}\beta^i
\left[\log(C_{t+i}-hC_{t+i-1})-\frac{\chi}{1+\varphi}(l_{t+i}^s)^{1+\varphi}\right].
$$

Their nominal budget constraint is source-stated as:

$$
P_t C_t = w_tP_t l_t + P_t prof_t + R_{t-1}B_{t-1}-B_t
+ R_t^{gov}B_{t-1}^g - B_t^g.
$$

`needs_review`: Appendix A OCR around government-bond notation is noisy, but the FOCs imply deposits and government bonds are perfect substitutes.

### 2.2 Capital-Goods Producers

Capital-goods producers, owned by households, choose investment to maximize discounted profits from selling new capital at real price `Q_t`:

$$
\max_{\{I_t\}} E_t\sum_{i=0}^{\infty}\beta^i
\frac{\varrho_{t+i}}{\varrho_t}
I_{t+i}\left[
Q_{t+i}\left(1-\frac{\eta_i}{2}\left(\frac{I_{t+i}}{I_{t+i-1}}-1\right)^2\right)-1
\right].
$$

### 2.3 Retailers

Retailers hire labor and capital services in economy-wide factor markets, operate a Cobb-Douglas technology, finance shares of factor costs in advance, and set prices under Calvo contracts with indexation. A resetting retailer chooses `p_t(i)` to maximize discounted demand-weighted profits subject to CES demand and indexation.

### 2.4 Banks

Bankers are risk neutral and survive with probability `theta`. They collect deposits to fund risky interperiod loans to entrepreneurs and risk-free intraperiod working-capital loans to retailers. After collecting deposits, a banker can divert a fraction `lambda` of entrepreneurial loans, so depositors require:

$$
V_t^b(q) \ge \lambda L_t^e(q).
$$

The value of banker `q` is:

$$
V_t^b(q)=E_t\left\{\sum_{i=0}^{\infty}(1-\theta)\theta^i
\left(\frac{1}{\prod_{j=0}^i R_{t+1+j}^r}\right)N_{t+1+i}^b(q)\right\},
\qquad R_{t+1}^r=\frac{R_t}{\Pi_{t+1}}.
$$

The paper calibrates `lambda` so the incentive constraint binds locally.

### 2.5 Entrepreneurs

Risk-neutral entrepreneurs buy capital at the end of period `t` using net worth and bank loans:

$$
P_tL_t^j=P_t(Q_tK_t^j-N_t^j).
$$

The loan contract is subject to idiosyncratic lognormal risk `omega`, monitoring cost `mu`, and a cutoff `\bar{\omega}_{t+1}` satisfying:

$$
\bar{\omega}_{t+1}^j R_{t+1}^K P_tQ_tK_t^j
=R_t^L P_tL_t^j.
$$

Entrepreneurs choose leverage and the loan contract to maximize expected equity subject to the bank participation constraint.

### 2.6 Government and Monetary Authority

The government-spending block is exogenous in the implementation cross-check. Monetary policy sets the risk-free nominal rate by an interest-rate rule with smoothing, inflation response, and a response to real marginal cost as a proxy for the output gap.

## 3. First-Order Conditions

**(F1) Household marginal utility with internal habit**

$$
\varrho_t =
\frac{1}{C_t-hC_{t-1}}
-\beta h E_t\left[\frac{1}{C_{t+1}-hC_t}\right].
$$

**(F2) Household Euler equation for risk-free deposits**

$$
\varrho_t=\beta E_t\left[\varrho_{t+1}\frac{R_t}{\Pi_{t+1}}\right].
$$

**(F3) Government-bond Euler equation and asset-substitution condition**

$$
\varrho_t=\beta E_t\left[\varrho_{t+1}\frac{R_t^{gov}}{\Pi_{t+1}}\right],
\qquad R_t=R_t^{gov}.
$$

**(F4) Household labor supply**

$$
\varrho_t w_t=\chi l_t^{\varphi}.
$$

**(F5) Linear marginal utility equation used in the implementation**

$$
\hat{\varrho}_t=
\frac{1}{(1-h)(1-\beta h)}
\left[-(\hat{C}_t-h\hat{C}_{t-1})
+\beta h(\hat{C}_{t+1}-h\hat{C}_t)\right].
$$

**(F6) Linear risk-free Euler equation**

$$
\hat{R}_t+\hat{\Lambda}_{t+1}-\hat{\Pi}_{t+1}=0.
$$

**(F7) Stochastic discount factor**

$$
\hat{\Lambda}_t=\hat{\varrho}_t-\hat{\varrho}_{t-1}.
$$

**(F8) Linear labor supply**

$$
\varphi\hat{l}_t=\hat{\varrho}_t+\hat{w}_t.
$$

**(F9) Capital-goods producer investment FOC**

$$
\begin{aligned}
Q_t\left(1-\frac{\eta_i}{2}\left(\frac{I_t}{I_{t-1}}-1\right)^2\right)
&=1+Q_t\eta_i\left(\frac{I_t}{I_{t-1}}-1\right)\frac{I_t}{I_{t-1}} \\
&\quad -E_t\left[\beta\frac{\varrho_{t+1}}{\varrho_t}
Q_{t+1}\eta_i\left(\frac{I_{t+1}}{I_t}-1\right)
\left(\frac{I_{t+1}}{I_t}\right)^2\right].
\end{aligned}
$$

**(F10) Linear investment dynamics**

$$
\hat{I}_t=\frac{1}{1+\beta}
\left(\hat{I}_{t-1}+\beta\hat{I}_{t+1}+\frac{\hat{Q}_t}{\eta_i}\right).
$$

**(F11) Capital accumulation**

$$
K_t=(1-\delta)K_{t-1}
+I_t\left[1-\frac{\eta_i}{2}\left(\frac{I_t}{I_{t-1}}-1\right)^2\right].
$$

**(F12) Linear capital accumulation**

$$
\hat{K}_t=(1-\delta)\hat{K}_{t-1}+\delta\hat{I}_t.
$$

**(F13) Production function with utilization**

$$
\hat{Y}_t=\alpha(\hat{U}_t+\hat{K}_{t-1})+(1-\alpha)(\hat{a}_t+\hat{l}_t).
$$

**(F14) Retailer labor demand with working-capital cost**

$$
w_t(1+\psi_L(R_t-1))=(1-\alpha)mc_t\frac{Y_t}{l_t}.
$$

**(F15) Linear retailer labor demand**

$$
w(1+\psi_L(R-1))\hat{w}_t+w\psi_LR\hat{R}_t
=(1+\psi_L(R-1))w(\widehat{mc}_t+\hat{Y}_t-\hat{l}_t).
$$

**(F16) Retailer capital demand with working-capital cost**

$$
r_t^k(1+\psi_K(R_t-1))=\alpha mc_t\frac{Y_t}{K_{t-1}}.
$$

**(F17) Linear retailer capital demand with utilization**

$$
\frac{\hat{r}_t^k}{r^k}
+\frac{\psi_KR}{1+\psi_K(R-1)}\hat{R}_t
=\widehat{mc}_t+\hat{Y}_t-\hat{K}_{t-1}-\hat{U}_t.
$$

**(F18) Working-capital loans**

$$
L_t^r=\psi_Lw_tl_t+\psi_Kr_t^kK_{t-1}.
$$

**(F19) New Keynesian Phillips curve**

$$
\hat{\Pi}_t=
\frac{1}{1+\beta\gamma_P}
\left[
\beta\hat{\Pi}_{t+1}+\gamma_P\hat{\Pi}_{t-1}
+\frac{(1-\xi^P\beta)(1-\xi^P)}{\xi^P}\widehat{mc}_t
\right].
$$

**(F20) Bank leverage identity**

$$
\hat{\phi}_t^b=\hat{L}_t^e-\hat{N}_t^b.
$$

**(F21) Existing bankers' net worth**

$$
N_{et}^b=\theta z_{t-1,t}N_{t-1}^b.
$$

**(F22) Aggregate bank net worth**

$$
N_t^b=N_{et}^b+N_n^b.
$$

**(F23) Bank asset growth**

$$
z_{t-1,t}=
\frac{[(R_t^b-R_{t-1})\phi_{t-1}^b+R_{t-1}]}{\Pi_t}\exp(e_t^z).
$$

**(F24) Bankers' consumption**

$$
C_t^b=(1-\theta)z_{t-1,t}N_{t-1}^b.
$$

**(F25) Forward-looking bank leverage condition**

$$
\hat{\phi}_t^b
=E_t\left[
\theta\beta^2z^2\hat{\phi}_{t+1}^b
+\phi^b\frac{R^b}{R}\left(\hat{R}_{t+1}^b-\hat{R}_t\right)
\right].
$$

**(F26) Bank balance sheet for entrepreneurial loans**

$$
L_t^e=\phi_t^bN_t^b.
$$

**(F27) Return to capital**

$$
R_{t+1}^K=\Pi_{t+1}\frac{r_{t+1}^k+Q_{t+1}(1-\delta)}{Q_t}.
$$

**(F28) Entrepreneur leverage**

$$
\phi_t^e=\frac{Q_tK_t}{N_t}.
$$

**(F29) Entrepreneurial bank-participation constraint**

$$
(\phi_t^e-1)E_tR_{t+1}^b
=\phi_t^eE_t\left[
R_{t+1}^K\left(\Gamma(\bar{\omega}_{t+1})-\mu G(\bar{\omega}_{t+1})\right)
\right].
$$

**(F30) Entrepreneur optimal-contract FOC for leverage**

$$
E_t\left[R_{t+1}^K(1-\Gamma(\bar{\omega}_{t+1}))\right]
+\xi_tE_t\left[
R_{t+1}^K(\Gamma(\bar{\omega}_{t+1})-\mu G(\bar{\omega}_{t+1}))
-R_{t+1}^b
\right]=0.
$$

**(F31) Entrepreneur optimal-contract FOC for the cutoff**

$$
E_t\left[
-\Gamma'(\bar{\omega}_{t+1})
+\xi_t\left(\Gamma'(\bar{\omega}_{t+1})-\mu G'(\bar{\omega}_{t+1})\right)
\right]=0.
$$

**(F32) Entrepreneur optimal-contract participation FOC**

$$
E_t\left[
\phi_t^e R_{t+1}^K(\Gamma(\bar{\omega}_{t+1})-\mu G(\bar{\omega}_{t+1}))
-R_{t+1}^b(\phi_t^e-1)
\right]=0.
$$

**(F33) Linear spread from capital return to bank-asset return**

$$
E_t\hat{R}_{t+1}^K-E_t\hat{R}_{t+1}^b
=\chi^l(\hat{K}_t+\hat{Q}_t-\hat{N}_t).
$$

**(F34) Entrepreneur equity**

$$
V_t=Q_{t-1}K_{t-1}\frac{R_t^K}{\Pi_t}
\left[1-\Gamma(\bar{\omega}_t)\right]\exp(e_t^N).
$$

`needs_review`: In the main text, equation (15) writes the integral form; Appendix A29 gives the compact `1-\Gamma` form. OCR around multiplication by `Q_{t-1}K_{t-1}` is fragile.

**(F35) Entrepreneur net worth**

$$
N_t=\gamma V_t+W^e.
$$

**(F36) Entrepreneur consumption**

$$
C_t^e=(1-\gamma)V_t.
$$

**(F37) Entrepreneur cutoff**

$$
\bar{\omega}_t=
\frac{R_{t-1}^L(Q_{t-1}K_{t-1}-N_{t-1})}
{R_t^KQ_{t-1}K_{t-1}}.
$$

**(F38) Average return on bank loans to entrepreneurs**

$$
\begin{aligned}
R_t^b
&=R_{t-1}^L\int_{\bar{\omega}_t}^{\infty}f(\omega^j)d\omega^j \\
&\quad +(1-\mu)R_t^K
\frac{\phi_{t-1}^e}{\phi_{t-1}^e-1}
\int_0^{\bar{\omega}_t}\omega^j f(\omega^j)d\omega^j .
\end{aligned}
$$

**(F39) Linear loan-rate/cutoff relation**

$$
\widehat{\bar{\omega}R^K}_t=\hat{R}_t^L+\frac{1}{\phi^e-1}\hat{\phi}_t^e.
$$

**(F40) Monetary policy rule**

$$
R_t-1=(1-\rho_i)\left[
R-1+\psi_{\pi}(\log\Pi_t-\log\Pi)
+\psi_y(\log GDP_t-\log GDP_t^*)
\right]
+\rho_i(R_{t-1}-1)+e_t^i.
$$

In the implementation, the output-gap term is proxied by real marginal cost:

$$
R\hat{R}_t=(1-\rho_i)(\psi_{\pi}\hat{\Pi}_t+\psi_y\widehat{mc}_t)
+\rho_iR\hat{R}_{t-1}+e_t^i.
$$

## 4. Market Clearing & Identities

**(F41) Aggregate private consumption**

$$
C_t^P=C_t+C_t^e+C_t^b.
$$

**(F42) Resource constraint with monitoring and utilization costs**

$$
Y_t=S_t\left[
I_t+C_t^P
+\frac{R_t^K}{\Pi_t}Q_{t-1}K_{t-1}\mu
\int_0^{\bar{\omega}_t}\omega f(\omega)d\omega
\right].
$$

The implementation cross-check adds the variable-utilization cost term in the linear resource constraint.

**(F43) GDP identity**

$$
GDP_t=I_t+C_t+G_t.
$$

**(F44) Aggregate loans**

$$
L_t=L_t^e+L_t^r.
$$

**(F45) Price-dispersion recursion**

$$
S_t=(1-\xi^P)\left(\frac{\Pi_t}{\Pi_t^*}\right)^{\varepsilon}
+\xi^P\left(\frac{\Pi_t}{\Pi_{t-1}^{\gamma_P}\Pi^{1-\gamma_P}}\right)^{\varepsilon}S_{t-1}.
$$

**(F46) Goods production**

$$
Y_t=K_{t-1}^{\alpha}(A_tl_t)^{1-\alpha}.
$$

**(F47) Aggregate bank-loan accounting**

$$
P_tL_t^e(q)=P_tN_t^b(q)+B_t(q).
$$

## 5. Exogenous Processes

**(F48) Technology shock**

$$
\hat{a}_t=\rho_a\hat{a}_{t-1}-e_t^a.
$$

**(F49) Government-spending shock**

$$
\hat{g}_t=\rho_g\hat{g}_{t-1}-e_t^g.
$$

**(F50) Monetary policy innovation**

$$
e_t^i \sim iid(0,\sigma_i^2).
$$

**(F51) Bank net-worth shock**

$$
e_t^z \sim iid.
$$

**(F52) Entrepreneurial net-worth shock**

$$
e_t^N \sim iid.
$$

`needs_review`: The Rep-MMB simulation declares monetary, technology, and government innovations. The paper uses bank- and entrepreneur-net-worth shocks for crisis experiments, but the cross-check implementation does not keep them as simulated shocks in the final `shocks` block.

## 6. Steady-State Solution

The implementation cross-check stores the steady-state calibration directly. The paper describes targets and reports calibration tables rather than deriving a closed-form sequence for every financial-contract object. The following ordered solution records the implementation-cross-check calibration logic and is therefore `needs_review` for source promotion:

1. Set calibrated policy and preference parameters: `beta=0.9958`, `h=0.6`, `varphi=0.25`, `alpha=0.33`, `delta=0.025`, `eta_i=4`, `epsilon=6`, `xi_p=0.67`, `gamma_p=0`, `psi_L=psi_K=1`.
2. Set financial-contract parameters and targets: `sigma=0.35`, `mu=0.2981`, entrepreneurial survival `gamma=0.975`, banker survival `theta=0.9915`, government share `G/Y=0.2`, default rate target `brate=0.0075`, bank leverage `phi_b=1/0.125`, and bank spread target `spread_RbR=(1.002)^{1/4}`.
3. Set quarterly inflation and nominal risk-free steady state:

$$
\Pi=(1+0.0223)^{1/4},\qquad R=\frac{\Pi}{\beta}.
$$

4. Construct the lognormal default terms:

$$
\bar{\omega}=\exp(\sigma\Phi^{-1}(brate)-0.5\sigma^2),\quad
F=\Phi\left(\frac{\log\bar{\omega}+0.5\sigma^2}{\sigma}\right),
\quad G=\Phi\left(\frac{\log\bar{\omega}+0.5\sigma^2}{\sigma}-\sigma\right).
$$

5. Use derivatives of `F`, `G`, and `Gamma` to compute the contract multiplier `xi`, capital-bank spread `spread_RkRb`, entrepreneurial leverage `phi_e`, and `chi_e`, the linear coefficient in (F33).
6. Set:

$$
R^b=spread_{RbR}R,\qquad R^K=R^b spread_{RkRb},\qquad
R^L=\frac{\bar{\omega}R^K}{1-1/\phi_e}.
$$

7. Set markup and marginal cost:

$$
X=\frac{\varepsilon}{\varepsilon-1},\qquad mc=\frac{\varepsilon-1}{\varepsilon},\qquad Q=1.
$$

8. Solve capital-labor ratios from factor demand with working-capital costs, then normalize labor `l=1/3`, compute `K`, `Y`, `I=delta K`, and `G=0.2Y`.
9. Compute entrepreneur variables:

$$
N=\frac{K}{\phi_e},\qquad L^e=K-N,\qquad
V=K\frac{R^K}{\Pi}(1-\Gamma),\qquad C^e=(1-\gamma)V.
$$

10. Compute working-capital loans and bank variables:

$$
L^r=\psi_Lwl+\psi_Kr^kK,\quad L=L^e+L^r,\quad
N^b=\frac{L^e}{\phi_b},\quad C^b=(1-\theta)zN^b.
$$

11. Residual household consumption and aggregate consumption are:

$$
C=Y-I-C^e-C^b-G-\mu G(\bar{\omega})\frac{R^K}{\Pi}K,
\qquad C^P=C+C^e+C^b.
$$

12. In `model(linear)`, all hatted/deviation variables have zero steady state after these levels and ratios are assigned.

## 7. Timing & Form Conventions

- **Form**: `model(linear)`. The derivation uses hatted variables for log deviations; the MMB implementation uses deviation variable names directly.
- **Capital timing**: `K_t` is the end-of-period stock purchased at `t`; production at `t` uses `K_{t-1}` and utilization `U_t`.
- **Bank loans**: Entrepreneurial loans made at `t-1` mature at the beginning of `t`; bank net worth at `t` depends on `R_t^b`, `R_{t-1}`, `L_{t-1}^e`, and `N_{t-1}^b`.
- **Entrepreneur net worth**: `N_t` is end-of-period entrepreneurial net worth after surviving entrepreneurs retain equity and new entrepreneurs receive transfer `W^e`.
- **Loan rate**: The full model uses a non-state-contingent loan rate determined at `t`; the cutoff at `t+1` moves with the realized capital return.
- **Inflation and rates**: `Pi_t=P_t/P_{t-1}`. The paper writes nominal rates; the implementation reports annualized `R4=4R`, `Pi4=4Pi`, and spreads.
- **Flexible-price counterpart**: The implementation carries a flex-price copy of the model to define `outputgap`; this archive records the core sticky-price model and notes the flex block as implementation detail.
- **Runtime validation**: No Dynare, Rep-MMB, BK, or IRF validation was run.

## 8. Variable & Parameter Reference Table

### Endogenous Variables

| Symbol | Meaning | Main equation(s) |
|---|---|---|
| `Y` | output | (F13), (F42), (F46) |
| `GDP` | GDP | (F43) |
| `I` | investment | (F9), (F10), (F11) |
| `K` | capital stock | (F11), (F12) |
| `l` | labor | (F4), (F8), (F14) |
| `U` | utilization rate | (F13), implementation cross-check |
| `Cp` | aggregate private consumption | (F41) |
| `C` | household consumption | (F1), (F2), (F41) |
| `Ce` | entrepreneur consumption | (F36) |
| `Cb` | banker consumption | (F24) |
| `varrho` | household marginal utility | (F1), (F5) |
| `Lambda` | stochastic discount factor | (F7) |
| `R` | risk-free nominal/deposit rate | (F2), (F6), (F40) |
| `Rk` | return on capital | (F27), (F33) |
| `rk` | rental/marginal product of capital | (F16), (F17), (F27) |
| `Rb` | return on bank entrepreneurial-loan portfolio | (F23), (F25), (F38) |
| `Rl` | loan rate to entrepreneurs | (F37), (F39) |
| `w` | real wage | (F4), (F14), (F15) |
| `a` | technology | (F13), (F48) |
| `Q` | price of capital | (F9), (F27), (F28) |
| `Pi` | inflation | (F2), (F19), (F40), (F45) |
| `mc` | real marginal cost | (F14), (F16), (F19), (F40) |
| `N` | entrepreneurial net worth | (F28), (F35) |
| `V` | entrepreneur equity/value | (F34), (F35), (F36) |
| `phi_e` | entrepreneurial leverage | (F28), (F33) |
| `omega_bar_prime` | cutoff-return composite in implementation | (F39) |
| `L` | total loans | (F44) |
| `Lr` | retailer working-capital loans | (F18) |
| `Le` | entrepreneurial loans | (F26), (F44), (F47) |
| `g` | government spending deviation | (F49) |
| `Nb` | bank net worth | (F21), (F22), (F26) |
| `phi_b` | bank leverage | (F20), (F25), (F26) |
| `z` | bank net-worth growth | (F23) |
| `spread_RlR`, `spread_RkR`, `spread_RbR`, `spread_RkRb` | annualized spreads | definitions from implementation |
| `R4`, `Pi4` | annualized risk-free rate and inflation | implementation definitions |

### Exogenous Shocks

| Symbol | Meaning | Source status |
|---|---|---|
| `e_i` / `interest_` | monetary policy innovation | source-stated and implementation cross-check |
| `e_a` | technology innovation | source-stated and implementation cross-check |
| `e_g` / `fiscal_` | government spending innovation | implementation cross-check |
| `e_z` | bank net-worth shock | source-stated; not retained in final Rep-MMB `shocks` block |
| `e_N` | entrepreneurial net-worth shock | source-stated; not retained in final Rep-MMB `shocks` block |

### Parameters

| Symbol | Meaning |
|---|---|
| `beta` | household discount factor |
| `h` | internal habit |
| `varphi` | inverse Frisch elasticity |
| `chi` | labor-disutility weight |
| `alpha` | capital share |
| `delta` | depreciation |
| `eta_i` | investment-adjustment-cost curvature |
| `epsilon` | CES elasticity across varieties |
| `xi_p` | Calvo non-reoptimization probability |
| `gamma_p` | price-indexation parameter |
| `theta` | banker survival probability |
| `gamma` | entrepreneur survival probability |
| `lambda` | divertible share in bank moral-hazard constraint |
| `psi_L`, `psi_K` | working-capital finance shares for labor and capital costs |
| `sigma` | standard deviation of idiosyncratic entrepreneur productivity |
| `mu` | monitoring/bankruptcy cost |
| `psi_pi`, `psi_y`, `rho_i` | Taylor-rule parameters |
| `rho_a`, `rho_g` | shock persistence |
| `G_over_Y` | steady-state government-spending share |
| `brate` | target default rate |
| `phi_b_ss`, `phi_e_ss` | bank and entrepreneur steady-state leverage |
| `spread_RbR_ss`, `spread_RkRb_ss` | steady-state spreads |
| `c_U` | utilization-cost parameter, from author-provided implementation cross-check |
