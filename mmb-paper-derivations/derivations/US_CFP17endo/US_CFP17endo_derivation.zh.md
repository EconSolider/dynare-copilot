# US_CFP17endo -- 推导（最优化问题 + 一阶条件）

> 用途：私有 MMB 推导档案条目，供后续 Dynare 审阅使用。
> 来源：Carlstrom, Fuerst, and Paustian (2017), "Targeting long rates in a model with segmented markets," American Economic Journal: Macroeconomics, DOI `10.1257/mac.20150179`。
> 状态：`needs_review`；基于 MinerU Markdown 的第一轮抽取。未执行运行时验证。

## 1. Model Overview

- **模型**：带金融中介、长期名义债券、通过长期投资债融资投资、价格和工资黏性的 segmented-markets Dynamic New Keynesian 模型。
- **MMB 变体**：`US_CFP17endo`。MMB 实现交叉检查显示该变体采用内生长期债务 / 期限溢价政策闭合：`term_prem = 0` 和 `term_premf = 0`。
- **主体**：家庭、就业中介、金融中介、最终品聚合者、垄断竞争中间品厂商、新资本生产者、货币当局和被动财政当局。
- **形式**：`model(linear)` / 对数线性化模型。论文先给出非线性原始结构，然后在对数线性系统中用小写变量表示对数偏离。MMB `.mod` 明确是线性化实现。
- **核心机制**：金融中介净值和 hold-up 约束限制短期存款利率与长期贷款利率之间的套利。由此产生的贷款-存款利差形成投资融资中的市场分割楔子。在内生债务制度下，央行调整长期债券持有量以钉住期限溢价。
- **来源记录**：主 Markdown `raw/mmb_mineru/runs/us_cfp17endo_us_cfp17exo__targeting_long_rates_in_a_model_with_segmented_markets__d8728772/full.md`；原始 PDF `raw/mmb_papers/Targeting long rates in a model with segmented markets.pdf`；MinerU run id `d8728772-c118-4e20-9cec-bcc6e7b742d5`；本地没有 appendix normalization 文件。

## 2. Optimization Problems

### 2.1 家庭

家庭选择消费、差异化劳动、短期存款、实物资本和投资债发行，并受到习惯偏好、工资黏性、资本积累以及投资的 loan-in-advance 融资约束限制。论文中的非线性记号为：

\[
\max E_0\sum_{s=0}^{\infty}\beta^s e^{rn_{t+s}}
\left\{\ln(C_{t+s}-hC_{t+s-1})-B\frac{H_{t+s}(j)^{1+\eta}}{1+\eta}\right\}.
\]

代表性家庭预算约束、资本法则和投资融资约束为：

\[
C_t+\frac{D_t}{P_t}+P_t^k I_t+\frac{F_{t-1}}{P_t}
\le W_tH_t+R_t^kK_t-T_t+\frac{D_{t-1}}{P_t}R_{t-1}
+\frac{Q_t(F_t-\kappa F_{t-1})}{P_t}+div_t.
\]

\[
K_{t+1}\le (1-\delta)K_t+I_t.
\]

\[
P_t^k I_t \le \frac{Q_t(F_t-\kappa F_{t-1})}{P_t}.
\]

永续投资债存量满足 \(CI_t=F_t-\kappa F_{t-1}\)。

### 2.2 工资设定

就业中介聚合差异化劳动：

\[
H_t=\left[\int_0^1 H_t(j)^{1/(1+\lambda_{w,t})}dj\right]^{1+\lambda_{w,t}}.
\]

在 Calvo 工资黏性下，不能重新优化的家庭按滞后通胀指数化名义工资；可以重新优化的家庭在就业中介劳动需求约束下选择工资，使贴现后的劳动收入扣除劳动负效用最大化。下方对数线性工资 Phillips 曲线概括该模块。

### 2.3 金融中介

金融中介用净值和短期存款持有投资债与长期政府债。其资产负债表为：

\[
\frac{B_t}{P_t}Q_t+\frac{F_t}{P_t}Q_t=\frac{D_t}{P_t}+N_t=L_tN_t.
\]

金融中介选择股利和下一期净值：

\[
V_t=\max_{N_t,div_t}E_t\sum_{j=0}^{\infty}(\beta\zeta)^j\Lambda_{t+j}div_{t+j},
\]

并满足

\[
div_t+N_t[1+f(N_t)]\le
\frac{P_{t-1}}{P_t}\left[(R_t^L-R_{t-1}^d)L_{t-1}+R_{t-1}^d\right]N_{t-1},
\]

其中 \(f(N_t)=\frac{\psi_n}{2}\left(\frac{N_t-N_{ss}}{N_{ss}}\right)^2\)。

### 2.4 厂商与资本生产者

最终品厂商用 CES 技术聚合差异化中间品。中间品厂商使用 Cobb-Douglas 生产函数，

\[
Y_t(i)=A_tK_t(i)^\alpha H_t(i)^{1-\alpha},
\]

并面对带指数化的 Calvo 价格黏性。新资本生产者把投资品转化为资本，并有调整成本：

\[
P_t^k\mu_t\left[1-S\left(\frac{I_t}{I_{t-1}}\right)\right]I_t-I_t,
\qquad
S\left(\frac{I_t}{I_{t-1}}\right)=\frac{\psi_i}{2}\left(\frac{I_t}{I_{t-1}}-1\right)^2.
\]

### 2.5 政策当局

货币当局用利率规则设定短期利率。在内生债务变体中，长期债券供给内生，并通过钉住期限溢价来闭合长期债务市场。财政政策是被动的：政府支出为零，一次总付税用于支持债务支付。

## 3. First-Order Conditions

以下编号方程是模型档案的第一轮规范化。论文的对数线性模型用小写变量表示相对稳态的偏离；保留论文中的期望算子。部分 OCR 符号，尤其是 \(\psi_n n_t\) 和 \(\nu\) 附近，需要源级复核后才能从 `needs_review` 提升。

**家庭模块**

**(F1) 消费边际效用**：

\[
\lambda_t=
\frac{1}{(1-\beta h)(1-h)}E_t\left[\beta h c_{t+1}-(1+\beta h^2)c_t+h c_{t-1}\right]
+\frac{1}{1-\beta h}(rn_t-\beta h E_t rn_{t+1}).
\]

**(F2) 边际替代率**：

\[
rn_t+\eta h_t-\lambda_t=mrs_t.
\]

**(F3) 工资 Phillips 曲线**：

\[
\pi_t^w-\iota_w\pi_{t-1}
=\kappa_w(mrs_t-w_t)+\beta(\pi_{t+1}^w-\iota_w\pi_t)+\epsilon_t^w.
\]

**(F4) 实际工资累积**：

\[
w_t=w_{t-1}+\pi_t^w-\pi_t.
\]

**(F5) 存款 Fisher/Euler 方程**：

\[
\lambda_t=E_t\lambda_{t+1}+r_t-E_t\pi_{t+1}.
\]

**(F6) 带市场分割楔子的资本 Euler 方程**：

\[
\lambda_t+p_t^k+m_t
=E_t\left\{\lambda_{t+1}+[1-\beta(1-\delta)]r_{t+1}^k
+\beta(1-\delta)(p_{t+1}^k+m_{t+1})\right\}.
\]

**(F7) 投资债 Euler 方程**：

\[
\lambda_t+q_t+m_t=E_t\lambda_{t+1}-E_t\pi_{t+1}
+\beta\kappa E_t(q_{t+1}+m_{t+1}).
\]

**(F8) 投资债发行关系**：

\[
(1-\kappa)(p_t^k+i_t)=f_t-\kappa(f_{t-1}+q_t-q_{t-1}-\pi_t).
\]

**金融中介与期限结构模块**

**(F9) 金融中介长期资产组合回报**：

\[
r_{t+1}^L=\frac{\kappa q_{t+1}}{R_{ss}^L}-q_t.
\]

**(F10) 由长期债券价格得到十年期收益率**：

\[
r_t^{10}=-\left(\frac{R_{ss}^L-\kappa}{R_{ss}^L}\right)q_t.
\]

**(F11) Hold-up / 杠杆利差条件**：

\[
E_t(r_{t+1}^L-r_t)
=\left(\frac{1}{L_{ss}-1}\right)l_t
+\left[\frac{1+(s-1)L_{ss}}{L_{ss}-1}\right]\phi_t.
\]

**(F12) 净值调整条件**（`needs_review` OCR 规范化）：

\[
\psi_n n_t=
\left[\frac{sL_{ss}}{1+L_{ss}(s-1)}\right]E_t(r_{t+1}^L-r_t)
+\left[\frac{(s-1)L_{ss}}{1+L_{ss}(s-1)}\right]l_t.
\]

**(F13) 金融中介资产负债表组成**：

\[
\frac{\overline{B}_{ss}}{L_{ss}N_{ss}}b_t+
\left(1-\frac{\overline{B}_{ss}}{L_{ss}N_{ss}}\right)f_t
=n_t+l_t.
\]

**生产、定价与投资供给**

**(F14) 实际工资等于边际成本加劳动边际产出**：

\[
w_t=mc_t+mpl_t.
\]

**(F15) 资本租金等于边际成本加资本边际产出**：

\[
r_t^k=mc_t+mpk_t.
\]

**(F16) 价格 Phillips 曲线**：

\[
\pi_t=\frac{\kappa_\pi}{1+\beta\iota_p}mc_t
+\frac{\beta}{1+\beta\iota_p}E_t\pi_{t+1}
+\frac{\iota_p}{1+\beta\iota_p}\pi_{t-1}
+\epsilon_t^p.
\]

**(F17) 投资供给 / 资本价格**：

\[
p_t^k=\psi_i\left[(i_t-i_{t-1})-\beta E_t(i_{t+1}-i_t)\right]-\mu_t.
\]

**(F18) 资源 / 会计恒等式**：

\[
\left(1-\frac{I_{ss}}{Y_{ss}}\right)c_t+\frac{I_{ss}}{Y_{ss}}i_t
=a_t+\alpha k_t+(1-\alpha)h_t.
\]

**(F19) 资本积累**：

\[
k_{t+1}=(1-\delta)k_t+\delta(\mu_t+i_t).
\]

**政策与期限溢价定义**

**(F20) 短期利率 Taylor 规则**：

\[
r_t=\rho r_{t-1}+(1-\rho)(\tau_\pi\pi_t+\tau_y y_t^{gap})+\epsilon_t^r.
\]

**(F21) 市场分割楔子为贴现后的贷款-存款利差**：

\[
m_t=E_t\sum_{j=0}^{\infty}(\beta\kappa)^j\Xi_{t+j},
\qquad
\Xi_{t+j}\equiv \beta\kappa q_{t+j+1}-q_{t+j}-r_{t+j}\approx r_{t+j}^L-r_{t+j}.
\]

**(F22) 预期假说债券价格**：

\[
r_t=E_t\frac{\kappa q_{t+1}^{EH}}{R_{ss}}-q_t^{EH}.
\]

**(F23) 预期假说十年期收益率**：

\[
r_t^{EH,10}=\left(\frac{R_{ss}-\kappa}{R_{ss}}\right)q_t^{EH}.
\]

**(F24) 期限溢价定义**：

\[
tp_t=r_t^{10}-r_t^{EH,10}
=-\left(\frac{R_{ss}^L-\kappa}{R_{ss}^L}\right)q_t
+\left(\frac{R_{ss}-\kappa}{R_{ss}}\right)q_t^{EH}.
\]

**(F25) 外生债务政策，非 `US_CFP17endo` 闭合**：

\[
b_t=\rho_1^b b_{t-1}+\rho_2^b b_{t-2}+\epsilon_t^b.
\]

**(F26) 带期限溢价的 Taylor 规则，替代政策**：

\[
r_t=\rho r_{t-1}+(1-\rho)(\tau_\pi\pi_t+\tau_y y_t^{gap}+\tau_{tp}tp_t).
\]

**(F27) `US_CFP17endo` 的内生债务闭合**：

\[
tp_t=0.
\]

## 4. Market Clearing & Identities

最终品会计恒等式嵌入 (F18)。论文在替代生产函数后把它写成对数线性资源恒等式：

\[
\left(1-\frac{I_{ss}}{Y_{ss}}\right)c_t+\frac{I_{ss}}{Y_{ss}}i_t=y_t,
\qquad
y_t=a_t+\alpha k_t+(1-\alpha)h_t.
\]

金融中介资产负债表为 (F13)，长期政府债和投资债的实际资产价值在净值和杠杆之间分配。投资债存量递推式为 (F8)。短期政府债与存款完全替代，并内生调整以支持短期利率目标，因此不是对数线性核心中的独立市场出清方程。在 `US_CFP17endo` 中，长期债券供给内生：(F27) 替代外生债务过程 (F25)，而 (F13) 决定所需的长期债券变动。

## 5. Exogenous Processes

论文侧 Markdown 明确给出以下随机过程：

**(F28) 贴现因子冲击**：

\[
rn_t=\rho_{rn}rn_{t-1}+\varepsilon_{rn,t}.
\]

**(F29) 工资加成冲击**：

\[
\log\lambda_{w,t}=(1-\rho_w)\log\lambda_w+\rho_w\log\lambda_{w,t-1}
+\varepsilon_{w,t}-\theta_w\varepsilon_{w,t-1}.
\]

**(F30) 技术冲击**：

\[
\ln A_t=\rho_A\ln A_{t-1}+\varepsilon_{a,t}.
\]

**(F31) 投资冲击**：

\[
\log\mu_t=\rho_\mu\log\mu_{t-1}+\varepsilon_{\mu,t}.
\]

**(F32) 金融摩擦 / 信用冲击**：

\[
\phi_t=(1-\rho_\phi)\phi_{ss}+\rho_\phi\phi_{t-1}+\varepsilon_{\phi,t}.
\]

**(F33) 货币政策冲击**：

\[
\epsilon_t^r=\rho_r\epsilon_{t-1}^r+\varepsilon_{r,t}
\]

其中论文把政策残差描述为自相关过程。MMB 实现交叉检查把创新项映射为 `eps_a`, `eps_mp`, `eps_i`, `eps_psi`, `eps_mk`, `eps_mkw`, `eps_b2`, `eps_rn`。

## 6. Steady-State Solution

由于 MMB 实现是对数线性模型，以偏离表示的变量局部稳态为零：

\[
\bar c=\bar i=\bar y=\bar k=\bar h=\bar q=\bar n=\bar l=\bar m=\bar \pi=\bar r-\bar r_{ss}=0.
\]

构造对数线性系数所需的非线性校准目标为：

1. 设季度贴现因子 \(\beta=0.99\)。
2. 设生产参数 \(\alpha=0.33\) 和 \(\delta=0.025\)。
3. 设价格和工资替代弹性，使价格与工资加成为 20%。
4. 通过 \(\zeta\) 和 \(\Phi_{ss}\) 匹配年化 100 个基点的稳态期限溢价和 \(L_{ss}=6\) 的杠杆：

\[
\zeta=\left(\frac{R_{ss}^{10}}{R_{ss}^{10,EH}}\right)^{-1},
\qquad
L_{ss}=\left[1+(\Phi_{ss}-1)\left(\frac{R_{ss}^{10}}{R_{ss}^{10,EH}}\right)\right]^{-1}.
\]

5. 设置长期债券久期为 40 个季度：

\[
(1-\kappa)^{-1}=40.
\]

6. 设置长期政府证券占金融中介资产的 40%：

\[
\frac{\overline B_{ss}}{\overline B_{ss}+\overline F_{ss}}=0.40.
\]

对 `US_CFP17endo`，政策稳态还满足偏离意义下的 \(\bar{tp}=0\)。具体参数值由 `.mod` 从 `parameterfile` 载入；未执行运行时验证或稳态数值检查。

## 7. Timing & Form Conventions

- **形式**：对数线性化 `model(linear)` 风格，小写变量表示相对稳态的偏离。MMB `.mod` 同时包含黏性价格变量和带 `f` 后缀的弹性价格对应变量。
- **资本时序**：论文把非线性资本积累写作 \(K_{t+1}=(1-\delta)K_t+I_t\)，把对数线性资本积累写作 \(k_{t+1}=(1-\delta)k_t+\delta(\mu_t+i_t)\)。`.mod` 用 `k(-1)` 进入当期生产，并写作 `k = (1-delta)*k(-1)+delta*(i+muinv)`，所以 `k` 是可用于下一期生产的预定存量。
- **债券时序**：永续债价格 \(Q_t\) 是第 \(t\) 期新发行债券的价格；\(F_t\) 是投资债义务存量，\(F_t-\kappa F_{t-1}\) 是新发行量。贷款回报使用下一期债券价格，\(r_{t+1}^L=\kappa q_{t+1}/R_{ss}^L-q_t\)。
- **内生债务约定**：`US_CFP17endo` 钉住期限溢价。长期政府债数量通过金融中介资产负债表恒等式内生调整，而短期利率规则继续设定存款 / T-bill 利率。
- **实现交叉检查**：`.agents/skills/dynare-copilot/references/examples/US_CFP17endo_rep.mod` 确认变量名、冲击和内生闭合，但它不是论文侧数学来源。

## 8. Variable & Parameter Reference Table

### 内生变量

| 符号 / ASCII | 含义 | 主要决定方程 |
|---|---|---|
| `muc`, \(\lambda_t\) | 消费边际效用 | (F1) |
| `mrs` | 边际替代率 | (F2) |
| `pinw` | 工资通胀 | (F3) |
| `w` | 实际工资 | (F4), (F14) |
| `r1`, \(r_t\) | 短期名义 / 存款利率 | (F5), (F20) |
| `pk` | 实际资本价格 | (F6), (F17) |
| `m` | 市场分割楔子 | (F6), (F7), (F21) |
| `q`, `qi` | 长期债券 / 投资债价格 | (F7), (F9), (F10) |
| `f` | 投资债存量 / 价值 | (F8), (F13) |
| `r2`, \(r^L\) | 金融中介长期资产回报 | (F9) |
| `r10` | 观测十年期收益率 | (F10) |
| `lev` | 杠杆 | (F11), (F13) |
| `nw` | 金融中介净值 | (F12), (F13) |
| `mc` | 实际边际成本 | (F14)-(F16) |
| `rk` | 资本租金 | (F15) |
| `pin` | 价格通胀 | (F16) |
| `i` | 投资 | (F17)-(F19) |
| `c` | 消费 | (F18) |
| `y` | 产出 | (F18) |
| `k` | 资本存量 | (F19) |
| `qnat`, `r10_nat` | 预期假说债券价格和收益率 | (F22)-(F24) |
| `term_prem` | 期限溢价 | (F24), (F27) |
| `b2`, `bb2` | 长期政府债 / QE 政策变量 | (F13), (F25), (F27) |
| `ygap` | 产出缺口 | (F20) |

### 外生冲击

| ASCII | 含义 |
|---|---|
| `eps_a` | 技术创新 |
| `eps_mp` | 货币政策创新 |
| `eps_i` | 投资专有技术创新 |
| `eps_psi` | 金融摩擦 / 信用创新 |
| `eps_mk` | 价格加成创新 |
| `eps_mkw` | 工资加成创新 |
| `eps_b2` | 外生长期债 / QE 创新；在期限溢价钉住下主要作为实现变量 |
| `eps_rn` | 贴现因子 / 自然利率创新 |

### 参数

| ASCII / symbol | 含义 |
|---|---|
| `alpha`, \(\alpha\) | 资本份额 |
| `beta`, \(\beta\) | 贴现因子 |
| `delta`, \(\delta\) | 折旧率 |
| `eta`, \(\eta\) | 劳动负效用曲率 |
| `gamma`, 与 \(L_{ss}\) 相关的校准 | 实现中的杠杆 / 金融中介资产负债表稳态参数 |
| `h` | 习惯参数 |
| `kappa`, \(\kappa\) | 长期政府债永续衰减参数 |
| `kappa_i` | 投资债永续衰减参数 |
| `psi_i` | 投资调整成本 |
| `psi_n` | 金融中介净值调整成本 |
| `zeta`, \(\zeta\) | 金融中介耐心楔子 |
| `tau_pi`, `tau_y`, `tau_prem` | Taylor 规则反应系数 |
| `rho_a`, `rho_phi`, `rho_mu`, `rho_rn`, `rho_m` | 冲击持续性参数 |
| `theta_p`, `theta_w` | Calvo 价格和工资不可重设概率 |
| `i_p`, `i_w` | 价格和工资指数化参数 |
| `kappapc`, `kappaw` | Phillips 曲线斜率 |
| `Y_ss`, `I_ss`, `C_ss`, `R1ss`, `R2ss`, `nwss`, `premss` | `.mod` 使用的稳态缩放常数 |
