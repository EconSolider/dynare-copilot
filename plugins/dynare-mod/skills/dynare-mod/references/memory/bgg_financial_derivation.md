# BGG 金融摩擦比较模型 —— 推导（最优化问题 + 一阶条件）

> 本推导用于据此编写 Dynare .mod；确认后再进入写代码阶段。  
> 来源：Bernanke, Gertler & Gilchrist (1999), "The Financial Accelerator in a Quantitative Business Cycle Framework", *Handbook of Macroeconomics*  
> 比较实验：`@#define WITH_FA = 1`（含 BGG 金融摩擦）vs `WITH_FA = 0`（无摩擦标准 NK）

---

## 1. 模型概述

- **模型**：小型闭合经济 NK-BGG，参照 Bernanke-Gertler-Gilchrist (1999) 金融加速器框架。
- **实验**：随机模拟（`stoch_simul, order=1`）；单文件 `@#define WITH_FA` 开关切换有/无金融摩擦两情形；观察货币政策冲击（MP shock）和 TFP 冲击下产出、通胀、投资、外部融资溢价的 IRF，比较两情形下货币政策传导差异。
- **主体**：
  - **代表性家庭**：CRRA 效用，选择消费 / 劳动 / 债券；不直接持有资本。
  - **企业家（Entrepreneurs）**：以杠杆方式购置资本，向金融中介借款；代理成本（CSV 最优合约）产生**外部融资溢价**；每期以概率 $(1-\gamma)$ "死亡"并消费净值。
  - **资本品生产商**（Capital Goods Producers）：面对投资调整成本，最优化给出 Tobin's $Q$。
  - **零售商 / 中间品厂商**：Calvo 黏性价格，CES 差异化产品。
  - **中央银行**：含利率平滑的 Taylor 规则。
  - **政府**：外生 AR(1) 支出，李嘉图财政（$T_t = G_t$，债券净供给为零）。
- **形式**：非线性（R8），Dynare 做一阶泰勒展开；**禁止手推线性化**。

---

## 2. 主体的最优化问题

### 2.1 代表性家庭

$$\max_{\{C_t,\,N_t,\,B_t\}}\;E_0\sum_{t=0}^{\infty}\beta^t
\left[\frac{C_t^{1-\sigma}-1}{1-\sigma} - \psi\frac{N_t^{1+\varphi}}{1+\varphi}\right]$$

**预算约束**（实际项，$R^n_t$ 为名义毛利率，$\Pi_t \equiv P_t/P_{t-1}$ 为毛通胀，$W_t$ 为实际工资，$T_t$ 为一次总付税）：

$$C_t + \frac{B_t}{R^n_t / \Pi_{t+1}^e} = W_t N_t + B_{t-1} + \Pi_t^{div} - T_t$$

简化为等价形式（用实际利率 $R_t \equiv R^n_t / E_t[\Pi_{t+1}]$，债券期末清零 $B_t=0$ by Walras）：

$$C_t = W_t N_t + \text{转移}$$

家庭**不拥有资本**——资本由企业家持有。

### 2.2 企业家（Entrepreneurs）

每个企业家在 $t$ 期末以净值 $N_t$ 为本金、向银行借款 $Q_t K_t - N_t$，购置资本 $K_t$（价格 $Q_t$）。

**CSV 最优合约**（costly state verification）：银行以审计成本 $\mu$ 核实企业家的特质冲击，最优合约产生**外部融资溢价**：

$$E_t\big[R^k_{t+1}\big] = \Psi\!\left(\frac{Q_t K_t}{N_t}\right) \cdot R_t$$

其中 $\Psi(\cdot) > 1$（杠杆越高溢价越大），参数化为 $\Psi(x) = x^{\chi}$（$\chi > 0$）。这是 CSV 最优合约的简约形式，直接从 BGG (1999) 附录 B 的均衡条件简化而来。

**净值演化**（存活企业家 $\gamma$ 比例保留净值，$(1-\gamma)$ "死亡"并消费）：

定义企业家持有资本的**总权益** $V_t$：

$$V_t = R^k_t \cdot Q_{t-1}K_{t-1} - R_{t-1}\cdot(Q_{t-1}K_{t-1} - N_{t-1})
= (R^k_t - R_{t-1})\cdot Q_{t-1}K_{t-1} + R_{t-1}\cdot N_{t-1}$$

$$N_t = \gamma \cdot V_t + \bar{W}^e, \qquad C^e_t = (1-\gamma)\cdot V_t$$

其中 $\bar{W}^e$ 为企业家的少量劳动禀赋收入（维持参与约束；稳态时为小量）。

### 2.3 资本品生产商（Capital Goods Producers）

购入最终品作为投资 $I_t$，以调整成本技术将其转化为新资本 $I^{net}_t$，卖给企业家获价 $Q_t$。

最大化利润：$Q_t I_t^{net} - I_t$，其中 $I_t^{net} = I_t \cdot\big[1 - \tfrac{\phi_k}{2}(I_t/I_{t-1}-1)^2\big]$。

FOC 对 $I_t$（令 $s \equiv I_t/I_{t-1}$，$S(s)=\tfrac{\phi_k}{2}(s-1)^2$，$S'(s)=\phi_k(s-1)$）得：

$$Q_t = \frac{1}{1 - S(s_t) - S'(s_t)\cdot s_t} + \beta\, E_t\!\left[\frac{u_{t+1}}{u_t}\cdot Q_{t+1}\cdot S'(s_{t+1})\cdot s_{t+1}^2\right]$$

等价的**简化非线性 Q 方程**（保留到一阶）：

$$1 = Q_t\cdot\Big[1 - \tfrac{\phi_k}{2}(s_t-1)^2 - \phi_k(s_t-1)\cdot s_t\Big]
+ \beta\,E_t\!\left[\frac{C_{t+1}^{-\sigma}}{C_t^{-\sigma}}\cdot Q_{t+1}\cdot \phi_k(s_{t+1}-1)\cdot s_{t+1}^2\right]$$

（此即进入 model 块的 Tobin's Q FOC，非线性形式。）

### 2.4 中间品厂商（Calvo 定价）

**成本最小化**（给定 $W_t$、$R^k_t$）——通过要素比条件得实际边际成本：

$$MC_t = \frac{1}{A_t}\left(\frac{R^k_t}{\alpha}\right)^{\alpha}\left(\frac{W_t}{1-\alpha}\right)^{1-\alpha}$$

即由资本要素定价条件：$R^k_t = \alpha \cdot MC_t \cdot Y_t / K_{t-1}$（结合劳动市场清零，见 §3 F3）。

**Calvo 最优定价**（概率 $\theta$ 无法调价）：最大化预期折现利润，FOC 整理为两个递归辅助变量：

$$x_{1,t} = C_t^{-\sigma}\cdot MC_t \cdot Y_t + \theta\beta\,E_t\!\left[\Pi_{t+1}^{\varepsilon}\,x_{1,t+1}\right]$$

$$x_{2,t} = C_t^{-\sigma}\cdot Y_t + \theta\beta\,E_t\!\left[\Pi_{t+1}^{\varepsilon-1}\,x_{2,t+1}\right]$$

**最优重定价**：

$$\frac{P^*_t}{P_t} = \frac{\varepsilon}{\varepsilon-1}\cdot\frac{x_{1,t}}{x_{2,t}}$$

---

## 3. 一阶条件（FOC）

> 连续编号 F1–F20，贯穿第3–5节。每条 FOC 对应 .mod 中一条方程（`[name=]` 回指）。

**家庭**

**(F1) 欧拉方程**（消费跨期选择）：

$$C_t^{-\sigma} = \beta\cdot\frac{R^n_t}{E_t[\Pi_{t+1}]}\cdot E_t\!\left[C_{t+1}^{-\sigma}\right]$$

或等价地（用 $R_t = R^n_t / \Pi_{t+1}$）：$C_t^{-\sigma} = \beta R_t \,E_t[C_{t+1}^{-\sigma}]$

**(F2) 劳动市场均衡**（家庭 MRS = 厂商劳动需求，合并为一条）：

$$\psi N_t^{\varphi} C_t^{\sigma} = MC_t \cdot \frac{(1-\alpha)Y_t}{N_t}$$

（左边为家庭劳动供给边际成本；右边为厂商实际工资 $W_t = MC_t \cdot (1-\alpha) Y_t / N_t$）

**资本与投资**

**(F3) 资本回报率**（企业家持有资本的总毛回报，由期末资本价格和租金决定）：

$$R^k_t = \frac{MC_t\cdot\alpha\cdot Y_t / K_{t-1} + (1-\delta)\cdot Q_t}{Q_{t-1}}$$

**(F4) 资本套利条件 / 外部融资溢价**（企业家的资本需求方程，前瞻）：

$$E_t\big[R^k_{t+1}\big] = \text{premium}_t \cdot R_t$$

即 Dynare 中：`rk(+1) = premium * r;`

**(F5) Tobin's Q（资本品生产商 FOC，简化形式）**：

令 $s_t \equiv I_t / I_{t-1}$，

$$1 = Q_t\Bigl[1 - \tfrac{\phi_k}{2}(s_t-1)^2 - \phi_k(s_t-1)s_t\Bigr]
+ \beta\,E_t\!\left[\frac{C_{t+1}^{-\sigma}}{C_t^{-\sigma}}\cdot Q_{t+1}\cdot\phi_k(s_{t+1}-1)\cdot s_{t+1}^2\right]$$

**(F6) 资本积累**（期末存量，R2）：

$$K_t = (1-\delta)K_{t-1} + \Bigl[1 - \tfrac{\phi_k}{2}(s_t-1)^2\Bigr] I_t$$

**金融摩擦块（@#define WITH_FA 切换）**

> 以下两条方程在两情形下不同：

**(F7) 净值演化**

| 情形 | 方程 |
|------|------|
| **WITH_FA = 1**（金融摩擦） | $N_t = \gamma\bigl[(R^k_t - R_{t-1})\,Q_{t-1}K_{t-1} + R_{t-1} N_{t-1}\bigr] + \bar{W}^e$ |
| **WITH_FA = 0**（无摩擦） | $N_t = Q_t K_t$（企业家完全股权融资，净值 = 资本总价值）|

**(F8) 外部融资溢价定义**

| 情形 | 方程 |
|------|------|
| **WITH_FA = 1** | $\text{premium}_t = \left(\dfrac{Q_t K_t}{N_t}\right)^{\chi}$（杠杆越高溢价越大）|
| **WITH_FA = 0** | $\text{premium}_t = 1$（无溢价）|

**(F9) 企业家消费**：

$$C^e_t = (1-\gamma)\bigl[(R^k_t - R_{t-1})\,Q_{t-1}K_{t-1} + R_{t-1}N_{t-1}\bigr]$$

（两情形相同；在 WITH_FA = 0 时 premium = 1 使 $R^k = R$，故 $C^e$ 对称地简化为 0 附近的小量，但方程形式不变以保证 R4。）

**生产与价格**

**(F10) 生产函数**（含 Calvo 价格分散度 $\Delta_t$，将总要素投入膨胀）：

$$Y_t \cdot \Delta_t = A_t \cdot K_{t-1}^{\alpha} \cdot N_t^{1-\alpha}$$

**(F11) Calvo 递归式 $x_{1}$**：

$$x_{1,t} = C_t^{-\sigma}\cdot MC_t \cdot Y_t + \theta\beta\,E_t\!\left[\Pi_{t+1}^{\varepsilon}\,x_{1,t+1}\right]$$

**(F12) Calvo 递归式 $x_{2}$**：

$$x_{2,t} = C_t^{-\sigma}\cdot Y_t + \theta\beta\,E_t\!\left[\Pi_{t+1}^{\varepsilon-1}\,x_{2,t+1}\right]$$

**(F13) 最优重定价**：

$$\frac{P^*_t}{P_t} = \frac{\varepsilon}{\varepsilon-1}\cdot\frac{x_{1,t}}{x_{2,t}}$$

**(F14) 价格指数演化**（Calvo 抽取规则）：

$$1 = \theta\,\Pi_t^{\varepsilon-1} + (1-\theta)\left(\frac{P^*_t}{P_t}\right)^{1-\varepsilon}$$

**(F15) 价格分散度演化**：

$$\Delta_t = (1-\theta)\left(\frac{P^*_t}{P_t}\right)^{-\varepsilon} + \theta\,\Pi_t^{\varepsilon}\,\Delta_{t-1}$$

**货币当局与政府**

**(F16) 费雪方程**：

$$R^n_t = R_t \cdot \Pi_{t+1}$$

（Dynare 写法：`rn = r * pi(+1);`）

**(F17) 泰勒规则**（名义利率，含平滑 $\rho_R$）：

$$\frac{R^n_t}{R^n} = \left(\frac{R^n_{t-1}}{R^n}\right)^{\rho_R}\!\cdot
\left[\left(\frac{\Pi_t}{\Pi}\right)^{\phi_\pi}\!\left(\frac{Y_t}{Y}\right)^{\phi_y}\right]^{1-\rho_R}\!\cdot e^{\varepsilon^m_t}$$

---

## 4. 市场出清与总量恒等式

**(F18) 资源约束**（Walras 定律：债券市场出清 $B_t=0$ 已由家庭预算 + 政府预算隐含，**不单列**，删去冗余方程）：

$$Y_t = C_t + I_t + G_t + C^e_t$$

> **Walras 定律检查**：家庭预算 $C_t = W_t N_t - T_t$，政府预算 $G_t = T_t$，企业家净值分配 $C^e + \Delta NW = R^k \cdot QK - R\cdot (QK - NW_{-1}) + \bar{W}^e$，厂商利润分配（$MC \cdot Y - W \cdot N - R^k_{\text{rental}}\cdot K$）在 CRS 下为零（Calvo 调整成本用于 CY 中）。将所有预算加总 + 产品市场出清 → 债券市场 $B_t=0$ 自动满足。**冗余方程：债券/资产市场出清（已删，不进 model 块）。**

---

## 5. 外生过程

**(F19) TFP 冲击**（AR(1)，稳态 $\bar{A}=1$）：

$$\log A_t = \rho_a \log A_{t-1} + \varepsilon^a_t$$

**(F20) 政府支出**（AR(1)，稳态 $G = \bar{g}_y \cdot \bar{Y}$）：

$$\log G_t = (1-\rho_g)\log\bar{G} + \rho_g \log G_{t-1} + \varepsilon^g_t$$

> 货币政策冲击 $\varepsilon^m_t$ 已嵌入 F17，`varexo` 只放三个创新：`eps_a, eps_g, eps_m`（R3）。

---

## 6. 稳态求解

稳态取 $X_t = X_{t+1} = \bar{X}$，$\Pi = 1$（零通胀目标），$\bar{A}=1$，$\Delta = 1$（零通胀下价格分散度为 1）。

**按如下顺序逐步求解**（可自上而下代入 `steady_state_model`）：

```
// 外生稳态
A_ss   = 1
G_ss   = gy_share * Y_ss  (反解，见下)
eps_*  = 0

// 利率与回报
R_ss   = 1/betta               // 由家庭欧拉 F1: C^{-σ}=β R C^{-σ}
Pi_ss  = 1
Rn_ss  = R_ss * Pi_ss = R_ss  // 费雪 F16

// 金融摩擦稳态（WITH_FA=1）
premium_ss = s_ss              // 校准目标，外部融资溢价约 1.005（季频 0.5%）
Rk_ss  = premium_ss * R_ss    // 资本套利 F4

// 资本—劳动比（由生产函数 + 资本回报）
// F3 稳态: Rk = (mc*α*Y/K + (1-δ)*Q) / Q，Q=1（稳态调整成本=0）
// → Rk = mc*α*Y/K + (1-δ)
// 定义 kl = K/N（资本劳动比），则：
mc_ss  = 1/X_ss = (ε-1)/ε     // 零利润稳态（CES，X=ε/(ε-1) 为加成倒数）
Rk_rental_ss = Rk_ss - (1-delta)  // 租金 = Rk - (1-δ) (Q=1 时)
kl_ss  = (alpha * mc_ss / Rk_rental_ss)^(1/(1-alpha))  // 从 Rk_rental = alpha*mc*(kl)^{α-1}

// 工资（稳态），见劳动市场 F2
W_ss   = (1-alpha) * mc_ss / (kl_ss)^(-alpha) = (1-alpha)*mc_ss*(kl_ss)^alpha

// 归一化劳动 N=1/3 → 反解 ψ
N_ss   = 0.333
K_ss   = kl_ss * N_ss
Y_ss   = K_ss^alpha * N_ss^(1-alpha)    // Δ=1，A=1
invest_ss = delta * K_ss
Q_ss   = 1                              // 稳态调整成本=0

// 企业家净值（WITH_FA=1）
// F7 稳态: N_ss = γ*[(Rk-R)*QK + R*N] + We → N*(1-γ*R) = γ*(Rk-R)*QK + We
// 取 We → 0，近似：N_ss = γ*(Rk-R)/(1-γ*R) * K_ss
// 再从 F8 稳态: premium_ss = (Q*K/N)^chi → N_ss = K_ss / premium_ss^(1/chi)
NW_ss  = Q_ss * K_ss / premium_ss^(1/chi)   // FROM F8
We_ss  = NW_ss * (1 - gamma*Rk_ss) - gamma*(Rk_ss - R_ss)*Q_ss*K_ss
         // 反解 We 使 F7 稳态成立

// 企业家消费
V_ss   = (Rk_ss - R_ss)*Q_ss*K_ss + R_ss*NW_ss  ... 近似简化
Ce_ss  = (1-gamma)*V_ss

// 家庭消费：由资源约束 F18
gy_share = 0.2                          // 校准目标 G/Y
G_ss   = gy_share * Y_ss
C_ss   = Y_ss - invest_ss - G_ss - Ce_ss

// 反解劳动负效用参数 ψ（使稳态劳动 = N_ss）
psi_ss = W_ss / (N_ss^phi * C_ss^sigma) // 从 F2 稳态反解

// Calvo 稳态（零通胀）
pstar_ss = 1，x1_ss = C_ss^{-σ}*mc_ss*Y_ss / (1 - θ*β)，x2_ss = C_ss^{-σ}*Y_ss / (1 - θ*β)
delta_p_ss = 1

// 名义利率
Rn_ss  = R_ss（已算）

// TFP、政府支出稳态水平
a_ss   = 1，g_ss = G_ss
```

> **校准目标**：$\bar{N}=1/3$（反解 $\psi$），$G/Y=0.2$（反解 $\bar{G}$），$\text{premium}=1.005$（外部融资溢价季频 0.5%，反解 $\bar{W}^e$）。

**WITH_FA = 0 时**：$\text{premium}_{ss}=1$，$N_t = Q_t K_t$（无杠杆），$R^k_{ss} = R_{ss}$，其余不变。

---

## 7. 时序与形式约定

- **期末存量（R2）**：$K_t$ 为 $t$ 期末资本，$t$ 期生产使用 $K_{t-1}$；资本积累方程左边写 $K_t$。
- **净值**：$N_t$ 为 $t$ 期末净值（企业家在 $t$ 期资本决策结束后），$t$ 期回报 $R^k_t$ 用 $K_{t-1}$，故净值演化含 $N_{t-1},K_{t-1}$。
- **价格分散度** $\Delta_t$：状态变量（含 $\Delta_{t-1}$）。
- **Calvo 辅助变量** $x_{1,t}, x_{2,t}$：当期控制变量，前瞻。
- **费雪方程**（F16）：写为 `rn = r * pi(+1)`，对当期名义利率决定实际利率，前瞻性。
- **形式**：全部非线性（R8），让 Dynare 做一阶展开。

---

## 8. 变量与参数对照表（R4 预核对）

### 内生变量（20 个）

| 变量名（ASCII） | 含义 | 由哪条方程决定 |
|---|---|---|
| `c` | 家庭消费 $C_t$ | F1（欧拉） |
| `n_lab` | 劳动时间 $N_t$ | F2（劳动市场） |
| `pi` | 毛通胀 $\Pi_t$ | F14（价格指数） |
| `r` | 实际毛利率 $R_t$ | F16（费雪） |
| `rn` | 名义毛利率 $R^n_t$ | F17（Taylor 规则） |
| `q` | Tobin's Q $Q_t$ | F5（Q 方程） |
| `k` | 资本存量 $K_t$（期末） | F6（资本积累） |
| `nw` | 企业家净值 $N_t$ | F7（净值，@#define） |
| `rk` | 资本回报率 $R^k_t$ | F3（回报率定义） |
| `y` | 总产出 $Y_t$ | F18（资源约束） |
| `mc` | 实际边际成本 $MC_t$ | F2（劳动市场，与 n_lab 联立） |
| `invest` | 投资 $I_t$ | F4（资本套利） |
| `a` | TFP $A_t$ | F19（TFP 过程） |
| `c_e` | 企业家消费 $C^e_t$ | F9（企业家消费） |
| `g` | 政府支出 $G_t$ | F20（政府支出过程） |
| `premium` | 外部融资溢价 $\Psi_t$ | F8（溢价，@#define） |
| `x1` | Calvo 递归 $x_{1,t}$ | F11 |
| `x2` | Calvo 递归 $x_{2,t}$ | F12 |
| `pstar` | 最优重定价 $P^*/P$ | F13 |
| `delta_p` | 价格分散度 $\Delta_t$ | F15 |

**方程数 = 变量数 = 20（R4 核对通过）** ✓

### 外生变量（3 个）

| 变量名（ASCII） | 含义 |
|---|---|
| `eps_a` | TFP 创新（R3：只放创新项）|
| `eps_g` | 政府支出创新 |
| `eps_m` | 货币政策创新 |

### 主要参数

| 参数名（ASCII） | 含义 | 校准值 |
|---|---|---|
| `betta` | 家庭贴现因子 $\beta$ | 0.99 |
| `sigma` | 风险规避 $\sigma$ | 1 |
| `phi_n` | 劳动供给弹性倒数 $\varphi$ | 3 |
| `psi` | 劳动负效用（稳态反解） | — |
| `alpha` | 资本产出份额 $\alpha$ | 0.35 |
| `delta` | 折旧率 $\delta$ | 0.025 |
| `theta` | Calvo 不可调价概率 $\theta$ | 0.75 |
| `eps_p` | CES 替代弹性 $\varepsilon$ | 6 |
| `phi_k` | 投资调整成本 $\phi_k$ | 1.0 |
| `gamma_e` | 企业家存活率 $\gamma$ | 0.9728 |
| `chi` | 溢价对杠杆弹性 $\chi$ | 0.05 |
| `s_ss` | 稳态外部融资溢价（校准目标）| 1.005 |
| `gy_share` | 政府支出占产出比 | 0.20 |
| `rho_R` | 利率平滑 $\rho_R$ | 0.90 |
| `phi_pi` | 泰勒规则通胀系数 $\phi_\pi$ | 1.50 |
| `phi_y` | 泰勒规则产出缺口系数 $\phi_y$ | 0.125 |
| `rho_a` | TFP 持续性 $\rho_a$ | 0.90 |
| `rho_g` | 政府支出持续性 $\rho_g$ | 0.90 |

---

> **交付此推导，等待用户确认后进入阶段2（写 .mod 文件）。**
