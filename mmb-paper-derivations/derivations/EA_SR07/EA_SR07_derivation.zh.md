# EA_SR07 - 推导档案条目

> 状态：needs_review。这个第一版条目基于 MinerU Markdown 来源，而不是 PDF 正文。论文 Markdown 包含已发表版本中的简明模型描述，但不包含论文引用的 2006 年附录，因此若干附录层级的一阶条件被记录为待后续来源核查的问题。`.mod` 文件仅作为实现交叉检查，用于变量名称和线性形式。

来源：Adolfson, Malin; Laseen, Stefan; Linde, Jesper; Villani, Mattias (2007), "Bayesian estimation of an open economy DSGE model with incomplete pass-through," *Journal of International Economics* 72, 481-511. DOI: `10.1016/j.jinteco.2007.01.003`。

## 1. 模型概述

- **模型 ID**：`EA_SR07`。
- **经济体**：估计的欧元区小型开放经济 DSGE 模型。
- **核心结构**：在 Christiano-Eichenbaum-Evans 式中型 DSGE 模型上加入进口消费品和投资品、出口需求、不完全汇率传递、国内/进口/出口价格粘性、工资粘性、习惯形成、投资调整成本、可变资本利用率、货币余额、营运资本融资、财政与外国 VAR 模块，以及时变通胀目标。
- **形式**：对数线性化模型。论文明确用帽子变量给出若干关系式，MMB 实现交叉检查使用 `model(linear)`。
- **冲击**：单位根技术增长、平稳技术、投资专有技术、消费偏好、劳动供给、国内/进口/出口加成、风险溢价、货币政策、通胀目标、外国非对称技术、财政 VAR 创新以及外国 VAR 创新。
- **运行验证**：未执行。

## 2. 主体的最优化问题

### 最终国内品聚合器

最终国内品是差异化中间品的 CES 组合：

**(F1) 国内 CES 聚合器**
$$
Y_t=\left[\int_0^1 (Y_{i,t})^{1/\lambda_t^d}\,di\right]^{\lambda_t^d},
\qquad 1\leq \lambda_t^d<\infty .
$$

### 国内中间品企业

中间品企业 `i` 使用资本服务和同质劳动生产：

**(F2) 中间品生产**
$$
Y_{i,t}=z_t^{1-\alpha}\epsilon_t K_{i,t}^{\alpha}H_{i,t}^{1-\alpha}-z_t\phi .
$$

营运资本要求企业在生产前为比例 `nu` 的工资账单融资。成本最小化给出名义边际成本：

**(F3) 国内名义边际成本**
$$
MC_t^d=
\frac{1}{(1-\alpha)^{1-\alpha}\alpha^\alpha}
\,(R_t^k)^\alpha
\left[W_t\left(1+\nu(R_{t-1}-1)\right)\right]^{1-\alpha}
\frac{1}{z_t^{1-\alpha}}
\frac{1}{\epsilon_t}.
$$

needs_review：Markdown OCR/来源方程使用乘法因子；上式保留来源顺序，但由于换行可能遮蔽乘法关系，应与 PDF 核对。

### 进口商和出口商

进口企业购买同质外国品，并将其品牌化为差异化进口消费品或进口投资品。出口企业购买国内最终品，并将其品牌化为差异化出口品。它们的本币定价问题与国内价格问题类似，均为 Calvo 问题。

**(F4) 进口和出口 CES 聚合器**
$$
C_t^m=\left[\int_0^1(C_{i,t}^m)^{1/\lambda_t^{mc}}\,di\right]^{\lambda_t^{mc}},
\quad
I_t^m=\left[\int_0^1(I_{i,t}^m)^{1/\lambda_t^{mi}}\,di\right]^{\lambda_t^{mi}},
\quad
X_t=\left[\int_0^1(X_{i,t})^{1/\lambda_t^x}\,di\right]^{\lambda_t^x}.
$$

### 家庭

家庭 `j` 在标准预算约束和资本积累法则下选择消费、劳动、货币余额、国内债券、外国债券、投资、资本和利用率。来源给出效用函数：

**(F5) 家庭效用**
$$
E_0^j\sum_{t=0}^{\infty}\beta^t
\left[
\zeta_t^c\ln(C_{j,t}-bC_{j,t-1})
-\zeta_t^h A_L\frac{h_{j,t}^{1+\sigma_L}}{1+\sigma_L}
+A_q\frac{\left(Q_{j,t}/(z_tP_t^d)\right)^{1-\sigma_q}}{1-\sigma_q}
\right].
$$

总消费和总投资由国内品与进口品构成：

**(F6) 消费聚合器**
$$
C_t=\left[
(1-\omega_c)^{1/\eta_c}(C_t^d)^{(\eta_c-1)/\eta_c}
+\omega_c^{1/\eta_c}(C_t^m)^{(\eta_c-1)/\eta_c}
\right]^{\eta_c/(\eta_c-1)}.
$$

**(F7) 投资聚合器**
$$
I_t=\left[
(1-\omega_i)^{1/\eta_i}(I_t^d)^{(\eta_i-1)/\eta_i}
+\omega_i^{1/\eta_i}(I_t^m)^{(\eta_i-1)/\eta_i}
\right]^{\eta_i/(\eta_i-1)}.
$$

实物资本以一期滞后进入生产，利用率把实物资本转化为资本服务：

**(F8) 资本积累**
$$
\bar K_{t+1}=(1-\delta)\bar K_t+\mathcal{Y}_t\left(1-\tilde S(I_t/I_{t-1})\right)I_t,
\qquad K_t=u_t\bar K_t .
$$

外国债券持有面对依赖债务的风险溢价：

**(F9) 外国债券溢价**
$$
\Phi(a_t,\tilde\phi_t)=
\exp\left[-\tilde\phi_a(a_t-\bar a)+\tilde\phi_t\right],
\qquad
a_t\equiv \frac{S_tB_t^{\ast}}{P_tz_t}.
$$

### 工资设定

家庭是差异化劳动服务的垄断供给者。工资遵循 Calvo 粘性，并索引到滞后 CPI 通胀、当前通胀目标和永久技术增长。来源描述了工资设定问题，但第 2 节没有列出完整工资 Phillips 曲线；MMB `.mod` 交叉检查将其标为方程 B5。

### 中央银行

中央银行采用经验性工具规则，而不是优化损失函数。

## 3. 一阶条件（FOC）

### 价格设定

国内 Calvo 定价 FOC 以对数线性形式给出：

**(F10) 国内价格 Phillips 曲线**
$$
\begin{aligned}
\hat\pi_t^d-\hat{\bar\pi}_t^c
&=\frac{\beta}{1+\kappa_d\beta}\left(E_t\hat\pi_{t+1}^d-\rho_\pi\hat{\bar\pi}_t^c\right)
+\frac{\kappa_d}{1+\kappa_d\beta}\left(\hat\pi_{t-1}^d-\hat{\bar\pi}_t^c\right) \\
&\quad-\frac{\kappa_d\beta(1-\rho_\pi)}{1+\kappa_d\beta}\hat{\bar\pi}_t^c
+\frac{(1-\xi_d)(1-\beta\xi_d)}{\xi_d(1+\kappa_d\beta)}
\left(\widehat{mc}_t^d+\hat\lambda_t^d\right).
\end{aligned}
$$

进口消费、进口投资和出口价格 Phillips 曲线被说明为与国内曲线具有相同结构：

**(F11) 部门 `j` 的通用本币 Phillips 曲线**
$$
\begin{aligned}
\hat\pi_t^j-\hat{\bar\pi}_t^c
&=\frac{\beta}{1+\kappa_j\beta}\left(E_t\hat\pi_{t+1}^j-\rho_\pi\hat{\bar\pi}_t^c\right)
+\frac{\kappa_j}{1+\kappa_j\beta}\left(\hat\pi_{t-1}^j-\hat{\bar\pi}_t^c\right) \\
&\quad-\frac{\kappa_j\beta(1-\rho_\pi)}{1+\kappa_j\beta}\hat{\bar\pi}_t^c
+\frac{(1-\xi_j)(1-\beta\xi_j)}{\xi_j(1+\kappa_j\beta)}
\left(\widehat{mc}_t^j+\hat\lambda_t^j\right),
\qquad j\in\{mc,mi,x\}.
\end{aligned}
$$

needs_review：已发表文章说明了类似结构，但未分别列出三个部门方程；部门特定边际成本定义仅与 `.mod` 名称做了交叉检查。

### 家庭与资本 FOC

论文把家庭预算约束称为标准形式，但第 2 节未列出全部家庭 FOC。因此以下 FOC 只在模块层面得到来源支持，需要附录/PDF 对公式层面确认：

**(F12) 消费 Euler 方程，对数线性实现形式**
$$
\hat c_t =
-\frac{1}{\mu_z^2+b^2\beta}
\left[
-b\beta\mu_z\hat c_{t+1}
-b\mu_z\hat c_{t-1}
+b\mu_z(\hat\mu_{z,t}-\beta\hat\mu_{z,t+1})
+(\mu_z-b\beta)(\mu_z-b)\hat\psi_{z,t}
+\frac{\tau_c}{1+\tau_c}(\mu_z-b\beta)(\mu_z-b)\hat\tau_{c,t}
+(\mu_z-b\beta)(\mu_z-b)\hat\gamma_{cd,t}
\right]+\zeta_{c,t}.
$$

needs_review：公式来自实现交叉检查 B6，升级审阅状态前应与论文附录核对。

**(F13) 含调整成本的投资 FOC，对数线性实现形式**
$$
\hat i_t=
\frac{\mu_z^2\tilde S(\hat i_{t-1}+\beta\hat i_{t+1}-\hat\mu_{z,t}+\beta\hat\mu_{z,t+1})
+\hat P_{k,t}-\hat\gamma_{id,t}}
{\mu_z^2\tilde S(1+\beta)}
+\Upsilon_t .
$$

needs_review：公式来自实现交叉检查 B7，应与论文附录核对。

**(F14) 资本回报 FOC，对数线性实现形式**
$$
\hat\psi_{z,t}+\hat\mu_{z,t+1}-\hat\psi_{z,t+1}
-\frac{\beta(1-\delta)}{\mu_z}\hat P_{k,t+1}
+\hat P_{k,t}
-\frac{\mu_z-\beta(1-\delta)}{\mu_z}\hat r^k_{t+1}
+\frac{\tau_k}{1-\tau_k}\frac{\mu_z-\beta(1-\delta)}{\mu_z}\hat\tau_{k,t+1}=0 .
$$

needs_review：公式来自实现交叉检查 B9，应与论文附录核对。

**(F15) 实际货币余额 FOC，对数线性实现形式**
$$
-\mu\hat\psi_{z,t}+\mu\hat\psi_{z,t+1}-\mu\hat\mu_{z,t+1}
+(\mu-\beta\tau_k)\hat R_t-\mu\hat\pi_{t+1}
+\frac{\tau_k}{1-\tau_k}(\beta-\mu)\hat\tau_{k,t+1}=0 .
$$

needs_review：公式来自实现交叉检查 B8，应与论文附录核对。

**(F16) 工资 Phillips 曲线，实现交叉检查占位**
$$
\hat{\bar w}_t=\mathcal{W}\left(
\hat{\bar w}_{t-1},E_t\hat{\bar w}_{t+1},\hat\pi_t,\hat\pi_{t+1},
\hat\pi_t^c,\hat\pi_{t-1}^c,\hat{\bar\pi}_t^c,\hat\psi_{z,t},\hat H_t,
\hat\tau_{y,t},\hat\tau_{w,t},\zeta_{h,t}
\right).
$$

needs_review：第 2 节 Markdown 描述了 Calvo 工资设定，但没有列出工资方程；该占位式记录 `.mod` B5 方程识别出的状态变量，并不声称已完成来源层面的公式核查。

### 货币政策与开放经济套利

**(F17) 货币政策规则**
$$
\hat R_t=\rho_R\hat R_{t-1}
+(1-\rho_R)\left[
\hat{\pi}_t^c+r_\pi(\hat{\pi}_{t-1}^c-\hat{\bar{\pi}}_t^c)
+r_y\hat y_{t-1}+r_x\hat x_{t-1}
\right]
+r_{\Delta\pi}\Delta\hat\pi_t^c
+r_{\Delta y}\Delta\hat y_t+\varepsilon_{R,t}.
$$

needs_review：来源 OCR 在通胀目标项附近不够干净；最终审阅前应与 PDF 比对。

**(F18) 含债务弹性溢价的 UIP 条件**
$$
E_t\Delta \hat S_{t+1}-(\hat R_t-\hat R_t^{\ast})-\phi_a\hat a_t+\tilde\phi_t=0 .
$$

needs_review：论文说明了溢价并描述套利条件，但第 2 节没有列出 UIP 方程；该表达式来自实现交叉检查 B10。

## 4. 市场出清与总量恒等式

**(F19) 出口需求**
$$
C_t^x=\left(\frac{P_t^x}{P_t^{\ast}}\right)^{-\eta_f}C_t^{\ast},
\qquad
I_t^x=\left(\frac{P_t^x}{P_t^{\ast}}\right)^{-\eta_f}I_t^{\ast} .
$$

**(F20) 相对进口/出口价格，对数线性实现形式**
$$
\hat\gamma_{mcd,t}=\hat\gamma_{mcd,t-1}+\hat\pi_t^{mc}-\hat\pi_t^d,
\quad
\hat\gamma_{mid,t}=\hat\gamma_{mid,t-1}+\hat\pi_t^{mi}-\hat\pi_t^d,
\quad
\hat\gamma_{x\ast,t}=\hat\gamma_{x\ast,t-1}+\hat\pi_t^x-\hat\pi_t^{\ast} .
$$

**(F21) 实际汇率和出口边际成本恒等式**
$$
\widehat{mc}_{x,t}=\widehat{mc}_{x,t-1}+\hat\pi_t^d-\hat\pi_t^x-\Delta\hat S_t,
\qquad
\hat x_t=-\omega_c\gamma_{cmc}^{-(1-\eta_c)}\hat\gamma_{mcd,t}
-\hat\gamma_{x\ast,t}-\widehat{mc}_{x,t}.
$$

**(F22) CPI 通胀**
$$
\hat\pi_t^c=
(1-\omega_c)\gamma_{dc}^{1-\eta_c}\hat\pi_t^d
+\omega_c\gamma_{mcc}^{1-\eta_c}\hat\pi_t^{mc}.
$$

**(F23) 产出定义**
$$
\hat y_t=\lambda_d\left[\epsilon_t+\alpha(\hat k_t-\hat\mu_{z,t})+(1-\alpha)\hat H_t\right].
$$

**(F24) 总资源约束，对数线性实现形式**
$$
\begin{aligned}
&(1-\omega_c)\gamma_{cd}^{\eta_c}\frac{c}{\bar y}(\hat c_t+\eta_c\hat\gamma_{cd,t})
+(1-\omega_i)\gamma_{id}^{\eta_i}\frac{i}{\bar y}(\hat i_t+\eta_i\hat\gamma_{id,t})
+g_r\hat g_t \\
&\quad+\frac{y^{\ast}}{\bar y}(\hat y_t^{\ast}-\eta_f\hat\gamma_{x\ast,t}+\tilde z_t^{\ast})
=\lambda_d\left[\epsilon_t+\alpha(\hat k_t-\hat\mu_{z,t})+(1-\alpha)\hat H_t\right]
-\frac{(1-\tau_k)r_k\bar k}{\bar y\mu_z}(\hat k_t-\hat{\bar k}_{t-1}) .
\end{aligned}
$$

needs_review：公式来自实现交叉检查 B11，应与附录核对。

## 5. 外生过程

论文给出结构冲击的单变量 AR(1) 表示：

**(F25) 通用结构冲击过程**
$$
\hat\varsigma_t=\rho_\varsigma\hat\varsigma_{t-1}+\varepsilon_{\varsigma,t},
\qquad
\varepsilon_{\varsigma,t}\stackrel{iid}{\sim}N(0,\sigma_\varsigma^2),
$$
where
$$
\varsigma_t\in\{\mu_{z,t},\epsilon_t,\lambda_t^j,\zeta_t^c,\zeta_t^h,\gamma_t,
\tilde\phi_t,\varepsilon_{R,t},\hat{\bar\pi}_t^c,\hat z_t^{\ast}\},
\qquad j\in\{d,mc,mi,x\}.
$$

**(F26) 财政 VAR 模块**
$$
\hat f_t=A_{f,1}\hat f_{t-1}+A_{f,2}\hat f_{t-2}+B_f\varepsilon_{f,t},
\qquad
\hat f_t=(\hat\tau_t^k,\hat\tau_t^w,\hat\tau_t^y,\hat\tau_t^c,\hat g_t)' .
$$

needs_review：论文说明财政变量服从已识别的二阶 VAR；系数矩阵属于实现/校准数据，而不是论文侧方程抽取。

**(F27) 外国 VAR 模块**
$$
\hat f_t^{\ast}=A_{\ast,1}\hat f_{t-1}^{\ast}+A_{\ast,2}\hat f_{t-2}^{\ast}
+A_{\ast,3}\hat f_{t-3}^{\ast}+A_{\ast,4}\hat f_{t-4}^{\ast}+B_\ast\varepsilon_{\ast,t},
\qquad
\hat f_t^{\ast}=(\hat\pi_t^{\ast},\hat y_t^{\ast},\hat R_t^{\ast})' .
$$

needs_review：论文说明外国价格、产出和利率是外生的，并服从已识别的四阶 VAR。

## 6. 稳态求解

论文将稳态相关参数校准到观测样本均值，并报告隐含稳态值，但 Markdown 来源不包含附录推导。以下关系来自实现交叉检查，在与附录/PDF 核对前均为 `needs_review`。

1. 通胀、技术增长和名义利率：
$$
\pi=\frac{\mu}{\mu_z},
\qquad
R=\frac{\pi\mu_z-\tau_k\beta}{(1-\tau_k)\beta},
\qquad
R_f=\nu R+1-\nu .
$$

2. 进口部门替代弹性和相对价格常数：
$$
\eta_{mc}=\frac{\lambda_{mc}}{\lambda_{mc}-1},
\qquad
\eta_{mi}=\frac{\lambda_{mi}}{\lambda_{mi}-1}.
$$

3. 消费和投资组合常数：
$$
\gamma_{id}=\left[(1-\omega_i)+\omega_i\left(\frac{\eta_{mi}}{\eta_{mi}-1}\right)^{1-\eta_i}\right]^{1/(1-\eta_i)},
\quad
\gamma_{cd}=\left[(1-\omega_c)+\omega_c\left(\frac{\eta_{mc}}{\eta_{mc}-1}\right)^{1-\eta_c}\right]^{1/(1-\eta_c)}.
$$

4. 资本租金、工资、资本劳动比和数量随后由稳态资本 FOC、企业成本最小化、劳动供给、资源约束和资本积累方程递归求解。

5. 对线性化模型而言，求得的稳态是展开点；帽子变量的稳态偏离为零。

## 7. 时序与形式约定

- **线性形式**：帽子变量是相对于稳态的对数偏离。MMB 实现确认 `model(linear)`。
- **趋势处理**：单位根技术水平 `z_t` 产生共同增长；平稳化变量使用 `mu_z,t=z_t/z_{t-1}`。
- **资本时序**：时期 `t` 选择的实物资本以一期滞后进入 `\bar K_{t+1}` 的积累方程。资本服务满足 `K_t=u_t\bar K_t`，实现交叉检查在利用率和资源恒等式中使用滞后实物资本。
- **开放经济时序**：UIP 使用预期汇率变化以及当期国内/国外利差；确切日期需要附录/PDF 核查。
- **价格设定时序**：Calvo 价格和工资方程包含预期未来通胀和滞后索引价格/工资。
- **审阅状态**：仅从 `.mod` 实现导出的公式已标记为 `needs_review`，不应视为来源层面的论文方程。

## 8. 变量与参数对照表

| 类别 | 符号 / ASCII 名称 | 含义 | 主要方程 |
|---|---|---|---|
| 内生 | `Y`, `y_hat` | 国内产出 | F1, F2, F23, F24 |
| 内生 | `C`, `c_hat` | 总消费 | F5, F6, F12, F24 |
| 内生 | `I`, `i_hat` | 总投资 | F7, F8, F13, F24 |
| 内生 | `C_d`, `C_m` | 国内和进口消费 | F6 |
| 内生 | `I_d`, `I_m` | 国内和进口投资 | F7 |
| 内生 | `X`, `C_x`, `I_x` | 出口和外国需求组成 | F4, F19 |
| 内生 | `K`, `k_hat`, `k_barhat`, `u` | 资本服务、实物资本、利用率 | F2, F8, F14 |
| 内生 | `H`, `H_hat`, `E` | 劳动投入和就业 | F2, F16 |
| 内生 | `W`, `w_barhat` | 工资 | F3, F16 |
| 内生 | `MC_d`, `mc` | 国内边际成本 | F3, F10 |
| 内生 | `mc_mc`, `mc_mi`, `mc_x` | 进口/出口边际成本 | F11, F21 |
| 内生 | `pi_hat`, `pi_mc`, `pi_mi`, `pi_x`, `pi_c` | 国内、进口、出口、CPI 通胀 | F10, F11, F22 |
| 内生 | `R_hat`, `Rstar_hat`, `dS`, `x` | 政策利率、外国利率、汇率变化、实际汇率 | F17, F18, F21 |
| 内生 | `a` | 净外国资产 | F9, F18 |
| 内生 | `P_k`, `rk_hat`, `psi_zhat`, `q_hat`, `m_barhat`, `mu_hat` | 资本价格、租金率、边际效用、货币与余额 | F14, F15 |
| 外生 | `epsilon_muz`, `epsilon_epsilon`, `epsilon_Upsilon` | 技术增长、平稳技术、投资专有冲击 | F25 |
| 外生 | `epsilon_lambdad`, `epsilon_lambdamc`, `epsilon_lambdami`, `epsilon_lambdax` | 加成创新 | F25 |
| 外生 | `epsilon_zetac`, `epsilon_zetah`, `epsilon_phitilde`, `epsilon_R`, `epsilon_pibar` | 偏好、劳动、风险溢价、货币、通胀目标创新 | F17, F25 |
| 外生 | `epsilon_tauk`, `epsilon_tauw`, `epsilon_tauc`, `epsilon_tauy`, `epsilon_rhog` | 财政冲击 | F26 |
| 外生 | `epsilon_pistar`, `epsilon_ystar`, `epsilon_Rstar` | 外国 VAR 冲击 | F27 |
| 参数 | `beta`, `alpha`, `delta`, `b`, `sigma_L`, `A_L`, `A_q` | 贴现、生产、折旧、习惯、劳动/货币偏好 | F2, F5, F8, F12 |
| 参数 | `omega_c`, `omega_i`, `eta_c`, `eta_i`, `eta_f` | 进口份额和替代弹性 | F6, F7, F19 |
| 参数 | `xi_d`, `xi_mc`, `xi_mi`, `xi_x`, `xi_w`, `kappa_d`, `kappa_mc`, `kappa_mi`, `kappa_x`, `kappa_w` | Calvo 与指数化参数 | F10, F11, F16 |
| 参数 | `lambda_d`, `lambda_mc`, `lambda_mi`, `lambda_x`, `lambda_w` | 稳态加成 | F1, F4, F10, F11 |
| 参数 | `rho_R`, `rho_pi`, `rho_y`, `rho_x`, `rho_dpi`, `rho_dy`, `rho_pibar` | 政策规则和通胀目标参数 | F17 |
| 参数 | `rho_*`, `sigma_*` | AR 系数和冲击标准差 | F25, F26, F27 |
| 参数 | `tau_k`, `tau_y`, `tau_c`, `tau_w`, `nu`, `phi_a`, `mu_z`, `mu` | 税率、营运资本、风险溢价斜率、增长和货币增长 | F3, F9, F15, F18 |
