# US_MI07 -- 推导（最优化问题 + 一阶条件）

> 私有 MMB 档案条目。未进行运行时验证。第一遍公式状态：`needs_review`。

来源：Fabio Milani (2007), "Expectations, learning and macroeconomic persistence," Journal of Monetary Economics 54(7), 2065-2082。DOI：`10.1016/j.jmoneco.2006.11.007`。

## 1. Model Overview

- **模型**：`US_MI07`，一个用于美国的估计型小型新凯恩斯模型，包含主观预期和常数增益学习。
- **实验**：使用美国季度产出缺口、通胀和名义利率数据进行贝叶斯估计和状态空间似然评估。本档案条目记录结构模型和学习预期模块；未执行 Dynare。
- **主体与模块**：代表性家庭产生带内部习惯形成的动态 IS 关系；Calvo 定价企业产生带指数化的 Phillips 曲线；央行遵循带利率平滑的 Taylor 规则；私人主体使用一个感知运动规律预测通胀、产出缺口和政策利率，并用常数增益递归最小二乘更新该规律。
- **形式**：对数线性状态空间模型。论文中的学习模型在偏离量上是线性的；Rep-MMB 实现交叉检查是相同总量方程的理性预期 `model(linear)` 版本，不实现学习递推。
- **核心变量**：产出缺口 $`x_t`$、通胀 $`\pi_t`$、名义利率 $`i_t`$、自然利率/需求冲击 $`r_t^n`$、成本推动冲击 $`u_t`$、主观预期算子 $`\widehat{E}_t`$，以及学习系数 $`(a_t,b_t,c_t,d_t)`$。

## 2. Optimization Problems

论文直接给出总量对数线性均衡条件，而不是完整的非线性家庭和企业推导。因此这里按模块记录优化基础。

### 2.1 家庭

家庭具有带内部习惯形成的跨期偏好。围绕稳态线性化 Euler 条件得到第 3 节的动态 IS 方程。习惯存量通过变换后的产出缺口项 $`\widetilde{x}_t`$ 进入。

### 2.2 定价企业

企业在 Calvo 摩擦下设定价格。不能重新优化的企业可以对滞后通胀进行指数化。最优定价条件线性化后得到第 3 节的新凯恩斯 Phillips 曲线，其中 $`\xi_p`$ 与价格黏性反向相关，$`\omega`$ 控制实际边际成本对产出的敏感性，$`\gamma`$ 是指数化参数。

### 2.3 中央银行

货币当局遵循带利率平滑的机械 Taylor 规则。它不是优化模块，因此列入均衡条件而不是私人最优化问题。

### 2.4 预期与学习

私人主体像计量经济学家一样行动。他们使用滞后内生变量和当期结构冲击估计 $`Z_t=[\pi_t,x_t,i_t]'`$ 的感知运动规律。系数通过常数增益递归最小二乘更新，并用于形成主观预测。

## 3. First-Order Conditions

- **(F1) 带习惯形成的动态 IS 关系**：

```math
\widetilde{x}_t
= \widehat{E}_t\widetilde{x}_{t+1}
- (1-\beta\eta)\sigma\left(i_t-\widehat{E}_t\pi_{t+1}-r_t^n\right)
```

- **(F2) 带指数化的新凯恩斯 Phillips 曲线**：

```math
\widetilde{\pi}_t
= \xi_p\left[\omega x_t+\left((1-\eta\beta)\sigma\right)^{-1}\widetilde{x}_t\right]
+\beta\widehat{E}_t\widetilde{\pi}_{t+1}+u_t
```

- **(F3) 带利率平滑的 Taylor 规则**：

```math
i_t
= \rho i_{t-1}
+(1-\rho)\left(\chi_{\pi}\pi_t+\chi_x x_t\right)
+\varepsilon_t
```

论文也通过将 (F1)-(F2) 中的 $`\widehat{E}_t`$ 替换为 $`E_t`$ 研究理性预期比较模型。该比较模型不是 `US_MI07` 学习条目的核心，但在说明中记录，因为 Rep-MMB `.mod` 实现的是理性预期线性版本。

## 4. Market Clearing & Identities

- **(F4) 通胀指数化变换**：

```math
\widetilde{\pi}_t \equiv \pi_t-\gamma\pi_{t-1}
```

- **(F5) 习惯调整后的产出缺口变换**：

```math
\widetilde{x}_t
\equiv (x_t-\eta x_{t-1})
-\beta\eta\widehat{E}_t(x_{t+1}-\eta x_t)
```

- **(F6) 预测变量的感知运动规律**：

```math
Z_t=a_t+b_t Z_{t-1}+c_t u_t+d_t r_t^n+\varepsilon_t,\qquad
Z_t\equiv[\pi_t,x_t,i_t]'
```

- **(F7) 常数增益系数更新**：

```math
\widehat{\boldsymbol{\phi}}_t
=\widehat{\boldsymbol{\phi}}_{t-1}
+\bar{g}R_{t-1}^{-1}X_t
\left(Z_t-X_t'\widehat{\boldsymbol{\phi}}_{t-1}\right)
```

- **(F8) 二阶矩矩阵更新**：

```math
R_t=R_{t-1}+\bar{g}\left(X_{t-1}X_{t-1}'-R_{t-1}\right)
```

- **(F9) 主观多步预测公式**（`needs_review`：OCR/来源公式使用 $`I_5`$ 单位矩阵，而 $`Z_t`$ 被定义为三维；保留以待复核）：

```math
\begin{aligned}
\widehat{E}_t Z_T
&=(I_5-b_t)^{-1}(I_5-b_t^{T-t})a_t+b_t^{T-t}E_tZ_t \\
&\quad+\phi_u u_t(\phi_u I_5-b_t)^{-1}(\phi_u^{T-t}I_5-b_t^{T-t})c_t \\
&\quad+\phi_r r_t^n(\phi_r I_5-b_t)^{-1}(\phi_r^{T-t}I_5-b_t^{T-t})d_t,\qquad T>t .
\end{aligned}
```

- **(F10) 状态空间实际运动规律**：

```math
\xi_t=A_t+F_t\xi_{t-1}+G_t w_t,\qquad Y_t=H\xi_t
```

其中 $`\xi_t=[x_t,\pi_t,i_t,u_t,r_t^n]`$，且 $`w_t\sim N(0,Q)`$。

## 5. Exogenous Processes

- **(F11) 自然实际利率/需求冲击**：

```math
r_t^n=\phi^r r_{t-1}^n+v_t^r,\qquad v_t^r\sim iid(0,\sigma_r^2)
```

- **(F12) 成本推动冲击**：

```math
u_t=\phi^u u_{t-1}+v_t^u,\qquad v_t^u\sim iid(0,\sigma_u^2)
```

- **(F13) 货币政策创新**：

```math
\varepsilon_t\sim iid(0,\sigma_{\varepsilon}^2)
```

稳健性分析中的时变政策扩展会加入通胀目标过程，但该扩展不是基准档案方程组。

## 6. Steady-State Solution

该模型是对数线性/状态空间模型。稳态是内生缺口和冲击的零偏离点：

```math
\bar{x}=0,\quad \bar{\pi}=0,\quad \bar{i}=0,\quad \bar{r}^n=0,\quad \bar{u}=0,
\quad \bar{\widetilde{x}}=0,\quad \bar{\widetilde{\pi}}=0 .
```

在零冲击创新下：

```math
\bar{v}^r=\bar{v}^u=\bar{\varepsilon}=0 .
```

感知运动规律的系数和二阶矩矩阵在论文侧推导中没有闭式稳态解。论文指出，当 $`\bar{g}\to0`$ 时，学习信念渐近收敛到理性预期信念，但有限样本学习并不等同于理性预期。该信念稳态标记为 `needs_review`，供后续来源级或实现级重构。

论文学习基准的后验均值估计包括：

| Parameter | Posterior mean |
|---|---:|
| $`\eta`$ | 0.117 |
| $`\beta`$ | 0.990 |
| $`\sigma`$ | 0.748 |
| $`\gamma`$ | 0.032 |
| $`\xi_p`$ | 0.016 |
| $`\omega`$ | 0.865 |
| $`\rho`$ | 0.914 |
| $`\chi_{\pi}`$ | 1.484 |
| $`\chi_x`$ | 0.801 |
| $`\phi_r`$ | 0.845 |
| $`\phi_u`$ | 0.854 |
| $`\sigma_{\varepsilon}`$ | 0.860 |
| $`\sigma_r`$ | 1.670 |
| $`\sigma_u`$ | 1.150 |
| $`\bar{g}`$ | 0.0183 |

实现交叉检查文件则校准了理性预期比较模型，且包含较大的习惯和指数化参数；这些值不作为学习条目的论文侧证据。

## 7. Timing & Form Conventions

- 变量是线性状态空间系统中的对数偏离或利率；Rep-MMB 交叉检查使用 `model(linear)`。
- $`x_t`$、$`\pi_t`$ 和 $`i_t`$ 分别是当期产出缺口、通胀和名义利率。
- $`\widetilde{x}_t`$ 取决于 $`x_t`$、$`x_{t-1}`$ 以及对 $`x_{t+1}`$ 的主观预测。
- $`\widetilde{\pi}_t`$ 取决于当期通胀和滞后通胀。
- 主体在时期 $`t`$ 观察到截至 $`t-1`$ 的内生变量、时期 $`t`$ 的当期冲击，并使用 $`t-1`$ 的参数估计形成对 $`t+1`$ 和 $`t+2`$ 的预测。
- 这个小型对数线性总量模型中没有资本存量或生产侧实物存量。
- 运行时验证：未执行；未运行 Dynare。

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Equation reference |
|---|---|---|---|
| Endogenous | $`x_t`$ / `x` | 产出缺口 | (F1), (F2), (F3), (F5), (F10) |
| Endogenous | $`\pi_t`$ / `pi` | 通胀 | (F2), (F3), (F4), (F10) |
| Endogenous | $`i_t`$ / `i` | 名义利率 | (F1), (F3), (F10) |
| Endogenous | $`\widetilde{x}_t`$ / `x_tilde` | 习惯调整后的产出缺口项 | (F1), (F2), (F5) |
| Endogenous | $`\widetilde{\pi}_t`$ / `pi_tilde` | 指数化通胀项 | (F2), (F4) |
| Endogenous/state | $`r_t^n`$ / `r_n` | 自然实际利率/需求冲击 | (F1), (F6), (F9), (F10), (F11) |
| Endogenous/state | $`u_t`$ / `u` | 成本推动冲击 | (F2), (F6), (F9), (F10), (F12) |
| Learning object | $`Z_t`$ | 预测变量向量 $`[\pi_t,x_t,i_t]'`$ | (F6), (F9) |
| Learning object | $`a_t,b_t,c_t,d_t`$ | PLM 系数 | (F6)-(F9) |
| Learning object | $`R_t`$ | 回归变量二阶矩矩阵 | (F7), (F8) |
| Exogenous shock | $`v_t^r`$ / `v_r` | 自然利率/需求创新 | (F11) |
| Exogenous shock | $`v_t^u`$ / `v_u` | 成本推动创新 | (F12) |
| Exogenous shock | $`\varepsilon_t`$ | 货币政策创新 | (F3), (F13) |
| Parameter | $`\eta`$ / `eta` | 习惯形成 | (F1), (F5) |
| Parameter | $`\beta`$ / `beta` | 贴现因子 | (F1), (F2), (F5) |
| Parameter | $`\sigma`$ / `sigma` | 跨期替代系数 | (F1), (F2) |
| Parameter | $`\gamma`$ / `gamma` | 通胀指数化 | (F4) |
| Parameter | $`\xi_p`$ / `xi_p` | 价格黏性斜率参数 | (F2) |
| Parameter | $`\omega`$ / `omega` | 边际成本/产出弹性项 | (F2) |
| Parameter | $`\rho`$ / `rho_i` | 利率平滑 | (F3) |
| Parameter | $`\chi_{\pi}`$ / `rho_pi` | Taylor 规则通胀反应 | (F3) |
| Parameter | $`\chi_x`$ / `rho_x` | Taylor 规则产出缺口反应 | (F3) |
| Parameter | $`\phi_r`$ / `phi_r` | 自然利率冲击持续性 | (F9), (F11) |
| Parameter | $`\phi_u`$ / `phi_u` | 成本推动冲击持续性 | (F9), (F12) |
| Parameter | $`\bar{g}`$ | 常数学习增益 | (F7), (F8) |
| Parameter | $`\sigma_{\varepsilon},\sigma_r,\sigma_u`$ | 冲击标准差 | (F11)-(F13) |
