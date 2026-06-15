# 发表级 IRF 绘图（plot_irfs_pub）

> **何时读**：用户要"好看的图""顶刊级 IRF""导出 PDF 给论文""多情景/多冲击对比图"，
> 或随机模拟跑完后想替换 Dynare 自带粗糙画图的场合。**本文件回答**：怎么用本 skill 自带的
> `references/plot_irfs_pub.m` 从 `oo_.irfs` 出发画出可直接进论文的矢量图。

Dynare 自带的 `stoch_simul` 画图（`<模型名>_IRF_*.eps`）排版粗、无法对比、字体杂。统一改用
本 skill 自带的 **`references/plot_irfs_pub.m`**：从 `oo_.irfs.<变量>_<冲击>` 直接取数，
变量=子图、情景/冲击=同图叠线，输出矢量 PDF。默认风格对标 AER/JME/Econometrica：tiledlayout
紧排、零线、无边框、**配色与线型同时变化**（保证黑白打印可辨——这是顶刊硬要求）。

## 接入流程（§3 主流程**阶段5b：凡产出 IRF 即默认执行**，不必等用户点名）

1. **复制脚本到工作目录**：把 `references/plot_irfs_pub.m` 拷到 `.mod` 所在目录（或 MATLAB
   path 上）。这是 skill 资产、不是中间产物，**收尾清理时不删**。
2. 跑 `stoch_simul` 时**关掉自带画图**省时间：加 `nograph`（如 `stoch_simul(order=1, irf=40, nograph) ...`）。
3. 确保要画的变量进了 `stoch_simul` 的变量列表（IRF 只对列出的变量生成）；要对数偏离就跑
   `log_*` 辅助变量或 `loglinear`（见 stochastic-simulation.md），此时 `Scale` 用默认 100。
4. 紧接 `.mod` 之后（脚本里或命令行）调用 `plot_irfs_pub(...)`，通过 MATLAB MCP 运行核对出图。

## 调用速查

```matlab
% 最简：oo_/M_ 已在工作区
plot_irfs_pub({'y','c','invest','l'}, 'eps_z');

% 存 PDF（论文图）
plot_irfs_pub({'y','c','invest','l'}, 'eps_z', 'Save','fig_irf_tech');

% 多情景对比（同变量同冲击叠线，黑白可辨）
plot_irfs_pub({'y','pi','r'}, 'eps_a', ...
    'Scenarios',     {oo_base, oo_alt}, ...
    'ScenarioNames', {'Baseline','Sticky wages'}, ...
    'Save','fig_irf_compare');

% 多冲击叠在同一张图
plot_irfs_pub({'y','c'}, {'eps_a','eps_g'}, 'OverlayShocks', true);

% 贝叶斯后验置信带（68%/90% 两层灰）
plot_irfs_pub({'y','pi'}, 'eps_a', 'Bands', {{lo90,hi90},{lo68,hi68}});

% 无参跑一张合成演示图，先确认风格
plot_irfs_pub
```

多情景对比的两个 `oo_` 这样拿到：跑完模型 A 后 `ooA = oo_;`，跑模型 B 后 `ooB = oo_;`，
再 `plot_irfs_pub(..., 'Scenarios', {ooA, ooB})`。或 `load('A/Output/A_results.mat')` 取各自 `oo_`。

## 常用参数

| 参数 | 作用 | 默认 |
|------|------|------|
| `Scale` | IRF 乘子（小数偏离→百分比给 100；levels 变量给 1） | 100 |
| `Horizon` | 画多少期 | 全长 |
| `Layout` | `[nr nc]` 子图网格 | 自动近正方 |
| `Titles` | 自定义子图标题（否则用 `long_name`/`${tex}$`） | long_name |
| `YLabel`/`XLabel` | 轴标题 | `Percent dev. from SS` / `Quarters` |
| `Save`/`Formats` | 文件名 / `{'pdf','eps','png'}` | 不存 / `{'pdf'}` |
| `Font`/`FontSize` | 字体 | `Helvetica` / 9 |
| `Grid`/`ZeroLine` | 网格 / 零线 | false / true |
| `OverlayShocks` | 多冲击叠同图（互斥于 Scenarios） | false |
| `Bands` | 置信带 `{{lo,hi}}` 或两段 `{{lo1,hi1},{lo2,hi2}}` | 无 |

标题自动取 `M_.endo_names_tex`（即 `.mod` 里 `${...}$`）走 LaTeX，没有则用 `long_name`，
再退变量名。所以**写 `.mod` 时给全 `long_name` 和 `${tex}$`，图就自带漂亮标题**——这反过来
强化 R1（标识符英文、注释用 §0 选定语言 [LANG]）与可读性习惯。

## 时间序列/模拟/过渡路径：`plot_series_pub`（IRF 之外的序列产出）

并非每次都出 IRF。**随机模拟序列**（`stoch_simul(periods=T)`）与**完全预见过渡路径**
（`perfect_foresight_solver`）的产出都落在 `oo_.endo_simul`，用姊妹脚本
**`references/plot_series_pub.m`** 出图（接口与风格同 `plot_irfs_pub`，run 脚本里**调用它、不内联手写 `plot`**）：

```matlab
% 最简：oo_/M_ 在工作区，画 endo_simul 里这几条路径
plot_series_pub({'y','c','k'}, 'Save','fig_sim');

% 看对稳态的偏离（减 oo_.steady_state；配 Scale=100 看百分比偏离）
plot_series_pub({'y','c'}, 'Center','ss', 'Scale',100, 'Save','fig_dev');

% 多情景过渡路径叠线（如基线 vs 改革）
plot_series_pub({'y','c'}, 'Scenarios',{ooA,ooB}, ...
    'ScenarioNames',{'Baseline','Reform'}, 'Save','fig_transition');

% 无参跑一张合成演示图，先确认风格
plot_series_pub
```

常用参数：`Source`（取哪条 [endo×T] 路径，默认 `endo_simul`）、`Center`（`none`/`ss`/`mean`）、
`Scale`、`Time`（自定义横轴）、`Horizon`，以及与 `plot_irfs_pub` 同名的 `Layout`/`Titles`/`Save`/`Formats` 等。
标题同样自动取 `long_name`/`${tex}$`。**两个脚本都是 skill 资产，收尾清理时不删。**

## 兼容性与清理

- 需 MATLAB R2020a+（`tiledlayout`/`exportgraphics`/`yline`）；更老版本自动回退
  `subplot`+`print`+手画零线（风格略降级但可用）。
- 收尾清理时 **`plot_irfs_pub.m` 与导出的 `fig_*.pdf/.eps/.png` 属用户成果与 skill 资产，
  绝不删**；删的是 Dynare 自带的 `<模型名>_IRF_*.eps`、图形夹等自动产物（见 SKILL.md §6
  与 workflow-detail.md「收尾清理」白名单）。
