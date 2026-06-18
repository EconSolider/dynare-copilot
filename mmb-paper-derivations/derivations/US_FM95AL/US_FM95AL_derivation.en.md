# US_FM95AL - Derivation

> Archive entry for `US_FM95AL`. Source: Fuhrer and Moore (1995), "Inflation persistence," *Quarterly Journal of Economics* 110(1), 127-159, DOI `10.2307/2118513`. Runtime validation was not performed.

## 1. Model Overview

- **Model**: Fuhrer-Moore relative real contract-price model of U.S. inflation persistence.
- **Source mapping**: `raw/mmb_mineru/model_index.csv` maps `US_FM95AL` to the MinerU Markdown source `raw/mmb_mineru/runs/us_fm95_us_fm95al__inflation_persistence__c66e898c/full.md` with title-match score 1.0000.
- **Core mechanism**: staggered nominal contracts last four quarters. The aggregate log price level is a weighted average of outstanding contract prices. In the relative-contracting version, the current real contract price is set relative to overlapping real contract prices and expected excess demand.
- **Observable block**: the paper combines the contracting equations with reduced-form VAR equations for the output gap and the short bill rate so that expectations of excess demand are model-consistent.
- **Policy-use variant**: the paper's policy experiments add a nominal-output growth reaction function. The local MMB implementation cross-check instead wraps the contract block in a `model(linear)` policy-rule interface used by MMB optimal-control comparisons.
- **Form**: linear forward-looking model. The MMB file uses `model(linear)`. Variables are logs, rates, gaps, or auxiliary linear combinations, not nonlinear levels.

## 2. Optimization Problems

The paper does not provide a micro-founded household-firm optimization problem. It explicitly uses overlapping nominal contract-price equations motivated by wage bargaining. This archive therefore records the behavioral contract-setting problem rather than inventing omitted household or firm programs.

Contract setters choose the current nominal contract price \(x_t\). The contract remains in effect for four quarters with weights \(f_i\) on contracts negotiated in periods \(t-i\), \(i=0,\ldots,3\). In the relative version, setters compare real contract prices rather than nominal contract prices:

\[
x_t - p_t
\quad\text{is chosen relative to}\quad
E_t(v_{t+i}),\; i=0,\ldots,3,
\quad\text{and expected excess demand}\quad E_t(\tilde y_{t+i}).
\]

The behavioral objective is summarized by the relative contract equation in Section 3. There is no separate resource constraint, production technology, or intertemporal Euler condition in the paper-side model.

## 3. First-Order Conditions

- **(F1) Aggregate price index from outstanding nominal contracts**:

\[
p_t = \sum_{i=0}^{3} f_i x_{t-i}.
\]

- **(F2) Downward-sloping four-quarter contract distribution**:

\[
f_i = 0.25 + (1.5-i)s,\qquad 0 < s \leq \frac{1}{6},\qquad i=0,\ldots,3.
\]

- **(F3) Contract weights sum to one**:

\[
\sum_{i=0}^{3} f_i = 1,\qquad f_i \geq 0.
\]

- **(F4) Real contract-price index**:

\[
v_t = \sum_{i=0}^{3} f_i\bigl(x_{t-i}-p_{t-i}\bigr).
\]

- **(F5) Relative real contract-price equation**:

\[
x_t - p_t =
\sum_{i=0}^{3} f_i E_t\bigl(v_{t+i}+\gamma \tilde y_{t+i}\bigr)
+ \epsilon^p_t.
\]

- **(F6) Two-sided relative contracting representation**:

\[
x_t-p_t =
\sum_{i=1}^{3}\beta_i(x_{t-i}-p_{t-i})
+\sum_{i=1}^{3}\beta_iE_t(x_{t+i}-p_{t+i})
+\gamma^\ast\sum_{i=0}^{3} f_i E_t(\tilde y_{t+i})
+\epsilon^p_t.
\]

- **(F7) Overlap coefficients in the two-sided representation**:

\[
\beta_i =
\frac{\sum_j f_j f_{i+j}}{1-\sum_j f_j^2},
\qquad
\gamma^\ast =
\frac{\gamma}{1-\sum_j f_j^2}.
\]

- **(F8) Inflation definition**:

\[
\pi_t = p_t-p_{t-1}.
\]

- **(F9) Contract-price inflation identity**:

\[
\theta_t = x_t-x_{t-1},\qquad \pi_t=f(L)\theta_t,\qquad \theta_t=f^{-1}(L)\pi_t.
\]

- **(F10) Distributed-lag mapping from contract inflation to real contract price**:

\[
x_t-p_t =
f_1\theta_t + f_2(\theta_t+\theta_{t-1})
+f_3(\theta_t+\theta_{t-1}+\theta_{t-2})
= g(L)\theta_t.
\]

- **(F11) Relative-contracting two-sided Phillips curve**:

\[
\pi_t =
f(L)f(L^{-1})
\left[\pi_t+\gamma g^{-1}(L)y_t\right].
\]

- **(F12) Nested standard-versus-relative contract index**:

\[
v_t=\sum_{i=0}^{3}f_i\bigl(x_{t-i}-\delta p_{t-i}\bigr),
\qquad 0\leq \delta\leq 1.
\]

- **(F13) Nested standard-versus-relative contract equation**:

\[
x_t-\delta p_t =
\sum_{i=0}^{3}f_iE_t\bigl(v_{t+i}+\gamma\tilde y_{t+i}\bigr)
+\epsilon^p_t.
\]

The paper reports \(\delta=1\) as the relative-contracting restriction and \(\delta=0\) as the standard-contracting restriction. The data fail to reject the relative restriction and reject the standard restriction.

## 4. Market Clearing & Identities

- **(F14) Nominal-output growth identity used in policy experiments**:

\[
\Delta Y_t = \Delta p_t + \Delta y_t.
\]

- **(F15) Nominal-output growth reaction function for policy experiments**:

\[
\Delta Y_t =
\alpha_\pi(\pi_t-\bar\pi)+\alpha_y\tilde y_t.
\]

- **(F16) Alternative expected-price index for the appendix robustness check**:

\[
\bar p_t = \sum_{i=0}^{3} f_iE_t p_{t+i}.
\]

- **(F17) Alternative real contract-price index**:

\[
v_t=\sum_{i=0}^{3}f_i(x_{t-i}-\bar p_{t-i}).
\]

- **(F18) Alternative relative contract equation using \(\bar p_t\)**:

\[
x_t-\bar p_t=
\sum_{i=0}^{3}f_iE_t\bigl(v_{t+i}+\gamma\tilde y_{t+i}\bigr)
+\epsilon^p_t.
\]

The appendix estimates this alternative but reports that the main \(p_t\) definition is empirically preferred. These equations are recorded for source coverage; the main `US_FM95AL` archive interpretation is the paper's relative-contracting \(p_t\) specification.

## 5. Exogenous Processes

- **(F19) Generic linear forward-looking model representation**:

\[
\sum_{i=-\tau}^{0}H_ix_{t+i}
+\sum_{i=1}^{\theta}H_iE_t(x_{t+i})
=\epsilon_t.
\]

- **(F20) Future-expectations equation implied by the white-noise shock assumption**:

\[
\sum_{i=-\tau}^{\theta}H_iE_t(x_{t+k+i})=0,\qquad k>0.
\]

- **(F21) Saddlepath representation of expectations**:

\[
E_t(x_{t+k})=\sum_{i=-\tau}^{-1}B_iE_t(x_{t+k+i}),\qquad k>0.
\]

- **(F22) Observable structural representation after substituting expectations**:

\[
\sum_{i=-\tau}^{0}S_ix_{t+i}=\epsilon_t.
\]

- **(F23) Reduced-form output-gap equation used in the local MMB cross-check**:

\[
\tilde y_t = a_0+a_1\tilde y_{t-1}+a_2\tilde y_{t-2}+a_\rho\rho_{t-1}+\epsilon^y_t.
\]

- **(F24) Local MMB real-rate / nominal-rate relation cross-check**:

\[
\rho_t-D(\rho_{t+1}-\rho_t)=f_t-\pi_{t+1}.
\]

Equations (F23)-(F24) are marked `implementation_cross_check`: they are visible in the local MMB `.mod` file and consistent with the paper's statement that reduced-form equations for the output gap and bill rate are combined with the contracting equations, but the exact coefficient names and auxiliary variables are implementation-side evidence rather than paper-side derivation.

## 6. Steady-State Solution

Because the archive entry is linear / `model(linear)`, steady-state values are normalized to zero for variables expressed as deviations, differences, or inflation relative to baseline:

\[
\bar{\tilde y}=0,\qquad \bar\pi=0,\qquad \bar\theta=0,\qquad \bar\epsilon^p=\bar\epsilon^y=0.
\]

For a constant inflation rate \(\bar\pi\), the source records the steady-state real contract-price gap:

\[
\bar x_t-\bar p_t=\bar\pi\sum_{i=1}^{3}if_i.
\]

Under the zero-inflation linearization used in the local MMB implementation, this reduces to:

\[
\bar x-\bar p=0,\qquad \bar v=0.
\]

The implementation initializes `ytilde`, `ypsilon`, `infl`, `inflation`, `inflationq`, `output`, and `outputgap` at zero and chooses constants in the interest-rate block to center the auxiliary rate variables. Runtime steady-state validation was not performed.

## 7. Timing & Form Conventions

- **Timing**: contracts negotiated at \(t\) enter the price index contemporaneously and remain in the weighted index for four quarters through \(x_t,x_{t-1},x_{t-2},x_{t-3}\).
- **Expectations**: \(E_t(\cdot)\) conditions on period-\(t\) history. The contract equation contains expectations through \(t+3\) in the four-quarter specification.
- **Form**: linear forward-looking system. The MMB implementation uses `model(linear)` and variables such as `p`, `x`, `ytilde`, `infl`, and `rho` as log/rate/gap objects.
- **Stocks**: there are no capital or asset-stock accumulation equations in the paper-side contracting model.
- **Runtime validation**: not performed. Dynare was not run.
- **OCR status**: formulas in the main model block were legible in MinerU Markdown. The exact mapping from the paper's reduced-form VAR coefficients to MMB policy-rule interface variables remains `needs_review` because the local `.mod` comes from MMB implementation conventions and later Fuhrer/Wieland policy-rule usage.

## 8. Variable & Parameter Reference Table

| Category | Symbol / name | Meaning | Main equation |
|---|---|---|---|
| Endogenous | \(p_t\) / `p` | aggregate log price index | (F1) |
| Endogenous | \(x_t\) / `x` | nominal contract price | (F5), (F6) |
| Endogenous | \(v_t\) / `ypsilon` | real contract-price index | (F4), (F5) |
| Endogenous | \(\tilde y_t\) / `ytilde` | output gap / excess demand | (F5), (F23) |
| Endogenous | \(\pi_t\) / `infl` | inflation rate | (F8), (F11) |
| Endogenous | \(\theta_t\) | contract-price inflation | (F9), (F10) |
| Endogenous | \(\Delta Y_t\) | nominal-output growth in policy experiments | (F14), (F15) |
| Endogenous | \(\rho_t\) / `rho` | real-rate auxiliary in MMB implementation | (F24) |
| Endogenous | \(f_t\) / `f` | short nominal rate auxiliary in MMB implementation | (F24) |
| Exogenous shock | \(\epsilon^p_t\) / `epsilon_p` | contract-price / supply disturbance | (F5), (F13) |
| Exogenous shock | \(\epsilon^y_t\) / `epsilon_y` | output-gap reduced-form disturbance | (F23) |
| Exogenous shock | `interest_` | MMB policy-rule shock | implementation_cross_check |
| Parameter | \(f_i\) / `f0`-`f3` | contract-duration weights | (F2), (F3) |
| Parameter | \(s\) | slope of contract distribution | (F2) |
| Parameter | \(\gamma\) / `gamma` | excess-demand effect on contract prices | (F5) |
| Parameter | \(\beta_i\) | overlap coefficients | (F6), (F7) |
| Parameter | \(\gamma^\ast\) | scaled excess-demand coefficient | (F6), (F7) |
| Parameter | \(\delta\) | standard-relative nesting index | (F12), (F13) |
| Parameter | \(\alpha_\pi,\alpha_y\) | policy-experiment reaction coefficients | (F15) |
| Parameter | \(H_i,S_i,B_i\) | generic linear-system coefficient matrices | (F19)-(F22) |
| Parameter | \(a_0,a_1,a_2,a_\rho,D\) | MMB reduced-form / rate block coefficients | (F23), (F24) |
