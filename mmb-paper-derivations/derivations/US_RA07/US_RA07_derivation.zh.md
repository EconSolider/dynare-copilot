# US_RA07 - 推导（最优化问题 + 一阶条件）

> `US_RA07` 的模型档案条目。来源：Pau Rabanal (2007), "Does inflation increase after a monetary policy tightening? Answers based on an estimated DSGE model", *Journal of Economic Dynamics & Control* 31(3), 906-937, DOI `10.1016/j.jedc.2006.01.008`。

## 1. Model Overview

- **模型**：估计的美国中等规模新凯恩斯 DSGE 模型，含货币政策工作资本成本渠道。
- **目的**：检验当名义利率进入生产成本时，紧缩性货币政策冲击后通胀是否可能上升。
- **主体与模块**：差异化家庭、中间品厂商、最终品厂商、财政当局和货币当局。
- **刚性**：Calvo 价格和工资设定、价格和工资滞后指数化、消费外部习惯形成、可变资本利用率和投资调整成本。
- **冲击**：货币政策、技术、财政支出和价格加成冲击。
- **形式**：`model(linear)`。论文先给出非线性基本设定，再在零通胀对称稳态附近使用对数线性均衡条件。除实际工资变量外，小写变量为对数偏离；实际工资在论文中记为 \(\omega_t\)。
- **运行验证**：未执行。此档案条目没有运行 Dynare。

## 2. Optimization Problems

### 中间品厂商

中间品厂商 \(i\) 使用资本服务和差异化劳动生产：

\[
Y^i_t = A_t (u_t K_{i,t})^\alpha N_{i,t}^{1-\alpha}.
\]

劳动是家庭特定劳动类型的 CES 加总：

\[
N_{i,t} =
\left[\int_0^1 (N^j_{i,t})^{(\phi-1)/\phi}\,dj\right]^{\phi/(\phi-1)}.
\]

成本渠道假设适用于比例为 \(\gamma\) 的厂商：这些厂商在出售产出前，必须按总名义利率借款支付工资账单。因此名义利率成为有效劳动成本的一部分。

### 最终品厂商

竞争性最终品厂商加总差异化中间品：

\[
Y_t =
\left[\int_0^1 (Y^i_t)^{(\lambda_t-1)/\lambda_t}\,di\right]^{\lambda_t/(\lambda_t-1)}.
\]

利润最大化推出每种中间品的标准 CES 需求曲线。

### 家庭

家庭 \(j\) 最大化外部习惯效用：

\[
E_0\sum_{t=0}^{\infty}\beta^t
\left[
\frac{(C^j_t-bC_{t-1})^{1-\sigma}}{1-\sigma}
-\frac{(N^j_t)^{1+\eta}}{1+\eta}
\right],
\]

约束为包含名义债券、资本、利用率、投资、工资收入、转移和利润收入的预算约束：

\[
C^j_t + I^j_t + \frac{B^j_t}{P_tR_t}
= \frac{W^j_tN^j_t}{P_t}+\frac{B^j_{t-1}}{P_t}
+[R^k_tu_t-\Psi(u_t)]K^j_{t-1}+T^j_t+\int_0^1\Pi^j_t(i)\,di.
\]

资本按照含投资调整成本的运动方程演化：

\[
K_t=(1-\delta)K_{t-1}+\left[1-S\left(\frac{I_t}{I_{t-1}}\right)\right]I_t.
\]

### 价格和工资设定者

中间品厂商以概率 \(1-\theta_p\) 重新设定价格；未重新设定价格的厂商以权重 \(\omega_p\) 指数化到滞后通胀。家庭以概率 \(1-\theta_w\) 重新设定工资；未重新设定工资的家庭以权重 \(\omega_w\) 指数化到滞后价格通胀。

### 政策当局

财政政策为李嘉图式，通过一次总付转移和债券发行清算政府购买。货币政策遵循利率规则，对通胀和产出偏离作出反应，并含利率平滑。

## 3. First-Order Conditions

- **(F1) 价格 Phillips 曲线**：

\[
\Delta p_t =
\gamma_b\Delta p_{t-1}
+\gamma_f E_t\Delta p_{t+1}
+\kappa_p mc_t
+\kappa_p\varepsilon^p_t.
\]

其中 \(\gamma_b=\omega_p/(1+\beta\omega_p)\)，\(\gamma_f=\beta/(1+\beta\omega_p)\)，且
\(\kappa_p=(1-\theta_p\beta)(1-\theta_p)/[(1+\beta\omega_p)\theta_p]\)。

- **(F2) 含成本渠道的实际边际成本**：

\[
mc_t=\alpha r^k_t+(1-\alpha)(\omega_t+\gamma r_t)-a_t.
\]

其中 \(\gamma r_t\) 是工作资本项。这是线性化模型中的来源明示条件，也是关键成本渠道项。

- **(F3) 资本利用率条件**：

\[
u_t=\psi r^k_t.
\]

论文在稳态利用率为一时定义 \(\psi=\Psi'(1)/\Psi''(1)\)。`needs_review`：OCR 对非线性基本设定中的部分利用成本符号识别不完整。

- **(F4) 工资 Phillips 曲线**：

\[
\begin{aligned}
(1+\beta)\omega_t
=&\ \omega_{t-1}+\beta E_t\omega_{t+1}
+\omega_w\Delta p_{t-1}
-(1+\beta\omega_w)\Delta p_t
+\beta E_t\Delta p_{t+1} \\
&-\kappa_w\left[
\omega_t-\frac{\sigma}{1-b}(c_t-bc_{t-1})-\eta n_t
\right].
\end{aligned}
\]

其中 \(\kappa_w=(1-\theta_w\beta)(1-\theta_w)/\{[1+\phi(\eta-1)]\theta_w\}\)。`needs_review`：OCR 中 \(\omega_{\mathrm{w}}\) 与 \(\omega_t\) 相邻，规范化符号遵循论文意图的工资指数化变量和实际工资变量。

- **(F5) 最优资本-劳动比**：

\[
l_t-u_t-k_{t-1}=r^k_t-(\omega_t+\gamma r_t).
\]

成本渠道项提高受影响厂商的有效劳动边际成本。

- **(F6) 含外部习惯的消费 Euler 方程**：

\[
(1+b)c_t=bc_{t-1}+E_tc_{t+1}
-(1-b)\sigma^{-1}\left(r_t-E_t\Delta p_{t+1}\right).
\]

- **(F7) Tobin's Q 方程**：

\[
q_t=\beta(1-\delta)E_tq_{t+1}
+[1-\beta(1-\delta)]E_tr^k_{t+1}
-\left(r_t-E_t\Delta p_{t+1}\right).
\]

- **(F8) 资本积累**：

\[
k_t=(1-\delta)k_{t-1}+\delta i_t.
\]

- **(F9) 投资调整成本条件**：

\[
i_t=\frac{1}{1+\beta}\left(\beta E_ti_{t+1}+i_{t-1}+\varphi q_t\right).
\]

论文定义 \(\varphi=1/\bar S''\)。

- **(F10) 生产函数**：

\[
y_t=a_t+\alpha(u_t+k_{t-1})+(1-\alpha)n_t.
\]

- **(F11) 货币政策规则**：

\[
r_t=\rho_r r_{t-1}
+(1-\rho_r)\gamma_p\Delta p_t
+(1-\rho_r)\gamma_y y_t
+\varepsilon^z_t.
\]

政策冲击 \(\varepsilon^z_t\) 为 iid，并直接进入规则。

## 4. Market Clearing & Identities

- **(F12) 总资源约束**：

\[
y_t=(1-\bar I-\bar G)c_t+\bar I i_t+\bar G g_t
+\alpha\frac{\bar\lambda}{\bar\lambda-1}u_t.
\]

其中

\[
\bar I=
\frac{\delta\alpha\bar\lambda}
{(\bar\lambda-1)[1/\beta-(1-\delta)]}.
\]

- **劳动符号恒等式**（`implementation_cross_check`）：

\[
n_t=l_t.
\]

该恒等式不是发表论文线性化列表中的单独纸面均衡方程。MMB 实现加入它，是因为论文在资本-劳动比条件中使用劳动符号不一致。这里仅作为实现交叉检查记录。

## 5. Exogenous Processes

- **(F13) 技术冲击**：

\[
a_t=\rho_a a_{t-1}+\varepsilon^a_t.
\]

- **(F14) 财政支出冲击**：

\[
g_t=\rho_g g_{t-1}+\varepsilon^g_t.
\]

- **(F15) 价格加成冲击**：

\[
\varepsilon^p_t \sim iid,\qquad E[\varepsilon^p_t]=0.
\]

货币政策冲击 \(\varepsilon^z_t\) 为 iid，并出现在 (F11) 中。论文说明货币政策和价格加成冲击没有序列相关；技术和财政冲击遵循 AR(1) 过程。

## 6. Steady-State Solution

由于 `US_RA07` 表示为对数线性的 `model(linear)` 条目，稳态偏离均为零：

\[
\Delta p = mc = r^k = \omega = r = a = u = n = c = l = q = i = k = y = g = 0.
\]

来源支持的固定稳态/校准值包括：

- 估计中 \(\beta=0.99\)，CEE 风格校准练习和 MMB 实现基准中 \(\beta=0.9926\)。
- \(\delta=0.025\) 季度折旧率。
- \(\alpha=0.36\) 资本份额。
- \(\bar G=0.2\) 政府消费-产出比。
- \(\bar\lambda=6\) 稳态替代弹性。
- \(\bar I=\delta\alpha\bar\lambda/\{(\bar\lambda-1)[1/\beta-(1-\delta)]\}\)。

`needs_review`：在任何运行验证前，应复核论文固定值、表 2 后验基准值与 MMB 实现中各图对应参数块之间的精确一致性。

## 7. Timing & Form Conventions

- **线性形式**：以上所有均衡方程均为围绕对称零通胀稳态的对数线性偏离。
- **通胀**：\(\Delta p_t\) 是通胀率，不是价格水平。
- **实际工资**：论文用 \(\omega_t\) 表示实际工资；MMB 实现映射为 `w`。
- **资本时序**：\(k_{t-1}\) 是生产中使用的期初既定资本；\(k_t\) 是投资后的期末资本存量。
- **资本利用率**：\(u_t\) 在当期选择，并影响当期资本服务。
- **利率**：\(r_t\) 是线性化规则中的名义政策利率偏离，并通过预期通胀项进入实际利率。
- **实现交叉检查**：`.agents/skills/dynare-copilot/references/examples/US_RA07_rep.mod` 确认存在一个含 15 个变量、冲击为 `epsp`、`epsz`、`epsa` 和 `epsg` 的 `model(linear)` 实现。该 `.mod` 没有作为纸面数学来源使用，且未运行 Dynare。

## 8. Variable & Parameter Reference Table

| 类别 | 符号 / ASCII | 含义 | 方程引用 |
|---|---|---|---|
| 内生变量 | `pi`, \(\Delta p_t\) | 通胀 | (F1), (F11) |
| 内生变量 | `mc`, \(mc_t\) | 实际边际成本 | (F1), (F2) |
| 内生变量 | `rk`, \(r^k_t\) | 资本租赁率 | (F2), (F3), (F5), (F7) |
| 内生变量 | `w`, \(\omega_t\) | 实际工资 | (F2), (F4), (F5) |
| 内生变量 | `r`, \(r_t\) | 名义政策利率偏离 | (F2), (F6), (F7), (F11) |
| 内生变量 | `a`, \(a_t\) | 技术状态 | (F2), (F10), (F13) |
| 内生变量 | `u`, \(u_t\) | 资本利用率 | (F3), (F5), (F10), (F12) |
| 内生变量 | `n`, \(n_t\) | 劳动投入 | (F4), (F10), 实现恒等式 |
| 内生变量 | `c`, \(c_t\) | 消费 | (F4), (F6), (F12) |
| 内生变量 | `l`, \(l_t\) | 资本-劳动比条件中的劳动符号 | (F5), 实现恒等式 |
| 内生变量 | `q`, \(q_t\) | Tobin's Q | (F7), (F9) |
| 内生变量 | `i`, \(i_t\) | 投资 | (F8), (F9), (F12) |
| 内生变量 | `k`, \(k_t\) | 资本存量 | (F5), (F8), (F10) |
| 内生变量 | `y`, \(y_t\) | 产出 | (F10), (F11), (F12) |
| 内生变量 | `g`, \(g_t\) | 政府支出 | (F12), (F14) |
| 外生变量 | `epsp`, \(\varepsilon^p_t\) | 价格加成创新 | (F1), (F15) |
| 外生变量 | `epsz`, \(\varepsilon^z_t\) | 货币政策创新 | (F11) |
| 外生变量 | `epsa`, \(\varepsilon^a_t\) | 技术创新 | (F13) |
| 外生变量 | `epsg`, \(\varepsilon^g_t\) | 财政创新 | (F14) |
| 参数 | \(\beta\) / `beta` | 贴现因子 | (F1), (F4), (F6), (F7), (F9) |
| 参数 | \(\omega_p\) / `omegap` | 价格指数化 | (F1) |
| 参数 | \(\theta_p\) / `thetap` | Calvo 价格不可重设概率 | (F1) |
| 参数 | \(\bar\lambda\) / `lambdaSS` | 稳态替代弹性 | (F12) |
| 参数 | \(\alpha\) / `alpha` | 资本份额 | (F2), (F10), (F12) |
| 参数 | \(\gamma\) / `gamma` | 成本渠道份额/弹性 | (F2), (F5) |
| 参数 | \(\psi\) / `psi` | 资本利用率弹性参数 | (F3) |
| 参数 | \(\omega_w\) / `omegaw` | 工资指数化 | (F4) |
| 参数 | \(\theta_w\) / `thetaw` | Calvo 工资不可重设概率 | (F4) |
| 参数 | \(\sigma\) / `sigma` | 跨期替代/效用曲率 | (F4), (F6) |
| 参数 | \(b\) / `b` | 外部习惯参数 | (F4), (F6) |
| 参数 | \(\eta\) / `eta` | 劳动供给弹性倒数 | (F4) |
| 参数 | \(\phi\) / `phi` | 劳动替代弹性 | (F4) |
| 参数 | \(\delta\) / `delta` | 折旧率 | (F7), (F8), (F12) |
| 参数 | \(\varphi\) / `vaphi` | 投资对 Tobin's Q 的反应 | (F9) |
| 参数 | \(\rho_r\) / `rhor` | 利率平滑 | (F11) |
| 参数 | \(\gamma_p\) / `gammap` | Taylor 规则通胀反应 | (F11) |
| 参数 | \(\gamma_y\) / `gammay` | Taylor 规则产出反应 | (F11) |
| 参数 | \(\bar I\) / `ISS` | 稳态投资-产出比 | (F12) |
| 参数 | \(\bar G\) / `GSS` | 稳态政府-产出比 | (F12) |
| 参数 | \(\rho_a\) / `rhoa` | 技术持续性 | (F13) |
| 参数 | \(\rho_g\) / `rhog` | 财政支出持续性 | (F14) |
