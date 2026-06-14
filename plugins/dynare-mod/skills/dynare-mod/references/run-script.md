# 运行脚本 `run_<model>.m`（把零件接成一键复跑的总装脚本）

> **何时读**：交付一个可让用户在自己 MATLAB 里**一键复跑**模型的驱动脚本时（§3 第6步默认产出）；
> 或用户问"怎么运行""给我个跑的脚本""图怎么自动出来"。**本文件回答**：怎么写这个 `.m`，
> 让它把已生成的零件（`.mod` + 稳态 `.m` + 绘图/产出代码 + 自检打印）**接成一条龙自动跑完**，
> 而不是又丢一个孤立、还得用户手动配路径、手动调画图的半成品。

## 核心定位：run 脚本是"总装"，不是又一个孤立文件

到了交付，工作目录里通常已经躺着几个零件：模型本体 `<model>.mod`、（可能的）外部稳态文件
`<model>_steadystate.m`、绘图函数 `plot_irfs_pub.m`。**它们各自不会自己跑起来**——尤其绘图代码，
过去最常见的疏漏就是：脚本拷过去了，但没有任何一行调用它，于是用户跑完 `dynare` 只看到 Dynare
自带的粗糙图，发表级图根本没生成。run 脚本的唯一职责，就是**按正确顺序把这些零件串起来、并真正
调用它们**，让用户改一行路径就能从求解一路自动跑到出图、出数。

因此判据很简单：**run 脚本跑完，用户该看到的产出（图/数）是否都自动出现了？** 缺哪个就是漏接了哪个零件。

## 每个项目结构不同——这是写法指引，不是死模板

不同任务的 run 脚本长得不一样：单文件 RBC 三行就够；带外部稳态文件的要确保稳态 `.m` 在路径上；
多模型对比要依次求解各自冻存；有些既有项目本就有一个 `main`/总控脚本，这时**把新模型的求解与出图
接进那个 main，而不是另起炉灶**。所以下面给的是**五个固定环节 + 按实验类型选产出**的拼装法，
照具体项目填充，不要原样照搬变量名与路径。

## 五个固定环节（骨架）

```matlab
% =====================================================================
%  run_<model>.m  —  <一句话：本脚本求解 X 模型并产出 Y>
%  用法：在 MATLAB 中直接运行（双击 / F5），无需手动配路径或切目录。
% =====================================================================
clear; close all; clc;

% ---- 1. 环境：自包含，开箱即用 ----
%   addpath 让干净的 MATLAB 也找得到 Dynare；cd 到脚本自身目录，避免 MCP/会话工作目录漂移
DYNARE_PATH = 'C:\dynare\7.1\matlab';      % 按本机改这一行
addpath(DYNARE_PATH);
cd(fileparts(mfilename('fullpath')));

% ---- 2. 求解：dynare 会自动调用同名 <model>_steadystate.m（若存在）----
dynare <model> noclearall nointeractive    % noclearall 保留 oo_ 供后续取用

% ---- 3. 关键结果自检：数字不会骗人，先打印再信图（见 matlab-workflow.md）----
ss = @(v) oo_.steady_state(strcmp(M_.endo_names, v));   % 按变量名取稳态值
fprintf('\n===== steady-state check =====\n');
fprintf('C/Y = %.4f   I/Y = %.4f\n', ss('c')/ss('y'), ss('invest')/ss('y'));

% ---- 4. 产出/出图：按实验类型选（见下表），并**真正调用**产出代码 ----
plot_irfs_pub({'y','c','invest','l'}, 'eps_z', 'Save', 'fig_irf');

% ---- 5. 冻存结果：供 analyze_<model>.m 反复改图时复用，不重解 ----
save('<model>_oo.mat', 'oo_', 'M_', 'options_');
```

第1、2、5 环节几乎所有任务通用；**第3、4 环节按模型与实验填**。注释一律用 §0 选定的 `[LANG]`
（R1：`.mod` 与 `.m` 同规则——注释随 [LANG]，标识符/字符串一律英文 ASCII）。

## 第4环节按实验类型选产出（产出不一定是 IRF）

run 脚本最容易写死成"画 IRF"，但本 skill 的实验类型很多，产出从哪取、怎么呈现各不相同。
**先看本任务的实验命令，再选对应产出代码接进第4环节**：

| 实验（命令）                              | 产出在哪                                   | 第4环节怎么写                                                                 |
| ----------------------------------------- | ------------------------------------------ | ----------------------------------------------------------------------------- |
| 随机模拟·IRF（`stoch_simul(irf=N)`）     | `oo_.irfs.<var>_<shock>`                  | 调**绘图脚本** `plot_irfs_pub({...}, 'eps_x', 'Save','fig_irf');`（见 publication-plots.md） |
| 随机模拟·模拟序列（`stoch_simul(periods=T)`） | `oo_.endo_simul`                        | 调**绘图脚本** `plot_series_pub({'y','c'}, 'Save','fig_sim');`（看偏离加 `'Center','ss'`） |
| 随机模拟·理论矩（`periods=0`）           | `oo_.mean`/`oo_.var`/`oo_.autocorr`     | 无图，`fprintf` 打印矩表（均值/标准差/自相关/相关阵关键项）                   |
| 完全预见过渡路径（`perfect_foresight_solver`） | `oo_.endo_simul`（各期路径）             | 调**绘图脚本** `plot_series_pub({'y','c','k'}, 'Save','fig_transition');`     |
| 估计·后验 IRF（`estimation`）            | `oo_.PosteriorIRF` / 后验图              | `plot_irfs_pub` 吃后验 IRF + 置信带（`'Bands',{{lo,hi}}`，见 publication-plots.md） |
| 预测/条件预测（`forecast`）              | `oo_.forecast`                            | 扇形图（自带 `_forecast` 图或自画分位带）                                     |
| 冲击分解（`shock_decomposition`）        | `oo_.shock_decomposition`                 | 堆叠柱状图（见 shock-decomposition.md）                                       |

要点：**第4环节必须真的调用绘图脚本并核对它生成了文件/图**——这是过去最常漏的一环。本 skill
**两个绘图脚本各管一类产出，都是现成的、直接调用、不要内联手写 `plot`**：
- `plot_irfs_pub.m`——IRF（脉冲响应），见 publication-plots.md；
- `plot_series_pub.m`——时间序列：模拟序列、完全预见过渡路径（`oo_.endo_simul`），接口与风格同上。

两者都要先拷进工作目录（属 skill 资产、收尾不删）。若一次任务同时产出多种（如又出 IRF 又出模拟序列），
就在第4环节顺次调多段、各自落地。`plot_series_pub` 用法：`plot_series_pub({'y','c'}, 'Save','fig_sim')`，
看对稳态的偏离加 `'Center','ss'`（配 `'Scale',100` 看百分比），多情景叠线用 `'Scenarios',{ooA,ooB}`。

## 项目特异变体

**① 项目已有 `main`/总控脚本**：不要另起 `run_<model>.m`，把第2、4环节（求解 + 出图）接进既有
`main` 的相应位置，沿用它的路径/目录约定。交付时说明"已接入现有 main 的第 N 步"。

**② 外部数值稳态文件**：`dynare <model>` 会**自动**探测并调用同目录的 `<model>_steadystate.m`，
无需在 run 脚本里手动 `run` 它——只要确保它与 `.mod` 同名、同目录、在路径上即可。

**③ 多模型/多情景对比**：各模型**各自求解、各自冻存**，最后统一读 `.mat` 出对比图，别在对比段里
嵌多个 `dynare`（否则每改一次图重解所有模型）。完整骨架见 matlab-workflow.md「多模型对比」。

**④ 求解很贵（HANK/估计/三阶）**：把"求解"与"分析/出图"拆成 `run_<model>.m`（只求解 + 冻存）
与 `analyze_<model>.m`（读 `.mat` + 出图），贵的求解只跑一次。理由与骨架见 matlab-workflow.md。

## 与既有参考的分工

- **绘图脚本 `plot_irfs_pub`（IRF）与 `plot_series_pub`（时间序列/过渡路径）的参数/多情景/置信带** → publication-plots.md（本文件只管"在 run 脚本里调用它们"）。
- **求解/分析解耦、缓存 oo_、多模型组织、解析基准自检** → matlab-workflow.md。
- **怎么把 `.mod` 跑通、报错怎么修** → workflow-detail.md §4.1 +  debugging.md。
- **本文件**只回答"怎么写那个把零件串起来、一键复跑且自动出产出的 `.m`"。
