# US_FRB22_mcapwp - Derivation (first-pass source extraction)

> Model archive entry for `US_FRB22_mcapwp`. Status: `needs_review`.
> Runtime validation was not performed. The `.mod` files listed here were used only as `implementation_cross_check` evidence.

Source provenance:

- Paper: "LINVER: The Linear Version of FRB/US"
- Authors: Flint Brayton; David Reifschneider
- Year: 2022
- DOI: `10.17016/feds.2022.053`
- Source Markdown: `raw/mmb_mineru/runs/us_frb22_mcap_us_frb22_mcapwp_us_frb22_mceall_us__linver_the_linear_version_of_frb_us__a8780356/full.md`
- Raw PDF: `raw/mmb_papers/LINVER- The Linear Version of FRB:US.pdf`
- MinerU run id: `a8780356-98b8-4931-bad6-3b2c5b4b2f0c`
- Appendix normalization: none found for `US_FRB22_mcapwp`

## 1. Model Overview

`US_FRB22_mcapwp` is a Modelbase variant of LINVER, the linear version of the Federal Reserve Board's FRB/US model. The paper describes LINVER as a large-scale linear macroeconometric model used for U.S. policy simulations, especially simulations with model-consistent expectations and occasionally binding effective-lower-bound policy constraints.

The specific `mcapwp` variant is identified from the local MMB implementation as the case with model-consistent expectations in financial markets and in wage-price setting, while other expectations are based on estimated small VARs. This variant label is an `implementation_cross_check`; the paper discusses this expectation regime, but the exact MMB model id is not paper-side notation.

Model form: linearized macroeconometric system. The paper says LINVER is built by classifying variables as level-linearized or log-linearized, replacing some variables that cannot safely be log-linearized, and evaluating a symbolic linearization around data close to 2018-2019 average conditions. The local MMB `.mod` uses a plain `model;` block rather than `model(linear)`, but the equations are linear in deviations and lags/leads.

The paper is not a compact structural-equation appendix. It gives methodology, expectation regimes, policy-rule examples, stochastic-simulation design, and tables/figures. The full equation list and coefficient values are present in the local implementation, not in the paper Markdown; formula-level reconstruction is therefore marked `needs_review`.

## 2. Optimization Problems

No household, firm, government, or central-bank optimization problem is explicitly derived in the paper-side source. LINVER is presented as a linearized version of the large FRB/US macroeconometric model rather than as a small DSGE system with a small set of primitive objectives and constraints.

The paper-side structure supports the following economic blocks, but not complete primitive optimization statements:

- Spending blocks for consumption, business fixed investment, housing, imports, exports, inventories, and government/fiscal variables.
- Labor-market and wage-price blocks, including an expectation regime where wage-price expectations can be model consistent.
- Financial-market blocks for the federal funds rate, Treasury yields, term premiums, equity and credit conditions, and exchange-rate channels.
- Policy blocks for inertial Taylor-type rules, average-inflation-targeting rules, make-up/change rules, threshold liftoff conditions, the ELB, and fiscal-stabilization options.

`needs_review`: source-level optimization problems are unavailable in the MinerU Markdown. The local `.mod` confirms a large linear equation system but is not used as a paper-side mathematical source.

## 3. First-Order Conditions

Because the paper-side source does not present primitive optimization problems, it also does not provide source-level first-order conditions. The following formulas are extracted as high-level equilibrium/policy relationships visible in the paper and should be read as source-backed model relationships, not full FOCs.

- **(F1) Generic inertial monetary policy rule** (`needs_review` because OCR uses placeholder characters in nearby text):

\[
R_t = \alpha R_{t-1} + (1-\alpha)\left[r^{\ast} + \pi_t + \beta(\pi_t-\pi^{\ast}) + \gamma Y_t\right]
\]

- **(F2) LINVER state-space representation** (`needs_review` because the paper states the reduced-form idea but does not print a full matrix system):

\[
A_0 x_t + A_1 x_{t-1} + A_f E_t x_{t+1} + B \varepsilon_t = 0
\]

- **(F3) Reduced form under a stable linear model** (`needs_review`; inferred from the paper's discussion of eliminating leads in the unique reduced form):

\[
x_t = H x_{t-1} + G \varepsilon_t
\]

The local `US_FRB22_mcapwp.mod` contains 274 named equations and a much larger number of assignment/equation lines. Those equations are recorded as `implementation_cross_check` evidence only and are not copied here as paper-side derivations.

## 4. Market Clearing & Identities

The paper does not print a complete set of market-clearing equations. It describes the variables and simulation outputs used to compare LINVER and FRB/US, including output gap, unemployment gap, PCE inflation, core PCE inflation, the federal funds rate, and Treasury yields.

- **(F4) Federal funds rate change identity** (`implementation_cross_check`; visible in the local `.mod`, not in the paper):

\[
\Delta rff_t = rff_t - rff_{t-1}
\]

- **(F5) Real federal funds rate identity** (`implementation_cross_check`; visible in the local `.mod`, not in the paper):

\[
rrff_t = rff_t - \frac{1}{4}\left(picxfe_t + picxfe_{t-1} + picxfe_{t-2} + picxfe_{t-3}\right)
\]

- **(F6) Modelbase output and price reporting identities** (`implementation_cross_check`; visible in the local `.mod`, not in the paper):

\[
interest_t = rff_t,\qquad inflation_t = pic4_t,\qquad outputgap_t = xgap2_t
\]

`needs_review`: the paper refers to full FRB/US/LINVER sectors but does not expose the full accounting identities in paper-side mathematical form.

## 5. Exogenous Processes

The paper describes stochastic simulations using historical equation residuals, bootstrapping, state-contingent sampling, and rescaled wage-price shocks. It also lists broad shock groups such as consumption, investment, exports/imports, government, productivity, premiums, foreign activity, wages, and prices.

- **(F7) Generic linear shock-driven equation residual representation** (`needs_review`; paper-level abstraction, not a printed equation):

\[
u_{j,t} = e_{j,t},\qquad e_{j,t}\sim \mathcal{D}_{hist}
\]

- **(F8) State-contingent sampling law** (`needs_review`; summarizes the paper's three-state simulation design):

\[
e_t \sim \mathcal{D}(s_t),\qquad s_t\in\{\text{normal},\text{mild slump},\text{severe slump}\}
\]

- **(F9) Fiscal-stabilization impulse mapping** (`needs_review`; paper appendix concept, not a full structural equation):

\[
fiscal_t = \kappa_{fs}\,\varepsilon^{fiscal}_t
\]

Implementation cross-check: the local `US_FRB22_mcapwp.json` lists many equation residual shocks plus `interest_` and `fiscal_`; the local `.mod` adds exogenous controls and dummy variables used in the modelbase package.

## 6. Steady-State Solution

LINVER is not linearized around a textbook deterministic steady state. The paper states that the current version is linearized around average 2018-2019 conditions for key macro variables, with stock variables chosen from data not too far from recent values. Therefore a conventional DSGE steady-state derivation is unavailable from the paper-side source.

- **(F10) Linearization point definition** (`needs_review`; paper-level normalization):

\[
x_t = X_t - \bar X_{2018-2019}\quad\text{or}\quad x_t = \log X_t - \log \bar X_{2018-2019}
\]

- **(F11) Baseline zero-gap convention for reported gaps** (`needs_review`; simulation convention):

\[
\bar{xgap2}=0,\qquad \bar{ugap}=0,\qquad \bar{\pi}^{core}=0\ \text{as deviation from baseline/target}
\]

There is no `steady_state_model` reconstruction in this first-pass entry. Runtime validation and exact steady-state/baseline replication are deferred.

## 7. Timing & Form Conventions

LINVER is a quarterly linear model with rich lag and lead structure. In the local implementation cross-check, the `US_FRB22_mcapwp.mod` model block contains many lagged terms, some forward-looking terms, and equations for expected future short rates such as `zrff5`, `zrff10`, and `zrff30`.

Timing conventions:

- Backward-looking terms use lags such as \(x_{t-1}\), \(x_{t-2}\), etc.
- Model-consistent expectation blocks introduce future-dated variables, especially in financial-market and wage-price channels for this variant.
- Policy constraints such as the ELB are nonlinear constraints imposed by solution routines on an otherwise linear model; they are not part of the base linear equation system.
- The MMB implementation includes policy-rule placeholders and generated modelbase variables for `interest`, `inflation`, `inflationq`, `outputgap`, `output`, and `fispol`.

Form convention: linearized macroeconometric model. Use `needs_review` for any claim that depends on exact paper-to-code equation mapping.

## 8. Variable & Parameter Reference Table

| Category | Symbol / name | Meaning | Source status |
|---|---|---|---|
| Endogenous | `rff` | Federal funds rate | source-stated concept; implementation variable |
| Endogenous | `rrff` | Real federal funds rate | implementation_cross_check |
| Endogenous | `xgap2` | Output gap reporting variable | source-stated concept; implementation variable |
| Endogenous | `ugap` | Unemployment gap | source-stated concept; implementation variable |
| Endogenous | `pic4` | Four-quarter inflation reporting variable | implementation_cross_check |
| Endogenous | `picxfe` | Core PCE inflation component used in implementation | implementation_cross_check |
| Endogenous | `rg5`, `rg10`, `rg30` | Treasury yields / long-rate variables | source-stated concept; implementation variable |
| Endogenous | `zrff5`, `zrff10`, `zrff30` | Expected future short-rate components for term structure | implementation_cross_check |
| Endogenous | `fiscal`, `fiscalav`, `fiscal_aerr` | Fiscal-stabilization reporting/shock variables | source-stated concept; implementation variable |
| Exogenous | `interest_` | Monetary policy shock | implementation_cross_check |
| Exogenous | `fiscal_` | Fiscal policy shock | implementation_cross_check |
| Exogenous | `*_aerr` | Equation residual shocks | implementation_cross_check |
| Parameter | `cofint*` | Modelbase policy-rule coefficients | implementation_cross_check |
| Parameter | `std_r_`, `std_r_quart` | Monetary policy shock scales | implementation_cross_check |
| Parameter | `coffispol` | Fiscal-policy shock scaling | implementation_cross_check |
| Parameter | `tax_gamma` | Fiscal countercyclicality parameter discussed in paper | source-stated concept |
| Parameter | ELB | Effective lower bound imposed by solution routine | source-stated concept |
| Parameter | `r^*` | Neutral real/nominal rate component in policy examples | source-stated concept |
| Parameter | `\alpha,\beta,\gamma` | Generic inertial rule coefficients in paper examples | source-stated concept |

Implementation cross-check counts:

- `US_FRB22_mcapwp.mod`: 319 endogenous `var` tokens before `varexo`; 124 `varexo` tokens before `parameters`; 274 named equations in the `model` block.
- `.agents/skills/dynare-copilot/references/examples/US_FRB22_rep.mod`: generic FRB22 example with 284 endogenous `var` tokens and 117 `varexo` tokens.

First-pass archive status: `needs_review`, because the paper-side Markdown does not expose the full equation list, OCR has placeholder characters in some printed policy-rule formulas, and the MMB `.mod` equation system has not been source-level reconciled with the paper/package documentation.
