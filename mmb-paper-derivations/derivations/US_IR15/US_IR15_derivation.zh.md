# US_IR15 - 推导（仿射宏观金融状态空间模型）

> `US_IR15` 的模型档案条目。状态：`needs_review`。未执行运行时验证；未运行 Dynare。

## 1. Model Overview

- **模型**：Ireland (2015), "Monetary policy, bond risk premia, and the economy."
- **模型 ID**：`US_IR15`。
- **来源**：`raw/mmb_mineru/runs/us_ir15__monetary_policy_bond_risk_premia_and_the_economy__eb56aade/full.md`；DOI `10.1016/j.jmoneco.2015.09.003`。
- **用途**：估计带宏观因子的仿射期限结构模型，用于研究货币政策、债券风险溢价、产出和通胀之间的双向联系。
- **主体/模块**：简约式央行规则、宏观 VAR 式状态转移、仿射名义定价核、无套利债券定价递归，以及宏观变量和债券收益率观测方程。
- **状态向量**：\(X_t=[g^r_t,\ g^\pi_t,\ g^y_t,\ \tau_t,\ \nu_t]'\)，其中 \(g^r_t\) 为利率缺口，\(g^\pi_t\) 为通胀缺口，\(g^y_t\) 为产出缺口，\(\tau_t\) 为通胀目标，\(\nu_t\) 为不可观测风险溢价因子。
- **形式**：线性状态空间 / 仿射期限结构模型。MMB 实现为 `model(linear)`。

## 2. Optimization Problems

论文没有给出家庭、企业或金融中介的最优化问题。其结构限制来自仿射期限结构模型中的无套利条件，以及宏观状态方程中的时序识别限制。

最接近最优化基础的对象是用于无套利定价的随机贴现因子：

\[
m_{t+1}=-r_t-\frac{1}{2}\lambda_t'\lambda_t-\lambda_t'\varepsilon_{t+1}.
\]

风险价格是状态向量的仿射函数，且时间变动只通过风险因子所在列进入：

\[
\lambda_t=\lambda+\Lambda X_t,\qquad
\Lambda=
\begin{bmatrix}
0&0&0&0&\Lambda^r\\
0&0&0&0&\Lambda^\pi\\
0&0&0&0&\Lambda^y\\
0&0&0&0&\Lambda^\tau\\
0&0&0&0&\Lambda^\nu
\end{bmatrix}.
\]

估计中施加 \(\sigma_\nu=0.01\)、\(\Lambda^\pi<0\)、\(\Lambda^\nu=0\)、\(\rho_\tau=0.999\)，并要求 \(P\) 与 \(P-\Sigma\Lambda\) 稳定。

## 3. First-Order Conditions

来源没有给出主体层面的一阶条件。以下编号条件是定义该线性实现的均衡/状态空间限制。

- **(F1) 通胀目标过程**：

\[
\tau_t=(1-\rho_\tau)\tau+\rho_\tau\tau_{t-1}+\sigma_\tau\varepsilon_{\tau t}.
\]

- **(F2) 利率缺口与通胀缺口定义**：

\[
g^r_t=r_t-\tau_t,\qquad g^\pi_t=\pi_t-\tau_t.
\]

- **(F3) 利率缺口的货币政策规则**：

\[
g^r_t-g^r=\rho_r(g^r_{t-1}-g^r)
+(1-\rho_r)\left[\rho_\pi g^\pi_t+\rho_y(g^y_t-g^y)+\rho_\nu\nu_t\right]
+\sigma_r\varepsilon_{rt}.
\]

- **(F4) 通胀缺口运动方程**：

\[
g^\pi_t=\rho_{\pi r}(g^r_{t-1}-g^r)+\rho_{\pi\pi}g^\pi_{t-1}
+\rho_{\pi y}(g^y_{t-1}-g^y)+\rho_{\pi\nu}\nu_{t-1}
+\sigma_{\pi\tau}\sigma_\tau\varepsilon_{\tau t}
+\sigma_\pi\varepsilon_{\pi t}.
\]

- **(F5) 产出缺口运动方程**：

\[
g^y_t-g^y=\rho_{yr}(g^r_{t-1}-g^r)+\rho_{y\pi}g^\pi_{t-1}
+\rho_{yy}(g^y_{t-1}-g^y)+\rho_{y\nu}\nu_{t-1}
+\sigma_{y\pi}\sigma_\pi\varepsilon_{\pi t}
+\sigma_{y\tau}\sigma_\tau\varepsilon_{\tau t}
+\sigma_y\varepsilon_{yt}.
\]

- **(F6) 风险因子运动方程**：

\[
\nu_t=\rho_{\nu\nu}\nu_{t-1}
+\sigma_{\nu r}\sigma_r\varepsilon_{rt}
+\sigma_{\nu\pi}\sigma_\pi\varepsilon_{\pi t}
+\sigma_{\nu y}\sigma_y\varepsilon_{yt}
+\sigma_{\nu\tau}\sigma_\tau\varepsilon_{\tau t}
+\sigma_\nu\varepsilon_{\nu t}.
\]

- **(F7) 紧凑状态转移式**：

\[
X_t=\mu+P X_{t-1}+\Sigma\varepsilon_t,\qquad
\varepsilon_t=[\varepsilon_{rt},\varepsilon_{\pi t},\varepsilon_{yt},\varepsilon_{\tau t},\varepsilon_{\nu t}]'.
\]

- **(F8) 短期利率对状态向量的载荷**：

\[
r_t=\delta'X_t,\qquad \delta=[1,\ 0,\ 0,\ 1,\ 0]'.
\]

- **(F9) 对数名义定价核**：

\[
m_{t+1}=-r_t-\frac{1}{2}\lambda_t'\lambda_t-\lambda_t'\varepsilon_{t+1}.
\]

- **(F10) 风险价格**：

\[
\lambda_t=\lambda+\Lambda X_t.
\]

- **(F11) 贴现债券对数价格**：

\[
p^n_t=\overline{A}_n+\overline{B}'_nX_t.
\]

- **(F12) 无套利债券定价条件**：

\[
\exp(p^{n+1}_t)=E_t\left[\exp(m_{t+1})\exp(p^n_{t+1})\right].
\]

- **(F13) 债券价格常数项递归**：

\[
\overline{A}_{n+1}=\overline{A}_n+\overline{B}'_n(\mu-\Sigma\lambda)
+\frac{1}{2}\overline{B}'_n\Sigma\Sigma'\overline{B}_n.
\]

- **(F14) 债券价格载荷递归**：

\[
\overline{B}'_{n+1}=\overline{B}'_n(P-\Sigma\Lambda)-\delta'.
\]

- **(F15) \(n\) 期贴现债券收益率**：

\[
y^n_t=-\frac{p^n_t}{n}=A_n+B'_nX_t,\qquad
A_n=-\frac{\overline{A}_n}{n},\quad B_n=-\frac{\overline{B}_n}{n}.
\]

- **(F16) 债券风险溢价**：

\[
q^n_t=y^n_t-\frac{1}{n}E_t(r_t+r_{t+1}+\cdots+r_{t+n-1}).
\]

- **(F17) 预期未来短期利率**：

\[
E_t r_{t+j}=\delta'\overline{\mu}+\delta'P^j(X_t-\overline{\mu}),\qquad
\overline{\mu}=(I-P)^{-1}\mu.
\]

- **(F18) 风险溢价闭式分解**：

\[
q^n_t=A_n-\delta'\left(I-\frac{1}{n}\sum_{j=0}^{n-1}P^j\right)\overline{\mu}
+\left(B'_n-\delta'\frac{1}{n}\sum_{j=0}^{n-1}P^j\right)X_t.
\]

- **(F19) 去均值观测变量的测量方程**：

\[
d_t=UX_t+V\eta_t.
\]

- **(F20) 观测向量和测量误差向量**：

\[
d_t=[r_t,\ \pi_t,\ g^y_t,\ y^4_t,\ y^8_t,\ y^{12}_t,\ y^{16}_t,\ y^{20}_t]',
\qquad
\eta_t=[\eta^4_t,\ \eta^8_t,\ \eta^{16}_t]'.
\]

## 4. Market Clearing & Identities

这个经验宏观金融模型不含商品、劳动、资产供给或政府预算出清条件。实际使用的恒等式是变量变换和观测量定义：

- **(F21) 由缺口恢复利率和通胀水平**：

\[
r_t=g^r_t+\tau_t,\qquad \pi_t=g^\pi_t+\tau_t.
\]

- **(F22) 年化实现观测量**：

\[
\text{inflation}_t=4\pi_t,\qquad \text{output}_t=g^y_t.
\]

- **(F23) MMB 实现中的收益率和溢价观测量**：

\[
P^y_{n,t}=4y^n_t-r_t,\qquad y^a_{n,t}=4y^n_t,\qquad n\in\{4,8,12,16,20\}.
\]

`.mod` 文件通过预先计算的载荷矩阵实现 \(P^y_{n,t}\) 和年化收益率，而不是在 Dynare 内部由递归式 (F13)-(F15) 内生推导。这一说明属于 `implementation_cross_check`，不是论文侧来源。

## 5. Exogenous Processes

基本冲击是相互独立且序列不相关的标准正态创新：

\[
\varepsilon_t=[\varepsilon_{rt},\varepsilon_{\pi t},\varepsilon_{yt},\varepsilon_{\tau t},\varepsilon_{\nu t}]'.
\]

它们通过 (F1)、(F3)、(F4)、(F5) 和 (F6) 进入系统。测量误差进入观测方程：

\[
\eta_t=[\eta^4_t,\eta^8_t,\eta^{16}_t]'.
\]

MMB 实现交叉检查：

\[
\{\epsilon_r,\epsilon_\pi,\epsilon_y,\epsilon_\tau,\epsilon_\nu,\eta_4,\eta_8,\eta_{16}\}.
\]

MMB `.mod` 将风险因子创新标为 `epsilon_v`，使用 `eta_4`、`eta_8` 和 `eta_16` 作为测量误差，并为了 Rep-MMB 模拟缩放设置较大的数值冲击方差。这些数值冲击方差属于实现约定，不是论文侧公式证据。

## 6. Steady-State Solution

论文使用去均值数据估计系统，并在经验状态方程中设 \(\mu=0\)。因此去均值形式下的线性状态向量稳态为零：

\[
\bar{X}=0.
\]

用于去均值的数据水平稳态为：

\[
\tau=\bar{\pi},\qquad
g^r=\bar{r}-\tau,\qquad
g^y=\overline{g^y}.
\]

长期债券收益率的稳态通过选择常数风险价格向量 \(\lambda\) 来匹配：

\[
\bar{y}^n=A_n+B'_n\bar{X}=A_n,\qquad n\in\{4,8,12,16,20\}.
\]

在 MMB 线性实现中，稳态作为校准常数保存：

\[
\pi^{SS}=0.89,\quad r^{SS}=5.47,\quad \tau^{SS}=\pi^{SS},\quad
g_r^{SS}=r^{SS}-\pi^{SS},\quad g_y^{SS}=-0.526,
\]

\[
y_4^{SS}=5.96,\quad y_8^{SS}=6.166,\quad y_{12}^{SS}=6.337,\quad
y_{16}^{SS}=6.4683,\quad y_{20}^{SS}=6.5447.
\]

`needs_review`：来源文本说明补充附录第 3 和第 4 部分描述 \(U\)、\(V\) 的构造以及稳态收益率匹配。本地没有相应附录规范化文件，因此档案将这些公式记录为第一遍提取结果。

## 7. Timing & Form Conventions

- 周期长度为季度。
- 模型是线性/仿射模型，实现为 `model(linear)`。
- 状态向量 \(X_t\) 由一期滞后和当期冲击决定，但政策规则使用当期 \(g^\pi_t\)、\(g^y_t\) 和 \(\nu_t\)。
- 时序限制用于识别冲击：货币政策冲击和风险溢价冲击对通胀缺口、产出缺口没有当期影响；产出缺口创新对通胀缺口没有当期影响。
- 估计中的债券期限为 \(n=4,8,12,16,20\) 个季度。
- 一年、两年和四年收益率含测量误差；短期利率、通胀、产出缺口、三年收益率和五年收益率被视为精确观测。
- 模型没有实物资本积累模块，因此不存在资本存量时序约定。

## 8. Variable & Parameter Reference Table

| 类别 | 符号 / ASCII | 含义 | 由哪条方程决定 |
|---|---|---|---|
| 内生状态 | `g_r`, \(g^r_t\) | 利率缺口 | (F3), (F7) |
| 内生状态 | `g_pi`, \(g^\pi_t\) | 通胀缺口 | (F4), (F7) |
| 内生状态 | `g_y`, \(g^y_t\) | 产出缺口 | (F5), (F7) |
| 内生状态 | `tau`, \(\tau_t\) | 通胀目标 | (F1), (F7) |
| 内生状态 | `v`, \(\nu_t\) | 风险溢价因子 | (F6), (F7) |
| 观测量 | `r`, \(r_t\) | 短期名义利率 | (F8), (F21) |
| 观测量 | `pi`, \(\pi_t\) | 通胀 | (F21) |
| 观测量 | `g_y_obs` | 产出缺口观测量 | (F19), (F20) |
| 观测量 | `y_4`, \(y^4_t\) | 一年期贴现债券收益率 | (F15), (F19) |
| 观测量 | `y_8`, \(y^8_t\) | 两年期贴现债券收益率 | (F15), (F19) |
| 观测量 | `y_12`, \(y^{12}_t\) | 三年期贴现债券收益率 | (F15), (F19) |
| 观测量 | `y_16`, \(y^{16}_t\) | 四年期贴现债券收益率 | (F15), (F19) |
| 观测量 | `y_20`, \(y^{20}_t\) | 五年期贴现债券收益率 | (F15), (F19) |
| 派生观测量 | `P_y_4`, `P_y_8`, `P_y_12`, `P_y_16`, `P_y_20` | 年化收益率减短期利率 | (F23) |
| 派生观测量 | `y_4_a`, `y_8_a`, `y_12_a`, `y_16_a`, `y_20_a` | 年化收益率 | (F23) |
| 派生观测量 | `output` | 产出缺口报告变量 | (F22) |
| 派生观测量 | `inflation` | 年化通胀报告变量 | (F22) |
| 外生冲击 | `epsilon_r` | 货币政策冲击 | (F3) |
| 外生冲击 | `epsilon_pi` | 通胀冲击 | (F4) |
| 外生冲击 | `epsilon_y` | 产出冲击 | (F5) |
| 外生冲击 | `epsilon_tau` | 通胀目标冲击 | (F1), (F4), (F5), (F6) |
| 外生冲击 | `epsilon_v` | 风险溢价因子冲击 | (F6) |
| 测量误差 | `eta_4`, `eta_8`, `eta_16` | 收益率测量误差 | (F19), (F20) |
| 参数组 | \(\rho\) coefficients | (F1)、(F3)-(F6) 中的持久性和动态传导系数 | - |
| 参数组 | \(\sigma\) coefficients | 冲击波动、当期影响载荷、测量误差波动 | - |
| 参数组 | \(\lambda,\Lambda\) | 常数风险价格和随状态变化的风险价格 | (F10), (F13), (F14) |
| 参数组 | `Uij`, `Pij`, `Qij`, `Sij` | 观测、状态转移、收益率载荷和冲击载荷的实现矩阵 | `implementation_cross_check` |

状态：`needs_review`，因为本推导是基于 MinerU Markdown 的第一遍提取，且补充附录中的矩阵构造公式没有本地规范化版本。
