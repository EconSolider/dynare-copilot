# dynare-mod

> 一个用于**编写、运行、调试和审查 Dynare `.mod` 模型文件**的 Claude Skill。
> 覆盖 DSGE / RBC / 新凯恩斯 / OLG 等宏观模型，从随机模拟到贝叶斯估计、最优政策、HANK、偶尔约束全流程。

`.mod` 是 Dynare 预处理器的**独立语言**（不是 MATLAB）。两类失误会**静默产生错误结果**而非干净报错：**时序约定错误** 和 **稳态不一致**。本 skill 的全部设计都围绕在这两点上拦住错误——靠一套硬规则、推导先行的工作流，以及通过 MATLAB MCP 的运行-纠错闭环。

---

## 为什么需要它

仅凭记忆手写 `.mod` 极易出错：时序下标、块语法、命名禁忌、稳态代数任何一处错都可能不报错而给出错误的 IRF 或矩。本 skill 把"先把经济学（数学）做对，再机械地翻译成代码"固化成流程，并在每一步用 Dynare 自身的诊断命令验证。

## 特性

- **硬规则 R1–R8**：时序、外生/内生划分、方程数=变量数、命名禁忌、随机情形禁用算子、非线性优先等，写每一行都对照。
- **推导先行**：先产出一份八节结构的 `<模型>_derivation.md`（最优化问题 → FOC → 市场出清 → 外生过程 → 稳态求解 → 时序 → 变量对照表），用户确认后再写代码，且写代码时全程照推导逐条翻译。
- **增量构建**：变量声明 → 模型方程 → 稳态 → 冲击与实验，分阶段递进，每阶段跑通才往下写。
- **MCP 运行-纠错闭环**：通过 MATLAB MCP 在 VSCode 里自动 `dynare` 运行、读报错、最小化修复、重跑（上限 5 轮、同错 2 轮即停）。
- **文献检索**：遇到不熟悉的论文/机制，先检索原文与现成 Dynare 实现（优先 DSGE_mod）再动笔，不凭模糊记忆编方程。
- **非线性优先**：默认写原始非线性方程组交给 Dynare 泰勒展开，不手推线性化（手推线性化是隐蔽错误重灾区）。

## 适用任务

| 信号词 | 任务 | 命令族 |
|--------|------|--------|
| IRF、矩、方差分解、模拟 DSGE/RBC/NK | 随机模拟 | `stoch_simul` |
| 过渡路径、永久冲击、确定性、完全预见 | 完全预见 | `perfect_foresight_*` |
| 贝叶斯、先验、MCMC、极大似然、`varobs` | 估计 | `estimation` |
| GMM、SMM、模拟矩、IRF 匹配 | 矩方法估计 | `method_of_moments` |
| 历史分解、哪个冲击驱动 | 冲击分解 | `shock_decomposition` 等 |
| 外推、条件预测、扇形图 | 预测 | `forecast` / `conditional_forecast` |
| 能否识别、敏感性/GSA | 识别与敏感性 | `identification` / `sensitivity` |
| Markov switching、结构 BVAR、SWZ | MS-SBVAR | `markov_switching` / `sbvar` 等 |
| HANK、Krusell-Smith、连续分布家庭 | 异质性 | `heterogeneity_*` |
| Ramsey、相机抉择、福利、简单规则 | 最优政策 | `ramsey_model` / `discretionary_policy` / `osr` |
| ZLB/有效下限、抵押/借贷约束、偶尔约束 | 偶尔约束 | `occbin_*` / 完全预见 `lmmcp` |
| 多国、多部门、变体切换 | 宏处理器 | `@#define/@#if/@#for` |
| 解析/数值稳态、反解校准 | 稳态 | `steady_state_model` / `initval` |
| BK 不满足、稳态求不出、跑不通 | 排错 | 诊断命令 |

## 工作流

```
判型 → 逐主体确认特征(⏸) → 知识判定/文献检索 → 增量构建 → 自查 → 交付
                                              │
        阶段1 写推导文件(⏸ 用户确认) ─────────┤
        阶段2 列变量声明 ────────────────────┤
        阶段3 写模型方程，核对方程数=变量数 ──┤  阶段3起每阶段
        阶段4 加稳态，求出稳态 ───────────────┤  走 MCP 运行-纠错闭环
        阶段5 加冲击与实验，跑出结果 ─────────┘
```

`⏸` 是暂停点：把问题/推导交付用户后结束本轮、等回答，不替用户拟答案。

## 硬规则速览（R1–R8）

| # | 规则 |
|---|------|
| R1 | 注释一律中文；注释以外（`long_name`、`[name=]`、标识符）一律英文/ASCII |
| R2 | 时序 = 决定期（期末存量）：状态变量当期带滞后，运动律左边是期末存量 |
| R3 | `varexo` 只放创新项；AR 等持续过程是内生变量 |
| R4 | 方程数 = 内生变量数（`ramsey_model`/`discretionary_policy` 例外少 1 条） |
| R5 | 禁用命名 `i`/`inv`/`e`/`E`、Dynare 命令、MATLAB 函数名；希腊字母写 `alppha`/`betta`/`gam` |
| R6 | 随机情形禁用 `max`/`min`/`abs`/`sign`/比较算子（拐点导数错误）；偶尔约束用 OccBin |
| R7 | 每条语句 `;` 结尾、每块 `end;` 结尾、一行一条；参数先赋值后用 |
| R8 | 非线性优先；仅 `discretionary_policy` 或论文只给线性系统时才 `model(linear);` |

## 环境要求

- **Dynare 7.1**（其他版本多数可用，时序与块语法约定一致）。
- **MATLAB**（或 Octave）用于运行 `.mod`。
- 可选：**MATLAB MCP** 服务器（在 VSCode 中），启用后 skill 可自动运行 Dynare 并闭环纠错；未启用时则交付文件 + 运行说明。

> 环境路径在 `references/workflow-detail.md` 中配置（默认示例为 `C:\dynare\7.1`），按实际安装修改。

## 安装与使用

本仓库是一个 **Claude Code 插件市场（plugin marketplace）**，一行命令即可安装。

**方式一 · 插件市场（推荐）**

```text
/plugin marketplace add EconSolider/dynare-mod
/plugin install dynare-mod@econsolider-skills
```

之后用 `/plugin marketplace update` 拉取更新。也可用非交互 CLI：`claude plugin marketplace add EconSolider/dynare-mod`。

**方式二 · 手动目录**（不走市场）

把 skill 目录拷进个人 skills 目录即可：

```bash
cp -r plugins/dynare-mod/skills/dynare-mod ~/.claude/skills/
# 结果：~/.claude/skills/dynare-mod/SKILL.md + references/
```

首次新建 `~/.claude/skills/` 后需重启 Claude Code。项目级则放 `<repo>/.claude/skills/dynare-mod/`。

**触发示例**（无需显式点名；插件 skill 也可手动 `/dynare-mod:dynare-mod` 调用）：

- “把这组 FOC 写成 dynare 代码：`c^-sigma = beta*E[c(+1)^-sigma*(r(+1)+1-delta)]`……”
- “复制 Smets-Wouters 2007，季度校准，跑 IRF”
- “给我的 NK 模型加名义利率有效下限（ZLB），用 OccBin”
- “我的 mod 报 `Blanchard-Kahn conditions are not satisfied`，帮我看时序”
- “用宏处理器写一个两国 DSGE，结构相同”

> 安装前请验证：`claude plugin validate .`（检查 marketplace.json）与 `claude plugin validate ./plugins/dynare-mod`（检查 plugin.json 及 skill 前置元数据）。

## 目录结构

本仓库即插件市场，skill 捆绑在插件内：

```
dynare-mod/                          # 市场仓库根
├── .claude-plugin/
│   └── marketplace.json             # 市场目录（name: econsolider-skills）
├── plugins/
│   └── dynare-mod/                  # 插件
│       ├── .claude-plugin/
│       │   └── plugin.json          # 插件清单（name/version/license…）
│       └── skills/
│           └── dynare-mod/          # 捆绑的 skill（自动发现）
│               ├── SKILL.md         # always-on 主干：硬规则 + 任务路由 + 主流程
│               └── references/      # 18 个按需读取的细节文件
│                   ├── workflow-detail.md      # 主流程展开、运行闭环、收尾清理
│                   ├── derivation-style.md     # 推导文件八节结构与公式规范
│                   ├── steady-state.md         # 解析/数值稳态、反解校准、homotopy
│                   ├── debugging.md            # 报错→病因→修法、最终检查清单
│                   ├── templates.md            # RBC / NK / 完全预见 规范骨架
│                   ├── stochastic-simulation.md
│                   ├── perfect-foresight.md
│                   ├── estimation.md           # 贝叶斯 / 极大似然
│                   ├── moments-method.md       # GMM / SMM / IRF 匹配
│                   ├── shock-decomposition.md
│                   ├── forecasting.md          # 预测 / 条件预测
│                   ├── identification.md       # 识别与敏感性
│                   ├── ms-sbvar.md             # 区制切换 / SBVAR
│                   ├── heterogeneity.md        # HANK / 异质主体
│                   ├── optimal-policy.md       # Ramsey / OSR / 相机抉择
│                   ├── occbin.md               # ZLB / 偶尔约束
│                   └── macro-processor.md      # @# 宏处理器
├── examples/                        # rbc_gov 用法示范（不属 skill 本体）
├── README.md
├── LICENSE
└── .gitignore
```


## 致谢与参考

- [Dynare](https://www.dynare.org/) 及其[官方手册](https://www.dynare.org/manual/)。
- Johannes Pfeifer 的 [DSGE_mod](https://github.com/JohannesPfeifer/DSGE_mod) 仓库——规范写法（文件头注释、`long_name`/LaTeX 名、`[name=]` 标注、`steady_state_model` 反解校准）的主要参考。

## License

[MIT](./LICENSE) © 2026 `EconSolider`

> 本 skill 内容参考了 [Dynare](https://www.dynare.org/) 手册与 [DSGE_mod](https://github.com/JohannesPfeifer/DSGE_mod)；MIT 许可仅覆盖本仓库自有内容，使用上述项目的素材请遵循其各自许可。
