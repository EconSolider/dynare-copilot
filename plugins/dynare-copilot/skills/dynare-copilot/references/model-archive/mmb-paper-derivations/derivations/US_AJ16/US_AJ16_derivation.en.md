# US_AJ16 - Derivation (Optimization Problems and First-Order Conditions)

> This is a private model-archive derivation for later implementation work. Runtime validation was not performed.

## 1. Model Overview

- **Model ID**: `US_AJ16`.
- **Paper**: Andrea Ajello (2016), "Financial intermediation, investment dynamics, and business cycle fluctuations," *American Economic Review* 106(8), 2256-2303.
- **DOI**: `10.1257/aer.20120079`.
- **Source Markdown**: `raw/mmb_mineru/runs/us_aj16__financial_intermediation_investment_dynamics_and_business_cycle_fluctuat__68cd7c2d/full.md`.
- **Raw PDF**: `raw/mmb_papers/Financial intermediation, investment dynamics, and business cycle fluctuations.pdf`.
- **MinerU run id**: `68cd7c2d-56de-47eb-b378-19705191b4ce`.
- **Implementation cross-check only**: `.agents/skills/dynare-copilot/references/examples/US_AJ16_rep.mod`.
- **Agents**: a representative household with heterogeneous members, financial intermediaries, final-good producers, monopolistically competitive intermediate-good producers, investment-good producers, employment agencies, a monetary authority, and a fiscal authority.
- **Core mechanism**: members receive idiosyncratic capital-installation technologies. High-technology members sell equity claims to finance investment, intermediate types keep installed capital, and low-technology members buy equity and government bonds. Competitive intermediaries create a bid-ask wedge between the equity sale price and purchase price. Persistent and transitory shocks to the intermediation wedge drive credit spreads, financing gaps, investment, and aggregate activity.
- **Model form**: the paper solves a stationary, log-linear approximation around steady state. The MMB implementation is written in log-deviation/stationary variables and uses `stoch_simul(..., order=1)`, so this entry treats the archive form as a log-linearized estimated DSGE system rather than a complete nonlinear replication.
- **Status**: `needs_review`, mainly because the online appendix derivations are referenced by the paper but not present in this source packet, and several aggregate heterogeneous-agent integrals are OCR-sensitive.

## 2. Optimization Problems

### 2.1 Household

The representative household contains measure-one members indexed by $i$. At the beginning of each period each member receives an idiosyncratic capital-installation technology $A_{i,t}\sim F(A_{i,t})$, where $F$ is lognormal with location $\mu_A$ and dispersion $\sigma_A$. The household head chooses contingent plans

$$
\mathbf X_{i,t+s}=\{C_{i,t+s},W_{i,t+s},\iota_{i,t+s},\Delta N^+_{i,t+s},\Delta N^-_{i,t+s},N_{i,t+s},B_{i,t+s}\}
$$

and aggregate quantities $\mathbf X_{t+s}$ to maximize

$$
\max_{\{\mathbf X_{i,t+s},\mathbf X_{t+s}\}} E_t\sum_{s=0}^{\infty}\beta^{t+s} b_{t+s}
\left[
\log(C_{t+s}-hC_{t+s-1})
-\chi_0\chi_{b,t+s}\frac{L_{t+s}^{1+\nu}}{1+\nu}
\right].
\tag{F1}
$$

The individual flow-of-funds constraint is

$$
P_t C_{i,t}+P_t^K\iota_{i,t}+Q_t^B\Delta N^+_{i,t}-Q_t^A\Delta N^-_{i,t}+B_{i,t}
=R_t^K N_{t-1}+W_{i,t}L_{i,t}+R_{t-1}^B B_{t-1}-P_tT_t+P_tD_t.
\tag{F2}
$$

The member-level law of motion for equity claims is

$$
N_{i,t}=A_{i,t}\iota_{i,t}+\Delta N^+_{i,t}-\Delta N^-_{i,t}+(1-\delta)N_{t-1}.
\tag{F3}
$$

Aggregate flow of funds and aggregate equity accumulation are

$$
P_t C_t+P_t^K\iota_t+Q_t^B\Delta N_t^+-Q_t^A\Delta N_t^-+B_t
=R_t^K N_{t-1}+W_tL_t+R_{t-1}^B B_{t-1}-P_tD_t+P_tT_t,
\tag{F4}
$$

$$
N_t=\int\left[A_{i,t}\iota_{i,t}+\Delta N^+_{i,t}-\Delta N^-_{i,t}\right]dF(A_{i,t})+(1-\delta)N_{t-1}.
\tag{F5}
$$

Equity sales are constrained by new-investment collateral and resaleability of existing claims:

$$
\Delta N^-_{i,t}\leq \theta\frac{P_t^K\iota_{i,t}}{Q_t^A}+\phi(1-\delta)N_{t-1}.
\tag{F6}
$$

### 2.2 Sellers, Keepers, and Buyers

The idiosyncratic draw partitions household members into sellers, keepers, and buyers:

$$
\chi_{s,t}=1-F\left(\frac{P_t^K}{Q_t^A}\right),
\tag{F7}
$$

$$
\chi_{k,t}=F\left(\frac{P_t^K}{Q_t^A}\right)-F\left(\frac{P_t^K}{Q_t^B}\right),
\tag{F8}
$$

$$
\chi_{b,t}=1-\chi_{s,t}-\chi_{k,t}.
\tag{F9}
$$

Sellers use good technologies and sell the maximum allowed amount of equity:

$$
\Delta N^+_{s,t}=0,\qquad
\Delta N^-_{s,t}= \theta\frac{P_t^K\iota_{s,t}}{Q_t^A}+\phi(1-\delta)N_{t-1}.
\tag{F10}
$$

Their investment demand is

$$
\iota_{s,t}=
\frac{R_t^K N_{t-1}+R_{t-1}^B B_{t-1}+P_tD_t-P_tT_t+Q_t^A\phi(1-\delta)N_{t-1}}
{P_t^K(1-\theta)}.
\tag{F11}
$$

Keepers invest using internal funds and do not trade equity:

$$
C_{k,t}=0,\qquad
\Delta N^-_{k,t}=0,\qquad
\Delta N^+_{k,t}=0,\qquad
B_{k,t}=0,
\tag{F12}
$$

$$
\iota_{k,t}=
\frac{R_t^K N_{t-1}+R_{t-1}^B B_{t-1}+P_tD_t-P_tT_t}{P_t^K}.
\tag{F13}
$$

Buyers do not install capital, buy equity claims and government bonds, consume, and supply differentiated labor.

### 2.3 Financial Intermediaries

Perfectly competitive intermediaries buy equity claims from sellers and resell them to buyers. They maximize nominal profits

$$
\Pi_t^{II}=Q_t^B\Delta N^+_{i,t}-(1+\tau_t^q)Q_t^A\Delta N^-_{i,t}
\tag{F14}
$$

subject to

$$
\Delta N^+_{i,t}=\Delta N^-_{i,t}.
\tag{F15}
$$

### 2.4 Final-Good Producers

Final-good producers aggregate differentiated intermediate goods:

$$
Y_t=\left[\int_0^1 Y_t(j)^{\frac{1}{1+\lambda_{p,t}}}dj\right]^{1+\lambda_{p,t}}.
\tag{F16}
$$

### 2.5 Intermediate-Good Producers

Intermediate producers use predetermined capital and current labor:

$$
Y_t(j)=A_t^\eta K_{t-1}(j)^{1-\eta}L_t(j)^\eta.
\tag{F17}
$$

They face Calvo price rigidity with indexation to past and steady-state inflation.

### 2.6 Investment-Good Producers

Competitive investment-good producers transform final goods into investment goods:

$$
\iota_t=\left[1-S\left(\frac{I_t}{I_{t-1}}\right)\right]I_t,
\qquad
S=0,\quad S'=0,\quad S''=\theta_I\text{ in steady state}.
\tag{F18}
$$

They choose $I_t$ to maximize the expected discounted value of profits

$$
\max_{\{I_{t+s}\}}E_t\sum_{s=0}^{\infty}\beta^s E_{t+s}
\left\{\mu_{t+s}^{\Sigma C}\left[P_{t+s}^K\iota_{t+s}-P_{t+s}I_{t+s}\right]\right\}.
\tag{F19}
$$

### 2.7 Employment Agencies

Employment agencies aggregate differentiated buyer labor:

$$
L_t=\left[\int_0^{P_t^K/Q_t^B} L_{b,t}^{\frac{1}{1+\lambda_{w,t}}}dF(A_{i,t})\right]^{1+\lambda_{w,t}}.
\tag{F20}
$$

### 2.8 Policy Authorities

The monetary authority sets a Taylor-type nominal interest-rate rule. The fiscal authority issues nominal government bonds and collects lump-sum taxes to finance government expenditures and maturing debt.

## 3. First-Order Conditions

**Household marginal utility with external habit**:

$$
\mu_t^{\Sigma C}
=\frac{1}{C_t-hC_{t-1}}
-\beta b_t h E_t\left[\frac{1}{C_{t+1}-hC_t}\right].
\tag{F21}
$$

**Equity Euler condition**:

$$
Q_t^B=
\beta b_t E_t\left\{
\frac{\mu_{t+1}^{\Sigma C}}{\mu_t^{\Sigma C}}
\frac{1}{\pi_{t+1}}
\left[
\chi_{s,t+1}E_t\left(\frac{Q_{t+1}^B}{\tilde Q_{s,t+1}^A}\Pi_{s,t+1}\right)
+\chi_{k,t+1}E_t\left(\frac{Q_{t+1}^B}{P_{t+1}^K/A_{k,t+1}}\Pi_{k,t+1}\right)
+\chi_{b,t+1}E_t\left(\Pi_{b,t+1}\right)
\right]\right\}.
\tag{F22}
$$

The payoffs are

$$
\Pi_{s,t+1}=R_{t+1}^K+\phi Q_{t+1}^A(1-\delta)+(1-\phi)\tilde Q_{s,t+1}^A(1-\delta),
\tag{F23}
$$

$$
\Pi_{k,t+1}=R_{t+1}^K+\frac{P_{t+1}^K}{A_{k,t+1}}(1-\delta),
\tag{F24}
$$

$$
\Pi_{b,t+1}=R_{t+1}^K+Q_{t+1}^B(1-\delta).
\tag{F25}
$$

**Bond Euler condition**:

$$
1=\beta b_tE_t\left\{
\frac{\mu_{t+1}^{\Sigma C}}{\mu_t^{\Sigma C}}\frac{R_t^B}{\pi_{t+1}}
\left[
\chi_{s,t+1}E_t\left(\frac{Q_{t+1}^B}{\tilde Q_{s,t+1}^A}\right)
+\chi_{k,t+1}E_t\left(\frac{Q_{t+1}^B}{P_{t+1}^K/A_{k,t+1}}\right)
+\chi_{b,t+1}
\right]\right\}.
\tag{F26}
$$

**Financial-intermediary zero-profit bid-ask condition**:

$$
Q_t^B=(1+\tau_t^q)Q_t^A.
\tag{F27}
$$

The MMB `.mod` cross-check uses a log approximation written as `exp(Q_t_B) - exp(Q_t_A)*exp(tau_q_t)`, so the implementation interprets $\tau_t^q$ as a log wedge in that equation. This mismatch with the paper notation is marked `needs_review`.

**Final-good demand for intermediate good $j$**:

$$
Y_t(j)=\left(\frac{P_t(j)}{P_t}\right)^{-\frac{1+\lambda_{p,t}}{\lambda_{p,t}}}Y_t.
\tag{F28}
$$

**Intermediate-good cost minimization**:

$$
\frac{K_{t-1}}{A_tL_t}=\frac{W_t/P_t}{R_t^K}\frac{1-\eta}{\eta}.
\tag{F29}
$$

**Real marginal cost**:

$$
mc_t=\frac{1}{(1-\eta)^{1-\eta}\eta^\eta}(R_t^K)^{1-\eta}(W_t/P_t)^\eta.
\tag{F30}
$$

**Sticky-price Phillips curve, log-linearized implementation form**:

$$
\pi_t-\pi
=\frac{\beta}{1+\iota_p\beta}(\pi_{t+1}-\pi)
+\frac{\iota_p}{1+\iota_p\beta}(\pi_{t-1}-\pi)
+\kappa_p(mc_t-mc)
+(\lambda_{p,t}-\lambda_p),
\tag{F31}
$$

where $\kappa_p=\frac{(1-\xi_p\beta)(1-\xi_p)}{\xi_p(1+\iota_p\beta)}$.

**Sticky-wage equation, log-linearized implementation form**:

$$
\begin{aligned}
w_t-w={}&\frac{1}{1+\beta}(w_{t-1}-w)+\frac{\beta}{1+\beta}(w_{t+1}-w)
+\frac{\iota_w}{1+\beta}\left[(\pi_{t-1}-\pi)+(z_{t-1}-\gamma)\right]\\
&-\frac{\beta\iota_w+1}{1+\beta}\left[(\pi_t-\pi)+(z_t-\gamma)\right]
+\frac{\beta}{1+\beta}\left[(\pi_{t+1}-\pi)+(z_{t+1}-\gamma)\right]\\
&+\frac{(1-\xi_w\beta)(1-\xi_w)}{1+\beta}
\left[\eta_{\beta,t}-(\lambda_t-\lambda)+\nu(l_t-l)+(\lambda_{w,t}-\lambda_w)-(w_t-w)\right].
\end{aligned}
\tag{F32}
$$

**Investment-good producer Tobin's-Q condition**:

$$
P_t^K
=\frac{1-\beta E_t\left[\frac{\mu_{t+1}^{\Sigma C}}{\mu_t^{\Sigma C}}P_{t+1}^K
S'\left(\frac{I_{t+1}}{I_t}\right)\left(\frac{I_{t+1}}{I_t}\right)^2\right]}
{1-S\left(\frac{I_t}{I_{t-1}}\right)-S'\left(\frac{I_t}{I_{t-1}}\right)\frac{I_t}{I_{t-1}}}.
\tag{F33}
$$

## 4. Market Clearing & Identities

**Aggregate equity accumulation**:

$$
N_t=AI_t+(1-\delta)N_{t-1},
\qquad
AI_t=\int A_{i,t}\iota_{i,t}dF(A_{i,t}).
\tag{F34}
$$

**Model capital-equity identity**:

$$
K_t=N_t.
\tag{F35}
$$

**Aggregate investment-goods demand**:

$$
\iota_t=\iota_{s,t}+\iota_{k,t}.
\tag{F36}
$$

**Traded equity claims**:

$$
\Delta N_t=\theta\frac{P_t^K}{Q_t^A}\iota_{s,t}
+\phi(1-\delta)\chi_{s,t}N_{t-1}.
\tag{F37}
$$

**Production function**:

$$
Y_t=\left(\frac{K_{t-1}}{z_t}\right)^{1-\eta}L_t^\eta.
\tag{F38}
$$

**Resource constraint / GDP identity**:

$$
Y_t=C_t+I_t+G_t.
\tag{F39}
$$

**Government budget constraint**:

$$
B_t+T_t=R_{t-1}^B B_{t-1}+G_t.
\tag{F40}
$$

**Fiscal tax feedback rule**:

$$
\frac{T_t/Y_t}{T/Y}=\left(\frac{B_t/Y_t}{B/Y}\right)^{\varphi_B}.
\tag{F41}
$$

**Taylor rule**:

$$
\frac{R_t^B}{R^B}=
\left(\frac{R_{t-1}^B}{R^B}\right)^{\rho_R}
\left[
\left(\frac{\bar\pi_t}{\bar\pi}\right)^{\phi_\pi}
\left(\frac{\Delta\bar Y_t}{\gamma}\right)^{\phi_{DY}}
\right]^{1-\rho_R}
\eta_{mp,t}.
\tag{F42}
$$

The paper writes this rule multiplicatively. The MMB `.mod` cross-check implements it as a log-linear interest-rate rule with interest-rate smoothing, average inflation over four quarters, output-gap option, GDP-growth response, and monetary-policy innovation.

**Financing gap share observable**:

$$
FGS_t=
\frac{
\int_{P_t^K/Q_t^A}^{\infty}\theta\frac{P_t^K}{Q_t^A}\iota_{i,t}dF(A_{i,t})
+(\chi_{s,t}+\chi_{k,t})\left[Q_t^A\phi(1-\delta)N_t+R_{t-1}^B B_t\right]
}{I_t}\eta_t^{FGS}.
\tag{F43}
$$

**Corporate spread observable**:

$$
Sp_t=400\,E_t\left[
\log\left(\frac{R_{t+1}^K+(1-\delta)Q_{t+1}^A}{Q_t^A}\right)-R_t^B
\right]+\eta_t^{Sp}.
\tag{F44}
$$

## 5. Exogenous Processes

**Preference shock**:

$$
\log b_t=\rho_b\log b_{t-1}+\varepsilon_t^b,\qquad
\varepsilon_t^b\sim N(0,\sigma_b^2).
\tag{F45}
$$

**Persistent and transitory financial-intermediation shocks**:

$$
\tau_t^q=\bar\tau_t^q+\tilde\tau_t^q,
\tag{F46}
$$

$$
\bar\tau_t^q=(1-\rho_{\bar\tau})\tau_{ss}^q+\rho_{\bar\tau}\bar\tau_{t-1}^q+\varepsilon_t^{\bar\tau},
\tag{F47}
$$

$$
\tilde\tau_t^q=\rho_{\tilde\tau}\tilde\tau_{t-1}^q+\varepsilon_t^{\tilde\tau},
\qquad \rho_{\tilde\tau}=\omega_\tau\rho_{\bar\tau}.
\tag{F48}
$$

**Price-markup shock**:

$$
\log(1+\lambda_{p,t})=(1-\rho_p)\log(1+\lambda_p)+\rho_p\log(1+\lambda_{p,t-1})
+\varepsilon_t^p+\theta_p\varepsilon_{t-1}^p.
\tag{F49}
$$

**Labor-augmenting technology growth**:

$$
\log z_t=(1-\rho_z)\log\gamma+\rho_z\log z_{t-1}+\varepsilon_t^z.
\tag{F50}
$$

**Wage-markup shock**:

$$
\log(1+\lambda_{w,t})=(1-\rho_w)\log(1+\lambda_w)+\rho_w\log(1+\lambda_{w,t-1})
+\varepsilon_t^w+\theta_w\varepsilon_{t-1}^w.
\tag{F51}
$$

**Monetary-policy shock**:

$$
\log\eta_{mp,t}=\varepsilon_{mp,t}.
\tag{F52}
$$

**Government-spending share**:

$$
G_t=\left(1-\frac{1}{g_t}\right)Y_t,
\tag{F53}
$$

$$
\log g_t=(1-\rho_g)\log g_{ss}+\rho_g\log g_{t-1}+\varepsilon_t^g.
\tag{F54}
$$

The MMB implementation cross-check includes shocks `eps_z`, `eps_g`, `eps_i`, `eps_tau`, `eps_tau_trans`, `eps_beta`, `eps_p`, `eps_w`, plus measurement errors `eps_meas` and `eps_meas_sp`. It comments out liquidity and technology-dispersion shocks.

## 6. Steady-State Solution

The paper states that the equilibrium conditions are stationarized by rescaling variables that inherit the unit root from labor-augmenting technology $A_t$, then the system is log-linearized around steady state. The full paper-side steady-state derivation is not contained in the MinerU source; this section therefore records the source-supported and implementation-cross-checked steady-state structure and marks unresolved closed-form details as `needs_review`.

1. Set steady-state growth and inflation from calibrated or estimated targets:

$$
z=\gamma,\qquad \pi=\pi_{ss},\qquad \eta_{\beta}=0,\qquad \lambda_{p,t}=\lambda_p,\qquad \lambda_{w,t}=\lambda_w.
\tag{F55}
$$

2. Compute the discount factor from the reported quarterly gross-rate convention:

$$
\beta=\frac{1}{1+(\beta^{-1}-1)}.
\tag{F56}
$$

3. Set steady-state intermediation wedge and government share:

$$
\tau_q=\tau_{q,ss},\qquad g=g_{ss},\qquad G=\left(1-\frac{1}{g_{ss}}\right)Y.
\tag{F57}
$$

4. Use the intermediary condition to pin down the steady-state price wedge:

$$
Q^B=(1+\tau_q)Q^A.
\tag{F58}
$$

In the MMB log implementation this is cross-checked as $Q^B=Q^A\exp(\tau_q)$; this is an implementation convention requiring source review before promotion.

5. Use the lognormal thresholds $P^K/Q^A$ and $P^K/Q^B$ to compute $\chi_s$, $\chi_k$, and $\chi_b$, then aggregate seller and keeper investment using (F11) and (F13).

6. Use $N=K$, equity accumulation, and the investment-good technology with $S=S'=0$ in steady state:

$$
\iota=I,\qquad N=AI+(1-\delta)N/z.
\tag{F59}
$$

7. Use the production function, factor condition, and marginal-cost equation:

$$
Y=(K/z)^{1-\eta}L^\eta,\qquad
\frac{K/z}{L}=\frac{W/P}{R^K}\frac{1-\eta}{\eta},\qquad
mc=\frac{(R^K)^{1-\eta}(W/P)^\eta}{(1-\eta)^{1-\eta}\eta^\eta}.
\tag{F60}
$$

8. Use the resource constraint to obtain consumption:

$$
C=Y-I-G.
\tag{F61}
$$

9. Use the government budget and fiscal feedback rule to pin down $B$, $T$, and the debt-output and tax-output ratios:

$$
B+T=R^B B+G,\qquad
\frac{T/Y}{T/Y}=\left(\frac{B/Y}{B/Y}\right)^{\varphi_B}=1.
\tag{F62}
$$

10. The paper calibrates or estimates selected moments and parameters including $FGS_{ss}=0.35$, $B/Y=0.02$, $g_{ss}=0.17$, $\tau_{q,ss}\times100=3.52$, $\theta=0.677$, $\sigma_A=0.0147$, $h=0.843$, $\delta=0.025$, and price/wage markups of 15 percent.

`needs_review`: a fully source-checked closed-form steady state requires the online appendix derivations for the household integrals and stationarization. This entry should not be treated as ready for direct `steady_state_model` coding.

## 7. Timing & Form Conventions

- **Stock timing**: physical capital/equity $K_t=N_t$ is an end-of-period stock. Production in period $t$ uses predetermined $K_{t-1}$, shown in the paper production function and in the implementation terms `Kbar(-1)/exp(z_t)` and `N_t(-1)/exp(z_t)`.
- **Equity trading**: equity purchases and sales occur within period $t$ after the technology draw. Sellers face a binding sales constraint involving current investment purchases and resalable existing equity.
- **Bond timing**: government bonds purchased in period $t-1$ pay $R_{t-1}^B B_{t-1}$ in period $t$.
- **Price notation**: $Q_t^A$ is the bid/resale price received by sellers; $Q_t^B$ is the ask/purchase price paid by buyers.
- **Stationarization**: aggregate quantities inheriting labor-augmenting growth are rescaled before log-linear solution. The implementation uses log variables for many real quantities and divides predetermined stocks by `exp(z_t)`.
- **Model form**: log-linear/stationary estimated model. The paper solves a log-linear rational-expectations system and the `.mod` uses equations in log variables and deviations around `steady_state(...)`.
- **Validation**: Dynare was not run. Runtime validation status is `not_performed`.

## 8. Variable & Parameter Reference Table

### Endogenous Variables

| Category | Symbol / ASCII | Meaning | Main equation(s) |
|---|---|---|---|
| Endogenous | $AI_t$ / `AI` | Aggregate installed investment technology integral | (F34) |
| Endogenous | $AIK_t$ / `AIK` | Keeper component of $AI_t$ | (F13), (F34) |
| Endogenous | $AIS_t$ / `AIS` | Seller component of $AI_t$ | (F11), (F34) |
| Endogenous | $A^{eff}_t$ / `A_eff` | Effective investment technology | (F36) |
| Endogenous | $B_t$ / `B_t` | Government bonds | (F40), (F41) |
| Endogenous | $C_t$ / `chat` | Consumption | (F21), (F39) |
| Endogenous | $D_t$ / `D_t` | Dividends and rebates | (F2), firm profits |
| Endogenous | $\Delta N_t$ / `Delta_N` | Traded equity claims | (F37) |
| Endogenous | $FGS_t$ / `FGS` | Financing gap share | (F43) |
| Endogenous | $GDP_t$ / `GDP_t` | GDP observable identity | (F39) |
| Endogenous | $I_t$ / `Ihat` | Aggregate investment | (F18), (F33), (F39) |
| Endogenous | $K_t$ / `Kbar` | Capital/equity stock | (F35), (F38) |
| Endogenous | $L_t$ / `l` | Hours worked | (F20), (F32), (F38) |
| Endogenous | $mc_t$ / `mchat` | Real marginal cost | (F30), (F31) |
| Endogenous | $N_t$ / `N_t` | Equity stock | (F34), (F35) |
| Endogenous | $P_t^K$ / `QK` | Price of investment goods | (F33) |
| Endogenous | $Q_t^A$ / `Q_t_A` | Equity sale/bid price | (F27), (F43), (F44) |
| Endogenous | $Q_t^B$ / `Q_t_B` | Equity purchase/ask price | (F22), (F27) |
| Endogenous | $R_t^B$ / `i_t` | Nominal policy/risk-free rate | (F26), (F42) |
| Endogenous | $R_t^K$ / `rK` | Return on capital | (F22)-(F25), (F29), (F44) |
| Endogenous | $r_t$ / `r` | Real risk-free rate | (F26), implementation |
| Endogenous | $\pi_t$ / `pi_t` | Inflation | (F31), (F42) |
| Endogenous | $\tau_t^q$ / `tau_q_t` | Intermediation wedge | (F46)-(F48) |
| Endogenous | $T_t$ / `T_t` | Lump-sum taxes | (F40), (F41) |
| Endogenous | $W_t/P_t$ / `what_t` | Real wage | (F29), (F32) |
| Endogenous | $Y_t$ / `yhat` | Output | (F38), (F39) |
| Endogenous | $z_t$ / `z_t` | TFP growth | (F50) |

### Exogenous Innovations

| Symbol / ASCII | Meaning |
|---|---|
| $\varepsilon_t^z$ / `eps_z` | TFP growth innovation |
| $\varepsilon_t^g$ / `eps_g` | Government-spending innovation |
| $\varepsilon_t^{mp}$ / `eps_i` | Monetary-policy innovation |
| $\varepsilon_t^{\bar\tau}$ / `eps_tau` | Persistent financial-intermediation innovation |
| $\varepsilon_t^{\tilde\tau}$ / `eps_tau_trans` | Transitory financial-intermediation innovation |
| $\varepsilon_t^b$ / `eps_beta` | Preference/discount-factor innovation |
| $\varepsilon_t^p$ / `eps_p` | Price-markup innovation |
| $\varepsilon_t^w$ / `eps_w` | Wage-markup innovation |
| $\eta_t^{FGS}$ / `eps_meas` | Financing-gap measurement error |
| $\eta_t^{Sp}$ / `eps_meas_sp` | Spread measurement error |

### Parameters

| Symbol / ASCII | Meaning |
|---|---|
| $\beta$ / `bet_s` conversion | Discount factor |
| $\delta$ / `delta` | Capital depreciation |
| $\nu$ / `nu` | Inverse Frisch parameter |
| $h$ / `h` | Habit persistence |
| $\eta$ / `eta` | Labor exponent in production |
| $\lambda_p,\lambda_w$ / `lambda_p`, `lambda_w` | Price and wage markups |
| $\xi_p,\xi_w$ / `xi_p`, `xi_w` | Calvo price and wage stickiness |
| $\iota_p,\iota_w$ / `iota_p`, `iota_w` | Price and wage indexation |
| $\mu_A,\sigma_A$ / `mu_ss`, `sg_ss` | Idiosyncratic technology distribution |
| $FGS_{ss}$ / `fgs_param` | Steady-state financing gap share |
| $\theta$ / `theta` | Collateral constraint |
| $\phi$ / `phi_t` | Resaleability/liquidity of existing claims |
| $B/Y$ / `Bs_ss` | Steady-state liquidity over GDP |
| $g_{ss}$ / `gs_ss` | Government spending share process parameter |
| $\tau_{q,ss}$ / `etau_q_ss` | Steady-state intermediation cost |
| $\theta_I$ / `theta_I` | Investment adjustment cost curvature |
| $\pi_{ss}$ / `pis` | Steady-state inflation |
| $\rho_R,\phi_\pi,\phi_{DY},\phi_{Ygap}$ / `rho_i`, `phi_pi`, `phi_DY`, `phi_Ygap` | Monetary policy rule coefficients |
| $\varphi_B$ / `tB` | Fiscal debt feedback |
| $\rho_z,\rho_g,\rho_{\bar\tau},\omega_\tau,\rho_b,\rho_p,\rho_w$ | Exogenous process persistence parameters |
| $\sigma_z,\sigma_g,\sigma_i,\sigma_{\bar\tau},\sigma_{\tilde\tau},\sigma_b,\sigma_p,\sigma_w$ | Structural shock standard deviations |
