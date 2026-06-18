# US_FRB22_mceall -- Derivation Notes

> Private MMB archive draft. Status: `needs_review`. Runtime validation was not performed.

## 1. Model Overview

- **Model ID**: `US_FRB22_mceall`.
- **Source**: Brayton and Reifschneider (2022), "LINVER: The Linear Version of FRB/US," Finance and Economics Discussion Series 2022-053, DOI `10.17016/feds.2022.053`.
- **Model family**: 2022-vintage LINVER, the linear version of the Federal Reserve Board's FRB/US model.
- **MMB variant**: `mceall`, interpreted from the MMB implementation as the variant in which all expectations are model consistent. This variant label is an `implementation_cross_check`, not an explicit paper equation label.
- **Agents and sectors**: large-scale U.S. macroeconometric model covering household demand, business fixed investment, housing, inventories, imports/exports, labor supply and wages, prices, government receipts/outlays/debt service, financial rates, term premiums, monetary policy, fiscal stabilization, and expectations objects.
- **Form**: linear model. The source describes LINVER as a symbolic linearization of nonlinear FRB/US, evaluated around average 2018-2019 conditions rather than a full stock steady state. The MMB `.mod` uses a linear equation block with levels/log-level transformations already embedded in named variables.
- **Main simulation context**: stochastic and deterministic simulations with model-consistent expectations, optional effective lower bound (ELB) restrictions, and policy-rule experiments. Dynare execution is out of scope for this archive pass.
- **Formula quality**: `needs_review`. The paper gives selected policy and fiscal-stabilization formulas and explains linearization methodology, but it does not publish the complete FRB/US equation system. Detailed equation coverage below is therefore a structured source-backed summary plus implementation cross-check, not a full paper-side derivation.

## 2. Optimization Problems

The LINVER paper does not present household, firm, government, or financial-sector optimization problems in the DSGE-style form used by smaller structural models. It states that LINVER is a linear version of the broader nonlinear FRB/US model and that variables are classified for linearization in levels or logs, with substitutions made when log linearization would be inappropriate for variables that may be non-positive.

- **Households and firms**: no paper-side utility, profit, or cost-minimization problems are listed in the source Markdown. `needs_review`: full sector equations would require the FRB/US/LINVER model documentation or code package, not just the FEDS overview paper.
- **Monetary authority**: the paper gives a generic inertial federal-funds-rate rule used in LINVER policy analysis:

**(F1) Generic inertial policy rule from the paper**:

$$
R_t = \alpha R_{t-1} + (1-\alpha)\left[r^{\ast} + \pi_t + \beta(\pi_t-\pi^{\ast}) + \gamma Y_t\right].
$$

Here $R_t$ is the nominal federal funds rate, $r^{\ast}$ the neutral real rate, $\pi_t$ inflation, $\pi^{\ast}$ the inflation target, and $Y_t$ the output gap. This is source-stated as a generic characterization used in optimal-rule studies, not necessarily the exact MMB policy equation.

- **Fiscal stabilization mechanism**: the appendix describes an emergency fiscal stabilization variable used when ELB simulations would otherwise produce severe downturns.

**(F2) ECFS fiscal process from the paper**:

$$
FISCAL_t = 0.97 FISCAL_{t-1} + \varepsilon_t.
$$

The shock is selected by the solution routine when needed to keep the expected near-term output gap above a floor. This is a simulation mechanism rather than a welfare-optimization FOC.

## 3. First-Order Conditions

No source-level first-order conditions are reported in the LINVER overview paper. The archive therefore records only reduced-form behavioral equations and cross-checked implementation equations. The following generic templates summarize the MMB implementation structure and must be treated as `implementation_cross_check`.

**(F3) Linear behavioral equation template (`implementation_cross_check`)**:

$$
x_t =
c_x
+ \sum_{j \in L_x} a_{x,j} x_{j,t-\ell_j}
+ \sum_{k \in F_x} b_{x,k} E_t x_{k,t+h_k}
+ \sum_{m \in Z_x} d_{x,m} z_{m,t}
+ \varepsilon^x_t.
$$

This template represents the many named equations in the MMB `.mod`, each written as a calibrated linear relation in lagged, contemporaneous, and sometimes future-dated variables.

**(F4) Model-consistent expectations object (`implementation_cross_check`)**:

$$
z^q_t = \sum_i \omega_i q_{i,t+s_i}.
$$

The MMB implementation has many expectation variables such as `zebfi`, `zecd`, `zeco`, `zeh`, `zgap05`, `zgap10`, `zgap30`, `zpi10`, `zpicxfe`, and `zrff5`/`zrff10`/`zrff30`, often involving leads. For `mceall`, these objects are consistent with the variant description "all expectations are model consistent."

**(F5) Interest-rate policy rule in the MMB implementation (`implementation_cross_check`)**:

$$
\begin{aligned}
i_t ={}&
\sum_{j=1}^{4} a_j i_{t-j}
+ b_0 \pi^q_t
+ \sum_{j=1}^{4} b_j \pi^q_{t-j}
+ \sum_{j=1}^{4} c_j E_t\pi^q_{t+j} \\
&+ d_0 gap_t
+ \sum_{j=1}^{4} d_j gap_{t-j}
+ \sum_{j=1}^{4} e_j E_t gap_{t+j}
+ f_0 y_t
+ \sum_{j=1}^{4} f_j y_{t-j}
+ \sum_{j=1}^{4} g_j E_t y_{t+j}
+ \sigma_i \varepsilon^i_t .
\end{aligned}
$$

The exact coefficients are `cofint*` and `std_r_` in the implementation. The source paper's policy equation (F1) motivates this rule family but does not list this high-dimensional implementation formula.

## 4. Market Clearing & Identities

The source paper does not provide a full set of market-clearing equations. It describes LINVER as maintaining dynamics close to nonlinear FRB/US when the ELB does not bind, with important observed variables including the output gap, unemployment gap, PCE/core PCE inflation, federal funds rate, and Treasury yields.

The MMB implementation exposes summary identities for Modelbase reporting:

**(F6) Reported short-rate identity (`implementation_cross_check`)**:

$$
interest_t = rff_t.
$$

**(F7) Quarterly inflation reporting identity (`implementation_cross_check`)**:

$$
inflationq_t = 4\,picnia_t.
$$

**(F8) Output-gap reporting identity (`implementation_cross_check`)**:

$$
outputgap_t = xgap2_t.
$$

**(F9) Output reporting identity (`implementation_cross_check`)**:

$$
output_t = 100\,xgdp\_l_t.
$$

**(F10) Production-side output-gap identity (`implementation_cross_check`)**:

$$
xgap2_t = 100\,xgdo\_l_t - 100\,xgdpt\_l_t.
$$

**(F11) GDP accounting block template (`implementation_cross_check`)**:

$$
xgdpn\_l_t =
\sum_s \lambda_s\,component_{s,t}
+ p_{k,t}
+ p_{x,t}
+ \lambda_i\,ki\_l_t
+ \lambda_{i,-1}\,ki\_l_{t-1}.
$$

`needs_review`: the exact source-level accounting identities and sector aggregation should be checked against the official LINVER package documentation, not inferred only from the `.mod`.

## 5. Exogenous Processes

The paper describes equation residuals sampled from 1970-2019 and rescaled wage-price shocks for stochastic simulation, but does not list all residual processes. The MMB implementation declares many equation residual shocks plus policy shocks.

**(F12) Generic equation residual (`implementation_cross_check`)**:

$$
u^x_t = \sigma_x \varepsilon^x_t.
$$

**(F13) Fiscal policy shock mapping (`implementation_cross_check`)**:

$$
fispol_t = \kappa_f \varepsilon^f_t.
$$

**(F14) Fiscal stock process (`implementation_cross_check`, paper-consistent)**:

$$
fiscal_t = 0.97\,fiscal_{t-1} + fiscal\_aerr_t.
$$

**(F15) Moving-average fiscal impetus (`implementation_cross_check`)**:

$$
fiscalav_t = 0.90\,fiscalav_{t-1} + fiscal_t.
$$

**(F16) Persistent trend/process template (`implementation_cross_check`)**:

$$
s_t = \rho_s s_{t-1} + \varepsilon^s_t.
$$

Examples in the implementation include persistent variables for trend productivity, labor-force participation, natural unemployment, prices, term premiums, and foreign-sector objects.

## 6. Steady-State Solution

LINVER is not linearized around a conventional full stock steady state. The source states that the current version is evaluated around average 2018-2019 conditions when the economy was near full employment with relatively stable inflation and interest rates. This is a central convention for this archive entry.

For a linear implementation, the archive-level steady-state interpretation is:

**(F17) Baseline deviation convention**:

$$
\tilde{x}_t = x_t - x^{base}_t,
\qquad
E[\tilde{x}_t] = 0
$$

for variables represented as linear deviations around the LINVER baseline/evaluation point.

**(F18) Inflation and interest baseline targets**:

$$
\pi_t = \pi^{\ast} + \tilde{\pi}_t,
\qquad
i_t = i^{\ast} + \tilde{i}_t.
$$

The paper discusses simulations under alternative neutral nominal federal funds rates, such as 2, 3, and 4 percent, and a zero ELB. These are scenario assumptions, not a single source-stated steady state.

`needs_review`: exact baseline values and transformation offsets are not recoverable from the FEDS overview paper alone. They should be read from the official LINVER package data or MMB calibration files in a later validation phase.

## 7. Timing & Form Conventions

- **Linearization**: variables are classified for level or log linearization based on their FRB/US treatment. Trending variables generally use log specifications; other variables use level specifications. Substitutions are made for non-positive candidates such as budget surplus, net foreign asset position, and inventory investment.
- **Evaluation point**: symbolic linearization is evaluated with data roughly consistent with equilibrium in key macro variables and close to 2018-2019 average conditions.
- **Expectations**: the model allows VAR-based expectations, model-consistent expectations, and mixed cases. `US_FRB22_mceall` corresponds to all expectations being model consistent according to the implementation cross-check.
- **Leads and lags**: model-consistent expectations add future-dated endogenous variables. The MMB `.mod` contains explicit leads such as `(+1)`, `(+2)`, and more distant forecast objects. Lags are pervasive in adjustment and accounting equations.
- **ELB**: the ELB is nonlinear and imposed by iterative solution routines on the path of expected federal funds rates. It is not part of the linear model block itself.
- **Dynare form**: implementation appears as a linear Dynare `model` block but not explicitly `model(linear)`. Treat this as a linear-form implementation requiring review before any runtime claims.
- **Runtime validation**: not performed. Dynare was not run.

## 8. Variable & Parameter Reference Table

Because the full MMB implementation contains hundreds of endogenous variables and shocks, this table records the main source-backed and cross-checked groups rather than a complete equation-by-equation inventory. Complete inventory should be generated from the `.mod` in a later implementation audit.

| Category | Symbol or implementation name | Meaning | Source status | Main equation |
|---|---|---|---|---|
| Endogenous | `interest`, `rff` | Federal funds rate / reporting short rate | implementation_cross_check | (F5), (F6) |
| Endogenous | `inflation`, `inflationq`, `pic4`, `picnia` | annual/four-quarter and quarterly inflation measures | implementation_cross_check | (F7) |
| Endogenous | `outputgap`, `xgap`, `xgap2` | output-gap measures | source-stated concept; implementation_cross_check formula | (F8), (F10) |
| Endogenous | `output`, `xgdp_l`, `xgdpn_l` | real/nominal GDP aggregates | implementation_cross_check | (F9), (F11) |
| Endogenous | consumption block: `ec_l`, `ecd_l`, `eco_l`, `eh_l` | consumer spending and housing demand components | implementation_cross_check | (F3) |
| Endogenous | investment/capital block: `ebfi_l`, `kbfi_l`, `ki_l`, `ks_l`, `rtinv` | business fixed investment, capital stock, inventory investment, investment returns | implementation_cross_check | (F3), (F11) |
| Endogenous | labor block: `lfpr`, `lur`, `lurnat`, `lww_l`, `leg_l`, `leh_l` | labor force, unemployment, wages, employment | implementation_cross_check | (F3), (F16) |
| Endogenous | price block: `picxfe`, `pieci`, `pcnia_l`, `pcxfe_l`, `pipxnc`, `ptr` | core prices, compensation inflation, price levels, trend inflation | implementation_cross_check | (F3), (F18) |
| Endogenous | financial block: `rg5`, `rg10`, `rg30`, `req`, `rbbb`, `rtb`, `zrff5`, `zrff10`, `zrff30` | Treasury yields, equity returns, corporate bond rates, expected funds-rate paths | implementation_cross_check | (F4), (F16) |
| Endogenous | government block: `gfexpn_l`, `gfrecn_l`, `gfdbtn_l`, `gtr_l`, `trci`, `trp`, `fiscal`, `fiscalav` | government outlays, receipts, debt, transfers, fiscal stabilization | source-stated for ECFS; implementation_cross_check details | (F2), (F13)-(F15) |
| Exogenous shock | `interest_` | monetary policy shock | implementation_cross_check | (F5) |
| Exogenous shock | `fiscal_`, `fiscal_aerr` | discretionary fiscal / ECFS shock | source-stated for ECFS; implementation_cross_check mapping | (F2), (F13)-(F15) |
| Exogenous shocks | `*_aerr` residuals | equation residual shocks for expenditure, price, labor, financial, and external-sector equations | implementation_cross_check | (F12), (F16) |
| Parameters | `cofint*`, `std_r_` | policy-rule coefficients and shock scale | implementation_cross_check | (F5) |
| Parameters | `coffispol` | fiscal policy shock scale | implementation_cross_check | (F13) |
| Parameters | `y_*` | equation coefficients in the MMB implementation | implementation_cross_check | (F3)-(F16) |
| Scenario parameter | neutral nominal federal funds rate | 2, 3, or 4 percent in paper simulations | source-stated scenario assumption | (F18) |

Deferred issues:

- `needs_review`: obtain official LINVER package equations/manual for source-level equation extraction.
- `needs_review`: generate full variable/shock/parameter inventory mechanically from the `.mod`.
- `needs_review`: confirm whether the MMB file should be treated as `model(linear)` in Dynare metadata despite using plain `model;`.
- `deferred_runtime_validation`: run Dynare only in a later assigned validation phase.
