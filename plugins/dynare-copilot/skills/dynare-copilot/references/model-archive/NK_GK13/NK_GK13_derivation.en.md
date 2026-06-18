# NK_GK13 -- Derivation (optimization problems + equilibrium conditions)

> Runtime validation: not performed. This is a first-pass source-backed derivation from MinerU Markdown and is marked `needs_review`.

Source provenance: `NK_GK13`, Gertler and Karadi (2013), "Qe 1 vs. 2 vs. 3. . . : A framework for analyzing large-scale asset purchases as a monetary policy tool", International Journal of Central Banking 9(1), pp. 5-53. DOI: not listed in `raw/mmb_mineru/model_index.csv`. Primary Markdown: `raw/mmb_mineru/runs/nk_gk13__qe_1_vs_2_vs_3_a_framework_for_analyzing_large_scale_asset_purchases_as__77fee003/full.md`. Raw PDF path checked: `raw/mmb_papers/A framework for analyzing large-scale asset purchases as a monetary policy tool.pdf`.

## 1. Model Overview

- **Model**: New Keynesian model with limits to private financial arbitrage and central-bank large-scale asset purchases (LSAPs).
- **Agents**: representative household with workers and bankers; financial intermediaries; central bank; intermediate-goods producers; capital-goods producers; Calvo retail firms; fiscal/monetary authority.
- **Main mechanism**: bankers finance private capital claims and long-term government bonds with short-term liabilities. A moral-hazard constraint limits bank balance-sheet size. LSAPs matter only when private arbitrage is constrained.
- **Assets**: private capital-backed claims, long-term government consols, and short-term riskless debt/deposits.
- **Model form**: the paper presents nonlinear equilibrium conditions. The MMB implementation cross-check is a first-order linearized `model` around logged steady states, not a paper-side source.
- **Source status**: `needs_review` because `model_index.csv` records a source-title/model-title mismatch and two MinerU run IDs. The chosen source is the row's `primary_full_md_path`.

## 2. Optimization Problems

### 2.1 Household

The household chooses consumption $`C_t`$, labor $`L_t`$, and short-term debt/deposits $`D_{ht}`$:

```math
\max_{\{C_t,L_t,D_{ht}\}} E_t\sum_{i=0}^{\infty}\beta^i
\left[
\log(C_{t+i}-hC_{t+i-1})
-\frac{\chi}{1+\varphi}L_{t+i}^{1+\varphi}
\right].
```

The period budget constraint is

```math
C_t = W_tL_t+\Pi_t-X+T_t+R_tD_{h,t-1}-D_{ht}.
```

### 2.2 Bank

A banker/intermediary chooses private claims $`s_t`$, long-term government bonds $`b_t`$, and deposits $`d_t`$ subject to its balance sheet, net-worth law, and incentive constraint:

```math
Q_ts_t+q_tb_t=n_t+d_t,
```

```math
n_t=R_{kt}Q_{t-1}s_{t-1}+R_{bt}q_{t-1}b_{t-1}-R_td_{t-1},
```

```math
\max_{\{s_t,b_t,d_t\}} V_t
=E_t\sum_{i=1}^{\infty}(1-\sigma)\sigma^{i-1}\Lambda_{t,t+i}n_{t+i},
```

```math
V_t\geq \theta Q_ts_t+\Delta\theta q_tb_t.
```

The incentive constraint is weaker for government bonds when $`0\leq\Delta<1`$.

### 2.3 Central Bank

The central bank chooses private-security purchases $`S_{gt}`$ and long-term-bond purchases $`B_{gt}`$ and finances them with short-term liabilities:

```math
Q_tS_{gt}+q_tB_{gt}=D_{gt}.
```

The paper assumes resource costs $`\tau_s`$ and $`\tau_b`$ for central-bank intermediation. Central-bank purchases are not constrained by the bank moral-hazard constraint.

### 2.4 Household Direct Security Holdings

In the generalized setup, households may directly hold private claims $`S_{ht}`$ and government bonds $`B_{ht}`$ subject to quadratic transaction costs around costless holdings $`\bar S_h`$ and $`\bar B_h`$:

```math
\begin{aligned}
C_t+D_{ht} &+ Q_t\left[S_{ht}+\frac{1}{2}\kappa(S_{ht}-\bar S_h)^2\right]
+q_t\left[B_{ht}+\frac{1}{2}\kappa(B_{ht}-\bar B_h)^2\right] \\
&=W_tL_t+\Pi_t+T_t+R_tD_{h,t-1}+R_{kt}S_{h,t-1}+R_{bt}B_{h,t-1}.
\end{aligned}
```

### 2.5 Capital-Goods Producer

Capital producers choose investment subject to flow investment adjustment costs:

```math
\max_{\{I_\tau\}} E_t\sum_{\tau=t}^{\infty}\Lambda_{t,\tau}
\left\{
Q_\tau I_\tau-\left[1+f\left(\frac{I_\tau}{I_{\tau-1}}\right)\right]I_\tau
\right\}.
```

## 3. First-Order Conditions

- **(F1) Household labor supply**:

```math
u_{C_t}W_t=\chi L_t^\varphi.
```

- **(F2) Household Euler equation**:

```math
E_t\Lambda_{t,t+1}R_{t+1}=1,
\qquad
\Lambda_{t,t+1}\equiv\beta\frac{u_{C_{t+1}}}{u_{C_t}}.
```

- **(F3) Private capital-claim return**:

```math
R_{k,t+1}=\frac{Z_{t+1}+(1-\delta)Q_{t+1}}{Q_t}\xi_{t+1}.
```

- **(F4) Long-term government-bond return**:

```math
R_{b,t+1}=\frac{1/P_t+q_{t+1}}{q_t}.
```

- **(F5) Bank excess-return condition for private claims**:

```math
E_t\widetilde{\Lambda}_{t,t+1}(R_{k,t+1}-R_{t+1})
=\frac{\lambda_t}{1+\lambda_t}\theta.
```

- **(F6) Bank excess-return condition for long-term government bonds**:

```math
E_t\widetilde{\Lambda}_{t,t+1}(R_{b,t+1}-R_{t+1})
=\Delta\frac{\lambda_t}{1+\lambda_t}\theta.
```

- **(F7) Augmented stochastic discount factor**:

```math
\widetilde{\Lambda}_{t,t+1}=\Lambda_{t,t+1}\Omega_{t+1}.
```

- **(F8) Aggregate bank portfolio restriction**:

```math
Q_tS_{pt}+\Delta q_tB_{pt}\leq \phi_tN_t.
```

- **(F9) Maximum adjusted leverage ratio**:

```math
\phi_t=
\frac{E_t\widetilde{\Lambda}_{t,t+1}R_{t+1}}
{\theta-E_t\widetilde{\Lambda}_{t,t+1}(R_{k,t+1}-R_{t+1})}.
```

- **(F10) Marginal value of bank net worth**:

```math
\Omega_{t+1}=1-\sigma+\sigma\frac{\partial V_{t+1}}{\partial n_{t+1}}.
```

- **(F11) Marginal value recursion for net worth**:

```math
\frac{\partial V_t}{\partial n_t}
=E_t\widetilde{\Lambda}_{t,t+1}
\left[
(R_{k,t+1}-R_{t+1})\phi_t+R_{t+1}
\right].
```

- **(F12) Aggregate bank net-worth accumulation**:

```math
N_t=\sigma\left[
(R_{kt}-R_t)\frac{Q_{t-1}S_{p,t-1}}{N_{t-1}}
+(R_{bt}-R_t)\frac{q_{t-1}B_{p,t-1}}{N_{t-1}}
+R_t
\right]N_{t-1}+X.
```

- **(F13) Central-bank balance sheet**:

```math
Q_tS_{gt}+q_tB_{gt}=D_{gt}.
```

- **(F14) Total private-security supply identity**:

```math
S_t=S_{pt}+S_{gt}.
```

- **(F15) Total long-term-government-bond supply identity**:

```math
B_t=B_{pt}+B_{gt}.
```

- **(F16) Total private-security value under constrained bank balance sheets**:

```math
Q_tS_t\leq \phi_tN_t+Q_tS_{gt}+\Delta(q_tB_{gt}-q_tB_t).
```

- **(F17) Cross-asset excess-return relation**:

```math
E_t\widetilde{\Lambda}_{t,t+1}(R_{b,t+1}-R_{t+1})
=\Delta E_t\widetilde{\Lambda}_{t,t+1}(R_{k,t+1}-R_{t+1}).
```

- **(F18) Household demand for direct private-security holdings**:

```math
S_{ht}=\bar S_h+
\frac{E_t\Lambda_{t,t+1}(R_{k,t+1}-R_{t+1})}{\kappa}.
```

- **(F19) Household demand for direct long-term-bond holdings**:

```math
B_{ht}=\bar B_h+
\frac{E_t\Lambda_{t,t+1}(R_{b,t+1}-R_{t+1})}{\kappa}.
```

- **(F20) Private-security market clearing with household holdings**:

```math
S_t=S_{pt}+S_{ht}+S_{gt}.
```

- **(F21) Government-bond market clearing with household holdings**:

```math
B_t=B_{pt}+B_{ht}+B_{gt}.
```

- **(F22) Bank portfolio restriction with household holdings**:

```math
Q_t(S_t-S_{ht})\leq
\phi_tN_t+Q_tS_{gt}+\Delta q_t\left[B_{gt}-(B_t-B_{ht})\right].
```

- **(F23) Intermediate-goods production function**:

```math
Y_t=A_tK_t^\alpha L_t^{1-\alpha}.
```

- **(F24) Labor demand / real wage**:

```math
W_t=P_{mt}(1-\alpha)\frac{Y_t}{L_t}.
```

- **(F25) Gross profit per unit of capital**:

```math
Z_t=P_{mt}\alpha\frac{Y_t}{K_t}.
```

- **(F26) Capital accumulation with capital-quality shock**:

```math
K_{t+1}=\xi_{t+1}\left[I_t+(1-\delta)K_t\right].
```

- **(F27) Capital-goods pricing condition**:

```math
Q_t=1+f\left(\frac{I_t}{I_{t-1}}\right)
+\frac{I_t}{I_{t-1}}f'\left(\frac{I_t}{I_{t-1}}\right)
-E_t\Lambda_{t,t+1}\left(\frac{I_{t+1}}{I_t}\right)^2
f'\left(\frac{I_{t+1}}{I_t}\right).
```

- **(F28) Final-good CES aggregator**:

```math
Y_t=\left[\int_0^1Y_{ft}^{\frac{\varepsilon-1}{\varepsilon}}df\right]^{\frac{\varepsilon}{\varepsilon-1}}.
```

- **(F29) Calvo reset-price condition**:

```math
\sum_{i=0}^{\infty}\gamma^i\Lambda_{t,t+i}
\left[
\frac{P_t^{\ast}}{P_{t+i}}-\mu P_{m,t+i}
\right]Y_{f,t+i}=0,
\qquad
\mu=\frac{1}{1-1/\varepsilon}.
```

- **(F30) Price-index evolution**:

```math
P_t=\left[(1-\gamma)(P_t^{\ast})^{1-\varepsilon}
+\gamma(P_{t-1})^{1-\varepsilon}\right]^{\frac{1}{1-\varepsilon}}.
```

- **(F31) Government budget constraint**:

```math
\begin{aligned}
G+(R_{bt}-1)\bar B
&=T_t+(R_{kt}-R_t-\tau_s)Q_{t-1}S_{g,t-1}\\
&\quad +(R_{bt}-R_t-\tau_b)q_{t-1}B_{g,t-1}.
\end{aligned}
```

- **(F32) Taylor rule**:

```math
i_t=i+\kappa_\pi\pi_t+\kappa_y(\log Y_t-\log Y_t^{\ast})+\epsilon_t.
```

- **(F33) Fisher relation**:

```math
1+i_t=R_{t+1}\frac{P_{t+1}}{P_t}.
```

- **(F34) Private-security LSAP rule**:

```math
S_{gt}=\varphi_{st}S_t.
```

- **(F35) Government-bond LSAP rule**:

```math
B_{gt}=\varphi_{bt}B_t.
```

`needs_review`: the MinerU Markdown prints both LSAP fractions as `\varphi_{st}` around the bond-purchase equation. The notation here follows the surrounding text and the implementation cross-check, where private-credit and bond-purchase shocks are distinct.

## 4. Market Clearing & Identities

- **(F36) Resource constraint**:

```math
Y_t=C_t+\left[1+f\left(\frac{I_t}{I_{t-1}}\right)\right]I_t+G+\Phi_t.
```

- **(F37) Central-bank intermediation resource cost**:

```math
\Phi_t=\tau_sQ_{t-1}S_{g,t-1}+\tau_bq_{t-1}B_{g,t-1}.
```

`needs_review`: the OCR source gives `\tau_g` in the resource-cost expression while the government budget and text use a bond-intermediation cost. This derivation writes $`\tau_b`$ for consistency and records the mismatch.

- **(F38) Private-security supply from installed and new capital**:

```math
S_t=I_t+(1-\delta)K_t.
```

- **(F39) Fixed government-bond supply**:

```math
B_t=\bar B.
```

- **(F40) Labor-market clearing condition**:

```math
(1-\alpha)\frac{Y_t}{L_t}E_tu_{C_t}
=\frac{1}{P_{mt}}\chi L_t^\varphi.
```

- **(F41) Short-term debt market clearing**:

```math
D_{ht}+D_{gt}=D_t,
```

where the exact decomposition is redundant by Walras's law once goods, labor, and long-term securities clear.

## 5. Exogenous Processes

- **(F42) Productivity shock**:

```math
\log A_t=\rho_a\log A_{t-1}+\varepsilon^a_t.
```

- **(F43) Capital-quality shock**:

```math
\log \xi_t=\rho_\xi\log \xi_{t-1}+\varepsilon^\xi_t.
```

- **(F44) Government-consumption shock**:

```math
\log G_t=(1-\rho_g)\log \bar G+\rho_g\log G_{t-1}+\varepsilon^g_t.
```

- **(F45) Private-security purchase process**:

```math
\varphi_{st}=\rho_{s1}\varphi_{s,t-1}+\rho_{s2}\varphi_{s,t-2}+\varepsilon^s_t.
```

- **(F46) Government-bond purchase process**:

```math
\varphi_{bt}=\rho_{b1}\varphi_{b,t-1}+\rho_{b2}\varphi_{b,t-2}+\varepsilon^b_t.
```

- **(F47) Monetary-policy shock**:

```math
\epsilon_t=\rho_\epsilon\epsilon_{t-1}+\varepsilon^i_t.
```

The implementation cross-check also includes an exogenous banker net-worth shock and ZLB indicator shocks; those are implementation-specific conveniences and not separately stated as structural paper equations in the primary Markdown.

## 6. Steady-State Solution

The paper calibrates a quarterly steady state and then studies linearized dynamics around it. The first-pass steady state is therefore recorded as a source-backed solve order rather than a completed numeric `steady_state_model`.

1. Set steady exogenous states: $`\bar A=1`$, $`\bar \xi=1`$, purchase shares $`\bar\varphi_s=\bar\varphi_b=0`$, and all innovations equal zero.
2. Set the steady real riskless rate from household saving: $`\bar R=1/\beta`$.
3. Set steady inflation according to the monetary regime; in the MMB cross-check, inflation is a zero log deviation and the nominal gross rate is consistent with $`\bar R`$.
4. Calibrate $`\alpha,\delta,\varepsilon,G/Y,h,\varphi,\eta_i,\gamma,\kappa_\pi,\kappa_y`$ from the paper's Table 2.
5. Choose the financial parameters $`\sigma,\theta,\Delta,X,\bar K^h,\bar B^h,\kappa,\bar B`$ to match the stated targets: government-bond excess return, private-security excess return, and bank leverage.
6. Use (F23)-(F27) to solve $`\bar K,\bar L,\bar Y,\bar I,\bar Q,\bar Z`$ with $`\bar Q=1`$ and zero adjustment costs.
7. Use (F5)-(F12) and the portfolio restriction to solve bank net worth, leverage, excess returns, and holdings of private claims and government bonds.
8. Use (F36)-(F40) to solve consumption, government spending, labor, wage, and markup.
9. Use (F28)-(F30) to impose the zero-inflation Calvo steady state and the desired steady markup $`\mu`$.

`needs_review`: the paper reports calibration targets and Table 2 parameter values, but the exact MMB steady-state construction is taken only as an implementation cross-check and was not runtime validated.

## 7. Timing & Form Conventions

- The derivation is nonlinear in the paper; MMB `NK_GK13_rep.mod` is a linearized implementation around logged steady states.
- $`K_t`$ in the paper's production function is the capital used in period $`t`$; equation (F26) states that the capital stock for $`t+1`$ is produced from period-$`t`$ investment and undepreciated capital, scaled by the capital-quality shock.
- Bank net worth $`N_t`$ is an end-of-period stock. Equation (F12) depends on returns earned on $`t-1`$ asset positions and previous net worth.
- Bank portfolio shares and central-bank purchase shares are asset positions at the end of the period.
- Long-term government bonds are modeled as perpetuities/consols. The paper later computes ten-year equivalent yields as reporting variables.
- The short-term real return $`R_t`$ pays from $`t-1`$ to $`t`$ in the household budget; the Euler condition is written with $`R_{t+1}`$.
- The central-bank balance sheet is consolidated with fiscal transfers. LSAPs are financed with short-term government liabilities or equivalent interest-bearing reserves.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Main equation(s) |
|---|---|---|---|
| Endogenous | $`C_t`$ / `C` | Household consumption | (F1), (F36) |
| Endogenous | $`L_t`$ / `L` | Labor supply | (F1), (F24), (F40) |
| Endogenous | $`D_{ht}`$ / `D_h` | Household short-term deposits/debt | household budget, (F41) |
| Endogenous | $`W_t`$ / `W` | Real wage | (F1), (F24) |
| Endogenous | $`\Lambda_{t,t+1}`$ / `Lambda` | Household stochastic discount factor | (F2), (F7) |
| Endogenous | $`R_t`$ / `R` | Short-term real riskless return | (F2), (F33) |
| Endogenous | $`R_{kt}`$ / `Rk` | Return on private capital claims | (F3), (F5) |
| Endogenous | $`R_{bt}`$ / `Rb` | Return on long-term government bonds | (F4), (F6) |
| Endogenous | $`Q_t`$ / `Q` | Market value of capital/private security | (F3), (F13), (F27) |
| Endogenous | $`q_t`$ / `q`, `qn` | Price of long-term government bond | (F4), (F13) |
| Endogenous | $`s_t,S_{pt}`$ / `Kb` | Bank private-security holdings | (F8), (F14), (F20) |
| Endogenous | $`b_t,B_{pt}`$ / `Bb` | Bank long-term government-bond holdings | (F8), (F15), (F21) |
| Endogenous | $`n_t,N_t`$ / `N` | Banker/banking-sector net worth | (F12) |
| Endogenous | $`d_t`$ / `Dep` | Bank deposits | bank balance sheet, (F41) |
| Endogenous | $`\lambda_t`$ / `lambda` | Multiplier on incentive constraint | (F5), (F6) |
| Endogenous | $`\Omega_t`$ / `Omega` | Shadow value of bank net worth | (F7), (F10) |
| Endogenous | $`\phi_t`$ / `phi` | Maximum adjusted leverage ratio | (F8), (F9) |
| Endogenous | $`S_{gt}`$ / `psi` | Central-bank private-security purchases | (F13), (F34) |
| Endogenous | $`B_{gt}`$ / `Gamma` | Central-bank bond purchases | (F13), (F35) |
| Endogenous | $`S_{ht}`$ / `Kh` | Household direct private-security holdings | (F18), (F20) |
| Endogenous | $`B_{ht}`$ / `Bh` | Household direct bond holdings | (F19), (F21) |
| Endogenous | $`Y_t,Y_{mt}`$ / `Y`, `Ym` | Final and intermediate output | (F23), (F28), (F36) |
| Endogenous | $`K_t`$ / `K` | Capital stock | (F23), (F26) |
| Endogenous | $`I_t`$ / `I` | Investment | (F26), (F27), (F36) |
| Endogenous | $`Z_t`$ / `Z` | Profit flow per unit of capital | (F25) |
| Endogenous | $`P_{mt}`$ / `Pm` | Relative price of intermediate goods / inverse markup | (F24), (F25), (F29) |
| Endogenous | $`P_t^{\ast}`$ / `inflstar` | Calvo reset price/inflation object | (F29), (F30) |
| Endogenous | $`\pi_t,i_t`$ / `infl`, `ir` | Inflation and nominal interest rate | (F32), (F33) |
| Exogenous | $`A_t`$ / `a` | TFP | (F42) |
| Exogenous | $`\xi_t`$ / `ksi` | Capital-quality disturbance | (F43) |
| Exogenous | $`\varepsilon^a_t`$ / `e_a` | TFP innovation | (F42) |
| Exogenous | $`\varepsilon^\xi_t`$ / `e_ksi` | Capital-quality innovation | (F43) |
| Exogenous | $`\varepsilon^g_t`$ / `e_g` | Government-spending innovation | (F44) |
| Exogenous | $`\varepsilon^s_t`$ / `e_psi` | Private-security purchase innovation | (F45) |
| Exogenous | $`\varepsilon^b_t`$ / `e_Gamma` | Government-bond purchase innovation | (F46) |
| Exogenous | $`\varepsilon^i_t`$ / `e_ir` | Monetary-policy innovation | (F47) |
| Parameter | $`\beta`$ / `betta` | Discount factor | (F2) |
| Parameter | $`h`$ / `hh` | Habit parameter | household utility |
| Parameter | $`\chi`$ / `chi` | Labor disutility weight | (F1), (F40) |
| Parameter | $`\varphi`$ / `varphi` | Inverse Frisch elasticity | (F1), (F40) |
| Parameter | $`\sigma`$ / `theta` in paper survival notation | Banker survival probability | (F10), (F12) |
| Parameter | $`\theta`$ / `lambda` or calibrated diversion parameter | Divertible fraction of private assets | bank incentive constraint |
| Parameter | $`\Delta`$ / `Delta` | Lower diversion/seizure weight for government bonds | (F6), (F8), (F17) |
| Parameter | $`\alpha`$ / `alfa` | Capital share | (F23)-(F25) |
| Parameter | $`\delta`$ / `delta` | Depreciation rate | (F3), (F26) |
| Parameter | $`\eta_i`$ / `eta_i` | Inverse elasticity of investment to capital price | adjustment cost |
| Parameter | $`\gamma`$ / `gam` | Calvo non-adjustment probability | (F29), (F30) |
| Parameter | $`\varepsilon`$ / `epsilon` | Retail substitution elasticity | (F28)-(F30) |
| Parameter | $`\kappa`$ / `kappa_s`, `kappa_b` | Household portfolio adjustment cost | (F18), (F19) |
| Parameter | $`\kappa_\pi,\kappa_y`$ / `kappa_pi`, `kappa_y` | Taylor-rule coefficients | (F32) |
| Parameter | $`\tau_s,\tau_b`$ / `tau` | Central-bank intermediation costs | (F31), (F37) |
| Parameter | $`\rho_a,\rho_\xi,\rho_g`$ | Shock persistence | (F42)-(F44) |
