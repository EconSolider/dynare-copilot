# GPM6_IMF13 - 推导（受来源限制的一审稿）

> 状态：`needs_review`。索引指向的论文侧来源是 2008 年美国小型季度预测模型论文，而实现交叉检查显示 `GPM6_IMF13` 是 2013 年六区域 Global Projection Model。本文只记录当前链接来源实际支持的论文侧方程，并把模型/来源不匹配标为 `source_index_issue`。
>
> 来源：`raw/mmb_mineru/model_index.csv` 中 `GPM6_IMF13` 行；Markdown 来源 `raw/mmb_mineru/runs/gpm6_imf13_us_pm08_us_pm08fl__a_small_quarterly_projection_model_of_the_us_economy__a2e8676b/full.md`；原始 PDF `raw/mmb_papers/A small quarterly projection model of the US economy.pdf`；MinerU run `a2e8676b-943b-4810-bcb5-d716951a7fa4`。未发现可选 appendix normalization。实现交叉检查：`.agents/skills/dynare-copilot/references/examples/GPM6_IMF13_rep.mod`。

## 1. Model Overview

- **归档模型 ID**：`GPM6_IMF13`。
- **索引论文标题**："A small quarterly projection model of the US economy"。
- **索引作者/年份/DOI**：Carabenciov, Freedman, Garcia-Saltos, Laxton, Kamenik, and Manchev；索引行为 2013；DOI `10.5089/9781451871364.001`。
- **来源标题问题**：链接的 Markdown 标题页为 "A Small Quarterly Projection Model of the US Economy"，prepared by Ioan Carabenciov, Igor Ermolaev, Charles Freedman, Michel Juillard, Ondra Kamenik, Dmitry Korshunov, and Douglas Laxton，December 2008。同一来源也被分配给 `US_PM08` 和 `US_PM08fl`。
- **实现交叉检查**：本地 `.mod` 把 `GPM6_IMF13` 描述为 "GPM6 - The Global Projection Model with 6 Regions"，区域为 `EA6`、`EU`、`JA`、`LA6`、`RC6`、`US`。这些六区域方程并不是链接 Markdown 中的论文侧来源证据。
- **当前链接论文支持的模型族**：美国经济的半结构小型季度预测模型，包含产出、失业、通胀、政策利率、潜在产出、NAIRU、均衡实际利率，以及可选的银行贷款收紧变量 `BLT`。
- **形式**：带前瞻项和持久冲击的线性缺口/偏离系统。按 Dynare 术语接近 `model(linear)` 风格的半结构模型，虽然已检查的实现文件使用普通 `model;` 块。

## 2. Optimization Problems

链接的论文侧来源没有给出家庭、企业、银行或财政部门的显式最优化问题。该模型由行为方程、恒等式、随机趋势过程和估计的政策/金融方程组成。因此本节不记录目标函数或约束。

`needs_review`：修正后的 2013 年 GPM6 论文来源可能包含当前 2008 年美国论文中没有的多国结构或推导细节。

## 3. First-Order Conditions

由于链接来源是半结构模型，以下是行为/均衡方程，而不是由显式最优化推出的 FOC。编号连续保留，便于归档和后续 `.mod` 核对。

- **(F1) 潜在产出水平**：

```math
\overline{Y}_t = \overline{Y}_{t-1} + \frac{g^{\overline{Y}}_t}{4} + \varepsilon^{\overline{Y}}_t
```

- **(F2) 潜在产出增长过程**：

```math
g^{\overline{Y}}_t = \tau g^{\overline{Y},ss} + (1-\tau)g^{\overline{Y}}_{t-1} + \varepsilon^{g^{\overline{Y}}}_t
```

- **(F3) NAIRU 水平**：

```math
\overline{U}_t = \overline{U}_{t-1} + g^{\overline{U}}_t + \varepsilon^{\overline{U}}_t
```

- **(F4) NAIRU 增长过程**：

```math
g^{\overline{U}}_t = (1-\alpha_3)g^{\overline{U}}_{t-1} + \varepsilon^{g^{\overline{U}}}_t
```

- **(F5) 基准模型产出缺口方程**：

```math
y_t = \beta_1 y_{t-1} + \beta_2 y_{t+1} - \beta_3 rrgap_{t-1} + \varepsilon^y_t
```

- **(F6) 通胀方程**：

```math
\pi_t = \lambda_1 \pi4_{t+4} + (1-\lambda_1)\pi4_{t-1} + \lambda_2 y_{t-1} - \varepsilon^\pi_t
```

- **(F7) Taylor 型政策利率方程**：

```math
rs_t = (1-\gamma_1)\left[\overline{rr}_t + \pi4_{t+3}
+ \gamma_2\left(\pi4_{t+3}-\pi^{tar}\right) + \gamma_4 y_t\right]
+ \gamma_1 rs_{t-1} + \varepsilon^{rs}_t
```

- **(F8) 动态 Okun 方程**：

```math
u_t = \alpha_1 u_{t-1} + \alpha_2 y_t + \varepsilon^u_t
```

- **(F9) 金融联动扩展中的银行贷款收紧方程**：

```math
BLT_t = \overline{BLT}_t - \kappa y_{t+4} + \varepsilon^{BLT}_t
```

- **(F10) 含金融联动的产出缺口方程**：

```math
y_t = \beta_1 y_{t-1} + \beta_2 y_{t+1} - \beta_3 rrgap_{t-1}
- \theta\eta_t + \varepsilon^y_t
```

`needs_review`：(F9)-(F10) 对美国金融联动扩展有来源支持。它们在六区域 `.mod` 中的逐国和跨境使用只属于实现侧证据，直到链接到修正后的 GPM6 论文来源。

## 4. Market Clearing & Identities

- **(F11) 实际利率定义**：

```math
rr_t = rs_t - \pi_{t+1}
```

- **(F12) 实际利率缺口**：

```math
rrgap_t = rr_t - \overline{rr}_t
```

- **(F13) 银行贷款收紧的分布滞后项**：

```math
\eta_t = 0.04\varepsilon^{BLT}_{t-1}
+ 0.08\varepsilon^{BLT}_{t-2}
+ 0.12\varepsilon^{BLT}_{t-3}
+ 0.16\varepsilon^{BLT}_{t-4}
+ 0.20\varepsilon^{BLT}_{t-5}
+ 0.16\varepsilon^{BLT}_{t-6}
+ 0.12\varepsilon^{BLT}_{t-7}
+ 0.08\varepsilon^{BLT}_{t-8}
+ 0.04\varepsilon^{BLT}_{t-9}
```

- **(F14) 来源中说明的测度定义**：

```math
y_t = Y_t-\overline{Y}_t,\qquad
u_t = \overline{U}_t-U_t,\qquad
\pi_t = 400\Delta\log(CPI_t),\qquad
\pi4_t = 100\left[\log(CPI_t)-\log(CPI_{t-4})\right]
```

已检查的实现把恒等式推广到六个区域：产出缺口为 `LGDP_i-LGDP_BAR_i`，实际利率为 `RS_i-PIE_i(+1)`，四季度平均通胀、实际有效汇率测度和外国活动因子等。这些只记录为 `implementation_cross_check`。

## 5. Exogenous Processes

- **(F15) 均衡实际利率**：

```math
\overline{rr}_t = \rho\overline{rr}^{ss} + (1-\rho)\overline{rr}_{t-1} + \varepsilon^{\overline{rr}}_t
```

- **(F16) 均衡 BLT 随机游走**：

```math
\overline{BLT}_t = \overline{BLT}_{t-1} + \varepsilon^{\overline{BLT}}_t
```

来源还估计了潜在产出水平和增长、NAIRU 水平和增长、产出、通胀、失业、政策利率、均衡实际利率、BLT 与均衡 BLT 的冲击。金融联动模型报告了两类交叉相关：潜在产出增长冲击与产出缺口冲击正相关，潜在产出水平冲击与通胀冲击正相关。精确协方差矩阵实现保留为 `needs_review`。

## 6. Steady-State Solution

论文侧来源是线性化/缺口形式的预测模型，因此自然稳态设定为缺口变量和创新为零，并由潜在过程锚定趋势水平：

1. 所有冲击设为零。
2. 设 $`y=0`$、$`u=0`$、$`rrgap=0`$、$`\eta=0`$。
3. 设 $`\pi4=\pi=\pi^{tar}`$，且 $`rs=\overline{rr}^{ss}+\pi^{tar}`$。
4. 设 $`g^{\overline{Y}}=g^{\overline{Y},ss}`$，并让 $`\overline{Y}`$ 留在其随机趋势上。
5. 设 $`g^{\overline{U}}=0`$，在没有水平冲击时 $`\overline{U}`$ 保持常数。
6. 在金融联动块中设 $`BLT=\overline{BLT}`$。

实现交叉检查：六区域 `.mod` 在 `steady_state_model` 中对各区域 CPI 水平、GDP 趋势、汇率水平、BLT 水平、通胀目标、产出缺口和冲击给出显式赋值。这些值是实现侧校准，不是链接 Markdown 的论文侧推导证据。

## 7. Timing & Form Conventions

- **形式**：线性半结构预测系统，变量以利率、对数水平、缺口和趋势偏离表示。
- **预期/时序**：产出和通胀方程使用超前项（$`y_{t+1}`$、$`\pi4_{t+4}`$）；货币政策响应三季度后的预期同比通胀（$`\pi4_{t+3}`$）；BLT 响应四季度后的预期产出缺口（$`y_{t+4}`$）。
- **实际利率时序**：实际利率使用当期名义利率减下一季度通胀，$`rr_t=rs_t-\pi_{t+1}`$。
- **金融滞后时序**：BLT 冲击通过九季度驼峰形分布滞后进入产出。
- **无资本存量时序**：论文侧模型没有资本积累或家庭/企业存量变量时序。
- **仅来自实现的六区域时序**：`.mod` 使用区域贸易/汇率恒等式、长期实际利率加权平均、外国活动因子和溢出残差。这些都需要论文侧确认。

## 8. Variable & Parameter Reference Table

| 类别 | 符号 / ASCII 名 | 含义 | 主要方程 |
|---|---|---|---|
| 内生 | `Y`, `LGDP` | 100 倍实际 GDP 对数 / GDP 对数水平 | (F14) |
| 内生 | `Y_BAR`, `LGDP_BAR` | 潜在产出 / 趋势 GDP | (F1) |
| 内生 | `g_Y_BAR`, `G` | 潜在产出增长 | (F2) |
| 内生 | `y`, `Y_US` | 产出缺口 | (F5), (F10), (F14) |
| 内生 | `U`, `UNR` | 失业率 | (F14) |
| 内生 | `U_BAR`, `UNR_BAR` | NAIRU | (F3) |
| 内生 | `g_U_BAR`, `UNR_G` | NAIRU 漂移 | (F4) |
| 内生 | `u`, `UNR_GAP` | 失业缺口 | (F8), (F14) |
| 内生 | `pi`, `PIE` | 季度年化通胀 | (F6), (F14) |
| 内生 | `pi4`, `PIE4` | 同比通胀 | (F6), (F7), (F14) |
| 内生 | `rs`, `RS` | 短期名义政策利率 | (F7) |
| 内生 | `rr`, `RR` | 实际利率 | (F11) |
| 内生 | `rr_bar`, `RR_BAR` | 均衡实际利率 | (F15) |
| 内生 | `rrgap`, `LRR_GAP` | 实际利率缺口 | (F12) |
| 内生 | `BLT` | 银行贷款收紧 | (F9) |
| 内生 | `BLT_BAR` | 均衡 BLT | (F16) |
| 内生 | `eta`, `E2` | BLT 分布滞后影响 | (F13) |
| 外生 | `eps_Y_BAR`, `RES_LGDP_BAR` | 潜在产出水平冲击 | (F1) |
| 外生 | `eps_g_Y_BAR`, `RES_G` | 潜在产出增长冲击 | (F2) |
| 外生 | `eps_U_BAR`, `RES_UNR_BAR` | NAIRU 水平冲击 | (F3) |
| 外生 | `eps_g_U_BAR`, `RES_UNR_G` | NAIRU 增长冲击 | (F4) |
| 外生 | `eps_y`, `RES_Y` | 产出缺口冲击 | (F5), (F10) |
| 外生 | `eps_pi`, `RES_PIE` | 通胀冲击 | (F6) |
| 外生 | `eps_rs`, `RES_RS` | 政策利率冲击 | (F7) |
| 外生 | `eps_rr_bar`, `RES_RR_BAR` | 均衡实际利率冲击 | (F15) |
| 外生 | `eps_BLT`, `RES_BLT` | BLT 冲击 | (F9), (F13) |
| 外生 | `eps_BLT_BAR`, `RES_BLT_BAR` | 均衡 BLT 冲击 | (F16) |
| 参数 | `alpha1`, `alpha2`, `alpha3` | 失业/NAIRU 动态 | (F4), (F8) |
| 参数 | `beta1`, `beta2`, `beta3` | 产出缺口动态和实际利率响应 | (F5), (F10) |
| 参数 | `lambda1`, `lambda2` | 通胀预期和缺口响应 | (F6) |
| 参数 | `gamma1`, `gamma2`, `gamma4` | 政策平滑和反应系数 | (F7) |
| 参数 | `rho`, `tau` | 均衡利率和趋势增长持久性 | (F2), (F15) |
| 参数 | `kappa`, `theta` | BLT 响应和产出影响 | (F9), (F10), (F13) |
| 参数 | `pi_tar` | 通胀目标 | (F7) |

`implementation_cross_check`：`GPM6_IMF13_rep.mod` 的变量列表把单国块扩展到六个区域，并加入汇率水平/缺口（`LZ`, `REER_M`, `REER_T`）、外国活动（`FACT`）、长期实际利率（`LRR`）、贸易/溢出权重、区域政策目标和大量区域残差。由于链接论文不是六区域 GPM6 论文，这些细节仍为 `needs_review`。
