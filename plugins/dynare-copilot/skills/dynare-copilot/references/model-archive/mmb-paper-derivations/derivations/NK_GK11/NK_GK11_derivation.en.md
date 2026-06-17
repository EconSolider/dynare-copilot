# NK_GK11 Derivation: Gertler-Karadi (2011)

Provenance: `NK_GK11`, Mark Gertler and Peter Karadi (2011), "A model of unconventional monetary policy", *Journal of Monetary Economics* 58(1), 17-34. DOI: `10.1016/j.jmoneco.2010.10.004`. Main source: `raw/mmb_mineru/runs/nk_gk09lin_nk_gk11__a_model_of_unconvetional_monetary_policy__e6192938/full.md`. Raw PDF exists at `raw/mmb_papers/A Model of Unconvetional Monetary Policy.pdf`; PDF body was not read. MinerU run id used for extraction: `e6192938-5688-49c7-9621-66ca2478274f`. Appendix normalization: none found. Implementation cross-check: `.agents/skills/dynare-copilot/references/examples/NK_GK11_rep.mod`.

Runtime validation was not performed. This is a first-pass source-backed derivation and remains `needs_review`, mainly because several MinerU equations contain OCR quirks in subscripts and Greek-letter rendering.

## 1. Model Overview

- **Model**: closed-economy New Keynesian DSGE model with financial intermediaries, endogenous intermediary balance-sheet constraints, capital-quality shocks, and optional central-bank credit intermediation.
- **Core agents**: representative household with workers and bankers, private financial intermediaries, competitive intermediate goods producers, capital producers, monopolistically competitive retailers, fiscal authority, and central bank.
- **Financial mechanism**: bankers face an incentive constraint because they can divert a fraction of assets. When the constraint binds, total private lending is tied to intermediary net worth through an endogenous leverage ratio.
- **Unconventional policy**: the central bank can intermediate a fraction of assets by issuing riskless government debt and lending to private firms. Public intermediation is not leverage constrained but consumes resources at cost `tau`.
- **Model form**: nonlinear equilibrium conditions in levels in the paper; the MMB implementation stores most real variables in logs and runs a first-order approximation. This derivation records the nonlinear source equations.

## 2. Optimization Problems

### Household

The household chooses consumption, labor, and one-period riskless bond holdings. It has habit formation in consumption:

$$
\max_{\{C_t,L_t,B_{t+1}\}} E_t \sum_{i=0}^{\infty}\beta^i
\left[\log(C_{t+i}-h C_{t+i-1})-\frac{\chi}{1+\varphi}L_{t+i}^{1+\varphi}\right].
$$

The period budget constraint is

$$
C_t = W_tL_t+\Pi_t+T_t+R_tB_t-B_{t+1}.
$$

### Banker/intermediary

Banker `j` starts period `t` with net worth `N_{jt}` and obtains deposits `B_{jt+1}` to purchase claims `S_{jt}` at price `Q_t`:

$$
Q_tS_{jt}=N_{jt}+B_{jt+1}.
$$

Intermediary net worth next period equals asset payoffs less deposit repayment:

$$
N_{j,t+1}=R_{k,t+1}Q_tS_{jt}-R_{t+1}B_{j,t+1}.
$$

The banker maximizes expected terminal wealth:

$$
V_{jt}=\max E_t\sum_{i=0}^{\infty}(1-\theta)\theta^i\beta^{i+1}
\Lambda_{t,t+1+i}N_{j,t+1+i}.
$$

Depositors lend only if the franchise value exceeds the gain from diverting a fraction of assets:

$$
V_{jt}\geq \lambda Q_tS_{jt}.
$$

### Intermediate goods producer

At the end of `t`, firms acquire capital for use at `t+1` by issuing claims equal to capital acquired:

$$
Q_tK_{t+1}=Q_tS_t.
$$

At `t`, they choose utilization and labor to produce

$$
Y_t=A_t(U_t\xi_tK_t)^\alpha L_t^{1-\alpha}.
$$

### Capital producer

Capital producers buy and refurbish depreciated capital and produce new capital subject to flow adjustment costs. Their discounted profit problem is

$$
\max_{\{I_{n,t}\}} E_t\sum_{\tau=t}^{\infty}\beta^{\tau-t}\Lambda_{t,\tau}
\left[(Q_\tau-1)I_{n,\tau}
-f\!\left(\frac{I_{n,\tau}+I_{ss}}{I_{n,\tau-1}+I_{ss}}\right)(I_{n,\tau}+I_{ss})\right].
$$

### Retailers

Final output is a CES aggregate of differentiated retail goods:

$$
Y_t=\left[\int_0^1 Y_{ft}^{(\varepsilon-1)/\varepsilon}df\right]^{\varepsilon/(\varepsilon-1)}.
$$

Retailer `f` chooses its reset price under Calvo stickiness and lagged inflation indexation:

$$
\max_{P_t^*} E_t\sum_{i=0}^{\infty}\gamma^i\beta^i\Lambda_{t,t+i}
\left[
\frac{P_t^*}{P_{t+i}}\prod_{k=1}^{i}(1+\pi_{t+k-1})^{\gamma_p}
-P_{m,t+i}
\right]Y_{f,t+i}.
$$

## 3. First-Order Conditions

**Household**

- **(F1) Marginal utility with external habit**:

$$
\varrho_t=(C_t-hC_{t-1})^{-1}-\beta h E_t(C_{t+1}-hC_t)^{-1}.
$$

- **(F2) Labor supply**:

$$
\varrho_t W_t=\chi L_t^\varphi.
$$

- **(F3) Euler equation for riskless bonds**:

$$
E_t\beta\Lambda_{t,t+1}R_{t+1}=1,\qquad
\Lambda_{t,t+1}=\frac{\varrho_{t+1}}{\varrho_t}.
$$

**Financial intermediaries**

- **(F4) Balance sheet**:

$$
Q_tS_{jt}=N_{jt}+B_{j,t+1}.
$$

- **(F5) Net-worth accumulation**:

$$
N_{j,t+1}=(R_{k,t+1}-R_{t+1})Q_tS_{jt}+R_{t+1}N_{jt}.
$$

- **(F6) Banker value decomposition**:

$$
V_{jt}=\nu_t Q_tS_{jt}+\eta_t N_{jt}.
$$

- **(F7) Marginal value of intermediary assets**:

$$
\nu_t=E_t\left\{(1-\theta)\beta\Lambda_{t,t+1}(R_{k,t+1}-R_{t+1})
+\beta\Lambda_{t,t+1}\theta x_{t,t+1}\nu_{t+1}\right\}.
$$

- **(F8) Marginal value of intermediary net worth**:

$$
\eta_t=E_t\left\{(1-\theta)+\beta\Lambda_{t,t+1}\theta z_{t,t+1}\eta_{t+1}\right\}.
$$

- **(F9) Incentive constraint**:

$$
\eta_tN_{jt}+\nu_tQ_tS_{jt}\geq \lambda Q_tS_{jt}.
$$

- **(F10) Binding leverage relation**:

$$
Q_tS_{jt}=\frac{\eta_t}{\lambda-\nu_t}N_{jt}\equiv \phi_tN_{jt}.
$$

- **(F11) Aggregate privately intermediated assets**:

$$
Q_tS_{p,t}=\phi_tN_t.
$$

- **(F12) Growth in intermediary net worth**:

$$
z_{t,t+1}=(R_{k,t+1}-R_{t+1})\phi_t+R_{t+1}.
$$

- **(F13) Growth in intermediary assets**:

$$
x_{t,t+1}=\frac{\phi_{t+1}}{\phi_t}z_{t,t+1}.
$$

- **(F14) Aggregate intermediary net worth**:

$$
N_t=N_{e,t}+N_{n,t}.
$$

- **(F15) Existing bankers' net worth**:

$$
N_{e,t}=\theta\left[(R_{k,t}-R_t)\phi_{t-1}+R_t\right]N_{t-1}.
$$

- **(F16) Entering bankers' net worth**:

$$
N_{n,t}=\omega Q_tS_{t-1}.
$$

**Credit policy and aggregate intermediation**

- **(F17) Total assets split between private and public intermediation**:

$$
Q_tS_t=Q_tS_{p,t}+Q_tS_{g,t}.
$$

- **(F18) Public intermediation share**:

$$
Q_tS_{g,t}=\psi_tQ_tS_t.
$$

- **(F19) Total leverage with credit policy**:

$$
Q_tS_t=\phi_tN_t+\psi_tQ_tS_t\equiv \phi_{c,t}N_t,\qquad
\phi_{c,t}=\frac{\phi_t}{1-\psi_t}.
$$

**Intermediate goods producers**

- **(F20) Claims equal next-period capital**:

$$
Q_tK_{t+1}=Q_tS_t.
$$

- **(F21) Production function**:

$$
Y_t=A_t(U_t\xi_tK_t)^\alpha L_t^{1-\alpha}.
$$

- **(F22) Utilization choice**:

$$
P_{m,t}\alpha\frac{Y_t}{U_t}=\delta'(U_t)\xi_tK_t.
$$

- **(F23) Labor demand**:

$$
P_{m,t}(1-\alpha)\frac{Y_t}{L_t}=W_t.
$$

- **(F24) Return to capital**:

$$
R_{k,t+1}=
\frac{\left[P_{m,t+1}\alpha\frac{Y_{t+1}}{\xi_{t+1}K_{t+1}}
+Q_{t+1}-\delta(U_{t+1})\right]\xi_{t+1}}{Q_t}.
$$

**Capital producers**

- **(F25) Net investment definition**:

$$
I_{n,t}=I_t-\delta(U_t)\xi_tK_t.
$$

- **(F26) Capital producer's Q relation**:

$$
Q_t=1+f(\cdot)
+\frac{I_{n,t}+I_{ss}}{I_{n,t-1}+I_{ss}}f'(\cdot)
-E_t\beta\Lambda_{t,t+1}
\left(\frac{I_{n,t+1}+I_{ss}}{I_{n,t}+I_{ss}}\right)^2f'(\cdot).
$$

**Retailers**

- **(F27) Demand for retail variety**:

$$
Y_{f,t}=\left(\frac{P_{f,t}}{P_t}\right)^{-\varepsilon}Y_t.
$$

- **(F28) Price index**:

$$
P_t=\left[\int_0^1P_{f,t}^{1-\varepsilon}df\right]^{1/(1-\varepsilon)}.
$$

- **(F29) Reset-price FOC**:

$$
E_t\sum_{i=0}^{\infty}\gamma^i\beta^i\Lambda_{t,t+i}
\left[
\frac{P_t^*}{P_{t+i}}\prod_{k=1}^{i}(1+\pi_{t+k-1})^{\gamma_p}
-\mu P_{m,t+i}
\right]Y_{f,t+i}=0,\qquad
\mu=\frac{1}{1-1/\varepsilon}.
$$

- **(F30) Price-level law of motion**:

$$
P_t=\left[(1-\gamma)(P_t^*)^{1-\varepsilon}
+\gamma\left(\Pi_{t-1}^{\gamma_p}P_{t-1}\right)^{1-\varepsilon}\right]^{1/(1-\varepsilon)}.
$$

## 4. Market Clearing & Identities

- **(F31) Resource constraint**:

$$
Y_t=C_t+I_t+
f\!\left(\frac{I_{n,t}+I_{ss}}{I_{n,t-1}+I_{ss}}\right)(I_{n,t}+I_{ss})
+G+\tau\psi_tQ_tK_{t+1}.
$$

- **(F32) Capital accumulation**:

$$
K_{t+1}=\xi_tK_t+I_{n,t}.
$$

- **(F33) Government budget identity**:

$$
G+\tau\psi_tQ_tK_{t+1}=T_t+(R_{k,t}-R_t)B_{g,t-1}.
$$

- **(F34) Government debt used for public intermediation**:

$$
B_{g,t}=\psi_tQ_tS_t.
$$

- **(F35) Wholesale-to-retail output relation**:

$$
Y_{m,t}=D_tY_t.
$$

- **(F36) Markup definition**:

$$
X_t=\frac{1}{P_{m,t}}.
$$

- **(F37) Fisher relation**:

$$
1+i_t=R_{t+1}\frac{E_tP_{t+1}}{P_t}.
$$

- **(F38) Taylor rule**:

$$
i_t=(1-\rho)\left[i+\kappa_\pi\pi_t+\kappa_y(\log Y_t-\log Y_t^*)\right]
+\rho i_{t-1}+\varepsilon^i_t.
$$

## 5. Exogenous Processes

- **(F39) Credit-policy feedback rule**:

$$
\psi_t=\psi+\nu_\psi E_t\left[(\log R_{k,t+1}-\log R_{t+1})-(\log R_k-\log R)\right].
$$

- **(F40) Technology shock**:

$$
\log A_t=\rho_a\log A_{t-1}+\varepsilon^a_t.
$$

- **(F41) Capital-quality shock**:

$$
\log \xi_t=\rho_\xi\log \xi_{t-1}+\varepsilon^\xi_t.
$$

- **(F42) Government-spending shock**:

$$
\log G_t=(1-\rho_g)\log G+\rho_g\log G_{t-1}+\varepsilon^g_t.
$$

- **(F43) Intermediary wealth shock, implementation cross-check only**:

$$
N_{e,t}=\theta\left[(R_{k,t}-R_t)\phi_{t-1}+R_t\right]N_{t-1}\exp(-\varepsilon^N_t).
$$

The source paper uses valuation and policy experiments; the implementation also carries an intermediary net-worth shock and a monetary policy shock for MMB simulations.

## 6. Steady-State Solution

Steady state sets inflation and capital-quality shocks to their deterministic means, with `A=1`, `xi=1`, and `U=1`. Let gross inflation be one and ignore public intermediation in the baseline steady state unless a positive `psi` is calibrated.

1. From **(F3)**, with constant marginal utility:

$$
R=\frac{1}{\beta}.
$$

2. The target steady-state spread implies

$$
R_k=R\cdot\exp(\overline{\text{prem}}).
$$

3. From the target leverage ratio:

$$
\phi=\overline{\phi}.
$$

4. The banker block solves jointly for `lambda`, `omega`, and `chi` to match leverage, spread, and labor targets. At steady state,

$$
z=(R_k-R)\phi+R,\qquad x=z.
$$

5. With `Q=1` and `xi=1`, the capital return equation implies a steady-state marginal product relation:

$$
R_k=P_m\alpha\frac{Y}{K}+1-\delta(U).
$$

6. The utilization condition pins down the depreciation-function scale:

$$
P_m\alpha Y=b U^{1+\zeta}K.
$$

7. Net investment and capital accumulation imply

$$
I_n=0,\qquad I=\delta(U)K.
$$

8. The Calvo block has zero inflation and no price dispersion:

$$
D=1,\qquad X=\frac{\varepsilon}{\varepsilon-1},\qquad P_m=\frac{\varepsilon-1}{\varepsilon}.
$$

9. Resource feasibility then determines consumption:

$$
C=Y-I-G.
$$

10. The labor target and **(F1)**-**(F2)** pin down the labor utility weight:

$$
\chi=\frac{\varrho W}{L^\varphi},\qquad
\varrho=(C-hC)^{-1}-\beta h(C-hC)^{-1}.
$$

The exact MMB steady-state implementation numerically solves the calibration targets and is recorded only as `implementation_cross_check`; the paper does not provide a complete closed-form steady-state algorithm.

## 7. Timing & Form Conventions

- `K_{t+1}` is chosen at the end of period `t` for production in `t+1`; production at `t` uses `K_t` combined with the current capital-quality shock and utilization.
- Intermediaries choose assets at `t`; asset returns and net-worth realization occur at `t+1`.
- `Q_t` prices a claim to next-period capital acquired at the end of `t`.
- `R_{t+1}` is the real riskless gross return from `t` to `t+1`; `R_{k,t+1}` is the stochastic gross return on intermediary assets over the same interval.
- The paper equations are nonlinear. The MMB example writes many variables as logs via `exp(variable)` and uses a first-order perturbation.
- The raw MinerU title spells "Unconvetional"; the paper metadata and DOI spell "unconventional". This title typo is preserved in source paths only.

## 8. Variable & Parameter Reference Table

| Category | Symbol or ASCII name | Meaning | Main equation(s) |
|---|---|---|---|
| Endogenous | `C_t`, `L_t`, `B_t` | household consumption, labor, bond holdings | (F1)-(F3) |
| Endogenous | `varrho_t`, `Lambda_{t,t+1}` | marginal utility and stochastic discount factor | (F1), (F3) |
| Endogenous | `W_t` | real wage | (F2), (F23) |
| Endogenous | `N_t`, `N_e`, `N_n` | intermediary net worth and components | (F14)-(F16) |
| Endogenous | `nu_t`, `eta_t` | values of assets and net worth to bankers | (F6)-(F8) |
| Endogenous | `phi_t`, `phi_c,t` | private and total leverage ratios | (F10), (F19) |
| Endogenous | `S_t`, `S_p,t`, `S_g,t` | total, private, and public intermediated assets | (F11), (F17)-(F20) |
| Endogenous | `Q_t` | price of capital/claims | (F20), (F26) |
| Endogenous | `K_t`, `I_t`, `I_n,t` | capital, gross investment, net investment | (F25), (F32) |
| Endogenous | `U_t`, `delta(U_t)` | utilization and utilization-dependent depreciation | (F22), (F25) |
| Endogenous | `Y_t`, `Y_m,t`, `D_t` | final output, wholesale output, price dispersion | (F21), (F31), (F35) |
| Endogenous | `P_m,t`, `X_t` | relative intermediate price and markup | (F22)-(F24), (F36) |
| Endogenous | `R_t`, `R_k,t`, `i_t` | real riskless return, capital return, nominal policy rate | (F24), (F37), (F38) |
| Endogenous | `P_t`, `P_t^*`, `pi_t` | aggregate price, reset price, inflation | (F28)-(F30) |
| Endogenous/policy | `psi_t` | central-bank credit share | (F18), (F39) |
| Exogenous | `A_t`, `xi_t`, `G_t` | technology, capital quality, government spending | (F40)-(F42) |
| Exogenous innovation | `eps_a`, `eps_ksi`, `eps_g`, `eps_Ne`, `eps_i` | shocks in MMB example | (F40)-(F43), (F38) |
| Parameter | `beta`, `h`, `chi`, `varphi` | discounting, habit, labor utility, inverse Frisch elasticity | (F1)-(F3) |
| Parameter | `theta`, `lambda`, `omega` | banker survival, divertible fraction, startup transfer | (F7)-(F16) |
| Parameter | `alpha`, `zeta`, `delta`, `eta_i` | production, utilization depreciation, investment adjustment | (F21)-(F26) |
| Parameter | `epsilon`, `gamma`, `gamma_p`, `mu` | retail elasticity, Calvo stickiness, indexation, markup | (F27)-(F30) |
| Parameter | `rho_i`, `kappa_pi`, `kappa_y` | Taylor-rule smoothing and feedback coefficients | (F38) |
| Parameter | `kappa`, `tau` | credit-policy feedback and resource cost | (F31), (F39) |
| Parameter | `rho_a`, `rho_ksi`, `rho_g` | shock persistence | (F40)-(F42) |
