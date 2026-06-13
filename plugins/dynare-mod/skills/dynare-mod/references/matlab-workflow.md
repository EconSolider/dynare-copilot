# MATLAB 侧迭代工作流（求解/分析解耦、缓存 oo_、多模型对比）

> **何时读**：模型**求解慢**（异质性时间迭代、二/三阶、估计、大型模型），且你要**反复**
> 改图、改归一化、调分析口径；或要**组织多模型/多情景对比**（HANK vs RANK、基线 vs 反事实）；
> 或想把 `.mod` 的运行包成**可复跑脚本**。**本文件回答**：MATLAB 侧的驱动脚本怎么组织，
> 让"贵的求解只跑一次、便宜且要反复试的分析随便改"，并用解析基准即时抓 bug。
>
> 这是 workflow-detail.md §4.1「运行与纠错闭环」的补充：闭环讲"怎么把 .mod 跑通"，本文件讲"跑通之后
> 怎么高效地反复分析、出图、对比，不每改一处就重解一遍模型"。

## 一句话原则：求解贵、分析便宜且要反复试 → 两者拆开，中间用 .mat 缓存 oo_ 衔接

最常见也最隐蔽的时间浪费：把 `dynare <model>` 和绘图/分析代码写在**同一个脚本**里，于是每次
改一个图例、调一次归一化系数、修一个标签，都要把**整个模型重解一遍**。异质性 HANK 一次时间
迭代就要 ~30 秒，调十次图 = 白等 5 分钟，且每次都刷屏几千行迭代日志。

正确的形态是两段独立脚本，用一个 `.mat` 文件衔接：

```matlab
% ===== run_<model>.m —— 只负责求解，跑一次 =====
cd('<工作目录>');
dynare <model> noclearall nointeractive
save('<model>_oo.mat', 'oo_', 'M_', 'options_');   % 把结果冻存

% ===== analyze_<model>.m —— 只负责分析/出图，随便改、秒级重跑 =====
cd('<工作目录>');
S = load('<model>_oo.mat');           % 不重解，直接读冻存的结果
oo_ = S.oo_;  M_ = S.M_;
% ... 在这里改归一化、改子图、改标签、改对比口径，反复跑都不碰求解 ...
```

判据：**只要求解一次能产出的东西被你跑了第二次，就该缓存。** 改图、改 `Scale`、改横轴期数、
换对比变量，全都属于"分析"，不该触发重解。

## 项目目录与运行脚本（多文件项目的标准骨架）

单文件模型不必如此；但凡涉及**多模型对比、外部稳态、反复出图**，按下面组织，自己和用户都不易乱：

```
<project>/
├── <model>.mod                 # 模型本体
├── <model>_derivation.md       # 推导（阶段1 产出）
├── run_<model>.m               # 求解驱动：cd + dynare + save oo.mat
├── analyze_<model>.m           # 分析/出图：load oo.mat + plot_irfs_pub
├── plot_irfs_pub.m             # skill 自带绘图函数（从 references/ 拷入）
└── <model>_oo.mat              # 冻存的求解结果（中间产物，可重生成）
```

**运行脚本（`run_<model>.m`）固定写法**——让 MCP 一句 `run_matlab_file` 就能复跑，也方便用户自己重跑：

```matlab
cd('<工作目录>');                        % 绝对路径，避免 MCP 会话工作目录漂移
dynare <model> noclearall nointeractive  % noclearall 保留 oo_；nointeractive 不弹窗等输入
save('<model>_oo.mat', 'oo_', 'M_', 'options_');
```

`<model>_oo.mat` 是可重生成的中间产物，收尾按 SKILL.md §6 白名单清理；`run_*.m`/`analyze_*.m`
是你和用户的成果脚本，**不删**（与 `plot_irfs_pub.m` 同级别）。

## 多模型 / 多情景对比的组织

对比 HANK vs RANK、基线 vs 反事实时，**每个模型各自求解、各自冻存，最后在一个分析脚本里一起读**：

```matlab
% run_all.m —— 依次求解两个模型，各自冻存
cd('<dir>'); dynare rank_model noclearall nointeractive; oo_rank = oo_; save('rank_oo.mat','oo_rank');
cd('<dir>'); dynare hank_model noclearall nointeractive; oo_hank = oo_; save('hank_oo.mat','oo_hank');

% compare.m —— 只读冻存结果做对比图，反复改口径不重解
R = load('rank_oo.mat'); H = load('hank_oo.mat');
plot_irfs_pub({'Y','C'}, 'eps_g', ...
    'Scenarios',     {R.oo_rank, H.oo_hank}, ...
    'ScenarioNames', {'RANK','HANK'}, ...
    'Save', 'fig_g_multiplier');     % 多情景叠线见 publication-plots.md
```

要点：**先各自跑通存盘，再统一对比**。别在对比脚本里嵌两个 `dynare` 调用——那样每调一次对比
图就重解两个模型。

### 异质性（HANK）IRF 不在 oo_.irfs，取数见 heterogeneity.md

标准 `stoch_simul` 的 IRF 在 `oo_.irfs.<var>_<shock>`（`plot_irfs_pub` 直接吃）。**异质性框架不同**：
`heterogeneity_solve` 把 IRF 放在序列空间雅可比 `oo_.heterogeneity.dr` 里，取数方式与维度都不一样，
对比 HANK vs RANK 前**务必先读 `references/heterogeneity.md`「IRF 取数」节**，否则会对着错的字段画图。

## 拿解析基准即时校验（图会骗人，数字不会）

图形掩盖量级错误：一条形状对、但**整体差了 100 倍或符号反了**的曲线，肉眼常看不出。凡模型里
存在**已知解析结果**，求解后立刻 `fprintf` 打出来、和基准对一眼，再去信图：

| 场景 | 解析基准 | 抓什么 bug |
|------|----------|-----------|
| RANK 平衡预算政府支出 | 产出乘数 = 1（精确） | 归一化/`Scale` 写错（如多除了 100） |
| RANK 一次总付转移 | 产出效应 = 0（李嘉图等价） | 冲击口径错、符号反 |
| 稳态大比率 | `C/Y`、`I/Y`、`K/Y` 落在合理区间 | 校准或稳态代数错 |
| 货币冲击 | 紧缩使产出/通胀同向下行 | Taylor 规则符号、时序错 |

例：政府支出乘数本应 ≈ 1，脚本却打印 0.01——立刻暴露归一化多除了 100。**有锚点时先打印再信图**，
这一步几乎零成本却能在出图前拦住缩放/符号类错误。基准从哪来：解析稳态、教科书极限情形（李嘉图
等价、长期中性）、或同结构 RANK 基线的闭式解。

## 调通后关掉求解器逐步打印

时间迭代、HANK 校准、homotopy 等迭代求解器默认逐步刷 `||Δpolicy||`、残差范数等，**几百上千行**。
调试期看收敛轨迹有用；**一旦稳定收敛，就关掉**——既让输出（和你的上下文）干净可读，也省 MCP
回传成本。具体怎么静默随求解器/选项而异（部分支持 `verbose`/`quiet` 开关或 `options_` 字段），
确认跑通后顺手关掉，别让满屏迭代日志淹没真正要看的稳态残差与 BK 结论。

## 与既有参考的分工

- **怎么把 .mod 跑通、报错怎么修** → workflow-detail.md §4.1「运行与纠错闭环」+ `references/debugging.md`（本文件不重复）。
- **画图函数 `plot_irfs_pub` 的参数/多情景/置信带** → `references/publication-plots.md`。
- **异质性框架、HANK IRF 取数** → `references/heterogeneity.md`。
- **本文件**只回答"驱动脚本怎么组织，让贵的求解只跑一次、便宜的分析随便改"。
