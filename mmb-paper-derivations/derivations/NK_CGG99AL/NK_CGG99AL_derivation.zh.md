# NK_CGG99AL - 推导（最优化问题 + 一阶条件）

> 一稿归档状态：`needs_review`。本条目以 Clarida、Gali 和 Gertler (1999) 的 MinerU Markdown 为来源。该文有意采用紧凑的线性化政策模型，而不是完整列出原始家庭和企业问题，因此只有在论文明确说明来源时才概述原始最优化细节。

## 1. Model Overview

- **模型**：`NK_CGG99AL`，基于 Clarida, Gali, and Gertler (1999), "The Science of Monetary Policy: A New Keynesian Perspective."
- **用途**：在基准新凯恩斯模型中研究货币政策设计；模型包含前瞻 IS 曲线、前瞻 Phillips 曲线、外生需求冲击和成本推动冲击，以及相机抉择或承诺下的央行政策。
- **主体与模块**：代表性家庭储蓄问题支撑 IS 关系；垄断竞争企业和 Calvo 式错期定价支撑 Phillips 曲线；央行选择短期名义利率；需求和成本推动冲击为外生过程。
- **形式**：对数线性、缩减式新凯恩斯模型。变量为相对于长期水平的偏离，或对数随机组成部分。基准模型没有资本积累。
- **核心来源线索**：基准框架和方程位于论文第 2.1 节；政策目标在第 2.2 节；相机抉择在第 3 节；承诺规则在第 4.2 节。

## 2. Optimization Problems

### 2.1 总需求背后的家庭储蓄问题

论文说明，IS 曲线来自家庭消费 Euler 方程的对数线性化，并施加消费等于扣除政府购买后的产出的产品市场条件。论文没有写出原始家庭效用函数。与这一来源说明一致的通用表示为：

$$
\max_{\{C_t,B_t\}} E_0 \sum_{t=0}^{\infty}\beta^t U(C_t) \quad\text{s.t.}\quad P_t C_t + Q_t B_t \leq B_{t-1}+Y_t^{h}-P_t T_t.
$$

这个原始问题是对论文所述 Euler 方程来源的解释，不是来源中直接打印的方程；因此在作为结构推导使用前标记为 `needs_review`。

### 2.2 企业的错期定价问题

论文描述了垄断竞争企业：当企业有机会重新定价时选择名义价格，并受到未来调价机会的 Calvo 式限制。论文没有用原始符号完整写出重定价目标。与来源一致的通用问题为：

$$
\max_{P_t^{\ast}} E_t \sum_{j=0}^{\infty}(\beta\theta)^j \Lambda_{t,t+j}\left[P_t^{\ast}Y_{t+j|t}-P_{t+j}MC_{t+j}Y_{t+j|t}\right],
$$

并受企业差异化产品需求曲线约束。这个通用重定价问题标记为 `needs_review`，因为文章只用它来引出对数线性 Phillips 曲线。

### 2.3 央行政策问题

央行选择产出缺口、通胀和名义政策利率的路径或反馈规则，以最大化二次目标：

$$
\max -\frac{1}{2}E_t\left\{\sum_{i=0}^{\infty}\beta^i\left[\alpha x_{t+i}^2+\pi_{t+i}^2\right]\right\}.
$$

在相机抉择下，央行每期重新优化，并把私人部门预期作为给定。在承诺下，央行选择状态依赖序列或规则，并承认该规则会影响预期。

## 3. First-Order Conditions

**私人部门均衡条件**

- **(F1) 产出缺口定义**：

$$
x_t \equiv y_t-z_t.
$$

- **(F2) 前瞻 IS 曲线**：

$$
x_t=-\varphi\left(i_t-E_t\pi_{t+1}\right)+E_t x_{t+1}+g_t.
$$

- **(F3) 前瞻 Phillips 曲线**：

$$
\pi_t=\lambda x_t+\beta E_t\pi_{t+1}+u_t.
$$

- **(F4) 产出需求的 Euler 方程来源表达式**：

$$
y_t-e_t=-\varphi\left(i_t-E_t\pi_{t+1}\right)+E_t\left(y_{t+1}-e_{t+1}\right).
$$

- **(F5) 由潜在产出和政府购买定义的需求冲击**：

$$
g_t=E_t\left(\Delta z_{t+1}-\Delta e_{t+1}\right).
$$

- **(F6) 总需求的前向解**：

$$
x_t=E_t\sum_{i=0}^{\infty}\left\{-\varphi\left(i_{t+i}-\pi_{t+1+i}\right)+g_{t+i}\right\}.
$$

- **(F7) 边际成本 Phillips 曲线表示**：

$$
\pi_t=\beta E_t\pi_{t+1}+\delta mc_t.
$$

- **(F8) 边际成本到产出缺口的映射**：

$$
mc_t=\kappa x_t.
$$

- **(F9) 通胀的前向解**：

$$
\pi_t=E_t\sum_{i=0}^{\infty}\beta^i\left(\lambda x_{t+i}+u_{t+i}\right).
$$

**相机抉择政策条件**

- **(F10) 静态相机抉择目标问题**：

$$
\max_{x_t,\pi_t}-\frac{1}{2}\left(\alpha x_t^2+\pi_t^2\right)+F_t \quad\text{s.t.}\quad \pi_t=\lambda x_t+f_t.
$$

- **(F11) 相机抉择最优性条件**：

$$
x_t=-\frac{\lambda}{\alpha}\pi_t.
$$

- **(F12) 相机抉择的产出缺口解**：

$$
x_t=-\lambda q u_t,\qquad q=\frac{1}{\lambda^2+\alpha(1-\beta\rho)}.
$$

- **(F13) 相机抉择的通胀解**：

$$
\pi_t=\alpha q u_t.
$$

- **(F14) 实施相机抉择的利率规则**：

$$
i_t=\gamma_\pi E_t\pi_{t+1}+\frac{1}{\varphi}g_t.
$$

- **(F15) 相机抉择下的通胀反应系数**：

$$
\gamma_\pi=1+\frac{(1-\rho)\lambda}{\rho\varphi\alpha}>1.
$$

**承诺政策条件**

- **(F16) 受限承诺的产出缺口规则**：

$$
x_t^c=-\omega u_t.
$$

- **(F17) 受限承诺的通胀解**：

$$
\pi_t^c=\frac{1-\lambda\omega}{1-\beta\rho}u_t.
$$

- **(F18) 受限承诺的权衡关系表示**：

$$
\pi_t^c=\frac{\lambda}{1-\beta\rho}x_t^c+\frac{1}{1-\beta\rho}u_t.
$$

- **(F19) 受限承诺最优性条件**：

$$
x_t^c=-\frac{\lambda}{\alpha^c}\pi_t^c,\qquad \alpha^c=\alpha(1-\beta\rho).
$$

- **(F20) 受限承诺的产出缺口解**：

$$
x_t^c=-\lambda q^c u_t,\qquad q^c=\frac{1}{\lambda^2+\alpha^c(1-\beta\rho)}.
$$

- **(F21) 受限承诺的通胀解**：

$$
\pi_t^c=\alpha^c q^c u_t.
$$

- **(F22) 实施受限承诺的利率规则**：

$$
i_t=\gamma_\pi^c E_t\pi_{t+1}+\frac{1}{\varphi}g_t.
$$

- **(F23) 受限承诺下的通胀反应系数**：

$$
\gamma_\pi^c=1+\frac{(1-\rho)\lambda}{\rho\varphi\alpha^c}>\gamma_\pi.
$$

- **(F24) 非受限承诺差分规则**：

$$
x_{t+i}-x_{t+i-1}=-\frac{\lambda}{\alpha}\pi_{t+i},\qquad i=1,2,3,\ldots.
$$

- **(F25) 非受限承诺的初始期条件**：

$$
x_t=-\frac{\lambda}{\alpha}\pi_t.
$$

- **(F26) 非受限承诺讨论中的相关利率规则**：

$$
i_t=\left(1-\frac{\lambda}{\alpha\varphi}\right)E_t\pi_{t+1}+\frac{1}{\varphi}g_t.
$$

## 4. Market Clearing & Identities

- **(F27) 用于得到 IS 曲线的产品市场条件**：

$$
Y_t=C_t+E_t^{g}.
$$

- **(F28) 政府购买的对数变换**：

$$
e_t\equiv-\log\left(1-\frac{E_t^{g}}{Y_t}\right).
$$

- **(F29) 产出分解**：

$$
y_t=x_t+z_t.
$$

论文在基准模型中抽象掉投资和资本积累。论文还把名义利率作为政策工具，因此不需要单独的货币市场均衡条件；货币供给调整以支持利率目标。

## 5. Exogenous Processes

- **(F30) 需求冲击过程**：

$$
g_t=\mu g_{t-1}+\hat{g}_t,\qquad 0\leq\mu\leq 1.
$$

- **(F31) 成本推动冲击过程**：

$$
u_t=\rho u_{t-1}+\hat{u}_t,\qquad 0\leq\rho\leq 1.
$$

- **(F32) 冲击矩**：

$$
E[\hat{g}_t]=E[\hat{u}_t]=0,\qquad Var(\hat{g}_t)=\sigma_g^2,\qquad Var(\hat{u}_t)=\sigma_u^2.
$$

MinerU OCR 中需求冲击创新的符号明显损坏，因此此处使用常规记号 `\hat{g}_t`，并标记为 `needs_review`。

## 6. Steady-State Solution

由于模型已经是对数线性的，且变量表示为相对于长期水平的偏离，因此产出缺口、通胀偏离、政策利率偏离和冲击的确定性稳态都规范化为零：

$$
\bar{x}=0,\qquad \bar{\pi}=0,\qquad \bar{i}=0,\qquad \bar{g}=0,\qquad \bar{u}=0.
$$

自然产出组成部分和实际产出随机组成部分满足：

$$
\bar{y}=\bar{z},\qquad \bar{x}=\bar{y}-\bar{z}=0.
$$

需求和成本推动 AR(1) 过程在创新均值为零时意味着零稳态扰动：

$$
\bar{g}=\mu\bar{g}=0,\qquad \bar{u}=\rho\bar{u}=0.
$$

政策目标以零通胀偏离和零产出缺口为中心。此一稿归档条目没有运行非线性稳态校准或 Dynare `steady_state_model`。

## 7. Timing & Form Conventions

- **信息时点**：预期以 `t` 期信息为条件，记作 `E_t`。
- **利率时点**：`i_t` 是 `t` 期选择的短期名义利率；IS 曲线中的实际利率项为 `i_t-E_t\pi_{t+1}`。
- **通胀时点**：`\pi_t` 是从 `t-1` 到 `t` 的通胀，表示为相对于趋势的偏离。
- **状态变量**：基准模型没有资本存量或内生预定存量变量。持久性来自 `g_t` 和 `u_t` 的外生 AR(1) 过程；非受限承诺规则引入对滞后产出缺口的依赖。
- **模型形式**：对数线性缩减式。Dynare 实现通常应使用 `model(linear)`。
- **不确定性**：(F4)、(F5)、(F7)、(F8) 和 (F32) 应在推广前做来源核对，因为文章紧凑地说明原始推导，且 OCR 存在可见符号损坏。

## 8. Variable & Parameter Reference Table

| 类别 | 符号 / ASCII 名 | 含义 | 方程引用 |
|---|---|---|---|
| 内生 | `x` / $x_t$ | 产出缺口 | (F1), (F2), (F3), (F10)-(F26), (F29) |
| 内生 | `y` / $y_t$ | 产出的随机组成部分，对数偏离 | (F1), (F4), (F27), (F29) |
| 内生 | `pi` / $\pi_t$ | 通胀偏离 | (F3), (F7), (F9)-(F26) |
| 内生 | `i` / $i_t$ | 短期名义政策利率偏离 | (F2), (F6), (F14), (F22), (F26) |
| 内生/参考 | `mc` / $mc_t$ | 实际边际成本偏离 | (F7), (F8) |
| 外生/状态 | `z` / $z_t$ | 自然产出水平，对数随机组成部分 | (F1), (F5), (F29) |
| 外生/状态 | `g` / $g_t$ | 需求冲击 | (F2), (F5), (F6), (F14), (F22), (F26), (F30) |
| 外生/状态 | `u` / $u_t$ | 成本推动冲击 | (F3), (F9), (F12), (F13), (F16)-(F21), (F31) |
| 外生创新 | `eps_g` / $\hat{g}_t$ | 需求冲击创新 | (F30), (F32) |
| 外生创新 | `eps_u` / $\hat{u}_t$ | 成本推动创新 | (F31), (F32) |
| 外生/参考 | `eg` / $E_t^g$ | 产品市场恒等式中的政府购买 | (F27), (F28) |
| 参数 | `beta` / $\beta$ | 目标函数和 Phillips 曲线中的贴现因子 | (F3), (F9), (F17)-(F23) |
| 参数 | `varphi` / $\varphi$ | 总需求利率弹性 / 跨期替代通道 | (F2), (F4), (F6), (F14), (F15), (F22), (F23), (F26) |
| 参数 | `lambda` / $\lambda$ | Phillips 曲线对产出缺口的斜率 | (F3), (F9), (F11)-(F26) |
| 参数 | `alpha` / $\alpha$ | 政策目标中产出缺口稳定的相对权重 | (F10)-(F15), (F24)-(F26) |
| 参数 | `alpha_c` / $\alpha^c$ | 受限承诺下产出缺口的有效权重 | (F19)-(F23) |
| 参数 | `rho` / $\rho$ | 成本推动冲击持久性 | (F15), (F17)-(F23), (F31) |
| 参数 | `mu` / $\mu$ | 需求冲击持久性 | (F30) |
| 参数 | `delta_mc` / $\delta$ | 边际成本 Phillips 关系中的边际成本系数 | (F7) |
| 参数 | `kappa` / $\kappa$ | 边际成本到产出缺口的弹性映射 | (F8) |
| 参数 | `omega` / $\omega$ | 受限承诺对成本推动冲击的反馈系数 | (F16), (F17) |
| 参数 | `q`, `q_c` / $q,q^c$ | 缩减式政策解系数 | (F12), (F20) |
| 参数 | `gamma_pi`, `gamma_pi_c` / $\gamma_\pi,\gamma_\pi^c$ | 利率规则中的通胀反应系数 | (F14), (F15), (F22), (F23) |
| 参数 | `sigma_g`, `sigma_u` / $\sigma_g,\sigma_u$ | 创新标准差 | (F32) |

方程数量：(F1)-(F32)。运行时验证：未执行。
