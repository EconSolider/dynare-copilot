# 马尔可夫切换 SBVAR（MS-SBVAR）

> **何时读**：任务含"区制切换/Markov switching""结构 BVAR（Sims-Zha）""时变波动或系数的 SVAR
> 估计/IRF/预测""SWZ"，命令族 `markov_switching` / `svar` / `sbvar` / `ms_*`。**本文件回答**：
> MS-SBVAR 这一**独立于 DSGE** 的命令族怎么组织、各 `ms_*` 子命令用途与关键选项、声明顺序的硬规则。
> **注意**：这是 Sims-Waggoner-Zha 框架的 SBVAR，**不是** .mod 里的 DSGE；Dynare 的区制切换实现面向
> SBVAR（MS-DSGE 请用外部 RISE 工具箱）。

MS-SBVAR 估计一个**结构 BVAR**，其截距/系数/冲击方差可随**马尔可夫区制**切换（Sims-Waggoner-Zha）。
整套命令自成体系，与 stoch_simul/estimation 的 DSGE 流程并行。典型骨架：

```dynare
var y pi r;                 // 内生变量（VAR 的被解释量）
varexo e_y e_pi e_r;        // 形式上的冲击声明（SBVAR 用结构识别）

// 1) 先声明结构识别——必须在 sbvar / ms_sbvar 之前！
svar_identification;
   exclusion lag 0;
   restriction ...;         // 按方程/滞后排除或线性约束（SWZ 识别）
end;

// 2) 声明马尔可夫链（可多条，分别控制系数/方差）
markov_switching(chain=1, number_of_regimes=2, duration=2.5,
                 restrictions=[[1,2,0.1],[2,1,0.1]]);
markov_switching(chain=2, number_of_regimes=3, duration=[2,4,4]);

// 3) 指定各链控制 SBVAR 的哪部分
svar(coefficients, chain=1, equations=[1:3]);   // 链1 切换系数
svar(variances,    chain=2);                     // 链2 切换冲击方差

// 4) 估计 → 诊断 → IRF/预测
ms_estimation(file_tag='m1', mh_replic=10000, drop=1000);
ms_compute_probabilities(file_tag='m1');
ms_compute_mdd(file_tag='m1');
ms_irf(file_tag='m1', horizon=24);
ms_forecast(file_tag='m1', forecast=12);
ms_variance_decomposition(file_tag='m1', horizon=24);
```

## `markov_switching`——声明一条马尔可夫链

```dynare
markov_switching(chain = 1,
                 number_of_regimes = 3,
                 duration = 2.5,                       // 标量或每区制向量，平均区制时长
                 restrictions = [[1,3,0],[3,1,0]]);    // 转移约束
```
- `chain`：链编号（可多条链，分别管系数/方差/常数，互相独立）。
- `number_of_regimes`、`duration`（平均时长，转成转移概率的先验）。
- `restrictions=[[当前区制, 下期区制, 转移概率], ...]`：固定某些转移概率；若对某区制给齐所有转移，须和为 1，
  否则给的部分须 < 1。
- MS-DSGE 才用的 `parameter=[...]`、`number_of_lags=` 在 SBVAR 下不用。

## `svar` / `sbvar`——把链挂到 SBVAR 的各部分

`svar(...)` 指定哪条链切换哪部分、作用于哪些方程：
- `svar(coefficients, chain=k[, equations=...])`：滞后系数随链 k 切换；
- `svar(variances, chain=k[, equations=...])`：结构冲击方差随链 k 切换；
- `svar(constants, chain=k[, equations=...])`：截距随链 k 切换。

`svar_identification` 块（**必须在 sbvar/ms_sbvar 之前声明**）给 SWZ 结构识别（按滞后/方程的 exclusion 与
linear restriction）。

## `ms_*` 子命令（都用 `file_tag`/`output_file_tag` 串联同一次运行）

| 命令 | 作用 | 关键选项 |
|------|------|----------|
| `ms_estimation` | 估计 SBVAR + 区制（MCMC） | `file_tag`、`output_file_tag`、`mh_replic`(默认1万)、`drop`(burn-in)、`thinning_factor`、`adaptive_mh_draws`(默认3万调优)、`save_draws` |
| `ms_simulation` | 后验抽样模拟 | 同上 file_tag 串联 |
| `ms_compute_mdd` | 计算边际数据密度 | 输出 Müller / Bridged log-MDD 进 `oo_.ms`（模型比较用） |
| `ms_compute_probabilities` | 滤波/平滑区制概率 | 画各期处于各区制的概率 |
| `ms_irf` | 区制相关 IRF | `horizon`(默认?)、`filtered_probabilities`/`regime=`/`regimes`(三选一)、`percentiles`(默认[.16 .5 .84])、`draws`、`parameter_uncertainty` |
| `ms_forecast` | 预测 | `forecast`(horizon，默认12)、`regime`/`regimes`/`filtered_probabilities`、`percentiles` |
| `ms_variance_decomposition` | 方差分解 | `horizon`、`filtered_probabilities`/`regime`、`percentiles` |

公共约定：
- `file_tag` 串起同一模型的多次 `ms_*` 调用；`output_file_tag` 给输出文件名。`.eps` 图在 `<tag>/Output/`，
  数据在 `<tag>/`。
- `ms_irf`/`ms_forecast`/`ms_variance_decomposition` 的区制视角三选一：`filtered_probabilities`（用样末滤波概率）
  / `regime=`（固定某区制）/ `regimes`（遍历所有区制）。
- `save_draws` 把 A0/Aplus/Q/Zeta 各抽样写 `draws_<tag>.out`，配 `load_flat_file.m` 载回 MATLAB。

## 与 DSGE 的边界（重要）

- 这套命令**不读 model 块的 DSGE 方程**——它是独立的 SBVAR 估计器，`var/varexo` 只是声明 VAR 的变量与维度。
- Dynare 原生**不支持 MS-DSGE**（区制切换的结构 DSGE）；需要 MS-DSGE 请用 Junior Maih 的 **RISE** 工具箱。
- `svar_identification` 必须在 `sbvar`/`ms_sbvar` 语句**之前**，否则预处理报错。

## MATLAB MCP 运行注意

- MS-SBVAR 走专门的 mex（switch_dw）；确认 Dynare 安装含该组件、数据文件就位。
- 用统一 `file_tag` 贯穿 estimation→probabilities→mdd→irf→forecast，避免找不到中间结果。
- 估计慢：先小 `mh_replic` 跑通设定，再放大；读 `oo_.ms`（含 MDD、区制概率等）。

参考：Dynare `examples/`、`tests/ms-sbvar` 下的 MS-SBVAR 示例；Sims-Waggoner-Zha 原始文献与 Dynare 旧版手册
§"Markov-switching SBVAR"。

---

# 手册增补（Dynare 7.1 §4.24 Markov-switching SBVAR）

- `markov_switching(chain=, number_of_regimes=, duration=, restrictions=[[cur,next,prob],...])`；可多条链。
- `svar(coefficients|variances|constants, chain=, equations=)` 把链挂到 SBVAR 各部分；
  `svar_identification` 块（SWZ 识别）**必须在 sbvar/ms_sbvar 之前**。
- `ms_estimation`/`ms_simulation`/`ms_compute_mdd`/`ms_compute_probabilities`/`ms_irf`/`ms_forecast`/
  `ms_variance_decomposition`，用 `file_tag`/`output_file_tag` 串联；MDD 进 `oo_.ms`。
- IRF/预测/方差分解的区制视角：`filtered_probabilities` | `regime=` | `regimes`（三选一）。
- Dynare 仅支持 MS-SBVAR，不支持 MS-DSGE（后者用 RISE）。
