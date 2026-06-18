# US_FRB22_mcapwp - 推导（第一轮来源抽取）

> `US_FRB22_mcapwp` 的模型档案条目。状态：`needs_review`。
> 未执行运行时验证。此处列出的 `.mod` 文件仅作为 `implementation_cross_check` 证据使用。

来源溯源：

- 论文："LINVER: The Linear Version of FRB/US"
- 作者：Flint Brayton; David Reifschneider
- 年份：2022
- DOI：`10.17016/feds.2022.053`
- 来源 Markdown：`raw/mmb_mineru/runs/us_frb22_mcap_us_frb22_mcapwp_us_frb22_mceall_us__linver_the_linear_version_of_frb_us__a8780356/full.md`
- 原始 PDF：`raw/mmb_papers/LINVER- The Linear Version of FRB:US.pdf`
- MinerU run id：`a8780356-98b8-4931-bad6-3b2c5b4b2f0c`
- 附录归一化：未发现 `US_FRB22_mcapwp` 对应文件

## 1. 模型概述

`US_FRB22_mcapwp` 是 LINVER 的 Modelbase 变体；LINVER 是联邦储备委员会 FRB/US 模型的线性版本。论文将 LINVER 描述为用于美国政策模拟的大型线性宏观计量模型，尤其适用于带模型一致预期和偶尔约束的有效下限政策实验。

具体的 `mcapwp` 变体在本地 MMB 实现中被识别为：金融市场预期以及工资价格形成相关预期是模型一致的，其他预期基于估计的小型 VAR。该变体标签属于 `implementation_cross_check`；论文讨论了这种预期设定，但 `US_FRB22_mcapwp` 不是论文中的数学符号。

模型形式：线性化宏观计量系统。论文说明 LINVER 通过三步构造：把变量分类为水平线性化或对数线性化；替换部分不能安全取对数线性化的变量；并在接近 2018-2019 年平均状态的数据点附近评价符号线性化。本地 MMB `.mod` 使用普通 `model;` 而不是 `model(linear)`，但方程在偏离量、滞后项和超前项中是线性的。

论文不是紧凑的结构方程附录。它给出方法、预期设定、政策规则例子、随机模拟设计和表图。完整方程清单及系数出现在本地实现中，而不是论文 Markdown 中；因此公式层面的重构标记为 `needs_review`。

## 2. 主体的最优化问题

论文侧来源没有显式推导家庭、企业、政府或央行的最优化问题。LINVER 被呈现为大型 FRB/US 宏观计量模型的线性化版本，而不是带少量原始目标函数和约束的小型 DSGE 系统。

论文侧结构支持以下经济模块，但不给出完整原始最优化问题：

- 消费、企业固定投资、住房、进口、出口、库存以及政府/财政变量等支出模块。
- 劳动力市场和工资价格模块，包括工资价格预期可设为模型一致的情形。
- 金融市场模块，包括联邦基金利率、国债收益率、期限溢价、股票和信贷条件、汇率渠道。
- 政策模块，包括惯性 Taylor 型规则、平均通胀目标规则、补偿/变化规则、离开下限的阈值条件、ELB 和财政稳定选项。

`needs_review`：MinerU Markdown 中没有来源级最优化问题。本地 `.mod` 确认存在大型线性方程系统，但不作为论文侧数学来源。

## 3. 一阶条件

由于论文侧来源没有给出原始最优化问题，也没有给出来源级一阶条件。以下公式抽取为论文中可见的高层均衡/政策关系，应理解为来源支持的模型关系，而不是完整 FOC。

- **(F1) 通用惯性货币政策规则**（`needs_review`，因为附近 OCR 文本含占位字符）：

$$
R_t = \alpha R_{t-1} + (1-\alpha)\left[r^{\ast} + \pi_t + \beta(\pi_t-\pi^{\ast}) + \gamma Y_t\right]
$$

- **(F2) LINVER 状态空间表示**（`needs_review`，因为论文陈述了约化形式思想，但没有打印完整矩阵系统）：

$$
A_0 x_t + A_1 x_{t-1} + A_f E_t x_{t+1} + B \varepsilon_t = 0
$$

- **(F3) 稳定线性模型下的约化形式**（`needs_review`；由论文关于唯一约化形式消除超前项的讨论推断）：

$$
x_t = H x_{t-1} + G \varepsilon_t
$$

本地 `US_FRB22_mcapwp.mod` 含 274 条命名方程以及更多赋值/方程行。这些方程记录为 `implementation_cross_check` 证据，不在此复制为论文侧推导。

## 4. 市场出清与总量恒等式

论文没有打印完整市场出清方程。它描述了用于比较 LINVER 与 FRB/US 的变量和模拟输出，包括产出缺口、失业缺口、PCE 通胀、核心 PCE 通胀、联邦基金利率和国债收益率。

- **(F4) 联邦基金利率变化恒等式**（`implementation_cross_check`；本地 `.mod` 可见，论文中不可见）：

$$
\Delta rff_t = rff_t - rff_{t-1}
$$

- **(F5) 实际联邦基金利率恒等式**（`implementation_cross_check`；本地 `.mod` 可见，论文中不可见）：

$$
rrff_t = rff_t - \frac{1}{4}\left(picxfe_t + picxfe_{t-1} + picxfe_{t-2} + picxfe_{t-3}\right)
$$

- **(F6) Modelbase 输出和价格报告恒等式**（`implementation_cross_check`；本地 `.mod` 可见，论文中不可见）：

$$
interest_t = rff_t,\qquad inflation_t = pic4_t,\qquad outputgap_t = xgap2_t
$$

`needs_review`：论文提到完整 FRB/US/LINVER 部门，但没有以论文侧数学形式展示完整会计恒等式。

## 5. 外生过程

论文描述了使用历史方程残差、bootstrap、状态依赖抽样和重缩放工资价格冲击的随机模拟。它还列举了宽泛的冲击组，包括消费、投资、进出口、政府、生产率、溢价、外国活动、工资和价格。

- **(F7) 通用线性残差冲击表示**（`needs_review`；论文层面的抽象，不是打印方程）：

$$
u_{j,t} = e_{j,t},\qquad e_{j,t}\sim \mathcal{D}_{hist}
$$

- **(F8) 状态依赖抽样规则**（`needs_review`；概括论文的三状态模拟设计）：

$$
e_t \sim \mathcal{D}(s_t),\qquad s_t\in\{\text{normal},\text{mild slump},\text{severe slump}\}
$$

- **(F9) 财政稳定冲击映射**（`needs_review`；论文附录概念，不是完整结构方程）：

$$
fiscal_t = \kappa_{fs}\,\varepsilon^{fiscal}_t
$$

实现交叉检查：本地 `US_FRB22_mcapwp.json` 列出大量方程残差冲击以及 `interest_` 和 `fiscal_`；本地 `.mod` 还加入了模型包使用的外生控制变量和虚拟变量。

## 6. 稳态求解

LINVER 不是围绕教科书式确定性稳态线性化。论文说明当前版本围绕 2018-2019 年关键宏观变量的平均状态线性化，存量变量取自不太偏离近期数值的数据。因此，论文侧来源无法提供常规 DSGE 稳态推导。

- **(F10) 线性化点定义**（`needs_review`；论文层面的归一化）：

$$
x_t = X_t - \bar X_{2018-2019}\quad\text{or}\quad x_t = \log X_t - \log \bar X_{2018-2019}
$$

- **(F11) 报告缺口的基线零值约定**（`needs_review`；模拟约定）：

$$
\bar{xgap2}=0,\qquad \bar{ugap}=0,\qquad \bar{\pi}^{core}=0\ \text{as deviation from baseline/target}
$$

本第一轮条目不重构 `steady_state_model`。运行时验证以及精确稳态/基线复制均推迟处理。

## 7. 时序与形式约定

LINVER 是季度线性模型，包含丰富的滞后和超前结构。在本地实现交叉检查中，`US_FRB22_mcapwp.mod` 的模型块含大量滞后项、若干前瞻项，以及 `zrff5`、`zrff10`、`zrff30` 等预期未来短端利率方程。

时序约定：

- 后顾项使用 $x_{t-1}$、$x_{t-2}$ 等滞后。
- 模型一致预期模块引入未来期变量；对本变体而言尤其体现在金融市场和工资价格渠道。
- ELB 等政策约束由求解例程施加在一个原本线性的模型上；它们不是基础线性方程系统的一部分。
- MMB 实现包括 `interest`、`inflation`、`inflationq`、`outputgap`、`output` 和 `fispol` 等政策规则占位和 Modelbase 变量。

形式约定：线性化宏观计量模型。任何依赖精确论文到代码方程映射的结论均使用 `needs_review`。

## 8. 变量与参数对照表

| 类别 | 符号 / 名称 | 含义 | 来源状态 |
|---|---|---|---|
| 内生变量 | `rff` | 联邦基金利率 | 论文概念；实现变量 |
| 内生变量 | `rrff` | 实际联邦基金利率 | implementation_cross_check |
| 内生变量 | `xgap2` | 产出缺口报告变量 | 论文概念；实现变量 |
| 内生变量 | `ugap` | 失业缺口 | 论文概念；实现变量 |
| 内生变量 | `pic4` | 四季度通胀报告变量 | implementation_cross_check |
| 内生变量 | `picxfe` | 实现中使用的核心 PCE 通胀组成变量 | implementation_cross_check |
| 内生变量 | `rg5`, `rg10`, `rg30` | 国债收益率 / 长端利率变量 | 论文概念；实现变量 |
| 内生变量 | `zrff5`, `zrff10`, `zrff30` | 期限结构中的预期未来短端利率组成项 | implementation_cross_check |
| 内生变量 | `fiscal`, `fiscalav`, `fiscal_aerr` | 财政稳定报告/冲击变量 | 论文概念；实现变量 |
| 外生变量 | `interest_` | 货币政策冲击 | implementation_cross_check |
| 外生变量 | `fiscal_` | 财政政策冲击 | implementation_cross_check |
| 外生变量 | `*_aerr` | 方程残差冲击 | implementation_cross_check |
| 参数 | `cofint*` | Modelbase 政策规则系数 | implementation_cross_check |
| 参数 | `std_r_`, `std_r_quart` | 货币政策冲击尺度 | implementation_cross_check |
| 参数 | `coffispol` | 财政政策冲击尺度 | implementation_cross_check |
| 参数 | `tax_gamma` | 论文讨论的财政逆周期参数 | 论文概念 |
| 参数 | ELB | 求解例程施加的有效下限 | 论文概念 |
| 参数 | `r^*` | 政策例子中的中性实际/名义利率组成项 | 论文概念 |
| 参数 | `\alpha,\beta,\gamma` | 论文例子中的通用惯性规则系数 | 论文概念 |

实现交叉检查计数：

- `US_FRB22_mcapwp.mod`：`varexo` 之前有 319 个内生 `var` token；`parameters` 之前有 124 个 `varexo` token；`model` 块中有 274 条命名方程。
- `.agents/skills/dynare-copilot/references/examples/US_FRB22_rep.mod`：通用 FRB22 示例，含 284 个内生 `var` token 和 117 个 `varexo` token。

第一轮档案状态：`needs_review`，因为论文侧 Markdown 没有展示完整方程清单，部分已打印政策规则公式附近有 OCR 占位字符，且 MMB `.mod` 方程系统尚未与论文/软件包文档逐条做来源级核对。
