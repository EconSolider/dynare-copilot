---
name: dynare-mod
description: 编写、运行、调试、修改和审查 Dynare .mod 文件，覆盖 DSGE/RBC/NK/HANK/OLG 等宏观模型全流程。以下场景必须触发：① 从零写新 .mod 或把论文方程翻成 Dynare 代码；② 复制某篇论文模型（"复制 Smets-Wouters 2007"、"按 GK 2011 写"）；③ 修改或扩展已有 .mod（加冲击/机制/模块/估计）；④ 调试 Dynare 报错（BK 不满足、稳态求不出、奇异雅可比、时序错）；⑤ 搭建 stoch_simul / perfect_foresight / estimation / method_of_moments / shock_decomposition / ramsey_model / occbin / identification 等实验；⑥ 出发表级 IRF 图（AER/JME 风格 PDF）。用户贴出模型方程、提到 .mod 文件或"用 Dynare 跑"时即触发——不要凭记忆写 Dynare，时序与块语法极易写错。
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

## §0 语言确定（每次任务第一步，自动完成）

**自动检测，无需提问**：根据用户本轮消息所用语言直接确定 `[LANG]`，全程沿用。

| 用户消息语言 | [LANG]  |
| ------------ | ------- |
| 中文（默认） | 中文    |
| 英文         | English |
| 日文         | 日本語  |

用户中途切换语言 → `[LANG]` 同步切换，无需说明。

`[LANG]` **只影响**：`.mod` 的 `//`/`/* */` 注释、推导 md 的叙述文字（含八节标题）、向用户提的所有建模问题与消息。**不影响**：变量名、标识符、`long_name`、`[name=]` 及其他非注释内容——这些一律英文/ASCII（R1 其余条款不变）。

## §1 硬规则 R1–R8（违反任一 = 文件失败，写每一行都对照）

| #  | 规则                                                                                                                                                                                                                                                    | 正例 / 反例                                                                                             |
| -- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- |
| R1 | **注释一律用 §0 选定语言；注释以外一律英文/ASCII**。`long_name`、`[name=]`、标识符、字符串禁止非 ASCII                                                                                                                                       | ✅`[name='Euler equation']` 上方加该语言注释；❌ `[name='欧拉方程']` 或 `[name='オイラー方程式']` |
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
| 报错、跑不通、BK 不满足、稳态求不出                                                                                                    | 排错                             | 诊断命令                                                                              | `references/debugging.md`                                                |
| 对**已有 .mod** 修改/扩展（加冲击/机制/估计/OSR/切换价格黏性等）、"帮我改这个文件"                                               | 存量文件修改                     | —                                                                                    | **走 §2.8，跳过建模主流程**                                         |
| **凡产出 IRF 即默认出图**（见 §3 阶段5b）；用户提到好看的图、顶刊/发表级 IRF、导出 PDF、多情景/多冲击对比、置信带时同样读此参考 | 发表级绘图（**默认产出**） | `plot_irfs_pub.m`（替代自带画图）                                                   | `references/publication-plots.md`                                        |
| 复制某论文模型、"要个带 X 特征的模型"、不确定有无现成实现 →**建模/复制类任务落笔前必做**                                        | 本地双库检索           | ① grep `catalog.csv`（模型结构）→ 读 `examples/<ID>.mod`；② grep `catalog-code.csv`（编程逻辑）→ 读 `examples-code/<Folder>/<ID>.mod`；两库无命中再 grep `memory-catalog.csv`          | `references/catalog-lookup.md`                                           |
| 需要现成骨架                                                                                                                           | 模板                             | —                                                                                    | `references/templates.md`                                                |
| 主流程任一步的细节（暂停点/检索/分阶段构建/闭环/骨架/细则）                                                                            | 流程                             | —                                                                                    | `references/workflow-detail.md`                                          |
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
② 用户记忆库 `references/memory-catalog.csv`（历次任务积累，.mod 在 `references/memory/`）——①无命中时次选；
③ web 检索论文原文——两套本地库均无命中时兜底。

**Dynare 编程逻辑参照优先级**（第1.3步②，针对"这个块/命令怎么写"）：
① 本地编程逻辑库 `references/catalog-code.csv`（41 个 Pfeifer DSGE_mod 示例，已本地化）——首选；
② 本机 Dynare 7.1 官方示例（上表）——补充 7.1 特有语法细节；
③ web 检索 Dynare 文档——两者均无明确答案时兜底。**不再需要上网找 DSGE_mod**。

## §2.8 存量 .mod 修改/扩展路径（跳过完整建模主流程）

**触发**：用户已有 `.mod` 文件，任务是在此基础上修改、扩展或调试，而非从零建模。
典型场景：加政府支出冲击、把 Calvo 换成 Rotemberg、给现有模型加 estimation 模块、修复某条报错。

**此路径跳过**：§3 第0步(语言已自动检测)、第1.3步(catalog检索)、第1.5步(闸门1)、阶段1(推导文件)。

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
```

注意：若修改范围影响到稳态（如改效用函数形式），需按 steady-state.md 重算并跑 `resid; steady; check;`。

---

## §3 主流程（按序执行，不跳步；每步 = 一个 TodoList 条目）

**先列 TodoList 再动手**（优先用 TodoWrite 工具；否则用 markdown 复选框 `- [ ]`→`- [x]`，
每阶段完成后重发）。中途冒出新问题 → 向清单追加新项。

```
第0步   语言确定：按 §0 自动检测用户消息语言，确定 [LANG]（中文/English/日本語）。**不询问**，直接进入第1步。
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

        两套均无命中 → 再 grep `references/memory-catalog.csv`（用户记忆库）；
        若该文件不存在，直接跳过、不报错；有命中则读 `references/memory/<ModelID>.mod`（同样只取内容/时序/校准）。

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
               产出：`<模型名>_derivation.md`，严格按 references/derivation-style.md 的八节结构。
               各主体 FOC 按 references/modeling-blocks.md 逐块推。
               八节：第1节 模型概述；第2节 各主体最优化问题；第3节 FOC（编号 F1,F2…）；
               **第4节 市场出清（必须执行 Walras 定律检查：在 GE 中找出哪条均衡条件由其余条件
               线性组合得出，在推导里明确注明"该方程冗余，不进 model 块"并写出推导路径——
               漏做此步将导致方程数=变量数但实际独立方程少一条，BK 失败）**；
               第5节 外生过程；第6节 稳态求解（写到能照抄进 steady_state_model）；
               第7节 时序约定；**第8节 变量参数对照表（每个 var 变量必须有对应方程，预核对 R4；
               任何一行"由哪条方程决定"为空则方程缺失，必须补进推导再进阶段2）**。
               完整范例见 `references/examples/rbc_baseline_derivation.md`。
               **这是暂停点**：交付推导文件 → 结束本轮 → 等用户确认后才进阶段2。详见 workflow-detail.md。

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
        每跑一次都走"运行与纠错闭环"（上限5轮、同错2轮即停）。详见 workflow-detail.md。
第5步   自查：对完整文件跑 references/debugging.md 的"最终检查清单"（12 条）；多主体模型额外确认 Walras 定律冗余方程已剔出 model 块（见清单第13条）。
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
5. **发表级 IRF 图**（凡产出 IRF 时必交付，阶段5b 产出）：plot_irfs_pub 导出的 `fig_*.pdf`
   （论文可直接用的矢量图），正文嵌图或附图说明；未出图时一句话说明原因（无 IRF / 用户不要）；
6. 稳态为数值求解时，提醒确认 `resid;` 近 0、`check;` 通过；
7. 最终 TodoList（全部勾选；有遗留项如实保留未勾并说明原因）；
8. 走过文献检索时，注明实际依据的来源（论文/附录/参考实现），与文件头注释一致；
9. **收尾清理工作目录**：复查文件夹，**白名单内的中间产物直接删**（Dynare 自动生成的
   `+<模型名>/`、`<模型名>/` 图形夹、`Output/`、`<模型名>_results.mat`、`<模型名>.log`、
   自动生成的 `<模型名>_dynamic.m/_static.m` 等，以及 agent 自己留下的占位/调试脚本/跑崩的旧版
   .mod）；**来源不确定的先列出来问用户，不擅自删**。绝不删：用户上传的文件/数据、推导 md、
   最终 .mod、**用户手写的 `<模型名>_steadystate.m`**（这是稳态文件不是中间产物）、**绘图脚本
   `plot_irfs_pub.m` 与它导出的论文图 `fig_*.pdf/.eps/.png`**（skill 资产与用户成果，不是中间产物；
   要删的是 Dynare 自带的 `<模型名>_IRF_*.eps`）。详见 workflow-detail.md「收尾清理」。最后向用户
   报告删了哪些、保留了哪些。
10. ⏸ **记忆存档**（建模/复制类任务；纯排错且无新 .mod 产出时跳过）：
    读 `references/memory.md`，按其"二、存档"节执行——先停下询问用户，等确认后再操作文件。
