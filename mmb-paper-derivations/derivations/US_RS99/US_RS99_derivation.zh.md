# US_RS99 - 推导（最优化问题 + 一阶条件）

> MMB 模型 `US_RS99` 的有来源依据的一轮归档条目。状态：`needs_review`。未执行运行时验证。

## 1. Model Overview

- **模型**：Rudebusch and Svensson (1999), "Policy rules for inflation targeting"；MMB 模型 ID 为 `US_RS99`。
- **来源**：MinerU Markdown 位于 `raw/mmb_mineru/runs/us_rs99__policy_rules_for_inflation_targeting__d61abd68/full.md`；原始 PDF 位于 `raw/mmb_papers/Policy rules for inflation targeting   .pdf`。
- **论文元数据**：Glenn D. Rudebusch and Lars E.O. Svensson，1999，DOI `10.3386/w6512`。
- **模型类型**：小型美国宏观计量政策模型，包含后顾型 Phillips 曲线、后顾型 IS/产出缺口方程和利率反馈规则。
- **形式**：线性模型。Rep-MMB 实现使用 `model(linear)`，通胀、产出缺口和联邦基金利率变量均为去均值变量，因此确定性稳态为零。
- **`US_RS99` 表示的政策实验**：实现交叉检查显示该条目选择平滑工具规则
  \(S(\bar{\pi}_t,y_t)\)，系数为 \(g_\pi=2.34\)、\(g_y=1.03\)、\(h=0.30\)，与来源表格中的该规则条目匹配。此 `.mod` 证据仅作为 `implementation_cross_check` 使用。

## 2. Optimization Problems

该论文不是微观基础的家庭-厂商 DSGE 模型，而是在线性经验系统中评价政策规则。因此，没有可抽取的家庭、厂商、资本或市场出清最优化问题。

政策当局的基准问题被表述为二次稳定化问题。对于贴现因子 \(0<\delta<1\)，跨期目标为：

\[
\min_{\{i_{t+\tau}\}}\; E_t \sum_{\tau=0}^{\infty}\delta^\tau L_{t+\tau},
\qquad
L_t=\bar{\pi}_t^2+\lambda y_t^2+\nu(i_t-i_{t-1})^2.
\]

在主要比较中，论文还使用极限形式的无条件损失：

\[
E[L_t]=\operatorname{Var}(\bar{\pi}_t)+\lambda\operatorname{Var}(y_t)+\nu\operatorname{Var}(i_t-i_{t-1}).
\]

MMB 的 `US_RS99` 实现不会在运行时求解该 regulator 问题，而是硬编码论文结果表中的一个已优化简单平滑规则。

## 3. First-Order Conditions

本模型没有私人主体 FOC。以下编号方程是线性 MMB 实现所需的均衡与政策方程。

- **(F1) Phillips 曲线 / 通胀方程**：

\[
\pi_t =
\alpha_{\pi 1}\pi_{t-1}
+\alpha_{\pi 2}\pi_{t-2}
+\alpha_{\pi 3}\pi_{t-3}
+\alpha_{\pi 4}\pi_{t-4}
+\alpha_y y_{t-1}
+\varepsilon_t.
\]

- **(F2) IS/产出缺口方程**：

\[
y_t =
\beta_{y1}y_{t-1}
+\beta_{y2}y_{t-2}
-\beta_r(\bar{i}_{t-1}-\bar{\pi}_{t-1})
+\eta_t.
\]

- **(F3) 四季度通胀恒等式**：

\[
\bar{\pi}_t=\frac{1}{4}\left(\pi_t+\pi_{t-1}+\pi_{t-2}+\pi_{t-3}\right).
\]

- **(F4) 四季度联邦基金利率恒等式**：

\[
\bar{i}_t=\frac{1}{4}\left(i_t+i_{t-1}+i_{t-2}+i_{t-3}\right).
\]

- **(F5) MMB 选定的平滑工具规则**（`implementation_cross_check`；与来源表格匹配）：

\[
i_t = h i_{t-1}+g_\pi \bar{\pi}_t+g_y y_t,
\qquad
h=0.30,\quad g_\pi=2.34,\quad g_y=1.03.
\]

论文将一般平滑规则定义为 \(i_t=h i_{t-1}+gX_t\)，并常用限制 \(gX_t=g_\pi\bar{\pi}_t+g_y y_t\)。所选系数组合通过将 Rep-MMB `.mod` 文件与来源表格交叉检查确定。

## 4. Market Clearing & Identities

该模型是简约形式宏观计量系统，不是完整的一般均衡资源配置模型。因此，没有商品市场资源约束、资产市场出清、劳动市场、资本积累方程或政府预算约束可抽取。

MMB 实现使用的会计恒等式已经由 (F3) 和 (F4) 表示。论文的状态向量也可写为：

\[
X_t =
\begin{bmatrix}
\pi_t & \pi_{t-1} & \pi_{t-2} & \pi_{t-3} &
y_t & y_{t-1} &
i_{t-1} & i_{t-2} & i_{t-3}
\end{bmatrix}'.
\]

论文中的状态空间转移为：

\[
X_{t+1}=AX_t+B i_t+v_{t+1},
\]

其中模型冲击进入通胀和产出方程。

## 5. Exogenous Processes

- **(F6) 通胀方程扰动**：

\[
\varepsilon_t \sim \text{i.i.d.}(0,\sigma_\varepsilon^2),
\qquad
\sigma_\varepsilon=1.009.
\]

- **(F7) 产出方程扰动**：

\[
\eta_t \sim \text{i.i.d.}(0,\sigma_\eta^2),
\qquad
\sigma_\eta=0.819.
\]

论文在一般状态空间表述中允许 \(\varepsilon_t\) 与 \(\eta_t\) 之间存在协方差。MMB 实现交叉检查仅指定两个方差，没有协方差项。

## 6. Steady-State Solution

由于变量是去均值偏离，且 Rep-MMB 文件使用 `model(linear)`，确定性稳态为：

\[
\pi=\bar{\pi}=y=i=\bar{i}=0,
\qquad
\varepsilon=\eta=0.
\]

加速主义 Phillips 曲线的来源约束为：

\[
\sum_{j=1}^{4}\alpha_{\pi j}=1
\]

在零冲击且所有滞后变量为零时，方程 (F1)-(F5) 在零稳态下成立。

实现使用的参数值为：

\[
\alpha_{\pi1}=0.70,\quad
\alpha_{\pi2}=-0.10,\quad
\alpha_{\pi3}=0.28,\quad
\alpha_{\pi4}=0.12,\quad
\alpha_y=0.14,
\]

\[
\beta_{y1}=1.16,\quad
\beta_{y2}=-0.25,\quad
\beta_r=0.10.
\]

运行时验证状态：未执行；未运行 Dynare。

## 7. Timing & Form Conventions

- **时序**：MMB 实现将论文中的 \(t+1\) 方程改写为左侧当期变量、右侧滞后变量。因此论文方程 \(\pi_{t+1}\) 映射为实现变量 `pi`，并使用 `pi(-1)` 到 `pi(-4)`。
- **利率平均**： (F2) 中的 \(\bar{i}_{t-1}\) 是截至 \(t-1\) 的四季度平均，因此当前政策利率 \(i_t\) 通过滞后传导影响产出。
- **通胀平均**：\(\bar{\pi}_t\) 是四季度通胀，而 \(\pi_t\) 是按年率表示的季度通胀。两者在政策规则分析中都是相对常数通胀目标的偏离。
- **存量**：模型中没有存量变量、资本、债券或预定物理资产。
- **形式**：`model(linear)`；变量是去均值的百分点偏离，不是对数水平。
- **不确定性标记**：`needs_review`，因为方程来自 OCR Markdown，并已与 `.mod` 实现交叉检查，但未逐方程对 PDF 正文核验。

## 8. Variable & Parameter Reference Table

| Category | Symbol / Dynare name | Meaning | Determined by |
|---|---|---|---|
| Endogenous | \(\pi_t\) / `pi` | 按年率表示的季度通胀偏离 | (F1) |
| Endogenous | \(y_t\) / `y` | 产出缺口偏离 | (F2) |
| Endogenous | \(\bar{\pi}_t\) / `pibar` | 四季度通胀偏离 | (F3) |
| Endogenous | \(\bar{i}_t\) / `ibar` | 四季度平均联邦基金利率偏离 | (F4) |
| Endogenous | \(i_t\) / `i` | 联邦基金利率偏离 / 政策工具 | (F5) |
| Exogenous | \(\varepsilon_t\) / `eps` | 通胀方程创新 | (F6) |
| Exogenous | \(\eta_t\) / `eta` | 产出方程创新 | (F7) |
| Parameter | \(\alpha_{\pi1}\) / `alphapi1` | 第一阶通胀滞后系数 | - |
| Parameter | \(\alpha_{\pi2}\) / `alphapi2` | 第二阶通胀滞后系数 | - |
| Parameter | \(\alpha_{\pi3}\) / `alphapi3` | 第三阶通胀滞后系数 | - |
| Parameter | \(\alpha_{\pi4}\) / `alphapi4` | 第四阶通胀滞后系数 | - |
| Parameter | \(\alpha_y\) / `alphay` | Phillips 曲线中的产出缺口系数 | - |
| Parameter | \(\beta_{y1}\) / `betay1` | 第一阶产出缺口滞后系数 | - |
| Parameter | \(\beta_{y2}\) / `betay2` | 第二阶产出缺口滞后系数 | - |
| Parameter | \(\beta_r\) / `betar` | 实际利率传导系数 | - |
| Policy coefficient | \(h\) | 利率平滑系数，所选规则中为 `0.30` | - |
| Policy coefficient | \(g_\pi\) | 对四季度通胀的反应，所选规则中为 `2.34` | - |
| Policy coefficient | \(g_y\) | 对产出缺口的反应，所选规则中为 `1.03` | - |
| Shock scale | \(\sigma_\varepsilon\) | 通胀扰动标准误，实现中为 `1.009` | - |
| Shock scale | \(\sigma_\eta\) | 产出扰动标准误，实现中为 `0.819` | - |
