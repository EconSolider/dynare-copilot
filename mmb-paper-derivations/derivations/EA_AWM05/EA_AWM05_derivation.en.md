# EA_AWM05 -- Derivation Archive Entry

> Status: needs_review. This first-pass derivation is based on the MinerU Markdown for Dieppe, Kuester, and McAdam (2005) plus an implementation-only cross-check against `EA_AWM05_rep.mod`. The raw PDF path was verified for provenance but the PDF body was not read.

## 1. Model Overview

- **Model ID**: `EA_AWM05`.
- **Paper**: "Optimal monetary policy rules for the euro area: An analysis using the area wide model", Alistair Dieppe, Keith Kuester, and Peter McAdam, 2005, DOI `10.1111/j.0021-9886.2005.00567.x`.
- **Source**: `raw/mmb_mineru/runs/ea_awm05__optimal_monetary_policy_rules_for_the_euro_area_an_analysis_using_the_ar__52db9f78/full.md`; raw PDF path `raw/mmb_papers/Optimal monetary policy rules for the euro area- An analysis using the area wide model.pdf`.
- **Source sniff**: the first Markdown page reports the expected title and the expected authors. No title/author mismatch was found. The implementation file header instead names the underlying Fagan-Henry-Mestre AWM documentation; this is recorded as `implementation_cross_check`, not as paper-side evidence.
- **Economy**: euro area, quarterly estimated Area Wide Model (AWM).
- **Core structure**: large empirical structural macro model with persistent price, wage, employment, investment, external-sector, fiscal, and wealth dynamics. Most private-sector blocks are backward-looking or error-correction equations; exchange rates and the long-term bond term structure contain forward-looking expectations.
- **Policy experiment**: compare simple, optimized simple, and fully optimal monetary policy rules. The MMB implementation exposes a flexible linear policy rule for the short nominal interest rate with lags/leads of inflation and output plus an interest-rate shock.
- **Model form**: `model(linear)` in the implementation cross-check. Variables are deviations from long-run means or steady ratios; steady state is zero for the linearized dynamic variables, with calibrated constants and shares stored separately.
- **Runtime validation**: not performed.

## 2. Optimization Problems

The article is an optimal-policy application of the AWM, not a micro-founded DSGE derivation. The private-sector AWM equations are estimated behavioral equations, so there are no household or firm objective functions in the paper-side source. The optimization problem that is explicit in the paper is the policymaker's stabilization objective.

### 2.1 Period Loss

The central bank evaluates deviations of inflation from target, output from potential, and changes in the nominal interest rate:

```math
\ell_t = (\pi_t-\pi^{\ast})^2 + \lambda (y_t-y_t^{\ast})^2 + \gamma (\Delta r_t)^2,
\qquad \Delta r_t = r_t-r_{t-1}.
```

### 2.2 Unconditional Loss

For the policy-rule comparisons, the period loss is represented by unconditional standard deviations:

```math
\mathcal{L} = \sigma_\pi^2 + \lambda \sigma_{gap}^2 + \gamma \sigma_{\Delta r}^2.
```

In many reported exercises the volatility of interest-rate changes is constrained to match the euro-area empirical upper bound, so the smoothing term is not always added directly to the loss.

### 2.3 Simple Policy Rule Search

The generalized simple rule chooses response coefficients and forecast horizons:

```math
r_t = \rho r_{t-1} + \alpha E_t\pi_{t+\theta} + \beta E_t gap_{t+\kappa}.
```

The model is then used to search for the parameter vector that minimizes the loss under determinacy/stability restrictions. This optimization is over policy-rule coefficients, not over private-agent allocations.

## 3. First-Order Conditions

Because the AWM private-sector block is empirical and largely backward-looking, the source does not provide structural FOCs for households or firms. The equations below therefore summarize the policy optimality target and the AWM implementation equations as model conditions. Equations copied from the implementation cross-check are marked `needs_review` because the paper points readers to Fagan et al. (2001) and Dieppe-Henry (2004) for the full model listing.

- **(F1) Policymaker period loss**:

```math
\ell_t = (\pi_t-\pi^{\ast})^2 + \lambda gap_t^2 + \gamma (r_t-r_{t-1})^2.
```

- **(F2) Policy-evaluation loss**:

```math
\mathcal{L} = \sigma_\pi^2 + \lambda \sigma_{gap}^2 + \gamma \sigma_{\Delta r}^2.
```

- **(F3) Generic simple interest-rate rule**:

```math
r_t = \rho r_{t-1} + \alpha E_t\pi_{t+\theta} + \beta E_t gap_{t+\kappa}.
```

- **(F4) MMB flexible policy rule, implementation_cross_check, needs_review**:

```math
\begin{aligned}
i_t ={}& c + \sum_{j=1}^{4} a_j i_{t-j}
+ b_0 \pi^q_t + \sum_{j=1}^{4} b^-_j \pi^q_{t-j}
+ \sum_{j=1}^{4} b^+_j E_t\pi^q_{t+j} \\
&+ d_0 y^{gap}_t + \sum_{j=1}^{4} d^-_j y^{gap}_{t-j}
+ \sum_{j=1}^{4} d^+_j E_t y^{gap}_{t+j}
+ b_\pi \pi^{\ast} + b_{rlb}\bar r + \sigma_i \varepsilon^i_t .
\end{aligned}
```

- **(F5) Employment equation, implementation_cross_check, needs_review**:

```math
\ell^n_t =
\ell^n_{t-1}
+ a_y(\Delta y^r_t+\pi^{pot}_t)
+ a_{\ell y}(\Delta y^r_{t-1}+\pi^{pot}_{t-1})
+ a_w\Delta w^r_t
+ a_{w1}\Delta w^r_{t-1}
+ a_{ecm}\left(\ell^n_{t-1}-\frac{1}{1-\beta_B}y^r_{t-1}\right)
+ \varepsilon^\ell_t .
```

- **(F6) Wage equation, implementation_cross_check, needs_review**:

```math
\Delta w^n_t =
\Delta lprod_t + \Delta p^c_t - \omega_\pi \pi^c_{t-1}
+ \sum_j \omega_{pj}\Delta \pi^c_{t-j}
+ \sum_j \omega_{zj}\Delta lprod_{t-j}
+ \omega_u urx_{t-1}
- \omega_{ecm} ulc^T_{t-1}
+ \varepsilon^w_t .
```

- **(F7) GDP deflator inflation, implementation_cross_check, needs_review**:

```math
\pi^{yfd}_t =
a_g y^r_{t-1} - a_\pi \pi^{yfd}_{t-1}
+ \sum_j a_{u,j}\Delta ulc^T_{t-j}
+ a_m \pi^m_{t-1}
- a_{ecm} ulc^T_{t-1}
+ \varepsilon^{yfd}_t .
```

- **(F8) Consumer-price inflation, implementation_cross_check, needs_review**:

```math
\pi^c_t =
a_4\pi^c_{t-4}
+ a_y\pi^{yfd}_t + a_{y1}\pi^{yfd}_{t-1}
+ a_m\pi^m_t + a_{m1}\pi^m_{t-1}
+ a_o\pi^{oil}_t
+ a_{ecm}\left(p^c_{t-1}-\eta_m m^d_{t-1}\right)
+ \varepsilon^c_t .
```

- **(F9) Investment ratio, implementation_cross_check, needs_review**:

```math
i^r_t =
i^r_{t-1}+\Delta y^r_t
+ a_{y1}\Delta y^r_{t-1}
+ a_{ecm}\left[-(\bar s+\delta+a_i)i^r_{t-1}-s^r_{t-1}\right]
+ \varepsilon^I_t .
```

- **(F10) Import-price inflation, implementation_cross_check, needs_review**:

```math
\pi^m_t =
a_m\pi^m_{t-1}
+ a_{wx}\pi^{ywdx}_t
+ a_o\pi^{oil}_t+a_{o1}\pi^{oil}_{t-1}
+ a_{ecm}\left[\eta_x(m^d_{t-1}-x^d_{t-1})+\eta_o(m^d_{t-1}-oil_{t-1})+\eta_w(m^d_{t-1}-y^w_{t-1})\right]
+ \varepsilon^m_t .
```

- **(F11) Private consumption ratio, implementation_cross_check, needs_review**:

```math
c^r_t =
c^r_{t-1}-\pi^{pot}_t
+ a_u(urx_t-urx_{t-1})
+ a_s\left[\Delta s^n_{t-1}-\Delta\pi^c_{t-1}\right]
+ a_y(\pi^y_t+\pi^y_{t-1})
+ a_{py}(c^r_{t-1}-y^p_{t-1})
+ a_{w}(c^r_{t-1}-w^l_{t-1}+p^c_{t-1})
+ \varepsilon^C_t .
```

- **(F12) Long-term bond rate, implementation_cross_check, needs_review**:

```math
\ell^T_t =
\chi_T \frac{1}{20}\sum_{j=0}^{19} E_t s^n_{t+j}
+ \varepsilon^{LT}_t .
```

## 4. Market Clearing & Identities

The following conditions summarize the model identities visible in the implementation cross-check. They are `needs_review` because the indexed paper provides only a high-level model description and references the full AWM listing elsewhere.

- **(F13) Output gap definition**:

```math
gap_t = y^r_t-y^{pot}_t .
```

- **(F14) Quarterly and annualized consumer inflation definitions**:

```math
\pi^q_t = 400\,\pi^c_t,\qquad
\pi^{ann}_t = \pi^c_t+\pi^c_{t-1}+\pi^c_{t-2}+\pi^c_{t-3}.
```

- **(F15) Potential output growth process used in model identities**:

```math
\pi^{pot}_t = \beta_B \pi^{pot}_{t-1} + \beta_B(k^s_{t-1}-k^s_{t-2}).
```

- **(F16) Unemployment gap from employment**:

```math
urx_t = -\frac{1-\bar U}{\bar U}\ell^n_t .
```

- **(F17) Labor productivity**:

```math
lprod_t = y^r_t + y^{trend}_t - \ell^n_t .
```

- **(F18) Unit labor cost identities**:

```math
ulc_t = w^i_t-y^{trend}_t-y^r_t,\qquad ulc^T_t=w^n_t-y^{trend}_t .
```

- **(F19) Capital stock accumulation, linearized ratio form**:

```math
k^s_t =
\frac{1-\delta}{1+\bar g}k^s_{t-1}
-\frac{1-\delta}{1+\bar g}\pi^{pot}_t
+\frac{\bar g+\delta}{1+\bar g}i^r_t .
```

- **(F20) Short real rate proxy**:

```math
s^r_t =
\frac{0.25}{100}\left(\frac{1}{1+\bar s/100}\right)^{0.75}s^n_t
-0.25(\pi^{yfd}_t+\pi^{yfd}_{t-1}+\pi^{yfd}_{t-2}+\pi^{yfd}_{t-3}).
```

- **(F21) Domestic demand deflator aggregate**:

```math
f^d_t =
\omega_C c^r_t+\omega_G g^c_t+\omega_I i^r_t+\omega_X x^r_t
+(1-\omega_C-\omega_G-\omega_I-\omega_X)s^c_t .
```

- **(F22) Trade balance aggregate**:

```math
tb_t = \omega_X x^n_t + (1-\omega_X)m^n_t .
```

- **(F23) Real GDP expenditure identity**:

```math
y^r_t =
\omega_C c^r_t+\omega_G g^c_t+\omega_I i^r_t+\omega_{TB}tb_t
+(1-\omega_C-\omega_G-\omega_I-\omega_{TB})s^c_t .
```

- **(F24) Current account identity**:

```math
ca_t=\omega_{TB}tb_t+(1-\omega_{TB})nfn_t .
```

- **(F25) Net foreign assets accumulation**:

```math
nfa_t =
\frac{1}{(1+\bar g)(1+\bar\pi)}(nfa_{t-1}-\pi^{pot}_t-\pi^{yfd}_t)
+ \omega_{CA} ca_t .
```

- **(F26) Private income identity**:

```math
y^p_t =
\omega_Y y^r_t +(1-\omega_Y-\omega_T-\omega_N-\omega_D)g^y_t
+\omega_T y^r_t+\omega_N nfn_t+\omega_D y^r_t .
```

- **(F27) Private wealth identity**:

```math
w^l_t =
\omega_N nfa_t+\omega_K(k^s_t+i^d_t)+(1-\omega_N-\omega_K)g^d_t .
```

- **(F28) Government income identity**:

```math
g^y_t =
\omega_{tdn}tdn_t+\omega_{ssn}y^r_t+\omega_{tin}y^r_t+\omega_{ogn}y^r_t
-\omega_{inn}inn_t-\omega_{trn}trn_t-\omega_{oth}y^r_t
+(1-\omega_{tdn}-\omega_{ssn}-\omega_{tin}-\omega_{ogn}+\omega_{inn}+\omega_{trn}+\omega_{oth})y^r_t .
```

## 5. Exogenous Processes

The implementation contains explicit innovations for employment, wages, deflators, investment, trade, consumption, stockbuilding, exports, imports, long rates, the short-rate rule, and fiscal spending. The paper-side article emphasizes monetary-policy shocks and fixed fiscal rules rather than a compact DSGE shock list.

- **(F29) Interest-rate shock in the policy rule, implementation_cross_check**:

```math
i_t = \cdots + \sigma_i \varepsilon^i_t .
```

- **(F30) Government consumption shock, implementation_cross_check, needs_review**:

```math
g^c_t-\bar a_g g^c_{t-1}+\pi^{pot}_t =
\rho_g(g^c_{t-1}-\bar a_g g^c_{t-2}+\pi^{pot}_{t-1})
+ \sigma_g\varepsilon^g_t .
```

- **(F31) Structural residual block, implementation_cross_check, needs_review**:

```math
\varepsilon_t =
\{\varepsilon^\ell_t,\varepsilon^w_t,\varepsilon^{yfd}_t,\varepsilon^c_t,\varepsilon^I_t,
\varepsilon^{id}_t,\varepsilon^x_t,\varepsilon^m_t,\varepsilon^C_t,\varepsilon^{lsr}_t,
\varepsilon^{xr}_t,\varepsilon^{mr}_t,\varepsilon^{LT}_t\}.
```

## 6. Steady-State Solution

The MMB implementation is declared as `model(linear)`. Therefore:

- **(F32) Linear-model steady state**:

```math
\bar x = 0 \quad \text{for each stationary deviation variable } x_t .
```

The non-zero long-run ratios and constants are calibration inputs rather than nonlinear steady-state unknowns. The implementation cross-check stores them as parameters such as `PIBAR`, `STNBAR`, `YETGBAR`, steady expenditure shares, government-debt shares, trade shares, and wealth shares. These are used to scale the linearized identities in Sections 3-5.

Steady-state reconstruction remains `needs_review` because the article being archived is the optimal-policy application and does not reproduce the full AWM steady-state derivation.

## 7. Timing & Form Conventions

- **Form**: linearized `model(linear)`; equations use deviations from long-run means or steady ratios.
- **Expectations**: the AWM is mostly backward-looking, but exchange-rate and term-structure channels use forward-looking expectations. The policy rule may include leads of inflation and output depending on the selected horizon.
- **Stock timing**: capital stock `ksr`, net foreign assets `nfa`, and government debt `gdn` are predetermined stock variables with lagged accumulation terms. Production and expenditure use current flow variables and lagged stocks.
- **Interest rates**: `stn` is the short nominal rate; `ltn` is a long nominal rate approximated by a finite expected average of future short rates.
- **Inflation**: `pipcd` is quarterly consumer-price inflation; `inflationq = 400*pipcd`; `infl` aggregates four quarterly inflation terms.
- **Policy-rule horizons**: the source distinguishes outcome-based, lagged-information, one-year-forward, and optimized forecast-horizon rules. The MMB implementation makes this operational through separate coefficients on current, lagged, and forward inflation/output terms.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Main equation |
|---|---|---|---|
| Endogenous | `interest`, `stn`, $`i_t`$ | short nominal interest rate | (F4) |
| Endogenous | `inflation`, `infl` | annual inflation measure | (F14) |
| Endogenous | `inflationq`, `pipcd` | annualized quarterly consumer inflation | (F14), (F8) |
| Endogenous | `outputgap` | output gap | (F13) |
| Endogenous | `output`, `yer` | real GDP/output | (F23) |
| Endogenous | `lnn` | employment | (F5) |
| Endogenous | `wrn` | nominal wage | (F6) |
| Endogenous | `piyfd` | GDP deflator inflation | (F7) |
| Endogenous | `pcd` | consumer-price deflator level/deviation | (F8), (F14) |
| Endogenous | `itr` | real investment ratio | (F9) |
| Endogenous | `ksr` | capital stock ratio | (F19) |
| Endogenous | `strq` | short real rate proxy | (F20) |
| Endogenous | `ltn` | long nominal rate | (F12) |
| Endogenous | `pcr` | private consumption ratio | (F11) |
| Endogenous | `xtr`, `mtr`, `tbr` | export, import, and trade-balance ratios | (F22), related trade equations |
| Endogenous | `nfa`, `can`, `nfn` | net foreign assets, current account, net factor income | (F24), (F25) |
| Endogenous | `gcr`, `gyn`, `gdn` | government consumption, income, debt | (F28), (F30) |
| Endogenous | `wln`, `pyn`, `pyr` | wealth, private income, real private income | (F26), (F27) |
| Exogenous | `interest_` | monetary-policy innovation | (F29) |
| Exogenous | `fiscal_` | fiscal/government-consumption innovation | (F30) |
| Exogenous | `innoe*` | residual innovations for empirical AWM blocks | (F31) |
| Parameter | $`\lambda`$ | loss weight on output-gap variability | (F1), (F2) |
| Parameter | $`\gamma`$ | loss weight on interest-rate-change variability | (F1), (F2) |
| Parameter | $`\rho,\alpha,\beta,\theta,\kappa`$ | simple-rule smoothing, response coefficients, and horizons | (F3) |
| Parameter | `cofint*` | implementation policy-rule coefficients | (F4) |
| Parameter | `PIBAR`, `STNBAR`, `YETGBAR` | inflation, short-rate, and potential-growth steady constants | (F19), (F20), (F32) |
| Parameter | `*_YERBAR`, `*_YENBAR`, `*_FDDBAR` | steady shares used in linear aggregates | (F21)-(F28) |
| Parameter | equation-specific `*_ECM`, `*_DL*`, `*_RES` | estimated AWM dynamic and error-correction coefficients | (F5)-(F12) |

Equation count note: (F1)-(F32) are archive equations and identities, not a one-equation-per-endogenous implementation reconstruction. The full MMB `.mod` contains many auxiliary lag equations and empirical identities beyond the compact source-backed summary above.
