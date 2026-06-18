# EA_CW05fm 推导

> 私有模型档案的一次提取稿。状态：`needs_review`。
> 未执行运行时验证。公式来自 MinerU Markdown；本地 Rep-MMB 实现只用于覆盖范围与时序的交叉检查。

## 1. 模型概述

- **模型 ID**：`EA_CW05fm`。
- **论文**：Coenen and Wieland (2005), "A small estimated euro area model with rational expectations and nominal rigidities", *European Economic Review* 49(5), 1081-1104, DOI `10.1016/j.euroecorev.2003.05.001`。
- **变体**：MMB 实现注释将 `EA_CW05fm` 标识为 Buiter-Jewitt / Fuhrer-Moore 相对实际工资合约版本。配对的 `EA_CW05ta` 是 Taylor 名义工资合约版本。
- **用途**：一个小型估计欧元区政策模型，连接通胀、产出缺口、利率和交错工资合约。论文估计多个合约设定，并用总需求方程、Taylor 型政策规则、期限结构方程和事前长期实际利率封闭模型。
- **主体/模块**：工资制定者签订交错合约；总需求是简化 IS 方程；央行设定短期名义利率；长期名义和实际利率由预期/期限结构定义给出。
- **形式**：线性理性预期模型。Rep-MMB 文件使用 `model(linear)`。变量是偏离值或利率，不是非线性 DSGE 配置中的水平变量。
- **来源嗅探**：Markdown 前 80 行匹配预期标题和作者，但姓名、inflation 等词有 OCR 噪声。未发现标题/来源不匹配。

## 2. 主体的最优化问题

论文没有给出微观基础的效用或利润最大化问题。结构性工资-价格模块是简化的交错合约模型。"选择"对象是在给定预期价格、实际合约工资比较和产出缺口条件下新谈判的合约工资或合约价格。

对 `EA_CW05fm` 的 Fuhrer-Moore 相对实际工资变体，工资制定者选择当期名义合约工资 \(x_t\)，使合约期限内的预期实际工资与预期重叠实际合约工资和平均产出缺口相关：

\[
{x_t - E_t[\bar p_t] = E_t\left[\sum_{i=0}^{3} f_i v_{t+i} + \gamma \bar q_t\right] + \sigma_{\varepsilon_x}\varepsilon_{x,t}} \qquad \text{(source M-3)}
\]

其中论文定义合约期限平均量为

\[
{\bar p_t = \sum_{i=0}^{3} f_i p_{t+i}, \qquad \bar q_t = \sum_{i=0}^{3} f_i q_{t+i}}
\]

并且在基准 RW 情形下，

\[
{v_t = \sum_{i=0}^{3} f_i\left(x_{t-i} - E_t[\bar p_{t-i}]\right)}.
\]

完整模型随后由估计行为方程封闭，而不是由显式家庭、企业或政府最优化问题封闭。

## 3. 一阶条件（FOC）

由于论文模型估计为线性合约系统，本节记录替代显式 FOC 的结构性均衡条件。编号在第 3-5 节连续。

**(F1) 合约权重**

\[
f_i = 0.25 + (1.5-i)s,\qquad i=0,1,2,3,\qquad 0<s\leq \frac{1}{6}.
\]

**(F2) 由生效合约决定的总价格指数**

\[
p_t = \sum_{i=0}^{3} f_i x_{t-i}.
\]

**(F3) 合约期限内的平均预期价格**

\[
\bar p_t = \sum_{i=0}^{3} f_i p_{t+i}.
\]

**(F4) 合约期限内的平均预期产出缺口**

\[
\bar q_t = \sum_{i=0}^{3} f_i q_{t+i}.
\]

**(F5) 基准 RW 设定的实际合约工资指数**

\[
v_t = \sum_{i=0}^{3} f_i\left(x_{t-i} - E_t[\bar p_{t-i}]\right).
\]

**(F6) `EA_CW05fm` 的相对实际工资合约方程**

\[
x_t - E_t[\bar p_t] = E_t\left[\sum_{i=0}^{3} f_i v_{t+i} + \gamma \bar q_t\right] + \sigma_{\varepsilon_x}\varepsilon_{x,t}.
\]

**(F7) 年化季度通胀定义**

\[
\pi_t = p_t - p_{t-1}.
\]

`needs_review`：论文说明工资-价格模块可以改写为季度通胀和实际合约工资形式，而 Rep-MMB 代码使用辅助滞后/超前变量以及四季度通胀指标。从 \((p_t,x_t)\) 到实现中的 `pi1`、`infl` 和滞后变量的精确代数转换已和 `.mod` 交叉检查，但尚未从论文完整重推。

## 4. 市场出清与总量恒等式

模型没有来自完整微观基础 DSGE 配置的商品、劳动或资产市场出清。其封闭恒等式是关于产出缺口、通胀指标和利率的简化定义。

**(F8) 总需求 / IS 方程**

\[
q_t = \delta_0 + \delta_1 q_{t-1} + \delta_2 q_{t-2} + \delta_3 r^l_{t-1} + \sigma_{\varepsilon_d}\varepsilon_{d,t}.
\]

**(F9) 政策规则使用的四季度通胀**

\[
\pi_t^{(4)} = p_t - p_{t-4}.
\]

**(F10) Taylor 型短期名义利率规则**

\[
i_t^s = r^{\ast} + \pi_t^{(4)} + \alpha_{\pi}\left(\pi_t^{(4)}-\pi^{\ast}\right) + \alpha_q q_t.
\]

**(F11) 由预期假说给出的长期名义利率**

\[
i_t^l = E_t\left[\frac{1}{8}\sum_{j=0}^{7} i_{t+j}^s\right].
\]

**(F12) 长期事前实际利率**

\[
r_t^l = i_t^l - E_t\left[\frac{1}{2}(p_{t+8}-p_t)\right].
\]

**(F13) 确定性稳态实际利率关系**

\[
r^{\ast} = -\frac{\delta_0}{\delta_3}.
\]

**(F14) 政策目标决定稳态通胀**

\[
\pi = \pi^{\ast}.
\]

`needs_review`：Rep-MMB 实现使用带平滑的 Gerdesmeier-Roffia 型 `interest` 规则，即 `interest = (0.87^3) interest_{t-1} + (1-0.87^3)1.93 inflation + (1-0.87^3)0.28 outputgap + interest_`。这相对于论文 Table 4 的 Taylor 规则似乎是实现层面的设定。

## 5. 外生过程

论文将合约工资冲击和需求冲击视为序列不相关、零均值、单位方差的创新，并由标准差参数缩放。

**(F15) 合约工资冲击**

\[
\varepsilon_{x,t}\sim iid(0,1),\qquad \text{contract block scale } \sigma_{\varepsilon_x}.
\]

**(F16) 需求冲击**

\[
\varepsilon_{d,t}\sim iid(0,1),\qquad \text{aggregate-demand scale } \sigma_{\varepsilon_d}.
\]

**(F17) Rep-MMB 政策规则中的货币政策冲击**

\[
\varepsilon_{i,t}\sim iid(0,\sigma_i^2).
\]

`needs_review`：论文 Table 4 的政策规则除模型模拟外是确定性的，而 Rep-MMB 文件包含名为 `interest_` 的政策创新。

## 6. 稳态求解

这是缺口/利率形式的线性模型。确定性稳态由零产出缺口和政策决定的通胀刻画。

**(F18) 产出缺口稳态**

\[
q = 0.
\]

**(F19) 长期实际利率稳态**

\[
r^l = r^{\ast} = -\frac{\delta_0}{\delta_3}.
\]

**(F20) 通胀稳态**

\[
\pi = \pi^{\ast}.
\]

**(F21) 冲击稳态**

\[
\varepsilon_x = \varepsilon_d = \varepsilon_i = 0.
\]

对于 Dynare `model(linear)` 实现，偏离值形式辅助变量的稳态为零，除非变量代表围绕非零目标的水平/利率并已在模型方程中去均值。未执行运行时稳态验证。

## 7. 时序与形式约定

- **合约时序**：四季度交错合约。当期总价格取决于当期和三个滞后的合约工资；当期合约设定取决于当期到未来三季度的预期价格和产出缺口。
- **相对实际工资基准**：`EA_CW05fm` 对应论文的 RW 情形，其中实际合约工资指数使用时点 \(t\) 条件下的预期。
- **利率时序**：总需求响应滞后的长期事前实际利率 \(r^l_{t-1}\)。长期名义利率为未来八个季度预期短期名义利率的平均。长期实际利率扣除未来八个季度的预期通胀。
- **实现时序交叉检查**：Rep-MMB 文件引入超前/滞后辅助变量（`ldq1`、`ldq2`、`ldvindex1`、`ldvindex2`、`ldis1`-`ldis6`、`ldpi1`-`ldpi7`），以便在 `model(linear)` 中表达前瞻平均。
- **形式**：线性理性预期模型，不是让 Dynare 再线性化的非线性模型。

## 8. 变量与参数对照表

### 内生变量

| 符号 / ASCII | 含义 | 主要方程 |
|---|---|---|
| \(p_t\) / `p` | 对数总价格水平 | (F2), (F7), (F9), (F12) |
| \(x_t\) / `cwp` | 新谈判合约工资/价格 | (F2), (F6) |
| \(v_t\) / `vindex` | 实际合约工资指数 | (F5), (F6) |
| \(q_t\) / `q`, `outputgap` | 产出缺口 | (F4), (F8), (F10) |
| \(\pi_t\) / `pi1`, `infl`, `inflation` | 季度或四季度通胀指标 | (F7), (F9), (F10) |
| \(i_t^s\) / `is`, `interest` | 短期名义利率 | (F10), implementation policy rule |
| \(i_t^l\) / `il` | 长期名义利率 | (F11) |
| \(r_t^l\) / `rl` | 长期事前实际利率 | (F8), (F12), (F19) |
| auxiliary lags/leads | `model(linear)` 使用的滞后或预期未来变量 | implementation_cross_check |

### 外生冲击

| 符号 / ASCII | 含义 | 来源 |
|---|---|---|
| \(\varepsilon_{x,t}\) / `e_cw` | 合约工资冲击 | paper Table 1, implementation |
| \(\varepsilon_{d,t}\) / `fiscal_` | 总需求冲击 | paper Table 4, implementation names it `fiscal_` |
| \(\varepsilon_{i,t}\) / `interest_` | 货币政策冲击 | implementation_cross_check |

### 参数

| 符号 / ASCII | 含义 | 说明 |
|---|---|---|
| \(s\) / `s` | 决定合约权重的斜率参数 | paper Table 1；Rep-MMB 的 `EA_CW05fm` 值为 `0.0742`，更接近论文 RW-S 估计而不是基准 RW 估计，`needs_review` |
| \(f_i\) / `f0`-`f3` | 合约工资权重 | (F1) |
| \(\gamma\) / `gamma1` | 合约工资方程中的产出缺口敏感度 | paper Table 1；Rep-MMB 值 `0.0212` |
| \(\sigma_{\varepsilon_x}\) / `sigma_e_cw` | 合约冲击尺度 | paper Table 2；Rep-MMB 归一化为 `1.00` 并在 `shocks` 中放方差 |
| \(\delta_0,\delta_1,\delta_2,\delta_3\) / `delta0`-`delta3` | 总需求参数 | (F8)；Rep-MMB 值使用欧元区德国利率行 |
| \(\sigma_{\varepsilon_d}\) / `sigma_e_d` | 需求冲击尺度 | (F8) |
| \(r^{\ast}\) | 均衡长期实际利率 | (F13), (F19) |
| \(\pi^{\ast}\) | 通胀目标 | (F10), (F14), (F20) |
| \(\alpha_{\pi},\alpha_q\) | 政策响应系数 | paper Table 4 policy rule |
| policy smoothing coefficients | 实现中的政策规则系数 | implementation_cross_check |

### 实现交叉检查摘要

本地 `.mod` 确认了 `model(linear)`、modelbase 变量 `interest`、`inflation`、`outputgap`，冲击 `interest_`、`fiscal_`、`e_cw`，以及实现相对工资合约和利率模块所用的辅助超前/滞后结构。未运行 Dynare。
