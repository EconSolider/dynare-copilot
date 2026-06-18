# US_VMDno - Derivation (optimization problems + first-order conditions)

> This first-pass archive entry is source-backed by the MinerU Markdown listed below. It is not runtime validated. Formula quality is `needs_review` because the published article defers much of the CMR/SW base model to a separate appendix and the MinerU OCR has visible math artifacts.

**Provenance.** Model ID: `US_VMDno`. Paper: Verona, Fabio; Martins, Manuel M. F.; Drumond, Ines (2013), "(Un)anticipated Monetary Policy in a DSGE Model with a Shadow Banking System - Normal times", *International Journal of Central Banking* 9(3), pp. 78-124. DOI: `10.2139/ssrn.2256278`. Primary source Markdown: `raw/mmb_mineru/runs/us_vmdno_us_vmdop__un_anticipated_monetary_policy_in_a_dsge_model_with_a_shadow_banking_sys__9ba7c6c3/full.md`. Raw PDF: `raw/mmb_papers/(Un)anticipated monetary policy in a dsge model with a shadow banking system - Normal times.pdf`. MinerU run id: `9ba7c6c3-ab5d-4369-ab19-763c4740a11e`.

## 1. Model Overview

- **Model.** U.S. quarterly DSGE model extending the Christiano-Motto-Rostagno financial accelerator environment with a shadow-banking bond-finance sector. `US_VMDno` is the normal-times calibration: the optimism tier is shut down by setting the optimism sensitivity to zero.
- **Experiment.** Anticipated and unanticipated "too low for too long" monetary-policy paths hold the policy rate 100 basis points below steady state for six quarters, then return to the Taylor-type rule.
- **Agents.** Households save through deposits/bonds and supply differentiated labor; intermediate/final goods firms produce; capital producers transform investment into installed capital; entrepreneurs rent capital and finance it through either retail-bank loans or investment-bank-underwritten bonds; government balances its budget; the central bank follows a smoothed Taylor rule outside the policy experiment.
- **Model form.** The source and implementation cross-check indicate nonlinear equilibrium equations solved by first-order perturbation, with a parallel flexible-price block. This derivation records the main normal-times sticky-price block and flags the full base-model appendix equations as `needs_review`.

## 2. Optimization Problems

### 2.1 Safer LR Entrepreneur

Safer entrepreneurs use bond finance. At the end of period \(t\), the bond-financed acquisition of capital is

\[
B I_{t+1}^{LR,l}=Q_{\bar{k}',t}\bar{K}_{t+1}^{LR,l}-N_{t+1}^{LR,l}.
\]

The entrepreneur chooses utilization and next-period capital to maximize period profit:

\[
\Pi_t^{LR,l}
=\left[u_t^{LR,l}r_t^{k,LR}-a(u_t^{LR,l})\right]\bar{K}_t^{LR,l}P_t
+(1-\delta)Q_{\bar{k}',t}\bar{K}_t^{LR,l}
-Q_{\bar{k}',t}\bar{K}_{t+1}^{LR,l}
-R_t^{coupon}\left(Q_{\bar{k}',t-1}\bar{K}_t^{LR,l}-N_t^{LR,l}\right).
\]

### 2.2 Safer Entrepreneur Demand For Bond Underwriting

The entrepreneur minimizes the total repayment across monopolistically competitive investment banks:

\[
\min_{\{BI_{t+1}^{LR,l}(z)\}_{z\in[0,1]}}
\int_0^1\left[1+R_{t+1}^{coupon}(z)\right]BI_{t+1}^{LR,l}(z)\,dz
\]

subject to the Dixit-Stiglitz aggregator

\[
BI_{t+1}^{LR,l}
=\left\{\int_0^1\left[BI_{t+1}^{LR,l}(z)\right]^{\frac{\varepsilon_{t+1}^{coupon}-1}{\varepsilon_{t+1}^{coupon}}}dz\right\}^{\frac{\varepsilon_{t+1}^{coupon}}{\varepsilon_{t+1}^{coupon}-1}}.
\]

### 2.3 Investment Bank

The underwriter chooses the coupon rate on its bond issue, taking the household required return as the risk-free policy rate:

\[
\max_{R_{t+1}^{coupon}(z)}
\left\{\left[1+R_{t+1}^{coupon}(z)\right]BI_{t+1}^{LR,l}(z)
-\left[1+R_{t+1}^{e}\right]BI_{t+1}^{LR,l}(z)\right\}
\]

subject to the individual demand curve implied by the entrepreneur's aggregator.

### 2.4 Standard CMR/SW Blocks

The paper states that the rest of the model follows the CMR-FA environment: households with deposits/bonds and differentiated labor, intermediate firms with sticky prices and wages, capital producers with investment adjustment costs, riskier HR entrepreneurs with BGG-style retail-bank finance, and a government/central-bank block. The article points to Verona, Martins, and Drumond (2012), Appendix A for the complete equations; that appendix is not included in the current MinerU source. Formulas for these blocks below are therefore marked `needs_review` where they depend on the implementation cross-check rather than the article text.

## 3. First-Order Conditions

**Safer LR entrepreneurs and investment banks**

- **(F1) Bond-financed capital acquisition.**

\[
BI_{t+1}^{LR,l}=Q_{\bar{k}',t}\bar{K}_{t+1}^{LR,l}-N_{t+1}^{LR,l}.
\]

- **(F2) Utilization condition.**

\[
r_t^{k,LR}=a'\left(u_t^{LR,l}\right).
\]

- **(F3) Capital Euler equation.**

\[
Q_{\bar{k}',t}
=\beta E_t\left\{\left[u_{t+1}^{LR,l}r_{t+1}^{k,LR}-a(u_{t+1}^{LR,l})\right]P_{t+1}
+(1-\delta)Q_{\bar{k}',t+1}
-R_{t+1}^{coupon}Q_{\bar{k}',t}\right\}.
\]

- **(F4) Entrepreneur demand for funds from underwriter \(z\).**

\[
BI_{t+1}^{LR,l}(z)
=\left(\frac{1+R_{t+1}^{coupon}(z)}{1+R_{t+1}^{coupon}}\right)^{-\varepsilon_{t+1}^{coupon}}BI_{t+1}^{LR,l}.
\]

- **(F5) Average coupon-rate index.**

\[
1+R_{t+1}^{coupon}
=\left\{\int_0^1\left[1+R_{t+1}^{coupon}(z)\right]^{1-\varepsilon_{t+1}^{coupon}}dz\right\}^{\frac{1}{1-\varepsilon_{t+1}^{coupon}}}.
\]

- **(F6) Investment-bank markup condition.**

\[
1+R_{t+1}^{coupon}
=\frac{\varepsilon_{t+1}^{coupon}}{\varepsilon_{t+1}^{coupon}-1}\left(1+R_{t+1}^e\right).
\]

- **(F7) Bond-finance spread.**

\[
spread_{t+1}\equiv R_{t+1}^{coupon}-R_{t+1}^e
=\frac{1}{\varepsilon_{t+1}^{coupon}-1}\left(1+R_{t+1}^e\right).
\]

- **(F8) Safer-entrepreneur equity value.**

\[
V_t^{LR,l}
=\left\{\left[u_t^{LR,l}r_t^{k,LR}-a(u_t^{LR,l})\right]P_t+(1-\delta)Q_{\bar{k}',t}\right\}\bar{K}_t^{LR,l}
-\left(1+R_t^{coupon}\right)\left(Q_{\bar{k}',t-1}\bar{K}_t^{LR,l}-N_t^{LR,l}\right).
\]

- **(F9) Safer-entrepreneur net worth.**

\[
N_{t+1}^{LR,l}=\gamma^{LR}V_t^{LR,l}+W_t^{e,LR,l}.
\]

**Normal-times shadow-banking calibration**

- **(F10) Normal-times bond-demand elasticity.**

\[
\varepsilon_{t+1}^{normal}=\bar{\varepsilon}+\alpha_1\left(Y_t-\bar{Y}\right).
\]

- **(F11) Normal-times coupon rate.**

\[
1+R_{t+1}^{coupon,normal}
=\frac{\varepsilon_{t+1}^{normal}}{\varepsilon_{t+1}^{normal}-1}\left(1+R_{t+1}^{e}\right).
\]

- **(F12) Normal-times spread.**

\[
spread_{t+1}^{normal}
=\frac{1}{\varepsilon_{t+1}^{normal}-1}\left(1+R_{t+1}^{e}\right).
\]

**Optimism tier recorded for variant control; inactive in `US_VMDno`**

- **(F13) Optimism process.**

\[
\chi_t=\rho_\chi\chi_{t-1}+(1-\rho_\chi)\left[\bar{\chi}+\alpha_2\left(N_{t+1}^{LR,l}-N^{LR,l}\right)\right].
\]

For `US_VMDno`, \(\alpha_2=0\), so this tier is not the source of additional optimism dynamics.

- **(F14) Optimistic elasticity.**

\[
\varepsilon_{t+1}^{optimistic}=\varepsilon_{t+1}^{normal}(1+\chi_t).
\]

- **(F15) Optimistic coupon rate.**

\[
1+R_{t+1}^{coupon,optimistic}
=\frac{\varepsilon_{t+1}^{normal}(1+\chi_t)}{\varepsilon_{t+1}^{normal}(1+\chi_t)-1}(1+R_{t+1}^{e}).
\]

**Policy rule and standard model shell**

- **(F16) Taylor-type policy rule outside the fixed-rate experiment.**

\[
R_t^e
=\tilde{\rho}R_{t-1}^e
+(1-\tilde{\rho})\left[R^e+\alpha_\pi(E_t\pi_{t+1}-\bar{\pi})+\alpha_y(Y_t-\bar{Y})\right]
+\varepsilon_t^{MP}.
\]

- **(F17) Policy-experiment path.**

\[
R_t^e=R^e-0.01 \quad \text{for } t=1,\ldots,6,
\]

implemented either with residual unanticipated shocks each period or with a pre-announced anticipated shock sequence.

- **(F18) Household Euler equation, implementation cross-check, needs_review.**

\[
\lambda_t=\beta E_t\left[\lambda_{t+1}\frac{1+R_t^e}{\pi_{t+1}}\right].
\]

- **(F19) Habit-adjusted marginal utility, implementation cross-check, needs_review.**

\[
\lambda_t=(c_t-bc_{t-1})^{-\sigma_c}-b\beta E_t\left[(c_{t+1}-bc_t)^{-\sigma_c}\right].
\]

- **(F20) Investment adjustment-cost condition, implementation cross-check, needs_review.**

\[
\lambda_t q_t\left[1-\frac{S''}{2}\left(\frac{i_t}{i_{t-1}}-1\right)^2-S''\frac{i_t}{i_{t-1}}\left(\frac{i_t}{i_{t-1}}-1\right)\right]
-\lambda_t
+\beta E_t\left[\lambda_{t+1}q_{t+1}S''\left(\frac{i_{t+1}}{i_t}\right)^2\left(\frac{i_{t+1}}{i_t}-1\right)\right]=0.
\]

## 4. Market Clearing & Identities

- **(F21) CES aggregate capital services.**

\[
K_t=\left[\eta\left(u_t^{HR,r}\bar{K}_t^{HR,r}\right)^\rho+(1-\eta)\left(u_t^{LR,l}\bar{K}_t^{LR,l}\right)^\rho\right]^{1/\rho}.
\]

- **(F22) Goods-market resource constraint, implementation cross-check, needs_review.**

\[
Y_t=G_t+C_t+I_t+a(u_t^{HR})\eta\bar{K}_{t-1}^{HR}+a(u_t^{LR})(1-\eta)\bar{K}_{t-1}^{LR}+monitoring\ costs_t.
\]

- **(F23) Aggregate bond, bank, and total finance definitions.**

\[
B_t^{LR}=Q_t\bar{K}_t^{LR}-N_t^{LR},\qquad
Loans_t^{HR}=Q_t\bar{K}_t^{HR}-N_t^{HR},\qquad
Finance_t=(1-\eta)B_t^{LR}+\eta Loans_t^{HR}.
\]

- **(F24) Leverage definitions.**

\[
lev_t^{LR}=\frac{Q_t\bar{K}_t^{LR}}{N_t^{LR}},\qquad
lev_t^{HR}=\frac{Q_t\bar{K}_t^{HR}}{N_t^{HR}}.
\]

## 5. Exogenous Processes

- **(F25) Monetary-policy innovation.**

\[
\varepsilon_t^{MP}\sim iid(0,\sigma_{MP}^2).
\]

- **(F26) Optimism persistence process, inactive in normal-times calibration.**

\[
\chi_t=\rho_\chi\chi_{t-1}\quad\text{when }\alpha_2=0,\ \bar{\chi}=0.
\]

No additional exogenous technology or preference shock process is clearly extracted from the paper body for this first-pass entry. The implementation cross-check exposes one policy shock `e_xpU` in the MMB replication file.

## 6. Steady-State Solution

The article reports quarterly calibration and steady-state targets but does not provide a complete source-side steady-state algorithm for the full model. First-pass steady-state quality is therefore `needs_review`.

1. Set zero-inflation/steady policy objects and no optimism:

\[
\chi=0,\qquad \varepsilon^{normal}=\bar{\varepsilon},\qquad \alpha_2=0\quad(\text{for }US\_VMDno).
\]

2. Compute the normal-times steady coupon and spread:

\[
1+R^{coupon}=\frac{\bar{\varepsilon}}{\bar{\varepsilon}-1}(1+R^e),\qquad
spread=\frac{1}{\bar{\varepsilon}-1}(1+R^e).
\]

3. Use the reported calibration targets:

\[
\beta=0.9875,\quad \eta=0.2772,\quad \bar{\varepsilon}=510,\quad \alpha_1=30000,\quad \gamma^{LR}=0.96,\quad \gamma^{HR}=0.97.
\]

4. The source tables report, among other targets, \(C/Y=0.63\), \(I/Y=0.17\), \(G/Y=0.2\), a bond-bank finance ratio of \(1.5152\), a safer leverage ratio of \(1.26\), and a riskier leverage ratio of \(1.35\). Mapping those targets into the full steady-state system requires the deferred Appendix A equations or the MMB steady-state data file, so no closed-form solution is asserted here.

## 7. Timing & Form Conventions

- Physical capital is a stock chosen for use in the next period; the source writes acquisitions as \(BI_{t+1}^{LR,l}=Q_{\bar{k}',t}\bar{K}_{t+1}^{LR,l}-N_{t+1}^{LR,l}\).
- Capital services in production use utilization times pre-existing entrepreneurial capital. The implementation cross-check uses lagged capital in production-style equations; the exact paper-to-code timing should be reviewed against Appendix A.
- Coupon rates on bonds issued at the end of period \(t\) are indexed to repayment in period \(t+1\) in the investment-bank problem.
- `US_VMDno` is the normal-times version: equations (F13)-(F15) are documented for variant separation but the optimism sensitivity is set to zero.
- Runtime validation was not performed.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII hint | Meaning | Equation anchor |
|---|---|---|---|
| Endogenous | \(BI^{LR}\) / `btotBU`, `btotSU` | Bond finance for safer entrepreneurs | (F1), (F23) |
| Endogenous | \(Q\) / `qU` | Price of installed capital | (F1), (F3) |
| Endogenous | \(\bar{K}^{LR}\) / `kbarBU` | Safer-entrepreneur physical capital | (F1), (F21) |
| Endogenous | \(N^{LR}\) / `nBU` | Safer-entrepreneur net worth | (F8), (F9) |
| Endogenous | \(u^{LR}\) / `uBU` | Safer-entrepreneur capital utilization | (F2), (F21) |
| Endogenous | \(R^{coupon}\) / `RcouponXU` | Bond coupon rate | (F5), (F6), (F11) |
| Endogenous | \(R^e\) / `ReXU` | Risk-free policy/time-deposit rate | (F6), (F16) |
| Endogenous | \(\varepsilon^{coupon}\) / `eps_couponU` | Demand elasticity for bond funds | (F4), (F10) |
| Endogenous | \(spread\) / `SpreadU` | Bond-finance spread | (F7), (F12) |
| Endogenous | \(Y\) / `YU` | Output | (F10), (F16), (F21), (F22) |
| Endogenous | \(c,i,\pi,\lambda\) / `cU`, `iU`, `piU`, `lambdanU` | Consumption, investment, inflation, household marginal utility | (F18)-(F20), needs_review |
| Endogenous | \(lev^{LR},lev^{HR}\) / `levBU`, `levSU` | Leverage ratios | (F24) |
| Exogenous | \(\varepsilon^{MP}\) / `e_xpU` | Monetary-policy innovation | (F16), (F25) |
| Parameter | \(\beta\) / `betaUU` | Discount factor | (F3), (F18), (F20) |
| Parameter | \(\eta\) / `etaSE` | Share of riskier entrepreneurs | (F21), (F23) |
| Parameter | \(\rho\) / `rhoEIS` | Substitutability across capital services | (F21) |
| Parameter | \(\bar{\varepsilon}\) / `eps_couponUU` | Steady-state bond-demand elasticity | (F10)-(F12) |
| Parameter | \(\alpha_1\) / `alpha4` in implementation | Normal-times sensitivity of elasticity to output gap | (F10) |
| Parameter | \(\alpha_2\) / `alpha3` in implementation | Optimism sensitivity; zero in `US_VMDno` | (F13) |
| Parameter | \(\rho_\chi\) / `rho_chi` | Persistence in optimism | (F13), (F26) |
| Parameter | \(\gamma^{LR},\gamma^{HR}\) / `gammaBUU`, `gammaSUU` | Entrepreneur survival probabilities | (F9) |
| Parameter | \(\tilde{\rho},\alpha_\pi,\alpha_y\) / `rhotilUU`, `aptilUU`, `aytilUU` | Monetary-policy rule coefficients | (F16) |
| Parameter | \(S''\) / `SdouprXUU` | Investment adjustment-cost curvature | (F20) |
| Status | `needs_review` | Missing/deferred Appendix A and OCR-sensitive formulas | Whole entry |
