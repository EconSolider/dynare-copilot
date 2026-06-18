# US_FRB22_mcap - Derivation (Optimization Problems + First-Order Conditions)

> Archive status: `needs_review`. This first-pass entry is based on the paper-side MinerU Markdown for Brayton and Reifschneider (2022) and uses the MMB implementation only as `implementation_cross_check`. Dynare runtime validation was not performed.

Provenance: `US_FRB22_mcap`, Brayton, Flint; Reifschneider, David (2022), "LINVER: The Linear Version of FRB/US", Finance and Economics Discussion Series 2022-053, DOI `10.17016/feds.2022.053`. Source Markdown: `raw/mmb_mineru/runs/us_frb22_mcap_us_frb22_mcapwp_us_frb22_mceall_us__linver_the_linear_version_of_frb_us__a8780356/full.md`. Raw PDF: `raw/mmb_papers/LINVER- The Linear Version of FRB:US.pdf`. MinerU run id: `a8780356-98b8-4931-bad6-3b2c5b4b2f0c`. Appendix normalization: none found for `US_FRB22_mcap`.

## 1. Model Overview

- **Model**: LINVER, the linear version of the Federal Reserve Board's FRB/US model, archived here as MMB model `US_FRB22_mcap`.
- **Variant**: The MMB implementation comment identifies this as the variant in which financial-market expectations are model-consistent, while other expectations are based on a small VAR. This is `implementation_cross_check`; the paper describes this mixed expectation regime as one standard LINVER/FRB/US option.
- **Purpose**: Large-scale U.S. semi-structural macroeconomic policy model for deterministic and stochastic simulations, including experiments with model-consistent (MC) expectations, VAR-based expectations, policy-rule alternatives, and the effective lower bound (ELB).
- **Agents/blocks**: Households and firms are represented through estimated expenditure, production, wage-price, financial-market, fiscal, external, and expectations blocks rather than through a compact DSGE set of optimizing agents. Monetary policy is represented by selectable simple rules plus optional ELB and fiscal-stabilization constraints.
- **Form**: Linear model around 2018-2019 average conditions. ELB and threshold policies are nonlinear constraints layered onto the otherwise linear simulation system. `needs_review`: the paper does not publish the full LINVER equation listing in this source.

## 2. Optimization Problems

The paper does not present household, firm, or policymaker optimization problems as primitive DSGE problems. LINVER is described as a symbolic linearization of the nonlinear FRB/US model and as a computational package for policy simulations. Therefore this section records the implied problem classes and marks full primitive optimization recovery as `needs_review`.

- **Private-sector behavioral equations**: Consumption, investment, labor-market, wage-price, external, and asset-price dynamics are inherited from FRB/US and linearized. Their full estimated equations are not reproduced in the paper source.
- **Expectation-formation problem**: Agents can use model-consistent expectations or expectations from limited-information VAR models. For `US_FRB22_mcap`, the implementation cross-check indicates MC expectations in financial markets only.
- **Financial-market block**: The mixed-expectations variant gives financial markets model-consistent forecasts of future rates and macro variables, while other sectors use VAR-based expectations.
- **Policy-rule design problem**: Researchers choose simple policy-rule coefficients or rule families to evaluate macroeconomic losses and ELB performance.

`needs_review`: Source-level extraction of each FRB/US behavioral equation requires the LINVER package/manual or FRB/US model documentation, not just this FEDS paper.

## 3. First-Order Conditions

The paper does not report first-order conditions from primitive household or firm optimization. The following numbered equations are the paper-supported equilibrium and simulation relations that define the archived first-pass derivation.

- **(F1) Linearization mapping for log variables**:

```math
\hat{x}_t = \log X_t - \log \bar{X} \approx \log\left(\frac{X_t}{\bar{X}}\right)
```

where the paper states that generally trending positive variables follow log specifications inherited from FRB/US.

- **(F2) Linearization mapping for level variables**:

```math
\tilde{x}_t = X_t - \bar{X}
```

where non-log variables are linearized in levels around baseline conditions. `needs_review`: variable-by-variable classifications are not listed in the paper.

- **(F3) Substitution for possibly non-positive stock/flow objects**:

```math
S^{surplus}_t = T^{receipts}_t - G^{outlays}_t
```

This represents the paper's stated method of replacing variables such as the government budget surplus with differences of positive components before log/level linearization.

- **(F4) Net foreign asset substitution**:

```math
NFA_t = FA^{gross}_t - FL^{gross}_t
```

The paper identifies the net foreign asset position as another object replaced by a difference of gross asset and liability variables.

- **(F5) Inventory investment substitution**:

```math
I^{inv}_t = K^{inv}_t - K^{inv}_{t-1}
```

The paper identifies inventory investment as a difference between current and lagged stocks.

- **(F6) Generic limited-information VAR expectations law**:

```math
E^{VAR}_t z_{t+h} = e_z' A_h
\sum_{j=0}^{p-1} e_z' B_{h,j} s_{t-j}
```

This is a compact representation of the paper's description that VAR expectations are based on predictions from estimated limited-information VAR models. `needs_review`: the source does not provide the exact VAR state vectors and coefficients.

- **(F7) Model-consistent expectation condition**:

```math
E^{MC}_t z_{t+h} = E_t\left[z_{t+h}\mid \mathcal{M}_{LINVER}, \Omega_t\right]
```

For `US_FRB22_mcap`, this condition applies to financial-market expectations according to the implementation cross-check.

- **(F8) Linear reduced form when nonlinear constraints are absent**:

```math
s_{t+1} = A s_t + B \varepsilon_{t+1}
```

The paper states that a stable linear model has a unique reduced form without leads. `needs_review`: matrices are not reported in the paper.

- **(F9) Generic inertial Taylor rule used in LINVER research**:

```math
R_t = \alpha R_{t-1} + (1-\alpha)\left[r^{\ast} + \pi_t + \beta_{\pi}(\pi_t-\pi^{\ast}) + \gamma_y Y_t\right] + \varepsilon^R_t
```

The paper presents this rule family as a standard policy-rule characterization used in LINVER studies. OCR in the source has one unreadable phrase near the rule; the rate variable is inferred from context and marked `needs_review`.

- **(F10) Inertial Taylor rule with ELB constraint**:

```math
R_t = \max\left\{0.85 R_{t-1} + 0.15\left[1.5\pi_t + 1.0Y_t\right],\; ELB\right\}
```

The paper lists this as one rule used in rule-comparison simulations.

- **(F11) Average inflation targeting rule**:

```math
R_t = \max\left\{0.85 R_{t-1} + 0.15\left[\pi_t + 1.0Y_t + 8.0\pi^{32}_t\right],\; ELB\right\}
```

where $`\pi^{32}_t`$ is the average annual inflation rate over the previous 32 quarters.

- **(F12) Asymmetric average inflation targeting adjustment**:

```math
R_t = \max\left\{0.85 R_{t-1} + 0.15\left[1.5\pi_t + 1.0Y_t\right] + \varepsilon^{AIT}_t,\; ELB\right\}
```

```math
\varepsilon^{AIT}_t =
\begin{cases}
0.15\left(8\pi^{32}_t - 0.5\pi_t\right), & \pi^{32}_t < 0,\\
0, & \pi^{32}_t \ge 0.
\end{cases}
```

- **(F13) Reifschneider-Williams make-up rule**:

```math
R_t = \max\left\{\pi_t + Y_t + CSF_t,\; ELB\right\}
```

```math
CSF_t = CSF_{t-1} + 1.5\pi_t + 1.0Y_t - R_t
```

- **(F14) Kiley-Roberts change rule**:

```math
RV_t = RV_{t-1} + 0.4\pi_t + 0.4Y_t
```

```math
R_t = \max\left\{RV_t,\; ELB\right\}
```

- **(F15) ECFS fiscal stabilization process**:

```math
FISCAL_t = 0.97 FISCAL_{t-1} + \varepsilon^{FISCAL}_t
```

The paper appendix states this emergency fiscal stabilization process and describes choosing the nonnegative shock to keep the near-term output gap above a floor.

## 4. Market Clearing & Identities

- **(F16) GDP expenditure identity by block**:

```math
Y_t = C_t + I_t + G_t + X_t - M_t + \Delta^{inv}_t
```

This is a standard national-accounts identity consistent with the FRB/US/LINVER expenditure blocks and the implementation variable coverage. `needs_review`: the exact LINVER accounting identities are not enumerated in the paper source.

- **(F17) Output gap definition**:

```math
Y^{gap}_t = Y_t - Y^{pot}_t
```

or, for log variables,

```math
y^{gap}_t = 100\left(\log Y_t-\log Y^{pot}_t\right)
```

The paper uses the output gap as a central policy-rule and simulation statistic; exact scaling should be checked against the package.

- **(F18) Unemployment gap definition**:

```math
U^{gap}_t = U_t - U^{nat}_t
```

The paper uses unemployment gap threshold conditions for liftoff simulations.

- **(F19) Four-quarter inflation measure**:

```math
\pi^{4}_t = \frac{1}{4}\sum_{j=0}^{3}\pi_{t-j}
```

The paper reports four-quarter PCE/core PCE inflation statistics and rule thresholds. `needs_review`: package-specific annualization should be checked.

## 5. Exogenous Processes

- **(F20) Demeaned historical residual bootstrap**:

```math
\varepsilon_t = u_{\tau(t)} - \bar{u},\qquad \tau(t)\sim \mathcal{U}\{1970Q1,\ldots,2019Q4\}
```

The paper describes drawing historical residual quarters after subtracting sample means.

- **(F21) State-contingent recession sampling**:

```math
\varepsilon_t =
\begin{cases}
u^{normal}_{\tau(t)}-\bar{u}, & q_t=N,\\
u^{mild}_{\tau(t)}-\bar{u}, & q_t=M,\\
u^{severe}_{\tau(t)}-\bar{u}, & q_t=S.
\end{cases}
```

The paper describes normal, mild slump, and severe slump sampling states.

- **(F22) Generic estimated residual equation in implementation**:

```math
x_t = c_x + \sum_i a_{x,i}x_{t-i} + \sum_k b_{x,k} w_{k,t} + \varepsilon^x_t
```

This compact form summarizes the large equation system visible in the MMB `.mod` implementation and is `implementation_cross_check`, not a paper-side formula.

## 6. Steady-State Solution

LINVER is not linearized around a conventional full stock steady state. The paper states that the current version is linearized around average 2018-2019 conditions, chosen because the economy was near full employment with stable inflation and interest rates and because a full FRB/US stock equilibrium could be far from current financial and physical stock positions.

For the linear archive entry, the baseline solution is:

```math
\bar{s} = s^{2018-2019}_{baseline}
```

and deviations are:

```math
\hat{s}_t = s_t - \bar{s}
```

or log deviations as in (F1). Therefore:

```math
\hat{s}^{ss} = 0
```

`needs_review`: the baseline vector and all variable-specific scaling constants must be extracted from the LINVER package or implementation data, not inferred from the paper.

## 7. Timing & Form Conventions

- Time is quarterly.
- Form is linear by construction; optional ELB and threshold restrictions are nonlinear constraints layered onto the linear model solution.
- The current archive variant uses model-consistent expectations in financial markets while other expectations are VAR-based, according to the MMB implementation comment. The paper describes this as one mixed-expectations case.
- LINVER is linearized around 2018-2019 average conditions rather than around a conventional steady state.
- Variables are classified into log-linearized and level-linearized forms based on FRB/US treatment. Objects that can be non-positive are rewritten as differences of positive components before linearization.
- `implementation_cross_check`: `raw/mmb/mmci-cli/models/US_FRB22_mcap/US_FRB22_mcap.mod` declares 309 endogenous `var` tokens, 120 `varexo` tokens, and 274 named model equations by a non-runtime text count. It uses a plain `model;` block but is described by the paper and metadata as linearized. Dynare was not run.

## 8. Variable & Parameter Reference Table

| Category | Symbol/name | Meaning | Equation reference |
|---|---|---|---|
| Endogenous | `rff`, `R_t`, `interest` | Federal funds rate / policy rate | (F9)-(F14) |
| Endogenous | `outputgap`, `xgap`, `Y_t` | Output gap / real activity measure | (F10)-(F14), (F17) |
| Endogenous | `inflation`, `pic4`, `picxfe`, `pi_t` | Inflation measures | (F9)-(F14), (F19) |
| Endogenous | `fiscal`, `FISCAL_t` | ECFS fiscal stabilization index | (F15) |
| Endogenous | `ugap`, `U^{gap}_t` | Unemployment gap | (F18) |
| Endogenous | `rg5`, `rg10`, `rg30`, `zrff5`, `zrff10`, `zrff30` | Treasury yields and MC expected future short-rate components in the financial-market block | (F7), (F8), needs_review |
| Endogenous | `ec_l`, `ecd_l`, `ech_l`, `eco_l` | Consumption expenditure blocks from implementation | (F22), needs_review |
| Endogenous | `ebfi_l`, `eh_l`, `ki_l`, `kbfi_l`, `kh_l` | Investment/capital/housing blocks from implementation | (F22), needs_review |
| Endogenous | `xgdp_l`, `xgap`, `xbt_l`, `xb_l`, `ex_l`, `em_l` | GDP, gap, trade/export/import blocks | (F16), (F22), needs_review |
| Exogenous | `interest_` | Monetary policy shock in MMB metadata | (F9)-(F14) |
| Exogenous | `fiscal_`, `fiscal_aerr` | Fiscal/ECFS shock | (F15) |
| Exogenous | `*_aerr` residuals | Equation residual shocks by block | (F20)-(F22) |
| Exogenous | `fpitrg`, `pitarg`, `rstar`, `ELB` | Inflation target, neutral rate, lower-bound settings | (F9)-(F14) |
| Parameter | `alpha`, `beta_pi`, `gamma_y` | Generic Taylor-rule inertia/inflation/gap coefficients in paper notation | (F9) |
| Parameter | `cofint*`, `std_r_`, `coffispol` | Policy-rule and modelbase coefficients in implementation | (F9)-(F15), implementation_cross_check |
| Parameter | `y_*` coefficient names | Implementation equation coefficients | (F22), implementation_cross_check |

Full variable, shock, and parameter coverage remains `needs_review` because the paper does not publish a complete equation-by-equation LINVER listing.
