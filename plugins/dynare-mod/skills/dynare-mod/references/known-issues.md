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
