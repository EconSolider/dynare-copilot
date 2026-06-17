# NK_PSV16 - Derivation (optimization problems and equilibrium conditions)

> This derivation is a first-pass private archive entry for Model ID `NK_PSV16`. It is source-backed by the MinerU Markdown of Pancrazi, Seoane, and Vukotic (2016), "The price of capital and the financial accelerator", and uses `.agents/skills/dynare-copilot/references/examples/NK_PSV16_rep.mod` only as `implementation_cross_check`. Runtime validation was not performed.

## 1. Model Overview

- **Model**: `NK_PSV16`, Pancrazi, Roberto; Seoane, Hernan D.; Vukotic, Marija (2016), "The price of capital and the financial accelerator", *Economics Letters* 149, 86-89, DOI `10.1016/j.econlet.2016.10.022`.
- **Source files**: `raw/mmb_mineru/runs/nk_psv16__the_price_of_capital_and_the_financial_accelerator__a468e7e7/full.md`; raw PDF `raw/mmb_papers/The price of capital and the financial accelerator.pdf`; MinerU run id `a468e7e7-073f-4a72-a489-1ee9eba05671`.
- **Purpose**: BGG financial-accelerator model augmented with the equilibrium price of previously installed capital. The paper shows that replacing the equilibrium old-capital price by the net-of-depreciation new-capital price creates first-order effects when depreciation is positive.
- **Agents**: households, fiscal and monetary authority, entrepreneurs, retailers, and capital-producing firms. The paper states the first four blocks follow the standard BGG framework and formally derives the capital-producing firm block because it drives the result.
- **Form**: linearized New Keynesian financial-accelerator system. Most baseline equations below are cross-checked against `NK_PSV16_rep.mod`; equations (F5), (F11), (F12), and (F15) are paper-stated capital-price conditions. The sign in paper equation (9), represented by (F15), is marked `needs_review` because the OCR/paper expression and implementation cross-check differ.

## 2. Optimization Problems

### 2.1 Households

The paper describes infinitely lived, risk-averse households that choose consumption, hours, money balances, and deposits while taking prices as given. Their exact objective and budget constraint are omitted from the paper because they do not affect the capital-price result. The linearized household Euler equation used below is therefore classified as `implementation_cross_check`.

### 2.2 Entrepreneurs

Entrepreneurs are risk-neutral, own production technology, survive with constant probability, buy capital from capital-producing firms, hire labor, and finance capital with net worth plus borrowing. The lender-borrower relationship has costly-state-verification financial frictions. The paper states aggregate capital demand as:

$$
E_t R^k_{t+1}
= E_t\left\{\frac{MPK_{t+1}+\tilde Q_{t+1}}{Q_t}\right\}.
$$

The external-finance schedule is:

$$
E_t R^k_{t+1}
= s\left(\frac{N_{t+1}}{Q_tK_{t+1}}\right)R_{t+1}.
$$

### 2.3 Retailers and policy authority

Retailers are monopolistically competitive and set prices subject to Calvo nominal rigidity. The government budget uses lump-sum taxes and money creation, and monetary policy follows a Taylor-type nominal interest rate rule. The exact Calvo and policy equations are not derived in the paper; the equations below use the paper description plus `implementation_cross_check`.

### 2.4 Capital-producing firms

Capital-producing firms purchase investment goods $I_t$ and used capital $K_t$, transform them into next-period capital, and sell new capital at price $Q_t$. They purchase previously installed capital at price $\tilde Q_t$. The production technology is:

$$
K_{t+1}=\Phi\left(\frac{I_t}{K_t}\right)K_t+(1-\delta)K_t.
$$

The representative firm solves:

$$
\max_{\{K_t,I_t\}}\; Q_tK_{t+1}-I_t-\tilde Q_tK_t
\quad\text{s.t.}\quad
K_{t+1}=\Phi\left(\frac{I_t}{K_t}\right)K_t+(1-\delta)K_t.
$$

## 3. First-Order Conditions

- **(F1) Consumption Euler equation** (`implementation_cross_check`):

$$
c_t=E_t c_{t+1}-r_t.
$$

- **(F2) Fisher relation** (`implementation_cross_check`):

$$
rn_t=r_t+E_t\pi_{t+1}.
$$

- **(F3) Entrepreneurial consumption and net worth** (`implementation_cross_check`):

$$
ce_t=n_t.
$$

- **(F4) External-finance premium / capital supply** (`implementation_cross_check`):

$$
E_t rk_{t+1}-r_t=-\nu\big(n_t-q_t-k_t\big).
$$

- **(F5) Return on capital with equilibrium old-capital price** (`source_stated`, paper eq. 8; index timing follows the source equation):

$$
E_t r^k_{t+1}
=(1-\epsilon)(y_{t+1}-k_{t+1}-x_{t+1})+\epsilon\tilde q_{t+1}-q_t.
$$

- **(F6) Price of newly installed capital** (`implementation_cross_check`):

$$
q_t=\psi(i_t-k_{t-1}).
$$

- **(F7) Production function** (`implementation_cross_check`):

$$
y_t=a_t+\alpha k_{t-1}+(1-\alpha)\omega h_t.
$$

- **(F8) Labor-demand / household intratemporal condition** (`implementation_cross_check`):

$$
y_t-h_t-x_t-c_t=\eta^{-1}h_t.
$$

- **(F9) New Keynesian Phillips curve** (`implementation_cross_check`):

$$
\pi_t=\kappa(-x_t)+\beta E_t\pi_{t+1}.
$$

- **(F10) Net worth accumulation** (`implementation_cross_check`):

$$
n_t=\gamma R K_N(rk_t-r_{t-1})+r_{t-1}+n_{t-1}.
$$

- **(F11) FOC for the price of newly installed capital** (`source_stated`, paper eq. 5):

$$
Q_t=\left[\Phi'\left(\frac{I_t}{K_t}\right)\right]^{-1}.
$$

- **(F12) FOC for the equilibrium price of previously installed capital** (`source_stated`, paper eq. 6):

$$
\tilde Q_t
=\left[
(1-\delta)
+\Phi\left(\frac{I_t}{K_t}\right)
-\Phi'\left(\frac{I_t}{K_t}\right)\frac{I_t}{K_t}
\right]Q_t.
$$

## 4. Market Clearing & Identities

- **(F13) Aggregate resource constraint** (`implementation_cross_check`):

$$
y_t=C_Yc_t+I_Yi_t+G_Yg_t+Ce_Yce_t.
$$

- **(F14) Capital accumulation** (`implementation_cross_check`):

$$
k_t=\delta i_t+(1-\delta)k_{t-1}.
$$

- **(F15) Linearized equilibrium old-capital price** (`source_stated with needs_review`; paper eq. 9):

$$
\tilde q_t
=-\frac{\delta\varphi}{1-\delta}i_t
-\frac{\delta\varphi}{1-\delta}k_t
+q_t.
$$

`needs_review`: the implementation cross-check has `qtilde = delta*psi/(1-delta)*i - delta*psi/(1-delta)*k(-1) + q`, which differs in the sign on investment and uses lagged capital. The source Markdown OCR also renders the definition of $\varphi$ noisily. This entry preserves the source equation and records the discrepancy.

## 5. Exogenous Processes

- **(F16) Monetary policy rule** (`implementation_cross_check`):

$$
rn_t=\rho rn_{t-1}+S\pi_{t-1}+e^M_t.
$$

- **(F17) Government spending process** (`implementation_cross_check`):

$$
g_t=\rho_Gg_{t-1}+e^G_t.
$$

- **(F18) Technology process** (`implementation_cross_check`):

$$
a_t=\rho_Aa_{t-1}+e^A_t.
$$

## 6. Steady-State Solution

The model is linearized around a deterministic BGG-style steady state. For the Dynare `model(linear)` implementation cross-check, steady states of the lowercase deviation variables are zero:

$$
\bar y=\bar c=\bar i=\bar g=\bar{ce}=\bar n=\bar{rk}=\bar r=\bar q=\bar k=\bar x=\bar a=\bar h=\bar\pi=\bar{rn}=\bar{\tilde q}=0.
$$

The calibration constants used by the implementation cross-check are:

$$
\beta=0.99,\quad R=\frac{1}{\beta},\quad \alpha=0.35,\quad
\delta=0.025,\quad \rho_A=0.999,\quad \rho_G=0.95,
$$

$$
C_Y=0.61,\quad I_Y=0.18,\quad G_Y=0.20,\quad Ce_Y=0.01,\quad
K_N=2.00,\quad Y_N=0.28,\quad X=1.10.
$$

The paper-specific steady-state statements are source-stated: at the steady state, $\Phi(I/K)=\delta$, $\Phi'(I/K)=1$, and $I/K=\delta$. Therefore:

$$
\bar Q=1,\qquad \bar{\tilde Q}=1-\delta.
$$

The paper defines:

$$
\epsilon
=\frac{1-\delta}{(1-\delta)+\alpha Y/(XK)}.
$$

The source Markdown renders the definition of $\varphi$ unclearly; the implementation uses the adjustment-cost parameter `psi` in the linearized `qtilde` equation. This mapping is marked `needs_review`.

## 7. Timing & Form Conventions

- **Form**: linearized model; implementation cross-check is a Dynare `model` block written directly in deviations.
- **Capital timing**: the implementation uses production with $k_{t-1}$ and capital accumulation determining $k_t$, so $k_t$ is the end-of-period stock used in production at $t+1$.
- **Old-capital price timing**: the source return equation uses $E_t\tilde q_{t+1}$ and current $q_t$. The implementation cross-check uses `rk = ... + eps*qtilde - q(-1)`, consistent with a return realized at date $t$ on capital chosen earlier.
- **Stock and net-worth timing**: net worth depends on lagged net worth and lagged safe return in the implementation cross-check.
- **Runtime validation**: not performed. The `.mod` file was read only as `implementation_cross_check`; Dynare was not run.

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII name | Meaning | Equation reference |
|---|---|---|---|
| Endogenous | `y`, $y_t$ | output | (F13), (F7) |
| Endogenous | `c`, $c_t$ | household consumption | (F1), (F13) |
| Endogenous | `i`, $i_t$ | investment | (F6), (F14), (F15) |
| Endogenous | `g`, $g_t$ | government spending | (F13), (F17) |
| Endogenous | `ce`, $ce_t$ | entrepreneurial consumption | (F3), (F13) |
| Endogenous | `n`, $n_t$ | entrepreneurial net worth | (F3), (F4), (F10) |
| Endogenous | `rk`, $rk_t$ | return on capital | (F4), (F5), (F10) |
| Endogenous | `r`, $r_t$ | real interest rate | (F1), (F2), (F4) |
| Endogenous | `q`, $q_t$ | price of newly installed capital | (F5), (F6), (F11), (F12), (F15) |
| Endogenous | `k`, $k_t$ | capital stock | (F4), (F5), (F7), (F14), (F15) |
| Endogenous | `x`, $x_t$ | gross markup / inverse marginal cost term | (F5), (F8), (F9) |
| Endogenous | `a`, $a_t$ | technology | (F7), (F18) |
| Endogenous | `h`, $h_t$ | hours worked | (F7), (F8) |
| Endogenous | `pi`, $\pi_t$ | inflation | (F2), (F9), (F16) |
| Endogenous | `rn`, $rn_t$ | nominal interest rate | (F2), (F16) |
| Endogenous | `qtilde`, $\tilde q_t$ | price of previously installed capital | (F5), (F12), (F15) |
| Exogenous | `eM` | monetary-policy innovation | (F16) |
| Exogenous | `eG` | government-spending innovation | (F17) |
| Exogenous | `eA` | technology innovation | (F18) |
| Parameter | `beta` | discount factor | (F1), (F9) |
| Parameter | `eta` | labor preference / Frisch-related parameter | (F8) |
| Parameter | `alpha` | capital share | (F7), (F18) |
| Parameter | `delta` | depreciation rate | (F12), (F14), (F15) |
| Parameter | `omega` | labor input scaling | (F7) |
| Parameter | `eps` / $\epsilon$ | weight in capital-return equation | (F5) |
| Parameter | `C_Y`, `I_Y`, `G_Y`, `Ce_Y` | expenditure shares | (F13) |
| Parameter | `Y_N`, `K_N`, `X` | steady-state ratios and markup | (F5), (F7), (F10) |
| Parameter | `rhoA`, `rhoG`, `rho`, `S` | AR and policy parameters | (F16)-(F18) |
| Parameter | `psi` / $\varphi$ | investment-adjustment-cost slope parameter | (F6), (F15) |
| Parameter | `gamma`, `nu` | survival and external-finance-premium parameters | (F4), (F10) |
| Parameter | `theta`, `kappa` | Calvo and Phillips-curve parameters | (F9) |

Status: `needs_review` because the archive entry relies on paper-side equations for the capital-price contribution but reconstructs most of the BGG baseline from the implementation cross-check, and because paper equation (9) conflicts with the `.mod` sign/timing for `qtilde`.
