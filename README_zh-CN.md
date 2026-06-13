# dynare-mod

![License](https://img.shields.io/badge/license-MIT-green)
![Claude Code](https://img.shields.io/badge/Claude%20Code-plugin-8A2BE2)
![Dynare](https://img.shields.io/badge/Dynare-7.1-blue)

> 这是一个 Claude Code skill，代替你把语言上的宏观经济直觉——"我想建一个带金融加速器的 NK 模型"、"给我复制 Smets-Wouters 2007"——转化为跑得通、稳态求得出、IRF 出得来的具体 Dynare `.mod` 文件。
>
> 它的核心在于把有经验的建模者才会遵循的流程**固定下来**：先推导方程、再翻译代码、分阶段运行验证。时序错误、命名冲突、稳态代数失误，在它们变成错误结果前就被截住。内置 **149 篇 MMB 复制模型库**（来自 [Macroeconomic Model Data Base](https://www.macromodelbase.com/rep-mmb)），每个新模型都从一份经过验证的参考出发，而不是凭空猜；每次完成的模型自动归档进**个人记忆库**，下次建模优先调用，越用越聪明。所有 IRF 以顶刊级矢量图交付，可以直接粘进论文。
>
> 没有时序坑，没有静默错误，没有空白纸。你只管想清楚经济学，剩下的交给它。
>
> *Enjoy 宏观经济的世界。*

---

## 环境要求

| 你想做的事                               | 需要装的东西                                                         |
| ---------------------------------------- | -------------------------------------------------------------------- |
| 让它**写 / 改 / 查** `.mod` 文件 | 只需[Claude Code](https://docs.claude.com/en/docs/claude-code/overview) |
| 自己**运行**生成的 `.mod`        | 额外需要[Dynare 7.1](https://www.dynare.org/) + MATLAB（或 Octave）     |
| 让它**自动运行并循环纠错**         | 再额外装一个 MATLAB MCP 服务器（在 VSCode 中）                       |

> 不装 MATLAB 也能用——它同样能帮你写模型、查报错，只是不替你跑。
>
> 如果提供具体的论文，能大大减少响应时间和 token 消耗。

## 安装（约 1 分钟）

先装好 Claude Code，见[官方安装指南](https://docs.claude.com/en/docs/claude-code/overview)，常见方式：`npm install -g @anthropic-ai/claude-code`。然后：

1. 在终端进入任意项目目录，运行 `claude` 启动 Claude Code。
2. 在 Claude Code 的对话里**逐行粘贴**下面两条命令：

   ```text
   /plugin marketplace add EconSolider/dynare-mod
   /plugin install dynare-mod@econsolider-skills
   ```

   第一行把本仓库注册为插件市场，第二行安装 `dynare-mod` 插件。
3. 完成。输入 `/` 能在菜单里看到 dynare-mod 就说明装好了。

> 把 `EconSolider/dynare-mod` 换成本仓库实际的 `用户名/仓库名`，`@econsolider-skills` 是固定的市场名，不用改。

## 快速上手

装好后，在 Claude Code 里**直接用中文或英文描述任务**即可，它会自动启用：

- "把这组 FOC 翻成 Dynare 代码：`c^-sigma = beta*E[c(+1)^-sigma*(r(+1)+1-delta)]` ……"
- "复制 Smets-Wouters 2007，季度校准，跑 IRF。"
- "给我的新凯恩斯主义模型加名义利率零下界（ZLB），用 OccBin。"
- "我的 mod 报 `Blanchard-Kahn conditions are not satisfied`，帮我查时序。"
- "把这几个变量的 IRF 绘成顶刊级图，基线 vs 高黏性两种情景对比，导出 PDF。"

也可以手动调用：`/dynare-mod:dynare-mod`。

`examples/`（仓库根目录）里有一个完整示例（含政府支出的 RBC），包含推导文件和最终 `.mod`，可对照学习。skill 内部在 `references/examples/` 下存放了 **149 篇 MMB rep-mmb 复制模型**（每篇论文一个 `.mod`，文件名即其 `ModelID`），由 `references/catalog.csv` 索引；还有一个最小教学范例（基础 RBC，推导与 `.mod` 逐条对应）供写推导时模仿格式。当你让它建模时，它会先按特征搜 `catalog.csv`，再搜个人 `memory-catalog.csv`，读最相近的 `.mod` 文件作参照，再下笔。

## 支持的任务

| 你说的                                                    | 它做的                          | Dynare 命令                                                   |
| --------------------------------------------------------- | ------------------------------- | ------------------------------------------------------------- |
| IRF、矩、方差分解、"模拟这个 DSGE/RBC/NK"                 | 随机模拟                        | `stoch_simul`                                               |
| 过渡路径、永久冲击、确定性、完全预见                      | 完全预见                        | `perfect_foresight_*`                                       |
| 贝叶斯、先验、MCMC、最大似然                              | 估计                            | `estimation`                                                |
| GMM、SMM、模拟矩、IRF 匹配                                | 矩方法估计                      | `method_of_moments`                                         |
| 历史分解、"哪个冲击在驱动"                                | 冲击分解                        | `shock_decomposition`                                       |
| 外推、条件预测、扇形图                                    | 预测                            | `forecast` / `conditional_forecast`                       |
| 能否识别、敏感性 / GSA                                    | 识别与敏感性                    | `identification` / `sensitivity`                          |
| Markov switching、结构 BVAR                               | MS-SBVAR                        | `markov_switching` / `sbvar`                              |
| HANK、Krusell-Smith、异质家庭                             | 异质性                          | `heterogeneity_*`                                           |
| Ramsey、相机抉择、福利、简单规则                          | 最优政策                        | `ramsey_model` / `osr`                                    |
| ZLB / 有效下限、抵押 / 借贷约束                           | 偶尔约束                        | `occbin_*` / `lmmcp`                                      |
| 多国、多部门、切换变体                                    | 宏处理器                        | `@#define / @#if / @#for`                                   |
| 复制某论文模型、"要个带 X 特征的模型"、不确定有无现成实现 | 本地库 + 记忆库检索（首先运行） | grep `catalog.csv` → `memory-catalog.csv` → 读 `.mod` |
| 顶刊级 IRF 图、导出 PDF 论文图、多情景 / 多冲击对比       | 发表级绘图                      | `plot_irfs_pub.m`                                           |
| 跑不通、BK 不满足、稳态求不出                             | 排错                            | 诊断命令                                                      |

## 工作原理

它不靠记忆硬写，而是按固定流程推进：

1. **先确认、再动笔**——在写代码之前，就**会改变方程结构的建模选择**（含哪些主体、劳动供给同/异质、含不含资本、市场结构……）会先问你拿答案；然后产出一份结构化推导文件（最优化问题 → FOC → 稳态求解 → 时序），你确认后才写代码。两处暂停都是为了在错误发生前拦住，而不是写完一大块再返工。
2. **增量构建**——变量声明 → 方程 → 稳态 → 冲击与实验，每阶段跑通/确认才往下写。
3. **非线性优先**——默认写原始非线性方程组交给 Dynare 展开，不手推线性化（这是最常见的隐蔽错误来源）。
4. **运行-纠错闭环**——接好 MATLAB MCP 时自动跑 Dynare、读报错、最小修复、重跑。
5. **三层模型检索**——建模前按特征搜索：① 内置 **149 篇 MMB 模型库**；② 你历次任务积累的**个人记忆库**；③ DSGE_mod 与网络检索（前两层无命中时才使用）。记忆库在每次建模任务收尾时自动更新——最终 `.mod` 与推导 md 归档到 `references/memory/`，并在 `references/memory-catalog.csv` 里新增一条索引。线性化参照只取方程内容/时序/校准，不照搬形式。

<details>
<summary>展开：八条硬规则 R1–R8（写每一行都对照）</summary>

| #  | 规则                                                                                                    |
| -- | ------------------------------------------------------------------------------------------------------- |
| R1 | 注释一律中文；注释以外（`long_name`、`[name=]`、标识符）一律英文 / ASCII                            |
| R2 | 时序 = 决定期（期末存量）：状态变量当期带滞后，运动律左边是期末存量                                     |
| R3 | `varexo` 只放创新项；AR 等持续过程是内生变量                                                          |
| R4 | 方程数 = 内生变量数；`ramsey_model` / `discretionary_policy` 例外少 1 条                            |
| R5 | 禁用命名 `i`/`inv`/`e`/`E`、Dynare 命令、MATLAB 函数名；希腊字母写 `alppha`/`betta`/`gam` |
| R6 | 随机情形禁用 `max`/`min`/`abs`/`sign`/ 比较算子；偶尔约束用 OccBin                              |
| R7 | 每条语句 `;` 结尾、每块 `end;` 结尾、一行一条；参数先赋值后用                                       |
| R8 | 非线性优先；仅 `discretionary_policy` 或论文只给线性系统时才 `model(linear);`                       |

</details>

## 仓库结构

```text
.claude-plugin/marketplace.json     # 插件市场目录
plugins/dynare-mod/                  # 插件
  ├── .claude-plugin/plugin.json     # 插件清单
  └── skills/dynare-mod/             # 附带的 skill
      ├── SKILL.md                   # 主干：硬规则 + 任务路由 + 主流程
      └── references/                # 按需读取的细节文件 + 模型索引 + 绘图脚本
          ├── catalog.csv            # 149 篇 MMB 复制模型的索引
          ├── memory-catalog.csv     # 你历次任务积累的模型索引（随用随长）
          ├── examples/              # 149 篇 MMB rep-mmb 复制 .mod（文件名即 ModelID）+ 最小 RBC 教学范例
          └── memory/                # 你的归档 .mod 与推导 md，随任务自动积累
examples/                            # 仓库级用法示例（含政府支出的 RBC），不属于 skill 本体
```

<details>
<summary>展开：references/ 下各文件职责</summary>

| 文件                         | 内容                                                                                                                                                         |
| ---------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `workflow-detail.md`       | 主流程各步展开、运行闭环、收尾清理                                                                                                                           |
| `derivation-style.md`      | 推导文件的八节结构与公式规范                                                                                                                                 |
| `modeling-blocks.md`       | 各主体建模逻辑库：家庭/厂商/政府央行/市场出清 block 的最优化问题、FOC 与结构变体                                                                             |
| `steady-state.md`          | 解析 / 数值稳态、反解校准、homotopy                                                                                                                          |
| `debugging.md`             | 报错 → 成因 → 修法、最终检查清单                                                                                                                           |
| `templates.md`             | RBC / NK / 完全预见 规范骨架                                                                                                                                 |
| `stochastic-simulation.md` | `stoch_simul`                                                                                                                                              |
| `perfect-foresight.md`     | 确定性 / 完全预见                                                                                                                                            |
| `estimation.md`            | 贝叶斯 / 最大似然                                                                                                                                            |
| `moments-method.md`        | GMM / SMM / IRF 匹配                                                                                                                                         |
| `shock-decomposition.md`   | 冲击 / 历史分解                                                                                                                                              |
| `forecasting.md`           | 预测 / 条件预测                                                                                                                                              |
| `identification.md`        | 识别与敏感性                                                                                                                                                 |
| `ms-sbvar.md`              | 区制切换 / SBVAR                                                                                                                                             |
| `heterogeneity.md`         | HANK / 异质主体                                                                                                                                              |
| `optimal-policy.md`        | Ramsey / OSR / 相机抉择                                                                                                                                      |
| `occbin.md`                | ZLB / 偶尔约束                                                                                                                                               |
| `macro-processor.md`       | `@#` 宏处理器                                                                                                                                              |
| `publication-plots.md`     | 发表级 IRF 绘图，随附脚本 `plot_irfs_pub.m`                                                                                                                |
| `catalog.csv`              | 149 篇参考模型库的索引：`ModelID`、论文、作者、期刊、模型类型、经济体、分类（14 桶）、关键特征                                                             |
| `catalog-lookup.md`        | 如何按特征搜索 catalog、14 类索引、记忆库检索说明，以及用参考 `.mod` 的照搬警示                                                                            |
| `memory-catalog.csv`       | 你历次任务积累的模型索引，字段格式与 catalog.csv 兼容，另含 `Task` 和 `DateAdded` 列；每次建模任务结束时自动追加                                         |
| `examples/`                | 149 篇 MMB rep-mmb 复制 `.mod`（文件名即 `ModelID`），建模时用作参照；另含最小 RBC 教学范例（八节推导 + 配套 `.mod`，FOC 编号与 `[name=]` 一一对应） |
| `memory/`                  | 你历次会话产出的 `.mod` 与推导 md 存档，未来建模任务自动优先检索，先于网络搜索                                                                             |

</details>

## 进阶

<details>
<summary>不走市场，手动安装 skill</summary>

把 skill 目录拷进个人 skills 目录即可，不需要插件市场：

```bash
cp -r plugins/dynare-mod/skills/dynare-mod ~/.claude/skills/
```

首次新建 `~/.claude/skills/` 后重启 Claude Code。只想给单个项目用，放到该项目的 `.claude/skills/dynare-mod/`。

</details>

<details>
<summary>本地校验与更新</summary>

```bash
claude plugin validate .                      # 校验 marketplace.json
claude plugin validate ./plugins/dynare-mod   # 校验 plugin.json 和 skill 元数据
```

发布更新：推一次 commit，用户运行 `/plugin marketplace update` 即可拉到最新。每次发布记得在 `plugin.json` 里递增 `version`。

</details>

<details>
<summary>运行环境路径配置</summary>

自动运行用到的 Dynare / MATLAB 路径在 `references/workflow-detail.md` 里配置，默认示例为 `C:\dynare\7.1`，按你的实际安装修改。

</details>

## 致谢

- [Dynare](https://www.dynare.org/) 及其[官方手册](https://www.dynare.org/manual/)。
- Johannes Pfeifer 的 [DSGE_mod](https://github.com/JohannesPfeifer/DSGE_mod)——规范写法（文件头、`long_name`/LaTeX 名、`[name=]` 标注、`steady_state_model` 反解校准）的主要参考。
- [Macroeconomic Model Data Base (MMB)](https://www.macromodelbase.com/rep-mmb) 及其复制档案（`IMFS-MMB/mmb-rep`，由 Volker Wieland 主持）——内置 149 篇参考模型库与 `catalog.csv` 索引的来源。

## License

[MIT](./LICENSE) © 2026 EconSolider

MIT 仅覆盖本仓库自有内容；使用 Dynare、DSGE_mod 与 MMB / mmb-rep 档案的素材请遵循其各自许可与条款。
