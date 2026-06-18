# EA_ALSV06 -- Derivation (Optimization Problems + First-Order Conditions)

> First-pass private archive entry. Status: `needs_review`. Runtime validation was not performed.

Provenance: `EA_ALSV06` is based on Javier Andres, J. David Lopez-Salido, and Javier Valles, "Money in an estimated business cycle model of the euro area", *The Economic Journal* 116, April 2006, pp. 457-477, DOI `10.1111/j.1468-0297.2006.01088.x`. The extraction uses `raw/mmb_mineru/runs/ea_alsv06__money_in_an_estimated_business_cycle_model_of_the_euro_area__21baa95d/full.md`. The raw PDF path exists at `raw/mmb_papers/Money in an estimated business cycle model of the euro area.pdf` but the PDF body was not read. No appendix normalization exists for this model. The MMB replication file `.agents/skills/dynare-copilot/references/examples/EA_ALSV06_rep.mod` was used only as an implementation cross-check.

## 1. Model Overview

- **Model**: Small estimated sticky-price DSGE model for the euro area with money in utility, habit formation, hybrid inflation dynamics, money demand, and an augmented Taylor rule.
- **MMB variant**: `EA_ALSV06` corresponds to the working-paper/replication variant with separable CRRA preferences and habits. The implementation cross-check is a `model(linear)` system with endogenous variables `y, m, r, mu, pi, mc, a, e, z`.
- **Agents**: A representative household chooses consumption, labor, money, and bonds; monopolistically competitive firms produce differentiated goods and set prices under Calvo-style nominal rigidity with a possible backward-looking pricing component; the monetary authority sets the nominal interest rate using output, inflation, and money growth.
- **Form**: Log-linear `model(linear)`. Variables with hats are deviations from steady state or detrended/log-linear quantities. First-pass status is `needs_review` because the Markdown OCR has minor accent/notation damage and the archive entry has not been source-level checked against the PDF.

## 2. Optimization Problems

### 2.1 Household

The paper starts from a representative household problem with real balances and habits:

\[
\max_{\{C_t,N_t,M_t,B_t\}} E_0 \sum_{t=0}^{\infty}\beta^t a_t
\left[
\Psi\left(C_t^{\ast},\frac{M_t}{e_t P_t}\right)
- \frac{N_t^{1+\varphi}}{1+\varphi}
\right],
\qquad C_t^{\ast}=\frac{C_t}{C_{t-1}^{h}} .
\]

The period budget constraint is:

\[
\frac{M_{t-1}+B_{t-1}+W_tN_t+T_t+D_t}{P_t}
= C_t + \frac{B_t/r_t+M_t}{P_t}.
\]

For the MMB `EA_ALSV06` replication variant, the paper's separable CRRA preference restriction is used:

\[
U\left(C_t,\frac{M_t}{e_tP_t}\right)
= \frac{1}{1-\sigma}\left(\frac{C_t}{C_{t-1}^{h}}\right)^{1-\sigma}
+ \frac{1}{1-\delta}\left(\frac{M_t}{e_tP_t}\right)^{1-\delta}.
\]

### 2.2 Firms

Final demand is CES over varieties. A representative differentiated goods producer has production technology:

\[
Y_t(j)=z_t N_t(j)^{1-\alpha}.
\]

Firms set nominal prices with Calvo rigidity. The paper allows a fraction of resetters to be backward-looking, yielding a hybrid Phillips curve in equilibrium.

### 2.3 Monetary Authority

The policy rule closes the model:

\[
\ln(r_t/r)=\rho_r\ln(r_{t-1}/r)
+(1-\rho_r)\rho_\pi\ln(\pi_t/\pi)
+(1-\rho_r)\rho_y\ln(Y_t/Y)
+(1-\rho_r)\rho_\mu\ln(\mu_t/\mu)
+\varepsilon_{r_t}.
\]

## 3. First-Order Conditions

The source paper reports the symmetric equilibrium as a log-linear system. The MMB variant uses the separable CRRA specialization, so equations (15)-(17) replace the corresponding general money-in-utility equations while the policy rule, money-growth identity, Phillips curve, and shock processes remain as in equations (7)-(13).

- **(F1) Intertemporal allocation / IS relation** (`needs_review`: transcribed from paper equation (15), expectation notation normalized):

\[
\widehat{y}_t
= \frac{\phi_1}{\phi_1+\phi_2}\widehat{y}_{t-1}
+ \frac{\beta\phi_1+\phi_2}{\phi_1+\phi_2}E_t\widehat{y}_{t+1}
- \frac{1}{\phi_1+\phi_2}\left(\widehat{r}_t-E_t\widehat{\pi}_{t+1}\right)
- \frac{\beta\phi_1}{\phi_1+\phi_2}E_t\widehat{y}_{t+2}
+ \frac{1-\beta h\rho_a}{1-\beta h}\frac{1-\rho_a}{\phi_1+\phi_2}\widehat{a}_t .
\]

- **(F2) Money demand** (`needs_review`: transcribed from paper equation (16); sign of the velocity-shock term differs between OCR paper text and `.mod` convention, so this follows the paper text and is flagged):

\[
\widehat{m}_t
= -\frac{\phi_1}{\delta}\widehat{y}_{t-1}
+ \frac{\phi_2}{\delta}\widehat{y}_t
- \frac{\beta\phi_1}{\delta}E_t\widehat{y}_{t+1}
- \frac{1}{\delta(r-1)}\widehat{r}_t
+ \frac{\beta h(1-\rho_a)}{(1-\beta h)\delta}\widehat{a}_t
+ \frac{\delta-1}{\delta}\widehat{e}_t .
\]

- **(F3) Monetary policy rule**:

\[
\widehat{r}_t
= \rho_r\widehat{r}_{t-1}
+(1-\rho_r)\rho_y\widehat{y}_t
+(1-\rho_r)\rho_\pi\widehat{\pi}_t
+(1-\rho_r)\rho_\mu\widehat{\mu}_t
+\varepsilon_{r_t}.
\]

- **(F4) Money-growth identity**:

\[
\widehat{\mu}_t=\widehat{m}_t-\widehat{m}_{t-1}+\widehat{\pi}_t .
\]

- **(F5) Hybrid New Keynesian Phillips curve**:

\[
\widehat{\pi}_t
= \gamma_f E_t\widehat{\pi}_{t+1}
+\gamma_b\widehat{\pi}_{t-1}
+\lambda\widehat{mc}_t .
\]

- **(F6) Real marginal cost relation** (`needs_review`: transcribed from paper equation (17), using the separable CRRA restriction):

\[
\widehat{mc}_t
= -\phi_1\widehat{y}_{t-1}
+(\chi+\phi_2)\widehat{y}_t
-\beta\phi_1E_t\widehat{y}_{t+1}
-(1+\chi)\widehat{z}_t
-\frac{\beta h(1-\rho_a)}{1-\beta h}\widehat{a}_t .
\]

The CRRA coefficient definitions used by this variant are:

\[
\phi_1=\frac{(\sigma-1)h}{1-\beta h},
\qquad
\phi_2=\frac{\sigma+(\sigma-1)\beta h^2-\beta h}{1-\beta h}.
\]

## 4. Market Clearing & Identities

- **(F7) Goods-market clearing in the symmetric equilibrium**:

\[
Y_t=C_t .
\]

This condition is stated in the firm-behavior section before the log-linear equilibrium system. In the reduced `model(linear)` implementation, `y` is the output/consumption allocation variable rather than a separate consumption variable.

- **(F8) Money growth definition in levels**:

\[
\mu_t=\frac{M_t}{M_{t-1}},
\qquad
\widehat{\mu}_t=\widehat{m}_t-\widehat{m}_{t-1}+\widehat{\pi}_t .
\]

Equation (F8) duplicates the identity represented by (F4) in log-linear form; it is included here to document the market-clearing/identity origin of the `mu` variable. In an implementation equation count, use (F4), not both (F4) and (F8).

## 5. Exogenous Processes

- **(F9) Preference/demand shock**:

\[
\widehat{a}_t=\rho_a\widehat{a}_{t-1}+\varepsilon_{a_t}.
\]

- **(F10) Velocity or money-demand shock**:

\[
\widehat{e}_t=\rho_e\widehat{e}_{t-1}+\varepsilon_{e_t}.
\]

- **(F11) Technology/supply shock**:

\[
\widehat{z}_t=\rho_z\widehat{z}_{t-1}+\varepsilon_{z_t}.
\]

- **(F12) Monetary-policy shock**:

\[
\varepsilon_{r_t}\ \text{enters the interest-rate rule (F3) directly.}
\]

## 6. Steady-State Solution

Because `EA_ALSV06` is a log-linear `model(linear)` entry, the model variables are expressed as deviations from steady state:

\[
\widehat{y}=\widehat{m}=\widehat{r}=\widehat{\mu}=\widehat{\pi}
=\widehat{mc}=\widehat{a}=\widehat{e}=\widehat{z}=0.
\]

The steady-state gross nominal interest-rate level appears as `rss` in the money-demand coefficient:

\[
r_{ss}=\exp(0.0224)
\]

in the implementation cross-check. The paper's CRRA/separable estimates correspond to approximately \(\beta=0.9876\), \(\sigma\approx1.0573\), \(h\approx0.9025\), \(\delta=108.76\), \(\gamma_f\approx0.9876\), \(\gamma_b\approx0\), \(\lambda\approx1.1939\), and persistence parameters near those in Table 2. These numerical values are recorded as implementation cross-checks, not as newly verified calibration from the PDF body.

## 7. Timing & Form Conventions

- **Form**: `model(linear)` log-linear system. Hatted variables denote deviations from steady-state or detrended/log-linear observables.
- **Expectations**: Forward-looking terms such as \(E_t\widehat{y}_{t+1}\), \(E_t\widehat{y}_{t+2}\), and \(E_t\widehat{\pi}_{t+1}\) are dated with information at \(t\).
- **Predetermined/lags**: The IS relation uses \(\widehat{y}_{t-1}\); the policy rule uses \(\widehat{r}_{t-1}\); the money-growth identity uses \(\widehat{m}_{t-1}\); the Phillips curve includes \(\widehat{\pi}_{t-1}\) when \(\gamma_b\ne0\).
- **Stocks and capital**: There is no physical capital stock in this small-scale model; production uses labor and a technology shock only.
- **Money convention**: `m` is real balances, `mu` is money growth, and `e` is a velocity/money-demand shock. The paper emphasizes the real-balances gap \(\widehat{m}_t-\widehat{e}_t\) in the general nonseparable model, while the MMB variant imposes separable CRRA preferences.
- **Runtime validation**: Not performed.

## 8. Variable & Parameter Reference Table

### Endogenous Variables

| Symbol | Meaning | Main equation |
|---|---|---|
| `y`, \(\widehat{y}_t\) | Detrended/log-linear output; equals consumption in symmetric equilibrium | (F1), (F7) |
| `m`, \(\widehat{m}_t\) | Real balances | (F2), (F4) |
| `r`, \(\widehat{r}_t\) | Nominal interest-rate deviation in the implementation convention | (F3) |
| `mu`, \(\widehat{\mu}_t\) | Money growth | (F4), (F8) |
| `pi`, \(\widehat{\pi}_t\) | Inflation | (F5) |
| `mc`, \(\widehat{mc}_t\) | Real marginal cost | (F6) |
| `a`, \(\widehat{a}_t\) | Preference/demand shock state | (F9) |
| `e`, \(\widehat{e}_t\) | Velocity/money-demand shock state | (F10) |
| `z`, \(\widehat{z}_t\) | Technology/supply shock state | (F11) |

### Exogenous Shocks

| Symbol | Meaning |
|---|---|
| `epsa`, \(\varepsilon_{a_t}\) | Innovation to preference/demand shock |
| `epse`, \(\varepsilon_{e_t}\) | Innovation to velocity/money-demand shock |
| `epsz`, \(\varepsilon_{z_t}\) | Innovation to technology/supply shock |
| `epsr`, \(\varepsilon_{r_t}\) | Monetary-policy shock |

### Parameters

| Symbol | Meaning |
|---|---|
| \(\beta\) / `beta` | Discount factor |
| \(\sigma\) / `sigma` | CRRA curvature, inverse intertemporal elasticity |
| \(h\) / `h` | Habit parameter |
| \(\delta\) / `delta` | Curvature governing money demand in the CRRA/separable restriction |
| \(\phi_1,\phi_2\) / `phi1`, `phi2` | Composite habit/preference coefficients |
| \(\gamma_f,\gamma_b\) / `gammaf`, `gammab` | Forward- and backward-looking Phillips-curve weights |
| \(\lambda\) / `lambda` | Phillips-curve slope on real marginal cost |
| \(\chi\) / `chi` | Composite labor-supply/decreasing-returns parameter |
| \(\rho_r,\rho_y,\rho_\pi,\rho_\mu\) | Interest-rate smoothing and policy responses |
| \(\rho_a,\rho_e,\rho_z\) | Shock persistence parameters |
| \(\sigma_a,\sigma_e,\sigma_z,\sigma_r\) | Shock standard deviations |
| \(r_{ss}\) / `rss` | Steady-state gross nominal interest-rate level |
