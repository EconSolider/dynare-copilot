# 冲击分解（Shock Decomposition）

> **何时读**：任务含"把某变量的历史/路径分解成各结构冲击贡献""哪个冲击驱动了衰退/通胀""实时
> 分解""初始条件贡献"，命令族 `shock_decomposition` / `realtime_shock_decomposition` /
> `plot_shock_decomposition` / `initial_condition_decomposition`。**本文件回答**：四个命令的用途与
> 选项、shock_groups 块、parameter_set 的选择、画图。**前置**：通常先做估计（estimation.md）或
> calib_smoother 得到平滑冲击。

冲击分解把每个内生变量在每期的取值，分解为：**初始条件贡献 + 各结构冲击的累积贡献（+ 平滑残差）**，
回答"这段历史主要由哪些冲击驱动"。底层依赖**平滑器**（Kalman 平滑）还原出历史结构冲击，故需要
数据 + 一组参数（估计后验/众数，或校准值经 `calib_smoother`）。

## 1. `shock_decomposition`——历史分解

```dynare
shock_decomposition(
   parameter_set = posterior_mean,   // 用哪组参数：calibration | prior_mode |
                                     // posterior_mode | posterior_mean(默认) | posterior_median | mle_mode
   datafile = 'data.csv',            // 未先跑 estimation 时需指明数据
   first_obs = 1, nobs = 200,
   use_shock_groups = monpol,        // 引用某个 shock_groups 块名，把冲击归类汇总
   colormap = 'jet',
   nograph                           // 只算不画（之后用 plot_shock_decomposition 画）
) y pi r;                            // 要分解的变量列表（缺省=所有内生）
```

- `parameter_set` 决定平滑用哪组参数：估计后用 `posterior_mean`/`posterior_mode`；纯校准模型用
  `calibration`（此时需先 `calib_smoother` 或本命令自带平滑）。
- 结果进 `oo_.shock_decomposition`（维度：变量 × (冲击数+2) × 时间；最后两层通常是初始条件与平滑残差/常数）。
- 大量变量时先 `nograph` 只算，再用 `plot_shock_decomposition` 精细画图。

## 2. `shock_groups` 块——把冲击归类

冲击多时，按经济含义分组（如"需求类""供给类""政策类"），分解图按组着色更可读：

```dynare
shock_groups(name = monpol);        // 组集合命名，命令里 use_shock_groups=monpol 引用
   'Monetary policy'  = eps_r;
   'Demand'           = eps_g, eps_b;
   'Supply'           = eps_z, eps_mu;
end;
```

每行：`'组显示名' = 冲击1, 冲击2, ...;`。未列出的冲击归入"其它"。

## 3. `realtime_shock_decomposition`——实时（递归)分解

模拟"站在历史每个时点、只用截至当时的数据"做分解，看分解如何随数据更新而修正（区分
forecast/realtime/pointwise 三种视角）：

```dynare
realtime_shock_decomposition(
   parameter_set = posterior_mean,
   forecast = 8,           // 每个 vintage 向前预测的期数
   save_realtime = [60 80 100]   // 保存这些末期 vintage 的分解
) y;
```

输出进 `oo_.realtime_shock_decomposition`、`oo_.realtime_forecast_shock_decomposition` 等。

## 4. `initial_condition_decomposition`——初始条件分解

把变量路径中**初始状态**的贡献，进一步拆到各个状态变量上（回答"起点的哪些状态在驱动后续动态"）：

```dynare
initial_condition_decomposition(
   nograph
) y k;
```
结果进 `oo_.initval_decomposition`。

## 5. `plot_shock_decomposition`——画图（与计算解耦）

先用 `shock_decomposition(nograph)` 算好，再灵活画：

```dynare
plot_shock_decomposition(
   use_shock_groups = monpol,
   type = qoq,             // aoa | yoy | qoq：把分解按年/同比/环比聚合呈现
   detail_plot,            // 每个冲击单独子图（默认 group 堆叠图）
   fig_name = 'crisis'
) y pi;
```

常用：`detail_plot`（逐冲击子图）/`realtime`/`vintage`（配合实时分解）/`type`（聚合方式）/`steadystate`（叠加稳态）。

## 与"方差分解"的区别

- **冲击分解**：针对**具体历史样本**，把每期的实际取值归因到各冲击（需数据 + 平滑器）。
- **方差分解**（stoch_simul 的 `conditional_variance_decomposition` / `oo_.variance_decomposition`）：
  无条件/条件**总体方差**中各冲击的占比，不针对具体历史。两者互补，别混用。

## MATLAB MCP 运行注意

- 先确认已有可用的参数组：估计模型用后验；校准模型可先跑 `calib_smoother(datafile=...)` 再分解。
- 数据列名须与 `varobs` 一致。
- 读 `oo_.shock_decomposition` 核对贡献和（各冲击 + 初始条件 ≈ 实际值）。

参考 DSGE_mod：`Smets_Wouters_2007`（估计后做历史/实时分解）；Pfeifer 关于冲击分解口径的说明。

---

# 手册增补（Dynare 7.1 §4.19 Shock Decomposition）

- 四命令：`shock_decomposition`、`realtime_shock_decomposition`、`initial_condition_decomposition`、
  `plot_shock_decomposition`；分组用 `shock_groups` 块 + `use_shock_groups=`。
- `parameter_set` 取值：`calibration`/`prior_mode`/`posterior_mode`/`posterior_mean`/`posterior_median`/`mle_mode`。
- 输出：`oo_.shock_decomposition`、`oo_.realtime_shock_decomposition`、`oo_.initval_decomposition`。
- `plot_shock_decomposition` 的 `type=aoa|yoy|qoq` 控制时间聚合；`detail_plot` 逐冲击子图。
