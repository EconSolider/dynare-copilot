// ==========================================================================
// Lu & Kameda (2024, JJIE 72, 101315)
// Two-sector search-friction fiscal DSGE for Japan.
// Calibrate-and-simulate: parameters fixed at paper Tables 2-4 (no estimation).
// Steady state: external reverse-calibration file lk2024_steadystate.m.
// See lk2024_derivation.md for full equations and typo resolutions.
// ==========================================================================

// ---------------------- 1. Endogenous variables ---------------------------
var
// goods / capital / pricing (15)
y r Y K k C invest lam psi p_m infl inflstar KF KZ dp
// labor market (11)
np ng n u v vp theta mm mu fp fg
// hours / wages (7)
hp hg wp wstar wg wbar wund
// value functions (4)
Op Og Nv J
// fiscal stocks (3)
GS GK B
// exogenous processes (15)
Am chip nu Af eta vg Pig z GC GI T tauc tauw taur i_nom
;

// ---------------------- 2. Exogenous innovations --------------------------
varexo
eps_Am eps_chi eps_nu eps_Af eps_eta eps_vg eps_Pig eps_z
eps_GC eps_GI eps_T eps_tauc eps_tauw eps_taur eps_i
;

// ---------------------- 3. Parameters -------------------------------------
parameters
// preferences / technology (calibrated, Table 2)
betta alp delta eta_ss nu_ss kappa phi zeta gam omp omw dinv hk hs
// labor-market separation
chip_ss chig
// calibrated-in-steady-state (placeholders; overwritten by steadystate.m)
sigp sigg lp lg Am_ss vg_ss
// fiscal steady-state levels / means
Pig_ss zss GC_ss GI_ss B_ss Y_ss T_ss i_ss infl_ss
tauc_ss tauw_ss taur_ss
// AR coefficients (Table 3)
rho_Am rho_chi rho_nu rho_Af rho_eta rho_vg rho_Pig rho_z
rho_GC rho_GI rho_T rho_tauc rho_tauw rho_taur rho_i
// fiscal-rule feedback (Table 3)
phib_T phib_tauc phib_tauw phib_taur phib_GC phib_GI
phiy_T phiy_tauc phiy_tauw phiy_taur phiy_GC phiy_GI
// Taylor rule
phi_pi phi_y
;

// ----- calibrated values (Table 2) -----
betta   = 0.99;
alp     = 0.35;
delta   = 0.025;
eta_ss  = 11;
nu_ss   = 1;
chip_ss = 0.012;
chig    = 0.0039;
Pig_ss  = 0.127;
tauc_ss = 0.077;
taur_ss = 0.409;
tauw_ss = 0.268;
i_ss    = 1/betta;
infl_ss = 1;

// ----- estimated structural means (Table 3) -----
hk    = 0.157;
hs    = 0.102;
kappa = 0.503;
phi   = 0.569;
zeta  = 1.415;
gam   = 0.339;
omp   = 0.693;
omw   = 0.596;
dinv  = 3.404;

// ----- AR coefficients (Table 3) -----
rho_Am   = 0.639;
rho_chi  = 0.949;
rho_nu   = 0.788;
rho_Af   = 0.822;
rho_eta  = 0.698;
rho_GC   = 0.650;
rho_GI   = 0.730;
rho_T    = 0.803;
rho_vg   = 0.886;
rho_Pig  = 0.978;
rho_tauc = 0.837;
rho_taur = 0.690;
rho_tauw = 0.969;
rho_z    = 0.937;
rho_i    = 0.639;

// ----- fiscal-rule debt-stabilisation (Table 3) -----
phib_T    =  0.203;
phib_tauc =  0.047;
phib_tauw =  0.010;
phib_taur =  0.078;
phib_GC   = -0.090;
phib_GI   = -0.101;
// ----- fiscal-rule cyclical (Table 3) -----
phiy_T    =  0.029;
phiy_tauc =  0.053;
phiy_tauw =  0.065;
phiy_taur =  0.042;
phiy_GC   = -0.103;
phiy_GI   = -0.117;
// ----- Taylor rule -----
phi_pi = 1.062;
phi_y  = 0.061;

// ----- placeholders (set by lk2024_steadystate.m) -----
sigp=0.48; sigg=0.461; lp=0.952; lg=0.143; Am_ss=0.5; vg_ss=0.001;
zss=0.1; GC_ss=0.178; GI_ss=0.072; B_ss=1.6; Y_ss=1; T_ss=0;

// ---------------------- 4. Model ------------------------------------------
model;
// ===== goods / capital / pricing =====
[name='G1 production (per firm) with public externalities']
y = Af*k^alp*hp^(1-alp)*(GK^hk*GS^hs);
[name='G2 capital FOC (rental)']
r = alp*p_m*y/k;
[name='G3 output aggregation (price dispersion)']
Y = np*y/dp;
[name='G4 capital market clearing']
K = np*k;
[name='G5 resource constraint']
Y = C + invest + GC + GI + lp*vp + lg*vg;
[name='G6 capital accumulation']
K = (1-delta)*K(-1) + (1-(dinv/2)*(invest/invest(-1)-1)^2)*invest;
[name='G7 marginal utility of consumption']
C^(-zeta)*(1+gam*nu*(zeta-1)*n)^zeta = (1+tauc)*lam;
[name='G8 investment FOC']
lam = psi*(1-(dinv/2)*(invest/invest(-1)-1)^2 - dinv*(invest/invest(-1)-1)*(invest/invest(-1)))
      + betta*psi(+1)*dinv*(invest(+1)/invest-1)*(invest(+1)/invest)^2;
[name='G9 capital Euler']
psi = betta*((1-taur(+1))*lam(+1)*r(+1) + (1-delta)*psi(+1));
[name='G10 bond Euler']
lam = betta*lam(+1)*i_nom/infl(+1);
[name='G11 Calvo numerator']
KF = lam*p_m*Y + omp*betta*infl(+1)^eta_ss*KF(+1);
[name='G12 Calvo denominator']
KZ = lam*Y + omp*betta*infl(+1)^(eta_ss-1)*KZ(+1);
[name='G13 optimal reset price (markup shock eta)']
inflstar = (eta/(eta-1))*(KF/KZ)*infl;
[name='G14 price index']
1 = omp*infl^(eta_ss-1) + (1-omp)*inflstar^(1-eta_ss);
[name='G15 price dispersion']
dp = omp*infl^eta_ss*dp(-1) + (1-omp)*inflstar^(-eta_ss);

// ===== labor market =====
[name='L1 private employment law']
np = (1-chip(-1))*np(-1) + fp(-1)*u(-1);
[name='L2 public employment law']
ng = (1-chig)*ng(-1) + fg(-1)*u(-1);
[name='L3 total employment']
n = np + ng;
[name='L4 unemployment']
u = 1 - n;
[name='L5 total vacancies']
v = vp + vg;
[name='L6 tightness']
theta = v/u;
[name='L7 matching']
mm = Am*u^kappa*v^(1-kappa);
[name='L8 vacancy-filling prob']
mu = mm/v;
[name='L9 job-finding private']
fp = (mm/u)*(vp/v);
[name='L10 job-finding public']
fg = (mm/u)*(vg/v);
[name='L11 job creation (free entry)']
lp = betta*(lam(+1)/lam)*mu*J(+1);

// ===== hours / wages =====
[name='W1 intensive margin (private)']
sigp/((1-tauw)*(1-hp)*lam) = (1-alp)*p_m*y/hp;
[name='W2 equal value (worker indifference) -> hg']
Op = Og;
[name='W3 staggered wage']
wp = omw*wp(-1) + (1-omw)*wstar;
[name='W4 target wage (Nash)']
wstar*hp = phi*wbar + (1-phi)*wund
           + (1-chip-fp)*betta*(lam(+1)/lam)*(wstar(+1)-wp(+1))*hp(+1);
[name='W5 public wage markup']
wg = (1+Pig)*wp;
[name='W6 firm reservation wage']
wbar = (1-alp)*p_m*y + lp*fp/mu;
[name='W7 worker reservation wage']
wund = (1/(1-tauw))*( z - sigp*log(1-hp)/lam
        + betta*fg*(lam(+1)/lam)*(Og(+1)-Nv(+1)) );

// ===== value functions =====
[name='V1 private worker value']
Op = (1-tauw)*wp*hp + sigp*log(1-hp)/lam
     + betta*(lam(+1)/lam)*((1-chip)*Op(+1)+chip*Nv(+1));
[name='V2 public worker value']
Og = (1-tauw)*wg*hg + sigg*log(1-hg)/lam
     + betta*(lam(+1)/lam)*((1-chig)*Og(+1)+chig*Nv(+1));
[name='V3 unemployed value']
Nv = z + betta*(lam(+1)/lam)*(fp*Op(+1)+fg*Og(+1)+(1-fp-fg)*Nv(+1));
[name='V4 firm value (production)']
J = (p_m*y - r*k - wp*hp) + betta*(lam(+1)/lam)*(1-chip)*J(+1);

// ===== fiscal =====
[name='F1 public services']
GS = ng*hg;
[name='F2 public capital accumulation']
GK = (1-delta)*GK(-1) + GI;
[name='F3 government budget -> B']
B + tauc*C + tauw*(wp*np*hp + wg*ng*hg) + taur*r(-1)*K(-1)
  = (i_nom(-1)/infl)*B(-1) + GC + GI + wg*ng*hg + lg*vg + z*u - T;

// ===== exogenous processes =====
[name='P1 matching efficiency']
log(Am)  = rho_Am*log(Am(-1))   + (1-rho_Am)*log(Am_ss)   + eps_Am;
[name='P2 separation rate (private)']
log(chip)= rho_chi*log(chip(-1))+ (1-rho_chi)*log(chip_ss)+ eps_chi;
[name='P3 labor disutility shifter']
log(nu)  = rho_nu*log(nu(-1))   + (1-rho_nu)*log(nu_ss)   + eps_nu;
[name='P4 TFP']
log(Af)  = rho_Af*log(Af(-1))   + (1-rho_Af)*log(1)       + eps_Af;
[name='P5 price markup']
log(eta) = rho_eta*log(eta(-1)) + (1-rho_eta)*log(eta_ss) + eps_eta;
[name='P6 public vacancy']
log(vg)  = rho_vg*log(vg(-1))   + (1-rho_vg)*log(vg_ss)   + eps_vg;
[name='P7 public wage markup']
log(Pig) = rho_Pig*log(Pig(-1)) + (1-rho_Pig)*log(Pig_ss) + eps_Pig;
[name='P8 unemployment benefit']
log(z)   = rho_z*log(z(-1))     + (1-rho_z)*log(zss)      + eps_z;
[name='P9 government consumption rule']
log(GC)  = rho_GC*log(GC(-1)) + (1-rho_GC)*(log(GC_ss)
           + phiy_GC*log(Y(-1)/Y_ss) + phib_GC*log(B(-1)/B_ss)) + eps_GC;
[name='P10 public investment rule']
log(GI)  = rho_GI*log(GI(-1)) + (1-rho_GI)*(log(GI_ss)
           + phiy_GI*log(Y(-1)/Y_ss) + phib_GI*log(B(-1)/B_ss)) + eps_GI;
[name='P11 lump-sum tax rule (level-deviation form, T_ss<0)']
T = T_ss + rho_T*(T(-1)-T_ss)
    + (1-rho_T)*( phib_T*B_ss*log(B(-1)/B_ss) + phiy_T*Y_ss*log(Y(-1)/Y_ss) ) + eps_T;
[name='P12 consumption tax rule']
log(tauc)= rho_tauc*log(tauc(-1)) + (1-rho_tauc)*(log(tauc_ss)
           + phiy_tauc*log(Y(-1)/Y_ss) + phib_tauc*log(B(-1)/B_ss)) + eps_tauc;
[name='P13 labor income tax rule']
log(tauw)= rho_tauw*log(tauw(-1)) + (1-rho_tauw)*(log(tauw_ss)
           + phiy_tauw*log(Y(-1)/Y_ss) + phib_tauw*log(B(-1)/B_ss)) + eps_tauw;
[name='P14 capital income tax rule']
log(taur)= rho_taur*log(taur(-1)) + (1-rho_taur)*(log(taur_ss)
           + phiy_taur*log(Y(-1)/Y_ss) + phib_taur*log(B(-1)/B_ss)) + eps_taur;
[name='P15 Taylor rule']
log(i_nom)= rho_i*log(i_nom(-1)) + (1-rho_i)*(log(i_ss)
           + phi_pi*log(infl/infl_ss) + phi_y*log(Y/Y_ss)) + eps_i;
end;

// ---------------------- 5. Shocks (Table 4 std dev) -----------------------
shocks;
var eps_Af   = 0.036^2;
var eps_Am   = 0.281^2;
var eps_nu   = 0.049^2;
var eps_eta  = 0.536^2;
var eps_chi  = 0.227^2;
var eps_GC   = 0.035^2;
var eps_GI   = 0.043^2;
var eps_vg   = 0.682^2;
var eps_Pig  = 0.151^2;
var eps_T    = 0.121^2;
var eps_tauc = 0.039^2;
var eps_taur = 0.045^2;
var eps_tauw = 0.034^2;
var eps_i    = 0.628^2;
var eps_z    = 0.054^2;
end;

steady;
resid;
check;

stoch_simul(order=1, irf=25, nograph, noprint, periods=0);
