# US_SW07AL -- 推导（第一轮来源抽取）

> 档案状态：`needs_review`。本第一轮推导以 Slobodyan and Wouters (2012) 的 MinerU Markdown 为来源。未做运行时验证；未运行 Dynare。

## 1. Model Overview

- **模型**：`US_SW07AL`，Sergey Slobodyan 和 Raf Wouters (2012) 的 "Learning in an estimated medium-scale DSGE model"，发表于 Journal of Economic Dynamics and Control。
- **来源关系**：论文将 Smets-Wouters (2007) 美国中等规模 DSGE 模型中的理性预期替换为适应性学习。结构 DSGE 方程块见附录 B；本模型特有贡献是第 3 节的预期形成层。
- **经济体**：美国，季度数据，1966-2005 估计样本，七个观测变量：实际 GDP 增长、实际消费增长、实际投资增长、实际工资增长、工时对数、GDP 平减指数通胀、联邦基金利率。
- **主体和模块**：带外部习惯和劳动供给的优化家庭；带资本/劳动需求和 Calvo-Kimball 定价的厂商；带 Calvo-Kimball 工资设定的工资设定者/工会；带投资调整成本和可变利用率的资本积累；带惯性的 Taylor 规则货币当局；以及技术、风险溢价、政府支出、投资、货币政策、价格加成和工资加成冲击。
- **学习层**：私人主体用感知运动规律 (PLM) 预测前瞻变量。论文研究 MSV learning、带常数的 MSV learning、以及基于观测变量的 VAR learning；信念用 constant-gain recursive least squares 更新。
- **模型形式**：围绕去趋势变量平稳稳态的对数线性方程。论文说明非线性的去趋势系统围绕平稳稳态线性化；因此本档案条目将 MMB 实现目标视作 `model(linear)` / log-linear。
- **第一轮不确定性**：`needs_review` 覆盖附录方程中的 OCR 敏感符号、产出缺口规则所需的完整弹性价格/工资伴随系统、以及加成冲击的精确 ARMA 约定。

## 2. Optimization Problems

### 2.1 家庭

论文说明家庭在消费和劳动努力上最大化非可分效用，消费相对于外部习惯进入效用。在对数线性附录中，这一优化通过消费 Euler 方程、习惯调整参数和劳动/工资加成条件体现，而不是通过完整的非线性家庭拉格朗日式给出。

令 \(\widehat{c}_t\) 表示去趋势消费的对数偏离，\(\widehat{L}_t\) 表示劳动，\(\widehat{R}_t\) 表示名义利率偏离，\(\widehat{\pi}_t\) 表示通胀，\(\widehat{\varepsilon}^b_t\) 表示风险溢价冲击。家庭侧结构由第 3 节的习惯调整 Euler 方程和工资加成条件概括。

### 2.2 厂商和工资设定者

最终品和中间品生产者使用资本服务和差异化劳动。厂商在带部分指数化、Kimball 曲率和价格加成冲击的 Calvo 定价下设定价格。工资设定者/工会产生工资垄断力，并在平行的 Calvo/指数化结构下设定粘性名义工资。

论文附录给出对数线性的价格和工资 Phillips 曲线，而非完整的非线性 Calvo 优化递归。此处保留来源陈述的形式。

### 2.3 资本积累和利用率

家庭将资本服务出租给厂商，并在投资调整成本下选择资本积累。资本利用率随资本租金变化而调整，并面临递增利用成本。

论文附录以对数线性形式给出投资 Euler 方程、资本价值方程、资本积累、利用率条件和资本/劳动投入条件。

### 2.4 学习下的预期

在适应性学习版本中，主体不施加理性的模型一致预期。主体用线性感知运动规律预测前瞻变量：

\[
y^f_t = \alpha_{t-1} + \beta_{t-1}^{T}
\begin{bmatrix}
y^s_{t-1}\\
w_t
\end{bmatrix}.
\]

信念系数每期用 constant-gain recursive least squares 更新。该学习块不是标准私人优化问题，而是 `US_SW07AL` 的定义性行为机制。

## 3. First-Order Conditions

- **(F1) 带外部习惯的消费 Euler 方程**：

\[
\widehat{c}_t =
c_1 E_t[\widehat{c}_{t+1}]
+(1-c_1)\widehat{c}_{t-1}
+c_2\left(\widehat{L}_t-E_t[\widehat{L}_{t+1}]\right)
-c_3\left(\widehat{R}_t-E_t[\widehat{\pi}_{t+1}]+\widehat{\varepsilon}^b_t\right).
\]

其中

\[
c_1=\frac{1}{1+\bar{\eta}},\qquad
c_2=\frac{c_1(\sigma_c-1)(wL/C)}{\sigma_c},\qquad
c_3=\frac{c_1(1-\bar{\eta})}{\sigma_c},\qquad
\bar{\eta}=\eta/\gamma.
\]

- **(F2) 投资 Euler 方程**：

\[
\widehat{i}_t =
i_1\widehat{i}_{t-1}
+(1-i_1)\widehat{i}_{t+1}
+i_2\widehat{Q}^k_t
+\widehat{\varepsilon}^q_t.
\]

其中

\[
i_1=\frac{1}{1+\bar{\beta}\gamma},\qquad
i_2=\frac{i_1}{\gamma^2\varphi},\qquad
\bar{\beta}=\beta\gamma^{1-\sigma_c}.
\]

- **(F3) 已安装资本价值**：

\[
\widehat{Q}^k_t =
-\left(\widehat{R}_t-E_t[\widehat{\pi}_{t+1}]+\widehat{\varepsilon}^b_t\right)
+q_1 E_t[\widehat{r}^k_{t+1}]
+(1-q_1)E_t[\widehat{Q}^k_{t+1}].
\]

其中

\[
q_1=\frac{r^k_\ast}{r^k_\ast+(1-\delta)}.
\]

- **(F4) 带指数化的 Calvo 价格设定**：

\[
\widehat{\pi}_t-\iota_p\widehat{\pi}_{t-1}
=\pi_1\left(E_t[\widehat{\pi}_{t+1}]-\iota_p\widehat{\pi}_t\right)
-\pi_2\widehat{\mu}^p_t
+\widehat{\varepsilon}^p_t.
\]

其中

\[
\pi_1=\bar{\beta}\gamma,\qquad
\pi_2=\frac{(1-\xi_p\bar{\beta}\gamma)(1-\xi_p)}
{\xi_p(1+(\phi_p-1)\varepsilon_p)}.
\]

- **(F5) 价格加成 / 实际边际成本关系**：

\[
\widehat{\mu}^p_t=-\widehat{mc}_t,\qquad
\widehat{mc}_t=(1-\alpha)\widehat{w}_t+\alpha\widehat{r}^k_t-\widehat{\varepsilon}^a_t.
\]

- **(F6) 带指数化的 Calvo 工资设定**：

\[
\widehat{\pi}^w_t-\iota_w\widehat{\pi}_{t-1}
=\pi_1\left(E_t[\widehat{\pi}^w_{t+1}]-\iota_w\widehat{\pi}_t\right)
-\pi_3\widehat{\mu}^w_t
+\widehat{\varepsilon}^w_t.
\]

其中

\[
\pi_3=\frac{(1-\xi_w\bar{\beta}\gamma)(1-\xi_w)}
{\xi_w(1+(\phi_w-1)\varepsilon_w)}.
\]

- **(F7) 工资加成关系**：

\[
\widehat{\mu}^w_t
=\widehat{w}_t
-w_1\widehat{c}_t
+(1-w_1)\widehat{c}_{t-1}
-\sigma_l\widehat{L}_t,
\qquad
w_1=\frac{1}{1-\bar{\eta}}.
\]

- **(F8) 最优资本利用率条件**：

\[
\widehat{u}_t=\frac{1-\psi}{\psi}\widehat{r}^k_t.
\]

- **(F9) 最优资本/劳动投入条件**：

\[
\widehat{k}_t=\widehat{w}_t-\widehat{r}^k_t+\widehat{L}_t.
\]

## 4. Market Clearing & Identities

- **(F10) 总需求等于总供给 / 生产恒等式**：

\[
\widehat{y}_t
=\frac{c_\ast}{y_\ast}\widehat{c}_t
+\frac{i_\ast}{y_\ast}\widehat{i}_t
+\widehat{\varepsilon}^g_t
+\frac{r^k_\astk_\ast}{y_\ast}\widehat{u}_t
=\Phi_p\left(\alpha\widehat{k}_t+(1-\alpha)\widehat{L}_t+\widehat{\varepsilon}^a_t\right).
\]

- **(F11) 资本积累**：

\[
\widehat{\bar{k}}_t
=k_1\widehat{\bar{k}}_{t-1}
+(1-k_1)\widehat{i}_t
+k_2\widehat{\varepsilon}^q_t.
\]

其中

\[
k_1=1-\frac{i_\ast}{\bar{k}_\ast},\qquad
k_2=\frac{i_\ast}{\bar{k}_\ast}(1+\bar{\beta}\gamma)\gamma^2 S''.
\]

- **(F12) 资本服务恒等式**：

\[
\widehat{k}_t=\widehat{u}_t+\widehat{\bar{k}}_{t-1}.
\]

- **(F13) 政策规则中的产出缺口定义**：

\[
\widehat{ygap}_t=\widehat{y}_t-\widehat{y}^{flex}_t.
\]

`needs_review`：论文说明弹性经济与其余模型同时求解，并排除加成冲击，但附录 B OCR 没有给出完整的弹性价格/工资伴随方程块。

- **(F14) 货币政策规则**：

\[
\widehat{R}_t
=\rho_R\widehat{R}_{t-1}
+(1-\rho_R)\left(
r_\pi\widehat{\pi}_t
+r_y\widehat{ygap}_t
+r_{\Delta y}\Delta\widehat{ygap}_t
\right)
+\widehat{\varepsilon}^r_t.
\]

## 5. Exogenous Processes

- **(F15) 通用 ARMA 外生过程**：

\[
x_t=\rho x_{t-1}+\varepsilon_t+\theta\varepsilon_{t-1}.
\]

- **(F16) 学习解法使用的堆叠 AR(1) 表示**：

\[
w_t=\Gamma w_{t-1}+\Pi\varepsilon_t,\qquad
w_t=(x_t^T,\varepsilon_t^T)^T.
\]

- **(F17) 代入信念前的结构线性系统**：

\[
A_0
\begin{bmatrix}
y_{t-1}\\
w_{t-1}
\end{bmatrix}
+A_1
\begin{bmatrix}
y_t\\
w_t
\end{bmatrix}
+A_2E_t y_{t+1}
+B_0\varepsilon_t
=const.
\]

- **(F18) 理性预期 / MSV 解形式**：

\[
\begin{bmatrix}
y_t\\
w_t
\end{bmatrix}
=\mu+T
\begin{bmatrix}
y_{t-1}\\
w_{t-1}
\end{bmatrix}
+R\varepsilon_t,
\qquad
y_t=a+by_{t-1}+cw_t.
\]

- **(F19) 前瞻变量的感知运动规律**：

\[
y^f_t=\alpha_{t-1}+\beta_{t-1}^T
\begin{bmatrix}
y^s_{t-1}\\
w_t
\end{bmatrix}.
\]

在 MSV 情形中，回归变量是内生状态变量和外生驱动过程；在 VAR learning 情形中，回归变量限制为观测宏观变量和一个常数项。

- **(F20) Constant-gain 信念更新**：

\[
\phi_t=\phi_{t-1}
+gR_t^{-1}Z_{t-1}
\left(y^f_t-\phi_{t-1}^TZ_{t-1}\right)^T.
\]

- **(F21) Constant-gain 二阶矩更新**：

\[
R_t=R_{t-1}+g\left(Z_{t-1}Z_{t-1}^T-R_{t-1}\right).
\]

其中

\[
Z_t=\left(1,(y^s_{t-1})^T,w_t^T\right)^T,\qquad
\phi^T=(\alpha,\beta^T).
\]

`needs_review`：附录文字/OCR 说明有 12 个前瞻变量、11 个内生状态变量和 9 个外生随机过程，但 \(\alpha_{t-1}\) 的渲染维度被 OCR 损坏。

- **(F22) 由 REE 矩初始化信念**：

\[
\phi_0
=E[Z_{t-1}Z_{t-1}^T]^{-1}
E[Z_{t-1}(y^f_t)^T],
\qquad
R_0=E[Z_{t-1}Z_{t-1}^T].
\]

## 6. Steady-State Solution

附录 B 方程是围绕去趋势变量平稳稳态的对数线性方程。因此，对 `model(linear)` 档案条目，相关稳态解为：

1. 用确定性劳动增广技术增长对实际量去趋势。
2. 将平稳实际变量的对数偏离以及通胀/利率偏离在稳态设为零：

\[
\widehat{c}_\ast=\widehat{i}_\ast=\widehat{y}_\ast=\widehat{w}_\ast=\widehat{L}_\ast
=\widehat{\pi}_\ast=\widehat{R}_\ast=\widehat{Q}^k_\ast
=\widehat{r}^k_\ast=\widehat{u}_\ast=0.
\]

3. 将创新和外生偏离设为零：

\[
\widehat{\varepsilon}^a_\ast=\widehat{\varepsilon}^b_\ast=\widehat{\varepsilon}^g_\ast=\widehat{\varepsilon}^q_\ast=\widehat{\varepsilon}^r_\ast=\widehat{\varepsilon}^p_\ast=\widehat{\varepsilon}^w_\ast=0.
\]

4. 对学习状态，如果信念由 REE 矩初始化，使用 (F22)。在模型一致信念和零创新下，PLM 给出的稳态预期等于零偏离稳态。
5. 出现在对数线性系数中的结构稳态比率和校准常数包括 \(c_\ast/y_\ast\)、\(i_\ast/y_\ast\)、\(r^k_\astk_\ast/y_\ast\)、\(\bar{k}_\ast\)、\(r^k_\ast\)、\(\bar{\eta}\)、\(\bar{\beta}\) 和 \(\gamma\)。论文附录没有给出完整非线性稳态推导；本第一轮档案将这些系数记录为来源陈述输入，并将完整非线性重构标为 `needs_review`。

运行时验证状态：未执行。未运行 Dynare。

## 7. Timing & Form Conventions

- **形式**：去趋势变量平稳稳态附近的 log-linear / `model(linear)` 偏离方程。
- **资本时序**：\(\widehat{\bar{k}}_t\) 是由 (F11) 演化的已安装资本存量。生产中使用的资本服务满足 \(\widehat{k}_t=\widehat{u}_t+\widehat{\bar{k}}_{t-1}\)，因此生产使用进入第 \(t\) 期之前已选择的预定安装资本。
- **预期时序**：前瞻变量 \(y^f_t\) 由 \(t-1\) 时已知的信念和 \(Z_t\) / \(Z_{t-1}\) 中的信息预测，具体取决于学习递归。论文在变量不可观测时使用 Kalman-filtered 模型变量。
- **学习变体**：MSV learning 使用模型状态和外生变量；带常数的 MSV learning 也学习常数；VAR learning 将信念方程限制为观测变量和常数。
- **Projection facility**：当学习动态产生爆炸性的临时转移矩阵时，论文遵循学习文献做法，排除这些更新。
- **实现交叉检查**：不存在 `.agents/skills/dynare-copilot/references/examples/US_SW07AL_rep.mod` 文件。存在相关的 `US_SW07_rep.mod`，但没有作为本模型的指定交叉检查证据使用。

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Equation(s) |
|---|---|---|---|
| Endogenous | `c` / \(\widehat{c}\) | 消费偏离 | (F1) |
| Endogenous | `i` / \(\widehat{i}\) | 投资偏离 | (F2), (F10), (F11) |
| Endogenous | `qk` / \(\widehat{Q}^k\) | 已安装资本价值 | (F2), (F3) |
| Endogenous | `rk` / \(\widehat{r}^k\) | 资本租金 | (F3), (F5), (F8), (F9) |
| Endogenous | `pi` / \(\widehat{\pi}\) | 价格通胀 | (F1), (F4), (F6), (F14) |
| Endogenous | `piw` / \(\widehat{\pi}^w\) | 工资通胀 | (F6) |
| Endogenous | `mc` / \(\widehat{mc}\) | 实际边际成本 | (F5) |
| Endogenous | `mup` / \(\widehat{\mu}^p\) | 价格加成 | (F4), (F5) |
| Endogenous | `muw` / \(\widehat{\mu}^w\) | 工资加成 | (F6), (F7) |
| Endogenous | `w` / \(\widehat{w}\) | 实际工资 | (F5), (F7), (F9) |
| Endogenous | `lab` / \(\widehat{L}\) | 劳动 | (F1), (F7), (F9), (F10) |
| Endogenous | `y` / \(\widehat{y}\) | 产出 | (F10), (F13) |
| Endogenous | `ygap` / \(\widehat{ygap}\) | 产出缺口 | (F13), (F14) |
| Endogenous | `yflex` / \(\widehat{y}^{flex}\) | 弹性价格/工资产出 | (F13) |
| Endogenous | `kbar` / \(\widehat{\bar{k}}\) | 已安装资本存量 | (F11), (F12) |
| Endogenous | `k` / \(\widehat{k}\) | 生产中的资本服务 | (F9), (F10), (F12) |
| Endogenous | `u` / \(\widehat{u}\) | 利用率 | (F8), (F10), (F12) |
| Endogenous | `R` / \(\widehat{R}\) | 名义利率偏离 | (F1), (F3), (F14) |
| Learning state | `phi` / \(\phi\) | 信念系数矩阵 | (F20), (F22) |
| Learning state | `Rbel` / \(R_t\) | 信念二阶矩矩阵 | (F21), (F22) |
| Learning state | `yf` / \(y^f\) | PLM 下预测的前瞻变量 | (F19), (F20), (F22) |
| Exogenous shock | `eps_a` / \(\varepsilon^a\) | 技术冲击 | (F5), (F10), (F15) |
| Exogenous shock | `eps_b` / \(\varepsilon^b\) | 风险溢价冲击 | (F1), (F3), (F15) |
| Exogenous shock | `eps_g` / \(\varepsilon^g\) | 政府/外生需求冲击 | (F10), (F15) |
| Exogenous shock | `eps_q` / \(\varepsilon^q\) | 投资特定技术冲击 | (F2), (F11), (F15) |
| Exogenous shock | `eps_r` / \(\varepsilon^r\) | 货币政策冲击 | (F14), (F15) |
| Exogenous shock | `eps_p` / \(\varepsilon^p\) | 价格加成冲击 | (F4), (F15) |
| Exogenous shock | `eps_w` / \(\varepsilon^w\) | 工资加成冲击 | (F6), (F15) |
| Parameter | `eta` / \(\eta\) | 外部习惯参数 | (F1), (F7) |
| Parameter | `gamma` / \(\gamma\) | 附录系数中的趋势增长调整 | (F1), (F2), (F4), (F6), (F11) |
| Parameter | `sigmac` / \(\sigma_c\) | 跨期替代弹性倒数 | (F1), (F2), (F7) |
| Parameter | `varphi` / \(\varphi\) | 投资调整成本弹性 | (F2) |
| Parameter | `beta` / \(\beta\) | 贴现因子 | (F2), (F4), (F6), (F11) |
| Parameter | `delta` / \(\delta\) | 折旧率，校准为 0.025 | (F3) |
| Parameter | `alpha` / \(\alpha\) | 资本份额 | (F5), (F9), (F10) |
| Parameter | `xip`, `xiw` / \(\xi_p,\xi_w\) | Calvo 价格/工资粘性 | (F4), (F6) |
| Parameter | `iotap`, `iotaw` / \(\iota_p,\iota_w\) | 价格/工资指数化 | (F4), (F6) |
| Parameter | `phip`, `phiw` / \(\phi_p,\phi_w\) | Kimball 曲率；\(\phi_w\) 校准为 1.5 | (F4), (F6) |
| Parameter | `epsp`, `epsw` / \(\varepsilon_p,\varepsilon_w\) | 价格/工资替代曲率，均校准为 10 | (F4), (F6) |
| Parameter | `psi` / \(\psi\) | 利用率成本弹性 | (F8) |
| Parameter | `rhoR` / \(\rho_R\) | 利率平滑 | (F14) |
| Parameter | `rpi`, `ry`, `rdy` | 对通胀、产出缺口、产出缺口增长的政策反应 | (F14) |
| Parameter | `g` | 学习递归中的 constant gain | (F20), (F21) |
| Parameter | `rho`, `theta` | 外生过程的持久性和 MA 项 | (F15), (F16) |
