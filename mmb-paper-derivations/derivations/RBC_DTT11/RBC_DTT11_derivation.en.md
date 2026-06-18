# RBC_DTT11 -- Derivation

> Source-backed first-pass derivation for the MMB model archive. Runtime validation was not performed.

## 1. Model Overview

- **Model ID**: `RBC_DTT11`.
- **Paper**: Fiorella De Fiore, Pedro Teles, and Oreste Tristani (2011), "Monetary Policy and the Financing of Firms," *American Economic Journal: Macroeconomics*, 3(4), 112-142, DOI `10.1257/mac.3.4.112`.
- **Source**: `raw/mmb_mineru/runs/rbc_dtt11__monetary_policy_and_the_financing_of_firms__d32dcd23/full.md`; raw PDF `raw/mmb_papers/Monetary policy and the financing of firms.pdf`; MinerU run `d32dcd23-cfeb-4a15-88ac-25e2cb169c6e`.
- **Model form**: log-linearized stochastic RBC-style monetary model with flexible prices, nominal predetermined firm finance, and costly-state-verification default. The paper derives nonlinear equilibrium restrictions, but the Rep-MMB implementation records that `fo_t`, `CapG_t`, `co_t`, `ho_t`, `dumnum_t`, `dumden_t`, `Util`, and `Welf` are linearized while other variables are log-linearized.
- **Experiment in MMB implementation**: simple Taylor-rule outcomes, constant government spending share, and no entrepreneurial consumption. The `.mod` file was used only as `implementation_cross_check`; Dynare was not run.
- **Agents**: households, entrepreneurs/firms, banks/financial intermediaries, and government/central bank.
- **Core mechanism**: firms must bring nominal internal and external funds from the previous period to pay wages. Aggregate shocks arrive after financial decisions are fixed, so policy affects real funds and real debt through the price level and nominal rates. Idiosyncratic firm productivity is privately observed and generates bankruptcy/default under an optimal debt contract.
- **Extraction status**: `needs_review`. The main equilibrium block and Appendix B are readable, but several OCR-normalized formulas and implementation simplifications need source-level review before final promotion.

## 2. Optimization Problems

### 2.1 Households

Households choose consumption, labor, money, deposits, and nominal state-contingent bonds. Money utility is separable and treated as negligible for the archive core.

\[
\max_{\{c_t,n_t,M_t,D_t,B_{t,t+1}\}} E_0 \sum_{t=0}^{\infty} \beta^t
\left[u(c_t,m_t)-\alpha n_t\right],
\]

subject to the nominal budget constraint

\[
M_t + \sum_{s^{t+1}|s^t} Q_{t,t+1} B_{t,t+1} + D_t
\leq B_t + R_{t-1}^d D_{t-1} + M_{t-1} - P_t c_t + W_t n_t - T_t^h.
\]

Here \(m_t=M_{t-1}/P_t\), \(R_t^d\) is the gross safe deposit rate, and \(Q_{t,t+1}\) is the nominal state-contingent-bond price.

### 2.2 Entrepreneurs/Firms and the Financial Contract

Each firm \(i\) produces with labor only:

\[
y_{i,t}=\omega_{i,t} A_t N_{i,t},
\]

where \(\omega_{i,t}\) is an idiosyncratic productivity draw with distribution \(\Phi\), density \(\phi\), mean one, and time-varying risk \(\sigma_{\omega,t}\). The aggregate technology process is \(A_t\).

Firms must pay wages at the start of the period using predetermined nominal total funds:

\[
W_t N_{i,t} \leq X_{i,t-1}.
\]

Total funds combine internal funds and bank borrowing:

\[
X_{i,t-1}=Z_{i,t-1}+\left(X_{i,t-1}-Z_{i,t-1}\right).
\]

The optimal debt contract fixes a loan repayment \(R_{i,t-1}^l(X_{i,t-1}-Z_{i,t-1})\). The bankruptcy threshold \(\bar{\omega}_{i,t}\) satisfies

\[
P_t A_t \bar{\omega}_{i,t} N_{i,t}
=R_{i,t-1}^l\left(X_{i,t-1}-Z_{i,t-1}\right).
\]

Define the entrepreneur and bank shares of output as

\[
f(\bar{\omega}_t)
=\int_{\bar{\omega}_t}^{\infty}(\omega_t-\bar{\omega}_t)\,\Phi(d\omega),
\]

\[
g(\bar{\omega}_t;\mu_t)
=\int_0^{\bar{\omega}_t}(1-\mu_t)\omega_t\,\Phi(d\omega)
+\int_{\bar{\omega}_t}^{\infty}\bar{\omega}_t\,\Phi(d\omega),
\]

with monitoring-loss function

\[
G(\bar{\omega}_t)=\int_0^{\bar{\omega}_t}\omega_t\,\Phi(d\omega),
\]

so that

\[
f(\bar{\omega}_t)+g(\bar{\omega}_t;\mu_t)
=1-\mu_t G(\bar{\omega}_t).
\]

Let

\[
z_{t-1}\equiv \frac{Z_{i,t-1}}{X_{i,t-1}},
\qquad
\nu_t\equiv \frac{P_t A_t}{W_t}.
\]

The contract chooses \((R_{i,t-1}^l,X_{i,t-1},\bar{\omega}_{i,t},N_{i,t})\) to maximize expected entrepreneur output

\[
\max E_{t-1}\left[f(\bar{\omega}_{i,t})P_t A_t N_{i,t}\right],
\]

subject to wage-finance feasibility, bank participation, and entrepreneur participation:

\[
W_t N_{i,t}\leq X_{i,t-1},
\]

\[
E_{t-1}\left[g(\bar{\omega}_{i,t};\mu_t)P_t A_t N_{i,t}\right]
\geq R_{t-1}^d\left(X_{i,t-1}-Z_{i,t-1}\right),
\]

\[
E_{t-1}\left[f(\bar{\omega}_{i,t})P_t A_t N_{i,t}\right]
\geq R_{t-1}^d Z_{i,t-1}.
\]

### 2.3 Banks

Banks are zero-profit intermediaries. They accept deposits from households and lend to entrepreneurs through the contract above. Government deposit insurance/taxes/subsidies make bank profits zero state by state, so household deposits earn the safe rate.

### 2.4 Government and Monetary Authority

Government consumption is a constant share \(g\) of production net of monitoring losses. In the Taylor-rule implementation, the monetary authority sets the deposit/policy rate as a function of inflation deviations.

## 3. First-Order Conditions

- **(F1) Household labor-supply condition**:

\[
\frac{u_c(t)}{\alpha}=\frac{P_t}{W_t}.
\]

- **(F2) State-contingent bond pricing condition**:

\[
\frac{u_c(t)}
{\beta\,\Pr(s^{t+1}|s^t)\,u_c(t+1)}
=Q_{t,t+1}^{-1}\frac{P_t}{P_{t+1}}.
\]

- **(F3) Deposit Euler equation**:

\[
\frac{u_c(t)}{P_t}
=R_t^d E_t\left[\frac{\beta u_c(t+1)}{P_{t+1}}\right].
\]

- **(F4) Money-demand condition**:

\[
E_t\left[\frac{u_m(t+1)}{P_{t+1}}\right]
=E_t\left[\frac{u_c(t+1)}{P_{t+1}}\right](R_t^d-1).
\]

- **(F5) Bankruptcy threshold**:

\[
\bar{\omega}_t=\frac{R_{t-1}^l(1-z_{t-1})}{\nu_t}.
\]

- **(F6) Entrepreneur output share**:

\[
f(\bar{\omega}_t)
=\int_{\bar{\omega}_t}^{\infty}(\omega_t-\bar{\omega}_t)\,\Phi(d\omega).
\]

- **(F7) Bank output share**:

\[
g(\bar{\omega}_t;\mu_t)
=\int_0^{\bar{\omega}_t}(1-\mu_t)\omega_t\,\Phi(d\omega)
+\int_{\bar{\omega}_t}^{\infty}\bar{\omega}_t\,\Phi(d\omega).
\]

- **(F8) Monitoring-loss identity**:

\[
f(\bar{\omega}_t)+g(\bar{\omega}_t;\mu_t)
=1-\mu_t G(\bar{\omega}_t).
\]

- **(F9) Optimal contract, entrepreneur return condition**:

\[
E_{t-1}\left[\nu_t f(\bar{\omega}_t)\right]
=
\frac{R_{t-1}^d}
{1-\frac{E_{t-1}\left[\mu_t\bar{\omega}_t\phi(\bar{\omega}_t)\right]}
{E_{t-1}\left[1-\Phi(\bar{\omega}_t)\right]}}
z_{t-1}.
\]

- **(F10) Optimal contract, bank zero-profit condition**:

\[
E_{t-1}\left[\nu_t g(\bar{\omega}_t;\mu_t)\right]
=R_{t-1}^d(1-z_{t-1}).
\]

- **(F11) Wedge/markup definition using household intratemporal optimality**:

\[
\nu_t=\frac{u_c(t)A_t}{\alpha}.
\]

- **(F12) Entrepreneur internal-funds accumulation**:

\[
Z_t=(1-\gamma_t)f(\bar{\omega}_t)P_t A_t N_t.
\]

- **(F13) Internal-funds accumulation in recursive ratio form**:

\[
Z_t=(1-\gamma_t)f(\bar{\omega}_t)\frac{\nu_t}{z_{t-1}}Z_{t-1}.
\]

- **(F14) Entrepreneur consumption before the no-entrepreneur-consumption limit**:

\[
c_t^e=\frac{\gamma_t f(\bar{\omega}_t)A_t N_t}{1+\tau}.
\]

The MMB implementation states that entrepreneurial consumption is shut down; this condition is retained as paper-side provenance and not as an active MMB resource equation.

## 4. Market Clearing & Identities

- **(F15) Wage-finance constraint at equality**:

\[
W_t N_{i,t}=X_{i,t-1}.
\]

- **(F16) Aggregate production and labor aggregation**:

\[
Y_t=A_t N_t,
\qquad
\int N_{i,t}\,di=N_t=n_t.
\]

- **(F17) Internal funds as a share of total funds**:

\[
Z_t=z_t X_t.
\]

- **(F18) Predetermined real funds relation**:

\[
\frac{Z_{t-1}}{P_t}
=z_{t-1}\frac{A_t}{\nu_t}N_t.
\]

- **(F19) Resource constraint with government spending share and monitoring losses**:

\[
c_t=(1-g)A_t N_t\left[1-\mu_t G(\bar{\omega}_t)\right].
\]

- **(F20) Implementability condition combining the contract and markup wedge**:

\[
E_{t-1}\left[
\frac{u_c(t)A_t}{\alpha}
\left(
1-\mu_t G(\bar{\omega}_t)
-f(\bar{\omega}_t)
\frac{E_{t-1}\left[\mu_t\bar{\omega}_t\phi(\bar{\omega}_t)\right]}
{E_{t-1}\left[1-\Phi(\bar{\omega}_t)\right]}
\right)
\right]
=R_{t-1}^d.
\]

`needs_review`: the OCR source gives this condition clearly in structure but the sign and placement of the \(f(\bar{\omega}_t)\) multiplier should be checked against the PDF before final use.

- **(F21) Taylor-type policy rule used for simple-rule simulations**:

\[
\hat{r}_t^d=1.5\,\hat{\pi}_t.
\]

The Rep-MMB `.mod` implements a gross-rate/log-linear counterpart:

\[
R_t^d=\frac{1.0025}{\beta}
\left(\frac{\Pi_t}{1.0025}\right)^{\zeta}\exp(\varepsilon_t^{pol}),
\qquad \zeta=1.5,
\]

with notation adapted from the implementation. This equation is an implementation cross-check, not an independent paper-side source.

## 5. Exogenous Processes

- **(F22) Technology process**:

\[
a_t=\rho_a a_{t-1}+\varepsilon_t^A,
\qquad a_t\equiv \log A_t.
\]

- **(F23) Monitoring-cost process**:

\[
\mu_t=(1-\rho_\mu)\log(\mu)+\rho_\mu\mu_{t-1}+\varepsilon_t^\mu.
\]

- **(F24) Entrepreneur-death/financial-funds shock**:

\[
\gamma_t=(1-\rho_\gamma)\log(\gamma)+\rho_\gamma\gamma_{t-1}+\varepsilon_t^\gamma.
\]

- **(F25) Idiosyncratic-risk process**:

\[
\sigma_{\omega,t}=(1-\rho_\sigma)\log(\sigma_\omega)+\rho_\sigma\sigma_{\omega,t-1}+\varepsilon_t^\sigma.
\]

- **(F26) Monetary-policy shock process**:

\[
pol_t=\rho_{pol}pol_{t-1}+\varepsilon_t^{pol}.
\]

`needs_review`: the Rep-MMB file sets the policy shock persistence equal to `rho_a`; this may be deliberate shorthand or a replication artifact.

## 6. Steady-State Solution

The paper's steady-state system uses gross inflation \(\Pi\), deposit rate \(R^d\), markup/wedge \(\nu\), internal-funds share \(z\), bankruptcy threshold \(\bar{\omega}\), and loan rate \(R^l\).

1. Deposit Euler condition:

\[
\frac{1}{\beta}=\frac{R^d}{\Pi}.
\]

2. Nominal internal-funds growth equals inflation:

\[
\Pi=(1-\gamma)\frac{f(\bar{\omega})\nu}{z}.
\]

3. Entrepreneur gross return on internal funds:

\[
R^e\equiv\frac{f(\bar{\omega})\nu}{z}
=
\frac{R^d}
{1-\mu\frac{\bar{\omega}\phi(\bar{\omega})}{1-\Phi(\bar{\omega})}}.
\]

4. Bank zero-profit condition:

\[
\frac{g(\bar{\omega};\mu)\nu}{1-z}=R^d.
\]

5. Bankruptcy threshold:

\[
\bar{\omega}=\frac{R^l(1-z)}{\nu}.
\]

6. Threshold equation independent of average inflation:

\[
\frac{1-\gamma}{\beta}
=1-\frac{\mu\bar{\omega}\phi(\bar{\omega})}{1-\Phi(\bar{\omega})}.
\]

7. Steady-state implementability condition:

\[
\frac{u_c A}{\alpha}
=
\frac{R^d}
{1-\mu G(\bar{\omega})
-f(\bar{\omega})
\frac{\mu\bar{\omega}\phi(\bar{\omega})}{1-\Phi(\bar{\omega})}}.
\]

`needs_review`: as with (F20), the OCR denominator should be checked for exact grouping before using this expression mechanically.

8. Resource constraint:

\[
c=(1-g)AN\left[1-\mu G(\bar{\omega})\right].
\]

9. Calibration anchors from the implementation cross-check:

\[
\beta=0.99,\quad \alpha=5.0,\quad \sigma=1.0,\quad \mu=0.12,\quad \gamma=0.06,\quad
\sigma_\omega=0.07,\quad g=0.02,\quad \zeta=1.5.
\]

The steady-state ordering is: choose/calibrate \((\beta,\alpha,\sigma,\mu,\gamma,\sigma_\omega,g,\Pi)\); solve \(\bar{\omega}\) from the threshold equation; solve \(R^d=\Pi/\beta\); solve \((\nu,z,R^l)\) from the contract and threshold equations; then obtain \(N\) and \(c\) from the implementability and resource constraints. The Rep-MMB initial values provide one log-linearization point but were not validated by a Dynare run in this task.

## 7. Timing & Form Conventions

- Financial variables \(X_{t-1}\), \(Z_{t-1}\), \(z_{t-1}\), and \(R_{t-1}^l\) are predetermined when aggregate shocks at \(t\) are realized.
- Firms hire labor and produce after aggregate shocks but before idiosyncratic productivity is observed.
- Default/bankruptcy is determined after production through \(\bar{\omega}_t\).
- Entrepreneurs that survive carry internal funds forward; death probability \(\gamma_t\) removes a fraction of entrepreneurial funds from the accumulation process.
- The price level and inflation affect real predetermined funds and real debt liabilities.
- The paper derives nonlinear equilibrium restrictions but studies log-linear dynamics. The Rep-MMB file mixes log-linearized variables with several level-linearized auxiliary objects.
- Runtime validation, BK checks, and IRF replication were not performed.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII name | Meaning | Main equation(s) |
|---|---|---|---|
| Endogenous | \(c_t\) / `c_t` | household consumption | (F3), (F19) |
| Endogenous | \(n_t,N_t\) / `n_t` | labor | (F1), (F15), (F16) |
| Endogenous | \(Y_t\) / `y_t` | output | (F16) |
| Endogenous | \(P_t,\Pi_t\) / `pi_t` | price level and inflation | (F3), (F21) |
| Endogenous | \(R_t^d\) / `r_t` | safe deposit/policy rate | (F3), (F21) |
| Endogenous | \(R_t^l\) / `rl_t` | loan rate | (F5), steady-state threshold |
| Endogenous | \(Z_t\) / `zbar_t` | nominal internal funds | (F12), (F13) |
| Endogenous | \(z_t\) / `z_t` | internal-to-total funds ratio | (F9), (F10), (F17) |
| Endogenous | \(X_t\) | total nominal funds | (F15), (F17) |
| Endogenous | \(\bar{\omega}_t\) / `omeg_t` | bankruptcy threshold | (F5) |
| Endogenous | \(f(\bar{\omega}_t)\) / `fo_t` | entrepreneur output share | (F6) |
| Endogenous | \(G(\bar{\omega}_t)\) / `CapG_t` | expected monitored output | (F8), (F19) |
| Endogenous | \(\Phi(\bar{\omega}_t)\) / `co_t` | bankruptcy probability | (F7) |
| Endogenous | \(\phi(\bar{\omega}_t)\) / `ho_t` | density at threshold | (F9), (F20) |
| Endogenous | \(\nu_t\) / `ni_t` | markup/wedge \(P_tA_t/W_t\) | (F11) |
| Endogenous | \(\Delta_t\) / `del_t` | credit spread \(R_t^l/R_t^d\) in implementation | implementation cross-check |
| Endogenous | `dumnum_t`, `dumden_t` | contract auxiliary denominator terms | (F9) |
| Endogenous | `Util`, `Welf` | period utility and welfare recursion | implementation cross-check |
| Exogenous | \(A_t\) / `a_t`, `epsA` | aggregate technology | (F22) |
| Exogenous | \(\mu_t\) / `mu_t`, `epsmu` | monitoring-cost shock | (F23) |
| Exogenous | \(\gamma_t\) / `gam_t`, `epsgam` | entrepreneur death/internal-funds shock | (F24) |
| Exogenous | \(\sigma_{\omega,t}\) / `std_t`, `epsstd` | idiosyncratic-risk shock | (F25) |
| Exogenous | `pol_t`, `epspol` | monetary-policy shock | (F26) |
| Parameter | \(\beta\) / `bet` | household discount factor | (F3), steady state |
| Parameter | \(\alpha\) / `alf` | labor disutility scale in paper/implementation notation | (F1) |
| Parameter | \(\sigma\) / `sig` | risk aversion/log utility parameter | utility and Euler equations |
| Parameter | \(\mu\) / `mu` | monitoring cost | (F8), (F20) |
| Parameter | \(\gamma\) / `gam` | entrepreneur death probability | (F12), (F24) |
| Parameter | \(\zeta\) / `zet` | Taylor-rule inflation response | (F21) |
| Parameter | \(g\) / `g` | government spending share | (F19) |
| Parameter | \(\rho_a,\rho_\mu,\rho_\gamma,\rho_\sigma\) | shock persistence | (F22)-(F25) |
