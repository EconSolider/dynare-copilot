# US_CFP17endo -- Derivation (Optimization Problems + First-Order Conditions)

> Purpose: private MMB derivation archive entry for later Dynare review.
> Source: Carlstrom, Fuerst, and Paustian (2017), "Targeting long rates in a model with segmented markets," American Economic Journal: Macroeconomics, DOI `10.1257/mac.20150179`.
> Status: `needs_review`; first-pass extraction from MinerU Markdown. Runtime validation was not performed.

## 1. Model Overview

- **Model**: segmented-markets Dynamic New Keynesian model with financial intermediaries, long-duration nominal bonds, investment finance through long-term investment bonds, and sticky prices and wages.
- **MMB variant**: `US_CFP17endo`. The MMB implementation cross-check sets the endogenous long-debt/term-premium policy closure: `term_prem = 0` and `term_premf = 0`.
- **Agents**: households, employment agencies, financial intermediaries, final-good aggregators, monopolistically competitive intermediate-good firms, new-capital producers, monetary authority, passive fiscal authority.
- **Form**: `model(linear)` / log-linearized model. The paper presents nonlinear primitives and then uses lower-case variables as log deviations in the log-linearized system. The MMB `.mod` is explicitly a linearized implementation.
- **Core mechanism**: intermediary net worth and a hold-up constraint limit arbitrage between short deposit rates and long lending rates. The induced loan-deposit spread creates a market-segmentation wedge in investment finance. Under the endogenous-debt regime, the central bank adjusts long-bond holdings so that the term premium is pegged.
- **Provenance**: primary Markdown `raw/mmb_mineru/runs/us_cfp17endo_us_cfp17exo__targeting_long_rates_in_a_model_with_segmented_markets__d8728772/full.md`; raw PDF `raw/mmb_papers/Targeting long rates in a model with segmented markets.pdf`; MinerU run id `d8728772-c118-4e20-9cec-bcc6e7b742d5`; no local appendix normalization file.

## 2. Optimization Problems

### 2.1 Households

Households choose consumption, specialized labor, short deposits, physical capital, and investment-bond issuance subject to habit preferences, wage stickiness, capital accumulation, and the loan-in-advance financing condition for investment. In the paper-side nonlinear notation:

$$
\max E_0\sum_{s=0}^{\infty}\beta^s e^{rn_{t+s}}
\left\{\ln(C_{t+s}-hC_{t+s-1})-B\frac{H_{t+s}(j)^{1+\eta}}{1+\eta}\right\}.
$$

The representative household budget, capital law, and investment financing constraint are:

$$
C_t+\frac{D_t}{P_t}+P_t^k I_t+\frac{F_{t-1}}{P_t}
\le W_tH_t+R_t^kK_t-T_t+\frac{D_{t-1}}{P_t}R_{t-1}
+\frac{Q_t(F_t-\kappa F_{t-1})}{P_t}+div_t.
$$

$$
K_{t+1}\le (1-\delta)K_t+I_t.
$$

$$
P_t^k I_t \le \frac{Q_t(F_t-\kappa F_{t-1})}{P_t}.
$$

The perpetual investment-bond stock obeys $CI_t=F_t-\kappa F_{t-1}$.

### 2.2 Wage Setting

Employment agencies aggregate differentiated labor:

$$
H_t=\left[\int_0^1 H_t(j)^{1/(1+\lambda_{w,t})}dj\right]^{1+\lambda_{w,t}}.
$$

With Calvo wage rigidity, non-reoptimizing households index nominal wages to lagged inflation, while reoptimizing households choose a wage to maximize discounted labor income net of disutility subject to agency labor demand. The log-linear wage Phillips curve below summarizes this block.

### 2.3 Financial Intermediaries

Financial intermediaries use net worth and short deposits to hold investment bonds and long-term government bonds. Their balance sheet is:

$$
\frac{B_t}{P_t}Q_t+\frac{F_t}{P_t}Q_t=\frac{D_t}{P_t}+N_t=L_tN_t.
$$

The FI chooses dividends and next-period net worth:

$$
V_t=\max_{N_t,div_t}E_t\sum_{j=0}^{\infty}(\beta\zeta)^j\Lambda_{t+j}div_{t+j},
$$

subject to

$$
div_t+N_t[1+f(N_t)]\le
\frac{P_{t-1}}{P_t}\left[(R_t^L-R_{t-1}^d)L_{t-1}+R_{t-1}^d\right]N_{t-1},
$$

where $f(N_t)=\frac{\psi_n}{2}\left(\frac{N_t-N_{ss}}{N_{ss}}\right)^2$.

### 2.4 Firms and Capital Producers

Final-good firms aggregate differentiated intermediate goods with CES technology. Intermediate firms use Cobb-Douglas production,

$$
Y_t(i)=A_tK_t(i)^\alpha H_t(i)^{1-\alpha},
$$

and face Calvo price rigidity with indexation. New-capital producers transform investment goods into capital with adjustment costs:

$$
P_t^k\mu_t\left[1-S\left(\frac{I_t}{I_{t-1}}\right)\right]I_t-I_t,
\qquad
S\left(\frac{I_t}{I_{t-1}}\right)=\frac{\psi_i}{2}\left(\frac{I_t}{I_{t-1}}-1\right)^2.
$$

### 2.5 Policy Authorities

The monetary authority sets the short rate with an interest-rate rule. In the endogenous-debt variant, long-bond supply is endogenous and closes the long-debt market by pegging the term premium. Fiscal policy is passive: government expenditures are zero and lump-sum taxes support debt payments.

## 3. First-Order Conditions

The numbered equations below are the first-pass model archive normalization. The paper's log-linearized model uses lower-case variables as log deviations; expectation operators are preserved where stated in the paper. Some OCR symbols, especially around $\psi_n n_t$ and $\nu$, require source-level review before promotion beyond `needs_review`.

**Household block**

**(F1) Marginal utility of consumption**:

$$
\lambda_t=
\frac{1}{(1-\beta h)(1-h)}E_t\left[\beta h c_{t+1}-(1+\beta h^2)c_t+h c_{t-1}\right]
+\frac{1}{1-\beta h}(rn_t-\beta h E_t rn_{t+1}).
$$

**(F2) Marginal rate of substitution**:

$$
rn_t+\eta h_t-\lambda_t=mrs_t.
$$

**(F3) Wage Phillips curve**:

$$
\pi_t^w-\iota_w\pi_{t-1}
=\kappa_w(mrs_t-w_t)+\beta(\pi_{t+1}^w-\iota_w\pi_t)+\epsilon_t^w.
$$

**(F4) Real wage accumulation**:

$$
w_t=w_{t-1}+\pi_t^w-\pi_t.
$$

**(F5) Fisher/Euler equation for deposits**:

$$
\lambda_t=E_t\lambda_{t+1}+r_t-E_t\pi_{t+1}.
$$

**(F6) Capital Euler equation with segmentation wedge**:

$$
\lambda_t+p_t^k+m_t
=E_t\left\{\lambda_{t+1}+[1-\beta(1-\delta)]r_{t+1}^k
+\beta(1-\delta)(p_{t+1}^k+m_{t+1})\right\}.
$$

**(F7) Investment-bond Euler equation**:

$$
\lambda_t+q_t+m_t=E_t\lambda_{t+1}-E_t\pi_{t+1}
+\beta\kappa E_t(q_{t+1}+m_{t+1}).
$$

**(F8) Investment-bond issuance relation**:

$$
(1-\kappa)(p_t^k+i_t)=f_t-\kappa(f_{t-1}+q_t-q_{t-1}-\pi_t).
$$

**Financial intermediary and term-structure block**

**(F9) Return on FI long asset portfolio**:

$$
r_{t+1}^L=\frac{\kappa q_{t+1}}{R_{ss}^L}-q_t.
$$

**(F10) Ten-year bond yield from long-bond price**:

$$
r_t^{10}=-\left(\frac{R_{ss}^L-\kappa}{R_{ss}^L}\right)q_t.
$$

**(F11) Hold-up/leverage spread condition**:

$$
E_t(r_{t+1}^L-r_t)
=\left(\frac{1}{L_{ss}-1}\right)l_t
+\left[\frac{1+(s-1)L_{ss}}{L_{ss}-1}\right]\phi_t.
$$

**(F12) Net-worth adjustment condition** (`needs_review` OCR normalization):

$$
\psi_n n_t=
\left[\frac{sL_{ss}}{1+L_{ss}(s-1)}\right]E_t(r_{t+1}^L-r_t)
+\left[\frac{(s-1)L_{ss}}{1+L_{ss}(s-1)}\right]l_t.
$$

**(F13) FI balance-sheet composition**:

$$
\frac{\overline{B}_{ss}}{L_{ss}N_{ss}}b_t+
\left(1-\frac{\overline{B}_{ss}}{L_{ss}N_{ss}}\right)f_t
=n_t+l_t.
$$

**Production, pricing, and investment supply**

**(F14) Real wage equals marginal cost plus marginal product of labor**:

$$
w_t=mc_t+mpl_t.
$$

**(F15) Rental rate equals marginal cost plus marginal product of capital**:

$$
r_t^k=mc_t+mpk_t.
$$

**(F16) Price Phillips curve**:

$$
\pi_t=\frac{\kappa_\pi}{1+\beta\iota_p}mc_t
+\frac{\beta}{1+\beta\iota_p}E_t\pi_{t+1}
+\frac{\iota_p}{1+\beta\iota_p}\pi_{t-1}
+\epsilon_t^p.
$$

**(F17) Investment supply / price of capital**:

$$
p_t^k=\psi_i\left[(i_t-i_{t-1})-\beta E_t(i_{t+1}-i_t)\right]-\mu_t.
$$

**(F18) Resource/accounting identity**:

$$
\left(1-\frac{I_{ss}}{Y_{ss}}\right)c_t+\frac{I_{ss}}{Y_{ss}}i_t
=a_t+\alpha k_t+(1-\alpha)h_t.
$$

**(F19) Capital accumulation**:

$$
k_{t+1}=(1-\delta)k_t+\delta(\mu_t+i_t).
$$

**Policy and term-premium definitions**

**(F20) Short-rate Taylor rule**:

$$
r_t=\rho r_{t-1}+(1-\rho)(\tau_\pi\pi_t+\tau_y y_t^{gap})+\epsilon_t^r.
$$

**(F21) Segmentation wedge as discounted loan-deposit spreads**:

$$
m_t=E_t\sum_{j=0}^{\infty}(\beta\kappa)^j\Xi_{t+j},
\qquad
\Xi_{t+j}\equiv \beta\kappa q_{t+j+1}-q_{t+j}-r_{t+j}\approx r_{t+j}^L-r_{t+j}.
$$

**(F22) Expectations-hypothesis bond price**:

$$
r_t=E_t\frac{\kappa q_{t+1}^{EH}}{R_{ss}}-q_t^{EH}.
$$

**(F23) Expectations-hypothesis ten-year yield**:

$$
r_t^{EH,10}=\left(\frac{R_{ss}-\kappa}{R_{ss}}\right)q_t^{EH}.
$$

**(F24) Term premium definition**:

$$
tp_t=r_t^{10}-r_t^{EH,10}
=-\left(\frac{R_{ss}^L-\kappa}{R_{ss}^L}\right)q_t
+\left(\frac{R_{ss}-\kappa}{R_{ss}}\right)q_t^{EH}.
$$

**(F25) Exogenous-debt policy, not the `US_CFP17endo` closure**:

$$
b_t=\rho_1^b b_{t-1}+\rho_2^b b_{t-2}+\epsilon_t^b.
$$

**(F26) Taylor rule augmented with term premium, alternative policy**:

$$
r_t=\rho r_{t-1}+(1-\rho)(\tau_\pi\pi_t+\tau_y y_t^{gap}+\tau_{tp}tp_t).
$$

**(F27) Endogenous-debt closure for `US_CFP17endo`**:

$$
tp_t=0.
$$

## 4. Market Clearing & Identities

The final-good accounting identity is embedded in (F18). The paper writes it as the log-linear resource identity after substituting production:

$$
\left(1-\frac{I_{ss}}{Y_{ss}}\right)c_t+\frac{I_{ss}}{Y_{ss}}i_t=y_t,
\qquad
y_t=a_t+\alpha k_t+(1-\alpha)h_t.
$$

The FI balance sheet is (F13), with real asset values of long government bonds and investment bonds allocated across net worth and leverage. The investment-bond stock recursion is (F8). Short government bonds are perfect substitutes for deposits and move endogenously to support the short-rate target, so they are not an independent market-clearing equation in the log-linear core. In `US_CFP17endo`, long-bond supply is endogenous: (F27) replaces the exogenous-debt process (F25), and (F13) determines the required long-bond movement.

## 5. Exogenous Processes

The paper-side Markdown gives these stochastic processes explicitly:

**(F28) Discount-factor shock**:

$$
rn_t=\rho_{rn}rn_{t-1}+\varepsilon_{rn,t}.
$$

**(F29) Wage markup shock**:

$$
\log\lambda_{w,t}=(1-\rho_w)\log\lambda_w+\rho_w\log\lambda_{w,t-1}
+\varepsilon_{w,t}-\theta_w\varepsilon_{w,t-1}.
$$

**(F30) Technology shock**:

$$
\ln A_t=\rho_A\ln A_{t-1}+\varepsilon_{a,t}.
$$

**(F31) Investment shock**:

$$
\log\mu_t=\rho_\mu\log\mu_{t-1}+\varepsilon_{\mu,t}.
$$

**(F32) Financial-friction / credit shock**:

$$
\phi_t=(1-\rho_\phi)\phi_{ss}+\rho_\phi\phi_{t-1}+\varepsilon_{\phi,t}.
$$

**(F33) Monetary-policy shock**:

$$
\epsilon_t^r=\rho_r\epsilon_{t-1}^r+\varepsilon_{r,t}
$$

where the paper describes the policy residual as autocorrelated. The MMB implementation cross-check maps innovations to `eps_a`, `eps_mp`, `eps_i`, `eps_psi`, `eps_mk`, `eps_mkw`, `eps_b2`, and `eps_rn`.

## 6. Steady-State Solution

Because the MMB implementation is a log-linear model, the local steady state for variables expressed as deviations is zero:

$$
\bar c=\bar i=\bar y=\bar k=\bar h=\bar q=\bar n=\bar l=\bar m=\bar \pi=\bar r-\bar r_{ss}=0.
$$

The nonlinear calibration targets needed to construct the log-linear coefficients are:

1. Set the quarterly household discount factor $\beta=0.99$.
2. Set production parameters $\alpha=0.33$ and $\delta=0.025$.
3. Set price and wage substitution elasticities so that price and wage markups are 20 percent.
4. Match a steady-state term premium of 100 annual basis points and leverage $L_{ss}=6$ through $\zeta$ and $\Phi_{ss}$:

$$
\zeta=\left(\frac{R_{ss}^{10}}{R_{ss}^{10,EH}}\right)^{-1},
\qquad
L_{ss}=\left[1+(\Phi_{ss}-1)\left(\frac{R_{ss}^{10}}{R_{ss}^{10,EH}}\right)\right]^{-1}.
$$

5. Set long-bond duration to 40 quarters:

$$
(1-\kappa)^{-1}=40.
$$

6. Set long government securities to 40 percent of FI assets:

$$
\frac{\overline B_{ss}}{\overline B_{ss}+\overline F_{ss}}=0.40.
$$

For `US_CFP17endo`, the policy steady state also satisfies $\bar{tp}=0$ in deviation terms. Exact parameter values are loaded by the `.mod` from `parameterfile`; runtime validation and steady-state numeric checking were not performed.

## 7. Timing & Form Conventions

- **Form**: log-linearized `model(linear)` style, with lower-case variables denoting deviations from steady state. The MMB `.mod` contains both sticky-price variables and flexible-price counterparts with `f` suffixes.
- **Capital timing**: the paper writes nonlinear accumulation as $K_{t+1}=(1-\delta)K_t+I_t$ and log-linear accumulation as $k_{t+1}=(1-\delta)k_t+\delta(\mu_t+i_t)$. The `.mod` indexes current production by `k(-1)` and writes `k = (1-delta)*k(-1)+delta*(i+muinv)`, so `k` is a predetermined stock available for next-period production.
- **Bond timing**: perpetual bond price $Q_t$ prices a new issue at time $t$; $F_t$ is the stock of investment-bond obligations and $F_t-\kappa F_{t-1}$ is new issuance. The loan return uses next-period bond price, $r_{t+1}^L=\kappa q_{t+1}/R_{ss}^L-q_t$.
- **Endogenous-debt convention**: `US_CFP17endo` pegs the term premium. The long-government-bond quantity adjusts endogenously through the FI balance-sheet identity, while the short-rate rule continues to set the deposit/T-bill rate.
- **Implementation cross-check**: `.agents/skills/dynare-copilot/references/examples/US_CFP17endo_rep.mod` confirms variable names, shocks, and the endogenous closure, but it is not a paper-side mathematical source.

## 8. Variable & Parameter Reference Table

### Endogenous Variables

| Symbol / ASCII | Meaning | Main determining equation |
|---|---|---|
| `muc`, $\lambda_t$ | marginal utility of consumption | (F1) |
| `mrs` | marginal rate of substitution | (F2) |
| `pinw` | wage inflation | (F3) |
| `w` | real wage | (F4), (F14) |
| `r1`, $r_t$ | short nominal/deposit rate | (F5), (F20) |
| `pk` | real price of capital | (F6), (F17) |
| `m` | segmentation wedge | (F6), (F7), (F21) |
| `q`, `qi` | long-bond / investment-bond prices | (F7), (F9), (F10) |
| `f` | investment-bond stock/value | (F8), (F13) |
| `r2`, $r^L$ | FI long-asset return | (F9) |
| `r10` | observed ten-year yield | (F10) |
| `lev` | leverage | (F11), (F13) |
| `nw` | FI net worth | (F12), (F13) |
| `mc` | real marginal cost | (F14)-(F16) |
| `rk` | rental rate of capital | (F15) |
| `pin` | price inflation | (F16) |
| `i` | investment | (F17)-(F19) |
| `c` | consumption | (F18) |
| `y` | output | (F18) |
| `k` | capital stock | (F19) |
| `qnat`, `r10_nat` | EH bond price and yield | (F22)-(F24) |
| `term_prem` | term premium | (F24), (F27) |
| `b2`, `bb2` | long government bonds / QE policy variable | (F13), (F25), (F27) |
| `ygap` | output gap | (F20) |

### Exogenous Shocks

| ASCII | Meaning |
|---|---|
| `eps_a` | technology innovation |
| `eps_mp` | monetary-policy innovation |
| `eps_i` | investment-specific technology innovation |
| `eps_psi` | financial-friction / credit innovation |
| `eps_mk` | price-markup innovation |
| `eps_mkw` | wage-markup innovation |
| `eps_b2` | exogenous long-bond/QE innovation; inactive under the term-premium peg except as an implementation variable |
| `eps_rn` | discount-factor / natural-rate innovation |

### Parameters

| ASCII / symbol | Meaning |
|---|---|
| `alpha`, $\alpha$ | capital share |
| `beta`, $\beta$ | discount factor |
| `delta`, $\delta$ | depreciation |
| `eta`, $\eta$ | labor disutility curvature |
| `gamma`, $L_{ss}$-related calibration | leverage/FI balance-sheet steady-state parameter in implementation |
| `h` | habit parameter |
| `kappa`, $\kappa$ | perpetuity decay for long government bonds |
| `kappa_i` | perpetuity decay for investment bonds |
| `psi_i` | investment adjustment cost |
| `psi_n` | FI net-worth adjustment cost |
| `zeta`, $\zeta$ | FI impatience wedge |
| `tau_pi`, `tau_y`, `tau_prem` | Taylor-rule responses |
| `rho_a`, `rho_phi`, `rho_mu`, `rho_rn`, `rho_m` | shock persistence parameters |
| `theta_p`, `theta_w` | Calvo price and wage non-reset probabilities |
| `i_p`, `i_w` | price and wage indexation parameters |
| `kappapc`, `kappaw` | Phillips-curve slopes |
| `Y_ss`, `I_ss`, `C_ss`, `R1ss`, `R2ss`, `nwss`, `premss` | steady-state scaling constants used in the `.mod` |
