# EAES_RA09 - Derivation

> First-pass private archive entry for Dynare replication work. Status: `needs_review`.

Provenance: `EAES_RA09`, Pau Rabanal (2009), "Inflation differentials between Spain and the EMU: A DSGE perspective", Journal of Money, Credit and Banking 41(6), 1141-1166, DOI `10.1111/j.1538-4616.2009.00250.x`. Main source: `raw/mmb_mineru/runs/eaes_ra09__inflation_differentials_between_spain_and_the_emu_a_dsge_perspective__9d18a448/full.md`. Raw PDF exists at `raw/mmb_papers/Inflation differentials between Spain and the EMU- A DSGE perspective.pdf`; PDF body was not read. MinerU run id: `9d18a448-9e8f-4f5d-afd4-ccab95a34c76`. Appendix normalization: none found.

## 1. Model Overview

- **Model**: two-country, two-sector New Keynesian DSGE model of a monetary union. Home is Spain; foreign is the rest of the EMU.
- **Purpose**: explain Spain-EMU inflation differentials using sectoral productivity shocks, demand/government-spending shocks, sectoral price rigidity and a common ECB Taylor rule.
- **Agents and blocks**: representative home and foreign households; monopolistically competitive intermediate producers in tradable and nontradable sectors; government-spending demand processes; common monetary authority.
- **Goods**: home nontradable $N$, home tradable $H$, foreign nontradable $N^{\ast}$, foreign tradable $F$. Tradable goods are differentiated by country and cannot be price-discriminated inside the currency area.
- **Model form**: the paper presents nonlinear preferences, CES aggregators, production, Calvo pricing, trends and normalization. The Rep-MMB implementation is `model(linear)` and uses stationary percent deviations from trend. The complete appendix equilibrium system was not available in the Markdown source, so this derivation records a source-backed nonlinear skeleton plus a linear implementation cross-check.
- **Runtime validation**: not performed.

## 2. Optimization Problems

### 2.1 Home Household

The home household chooses consumption, labor and asset holdings. Preferences are external-habit in aggregate home consumption:

$$
\max_{\{C_t^j,L_t^j,B_t\}} E_0 \sum_{t=0}^{\infty} \beta^t
\left[
\log(C_t^j-b C_{t-1})-\frac{(L_t^j)^{1+\varpi}}{1+\varpi}
\right].
$$

Labor disutility aggregates tradable and nontradable hours:

$$
L_t=L_t^T+L_t^N.
$$

The euro-denominated budget constraint is:

$$
\frac{B_t}{P_t R_t}\leq \frac{B_{t-1}}{P_t}+W_t L_t-C_t+\zeta_t.
$$

The foreign household solves the analogous problem with starred variables and foreign parameters.

### 2.2 Consumption Aggregators

The home consumption index combines tradable and nontradable goods:

$$
C_t=\left[
\gamma^{1/\varepsilon}(C_t^T)^{(\varepsilon-1)/\varepsilon}
+(1-\gamma)^{1/\varepsilon}(\xi_t^{N,C})^{1/\varepsilon}(C_t^N)^{(\varepsilon-1)/\varepsilon}
\right]^{\varepsilon/(\varepsilon-1)}.
$$

Tradable consumption combines home and foreign tradables:

$$
C_t^T=\left[
\lambda^{1/\nu}(C_t^H)^{(\nu-1)/\nu}
+(1-\lambda)^{1/\nu}(\xi_t^{F,C})^{1/\nu}(C_t^F)^{(\nu-1)/\nu}
\right]^{\nu/(\nu-1)}.
$$

Variety aggregators are CES:

$$
C_t^H=\left[\left(\frac{1}{s}\right)^{1/\sigma}\int_0^s c_t(h)^{(\sigma-1)/\sigma}dh\right]^{\sigma/(\sigma-1)},\quad
C_t^F=\left[\left(\frac{1}{1-s}\right)^{1/\sigma}\int_s^1 c_t(f)^{(\sigma-1)/\sigma}df\right]^{\sigma/(\sigma-1)}.
$$

$$
C_t^N=\left[\left(\frac{1}{s}\right)^{1/\sigma}\int_0^s c_t^N(n)^{(\sigma-1)/\sigma}dn\right]^{\sigma/(\sigma-1)}.
$$

Foreign aggregators are symmetric with starred variables and parameters.

### 2.3 Intermediate Firms

Home nontradable firm $n$ produces with labor only:

$$
y_t^N(n)=X_t Z_t^N L_t^N(n).
$$

Home tradable firm $h$ produces:

$$
y_t^H(h)=X_t Z_t^T L_t^T(h).
$$

Nontradable firms choose an optimal reset price under Calvo non-reoptimization probability $\theta_N$ and indexation share $\varphi_N$:

$$
\max_{\hat p_t^N(n)} E_t\sum_{k=0}^{\infty}\theta_N^k\Lambda_{t,t+k}
\left[
\frac{\hat p_t^N(n)\left(P_{t+k-1}^N/P_{t-1}^N\right)^{\varphi_N}(\Pi^N)^{k(1-\varphi_N)}}{P_{t+k}}
-MC_{t+k}^N
\right]y_{t+k}^{N,d}(n).
$$

subject to:

$$
y_{t+k}^{N,d}(n)=\frac{1-\gamma}{s}
\left[
\frac{\hat p_t^N(n)}{P_{t+k}^N}
\left(\frac{P_{t+k-1}^N}{P_{t-1}^N}\right)^{\varphi_N}
(\Pi^N)^{k(1-\varphi_N)}
\right]^{-\sigma}Y_{t+k}^N.
$$

The home tradable and foreign sector pricing problems are analogous, with sector-specific $\theta$, $\varphi$, productivity and demand variables. The source states that the full pricing equations are in an appendix available on request; detailed Phillips-curve expressions below therefore remain `needs_review`.

## 3. First-Order Conditions

**Households and complete markets**

- **(F1) Home Euler equation**:

$$
\mu_t=E_t\mu_{t+1}+r_t-E_t\pi_{t+1}.
$$

In the linear Rep-MMB implementation this appears as `mu=mu(+1)+(r-pi(+1));`.

- **(F2) Home marginal utility with habit**:

$$
-\mu_t\left(1-\frac{b}{(1+x)(1+\alpha^T)}\right)
=c_t-\frac{b}{(1+x)(1+\alpha^T)}c_{t-1}.
$$

- **(F3) Foreign marginal utility with habit**:

$$
-\mu_t^{\ast}\left(1-\frac{b^{\ast}}{(1+x)(1+\alpha^{T\ast})}\right)
=c_t^{\ast}-\frac{b^{\ast}}{(1+x)(1+\alpha^{T\ast})}c_{t-1}^{\ast}.
$$

- **(F4) Complete-markets risk sharing**:

$$
rer_t=\mu_t^{\ast}-\mu_t.
$$

The nonlinear source condition is $RER_t=P_t^{\ast}/P_t=\mu_t^{\ast}/\mu_t$.

- **(F5) Home labor supply**:

$$
\bar w\,l_t=w_t+\mu_t.
$$

- **(F6) Foreign labor supply**:

$$
\bar w^{\ast}\,l_t^{\ast}=w_t^{\ast}+\mu_t^{\ast}.
$$

**Intratemporal consumption demand**

- **(F7) Home demand for home tradables**:

$$
c_{H,t}=-\nu t_{H,t}-(\varepsilon-\nu)t_{T,t}+c_t.
$$

- **(F8) Home demand for imported tradables**:

$$
c_{F,t}=-\nu t_{F,t}-(\varepsilon-\nu)t_{T,t}+c_t.
$$

- **(F9) Home demand for nontradables**:

$$
c_{N,t}=-\varepsilon t_{N,t}+c_t.
$$

- **(F10) Foreign demand for home tradables**:

$$
c_{H,t}^{\ast}=-\nu t_{H,t}^{\ast}-(\varepsilon-\nu)t_{T,t}^{\ast}+c_t^{\ast}.
$$

- **(F11) Foreign demand for foreign tradables**:

$$
c_{F,t}^{\ast}=-\nu t_{F,t}^{\ast}-(\varepsilon-\nu)t_{T,t}^{\ast}+c_t^{\ast}.
$$

- **(F12) Foreign demand for nontradables**:

$$
c_{N,t}^{\ast}=-\varepsilon t_{N,t}^{\ast}+c_t^{\ast}.
$$

**Production and pricing**

- **(F13) Home labor aggregation**:

$$
l_t=(1-\gamma)l_{N,t}+\gamma l_{T,t}.
$$

- **(F14) Foreign labor aggregation**:

$$
l_t^{\ast}=(1-\gamma^{\ast})l_{N,t}^{\ast}+\gamma^{\ast}l_{T,t}^{\ast}.
$$

- **(F15) Home nontradable production**:

$$
y_{N,t}=z_{N,t}+l_{N,t}.
$$

- **(F16) Home tradable production**:

$$
y_{H,t}=z_{T,t}+l_{T,t}.
$$

- **(F17) Foreign nontradable production**:

$$
y_{N,t}^{\ast}=z_{N,t}^{\ast}+l_{N,t}^{\ast}.
$$

- **(F18) Foreign tradable production**:

$$
y_{F,t}^{\ast}=z_{T,t}^{\ast}+l_{T,t}^{\ast}.
$$

- **(F19) Home nontradable Phillips curve** (`needs_review` appendix expression, implementation cross-check):

$$
\pi_{N,t}-\varphi_N\pi_{N,t-1}
=\kappa_N(w_t-t_{N,t}-z_{N,t})
+\beta\frac{1+\alpha_N}{1+\alpha_T}\left(\pi_{N,t+1}-\varphi_N\pi_{N,t}\right),
$$

where $\kappa_N=(1-\theta_N)(1-\beta\theta_N(1+\alpha_N)/(1+\alpha_T))/\theta_N$.

- **(F20) Home tradable Phillips curve** (`needs_review` appendix expression, implementation cross-check):

$$
\pi_{H,t}-\varphi_H\pi_{H,t-1}
=\kappa_H(w_t-t_{H,t}-z_{T,t})
+\beta(\pi_{H,t+1}-\varphi_H\pi_{H,t}),
$$

where $\kappa_H=(1-\theta_H)(1-\beta\theta_H)/\theta_H$.

- **(F21) Foreign nontradable Phillips curve** (`needs_review` appendix expression, implementation cross-check):

$$
\pi_{N,t}^{\ast}-\varphi_N^{\ast}\pi_{N,t-1}^{\ast}
=\kappa_N^{\ast}(w_t^{\ast}-t_{N,t}^{\ast}-z_{N,t}^{\ast})
+\beta\frac{1+\alpha_N^{\ast}}{1+\alpha_T^{\ast}}\left(\pi_{N,t+1}^{\ast}-\varphi_N^{\ast}\pi_{N,t}^{\ast}\right).
$$

- **(F22) Foreign tradable Phillips curve** (`needs_review` appendix expression, implementation cross-check):

$$
\pi_{F,t}-\varphi_F^{\ast}\pi_{F,t-1}
=\kappa_F^{\ast}(w_t^{\ast}-t_{F,t}^{\ast}-z_{T,t}^{\ast})
+\beta(\pi_{F,t+1}-\varphi_F^{\ast}\pi_{F,t}).
$$

## 4. Market Clearing & Identities

- **(F23) Home CPI inflation**:

$$
\pi_t=\gamma\lambda\pi_{H,t}+\gamma(1-\lambda)\pi_{F,t}+(1-\gamma)\pi_{N,t}.
$$

- **(F24) Foreign CPI inflation**:

$$
\pi_t^{\ast}=\gamma^{\ast}(1-\lambda^{\ast})\pi_{H,t}+\gamma^{\ast}\lambda^{\ast}\pi_{F,t}+(1-\gamma^{\ast})\pi_{N,t}^{\ast}.
$$

- **(F25) EMU CPI inflation**:

$$
\pi_t^{EMU}=s\pi_t+(1-s)\pi_t^{\ast}.
$$

- **(F26) Home GDP growth identity**:

$$
dy_t=y_t-y_{t-1}.
$$

- **(F27) Foreign GDP growth identity**:

$$
dy_t^{\ast}=y_t^{\ast}-y_{t-1}^{\ast}.
$$

- **(F28) Home relative nontradable price**:

$$
t_{N,t}=-\frac{\gamma}{1-\gamma}t_{T,t}.
$$

- **(F29) Home tradable price index**:

$$
t_{T,t}=\lambda t_{H,t}+(1-\lambda)t_{F,t}.
$$

- **(F30) Home tradable relative prices**:

$$
t_{H,t}=t_{H,t-1}+\pi_{H,t}-\pi_t,\quad
t_{F,t}=t_{F,t-1}+\pi_{F,t}-\pi_t.
$$

- **(F31) Foreign nontradable relative price**:

$$
t_{N,t}^{\ast}=t_{N,t-1}^{\ast}+\pi_{N,t}^{\ast}-\pi_t^{\ast}.
$$

- **(F32) Foreign tradable relative prices**:

$$
t_{T,t}^{\ast}=(1-\lambda^{\ast})t_{H,t}^{\ast}+\lambda^{\ast}t_{F,t}^{\ast},\quad
t_{H,t}^{\ast}=t_{H,t-1}^{\ast}+\pi_{H,t}-\pi_t^{\ast},\quad
t_{F,t}^{\ast}=t_{F,t-1}^{\ast}+\pi_{F,t}-\pi_t^{\ast}.
$$

- **(F33) Real exchange rate relative-price identity**:

$$
rer_t=-(1-\gamma)(t_{N,t}-t_{T,t})+(1-\gamma^{\ast})(t_{N,t}^{\ast}-t_{T,t}^{\ast})+(1-\lambda-\lambda^{\ast})(t_{H,t}-t_{F,t}).
$$

- **(F34) Home nontradable market clearing**:

$$
y_{N,t}=(1-\eta)c_{N,t}+\eta g_{N,t}.
$$

- **(F35) Home tradable market clearing**:

$$
y_{H,t}=(1-\eta)\left[\lambda c_{H,t}+(1-\lambda)c_{H,t}^{\ast}\right]+\eta g_{T,t}.
$$

- **(F36) Foreign nontradable market clearing**:

$$
y_{N,t}^{\ast}=(1-\eta^{\ast})c_{N,t}^{\ast}+\eta^{\ast}g_{N,t}^{\ast}.
$$

- **(F37) Foreign tradable market clearing**:

$$
y_{F,t}^{\ast}=(1-\eta^{\ast})\left[(1-\lambda^{\ast})c_{F,t}+\lambda^{\ast}c_{F,t}^{\ast}\right]+\eta^{\ast}g_{T,t}^{\ast}.
$$

- **(F38) Home real GDP aggregation**:

$$
y_t=\gamma(t_{H,t}+y_{H,t})+(1-\gamma)(t_{N,t}+y_{N,t}).
$$

- **(F39) Foreign real GDP aggregation**:

$$
y_t^{\ast}=\gamma^{\ast}(t_{F,t}^{\ast}+y_{F,t}^{\ast})+(1-\gamma^{\ast})(t_{N,t}^{\ast}+y_{N,t}^{\ast}).
$$

- **(F40) Common monetary policy rule**:

$$
r_t=\rho_r r_{t-1}+(1-\rho_r)\gamma_{\pi}\pi_t^{EMU}+\varepsilon_t^m.
$$

The nonlinear source rule is $R_t=\bar R^{1-\rho_r}R_{t-1}^{\rho_r}(\Pi_t^{EMU}/\Pi)^{(1-\rho_r)\gamma_\pi}\exp(\varepsilon_t^m)$.

## 5. Exogenous Processes

- **(F41) Home tradable productivity**:

$$
z_{T,t}=\rho_{ZT}z_{T,t-1}+\varepsilon_t^{ZT}+\varepsilon_t^Z.
$$

- **(F42) Home nontradable productivity**:

$$
z_{N,t}=\rho_{ZN}z_{N,t-1}+\varepsilon_t^{ZN}.
$$

- **(F43) Foreign tradable productivity**:

$$
z_{T,t}^{\ast}=\rho_{ZT}^{\ast}z_{T,t-1}^{\ast}+\varepsilon_t^{ZT\ast}+\varepsilon_t^Z.
$$

- **(F44) Foreign nontradable productivity**:

$$
z_{N,t}^{\ast}=\rho_{ZN}^{\ast}z_{N,t-1}^{\ast}+\varepsilon_t^{ZN\ast}.
$$

- **(F45) Home tradable demand/government spending**:

$$
g_{T,t}=\rho_{GT}g_{T,t-1}+\varepsilon_t^{GT}.
$$

- **(F46) Home nontradable demand/government spending**:

$$
g_{N,t}=\rho_{GN}g_{N,t-1}+\varepsilon_t^{GN}.
$$

- **(F47) Foreign tradable demand/government spending**:

$$
g_{T,t}^{\ast}=\rho_{GT}^{\ast}g_{T,t-1}^{\ast}+\varepsilon_t^{GT\ast}.
$$

- **(F48) Foreign nontradable demand/government spending**:

$$
g_{N,t}^{\ast}=\rho_{GN}^{\ast}g_{N,t-1}^{\ast}+\varepsilon_t^{GN\ast}.
$$

The paper-level nonlinear trend processes are $X_t=(1+x)^tX_0$, $Z_t^i=(1+\alpha^i)^t\tilde Z_t^i$, and $G_t^i=[(1+\alpha^i)(1+x)]^t\tilde G_t^i$. The linear implementation sets estimated trend parameters to zero for Rep-MMB IRF matching; this is an implementation convention, not a paper-side restriction.

## 6. Steady-State Solution

The paper uses a stationary normalized system because real sectoral quantities contain deterministic trends. In normalized variables, the paper implies:

1. Set steady innovations to zero: $\varepsilon^m=\varepsilon^{Z}=\varepsilon^{ZT}=\varepsilon^{ZN}=\varepsilon^{ZT\ast}=\varepsilon^{ZN\ast}=\varepsilon^{GT}=\varepsilon^{GN}=\varepsilon^{GT\ast}=\varepsilon^{GN\ast}=0$.
2. Set normalized productivity and demand states to their means: $\tilde Z^i=1$ and $\tilde G^i$ constant.
3. Sectoral balanced-growth rates are $(1+x)(1+\alpha^i)$ for quantities in sector $i$.
4. Model-consistent observable constants are $\Delta p=\pi-\alpha^T$, $\Delta p^N=\pi-\alpha^N$, $\Delta p^{\ast}=\pi-\alpha^{T\ast}$, $\Delta p^{N\ast}=\pi-\alpha^{N\ast}$, $\Delta y=x+\alpha^T$, $\Delta y^N=x+\alpha^N$, $\Delta y^{\ast}=x+\alpha^{T\ast}$, $\Delta y^{N\ast}=x+\alpha^{N\ast}$, and $r=x+\pi-\log\beta$.
5. In the Rep-MMB `model(linear)` file, all endogenous variables are deviations from trend; therefore the implemented deterministic steady state is zero for all endogenous variables after `steady;`.

`needs_review`: the full nonlinear steady-state algebra for reset prices and normalized sectoral relative prices is not fully recoverable from the paper Markdown because the paper refers to an appendix available upon request for the complete pricing equations.

## 7. Timing & Form Conventions

- Form: `model(linear)` in the Rep-MMB implementation. The paper's conceptual model is nonlinear, then normalized and linearized for Bayesian estimation.
- Timing: implementation variables are stationary deviations. Lagged variables appear in habit, inflation indexation, relative-price accumulation, GDP growth, interest-rate smoothing and AR(1) shock states.
- Shared currency: there is one nominal interest rate and one ECB policy rule targeting EMU HICP inflation.
- Complete markets: the risk-sharing condition links the real exchange rate to relative marginal utilities.
- Tradable pricing: home and foreign tradable prices are common across countries in the currency area, so relative-price identities use $\pi_H$ and $\pi_F$ in both home and foreign CPI blocks.
- Stock variables: no physical capital is present; production uses labor only.
- Appendix gap: the paper states that the full pricing equations are available in an appendix on request. Equations marked `needs_review` should be source-checked against that appendix before promotion.

## 8. Variable & Parameter Reference Table

### Endogenous variables

| Category | Symbol | Meaning | Main equations |
|---|---|---|---|
| Endogenous | $dy_t,dy_t^{\ast}$ | Home and foreign GDP growth | (F26), (F27) |
| Endogenous | $\mu_t,\mu_t^{\ast}$ | Marginal utility states | (F1)-(F4) |
| Endogenous | $r_t$ | Common nominal policy rate in linear implementation | (F1), (F40) |
| Endogenous | $\pi_t,\pi_t^{\ast},\pi_t^{EMU}$ | Home, foreign and EMU CPI inflation | (F23)-(F25) |
| Endogenous | $c_t,c_t^{\ast}$ | Aggregate consumption | (F2), (F3), (F7)-(F12) |
| Endogenous | $rer_t$ | Real exchange rate | (F4), (F33) |
| Endogenous | $t_N,t_H,t_F,t_T,t_N^{\ast},t_H^{\ast},t_F^{\ast},t_T^{\ast}$ | Relative prices | (F28)-(F33) |
| Endogenous | $c_H,c_F,c_N,c_H^{\ast},c_F^{\ast},c_N^{\ast}$ | Consumption by good origin/sector | (F7)-(F12), (F34)-(F37) |
| Endogenous | $l,l^{\ast},w,w^{\ast}$ | Aggregate labor and wages | (F5), (F6), (F13), (F14) |
| Endogenous | $l_N,l_T,l_N^{\ast},l_T^{\ast}$ | Sectoral labor | (F13)-(F18) |
| Endogenous | $y_N,y_H,y_N^{\ast},y_F^{\ast}$ | Sectoral output | (F15)-(F18), (F34)-(F37) |
| Endogenous | $z_N,z_T,z_N^{\ast},z_T^{\ast}$ | Productivity states | (F41)-(F44) |
| Endogenous | $\pi_N,\pi_H,\pi_N^{\ast},\pi_F$ | Sectoral inflation | (F19)-(F25), (F30)-(F32) |
| Endogenous | $g_N,g_T,g_N^{\ast},g_T^{\ast}$ | Sectoral demand/government spending states | (F45)-(F48) |
| Endogenous | $y,y^{\ast}$ | Real GDP aggregates | (F38), (F39) |

### Exogenous shocks

| Symbol | Meaning |
|---|---|
| $\varepsilon_t^m$ | Monetary policy innovation |
| $\varepsilon_t^Z$ | Common tradable technology innovation |
| $\varepsilon_t^{ZT},\varepsilon_t^{ZN}$ | Home tradable and nontradable technology innovations |
| $\varepsilon_t^{ZT\ast},\varepsilon_t^{ZN\ast}$ | Foreign tradable and nontradable technology innovations |
| $\varepsilon_t^{GT},\varepsilon_t^{GN}$ | Home tradable and nontradable demand/government-spending innovations |
| $\varepsilon_t^{GT\ast},\varepsilon_t^{GN\ast}$ | Foreign tradable and nontradable demand/government-spending innovations |

### Parameters

| Symbol | Meaning |
|---|---|
| $\beta$ | Discount factor |
| $b,b^{\ast}$ | Habit persistence |
| $x$ | EMU aggregate real growth trend |
| $\alpha_T,\alpha_N,\alpha_T^{\ast},\alpha_N^{\ast}$ | Sector/country productivity trends |
| $\varepsilon$ | Elasticity between tradable and nontradable goods |
| $\nu$ | Elasticity between home and foreign tradables |
| $\sigma$ | Elasticity across varieties |
| $\gamma,\gamma^{\ast}$ | Tradable weights in home and foreign consumption baskets |
| $\lambda,\lambda^{\ast}$ | Home/foreign bias weights in tradable baskets |
| $s$ | Home country weight in EMU |
| $\bar w,\bar w^{\ast}$ | Labor disutility scale in linear implementation |
| $\varpi$ | Inverse labor-supply elasticity in paper notation |
| $\theta_N,\theta_H,\theta_N^{\ast},\theta_F^{\ast}$ | Calvo non-reoptimization probabilities |
| $\varphi_N,\varphi_H,\varphi_N^{\ast},\varphi_F^{\ast}$ | Inflation indexation shares |
| $\eta,\eta^{\ast}$ | Government-spending shares |
| $\rho_r,\gamma_\pi$ | Monetary policy smoothing and inflation response |
| $\rho_{ZT},\rho_{ZN},\rho_{ZT}^{\ast},\rho_{ZN}^{\ast}$ | Technology shock persistence |
| $\rho_{GT},\rho_{GN},\rho_{GT}^{\ast},\rho_{GN}^{\ast}$ | Demand/government-spending shock persistence |
