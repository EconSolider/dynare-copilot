# CA_ToTEM10 - Derivation

> First-pass private archive draft. Runtime validation was not performed. Formula-level status: `needs_review` because the MinerU Markdown source is a narrative overview article, not a formal appendix with complete equilibrium equations.

## 1. Model Overview

- **Model ID**: `CA_ToTEM10`.
- **Paper-side source**: Murchison and Rennison (2006), "ToTEM: The Bank of Canada's New Canadian Projection Model," Bank of Canada Technical Report.
- **Source paths**: `raw/mmb_mineru/runs/ca_totem10__totem_the_bank_of_canada_s_new_canadian_projection_model__1f1558b7/full.md`; raw PDF recorded at `raw/mmb_papers/ToTEM- The Bank of Canada's New Canadian Projection Model.pdf`.
- **Source DOI**: not listed in `raw/mmb_mineru/model_index.csv`.
- **Model class**: open-economy DSGE projection and policy-analysis model for Canada.
- **Agents and institutions**: households, firms, the central bank, and a fiscal authority. The paper describes households, firms, and the central bank as optimizing agents; fiscal policy is rule based.
- **Goods and sectors**: four finished-product sectors (consumption, investment, government, and exports) plus a commodity-producing sector. Finished-product firms use capital services, labour, commodities, and imports.
- **Nominal rigidities**: staggered sticky prices and staggered sticky wages. Import prices are also sticky, generating supply-chain price staggering and gradual exchange-rate pass-through.
- **Form**: large log-linearized / linearized DSGE implementation in the MMB replication file; paper narrative says ToTEM uses linearization and modern solution techniques. Exact paper-side algebra is `needs_review`.
- **Shocks emphasized in the paper**: consumption/preference shock, country-risk-premium or exchange-rate shock, and world commodity-price shock. Implementation cross-check lists seven exogenous shocks: `lyrow_shk`, `lpcomrow_shk`, `lxdc_shk`, `lforexn_shk`, `lc_shk`, `la_shk`, and `gn_yn_shk`.

## 2. Optimization Problems

### Lifetime-income households

Lifetime-income households smooth consumption subject to an intertemporal budget constraint, receive firm profits, sell differentiated labour services, and can borrow or save. A compact source-consistent representation is:

\[
\max_{\{C^L_t,N^L_t,A^L_t\}} E_0\sum_{t=0}^{\infty}\beta^t
U(C^L_t-h C^L_{t-1},N^L_t)
\]

subject to

\[
P^c_t C^L_t + A^L_t
= W_t N^L_t + R_{t-1}A^L_{t-1}+\Pi_t-T^L_t .
\]

`needs_review`: the paper source identifies lifetime-income households and their intertemporal budget constraint but does not print the exact utility or asset-pricing equation.

### Current-income households

Current-income households do not save or borrow and consume disposable current income, including transfers:

\[
P^c_t C^C_t = W_t N^C_t + TR_t - T^C_t .
\]

`needs_review`: exact tax/transfer split is not printed in the Markdown source.

### Wage setters

Households have market power in labour supply because labour skills are imperfect substitutes. Nominal wage contracts are staggered and last about six quarters on average:

\[
\max_{W^{\ast}_t} E_t\sum_{j=0}^{\infty}(\beta \theta_w)^j
\Lambda_{t,t+j}\left[
W^{\ast}_t N_{t+j|t}-P^c_{t+j} MRS^N_{t+j}N_{t+j|t}
\right] .
\]

`needs_review`: this is a generic Calvo wage-setting representation consistent with the paper description; the exact ToTEM wage block is not printed in the paper-side Markdown.

### Finished-product firms

Each finished-product sector `s in {c, inv, g, x}` combines capital services, labour, commodities, and imports with a CES production technology and sets sticky prices:

\[
\max_{\{K_{s,t},L_{s,t},COM_{s,t},M_{s,t}\}}
P^s_t Y^s_t-W_tL_{s,t}-R^k_tK_{s,t}-P^{com}_tCOM_{s,t}-P^m_tM_{s,t}
\]

subject to

\[
Y^s_t = A^s_t\,F_s(K_{s,t},L_{s,t},COM_{s,t},M_{s,t};u_{s,t}) .
\]

`needs_review`: the Markdown source says the production function is CES and that current ToTEM versions mainly differ by relative import content across finished goods, but it does not print the nested CES formula.

### Commodity-producing firms

The commodity sector is separate from finished-product sectors, is price-taking in world commodity markets, and supplies commodities for domestic use, household consumption, and exports:

\[
\max_{\{K^{com}_t,L^{com}_t\}}
P^{com}_tY^{com}_t-W_tL^{com}_t-R^k_tK^{com}_t
\]

subject to

\[
Y^{com}_t=A^{com}_tF^{com}(K^{com}_t,L^{com}_t).
\]

### Central bank and fiscal authority

The central bank is described as choosing policy to minimize deviations of inflation from target, output from potential, and interest-rate variability. For MMB implementation purposes, this appears as an optimized interest-rate feedback rule rather than an explicit Ramsey problem.

The fiscal authority follows rules for spending, taxes, transfers, and debt that are consistent with a medium-term debt-to-GDP objective.

## 3. First-Order Conditions

The following equations are a first-pass structural map. Conditions with exact algebra not printed in the paper-side Markdown are explicitly marked `needs_review`.

- **(F1) Lifetime-income Euler condition** (`needs_review`):

\[
U_{C,t}=\beta E_t\left[U_{C,t+1}\frac{1+i_t}{\Pi^c_{t+1}}\right].
\]

- **(F2) Current-income household budget rule** (`needs_review`):

\[
C^C_t=\frac{W_tN^C_t+TR_t-T^C_t}{P^c_t}.
\]

- **(F3) Labour supply / desired real wage condition** (`needs_review`):

\[
\frac{W^{des}_t}{P^c_t}=MRS^N_t(C_t,N_t).
\]

- **(F4) Calvo wage Phillips curve block** (`needs_review`):

\[
\pi^w_t=\gamma_w\pi^w_{t-1}+\beta E_t\pi^w_{t+1}
\kappa_w\left(\log W_t-\log P^c_t-\log MRS^N_t\right).
\]

- **(F5) Finished-good input demand, capital services** (`needs_review`):

\[
R^k_t=P^s_t MC^s_t\frac{\partial F_s}{\partial K_{s,t}}.
\]

- **(F6) Finished-good input demand, labour** (`needs_review`):

\[
W_t=P^s_t MC^s_t\frac{\partial F_s}{\partial L_{s,t}}.
\]

- **(F7) Finished-good input demand, commodities** (`needs_review`):

\[
P^{com}_t=P^s_t MC^s_t\frac{\partial F_s}{\partial COM_{s,t}}.
\]

- **(F8) Finished-good input demand, imports** (`needs_review`):

\[
P^m_t=P^s_t MC^s_t\frac{\partial F_s}{\partial M_{s,t}}.
\]

- **(F9) Sectoral New Keynesian price equation** (`needs_review`):

\[
\pi^s_t=\gamma_s\pi^s_{t-1}+\beta E_t\pi^s_{t+1}
\kappa_s\left(\log MC^s_t-\log \overline{MC}^s\right)+\varepsilon^s_t .
\]

- **(F10) Import-price Phillips curve / supply-chain pass-through block** (`needs_review`):

\[
\pi^m_t=\gamma_m\pi^m_{t-1}+\beta E_t\pi^m_{t+1}
\kappa_m\left(\log P^{row}_t+\log S_t-\log P^m_t\right).
\]

- **(F11) Capital accumulation and utilization cost** (`needs_review`):

\[
K_{t+1}=(1-\delta(u_t))K_t+I_t-\Phi_I(I_t,I_{t-1}).
\]

- **(F12) Tobin's Q / investment condition** (`needs_review`):

\[
Q_t=1+\Phi_{I,t}+\beta E_t\left[\Lambda_{t,t+1}Q_{t+1}\Phi_{I,t+1}\right].
\]

- **(F13) Capital-service utilization condition** (`needs_review`):

\[
R^k_t=\frac{\partial \delta(u_t)}{\partial u_t}Q_t .
\]

- **(F14) Commodity-sector input demand** (`needs_review`):

\[
W_t=P^{com}_t\frac{\partial F^{com}}{\partial L^{com}_t},\qquad
R^k_t=P^{com}_t\frac{\partial F^{com}}{\partial K^{com}_t}.
\]

- **(F15) Monetary-policy feedback rule** (`needs_review`; implementation cross-check):

\[
i_t=\rho_i i_{t-1}+(1-\rho_i)\left(\bar{i}
\phi_{\pi}(\pi^{cpi}_{t+h}-\pi^{target}_{t+h})
\phi_y y^{gap}_t\right)+\varepsilon^i_t .
\]

Implementation cross-check maps this to a smoothed rule for `r1n` that reacts to `infq2`, `pertarget`, `pertran`, and `ly_gap`.

## 4. Market Clearing & Identities

- **(F16) Finished-good resource identities** (`needs_review`):

\[
Y^c_t=C_t,\qquad Y^{inv}_t=I_t,\qquad Y^g_t=G_t,\qquad Y^x_t=X_t .
\]

- **(F17) Aggregate GDP identity** (`needs_review`):

\[
Y_t=C_t+I_t+G_t+X_t-M_t+Y^{com,value}_t .
\]

- **(F18) Commodity allocation** (`needs_review`):

\[
Y^{com}_t=COM^c_t+COM^{inv}_t+COM^g_t+COM^x_t+COM^{hh}_t+X^{com}_t .
\]

- **(F19) Net foreign asset accumulation** (`needs_review`; implementation cross-check):

\[
NFA_t=\frac{1+i^{row}_{t-1}+\rho^{risk}_{t-1}}{\Pi_t}\frac{S_t}{S_{t-1}}NFA_{t-1}
NX_t .
\]

The implementation cross-check has an explicit `nfa` law of motion and a risk-premium term linked to deviations from desired NFA.

- **(F20) Risk premium / exchange-rate relation** (`needs_review`; implementation cross-check):

\[
1+i_t=(1+i^{row}_t)(1+risk_t)E_t\left[\frac{S_{t+1}}{S_t}\frac{\Pi^{row}_{t+1}}{\Pi_{t+1}}\right].
\]

- **(F21) Fiscal debt accumulation** (`needs_review`; implementation cross-check):

\[
B^g_t=(1+i^g_{t-1})B^g_{t-1}+P^g_tG_t+TR_t-T_t .
\]

- **(F22) Fiscal rule block** (`needs_review`; implementation cross-check):

\[
G_t,TR_t,T_t=f(B^g_t/Y_t,\overline{B^g/Y},Y^{gap}_t,\varepsilon^g_t).
\]

- **(F23) Price-index definitions** (`needs_review`):

\[
\Pi^{cpi}_t=g(\Pi^c_t,\Pi^m_t,\Pi^{com}_t,\Pi^g_t,\Pi^{inv}_t,\Pi^x_t).
\]

## 5. Exogenous Processes

- **(F24) Domestic technology process** (`needs_review`; implementation cross-check `la_shk`):

\[
a_t=a_{t-1}+\bar{g}_a+\varepsilon^a_t .
\]

- **(F25) World commodity-price process** (`needs_review`; implementation cross-check `lpcomrow_shk`):

\[
\log P^{com,row}_t-\log \bar{P}^{com,row}
=\rho_{com}\left(\log P^{com,row}_{t-1}-\log \bar{P}^{com,row}\right)
\varepsilon^{com}_t .
\]

- **(F26) Foreign output block** (`needs_review`; implementation cross-check `lyrow_shk`):

\[
y^{row}_t=y^{row,sreq}_t+y^{row,gap}_t .
\]

- **(F27) Exchange-rate / country-risk shock block** (`needs_review`; implementation cross-check `lforexn_shk`, `risk_shk`):

\[
risk_t=\overline{risk}+\tau\left(e^{-(NFA_t-\overline{NFA})}-1\right)+\varepsilon^{risk}_t .
\]

- **(F28) Consumption-demand shock** (`needs_review`; implementation cross-check `lc_shk`):

\[
\xi^c_t=\rho_c\xi^c_{t-1}+\varepsilon^c_t .
\]

- **(F29) Fiscal spending-ratio shock** (`needs_review`; implementation cross-check `gn_yn_shk`):

\[
gny_t=\rho_g gny_{t-1}+\varepsilon^g_t .
\]

- **(F30) Direct CPI-price shock** (`needs_review`; implementation cross-check `lxdc_shk`):

\[
\varepsilon^{pc}_t=\rho_{pc}\varepsilon^{pc}_{t-1}+\eta^{pc}_t .
\]

## 6. Steady-State Solution

The source Markdown states that many parameters were chosen so the steady state replicates Canadian data means for 1980-2004. It does not provide the full steady-state system. First-pass steady-state status is therefore `needs_review`.

Recommended steady-state ordering for a later checked implementation:

1. Set inflation target, foreign trend growth, and balanced-growth rates.
2. Set steady-state markups for finished goods and import pricing.
3. Solve sectoral CES unit-cost equations for relative prices and marginal costs.
4. Solve labour, capital-service, commodity, and import input shares by sector.
5. Solve capital stocks, utilization, depreciation, investment, and Tobin's Q.
6. Solve household consumption by type, wage-setting steady state, transfers, taxes, and government spending shares.
7. Solve net exports, NFA, the country risk premium, and exchange-rate-normalized foreign asset terms.
8. Solve monetary-policy steady state: nominal 90-day rate, real rate, target inflation, and the output gap at zero.

Steady-state placeholders consistent with the implementation cross-check:

\[
\pi^{target}=\bar{\pi},\qquad y^{gap}=0,\qquad i=\bar{i},\qquad risk=\overline{risk}.
\]

No Dynare steady-state residual check was run.

## 7. Timing & Form Conventions

- **Form**: first-pass archive classifies `CA_ToTEM10` as linearized / log-linearized. The MMB implementation uses many log-level variables with a large `model` block; the paper says ToTEM uses linearization and new solution techniques.
- **Capital timing**: the implementation cross-check uses lagged and forward capital-stock terms in sectoral capital valuation and investment equations. Treat capital as a stock predetermined by prior accumulation until formula-level review confirms exact timing.
- **NFA timing**: net foreign assets are stock variables with lagged NFA entering the accumulation identity and a risk premium tied to deviations from desired NFA.
- **Inflation timing**: sectoral inflation equations are forward-looking with lagged indexation/dynamic terms; import and sector prices create staggered pass-through.
- **Policy timing**: the policy rule reacts to a forward inflation measure (`infq2` in the implementation cross-check) and the contemporaneous output gap, with interest-rate smoothing.
- **Runtime validation**: not performed.

## 8. Variable & Parameter Reference Table

### Endogenous variables and blocks

| Category | Symbol / ASCII cue | Meaning | Main equation(s) |
|---|---|---|---|
| Endogenous | `C^L`, `lcfl` | lifetime-income consumption | (F1) |
| Endogenous | `C^C`, `lc` components | current-income consumption | (F2) |
| Endogenous | `W`, `lwn_r`, `w_inf` | nominal/real wages and wage inflation | (F3), (F4) |
| Endogenous | `Y^s`, `ly`, sector outputs | finished-product output | (F5)-(F9), (F16), (F17) |
| Endogenous | `MC^s`, `lmc*_r` | sectoral marginal costs | (F5)-(F10) |
| Endogenous | `K_s`, `lk*` | sectoral capital stocks | (F11)-(F14) |
| Endogenous | `I`, `linv*` | investment and sectoral investment | (F11), (F12), (F17) |
| Endogenous | `u_s`, `u*` | utilization rates | (F13) |
| Endogenous | `P^m`, `lpm*_r` | import prices | (F10), (F23) |
| Endogenous | `Y^{com}`, `lcom*` | commodity output and use | (F14), (F18) |
| Endogenous | `i`, `r1n` | nominal 90-day interest rate | (F15), (F20) |
| Endogenous | `S`, `lforex` | nominal/real exchange-rate block | (F20), (F27) |
| Endogenous | `NFA`, `nfa` | net foreign assets | (F19), (F27) |
| Endogenous | `B^g`, `gbn_yn` | government debt ratio | (F21), (F22) |
| Endogenous | `G`, `lg`, `gn_yn` | government spending | (F22), (F29) |
| Endogenous | `pi`, `infq`, `inff` | CPI/core inflation measures | (F9), (F10), (F23), (F30) |

### Exogenous shocks

| Symbol / ASCII cue | Meaning | Main equation(s) |
|---|---|---|
| `la_shk` | domestic productivity shock | (F24) |
| `lpcomrow_shk` | world commodity-price shock | (F25) |
| `lyrow_shk` | rest-of-world output shock | (F26) |
| `lforexn_shk`, `risk_shk` | country-risk / exchange-rate shock block | (F27) |
| `lc_shk` | consumption-demand shock | (F28) |
| `gn_yn_shk` | fiscal spending-ratio shock | (F29) |
| `lxdc_shk` | direct CPI-price shock | (F30) |

### Parameters and calibration cues

| Parameter cue | Meaning |
|---|---|
| `beta` | discount factor |
| `habit`, `habitrow` | habit persistence in domestic/foreign demand blocks |
| `calvo_*` | Calvo stickiness parameters by price/wage block |
| `dyn_*` | indexation/dynamic inflation parameters |
| `smooth1` | interest-rate smoothing |
| `b`, `bqy` | monetary-policy responses to inflation and output gap |
| `alpha_*` | production/input share or CES weight parameters |
| `sigma`, `sigma_com`, `theta`, `theta_com` | substitution/curvature parameters |
| `chi`, `chi_k`, `psi*` | adjustment/utilization/investment-cost parameters |
| `tau`, `tau2` | NFA/risk-premium sensitivity |
| `fiscal1`-`fiscal4` | fiscal rule coefficients |

Equation count in this draft: 30 numbered conditions. Because many are structural block equations rather than the complete MMB implementation equation list, equation-variable equality is `needs_review`.
