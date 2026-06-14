# 估计（贝叶斯 & 极大似然）

> **何时读**：任务含估计/贝叶斯/先验/MCMC/极大似然/数据，命令族 `estimation`。**本文件回答**：观测方程写法（增长率优先）、estimated_params 先验语法、estimation 选项、MCP 运行注意。**配套必读**：steady-state.md。

Dynare 通过 Kalman 滤波从可观测变量数据估计模型参数，支持极大似然或贝叶斯
MCMC（Metropolis-Hastings）。

**随机奇异性规则**：可观测变量个数 ≤ 冲击数 + 测量误差数，否则似然退化。

顺序：`varobs` →（可选 `observation_trends`）→ `estimated_params` → `estimation(...)`。
这里**正确且高效的稳态**比模拟更重要——Dynare 在每个参数抽样点重算稳态，强烈建议写
`steady_state_model` 块（见 `references/steady-state.md`）。

## 观测变量与观测方程

```dynare
varobs y_obs pi_obs r_obs;   // 名字须与数据文件的列/序列名一致
```

- 全文件只能有**一个** `varobs`；所列变量须为内生且与数据列名匹配。
- 模型里要有**观测方程**把模型变量映射到数据。这是估计**最大的出错来源**——均值/趋势/
  人均/增长率必须两端一致（Pfeifer《观测方程指南》核心）。

### 观测方程最佳实践（Pfeifer 指南要点）

1. **优先用增长率**作观测方程，其稳态为 0、对去趋势方式稳健：
   ```dynare
   [name='output growth observation eq.']
   y_obs = log_y - log_y(-1);     // 需先有 log_y = log(y);
   ```
   配合 `steady_state_model` 里 `y_obs = 0;`。
2. **数据与模型变量定义一致**：若数据是人均、季度、去通胀的，模型变量也要对应；常数项
   （如稳态增长率 `gamma`）要显式加进观测方程：`y_obs = log_y - log_y(-1) + gamma;`。
3. **demean 的选择**：`prefilter=1` 让 Dynare 对每条序列去均值（适合 level 形式且模型
   稳态非零时）；用增长率观测方程时通常**不需要**再 demean。
4. **`loglinear` 与 `logdata` 要配套**：`loglinear` 会同时对模型和数据取对数（假设数据是
   原始非对数水平、稳态严格为正）；若数据已是对数，加 `logdata`。

## 估计参数与先验

```dynare
estimated_params;
// 参数,    初值,   下界,   上界,   先验形状,      先验均值, 先验标准差[, p3, p4];
   alppha,        0.30,           ,        ,  beta_pdf,      0.30,    0.05;
   rhoz,          0.80,    0,      0.999,     beta_pdf,      0.80,    0.10;
   stderr eps_z,  0.01,    0,      ,          inv_gamma_pdf, 0.01,    inf;
   corr eps_z, eps_g,  0,  -1, 1,             normal_pdf,    0,       0.2;
end;
```

每行首 token 选择估计对象：
- `参数名`——模型参数。
- `stderr 变量名`——外生冲击的标准差**或**某可观测内生变量测量误差的标准差。
- `corr 变量1, 变量2`——相关系数（界自动设为 [-1, 1]）。
- `skew 变量名`——偏度（冲击变为偏正态）。

名字之后的字段：
- **极大似然 / 矩方法**：`名字, 初值 [, 下界, 上界];`
- **贝叶斯 MCMC**：`名字 [, 初值 [, 下界, 上界]], 先验形状, 先验均值, 先验标准差 [, p3 [, p4 [, scale]]];`
- `初值` 是优化器起点（省略则取先验均值）。
- 贝叶斯下 `下界`/`上界` **只**约束众数优化器，不改变先验形状（除非用 p3/p4 平移分布支撑）。

先验形状：`beta_pdf`、`gamma_pdf`、`normal_pdf`、`uniform_pdf`、`inv_gamma_pdf`
（=`inv_gamma1_pdf`）、`inv_gamma2_pdf`、`weibull_pdf`。

惯例：(0,1) 区间参数（自相关、份额）用 `beta_pdf`；标准差（正、右厚尾）用 `inv_gamma_pdf`；
无界/正的结构参数用 `normal_pdf` 或 `gamma_pdf`。要在 [-1,1] 上给相关系数一个广义 beta，
设 p3=-1、p4=1。

相关块（同样的行语法）：
- `estimated_params_init;`——覆盖优化器起点（放在 `estimated_params` **之后**；选项
  `use_calibration` 用校准值播种）。
- `estimated_params_bounds;`——ML 的界。
- `estimated_params_remove;`——移除先前加入的参数（模块化模型）。
- 再来一个 `estimated_params(overwrite);` 会替换整张列表（一份文件跑多次估计时有用）。

**参数变换技巧**：要估计某模型参数的变换，把模型参数留在 `parameters`，用 `#` 模型局部
变量定义、变换写进模型，把模型参数放进 `estimated_params`。

## `estimation` 命令

```dynare
estimation(
   datafile = 'mydata.csv',   // .m .mat .csv .xls/.xlsx；basename 须 ≠ mod 文件名
   first_obs = 1,
   nobs = 200,
   mode_compute = 5,          // 众数/MLE 优化器
   mh_replic = 20000,         // MCMC 抽样数（0 = 只求众数，不跑 MCMC）
   mh_nblocks = 2,            // 并行链数（≥2 启用 Brooks-Gelman 诊断）
   mh_jscale = 0.3,           // 调到接受率 ≈ 0.23–0.33
   mh_drop = 0.5,             // 预热比例
   order = 1
) y_obs pi_obs r_obs;          // 报告后验对象的变量列表
```

关键选项：
- **数据**：`datafile`、`first_obs`、`nobs`、`xls_sheet`、`xls_range`、`presample`
  （训练样本，不进似然）、`prefilter=1`（去均值）、`loglinear`、`logdata`。
- **优化**：`mode_compute`（4=默认 csminwel；5=Marquardt 型 newrat；6=蒙卡；9=CMA-ES；
  0=跳过、载入 mode 文件）、`mode_file`、`mode_check`（在众数附近画似然）。
- **MCMC**：`mh_replic`、`mh_nblocks`、`mh_jscale`、`mh_drop`、`mh_init_scale`、
  `load_mh_file`（续跑）。
- **贝叶斯输出**：`bayesian_irf`、`moments_varendo`、`conditional_variance_decomposition`、
  `forecast=整数`、`smoother`、`filtered_vars`。
- **先查识别**：跑 `identification;` 和 `sensitivity;` 再开长 MCMC。

接受率调参：目标约 1/4–1/3，偏离太远就停下调 `mh_jscale`。Dynare 的 MCMC 默认确定性
（种子 0）；要在多次运行间变化提议序列，在 `estimation` 前加 `set_dynare_seed('clock');`。

## 测量误差

通过 `shocks` 块对**可观测内生**变量声明（须在 `varobs` 之后）：
`var y_obs; stderr 0.001;`；或在 `estimated_params` 里用 `stderr y_obs` 估计它。

## MATLAB MCP 运行注意

- 估计会读外部数据文件——通过 MCP 确认数据文件在工作目录、列名与 `varobs` 一致。
- 长 MCMC 很慢；调试阶段先用 `mh_replic=0`（只求众数）或很小的 `mh_replic` 快速验证
  设定正确，再交给用户跑完整链。
- 跑完用 MCP 读 `oo_.posterior_mean`、`oo_.MarginalDensity`、`oo_.posterior_hpdinf/hpdsup`
  核对结果。

## 估计文件骨架

```dynare
var ...; varexo ...; parameters ...;
// 校准“不估计”的参数；被估计的参数随便给个值
model; ...
[name='output growth observation eq.'] y_obs = log_y - log_y(-1);
...
end;
steady_state_model; ...  y_obs = 0; ... end;   // 强烈建议
resid; steady; check;

varobs y_obs pi_obs r_obs;

estimated_params;
   ...
end;

estimation(datafile='data.csv', mh_replic=20000, mh_nblocks=2, mode_compute=5)
   y_obs pi_obs r_obs;
```

参考 DSGE_mod：`Smets_Wouters_2007`（完整中型 DSGE 估计）、`Ireland_2004`（极大似然）、
`RBC_baseline_first_diff_bayesian`（增长率观测方程的最小贝叶斯例子）、
`GarciaCicco_et_al_2010`（小型开放经济估计）。

---

## 课程示例（Pfeifer Dynare Course，本地可跑，**首选参照**）

> 路径 `references/examples-code/Dynare_Course/Chapter_05_Kalman_ML/`（滤波/平滑、ML）与
> `Chapter_06_Bayesian/`（贝叶斯 MH）。同一个 RBC 贯穿两章，便于对照不同估计法。
> `grep -i "calib_smoother\|estimation\|mh_jscale\|estimated_params" references/catalog-code.csv`。
> 数据文件 `first_diff.mat` 已随同复制（一阶差分观测）。

| 文件 | 教什么（grep 命中点） |
| ---- | --------------------- |
| `Chapter_05_Kalman_ML/RBC_smoother.mod` | `calib_smoother(datafile=,filter_step_ahead=[1,4])`：**不估计、只对校准模型跑 Kalman 滤波/平滑**取状态；`steady_state_model` 里反解 `betta/delta/psi` 命中目标比率 |
| `Chapter_06_Bayesian/RBC_Bayesian.mod` | 完整 MH：`estimated_params` + `estimated_params_init(use_calibration)` + `estimation(mh_replic,mh_nblocks,smoother,moments_varendo,raftery_lewis_diagnostics,bayesian_irf,forecast=8,tex)` |
| `Chapter_06_Bayesian/RBC_high/medium/low_acceptance.mod` | **同模型只改 `mh_jscale`**（0.2 / 1.5 / 3.5），演示 MCMC 接受率怎么被提案步长决定 |

**课程补的关键实务——调 MH 接受率（手册只给选项、不讲怎么调）**：
随机游走 Metropolis-Hastings 的接受率应落在 **约 25–35%**（高维偏低端）。唯一的调节钮是
`mh_jscale`（提案分布标准差的缩放）——方向是反的：

| `mh_jscale` | 提案步长 | 接受率 | 症状 |
| ----------- | -------- | ------ | ---- |
| 太小（0.2） | 小碎步 | **过高** | 链挪不动、自相关高、有效样本少 |
| 合适（~1.5）| 适中 | ~25–35% | 健康混合 |
| 太大（3.5） | 大跳 | **过低** | 频繁被拒、链"卡住"不动 |

实操：先短跑看 `Acceptance ratio`，按上表反向调 `mh_jscale` 再正式长跑；Dynare 也可 `mode_compute` 后用
`mh_tune_jscale` 自动整定。三个 `*_acceptance.mod` 就是让你把这三种情形各跑一遍、亲眼看链的差别。

`calib_smoother` 的另一大用途是**接力预测**：跑完它用 `smoother2histval` 把平滑末态写进 `histval` 再
`forecast`（见 forecasting.md 课程示例 `rbc_basic_calib_smoother.mod`）。

参考 DSGE_mod：`Smets_Wouters_2007`（完整中型 DSGE 估计）、`Ireland_2004`（极大似然）、
`RBC_baseline_first_diff_bayesian`（增长率观测方程的最小贝叶斯例子）。

---

# 手册增补（Dynare 7.1 §4.8/4.16）

- **测量误差/异方差**：`heteroskedastic_shocks` 块在估计期逐期改某冲击标准差，`values`（直接给）
  或 `scales`（按因子缩放 `std0*scale(t)`）；与 `analytic_derivation` 不兼容。
- **混合确定性/随机**：`varexo_det tau;` + 完全预见 `shocks` 给 tau 路径 → `stoch_simul(irf=0);
  forecast;`（agent 从一开始就知道未来确定性变化）。
- 估计输出读：`oo_.posterior_mean`、`oo_.MarginalDensity`、`oo_.posterior_hpdinf/hpdsup`。
- 预处理器 `params_derivs_order=0|1|2` 控制对参数求导阶（identification/estimation 用）。
