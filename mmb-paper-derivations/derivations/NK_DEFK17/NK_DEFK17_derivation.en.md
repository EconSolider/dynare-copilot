# NK_DEFK17 - Derivation

> Model archive draft for `NK_DEFK17`. Runtime validation was not performed. Equations marked `needs_review` rely on paper-body summaries plus the local implementation cross-check because the paper body delegates the detailed price, wage, and capital-producer derivations to the online appendix, and no normalized appendix file exists in this repository.

## 1. Model Overview

- **Model**: Del Negro, Eggertsson, Ferrero, and Kiyotaki (2017), "The Great Escape? A Quantitative Evaluation of the Fed's Liquidity Facilities."
- **Source**: `raw/mmb_mineru/runs/nk_defk17__the_great_escape_a_quantitative_evaluation_of_the_fed_s_liquidity_facili__b6479bed/full.md`; raw PDF path checked at `raw/mmb_papers/The Great Escape? A Quantitative Evaluation of the Fed's Liquidity Facilities.pdf`.
- **Agents**: representative household with entrepreneurs and workers, government, intermediate and final goods firms, labor agencies/unions, and capital producers.
- **Core friction**: Kiyotaki-Moore liquidity frictions. Entrepreneurs face a borrowing constraint on new equity issuance and a resaleability constraint on existing equity; government paper is fully liquid.
- **Policy experiment**: deterministic perfect-foresight liquidity shock to private-paper resaleability `phi`, with conventional Taylor-rule monetary policy subject to the zero lower bound and unconventional government purchases of private paper.
- **Form**: nonlinear model with occasionally binding ZLB in the paper. The local MMB implementation uses a nonlinear Dynare `model` block and a `max(...,1)` nominal-rate rule.

## 2. Optimization Problems

### Household

Aggregate household consumption is

\[
C_t = \int_0^1 C_t(j)\,dj.
\]

The representative household objective is

\[
E_t \sum_{s=t}^{\infty}\beta^{s-t}
\left[
\frac{C_s^{1-\sigma}}{1-\sigma}
- \frac{\omega}{1+\nu}\int_{\varkappa}^{1} H_s(j)^{1+\nu}\,dj
\right].
\]

Net equity is defined by claims on other households' capital, own capital, and claims issued on own capital:

\[
N_t = N_t^O + K_t - N_t^I.
\]

Each member's flow of funds is

\[
C_t(j) + p_t^I I_t(j) + q_t\left[N_{t+1}(j)-I_t(j)\right] + \frac{B_{t+1}(j)}{P_t}
= \left[R_t^k+(1-\delta)q_t\right]N_t + \frac{R_{t-1}B_t}{P_t}
+ \frac{W_t(j)}{P_t}H_t(j)-\tau_t.
\]

Financial constraints are

\[
N_{t+1}(j) \ge (1-\theta)I_t(j) + (1-\phi_t)(1-\delta)N_t,
\]

\[
B_{t+1}(j) \ge 0.
\]

### Entrepreneurs

For entrepreneurs, the paper focuses on constrained equilibria with \(q_t>p_t^I\). The financing constraints bind:

\[
N_{t+1}(j) = (1-\theta)I_t(j) + (1-\phi_t)(1-\delta)N_t(j),
\]

\[
B_{t+1}(j)=0,\qquad C_t(j)=0.
\]

Individual investment is

\[
I_t(j)=
\frac{\left[R_t^k+(1-\delta)q_t\phi_t\right]N_t
+ \frac{R_{t-1}B_t}{P_t}-\tau_t}
{p_t^I-\theta q_t}.
\]

Aggregate investment is

\[
I_t=\varkappa
\frac{\left[R_t^k+(1-\delta)q_t\phi_t\right]N_t
+ \frac{R_{t-1}B_t}{P_t}-\tau_t}
{p_t^I-\theta q_t}.
\]

### Workers, wage setters, firms, and capital producers

Workers' asset and consumption choices are chosen at the household level. Wages are set by unions under Calvo wage stickiness. Final goods firms aggregate intermediate goods; intermediate producers use capital and labor, pay a fixed cost, and set prices under Calvo price stickiness. Capital producers transform final goods into investment goods with adjustment cost \(S(I_t/I)\) where \(S(1)=S'(1)=0\) and \(S''(1)>0\).

The paper body states these production, price, wage, and capital-producer blocks are standard CEE/SW blocks and refers details to online Appendices B.1-B.3. The local `.mod` cross-check supplies recursive equations, but those formulas are marked `needs_review` where not printed in the paper body.

## 3. First-Order Conditions

- **(F1) Bond Euler equation**:

\[
C_t^{-\sigma} =
\beta E_t\left\{
C_{t+1}^{-\sigma}
\frac{R_t}{\pi_{t+1}}
\left[
1+\frac{\varkappa(q_{t+1}-p_{t+1}^I)}
{p_{t+1}^I-\theta q_{t+1}}
\right]
\right\}.
\]

- **(F2) Equity Euler equation**:

\[
C_t^{-\sigma} =
\beta E_t\left\{
C_{t+1}^{-\sigma}
\left[
\frac{R_{t+1}^k+(1-\delta)q_{t+1}}{q_t}
+ \frac{\varkappa(q_{t+1}-p_{t+1}^I)}
{p_{t+1}^I-\theta q_{t+1}}
\frac{R_{t+1}^k+(1-\delta)\phi_{t+1}q_{t+1}}{q_t}
\right]
\right\}.
\]

- **(F3) Investment financing equation**:

\[
(p_t^I-\theta q_t)I_t =
\varkappa\left(
\left[R_t^k+\phi_t(1-\delta)q_t\right]N_t
+ \frac{R_{t-1}B_t}{P_t}-\tau_t
\right).
\]

- **(F4) Price of investment goods** `needs_review`:

\[
p_t^I = 1+S\left(\frac{I_t}{I}\right)+S'\left(\frac{I_t}{I}\right)\frac{I_t}{I}.
\]

- **(F5) Investment adjustment cost definition** `needs_review`:

\[
S_t = \frac{s_0}{2}\left(\frac{I_t}{I}-1\right)^2.
\]

- **(F6) Investment adjustment cost derivative** `needs_review`:

\[
S'_t = s_0\left(\frac{I_t}{I}-1\right).
\]

- **(F7) Production function with price dispersion and fixed cost** `needs_review`:

\[
Y_t\Delta_{p,t} = A K_{t-1}^{\gamma}H_t^{1-\gamma}-\Gamma.
\]

- **(F8) Marginal product of capital** `needs_review`:

\[
r_t^K = \gamma mc_t A\left(\frac{H_t}{K_{t-1}}\right)^{1-\gamma}.
\]

- **(F9) Marginal product of labor / real wage** `needs_review`:

\[
w_t = (1-\gamma)mc_t A\left(\frac{K_{t-1}}{H_t}\right)^{\gamma}.
\]

- **(F10) Rental income identity** `needs_review`:

\[
R_t^K K_{t-1} = Y_t - w_tH_t + \left[p_t^I-(1+S_t)\right]I_t.
\]

- **(F11) Price Phillips auxiliary relation** `needs_review`:

\[
X_{1p,t}=X_{2p,t}
\left(
\frac{1-\xi_p\pi_t^{1/\lambda_p}}{1-\xi_p}
\right)^{-\lambda_p}.
\]

- **(F12) Present value of real marginal costs** `needs_review`:

\[
X_{1p,t}=(1+\lambda_p)C_t^{-\sigma}Y_tmc_t
+\beta\xi_p E_t\left[\pi_{t+1}^{(1+\lambda_p)/\lambda_p}X_{1p,t+1}\right].
\]

- **(F13) Present value of real marginal revenues** `needs_review`:

\[
X_{2p,t}=C_t^{-\sigma}Y_t
+\beta\xi_p E_t\left[\pi_{t+1}^{1/\lambda_p}X_{2p,t+1}\right].
\]

- **(F14) Wage Phillips auxiliary relation** `needs_review`:

\[
X_{1w,t}=X_{2w,t}
\left(
\frac{1-\xi_w\pi_{w,t}^{1/\lambda_w}}{1-\xi_w}
\right)^{-\left[\lambda_w+(1+\lambda_w)\nu\right]}.
\]

- **(F15) Present value of marginal disutility of work** `needs_review`:

\[
X_{1w,t}=(1+\lambda_w)H_t^{1+\nu}
+\beta\xi_w E_t\left[\pi_{w,t+1}^{(1+\lambda_w)(1+\nu)/\lambda_w}X_{1w,t+1}\right].
\]

- **(F16) Present value of real wage bill** `needs_review`:

\[
X_{2w,t}=C_t^{-\sigma}w_tH_t
+\beta\xi_w E_t\left[\pi_{w,t+1}^{1/\lambda_w}X_{2w,t+1}\right].
\]

- **(F17) Real wage and inflation relation** `needs_review`:

\[
w_t\pi_t=w_{t-1}\pi_{w,t}.
\]

## 4. Market Clearing & Identities

- **(F18) Aggregate net equity**:

\[
N_{t+1}=\int N_{t+1}(j)\,dj.
\]

- **(F19) Aggregate bonds**:

\[
B_{t+1}=\int B_{t+1}(j)\,dj.
\]

- **(F20) Capital accumulation**:

\[
K_{t+1}=(1-\delta)K_t+\int I_t(j)\,dj.
\]

- **(F21) Government portfolio share in capital**:

\[
K_{t+1}=N_{t+1}+N_{t+1}^g.
\]

- **(F22) Resource constraint**:

\[
Y_t=C_t+\left[1+S\left(\frac{I_t}{I}\right)\right]I_t.
\]

- **(F23) Government budget constraint**:

\[
q_tN_{t+1}^g+\frac{R_{t-1}B_t}{P_t}
=\tau_t+\left[R_t^k+(1-\delta)q_t\right]N_t^g+\frac{B_{t+1}}{P_t}.
\]

- **(F24) Fiscal rule**:

\[
\tau_t-\tau =
\psi_{\tau}
\left[
\left(\frac{R_{t-1}B_t}{P_t}-\frac{RB}{P}\right)
-q_tN_t^g
\right].
\]

- **(F25) Price dispersion law of motion** `needs_review`:

\[
\Delta_{p,t}=
\xi_p\Delta_{p,t-1}\pi_t^{(1+\lambda_p)/\lambda_p}
+(1-\xi_p)
\left(
\frac{1-\xi_p\pi_t^{1/\lambda_p}}{1-\xi_p}
\right)^{1+\lambda_p}.
\]

- **(F26) Real rate identity**:

\[
rr_t=\frac{R_t}{E_t\pi_{t+1}}.
\]

- **(F27) Expected return on illiquid equity**:

\[
ERQ_t=E_t\left[\frac{R_{t+1}^K+(1-\delta)q_{t+1}}{q_t}\right].
\]

- **(F28) Equity-bond spread**:

\[
Spr_t=ERQ_t-rr_t.
\]

- **(F29) Convenience yield**:

\[
CY_t =
E_t\left[
\frac{\varkappa(q_{t+1}-p_{t+1}^I)}
{p_{t+1}^I-\theta q_{t+1}}
\right].
\]

- **(F30) Value of capital**:

\[
QK_t=q_tK_{t-1}.
\]

- **(F31) GDP measure**:

\[
GDP_t=C_t+p_t^I I_t.
\]

- **(F32) No-convenience-yield security Euler equation**:

\[
C_t^{-\sigma}=\beta E_t\left\{C_{t+1}^{-\sigma}\frac{R_t^0}{\pi_{t+1}}\right\}.
\]

## 5. Exogenous Processes

- **(F33) Taylor rule with zero lower bound**:

\[
R_t=\max\left\{
R\pi_t^{\psi_{\pi}}\left(\frac{Y_t}{Y}\right)^{\psi_y},
1
\right\}.
\]

- **(F34) Unconventional credit policy rule**:

\[
N_{t+1}^g=\psi_k(\phi_t-\phi).
\]

- **(F35) Liquidity shock process**:

\[
\phi_t=(1-\rho_{\phi})\phi+\rho_{\phi}\phi_{t-1}+\varepsilon_{\phi,t}.
\]

## 6. Steady-State Solution

The paper calibrates the model at quarterly frequency. The main steady-state targets are the convenience yield, liquid-asset supply relative to output, real rate, liquidity share, labor share, and investment-output ratio. The paper reports exact calibration targets and model-implied values, but the paper body does not provide a complete closed-form steady-state derivation for every recursive pricing and wage block.

A source-backed steady-state skeleton is:

1. Set \(\bar{\phi}=0.309\), \(\theta=0.792\), \(\beta=0.993\), \(\varkappa=0.009\), \(\delta=0.024\), \(\gamma=0.340\).
2. Set \(\bar{\pi}=1\) and \(\bar{\pi}_w=1\).
3. Use the steady-state real return and convenience-yield targets to pin down liquid and illiquid asset returns.
4. Set \(\bar{N}^g=0\) by the steady-state unconventional-policy rule.
5. Use \(\bar{K}=\bar{N}\) from (F21) when \(\bar{N}^g=0\).
6. Use \(\bar{I}=\delta\bar{K}\) from (F20).
7. Use \(\bar{Y}=\bar{C}+\bar{I}\) from (F22), because \(S(1)=0\).
8. Use the production block, wage block, and price block to solve \(\bar{mc}\), \(\bar{w}\), \(\bar{H}\), \(\bar{Y}\), and recursive auxiliary variables.

Implementation cross-check steady-state values in `NK_DEFK17_rep.mod` include `Y_ss=2.6779`, `C_ss=1.9685`, `I_ss=0.70945`, `K_ss=29.2064`, `H_ss=0.90345`, `Q_ss=1.0223`, `R_ss=1.0055`, `phi_ss=0.3092`, `LY_ss=1.6`, and `tau_ss=0.023387`. These are not independently source-validated from a normalized appendix and remain `needs_review`.

## 7. Timing & Form Conventions

- The model is nonlinear. The paper solves nonlinear perfect-foresight paths and accounts for the zero lower bound endogenously.
- Capital in production is predetermined: production uses \(K_{t-1}\), and accumulation determines \(K_t\) or \(K_{t+1}\) depending on the dating convention.
- Net equity and government private-paper holdings are stock variables. The paper states aggregate capital is owned by households and government according to \(K_{t+1}=N_{t+1}+N_{t+1}^g\).
- Nominal bonds are dated so beginning-of-period debt service appears as \(R_{t-1}B_t/P_t\).
- The liquidity shock is the resaleability parameter \(\phi_t\); the MMB implementation uses `e_phi` as the only exogenous innovation.
- The local MMB implementation shifts several paper equations by one period relative to paper notation, for example using `K(-1)` in production and `N(-1)` in the investment equation. This is recorded as an implementation timing cross-check, not as paper-side provenance.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Equation anchor |
|---|---|---|---|
| Endogenous | `C`, \(C_t\) | Aggregate household consumption | (F1), (F22) |
| Endogenous | `Inv`, \(I_t\) | Investment | (F3), (F20), (F22) |
| Endogenous | `S_Inv`, \(S_t\) | Investment adjustment cost | (F5), (F22) |
| Endogenous | `dS_Inv`, \(S'_t\) | Adjustment-cost derivative | (F6) |
| Endogenous | `H`, \(H_t\) | Labor input | (F7), (F9), (F15) |
| Endogenous | `Y`, \(Y_t\) | Output | (F7), (F22), (F33) |
| Endogenous | `tau`, \(\tau_t\) | Taxes / primary surplus | (F23), (F24) |
| Endogenous | `K`, \(K_t\) | Capital stock | (F20), (F21) |
| Endogenous | `N`, \(N_t\) | Private net equity | (F18), (F21) |
| Endogenous | `Ng`, \(N_t^g\) | Government private-paper holdings | (F21), (F34) |
| Endogenous | `LY` | Government debt-output state | (F23), (F24) |
| Endogenous | `Q`, \(q_t\) | Equity / capital value | (F2), (F23), (F30) |
| Endogenous | `pI`, \(p_t^I\) | Price of investment goods | (F3), (F4) |
| Endogenous | `RK`, \(R_t^K\) | Rental/dividend return on capital | (F2), (F10) |
| Endogenous | `rK`, \(r_t^K\) | Marginal product / rental rate | (F8) |
| Endogenous | `rr`, \(rr_t\) | Real liquid return | (F26) |
| Endogenous | `rr0`, \(R_t^0/E_t\pi_{t+1}\) | Return on no-convenience security | (F32) |
| Endogenous | `ERQ`, \(ERQ_t\) | Expected return on illiquid equity | (F27) |
| Endogenous | `w`, \(w_t\) | Real wage | (F9), (F17) |
| Endogenous | `infl_w`, \(\pi_{w,t}\) | Wage inflation | (F14), (F17) |
| Endogenous | `X1w`, \(X_{1w,t}\) | Wage-recursion numerator | (F14), (F15) |
| Endogenous | `X2w`, \(X_{2w,t}\) | Wage-recursion denominator | (F14), (F16) |
| Endogenous | `mc`, \(mc_t\) | Real marginal cost | (F7), (F12) |
| Endogenous | `infl`, \(\pi_t\) | Price inflation | (F11), (F25), (F33) |
| Endogenous | `X1p`, \(X_{1p,t}\) | Price-recursion numerator | (F11), (F12) |
| Endogenous | `X2p`, \(X_{2p,t}\) | Price-recursion denominator | (F11), (F13) |
| Endogenous | `Delta_p`, \(\Delta_{p,t}\) | Price dispersion | (F7), (F25) |
| Endogenous | `CY`, \(CY_t\) | Convenience yield | (F29) |
| Endogenous | `Spr`, \(Spr_t\) | Illiquid-equity spread | (F28) |
| Endogenous | `phi`, \(\phi_t\) | Resaleability / liquidity state | (F34), (F35) |
| Endogenous | `QK`, \(q_tK_{t-1}\) | Capital value | (F30) |
| Endogenous | `GDP` | GDP measurement variable | (F31) |
| Exogenous | `e_phi`, \(\varepsilon_{\phi,t}\) | Liquidity shock innovation | (F35) |
| Parameter | `beta` | Discount factor | (F1), (F2) |
| Parameter | `sigma` | Relative risk aversion | (F1), (F2) |
| Parameter | `nu` | Inverse Frisch elasticity | (F15) |
| Parameter | `kappa`, \(\varkappa\) | Probability of investment opportunity | (F3), (F29) |
| Parameter | `theta` | Borrowing constraint | (F3), (F29) |
| Parameter | `gamma` | Capital share | (F7), (F8), (F9) |
| Parameter | `delta` | Depreciation | (F20) |
| Parameter | `s0` | Investment adjustment-cost scale | (F5), (F6) |
| Parameter | `lambda_w`, `lambda_p` | Wage and price markup parameters | (F11)-(F16) |
| Parameter | `xi_w`, `xi_p` | Calvo wage and price probabilities | (F11)-(F16), (F25) |
| Parameter | `psi_p`, `psi_y` | Taylor rule responses | (F33) |
| Parameter | `rho_i` | Interest-rate smoothing in implementation | (F33) |
| Parameter | `psi_k` | Liquidity intervention coefficient | (F34) |
| Parameter | `psi_tau` | Fiscal feedback coefficient | (F24) |
| Parameter | `rho_phi` | Liquidity-shock persistence | (F35) |
| Parameter | `Gamma` | Fixed cost in production | (F7) |
