// ============================================================
// govt_rbc_irf_matching.mod
// Public capital RBC: IRF-matching estimation of alphag
//
// Model: trend RBC with government investment -> public capital externality
//        (Aschauer 1989); log AR(1) process for government investment.
// Estimation: method_of_moments(mom_method=irf_matching, Dynare 7.1)
//   Empirical targets: 3-var Choleski VAR [gov, y, inv], 1960Q1-2019Q4
//   Estimated: alphag (public capital elasticity), rho_ig (persistence)
// ============================================================

// ---------- Variables (17 = 16 memory + log_invest) --------
var y          ${y}$          (long_name='output, detrended')
    c          ${c}$          (long_name='consumption, detrended')
    k          ${k}$          (long_name='private capital, detrended')
    n          ${n}$          (long_name='labor hours')
    invest     ${\imath}$     (long_name='private investment, detrended')
    ig         ${i_g}$        (long_name='government investment, detrended')
    kg         ${k_g}$        (long_name='public capital, detrended')
    z          ${z}$          (long_name='TFP, log level')
    w          ${w}$          (long_name='real wage, detrended')
    rk         ${r^k}$        (long_name='rental rate of private capital')
    log_y      (long_name='log output')
    log_c      (long_name='log consumption')
    log_k      (long_name='log private capital')
    log_kg     (long_name='log public capital')
    log_ig     (long_name='log government investment')
    log_n      (long_name='log labor')
    log_invest (long_name='log private investment');

// ---------- Shocks (only innovations, R3) -----------------
varexo eps_z  ${\varepsilon_z}$ (long_name='TFP innovation')
       eps_ig ${\varepsilon_g}$ (long_name='government investment innovation');

// ---------- Parameters ------------------------------------
parameters betta    ${\beta}$    (long_name='discount factor')
           gam      ${\gamma}$   (long_name='quarterly trend growth')
           delta    ${\delta}$   (long_name='private capital depreciation')
           deltag   ${\delta_g}$ (long_name='public capital depreciation')
           alppha   ${\alpha}$   (long_name='private capital income share')
           alphag   ${\alpha_g}$ (long_name='public capital elasticity [estimated]')
           phhi     ${\varphi}$  (long_name='inverse Frisch elasticity')
           psi      ${\psi}$     (long_name='labor disutility [back-solved]')
           rhoz     ${\rho_z}$   (long_name='TFP persistence')
           rho_ig   ${\rho_g}$   (long_name='gov investment persistence [estimated]')
           gy       ${g_y}$      (long_name='gov investment / output, steady state')
           ig_ss    ${i_{g,ss}}$ (long_name='gov investment level, steady state [back-solved]');

// ---------- Calibration (starting values) -----------------
betta  = 0.99;
gam    = 0.005;
delta  = 0.025;
deltag = 0.05;
alppha = 0.33;
alphag = 0.10;    // initial value; estimated below
phhi   = 1.0;
rhoz   = 0.95;
rho_ig = 0.80;    // initial value; estimated below
gy     = 0.05;

// ---------- Model (17 equations, 17 variables, R4) --------
model;

// --- Production and factor prices ---
// (1) Cobb-Douglas: public capital as externality (Aschauer 1989)
[name='production function']
y = exp(z) * kg(-1)^alphag * k(-1)^alppha * n^(1-alppha-alphag);

// (2) Firm FOC for labor (competitive factor market)
[name='labor demand FOC']
w = (1-alppha-alphag) * y / n;

// (3) Firm FOC for private capital
[name='capital rental rate FOC']
rk = alppha * y / k(-1);

// --- Household optimization ---
// (4) Euler equation (detrended: effective discount = betta/(1+gam))
[name='Euler equation']
c^(-1) = (betta/(1+gam)) * c(+1)^(-1) * (rk(+1) + 1 - delta);

// (5) Labor supply (log utility in consumption, power disutility in labor)
[name='labor supply FOC']
psi * n^phhi * c = w;

// --- Capital accumulation ---
// (6) Private capital (R2: k is end-of-period stock)
[name='private capital law of motion']
(1+gam) * k = (1-delta) * k(-1) + invest;

// (7) Public capital (R2: kg is end-of-period stock)
[name='public capital law of motion']
(1+gam) * kg = (1-deltag) * kg(-1) + ig;

// --- Market clearing ---
// (8) Goods market (household budget constraint is Walras-redundant)
[name='resource constraint']
y = c + invest + ig;

// --- Exogenous processes (R3: only innovations in varexo) ---
// (9) TFP: log level AR(1)
[name='TFP process']
z = rhoz * z(-1) + eps_z;

// (10) Government investment: log-level AR(1); ig_ss is the steady-state level
[name='government investment process']
log(ig) = (1-rho_ig)*log(ig_ss) + rho_ig*log(ig(-1)) + eps_ig;

// --- Log auxiliary variables (for IRF matching targets) ---
[name='log output']
log_y = log(y);
[name='log consumption']
log_c = log(c);
[name='log private capital']
log_k = log(k);
[name='log public capital']
log_kg = log(kg);
[name='log government investment']
log_ig = log(ig);
[name='log labor']
log_n = log(n);
[name='log private investment']
log_invest = log(invest);

end;

// ---------- Analytic steady state -------------------------
// Order: rk -> ratios -> level y -> levels -> psi (back-solved), ig_ss (back-solved)
steady_state_model;
    z     = 0;
    rk    = (1+gam)/betta - (1-delta);      // from Euler equation
    ky    = alppha / rk;                     // k/y ratio
    kgy   = gy / (gam + deltag);             // kg/y ratio
    n_ss  = 1/3;
    // y^(1-alpha-alphag) = (kgy^alphag * ky^alppha) * n^(1-alpha-alphag)
    y     = (kgy^alphag * ky^alppha)^(1/(1-alppha-alphag)) * n_ss;
    k     = ky * y;
    kg    = kgy * y;
    invest = (gam + delta) * k;
    ig_ss  = gy * y;                         // back-solve ig_ss to hit gy target
    ig     = ig_ss;
    c      = y - invest - ig;
    w      = (1-alppha-alphag) * y / n_ss;
    psi    = w / (n_ss^phhi * c);            // back-solve psi to hit n=1/3
    n      = n_ss;
    rk_chk = alppha * y / k;
    log_y      = log(y);
    log_c      = log(c);
    log_k      = log(k);
    log_kg     = log(kg);
    log_ig     = log(ig);
    log_n      = log(n);
    log_invest = log(invest);
end;

// ---------- Shocks (unit variance: IRF normalized to 1% gov impact) --
shocks;
    var eps_ig = 1;       // unit shock; model log_ig IRF(h=1) = 1
    var eps_z  = 0.0001;  // TFP (calibrated; not matched)
end;

resid;
steady;
check;

// ---------- Observables (must include all matched_irfs variables) ----
varobs log_ig log_invest;

// ---------- Parameters to estimate ---------------------------------
// alphag upper bound = 0.15: consistent with labor share 2/3 (1-alppha-alphag >= 0.52)
// rho_ig upper bound = 0.995: allows near-persistent gov investment (empirical data shows ~0.88)
estimated_params;
    alphag, 0.08, 0.01, 0.15;   // public capital elasticity
    rho_ig, 0.88, 0.50, 0.995;  // gov investment persistence (start at empirical h=2 decay rate)
end;

// ---------- Compute empirical IRFs from VAR (runs once here) -------
run('compute_empirical_IRFs.m');

// ---------- IRF matching targets -----------------------------------
// log_ig   h=2:4  -- identifies rho_ig from early AR(1)-like decay (before plateau)
// log_invest h=3:20 -- identifies alphag: skip h=1-2 (crowding-out impact), focus long-run complementarity
matched_irfs;
    var log_ig;     varexo eps_ig; periods 2:4;  values (irfs_gov_vals_2to4); weights (irfs_gov_wgts_2to4);
    var log_invest; varexo eps_ig; periods 3:20; values (irfs_inv_vals_3end); weights (irfs_inv_wgts_3end);
end;

// ---------- IRF matching estimation --------------------------------
method_of_moments(
    mom_method                = irf_matching,
    order                     = 1,
    mode_compute              = 5,
    additional_optimizer_steps = [4]
);
