# 稳态

> **何时读**：几乎每个任务（线性化点/初终条件都依赖稳态）。**本文件回答**：解析 steady_state_model（首选）vs 数值 initval 的决策、反解校准、homotopy、[static]/[dynamic] 标注、验证命令。

几乎每个 `.mod` 都需要稳态：`stoch_simul` 和 `estimation` 在其附近线性化，完全预见用它
作初/终条件。算对稳态是"结果正确"与"静默出错"的分水岭。**默认：能手解就写解析式
`steady_state_model` 块**；无闭式解才退回数值 `initval` 初猜。

## 方案 A（首选）：解析式 `steady_state_model`

能在纸上解出稳态时，把公式交给 Dynare。它便能廉价可靠地在每个参数点重算稳态（对估计
至关重要），而非每次跑 Newton 求解器。

```dynare
steady_state_model;
    z = 0;                                  // 稳态下冲击为零
    r = 1/betta - 1 + delta;                // 逐步构造中间量……
    kl = (alppha/r)^(1/(1-alppha));         // 临时变量（资本-劳动比）
    w  = (1-alppha)*kl^alppha;
    // ……用参数、稳态外生和上方已赋值的变量逐行推导每个内生变量
    l  = ...;
    k  = kl*l;
    invest = delta*k;
    y  = kl^alppha*l;
    c  = y - invest;
end;
steady;        // 执行该块并验证它确实解出静态模型
```

规则：
- 每行给**一个**变量（内生、临时或参数）赋一个表达式，只能用参数、稳态外生和**上方已赋值**
  的变量。**顺序重要**——这是顺序计算，不是联立方程组。
- 可自由引入临时变量（无需声明）。
- 若右端 MATLAB 函数返回多个输出，可一次赋多个：`[W, e] = my_function(l, n);`。
- Dynare 由该块自动生成 `+文件名/steadystate.m`。
- 确定性模型也适用：每个设定外生水平的 `initval`/`endval` 块后都接 `steady` 来执行它。
- 若故意提供"非静态模型精确解"的稳态值（如单位根模型），用 `steady(nocheck)`。

## 在稳态里反解校准（Pfeifer 关键技巧）

`steady_state_model` 块里可以**更新参数**——把校准目标反解成参数值。例如固定稳态劳动
`l=0.33`，反解劳动负效用 `psi`，并由"伟大比率"反解 `delta`、`betta`：

```dynare
steady_state_model;
    // 先做校准：用投资产出比 i_y、资本产出比 k_y 等目标反解参数
    gammax = (1+n)*(1+x);
    delta  = i_y/k_y - x - n - n*x;
    betta  = (1+x)*(1+n)/(alppha/k_y + (1-delta));
    l = 0.33;                               // 目标：稳态劳动 = 1/3
    k = ((1/betta*(1+n)*(1+x) - (1-delta))/alppha)^(1/(alppha-1))*l;
    invest = (x+n+delta+n*x)*k;
    y = k^alppha*l^(1-alppha);
    c = (1-gshare)*y - invest;
    psi = (1-alppha)*(k/l)^alppha*(1-l)/c^sigma;   // 反解出 psi 命中 l=0.33
    w = (1-alppha)*y/l;
    r = 4*alppha*y/k;
    z = 0; ghat = 0;
end;
```

注意：这样被反解的参数（如 `psi`、`delta`、`betta`）**不要再**在前面 `parameters` 校准区
赋值（或赋了也会被这里覆盖）。

**被反解的参数也可同时出现在 model 块的某条动态方程里**——典型如政府支出占比 `G/Y=s_g`
反解出稳态支出参数 `gss`，再在外生过程里用它定均值：
```dynare
parameters gss;                              // 不在校准区赋值，下面反解
model;
   [name='gov spending process']
   log(g) = (1-rho_g)*log(gss) + rho_g*log(g(-1)) + eps_g;
end;
steady_state_model;
   // …先解出 y…
   gss = gy_share*y;                         // 反解：命中 G/Y = gy_share
   g   = gss;
end;
```
机制：估计/模拟时 `steady_state_model` 在每个参数点先更新 `gss` 再线性化，故动态方程里引用它
是安全的。趋势增长率、稳态通胀、政府/债务比等\"既是校准目标又进方程\"的量都用这个模式。

## 方案 B：数值 `initval` 初猜

无闭式解时给 Newton 求解器一个好起点：

```dynare
initval;
   c = 1;  k = 10;  l = 0.33;  y = 1;  invest = 0.25;  z = 0;
end;
steady;        // Dynare 从该初猜求解静态模型
```

- 给**每个**内生变量赋值；省略的内生/外生默认 **0**，常导致求解失败（如 TFP 水平为 0）。
- 好初猜是难点：复杂模型逐步搭建，用经济上合理的值（伟大比率、劳动约 1/3 等）。
- 求解前用 `resid;` 检查（解出后应接近 0），失败时调
  `steady(solve_algo=..., maxit=..., tolf=...)`。`solve_algo=0` 用 `fsolve`；`4`（默认）
  信赖域；`2`/`12` 块分解。

## 方案 C：手写稳态文件

要最大灵活性（循环、条件）可自己写 `文件名_steadystate.m`。更强但更易引入 bug，通常
`steady_state_model` 足矣。

## Homotopy——好初猜也不收敛时

先解容易的参数化，再分步推进到难的：

```dynare
homotopy_setup;
   gam, 0.5, 2;     // gam 从 0.5 走到 2
   x,   2;          // x 从 initval 值走到 2
end;
steady(homotopy_mode=1, homotopy_steps=50);
```

永久冲击且初始稳态已解出时，可在 `endval` 块后放
`homotopy_setup(from_initval_to_endval);`（常空体）让所有外生从 initval 过渡到 endval。

## `[static]` / `[dynamic]` 方程标注

静态（稳态）版方程有时应不同于动态版——典型是有连续稳态的单位根模型。给 `[static]` 标注
的方程钉住稳态，配一条 `[dynamic]` 的运动律：

```dynare
model;
   c + k - aa*x*k(-1)^alph - (1-delt)*k(-1);
   [dynamic] c^(-gam) - (1+bet)^(-1)*(aa*alph*x(+1)*k^(alph-1) + 1 - delt)*c(+1)^(-gam);
   [static]  k = ((delt+bet)/(x*aa*alph))^(1/(alph-1));
end;
```

每条 `[static]` 须配一条 `[dynamic]`。

## 验证稳态（可通过 MCP 逐条运行）

- `steady;`——打印稳态值（有稳态文件时还检查它解出静态模型）。
- `resid;`（或 `resid(non_zero);`）——打印当前 `initval`/`endval` 下的静态残差，`steady`
  前用它定位错误方程。
- `check;`——报告特征值及 Blanchard-Kahn 条件是否成立（见 `references/debugging.md`）。
- 跑完用 MCP 读 `oo_.steady_state` 核对是否无 NaN、经济合理。

---

# 手册增补（Dynare 7.1 §4.10）

## `steady` 全部 solve_algo（0–14）

| 值 | 解法 | 备注 |
|----|------|------|
| 0 | `fsolve`（需 Optimization Toolbox；Octave 总有） | |
| 1 | 带线搜索的 Newton | |
| 2 | 分递归块、各块用 algo 1 | |
| 3 | Chris Sims 求解器 | |
| **4** | **整体 trust-region + 自动缩放（默认）** | 最稳健，首选 |
| 5 | 稀疏高斯消元(SPE) Newton | 需 `bytecode`，配 `markowitz` |
| 6 | 稀疏 LU Newton | |
| 7 / 8 | GMRES / BiCGStab Newton | |
| 9 | trust-region 整体（=4 不分块） | |
| 10 | LMMCP 互补问题（`⟂`） | 偶尔约束 |
| 11 | PATH 互补求解器 | 需自行下载 |
| 12 | 块分解 + 各块 Newton | 比 2 高效；半结构/纯前/后向模型常用 |
| 14 | 同 12 但块内用 trust-region | |

`homotopy_force_continue=1` 失败也用上一成功步继续（**危险**：参数/外生未必在期望值）。
`homotopy_mode`：1=所有参数同时推进、2=逐参数、3=自适应折半；`homotopy_steps` 控步数。

## 手写稳态文件的两种形态（与「收尾清理」白名单直接相关）

手册（7.1）明确：
- **`steady_state_model` 块** → Dynare 自动生成 **`+FILENAME/steadystate.m`**（在 `+包`文件夹内）。
- **用户手写** → 必须命名 **`FILENAME_steadystate.m`**（更灵活，可用循环/条件，但更易出 bug）。
  示例见 Dynare 自带 `NK_baseline_steadystate.m`。

> ⚠ 旧版（4.x/5.x）自动产物曾叫 `<m>_steadystate2.m`。在 7.1 下 `steady_state_model` 的自动产物
> 进 `+<m>/steadystate.m`（清理时删 `+<m>/` 文件夹即可），一般不再出现 `_steadystate2.m`。
> **绝不删**用户手写的 `<m>_steadystate.m`（无 2）。详见 workflow-detail.md「收尾清理」。

两种文件都可在每次调用时**更新参数**（如把劳动负效用设成使稳态劳动=0.2 的值；估计时让某参数随
被估参数更新以保持比率）——这正是稳态反解校准的机制。注意别误覆盖参数。

## 稳态相关命令/输出

- `resid(non_zero);`——只显示非零残差，定位错误方程更快。
- `[W, e] = my_function(l, n);`——`steady_state_model` 右端是多返回 MATLAB 函数时可一次赋多值。
- `get_mean('c','k')`——取稳态值（未算则先算）。
- 稳态存 `oo_.steady_state`（声明序）、外生稳态 `oo_.exo_steady_state`；永久冲击时初始稳态另存
  `oo_.initial_steady_state`、`oo_.initial_exo_steady_state`。
