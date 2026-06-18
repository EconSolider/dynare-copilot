# G3_CW03 -- 推导（模型方程与第一轮来源抽取）

> 归档状态：`needs_review`。本第一轮推导来自 Coenen and Wieland (2003/2002 工作论文版本) 的 MinerU Markdown。未执行 Dynare 运行验证。

## 1. Model Overview

- **模型**：`G3_CW03`，一个关于美国、欧元区和日本的三国半结构理性预期模型。
- **来源**：Gunter Coenen and Volker Wieland, "Inflation dynamics and international linkages: A model of the United States, the Euro Area and Japan", ECB Working Paper Series No. 181, September 2002；索引年份 2003；DOI `10.17016/ifdp.2002.0745`。
- **来源文件**：`raw/mmb_mineru/runs/g3_cw03__inflation_dynamics_and_international_linkages_a_model_of_the_united_stat__b76bbb9e/full.md`；原始 PDF `raw/mmb_papers/Inflation dynamics and international linkages- A model of the United States, the Euro Area and Japan.pdf`。
- **形式**：线性理性预期宏观计量模型（实现交叉检查中为 `model(linear)`）。变量是缺口、利率或相对目标/稳态的偏离。
- **地区**：欧元区 (`eu`)、日本 (`ja`)、美国 (`us`)。
- **核心模块**：交错合约工资/价格模块、总需求产出缺口模块、货币政策规则、期限结构、长期实际利率定义、贸易加权实际汇率以及双边未抛补利率平价。
- **国家特定供给侧**：欧元区和日本使用 Taylor-style 固定期限合约；美国在最终模型中使用 Fuhrer-Moore 相对实际工资合约。

## 2. Optimization Problems

该论文没有为完整三国模型给出完整 DSGE 最优化问题。来源明确说明需求侧是半结构的，并对未来利率、通胀和汇率采用理性预期，同时优先考虑经验拟合。

### 2.1 交错名义合约

供给侧方程由重叠名义合约提供动机。对于 Taylor-style 合约，工人或定价者在选择当期名义合约工资/价格时，会参考合约期内预期价格水平和预期产出缺口：

```math
x_t = E_t\left[\sum_{i=0}^{\eta(x)} f_i p_{t+i} + \gamma \sum_{i=0}^{\eta(x)} f_i q_{t+i}\right] + \sigma_{\epsilon_x}\epsilon_{x,t}.
```

对于 Fuhrer-Moore-style 合约，工资设定者将隐含实际工资与重叠实际工资合约比较：

```math
x_t - p_t = E_t\left[\sum_{i=0}^{\eta(x)} f_i v_{t+i} + \gamma \sum_{i=0}^{\eta(x)} f_i q_{t+i}\right] + \sigma_{\epsilon_x}\epsilon_{x,t}.
```

### 2.2 总需求与政策

来源中的需求侧不是从显式家庭-企业最优化问题推出的。它是估计的开放经济总需求方程，包含滞后产出缺口、滞后长期实际利率和贸易加权实际汇率。货币政策由估计的利率规则给定。

## 3. First-Order Conditions

以下编号方程是归档草稿使用的均衡/动态条件。严格来说，它们并不全是一阶条件；来源结合了重叠合约条件、估计行为方程、恒等式和套利条件。

### 3.1 通用供给侧合约方程

- **(F1) Taylor 合约价格/工资聚合式**：

```math
p_t = \sum_{i=0}^{\eta(x)} f_i x_{t-i}, \qquad \sum_{i=0}^{\eta(x)} f_i = 1.
```

- **(F2) Taylor 合约工资/价格设定**：

```math
x_t = E_t\left[\sum_{i=0}^{\eta(x)} f_i p_{t+i} + \gamma\sum_{i=0}^{\eta(x)} f_i q_{t+i}\right] + \sigma_{\epsilon_x}\epsilon_{x,t}.
```

- **(F3) Fuhrer-Moore 实际合约工资设定**：

```math
x_t - p_t = E_t\left[\sum_{i=0}^{\eta(x)} f_i v_{t+i} + \gamma\sum_{i=0}^{\eta(x)} f_i q_{t+i}\right] + \sigma_{\epsilon_x}\epsilon_{x,t}.
```

- **(F4) Fuhrer-Moore 重叠实际工资指数**：

```math
v_t = \sum_{i=0}^{\eta(x)} f_i\left(x_{t-i}-p_{t-i}\right).
```

### 3.2 `G3_CW03` 使用的国家层面线性化供给方程

在 MMB 实现中，最大合约期限为四个季度。下列方程在适用时使用国家后缀 `j \in \{eu, ja, us\}`。

- **(F5) 欧元区/日本的 Taylor-style 合约方程**：

```math
cwp_{j,t} =
(f_{1,j}+f_{2,j}+f_{3,j})\pi1_{j,t+1}
+(f_{2,j}+f_{3,j})\pi1_{j,t+2}
+f_{3,j}\pi1_{j,t+3}
+\gamma_j\sum_{i=0}^{3} f_{i,j} q_{j,t+i}
+\sigma_{e\_cw,j}e\_cw_{j,t}.
```

- **(F6) 欧元区/日本的 Taylor-style 季度通胀恒等式**：

```math
\pi1_{j,t} =
\frac{f_{0,j}cwp_{j,t}+f_{1,j}cwp_{j,t-1}+f_{2,j}cwp_{j,t-2}+f_{3,j}cwp_{j,t-3}
-(f_{2,j}+f_{3,j})\pi1_{j,t-1}-f_{3,j}\pi1_{j,t-2}}
{f_{1,j}+f_{2,j}+f_{3,j}}.
```

- **(F7) 美国的 Fuhrer-Moore 合约方程**：

```math
cwp_{us,t} =
f_{0,us}index_{us,t}+f_{1,us}index_{us,t+1}+f_{2,us}index_{us,t+2}+f_{3,us}index_{us,t+3}
+\gamma_{us}\sum_{i=0}^{3} f_{i,us} q_{us,t+i}
+\sigma_{e\_cw,us}e\_cw_{us,t}.
```

- **(F8) 美国的 Fuhrer-Moore 合约指数**：

```math
index_{us,t}=f_{0,us}cwp_{us,t}+f_{1,us}cwp_{us,t-1}+f_{2,us}cwp_{us,t-2}+f_{3,us}cwp_{us,t-3}.
```

- **(F9) 美国季度通胀恒等式**：

```math
\pi1_{us,t} =
\frac{f_{0,us}cwp_{us,t}+f_{1,us}cwp_{us,t-1}+f_{2,us}cwp_{us,t-2}+f_{3,us}cwp_{us,t-3}
-(f_{2,us}+f_{3,us})\pi1_{us,t-1}-f_{3,us}\pi1_{us,t-2}}
{f_{1,us}+f_{2,us}+f_{3,us}}.
```

## 4. Market Clearing & Identities

- **(F10) 四季度通胀**：

```math
\pi4_{j,t}=\pi1_{j,t}+\pi1_{j,t-1}+\pi1_{j,t-2}+\pi1_{j,t-3}.
```

- **(F11) 总需求/产出缺口动态**：

```math
q_{j,t}=\delta_{1,j}q_{j,t-1}+\delta_{2,j}q_{j,t-2}+\delta_{3,j}q_{j,t-3}
+\delta_{4,j}(rl_{j,t-1}-\bar{r}_{l,j})
+\delta_{5,j}reer_{j,t}
+\sigma_{e\_d,j}e\_d_{j,t}.
```

对于日本，来源和实现均将第二、第三个产出缺口滞后系数设为零。

- **(F12) 短期名义利率规则**：

```math
is_{j,t}=(1-\rho_j)(\bar{r}_{l,j}+\pi4_{j,t})
+\rho_j is_{j,t-1}
+\alpha_j(\pi4_{j,t}-\pi^{\ast}_{j})
+\beta_j q_{j,t}.
```

来源的一般规则还允许预测期、高阶利率平滑和货币政策冲击。实现交叉检查使用当期年度通胀项，且模型方程中没有启用政策冲击项。

- **(F13) 8 季度期限的长期名义利率**：

```math
il_{j,t}=\frac{1}{8}\sum_{h=0}^{7}is_{j,t+h}, \qquad j\in\{eu,us\}.
```

- **(F14) 日本 12 季度期限的长期名义利率**：

```math
il_{ja,t}=\frac{1}{12}\sum_{h=0}^{11}is_{ja,t+h}.
```

- **(F15) 8 季度期限的长期实际利率**：

```math
rl_{j,t}=il_{j,t}-\frac{1}{2}\sum_{h=1}^{8}\pi1_{j,t+h}, \qquad j\in\{eu,us\}.
```

- **(F16) 日本 12 季度期限的长期实际利率**：

```math
rl_{ja,t}=il_{ja,t}-\frac{1}{3}\sum_{h=1}^{12}\pi1_{ja,t+h}.
```

- **(F17) 欧元区贸易加权实际汇率**：

```math
reer_{eu,t}=w_{eu,ja}rer_{euja,t}+w_{eu,us}rer_{euus,t}.
```

- **(F18) 日本贸易加权实际汇率**：

```math
reer_{ja,t}=-w_{ja,eu}rer_{euja,t}+w_{ja,us}rer_{jaus,t}.
```

- **(F19) 美国贸易加权实际汇率**：

```math
reer_{us,t}=-w_{us,eu}rer_{euus,t}-w_{us,ja}rer_{jaus,t}.
```

- **(F20) 欧元区/日本双边实际汇率平价**：

```math
rer_{euja,t}=rer_{euja,t+1}+4\pi1_{eu,t+1}-4\pi1_{ja,t+1}-is_{eu,t}+is_{ja,t}.
```

- **(F21) 欧元区/美国双边实际汇率平价**：

```math
rer_{euus,t}=rer_{euus,t+1}+4\pi1_{eu,t+1}-4\pi1_{us,t+1}-is_{eu,t}+is_{us,t}.
```

- **(F22) 日本/美国三角实际汇率恒等式**：

```math
rer_{jaus,t}=rer_{euus,t}-rer_{euja,t}.
```

- **(F23) 常数单位过程**：

```math
one_t=one_{t-1}.
```

## 5. Exogenous Processes

- **(F24) 结构创新**：

```math
e\_d_{j,t},\ e\_cw_{j,t}\ \text{are serially uncorrelated innovations with zero mean,}
```

并在需求方程和合约方程中使用国家特定尺度参数。来源的一般政策规则包含 $`\sigma_{\epsilon_p}\epsilon_{p,t}`$；MMB 实现声明了 `interest_`，但没有在活动模型方程中包含它。

## 6. Steady-State Solution

由于 `G3_CW03` 是缺口、利率和偏离量构成的线性模型，确定性稳态通过归一化给出，而不是由非线性家庭和企业条件求解。

1. 将产出缺口设为零：

```math
\bar{q}_{eu}=\bar{q}_{ja}=\bar{q}_{us}=0.
```

2. 将合约工资/价格偏离、季度通胀偏离、四季度通胀偏离和合约指数设为零：

```math
\bar{cwp}_j=\bar{\pi1}_j=\bar{\pi4}_j=0,\qquad \bar{index}_{us}=0.
```

3. 将实际汇率和有效实际汇率设为零：

```math
\bar{rer}_{euja}=\bar{rer}_{euus}=\bar{rer}_{jaus}=0,\qquad \bar{reer}_j=0.
```

4. 设置单位常数：

```math
\bar{one}=1.
```

5. 根据需求截距归一化计算各国均衡长期实际利率：

```math
\bar{r}_{l,j}=-\frac{\delta_{0,j}}{\delta_{4,j}}.
```

在实现交叉检查中，`delta0_j = 0`，因此所有三个国家的 $`\bar{r}_{l,j}=0`$。

6. 在偏离形式中将政策目标设为零：

```math
\pi^{\ast}_j=0.
```

7. 在稳态中，`is_j`、`il_j` 和 `rl_j` 等于由政策规则、期限结构和实际利率定义隐含的归一化值。在实现的零通胀目标和零均衡长期实际利率下，这些利率在模型单位中为零。

## 7. Timing & Form Conventions

- **模型形式**：`model(linear)`；所有方程应解释为缺口/利率/偏离之间的线性关系，而非非线性水平变量。
- **预期时点**：$`\pi1_{j,t+h}`$、$`is_{j,t+h}`$ 和 $`rer_{i,t+1}`$ 等前瞻项在来源中是理性预期预测。
- **产出动态**：需求响应滞后产出缺口和滞后长期实际利率缺口，因此货币政策存在传导滞后。
- **期限结构时点**：长期利率是未来短期利率预期的平均。欧元区和美国模块使用 8 季度期限；日本使用 12 季度期限。
- **汇率符号约定**：来源中的双边实际汇率以本国兑外国定义；实现交叉检查使用 `rer_euja`、`rer_euus` 和 `rer_jaus`，符号约定嵌入 (F17)-(F22)。
- **存量变量**：该半结构模型中没有物质资本或净值存量变量。
- **运行验证**：未执行。

## 8. Variable & Parameter Reference Table

### 内生变量

| 类别 | 符号 / ASCII 名称 | 含义 | 主要决定方程 |
|---|---|---|---|
| 内生 | `q_eu`, `q_ja`, `q_us` | 产出缺口 | (F11) |
| 内生 | `cwp_eu`, `cwp_ja` | Taylor-style 合约工资/价格项 | (F5) |
| 内生 | `cwp_us` | Fuhrer-Moore 合约工资/价格项 | (F7) |
| 内生 | `index_us` | Fuhrer-Moore 合约指数 | (F8) |
| 内生 | `pi1_eu`, `pi1_ja` | 季度通胀 | (F6) |
| 内生 | `pi1_us` | 美国季度通胀 | (F9) |
| 内生 | `pi4_eu`, `pi4_ja`, `pi4_us` | 四季度通胀 | (F10) |
| 内生 | `is_eu`, `is_ja`, `is_us` | 短期名义利率 | (F12) |
| 内生 | `il_eu`, `il_us` | 8 季度长期名义利率 | (F13) |
| 内生 | `il_ja` | 12 季度长期名义利率 | (F14) |
| 内生 | `rl_eu`, `rl_us` | 8 季度长期实际利率 | (F15) |
| 内生 | `rl_ja` | 12 季度长期实际利率 | (F16) |
| 内生 | `reer_eu`, `reer_ja`, `reer_us` | 贸易加权实际汇率 | (F17)-(F19) |
| 内生 | `rer_euja`, `rer_euus`, `rer_jaus` | 双边实际汇率 | (F20)-(F22) |
| 内生 | `one` | 常数单位过程 | (F23) |

### 外生冲击

| 类别 | ASCII 名称 | 含义 | 主要方程 |
|---|---|---|---|
| 外生 | `e_d_eu`, `e_d_ja`, `e_d_us` | 总需求创新 | (F11), (F24) |
| 外生 | `e_cw_eu`, `e_cw_ja`, `e_cw_us` | 合约工资/价格创新 | (F5), (F7), (F24) |
| 外生 | `interest_` | 实现交叉检查中声明的政策冲击；未在模型方程中启用 | needs_review |

### 参数

| 类别 | ASCII 名称 | 含义 |
|---|---|---|
| 参数 | `f0_j`, `f1_j`, `f2_j`, `f3_j` | 各国合约权重 |
| 参数 | `gamma_j` | 合约对产出缺口的敏感度 |
| 参数 | `sigma_e_cw_j` | 合约冲击尺度 |
| 参数 | `delta0_j`, `delta1_j`, `delta2_j`, `delta3_j`, `delta4_j`, `delta5_j` | 总需求截距和系数 |
| 参数 | `sigma_e_d_j` | 需求冲击尺度 |
| 参数 | `rho_j` | 利率平滑系数 |
| 参数 | `alpha_j` | 政策规则中的通胀响应 |
| 参数 | `beta_j` | 政策规则中的产出缺口响应 |
| 参数 | `pitarget_j` | 偏离单位中的通胀目标 |
| 参数 | `rlbar_j` | 均衡长期实际利率 |
| 参数 | `w_euja`, `w_euus`, `w_jaeu`, `w_jaus`, `w_useu`, `w_usja` | 有效实际汇率中的双边贸易权重 |

第一轮方程数量：(F1)-(F24)。公式质量仍为 `needs_review`，因为来源的通用方程、表格方程和 MMB 实现对政策冲击、国家后缀和合约模块使用了略有差异的归一化。
