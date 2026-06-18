# NK_GM16 - Derivation (Optimization Problems + First-Order Conditions)

> Private archive draft. Runtime validation was not performed. Status: `needs_review` because the entry relies on MinerU OCR Markdown and has not been source-level checked against the PDF beyond path existence.

## 1. Model Overview

- **Model ID**: `NK_GM16`
- **Paper**: Jordi Gali and Tommaso Monacelli (2016), "Understanding the Gains from Wage Flexibility: The Exchange Rate Connection," *American Economic Review*, 106(12), 3829-3868.
- **DOI**: `10.1257/aer.20131658`
- **Core economy**: small open New Keynesian economy with sticky domestic prices, sticky nominal wages, complete international financial markets, law of one price, export demand, no capital accumulation in the baseline, and exogenous domestic, technology, payroll-tax, export, and world-interest-rate disturbances.
- **MMB implementation cross-check**: `.agents/skills/dynare-copilot/references/examples/NK_GM16_rep.mod` implements the currency-union regime with `model(linear)` and `e = 0`.
- **Model form**: log-linear equilibrium system around a zero-inflation symmetric steady state. Lowercase variables are log deviations from steady state; gap variables are deviations from flexible-price-and-wage natural allocations.
- **Policy regimes**: the paper discusses strict domestic inflation targeting (`\pi_{H,t}=0`) and currency union / hard peg (`e_t=0`). The MMB replication file activates the currency-union regime.
- **Provenance sources**: source Markdown `raw/mmb_mineru/runs/nk_gm16__understanding_the_gains_from_wage_flexibility_the_exchange_rate_connecti__f3573fbb/full.md`; raw PDF `raw/mmb_papers/Understanding the Gains from Wage Flexibility- The Exchange Rate Connection.pdf`; no appendix-normalization file was found.

## 2. Optimization Problems

### 2.1 Representative Household

The household chooses consumption, state-contingent asset holdings, and wage-reset decisions for differentiated labor types. Period utility is logarithmic in aggregate consumption and separable in occupation-specific labor:

```math
E_0\sum_{t=0}^{\infty}\beta^t
\left(\log C_t-\frac{1}{1+\varphi}\int_0^1 \mathcal{N}_t(j)^{1+\varphi}dj\right)Z_t.
```

Consumption combines home and imported goods:

```math
C_t=\Upsilon C_{H,t}^{1-\nu}C_{F,t}^{\nu}.
```

The nominal budget constraint is:

```math
\int_0^1 P_{H,t}(i)C_{H,t}(i)di+P_{F,t}C_{F,t}
+E_t\{Q_{t,t+1}D_{t+1}\}
\le D_t+\int_0^1 W_t(j)\mathcal{N}_t(j)dj-T_t.
```

For wage setting, a labor type that can reset in period `t` chooses a wage `\bar W_t` subject to future demand for that labor type:

```math
\mathcal{N}_{t+k|t}=\left(\frac{\bar W_t}{W_{t+k}}\right)^{-\epsilon_w}N_{t+k}.
```

### 2.2 Domestic Producers

Domestic firm `i` produces with differentiated labor services:

```math
Y_t(i)=A_tN_t(i)^{1-\alpha},
\qquad
N_t(i)=\left(\int_0^1N_t(i,j)^{\frac{\epsilon_w-1}{\epsilon_w}}dj\right)^{\frac{\epsilon_w}{\epsilon_w-1}}.
```

Firms minimize labor cost subject to the CES labor aggregator and, when allowed to reset prices, choose `\bar P_{H,t}` to maximize discounted nominal profits subject to demand for home varieties:

```math
Y_{t+k|t}=
\left(\frac{\bar P_{H,t}}{P_{H,t+k}}\right)^{-\epsilon_p}
\left(C_{H,t+k}+X_{t+k}\right).
```

### 2.3 Foreign Demand and Asset Pricing Blocks

Complete international financial markets imply a risk-sharing condition linking domestic consumption to world consumption, the real exchange rate, and relative preference shocks. Export demand is an exogenous-demand block rather than an optimizing domestic agent:

```math
X_t=\nu S_tY_t^{\ast}.
```

The foreign block supplies two independent shocks: `z_{1,t}^*`, which moves world output/export demand, and `z_{2,t}^*`, which moves the world real interest rate.

## 3. First-Order Conditions

The numbered conditions below represent the baseline log-linear MMB system and its derivational components. They are continuous across sections 3-5.

- **(F1) Domestic-goods demand**:

```math
C_{H,t}(i)=\left(\frac{P_{H,t}(i)}{P_{H,t}}\right)^{-\epsilon_p}C_{H,t}.
```

- **(F2) Home/import allocation**:

```math
P_{H,t}C_{H,t}=(1-\nu)P_tC_t,\qquad P_{F,t}C_{F,t}=\nu P_tC_t.
```

- **(F3) Domestic Euler equation**:

```math
1=\beta(1+i_t)E_t\left[
\left(\frac{C_t}{C_{t+1}}\right)
\left(\frac{Z_{t+1}}{Z_t}\right)
\left(\frac{P_t}{P_{t+1}}\right)
\right].
```

- **(F4) Foreign-bond Euler equation / UIP source**:

```math
1=\beta(1+i_t^{\ast})E_t\left[
\left(\frac{C_t}{C_{t+1}}\right)
\left(\frac{Z_{t+1}}{Z_t}\right)
\left(\frac{P_t}{P_{t+1}}\right)
\left(\frac{\mathcal{E}_{t+1}}{\mathcal{E}_t}\right)
\right].
```

- **(F5) Log-linear uncovered interest parity**:

```math
i_t=i_t^{\ast}+E_t\{\Delta e_{t+1}\}.
```

- **(F6) Complete-markets risk sharing**:

```math
C_t=C_t^{\ast}\mathcal{Q}_t\left(\frac{Z_t}{Z_t^{\ast}}\right).
```

- **(F7) Reset wage optimality**:

```math
\sum_{k=0}^{\infty}(\beta\theta_w)^kE_t\left\{
N_{t+k|t}U_{c,t+k}
\left(\frac{\bar W_t}{P_{t+k}}-\mathcal{M}^w MRS_{t+k|t}\right)
\right\}=0.
```

- **(F8) Log reset wage equation**:

```math
\bar w_t=\mu^w+(1-\beta\theta_w)\sum_{k=0}^{\infty}(\beta\theta_w)^k
E_t\{mrs_{t+k|t}+p_{t+k}\}.
```

- **(F9) Average wage index**:

```math
w_t=\theta_ww_{t-1}+(1-\theta_w)\bar w_t.
```

- **(F10) Wage Phillips curve in markup form**:

```math
\pi_t^w=\beta E_t\{\pi_{t+1}^w\}-\lambda_w(\mu_t^w-\mu^w).
```

- **(F11) Labor demand by type**:

```math
\mathcal{N}_t(j)=\left(\frac{W_t(j)}{W_t}\right)^{-\epsilon_w}N_t.
```

- **(F12) Reset price optimality**:

```math
\sum_{k=0}^{\infty}\theta_p^kE_t\left\{
Q_{t,t+k}Y_{t+k|t}
\left(\bar P_{H,t}-\mathcal{M}^p\Psi_{t+k|t}\right)
\right\}=0.
```

- **(F13) Log reset price equation**:

```math
\bar p_{H,t}=\mu^p+(1-\beta\theta_p)\sum_{k=0}^{\infty}(\beta\theta_p)^k
E_t\{\psi_{t+k|t}\}.
```

- **(F14) Average domestic price index**:

```math
p_{H,t}=\theta_pp_{H,t-1}+(1-\theta_p)\bar p_{H,t}.
```

- **(F15) Domestic-price Phillips curve in markup form**:

```math
\pi_{H,t}^p=\beta E_t\{\pi_{H,t+1}^p\}-\lambda_p(\mu_t^p-\mu^p).
```

## 4. Market Clearing & Identities

- **(F16) Domestic goods market clearing, log-linearized**:

```math
y_t=(1-\nu)c_t+\nu(2-\nu)s_t+\nu z_{1,t}^{\ast}.
```

- **(F17) Risk-sharing demand relation used in the MMB system**:

```math
c_t=(1-\nu)s_t+z_t-z_{2,t}^{\ast}.
```

- **(F18) Consumption Euler equation, log-linearized**:

```math
c_t=E_t\{c_{t+1}\}-\left(i_t-E_t\{\pi_{t+1}\}\right)+(1-\rho_z)z_t.
```

- **(F19) Terms of trade definition**:

```math
s_t\equiv e_t-p_{H,t}.
```

- **(F20) Production/employment relation**:

```math
n_t=\frac{1}{1-\alpha}(y_t-a_t).
```

- **(F21) Domestic-price Phillips curve in gap form**:

```math
\pi_{H,t}^p=\beta E_t\{\pi_{H,t+1}^p\}
+\frac{\lambda_p\alpha}{1-\alpha}\tilde y_t
+\lambda_p\tilde\omega_t+\lambda_p\nu\tilde s_t+\lambda_p\tau_t.
```

- **(F22) Domestic price inflation definition**:

```math
\pi_{H,t}^p\equiv p_{H,t}-p_{H,t-1}.
```

- **(F23) CPI price level**:

```math
p_t=p_{H,t}+\nu s_t.
```

- **(F24) CPI inflation definition**:

```math
\pi_t^p\equiv p_t-p_{t-1}.
```

- **(F25) Wage Phillips curve in gap form**:

```math
\pi_t^w=\beta E_t\{\pi_{t+1}^w\}
+\frac{\lambda_w\varphi}{1-\alpha}\tilde y_t
+\lambda_w\tilde c_t-\lambda_w\tilde\omega_t.
```

- **(F26) Wage inflation definition**:

```math
\pi_t^w\equiv w_t-w_{t-1}.
```

- **(F27) Real consumption wage**:

```math
\omega_t\equiv w_t-p_t.
```

- **(F28) Output gap**:

```math
\tilde y_t=y_t-y_t^n.
```

- **(F29) Consumption gap**:

```math
\tilde c_t=c_t-c_t^n.
```

- **(F30) Terms-of-trade gap**:

```math
\tilde s_t=s_t-s_t^n.
```

- **(F31) Real-wage gap**:

```math
\tilde\omega_t=\omega_t-\omega_t^n.
```

- **(F32) Policy regime used by the MMB replication: currency union / hard peg**:

```math
e_t=0.
```

- **(F33) Alternative strict domestic-inflation-targeting regime discussed in the paper**:

```math
\pi_{H,t}=0.
```

## 5. Exogenous Processes

- **(F34) Domestic demand/preference shock**:

```math
z_t=\rho_zz_{t-1}+\varepsilon_t^z.
```

- **(F35) Domestic technology shock**:

```math
a_t=\rho_aa_{t-1}+\varepsilon_t^a.
```

- **(F36) Foreign export-demand shock**:

```math
z_{1,t}^{\ast}=\rho_1^{\ast}z_{1,t-1}^{\ast}+\varepsilon_{1,t}^{\ast}.
```

- **(F37) Foreign world-interest-rate shock**:

```math
z_{2,t}^{\ast}=\rho_2^{\ast}z_{2,t-1}^{\ast}+\varepsilon_{2,t}^{\ast}.
```

- **(F38) Payroll-tax shock, as implemented in MMB with sign chosen for IRFs**:

```math
\tau_t=\rho_\tau\tau_{t-1}-\varepsilon_t^\tau.
```

- **(F39) World output relation for export shocks**:

```math
Y_t^{\ast}=Z_{1,t}^{\ast}.
```

- **(F40) World interest rate relation**:

```math
i_t^{\ast}=\rho+(1-\rho_2^{\ast})z_{2,t}^{\ast}.
```

## 6. Steady-State Solution

The MMB model is linearized around a zero-inflation symmetric steady state. All log-deviation endogenous variables and exogenous shocks are zero in deterministic steady state:

```math
y=c=s=z=z_1^{\ast}=z_2^{\ast}=i=\pi=p=n=a=\tau=\omega=\pi^w=e=0.
```

The source paper uses a symmetric steady state with:

```math
S=1,\qquad C=C^{\ast}=Y^{\ast},\qquad X=\nu Y^{\ast},\qquad C_F=\nu C,\qquad Y=C.
```

Natural employment, ignoring constants, is:

```math
n_t^n=\frac{\nu}{1+\varphi}(z_{1,t}^{\ast}+z_{2,t}^{\ast}-z_t)-\frac{1}{1+\varphi}\tau_t.
```

The natural allocation used to define gaps is:

```math
y_t^n=a_t+(1-\alpha)n_t^n,
```

```math
s_t^n=a_t-z_t+z_{2,t}^{\ast}-\tau_t-(\alpha+\varphi)n_t^n,
```

```math
c_t^n=z_t+(1-\nu)s_t^n-z_{2,t}^{\ast},
```

```math
\omega_t^n=a_t-\alpha n_t^n-\tau_t-\nu s_t^n.
```

The complete-source appendix includes constants involving desired markups in the natural allocation. The MMB implementation drops constants consistently with a log-deviation `model(linear)` representation.

## 7. Timing & Form Conventions

- **Timing**: no capital stock appears in the baseline MMB entry. Inflation, wage inflation, exchange-rate changes, and price levels use one-period lag definitions.
- **Expectations**: Euler and Phillips-curve terms use `E_t` of period `t+1` variables; the MMB file writes these as `(+1)`.
- **Open-economy prices**: the terms of trade is `s_t=e_t-p_{H,t}` and CPI is `p_t=p_{H,t}+\nu s_t` in log-linear form.
- **Policy regime**: `NK_GM16_rep.mod` sets `e=0`, i.e. the currency-union/hard-peg case. The paper also studies domestic inflation targeting with `\pi_{H,t}=0`.
- **Form**: `model(linear)`, variables in log deviations from steady state. Runtime validation was not performed for this archive entry.
- **OCR status**: the MinerU Markdown is readable for the baseline model and appendix, but some appendix text around constants and marginal-cost prose is noisy. Equations above were normalized from the clean main-text system and appendix conditions; the entry remains `needs_review`.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Main equation(s) |
|---|---|---|---|
| Endogenous | `y`, $`y_t`$ | output | (F16), (F28) |
| Endogenous | `c`, $`c_t`$ | consumption | (F17), (F18), (F29) |
| Endogenous | `s`, $`s_t`$ | terms of trade | (F19), (F30) |
| Endogenous | `i`, $`i_t`$ | nominal interest rate | (F18), (F32), (F40) |
| Endogenous | `dpc`, $`\pi_t^p`$ | CPI inflation | (F24) |
| Endogenous | `e`, $`e_t`$ | nominal exchange rate | (F19), (F32) |
| Endogenous | `p`, $`p_{H,t}`$ in MMB code | domestic price level | (F19), (F22) |
| Endogenous | `pc`, $`p_t`$ | CPI price level | (F23), (F24) |
| Endogenous | `n`, $`n_t`$ | employment | (F20) |
| Endogenous | `a`, $`a_t`$ | technology state | (F35) |
| Endogenous | `dp`, $`\pi_{H,t}^p`$ | domestic price inflation | (F21), (F22) |
| Endogenous | `t`, $`\tau_t`$ | payroll-tax state | (F38) |
| Endogenous | `wp`, $`\omega_t`$ | real consumption wage | (F27), (F31) |
| Endogenous | `dw`, $`\pi_t^w`$ | wage inflation | (F25), (F26) |
| Endogenous | `w`, $`w_t`$ | nominal wage | (F26), (F27) |
| Endogenous | `r` | ex ante real rate in code | (F18), implementation identity |
| Endogenous | `de` | exchange-rate change | price/exchange-rate identity |
| Endogenous | `ygap`, `cgap`, `sgap`, `wgap`, `ngap` | gaps from natural allocation | (F28)-(F31) |
| Endogenous | `yn`, `cn`, `sn`, `nn`, `wpn` | natural values | steady-state/natural allocation block |
| Endogenous | `z`, $`z_t`$ | domestic preference state | (F34) |
| Endogenous | `zx1`, $`z_{1,t}^{\ast}`$ | export-demand state | (F36), (F39) |
| Endogenous | `zx2`, $`z_{2,t}^{\ast}`$ | world-interest-rate state | (F37), (F40) |
| Exogenous | `ez`, `ea`, `ezx1`, `ezx2`, `et` | innovations to preference, technology, export, world-rate, and tax processes | (F34)-(F38) |
| Parameter | `bet`, $`\beta`$ | discount factor | (F3), (F10), (F15), (F25) |
| Parameter | `phi`, $`\varphi`$ | curvature of labor disutility | (F25), natural allocation |
| Parameter | `epsp`, $`\epsilon_p`$ | goods substitution elasticity | (F1), (F12)-(F15) |
| Parameter | `epsw`, $`\epsilon_w`$ | labor substitution elasticity | (F7)-(F11) |
| Parameter | `alf`, $`\alpha`$ | decreasing returns parameter in labor production | (F20), (F21), natural allocation |
| Parameter | `thep`, $`\theta_p`$ | Calvo price rigidity | (F12)-(F15) |
| Parameter | `thew`, $`\theta_w`$ | Calvo wage rigidity | (F7)-(F10), (F25) |
| Parameter | `nu`, $`\nu`$ | openness | (F16), (F17), (F21), (F23), natural allocation |
| Parameter | `lamp`, $`\lambda_p`$ | slope of price Phillips curve | (F15), (F21) |
| Parameter | `lamw`, $`\lambda_w`$ | slope of wage Phillips curve | (F10), (F25) |
| Parameter | `rhoa`, `rhoz`, `rhot`, `rhozx1`, `rhozx2` | shock persistence parameters | (F34)-(F38) |

Implementation cross-check notes: the MMB `.mod` also defines graph scaling variables `ngraph`, `igraph`, `rgraph`, and `sgraph`, which are reporting transformations rather than independent model equations.
