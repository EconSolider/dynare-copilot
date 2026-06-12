# 识别与敏感性分析（Identification & Sensitivity）

> **何时读**：任务含"参数能不能被识别""估计前先查识别""先验/全局敏感性（GSA）""稳定性映射/
> Morris/Sobol""IRF 或矩校准约束先验"，命令族 `identification` 与 `dynare_sensitivity`/`sensitivity`，
> 以及 `irf_calibration`/`moment_calibration` 块。**本文件回答**：识别分析怎么跑、读什么、敏感性
> 分析的几类用途、把 IRF/矩约束当先验。**强烈建议**：开长 MCMC（estimation.md）之前先跑这两项。

估计能否成功，**识别**是前提：若某些参数（组合）对似然/矩无独立影响，后验就贴着先验、MCMC 漂移。
Dynare 提供两条互补工具：`identification`（局部、解析，基于 Iskrev/Ratto-Iskrev）与
`sensitivity`（全局，GSA，基于 Ratto 的 Monte Carlo 滤波/方差分解）。

## 1. `identification`——局部识别分析

```dynare
identification(
   parameter_set = prior_mean,   // 在哪点查识别：calibration | prior_mean(默认) | prior_mode |
                                 // posterior_mean | posterior_mode
   prior_mc = 2000,              // 在先验支撑上抽多少点做"先验空间"识别检查（>1 触发蒙卡）
   advanced = 1,                 // 输出更细：共线性、配对、最弱方向
   order = 1,                    // 用几阶矩/谱做识别（2 阶可识别更多）
   no_identification_strength    // 跳过较慢的"识别强度"计算
);
```

读什么（输出进 `oo_.identification`）：
- **识别强度（identification strength）**：每个参数被数据"按动"的力度；接近 0 = 弱/不可识别。
- **共线性 / 配对（collinearity, pairwise）**：哪些参数（对）的效应高度共线、难以分开。
- **被诊断为不可识别的参数**与**最弱识别方向**（参数组合）。
- `advanced=1` 还给基于 moments/spectrum/minimal-system 的多套 J 检查。

典型流程：`prior_mean` 处先看一眼；再 `prior_mc=N` 在整个先验空间扫，避免"恰好在某点可识别"的假象。

## 2. 敏感性与全局分析——`sensitivity`（= `dynare_sensitivity`）

GSA：在先验/参数空间大量抽样，分析参数如何映射到**稳定性、矩、IRF、似然**。几类用途由选项切换：

```dynare
// (a) 稳定性映射：哪些参数区域满足 BK / 落入不稳定或不定区
sensitivity(stab = 1, redform = 0, Nsam = 2048, pprior = 1);

// (b) 简化式（reduced-form）映射：参数 → 某些 oo_ 系数/矩 的关系（含 Morris/Sobol）
sensitivity(redform = 1, morris = 1);     // morris=1 筛选；morris=0+Sobol 做方差分解

// (c) RMSE / 拟合映射：参数 → 对数据的拟合（需 datafile）
sensitivity(rmse = 1, datafile = 'data.csv');

// (d) 与识别联动
sensitivity(identification = 1, morris = 2);
```

常用选项：`pprior`(1=从先验抽/0=从后验或指定范围)、`Nsam`(样本数)、`stab`/`redform`/`rmse`/`identification`
（选哪类分析）、`morris`(筛选 vs Sobol 方差分解)、`ppost`(用后验样本)、`graph_format`。
输出图（散点、CDF、稳定性映射、Sobol 指数）存到 `GSA/` 子夹。

> 兼容性：旧名 `dynare_sensitivity` 与 `sensitivity` 等价。

## 3. 把 IRF / 矩约束当"内生先验"——`irf_calibration` / `moment_calibration`

在估计里施加隐式先验："凡是不满足这些 IRF/矩形状的参数抽样，先验密度记 0 被丢弃"。也用于敏感性里
划定"可接受"区域。

```dynare
// 矩约束：output 自相关须落在 [0.4,0.7]
moment_calibration;
   y, y(-1), [0.4 0.7];                  // E[y_t y_{t-1}]/方差 → 一阶自相关落区间
   y, eps_z, 1:4, +;                     // y 对 eps_z 在 1..4 期方差贡献为正
end;

// IRF 约束：政府支出冲击下产出乘数前 4 期 >1（财政乘数 >1）
irf_calibration;
   y, eps_g, 1:4, [1 3];                 // y 对 eps_g 的 IRF 在 1..4 期落 [1,3]
end;
```

行义：`变量, 冲击或变量, 期/期段, 取值区间或符号`。注意：用了这些块后先验不再积分到 1，
`model_comparison`/边际似然口径会受影响（手册明确提示）。

## 推荐前置流程（估计前）

1. `identification(prior_mc=2000, advanced=1)` → 看识别强度/共线性，剔除/重参数化弱识别参数；
2. `sensitivity(stab=1)` → 确认先验空间里多数抽样满足 BK（否则 MCMC 频繁拒绝）；
3.（可选）`sensitivity(redform=1, morris=1)` → 哪些参数真正驱动关键矩；
4. 再开 `estimation(..., mh_replic=大)`。

## MATLAB MCP 运行注意

- 识别/GSA 都较慢且产图多——调试先用小 `prior_mc`/`Nsam` 跑通，再放大。
- `order=2` 能识别更多参数但更慢；先 `order=1` 看大局。
- 读 `oo_.identification`（强度、共线性、不可识别清单）；GSA 图在 `GSA/` 夹。

参考 DSGE_mod：`Smets_Wouters_2007`（估计前识别检查）；Dynare `tests/identification`、`tests/gsa` 示例。

---

# 手册增补（Dynare 7.1 §4.23 Sensitivity and Identification analysis）

- `identification(parameter_set=, prior_mc=, advanced=, order=)`：局部识别 + 先验空间扫描；输出 `oo_.identification`。
- `sensitivity`（= `dynare_sensitivity`）：GSA，`stab`/`redform`/`rmse`/`identification` 选分析类型，
  `morris`/Sobol 做筛选/方差分解，`pprior`/`ppost`/`Nsam` 控样本；图存 `GSA/`。
- `irf_calibration` / `moment_calibration` 块：把 IRF/矩形状作为隐式先验（不满足的抽样先验密度=0）；
  会破坏先验归一化，影响 `model_comparison`。
