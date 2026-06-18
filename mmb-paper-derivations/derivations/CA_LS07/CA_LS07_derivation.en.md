# CA_LS07 - Derivation (optimization problems + first-order conditions)

Source-backed first-pass derivation for `CA_LS07`. Status: `needs_review`.

Provenance: Lubik and Schorfheide (2007), "Do central banks respond to exchange rate movements? A structural investigation", Journal of Monetary Economics 54(4), 1069-1087, DOI `10.1016/j.jmoneco.2006.01.009`. Primary Markdown source: `raw/mmb_mineru/runs/ca_ls07__do_central_banks_respond_to_exchange_rate_movements_a_structural_investi__075fd116/full.md`. Raw PDF path checked: `raw/mmb_papers/Do central banks respond to exchange rate movements? A structural investigation.pdf`. MinerU run id: `075fd116-e951-48af-9644-dfddec2c1ac6`.

## 1. Model Overview

- **Model**: `CA_LS07`, the Canada implementation of Lubik and Schorfheide's small-scale structural small-open-economy New Keynesian model.
- **Purpose**: estimate whether the Bank of Canada reacts to nominal exchange-rate depreciation in a Taylor-type monetary policy rule.
- **Agents and blocks**: optimizing households imply an open-economy IS curve; domestic firms with nominal rigidity imply an open-economy Phillips curve; monetary policy follows an interest-rate rule; the CPI links domestic inflation, nominal depreciation, terms-of-trade growth, and world inflation under relative PPP; terms-of-trade growth, technology growth, world output, and world inflation are exogenous processes in the implemented specification.
- **Model form**: linear rational expectations model. The implementation cross-check uses `model(linear)`, and all real variables are in percentage deviations from the non-stationary technology process.
- **Country-specific calibration / posterior means used by the MMB replication**: for Canada, the implementation cross-check reports `tau=0.31`, `alfa=0.11`, `rhoz=0.42`, `rss=2.52`, `kappa=0.32`, `rhoR=0.69`, `psi1=1.3`, `psi2=0.23`, `psi3=0.14`, `rhoq=0.31`, `rhoy_star=0.97`, and `rhopi_star=0.46`.

## 2. Optimization Problems

The paper presents the final linear structural equations rather than the full primitive household and firm problems. The derivation points are therefore source-backed at the reduced-form equilibrium level:

- **Households** choose intertemporal consumption in a small open economy. Their Euler equation, after expressing real variables relative to the stochastic technology trend and using the CPI-based real rate, yields the open-economy IS curve in (F1).
- **Domestic firms** set prices with nominal rigidity. Optimal price setting yields the open-economy Phillips curve in (F2). The slope parameter `\kappa` is treated as structural in the estimated system.
- **Monetary authority** sets the nominal interest-rate deviation by reacting to CPI inflation, output, and nominal exchange-rate depreciation with interest-rate smoothing, shown in (F3).
- **External sector / small-open-economy closure** uses relative PPP for CPI inflation and treats terms-of-trade growth as exogenous in the estimated implementation. The paper also displays the fully structural terms-of-trade market-clearing relation, but explicitly explains that the estimated model replaces it with a terms-of-trade shock process.

Primitive utility, production, and Calvo reset-price expressions are not reproduced in the Markdown source; deriving them from Galí-Monacelli primitives is deferred. `needs_review`: the extraction below should be checked against the published PDF or original author code before being treated as final mathematical documentation.

## 3. First-Order Conditions

- **(F1) Open-economy IS curve** from the consumption Euler equation:

```math
y_t = E_t y_{t+1}
- \left[\tau + \alpha(2-\alpha)(1-\tau)\right]\left(R_t - E_t\pi_{t+1}\right)
- \rho_z z_t
- \alpha\left[\tau + \alpha(2-\alpha)(1-\tau)\right]E_t\Delta q_{t+1}
+ \alpha(2-\alpha)\frac{1-\tau}{\tau}E_t\Delta y^{\ast}_{t+1}.
```

- **(F2) Open-economy Phillips curve** from optimal price setting:

```math
\pi_t = \beta E_t\pi_{t+1}
+ \alpha\beta E_t\Delta q_{t+1}
- \alpha\Delta q_t
+ \frac{\kappa}{\tau+\alpha(2-\alpha)(1-\tau)}(y_t-\bar y_t).
```

- **(F3) Monetary policy rule** with interest-rate smoothing and exchange-rate response:

```math
R_t = \rho_R R_{t-1}
+ (1-\rho_R)\left[\psi_1\pi_t+\psi_2 y_t+\psi_3\Delta e_t\right]
+ \varepsilon^R_t.
```

`needs_review`: equations (F1)-(F3) are transcribed from MinerU OCR and checked against the implementation variable list. They were not checked against the PDF body in this pass.

## 4. Market Clearing & Identities

- **(F4) Potential output in the absence of nominal rigidities**:

```math
\bar y_t = -\alpha(2-\alpha)\frac{1-\tau}{\tau}y^{\ast}_t.
```

- **(F5) CPI / relative PPP identity**:

```math
\pi_t = \Delta e_t + (1-\alpha)\Delta q_t + \pi^{\ast}_t.
```

- **(F6) World-output growth identity** used by the implementation:

```math
\Delta y^{\ast}_t = y^{\ast}_t-y^{\ast}_{t-1}.
```

- **(F7) Annualized CPI inflation reporting identity**:

```math
\mathrm{inflationq}_t = 4\pi_t.
```

- **(F8) Annualized nominal interest reporting identity**:

```math
\mathrm{interest}_t = 4R_t.
```

The paper's fully structural terms-of-trade market-clearing relation is:

```math
\left[\tau+\alpha(2-\alpha)(1-\tau)\right]\Delta q_t = \Delta y^{\ast}_t-\Delta y_t.
```

The estimated and replicated model does not use that equation as an equilibrium condition; it replaces it with the exogenous process (F9). This exclusion is source-stated and implementation-confirmed.

## 5. Exogenous Processes

- **(F9) Terms-of-trade growth shock**:

```math
\Delta q_t = \rho_q \Delta q_{t-1}+\varepsilon_{q,t}.
```

- **(F10) Technology growth shock**:

```math
z_t = \rho_z z_{t-1}+\varepsilon^z_t.
```

- **(F11) World output shock**:

```math
y^{\ast}_t = \rho_{y^{\ast}}y^{\ast}_{t-1}+\varepsilon^{y^{\ast}}_t.
```

- **(F12) World inflation shock**:

```math
\pi^{\ast}_t = \rho_{\pi^{\ast}}\pi^{\ast}_{t-1}+\varepsilon^{\pi^{\ast}}_t.
```

The policy shock `\varepsilon^R_t` enters the rule in (F3). The implementation cross-check names the five innovations `epsR`, `epsq`, `epsy_star`, `epspi_star`, and `epsz`.

## 6. Steady-State Solution

Because `CA_LS07` is a `model(linear)` implementation, the model variables are deviations or growth-rate deviations around their steady states. The Dynare steady state is therefore zero for all endogenous variables:

```math
y=R=\pi=z=\Delta q=\Delta y^{\ast}=y^{\ast}=\bar y=\Delta e=\pi^{\ast}=\mathrm{inflationq}=\mathrm{interest}=0.
```

The discount factor is parameterized from the annualized steady-state real interest rate:

```math
\beta = \exp(-r/400).
```

For the Canadian replication, the implementation cross-check uses `rss=2.52`, so `beta=exp(-2.52/400)`. Runtime validation was not performed.

## 7. Timing & Form Conventions

- Expectations are dated at `t`; in Dynare notation, `x(+1)` corresponds to `E_t x_{t+1}` in the linear rational-expectations equations.
- `R_t`, `\pi_t`, `y_t`, `\Delta e_t`, and `\Delta q_t` are deviations / growth-rate variables, not gross nonlinear levels.
- `y_t` is output relative to the non-stationary technology process. Observed output growth corresponds to `\Delta y_t + z_t`.
- `\Delta q_t` is terms-of-trade growth, treated as exogenous in the estimated model.
- `\Delta e_t` is nominal exchange-rate depreciation and is determined through the CPI / PPP identity.
- No capital stock appears in this simplified SOE model; there is no capital-in-production timing convention to record.

## 8. Variable & Parameter Reference Table

### Endogenous variables

| Symbol | Implementation name | Meaning | Main equation |
|---|---|---|---|
| $`y_t`$ | `y` | output deviation relative to technology trend | (F1) |
| $`R_t`$ | `R` | nominal interest-rate deviation | (F3) |
| $`\pi_t`$ | `pi` | CPI inflation deviation | (F2), (F5) |
| $`z_t`$ | `z` | technology growth process | (F10) |
| $`\Delta q_t`$ | `deltaq` | terms-of-trade growth | (F9) |
| $`\Delta y^{\ast}_t`$ | `deltay_star` | world-output growth | (F6) |
| $`\bar y_t`$ | `y_bar` | potential output without nominal rigidities | (F4) |
| $`y^{\ast}_t`$ | `y_star` | world output | (F11) |
| $`\Delta e_t`$ | `deltae` | nominal exchange-rate depreciation | (F5) |
| $`\pi^{\ast}_t`$ | `pi_star` | world inflation / PPP deviation shock | (F12) |
| $`\mathrm{inflationq}_t`$ | `inflationq` | annualized CPI inflation reporting variable | (F7) |
| $`\mathrm{interest}_t`$ | `interest` | annualized nominal interest reporting variable | (F8) |

### Exogenous shocks

| Symbol | Implementation name | Meaning |
|---|---|---|
| $`\varepsilon^R_t`$ | `epsR` | monetary policy shock |
| $`\varepsilon_{q,t}`$ | `epsq` | terms-of-trade growth shock |
| $`\varepsilon^{y^{\ast}}_t`$ | `epsy_star` | world output shock |
| $`\varepsilon^{\pi^{\ast}}_t`$ | `epspi_star` | world inflation shock |
| $`\varepsilon^z_t`$ | `epsz` | technology growth shock |

### Parameters

| Symbol | Implementation name | Meaning / Canada value used in MMB cross-check |
|---|---|---|
| $`\tau`$ | `tau` | intertemporal substitution elasticity; 0.31 |
| $`\alpha`$ | `alfa` | import share; 0.11 |
| $`\rho_z`$ | `rhoz` | technology-growth persistence; 0.42 |
| $`r`$ | `rss` | annualized steady-state real interest rate; 2.52 |
| $`\beta`$ | `beta` | discount factor, `exp(-rss/400)` |
| $`\kappa`$ | `kappa` | Phillips-curve slope; 0.32 |
| $`\rho_R`$ | `rhoR` | interest-rate smoothing; 0.69 |
| $`\psi_1`$ | `psi1` | policy response to inflation; 1.30 |
| $`\psi_2`$ | `psi2` | policy response to output; 0.23 |
| $`\psi_3`$ | `psi3` | policy response to nominal depreciation; 0.14 |
| $`\rho_q`$ | `rhoq` | terms-of-trade growth persistence; 0.31 |
| $`\rho_{y^{\ast}}`$ | `rhoy_star` | world-output persistence; 0.97 |
| $`\rho_{\pi^{\ast}}`$ | `rhopi_star` | world-inflation persistence; 0.46 |
