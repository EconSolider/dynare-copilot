/*
 * bj2021_demography.mod
 * --------------------------------------------------------------------------
 * Faithful Dynare replication of the UNAMBIGUOUS CORE of
 *   Basso & Jimeno (2021, JME) "From secular stagnation to robocalypse?".
 *
 * Mechanism captured (paper Section 2.1 + Appendix A.68 + Proposition 1):
 *   - exact demographic law of motion for the retiree/worker ratio tau_r,
 *     driven by the structural rates: birth psi_y, retiree survival psi_r,
 *     worker-retention omega;
 *   - the balanced-growth-path mapping from population growth g_n into
 *     output growth g, per-capita growth, robot-price growth g_q and the
 *     variety/automation growth g_Z=g_A (Proposition 1, chi<1):
 *         g = g_n^{1/(1-chi)},   g_q = g/g_n,   g_Z = g^eta.
 *
 * Experiment: an unanticipated PERMANENT change in the demographic rates
 * (1993 -> 2055 UN projections), as in the Solow_growth_rate_changes
 * pattern. The rates jump at t=0; the age structure tau_r adjusts
 * gradually, so g_n, per-capita growth and the automation incentive
 * transition smoothly toward the new BGP (cf. paper Fig. 1).
 *
 * SCOPE NOTE: the full ~40-equation structural model is NOT faithfully
 * recoverable from the (OCR'd) working paper - the interest rate (Gertler
 * Epstein-Zin MPC block) and the automation level a_z (sigma-technology
 * scaling) depend on constants the document does not pin. This file
 * therefore replicates the demographic + BGP-growth core exactly and
 * treats g as the quasi-BGP (sequence-of-BGPs) growth path. See README.
 *
 * Run for the US calibration; Europe via bj2021_demography_run.m.
 * --------------------------------------------------------------------------
 */

@#ifndef PSIY0
  @#define PSIY0 = 0.0265   // US 1993 birth rate
  @#define PSIR0 = 0.93     // US 1993 retiree survival (death prob 0.07)
  @#define PSIY1 = 0.0236   // US 2055 birth rate
  @#define PSIR1 = 0.963    // US 2055 retiree survival (death prob 0.037)
@#endif

//----------------------------------------------------------------------------
// 1. Endogenous variables (all stationary on the BGP)
//----------------------------------------------------------------------------
var
    tau_r   ${\tau^r}$        (long_name='retiree/worker ratio N^r/N^w')
    gw      ${g^w}$           (long_name='worker (gross) growth')
    gn      ${g^n}$           (long_name='population (gross) growth')
    g       ${g}$             (long_name='output (gross) growth')
    gpc     ${g/g^n}$         (long_name='per-capita output growth')
    gq      ${g^q}$           (long_name='robot-price growth on BGP')
    gZ      ${g^Z}$           (long_name='variety = automation growth g_Z=g_A')
    wshare  ${N^w/N}$         (long_name='worker share of (20+) population')
    ;

//----------------------------------------------------------------------------
// 2. Exogenous demographic rates (jump permanently in the experiment)
//----------------------------------------------------------------------------
varexo
    psi_y   ${\psi_y}$        (long_name='birth rate per worker')
    psi_r   ${\psi_r}$        (long_name='retiree survival probability')
    ;

//----------------------------------------------------------------------------
// 3. Parameters
//----------------------------------------------------------------------------
parameters
    omega   ${\omega}$        (long_name='prob a worker stays a worker (1-1/45)')
    chi     ${\chi}$          (long_name='robot-production curvature (<1)')
    eta     ${\eta}$          (long_name='(1-alpha)(eps-1)(1-rhoHat)(1-gamma_I)')
    ;

omega = 1 - 1/45;
// chi calibrated ONCE to US-1993 per-capita growth = 1.6% (Prop.1: g_n^{chi/(1-chi)})
// and held COMMON across regions (structural parameter), as in the paper.
chi   = log(1.016)/log(omega + 0.0265) / (1 + log(1.016)/log(omega + 0.0265));
// eta from recommended defaults: alpha=.33, eps=8, rhoHat=.31, gamma_I=.5
eta   = (1-0.33)*(8-1)*(1-0.31)*(1-0.50);

//----------------------------------------------------------------------------
// 4. Model (exact demographic dynamics + Proposition-1 BGP mapping)
//----------------------------------------------------------------------------
model;
[name='worker growth (eq.1)']
gw = omega + psi_y;
[name='retiree/worker law of motion (App. A.68d)']
tau_r = ((1-omega) + psi_r*tau_r(-1))/gw;
[name='population growth (App. A.68e)']
gn = gw*(1+tau_r)/(1+tau_r(-1));
[name='BGP output growth (Prop.1: g^{1-chi}=g_n)']
g = gn^(1/(1-chi));
[name='per-capita output growth']
gpc = g/gn;
[name='robot-price growth on BGP (g_q=g/g_n)']
gq = g/gn;
[name='variety = automation growth (Prop.1: g_Z=g_A=g^eta)']
gZ = g^eta;
[name='worker share of 20+ population']
wshare = 1/(1+tau_r);
end;

//----------------------------------------------------------------------------
// 5. Initial BGP (1993 rates) - stationary tau_r = (1-omega)/(g_w-psi_r)
//----------------------------------------------------------------------------
initval;
    psi_y = @{PSIY0};
    psi_r = @{PSIR0};
    gw    = omega + @{PSIY0};
    tau_r = (1-omega)/(gw - @{PSIR0});
    gn    = gw;
    g     = gn^(1/(1-chi));
    gpc   = g/gn;
    gq    = g/gn;
    gZ    = g^eta;
    wshare= 1/(1+tau_r);
end;
steady;

//----------------------------------------------------------------------------
// 6. Terminal BGP (2055 rates)
//----------------------------------------------------------------------------
endval;
    psi_y = @{PSIY1};
    psi_r = @{PSIR1};
    gw    = omega + @{PSIY1};
    tau_r = (1-omega)/(gw - @{PSIR1});
    gn    = gw;
    g     = gn^(1/(1-chi));
    gpc   = g/gn;
    gq    = g/gn;
    gZ    = g^eta;
    wshare= 1/(1+tau_r);
end;
steady;

//----------------------------------------------------------------------------
// 7. Perfect-foresight transition (rates jump at t=1; structure adjusts)
//----------------------------------------------------------------------------
perfect_foresight_setup(periods=200);
perfect_foresight_solver;
