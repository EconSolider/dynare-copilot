# 运行 Dynare 与排错（MCP 闭环核心）

> **何时读**：① 交付前自查（最终检查清单）；② MCP 运行报错时（报错→病因→修法表）。**本文件回答**：BK/稳态/奇异雅可比/语法/估计类报错的诊断与修复、诊断命令。

本文件服务于"写 `.mod` → 通过 MATLAB MCP 运行 → 读报错 → 修复 → 重跑"的闭环。
交付前先过一遍"最终检查清单"，遇到用户反馈的报错时查"报错→病因→修法"表。

## bug 处理协议（先查后补，让排错库随用随长）

遇到任何 Dynare/MATLAB 报错，按固定次序处理，**不要一上来就从头推**——skill 里很多坑是别人
（或你上次）已经踩平、写下修法的，重新诊断一遍是纯浪费：

1. **先查 skill 内已编码的排错知识**（命中就直接照修法改，别重新发明）：
   - **`references/known-issues.md`「已知坑与修法」——实战踩坑日志，先扫这里**（按现象快速命中具体坑）；
   - 本文件「报错 → 病因 → 修法」表（语法/BK/稳态/奇异雅可比/估计/MATLAB 层等结构性报错）；
   - 任务相关 reference 的"常见报错与陷阱"节——尤其 `heterogeneity.md`（HANK 框架 varexo 顺序崩溃、
     IRF 取数）、`steady-state.md`、`perfect-foresight.md`、`occbin.md`、`estimation.md`；
   - 「最终检查清单」（很多 BK/奇异雅可比问题其实是清单某条没过）。
   **这是硬性优先级**：skill 里写过的坑，不要再踩着从头推一遍。

2. **没查到 → 自己定位**：用诊断命令（`model_diagnostics;`、`model_info;`、`resid;`、`check;`）+
   对照官方示例（SKILL.md §2.5 / `examples-code/`）缩小范围，按"每轮只改一处、最小化修复"找根因。

3. **解决后回写 skill（关键，这就是"写新功能"）**：凡是 skill 里**没有**、你自己新定位到的报错，
   **解决的当下立即往 TodoList 追加一条** `回写 known-issues.md：<一句话现象>`——别等收尾再回忆。
   原因很实在：bug 一修好，注意力立刻转回主任务，到交付时这条经验已模糊、或被"任务完成"的压力
   挤掉，**这正是排错库长不起来、同一个坑被反复重踩的根因**。交付前把该 TodoList 条目落地：追加
   一条到 **`references/known-issues.md`**（沿用其条目格式：现象 → 根因 → 修法 + 正/反例代码 → 详见）；
   框架特异的坑同时在对应 reference 的"常见报错与陷阱"节补一份。这样同一个坑下次直接命中第 1 步，
   skill 的排错库随用随长。判定 novel：第 1 步各处都查不到对应条目；**拿不准就补，重复比遗漏代价小**。
   （SKILL.md §3 已把"回写 known-issues.md"列为建模任务的固定收尾 TodoList 项，与归档询问并列。）

> 即"消费"与"生产"并行：第 1 步消费已有排错知识，第 3 步把新知识生产回 `known-issues.md`。两步都做，skill 才会越用越强。

## 通过 MATLAB MCP 运行的标准步骤

1. **定位 MCP 工具**：在工具列表找 MATLAB MCP 提供的"执行 MATLAB 命令/脚本""读工作区"
   "捕获输出"等工具（不同 MCP 服务器工具名不同，按实际可用的来）。
2. **准备环境**（路径按用户实际安装填写）：
   ```matlab
   addpath('<dynare安装目录>/matlab');   % 仅当 Dynare 不在路径上
   cd('<.mod所在目录>');
   ```
3. **运行并捕获全部输出**：
   ```matlab
   dynare <文件名不带扩展名> noclearall
   ```
   调试期建议加 `noclearall`（保留工作区）；想跳过画图加 `nograph`。
4. **判读输出**：见下方对照表。
5. **最小化修复后重跑**：每轮只改一处并说明改了什么，避免来回震荡。
6. **干净跑通后验证**（用 MCP 读工作区）：
   ```matlab
   oo_.dr.eigval        % 特征值 / BK
   oo_.steady_state     % 稳态向量（无 NaN、经济合理）
   oo_.mean, oo_.var    % 理论矩
   M_.endo_names        % 变量顺序
   ```
7. **收敛纪律**：自动迭代有上限；反复无法收敛时停下，向用户说明卡点、已试方案、所需
   信息（更好的初猜、正确的校准目标、数据文件等）。

调试期常追加运行的诊断命令：`resid;`、`model_diagnostics;`、`model_info;`、`check;`。

## 最终检查清单（每个文件；括号内为 SKILL.md 硬规则编号）

1. **方程数 = 内生变量数**（R4；例外：`ramsey_model`/`discretionary_policy` 少一个）。
2. **时序约定**（R2）：状态变量当期带滞后（生产里 `k(-1)`）；运动律左边是期末存量
   （`k = invest + (1-delta)*k(-1)`）；控制变量自身无超前。没有把 `k(-1)` 误写成 `k`。
3. **外生仅为创新项**（R3）：所有持续过程（AR 等）是**内生**变量，只有其创新项进 `varexo`。
4. **无禁用命名**（R5）：不用 `i`、`inv`、`e`、`E`，不与 Dynare 命令/MATLAB 函数同名；用稳态
   文件时还避开 `alpha`/`beta`/`gamma`（写 `alppha`/`betta`/`gam`）。
5. **参数先赋值后使用**（R7）——尤其在 `steady_state_model`（自上而下求值）之前。
6. **冲击块匹配情形**：随机用 `stderr`/`var =`/`corr`；完全预见用 `periods`/`values`。
7. **稳态存在且一致**：`steady_state_model`（首选）或给每个内生变量 `initval` 初猜；后接
   `resid; steady; check;`。
8. **随机情形无 `max`/`min`/`abs`/`sign`/比较算子**（R6）。
9. **每条语句以 `;` 结尾、每个块以 `end;` 结尾**（R7）；一行一条语句（未知行首会被当原生 MATLAB）。
10. **注释用 §0 选定语言 [LANG]、注释以外英文/ASCII**（R1）：`long_name='...'`、`[name='...']`、
    标识符等非注释内容全英文，否则预处理器报错；注释要充分、用 [LANG] 写。
11. **形式正确**（R8）：默认原始非线性方程组；仅 `discretionary_policy` 或用户要线性版/
    论文只给线性系统时才写线性化并用 `model(linear);` 声明；
    非线性模型冲击标准差按小数（1% = `stderr 0.01`）。
12. **实验已指定**（`stoch_simul`/`perfect_foresight_*`/`estimation`/`ramsey_*`/`osr` 之一）
    且选项合理。
13. **Walras 定律冗余方程已剔出**（多主体模型必查）：在含家庭预算约束、商品市场出清、
    资产市场出清等多条均衡条件的模型中，其中一条由其余条件线性组合推出，是冗余的——
    应当在推导 md 第4节注明该方程冗余，并确认 model 块**没有**把它写进去。
    表面方程数=变量数但实际少一条独立方程 → 静态雅可比奇异、BK 失败；
    用 `model_diagnostics;` 可辅助定位奇异来源。

## 阶段3：如何核对方程数 = 变量数

增量构建阶段3（只有声明+模型，还没写稳态/实验）跑 Dynare 时：

- 预处理器在解析模型时会校验方程数与内生变量数。**数目不符**会直接报错，类似
  `ERROR: ... The number of equations (N) doesn't match the number of endogenous
  variables (M)`——按提示增删方程或变量声明。
- Dynare 能直接处理只含 var/varexo/parameters/model 的半成品文件，无需临时加 initval 占位。
  此阶段不追求算出稳态，只确认结构（方程数、语法、命名、时序笔误）正确。
- 数目对上、无语法/命名错后，进入阶段4 写真正的稳态求解。

## 报错 → 病因 → 修法

**`Blanchard-Kahn conditions are not satisfied`（特征值数量不匹配）**
- 爆炸根多于跳跃变量 → 无稳定解；少于 → 不确定性（indeterminacy）。
- 常见原因：符号或系数错（如违反泰勒原则 `phi_pi<1`）、时序错把状态变成跳跃变量（或反之）、
  方程缺失或多余。**先查时序**。用 `model_info;` 看哪些是状态/跳跃变量是否符合预期。

**`Impossible to find the steady state ...`（稳态求不出）**
- 数值 `initval`：改进初猜；用 `resid;` 看哪条方程残差大；试 `homotopy_setup`；换 `solve_algo`。
- `steady_state_model`：是代数 bug——逐行手验，或临时换成数值 `initval` 定位不一致处。
- 真单位根模型：用 `[static]`/`[dynamic]` 标注 + `steady(nocheck)`。

**`STEADY: convergence problems` / 静态雅可比奇异**
- 两条方程线性相关（如资源约束以不同形式写了两遍）、某变量实际未出现、或函数形式错。
- 跑 `model_diagnostics;`——它会标出奇异雅可比、缺失变量、稳态问题。

**完全预见：求解器失败 / 堆叠雅可比奇异**
- 某方程替换后只剩超前或只剩滞后（常因拉格朗日乘子辅助变量）。改写以保留一个 `t` 期项
  （见 `references/perfect-foresight.md`）。
- 或终端条件不可达：加大 `periods`，或用 `endval_steady` / homotopy。

**`syntax error ... line ...` / 非 ASCII 相关报错**
- 文件用了回车符（旧 Mac 行尾）；转成换行符（LF）。
- 注释以外的地方出现了非 ASCII（如 `long_name='产出'`、`[name='欧拉方程']`）——
  改成英文；非英文只放注释里（注释本身用 [LANG]）。
- 或缺 `;`，或在 `verbatim`/原生 MATLAB 区用了 `//`（那里要用 `%`）。

**估计：`The variance-covariance matrix ... is not positive definite` / 随机奇异性**
- 冲击 + 测量误差数少于可观测变量数。加冲击/测量误差或减少可观测变量。

**估计：众数找不到 / 后验古怪**
- 多半是稳态或观测方程不匹配（数据没映射到正确模型变量、均值/趋势不一致、
  `loglinear` 与 `logdata` 不配套）。先在先验均值处跑一次模拟核对设定。

**`Error using ... / Undefined function or variable`（MATLAB 层面）**
- 变量/参数名与 MATLAB 函数冲突（如 `gamma`、`beta`）。改名（`gam`、`betta`）。
- 或 Dynare 不在路径上：`addpath('<dynare>/matlab')`。

**实战中踩过的具体坑（lagged varexo 的 `subst_auxvar` 崩溃、`oo_.irf` vs `oo_.irfs` 字段名、`range()` 工具箱依赖、纯 varexo 稳态取 0、异质性 varexo 顺序崩溃等）**
- 这些「现象 → 根因 → 现成修法」统一收在 **`references/known-issues.md`「已知坑与修法」**（实战
  踩坑日志，随用随长）——遇报错先扫那里、命中直接改。本表只保留通用/结构性报错的诊断。

## 数值结果可疑但无报错（静默错误，最危险）

模型干净跑完、却得到**经济上不合理的数**（平衡预算政府支出乘数 ≈ 0.01、IRF 差 ~100 倍或符号反、
稳态比率离谱），全程无任何报错——这类**静默错误**比崩溃更危险，因为它不会自己暴露。固定动作：
**与解析基准对一眼再信结果**。

- 凡有**已知解析/极限结果**（平衡预算 G 乘数 ≈ 1、李嘉图等价下转移乘数 = 0、长期货币中性、
  稳态大比率 `C/Y`、`I/Y`、`K/Y` 的合理区间），求解后先 `fprintf` 把它打出来与基准比。**偏离一个
  数量级 → 几乎必是后处理口径错**，最常见：归一化漏乘稳态份额 `1/g_y`、把百分比 IRF 当成绝对量
  之比、字段名 `oo_.irf` 误当 `oo_.irfs`、`Scale` 多除了 100、冲击符号/口径反。
- 解析基准从哪来、为什么这一步几乎零成本却能在出图前拦住缩放/符号 bug，见
  `references/matlab-workflow.md`「拿解析基准即时校验」。
- 若与时序/稳态有关（静默给错 IRF 而非崩溃），回到本文件「最终检查清单」R2/R3 条与
  `references/steady-state.md`。

## 快速 sanity 工具（可建议用户或自己通过 MCP 跑）

- `resid;`——当前值下的静态残差（调试稳态初猜）。
- `check;`——特征值 / Blanchard-Kahn。
- `model_diagnostics;`——模型与稳态的健全性检查。
- `model_info;`——列出状态、跳跃、静态变量与块结构。
- `steady;` 打印值——目测比率是否经济合理。

## 交付呈现

说明模型与所跑实验；标注任一存量变量的时序选择；告诉用户运行方式与预期输出（`stoch_simul`
得政策函数+矩+IRF；完全预见得过渡路径；估计得后验）。若稳态是数值求解的，提醒确认 `resid;`
接近 0、`check;` 通过后再信任结果。MCP 已跑通时，直接把 BK/稳态/矩的关键结论汇报给用户。

---

# 手册增补（Dynare 7.1 §3 + §4.11）

## 预处理器产物与排错入口

`dynare FILENAME` 先跑预处理器，在 `+FILENAME/` 下生成：
- `driver.m`——变量声明+计算任务（**未被识别的行会被当原生 MATLAB 直接塞进这里**；拼写错的
  变量/参数名最常在此暴露——排错先看 driver.m）。
- `dynamic.m`——动态方程残差与雅可比；列序由 `M_.lead_lag_incidence` 给（行 = t-1/t/t+1，
  列 = 声明序内生，0 表示该期不出现，非零值=该变量在雅可比中的列号）。
- `static.m`——静态（稳态）方程残差与雅可比。
报错涉及某方程时，对照这三个文件定位。

## `model_info` 的块类型（BK/时序排错）

`model_info;` 给状态/跳跃/静态变量清单；加 `block_dynamic`/`block_static`/`incidence` 看块分解。
五种块：`EVALUATE FORWARD/BACKWARD`（可直接求值）、`SOLVE FORWARD/BACKWARD x`、
`SOLVE TWO BOUNDARIES x`（含前后向，`x`=SIMPLE 单方程/COMPLETE 多方程）。BK 不满足时先用它确认
哪些变量被当成了状态/跳跃，是否与预期一致。

## `dynare` 调用选项（闭环里按需加）

| 选项 | 用途 |
|------|------|
| `noclearall` | 不清工作区（调试期保留 M_/oo_）——本 skill 闭环默认加 |
| `nograph` | 不画图，提速 |
| `console` / `nodisplay` / `nointeractive` | 无 GUI / 不弹窗 / 不等输入 |
| `savemacro[=f]` | 存宏展开后的 .mod（查 `@#` 展开结果） |
| `onlymacro` / `onlymodel` | 只跑宏 / 只输出模型信息不算 |
| `nostrict` | 容忍：方程多于内生、initval 出现未声明符号、model 里未声明符号自动设外生、声明未用外生 |
| `warn_uninit` | 对每个未初始化变量/参数报警 |
| `exclude_eqs=[name1,name2]` / `include_eqs=...` | 按 name 标签增删方程跑（做变体很方便） |
| `transform_unary_ops` | 把 exp/log/sin… 转成辅助变量（有时帮收敛/可读性） |
| `json=parse\|check\|transform\|compute` | 输出 JSON 版模型（程序化分析） |
| `output=first\|second\|third` | 强制输出到指定阶导数（调稳态时 first 提速） |
| `language=matlab\|julia`、`use_dll`、`fast` | 目标语言 / 编译 DLL 提速 / 复用未变产物 |

选项也可写在 .mod 首行注释：`// --+ options: savemacro, json=compute +--`。

## 看懂预处理器报错（行号陷阱）

报错形如 `ERROR: file.mod: line A, col B: <msg>`。**最常见误导=漏分号**：
```
varexo a, b           // ← 这里漏了 ;
parameters c, ...;
```
解析器要等读到第2行 `parameters` 才发现意外，于是报在第2行 `unexpected PARAMETERS`——
真正的修法是给**第1行**补 `;`。记住：任何不违反语法但 Dynare 不认得的行都被当原生 MATLAB。

## 命名禁忌的官方理由（R5 背书）

不区分大小写；变量/参数不得与 Dynare 命令或内置函数同名（如 `Ln`、`shocks`）；用稳态文件时避开
与 MATLAB 函数同名的希腊词（`alpha`/`beta`/`gamma`→`alppha`/`betta`/`gam`）；**不要命名 `i`**
（与虚数单位、循环索引冲突），投资用 `invest`；`inv` 也不宜（已是求逆）。
