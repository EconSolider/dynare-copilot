# US_FRB22_var - 推导（最优化问题 + 一阶条件）

> 档案状态：`needs_review`。本首轮条目基于 Brayton and Reifschneider (2022) 的论文侧 MinerU Markdown；MMB 实现只作为 `implementation_cross_check` 使用。未执行 Dynare 运行验证。

来源信息：`US_FRB22_var`，Brayton, Flint; Reifschneider, David (2022)，《LINVER: The Linear Version of FRB/US》，Finance and Economics Discussion Series 2022-053，DOI `10.17016/feds.2022.053`。来源 Markdown：`raw/mmb_mineru/runs/us_frb22_mcap_us_frb22_mcapwp_us_frb22_mceall_us__linver_the_linear_version_of_frb_us__a8780356/full.md`。原始 PDF：`raw/mmb_papers/LINVER- The Linear Version of FRB:US.pdf`。MinerU run id：`a8780356-98b8-4931-bad6-3b2c5b4b2f0c`。

## 1. Model Overview

- **模型**：LINVER，即 Federal Reserve Board 的 FRB/US 模型的线性版本；此处归档为 MMB 模型 `US_FRB22_var`。
- **变体**：MMB 实现注释将其标识为所有预期都基于 VAR 预测的变体。这一点属于 `implementation_cross_check`；论文将全 VAR 预期描述为 LINVER/FRB-US 的一种模拟选项。
- **用途**：大型美国半结构宏观政策模型，用于确定性和随机模拟，包括模型一致预期（MC）、VAR 预期以及有效下限（ELB）实验。
- **主体/模块**：家庭和企业通过估计的支出、生产、工资价格、金融市场、财政、外部部门和预期模块表示，而不是通过紧凑的 DSGE 优化主体集合表示。货币政策由可选择的简单规则以及 ELB/非线性政策约束表示。
- **形式**：围绕 2018-2019 年平均条件的线性模型；ELB 等可选非线性约束通过迭代加性调整施加。`needs_review`：该论文来源没有发布完整 LINVER 方程清单。

## 2. Optimization Problems

论文没有把家庭、企业或政策制定者的问题写成原始 DSGE 优化问题。它把 LINVER 描述为非线性 FRB/US 模型的符号线性化版本，以及用于政策模拟的计算包。因此本节记录隐含的问题类别，并把完整原始优化问题恢复标为 `needs_review`。

- **私人部门行为方程**：消费、投资、劳动力市场、工资价格、外部部门和资产价格动态继承自 FRB/US 并被线性化。论文来源没有复制完整估计方程。
- **预期形成**：主体可以使用模型一致预期，也可以使用有限信息 VAR 模型给出的预期。对 `US_FRB22_var` 而言，实现交叉检查显示所有预期均基于 VAR。
- **政策规则设计问题**：研究者选择简单政策规则系数或规则族，以评估宏观损失和 ELB 表现。

`needs_review`：每条 FRB/US 行为方程的来源级抽取需要 LINVER 包/手册或 FRB/US 模型文档，不能只依赖这篇 FEDS 论文。

## 3. First-Order Conditions

论文没有报告来自家庭或企业原始优化的一阶条件。以下编号方程是论文支持的均衡和模拟关系，定义本首轮归档推导。

- **(F1) 对数变量的线性化映射**：

$$\hat{x}_t = \log X_t - \log \bar{X} \approx \log\left(\frac{X_t}{\bar{X}}\right)$$

论文说明，通常具有趋势且为正的变量沿用 FRB/US 的对数设定。

- **(F2) 水平变量的线性化映射**：

$$\tilde{x}_t = X_t - \bar{X}$$

非对数变量围绕基准条件按水平线性化。`needs_review`：论文没有列出逐变量分类。

- **(F3) 对可能非正的存量/流量对象进行替代**：

$$S^{surplus}_t = T^{receipts}_t - G^{outlays}_t$$

这表示论文说明的方法：在对数/水平线性化之前，将政府预算盈余等变量替换为正组成部分之差。

- **(F4) 净外国资产替代**：

$$NFA_t = FA^{gross}_t - FL^{gross}_t$$

论文把净外国资产头寸列为另一个用资产和负债总额之差替代的对象。

- **(F5) 存货投资替代**：

$$I^{inv}_t = K^{inv}_t - K^{inv}_{t-1}$$

论文把存货投资识别为当前和滞后存货存量之差。

- **(F6) 通用有限信息 VAR 预期法则**：

$$E^{VAR}_t z_{t+h} = e_z' A_h
+\sum_{j=0}^{p-1} e_z' B_{h,j} s_{t-j}$$

这是对论文所述“VAR 预期基于估计的有限信息 VAR 模型预测”的紧凑表示。`needs_review`：来源没有提供精确 VAR 状态向量和系数。

- **(F7) 模型一致预期条件**：

$$E^{MC}_t z_{t+h} = E_t\left[z_{t+h}\mid \mathcal{M}_{LINVER}, \Omega_t\right]$$

这记录论文中的 MC 预期概念，用于和全 VAR 变体对照。

- **(F8) 无非线性约束时的线性约化式**：

$$s_{t+1} = A s_t + B \varepsilon_{t+1}$$

论文说明，稳定的线性模型有唯一的不含超前项的约化式。`needs_review`：论文没有报告矩阵。

- **(F9) LINVER 研究使用的通用惯性 Taylor 规则**：

$$R_t = \alpha R_{t-1} + (1-\alpha)\left[r^* + \pi_t + \beta_{\pi}(\pi_t-\pi^*) + \gamma_y Y_t\right] + \varepsilon^R_t$$

论文把此规则族作为 LINVER 研究中使用的标准政策规则表述。来源 OCR 在规则附近有一处不可读短语；利率变量由上下文推断，并标为 `needs_review`。

- **(F10) 带 ELB 约束的惯性 Taylor 规则**：

$$R_t = \max\left\{0.85 R_{t-1} + 0.15\left[1.5\pi_t + 1.0Y_t\right],\; ELB\right\}$$

论文将其列为规则比较模拟中使用的一条规则。

- **(F11) 平均通胀目标规则**：

$$R_t = \max\left\{0.85 R_{t-1} + 0.15\left[\pi_t + 1.0Y_t + 8.0\pi^{32}_t\right],\; ELB\right\}$$

其中 $\pi^{32}_t$ 是过去 32 个季度的平均年化通胀率。

- **(F12) 非对称平均通胀目标调整**：

$$R_t = \max\left\{0.85 R_{t-1} + 0.15\left[1.5\pi_t + 1.0Y_t\right] + \varepsilon^{AIT}_t,\; ELB\right\}$$

$$\varepsilon^{AIT}_t =
\begin{cases}
0.15\left(8\pi^{32}_t - 0.5\pi_t\right), & \pi^{32}_t < 0,\\
0, & \pi^{32}_t \ge 0.
\end{cases}$$

- **(F13) Reifschneider-Williams 补偿规则**：

$$R_t = \max\left\{\pi_t + Y_t + CSF_t,\; ELB\right\}$$

$$CSF_t = CSF_{t-1} + 1.5\pi_t + 1.0Y_t - R_t$$

- **(F14) Kiley-Roberts 变化规则**：

$$RV_t = RV_{t-1} + 0.4\pi_t + 0.4Y_t$$

$$R_t = \max\left\{RV_t,\; ELB\right\}$$

- **(F15) ECFS 财政稳定过程**：

$$FISCAL_t = 0.97 FISCAL_{t-1} + \varepsilon^{FISCAL}_t$$

论文附录给出这一紧急财政稳定过程，并说明通过选择非负冲击使近期产出缺口保持在下限以上。

## 4. Market Clearing & Identities

- **(F16) GDP 支出恒等式（按模块）**：

$$Y_t = C_t + I_t + G_t + X_t - M_t + \Delta^{inv}_t$$

这是与 FRB/US/LINVER 支出模块和实现变量覆盖相一致的标准国民账户恒等式。`needs_review`：论文来源没有逐条列举 LINVER 的精确会计恒等式。

- **(F17) 产出缺口定义**：

$$Y^{gap}_t = Y_t - Y^{pot}_t$$

或对数变量下：

$$y^{gap}_t = 100\left(\log Y_t-\log Y^{pot}_t\right)$$

论文把产出缺口作为政策规则和模拟统计量的核心变量；确切尺度需要和包代码核对。

- **(F18) 失业缺口定义**：

$$U^{gap}_t = U_t - U^{nat}_t$$

论文在 liftoff 阈值模拟中使用失业缺口条件。

- **(F19) 四季度通胀指标**：

$$\pi^{4}_t = \frac{1}{4}\sum_{j=0}^{3}\pi_{t-j}$$

论文报告四季度 PCE/核心 PCE 通胀统计量和规则阈值。`needs_review`：包内具体年化方式需要核对。

## 5. Exogenous Processes

- **(F20) 去均值历史残差 bootstrap**：

$$\varepsilon_t = u_{\tau(t)} - \bar{u},\qquad \tau(t)\sim \mathcal{U}\{1970Q1,\ldots,2019Q4\}$$

论文描述了在减去样本均值后抽取历史残差季度的过程。

- **(F21) 状态依赖的衰退抽样**：

$$\varepsilon_t =
\begin{cases}
u^{normal}_{\tau(t)}-\bar{u}, & q_t=N,\\
u^{mild}_{\tau(t)}-\bar{u}, & q_t=M,\\
u^{severe}_{\tau(t)}-\bar{u}, & q_t=S.
\end{cases}$$

论文描述了正常、轻度衰退和严重衰退三类抽样状态。

- **(F22) 实现中的通用估计残差方程**：

$$x_t = c_x + \sum_i a_{x,i}x_{t-i} + \sum_k b_{x,k} w_{k,t} + \varepsilon^x_t$$

此紧凑形式概括 MMB `.mod` 实现中可见的大型方程系统，属于 `implementation_cross_check`，不是论文侧公式。

## 6. Steady-State Solution

LINVER 并非围绕传统的完整存量稳态线性化。论文说明，当前版本围绕 2018-2019 年平均条件线性化，因为当时经济接近充分就业、通胀和利率相对稳定；而 FRB/US 的完整存量均衡可能远离当前金融和实物存量状态。

对线性归档条目，基准解为：

$$\bar{s} = s^{2018-2019}_{baseline}$$

偏离量为：

$$\hat{s}_t = s_t - \bar{s}$$

或如 (F1) 所示使用对数偏离。因此：

$$\hat{s}^{ss} = 0$$

`needs_review`：基准向量和所有逐变量尺度常数必须从 LINVER 包或实现数据抽取，不能由论文推断。

## 7. Timing & Form Conventions

- 时间频率为季度。
- 形式上按构造为线性；ELB 和阈值限制等可选项是叠加在线性模型解上的非线性约束。
- 根据 MMB 实现注释，当前归档变体是全 VAR 预期。论文也讨论混合预期和全 MC 预期情形。
- LINVER 围绕 2018-2019 年平均条件线性化，而不是围绕传统稳态线性化。
- 变量按 FRB/US 中的处理方式分为对数线性化和水平线性化。可能非正的对象会先改写为正组成部分之差再线性化。
- `implementation_cross_check`：`raw/mmb/mmci-cli/models/US_FRB22_var/US_FRB22_var.mod` 声明 276 个内生变量、114 个外生条目和 1393 个参数/系数名。它使用普通 `model;` 块，但论文和元数据将其描述为线性化模型。未运行 Dynare。

## 8. Variable & Parameter Reference Table

| 类别 | 符号/名称 | 含义 | 方程引用 |
|---|---|---|---|
| 内生 | `rff`, `R_t`, `interest` | 联邦基金利率/政策利率 | (F9)-(F14) |
| 内生 | `outputgap`, `xgap`, `Y_t` | 产出缺口/实际活动指标 | (F10)-(F14), (F17) |
| 内生 | `inflation`, `pic4`, `picxfe`, `pi_t` | 通胀指标 | (F9)-(F14), (F19) |
| 内生 | `fiscal`, `FISCAL_t` | ECFS 财政稳定指数 | (F15) |
| 内生 | `ugap`, `U^{gap}_t` | 失业缺口 | (F18) |
| 内生 | `rg5`, `rg10`, `rg30` | 国债收益率/期限溢价渠道 | needs_review |
| 内生 | `ec_l`, `ecd_l`, `ech_l`, `eco_l` | 实现中的消费支出模块 | (F22), needs_review |
| 内生 | `ebfi_l`, `eh_l`, `ki_l`, `kbfi_l`, `kh_l` | 实现中的投资/资本/住房模块 | (F22), needs_review |
| 内生 | `xgdp_l`, `xgap`, `xbt_l`, `xb_l`, `ex_l`, `em_l` | GDP、缺口、贸易/出口/进口模块 | (F16), (F22), needs_review |
| 外生 | `interest_` | MMB 元数据中的货币政策冲击 | (F9)-(F14) |
| 外生 | `fiscal_`, `fiscal_aerr` | 财政/ECFS 冲击 | (F15) |
| 外生 | `*_aerr` residuals | 各模块方程残差冲击 | (F20)-(F22) |
| 外生 | `fpitrg`, `pitarg`, `rstar`, `ELB` | 通胀目标、中性利率、下限设定 | (F9)-(F14) |
| 参数 | `alpha`, `beta_pi`, `gamma_y` | 论文记号中的通用 Taylor 规则惯性/通胀/缺口系数 | (F9) |
| 参数 | `cofint*`, `std_r_`, `coffispol` | 实现中的政策规则和 modelbase 系数 | (F9)-(F15), implementation_cross_check |
| 参数 | `y_*` coefficient names | 实现方程系数 | (F22), implementation_cross_check |

完整变量、冲击和参数覆盖仍为 `needs_review`，因为论文没有发布逐方程的完整 LINVER 清单。
