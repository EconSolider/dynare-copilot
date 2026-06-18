# US_MR07 - 一般均衡中的粘性信息

> MMB 模型 `US_MR07` 的第一遍档案推导。状态：`needs_review`。
> 未执行运行时验证。`.mod` 文件仅作为 `implementation_cross_check`
> 证据，用于核对变量、截断约定和冲击名称。

## 1. Model Overview

- **模型**：Mankiw and Reis (2007), "Sticky information in general equilibrium.", Journal of the European Economic Association 5(2-3), pp. 603-613, DOI `10.1162/jeea.2007.5.2-3.603`。
- **核心机制**：唯一刚性是粘性信息。消费者、工人和企业在设定消费、工资和价格前，会以随机频率更新信息。
- **主体与模块**：消费者选择支出，工人在分割劳动市场中设定工资，企业在垄断竞争下设定价格，生产以递减报酬技术使用劳动，货币政策遵循 Taylor 规则。
- **形式**：对数线性 / `model(linear)`。论文侧 Markdown 给出价格水平、产出、工资、生产和名义利率的五条约化均衡关系。实现交叉核对显示，`.mod` 用 30 阶滞后预期项近似无限粘性信息和式，并用 150 季超前变量代理长期产出。
- **冲击**：总生产率增长、总需求、商品加成、劳动加成和货币政策冲击。
- **公式质量**：MinerU Markdown 中五条主方程可读，但附录方程和完整算法系数定义不在该来源中。这些缺口标记为 `needs_review`。

## 2. Optimization Problems

文章说明了底层微观环境，但把详细最优化问题和均衡定义留给工作论文版本的附录。可用 MinerU Markdown 只包含期刊正文，因此本节只按论文支持的层次记录来源所述问题，并标记缺失细节。

### Consumers

家庭无限期存活，效用在消费和闲暇上可加分离且为等弹性形式，并交易债券。每期有比例 $`\delta`$ 的消费者更新信息，并用新信息集选择支出。完整生命周期问题和债券预算约束未出现在可用 Markdown 来源中（`needs_review`）。

### Workers

工人在分割市场中供给差异化劳动品种。每个工人是一个劳动品种的唯一供给者，并在垄断竞争下设定工资。每期有比例 $`\omega`$ 的工人更新信息。来源给出的工资关系记录为 (F3)；详细工人最优化问题在不可用附录中（`needs_review`）。

### Firms

企业在垄断竞争下销售差异化商品，并使用关于总劳动的递减报酬技术。每期有比例 $`\lambda`$ 的企业在设定价格前更新信息。来源给出的定价关系记录为 (F1)；详细企业定价问题在不可用附录中（`needs_review`）。

### Monetary Authority

中央银行遵循 Taylor 规则。这是政策规则，不是最优化问题。

## 3. First-Order Conditions

论文通过五条关键对数线性均衡关系展示模型，而不是从原始 FOC 展开。方程 (F1)-(F5) 保留这些来源给出的约化形式。

- **(F1) 粘性信息定价 / 总供给关系**：

```math
p_t =
\lambda \sum_{j=0}^{\infty}(1-\lambda)^j E_{t-j}\left[
p_t + \frac{\beta(w_t-p_t)+(1-\beta)y_t-a_t}{\beta+\nu(1-\beta)}
- \frac{\beta v_t}{(\nu-1)[\beta+\nu(1-\beta)]}
\right].
```

这里 $`p_t`$ 是价格水平，$`w_t-p_t`$ 是实际工资，$`y_t`$ 是产出，$`a_t`$ 是生产率，$`v_t`$ 是商品加成冲击，$`\nu`$ 是商品间替代弹性，$`\lambda`$ 是更新信息的企业比例。该式由来源给出，但它是约化关系；原始的企业 FOC 标记为 `needs_review`。

- **(F2) 粘性信息 IS 关系**：

```math
y_t =
\delta \sum_{j=0}^{\infty}(1-\delta)^j E_{t-j}\left(y_\infty^n-\theta R_t\right)
+ g_t.
```

长期均衡产出项为

```math
y_\infty^n = \lim_{i\to\infty} E_t[y_{t+i}],
```

长期实际利率在来源中写为

```math
R_t = E_t\left[\sum_{i=0}^{\infty}(i_{t+i}-\Delta p_{t+1+i})\right].
```

Markdown OCR 在长期利率符号附近不完美，但经济对象可读（精确索引记号为 `needs_review`）。

- **(F3) 粘性信息工资设定关系**：

```math
w_t =
\omega \sum_{j=0}^{\infty}(1-\omega)^j E_{t-j}\left[
p_t + \frac{\gamma(w_t-p_t)}{\gamma+\psi}
+ \frac{l_t}{\gamma+\psi}
+ \frac{\psi(y_\infty^n-\theta R_t)}{\theta(\gamma+\psi)}
- \frac{\psi\gamma_t}{(\gamma+\psi)(\gamma-1)}
\right].
```

这里 $`w_t`$ 是名义工资，$`l_t`$ 是劳动，$`\gamma_t`$ 是劳动加成冲击，$`\gamma`$ 是平均劳动替代参数，$`\psi`$ 是论文使用的 Frisch 弹性参数，$`\omega`$ 是更新信息的工人比例。

## 4. Market Clearing & Identities

- **(F4) 生产函数**：

```math
y_t = a_t + \beta l_t.
```

参数 $`\beta`$ 衡量劳动生产的递减报酬。来源所述模型没有资本积累。

- **(F5) 自然产出 / 产出缺口定义**：

Taylor 规则使用产出缺口 $`y_t-y_t^n`$。来源文本把 $`y_t^n`$ 定义为所有主体都充分注意时的产出水平，但 `.mod` 使用的闭式关系来自实现交叉核对，而不是论文侧来源：

```math
y_t^n =
\frac{1+1/\psi}{1+1/\psi+\beta/\theta-\beta}a_t
+ \frac{\beta/\theta}{1+1/\psi+\beta/\theta-\beta}g_t
+ \frac{\beta/(\gamma-1)}{1+1/\psi+\beta/\theta-\beta}\gamma_t
+ \frac{\beta/(\nu-1)}{1+1/\psi+\beta/\theta-\beta}v_t.
```

状态：`needs_review`；该表达式与实现一致，但没有直接印在可用 Markdown 来源中。

- **(F6) 产出缺口恒等式**：

```math
x_t = y_t-y_t^n.
```

- **(F7) 通胀恒等式**：

```math
\pi_t = p_t-p_{t-1}.
```

## 5. Exogenous Processes

来源说明每个冲击都服从 AR(1) 过程。`.mod` 交叉核对把生产率写成水平变量并另设生产率增长项。精确的附录层面时序应对工作论文附录核查。

- **(F8) 总需求冲击**：

```math
g_t = \rho_g g_{t-1}+e_t^g.
```

- **(F9) 总生产率水平与增长冲击**：

```math
a_t = (1+\rho_{\Delta a})a_{t-1}-\rho_{\Delta a}a_{t-2}+e_t^{\Delta a},
\qquad
\Delta a_t = a_t-a_{t-1}.
```

状态：`needs_review`；论文正文描述生产率增长冲击，而实现将其表示为生产率水平的二阶规律。

- **(F10) 货币政策扰动**：

```math
\varepsilon_t = \rho_\varepsilon \varepsilon_{t-1}+e_t^\varepsilon.
```

- **(F11) 商品加成冲击**：

```math
v_t = \rho_\nu v_{t-1}+e_t^\nu.
```

- **(F12) 劳动加成冲击**：

```math
\gamma_t = \rho_\gamma \gamma_{t-1}+e_t^\gamma.
```

- **(F13) Taylor 规则**：

```math
i_t = \varphi_y(y_t-y_t^n)+\varphi_p\Delta p_t-\varepsilon_t.
```

货币政策扰动前的负号由来源给出，并与实现一致。

## 6. Steady-State Solution

由于本档案条目对应对数线性 / `model(linear)` 表示，内生模型变量在偏离形式下的稳态为零：

```math
\bar{x}=\bar{\pi}=\bar{y}=\bar{y}^n=\bar{i}=\bar{l}=\bar{p}=\bar{w}=\bar{R}
=\bar{g}=\bar{a}=\bar{\varepsilon}=\bar{v}=\bar{\gamma}=\overline{\Delta a}=0.
```

冲击创新的均值也为零：

```math
\bar{e}^g=\bar{e}^{\Delta a}=\bar{e}^{\varepsilon}=\bar{e}^{\nu}=\bar{e}^{\gamma}=0.
```

实现中使用的有限滞后辅助预期变量，例如 $`p_j,w_j,l_j,R_j,y_j`$，$`j=1,\ldots,30`$，稳态也为零。未执行运行时验证。

## 7. Timing & Form Conventions

- **线性形式**：模型实现为 `model(linear)`；变量是相对稳态的对数偏离或线性化水平。
- **信息时序**：上次在 $`j`$ 期前更新信息的企业、消费者和工人，在设定当期行为时使用 $`E_{t-j}[\cdot]`$。
- **有限近似**：论文方程使用 $`j=0,\ldots,\infty`$ 的无限和。实现交叉核对把粘性信息和式截断到 30 阶滞后，并用 `y(+150)` 近似 $`y_\infty^n`$。
- **资本时序**：来源给出的模型中没有资本积累。
- **长期实际利率**：$`R_t`$ 是未来事前实际短期利率的预期和；OCR 来源中的精确索引记号为 `needs_review`。
- **运行时验证**：未执行；没有运行 Dynare。

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Main relation |
|---|---|---|---|
| Endogenous | `x`, $`x_t`$ | 产出缺口 | (F6) |
| Endogenous | `pi`, $`\pi_t`$ | 通胀 | (F7) |
| Endogenous | `y`, $`y_t`$ | 产出 | (F2), (F4) |
| Endogenous | `yn`, $`y_t^n`$ | 自然产出 | (F5) |
| Endogenous | `i`, $`i_t`$ | 名义利率 | (F13) |
| Endogenous | `l`, $`l_t`$ | 劳动 | (F3), (F4) |
| Endogenous | `p`, $`p_t`$ | 价格水平 | (F1) |
| Endogenous | `w`, $`w_t`$ | 名义工资 | (F3) |
| Endogenous | `R`, $`R_t`$ | 长期实际利率 | (F2) |
| Endogenous | `g`, $`g_t`$ | 总需求冲击状态 | (F8) |
| Endogenous | `a`, $`a_t`$ | 生产率水平 | (F9) |
| Endogenous | `e`, $`\varepsilon_t`$ | 货币政策扰动状态 | (F10), (F13) |
| Endogenous | `v`, $`v_t`$ | 商品加成冲击状态 | (F11) |
| Endogenous | `gam`, $`\gamma_t`$ | 劳动加成冲击状态 | (F12) |
| Endogenous | `da`, $`\Delta a_t`$ | 生产率增长 | (F9) |
| Endogenous auxiliary | `p1`-`p30`, `w1`-`w30`, `l1`-`l30`, `R1`-`R30`, `y1`-`y30` | 实现中的有限滞后预期辅助变量 | implementation_cross_check |
| Endogenous auxiliary | `y100` | 长期产出代理，实现为 `y(+150)` | implementation_cross_check |
| Exogenous | `g_e`, $`e_t^g`$ | 总需求创新 | (F8) |
| Exogenous | `a_e`, $`e_t^{\Delta a}`$ | 生产率增长创新 | (F9) |
| Exogenous | `e_e`, $`e_t^\varepsilon`$ | 货币政策创新 | (F10) |
| Exogenous | `v_e`, $`e_t^\nu`$ | 商品加成创新 | (F11) |
| Exogenous | `gam_e`, $`e_t^\gamma`$ | 劳动加成创新 | (F12) |
| Parameter | `delta`, $`\delta`$ | 消费者信息更新概率 | (F2) |
| Parameter | `lambda`, $`\lambda`$ | 企业信息更新概率 | (F1) |
| Parameter | `omega`, $`\omega`$ | 工人信息更新概率 | (F3) |
| Parameter | `beta`, $`\beta`$ | 本文符号中的劳动份额 / 生产曲率 | (F1), (F4), (F5) |
| Parameter | `phi_p`, $`\varphi_p`$ | Taylor 规则通胀系数 | (F13) |
| Parameter | `phi_y`, $`\varphi_y`$ | Taylor 规则产出缺口系数 | (F13) |
| Parameter | `mu`, $`\nu`$ | 实现命名中的平均商品替代弹性 | (F1), (F5) |
| Parameter | `theta`, $`\theta`$ | 跨期替代弹性 | (F2), (F3), (F5) |
| Parameter | `psi`, $`\psi`$ | Frisch 弹性参数 | (F3), (F5) |
| Parameter | `gamma`, $`\gamma`$ | 平均劳动替代弹性 | (F3), (F5) |
| Parameter | `rho_g`, $`\rho_g`$ | 总需求持续性 | (F8) |
| Parameter | `rho_a`, $`\rho_{\Delta a}`$ | 生产率增长持续性 | (F9) |
| Parameter | `rho_e`, $`\rho_\varepsilon`$ | 货币政策冲击持续性 | (F10) |
| Parameter | `rho_v`, $`\rho_\nu`$ | 商品加成冲击持续性 | (F11) |
| Parameter | `rho_gam`, $`\rho_\gamma`$ | 劳动加成冲击持续性 | (F12) |
