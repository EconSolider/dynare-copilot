# NK_RW97 - 推导（Rotemberg-Woodford 新凯恩斯模型）

> `NK_RW97` 的模型档案条目。状态：`needs_review`。未执行运行时验证；未运行 Dynare。

## 1. Model Overview

- **模型**：Rotemberg and Woodford (1997), "An Optimization-Based Econometric Framework for the Evaluation of Monetary Policy."
- **模型 ID**：`NK_RW97`。
- **来源**：`raw/mmb_mineru/runs/nk_rw97_nk_rw97al__an_optimization_based_econometric_framework_for_the_evaluation_of_moneta__af3fb04e/full.md`；DOI `10.1086/654340`。
- **用途**：一个用于评价货币政策规则的小型优化基础计量模型，核心变量为产出、通胀和联邦基金利率。
- **主体/模块**：消费 CES 总量并生产差异化商品的代表性家庭，带决策滞后的 Calvo 定价者，遵循估计利率反馈规则的货币当局，以及外生自主支出和自然产出扰动。
- **核心变量**：通胀 $`\hat{\pi}_t`$、产出 $`\hat{Y}_t`$、名义利率 $`\hat{R}_t`$、长期实际利率 $`\hat{r}^l_t`$、相对重设价格变量 $`\hat{X}_t`$、自主支出扰动 $`\hat{G}_t`$ 和自然产出扰动 $`\hat{Y}^s_t`$。
- **形式**：围绕零通胀稳态的对数线性近似。MMB 交叉检查实现为 `model(linear)`。

## 2. Optimization Problems

### 2.1 代表性家庭

家庭 $`i`$ 选择 CES 总量购买和差异化商品产量，以最大化期望效用：

```math
E_0\sum_{t=0}^{\infty}\beta^t\left[u(C^i_t;\xi_t)-v(y^i_t;\xi_t)\right].
```

CES 消费总量为：

```math
C^i_t=\left(\int_0^1 c^i_t(z)^{(\theta-1)/\theta}\,dz\right)^{\theta/(\theta-1)}.
```

给定名义支出 $`S^i_t`$，在差异化商品之间的支出最小化给出 Dixit-Stiglitz 价格指数：

```math
P_t=\left(\int_0^1 p_t(z)^{1-\theta}\,dz\right)^{1/(1-\theta)}.
```

跨期预算约束为：

```math
E_t\sum_{T=t}^{\infty}\delta_{t,T}S^i_T
\leq
E_t\sum_{T=t}^{\infty}\delta_{t,T}\left[p_T(i)y^i_T-T_T\right]+A^i_t.
```

无风险名义总利率满足：

```math
R_t=\left(E_t\delta_{t,t+1}\right)^{-1}.
```

### 2.2 需求加总

总需求为利率敏感私人购买和自主支出之和：

```math
Y_t=C_t+G_t.
```

自主支出也被设定为商品的 CES 总量，因此单个供给者面对的需求为：

```math
y^i_t=Y_t\left(\frac{p_t(i)}{P_t}\right)^{-\theta}.
```

### 2.3 定价问题

每期有 $`1-\alpha`$ 比例的卖者可以选择新价格。其中 $`\gamma`$ 比例在当期开始收取新价格，$`1-\gamma`$ 比例提前一个季度公布价格。令 $`p^i_t`$ 表示从 $`t`$ 期开始收取、但基于 $`t-i`$ 期信息选择的新价格，其中 $`i=1,2`$。

重设价格 $`p`$ 的目标函数为：

```math
\Phi_t(p)=\sum_{j=0}^{\infty}(\alpha\beta)^j
\left[
\lambda_{t+j}(1-\tau)pY_{t+j}\left(\frac{p}{P_{t+j}}\right)^{-\theta}
-v\left(Y_{t+j}\left(\frac{p}{P_{t+j}}\right)^{-\theta};\xi_{t+j}\right)
\right].
```

最优重设价格满足：

```math
E_{t-i}\Phi'_t(p^i_t)=0,\qquad i=1,2.
```

## 3. First-Order Conditions

论文采用的实现形式是对数线性均衡系统。以下编号条件是本档案条目使用的来源支持的均衡限制和定义。

- **(F1) 带决策滞后的家庭期内购买条件**：

```math
E_t u'(C^i_{t+2};\xi_{t+2})=E_t\left(\lambda^i_{t+2}P_{t+2}\right).
```

- **(F2) 跨状态和跨日期的名义收入边际效用**：

```math
\lambda^i_t\delta_{t,T}=\beta^{T-t}\lambda^i_T,\qquad T\geq t.
```

- **(F3) 收入边际效用欧拉关系**：

```math
\lambda_t=\beta E_t\left(R_t\lambda_{t+1}\right).
```

- **(F4) 对数线性形式的长期实际利率/边际效用**：

```math
\hat{\lambda}_t=\hat{r}^l_t
\equiv
\sum_{T=t}^{\infty}E_t\left(\hat{R}_T-\hat{\pi}_{T+1}\right).
```

- **(F5) 对数线性消费决策条件**：

```math
-\tilde{\sigma}E_t\left(\hat{C}_{t+2}-\bar{C}_{t+2}\right)
=E_t\hat{r}^l_{t+2}.
```

- **(F6) 带两期决策滞后的 IS 方程**：

```math
\hat{Y}_t=-\sigma^{-1}E_{t-2}\hat{r}^l_t+\hat{G}_t.
```

- **(F7) 新价格对通胀的贡献**：

```math
\hat{\pi}_t=\gamma\hat{X}^1_t+(1-\gamma)\hat{X}^2_t.
```

- **(F8) 预定新价格关系**：

```math
\hat{X}^2_t=E_{t-2}\hat{X}^1_t-\frac{1-\alpha}{\alpha}
\left(\hat{\pi}_t-E_{t-2}\hat{\pi}_t\right).
```

- **(F9) 通胀和当期重设价格**：

```math
\hat{\pi}_t=\frac{1}{1+\psi}\hat{X}_t+
\frac{\psi}{1+\psi}E_{t-2}\hat{\pi}_t,
\qquad
\psi\equiv\frac{1-\gamma}{\gamma\alpha}.
```

- **(F10) 拟差分前的对数线性定价条件**：

```math
\begin{aligned}
E_{t-1}\sum_{j=0}^{\infty}(\alpha\beta)^j
\Bigg[
&(1+\omega\theta)
\left(\frac{\alpha}{1-\alpha}\hat{X}_t-\sum_{s=1}^{j}\hat{\pi}_{t+s}\right)\\
&-(\omega+\sigma)\left(\hat{Y}_{t+j}-\hat{Y}^s_{t+j}\right)
\Bigg]
=-\phi_{t-1}.
\end{aligned}
```

- **(F11) 定价中的实际利率修正项**：

```math
\phi_t\equiv
E_t\left[
\hat{R}_{t+1}-\hat{\pi}_{t+2}
-\sigma\left(\hat{Y}_{t+2}-\hat{G}_{t+2}-\hat{Y}_{t+1}+\hat{G}_{t+1}\right)
\right].
```

- **(F12) 自然产出扰动定义**：

```math
\hat{Y}^s_t\equiv
\frac{\omega}{\omega+\sigma}E_{t-1}\bar{Y}_t
+\frac{\sigma}{\omega+\sigma}\hat{G}_t.
```

- **(F13) 拟差分后的总供给/重设价格方程**：

```math
\hat{X}_t=\beta E_{t-1}\hat{X}_{t+1}
+\kappa(\hat{Y}_t-\hat{Y}^s_t)
-\frac{\kappa}{\omega+\sigma}\phi_{t-1}.
```

- **(F14) 总供给关系的斜率**：

```math
\kappa=
\frac{(1-\alpha)(1-\alpha\beta)(\omega+\sigma)}
{\alpha(1+\omega\theta)}.
```

- **(F15) 条件期望形式的新凯恩斯菲利普斯曲线**：

```math
E_{t-2}\hat{\pi}_t
=\kappa E_{t-2}\left(\hat{Y}_t-\hat{Y}^s_t\right)
+\beta E_{t-2}\hat{\pi}_{t+1}.
```

- **(F16) 估计的历史利率反馈规则**：

```math
r_t=r^{\ast}
+\sum_{k=1}^{n_r}\mu_k(r_{t-k}-r^{\ast})
+\sum_{k=0}^{n_\pi}\phi_k(\pi_{t-k}-\pi^{\ast})
+\sum_{k=0}^{n_y}\theta_k y_{t-k}
+\epsilon_t.
```

## 4. Market Clearing & Identities

- **(F17) 总资源恒等式**：

```math
Y_t=C_t+G_t.
```

- **(F18) 对数线性总需求恒等式**：

```math
\hat{Y}_t=s_C\hat{C}_t+\tilde{G}_t,
\qquad
\hat{G}_t\equiv \tilde{G}_t+s_CE_{t-2}\bar{C}_t.
```

- **(F19) 商品 $`i`$ 的 Dixit-Stiglitz 需求**：

```math
y^i_t=Y_t\left(\frac{p_t(i)}{P_t}\right)^{-\theta}.
```

- **(F20) 含当期和提前一期重设价格的价格指数**：

```math
P_t=
\left[
\alpha P_{t-1}^{1-\theta}
+(1-\alpha)\gamma(p^1_t)^{1-\theta}
+(1-\alpha)(1-\gamma)(p^2_t)^{1-\theta}
\right]^{1/(1-\theta)}.
```

## 5. Exogenous Processes

- **(F21) 用于识别政策冲击的 VAR 状态向量**：

```math
Z_t=\left[r_t,\ \pi_{t+1},\ y_{t+1}\right]'.
```

- **(F22) 估计的 VAR 表示**：

```math
T\bar{Z}_t=A\bar{Z}_{t-1}+\bar{e}_t.
```

- **(F23) 伴随形式 VAR 运动规律**：

```math
\bar{Z}_t=B\bar{Z}_{t-1}+U\bar{e}_t.
```

- **(F24) 从 VAR 恢复的货币政策冲击**：

```math
\epsilon_t=i_1'\left(\bar{Z}_t-B\bar{Z}_{t-1}\right).
```

- **(F25) 紧凑形式的自主支出冲击方程**：

```math
M'\tilde{Z}_t-N'\sum_{j=1}^{\infty}E_{t-1}\tilde{Z}_{t+j}
=\hat{G}_{t+1}.
```

- **(F26) 紧凑形式的自然产出冲击方程**：

```math
P'E_{t-1}\tilde{Z}_t+R'E_t\tilde{Z}_{t+1}
=\hat{Y}^s_{t+1}
+\frac{\sigma}{\sigma+\omega}
E_t\left(\hat{G}_{t+2}-\hat{G}_{t+1}\right).
```

- **(F27) 从 VAR 对象重构的实际扰动向量**：

```math
s_t\equiv
\begin{bmatrix}
\hat{G}_{t+1}\\
\hat{Y}^s_{t+1}
\end{bmatrix}
=C\bar{Z}_{t-1}+D\bar{e}_t.
```

## 6. Steady-State Solution

本模型档案条目遵循论文围绕零通胀稳态的对数线性近似，所有平稳变量均写成相对稳态的偏离。

1. 令所有带帽变量和创新为零：

```math
\hat{Y}=\hat{C}=\hat{G}=\hat{Y}^s=\hat{\pi}=\hat{R}=\hat{r}^l=\hat{X}=0.
```

2. 零通胀是展开点：

```math
\pi=0,\qquad P_t/P_{t+1}=1.
```

3. 实际总回报确定贴现因子：

```math
\beta^{-1}=R/\Pi.
```

论文在主要估计中校准 $`\beta=0.99`$，而 Rep-MMB 实现使用 $`\beta=1/(1+0.035/4)`$。该差异记录为 `implementation_cross_check` 差异，而不静默归一化。

4. 在 MMB `model(linear)` 交叉检查中，声明的内生变量稳态均为零：

```math
\pi=y=y^{nat}=r^{nat}=i=x=u=g=0.
```

## 7. Timing & Form Conventions

- **形式**：对数线性模型。MMB 文件声明 `model(linear)`。
- **决策时序**：第 $`t`$ 期总购买由 $`t-2`$ 期信息决定。自主支出在第 $`t`$ 期开始前已知，即属于 $`t-1`$ 期信息集。
- **价格时序**：每期只有 $`1-\alpha`$ 比例可以重设价格。重设者中 $`\gamma`$ 比例立即收取新价格，$`1-\gamma`$ 比例提前一个季度公布。
- **信息集**：由于购买和价格决策滞后，总需求和通胀中出现 $`E_{t-2}`$。重设价格方程中出现 $`E_{t-1}`$。
- **存量变量**：模型抽象掉资本积累；不存在生产资本时序。
- **冲击**：论文构造三个随机扰动：货币政策冲击 $`\epsilon_t`$、自主支出扰动 $`\hat{G}_t`$ 和自然产出/供给扰动 $`\hat{Y}^s_t`$。MMB 实现保留两个外生创新 `u_` 和 `g_`，分别对应成本推动和财政/自主支出扰动，并使用不含单独货币政策创新的简单政策规则。
- **实现交叉检查**：本地 `.mod` 引用 Woodford (2003, p. 246) 作为所实现简化形式的来源，并使用方程
  $`\pi_t=\beta E_t\pi_{t+1}+\kappa x_t+u_t`$、
  $`x_t=E_tx_{t+1}-\sigma(i_t-E_t\pi_{t+1}-r^{nat}_t)`$、
  $`x_t=y_t-y^{nat}_t`$、
  $`u_t=\rho_u u_{t-1}+\varepsilon^u_t`$、
  $`g_t=\rho_g g_{t-1}+\varepsilon^g_t`$、
  以及 $`i_t=\phi_\pi\pi_t+\phi_xx_t`$。

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Determined by |
|---|---|---|---|
| 内生 | $`\hat{\pi}_t`$ / `pi` | 通胀偏离 | (F9), (F15), 实现中的 NKPC |
| 内生 | $`\hat{Y}_t`$ / `y` | 产出偏离 | (F6), (F17), (F18) |
| 内生 | $`\hat{R}_t`$ / `i` | 名义利率偏离 | (F16), 实现中的 Taylor 规则 |
| 内生 | $`\hat{r}^l_t`$ | 长期实际利率 | (F4) |
| 内生 | $`\hat{X}_t`$ / `x` in implementation | 来源中为重设价格状态，实现在记号上为产出缺口 | (F9), (F13); implementation `x=y-ynat` |
| 内生 | $`\hat{C}_t`$ | 利率敏感购买 | (F5), (F18) |
| 内生 | $`P_t`$ | Dixit-Stiglitz 价格指数 | (F20) |
| 内生 | $`p^1_t,p^2_t`$ | 当期和提前公布的重设价格 | (F7)-(F10), (F20) |
| 内生 | $`y^i_t`$ | 生产者 $`i`$ 的需求 | (F19) |
| 内生 | $`\lambda_t`$ | 名义收入边际效用 | (F2), (F3) |
| 内生 | $`\hat{Y}^{nat}_t`$ / `ynat` | 实现中的自然产出 | implementation cross-check |
| 内生 | $`\hat{r}^{nat}_t`$ / `rnat` | 实现中的自然实际利率 | implementation cross-check |
| 外生/状态 | $`\epsilon_t`$ | 论文 VAR 系统中的货币政策冲击 | (F16), (F24) |
| 外生/状态 | $`\hat{G}_t`$ / `g` | 自主支出扰动 | (F6), (F18), (F25), implementation AR(1) |
| 外生/状态 | $`\hat{Y}^s_t`$ | 自然产出/供给扰动 | (F12), (F26) |
| 外生/状态 | $`u_t`$ / `u` | MMB 实现中的成本推动扰动 | implementation cross-check |
| Varexo | `u_` | 成本推动创新 | implementation cross-check |
| Varexo | `g_` | 自主支出创新 | implementation cross-check |
| 参数 | $`\beta`$ / `beta` | 贴现因子 | (F2)-(F4) |
| 参数 | $`\sigma`$ / `sigma` | 利率敏感性/逆弹性参数 | (F5), (F6), (F11), (F12), (F26) |
| 参数 | $`\alpha`$ / `alpha` | Calvo 不重设概率 | (F7), (F8), (F10), (F14), (F20) |
| 参数 | $`\gamma`$ | 重设者中立即生效的比例 | (F7)-(F9), (F20) |
| 参数 | $`\psi`$ | 提前定价时序组合 $`(1-\gamma)/(\gamma\alpha)`$ | (F9) |
| 参数 | $`\theta`$ / `theta` | CES 需求弹性 | (F10), (F14), (F19), (F20) |
| 参数 | $`\omega`$ / `omega` | 边际负效用/边际成本对产出的弹性 | (F10)-(F14), (F26) |
| 参数 | $`\kappa`$ / `kappa` | NK 总供给斜率 | (F13)-(F15) |
| 参数 | $`\rho_u,\rho_g`$ / `rhou`, `rhog` | 实现中的冲击持续性 | implementation cross-check |
| 参数 | $`\phi_\pi,\phi_x`$ / `phipi`, `phix` | 实现中的 Taylor 规则系数 | implementation cross-check |

**方程数说明**：来源支持的档案条件为 (F1)-(F27)。Rep-MMB 实现是简化 `model(linear)` 交叉检查，包含 8 个内生变量和 8 条实现方程；它不作为论文侧来源处理。
