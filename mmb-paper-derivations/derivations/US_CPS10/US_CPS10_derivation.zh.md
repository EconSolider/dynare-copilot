# US_CPS10 - 推导（最优化问题与线性均衡系统）

> 档案状态：needs_review。未进行运行时验证。论文侧来源给出了结构性原始问题和估计目标；完整 Rep-MMB `model(linear)` 方程只用 `.agents/skills/dynare-copilot/references/examples/US_CPS10_rep.mod` 作为 implementation_cross_check 证据。

## 1. Model Overview

- **模型**：Cogley, Primiceri, and Sargent (2010), "Inflation-gap persistence in the US," AEJ: Macroeconomics, DOI `10.1257/mac.2.1.43`。
- **MMB ID**：`US_CPS10`。
- **用途**：一个简单的估计型新凯恩斯模型，用于解释 1960:Q1-1979:Q3 与 1982:Q4-2006:Q4 两个子样本中美国通胀缺口波动率和可预测性的变化。
- **主体**：代表性家庭、连续统垄断竞争企业、货币/财政当局。
- **关键机制**：内部习惯形成、Calvo 价格黏性、未重新定价企业对稳态通胀的指数化、随机技术增长、偏好冲击、目标加成冲击、货币政策冲击和通胀目标冲击。
- **形式**：在用单位根技术过程缩放消费、产出和实际工资后，围绕非随机稳态作对数线性化，形式为 `model(linear)`。论文说明了这一求解方法，但没有列出全部约化对数线性方程；MMB 实现提供交叉检查系统。

## 2. Optimization Problems

### 2.1 代表性家庭

家庭选择差异化消费、劳动供给和债券持有，以最大化带内部习惯的预期贴现效用：

$$
E_t \sum_{s=0}^{\infty}\delta^s b_{t+s}
\left[
\log(C_{t+s}-h C_{t+s-1})
-\varphi\int_0^1 \frac{L_{t+s}(i)^{1+\nu}}{1+\nu}\,di
\right].
$$

名义预算约束为：

$$
\int_0^1 P_t(i) C_t(i)\,di + B_t + T_t
\le R_{t-1} B_{t-1} + \Pi_t + \int_0^1 W_t(i)L_t(i)\,di.
$$

差异化消费的聚合器为：

$$
C_t =
\left[\int_0^1 C_t(i)^{1/(1+\theta_t)}\,di\right]^{1+\theta_t}.
$$

这里标记 `needs_review`：论文用 $\delta$ 表示贴现因子，而 Rep-MMB 文件用 `betta = 100/(Fbeta+100)`，其中 `Fbeta` 是估计的年化百分比贴现率参数。

### 2.2 企业

每个垄断竞争企业用线性劳动技术生产一种差异化产品：

$$
Y_t(i)=A_t L_t(i).
$$

在 Calvo 概率 $\xi$ 下，企业不能重新优化价格，并把价格指数化到稳态总通胀率 $\pi$。重新优化的企业选择 $\tilde P_t(i)$ 以最大化：

$$
E_t \sum_{s=0}^{\infty}\xi^s\delta^s\lambda_{t+s}
\left\{
\tilde P_t(i)\pi^s Y_{t+s}(i)-W_{t+s}(i)L_{t+s}(i)
\right\}.
$$

目标加成冲击 $\theta_t$ 进入 Dixit-Stiglitz 聚合器中的弹性，因此影响新凯恩斯 Phillips 曲线斜率和成本推动项。

### 2.3 政府与货币当局

财政政策通过一次总付税/转移和债券供给闭合。货币当局按照带平滑的 Taylor 规则设定短期名义总利率：

$$
\frac{R_t}{R} =
\left(\frac{R_{t-1}}{R}\right)^{\rho_R}
\left[
\left(\frac{\bar\pi_{4,t}}{(\pi_t^{\ast})^4}\right)^{\varphi_\pi/4}
\left(\frac{Y_t}{Y_t^{\ast}}\right)^{\varphi_Y}
\right]^{1-\rho_R}
e^{\varepsilon_{R,t}}.
$$

该规则响应相对于时变通胀目标的年度通胀，以及相对于灵活价格产出的产出缺口。

## 3. First-Order Conditions

论文的原始问题推出通常的消费 Euler 方程、劳动供给条件、灵活价格基准和 Calvo 定价条件。以下对数线性均衡系统是 Rep-MMB 实现交叉检查。变量是 `.mod` 文件中的偏离量或变换量；本小节所有方程都标为 `needs_review` 的 paper-to-implementation transformation，因为论文没有把它们作为完整方程块打印出来。

- **(F1) 通胀缺口通胀 `p` 的新凯恩斯 Phillips 曲线**：

$$
p_t-\frac{\beta}{1+\iota_p\beta}p_{t+1}-\lambda^p_t
-\frac{(1-\beta\xi_p)(1-\xi_p)}
{(1+\iota_p\beta)\xi_p\left[1+\nu(1+1/\bar\lambda^p)\right]}w_t
=\frac{\iota_p}{1+\iota_p\beta}p_{t-1}.
$$

- **(F2) 灵活价格实际工资缺口归一化**：

$$
w^{\ast}_t=0.
$$

- **(F3) 带习惯的边际效用和产出关系**：

$$
(g-h\beta)(g-h)\lambda_t
-(g-h\beta\rho_b)(g-h)b_t
-(\beta h g\rho_z-hg)z_t
(g^2+\beta h^2)y_t
-\beta hg\,y_{t+1}
=gh\,y_{t-1}.
$$

- **(F4) 边际效用和产出的灵活价格对应式**：

$$
(g-h\beta)(g-h)\lambda^{\ast}_t
-(g-h\beta\rho_b)(g-h)b_t
-(\beta h g\rho_z-hg)z_t
(g^2+\beta h^2)y^{\ast}_t
-\beta hg\,y^{\ast}_{t+1}
=gh\,y^{\ast}_{t-1}.
$$

- **(F5) Euler 方程**：

$$
\lambda_t-R_t-\lambda_{t+1}+p_{t+1}+\rho_z z_t=0.
$$

- **(F6) 灵活价格 Euler 方程**：

$$
\lambda^{\ast}_t-R^{\ast}_t-\lambda^{\ast}_{t+1}+\rho_z z_t=0.
$$

- **(F7) 劳动供给/实际工资关系**：

$$
w_t-b_t-\nu y_t+\lambda_t=0.
$$

- **(F8) 灵活价格劳动供给/实际工资关系**：

$$
w^{\ast}_t-b_t-\nu y^{\ast}_t+\lambda^{\ast}_t=0.
$$

## 4. Market Clearing & Identities

- **(F9) 货币政策规则**：

$$
R_t-(1-\rho_R)\frac{\varphi_\pi}{4}p_t
+(1-\rho_R)\varphi_\pi\pi^{\ast}_t
-(1-\rho_R)\varphi_y y_t
+(1-\rho_R)\varphi_y y^{\ast}_t
=\rho_R R_{t-1}
+(1-\rho_R)\frac{\varphi_\pi}{4}(p_{t-1}+p_{t-2}+p_{t-3})
+\varepsilon_{R,t}.
$$

- **(F10) 通胀缺口定义**：

$$
\text{inflgap}_t=p_t-\pi^{\ast}_t.
$$

- **(F11) 事后实际利率定义**：

$$
\text{realR}_t=R_t-p_t.
$$

- **(F12) 产出缺口定义**：

$$
\text{outpgap}_t=y_t-y^{\ast}_t.
$$

## 5. Exogenous Processes

- **(F13) 技术增长冲击**：

$$
z_t=\rho_z z_{t-1}+\varepsilon_{z,t}.
$$

- **(F14) 目标加成冲击**：

$$
\lambda^p_t=\rho_{\lambda^p}\lambda^p_{t-1}+\varepsilon_{\lambda^p,t}.
$$

- **(F15) 通胀目标过程**：

$$
\pi^{\ast}_t=\rho_{\pi^{\ast}}\pi^{\ast}_{t-1}+\varepsilon_{\pi^{\ast},t}.
$$

论文 OCR 注记：MinerU Markdown 中方程 (21) 在等式两边重复 $\log\pi_t^{\ast}$；预期的持久性目标过程应使用滞后目标，这与 Rep-MMB 实现和论文上下文一致。此归一化标为 `needs_review`。

- **(F16) 偏好冲击**：

$$
b_t=\rho_b b_{t-1}+\varepsilon_{b,t}.
$$

## 6. Steady-State Solution

因为档案目标是 Rep-MMB 线性实现，`model(linear)` 块中所有模型变量的稳态均为零：

$$
\bar p=\bar y=\bar\lambda=\bar w=\bar R=\bar z=\bar\lambda^p=\bar\pi^{\ast}
=\bar b=\bar y^{\ast}=\bar\lambda^{\ast}=\bar w^{\ast}=\bar R^{\ast}
=\overline{\text{inflgap}}=\overline{\text{realR}}=\overline{\text{outpgap}}=0.
$$

对数线性化背后的非随机水平由以下关系给出：

$$
g=e^\gamma,\qquad
\beta=\frac{100}{100+F_\beta},\qquad
r^{ss}=e^\gamma/\beta-1,\qquad
100r^{ss}=100\,r^{ss}.
$$

MMB 校准用 `gamma100/100` 表示 $\gamma$，并用 `pss100/100` 表示季度稳态总通胀偏离度量。论文分别估计两个子样本；Rep-MMB 文件默认启用 1960-1979 后验中位数，并把 1982-2006 和反事实数值留在注释中。

## 7. Timing & Form Conventions

- **时序**：前瞻变量包括 $p_{t+1}$、$y_{t+1}$、$\lambda_{t+1}$ 和灵活价格对应项。政策规则包含 $R_{t-1}$ 和四个季度通胀项 $p_t,p_{t-1},p_{t-2},p_{t-3}$。
- **存量变量**：论文 DSGE 小节没有资本存量。债券进入家庭预算，但对数线性 MMB 实现没有显式债券状态方程。
- **趋势缩放**：由于技术具有单位根，消费、产出和实际工资在对数线性化前由技术缩放。
- **通胀目标**：目标高度持久，基准中 $\rho_{\pi^{\ast}}=0.995$。
- **运行时验证**：未执行；没有运行 Dynare。

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII name | Meaning | Equation |
|---|---|---|---|
| Endogenous | `p` | Phillips 曲线中的通胀缺口通胀项 | (F1), (F9) |
| Endogenous | `y` | 经技术缩放/对数线性化的产出 | (F3), (F7), (F9) |
| Endogenous | `lambdda` | 消费边际效用 | (F3), (F5), (F7) |
| Endogenous | `w` | 实际工资 | (F1), (F7) |
| Endogenous | `R` | 名义政策利率偏离 | (F5), (F9) |
| Endogenous | `z` | 技术增长状态 | (F13) |
| Endogenous | `lambddap` | 目标加成/成本推动冲击 | (F1), (F14) |
| Endogenous | `pit` | 通胀目标 | (F9), (F10), (F15) |
| Endogenous | `b` | 偏好冲击 | (F3), (F4), (F7), (F8), (F16) |
| Endogenous | `ystar` | 灵活价格产出 | (F4), (F8), (F9), (F12) |
| Endogenous | `lambddastar` | 灵活价格边际效用 | (F4), (F6), (F8) |
| Endogenous | `wstar` | 灵活价格实际工资 | (F2), (F8) |
| Endogenous | `Rstar` | 灵活价格名义/实际利率对应项 | (F6) |
| Endogenous | `inflgap` | 通胀缺口 | (F10) |
| Endogenous | `realR` | 事后实际利率 | (F11) |
| Endogenous | `outpgap` | 产出缺口 | (F12) |
| Exogenous shock | `Rs` | 货币政策创新 $\varepsilon_{R,t}$ | (F9) |
| Exogenous shock | `zs` | 技术增长创新 $\varepsilon_{z,t}$ | (F13) |
| Exogenous shock | `lambddaps` | 目标加成创新 $\varepsilon_{\lambda^p,t}$ | (F14) |
| Exogenous shock | `pits` | 通胀目标创新 $\varepsilon_{\pi^{\ast},t}$ | (F15) |
| Exogenous shock | `bs` | 偏好创新 $\varepsilon_{b,t}$ | (F16) |
| Parameter | `niu` / $\nu$ | Frisch 弹性倒数；校准为 2 | - |
| Parameter | `lambddapss` / $\bar\lambda^p$ | 稳态加成参数；校准为 0.1 | - |
| Parameter | `iotap` / $\iota_p$ | 实现中 Phillips 曲线的价格指数化系数；默认 0 | - |
| Parameter | `rhopit` / $\rho_{\pi^{\ast}}$ | 通胀目标持久性；基准 0.995 | (F15) |
| Parameter | `gamma100`, `gamma` | 技术增长估计值及季度值 | - |
| Parameter | `pss100` | 稳态通胀估计值 | - |
| Parameter | `Fbeta`, `betta` | 贴现率估计值和贴现因子 | (F1), (F3)-(F6) |
| Parameter | `hparam` | 内部习惯参数 $h$ | (F3), (F4) |
| Parameter | `xip` / $\xi_p$ | Calvo 价格黏性 | (F1) |
| Parameter | `fp`, `fy`, `rhoR` | Taylor 规则系数 $\varphi_\pi,\varphi_y,\rho_R$ | (F9) |
| Parameter | `rhoz`, `rholambddap`, `rhob` | 冲击持久性参数 | (F13), (F14), (F16) |
| Parameter | `sdr`, `sdz`, `sdlambddap`, `sdpit`, `sdb` | 冲击标准差 | shocks block |
| Parameter | `rss`, `rss100`, `expg` | 稳态利率和增长变换 | steady state |
