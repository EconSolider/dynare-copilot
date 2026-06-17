# EA_SW03 -- 推导（最优化问题 + 一阶条件）

> 私有归档的一轮抽取稿。公式状态：标注处为 `needs_review`。未执行运行时验证。

来源：Frank Smets and Rafael Wouters (2003), "An estimated dynamic stochastic general equilibrium model of the euro area", Journal of the European Economic Association, 1(5), 1123-1175。DOI：`10.1162/154247603770383415`。

## 1. Model Overview

- **模型**：`EA_SW03`，一个估计型中等规模欧元区 DSGE 模型，包含黏性价格、黏性工资、外部习惯形成、投资调整成本、可变资本利用率、垄断竞争和广义 Taylor 型货币政策规则。
- **经济体**：闭合欧元区模型，估计使用 GDP、消费、投资、价格、实际工资、就业和名义短期利率。
- **主体和模块**：差异化家庭提供垄断性劳动、消费、储蓄、出租资本服务并选择投资和利用率；最终品厂商加总中间品；中间品厂商租用资本和劳动并在部分指数化下进行 Calvo 定价；货币当局设定短期名义利率；政府支出外生。
- **冲击**：技术、劳动供给、偏好/贴现因子、投资调整成本、政府支出、价格加成、工资加成、权益/风险溢价、持久通胀目标和临时货币政策冲击。
- **形式**：论文中的结构设定是非线性的，但用于估计的模型明确写成围绕非随机稳态的对数线性偏离。MMB 实现交叉检查使用 `model(linear)`。本归档同时记录结构来源方程和线性化估计系统；一轮公式质量为 `needs_review`。

## 2. Optimization Problems

### 家庭

每类家庭 $\tau$ 选择消费、债券持有、可调整时的工资设定、资本积累和资本利用率：

$$
\max E_0\sum_{t=0}^{\infty}\beta^t U_t^\tau
$$

$$
U_t^\tau=\varepsilon_t^b\left[
\frac{(C_t^\tau-H_t)^{1-\sigma_c}}{1-\sigma_c}
-\frac{\varepsilon_t^L(\ell_t^\tau)^{1+\sigma_l}}{1+\sigma_l}
\right]
$$

预算约束为

$$
b_t\frac{B_t^\tau}{P_t}
=\frac{B_{t-1}^\tau}{P_t}+Y_t^\tau-C_t^\tau-I_t^\tau
$$

收入为

$$
Y_t^\tau=(w_t^\tau l_t^\tau+A_t^\tau)
+\left(r_t^k z_t^\tau K_{t-1}^\tau-\Psi(z_t^\tau)K_{t-1}^\tau\right)
+Div_t^\tau.
$$

外部习惯为

$$
H_t=hC_{t-1}.
$$

当家庭可以重新优化名义工资时，它在劳动需求和未来不能重新优化的 Calvo 风险下选择 $\tilde W_t^\tau$。不能重新优化的工资按滞后通胀部分指数化：

$$
W_t^\tau=\left(\frac{P_{t-1}}{P_{t-2}}\right)^{\gamma_w}W_{t-1}^\tau.
$$

家庭还在资本积累约束下选择投资和利用率：

$$
K_t=(1-\tau)K_{t-1}
+\left[1-S\left(\frac{\varepsilon_t^I I_t}{I_{t-1}}\right)\right]I_t.
$$

### 最终品厂商

完全竞争的最终品厂商加总差异化中间品：

$$
Y_t=\left[\int_0^1(y_t^j)^{1/(1+\lambda_{p,t})}dj\right]^{1+\lambda_{p,t}}.
$$

### 中间品厂商

中间品厂商 $j$ 的生产函数为

$$
y_t^j=\varepsilon_t^a\tilde K_{j,t}^{\alpha}L_{j,t}^{1-\alpha}-\Phi,
\qquad \tilde K_{j,t}=z_tK_{j,t-1}.
$$

它在给定 $W_t$ 和 $r_t^k$ 下最小化成本，并在部分指数化的 Calvo 定价下设定价格。重新优化价格 $\tilde p_t^j$ 使价格不能重设期间的未来利润贴现期望最大化。

### 货币当局和政府

货币当局遵循广义 Taylor 型反应函数。政府支出外生并进入资源约束。

## 3. First-Order Conditions

- **(F1) 消费 Euler 方程**：

$$
E_t\left[\beta\frac{\lambda_{t+1}}{\lambda_t}\frac{R_tP_t}{P_{t+1}}\right]=1.
$$

- **(F2) 消费边际效用**：

$$
\lambda_t=\varepsilon_t^b(C_t-H_t)^{-\sigma_c}.
$$

- **(F3) 工资指数化和工资设定条件**：

$$
W_t^\tau=\left(\frac{P_{t-1}}{P_{t-2}}\right)^{\gamma_w}W_{t-1}^\tau,
$$

$$
\frac{\tilde w_t}{P_t}E_t\sum_{i=0}^{\infty}\beta^i\xi_w^i
\left(\frac{(P_t/P_{t-1})^{\gamma_w}}{P_{t+i}/P_{t+i-1}}\right)
\frac{l_{t+i}^\tau U_{t+i}^C}{1+\lambda_{w,t+i}}
=E_t\sum_{i=0}^{\infty}\beta^i\xi_w^i l_{t+i}^\tau U_{t+i}^{\ell}.
$$

- **(F4) 总工资指数运动方程**：

$$
W_t^{-1/\lambda_{w,t}}
=\xi_w\left(W_{t-1}\left(\frac{P_{t-1}}{P_{t-2}}\right)^{\gamma_w}\right)^{-1/\lambda_{w,t}}
+(1-\xi_w)(\tilde w_t)^{-1/\lambda_{w,t}}.
$$

- **(F5) 已安装资本价值**：

$$
Q_t=E_t\left[\beta\frac{\lambda_{t+1}}{\lambda_t}
\left(Q_{t+1}(1-\tau)+z_{t+1}r_{t+1}^k-\Psi(z_{t+1})\right)\right].
$$

- **(F6) 投资调整成本一阶条件**（`needs_review`：OCR 将公式拆成多行）：

$$
Q_t S'\left(\frac{\varepsilon_t^I I_t}{I_{t-1}}\right)
\frac{\varepsilon_t^I I_t}{I_{t-1}}
-\beta E_t Q_{t+1}\frac{\lambda_{t+1}}{\lambda_t}
S'\left(\frac{\varepsilon_{t+1}^I I_{t+1}}{I_t}\right)
\left(\frac{\varepsilon_{t+1}^I I_{t+1}}{I_t}\right)\frac{I_{t+1}}{I_t}
+1
=Q_t\left[1-S\left(\frac{\varepsilon_t^I I_t}{I_{t-1}}\right)\right].
$$

- **(F7) 资本利用率一阶条件**：

$$
r_t^k=\Psi'(z_t).
$$

- **(F8) 成本最小化要素条件**：

$$
\frac{W_tL_{j,t}}{r_t^k\tilde K_{j,t}}=\frac{1-\alpha}{\alpha}.
$$

- **(F9) 实际边际成本**：

$$
MC_t=\frac{1}{\varepsilon_t^a}W_t^{1-\alpha}(r_t^k)^\alpha
\alpha^{-\alpha}(1-\alpha)^{-(1-\alpha)}.
$$

- **(F10) 价格设定一阶条件**：

$$
E_t\sum_{i=0}^{\infty}\beta^i\xi_p^i\lambda_{t+i}y_{t+i}^j
\left[
\frac{\tilde p_t^j}{P_t}
\left(\frac{(P_{t-1+i}/P_{t-1})^{\gamma_p}}{P_{t+i}/P_t}\right)
-(1+\lambda_{p,t+i})mc_{t+i}
\right]=0.
$$

- **(F11) 价格指数运动方程**：

$$
P_t^{-1/\lambda_{p,t}}
=\xi_p\left(P_{t-1}\left(\frac{P_{t-1}}{P_{t-2}}\right)^{\gamma_p}\right)^{-1/\lambda_{p,t}}
+(1-\xi_p)(\tilde p_t^j)^{-1/\lambda_{p,t}}.
$$

论文随后将系统线性化。以下方程是估计形式。

- **(F12) 线性化消费方程**：

$$
\hat C_t=\frac{h}{1+h}\hat C_{t-1}
+\frac{1}{1+h}E_t\hat C_{t+1}
-\frac{1-h}{(1+h)\sigma_c}(\hat R_t-E_t\hat\pi_{t+1})
+\frac{1-h}{(1+h)\sigma_c}(\hat\varepsilon_t^b-E_t\hat\varepsilon_{t+1}^b).
$$

- **(F13) 线性化投资方程**：

$$
\hat I_t=\frac{1}{1+\beta}\hat I_{t-1}
+\frac{\beta}{1+\beta}E_t\hat I_{t+1}
+\frac{\varphi}{1+\beta}\hat Q_t
-\frac{\beta E_t\hat\varepsilon_{t+1}^I-\hat\varepsilon_t^I}{1+\beta}.
$$

- **(F14) 线性化 Q 方程**：

$$
\hat Q_t=-(\hat R_t-\hat\pi_{t+1})
+\frac{1-\tau}{1-\tau+\bar r^k}E_t\hat Q_{t+1}
+\frac{\bar r^k}{1-\tau+\bar r^k}E_t\hat r_{t+1}^k+\eta_t^Q.
$$

- **(F15) 线性化资本积累**：

$$
\hat K_t=(1-\tau)\hat K_{t-1}+\tau\hat I_{t-1}.
$$

- **(F16) 线性化通胀方程**：

$$
\hat\pi_t=\frac{\beta}{1+\beta\gamma_p}E_t\hat\pi_{t+1}
+\frac{\gamma_p}{1+\beta\gamma_p}\hat\pi_{t-1}
+\frac{1}{1+\beta\gamma_p}\frac{(1-\beta\xi_p)(1-\xi_p)}{\xi_p}
\left[\alpha\hat r_t^k+(1-\alpha)\hat w_t-\hat\varepsilon_t^a+\eta_t^p\right].
$$

- **(F17) 线性化实际工资方程**：

$$
\begin{aligned}
\hat w_t={}&\frac{\beta}{1+\beta}E_t\hat w_{t+1}
+\frac{1}{1+\beta}\hat w_{t-1}
+\frac{\beta}{1+\beta}E_t\hat\pi_{t+1}
-\frac{1+\beta\gamma_w}{1+\beta}\hat\pi_t
+\frac{\gamma_w}{1+\beta}\hat\pi_{t-1} \\
&-\frac{1}{1+\beta}
\frac{(1-\beta\xi_w)(1-\xi_w)}
{\left(1+\frac{(1+\lambda_w)\sigma_L}{\lambda_w}\right)\xi_w}
\left[
\hat w_t-\sigma_L\hat L_t
-\frac{\sigma_c}{1-h}(\hat C_t-h\hat C_{t-1})
-\hat\varepsilon_t^L-\eta_t^w
\right].
\end{aligned}
$$

- **(F18) 劳动需求 / 边际成本均等条件**：

$$
\hat L_t=-\hat w_t+(1+\psi)\hat r_t^k+\hat K_{t-1}.
$$

## 4. Market Clearing & Identities

- **(F19) 商品市场均衡和生产恒等式**：

$$
\hat Y_t=(1-\tau k_y-g_y)\hat C_t+\tau k_y\hat I_t+g_y\varepsilon_t^G
=\phi\hat\varepsilon_t^a+\phi\alpha\hat K_{t-1}
+\phi\alpha\psi\hat r_t^k+\phi(1-\alpha)\hat L_t.
$$

- **(F20) 就业调整辅助方程**：

$$
\hat E_t=\beta\hat E_{t+1}
+\frac{(1-\beta\xi_e)(1-\xi_e)}{\xi_e}(\hat L_t-\hat E_t).
$$

- **(F21) 货币政策反应函数**：

$$
\begin{aligned}
\hat R_t={}&\rho\hat R_{t-1}
+(1-\rho)\left\{\bar\pi_t
+r_\pi(\hat\pi_{t-1}-\bar\pi_t)
+r_Y(\hat Y_t-\hat Y_t^p)\right\}\\
&+r_{\Delta\pi}(\hat\pi_t-\hat\pi_{t-1})
+r_{\Delta y}\left[(\hat Y_t-\hat Y_t^p)
-(\hat Y_{t-1}-\hat Y_{t-1}^p)\right]
+\eta_t^R.
\end{aligned}
$$

## 5. Exogenous Processes

来源说明，持久技术/偏好冲击服从相互独立的一阶自回归过程，成本推动冲击和临时货币政策冲击为 i.i.d.。一轮抽取记号如下：

$$
\hat\varepsilon_t^a=\rho_a\hat\varepsilon_{t-1}^a+\eta_t^a,\quad
\hat\varepsilon_t^b=\rho_b\hat\varepsilon_{t-1}^b+\eta_t^b,\quad
\hat\varepsilon_t^L=\rho_L\hat\varepsilon_{t-1}^L+\eta_t^L.
$$

$$
\hat\varepsilon_t^I=\rho_I\hat\varepsilon_{t-1}^I+\eta_t^I,\quad
\varepsilon_t^G=\rho_G\varepsilon_{t-1}^G+\eta_t^G,\quad
\bar\pi_t=\rho_\pi\bar\pi_{t-1}+\eta_t^\pi.
$$

$$
\eta_t^p,\quad \eta_t^w,\quad \eta_t^Q,\quad \eta_t^R
\quad\text{在论文估计系统中为白噪声冲击。}
$$

实现交叉检查：`EA_SW03_rep.mod` 包含 `a`、`as`、`b`、`g`、`ls`、`qs` 的 AR(1) 状态，以及 MMB 政策冲击替代项 `interest_`；它还保留额外的 MMB 记账冲击和变量。这些信息记录为 `implementation_cross_check`，不是论文侧推导来源。

## 6. Steady-State Solution

论文围绕非随机稳态线性化；带帽变量是相对该稳态的对数偏离。因此线性化归档条目的操作稳态为：

$$
\hat C=\hat I=\hat Q=\hat K=\hat\pi=\hat w=\hat R=\hat r^k=\hat L=\hat Y=\hat E=0.
$$

来源中报告的部分校准或固定稳态关系：

$$
\beta=0.99,\qquad \tau=0.025,\qquad \alpha=0.30,\qquad C/Y=0.60,\qquad I/Y=0.22.
$$

由季度频率下 $I/Y=0.22$ 和 $\tau=0.025$ 可得稳态资本产出比约为 $2.2$。来源还将工资加成参数设为 $\lambda_w=0.5$，因为该参数不可识别。完整非线性稳态重构延期处理并标为 `needs_review`，因为本一轮条目未从源 PDF 求解水平系统。

## 7. Timing & Form Conventions

- **资本时序**：$K_t$ 通过投资安装，并以滞后安装资本进入生产；论文的线性化资本积累方程 (F15) 使用 $\hat I_{t-1}$，MMB 实现中在资本服务定义里使用 `kp(-1)`/`kpf(-1)`。
- **利用率**：资本服务为 $\tilde K_{j,t}=z_tK_{j,t-1}$；利用率通过 (F7) 随租金率变化。
- **名义刚性**：Calvo 工资和价格概率为 $\xi_w$ 与 $\xi_p$；不能重新优化的工资和价格分别通过 $\gamma_w$ 与 $\gamma_p$ 按滞后通胀部分指数化。
- **形式**：估计方程是围绕非随机稳态的线性化对数偏离；实现交叉检查确认 `model(linear)`。
- **潜在产出**：政策规则使用相对潜在产出的产出缺口，潜在产出由排除加成冲击的弹性价格和工资模型定义。
- **运行时验证**：按任务要求未执行。

## 8. Variable & Parameter Reference Table

| 类别 | 符号 / ASCII | 含义 | 主要来源方程 |
|---|---|---|---|
| 内生 | `c`, $\hat C_t$ | 消费 | (F12) |
| 内生 | `inve`, $\hat I_t$ | 投资 | (F13) |
| 内生 | `pk`, $\hat Q_t$ | 已安装资本实际价值 / Tobin Q | (F14) |
| 内生 | `kp`, $\hat K_t$ | 已安装资本存量 | (F15) |
| 内生 | `pinf`, $\hat\pi_t$ | 通胀 | (F16) |
| 内生 | `w`, $\hat w_t$ | 实际工资 | (F17) |
| 内生 | `r`, $\hat R_t$ | 线性化规则中的名义短期利率 / MMB 季度利率 | (F21) |
| 内生 | `rk`, $\hat r_t^k$ | 资本租金率 | (F18), (F14) |
| 内生 | `lab`, $\hat L_t$ | 劳动投入 | (F18) |
| 内生 | `y`, $\hat Y_t$ | 产出 | (F19) |
| 内生 | `empl`, $\hat E_t$ | 就业辅助变量 | (F20) |
| 内生 | `mc`, `mcf` | 边际成本，实现中交叉检查 | (F9), (F16) |
| 外生 | $\eta_t^a$, `ea` | 技术创新 | 第5节 |
| 外生 | $\eta_t^b$, `eb` | 偏好/贴现创新 | 第5节 |
| 外生 | $\eta_t^L$, `els` | 劳动供给创新 | 第5节 |
| 外生 | $\eta_t^I$, `eqs` / investment shock proxy | 投资调整创新 | 第5节 |
| 外生 | $\eta_t^G$, `fiscal_` / `g` innovation | 政府支出创新 | 第5节 |
| 外生 | $\eta_t^p$, `epinf` / `ps` | 价格加成冲击 | 第5节 |
| 外生 | $\eta_t^w$, `ew` / `sw` | 工资加成冲击 | 第5节 |
| 外生 | $\eta_t^Q$, `eqs` | 权益/风险溢价冲击 | (F14), 第5节 |
| 外生 | $\eta_t^\pi$, `eas` | 通胀目标创新 | 第5节 |
| 外生 | $\eta_t^R`, `interest_` / `em` | 临时货币政策创新 | (F21), 第5节 |
| 参数 | $\beta$ / `cbeta` | 贴现因子 | 第6节 |
| 参数 | $\tau$ / `ctou` | 折旧率 | 第6节 |
| 参数 | $\alpha$ / `calfa` | 资本份额 | (F8), (F9) |
| 参数 | $h$ / `chabb` | 外部习惯 | (F12) |
| 参数 | $\sigma_c$ / `csigma` | 跨期替代弹性倒数 | (F12) |
| 参数 | $\sigma_L$ / `csigl` | 劳动供给弹性倒数 | (F17) |
| 参数 | $\xi_p,\xi_w$ / `cprobp,cprobw` | Calvo 价格和工资概率 | (F16), (F17) |
| 参数 | $\gamma_p,\gamma_w$ / `cindp,cindw` | 价格和工资指数化 | (F16), (F17) |
| 参数 | $\rho, r_\pi, r_Y, r_{\Delta\pi}, r_{\Delta y}$ / `crr, crpi, cry, crdpi, crdy` | 政策规则系数 | (F21) |
| 参数 | $\rho_a,\rho_b,\rho_L,\rho_I,\rho_G,\rho_\pi$ | 持续性参数 | 第5节 |

方程数说明：(F1)-(F21) 是归档方程标签，并不保证与完整 MMB 实现中的 Dynare 方程逐条一一对应。论文明确说明方程 (28)-(36) 决定九个核心内生变量；实现额外加入弹性价格模块、就业调整、MMB 报告变量和政策规则变体。
