# US_FM95AL - 推导

> `US_FM95AL` 的模型档案条目。来源：Fuhrer and Moore (1995), "Inflation persistence," *Quarterly Journal of Economics* 110(1), 127-159, DOI `10.2307/2118513`。未执行运行时验证。

## 1. Model Overview

- **模型**：美国通胀持续性的 Fuhrer-Moore 相对实际合约价格模型。
- **来源映射**：`raw/mmb_mineru/model_index.csv` 将 `US_FM95AL` 映射到 MinerU Markdown 来源 `raw/mmb_mineru/runs/us_fm95_us_fm95al__inflation_persistence__c66e898c/full.md`，标题匹配分数为 1.0000。
- **核心机制**：交错名义合约持续四个季度。总量对数价格水平是仍在生效的合约价格的加权平均。在相对合约版本中，当期实际合约价格相对于重叠实际合约价格和预期过度需求来设定。
- **可观测模块**：论文将合约方程与产出缺口和短期票据利率的约化 VAR 方程合并，使过度需求预期与模型一致。
- **政策用途变体**：论文的政策实验加入名义产出增长反应函数。本地 MMB 实现交叉检查则把合约模块放入 MMB 最优控制比较使用的 `model(linear)` 政策规则接口中。
- **形式**：线性前瞻模型。MMB 文件使用 `model(linear)`。变量是对数、利率、缺口或辅助线性组合，不是非线性水平变量。

## 2. Optimization Problems

论文没有给出微观基础的家庭-企业最优化问题，而是使用由工资议价动机支撑的交错名义合约价格方程。因此，本档案记录行为式合约设定问题，而不虚构论文没有给出的家庭或企业规划问题。

合约设定者选择当期名义合约价格 $x_t$。合约持续四个季度，对 $t-i$ 期谈定且仍在生效的合约给予权重 $f_i$，其中 $i=0,\ldots,3$。在相对版本中，设定者比较实际合约价格而不是名义合约价格：

$$
x_t - p_t
\quad\text{is chosen relative to}\quad
E_t(v_{t+i}),\; i=0,\ldots,3,
\quad\text{and expected excess demand}\quad E_t(\tilde y_{t+i}).
$$

该行为目标由第 3 节的相对合约方程概括。论文侧模型没有单独的资源约束、生产技术或跨期 Euler 条件。

## 3. First-Order Conditions

- **(F1) 由未到期名义合约得到的总量价格指数**：

$$
p_t = \sum_{i=0}^{3} f_i x_{t-i}.
$$

- **(F2) 向下倾斜的四季度合约分布**：

$$
f_i = 0.25 + (1.5-i)s,\qquad 0 < s \leq \frac{1}{6},\qquad i=0,\ldots,3.
$$

- **(F3) 合约权重和为一**：

$$
\sum_{i=0}^{3} f_i = 1,\qquad f_i \geq 0.
$$

- **(F4) 实际合约价格指数**：

$$
v_t = \sum_{i=0}^{3} f_i\bigl(x_{t-i}-p_{t-i}\bigr).
$$

- **(F5) 相对实际合约价格方程**：

$$
x_t - p_t =
\sum_{i=0}^{3} f_i E_t\bigl(v_{t+i}+\gamma \tilde y_{t+i}\bigr)
+ \epsilon^p_t.
$$

- **(F6) 双边相对合约表示**：

$$
x_t-p_t =
\sum_{i=1}^{3}\beta_i(x_{t-i}-p_{t-i})
+\sum_{i=1}^{3}\beta_iE_t(x_{t+i}-p_{t+i})
+\gamma^\ast\sum_{i=0}^{3} f_i E_t(\tilde y_{t+i})
+\epsilon^p_t.
$$

- **(F7) 双边表示中的重叠系数**：

$$
\beta_i =
\frac{\sum_j f_j f_{i+j}}{1-\sum_j f_j^2},
\qquad
\gamma^\ast =
\frac{\gamma}{1-\sum_j f_j^2}.
$$

- **(F8) 通胀定义**：

$$
\pi_t = p_t-p_{t-1}.
$$

- **(F9) 合约价格通胀恒等式**：

$$
\theta_t = x_t-x_{t-1},\qquad \pi_t=f(L)\theta_t,\qquad \theta_t=f^{-1}(L)\pi_t.
$$

- **(F10) 从合约通胀到实际合约价格的分布滞后映射**：

$$
x_t-p_t =
f_1\theta_t + f_2(\theta_t+\theta_{t-1})
+f_3(\theta_t+\theta_{t-1}+\theta_{t-2})
= g(L)\theta_t.
$$

- **(F11) 相对合约的双边 Phillips 曲线**：

$$
\pi_t =
f(L)f(L^{-1})
\left[\pi_t+\gamma g^{-1}(L)y_t\right].
$$

- **(F12) 标准合约与相对合约的嵌套指数**：

$$
v_t=\sum_{i=0}^{3}f_i\bigl(x_{t-i}-\delta p_{t-i}\bigr),
\qquad 0\leq \delta\leq 1.
$$

- **(F13) 标准合约与相对合约的嵌套合约方程**：

$$
x_t-\delta p_t =
\sum_{i=0}^{3}f_iE_t\bigl(v_{t+i}+\gamma\tilde y_{t+i}\bigr)
+\epsilon^p_t.
$$

论文报告 $\delta=1$ 是相对合约限制，$\delta=0$ 是标准合约限制。数据不能拒绝相对合约限制，但拒绝标准合约限制。

## 4. Market Clearing & Identities

- **(F14) 政策实验中的名义产出增长恒等式**：

$$
\Delta Y_t = \Delta p_t + \Delta y_t.
$$

- **(F15) 政策实验的名义产出增长反应函数**：

$$
\Delta Y_t =
\alpha_\pi(\pi_t-\bar\pi)+\alpha_y\tilde y_t.
$$

- **(F16) 附录稳健性检查中的替代预期价格指数**：

$$
\bar p_t = \sum_{i=0}^{3} f_iE_t p_{t+i}.
$$

- **(F17) 替代实际合约价格指数**：

$$
v_t=\sum_{i=0}^{3}f_i(x_{t-i}-\bar p_{t-i}).
$$

- **(F18) 使用 $\bar p_t$ 的替代相对合约方程**：

$$
x_t-\bar p_t=
\sum_{i=0}^{3}f_iE_t\bigl(v_{t+i}+\gamma\tilde y_{t+i}\bigr)
+\epsilon^p_t.
$$

附录估计了该替代版本，但报告主文中的 $p_t$ 定义在经验上更优。这些方程用于来源覆盖；`US_FM95AL` 的主要档案解释是论文的相对合约 $p_t$ 规格。

## 5. Exogenous Processes

- **(F19) 通用线性前瞻模型表示**：

$$
\sum_{i=-\tau}^{0}H_ix_{t+i}
+\sum_{i=1}^{\theta}H_iE_t(x_{t+i})
=\epsilon_t.
$$

- **(F20) 白噪声冲击假设推出的未来预期方程**：

$$
\sum_{i=-\tau}^{\theta}H_iE_t(x_{t+k+i})=0,\qquad k>0.
$$

- **(F21) 预期的鞍路径表示**：

$$
E_t(x_{t+k})=\sum_{i=-\tau}^{-1}B_iE_t(x_{t+k+i}),\qquad k>0.
$$

- **(F22) 代入预期后的可观测结构表示**：

$$
\sum_{i=-\tau}^{0}S_ix_{t+i}=\epsilon_t.
$$

- **(F23) 本地 MMB 交叉检查使用的约化产出缺口方程**：

$$
\tilde y_t = a_0+a_1\tilde y_{t-1}+a_2\tilde y_{t-2}+a_\rho\rho_{t-1}+\epsilon^y_t.
$$

- **(F24) 本地 MMB 实际利率 / 名义利率关系交叉检查**：

$$
\rho_t-D(\rho_{t+1}-\rho_t)=f_t-\pi_{t+1}.
$$

方程 (F23)-(F24) 标记为 `implementation_cross_check`：它们在本地 MMB `.mod` 文件中可见，并且与论文所说的将产出缺口和票据利率的约化方程并入合约方程一致；但具体系数名和辅助变量属于实现侧证据，而不是论文侧推导。

## 6. Steady-State Solution

由于本档案条目是线性 / `model(linear)`，以偏离、差分或相对于基准的通胀表示的变量稳态归一化为零：

$$
\bar{\tilde y}=0,\qquad \bar\pi=0,\qquad \bar\theta=0,\qquad \bar\epsilon^p=\bar\epsilon^y=0.
$$

对常数通胀率 $\bar\pi$，来源记录了稳态实际合约价格缺口：

$$
\bar x_t-\bar p_t=\bar\pi\sum_{i=1}^{3}if_i.
$$

在本地 MMB 实现使用的零通胀线性化下，该式化为：

$$
\bar x-\bar p=0,\qquad \bar v=0.
$$

实现文件将 `ytilde`、`ypsilon`、`infl`、`inflation`、`inflationq`、`output` 和 `outputgap` 初始化为零，并在利率模块中选择常数来居中辅助利率变量。未执行运行时稳态验证。

## 7. Timing & Form Conventions

- **时序**：在 $t$ 期谈定的合约当期进入价格指数，并通过 $x_t,x_{t-1},x_{t-2},x_{t-3}$ 在加权指数中持续四个季度。
- **预期**：$E_t(\cdot)$ 以 $t$ 期历史为条件。四季度规格中的合约方程包含直到 $t+3$ 的预期。
- **形式**：线性前瞻系统。MMB 实现使用 `model(linear)`，并把 `p`、`x`、`ytilde`、`infl` 和 `rho` 等变量作为对数/利率/缺口对象。
- **存量**：论文侧合约模型没有资本或资产存量累积方程。
- **运行时验证**：未执行。没有运行 Dynare。
- **OCR 状态**：主模型模块公式在 MinerU Markdown 中可读。论文约化 VAR 系数到 MMB 政策规则接口变量的精确映射仍为 `needs_review`，因为本地 `.mod` 来自 MMB 实现约定和后续 Fuhrer/Wieland 政策规则用途。

## 8. Variable & Parameter Reference Table

| Category | Symbol / name | Meaning | Main equation |
|---|---|---|---|
| Endogenous | $p_t$ / `p` | 总量对数价格指数 | (F1) |
| Endogenous | $x_t$ / `x` | 名义合约价格 | (F5), (F6) |
| Endogenous | $v_t$ / `ypsilon` | 实际合约价格指数 | (F4), (F5) |
| Endogenous | $\tilde y_t$ / `ytilde` | 产出缺口 / 过度需求 | (F5), (F23) |
| Endogenous | $\pi_t$ / `infl` | 通胀率 | (F8), (F11) |
| Endogenous | $\theta_t$ | 合约价格通胀 | (F9), (F10) |
| Endogenous | $\Delta Y_t$ | 政策实验中的名义产出增长 | (F14), (F15) |
| Endogenous | $\rho_t$ / `rho` | MMB 实现中的实际利率辅助变量 | (F24) |
| Endogenous | $f_t$ / `f` | MMB 实现中的短期名义利率辅助变量 | (F24) |
| Exogenous shock | $\epsilon^p_t$ / `epsilon_p` | 合约价格 / 供给扰动 | (F5), (F13) |
| Exogenous shock | $\epsilon^y_t$ / `epsilon_y` | 产出缺口约化扰动 | (F23) |
| Exogenous shock | `interest_` | MMB 政策规则冲击 | implementation_cross_check |
| Parameter | $f_i$ / `f0`-`f3` | 合约期限权重 | (F2), (F3) |
| Parameter | $s$ | 合约分布斜率 | (F2) |
| Parameter | $\gamma$ / `gamma` | 过度需求对合约价格的影响 | (F5) |
| Parameter | $\beta_i$ | 重叠系数 | (F6), (F7) |
| Parameter | $\gamma^\ast$ | 缩放后的过度需求系数 | (F6), (F7) |
| Parameter | $\delta$ | 标准-相对嵌套指数 | (F12), (F13) |
| Parameter | $\alpha_\pi,\alpha_y$ | 政策实验反应系数 | (F15) |
| Parameter | $H_i,S_i,B_i$ | 通用线性系统系数矩阵 | (F19)-(F22) |
| Parameter | $a_0,a_1,a_2,a_\rho,D$ | MMB 约化式 / 利率模块系数 | (F23), (F24) |
