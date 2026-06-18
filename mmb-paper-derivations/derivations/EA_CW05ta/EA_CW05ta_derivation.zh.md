# EA_CW05ta -- 推导（Taylor 名义工资合约）

> `EA_CW05ta` 的第一轮模型档案推导。状态：`needs_review`。
> 未进行运行时验证。未读取原始 PDF 正文；仅检查 PDF 路径存在并记录来源。

来源：Coenen and Wieland (2005), "A small estimated euro area model with rational expectations and nominal rigidities," European Economic Review 49(5), 1081-1104, DOI `10.1016/j.euroecorev.2003.05.001`。

## 1. 模型概述

- **模型**：一个小型估计欧元区模型，包含理性预期、重叠名义工资合约、总需求方程、期限结构模块和 Taylor 型政策规则。
- **MMB 变体**：`EA_CW05ta`，即 Taylor 名义工资合约版本。实现交叉检查文件说明，兄弟版本 Fuhrer-Moore 相对实际工资合约模型是另一个变体。
- **经济体**：欧元区总量数据；模型用于政策规则模拟以及通胀-产出波动权衡分析。
- **主体/模块**：工资制定者谈判重叠合约；总需求由经验 IS 方程给出；中央银行设定短期名义利率；金融市场把预期短期利率映射为长期名义利率和长期事前实际利率。
- **形式**：线性理性预期模型，MMB 示例中实现为 `model(linear)`。变量是缺口或利率变量，不是家庭效用或生产的水平变量。
- **来源质量**：MinerU Markdown 的题名和作者与索引行匹配，但存在轻微 OCR 噪声（`Gunter` vs. Guenther/Gunther；`in1ation`, `2t`, `di@erent`）。方程可用，但第一轮公式仍标记为 `needs_review`。

## 2. 主体的最优化问题

原文没有为 `EA_CW05ta` 给出家庭或厂商的微观最优化问题。该模型是估计型半结构理性预期系统。

### 2.1 工资制定者合约问题

在 Taylor 名义合约变体中，工资制定者设定当前合约工资时参考四个季度合约期内的预期平均价格和预期平均产出缺口。该选择直接由合约工资条件表示，而不是由效用最大化问题表示：

$$x_t = E_t\left[\bar p_t + \gamma \bar q_t\right] + \sigma_{\varepsilon_x}\varepsilon_{x,t}.$$

### 2.2 总需求与政策模块

总需求、期限结构和货币政策规则在来源中不是最优化问题。它们是估计或外加的均衡关系，因此放在第 3-5 节。

## 3. 一阶条件（FOC）

来源中没有来自家庭或厂商优化的字面一阶条件。以下编号条件是定义该线性理性预期模型的行为方程和均衡方程。

- **(F1) 合约价格加总**：

$$p_t = \sum_{i=0}^{3} f_i x_{t-i}.$$

- **(F2) 合约权重序列**：

$$f_i = 0.25 + (1.5-i)s,\qquad i=0,1,2,3,\qquad s\in(0,1/6].$$

- **(F3) 合约期内预期平均价格**：

$$\bar p_t = \sum_{i=0}^{3} f_i p_{t+i}.$$

- **(F4) 合约期内预期平均产出缺口**：

$$\bar q_t = \sum_{i=0}^{3} f_i q_{t+i}.$$

- **(F5) Taylor 名义工资合约条件**：

$$x_t = E_t\left[\bar p_t + \gamma \bar q_t\right] + \sigma_{\varepsilon_x}\varepsilon_{x,t}.$$

- **(F6) 季度通胀定义**：

$$\pi_t = p_t-p_{t-1}.$$

- **(F7) 政策规则使用的四季度通胀**：

$$\pi_t^{(4)} = p_t-p_{t-4} = \sum_{j=0}^{3}\pi_{t-j}.$$

- **(F8) 总需求 / IS 方程**：

$$q_t = \delta_0 + \delta_1 q_{t-1} + \delta_2 q_{t-2} + \delta_3 r^l_{t-1} + \sigma_{\varepsilon_d}\varepsilon_{d,t}.$$

- **(F9) Taylor 型短期利率规则**：

$$i^s_t = r^{\ast} + \pi_t^{(4)} + \alpha_{\pi}\left(\pi_t^{(4)}-\pi^{\ast}\right) + \alpha_q q_t + \varepsilon_{i,t}.$$

加性货币政策冲击来自 MMB 实现交叉检查；论文方程列出的是没有显式冲击项的确定性规则。状态：`needs_review`。

- **(F10) 预期假说下的长期名义利率**：

$$i^l_t = E_t\left[\frac{1}{8}\sum_{j=0}^{7} i^s_{t+j}\right].$$

- **(F11) 长期事前实际利率**：

$$r^l_t = i^l_t - E_t\left[\frac{1}{2}(p_{t+8}-p_t)\right].$$

- **(F12) 确定性稳态实际利率恒等式**：

$$r^{\ast} = -\frac{\delta_0}{\delta_3}.$$

## 4. 市场出清与总量恒等式

这个小模型用产出缺口、通胀和利率关系表示。它不包含商品市场出清、要素市场出清、资本积累或家庭预算约束。

- **(F13) 产出缺口归一化**：

$$q_t = y_t-y^{\ast}_t.$$

其中 $y_t$ 是对数产出，$y^{\ast}_t$ 是趋势或潜在产出。论文估计中使用对数线性趋势产出缺口，并讨论了 OECD 产出缺口对照。状态：`needs_review`，因为本档案没有从原始数据重建精确 MMB 数据转换。

- **(F14) 实现中的通胀/产出/利率别名**：

$$\text{outputgap}_t=q_t,\qquad \text{inflation}_t=\pi_t^{(4)},\qquad \text{interest}_t=i^s_t.$$

这些别名来自 `.mod` 实现交叉检查，并非单独的论文侧方程。

## 5. 外生过程

- **(F15) 合约工资冲击**：

$$\varepsilon_{x,t}\sim iid(0,1).$$

- **(F16) 总需求冲击**：

$$\varepsilon_{d,t}\sim iid(0,1).$$

- **(F17) MMB 模拟中的货币政策冲击**：

$$\varepsilon_{i,t}\sim iid(0,\sigma_i^2).$$

来源中的模拟讨论成本推动冲击和反通胀实验；显式政策冲击创新是实现交叉检查项。状态：`needs_review`。

## 6. 稳态求解

该模型是线性的，并使用缺口/利率变量。确定性稳态由零产出缺口和政策决定的通胀目标刻画。

1. 将冲击设为零：

$$\varepsilon_{x,t}=\varepsilon_{d,t}=\varepsilon_{i,t}=0.$$

2. 将产出缺口设为零：

$$\bar q=0.$$

3. 政策目标钉住通胀：

$$\bar\pi^{(4)}=\pi^{\ast}.$$

4. 长期事前实际利率等于均衡实际利率：

$$\bar r^l=r^{\ast}=-\frac{\delta_0}{\delta_3}.$$

5. 短期和长期名义利率满足：

$$\bar i^s=\bar i^l=r^{\ast}+\pi^{\ast}.$$

6. 合约价格水平的绝对水平未被钉住。可以使用 $\bar p=0$ 这样的归一化；在去趋势后的零缺口、常数通胀表示中，$\bar x=\bar p$。状态：`needs_review`，因为本档案没有重建 MMB 转换使用的精确水平归一化。

## 7. 时序与形式约定

- **形式**：线性理性预期模型；MMB 实现使用 `model(linear)`。
- **合约时序**：当前合约工资 $x_t$ 通过四季度重叠合约影响当前和未来总价格；总价格 $p_t$ 是当前以及三个滞后合约工资的加权平均。
- **前瞻项**：合约工资设定使用 $i=0,\dots,3$ 的 $E_t p_{t+i}$ 和 $E_t q_{t+i}$；长期名义利率使用从 $t$ 到 $t+7$ 的预期短期利率；长期实际利率扣除从 $t$ 到 $t+8$ 的预期通胀。
- **政策时序**：总需求响应滞后的长期实际利率 $r^l_{t-1}$，表示货币传导滞后。
- **实现交叉检查**：`EA_CW05ta_rep.mod` 使用辅助滞后变量和有限期超前项，在 Dynare 安全的线性形式中表达同一 Taylor 合约模块。它还使用带平滑的 Gerdesmeier-Roffia 风格政策规则，因此该文件中的精确规则系数应视为实现校准，而非论文侧推导。
- **运行时验证**：未执行。

## 8. 变量与参数对照表

### 内生变量

| 符号 / ASCII | 含义 | 主要方程 |
|---|---|---|
| $p_t$ / `p` | 总量对数价格水平 | (F1) |
| $x_t$ / `x`, `cwp` | 当前名义合约工资/价格 | (F5) |
| $q_t$ / `q`, `outputgap` | 产出缺口 | (F8), (F13) |
| $\pi_t$ / `pi1` | 季度通胀 | (F6) |
| $\pi_t^{(4)}$ / `infl`, `inflation` | 四季度通胀 | (F7), (F14) |
| $i^s_t$ / `is`, `interest` | 短期名义政策利率 | (F9) |
| $i^l_t$ / `il` | 长期名义利率 | (F10) |
| $r^l_t$ / `rl` | 长期事前实际利率 | (F11) |
| $\bar p_t$ | 合约期内预期平均价格 | (F3) |
| $\bar q_t$ | 合约期内预期平均产出缺口 | (F4) |

### 外生冲击

| 符号 / ASCII | 含义 | 主要方程 |
|---|---|---|
| $\varepsilon_{x,t}$ / `e_cw` | 合约工资/成本推动冲击 | (F15) |
| $\varepsilon_{d,t}$ / `fiscal_` in MMB file | 总需求冲击 | (F16) |
| $\varepsilon_{i,t}$ / `interest_` | 货币政策冲击 | (F17) |

### 参数

| 符号 / ASCII | 含义 | 来源线索 |
|---|---|---|
| $s$ / `s` | 合约权重的斜率参数 | Table 1, Table 2 |
| $f_i$ / `f0`-`f3` | 合约权重 | (F2) |
| $\gamma$ / `gamma1` | 工资合约中产出缺口敏感度 | Table 1, Table 2 |
| $\sigma_{\varepsilon_x}$ / `sigma_e_cw` | 合约工资冲击尺度 | Table 2 |
| $\delta_0,\delta_1,\delta_2,\delta_3$ / `delta0`-`delta3` | 总需求系数 | Table 4, Table 5 |
| $\sigma_{\varepsilon_d}$ / `sigma_e_d` | 需求冲击尺度 | Table 5 |
| $\alpha_\pi,\alpha_q$ | 政策规则反应系数 | Table 4 |
| $\pi^{\ast}$ | 政策通胀目标 | Table 4 / Section 5 |
| $r^{\ast}$ | 均衡实际利率 | (F12) |

第一轮方程数：17 个编号条件。公式忠实度和精确 MMB 转换细节仍为 `needs_review`。
