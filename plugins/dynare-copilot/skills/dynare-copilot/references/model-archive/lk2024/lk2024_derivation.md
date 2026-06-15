# Lu & Kameda (2024, JJIE) — Two-Sector Search-Friction Fiscal DSGE
## Derivation / replication notes (calibrate-and-simulate, no estimation)

Paper: *Impact of fiscal policies on the labor market with search friction: An estimated
DSGE model for Japan*, JJIE 72 (2024) 101315.

Goal: reproduce the model, plug in the paper's reported posterior means (Tables 2–4) as
**fixed** parameters, solve the steady state, run `stoch_simul`, and produce the IRFs of
Figs. 5–7 (government consumption, public vacancy, public wage markup).

---

## §1 Model overview

Medium-scale New-Keynesian model with:
- **Two-sector search-and-matching labor market** (private `p`, government `g`), à la
  Gomes (2015) / Esteban-Pretel et al. (2022).
- **Staggered Nash wage bargaining** (Hall 2005 partial adjustment of the wage).
- **Endogenous intensive margin** (hours `h^p`, `h^g`).
- **Heterogeneous consumption** employed vs unemployed → consumption-employment
  complementarity (Shimer 2010, Monacelli et al. 2010): marginal utility rises with `n`.
- **Productive public employment**: public services `GS=n^g h^g` and public capital `GK`
  enter private production as positive externalities (NOT in utility — divergence from
  Esteban-Pretel et al.).
- **Calvo wholesalers** (price stickiness), competitive intermediate firms + final-good CES.
- **Rich fiscal block**: GC, GI, lump-sum T, distortionary τ^c, τ^w, τ^r, public vacancies
  v^g, public wage markup Π^g, unemployment benefit z, debt B; fiscal rules with output &
  debt feedback; Taylor rule.

Population normalized to 1: `n = n^p + n^g`, `u = 1 - n`.

15 structural shocks (matches Table 4): A^m, χ^p, ν, A^f, η (eq.39); v^g (28); Π^g (29);
z (32); GC, GI, T, τ^c, τ^w, τ^r (fiscal rule 33); i (Taylor 34).

---

## §2 Timing conventions (R2)

- **Stocks are end-of-period (decision-time) values.** `n^p`, `n^g`, `K`, `GK`, `w^p`,
  `B`, `I` are predetermined → enter next period with `(-1)`.
- **Employment laws (paper eq. 4,5)** use *lagged* finding/separation: new hires formed in
  `t-1` become productive in `t`:
  `n^p_t = (1-χ^p_{t-1}) n^p_{t-1} + f^p_{t-1} u_{t-1}`.
  Because `n_t` depends only on `t-1` objects, **`n_t` and `u_t=1-n_t` are predetermined**;
  vacancies `v_t` (hence θ_t, μ_t, m_t, f_t) are the jump objects in the matching block.
- Matching `m_t = A^m_t u_t^κ v_t^{1-κ}` uses contemporaneous (predetermined) `u_t` and
  jump `v_t`. `θ_t=v_t/u_t`, `μ_t=m_t/v_t`, `f^i_t=(m_t/u_t)(v^i_t/v_t)`.
- Wage `w^p_t = ω^w w^p_{t-1} + (1-ω^w) w^{p*}_t` → `w^p` predetermined component.

---

## §3 Paper typos / ambiguities resolved (IMPORTANT — please verify)

1. **Bond timing in budgets.** HH budget eq.(6) prints `i_t B_{t-1}/π_t`, but the bond
   Euler eq.(11) `λ_t = β E_t λ_{t+1} i_t/π_{t+1}` makes `i_t` the gross return on bonds
   *bought at t*. Hence the period-t interest payment must be `i_{t-1} B_{t-1}/π_t`
   (consistent with govt budget eq.30). **We use `i_{t-1} B_{t-1}/π_t`.**
2. **Taylor rule (34)** prints `ρ_i ln(i_t/i)` on the RHS — typo for `ρ_i ln(i_{t-1}/i)`.
   **We use the lag.**
3. **Cross-references in §5.3:** text attaches the public-vacancy shock to "Eq.(31)" and the
   markup shock to "Eq.(30)"; those are GK accumulation / govt budget. The actual exogenous
   processes are **(28) for v^g and (29) for Π^g**.
4. **Markup shock η_t.** Implemented as a time-varying wedge in the reset-price markup
   `η_t/(η_t-1)`; the Calvo index/dispersion exponents are kept at steady-state `η`. To
   first order this is the standard price-markup (cost-push) shock and matches the paper's
   labeling. (Avoids ill-defined time-varying CES exponents under perturbation.)
5. **Redundant unemployment law (3).** `u_t=(1-f^p-f^g)_{t-1}u_{t-1}+χ^p_{t-1}n^p_{t-1}+χ^g
   n^g_{t-1}` is implied by (4)+(5)+`u=1-n` (Walras for the labor flows). **Dropped from the
   model block** (would otherwise make the system singular → BK failure).
6. **Household budget (6) dropped** (Walras): we keep resource constraint (37) + govt budget
   (30); the HH budget is the redundant one.
7. **Public hours `h^g`** are determined each period by the equal-value condition
   `O^p_t=O^g_t` together with `w^g_t=(1+Π^g_t)w^p_t` (paper §3.3 / §5.3). There is no
   separate public marginal-product FOC (public services are linear `GS=n^g h^g`).
8. **Matching-efficiency mean `A^m`** is not in Table 2. We add one innocuous normalization:
   steady-state vacancy-filling probability `μ=0.70` (quarterly), and back out `A^m`.
9. **Public-vacancy mean `v^g`** is not in Table 2 either; calibrated so the steady-state
   **government wage bill `w^g n^g h^g / Y = 4.44%`** (the GDP share quoted in the paper).
10. **Unemployment benefit `z = 0.26 · w^p · h^p`** (26% of *earnings*) — NOT `0.26·w^p`
    (26% of the hourly *rate*). The latter implies a ~68% replacement of earnings (since
    `h^p≈0.68`), which pushes the worker's reservation wage above the marginal product and
    leaves **negative match surplus → no search equilibrium at any scale**. With the
    earnings-based reading the firm's flow profit is positive (`J>0`, `l^p>0`).
11. **Hours `h^p, h^g` are ENDOGENOUS** (from the intensive margin W1 and equal-value W2),
    not pinned to the paper's 0.381. With `σ^p=0.480, σ^g=0.461` (paper) the model delivers
    `h^p≈0.68, h^g≈0.43`. Forcing 0.381 is incompatible with positive firm surplus (see #10).
    `σ^p, σ^g` are therefore kept at the paper values rather than recalibrated.
12. **Known limitation:** with `h^g` set by worker indifference `O^p=O^g`, a public-wage-markup
    shock generates a wealth (income) effect `w^g↑→h^g↓`, so the model's public-wage-markup IRF
    has output falling, opposite to the paper's productivity story (`h^g↑→GS↑→output↑`). The
    paper's narrative is reproduced if `h^g` instead obeys a public intensive margin
    `σ^g/((1-τ^w)(1-h^g)λ)=w^g`, but that specification destabilises the (headline) public-vacancy
    response, so we keep equal-value. The **public-vacancy result — the paper's main finding —
    is reproduced correctly** (unemployment falls, output/C/I rise, tightness rises, inflation
    falls); the public-wage-markup channel (which the paper itself calls "minor") is not.

---

## §4 Equilibrium conditions (model block)

Investment adjustment cost: `S(x)=(d/2)(x-1)^2`, `S'(x)=d(x-1)`, `x=I/I_{-1}`;
`S(1)=S'(1)=0`, `S''(1)=d`.

**Goods / capital / pricing**
- (G1) Production (per firm): `y = A^f k^α (h^p)^{1-α} (GK^{hk} GS^{hs})`.
- (G2) Capital FOC: `r = α p_m y / k`.
- (G3) Output aggregation: `Y = n^p y / d^p`.
- (G4) Capital market: `K = n^p k`.
- (G5) Resource constraint: `Y = C + I + GC + GI + l^p v^p + l^g v^g`.
- (G6) Capital law: `K = (1-δ)K_{-1} + (1 - (d/2)(I/I_{-1}-1)^2) I`.
- (G7) MU of consumption: `U^c_t = (1+τ^c_t) λ_t`,
  `U^c_t = C_t^{-ζ}(1+γ ν_t (ζ-1) n_t)^ζ`.
- (G8) Investment FOC:
  `λ = ψ[1 - (d/2)(I/I_{-1}-1)^2 - d(I/I_{-1}-1)(I/I_{-1})] + β E[ψ' d(I'/I-1)(I'/I)^2]`.
- (G9) Capital Euler: `ψ = β E[(1-τ^r_{+1})λ' r' + (1-δ)ψ']`.
- (G10) Bond Euler: `λ = β E[λ' i_t/π_{+1}]`.
- (G11) Calvo numerator: `KF = λ p_m Y + ω^p β E[π_{+1}^{η} KF']`.
- (G12) Calvo denominator: `KZ = λ Y + ω^p β E[π_{+1}^{η-1} KZ']`.
- (G13) Reset price: `π^* = (η_t/(η_t-1)) (KF/KZ) π`  (η_t = markup-shock variable).
- (G14) Price index: `1 = ω^p π^{η-1} + (1-ω^p) (π^*)^{1-η}`.  (η at SS value)
- (G15) Dispersion: `d^p = ω^p π^{η} d^p_{-1} + (1-ω^p)(π^*)^{-η}`.

**Labor market**
- (L1) `n^p = (1-χ^p_{-1}) n^p_{-1} + f^p_{-1} u_{-1}`.
- (L2) `n^g = (1-χ^g) n^g_{-1} + f^g_{-1} u_{-1}`.
- (L3) `n = n^p + n^g`.   (L4) `u = 1 - n`.   (L5) `v = v^p + v^g`.
- (L6) `θ = v/u`.   (L7) `m = A^m u^κ v^{1-κ}`.   (L8) `μ = m/v`.
- (L9) `f^p = (m/u)(v^p/v)`.   (L10) `f^g = (m/u)(v^g/v)`.
- (L11) Job-creation (free entry, V=0): `l^p = β E[(λ'/λ) μ_t J_{+1}]`.

**Hours / wages**
- (W1) Intensive margin (private):
  `σ^p / [(1-τ^w)(1-h^p) λ] = (1-α) p_m y / h^p`.
- (W2) Equal value: `O^p = O^g`  (determines `h^g`).
- (W3) Wage adjustment: `w^p = ω^w w^p_{-1} + (1-ω^w) w^{p*}`.
- (W4) Target wage:
  `w^{p*} h^p = ϕ w̄ + (1-ϕ) ŵ + (1-χ^p-f^p) β E[(λ'/λ)(w^{p*}_{+1}-w^p_{+1}) h^p_{+1}]`.
- (W5) Public wage: `w^g = (1+Π^g) w^p`.
- (W6) Firm reservation: `w̄ = (1-α) p_m y + l^p f^p / μ`.
- (W7) Worker reservation:
  `ŵ = (1/(1-τ^w))[ z - σ^p ln(1-h^p)/λ + β f^g E[(λ'/λ)(O^g_{+1}-N_{+1})] ]`.

**Value functions**
- (V1) `O^p = (1-τ^w)w^p h^p + σ^p ln(1-h^p)/λ + β E[(λ'/λ)((1-χ^p)O^p_{+1}+χ^p N_{+1})]`.
- (V2) `O^g = (1-τ^w)w^g h^g + σ^g ln(1-h^g)/λ + β E[(λ'/λ)((1-χ^g)O^g_{+1}+χ^g N_{+1})]`.
- (V3) `N = z + β E[(λ'/λ)(f^p O^p_{+1}+f^g O^g_{+1}+(1-f^p-f^g)N_{+1})]`.
- (V4) `J = (p_m y - r k - w^p h^p) + β E[(λ'/λ)(1-χ^p) J_{+1}]`.

**Fiscal**
- (F1) `GS = n^g h^g`.
- (F2) `GK = (1-δ)GK_{-1} + GI`.
- (F3) Govt budget → `B`:
  `B + τ^c C + τ^w(w^p n^p h^p + w^g n^g h^g) + τ^r r_{-1} K_{-1}
   = (i_{-1}/π) B_{-1} + GC + GI + w^g n^g h^g + l^g v^g + z u - T`.

**Exogenous processes** (15)
- (39) AR in logs for `A^m, χ^p, ν, A^f, η` (means: A^m calibrated, χ^p=0.012, ν=1,
  A^f=1, η=11).
- (28) `log v^g`, (29) `log Π^g` (mean 0.127), (32) `log z` (mean z_ss=0.26 w^p).
- (33) fiscal rules for `GC, GI, T, τ^c, τ^w, τ^r`:
  `log(x/x̄)=ρ_x log(x_{-1}/x̄)+(1-ρ_x)[ϕ^x_y log(Y_{-1}/Ȳ)+ϕ^x_b log(B_{-1}/B̄)]+ε^x`.
- (34) Taylor: `log(i/ī)=ρ_i log(i_{-1}/ī)+(1-ρ_i)[ϕ_π log(π/π̄)+ϕ_y log(Y/Ȳ)]+ε^i`.

**Count:** 15 (goods/price) + 11 (labor) + 7 (hours/wages) + 4 (values) + 3 (fiscal) = 40
core + 15 processes = **55 equations / 55 endogenous vars**; 15 varexo. ✓ R4.

---

## §5 Exogenous processes — see §4. (All means at steady-state values; ν=A^f=1, η=11.)

---

## §6 Steady state (analytic + tiny fsolve)

Set ν=A^f=1, η=11, π=1, all shocks at mean. Then:
- `i = 1/β`, `p_m = (η-1)/η = 10/11`, `ψ = λ` (inv. FOC at S=S'=0),
  `r = (1/β - 1 + δ)/(1-τ^r)`.
- Calibration: **fix** `σ^p=0.480, σ^g=0.461` (paper), `μ=0.70` (matching normalization).
  **Targets:** `u=0.034`, govt wage bill `=4.44%`. **Reverse-calibrate** `l^p, l^g, A^m, v^g`.
  Hours `h^p, h^g` and everything else are **endogenous outputs**.

**6-variable `fsolve` over `x=[n^p, n^g, h^p, h^g, w^p, λ]`** with residuals (`σ^p,σ^g,μ` fixed,
`l^p=βμJ` derived, so free entry holds by construction):
1. `u` target: `n^p+n^g − 0.966 = 0`;
2. govt wage bill: `(1+Π^g)w^p n^g h^g / Y − 0.0444 = 0`;
3. private intensive margin (W1): `σ^p/((1-τ^w)(1-h^p)λ) − (1-α)p_m y/h^p = 0`;
4. equal value (W2): `O^g − O^p = 0`;
5. bargaining (W4 at SS): `w^p h^p − [ϕ w̄ + (1-ϕ) ŵ] = 0`;
6. MU consistency: `λ − U^c/(1+τ^c) = 0`.

Inside an evaluation: labor block from `{n^p,n^g,θ=f/μ,...}` with `f^i=χ^i n^i/u`, `v^i=f^i u/μ`,
`A^m=μθ^κ`; per-firm `y` solved from `y=[(αp_m/r)^α (h^p)^{1-α}(GK/Y·n^p)^{hk}(n^g h^g)^{hs}]^{1/(1-α-hk)}`
(`GK/Y=0.072/0.025`); aggregates `Y=n^p y, K=n^p k, I=δK, GC=0.178Y, GI=0.072Y, B=1.60Y`;
`z=0.26 w^p h^p`; `w^g=(1+Π^g)w^p`; flow profit `(1-α)p_m y−w^p h^p`, `J=·/(1−β(1−χ^p))`,
**`l^p=βμJ`**, `l^g=0.15 l^p`; values `O^p=O^g=O`, `N` in closed form; `w̄, ŵ` as in W6/W7.

After fsolve: `w^{p*}=w^p`, `ψ=λ`, `inflstar=1`, `d^p=1`, `KF=λ p_m Y/(1−ω^p β)`,
`KZ=λ Y/(1−ω^p β)`, `i=1/β`; `T` from (F3) residually.

Parameters updated in the steady-state file: `l^p, l^g, A^m, v^g_ss, z_ss, GC_ss, GI_ss,
B_ss, Y_ss, T_ss` (`σ^p, σ^g` stay at paper values).

**Result (verified):** `u=3.40%`, wage bill `=4.44%`, public-employment share `n^g/n=9.6%`,
`l^p=0.132, l^g=0.020, A^m=0.471, θ=0.456`, job-finding `f≈32%/qtr`, `C/Y=0.61, K/Y=5.36`
(quarterly), `h^p=0.68, h^g=0.43`. Firm flow profit `>0` so `J=0.19>0`. All static residuals 0;
BK satisfied (15 explosive roots for 15 forward-looking vars).

---

## §7 Timing summary (predetermined / jump)

Predetermined (enter `(-1)`): `n^p, n^g` (hence n,u), `K, GK, B, I, w^p, d^p`, and all AR
process variables. Jump: `v, v^p, θ, μ, m, f^p, f^g, h^p, h^g, w^{p*}, w^g, w̄, ŵ, y, k, r,
p_m, π, π^*, KF, KZ, λ, ψ, C, Y, O^p, O^g, N, J, GS, GC, GI, T, τ's, i_nom`. (GC, GI, T,
τ's, i_nom follow rules but condition on lagged Y, B, own lag → contain `(-1)`.)

---

## §8 Variable ↔ equation map (R4 pre-check)

| var | eq | var | eq |
|---|---|---|---|
| y | G1 | r | G2 |
| Y | G3 | K | G4 |
| C | G5 | invest | G6 |
| lam | G7 | psi | G8 (capEuler G9 pairs) |
| p_m | G11–G15 block | pi | G14 |
| inflstar | G13 | KF | G11 |
| KZ | G12 | dp | G15 |
| (bond Euler G10 closes nominal block) | | | |
| np | L1 | ng | L2 |
| n | L3 | u | L4 |
| v | L5 | theta | L6 |
| mm | L7 | mu | L8 |
| fp | L9 | fg | L10 |
| vp | L11 (job creation, via v) | | |
| hp | W1 | hg | W2 |
| wp | W3 | wstar | W4 |
| wg | W5 | wbar | W6 |
| wund | W7 | | |
| Op | V1 | Og | V2 |
| Nv | V3 | J | V4 |
| GS | F1 | GK | F2 |
| B | F3 | | |
| Am,chip,nu,Af,eta | 39 | vg | 28 |
| Pig | 29 | z | 32 |
| GC,GI,T,tauc,tauw,taur | 33 | i_nom | 34 |

All 55 vars have a determining equation. ✓
