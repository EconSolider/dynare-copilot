# US_FGKR15 -- 推导（最优化问题 + 均衡条件）

> 私有档案的一阶提取稿。状态：`needs_review`。未做运行时验证；未运行 Dynare。

出处：`US_FGKR15`，Fernandez-Villaverde, Guerron-Quintana, Kuester, and Rubio-Ramirez (2015), "Fiscal volatility shocks and economic activity," *American Economic Review* 105(11), 3352-3384, DOI `10.1257/aer.20121236`。主来源：`raw/mmb_mineru/runs/us_fgkr15__fiscal_volatility_shocks_and_economic_activity__c11fd284/full.md`。原始 PDF：`raw/mmb_papers/Fiscal volatility shocks and economic activity.pdf`。在线附录来源：`raw/theory_sources/mmb_appendix_us_fgkr15/files/20121236_app.pdf`。MinerU run id：`c11fd284-6f64-4c88-bb10-440da7196eef`。

## 1. Model Overview

- **模型**：带财政规则和随机财政波动率冲击的中等规模美国新凯恩斯 DSGE 模型。
- **目的**：量化财政工具波动率意外上升的实际效应，特别是资本所得税波动率。
- **主体和模块**：代表性家庭具有习惯、投资、利用率、政府债券、差异化劳动和 Rotemberg 工资调整；最终品打包商；具有 Rotemberg 价格调整的垄断竞争中间品企业；货币当局；财政当局。
- **财政工具**：政府支出份额 $\tilde g_t$、劳动税 $\tau_{l,t}$、资本税 $\tau_{k,t}$ 和消费税 $\tau_{c,t}$。每个工具都有财政冲击和单独的随机波动率冲击。
- **核心机制**：财政波动率改变未来扭曲性政策周围的风险；在名义刚性下，markup 内生变化并放大收缩。
- **形式**：带平衡增长的非线性 DSGE，论文用三阶扰动求解。Rep-MMB 交叉检查使用非线性 `model` 块中的指数化对数变量；其激活的 `stoch_simul` 行为一阶，但论文发表的 IRF 使用高阶/剪枝模拟。运行验证推迟。

## 2. Optimization Problems

### 2.1 家庭

家庭选择消费、差异化劳动、债券、利用率、资本、账面资本和投资，以最大化：

$$
\max E_0\sum_{t=0}^{\infty}\beta^t d_t
\left[
\frac{(c_t-b_h c_{t-1})^{1-\omega}}{1-\omega}
+v(g_t)
-\psi A_t^{1-\omega}\int_0^1\frac{l_{j,t}^{1+\vartheta}}{1+\vartheta}\,dj
\right].
$$

实际预算约束为：

$$
\begin{aligned}
(1+\tau_{c,t})c_t+i_t+b_t+\Omega_t+\int_0^1 AC^w_{j,t}\,dj
=&(1-\tau_{l,t})\int_0^1 w_{j,t}l_{j,t}\,dj
+(1-\tau_{k,t})r_{k,t}u_t k_{t-1}\\
&+\tau_{k,t}\delta k^b_{t-1}
+b_{t-1}\frac{R_{t-1}}{\Pi_t}+F_t .
\end{aligned}
$$

工资调整成本为二次型：

$$
AC^w_{j,t}=\frac{\phi_w}{2}
\left(\frac{w_{j,t}}{w_{j,t-1}}-g_A\right)^2 y_t.
$$

资本和账面资本的运动方程为：

$$
k_t=(1-\delta(u_t))k_{t-1}
+\left[1-S\left(\frac{i_t}{i_{t-1}}\right)\right]i_t,
$$

$$
\delta(u_t)=\delta+\phi_1(u_t-1)+\frac{1}{2}\phi_2(u_t-1)^2,\qquad
S\left(\frac{i_t}{i_{t-1}}\right)=\frac{\kappa}{2}\left(\frac{i_t}{i_{t-1}}-g_A\right)^2,
$$

$$
k^b_t=(1-\delta)k^b_{t-1}+i_t.
$$

### 2.2 劳动打包商

竞争性劳动打包商聚合差异化劳动：

$$
l_t=\left(\int_0^1 l_{j,t}^{(\epsilon_w-1)/\epsilon_w}\,dj\right)^{\epsilon_w/(\epsilon_w-1)}.
$$

成本最小化给出每种劳动的需求：

$$
l_{j,t}=\left(\frac{w_{j,t}}{w_t}\right)^{-\epsilon_w}l_t.
$$

### 2.3 最终品生产者

最终品生产者聚合差异化中间品：

$$
y_t=\left(\int_0^1 y_{i,t}^{(\epsilon-1)/\epsilon}\,di\right)^{\epsilon/(\epsilon-1)}.
$$

成本最小化给出：

$$
y_{i,t}=\left(\frac{P_{i,t}}{P_t}\right)^{-\epsilon}y_t.
$$

### 2.4 中间品企业

中间品企业 $i$ 的生产函数为：

$$
y_{i,t}=k_{i,t}^{\alpha}(A_t l_{i,t})^{1-\alpha}.
$$

成本最小化给出共同实际边际成本：

$$
mc_t=\left(\frac{1}{1-\alpha}\right)^{1-\alpha}
\left(\frac{1}{\alpha}\right)^{\alpha}
\frac{w_t^{1-\alpha}r_{k,t}^{\alpha}}{A_t^{1-\alpha}}.
$$

每个垄断竞争企业在需求约束和 Rotemberg 价格调整成本下设定价格：

$$
\max_{\{P_{i,t+s}\}} E_t\sum_{s=0}^{\infty}
\beta^s\frac{\lambda_{t+s}}{\lambda_t}
\left[
\frac{P_{i,t+s}}{P_{t+s}}y_{i,t+s}
-mc_{t+s}y_{i,t+s}
-AC^p_{i,t+s}
\right],
$$

$$
AC^p_{i,t}=\frac{\phi_p}{2}
\left(\frac{P_{i,t}}{P_{i,t-1}}-\Pi\right)^2y_{i,t}.
$$

### 2.5 政府与货币当局

基准经济中货币当局遵循 Taylor 规则；扩展经济中也可以对财政波动率作出反应。财政当局按随机财政规则选择扭曲性税率和支出，一次总付税稳定债务产出比。

## 3. First-Order Conditions

以下条件来自论文和在线附录。标为 `needs_review` 的方程因 PDF 文本提取不够干净，结合实现交叉检查作了代数规范化。

- **(F1) 带习惯的消费边际效用**：

$$
\frac{d_t}{(c_t-b_h c_{t-1})^\omega}
-E_t\left[\frac{\beta b_h d_{t+1}}{(c_{t+1}-b_h c_t)^\omega}\right]
=\lambda_t(1+\tau_{c,t}).
$$

- **(F2) 工资设定条件** (`needs_review`)：

$$
\begin{aligned}
&\phi_w y_t\left(\frac{w_t}{w_{t-1}}-g_A\right)\frac{w_t}{w_{t-1}}\\
&=E_t\Bigg[
\beta\frac{\lambda_{t+1}}{\lambda_t}\phi_w y_{t+1}
\left(\frac{w_{t+1}}{w_t}-g_A\right)\frac{w_{t+1}}{w_t}
+\frac{(1-\epsilon_w)d_t}{\lambda_t}\psi A_t^{1-\omega}l_t^{1+\vartheta}
+(\epsilon_w-1)(1-\tau_{l,t})w_t l_t
\Bigg].
\end{aligned}
$$

- **(F3) 债券 Euler 方程**：

$$
\lambda_t=\beta E_t\left[\lambda_{t+1}\frac{R_t}{\Pi_{t+1}}\right].
$$

- **(F4) 利用率条件**：

$$
r_{k,t}(1-\tau_{k,t})=q_t\delta'(u_t).
$$

- **(F5) 资本 Euler 方程**：

$$
q_t=E_t\left\{\beta\frac{\lambda_{t+1}}{\lambda_t}
\left[(1-\delta(u_{t+1}))q_{t+1}+(1-\tau_{k,t+1})r_{k,t+1}u_{t+1}\right]\right\}.
$$

- **(F6) 折旧抵扣的账面资本 Euler 方程**：

$$
q^b_t=E_t\left\{\beta\frac{\lambda_{t+1}}{\lambda_t}
\left[(1-\delta)q^b_{t+1}+\delta\tau_{k,t+1}\right]\right\}.
$$

- **(F7) 投资 FOC** (`needs_review`)：

$$
1=q_t\left[
1-S\left(\frac{i_t}{i_{t-1}}\right)
-S'\left(\frac{i_t}{i_{t-1}}\right)\frac{i_t}{i_{t-1}}
\right]
+\beta E_t\left[
q_{t+1}\frac{\lambda_{t+1}}{\lambda_t}
S'\left(\frac{i_{t+1}}{i_t}\right)
\left(\frac{i_{t+1}}{i_t}\right)^2
\right]+q^b_t.
$$

- **(F8) 中间品边际成本**：

$$
mc_t=\left(\frac{w_t}{1-\alpha}\right)^{1-\alpha}
\left(\frac{r_{k,t}}{\alpha}\right)^\alpha A_t^{\alpha-1}.
$$

- **(F9) 要素投入比例**：

$$
\frac{u_t k_{t-1}}{l_t}
=\frac{\alpha}{1-\alpha}\frac{A_t w_t}{r_{k,t}}.
$$

- **(F10) Rotemberg Phillips 曲线**：

$$
\begin{aligned}
0=&(1-\epsilon)+\epsilon mc_t-\phi_p\Pi_t(\Pi_t-\Pi)
+\frac{\epsilon\phi_p}{2}(\Pi_t-\Pi)^2\\
&+\phi_p\beta E_t\left[
\frac{\lambda_{t+1}}{\lambda_t}\Pi_{t+1}(\Pi_{t+1}-\Pi)
\frac{y_{t+1}}{y_t}
\right].
\end{aligned}
$$

- **(F11) 基准 Taylor 规则**：

$$
\frac{R_t}{R}=
\left(\frac{R_{t-1}}{R}\right)^{\phi_R}
\left(\frac{\Pi_t}{\Pi}\right)^{(1-\phi_R)\gamma_\Pi}
\left(\frac{y_t}{yA_t}\right)^{(1-\phi_R)\gamma_y}
\exp(\sigma_m\xi_t).
$$

- **(F12) 带财政波动率反应的扩展 Taylor 规则**：

$$
\frac{R_t}{R}=
\left(\frac{R_{t-1}}{R}\right)^{\phi_R}
\left(\frac{\Pi_t}{\Pi}\right)^{(1-\phi_R)\gamma_\Pi}
\left(\frac{y_t}{yA_t}\right)^{(1-\phi_R)\gamma_y}
\left(\frac{e^{\sigma_{\tau_k,t}}}{e^{\sigma_{\tau_k}}}\right)^{\gamma_\sigma(1-\phi_R)}
\exp(\sigma_m\xi_t).
$$

- **(F13) 政府预算约束**：

$$
b_t=b_{t-1}\frac{R_{t-1}}{\Pi_t}+g_t
-\left(c_t\tau_{c,t}+w_tl_t\tau_{l,t}+r_{k,t}u_tk_{t-1}\tau_{k,t}
-\delta k^b_{t-1}\tau_{k,t}+\Omega_t\right).
$$

- **(F14) 一次总付税反馈规则**：

$$
\Omega_t=A_t\left[
\Omega+\phi_{\Omega,b}\left(\frac{b_{t-1}}{A_{t-1}y}-\frac{b}{y}\right)
\right].
$$

- **(F15) 资本积累**：

$$
k_t=(1-\delta(u_t))k_{t-1}
+\left[1-S\left(\frac{i_t}{i_{t-1}}\right)\right]i_t.
$$

- **(F16) 账面资本积累**：

$$
k^b_t=(1-\delta)k^b_{t-1}+i_t.
$$

## 4. Market Clearing & Identities

- **(F17) 总资源约束和总供给恒等式**：

$$
y_t=c_t+i_t+g_t+\frac{\phi_p}{2}(\Pi_t-\Pi)^2y_t
+\frac{\phi_w}{2}\left(\frac{w_t}{w_{t-1}}-g_A\right)^2y_t
=(u_tk_{t-1})^\alpha(A_tl_t)^{1-\alpha}.
$$

- **(F18) 总利润**：

$$
F_t=y_t-w_tl_t-r_{k,t}u_tk_{t-1}
-\frac{\phi_p}{2}(\Pi_t-\Pi)^2y_t.
$$

- **(F19) 政府支出水平**：

$$
g_t=\tilde g_t y_t.
$$

- **(F20) 毛通胀定义**：

$$
\Pi_t=\frac{P_t}{P_{t-1}}.
$$

- **(F21) 折旧和投资调整函数**：

$$
\delta'(u_t)=\phi_1+\phi_2(u_t-1),\qquad
S'(x)=\kappa(x-g_A).
$$

## 5. Exogenous Processes

- **(F22) 带单位根的劳动增强技术**：

$$
\log A_t=g_A+\log A_{t-1}+\sigma_A\epsilon_{A,t},\qquad
\epsilon_{A,t}\sim\mathcal N(0,1).
$$

- **(F23) 偏好冲击**：

$$
\log d_t=\rho_d\log d_{t-1}+\sigma_d\epsilon_{d,t},\qquad
\epsilon_{d,t}\sim\mathcal N(0,1).
$$

- **(F24) $x\in\{\tilde g,\tau_l,\tau_k,\tau_c\}$ 的财政工具规则**：

$$
x_t-x=\rho_x(x_{t-1}-x)
+\phi_{x,y}\tilde y_{t-1}
+\phi_{x,b}\left(\frac{b_{t-1}}{y_{t-1}}-\frac{b}{y}\right)
+\exp(\sigma_{x,t})\epsilon_{x,t},
\qquad \epsilon_{x,t}\sim\mathcal N(0,1).
$$

- **(F25) $x\in\{\tilde g,\tau_l,\tau_k,\tau_c\}$ 的财政波动率过程**：

$$
\sigma_{x,t}=(1-\rho_{\sigma_x})\sigma_x
+\rho_{\sigma_x}\sigma_{x,t-1}
+(1-\rho_{\sigma_x}^2)^{1/2}\eta_x u_{x,t},
\qquad u_{x,t}\sim\mathcal N(0,1).
$$

- **(F26) 货币政策冲击创新**：

$$
\xi_t\sim\mathcal N(0,1).
$$

## 6. Steady-State Solution

论文使用平衡增长路径。必要时用 $A_t$ 归一化平稳变量，并把冲击设为无条件均值。

1. 设 $u=1$、$\delta(u)=\delta$、$\delta'(1)=\phi_1$、$S(g_A)=S'(g_A)=0$。
2. 设 $\Pi$ 为通胀目标、$g_A=1.005$，并从带增长和习惯调整的稳态 Fisher/Euler 条件确定 $R$；实现交叉检查中采用此规范化。
3. 由 (F4) 固定利用率成本斜率：$r_k(1-\tau_k)=q\phi_1$。
4. 由 (F5) 在 $q=1$ 下求稳态资本使用成本：

$$
1=\beta \frac{\lambda_{t+1}}{\lambda_t}\left[(1-\delta)+r_k(1-\tau_k)\right],
$$

其中增长归一化由平稳化变换处理。

5. 由 (F8) 和 (F9)，给定 $mc=(\epsilon-1)/\epsilon$ 后求资本劳动比和实际工资。
6. 将工时归一到校准目标 $l=1/3$，并计算 $k$、$y$ 和 $i=[1-(1-\delta)/g_A]k$。
7. 由 (F16) 计算账面资本：在实现的增长调整约定下 $k^b=i/(1-(1-\delta)/g_A)$。
8. 用无调整成本的资源约束 (F17) 得到消费：$c=y-i-\tilde g y$。
9. 用 (F1) 和 (F2) 反解 $\lambda$ 与劳动负效用尺度 $\psi$。
10. 用政府预算约束 (F13) 和一次总付税规则 (F14) 反解稳态一次总付税水平 $\Omega$。

`needs_review`：$\lambda$、$q$ 和 $q^b$ 的精确增长归一化稳态公式在 `US_FGKR15_rep.mod` 中以实现口径规范化；本条目记录来源逻辑，但不认证可运行的 steady-state block。

## 7. Timing & Form Conventions

- **资本时序**：$t$ 期生产使用 $k_{t-1}$ 和利用率 $u_t$；投资决定期末 $k_t$。
- **账面资本时序**：折旧抵扣使用 $k^b_{t-1}$，投资更新 $k^b_t$。
- **债务时序**：政府债券 $b_t$ 是期末实际债务；预算约束将 $b_{t-1}R_{t-1}/\Pi_t$ 带入 $t$ 期。
- **财政冲击**：$\epsilon_{x,t}$ 移动财政工具；$u_{x,t}$ 移动对数标准差 $\sigma_{x,t}$。主要实验冲击 $u_{\tau_k,t}$。
- **模型形式**：带平衡增长的非线性平稳均衡。论文侧数量结果使用三阶扰动，因为波动率冲击本身在高阶项中直接发挥作用。
- **实现交叉检查**：`.agents/skills/dynare-copilot/references/examples/US_FGKR15_rep.mod` 使用对数/指数化变量，包括 `ct`、`yt`、`invt`、`kt`、`kbt`、`ht`、`mct`、`wt`、`inflt`、`Rt`、税率和波动率状态。未运行该文件。

## 8. Variable & Parameter Reference Table

### 内生变量

| 符号 | ASCII / 实现线索 | 含义 | 主要方程 |
|---|---|---|---|
| $c_t$ | `ct` | 消费 | (F1), (F17) |
| $i_t$ | `invt` | 投资 | (F7), (F15), (F17) |
| $y_t$ | `yt` | 产出 | (F17) |
| $l_t$ | `ht` | 总工时 | (F2), (F9), (F17) |
| $w_t$ | `wt` | 实际工资 | (F2), (F8), (F9) |
| $\lambda_t$ | `lamt` | 预算乘子 | (F1), (F3), (F5), (F7), (F10) |
| $b_t$ | `bdt` | 实际政府债务 | (F13), (F14), (F24) |
| $u_t$ | `utilt` | 资本利用率 | (F4), (F15), (F17) |
| $k_t$ | `kt` | 生产性资本存量 | (F15), (F17) |
| $k^b_t$ | `kbt` | 税收账面资本 | (F6), (F16) |
| $q_t$ | `miut / lamt` | 由 $\lambda_t$ 归一化的 Tobin's Q 乘子 | (F5), (F7) |
| $q^b_t$ | `miubt / lamt` | 由 $\lambda_t$ 归一化的账面资本乘子 | (F6), (F7) |
| $r_{k,t}$ | `rkt` | 资本租金率 | (F4), (F8), (F9) |
| $mc_t$ | `mct` | 实际边际成本 | (F8), (F10) |
| $\Pi_t$ | `inflt` | 毛通胀 | (F10), (F11), (F20) |
| $R_t$ | `Rt` | 毛名义利率 | (F3), (F11), (F12), (F13) |
| $F_t$ | `proft` | 企业总利润 | (F18) |
| $\tilde g_t$ | `gt` | 政府支出份额 | (F19), (F24) |
| $\tau_{k,t}$ | `taukt` | 资本所得税率 | (F4), (F13), (F24) |
| $\tau_{l,t}$ | `tauwt` | 劳动所得税率 | (F2), (F13), (F24) |
| $\tau_{c,t}$ | `tauct` | 消费税率 | (F1), (F13), (F24) |
| $\sigma_{k,t},\sigma_{l,t},\sigma_{c,t},\sigma_{g,t}$ | `sigkt`, `sigwt`, `sigct`, `siggt` | 财政波动率状态 | (F25) |
| $A_t$ | `gzt` growth state | 劳动增强技术水平/增长 | (F22) |
| $d_t$ | `dt` | 偏好冲击 | (F23) |

### 外生创新

| 符号 | ASCII / 实现线索 | 含义 |
|---|---|---|
| $\epsilon_{A,t}$ | `ezt` | 技术创新 |
| $\epsilon_{d,t}$ | `edt` | 偏好创新 |
| $\xi_t$ | `emt` | 货币政策创新 |
| $\epsilon_{\tau_k,t}$ | `ekt` | 资本税财政创新 |
| $\epsilon_{\tau_c,t}$ | `ect` | 消费税财政创新 |
| $\epsilon_{\tilde g,t}$ | `egt` | 政府支出财政创新 |
| $\epsilon_{\tau_l,t}$ | `ewt` | 劳动税财政创新 |
| $u_{\tau_k,t}$ | `ukt` | 资本税波动率创新 |
| $u_{\tau_c,t}$ | `uct` | 消费税波动率创新 |
| $u_{\tilde g,t}$ | `ugt` | 支出波动率创新 |
| $u_{\tau_l,t}$ | `uwt` | 劳动税波动率创新 |

### 参数

| 参数 | 含义 |
|---|---|
| $\beta,\omega,b_h,\psi,\vartheta$ | 家庭贴现、风险厌恶、习惯、劳动负效用尺度、Frisch 弹性倒数 |
| $\alpha,\delta,\phi_1,\phi_2,\kappa,g_A$ | 生产份额、折旧、利用率成本、投资调整、趋势增长 |
| $\epsilon,\epsilon_w,\phi_p,\phi_w$ | 商品/劳动需求弹性和 Rotemberg 价格/工资调整成本 |
| $\Pi,R,\phi_R,\gamma_\Pi,\gamma_y,\gamma_\sigma,\sigma_m$ | 通胀目标、名义利率、Taylor 规则参数、财政波动率反应、货币冲击尺度 |
| $\rho_x,\phi_{x,y},\phi_{x,b},\sigma_x,\rho_{\sigma_x},\eta_x$ | 财政规则持续性、反馈、平均波动率、波动率持续性和创新尺度 |
| $\rho_d,\sigma_d,\sigma_A,\phi_{\Omega,b},\Omega,b/y$ | 偏好和技术冲击参数、债务稳定和财政稳态目标 |
