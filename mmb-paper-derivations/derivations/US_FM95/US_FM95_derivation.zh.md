# US_FM95 -- 推导（有来源支撑的模型档案条目）

> 档案状态：`needs_review`。这是基于 MinerU Markdown 来源的一轮初稿推导。未运行 Dynare。Rep-MMB `.mod` 仅作为 `implementation_cross_check` 使用。

来源：Jeff Fuhrer and George Moore (1995), "Inflation Persistence," *The Quarterly Journal of Economics*, 110(1), 127-159. DOI: `10.2307/2118513`。

## 1. Model Overview

- **模型**：`US_FM95`，Fuhrer-Moore 相对合约通胀持久性模型。
- **核心机制**：四季度交错名义合约。合约制定者关心相对实际合约价格，因此通胀本身具有持久性，而不是只从产出缺口过程继承持久性。
- **主体/模块**：合约制定者选择名义合约价格；价格指数汇总仍在生效的合约；约简型产出缺口和利率方程提供预测系统；政策实验使用名义产出增长反应函数。
- **形式**：线性前瞻模型。Rep-MMB 实现使用 `model(linear)`。
- **范围说明**：QJE 来源估计标准合约和相对合约两类设定。`US_FM95` 对应 Rep-MMB 使用的相对合约版本。`.mod` 还加入 LWW 政策规则以及来自后续实现来源的参数化；这些内容记录为交叉检查证据，而不是论文侧来源方程。

## 2. Optimization Problems

论文没有从完整家庭或企业最优化问题推导合约方程，而是直接给出行为型工资/价格合约规则。在假设价格是工资固定加成的情况下，本档案直接把模型写成合约设定均衡条件系统。

合约制定者在四季度有效的合约中协商名义合约价格 $x_t$。在相对合约设定中，他们选择当前实际合约价格 $x_t-p_t$，使其等于合约期限内预期平均实际合约价格指数加上过度需求压力：

$$
x_t - p_t
= \sum_{i=0}^{3} f_i E_t\left(v_{t+i}+\gamma \tilde y_{t+i}\right)+\epsilon^p_t .
$$

隐含的选择变量是当前名义合约价格 $x_t$，给定价格指数 $p_t$、未来实际合约价格指数预期、未来产出缺口预期和合约扰动。

## 3. First-Order Conditions

- **(F1) 价格指数汇总**：

$$
p_t=\sum_{i=0}^{3} f_i x_{t-i}.
$$

- **(F2) 合约权重设定**：

$$
f_i=0.25+(1.5-i)s,\qquad 0<s\leq \frac{1}{6},\qquad i=0,\ldots,3.
$$

- **(F3) 权重归一化和可行性**：

$$
\sum_{i=0}^{3} f_i=1,\qquad f_i\geq 0.
$$

- **(F4) 实际合约价格指数**：

$$
v_t=\sum_{i=0}^{3} f_i\left(x_{t-i}-p_{t-i}\right).
$$

- **(F5) 相对合约方程**：

$$
x_t-p_t
=\sum_{i=0}^{3} f_i E_t\left(v_{t+i}+\gamma \tilde y_{t+i}\right)+\epsilon^p_t.
$$

- **(F6) 代入实际合约价格指数后的相对合约方程**：

$$
x_t-p_t
=\sum_{i=1}^{3}\beta_i\left(x_{t-i}-p_{t-i}\right)
+\sum_{i=1}^{3}\beta_i E_t\left(x_{t+i}-p_{t+i}\right)
+\gamma^*\sum_{i=0}^{3} f_i E_t\left(\tilde y_{t+i}\right)+\epsilon^p_t.
$$

- **(F7) 双边表示中的重叠权重**：

$$
\beta_i=
\frac{\sum_j f_j f_{i+j}}{1-\sum_j f_j^2},
\qquad
\gamma^*=\frac{\gamma}{1-\sum_j f_j^2}.
$$

- **(F8) 通胀定义**：

$$
\pi_t=p_t-p_{t-1}.
$$

论文数据表使用年化季度通胀，$\pi_t=4\Delta p_t$。Rep-MMB 交叉检查中使用 `infl = 4*(p-p(-1))`。

- **(F9) 合约价格通胀和价格指数通胀**：

$$
\theta_t=x_t-x_{t-1},\qquad \pi_t=f(L)\theta_t,\qquad \theta_t=f(L)^{-1}\pi_t,
$$

其中 $f(L)=f_0+f_1L+f_2L^2+f_3L^3$。

- **(F10) 从通胀到实际合约价格的分布滞后映射**：

$$
x_t-p_t
=f_1\theta_t+f_2(\theta_t+\theta_{t-1})+f_3(\theta_t+\theta_{t-1}+\theta_{t-2})
=g(L)\theta_t
=g(L)f(L)^{-1}\pi_t.
$$

- **(F11) 作为通胀分布滞后的实际合约价格指数**：

$$
v_t=g(L)\pi_t.
$$

- **(F12) 相对合约模型的双边菲利普斯曲线表示**：

$$
\pi_t=f(L)f(L^{-1})\left[\pi_t+\gamma g(L)^{-1}y_t\right].
$$

- **(F13) 嵌套标准/相对合约的合约价格指数**：

$$
v_t=\sum_{i=0}^{3}f_i\left(x_{t-i}-\delta p_{t-i}\right),\qquad 0\leq \delta\leq 1.
$$

- **(F14) 嵌套标准/相对合约方程**：

$$
x_t-\delta p_t
=\sum_{i=0}^{3}f_iE_t\left(v_{t+i}+\gamma\tilde y_{t+i}\right)+\epsilon^p_t.
$$

其中 $\delta=0$ 给出标准名义合约模型，$\delta=1$ 给出相对实际合约模型。论文报告数据拒绝 $\delta=0$，但不拒绝 $\delta=1$。

## 4. Market Clearing & Identities

- **(F15) 可观测对数价格指数恒等式**：

$$
p_t=f(L)x_t.
$$

- **(F16) 实际合约价格定义**：

$$
q^x_t=x_t-p_t.
$$

- **(F17) 论文政策实验中的名义产出恒等式**：

$$
\Delta Y_t=\Delta y_t+\pi_t.
$$

- **(F18) 名义产出增长政策实验规则**：

$$
\Delta Y_t=\alpha_\pi(\pi_t-\bar\pi)+\alpha_y\tilde y_t.
$$

论文抽象掉货币政策控制名义产出的工具传导机制。在 Rep-MMB 中，这一政策实验规则被单独的 LWW 风格利率规则替代；该替代属于实现细节。

## 5. Exogenous Processes

- **(F19) 合约扰动**：

$$
\epsilon^p_t\sim \text{i.i.d. }N(0,\sigma_p^2).
$$

- **(F20) 约简型产出缺口方程，通用表示**：

$$
\tilde y_t=a_0+a_1\tilde y_{t-1}+a_2\tilde y_{t-2}+a_\rho\rho_{t-1}+\epsilon^y_t.
$$

这一具体滞后结构和命名由实现交叉检查确认。QJE 论文说明，VAR 中的票据利率和产出缺口约简型方程会与合约方程结合，但 (F20) 的紧凑系数形式属于实现侧内容，因此作为论文来源方程仍标记为 `needs_review`。

- **(F21) 附录 A 中的一般前瞻模型形式**：

$$
\sum_{i=-\tau}^{0}H_i x_{t+i}+\sum_{i=1}^{\theta}H_iE_t(x_{t+i})=\epsilon_t.
$$

- **(F22) 解法中的预测方程**：

$$
\sum_{i=-\tau}^{\theta}H_iE_t(x_{t+k+i})=0,\qquad k>0.
$$

- **(F23) 解路径的 VAR 表示**：

$$
E_t(x_{t+k})=\sum_{i=-\tau}^{-1}B_iE_t(x_{t+k+i}),\qquad k>0.
$$

## 6. Steady-State Solution

由于档案形式是线性/对数偏离模型，操作性稳态是零缺口状态：

$$
\tilde y=0,\qquad \epsilon^p=\epsilon^y=0,\qquad \pi=\bar\pi,\qquad \Delta Y=0
$$

在通胀目标不变时，$p_t$ 和 $x_t$ 以共同稳态通胀率增长。

论文给出常数通胀下的稳态实际合约价格关系：

- **(F24) 趋势通胀下的稳态实际合约价格**：

$$
\bar x_t-\bar p_t=\bar\pi\sum_{i=1}^{3}i f_i.
$$

在 Rep-MMB 零通胀线性化下，$\bar\pi=0$，因此：

$$
\bar x-\bar p=0,\qquad \bar v=0,\qquad \bar{\tilde y}=0,\qquad \bar{\pi}=0.
$$

Rep-MMB 实现用产出缺口方程常数初始化 `f` 和 `rho`，但该稳态归一化来自实现代码，在提升到 `needs_review` 以上状态前应与后续 Fuhrer/LWW 文档做来源检查。

## 7. Timing & Form Conventions

- 时间频率为季度。
- 合约持续四个季度，由当前和三个滞后的合约价格索引。
- 预期 $E_t(\cdot)$ 是基于截至 $t$ 期信息的理性预期。
- $x_t$ 是 $t$ 期协商的合约价格；$p_t$ 是总对数价格指数。
- 合约方程包含直到 $t+3$ 的超前项，因为当前合约与未来预期合约和产出缺口条件重叠。
- 价格汇总包含直到 $t-3$ 的滞后项，因为四个合约 cohort 同时有效。
- 模型在对数水平、通胀率、缺口和合约价格偏离中是线性的。Rep-MMB 在 Dynare 中以 `model(linear)` 实现。
- 资本存量时序不适用；这是工资/价格合约和约简型货币模型，不是资本积累模型。
- 未执行运行时验证。

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII name | Meaning | Source / equation |
|---|---|---|---|
| Endogenous | $p_t$ / `p` | 总对数价格指数 | (F1), (F15) |
| Endogenous | $x_t$ / `x` | 对数名义合约价格 | (F1), (F5) |
| Endogenous | $v_t$ / `ypsilon` | 实际合约价格指数 | (F4), implementation naming |
| Endogenous | $\pi_t$ / `infl` | 通胀率 | (F8), (F9) |
| Endogenous | $\theta_t$ | 合约价格通胀 | (F9), (F10) |
| Endogenous | $\tilde y_t$ / `ytilde` | 产出缺口 | (F5), (F20) |
| Endogenous | $\Delta Y_t$ | 政策实验中的名义产出增长 | (F17), (F18) |
| Endogenous | $\rho_t$ / `rho` | 实现中的实际/长期利率状态 | implementation_cross_check, needs_review |
| Endogenous | $r_t$ / `interest` | VAR/政策规则中的短期名义利率 | paper VAR and implementation_cross_check |
| Exogenous | $\epsilon^p_t$ / `epsilon_p` | 合约或价格扰动 | (F5), (F19) |
| Exogenous | $\epsilon^y_t$ / `epsilon_y` | 产出缺口扰动 | (F20), implementation_cross_check |
| Exogenous | `interest_` | Rep-MMB 规则中的货币政策冲击 | implementation_cross_check |
| Parameter | $s$ / `s` | 四季度合约权重分布斜率 | (F2) |
| Parameter | $f_i$ / `f0`-`f3` | 合约权重系数 | (F1), (F2) |
| Parameter | $\gamma$ / `gamma` | 合约设定中的产出缺口效应 | (F5) |
| Parameter | $\beta_i$ | 双边表示中的重叠权重 | (F6), (F7) |
| Parameter | $\gamma^*$ | 缩放后的产出缺口系数 | (F6), (F7) |
| Parameter | $\delta$ | 标准合约和相对合约的嵌套指数 | (F13), (F14) |
| Parameter | $\alpha_\pi,\alpha_y$ | 名义产出政策实验响应系数 | (F18) |
| Parameter | $\bar\pi$ | 通胀目标 | (F18), (F24) |
| Parameter | $a_0,a_1,a_2,a_\rho$ | 约简型产出缺口系数 | (F20), implementation_cross_check |
| Parameter | $D$ | 实现中的期限结构参数 | implementation_cross_check, needs_review |
