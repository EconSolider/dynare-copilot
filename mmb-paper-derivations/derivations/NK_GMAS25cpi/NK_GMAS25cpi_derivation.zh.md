# NK_GMAS25cpi -- 推导

> 归档状态：`needs_review`。这份一稿推导以 Gali and Monacelli (2005) 的 MinerU Markdown 为来源。该模型编号没有可用的附录归一化文件，也没有可用的实现 `.mod` 交叉检查文件。

## 1. Model Overview

- **模型**：`NK_GMAS25cpi`，对应 Gali and Monacelli (2005) "Monetary policy and exchange rate volatility in a small open economy" 的 CPI 通胀泰勒规则变体。
- **来源**：`raw/mmb_mineru/runs/nk_gm05_nk_gmas25cpi_nk_gmas25ppi__monetary_policy_and_exchange_rate_volatility_in_a_small_open_economy__6f92413a/full.md`；DOI `10.1111/j.1467-937x.2005.00349.x`。
- **主体与市场**：测度为零的小型开放经济中的代表性家庭；具有 Calvo 定价的垄断竞争国内企业连续统；完全国际证券市场；以及设定短期名义利率的中央银行。
- **模型形式**：对数线性小型开放经济 New Keynesian 模型。非线性的家庭、商品聚合、预算、技术和 Calvo 问题作为原始结构记录，但可操作的均衡条件采用论文的一阶近似系统。
- **变体说明**：`NK_GMAS25cpi` 表示 CPI 通胀泰勒规则。同一篇论文还讨论国内通胀泰勒规则和汇率钉住制度；这些不是本条目的政策闭合。
- **运行验证**：未执行。

## 2. Optimization Problems

### 家庭

代表性家庭选择消费、劳动和完全或有债权组合：

\[
\max_{\{C_t,N_t,D_{t+1}\}} E_0\sum_{t=0}^{\infty}\beta^t
\left(\frac{C_t^{1-\sigma}}{1-\sigma}-\frac{N_t^{1+\varphi}}{1+\varphi}\right)
\]

并满足名义预算约束

\[
P_t C_t + E_t\{Q_{t,t+1}D_{t+1}\}
\le D_t + W_tN_t + T_t.
\]

综合消费由国内品和进口品组成：

\[
C_t =
\left[(1-\alpha)^{1/\eta}C_{H,t}^{(\eta-1)/\eta}
+\alpha^{1/\eta}C_{F,t}^{(\eta-1)/\eta}\right]^{\eta/(\eta-1)}.
\]

国内品和进口品组合的需求为

\[
C_{H,t}=(1-\alpha)\left(\frac{P_{H,t}}{P_t}\right)^{-\eta}C_t,\qquad
C_{F,t}=\alpha\left(\frac{P_{F,t}}{P_t}\right)^{-\eta}C_t.
\]

### 企业

每个国内企业生产一种差异化产品，技术为线性形式：

\[
Y_t(j)=A_tN_t(j).
\]

名义刚性采用 Calvo 定价。每期有比例 \(1-\theta\) 的企业可以重设价格 \(\overline{P}_{H,t}\)。来源给出的对数线性重设价格规则为：

\[
\overline{p}_{H,t}
=\mu +(1-\beta\theta)\sum_{k=0}^{\infty}(\beta\theta)^k
E_t\{mc^n_{t+k}\},
\]

其中 \(\mu=\log(\varepsilon/(\varepsilon-1))\) 是对数稳态期望加成。

### 货币当局

在这个 MMB 变体中，政策工具是短期名义利率，规则对 CPI 通胀作出反应：

\[
r_t=\rho+\phi_{\pi}\pi_t.
\]

这是来源论文中的 CPI 通胀泰勒规则，不是国内通胀规则，也不是汇率钉住规则。

## 3. First-Order Conditions

- **(F1) 家庭劳动的期内条件**：

\[
C_t^\sigma N_t^\varphi=\frac{W_t}{P_t},
\qquad
w_t-p_t=\sigma c_t+\varphi n_t.
\]

- **(F2) 家庭随机贴现因子**：

\[
Q_{t,t+1}=
\beta\left(\frac{C_{t+1}}{C_t}\right)^{-\sigma}
\left(\frac{P_t}{P_{t+1}}\right).
\]

- **(F3) 无风险债券欧拉方程**：

\[
c_t=E_t\{c_{t+1}\}
-\frac{1}{\sigma}\left(r_t-E_t\{\pi_{t+1}\}-\rho\right).
\]

- **(F4) 完全市场下的国际风险分担**：

\[
c_t=c_t^{\ast}+\frac{1}{\sigma}q_t
=c_t^{\ast}+\frac{1-\alpha}{\sigma}s_t.
\]

- **(F5) 无抛补利率平价 / 贸易条件运动方程**：

\[
s_t=(r_t^{\ast}-E_t\{\pi_{t+1}^{\ast}\})
-(r_t-E_t\{\pi_{H,t+1}\})+E_t\{s_{t+1}\}.
\]

- **(F6) 以国内价格表示的企业实际边际成本**：

\[
mc_t=-\nu+w_t-p_{H,t}-a_t.
\]

- **(F7) 由产出、世界产出和生产率表示的国内边际成本**：

\[
mc_t=-\nu+(\sigma_\alpha+\varphi)y_t
+(\sigma-\sigma_\alpha)y_t^{\ast}-(1+\varphi)a_t.
\]

- **(F8) 国内自然产出**：

\[
\overline{y}_t=\Omega+\Gamma a_t+\alpha\Psi y_t^{\ast},
\]

其中

\[
\Gamma=\frac{1+\varphi}{\sigma_\alpha+\varphi},\qquad
\Psi=-\frac{\Theta\sigma_\alpha}{\sigma_\alpha+\varphi}.
\]

- **(F9) 产出缺口定义**：

\[
x_t=y_t-\overline{y}_t.
\]

- **(F10) 国内通胀 New Keynesian Phillips 曲线**：

\[
\pi_{H,t}=\beta E_t\{\pi_{H,t+1}\}+\kappa_\alpha x_t,
\qquad
\kappa_\alpha=\lambda(\sigma_\alpha+\varphi).
\]

- **(F11) 产出缺口动态 IS 方程**：

\[
x_t=E_t\{x_{t+1}\}
-\frac{1}{\sigma_\alpha}
\left(r_t-E_t\{\pi_{H,t+1}\}-\overline{rr}_t\right).
\]

- **(F12) 自然实际利率**：

\[
\overline{rr}_t
=\rho-\sigma_\alpha\Gamma(1-\rho_a)a_t
+\alpha\sigma_\alpha(\Theta+\Psi)E_t\{\Delta y_{t+1}^{\ast}\}.
\]

- **(F13) `NK_GMAS25cpi` 的 CPI 通胀泰勒规则**：

\[
r_t=\rho+\phi_{\pi}\pi_t.
\]

## 4. Market Clearing & Identities

- **(F14) CPI 与国内价格**：

\[
p_t=p_{H,t}+\alpha s_t.
\]

- **(F15) CPI 通胀与国内通胀**：

\[
\pi_t=\pi_{H,t}+\alpha\Delta s_t.
\]

- **(F16) 有效贸易条件与名义汇率**：

\[
s_t=e_t+p_t^{\ast}-p_{H,t}.
\]

- **(F17) 有效实际汇率**：

\[
q_t=(1-\alpha)s_t.
\]

- **(F18) 商品市场出清 / 产出需求关系**：

\[
y_t=c_t+\frac{\alpha\omega}{\sigma}s_t,
\qquad
\omega=\sigma\gamma+(1-\alpha)(\sigma\eta-1).
\]

- **(F19) 产出与贸易条件**：

\[
y_t=y_t^{\ast}+\frac{1}{\sigma_\alpha}s_t,\qquad
\sigma_\alpha=\frac{\sigma}{(1-\alpha)+\alpha\omega}.
\]

- **(F20) 线性生产函数**：

\[
y_t=a_t+n_t.
\]

- **(F21) 如需跟踪的净出口**：

\[
nx_t=\alpha\left(\frac{\omega}{\sigma}-1\right)s_t.
\]

## 5. Exogenous Processes

- **(F22) 国内生产率**：

\[
a_t=\rho_a a_{t-1}+\varepsilon_t^a.
\]

- **(F23) 世界产出过程**：

\[
y_t^{\ast}=\rho_{y^{\ast}}y_{t-1}^{\ast}+\varepsilon_t^{\ast}.
\]

数值部分使用加拿大季度劳动生产率和美国 GDP 数据估计两个 AR(1) 过程，并允许两个创新存在正的同期相关。本条目不把论文报告的创新标准差作为结构推导要求。

## 6. Steady-State Solution

由于可操作系统是对数线性的，所有平稳小写变量都是围绕对称完全预见稳态的偏离。

- 设定零通胀稳态：\(\pi_H=\pi=0\)。
- 设定 PPP/相对价格归一化：\(s=q=e=0\) 且 \(p=p_H=p_F=p^{\ast}\)。
- 设定外生偏离：\(a=0\) 且 \(y^{\ast}=0\)。
- 设定产出处在自然水平：\(x=0\) 且 \(y=\overline{y}\)。
- 在论文的对数线性记号中，稳态实际利率常数为：\(r=\rho=\beta^{-1}-1\)。
- 在福利分析的特殊情形 \(\sigma=\eta=\gamma=1\) 下，来源报告 \(\omega=1\) 且平衡贸易条件 \(nx_t=0\)。

自然产出的常数项 \(\Omega\) 取决于加成和补贴楔子。OCR 中关于 \(\Omega=(\nu-\mu)/(\sigma_\alpha+\varphi)\) 的行足以支持一稿，但在进入 reviewed 状态前仍标记为 `needs_review`。

## 7. Timing & Form Conventions

- **形式**：`model(linear)` 风格的对数线性表示。除非明确表示利率，小写变量均为对数或对数偏离。
- **通胀时点**：\(\pi_t=p_t-p_{t-1}\)，\(\pi_{H,t}=p_{H,t}-p_{H,t-1}\)。
- **预期**：\(E_t\{\cdot\}\) 基于 \(t\) 期信息集。
- **存量**：该模型没有资本存量；生产对劳动为线性。
- **政策利率**：\(r_t\) 是来源对数线性政策规则记号中的短期名义利率；自然实际利率 \(\overline{rr}_t\) 进入 IS 方程。
- **开放经济价格**：贸易条件是外国品相对于本国品的价格，因此在论文约定下，\(s_t\) 上升表示本国贸易条件恶化。
- **CPI 变体**：`NK_GMAS25cpi` 使用 (F13) 闭合系统，政策规则对 \(\pi_t\) 而非 \(\pi_{H,t}\) 作出反应。

## 8. Variable & Parameter Reference Table

| 类别 | 符号 / ASCII | 含义 | 主要方程 |
|---|---|---|---|
| 内生变量 | \(c_t\) / `c` | 消费 | (F3), (F4), (F18) |
| 内生变量 | \(n_t\) / `n` | 劳动 | (F1), (F20) |
| 内生变量 | \(y_t\) / `y` | 国内产出 | (F18), (F19), (F20) |
| 内生变量 | \(x_t\) / `x` | 产出缺口 | (F9), (F10), (F11) |
| 内生变量 | \(\pi_{H,t}\) / `piH` | 国内品通胀 | (F10), (F15) |
| 内生变量 | \(\pi_t\) / `pi` | CPI 通胀 | (F13), (F15) |
| 内生变量 | \(r_t\) / `r` | 对数线性记号中的短期名义政策利率 | (F11), (F13) |
| 内生变量 | \(s_t\) / `s` | 有效贸易条件 | (F4), (F5), (F14)-(F19) |
| 内生变量 | \(q_t\) / `q` | 实际汇率 | (F4), (F17) |
| 内生变量 | \(e_t\) / `e` | 名义有效汇率 | (F16) |
| 内生变量 | \(mc_t\) / `mc` | 实际边际成本 | (F6), (F7), (F10) |
| 内生变量 | \(\overline{y}_t\) / `ybar` | 自然产出 | (F8), (F9) |
| 内生变量 | \(\overline{rr}_t\) / `rrbar` | 自然实际利率 | (F11), (F12) |
| 可选内生变量 | \(nx_t\) / `nx` | 净出口占比 | (F21) |
| 外生变量 | \(a_t\) / `a` | 国内生产率 | (F22) |
| 外生变量 | \(y_t^{\ast}\) / `ystar` | 世界产出 | (F23) |
| 冲击 | \(\varepsilon_t^a\) / `eps_a` | 国内生产率创新 | (F22) |
| 冲击 | \(\varepsilon_t^{\ast}\) / `eps_ystar` | 世界产出创新 | (F23) |
| 参数 | \(\beta\) / `beta` | 贴现因子 | (F2), (F10) |
| 参数 | \(\sigma\) / `sigma` | 跨期替代弹性倒数 / 风险厌恶 | (F1), (F3), (F4) |
| 参数 | \(\varphi\) / `phi_n` | Frisch 弹性倒数 | (F1), (F7), (F10) |
| 参数 | \(\alpha\) / `alpha` | 开放度/进口份额参数 | (F14), (F15), (F18), (F19) |
| 参数 | \(\eta\) / `eta` | 国内品与外国品组合替代弹性 | (F18) |
| 参数 | \(\gamma\) / `gamma` | 不同外国品之间的替代弹性 | (F18) |
| 参数 | \(\theta\) / `theta` | Calvo 不重设价格概率 | (F10) |
| 参数 | \(\varepsilon\) / `epsilon` | 品种替代弹性 / 加成决定因素 | 第2节，第6节 |
| 参数 | \(\lambda\) / `lambda` | Calvo 斜率组成部分 | (F10) |
| 参数 | \(\kappa_\alpha\) / `kappa_alpha` | 开放经济 Phillips 曲线斜率 | (F10) |
| 参数 | \(\phi_\pi\) / `phi_pi` | 泰勒规则中的 CPI 通胀反应 | (F13) |
| 参数 | \(\rho_a\) / `rho_a` | 国内生产率持续性 | (F22) |
| 参数 | \(\rho_{y^{\ast}}\) / `rho_ystar` | 世界产出持续性 | (F23) |
| 参数 | \(\nu,\mu,\tau\) / `nu`, `mu`, `tau` | 补贴与加成项 | (F6), 第6节 |

一稿方程标签从 (F1) 到 (F23) 连续。由于 \(\Omega\)、\(\Theta\) 和 OCR 渲染的附录公式中的部分系数定义需要在晋升前对照 PDF 检查，本条目保持 `needs_review`。
