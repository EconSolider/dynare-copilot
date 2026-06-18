# NK_MPT10 - Derivation (optimization problems + first-order conditions)

> Archive status: needs_review. Runtime validation was not performed. The `.mod` file was used only as `implementation_cross_check`, not as a paper-side mathematical source.

Source provenance: `NK_MPT10`, Monacelli, Tommaso; Perotti, Roberto; Trigari, Antonella (2010), "Unemployment fiscal multipliers", Journal of Monetary Economics 57(5), 531-553, DOI `10.1016/j.jmoneco.2010.05.009`. Primary OCR Markdown: `raw/mmb_mineru/runs/nk_mpt10__unemployment_fiscal_multipliers__7b622dc6/full.md`; raw PDF: `raw/mmb_papers/Unemployment fiscal multipliers.pdf`; MinerU run id: `7b622dc6-7f76-4474-a39f-7237f4510f1b`.

## 1. Model Overview

- **Model**: Monthly search-and-matching model with fiscal shocks and the New Keynesian extension from Monacelli, Perotti, and Trigari (2010), section 7. The MMB implementation label is `NK_MPT10`.
- **Experiment**: Government spending shock, calibrated as a rise in government purchases equal to 1 percent of steady-state output in the paper simulations; the MMB implementation targets the paper's Figure 11 case with `sigma=1`.
- **Agents and blocks**: representative household/family, intermediate goods firms with vacancy posting and search frictions, Nash bargaining over wages, capital accumulation with investment adjustment costs, fiscal authority, monopolistically competitive retail firms with Calvo price rigidity, and a Taylor-style monetary policy rule.
- **Form**: nonlinear equilibrium system solved by first-order perturbation in the implementation. The paper also presents a log-linear tightness equation for interpretation, but the model equations below are nonlinear unless explicitly marked as a log-linear diagnostic.
- **Source quality note**: the paper OCR clearly preserves the baseline model equations (1)-(29), the extension equations (35)-(39), and the NK surplus equation in section 7. It does not expose all Calvo recursive equations in paper-side text; those are therefore marked `needs_review` and cross-checked only against `NK_MPT10_rep.mod`.

## 2. Optimization Problems

### 2.1 Matching and Employment Timing

At the beginning of period $`t`$, unemployed searchers are

```math
u_t = 1 - n_{t-1}.
```

Matches are produced by a Cobb-Douglas matching function. New matches become productive in the current period and are not separated until the following period:

```math
m_t = \gamma_m u_t^\gamma v_t^{1-\gamma}, \qquad
q_t = \frac{m_t}{v_t} = \gamma_m\theta_t^{-\gamma}, \qquad
p_t = \frac{m_t}{u_t} = \gamma_m\theta_t^{1-\gamma}, \qquad
\theta_t = \frac{v_t}{u_t}.
```

### 2.2 Intermediate Goods Firm

The representative intermediate goods firm chooses capital and employment, equivalently vacancies, taking wages, rental rates, and matching probabilities as given:

```math
F(n_{t-1},k_t)=\max_{\{k_t,n_t\}}
\left\{
z_t k_t^\alpha n_t^{1-\alpha}
-w_t n_t-\kappa v_t-r_{k,t}k_t
+\beta E_t\left[\Lambda_{t,t+1}F(n_t,k_{t+1})\right]
\right\}
```

subject to

```math
n_t=\rho n_{t-1}+q_t v_t.
```

In the NK extension, the intermediate producer sells to retailers; real marginal cost is the inverse markup, so the marginal products entering the surplus are scaled by $`mc_t=\mu_t^{-1}`$.

### 2.3 Representative Household / Family

The household pools income across members. After optimizing over employed and unemployed members' consumption allocations, the paper writes the household as maximizing

```math
E_0\sum_{t=0}^{\infty}\beta^t
\frac{c_t^{1-\sigma}\left(1+(\sigma-1)b n_t\right)^\sigma-1}{1-\sigma}
```

subject to the period budget constraint

```math
c_t+i_t+E_t\left[\Lambda_{t,t+1}B_{t+1}\right]
\leq w_t n_t+r_{k,t}k_t+B_t+\pi_t-\tau_t,
```

capital accumulation

```math
k_{t+1}=(1-\delta)k_t+i_t(1-\phi_t),
```

and the household employment law of motion

```math
n_t=\rho n_{t-1}+p_t(1-n_{t-1}).
```

### 2.4 Wage Bargaining

The firm and marginal worker choose the wage by Nash bargaining:

```math
\max_{w_t}\; (H_{n,t})^\eta(F_{n,t})^{1-\eta},
```

where $`H_{n,t}`$ is the household value of an additional employed member and $`F_{n,t}`$ is the firm value of an additional worker.

### 2.5 Retail Price Setting

Retailers buy intermediate goods competitively, differentiate output, and sell final goods under monopolistic competition. The paper states a conventional Calvo specification with reset probability $`1-\phi`$ and a Taylor rule, but the OCR Markdown does not include the full retailer optimization equations. The Calvo recursive equations below are therefore `needs_review` and are recorded as `implementation_cross_check` because they are visible in the MMB `.mod`.

## 3. First-Order Conditions

- **(F1) Employment law of motion**:

```math
n_t=\rho n_{t-1}+q_t v_t.
```

- **(F2) Rental rate of capital**:

```math
r_{k,t}=\alpha\frac{y_t}{k_t}.
```

- **(F3) Firm hiring condition**:

```math
\frac{\kappa}{q_t}
=a_t-w_t+\rho\beta E_t\left[\Lambda_{t,t+1}\frac{\kappa}{q_{t+1}}\right].
```

- **(F4) Firm marginal worker value**:

```math
F_{n,t}=a_t-w_t+\rho\beta E_t\left[\Lambda_{t,t+1}F_{n,t+1}\right].
```

- **(F5) Vacancy cost equals firm marginal worker value**:

```math
\frac{\kappa}{q_t}=F_{n,t}.
```

- **(F6) Household marginal utility of wealth**:

```math
\lambda_t=\left(\frac{1+(\sigma-1)b n_t}{c_t}\right)^\sigma.
```

- **(F7) Investment adjustment-cost FOC**:

```math
\varphi_t\left[1-\left(\phi_t+\frac{i_t}{i_{t-1}}\phi_{i,t}\right)\right]
=1-\beta E_t\left[
\varphi_{t+1}\Lambda_{t,t+1}
\left(\frac{i_{t+1}}{i_t}\right)^2\phi_{i,t+1}
\right].
```

- **(F8) Capital FOC**:

```math
\varphi_t=\beta E_t\left[\Lambda_{t,t+1}\left(r_{k,t+1}+\varphi_{t+1}(1-\delta)\right)\right].
```

- **(F9) Household marginal value of employment**:

```math
H_{n,t}=\lambda_t w_t-U_{n,t}
+\beta(\rho-p_{t+1})E_t\left[H_{n,t+1}\right].
```

- **(F10) Marginal disutility of employment**:

```math
U_{n,t}=\sigma b\left(\frac{1+(\sigma-1)b n_t}{c_t}\right)^{\sigma-1}.
```

- **(F11) Marginal value of non-work activity**:

```math
\omega_t=\frac{U_{n,t}}{\lambda_t}=\sigma b\lambda_t^{-1/\sigma}.
```

- **(F12) Nash bargaining rule**:

```math
\eta F_{n,t}=(1-\eta)\frac{H_{n,t}}{\lambda_t}.
```

- **(F13) Total surplus definition**:

```math
S_{n,t}=\frac{H_{n,t}}{\lambda_t}+F_{n,t}.
```

- **(F14) Worker surplus share**:

```math
\frac{H_{n,t}}{\lambda_t}=\eta S_{n,t}.
```

- **(F15) Firm surplus share**:

```math
F_{n,t}=(1-\eta)S_{n,t}.
```

- **(F16) Reservation wage spread**:

```math
S_{n,t}=\overline{w}_t-\underline{w}_t.
```

- **(F17) Firm reservation wage**:

```math
\overline{w}_t=a_t+\rho\beta E_t\left[\Lambda_{t,t+1}F_{n,t+1}\right].
```

- **(F18) Worker reservation wage**:

```math
\underline{w}_t=\omega_t-\beta E_t\left[(\rho-p_{t+1})\Lambda_{t,t+1}H_{n,t+1}\right].
```

- **(F19) Bargained wage**:

```math
w_t=\eta\overline{w}_t+(1-\eta)\underline{w}_t.
```

- **(F20) Total match surplus recursion**:

```math
S_{n,t}=a_t-\omega_t+\beta E_t\left[(\rho-\eta p_{t+1})\Lambda_{t,t+1}S_{n,t+1}\right].
```

- **(F21) Hiring condition in tightness form**:

```math
\kappa\gamma_m^{-1}\theta_t^\gamma=(1-\eta)S_{n,t}.
```

- **(F22) Combined tightness equation**:

```math
\kappa\gamma_m^{-1}\theta_t^\gamma
=(1-\eta)(a_t-\omega_t)
+\beta E_t\left[(\rho-\eta p_{t+1})\Lambda_{t,t+1}
\kappa\gamma_m^{-1}\theta_{t+1}^\gamma\right].
```

- **(F23) NK effective marginal product of labor**:

```math
a_{\mu,t}=\mu_t^{-1}a_t.
```

- **(F24) NK match surplus recursion**:

```math
S_{n,t}=a_{\mu,t}-\omega_t
+\beta E_t\left[(\rho-\eta p_{t+1})\Lambda_{t,t+1}S_{n,t+1}\right].
```

- **(F25) Taylor rule from section 7**:

```math
1+r_t^n=(1+r)\pi_t^{\phi_\pi}\left(\frac{y_t}{y_{t-1}}\right)^{\phi_y}.
```

- **(F26) Fisher relation for nominal and real rates** (`implementation_cross_check`):

```math
1+r_t^n=(1+r_t)\pi_{t+1}.
```

- **(F27) Calvo price dispersion recursion** (`needs_review`, `implementation_cross_check`):

```math
D_t=\phi D_{t-1}\pi_{t-1}^{-\gamma_P\epsilon}\pi_t^\epsilon
+(1-\phi)\left(\frac{1-\phi\pi_{t-1}^{\gamma_P(1-\epsilon)}\pi_t^{\epsilon-1}}{1-\phi}\right)^{-\epsilon/(1-\epsilon)}.
```

- **(F28) Calvo numerator recursion** (`needs_review`, `implementation_cross_check`):

```math
P_{F,t}=Y_t mc_t+\beta\phi E_t\left[
\Lambda_{t,t+1}\pi_{t+1}^{\epsilon}\pi_t^{-\epsilon\gamma_P}P_{F,t+1}
\right].
```

- **(F29) Calvo denominator recursion** (`needs_review`, `implementation_cross_check`):

```math
P_{Z,t}=Y_t+\beta\phi E_t\left[
\Lambda_{t,t+1}\pi_{t+1}^{\epsilon-1}\pi_t^{\gamma_P(1-\epsilon)}P_{Z,t+1}
\right].
```

- **(F30) Optimal reset-price relation** (`needs_review`, `implementation_cross_check`):

```math
\pi_t^\star=\frac{\epsilon}{\epsilon-1}\frac{P_{F,t}}{P_{Z,t}}\pi_t.
```

- **(F31) Price index condition** (`needs_review`, `implementation_cross_check`):

```math
\pi_t^{1-\epsilon}=\phi\pi_{t-1}^{\gamma_P(1-\epsilon)}
+(1-\phi)(\pi_t^\star)^{1-\epsilon}.
```

## 4. Market Clearing & Identities

- **(F32) Production function**:

```math
y_t=z_t k_t^\alpha n_t^{1-\alpha}.
```

In the NK implementation, source-side intermediate output and final output are separated by price dispersion:

```math
y_t=Y_tD_t.
```

- **(F33) Capital accumulation**:

```math
k_{t+1}=(1-\delta)k_t+i_t(1-\phi_t).
```

- **(F34) Investment adjustment cost**:

```math
\phi_t=\frac{\eta_k}{2}\left(\frac{i_t}{i_{t-1}}-1\right)^2,\qquad
\phi_{i,t}=\eta_k\left(\frac{i_t}{i_{t-1}}-1\right).
```

- **(F35) Government budget under lump-sum taxes**:

```math
\tau_t=g_t.
```

- **(F36) Aggregate resource constraint**:

```math
y_t=c_t+g_t+i_t+\kappa v_t.
```

- **(F37) Matching function**:

```math
m_t=\gamma_m u_t^\gamma v_t^{1-\gamma}.
```

- **(F38) Job-filling probability**:

```math
q_t=\gamma_m\theta_t^{-\gamma}.
```

- **(F39) Job-finding probability**:

```math
p_t=\gamma_m\theta_t^{1-\gamma}.
```

- **(F40) Labor-market tightness**:

```math
\theta_t=\frac{v_t}{u_t}.
```

- **(F41) Unemployment identity**:

```math
u_t=1-n_{t-1}.
```

- **(F42) Flexible-price benchmark output gap** (`implementation_cross_check`):

```math
outputgap_t=Y_t-Y^{fe}_t.
```

## 5. Exogenous Processes

- **(F43) Government spending process**:

```math
\log(g_t)=(1-\rho_g)\log(g_{ss})+\rho_g\log(g_{t-1})+\varepsilon_{g,t}.
```

The paper's equation (28) OCR/published text writes the steady-state share $`g_y`$ in the intercept; the MMB implementation comment says this must be replaced by the steady-state level of government spending, $`g_{ss}`$. This is recorded as an implementation cross-check, not as a new paper source.

- **(F44) Monetary policy shock** (`implementation_cross_check`):

```math
\varepsilon_{i,t}
```

is declared in the implementation but disabled in the active Taylor rule used for the paper replication.

## 6. Steady-State Solution

The model is calibrated at monthly frequency. The paper states conventional values $`\beta=0.99^{1/3}`$, $`\delta=0.025/3`$, $`\alpha=1/3`$, $`\rho_g=0.9^{1/3}`$, matching elasticity $`\gamma=0.5`$, bargaining power $`\eta=0.5`$, and baseline separability $`\sigma=1`$. The NK section states a steady-state markup of 16 percent, a four-quarter degree of price stickiness, and Taylor parameters $`\phi_\pi=1.5`$ and $`\phi_y=0.5/4`$; the implementation converts several parameters to monthly frequency.

Use the following source-backed steady-state ordering:

1. Choose targets: $`\theta=0.5`$, $`p=0.45`$, $`\overline{\omega}=0.9`$, $`G/Y=0.2`$, and $`\sigma=1`$ for the MMB replication.
2. Set $`q=\gamma_m\theta^{-\gamma}`$ and $`p=\gamma_m\theta^{1-\gamma}`$, so $`\gamma_m=p\theta^{\gamma-1}`$.
3. Employment and unemployment:

```math
n=\frac{p}{1-\rho+p}, \qquad u=1-n, \qquad v=\theta u,\qquad m=\gamma_m u^\gamma v^{1-\gamma}.
```

4. Capital returns:

```math
r_k=\frac{1}{\beta}+\delta-1.
```

5. With NK real marginal cost $`mc=(\epsilon-1)/\epsilon`$, use

```math
\frac{Y}{K}=\frac{r_k}{\alpha mc}, \qquad
\frac{K}{N}=\left(\frac{Y}{K}\right)^{1/(\alpha-1)}, \qquad
k=\frac{K}{N}n,\qquad y=\frac{Y}{K}k.
```

6. Labor marginal product:

```math
a=(1-\alpha)mc\frac{y}{n}.
```

7. Investment and government:

```math
i=\delta k,\qquad g=0.2y,\qquad \tau=g.
```

8. Non-work value, surplus, firm worker value, and hiring cost:

```math
\omega=\overline{\omega}a,\qquad
S=\frac{a-\omega}{1-\beta(\rho-\eta p)},\qquad
F=(1-\eta)S,\qquad
\kappa=Fq.
```

9. Wage and reservation wages:

```math
w=a-(1-\rho\beta)F,\qquad
\overline{w}=a+\rho\beta F,\qquad
\underline{w}=\overline{w}-S.
```

10. Consumption from the resource constraint:

```math
c=y-g-i-\kappa v.
```

11. Recover the preference parameter:

```math
b=\frac{\omega}{c\sigma-(\sigma-1)\omega n}, \qquad
\lambda=\left(\frac{\sigma b}{\omega}\right)^\sigma.
```

12. NK steady-state values: $`\pi=1`$, $`\pi^\star=1`$, $`D=1`$, $`Y=y`$, $`mc=(\epsilon-1)/\epsilon`$, $`P_F=Ymc/(1-\beta\phi)`$, $`P_Z=Y/(1-\beta\phi)`$, and $`1+r^n=1+r`$.

The active implementation contains a flexible-price duplicate block with `_fe` variables for output-gap construction; that block is `implementation_cross_check` only.

## 7. Timing & Form Conventions

- The model is monthly. Some paper parameters are stated as monthly transformations of quarterly values.
- Employment is predetermined through $`n_{t-1}`$ in the unemployment identity $`u_t=1-n_{t-1}`$; new hires become productive in period $`t`$.
- In the paper notation, the household capital law is $`k_{t+1}=(1-\delta)k_t+i_t(1-\phi_t)`$. The implementation shifts this to Dynare's stock convention as `k = (1-delta)*k(-1)+...`, so production uses `k(-1)`.
- The stochastic discount factor is $`\Lambda_{t,t+1}=\lambda_{t+1}/\lambda_t`$.
- The MMB file is nonlinear and lets Dynare compute the first-order approximation. The paper's log-linear equation for tightness is a diagnostic, not the maintained implementation form.
- The NK Calvo block is visible in the `.mod` but not fully formula-preserved in the paper OCR. It remains `needs_review` against the PDF or a better source.
- Dynare runtime validation: not performed by instruction.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Main equation(s) |
|---|---|---|---|
| Endogenous | `q`, $`q_t`$ | probability a vacancy is filled | (F38) |
| Endogenous | `rk`, $`r_{k,t}`$ | rental rate of capital | (F2) |
| Endogenous | `y`, $`y_t`$ | intermediate output | (F32) |
| Endogenous | `k`, $`k_t`$ | capital stock | (F33) |
| Endogenous | `w`, $`w_t`$ | bargained real wage | (F19) |
| Endogenous | `lambda`, $`\lambda_t`$ | marginal utility of wealth | (F6) |
| Endogenous | `F`, $`F_{n,t}`$ | firm value of marginal worker | (F4), (F5) |
| Endogenous | `n`, $`n_t`$ | employment | (F1) |
| Endogenous | `p`, $`p_t`$ | job-finding probability | (F39) |
| Endogenous | `theta`, $`\theta_t`$ | labor-market tightness | (F40) |
| Endogenous | `u`, $`u_t`$ | unemployment/searchers | (F41) |
| Endogenous | `i`, $`i_t`$ | investment | (F7), (F33) |
| Endogenous | `phi`, $`\phi_t`$ | investment adjustment cost | (F34) |
| Endogenous | `c`, $`c_t`$ | consumption | (F36) |
| Endogenous | `phi_i`, $`\phi_{i,t}`$ | adjustment-cost derivative | (F34) |
| Endogenous | `omega`, $`\omega_t`$ | non-work value | (F11) |
| Endogenous | `H`, $`H_{n,t}`$ | household value of employment | (F9) |
| Endogenous | `w_bar`, $`\overline{w}_t`$ | firm reservation wage | (F17) |
| Endogenous | `w_und`, $`\underline{w}_t`$ | worker reservation wage | (F18) |
| Endogenous | `S`, $`S_{n,t}`$ | total match surplus | (F20), (F24) |
| Endogenous | `tau`, $`\tau_t`$ | lump-sum taxes | (F35) |
| Endogenous | `g`, $`g_t`$ | government spending | (F43) |
| Endogenous | `v`, $`v_t`$ | vacancies | (F1), (F37), (F40) |
| Endogenous | `m`, $`m_t`$ | matches | (F37) |
| Endogenous | `Lambda`, $`\Lambda_{t,t+1}`$ | stochastic discount factor ratio | (F7), (F8) |
| Endogenous | `varphi`, $`\varphi_t`$ | investment shadow value | (F7), (F8) |
| Endogenous | `r`, $`r_t`$ | net real interest rate | (F26) |
| Endogenous | `i_nom`, $`r_t^n`$ | net nominal interest rate | (F25), (F26) |
| Endogenous | `mc`, $`mc_t`$ | real marginal cost / inverse markup | (F23), (F28) |
| Endogenous | `Dis`, $`D_t`$ | price dispersion | (F27) |
| Endogenous | `Y`, $`Y_t`$ | final output | (F32), (F36) |
| Endogenous | `infl`, $`\pi_t`$ | final-goods inflation | (F25), (F31) |
| Endogenous | `inflstar`, $`\pi_t^\star`$ | optimal reset-price inflation | (F30), (F31) |
| Endogenous | `P_F`, $`P_{F,t}`$ | Calvo numerator auxiliary | (F28) |
| Endogenous | `P_Z`, $`P_{Z,t}`$ | Calvo denominator auxiliary | (F29) |
| Endogenous | `_fe` variables | flexible-price benchmark counterparts | (F42) |
| Endogenous | `outputgap` | final output minus flexible-price output | (F42) |
| Exogenous | `e`, $`\varepsilon_{g,t}`$ | government spending innovation | (F43) |
| Exogenous | `e_i`, $`\varepsilon_{i,t}`$ | monetary policy innovation, declared but inactive | (F44) |
| Parameter | `alpha`, $`\alpha`$ | capital share | (F2), (F32) |
| Parameter | `beta`, $`\beta`$ | discount factor | (F3), (F7), (F8) |
| Parameter | `rho`, $`\rho`$ | job survival probability | (F1), (F20) |
| Parameter | `gamma_m`, $`\gamma_m`$ | matching efficiency | (F37)-(F39) |
| Parameter | `gamma`, $`\gamma`$ | matching elasticity | (F37)-(F39) |
| Parameter | `delta`, $`\delta`$ | depreciation | (F33) |
| Parameter | `eta_k`, $`\eta_k`$ | investment adjustment cost curvature | (F34) |
| Parameter | `sigma`, $`\sigma`$ | complementarity / intertemporal parameter | (F6), (F10), (F11) |
| Parameter | `eta`, $`\eta`$ | worker bargaining power | (F12), (F20) |
| Parameter | `b` | relative disutility/non-work preference parameter | (F6), (F11) |
| Parameter | `kappa`, $`\kappa`$ | vacancy posting cost | (F3), (F21), (F36) |
| Parameter | `rho_g`, $`\rho_g`$ | government spending persistence | (F43) |
| Parameter | `rho_i`, $`\rho_i`$ | interest-rate smoothing in implementation | (F25) cross-check |
| Parameter | `kappa_pi`, $`\phi_\pi`$ | Taylor inflation coefficient | (F25) |
| Parameter | `kappa_y`, $`\phi_y`$ | Taylor output-growth coefficient | (F25) |
| Parameter | `epsilon`, $`\epsilon`$ | substitution elasticity across retail varieties | (F27)-(F31) |
| Parameter | `gam`, $`\phi`$ | Calvo no-reset probability | (F27)-(F31) |
| Parameter | `gam_P`, $`\gamma_P`$ | indexation/backward-looking price setting parameter | (F27)-(F31) |
| Parameter | steady-state suffix `_ss` | implementation steady-state values | Section 6 |
