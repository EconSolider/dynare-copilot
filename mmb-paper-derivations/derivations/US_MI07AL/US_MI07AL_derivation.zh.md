# US_MI07AL -- 推导（最优化问题 + 一阶条件）

> MMB 模型 `US_MI07AL` 的第一轮私人归档推导。未执行运行时验证。公式不确定处标记为 `needs_review`。

来源：Fabio Milani (2007), "Expectations, learning and macroeconomic persistence," *Journal of Monetary Economics* 54(7), 2065-2082, DOI `10.1016/j.jmoneco.2006.11.007`。

## 1. 模型概述

- **模型**：带主观预期和常数增益适应性学习的小型估计新凯恩斯模型。MMB `US_MI07AL` 条目是 Milani (2007) 对应的适应性学习版本。
- **目的**：拟合美国季度产出缺口、通胀和名义利率数据，并区分机械性持久性与学习生成的持久性。
- **核心主体/模块**：带习惯形成的家庭给出产出缺口的跨期 IS/欧拉方程；带可能指数化的 Calvo 定价企业给出 Phillips 曲线；中央银行遵循利率规则；私人主体用估计的感知运动法则形成预测。
- **状态变量和观测量**：论文使用产出缺口 $`x_t`$、通胀 $`\pi_t`$、名义利率 $`i_t`$、自然实际利率冲击 $`r_t^n`$ 和成本推动冲击 $`u_t`$。状态向量为 $`\xi_t=[x_t,\pi_t,i_t,u_t,r_t^n]'`$。
- **形式**：带主观预期的对数线性模型。实现交叉检查使用 `model(linear)` 和适应性学习封装。下方论文侧推导不运行 Dynare。

## 2. 主体的最优化问题

### 2.1 代表性家庭

论文给出的是对数线性化欧拉方程，而不是完整的非线性家庭问题。其底层问题是带内部习惯形成的标准优化家庭：

```math
\max_{\{C_t,B_t\}} E_0 \sum_{t=0}^{\infty}\beta^t U(C_t-\eta C_{t-1})
```

并受到通常的跨期预算约束。围绕稳态对数线性化、并用习惯调整后的产出表示后，家庭模块由第 3 节的修正 IS/欧拉方程概括。

### 2.2 定价企业

企业面临 Calvo 型价格刚性。不能重新优化的企业可按滞后通胀指数化价格，指数化参数为 $`\gamma`$。论文直接给出所得的新凯恩斯 Phillips 曲线，而不是完整的重设价格问题：

```math
\max_{P_t^{\ast}} \widehat{E}_t \sum_{j=0}^{\infty}(\beta\theta)^j \Lambda_{t,t+j}
\left[P_t^{\ast} \prod_{s=1}^{j}\Pi_{t+s-1}^{\gamma}-MC_{t+j}\right]Y_{t+j|t}
```

本地 Markdown 未打印精确的重设价格 FOC；来源中明确给出的均衡条件是简约 Phillips 曲线。`needs_review`：从这个一般重设价格问题到来源中 $`\xi_p[\omega x_t+\cdots]`$ 系数的映射，在进入 reviewed 状态前需要源级核对。

### 2.3 中央银行与学习主体

论文中中央银行不求解最优化问题。货币政策由利率反馈规则表示。

私人主体像计量经济学家一样行动。他们用滞后宏观变量和当期结构冲击估计 $`Z_t=[\pi_t,x_t,i_t]'`$ 的感知运动法则，然后用常数增益递归最小二乘规则更新系数。这是预测规则，而不是规划者目标函数。

## 3. 一阶条件（FOC）

- **(F1) 习惯调整后的 IS/欧拉方程**：

```math
\widetilde{x}_t
= \widehat{E}_t\widetilde{x}_{t+1}
-(1-\beta\eta)\sigma
\left[i_t-\widehat{E}_t\pi_{t+1}-r_t^n\right].
```

- **(F2) 带指数化和习惯的新凯恩斯 Phillips 曲线**：

```math
\widetilde{\pi}_t
= \xi_p\left[
\omega x_t + \left((1-\eta\beta)\sigma\right)^{-1}\widetilde{x}_t
\right]
+\beta\widehat{E}_t\widetilde{\pi}_{t+1}+u_t.
```

- **(F3) 论文基准货币政策规则**：

```math
i_t=\rho i_{t-1}+(1-\rho)\left(\chi_{\pi}\pi_t+\chi_x x_t\right)+\varepsilon_t.
```

MMB 实现将这个简单的论文规则替换为 Modelbase 货币政策规则接口，其中 `interest_` 是货币政策冲击，规则系数向量来自 `policy_param.mat`。该替换属于 `implementation_cross_check`，不是论文侧方程。

## 4. 市场出清与总量恒等式

- **(F4) 通胀指数化恒等式**：

```math
\widetilde{\pi}_t \equiv \pi_t-\gamma\pi_{t-1}.
```

- **(F5) 习惯调整产出缺口恒等式**：

```math
\widetilde{x}_t
\equiv (x_t-\eta x_{t-1})
-\beta\eta\widehat{E}_t(x_{t+1}-\eta x_t).
```

- **(F6) 感知运动法则（PLM）**：

```math
Z_t=a_t+b_tZ_{t-1}+c_tu_t+d_tr_t^n+\varepsilon_t,
\qquad
Z_t\equiv[\pi_t,x_t,i_t]'.
```

- **(F7) 主观预测公式**：

```math
\begin{aligned}
\widehat{E}_t Z_T
&=(I_5-b_t)^{-1}(I_5-b_t^{T-t})a_t+b_t^{T-t}E_tZ_t \\
&\quad+\phi_u u_t(\phi_u I_5-b_t)^{-1}(\phi_u^{T-t}I_5-b_t^{T-t})c_t \\
&\quad+\phi_r r_t^n(\phi_r I_5-b_t)^{-1}(\phi_r^{T-t}I_5-b_t^{T-t})d_t .
\end{aligned}
```

`needs_review`：来源 Markdown 中打印 $`I_5`$，但 $`Z_t`$ 被定义为三维向量；这可能对应包含 $`u_t`$ 和 $`r_t^n`$ 的扩展状态维度，但维度需要与 PDF 或作者代码核对。

- **(F8) 状态空间实际运动法则与测量方程**：

```math
\begin{aligned}
\xi_t &= A_t+F_t\xi_{t-1}+G_tw_t,\\
Y_t &= H\xi_t,
\end{aligned}
\qquad
\xi_t=[x_t,\pi_t,i_t,u_t,r_t^n]',\quad w_t\sim N(0,Q).
```

状态空间矩阵是结构参数和当期信念的时变组合。论文用 Kalman filter 估计模型，但 Markdown 中没有打印 $`A_t`$、$`F_t`$、$`G_t`$ 或 $`H`$ 的元素。

## 5. 外生过程

- **(F9) 自然实际利率冲击**：

```math
r_t^n=\phi^r r_{t-1}^n+v_t^r,\qquad v_t^r\sim iid(0,\sigma_r^2).
```

- **(F10) 成本推动冲击**：

```math
u_t=\phi^u u_{t-1}+v_t^u,\qquad v_t^u\sim iid(0,\sigma_u^2).
```

- **(F11) 常数增益系数更新**：

```math
\widehat{\boldsymbol{\phi}}_t
=\widehat{\boldsymbol{\phi}}_{t-1}
+\overline{g}R_{t-1}^{-1}X_t
\left(Z_t-X_t'\widehat{\boldsymbol{\phi}}_{t-1}\right).
```

- **(F12) 回归变量二阶矩更新**：

```math
R_t=R_{t-1}+\overline{g}\left(X_{t-1}X_{t-1}'-R_{t-1}\right).
```

其中 $`\widehat{\boldsymbol{\phi}}_t=(a_t',vec(b_t,c_t,d_t)')'`$，$`X_t=\{1,Z_{t-1},u_t,r_t^n\}`$。常数增益参数 $`\overline{g}`$ 与结构参数联合估计。

## 6. 稳态求解

由于这是产出缺口、通胀和利率的对数线性模型，相关的无冲击确定性稳态被规范化为零偏离：

```math
\bar{x}=0,\qquad \bar{\pi}=0,\qquad \bar{i}=0,\qquad \bar{r}^n=0,\qquad \bar{u}=0.
```

变换变量在稳态中也为零：

```math
\bar{\widetilde{x}}=0,\qquad \bar{\widetilde{\pi}}=0.
```

冲击创新的均值为零：

```math
\bar{v}^r=0,\qquad \bar{v}^u=0,\qquad \bar{\varepsilon}=0.
```

在常数增益学习下，有限样本中的信念不一定处于理性预期不动点。随着 $`\overline{g}\to 0`$ 且 $`t\to\infty`$，渐近理性预期极限会被逼近，但论文估计的是有限样本学习动态。`needs_review`：基准中初始信念是固定的，后文也用预样本数据估计；本归档条目没有重构这些初始值。

## 7. 时序与形式约定

- **预期**：$`\widehat{E}_t`$ 表示由 PLM 形成的主观预期；$`E_t`$ 表示模型一致预期。在时间 $`t`$，主体观察 $`t-1`$ 期内生变量，观察 $`t`$ 期冲击，并用 $`t-1`$ 期系数估计形成预测。
- **超前/滞后**：来源方程使用 $`x_{t+1}`$、$`\pi_{t+1}`$、$`x_{t-1}`$、$`\pi_{t-1}`$ 和 $`i_{t-1}`$。模型中没有资本等物理存量变量。
- **形式**：对数线性。MMB `.mod` 交叉检查确认 `model(linear)`。
- **观测变量**：论文拟合产出缺口、通胀和名义利率。实现交叉检查加入 Modelbase 观测量，例如年化利率、季度通胀、四季度通胀、产出缺口和产出别名。
- **运行时验证**：未执行；未运行 Dynare。

## 8. 变量与参数对照表

| 类别 | 符号 / ASCII 名称 | 含义 | 方程或来源作用 |
|---|---|---|---|
| 内生变量 | $`x_t`$ / `x` | 产出缺口 | (F1), (F2), (F5), (F8) |
| 内生变量 | $`\pi_t`$ / `pi` | 通胀 | (F2), (F3), (F4), (F8) |
| 内生变量 | $`i_t`$ / `i` | 名义利率 | (F1), (F3), (F8) |
| 内生变量 | $`\widetilde{x}_t`$ / `x_tilde` | 习惯调整产出缺口 | (F1), (F2), (F5) |
| 内生变量 | $`\widetilde{\pi}_t`$ / `pi_tilde` | 指数化通胀缺口 | (F2), (F4) |
| 内生/状态 | $`r_t^n`$ / `r_n` | 自然实际利率冲击状态 | (F1), (F6), (F9) |
| 内生/状态 | $`u_t`$ / `u` | 成本推动冲击状态 | (F2), (F6), (F10) |
| 信念对象 | $`Z_t`$ | PLM 内生向量 $`[\pi_t,x_t,i_t]'`$ | (F6), (F7), (F11) |
| 信念对象 | $`a_t,b_t,c_t,d_t`$ | 时变 PLM 系数 | (F6), (F7), (F11) |
| 信念对象 | $`R_t`$ | 回归变量二阶矩矩阵 | (F12) |
| 外生创新 | $`\varepsilon_t`$ / MMB 政策封装中的 `interest_` | 货币政策创新 | (F3), implementation cross-check |
| 外生创新 | $`v_t^r`$ / `v_r` | 自然利率创新 | (F9) |
| 外生创新 | $`v_t^u`$ / `v_u` | 成本推动创新 | (F10) |
| 参数 | $`\beta`$ / `beta` | 贴现因子 | (F1), (F2) |
| 参数 | $`\sigma`$ / `sigma` | 论文记号中的跨期替代系数 | (F1), (F2) |
| 参数 | $`\eta`$ / `eta` | 习惯形成 | (F1), (F5) |
| 参数 | $`\gamma`$ / `gamma` | 通胀指数化 | (F4) |
| 参数 | $`\xi_p`$ / `xi_p` | 价格刚性斜率参数 | (F2) |
| 参数 | $`\omega`$ / `omega` | 边际成本/产出缺口弹性项 | (F2) |
| 参数 | $`\rho`$ | 论文利率平滑系数 | (F3) |
| 参数 | $`\chi_\pi,\chi_x`$ | 论文对通胀和产出缺口的政策反馈 | (F3) |
| 参数 | $`\phi_r,\phi_u`$ / `phi_r`, `phi_u` | 冲击持续性 | (F9), (F10) |
| 参数 | $`\sigma_\varepsilon,\sigma_r,\sigma_u`$ | 创新标准差 | (F3), (F9), (F10) |
| 参数 | $`\overline{g}`$ | 常数增益 | (F11), (F12) |

在 `raw/mmb/mmci-cli/models/US_MI07AL/US_MI07AL.mod` 中观察到的仅实现变量包括 `interest`、`inflation`、`inflationq`、`inflationql`、`inflationql2`、`inflationqls`、`outputgap` 和 `output`；这些是 Modelbase 报告和政策接口别名，不是额外的论文侧均衡状态。
