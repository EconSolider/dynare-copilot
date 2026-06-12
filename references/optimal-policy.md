# 最优政策（Ramsey、discretion、OSR）

> **何时读**：任务含 Ramsey/承诺/相机抉择/福利/最优简单规则，命令族 `ramsey_model`/`discretionary_policy`/`osr`。**本文件回答**：三种实验如何选、planner_objective、方程数少 1 的规则、OSR 三件套。

三类不同实验，按问题选择：

- **Ramsey / 承诺**：规划者一次性承诺一条状态依存的计划。用 `ramsey_model`（再接
  `stoch_simul`）或旧的一体式 `ramsey_policy`。
- **相机抉择（discretion）**：规划者每期重优化、无法承诺。用 `discretionary_policy`。
- **最优简单规则（OSR）**：在**给定**简单规则（如泰勒规则）中找使二次损失最小的系数。
  用 `osr` 配 `osr_params`。

三者都在模型块写**私人部门均衡条件**，并单独给规划者**目标**；Ramsey/discretion **不写**
政策工具自身的规则——Dynare 自行导出最优规则。

## 规划者目标

```dynare
planner_objective pi^2 + vartheta*x^2;        // 每期损失（被最小化）
// 或福利/效用表达式（被最大化），如：
planner_objective log(c) - chi*n^(1+phi)/(1+phi);
```

`planner_objective` 给的是**每期**收益；Dynare 用命令选项里的贴现因子贴现。

## Ramsey（承诺）

```dynare
planner_objective pi^2 + vartheta*x^2;
ramsey_model(planner_discount=betta, instruments=(i));
stoch_simul(order=1, irf=20) x pi i;
evaluate_planner_objective;     // 条件/无条件福利
```

- Dynare 会补上规划者 FOC（带乘子 `MULT_i`），因此模型块比内生变量**少一个方程**——
  缺的那条就是 Dynare 求解的工具规则。**不要**自己写泰勒规则。
- `instruments=(i)` 指明政策工具。
- `planner_discount` 是规划者贴现因子（常等于家庭 `betta`）。
- `ramsey_policy(...)` 是旧的一体式命令（= `ramsey_model` + `stoch_simul`）；建议用拆分式。
- 提供解析稳态时，Ramsey 稳态还须给工具的稳态初猜（在 `initval` 里给）。

## 相机抉择（discretion）

```dynare
planner_objective pi^2 + vartheta*x^2;
discretionary_policy(planner_discount=betta, instruments=(i), order=1) x pi i;
```

设定同 Ramsey（目标 + 均衡条件，不写工具规则），但解的是时间一致（无承诺）解。仅支持一阶。

**注意：`discretionary_policy` 要求线性模型**——这是 R8 非线性优先的两个例外之一：模型块
写线性化方程并用 `model(linear);` 声明（参考 DSGE_mod 的 `Gali_2015_chapter_5_discretion`）。
Ramsey 则没有此限制，照常写非线性。

## 最优简单规则（OSR）

这里你**要**写带自由系数的规则，让 Dynare 优化系数：

```dynare
parameters ... gpi gy grho;      // 待优化的规则系数

model;
   ...
[name='simple interest-rate rule (coeffs optimized)']
   i = grho*i(-1) + (1-grho)*(gpi*pi + gy*x);
end;

// Dynare 将优化的参数：
osr_params gpi gy grho;

// 待最小化的损失权重：
optim_weights;
   pi 1;
   x  0.5;
   i  0.1;        // 也可对协方差加权：pi, x  W;
end;

// 可选：搜索的界与初值：
osr_params_bounds;
   gpi, 1, 5;
   gy,  0, 3;
   grho, 0, 0.95;
end;

osr(opt_algo=9) x pi i;          // 最小化加权方差损失
```

- `osr_params` 列出被优化的参数。
- `optim_weights` 给二次损失权重（按变量给对角项；非对角用 `变量1, 变量2 权重;`）。
- `osr_params_bounds`（可选）限定搜索并设初值。
- 损失是**无条件方差**（和协方差）的加权和。

## 注意

- 最优政策稳态常因乘子进入而不平凡；若 `steady_state_model` 难写，给好的数值 `initval`
  并靠 `steady`。
- Ramsey/discretion 后用 `evaluate_planner_objective` 报告福利；`histval` 可设定评估福利
  所在的状态（含滞后外生）。
- 保持随机情形的注意事项（拐点附近不用 `max`/`min`/`abs`/比较算子）。

参考 DSGE_mod：`Gali_2015_chapter_5_commitment`（`ramsey_model`）、
`Gali_2015_chapter_5_discretion`（`discretionary_policy`）、含 ZLB 的对应变体、以及
新凯恩斯 Ramsey/OSR 综合示例。

---

# 手册增补（Dynare 7.1 §4.22）

- `ramsey_model` 用辅助乘子 `MULT_i`（i=约束在 model 块的声明序），故模型块比内生少一个方程——
  缺的就是工具规则（前文已述，手册确认）。
- **条件福利的状态**：`histval` 设定评估 planner 目标所在的内生状态（含滞后外生）；乘子初值不能设
  （见 `evaluate_planner_objective`）。
- **第1期已知冲击实现**：随机最优政策下福利条件于第1期状态、含该期外生实现——用完全预见 `shocks`
  语法在 `periods 1` 给值（其它期忽略）；滞后冲击（news）用 `histval`。
