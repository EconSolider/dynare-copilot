# US_VGMP15 -- 推导（最优化问题 + 一阶条件）

> 私有模型档案一稿。状态：`needs_review`。未执行运行时验证。

## 1. Model Overview

- **模型 ID**：`US_VGMP15`。
- **来源**：Veronica Acurio Vasconez, Gael Giraud, Florent Mc Isaac, and Ngoc-Sang Pham (2015), "The effects of oil price shocks in a new-Keynesian framework with capital accumulation," *Energy Policy* 86, 844-854, DOI `10.1016/j.enpol.2015.04.016`。
- **源文件**：主要 OCR Markdown `raw/mmb_mineru/runs/us_vgmp15__the_effects_of_oil_price_shocks_in_a_new_keynesian_framework_with_capita__b2b0e207/full.md`；原始 PDF `raw/mmb_papers/The effects of oil price shocks in a new-Keynesian framework with capital accumulation.pdf`。
- **主体**：代表性家庭、最终品组合厂商、Calvo 中间品厂商、中央银行和政府。
- **核心机制**：进口石油进入家庭消费和中间品生产。模型在新凯恩斯石油冲击框架中加入资本积累和外生实际资本价格，使能源产出弹性和成本份额可以不相等。
- **经济体**：美国季度模型，使用 1984:Q1-2007:Q1 数据估计。
- **模型形式**：来源说明估计使用围绕稳态的对数线性版本，完整形式在在线附录中。本地档案没有该附录归一化文件，因此本推导记录来源正文给出的非线性/静态关系和一稿归一化均衡条件。只在附录中出现的对数线性方程标为 `needs_review`。
- **实验**：贝叶斯估计和油价冲击模拟；六类潜在冲击为实际油价、实际资本价格、政府支出、货币政策、价格加成和技术。

## 2. Optimization Problems

### 家庭

代表性家庭选择最终品消费、石油消费、劳动、资本积累和债券。来源给出的期效用为

```math
u(C_t,L_t)=\ln C_t-\frac{L_t^{1+\phi}}{1+\phi}.
```

复合消费由石油和国内最终品消费组成：

```math
C_t=\Theta_x C_{e,t}^{x}C_{q,t}^{1-x},\qquad
\Theta_x=x^{-x}(1-x)^{-(1-x)}.
```

名义预算约束为

```math
P_{e,t}C_{e,t}+P_{q,t}C_{q,t}+P_{k,t}\bigl(K_{t+1}-(1-\delta)K_t\bigr)+B_t
\leq (1+i_{t-1})B_{t-1}+W_tL_t+D_t+r_t^k P_{k,t}K_t+T_t.
```

资本积累由来源写为

```math
I_t=K_{t+1}-(1-\delta)K_t.
```

### 最终品厂商

最终品厂商购买差异化中间品并生产复合最终品：

```math
Q_t=\left(\int_0^1 Q_t(i)^{(\epsilon-1)/\epsilon}\,di\right)^{\epsilon/(\epsilon-1)}.
```

它为给定的 $`Q_t`$ 选择连续统投入 $`Q_t(i)`$ 以最小化支出。

### 中间品厂商

中间品厂商 $`i`$ 使用进口石油、劳动和资本生产：

```math
Q_t(i)=A_t E_t(i)^{\alpha_e}L_t(i)^{\alpha_l}K_t(i)^{\alpha_k},\qquad
\alpha_e,\alpha_l,\alpha_k\geq0.
```

由于规模报酬可能大于一，论文采用边际成本定价，而不是把利润最大化的一阶条件当作充分条件。条件要素需求满足来源给出的边际成本相等关系。

第二阶段是 Calvo 定价。论文说明完整定价规则推导在在线附录中；本地 MinerU Markdown 不包含该附录。因此下面的 Phillips 曲线为 `needs_review`。

### 中央银行和政府

中央银行用 Taylor 规则设定名义短期利率。政府发行债券、向家庭征税，并遵循外生实际支出过程。

## 3. First-Order Conditions

- **(F1) 家庭石油/最终品支出分配**：

```math
P_{e,t}C_{e,t}=xP_{c,t}C_t.
```

- **(F2) 家庭国内最终品支出分配**：

```math
P_{q,t}C_{q,t}=(1-x)P_{c,t}C_t.
```

- **(F3) CPI 聚合器**：

```math
P_{c,t}=P_{e,t}^{x}P_{q,t}^{1-x}.
```

- **(F4) 债券 Euler 方程，一稿归一化条件（`needs_review`）**：

```math
\frac{1}{P_{c,t}C_t}
=\beta E_t\left[\frac{1+i_t}{P_{c,t+1}C_{t+1}}\right].
```

- **(F5) 劳动供给，一稿归一化条件（`needs_review`）**：

```math
L_t^{\phi}=\frac{W_t}{P_{c,t}C_t}.
```

- **(F6) 资本 Euler / 无套利条件，一稿归一化条件（`needs_review`）**：

```math
S_{k,t}
=\beta E_t\left[\frac{C_t}{C_{t+1}}\frac{P_{c,t}}{P_{c,t+1}}
\left(r_{t+1}^{k}S_{k,t+1}+(1-\delta)S_{k,t+1}\right)\right],
\qquad S_{k,t}=\frac{P_{k,t}}{P_{q,t}}.
```

- **(F7) 最终品对品种 $`i`$ 的需求，CES 对偶蕴含**：

```math
Q_t(i)=\left(\frac{P_t(i)}{P_{q,t}}\right)^{-\epsilon}Q_t.
```

- **(F8) 最终品价格指数，CES 对偶蕴含**：

```math
P_{q,t}=\left(\int_0^1 P_t(i)^{1-\epsilon}\,di\right)^{1/(1-\epsilon)}.
```

- **(F9) 中间品厂商石油需求 / 边际成本定价**：

```math
mc_t(i)=\frac{P_{e,t}}{\alpha_e Q_t(i)/E_t(i)}.
```

- **(F10) 中间品厂商劳动需求 / 边际成本定价**：

```math
mc_t(i)=\frac{W_t}{\alpha_l Q_t(i)/L_t(i)}.
```

- **(F11) 中间品厂商资本需求 / 边际成本定价**：

```math
mc_t(i)=\frac{r_t^k P_{k,t}}{\alpha_k Q_t(i)/K_t(i)}.
```

- **(F12) Calvo 定价 / 新凯恩斯 Phillips 关系（`needs_review`）**：

```math
\hat{\Pi}_{q,t}
=\beta E_t[\hat{\Pi}_{q,t+1}]
\kappa\widehat{mc}_t+\varepsilon_{p,t}.
```

来源说明完整定价规则在在线附录中；本地条目只记录通用对数线性表示，待复核。

## 4. Market Clearing & Identities

- **(F13) 资本积累**：

```math
I_t=K_{t+1}-(1-\delta)K_t.
```

- **(F14) 国内产出生产函数**：

```math
Q_t(i)=A_t E_t(i)^{\alpha_e}L_t(i)^{\alpha_l}K_t(i)^{\alpha_k}.
```

- **(F15) 扣除进口石油成本后的实际 GDP 定义**：

```math
P_{y,t}Y_t=P_{q,t}Q_t-P_{e,t}E_t.
```

- **(F16) GDP 平减指数约定**：

```math
P_{y,t}=P_{c,t}.
```

- **(F17) 政府预算约束**：

```math
(1+i_{t-1})B_{t-1}+G_t=B_t+T_t.
```

## 5. Exogenous Processes

- **(F18) 实际油价过程**：

```math
\ln S_{e,t}=(1-\rho_{se})\ln \bar{S}_e+\rho_{se}\ln S_{e,t-1}+e_{se,t},
\qquad S_{e,t}=\frac{P_{e,t}}{P_{q,t}}.
```

- **(F19) 实际资本价格过程**：

```math
\ln S_{k,t}=(1-\rho_{sk})\ln \bar{S}_k+\rho_{sk}\ln S_{k,t-1}+e_{sk,t}.
```

- **(F20) TFP 过程**：

```math
\ln A_t=\rho_a\ln A_{t-1}+e_{a,t}.
```

- **(F21) 货币政策规则**：

```math
\frac{1+i_t}{1+\bar{i}}
=\left(\frac{\Pi_{q,t}}{\bar{\Pi}}\right)^{\phi_{\pi}}
\left(\frac{Y_t}{\bar{Y}}\right)^{\phi_y}\varepsilon_{i,t}.
```

- **(F22) 货币政策冲击过程**：

```math
\ln\varepsilon_{i,t}=\rho_i\ln\varepsilon_{i,t-1}+e_{i,t}.
```

- **(F23) 实际政府支出过程**：

```math
\ln G_{r,t}=(1-\rho_g)\ln(\omega\bar{Q})+\rho_g\ln G_{r,t-1}+\rho_{ag}e_{a,t}+e_{g,t}.
```

模拟部分还提到价格加成冲击。其精确方程只在可用来源未包含的附录中出现，状态为 `needs_review`。

## 6. Steady-State Solution

论文估计围绕稳态的对数线性版本，但本地 Markdown 不包含完整附录稳态模块。因此一稿稳态信息不完整，状态为 `needs_review`。

- 设外生均值：$`\bar{A}=1`$，$`\bar{S}_e`$ 和 $`\bar{S}_k`$ 为估计/校准的稳态实际价格，冲击 $`e_{se}=e_{sk}=e_a=e_i=e_g=0`$。
- 政府支出满足 $`\bar{G}_r=\omega\bar{Q}`$，来源校准 $`\omega=0.18`$。
- 由 (F13)，资本满足 $`\bar{I}=\delta\bar{K}`$，来源校准 $`\delta=0.025`$。
- $`\epsilon=8`$ 蕴含的稳态加成约为 $`8/7\simeq1.14`$。
- 稳态 GDP 满足 $`\bar{P}_y\bar{Y}=\bar{P}_q\bar{Q}-\bar{P}_e\bar{E}`$ 且 $`\bar{P}_y=\bar{P}_c`$。
- 家庭石油和国内最终品支出份额由 (F1)-(F3) 给出，为 $`x`$ 和 $`1-x`$。
- 估计报告两个相关参数情形：估计 $`\theta`$ 时，后验价格黏性较高，约 0.96-0.98；校准 $`\theta`$ 时，取 0.65。
- 来源校准包括 $`\beta=0.99`$、$`\delta=0.025`$、$`\omega=0.18`$ 和 $`\epsilon=8`$。

## 7. Timing & Form Conventions

- **资本时序**：论文写作 $`I_t=K_{t+1}-(1-\delta)K_t`$，因此 $`K_t`$ 是进入 $`t`$ 期租金收入的资本存量，$`K_{t+1}`$ 在 $`t`$ 期选择。
- **价格**：$`S_{e,t}=P_{e,t}/P_{q,t}`$ 和 $`S_{k,t}=P_{k,t}/P_{q,t}`$ 是外生实际相对价格。
- **通胀**：货币政策对核心通胀 $`\Pi_{q,t}`$ 作出反应。
- **GDP 平减指数**：模型设定 $`P_{y,t}=P_{c,t}`$，并将 GDP 定义为扣除进口石油成本后的国内产出。
- **形式**：估计模型为围绕稳态的对数线性模型；本一稿保留来源给出的非线性恒等式，并把缺失的对数线性附录方程标为 `needs_review`。
- **运行时验证**：未运行 Dynare。

## 8. Variable & Parameter Reference Table

| 类别 | 符号 / ASCII | 含义 | 主要方程 |
|---|---|---|---|
| 内生变量 | `C`, $`C_t`$ | 复合消费 | (F1)-(F5) |
| 内生变量 | `Ce`, $`C_{e,t}`$ | 家庭石油消费 | (F1) |
| 内生变量 | `Cq`, $`C_{q,t}`$ | 国内最终品消费 | (F2) |
| 内生变量 | `L`, $`L_t`$ | 劳动 | (F5), (F10), (F14) |
| 内生变量 | `K`, $`K_t`$ | 资本存量 | (F6), (F11), (F13), (F14) |
| 内生变量 | `I`, $`I_t`$ | 投资 | (F13) |
| 内生变量 | `B`, $`B_t`$ | 政府债券 | (F4), (F17) |
| 内生变量 | `Q`, $`Q_t`$ | 国内最终产出 | (F7), (F14), (F15) |
| 内生变量 | `Y`, $`Y_t`$ | 实际 GDP | (F15), (F21) |
| 内生变量 | `mc`, $`mc_t`$ | 边际成本 | (F9)-(F12) |
| 内生变量 | `rk`, $`r_t^k`$ | 资本实际租金率 | (F6), (F11) |
| 内生变量 | `Pc`, $`P_{c,t}`$ | CPI | (F3), (F16) |
| 内生变量 | `Pq`, $`P_{q,t}`$ | 核心/最终品价格 | (F3), (F8), (F18), (F19) |
| 内生变量 | `Py`, $`P_{y,t}`$ | GDP 平减指数 | (F15), (F16) |
| 内生变量 | `Pi_q`, $`\Pi_{q,t}`$ | 核心通胀 | (F12), (F21) |
| 内生变量 | `i`, $`i_t`$ | 名义短期利率 | (F4), (F17), (F21) |
| 内生变量 | `T`, $`T_t`$ | 税收 | (F17) |
| 内生变量 | `G_r`, $`G_{r,t}`$ | 实际政府支出 | (F23) |
| 外生/状态 | `Se`, $`S_{e,t}`$ | 实际油价 | (F18) |
| 外生/状态 | `Sk`, $`S_{k,t}`$ | 实际资本价格 | (F6), (F19) |
| 外生/状态 | `A`, $`A_t`$ | TFP | (F20) |
| 外生冲击 | `e_se` | 油价创新 | (F18) |
| 外生冲击 | `e_sk` | 资本价格创新 | (F19) |
| 外生冲击 | `e_a` | TFP 创新 | (F20), (F23) |
| 外生冲击 | `e_i` | 货币政策创新 | (F22) |
| 外生冲击 | `e_g` | 政府支出创新 | (F23) |
| 外生冲击 | `eps_p` | 价格加成创新 | (F12), `needs_review` |
| 参数 | `beta`, $`\beta`$ | 贴现因子；校准 0.99 | (F4), (F6), (F12) |
| 参数 | `delta`, $`\delta`$ | 折旧率；校准 0.025 | (F6), (F13) |
| 参数 | `omega`, $`\omega`$ | 政府产出份额；校准 0.18 | (F23) |
| 参数 | `epsilon`, $`\epsilon`$ | 替代弹性；校准 8 | (F7), (F8) |
| 参数 | `x`, $`x`$ | 家庭消费中的石油份额 | (F1)-(F3) |
| 参数 | `phi`, $`\phi`$ | Frisch 弹性倒数 | (F5) |
| 参数 | `alpha_e`, $`\alpha_e`$ | 石油产出弹性 | (F9), (F14) |
| 参数 | `alpha_l`, $`\alpha_l`$ | 劳动产出弹性 | (F10), (F14) |
| 参数 | `alpha_k`, $`\alpha_k`$ | 资本产出弹性 | (F11), (F14) |
| 参数 | `theta`, $`\theta`$ | Calvo 不重置价格概率 | (F12) |
| 参数 | `phi_pi`, $`\phi_\pi`$ | Taylor 规则通胀反应 | (F21) |
| 参数 | `phi_y`, $`\phi_y`$ | Taylor 规则产出反应 | (F21) |
| 参数 | `rho_se`, $`\rho_{se}`$ | 油价持续性 | (F18) |
| 参数 | `rho_sk`, $`\rho_{sk}`$ | 资本价格持续性 | (F19) |
| 参数 | `rho_a`, $`\rho_a`$ | TFP 持续性 | (F20) |
| 参数 | `rho_i`, $`\rho_i`$ | 货币政策冲击持续性 | (F22) |
| 参数 | `rho_g`, $`\rho_g`$ | 政府支出持续性 | (F23) |
| 参数 | `rho_ag`, $`\rho_{ag}`$ | 政府支出对 TFP 创新的反应 | (F23) |
