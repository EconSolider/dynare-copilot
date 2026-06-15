# 已知坑与修法（排错日志 · 随用随长）

> **何时读**：遇到 Dynare/MATLAB 报错或可疑结果时，**先扫这里**——按现象快速命中已踩平的坑，
> 命中就直接照修法改、别从头推。这是「实战踩坑日志」，与 `debugging.md` 分工：
> debugging.md 教你**怎么诊断**通用/结构性报错（BK、稳态、奇异雅可比、语法）并给最终检查清单；
> 本文件记**具体踩过的坑 → 现成修法**，随用随长。
>
> **如何追加（encode-back，见 `debugging.md`「bug 处理协议」第3步）**：凡 skill 里查不到、你自己
> 新定位并解决的报错，解决后在本文件追加一条，沿用下方条目格式：**现象 → 根因 → 修法（带代码）
> → 详见（某 reference 有更深入处理时）**。判定 novel：debugging.md 与本文件都查不到对应条目。
> **拿不准就追加，重复比遗漏代价小。**
>
> **关键习惯：解决的当下就把"回写本条"列进 TodoList**（趁现象/根因/修法还在眼前），别等收尾——
> 收尾时经验已模糊、且易被"任务完成"挤掉，这正是本日志长不起来的根因。SKILL.md §3 已把它列为
> 建模任务的固定收尾 TodoList 项，与归档询问并列。

---

## 过去的杂项（历史积累）

> 截至 2026-06，HANK 财政等任务中踩平的零散坑，按现象排列。后续新坑直接往下追加。

### heterogeneity_solve 崩在 `eq` 未定义 / `process_jacobian_block`
- **现象**：Dynare 7.1 异质性模型跑 `heterogeneity_solve` 崩溃，栈停在 `process_jacobian_block`，报 `eq` 未定义。
- **根因**：总量层有「只带滞后出现」的 varexo（如泰勒规则用 `rstar(-1)` 加实施滞后），其辅助方程行号 > `M_.orig_endo_nbr`；`heterogeneity_solve` 用 `find()` 列优先遍历雅可比，若该 varexo 在 `varexo` 块声明在前，辅助行抢先于常规方程项被遍历，`eq` 未赋值即被引用。
- **修法**：把任何「只带滞后出现」的 varexo 声明在 `varexo` 块**最后**（`varexo G TR markup rstar;`，rstar 殿后），与官方 `hank_one_asset.mod` 一致。
- **详见**：`heterogeneity.md`「常见报错与陷阱」（含根因展开与正/反例）。

### 非异质模型 `disp_dr` / `subst_auxvar` 崩（"索引生成 2 个值" / "list of 2 values"）
- **现象**：含 `rstar(-1)` 之类 lagged varexo 的**普通**模型跑 `stoch_simul`，打印政策函数时崩，报「索引生成 2 个值」。
- **根因**：lagged varexo 建滞后辅助变量，`disp_dr` 里 `subst_auxvar` 查 `M_.aux_vars` 命中 2 条。
- **修法**：把 lagged varexo 改写成由创新项驱动的 AR(1) 内生变量，规则里用其当期值：
  ```dynare
  var rstar_sh; varexo eps_rstar;
  [name='Taylor rule'] (1+r_ss+rstar_sh+phi*pi)/(1+pi(+1)) - 1 - r;
  [name='MP shock AR(1)'] rstar_sh - rho_r*rstar_sh(-1) - eps_rstar;
  ```
  （注意：同一 lagged varexo 在**异质性**框架下改崩在 `heterogeneity_solve`，修法不同——见上一条。）

### 取 IRF 取到空 / `无法识别的字段 "irf"`
- **现象**：后处理脚本 `oo_.irf.Y_G` 报字段不存在。
- **根因**：`stoch_simul` 的 IRF 字段是 `oo_.irfs`（**复数带 s**），不是 `oo_.irf`。
- **修法**：用 `oo_.irfs.<var>_<shock>`；拿不准先 `disp(fieldnames(oo_))` 核对。异质性框架的 IRF 又在别处（见下条）。

### HANK 的 IRF 不在 `oo_.irfs`
- **现象**：异质性模型跑完，`oo_.irfs` 里找不到 IRF。
- **根因**：`heterogeneity_solve` 把总量动态存成序列空间雅可比 `oo_.heterogeneity.dr.<shock>.<var>.<shock>`（T×T）。
- **修法**：对一次性冲击（t=1）的 IRF = 该矩阵**第一列**：`oo_.heterogeneity.dr.G.Y.G(:,1)`（每单位冲击，乘冲击幅度缩放）。**详见** `heterogeneity.md`「IRF 取数」、`matlab-workflow.md`。

### 自写分析/绘图脚本报 `未定义函数 'range'`（工具箱依赖）
- **现象**：分析/绘图脚本在某些机器上崩，报 `range` 未定义。
- **根因**：`range`（值域）属 Statistics Toolbox，未必每台机都装。
- **修法**：用 base MATLAB 替代——值域 `diff(ylim)` 或 `max(x)-min(x)`。自写后处理优先用 base 函数，少依赖工具箱。

### 纯 varexo 在稳态被当正值 → 稳态残差非 0
- **现象**：政府预算等方程的稳态残差不为 0（模型不报错，但 `resid;` 显示某条非零）。
- **根因**：`G`、`TR` 等**纯 varexo**（非 AR 内生过程）稳态值 = 0，却在稳态方程里按正值代入。
- **修法**：`Tax = r*B + G + TR` 的稳态写 `Tax_ss = r_ss*B`（因 G=TR=0），不要 `+ G_ss + TR_ss`。

### 财政乘数画出来 ≈ 0.01（静默错误，无报错）
- **现象**：RANK 平衡预算政府支出乘数算出来 ≈ 0.01，模型干净跑完、无任何报错。
- **根因**：后处理口径错——归一化漏乘稳态份额 `1/g_y`、把百分比 IRF 当成绝对量之比、或 `Scale` 多除了 100。平衡预算 G 乘数解析上应 ≈ 1。
- **修法**：求解后先 `fprintf` 打出乘数与解析基准（平衡预算 G≈1、李嘉图 TR=0）对一眼再信图。**详见** `debugging.md`「数值结果可疑但无报错」、`matlab-workflow.md`「拿解析基准即时校验」。

### 完全预见求解失败：奇异雅可比（来自含 `x(-1)` 的前瞻资产定价块）
- **现象**：`perfect_foresight_solver` 跑满 `maxit`、homotopy 各份额全 `failed`，反复报「矩阵在工作精度内为奇异的 / Matrix is singular to working precision」（`lin_solve`→`sim1`），最终 `Failed to solve perfect foresight model`。`check;` 阶段其实已现端倪：特征根表里有 ~1e17–1e51 量级的**巨大伪特征根**，但 BK 秩条件仍「verified」，容易被放过。
- **根因**：某条**前瞻资产定价方程**同时含超前与上一期价格、形如永续债 `RL = (1+kappa_L*QL)/QL(-1)` 配 `1+zeta = betta*E[(C(+1)/C)^(-sigma)*RL(+1)]`。这种 `QL(-1)` 递归在堆叠系统里制造近乎无穷的广义特征根，雅可比奇异。ZLB/lmmcp 不是病根——去掉 lmmcp 的纯情景同样失败即可定位到此块。
- **修法**：先判断该块**是否对实体经济反馈**。若只是「报告用」的长端利率/期限结构（QE 的真实传导走 `zeta → 资本欧拉 → 投资`，长债不进任何实体方程），别纠缠数值技巧——直接把整块**约简成静态恒等式**，例如长端名义利率 `RL = R*(1+zeta);`，删掉 `QL`/前瞻欧拉。奇异性即消，求解器数次迭代收敛；且 ZLB 下 `R` 锁定，`RL` 只随 QE 压低的 `zeta` 而动，故事反而更干净。
- **通用判据**：含 `x(-1)` 的前瞻方程在完全预见下极易奇异；**对实体不反馈的块，约简优先于调参**。若该块必须保留动态（真有反馈），改用「价格水平差分辅助变量」或 `model(..., differentiate_forward_vars)` 帮助收敛（见 `perfect-foresight.md`「奇异雅可比」「永久冲击便捷开关」）。

### 参数初始化报 `Namespace-qualified symbol pp.x not allowed in this context`
- **现象**：`.mod` 里想用 MATLAB 工作区里算好的参数（如外部脚本算了一堆派生/稳态系数），写
  `alppha = pp.alppha;`（`pp` 是 struct）或在 `shocks` 块写 `var eps = pp.sig^2;`，预处理直接报
  `Namespace-qualified symbol pp.alppha not allowed in this context`。
- **根因**：Dynare 预处理器在参数初始化/`shocks` 块**不接受结构体字段访问**（`a.b` 形式）作为右值；
  它只认裸标识符或数字字面量。把 workspace struct 字段塞进 RHS 一定挂。
- **修法**：让驱动脚本把所有要注入的参数**写成一个数值 include 文件**，`.mod` 用 `@#include` 拉进来：
  ```matlab
  % run_model.m：算完所有 deep+派生参数后
  fid=fopen('model_params.inc','w');
  for k=1:numel(names), fprintf(fid,'%s = %.15g;\n', names{k}, eval(names{k})); end
  fclose(fid);
  dynare model.mod noclearall
  ```
  ```dynare
  parameters alppha betta ... sig_z ...;   // 先声明
  @#include "model_params.inc"             // 数值字面量逐行赋值
  ...
  shocks; var eps_z = sig_z^2; end;        // 用已声明的参数，不用 pp.sig_z
  ```
  这样 RHS 全是数字字面量/已声明参数，预处理通过。需要 fzero/normcdf 等求的稳态系数也在驱动里算好再写进 .inc。

### 线性 SW/估计类模型 IRF 量级差 100 倍（变量与 σ 都是"百分点"单位）
- **现象**：复现 Smets-Wouters / FRBNY 型估计模型，IRF 用 `plot_irfs_pub` 默认 `Scale=100` 画出来
  投资掉 180%、产出掉 30% 等离谱量级；但 BK、稳态全过，纯量级不对。
- **根因**：这类论文的度量方程是 `obs = 100*(model var)`，即模型变量是**小数对数偏离**，而 Table 里
  报的 σ（0.05–3）是**百分点**单位的创新。若直接 `var eps = sigma^2`（把百分点当小数）变量就被放大
  100 倍；`plot_irfs_pub` 默认 `Scale=100`（假设变量是小数→转百分比）再乘一次。两种自洽口径只能选一：
  ① 变量小数 + 创新 `sigma/100` + 画图 `Scale=100`；② 变量百分点 + 创新 `sigma`（原值）+ 画图 `Scale=1`。
- **修法**：选定一种口径并自检——1 个标准差**货币冲击**产出应降约 0.3–0.6%、政策利率升约 0.1–0.2pp。
  达不到这个量级先怀疑 100 倍口径错。最省事：保留 σ 原值（变量即百分点），`plot_irfs_pub(...,'Scale',1)`。
- **通用判据**：度量方程带 `100*` ⇒ 模型变量是小数；σ 报在 0.1–3 量级 ⇒ 百分点。两者口径必须配齐，
  画图 `Scale` 跟着变量口径走（小数→100，百分点→1）。**详见** `publication-plots.md`「Scale 参数」。

### BGG/CMR 金融摩擦稳态系数（ζ_nRk 等）——别手推，照抄 DSGE.jl 公式数值求解
- **现象**：复现含 BGG/Christiano-Motto-Rostagno 金融摩擦的模型（外部融资溢价、企业家净值、利差方程），
  净值演化方程的一堆 ζ 系数（`zeta_nRk/zeta_nR/zeta_nqk/zeta_nn/zeta_nsigw/zeta_spsigw`）从论文正文
  推不出来——论文只给约简型线性方程，ζ 是更深的成本状态核查（CSV）稳态的函数。
- **根因**：ζ 系数由 BGG 稳态隐式决定：给定违约概率 `Fstar`、存活率、稳态利差 `spr`、利差-杠杆弹性
  `zeta_spb`，先 `fzero` 解出 σ_ω，再代入一组 Γ/G/导数公式。手推极易错。
- **修法**：直接把 **FRBNY DSGE.jl m990** 的两段源码翻成 MATLAB 辅助函数（不用上网搜公式）：
  `financial_frictions.jl`（`zeta_spb_fn/zeta_bw_fn/zeta_zw_fn/nk_fn/mu_fn/G/Gamma/各阶导数`）+
  `m990.jl` 的 `steadystate!`（ζ_n* / ζ_sp* 网worth 演化系数）。在驱动脚本里 `fzero` 求 σ_ω、算全部 ζ，
  写进 `.inc`（见上面 `@#include` 条）。稳态自检：违约概率应 = `Fstar`、`nk*`（净值/资本）落 0.4–0.8、
  `r_k* ≈ 0.03–0.04`（标准季度租金率）。`spr` 取**毛季度利差** `(1+SP_annual/100)^(1/4)` 或 `1+SP/400`。
- **通用判据**：约简型线性 FF 方程的系数推不动时，先找该模型的**权威代码实现**（DSGE.jl / Dynare 复制档）
  逐条转写，比从论文反推快且不易错。**详见** `catalog-lookup.md`（编程逻辑库 + 权威实现优先）。
