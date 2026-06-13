# 含政府投资的趋势 RBC 模型推导

**模型文件**：`model.mod`  
**参考文献**：Aschauer (1989) "Is public expenditure productive?", *Journal of Monetary Economics*；Barro (1990) "Government spending in a simple model of endogenous growth"；King, Plosser & Rebelo (1988) "Production, growth and business cycles"

---

## 第1节 模型概述

**经济问题**：政府投资（公共基础设施支出）对经济总量趋势的影响。  
**机制**：政府投资形成公共资本存量，作为外部性进入私人生产函数，提升总要素生产率；同时与私人投资争夺资源（挤出效应）。  
**经济体**：封闭经济、代表性代理人、完全竞争 RBC 框架、带确定性劳动增强型技术进步（趋势增长率 $\gamma$）。  
**冲击**：① 暂时性全要素生产率冲击 $\varepsilon_z$；② 政府投资冲击 $\varepsilon_g$。  
**分析方式**：对去趋势后的平衡增长路径（BGP）做一阶线性近似（`stoch_simul, order=1`）。

**去趋势约定**：所有量值变量除以技术水平 $A_t = (1+\gamma)^t$，得到去趋势变量（小写）；劳动 $N_t$（小时）无趋势。有效贴现因子 $\tilde{\beta} = \beta(1+\gamma)^{-1}$（对数效用）。

---

## 第2节 各主体最优化问题

### 2.1 代表性家庭

选择 $\{C_t, N_t, I_t, K_t\}$ 最大化贴现期望效用：

$$\max \; E_0 \sum_{t=0}^{\infty} \beta^t \left[ \ln C_t - \psi \frac{N_t^{1+\varphi}}{1+\varphi} \right]$$

**预算约束**（量值）：

$$C_t + I_t = W_t N_t + R_t^k K_{t-1} - T_t$$

其中利润为零（竞争均衡）；政府以总付税 $T_t = I_{G,t}$ 为政府投资融资。

**私人资本积累**（量值，R2：左边为期末存量）：

$$K_t = (1-\delta) K_{t-1} + I_t$$

在去趋势坐标系下（$\hat{c}_t = C_t/A_t$，$\hat{k}_t = K_t/A_t$ 等）：

$$\hat{c}_t + \hat{\imath}_t = \hat{w}_t N_t + \hat{r}_t^k \hat{k}_{t-1}$$

$$(1+\gamma)\hat{k}_t = (1-\delta)\hat{k}_{t-1} + \hat{\imath}_t$$

### 2.2 代表性竞争厂商

每期静态最大化利润，生产函数含劳动增强型技术与公共资本外部性（Aschauer 1989）：

$$Y_t = e^{z_t} K_{G,t-1}^{\alpha_G} K_{t-1}^{\alpha} (A_t N_t)^{1-\alpha-\alpha_G}$$

去趋势形式：

$$\hat{y}_t = e^{z_t} \hat{k}_{G,t-1}^{\alpha_G} \hat{k}_{t-1}^{\alpha} N_t^{1-\alpha-\alpha_G}$$

$K_{G,t}$ 为公共资本存量（外生于厂商，外部性），厂商将其视为给定。

利润最大化条件：

$$\max_{\{K_{t-1}, N_t\}} \hat{y}_t - \hat{r}_t^k \hat{k}_{t-1} - \hat{w}_t N_t$$

### 2.3 政府

政府选择 $I_{G,t}$ 并以总付税融资（$T_t = I_{G,t}$），不做最优化（外生规则）：

$$\ln I_{G,t} = (1-\rho_g)\ln I_{G}^{ss} + \rho_g \ln I_{G,t-1} + \varepsilon_{g,t}$$

政府公共资本积累（量值；去趋势：$(1+\gamma)\hat{k}_{G,t} = (1-\delta_G)\hat{k}_{G,t-1} + \hat{\imath}_{G,t}$）：

$$K_{G,t} = (1-\delta_G)K_{G,t-1} + I_{G,t}$$

---

## 第3节 一阶条件（FOC）

拉格朗日乘子 $\lambda_t$ 配预算约束，$\mu_t$ 配资本积累；消去 $\mu_t$ 后（无调整成本），$\lambda_t = C_t^{-1} = \hat{c}_t^{-1} A_t^{-1}$。

**（F1）消费欧拉方程**（对数效用，去趋势后）：

$$\hat{c}_t^{-1} = \frac{\beta}{1+\gamma} E_t\left[\hat{c}_{t+1}^{-1}\left(\hat{r}_{t+1}^k + 1-\delta\right)\right]$$

**（F2）劳动供给 FOC**（消费-闲暇权衡）：

$$\psi N_t^{\varphi} \hat{c}_t = \hat{w}_t$$

**（F3）劳动需求（厂商 FOC for $N_t$）**：

$$\hat{w}_t = (1-\alpha-\alpha_G) \frac{\hat{y}_t}{N_t}$$

**（F4）资本需求（厂商 FOC for $K_{t-1}$）**：

$$\hat{r}_t^k = \alpha \frac{\hat{y}_t}{\hat{k}_{t-1}}$$

---

## 第4节 市场出清与 Walras 定律检查

**商品市场出清**（资源约束，去趋势）：

$$\hat{y}_t = \hat{c}_t + \hat{\imath}_t + \hat{\imath}_{G,t}$$

**Walras 定律冗余方程检查**：

本模型有家庭预算约束、商品市场出清、政府预算（$T_t = I_{G,t}$）三条。其中：
- 家庭：$\hat{c}_t + \hat{\imath}_t = \hat{w}_t N_t + \hat{r}_t^k \hat{k}_{t-1} - T_t$
- 厂商零利润：$\hat{y}_t = \hat{w}_t N_t + \hat{r}_t^k \hat{k}_{t-1}$（CRS）
- 政府：$T_t = \hat{\imath}_{G,t}$（去趋势）

代入后得：$\hat{c}_t + \hat{\imath}_t = \hat{y}_t - \hat{\imath}_{G,t}$，即资源约束。

**结论**：商品市场出清条件由家庭预算约束 + 厂商零利润 + 政府预算恒等式推出，即 **Walras 定律意义下，家庭预算约束是冗余方程**。  
`model` 块中**只写资源约束**，不写家庭预算约束。✓

---

## 第5节 外生过程

**(E1) 暂时性 TFP 冲击**（AR(1)，对数水平）：

$$z_t = \rho_z z_{t-1} + \varepsilon_{z,t}, \quad \varepsilon_{z,t} \sim \mathcal{N}(0, \sigma_z^2)$$

**(E2) 政府投资过程**（对数 AR(1)，均值为稳态值）：

$$\ln \hat{\imath}_{G,t} = (1-\rho_g)\ln \hat{\imath}_{G}^{ss} + \rho_g \ln \hat{\imath}_{G,t-1} + \varepsilon_{g,t}, \quad \varepsilon_{g,t} \sim \mathcal{N}(0, \sigma_g^2)$$

其中 $\hat{\imath}_{G}^{ss}$ 在稳态模块中由 $\hat{\imath}_{G}^{ss} / \hat{y}^{ss} = g_y$ 反解（校准目标）。

---

## 第6节 稳态求解（去趋势，顺序计算）

1. $z^{ss} = 0$

2. **资本租金率**（由欧拉方程 F1）：

$$\hat{r}^{k,ss} = \frac{1+\gamma}{\beta} - (1-\delta) = \frac{1+\gamma}{\beta} - 1 + \delta$$

3. **资本-产出比**（由 F4）：$ky \equiv \hat{k}^{ss}/\hat{y}^{ss} = \alpha / \hat{r}^{k,ss}$

4. **公共资本-产出比**（由公共资本积累方程稳态）：$kgy \equiv \hat{k}_G^{ss}/\hat{y}^{ss} = g_y/(\gamma+\delta_G)$

5. **归一化劳动目标**：$N^{ss} = 1/3$（校准目标，反解 $\psi$）

6. **稳态产出**（由生产函数，$\hat{y}^{ss} = kgy^{\alpha_G} ky^{\alpha} \hat{y}^{ss^{\alpha_G+\alpha}} N^{ss^{1-\alpha-\alpha_G}}$）：

$$\hat{y}^{ss} = \left(kgy^{\alpha_G} \cdot ky^{\alpha}\right)^{1/(1-\alpha-\alpha_G)} \cdot N^{ss}$$

7. $\hat{k}^{ss} = ky \cdot \hat{y}^{ss}$，$\hat{k}_G^{ss} = kgy \cdot \hat{y}^{ss}$

8. $\hat{\imath}^{ss} = (\gamma+\delta)\hat{k}^{ss}$（私人投资）；$\hat{\imath}_G^{ss} = g_y \hat{y}^{ss}$（政府投资）

9. $\hat{c}^{ss} = \hat{y}^{ss} - \hat{\imath}^{ss} - \hat{\imath}_G^{ss}$（资源约束）

10. $\hat{w}^{ss} = (1-\alpha-\alpha_G)\hat{y}^{ss}/N^{ss}$（劳动需求 F3）

11. **反解劳动负效用权重**（由 F2）：$\psi = \hat{w}^{ss} / \left((N^{ss})^{\varphi} \hat{c}^{ss}\right)$

---

## 第7节 时序约定（R2 期末存量）

| 变量 | 时序类型 | Dynare 写法 | 备注 |
|------|---------|-------------|------|
| $\hat{k}_t$ | 状态（期末存量） | `k` 当期，`k(-1)` 上期；生产用 `k(-1)` | $t$ 期末决定，$t+1$ 期投入生产 |
| $\hat{k}_{G,t}$ | 状态（期末存量） | `kg` 当期，`kg(-1)` 上期；生产用 `kg(-1)` | 同上 |
| $z_t$ | 状态 | `z(-1)` 在 AR 过程中 | 对数水平 |
| $\hat{\imath}_{G,t}$ | 状态 | `ig(-1)` 在 AR 过程中 | 对数 AR |
| $\hat{c}_t, N_t, \hat{\imath}_t, \hat{y}_t$ | 控制（跳跃） | 无滞后 | 当期决定 |
| $\hat{w}_t, \hat{r}_t^k$ | 跳跃（辅助） | 无滞后 | 由厂商 FOC 即期决定 |

---

## 第8节 变量参数对照表（预核对 R4）

| 内生变量 | 由哪条方程决定 |
|---------|--------------|
| `y` | 生产函数 |
| `c` | 资源约束 |
| `k` | 私人资本积累方程 |
| `n` | 劳动市场出清（由 F2=F3 联立） |
| `invest` | 私人投资（由 F4 + 欧拉推出，等价于：资本积累 + 资源约束） |
| `ig` | 政府投资 AR(1) 过程 |
| `kg` | 公共资本积累方程 |
| `z` | TFP AR(1) 过程 |
| `w` | 劳动需求 FOC（F3） |
| `rk` | 资本需求 FOC（F4） |
| `log_y`…`log_n` | 6 条对数辅助方程 |

**方程总数**：10 + 6 = 16；**内生变量总数**：16。✓ 满足 R4。

**外生变量**：`eps_z`（TFP 创新），`eps_ig`（政府投资创新）。

**参数校准摘要**：

| 参数 | 值 | 说明 |
|------|-----|------|
| `betta` | 0.99 | 季度贴现因子 |
| `gam` | 0.005 | 季度趋势增长率（≈2% 年化） |
| `delta` | 0.025 | 私人资本折旧（≈10% 年化） |
| `deltag` | 0.05 | 公共资本折旧（≈20% 年化，基础设施） |
| `alppha` | 0.33 | 私人资本产出弹性 |
| `alphag` | 0.10 | 公共资本外部性弹性（Aschauer 1989） |
| `phhi` | 1.0 | Frisch 弹性倒数 |
| `psi` | *反解* | 劳动负效用，命中 $N^{ss}=1/3$ |
| `rhoz` | 0.95 | TFP 冲击持续性 |
| `rho_ig` | 0.80 | 政府投资冲击持续性 |
| `gy` | 0.05 | 政府投资/产出稳态比 = 5% |
| `ig_ss` | *反解* | 稳态政府投资水平 |
