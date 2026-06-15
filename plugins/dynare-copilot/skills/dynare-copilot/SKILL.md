---
name: dynare-copilot
description: Write, run, debug, modify, and review Dynare .mod files across the full lifecycle of macro models (DSGE/RBC/NK/HANK/OLG). MUST trigger when: ① writing a new .mod from scratch or translating paper equations into Dynare code; ② replicating a published model ("replicate Smets-Wouters 2007", "code it per GK 2011"); ③ modifying or extending an existing .mod (adding shocks/mechanisms/blocks/estimation); ④ debugging Dynare errors (Blanchard-Kahn not satisfied, no steady state found, singular Jacobian, timing mistakes); ⑤ setting up stoch_simul / perfect_foresight / estimation / method_of_moments / shock_decomposition / ramsey_model / occbin / identification experiments; ⑥ producing publication-grade IRF figures (AER/JME-style PDF). Trigger whenever the user pastes model equations, mentions a .mod file, or says "run it in Dynare" — do not write Dynare from memory, as timing conventions and block syntax are extremely error-prone.
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

为此设两道闸门——**有足够信息时直接跳过，信息不足时才停下**：

- **闸门1：写任何 var 声明 / 方程之前。** 用户已给全结构信息（论文/完整方程/已答完所有分叉）、
  或任务是对已有 .mod 修改/排错 → **直接跳过**；否则把悬空的结构选择一次性抛给用户（带推荐），
  停下等回答。具体跳过条件见第1.5步。
- **闸门2：动 .mod 之前，仅含非标准机制时。** 含 TANK/HANK/金融摩擦/开放经济/最优政策/OccBin 等
  非标准机制 → 先写推导 md、交付用户、停下确认；教科书标准模型（基础 RBC/三方程 NK）且信息充分、
  或修改类任务 → **直接跳过推导**。具体条件见阶段1。

到了闸门且条件触发时：**停下 → 把待定项连同推荐输出 → 结束本轮 → 等用户回答**（不替用户拟答案、
不绕过提问继续写）。

**一句话判据**：这个选择会改变方程的结构吗？会 → 走闸门、停下问；不会（只是写法/形式：R8 非线性、
命名 R5、log_x 辅助变量、`[name=]` 标注等）→ 按规则直接做，不要为它停下。除两道闸门与第3步
（信息不全）外，各步一律持续产出、不停顿。

## §0 语言确认（每次任务第一步，停下问用户）

**首次触发本 skill 时，先停下确认输出语言，不要默认中文直接开写。** 以用户本轮消息所用语言为
**推荐项**，向用户提一道单选题确定 `[LANG]`（中文 / English / 日本語），等回答后全程沿用。
这是本 skill 的第一个暂停点：问出语言、结束本轮、等用户选定，再进第1步。

| 用户消息语言 | 推荐 [LANG] |
| ------------ | ----------- |
| 中文         | 中文        |
| 英文         | English     |
| 日文         | 日本語      |

**两种情况跳过提问、直接采用**：① 用户本轮消息已明确指定输出语言（如"用英文回答"/"日本語で"）；
② 本 skill 同一会话内已确认过语言（只需确认一次，不必每轮重复问）。
用户中途要求切换语言 → `[LANG]` 同步切换，无需再次确认。

`[LANG]` **只影响**：`.mod` 的 `//`/`/* */` 注释、**配套 `.m` 文件（run 脚本、稳态文件、绘图封装）里的 `%` 注释**、推导 md 的叙述文字（含八节标题）、向用户提的所有建模问题与消息。**不影响**：变量名、标识符、`long_name`、`[name=]`、MATLAB 函数/字段名及其他非注释内容——这些一律英文/ASCII（R1 其余条款不变）。

## §1 硬规则 R1–R8（违反任一 = 文件失败，写每一行都对照）

| #  | 规则                                                                                                                                                                                                                                                    | 正例 / 反例                                                                                             |
| -- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- |
| R1 | **注释一律用 §0 选定语言；注释以外一律英文/ASCII**。覆盖本 skill 生成的**全部代码文件**——`.mod` 与配套 `.m`（run 脚本/稳态文件/绘图封装）注释同规则。`long_name`、`[name=]`、标识符、字符串禁止非 ASCII                                                                                                                                       | ✅`[name='Euler equation']` 上方加该语言注释；❌ `[name='欧拉方程']` 或 `[name='オイラー方程式']` |
| R2 | **时序 = 决定期**（期末存量）。状态变量当期带滞后；运动律左边是期末存量                                                                                                                                                                           | ✅`y=...k(-1)...` 与 `k=invest+(1-delta)*k(-1);`；❌ 生产函数里写 `k`                             |
| R3 | **varexo 只放创新项**；持续过程（AR 等）是内生变量                                                                                                                                                                                                | ✅`var z; varexo eps_z;`；❌ `varexo z;`                                                            |
| R4 | **方程数 = 内生变量数**（例外：`ramsey_model`/`discretionary_policy` 少 1 条）                                                                                                                                                                | 写完模型块数一遍                                                                                        |
| R5 | **禁用命名**：`i`、`inv`、`e`、`E`、Dynare 命令/MATLAB 函数名；希腊字母写 `alppha`/`betta`/`gam`；投资写 `invest`                                                                                                                 | ❌`var i;`；❌ `parameters beta;`                                                                   |
| R6 | **随机情形禁用** `max/min/abs/sign/比较算子`（摄动在拐点给错误导数）；完全预见可用                                                                                                                                                              | 偶尔约束 → OccBin，不是 `>=`                                                                         |
| R7 | 每条语句 `;` 结尾、每块 `end;` 结尾、一行一条；参数先赋值后用                                                                                                                                                                                       | 未知行首会被当原生 MATLAB                                                                               |
| R8 | **非线性优先**：默认写原始非线性方程组（FOC/约束/外生过程），让 Dynare 做泰勒展开，不手推线性化。**仅两种情况写线性化**并 `model(linear);`：① `discretionary_policy`（Dynare 技术要求）；② 用户明确要线性版或复制的论文只给线性化系统 | ✅ 非线性 RBC 用原始 FOC；`discretionary_policy` 用 `model(linear);`                                |

## §2 任务路由（判型 → 读对应参考，然后才动笔）

| 信号词                                                                                                                                 | 任务                             | 命令族                                                                                | 必读参考                                                                   |
| -------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------- | ------------------------------------------------------------------------------------- | -------------------------------------------------------------------------- |
| IRF、矩、方差分解、"模拟这个 DSGE/RBC/NK"                                                                                              | 随机模拟                         | `stoch_simul`                                                                       | `references/stochastic-simulation.md`                                    |
| 风险溢价/资产定价、不确定性（波动率）冲击、预防性储蓄、二/三阶福利、Epstein-Zin 递归偏好、GIRF、随机/遍历稳态、`order=2/3`、pruning | 高阶摄动                         | `stoch_simul(order=2/3)`                                                             | `references/higher-order.md`                                             |
| 过渡路径、永久冲击、确定性、完全预见                                                                                                   | 完全预见                         | `perfect_foresight_*`                                                               | `references/perfect-foresight.md`                                        |
| 估计、贝叶斯、先验、MCMC、极大似然、数据、varobs                                                                                       | 估计                             | `estimation`                                                                        | `references/estimation.md` + steady-state.md                             |
| 矩方法、GMM、SMM、模拟矩、IRF 匹配、匹配矩校准                                                                                         | 矩方法估计                       | `method_of_moments`                                                                 | `references/moments-method.md` + estimation.md                           |
| 冲击分解、历史分解、哪个冲击驱动、实时分解、初始条件分解                                                                               | 冲击分解                         | `shock_decomposition`/`realtime_*`/`plot_*`/`initial_condition_decomposition` | `references/shock-decomposition.md`                                      |
| 预测、外推、条件预测、约束某变量未来路径、扇形图                                                                                       | 预测                             | `forecast`/`conditional_forecast`/`conditional_forecast_paths`                  | `references/forecasting.md`                                              |
| 识别、能否识别、估计前查识别、敏感性/GSA、IRF/矩校准先验                                                                               | 识别与敏感性                     | `identification`/`sensitivity`                                                    | `references/identification.md`                                           |
| 区制切换、Markov switching、结构 BVAR、SBVAR、SWZ、时变波动/系数                                                                       | MS-SBVAR                         | `markov_switching`/`svar`/`sbvar`/`ms_*`                                      | `references/ms-sbvar.md`                                                 |
| 异质主体、HANK、Krusell-Smith、连续分布家庭、SSJ、一/两资产 HANK                                                                       | 异质性                           | `heterogeneity_dimension`/`heterogeneity_*`                                       | `references/heterogeneity.md`                                            |
| 最优政策、Ramsey、相机抉择、福利、简单规则                                                                                             | 最优政策                         | `ramsey_model`/`discretionary_policy`/`osr`                                     | `references/optimal-policy.md`                                           |
| ZLB/有效下限、抵押/借贷约束、不可逆投资、偶尔约束                                                                                      | 偶尔约束                         | `occbin_*` 或完全预见 `lmmcp`/`⟂`                                              | `references/occbin.md`（确定性单约束亦见 perfect-foresight.md「lmmcp」） |
| —（几乎都涉及）                                                                                                                       | 稳态                             | `steady_state_model`/`initval`                                                    | `references/steady-state.md`                                             |
| 多国、多部门、变体切换、@#、循环生成方程                                                                                               | 宏处理器                         | `@#define/@#if/@#for`                                                               | `references/macro-processor.md`                                          |
| 报错、跑不通、BK 不满足、稳态求不出、**结果数值可疑**（无报错但数不对劲、乘数/IRF 量级或符号存疑）                                     | 排错                             | 诊断命令                                                                              | `references/debugging.md`                                                |
| 已踩过的具体坑速查（先扫实战日志命中现成修法）、自己新解决报错后 encode-back 回写                                                       | 排错日志                         | —                                                                                    | `references/known-issues.md`                                            |
| 对**已有 .mod** 修改/扩展（加冲击/机制/估计/OSR/切换价格黏性等）、"帮我改这个文件"                                               | 存量文件修改                     | —                                                                                    | **走 §2.8，跳过建模主流程**                                         |
| **凡产出 IRF 即默认出图**（见 §3 阶段5b）；用户提到好看的图、顶刊/发表级 IRF/时间序列、导出 PDF、多情景/多冲击对比、置信带时同样读此参考 | 发表级绘图（**默认产出**） | IRF→`plot_irfs_pub.m`；模拟序列/过渡路径→`plot_series_pub.m`（均替代自带画图）   | `references/publication-plots.md`                                        |
| 复制某论文模型、"要个带 X 特征的模型"、不确定有无现成实现 →**建模/复制类任务落笔前必做**                                        | 本地双库检索           | ① grep `catalog.csv`（模型结构）→ 读 `examples/<ID>.mod`；② grep `catalog-code.csv`（编程逻辑）→ 读 `examples-code/<Folder>/<ID>.mod`；两库无命中再 grep `model-archive-catalog.csv`  | `references/catalog-lookup.md`                                           |
| 需要现成骨架                                                                                                                           | 模板                             | —                                                                                    | `references/templates.md`                                                |
| 主流程任一步的细节（暂停点/检索/分阶段构建/闭环/骨架/细则）                                                                            | 流程                             | —                                                                                    | `references/workflow-detail.md`                                          |
| 求解慢、反复改图/改归一化要重算、缓存 oo_、多模型/多情景对比（HANK vs RANK）、求解与分析解耦、迭代效率                       | MATLAB 侧工作流                  | —                                                                                    | `references/matlab-workflow.md`                                          |
| 给用户可一键复跑的运行脚本、把 .mod+稳态.m+绘图代码串成总装、**让绘图/产出代码被自动调用**、有特定 main 的项目编排、按实验类型（IRF/模拟/过渡路径/矩）选产出 | 运行脚本（**默认产出**） | `run_<模型名>.m`                                                                   | `references/run-script.md`                                              |
| 写阶段1 推导文件的结构与公式规范                                                                                                       | 推导规范                         | —                                                                                    | `references/derivation-style.md`                                         |
| 各主体最优化问题/FOC 怎么推、有哪些会改方程结构的变体                                                                                  | 建模逻辑                         | —                                                                                    | `references/modeling-blocks.md`                                          |

## §2.5 本机 Dynare 7.1 官方示例速查（`C:\dynare\7.1\examples\`）

| 任务类型                                          | 本机示例路径（相对 `C:\dynare\7.1\examples\`）                                             |
| ------------------------------------------------- | -------------------------------------------------------------------------------------------- |
| 随机模拟：NK 基线 + 解析稳态                      | `stochastic_simulations/nk_baseline.mod` + `nk_baseline_steadystate.m`                   |
| 随机模拟：Collard 2001（解析稳态辅助函数写法）    | `stochastic_simulations/collard_2001_analytical_steady_state.mod` + `_helper.m`          |
| 随机模拟：模拟矩 vs 理论矩对比                    | `stochastic_simulations/collard_2001_simulated_moments.mod` + `_theoretical_moments.mod` |
| 随机模拟：非平稳/趋势冲击（Aguiar-Gopinath 2007） | `stochastic_simulations/aguiar_gopinath_2007_trend.mod`                                    |
| 估计：贝叶斯全系统（Schorfheide 2000）            | `estimation/schorfheide_2000.mod` + `schorfheide_2000_data.m`                            |
| 估计：IRF 匹配（RBC）                             | `estimation/rbc_irf_matching.mod` + `rbc_irf_matching_data.csv` + `_transformations.m` |
| 估计：Galí 2015（先验限制写法）                  | `estimation/gali_2015.mod` + `gali_2015_prior_restrictions.m`                            |
| 最优政策：Ramsey + OSR（NK）                      | `optimal_policy/nk_ramsey_osr.mod`                                                         |
| 最优政策：Ramsey + 外部稳态文件                   | `optimal_policy/nk_ramsey_steady_file.mod` + `nk_ramsey_steady_file_steadystate.m`       |
| 偶尔约束（OccBin）                                | `occbin/rbc_occbin.mod`                                                                    |
| 完全预见：基础 RBC                                | `perfect_foresight/perfect_foresight_rbc.mod`                                              |
| 完全预见：预期误差冲击                            | `perfect_foresight/perfect_foresight_expectation_errors.mod`                               |
| 异质主体：HANK 单资产                             | `heterogeneity/hank_one_asset.mod` + `hank_one_asset_steady_state.mod`                   |
| 异质主体：HANK 双资产                             | `heterogeneity/hank_two_assets.mod` + `hank_two_assets_steady_state.mod`                 |
| 异质主体：Krusell-Smith 1998                      | `heterogeneity/krusell_smith_1998.mod` + `krusell_smith_1998_steady_state.mod`           |
| 宏处理器：多国（BKK 1992）                        | `macroprocessor/bkk_1992.mod`                                                              |
| 半结构/PAC 模型                                   | `semistructural/pac_model.mod`                                                             |

**三类参照的分工（重要）**：三类来源服务于不同问题，不互相替代，通常组合使用：

| 问题                                                              | 用哪个来源                              | 从中取什么                 | 绝不照搬                 |
| ----------------------------------------------------------------- | --------------------------------------- | -------------------------- | ------------------------ |
| **经济学怎么建模？** FOC 结构、机制设计、校准策略、时序约定 | 本地模型参考库 `catalog.csv` → web     | 方程逻辑、参数值、时序选择 | 代码形式（尤其线性化版） |
| **Dynare 块/命令怎么写？** 语法、块格式、辅助函数接口       | 本地编程逻辑库 `catalog-code.csv`       | 命令选项、块结构、接口写法 | 方程内容/校准            |
| **Dynare 内置命令细节？** 7.1 新选项、边缘语法确认          | 本机 Dynare 7.1 官方示例（上表）        | 语法细节、版本兼容性       | 方程内容/校准            |

官方示例语法与本机版本完全兼容；Read 前先确认路径存在（大小写敏感）。

**经济建模参照优先级**（第1.3步，针对"模型结构该怎么设"）：
① 本地模型参考库 `references/catalog.csv`（149 篇 MMB/rep-mmb）——首选，论文忠实、时序与校准现成；
② 用户模型存档库 `references/model-archive-catalog.csv`（历次任务积累，每个模型在 `references/model-archive/<ModelID>/` 独立子文件夹，含 .mod + 稳态/辅助 .m；检索时也 `ls` 扫文件夹名）——①无命中时次选；
③ web 检索论文原文——两套本地库均无命中时兜底。

**Dynare 编程逻辑参照优先级**（第1.3步②，针对"这个块/命令怎么写"）：
① 本地编程逻辑库 `references/catalog-code.csv`（89 个示例：41 个 Pfeifer DSGE_mod + 48 个
   Pfeifer《Advanced Dynare》课程教学示例，后者 Folder 以 `Dynare_Course/` 开头、按 Dynare 功能逐章组织，
   是抄某命令/块写法的最佳模板；全部已本地化）——首选；
② 本机 Dynare 7.1 官方示例（上表）——补充 7.1 特有语法细节；
③ web 检索 Dynare 文档——两者均无明确答案时兜底。**不再需要上网找 DSGE_mod**。

## §2.8 存量 .mod 修改/扩展路径（跳过完整建模主流程）

**触发**：用户已有 `.mod` 文件，任务是在此基础上修改、扩展或调试，而非从零建模。
典型场景：加政府支出冲击、把 Calvo 换成 Rotemberg、给现有模型加 estimation 模块、修复某条报错。

**此路径跳过**：第1.3步(catalog检索)、第1.5步(闸门1)、阶段1(推导文件)。
（§0 语言确认仍要做——它是任何路径的第一步，除非用户已指定语言或本会话已确认过。）

```
步骤 M1  读文件：Read 目标 .mod，了解现有变量/方程/参数结构与时序约定。
步骤 M2  定位改动范围并分类：
         修改类（改参数/方程/校准）→ 直接 Edit，跑修改后文件验证；
         扩展类（加新机制/冲击）   → 确认新增 var/varexo/参数不破坏 R4；
                                      若新机制涉及结构性分叉（如代表性→异质家庭），
                                      对该部分做局部推导（写清楚新增 FOC 即可，无需完整八节）；
         加实验模块（estimation/ramsey/occbin 等）→ 走 §2 对应路由的参考文件，
                                      在现有稳态/方程基础上追加实验命令块。
步骤 M3  增量修改 → 用 MATLAB MCP 运行验证 → 阶段性确认（跑通再继续）。
步骤 M4  自查：debugging.md 最终检查清单中与本次改动相关的条目。
步骤 M5  交付：说明改了什么及原因，附运行结果摘要；若产出 IRF 走阶段5b 绘图。
步骤 M6  🔒 回写 known-issues.md（若本次定位并解决了 skill 里查不到的报错）：修改/排错类任务正是
         新坑高发处——按 debugging.md「bug 处理协议」第3步，解决的当下就列进 TodoList、交付前回写。
         漏写则同一个坑下次还得从头踩。本次没踩新坑则一句话跳过。
```

注意：若修改范围影响到稳态（如改效用函数形式），需按 steady-state.md 重算并跑 `resid; steady; check;`。

---

## §3 主流程（按序执行，不跳步；每步 = 一个 TodoList 条目）

**先列 TodoList 再动手**（优先用 TodoWrite 工具；否则用 markdown 复选框 `- [ ]`→`- [x]`，
每阶段完成后重发）。中途冒出新问题 → 向清单追加新项。

**建模/复制类任务（产出新 .mod）起手列 TodoList 时，必须把两条「收尾门控」作为固定项显式写进去、
保持未勾选直到真正完成**：
（a）第7步「⏸ 询问用户是否归档模型」——保持到归档询问真正发出；
（b）「回写 known-issues.md（若本任务新解决过 skill 里查不到的报错）」——见下方第4步 bug 协议，
新报错**一解决就立刻列进 TodoList**，交付前完成回写。
原因很实在：终端「停下问用户」「把经验沉淀回库」这类门控一旦只藏在流程深处，极易被用户一句
"收尾/差不多了"带过而整步蒸发（这既是本 skill 反复漏掉归档、也是排错库长不起来的根因）——
把它们做成从一开始就可见、始终待办的清单项，是防遗漏最可靠的机制。

```
第0步   语言确认：按 §0 停下问用户确定 [LANG]（中文/English/日本語），以本轮消息语言为推荐项；
        等用户选定后再进第1步。用户已指定语言、或本会话已确认过 → 跳过提问直接沿用。
第1步   判型：对照 §2 定任务类型与模型类别；贴论文方程时先标状态(带滞后)/控制(跳跃)。
        顺手提炼**检索特征**：模型类型 + 核心机制（金融加速器/搜寻匹配/住房抵押/两国/财政…）+ 经济体。
第1.3步 本地模型库检索（**建模/复制类任务必做，先于闸门1**；纯排错/对已有 .mod 估计等可跳过）：
        **两套库分开检索，服务不同问题**（详见 `references/catalog-lookup.md`）：

        ① **模型参考库**（经济结构）：grep `references/catalog.csv`，挑 3–5 个最相近的 ModelID，
           向用户报一句"找到这几篇相近"，再读 1–3 个 `references/examples/<ModelID>.mod`——
           抽取方程写法、**时序约定**、参数校准、冲击设定。
           ⚠ `(linearized)` 版只取内容/机制/时序/校准，形式仍按 R8 写非线性。

        ② **编程逻辑库**（Dynare 命令/块怎么写）：grep `references/catalog-code.csv`，
           按 DynareFeatures 列搜关键词（如 `discretionary_policy`、`steadystate.m`、
           `lmmcp`、`welfare`、`news shock`、`TANK`…），读命中的
           `references/examples-code/<Folder>/<CodeID>.mod` 中的相关块——
           只取语法样板，不要照搬经济结构。

        两套均无命中 → 再查用户模型存档库：grep `references/model-archive-catalog.csv` 的机制标签，
        同时 `ls references/model-archive/` 扫子文件夹名（folder = ModelID，兜底 catalog 漏写）；
        若文件/目录不存在，直接跳过、不报错；有命中则进 `references/model-archive/<ModelID>/`
        读其 `.mod`（必要时连带 `<ModelID>_steadystate.m` 等 .m，同样只取内容/时序/校准）。

        命中后，第3步 web 检索降为兜底（仅补论文精确校准来源或某条推导细节）。
        **DSGE_mod 已本地化**，不再需要上网找 DSGE_mod——其关键 .mod 已全部在
        `references/examples-code/` 中，直接读即可，无需网络。
        参照不替代阶段1 推导。14 类模型索引与照搬警示详见 `references/catalog-lookup.md`。
第1.5步 ⏸ 逐主体确认特征 + 建模选择（即闸门1）：
        【满足任一条件 → 直接跳过，不停顿】
          A. 用户已点名具体论文（第3步检索定模型）
          B. 用户已给出完整方程组（含 FOC、约束、外生过程）
          C. 用户本轮消息已明确以下**所有**结构性选项：
             ① 含资本否　② 劳动供给形式（可分/GHH/黏性工资）
             ③ 市场结构（完全竞争/垄断竞争 + 价格黏性类型）
             ④ 家庭是否异质（代表性/HtM-TANK/HANK）
             ⑤ 财政/金融模块有无及形式
          D. 任务是纯排错、对已有 .mod 修改/扩展（走 §2.8）
        【需要停下问用户】：以上均不满足，且上述选项有至少一项悬空——把所有悬空项整理成
        一份选择题（附推荐）一次性发出，停下等回答。（R8 非线性形式不必问。）详见 workflow-detail.md。
第2步   读参考：读 §2 指定的参考文件（含 steady-state.md）。
第3步   知识判定（**本地库优先，web 兜底**）：第1.3步已在两套本地库命中相近实现 → web 降为只补
        论文特定细节（精确校准来源/某条推导）；**不需要上网找 DSGE_mod**（已本地化）。
        两套本地库均无相近模型、或对模型没十足把握（"大概记得"=不会）→
        实际调用 web 搜索查论文原文，提取方程组/校准/时序/冲击四样；缺关键信息 ⏸
        停下问用户。教科书标准件且有把握 → 直接第4步。详见 workflow-detail.md。
第4步   增量构建——**三跑三锁，前一跑未过不得写下一段**。
        绝不一次写完整个 .mod 再跑。每跑一次都必须实际调用 MATLAB MCP 执行 Dynare，
        看到输出结果确认通过后，才能继续写下一段。
        **核心：阶段2起写 .mod 时全程打开阶段1 的推导 md，对照逐条翻译（变量照第8节、方程照
        第2–5节 FOC、稳态照第6节），不凭记忆重推——更快更准、且与推导一致。**

        阶段1  ⏸ 先写推导（即闸门2）：
               【满足任一条件 → 跳过，直接进阶段2】
                 A. 用户明确说"不用推导"/"直接写 .mod"/"跳过推导"
                 B. 是纯排错或对已有 .mod 的修改/扩展任务（走 §2.8）
                 C. 教科书标准模型（基础 RBC 或三方程 NK）+ catalog 有直接命中
                    → 省略推导，但在回复中一句话说明稳态解析解来源
               【必须写推导】：含非标准机制（TANK/HANK/金融摩擦/开放经济/最优政策/OccBin 等），
               或用户给出方程需核对自洽性时。
               产出 `<模型名>_derivation.md`，严格按 references/derivation-style.md 的八节结构
               （各主体 FOC 按 references/modeling-blocks.md 逐块推）。八节里有两处最易漏、漏则 BK 失败，
               务必硬查：**第4节 Walras 定律检查**——GE 中必有一条均衡条件冗余，找出它、注明"不进 model 块"
               并写出推导路径；**第8节 R4 预核对**——每个 var 都要有对应方程，"由哪条方程决定"留空即方程缺失，
               补全再进阶段2。
               **这是暂停点**：交付推导文件 → 结束本轮 → 等用户确认后才进阶段2。
               八节逐节展开 + 两处硬查的完整说明见 workflow-detail.md「第4步」阶段1。

        阶段2  先列变量清单：写文件头 + var/varexo/parameters 三类声明（含 long_name），
               **只声明、不写方程**；逐一核对：所有内生量都进 var、只有创新项进 varexo(R3)、
               参数齐全。把清单整理好作为后续方程的基准，确认无误再进阶段3。

        ══ 第一跑：结构验证 ══════════════════════════════════════════
        阶段3  写：模型方程（model...end;）+ 参数赋值
               逐条对应推导里的 FOC，加 [name=] 标注。
               ▶ 立即用 MATLAB MCP 跑 Dynare（noclearall nointeractive）
               ✔ 通过标准："Found N equation(s)" 中 N = var 变量数；预处理无报错；
                 无 R5 命名警告（如 alpha/beta 未改写）。
               ✘ 未通过：修复报错后重跑，不得写阶段4。
        ══════════════════════════════════════════════════════════════

        ══ 第二跑：稳态验证 ══════════════════════════════════════════
        阶段4  写：steady_state_model（照抄推导第6节解析解；解不出才用 initval 初猜）
                  + steady; resid(non_zero); check;
               ▶ 立即用 MATLAB MCP 跑 Dynare
               ✔ 通过标准："All residuals are zero"；check 输出
                 "The rank conditions are verified"（BK 初步满足）。
               ✘ 未通过：查 resid 哪条非零 → 核对对应 FOC 的稳态方程，修复后重跑；
                 不得写阶段5。
        ══════════════════════════════════════════════════════════════

        ══ 第三跑：完整模拟 ══════════════════════════════════════════
        阶段5a 写：shocks; ... end; + stoch_simul(order=1, irf=20, nograph, periods=0);
               ▶ 立即用 MATLAB MCP 跑 Dynare
               ✔ 通过标准：BK 条件满足（爆炸根数 = 跳跃变量数）；IRF 无 NaN/Inf。
               ✘ 未通过：查 debugging.md「BK」小节；修方程或 Taylor 参数，重跑。
        ══════════════════════════════════════════════════════════════

        阶段5b ⭐发表级绘图（**默认必做**，不必等用户点名——这是本 skill 的标准产出，不是可选附加）：
               **凡本任务产出了 IRF**（stoch_simul 的 `irf=`、贝叶斯后验 IRF、或完全预见过渡路径），
               就读 `references/publication-plots.md`，按其"接入流程"用 `references/plot_irfs_pub.m`
               出顶刊级矢量图（替代 Dynare 自带粗糙图：`stoch_simul` 加 `nograph`）→ 通过 MATLAB MCP
               运行核对出图、确认 `fig_*.pdf` 已生成。**仅两种情况跳过**：① 本任务压根不产出 IRF
               （纯稳态检查 / 纯识别 / 预测扇形图等有专门图的场景）；② 用户明说不要出版图。
               跳过时在交付里一句话说明原因。

        阶段5c 🏃生成运行脚本 `run_<模型名>.m`（**默认产出**，不必等用户点名）：
               读 `references/run-script.md`，按其五环节骨架把工作目录里的零件**串成一键复跑的总装脚本**：
               自包含（addpath Dynare + cd 到脚本目录，干净 MATLAB 双击即跑）→ `dynare <模型名>`（自动用
               同名稳态 `.m`）→ 稳态/解析基准自检打印 → **第4环节按本任务实验类型选产出并真正调用产出代码**
               （IRF→`plot_irfs_pub.m`；模拟序列/完全预见过渡路径→`plot_series_pub.m`；纯矩→打印矩表）→ 冻存 `oo_.mat`。
               **核心：绘图脚本必须被 run 脚本自动调用**——这是过去最常漏的一环（脚本拷了却没人调）；
               两个绘图脚本各管一类产出（IRF / 时间序列），都现成、直接调用、不内联手写 `plot`。
               注释随 [LANG]（R1）。项目已有 `main` 则接进去、不另起；多模型/贵求解按 run-script.md 的变体拆分。
               写完用 MATLAB MCP 跑一遍 `run_<模型名>.m` 核对它一条龙跑通、产出文件确已生成。
               **仅一种情况跳过**：用户明说不要运行脚本（交付里一句话说明）。
        每跑一次都走"运行与纠错闭环"（上限5轮、同错2轮即停），详见 workflow-detail.md「§4.1」。
        **遇报错先查后补**：先扫 `known-issues.md` 实战坑日志 + `debugging.md`「报错→病因→修法」表，
        命中直接照修法改、不重推；查不到才自己诊断。**解决一个 skill 里查不到的新报错，就地（趁现象/根因/
        修法还在眼前）往 TodoList 追加一条 `回写 known-issues.md：<一句话现象>`**——别等收尾再回忆，否则经验
        已模糊、且易被"任务完成"挤掉（这正是排错库长不起来的根因）。完整协议与回写格式见 debugging.md「bug 处理协议」。
第5步   自查：对完整文件跑 references/debugging.md 的"最终检查清单"（共13条）；多主体模型尤其确认 Walras 定律冗余方程已剔出 model 块（清单第13条）。
第6步   交付：见下方"交付格式"。
第7步   ⏸🔒 归档门控（建模/复制类任务且产出新 .mod 必做；纯排错、无新 .mod 则跳过）——
        这是「收尾门控(a)」的执行步（why 见 §3 前言）：把"是否将本模型归档到存档库供未来复用？(是/否)"
        作为交付消息**固定最后一行**问出，停下等回答。用户答"是"才按 `references/model-archive.md`「二、存档」
        新建 `references/model-archive/<模型名>/`，把 .mod、推导 md、运行所需的稳态/辅助 .m 一并复制进去、
        追加 catalog 索引行；答"否"则跳过。
        ✔ 完成标准：交付消息里**确实出现了归档询问这一行**（无论用户答是/否），该 TodoList 项才可勾掉。
```

形式默认非线性(R8)，不需在脑内判断"该不该线性化"——仅 `discretionary_policy` 或用户要线性版/
论文只给线性系统时才 `model(linear);`。展开与理由见 workflow-detail.md「非线性优先」。

## 交付格式（第6步）

最终回复必须包含：

1. **推导文件 `<模型名>_derivation.md`**（阶段1 产出，已与用户确认的版本）；
2. `.mod` 文件；
3. 模型与实验一句话说明 + 存量变量的时序选择；
4. 运行结果摘要（BK、稳态、矩/IRF/估计关键数字）；未能运行时给运行方式与预期输出；
5. **发表级 IRF 图**（凡产出 IRF 时必交付，阶段5b 产出）：plot_irfs_pub 导出的 `fig_*.pdf`
   （论文可直接用的矢量图），正文嵌图或附图说明；未出图时一句话说明原因（无 IRF / 用户不要）；
5b. **运行脚本 `run_<模型名>.m`**（阶段5c 产出，默认必交付）：自包含、可一键复跑的总装脚本，
   把 `.mod`+稳态 `.m`+产出代码串起来并**自动调用绘图/产出代码**；说明用户需按本机改的那行 Dynare 路径；
   接进既有 `main` 时改为指明接入位置；用户明说不要时一句话说明跳过；
6. 稳态为数值求解时，提醒确认 `resid;` 近 0、`check;` 通过；
7. 最终 TodoList（全部勾选；有遗留项如实保留未勾并说明原因）；
8. 走过文献检索时，注明实际依据的来源（论文/附录/参考实现），与文件头注释一致；
9. **收尾清理工作目录**：复查文件夹，按 workflow-detail.md「收尾清理」的白/黑名单处理——白名单内的
   Dynare 自动产物（`+<模型名>/`、`Output/`、`<模型名>_results.mat`、`.log`、自动 `_dynamic.m/_static.m` 等）
   与 agent 临时文件直接删，来源不确定的先列出来问用户、不擅自删。**最易误删、务必保留**：用户上传的文件/数据、
   推导 md、最终 .mod、用户手写的 `<模型名>_steadystate.m`、**运行脚本 `run_<模型名>.m` 与 `analyze_<模型名>.m`**、
   绘图脚本 `plot_irfs_pub.m`、`plot_series_pub.m` 与它们导出的论文图 `fig_*.pdf/.eps/.png`。最后向用户报告删了哪些、保留了哪些。
10. 🔒 **回写 known-issues.md（收尾门控(b)，详见第4步 bug 协议）**：把第4步沉淀的 TodoList 条目
    按 `references/known-issues.md` 条目格式（现象→根因→修法带代码→详见）逐一落地；框架特异的坑
    同时补进对应 reference 的"常见报错与陷阱"节。无需问用户（是写库不是外发）。没踩新坑则一句话跳过。
11. ⏸🔒 **归档询问行（收尾门控(a)，详见第7步）**：交付消息**固定最后一行**问出
    "是否将本模型归档到存档库供未来复用？(是/否)" 再结束本轮；答"是"后按第7步把整个模型子文件夹
    复制进 `references/model-archive/<模型名>/`、追加 catalog 行。
