# US_PM08fl -- 推导（半结构投影模型）

> 档案状态：needs_review。本一轮推导来自 Carabenciov et al. (2008), "A small quarterly projection model of the US economy," IMF Working Paper 08/278, DOI 10.5089/9781451871364.001 的 MinerU Markdown。`.mod` 文件仅作为 implementation_cross_check，用于核对带金融-实际联动的平稳化变体。

## 1. Model Overview

- **模型**：US_PM08fl，美国小型季度投影模型中包含金融-实际联动的版本。
- **来源**：Carabenciov, Ermolaev, Freedman, Juillard, Kamenik, Korshunov, and Laxton (2008), IMF Working Paper 08/278。
- **用途**：一个贝叶斯估计的预测和政策分析模型，覆盖产出、失业、通胀、联邦基金利率、均衡实际利率以及银行贷款收紧程度。
- **主体和模块**：这不是微观基础最优化 DSGE，而是半结构缺口模型，包含随机趋势模块、产出/通胀/政策/失业行为方程，以及基于银行贷款收紧程度（BLT）的金融-实际联动代理变量。
- **形式**：线性/平稳化缺口形式。MMB 实现使用 `model(linear)`，此点仅由 implementation_cross_check 确认。大多数变量是百分点缺口、年化利率或相对均衡值的偏离。
- **运行验证**：未执行；没有运行 Dynare。

## 2. Optimization Problems

论文没有为该 MMB 模型给出显式的家庭、企业、银行或政府最优化问题。来源文献描述的是一个含简约式行为方程和随机均衡过程的小型季度投影模型。

因此，实际的“问题”是政策和测度关系，而不是私人最优化：

- 潜在产出和 NAIRU 是潜在的随机均衡概念；
- 总需求由包含前瞻和后顾项的产出缺口关系刻画；
- 通胀由混合 Phillips 曲线关系刻画；
- 货币当局遵循 Taylor 型短期利率规则；
- BLT 是基于调查的金融-实际联动代理变量。

因为来源没有陈述最优化问题，下文所有均衡条件均分类为行为方程、定义、恒等式或外生/随机过程。

## 3. First-Order Conditions

来源没有陈述一阶条件。论文中的模型方程不是由显式最优化推导而来。为了保持档案格式连续，本节记录在动态模型中起核心作用的行为条件。

**(F1) 含金融-实际联动的产出缺口方程**：

```math
y_t
= \beta_1 y_{t-1}
+ \beta_2 y_{t+1}
- \beta_3 rrgap_{t-1}
- \theta \eta_t
+ \varepsilon_t^y .
```

这是来源中的方程 (14)。它通过加入分布滞后的 BLT 冲击项 $`\eta_t`$ 扩展了基准产出缺口方程。

**(F2) 通胀方程**：

```math
\pi_t
= \lambda_1 \pi4_{t+4}
+ (1-\lambda_1)\pi4_{t-1}
+ \lambda_2 y_{t-1}
- \varepsilon_t^\pi .
```

这是来源中的方程 (9)。$`\varepsilon_t^\pi`$ 前的负号由来源陈述；正的残差被解释为对通胀的下行压力。needs_review：通胀符号附近的 OCR 文字有乱码，但显示公式可读。

**(F3) 货币政策规则**：

```math
rs_t
= (1-\gamma_1)
\left[
\overline{rr}_t
+ \pi4_{t+3}
+ \gamma_2\left(\pi4_{t+3}-\pi^{tar}\right)
+ \gamma_4 y_t
\right]
+ \gamma_1 rs_{t-1}
+ \varepsilon_t^{rs}.
```

这是来源中的方程 (10)。规则以均衡实际利率和预期同比通胀隐含的均衡名义利率为目标，并包含平滑项以及对通胀目标缺口和产出缺口的反应。

**(F4) 动态 Okun 定律失业缺口方程**：

```math
u_t
= \alpha_1 u_{t-1}
+ \alpha_2 y_t
+ \varepsilon_t^u .
```

这是来源中的方程 (11)。论文说明该方程主要通过利用产出缺口与未来失业缺口变化之间的相关性来帮助实时测度产出缺口，而不是基础结构模块。

## 4. Market Clearing & Identities

模型没有显式的商品、劳动、资产或政府预算出清条件。它的会计关系是缺口和利率的测度恒等式。

**(F5) 产出缺口定义**：

```math
y_t = Y_t - \overline{Y}_t .
```

来源文字将 $`Y`$ 定义为实际 GDP 对数乘以 100，将 $`\overline{Y}`$ 定义为潜在产出对数乘以 100；OCR 对印刷关系的呈现受损。needs_review：Markdown 行中公式损坏，因此此恒等式由周围定义规范化而来。

**(F6) 失业缺口定义**：

```math
u_t = U_t - \overline{U}_t .
```

来源将失业缺口定义为实际失业率与均衡失业率/NAIRU 的差。

**(F7) 实际利率定义**：

```math
rr_t = rs_t - \pi_{t+1}.
```

这是来源中的方程 (5)。

**(F8) 实际利率缺口定义**：

```math
rrgap_t = rr_t - \overline{rr}_t .
```

这是来源中的方程 (6)。

**(F9) 同比通胀恒等式**：

```math
\pi4_t = \frac{\pi_t+\pi_{t-1}+\pi_{t-2}+\pi_{t-3}}{4}.
```

来源从 CPI 水平定义季度年化通胀和同比通胀。MMB 实现给出了这一精确的平稳化恒等式；这里记录为 implementation_cross_check，而不是独立的论文侧来源。

## 5. Exogenous Processes

**(F10) 潜在产出水平**：

```math
\overline{Y}_t
= \overline{Y}_{t-1}
+ \frac{g_t^{\overline{Y}}}{4}
+ \varepsilon_t^{\overline{Y}} .
```

这是来源中的方程 (1)。

**(F11) 潜在产出增长率**：

```math
g_t^{\overline{Y}}
= \tau g^{\overline{Y}ss}
+ (1-\tau) g_{t-1}^{\overline{Y}}
+ \varepsilon_t^{g^{\overline{Y}}}.
```

这是来源中的方程 (2)。

**(F12) 均衡失业率/NAIRU 水平**：

```math
\overline{U}_t
= \overline{U}_{t-1}
+ g_t^{\overline{U}}
+ \varepsilon_t^{\overline{U}} .
```

这是来源中的方程 (3)。

**(F13) 均衡失业率/NAIRU 增长项**：

```math
g_t^{\overline{U}}
= (1-\alpha_3)g_{t-1}^{\overline{U}}
+ \varepsilon_t^{g^{\overline{U}}}.
```

这是来源中的方程 (4)。

**(F14) 均衡实际利率**：

```math
\overline{rr}_t
= \rho \overline{rr}^{ss}
+ (1-\rho)\overline{rr}_{t-1}
+ \varepsilon_t^{\overline{rr}} .
```

这是来源中的方程 (7)。needs_review：来源文字说明均衡实际利率可因冲击偏离稳态，但持久性权重不同于更常见的 $`(1-\rho)\overline{rr}^{ss}+\rho\overline{rr}_{t-1}`$ 约定。MMB 实现使用了印刷方程中这种不常见的排序。

**(F15) 银行贷款收紧方程**：

```math
BLT_t
= \overline{BLT}_t
- \kappa y_{t+4}
+ \varepsilon_t^{BLT}.
```

这是来源中的方程 (12)。

**(F16) 均衡 BLT 随机游走**：

```math
\overline{BLT}_t
= \overline{BLT}_{t-1}
+ \varepsilon_t^{\overline{BLT}} .
```

这是来源中的方程 (13)。needs_review：OCR 公式有一处遗漏左侧时间下标，但从文字和实现看，意图是随机游走。

**(F17) 分布滞后的 BLT 冲击指数**：

```math
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
```

这是来源中的方程 (15)。驼峰形权重由来源陈述。

**(F18) 交叉相关结构**：

```math
\operatorname{corr}\!\left(\varepsilon_t^{g^{\overline{Y}}},\varepsilon_t^y\right)>0,
\qquad
\operatorname{corr}\!\left(\varepsilon_t^{\overline{Y}},\varepsilon_t^\pi\right)>0 .
```

来源说明 BLT 模型中存在两个正的交叉相关。表 6 报告的后验众数约为 0.1944 和 0.0422。

## 6. Steady-State Solution

该模型在 MMB 实现中是线性/平稳化形式。除非变量被定义为稳态水平或目标，带帽/缺口变量的稳态为零。

顺序稳态约定：

1. 将所有结构冲击设为零：对每个创新都有 $`\varepsilon_t^j=0`$。
2. 将缺口变量设为零：$`y=0`$，$`u=0`$，$`rrgap=0`$，$`\eta=0`$，实现中的带帽变量 $`RR\_USh`$、$`RR\_US\_BARh`$、$`PIE\_USh`$、$`PIE\_US4h`$、$`Y\_US`$ 和 $`RS\_USh`$ 均为零。
3. 在 (F11) 下，潜在产出增长率收敛到 $`g^{\overline{Y}ss}`$。
4. 在 (F13) 下，均衡失业率增长项收敛到零。
5. 均衡实际利率在水平上由 $`\overline{rr}^{ss}`$ 锚定；在平稳偏离形式中，$`\overline{rr}`$ 为零。
6. 通胀目标在水平上为 $`\pi^{tar}`$；在平稳偏离形式中，通胀变量为零。
7. 来源模型中的均衡 BLT 水平是随机游走。对于平稳化实现，创新表示使报告的 BLT 冲击状态在稳态为零。

needs_review：论文报告后验众数和冲击标准差，但没有给出原始水平模型的完整确定性稳态算法。未执行运行时稳态验证。

## 7. Timing & Form Conventions

- **形式**：线性/平稳化缺口模型；实现使用 `model(linear)`。
- **预期和超前项**：产出缺口依赖 $`y_{t+1}`$；通胀依赖 $`\pi4_{t+4}`$；货币政策依赖 $`\pi4_{t+3}`$；BLT 依赖预期产出状况 $`y_{t+4}`$。
- **滞后项**：需求使用 $`y_{t-1}`$ 和 $`rrgap_{t-1}`$；失业使用 $`u_{t-1}`$；通胀使用 $`\pi4_{t-1}`$ 和 $`y_{t-1}`$；货币政策通过 $`rs_{t-1}`$ 平滑。
- **分布滞后的金融效应**：$`\eta_t`$ 是 BLT 创新的九季度加权滞后多项式，在 $`t-5`$ 达到峰值。
- **存量变量**：此半结构条目没有物质资本或净值存量。潜在均衡水平 $`\overline{Y}_t`$、$`\overline{U}_t`$、$`\overline{rr}_t`$ 和 $`\overline{BLT}_t`$ 是预定随机状态。
- **年化**：季度通胀 $`\pi_t`$ 为年化；在实现中，$`\pi4_t`$ 是季度年化通胀的四季度平均。
- **实现交叉核对**：`US_PM08fl_rep.mod` 实现了一个简化的平稳化子集，其中 BLT 创新为 `E = RES_BLT_US`，产出效应为 `E2`，并且没有显式的潜在产出、NAIRU 或 BLT 水平方程。

## 8. Variable & Parameter Reference Table

| 类别 | 符号 / ASCII | 含义 | 由哪条方程决定 |
|---|---|---|---|
| 内生 | $`y_t`$ / `Y_US` | 产出缺口 | (F1), (F5) |
| 内生 | $`\pi_t`$ / `PIE_USh` | 季度通胀，年化 | (F2) |
| 内生 | $`rs_t`$ / `RS_USh` | 短期名义/政策利率 | (F3) |
| 内生 | $`u_t`$ / `UNR_US_GAP` | 失业缺口 | (F4), (F6) |
| 内生 | $`rr_t`$ / `RR_USh` | 实际利率 | (F7) |
| 内生 | $`rrgap_t`$ | 实际利率缺口 | (F8) |
| 内生 | $`\pi4_t`$ / `PIE_US4h` | 同比通胀度量 | (F9) |
| 内生 | $`\overline{Y}_t`$ | 潜在产出水平 | (F10) |
| 内生 | $`g_t^{\overline{Y}}`$ | 潜在产出增长率 | (F11) |
| 内生 | $`\overline{U}_t`$ | 均衡失业率 / NAIRU | (F12) |
| 内生 | $`g_t^{\overline{U}}`$ | NAIRU 增长项 | (F13) |
| 内生 | $`\overline{rr}_t`$ / `RR_US_BARh` | 均衡实际利率 | (F14) |
| 内生 | $`BLT_t`$ | 银行贷款收紧指数 | (F15) |
| 内生 | $`\overline{BLT}_t`$ | 均衡 BLT 水平 | (F16) |
| 内生 | $`\eta_t`$ / `E2` | 分布滞后的 BLT 创新效应 | (F17) |
| 内生 | `E` | 实现中的 BLT 创新状态 | implementation_cross_check |
| 内生 | `E4_PIE_US4h` | 报告用预期 $`\pi4_{t+4}`$ | implementation_cross_check |
| 内生 | `E1_PIE_USh` | 报告用预期 $`\pi_{t+1}`$ | implementation_cross_check |
| 内生 | `E1_Y_USh` | 报告用预期 $`y_{t+1}`$ | implementation_cross_check |
| 外生 | $`\varepsilon_t^{\overline{rr}}`$ / `RES_RR_US_BAR` | 均衡实际利率冲击 | (F14) |
| 外生 | $`\varepsilon_t^u`$ / `RES_UNR_US_GAP` | 失业缺口冲击 | (F4) |
| 外生 | $`\varepsilon_t^y`$ / `RES_Y_US` | 产出缺口冲击 | (F1) |
| 外生 | $`\varepsilon_t^\pi`$ / `RES_PIE_US` | 通胀冲击 | (F2) |
| 外生 | $`\varepsilon_t^{BLT}`$ / `RES_BLT_US` | BLT 冲击 | (F15), (F17) |
| 外生 | $`\varepsilon_t^{rs}`$ / `RES_RS_US` | 货币政策冲击 | (F3) |
| 外生 | $`\varepsilon_t^{\overline{Y}}`$ | 潜在产出水平冲击 | (F10) |
| 外生 | $`\varepsilon_t^{g^{\overline{Y}}}`$ | 潜在增长率冲击 | (F11) |
| 外生 | $`\varepsilon_t^{\overline{U}}`$ | NAIRU 水平冲击 | (F12) |
| 外生 | $`\varepsilon_t^{g^{\overline{U}}}`$ | NAIRU 增长冲击 | (F13) |
| 外生 | $`\varepsilon_t^{\overline{BLT}}`$ | 均衡 BLT 冲击 | (F16) |
| 参数 | $`\alpha_1`$, `alpha_us1` | 失业缺口持久性 | (F4) |
| 参数 | $`\alpha_2`$, `alpha_us2` | Okun 方程对产出缺口的反应 | (F4) |
| 参数 | $`\alpha_3`$, `alpha_us3` | NAIRU 增长持久性的互补权重 | (F13) |
| 参数 | $`\rho`$, `rho_us` | 均衡实际利率持久性/权重 | (F14) |
| 参数 | $`\overline{rr}^{ss}`$, `rr_us_bar_ss` | 稳态均衡实际利率 | (F14) |
| 参数 | $`\tau`$, `tau_us` | 潜在增长收敛权重 | (F11) |
| 参数 | $`g^{\overline{Y}ss}`$, `growth_us_ss` | 稳态潜在产出增长率 | (F11) |
| 参数 | $`\beta_1`$, `beta_us1` | 产出缺口滞后项系数 | (F1) |
| 参数 | $`\beta_2`$, `beta_us2` | 产出缺口超前项系数 | (F1) |
| 参数 | $`\beta_3`$, `beta_us3` | 实际利率缺口需求系数 | (F1) |
| 参数 | $`\lambda_1`$, `lambda_us1` | 通胀前瞻/后顾权重 | (F2) |
| 参数 | $`\lambda_2`$, `lambda_us2` | Phillips 曲线产出缺口系数 | (F2) |
| 参数 | $`\gamma_1`$, `gamma_us1` | 货币政策平滑 | (F3) |
| 参数 | $`\gamma_2`$, `gamma_us2` | 对通胀缺口的政策反应 | (F3) |
| 参数 | $`\gamma_4`$, `gamma_us4` | 对产出缺口的政策反应 | (F3) |
| 参数 | $`\pi^{tar}`$, `pietar_us_ss` | 通胀目标 | (F3) |
| 参数 | $`\kappa`$, `kappa_us` | BLT 对未来产出的反应 | (F15) |
| 参数 | $`\theta`$, `theta` | $`\eta_t`$ 对产出的影响 | (F1), (F17) |

平稳化后，MMB 实现包含 11 个内生变量和 6 个外生创新；上面的论文侧完整概念系统包含额外的潜在水平/增长状态和冲击。
