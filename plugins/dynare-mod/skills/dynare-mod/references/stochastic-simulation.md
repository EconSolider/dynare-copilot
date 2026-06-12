# 随机模拟（stoch_simul）

> **何时读**：任务含 IRF/矩/方差分解/政策函数，命令族 `stoch_simul`。**本文件回答**：随机冲击块写法、stoch_simul 选项、结果存放、非平稳/混合冲击等情形。

`stoch_simul` 在**确定性稳态**附近做泰勒展开，求出决策/政策规则，输出政策函数、
（理论或模拟）矩、方差分解和脉冲响应（IRF）。这是 RBC / 新凯恩斯 / DSGE 在理性预期
下分析的主力命令。

## 冲击块——随机情形写法

随机情形下 `shocks` 块设定外生**创新项的协方差矩阵**（不是时间路径）：

```dynare
shocks;
    var eps_a;            stderr 0.0072;     // 标准差
    var eps_g          =  0.0052^2;          // 方差（= 标准差平方）
    corr eps_a, eps_g  =  0.3;               // 相关系数
end;
```

- `stderr` 给标准差；`var x = ...;` 给**方差**。
- **非线性模型（R8 默认）标准差按小数写**：1% 写 `stderr 0.01`，不要乘 100；只有
  线性化模型（变量本身是百分比偏离）才写 `stderr 1` 表示 1%。写错会让高阶近似的
  不确定性修正项出错。
- 把某冲击方差设为 0 可在不删除变量的前提下将其移出矩/IRF。
- 相关冲击的方差分解走 Cholesky 分解，因此**依赖 `varexo` 的声明顺序**。

## `stoch_simul` 常用选项

- `order = 1 | 2 | 3`：泰勒展开阶数，默认 2。≥3 阶隐含 `k_order_solver`，且只有**模拟**矩
  （需 `periods`）。
- `irf = 整数`：IRF 期数；`irf=0` 关闭画图，默认 40。
- `irf_shocks = (eps_a, eps_g)`：只画指定冲击的 IRF。
- `periods = 整数`：>0 时用该长度模拟算**经验矩**而非理论矩，默认 0。
- `drop = 整数`：算模拟矩前丢弃的预热期，默认 100。
- `pruning`：迭代模拟时丢弃高阶项（2 阶及以上建议开，防爆炸路径）。
- `hp_filter = 1600` / `bandpass_filter` / `one_sided_hp_filter`：算矩前滤波。
- `nograph`、`nodisplay`、`graph_format = pdf`：控制画图。
- `nomoments`、`nocorr`、`nodecomposition`、`nofunctions`：抑制打印块。
- `loglinear`：对**所有**变量取对数（稳态须严格为正），矩/IRF 解释为对数偏离。
- `conditional_variance_decomposition = [1 4 8]`：指定期限的条件方差分解。
- `replic`、`simul_replic`、`solve_algo`、`qz_criterium`：高级控制。

## 结果存放（按需告诉用户，可用 MCP 读取）

- `oo_.dr`：决策规则。
- `oo_.mean`、`oo_.var`、`oo_.autocorr`、`oo_.gamma_y`：矩。
- `oo_.irfs.<变量>_<冲击>`：IRF（如 `oo_.irfs.y_eps_a`）。
- `oo_.endo_simul`、`oo_.exo_simul`：模拟序列（当 `periods > 0`）。
- `oo_.variance_decomposition` / `oo_.conditional_variance_decomposition`。

**画发表级 IRF**：自带画图粗糙。要顶刊级图（多情景/多冲击对比、矢量 PDF）→ `stoch_simul`
加 `nograph` 省时间，再用本 skill 自带的 `references/plot_irfs_pub.m` 从 `oo_.irfs` 出图，
详见 `references/publication-plots.md`。

## 规范示例——基础 RBC（含 Pfeifer 写法）

要点：内生 AR 过程（`z` 内生、`eps_z` 外生）、解析 `steady_state_model`、`[name=]` 标注、
`log_*` 辅助变量、`resid;steady;check;` 流程。完整可套用骨架见 `references/templates.md`。

```dynare
var y ${y}$ (long_name='output')  c ${c}$ (long_name='consumption')
    k ${k}$ (long_name='capital')  l ${l}$ (long_name='labor')
    invest ${i}$ (long_name='investment')  z ${z}$ (long_name='TFP')
    log_y log_c log_k log_l ;
varexo eps_z ${\varepsilon_z}$ (long_name='TFP shock') ;
parameters betta alppha delta rhoz psi sigma ;

alppha = 0.33;  betta = 0.99;  delta = 0.025;  rhoz = 0.95;  sigma = 1;

model;
[name='Euler equation']
c^(-sigma) = betta*c(+1)^(-sigma)*(alppha*exp(z(+1))*k^(alppha-1)*l(+1)^(1-alppha) + 1 - delta);
[name='labor FOC']
psi*c^sigma/(1-l) = (1-alppha)*exp(z)*k(-1)^alppha*l^(-alppha);
[name='law of motion of capital']
k = invest + (1-delta)*k(-1);
[name='resource constraint']
y = c + invest;
[name='production function']
y = exp(z)*k(-1)^alppha*l^(1-alppha);
[name='TFP process']
z = rhoz*z(-1) + eps_z;
[name='log output'] log_y = log(y);
[name='log consumption'] log_c = log(c);
[name='log capital'] log_k = log(k);
[name='log labor'] log_l = log(l);
end;

steady_state_model;
    z = 0;
    // 固定稳态劳动 l=1/3，反解 psi（校准目标在稳态里反解）
    l = 1/3;
    kl = ((1/betta - 1 + delta)/alppha)^(1/(alppha-1));  // 资本-劳动比（临时变量）
    k = kl*l;
    invest = delta*k;
    y = kl^alppha*l;
    c = y - invest;
    psi = (1-alppha)*kl^alppha*(1-l)/c^sigma;
    log_y = log(y); log_c = log(c); log_k = log(k); log_l = log(l);
end;

resid;
steady;
check;

shocks;
    var eps_z; stderr 0.007;
end;

stoch_simul(order=1, irf=40, hp_filter=1600) log_y log_c log_k log_l z;
```

## 非线性优先与对数偏离报告（R8）

默认写原始非线性方程组（见 SKILL.md R8），交给 `stoch_simul` 做摄动。要让 IRF/矩以
**对数偏离**呈现：

- 首选：加辅助变量 `log_y = log(y);` 并对 `log_*` 跑 `stoch_simul`（模板已内置）；
- 或 `stoch_simul(loglinear)`：对**所有**变量取对数（稳态须严格为正）；
- 或声明 `var(log) y;`：Dynare 自动建 `LOG_y` 辅助变量并替换。
- AR 过程的非线性写法：`log(A) = rho_a*log(A(-1)) + eps_a;`。

写线性化模型（命中 R8 例外）时用 `model(linear);` 声明。

## 常见情形

- **非平稳模型**：用 `trend_var(growth_factor=gA) A;` 声明趋势，并在趋势变量上给
  deflator（`var(deflator=A) y;`），Dynare 内部平稳化；通常直接写成已平稳化形式更省事。
  参考 DSGE_mod 的 `Aguiar_Gopinath_2007`（趋势增长、从去趋势变量还原非平稳变量）。
- **混合确定性与随机冲击**（如预先宣告的未来变化）：用 `varexo_det` 声明确定性路径 +
  完全预见写法的 `shocks` 块，然后 `stoch_simul(irf=0); forecast;`。
- **histval 作模拟起点**：`periods>0` 时 `histval` 块设定模拟起始状态（不影响 IRF）。
- **三阶 + 非对称创新**：参考 DSGE_mod 的 `Andreasen_2012`、`Born_Pfeifer_2014`。

---

# 手册增补（Dynare 7.1 §4.13）

## `stoch_simul` 重要选项补全

- `order = 1|2|3`（默认 2）；**≥3 自动 `k_order_solver`，且只有模拟矩**（须给 `periods`）。
- `pruning`：二阶起强烈建议开，防爆炸路径；开后理论矩按剪枝状态空间算（Andreasen et al. 2018），
  否则二阶只是基于线性项的二阶近似矩（Kim et al. 2008）。
- `conditional_variance_decomposition = [1 4 8]`：条件方差分解（仅 `order<3` 且无 pruning；
  `periods=0` 理论矩时才做）。无条件分解在请求理论矩且未设 `nodecomposition` 时自动做，存
  `oo_.variance_decomposition`；有测量误差时另有 `oo_.variance_decomposition_ME`。
- `relative_irf`：一阶下 = 对「1 单位（=100%）冲击」的响应×100，便于解释百分比模型。
- `loglinear`：对**所有**变量取对数（稳态须严格正），矩/IRF/决策规则都按对数变量。
- `contemporaneous_correlation` → `oo_.contemporaneous_correlation`；`spectral_density` →
  `oo_.SpectralDensity`；`partial_information`：不完全信息解（agent 只观测 `varobs` 子集）。
- `dr = default|cycle_reduction|logarithmic_reduction|aim`：大模型用 `cycle_reduction` 更快。
- `irf_shocks=(eps_a,eps_g)` 只画指定冲击；`irf_plot_threshold`、`ar=`（自相关阶，默认 5）、
  `replic`、`simul_replic`、`graph_format=pdf|eps|fig|none`。

## 决策规则结构 `oo_.dr`（报告/核对用）

一阶 `y_t = y^s + A·y^h_{t-1} + B·u_t`：
- `oo_.dr.ys` 稳态（声明序）；`oo_.dr.ghx`=A（行=内生 DR 序、列=状态 DR 序）；`oo_.dr.ghu`=B。
二阶另有 `ghs2`(Δ²风险修正)、`ghxx`、`ghuu`、`ghxu`；三阶 `g_0..g_3`（折叠存储、对称元只存一次，
解码时非对角项需×2/×6，详见手册）。

## 变量四分类与两套排序（排 BK 故障关键）

- 四类：纯后向 `M_.npred`、纯前向 `M_.nfwrd`、混合 `M_.nboth`、纯静态 `M_.nstatic`，
  四者之和 = `M_.endo_nbr`。状态变量 = 纯后向+混合，共 `M_.nspred`。
- 两套序：**声明序**（`M_.endo_names`）与 **DR 序**（静态→纯后向→混合→纯前向，组内按声明序）。
  决策规则元素一律 DR 序。映射：`oo_.dr.order_var`（DR→声明）、`oo_.dr.inv_order_var`（反）。
- BK 必要条件：模 >1 的特征值数 = 前瞻变量数（外加一个秩条件）。`check` 存 `oo_.dr.eigval`。
  不满足时先用 `model_info;` 核对哪些被当状态/跳跃（见 debugging.md）。

## 非平稳模型（趋势）声明法

```dynare
trend_var(growth_factor=gA) A;          // 乘法趋势变量（先于引用它的 var）
var(deflator=A) y i;                    // y、i 跟随趋势 A，Dynare 内部平稳化
// 加法趋势用 log_trend_var / log_deflator
var(log) c;                             // 造 LOG_c=log(c)，模型里 c 被 exp(LOG_c) 替换
```
参考 DSGE_mod `Aguiar_Gopinath_2007`。通常直接写成已平稳化形式更省事。
报告对数偏离的三法（择一）：辅助 `log_y=log(y)` 跑 `log_*`（模板内置）/ `stoch_simul(loglinear)` /
声明 `var(log) y;`。
