# NK_GK09lin - Derivation

> First-pass private archive derivation for the MMB `model(linear)` implementation of Gertler and Karadi, "A Model of Unconvetional Monetary Policy." Runtime validation was not performed. Equations marked `needs_review` require source-level checking before promotion beyond draft status.

Provenance: `model_id=NK_GK09lin`; authors Mark Gertler and Peter Karadi; year 2009 in MMB metadata, published in Journal of Monetary Economics 58(1), pp. 17-34; DOI `10.1016/j.jmoneco.2010.10.004`; primary Markdown `raw/mmb_mineru/runs/nk_gk09lin_nk_gk11__a_model_of_unconvetional_monetary_policy__e6192938/full.md`; raw PDF `raw/mmb_papers/A Model of Unconvetional Monetary Policy.pdf`; MinerU run ids `e6192938-5688-49c7-9621-66ca2478274f`, `7766fa43-5b60-4812-9445-88d48b0fe6cf`.

## 1. Model Overview

- **Model**: New Keynesian DSGE model with financial intermediaries, endogenous intermediary balance-sheet constraints, capital-quality shocks, and central-bank credit intermediation.
- **MMB entry**: `NK_GK09lin`, a linearized MMB implementation (`model(linear)`) of the Gertler-Karadi framework.
- **Agents**: representative household with workers and bankers, financial intermediaries, competitive intermediate-good firms, capital producers, monopolistically competitive retailers, fiscal authority, and central bank.
- **Core mechanism**: intermediary leverage is limited by an incentive constraint; shocks that reduce intermediary net worth tighten credit supply, raise the excess return on capital, depress asset prices and investment, and amplify real downturns.
- **Form**: the paper writes nonlinear equilibrium conditions and later approximates for policy analysis; the MMB implementation is a log-linear or linear-deviation system around a deterministic steady state. The derivation below preserves the paper-side nonlinear conditions and records implementation-linear variables in Section 8.

## 2. Optimization Problems

### 2.1 Household

The household chooses consumption, labor, and one-period riskless bonds, internalizing habit formation:

\[
\max_{\{C_{t+i},L_{t+i},B_{t+1+i}\}} E_t\sum_{i=0}^{\infty}\beta^i
\left[\log(C_{t+i}-hC_{t+i-1})-\frac{\chi}{1+\varphi}L_{t+i}^{1+\varphi}\right].
\]

The period budget constraint is:

\[
C_t = W_t L_t + \Pi_t + T_t + R_t B_t - B_{t+1}.
\]

### 2.2 Financial Intermediary

Intermediary \(j\) holds claims \(S_{jt}\) worth \(Q_tS_{jt}\), financed by net worth \(N_{jt}\) and deposits \(B_{jt+1}\):

\[
Q_tS_{jt}=N_{jt}+B_{jt+1}.
\]

The banker maximizes expected terminal wealth:

\[
V_{jt}=\max E_t\sum_{i=0}^{\infty}(1-\theta)\theta^i\beta^{i+1}\Lambda_{t,t+1+i}N_{jt+1+i}.
\]

Depositors lend only if the banker does not prefer to divert a fraction \(\lambda\) of assets:

\[
V_{jt}\geq \lambda Q_tS_{jt}.
\]

### 2.3 Intermediate-Good Firm

The firm rents effective capital and labor to produce intermediate output:

\[
Y_t=A_t(U_t\xi_tK_t)^\alpha L_t^{1-\alpha}.
\]

It chooses labor and utilization statically and pays the ex post capital return to claim holders.

### 2.4 Capital Producer

Capital producers choose net investment subject to flow adjustment costs:

\[
\max E_t\sum_{\tau=t}^{\infty}\beta^{\tau-t}\Lambda_{t,\tau}
\left[(Q_\tau-1)I_{n\tau}
- f\!\left(\frac{I_{n\tau}+I_{ss}}{I_{n,\tau-1}+I_{ss}}\right)(I_{n\tau}+I_{ss})\right].
\]

### 2.5 Retailer

Retail firms repackage intermediate output and face Calvo pricing with indexation:

\[
\max_{P_t^{\ast}} E_t\sum_{i=0}^{\infty}\gamma^i\beta^i\Lambda_{t,t+i}
\left[
\frac{P_t^{\ast}}{P_{t+i}}\prod_{k=1}^i(1+\pi_{t+k-1})^{\gamma_p}
- P_{m,t+i}
\right]Y_{f,t+i}.
\]

## 3. First-Order Conditions

- **(F1) Household marginal utility with external habit**:

\[
\varrho_t=(C_t-hC_{t-1})^{-1}-\beta h E_t(C_{t+1}-hC_t)^{-1}.
\]

- **(F2) Labor supply**:

\[
\varrho_t W_t=\chi L_t^\varphi.
\]

- **(F3) Riskless-bond Euler equation**:

\[
E_t\beta\Lambda_{t,t+1}R_{t+1}=1,\qquad
\Lambda_{t,t+1}=\frac{\varrho_{t+1}}{\varrho_t}.
\]

- **(F4) Intermediary net-worth accumulation**:

\[
N_{j,t+1}=(R_{k,t+1}-R_{t+1})Q_tS_{jt}+R_{t+1}N_{jt}.
\]

- **(F5) Intermediary value decomposition**:

\[
V_{jt}=\nu_t Q_tS_{jt}+\eta_tN_{jt}.
\]

- **(F6) Marginal value of expanding assets**:

\[
\nu_t=E_t\left\{(1-\theta)\beta\Lambda_{t,t+1}(R_{k,t+1}-R_{t+1})
\,+\beta\theta\Lambda_{t,t+1}x_{t,t+1}\nu_{t+1}\right\}.
\]

- **(F7) Marginal value of net worth**:

\[
\eta_t=E_t\left\{(1-\theta)+\beta\theta\Lambda_{t,t+1}z_{t,t+1}\eta_{t+1}\right\}.
\]

- **(F8) Binding incentive constraint and private leverage**:

\[
Q_tS_{jt}=\frac{\eta_t}{\lambda-\nu_t}N_{jt}\equiv \phi_tN_{jt}.
\]

- **(F9) Individual net-worth growth**:

\[
z_{t,t+1}=\frac{N_{j,t+1}}{N_{jt}}=(R_{k,t+1}-R_{t+1})\phi_t+R_{t+1}.
\]

- **(F10) Asset growth**:

\[
x_{t,t+1}=\frac{Q_{t+1}S_{j,t+1}}{Q_tS_{jt}}=\frac{\phi_{t+1}}{\phi_t}z_{t,t+1}.
\]

- **(F11) Aggregate assets constrained by aggregate net worth**:

\[
Q_tS_t=\phi_tN_t.
\]

- **(F12) Continuing-bank net worth**:

\[
N_{e,t}=\theta\left[(R_{k,t}-R_t)\phi_{t-1}+R_t\right]N_{t-1}.
\]

- **(F13) New-bank net worth**:

\[
N_{n,t}=\omega Q_tS_{t-1}.
\]

- **(F14) Aggregate intermediary net worth**:

\[
N_t=N_{e,t}+N_{n,t}.
\]

- **(F15) Central-bank credit share and total intermediation**:

\[
Q_tS_t=Q_tS_{p,t}+Q_tS_{g,t},\qquad
Q_tS_{g,t}=\psi_t Q_tS_t,\qquad
Q_tS_t=\phi_{c,t}N_t.
\]

- **(F16) Total leverage under credit policy**:

\[
\phi_{c,t}=\frac{\phi_t}{1-\psi_t}.
\]

- **(F17) Firm financing of capital claims**:

\[
Q_tK_{t+1}=Q_tS_t.
\]

- **(F18) Intermediate-goods production**:

\[
Y_t=A_t(U_t\xi_tK_t)^\alpha L_t^{1-\alpha}.
\]

- **(F19) Utilization condition**:

\[
P_{m,t}\alpha\frac{Y_t}{U_t}=\delta'(U_t)\xi_tK_t.
\]

- **(F20) Labor demand**:

\[
P_{m,t}(1-\alpha)\frac{Y_t}{L_t}=W_t.
\]

- **(F21) Return on capital**:

\[
R_{k,t+1}=
\frac{\left[P_{m,t+1}\alpha\frac{Y_{t+1}}{\xi_{t+1}K_{t+1}}+Q_{t+1}-\delta(U_{t+1})\right]\xi_{t+1}}{Q_t}.
\]

- **(F22) Net investment definition**:

\[
I_{n,t}=I_t-\delta(U_t)\xi_tK_t.
\]

- **(F23) Capital-producer Tobin's Q condition**:

\[
Q_t=1+f(\cdot)+
\frac{I_{n,t}+I_{ss}}{I_{n,t-1}+I_{ss}}f'(\cdot)
-E_t\beta\Lambda_{t,t+1}
\left(\frac{I_{n,t+1}+I_{ss}}{I_{n,t}+I_{ss}}\right)^2f'(\cdot).
\]

- **(F24) Retail demand for differentiated output**:

\[
Y_{f,t}=\left(\frac{P_{f,t}}{P_t}\right)^{-\varepsilon}Y_t.
\]

- **(F25) Reset-price first-order condition**:

\[
E_t\sum_{i=0}^{\infty}\gamma^i\beta^i\Lambda_{t,t+i}
\left[
\frac{P_t^{\ast}}{P_{t+i}}\prod_{k=1}^{i}(1+\pi_{t+k-1})^{\gamma_p}
-\mu P_{m,t+i}
\right]Y_{f,t+i}=0.
\]

- **(F26) Price-index law of motion**:

\[
P_t=\left[(1-\gamma)(P_t^{\ast})^{1-\varepsilon}
+\gamma\left(\Pi_{t-1}^{\gamma_p}P_{t-1}\right)^{1-\varepsilon}\right]^{1/(1-\varepsilon)}.
\]

## 4. Market Clearing & Identities

- **(F27) Resource constraint including credit-policy cost**:

\[
Y_t=C_t+I_t+
f\!\left(\frac{I_{n,t}+I_{ss}}{I_{n,t-1}+I_{ss}}\right)(I_{n,t}+I_{ss})
+G+\tau\psi_tQ_tK_{t+1}.
\]

- **(F28) Capital accumulation**:

\[
K_{t+1}=\xi_tK_t+I_{n,t}.
\]

- **(F29) Government budget constraint with central-bank intermediation revenue**:

\[
G+\tau\psi_tQ_tK_{t+1}=T_t+(R_{k,t}-R_t)B_{g,t-1}.
\]

- **(F30) Fisher relation**:

\[
1+i_t=R_{t+1}\frac{E_tP_{t+1}}{P_t}.
\]

## 5. Exogenous Processes

- **(F31) Interest-rate rule**:

\[
i_t=(1-\rho)\left[i+\kappa_\pi\pi_t+\kappa_y(\log Y_t-\log Y_t^{\ast})\right]
+\rho i_{t-1}+\varepsilon_t.
\]

- **(F32) Credit-policy feedback rule**:

\[
\psi_t=\psi+\nu_\psi E_t\left[(\log R_{k,t+1}-\log R_{t+1})-(\log R_k-\log R)\right].
\]

- **(F33) Technology process, as implemented in the linear MMB file**:

\[
a_t=\rho_a a_{t-1}+\varepsilon^a_t.
\]

- **(F34) Capital-quality process, as implemented in the linear MMB file**:

\[
\xi_t=\rho_\xi\xi_{t-1}+\varepsilon^\xi_t.
\]

- **(F35) Intermediary net-worth transfer shock, as implemented in the linear MMB file**:

\[
\varepsilon^n_t \text{ shifts aggregate intermediary net worth in the linearized net-worth equation.}
\]

## 6. Steady-State Solution

The archive pass records the steady-state structure but does not reproduce a full runnable `steady_state_model`. In the MMB implementation, variables are linear deviations from the deterministic steady state, so all model variables in the `model(linear)` block have zero steady state after normalization.

Key steady-state restrictions:

1. \(R=1/\beta\) from (F3) when \(\Lambda=1\).
2. \(P_m=(\varepsilon-1)/\varepsilon\) from monopolistic competition.
3. \(R_k=R+\text{EFP}\), where the steady-state excess finance premium target is one hundred basis points annually in the paper calibration.
4. \(\phi=QK/N\) targets leverage of approximately four in the paper calibration.
5. \(G/Y=0.2\), \(U=1\), \(\delta(U)=0.025\), and \(Q=1\) in steady state.
6. The parameter \(\omega\) pins down banker entry net worth so that aggregate net worth is stationary.

Implementation cross-check from `NK_GK09lin_rep.mod`: the file computes steady-state objects such as `Rss`, `EFPss`, `PHIss`, `PMss`, `RKss`, `DELTAss`, `YKss`, `KLss`, `Kss`, `Yss`, `Nss`, `NEss`, `NNss`, `Css`, `Fss`, `F1ss`, and `Dss` before declaring `model(linear)`. These values are treated as implementation evidence, not paper-side source equations.

## 7. Timing & Form Conventions

- **Capital timing**: the paper indexes production with capital \(K_t\) and the financing decision as \(K_{t+1}\) acquired at the end of period \(t\). The MMB implementation uses lagged capital in production equations, consistent with predetermined capital in a linearized Dynare system.
- **Intermediary net worth**: \(N_t\) is end-of-period intermediary capital after survival, returns, and entry transfers. It is predetermined for next-period lending capacity.
- **Returns**: \(R_{k,t+1}\) is the stochastic payoff on capital purchased at \(t\); \(R_{t+1}\) is the riskless real return paid from \(t\) to \(t+1\).
- **Inflation and nominal rate**: the MMB file uses log-linear inflation `pi`, nominal rate `rn`, and real rate `r`, with a linear Fisher relation.
- **Form**: `NK_GK09lin` is `model(linear)`. The equations above are paper-side nonlinear ancestors; the `.mod` confirms the linear variables and shocks.
- **Status**: `needs_review` for equation-by-equation linearization parity, because the raw paper source gives nonlinear conditions and the MMB code gives a compact linear implementation.

## 8. Variable & Parameter Reference Table

| Category | Symbol or ASCII name | Meaning | Source equation |
|---|---|---|---|
| Endogenous | \(C_t\), `c` | Household consumption | (F1), (F27) |
| Endogenous | \(L_t\), `l` | Labor supply | (F2), (F20) |
| Endogenous | \(W_t\) | Real wage | (F2), (F20) |
| Endogenous | \(\varrho_t\), `uc` | Marginal utility of consumption | (F1) |
| Endogenous | \(\Lambda_{t,t+1}\), `lambda` | Stochastic discount factor | (F3) |
| Endogenous | \(R_t\), `r` | Riskless real return | (F3), (F30) |
| Endogenous | \(R_{k,t}\), `rk` | Return on capital | (F21) |
| Endogenous | \(Q_t\), `q` | Relative price of capital | (F8), (F17), (F23) |
| Endogenous | \(S_t\) | Claims on non-financial firms | (F11), (F17) |
| Endogenous | \(N_t\), `n` | Aggregate intermediary net worth | (F12)-(F14) |
| Endogenous | \(N_{e,t}\), `ne` | Existing-bank net worth | (F12) |
| Endogenous | \(N_{n,t}\), `nn` | New-bank net worth | (F13) |
| Endogenous | \(\nu_t\), `nu` | Marginal value of intermediary assets | (F6) |
| Endogenous | \(\eta_t\), `eta` | Marginal value of intermediary net worth | (F7) |
| Endogenous | \(\phi_t\), `phi` | Private leverage ratio | (F8) |
| Endogenous | \(\phi_{c,t}\), `phic` | Total leverage including credit policy | (F16) |
| Endogenous | \(\psi_t\), `psi` | Central-bank credit share | (F32) |
| Endogenous | \(K_t\), `k` | Capital stock | (F17), (F28) |
| Endogenous | \(U_t\), `u` | Utilization rate | (F19) |
| Endogenous | \(Y_t\), `y`, `ym` | Output, intermediate output | (F18), (F27) |
| Endogenous | \(I_t\), `i` | Gross investment | (F22), (F27) |
| Endogenous | \(I_{n,t}\), `in` | Net investment | (F22), (F28) |
| Endogenous | \(P_{m,t}\), `pm`, `pmn`, `mc` | Relative price / marginal cost | (F19), (F20), (F25) |
| Endogenous | \(\pi_t\), `pi` | Inflation | (F26), (F30), (F31) |
| Endogenous | \(i_t\), `rn` | Net nominal policy rate | (F31) |
| Endogenous | \(P_t^{\ast}\), `pistar` | Optimal reset price / reset inflation | (F25), (F26) |
| Endogenous | `f`, `f1`, `d` | Calvo auxiliary and dispersion variables in implementation | (F25), (F26) |
| Exogenous | `e_rn` | Monetary-policy shock | (F31) |
| Exogenous | `e_a` | Technology innovation | (F33) |
| Exogenous | `e_epsilon` | Capital-quality innovation | (F34) |
| Exogenous | `e_n` | Net-worth transfer shock | (F35) |
| Parameter | \(\beta\), `beta` | Discount factor | (F1)-(F3) |
| Parameter | \(h\) | Habit parameter | (F1) |
| Parameter | \(\chi,\varphi\) | Labor disutility weight and inverse Frisch elasticity | (F2) |
| Parameter | \(\theta\) | Banker survival probability in finance block | (F6)-(F14) |
| Parameter | \(\lambda\) | Divertible asset fraction | (F8) |
| Parameter | \(\omega\) | Transfer to entering bankers | (F13) |
| Parameter | \(\alpha\) | Effective capital share | (F18)-(F21) |
| Parameter | \(\delta(\cdot)\), `deltac`, `zeta` | Depreciation and utilization curvature | (F19), (F22), (F28) |
| Parameter | \(\varepsilon\), `veps` | Elasticity of substitution | (F24)-(F26) |
| Parameter | \(\gamma,\gamma_p\) | Calvo rigidity and indexation | (F25), (F26) |
| Parameter | \(\kappa_\pi,\kappa_y,\rho\) | Taylor-rule coefficients | (F31) |
| Parameter | \(\tau,\nu_\psi\) | Credit-policy cost and feedback coefficient | (F27), (F32) |
