# US_RE09 - 推导（最优化问题 + 一阶条件）

> 状态：needs_review。本文件是基于 MinerU Markdown 和实现交叉检查的一次性初稿抽取。未执行 Dynare 运行时验证。

出处：`US_RE09`，Robert Reis (2009)，"A sticky-information general-equilibrium model for policy analysis"，NBER working paper/report，DOI `10.3386/w14732`。主要 Markdown 来源：`raw/mmb_mineru/runs/us_re09__a_sticky_information_general_equilibrium_model_for_policy_analysis__492aea55/full.md`。原始 PDF：`raw/mmb_papers/A sticky-information general-equilibrium model for policy analysis.pdf`。主要 Markdown 的首页标题为 "Optimal Monetary Policy Rules in an Estimated Sticky-Information Model"；MMB 索引将其映射到 NBER sticky-information policy-analysis 报告。这个版本/标题问题记录在 `extraction_notes.md`。

## 1. Model Overview

- **模型**：用于美国政策分析的黏性信息一般均衡模型（SIGE）。
- **经济体**：闭合经济的对数线性 DSGE 模型，包含商品、劳动和储蓄市场。
- **主体**：家庭包含消费者和工人；厂商生产差异化商品；政府引入财政需求冲击；中央银行遵循 Taylor 型利率规则。
- **关键刚性**：黏性信息存在于所有市场。消费者以概率 $`\delta`$ 更新信息，工人以概率 $`\omega`$ 更新信息，厂商以概率 $`\lambda`$ 更新信息。
- **冲击**：生产率增长、总需求、商品加成、工资加成和货币政策冲击。
- **形式**：围绕非随机 Pareto 最优稳态的 `model(linear)` / 对数线性简约系统。$`y_t`$、$`p_t`$、$`w_t`$、$`l_t`$、$`i_t`$ 和冲击等变量按论文简约形式部分定义为对数水平、对数偏离或差分。
- **实现交叉检查**：`.agents/skills/dynare-copilot/references/examples/US_RE09_rep.mod` 确认 MMB 复现把无限黏性信息预期和截断为 16 个滞后信息集的有限近似。该 `.mod` 文件没有被当作论文侧数学来源。

## 2. Optimization Problems

### 2.1 家庭：消费者-工人单元

家庭包含消费者 $`j`$ 和工人 $`k`$。论文侧效用问题为：

```math
\max_{\{C_{t,j},L_{t,k},M_{t+1,j},W_{t,k}\}} E_t\sum_{s=0}^{\infty}\xi^s
\left[\log C_{t+s,j}
-\frac{\varkappa L_{t+s,k}^{1+1/\psi}}{1+1/\psi}\right].
```

预算约束为：

```math
M_{t+1,j}
=\Pi_{t+1}\left[
M_{t,j}-C_{t,j}
+(1-\tau_w)\frac{W_{t,k}L_{t,k}}{P_t}
+T_{t,j}
\right].
```

消费是关于商品品种的 Dixit-Stiglitz 聚合，随机替代弹性为 $`\tilde{\nu}_t`$：

```math
C_{t,j}
=\left(\int_0^1 C_{t,j}(i)^{\frac{\tilde{\nu}_t}{\tilde{\nu}_t-1}}\,di\right)^{\frac{\tilde{\nu}_t-1}{\tilde{\nu}_t}}.
```

工人 $`k`$ 供给的劳动面对由厂商差异化劳动服务聚合诱导出的需求曲线，随机替代弹性为 $`\tilde{\gamma}_t`$。

### 2.2 厂商

厂商 $`i`$ 雇用复合劳动投入 $`N_{t,i}`$ 并生产：

```math
Y_{t,i}=A_t N_{t,i}^{\beta}.
```

厂商在垄断竞争下选择价格 $`P_{t,i}`$。其实际利润表达式为：

```math
\frac{(1-\tau_p)P_{t,i}Y_{t,i}-W_tN_{t,i}}{P_t}.
```

品种 $`i`$ 的商品需求为：

```math
Y_{t,i}
=\left(\frac{P_{t,i}}{P_t}\right)^{-\tilde{\nu}_t}
G_t\int_0^1 C_{t,j}\,dj.
```

### 2.3 政府和中央银行

政府购买是浪费性的，并由总需求冲击 $`g_t`$ 概括。财政盈余或赤字以一次总付方式返还给家庭或向家庭征收。

中央银行按照 Taylor 规则设定名义利率：

```math
i_t=\varphi_p\Delta p_t+\varphi_y(y_t-y_t^c)-\varepsilon_t.
```

## 3. First-Order Conditions

下面的归档方程是论文强调的 SIGE 模型简约均衡条件。编号在第 3-5 节连续。

**(F1) 消费 Euler 方程，灵活信息基准**：

```math
C_{t,j}^{-1/\theta}
=\xi E_t\left(\Pi_{t+1}C_{t+1,j}^{-1/\theta}\right).
```

needs_review：OCR/论文记号在这里使用 $`\theta`$，而正文其他位置的参数记号存在不完全一致；实现文件使用 `theta` 表示跨期替代/利率敏感性相关项。

**(F2) 厂商期望价格 / 静态定价 FOC**：

```math
p_t^{\ast}
=p_t+\frac{\beta(w_t-p_t)+(1-\beta)y_t-a_t}{\beta+\nu(1-\beta)}
-\frac{\beta\nu_t}{(\nu-1)[\beta+\nu(1-\beta)]}.
```

**(F3) 家庭期望工资 / 劳动供给条件**：

```math
(\gamma+\psi)(w_t^{\ast}-p_t)
=\gamma(w_t-p_t)+l_t-\psi(y_t-g_t)
-\frac{\psi\gamma_t}{\gamma-1}.
```

**(F4) 黏性信息 Phillips 曲线**：

```math
p_t
=\lambda\sum_{i=0}^{\infty}(1-\lambda)^i E_{t-i}
\left[
p_t+\frac{\beta(w_t-p_t)+(1-\beta)y_t-a_t}{\beta+\nu(1-\beta)}
-\frac{\beta\nu_t}{(\nu-1)[\beta+\nu(1-\beta)]}
\right].
```

**(F5) 长期实际利率定义**：

```math
R_t=E_t\sum_{\tau=0}^{\infty}\left(i_{t+\tau}-\Delta p_{t+1+\tau}\right).
```

**(F6) 黏性信息 IS 曲线**：

```math
y_t
=\delta\sum_{j=0}^{\infty}(1-\delta)^j E_{t-j}\left(y_\infty^c-R_t\right)
+g_t.
```

needs_review：OCR 来源中该方程的 $`y_\infty^c`$ 上标有一次渲染为 $`y_\infty^n`$；周围文字将财富度量定义为 $`y_\infty^c`$。本推导保留 $`c`$，并在公式问题中记录。

**(F7) 黏性信息工资曲线**：

```math
w_t
=\omega\sum_{k=0}^{\infty}(1-\omega)^k E_{t-k}
\left[
p_t+\frac{\gamma(w_t-p_t)}{\gamma+\psi}
+\frac{l_t}{\gamma+\psi}
+\frac{\psi(y_\infty^c-R_t)}{\gamma+\psi}
-\frac{\psi\gamma_t}{(\gamma+\psi)(\gamma-1)}
\right].
```

## 4. Market Clearing & Identities

**(F8) 总生产函数**：

```math
y_t=a_t+\beta l_t.
```

**(F9) 古典产出**：

```math
y_t^c
=a_t+\Xi\left[g_t+\frac{\gamma_t}{\gamma-1}+\frac{\nu_t}{\nu-1}\right],
\qquad
\Xi=\frac{\beta\psi}{1+\psi}.
```

**(F10) 古典劳动**：

```math
l_t^c=\frac{y_t^c-a_t}{\beta}.
```

**(F11) 古典实际工资**：

```math
(w_t-p_t)^c
=y_t^c-l_t^c+\frac{\nu_t}{\nu-1}.
```

**(F12) 古典通胀路径**：

```math
\Delta p_t^c
=\sum_{j=0}^{\infty}\varphi_p^{-j-1}
E_t\left(\Delta y_{t+1+j}^c-\Delta g_{t+1+j}+\varepsilon_{t+j}\right).
```

**(F13) 通胀定义**：

```math
\pi_t=p_t-p_{t-1}.
```

**(F14) 产出缺口定义**：

```math
\text{outputgap}_t=y_t-y_t^c.
```

## 5. Exogenous Processes

**(F15) 货币政策规则**：

```math
i_t=\varphi_p\Delta p_t+\varphi_y(y_t-y_t^c)-\varepsilon_t.
```

**(F16) 货币政策冲击**：

```math
\varepsilon_t=\rho_\varepsilon\varepsilon_{t-1}+e_{\varepsilon,t}.
```

**(F17) 生产率增长冲击**：

```math
\Delta a_t=\rho_{\Delta a}\Delta a_{t-1}+e_{\Delta a,t}.
```

**(F18) 总需求冲击**：

```math
g_t=\rho_g g_{t-1}+e_{g,t}.
```

**(F19) 商品加成冲击**：

```math
\nu_t=\rho_\nu\nu_{t-1}+e_{\nu,t}.
```

**(F20) 工资加成冲击**：

```math
\gamma_t=\rho_\gamma\gamma_{t-1}+e_{\gamma,t}.
```

## 6. Steady-State Solution

该模型表示为围绕非随机 Pareto 最优稳态的对数线性简约系统。归档推导采用如下稳态说明：

- 对数线性变量的稳态偏离为零：$`\bar{a}=\bar{g}=\bar{\nu}=\bar{\gamma}=\bar{\varepsilon}=0`$ 且 $`\Delta\bar{a}=0`$。
- 价格水平规范化在简约形式讨论中为 $`p_{-1}=0`$；实现交叉检查中将 $`p_t`$ 用作对数价格水平，并设 $`\pi_t=p_t-p_{t-1}`$。
- 长期实际利率在偏离形式下满足 $`\bar{R}=0`$。
- 当冲击为零时，古典产出和劳动偏离满足 $`\bar{y}^c=\bar{l}^c=0`$。
- 在黏性信息和零冲击下，(F4)、(F6) 和 (F7) 中的预期和退化为同一个零偏离稳态。

needs_review：论文强调简约对数线性动态，而不是非线性稳态块。未对等价的 `steady_state_model` 进行来源级检查，也未执行运行时验证。

## 7. Timing & Form Conventions

- **形式**：MMB 复现使用 `model(linear)`；论文侧方程围绕非随机 Pareto 最优稳态进行对数线性化。
- **信息时序**：黏性信息预期使用 $`E_{t-i}`$、$`E_{t-j}`$ 和 $`E_{t-k}`$，表示信息在更早时期最后一次更新的主体所制定的计划。
- **有限滞后近似**：论文为黏性信息价格、消费/产出和工资方程写出无限和。MMB `.mod` 实现将和式截断为 16 个滞后信息集，作为 `implementation_cross_check`。
- **价格时序**：通胀为 $`\Delta p_t=p_t-p_{t-1}`$；Taylor 规则响应当期通胀和产出缺口。
- **长期利率时序**：$`R_t`$ 是前瞻变量，汇总预期未来名义利率减未来通胀。
- **存量/资本**：该模型没有资本存量；生产使用劳动并具有递减收益。

## 8. Variable & Parameter Reference Table

| 类别 | 符号 / ASCII | 含义 | 方程来源 |
|---|---:|---|---|
| 内生 | `y`, $`y_t`$ | 产出 | (F6), (F8) |
| 内生 | `a`, $`a_t`$ | 生产率水平 | (F8), (F17) |
| 内生 | `l`, $`l_t`$ | 工时/劳动 | (F7), (F8) |
| 内生 | `p`, $`p_t`$ | 对数价格水平 | (F4), (F13) |
| 内生 | `w`, $`w_t`$ | 对数名义工资 | (F7) |
| 内生 | `i`, $`i_t`$ | 名义利率 | (F15) |
| 内生 | `R`, $`R_t`$ | 长期实际利率 | (F5), (F6), (F7) |
| 内生 | `pi`, $`\pi_t`$ | 通胀/价格水平变动 | (F13) |
| 内生 | `outputgap` | 产出缺口 | (F14) |
| 内生 | `yclas`, $`y_t^c`$ | 古典产出 | (F9) |
| 内生 | `yinfn`, $`y_\infty^c`$ | 长期/古典财富度量 | (F6), (F7) |
| 内生 | `deltaa`, $`\Delta a_t`$ | 生产率增长 | (F17) |
| 内生 | `g`, $`g_t`$ | 总需求冲击状态 | (F18) |
| 内生 | `nuu`, $`\nu_t`$ | 商品加成冲击状态 | (F19) |
| 内生 | `gam`, $`\gamma_t`$ | 工资加成冲击状态 | (F20) |
| 内生 | `eps`, $`\varepsilon_t`$ | 货币政策冲击状态 | (F16) |
| 辅助 | `z` | `.mod` 中有限滞后黏性价格目标 | (F4) 的 implementation_cross_check |
| 辅助 | `zwage` | `.mod` 中有限滞后黏性工资目标 | (F7) 的 implementation_cross_check |
| 辅助 | `zoutput` | `.mod` 中有限滞后黏性产出目标 | (F6) 的 implementation_cross_check |
| 外生 | `e_deltaa` | 生产率增长创新 | (F17) |
| 外生 | `e_g` | 总需求创新 | (F18) |
| 外生 | `e_nuu` | 商品加成创新 | (F19) |
| 外生 | `e_gam` | 工资加成创新 | (F20) |
| 外生 | `e_eps` | 货币政策创新 | (F16) |
| 参数 | `beta`, $`\beta`$ | 论文记号中的劳动份额/生产曲率 | (F8) |
| 参数 | `psi`, $`\psi`$ | Frisch 弹性/劳动供给项 | (F3), (F7), (F9) |
| 参数 | `nu`, $`\nu`$ | 稳态商品替代弹性 | (F2), (F4), (F9), (F11) |
| 参数 | `gamma`, $`\gamma`$ | 稳态劳动替代弹性 | (F3), (F7), (F9) |
| 参数 | `theta` | 实现中的跨期替代/利率敏感性参数 | (F1), (F6), (F7) |
| 参数 | `delta`, $`\delta`$ | 消费者信息更新概率 | (F6) |
| 参数 | `omega`, $`\omega`$ | 工人信息更新概率 | (F7) |
| 参数 | `lambda`, $`\lambda`$ | 厂商信息更新概率 | (F4) |
| 参数 | `phi_pi`, $`\varphi_p`$ | Taylor 规则通胀响应 | (F15) |
| 参数 | `phi_y`, $`\varphi_y`$ | Taylor 规则产出缺口响应 | (F15) |
| 参数 | `rho_deltaa` | 生产率增长持续性 | (F17) |
| 参数 | `rho_eps` | 货币政策冲击持续性 | (F16) |
| 参数 | `rho_g` | 总需求冲击持续性 | (F18) |
| 参数 | `rho_nuu` | 商品加成冲击持续性 | (F19) |
| 参数 | `rho_gam` | 工资加成冲击持续性 | (F20) |
| 参数 | `T` | MMB 实现中的有限滞后数量 | implementation_cross_check |

方程计数：本文档记录 20 条编号条件。`.mod` 实现交叉检查有 19 个内生变量，因为它把无限和目标改写为有限滞后辅助方程，并加入实现特定辅助变量；该差异留待审查，不视为运行时验证。
