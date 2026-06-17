# US_KK14 -- 推导（最优化问题 + 一阶条件）

> `US_KK14` 模型档案草稿。状态：`needs_review`。
> 来源：Kliem and Kriwoluzky (2014), "Toward a Taylor rule for fiscal policy", Review of Economic Dynamics 17(2), 294-302。DOI：`10.1016/j.red.2013.08.003`。
> 主要 Markdown 来源：`raw/mmb_mineru/runs/us_kk14__toward_a_taylor_rule_for_fiscal_policy__db8507f5/full.md`。
> 论文正文说明，家庭和厂商 FOC、稳态解以及完整对数线性方程列表在在线补充材料中。本地没有该模型的附录规范化文件，因此来源不完整的模块均标为 `needs_review`。

## 1. Model Overview

- **模型**：Smets-Wouters 传统下的美国估计型新凯恩斯 DSGE 模型，并加入政府购买、转移支付、政府债务、劳动收入税和资本收入税构成的财政部门。
- **目的**：比较传统的税率对产出反应的财政反馈规则，和劳动税对工时反应、资本税对投资反应的替代规则。
- **主体和部门**：具有内部消费习惯的家庭、差异化劳动、工资设定、债券和资本积累决策；最终品厂商；具有 Calvo 定价的垄断竞争中间品厂商；货币当局；财政当局。
- **摩擦**：内部习惯、可变资本利用率、投资调整成本、Calvo 工资和价格黏性、固定生产成本、劳动和资本收入扭曲性税收。
- **经济体**：美国，使用 1983:1 到 2008:3 的季度数据估计。
- **形式**：论文采用对数线性求解。MMB 实现交叉检查文件为 `model(linear)`。因此本档案条目按线性化 DSGE 处理。精确的附录对数线性方程在本地不可用，标为 `needs_review`。
- **运行验证**：未执行。没有运行 Dynare。

## 2. Optimization Problems

### 2.1 家庭

家庭 $i \in [0,1]$ 选择消费、投资、债券、资本、资本利用率和工资设定。来源论文给出时期效用和预算约束，完整 FOC 则放在在线附录中。

**(F1) 家庭终身效用**：

$$
E_t \sum_{s=0}^{\infty}\beta^s
\left[
\varepsilon_{q,t+s}
\frac{(c_{t+s}-h c_{t+s-1})^{1-\sigma_c}}{1-\sigma_c}
-\psi_l \frac{l_{t+s}(i)^{1+\sigma_l}}{1+\sigma_l}
\right].
$$

其中 $\varepsilon_{q,t}$ 是跨期偏好冲击。

**(F2) 家庭流量预算约束**：

$$
c_t+I_t+b_t
=
(1-\tau_t^w)\frac{W_t(i)}{P_t}l_t(i)
+\left((1-\tau_t^k)r_t^k u_t-\phi_t(u_t)\right)k_{t-1}
+\frac{R_{t-1}b_{t-1}}{\pi_t}
+(1-\tau_t^k)d_t+\iota_t(i)+\tau_t^T.
$$

**(F3) 带投资专有效率冲击的资本积累**：

$$
k_t=(1-\delta)k_{t-1}
+\varepsilon_{i,t}\left[1-s\left(\frac{I_t}{I_{t-1}}\right)\right]I_t.
$$

### 2.2 工资设定

家庭供给差异化劳动。竞争性劳动承包商用 Dixit-Stiglitz 技术加总差异化劳动服务。每个家庭以概率 $1-\gamma_w$ 重设工资；否则工资按稳态通胀指数化。

**(F4) 工资设定模块占位式**（`needs_review`）：

$$
\text{Calvo wage reset FOC and wage Phillips curve: online appendix required.}
$$

MMB 实现交叉检查文件包含线性工资 Phillips 关系和工资通胀恒等式，但这些方程不作为论文侧来源。

### 2.3 最终品和中间品厂商

最终品厂商用替代弹性 $\theta_p>1$ 的 Dixit-Stiglitz 技术加总中间品。中间品厂商用资本服务和劳动服务，并受到劳动增强型生产率影响。

**(F5) 中间品生产函数**：

$$
y_t(j)=\left(u_t k_{t-1}(j)\right)^\alpha
\left(l_t^d(j)\varepsilon_{z,t}\right)^{1-\alpha}
-\Omega.
$$

中间品厂商以概率 $1-\gamma_p$ 重设价格；不能重设价格的厂商按稳态通胀指数化。

**(F6) 价格设定模块占位式**（`needs_review`）：

$$
\text{Calvo price reset FOC and price Phillips curve: online appendix required.}
$$

### 2.4 财政当局

财政当局通过税收收入 $x_t$ 和一期政府债券为浪费性政府消费 $c_t^g$ 与转移支付 $\tau_t^T$ 融资。

**(F7) 政府预算约束**：

$$
b_t-\frac{R_{t-1}b_{t-1}}{\pi_t}=c_t^g+\tau_t^T-x_t.
$$

**(F8) 税收收入恒等式**：

$$
x_t=\tau_t^w w_t\frac{l_t}{w_t^+}
+\tau_t^k\left[y_t-w_t\frac{l_t}{w_t^+}\right].
$$

## 3. First-Order Conditions

论文正文没有列出完整的家庭、厂商、工资设定和价格设定 FOC，而是明确指向在线补充材料中的最大化问题、FOC、稳态和完整对数线性方程。由于本地没有附录规范化文件，本节只记录用于描述模型架构的第一遍规范化条件；本节所有公式均为 `needs_review`。

**(F9) 消费 Euler 方程**（`needs_review`）：

$$
\chi_t
=E_t\chi_{t+1}+R_t-E_t\pi_{t+1},
$$

其中 $\chi_t$ 表示线性化的消费边际效用，$R_t-E_t\pi_{t+1}$ 是事前实际回报。

**(F10) 带习惯的边际效用**（`needs_review`）：

$$
(1-\beta h)\chi_t
=\varepsilon_{q,t}
-\frac{\sigma_c}{1-h}(c_t-hc_{t-1})
-h\beta E_t\varepsilon_{q,t+1}
+h\beta\frac{\sigma_c}{1-h}E_t(c_{t+1}-hc_t).
$$

**(F11) 劳动边际负效用**（`needs_review`）：

$$
MUL_t=\sigma_l l_t.
$$

**(F12) 劳动与消费的边际替代率**（`needs_review`）：

$$
MRS_t=MUL_t-\chi_t.
$$

**(F13) 资本 Euler 条件**（`needs_review`）：

$$
\chi_t+q_t
=E_t\chi_{t+1}
+\beta E_t\left[(1-\bar{\tau}^k) \bar{r}^k r_{t+1}^k
-\bar{\tau}^k \bar{r}^k \tau_{t+1}^k
+(1-\delta)q_{t+1}\right].
$$

**(F14) 投资调整成本条件**（`needs_review`）：

$$
I_t=\frac{1}{1+\beta}I_{t-1}
+\frac{\beta}{1+\beta}E_t I_{t+1}
+\frac{1}{\nu(1+\beta)}q_t
+\frac{1}{\nu(1+\beta)}\varepsilon_{i,t}.
$$

**(F15) 资本利用率条件**（`needs_review`）：

$$
\sigma_u u_t=r_t^k-\frac{\bar{\tau}^k}{1-\bar{\tau}^k}\tau_t^k.
$$

**(F16) 工资 Phillips 曲线**（`needs_review`）：

$$
\pi_t^w
=\beta E_t\pi_{t+1}^w
+\frac{(1-\gamma_w)(1-\gamma_w\beta)}
{\gamma_w(1+\theta_w\sigma_l)}
\left(MRS_t-w_t+\frac{\bar{\tau}^w}{1-\bar{\tau}^w}\tau_t^w\right).
$$

**(F17) 工资通胀恒等式**（`needs_review`）：

$$
\pi_t^w=w_t-w_{t-1}+\pi_t.
$$

**(F18) 价格 Phillips 曲线**（`needs_review`）：

$$
\pi_t=\beta E_t\pi_{t+1}
+\frac{(1-\gamma_p)(1-\gamma_p\beta)}{\gamma_p}mc_t.
$$

## 4. Market Clearing & Identities

**(F19) 边际成本与劳动价格关系**（`needs_review`）：

$$
mc_t+(1-\alpha)\varepsilon_{z,t}+\alpha(u_t+k_{t-1})
-\alpha l_t=w_t.
$$

**(F20) 边际成本与资本租金关系**（`needs_review`）：

$$
mc_t+(1-\alpha)\varepsilon_{z,t}+(\alpha-1)(u_t+k_{t-1})
+(1-\alpha)l_t=r_t^k.
$$

**(F21) 总生产**（`needs_review`）：

$$
\bar{y}y_t
=\bar{k}^{\alpha}\bar{l}^{1-\alpha}
\left(\alpha u_t+\alpha k_{t-1}+(1-\alpha)l_t+(1-\alpha)\varepsilon_{z,t}\right).
$$

**(F22) 总资源约束**（`needs_review`）：

$$
\bar{y}y_t=\bar{c}c_t+\bar{I}I_t+\bar{c}^g c_t^g
+\bar{r}^k(1-\bar{\tau}^k)\bar{k}u_t.
$$

**(F23) 测度 GDP 恒等式**：

$$
y_t^m=y_t-\phi(u_t)k_{t-1}.
$$

论文的 Taylor 规则使用测度产出 $y_t^m$。

**(F24) 政府预算约束的线性化形式**（`needs_review`）：

$$
\bar{b}b_t-\frac{\bar{b}}{\beta}
\left(R_{t-1}-\pi_t+b_{t-1}\right)
=\bar{c}^g c_t^g+\bar{\tau}^T\tau_t^T-\bar{x}x_t.
$$

**(F25) 税收收入的线性化形式**（`needs_review`）：

$$
\bar{x}x_t
=\bar{\tau}^w\bar{w}\bar{l}\left(\tau_t^w+w_t+l_t\right)
+\bar{\tau}^k\bar{r}^k\bar{k}\left(\tau_t^k+r_t^k+u_t+k_{t-1}\right)
+\bar{\tau}^k\left(\bar{y}y_t-\bar{r}^k\bar{k}(r_t^k+u_t+k_{t-1})-\bar{w}\bar{l}(w_t+l_t)\right).
$$

**(F26) 货币政策规则**：

$$
\hat{R}_t=\rho_R\hat{R}_{t-1}
+(1-\rho_R)\left(\rho_\pi\hat{\pi}_t+\rho_y\hat{y}_t^m\right)
+\hat{\epsilon}_t^m.
$$

**(F27) 基准劳动收入税规则**：

$$
\hat{\tau}_t^w=\rho_w\hat{\tau}_{t-1}^w
+(1-\rho_w)\left(\eta_{wb}\hat{b}_{t-1}+\eta_{wy}\hat{y}_t^m\right)
+\hat{\epsilon}_{t,\tau^w}.
$$

**(F28) 基准资本收入税规则**：

$$
\hat{\tau}_t^k=\rho_k\hat{\tau}_{t-1}^k
+(1-\rho_k)\left(\eta_{kb}\hat{b}_{t-1}+\eta_{ky}\hat{y}_t^m\right)
+\hat{\epsilon}_{t,\tau^k}.
$$

**(F29) 推荐劳动收入税规则**：

$$
\hat{\tau}_t^w=\rho_w\hat{\tau}_{t-1}^w
+(1-\rho_w)\left(\eta_{wb}\hat{b}_{t-1}+\eta_{wh}\hat{l}_t\right)
+\epsilon_{t,\tau^w}.
$$

**(F30) 推荐资本收入税规则**：

$$
\hat{\tau}_t^k=\rho_k\hat{\tau}_{t-1}^k
+(1-\rho_k)\left(\eta_{kb}\hat{b}_{t-1}+\eta_{kI}\hat{I}_t\right)
+\epsilon_{t,\tau^k}.
$$

## 5. Exogenous Processes

论文说明政府消费、转移支付、跨期偏好冲击、投资专有冲击和劳动增强型技术均服从 AR(1) 过程。实现交叉检查文件也包含这些 AR(1) 过程。

**(F31) 政府消费过程**（`needs_review`）：

$$
c_t^g=\rho_{cg}c_{t-1}^g+\epsilon_t^{cg}.
$$

**(F32) 转移支付过程**（`needs_review`）：

$$
\tau_t^T=\rho_T\tau_{t-1}^T+\epsilon_t^{T}.
$$

**(F33) 投资专有效率冲击**（`needs_review`）：

$$
\varepsilon_{i,t}=\rho_i\varepsilon_{i,t-1}+e_{i,t}.
$$

**(F34) 劳动增强型技术冲击**（`needs_review`）：

$$
\varepsilon_{z,t}=\rho_z\varepsilon_{z,t-1}+e_{z,t}.
$$

**(F35) 跨期偏好冲击**（`needs_review`）：

$$
\varepsilon_{q,t}=\rho_q\varepsilon_{q,t-1}+e_{q,t}.
$$

**(F36) 货币政策创新**：

$$
\epsilon_t^m \sim \text{i.i.d.}
$$

**(F37) 财政规则创新**：

$$
\epsilon_{t,\tau^w}\sim \text{i.i.d.}, \qquad
\epsilon_{t,\tau^k}\sim \text{i.i.d.}
$$

## 6. Steady-State Solution

论文正文给出若干校准目标，但说明完整稳态解在在线附录中。因此下列内容是有来源依据的目标清单和实现交叉检查，而不是已审阅的稳态推导。

- 稳态资本税率：估计数据校准中 $\bar{\tau}^k=0.1929$。
- 稳态劳动税率：估计数据校准中 $\bar{\tau}^w=0.2088$。
- 名义总利率目标：实现交叉检查中 $\bar{R}=1.013$。
- 政府购买产出比目标：$\bar{c}^g/\bar{y}=0.085$。
- 转移支付产出比目标：$\bar{\tau}^T/\bar{y}=0.105$。
- 稳态工时目标：$\bar{l}=1/3$。
- 实现交叉检查中的资本份额和折旧率：$\alpha=0.36$，$\delta=0.025$。
- 对于论文正文讨论的 Ramsey 最优政策稳态，论文报告 $\bar{\tau}^k=-0.1523$、$\bar{\tau}^w=0.3945$、$\bar{b}/\bar{y}=0.3$。

`needs_review`：在本条目提升到第一遍档案状态之上以前，需要从在线附录重建精确的递归稳态解和全部辅助稳态定义，或对实现方程做来源级核对。

## 7. Timing & Form Conventions

- **线性化形式**：方程使用稳态偏离表示，帽子变量或小写线性化变量均表示偏离量。MMB 文件使用 `model(linear)`。
- **资本时序**：生产使用预定的 $k_{t-1}$ 和利用率 $u_t$；资本积累决定 $t$ 期末的 $k_t$。
- **债务时序**：财政反馈规则对滞后债务 $b_{t-1}$ 作出反应。
- **税率时序**：劳动税和资本税是当期财政工具，并具有自回归反馈规则动态。
- **货币时序**：Taylor 规则对当期通胀和测度产出作出反应，并包含滞后名义利率平滑。
- **仅作实现交叉检查**：`.mod` 文件确认变量和冲击名称，但不作为论文侧数学证据。
- **运行验证**：未执行；没有为本档案条目运行 `steady`、`check` 或 `stoch_simul`。

## 8. Variable & Parameter Reference Table

| 类别 | 符号 / ASCII 名称 | 含义 | 由哪条方程决定 |
|---|---|---|---|
| 内生 | `c` / $c_t$ | 消费 | (F9), (F10), (F22) |
| 内生 | `I` / $I_t$ | 投资 | (F14), (F22), (F30) |
| 内生 | `b` / $b_t$ | 政府债务 | (F7), (F24), (F27)-(F30) |
| 内生 | `k` / $k_t$ | 私人资本存量 | (F3), (F13), (F21) |
| 内生 | `u` / $u_t$ | 资本利用率 | (F15), (F21), (F22) |
| 内生 | `q` / $q_t$ | Tobin's Q | (F13), (F14) |
| 内生 | `rk` / $r_t^k$ | 资本租金 | (F13), (F15), (F20), (F25) |
| 内生 | `w` / $w_t$ | 实际工资 | (F16), (F17), (F19), (F25) |
| 内生 | `lp` / $l_t$ | 工时/劳动服务 | (F1), (F11), (F12), (F19), (F21), (F29) |
| 内生 | `MUL` | 劳动边际负效用 | (F11) |
| 内生 | `MRS` | 劳动-消费边际替代率 | (F12), (F16) |
| 内生 | `chi` / $\chi_t$ | 消费边际效用 | (F9), (F10), (F13) |
| 内生 | `inf_p` / $\pi_t$ | 价格通胀 | (F17), (F18), (F24), (F26) |
| 内生 | `inf_w` / $\pi_t^w$ | 工资通胀 | (F16), (F17) |
| 内生 | `R` / $R_t$ | 实现记号中的名义政策利率偏离 | (F9), (F24), (F26) |
| 内生 | `Rb` | 事前实际债券回报 | (F9) |
| 内生 | `mc` / $mc_t$ | 实际边际成本 | (F18)-(F20) |
| 内生 | `y` / $y_t$ | 产出 | (F21), (F22), (F25) |
| 内生 | `GDP` / $y_t^m$ | 测度产出/GDP | (F23), (F26)-(F30) |
| 内生 | `tax` / $x_t$ | 总税收收入 | (F8), (F25) |
| 内生 | `tax_rev_tauw` | 劳动税收入报告变量 | (F8), (F25) |
| 内生 | `tax_rev_tauk` | 资本税收入报告变量 | (F8), (F25) |
| 内生 | `tau_w` / $\tau_t^w$ | 劳动收入税率 | (F27), (F29) |
| 内生 | `tau_k` / $\tau_t^k$ | 资本收入税率 | (F28), (F30) |
| 内生 | `cg` / $c_t^g$ | 政府消费 | (F7), (F22), (F24), (F31) |
| 内生 | `tr` / $\tau_t^T$ | 转移支付 | (F7), (F24), (F32) |
| 内生 | `eps_i` / $\varepsilon_{i,t}$ | 投资专有效率状态 | (F3), (F14), (F33) |
| 内生 | `eps_z` / $\varepsilon_{z,t}$ | 劳动增强型技术状态 | (F5), (F19)-(F21), (F34) |
| 内生 | `eps_q` / $\varepsilon_{q,t}$ | 偏好冲击状态 | (F1), (F10), (F35) |
| 外生 | `e_i` | 投资效率创新 | (F33) |
| 外生 | `e_z` | 技术创新 | (F34) |
| 外生 | `e_q` | 偏好冲击创新 | (F35) |
| 外生 | `eps_m` | 货币政策创新 | (F26), (F36) |
| 外生 | `eps_cg` | 政府消费创新 | (F31) |
| 外生 | `eps_tr` | 转移支付创新 | (F32) |
| 外生 | `eps_tauk` | 资本税创新 | (F28), (F30), (F37) |
| 外生 | `eps_tauw` | 劳动税创新 | (F27), (F29), (F37) |
| 参数 | `nbeta` / $\beta$ | 贴现因子 | -- |
| 参数 | `nalpha` / $\alpha$ | 资本份额 | -- |
| 参数 | `sigma_c` | 跨期替代弹性的倒数 | -- |
| 参数 | `sigma_l` | 劳动供给弹性的倒数 | -- |
| 参数 | `h` | 内部习惯持续性 | -- |
| 参数 | `delta` | 折旧率 | -- |
| 参数 | `nu` | 投资调整成本曲率 | -- |
| 参数 | `sigma_u` | 利用率成本曲率 | -- |
| 参数 | `gamma_w`, `theta_w` | 工资 Calvo 和劳动替代弹性参数 | -- |
| 参数 | `gamma_p`, `theta_p` | 价格 Calvo 和产品替代弹性参数 | -- |
| 参数 | `rho_R`, `rho_pi`, `rho_y` | Taylor 规则平滑和反应参数 | -- |
| 参数 | `rho_w`, `rho_k` | 财政规则持续性参数 | -- |
| 参数 | `etaW*`, `etaK*` | 财政反馈系数 | -- |
| 参数 | `rho_cg`, `rho_tr`, `rho_eps_i`, `rho_eps_z`, `rho_eps_q` | 外生过程持续性参数 | -- |
| 参数 | `tau_k_SS`, `tau_w_SS`, `R_SS`, `cgy`, `tr_o_y`, `l_SS` | 稳态目标 | -- |
