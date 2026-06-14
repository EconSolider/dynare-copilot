# 矩方法估计（GMM / SMM / IRF 匹配）

> **何时读**：任务含矩方法/GMM/SMM/广义矩/模拟矩/IRF 匹配/"匹配矩或脉冲响应来校准参数"，命令族
> `method_of_moments`。**本文件回答**：matched_moments / matched_irfs 块写法、`method_of_moments`
> 选项分组、权重矩阵、三种 `mom_method` 的取舍、MCP 运行注意。**配套必读**：estimation.md（共用
> `estimated_params` 行语法）、steady-state.md。

`method_of_moments` 用矩条件而非似然来估计参数：让**模型隐含矩**逼近**数据矩**（或经验 IRF）。
三种方法由 `mom_method` 选：

- **GMM**：用模型的**解析（摄动）矩**，速度快，要求 `order` 阶摄动能算出所需矩；
- **SMM**（模拟矩）：从模型**模拟样本**算矩，适合解析矩难求或高阶/强非线性；
- **IRF_MATCHING**：让模型 IRF 逼近外部给定（常来自 SVAR）的经验脉冲响应。

顺序：（GMM/SMM）`matched_moments` 块 → `estimated_params` → `method_of_moments(mom_method=...)`；
（IRF 匹配）`matched_irfs`(+`matched_irfs_weights`) 块 → `estimated_params` → `method_of_moments(mom_method=irf_matching)`。
**稳态高效且正确**同样关键——优化器每个抽样点重算稳态，强烈建议写 `steady_state_model`（见 steady-state.md）。

## `matched_moments` 块（GMM/SMM 目标矩）

只支持**线性乘积矩**：变量名 + 滞后阶 + 幂次，三组向量一一对应。

```dynare
matched_moments;
   // 各行：被取矩的变量(可带滞后) ; 滞后阶向量 ; 幂次向量
   c;            // E[c]      一阶矩（均值）
   y y;          // E[y^2]    方差（中心化由 prefilter/中心矩选项控制）
   c y;          // E[c*y]    协方差
   y y(-1);      // E[y_t*y_{t-1}]  一阶自协方差
   gy gy gy;     // E[gy^3]   三阶矩（SMM 可用，GMM 视 order 而定）
end;
```

- 每行第一段是要相乘的变量（含可选 `(-k)` 滞后），Dynare 自动按声明拆成 变量/滞后/幂次 三组。
- **只有乘积矩**：`xx`=E[x²]（方差）、`xy`=E[x·y]（协方差）。**直接匹配相关系数不支持**——分别匹配两个方差和协方差来间接锁定。
- 矩的**条数 ≥ 待估参数数**（恰好识别取等，过度识别用最优权重）。

## `estimated_params`（待估参数，行语法见 estimation.md）

矩方法用**极大似然式**行（无先验）：`名字, 初值[, 下界, 上界];`；也支持**带先验的"惩罚化"矩方法**
（贝叶斯式行，先验把矩目标拉向先验）：

```dynare
estimated_params;
   rho,          0.8,   0,  0.999;          // ML 式：仅初值+界
   stderr eps_z, 0.01,  0,  ;
   // 惩罚化：再加 先验形状/均值/标准差，则把先验作为额外"矩条件"
   // alppha,    0.3,  , , beta_pdf, 0.30, 0.05;
end;
```

## `method_of_moments` 命令与选项分组

手册把选项分成：**必填 / 通用 / SMM 专属 / GMM 专属 / IRF 匹配专属 / 一般 / 数据 / 优化 / 贝叶斯 / 数值算法**。

```dynare
method_of_moments(
   mom_method = SMM,            // 必填：GMM | SMM | IRF_MATCHING
   datafile   = 'data.csv',     // GMM/SMM 必填（IRF 匹配用 matched_irfs 块，不需要）
   order      = 2,              // 摄动阶（GMM 解析矩的阶；SMM 模拟所用阶）
   // ── 权重矩阵 ──
   weighting_matrix = ['DIAGONAL','OPTIMAL'],  // 可给序列：先对角再最优，分步迭代
   weighting_matrix_scaling_factor = 1,
   bartlett_kernel_lag = 20,    // HAC（Newey-West）核滞后，估最优权重用
   // ── SMM 专属 ──
   simulation_multiple = 5,     // 模拟样本长度 = 数据长度 × 此倍数
   burnin = 500,                // 模拟丢弃期
   // ── 优化 ──
   mode_compute = 13,           // 矩方法常用 13(lsqnonlin)/4/5
   additional_optimizer_steps = [4],
   // ── 输出/显示 ──
   nodisplay, graph_format = eps
);
```

要点：
- `mom_method` 必填；GMM/SMM 必给 `datafile`（IRF 匹配改用 `matched_irfs` 块提供经验响应）。
- `order`：GMM 下决定解析矩能算到几阶（≥3 阶矩通常需 SMM）；SMM 下是模拟所用摄动阶。
- `weighting_matrix`：`IDENTITY`/`DIAGONAL`/`OPTIMAL`/自定义 mat 文件名；可传**序列**做两步/迭代 GMM（先 DIAGONAL 起步，再 OPTIMAL 高效）。
- `bartlett_kernel_lag`：估计最优权重（长期方差，HAC）时的核滞后。
- SMM 专属：`simulation_multiple`、`burnin`、`seed`/`bounded_shock_support` 等。
- 共用 estimation 的优化器选项（`mode_compute`、`additional_optimizer_steps`、`optim`）与数据选项（`first_obs`、`nobs`、`prefilter`、`logdata`）。`loglinear` 仅在 model 块也加 `loglinear` 时才与此处的 `logdata` 配套（一般不建议全模型对数化，宁可写辅助变量）。

## IRF 匹配（mom_method=irf_matching）

用 `matched_irfs` 块给经验 IRF 目标（变量、冲击、horizon、值），可选 `matched_irfs_weights` 给权重：

```dynare
matched_irfs;
   var y;   varexo eps_r;  periods 1:8;  values (empirical_irf_y);   // 列向量
   var pi;  varexo eps_r;  periods 1:8;  values (empirical_irf_pi);
end;
matched_irfs_weights;
   y, eps_r, (W_y);     // 对应 horizon 的权重（默认单位）
end;
method_of_moments(mom_method = irf_matching, order = 1, mode_compute = 13);
```

## 输出（oo_.mom）

估计结果进 `oo_.mom`：参数估计、（最优权重下的）标准误、J 统计量与过度识别检验、模型矩 vs 数据矩对照、
权重矩阵等。跑完用 MCP 读 `oo_.mom` 核对。

## 三法取舍

| 方法 | 矩来源 | 适用 | 注意 |
|------|--------|------|------|
| GMM | 解析摄动矩 | 一/二阶矩、要快 | 高阶矩受 `order` 限制 |
| SMM | 模拟样本矩 | 高阶/强非线性/解析矩难求 | 慢；`simulation_multiple` 越大越稳但越慢 |
| IRF 匹配 | 模型 vs 经验 IRF | 有可信 SVAR 经验响应时 | 需先估出经验 IRF 与其权重 |

## MATLAB MCP 运行注意

- GMM/SMM 读外部数据——确认数据文件在工作目录、列名匹配（同 estimation）。
- SMM 较慢：调试先用小 `simulation_multiple`、少量 `additional_optimizer_steps` 跑通设定，再放大。
- 两步/迭代 GMM：先用 `weighting_matrix=['DIAGONAL','OPTIMAL']` 让最优权重基于第一步估计。
- 跑完读 `oo_.mom`（参数、标准误、J 检验、模型矩对数据矩）。

参考 DSGE_mod：`Born_Pfeifer_2014`（GMM/SMM 经典示例，含 recalibration/estimation 开关）、
`RBC_state_dependent_GIRF`、以及 Dynare `examples/` 下 `method_of_moments` 示例（`AnScho_GMM`/`RBC_MoM` 等）。

---

## 课程示例（Pfeifer Dynare Course，本地可跑，**首选参照**）

> 路径 `references/examples-code/Dynare_Course/Chapter_09_Method_of_Moments/`。三法各一个最小可跑例子，
> 命令选项写全（带逐行注释），是抄 `method_of_moments(...)` 选项的最佳模板。
> `grep -i "mom_method\|method_of_moments\|irf_matching" references/catalog-code.csv`。
> 共享设定在 `RBC_MoM_common.inc`（`@#include` 引入）、稳态辅助 `RBC_MoM_steady_helper.m`、数据 `RBC_Data_2.mat`——都已随同复制。

| 文件 | 方法 | 关键选项 |
| ---- | ---- | -------- |
| `RBC_MoM_GMM_order2.mod` | GMM | `mom_method=GMM, order=2, mode_compute=4, additional_optimizer_steps=[13]`、`matched_moments` |
| `RBC_MoM_SMM_order2.mod` | SMM | `mom_method=SMM, order=2`（模拟矩；同模型同矩，只换方法对照 GMM） |
| `rbc_irf_matching.mod` | IRF 匹配 | `mom_method=irf_matching`、经验 IRF 当"数据"、对角权重=IRF 方差倒数、**用 AR 根重参数化 AR(2)** 以约束在稳定域、`estimated_params(overwrite)` |

GMM 与 SMM 两文件刻意共用 `RBC_MoM_common.inc` 与同一组 `matched_moments`，**只改 `mom_method`**——
想看"解析矩 vs 模拟矩"在写法和结果上差多少，直接 diff 这两个文件即可。`rbc_irf_matching.mod` 的两个进阶技巧
（经验 IRF 作数据、用特征根而非系数估 AR(2) 以保稳定）手册不会手把手教，遇到 IRF 匹配/估持续性参数时值得照搬。

---

# 手册增补（Dynare 7.1 §4.17 Estimation based on moments）

- 命令子节：必填选项 / 通用 / SMM 专属 / GMM 专属 / IRF 匹配专属 / 一般 / 数据 / 优化 / 贝叶斯 / 数值算法 / 专属输出。
- `matched_moments` 块只接受**线性乘积矩**（方差=`xx`、协方差=`xy`）；相关系数需经方差+协方差间接匹配。
- 惩罚化矩方法：`estimated_params` 用贝叶斯式行（带先验）即把先验当额外矩条件（penalized MoM）。
- 输出在 `oo_.mom`。
