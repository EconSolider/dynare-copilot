# ZLB-QE 模型 —— 推导（最优化问题 + 一阶条件）

> 本推导用于据此编写 Dynare `.mod`；**确认后再进入写代码阶段**。
> 题目：用债券市场分割 / 组合平衡（CCF12/PV16 风格）渠道，分析**零利率下限（ZLB）对量化宽松（QE）政策效果的影响**。

---

## 1. 模型概述

- **模型**：紧凑型新凯恩斯模型 + 组合平衡（portfolio-balance）型期限溢价 + QE。
  以 Chen-Curdia-Ferrero (2012, *Economic Journal*, "The Macroeconomic Effects of Large-Scale Asset Purchase Programmes") 的债券市场分割/组合平衡机制为蓝本（本地库 `US_CCF12_rep`），**蒸馏为可解析求稳态、可跑完全预见 lmmcp 的非线性紧凑版**——剥去习惯形成、工资黏性、产能利用率、两类价格制定者等枝节，只保留 QE 传导的骨架。
- **QE 传导渠道（核心）**：短债与长久期资产（长期债 + 资本）因市场分割而**不完全替代**，二者之间存在期限溢价 $\zeta_t$。央行 QE = 买入长期资产、压低私人部门长债持有 → $\zeta_t$ 下降 → 长久期资产要求回报下降 → 资本价格 $Q^k_t$ 上升 → 投资回升。**这是 CCF12 式 portfolio-balance 渠道**（对应其 D.23：$\zeta_t = \zeta'(\text{私人长债持有}) + \text{shock}$）。
- **实验**：完全预见（确定性）。一个**大的负向资本质量冲击**把自然利率压到 ZLB 之下，在三个情景下对比经济反应：
  - **情景①** 无 ZLB（短端利率可为负，常规利率政策不受约束）、无 QE —— 基准；
  - **情景②** ZLB 绑定（lmmcp 卡 $R_t\ge 1$）、无 QE —— 常规政策失效，衰退加深；
  - **情景③** ZLB 绑定 + QE 启动 —— QE 通过 $\zeta_t$ 填补政策缺口。
  三情景用宏处理器 `@#define` 切换，叠加 IRF。**直接回答："ZLB 使常规政策失效，正是此时 QE 才有用武之地。"**
- **主体**：代表性家庭（消费/劳动/持短债与长久期资产）、垄断竞争厂商（Rotemberg 价格黏性）、资本生产者（投资调整成本）、央行（短端 Taylor 规则 + ZLB + QE 规则）。
- **形式**：**非线性**（R8 默认）。ZLB 作为不等式约束天然非线性，完全预见 + lmmcp 正需要非线性原始方程；组合平衡的期限溢价写成结构关系而非约简线性式。

---

## 2. 各主体的最优化问题

### 2.1 家庭

代表性家庭持有**短期名义债券** $B_t$（一期，毛名义利率 $R_t$）与**长久期资产**（长期债 + 资本，实际回报 $R^L_{t+1}, R^k_{t+1}$）。市场分割 / 组合调整摩擦使长短资产不完全替代——在长久期资产的欧拉方程上体现为一个期限溢价楔子 $\zeta_t$（见 §3 说明）。效用：

$$\max_{\{C_t,N_t,B_t,\dots\}}\; E_0\sum_{t=0}^{\infty}\beta^t\Big[\frac{C_t^{1-\sigma}}{1-\sigma}-\chi\frac{N_t^{1+\varphi}}{1+\varphi}\Big]$$

预算约束（实际、含短债、长久期资产、工资、利润、资本租金）：

$$C_t + \frac{B_t}{P_t} + (\text{长久期资产购置}) \le \frac{R_{t-1}B_{t-1}}{P_t} + (\text{长久期资产回报}) + W_tN_t + \Pi^f_t$$

记 $\Lambda_t \equiv C_t^{-\sigma}$ 为消费边际效用，随机贴现因子 $\Lambda_{t,t+1}\equiv\beta\,\Lambda_{t+1}/\Lambda_t = \beta\,C_{t+1}^{-\sigma}/C_t^{-\sigma}$。

### 2.2 厂商（垄断竞争 + Rotemberg 价格黏性）

中间品厂商 $j$ 用有效资本 $\tilde K_t=\xi_t K_{t-1}$ 与劳动生产，面对需求 $Y_t(j)=(P_t(j)/P_t)^{-\epsilon}Y_t$，调价付二次成本 $\frac{\phi_p}{2}\big(\frac{P_t(j)}{P_{t-1}(j)}-1\big)^2 Y_t$。实际利润现值最大化：

$$\max\; E_0\sum_{t=0}^{\infty}\Lambda_{0,t}\Big[\big(\tfrac{P_t(j)}{P_t}-mc_t\big)\big(\tfrac{P_t(j)}{P_t}\big)^{-\epsilon}Y_t-\frac{\phi_p}{2}\big(\tfrac{P_t(j)}{P_{t-1}(j)}-1\big)^2 Y_t\Big]$$

成本最小化给出要素需求（$mc_t$ = 实际边际成本）。

### 2.3 资本生产者

由投资 $I_t$ 产出新资本，付投资调整成本 $\frac{\kappa_I}{2}\big(\frac{I_t}{I_{t-1}}-1\big)^2 I_t$，资本价格（Tobin's Q）$Q^k_t$。

---

## 3. 一阶条件（FOC）

> 关于期限溢价楔子 $\zeta_t$ 的处理：短债欧拉方程**不含** $\zeta_t$（短端是政策利率，由 ZLB 直接约束）；长久期资产（长期债、资本）的欧拉方程**含** $(1+\zeta_t)$ —— 正的 $\zeta_t$ 表示长资产须提供更高回报方被持有（价格更低、收益率更高）。$\zeta_t$ 由组合平衡关系 (F11) 决定，QE 通过它起作用。

- **(F1) 消费欧拉方程（短端，ZLB 约束的就是它）**：
$$C_t^{-\sigma}=\beta\,E_t\Big[C_{t+1}^{-\sigma}\,\frac{R_t}{\Pi_{t+1}}\Big]$$

- **(F2) 劳动供给**：
$$\chi N_t^{\varphi}=C_t^{-\sigma}\,W_t$$

- **(F3) 生产函数**（有效资本 $\xi_t K_{t-1}$）：
$$Y_t=(\xi_t K_{t-1})^{\alpha}N_t^{1-\alpha}$$

- **(F4) 资本租金（资本需求）**：
$$r^k_t=\alpha\,mc_t\,\frac{Y_t}{\xi_t K_{t-1}}$$

- **(F5) 劳动需求**：
$$W_t=(1-\alpha)\,mc_t\,\frac{Y_t}{N_t}$$

- **(F6) Rotemberg 新凯恩斯菲利普斯曲线**（$\Pi_{ss}=1$ 归一）：
$$\phi_p\,(\Pi_t-1)\Pi_t=(1-\epsilon)+\epsilon\,mc_t+\phi_p\,E_t\Big[\Lambda_{t,t+1}(\Pi_{t+1}-1)\Pi_{t+1}\frac{Y_{t+1}}{Y_t}\Big]$$

- **(F7) 资本积累**（含资本质量冲击 $\xi_t$ 与投资调整成本）：
$$K_t=(1-\delta)\xi_t K_{t-1}+\Big[1-\frac{\kappa_I}{2}\big(\tfrac{I_t}{I_{t-1}}-1\big)^2\Big]I_t$$

- **(F8) 投资 FOC（Tobin's Q）**：
$$1=Q^k_t\Big[1-\frac{\kappa_I}{2}\big(\tfrac{I_t}{I_{t-1}}-1\big)^2-\kappa_I\big(\tfrac{I_t}{I_{t-1}}-1\big)\tfrac{I_t}{I_{t-1}}\Big]+E_t\Big[\Lambda_{t,t+1}\,Q^k_{t+1}\,\kappa_I\big(\tfrac{I_{t+1}}{I_t}-1\big)\big(\tfrac{I_{t+1}}{I_t}\big)^2\Big]$$

- **(F9) 资本的实现回报**（$t-1\to t$，用 $Q^k_{t-1}$ 作分母）：
$$R^k_t=\frac{\xi_t\big[r^k_t+(1-\delta)Q^k_t\big]}{Q^k_{t-1}}$$

- **(F10) 资本欧拉方程（含期限溢价楔子）**：
$$1+\zeta_t=\beta\,E_t\Big[\frac{C_{t+1}^{-\sigma}}{C_t^{-\sigma}}\,R^k_{t+1}\Big]$$

- **(F11) 组合平衡 / 期限溢价**（QE 入口）：
$$\zeta_t=\bar\zeta-\zeta'\,qe_t$$
央行长债持有 $qe_t$↑ → 私人长债持有↓ → $\zeta_t$↓。$\zeta'>0$ 为组合平衡弹性。

- **(F12) 长端名义利率（期限溢价定义，报告用）**：
$$R^L_t=R_t\,(1+\zeta_t)$$

> **关于长端利率的实现说明**：最初设想用永续债（几何衰减票息 $\kappa_L$，价格 $Q^L_t$）显式定价，但其前瞻欧拉 + $Q^L_{t-1}$ 递归在完全预见下产生**奇异雅可比**（两个 $\sim 10^{51}$ 量级伪特征根，求解器失败）。由于该长债块**对实体经济不反馈**（QE 的需求渠道是资本/投资 (F10)，长债仅作报告），改用**静态恒等式** $R^L_t=R_t(1+\zeta_t)$：长端名义利率 = 短端名义利率复合期限溢价。这既消除奇异性，又恰好凸显 QE 故事——ZLB 下 $R_t$ 锁定在 1，长端利率只能通过 QE 压低 $\zeta_t$ 而下降。

---

## 4. 市场出清与总量恒等式

- **(F15) 资源约束**（Rotemberg 调价成本是实际资源损耗；无政府购买；QE 不耗资源）：
$$Y_t=C_t+I_t+\frac{\phi_p}{2}(\Pi_t-1)^2 Y_t$$

> **Walras 定律检查**：本模型的冗余方程是**家庭预算约束**。短债净供给为零（家庭间/与央行轧差），资本由家庭持有，厂商利润全额返还家庭；将家庭预算约束、厂商利润定义、央行/QE 账户三者相加并用各主体 FOC 替换，恰好退化为资源约束 (F15)。故**家庭预算约束冗余，不进 model 块**——否则方程数虚增一条、BK 必失败。QE 在本紧凑设定中以 (F11) 约简形式进入，不单列央行资产负债表账户（这是为可解析稳态作的显式建模取舍，机制等价于 CCF12 的 D.20+D.23）。

---

## 5. 外生过程与政策规则

- **(F16) 短端 Taylor 规则 + ZLB**（$R_{ss}=1/\beta$，$\Pi_{ss}=1$）：
$$R_t=R_{ss}\,\Pi_t^{\phi_\pi}\Big(\frac{Y_t}{Y_{ss}}\Big)^{\phi_y}\qquad\perp\qquad R_t\ge 1$$
情景①：去掉互补条件、允许 $R_t<1$；情景②③：lmmcp 卡 $R_t\ge1$。
（Dynare 残差 = LHS−RHS = $R_t-$规则；绑定时 $R_t=1$、规则值<1 → 残差>0，符合 lmmcp 下界要求。）

- **(F17) QE 规则**（央行长债持有；情景③启动，①②为 0）：
$$qe_t=\rho_{qe}\,qe_{t-1}+\phi_{qe}\,\frac{Y_{ss}-Y_t}{Y_{ss}}\qquad(\text{情景①②}:qe_t=0)$$
衰退（$Y_t<Y_{ss}$）→ 央行扩表买长债。

- **(F18) 资本质量冲击过程**（衰退驱动）：
$$\log\xi_t=\rho_\xi\,\log\xi_{t-1}+\varepsilon^\xi_t$$
$\varepsilon^\xi_t<0$ 的大冲击 → 有效资本与资本回报骤降 → 投资坍塌 → 自然利率转负 → ZLB 绑定。

---

## 6. 稳态求解（$\xi=1,\ qe=0,\ \Pi=1$；可自上而下照抄进 steady_state_model）

按以下次序逐个求值：

1. $\Pi=1,\quad R=1/\beta,\quad \zeta=\bar\zeta,\quad qe=0,\quad \xi=1$
2. 价格黏性 SS（F6，$\Pi=1$）：$mc=\dfrac{\epsilon-1}{\epsilon}$
3. 投资 SS（F8，$I/I_{-1}=1$）：$Q^k=1$
4. 资本回报（F10）：$R^k=\dfrac{1+\bar\zeta}{\beta}$
5. 租金（F9，$\xi=1,Q^k=1$）：$r^k=R^k-(1-\delta)=\dfrac{1+\bar\zeta}{\beta}-(1-\delta)$
6. 资本-产出比（F4）：$\dfrac{K}{Y}=\dfrac{\alpha\,mc}{r^k}$
7. 投资-产出比（F7，$\xi=1$）：$I=\delta K\Rightarrow \dfrac{I}{Y}=\delta\dfrac{K}{Y}$
8. 归一 $N=1$（反解 $\chi$）：由 $Y=K^\alpha N^{1-\alpha}=K^\alpha$ 与 $K=(K/Y)Y=(K/Y)K^\alpha$ 得
$$K=\Big(\frac{K}{Y}\Big)^{1/(1-\alpha)},\quad Y=K^\alpha,\quad I=\delta K,\quad C=Y-I$$
9. 工资（F5）：$W=(1-\alpha)mc\,Y/N=(1-\alpha)mc\,Y$
10. 反解偏好权重（F2）：$\chi=C^{-\sigma}W/N^{\varphi}=C^{-\sigma}W$
11. 长端利率（F12）：$R^L=R\,(1+\bar\zeta)=\dfrac{1+\bar\zeta}{\beta}$
12. 校验短端欧拉 (F1)：$1=\beta R/\Pi=\beta\cdot(1/\beta)/1=1$ ✓

> $R_{ss}=1/\beta>1$，稳态 ZLB 松弛 ✓。

---

## 7. 时序与形式约定

- **状态变量期末存量**：$K_t$ 是 $t$ 期末资本，生产用 $K_{t-1}$（F3 写 `K(-1)`）；$I_{t-1}$ 进调整成本；$Q^k_{t-1}$ 进 (F9) 实现回报；$qe_{t-1},\xi_{t-1}$ 进各自滞后项。
- **资本质量冲击** $\xi_t$ 同期乘 $K_{t-1}$ 得有效资本（F3、F4、F7、F9）。
- **利率时序**：$R_t$ 是 $t$ 期设定、$t\to t{+}1$ 兑现的毛名义利率，进 (F1) 的 `R`（当期）。
- **形式**：全非线性，让 Dynare 做泰勒展开（R8）；ZLB 用 `perfect_foresight_solver(lmmcp)` + 方程后挂 `⟂ R>1`。
- **求解**：完全预见，`perfect_foresight_setup`/`solver`；初/终值 = 无冲击稳态。

---

## 8. 变量与参数对照表

| 类别 | 符号(.mod) | 含义 | 由哪条方程定 |
|------|-----------|------|--------------|
| 内生 | `C` | 消费 | (F1) |
| 内生 | `N` | 劳动 | (F2) |
| 内生 | `Y` | 产出 | (F3) |
| 内生 | `mc` | 实际边际成本 | (F5) |
| 内生 | `W` | 实际工资 | (F4) 经因子需求；与(F5)联立 |
| 内生 | `rk` | 资本租金 | (F4) |
| 内生 | `Pi` | 毛通胀 | (F6) |
| 内生 | `K` | 资本（期末） | (F7) |
| 内生 | `I` | 投资 | (F8) |
| 内生 | `Qk` | 资本价格 Tobin Q | (F10) |
| 内生 | `Rk` | 资本实现回报 | (F9) |
| 内生 | `zeta` | 期限溢价 | (F11) |
| 内生 | `RL` | 长端毛名义利率 | (F12) |
| 内生 | `R` | 短端毛名义利率 | (F16) Taylor+ZLB |
| 内生 | `qe` | 央行长债持有(QE) | (F17) |
| 内生 | `xi` | 资本质量 | (F18) |
| 外生 | `eps_xi` | 资本质量创新 | — |
| 参数 | `betta,sigma,varphi,chi,alppha,delta` | 偏好/技术 | — |
| 参数 | `epsilon,phi_p` | 加成/Rotemberg 黏性 | — |
| 参数 | `kappa_I` | 投资调整成本 | — |
| 参数 | `zetabar,zeta_prime` | 稳态期限溢价/组合平衡弹性 | — |
| 参数 | `phi_pi,phi_y` | Taylor 系数 | — |
| 参数 | `rho_qe,phi_qe` | QE 规则 | — |
| 参数 | `rho_xi` | 资本质量持续性 | — |

**R4 核对（最终实现）**：内生变量 16 个（C,N,Y,mc,W,rk,Pi,K,I,Qk,Rk,zeta,RL,R,qe,xi），方程 16 条（F1–F12、F15–F18；长债块由原 F12–F14 三条简化为 F12 一条静态恒等式，故变量数与方程数各减 2）。家庭预算约束按 Walras 剔除。已跑通：稳态残差全 0、BK 秩条件验证、完全预见求解残差 $\sim10^{-10}$。

> **宏处理器切换**：`@#define ZLB`（0=情景①,1=②③）控制 (F16) 是否挂 `⟂`；`@#define QE`（0=①②,1=③）控制 (F17) 是 QE 规则还是 `qe=0`。三情景跑三次、叠加 IRF。

---

**确认要点（请审阅）**：
1. **QE 渠道定位**：QE 通过期限溢价 $\zeta_t$ 作用于**资本/投资**（长久期资产要求回报），而非单列家庭消费的长端欧拉——这是把 CCF12 两类家庭蒸馏为代表性家庭后最自然的需求渠道。接受否？
2. **期限溢价无独立冲击**：衰退由资本质量冲击单独驱动，$\zeta_t$ 仅随 QE 变动（无 QE 时恒为 $\bar\zeta$）。符合你"只用资本质量冲击"的选择。接受否？
3. **QE 规则**对产出缺口反应（$\phi_{qe}\cdot(Y_{ss}-Y)/Y_{ss}$），情景③启动。或你想要**固定规模**的一次性 QE（更贴近"LSAP 公告"）？
4. **价格黏性用 Rotemberg**（单条 NKPC、省辅助变量）替代 CCF12 的 Calvo。接受否？

确认（或指出要改的点）后，我进入阶段2 写 `.mod`，按三跑三锁增量验证。
