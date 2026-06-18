# NK_LWW03 - 推导（最优化问题 + 一阶条件）

> 这是一个第一轮归档条目，来源为 Levin, Wieland, and Williams (2003) 的 MinerU Markdown。本文记录论文中的小型 optimizing AD-AS 模型，并把 MMB 的 `NK_LWW03` 实现作为交叉核对。未执行运行时验证。

## 1. 模型概述

- **模型 ID**：`NK_LWW03`。
- **论文**：Andrew Levin, Volker Wieland, and John C. Williams (2003), "The Performance of Forecast-Based Monetary Policy Rules under Model Uncertainty," *American Economic Review* 93(3), 622-645。
- **DOI**：`10.1257/000282803322157016`。
- **来源 Markdown**：`raw/mmb_mineru/runs/nk_lww03_nk_lww03al_us_frb03__the_performance_of_forecast_based_monetary_policy_rules_under_model_unce__c97e3d2f/full.md`。
- **原始 PDF**：`raw/mmb_papers/The Performance of Forecast-Based Monetary Policy Rules under Model Uncertainty.pdf`。
- **MinerU run id**：`c97e3d2f-7a9e-4264-94c8-b3429b587455`。
- **模型族**：小型理性预期 New Keynesian / optimizing AD-AS 模型，包含名义惯性和货币中性。
- **主体与模块**：论文描述的风格化系统来自优化行为，包括价格设定 / 总供给模块、预期 IS / 总需求模块、货币政策规则，以及自然实际利率和通胀的外生扰动。
- **形式**：线性化模型。MMB 实现交叉核对使用 `model(linear)`，变量以年化百分点或缺口单位表示。
- **状态**：`needs_review`。论文说明两条结构方程来自优化主体，但提取出的 Markdown 没有给出完整的家庭和企业原始问题；因此本条目保持在约化形式均衡层面。

## 2. 最优化问题

来源论文没有为这个小型 optimizing AD-AS 模型给出完整的原始家庭问题、最终品聚合器、Calvo 定价问题或中央银行损失最小化问题。论文说明第一个模型是一个小型风格化模型，参考 Bernanke-Woodford、Clarida-Gali-Gertler 和 Woodford，由两条来自优化行为的方程构成。因此，本归档条目记录约化形式均衡系统，而不发明缺失的原始问题。

- **代表性需求侧**：由预期 IS 曲线概括。其背后的优化是跨期消费 / 储蓄边际；当事前实际政策利率高于自然实际利率时，产出缺口下降。
- **价格设定侧**：由前瞻 Phillips 曲线概括。其背后的优化是交错名义价格设定；当期通胀取决于未来预期通胀、产出缺口和成本推动扰动。
- **政策当局**：论文评估时不变的简单工具规则。MMB `NK_LWW03` 实现交叉核对固定了一条当前通胀规则，而论文也报告了预测型规则。

`needs_review`：未来的源码级复核应决定是否用论文引用的 Woodford / Clarida-Gali-Gertler 来源补充原始目标函数，而不是只保留论文的约化形式方程。

## 3. 一阶条件

论文中的结构模型已经写成线性化均衡条件，因此以下条件是与约化形式 FOC / 均衡方程对应的 F 编号归档方程。

- **(F1) 前瞻 Phillips 曲线 / 总供给**：

\[
\pi_t = \delta E_t \pi_{t+1} + \phi y_t + \varepsilon_t.
\]

当期通胀取决于下一期预期通胀、产出缺口和总供给扰动。

- **(F2) 预期 IS 曲线 / 总需求**：

\[
y_t = E_t y_{t+1} - \sigma\left(i_t - E_t \pi_{t+1} - r_t^{\ast}\right).
\]

当短期名义利率超过预期通胀加自然实际利率时，产出缺口下降。

- **(F3) 论文中的一般预测型工具规则**：

\[
i_t =
\rho i_{t-1}
+ (1-\rho)\left(r^{\ast} + E_t\tilde{\pi}_{t+\theta}\right)
+ \alpha\left(E_t\tilde{\pi}_{t+\theta}-\pi^{\ast}\right)
+ \beta E_t y_{t+\kappa}.
\]

其中 `theta` 是通胀预测期，`kappa` 是产出缺口预测期，二者都以季度计。来源论文用这个规则类别做稳健性实验。

- **(F4) 来源论文的基准预测型规则**：

\[
i_t = 1.0\,i_{t-1} + 0.4\,E_t\left(\tilde{\pi}_{t+4}-\pi^{\ast}\right) + 0.4\,y_t.
\]

这是论文给出的、在五个模型中表现稳健的基准规则。`implementation_cross_check`：MMB 的 `NK_LWW03_rep.mod` 没有实现这条精确的预测型规则；它使用 (F5) 中的简单当前通胀规则。

- **(F5) MMB 实现中的政策规则变体**：

\[
i_t = 1.5\,\pi_t.
\]

该方程来自 `.mod` 实现交叉核对（`rff = 1.5*pdot`），不作为论文的基准规则处理。这里列出它是为了说明具体的 MMB `NK_LWW03` 变体。

## 4. 市场出清与恒等式

- **(F6) 产出缺口定义**：

\[
y_t \equiv \log Y_t - \log Y_t^{pot}.
\]

论文把 `y` 描述为产出缺口，即产出相对潜在产出的偏离。

- **(F7) 实现中使用的政策利率变化恒等式**：

\[
\Delta i_t = i_t - i_{t-1}.
\]

`implementation_cross_check`：MMB 实现包含 `drff = rff - rff(-1)`，表示联邦基金利率变化。该恒等式对模型输出有用，但不是论文中的独立行为模块。

## 5. 外生过程

- **(F8) 自然实际利率过程**：

\[
r_t^{\ast} = \rho_r r_{t-1}^{\ast} + \eta^r_t.
\]

论文把 `rstar` 的自相关系数校准为 0.35，创新标准差为 3.72，单位为年化百分点。`.mod` 交叉核对使用 `rhorstar = 0.35`。

- **(F9) 总供给 / 通胀冲击过程**：

\[
\varepsilon_t = \rho_{\varepsilon}\varepsilon_{t-1} + \eta^\pi_t.
\]

来源文本说明，在 optimizing AD-AS 校准中，总供给扰动是 i.i.d.；MMB 实现交叉核对保留参数 `rhopish` 并将其设为 0。因此本条目记录 AR(1) 包络形式，并在来源校准基线中取 `\rho_{\varepsilon}=0`。

## 6. 稳态解

由于模型是线性化的缺口 / 偏离形式，确定性稳态为内生缺口变量的零向量和零均值冲击：

\[
\bar{y}=0,\qquad \bar{\pi}=0,\qquad \bar{i}=0,\qquad \overline{\Delta i}=0,
\qquad \bar{r}^{\ast}=0,\qquad \bar{\varepsilon}=0.
\]

对 MMB 实现交叉核对：

1. 设 `rstar = 0` 且 `pdotsh = 0`。
2. 由 (F1)，`pdot = discountt*pdot + 4*phi*ygap`；由于 `discountt < 1`，零通胀、零缺口稳态满足该方程。
3. 由 (F2)，`ygap = ygap - 0.25*sigma*(rff - pdot - rstar)`，所以当 `pdot = rstar = 0` 时有 `rff = 0`。
4. 由 (F5)，`rff = 1.5*pdot = 0`。
5. 由 (F7)，`drff = 0`。

未执行运行时验证。

## 7. 时序与形式约定

- **线性化**：论文方程和 MMB 实现都是线性 / 缺口形式方程，不是非线性水平值。
- **频率和缩放**：季度时点；在来源讨论和实现中，通胀与利率以年化百分点单位表示。
- **预期**：`E_t` 表示基于 `t` 期可得信息的理性预期。
- **前瞻变量**：(F1)-(F2) 中通胀和产出缺口带有一期超前预期；预测型政策规则可以使用多季度预测期。
- **存量变量**：`NK_LWW03` 约化模型中没有资本或其他实物存量状态。滞后名义利率在预测型政策规则类别中是预定变量。
- **实现政策规则区别**：来源论文的基准预测型规则 (F4) 不应与 MMB 实现中的简单当前通胀规则 (F5) 混淆。

## 8. 变量与参数对照表

| 类别 | 符号 / ASCII 名称 | 含义 | 方程覆盖 |
|---|---|---|---|
| 内生变量 | `ygap`, \(y_t\) | 产出缺口 | (F1), (F2), (F3), (F4), (F6) |
| 内生变量 | `pdot`, \(\pi_t\) | 通胀率 | (F1), (F2), (F3), (F4), (F5) |
| 内生变量 | `rff`, \(i_t\) | 短期名义政策利率 / 联邦基金利率 | (F2), (F3), (F4), (F5) |
| 内生变量 | `drff`, \(\Delta i_t\) | 政策利率变化 | (F7) |
| 内生 / 外生状态 | `rstar`, \(r_t^{\ast}\) | 自然实际利率 | (F2), (F8) |
| 内生 / 外生状态 | `pdotsh`, \(\varepsilon_t\) | 通胀 / 总供给扰动 | (F1), (F9) |
| 外生创新 | `rstar_`, \(\eta^r_t\) | 自然利率创新 | (F8) |
| 外生创新 | `pdotsh_`, \(\eta^\pi_t\) | 通胀冲击创新 | (F9) |
| 参数 | `discountt`, \(\delta\) | 通胀预期贴现系数 | (F1) |
| 参数 | `sigma`, \(\sigma\) | IS 曲线实际利率敏感度 | (F2) |
| 参数 | `phi`, \(\phi\) | 年化调整前的 Phillips 曲线斜率 | (F1) |
| 参数 | `wtrl` | MMB 政策规则交叉核对参数；未在 `NK_LWW03_rep.mod` model block 中启用 | needs_review |
| 参数 | `rhorstar`, \(\rho_r\) | 自然利率 AR 系数 | (F8) |
| 参数 | `rhopish`, \(\rho_{\varepsilon}\) | 通胀冲击 AR 系数 | (F9) |
| 政策参数 | \(\rho\) | 论文规则类别中的利率平滑 | (F3), (F4) |
| 政策参数 | \(\alpha\) | 对预测通胀缺口的反应 | (F3), (F4) |
| 政策参数 | \(\beta\) | 对产出缺口预测 / 当期产出缺口的反应 | (F3), (F4) |
| 政策参数 | \(\theta\) | 通胀预测期 | (F3), (F4) |
| 政策参数 | \(\kappa\) | 产出缺口预测期 | (F3) |
