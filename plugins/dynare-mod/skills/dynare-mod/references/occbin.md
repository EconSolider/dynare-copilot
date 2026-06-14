# 偶尔约束（OccBin，分段线性解）

> **何时读**：模型含偶尔起作用的约束——ZLB/有效下限、抵押/借贷约束、不可逆投资等，需分段线性
> 解或带约束估计。**本文件回答**：如何从零搭一个带 OccBin 的 .mod、运行模拟、读取结果。
> **另一条路**：完全预见下用 lmmcp/`⟂` 互补松弛（见 perfect-foresight.md），单约束、确定性路径时更轻。

---

## 快速定位

| 任务 | 直接跳到 |
|------|---------|
| 完整 .mod 文件的正确骨架 | §0 |
| 约束声明 (`occbin_constraints`) | §1 |
| 哪些方程要加 regime 标签 | §2 |
| 运行模拟、读取结果 | §3 |
| ZLB 财政乘数双模拟模板 | §4 |
| 六个坑（Dynare 7.1 已知问题） | §5 |
| 带约束估计 | §6 |

---

## §0 完整 .mod 骨架（Dynare 7.1，ZLB 为例）

在动笔任何一节之前，先看清各命令的正确位置顺序——位置错误是最常见的静默失败原因：

```dynare
var y c pi R_nom r_unc ...;
varexo eps_g eps_xi;
parameters ...;

model;
  // 普通方程（无 regime 标签）
  ...

  // 影子利率——不加任何 regime 标签，两个 regime 下均有效
  [name='shadow Taylor rate']
  r_unc = (1/betta) * pi^phi_pi * y^phi_y;

  // 货币政策——两条方程，共用 name，一 bind 一 relax（缺一不可）
  [name='monetary policy', relax='ELB']
  R_nom = r_unc;          // 基线 regime

  [name='monetary policy', bind='ELB']
  R_nom = R_lb;           // ZLB regime
end;

steady_state_model; ... end;
resid; steady; check;

// ① 约束声明
occbin_constraints;
    name 'ELB'; bind r_unc <= R_lb; relax r_unc > R_lb;
end;

// ② 标准冲击方差（供 stoch_simul 线性化用，不是 OccBin 的冲击序列）
shocks;
    var eps_g;  stderr 0.01;
    var eps_xi; stderr 0.01;
end;

// ③ occbin_setup 必须在此处——作为 Dynare 命令，不能放到 stoch_simul 之后
occbin_setup(simul_periods=60, simul_check_ahead_periods=200, simul_maxit=50);

// ④ stoch_simul 计算一阶线性决策规则（OccBin 的线性化基础）
stoch_simul(order=1, irf=0, nograph, nocorr, nomoments);

// ⑤ 以下是内联 MATLAB 代码段——用直接赋值法运行 OccBin（见 §3）
% ... occbin.solver() 调用 ...
```

**五个关键位置顺序**：`occbin_constraints` → `shocks` → `occbin_setup` → `stoch_simul` → MATLAB 模拟代码。

---

## §1 `occbin_constraints` 块——命名约束 + bind/relax 条件

```dynare
occbin_constraints;
   // ZLB：影子利率触底时约束生效；留小缓冲防临界点伪周期解
   name 'ELB'; bind r_unc <= R_lb; relax r_unc > R_lb;
end;
```

- `name 'STRING'`：约束名，供 §2 的方程标签引用。
- `bind`（必填）：在**基线 regime** 下评估，判断约束是否进入起作用状态。
- `relax`（建议显式给）：在**约束 regime** 下评估，判断是否返回基线。
- 表达式**只能含当期内生变量**（含 lead/lag/外生须先造辅助变量）；变量是**水平值**，不是偏离稳态；取稳态值用 `STEADY_STATE()`。
- Dynare 支持最多 **两个** 约束。

---

## §2 model 块——regime 方程标签

每个约束需要**两条**版本不同的方程，共用同一个 `name`：

```dynare
// ✅ 正确：bind 和 relax 各一条，name 相同
[name='monetary policy', relax='ELB']
R_nom = r_unc;

[name='monetary policy', bind='ELB']
R_nom = R_lb;
```

> ⚠ **Dynare 7.1 强制要求**：`relax='ELB'` 必须显式写在独立方程上，**不能**用无标签方程
> 隐式充当基线 regime。否则预处理报：
> `"the regime corresponding to relax='ELB' is not defined"`
>
> **影子利率方程不加任何标签**，两个 regime 下均有效。

两约束时的标签规则：

```dynare
[name='foo', bind='IRR,INEG']   // 两约束都 bind
[name='foo', relax='IRR']        // IRR 不 bind（不论 INEG 状态）
[name='foo', bind='IRR', relax='INEG']  // IRR bind 而 INEG relax
```

---

## §3 运行模拟——推荐：直接调用 `occbin.solver()`

### 为什么不用 `occbin_solver;` 或 `shocks(surprise)`

Dynare 7.1 有两个已知问题：

1. **`shocks(surprise, overwrite)` 静默失效**：语法不报错，但冲击矩阵实际上写入的是全零，ZLB 永远不触发。
2. **`occbin_solver;` 命令**（Dynare 自带命令）依赖上述冲击块，同样失效。

**正确做法**：在 `stoch_simul` 之后的内联 MATLAB 代码里直接赋值并调用 MATLAB 函数：

```matlab
% stoch_simul 完成后，手动设置冲击序列并调用 OccBin
T_sim = 60;

shk = zeros(T_sim, M_.exo_nbr);
shk(1, find(strcmp(M_.exo_names,'eps_g'))) = 0.10;   % 第 1 期财政冲击

options_.occbin.simul.SHOCKS    = shk;                % ← 这是真正起作用的写法
options_.occbin.simul.endo_init = zeros(M_.endo_nbr, 1);  % ← 必须是 endo_nbr，不是 nspred

[~, out, ~] = occbin.solver(M_, options_, oo_.dr, oo_.dr.ys, oo_.exo_steady_state, []);
```

### 读取结果

```matlab
% out.piecewise  (T × M_.endo_nbr)：满足约束的分段线性解，水平值
% out.linear     (T × M_.endo_nbr)：忽略约束的纯线性解（对照）
% 列索引 = 变量声明顺序，用 find(strcmp(M_.endo_names,'y')) 定位

idx_y    = find(strcmp(M_.endo_names, 'y'));
idx_rnom = find(strcmp(M_.endo_names, 'R_nom'));

% ZLB 有效期
zlb_periods = find(abs(out.piecewise(:, idx_rnom) - R_lb) < 1e-5);
fprintf('ZLB 有效 %d 期\n', length(zlb_periods));
```

> ⚠ `endo_init` 大小：`DM.n_vars = M_.endo_nbr`（所有内生变量数），不是 `M_.nspred`（状态变量数）。
> 用错会在运行时报 `history(:,1) = init` 尺寸不匹配。

---

## §4 ZLB 财政乘数：双模拟模板

财政乘数 = ΔY / ΔG。**不能**从单次模拟算——同时有需求冲击时，`Y - Y_ss` 里混入了需求冲击的贡献，
得到的乘数可能为负。**必须两次模拟、差分消除需求冲击**：

```matlab
T_sim = 60;
ix_xi = find(strcmp(M_.exo_names, 'eps_xi'));
ix_g  = find(strcmp(M_.exo_names, 'eps_g'));

% Sim A：需求冲击（创造 ZLB 环境）+ 财政冲击
shk_A = zeros(T_sim, M_.exo_nbr);
shk_A(1:8, ix_xi) = -0.25;   % 8 期持续需求冲击（Eggertsson-Woodford 式，见下方选幅规则）
shk_A(1,   ix_g)  =  0.10;
options_.occbin.simul.SHOCKS    = shk_A;
options_.occbin.simul.endo_init = zeros(M_.endo_nbr, 1);
[~, out_A, ~] = occbin.solver(M_, options_, oo_.dr, oo_.dr.ys, oo_.exo_steady_state, []);

% Sim B：相同需求冲击，无财政冲击（控制组）
shk_B = zeros(T_sim, M_.exo_nbr);
shk_B(1:8, ix_xi) = -0.25;
options_.occbin.simul.SHOCKS = shk_B;
[~, out_B, ~] = occbin.solver(M_, options_, oo_.dr, oo_.dr.ys, oo_.exo_steady_state, []);

% 正确乘数
idx_y = find(strcmp(M_.endo_names, 'y'));
idx_g = find(strcmp(M_.endo_names, 'g'));
dG0   = out_A.piecewise(1, idx_g) - oo_.dr.ys(idx_g);   % 初期 G 增量

mult_zlb   = (out_A.piecewise(:,idx_y) - out_B.piecewise(:,idx_y)) / dG0;  % 含 ZLB
mult_nozlb = (out_A.linear(:,idx_y)    - out_B.linear(:,idx_y))    / dG0;  % 无 ZLB 对照
```

### ZLB 持续冲击幅度估算

单期需求冲击通过 AR(1) 衰减，往往不足以让 ZLB 持续多期。估算所需冲击幅度：

```
|ε_min| > (R_ss - R_lb) / |coeff(r_unc, eps_xi)|
```

其中 `coeff(r_unc, eps_xi)` 从决策规则矩阵读出（`eps_xi` 对 `r_unc` 的冲击系数，见 `oo_.dr.ghu`）。
要让 ZLB 持续 N 期，就连续施加 N 期意外冲击（Eggertsson-Woodford 2003 风格）。

示例参数（β=0.99, φπ=1.5, φy=0.5, R_lb=1.0）：
- R_ss − R_lb = 0.0101，冲击系数 = 0.0348
- 最小单期冲击幅度 ≈ −0.29；取 −0.25 × 8 期，ZLB 有效 12 期

---

## §5 六个坑（Dynare 7.1）

| # | 坑 | 症状 | 正确做法 |
|---|---|---|---|
| 1 | `shocks(surprise)` 静默失效 | shocks_sequence 全零，ZLB 从不触发，无报错 | 直接赋 `options_.occbin.simul.SHOCKS`（见 §3） |
| 2 | `endo_init` 大小写错 | 运行时 `history(:,1)=init` 尺寸不匹配 | `zeros(M_.endo_nbr,1)`，不是 `zeros(M_.nspred,1)` |
| 3 | `relax='ELB'` 未显式标注 | 预处理报 "regime for relax='ELB' is not defined" | 两条方程都显式标 `bind=`/`relax=`（见 §2） |
| 4 | 单期冲击不足以触发 ZLB | ZLB 有效期 = 0 | 连续 N 期施加意外冲击（见 §4 幅度估算） |
| 5 | `occbin_setup` 放到了 MATLAB 代码段 | 函数未定义或行为异常 | 放在 `stoch_simul` **之前**作为 Dynare 命令（见 §0） |
| 6 | 作图：ZLB 阴影先于数据画 | 纵轴被撑到 ±999，两条线无法区分 | 先 `plot` 数据，读 `ylim`，再 `patch` 阴影，最后 `uistack` |

---

## §6 带约束估计

```dynare
occbin_setup(likelihood_inversion_filter, smoother_inversion_filter);
estimation(smoother, heteroskedastic_filter, ...);
```

- **反演滤波**（`likelihood_inversion_filter`）：假设系统始于稳态；`varexo` 与 `varobs` 声明顺序必须一一对应。
- **分段 Kalman 滤波**（默认）：与单变量 Kalman `kalman_algo=2,4` 不兼容。
- ZLB 期间某冲击退出时：设对应观测为 NaN；分段 Kalman 还需用 `heteroskedastic_shocks` 把该冲击标准差设 0。
- 单位根模型加 `diffuse_filter`。

---

## §7 与 lmmcp/`⟂` 的取舍

| | OccBin | lmmcp（`⟂`） |
|---|---|---|
| 适用场景 | 随机模拟、含预期、可估计 | 完全预见确定性路径 |
| 约束数量 | 最多 2 个 | 不限 |
| 写法 | 需要写各 regime 方程 | 直接写不等式互补 |
| 参考 | `Guerrieri_Iacoviello_2015`（DSGE_mod） | perfect-foresight.md「lmmcp」 |

---

## §8 课程示例（Pfeifer Dynare Course，本地可跑，**首选参照**）

> 路径 `references/examples-code/Dynare_Course/Chapter_12_OccBin/`。同一个 NK + ELB 模型，用**三种**方式
> 处理同一个有效下限——这组对照是理解"该用哪条路"的最佳教材。`grep -i "occbin\|lmmcp\|ELB" references/catalog-code.csv`。

| 文件 | 处理 ELB 的方式 | 何时选它 |
| ---- | ----------------- | -------- |
| `NK_det.mod` | 完全预见里直接写带折点的泰勒规则 | 只想看一条确定性路径、约束写法最朴素 |
| `NK_det_mcp.mod` | `[mcp]` 方程标注 + `perfect_foresight_solver(lmmcp)` | 确定性、要把下界**精确**钉住（§7 lmmcp 列） |
| `NK_occbin.mod` | `occbin_constraints` + `occbin_setup`/`occbin_solver` + `bind=`/`relax=` 标签 | 要随机模拟/含预期/可估计（§0–§2 的标准 OccBin 结构；**运行路径见下方注意**） |

读这组时按 `NK_det → NK_det_mcp → NK_occbin` 的顺序看：能清楚看到从"手写折点"到"互补松弛"再到"分段线性
工具箱"的递进，以及每一步多解决了什么（精确钉住下界 → 支持随机/预期）。`NK_occbin.mod` 的
**约束声明与 regime 标签成对写法**（一 `bind` 一 `relax`、共用 `name`）正是 §0–§2 教的标准结构，
照它对齐标签最不容易错。
> ⚠ **但它的运行用的是 `shocks(surprise);` + `occbin_solver(...)`——正是 §3 指出在 Dynare 7.1 下会
> 静默失效（冲击矩阵写成全零、约束从不触发）的那条路。** 照搬它的标签结构，但实际跑模拟时改用 §3 的
> 直接赋值 `options_.occbin.simul.SHOCKS` + 调用 `occbin.solver(...)`（§0 骨架第⑤步就是这么写的）。
