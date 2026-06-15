// ============================================================
// 含政府投资的趋势 RBC 模型
// Trend RBC with public capital externality
//
// 机制：政府投资 → 公共资本存量 → 生产外部性（Aschauer 1989）
//       趋势增长率 gam（劳动增强型技术进步，季度）
//       所有量值变量已对技术水平 A_t 去趋势
//
// 参考：Aschauer (1989, JME), Barro (1990, JPE),
//       King-Plosser-Rebelo (1988, QJE)
// ============================================================

// ---------- 内生变量（16 个，全为去趋势量）-------------------
var y        ${y}$          (long_name='output, detrended')
    c        ${c}$          (long_name='consumption, detrended')
    k        ${k}$          (long_name='private capital, detrended')
    n        ${n}$          (long_name='labor hours')
    invest   ${\imath}$     (long_name='private investment, detrended')
    ig       ${i_g}$        (long_name='government investment, detrended')
    kg       ${k_g}$        (long_name='public capital stock, detrended')
    z        ${z}$          (long_name='TFP shock, log level')
    w        ${w}$          (long_name='real wage, detrended')
    rk       ${r^k}$        (long_name='rental rate of private capital')
    log_y    (long_name='log output')
    log_c    (long_name='log consumption')
    log_k    (long_name='log private capital')
    log_kg   (long_name='log public capital')
    log_ig   (long_name='log government investment')
    log_n    (long_name='log labor');

// ---------- 外生变量（仅冲击创新项，R3）-----------------------
varexo eps_z   ${\varepsilon_z}$   (long_name='TFP innovation')
       eps_ig  ${\varepsilon_g}$   (long_name='government investment innovation');

// ---------- 参数 ----------------------------------------------
parameters betta    ${\beta}$        (long_name='household discount factor')
           gam      ${\gamma}$       (long_name='quarterly trend growth rate')
           delta    ${\delta}$       (long_name='private capital depreciation')
           deltag   ${\delta_g}$     (long_name='public capital depreciation')
           alppha   ${\alpha}$       (long_name='private capital income share')
           alphag   ${\alpha_g}$     (long_name='public capital externality')
           phhi     ${\varphi}$      (long_name='inverse Frisch elasticity')
           psi      ${\psi}$         (long_name='labor disutility, back-solved to hit n=1/3')
           rhoz     ${\rho_z}$       (long_name='TFP shock persistence')
           rho_ig   ${\rho_g}$       (long_name='government investment persistence')
           gy       ${g_y}$          (long_name='steady-state gov investment / output ratio')
           ig_ss    ${i_g^{ss}}$     (long_name='steady-state gov investment, back-solved');

// ---------- 参数校准 ------------------------------------------
// 标准 RBC 校准（季度数据）
betta   = 0.99;     // 季度贴现因子 → 年化约 4%
gam     = 0.005;    // 季度趋势增长率 → 年化 2%
delta   = 0.025;    // 私人资本折旧 → 年化 10%
deltag  = 0.05;     // 公共资本折旧 → 年化 20%（基础设施）

// 生产函数弹性
alppha  = 0.33;     // 私人资本份额
alphag  = 0.10;     // 公共资本外部性弹性（Aschauer 1989）

// 家庭偏好
phhi    = 1.0;      // Frisch 弹性倒数（= 1，标准设定）
// psi 在 steady_state_model 中反解，命中 n = 1/3

// 冲击过程
rhoz    = 0.95;     // TFP 持续性
rho_ig  = 0.80;     // 政府投资持续性

// 财政结构
gy      = 0.05;     // 政府投资 / 产出稳态比 = 5%
// ig_ss 在 steady_state_model 中反解，命中 gy 目标

// ============================================================
// 模型方程（16 条，对应 16 个内生变量，R4 ✓）
// 时序：k、kg、ig 为状态变量（期末存量，R2 ✓）
//       y, c, n, invest, w, rk 为控制变量（当期跳跃）
// ============================================================
model;

// --- 生产技术 ---

// (1) 生产函数（对数效用，去趋势坐标；公共资本为外部性，用 kg(-1)，R2）
[name='production function']
y = exp(z) * kg(-1)^alphag * k(-1)^alppha * n^(1-alppha-alphag);

// (2) 劳动需求 FOC（厂商，F3）
[name='labor demand FOC']
w = (1-alppha-alphag) * y / n;

// (3) 资本租金率 FOC（厂商，F4）
[name='capital rental rate FOC']
rk = alppha * y / k(-1);

// --- 家庭最优化 ---

// (4) 消费欧拉方程（对数效用，去趋势后有效贴现因子 = betta/(1+gam)，F1）
[name='consumption Euler equation']
c^(-1) = (betta/(1+gam)) * c(+1)^(-1) * (rk(+1) + 1 - delta);

// (5) 劳动供给 FOC（F2）
[name='labor supply FOC']
psi * n^phhi * c = w;

// --- 资本积累 ---

// (6) 私人资本积累（去趋势，R2：k 为期末存量）
[name='private capital law of motion']
(1+gam) * k = (1-delta) * k(-1) + invest;

// (7) 公共资本积累（去趋势，R2：kg 为期末存量）
[name='public capital law of motion']
(1+gam) * kg = (1-deltag) * kg(-1) + ig;

// --- 市场出清 ---

// (8) 资源约束（商品市场出清；Walras 定律：家庭预算约束冗余）
[name='resource constraint']
y = c + invest + ig;

// --- 外生过程 ---

// (9) TFP 冲击（E1；AR(1)，z 为内生，eps_z 为创新，R3）
[name='TFP process']
z = rhoz * z(-1) + eps_z;

// (10) 政府投资过程（E2；对数 AR(1)，ig_ss 为稳态水平参数）
[name='government investment process']
log(ig) = (1-rho_ig)*log(ig_ss) + rho_ig*log(ig(-1)) + eps_ig;

// --- 对数辅助变量（IRF 用，方便解读百分比偏离）---

// (11)-(16) 各量的对数水平
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

end;

// ============================================================
// 解析稳态（steady_state_model，顺序求值，见推导第6节）
// psi 和 ig_ss 在此反解，覆盖 parameters 区的缺省值
// ============================================================
steady_state_model;
    z = 0;

    // 步骤1：资本租金率（欧拉方程稳态）
    rk = (1+gam)/betta - (1-delta);

    // 步骤2：关键比率
    ky  = alppha / rk;                   // 私人资本/产出比
    kgy = gy / (gam + deltag);           // 公共资本/产出比

    // 步骤3：稳态劳动归一化目标
    n_ss = 1/3;

    // 步骤4：稳态产出（由生产函数 + 比率推出）
    // y = (kgy*y)^alphag * (ky*y)^alppha * n^(1-alppha-alphag)
    // => y^(1-alppha-alphag) = kgy^alphag * ky^alppha * n^(1-alppha-alphag)
    // => y = (kgy^alphag * ky^alppha)^(1/(1-alppha-alphag)) * n
    y = (kgy^alphag * ky^alppha)^(1/(1-alppha-alphag)) * n_ss;

    // 步骤5：其他量值变量
    k      = ky * y;
    kg     = kgy * y;
    invest = (gam + delta) * k;
    ig_ss  = gy * y;                     // 反解参数 ig_ss
    ig     = ig_ss;
    c      = y - invest - ig;
    w      = (1-alppha-alphag) * y / n_ss;
    rk_chk = alppha * y / k;             // 核对用（应等于 rk）

    // 步骤6：反解劳动负效用权重 psi（命中 n = 1/3）
    psi = w / (n_ss^phhi * c);

    n = n_ss;

    // 对数辅助变量稳态
    log_y  = log(y);
    log_c  = log(c);
    log_k  = log(k);
    log_kg = log(kg);
    log_ig = log(ig);
    log_n  = log(n);
end;

// ============================================================
// 验证：残差、稳态、BK 条件
// ============================================================
resid;
steady;
check;

// ============================================================
// 随机模拟：冲击设定与 stoch_simul
// ============================================================
shocks;
    var eps_z;   stderr 0.01;    // TFP 冲击标准差 = 1%
    var eps_ig;  stderr 0.02;    // 政府投资冲击标准差 = 2%
end;

// 一阶近似；输出 IRF 40 期；nograph（由 plot_irfs_pub.m 出图）
stoch_simul(order=1, irf=40, nograph, hp_filter=1600)
    y c invest ig kg n w rk
    log_y log_c log_k log_kg log_ig log_n;
