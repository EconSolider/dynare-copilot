# EA_QR14 - Derivation

> First-pass private MMB archive entry. Status: `needs_review`; formulas come from MinerU Markdown OCR and were not checked against the PDF body.

Provenance: `EA_QR14`, Dominic Quint and Pau Rabanal (2014), "Monetary and Macroprudential Policy in an Estimated DSGE Model of the Euro Area", *International Journal of Central Banking* 10(2), 169-236. DOI recorded in `model_index.csv`: `10.5089/9781484333693.001`. Main source: `raw/mmb_mineru/runs/ea_qr14__monetary_and_macroprudential_policy_in_an_estimated_dsge_model_of_the_eu__78d59631/full.md`. Raw PDF exists at `raw/mmb_papers/Monetary and Macroprudential Policy in an Estimated DSGE Model of the Euro Area.pdf`; PDF body was not read. MinerU run id: `78d59631-1509-497c-b15f-d57584562569`. Appendix normalization: none found. Implementation cross-check: `.agents/skills/dynare-copilot/references/examples/EA_QR14_rep.mod`.

## 1. Model Overview

- **Model**: estimated two-country euro-area DSGE model with core and periphery blocks, two sectors, two household types, financial frictions in mortgage credit, a common ECB monetary rule, and national macroprudential instruments.
- **Countries**: home country has population weight \(n\); foreign country has weight \(1-n\). Foreign variables are denoted by a star or, in the Rep-MMB implementation, by `_s`.
- **Sectors and goods**: non-durable goods are traded across countries; durable goods are non-tradable and interpreted as housing. Each country has Calvo pricing in the non-durable and durable sectors.
- **Households**: savers, share \(\lambda\), and borrowers, share \(1-\lambda\), consume non-durables, accumulate durable housing, and supply labor to both sectors. Borrowers are more impatient and borrow against housing collateral.
- **Financial block**: domestic intermediaries collect saver deposits and lend to borrowers. Borrower default arises when idiosyncratic housing quality shocks push collateral below debt. Macroprudential policy shifts the fraction of liabilities banks can lend and therefore affects the lending-deposit spread.
- **Open-economy block**: international intermediaries link domestic and foreign funding markets through a risk premium depending on net foreign assets.
- **Model form**: Appendix 2 presents linearized conditions around a balanced-growth steady state. The Rep-MMB file implements a nonlinear `model` block in exponentiated stationary variables and then solves a first-order approximation. This archive entry records the linearized paper equations as the paper-side source and uses the `.mod` only as `implementation_cross_check`.
- **Runtime validation**: not performed.

## 2. Optimization Problems

### Savers

Savers choose non-durable consumption \(C_t\), durable housing stock \(D_t\), residential investment \(I_t\), labor in the non-durable and durable sectors, and deposits/bonds. Preferences combine habit-adjusted non-durable consumption, housing services, and total labor:

\[
E_0\sum_{t=0}^{\infty}\beta^t\left[
\gamma \xi_t^C \log(C_t-\varepsilon C_{t-1}/A_t)
+(1-\gamma)\xi_t^D\log D_t
-\frac{L_t^{1+\varphi}}{1+\varphi}
\right].
\]

Total labor is a CES-style aggregate of sectoral hours:

\[
L_t=\left[\alpha^{-\iota_L}(L_t^C)^{1+\iota_L}+(1-\alpha)^{-\iota_L}(L_t^D)^{1+\iota_L}\right]^{1/(1+\iota_L)}.
\]

Durable housing evolves with depreciation and installation costs in the nonlinear implementation; Appendix 2 records the linear law of motion after trend normalization.

### Borrowers

Borrowers solve the analogous problem with \(\beta^B<\beta\) and habit parameter \(\varepsilon^B\). Their budget constraint includes new credit \(\tilde S_t^B\), repayment on performing debt, foreclosure/default settlement terms, durable investment, and labor income from both sectors. Borrowers face mortgage rates \(R_t^L\), default thresholds, and default-rate functions determined by the financial intermediary block.

### Domestic financial intermediaries

Domestic intermediaries take saver deposits, grant loans to borrowers, and impose a zero-profit/participation condition equating funding cost to expected returns from performing loans and foreclosure settlement. A macroprudential wedge \(\eta_t\) shifts credit supply.

### Firms and price setters

Non-durable and durable firms produce with sectoral labor and sectoral technology. Monopolistic competitors set prices under Calvo contracts with lagged inflation indexation, giving two New Keynesian Phillips curves in each country.

### Monetary and macroprudential authorities

The ECB sets the common nominal policy rate with smoothing, euro-area CPI inflation, and euro-area output growth. National macroprudential instruments react to a credit indicator, either nominal credit growth or credit-to-GDP in the policy experiments.

## 3. First-Order Conditions

The following equations renumber the source's Appendix 2 conditions continuously for this archive entry. Starred foreign-country conditions are symmetric and omitted where no additional structure is introduced.

- **(F1) Saver housing-investment Euler equation**:

\[
q_t+\xi_t^C-\frac{c_t-\varepsilon(c_{t-1}-\varepsilon_t^A)}{1-\varepsilon}
+\psi(i_t-i_{t-1}+\varepsilon_t^A)
=E_t\varrho_{t+1}+\beta\psi(E_t i_{t+1}-i_t).
\]

- **(F2) Saver durable demand shadow value**:

\[
[1-\beta(1-\delta)](\xi_t^D-d_t)=\varrho_t-\beta(1-\delta)E_t\varrho_{t+1}.
\]

- **(F3) Saver non-durable Euler equation**:

\[
\varepsilon(\Delta c_t+\varepsilon_t^A)
=E_t\Delta c_{t+1}-(1-\varepsilon)(r_t+E_t\Delta\xi_{t+1}^C-E_t\Delta p_{t+1}^C).
\]

- **(F4) Saver labor supply, non-durable sector**:

\[
[(\varphi-\iota_L)\alpha+\iota_L]l_t^C
+(\varphi-\iota_L)(1-\alpha)l_t^D
=\tilde w_t^C+\xi_t^C-\frac{c_t-\varepsilon(c_{t-1}-\varepsilon_t^A)}{1-\varepsilon}.
\]

- **(F5) Saver labor supply, durable sector**:

\[
[(\varphi-\iota_L)(1-\alpha)+\iota_L]l_t^D
+(\varphi-\iota_L)\alpha l_t^C
=\tilde w_t^D+\xi_t^C-\frac{c_t-\varepsilon(c_{t-1}-\varepsilon_t^A)}{1-\varepsilon}.
\]

- **(F6) Borrower housing-investment Euler equation**:

\[
q_t+\xi_t^C-\frac{c_t^B-\varepsilon^B(c_{t-1}^B-\varepsilon_t^A)}{1-\varepsilon^B}
+\psi(i_t^B-i_{t-1}^B+\varepsilon_t^A)
=E_t\varrho_{t+1}^B+\beta^B\psi(E_t i_{t+1}^B-i_t^B).
\]

- **(F7) Borrower durable demand shadow value**:

\[
[1-\beta^B(1-\delta)](\xi_t^D-d_t^B)=\varrho_t^B-\beta^B(1-\delta)E_t\varrho_{t+1}^B.
\]

- **(F8) Borrower Euler equation with mortgage/default terms** (`needs_review`, OCR-sensitive financial derivatives):

\[
\begin{aligned}
\varepsilon^B(\Delta c_t^B+\varepsilon_t^A)
&=E_t\Delta c_{t+1}^B-(1-\varepsilon^B)(\beta^B R^D E_t r_{t+1}^D
+E_t\Delta\xi_{t+1}^C-E_t\Delta p_{t+1}^C)\\
&\quad -(1-\varepsilon^B)\beta^B R^L[1-F(\bar\omega,\sigma_\omega)]
\left(r_t^L-\frac{F_\omega\bar\omega}{1-F}\hat{\bar\omega}_t^a
-\frac{F_{\sigma_\omega}\sigma_\omega}{1-F}\hat\sigma_{\omega,t}\right).
\end{aligned}
\]

- **(F9) Interest rate paid by defaulting borrowers** (`needs_review`):

\[
r_t^D=d_t^B-\tilde s_{t-1}^B
+\frac{G_\omega\bar\omega}{G}\hat\omega_{t-1}^p
+\frac{G_{\sigma_\omega}\sigma_\omega}{G}\hat\sigma_{\omega,t-1}
+q_t+\Delta p_t^C+\varepsilon_t^A.
\]

- **(F10) Borrower labor supply, non-durable sector**:

\[
[(\varphi-\iota_L)\alpha+\iota_L]l_t^{B,C}
+(\varphi-\iota_L)(1-\alpha)l_t^{B,D}
=\tilde w_t^C+\xi_t^C-\frac{c_t^B-\varepsilon^B(c_{t-1}^B-\varepsilon_t^A)}{1-\varepsilon^B}.
\]

- **(F11) Borrower labor supply, durable sector**:

\[
[(\varphi-\iota_L)(1-\alpha)+\iota_L]l_t^{B,D}
+(\varphi-\iota_L)\alpha l_t^{B,C}
=\tilde w_t^D+\xi_t^C-\frac{c_t^B-\varepsilon^B(c_{t-1}^B-\varepsilon_t^A)}{1-\varepsilon^B}.
\]

- **(F12) Borrower budget constraint** (`needs_review`, condensed from source equation 39):

\[
\begin{aligned}
C^B c_t^B+\delta D^B(q_t+i_t^B)
&+R^D\tilde S^B[r_t^D+\tilde s_{t-1}^B-\Delta p_t^C-\varepsilon_t^A]\\
&+[1-F]R^L\tilde S^B\left[r_{t-1}^L+\tilde s_{t-1}^B-\Delta p_t^C-\varepsilon_t^A-\frac{F_\omega\bar\omega}{1-F}\hat{\bar\omega}_{t-1}^p-\frac{F_{\sigma_\omega}\sigma_\omega}{1-F}\hat\sigma_{\omega,t-1}\right]\\
&=\tilde S^B\tilde s_t^B+\alpha W L^B(\tilde w_t^C+l_t^{B,C})+(1-\alpha)W L^B(\tilde w_t^D+l_t^{B,D}).
\end{aligned}
\]

- **(F13) Financial intermediary participation constraint** (`needs_review`, OCR-sensitive):

\[
\begin{aligned}
\frac{1}{\beta}\tilde S^B(r_t+\tilde s_t^B+\eta_t)
&=(1-\mu)D^B G\left[\frac{G_\omega\bar\omega}{G}\hat{\bar\omega}_t^a+\frac{G_{\sigma_\omega}\sigma_\omega}{G}\hat\sigma_{\omega,t}\right]\\
&\quad +(1-\mu)D^B G E_t(q_{t+1}+d_{t+1}^B+\Delta p_{t+1}^C)\\
&\quad +[1-F]R^L\tilde S^B\left[r_t^L+\tilde s_t^B-\frac{F_\omega\bar\omega}{1-F}\hat{\bar\omega}_t^a-\frac{F_{\sigma_\omega}\sigma_\omega}{1-F}\hat\sigma_{\omega,t}\right].
\end{aligned}
\]

- **(F14) Ex ante default threshold**:

\[
\hat{\bar\omega}_t^a+E_t(q_{t+1}+d_{t+1}^B)=r_t^L+\tilde s_t^B-E_t\Delta p_{t+1}^C.
\]

- **(F15) Ex post default threshold**:

\[
\hat\omega_{t-1}^p+q_t+d_t^B=r_{t-1}^L+\tilde s_{t-1}^B-\Delta p_t^C-\varepsilon_t^A.
\]

- **(F16) Domestic-imported non-durable demand, home good**:

\[
c_{H,t}=\iota_C(1-\tau)t_t+c_t^{TOT}.
\]

- **(F17) Domestic-imported non-durable demand, foreign good**:

\[
c_{F,t}=-\iota_C\tau t_t+c_t^{TOT}.
\]

- **(F18) Aggregate non-durable consumption**:

\[
[\lambda C+(1-\lambda)C^B]c_t^{TOT}=\lambda Cc_t+(1-\lambda)C^B c_t^B.
\]

- **(F19) Non-durable production**:

\[
y_t^C=z_t^C+l_t^{C,TOT}.
\]

- **(F20) Durable production**:

\[
y_t^D=z_t^D+l_t^{D,TOT}.
\]

- **(F21) Non-durable sector hours aggregation**:

\[
[\lambda L^C+(1-\lambda)L^{B,C}]l_t^{C,TOT}
=\lambda L^C l_t^C+(1-\lambda)L^{B,C}l_t^{B,C}.
\]

- **(F22) Durable sector hours aggregation**:

\[
[\lambda L^D+(1-\lambda)L^{B,D}]l_t^{D,TOT}
=\lambda L^D l_t^D+(1-\lambda)L^{B,D}l_t^{B,D}.
\]

- **(F23) CPI inflation**:

\[
\Delta p_t^C=\tau\Delta p_{H,t}+(1-\tau)\Delta p_{F,t}.
\]

- **(F24) Relative house price**:

\[
q_t=q_{t-1}+\Delta p_t^D-\Delta p_t^C.
\]

- **(F25) Non-durable Phillips curve**:

\[
\Delta p_t^H-\varphi_C\Delta p_{t-1}^H
=\beta E_t(\Delta p_{t+1}^H-\varphi_C\Delta p_t^H)
+\kappa^C(\tilde w_t^C+(1-\tau)t_t-z_t^C).
\]

- **(F26) Durable Phillips curve**:

\[
\Delta p_t^D-\varphi_D\Delta p_{t-1}^D
=\beta E_t(\Delta p_{t+1}^D-\varphi_D\Delta p_t^D)
+\kappa^D(\tilde w_t^D-q_t-z_t^D).
\]

## 4. Market Clearing & Identities

- **(F27) Non-durable goods market clearing**:

\[
y_t^C=\tau c_{H,t}+\frac{(1-n)(1-\tau^{\ast})}{n}c_{H,t}^{\ast}.
\]

- **(F28) Durable goods market clearing**:

\[
y_t^D=\frac{\lambda\delta D\, i_t+(1-\lambda)\delta D^B\, i_t^B}{\lambda\delta D+(1-\lambda)\delta D^B}.
\]

- **(F29) Saver housing law of motion**:

\[
d_t=(1-\delta)d_{t-1}+\delta i_{t-1}-\varepsilon_t^A.
\]

- **(F30) Borrower housing law of motion**:

\[
d_t^B=(1-\delta)d_{t-1}^B+\delta i_{t-1}^B-\varepsilon_t^A.
\]

- **(F31) Aggregate output**:

\[
y_t=\alpha y_t^C+(1-\alpha)(y_t^D+q_t).
\]

- **(F32) Foreign-country block**:

\[
\mathcal{E}_t^{\ast}=\mathcal{S}\{\text{(F1)--(F31)};\; x_t\mapsto x_t^{\ast},\; \tau\mapsto\tau^{\ast},\; n\mapsto1-n\}.
\]

- **(F33) International interest-rate link**:

\[
r_t^{\ast}=r_t+\beta(\kappa_b b_t+\vartheta_t).
\]

- **(F34) Net foreign assets**:

\[
\lambda b_t=\lambda\frac{1}{\beta}b_{t-1}
+\frac{(1-n)(1-\tau^{\ast})}{n}(c_{H,t}^{\ast}-t_t)
-(1-\tau)c_{F,t}.
\]

- **(F35) Terms of trade**:

\[
t_t=t_{t-1}+\Delta p_t^F-\Delta p_t^H.
\]

- **(F36) ECB Taylor rule** (`needs_review`: source equation repeats \(\gamma_\pi\) where output-growth coefficient is expected):

\[
r_t=\gamma_R r_{t-1}+(1-\gamma_R)\left[\gamma_\pi\Delta p_t^{EMU}
+\gamma_y(y_t^{EMU}-y_{t-1}^{EMU}+\varepsilon_t^A)\right]+\varepsilon_t^m.
\]

- **(F37) Euro-area CPI inflation**:

\[
\Delta p_t^{EMU}=n\Delta p_t^C+(1-n)\Delta p_t^{C^{\ast}}.
\]

- **(F38) Euro-area output**:

\[
y_t^{EMU}=ny_t+(1-n)y_t^{\ast}.
\]

- **(F39) Home macroprudential rule**:

\[
\eta_t=\gamma_\eta\Upsilon_t.
\]

- **(F40) Foreign macroprudential rule**:

\[
\eta_t^{\ast}=\gamma_\eta^{\ast}\Upsilon_t^{\ast}.
\]

## 5. Exogenous Processes

- **(F41) Home non-durable preference shock**:

\[
\xi_t^C=\rho_{\xi,H}\xi_{t-1}^C+\varepsilon_t^{\xi,C}.
\]

- **(F42) Foreign non-durable preference shock**:

\[
\xi_t^{C^{\ast}}=\rho_{\xi,H}\xi_{t-1}^{C^{\ast}}+\varepsilon_t^{\xi,C^{\ast}}.
\]

- **(F43) Home durable preference shock**:

\[
\xi_t^D=\rho_{\xi,D}\xi_{t-1}^D+\varepsilon_t^{\xi,D}+\varepsilon_t^{\xi,D,COM}.
\]

- **(F44) Foreign durable preference shock**:

\[
\xi_t^{D^{\ast}}=\rho_{\xi,D}\xi_{t-1}^{D^{\ast}}+\varepsilon_t^{\xi,D^{\ast}}+\varepsilon_t^{\xi,D,COM}.
\]

- **(F45) Home non-durable technology shock**:

\[
z_t^C=\rho_{Z,C}z_{t-1}^C+\varepsilon_t^{Z,C}+\varepsilon_t^{Z,C,COM}.
\]

- **(F46) Foreign non-durable technology shock**:

\[
z_t^{C^{\ast}}=\rho_{Z,C}z_{t-1}^{C^{\ast}}+\varepsilon_t^{Z,C^{\ast}}+\varepsilon_t^{Z,C,COM}.
\]

- **(F47) Home durable technology shock**:

\[
z_t^D=\rho_{Z,D}z_{t-1}^D+\varepsilon_t^{Z,D}.
\]

- **(F48) Foreign durable technology shock**:

\[
z_t^{D^{\ast}}=\rho_{Z,D}z_{t-1}^{D^{\ast}}+\varepsilon_t^{Z,D^{\ast}}.
\]

- **(F49) Home mortgage-risk shock**:

\[
\sigma_{\omega,t}=(1-\rho_{\sigma\omega})\bar\sigma_\omega+\rho_{\sigma\omega}\sigma_{\omega,t-1}+u_{\omega,t}.
\]

- **(F50) Foreign mortgage-risk shock**:

\[
\sigma_{\omega,t}^{\ast}=(1-\rho_{\sigma\omega})\bar\sigma_\omega+\rho_{\sigma\omega}\sigma_{\omega,t-1}^{\ast}+u_{\omega,t}^{\ast}.
\]

- **(F51) International risk-premium shock**:

\[
\vartheta_t=\rho_\vartheta\vartheta_{t-1}+\varepsilon_t^\vartheta.
\]

- **(F52) Unit-root technology and monetary-policy innovations**:

\[
\varepsilon_t^A\;\text{and}\;\varepsilon_t^m\;\text{are i.i.d. innovations.}
\]

## 6. Steady-State Solution

The paper appendix states the linearized system in deviations from steady state after normalizing variables with the common euro-area technology trend \(A_t\). Hence the linearized steady state sets all lowercase deviation variables and inflation gaps to zero:

\[
c=d=i=q=l=w=y=b=t=r=\eta=\xi=z=\sigma_\omega-\bar\sigma_\omega=0.
\]

For implementation work, the Rep-MMB `.mod` provides the nonlinear stationary calibration used to initialize the exponentiated model. Important normalizations and targets include \(Q=1\), gross inflation rates equal to one, \(b=0\), \(R=RR\_bar\), \(R^L=RL\_bar\), steady default fraction \(F\_bar\), and symmetric calibrated home/foreign housing-credit steady states. These values are recorded as `implementation_cross_check`, not as additional paper-side derivations.

Steady-state reconstruction is `needs_review`: the source appendix gives linearized conditions, while the nonlinear implementation encodes a full set of steady-state constants. No Dynare `steady` or `check` run was performed for this archive pass.

## 7. Timing & Form Conventions

- **Linearization**: Appendix 2 uses lowercase variables for log deviations from steady state; variables with a unit-root trend are first normalized by \(A_t\).
- **Foreign variables**: the paper uses starred notation; the Rep-MMB implementation uses `_s`.
- **Housing stocks**: \(d_t\) and \(d_t^B\) are beginning-of-period normalized housing stocks determined by past investment in (F29) and (F30). The implementation uses lagged investment and trend growth in the nonlinear law of motion.
- **Mortgage timing**: the lending rate and credit stock chosen at \(t-1\) enter repayment and ex post default settlement at \(t\), while ex ante threshold \(\hat{\bar\omega}_t^a\) depends on expected next-period house value.
- **Policy timing**: the Taylor rule smooths the common policy rate with \(r_{t-1}\) and responds to current euro-area inflation and output growth. Macroprudential instruments are national and contemporaneous functions of credit indicators.
- **Formula caveats**: equations (F8), (F9), (F12), (F13), and (F36) are marked `needs_review` because the MinerU OCR or the published appendix text contains sensitive derivative notation or a possible coefficient typo.

## 8. Variable & Parameter Reference Table

| Category | Symbols | Meaning | Main equations |
|---|---|---|---|
| Endogenous, savers | \(c,d,i,\varrho,l^C,l^D\) | Saver consumption, housing, investment, housing multiplier, sectoral hours | (F1)-(F5), (F29) |
| Endogenous, borrowers | \(c^B,d^B,i^B,\varrho^B,l^{B,C},l^{B,D},\tilde s^B\) | Borrower consumption, housing, investment, credit and hours | (F6)-(F15), (F30) |
| Financial variables | \(r,r^L,r^D,\hat{\bar\omega}^a,\hat\omega^p,\eta,F,G\) | Deposit rate, lending/default rates, default thresholds, macroprudential wedge and lognormal functions | (F8)-(F15), (F39)-(F40) |
| Prices and wages | \(q,\Delta p^C,\Delta p^D,\Delta p^H,\Delta p^F,\tilde w^C,\tilde w^D\) | Relative house price, CPI/sectoral inflation, sectoral real wages | (F23)-(F26), (F35), (F37) |
| Quantities | \(c_H,c_F,c^{TOT},y^C,y^D,y,l^{C,TOT},l^{D,TOT}\) | Demand aggregation, production, market clearing and output | (F16)-(F22), (F27)-(F31), (F38) |
| Open economy | \(b,t,r^{\ast},y^{\ast},\Delta p^{C^{\ast}}\) | Net foreign assets, terms of trade, foreign policy rate and foreign aggregates | (F32)-(F38) |
| Exogenous shocks | \(\xi^C,\xi^{C^{\ast}},\xi^D,\xi^{D^{\ast}},z^C,z^{C^{\ast}},z^D,z^{D^{\ast}},\sigma_\omega,\sigma_\omega^{\ast},\vartheta,\varepsilon^A,\varepsilon^m\) | Preference, technology, risk, international premium, unit-root technology and monetary shocks | (F41)-(F52) |
| Parameters | \(\beta,\beta^B,\lambda,n,\delta,\varepsilon,\varepsilon^B,\alpha,\tau,\iota_C,\iota_L,\varphi,\psi,\theta_C,\theta_D,\varphi_C,\varphi_D,\kappa_b,\gamma_R,\gamma_\pi,\gamma_y,\gamma_\eta,\mu,\rho_\cdot\) | Discount factors, population shares, adjustment and price parameters, policy coefficients, monitoring cost and persistence terms | all equations |
