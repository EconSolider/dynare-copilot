# NK_RW97AL -- 推导（最优化问题与一阶条件）

> 本推导是 MMB 条目 `NK_RW97AL` 的 source-backed archive 初稿，不是已经运行验证的 Dynare 复现。论文侧来源是 Rotemberg and Woodford (1997), "An Optimization-Based Econometric Framework for the Evaluation of Monetary Policy," NBER Macroeconomics Annual 12, pp. 297-346, DOI `10.1086/654340`。

## 1. Model Overview

- **模型**：一个用于评估货币政策规则的小型封闭经济 New Keynesian 模型，围绕美国季度产出、通胀和联邦基金利率估计。
- **核心机制**：带有提前决定的利率敏感支出的跨期总需求、垄断竞争、以及带有一季度和两季度定价决策滞后的 Calvo 式错列调价。
- **主体**：代表性家庭选择消费和金融索取权；差异化供给者在外生调价机会和决策滞后下设定价格；货币当局设定短期名义利率；自主支出和自然产出扰动概括真实冲击。
- **形式**：围绕零通胀稳态的对数线性近似。未执行运行时验证。
- **变体说明**：MMB 实现交叉检查文件为 `NK_RW97_rep.mod`，其中实现的是紧凑的 Woodford 式线性版本。该文件只用作 `implementation_cross_check`。

下文使用的方程标签：(F1), (F2), (F3), (F4), (F5), (F6), (F7), (F8), (F9), (F10), (F11), (F12), (F13), (F14), (F15), (F16), (F17), (F18), (F19), (F20), (F21), (F22), (F23), (F24), (F25), (F26), (F27), (F28), (F29), (F30), (F31), (F32), (F33), (F34), (F35), (F36), (F37), (F38), (F39), (F40), and (F41).

## 2. Optimization Problems

### 2.1 家庭

代表性家庭从复合消费指数获得效用，并从生产差异化商品承受负效用。与来源一致的紧凑表述为：

$$
\max_{\{C_t^i,\{y_t^i(z)\}_{z \in [0,1]},\text{claims}\}}
E_0 \sum_{t=0}^{\infty} \beta^t
\left[u(C_t^i;\xi_t)-\int_0^1 v(y_t^i(z);\xi_t)\,dz\right].
$$

消费聚合器为

$$
C_t^i=\left(\int_0^1 c_t^i(z)^{(\theta-1)/\theta}\,dz\right)^{\theta/(\theta-1)}.
\tag{F1}
$$

在给定消费指数下的成本最小化给出商品 $z$ 的需求：

$$
c_t^i(z)=C_t^i\left(\frac{p_t(z)}{P_t}\right)^{-\theta}.
\tag{F2}
$$

相应的价格指数为

$$
P_t=\left(\int_0^1 p_t(z)^{1-\theta}\,dz\right)^{1/(1-\theta)}.
\tag{F3}
$$

家庭交易状态依存金融索取权。若 $\delta_{t,T}$ 是日期 $t$ 到 $T$ 的随机贴现因子，则一期名义利率满足

$$
R_t=(E_t \delta_{t,t+1})^{-1}.
\tag{F4}
$$

论文的时序约定中，利率敏感支出 $C_t^i$ 提前两个季度决定。最优购买条件为

$$
E_t u'(C_{t+2}^i;\xi_{t+2})
=E_t(\lambda_{t+2}^i P_{t+2}).
\tag{F5}
$$

名义收入边际效用满足跨期资产定价条件

$$
\lambda_t^i\delta_{t,T}=\beta^{T-t}\lambda_T^i,\qquad T\ge t.
\tag{F6}
$$

在完全保险掉异质定价收入风险后，家庭共享同一个 $\lambda_t$，一期 Euler 限制为

$$
\lambda_t=\beta E_t(R_t\lambda_{t+1}).
\tag{F7}
$$

### 2.2 定价供给者

每个供给者面对总需求

$$
y_t(i)=Y_t\left(\frac{p_t(i)}{P_t}\right)^{-\theta}.
\tag{F8}
$$

每期有比例 $1-\alpha$ 的供给者可以选择新价格。在调价者中，比例 $\gamma$ 在当期收取新价格，比例 $1-\gamma$ 还要再提前一个季度公布价格。若在期间 $t$ 生效的价格基于期间 $t-i$ 信息选择，则供给者选择 $p_t^i$ 以最大化

$$
E_{t-i}\Phi_t(p),
\quad
\Phi_t(p)=\sum_{j=0}^{\infty}(\alpha\beta)^j
\left[
\lambda_{t+j}(1-\tau)pY_{t+j}\left(\frac{p}{P_{t+j}}\right)^{-\theta}
-v\!\left(Y_{t+j}\left(\frac{p}{P_{t+j}}\right)^{-\theta};\xi_{t+j}\right)
\right].
\tag{F9}
$$

价格设定的一阶条件为

$$
E_{t-i}\Phi_t'(p_t^i)=0,\qquad i\in\{1,2\}.
\tag{F10}
$$

## 3. First-Order Conditions

论文使用对数线性近似。除非另有说明，帽子变量表示相对于零通胀稳态的对数偏离。

由 (F7)，边际效用条件的对数线性形式为

$$
\hat{\lambda}_t=E_t(\hat{R}_t-\hat{\pi}_{t+1}+\hat{\lambda}_{t+1}).
\tag{F11}
$$

向前求解定义长期实际利率：

$$
\hat{r}_t^l\equiv
\sum_{T=t}^{\infty}E_t(\hat{R}_T-\hat{\pi}_{T+1}).
\tag{F12}
$$

提前决定购买条件的对数线性化给出

$$
-\tilde{\sigma}\,E_t(\hat{C}_{t+2}-\bar{C}_{t+2})
=E_t\hat{r}_{t+2}^l.
\tag{F13}
$$

总需求为

$$
Y_t=C_t+G_t.
\tag{F14}
$$

结合 (F13) 与 (F14) 得到来源中的 IS 方程：

$$
\hat{Y}_t=-\sigma^{-1}E_{t-2}\hat{r}_t^l+\hat{G}_t.
\tag{F15}
$$

含两类新生效价格的价格指数为

$$
P_t=\left[
\alpha P_{t-1}^{1-\theta}
+(1-\alpha)\gamma(p_t^1)^{1-\theta}
+(1-\alpha)(1-\gamma)(p_t^2)^{1-\theta}
\right]^{1/(1-\theta)}.
\tag{F16}
$$

对数线性化后，总通胀满足

$$
\hat{\pi}_t=\gamma \hat{X}_t^1+(1-\gamma)\hat{X}_t^2,
\quad
\hat{X}_t^i\equiv\frac{1-\alpha}{\alpha}\log\left(\frac{p_t^i}{P_t}\right).
\tag{F17}
$$

提前一季度定价者与提前两季度定价者之间的关系为

$$
\hat{X}_t^2=E_{t-2}\hat{X}_t^1
-\frac{1-\alpha}{\alpha}(\hat{\pi}_t-E_{t-2}\hat{\pi}_t).
\tag{F18}
$$

令 $\hat{X}_t\equiv\hat{X}_t^1$ 且 $\psi\equiv(1-\gamma)/(\gamma\alpha)$。总价格关系变为

$$
\hat{\pi}_t=\frac{1}{1+\psi}\hat{X}_t
+\frac{\psi}{1+\psi}E_{t-2}\hat{\pi}_t.
\tag{F19}
$$

对基于期间 $t-1$ 信息选择的价格的一阶条件进行对数线性化，得到现值定价条件：

$$
\begin{aligned}
E_{t-1}\sum_{j=0}^{\infty}(\alpha\beta)^j
\Bigg[
&(1+\omega\theta)
\left(\frac{\alpha}{1-\alpha}\hat{X}_t-\sum_{s=1}^j\hat{\pi}_{t+s}\right)\\
&-(\omega+\sigma)(\hat{Y}_{t+j}-\hat{Y}_{t+j}^s)
\Bigg]
=-\phi_{t-1}.
\end{aligned}
\tag{F20}
$$

利率/边际效用修正项为

$$
\phi_t=E_t\left[
\hat{R}_{t+1}-\hat{\pi}_{t+2}
-\sigma(\hat{Y}_{t+2}-\hat{G}_{t+2}-\hat{Y}_{t+1}+\hat{G}_{t+1})
\right].
\tag{F21}
$$

来源将自然产出扰动定义为

$$
\hat{Y}_t^s=
\frac{\omega}{\omega+\sigma}E_{t-1}\bar{Y}_t
+\frac{\sigma}{\omega+\sigma}\hat{G}_t.
\tag{F22}
$$

对 (F20) 作准差分得到总供给关系：

$$
\hat{X}_t=\beta E_{t-1}\hat{X}_{t+1}
+\kappa(\hat{Y}_t-\hat{Y}_t^s)
-\frac{\kappa}{\omega+\sigma}\phi_{t-1}.
\tag{F23}
$$

斜率系数为

$$
\kappa=
\frac{(1-\alpha)(1-\alpha\beta)(\omega+\sigma)}
{\alpha(1+\omega\theta)}.
\tag{F24}
$$

在 $t-2$ 信息条件下，(F19) 与 (F23) 推出 New Keynesian Phillips curve 形式：

$$
E_{t-2}\hat{\pi}_t
=\kappa E_{t-2}(\hat{Y}_t-\hat{Y}_t^s)
+\beta E_{t-2}\hat{\pi}_{t+1}.
\tag{F25}
$$

## 4. Market Clearing & Identities

商品市场恒等式就是总需求 (F14)。来源模型没有投资或资本积累；论文明确指出缺少投资与资本是模型限制。

用于刻画历史政策的货币政策反馈规则为

$$
r_t=r^*
+\sum_{k=1}^{n_r}\mu_k(r_{t-k}-r^*)
+\sum_{k=0}^{n_\pi}\phi_k(\pi_{t-k}-\pi^*)
+\sum_{k=0}^{n_y}\theta_k y_{t-k}
+\epsilon_t.
\tag{F26}
$$

论文还评估如下 Taylor 式简单规则

$$
r_t=\theta_\pi\pi_t+\theta_y y_t.
\tag{F27}
$$

用于识别政策冲击的 VAR 状态向量为

$$
Z_t=[r_t,\pi_{t+1},y_{t+1}]'.
\tag{F28}
$$

估计的递归 VAR 表示为

$$
T\bar{Z}_t=A\bar{Z}_{t-1}+\bar{e}_t.
\tag{F29}
$$

货币政策冲击恢复为

$$
\epsilon_t=i_1'(\bar{Z}_t-B\bar{Z}_{t-1}).
\tag{F30}
$$

在紧凑 MMB 实现交叉检查中，线性状态使用产出缺口 $x_t=y_t-y_t^{nat}$：

$$
x_t=y_t-y_t^{nat}.
\tag{F31}
$$

该恒等式来自 `.mod` 实现，只记录为 `implementation_cross_check`，不作为额外的论文侧来源方程。

## 5. Exogenous Processes

论文从 VAR 表示中构造真实扰动，而不是在论文侧模型中施加简单的标量 AR(1) 法则。两个结构真实扰动是自主支出 $\hat{G}_t$ 和自然产出 $\hat{Y}_t^s$。

将结构方程代入 VAR 记号后，来源将结构限制写为

$$
M'\tilde{Z}_t-N'\sum_{j=1}^{\infty}E_{t-1}\tilde{Z}_{t+j}
=\hat{G}_{t+1}.
\tag{F32}
$$

自然产出限制为

$$
P'E_{t-1}\tilde{Z}_t+R'E_t\tilde{Z}_{t+1}
=\hat{Y}_{t+1}^s
+\frac{\sigma}{\sigma+\omega}E_t(\hat{G}_{t+2}-\hat{G}_{t+1}).
\tag{F33}
$$

真实冲击向量重构为

$$
s_t\equiv[\hat{G}_{t+1},\hat{Y}_{t+1}^s]'
=C\bar{Z}_{t-1}+D\bar{e}_t.
\tag{F34}
$$

紧凑 MMB 实现则使用两个 AR(1) 过程：

$$
u_t=\rho_u u_{t-1}+\varepsilon^u_t.
\tag{F35}
$$

$$
g_t=\rho_g g_{t-1}+\varepsilon^g_t.
\tag{F36}
$$

方程 (F35)-(F36) 只是实现交叉检查方程。它们帮助说明简化的 `model(linear)` MMB 表示，但不作为论文侧冲击过程陈述。

## 6. Steady-State Solution

本推导采用对数线性形式。因此 Dynare 式线性实现中所有帽子变量与产出缺口的稳态均为零：

$$
\bar{\pi}=\bar{y}=\bar{y}^{nat}=\bar{r}^{nat}=\bar{i}=\bar{x}=\bar{u}=\bar{g}=0.
\tag{F37}
$$

来源中的非帽子稳态是零通胀平稳均衡。关键来源规范化为：

$$
\Pi=1,\qquad \hat{\pi}_t=0,\qquad \hat{Y}_t=0,\qquad \hat{G}_t=0,\qquad \hat{Y}_t^s=0.
\tag{F38}
$$

贴现因子钉住稳态实际回报：

$$
\beta^{-1}=1+\rho.
\tag{F39}
$$

对于实现交叉检查，自然利率和自然产出公式为：

$$
r_t^{nat}
=\sigma^{-1}\left[(g_t-y_t^{nat})-(g_{t+1}-y_{t+1}^{nat})\right].
\tag{F40}
$$

$$
y_t^{nat}
=\frac{\sigma^{-1}g_t}{\sigma^{-1}+\omega}.
\tag{F41}
$$

最后两个方程与实现文件以及来源中的紧凑自然利率逻辑一致，但论文侧的真实扰动推导比两个 AR(1) 实现更丰富。

## 7. Timing & Form Conventions

- **形式**：对数线性；实现交叉检查中为 `model(linear)`。
- **通胀时序**：论文的 VAR 状态为 $Z_t=[r_t,\pi_{t+1},y_{t+1}]'$，反映决策滞后时序。一些在期间 $t+1$ 观测的变量被视作由期间 $t$ 信息决定。
- **家庭购买**：复合利率敏感支出 $C_t^i$ 提前两个季度选择；执行该指数所需的单个商品购买稍后依赖单个商品价格。
- **价格设定**：比例 $1-\alpha$ 的企业可以选择新价格。其中比例 $\gamma$ 当期收取该价格，比例 $1-\gamma$ 提前一个季度公布。
- **存量与资本**：来源模型和紧凑实现中都没有资本存量状态变量。
- **利率**：论文的数据讨论在若干地方使用年化利率和通胀率，而结构方程为季度对数线性方程。
- **不确定性标记**：方程 (F32)-(F34) 来自 OCR 噪声较重的矩阵表达式，标记为 `needs_review`，需要来源级公式审计。

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | 含义 | Equation reference |
|---|---|---|---|
| Endogenous | `pi`, $\hat{\pi}_t$ | 通胀 | (F17), (F19), (F25) |
| Endogenous | `y`, $\hat{Y}_t$ | 产出偏离 | (F15), (F23) |
| Endogenous | `ynat`, $\hat{Y}_t^s$ | 自然产出/供给扰动 | (F22), implementation (F41) |
| Endogenous | `rnat`, $r_t^{nat}$ | 自然实际利率 | implementation (F40) |
| Endogenous | `i` / `r`, $r_t$ | 短期名义政策利率 | (F26), (F27) |
| Endogenous | `x`, $x_t$ | 产出缺口 | implementation (F31) |
| Endogenous | $\hat{r}_t^l$ | 长期实际利率 | (F12), (F15) |
| Endogenous | $\lambda_t$ | 名义收入边际效用 | (F7), (F11) |
| Endogenous | $\hat{X}_t$ | 相对重设价格指数 | (F19), (F23) |
| Exogenous | `u`, $u_t$ | 实现中的成本推动/通胀扰动 | implementation (F35) |
| Exogenous | `g`, $g_t$ / $\hat{G}_t$ | 自主支出扰动 | (F15), (F32), implementation (F36) |
| Exogenous | `u_`, $\varepsilon^u_t$ | 通胀/成本推动创新 | implementation (F35) |
| Exogenous | `g_`, $\varepsilon^g_t$ | 自主支出创新 | implementation (F36) |
| Exogenous | $\epsilon_t$ | 货币政策冲击 | (F26), (F30) |
| Parameter | `beta`, $\beta$ | 贴现因子 | (F6), (F7), (F39) |
| Parameter | `sigma`, $\sigma$ | 利率敏感度/跨期弹性倒数复合参数 | (F13), (F15) |
| Parameter | `alpha`, $\alpha$ | Calvo 价格保持不变概率 | (F16), (F24) |
| Parameter | `theta`, $\theta$ | 替代弹性/需求弹性 | (F1)-(F3), (F8), (F24) |
| Parameter | `omega`, $\omega$ | 边际负效用/边际成本对产出的弹性 | (F20), (F22), (F24) |
| Parameter | `kappa`, $\kappa$ | Phillips 曲线斜率 | (F23), (F24), (F25) |
| Parameter | `rhou`, $\rho_u$ | 实现中成本推动冲击持久性 | (F35) |
| Parameter | `rhog`, $\rho_g$ | 实现中支出冲击持久性 | (F36) |
| Parameter | `phipi`, $\phi_\pi$ | 政策对通胀的反应 | (F27) |
| Parameter | `phix`, $\phi_x$ | 政策对产出缺口的反应 | implementation policy rule |

初稿状态：`needs_review`。主要未解决问题是 OCR 矩阵方程 (F32)-(F34) 的来源级检查、论文侧 VAR 冲击重构和紧凑 MMB AR(1) 实现之间的区分，以及未执行运行时验证。
