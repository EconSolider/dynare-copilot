# NK_GLSV07 - Derivation (Optimization Problems + First-Order Conditions)

> This derivation is a source-backed private archive draft for later Dynare work. Runtime validation was not performed.

Provenance: `NK_GLSV07`, Galí, Jordi; López-Salido, J. David; Vallés, Javier, "Understanding the effects of government spending on consumption", Journal of the European Economic Association 5(1), 227-270, 2007, DOI `10.1162/jeea.2007.5.1.227`. Source Markdown: `raw/mmb_mineru/runs/nk_glsv07__understanding_the_effects_of_government_spending_on_consumption__47e78a28/full.md`; raw PDF checked for existence only: `raw/mmb_papers/Understanding the effects of government spending on consumption.pdf`; MinerU run id `47e78a28-668e-4d2c-a7ff-9274c85dd958`. Implementation cross-check only: `.agents/skills/dynare-copilot/references/examples/NK_GLSV07_rep.mod`.

## 1. Model Overview

- **Model**: New Keynesian fiscal model with rule-of-thumb consumers, sticky prices, capital accumulation, government debt, and a government-spending shock.
- **MMB variant**: `NK_GLSV07` corresponds to the imperfectly competitive labor market implementation (`NK_GLSV07_iclm`) in the Rep-MMB example. The paper also discusses a perfectly competitive labor market variant.
- **Agents**: optimizing Ricardian households, rule-of-thumb households, final-good firm, monopolistically competitive intermediate firms with Calvo price setting, central bank, and fiscal authority.
- **Experiment**: first-order stochastic simulation of the response to a government-spending innovation.
- **Form**: log-linear/model(linear). Lower-case variables are log deviations or steady-state-normalized deviations around a zero-inflation steady state. The archive entry uses the paper-side reduced imperfect-labor-market system in Appendix C because it matches the available MMB implementation.
- **Review status**: `needs_review`. The formulas are taken from MinerU OCR Markdown and the `.mod` file was used only to confirm equation coverage and variable naming.

## 2. Optimization Problems

### 2.1 Optimizing Households

A fraction $`1-\lambda`$ of households trades state-contingent claims, bonds, and capital. A representative optimizing household solves

```math
\max_{\{C_t^o,N_t^o,I_t^o,K_{t+1}^o,B_{t+1}^o\}} E_0\sum_{t=0}^{\infty}\beta^t U(C_t^o,N_t^o)
```

subject to

```math
P_t(C_t^o+I_t^o)+R_t^{-1}B_{t+1}^o
=W_tP_tN_t^o+R_t^kP_tK_t^o+B_t^o+D_t^o-P_tT_t^o,
```

and

```math
K_{t+1}^o=(1-\delta)K_t^o+\phi\!\left(\frac{I_t^o}{K_t^o}\right)K_t^o.
```

The period utility specialization used in the paper is

```math
U(C,N)=\log C-\frac{N^{1+\varphi}}{1+\varphi}.
```

### 2.2 Rule-of-Thumb Households

A fraction $`\lambda`$ of households does not trade assets and consumes current labor income net of taxes:

```math
P_tC_t^r=W_tP_tN_t^r-P_tT_t^r.
```

Under competitive labor markets these households satisfy the same intratemporal condition as optimizing households. Under the imperfectly competitive labor market variant used by `NK_GLSV07`, hours are demand-determined and a wage schedule replaces household labor supply.

### 2.3 Firms

The final-good firm aggregates differentiated intermediate goods:

```math
Y_t=\left(\int_0^1 X_t(j)^{\frac{\varepsilon_p-1}{\varepsilon_p}}dj\right)^{\frac{\varepsilon_p}{\varepsilon_p-1}},
```

which implies demand

```math
X_t(j)=\left(\frac{P_t(j)}{P_t}\right)^{-\varepsilon_p}Y_t.
```

Intermediate producers use

```math
Y_t(j)=K_t(j)^{\alpha}N_t(j)^{1-\alpha}.
```

A price-resetting firm chooses $`P_t^{\ast}`$ to maximize expected discounted profits subject to demand under Calvo non-adjustment probability $`\theta`$:

```math
\max_{P_t^{\ast}} E_t\sum_{k=0}^{\infty}\theta^k \Lambda_{t,t+k}Y_{t+k}(j)\left(\frac{P_t^{\ast}}{P_{t+k}}-MC_{t+k}\right).
```

### 2.4 Monetary and Fiscal Authorities

The central bank sets a simple nominal interest-rate rule. The fiscal authority satisfies the government budget constraint, sets taxes as a function of debt and government purchases, and government purchases follow an AR(1) process.

## 3. First-Order Conditions

The paper derives a structural model and then works with log-linear equilibrium conditions. For the MMB imperfect-labor-market reduced system, the operative equilibrium conditions are the following.

**(F1) Optimizing-household nominal Euler condition**

```math
1=R_tE_t\left\{\Lambda_{t,t+1}\frac{P_t}{P_{t+1}}\right\}.
```

**(F2) Capital value equation**

```math
Q_t=E_t\left\{\Lambda_{t,t+1}\left[R_{t+1}^k+Q_{t+1}\left((1-\delta)+\phi_{t+1}-\frac{I_{t+1}^o}{K_{t+1}^o}\phi'_{t+1}\right)\right]\right\}.
```

**(F3) Investment-capital condition**

```math
Q_t=\frac{1}{\phi'\!\left(I_t^o/K_t^o\right)}.
```

**(F4) Aggregate consumption Euler equation, imperfect labor market**

```math
c_t=E_t\{c_{t+1}\}-\frac{1}{\tilde{\sigma}}\left(r_t-E_t\{\pi_{t+1}\}\right)
-\Theta_nE_t\{\Delta n_{t+1}\}+\Theta_tE_t\{\Delta t_{t+1}^r\},
```

with

```math
\frac{1}{\tilde{\sigma}}=\gamma_c\Phi(1-\lambda)\mu^p,\quad
\Theta_n=\lambda\Phi(1-\alpha)(1+\varphi),\quad
\Theta_t=\lambda\Phi\mu^p,\quad
\Phi=(\gamma_c\mu^p-\lambda(1-\alpha))^{-1}.
```

**(F5) Wage schedule for the imperfect labor market variant**

```math
w_t=c_t+\varphi n_t.
```

**(F6) New Keynesian Phillips curve in reduced variables**

```math
\pi_t=\beta E_t\{\pi_{t+1}\}+\lambda_p c_t-\alpha\lambda_p k_t+(\alpha+\varphi)\lambda_p n_t,
```

where $`\lambda_p=(1-\beta\theta)(1-\theta)/\theta`$.

**(F7) Reduced aggregate Euler equation after substituting policy rules**

```math
c_t-\Theta_n n_t+\frac{\phi_{\pi}}{\tilde{\sigma}}\pi_t
=E_t\{c_{t+1}\}+\frac{1}{\tilde{\sigma}}E_t\{\pi_{t+1}\}
-\Theta_nE_t\{n_{t+1}\}
+\Theta_t\phi_b\Delta b_{t+1}
+\Theta_t\phi_g(\rho_g-1)g_t.
```

**(F8) Investment and Tobin's-q reduced condition**

```math
\begin{aligned}
&(1-\alpha)n_t-\gamma_c c_t-(1-\tilde{\gamma}_c-\alpha)k_t
+(1-\tilde{\gamma}_c)\eta\phi_{\pi}\pi_t \\
&=[\omega(1+\varphi)+\beta(1-\alpha)]E_t\{n_{t+1}\}
+(\omega-\beta\gamma_c)E_t\{c_{t+1}\}
-[\omega+\beta(1-\tilde{\gamma}_c-\alpha)]k_{t+1} \\
&\quad +(1-\tilde{\gamma}_c)\eta E_t\{\pi_{t+1}\}+(1-\beta\rho_g)g_t,
\end{aligned}
```

where $`\tilde{\gamma}_c=\gamma_c+\gamma_g`$ and $`\omega=\eta[1-\beta(1-\delta)](1-\tilde{\gamma}_c)`$.

## 4. Market Clearing & Identities

**(F9) Aggregate definitions for consumption and hours**

```math
C_t=\lambda C_t^r+(1-\lambda)C_t^o,\qquad
N_t=\lambda N_t^r+(1-\lambda)N_t^o.
```

**(F10) Aggregate investment and capital**

```math
I_t=(1-\lambda)I_t^o,\qquad K_t=(1-\lambda)K_t^o.
```

**(F11) Log-linear production function**

```math
y_t=(1-\alpha)n_t+\alpha k_t.
```

**(F12) Goods-market clearing**

```math
y_t=\gamma_c c_t+\gamma_i i_t+g_t.
```

**(F13) Reduced capital accumulation equation**

```math
k_{t+1}=\left(1-\delta+\frac{\delta\alpha}{1-\tilde{\gamma}_c}\right)k_t
+\frac{\delta(1-\alpha)}{1-\tilde{\gamma}_c}n_t
-\frac{\delta\gamma_c}{1-\tilde{\gamma}_c}c_t
-\frac{\delta}{1-\tilde{\gamma}_c}g_t.
```

**(F14) Real marginal-cost / markup relation used in the Phillips curve**

```math
\mu_t=y_t-c_t-(1+\varphi)n_t.
```

**(F15) Tax rule**

```math
t_t=\phi_b b_t+\phi_g g_t.
```

**(F16) Debt accumulation**

```math
b_{t+1}=(1+\rho)(1-\phi_b)b_t+(1+\rho)(1-\phi_g)g_t.
```

## 5. Exogenous Processes

**(F17) Government spending shock**

```math
g_t=\rho_g g_{t-1}+\varepsilon_t.
```

The MMB example uses one exogenous innovation, `e_g`, and computes IRFs to a fiscal spending shock. Monetary policy has no separate shock in this implementation.

## 6. Steady-State Solution

The model is solved in log deviations or steady-state-normalized deviations, so all dynamic variables in the MMB implementation initialize at zero:

```math
n=c=\pi=k=b=g=y=w=t=i=0.
```

The paper's steady-state relationships used to define the reduced coefficients include:

```math
\rho=\beta^{-1}-1,
```

```math
\gamma_c=(1-\gamma_g)-\frac{\delta\alpha}{(\rho+\delta)\mu^p},
```

```math
\gamma_i=1-\gamma_c-\gamma_g,\qquad \tilde{\gamma}_c=\gamma_c+\gamma_g.
```

The reduced-system coefficients are then computed from calibrated structural parameters:

```math
\lambda_p=\frac{(1-\beta\theta)(1-\theta)}{\theta},
```

```math
\Phi=(\gamma_c\mu^p-\lambda(1-\alpha))^{-1},\quad
\frac{1}{\tilde{\sigma}}=\gamma_c\Phi(1-\lambda)\mu^p,
```

```math
\Theta_t=\lambda\Phi\mu^p,\quad
\Theta_n=\lambda\Phi(1-\alpha)(1+\varphi),\quad
\omega=\eta[1-\beta(1-\delta)](1-\tilde{\gamma}_c).
```

The source paper calibrates quarterly $`\beta=0.99`$, $`\delta=0.025`$, $`\alpha=1/3`$, baseline $`\lambda=1/2`$, $`\theta=0.75`$, $`\varphi=0.2`$, $`\eta=1`$, $`\phi_\pi=1.5`$, $`\rho_g=0.9`$, $`\phi_g=0.10`$, $`\phi_b=0.33`$, and $`\gamma_g=0.2`$. The implementation cross-check uses `alpha=0.33` and `my_p=1.2`; the paper's notation describes $`\mu^p`$ as the gross price markup while one sentence refers to a markup of 0.2, so this entry keeps the implementation value as a cross-check and marks the markup convention as `needs_review`.

## 7. Timing & Form Conventions

- The operative MMB file is `model(linear)` in substance: all endogenous variables are deviations around steady state.
- In the paper's timing, capital chosen by optimizing households evolves as $`K_{t+1}`$ from period-$`t`$ investment; the MMB example declares `k` and `b` as predetermined variables.
- The reduced state vector in Appendix C is $`\mathbf{x}_t=(n_t,c_t,\pi_t,k_t,b_t,g_{t-1})'`$.
- Inflation $`\pi_t`$ is a log deviation around zero inflation.
- Government spending $`g_t`$, taxes $`t_t`$, and debt $`b_t`$ are normalized by steady-state output.
- The implementation uses the imperfectly competitive labor market reduced equation; the competitive-labor-market aggregate Euler equation is documented in the paper but is not the selected `NK_GLSV07` variant.
- Runtime validation was not performed.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Equation reference |
|---|---|---|---|
| Endogenous | `n`, $`n_t`$ | aggregate hours | (F5), (F7), (F8), (F11), (F13) |
| Endogenous | `c`, $`c_t`$ | aggregate consumption | (F4), (F7), (F8), (F12), (F13) |
| Endogenous | `pi`, $`\pi_t`$ | inflation | (F6), (F7), (F8) |
| Endogenous | `k`, $`k_t`$ | capital stock deviation | (F8), (F11), (F13) |
| Endogenous | `b`, $`b_t`$ | government debt deviation | (F16) |
| Endogenous | `g`, $`g_t`$ | government spending deviation | (F17) |
| Endogenous | `y`, $`y_t`$ | output | (F11), (F12) |
| Endogenous | `w`, $`w_t`$ | real wage | (F5) |
| Endogenous | `t`, $`t_t`$ | taxes | (F15) |
| Endogenous | `i`, $`i_t`$ | investment | (F12), (F13), implementation identity |
| Exogenous | `e_g`, $`\varepsilon_t`$ | government spending innovation | (F17) |
| Parameter | `alpha`, $`\alpha`$ | capital share | (F6), (F8), (F11), (F13) |
| Parameter | `beta`, $`\beta`$ | discount factor | (F1), (F6), (F8) |
| Parameter | `delta`, $`\delta`$ | depreciation rate | (F2), (F13) |
| Parameter | `eta`, $`\eta`$ | investment elasticity with respect to $`q`$ | (F8) |
| Parameter | `theta`, $`\theta`$ | Calvo non-adjustment probability | (F6), steady-state coefficients |
| Parameter | `lambda`, $`\lambda`$ | rule-of-thumb household share | (F4), (F9), coefficients |
| Parameter | `lambda_p`, $`\lambda_p`$ | Phillips-curve slope | (F6) |
| Parameter | `my_p`, $`\mu^p`$ | price-markup convention, needs_review | (F4), (F14), steady-state coefficients |
| Parameter | `rho_g`, $`\rho_g`$ | government spending persistence | (F7), (F17) |
| Parameter | `phi_b`, $`\phi_b`$ | tax response to debt | (F7), (F15), (F16) |
| Parameter | `phi_g`, $`\phi_g`$ | tax response to spending | (F7), (F15), (F16) |
| Parameter | `phi_pi`, $`\phi_\pi`$ | monetary response to inflation | (F7), (F8) |
| Parameter | `psi`, $`\varphi`$ | wage-hours elasticity / labor disutility curvature | (F5), (F6), (F8) |
| Parameter | `sigma_bar`, $`\tilde{\sigma}`$ | aggregate Euler coefficient | (F4), (F7) |
| Parameter | `theta_n`, $`\Theta_n`$ | hours coefficient in aggregate Euler equation | (F4), (F7) |
| Parameter | `theta_tau`, $`\Theta_t`$ | tax coefficient in aggregate Euler equation | (F4), (F7) |
| Parameter | `omega`, $`\omega`$ | investment block composite coefficient | (F8) |
