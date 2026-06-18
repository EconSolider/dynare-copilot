# US_IR11 -- 关于大衰退的新凯恩斯主义视角

> 归档状态：`needs_review`。未执行运行时验证。MMB `.mod` 文件仅用作 `implementation_cross_check`，不作为论文侧数学来源。

来源出处：Peter N. Ireland (2011), "A New Keynesian Perspective on the Great Recession," Journal of Money, Credit and Banking 43(1), 31-54, DOI `10.1111/j.1538-4616.2010.00364.x`。主要 MinerU Markdown：`raw/mmb_mineru/runs/us_ir11__a_new_keynesian_perspective_on_the_great_recession__fee43648/full.md`。原始 PDF：`raw/mmb_papers/A New Keynesian perspective on the Great Recession.pdf`。

## 1. Model Overview

US_IR11 是一个估计的小型美国新凯恩斯主义模型，用于比较 2007-09 年大衰退与 1990-91 年、2001 年两次衰退。模型包含代表性家庭、代表性最终品厂商、由具有 Rotemberg 调价成本的垄断竞争中间品厂商构成的连续统、采用一阶差分 Taylor 规则的中央银行，以及一个用于定义有效产出和产出缺口的社会计划者模块。

经验模型是论文中的对数线性平稳系统。模型含消费习惯形成、价格调整中的部分指数化、偏好冲击、重新规范化的成本推动冲击、技术增长冲击和货币政策冲击。论文先推导非线性的家庭、厂商、政策和计划者方程，再用非平稳技术水平转换实际变量，并围绕平稳系统做对数线性化。

模型形式：`model(linear)` / 对数线性百分比偏离系统。MMB 实现中的稳态偏离全为零。论文包含来源层面的非线性模型，但本归档条目跟随对数线性系统（论文方程 21-30），因为这是论文实际求解和估计的模型。

## 2. Optimization Problems

### 代表性家庭

家庭在名义预算约束下选择消费、劳动、名义债券和货币余额。偏好包含消费的外部习惯形成，并且实际货币余额和劳动以可加方式进入效用：

\[
E_0 \sum_{t=0}^{\infty} \beta^t a_t
\left[\ln(C_t-\gamma C_{t-1})+\ln(M_t/P_t)-h_t\right].
\]

预算约束为：

\[
\frac{M_{t-1}+T_t+B_{t-1}+W_t h_t+D_t}{P_t}
\ge C_t+\frac{M_t+B_t/r_t}{P_t}.
\]

### 最终品厂商

最终品厂商在 CES 加总器下选择差异化中间品投入 \(Y_t(i)\)，以最大化静态利润：

\[
\left[\int_0^1 Y_t(i)^{(\theta_t-1)/\theta_t}\,di\right]^{\theta_t/(\theta_t-1)}
\ge Y_t.
\]

加成参数 \(\theta_t\) 是随机的，并在后续被重新规范化为线性系统中的成本推动冲击。

### 中间品厂商

每个中间品厂商雇佣劳动，并使用线性技术生产：

\[
Z_t h_t(i) \ge Y_t(i).
\]

厂商在最终品厂商需求约束下设定名义价格，并面临 Rotemberg 价格调整成本：

\[
\frac{\phi}{2}
\left[
\frac{P_t(i)}{\pi_{t-1}^{\alpha}\pi^{1-\alpha}P_{t-1}(i)}-1
\right]^2Y_t.
\]

厂商的动态目标与预期贴现实际股利成比例：

\[
E_0\sum_{t=0}^{\infty}\beta^t\Lambda_t[D_t(i)/P_t].
\]

### 用于有效产出的社会计划者

社会计划者选择有效产出 \(Q_t\) 和劳动配置 \(n_t(i)\)，使用与代表性家庭相同的消费和劳动偏好排序，并受总生产可行性约束限制。该模块不是竞争均衡配置；它定义 \(Q_t\) 和产出缺口。

## 3. First-Order Conditions

以下均衡条件按归档方程连续编号。它们结合了来源模型的非线性方程和论文的估计对数线性系统。标记为 `needs_review` 的条目应在提升状态前对照 PDF 做来源核查。

### 家庭和静态生产条件

**(F1) 来自消费与习惯的家庭财富边际效用**

\[
\Lambda_t =
\frac{a_t}{C_t-\gamma C_{t-1}}
-\beta\gamma E_t\left[
\frac{a_{t+1}}{C_{t+1}-\gamma C_t}
\right].
\]

**(F2) 劳动供给条件**

\[
a_t=\Lambda_t(W_t/P_t).
\]

**(F3) 名义债券 Euler 方程**

\[
\Lambda_t=\beta r_t E_t\left(\Lambda_{t+1}/\pi_{t+1}\right).
\]

**(F4) 货币需求条件**

\[
M_t/P_t=(a_t/\Lambda_t)\left[r_t/(r_t-1)\right].
\]

**(F5) 最终品厂商对中间品的需求**

\[
Y_t(i)=\left[P_t(i)/P_t\right]^{-\theta_t}Y_t.
\]

**(F6) 总价格指数**

\[
P_t=\left[\int_0^1 P_t(i)^{1-\theta_t}\,di\right]^{1/(1-\theta_t)}.
\]

**(F7) 中间品生产**

\[
Z_t h_t(i)=Y_t(i).
\]

**(F8) Rotemberg 定价 FOC（`needs_review`：OCR 公式较长，应对照 PDF 核查）**

\[
\begin{aligned}
0={}&(1-\theta_t)\left[\frac{P_t(i)}{P_t}\right]^{-\theta_t}
+\theta_t\left[\frac{P_t(i)}{P_t}\right]^{-\theta_t-1}
\left(\frac{W_t}{P_tZ_t}\right)\\
&-\phi
\left[
\frac{P_t(i)}{\pi_{t-1}^{\alpha}\pi^{1-\alpha}P_{t-1}(i)}-1
\right]
\left[
\frac{P_t(i)}{\pi_{t-1}^{\alpha}\pi^{1-\alpha}P_{t-1}(i)}
\right]\\
&+\beta\phi E_t\left\{
\left(\frac{\Lambda_{t+1}}{\Lambda_t}\right)
\left[
\frac{P_{t+1}(i)}{\pi_t^{\alpha}\pi^{1-\alpha}P_t(i)}-1
\right]
\left[
\frac{P_{t+1}(i)}{\pi_t^{\alpha}\pi^{1-\alpha}P_t(i)}
\right]
\left[
\frac{P_tY_{t+1}}{P_t(i)Y_t}
\right]\right\}.
\end{aligned}
\]

### 对数线性估计系统

带帽变量表示在转换 \(y_t=Y_t/Z_t\)、\(c_t=C_t/Z_t\)、\(q_t=Q_t/Z_t\)、\(\lambda_t=Z_t\Lambda_t\) 和 \(z_t=Z_t/Z_{t-1}\) 之后，相对稳态增长路径的对数偏离。

**(F9) 偏好冲击**

\[
\hat a_t=\rho_a\hat a_{t-1}+\varepsilon_{at}.
\]

**(F10) 边际效用 / 习惯关系**

\[
\begin{aligned}
(z-\beta\gamma)(z-\gamma)\hat\lambda_t
={}&\gamma z\hat y_{t-1}
-(z^2+\beta\gamma^2)\hat y_t
+\beta\gamma z E_t\hat y_{t+1}\\
&+(z-\beta\gamma\rho_a)(z-\gamma)\hat a_t
-\gamma z\hat z_t.
\end{aligned}
\]

**(F11) 新凯恩斯主义 IS 曲线**

\[
\hat\lambda_t=\hat r_t+E_t\hat\lambda_{t+1}-E_t\hat\pi_{t+1}.
\]

**(F12) 重新规范化的成本推动冲击（`needs_review`：应对照论文方程文字和实现说明核查重新规范化）**

\[
\hat e_t=\rho_e\hat e_{t-1}+\varepsilon_{et}.
\]

**(F13) 技术增长冲击**

\[
\hat z_t=\varepsilon_{zt}.
\]

**(F14) 新凯恩斯主义 Phillips 曲线**

\[
(1+\beta\alpha)\hat\pi_t
=\alpha\hat\pi_{t-1}
+\beta E_t\hat\pi_{t+1}
-\psi\hat\lambda_t
+\psi\hat a_t
+\hat e_t.
\]

**(F15) 一阶差分 Taylor 规则**

\[
\hat r_t-\hat r_{t-1}
=\rho_{\pi}\hat\pi_t+\rho_g\hat g_t+\varepsilon_{rt}.
\]

**(F16) 产出增长恒等式**

\[
\hat g_t=\hat y_t-\hat y_{t-1}+\hat z_t.
\]

**(F17) 有效产出关系**

\[
0=\gamma z\hat q_{t-1}
-(z^2+\beta\gamma^2)\hat q_t
+\beta\gamma zE_t\hat q_{t+1}
+\beta\gamma(z-\gamma)(1-\rho_a)\hat a_t
-\gamma z\hat z_t.
\]

**(F18) 产出缺口**

\[
\hat x_t=\hat y_t-\hat q_t.
\]

## 4. Market Clearing & Identities

货币市场和债券市场出清为：

\[
M_t=M_{t-1}+T_t,\qquad B_t=B_{t-1}=0.
\]

论文说明，在施加对称性并使用家庭和厂商条件解出工资、货币余额、劳动和股利之后，剩余的均衡系统决定产出、消费、通胀、名义利率、产出增长、有效产出、产出缺口、边际效用以及三个结构冲击。

一阶近似下，价格调整成本是二阶项，因此转换后的资源恒等式意味着：

\[
\hat c_t=\hat y_t.
\]

该条件出现在论文推导中，但在实现交叉检查中被注释掉，因为消费未作为单独的 MMB 内生变量保留。

价格水平加总器和中间品需求作为来源层面的恒等式保留在 (F5)-(F6) 中，而估计的线性系统直接使用总通胀。

## 5. Exogenous Processes

论文侧非线性冲击为：

\[
\ln(a_t)=\rho_a\ln(a_{t-1})+\varepsilon_{at},
\]

\[
\ln(\theta_t)=(1-\rho_{\theta})\ln(\theta)+\rho_{\theta}\ln(\theta_{t-1})+\varepsilon_{\theta t},
\]

\[
\ln(Z_t)=\ln(z)+\ln(Z_{t-1})+\varepsilon_{zt}.
\]

在估计的线性系统中，加成冲击重新规范化为 \(\hat e_t=-(1/\phi)\hat\theta_t\)，且 \(\rho_e=\rho_{\theta}\)、\(\psi=(\theta-1)/\phi\)。模型还在 Taylor 规则 (F15) 中包含货币政策创新 \(\varepsilon_{rt}\)。

实现交叉检查声明了四个创新：`epsa`、`epse`、`epsz` 和 `epsr`，对应偏好、重新规范化成本推动、技术和货币政策冲击。

## 6. Steady-State Solution

由于 US_IR11 以对数线性 `model(linear)` 系统实现和估计，所有带帽变量的确定性稳态均为零：

\[
\hat a=\hat\lambda=\hat y=\hat r=\hat\pi=\hat e=\hat z=\hat g=\hat q=\hat x=0.
\]

论文中的平衡增长稳态水平满足：

\[
g=z,\qquad r=z\pi/\beta,
\]

其中 \(z\) 是季度技术增长毛率，\(\pi\) 是季度趋势通胀毛率。论文在估计其余参数前固定 \(z=1.0046\)、\(\pi=1.0062\)、\(\beta=0.9987\) 和 \(\psi=0.10\)。这些水平关系不是 MMB 线性实现所需的非零 `steady_state_model`。

论文和交叉检查实现中可见的估计与校准参数值：

| Parameter | Meaning | Value / status |
|---|---|---|
| \(\gamma\) | 习惯形成 | 0.3904 |
| \(\alpha\) | 价格指数化 | 0 |
| \(\rho_{\pi}\) | Taylor 规则通胀反应 | 0.4153 |
| \(\rho_g\) | Taylor 规则产出增长反应 | 0.1270 |
| \(\rho_a\) | 偏好冲击持续性 | 0.9797 |
| \(\rho_e\) | 重新规范化成本推动持续性 | 0 |
| \(z\) | 技术漂移 | 1.0046 |
| \(\beta\) | 贴现因子 | 0.9987 |
| \(\psi\) | Phillips 曲线参数 | 0.10 |
| \(\sigma_a,\sigma_e,\sigma_z,\sigma_r\) | 创新标准差 | 0.0868, 0.0017, 0.0095, 0.0014 |

运行时验证：未执行。

## 7. Timing & Form Conventions

估计系统是季度频率，并围绕平衡增长路径对数线性化。带帽变量表示相对稳态转换变量的对数偏离。技术水平 \(Z_t\) 具有带漂移的单位根，因此实际变量先除以 \(Z_t\) 平稳化，再做对数线性化。

该模型没有资本存量。线性系统中的主要预定内生变量为滞后产出、滞后名义利率和滞后有效产出，分别以 \(\hat y_{t-1}\)、\(\hat r_{t-1}\) 和 \(\hat q_{t-1}\) 出现。偏好和成本推动冲击为 AR(1)，而基准设定中的技术增长和货币政策冲击以创新形式进入。

通胀和名义利率是季度模型变量；实现中通过乘以四加入年化报告变量。产出水平报告变量通过累积技术增长并加上平稳产出来重构。

## 8. Variable & Parameter Reference Table

### 内生变量

| Category | Symbol | ASCII name | Meaning | Main equation |
|---|---|---|---|---|
| Endogenous | \(\hat a_t\) | `a` | 偏好冲击状态 | (F9) |
| Endogenous | \(\hat\lambda_t\) | `lambda` | 边际效用 / IS 状态 | (F10), (F11) |
| Endogenous | \(\hat y_t\) | `y` | 平稳产出偏离 | (F10), (F16) |
| Endogenous | \(\hat z_t\) | `z` | 技术增长偏离 | (F13) |
| Endogenous | \(\hat r_t\) | `r` | 名义利率偏离 | (F15) |
| Endogenous | \(\hat\pi_t\) | `pi` | 通胀偏离 | (F14) |
| Endogenous | \(\hat e_t\) | `e` | 重新规范化成本推动冲击 | (F12) |
| Endogenous | \(\hat g_t\) | `g` | 产出增长偏离 | (F16), (F15) |
| Endogenous | \(\hat q_t\) | `q` | 有效产出偏离 | (F17) |
| Endogenous | \(\hat x_t\) | `x` | 产出缺口 | (F18) |
| Endogenous | \(4\hat\pi_t\) | `inflationq` | 年化通胀报告变量 | implementation_cross_check |
| Endogenous | \(4\hat r_t\) | `interest` | 年化利率报告变量 | implementation_cross_check |
| Endogenous | output level | `output` | 产出水平报告变量 | implementation_cross_check |
| Endogenous | technology level accumulator | `Z_au` | 累积技术报告状态 | implementation_cross_check |

### 外生冲击

| Symbol | ASCII name | Meaning |
|---|---|---|
| \(\varepsilon_{at}\) | `epsa` | 偏好创新 |
| \(\varepsilon_{et}\) | `epse` | 重新规范化成本推动创新 |
| \(\varepsilon_{zt}\) | `epsz` | 技术增长创新 |
| \(\varepsilon_{rt}\) | `epsr` | 货币政策创新 |

### 参数

| Symbol | ASCII name | Meaning |
|---|---|---|
| \(\gamma\) | `gamma` | 习惯形成 |
| \(\alpha\) | `alfa` | 价格指数化 |
| \(\rho_{\pi}\) | `rhopi` | Taylor 规则通胀反应 |
| \(\rho_g\) | `rhog` | Taylor 规则产出增长反应 |
| \(\rho_a\) | `rhoa` | 偏好冲击持续性 |
| \(\rho_e\) | `rhoe` | 重新规范化成本推动持续性 |
| \(z\) | `zeta` | 技术漂移 |
| \(\beta\) | `beta` | 贴现因子 |
| \(\psi\) | `psi` | Phillips 曲线斜率 / 名义刚性参数 |
| \(\sigma_a,\sigma_e,\sigma_z,\sigma_r\) | shock variances in `shocks` block | 实现中用于模拟的创新标准差 |
