/*
 * zlb_qe.mod
 * Compact New Keynesian model with portfolio-balance term premium and QE.
 * Purpose: analyze how the zero lower bound (ZLB) shapes the effectiveness of
 *          quantitative easing (QE), under a capital-quality-shock recession.
 *
 * Mechanism (CCF12-style portfolio balance, distilled to a representative agent):
 *   short bond and long-duration assets (long bond + capital) are imperfect
 *   substitutes -> a term premium zeta separates them. QE = central-bank long-bond
 *   holdings -> compresses zeta -> lowers required return on capital -> raises Qk
 *   -> stimulates investment. Capital-quality shock drives the rate to the ZLB.
 *
 * Three scenarios via macro switches (-DZLB, -DQE on the dynare command line):
 *   (1) ZLB=0, QE=0 : no ZLB (rate may go below 1), no QE  -- benchmark
 *   (2) ZLB=1, QE=0 : ZLB binds (lmmcp R>=1), no QE        -- policy constrained
 *   (3) ZLB=1, QE=1 : ZLB binds + QE active               -- QE fills the gap
 *
 * Reference: Chen, Curdia, Ferrero (2012, Economic Journal); local lib US_CCF12_rep.
 * Solver: perfect foresight + lmmcp for the ZLB. All equations nonlinear (R8).
 */

@#ifndef ZLB
@#define ZLB = 0
@#endif
@#ifndef QE
@#define QE = 0
@#endif

%----------------------------------------------------------------
% 1. Variable / shock / parameter declarations
%----------------------------------------------------------------
var C        ${C}$        (long_name='consumption')
    N        ${N}$        (long_name='labor')
    Y        ${Y}$        (long_name='output')
    mc       ${mc}$       (long_name='real marginal cost')
    W        ${W}$        (long_name='real wage')
    rk       ${r^k}$      (long_name='capital rental rate')
    Pi       ${\Pi}$      (long_name='gross inflation')
    K        ${K}$        (long_name='capital, end of period')
    I        ${I}$        (long_name='investment')
    Qk       ${Q^k}$      (long_name='price of capital (Tobin Q)')
    Rk       ${R^k}$      (long_name='realized return on capital')
    zeta     ${\zeta}$    (long_name='term premium')
    RL       ${R^L}$      (long_name='long-term nominal gross rate')
    R        ${R}$        (long_name='short nominal gross rate')
    qe       ${qe}$       (long_name='central-bank long-bond holdings (QE)')
    xi       ${\xi}$      (long_name='capital quality')
    ;

varexo eps_xi ${\varepsilon^{\xi}}$ (long_name='capital quality innovation');

parameters
    betta    ${\beta}$        (long_name='discount factor')
    sigma    ${\sigma}$       (long_name='risk aversion / inverse IES')
    varphi   ${\varphi}$      (long_name='inverse Frisch elasticity')
    chi      ${\chi}$         (long_name='labor disutility weight')
    alppha   ${\alpha}$       (long_name='capital share')
    delta    ${\delta}$       (long_name='depreciation rate')
    epsilon  ${\epsilon}$     (long_name='demand elasticity')
    phi_p    ${\phi_p}$       (long_name='Rotemberg price adjustment cost')
    kappa_I  ${\kappa_I}$     (long_name='investment adjustment cost')
    zetabar  ${\bar\zeta}$    (long_name='steady-state term premium')
    zeta_prime ${\zeta^{\prime}}$ (long_name='portfolio-balance elasticity')
    phi_pi   ${\phi_\pi}$     (long_name='Taylor rule inflation coeff')
    phi_y    ${\phi_y}$       (long_name='Taylor rule output coeff')
    rho_qe   ${\rho_{qe}}$    (long_name='QE persistence')
    phi_qe   ${\phi_{qe}}$    (long_name='QE response to output gap')
    rho_xi   ${\rho_\xi}$     (long_name='capital quality persistence')
    R_ss     ${R^{ss}}$       (long_name='steady-state gross short rate')
    Y_ss     ${Y^{ss}}$       (long_name='steady-state output')
    ;

%----------------------------------------------------------------
% 2. Calibration
%----------------------------------------------------------------
betta    = 0.99;
sigma    = 1;
varphi   = 1;
alppha   = 0.33;
delta    = 0.025;
epsilon  = 6;
phi_p    = 58.3;     // Rotemberg, matches Calvo theta=0.75 NKPC slope
kappa_I  = 2.5;
zetabar  = 0.0025;   // quarterly term premium ~ 1% annualized
zeta_prime = 0.025;  // QE of size 0.1 compresses premium by ~100bp annual
phi_pi   = 1.5;
phi_y    = 0.125;
rho_qe   = 0.8;
phi_qe   = 0.5;
rho_xi   = 0.9;

R_ss    = 1/betta;

// closed-form steady state (derivation section 6) -> pin Y_ss and chi (so that N=1)
mc_ss = (epsilon-1)/epsilon;
Rk_ss = (1+zetabar)/betta;
rk_ss = Rk_ss - (1-delta);
KY_ss = alppha*mc_ss/rk_ss;
K_ss  = KY_ss^(1/(1-alppha));
Y_ss  = K_ss^alppha;
I_ss  = delta*K_ss;
C_ss  = Y_ss - I_ss;
W_ss  = (1-alppha)*mc_ss*Y_ss;
chi   = C_ss^(-sigma)*W_ss;

%----------------------------------------------------------------
% 3. Analytical steady state
%----------------------------------------------------------------
steady_state_model;
    Pi   = 1;
    R    = 1/betta;
    zeta = zetabar;
    qe   = 0;
    xi   = 1;
    mc   = (epsilon-1)/epsilon;
    Qk   = 1;
    Rk   = (1+zetabar)/betta;
    rk   = Rk - (1-delta);
    KY   = alppha*mc/rk;
    K    = KY^(1/(1-alppha));
    Y    = K^alppha;
    I    = delta*K;
    C    = Y - I;
    N    = 1;
    W    = (1-alppha)*mc*Y/N;
    RL   = R*(1+zetabar);
end;

%----------------------------------------------------------------
% 4. Model
%----------------------------------------------------------------
model;
[name='F1 consumption Euler (short rate)']
C^(-sigma) = betta*C(+1)^(-sigma)*R/Pi(+1);

[name='F2 labor supply']
chi*N^varphi = C^(-sigma)*W;

[name='F3 production']
Y = (xi*K(-1))^alppha*N^(1-alppha);

[name='F4 capital rental (capital demand)']
rk = alppha*mc*Y/(xi*K(-1));

[name='F5 labor demand']
W = (1-alppha)*mc*Y/N;

[name='F6 Rotemberg NKPC']
phi_p*(Pi-1)*Pi = (1-epsilon) + epsilon*mc
    + phi_p*betta*(C(+1)^(-sigma)/C^(-sigma))*(Pi(+1)-1)*Pi(+1)*Y(+1)/Y;

[name='F7 capital accumulation']
K = (1-delta)*xi*K(-1) + (1 - (kappa_I/2)*(I/I(-1)-1)^2)*I;

[name='F8 investment FOC (Tobin Q)']
1 = Qk*(1 - (kappa_I/2)*(I/I(-1)-1)^2 - kappa_I*(I/I(-1)-1)*(I/I(-1)))
    + betta*(C(+1)^(-sigma)/C^(-sigma))*Qk(+1)*kappa_I*(I(+1)/I-1)*(I(+1)/I)^2;

[name='F9 realized return on capital']
Rk = xi*(rk + (1-delta)*Qk)/Qk(-1);

[name='F10 capital Euler with term-premium wedge']
1 + zeta = betta*(C(+1)^(-sigma)/C^(-sigma))*Rk(+1);

[name='F11 portfolio-balance term premium']
zeta = zetabar - zeta_prime*qe;

[name='F12 long-term nominal rate via term premium']
RL = R*(1+zeta);

[name='F15 resource constraint']
Y = C + I + (phi_p/2)*(Pi-1)^2*Y;

@#if ZLB
[name='F16 Taylor rule + ZLB', mcp = 'R > 1']
@#else
[name='F16 Taylor rule (no ZLB)']
@#endif
R = R_ss*Pi^phi_pi*(Y/Y_ss)^phi_y;

[name='F17 QE rule']
@#if QE
qe = rho_qe*qe(-1) + phi_qe*(Y_ss - Y)/Y_ss;
@#else
qe = 0;
@#endif

[name='F18 capital quality process']
log(xi) = rho_xi*log(xi(-1)) + eps_xi;
end;

steady;
resid;
check;

%----------------------------------------------------------------
% 5. Perfect-foresight experiment: capital-quality recession
%----------------------------------------------------------------
shocks;
var eps_xi;
periods 1;
values -0.05;
end;

perfect_foresight_setup(periods=100);
@#if ZLB
perfect_foresight_solver(lmmcp, maxit=200);
@#else
perfect_foresight_solver(maxit=200);
@#endif
