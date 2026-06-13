/*
 * BGG 金融摩擦比较模型
 * 来源：Bernanke, Gertler & Gilchrist (1999), Handbook of Macroeconomics
 * 比较：WITH_FA=1（CSV 最优合约金融摩擦）vs WITH_FA=0（无摩擦标准 NK）
 * 时序：期末存量约定（R2），K_t 为 t 期末资本，生产用 K_{t-1}
 * 形式：非线性（R8），Dynare 做一阶泰勒展开
 * 运行：dynare bgg_financial                  （WITH_FA=1，默认）
 *       dynare bgg_financial -DWITH_FA=0      （无摩擦 NK 对照组）
 */

// 默认含摩擦；命令行 -DWITH_FA=0 可覆盖
@#ifndef WITH_FA
@#define WITH_FA = 1
@#endif

//============================================================
// 变量声明（20 个内生变量，对应方程 F1-F20）
//============================================================
var
    c        ${C}$         (long_name='household consumption')
    n_lab    ${N}$         (long_name='labor hours')
    infl     ${\Pi}$       (long_name='gross CPI inflation')
    r        ${R}$         (long_name='gross real interest rate')
    rn       ${R^n}$       (long_name='gross nominal interest rate')
    q        ${Q}$         (long_name='Tobin Q - price of capital')
    k        ${K}$         (long_name='capital stock end-of-period')
    nw       ${N^e}$       (long_name='entrepreneur net worth')
    rk       ${R^k}$       (long_name='gross return on capital')
    y        ${Y}$         (long_name='output')
    mc       ${MC}$        (long_name='real marginal cost')
    invest   ${I}$         (long_name='investment')
    a        ${A}$         (long_name='TFP level')
    c_e      ${C^e}$       (long_name='entrepreneur consumption')
    g        ${G}$         (long_name='government spending')
    premium  ${\Psi}$      (long_name='external finance premium')
    x1       ${x_1}$       (long_name='Calvo recursive sum 1')
    x2       ${x_2}$       (long_name='Calvo recursive sum 2')
    pstar    ${P^*/P}$     (long_name='optimal reset price ratio')
    delta_p  ${\Delta}$    (long_name='price dispersion')
;

varexo
    eps_a  ${\varepsilon^a}$  (long_name='TFP innovation')
    eps_g  ${\varepsilon^g}$  (long_name='government spending innovation')
    eps_m  ${\varepsilon^m}$  (long_name='monetary policy innovation')
;

//============================================================
// 参数声明
//============================================================
parameters
    betta    ${\beta}$        (long_name='household discount factor')
    sigma    ${\sigma}$       (long_name='risk aversion')
    phi_n    ${\varphi}$      (long_name='inverse Frisch elasticity')
    psi      ${\psi}$         (long_name='labor disutility - SS calibrated')
    alpha    ${\alpha}$       (long_name='capital share')
    delta    ${\delta}$       (long_name='depreciation rate')
    theta    ${\theta}$       (long_name='Calvo non-adjustment probability')
    eps_p    ${\varepsilon_p}$(long_name='CES substitution elasticity')
    phi_k    ${\phi_k}$       (long_name='investment adjustment cost coefficient')
    gamma_e  ${\gamma}$       (long_name='entrepreneur survival rate')
    chi      ${\chi}$         (long_name='premium elasticity wrt leverage')
    we       ${\bar{W}^e}$    (long_name='entrepreneur endowment - SS calibrated')
    s_ss     ${\bar{s}}$      (long_name='steady state external finance premium target')
    gy_share                  (long_name='government spending to output ratio')
    rho_R    ${\rho_R}$       (long_name='Taylor rule smoothing')
    phi_pi   ${\phi_\pi}$     (long_name='Taylor rule inflation coefficient')
    phi_y    ${\phi_y}$       (long_name='Taylor rule output coefficient')
    rho_a    ${\rho_a}$       (long_name='TFP persistence')
    rho_g    ${\rho_g}$       (long_name='government spending persistence')
    y_ss                      (long_name='steady state output - for Taylor rule')
    rn_ss                     (long_name='steady state nominal rate - for Taylor rule')
    g_ss                      (long_name='steady state gov spending - for AR(1) mean')
;

//============================================================
// 参数校准
//============================================================

betta    = 0.99;
sigma    = 1;
phi_n    = 3;
alpha    = 0.35;
delta    = 0.025;
phi_k    = 1.0;
theta    = 0.75;
eps_p    = 11;       // 加成约 10%，与 BGG 一致

gamma_e  = 0.9728;   // 存活率（BGG 原版）
chi      = 0.05;     // 溢价杠杆弹性（BGG niv=0.05）
s_ss     = 1.005;    // 稳态季频溢价 0.5%（BGG 原版）

gy_share = 0.20;
rho_R    = 0.90;
phi_pi   = 1.50;
phi_y    = 0.125;
rho_a    = 0.90;
rho_g    = 0.90;

// 占位（稳态反解后自动更新）
psi      = 1;
we       = 0.01;
y_ss     = 1;
rn_ss    = 1.0101;
g_ss     = 0.2;

//============================================================
// 稳态解析式（自上而下逐行可解）
//============================================================
steady_state_model;

    // 外生稳态
    a        = 1;
    infl     = 1;
    delta_p  = 1;

    // 利率
    r        = 1/betta;
    rn       = r;

    // 溢价
    @#if WITH_FA
    premium  = s_ss;
    @#else
    premium  = 1;
    @#endif

    // 资本回报（资本套利 F4 稳态）
    rk       = premium * r;

    // 边际成本（Calvo 零通胀稳态）
    mc       = (eps_p - 1) / eps_p;

    // Tobin's Q（稳态调整成本=0）
    q        = 1;

    // 资本产出比（F3 稳态：rk = mc*alpha*yk + (1-delta)，Q=1）
    yk_ss    = (rk - (1-delta)) / (mc * alpha);

    // 资本劳动比（yk = kl^(alpha-1)）
    kl_ss    = yk_ss^(1/(alpha-1));

    // 劳动归一化 N=1/3
    n_lab    = 1/3;
    k        = kl_ss * n_lab;
    y        = a * k^alpha * n_lab^(1-alpha);
    invest   = delta * k;

    // 企业家净值
    @#if WITH_FA
    nw       = q * k / s_ss^(1/chi);
    @#else
    nw       = q * k;
    @#endif

    // 总权益（中间量）
    Vss      = (rk - r)*q*k + r*nw;
    c_e      = (1-gamma_e) * Vss;

    // 反解禀赋 we（使 F7 稳态成立）
    we       = nw - gamma_e * Vss;

    // 政府支出
    g_ss     = gy_share * y;
    g        = g_ss;

    // 家庭消费（资源约束 F18）
    c        = y - invest - g - c_e;

    // 反解劳动负效用 psi（使 F2 稳态成立）
    psi      = mc * (1-alpha) * y / (n_lab^(1+phi_n) * c^sigma);

    // Calvo 稳态
    pstar    = 1;
    x1       = c^(-sigma) * mc * y / (1 - theta*betta);
    x2       = c^(-sigma) * y  / (1 - theta*betta);

    // 稳态水平参数（模型方程引用）
    y_ss     = y;
    rn_ss    = rn;

end;

//============================================================
// 模型方程（20 条，F1-F20）
//============================================================
model;

// F1: 家庭欧拉方程
[name='euler']
c^(-sigma) = betta * r * c(+1)^(-sigma);

// F2: 劳动市场均衡（MRS = 实际工资）
[name='labor_market']
psi * n_lab^phi_n * c^sigma = mc * (1-alpha) * y / n_lab;

// F3: 资本回报率
[name='rk_identity']
rk = (mc * alpha * y / k(-1) + (1-delta) * q) / q(-1);

// F4: 资本套利（外部融资溢价 × 无风险利率 = 期望资本回报，前瞻）
[name='capital_arbitrage']
rk(+1) = premium * r;

// F5: Tobin's Q（资本品生产商 FOC，CEE 投资调整成本）
[name='tobin_q']
1 = q*(1 - phi_k/2*(invest/invest(-1)-1)^2 - phi_k*(invest/invest(-1)-1)*(invest/invest(-1)))
    + betta*(c(+1)^(-sigma)/c^(-sigma))*q(+1)*phi_k*(invest(+1)/invest-1)*(invest(+1)/invest)^2;

// F6: 资本积累
[name='capital_accum']
k = (1-delta)*k(-1) + (1 - phi_k/2*(invest/invest(-1)-1)^2)*invest;

// F7/F8: 金融摩擦块
@#if WITH_FA
[name='net_worth']
nw = gamma_e*((rk - r(-1))*q(-1)*k(-1) + r(-1)*nw(-1)) + we;
[name='premium_eq']
premium = (q*k/nw)^chi;
@#else
[name='net_worth']
nw = q*k;
[name='premium_eq']
premium = 1;
@#endif

// F9: 企业家消费
[name='entrepreneur_cons']
c_e = (1-gamma_e)*((rk - r(-1))*q(-1)*k(-1) + r(-1)*nw(-1));

// F10: 生产函数（含价格分散度）
[name='production']
y*delta_p = a*k(-1)^alpha*n_lab^(1-alpha);

// F11: Calvo 递归式 x1
[name='calvo_x1']
x1 = c^(-sigma)*mc*y + theta*betta*x1(+1)*infl(+1)^eps_p;

// F12: Calvo 递归式 x2
[name='calvo_x2']
x2 = c^(-sigma)*y + theta*betta*x2(+1)*infl(+1)^(eps_p-1);

// F13: 最优重定价
[name='optimal_price']
pstar = eps_p/(eps_p-1)*x1/x2;

// F14: 价格指数演化
[name='price_index']
1 = theta*infl^(eps_p-1) + (1-theta)*pstar^(1-eps_p);

// F15: 价格分散度演化
[name='price_disp']
delta_p = (1-theta)*pstar^(-eps_p) + theta*infl^eps_p*delta_p(-1);

// F16: 费雪方程
[name='fisher']
rn = r*infl(+1);

// F17: Taylor 规则
[name='taylor']
rn/rn_ss = (rn(-1)/rn_ss)^rho_R * (infl^phi_pi*(y/y_ss)^phi_y)^(1-rho_R) * exp(eps_m);

// F18: 资源约束（Walras：债券市场出清已由预算约束隐含，不单列）
[name='resource']
y = c + invest + g + c_e;

// F19: TFP 过程
[name='tfp_process']
log(a) = rho_a*log(a(-1)) + eps_a;

// F20: 政府支出过程
[name='gov_process']
log(g) = (1-rho_g)*log(g_ss) + rho_g*log(g(-1)) + eps_g;

end;

//============================================================
// 稳态与 BK 验证
//============================================================
steady;
resid(non_zero);
check;

//============================================================
// 冲击
//============================================================
shocks;
var eps_m; stderr 0.0025;   // 货币政策冲击 25bp
var eps_a; stderr 0.01;     // TFP 冲击 1%
var eps_g; stderr 0.01;     // 政府支出冲击 1%
end;

//============================================================
// 随机模拟（nograph：使用 plot_irfs_pub 出版图）
//============================================================
stoch_simul(order=1, irf=20, nograph, periods=0);
