# 完全预见（确定性模拟）

> **何时读**：任务含过渡路径/永久或临时冲击/确定性模拟，命令族 `perfect_foresight_*`。**本文件回答**：initval/endval/histval 三者分工、确定性冲击块、奇异雅可比陷阱。

**确定性/完全预见**设定下，agent 完全知道外生变量的整条未来路径。Dynare 在 `T` 期上
精确求解完整非线性系统（不线性化），能处理大冲击和强非线性。典型用途：临时冲击后回到
均衡、永久冲击后向**新**稳态过渡。

两条命令，固定顺序：

```dynare
perfect_foresight_setup(periods=200);   // 由 initval/endval/shocks 构造路径
perfect_foresight_solver;               // 求解非线性两点边值问题
```

## 初值与终值条件——设定的核心

前瞻模型既需**初始条件**（状态/滞后），又需**终端条件**（跳跃/超前）。`initval`、
`endval`、`histval` 相互作用，务必想清楚谁提供了什么。`perfect_foresight_setup` 后
**用 MCP 检查 `oo_.endo_simul` 和 `oo_.exo_simul`** 是否如预期。

### 临时冲击、回到原稳态 —— `initval` + `shocks`

```dynare
initval;
   c = 1.2;  k = 12;  x = 1;
end;
steady;                 // 把 initval 变成给定 x=1 下的真实稳态

shocks;                 // 外生变量 x 的临时偏离
   var x;
   periods 1;
   values 1.2;
end;

perfect_foresight_setup(periods=200);
perfect_foresight_solver;
```

`initval` 后接 `steady` 会算出"给定 initval 中外生值"的稳态，并同时作为初始条件、终端
条件和求解器初猜。

### 永久冲击、过渡到新稳态 —— `initval` + `endval`

```dynare
initval;                // 初始稳态（外生在旧水平）
   x = 1;  k = 12;  c = 1.2;
end;
steady;

endval;                 // 终端稳态（外生在新水平）
   x = 2;  k = 20;  c = 2;
end;
steady;

perfect_foresight_setup(periods=200);
perfect_foresight_solver;
```

- `initval` 在前、`endval` 在后：`initval` 提供状态变量（滞后）的**历史值**，`endval`
  提供跳跃变量的**终端值**及每期的求解器初猜。
- `endval` 若**不接** `steady`，终端值就**按字面**取，不必是稳态。
- `endval` 中**省略**的变量保留上一次 `initval`/`steady` 的值（**不**归零；这点与
  `initval` 不同——`initval` 省略的变量默认 0）。
- 也可用 `perfect_foresight_setup(periods=200, endval_steady)`（或 `endval` 后接 `steady`）
  让求解器自己找终端稳态；大永久冲击时有用（homotopy 一次性搞定两者）。

### 任意历史路径 —— `histval`

多期滞后模型用 `histval` 给不同前样本期设不同历史值。第 1 期是首个模拟期，往前是第 0、
-1 期……然后 `initval` 提供终端条件 + 求解器初猜。

```dynare
model;
   x = 1.5*x(-1) - 0.6*x(-2) + epsilon;
   log(c) = 0.5*x + 0.5*log(c(+1));
end;
histval;
   x(0)  = -1;
   x(-1) =  0.2;
end;
initval;
   c = 1;  x = 1;
end;
```

`histval` 不能接 `steady`，且不接受非状态变量。

## 冲击块——确定性写法

确定性情形下 `shocks` 块设外生变量的**临时时间路径**（永久变化用 `endval`）：

```dynare
shocks;
   var e;
   periods 1;
   values 0.5;

   var v;
   periods 4:5  6  7:9;     // 区间与单点
   values  1    1.1  0.9;   // 每期或每区间一个值

   var w;
   periods 1 2;
   values (1+p) (exp(z));   // 表达式须加括号
end;
```

- 区间 `4:5` 配单标量 = 整段同值；配向量则向量长度须等于区间长度。
- 模拟第 1 期是首个内生期；第 0 期的值可能与 `initval`/`endval` 冲突。`setup` 后用 MCP
  核对 `oo_.exo_simul`。
- `mshocks` 是乘法版（`1.05` = 高于稳态 5%），适合稳态非零的外生变量。

## `perfect_foresight_solver` 选项

- `stack_solve_algo = 0`（默认，全堆叠系统稀疏 Newton）| `1`（LBJ，省内存）| 其他
  块/迭代求解器。
- `maxit`、`tolf`、`tolx`：求解器容差。
- `no_homotopy`：关闭自动 homotopy 兜底（默认失败时会缩小冲击再逐步放大）。
- `print` / `noprint`。

## 完全预见专属陷阱（奇异雅可比）

若某方程经替换后**只含** `t+1`（或只含 `t-1`）变量，它在最后（最初）一期对 `t` 期变量的
导数为 0，使堆叠雅可比奇异——常见于用拉格朗日乘子作辅助变量。会失败的写法：

```dynare
Lambda = beta*C(-1)/C;
Lambda(+1)*R(+1) = 1;
```

改成替换掉乘子：

```dynare
beta*C/C(+1)*R(+1) = 1;
```

## 结果

- `oo_.endo_simul`：内生路径（列=期，第 1 列是初始条件、最后一列是终端）。
- `oo_.exo_simul`：外生路径。
- 用日期（`first_simulation_period=2000Q1`）时，结果还以时间序列存于
  `Simulated_time_series`。
- 快速查看：`rplot c;` `rplot k;`。

## 相关变体（按需提及）

- **预期误差**：agent 按完全预见行动但会被意外冲击惊到并重优化——
  `perfect_foresight_with_expectation_errors_setup/_solver`。
- **OccBin**（偶尔约束）：`occbin_setup; occbin_solver;`，参考 DSGE_mod 的
  `Guerrieri_Iacoviello_2015`。

---

# 手册增补（Dynare 7.1 §4.7/4.8/4.12）

## 控制内生路径（确定性条件预测）`perfect_foresight_controlled_paths`

钉住某些内生变量的路径，放开同期某些外生由 Dynare 反解（即确定性版"条件预测"）：

```dynare
perfect_foresight_controlled_paths;
   exogenize c;            // 把内生 c 钉住（受控）
   periods 2 4:5;
   values 1.6 1.7;         // c 第2期=1.6，第4-5期=1.7
   endogenize x;           // 放开外生 x 反解，使上面成立
   exogenize k;
   periods 7:9;
   values 13;
   endogenize z;
end;
perfect_foresight_setup(periods=100);
perfect_foresight_solver;
```
- 受控内生数 = 放开外生数。可与普通 `shocks` 并存（不冲突即可）。
- 要求 `stack_solve_algo ∈ {0,1,2,3,6,7}`；与 `block`/`bytecode` 不兼容。
- 预期误差版加 `learnt_in=期` 表示该受控计划在哪期被告知。

## 统一冲击接口 `shock_paths`（带作用域表达式）

一块顶替 `shocks`+`mshocks`+`endval`+`perfect_foresight_controlled_paths`（不能与它们混用）。
`values` 引用变量须带作用域前缀：

| 前缀 | 含义 |
|------|------|
| `initval.X` / `init.X` | 取 initval 块的值（内生为其稳态，若 initval 后接 steady） |
| `self.X(-1)` | 本块已定义外生在某滞后期的值——可造 AR 过程 |
| `DBNAME.X` / `DBNAME.X(-1)` | 取自 `database` 声明的外部表/dseries |
| `prev.X` | 预期误差情形：上一信息期该外生的值 |
| `learnt_in(p).X` | 预期误差情形：第 p 信息期那一版的值 |

`periods` 含 `end` 关键字 = **永久冲击**（隐式开启 `endval_steady`）。

```dynare
db = table(transpose(linspace(0,1,101)),'VariableNames',{'foo'});
database db;
shock_paths;
   var x;                                  // 前5期 AR、第6期起转永久冲击
   periods 1, 2:5, 6:end;
   values initval.x*1.05, self.x(-1)*1.05, self.x(-1);
   var y;                                  // 取自数据库
   periods 1:3;
   values db.foo;
   exogenize c; periods 2,4:5; values 1.6,1.7; endogenize z;   // 受控
end;
```
表达式不需加括号（逗号已分隔）。`database NAME;` 先声明外部表（单行=无时间维、多行=逐期）。

## 预期误差完全预见（`learnt_in` 全语法）

命令对 `perfect_foresight_with_expectation_errors_setup/_solver`。**终端条件始终被当稳态**
（隐式 `endval_steady`，每次预期改变都重算终端稳态）。

```dynare
shocks(learnt_in=1);   // 第1期所知：x 各期路径
  var x; periods 1:2 3:4 5; values 1 1.2 1.4;
end;
shocks(learnt_in=2);   // 第2期新信息：对 3:4 期"在原预期上加 0.1"
  var x; periods 3:4; add 0.1;        // values→add（加法）/ multiply（乘法）
end;
endval(learnt_in=3);   // 第3期才知道的终端条件
  x = 1.1;  y += 0.1;  z *= 2;        // = 绝对 / += 相对上一预期加 / *= 乘
end;
perfect_foresight_with_expectation_errors_setup(periods=30);
perfect_foresight_with_expectation_errors_solver;   // 可选 constant_simulation_length
```
也可用 CSV 给整张信息集（`datafile=...`）：`p+3` 行 ×`k*p+1` 列，第2行=「形成预期的信息期」、
各数据行=「被预期的期」、末行=终端条件。结果存 `oo_.pfwee.shocks_info(k,t,s)` 与
`oo_.pfwee.terminal_info(k,s)`。

## 不等式约束：lmmcp / 互补松弛 `⟂`（ZLB、不可逆投资）

完全预见下处理偶尔约束的**另一条路**（区别于 OccBin，见 occbin.md）。相关方程后用垂直符 `⟂`
（UTF-8 U+27C2，或 ASCII `_|_`）接互补条件，再 `perfect_foresight_solver(lmmcp)`：

```dynare
model;
   ...
   // 名义利率 ZLB：1.94478 是稳态利率，r 是相对稳态偏离
   r = rho*r(-1) + (1-rho)*(gpi*Infl+gy*YGap) + e   ⟂   r > -1.94478;
   ...
end;
perfect_foresight_setup(periods=200);
perfect_foresight_solver(lmmcp);     // = stack_solve_algo=7 且 solve_algo=10
```
- 互补条件**必须挂在受影响的那条方程**上；残差符号要对：Dynare 取 `residual=LHS-RHS`，
  ZLB（下界）要求残差为正。上式 `r-(rho*r(-1)+...)` 正确；写成 `...=r;` 则错。
- 好处：免去在模型其余处写 `max(r,-1.94478)`（R6 随机情形禁 max/min；确定性虽可用但引奇异）。
- 双边界：`... ⟂ -1.94478 < r < 1+2*alpha;`（界可含参数表达式）。`extended_path(lmmcp)` 同理。

## 永久冲击便捷开关与陷阱

- `perfect_foresight_setup(..., endval_steady)`：`endval` 不接 `steady` 也让求解器自算终端稳态；
  大永久冲击省一遍 homotopy。`shock_paths` 用 `end` 时隐式开启。
- `model(..., differentiate_forward_vars)`：给每个带超前内生造 `AUX_DIFF_FWRD=x-x(-1)`，
  其终端条件天然为 0，**对强持续/永久冲击的收敛很有帮助**。
- `perfect_foresight_solver` 失败自动 homotopy（缩小冲击逐步放大）；可调 `no_homotopy`、
  `homotopy_initial_step_size`、`homotopy_min_step_size`、`homotopy_max_completion_share`、
  `homotopy_linearization_fallback`（解不到 100% 时用线性外推近似解）、
  `homotopy_marginal_linearization_fallback`、`homotopy_exclude_varexo=(...)`。
- `linear_approximation`：解线性化版（需稳态，仅 `stack_solve_algo∈{0,7}`）。
- `endogenous_terminal_period`：动态删掉已收敛尾段、混合 shooting/relaxation（仅 algo=0）。

## 从文件给初/终值与历史：`initval_file` / `histval_file`

```dynare
initval_file(datafile='mydata.csv');         // 列名须与变量同名；首列可放日期
// 选项：first_obs / nobs / first_simulation_period / last_simulation_period / series=DSERIES
perfect_foresight_setup(periods=200);
perfect_foresight_solver;
```
- 路径长度需 = 模拟期数 + 滞后数 + 超前数（如 200 期、2 滞后 1 超前 → 至少 203 行）。
- 不要与 `initval` 混用；但其后可再用 `histval`/`histval_file` 改历史值。
- `histval_file` 常与 `smoother2histval` 配合（把平滑结果当模拟起点）。

## `mshocks` 乘法冲击

- 无 `endval`：以 `initval` 稳态为基；有 `endval`：以终端稳态为基（除非 `relative_to_initval`）。
- `1.05` = 高于稳态 5%。仅对**稳态非零**的外生有意义。
