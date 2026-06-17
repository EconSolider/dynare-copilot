# US_FMS134 推导 - Feve、Matheron 和 Sahuc (2013)

来源：Patrick Feve, Julien Matheron, and Jean-Guillaume Sahuc (2013), "A Pitfall with Estimated DSGE-Based Government Spending Multipliers," *American Economic Journal: Macroeconomics* 5(4), 141-178. DOI: `10.1257/mac.5.4.141`.

模型 ID：`US_FMS134`。状态：`needs_review`。

## 1. Model Overview

- **模型**：Feve、Matheron 和 Sahuc (2013) 中用于 Smets-Wouters 类型稳健性检验的中等规模 New Keynesian DSGE 模型。核心机制是私人消费与政府支出的 Edgeworth 互补/替代关系，以及内生的逆周期政府支出规则。
- **主体和部门**：家庭、最终品生产者、中间品生产者、就业机构/工资设定者，以及政府/货币当局。
- **摩擦**：消费服务中的外部习惯、投资调整成本、可变资本利用率、垄断竞争、带指数化的 Calvo 价格和工资刚性、七个结构冲击，以及内生政府支出。
- **形式**：`model(linear)`。论文说明估计模型经过对数线性化并写为状态空间形式；MMB 实现交叉检查确认这是线性 Dynare 模型。下列变量均为平稳化后的对数偏离或观测方程，除非明确写为稳态对象。
- **运行验证**：未执行。没有运行 Dynare。
- **出处边界**：论文侧 Markdown 是数学来源。`.agents/skills/dynare-copilot/references/examples/US_FMS134_rep.mod` 仅用作 `implementation_cross_check`。

## 2. Optimization Problems

### 家庭

定量来源模型在简单分析模型基础上加入资本、投资、偏好冲击和劳动习惯。在线性化前的水平记号下，代表性家庭最大化：

$$
E_t\sum_{i=0}^{\infty}\beta^i
\left[
e^{\epsilon_{c,t+i}}\log(C_{t+i}+\alpha_g G_{t+i})
-e^{\epsilon_{n,t+i}}\frac{\eta}{1+\nu}
\left(\frac{N_{t+i}}{N_{t+i-1}^{\phi}}\right)^{1+\nu}
\right].
$$

约束为预算约束：

$$
C_t+X_t+E_t\{q_{t,t+1}B_{t+1}\}
=W_tN_t+R^k_tK_t-T_t+B_t .
$$

以及物理资本积累：

$$
K_{t+1}=(1-\delta)K_t+X_t .
$$

在中等规模稳健性模型中，MMB 实现还加入习惯调整后的消费服务、投资调整成本和可变利用率。这些细节作为 `implementation_cross_check` 使用，因为论文对中等规模模型只作压缩描述。

### 企业

论文中定量基准的生产端有最终品：

$$
Y_t=K_t^{\theta}\left(e^{Z_t}N_t\right)^{1-\theta},
$$

完全竞争下的要素价格为：

$$
R^k_t=\theta\frac{Y_t}{K_t}, \qquad
W_t=(1-\theta)\frac{Y_t}{N_t}.
$$

中等规模稳健性模型沿用 Christiano-Eichenbaum-Evans / Smets-Wouters 结构，包括最终品生产者、中间品生产者、Calvo 定价和工资设定。下面的精确线性价格/工资块标为 `needs_review`，因为本地 Markdown 只概述该模块，没有打印所有中等规模 FOC。

### 政府和政策当局

来源基准中，政府购买由一次总付税融资：

$$
T_t=G_t.
$$

政府支出的平稳成分服从内生反馈规则：

$$
G_t e^{-Z_t}=\bar{G}^s\widetilde{G}_t e^{\epsilon_{g,t}},
$$

$$
\log\widetilde{G}_t=-\varphi_g\left(\Delta\log Y_t-\log\gamma_z\right).
$$

在 MMB 中等规模实现中，同一机制表现为 `g` 和 `gf` 的线性规则，即政府支出响应相对于趋势的产出增长。

## 3. First-Order Conditions

以下方程使用中等规模 MMB 条目的实现变量名。论文支持模型族、对数线性形式、财政规则机制、冲击集合和测量策略；标为 `implementation_cross_check` 的方程来自 MMB 实现以保证覆盖，提升到 reviewed 前仍需论文/附录核查。

### 弹性价格块

- **(F1) 弹性有效资本** (`implementation_cross_check`):

$$
k^f_t=u^f_t+\bar{k}^f_{t-1}-e^z_t .
$$

- **(F2) 弹性物理资本积累** (`implementation_cross_check`):

$$
\bar{k}^f_t=\frac{1-\delta}{e^\gamma}(\bar{k}^f_{t-1}-e^z_t)
\left(1-\frac{1-\delta}{e^\gamma}\right)
\left[x^f_t+\eta_k e^{2\gamma}(1+\beta)e^x_t\right].
$$

- **(F3) 弹性消费服务边际效用** (`needs_review`, `implementation_cross_check`):

$$
\lambda^f_t =
a_1 c^{*f}_{t+1}-a_2 c^{*f}_t+a_3 c^{*f}_{t-1}
a_4 e^z_t+a_5 e^b_t .
$$

- **(F4) 弹性消费 Euler 方程** (`needs_review`, `implementation_cross_check`):

$$
c^{*f}_t=b_1c^{*f}_{t+1}-b_2c^{*f}_{t+2}
b_3c^{*f}_{t-1}+b_4e^z_t-b_5r^f_t+e^b_t .
$$

- **(F5) 带 Edgeworth 项的弹性消费服务**:

$$
c^{*f}_t=\frac{c_{ss}}{c_{ss}+\alpha_g g_{ss}}c^f_t
\frac{\alpha_g g_{ss}}{c_{ss}+\alpha_g g_{ss}}g^f_t .
$$

- **(F6) 弹性投资方程** (`implementation_cross_check`):

$$
x^f_t=\frac{1}{1+\beta}(x^f_{t-1}-e^z_t)
\frac{1}{\eta_k e^{2\gamma}(1+\beta)}q^f_t
\frac{\beta}{1+\beta}(x^f_{t+1}+e^z_{t+1})+e^x_t .
$$

- **(F7) 弹性 Tobin's Q** (`implementation_cross_check`):

$$
q^f_t=\frac{\beta(1-\delta)}{e^\gamma}q^f_{t+1}
\left(1-\frac{\beta(1-\delta)}{e^\gamma}\right)r^{k,f}_{t+1}-r^f_t .
$$

- **(F8) 弹性资本利用率** (`implementation_cross_check`):

$$
u^f_t=\eta_u r^{k,f}_t .
$$

- **(F9) 弹性生产函数** (`implementation_cross_check`):

$$
y^f_t=(1+f_{ss}/y_{ss})\left[\alpha k^f_t+(1-\alpha)n^f_t\right].
$$

- **(F10) 弹性劳动需求** (`implementation_cross_check`):

$$
w^f_t=\alpha k^f_t-\alpha n^f_t .
$$

- **(F11) 弹性资本租金率** (`implementation_cross_check`):

$$
r^{k,f}_t=(1-\alpha)n^f_t-(1-\alpha)k^f_t .
$$

- **(F12) 弹性工资曲线** (`needs_review`, `implementation_cross_check`):

$$
w^f_t=\omega n^f_t+a_5 e^b_t-\lambda^f_t .
$$

- **(F13) 弹性政府支出规则**:

$$
g^f_t=-\varphi_g(y^f_t-y^f_{t-1}+e^z_t)+e^g_t .
$$

### 黏性价格/黏性工资块

- **(F14) 黏性有效资本** (`implementation_cross_check`):

$$
k_t=u_t+\bar{k}_{t-1}-e^z_t .
$$

- **(F15) 黏性物理资本积累** (`implementation_cross_check`):

$$
\bar{k}_t=\frac{1-\delta}{e^\gamma}(\bar{k}_{t-1}-e^z_t)
\left(1-\frac{1-\delta}{e^\gamma}\right)
\left[x_t+\eta_k e^{2\gamma}(1+\beta)e^x_t\right].
$$

- **(F16) 黏性消费服务边际效用** (`needs_review`, `implementation_cross_check`):

$$
\lambda_t =
a_1 c^{*}_{t+1}-a_2 c^{*}_t+a_3 c^{*}_{t-1}
a_4 e^z_t+a_5 e^b_t .
$$

- **(F17) 黏性消费 Euler 方程** (`needs_review`, `implementation_cross_check`):

$$
c^{*}_t=b_1c^{*}_{t+1}-b_2c^{*}_{t+2}
b_3c^{*}_{t-1}+b_4e^z_t-b_5(r_t-\pi_{t+1})+e^b_t .
$$

- **(F18) 带 Edgeworth 项的黏性消费服务**:

$$
c^*_t=\frac{c_{ss}}{c_{ss}+\alpha_g g_{ss}}c_t
\frac{\alpha_g g_{ss}}{c_{ss}+\alpha_g g_{ss}}g_t .
$$

- **(F19) 黏性投资方程** (`implementation_cross_check`):

$$
x_t=\frac{1}{1+\beta}(x_{t-1}-e^z_t)
\frac{1}{\eta_k e^{2\gamma}(1+\beta)}q_t
\frac{\beta}{1+\beta}(x_{t+1}+e^z_{t+1})+e^x_t .
$$

- **(F20) 黏性 Tobin's Q** (`implementation_cross_check`):

$$
q_t=\frac{\beta(1-\delta)}{e^\gamma}q_{t+1}
\left(1-\frac{\beta(1-\delta)}{e^\gamma}\right)r^k_{t+1}
-(r_t-\pi_{t+1}) .
$$

- **(F21) 黏性资本利用率** (`implementation_cross_check`):

$$
u_t=\eta_u r^k_t .
$$

- **(F22) 黏性生产函数** (`implementation_cross_check`):

$$
y_t=(1+f_{ss}/y_{ss})\left[\alpha k_t+(1-\alpha)n_t\right].
$$

- **(F23) 黏性劳动需求** (`implementation_cross_check`):

$$
w_t=mc_t+\alpha k_t-\alpha n_t .
$$

- **(F24) 黏性资本租金率** (`implementation_cross_check`):

$$
r^k_t=mc_t-(1-\alpha)k_t+(1-\alpha)n_t .
$$

- **(F25) 价格 Phillips 曲线** (`needs_review`, `implementation_cross_check`):

$$
\pi_t=\frac{\beta}{1+\gamma_p\beta}\pi_{t+1}
\frac{\gamma_p}{1+\gamma_p\beta}\pi_{t-1}
\kappa mc_t+e^p_t .
$$

- **(F26) 工资 Phillips 曲线** (`needs_review`, `implementation_cross_check`):

$$
w_t=\frac{
\frac{1}{1+\beta}w_{t-1}+\frac{\beta}{1+\beta}w_{t+1}
\kappa_w mrs_t+\frac{\gamma_w}{1+\beta}\pi_{t-1}
-\frac{1+\beta\gamma_w}{1+\beta}\pi_t
\frac{\beta}{1+\beta}\pi_{t+1}
-\frac{1-\rho_z\beta}{1+\beta}e^z_t
}{1+\kappa_w}+e^w_t .
$$

- **(F27) 边际替代率** (`implementation_cross_check`):

$$
mrs_t=\omega n_t+a_5e^b_t-\lambda_t .
$$

- **(F28) 黏性政府支出规则**:

$$
g_t=-\varphi_g(y_t-y_{t-1}+e^z_t)+e^g_t .
$$

- **(F29) 货币政策规则** (`implementation_cross_check`):

$$
r_t=\rho_s r_{t-1}
(1-\rho_s)\left[\rho_{\pi}\pi_t+\rho_y(y_t-y^f_t)\right]
\rho_{\Delta y}\left[(y_t-y_{t-1})+(y^f_{t-1}-y^f_t)\right]
\zeta^r_t .
$$

## 4. Market Clearing & Identities

- **(F30) 弹性资源约束** (`implementation_cross_check`):

$$
y^f_t=c_{ss}/y_{ss}\,c^f_t+x_{ss}/y_{ss}\,x^f_t
g_{ss}/y_{ss}\,g^f_t+\bar{r}^k k_{ss}/y_{ss}\,u^f_t .
$$

- **(F31) 黏性资源约束** (`implementation_cross_check`):

$$
y_t=c_{ss}/y_{ss}\,c_t+x_{ss}/y_{ss}\,x_t
g_{ss}/y_{ss}\,g_t+\bar{r}^k k_{ss}/y_{ss}\,u_t .
$$

- **(F32) 政府预算恒等式**:

$$
T_t=G_t .
$$

- **(F33) 产出增长观测方程**:

$$
dyobs_t=y_t-y_{t-1}+\gamma_z+e^z_t .
$$

- **(F34) 消费增长观测方程**:

$$
dcobs_t=c_t-c_{t-1}+\gamma_z+e^z_t .
$$

- **(F35) 投资增长观测方程**:

$$
dxobs_t=x_t-x_{t-1}+\gamma_z+e^z_t .
$$

- **(F36) 政府支出增长观测方程**:

$$
dgobs_t=g_t-g_{t-1}+\gamma_z+e^z_t .
$$

- **(F37) 工资增长观测方程**:

$$
dwobs_t=w_t-w_{t-1}+\gamma_z+e^z_t .
$$

- **(F38) 通胀观测方程**:

$$
inflobs_t=\pi_t+\bar{\pi}_{obs}.
$$

- **(F39) 名义利率观测方程**:

$$
robs_t=r_t+\bar{r}_{obs}.
$$

- **(F40) 工时观测方程**:

$$
labobs2_t=n_t+\bar{n}_{obs}.
$$

## 5. Exogenous Processes

- **(F41) 技术冲击**:

$$
e^z_t=\rho_z e^z_{t-1}+\zeta^z_t .
$$

- **(F42) 偏好/风险溢价冲击** (`implementation_cross_check`):

$$
e^b_t=\rho_b e^b_{t-1}+\zeta^b_t .
$$

- **(F43) 投资冲击** (`implementation_cross_check`):

$$
e^x_t=\rho_x e^x_{t-1}+\zeta^x_t .
$$

- **(F44) 价格加成冲击** (`implementation_cross_check`):

$$
e^p_t=\rho_p e^p_{t-1}+\zeta^p_t .
$$

- **(F45) 政府支出冲击**:

$$
e^g_t=\rho_g e^g_{t-1}+\zeta^g_t .
$$

- **(F46) 工资加成冲击** (`implementation_cross_check`):

$$
e^w_t=\rho_w e^w_{t-1}+\zeta^w_t .
$$

- **(F47) 货币政策冲击** (`implementation_cross_check`):

$$
\zeta^r_t \sim iid(0,\sigma_r^2).
$$

## 6. Steady-State Solution

由于 `US_FMS134` 实现为 `model(linear)`，模型块中的所有动态变量在确定性稳态为零。实现文件在模型块之前计算稳态比率和线性化系数：

$$
e^\gamma=\exp(\gamma_z/100), \qquad
\bar{r}^k=\frac{e^\gamma}{\beta}-(1-\delta).
$$

生产端稳态比率为：

$$
\bar{w}=
\left[
\frac{1}{1+\lambda_p}
\frac{\alpha^\alpha(1-\alpha)^{1-\alpha}}{(\bar{r}^k)^\alpha}
\right]^{1/(1-\alpha)},
$$

$$
k/y=\frac{k/l}{y/l}, \qquad
x/y=\frac{\left(1-\frac{1-\delta}{e^\gamma}\right)e^\gamma k/l}{y/l},
\qquad c/y=1-x/y-g/y.
$$

线性 Phillips 系数为：

$$
\kappa=\frac{(1-\beta\theta_p)(1-\theta_p)}{\theta_p(1+\beta\gamma_p)},
$$

$$
\kappa_w=
\frac{(1-\beta\theta_w)(1-\theta_w)}
{\theta_w(1+\beta)(1+\omega(1+1/\lambda_w))}.
$$

效用/互补性稳态项通过 (F5) 和 (F18) 中的 `csy`、`gsy` 与 `alphag` 进入。运行层面的稳态验证延后。

## 7. Timing & Form Conventions

- **线性形式**：所有模型方程都是平稳对数偏离或观测增长率中的线性方程。MMB 实现声明 `model(linear)`。
- **趋势处理**：实际变量围绕确定性技术增长 `egamma` 平稳化；观测方程加入 `gammaz` 和技术状态 `ez`。
- **资本时序**：`kp` 和 `kpf` 是上一期带入的物理资本存量；有效资本使用 `kp(-1)` 和 `kpf(-1)`。
- **政策时序**：政府支出当期响应相对于趋势的产出增长 `y_t-y_{t-1}+e^z_t`。货币规则响应通胀、相对弹性块的产出缺口、产出增长变化和货币政策创新。
- **来源不确定性**：论文更完整地打印了基准新古典模型，而不是中等规模 SW 类型稳健性块。价格/工资方程和若干动态 FOC 因此是第一版 `needs_review`。

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Equation |
|---|---|---|---|
| Endogenous | `y`, `yf` | 黏性/弹性产出 | (F22), (F30), (F31) |
| Endogenous | `c`, `cf` | 黏性/弹性消费 | (F5), (F18), (F30), (F31) |
| Endogenous | `x`, `xf` | 黏性/弹性投资 | (F6), (F19) |
| Endogenous | `w`, `wf` | 黏性/弹性实际工资 | (F10), (F12), (F23), (F26) |
| Endogenous | `infl` | 通胀 | (F25), (F38) |
| Endogenous | `r`, `rf` | 实现约定中的名义/政策或弹性实际利率 | (F4), (F17), (F29) |
| Endogenous | `labor`, `laborf` | 黏性/弹性劳动 | (F9), (F22), (F27) |
| Endogenous | `cstar`, `cstarf` | 包含政府支出的消费服务 | (F5), (F18) |
| Endogenous | `k`, `kf` | 有效资本 | (F1), (F14) |
| Endogenous | `u`, `uf` | 资本利用率 | (F8), (F21) |
| Endogenous | `kp`, `kpf` | 物理资本存量 | (F2), (F15) |
| Endogenous | `lambda`, `lambdaf` | 边际效用 | (F3), (F16) |
| Endogenous | `q`, `qf` | Tobin's Q | (F7), (F20) |
| Endogenous | `rk`, `rkf` | 资本租金率 | (F11), (F24) |
| Endogenous | `mc` | 实际边际成本 | (F23), (F25) |
| Endogenous | `g`, `gf` | 政府支出 | (F13), (F28), (F30), (F31) |
| Endogenous | `mrs` | 边际替代率 | (F27) |
| Endogenous | `dyobs`, `dcobs`, `dxobs`, `dgobs`, `dwobs`, `inflobs`, `robs`, `labobs2` | 观测变量 | (F33)-(F40) |
| Exogenous state | `ez`, `eb`, `ex`, `ep`, `eg`, `ew` | 结构冲击状态 | (F41)-(F46) |
| Exogenous innovation | `zetaz`, `zetab`, `zetax`, `zetap`, `zetaw`, `zetar`, `zetag` | 创新项 | (F41)-(F47) |
| Parameter | `beta`, `delta`, `alpha`, `gsy` | 贴现、折旧、资本份额、政府支出份额 | steady state |
| Parameter | `alphag`, `phig` | Edgeworth 互补性和政府反馈 | (F5), (F13), (F18), (F28) |
| Parameter | `hab`, `etak`, `psiu`, `omega` | 习惯、投资调整、利用率、劳动曲率 | (F3)-(F8), (F16)-(F21), (F27) |
| Parameter | `thetap`, `thetaw`, `gammap`, `gammaw`, `lambdap`, `lambdaw` | 名义刚性和加成 | (F25), (F26), steady state |
| Parameter | `rhoz`, `rhob`, `rhox`, `rhop`, `rhog`, `rhow`, `rhos`, `rhoinfl`, `rhoy`, `rhody` | 持续性和政策响应 | (F29), (F41)-(F46) |
| Parameter | `consteinfl`, `conster`, `constelabor`, `gammaz` | 测量常数和趋势增长 | (F33)-(F40) |
