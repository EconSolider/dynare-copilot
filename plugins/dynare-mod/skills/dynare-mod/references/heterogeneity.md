# 异质性 / 异质主体（HANK / Krusell-Smith）

> **何时读**：任务含"异质主体""HANK""Krusell-Smith""连续分布的家庭/财富分布影响个体选择""一/两
> 资产 HANK""序列空间雅可比(SSJ)"，命令族 `heterogeneity_dimension` / `var(heterogeneity=...)` /
> `heterogeneous`/`aggregate` 块 / `heterogeneity_*` 命令。**本文件回答**：Dynare 7.0 起新增的异质性
> 框架怎么组织、声明与块结构、求解/模拟命令、稳态从哪来。**重要**：这是 Dynare **较新且仍在演进**的
> 功能；动笔前**务必对照 `examples/` 的 `krusell_smith.mod`、`hank_one_asset.mod`、`hank_two_assets.mod`
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
- `krusell_smith.mod`——Krusell-Smith (1998)，演示 `heterogeneity_compute_steady_state` 数值稳态 + 模拟；
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
- 调试：先跑通自带 example（krusell_smith / hank_one_asset）确认环境，再改成自己的模型。
- 稳态载入时核对 MAT 文件字段（策略函数、冲击离散化、平稳分布）与模型维度一致。

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
- 示例：`krusell_smith.mod`、`hank_one_asset.mod`、`hank_two_assets.mod`（= shade-econ SSJ 同模型）。
- 解法：Bhandari et al. (2023) + Auclert et al. (2021, 序列空间雅可比)。
- **块内精确语法以官方 example mods + 手册 §4.26 为权威**（功能新、仍演进）。
