# 异质性 / 异质主体（HANK / Krusell-Smith）

> **何时读**：任务含"异质主体""HANK""Krusell-Smith""连续分布的家庭/财富分布影响个体选择""一/两
> 资产 HANK""序列空间雅可比(SSJ)"，命令族 `heterogeneity_dimension` / `var(heterogeneity=...)` /
> `heterogeneous`/`aggregate` 块 / `heterogeneity_*` 命令。**本文件回答**：Dynare 7.0 起新增的异质性
> 框架怎么组织、声明与块结构、求解/模拟命令、稳态从哪来。**重要**：这是 Dynare **较新且仍在演进**的
> 功能；动笔前**务必对照 `examples/` 的 `krusell_smith_1998.mod`、`hank_one_asset.mod`、`hank_two_assets.mod`
> 与手册 §4.26 核对块内精确语法**，不要凭记忆硬写块内细节。

Dynare 7.0 引入统一的**异质性（heterogeneity）**框架，处理"一个连续分布的主体、其分布影响个体选择、
且与总量动态双向耦合"的模型（HANK 是其特例）。动态解法融合 Bhandari-Bourany-Evans-Golosov (2023) 与
Auclert-Bardóczy-Rognlie-Straub (2021, 序列空间雅可比) 的思想。模型分两层：**异质（个体）层** 与
**总量（aggregate）层**，用聚合算子 `SUM()` 把个体加总到总量。

## 核心声明与算子

- `heterogeneity_dimension`：声明一个异质性维度（如按财富/生产率离散化的家庭分布）。
- `var(heterogeneity=NAME) ...;` / `varexo(heterogeneity=NAME) ...;`：声明属于该维度的**异质变量/冲击**
  （每个体一份，随分布变化）。
- `model(heterogeneity=NAME); ... end;`：**异质主体模型块**，写个体的最优化一阶条件/预算约束（如家庭的
  欧拉方程、资产积累），方程在该维度上对每个体成立。
- `shocks(heterogeneity=NAME); ... end;`：**异质冲击块**（个体特异冲击的分布/离散化）。
- `SUM(expr)`：**聚合算子**，把异质表达式按分布加总成总量（如 `SUM(a)` = 总资产）。

总量层用**普通的 `var/varexo/model`**（不带 heterogeneity=），写总量恒等式/市场出清/政策规则，并通过
`SUM(...)` 引用个体加总。手册 §4.26 把声明拆成：异质性维度 → 异质变量声明 → 异质主体模型块 →
异质冲击块 → 总量变量声明 → 总量冲击块 → 总量模型块。

```dynare
// —— 概念骨架（精确块内语法请对照 example mods）——
heterogeneity_dimension hh;                 // 家庭维度

var(heterogeneity=hh) a c;                  // 个体资产、消费（随分布）
varexo(heterogeneity=hh) e;                 // 个体特异生产率冲击

parameters bet gam r_ss ...;

model(heterogeneity=hh);                    // 个体问题（每个体成立）
   c^(-gam) = bet*(1+r)*c(+1)^(-gam);       // 欧拉方程
   a = (1+r)*a(-1) + w*e - c;               // 个体预算/资产积累
end;

var K r w;                                  // 总量变量
model;                                      // 总量层
   K = SUM(a);                              // 总资本 = 个体资产加总
   r = alpha*(K(-1))^(alpha-1) - delta;     // 要素价格
   w = (1-alpha)*(K(-1))^alpha;
end;
```

## 求解与模拟命令

异质模型的稳态是**个体策略函数 + 离散化冲击 + 平稳分布**，两条路获取：

1. **载入外部稳态** `heterogeneity_load_steady_state`：从 MAT 文件读入预先算好的策略函数/离散化/平稳分布
   （例如用 SSJ/外部代码算的稳态）。
   ```dynare
   heterogeneity_load_steady_state(... 'steady_state.mat' ...);
   ```
2. **Dynare 内算稳态** `heterogeneity_compute_steady_state`：用**时间迭代（time iteration）**在 Dynare 内
   数值求个体策略与平稳分布（可带参数校准，如校准到某目标资产/利率）。
   ```dynare
   heterogeneity_compute_steady_state(... 校准选项 ...);
   ```

得到稳态后：
- `heterogeneity_solve`：求解**总量动态**（围绕稳态的线性化/序列空间雅可比）。
- `heterogeneity_simulate`：算 **IRF 与随机模拟**，支持**未预期冲击**与**预期到的 news 冲击序列**。
- 还有若干 **helper functions**（手册 §4.26.2.3）辅助构造/检视分布与策略。

```dynare
heterogeneity_compute_steady_state(...);
heterogeneity_solve;
heterogeneity_simulate(...);     // IRF / 随机模拟；可给 news 冲击序列
```

## 自带示例（强烈建议照抄起步）

Dynare `examples/` 提供（与 shade-econ/sequence-jacobian 同模型）：
- `krusell_smith_1998.mod`——Krusell-Smith (1998)，演示 `heterogeneity_compute_steady_state` 数值稳态 + 模拟；
- `hank_one_asset.mod`——单资产 HANK，演示 `heterogeneity_load_steady_state` 载入稳态 + `heterogeneity_solve`
  + `heterogeneity_simulate` 随机模拟；另有用 `compute_steady_state`（含参数校准）的变体；
- `hank_two_assets.mod`——双资产（流动/非流动）HANK，演示载入稳态 + news 冲击模拟，及多参数校准变体。

## 实操要点 / 取舍

- **稳态是难点**：能用外部成熟代码（SSJ 等）算好稳态再 `load`，通常比纯靠 Dynare `compute` 稳。两条路按
  模型复杂度选。
- 个体层只写**个体一阶条件/约束**，总量耦合一律经 `SUM()`；别在个体块里手写加总。
- 该框架新、API 仍可能调整：**以你所装 Dynare 版本的 example mods + 手册 §4.26 为准**，本文件给的是框架与
  命令清单，块内精确关键字以官方示例为权威。
- 与"含几类异质家庭"的有限异质（TANK/多代理）不同：这里是**连续分布**、分布本身是状态。少数离散类型用
  普通 .mod + 宏处理器循环即可（见 macro-processor.md），不必动用本框架。

## MATLAB MCP 运行注意

- 先确认 Dynare ≥ 7.0 且含 heterogeneity 组件（预处理器为 heterogeneity-aware 版本）。
- 调试：先跑通自带 example（krusell_smith_1998 / hank_one_asset）确认环境，再改成自己的模型。
- 稳态载入时核对 MAT 文件字段（策略函数、冲击离散化、平稳分布）与模型维度一致。

## 常见报错与陷阱（Dynare 7.1，实测）

**`heterogeneity_solve` 崩在 `eq` 未定义 / `process_jacobian_block`——病因是 varexo 声明顺序**

总量层若有**只带滞后出现**的 varexo（典型：泰勒规则带实施滞后 `rstar(-1)`，或 `pi(-1)` 之外
再引 `g(-1)`），Dynare 会为它建一条辅助方程 `aux(+1) = rstar`，该辅助方程的行号 **大于**
`M_.orig_endo_nbr`。`heterogeneity_solve` 内部用 `find()` 遍历雅可比块，而 MATLAB 的 `find()`
**按列优先**返回——若这个 lag-only varexo 在 `varexo` 块里**声明在前**，它的辅助行就排在常规
方程项之前被先遇到，循环里 `eq` 还没被赋值就被引用 → 崩溃。

**修法：把任何"只带滞后出现"的 varexo 声明在 `varexo` 块的最后。** 这样常规方程项先被遍历、
先给 `eq` 赋值，辅助行随后才出现。官方示例 `hank_one_asset_steady_state.mod` 正是这么做的
（`varexo G markup rstar;`，`rstar` 殿后）。

```dynare
// ✅ 正确：lag-only 的 rstar 殿后
varexo G TR markup rstar;     // rstar(-1) 进泰勒规则 → 必须最后声明
// ❌ 触发崩溃：varexo rstar G TR markup;
```

> 这是 heterogeneity 框架特有的表现。**非异质**模型里同样的 lag-only varexo 会在 `disp_dr` 阶段
> 触发另一个 `subst_auxvar` 崩溃（"索引生成 2 个值"）——那种情形改用 AR(1) 内生变量替代 lagged
> varexo，见 `references/known-issues.md`「非异质模型 disp_dr / subst_auxvar 崩」。

**稳态：纯 varexo 在稳态取 0**

`G`、`TR` 等作为纯 varexo（非 AR 内生过程）时，稳态值就是 0。政府预算等稳态方程里**不要**把它们
当正值代入：若 `Tax = r*B + G + TR`，稳态应为 `Tax_ss = r_ss*B`（`G=TR=0`），写成
`r_ss*B + G_ss + TR_ss` 会让稳态残差不为零。

## IRF 取数（heterogeneity_solve 后）

异质性框架的 IRF **不在 `oo_.irfs`**（那是 `stoch_simul` 的产物）。`heterogeneity_solve` 把总量
动态存成**序列空间雅可比** `oo_.heterogeneity.dr`：

- `oo_.heterogeneity.dr.G.<var>.<shock>` 是一个 **T×T 矩阵**（T = `truncation_horizon`），第 `(t,s)`
  元 = 变量 `var` 在 `t` 期对"`s` 期发生一单位 `shock`"的响应。
- **对一次性冲击（t=1 发生）的 IRF = 该矩阵的第一列**：`oo_.heterogeneity.dr.G.Y.G(:,1)`
  就是 Y 对单位 G 冲击的脉冲响应路径。
- 这是**每单位冲击**的响应；要对应某个冲击大小（如 1%），乘以冲击幅度即可。
- 没单独存的总量（如总消费 C）走 Walras 恒等式从已有变量反推（如商品市场 `C = Y - G`）。

```matlab
% Y 对单位 G 冲击的 IRF（前 20 期），再缩放到 1% 冲击
irf_Y_G = oo_.heterogeneity.dr.G.Y.G(1:20, 1) * 0.01;
```

要和 RANK（`oo_.irfs`）并排对比、或反复改图，**先把 `oo_` 冻存再分析**，别每改一次图就重跑
30 秒的 HANK 求解——见 `references/matlab-workflow.md`。

参考：Dynare 7.0 发布说明（heterogeneity 框架）；手册 §4.26；example mods（与 SSJ 同模型）；
Auclert-Bardóczy-Rognlie-Straub (2021)、Bhandari-Bourany-Evans-Golosov (2023)。

---

# 手册增补（Dynare 7.0+ §4.26 Heterogeneity）

- 声明：`heterogeneity_dimension`；`var/varexo/model/shocks(heterogeneity=NAME)`；聚合算子 `SUM()`。
- 块结构（§4.26.1）：异质性维度 → 异质变量声明 → 异质主体模型块 → 异质冲击块 → 总量变量声明 →
  总量冲击块 → 总量模型块。
- 求解（§4.26.2）：`heterogeneity_load_steady_state`（载入）/ `heterogeneity_compute_steady_state`（时间迭代内算，
  可校准）→ helper functions → `heterogeneity_solve`（总量动态）→ `heterogeneity_simulate`（IRF/随机模拟，
  含 news 冲击）。
- 示例：`krusell_smith_1998.mod`、`hank_one_asset.mod`、`hank_two_assets.mod`（= shade-econ SSJ 同模型）。
- 解法：Bhandari et al. (2023) + Auclert et al. (2021, 序列空间雅可比)。
- **块内精确语法以官方 example mods + 手册 §4.26 为权威**（功能新、仍演进）。
