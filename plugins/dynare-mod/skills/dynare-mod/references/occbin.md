# 偶尔约束（OccBin，分段线性解）

> **何时读**：模型含偶尔起作用的约束——ZLB/有效下限、抵押/借贷约束、不可逆投资等，需分段线性
> 解或带约束估计。**本文件回答**：occbin_constraints 块、regime 方程标签、shocks(surprise)、
> occbin_setup/occbin_solver。**另一条路**：完全预见下用 lmmcp/`⟂` 互补松弛（见
> perfect-foresight.md），单约束、确定性路径时更轻。

Dynare 支持最多**两个**偶尔约束，用分段线性解（Guerrieri & Iacoviello 2015）。也可带约束估计
（反演滤波 Cuba-Borda et al. 2019，或分段 Kalman 滤波 Giovannini et al. 2021）。五步：

## 1. `occbin_constraints` 块——命名约束 + bind/relax 条件

```dynare
occbin_constraints;
   // 名义利率 ELB；留小缓冲(1e-8)防在临界点震荡出伪周期解
   name 'ELB'; bind inom <= iss-1e-8; relax inom > iss+1e-8;
end;
```

- `name 'STRING'`：约束名，后面在 `bind=`/`relax=` 方程标签里引用。
- `bind`（必给）：在**基线/稳态 regime** 评估、判定约束是否变为起作用。
- `relax`（可选）：在**约束 regime** 评估、判定是否返回基线。不给则 Dynare 自动检查 `bind` 是否
  转假；但若 `bind` 在约束态无法评估（如相关变量恒定，要看乘子符号），就必须显式给 `relax`。
- 表达式**只能含当期内生**（含 lead/lag/外生须先造辅助变量）；**不自动线性化**，须自己写成与
  分段线性解一致的（通常线性化的）形式；变量是**水平**不是偏离，取稳态用 `STEADY_STATE()`。
- `error_bind`/`error_relax`（可选）：自定义约束违反量的数值判据（默认用不等式绝对值）。

## 2. model 块用标签标各 regime 方程

差异方程都带 `name` 标签 + `bind=`/`relax=` 指明所属 regime：

```dynare
[name='investment',bind='IRR,INEG']
(log_Invest - log(phi*steady_state(Invest))) = 0;     // 两约束都 bind 的 regime
[name='investment',relax='IRR']
Lambda = 0;                                            // IRR 不 bind 的 regime（不论 INEG）
[name='investment',bind='IRR',relax='INEG']
(log_Invest - log(phi*steady_state(Invest))) = 0;     // IRR bind 而 INEG relax
```

- 同一条逻辑方程在不同 regime 的各版本**共用同一个 `name`**。
- 两约束时，只给一个 name tag 表示对另一约束的两态都成立。
- 多约束且某方程属多 regime（如两约束都 bind）时，约束名以逗号分隔。

## 3. `shocks(surprise)` 块——逐期意外冲击序列

```dynare
shockssequence = randn(100,1)*0.02;
shocks(surprise,overwrite);
   var epsilon;
   periods 1:100;
   values (shockssequence);
end;
```
语法同完全预见的 `periods/values`；每期冲击对 agent 都是意外（非预期）。
要真正生效，须随后调用 `occbin_setup`。

## 4. `occbin_setup(...)`——准备

模拟关键选项：
- `simul_periods`（默认 100）、`simul_check_ahead_periods`（默认 200，须够大以保证回到基线）、
  `simul_maxit`（默认 30）。
- `simul_curb_retrench`：初始 regime 猜测每次只更一期，更稳但更慢。
- `simul_periodic_solution`：接受周期解（解在两组结果间振荡、非唯一时）；常因临界点数值误差，
  也可靠 bind/relax 留缓冲避免。
- `simul_debug`：额外调试信息。

带约束**估计**时，`occbin_setup` 选滤波：`likelihood_inversion_filter`（反演滤波，设系统始于稳态）
或默认 `likelihood_piecewise_kalman_filter`（分段 Kalman，与单变量 Kalman `kalman_algo=2,4` 不兼容）；
平滑用 `smoother_inversion_filter`/`smoother_piecewise_kalman_filter`。ZLB 处某结构冲击退出模型
（如泰勒规则货币冲击）时：把该期观测设 NaN，分段 Kalman 还需用 `heteroskedastic_shocks` 把对应
冲击标准差设 0（防随机奇异）；反演滤波则靠 `varexo` 与 `varobs` 的**声明序一一对应**自动丢弃
（务必保证两者声明序可配）。单位根模型加 `diffuse_filter`。

```dynare
occbin_setup(likelihood_inversion_filter, smoother_inversion_filter);
estimation(smoother, heteroskedastic_filter, ...);
```

## 5. `occbin_solver(...)`——跑分段线性解

输出进 `oo_.occbin`：
- `oo_.occbin.simul.piecewise`——分段线性解（列=变量声明序、行=`simul_periods`）。
- `oo_.occbin.simul.linear`——忽略约束的纯线性解（对照）。
- `oo_.occbin.simul.shocks_sequence`、`oo_.occbin.simul.regime_history`（每期 regime）。

## 与 lmmcp/`⟂` 的取舍

- **OccBin**：最多两约束，分段线性，可估计；适合 ZLB/抵押约束等含预期的随机情形。
- **lmmcp（`⟂`）**：完全预见确定性路径里直接写不等式互补，单/双边界、可含参数；实现轻、无需写
  各 regime 方程，但只在确定性模拟/extended_path 下（见 perfect-foresight.md「lmmcp」）。

参考 DSGE_mod 的 `Guerrieri_Iacoviello_2015`。
