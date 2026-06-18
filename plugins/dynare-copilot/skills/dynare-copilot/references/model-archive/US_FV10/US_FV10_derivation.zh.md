# US_FV10 -- 推导（最优化问题 + 一阶条件）

> 归档状态：`needs_review`。本一轮推导以 Fernández-Villaverde (2010) 的 MinerU Markdown 为来源支撑。本地 `.mod` 实现中的方程仅作为 `implementation_cross_check` 使用；未执行 Dynare 运行验证。

## 1. Model Overview

- **模型**：`US_FV10`，Jesús Fernández-Villaverde (2010) "The Econometrics of DSGE Models" 中的基准估计 DSGE 应用，DOI `10.1007/s13209-009-0014-7`。
- **用途**：带真实和名义刚性的美国中等规模新凯恩斯 DSGE 估计模型，论文用它展示贝叶斯 DSGE 估计。
- **主体与模块**：家庭具有外部习惯、货币效用、完全市场、资本积累、利用率、差异化劳动和 Calvo 工资设定；最终品聚合商；中间品企业具有 Cobb-Douglas 生产、固定成本、Calvo 价格设定和指数化；货币当局采用 Taylor 规则。
- **冲击**：偏好、劳动负效用、中性技术、投资特定技术和货币政策冲击。
- **模型形式**：论文给出非线性均衡条件，随后用随机趋势缩放非平稳变量，并在确定性稳态附近做对数线性化求解。Rep-MMB `.mod` 交叉检查实现的是平稳化后的非线性方程并调用一阶扰动，不是 `model(linear)`。
- **来源说明**：MMB 实现注释称方程在 Fernández-Villaverde and Rubio-Ramírez (2006) 中有更详细描述，而 2010 年论文提供模型概要和估计校准。本归档条目不把 `.mod` 文件当作论文侧数学来源。

## 2. Optimization Problems

### 2.1 家庭

家庭选择消费、货币、债券、Arrow 证券、投资、利用率、资本、劳动和重置工资。其单期效用包含习惯调整后的对数消费、货币服务和劳动负效用：

```math
E_0 \sum_{t=0}^{\infty}\beta^t d_t
\left[
\log(c_{jt}-h c_{j,t-1})
+ \upsilon\log\left(\frac{m_{jt}}{p_t}\right)
-\varphi_t\psi\frac{l_{jt}^{1+\vartheta}}{1+\vartheta}
\right].
```

预算约束为：

```math
\begin{aligned}
c_{jt}+x_{jt}+\frac{m_{jt}}{p_t}+\frac{b_{jt+1}}{p_t}
+\int q_{j,t+1,t}a_{j,t+1}\,d\omega_{j,t+1,t}
&=w_{jt}l_{jt}+\left(r_tu_{jt}-\mu_t^{-1}\Phi[u_{jt}]\right)k_{j,t-1}\\
&\quad+\frac{m_{j,t-1}}{p_t}+R_{t-1}\frac{b_{jt}}{p_t}
+a_{jt}+T_t+F_t .
\end{aligned}
```

资本运动方程为：

```math
k_{jt}=(1-\delta)k_{j,t-1}
+\mu_t\left(1-S\left[\frac{x_{jt}}{x_{j,t-1}}\right]\right)x_{jt}.
```

工资设定者面对 Calvo 刚性。可重设工资的家庭求解：

```math
\max_{w_{jt}} E_t\sum_{\tau=0}^{\infty}(\beta\theta_w)^\tau
\left[
-d_{t+\tau}\varphi_{t+\tau}\psi\frac{l_{j,t+\tau}^{1+\vartheta}}{1+\vartheta}
+\lambda_{t+\tau}
\prod_{s=1}^{\tau}\frac{\Pi_{t+s-1}^{\chi_w}}{\Pi_{t+s}}
w_{jt}l_{j,t+\tau}
\right],
```

约束为劳动需求：

```math
l_{j,t+\tau}=
\left(
\prod_{s=1}^{\tau}\frac{\Pi_{t+s-1}^{\chi_w}}{\Pi_{t+s}}
\frac{w_{jt}}{w_{t+\tau}}
\right)^{-\eta}l^d_{t+\tau}.
```

### 2.2 劳动聚合商

竞争性劳动聚合商聚合差异化劳动：

```math
l_t^d=\left(\int_0^1 l_{jt}^{\frac{\eta-1}{\eta}}\,dj\right)^{\frac{\eta}{\eta-1}},
```

并最大化：

```math
\max_{\{l_{jt}\}} w_tl_t^d-\int_0^1 w_{jt}l_{jt}\,dj.
```

### 2.3 最终品生产者

最终品生产者聚合中间品：

```math
y_t^d=\left(\int_0^1 y_{it}^{\frac{\varepsilon-1}{\varepsilon}}\,di\right)^{\frac{\varepsilon}{\varepsilon-1}},
```

并在给定中间品价格和最终品价格下最大化利润。

### 2.4 中间品生产者

给定投入价格，每个中间品生产者先最小化成本：

```math
\min_{l^d_{it},k_{i,t-1}} w_tl^d_{it}+r_tk_{i,t-1}
```

约束为：

```math
y_{it}=A_t k_{i,t-1}^{\alpha}(l^d_{it})^{1-\alpha}-\phi z_t .
```

同一企业随后在 Calvo 刚性和价格指数化下设定价格：

```math
\max_{p_{it}} E_t\sum_{\tau=0}^{\infty}(\beta\theta_p)^\tau
\frac{\lambda_{t+\tau}}{\lambda_t}
\left[
\left(
\prod_{s=1}^{\tau}\Pi_{t+s-1}^{\chi}\frac{p_{it}}{p_{t+\tau}}
-mc_{t+\tau}
\right)y_{i,t+\tau}
\right],
```

约束为：

```math
y_{i,t+\tau}=
\left(
\prod_{s=1}^{\tau}\Pi_{t+s-1}^{\chi}\frac{p_{it}}{p_{t+\tau}}
\right)^{-\varepsilon}y^d_{t+\tau}.
```

### 2.5 货币当局

货币当局是机械规则而非优化主体。Taylor 规则列在第 5 节。

## 3. First-Order Conditions

- **(F1) 习惯调整的消费边际效用**（`needs_review`：OCR 中后续重复的总量方程似乎在习惯项内漏掉了 `t+1` 下标；较早的家庭 FOC 内部一致）：

```math
d_t(c_t-hc_{t-1})^{-1}
-h\beta E_t\left[d_{t+1}(c_{t+1}-hc_t)^{-1}\right]
=\lambda_t .
```

- **(F2) 名义债券欧拉方程**：

```math
\lambda_t=\beta E_t\left[\lambda_{t+1}\frac{R_t}{\Pi_{t+1}}\right].
```

- **(F3) 资本利用率**：

```math
r_t=\mu_t^{-1}\Phi'[u_t].
```

- **(F4) Tobin's Q / 资本欧拉方程**：

```math
q_t=\beta E_t\left[
\frac{\lambda_{t+1}}{\lambda_t}
\left((1-\delta)q_{t+1}+r_{t+1}u_{t+1}-\mu_{t+1}^{-1}\Phi[u_{t+1}]\right)
\right].
```

- **(F5) 投资调整成本 FOC**：

```math
\begin{aligned}
1&=q_t\mu_t
\left(
1-S\left[\frac{x_t}{x_{t-1}}\right]
-S'\left[\frac{x_t}{x_{t-1}}\right]\frac{x_t}{x_{t-1}}
\right)\\
&\quad+\beta E_t\left[
q_{t+1}\mu_{t+1}\frac{\lambda_{t+1}}{\lambda_t}
S'\left[\frac{x_{t+1}}{x_t}\right]\left(\frac{x_{t+1}}{x_t}\right)^2
\right].
\end{aligned}
```

- **(F6) 工资递归的定价侧**：

```math
f^1_t=\frac{\eta-1}{\eta}(w_t^{\ast})^{1-\eta}\lambda_t w_t^\eta l^d_t
+\beta\theta_w E_t\left[
\left(\frac{\Pi_t^{\chi_w}}{\Pi_{t+1}}\right)^{1-\eta}
\left(\frac{w^{\ast}_{t+1}}{w^{\ast}_t}\right)^{\eta-1}f^1_{t+1}
\right].
```

- **(F7) 工资递归的劳动负效用侧**：

```math
f^2_t=\psi d_t\varphi_t\left(\frac{w_t}{w_t^{\ast}}\right)^{\eta(1+\vartheta)}(l^d_t)^{1+\vartheta}
+\beta\theta_w E_t\left[
\left(\frac{\Pi_t^{\chi_w}}{\Pi_{t+1}}\right)^{-\eta(1+\vartheta)}
\left(\frac{w^{\ast}_{t+1}}{w^{\ast}_t}\right)^{\eta(1+\vartheta)}f^2_{t+1}
\right].
```

- **(F8) 最优工资条件**：

```math
f^1_t=f^2_t.
```

- **(F9) 中间品企业成本最小化投入比例**：

```math
\frac{k_{i,t-1}}{l^d_{it}}=\frac{\alpha}{1-\alpha}\frac{w_t}{r_t}.
```

- **(F10) 实际边际成本**：

```math
mc_t=
\left(\frac{1}{1-\alpha}\right)^{1-\alpha}
\left(\frac{1}{\alpha}\right)^\alpha
\frac{w_t^{1-\alpha}r_t^\alpha}{A_t}.
```

- **(F11) Calvo 价格递归 1**：

```math
g^1_t=\lambda_tmc_ty^d_t+
\beta\theta_p E_t\left[
\left(\frac{\Pi_t^\chi}{\Pi_{t+1}}\right)^{-\varepsilon}g^1_{t+1}
\right].
```

- **(F12) Calvo 价格递归 2**：

```math
g^2_t=\lambda_t\Pi^{\ast}_t y^d_t+
\beta\theta_p E_t\left[
\left(\frac{\Pi_t^\chi}{\Pi_{t+1}}\right)^{1-\varepsilon}
\left(\frac{\Pi^{\ast}_t}{\Pi^{\ast}_{t+1}}\right)g^2_{t+1}
\right].
```

- **(F13) 最优重置价格条件**：

```math
\varepsilon g^1_t=(\varepsilon-1)g^2_t.
```

## 4. Market Clearing & Identities

- **(F14) 资本积累**：

```math
k_t=(1-\delta)k_{t-1}
+\mu_t\left(1-S\left[\frac{x_t}{x_{t-1}}\right]\right)x_t .
```

- **(F15) 差异化劳动需求**：

```math
l_{jt}=\left(\frac{w_{jt}}{w_t}\right)^{-\eta}l^d_t.
```

- **(F16) 总工资指数**：

```math
w_t=\left(\int_0^1 w_{jt}^{1-\eta}\,dj\right)^{\frac{1}{1-\eta}}.
```

- **(F17) 实际工资运动方程**：

```math
w_t^{1-\eta}=
\theta_w\left(\frac{\Pi_{t-1}^{\chi_w}}{\Pi_t}\right)^{1-\eta}w_{t-1}^{1-\eta}
+(1-\theta_w)(w_t^{\ast})^{1-\eta}.
```

- **(F18) 最终品对中间品的需求**：

```math
y_{it}=\left(\frac{p_{it}}{p_t}\right)^{-\varepsilon}y^d_t.
```

- **(F19) 总价格指数**：

```math
p_t=\left(\int_0^1 p_{it}^{1-\varepsilon}\,di\right)^{\frac{1}{1-\varepsilon}}.
```

- **(F20) Calvo 价格指数方程**：

```math
1=\theta_p\left(\frac{\Pi_{t-1}^{\chi}}{\Pi_t}\right)^{1-\varepsilon}
+(1-\theta_p)(\Pi^{\ast}_t)^{1-\varepsilon}.
```

- **(F21) Taylor 规则**：

```math
\frac{R_t}{R}=
\left(\frac{R_{t-1}}{R}\right)^{\gamma_R}
\left[
\left(\frac{\Pi_t}{\Pi}\right)^{\gamma_\Pi}
\left(\frac{(y^d_t/y^d_{t-1})}{\Lambda_z}\right)^{\gamma_y}
\right]^{1-\gamma_R}
\exp(m_t).
```

- **(F22) 总需求**：

```math
y^d_t=c_t+x_t+\mu_t^{-1}\Phi[u_t]k_{t-1}.
```

- **(F23) 带价格离散项的总供给**：

```math
y_t=
\frac{A_t(u_tk_{t-1})^\alpha(l^d_t)^{1-\alpha}-\phi z_t}{v^p_t}.
```

- **(F24) 劳动聚合与工资离散项**：

```math
l^d_t=\frac{l_t}{v^w_t}.
```

- **(F25) 价格离散项**：

```math
v^p_t=
\theta_p\left(\frac{\Pi_{t-1}^{\chi}}{\Pi_t}\right)^{-\varepsilon}v^p_{t-1}
+(1-\theta_p)(\Pi^{\ast}_t)^{-\varepsilon}.
```

- **(F26) 工资离散项**：

```math
v^w_t=
\theta_w\left(\frac{w_{t-1}}{w_t}\frac{\Pi_{t-1}^{\chi_w}}{\Pi_t}\right)^{-\eta}v^w_{t-1}
+(1-\theta_w)(\Pi^{\astw}_t)^{-\eta}.
```

- **(F27) 复合随机趋势**（`needs_review`：OCR 在正文中包含一个重复的指数片段；公式按相邻展示方程和 `.mod` 交叉检查重构）：

```math
z_t=A_t^{\frac{1}{1-\alpha}}\mu_t^{\frac{\alpha}{1-\alpha}}.
```

- **(F28) 复合增长率**：

```math
z_t=z_{t-1}\exp(\Lambda_z+z_{z,t}),\qquad
z_{z,t}=\frac{z_{A,t}+\alpha z_{\mu,t}}{1-\alpha},\qquad
\Lambda_z=\frac{\Lambda_A+\alpha\Lambda_\mu}{1-\alpha}.
```

## 5. Exogenous Processes

- **(F29) 中性技术**：

```math
A_t=A_{t-1}\exp(\Lambda_A+z_{A,t}),\qquad
z_{A,t}=\sigma_A\varepsilon_{A,t},\qquad
\varepsilon_{A,t}\sim\mathcal{N}(0,1).
```

- **(F30) 投资特定技术**（`needs_review`：2010 Markdown 通过复合趋势以及 Table 1/Table 3 暗示 $`\mu_t`$ 过程，但展示方程不如 $`A_t`$ 的方程明确）：

```math
\mu_t=\mu_{t-1}\exp(\Lambda_\mu+z_{\mu,t}),\qquad
z_{\mu,t}=\sigma_\mu\varepsilon_{\mu,t}.
```

- **(F31) 货币政策创新**：

```math
m_t=\sigma_m\varepsilon_{m,t},\qquad \varepsilon_{m,t}\sim\mathcal{N}(0,1).
```

- **(F32) 偏好冲击**（`implementation_cross_check`；论文表格列出 $`\rho_d`$ 与 $`\sigma_d`$，本地 `.mod` 实现为该平稳 AR(1)）：

```math
\log d_t=\rho_d\log d_{t-1}+\sigma_d\varepsilon_{d,t}.
```

- **(F33) 劳动负效用冲击**（`implementation_cross_check`；论文表格列出 $`\rho_\varphi`$ 与 $`\sigma_\varphi`$，本地 `.mod` 实现为该平稳 AR(1)）：

```math
\log\varphi_t=\rho_\varphi\log\varphi_{t-1}+\sigma_\varphi\varepsilon_{\varphi,t}.
```

## 6. Steady-State Solution

论文说明，求解模型前要用随机趋势缩放变量。对任意随复合趋势增长的变量 $`x_t`$，定义 $`\tilde{x}_t=x_t/z_t`$。论文也说明若干例外：

```math
\tilde r_t=r_t\mu_t,\qquad \tilde q_t=q_t\mu_t,\qquad
\tilde k_t=\frac{k_t}{z_t\mu_t}.
```

在平稳系统的确定性稳态：

```math
E[\varepsilon_{A,t}]=E[\varepsilon_{\mu,t}]=E[\varepsilon_{m,t}]
=E[\varepsilon_{d,t}]=E[\varepsilon_{\varphi,t}]=0,
\qquad d=\varphi=1.
```

平衡增长率为：

```math
\Lambda_z=\frac{\Lambda_A+\alpha\Lambda_\mu}{1-\alpha}.
```

论文记录并被 MMB 实现使用的估计/固定值包括：

```math
\delta=0.025,\quad \varepsilon=10,\quad \eta=10,\quad \phi=0,\quad \Phi_2=0.001,
```

以及后验中位数，例如：

```math
\beta=0.998,\; h=0.97,\; \psi=8.92,\; \vartheta=1.17,\;
\kappa=9.51,\; \alpha=0.21,\; \theta_p=0.82,\; \chi=0.63,\;
\theta_w=0.68,\; \chi_w=0.62.
```

未来若写 `steady_state_model`，应在将变量替换为其平稳化对应项并把冲击设为零之后，求解 (F1)-(F33) 所隐含的平稳非线性系统。抽取的 Markdown 中没有提供完整闭式稳态算法，所以本一轮归档把闭式稳态标为 `needs_review`。本地 `.mod` 显示若干稳态对象在外部 steady-state 文件中赋值，而不是在该 `.mod` 中赋值：$`\gamma_1`$、$`R`$、$`\Lambda_{Yd}`$ 和 $`\Lambda_x`$。

运行验证：未执行。未运行 Dynare。

## 7. Timing & Form Conventions

- **资本时序**：论文生产函数使用 $`k_{i,t-1}`$，资本运动方程把当期投资映射到 $`k_t`$；资本是用于下一期生产、在生产中滞后一阶使用的预定存量。
- **增长和平稳化**：中性技术 $`A_t`$ 与投资特定技术 $`\mu_t`$ 产生单位根。变量按 $`z_t=A_t^{1/(1-\alpha)}\mu_t^{\alpha/(1-\alpha)}`$ 缩放，但租金率、Tobin's Q 和资本有例外。
- **名义刚性**：工资和价格均为 Calvo，并部分指数化到滞后通胀。工资和价格离散项是状态变量。
- **利率时序**：Taylor 规则使用滞后名义利率、当期通胀，以及相对趋势增长的总需求增长。
- **求解形式**：平稳化后的非线性均衡条件在确定性稳态附近做对数线性化；本归档不应被理解为手工线性化的 `model(linear)` 规范。

## 8. Variable & Parameter Reference Table

| 类别 | 符号 / ASCII | 含义 | 主要方程 |
|---|---|---|---|
| 内生 | `c`, $`c_t`$ | 消费 | (F1), (F22) |
| 内生 | `lambda`, $`\lambda_t`$ | 边际效用 / 预算乘子 | (F1), (F2) |
| 内生 | `R`, $`R_t`$ | 名义总利率 | (F2), (F21) |
| 内生 | `PI`, $`\Pi_t`$ | 总通胀率 | (F2), (F20), (F21) |
| 内生 | `r`, $`r_t`$ | 资本租金率 | (F3), (F9), (F10) |
| 内生 | `u`, $`u_t`$ | 资本利用率 | (F3), (F23) |
| 内生 | `q`, $`q_t`$ | Tobin's marginal Q | (F4), (F5) |
| 内生 | `x`, $`x_t`$ | 投资 | (F5), (F14), (F22) |
| 内生 | `k`, $`k_t`$ | 资本存量 | (F14), (F23) |
| 内生 | `f`, $`f^1_t/f^2_t`$ | 工资递归辅助变量 | (F6)-(F8) |
| 内生 | `w`, $`w_t`$ | 实际工资 | (F16), (F17) |
| 内生 | `wstar`, $`w^{\ast}_t`$ | 重置实际工资 | (F6)-(F8), (F17) |
| 内生 | `PIstarw`, $`\Pi^{\astw}_t`$ | 最优工资通胀 / 重置工资比 | (F7), (F26) |
| 内生 | `yd`, $`y^d_t`$ | 总需求 / 需求产出 | (F11), (F12), (F18), (F21), (F22) |
| 内生 | `mc`, $`mc_t`$ | 实际边际成本 | (F10), (F11) |
| 内生 | `g1`, $`g^1_t`$ | 价格设定递归 1 | (F11), (F13) |
| 内生 | `g2`, $`g^2_t`$ | 价格设定递归 2 | (F12), (F13) |
| 内生 | `PIstar`, $`\Pi^{\ast}_t`$ | 重置价格通胀 | (F12), (F20), (F25) |
| 内生 | `vp`, $`v^p_t`$ | 价格离散项 | (F23), (F25) |
| 内生 | `vw`, $`v^w_t`$ | 工资离散项 | (F24), (F26) |
| 内生 | `ld`, $`l^d_t`$ | 总劳动需求 / 聚合劳动 | (F15), (F24) |
| 内生 | `l`, $`l_t`$ | 总劳动组合 | (F24) |
| 内生 | `mu_z`, $`z_t/z_{t-1}`$ | 复合趋势增长 | (F28) |
| 内生 | `mu_I`, $`\mu_t/\mu_{t-1}`$ | 投资特定技术增长 | (F30) |
| 内生 | `mu_A`, $`A_t/A_{t-1}`$ | 中性技术增长 | (F29) |
| 内生 | `d`, $`d_t`$ | 偏好冲击水平 | (F32) |
| 内生 | `phi`, $`\varphi_t`$ | 劳动负效用冲击水平 | (F33) |
| 内生 | `F`, $`F_t`$ | 企业利润 / 家庭预算中的转移 | 预算约束 |
| 内生 | `yg` | 产出增长观测量 | (F21), `.mod` 交叉检查 |
| 外生 | `epsd` | 偏好创新 | (F32) |
| 外生 | `epsphi` | 劳动负效用创新 | (F33) |
| 外生 | `epsmu_I` | 投资特定技术创新 | (F30) |
| 外生 | `epsA` | 中性技术创新 | (F29) |
| 外生 | `epsm` | 货币政策创新 | (F31) |
| 参数 | `h` | 习惯参数 | (F1) |
| 参数 | `betta`, $`\beta`$ | 贴现因子 | (F1)-(F7), (F11)-(F12) |
| 参数 | `delta`, $`\delta`$ | 折旧率 | (F4), (F14) |
| 参数 | `kappa`, $`\kappa`$ | 投资调整成本尺度 | 通过 $`S(\cdot)`$ |
| 参数 | `eta`, $`\eta`$ | 劳动品种替代弹性 | (F6)-(F8), (F15)-(F17), (F26) |
| 参数 | `epsilon`, $`\varepsilon`$ | 商品品种替代弹性 | (F11)-(F13), (F18)-(F20), (F25) |
| 参数 | `varpsi`, $`\psi`$ | 劳动负效用尺度 | (F7) |
| 参数 | `gammma`, $`\vartheta`$ | Frisch 弹性倒数 | (F7) |
| 参数 | `chiw`, $`\chi_w`$ | 工资指数化 | (F6), (F7), (F17), (F26) |
| 参数 | `chi`, $`\chi`$ | 价格指数化 | (F11), (F12), (F20), (F25) |
| 参数 | `thetap`, $`\theta_p`$ | Calvo 价格黏性 | (F11), (F12), (F20), (F25) |
| 参数 | `thetaw`, $`\theta_w`$ | Calvo 工资黏性 | (F6), (F7), (F17), (F26) |
| 参数 | `alppha`, $`\alpha`$ | 资本份额 | (F9), (F10), (F23), (F28) |
| 参数 | `gammmaR`, $`\gamma_R`$ | 利率平滑 | (F21) |
| 参数 | `gammmaPI`, $`\gamma_\Pi`$ | 通胀反应 | (F21) |
| 参数 | `gammmay`, $`\gamma_y`$ | 产出增长反应 | (F21) |
| 参数 | `PIbar`, $`\Pi`$ | 通胀目标 | (F21) |
| 参数 | `rhod`, `rhophi` | 冲击持久性 | (F32), (F33) |
| 参数 | `sigma_A`, `sigma_d`, `sigma_phi`, `sigma_mu`, `sigma_m` | 冲击标准差 | (F29)-(F33) |
| 参数 | `LambdaA`, `Lambdamu`, `Lambdax`, `LambdaYd` | 趋势增长项 | (F28)-(F30), `.mod` 交叉检查 |
