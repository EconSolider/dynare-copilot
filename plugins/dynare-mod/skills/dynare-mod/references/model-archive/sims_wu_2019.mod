// ============================================================
// Sims & Wu (2019): The Four Equation New Keynesian Model
// Linearized system (paper Subsection 2.1 / 2.3, Figures 1-4)
// model(linear): all variables are log-deviations, zero steady state
// Calibration: Table 1 of the paper
// ============================================================

// ---------- 内生变量 (7) ----------
var
    x       ${x}$         (long_name='output gap')
    pi      ${\pi}$       (long_name='inflation')
    rs      ${r^s}$       (long_name='short-term nominal rate')
    qe      ${qe}$        (long_name='central bank long-bond portfolio (QE)')
    rf      ${r^f}$       (long_name='natural rate of interest')
    theta   ${\theta}$    (long_name='credit (leverage) shock')
    exr     ${exr}$       (long_name='expected excess return on long bond')
    ;

// ---------- 外生创新 (4) ----------
varexo
    eps_f       ${\varepsilon^f}$       (long_name='natural rate innovation')
    eps_theta   ${\varepsilon^\theta}$  (long_name='credit innovation')
    eps_r       ${\varepsilon^r}$       (long_name='monetary policy innovation')
    eps_q       ${\varepsilon^q}$       (long_name='QE innovation')
    ;

// ---------- 参数 ----------
parameters
    betta z sigma bFI bcb gam zeta
    rho_r phi_pi phi_x
    rho_f rho_theta rho_q
    ;

// Table 1 calibration
betta     = 0.995;   // discount factor
z         = 0.33;    // child consumption share
sigma     = 1;       // inverse IES
bFI       = 0.70;    // weight on leverage in IS/PC
bcb       = 0.30;    // weight on QE in IS/PC (bFI + bcb = 1)
gam       = 0.086;   // elasticity of inflation w.r.t. real MC
zeta      = 2;       // elasticity of gap w.r.t. real MC
rho_r     = 0.8;     // Taylor smoothing
phi_pi    = 1.5;     // Taylor inflation
phi_x     = 0;       // Taylor gap
rho_f     = 0.8;     // AR natural rate
rho_theta = 0.8;     // AR leverage
rho_q     = 0.8;     // AR QE

// ---------- 模型方程 ----------
model(linear);

// E1: IS curve (eq. 2.1)
[name='IS curve']
x = x(+1) - ((1-z)/sigma)*( rs - pi(+1) - rf )
      - z*( bFI*( theta(+1) - theta ) + bcb*( qe(+1) - qe ) );

// E2: Phillips curve (eq. 2.2)
[name='Phillips curve']
pi = gam*zeta*x - ( z*gam*sigma/(1-z) )*( bFI*theta + bcb*qe ) + betta*pi(+1);

// E3: Taylor rule (eq. 2.33)
[name='Taylor rule']
rs = rho_r*rs(-1) + (1-rho_r)*( phi_pi*pi + phi_x*x ) + eps_r;

// E4: QE rule (eq. 2.34)
[name='QE rule']
qe = rho_q*qe(-1) + eps_q;

// E5: natural rate process (eq. 2.35)
[name='natural rate AR(1)']
rf = rho_f*rf(-1) + eps_f;

// E6: credit shock process (eq. 2.36)
[name='credit shock AR(1)']
theta = rho_theta*theta(-1) + eps_theta;

// E7: expected excess return on long bond (eq. B.37 + 2.37, for Fig. 4)
[name='expected excess return']
exr = pi(+1) + sigma*( bFI*( theta(+1) - theta ) + bcb*( qe(+1) - qe ) ) - rs;

end;

// ---------- 冲击 ----------
shocks;
    var eps_f     = 1;   // natural rate shock
    var eps_theta = 1;   // credit shock
    var eps_r     = 1;   // monetary policy shock
    var eps_q     = 1;   // QE shock
end;

steady;
check;
resid;

stoch_simul(order=1, irf=20, nograph, periods=0);
