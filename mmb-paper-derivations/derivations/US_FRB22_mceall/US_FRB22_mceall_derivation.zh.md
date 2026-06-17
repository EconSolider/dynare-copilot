# US_FRB22_mceall -- 推导笔记

> 私有 MMB 归档草稿。状态：`needs_review`。未执行运行时验证。

## 1. Model Overview

- **模型 ID**：`US_FRB22_mceall`。
- **来源**：Brayton and Reifschneider (2022), "LINVER: The Linear Version of FRB/US," Finance and Economics Discussion Series 2022-053, DOI `10.17016/feds.2022.053`。
- **模型族**：2022 vintage 的 LINVER，即 Federal Reserve Board FRB/US 模型的线性版本。
- **MMB 变体**：`mceall`，根据 MMB 实现解释为所有预期均为 model-consistent 的变体。该变体标签属于 `implementation_cross_check`，不是论文中明确给出的方程标签。
- **主体与部门**：大型美国宏观计量模型，覆盖家庭需求、企业固定投资、住房、存货、进出口、劳动供给与工资、价格、政府收入/支出/债务服务、金融利率、期限溢价、货币政策、财政稳定机制和预期对象。
- **形式**：线性模型。来源说明 LINVER 是非线性 FRB/US 的符号线性化版本，在线性化时围绕 2018-2019 年平均状态评估，而不是围绕完整存量稳态。MMB `.mod` 使用线性方程块，并已将水平/对数水平转换嵌入变量名。
- **主要模拟环境**：带 model-consistent expectations 的随机和确定性模拟，可选有效下限（ELB）约束，以及政策规则实验。本轮归档不运行 Dynare。
- **公式质量**：`needs_review`。论文给出若干政策和财政稳定公式并说明线性化方法，但没有公布完整 FRB/US 方程系统。因此下文是有来源支持的结构化摘要加实现交叉核对，不是完整的论文侧推导。

## 2. Optimization Problems

LINVER 论文没有以小型结构模型常见的 DSGE 形式列出家庭、企业、政府或金融部门的优化问题。论文说明 LINVER 是更大非线性 FRB/US 模型的线性版本，并说明变量会按水平或对数进行线性化；当某些可能非正的变量不适合取对数时，会进行替换。

- **家庭和企业**：源 Markdown 中没有列出效用最大化、利润最大化或成本最小化问题。`needs_review`：完整部门方程需要 FRB/US/LINVER 模型文档或代码包，不能仅靠 FEDS 概览论文获得。
- **货币当局**：论文给出 LINVER 政策分析中使用的一类联邦基金利率惯性规则：

**(F1) 论文中的一般惯性政策规则**：
$$
R_t = \alpha R_{t-1} + (1-\alpha)\left[r^\* + \pi_t + \beta(\pi_t-\pi^\*) + \gamma Y_t\right].
$$

其中 $R_t$ 是名义联邦基金利率，$r^\*$ 是中性实际利率，$\pi_t$ 是通胀，$\pi^\*$ 是通胀目标，$Y_t$ 是产出缺口。该式是论文用于最优规则研究的一般刻画，不一定是 MMB 中的精确政策方程。

- **财政稳定机制**：附录描述了在 ELB 模拟可能产生严重衰退时使用的 emergency fiscal stabilization 变量。

**(F2) 论文中的 ECFS 财政过程**：
$$
FISCAL_t = 0.97 FISCAL_{t-1} + \varepsilon_t.
$$

需要时，求解程序会选择该冲击以使预期近期产出缺口不低于给定下限。这是模拟机制，不是福利优化 FOC。

## 3. First-Order Conditions

LINVER 概览论文没有报告来源层面的一阶条件。因此本归档只记录简化式行为方程和交叉核对过的实现方程。以下一般模板概括 MMB 实现结构，必须作为 `implementation_cross_check` 处理。

**(F3) 线性行为方程模板（`implementation_cross_check`）**：
$$
x_t =
c_x
+ \sum_{j \in L_x} a_{x,j} x_{j,t-\ell_j}
+ \sum_{k \in F_x} b_{x,k} E_t x_{k,t+h_k}
+ \sum_{m \in Z_x} d_{x,m} z_{m,t}
+ \varepsilon^x_t.
$$

该模板表示 MMB `.mod` 中大量带名称的方程；每条方程都是由滞后、当期、有时还有未来变量构成的校准线性关系。

**(F4) Model-consistent expectations 对象（`implementation_cross_check`）**：
$$
z^q_t = \sum_i \omega_i q_{i,t+s_i}.
$$

MMB 实现包含许多预期变量，如 `zebfi`, `zecd`, `zeco`, `zeh`, `zgap05`, `zgap10`, `zgap30`, `zpi10`, `zpicxfe`, `zrff5`/`zrff10`/`zrff30`，其中很多包含 lead。对于 `mceall`，这些对象与实现中的 "all expectations are model consistent" 变体说明一致。

**(F5) MMB 实现中的利率政策规则（`implementation_cross_check`）**：
$$
\begin{aligned}
i_t ={}&
\sum_{j=1}^{4} a_j i_{t-j}
+ b_0 \pi^q_t
+ \sum_{j=1}^{4} b_j \pi^q_{t-j}
+ \sum_{j=1}^{4} c_j E_t\pi^q_{t+j} \\
&+ d_0 gap_t
+ \sum_{j=1}^{4} d_j gap_{t-j}
+ \sum_{j=1}^{4} e_j E_t gap_{t+j}
+ f_0 y_t
+ \sum_{j=1}^{4} f_j y_{t-j}
+ \sum_{j=1}^{4} g_j E_t y_{t+j}
+ \sigma_i \varepsilon^i_t .
\end{aligned}
$$

精确系数是实现中的 `cofint*` 和 `std_r_`。论文中的政策方程 (F1) 支持这一规则族，但没有列出这个高维实现公式。

## 4. Market Clearing & Identities

来源论文没有提供完整市场出清方程组。论文说明，在 ELB 不约束时，LINVER 与非线性 FRB/US 的动态接近，并强调产出缺口、失业缺口、PCE/核心 PCE 通胀、联邦基金利率和国债收益率等重要观测变量。

MMB 实现暴露了用于 Modelbase 报告的汇总恒等式：

**(F6) 短端利率报告恒等式（`implementation_cross_check`）**：
$$
interest_t = rff_t.
$$

**(F7) 季度通胀报告恒等式（`implementation_cross_check`）**：
$$
inflationq_t = 4\,picnia_t.
$$

**(F8) 产出缺口报告恒等式（`implementation_cross_check`）**：
$$
outputgap_t = xgap2_t.
$$

**(F9) 产出报告恒等式（`implementation_cross_check`）**：
$$
output_t = 100\,xgdp\_l_t.
$$

**(F10) 生产侧产出缺口恒等式（`implementation_cross_check`）**：
$$
xgap2_t = 100\,xgdo\_l_t - 100\,xgdpt\_l_t.
$$

**(F11) GDP 核算块模板（`implementation_cross_check`）**：
$$
xgdpn\_l_t =
\sum_s \lambda_s\,component_{s,t}
+ p_{k,t}
+ p_{x,t}
+ \lambda_i\,ki\_l_t
+ \lambda_{i,-1}\,ki\_l_{t-1}.
$$

`needs_review`：精确的来源层面核算恒等式和部门加总应在官方 LINVER 包文档中核对，而不是只从 `.mod` 推断。

## 5. Exogenous Processes

论文描述了随机模拟中从 1970-2019 年抽取方程残差并对工资价格冲击进行重缩放，但没有列出全部残差过程。MMB 实现声明了许多方程残差冲击以及政策冲击。

**(F12) 一般方程残差（`implementation_cross_check`）**：
$$
u^x_t = \sigma_x \varepsilon^x_t.
$$

**(F13) 财政政策冲击映射（`implementation_cross_check`）**：
$$
fispol_t = \kappa_f \varepsilon^f_t.
$$

**(F14) 财政存量过程（`implementation_cross_check`，与论文一致）**：
$$
fiscal_t = 0.97\,fiscal_{t-1} + fiscal\_aerr_t.
$$

**(F15) 财政影响移动平均（`implementation_cross_check`）**：
$$
fiscalav_t = 0.90\,fiscalav_{t-1} + fiscal_t.
$$

**(F16) 持续性趋势/过程模板（`implementation_cross_check`）**：
$$
s_t = \rho_s s_{t-1} + \varepsilon^s_t.
$$

实现中的例子包括趋势生产率、劳动参与率、自然失业率、价格、期限溢价和国外部门对象等持续变量。

## 6. Steady-State Solution

LINVER 不是围绕传统的完整存量稳态线性化。来源说明，当前版本是在 2018-2019 年平均状态附近评估的；当时经济接近充分就业，通胀和利率相对稳定。这是本归档条目的核心约定。

对线性实现而言，归档层面的稳态解释是：

**(F17) 基线偏离约定**：
$$
\tilde{x}_t = x_t - x^{base}_t,
\qquad
E[\tilde{x}_t] = 0
$$

其中变量表示围绕 LINVER 基线/评估点的线性偏离。

**(F18) 通胀和利率基线目标**：
$$
\pi_t = \pi^\* + \tilde{\pi}_t,
\qquad
i_t = i^\* + \tilde{i}_t.
$$

论文讨论了 2、3、4 个百分点等不同中性名义联邦基金利率设定，以及零 ELB。这些是情景假设，不是单一来源给出的稳态。

`needs_review`：仅凭 FEDS 概览论文无法恢复精确基线值和变换偏移。它们应在后续验证阶段从官方 LINVER 包数据或 MMB 校准文件读取。

## 7. Timing & Form Conventions

- **线性化**：变量依据 FRB/US 中的处理方式被分类为水平或对数线性化。趋势变量通常使用对数设定；其他变量使用水平设定。对预算盈余、净国外资产头寸、存货投资等非正变量候选项会进行替换。
- **评估点**：符号线性化使用大致与关键宏观变量均衡一致且接近 2018-2019 年平均条件的数据进行评估。
- **预期**：模型允许 VAR-based expectations、model-consistent expectations 以及混合情形。根据实现交叉核对，`US_FRB22_mceall` 对应所有预期均为 model-consistent。
- **超前和滞后**：model-consistent expectations 会加入未来内生变量。MMB `.mod` 包含 `(+1)`, `(+2)` 和更远期预测对象等显式 leads。调整和核算方程中广泛使用 lags。
- **ELB**：ELB 是非线性约束，通过迭代求解程序施加在预期联邦基金利率路径上，不属于线性模型块本身。
- **Dynare 形式**：实现表现为线性 Dynare `model` 块，但没有显式写成 `model(linear)`。在作出任何运行时声明前，应将其视为需要复核的线性形式实现。
- **运行时验证**：未执行。未运行 Dynare。

## 8. Variable & Parameter Reference Table

由于完整 MMB 实现包含数百个内生变量和冲击，本表记录主要的来源支持和交叉核对变量组，而不是完整逐方程清单。完整清单应在后续实现审计中从 `.mod` 机械生成。

| Category | Symbol or implementation name | Meaning | Source status | Main equation |
|---|---|---|---|---|
| Endogenous | `interest`, `rff` | 联邦基金利率/报告短端利率 | implementation_cross_check | (F5), (F6) |
| Endogenous | `inflation`, `inflationq`, `pic4`, `picnia` | 年化/四季度与季度通胀指标 | implementation_cross_check | (F7) |
| Endogenous | `outputgap`, `xgap`, `xgap2` | 产出缺口指标 | source-stated concept; implementation_cross_check formula | (F8), (F10) |
| Endogenous | `output`, `xgdp_l`, `xgdpn_l` | 实际/名义 GDP 总量 | implementation_cross_check | (F9), (F11) |
| Endogenous | consumption block: `ec_l`, `ecd_l`, `eco_l`, `eh_l` | 消费支出和住房需求组成 | implementation_cross_check | (F3) |
| Endogenous | investment/capital block: `ebfi_l`, `kbfi_l`, `ki_l`, `ks_l`, `rtinv` | 企业固定投资、资本存量、存货投资、投资回报 | implementation_cross_check | (F3), (F11) |
| Endogenous | labor block: `lfpr`, `lur`, `lurnat`, `lww_l`, `leg_l`, `leh_l` | 劳动力、失业、工资、就业 | implementation_cross_check | (F3), (F16) |
| Endogenous | price block: `picxfe`, `pieci`, `pcnia_l`, `pcxfe_l`, `pipxnc`, `ptr` | 核心价格、报酬通胀、价格水平、趋势通胀 | implementation_cross_check | (F3), (F18) |
| Endogenous | financial block: `rg5`, `rg10`, `rg30`, `req`, `rbbb`, `rtb`, `zrff5`, `zrff10`, `zrff30` | 国债收益率、股权收益、公司债利率、预期基金利率路径 | implementation_cross_check | (F4), (F16) |
| Endogenous | government block: `gfexpn_l`, `gfrecn_l`, `gfdbtn_l`, `gtr_l`, `trci`, `trp`, `fiscal`, `fiscalav` | 政府支出、收入、债务、转移支付、财政稳定机制 | source-stated for ECFS; implementation_cross_check details | (F2), (F13)-(F15) |
| Exogenous shock | `interest_` | 货币政策冲击 | implementation_cross_check | (F5) |
| Exogenous shock | `fiscal_`, `fiscal_aerr` | 相机财政/ECFS 冲击 | source-stated for ECFS; implementation_cross_check mapping | (F2), (F13)-(F15) |
| Exogenous shocks | `*_aerr` residuals | 支出、价格、劳动、金融和外部部门方程残差冲击 | implementation_cross_check | (F12), (F16) |
| Parameters | `cofint*`, `std_r_` | 政策规则系数和冲击尺度 | implementation_cross_check | (F5) |
| Parameters | `coffispol` | 财政政策冲击尺度 | implementation_cross_check | (F13) |
| Parameters | `y_*` | MMB 实现中的方程系数 | implementation_cross_check | (F3)-(F16) |
| Scenario parameter | neutral nominal federal funds rate | 论文模拟中的 2、3、4 个百分点设定 | source-stated scenario assumption | (F18) |

待处理问题：

- `needs_review`：获取官方 LINVER 包方程/手册，用于来源层面方程抽取。
- `needs_review`：从 `.mod` 机械生成完整变量/冲击/参数清单。
- `needs_review`：确认 MMB 文件虽使用普通 `model;`，是否应在 Dynare 元数据中按 `model(linear)` 处理。
- `deferred_runtime_validation`：仅在后续明确分配的验证阶段运行 Dynare。
