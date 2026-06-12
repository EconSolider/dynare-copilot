# 模板库（可直接套用的规范骨架）

> **何时读**：需要现成骨架起步时。**本文件回答**：RBC/NK/完全预见三个规范模板（英文标签+中文注释）、宏处理器变体写法、LaTeX 输出命令、DSGE_mod 论文对照表。

以下骨架提炼自 Johannes Pfeifer 的 DSGE_mod，体现规范写法：文件头注释块、变量/参数
`long_name`+LaTeX 名、`[name=]` 方程标注、`steady_state_model` 反解校准、`log_*` 辅助
变量、`resid;steady;check;` 流程。**按用户的具体模型修改，不要原样照搬数字。**

接近某篇论文时，优先去 DSGE_mod 取对应文件作起点：RBC 类→`RBC_baseline`、`Hansen_1985`；
NK 类→`Gali_2015_chapter_3`；中型估计→`Smets_Wouters_2007`；开放经济→`SGU_2003`、
`GarciaCicco_et_al_2010`；最优政策→`Gali_2015_chapter_5_*`；偶尔约束→
`Guerrieri_Iacoviello_2015`。

> 注意：`.mod` 文件里只有注释能用 §0 选定语言（中文/英文/日语）；`long_name='...'`、`[name='...']` 等一律英文，否则
> 预处理器报错。下方模板已遵循（标签英文、注释中文；实际使用时注释改为 [LANG]）。

## 模板 1：基础 RBC（随机模拟）

```dynare
/*
 * 基础 RBC 模型（含 TFP 冲击），随机模拟。
 * 时序：期末存量约定，资本以 k(-1) 进入当期生产。
 * 稳态解析求解，并固定稳态劳动 l=1/3 反解 psi。
 */

//==================== 变量声明 ====================
var y      ${y}$       (long_name='output')
    c      ${c}$       (long_name='consumption')
    k      ${k}$       (long_name='capital')
    l      ${l}$       (long_name='labor')
    invest ${i}$       (long_name='investment')
    z      ${z}$       (long_name='TFP')
    log_y log_c log_k log_l ;
varexo eps_z ${\varepsilon_z}$ (long_name='TFP shock') ;
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
// psi 在 steady_state_model 中反解

//==================== 模型方程 ====================
model;
// 欧拉方程：跨期消费选择
[name='Euler equation']
c^(-sigma) = betta*c(+1)^(-sigma)*(alppha*exp(z(+1))*k^(alppha-1)*l(+1)^(1-alppha) + 1 - delta);
// 劳动 FOC：消费-闲暇权衡
[name='labor FOC']
psi*c^sigma/(1-l) = (1-alppha)*exp(z)*k(-1)^alppha*l^(-alppha);
// 资本运动律（期末存量在左边）
[name='law of motion of capital']
k = invest + (1-delta)*k(-1);
// 资源约束
[name='resource constraint']
y = c + invest;
// 生产函数（资本预定，故 k(-1)）
[name='production function']
y = exp(z)*k(-1)^alppha*l^(1-alppha);
// TFP 过程（z 内生，仅 eps_z 外生）
[name='TFP process']
z = rhoz*z(-1) + eps_z;
[name='log output'] log_y = log(y);
[name='log consumption'] log_c = log(c);
[name='log capital'] log_k = log(k);
[name='log labor'] log_l = log(l);
end;

//==================== 稳态（解析 + 反解校准）====================
steady_state_model;
    z = 0;
    l  = 1/3;                                           // 校准目标
    kl = ((1/betta - 1 + delta)/alppha)^(1/(alppha-1)); // 资本-劳动比
    k  = kl*l;
    invest = delta*k;
    y  = kl^alppha*l;
    c  = y - invest;
    psi = (1-alppha)*kl^alppha*(1-l)/c^sigma;           // 反解 psi 命中 l=1/3
    log_y = log(y); log_c = log(c); log_k = log(k); log_l = log(l);
end;

//==================== 检查 ====================
resid;
steady;
check;

//==================== 冲击 ====================
shocks;
    var eps_z; stderr 0.007;
end;

//==================== 实验 ====================
stoch_simul(order=1, irf=40, hp_filter=1600) log_y log_c log_k log_l z;
```

## 模板 2：三方程新凯恩斯（缺口形式，随机模拟）

```dynare
/*
 * 基础三方程新凯恩斯模型（Galí 缺口形式）。
 * 所有变量为对零通胀稳态的对数线性偏离，故稳态全为 0。
 * 本模型属 R8 例外②（论文/教科书本身以线性化形式定义），故用 model(linear) 声明；
 *（例外① 是 discretionary_policy 的 Dynare 技术要求，与此无关）
 * 若需要非线性版（可做二阶福利分析），参考 DSGE_mod 的 Gali_2015_chapter_3_nonlinear。
 */

//==================== 变量声明 ====================
var x  ${x}$   (long_name='output gap')
    pi ${\pi}$ (long_name='inflation')
    i  ${i}$   (long_name='nominal interest rate')
    rn ${r^n}$ (long_name='natural rate of interest (AR(1) demand process)')
    v  ${v}$   (long_name='monetary policy shock process') ;
varexo eps_a ${\varepsilon_a}$ (long_name='demand / natural-rate innovation')
       eps_v ${\varepsilon_v}$ (long_name='monetary policy innovation') ;
parameters
    betta  ${\beta}$    (long_name='discount factor')
    sigma  ${\sigma}$   (long_name='inverse EIS')
    kappa  ${\kappa}$   (long_name='NKPC slope')
    phi_pi ${\phi_\pi}$ (long_name='Taylor rule inflation coefficient')
    phi_x  ${\phi_x}$   (long_name='Taylor rule output-gap coefficient')
    rho_a  ${\rho_a}$   (long_name='demand process persistence')
    rho_v  ${\rho_v}$   (long_name='monetary shock persistence') ;

//==================== 参数校准 ====================
betta  = 0.99;  sigma = 1;   kappa = 0.13;
phi_pi = 1.5;   phi_x = 0.125;
rho_a  = 0.90;  rho_v = 0.50;

//==================== 模型方程 ====================
model(linear);
// 动态 IS 曲线（欧拉方程缺口形式）
[name='Dynamic IS curve']
x = x(+1) - (1/sigma)*(i - pi(+1) - rn);
// 新凯恩斯菲利普斯曲线
[name='New Keynesian Phillips Curve']
pi = betta*pi(+1) + kappa*x;
// 泰勒规则（货币政策）
[name='Taylor rule']
i = phi_pi*pi + phi_x*x + v;
// 需求/自然利率过程（rn 内生，仅 eps_a 外生）
[name='demand / natural-rate process']
rn = rho_a*rn(-1) + eps_a;
// 货币政策过程（v 内生，仅 eps_v 外生）
[name='monetary policy process']
v = rho_v*v(-1) + eps_v;
end;

//==================== 稳态（全为 0）====================
steady_state_model;
    x = 0; pi = 0; i = 0; rn = 0; v = 0;
end;

//==================== 检查 ====================
resid;
steady;
check;     // BK 需泰勒原则 phi_pi > 1

//==================== 冲击 ====================
shocks;
    var eps_a; stderr 0.01;
    var eps_v; stderr 0.0025;
end;

//==================== 实验 ====================
stoch_simul(order=1, irf=20) x pi i rn;
```

## 模板 3：完全预见（永久冲击过渡路径，骨架）

```dynare
var c k ;
varexo x ;
parameters alppha betta delta gam ;
alppha = 0.33; betta = 0.99; delta = 0.025; gam = 1;

model;
// 资源约束（齐次式，省略 = 0）
[name='resource constraint']
c + k - x*k(-1)^alppha - (1-delta)*k(-1);
// 欧拉方程
[name='Euler equation']
c^(-gam) - betta*(alppha*x(+1)*k^(alppha-1) + 1 - delta)*c(+1)^(-gam);
end;

initval;                       // 初始稳态（x 在旧水平）
   x = 1;
   k = ((1/betta - 1 + delta)/(alppha*x))^(1/(alppha-1));
   c = x*k^alppha - delta*k;
end;
steady;

endval;                        // 终端稳态（x 永久升至 1.1）
   x = 1.1;
end;
steady;

perfect_foresight_setup(periods=200);
perfect_foresight_solver;

rplot c; rplot k;
```

## 宏处理器：一份文件维护多个变体

```dynare
@#define rule_type = 1     // 1 = 泰勒规则；0 = 货币增长规则

model;
   ...
@#if rule_type == 1
   // 泰勒规则
   [name='Taylor rule']
   i = phi_pi*pi + phi_x*x + v;
@#else
   // 货币增长规则
   [name='money growth rule']
   ...
@#endif
   ...
end;
```

> 宏处理器还支持 `@#for` 循环（多国/多部门模型）、`@#include` 模块化、内生化参数
> （variable flipping）等——完整语法、运算符、推导式和典型用法见 `references/macro-processor.md`。

## 输出 LaTeX 文档（可选，便于核对）

```dynare
write_latex_definitions;             // 变量/参数符号表
write_latex_original_model;          // 原始模型方程
write_latex_dynamic_model;           // Dynare 内部动态模型
write_latex_steady_state_model;      // 稳态模型
// 估计：write_latex_prior_table;
```

---

# 手册增补（Dynare 7.1 §4.3/4.5）

## `external_function`（模型里调用自定义 MATLAB 函数）

模型块里用到外部 MATLAB/Octave 函数（标量返回）须先声明：
```dynare
external_function(name=funcname);                          // nargs 默认 1
external_function(name=g, nargs=2, first_deriv_provided, second_deriv_provided);
external_function(name=h, nargs=3, first_deriv_provided=h_deriv);
```
不提供导数则 Dynare 用有限差分近似。`steady_state_model` 块外（EXPRESSION 处）用外部函数无需声明。

## 模型局部变量与两个算子（集中备查）

- `#z = MODEL_EXPR;`——跨方程共享子表达式，作用域仅 model 块；带超前/滞后会整体平移。
- `STEADY_STATE(x)`——取稳态值（泰勒规则/产出缺口常用；外生不可入内）。
- `EXPECTATION(-1)(x(+1))`——用上一期信息集的预期（内部转辅助变量 `AUX_EXPECT_*`）。

## LaTeX 输出命令（核对模型）

`write_latex_original_model;`（原始）、`write_latex_dynamic_model;`（Dynare 内部动态，含辅助变量
替换）、`write_latex_static_model;`（静态）、`write_latex_steady_state_model;`（steady_state_model
块）。需 LaTeX 包 `geometry fullpage breqn`。加 `(write_equation_tags)` 把 `[name=]` 也写进去。
