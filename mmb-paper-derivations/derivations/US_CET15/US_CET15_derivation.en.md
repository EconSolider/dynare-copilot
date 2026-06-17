# US_CET15 -- Derivation (Optimization Problems + First-Order Conditions)

> This private-archive draft is for source-backed model understanding. Runtime validation was not performed. The implementation `.mod` was used only as `implementation_cross_check`.

Provenance: model `US_CET15`, Christiano, Eichenbaum, and Trabandt, "Understanding the Great Recession", American Economic Journal: Macroeconomics, DOI `10.1257/mac.20140104`. Primary source Markdown: `raw/mmb_mineru/runs/us_cet15__understanding_the_great_recession__310d6625/full.md`. Raw PDF: `raw/mmb_papers/Understanding the Great Recession.pdf`. MinerU run id: `310d6625-b977-4335-aae4-c44716391cf8`.

## 1. Model Overview

- **Model**: medium-sized New Keynesian DSGE model for the United States, extending Christiano, Eichenbaum, and Trabandt (2013) by making labor force participation endogenous.
- **Purpose**: explain Great Recession movements in output, consumption, investment, employment, unemployment, vacancies, labor force participation, wages, inflation, and interest rates using financial, consumption, technology, and government-spending shocks.
- **Agents and blocks**: representative household with home production and labor-force choice; final-good aggregator; Calvo retailers; competitive wholesalers/search-and-matching labor market with alternating-offer bargaining; government; monetary authority; technology and wedge shock processes.
- **Nominal rigidities**: Calvo prices, no nominal wage rigidity in the paper model.
- **Form**: nonlinear equilibrium system with balanced-growth scaling and log-variable implementation in MMB. Post-2008 simulations use the nonlinear conditions with certainty equivalence, a binding ZLB, and regime-switching monetary policy. The MMB `.mod` is a log-level first-order implementation with separate `R` and `F` economies for monetary-policy information timing.
- **Status**: `needs_review`; the paper states that many technical details are in a separate technical appendix, and no normalized appendix file exists for this entry.

## 2. Optimization Problems

### 2.1 Household

Each household has a unit mass of members split among nonparticipation, employment, and unemployment. It chooses market consumption, home consumption, investment, utilization, capital accumulation, labor force participation, employment, and financial assets. Period utility is:

$$
\mathcal{U}_t = \ln \tilde{C}_t + v\left(\frac{M_{t+1}}{P_t}\right),
\qquad
\tilde{C}_t =
\left[(1-\omega)(C_t-b\bar C_{t-1})^\chi
+ \omega(C_t^H-b\bar C_{t-1}^H)^\chi\right]^{1/\chi}.
$$

Home production and labor-force adjustment costs are:

$$
C_t^H = \eta_t^H(1-L_t) - \mathcal{F}(L_t,L_{t-1};\eta_t^L),
\qquad
\mathcal{F}(L_t,L_{t-1};\eta_t^L)
= \frac{1}{2}\eta_t^L\phi_L\left(\frac{L_t}{L_{t-1}}-1\right)^2.
$$

The household budget and asset constraints are:

$$
P_t C_t + P_{I,t}I_t + \mathcal{A}_{t+1}
\leq
\left(R_{K,t}u_t^K-a(u_t^K)P_{I,t}\right)K_t
+(L_t-l_t)P_t\eta_t^D D + l_t W_t - T_t + B_t + M_t,
$$

$$
\mathcal{A}_{t+1}\geq \frac{B_{t+1}}{R_t}+M_{t+1}.
$$

Capital evolves according to:

$$
K_{t+1}=(1-\delta_K)K_t+\left[1-S(I_t/I_{t-1})\right]I_t.
$$

### 2.2 Final-Good Producer

A competitive final-good firm aggregates differentiated retailer outputs:

$$
Y_t=\left[\int_0^1 Y_{j,t}^{1/\lambda}\,dj\right]^\lambda,
\qquad
\max_{\{Y_{j,t}\}}\; P_tY_t-\int_0^1P_{j,t}Y_{j,t}\,dj.
$$

### 2.3 Retailers

Retailer `j` produces a differentiated input using capital services and wholesaler labor input:

$$
Y_{j,t}=k_{j,t}^{\alpha}(z_t h_{j,t})^{1-\alpha}-\eta_t^\phi\phi.
$$

The retailer chooses factor inputs and sets prices subject to demand and Calvo rigidity:

$$
P_{j,t}=
\begin{cases}
P_{j,t-1}, & \text{with probability }\xi,\\
\tilde P_t, & \text{with probability }1-\xi.
\end{cases}
$$

The risky-working-capital version replaces the normal intermediate-input financing cost with:

$$
P_t^h\left[\varkappa R_t(1+\hat\Delta_t^k)+(1-\varkappa)\right].
$$

### 2.4 Wholesalers and Labor Market

The competitive wholesaler hires workers in a matching market, pays vacancy/hiring costs, and bargains wages through the alternating-offer protocol. Free entry equates hiring cost and match value:

$$
\eta_t^\kappa\kappa = J_t.
$$

Wages satisfy the alternating-offer sharing rule:

$$
\alpha_1J_t=\alpha_2(V_t-U_t)-\alpha_3\eta_t^\gamma\gamma+\alpha_4(\vartheta_t-\eta_t^D D).
$$

### 2.5 Policy and Wedges

The monetary authority follows an interest-rate rule outside the ZLB. Great Recession simulations add a consumption wedge to the bond Euler equation and a financial wedge to the capital Euler equation. Government consumption is exogenous after balanced-growth scaling.

## 3. First-Order Conditions

- **(F1) Composite-consumption marginal utility**:

$$
\lambda_{C,t}
= (1-\omega)\tilde C_t^{1-\chi-1}(C_t-b\bar C_{t-1})^{\chi-1}.
$$

- **(F2) Home-consumption marginal utility**:

$$
\lambda_{H,t}
= \omega \tilde C_t^{1-\chi-1}(C_t^H-b\bar C_{t-1}^H)^{\chi-1}.
$$

- **(F3) Bond Euler equation with consumption wedge**:

$$
1=(1+\Delta_t^b)E_t\left[m_{t+1}\frac{R_t}{\pi_{t+1}}\right].
$$

- **(F4) Capital Euler equation with financial wedge**:

$$
1=(1-\tilde\Delta_t^k)E_t\left[m_{t+1}\frac{R_{t+1}^k}{\pi_{t+1}}\right].
$$

- **(F5) Investment adjustment-cost FOC** `needs_review`: the paper defines the adjustment-cost function but the OCR Markdown does not print the full FOC. In the implementation cross-check it is represented by a Tobin-price equation for `pk`:

$$
1=P_{K,t}\left[1-S_t-S_t'\frac{I_t}{I_{t-1}}\mu_{\Phi,t}\mu_{\Psi,t}\right]
+E_t\left[m_{t+1}\mu_{\Phi,t+1}P_{K,t+1}S'_{t+1}
\left(\frac{I_{t+1}}{I_t}\right)^2\mu_{\Phi,t+1}\mu_{\Psi,t+1}\right].
$$

- **(F6) Capital accumulation**:

$$
K_{t+1}=(1-\delta_K)K_t+\left[1-S(I_t/I_{t-1})\right]I_t.
$$

- **(F7) Utilization rental condition** `needs_review`:

$$
R_{K,t}=P_{I,t}a'(u_t^K).
$$

- **(F8) Final-good demand for retailer `j`**:

$$
Y_{j,t}=\left(\frac{P_t}{P_{j,t}}\right)^{\lambda/(\lambda-1)}Y_t.
$$

- **(F9) Retail production**:

$$
Y_{j,t}=k_{j,t}^{\alpha}(z_t h_{j,t})^{1-\alpha}-\eta_t^\phi\phi.
$$

- **(F10) Working-capital marginal input cost**:

$$
MC^h_t=P_t^h\left[\varkappa R_t(1+\hat\Delta_t^k)+(1-\varkappa)\right].
$$

- **(F11) Retailer cost-minimization condition** `needs_review`:

$$
a'(u_t^K)u_t^K\frac{K_t}{\mu_{\Phi,t}\mu_{\Psi,t}}
=\frac{\alpha}{1-\alpha}\left[\varkappa R_t(1+\hat\Delta_t^k)+(1-\varkappa)\right]\vartheta_t l_t.
$$

- **(F12) Calvo price auxiliary recursion 1** `needs_review`:

$$
F_t=\lambda_{C,t}Y_t+\beta\xi E_t\left[\left(\frac{\tilde\pi_{t+1}}{\pi_{t+1}}\right)^{1/(1-\lambda)}F_{t+1}\right].
$$

- **(F13) Calvo price auxiliary recursion 2** `needs_review`:

$$
K_t^p=\lambda \lambda_{C,t}Y_t MC_t
+\beta\xi E_t\left[\left(\frac{\tilde\pi_{t+1}}{\pi_{t+1}}\right)^{\lambda/(1-\lambda)}K_{t+1}^p\right].
$$

- **(F14) Optimal reset-price condition** `needs_review`:

$$
K_t^p-F_t=(1-\lambda)\log\left(\frac{1-\xi(\tilde\pi_t/\pi_t)^{1/(1-\lambda)}}{1-\xi}\right).
$$

- **(F15) Price dispersion** `needs_review`:

$$
\Delta_t^{\lambda/(1-\lambda)}
=(1-\xi)^{1-\lambda}\left[1-\xi(\tilde\pi_t/\pi_t)^{1/(1-\lambda)}\right]^\lambda
+\xi(\tilde\pi_t\Delta_{t-1})^{\lambda/(1-\lambda)}.
$$

- **(F16) Present value of wages**:

$$
w_t^p=w_t+\rho E_t[m_{t+1}w_{t+1}^p].
$$

- **(F17) Present value of marginal revenue product**:

$$
\vartheta_t^p=\vartheta_t+\rho E_t[m_{t+1}\vartheta_{t+1}^p].
$$

- **(F18) Firm match value**:

$$
J_t=\vartheta_t^p-w_t^p.
$$

- **(F19) Free-entry hiring condition**:

$$
J_t=\eta_t^\kappa\kappa.
$$

- **(F20) Worker value of employment**:

$$
V_t=w_t^p+A_t.
$$

- **(F21) Worker value after separation**:

$$
A_t=(1-\rho)E_t m_{t+1}\left[s f_{t+1}V_{t+1}
+s(1-f_{t+1})U_{t+1}
+(1-s)(\mathcal{L}_{t+1}+N_{t+1})\right]
+\rho E_t[m_{t+1}A_{t+1}].
$$

- **(F22) Unemployment value**:

$$
U_t=\eta_t^D D+E_t m_{t+1}\left[s f_{t+1}V_{t+1}
+s(1-f_{t+1})U_{t+1}
+(1-s)(\mathcal{L}_{t+1}+N_{t+1})\right].
$$

- **(F23) Nonparticipation value**:

$$
N_t=\lambda_t\eta_t^H+E_t m_{t+1}
\left[e_{t+1}\left(f_{t+1}V_{t+1}+(1-f_{t+1})U_{t+1}-\mathcal{L}_{t+1}\right)
+(1-e_{t+1})N_{t+1}\right].
$$

- **(F24) Alternating-offer wage sharing rule**:

$$
\alpha_1J_t=\alpha_2(V_t-U_t)-\alpha_3\eta_t^\gamma\gamma+\alpha_4(\vartheta_t-\eta_t^D D).
$$

- **(F25) Employment law of motion**:

$$
l_t=\rho l_{t-1}+f_t(L_t-\rho l_{t-1}).
$$

- **(F26) Job-finding rate**:

$$
f_t=\frac{x_tl_{t-1}}{L_t-\rho l_{t-1}}.
$$

- **(F27) Entry from nonparticipation**:

$$
e_t=\frac{L_t-s(L_{t-1}-\rho l_{t-1})-\rho l_{t-1}}{1-L_{t-1}}.
$$

- **(F28) Labor-force choice condition** `needs_review`:

$$
\eta_t^D D+p_{l,t}f_t
-\lambda_t\frac{C_t^H+\mathcal{F}(L_t,L_{t-1};\eta_t^L)}{1-L_t}
-\lambda_t\mathcal{F}_1(L_t,L_{t-1};\eta_t^L)
-E_t[m_{t+1}\lambda_{t+1}\mathcal{F}_2(L_{t+1},L_t;\eta_{t+1}^L)]
=0.
$$

- **(F29) Home consumption**:

$$
C_t^H=\eta_t^H(1-L_t)-\mathcal{F}(L_t,L_{t-1};\eta_t^L).
$$

- **(F30) Matching function**:

$$
x_tl_{t-1}=\sigma_m(L_t-\rho l_{t-1})^\sigma(l_{t-1}v_t)^{1-\sigma}.
$$

- **(F31) Vacancy filling rate**:

$$
Q_t=\frac{x_t}{v_t}.
$$

## 4. Market Clearing & Identities

- **(F32) Intermediate-good market clearing**:

$$
h_t=l_t.
$$

- **(F33) Capital-services market clearing**:

$$
u_t^K K_t=\int_0^1k_{j,t}\,dj.
$$

- **(F34) Final-goods resource constraint**:

$$
C_t+\frac{I_t+a(u_t^K)K_t}{\Psi_t}+\eta_t^\kappa\kappa x_tl_{t-1}+G_t=Y_t.
$$

- **(F35) Investment-goods price**:

$$
P_{I,t}=\frac{P_t}{\Psi_t}.
$$

- **(F36) Loan-market clearing**:

$$
\varkappa h_tP_t^h=\frac{B_{t+1}}{R_t}.
$$

- **(F37) GDP identity used in the policy rule**:

$$
\mathcal{O}_t=C_t+\frac{I_t}{\Psi_t}+G_t.
$$

## 5. Exogenous Processes

- **(F38) Monetary policy rule outside the ZLB**:

$$
\ln(R_t/R)=\rho_R\ln(R_{t-1}/R)
+(1-\rho_R)\left[
0.25 r_\pi\ln\left(\frac{\pi_t^A}{\pi^A}\right)
+0.25 r_{\Delta y}\ln\left(\frac{\mathcal{O}_t}{\mathcal{O}_{t-4}\mu_\mathcal{O}^A}\right)
\right]
+\sigma_R\varepsilon_{R,t}.
$$

- **(F39) Government consumption**:

$$
G_t=\eta_t^g g_t.
$$

- **(F40) Investment-specific technology growth**:

$$
\ln\mu_{\Psi,t}=(1-\rho_\Psi)\ln\mu_\Psi+\rho_\Psi\ln\mu_{\Psi,t-1}
+\sigma_\Psi\varepsilon_{\Psi,t}.
$$

- **(F41) Neutral technology growth decomposition**:

$$
\ln\mu_{z,t}=\ln(z_t/z_{t-1})=\ln\mu_z+\mu_{P,t}+\mu_{T,t}.
$$

- **(F42) Persistent neutral-technology component**:

$$
\mu_{P,t}=\rho_P\mu_{P,t-1}+\sigma_P\varepsilon_{P,t}.
$$

- **(F43) Transitory neutral-technology component**:

$$
\mu_{T,t}=\rho_T\mu_{T,t-1}+\sigma_T(\varepsilon_{T,t}-\varepsilon_{T,t-1}).
$$

- **(F44) Wold representation of neutral technology**:

$$
(1-\rho_PL)(1-\rho_TL)\ln(\mu_{z,t})
=(1-\theta_1L-\theta_2L^2)\sigma_\eta\eta_t.
$$

- **(F45) Balanced-growth composite technology**:

$$
\Phi_t=\Psi_t^{\alpha/(1-\alpha)}z_t.
$$

- **(F46) Slow-moving balanced-growth normalizers**:

$$
\Omega_{i,t}=\Phi_{t-1}^{\theta}(\Omega_{i,t-1})^{1-\theta},
\qquad i=1,\ldots,7.
$$

- **(F47) Consumption-wedge process**:

$$
\Delta_t^b=1.5\Delta_{t-1}^b-0.56\Delta_{t-2}^b+\varepsilon_t^b.
$$

- **(F48) Financial-spread mapping**:

$$
\Gamma_t=E_t\left[\frac{\Delta_t^k+\Delta_{t+1}^k+\cdots+\Delta_{t+27}^k}{7}\right],
\qquad
E_t\Gamma_{t+1}=0.5\Gamma_t.
$$

- **(F49) Working-capital wedge scale**:

$$
\hat\Delta_t^k=0.33\Delta_t^k.
$$

## 6. Steady-State Solution

The model is solved around a nonstochastic balanced-growth path. Variables such as $Y_t/\Phi_t$, $C_t/\Phi_t$, $w_t/\Phi_t$, and $I_t/(\Psi_t\Phi_t)$ converge to constants.

Steady-state normalization and calibration steps:

1. Set steady growth from calibrated averages: annual output per-capita growth fixes $\mu_\Phi$; annual investment growth fixes $\mu_\Phi\mu_\Psi$.
2. Set $u_t^K=1$, $S(\mu_\Phi\mu_\Psi)=S'(\mu_\Phi\mu_\Psi)=0$, and labor-force adjustment cost equal to zero at $L_t=L_{t-1}$.
3. Set steady inflation target $\pi^A$ at 2 percent annual net inflation and choose $\beta$ to imply a 3 percent annual real rate.
4. Calibrate $\delta_K=0.025$, job survival $\rho=0.9$, $Q=0.7$, unemployment rate $u=0.055$, labor force $L=0.67$, and $G/Y=0.2$.
5. Infer employment $l=L(1-u)$, hiring rate $x=1-\rho$, job-finding rate $f=xl/(L-\rho l)$, vacancies from $Q=x/v$, and the matching-efficiency parameter from (F30).
6. Choose $\omega$, $\sigma_m$, $\phi$, $\gamma$, and government scale `g` so the calibrated steady-state targets for labor force, vacancy filling, government-output share, unemployment, and zero retailer profits hold.
7. The MMB implementation cross-check computes a log steady state for all `R` and `F` variables, but this archive draft does not validate residuals or BK conditions.

This section is `needs_review` because the source Markdown gives steady-state targets and implied values but not a complete hand-normalized steady-state derivation.

## 7. Timing & Form Conventions

- Time is quarterly.
- In the paper equations, $K_t$ is the capital stock owned at the start of period `t` and evolves to $K_{t+1}$; the MMB implementation logs a scaled stock `kstst` with lagged stock used in current production.
- Employment entering period `t` is inherited through $\rho l_{t-1}$ plus new hires; current employment is $l_t=(\rho+x_t)l_{t-1}$.
- The monetary policy shock is not in the period-`t` information set for price/wage and quantity decisions in the MMB implementation. The `.mod` implements this with two parallel economies: `R` for monetary-policy shocks under restricted information and `F` for other shocks under the standard information set.
- All implementation endogenous variables are in logs; aggregate reported variables are deviations from steady state combining the `R` and `F` economies.
- The paper's Great Recession simulations use nonlinear conditions with certainty equivalence, a ZLB, and forward-guidance regime switching. The local archive entry records no Dynare runtime validation.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII cue | Meaning | Equation cue |
|---|---|---|---|
| endogenous | $C_t$ / `c` | market consumption | (F1), (F34) |
| endogenous | $\tilde C_t$ | composite consumption | (F1)-(F2) |
| endogenous | $C_t^H$ / `cH` | home consumption | (F2), (F29) |
| endogenous | $\lambda_{C,t}$ / `lambda_C` | marginal utility of market consumption | (F1), (F3) |
| endogenous | $I_t$ / `i` | investment | (F5), (F34) |
| endogenous | $K_t$ / `kstst` | physical capital stock | (F6), (F33) |
| endogenous | $u_t^K$ / `uk` | utilization | (F7), (F33) |
| endogenous | $P_{I,t}$ / `pk` | investment-good price | (F35) |
| endogenous | $Y_t$ / `y` | gross output | (F9), (F34) |
| endogenous | $\mathcal O_t$ / `GDP` | GDP measure for policy rule | (F37), (F38) |
| endogenous | $\pi_t$ / `pi` | inflation | (F3), (F38) |
| endogenous | $R_t$ / `R` | nominal interest rate | (F3), (F38) |
| endogenous | $\Delta_t$ / `Disp` | price dispersion | (F15) |
| endogenous | $F_t,K_t^p$ / `F`, `K` | Calvo pricing auxiliaries | (F12)-(F14) |
| endogenous | $L_t$ / `L` | labor force | (F25), (F27), (F28) |
| endogenous | $l_t$ / `l` | employment | (F25), (F30) |
| endogenous | $u_t$ / `unemp` | unemployment rate | definition from $L_t,l_t$ |
| endogenous | $x_t$ / `x` | hiring rate | (F25), (F30) |
| endogenous | $f_t$ / `f` | job-finding probability | (F26) |
| endogenous | $v_t$ / `v`, `vTot` | vacancy rate / vacancies | (F30), (F31) |
| endogenous | $Q_t$ / `Q` | vacancy-filling probability | (F31) |
| endogenous | $w_t,w_t^p$ / `w`, `wp` | real wage and wage present value | (F16), (F24) |
| endogenous | $J_t,V_t,U_t,N_t,A_t$ / `J`, `V`, `U`, `N`, `A` | match and worker state values | (F18)-(F24) |
| endogenous | $\vartheta_t,\vartheta_t^p$ / `varthet`, `varthetp` | marginal revenue product and present value | (F17), (F18) |
| exogenous/state | $\mu_{\Psi,t}$ / `mupsi` | investment-specific technology growth | (F40) |
| exogenous/state | $\mu_{z,t}$ / `muz` | neutral technology growth | (F41)-(F44) |
| exogenous/state | $\eta_t^g,\eta_t^D,\eta_t^\gamma,\eta_t^\kappa,\eta_t^\phi,\eta_t^L,\eta_t^H$ / `nG` family | balanced-growth normalizers | (F46) |
| exogenous/wedge | $\Delta_t^b$ | consumption wedge | (F3), (F47) |
| exogenous/wedge | $\Delta_t^k,\hat\Delta_t^k,\Gamma_t$ | financial and working-capital wedges | (F4), (F10), (F48), (F49) |
| varexo | `epsR_eps`, `muz_eps`, `mupsi_eps` | MMB implementation shocks | implementation cross-check |
| parameter | $\beta,b,\omega,\chi$ | preferences and habit/home-consumption parameters | (F1)-(F3) |
| parameter | $\alpha,\delta_K,\lambda,\xi,\varkappa$ | production, depreciation, markup, Calvo, working-capital share | (F6)-(F15) |
| parameter | $\rho,s,\sigma,\sigma_m,\kappa,\delta,M,\gamma,D,\phi_L$ | labor market and bargaining parameters | (F19)-(F31) |
| parameter | $\rho_R,r_\pi,r_{\Delta y},\sigma_R$ | monetary-policy parameters | (F38) |
| parameter | $\rho_\Psi,\rho_P,\rho_T,\sigma_\Psi,\sigma_P,\sigma_T,\theta_1,\theta_2,\sigma_\eta$ | technology-process parameters | (F40)-(F44) |

Equation-variable count is not asserted for this first-pass derivation because the published Markdown does not contain the full technical appendix and the MMB implementation duplicates many variables across restricted-information and full-information economies.
