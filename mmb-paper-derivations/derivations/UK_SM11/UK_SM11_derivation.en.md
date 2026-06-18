# UK_SM11 -- Derivation (log-linear equilibrium extraction)

> Archive entry for the private MMB derivation workspace. Runtime validation was not performed. The paper states that Section 2 reports the log-linear equilibrium conditions and refers the full nonlinear derivation to the Harrison et al. (2011) technical appendix; therefore this entry preserves the paper-side log-linear system and marks unavailable primitive optimization detail as `needs_review`.

Source provenance: `UK_SM11`, Stephen Millard (2011), "An estimated DSGE model of energy, costs and inflation in the United Kingdom", Bank of England Working Paper No. 432, DOI `10.2139/ssrn.1898065`. Primary Markdown: `raw/mmb_mineru/runs/uk_sm11__an_estimated_dsge_model_of_energy_costs_and_inflation_in_the_united_king__84b3b0b8/full.md`. Raw PDF: `raw/mmb_papers/An estimated DSGE model of energy, costs and inflation in the United Kingdom.pdf`. MinerU run ids: `84b3b0b8-fdb9-42d7-a2f1-4e4e266ccde8`, `7c46224e-727a-48ed-950c-97f2f1810d7d`.

## 1. Model Overview

- **Model**: Estimated UK small-open-economy DSGE model with explicit energy sectors.
- **Paper-side source**: Section 2 reports log-linear equilibrium conditions for the model of Harrison, Thomas and de Weymarn (2011), as estimated by Millard.
- **Agents and blocks**: households, differentiated labour suppliers, non-energy firms, value-added producers, petrol producers, utilities producers, monetary/fiscal authorities, and a foreign sector.
- **Key features**: three consumption goods (non-energy, petrol, utilities); labour, capital, imported intermediates, oil, and gas inputs; sticky wages; sector-specific sticky prices; habit persistence; capital adjustment cost; variable capital utilisation; working-capital cost channel; UIP with foreign-bond adjustment costs; Taylor rule; balanced-budget fiscal authority with petrol duty.
- **Model form**: log-linear, implemented as `model(linear)` in the MMB cross-check file. Hatted variables are log deviations from trend or steady state; foreign bond holdings are normalized as a share of non-energy output.
- **Status**: `needs_review` because the paper does not include the full nonlinear optimization derivation and several OCR symbols in the Markdown need source-level checking against the PDF/appendix.

## 2. Optimization Problems

The paper does not print primitive maximization problems. It states the economic choices and then gives log-linear equilibrium conditions. The underlying optimization blocks are:

- **Households** choose aggregate consumption, the composition of non-energy/petrol/utilities consumption, capital accumulation, capital utilisation, domestic and foreign bond positions, and differentiated wages under habit formation, capital adjustment/utilisation costs, bond adjustment costs, and Calvo/Rotemberg-style wage rigidity. Full primitive objectives and constraints are `needs_review` because they are only cited as being in the technical appendix to Harrison et al. (2011).
- **Non-energy firms** combine a value-added/import bundle with energy, minimize costs across value-added, imported intermediates, petrol, and utilities inputs, and set sticky prices with indexation.
- **Value-added producers** combine labour and utilised capital, and borrow to finance a share of their wage bill, generating a working-capital cost channel.
- **Petrol and utilities producers** use Leontief technologies with energy commodities and value-added, and set sectoral prices subject to nominal rigidity.
- **Importers** face slow pass-through to purchasing-power parity, producing an import-price Phillips curve.
- **Policy authorities and the foreign sector** are rule/identity blocks rather than optimizing agents in the printed source.

## 3. First-Order Conditions

The following conditions reproduce the paper's log-linear equilibrium equations where they are agent choice or pricing conditions. Paper equation numbers are not reused; archive numbering is continuous as `(F#)`.

- **(F1) Habit consumption Euler equation**:

\[
\hat{c}_t =
\frac{\psi_{hab}(1-\sigma_c)}{1+\psi_{hab}(1-\sigma_c)}\hat{c}_{t-1}
+\frac{1}{1+\psi_{hab}(1-\sigma_c)}E_t\hat{c}_{t+1}
-\frac{\sigma_c}{1+\psi_{hab}(1-\sigma_c)}
\left(i_t-E_t\pi_{c,t+1}-\left(\frac{1}{\beta}-1\right)+\varepsilon_{b,t}\right).
\]

- **(F2) Capital accumulation / investment condition**:

\[
\begin{aligned}
i_t-E_t\pi_{c,t+1}-\left(\frac{1}{\beta}-1\right)+\varepsilon_{b,t}
&=\left(\frac{\varepsilon_k}{1-\delta+\chi_z}+1+\varepsilon_k\right)\chi_k\hat{k}_{t-1}\\
&-\left(\frac{1+\varepsilon_k}{1-\delta+\chi_z}+1\right)\chi_k\hat{k}_t
+\frac{\chi_k}{1-\delta+\chi_z}E_t\hat{k}_{t+1}\\
&-\chi_k\varepsilon_k\hat{k}_{t-2}
+\frac{\chi_z}{1-\delta+\chi_z}E_t\hat{w}_{k,t+1}
+\varepsilon_{inv,t}.
\end{aligned}
\]

- **(F3) Capital utilisation rental-rate condition**:

\[
\hat{w}_{k,t}=\phi_z\hat{z}_t.
\]

- **(F4) Energy consumption aggregator**:

\[
\hat{c}_{E,t}=(1-\psi_p)\hat{c}_{U,t}+\psi_p\hat{c}_{P,t}.
\]

- **(F5) Aggregate consumption aggregator**:

\[
\hat{c}_t=(1-\psi_e)\hat{c}_{n,t}+\psi_e\hat{c}_{e,t}.
\]

- **(F6) Non-energy/utilities relative consumption demand**:

\[
\hat{p}_{U,t}=\frac{1}{\sigma_e}\hat{c}_{n,t}
+\left(\frac{1}{\sigma_p}-\frac{1}{\sigma_e}\right)\hat{c}_{E,t}
-\frac{1}{\sigma_p}\hat{c}_{U,t}.
\]

- **(F7) Petrol/utilities relative consumption demand**:

\[
\hat{p}_{U,t}-\hat{p}_{P,t}
=-\frac{1}{\sigma_p}\hat{c}_{U,t}
+\frac{1}{\sigma_p}\hat{c}_{P,t}.
\]

- **(F8) UIP with foreign-bond adjustment cost**:

\[
E_t\hat{s}_{t+1}-\hat{s}_t
=-\left(i_t-\left(\frac{1}{\beta}-1\right)\right)-\chi_{bf}b_{f,t}+\varepsilon_{rf,t}.
\]

- **(F9) Wage Phillips curve**:

\[
\dot{W}_t=\frac{\xi_w}{1+\beta\xi_w}\dot{W}_{t-1}
+\frac{\beta}{1+\beta\xi_w}E_t\dot{W}_{t+1}
-\frac{\psi_w(1-\beta(1-\psi_w))}
{(1+\sigma_w/\sigma_h)(1-\psi_w)(1+\beta\xi_w)}
(\hat{w}_t-mrs_t)+\varepsilon_{w,t}.
\]

- **(F10) Marginal rate of substitution**:

\[
mrs_t=\frac{1}{\sigma_h}\hat{h}_t
+\frac{1}{\sigma_c}\left(\hat{c}_t+\psi_{hab}(\sigma_c-1)\hat{c}_{t-1}\right).
\]

- **(F11) Real consumption wage law of motion**:

\[
\hat{w}_t=\dot{W}_t+\hat{w}_{t-1}-\pi_{c,t}.
\]

- **(F12) Non-energy production**:

\[
\hat{q}_t=(1-\alpha_q)\hat{B}_t+\alpha_q\hat{e}_t+\varepsilon_{a,t}.
\]

- **(F13) Value-added/import bundle**:

\[
\hat{B}_t=(1-\alpha_B)\hat{V}_{n,t}+\alpha_B\hat{M}_{n,t}.
\]

- **(F14) Energy input Leontief relation in non-energy production**:

\[
\hat{e}_t=\hat{I}_{p,t}=\hat{I}_{u,t}.
\]

- **(F15) Demand for value-added by non-energy firms**:

\[
\hat{V}_{n,t}=\hat{\mu}_t-\hat{p}_{vc,t}
+\frac{1}{\sigma_q}\hat{q}_t
+\frac{\sigma_q-1}{\sigma_q}\hat{B}_t
+\frac{\sigma_q-1}{\sigma_q}\varepsilon_{a,t}.
\]

- **(F16) Demand for imported intermediates by non-energy firms**:

\[
\hat{M}_{n,t}=\hat{\mu}_t-\hat{p}_{m,t}
+\frac{1}{\sigma_q}\hat{q}_t
-\left(\frac{1}{\sigma_q}-1\right)\hat{B}_t
+\frac{\sigma_q-1}{\sigma_q}\varepsilon_{a,t}.
\]

- **(F17) Energy demand by non-energy firms**:

\[
\hat{e}_t=\sigma_q\hat{\mu}_t+\hat{q}_t
-\sigma_q\left(\psi_n\hat{p}_{p,t}+(1-\psi_n)\hat{p}_{U,t}\right)
+(\sigma_q-1)\varepsilon_{a,t}.
\]

- **(F18) Non-energy-sector Phillips curve**:

\[
\pi_t=\frac{\beta}{1+\beta\varepsilon}E_t\pi_{t+1}
+\frac{\varepsilon}{1+\beta\varepsilon}\pi_{t-1}
+\frac{(1-\chi_p)(1-\beta\chi_p)}{(1+\beta\varepsilon)\chi_p}\hat{\mu}_t
+\varepsilon_{\mu,t}.
\]

- **(F19) Value-added production**:

\[
\hat{V}_t=(1-\alpha_v)\hat{h}_t+\alpha_v(\hat{k}_{t-1}+\hat{z}_t).
\]

- **(F20) Labour demand by value-added producers with working-capital cost**:

\[
\hat{h}_t=\hat{V}_t+\sigma_V\left(\hat{p}_{vc,t}-\hat{w}_t-\psi_{wc}\left(i_t-\left(\frac{1}{\beta}-1\right)+\varepsilon_{b,t}\right)\right).
\]

- **(F21) Capital services demand by value-added producers**:

\[
\hat{k}_{t-1}+\hat{z}_t=\hat{V}_t+\sigma_V(\hat{p}_{vc,t}-\hat{w}_{k,t}).
\]

- **(F22) Petrol production technology**:

\[
\hat{q}_{p,t}=\hat{I}_{o,t}=\hat{V}_{p,t}.
\]

- **(F23) Petrol-sector Phillips curve**:

\[
\pi_{pb,t}=\frac{\beta}{1+\beta\varepsilon_{pp}}E_t\pi_{pb,t+1}
+\frac{\varepsilon_{pp}}{1+\beta\varepsilon_{pp}}\pi_{pb,t-1}
+\frac{(1-\chi_{pp})(1-\beta\chi_{pp})}{(1+\beta\varepsilon_{pp})\chi_{pp}}\hat{\mu}_{p,t}.
\]

- **(F24) Petrol marginal cost**:

\[
\hat{\mu}_{p,t}=\psi_{qp}\hat{p}_{vc,t}+(1-\psi_{qp})\hat{p}_{o,t}-\hat{p}_{pb,t}.
\]

- **(F25) Basic petrol inflation identity**:

\[
\pi_{pb,t}=\pi_t+\hat{p}_{pb,t}-\hat{p}_{pb,t-1}.
\]

- **(F26) Utilities production technology**:

\[
\hat{q}_{u,t}=\hat{I}_{g,t}=\hat{V}_{u,t}.
\]

- **(F27) Utilities-sector Phillips curve**:

\[
\pi_{u,t}=\frac{\beta}{1+\beta\varepsilon_u}E_t\pi_{u,t+1}
+\frac{\varepsilon_u}{1+\beta\varepsilon_u}\pi_{u,t-1}
+\frac{(1-\chi_u)(1-\beta\chi_u)}{(1+\beta\varepsilon_u)\chi_u}\hat{\mu}_{u,t}.
\]

- **(F28) Utilities marginal cost**:

\[
\hat{\mu}_{u,t}=\psi_u\hat{p}_{vc,t}+(1-\psi_u)\hat{p}_{g,t}-\hat{p}_{u,t}.
\]

- **(F29) Utilities inflation identity**:

\[
\pi_{u,t}=\pi_t+\hat{p}_{u,t}-\hat{p}_{u,t-1}.
\]

- **(F30) Taylor rule**:

\[
i_t-\left(\frac{1}{\beta}-1\right)
=\theta_{rg}\left(i_{t-1}-\left(\frac{1}{\beta}-1\right)\right)
+(1-\theta_{rg})(\theta_{pdot}\pi_{c,t}+\theta_y\hat{y}_t)
+\varepsilon_{i,t}.
\]

- **(F31) Petrol duty pass-through**:

\[
\hat{p}_{p,t}=(1-\psi_d)\hat{p}_{pb,t}.
\]

- **(F32) Oil price in domestic currency**:

\[
\hat{p}_{o,t}=\varepsilon_{p_o,t}-\hat{s}_t.
\]

- **(F33) Gas price in domestic currency**:

\[
\hat{p}_{g,t}=\varepsilon_{p_g,t}-\hat{s}_t.
\]

- **(F34) Import-price Phillips curve**:

\[
\pi_{m,t}=\frac{\iota_{pm}}{1+\beta\iota_{pm}}\pi_{m,t-1}
+\frac{\beta}{1+\beta\iota_{pm}}E_t\pi_{m,t+1}
+\frac{(1-\xi_{pm})(1-\beta\xi_{pm})}{(1+\beta\iota_{pm})\xi_{pm}}
(\varepsilon_{P_{mf},t}-\hat{s}_t-\hat{p}_{m,t}).
\]

- **(F35) Export demand**:

\[
\hat{x}_{n,t}=\psi_x\hat{x}_{n,t-1}+(1-\psi_x)(\varepsilon_{y_f,t}-\eta_x\hat{s}_t).
\]

## 4. Market Clearing & Identities

- **(F36) Consumer price index / aggregate-consumption value identity**:

\[
\hat{p}_{c,t}+\hat{c}_t
=\frac{c_n}{p_c c}\hat{c}_{n,t}
+\frac{p_u c_u}{p_c c}(\hat{p}_{U,t}+\hat{c}_{U,t})
+\left(1-\frac{c_n}{p_c c}-\frac{p_u c_u}{p_c c}\right)(\hat{p}_{P,t}+\hat{c}_{P,t}).
\]

- **(F37) Aggregate value-added allocation**:

\[
\hat{V}_t=\frac{V_n}{V}\hat{V}_{n,t}
+\frac{V_u}{V}\hat{V}_{u,t}
+\left(1-\frac{V_n}{V}-\frac{V_u}{V}\right)\hat{V}_{p,t}.
\]

- **(F38) Petrol goods market clearing**:

\[
\hat{q}_{P,t}=\frac{c_P}{q_P}\hat{c}_{P,t}
+\left(1-\frac{c_P}{q_P}\right)\hat{I}_{P,t}.
\]

- **(F39) Utilities goods market clearing**:

\[
\hat{q}_{U,t}=\frac{c_U}{q_U}\hat{c}_{U,t}
+\left(1-\frac{c_U}{q_U}\right)\hat{I}_{U,t}.
\]

- **(F40) Oil input/export identity**:

\[
\hat{I}_{O,t}=-\frac{X_o}{I_o}\hat{X}_{O,t}.
\]

- **(F41) Gas input/export identity**:

\[
\hat{I}_{G,t}=-\frac{X_g}{I_g}\hat{X}_{G,t}.
\]

- **(F42) Non-energy output market clearing**:

\[
\hat{q}_t=\frac{c_n}{q}\hat{c}_{n,t}
+\frac{k}{q}\hat{k}_t-\frac{(1-\delta)k}{q}\hat{k}_{t-1}
+\frac{\chi_z k}{q}\hat{z}_t
+\frac{x_n}{q}\hat{x}_{n,t}
+\frac{c_g}{q}\varepsilon_{g,t}.
\]

- **(F43) Net foreign asset accumulation**:

\[
b_{f,t}=\frac{1}{\beta}b_{f,t-1}
+\frac{x_n}{q}\hat{x}_{n,t}
+\frac{X_g}{q}(\hat{p}_{g,t}+\hat{X}_{g,t})
+\frac{X_o}{q}(\hat{p}_{o,t}+\hat{X}_{o,t})
-\frac{M_n}{q}(\hat{p}_{m,t}+\hat{M}_{n,t}).
\]

The government budget is balanced by lump-sum taxes:

\[
G_t=\psi_d P_{p,t}q_{p,t}+T_t.
\]

This printed budget equation is not assigned an F-number because the paper uses it as fiscal closure and the log-linear domestic-demand disturbance enters (F42).

## 5. Exogenous Processes

- **(F44) Productivity shock**:

\[
\varepsilon_{a,t}=\rho_a\varepsilon_{a,t-1}+\eta_{a,t}.
\]

- **(F45) Risk-premium shock**:

\[
\varepsilon_{b,t}=\rho_b\varepsilon_{b,t-1}+\eta_{b,t}.
\]

- **(F46) Domestic-demand shock**:

\[
\varepsilon_{g,t}=\rho_g\varepsilon_{g,t-1}+\eta_{g,t}.
\]

- **(F47) Monetary-policy shock**:

\[
\varepsilon_{i,t}=\rho_i\varepsilon_{i,t-1}+\eta_{i,t}.
\]

- **(F48) Price mark-up shock**:

\[
\varepsilon_{\mu,t}=\rho_{\mu}\varepsilon_{\mu,t-1}+\eta_{\mu,t}.
\]

- **(F49) Investment-specific technology shock**:

\[
\varepsilon_{inv,t}=\rho_{inv}\varepsilon_{inv,t-1}+\eta_{inv,t}.
\]

- **(F50) Wage mark-up shock**:

\[
\varepsilon_{w,t}=\rho_w\varepsilon_{w,t-1}+\eta_{w,t}.
\]

- **(F51) World-demand shock**:

\[
\varepsilon_{y_f,t}=\rho_{y_f}\varepsilon_{y_f,t-1}+\eta_{y_f,t}.
\]

- **(F52) World export/import-price shock**:

\[
\varepsilon_{p_{mf},t}=\rho_{p_{mf}}\varepsilon_{p_{mf},t-1}+\eta_{p_{mf},t}.
\]

- **(F53) World oil-price shock**:

\[
\varepsilon_{p_o,t}=\rho_{p_o}\varepsilon_{p_o,t-1}+\eta_{p_o,t}.
\]

- **(F54) World gas-price shock**:

\[
\varepsilon_{p_g,t}=\rho_{p_g}\varepsilon_{p_g,t-1}+\eta_{p_g,t}.
\]

- **(F55) World real-interest-rate shock**:

\[
\varepsilon_{rf,t}=\rho_{rf}\varepsilon_{rf,t-1}+\eta_{rf,t}.
\]

The foreign-process estimates printed in the estimation section are: \(\rho_{y_f}=0.9061\), \(\sigma_{y_f}=0.0142\); \(\rho_{p_{mf}}=0.8991\), \(\sigma_{p_{mf}}=0.0075\); \(\rho_{p_o}=0.7283\), \(\sigma_{p_o}=0.1410\); \(\rho_{p_g}=0.5940\), \(\sigma_{p_g}=0.2544\); \(\rho_{rf}=0.8738\), \(\sigma_{rf}=0.0012\).

## 6. Steady-State Solution

The printed model is log-linear. Therefore the operational steady state for hatted variables, inflation deviations, price deviations, and shocks is zero:

\[
\hat{x}=0,\quad \pi=0,\quad \dot{W}=0,\quad \varepsilon_j=0,\quad \eta_j=0.
\]

The paper calibrates or fixes steady-state ratios used in the log-linear identities, including \(c_n/(p_c c)\), \(p_u c_u/(p_c c)\), \(V_n/V\), \(V_u/V\), \(c_P/q_P\), \(c_U/q_U\), \(X_o/I_o\), \(X_g/I_g\), \(c_n/q\), \(k/q\), \(c_g/q\), \(x_n/q\), \(M_n/q\), \(X_o/q\), and \(X_g/q\). The MMB cross-check file sets these as `cncratio`, `cucratio`, `vnvratio`, `vuvratio`, `cpqpratio`, `cuquratio`, `xoioratio`, `xgigratio`, `cnqratio`, `kqratio`, `cgqratio`, `xnqratio`, `mnqratio`, `xoqratio`, and `xgqratio`.

Primitive nonlinear steady-state equations are `needs_review` because they are not printed in Millard (2011). The derivation should not be promoted to a nonlinear runnable model archive without checking the cited technical appendix and the full MMB implementation.

## 7. Timing & Form Conventions

- **Form**: log-linear equilibrium system; the MMB file uses `model(linear)`.
- **Expectations**: equations use \(E_t x_{t+1}\) for forward-looking consumption, capital, wage, price, and import-price conditions.
- **Capital timing**: productive capital services use predetermined capital \(\hat{k}_{t-1}\) plus utilisation \(\hat{z}_t\) in (F19) and (F21). Capital accumulation in (F2) includes \(\hat{k}_{t-2}\), \(\hat{k}_{t-1}\), \(\hat{k}_t\), and \(E_t\hat{k}_{t+1}\) due to capital adjustment costs.
- **Prices and inflation**: relative prices are hatted; sectoral inflation identities link relative price changes to non-energy inflation.
- **Foreign assets**: \(b_{f,t}\) is a level-like log-linearized stock normalized by non-energy output, with lagged accumulation in (F43).
- **Flexible-price cross-check**: the `.mod` contains a parallel flexible-price block (`cf`, `vaf`, `rf`, etc.) used to construct gaps for the Taylor rule. This is implementation evidence, not an additional paper-side source equation set.
- **Runtime validation**: not performed; Dynare was not run.

## 8. Variable & Parameter Reference Table

| Category | Symbols / ASCII names | Meaning | Main equations |
|---|---|---|---|
| Endogenous | \(\hat{c}\) / `c` | Aggregate consumption | (F1), (F5), (F36) |
| Endogenous | \(\lambda\) / `lam` | Marginal utility proxy in implementation | implementation_cross_check |
| Endogenous | \(\hat{c}_n,\hat{c}_P,\hat{c}_U,\hat{c}_E\) / `cn, cp, cu, ce` | Non-energy, petrol, utilities, and energy consumption | (F4)-(F7), (F36), (F38)-(F39) |
| Endogenous | \(\hat{p}_c,\hat{p}_P,\hat{p}_U,\hat{p}_{pb}\) / `pc, pp, pu, ppb` | Consumer and sectoral relative prices | (F6)-(F7), (F24)-(F31), (F36) |
| Endogenous | \(\pi,\pi_c,\pi_{pb},\pi_u,\pi_m,\dot{W}\) / `pdot, pcdot, ppbdot, pudot, pmdot, wdot` | Inflation rates and wage inflation | (F9), (F18), (F23), (F25), (F27), (F29), (F34) |
| Endogenous | \(i\) / `rg` | Nominal policy rate deviation | (F1), (F8), (F20), (F30) |
| Endogenous | \(\hat{w},mrs,\hat{h}\) / `w, rcw, h` | Real wage, marginal rate of substitution, hours | (F9)-(F11), (F19)-(F21) |
| Endogenous | \(\hat{k},\hat{z},\hat{w}_k\) / `k, z, wk` | Capital, utilisation, capital rental rate | (F2), (F3), (F19), (F21), (F42) |
| Endogenous | \(\hat{q},\hat{B},\hat{e}\) / `q, b, e` | Non-energy output, bundle input, energy input | (F12)-(F17), (F42) |
| Endogenous | \(\hat{V},\hat{V}_n,\hat{V}_p,\hat{V}_u\) / `va, vn, vp, vu` | Aggregate and sectoral value-added | (F15), (F19), (F22), (F26), (F37) |
| Endogenous | \(\hat{M}_n,\hat{p}_m\) / `mn, pm` | Imported intermediates and import price | (F16), (F34), (F43) |
| Endogenous | \(\hat{q}_P,\hat{q}_U,\hat{I}_p,\hat{I}_u,\hat{I}_o,\hat{I}_g\) / `qp, qu, ip, iu, io, ig` | Energy-sector outputs and inputs | (F14), (F22), (F26), (F38)-(F41) |
| Endogenous | \(\hat{s},b_f,\hat{x}_n,\hat{X}_o,\hat{X}_g\) / `s, bf, xn, xo, xg` | Exchange rate, foreign assets, exports | (F8), (F35), (F40)-(F43) |
| Endogenous | \(\hat{p}_o,\hat{p}_g\) / `po, pg` | Domestic-currency oil and gas prices | (F32), (F33), (F43) |
| Exogenous shocks | `eps_a, eps_b, eps_i, eps_g, eps_mu, eps_inv, eps_w, eps_yf, eps_pmf, eps_po, eps_pg, eps_rf` | Innovations to productivity, risk premium, monetary policy, domestic demand, markups, investment, and foreign shocks | (F44)-(F55) |
| Parameters | \(\beta,\delta,\chi_z,\psi_e,\psi_p,\alpha_q,\alpha_v,\alpha_B,\psi_n,\psi_{qp},\psi_u,\psi_d\) | Discounting, depreciation/utilisation, shares and technology weights | Multiple |
| Parameters | \(\sigma_c,\psi_{hab},\chi_{bf},\chi_k,\varepsilon_k,\phi_z,\sigma_w,\sigma_h,\psi_w,\xi_w\) | Preferences, bond costs, capital costs, wage setting | (F1)-(F11) |
| Parameters | \(\sigma_e,\sigma_p,\sigma_V,\sigma_q,\chi_p,\chi_u,\chi_{pp},\varepsilon,\varepsilon_u,\varepsilon_{pp}\) | Substitution and sectoral price rigidity/indexation | (F4)-(F29) |
| Parameters | \(\psi_{wc},\psi_x,\eta_x,\xi_{pm},\iota_{pm},\theta_{rg},\theta_{pdot},\theta_y,\rho_j\) | Working capital, export/import behavior, policy, shock persistence | (F20), (F30), (F34)-(F55) |
| Calibration ratios | `cncratio, cucratio, vnvratio, vuvratio, cpqpratio, cuquratio, xoioratio, xgigratio, cnqratio, kqratio, cgqratio, xnqratio, mnqratio, xoqratio, xgqratio` | Steady-state ratios appearing in market-clearing equations | (F36)-(F43) |
