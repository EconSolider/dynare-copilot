# NK_CGG99 - 推导（最优化问题 + 一阶条件）

> 状态：needs_review。本一稿档案条目以 Clarida、Gali 和 Gertler（1999）的 MinerU Markdown 为论文侧来源，并仅把 MMB `NK_CGG99_rep.mod` 作为变量覆盖和 Rep-MMB 所用混合规格的实现交叉检查。

## 1. Model Overview

- **模型**：`NK_CGG99`，基于 Clarida, Gali, and Gertler, "The Science of Monetary Policy: A New Keynesian Perspective," *Journal of Economic Literature* 37(4), 1999, DOI `10.1257/jel.37.4.1661`。
- **来源形式**：小型对数线性新凯恩斯货币政策模型，核心变量包括产出缺口、通胀、名义利率、需求扰动和成本推动扰动。
- **MMB 实现变体**：Rep-MMB 文件采用论文第 6 节带有滞后产出缺口和滞后通胀项的混合扩展，并用第 7 节中 Volcker-Greenspan 时期估计的前瞻性利率规则闭合模型。
- **主体和模块**：家庭部门通过消费 Euler 方程与产品市场出清给出对数线性 IS 关系；垄断竞争的 Calvo 定价厂商给出新凯恩斯 Phillips 曲线；央行用带利率平滑的预期通胀/产出缺口规则设定短期名义利率。
- **模型形式**：`model(linear)`。变量均为相对长期水平的偏离或缺口，因此内生变量和外生状态的稳态均为零。
- **运行验证**：本档案构建轮次未执行。

## 2. Optimization Problems

论文没有为这个紧凑政策模型完整列出原始家庭-厂商问题，而是给出总量关系并引用标准推导。因此本条目记录来源中明示的约化最优性条件，并将缺失的原始推导标为 `needs_review`。

### 2.1 代表性家庭

家庭储蓄问题在 Euler 方程对数线性化并施加产品市场出清后，给出 IS 曲线：产出缺口取决于预期未来产出缺口和事前实际利率。对 MMB 的混合变体，滞后产出也作为内生持续性项进入。

### 2.2 定价厂商

垄断竞争厂商面临 Calvo 名义刚性。将最优重设价格决策加总后得到新凯恩斯 Phillips 曲线，把通胀与产出缺口、预期未来通胀和成本推动扰动联系起来。MMB 的混合变体加入滞后通胀。

### 2.3 中央银行

中央银行以短期名义利率为政策工具。实现交叉检查显示，`NK_CGG99` 对应采用部分调整的后 1979 年估计前瞻性规则。

## 3. First-Order Conditions

**(F1) 混合 IS 曲线 / Euler 方程表示**：

```math
x_t =
\sigma\big(i_t - E_t \pi_{t+1}\big)
+ \theta x_{t-1}
+ (1-\theta)E_t x_{t+1}
+ \varepsilon^d_t
```

在论文记号中，利率弹性系数在

```math
x_t=-\varphi(i_t-E_t\pi_{t+1})+\theta x_{t-1}+(1-\theta)E_t x_{t+1}+g_t
```

中为正。MMB 实现使用 `sigma = -6.25`，因此符号约定包含在校准参数中。

**(F2) 混合新凯恩斯 Phillips 曲线 / Calvo 定价关系**：

```math
\pi_t =
\lambda x_t
+ \phi \pi_{t-1}
+ (1-\phi)\beta E_t \pi_{t+1}
+ \varepsilon^u_t
```

来源中的基准模型在 `needs_review` 意义下嵌套于此：令 $`\theta=0`$ 和 $`\phi=0`$ 可得到前瞻性基准模型，但实现中的冲击命名和持续性处理不同。

**(F3) 前瞻性目标利率规则**：

```math
i^{\ast}_t =
\bar{i}
+ \gamma_{\pi}\big(E_t\pi_{t+1}-\bar{\pi}\big)
+ \gamma_x x_t
```

论文报告的 Volcker-Greenspan 估计为 $`\gamma_{\pi}=2.15`$、$`\gamma_x=0.93`$、平滑参数 $`\rho_i=0.79`$。MMB 实现令 $`\bar{i}=0`$，并将产出系数除以 4，因为来源估计使用年化季度通胀和利率数据。

**(F4) 利率部分调整**：

```math
i_t =
\rho_i i_{t-1}
+ (1-\rho_i)i^{\ast}_t
```

合并 (F3) 与 (F4) 得到实现中的政策规则

```math
i_t =
0.79 i_{t-1}
+ (1-0.79)\left(2.15 E_t\pi_{t+1}+\frac{0.93}{4}x_t\right).
```

## 4. Market Clearing & Identities

**(F5) 产出缺口定义**：

```math
x_t \equiv y_t-z_t
```

其中 $`y_t`$ 是产出的随机组成部分，$`z_t`$ 是价格完全灵活时的自然产出水平。论文脚注推导还使用产品市场出清，把对数线性化的消费 Euler 方程改写为产出缺口形式。

名义短期利率作为政策工具时，没有单独的货币市场出清方程。中央银行内生供给货币以支持所选择的利率目标，因此 LM 方程被有意省略。

## 5. Exogenous Processes

**(F6) MMB 实现使用的冲击过程**：

```math
\varepsilon^d_t \sim \operatorname{i.i.d.}(0,\sigma_d^2),
\qquad
\varepsilon^u_t \sim \operatorname{i.i.d.}(0,\sigma_u^2)
```

来源基准模型写作 AR(1) 需求和成本推动过程，

```math
g_t=\mu g_{t-1}+\hat{g}_t,\quad u_t=\rho_u u_{t-1}+\hat{u}_t.
```

对第 6 节的混合模型，论文为简化明确将这些序列相关系数设为零；MMB 文件将冲击实现为创新 `demand_` 和 `inflation_`。

## 6. Steady-State Solution

由于 `NK_CGG99` 围绕长期值线性化，稳态为：

```math
\bar{x}=\bar{\pi}=\bar{i}=0,\qquad
\bar{\varepsilon}^d=\bar{\varepsilon}^u=0.
```

预期未来变量和滞后变量在稳态中等于同样的零值。目标利率规则在实现单位下有 $`\bar{i}=0`$。这个一稿线性档案条目不需要非线性稳态方程组或 `steady_state_model` 推导。

## 7. Timing & Form Conventions

- **时序**：$`x_{t-1}`$、$`\pi_{t-1}`$ 和 $`i_{t-1}`$ 是预定滞后变量。$`E_t x_{t+1}`$ 和 $`E_t\pi_{t+1}`$ 是一期前瞻理性预期。
- **通胀**：$`\pi_t`$ 是第 $`t`$ 期通胀，按相对长期目标/趋势的偏离度量。
- **利率**：$`i_t`$ 是短期名义利率偏离。IS 曲线中的事前实际利率缺口是 $`i_t-E_t\pi_{t+1}`$。
- **资本和存量**：这个紧凑模型没有资本存量；论文在政策分析框架中抽象掉投资和资本积累。
- **线性形式**：全部方程均为对数线性/偏离形式，对应 Dynare `model(linear)`。
- **不确定性**：论文的综述性方程到 Rep-MMB `NK_CGG99` 校准之间的精确映射标为 `needs_review`，尤其是 $`\theta`$、$`\phi`$ 和 $`\sigma`$ 的系数选择；实现注释称这些选择来自 Rotemberg-Woodford 风格的校准。

## 8. Variable & Parameter Reference Table

### 内生变量

| ASCII 名称 | 符号 | 含义 | 由哪条方程决定 |
|---|---|---|---|
| `x` | $`x_t`$ | 产出缺口 | (F1), (F5) |
| `pi` | $`\pi_t`$ | 通胀偏离 | (F2) |
| `i` | $`i_t`$ | 短期名义利率偏离 | (F3), (F4) |

### 外生冲击

| ASCII 名称 | 符号 | 含义 | 方程 |
|---|---|---|---|
| `demand_` | $`\varepsilon^d_t`$ | 需求/IS 创新 | (F6) |
| `inflation_` | $`\varepsilon^u_t`$ | 成本推动/通胀创新 | (F6) |

### 参数

| ASCII 名称 | 符号 | 含义 | 来源/交叉检查取值 |
|---|---|---|---|
| `theta` | $`\theta`$ | 混合 IS 曲线中的滞后产出权重 | MMB 实现为 0.44 |
| `sigma` | $`\sigma`$ | 实现中的实际利率系数 | MMB 实现为 -6.25；符号约定不同于论文的 $`\varphi>0`$ |
| `phi` | $`\phi`$ | 混合 Phillips 曲线中的滞后通胀权重 | MMB 实现为 0.48 |
| `lambda` | $`\lambda`$ | Phillips 曲线的产出缺口斜率 | MMB 实现为 0.0244 |
| `beta` | $`\beta`$ | 前瞻通胀项的贴现因子 | MMB 实现为 $`1/(1+0.035/4)`$ |
| `gamma_pi` | $`\gamma_{\pi}`$ | 目标利率对预期通胀的反应 | 来源表 1 为 2.15 |
| `gamma_x` | $`\gamma_x`$ | 目标利率对产出缺口的反应 | 来源估计为 0.93；MMB 使用 $`0.93/4`$ |
| `rho_i` | $`\rho_i`$ | 利率平滑 | 来源表 1 为 0.79 |

方程计数：F1-F6。运行验证：未执行。
