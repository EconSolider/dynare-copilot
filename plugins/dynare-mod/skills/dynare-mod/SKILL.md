---
name: dynare-mod
description: 编写、运行、调试和审查 Dynare 的 .mod 模型文件（DSGE、RBC、新凯恩斯、OLG 等宏观模型）。当用户想创建 .mod 文件、把论文或模型方程翻译成 Dynare 语法、复制某篇论文的模型（如"复制 Smets-Wouters 2007"、"按 GK 2011 写"）、搭建 stoch_simul / 完全预见(perfect foresight) / 贝叶斯或极大似然估计 / 矩方法(GMM/SMM/IRF 匹配) / 冲击分解 / 预测(含条件预测) / 识别与敏感性分析 / MS-SBVAR 区制切换 / 异质主体(HANK) / Ramsey 或 OSR 最优政策 / ZLB 有效下限或借贷抵押等偶尔约束(OccBin) 实验、用宏处理器(@#)写多国/多部门/变体模型、编写 steady_state_model 稳态块，或调试 Dynare 报错（Blanchard-Kahn、奇异雅可比、稳态残差、时序问题）时，都使用本 skill。即使用户只是贴出模型方程说"写成 Dynare 代码"，或提到 stoch_simul、perfect_foresight_solver、estimation、method_of_moments、shock_decomposition、forecast、identification、markov_switching、heterogeneity、ramsey_model、occbin、varexo、initval 等关键词，也要触发——不要仅凭记忆写 Dynare，时序约定和块语法极易写错。遇到不熟悉的模型本 skill 会先上网检索论文原文与现成 Dynare 实现再动笔，并在写完后通过 MATLAB MCP 在 VSCode 中自动运行 Dynare 循环纠错。
---

# 编写与调试 Dynare .mod 文件

`.mod` 是 Dynare 预处理器的**独立语言**，不是 MATLAB。两类失误会**静默产生错误结果**
（而非干净报错）：**时序约定错误** 和 **稳态不一致**——所有检查围绕这两点展开。

本文件是 always-on 主干（精简）。各步细节按需读 `references/` 对应文件，不要把它们的内容
预先全部拉进上下文。

## 执行准则：落笔前先把建模选择定死（针对最常见失误）

最贵的错误来自**结构性建模选择**写错——劳动供给同/异、含不含资本、厂商一层/两层、市场结构、
含哪些财政/金融模块、有哪些冲击。这类选择一旦写进方程，错了往往要整段乃至整文件重写；而问用户
一句、等一个回答成本极低。**正是这种不对称决定了：在选择没定死之前就开写，是本 skill 最该避免的
失败，而不是一种勤奋。** 把待定选项连同你的推荐抛给用户、等回答，**本身就是合格的可见产出**；
在没定下的分叉上继续往下写，那才是真正的空转。

为此设两道硬闸门。到了闸门就**停下 → 把待定项连同推荐作为可见文本输出 → 结束本轮 → 等用户回答**
（不替用户拟答案、不绕过提问继续写）：

- **闸门1：写任何 var 声明 / 方程之前。** 逐项列出本模型的结构性选择，核对每项"用户是否已明确、
  或所点名论文是否已定死"。**只要有一项悬空，你就没有资格替用户默选**——把全部未定项一次性抛给
  用户（用选项让他快选）。已点名论文 / 已给完整方程 / 用户本轮已讲清 → 跳过。（即第1.5步）
- **闸门2：阶段1 推导写完、动 .mod 之前。** 把推导 md 交付用户、停下等确认。**先把数学做对再翻成
  代码**——错在数学层面就该在这里被你我拦住，而不是等跑出错误 IRF 才发现。**别写完推导顺手把 .mod
  一起写了**：这正是"暂停不足"最常发作的地方。

**一句话判据**：这个选择会改变方程的结构吗？会 → 走闸门、停下问；不会（只是写法/形式：R8 非线性、
命名 R5、log_x 辅助变量、`[name=]` 标注等）→ 按规则直接做，不要为它停下。除两道闸门与第3步
（信息不全）外，各步一律持续产出、不停顿。

## §1 硬规则 R1–R8（违反任一 = 文件失败，写每一行都对照）

| # | 规则 | 正例 / 反例 |
|---|------|------------|
| R1 | **注释一律中文；注释以外一律英文/ASCII**。`long_name`、`[name=]`、标识符、字符串禁止中文 | ✅ `[name='Euler equation']` 上方加 `// 欧拉方程`；❌ `[name='欧拉方程']` |
| R2 | **时序 = 决定期**（期末存量）。状态变量当期带滞后；运动律左边是期末存量 | ✅ `y=...k(-1)...` 与 `k=invest+(1-delta)*k(-1);`；❌ 生产函数里写 `k` |
| R3 | **varexo 只放创新项**；持续过程（AR 等）是内生变量 | ✅ `var z; varexo eps_z;`；❌ `varexo z;` |
| R4 | **方程数 = 内生变量数**（例外：`ramsey_model`/`discretionary_policy` 少 1 条） | 写完模型块数一遍 |
| R5 | **禁用命名**：`i`、`inv`、`e`、`E`、Dynare 命令/MATLAB 函数名；希腊字母写 `alppha`/`betta`/`gam`；投资写 `invest` | ❌ `var i;`；❌ `parameters beta;` |
| R6 | **随机情形禁用** `max/min/abs/sign/比较算子`（摄动在拐点给错误导数）；完全预见可用 | 偶尔约束 → OccBin，不是 `>=` |
| R7 | 每条语句 `;` 结尾、每块 `end;` 结尾、一行一条；参数先赋值后用 | 未知行首会被当原生 MATLAB |
| R8 | **非线性优先**：默认写原始非线性方程组（FOC/约束/外生过程），让 Dynare 做泰勒展开，不手推线性化。**仅两种情况写线性化**并 `model(linear);`：① `discretionary_policy`（Dynare 技术要求）；② 用户明确要线性版或复制的论文只给线性化系统 | ✅ 非线性 RBC 用原始 FOC；`discretionary_policy` 用 `model(linear);` |

## §2 任务路由（判型 → 读对应参考，然后才动笔）

| 信号词 | 任务 | 命令族 | 必读参考 |
|--------|------|--------|----------|
| IRF、矩、方差分解、"模拟这个 DSGE/RBC/NK" | 随机模拟 | `stoch_simul` | `references/stochastic-simulation.md` |
| 过渡路径、永久冲击、确定性、完全预见 | 完全预见 | `perfect_foresight_*` | `references/perfect-foresight.md` |
| 估计、贝叶斯、先验、MCMC、极大似然、数据、varobs | 估计 | `estimation` | `references/estimation.md` + steady-state.md |
| 矩方法、GMM、SMM、模拟矩、IRF 匹配、匹配矩校准 | 矩方法估计 | `method_of_moments` | `references/moments-method.md` + estimation.md |
| 冲击分解、历史分解、哪个冲击驱动、实时分解、初始条件分解 | 冲击分解 | `shock_decomposition`/`realtime_*`/`plot_*`/`initial_condition_decomposition` | `references/shock-decomposition.md` |
| 预测、外推、条件预测、约束某变量未来路径、扇形图 | 预测 | `forecast`/`conditional_forecast`/`conditional_forecast_paths` | `references/forecasting.md` |
| 识别、能否识别、估计前查识别、敏感性/GSA、IRF/矩校准先验 | 识别与敏感性 | `identification`/`sensitivity` | `references/identification.md` |
| 区制切换、Markov switching、结构 BVAR、SBVAR、SWZ、时变波动/系数 | MS-SBVAR | `markov_switching`/`svar`/`sbvar`/`ms_*` | `references/ms-sbvar.md` |
| 异质主体、HANK、Krusell-Smith、连续分布家庭、SSJ、一/两资产 HANK | 异质性 | `heterogeneity_dimension`/`heterogeneity_*` | `references/heterogeneity.md` |
| 最优政策、Ramsey、相机抉择、福利、简单规则 | 最优政策 | `ramsey_model`/`discretionary_policy`/`osr` | `references/optimal-policy.md` |
| ZLB/有效下限、抵押/借贷约束、不可逆投资、偶尔约束 | 偶尔约束 | `occbin_*` 或完全预见 `lmmcp`/`⟂` | `references/occbin.md`（确定性单约束亦见 perfect-foresight.md「lmmcp」）|
| —（几乎都涉及） | 稳态 | `steady_state_model`/`initval` | `references/steady-state.md` |
| 多国、多部门、变体切换、@#、循环生成方程 | 宏处理器 | `@#define/@#if/@#for` | `references/macro-processor.md` |
| 报错、跑不通、BK 不满足、稳态求不出 | 排错 | 诊断命令 | `references/debugging.md` |
| 好看的图、顶刊/发表级 IRF、导出 PDF 论文图、多情景/多冲击对比、置信带 | 发表级绘图 | `plot_irfs_pub.m`（替代自带画图） | `references/publication-plots.md` |
| 需要现成骨架 | 模板 | — | `references/templates.md` |
| 主流程任一步的细节（暂停点/检索/分阶段构建/闭环/骨架/细则） | 流程 | — | `references/workflow-detail.md` |
| 写阶段1 推导文件的结构与公式规范 | 推导规范 | — | `references/derivation-style.md` |
| 各主体最优化问题/FOC 怎么推、有哪些会改方程结构的变体 | 建模逻辑 | — | `references/modeling-blocks.md` |

接近 [DSGE_mod](https://github.com/JohannesPfeifer/DSGE_mod) 某论文（Galí 2015、SW 2007、
RBC_baseline、SGU 2003 等）→ 以其 `.mod` 为模板。模型不熟/用户点名没把握的论文 → 先走第3步检索。

## §3 主流程（按序执行，不跳步；每步 = 一个 TodoList 条目）

**先列 TodoList 再动手**（优先用 TodoWrite 工具；否则用 markdown 复选框 `- [ ]`→`- [x]`，
每阶段完成后重发）。中途冒出新问题 → 向清单追加新项。

```
第1步   判型：对照 §2 定任务类型与模型类别；贴论文方程时先标状态(带滞后)/控制(跳跃)。
第1.5步 ⏸ 逐主体确认特征 + 建模选择（即闸门1）：搭主体前先问用户各主体（家庭/厂商/央行/政府/银行…）
        的特征，**以及任何会影响方程结构的分叉**（劳动供给同/异？含资本否？市场结构？）。
        把这些做成一份选择题（带你的推荐）一次性抛给用户，提问后停下等回答。
        （形式不必问：R8 默认非线性。）已点名论文/已给完整方程/已讲清 → 跳过。详见 workflow-detail.md。
第2步   读参考：读 §2 指定的参考文件（含 steady-state.md）。
第3步   知识判定：对模型没十足把握（"大概记得"=不会）→ 实际调用 web 搜索查论文原文与
        现成 Dynare 实现，提取方程组/校准/时序/冲击四样；缺关键信息 ⏸ 停下问用户。
        教科书标准件且有把握 → 直接第4步。详见 workflow-detail.md。
第4步   增量构建（绝不一次写完再跑，每阶段跑通/确认才往下写）。
        **核心：阶段2起写 .mod 时全程打开阶段1 的推导 md，对照逐条翻译（变量照第8节、方程照
        第2–5节 FOC、稳态照第6节），不凭记忆重推——更快更准、且与推导一致。**
        阶段1  ⏸ 先写推导（每次建模必做，含教科书标准模型；即闸门2）：单独生成 markdown 推导文件
               `<模型名>_derivation.md`。**格式照 references/derivation-style.md（八节固定结构 +
               LaTeX 规范，统一编号全程沿用）；各主体最优化问题 / FOC / 会改方程结构的变体照
               references/modeling-blocks.md 逐块推（家庭→厂商→政府央行→市场出清，每想好一块就落进
               对应小节，不囤在脑子里）**。八节为：第1节 模型概述；第2节 各主体最优化问题；
               第3节 逐主体一阶条件 FOC（编号 F1,F2…）；第4节 市场出清与总量恒等式；
               第5节 外生过程；**第6节 稳态求解（稳态方程组 + 解析解/反解步骤，写到能直接照抄进
               steady_state_model）**；第7节 时序约定；第8节 变量参数对照表（标每个变量由哪条 FOC
               定，预核对 R4）。完整范例见 `references/examples/rbc_baseline_derivation.md`。
               **这是暂停点**：把推导文件交付用户 → 结束本轮 → 等用户确认/修改后点头，才进阶段2。
               详见 workflow-detail.md。
        阶段2 先列变量清单：写文件头 + var/varexo/parameters 三类声明（含 long_name），
               **只声明、不写方程**；逐一核对：所有内生量都进 var、只有创新项进 varexo(R3)、
               参数齐全。把清单整理好作为后续方程的基准，确认无误再进阶段3。
        阶段3  写模型方程 + 参数校准（**逐条对应阶段1 推导里的某条 FOC，[name=] 标注来源**）→
               跑 Dynare 核对方程数=变量数(R4)，过关再继续；
        阶段4  加稳态：把阶段1 推导第6节的稳态解**照抄进 steady_state_model**（解不出才用
               initval 初猜）+ resid; steady; check; → 跑通、稳态求出再继续；
        阶段5  加"shocks+实验命令"→ 跑出 BK/矩/IRF（或过渡路径/后验）。
        阶段3起每阶段都走"运行与纠错闭环"（上限5轮、同错2轮即停）。详见 workflow-detail.md。
第5步   自查：对完整文件跑 references/debugging.md 的"最终检查清单"（12 条）。
第6步   交付：见下方"交付格式"。
```

形式默认非线性(R8)，不需在脑内判断"该不该线性化"——仅 `discretionary_policy` 或用户要线性版/
论文只给线性系统时才 `model(linear);`。展开与理由见 workflow-detail.md「非线性优先」。

## 交付格式（第6步）

最终回复必须包含：
1. **推导文件 `<模型名>_derivation.md`**（阶段1 产出，已与用户确认的版本）；
2. `.mod` 文件；
3. 模型与实验一句话说明 + 存量变量的时序选择；
4. 运行结果摘要（BK、稳态、矩/IRF/估计关键数字）；未能运行时给运行方式与预期输出；
5. 稳态为数值求解时，提醒确认 `resid;` 近 0、`check;` 通过；
6. 最终 TodoList（全部勾选；有遗留项如实保留未勾并说明原因）；
7. 走过文献检索时，注明实际依据的来源（论文/附录/参考实现），与文件头注释一致；
8. **收尾清理工作目录**：复查文件夹，**白名单内的中间产物直接删**（Dynare 自动生成的
   `+<模型名>/`、`<模型名>/` 图形夹、`Output/`、`<模型名>_results.mat`、`<模型名>.log`、
   自动生成的 `<模型名>_dynamic.m/_static.m` 等，以及 agent 自己留下的占位/调试脚本/跑崩的旧版
   .mod）；**来源不确定的先列出来问用户，不擅自删**。绝不删：用户上传的文件/数据、推导 md、
   最终 .mod、**用户手写的 `<模型名>_steadystate.m`**（这是稳态文件不是中间产物）、**绘图脚本
   `plot_irfs_pub.m` 与它导出的论文图 `fig_*.pdf/.eps/.png`**（skill 资产与用户成果，不是中间产物；
   要删的是 Dynare 自带的 `<模型名>_IRF_*.eps`）。详见 workflow-detail.md「收尾清理」。最后向用户
   报告删了哪些、保留了哪些。
