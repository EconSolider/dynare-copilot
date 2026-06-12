# dynare-mod

![License](https://img.shields.io/badge/license-MIT-green)
![Claude Code](https://img.shields.io/badge/Claude%20Code-plugin-8A2BE2)
![Dynare](https://img.shields.io/badge/Dynare-7.1-blue)

> 一个帮你**编写、运行、调试 Dynare `.mod` 模型**的 Claude Code 插件。
> 覆盖 DSGE / RBC / 新凯恩斯 / HANK 等宏观模型，从随机模拟到贝叶斯估计、最优政策、偶尔约束全流程，并能一键导出顶刊级 IRF 图。
> 内置**149 篇复制模型库**（来自 [Macroeconomic Model Data Base](https://www.macromodelbase.com/rep-mmb)），按特征检索——每写一个新模型都先落在一份经过验证的参照实现上，而不是凭记忆硬写。

手写 `.mod` 最怕**静默出错**——时序、命名、稳态代数错了往往不报错，却给出错误的 IRF 或矩。本插件把"先把数学推导做对，再机械翻译成代码，并用 Dynare 自身命令逐步验证"固化成流程，帮你在出错前拦住错误。

---

## 环境要求

| 你想做的事                               | 需要装的东西                                                         |
| ---------------------------------------- | -------------------------------------------------------------------- |
| 让它**写 / 改 / 查** `.mod` 文件 | 只需[Claude Code](https://docs.claude.com/en/docs/claude-code/overview) |
| 自己**运行**生成的 `.mod`        | 额外需要[Dynare 7.1](https://www.dynare.org/) + MATLAB（或 Octave）     |
| 让它**自动运行并循环纠错**         | 再额外装一个 MATLAB MCP 服务器（在 VSCode 中）                       |

> 不装 MATLAB 也能用——它照样能帮你写模型、查报错，只是不替你跑。
>
> 如果提供具体的论文，能大大减少反应时间和token消耗。

## 安装（约 1 分钟）

先装好 Claude Code（见[官方安装指南](https://docs.claude.com/en/docs/claude-code/overview)，常见方式：`npm install -g @anthropic-ai/claude-code`）。然后：

1. 在终端进入任意项目目录，运行 `claude` 启动 Claude Code。
2. 在 Claude Code 的对话里**逐行粘贴**下面两条命令：

   ```text
   /plugin marketplace add EconSolider/dynare-mod
   /plugin install dynare-mod@econsolider-skills
   ```

   第一行把本仓库登记为插件市场，第二行安装 `dynare-mod` 插件。
3. 完成。输入 `/` 能在菜单里看到 dynare-mod 就说明装好了。

> 把 `EconSolider/dynare-mod` 换成本仓库实际的 `用户名/仓库名`；`@econsolider-skills` 是固定的市场名，不用改。

## 快速上手

装好后，在 Claude Code 里**直接用中文描述任务**即可，它会自动启用：

- “把这组 FOC 写成 Dynare 代码：`c^-sigma = beta*E[c(+1)^-sigma*(r(+1)+1-delta)]` ……”
- “复制 Smets-Wouters 2007，季度校准，跑 IRF。”
- “给我的新凯恩斯模型加名义利率有效下限（ZLB），用 OccBin。”
- “我的 mod 报 `Blanchard-Kahn conditions are not satisfied`，帮我看时序。”
- “把这几个变量的 IRF 画成顶刊级图，基准 vs 高粘性两情景叠加对比，导出 PDF。”

也可以手动调用：`/dynare-mod:dynare-mod`。

`examples/`（仓库根目录）里有一个完整示范（含政府支出的 RBC），包含推导文件和最终 `.mod`，可对照学习。skill 内部在 `references/examples/` 下捆绑了**149 篇 MMB rep-mmb 复制模型**（每篇论文一个 `.mod`，文件名即其 `ModelID`），由 `references/catalog.csv` 索引；另有一个最小教学范例（基础 RBC，推导与 `.mod` 逐条对应），供它写推导时照格式仿写。当你让它建模时，它会先按特征 grep `catalog.csv`，读最相近的一两个 `.mod` 作参照再动笔。

## 支持的任务

| 你说的                                              | 它做的       | Dynare 命令                             |
| --------------------------------------------------- | ------------ | --------------------------------------- |
| IRF、矩、方差分解、“模拟这个 DSGE/RBC/NK”         | 随机模拟     | `stoch_simul`                         |
| 过渡路径、永久冲击、确定性、完全预见                | 完全预见     | `perfect_foresight_*`                 |
| 贝叶斯、先验、MCMC、极大似然                        | 估计         | `estimation`                          |
| GMM、SMM、模拟矩、IRF 匹配                          | 矩方法估计   | `method_of_moments`                   |
| 历史分解、“哪个冲击在驱动”                        | 冲击分解     | `shock_decomposition`                 |
| 外推、条件预测、扇形图                              | 预测         | `forecast` / `conditional_forecast` |
| 能否识别、敏感性 / GSA                              | 识别与敏感性 | `identification` / `sensitivity`    |
| Markov switching、结构 BVAR                         | MS-SBVAR     | `markov_switching` / `sbvar`        |
| HANK、Krusell-Smith、异质家庭                       | 异质性       | `heterogeneity_*`                     |
| Ramsey、相机抉择、福利、简单规则                    | 最优政策     | `ramsey_model` / `osr`              |
| ZLB / 有效下限、抵押 / 借贷约束                     | 偶尔约束     | `occbin_*` / `lmmcp`                |
| 多国、多部门、变体切换                              | 宏处理器     | `@#define / @#if / @#for`             |
| 复制某论文模型、"要个带 X 特征的模型"、不确定有无现成实现 | 本地模型库检索（最先做） | grep `catalog.csv` → 读 `examples/<ID>.mod` |
| 顶刊级 IRF 图、导出 PDF 论文图、多情景 / 多冲击对比 | 发表级绘图   | `plot_irfs_pub.m`                     |
| 跑不通、BK 不满足、稳态求不出                       | 排错         | 诊断命令                                |

## 工作原理

它不靠记忆硬写，而是按固定流程推进：

1. **先确认、再落笔**——动手前先就**会改变方程结构的建模选择**（含哪些主体、劳动供给同/异、含不含资本、市场结构……）问你拍板；随后产出一份结构化推导文件（最优化问题 → FOC → 稳态求解 → 时序），你确认后才写代码。两处暂停都是为了在出错前拦住错误，而不是写完一堆再返工。
2. **增量构建**——变量声明 → 方程 → 稳态 → 冲击与实验，每阶段跑通才往下写。
3. **非线性优先**——默认写原始非线性方程组交给 Dynare 展开，不手推线性化（隐蔽错误重灾区）。
4. **运行-纠错闭环**——接好 MATLAB MCP 时自动跑 Dynare、读报错、最小化修复、重跑。
5. **先查本地模型库**——建模前先按特征（模型类型 / 核心机制 / 经济体）grep 内置的 149 篇 MMB rep-mmb 复制模型，定位几篇相近论文，读 `references/examples/` 下对应的 `.mod` 作参照；本地库没有相近的，才回退到 DSGE_mod 与 web 检索。线性化的参照只取其方程内容、时序与校准，不照抄——因为本 skill 默认写非线性（R8）。

<details>
<summary>展开：八条硬规则 R1–R8（写每一行都对照）</summary>

| #  | 规则                                                                                                    |
| -- | ------------------------------------------------------------------------------------------------------- |
| R1 | 注释一律中文；注释以外（`long_name`、`[name=]`、标识符）一律英文 / ASCII                            |
| R2 | 时序 = 决定期（期末存量）：状态变量当期带滞后，运动律左边是期末存量                                     |
| R3 | `varexo` 只放创新项；AR 等持续过程是内生变量                                                          |
| R4 | 方程数 = 内生变量数（`ramsey_model` / `discretionary_policy` 例外少 1 条）                          |
| R5 | 禁用命名 `i`/`inv`/`e`/`E`、Dynare 命令、MATLAB 函数名；希腊字母写 `alppha`/`betta`/`gam` |
| R6 | 随机情形禁用 `max`/`min`/`abs`/`sign`/ 比较算子；偶尔约束用 OccBin                              |
| R7 | 每条语句 `;` 结尾、每块 `end;` 结尾、一行一条；参数先赋值后用                                       |
| R8 | 非线性优先；仅 `discretionary_policy` 或论文只给线性系统时才 `model(linear);`                       |

</details>

## 仓库结构

```
.claude-plugin/marketplace.json     # 插件市场目录
plugins/dynare-mod/                  # 插件
  ├── .claude-plugin/plugin.json     # 插件清单
  └── skills/dynare-mod/             # 捆绑的 skill
      ├── SKILL.md                   # 主干：硬规则 + 任务路由 + 主流程
      └── references/                # 按需读取的细节文件 + 模型索引 catalog.csv + 绘图脚本 plot_irfs_pub.m
          └── examples/              # 149 篇 MMB rep-mmb 复制 .mod（文件名即 ModelID）+ 一个最小 RBC 教学范例
examples/                            # 仓库级用法示范（含政府支出的 RBC，不属 skill 本体）
```

<details>
<summary>展开：references/ 各文件职责</summary>

| 文件                         | 内容                                                                                     |
| ---------------------------- | ---------------------------------------------------------------------------------------- |
| `workflow-detail.md`       | 主流程各步展开、运行闭环、收尾清理                                                       |
| `derivation-style.md`      | 推导文件的八节结构与公式规范                                                             |
| `modeling-blocks.md`       | 分主体建模逻辑库：家庭/厂商/政府央行/市场出清各 block 的最优化问题、FOC 与结构变体       |
| `steady-state.md`          | 解析 / 数值稳态、反解校准、homotopy                                                      |
| `debugging.md`             | 报错 → 病因 → 修法、最终检查清单                                                       |
| `templates.md`             | RBC / NK / 完全预见 规范骨架                                                             |
| `stochastic-simulation.md` | `stoch_simul`                                                                          |
| `perfect-foresight.md`     | 确定性 / 完全预见                                                                        |
| `estimation.md`            | 贝叶斯 / 极大似然                                                                        |
| `moments-method.md`        | GMM / SMM / IRF 匹配                                                                     |
| `shock-decomposition.md`   | 冲击 / 历史分解                                                                          |
| `forecasting.md`           | 预测 / 条件预测                                                                          |
| `identification.md`        | 识别与敏感性                                                                             |
| `ms-sbvar.md`              | 区制切换 / SBVAR                                                                         |
| `heterogeneity.md`         | HANK / 异质主体                                                                          |
| `optimal-policy.md`        | Ramsey / OSR / 相机抉择                                                                  |
| `occbin.md`                | ZLB / 偶尔约束                                                                           |
| `macro-processor.md`       | `@#` 宏处理器                                                                          |
| `publication-plots.md`     | 发表级 IRF 绘图（配套脚本 `plot_irfs_pub.m`）                                          |
| `catalog.csv`              | 149 篇参照模型库的索引：`ModelID`、论文、作者、期刊、模型类型、经济体、分类（14 桶）、关键特征 |
| `catalog-lookup.md`        | 如何按特征检索 catalog、14 类索引，以及用参照 `.mod` 的照搬警示（线性化 vs 非线性、参照≠成品） |
| `examples/`                | 149 篇 MMB rep-mmb 复制 `.mod`（文件名即 `ModelID`），建模时作参照；另含一个最小 RBC 教学范例（八节推导 + 配套 `.mod`，FOC 编号与 `[name=]` 一一对应） |

</details>

## 进阶

<details>
<summary>不走市场，手动安装 skill</summary>

把 skill 目录拷进个人 skills 目录即可（无需插件市场）：

```bash
cp -r plugins/dynare-mod/skills/dynare-mod ~/.claude/skills/
```

首次新建 `~/.claude/skills/` 后需重启 Claude Code。只想给单个项目用，则放到该项目的 `.claude/skills/dynare-mod/`。

</details>

<details>
<summary>本地校验与更新</summary>

```bash
claude plugin validate .                      # 校验 marketplace.json
claude plugin validate ./plugins/dynare-mod   # 校验 plugin.json 及 skill 元数据
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
- [Macroeconomic Model Data Base (MMB)](https://www.macromodelbase.com/rep-mmb) 及其复制档（`IMFS-MMB/mmb-rep`，由 Volker Wieland 主持）——内置 149 篇参照模型库与 `catalog.csv` 索引的来源。

## License

[MIT](./LICENSE) © 2026 EconSolider

MIT 仅覆盖本仓库自有内容；使用 Dynare、DSGE_mod 与 MMB / mmb-rep 档案的素材请遵循其各自许可与条款。
