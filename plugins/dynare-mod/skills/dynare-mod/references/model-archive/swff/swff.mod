// ==========================================================================
// Del Negro, Giannoni & Schorfheide (2015, AEJ:Macro)
// "Inflation in the Great Recession and New Keynesian Models" -- SWFF model
// Smets-Wouters (2007) + time-varying inflation target + BGG/CMR financial frictions.
//
// Log-linearized system, transcribed from the canonical FRBNY implementation
// (DSGE.jl model m990: eqcond.jl + financial_frictions.jl).  model(linear).
// Parameters: SWFF posterior mode (Table A-2).  Coefficients are computed in
// run_swff.m and injected via the base-workspace struct `pp`.
//
// Two economies: sticky (actual, with FF) and flexible (superscript _f, no FF),
// the latter only to supply the output gap (y - y_f) for the policy rule.
// ==========================================================================

// ---------------- endogenous variables ----------------
var
// sticky economy (16)
    c            // consumption
    invest       // investment
    qk           // value of capital (Tobin's Q)
    Rtil_k       // gross nominal return on capital for entrepreneurs
    n            // entrepreneurial net worth
    y            // output
    k            // effective (utilized) capital
    u            // capital utilization
    kbar         // installed capital (end of period)
    mc           // real marginal cost
    pinf         // inflation
    rk           // rental rate of capital
    muw          // wage markup (w - MRS)
    w            // real wage
    R            // nominal interest rate
    L            // hours
// flexible economy (11)
    c_f invest_f qk_f rk_f k_f u_f kbar_f w_f L_f y_f r_f
// exogenous processes (12)
    ztil         // detrended log productivity (AR1 level)
    z            // productivity growth rate (deviation)
    b            // preference / risk-premium shock process
    mu           // marginal efficiency of investment process
    g            // government spending process
    lamf         // price markup process (ARMA part)
    lamf1        // price markup MA auxiliary
    lamw         // wage markup process (ARMA part)
    lamw1        // wage markup MA auxiliary
    rm           // monetary policy shock process
    sigw         // financial risk (cross-sectional dispersion) shock process
    pistar       // time-varying inflation target
    spread       // external finance premium (observable), = E_t[Rtil_k(+1)] - R
;

// ---------------- innovations (9) ----------------
varexo eps_z eps_b eps_mu eps_g eps_lamf eps_lamw eps_rm eps_sigw eps_pistar;

// ---------------- parameters ----------------
parameters
    alppha Phi nu_l rho psi1 psi2 psi3
    rho_g rho_b rho_mu rho_z rho_lamf rho_lamw rho_rm rho_sigw rho_pistar
    eta_gz eta_lamf eta_lamw zeta_spb
    e_r e_c1 e_cf e_l inv_lag inv_f inv_q cv_rk cv_qk
    ce_i ce_mu kappa ph_lag ph_f wg_mu wg_pi wg_wlag wg_pilag wg_f
    ms_c ms_clag cs res_c res_i res_u gstar bcoef
    zeta_spsigw zeta_nRk zeta_nR zeta_nqk zeta_nn zeta_nsigw gstar_v_n
    sig_g sig_b sig_mu sig_z sig_lamf sig_lamw sig_rm sig_sigw sig_pistar
;

// numeric values computed in run_swff.m (SWFF posterior mode + derived/FF coeffs)
@#include "swff_params.inc"

// ======================= model =======================
model(linear);

// ---- sticky economy ----
[name='Consumption Euler equation']
c = -e_r*R + b + e_r*pinf(+1) + e_c1*(c(-1) - z) + e_cf*(c(+1) + z(+1)) + e_l*(L - L(+1));

[name='Investment Euler (Tobin Q)']
invest = inv_lag*(invest(-1) - z) + inv_f*(invest(+1) + z(+1)) + inv_q*qk + mu;

[name='Return to capital definition']
Rtil_k - pinf = cv_rk*rk + cv_qk*qk - qk(-1);

[name='Spread equation (external finance premium)']
Rtil_k(+1) - R = -bcoef*b + zeta_spb*(qk + kbar - n) + sigw;

[name='Net worth evolution']
n = zeta_nRk*(Rtil_k - pinf) - zeta_nR*(R(-1) - pinf) + zeta_nqk*(qk(-1) + kbar(-1))
    + zeta_nn*n(-1) - (zeta_nsigw/zeta_spsigw)*sigw(-1) - gstar_v_n*z
    + zeta_nR*bcoef*b(-1);

[name='Production function']
y = Phi*(alppha*k + (1-alppha)*L);

[name='Effective capital']
k = u - z + kbar(-1);

[name='Capital utilization FOC']
u = cs*rk;

[name='Capital accumulation']
kbar = (1-ce_i)*(kbar(-1) - z) + ce_i*invest + ce_mu*mu;

[name='Marginal cost']
mc = w + alppha*L - alppha*k;

[name='Price Phillips curve']
pinf = kappa*mc + ph_lag*pinf(-1) + ph_f*pinf(+1) + lamf;

[name='Factor price (capital-labor) relation']
rk + k - L - w = 0;

[name='Marginal rate of substitution / wage markup']
muw + nu_l*L + ms_c*c + ms_clag*z - w - ms_clag*c(-1) = 0;

[name='Wage Phillips curve']
w = -wg_mu*muw - wg_pi*pinf + wg_f*(w(+1) + z(+1) + pinf(+1))
    + wg_wlag*(w(-1) - z) + wg_pilag*pinf(-1) + lamw;

[name='Monetary policy rule']
R = rho*R(-1) + (1-rho)*( psi1*(pinf - pistar) + psi2*(y - y_f) )
    + psi3*( (y - y_f) - (y(-1) - y_f(-1)) ) + rm;

[name='Resource constraint']
y = gstar*g + res_c*c + res_i*invest + res_u*u;

// ---- flexible economy (no nominal rigidity, no FF) ----
[name='Euler (flex)']
c_f = -e_r*r_f + b + e_c1*(c_f(-1) - z) + e_cf*(c_f(+1) + z(+1)) + e_l*(L_f - L_f(+1));

[name='Investment Euler (flex)']
invest_f = inv_lag*(invest_f(-1) - z) + inv_f*(invest_f(+1) + z(+1)) + inv_q*qk_f + mu;

[name='Capital arbitrage (flex, no FF)']
qk_f = cv_rk*rk_f(+1) + cv_qk*qk_f(+1) - r_f + bcoef*b;

[name='Production (flex)']
y_f = Phi*(alppha*k_f + (1-alppha)*L_f);

[name='Effective capital (flex)']
k_f = u_f - z + kbar_f(-1);

[name='Capital utilization FOC (flex)']
u_f = cs*rk_f;

[name='Capital accumulation (flex)']
kbar_f = (1-ce_i)*(kbar_f(-1) - z) + ce_i*invest_f + ce_mu*mu;

[name='Marginal cost = 0 (flex)']
w_f = alppha*(k_f - L_f);

[name='Factor price relation (flex)']
rk_f + k_f - L_f - w_f = 0;

[name='MRS = wage (flex)']
w_f = ms_c*c_f - ms_clag*c_f(-1) + ms_clag*z + nu_l*L_f;

[name='Resource constraint (flex)']
y_f = gstar*g + res_c*c_f + res_i*invest_f + res_u*u_f;

// ---- exogenous processes ----
[name='Detrended productivity level (AR1)']
ztil = rho_z*ztil(-1) + eps_z;

[name='Productivity growth']
z = ((rho_z-1)/(1-alppha))*ztil(-1) + (1/(1-alppha))*eps_z;

[name='Preference / risk premium']
b = rho_b*b(-1) + eps_b;

[name='Marginal efficiency of investment']
mu = rho_mu*mu(-1) + eps_mu;

[name='Government spending']
g = rho_g*g(-1) + eps_g + eta_gz*eps_z;

[name='Price markup (ARMA 1,1)']
lamf = rho_lamf*lamf(-1) - eta_lamf*lamf1(-1) + eps_lamf;
[name='Price markup MA auxiliary']
lamf1 = eps_lamf;

[name='Wage markup (ARMA 1,1)']
lamw = rho_lamw*lamw(-1) - eta_lamw*lamw1(-1) + eps_lamw;
[name='Wage markup MA auxiliary']
lamw1 = eps_lamw;

[name='Monetary policy shock']
rm = rho_rm*rm(-1) + eps_rm;

[name='Financial risk shock (sigma_omega)']
sigw = rho_sigw*sigw(-1) + eps_sigw;

[name='Time-varying inflation target']
pistar = rho_pistar*pistar(-1) + eps_pistar;

[name='External finance premium (observable)']
spread = zeta_spb*(qk + kbar - n) + sigw - bcoef*b;

end;

// ======================= shocks =======================
shocks;
var eps_z      = sig_z^2;
var eps_b      = sig_b^2;
var eps_mu     = sig_mu^2;
var eps_g      = sig_g^2;
var eps_lamf   = sig_lamf^2;
var eps_lamw   = sig_lamw^2;
var eps_rm     = sig_rm^2;
var eps_sigw   = sig_sigw^2;
var eps_pistar = sig_pistar^2;
end;

// ======================= solve =======================
steady;
resid;
check;

stoch_simul(order=1, irf=20, nograph, periods=0) y pinf R spread Rtil_k n qk invest c w L mc;
