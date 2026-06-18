# US_DG08 -- 推导（最优化问题 + 一阶条件）

> `US_DG08` 的归档条目。未执行运行时验证。论文直接给出估计用的对数线性化系统，因此下面的最优化问题是有来源依据的经济原始结构说明，而不是完整的非线性规划。

## 1. Model Overview

- **模型**：De Graeve (2008), "The external finance premium and the macroeconomy: US post-WWII evidence."
- **作者/年份**：Ferre De Graeve, 2008。
- **DOI**：`10.1016/j.jedc.2008.02.008`。
- **来源**：`raw/mmb_mineru/runs/us_dg08__the_external_finance_premium_and_the_macroeconomy_us_post_wwii_evidence__6112c2c0/full.md`；原始 PDF 为 `raw/mmb_papers/The external finance premium and the macroeconomy- US post-WWII evidence..pdf`。
- **MMB 实现交叉检查**：`.agents/skills/dynare-copilot/references/examples/US_DG08_rep.mod`。
- **用途**：估计一个包含 Bernanke-Gertler-Gilchrist 金融加速器的美国战后中型 DSGE 模型，并从宏观数据中推断模型一致的外部融资溢价。
- **主体**：具有习惯形成和差异化劳动的家庭、具有粘性价格的垄断竞争中间品厂商、最终品厂商、具有投资调整成本的资本品生产商、由内部净值和银行贷款融资的企业家、存在 costly state verification 的金融中介，以及货币当局。
- **形式**：对数线性化 `model(linear)`。带帽变量是论文和实现中的稳态偏离。首次公式状态为 `needs_review`，因为若干 OCR 符号和实现归一化仍需逐页核对。

## 2. Optimization Problems

### 家庭

家庭选择消费、债券持有和差异化劳动服务。论文没有打印完整的家庭目标函数，但方程 (1) 和 (2) 表明模型包含外部习惯、消费与劳动的非可分性、差异化劳动供给、Calvo 工资设定、工资部分指数化、贴现因子冲击、劳动供给冲击和工资加成冲击。

有来源依据的简约原始结构为：

\[
U_t = U(C_t, C_{t-1}, L_t; h, \sigma_c, \sigma_l, \varepsilon_t^B, \varepsilon_t^L),
\qquad
W_t(j)\ \text{is reset only with probability}\ 1-\xi_w .
\]

### 厂商

最终品厂商聚合差异化中间品。中间品厂商租用资本服务和劳动，使用带固定成本和可变资本利用率的 Cobb-Douglas 生产函数，并且只有概率 \(1-\xi_p\) 可以重新定价。

\[
Y_t = F(\varepsilon_t^A, K_{t-1}, u_t, L_t;\alpha,\phi),
\qquad
P_t(i)\ \text{is partially indexed with parameter}\ \gamma_p .
\]

### 资本品生产商

资本品生产商在投资调整成本和投资特定技术冲击下，把投资品转化为安装资本：

\[
K_{t+1}=(1-\tau)K_t+\tau I_t+\text{investment-technology disturbance}.
\]

### 企业家与金融中介

企业家用净值 \(N_{t+1}\) 和外部借款，以价格 \(Q_t\) 购买资本 \(K_{t+1}\)。Costly state verification 产生随杠杆上升而上升的外部融资溢价，其对数线性形式由方程 (F9) 概括。

### 货币当局

货币当局采用经验 Taylor 规则，包括利率平滑、对通胀和产出缺口水平的反应、speed-limit 项、临时货币政策冲击和持续性通胀目标冲击。

## 3. First-Order Conditions

论文第 2 节打印估计用的对数线性系统。除特别说明外，(F1)-(F12) 对应论文方程 (1)-(12)。

- **(F1) 带习惯和偏好冲击的消费 Euler 方程**：

\[
\hat C_t =
\frac{h}{1+h}\hat C_{t-1}
+\frac{1}{1+h}E_t\hat C_{t+1}
+\frac{\sigma_c-1}{(1+\lambda_w)(1+h)\sigma_c}
(\hat L_t-E_t\hat L_{t+1})
-\frac{1-h}{(1+h)\sigma_c}\hat R_t
+\frac{1-h}{(1+h)\sigma_c}
(\hat\varepsilon_t^B-E_t\hat\varepsilon_{t+1}^B).
\]

- **(F2) 粘性工资方程**：

\[
\begin{aligned}
\hat w_t={}&
\frac{\beta}{1+\beta}E_t\hat w_{t+1}
+\frac{1}{1+\beta}\hat w_{t-1}
+\frac{\beta}{1+\beta}(E_t\hat\pi_{t+1}-\bar\pi_t)
-\frac{1+\beta\gamma_w}{1+\beta}(\hat\pi_t-\bar\pi_t) \\
&+\frac{\gamma_w}{1+\beta}(\hat\pi_{t-1}-\bar\pi_t)
-\frac{1}{1+\beta}
\frac{(1-\beta\xi_w)(1-\xi_w)}
{(1+(1+\lambda_w)\sigma_l/\lambda_w)\xi_w}
\left[
\hat w_t-\sigma_l\hat L_t-\frac{\sigma_c}{1-h}(\hat C_t-h\hat C_{t-1})
-\hat\varepsilon_t^L
\right]
+\eta_t^W .
\end{aligned}
\]

- **(F3) 总供给 / 生产函数**：

\[
\hat Y_t =
\phi\hat\varepsilon_t^A
+\phi\alpha\hat K_{t-1}
+\frac{\phi\alpha}{\psi}\hat r_t^k
+\phi(1-\alpha)\hat L_t .
\]

- **(F4) 劳动需求**：

\[
\hat L_t =
-\hat w_t+\left(1+\frac{1}{\psi}\right)\hat r_t^k+\hat K_{t-1}.
\]

- **(F5) 粘性价格 Phillips 曲线**：

\[
\begin{aligned}
\hat\pi_t-\bar\pi_t={}&
\frac{\beta}{1+\beta\gamma_p}(E_t\hat\pi_{t+1}-\bar\pi_t)
+\frac{\gamma_p}{1+\beta\gamma_p}(\hat\pi_{t-1}-\bar\pi_t)\\
&+\frac{1}{1+\beta\gamma_p}
\frac{(1-\beta\xi_p)(1-\xi_p)}{\xi_p}
\left[\alpha\hat r_t^k+(1-\alpha)\hat w_t-\hat\varepsilon_t^A\right]
+\eta_t^P .
\end{aligned}
\]

- **(F6) 资本积累**：

\[
\hat K_{t+1}=(1-\tau)\hat K_t+\tau\hat I_t+\tau\hat\varepsilon_t^I .
\]

- **(F7) 投资调整成本条件**：

\[
\hat I_t=
\frac{1}{1+\beta}\hat I_{t-1}
+\frac{\beta}{1+\beta}E_t\hat I_{t+1}
+\frac{1/\varphi}{1+\beta}(\hat Q_t+\hat\varepsilon_t^I).
\]

- **(F8) 预期实际资本回报**：

\[
E_t\hat R_{t+1}^K =
\frac{1-\tau}{\bar R^K}E_t\hat Q_{t+1}
+\frac{\bar r^k}{\bar R^K}E_t\hat r_{t+1}^k
-\hat Q_t .
\]

- **(F9) 外部融资溢价 / 资本套利条件**：

\[
E_t\hat R_{t+1}^K =
-\varepsilon E_t[\hat N_{t+1}-\hat Q_t-\hat K_{t+1}]
+\hat R_t .
\]

- **(F10) 企业家净值**：

\[
\hat N_{t+1} =
\gamma\bar R^K
\left[
\frac{\bar K}{\bar N}
(\hat R_t^K-E_{t-1}\hat R_t^K)
+E_{t-1}\hat R_t^K+\hat N_t
\right].
\]

## 4. Market Clearing & Identities

- **(F11) 产品市场资源约束**：

\[
\hat Y_t =
c_y\hat C_t+\tau k_y\hat I_t+\varepsilon_t^G
+c_{\mathrm{util},t}
+c_{\mathrm{bankrupt},t}.
\]

实现交叉检查把资本利用成本和破产成本展开为：

\[
c_{\mathrm{util},t}+c_{\mathrm{bankrupt},t}
\approx
(\bar R^K+\tau-1)\frac{1}{\psi}k_y\hat r_t^k
+(\bar R^K-1/\beta)
\left(1-\frac{\bar N}{\bar K}\right)
k_y(\hat R_t^K+\hat Q_{t-1}+\hat K_t).
\]

- **(F12) 货币政策规则**：

\[
\begin{aligned}
\hat R_t^n={}&
\rho\hat R_{t-1}^n
+(1-\rho)\left\{\bar\pi_t+r_\pi(\hat\pi_t-\bar\pi_t)
+r_Y(\hat Y_t-\hat Y_t^p)\right\}\\
&+r_{\Delta\pi}(\hat\pi_t-\hat\pi_{t-1})
+r_{\Delta Y}\left[\hat Y_t-\hat Y_t^p-(\hat Y_{t-1}-\hat Y_{t-1}^p)\right]
+\eta_t^R .
\end{aligned}
\]

- **(F13) Fisher 关系 / 实际利率恒等式**：

\[
\hat R_t^n=\hat R_t+E_t\hat\pi_{t+1}.
\]

- **(F14) 外部融资溢价定义**：

\[
\widehat{\mathrm{Prem}}_t=E_t\hat R_{t+1}^K-\hat R_t.
\]

- **(F15) 弹性价格产出目标**：

\[
\hat Y_t^p
\quad\text{is the flexible-price, flexible-wage, frictionless-credit-market equilibrium.}
\]

`.mod` 交叉检查用 \(C^f,L^f,w^f,Y^f,K^f,r^{k,f},I^f,Q^f,R^f\) 的平行弹性价格模块表示该目标；这些方程属于 implementation_cross_check，而不是论文打印的方程。

## 5. Exogenous Processes

- **(F16) 通胀目标**：

\[
\bar\pi_t=\bar\pi_{t-1}+\eta_t^\pi .
\]

- **(F17) 贴现因子冲击**：

\[
\hat\varepsilon_t^B=\rho_B\hat\varepsilon_{t-1}^B+\epsilon_t^B .
\]

- **(F18) 劳动供给冲击**：

\[
\hat\varepsilon_t^L=\rho_L\hat\varepsilon_{t-1}^L+\epsilon_t^L .
\]

- **(F19) 生产率冲击**：

\[
\hat\varepsilon_t^A=\rho_A\hat\varepsilon_{t-1}^A+\epsilon_t^A .
\]

- **(F20) 投资特定技术冲击**：

\[
\hat\varepsilon_t^I=\rho_I\hat\varepsilon_{t-1}^I+\epsilon_t^I .
\]

- **(F21) 政府支出冲击**：

\[
\hat\varepsilon_t^G=\rho_G\hat\varepsilon_{t-1}^G+\epsilon_t^G .
\]

AR(1) 冲击记号和创新名称来自 `US_DG08_rep.mod` 的交叉检查。论文讨论了结构冲击并打印通胀目标过程；具体实现名称不作为论文侧推导证据。

## 6. Steady-State Solution

因为模型是对数线性化，所有带帽内生变量和持续性冲击状态的稳态偏离均为零：

\[
\hat C=\hat L=\hat R=\hat w=\hat\pi=\hat Y=\hat K=\hat r^k=\hat I=\hat Q
=\hat R^K=\hat N=\widehat{\mathrm{Prem}}=0.
\]

线性系统需要的非零稳态比率和水平由校准或估计给出：

\[
\bar R=1/\beta,\qquad
\bar R^K\ \text{estimated},\qquad
\bar r^k=\bar R^K-1+\tau,\qquad
c_y=\bar C/\bar Y,\qquad
k_y=\bar K/\bar Y,\qquad
\bar K/\bar N\ \text{estimated}.
\]

对于基准 MMB 实现，posterior mode 交叉检查值包括 \(\beta=0.99\)、\(\tau=0.025\)、\(\bar R^K=1.0131\)、\(\varepsilon=0.1005\)、\(\gamma=0.9923\)、\(\bar K/\bar N=1.4202\)、\(c_y=0.65\) 和 \(k_y=0.17/\tau\)。这些值属于 implementation_cross_check 校准值。

## 7. Timing & Form Conventions

- **形式**：`model(linear)`，变量为相对稳态的对数线性偏离。
- **资本时序**：论文把资本积累写成由 \(\hat K_t\) 和 \(\hat I_t\) 决定 \(\hat K_{t+1}\)；`.mod` 将其移位为 `K = (1-tau)K(-1)+...`，所以实现中的当期资本是预定状态，对应上一期选择的安装资本。
- **回报时序**：企业家在 \(t\) 期以 \(Q_t\) 购买 \(K_{t+1}\)，预期回报为 \(E_t\hat R_{t+1}^K\)。`.mod` 使用 `Rkforward = Rk(+1)` 表示这一预期时序。
- **金融摩擦**：外部融资溢价随净值相对资本支出的比例下降而上升，等价地随杠杆 \(\hat Q_t+\hat K_{t+1}-\hat N_{t+1}\) 上升而上升。
- **弹性目标**：政策产出缺口使用弹性价格产出 \(Y^p\)，实现为 `Yf`。
- **运行时验证**：未执行；本归档条目没有运行 Dynare。
- **公式疑点**：论文 OCR 在若干正文位置把弹性符号识别成短横；本推导依公式和实现采用 \(\varepsilon\)。投资冲击归一化在论文方程 (6) 与 MMB 实现之间不同，标记为 `needs_review`。

## 8. Variable & Parameter Reference Table

| Category | Symbol / Dynare name | Meaning | Main equation |
|---|---|---|---|
| Endogenous | \(\hat C_t\) / `C` | 消费偏离 | (F1) |
| Endogenous | \(\hat L_t\) / `L` | 劳动偏离 | (F2), (F4) |
| Endogenous | \(\hat R_t\) / `R` | 实际利率偏离 | (F1), (F13) |
| Endogenous | \(\hat w_t\) / `w` | 实际工资偏离 | (F2), (F4) |
| Endogenous | \(\hat\pi_t\) / `pi` | 通胀偏离 | (F5), (F12) |
| Endogenous | \(\bar\pi_t\) / `pibar` | 通胀目标 | (F12), (F16) |
| Endogenous | \(\hat Y_t\) / `Y` | 产出偏离 | (F3), (F11) |
| Endogenous | \(\hat K_t\) / `K` | 安装资本偏离 | (F6) |
| Endogenous | \(\hat r_t^k\) / `ren` | 资本租金率 | (F3), (F4), (F8) |
| Endogenous | \(\hat I_t\) / `I` | 投资偏离 | (F7), (F11) |
| Endogenous | \(\hat Q_t\) / `Q` | 安装资本价格 | (F7), (F8), (F9) |
| Endogenous | \(\hat R_t^K\) / `Rk`, `Rkforward` | 资本回报 | (F8), (F9), (F10) |
| Endogenous | \(\hat N_t\) / `N` | 企业家净值 | (F10) |
| Endogenous | \(\hat R_t^n\) / `Rn` | 名义政策利率 | (F12), (F13) |
| Endogenous | \(\widehat{\mathrm{Prem}}_t\) / `Prem` | 外部融资溢价 | (F14) |
| Endogenous | `Cf,Lf,Rf,wf,Yf,Kf,renf,If,Qf` | 弹性价格对应变量 | (F15) |
| Exogenous state | \(\hat\varepsilon_t^B\) / `eps_B` | 贴现因子冲击状态 | (F17) |
| Exogenous state | \(\hat\varepsilon_t^L\) / `eps_L` | 劳动供给冲击状态 | (F18) |
| Exogenous state | \(\hat\varepsilon_t^A\) / `eps_A` | 生产率冲击状态 | (F19) |
| Exogenous state | \(\hat\varepsilon_t^I\) / `eps_I` | 投资特定冲击状态 | (F20) |
| Exogenous state | \(\hat\varepsilon_t^G\) / `eps_G` | 政府支出冲击状态 | (F21) |
| Innovation | `eta_w`, `eta_p`, `eta_R`, `etapi` | 工资加成、价格加成、利率、目标冲击 | (F2), (F5), (F12), (F16) |
| Innovation | `epsinno_B`, `epsinno_L`, `epsinno_A`, `epsinno_I`, `epsinno_G` | 持续性冲击创新 | (F17)-(F21) |
| Parameter | \(h,\sigma_c,\lambda_w,\beta,\gamma_w,\xi_w,\sigma_l\) | 家庭和工资设定参数 | (F1), (F2) |
| Parameter | \(\alpha,\psi,\gamma_p,\xi_p,\tau,\phi\) | 生产、资本利用、价格、折旧和投资成本参数 | (F3)-(F8) |
| Parameter | \(\bar R^K,\varepsilon,\gamma,\bar K/\bar N\) | 金融加速器参数 | (F8)-(F10) |
| Parameter | \(c_y,k_y\) | 稳态支出和资本产出比 | (F11) |
| Parameter | \(\rho,r_\pi,r_Y,r_{\Delta\pi},r_{\Delta Y}\) | 政策规则参数 | (F12) |
| Parameter | \(\rho_B,\rho_L,\rho_A,\rho_I,\rho_G\) | 冲击持续性参数 | (F17)-(F21) |
