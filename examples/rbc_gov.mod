/*
 * 含政府支出的基础 RBC 模型，随机模拟。
 * 来源：标准 RBC（Pfeifer RBC_baseline 谱系）+ 外生政府支出冲击。
 * 实验：stoch_simul，TFP 冲击 + 政府支出冲击，看 IRF 与理论矩。
 * 主体：家庭（消费-劳动-储蓄）、厂商（完全竞争 Cobb-Douglas）、
 *       政府（外生支出、一次总付税平衡预算，不优化）。
 * 时序：期末存量约定，资本以 k(-1) 进入当期生产。
 * 形式：非线性（R8 默认）。稳态解析求解，固定 n=1/3 反解 psi、G/Y=gy_share 反解 gss。
 */

//==================== 变量声明 ====================
var y      ${y}$       (long_name='output')
    c      ${c}$       (long_name='consumption')
    n      ${n}$       (long_name='labor')
    k      ${k}$       (long_name='capital (end of period)')
    invest ${i}$       (long_name='investment')
    w      ${w}$       (long_name='real wage')
    rk     ${r^k}$     (long_name='rental rate of capital')
    a      ${a}$       (long_name='TFP level')
    g      ${g}$       (long_name='government spending')
    log_y log_c log_invest log_n ;          // 报告用对数偏离
varexo eps_a ${\varepsilon_a}$ (long_name='TFP innovation')
       eps_g ${\varepsilon_g}$ (long_name='government spending innovation') ;
parameters
    betta    ${\beta}$    (long_name='discount factor')
    sigma    ${\sigma}$   (long_name='risk aversion')
    phi      ${\varphi}$  (long_name='inverse Frisch elasticity')
    alppha   ${\alpha}$   (long_name='capital share')
    delta    ${\delta}$   (long_name='depreciation rate')
    rho_a    ${\rho_a}$   (long_name='TFP persistence')
    rho_g    ${\rho_g}$   (long_name='government spending persistence')
    gy_share ${s_g}$      (long_name='steady-state G/Y target')
    psi      ${\psi}$     (long_name='labor disutility (reverse-solved)')
    gss      ${\bar G}$   (long_name='steady-state government spending (reverse-solved)') ;

//==================== 参数校准 ====================
betta    = 0.99;
sigma    = 1;
phi      = 1;
alppha   = 0.33;
delta    = 0.025;
rho_a    = 0.95;
rho_g    = 0.90;
gy_share = 0.20;
// psi、gss 在 steady_state_model 中反解，故此处不赋值

//==================== 模型方程 ====================
model;
// 劳动供给（F1）：消费-闲暇权衡
[name='F1: labor supply']
psi*n^phi = c^(-sigma)*w;
// 欧拉方程（F2）：消费跨期选择
[name='F2: Euler equation']
c^(-sigma) = betta*c(+1)^(-sigma)*(rk(+1) + 1 - delta);
// 劳动需求（F3）
[name='F3: labor demand']
w = (1-alppha)*y/n;
// 资本需求（F4），资本预定故 k(-1)
[name='F4: capital demand']
rk = alppha*y/k(-1);
// 生产函数（F5），资本预定故 k(-1)
[name='F5: production function']
y = a*k(-1)^alppha*n^(1-alppha);
// 资本运动律（F6），期末存量在左边
[name='F6: law of motion of capital']
k = invest + (1-delta)*k(-1);
// 资源约束（F7）
[name='F7: resource constraint']
y = c + invest + g;
// TFP 过程（F8），a 内生、仅 eps_a 外生
[name='F8: TFP process']
log(a) = rho_a*log(a(-1)) + eps_a;
// 政府支出过程（F9），g 内生、仅 eps_g 外生，绕稳态 gss
[name='F9: government spending process']
log(g) = (1-rho_g)*log(gss) + rho_g*log(g(-1)) + eps_g;
// 报告用对数偏离
[name='log output']     log_y = log(y);
[name='log consumption'] log_c = log(c);
[name='log investment'] log_invest = log(invest);
[name='log labor']      log_n = log(n);
end;

//==================== 稳态（解析 + 反解校准）====================
steady_state_model;
    a  = 1;
    rk = 1/betta - 1 + delta;                       // 由 F2
    kl = (alppha/rk)^(1/(1-alppha));                // 资本-劳动比 k/n（由 F4）
    n  = 1/3;                                       // 校准目标
    k  = kl*n;
    y  = kl^alppha*n;                               // 由 F5
    w  = (1-alppha)*kl^alppha;                      // 由 F3
    invest = delta*k;                               // 由 F6
    gss = gy_share*y;                               // 反解：命中 G/Y = gy_share
    g  = gss;
    c  = y - invest - g;                            // 由 F7
    psi = c^(-sigma)*w/n^phi;                       // 反解：命中 n = 1/3（由 F1）
    log_y = log(y); log_c = log(c);
    log_invest = log(invest); log_n = log(n);
end;

//==================== 检查 ====================
resid;
steady;
check;

//==================== 冲击 ====================
shocks;
    var eps_a; stderr 0.01;     // 非线性模型按小数写（1% = 0.01）
    var eps_g; stderr 0.01;
end;

//==================== 实验 ====================
stoch_simul(order=1, irf=40) log_y log_c log_invest log_n rk g;
