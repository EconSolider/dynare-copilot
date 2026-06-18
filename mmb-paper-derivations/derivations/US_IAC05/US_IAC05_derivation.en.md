# US_IAC05 - Iacoviello (2005) derivation

> Status: `needs_review`. This is a first-pass, source-backed derivation from MinerU Markdown for the MMB implementation `US_IAC05`. Runtime validation was not performed.

## 1. Model Overview

- Model: Matteo Iacoviello (2005), "House prices, borrowing constraints, and monetary policy in the business cycle."
- MMB ID: `US_IAC05`.
- Source form: log-linearized quarterly DSGE model with nominal debt, housing collateral, sticky prices, patient households, impatient households, entrepreneurs, retailers, and a monetary authority.
- Main frictions: collateral constraints tied to expected housing values, nominal loan repayment terms, Calvo sticky prices summarized by a Phillips curve, variable capital with adjustment costs, and fixed aggregate housing supply.
- Shocks: monetary policy, housing preference, inflation/markup, and technology shocks.
- Provenance: primary Markdown `raw/mmb_mineru/runs/us_iac05__house_prices_borrowing_constraints_and_monetary_policy_in_the_business_c__4002ee39/full.md`; raw PDF `raw/mmb_papers/House prices, borrowing constraints, and monetary policy in the business cycle.pdf`; DOI `10.1257/0002828054201477`; MinerU run `4002ee39-61e1-4470-a4e8-b5386cfee9a2`.
- Form convention: the archive entry records the paper's complete log-linearized extended model. Hatted variables are percent deviations from steady state. Expectations on variables dated `t+1` are implicit in the appendix; they are written explicitly below where helpful. Status marker: `needs_review` because several OCR equations required normalization from the appendix text and should be checked against the PDF before review promotion.

## 2. Optimization Problems

### Patient households

Patient households choose consumption, housing, labor, bonds, and real balances:

\[
\max E_0\sum_{t=0}^{\infty}\beta^t
\left(\log c'_t+j_t\log h'_t-\frac{(L'_t)^\eta}{\eta}+\chi\log\frac{M'_t}{P_t}\right)
\]

subject to a nominal-debt flow budget constraint:

\[
c'_t+q_t\Delta h'_t+\frac{R_{t-1}b'_{t-1}}{\pi_t}
=b'_t+w'_tL'_t+F_t+T'_t-\frac{\Delta M'_t}{P_t}.
\]

Money demand is separable and omitted from the reduced system because policy implements an interest-rate rule.

### Entrepreneurs

Entrepreneurs are more impatient than patient households and choose consumption, capital, commercial real estate, labor demand, and debt:

\[
\max E_0\sum_{t=0}^{\infty}\gamma^t\log c_t,\qquad \gamma<\beta.
\]

The extended-model production function is:

\[
Y_t=A_tK_{t-1}^{\mu}h_{t-1}^{\nu}(L'_t)^{\alpha(1-\mu-\nu)}
(L''_t)^{(1-\alpha)(1-\mu-\nu)}.
\]

Their flow budget constraint is:

\[
\frac{Y_t}{X_t}+b_t
=c_t+q_t\Delta h_t+\frac{R_{t-1}b_{t-1}}{\pi_t}
+w'_tL'_t+w''_tL''_t+I_t+\xi_{e,t}+\xi_{K,t}.
\]

Capital evolves with investment \(I_t=K_t-(1-\delta)K_{t-1}\) and adjustment cost:

\[
\xi_{K,t}=\frac{\psi}{2\delta}\left(\frac{I_t}{K_{t-1}}-\delta\right)^2K_{t-1}.
\]

Housing adjustment costs are:

\[
\xi_{e,t}=\frac{\phi_e}{2}\left(\frac{\Delta h_t}{h_{t-1}}\right)^2q_th_{t-1}.
\]

The entrepreneurial collateral constraint binds in the deterministic neighborhood used for log-linearization:

\[
b_t=mE_t\left(\frac{q_{t+1}h_t\pi_{t+1}}{R_t}\right).
\]

### Impatient households

Impatient households choose consumption, housing, labor, debt, and real balances:

\[
\max E_0\sum_{t=0}^{\infty}(\beta'')^t
\left(\log c''_t+j_t\log h''_t-\frac{(L''_t)^\eta}{\eta}+\chi\log\frac{M''_t}{P_t}\right),
\qquad \beta''<\beta.
\]

Their flow budget and collateral constraint are:

\[
c''_t+q_t\Delta h''_t+\frac{R_{t-1}b''_{t-1}}{\pi_t}
=b''_t+w''_tL''_t+T''_t-\frac{\Delta M''_t}{P_t}-\xi_{h,t},
\]

\[
b''_t=m''E_t\left(\frac{q_{t+1}h''_t\pi_{t+1}}{R_t}\right),
\]

with:

\[
\xi_{h,t}=\frac{\phi_h}{2}\left(\frac{\Delta h''_t}{h''_{t-1}}\right)^2q_th''_{t-1}.
\]

### Retailers and monetary authority

Retailers face Calvo price rigidity. The paper reduces the pricing block to a New Keynesian Phillips curve in the log-linear system. The central bank follows an estimated Taylor-type interest-rate rule with interest-rate inertia and responses to lagged inflation and lagged output.

## 3. First-Order Conditions

The following equations reproduce the paper's complete log-linearized extended model. Hatted variables are deviations from steady state; variables dated \(t+1\) are conditional expectations.

- **(F1) Patient household Euler equation**:

\[
\hat c'_t=E_t\hat c'_{t+1}-\widehat{rr}_t.
\]

- **(F2) Entrepreneurial investment condition**:

\[
\hat I_t-\hat K_{t-1}
=\gamma(E_t\hat I_{t+1}-\hat K_t)
+\frac{1-\gamma(1-\delta)}{\psi}(E_t\hat Y_{t+1}-E_t\hat X_{t+1}-\hat K_t)
+\frac{1}{\psi}(\hat c_t-E_t\hat c_{t+1}).
\]

- **(F3) Entrepreneurial housing-consumption margin**:

\[
\begin{aligned}
\hat q_t={}&\gamma_eE_t\hat q_{t+1}
+(1-\gamma_e)(E_t\hat Y_{t+1}-E_t\hat X_{t+1}-\hat h_t)
-m\beta\,\widehat{rr}_t \\
&-(1-m\beta)E_t\Delta\hat c_{t+1}
-\phi_e(\Delta\hat h_t-\gamma E_t\Delta\hat h_{t+1}).
\end{aligned}
\]

`needs_review`: the Markdown line shows `m beta r rrhat` in one place while the MMB `.mod` uses `m*beta*rrhat`; this draft follows the implementation cross-check and the surrounding appendix notation.

- **(F4) Impatient-household housing-consumption margin**:

\[
\begin{aligned}
\hat q_t={}&\gamma_hE_t\hat q_{t+1}
+(1-\gamma_h)(\hat j_t-\hat h''_t)
-m''\beta\,\widehat{rr}_t
+(1-m''\beta)(\hat c''_t-\omega E_t\hat c''_{t+1})\\
&-\phi_h(\Delta\hat h''_t-\beta''E_t\Delta\hat h''_{t+1}).
\end{aligned}
\]

- **(F5) Patient-household housing demand with market clearing**:

\[
\begin{aligned}
\hat q_t={}&\beta E_t\hat q_{t+1}+(1-\beta)\hat j_t+\iota\hat h_t+\iota''\hat h''_t
+\hat c'_t-\beta E_t\hat c'_{t+1}\\
&+\frac{\phi_h}{h'}\left(h\Delta\hat h_t+h''\Delta\hat h''_t
-\beta hE_t\Delta\hat h_{t+1}-\beta h''E_t\Delta\hat h''_{t+1}\right).
\end{aligned}
\]

`needs_review`: the appendix associates the final adjustment-cost bracket with the patient housing condition; the exact coefficient on adjustment costs should be checked against the PDF because the OCR line break is noisy.

- **(F6) Production and labor-market block**:

\[
\hat Y_t=
\frac{\eta}{\eta-(1-\nu-\mu)}
\left(\hat A_t+\nu\hat h_{t-1}+\mu\hat K_{t-1}\right)
-\frac{1-\nu-\mu}{\eta-(1-\nu-\mu)}
\left(\hat X_t+\alpha\hat c'_t+(1-\alpha)\hat c''_t\right).
\]

- **(F7) Phillips curve**:

\[
\hat\pi_t=\beta E_t\hat\pi_{t+1}-\kappa\hat X_t+\hat u_t.
\]

## 4. Market Clearing & Identities

- **(F8) Aggregate demand / goods market clearing**:

\[
\hat Y_t=\frac{c}{Y}\hat c_t+\frac{c'}{Y}\hat c'_t+\frac{c''}{Y}\hat c''_t+\frac{I}{Y}\hat I_t.
\]

- **(F9) Entrepreneurial borrowing constraint**:

\[
\hat b_t=E_t\hat q_{t+1}+\hat h_t-\widehat{rr}_t.
\]

- **(F10) Impatient-household borrowing constraint**:

\[
\hat b''_t=E_t\hat q_{t+1}+\hat h''_t-\widehat{rr}_t.
\]

- **(F11) Capital accumulation**:

\[
\hat K_t=\delta\hat I_t+(1-\delta)\hat K_{t-1}.
\]

- **(F12) Entrepreneurial flow of funds / net worth dynamics**:

\[
\begin{aligned}
\frac{b}{Y}\hat b_t={}&\frac{c}{Y}\hat c_t+\frac{qh}{Y}\Delta\hat h_t+\frac{I}{Y}\hat I_t
+\frac{Rb}{Y}(\hat R_{t-1}+\hat b_{t-1}-\hat\pi_t)\\
&-(1-s'-s'')(\hat Y_t-\hat X_t).
\end{aligned}
\]

- **(F13) Impatient-household flow of funds / net worth dynamics**:

\[
\frac{b''}{Y}\hat b''_t=
\frac{c''}{Y}\hat c''_t+\frac{qh''}{Y}\Delta\hat h''_t
+\frac{Rb''}{Y}(\hat b''_{t-1}+\hat R_{t-1}-\hat\pi_t)
-s''(\hat Y_t-\hat X_t).
\]

- **(F14) Ex ante real rate definition**:

\[
\widehat{rr}_t=\hat R_t-E_t\hat\pi_{t+1}.
\]

Housing market clearing is imposed by fixed aggregate housing and embedded in the transformed housing-demand equations. Loan-market clearing is \(b_t+b'_t+b''_t=0\), with patient households as net lenders in steady state.

## 5. Exogenous Processes

- **(F15) Monetary policy rule**:

\[
\hat R_t=(1-r_R)(1+r_\pi)\hat\pi_{t-1}
+r_Y(1-r_R)\hat Y_{t-1}
+r_R\hat R_{t-1}+\hat e_{R,t}.
\]

- **(F16) Housing preference shock**:

\[
\hat j_t=\rho_j\hat j_{t-1}+\hat e_{j,t}.
\]

- **(F17) Inflation/markup shock**:

\[
\hat u_t=\rho_u\hat u_{t-1}+\hat e_{u,t}.
\]

- **(F18) Technology shock**:

\[
\hat A_t=\rho_A\hat A_{t-1}+\hat e_{A,t}.
\]

## 6. Steady-State Solution

The model is solved around a zero-inflation deterministic steady state with \(R=1/\beta\). The archive records ratios because the MMB implementation is a log-linear model.

Definitions:

\[
\gamma_e=(1-m)\gamma+m\beta,\qquad
\gamma_h=\beta''+m''(\beta-\beta''),\qquad
\omega=\frac{\beta''-m''\beta''}{1-m''\beta}.
\]

Income shares:

\[
s'=\frac{\alpha(1-\mu-\nu)+X-1}{X},\qquad
s''=\frac{(1-\alpha)(1-\mu-\nu)}{X}.
\]

Commercial real estate and debt ratios:

\[
\frac{qh}{Y}=\frac{\gamma\nu}{1-\gamma_e}\frac{1}{X},\qquad
\frac{b}{Y}=\frac{\beta m\gamma\nu}{1-\gamma_e}\frac{1}{X}.
\]

Patient and impatient household real-estate ratios:

\[
\frac{qh'}{Y}
=\frac{j}{1-\beta}s'
+\frac{jm\gamma\nu}{1-\gamma_e}\frac{1}{X}
+\frac{jm''s''}{1-\beta''-m''(\beta-\beta''-j(1-\beta))}.
\]

\[
\frac{qh''}{Y}
=\frac{js''}{1-\beta''-m''(\beta-\beta''-j(1-\beta))}.
\]

Impatient-household debt and consumption ratios:

\[
\frac{b''}{Y}
=\frac{j\beta m''s''}{1-\beta''-m''(\beta-\beta'')+jm''(1-\beta)}.
\]

\[
\frac{c''}{Y}
=\frac{1-\beta''-m''(\beta-\beta'')}{1-\beta''-m''(\beta-\beta'')+jm''(1-\beta)}s''.
\]

Entrepreneurial consumption ratio:

\[
\frac{c}{Y}
=\left(\mu+\nu-\frac{\delta\gamma\mu}{1-\gamma(1-\delta)}
-\frac{(1-\beta)m\gamma\nu}{1-\gamma_e}\right)\frac{1}{X}.
\]

The patient household consumption ratio and investment ratio are then pinned down by aggregate resource accounting:

\[
\frac{c'}{Y}=1-\frac{c}{Y}-\frac{c''}{Y}-\frac{I}{Y},\qquad
\frac{I}{Y}=1-\frac{c}{Y}-\frac{c'}{Y}-\frac{c''}{Y}.
\]

`needs_review`: the paper appendix gives several steady-state ratios but not a full standalone sequence for every normalized variable. This section should be checked against the original appendix and the MMB calibration before being promoted beyond first-pass status.

## 7. Timing & Form Conventions

- Form: log-linear, percent-deviation model; the MMB `.mod` uses a linearized `model` block.
- Expectations: appendix text omits explicit \(E_t\) before variables dated \(t+1\); this derivation restores \(E_t\) in the mathematical display where the source states this convention.
- Capital timing: \(K_t\) is end-of-period capital; production at \(t\) uses \(K_{t-1}\). Capital accumulation is (F11).
- Housing timing: production uses commercial real estate \(h_{t-1}\); collateral constraints depend on expected \(q_{t+1}h_t\). Household housing choices are current stocks with adjustment-cost terms in first differences.
- Debt timing: debt obligations are nominal. The real repayment burden contains \(R_{t-1}b_{t-1}/\pi_t\), so unexpected inflation redistributes resources from lenders to borrowers.
- Interest rate: \(\hat R_t\) is the nominal policy rate in the linear system; \(\widehat{rr}_t=\hat R_t-E_t\hat\pi_{t+1}\) is the ex ante real rate.
- Runtime validation: not performed; Dynare was not run.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Equation anchor |
|---|---|---|---|
| Endogenous | `Yhat` / \(\hat Y_t\) | aggregate output | (F8), (F6) |
| Endogenous | `chat` / \(\hat c_t\) | entrepreneurial consumption | (F3), (F12) |
| Endogenous | `c1hat` / \(\hat c'_t\) | patient-household consumption | (F1), (F5) |
| Endogenous | `c2hat` / \(\hat c''_t\) | impatient-household consumption | (F4), (F13) |
| Endogenous | `Ihat` / \(\hat I_t\) | investment | (F2), (F11) |
| Endogenous | `Khat` / \(\hat K_t\) | capital stock | (F11) |
| Endogenous | `Xhat` / \(\hat X_t\) | markup | (F6), (F7) |
| Endogenous | `qhat` / \(\hat q_t\) | real housing price | (F3)-(F5) |
| Endogenous | `bhat` / \(\hat b_t\) | entrepreneurial debt | (F9), (F12) |
| Endogenous | `b2hat` / \(\hat b''_t\) | impatient-household debt | (F10), (F13) |
| Endogenous | `hhat` / \(\hat h_t\) | entrepreneurial housing | (F3), (F9), (F12) |
| Endogenous | `h2hat` / \(\hat h''_t\) | impatient-household housing | (F4), (F10), (F13) |
| Endogenous | `pihat` / \(\hat\pi_t\) | inflation | (F7), (F14), (F15) |
| Endogenous | `Rhat` / \(\hat R_t\) | nominal policy interest rate | (F15) |
| Endogenous | `rrhat` / \(\widehat{rr}_t\) | ex ante real interest rate | (F14) |
| Endogenous with AR dynamics | `jhat` / \(\hat j_t\) | housing preference | (F16) |
| Endogenous with AR dynamics | `uhat` / \(\hat u_t\) | inflation/markup disturbance | (F17) |
| Endogenous with AR dynamics | `Ahat` / \(\hat A_t\) | technology | (F18) |
| Exogenous shock | `eRhat` | monetary-policy innovation | (F15) |
| Exogenous shock | `ejhat` | housing-preference innovation | (F16) |
| Exogenous shock | `euhat` | inflation/markup innovation | (F17) |
| Exogenous shock | `eAhat` | technology innovation | (F18) |
| Parameter | `beta` / \(\beta\) | patient discount factor | steady state, (F1) |
| Parameter | `beta2` / \(\beta''\) | impatient discount factor | (F4), steady state |
| Parameter | `gamma` / \(\gamma\) | entrepreneurial discount factor | (F2), (F3), steady state |
| Parameter | `j` | housing utility weight | (F5), steady state |
| Parameter | `eta` / \(\eta\) | labor supply curvature | (F6) |
| Parameter | `my` / \(\mu\) | capital share | (F6), steady state |
| Parameter | `ypsilon` / \(\nu\) | commercial real-estate share | (F6), steady state |
| Parameter | `psi` | capital adjustment cost | (F2) |
| Parameter | `delta` / \(\delta\) | depreciation | (F2), (F11), steady state |
| Parameter | `fie`, `fih` / \(\phi_e,\phi_h\) | housing adjustment costs | (F3)-(F5) |
| Parameter | `X` | steady-state markup | steady state |
| Parameter | `theta` | Calvo fixed-price probability | (F7), via \(\kappa\) |
| Parameter | `alfa` / \(\alpha\) | patient labor-income share | (F6), steady state |
| Parameter | `m`, `m2` / \(m,m''\) | loan-to-value ratios | (F3), (F4), (F9), (F10) |
| Parameter | `rhou`, `rhoj`, `rhoA` | AR coefficients | (F16)-(F18) |
| Parameter | `sigmaR`, `sigmaj`, `sigmau`, `sigmaA` | shock standard deviations | shock calibration |
| Parameter | `rR`, `rpi`, `rY` | Taylor-rule coefficients | (F15) |
| Defined parameter | `gammae`, `gammah`, `omega`, `kappa`, `s1`, `s2`, ratios | steady-state and linearized coefficients | multiple |
