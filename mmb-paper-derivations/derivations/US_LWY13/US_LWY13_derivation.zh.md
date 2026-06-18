# US_LWY13 - 推导（最优化问题 + 一阶条件）

> MMB 模型档案的一次来源支撑初稿。状态：`needs_review`。

## 1. 模型概述

- **模型**：`US_LWY13`，来源 Leeper、Walker 和 Yang（2013）"Fiscal foresight and information flows"，*Econometrica* 81(3), 1115-1145，DOI `10.3982/ecta8337`。
- **档案范围**：论文研究财政预见与信息流假设。论文先给出一个透明的解析增长模型，再把税收新闻嵌入 RBC 和新凯恩斯数据生成模型。本条目记录与 MMB `US_LWY13` 实现相关的模型结构。
- **主体与模块**：家庭、厂商、政府/财政当局、NK 应用中的货币当局，以及外生新闻/冲击过程。
- **形式**：MMB 实现交叉检查显示为 `model(linear)`。论文侧方程同时包含非线性原始条件和对数线性化均衡条件。由于论文正文只概述完整 NK 模型并把细节放在未规范化的补充材料中，公式级状态为 `needs_review`。
- **运行验证**：未执行。未运行 Dynare。

## 2. 主体的最优化问题

### 2.1 解析增长模型家庭

解析例子中的代表性家庭在对数效用、完全折旧、劳动无弹性和税收扭曲生产回报下选择消费和下一期资本：

\[
\max_{\{C_t,K_t\}} E_0\sum_{t=0}^{\infty}\beta^t\log C_t
\quad\text{s.t.}\quad
C_t+K_t+T_t \le (1-\tau_t)A_tK_{t-1}^{\alpha}.
\]

政府用一次性转移平衡预算：

\[
T_t=\tau_tY_t,\qquad G_t=0.
\]

### 2.2 定量 RBC 家庭与厂商

RBC 模型被描述为接近 Chari-Kehoe-McGrattan 的代表性主体经济。家庭最大化关于消费和闲暇的时间可分效用，供给劳动和资本，并面对劳动税和资本税。代表性厂商租用劳动和资本，用 Cobb-Douglas 技术生产。

论文侧 Markdown 没有列出完整一阶条件；因此本模块暂记为 `needs_review`，等待补充材料公式复核。

### 2.3 定量新凯恩斯模型

NK 模型在 RBC 模型基础上加入外部习惯形成、差异化劳动、垄断竞争中间品生产者、可变资本利用率、工资和价格黏性，以及设置名义利率的 Taylor 型货币政策规则。财政融资允许政府支出和转移对债务作出反应。论文以模块层面描述该模型，并把完整细节放在补充材料中。

Rep-MMB `.mod` 文件只作为 `implementation_cross_check` 使用，并显示 `US_LWY13` 是线性化 NK 实现，包含 Ricardian/Non-Ricardian 消费模块、投资调整、资本利用、工资和价格加成冲击、税收规则、支出和转移规则，以及用于产出缺口的灵活价格对应变量。

## 3. 一阶条件（FOC）

- **(F1) 解析家庭 Euler 方程**：

\[
\frac{1}{C_t}
=
\alpha\beta E_t\left[
(1-\tau_{t+1})\frac{1}{C_{t+1}}\frac{Y_{t+1}}{K_t}
\right].
\]

- **(F2) 解析资源与生产条件**：

\[
C_t+K_t=Y_t=A_tK_{t-1}^{\alpha}.
\]

- **(F3) 对数线性化资本差分方程**：

\[
E_tk_{t+1}-(\theta^{-1}+\alpha)k_t+\alpha\theta^{-1}k_{t-1}
=
E_t\left[a_{t+1}-\theta^{-1}a_t\right]
+\left\{\theta^{-1}(1-\theta)\frac{\tau}{1-\tau}\right\}E_t\hat{\tau}_{t+1},
\]

其中

\[
\theta=\alpha\beta(1-\tau).
\]

- **(F4) 财政预见下的解析资本解**：

\[
k_t=\alpha k_{t-1}+a_t
-(1-\theta)\frac{\tau}{1-\tau}
\sum_{i=0}^{\infty}\theta^i E_t\hat{\tau}_{t+i+1}.
\]

- **(F5) 实际利率 / Ricardian 消费 Euler 模块（`implementation_cross_check`）**：

\[
c^r_t-\frac{1}{1+\theta_h}c^r_{t+1}
+\frac{1-\theta_h}{\gamma(1+\theta_h)}(R_t-\pi_{t+1}-u^b_t+u^b_{t+1})
=\frac{\theta_h}{1+\theta_h}c^r_{t-1}.
\]

该式改写自 MMB 线性实现；记号标记为 `implementation_cross_check`。

- **(F6) 投资调整方程（`implementation_cross_check`）**：

\[
i_t-\frac{\beta}{1+\beta}i_{t+1}
-\frac{1}{(1+\beta)s}q_t-\beta u^i_{t+1}+u^i_t
=\frac{1}{1+\beta}i_{t-1}.
\]

- **(F7) 含资本税楔子的 Q 方程（`implementation_cross_check`）**：

\[
q_t+R_t-\pi_{t+1}-\beta(1-\delta)q_{t+1}
-\beta r^k(1-\tau^K)(1+\tau^C)r^k_{t+1}
+\tau^K\beta r^k(1+\tau^C)\tau^K_{t+1}=0.
\]

- **(F8) 资本积累（`implementation_cross_check`）**：

\[
k_t-\delta i_t=(1-\delta)k_{t-1}.
\]

- **(F9) 工资设定 / 劳动供给模块（`implementation_cross_check`，压缩表示）**：

\[
\mathcal{W}(w_t,w_{t+1},w_{t-1},\pi_t,\pi_{t+1},\pi_{t-1},l_t,c^r_t,c^r_{t-1},c^{nr}_t,\tau^L_t,u^w_t)=0.
\]

精确的系数密集型线性工资方程来自 `.mod` 文件，需要论文侧补充材料复核。

- **(F10) 资本需求（`implementation_cross_check`）**：

\[
\bar{k}_t-y_t-(1-\alpha)w_t+(1-\alpha)r^k_t+u^a_t=0.
\]

- **(F11) 生产函数（`implementation_cross_check`）**：

\[
y_t-u^a_t-\alpha\bar{k}_t-(1-\alpha)l_t=0.
\]

- **(F12) Taylor 型货币政策规则（`implementation_cross_check`）**：

\[
R_t-\left[(1-\rho_R)\phi_{\pi}+\phi_{\pi d}\right]\pi_t
-\left[(1-\rho_R)\phi_y+\phi_{yd}\right]y_t
+\phi_a u^a_t-u^m_t
=-\phi_{\pi d}\pi_{t-1}-\phi_{yd}y_{t-1}+\rho_RR_{t-1}.
\]

## 4. 市场出清与总量恒等式

- **(F13) 总消费恒等式（`implementation_cross_check`）**：

\[
c\,c_t-(1-\mu)c^r c^r_t-\mu c^{nr}c^{nr}_t=0.
\]

- **(F14) Non-Ricardian 家庭预算（`implementation_cross_check`）**：

\[
c^{nr}c^{nr}_t
-w l(1-\tau^L)w_t-w l(1-\tau^L)l_t
+w l\tau^L\tau^L_t-z z_t=0.
\]

- **(F15) 债务产出比定义（`implementation_cross_check`）**：

\[
s^B_t+y_t-b_t=0.
\]

- **(F16) 总资源约束（`implementation_cross_check`）**：

\[
y_t-c_yc_t-\delta k_y i_t-s_g g_t-\psi_1 k_y v_t=0.
\]

- **(F17) 政府预算约束（`implementation_cross_check`，压缩表示）**：

\[
\mathcal{B}(b_t,g_t,\tau^K_t,r^k_t,v_t,\tau^L_t,w_t,l_t,z_t,\pi_t,R_{t-1},b_{t-1},k_{t-1})=0.
\]

完整线性化政府预算恒等式可在 `.mod` 文件中看到；本初稿将它保存为压缩的 `needs_review` 方程，而不把系数密集的实现式当作论文证据复制。

- **(F18) 资本利用关系（`implementation_cross_check`）**：

\[
\frac{\psi}{1-\psi}v_t-r^k_t+\frac{\tau^K}{1-\tau^K}\tau^K_t=0.
\]

- **(F19) 有效资本定义（`implementation_cross_check`）**：

\[
\bar{k}_t-v_t=k_{t-1}.
\]

- **(F20) Fisher 方程（`implementation_cross_check`）**：

\[
r_t-R_t+\pi_{t+1}=0.
\]

- **(F21) 实际边际成本（`implementation_cross_check`）**：

\[
mc_t-(1-\alpha)w_t-\alpha r^k_t+u^a_t=0.
\]

- **(F22) 资本税收入（`implementation_cross_check`）**：

\[
T^K_t-\tau^K_t-r^k_t-\bar{k}_t=0.
\]

- **(F23) 劳动税收入（`implementation_cross_check`）**：

\[
T^L_t-\tau^L_t-w_t-l_t=0.
\]

## 5. 外生过程

- **(F24) 简单解析税收新闻过程**：

\[
\hat{\tau}_t=\varepsilon_{\tau,t-q}.
\]

- **(F25) 简单解析技术过程**：

\[
a_t=\varepsilon_{A,t}.
\]

- **(F26) 一般劳动税信息流过程**：

\[
\hat{\tau}^L_t
=\rho\hat{\tau}^L_{t-1}
+\sum_{j=0}^{J}\phi_j\left[
\sigma^L\varepsilon^L_{\tau,t-j}
+\xi\sigma^K\varepsilon^K_{\tau,t-j}
\right].
\]

- **(F27) NK 模型中的政府支出和转移反馈过程**：

\[
\hat{X}_t=\rho_X\hat{X}_{t-1}+\gamma_X\hat{s}^B_{t-1}+\sigma_X\varepsilon^X_t,
\qquad
\hat{X}\in\{\hat{G},\hat{Z}\},\quad \gamma_X<0.
\]

- **(F28) 技术冲击（`implementation_cross_check`）**：

\[
u^a_t=\rho_a u^a_{t-1}+\sigma_a\varepsilon^a_t.
\]

- **(F29) 偏好冲击（`implementation_cross_check`）**：

\[
u^b_t=\rho_b u^b_{t-1}+\sigma_b\varepsilon^b_t.
\]

- **(F30) 投资冲击（`implementation_cross_check`）**：

\[
u^i_t=\rho_i u^i_{t-1}+\sigma_i\varepsilon^i_t.
\]

- **(F31) 工资加成冲击（`implementation_cross_check`）**：

\[
u^w_t=\rho_w u^w_{t-1}+\sigma_w\varepsilon^w_t.
\]

- **(F32) 价格加成冲击（`implementation_cross_check`）**：

\[
u^p_t=\rho_p u^p_{t-1}+\sigma_p\varepsilon^p_t.
\]

- **(F33) 资本税冲击（`implementation_cross_check`）**：

\[
u^{\tau K}_t=\sigma_{\tau K}\varepsilon^{\tau K}_t.
\]

- **(F34) 劳动税冲击（`implementation_cross_check`）**：

\[
u^{\tau L}_t=\sigma_{\tau L}\varepsilon^{\tau L}_t.
\]

- **(F35) 转移冲击（`implementation_cross_check`）**：

\[
u^z_t=\sigma_z\varepsilon^z_t.
\]

## 6. 稳态求解

- 解析例子的稳态资本存量为

\[
K=\left[\alpha\beta(1-\tau)A\right]^{1/(1-\alpha)}.
\]

- 解析例子使用相对稳态的对数偏离：

\[
k_t=\log K_t-\log K,\qquad a_t=\log A_t-\log A,\qquad
\hat{\tau}_t=\log\tau_t-\log\tau.
\]

- NK MMB 实现围绕由 `.mod` 文件中 `paramfile_leeper` 参数计算的稳态线性化。实现定义了 `Rss`、`rkss`、`wss`、`kyss`、`lyss`、`cyss`、`yss`、`crss`、`cnrss`、`kss`、`ivss`、`lss`、`css`、`zss`、`bss`、`gss`、`lambrss` 和 `lambnrss` 等比率和水平。
- 论文侧 Markdown 没有给出 NK 模型的完整稳态推导。因此稳态质量为 `implementation_cross_check_only` 和 `needs_review`。

## 7. 时序与形式约定

- 解析例子采用完全折旧，并把 \(K_t\) 作为决策后的资本存量；它在下一期生产中作为 \(Y_{t+1}\) 的投入 \(K_t\) 出现。
- 简单新闻过程 \(\hat{\tau}_t=\varepsilon_{\tau,t-q}\) 表示日期 \(t\) 的主体观察到会映射到 \(q\) 期后税率的新闻。
- 在一般信息流过程中，\(\phi_j\) 系数描述税收新闻如何分布在 inside lag 和 outside lag 中。论文表 I 给出四种设定，包括平滑六季度 inside-lag 新闻，以及两季度或八季度 outside-lag 完全预见。
- MMB 实现使用 `model(linear)`，生产中使用滞后资本，并用灵活价格对应变量定义产出缺口。
- 未执行 Dynare 运行验证。

## 8. 变量与参数对照表

| 类别 | 符号 / ASCII | 含义 | 方程覆盖 |
|---|---|---|---|
| 内生 | \(C_t\), `cr`, `cnr`, `c` | 消费；实现中的 Ricardian/Non-Ricardian 分量 | (F1), (F5), (F13), (F14) |
| 内生 | \(K_t\), `k`, `kbar` | 资本存量和有效资本 | (F2), (F4), (F8), (F19) |
| 内生 | \(Y_t\), `y` | 产出 | (F2), (F11), (F16) |
| 内生 | \(l_t\) | 劳动 | (F9), (F11), (F14), (F23) |
| 内生 | \(q_t\) | Tobin's Q | (F6), (F7) |
| 内生 | \(R_t\), \(r_t\) | 名义和实际利率 | (F5), (F12), (F20) |
| 内生 | \(\pi_t\) | 通胀 | (F5), (F12), (F20) |
| 内生 | \(w_t\), \(r^k_t\), \(mc_t\) | 工资、资本回报和实际边际成本 | (F9), (F10), (F18), (F21) |
| 内生 | \(b_t\), \(s^B_t\) | 政府债务和债务产出比 | (F15), (F17), (F27) |
| 内生 | \(g_t\), \(z_t\) | 政府支出和转移 | (F14), (F16), (F17), (F27) |
| 内生 | \(\tau^K_t\), \(\tau^L_t\), \(T^K_t\), \(T^L_t\) | 资本/劳动税率和税收收入 | (F22), (F23), (F26), (F33), (F34) |
| 内生 | \(v_t\) | 资本利用率 | (F16), (F18), (F19) |
| 外生 | \(\varepsilon_A\), `epsilona` | 技术创新 | (F25), (F28) |
| 外生 | \(\varepsilon_{\tau}\), `epsilontk`, `epsilontl` | 税收新闻/创新 | (F24), (F26), (F33), (F34) |
| 外生 | `epsilonb`, `epsiloni`, `epsilonw`, `epsilonp`, `epsilonz` | 偏好、投资、工资加成、价格加成、转移冲击 | (F29)-(F32), (F35) |
| 外生 | `interest_`, `fiscal_` | MMB 政策冲击 | (F12), (F27) |
| 参数 | \(\alpha\), \(\beta\), \(\tau\), \(\theta\) | 生产份额、贴现因子、税率、解析折现系数 | (F1)-(F4) |
| 参数 | \(\rho\), \(\phi_j\), \(\sigma^L\), \(\sigma^K\), \(\xi\) | 财政预见的信息流参数 | (F26) |
| 参数 | \(\rho_X\), \(\gamma_X\), \(\sigma_X\) | 财政反馈参数 | (F27) |
| 参数 | `gamm`, `kappa`, `omegaw`, `omegap`, `etaw`, `etap`, `mu`, `phipi`, `phiy`, `delt` | NK 实现中的偏好、刚性、政策和折旧参数 | `implementation_cross_check` |
