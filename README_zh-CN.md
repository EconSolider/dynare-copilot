# dynare-copilot

![License](https://img.shields.io/badge/license-MIT-green)
![Claude Code](https://img.shields.io/badge/Claude%20Code-plugin-8A2BE2)
![Dynare](https://img.shields.io/badge/Dynare-7.1-blue)

[English](./README.md) | **中文** | [日本語](./README_ja.md)

> 这是一个 Claude Code skill，代替你把语言中的宏观经济直觉——"我想建一个带金融加速器的 NK 模型"、"请复制 Smets-Wouters 2007"——转化为跑通、稳态解出、IRF 出图到手的具体 Dynare `.mod` 文件。
>
> 它的核心在于把所有经验丰富的建模者无论如何都会遵循的流程**固定下来**：先推导方程、后翻译代码、再分阶段运行验证——让时序错误、命名冲突、稳态代数失误，在它们成为错误结果前就被截住。具体而言，它给你：
>
> - **从经过验证的起点出发，而不是空白纸**——内置双层参考库（149 篇 MMB 复制模型管经济结构 + 89 个 Pfeifer 示例管 Dynare 写法），每个模型都从能跑通的代码起步。
> - **越用越聪明的工具**——每次完成的模型都会归档、下次建模自动调用；每次踩的坑都连同修法记入日志，同一陷阱不会调试两次。
> - **可直接发表的产出**——所有 IRF 以顶刊级矢量图交付，可以直接粘进论文。
>
> 没有时序陷阱，没有隐藏错误，没有空白纸。你只管想清楚经济学，剩下的交给它。
>
> *Enjoy 宏观经济的世界。*

---

## 目录

- [环境要求](#环境要求)
- [安装](#安装约-1-分钟)
- [更新](#更新)
- [卸载](#卸载)
- [快速上手](#快速上手)
- [支持的任务](#支持的任务)
- [工作原理](#工作原理)
- [产出结构](#产出结构)
- [仓库结构](#仓库结构)
- [进阶](#进阶)
- [参与共建](#参与共建)
- [致谢](#致谢)
- [License](#license)

---

## 环境要求

| 你想做的事                               | 需要装的东西                                                         |
| ---------------------------------------- | -------------------------------------------------------------------- |
| 让它**写 / 改 / 查** `.mod` 文件 | 只需[Claude Code](https://docs.claude.com/en/docs/claude-code/overview) |
| 自己**运行**生成的 `.mod`        | 额外需要[Dynare 7.1](https://www.dynare.org/) + MATLAB（或 Octave）     |
| 让它**自动运行并循环纠错**         | 再额外装一个 MATLAB MCP 服务器（在 VSCode 中）                       |

> 不装 MATLAB 也能用——它同样能帮你写模型、查查错，只是不替你跑。
>
> 如果提供具体的论文，能大大减少响应时间和 token 消耗。
>
> 🔌 **没配过 MCP？** 如果你从没把 MATLAB（或 Stata）接进 Claude Code，请跟着这份零基础图文教程一步步来：**[给 Claude Code 接上 MATLAB / Stata（MCP 配置入门指南）](./docs/mcp-setup-guide_zh-CN.md)**。它默认你毫无配置基础，手把手教你安装 Claude Code、接好驱动上面「自动运行-纠错」闭环的 MATLAB MCP，以及 Stata MCP。

## 安装（约 1 分钟）

先装好 Claude Code，见[官方安装文档](https://docs.claude.com/en/docs/claude-code/overview)，常见方式：`npm install -g @anthropic-ai/claude-code`。然后：

1. 在终端进入任意项目目录，运行 `claude` 启动 Claude Code。
2. 在 Claude Code 的对话里**逐行粘贴**下面两条命令：

   ```text
   /plugin marketplace add EconSolider/dynare-copilot
   /plugin install dynare-copilot@econsolider-skills
   ```

   第一行把本仓库注册为插件市场，第二行安装 `dynare-copilot` 插件。
3. 完成。输入 `/` 能在菜单里看到 dynare-copilot skill 就说明装好了。

## 更新

装好后想拉最新版，在 Claude Code 里**逐行粘贴**下面两条命令：

```text
/plugin marketplace update econsolider-skills
/plugin update dynare-copilot@econsolider-skills
```

第一行从仓库刷新插件市场的元数据，第二行把已安装的插件升级到最新发布的 `version`。如果没有立即生效，重启一次 Claude Code 即可。

### 开启自动更新（推荐）

第三方市场**默认不自动更新**，所以不开启的话每次都得手动跑上面两条命令。让 Claude Code 在每次启动时自动刷新本市场并升级插件：

1. 运行 `/plugin` 打开插件管理器。
2. 切到 **Marketplaces** 标签页，选中 `econsolider-skills`。
3. 选择 **Enable auto-update**。

设好之后，每次启动 Claude Code 都会自动拉取最新版；有更新时会提示你运行 `/reload-plugins`。这一步只需做一次。

## 卸载

在 Claude Code 里运行即可卸载插件：

```text
/plugin uninstall dynare-copilot@econsolider-skills
```

这样只卸载插件、保留市场注册，之后想重装或更新都不必再重新添加市场。

> 如果你是手动安装的（见下方「进阶」），没有插件可卸载，直接删掉拷过去的目录即可：`rm -rf ~/.claude/skills/dynare-copilot`（或项目级的 `.claude/skills/dynare-copilot/`）。

## 快速上手

装好后，在 Claude Code 里**直接用中文或英文描述任务**即可，它会自动启用：

- "把这组 FOC 翻成 Dynare 代码：`c^-sigma = beta*E[c(+1)^-sigma*(r(+1)+1-delta)]` ……"
- "复制 Smets-Wouters 2007，季度校准，跑 IRF。"
- "给我的新凯恩斯主义模型加上名义利率零下界（ZLB），用 OccBin。"
- "我的 mod 报 `Blanchard-Kahn conditions are not satisfied`，帮我查时序。"
- "把我这几个变量的 IRF 绘成顶刊级图，基线 vs 高黏性两种情景对比，导出 PDF。"

也可以手动调用：`/dynare-copilot:dynare-copilot`。

skill 在 `references/` 下捆绑了两套参考库——149 篇 MMB 复制模型管经济结构、89 个 Pfeifer 示例管 Dynare 写法——外加一套模型存档库——已用 161 篇 MMB 论文推导做种子，并随你构建的可复跑模型不断增长。建模时先检索这些本地库，仅在都无命中时才上网补充论文特定细节。检索逻辑详见[工作原理](#工作原理)，各库具体内容见[仓库结构](#仓库结构)。

## 支持的任务

| 你说的                                                    | 它做的                   | Dynare 命令                                                                                       |
| --------------------------------------------------------- | ------------------------ | ------------------------------------------------------------------------------------------------- |
| IRF、矩、方差分解、"模拟这个 DSGE/RBC/NK"                 | 随机模拟                 | `stoch_simul`                                                                                   |
| 过渡路径、永久冲击、确定性、完全预见                      | 完全预见                 | `perfect_foresight_*`                                                                           |
| 贝叶斯、先验、MCMC、最大似然                              | 估计                     | `estimation`                                                                                    |
| GMM、SMM、模拟矩、IRF 匹配                                | 矩方法估计               | `method_of_moments`                                                                             |
| 冲击分解、"哪个冲击在驱动"                                | 冲击分解                 | `shock_decomposition`                                                                           |
| 外推、条件预测、扇形图                                    | 预测                     | `forecast` / `conditional_forecast`                                                           |
| 能否识别、敏感性 / GSA                                    | 识别与敏感性             | `identification` / `sensitivity`                                                              |
| Markov switching、结构 BVAR                               | MS-SBVAR                 | `markov_switching` / `sbvar`                                                                  |
| HANK、Krusell-Smith、异质家庭                             | 异质性                   | `heterogeneity_*`                                                                               |
| Ramsey、相机抉择、福利、简单规则                          | 最优政策                 | `ramsey_model` / `osr`                                                                        |
| ZLB / 有效下限、抵押 / 借贷约束                           | 偶尔约束                 | `occbin_*` / `lmmcp`                                                                          |
| 多国、多部门、切换变体                                    | 宏处理器                 | `@#define / @#if / @#for`                                                                       |
| 复制某论文模型、"要个带 X 特征的模型"、不确定有无现成实现 | 本地双库检索（首先运行） | grep `catalog.csv`（结构）+ `catalog-code.csv`（语法）→ `model-archive-catalog.csv` → web |
| 顶刊级 IRF / 时间序列图、导出 PDF 论文图、多情景 / 多冲击对比 | 发表级绘图           | IRF→`plot_irfs_pub.m`；模拟序列 / 过渡路径→`plot_series_pub.m`                              |
| 跑不通、BK 不满足、稳态求不出                             | 排错                     | 诊断命令                                                                                          |

## 工作原理

它不靠记忆硬写，而是按固定流程推进：

1. **先确认、后动笔**——在写代码之前，就**会改变方程结构的建模选择**（含哪些主体、劳动供给同/异质、含不含资本、市场结构……）会问你答案，然后产出一份结构化推导文件（最优化问题 → FOC → 稳态求解 → 时序），你确认后才写代码。两次暂停点都是为了在错误发生前拦住，而不是事后对一大块代码返工。
2. **增量构建**——变量声明 → 方程 → 稳态 → 冲击与实验，逐阶段跑通/确认后才继续。
3. **非线性优先**——默认写原始非线性方程组交给 Dynare 展开，不手推线性化（这是最常见的隐藏错误来源）。
4. **运行-纠错闭环**——接好 MATLAB MCP 时自动跑 Dynare、读报错、做最小修复、重跑。它会先查内置的**排错日志**（`known-issues.md`）里已记录的坑，自己新解决的报错也回写进去——同一个坑不会从头调试两次。
5. **本地双库检索**——建模前先查两套独立的本地库：

   - **模型参考库**（`catalog.csv`，149 篇 MMB/rep-mmb 模型）：回答"这个经济机制该怎么建模？"—— FOC 结构、时序约定、参数校准。
   - **编程逻辑库**（`catalog-code.csv`，89 个 Johannes Pfeifer 示例：41 个 DSGE_mod + 48 个 *Advanced Dynare* 课程）：回答"这个 Dynare 块/命令怎么写？"—— 命令语法、`steadystate.m` 接口、`discretionary_policy`、`lmmcp`、福利块、新闻冲击、高阶方法。

   两套本地库之后，再查你**个人模型存档库**（`model-archive-catalog.csv`），最后才上网补论文特定细节（精确校准来源、某条推导步骤）。**DSGE_mod 已全部本地化，不再需要上网查找。** 模型存档库在每次建模任务结束时自动更新——最终 `.mod` 与推导 md 归档到 `references/model-archive/`，并在 `references/model-archive-catalog.csv` 里新增一条索引。线性化参照只取方程内容/时序/校准，不照搬代码形式。
6. **慢模型的高效迭代**——对求解昂贵的模型（异质性 / HANK、估计、高阶），把一次性求解与反复调图拆开、缓存 `oo_`，让改图 / 改归一化 / 多模型对比（如 HANK vs RANK）都不重解模型；出图前先打印已知解析基准对一眼，拦住静默的归一化 / 缩放错误。

<details>
<summary>展开：八条硬规则 R1–R8（每行都对照）</summary>

| #  | 规则                                                                                                    |
| -- | ------------------------------------------------------------------------------------------------------- |
| R1 | 注释一律用用户所用语言；注释以外（`long_name`、`[name=]`、标识符）一律英文 / ASCII                  |
| R2 | 时序 = 决定期（期末存量）：状态变量当期带滞后，运动律左边是期末存量                                     |
| R3 | `varexo` 只放创新项；AR 等持续过程是内生变量                                                          |
| R4 | 方程数 = 内生变量数；`ramsey_model` / `discretionary_policy` 例外少 1 条                            |
| R5 | 禁用命名 `i`/`inv`/`e`/`E`、Dynare 命令、MATLAB 函数名；希腊字母写 `alppha`/`betta`/`gam` |
| R6 | 随机情形禁用 `max`/`min`/`abs`/`sign`/ 比较算子；偶尔约束用 OccBin                              |
| R7 | 每条语句 `;` 结尾、每块 `end;` 结尾、一行一条，参数先赋值后用                                       |
| R8 | 非线性优先；仅 `discretionary_policy` 或论文只给线性系统时才 `model(linear);`                       |

</details>

## 产出结构

完成一个建模任务后，工作目录里会留下一套可直接使用、可一键复跑的产物：

```text
<model>_derivation.md   # 推导文件：最优化问题 → FOC → 稳态求解 → 时序（先于代码交付你确认）
<model>.mod             # 模型本体：变量/参数声明、模型方程、稳态、冲击、实验命令
<model>_steadystate.m   # 外部稳态文件（仅当稳态需数值求解时；解析稳态写进 .mod 的 steady_state_model 块，则无此文件）
run_<model>.m           # 运行脚本：自包含一键复跑（addpath + cd + dynare + 自检 + 调绘图 + 缓存 oo_），按本机改一行 Dynare 路径即可双击运行
plot_irfs_pub.m         # 绘图脚本：IRF（脉冲响应）顶刊级矢量图
plot_series_pub.m       # 绘图脚本：时间序列 / 模拟序列 / 完全预见过渡路径
fig_*.pdf               # 发表级矢量图（可直接粘进论文）
<model>_oo.mat          # 求解结果缓存（run 脚本自动生成，可重生成的中间产物）
```

并非每次都出全部文件——产出随任务而定：

- **推导文件**仅在含非标准机制（TANK / HANK、金融摩擦、开放经济、最优政策、OccBin）或需核对方程自洽时产出；教科书标准件（基础 RBC、三方程 NK）会略过。
- **外部稳态文件**仅在稳态无解析解、需数值求解时产出；有解析稳态则直接写进 `.mod`，不单独出文件。
- **绘图脚本与图**按实验产出类型选：出 IRF 调 `plot_irfs_pub`，出模拟序列 / 过渡路径调 `plot_series_pub`；纯稳态检查、识别等无图任务略过。
- **运行脚本**默认产出，把上述零件串成一键复跑、并**自动调用绘图脚本**（不必再手动跑画图）；若你的项目已有总控 `main`，则把求解与出图接进现有 `main`、而非另起。

收尾时它只清理 Dynare 自动产物（`+<model>/`、`Output/`、`*_results.mat`、`.log` 等），上述成果文件与你上传的数据一律保留。

## 仓库结构

```text
.claude-plugin/marketplace.json     # 插件市场目录
plugins/dynare-copilot/                  # 插件
  └── .claude-plugin/plugin.json     # 插件清单
  └── skills/dynare-copilot/             # 捆绑的 skill
      ├── SKILL.md                   # 主干：硬规则 + 任务路由 + 主流程
      └── references/                # 按需读取的细节文件 + 模型索引 + 绘图与运行脚本
          ├── catalog.csv            # 149 篇 MMB 复制模型的索引（模型结构参考库）
          ├── catalog-code.csv       # 89 个 Pfeifer 示例的索引：41 个 DSGE_mod + 48 个 Advanced Dynare 课程（编程逻辑参考库）
          ├── model-archive-catalog.csv # 模型存档库索引：161 篇 MMB 论文推导 + 你历次任务积累的可复跑模型（用 Status 列区分）
          ├── known-issues.md       # 实战排错日志（现象 → 成因 → 修法），随 encode-back 增长
          ├── matlab-workflow.md    # MATLAB 侧工作流：求解/绘图解耦、缓存 oo_、多模型对比
          ├── examples/              # 149 篇 MMB rep-mmb 复制 .mod（文件名即 ModelID）
          ├── examples-code/         # 89 个 Pfeifer .mod，22 个子文件夹：41 个 DSGE_mod + 48 个 Advanced Dynare 课程（Dynare_Course/，按章分）
          └── model-archive/         # 161 篇 MMB 论文推导参照（仅推导、无 .mod）+ 你归档的可复跑模型；每模型一个子文件夹，来源元数据见 _mmb-provenance/
paper-candidates/                    # 为未来纳入而预选的候选论文清单（不属于 skill 本体）
```

<details>
<summary>展开：references/ 下各文件职责</summary>

| 文件                          | 内容                                                                                                                                                                                                                                                      |
| ----------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `workflow-detail.md`        | 主流程各步展开、运行闭环、收尾清理                                                                                                                                                                                                                        |
| `derivation-style.md`       | 推导文件的八节结构与公式规范                                                                                                                                                                                                                              |
| `modeling-blocks.md`        | 各主体建模逻辑库：家庭/厂商/政府央行/市场出清 block 的最优化问题、FOC 与结构变体                                                                                                                                                                          |
| `steady-state.md`           | 解析 / 数值稳态、反解校准、homotopy                                                                                                                                                                                                                       |
| `debugging.md`              | 报错 → 成因 → 修法、最终检查清单                                                                                                                                                                                                                        |
| `known-issues.md`           | 实战排错日志：具体踩过的坑「现象 → 成因 → 修法」，随时间增长（运行闭环先查它，新解决的报错回写）                                                                                                                                                        |
| `templates.md`              | RBC / NK / 完全预见 规范骨架                                                                                                                                                                                                                              |
| `stochastic-simulation.md`  | `stoch_simul`                                                                                                                                                                                                                                           |
| `higher-order.md`           | 高阶摄动：风险溢价 / 资产定价、不确定性（波动率）冲击、预防性储蓄、二 / 三阶福利、Epstein-Zin、GIRF、随机 / 遍历稳态、pruning                                                                                                                          |
| `perfect-foresight.md`      | 确定性 / 完全预见                                                                                                                                                                                                                                         |
| `estimation.md`             | 贝叶斯 / 最大似然                                                                                                                                                                                                                                         |
| `moments-method.md`         | GMM / SMM / IRF 匹配                                                                                                                                                                                                                                      |
| `shock-decomposition.md`    | 冲击 / 历史分解                                                                                                                                                                                                                                           |
| `forecasting.md`            | 预测 / 条件预测                                                                                                                                                                                                                                           |
| `identification.md`         | 识别与敏感性                                                                                                                                                                                                                                              |
| `ms-sbvar.md`               | 区制切换 / SBVAR                                                                                                                                                                                                                                          |
| `heterogeneity.md`          | HANK / 异质主体                                                                                                                                                                                                                                           |
| `optimal-policy.md`         | Ramsey / OSR / 相机抉择                                                                                                                                                                                                                                   |
| `occbin.md`                 | ZLB / 偶尔约束                                                                                                                                                                                                                                            |
| `macro-processor.md`        | `@#` 宏处理器                                                                                                                                                                                                                                           |
| `publication-plots.md`      | 发表级绘图，配套脚本 `plot_irfs_pub.m`（IRF）与 `plot_series_pub.m`（时间序列 / 模拟 / 过渡路径）                                                                                                                                                      |
| `run-script.md`             | 运行脚本 `run_<model>.m` 的写法：自包含一键复跑、按实验类型选产出、自动调用绘图脚本、有特定 `main` 的项目编排                                                                                                                                          |
| `matlab-workflow.md`        | 慢模型的 MATLAB 侧工作流：把昂贵的求解与廉价绘图解耦、缓存 `oo_`、项目脚手架（run / analyze 脚本）、多模型对比、解析基准即时校验                                                                                                                        |
| `catalog.csv`               | 149 篇模型参考库的索引：`ModelID`、论文、作者、期刊、模型类型、经济体、分类（14 桶）、关键特征。回答"这个经济机制该怎么建模？"                                                                                                                          |
| `catalog-code.csv`          | 89 个编程逻辑库的索引（41 个 DSGE_mod + 48 个 *Advanced Dynare* 课程）：`CodeID`、文件夹、论文、作者、模型类型、`DynareFeatures`（grep 落点，如命令名/块格式）、分类（11 桶）。回答"这个 Dynare 块/命令怎么写？"                                                                                       |
| `catalog-lookup.md`         | 如何按特征检索两套 catalog、各自的分类索引、模型存档库检索说明，以及用参考 `.mod` 的注意事项（线性化版 vs 非线性、参照不等于成品）                                                                                                                      |
| `model-archive-catalog.csv` | 模型存档库索引，字段格式与 catalog.csv 兼容，另含 `Task`、`DateAdded`、`Status` 列；`Status` 区分 161 篇 `derivation-only (needs_review)` MMB 论文推导（无 `.mod`——读结构、用前对照论文核对）与你历次任务积累的 `runnable` 模型（每次建模任务结束时自动追加）                                                                                                                                      |
| `model-archive.md`          | 模型存档库使用规范：两类条目（runnable 与 derivation-only）、目录结构、检索方式、存档流程、全新安装初始化                                                                                                                                                                                          |
| `examples/`                 | 149 篇 MMB rep-mmb 复制 `.mod`（文件名即 `ModelID`）。回答"经济结构该怎么设"                                                                                                                                                                          |
| `examples-code/`            | 89 个 Pfeifer `.mod`（及关键 `.m` 辅助文件），分 22 个子文件夹：41 个来自 DSGE_mod + 48 个来自他的 *Advanced Dynare* 课程（在 `Dynare_Course/` 下，按章组织）。涵盖：RBC 基础、NK 线性/非线性、TANK、估计（ML/贝叶斯/IRF 匹配）、矩方法、最优政策、高阶方法、完全预见、OccBin、开放经济、福利计算、新闻冲击、前瞻指引、识别、预测。回答"这个 Dynare 特性怎么实现" |
| `model-archive/`            | 模型存档库，每个模型一个子文件夹。含 161 篇 MMB 论文推导参照（仅推导：`*_derivation.en.md` / `.zh.md`，无 `.mod`）+ 你历次会话产出的可复跑 `.mod` 与推导 md；`_mmb-provenance/` 保存 MMB 来源元数据。未来建模任务自动优先检索，早于网络搜索                                                                                                                                                                          |

</details>

## 进阶

<details>
<summary>不走市场，手动安装 skill</summary>

把 skill 目录拷进个人 skills 目录即可，不需要插件市场：

```bash
cp -r plugins/dynare-copilot/skills/dynare-copilot ~/.claude/skills/
```

首次新建 `~/.claude/skills/` 后重启 Claude Code。只想给单个项目用，放到该项目的 `.claude/skills/dynare-copilot/`。

</details>

<details>
<summary>本地校验与更新</summary>

```bash
claude plugin validate .                      # 校验 marketplace.json
claude plugin validate ./plugins/dynare-copilot   # 校验 plugin.json 和 skill 元数据
```

发布更新：推一次 commit，用户运行 `/plugin marketplace update` 即可拉到最新。每次发布记得在 `plugin.json` 里递增 `version`。

</details>

<details>
<summary>运行环境路径配置</summary>

自动运行用到的 Dynare / MATLAB 路径在 `references/workflow-detail.md` 里配置，默认示例为 `C:\dynare\7.1`，按你的实际安装修改。

</details>

## 参与共建

这是一个正在快速迭代的项目。我们热情欢迎加入开发、反馈使用意见。

## 致谢

- [Dynare](https://www.dynare.org/) 及其[官方文档](https://www.dynare.org/manual/)。
- Johannes Pfeifer 的 [DSGE_mod](https://github.com/JohannesPfeifer/DSGE_mod) 及其 *Advanced Dynare* 课程——共同构成编程逻辑库（`references/examples-code/`，89 个示例：41 个来自 DSGE_mod + 48 个来自课程，在 `Dynare_Course/` 下）的来源。规范写法的主要参考：文件头、`long_name`/LaTeX 名、`[name=]` 标注、`steady_state_model` 反解校准。
- [Macroeconomic Model Data Base (MMB)](https://www.macromodelbase.com/rep-mmb) 及其复制档案（`IMFS-MMB/mmb-rep`，由 Volker Wieland 主持）——模型参考库（`references/examples/`，149 篇）与 `references/catalog.csv` 索引的来源。

## License

[MIT](./LICENSE) © 2026 EconSolider

MIT 仅覆盖本仓库自有内容；使用 Dynare、DSGE_mod 与 MMB / mmb-rep 档案的素材请遵循其各自许可与条款。
