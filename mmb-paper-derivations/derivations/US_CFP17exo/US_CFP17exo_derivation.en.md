# US_CFP17exo -- Derivation

> Source-backed private archive draft. Runtime validation was not performed; `.mod` evidence is used only as an implementation cross-check.

## 1. Model Overview

- **Model ID**: `US_CFP17exo`.
- **Paper**: Carlstrom, Fuerst, and Paustian (2017), "Targeting long rates in a model with segmented markets," *American Economic Journal: Macroeconomics*, 9(1), 205-42.
- **DOI**: `10.1257/mac.20150179`.
- **Variant**: exogenous long-debt policy. The Rep-MMB implementation sets the long-bond quantity rule exogenously and leaves the term premium endogenous.
- **Economic environment**: medium-scale Dynamic New Keynesian model with habit formation, sticky wages, sticky prices, investment adjustment costs, and segmented long-term bond markets.
- **Market segmentation**: financial intermediaries are the only buyers of investment bonds and long-term government bonds. Their net worth and leverage constraint limit arbitrage between the short deposit rate and the return on long debt, generating a term premium.
- **Form**: `model(linear)`. The main equations below use lower-case log deviations from steady state, matching the paper's log-linear system and the Rep-MMB implementation cross-check.
- **Primary source**: `raw/mmb_mineru/runs/us_cfp17endo_us_cfp17exo__targeting_long_rates_in_a_model_with_segmented_markets__d8728772/full.md`.
- **Raw PDF**: `raw/mmb_papers/Targeting long rates in a model with segmented markets.pdf`.
- **MinerU run id**: `d8728772-c118-4e20-9cec-bcc6e7b742d5`.

## 2. Optimization Problems

### Households

Households choose consumption, labor, short deposits, capital, and investment-bond finance. Preferences include external habit and a discount-factor shock:

\[
E_0\sum_{s=0}^{\infty}\beta^s e^{rn_{t+s}}
\left[\log(C_{t+s}-hC_{t+s-1})-B\frac{H_{t+s}(j)^{1+\eta}}{1+\eta}\right].
\]

The paper's budget and finance constraints are:

\[
C_t+\frac{D_t}{P_t}+P_t^k I_t+\frac{F_{t-1}}{P_t}
\leq W_tH_t+R_t^kK_t-T_t+\frac{D_{t-1}}{P_t}R_{t-1}
\frac{Q_t(F_t-\kappa F_{t-1})}{P_t}+div_t,
\]

\[
K_{t+1}\leq(1-\delta)K_t+I_t,
\]

\[
P_t^kI_t\leq \frac{Q_t(F_t-\kappa F_{t-1})}{P_t}.
\]

The last constraint is the loan-in-advance constraint: new investment must be financed by newly issued long investment bonds.

### Wage Setters

Households are monopolistic suppliers of differentiated labor. A competitive aggregator combines specialized labor into homogeneous labor. A fraction \(\theta_w\) cannot reset wages and indexes to lagged inflation; the remainder chooses an optimal real wage subject to labor demand.

### Financial Intermediaries

Financial intermediaries choose dividends and next-period net worth:

\[
V_t=\max_{\{N_t,div_t\}}E_t\sum_{j=0}^{\infty}(\beta\zeta)^j\Lambda_{t+j}div_{t+j},
\]

subject to the budget constraint

\[
div_t+N_t[1+f(N_t)]\leq
\frac{P_{t-1}}{P_t}\left[(R_t^L-R_{t-1}^d)L_{t-1}+R_{t-1}\right]N_{t-1}.
\]

The convex net-worth adjustment cost is

\[
f(N_t)=\frac{\psi_n}{2}\left(\frac{N_t-N_{ss}}{N_{ss}}\right)^2.
\]

The incentive constraint prevents default on deposits and pins down leverage as a function of aggregate variables and the financial shock \(\Phi_t\).

### Firms

Final-good firms aggregate differentiated intermediate goods with CES technology. Intermediate-good producers rent capital and labor, face Calvo price stickiness with indexation, and produce with

\[
Y_t(i)=A_tK_t(i)^\alpha H_t(i)^{1-\alpha}.
\]

New-capital producers transform investment goods into capital using

\[
\mu_t\left[1-S\left(\frac{I_t}{I_{t-1}}\right)\right]I_t,\qquad
S\left(\frac{I_t}{I_{t-1}}\right)=\frac{\psi_i}{2}\left(\frac{I_t}{I_{t-1}}-1\right)^2.
\]

### Policy Authorities

The monetary authority sets the short rate with a Taylor rule. In this `US_CFP17exo` variant, long-term government debt available to intermediaries follows an exogenous AR(2) rule. Fiscal policy is passive and government purchases are set to zero in the paper.

## 3. First-Order Conditions

The equations below are numbered continuously and use the paper's log-linear notation. Expectations are implicit where the paper writes dated leads in the linearized system; the Rep-MMB implementation represents the same objects with Dynare leads.

**Households and wages**

- **(F1) Marginal utility of consumption with habit and discount shock**:

\[
\lambda_t=\frac{1}{(1-\beta h)(1-h)}E_t\left[\beta h c_{t+1}-(1+\beta h^2)c_t+hc_{t-1}\right]
+\frac{1}{1-\beta h}(rn_t-\beta h E_t rn_{t+1}).
\]

- **(F2) Labor supply / marginal rate of substitution**:

\[
rn_t+\eta h_t-\lambda_t=mrs_t.
\]

- **(F3) Wage Phillips curve**:

\[
\pi_t^w-\iota_w\pi_{t-1}=\kappa_w(mrs_t-w_t)+\beta(\pi_{t+1}^w-\iota_w\pi_t)+\varepsilon_t^w.
\]

- **(F4) Real wage accumulation**:

\[
w_t=w_{t-1}+\pi_t^w-\pi_t.
\]

- **(F5) Fisher equation / deposit Euler equation**:

\[
\lambda_t=E_t\lambda_{t+1}+r_t-E_t\pi_{t+1}.
\]

**Capital, investment finance, and segmented bond market**

- **(F6) Capital Euler equation with segmentation wedge**:

\[
\lambda_t+p_t^k+m_t
=E_t\left[\lambda_{t+1}+[1-\beta(1-\delta)]r_{t+1}^k
+\beta(1-\delta)(p_{t+1}^k+m_{t+1})\right].
\]

- **(F7) Investment-bond pricing equation**:

\[
\lambda_t+q_t+m_t=E_t\lambda_{t+1}-E_t\pi_{t+1}
+\beta\kappa E_t(q_{t+1}+m_{t+1}).
\]

- **(F8) Link between investment and outstanding investment bonds**:

\[
(1-\kappa)(p_t^k+i_t)=f_t-\kappa(f_{t-1}+q_t-q_{t-1}-\pi_t).
\]

- **(F9) One-period return on intermediated long assets**:

\[
r_{t+1}^{L}=\frac{\kappa q_{t+1}}{R_{ss}^{L}}-q_t.
\]

- **(F10) Ten-year yield on intermediated long bonds**:

\[
r_t^{10}=-\left(\frac{R_{ss}^{L}-\kappa}{R_{ss}^{L}}\right)q_t.
\]

- **(F11) Leverage-spread relation**:

\[
E_t(r_{t+1}^{L}-r_t)=\frac{1}{L_{ss}-1}l_t+
\left[\frac{1+(s-1)L_{ss}}{L_{ss}-1}\right]\phi_t.
\]

- **(F12) Net-worth adjustment condition**:

\[
\psi n_t=
\left[\frac{sL_{ss}}{1+L_{ss}(s-1)}\right]E_t(r_{t+1}^{L}-r_t)
+\left[\frac{(s-1)L_{ss}}{1+L_{ss}(s-1)}\right]l_t.
\]

- **(F13) Intermediary balance-sheet / leverage identity**:

\[
\frac{\overline{B}_{ss}}{L_{ss}N_{ss}}b_t+
\left(1-\frac{\overline{B}_{ss}}{L_{ss}N_{ss}}\right)f_t=n_t+l_t.
\]

**Production, prices, and investment supply**

- **(F14) Real wage equals marginal cost plus marginal product of labor**:

\[
w_t=mc_t+mpl_t.
\]

- **(F15) Real rental rate equals marginal cost plus marginal product of capital**:

\[
r_t^k=mc_t+mpk_t.
\]

- **(F16) Price Phillips curve**:

\[
\pi_t=\frac{\kappa_\pi}{1+\beta\iota_p}mc_t+
\frac{\beta}{1+\beta\iota_p}E_t\pi_{t+1}
+\frac{\iota_p}{1+\beta\iota_p}\pi_{t-1}+\varepsilon_t^p.
\]

- **(F17) Investment supply / capital-price equation**:

\[
p_t^k=\psi_i[(i_t-i_{t-1})-\beta E_t(i_{t+1}-i_t)]-\mu_t.
\]

## 4. Market Clearing & Identities

- **(F18) Resource constraint**:

\[
\left(1-\frac{I_{ss}}{Y_{ss}}\right)c_t+\frac{I_{ss}}{Y_{ss}}i_t
=a_t+\alpha k_t+(1-\alpha)h_t.
\]

- **(F19) Capital accumulation**:

\[
k_{t+1}=(1-\delta)k_t+\delta(\mu_t+i_t).
\]

- **(F20) Short-rate Taylor rule**:

\[
r_t=\rho r_{t-1}+(1-\rho)(\tau_\pi\pi_t+\tau_y y_t^{gap})+\epsilon_t^r.
\]

- **(F21) Market-segmentation distortion as discounted future spreads**:

\[
m_t=E_t\sum_{j=0}^{\infty}(\beta\kappa)^j\Xi_{t+j},
\qquad
\Xi_{t+j}\equiv\beta\kappa q_{t+j+1}-q_{t+j}-r_{t+j}\approx r_{t+j}^{L}-r_{t+j}.
\]

- **(F22) Expectations-hypothesis bond price**:

\[
r_t=E_t\frac{\kappa q_{t+1}^{EH}}{R_{ss}}-q_t^{EH}.
\]

- **(F23) Expectations-hypothesis ten-year yield**:

\[
r_t^{EH,10}=\left(\frac{R_{ss}-\kappa}{R_{ss}}\right)q_t^{EH}.
\]

- **(F24) Term premium definition**:

\[
tp_t=r_t^{10}-r_t^{EH,10}
=-\left(\frac{R_{ss}^{L}-\kappa}{R_{ss}^{L}}\right)q_t
+\left(\frac{R_{ss}-\kappa}{R_{ss}}\right)q_t^{EH}.
\]

- **(F25) Exogenous long-debt policy rule for `US_CFP17exo`**:

\[
b_t=\rho_1^b b_{t-1}+\rho_2^b b_{t-2}+\epsilon_t^b.
\]

- **(F26) Taylor rule augmented with term premium, used in policy experiments**:

\[
r_t=\rho r_{t-1}+(1-\rho)(\tau_\pi\pi_t+\tau_y y_t^{gap}+\tau_{tp}tp_t).
\]

- **(F27) Output gap definition**:

\[
y_t^{gap}=y_t-y_t^f.
\]

- **(F28) Flexible-price resource constraint, implementation cross-check**:

\[
\frac{C_{ss}}{Y_{ss}}c_t^f+\frac{I_{ss}}{Y_{ss}}i_t^f=y_t^f.
\]

- **(F29) Flexible-price production, implementation cross-check**:

\[
y_t^f=a_t+\alpha k_{t-1}^f+(1-\alpha)h_t^f.
\]

- **(F30) Annualized observables and spreads, implementation cross-check**:

\[
ann\_\pi_t=4\pi_t,\qquad ann\_r1_t=4r_t,\qquad ann\_r2_t=4r_t^L,\qquad spread_t=ann\_r2_t-ann\_r1_t.
\]

## 5. Exogenous Processes

- **(F31) TFP shock**:

\[
a_t=\rho_Aa_{t-1}+\varepsilon_{a,t}.
\]

- **(F32) Credit / financial-friction shock**:

\[
\phi_t=(1-\rho_\phi)\phi_{ss}+\rho_\phi\phi_{t-1}+\varepsilon_{\phi,t}.
\]

The Rep-MMB implementation uses `u_psi` as the linear credit shock state:

\[
u_{\psi,t}=\rho_\phi u_{\psi,t-1}+\varepsilon_{\psi,t}.
\]

- **(F33) Investment shock**:

\[
\log\mu_t=\rho_\mu\log\mu_{t-1}+\varepsilon_{\mu,t}.
\]

- **(F34) Natural-rate / discount shock**:

\[
rn_t=\rho_{rn}rn_{t-1}+\varepsilon_{rn,t}.
\]

- **(F35) Price and wage markup shocks, implementation cross-check**:

\[
mk_t=\rho_{mk}mk_{t-1}+\varepsilon_{mk,t},\qquad
mkw_t=\rho_{mkw}mkw_{t-1}+\varepsilon_{mkw,t}.
\]

## 6. Steady-State Solution

The archive entry records the paper's steady-state normalization and calibration equations. Because `US_CFP17exo` is implemented as `model(linear)`, all endogenous variables in the Dynare model are deviations around this steady state and have zero simulation steady state.

1. Normalize technology, investment efficiency, and labor:

\[
A_{ss}=1,\qquad \mu_{ss}=1,\qquad H_{ss}=1.
\]

2. Household marginal utility and short rate:

\[
\Lambda_{ss}=\frac{1-\beta h}{(1-h)C_{ss}},\qquad 1=\beta R_{ss}.
\]

3. Wage disutility parameter:

\[
B=W_{ss}\Lambda_{ss}.
\]

4. Capital return and segmentation wedge:

\[
R_{ss}^{k}=\frac{M_{ss}[1-\beta(1-\delta)]}{\beta},\qquad
M_{ss}=\frac{\beta}{(1-\beta\kappa)Q_{ss}^{I}}.
\]

5. Price markup and marginal cost:

\[
MC_{ss}=\frac{\epsilon_p-1}{\epsilon_p}.
\]

6. Capital-output ratio:

\[
\frac{K_{ss}}{Y_{ss}}=
\frac{\beta\alpha MC_{ss}}{M_{ss}[1-\beta(1-\delta)]},
\qquad
K_{ss}=\left(\frac{K_{ss}}{Y_{ss}}\right)^{1/(1-\alpha)}.
\]

7. Goods-market steady state:

\[
I_{ss}=\delta K_{ss},\qquad C_{ss}=Y_{ss}-\delta K_{ss}.
\]

8. Intermediary and long-bond steady state:

\[
1=\beta\zeta R_{ss}^{L},\qquad Q=(R_{ss}^{L}-\kappa)^{-1},\qquad R_{ss}^{10}=R_{ss}^{L}.
\]

9. Calibration targets reported by the paper:

\[
\beta=0.99,\qquad \beta R_{ss}^{L}=1.0025,\qquad L_{ss}=6,\qquad
(1-\kappa)^{-1}=40,\qquad
\frac{\overline{B}_{ss}}{\overline{B}_{ss}+\overline{F}_{ss}}=0.40.
\]

Steady-state formula quality: `needs_review`. The paper appendix provides formulas, but several OCR expressions require source-level checking against the PDF before a reviewed archive status.

## 7. Timing & Form Conventions

- **Form**: linearized model (`model(linear)`); lower-case variables are log deviations or linear deviations from the nonstochastic steady state.
- **Expectations**: the paper writes \(E_t\) explicitly in the log-linear system; the `.mod` cross-check encodes these with Dynare leads.
- **Capital timing**: the paper's log-linear equation uses \(k_{t+1}=(1-\delta)k_t+\delta(\mu_t+i_t)\), while the Rep-MMB file shifts the stock so production uses `k(-1)` and accumulation is written as `k=(1-delta)*k(-1)+delta*(i+muinv)`.
- **Long-bond timing**: the return on intermediated assets depends on next-period bond prices, \(r_{t+1}^L=\kappa q_{t+1}/R_{ss}^L-q_t\); the implementation writes the contemporaneous variable as `r2 = kappa*q(+1)/R2ss - q`.
- **Variant convention**: `US_CFP17exo` uses the exogenous debt rule for long bonds. The endogenous term-premium peg is a separate conceptual policy regime and belongs to `US_CFP17endo`.
- **Runtime validation**: not performed. The Rep-MMB `.mod` contains `steady; check;` and `stoch_simul`, but this archive task did not run Dynare.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Main equation(s) |
|---|---|---|---|
| Endogenous | \(\lambda_t\) / `muc` | marginal utility of consumption | (F1), (F5) |
| Endogenous | \(c_t\) / `c` | consumption | (F1), (F18) |
| Endogenous | \(h_t\) / `L` | hours / labor input | (F2), (F18) |
| Endogenous | \(mrs_t\) / `mrs` | marginal rate of substitution | (F2), (F3) |
| Endogenous | \(w_t\) / `w` | real wage | (F4), (F14) |
| Endogenous | \(\pi_t^w\) / `pinw` | wage inflation | (F3), (F4) |
| Endogenous | \(\pi_t\) / `pin` | price inflation | (F3), (F4), (F16) |
| Endogenous | \(r_t\) / `r1` | short nominal policy/deposit rate | (F5), (F20), (F26) |
| Endogenous | \(p_t^k\) / `pk` | real price of capital | (F6), (F17) |
| Endogenous | \(m_t\) / `m` | segmentation wedge | (F6), (F7), (F21) |
| Endogenous | \(r_t^k\) / `rk` | rental return on capital | (F6), (F15) |
| Endogenous | \(q_t\) / `q` | long-bond price | (F7), (F9), (F10), (F24) |
| Endogenous | \(f_t\) / `f` | investment-bond asset value | (F8), (F13) |
| Endogenous | \(r_t^L\) / `r2` | return on intermediated long assets | (F9), (F11), (F30) |
| Endogenous | \(r_t^{10}\) / `r10` | ten-year yield | (F10), (F24) |
| Endogenous | \(l_t\) / `lev` | leverage | (F11), (F13) |
| Endogenous | \(n_t\) / `nw` | intermediary net worth | (F12), (F13) |
| Endogenous | \(mc_t\) / `mc` | real marginal cost | (F14), (F15), (F16) |
| Endogenous | \(i_t\) / `i` | investment | (F8), (F17), (F18), (F19) |
| Endogenous | \(y_t\) / `y` | output | (F18), (F27) |
| Endogenous | \(k_t\) / `k` | capital stock | (F18), (F19) |
| Endogenous | \(q_t^{EH}\) / `qnat` | expectations-hypothesis bond price | (F22), (F23) |
| Endogenous | \(tp_t\) / `term_prem` | term premium | (F24), (F26) |
| Endogenous | \(b_t\) / `b2` | long government bonds held by intermediaries | (F25) |
| Endogenous | \(y_t^{gap}\) / `ygap` | output gap | (F20), (F27) |
| Endogenous | flexible-price block / `cf`, `yf`, `kf`, etc. | flexible-price counterpart variables | (F28), (F29) |
| Exogenous | \(\varepsilon_{a,t}\) / `eps_a` | TFP innovation | (F31) |
| Exogenous | \(\varepsilon_{\phi,t}\) / `eps_psi` | credit / financial-friction innovation | (F32) |
| Exogenous | \(\varepsilon_{\mu,t}\) / `eps_i` | investment shock innovation | (F33) |
| Exogenous | \(\varepsilon_{rn,t}\) / `eps_rn` | natural-rate / discount shock innovation | (F34) |
| Exogenous | \(\varepsilon_t^r\) / `eps_mp` | monetary policy shock innovation | (F20) |
| Exogenous | \(\varepsilon_t^b\) / `eps_b2` | exogenous long-debt / QE innovation | (F25) |
| Exogenous | \(\varepsilon_{mk,t}\) / `eps_mk` | price markup innovation | (F35) |
| Exogenous | \(\varepsilon_{mkw,t}\) / `eps_mkw` | wage markup innovation | (F35) |
| Parameter | `beta` | household discount factor | steady state |
| Parameter | `h` | habit persistence | (F1) |
| Parameter | `eta` | inverse labor supply elasticity | (F2) |
| Parameter | `alpha` | capital share | (F18), (F29) |
| Parameter | `delta` | depreciation rate | (F6), (F19) |
| Parameter | `kappa`, `kappa_i` | perpetuity decay parameters / duration | (F7), (F9), (F22) |
| Parameter | `psi_i` | investment adjustment cost | (F17) |
| Parameter | `psi_n` | net-worth adjustment cost | (F12) |
| Parameter | `zeta` | FI discount wedge | steady state |
| Parameter | `theta_p`, `theta_w` | Calvo price and wage non-reset probabilities | (F3), (F16) |
| Parameter | `i_p`, `i_w` | price and wage indexation | (F3), (F16) |
| Parameter | `rhoi`, `tau_pi`, `tau_y`, `tau_prem` | short-rate rule coefficients | (F20), (F26) |
| Parameter | `rho1_b`, `rho2_b` | exogenous long-debt AR coefficients | (F25) |
| Parameter | `rho_a`, `rho_phi`, `rho_mu`, `rho_rn`, `rhomk`, `rhomkw` | shock persistence parameters | (F31)-(F35) |
