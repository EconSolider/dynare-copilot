# NK_GM05 -- 推导

> 未执行运行时验证。本一阶段归档条目基于 MinerU Markdown 来源；凡公式或实现选择需要后续对照已发表 PDF 的位置，均标记为 `needs_review`。

来源信息：`NK_GM05`，Galí and Monacelli (2005)，"Monetary policy and exchange rate volatility in a small open economy"，Review of Economic Studies 72, 707-734，DOI `10.1111/j.1467-937x.2005.00349.x`。来源 Markdown：`raw/mmb_mineru/runs/nk_gm05_nk_gmas25cpi_nk_gmas25ppi__monetary_policy_and_exchange_rate_volatility_in_a_small_open_economy__6f92413a/full.md`。已检查原始 PDF 路径：`raw/mmb_papers/Monetary policy and exchange rate volatility in a small open economy.pdf`。

## 1. Model Overview

- **模型**：小型开放经济新凯恩斯模型，包含完全国际金融市场、Calvo 国内价格设定、生产者价格通胀、CPI 通胀、贸易条件和名义汇率动态。
- **来源重点**：论文先推导家庭和企业模型，再使用对数线性 canonical system 做政策制度实验。MMB 实现交叉检查使用对数线性的 `model(linear)` 表示。
- **主体与模块**：代表性家庭、国内差异化产品企业、对小国经济外生的世界经济，以及选择严格国内通胀目标、国内通胀 Taylor 规则、CPI 通胀 Taylor 规则或汇率盯住的货币当局。
- **形式**：对数线性。小写变量是围绕对称零通胀稳态的对数偏离或对数水平。MMB 示例使用 `model(linear)`。
- **主要外生驱动**：国内生产率 \(a_t\) 和世界产出 \(y_t^{\ast}\)。

## 2. Optimization Problems

### 代表性家庭

家庭选择消费、劳动和完整或有债权组合：

\[
\max_{\{C_t,N_t,D_{t+1}\}} E_0 \sum_{t=0}^{\infty}\beta^t
\left(\frac{C_t^{1-\sigma}}{1-\sigma}-\frac{N_t^{1+\varphi}}{1+\varphi}\right)
\]

约束为名义预算约束：

\[
P_t C_t + E_t\{Q_{t,t+1}D_{t+1}\} \le D_t + W_t N_t + T_t.
\]

消费是国内品和进口品的 CES 组合：

\[
C_t=\left[(1-\alpha)^{1/\eta}C_{H,t}^{(\eta-1)/\eta}
+\alpha^{1/\eta}C_{F,t}^{(\eta-1)/\eta}\right]^{\eta/(\eta-1)}.
\]

每个来源国的品种以内生替代弹性 \(\varepsilon\) 聚合为 CES 指数；进口品还按外国来源国以弹性 \(\gamma\) 聚合。

### 国内企业

每个国内企业用线性技术生产一种差异化产品：

\[
Y_t(j)=A_t N_t(j), \qquad a_t \equiv \log A_t.
\]

在 Calvo 概率 \(1-\theta\) 下能够重新定价的企业选择 \(\overline P_{H,t}\)，最大化预期贴现股利流：

\[
\max_{\overline P_{H,t}} \sum_{k=0}^{\infty}\theta^k E_t
\left\{Q_{t,t+k}Y_{t+k}(\overline P_{H,t})
\left[\overline P_{H,t}-MC^n_{t+k}\right]\right\},
\]

并受品种需求约束。Appendix B 附近的 MinerU OCR 在结构上可读，但需求项被压缩；晋升前应对照 PDF 检查该目标式（`needs_review`）。

### 货币当局

论文研究严格国内通胀目标和三类简单政策制度。政策由利率规则或汇率规则表示，而不是由货币需求表示。

## 3. First-Order Conditions

- **(F1) 劳动的期内条件**：

\[
C_t^{\sigma}N_t^{\varphi}=\frac{W_t}{P_t}.
\]

- **(F2) 名义随机贴现因子**：

\[
Q_{t,t+1}=\beta\left(\frac{C_{t+1}}{C_t}\right)^{-\sigma}
\left(\frac{P_t}{P_{t+1}}\right).
\]

- **(F3) 消费 Euler 方程，对数线性形式**：

\[
c_t=E_t\{c_{t+1}\}-\frac{1}{\sigma}
\left(r_t-E_t\{\pi_{t+1}\}-\rho\right).
\]

- **(F4) 国际风险分担**：

\[
c_t=c_t^{\ast}+\frac{1}{\sigma}q_t
=c_t^{\ast}+\frac{1-\alpha}{\sigma}s_t.
\]

- **(F5) 无抛补利率平价**：

\[
r_t-r_t^{\ast}=E_t\{\Delta e_{t+1}\}.
\]

- **(F6) 贸易条件与利差关系**：

\[
s_t=(r_t^{\ast}-E_t\{\pi_{t+1}^{\ast}\})-(r_t-E_t\{\pi_{H,t+1}\})+E_t\{s_{t+1}\}.
\]

- **(F7) 总量生产**：

\[
y_t=a_t+n_t.
\]

- **(F8) 以国内价格计的实际边际成本**：

\[
mc_t=-\nu+(w_t-p_{H,t})-a_t.
\]

- **(F9) 以边际成本表示的国内通胀 Phillips 曲线**：

\[
\pi_{H,t}=\beta E_t\{\pi_{H,t+1}\}+\lambda \widehat{mc}_t,
\qquad
\lambda=\frac{(1-\beta\theta)(1-\theta)}{\theta}.
\]

- **(F10) 边际成本作为国内产出的函数**：

\[
mc_t=-\nu+(\sigma_{\alpha}+\varphi)y_t+(\sigma-\sigma_{\alpha})y_t^{\ast}
-(1+\varphi)a_t.
\]

- **(F11) 自然产出**：

\[
\overline y_t=\Omega+\Gamma a_t+\alpha\Psi y_t^{\ast},
\quad
\Gamma=\frac{1+\varphi}{\sigma_{\alpha}+\varphi},
\quad
\Psi=-\frac{\Theta\sigma_{\alpha}}{\sigma_{\alpha}+\varphi}.
\]

- **(F12) 产出缺口定义**：

\[
x_t=y_t-\overline y_t.
\]

- **(F13) 以产出缺口表示的 NK Phillips 曲线**：

\[
\pi_{H,t}=\beta E_t\{\pi_{H,t+1}\}+\kappa_{\alpha}x_t,
\qquad
\kappa_{\alpha}=\lambda(\sigma_{\alpha}+\varphi).
\]

- **(F14) 动态 IS 方程**：

\[
x_t=E_t\{x_{t+1}\}-\frac{1}{\sigma_{\alpha}}
\left(r_t-E_t\{\pi_{H,t+1}\}-\overline{rr}_t\right).
\]

- **(F15) 自然实际利率**：

\[
\overline{rr}_t=\rho-\sigma_{\alpha}\Gamma(1-\rho_a)a_t
+\alpha\sigma_{\alpha}(\Theta+\Psi)E_t\{\Delta y_{t+1}^{\ast}\}.
\]

- **(F16) 严格国内通胀目标 / 最优特殊情形**：

\[
x_t=\pi_{H,t}=0.
\]

- **(F17) 实现最优配置的规则**：

\[
r_t=\overline{rr}_t+\phi_{\pi}\pi_{H,t}+\phi_x x_t.
\]

- **(F18) 实现规则的确定性条件**：

\[
\kappa_{\alpha}(\phi_{\pi}-1)+(1-\beta)\phi_x>0.
\]

## 4. Market Clearing & Identities

- **(F19) CPI 价格指数，一阶形式**：

\[
p_t=p_{H,t}+\alpha s_t.
\]

- **(F20) CPI 通胀恒等式**：

\[
\pi_t=\pi_{H,t}+\alpha\Delta s_t.
\]

- **(F21) 贸易条件定义**：

\[
s_t=e_t+p_t^{\ast}-p_{H,t}.
\]

- **(F22) 有效实际汇率**：

\[
q_t=(1-\alpha)s_t.
\]

- **(F23) 小型开放经济需求-产出关系**：

\[
y_t=c_t+\frac{\alpha\omega}{\sigma}s_t,
\qquad
\omega=\sigma\gamma+(1-\alpha)(\sigma\eta-1).
\]

- **(F24) 世界商品市场出清**：

\[
y_t^{\ast}=c_t^{\ast}.
\]

- **(F25) 产出与贸易条件关系**：

\[
y_t=y_t^{\ast}+\frac{1}{\sigma_{\alpha}}s_t,
\qquad
\sigma_{\alpha}=\frac{\sigma}{(1-\alpha)+\alpha\omega}.
\]

- **(F26) 净出口关系**：

\[
nx_t=\alpha\left(\frac{\omega}{\sigma}-1\right)s_t.
\]

- **(F27) CPI 通胀 Taylor 规则**：

\[
r_t=\rho+\phi_{\pi}\pi_t.
\]

- **(F28) 国内通胀 Taylor 规则**：

\[
r_t=\rho+\phi_{\pi}\pi_{H,t}.
\]

- **(F29) 汇率盯住**：

\[
e_t=0.
\]

- **(F30) 特殊情形下的福利损失近似**：

\[
\mathbb{W}=-\frac{1-\alpha}{2}\sum_{t=0}^{\infty}\beta^t
\left[\frac{\varepsilon}{\lambda}\pi_{H,t}^2+(1+\varphi)x_t^2\right].
\]

## 5. Exogenous Processes

- **(F31) 国内生产率**：

\[
a_t=\rho_a a_{t-1}+\varepsilon_t^a.
\]

- **(F32) 世界产出**：

\[
y_t^{\ast}=\rho_y y_{t-1}^{\ast}+\varepsilon_t^{\ast}.
\]

校准部分估计 \(\rho_a=0.66\)、\(\rho_y=0.86\)，标准差为 \(0.0071\) 和 \(0.0078\)，创新相关系数为 \(0.3\)。MMB 示例使用冲击 `a_` 和 `ystar_`。

## 6. Steady-State Solution

该推导围绕对称完美预见稳态对数线性化。在该稳态中：

1. 对称外国经济的 \(A=1\)；对称基准下国内 \(A=1\)。
2. 购买力平价成立且 \(S=1\)，因此 \(s=0\)、\(q=0\)。
3. 在对称情形下，国内和国外产出相等，\(Y=Y^{\ast}\)。
4. 零通胀意味着 \(\pi_H=\pi=0\)，国内价格水平和 CPI 价格水平为常数。
5. 无风险实际总回报由 \(\beta\) 决定；论文对数线性记号中 \(\rho=\beta^{-1}-1\)。
6. 在最优政策的特殊校准下，\(\sigma=\eta=\gamma=1\)，补贴满足 \((1-\tau)(1-\alpha)=1-1/\varepsilon\)，使灵活价格配置有效率。
7. 在 `model(linear)` 实现中，所有内生对数偏离变量稳态为零；这是 Rep-MMB 示例采用的稳态约定。

来源在 Appendix A 给出了贸易条件唯一性的稳态论证。Appendix A 的少数代数行 OCR 有噪声，但 MMB 对数线性模型块不需要这些行（完整非线性推导需 `needs_review`）。

## 7. Timing & Form Conventions

- 变量以 \(t\) 期计时，并通过期望 \(E_t\{\cdot\}\) 体现前瞻性。
- 模型不含资本存量，因此没有资本投入生产的时序约定。
- 国内价格通胀为 \(\pi_{H,t}=p_{H,t}-p_{H,t-1}\)；CPI 通胀为 \(\pi_t=p_t-p_{t-1}\)。
- 贸易条件为 \(s_t=p_{F,t}-p_{H,t}=e_t+p_t^{\ast}-p_{H,t}\)；在论文约定中，更高的 \(s_t\) 表示本国贸易条件贬值。
- MMB 示例将政策制度固定为 DIT（`pih = 0`），并注释掉 DITR、CITR 和 PEG 替代规则。它还把外国通胀设为零，并未在活动模型块中包含 UIP 方程。
- 未执行运行时验证；方程数和 BK 检查留待以后处理。

## 8. Variable & Parameter Reference Table

| Category | Symbol / Dynare name | Meaning | Main equation(s) |
|---|---|---|---|
| Endogenous | \(c_t\) | CPI 消费 | (F3), (F4), (F23) |
| Endogenous | \(n_t\) | 劳动 | (F1), (F7) |
| Endogenous | \(w_t\) | 名义工资对数 | (F1), (F8) |
| Endogenous | \(y_t\) / `y` | 国内产出 | (F10), (F12), (F25) |
| Endogenous | \(\overline y_t\) / `ynat` | 自然产出 | (F11) |
| Endogenous | \(x_t\) / `x` | 产出缺口 | (F12), (F14) |
| Endogenous | \(\pi_{H,t}\) / `pih` | 国内通胀 | (F13), (F20), (F28) |
| Endogenous | \(\pi_t\) / `pi` | CPI 通胀 | (F20), (F27) |
| Endogenous | \(r_t\) / `r` | 对数线性记号下的名义政策利率 | (F14), (F17), (F27), (F28) |
| Endogenous | \(\overline{rr}_t\) / `rnat` | 自然实际利率 | (F15) |
| Endogenous | \(s_t\) / `s` | 贸易条件 | (F21), (F25) |
| Endogenous | \(q_t\) | 有效实际汇率 | (F22) |
| Endogenous | \(e_t\) / `e` | 名义有效汇率 | (F21), (F29) |
| Endogenous | \(p_t\) / `p` | CPI 价格水平 | (F19) |
| Endogenous | \(p_{H,t}\) / `ph` | 国内价格水平 | (F19), (F21) |
| Endogenous | \(a_t\) / `a` | 国内生产率 | (F31) |
| Endogenous | \(y_t^{\ast}\) / `ystar` | 世界产出 | (F32) |
| Endogenous | \(\pi_t^{\ast}\) / `pistar` | 世界通胀 | MMB sets zero |
| Exogenous | \(\varepsilon_t^a\) / `a_` | 国内生产率创新 | (F31) |
| Exogenous | \(\varepsilon_t^{\ast}\) / `ystar_` | 世界产出创新 | (F32) |
| Parameter | \(\beta\) / `beta` | 贴现因子 | (F2), (F9), (F13) |
| Parameter | \(\sigma\) / `sigma` | 消费风险厌恶 / 跨期替代弹性倒数 | (F3), (F4), (F23) |
| Parameter | \(\varphi\) / `varphi` or `tau` in MMB code | Frisch 弹性倒数 | (F1), (F10), (F11) |
| Parameter | \(\alpha\) / `alpha` | 开放度 / 进口份额 | (F19), (F20), (F25) |
| Parameter | \(\eta\) | 国内品与外国产品替代弹性 | (F23) |
| Parameter | \(\gamma\) | 不同外国来源品替代弹性 | (F23) |
| Parameter | \(\theta\) / `theta` | Calvo 不重设价格概率 | (F9) |
| Parameter | \(\varepsilon\) | 品种替代弹性 | (F30) |
| Parameter | \(\lambda\) | Phillips 曲线边际成本系数 | (F9), (F30) |
| Parameter | \(\kappa_{\alpha}\) / `kappa` | 开放经济 NKPC 斜率 | (F13), (F18) |
| Parameter | \(\rho\) / `rho` | 对数线性记号中的稳态实际利率 | (F3), (F15), (F27), (F28) |
| Parameter | \(\rho_a\) / `rhoa` | 生产率持续性 | (F31) |
| Parameter | \(\rho_y\) / `rhoy` | 世界产出持续性 | (F32) |
| Parameter | \(\phi_{\pi}\) / `phipi` | Taylor 规则通胀系数 | (F17), (F27), (F28) |
| Parameter | \(\phi_x\) | Taylor 规则产出缺口系数 | (F17), (F18) |
| Parameter | \(\omega\), \(\Theta\), \(\sigma_{\alpha}\), \(\Gamma\), \(\Psi\), \(\Omega\) | 开放经济复合系数 | (F10), (F11), (F15), (F23), (F25) |
