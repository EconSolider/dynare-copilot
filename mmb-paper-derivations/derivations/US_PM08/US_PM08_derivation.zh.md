# US_PM08 - 推导（小型季度预测模型）

> 归档状态：`needs_review`。本一稿推导基于 MinerU Markdown 和有针对性的 PDF 文本核对。未执行 Dynare 运行验证。

来源：`US_PM08`，Carabenciov, Ermolaev, Freedman, Juillard, Kamenik, Korshunov, and Laxton (2008)，"A small quarterly projection model of the US economy"，IMF Working Paper 08/278，DOI `10.5089/9781451871364.001`。来源 Markdown：`raw/mmb_mineru/runs/gpm6_imf13_us_pm08_us_pm08fl__a_small_quarterly_projection_model_of_the_us_economy__a2e8676b/full.md`。

## 1. Model Overview

- **模型**：IMF Global Projection Model 系列中的美国小型季度预测模型。
- **用途**：用于预测和政策分析的贝叶斯估计半结构模型，覆盖产出、通胀、失业、联邦基金利率、均衡实际利率以及金融-实体联动。
- **主体与模块**：该模型不是从家庭-企业最优化出发的微观基础 DSGE 模型。它由产出缺口、通胀、货币政策、奥肯定律、潜在产出、NAIRU、均衡实际利率和银行贷款收紧条件等行为方程组成。
- **变体边界**：论文先给出不含金融-实体联动的基准模型，再加入 BLT 变量扩展。`US_PM08` 的 MMB 实现是带 BLT 冲击滞后效应的平稳 `model(linear)` 版本，因此本条目记录含 BLT 的版本，并说明令 BLT 项为零时嵌套基准方程。
- **形式**：线性/平稳缺口模型，在 MMB 中表示为 `model(linear)`。论文描述潜在产出和 NAIRU 等水平变量；实现交叉核对使用平稳偏离/缺口变量。

## 2. Optimization Problems

这是一个小型半结构预测模型。论文没有给出家庭、企业、银行或政府的显式最优化问题。相反：

- 总需求由含前瞻和后顾项的产出缺口关系决定；
- 通胀由混合 Phillips 曲线关系决定；
- 货币政策由带平滑的 Taylor 型利率规则决定；
- 失业由动态奥肯定律关系决定；
- 潜在产出、NAIRU、均衡实际利率和 BLT 均衡项服从随机趋势/缺口过程。

`needs_review`：除论文给出的行为方程外，没有推断任何最优化问题。

## 3. First-Order Conditions

由于来源是半结构模型，本节记录行为条件，而不是由显式最优化推出的一阶条件。

- **(F1) 产出缺口/总需求，基准形式**：

$$
y_t = \beta_1 y_{t-1} + \beta_2 y_{t+1} - \beta_3 rrgap_{t-1} + \varepsilon_t^y .
$$

- **(F2) 带金融-实体联动的产出缺口**：

$$
y_t = \beta_1 y_{t-1} + \beta_2 y_{t+1} - \beta_3 rrgap_{t-1} - \theta \eta_t + \varepsilon_t^y .
$$

当 BLT 分布滞后项不存在或其载荷为零时，基准模型嵌套在该式中。

- **(F3) 通胀方程**：

$$
\pi_t = \lambda_1 \pi4_{t+4} + (1-\lambda_1)\pi4_{t-1} + \lambda_2 y_{t-1} - \varepsilon_t^\pi .
$$

`needs_review`：论文将通胀残差写为负号；此处保留该符号。

- **(F4) Taylor 型政策规则**：

$$
rs_t = (1-\gamma_1)\left[
\overline{rr}_t + \pi4_{t+3}
+ \gamma_2\left(\pi4_{t+3}-\pi^{tar}\right)
+ \gamma_4 y_t
\right] + \gamma_1 rs_{t-1} + \varepsilon_t^{rs}.
$$

- **(F5) 动态奥肯定律**：

$$
u_t = \alpha_1 u_{t-1} + \alpha_2 y_t + \varepsilon_t^u .
$$

- **(F6) 银行贷款收紧方程**：

$$
BLT_t = \overline{BLT}_t - \kappa y_{t+4} + \varepsilon_t^{BLT}.
$$

`needs_review`：有针对性的 PDF 文本核对确认了方程结构，但 BLT 趋势/均衡项上的上横线受 OCR 影响。

- **(F7) 进入需求的 BLT 冲击分布滞后**：

$$
\eta_t =
0.04\varepsilon_{t-1}^{BLT}
+0.08\varepsilon_{t-2}^{BLT}
+0.12\varepsilon_{t-3}^{BLT}
+0.16\varepsilon_{t-4}^{BLT}
+0.20\varepsilon_{t-5}^{BLT}
+0.16\varepsilon_{t-6}^{BLT}
+0.12\varepsilon_{t-7}^{BLT}
+0.08\varepsilon_{t-8}^{BLT}
+0.04\varepsilon_{t-9}^{BLT}.
$$

## 4. Market Clearing & Identities

- **(F8) 产出缺口定义**：

$$
y_t = Y_t - \overline{Y}_t .
$$

论文将 $Y_t$ 和 $\overline{Y}_t$ 分别定义为实际 GDP 和潜在产出的 100 倍对数。

- **(F9) 失业缺口定义**：

$$
u_t = U_t - \overline{U}_t .
$$

- **(F10) 实际利率定义**：

$$
rr_t = rs_t - \pi_{t+1}.
$$

- **(F11) 实际利率缺口定义**：

$$
rrgap_t = rr_t - \overline{rr}_t .
$$

- **(F12) 同比通胀定义**：

$$
\pi4_t = \frac{\pi_t+\pi_{t-1}+\pi_{t-2}+\pi_{t-3}}{4}.
$$

`needs_review`：论文从 CPI 对数定义季度年化通胀和同比通胀；该平均式是平稳实现中的恒等式，并与 `.mod` 交叉核对一致。

- **(F13) 四季度通胀报告期望**：

$$
E4\_\pi4_t = \pi4_{t+4}.
$$

- **(F14) 下一季度通胀报告期望**：

$$
E1\_\pi_t = \pi_{t+1}.
$$

- **(F15) 下一期产出缺口报告期望**：

$$
E1\_y_t = y_{t+1}.
$$

## 5. Exogenous Processes

- **(F16) 潜在产出随机趋势**：

$$
\overline{Y}_t = \overline{Y}_{t-1} + \frac{g_t^{\overline{Y}}}{4} + \varepsilon_t^{\overline{Y}}.
$$

- **(F17) 潜在产出增长过程**：

$$
g_t^{\overline{Y}} = \tau g^{\overline{Y},ss} + (1-\tau)g_{t-1}^{\overline{Y}} + \varepsilon_t^{g^{\overline{Y}}}.
$$

- **(F18) NAIRU 随机趋势**：

$$
\overline{U}_t = \overline{U}_{t-1} + g_t^{\overline{U}} + \varepsilon_t^{\overline{U}}.
$$

- **(F19) NAIRU 增长过程**：

$$
g_t^{\overline{U}} = (1-\alpha_3)g_{t-1}^{\overline{U}} + \varepsilon_t^{g^{\overline{U}}}.
$$

- **(F20) 均衡实际利率过程**：

$$
\overline{rr}_t = \rho \overline{rr}^{ss} + (1-\rho)\overline{rr}_{t-1} + \varepsilon_t^{\overline{rr}}.
$$

`needs_review`：MinerU Markdown 与有针对性的 PDF 文本显示同一结构，但 PDF 提取中的系数位置有视觉噪声。

- **(F21) BLT 均衡项过程**：

$$
\overline{BLT}_t = \overline{BLT}_{t-1} + \varepsilon_t^{\overline{BLT}}.
$$

`needs_review`：方程 13 附近的 Markdown/PDF 文本在部分提取结果中丢失左侧下标。

`US_PM08` 的 MMB 实现交叉核对使用外生创新 `RES_RR_US_BAR`、`RES_UNR_US_GAP`、`RES_Y_US`、`RES_PIE_US`、`RES_BLT_US` 和 `RES_RS_US`；它省略了论文层面的潜在产出和 NAIRU 增长随机趋势创新，改用平稳实现状态向量。

## 6. Steady-State Solution

论文以缺口、增长率和年化利率表示，而不是非线性资源配置稳态。对于平稳 MMB 实现，自然的确定性稳态为：

1. 所有创新为零。
2. 缺口变量满足 $y=0$、$u=0$、$rrgap=0$，报告期望变量等于相应的超前变量。
3. 在论文的非去均值记号中，通胀锚定在目标 $\pi4=\pi=\pi^{tar}$；在平稳实现交叉核对中，`PIE_USh` 和 `PIE_US4h` 是偏离变量，所以稳态为零。
4. 论文记号中的均衡实际利率位于稳态成分 $\overline{rr}^{ss}$；在平稳实现交叉核对中，`RR_US_BARh` 是偏离状态，稳态为零。
5. 论文记号中的政策利率满足 $rs=\overline{rr}^{ss}+\pi^{tar}$，而 `RS_USh` 等实现偏离变量的稳态为零。
6. 潜在产出和 NAIRU 水平是论文中的随机趋势，不由有限的确定性水平稳态钉住；其平稳偏离为零。
7. BLT 及其均衡趋势在论文中是随机游走成分。平稳实现直接使用 BLT 创新/分布滞后效应，所以实现稳态值为零。

`needs_review`：论文层面随机趋势系统和平稳 MMB 变量之间的完整稳态映射，需要进一步核对复制包约定。

## 7. Timing & Form Conventions

- **时序**：季度模型。产出缺口方程包含 $y_{t+1}$ 和滞后 $rrgap_{t-1}$。通胀方程包含 $\pi4_{t+4}$ 和 $\pi4_{t-1}$。政策规则响应提前三个季度的预期同比通胀 $\pi4_{t+3}$ 和当期产出缺口。BLT 方程使用 $y_{t+4}$；BLT 冲击通过 $t-1$ 到 $t-9$ 的滞后影响需求。
- **存量**：没有实物资本存量。潜在产出、NAIRU、均衡实际利率和 BLT 均衡项是潜在状态/趋势变量。
- **通胀单位**：季度通胀为年化；同比通胀是四季度对数差。平稳实现恒等式使用四个季度年化率的平均。
- **形式**：线性/平稳 `model(linear)`。未执行非线性 Dynare 运行。
- **实现交叉核对**：`.agents/skills/dynare-copilot/references/examples/US_PM08_rep.mod` 确认了平稳 `model(linear)` 模块，以及变量 `RR_USh`、`RR_US_BARh`、`UNR_US_GAP`、`PIE_USh`、`PIE_US4h`、`Y_US`、`RS_USh`、期望报告变量和 BLT 冲击分布辅助变量。该文件仅作为 `implementation_cross_check` 使用。

## 8. Variable & Parameter Reference Table

| 类别 | 符号 / 实现名称 | 含义 | 主要方程 |
|---|---|---|---|
| 内生变量 | $y_t$ / `Y_US` | 产出缺口 | (F2), (F8) |
| 内生变量 | $u_t$ / `UNR_US_GAP` | 失业缺口 | (F5), (F9) |
| 内生变量 | $\pi_t$ / `PIE_USh` | 季度年化通胀 | (F3) |
| 内生变量 | $\pi4_t$ / `PIE_US4h` | 四季度通胀 | (F12) |
| 内生变量 | $rr_t$ / `RR_USh` | 实际利率 | (F10) |
| 内生变量 | $\overline{rr}_t$ / `RR_US_BARh` | 均衡实际利率 | (F20) |
| 内生变量 | $rrgap_t$ | 实际利率缺口 | (F11) |
| 内生变量 | $rs_t$ / `RS_USh` | 短期名义政策利率 | (F4) |
| 内生变量 | $\eta_t$ / `E2` | 进入需求的 BLT 冲击分布滞后 | (F7) |
| 内生变量 | $BLT_t$ | 银行贷款收紧变量 | (F6) |
| 内生变量 | $\overline{BLT}_t$ | BLT 均衡成分 | (F21) |
| 内生变量 | $E4\_\pi4_t$ / `E4_PIE_US4h` | 四季度通胀报告期望 | (F13) |
| 内生变量 | $E1\_\pi_t$ / `E1_PIE_USh` | 下一季度通胀报告期望 | (F14) |
| 内生变量 | $E1\_y_t$ / `E1_Y_USh` | 产出缺口报告期望 | (F15) |
| 潜在/状态变量 | $\overline{Y}_t$ | 潜在产出水平 | (F16) |
| 潜在/状态变量 | $g_t^{\overline{Y}}$ | 潜在产出增长 | (F17) |
| 潜在/状态变量 | $\overline{U}_t$ | NAIRU 水平 | (F18) |
| 潜在/状态变量 | $g_t^{\overline{U}}$ | NAIRU 增长 | (F19) |
| 外生创新 | $\varepsilon_t^y$ / `RES_Y_US` | 产出缺口冲击 | (F1), (F2) |
| 外生创新 | $\varepsilon_t^\pi$ / `RES_PIE_US` | 通胀冲击 | (F3) |
| 外生创新 | $\varepsilon_t^{rs}$ / `RES_RS_US` | 政策利率冲击 | (F4) |
| 外生创新 | $\varepsilon_t^u$ / `RES_UNR_US_GAP` | 失业缺口冲击 | (F5) |
| 外生创新 | $\varepsilon_t^{BLT}$ / `RES_BLT_US` | BLT 冲击 | (F6), (F7) |
| 外生创新 | $\varepsilon_t^{\overline{rr}}$ / `RES_RR_US_BAR` | 均衡实际利率冲击 | (F20) |
| 外生创新 | $\varepsilon_t^{\overline{Y}}$ | 潜在产出水平冲击 | (F16) |
| 外生创新 | $\varepsilon_t^{g^{\overline{Y}}}$ | 潜在产出增长冲击 | (F17) |
| 外生创新 | $\varepsilon_t^{\overline{U}}$ | NAIRU 水平冲击 | (F18) |
| 外生创新 | $\varepsilon_t^{g^{\overline{U}}}$ | NAIRU 增长冲击 | (F19) |
| 外生创新 | $\varepsilon_t^{\overline{BLT}}$ | BLT 均衡项冲击 | (F21) |
| 参数 | $\alpha_1,\alpha_2,\alpha_3$ / `alpha_us1`, `alpha_us2`, `alpha_us3` | 奥肯定律和 NAIRU 增长参数 | (F5), (F19) |
| 参数 | $\beta_1,\beta_2,\beta_3$ / `beta_us1`, `beta_us2`, `beta_us3` | 产出缺口动态和实际利率缺口载荷 | (F1), (F2) |
| 参数 | $\lambda_1,\lambda_2$ / `lambda_us1`, `lambda_us2` | 通胀前瞻/后顾权重和产出缺口斜率 | (F3) |
| 参数 | $\gamma_1,\gamma_2,\gamma_4$ / `gamma_us1`, `gamma_us2`, `gamma_us4` | 政策平滑和 Taylor 规则响应 | (F4) |
| 参数 | $\rho$ / `rho_us` | 均衡实际利率持久性/载荷约定 | (F20) |
| 参数 | $\tau$ / `tau_us` | 潜在产出增长回归速度 | (F17) |
| 参数 | $\kappa$ / `kappa_us` | 产出缺口对 BLT 的影响 | (F6) |
| 参数 | $\theta$ / `theta` | 需求方程中的 BLT 分布滞后载荷 | (F2), (F7) |
| 参数 | $\pi^{tar}$ / `pietar_us_ss` | 通胀目标 | (F4) |
| 参数 | $\overline{rr}^{ss}$ / `rr_us_bar_ss` | 稳态均衡实际利率 | (F20) |
| 参数 | $g^{\overline{Y},ss}$ / `growth_us_ss` | 稳态潜在产出增长 | (F17) |
