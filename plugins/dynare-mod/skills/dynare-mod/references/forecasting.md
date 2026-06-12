# 预测（Forecasting / 条件预测）

> **何时读**：任务含"预测未来路径""无条件/条件预测""给定某变量未来路径下其它变量怎么走""扇形
> 图/置信带"，命令族 `forecast` / `conditional_forecast` / `conditional_forecast_paths` /
> `plot_conditional_forecast`。**本文件回答**：无条件 vs 条件预测的区别与写法、把某些内生变量约束到
> 给定路径、画扇形图。**前置**：随机解（stoch_simul，见 stochastic-simulation.md）或估计（estimation.md）。

两类预测：
- **无条件预测** `forecast`：从当前状态（稳态或 `histval`/平滑末态）出发，按模型动态外推，给出均值路径 + 置信带。
- **条件预测** `conditional_forecast`：**把某些内生变量约束到用户给定的未来路径**（如"假设央行让利率按这条路径走"），
  反解出需要的冲击，再看其它变量如何响应。

## 1. `forecast`——无条件预测

需先有解（`stoch_simul` 或 `estimation`）。起点：随机情形用 `stoch_simul` 算出的稳态，或 `histval`/估计平滑末态。

```dynare
stoch_simul(irf=0);            // 先得到一阶解
forecast(
   periods = 20,               // 预测期数
   conf_sig = 0.9              // 置信带覆盖率（默认 0.9）
) y pi r;                      // 缺省=所有内生
```

- 含 `varexo_det` + 完全预见 `shocks` 给确定性未来路径时，`forecast` 会算"已知未来确定性变化"下的条件外推
  （见 estimation.md/stochastic-simulation.md「混合确定/随机」）。
- 输出进 `oo_.forecast`：`.Mean`、`.HPDinf`/`.HPDsup`（置信带）、`.Steady` 等。
- 估计后用 `estimation(..., forecast=20)` 也能直接出后验预测。

## 2. 条件预测——三步

### (a) `conditional_forecast_paths` 块：给约束路径

```dynare
conditional_forecast_paths;
   var r;                      // 把内生变量 r 约束到给定路径
   periods 1:4;
   values 0.01 0.0125 0.015 0.015;

   var pi;
   periods 1:2;
   values 0.02 0.02;
end;
```
每个被约束内生变量一段 `var/periods/values`。被约束的内生数 ≤ 用来反解的冲击数。

### (b) `conditional_forecast` 命令：反解并预测

```dynare
conditional_forecast(
   parameter_set = calibration,   // 校准模型用 calibration；估计后用 posterior_mean 等
   controlled_varexo = (eps_r, eps_pi),   // 留作"自由"、被反解出来以命中约束路径的冲击
   periods = 20,
   conf_sig = 0.8
) y c;                            // 报告这些变量的条件预测
```

- `controlled_varexo`：为命中约束路径而被反解的冲击；其数目须 ≥ 被约束内生变量数。
- `parameter_set`：`calibration` | `posterior_mode` | `posterior_mean` | ...（同冲击分解）。
- 结果进 `oo_.conditional_forecast`（`.cond` 条件预测、`.uncond` 对照的无条件预测）。

### (c) `plot_conditional_forecast`：画扇形图

```dynare
plot_conditional_forecast(periods = 20) y c;
```
叠加条件路径与置信扇形，便于比较"约束 vs 自由"。

## 起点的设定（重要）

- 缺省起点是模型稳态。要从**特定历史状态**出发，用 `histval` 设状态变量初值（见 steady-state.md/perfect-foresight.md）。
- 估计后做预测，起点常用**平滑末态**（数据末期的滤波/平滑状态）——由 `estimation` 自动衔接。
- `loglinear` 模型里 `histval` 仍填**未取对数**的水平值。

## 无条件 vs 条件 vs 完全预见

| 场景 | 命令 | 关键 |
|------|------|------|
| 纯外推、要置信带 | `forecast` | 随机解 + conf_sig |
| 约束部分内生路径、反解冲击 | `conditional_forecast`(+paths) | controlled_varexo |
| 确定性、agent 完全预见未来路径 | 完全预见 `perfect_foresight_*` 或 `varexo_det`+`forecast` | 见 perfect-foresight.md |

## MATLAB MCP 运行注意

- `conditional_forecast` 的 `controlled_varexo` 数 ≥ 被约束内生数，否则反解欠定/无解。
- 估计后预测确认 `parameter_set` 与已载入的后验一致。
- 读 `oo_.forecast` / `oo_.conditional_forecast` 核对均值与置信带。

参考 DSGE_mod：`Smets_Wouters_2007`（后验预测）；Dynare `examples/` 的 `fs2000`（`forecast` 基本用法）、
条件预测示例。

---

# 手册增补（Dynare 7.1 §4.21 Forecasting）

- 无条件：`forecast(periods=, conf_sig=)`，输出 `oo_.forecast`（Mean/HPDinf/HPDsup）。
- 条件：`conditional_forecast_paths` 块给约束路径 → `conditional_forecast(parameter_set=, controlled_varexo=(...), periods=)`
  → `plot_conditional_forecast`。输出 `oo_.conditional_forecast`。
- `controlled_varexo` 数 ≥ 被约束内生数；`parameter_set` 同冲击分解取值族。
- 起点：稳态 / `histval` / 估计平滑末态。
