# EACZ_GEM03 -- Derivation (Optimization Problems + First-Order Conditions)

> First-pass private archive entry for MMB model `EACZ_GEM03`. Runtime validation was not performed. Formula status: `needs_review` where MinerU OCR or paper-to-implementation compression is uncertain.

## 1. Model Overview

- **Model**: Laxton and Pesenti (2003), "Monetary rules for small, open, emerging economies", a two-country variant of the IMF Global Economy Model (GEM).
- **Archive model ID**: `EACZ_GEM03`.
- **Source**: `raw/mmb_mineru/runs/eacz_gem03__monetary_rule_for_small_open_emerging_economies__7512f0ea/full.md`; raw PDF provenance at `raw/mmb_papers/Monetary rule for small, open, emerging economies.pdf`.
- **Countries**: Home is the relatively small open economy, calibrated to the Czech Republic; Foreign is the large relatively closed economy, calibrated to the Euro area. Foreign variables are denoted with a star in the paper and with suffix `F` in the implementation cross-check; Home variables use suffix `H`.
- **Agents and sectors**: infinitely lived households, final-good firms, monopolistically competitive nontradable and tradable intermediate-good firms, competitive distribution firms, competitive raw-material firms using land, and governments/central banks.
- **Experiment**: comparison of generalized Taylor rules and inflation-forecast-based rules under stochastic shocks; the MMB implementation replicates the second row of Table 4, with optimized policy-rule parameters for the Home country.
- **Model form**: nonlinear structural DSGE in the paper; the paper solves the nonlinear steady state and then studies linearized versions in Dynare. The Rep-MMB implementation is a nonlinear Dynare `model` block with percentage-deviation reporting variables.
- **First-pass status**: `needs_review`. The paper gives core structural equations but leaves several FOCs in prose; the implementation file was used only as `implementation_cross_check`, not as paper-side mathematical evidence.

## 2. Optimization Problems

### 2.1 Final-Good Firms

Perfectly competitive final-good firms choose nontradable input basket \(N_{N,t}(x)\), domestic tradable basket \(Q_t(x)\), and imported tradable basket \(M_t(x)\) to minimize input cost subject to a nested CES production function. The paper's OCR for the outer nesting around Eq. (1) is damaged, so the cleaned representation below is marked `needs_review`:

\[
A_t(x)=\Bigg\lbrace(1-\gamma_t)^{1/\epsilon}N_{N,t}(x)^{1-1/\epsilon}
+\gamma_t^{1/\epsilon}\left[\nu^{1/\epsilon_{QM}}Q_t(x)^{1-1/\epsilon_{QM}}
+(1-\nu)^{1/\epsilon_{QM}}\left(M_t(x)(1-\Gamma_{M,t}(x))\right)^{1-1/\epsilon_{QM}}\right]^{\frac{\epsilon_{QM}}{\epsilon_{QM}-1}\left(1-\frac{1}{\epsilon}\right)}\Bigg\rbrace^{\frac{\epsilon}{\epsilon-1}}.
\quad \text{needs_review}
\]

The import adjustment-cost wedge is:

\[
\Gamma_{M,t}(x)=\frac{\phi_M}{2}\left(\frac{M_t(x)/A_t(x)}{M_{t-1}/A_{t-1}}-1\right)^2.
\]

### 2.2 Intermediate-Good Firms

Each nontradable producer \(n\) minimizes cost subject to a CES technology over labor, capital, and a materials basket:

\[
N_t^S(n)=Z_{N,t}\left[(1-\alpha_N-\gamma_N)^{1/\xi_N}\ell_t(n)^{1-1/\xi_N}
+\alpha_N^{1/\xi_N}K_t(n)^{1-1/\xi_N}
+\gamma_N^{1/\xi_N}(O_t(n)(1-\Gamma_{O,t}(n)))^{1-1/\xi_N}\right]^{\xi_N/(\xi_N-1)}.
\]

Tradable-good producers solve the analogous problem with \(T_t^S(h)\) and parameters \((\alpha_T,\gamma_T,\xi_T,Z_{T,t})\). Raw-material firms solve a competitive cost-minimization problem with labor, capital, and land:

\[
T_{O,t}^S(o)=Z_{O,t}\left[(1-\alpha_O-\gamma_O)^{1/\xi_O}\ell_t(o)^{1-1/\xi_O}
+\alpha_O^{1/\xi_O}K_t(o)^{1-1/\xi_O}
+\gamma_O^{1/\xi_O}L_t(o)^{1-1/\xi_O}\right]^{\xi_O/(\xi_O-1)}.
\]

Monopolistically competitive nontradable and tradable firms choose prices to maximize discounted real profits subject to downward-sloping demands and Rotemberg-style adjustment costs. The nontradable price-setting problem is:

\[
\max_{\{p_\tau(n)\}_{\tau=t}^{\infty}}E_t\sum_{\tau=t}^{\infty}
D_{t,\tau}(p_\tau(n)-MC_\tau(n))p_\tau(n)^{-\theta}P_{N,\tau}^{\theta}
\left[N_{N,\tau}+\eta(Q_\tau+M_\tau)+G_{N,\tau}\right](1-\Gamma_{PN,\tau}(n)).
\]

### 2.3 Households

Home household \(j\) maximizes expected lifetime utility:

\[
\mathscr W_t(j)=E_t\sum_{\tau=t}^{\infty}\beta^{\tau-t}\left[U(C_\tau(j))-V(\ell_\tau(j))\right],
\]

with habit-adjusted consumption utility and labor disutility:

\[
U_t(j)=Z_{U,t}\frac{(C_t(j)-bC_{t-1})^{1-\sigma}-1}{1-\sigma},
\qquad
V_t(j)=Z_{V,t}\frac{\ell_t(j)^{1+\zeta}}{1+\zeta}.
\]

The household chooses money, domestic bonds, foreign-currency bonds, capital, investment, consumption, and its wage subject to the nominal budget constraint, capital accumulation, and labor demand. The source budget constraint includes money, domestic and foreign bonds, rental income on capital and land, wage income net of wage-adjustment costs, consumption plus shopping costs, investment, profits/rebates, and lump-sum taxes.

### 2.4 Government and Monetary Authority

Government purchases final and nontradable goods and finances them through lump-sum taxes and seigniorage. The central bank controls the short nominal rate according to a generalized Taylor/IFB rule. In the Home-country MMB variant, the implementation cross-check uses the Home-country optimized generalized Taylor-rule row from Table 4.

## 3. First-Order Conditions

- **(F1) Nontradable basket price index**:

\[
P_{N,t}=\left[\frac{1}{s}\int_0^s p_t(n)^{1-\theta}\,dn\right]^{1/(1-\theta)}.
\]

- **(F2) Domestic tradable differentiated-good demand**:

\[
\int_0^s Q_t^D(h,x)\,dx=\left(\frac{p_t(h)}{P_{Q,t}}\right)^{-\theta}Q_t.
\]

- **(F3) Distribution-sector price wedge**:

\[
p_t(n)=\bar p_t(n),\qquad p_t(h)=\bar p_t(h)+\eta P_{N,t},\qquad p_t(f)=\bar p_t(f)+\eta P_{N,t}.
\]

- **(F4) Nontradable-good demand including distribution services**:

\[
N_t^D(n)=\left(\frac{p_t(n)}{P_{N,t}}\right)^{-\theta}
\left[N_{N,t}+\eta(Q_t+M_t)+G_{N,t}\right].
\]

- **(F5) Labor-input demand and wage index**:

\[
\ell_t^D(n,j)=\frac{1}{s}\left(\frac{W_t(j)}{W_t}\right)^{-\phi}\ell_t(n),
\qquad
W_t=\left[\frac{1}{s}\int_0^s W_t(j)^{1-\phi}\,dj\right]^{1/(1-\phi)}.
\]

- **(F6) Nontradable marginal-cost index**:

\[
MC_{N,t}=Z_{N,t}^{-1}\left[(1-\alpha_N-\gamma_N)W_t^{1-\xi_N}
+\alpha_NR_t^{1-\xi_N}
+\gamma_NP_{O,N,t}^{1-\xi_N}\Xi_{O,N,t}^{\xi_N-1}\right]^{1/(1-\xi_N)}.
\]

`needs_review`: the paper states that cost minimization yields marginal cost but does not print this exact expression; the form is inferred from the CES dual and cross-checked against the implementation.

- **(F7) Tradable marginal-cost index**:

\[
MC_{T,t}=Z_{T,t}^{-1}\left[(1-\alpha_T-\gamma_T)W_t^{1-\xi_T}
+\alpha_TR_t^{1-\xi_T}
+\gamma_TP_{O,T,t}^{1-\xi_T}\Xi_{O,T,t}^{\xi_T-1}\right]^{1/(1-\xi_T)}.
\]

`needs_review`: same source limitation as (F6).

- **(F8) Raw-material marginal cost**:

\[
P_{QO,t}=
\frac{\left[(1-\alpha_O-\gamma_O)W_t^{1-\xi_O}
+\alpha_OR_t^{1-\xi_O}
+\gamma_OP_{L,t}^{1-\xi_O}\right]^{1/(1-\xi_O)}}{Z_{O,t}}.
\]

- **(F9) Law of one price for raw materials**:

\[
P_{MO,t}^{\ast}=\frac{P_{QO,t}}{\mathcal E_t}.
\]

- **(F10) Price-adjustment cost for nontradables**:

\[
\Gamma_{PN,t}(n)=\frac{\phi_N}{2}
\left(\frac{p_t(n)/p_{t-1}(n)}{P_{N,t-1}/P_{N,t-2}}-1\right)^2.
\]

- **(F11) Flexible-price markup limit for nontradables**:

\[
p_t(n)=\frac{\theta}{\theta-1}MC_t(n).
\]

- **(F12) Flexible-price export pricing with distribution costs**:

\[
\bar p_t(h)=\frac{\theta}{\theta-1}MC_t(h)+\frac{\eta}{\theta-1}P_{N,t},
\qquad
\mathcal E_t\bar p_t^{\ast}(h)=\frac{\theta}{\theta-1}MC_t(h)+\frac{\eta^{\ast}}{\theta-1}\mathcal E_tP_{N,t}^{\ast}.
\]

- **(F13) Stochastic discount factor / pricing kernel**:

\[
D_{t,\tau}=\beta^{\tau-t}\frac{P_tU'(C_\tau)\left[1+\Gamma_{S,t}+\Gamma'_{S,t}v_t\right]}
{P_\tau U'(C_t)\left[1+\Gamma_{S,\tau}+\Gamma'_{S,\tau}v_\tau\right]}.
\]

`needs_review`: MinerU OCR shows a leading \(\beta\) rather than \(\beta^{\tau-t}\) in Eq. (34); the exponent is inferred from Eq. (25).

- **(F14) Domestic-bond Euler equation**:

\[
1=(1+i_{t+1})E_tD_{t,t+1}.
\]

- **(F15) Risk-adjusted uncovered interest parity**:

\[
1=(1+i_{t+1}^{\ast})(1-\Gamma_{B,t+1})
E_t\left(D_{t,t+1}\frac{\mathcal E_{t+1}}{\mathcal E_t}\right).
\]

- **(F16) Foreign-bond intermediation wedge**:

\[
\Gamma_{B,t+1}=\phi_{B1}
\frac{\exp\left(\phi_{B2}\mathcal E_tB_{H,t+1}^{\ast}/P_t\right)-1}
{\exp\left(\phi_{B2}\mathcal E_tB_{H,t+1}^{\ast}/P_t\right)+1}
+Z_{B,t}.
\]

- **(F17) Capital accumulation**:

\[
K_{t+1}(j)=(1-\delta)K_t(j)+\Psi_tK_t(j).
\]

- **(F18) Investment adjustment technology**:

\[
\Psi_t=\frac{I_t(j)}{K_t(j)}
-\frac{\phi_{I1}}{2}\left(\frac{I_t(j)}{K_t(j)}-\delta(1+Z_{I,t})\right)^2
-\frac{\phi_{I2}}{2}\left(\frac{I_t(j)}{K_t(j)}-\frac{I_{t-1}}{K_{t-1}}\right)^2.
\]

- **(F19) Wage-adjustment cost**:

\[
\Gamma_{W,t}(j)=\frac{\phi_W}{2}
\left(\frac{W_t(j)/W_{t-1}(j)}{W_{t-1}/W_{t-2}}-1\right)^2.
\]

- **(F20) Household transversality condition**:

\[
\lim_{\tau\to\infty}E_tD_{t,\tau}
\left[\mathcal M_{\tau-1}(j)+(1+i_\tau)B_\tau(j)+(1+i_\tau^{\ast})(1-\Gamma_{B,\tau})\mathcal E_\tau B_\tau^{\ast}(j)\right]=0.
\]

- **(F21) Government budget constraint**:

\[
sP_tG_{A,t}+sP_{N,t}G_{N,t}
\leq \int_0^s NETT_t(j)\,dj+\int_0^s\left[\mathcal M_t(j)-\mathcal M_{t-1}(j)\right]\,dj.
\]

- **(F22) Annualized monetary policy rule**:

\[
(1+i_{t+1})^4-1=\omega_i\left[(1+i_t)^4-1\right]
+(1-\omega_i)\left[(1+\bar i_{t+1})^4-1\right]
+\omega_1E_t\left[\frac{P_{t+\tau}}{P_{t+\tau-4}}-\Pi_{t+\tau}\right]
+\Theta(F_t).
\]

`needs_review`: paper Eq. (38) has OCR ambiguity around the forecast horizon symbol and target inflation notation.

## 4. Market Clearing & Identities

- **(F23) Raw-material market clearing**:

\[
\int_0^s T_{O,t}^S(o)\,do
=\int_0^s Q_{O,t}^D(n)\,dn+\int_0^s Q_{O,t}^D(h)\,dh
+\int_s^1 M_{O,t}^{D\ast}(n^{\ast})\,dn^{\ast}+\int_s^1 M_{O,t}^{D\ast}(f)\,df.
\]

- **(F24) Nontradable market clearing**:

\[
N^S(n)=\int_0^s N_{N,t}^D(n,x)\,dx+\eta(Q_t+M_t)+G_{N,t}.
\]

- **(F25) Tradable-goods market clearing**:

\[
T^S(h)=\int_0^s Q_t^D(h,x)\,dx+\int_s^1 M_t^{\astD}(h,x^{\ast})\,dx^{\ast}.
\]

- **(F26) Final-good resource constraint**:

\[
\int_0^s A_t(x)\,dx=\int_0^s C_t(j)(1+\Gamma_{S,t}(j))\,dj+sG_{A,t}+\int_0^s I_t(j)\,dj.
\]

- **(F27) Labor market clearing**:

\[
\ell_t(j)=\int_0^s\ell_t^D(n,j)\,dn+\int_0^s\ell_t^D(h,j)\,dh+\int_0^s\ell_t^D(o,j)\,do.
\]

- **(F28) Capital market clearing**:

\[
\int_0^sK_t(j)\,dj=\int_0^sK_t^D(n)\,dn+\int_0^sK_t^D(h)\,dh+\int_0^sK_t^D(o)\,do.
\]

- **(F29) Land market clearing**:

\[
\int_0^s\bar L_t(j)\,dj=\int_0^sL_t^D(o)\,do.
\]

- **(F30) Asset-market clearing**:

\[
\int_0^sB_t(j)\,dj=0,\qquad
\int_0^sB_t^{\ast}(j)\,dj+\int_s^1B_t^{\ast}(j^{\ast})\,dj^{\ast}=0.
\]

`needs_review`: MinerU merged the two asset-clearing equations in Eq. (46); separation follows the surrounding prose.

- **(F31) Home GDP identity, implementation cross-check only**:

\[
GDPH=AH+REALPNH\cdot GNH+EXPORTSH-IMPORTSH+(RNOMF_{t-1}-1)\frac{REALEX_tREALBH_{t-1}}{PIEF_t}.
\]

- **(F32) Home current-account ratio, implementation cross-check only**:

\[
CURBALH\_RAT=\frac{REALEX_t(REALBH_t-REALBH_{t-1}/PIEF_t)}{GDPH_t}.
\]

## 5. Exogenous Processes

The paper states that each stochastic process has AR(1) form \(y_t=(1-\psi)\bar y+\psi y_{t-1}+\epsilon_t^y\), applied either to the level or the logarithm.

- **(F33) Generic level shock**:

\[
y_t=(1-\rho_y)\bar y+\rho_yy_{t-1}+\varepsilon_t^y.
\]

- **(F34) Generic log shock**:

\[
\log y_t=(1-\rho_y)\log\bar y+\rho_y\log y_{t-1}+\varepsilon_t^y.
\]

- **(F35) Risk-premium shock**:

\[
Z_{B,t}=(1-\rho_B)\bar Z_B+\rho_BZ_{B,t-1}+\varepsilon_t^B.
\]

- **(F36) Tradable-preference weight shock**:

\[
\log\gamma_t=(1-\rho_\gamma)\log\bar\gamma+\rho_\gamma\log\gamma_{t-1}+\varepsilon_t^\gamma.
\]

Source and implementation cross-check indicate shocks to productivity \((Z_N,Z_T,Z_O)\), investment/depreciation \((Z_I)\), marginal utility of consumption \((Z_U)\), marginal disutility of labor \((Z_V)\), government absorption \((G_A)\), preference shifter \((\gamma)\), risk premium \((Z_B)\), land/productivity group shocks, and inflation-target shocks.

## 6. Steady-State Solution

The paper does not print a full closed-form steady-state block. It states that the nonlinear steady state is solved with Newton-based divide-and-conquer methods, beginning from an easier nearly linear parameterization and gradually adjusting parameters/exogenous variables to the target calibration. Therefore the first-pass archive records the source-backed steady-state restrictions rather than inventing a closed-form solution.

Key steady-state restrictions:

- **(F37) Gross steady-state real rate**:

\[
1+r=\frac{1}{\beta}.
\]

- **(F38) Steady-state nominal rate and inflation**:

\[
1+i=\frac{\pi}{\beta}.
\]

- **(F39) No-intermediation steady state for net foreign assets**:

\[
B_H^{\ast}=0,\qquad \Gamma_B=0.
\]

- **(F40) Capital rental steady-state restriction**:

\[
1+\frac{R}{P}=\frac{1}{\beta}+\delta.
\]

- **(F41) Real wage steady-state condition**:

\[
\frac{W}{P}=\frac{\phi}{\phi-1}\frac{V'(\ell)}{U'(C)}.
\]

- **(F42) Government spending shares**:

\[
\frac{G_N}{GDP}=0.10,\qquad \frac{G_A}{GDP}=0.05.
\]

- **(F43) Core calibration values**:

\[
s=0.05,\quad \beta=1.03^{-0.25},\quad \theta=\theta^{\ast}=6,\quad
\phi=\phi^{\ast}=4,\quad \delta=\delta^{\ast}=0.025.
\]

Additional steady-state targets recorded by the source include Home import shares, Home/Foreign openness weights, material/input shares, distribution parameters, habit persistence \(b=0.95\), intertemporal elasticity parameter \(\sigma=1/3\), and labor-disutility curvature \(\zeta=2.5\). The implementation cross-check includes numeric `initval` values, but these are not promoted here as paper-side derivation evidence.

## 7. Timing & Form Conventions

- Period is quarterly.
- Stocks: the paper writes capital as \(K_{t+1}=(1-\delta)K_t+\Psi_tK_t\); the Rep-MMB code expresses this as `K = K(-1)*(1-delta)+PSI(-1)*K(-1)`, so production in period \(t\) uses predetermined capital.
- Bonds: short nominal rates \(i_t\) and \(i_t^{\ast}\) are paid at the beginning of period \(t\) and known at \(t-1\); the Euler equations use \(i_{t+1}\) chosen at \(t\).
- Exchange rate: \(\mathcal E_t\) is Home currency per unit of Foreign currency. Depreciation enters the risk-adjusted UIP condition.
- Country notation: paper uses no star for Home and star for Foreign. The implementation uses `H` for the small Home economy and `F` for the large Foreign economy.
- Model form: nonlinear equilibrium conditions are solved for the steady state and then linearized for stochastic policy analysis. The MMB implementation is not declared `model(linear)`.
- Runtime validation: not performed; no Dynare command was run.
- Formula uncertainty: equations (F4), (F6), (F7), (F13), (F22), and (F30) are `needs_review` due to OCR damage, source prose instead of printed FOCs, or implementation-only compression.

## 8. Variable & Parameter Reference Table

### Endogenous Variables

| Symbol / ASCII | Meaning | Equation reference |
|---|---|---|
| \(A\), `AH`, `AF` | final good / absorption | (F26), (F31) |
| \(N_N\), `NNH`, `NNF` | nontradable input basket | (F1), (F4), (F24) |
| \(Q\), `QH`, `QF` | domestic tradable basket | (F2), (F23), (F25) |
| \(M\), `MH`, `MF` | imported tradable basket | (F3), (F4), (F26) |
| \(N\), `NH`, `NF` | nontradable intermediate output | (F4), (F24) |
| \(T\), `TH`, `TF` | tradable intermediate output | (F25) |
| \(T_O\), `T_OH`, `T_OF` | raw-material output | (F8), (F23) |
| \(O_N,O_T\), `O_NH`, `O_TH` | material composite inputs | (F6), (F7) |
| \(C\), `CH`, `CF` | consumption | (F13), (F26) |
| \(I\), `EYEH`, `EYEF` | investment | (F17), (F18), (F26) |
| \(K\), `KH`, `KF` | capital stock | (F17), (F28), (F40) |
| \(\ell\), `LH`, `LF` | labor | (F5), (F27), (F41) |
| \(L\), `LANDH`, `LANDF` | land | (F8), (F29) |
| \(P_N,P_Q,P_M\), `REALPNH`, `REALPQH`, `REALPMH` | relative prices | (F1), (F3), (F8) |
| \(MC_N,MC_T\), `REALMCNH`, `REALMCTH` | real marginal costs | (F6), (F7), (F11), (F12) |
| \(W\), `REALWH`, `REALWF` | wage | (F5), (F19), (F41) |
| \(R\), `REALRH`, `REALRF` | capital rental rate | (F6), (F7), (F40) |
| \(i\), `RNOMH`, `RNOMF` | nominal policy rate | (F14), (F22), (F38) |
| \(B^{\ast}\), `REALBH`, `REALBF` | foreign-currency bond position | (F15), (F16), (F30), (F32) |
| \(\mathcal E\), `REALEX` | nominal/real exchange-rate block | (F9), (F15), (F32) |
| \(GDP\), `GDPH`, `GDPF` | GDP accounting object | (F31), (F32) |
| \(\Pi_4\), `PIE4H`, `PIE4F` | annual inflation | (F22), (F38) |

### Exogenous Shocks

| Symbol / ASCII | Meaning | Process |
|---|---|---|
| \(Z_B\), `ZBH`, `ZBF` | risk-premium / UIP shock | (F35) |
| \(Z_N,Z_T,Z_O\) | sector productivity shocks | (F34) |
| \(Z_I\), `ZEYEH`, `ZEYEF` | investment/depreciation shock | (F33) |
| \(Z_U\), `ZUH`, `ZUF` | marginal utility of consumption shock | (F34) |
| \(Z_V\), `CAPAH`, `CAPAF` | labor disutility shock in implementation | (F33) |
| \(G_A\), `GAH`, `GAF` | government absorption shock | (F33) |
| \(\gamma\), `GAMMAH`, `GAMMAF` | tradable preference-weight shock | (F36) |
| `E_PIE4TARH`, `E_PIE4TARF` | inflation-target innovation | (F33) |

### Parameters

| Symbol / ASCII | Meaning | Source value / note |
|---|---|---|
| \(s\), `SSH` | Home country size | \(0.05\) |
| \(\beta\), `BET` | discount factor | \(1.03^{-0.25}\) |
| \(\theta\), `THETAH`, `THETAF` | intermediate-goods elasticity | \(6\) |
| \(\phi\), `PHIH`, `PHIF` | labor-input elasticity | \(4\) in paper calibration; implementation parameterization uses related wage markup objects |
| \(\epsilon\), `EPSH`, `EPSF` | tradable/nontradable elasticity | \(1.1\) |
| \(\epsilon_{QM}\), `EPSQMH`, `EPSQMF` | Home/Foreign tradable composite elasticity | Home and Foreign differ by calibration |
| \(\xi_N,\xi_T,\xi_O\), `XIXI_*` | input substitution elasticities | \(0.75\) baseline |
| \(\alpha_N,\alpha_T,\alpha_O\) | capital shares | sector and country specific |
| \(\gamma_N,\gamma_T,\gamma_O\) | material/land shares | sector and country specific |
| \(\eta\), `ETAH`, `ETAF` | distribution-service parameter | Home \(0.2\), Foreign \(0.35\) in paper text |
| \(b\), `B1H`, `B1F` | habit persistence | \(0.95\) |
| \(\sigma\), `SIGMAH`, `SIGMAF` | consumption curvature | \(1/3\) |
| \(\zeta\), `ZEDH`, `ZEDF` | labor-disutility curvature | \(2.5\) |
| \(\delta\), `DELTAH`, `DELTAF` | depreciation | \(0.025\) |
| \(\phi_{B1},\phi_{B2}\), `CHI0`, `CHI1` | bond intermediation cost parameters | \(0.05\), \(0.1\) |
| \(\omega_i,\omega_1,\omega_2\), `XR3H`, `XR1H`, `XR2H` | policy-rule coefficients | MMB variant uses Table 4 row-2 optimized values in implementation |
