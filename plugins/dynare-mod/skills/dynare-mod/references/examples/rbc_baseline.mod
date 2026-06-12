/*
 * 基础 RBC 模型（含 TFP 冲击），随机模拟。
 * 配套推导：references/examples/rbc_baseline_derivation.md（方程的 [name='Fk: ...'] 回指其 FOC 编号）。
 * 时序：期末存量约定，资本以 k(-1) 进入当期生产（R2）。
 * 稳态解析求解，固定稳态劳动 l=1/3，反解 psi 命中该目标。
 * 形式：非线性（R8），TFP 以 z=log(A) 写 AR(1)，模型里用 exp(z)。
 */

//==================== 变量声明 ====================
var y      ${y}$       (long_name='output')
    c      ${c}$       (long_name='consumption')
    k      ${k}$       (long_name='capital')
    l      ${l}$       (long_name='labor')
    invest ${i}$       (long_name='investment')
    z      ${z}$       (long_name='log TFP')
    log_y log_c log_k log_l ;       // 对数报告量
varexo eps_z ${\varepsilon_z}$ (long_name='TFP shock') ;   // 仅创新项进 varexo (R3)
parameters
    betta  ${\beta}$   (long_name='discount factor')
    sigma  ${\sigma}$  (long_name='risk aversion')
    alppha ${\alpha}$  (long_name='capital share')
    delta  ${\delta}$  (long_name='depreciation rate')
    rhoz   ${\rho_z}$  (long_name='TFP persistence')
    psi    ${\psi}$    (long_name='labor disutility') ;

//==================== 参数校准 ====================
betta  = 0.99;
sigma  = 1;
alppha = 0.33;
delta  = 0.025;
rhoz   = 0.95;
// psi 在 steady_state_model 中反解（校准目标 l=1/3）

//==================== 模型方程（逐条对应推导 FOC）====================
model;
// 欧拉方程：跨期消费选择
[name='F1: Euler equation']
c^(-sigma) = betta*c(+1)^(-sigma)*(alppha*exp(z(+1))*k^(alppha-1)*l(+1)^(1-alppha) + 1 - delta);
// 劳动供给 FOC：消费-闲暇权衡（右边 = 工资 = 劳动边际产品）
[name='F2: labor supply FOC']
psi*c^sigma/(1-l) = (1-alppha)*exp(z)*k(-1)^alppha*l^(-alppha);
// 资本运动律（期末存量在左边，R2）
[name='F3: law of motion of capital']
k = invest + (1-delta)*k(-1);
// 资源约束
[name='F4: resource constraint']
y = c + invest;
// 生产函数（资本预定，故 k(-1)）
[name='F5: production function']
y = exp(z)*k(-1)^alppha*l^(1-alppha);
// 对数报告量（便于读 IRF / 接观测方程）
[name='F6: log output']      log_y = log(y);
[name='F7: log consumption'] log_c = log(c);
[name='F8: log capital']     log_k = log(k);
[name='F9: log labor']       log_l = log(l);
// TFP 过程（z 内生，仅 eps_z 外生）
[name='F10: TFP process']
z = rhoz*z(-1) + eps_z;
end;

//==================== 稳态（解析 + 反解校准；照抄推导第6节）====================
steady_state_model;
    z  = 0;
    l  = 1/3;                                           // 校准目标
    kl = ((1/betta - 1 + delta)/alppha)^(1/(alppha-1)); // 资本-劳动比 K/N
    k  = kl*l;
    invest = delta*k;
    y  = kl^alppha*l;
    c  = y - invest;
    psi = (1-alppha)*kl^alppha*(1-l)/c^sigma;           // 反解 psi，命中 l=1/3
    log_y = log(y); log_c = log(c); log_k = log(k); log_l = log(l);
end;

//==================== 检查 ====================
resid;     // 稳态残差应近 0
steady;    // 求解/验证稳态
check;     // Blanchard-Kahn

//==================== 冲击 ====================
shocks;
    var eps_z; stderr 0.007;     // 非线性模型按小数写标准差（R8）
end;

//==================== 实验 ====================
stoch_simul(order=1, irf=40, hp_filter=1600) log_y log_c log_k log_l z;
