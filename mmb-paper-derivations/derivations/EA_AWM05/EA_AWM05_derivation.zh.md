# EA_AWM05 -- 推导存档条目

> 状态：needs_review。本一稿基于 Dieppe、Kuester 和 McAdam（2005）的 MinerU Markdown，并用 `EA_AWM05_rep.mod` 仅作实现交叉检查。原始 PDF 路径已为 provenance 核验，但未读取 PDF 正文。

## 1. Model Overview

- **模型 ID**：`EA_AWM05`。
- **论文**："Optimal monetary policy rules for the euro area: An analysis using the area wide model"，Alistair Dieppe、Keith Kuester 和 Peter McAdam，2005，DOI `10.1111/j.0021-9886.2005.00567.x`。
- **来源**：`raw/mmb_mineru/runs/ea_awm05__optimal_monetary_policy_rules_for_the_euro_area_an_analysis_using_the_ar__52db9f78/full.md`；原始 PDF 路径 `raw/mmb_papers/Optimal monetary policy rules for the euro area- An analysis using the area wide model.pdf`。
- **来源 sniff**：Markdown 首页给出了预期标题和预期作者。未发现标题/作者不匹配。实现文件头部则命名底层 Fagan-Henry-Mestre AWM 文档；这里记录为 `implementation_cross_check`，不作为论文侧证据。
- **经济体**：欧元区，季度估计的 Area Wide Model（AWM）。
- **核心结构**：大型经验结构宏观模型，包含持久的价格、工资、就业、投资、外部部门、财政和财富动态。多数私人部门模块是 backward-looking 或误差修正方程；汇率和长期债券期限结构包含 forward-looking 预期。
- **政策实验**：比较简单规则、优化简单规则和完全最优货币政策规则。MMB 实现暴露了一个线性短期名义利率政策规则，可包含通胀和产出的滞后/超前项以及利率冲击。
- **模型形式**：实现交叉检查中为 `model(linear)`。变量是相对长期均值或稳态比率的偏离；线性动态变量稳态为零，校准常数和份额另存。
- **运行验证**：未执行。

## 2. Optimization Problems

本文是 AWM 的最优政策应用，不是微观基础 DSGE 推导。私人部门 AWM 方程是估计的行为方程，因此论文侧来源没有给出家庭或企业目标函数。论文明确给出的优化问题是政策制定者的稳定化目标。

### 2.1 期间损失

中央银行评价通胀偏离目标、产出偏离潜在产出以及名义利率变化：

$$
\ell_t = (\pi_t-\pi^{\ast})^2 + \lambda (y_t-y_t^{\ast})^2 + \gamma (\Delta r_t)^2,
\qquad \Delta r_t = r_t-r_{t-1}.
$$

### 2.2 无条件损失

在政策规则比较中，期间损失用无条件标准差表示：

$$
\mathcal{L} = \sigma_\pi^2 + \lambda \sigma_{gap}^2 + \gamma \sigma_{\Delta r}^2.
$$

在许多报告的实验中，利率变化波动率被约束为匹配欧元区经验上界，因此平滑项并不总是直接加入损失函数。

### 2.3 简单政策规则搜索

广义简单规则选择反应系数和预测期：

$$
r_t = \rho r_{t-1} + \alpha E_t\pi_{t+\theta} + \beta E_t gap_{t+\kappa}.
$$

随后使用模型搜索在确定性/稳定性限制下使损失最小的参数向量。这个优化针对政策规则系数，而不是私人主体配置。

## 3. First-Order Conditions

由于 AWM 私人部门模块是经验模型且大体 backward-looking，来源没有提供家庭或企业的结构 FOC。以下方程因此概括政策最优性目标和 AWM 实现方程。从实现交叉检查取得的方程标为 `needs_review`，因为论文把完整模型清单指向 Fagan et al. (2001) 和 Dieppe-Henry (2004)。

- **(F1) 政策制定者期间损失**：

$$
\ell_t = (\pi_t-\pi^{\ast})^2 + \lambda gap_t^2 + \gamma (r_t-r_{t-1})^2.
$$

- **(F2) 政策评价损失**：

$$
\mathcal{L} = \sigma_\pi^2 + \lambda \sigma_{gap}^2 + \gamma \sigma_{\Delta r}^2.
$$

- **(F3) 通用简单利率规则**：

$$
r_t = \rho r_{t-1} + \alpha E_t\pi_{t+\theta} + \beta E_t gap_{t+\kappa}.
$$

- **(F4) MMB 灵活政策规则，implementation_cross_check，needs_review**：

$$
\begin{aligned}
i_t ={}& c + \sum_{j=1}^{4} a_j i_{t-j}
+ b_0 \pi^q_t + \sum_{j=1}^{4} b^-_j \pi^q_{t-j}
+ \sum_{j=1}^{4} b^+_j E_t\pi^q_{t+j} \\
&+ d_0 y^{gap}_t + \sum_{j=1}^{4} d^-_j y^{gap}_{t-j}
+ \sum_{j=1}^{4} d^+_j E_t y^{gap}_{t+j}
+ b_\pi \pi^{\ast} + b_{rlb}\bar r + \sigma_i \varepsilon^i_t .
\end{aligned}
$$

- **(F5) 就业方程，implementation_cross_check，needs_review**：

$$
\ell^n_t =
\ell^n_{t-1}
+ a_y(\Delta y^r_t+\pi^{pot}_t)
+ a_{\ell y}(\Delta y^r_{t-1}+\pi^{pot}_{t-1})
+ a_w\Delta w^r_t
+ a_{w1}\Delta w^r_{t-1}
+ a_{ecm}\left(\ell^n_{t-1}-\frac{1}{1-\beta_B}y^r_{t-1}\right)
+ \varepsilon^\ell_t .
$$

- **(F6) 工资方程，implementation_cross_check，needs_review**：

$$
\Delta w^n_t =
\Delta lprod_t + \Delta p^c_t - \omega_\pi \pi^c_{t-1}
+ \sum_j \omega_{pj}\Delta \pi^c_{t-j}
+ \sum_j \omega_{zj}\Delta lprod_{t-j}
+ \omega_u urx_{t-1}
- \omega_{ecm} ulc^T_{t-1}
+ \varepsilon^w_t .
$$

- **(F7) GDP 平减指数通胀，implementation_cross_check，needs_review**：

$$
\pi^{yfd}_t =
a_g y^r_{t-1} - a_\pi \pi^{yfd}_{t-1}
+ \sum_j a_{u,j}\Delta ulc^T_{t-j}
+ a_m \pi^m_{t-1}
- a_{ecm} ulc^T_{t-1}
+ \varepsilon^{yfd}_t .
$$

- **(F8) 消费者价格通胀，implementation_cross_check，needs_review**：

$$
\pi^c_t =
a_4\pi^c_{t-4}
+ a_y\pi^{yfd}_t + a_{y1}\pi^{yfd}_{t-1}
+ a_m\pi^m_t + a_{m1}\pi^m_{t-1}
+ a_o\pi^{oil}_t
+ a_{ecm}\left(p^c_{t-1}-\eta_m m^d_{t-1}\right)
+ \varepsilon^c_t .
$$

- **(F9) 投资比率，implementation_cross_check，needs_review**：

$$
i^r_t =
i^r_{t-1}+\Delta y^r_t
+ a_{y1}\Delta y^r_{t-1}
+ a_{ecm}\left[-(\bar s+\delta+a_i)i^r_{t-1}-s^r_{t-1}\right]
+ \varepsilon^I_t .
$$

- **(F10) 进口价格通胀，implementation_cross_check，needs_review**：

$$
\pi^m_t =
a_m\pi^m_{t-1}
+ a_{wx}\pi^{ywdx}_t
+ a_o\pi^{oil}_t+a_{o1}\pi^{oil}_{t-1}
+ a_{ecm}\left[\eta_x(m^d_{t-1}-x^d_{t-1})+\eta_o(m^d_{t-1}-oil_{t-1})+\eta_w(m^d_{t-1}-y^w_{t-1})\right]
+ \varepsilon^m_t .
$$

- **(F11) 私人消费比率，implementation_cross_check，needs_review**：

$$
c^r_t =
c^r_{t-1}-\pi^{pot}_t
+ a_u(urx_t-urx_{t-1})
+ a_s\left[\Delta s^n_{t-1}-\Delta\pi^c_{t-1}\right]
+ a_y(\pi^y_t+\pi^y_{t-1})
+ a_{py}(c^r_{t-1}-y^p_{t-1})
+ a_{w}(c^r_{t-1}-w^l_{t-1}+p^c_{t-1})
+ \varepsilon^C_t .
$$

- **(F12) 长期债券利率，implementation_cross_check，needs_review**：

$$
\ell^T_t =
\chi_T \frac{1}{20}\sum_{j=0}^{19} E_t s^n_{t+j}
+ \varepsilon^{LT}_t .
$$

## 4. Market Clearing & Identities

以下条件概括实现交叉检查中可见的模型恒等式。它们为 `needs_review`，因为索引论文只给出高层模型描述，并把完整 AWM 清单引用到其他来源。

- **(F13) 产出缺口定义**：

$$
gap_t = y^r_t-y^{pot}_t .
$$

- **(F14) 季度和年化消费者通胀定义**：

$$
\pi^q_t = 400\,\pi^c_t,\qquad
\pi^{ann}_t = \pi^c_t+\pi^c_{t-1}+\pi^c_{t-2}+\pi^c_{t-3}.
$$

- **(F15) 模型恒等式中使用的潜在产出增长过程**：

$$
\pi^{pot}_t = \beta_B \pi^{pot}_{t-1} + \beta_B(k^s_{t-1}-k^s_{t-2}).
$$

- **(F16) 由就业得到的失业缺口**：

$$
urx_t = -\frac{1-\bar U}{\bar U}\ell^n_t .
$$

- **(F17) 劳动生产率**：

$$
lprod_t = y^r_t + y^{trend}_t - \ell^n_t .
$$

- **(F18) 单位劳动成本恒等式**：

$$
ulc_t = w^i_t-y^{trend}_t-y^r_t,\qquad ulc^T_t=w^n_t-y^{trend}_t .
$$

- **(F19) 资本存量积累，线性化比率形式**：

$$
k^s_t =
\frac{1-\delta}{1+\bar g}k^s_{t-1}
-\frac{1-\delta}{1+\bar g}\pi^{pot}_t
+\frac{\bar g+\delta}{1+\bar g}i^r_t .
$$

- **(F20) 短期实际利率代理变量**：

$$
s^r_t =
\frac{0.25}{100}\left(\frac{1}{1+\bar s/100}\right)^{0.75}s^n_t
-0.25(\pi^{yfd}_t+\pi^{yfd}_{t-1}+\pi^{yfd}_{t-2}+\pi^{yfd}_{t-3}).
$$

- **(F21) 国内需求平减指数汇总**：

$$
f^d_t =
\omega_C c^r_t+\omega_G g^c_t+\omega_I i^r_t+\omega_X x^r_t
+(1-\omega_C-\omega_G-\omega_I-\omega_X)s^c_t .
$$

- **(F22) 贸易余额汇总**：

$$
tb_t = \omega_X x^n_t + (1-\omega_X)m^n_t .
$$

- **(F23) 实际 GDP 支出恒等式**：

$$
y^r_t =
\omega_C c^r_t+\omega_G g^c_t+\omega_I i^r_t+\omega_{TB}tb_t
+(1-\omega_C-\omega_G-\omega_I-\omega_{TB})s^c_t .
$$

- **(F24) 经常账户恒等式**：

$$
ca_t=\omega_{TB}tb_t+(1-\omega_{TB})nfn_t .
$$

- **(F25) 净外国资产积累**：

$$
nfa_t =
\frac{1}{(1+\bar g)(1+\bar\pi)}(nfa_{t-1}-\pi^{pot}_t-\pi^{yfd}_t)
+ \omega_{CA} ca_t .
$$

- **(F26) 私人收入恒等式**：

$$
y^p_t =
\omega_Y y^r_t +(1-\omega_Y-\omega_T-\omega_N-\omega_D)g^y_t
+\omega_T y^r_t+\omega_N nfn_t+\omega_D y^r_t .
$$

- **(F27) 私人财富恒等式**：

$$
w^l_t =
\omega_N nfa_t+\omega_K(k^s_t+i^d_t)+(1-\omega_N-\omega_K)g^d_t .
$$

- **(F28) 政府收入恒等式**：

$$
g^y_t =
\omega_{tdn}tdn_t+\omega_{ssn}y^r_t+\omega_{tin}y^r_t+\omega_{ogn}y^r_t
-\omega_{inn}inn_t-\omega_{trn}trn_t-\omega_{oth}y^r_t
+(1-\omega_{tdn}-\omega_{ssn}-\omega_{tin}-\omega_{ogn}+\omega_{inn}+\omega_{trn}+\omega_{oth})y^r_t .
$$

## 5. Exogenous Processes

实现包含就业、工资、平减指数、投资、贸易、消费、存货、出口、进口、长期利率、短期利率规则和财政支出的显式创新。论文侧文章强调货币政策冲击和固定财政规则，而不是紧凑的 DSGE 冲击列表。

- **(F29) 政策规则中的利率冲击，implementation_cross_check**：

$$
i_t = \cdots + \sigma_i \varepsilon^i_t .
$$

- **(F30) 政府消费冲击，implementation_cross_check，needs_review**：

$$
g^c_t-\bar a_g g^c_{t-1}+\pi^{pot}_t =
\rho_g(g^c_{t-1}-\bar a_g g^c_{t-2}+\pi^{pot}_{t-1})
+ \sigma_g\varepsilon^g_t .
$$

- **(F31) 结构残差模块，implementation_cross_check，needs_review**：

$$
\varepsilon_t =
\{\varepsilon^\ell_t,\varepsilon^w_t,\varepsilon^{yfd}_t,\varepsilon^c_t,\varepsilon^I_t,
\varepsilon^{id}_t,\varepsilon^x_t,\varepsilon^m_t,\varepsilon^C_t,\varepsilon^{lsr}_t,
\varepsilon^{xr}_t,\varepsilon^{mr}_t,\varepsilon^{LT}_t\}.
$$

## 6. Steady-State Solution

MMB 实现声明为 `model(linear)`。因此：

- **(F32) 线性模型稳态**：

$$
\bar x = 0 \quad \text{for each stationary deviation variable } x_t .
$$

非零长期比率和常数是校准输入，而不是非线性稳态未知量。实现交叉检查把它们存为 `PIBAR`、`STNBAR`、`YETGBAR`、稳态支出份额、政府债务份额、贸易份额和财富份额等参数。这些参数用于缩放第 3-5 节的线性化恒等式。

稳态重建仍为 `needs_review`，因为本条目归档的文章是最优政策应用，并未重现完整 AWM 稳态推导。

## 7. Timing & Form Conventions

- **形式**：线性化 `model(linear)`；方程使用相对长期均值或稳态比率的偏离。
- **预期**：AWM 大多是 backward-looking，但汇率和期限结构渠道使用 forward-looking 预期。政策规则可根据所选预测期包含通胀和产出的超前项。
- **存量时序**：资本存量 `ksr`、净外国资产 `nfa` 和政府债务 `gdn` 是带有滞后积累项的 predetermined stock variables。生产和支出使用当期流量变量和滞后存量。
- **利率**：`stn` 是短期名义利率；`ltn` 是由未来短期利率有限期望平均近似的长期名义利率。
- **通胀**：`pipcd` 是季度消费者价格通胀；`inflationq = 400*pipcd`；`infl` 汇总四个季度通胀项。
- **政策规则预测期**：来源区分 outcome-based、lagged-information、one-year-forward 和 optimized forecast-horizon 规则。MMB 实现通过当前、滞后和超前通胀/产出项的不同系数使其可操作。

## 8. Variable & Parameter Reference Table

| 类别 | 符号 / ASCII | 含义 | 主要方程 |
|---|---|---|---|
| 内生 | `interest`, `stn`, $i_t$ | 短期名义利率 | (F4) |
| 内生 | `inflation`, `infl` | 年通胀指标 | (F14) |
| 内生 | `inflationq`, `pipcd` | 年化季度消费者通胀 | (F14), (F8) |
| 内生 | `outputgap` | 产出缺口 | (F13) |
| 内生 | `output`, `yer` | 实际 GDP/产出 | (F23) |
| 内生 | `lnn` | 就业 | (F5) |
| 内生 | `wrn` | 名义工资 | (F6) |
| 内生 | `piyfd` | GDP 平减指数通胀 | (F7) |
| 内生 | `pcd` | 消费者价格平减指数水平/偏离 | (F8), (F14) |
| 内生 | `itr` | 实际投资比率 | (F9) |
| 内生 | `ksr` | 资本存量比率 | (F19) |
| 内生 | `strq` | 短期实际利率代理变量 | (F20) |
| 内生 | `ltn` | 长期名义利率 | (F12) |
| 内生 | `pcr` | 私人消费比率 | (F11) |
| 内生 | `xtr`, `mtr`, `tbr` | 出口、进口和贸易余额比率 | (F22), 相关贸易方程 |
| 内生 | `nfa`, `can`, `nfn` | 净外国资产、经常账户、净要素收入 | (F24), (F25) |
| 内生 | `gcr`, `gyn`, `gdn` | 政府消费、收入、债务 | (F28), (F30) |
| 内生 | `wln`, `pyn`, `pyr` | 财富、私人收入、实际私人收入 | (F26), (F27) |
| 外生 | `interest_` | 货币政策创新 | (F29) |
| 外生 | `fiscal_` | 财政/政府消费创新 | (F30) |
| 外生 | `innoe*` | 经验 AWM 模块残差创新 | (F31) |
| 参数 | $\lambda$ | 损失函数中产出缺口波动权重 | (F1), (F2) |
| 参数 | $\gamma$ | 损失函数中利率变化波动权重 | (F1), (F2) |
| 参数 | $\rho,\alpha,\beta,\theta,\kappa$ | 简单规则平滑、反应系数和预测期 | (F3) |
| 参数 | `cofint*` | 实现中的政策规则系数 | (F4) |
| 参数 | `PIBAR`, `STNBAR`, `YETGBAR` | 通胀、短期利率和潜在增长稳态常数 | (F19), (F20), (F32) |
| 参数 | `*_YERBAR`, `*_YENBAR`, `*_FDDBAR` | 线性汇总中使用的稳态份额 | (F21)-(F28) |
| 参数 | equation-specific `*_ECM`, `*_DL*`, `*_RES` | 估计的 AWM 动态和误差修正系数 | (F5)-(F12) |

方程计数说明：(F1)-(F32) 是归档方程和恒等式，不是逐内生变量的一对一实现重建。完整 MMB `.mod` 包含许多辅助滞后方程和经验恒等式，超出上面的紧凑来源支持摘要。
