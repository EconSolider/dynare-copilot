# US_LTW17 Derivation - Leeper, Traum, and Walker (2017)

Source: Eric M. Leeper, Nora Traum, and Todd B. Walker (2017), "Clearing Up the Fiscal Multiplier Morass," *American Economic Review* 107(8), 2409-2454. DOI: `10.1257/aer.20111196`.

Model ID: `US_LTW17`. Status: `needs_review`.

## 1. Model Overview

- **Model**: Estimated U.S. monetary DSGE model with fiscal detail, long-term nominal government debt, steady-state distortionary taxes, government consumption in utility, and active monetary/passive fiscal policy in the `US_LTW17` implementation variant.
- **Agents and sectors**: final goods producers, monopolistically competitive intermediate firms, a labor agency, saver households, non-saver households, a monetary authority, and a fiscal authority.
- **Fiscal structure**: government spending, transfers, capital taxes, labor taxes, consumption taxes, long-maturity nominal debt, and a primary surplus identity.
- **Form**: `model(linear)`. The paper describes a DSGE model and subsequent log-linear solution; the MMB implementation cross-check confirms `model (linear)`. Variables in equations below are percentage/log deviations from the balanced-growth steady state unless explicitly described as a level or steady-state object.
- **Runtime validation**: not performed. Dynare was not run.
- **Provenance boundary**: the paper-side Markdown is the mathematical source. `.agents/skills/dynare-copilot/references/examples/US_LTW17_rep.mod` is used only as `implementation_cross_check`.

## 2. Optimization Problems

### Final Goods Producers

Final goods producers aggregate differentiated intermediate goods:

$$
Y_t =
\left(\int_0^1 Y_t(i)^{\frac{1}{1+\eta_t^p}}\,di\right)^{1+\eta_t^p}.
$$

Profit maximization gives demand for good \(i\):

$$
Y_t(i)=Y_t\left(\frac{P_t(i)}{P_t}\right)^{-\frac{1+\eta_t^p}{\eta_t^p}}.
$$

### Intermediate Goods Firms

Intermediate firm \(i\) produces with capital and labor:

$$
\bar{Y}_t(i)=\bar{K}_t(i)^\alpha (A_t L_t(i))^{1-\alpha}-A_t\Omega.
$$

Cost minimization implies a common nominal marginal cost:

$$
MC_t=(1-\alpha)^{\alpha-1}\alpha^{-\alpha}(R_t^k)^\alpha W_t^{1-\alpha}A_t^{-1+\alpha}.
$$

Calvo price setters reoptimize with probability \(1-\omega_p\). Non-reset prices are indexed to lagged inflation with weight \(\chi_p\). The reset-price problem in the Markdown source is:

$$
E_t\sum_{s=0}^{\infty}(\beta\omega_p)^s\frac{\lambda_{t+s}}{\lambda_t}
\left[
\left(\prod_{k=1}^s \pi_{t+k-1}^{\chi_p}\pi^{1-\chi_p}\right)P_t(i)Y_{t+s}(i)
-MC_{t+s}Y_{t+s}(i)
\right].
$$

### Labor Agency and Wage Setters

A competitive labor agency aggregates differentiated labor services and derives demand for each labor variety. Saver households optimally reset wages with probability \(1-\omega_w\); non-savers follow the average wage set by savers. Wage non-resetters index to past inflation and trend growth. The wage Phillips equation below is therefore treated as a source-backed model block but first-pass algebra is `needs_review`.

### Saver Households

Saver household \(j\) values composite consumption and leisure:

$$
E_0\sum_{t=0}^{\infty}\beta^t u_t^b
\left[
\log\left(C_t^{\astS}(j)-\theta \tilde{C}_{t-1}^{\astS}\right)
-\frac{(L_t^S(j))^{1+\xi}}{1+\xi}
\right],
$$

where

$$
C_t^{\astS}(j)=C_t^S(j)+\alpha_G G_t.
$$

Savers choose consumption, nominal private bonds, long-term government bonds, investment, capital utilization, and capital accumulation subject to the nominal budget constraint, capital law of motion, and utilization cost. The source Markdown states the budget constraint and capital accumulation equation; several FOCs below are `needs_review` because the local source does not provide a clean appendix derivation.

### Non-Saver Households

Non-savers consume current disposable income:

$$
(1+\tau_t^C)P_t C_t^N(j)
=(1-\tau_t^L)\int_0^1 W_t(l)L_t^N(j,l)\,dl+P_tZ_t^N(j).
$$

### Government and Policy Authorities

The monetary authority sets the nominal interest rate by a Taylor rule. The fiscal authority finances government consumption, transfers, and debt service with long-term nominal debt and tax revenues, and fiscal instruments respond to the lagged market value of debt relative to GDP.

## 3. First-Order Conditions

The following conditions use the `US_LTW17` implementation variable names where useful. Because the local paper Markdown does not include a clean appendix-level derivation for every first-order condition, implementation-confirmed linear equations are marked `needs_review`.

- **(F1) Production function**:

$$
y_t-\frac{\bar{Y}+\bar{\Omega}}{\bar{Y}}\alpha k_t
-\frac{\bar{Y}+\bar{\Omega}}{\bar{Y}}(1-\alpha)l_t=0.
$$

- **(F2) Factor-price relation**:

$$
rk_t-w_t+k_t-l_t=0.
$$

- **(F3) Real marginal cost**:

$$
mc_t-\alpha rk_t+(\alpha-1)w_t=0.
$$

- **(F4) Price Phillips equation** (`needs_review` OCR/algebra):

$$
\lambda_p \pi_t-\frac{\lambda_p\beta}{1+\beta\chi_p}\pi_{t+1}
-mc_t-\lambda_p u_t^p
=\frac{\lambda_p\chi_p}{1+\beta\chi_p}\pi_{t-1}.
$$

- **(F5) Saver marginal utility of wealth** (`needs_review`):

$$
\lambda_t+\frac{\theta}{e^\gamma-\theta}u_t^a
+\frac{e^\gamma}{e^\gamma-\theta}c_t^{\ast}
-u_t^b+\frac{\bar{\tau}^C}{1+\bar{\tau}^C}\tau_t^C
=\frac{\theta}{e^\gamma-\theta}c_{t-1}^{\ast}.
$$

- **(F6) Long-run real interest rate**:

$$
r_t^L+P_t^B-\frac{\beta\rho}{e^\gamma}r_{t+1}^L
-\frac{\beta\rho}{e^\gamma}P_{t+1}^B+\pi_{t+1}=0.
$$

- **(F7) Long-run inflation rate**:

$$
\pi_t^L+P_t^B+r_t^L=0.
$$

- **(F8) Consumption entering utility**:

$$
c_t^{\ast}-\frac{\bar{C}^S}{\bar{C}^S+\alpha_G\bar{G}}c_t^S
-\frac{\alpha_G\bar{G}}{\bar{C}^S+\alpha_G\bar{G}}g_t=0.
$$

- **(F9) Saver Euler equation** (`needs_review`):

$$
\lambda_t-R_t+\pi_{t+1}-\lambda_{t+1}+\rho_a u_t^a=0.
$$

- **(F10) Capacity utilization**:

$$
\frac{1-\psi}{\psi}rk_t-v_t
-\frac{1-\psi}{\psi}\frac{\bar{\tau}^K}{1-\bar{\tau}^K}\tau_t^K=0.
$$

- **(F11) Capital FOC** (`needs_review`):

$$
q_t+R_t-\pi_{t+1}
-\beta e^{-\gamma}(1-\delta)q_{t+1}
-\beta e^{-\gamma}\bar{R}^k(1-\bar{\tau}^K)rk_{t+1}
+\bar{\tau}^K\beta e^{-\gamma}\bar{R}^k\tau_{t+1}^K=0.
$$

- **(F12) Investment FOC** (`needs_review`):

$$
-\frac{1}{(1+\beta)s e^{2\gamma}}q_t+i_t
-\frac{\beta}{1+\beta}i_{t+1}
+\frac{1-\beta\rho_a}{1+\beta}u_t^a-u_t^i
=\frac{1}{1+\beta}i_{t-1}.
$$

- **(F13) Effective capital**:

$$
k_t-v_t+u_t^a=\bar{k}_{t-1}.
$$

- **(F14) Physical capital law of motion**:

$$
\bar{k}_t-\left[1-(1-\delta)e^{-\gamma}\right](1+\beta)s e^{2\gamma}u_t^i
-\left[1-(1-\delta)e^{-\gamma}\right]i_t
+(1-\delta)e^{-\gamma}u_t^a
=(1-\delta)e^{-\gamma}\bar{k}_{t-1}.
$$

- **(F15) Wage Phillips equation** (`needs_review`):

$$
\begin{aligned}
(1+\lambda_w)w_t
&-\lambda_w\frac{\beta}{1+\beta}w_{t+1}
+\lambda_w\frac{1+\beta\chi_w}{1+\beta}\pi_t
-\lambda_w\frac{\beta}{1+\beta}\pi_{t+1}
-\xi l_t+\lambda_t \\
&+\lambda_w\frac{1+\beta\chi_w-\rho_a\beta}{1+\beta}u_t^a
-\frac{\bar{\tau}^L}{1-\bar{\tau}^L}\tau_t^L
-\lambda_w u_t^w-u_t^b \\
&=\frac{\lambda_w}{1+\beta}w_{t-1}
+\frac{\lambda_w\chi_w}{1+\beta}\pi_{t-1}
+\frac{\lambda_w\chi_w}{1+\beta}u_{t-1}^a .
\end{aligned}
$$

## 4. Market Clearing & Identities

- **(F16) Aggregate resource constraint**:

$$
\bar{C}c_t+\bar{I}i_t-\bar{Y}y_t+\bar{s}_G\bar{Y}g_t+\psi_1\bar{K}v_t=0.
$$

- **(F17) Non-saver budget constraint**:

$$
\bar{C}^N(1+\bar{\tau}^C)c_t^N+\bar{\tau}^C\bar{C}^N\tau_t^C
-\bar{W}\bar{L}(1-\bar{\tau}^L)w_t
-\bar{W}\bar{L}(1-\bar{\tau}^L)l_t
+\bar{W}\bar{L}\bar{\tau}^L\tau_t^L-\bar{Z}z_t=0.
$$

- **(F18) Consumption aggregation**:

$$
\bar{C}c_t-(1-\mu)\bar{C}^S c_t^S-\mu\bar{C}^N c_t^N=0.
$$

- **(F19) Long-maturity government bond price**:

$$
R_t-\frac{\rho \bar{P}^B}{1+\rho\bar{P}^B}P_{t+1}^B+P_t^B=0.
$$

- **(F20) Government budget constraint** (`needs_review`):

$$
\begin{aligned}
\bar{s}_b b_t-\bar{s}_G g_t-\frac{\bar{Z}}{\bar{Y}}z_t
&+\bar{\tau}^K\bar{r}^k\bar{k}_y(\tau_t^K+rk_t+k_t)
+\bar{s}_b\beta^{-1}u_t^a \\
&+\bar{\tau}^L\bar{w}\bar{l}_y(\tau_t^L+w_t+l_t)
+\bar{\tau}^C\bar{c}_y(c_t+\tau_t^C)
-\bar{s}_b\rho e^{-\gamma}P_t^B+\bar{s}_b\beta^{-1}\pi_t \\
&=\bar{s}_b\beta^{-1}b_{t-1}-\bar{s}_b\beta^{-1}P_{t-1}^B.
\end{aligned}
$$

- **(F21) Fisher equation**:

$$
r_t-R_t+\pi_{t+1}=0.
$$

- **(F22) Debt-to-output ratio**:

$$
s_t^b+y_t-b_t=0.
$$

- **(F23) Consumption tax revenue**:

$$
T_t^C-\tau_t^C-c_t=0.
$$

- **(F24) Capital tax revenue**:

$$
T_t^K-\tau_t^K-rk_t-k_t=0.
$$

- **(F25) Long-bond return definition**:

$$
r_t^b-\frac{\rho\beta}{e^\gamma}P_t^B+\pi_t=-P_{t-1}^B.
$$

- **(F26) Primary surplus definition**:

$$
\begin{aligned}
S_t
&-\frac{\bar{\tau}^K\bar{r}^k\bar{k}}{\bar{S}}(\tau_t^K+rk_t+k_t)
-\frac{\bar{\tau}^L\bar{w}\bar{l}}{\bar{S}}(\tau_t^L+w_t+l_t)
-\frac{\bar{\tau}^C\bar{C}}{\bar{S}}(\tau_t^C+c_t) \\
&+\frac{\bar{Z}}{\bar{S}}z_t+\frac{\bar{G}}{\bar{S}}g_t=0.
\end{aligned}
$$

- **(F27) Labor tax revenue**:

$$
T_t^L-\tau_t^L-w_t-l_t=0.
$$

- **(F28) Observable consumption growth**:

$$
c_t^{obs}-100c_t-100u_t^a=-100c_{t-1}.
$$

- **(F29) Observable investment growth**:

$$
i_t^{obs}-100i_t-100u_t^a=-100i_{t-1}.
$$

- **(F30) Observable government spending growth**:

$$
g_t^{obs}-100g_t-100u_t^a=-100g_{t-1}.
$$

- **(F31) Observable wage growth**:

$$
w_t^{obs}-100w_t-100u_t^a=-100w_{t-1}.
$$

- **(F32) Observable debt growth**:

$$
b_t^{obs}-100b_t-100u_t^a=-100b_{t-1}.
$$

- **(F33) Observable nominal interest rate**:

$$
R_t^{obs}-100R_t=0.
$$

- **(F34) Observable inflation**:

$$
\Pi_t^{obs}-100\pi_t=0.
$$

- **(F35) Observable hours**:

$$
L_t^{obs}-100l_t=0.
$$

## 5. Exogenous Processes

- **(F36) Monetary policy rule**:

$$
R_t-(1-\rho_R)\phi_\pi\pi_t-(1-\rho_R)\phi_y y_t-u_t^m=\rho_R R_{t-1}.
$$

- **(F37) Government spending rule**:

$$
g_t-u_t^G=\rho_G g_{t-1}-(1-\rho_G)\gamma_G s_{t-1}^b.
$$

- **(F38) Capital tax rule**:

$$
\tau_t^K=(1-\rho_K)\gamma_K s_{t-1}^b+\rho_K\tau_{t-1}^K.
$$

- **(F39) Labor tax rule**:

$$
\tau_t^L=(1-\rho_L)\gamma_L s_{t-1}^b+\rho_L\tau_{t-1}^L.
$$

- **(F40) Consumption tax rule**:

$$
\tau_t^C=\rho_C\tau_{t-1}^C.
$$

- **(F41) Transfer rule**:

$$
z_t-u_t^Z=-(1-\rho_Z)\gamma_Z s_{t-1}^b+\rho_Zz_{t-1}.
$$

- **(F42) Government spending shock**:

$$
u_t^G=\rho_{eG}u_{t-1}^G+\varepsilon_t^G.
$$

- **(F43) Transfer shock**:

$$
u_t^Z=\rho_{eZ}u_{t-1}^Z+\varepsilon_t^Z.
$$

- **(F44) Technology-growth shock**:

$$
u_t^a=\rho_a u_{t-1}^a+\varepsilon_t^a.
$$

- **(F45) Preference shock**:

$$
u_t^b=\rho_b u_{t-1}^b+\varepsilon_t^b.
$$

- **(F46) Monetary policy shock**:

$$
u_t^m=\rho_{em}u_{t-1}^m+\sigma_m\varepsilon_t^m.
$$

- **(F47) Investment shock**:

$$
u_t^i=\rho_i u_{t-1}^i+\varepsilon_t^i.
$$

- **(F48) Wage markup shock**:

$$
u_t^w=\rho_w u_{t-1}^w+\varepsilon_t^w.
$$

- **(F49) Price markup shock**:

$$
u_t^p=\rho_p u_{t-1}^p+\varepsilon_t^p.
$$

## 6. Steady-State Solution

Because `US_LTW17` is implemented as `model(linear)`, the dynamic model variables are deviations from the balanced-growth steady state and have zero steady state in the linear model block. The required nonzero constants are computed before the model block and are used as coefficients.

Steady-state construction from the implementation cross-check:

1. Set \(\beta=0.99\), \(\delta=0.025\), \(\alpha=0.33\), \(\pi=1\), and fiscal shares from U.S. data: \(\bar{s}_G=0.11\), \(\bar{s}_b=1.47\), \(\bar{\tau}^L=0.186\), \(\bar{\tau}^K=0.218\), \(\bar{\tau}^C=0.023\).
2. Convert estimated steady growth from `gamm100` to \(\gamma\), set \(e^\gamma\), and compute \(\bar{R}=e^\gamma/\beta\).
3. Use government debt duration \(AD\) to compute the maturity decay and long-bond price: \(\rho=(1-1/AD)/\beta\), \(\bar{P}^B=1/(\bar{R}-\rho)\).
4. Compute the rental return and marginal cost:

$$
\bar{R}^k=\frac{e^\gamma/\beta-1+\delta}{1-\bar{\tau}^K},
\qquad
\bar{mc}=\frac{1}{1+\eta_p}.
$$

5. Solve the wage, capital-labor ratio, fixed cost, output-labor ratio, investment-labor ratio, consumption-labor ratio, transfers, saver/non-saver consumption, and labor scale recursively as in the implementation. These steps are `implementation_cross_check` and `needs_review` against a paper-side appendix.
6. Set all innovations and model deviations to zero in the linear steady state. Runtime validation was not performed.

## 7. Timing & Form Conventions

- **Form**: `model(linear)`. Variables in the model block are deviations from steady state, not nonlinear levels.
- **Growth adjustment**: the paper has permanent technology \(A_t\); the implementation uses growth-adjusted variables and steady-state coefficients involving \(e^\gamma\).
- **Capital timing**: effective capital \(k_t\) depends on utilization \(v_t\), technology growth \(u_t^a\), and lagged physical capital \(\bar{k}_{t-1}\). Physical capital \(\bar{k}_t\) is predetermined through (F14).
- **Debt timing**: the government budget constraint uses lagged debt and lagged bond prices; fiscal rules respond to \(s_{t-1}^b\).
- **Bond maturity**: long-term nominal debt decays at rate \(\rho\), giving duration \((1-\beta\rho)^{-1}\).
- **Policy regime**: this `US_LTW17` implementation cross-check sets active monetary/passive fiscal coefficients for the baseline model. Other same-paper archive IDs (`US_LTW17gz`, `US_LTW17nu`, `US_LTW17rot`) should not be collapsed into this entry.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII name | Meaning | Main equation |
|---|---|---|---|
| Endogenous | `cs` / \(c_t^S\) | saver consumption | (F9), (F18) |
| Endogenous | `cn` / \(c_t^N\) | non-saver consumption | (F17), (F18) |
| Endogenous | `R` / \(R_t\) | nominal interest rate | (F36) |
| Endogenous | `i` / \(i_t\) | investment | (F12), (F16) |
| Endogenous | `k` / \(k_t\) | effective capital | (F13) |
| Endogenous | `v` / \(v_t\) | utilization | (F10) |
| Endogenous | `l` / \(l_t\) | labor | (F1), (F15) |
| Endogenous | `y` / \(y_t\) | output | (F1), (F16) |
| Endogenous | `gc` / \(g_t\) | government consumption | (F37) |
| Endogenous | `c` / \(c_t\) | aggregate consumption | (F18) |
| Endogenous | `q` / \(q_t\) | investment multiplier/Tobin's Q | (F11), (F12) |
| Endogenous | `rk` / \(rk_t\) | real return on private capital | (F2), (F11) |
| Endogenous | `w` / \(w_t\) | real wage | (F2), (F15) |
| Endogenous | `pi` / \(\pi_t\) | inflation | (F4), (F21) |
| Endogenous | `b` / \(b_t\) | government debt | (F20), (F22) |
| Endogenous | `sb` / \(s_t^b\) | debt-output ratio | (F22) |
| Endogenous | `tauk`, `taul`, `tauc` | capital, labor, consumption tax rates | (F38)-(F40) |
| Endogenous | `r` / \(r_t\) | real interest rate | (F21) |
| Endogenous | `z` / \(z_t\) | transfers | (F41) |
| Endogenous | `mc` / \(mc_t\) | real marginal cost | (F3), (F4) |
| Endogenous | `kbar` / \(\bar{k}_t\) | physical capital | (F14) |
| Endogenous | `lambda` / \(\lambda_t\) | marginal utility of wealth | (F5), (F9) |
| Endogenous | `Pb` / \(P_t^B\) | long-bond price | (F19), (F20) |
| Endogenous | `cstar` / \(c_t^{\ast}\) | consumption in utility | (F8) |
| Endogenous | `piL`, `rL` | long-run inflation and real rate | (F6), (F7) |
| Endogenous | `S`, `rb`, `Tk`, `Tl`, `Tc` | surplus, bond return, tax revenues | (F23)-(F27) |
| Observables | `cobs`, `iobs`, `gcobs`, `wobs`, `bobs`, `Robs`, `Piobs`, `Lobs` | measurement equations | (F28)-(F35) |
| Shock states | `ugc`, `uz`, `ua`, `ub`, `um`, `ui`, `uw`, `up` | fiscal, preference, technology, monetary, investment, markup shocks | (F42)-(F49) |
| Exogenous innovations | `eugc`, `euz`, `eua`, `eub`, `eum`, `eui`, `euw`, `eup` | structural innovations | (F42)-(F49) |
| Parameters | `bet`, `delt`, `alph`, `etaw`, `etap`, `xi`, `muHH`, `omegaw`, `omegap`, `gpsi`, `s`, `chiw`, `chip`, `phipi`, `phiy` | preferences, technology, nominal/real rigidities, policy coefficients | - |
| Parameters | `gammgc`, `gammtk`, `gammtl`, `gammz`, `rhoa`, `rhob`, `rhor`, `rhoi`, `rhow`, `rhop`, `rhogc`, `rhotk`, `rhotl`, `rhotc`, `rhoz` | fiscal and shock persistence/feedback | - |
| Parameters | steady-state block names ending in `ss` | coefficient values for the linearized model | (F1)-(F49) |

First-pass equation coverage: 49 numbered conditions in this derivation. The implementation contains additional expectation-helper identities for forward variables; those are not listed as separate economic conditions here and remain `implementation_cross_check`.
