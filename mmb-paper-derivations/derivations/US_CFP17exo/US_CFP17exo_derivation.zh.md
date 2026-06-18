# US_CFP17exo -- 推导

> 有来源支撑的私有归档草稿。未执行运行时验证；`.mod` 只作为实现交叉检查使用。

## 1. Model Overview

- **模型 ID**：`US_CFP17exo`。
- **论文**：Carlstrom, Fuerst, and Paustian (2017), "Targeting long rates in a model with segmented markets," *American Economic Journal: Macroeconomics*, 9(1), 205-42。
- **DOI**：`10.1257/mac.20150179`。
- **变体**：外生长期债务政策。Rep-MMB 实现将长期债券数量规则设为外生，并让期限溢价内生决定。
- **经济环境**：中等规模动态新凯恩斯模型，包含习惯形成、工资黏性、价格黏性、投资调整成本和分割的长期债券市场。
- **市场分割**：金融中介是投资债券和长期政府债券的唯一购买者。其净值和杠杆约束限制短期存款利率与长期债券回报之间的套利，从而产生期限溢价。
- **形式**：`model(linear)`。下列主方程采用小写的稳态偏离记号，与论文的线性化系统和 Rep-MMB 实现交叉检查一致。
- **主要来源**：`raw/mmb_mineru/runs/us_cfp17endo_us_cfp17exo__targeting_long_rates_in_a_model_with_segmented_markets__d8728772/full.md`。
- **原始 PDF**：`raw/mmb_papers/Targeting long rates in a model with segmented markets.pdf`。
- **MinerU run id**：`d8728772-c118-4e20-9cec-bcc6e7b742d5`。

## 2. Optimization Problems

### 家庭

家庭选择消费、劳动、短期存款、资本和投资债券融资。偏好包含外部习惯和贴现因子冲击：

\[
E_0\sum_{s=0}^{\infty}\beta^s e^{rn_{t+s}}
\left[\log(C_{t+s}-hC_{t+s-1})-B\frac{H_{t+s}(j)^{1+\eta}}{1+\eta}\right].
\]

论文中的预算和融资约束为：

\[
C_t+\frac{D_t}{P_t}+P_t^k I_t+\frac{F_{t-1}}{P_t}
\leq W_tH_t+R_t^kK_t-T_t+\frac{D_{t-1}}{P_t}R_{t-1}
\frac{Q_t(F_t-\kappa F_{t-1})}{P_t}+div_t,
\]

\[
K_{t+1}\leq(1-\delta)K_t+I_t,
\]

\[
P_t^kI_t\leq \frac{Q_t(F_t-\kappa F_{t-1})}{P_t}.
\]

最后一个约束是贷款先行约束：新增投资必须通过新发行的长期投资债券融资。

### 工资设定者

家庭是差异化劳动的垄断供给者。竞争性汇总部门将专业劳动合成为同质劳动。一部分 \(\theta_w\) 不能重设工资并按滞后通胀指数化，其余家庭在劳动需求约束下选择最优实际工资。

### 金融中介

金融中介选择股利和下一期净值：

\[
V_t=\max_{\{N_t,div_t\}}E_t\sum_{j=0}^{\infty}(\beta\zeta)^j\Lambda_{t+j}div_{t+j},
\]

并受预算约束：

\[
div_t+N_t[1+f(N_t)]\leq
\frac{P_{t-1}}{P_t}\left[(R_t^L-R_{t-1}^d)L_{t-1}+R_{t-1}\right]N_{t-1}.
\]

凸的净值调整成本为

\[
f(N_t)=\frac{\psi_n}{2}\left(\frac{N_t-N_{ss}}{N_{ss}}\right)^2.
\]

防止对存款违约的激励相容约束将杠杆确定为总量变量和金融冲击 \(\Phi_t\) 的函数。

### 企业

最终品企业用 CES 技术汇总差异化中间品。中间品企业租用资本和劳动，面对 Calvo 价格黏性和指数化，生产函数为

\[
Y_t(i)=A_tK_t(i)^\alpha H_t(i)^{1-\alpha}.
\]

新资本生产者将投资品转化为资本：

\[
\mu_t\left[1-S\left(\frac{I_t}{I_{t-1}}\right)\right]I_t,\qquad
S\left(\frac{I_t}{I_{t-1}}\right)=\frac{\psi_i}{2}\left(\frac{I_t}{I_{t-1}}-1\right)^2.
\]

### 政策部门

货币当局使用 Taylor 规则设定短期利率。在 `US_CFP17exo` 变体中，金融中介可持有的长期政府债务遵循外生 AR(2) 规则。财政政策是被动的，论文中政府购买设为零。

## 3. First-Order Conditions

下面方程连续编号，并使用论文的线性化记号。论文在线性化系统中显式写出 \(E_t\)；Rep-MMB 实现用 Dynare lead 表达同一预期对象。

**家庭与工资**

- **(F1) 含习惯和贴现冲击的消费边际效用**：

\[
\lambda_t=\frac{1}{(1-\beta h)(1-h)}E_t\left[\beta h c_{t+1}-(1+\beta h^2)c_t+hc_{t-1}\right]
+\frac{1}{1-\beta h}(rn_t-\beta h E_t rn_{t+1}).
\]

- **(F2) 劳动供给 / 边际替代率**：

\[
rn_t+\eta h_t-\lambda_t=mrs_t.
\]

- **(F3) 工资 Phillips 曲线**：

\[
\pi_t^w-\iota_w\pi_{t-1}=\kappa_w(mrs_t-w_t)+\beta(\pi_{t+1}^w-\iota_w\pi_t)+\varepsilon_t^w.
\]

- **(F4) 实际工资累计关系**：

\[
w_t=w_{t-1}+\pi_t^w-\pi_t.
\]

- **(F5) Fisher 方程 / 存款 Euler 方程**：

\[
\lambda_t=E_t\lambda_{t+1}+r_t-E_t\pi_{t+1}.
\]

**资本、投资融资与分割债券市场**

- **(F6) 含市场分割楔子的资本 Euler 方程**：

\[
\lambda_t+p_t^k+m_t
=E_t\left[\lambda_{t+1}+[1-\beta(1-\delta)]r_{t+1}^k
+\beta(1-\delta)(p_{t+1}^k+m_{t+1})\right].
\]

- **(F7) 投资债券定价方程**：

\[
\lambda_t+q_t+m_t=E_t\lambda_{t+1}-E_t\pi_{t+1}
+\beta\kappa E_t(q_{t+1}+m_{t+1}).
\]

- **(F8) 投资与未偿投资债券的联系**：

\[
(1-\kappa)(p_t^k+i_t)=f_t-\kappa(f_{t-1}+q_t-q_{t-1}-\pi_t).
\]

- **(F9) 中介长期资产的一期回报**：

\[
r_{t+1}^{L}=\frac{\kappa q_{t+1}}{R_{ss}^{L}}-q_t.
\]

- **(F10) 中介长期债券的十年收益率**：

\[
r_t^{10}=-\left(\frac{R_{ss}^{L}-\kappa}{R_{ss}^{L}}\right)q_t.
\]

- **(F11) 杠杆-利差关系**：

\[
E_t(r_{t+1}^{L}-r_t)=\frac{1}{L_{ss}-1}l_t+
\left[\frac{1+(s-1)L_{ss}}{L_{ss}-1}\right]\phi_t.
\]

- **(F12) 净值调整条件**：

\[
\psi n_t=
\left[\frac{sL_{ss}}{1+L_{ss}(s-1)}\right]E_t(r_{t+1}^{L}-r_t)
+\left[\frac{(s-1)L_{ss}}{1+L_{ss}(s-1)}\right]l_t.
\]

- **(F13) 中介资产负债表 / 杠杆恒等式**：

\[
\frac{\overline{B}_{ss}}{L_{ss}N_{ss}}b_t+
\left(1-\frac{\overline{B}_{ss}}{L_{ss}N_{ss}}\right)f_t=n_t+l_t.
\]

**生产、价格与投资供给**

- **(F14) 实际工资等于边际成本加劳动边际产出**：

\[
w_t=mc_t+mpl_t.
\]

- **(F15) 实际资本租金等于边际成本加资本边际产出**：

\[
r_t^k=mc_t+mpk_t.
\]

- **(F16) 价格 Phillips 曲线**：

\[
\pi_t=\frac{\kappa_\pi}{1+\beta\iota_p}mc_t+
\frac{\beta}{1+\beta\iota_p}E_t\pi_{t+1}
+\frac{\iota_p}{1+\beta\iota_p}\pi_{t-1}+\varepsilon_t^p.
\]

- **(F17) 投资供给 / 资本价格方程**：

\[
p_t^k=\psi_i[(i_t-i_{t-1})-\beta E_t(i_{t+1}-i_t)]-\mu_t.
\]

## 4. Market Clearing & Identities

- **(F18) 资源约束**：

\[
\left(1-\frac{I_{ss}}{Y_{ss}}\right)c_t+\frac{I_{ss}}{Y_{ss}}i_t
=a_t+\alpha k_t+(1-\alpha)h_t.
\]

- **(F19) 资本积累**：

\[
k_{t+1}=(1-\delta)k_t+\delta(\mu_t+i_t).
\]

- **(F20) 短期利率 Taylor 规则**：

\[
r_t=\rho r_{t-1}+(1-\rho)(\tau_\pi\pi_t+\tau_y y_t^{gap})+\epsilon_t^r.
\]

- **(F21) 市场分割楔子等于未来利差贴现和**：

\[
m_t=E_t\sum_{j=0}^{\infty}(\beta\kappa)^j\Xi_{t+j},
\qquad
\Xi_{t+j}\equiv\beta\kappa q_{t+j+1}-q_{t+j}-r_{t+j}\approx r_{t+j}^{L}-r_{t+j}.
\]

- **(F22) 预期假说债券价格**：

\[
r_t=E_t\frac{\kappa q_{t+1}^{EH}}{R_{ss}}-q_t^{EH}.
\]

- **(F23) 预期假说十年收益率**：

\[
r_t^{EH,10}=\left(\frac{R_{ss}-\kappa}{R_{ss}}\right)q_t^{EH}.
\]

- **(F24) 期限溢价定义**：

\[
tp_t=r_t^{10}-r_t^{EH,10}
=-\left(\frac{R_{ss}^{L}-\kappa}{R_{ss}^{L}}\right)q_t
+\left(\frac{R_{ss}-\kappa}{R_{ss}}\right)q_t^{EH}.
\]

- **(F25) `US_CFP17exo` 的外生长期债务政策规则**：

\[
b_t=\rho_1^b b_{t-1}+\rho_2^b b_{t-2}+\epsilon_t^b.
\]

- **(F26) 含期限溢价的 Taylor 规则，用于政策实验**：

\[
r_t=\rho r_{t-1}+(1-\rho)(\tau_\pi\pi_t+\tau_y y_t^{gap}+\tau_{tp}tp_t).
\]

- **(F27) 产出缺口定义**：

\[
y_t^{gap}=y_t-y_t^f.
\]

- **(F28) 灵活价格资源约束，实现交叉检查**：

\[
\frac{C_{ss}}{Y_{ss}}c_t^f+\frac{I_{ss}}{Y_{ss}}i_t^f=y_t^f.
\]

- **(F29) 灵活价格生产函数，实现交叉检查**：

\[
y_t^f=a_t+\alpha k_{t-1}^f+(1-\alpha)h_t^f.
\]

- **(F30) 年化观测量和利差，实现交叉检查**：

\[
ann\_\pi_t=4\pi_t,\qquad ann\_r1_t=4r_t,\qquad ann\_r2_t=4r_t^L,\qquad spread_t=ann\_r2_t-ann\_r1_t.
\]

## 5. Exogenous Processes

- **(F31) TFP 冲击**：

\[
a_t=\rho_Aa_{t-1}+\varepsilon_{a,t}.
\]

- **(F32) 信贷 / 金融摩擦冲击**：

\[
\phi_t=(1-\rho_\phi)\phi_{ss}+\rho_\phi\phi_{t-1}+\varepsilon_{\phi,t}.
\]

Rep-MMB 实现用 `u_psi` 表示线性信贷冲击状态：

\[
u_{\psi,t}=\rho_\phi u_{\psi,t-1}+\varepsilon_{\psi,t}.
\]

- **(F33) 投资冲击**：

\[
\log\mu_t=\rho_\mu\log\mu_{t-1}+\varepsilon_{\mu,t}.
\]

- **(F34) 自然利率 / 贴现冲击**：

\[
rn_t=\rho_{rn}rn_{t-1}+\varepsilon_{rn,t}.
\]

- **(F35) 价格和工资加成冲击，实现交叉检查**：

\[
mk_t=\rho_{mk}mk_{t-1}+\varepsilon_{mk,t},\qquad
mkw_t=\rho_{mkw}mkw_{t-1}+\varepsilon_{mkw,t}.
\]

## 6. Steady-State Solution

本归档记录论文中的稳态归一化和校准方程。由于 `US_CFP17exo` 实现为 `model(linear)`，Dynare 模型中的所有内生变量都是围绕该稳态的偏离，模拟稳态为零。

1. 归一化技术、投资效率和劳动：

\[
A_{ss}=1,\qquad \mu_{ss}=1,\qquad H_{ss}=1.
\]

2. 家庭边际效用和短期利率：

\[
\Lambda_{ss}=\frac{1-\beta h}{(1-h)C_{ss}},\qquad 1=\beta R_{ss}.
\]

3. 工资负效用参数：

\[
B=W_{ss}\Lambda_{ss}.
\]

4. 资本回报和分割楔子：

\[
R_{ss}^{k}=\frac{M_{ss}[1-\beta(1-\delta)]}{\beta},\qquad
M_{ss}=\frac{\beta}{(1-\beta\kappa)Q_{ss}^{I}}.
\]

5. 价格加成和边际成本：

\[
MC_{ss}=\frac{\epsilon_p-1}{\epsilon_p}.
\]

6. 资本-产出比：

\[
\frac{K_{ss}}{Y_{ss}}=
\frac{\beta\alpha MC_{ss}}{M_{ss}[1-\beta(1-\delta)]},
\qquad
K_{ss}=\left(\frac{K_{ss}}{Y_{ss}}\right)^{1/(1-\alpha)}.
\]

7. 产品市场稳态：

\[
I_{ss}=\delta K_{ss},\qquad C_{ss}=Y_{ss}-\delta K_{ss}.
\]

8. 中介与长期债券稳态：

\[
1=\beta\zeta R_{ss}^{L},\qquad Q=(R_{ss}^{L}-\kappa)^{-1},\qquad R_{ss}^{10}=R_{ss}^{L}.
\]

9. 论文报告的校准目标：

\[
\beta=0.99,\qquad \beta R_{ss}^{L}=1.0025,\qquad L_{ss}=6,\qquad
(1-\kappa)^{-1}=40,\qquad
\frac{\overline{B}_{ss}}{\overline{B}_{ss}+\overline{F}_{ss}}=0.40.
\]

稳态公式质量：`needs_review`。论文附录提供了公式，但若要提升到 reviewed 状态，若干 OCR 表达仍需对照 PDF 做来源级检查。

## 7. Timing & Form Conventions

- **形式**：线性化模型（`model(linear)`）；小写变量为相对非随机稳态的对数偏离或线性偏离。
- **预期**：论文在 log-linear 系统中显式写 \(E_t\)；`.mod` 交叉检查用 Dynare lead 编码。
- **资本时序**：论文线性化方程使用 \(k_{t+1}=(1-\delta)k_t+\delta(\mu_t+i_t)\)，Rep-MMB 文件移动了存量时点，使生产使用 `k(-1)`，资本积累写为 `k=(1-delta)*k(-1)+delta*(i+muinv)`。
- **长期债券时序**：中介资产回报依赖下一期债券价格，\(r_{t+1}^L=\kappa q_{t+1}/R_{ss}^L-q_t\)；实现中当期变量写为 `r2 = kappa*q(+1)/R2ss - q`。
- **变体约定**：`US_CFP17exo` 使用长期债券的外生债务规则。内生期限溢价 peg 是另一个概念政策制度，应归入 `US_CFP17endo`。
- **运行时验证**：未执行。Rep-MMB `.mod` 含有 `steady; check;` 和 `stoch_simul`，但本归档任务没有运行 Dynare。

## 8. Variable & Parameter Reference Table

| 类别 | 符号 / ASCII | 含义 | 主要方程 |
|---|---|---|---|
| 内生 | \(\lambda_t\) / `muc` | 消费边际效用 | (F1), (F5) |
| 内生 | \(c_t\) / `c` | 消费 | (F1), (F18) |
| 内生 | \(h_t\) / `L` | 工时 / 劳动投入 | (F2), (F18) |
| 内生 | \(mrs_t\) / `mrs` | 边际替代率 | (F2), (F3) |
| 内生 | \(w_t\) / `w` | 实际工资 | (F4), (F14) |
| 内生 | \(\pi_t^w\) / `pinw` | 工资通胀 | (F3), (F4) |
| 内生 | \(\pi_t\) / `pin` | 价格通胀 | (F3), (F4), (F16) |
| 内生 | \(r_t\) / `r1` | 短期名义政策 / 存款利率 | (F5), (F20), (F26) |
| 内生 | \(p_t^k\) / `pk` | 资本实际价格 | (F6), (F17) |
| 内生 | \(m_t\) / `m` | 市场分割楔子 | (F6), (F7), (F21) |
| 内生 | \(r_t^k\) / `rk` | 资本租金回报 | (F6), (F15) |
| 内生 | \(q_t\) / `q` | 长期债券价格 | (F7), (F9), (F10), (F24) |
| 内生 | \(f_t\) / `f` | 投资债券资产价值 | (F8), (F13) |
| 内生 | \(r_t^L\) / `r2` | 中介长期资产回报 | (F9), (F11), (F30) |
| 内生 | \(r_t^{10}\) / `r10` | 十年收益率 | (F10), (F24) |
| 内生 | \(l_t\) / `lev` | 杠杆 | (F11), (F13) |
| 内生 | \(n_t\) / `nw` | 中介净值 | (F12), (F13) |
| 内生 | \(mc_t\) / `mc` | 实际边际成本 | (F14), (F15), (F16) |
| 内生 | \(i_t\) / `i` | 投资 | (F8), (F17), (F18), (F19) |
| 内生 | \(y_t\) / `y` | 产出 | (F18), (F27) |
| 内生 | \(k_t\) / `k` | 资本存量 | (F18), (F19) |
| 内生 | \(q_t^{EH}\) / `qnat` | 预期假说债券价格 | (F22), (F23) |
| 内生 | \(tp_t\) / `term_prem` | 期限溢价 | (F24), (F26) |
| 内生 | \(b_t\) / `b2` | 金融中介持有的长期政府债券 | (F25) |
| 内生 | \(y_t^{gap}\) / `ygap` | 产出缺口 | (F20), (F27) |
| 内生 | flexible-price block / `cf`, `yf`, `kf`, etc. | 灵活价格对应变量 | (F28), (F29) |
| 外生 | \(\varepsilon_{a,t}\) / `eps_a` | TFP 创新 | (F31) |
| 外生 | \(\varepsilon_{\phi,t}\) / `eps_psi` | 信贷 / 金融摩擦创新 | (F32) |
| 外生 | \(\varepsilon_{\mu,t}\) / `eps_i` | 投资冲击创新 | (F33) |
| 外生 | \(\varepsilon_{rn,t}\) / `eps_rn` | 自然利率 / 贴现冲击创新 | (F34) |
| 外生 | \(\epsilon_t^r\) / `eps_mp` | 货币政策冲击创新 | (F20) |
| 外生 | \(\epsilon_t^b\) / `eps_b2` | 外生长期债务 / QE 创新 | (F25) |
| 外生 | \(\varepsilon_{mk,t}\) / `eps_mk` | 价格加成创新 | (F35) |
| 外生 | \(\varepsilon_{mkw,t}\) / `eps_mkw` | 工资加成创新 | (F35) |
| 参数 | `beta` | 家庭贴现因子 | 稳态 |
| 参数 | `h` | 习惯持久性 | (F1) |
| 参数 | `eta` | 劳动供给弹性倒数 | (F2) |
| 参数 | `alpha` | 资本份额 | (F18), (F29) |
| 参数 | `delta` | 折旧率 | (F6), (F19) |
| 参数 | `kappa`, `kappa_i` | 永续债衰减参数 / 久期 | (F7), (F9), (F22) |
| 参数 | `psi_i` | 投资调整成本 | (F17) |
| 参数 | `psi_n` | 净值调整成本 | (F12) |
| 参数 | `zeta` | FI 贴现楔子 | 稳态 |
| 参数 | `theta_p`, `theta_w` | Calvo 价格和工资不能重设概率 | (F3), (F16) |
| 参数 | `i_p`, `i_w` | 价格和工资指数化 | (F3), (F16) |
| 参数 | `rhoi`, `tau_pi`, `tau_y`, `tau_prem` | 短期利率规则系数 | (F20), (F26) |
| 参数 | `rho1_b`, `rho2_b` | 外生长期债务 AR 系数 | (F25) |
| 参数 | `rho_a`, `rho_phi`, `rho_mu`, `rho_rn`, `rhomk`, `rhomkw` | 冲击持久性参数 | (F31)-(F35) |
