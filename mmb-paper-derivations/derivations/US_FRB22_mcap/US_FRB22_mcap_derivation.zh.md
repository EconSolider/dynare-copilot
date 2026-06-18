# US_FRB22_mcap - 推导（最优化问题 + 一阶条件）

> 归档状态：`needs_review`。本一稿条目基于 Brayton and Reifschneider (2022) 的论文侧 MinerU Markdown；MMB 实现仅作为 `implementation_cross_check` 使用。未执行 Dynare 运行验证。

来源信息：`US_FRB22_mcap`，Brayton, Flint; Reifschneider, David (2022)，《LINVER: The Linear Version of FRB/US》，Finance and Economics Discussion Series 2022-053，DOI `10.17016/feds.2022.053`。来源 Markdown：`raw/mmb_mineru/runs/us_frb22_mcap_us_frb22_mcapwp_us_frb22_mceall_us__linver_the_linear_version_of_frb_us__a8780356/full.md`。原始 PDF：`raw/mmb_papers/LINVER- The Linear Version of FRB:US.pdf`。MinerU run id：`a8780356-98b8-4931-bad6-3b2c5b4b2f0c`。附录规范化文件：未找到 `US_FRB22_mcap` 对应文件。

## 1. Model Overview

- **模型**：LINVER，即 Federal Reserve Board 的 FRB/US 模型的线性版本；此处归档为 MMB 模型 `US_FRB22_mcap`。
- **变体**：MMB 实现注释说明该变体中金融市场预期为模型一致预期，其他预期基于小型 VAR。这是 `implementation_cross_check`；论文将该混合预期制度描述为 LINVER/FRB/US 的一种标准选项。
- **用途**：大型美国半结构宏观政策模型，用于确定性和随机模拟，包括模型一致预期、VAR 预期、政策规则替代方案以及有效下界（ELB）实验。
- **主体/模块**：家庭和企业通过估计的支出、生产、工资价格、金融市场、财政、外部部门和预期模块表示，而不是通过一个紧凑的 DSGE 优化主体集合表示。货币政策由可选择的简单规则加可选 ELB 和财政稳定约束表示。
- **形式**：围绕 2018-2019 年平均条件的线性模型。ELB 和阈值政策作为非线性约束叠加在原本线性的模拟系统上。`needs_review`：该论文来源没有发布完整 LINVER 方程清单。

## 2. Optimization Problems

论文没有把家庭、企业或政策制定者的问题表述为原始 DSGE 优化问题。LINVER 被描述为非线性 FRB/US 模型的符号线性化，以及用于政策模拟的计算包。因此本节记录隐含的问题类别，并将完整原始优化问题恢复标记为 `needs_review`。

- **私人部门行为方程**：消费、投资、劳动市场、工资价格、外部部门和资产价格动态继承自 FRB/US 并被线性化。论文来源没有复现这些完整估计方程。
- **预期形成问题**：主体可以使用模型一致预期，也可以使用有限信息 VAR 模型给出的预期。对 `US_FRB22_mcap`，实现交叉检查显示仅金融市场使用 MC 预期。
- **金融市场模块**：混合预期变体使金融市场对未来利率和宏观变量具有模型一致预测，而其他部门使用 VAR 预期。
- **政策规则设计问题**：研究者选择简单政策规则系数或规则族，以评估宏观损失和 ELB 表现。

`needs_review`：逐条 FRB/US 行为方程的来源级提取需要 LINVER 包/手册或 FRB/US 模型文档，不能仅依赖这篇 FEDS 论文。

## 3. First-Order Conditions

论文没有报告来自家庭或企业原始优化的一阶条件。以下编号方程是论文支持的均衡和模拟关系，用于定义本一稿归档推导。

- **(F1) 对数变量的线性化映射**：

$$
\hat{x}_t = \log X_t - \log \bar{X} \approx \log\left(\frac{X_t}{\bar{X}}\right)
$$

论文说明，一般而言，正的趋势变量遵循 FRB/US 继承而来的对数设定。

- **(F2) 水平变量的线性化映射**：

$$
\tilde{x}_t = X_t - \bar{X}
$$

非对数变量围绕基准条件按水平线性化。`needs_review`：论文没有列出逐变量分类。

- **(F3) 可能非正的存量/流量对象替换**：

$$
S^{surplus}_t = T^{receipts}_t - G^{outlays}_t
$$

这表示论文说明的方法：在线性化之前，把政府预算盈余等变量替换为正分量的差。

- **(F4) 净外国资产替换**：

$$
NFA_t = FA^{gross}_t - FL^{gross}_t
$$

论文将净外国资产头寸列为另一个被替换为总资产和总负债差值的对象。

- **(F5) 存货投资替换**：

$$
I^{inv}_t = K^{inv}_t - K^{inv}_{t-1}
$$

论文将存货投资识别为当前和滞后存货存量之差。

- **(F6) 通用有限信息 VAR 预期法则**：

$$
E^{VAR}_t z_{t+h} = e_z' A_h
\sum_{j=0}^{p-1} e_z' B_{h,j} s_{t-j}
$$

这是对论文描述的紧凑表示：VAR 预期基于估计的有限信息 VAR 模型预测。`needs_review`：来源没有给出精确 VAR 状态向量和系数。

- **(F7) 模型一致预期条件**：

$$
E^{MC}_t z_{t+h} = E_t\left[z_{t+h}\mid \mathcal{M}_{LINVER}, \Omega_t\right]
$$

根据实现交叉检查，对 `US_FRB22_mcap`，该条件适用于金融市场预期。

- **(F8) 无非线性约束时的线性约化形式**：

$$
s_{t+1} = A s_t + B \varepsilon_{t+1}
$$

论文说明，稳定的线性模型具有不含超前项的唯一约化形式。`needs_review`：论文没有报告矩阵。

- **(F9) LINVER 研究中使用的通用惯性 Taylor 规则**：

$$
R_t = \alpha R_{t-1} + (1-\alpha)\left[r^{\ast} + \pi_t + \beta_{\pi}(\pi_t-\pi^{\ast}) + \gamma_y Y_t\right] + \varepsilon^R_t
$$

论文把这一规则族作为 LINVER 研究中使用的标准政策规则表述。来源 OCR 在规则附近有一个不可读短语；利率变量由语境推断并标记为 `needs_review`。

- **(F10) 带 ELB 约束的惯性 Taylor 规则**：

$$
R_t = \max\left\{0.85 R_{t-1} + 0.15\left[1.5\pi_t + 1.0Y_t\right],\; ELB\right\}
$$

论文将其列为规则比较模拟中使用的一条规则。

- **(F11) 平均通胀目标规则**：

$$
R_t = \max\left\{0.85 R_{t-1} + 0.15\left[\pi_t + 1.0Y_t + 8.0\pi^{32}_t\right],\; ELB\right\}
$$

其中 $\pi^{32}_t$ 是过去 32 个季度的平均年化通胀率。

- **(F12) 非对称平均通胀目标调整**：

$$
R_t = \max\left\{0.85 R_{t-1} + 0.15\left[1.5\pi_t + 1.0Y_t\right] + \varepsilon^{AIT}_t,\; ELB\right\}
$$

$$
\varepsilon^{AIT}_t =
\begin{cases}
0.15\left(8\pi^{32}_t - 0.5\pi_t\right), & \pi^{32}_t < 0,\\
0, & \pi^{32}_t \ge 0.
\end{cases}
$$

- **(F13) Reifschneider-Williams 补偿规则**：

$$
R_t = \max\left\{\pi_t + Y_t + CSF_t,\; ELB\right\}
$$

$$
CSF_t = CSF_{t-1} + 1.5\pi_t + 1.0Y_t - R_t
$$

- **(F14) Kiley-Roberts change rule**：

$$
RV_t = RV_{t-1} + 0.4\pi_t + 0.4Y_t
$$

$$
R_t = \max\left\{RV_t,\; ELB\right\}
$$

- **(F15) ECFS 财政稳定过程**：

$$
FISCAL_t = 0.97 FISCAL_{t-1} + \varepsilon^{FISCAL}_t
$$

论文附录说明了这一紧急财政稳定过程，并描述选择非负冲击以使近端产出缺口不低于下限。

## 4. Market Clearing & Identities

- **(F16) 按模块表示的 GDP 支出恒等式**：

$$
Y_t = C_t + I_t + G_t + X_t - M_t + \Delta^{inv}_t
$$

这是与 FRB/US/LINVER 支出模块和实现变量覆盖一致的标准国民账户恒等式。`needs_review`：论文来源没有逐条列举精确 LINVER 会计恒等式。

- **(F17) 产出缺口定义**：

$$
Y^{gap}_t = Y_t - Y^{pot}_t
$$

或者对对数变量，

$$
y^{gap}_t = 100\left(\log Y_t-\log Y^{pot}_t\right)
$$

论文将产出缺口作为政策规则和模拟统计中的核心变量；精确缩放需要与模型包核对。

- **(F18) 失业缺口定义**：

$$
U^{gap}_t = U_t - U^{nat}_t
$$

论文在 liftoff 阈值模拟中使用失业缺口。

- **(F19) 四季度通胀度量**：

$$
\pi^{4}_t = \frac{1}{4}\sum_{j=0}^{3}\pi_{t-j}
$$

论文报告四季度 PCE/核心 PCE 通胀统计和规则阈值。`needs_review`：模型包特定的年化处理需要检查。

## 5. Exogenous Processes

- **(F20) 去均值历史残差 bootstrap**：

$$
\varepsilon_t = u_{\tau(t)} - \bar{u},\qquad \tau(t)\sim \mathcal{U}\{1970Q1,\ldots,2019Q4\}
$$

论文描述了在扣除样本均值后抽取历史残差季度。

- **(F21) 状态依赖的衰退抽样**：

$$
\varepsilon_t =
\begin{cases}
u^{normal}_{\tau(t)}-\bar{u}, & q_t=N,\\
u^{mild}_{\tau(t)}-\bar{u}, & q_t=M,\\
u^{severe}_{\tau(t)}-\bar{u}, & q_t=S.
\end{cases}
$$

论文描述了正常、温和下滑和严重下滑三种抽样状态。

- **(F22) 实现中的通用估计残差方程**：

$$
x_t = c_x + \sum_i a_{x,i}x_{t-i} + \sum_k b_{x,k} w_{k,t} + \varepsilon^x_t
$$

这一紧凑形式概括 MMB `.mod` 实现中可见的大型方程系统，属于 `implementation_cross_check`，不是论文侧公式。

## 6. Steady-State Solution

LINVER 并不是围绕传统的完整存量稳态线性化。论文说明当前版本围绕 2018-2019 年平均条件线性化，因为当时经济接近充分就业、通胀和利率较稳定，同时 FRB/US 的完整存量均衡可能与当期金融和物质资本存量相距较远。

对该线性归档条目，基准解为：

$$
\bar{s} = s^{2018-2019}_{baseline}
$$

偏离量为：

$$
\hat{s}_t = s_t - \bar{s}
$$

或按 (F1) 使用对数偏离。因此：

$$
\hat{s}^{ss} = 0
$$

`needs_review`：基准向量和所有变量特定缩放常数必须从 LINVER 包或实现数据中提取，不能由论文推断。

## 7. Timing & Form Conventions

- 时间频率为季度。
- 形式上按构造为线性；可选 ELB 和阈值限制作为非线性约束叠加在线性模型解上。
- 根据 MMB 实现注释，当前归档变体中金融市场使用模型一致预期，其他预期为 VAR 预期。论文将其描述为一种混合预期情形。
- LINVER 围绕 2018-2019 年平均条件线性化，而不是围绕传统稳态线性化。
- 变量根据 FRB/US 处理方式分为对数线性化和水平线性化。可能非正的对象在线性化前被改写为正分量之差。
- `implementation_cross_check`：`raw/mmb/mmci-cli/models/US_FRB22_mcap/US_FRB22_mcap.mod` 通过非运行文本计数声明 309 个内生 `var` token、120 个 `varexo` token 和 274 个命名模型方程。它使用普通 `model;` 块，但论文和元数据将其描述为线性化模型。未运行 Dynare。

## 8. Variable & Parameter Reference Table

| Category | Symbol/name | Meaning | Equation reference |
|---|---|---|---|
| Endogenous | `rff`, `R_t`, `interest` | 联邦基金利率/政策利率 | (F9)-(F14) |
| Endogenous | `outputgap`, `xgap`, `Y_t` | 产出缺口/实际活动度量 | (F10)-(F14), (F17) |
| Endogenous | `inflation`, `pic4`, `picxfe`, `pi_t` | 通胀度量 | (F9)-(F14), (F19) |
| Endogenous | `fiscal`, `FISCAL_t` | ECFS 财政稳定指数 | (F15) |
| Endogenous | `ugap`, `U^{gap}_t` | 失业缺口 | (F18) |
| Endogenous | `rg5`, `rg10`, `rg30`, `zrff5`, `zrff10`, `zrff30` | 金融市场模块中的国债收益率和 MC 预期未来短期利率成分 | (F7), (F8), needs_review |
| Endogenous | `ec_l`, `ecd_l`, `ech_l`, `eco_l` | 实现中的消费支出模块 | (F22), needs_review |
| Endogenous | `ebfi_l`, `eh_l`, `ki_l`, `kbfi_l`, `kh_l` | 实现中的投资/资本/住房模块 | (F22), needs_review |
| Endogenous | `xgdp_l`, `xgap`, `xbt_l`, `xb_l`, `ex_l`, `em_l` | GDP、缺口、贸易/出口/进口模块 | (F16), (F22), needs_review |
| Exogenous | `interest_` | MMB 元数据中的货币政策冲击 | (F9)-(F14) |
| Exogenous | `fiscal_`, `fiscal_aerr` | 财政/ECFS 冲击 | (F15) |
| Exogenous | `*_aerr` residuals | 按模块划分的方程残差冲击 | (F20)-(F22) |
| Exogenous | `fpitrg`, `pitarg`, `rstar`, `ELB` | 通胀目标、中性利率、下界设置 | (F9)-(F14) |
| Parameter | `alpha`, `beta_pi`, `gamma_y` | 论文记号中的通用 Taylor 规则惯性/通胀/缺口系数 | (F9) |
| Parameter | `cofint*`, `std_r_`, `coffispol` | 实现中的政策规则和 modelbase 系数 | (F9)-(F15), implementation_cross_check |
| Parameter | `y_*` coefficient names | 实现方程系数 | (F22), implementation_cross_check |

完整变量、冲击和参数覆盖仍为 `needs_review`，因为论文没有发布逐方程 LINVER 清单。
