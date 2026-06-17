# US_OR03 - 推导（最优化问题 + 一阶条件）

> MMB 模型 `US_OR03` 的来源支撑型第一遍档案条目。状态：`needs_review`。未执行运行时验证。

## 1. Model Overview

- **模型**：Orphanides (2003), "The quest for prosperity without inflation"；MMB 模型 ID `US_OR03`。
- **来源**：MinerU Markdown 位于 `raw/mmb_mineru/runs/us_or03__the_quest_for_prosperity_without_inflation__1b77d67e/full.md`；原始 PDF 位于 `raw/mmb_papers/The quest for prosperity without inflation.pdf`。
- **论文元数据**：Athanasios Orphanides，2003，DOI `10.1016/s0304-3932(03)00028-x`。
- **模型类别**：小型美国宏观计量政策模型，可解释为带四阶滞后的轻度受限结构 VAR。
- **核心变量**：季度通胀 $\pi_t$、产出缺口 $y_t$、联邦基金利率/政策工具 $f_t$ 或 $R_t$。
- **形式**：线性估计系统。Rep-MMB 实现使用 `model(linear)`，变量为 `y`、`pi` 和 `f`。
- **用途**：在完全信息和实时数据信息假设下，对 Taylor 型政策规则进行反事实模拟。

## 2. Optimization Problems

本文不是包含家庭、企业、资本或政府最优化的微观基础 DSGE 模型。它估计一个简约式宏观系统，并在反事实模拟中施加替代政策规则。

政策当局由简单的利率反馈规则表示，而不是由 Ramsey 或相机抉择最优化问题求解。一般的积极型规则族为：

$$
R_t-R_t^*=\gamma(\pi_t^a-\pi^*)+\delta y_t.
$$

信息问题来自政策制定者观察到的是实时测度 $\tilde{\pi}_t^a$ 和 $\tilde{y}_t$，而不是最终数据值。论文评估这些规则选择所隐含的宏观表现；它不推导私人部门主体的一阶条件。

## 3. First-Order Conditions

没有私人主体的一阶条件。以下编号方程是线性 MMB 档案表示所需的均衡、政策和信息方程。

- **(F1) 产出缺口方程**：

$$
y_t =
b_0
+ \sum_{i=1}^{4} b_i^\pi \pi_{t-i}
+ \sum_{i=1}^{4} b_i^y y_{t-i}
+ \sum_{i=1}^{4} b_i^f f_{t-i}
+ u_t.
$$

- **(F2) 通胀方程**：

$$
\pi_t =
\sum_{i=1}^{4} a_i^\pi \pi_{t-i}
+ \sum_{i=0}^{4} a_i^y y_{t-i}
+ e_t.
$$

OCR 来源在公式 (9) 的一处把第二组系数上标打印为 $\nu$ 而不是 $y$。本条目依据周围文字和实现交叉检查，将这些项视为产出缺口系数；该规范化仍为 `needs_review`。

- **(F3) 中性名义利率恒等式**：

$$
R_t^* = r^*+\pi_t^a.
$$

- **(F4) 一般积极型政策规则**：

$$
R_t-R_t^*=\gamma(\pi_t^a-\pi^*)+\delta y_t.
$$

- **(F5) Taylor 规则**：

$$
R_t = 2+\pi_t^a+0.5(\pi_t^a-2)+0.5y_t.
$$

- **(F6) 修正 Taylor 规则**：

$$
R_t = 2+\pi_t^a+0.5(\pi_t^a-2)+1.0y_t.
$$

- **(F7) 实时测度方程**：

$$
\pi_t^a=\tilde{\pi}_t^a+x_t,
\qquad
y_t=\tilde{y}_t+z_t.
$$

- **(F8) 可实时实施的政策规则**：

$$
R_t-\tilde{R}_t^*
=\gamma(\tilde{\pi}_t^a-\pi^*)+\delta\tilde{y}_t,
\qquad
\tilde{R}_t^* \equiv r^*+\tilde{\pi}_t^a.
$$

- **(F9) 实时规则的真实数据等价表达**：

$$
R_t-R_t^*
=\gamma(\pi_t^a-\pi^*)+\delta y_t
-\big((1+\gamma)x_t+\delta z_t\big).
$$

- **(F10) 仅通胀规则**：

$$
R_t=2+\pi_t^a+0.5(\pi_t^a-2).
$$

- **(F11) 自然增长目标规则**：

$$
R_t=2+\pi_t^a+0.5\big(\pi_t^a-2+\Delta^a y_t\big),
\qquad
\Delta^a y_t \equiv y_t-y_{t-4}.
$$

Rep-MMB 实现选择原始 Taylor 规则，并用实现变量 `f` 写为：

$$
f_t = 2+\pi_t+0.5(\pi_t-2)+0.5y_t+\varepsilon^f_t.
$$

这个选定规则记录为 `implementation_cross_check` 证据，因为它来自 `.agents/skills/dynare-copilot/references/examples/US_OR03_rep.mod`，不是论文侧数学来源。

## 4. Market Clearing & Identities

该模型没有商品市场资源约束、资产市场出清方程、资本积累律、劳动市场或政府预算恒等式。它是一个三方程经验政策模型。

主要恒等式已经嵌入上面的政策和测度定义：

- 中性名义利率恒等式 (F3)；
- 实时测度恒等式 (F7)；
- (F8) 中的实时中性利率定义；
- (F11) 中的年度产出缺口变化定义。

论文报告了两个用于施加古典二分性质的限制。MinerU OCR 损坏了公式行。可读内容支持：

$$
\sum_{i=1}^{4}a_i^\pi = 1
\qquad\text{and}\qquad
\sum_{i=1}^{4} b_i^\pi + \sum_{i=1}^{4} b_i^f = 0,
$$

但这些限制在 PDF 级公式检查前标记为 `needs_review`。

## 5. Exogenous Processes

- **(F12) 产出缺口创新**：

$$
u_t \sim (0,\sigma_u^2).
$$

- **(F13) 通胀创新**：

$$
e_t \sim (0,\sigma_e^2).
$$

- **(F14) MMB 实现使用的政策规则创新**（`implementation_cross_check`）：

$$
\varepsilon^f_t \sim (0,\sigma_f^2).
$$

Rep-MMB 文件将这些冲击命名为 `u`、`e` 和 `interest_`。其冲击方差分别为 `0.771025149^2`、`1.4069906748^2` 和 `0`。这些数值仅作为实现交叉检查证据。

## 6. Steady-State Solution

由于论文系统是以百分点宏观变量表示的线性系统，稳态通过令冲击为零且变量保持常数来定义。

对于论文侧估计系统：

$$
\bar{y}
= b_0
+ \left(\sum_{i=1}^{4}b_i^\pi\right)\bar{\pi}
+ \left(\sum_{i=1}^{4}b_i^y\right)\bar{y}
+ \left(\sum_{i=1}^{4}b_i^f\right)\bar{f},
$$

$$
\bar{\pi}
= \left(\sum_{i=1}^{4}a_i^\pi\right)\bar{\pi}
+ \left(\sum_{i=0}^{4}a_i^y\right)\bar{y}.
$$

对于选定的 Taylor 规则：

$$
\bar{f}=2+\bar{\pi}^a+0.5(\bar{\pi}^a-2)+0.5\bar{y}.
$$

在论文的基准目标值 $r^*=2$ 和 $\pi^*=2$ 下，当 $\bar{y}=0$ 且 $\bar{\pi}^a=2$ 时，Taylor 规则稳态政策利率为 $\bar{R}=4$。在 Rep-MMB 实现中，即使产出方程和政策方程含有常数，也使用 `model(linear)`；因此精确的实现稳态约定在核对预期 MMB 预处理/运行时行为前为 `needs_review`。

运行时验证状态：未执行；未运行 Dynare。

## 7. Timing & Form Conventions

- **滞后结构**：产出和通胀是向后看的四阶滞后方程。产出方程使用 $\pi_t$、$y_t$ 和 $f_t$ 的滞后；通胀方程使用四阶通胀滞后以及当期和滞后产出缺口。
- **政策时点**：在模拟中，政策工具使用可得的当季信息和滞后模拟值递归设定。
- **信息时点**：实时模拟在政策决策时使用感知变量 $\tilde{\pi}_t^a$ 和 $\tilde{y}_t$；最终数据模拟使用事后值。
- **存量**：没有预定资本、债券或其他存量变量。
- **形式**：线性简约式/受限 SVAR 模型；Rep-MMB 使用 `model(linear)`。
- **不确定性标记**：`needs_review`，因为 OCR 损坏了古典二分限制行，且未打开源 PDF 正文逐式核对公式。

## 8. Variable & Parameter Reference Table

| Category | Symbol / Dynare name | Meaning | Determined by |
|---|---|---|---|
| Endogenous | $y_t$ / `y` | 产出缺口 | (F1) |
| Endogenous | $\pi_t$ / `pi` | 季度通胀 | (F2) |
| Endogenous | $f_t$ or $R_t$ / `f` | 联邦基金利率/政策工具 | (F5), implementation selected rule |
| Policy concept | $R_t^*$ | 中性名义利率 | (F3) |
| Policy concept | $\tilde{R}_t^*$ | 实时中性名义利率 | (F8) |
| Observed real-time variable | $\tilde{\pi}_t^a$ | 政策制定者的实时年度通胀测度 | (F7) |
| Observed real-time variable | $\tilde{y}_t$ | 政策制定者的实时产出缺口测度 | (F7) |
| Measurement error | $x_t$ | 年度通胀测度噪声 | (F7), (F9) |
| Measurement error | $z_t$ | 产出缺口测度噪声 | (F7), (F9) |
| Exogenous | $u_t$ / `u` | 产出缺口方程创新 | (F12) |
| Exogenous | $e_t$ / `e` | 通胀方程创新 | (F13) |
| Exogenous | $\varepsilon^f_t$ / `interest_` | MMB 实现中的政策规则冲击 | (F14) |
| Parameter | $b_0$ / `b0` | 产出方程截距 | - |
| Parameter | $b_i^\pi$ / `bpi1`-`bpi4` | 产出方程中的通胀滞后系数 | - |
| Parameter | $b_i^y$ / `by1`-`by4` | 产出方程中的产出缺口滞后系数 | - |
| Parameter | $b_i^f$ / `bf1`-`bf4` | 产出方程中的联邦基金利率滞后系数 | - |
| Parameter | $a_i^\pi$ / `api1`-`api4` | 通胀方程中的通胀滞后系数 | - |
| Parameter | $a_i^y$ / `ay0`-`ay4` | 通胀方程中的产出缺口系数 | - |
| Policy coefficient | $\gamma$ | 一般规则中的通胀响应 | - |
| Policy coefficient | $\delta$ | 一般规则中的产出缺口响应 | - |
| Policy target | $\pi^*$ | 通胀目标，Taylor 参数化中为 `2` | - |
| Policy parameter | $r^*$ | 自然实际利率，Taylor 参数化中为 `2` | - |
