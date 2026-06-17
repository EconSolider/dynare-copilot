# NK_RW06 - 带成本渠道的最优货币政策

> 归档状态：`needs_review`。未执行运行时验证。MMB `.mod` 文件仅作为 `implementation_cross_check` 使用。

## 1. Model Overview

- **模型**：Ravenna and Walsh (2006), "Optimal monetary policy with the cost channel," `NK_RW06`。
- **来源**：`raw/mmb_mineru/runs/nk_rw06_nk_rw06al__optimal_monetary_policy_with_the_cost_channel__59aa85a1/full.md`；原始 PDF `raw/mmb_papers/Optimal monetary policy with the cost channel.pdf`。
- **核心机制**：带成本渠道的新凯恩斯黏性价格模型。企业借入营运资本支付工资，因此名义利率直接进入实际边际成本和菲利普斯曲线。
- **主体与模块**：代表性家庭、垄断竞争的 Calvo 定价企业、金融中介、政府/财政需求以及货币当局。
- **形式**：围绕稳态的对数线性/线性化均衡条件。MMB 实现使用 `model(linear)`，变量为 `x`、`pi` 和 `R`，并有一个复合需求冲击 `u`。
- **MMB 中表示的政策实验**：一个简单利率规则，该规则由 `.agents/skills/dynare-copilot/references/examples/NK_RW06_rep.mod` 交叉核对；它不是论文完整的承诺/相机抉择最优控制系统。

## 2. Optimization Problems

### 家庭

代表性家庭选择消费、劳动、存款和货币余额。偏好为

$$
E_t \sum_{i=0}^{\infty}\beta^i
\left[
\frac{\xi_{t+i} C_{t+i}^{1-\sigma}}{1-\sigma}
- \chi\frac{N_{t+i}^{1+\eta}}{1+\eta}
\right].
$$

来源中的当期现金和预算结构推出欧拉方程、劳动的期内条件以及现金先行约束。在正名义利率均衡中，这些条件记录在第 3 节。

### 最终品需求聚合器

复合品是 Dixit-Stiglitz 聚合：

$$
C_t =
\left[
\int_0^1 c_{jt}^{(\theta-1)/\theta}dj
\right]^{\theta/(\theta-1)}, \qquad \theta>1.
$$

对差异化商品进行成本最小化得到单个商品需求和总价格指数。

### 企业与成本渠道

基准理论模型中，每个企业使用线性劳动技术生产：

$$
y_{jt}=A_t N_{jt}.
$$

在成本渠道下，企业在销售收入到达之前借入营运资本支付工资。因此劳动的名义成本为 $R_t W_t$，实际边际成本包含名义利率。

### 政策制定者

在最优政策分析中，政策制定者在预期 IS 关系和成本渠道菲利普斯曲线约束下，最小化关于通胀和福利相关产出缺口的二次损失。MMB 实现交叉核对使用的是简单 Taylor 型规则，并在第 5 节标注为 `implementation_cross_check`。

## 3. First-Order Conditions

- **(F1) 家庭欧拉方程**：

$$
\xi_t C_t^{-\sigma}
=
\beta E_t\left[
\frac{R_t P_t}{P_{t+1}}\xi_{t+1} C_{t+1}^{-\sigma}
\right].
$$

- **(F2) 家庭劳动供给**：

$$
\frac{\chi N_t^\eta}{\xi_t C_t^{-\sigma}}
=
\frac{W_t}{P_t}.
$$

- **(F3) 现金先行约束**：

$$
P_t C_t = M_t + W_t N_t - D_t.
$$

- **(F4) 带成本渠道的灵活价格企业条件**：

$$
R_t^f w_t^f = \frac{A_t}{\Phi},
\qquad
\Phi \equiv \frac{\theta}{\theta-1}.
$$

- **(F5) 灵活价格产出**：

$$
Y_t^f =
\left[
\frac{\xi_t \gamma_t^{-\sigma} A_t^{1+\eta}}
{\chi \Phi R_t^f}
\right]^{1/(\sigma+\eta)}.
$$

- **(F6) 对数线性的灵活价格产出**：

$$
\hat{Y}_t^f =
\frac{1}{\sigma+\eta}
\left[
(1+\eta)\hat{A}_t
-\sigma\hat{\gamma}_t
+\hat{\xi}_t
-\hat{R}_t^f
\right].
$$

- **(F7) 有效率产出**：

$$
\hat{Y}_t^e =
\frac{(1+\eta)\hat{A}_t+\hat{\xi}_t+(1-\sigma)\hat{\gamma}_t}
{\sigma+\eta}.
$$

- **(F8) 固定利率潜在产出**：

$$
\hat{Y}_t^* =
\frac{(1+\eta)\hat{A}_t-\sigma\hat{\gamma}_t+\hat{\xi}_t}
{\sigma+\eta}.
$$

- **(F9) 产出缺口定义**：

$$
x_t \equiv \hat{Y}_t-\hat{Y}_t^*.
$$

- **(F10) 福利缺口关系**：

$$
\hat{Y}_t-\hat{Y}_t^e =
x_t-\frac{1}{\sigma+\eta}\hat{\gamma}_t,
\qquad \text{when } z^*=0.
$$

## 4. Market Clearing & Identities

- **(F11) 差异化商品需求**：

$$
c_{jt} =
\left(\frac{p_{jt}}{P_t}\right)^{-\theta} C_t.
$$

- **(F12) 总价格指数**：

$$
P_t =
\left[
\int_0^1 p_{jt}^{1-\theta}dj
\right]^{1/(1-\theta)}.
$$

- **(F13) 总资源约束**：

$$
Y_t = C_t + G_t.
$$

- **(F14) 政府购买份额恒等式**：

$$
G_t=(1-\gamma_t)Y_t,
\qquad
C_t=\gamma_t Y_t.
$$

- **(F15) 带成本渠道的实际边际成本**：

$$
\varphi_t \equiv \frac{R_t w_t}{A_t}=R_t S_t.
$$

- **(F16) 对数线性边际成本恒等式**：

$$
\hat{\varphi}_t \approx \hat{R}_t+\hat{s}_t.
$$

- **(F17) 以产出缺口表示的边际成本**：

$$
\hat{\varphi}_t =
(\sigma+\eta)x_t+\hat{R}_t.
$$

- **(F18) 预期 IS 曲线**：

$$
x_t =
E_t x_{t+1}
-\frac{1}{\sigma}\left(\hat{R}_t-E_t\pi_{t+1}\right)
+u_t.
$$

- **(F19) 成本渠道菲利普斯曲线**：

$$
\pi_t =
\beta E_t\pi_{t+1}
+\kappa(\sigma+\eta)x_t
+\kappa\hat{R}_t.
$$

- **(F20) Calvo 斜率参数**：

$$
\kappa=\frac{(1-\omega)(1-\omega\beta)}{\omega}.
$$

## 5. Exogenous Processes

- **(F21) 复合需求扰动**：

$$
u_t \equiv
\frac{1+\eta}{\sigma+\eta}
\left[
(E_t\hat{A}_{t+1}-\hat{A}_t)
-\frac{\eta}{\sigma}(E_t\hat{\xi}_{t+1}-\hat{\xi}_t)
+\frac{\eta}{1+\eta}(E_t\hat{\gamma}_{t+1}-\hat{\gamma}_t)
\right].
$$

- **(F22) 论文讨论中使用的生产率冲击例子**：

$$
\hat{A}_t=\rho_a \hat{A}_{t-1}+a_t,
\qquad 0<\rho_a<1.
$$

- **(F23) 论文校准讨论中使用的财政份额冲击例子**：

$$
\hat{\gamma}_t=\rho_\gamma \hat{\gamma}_{t-1}+\varepsilon^\gamma_t,
\qquad \rho_\gamma=0.9 \text{ in the reported fiscal-shock calibration.}
$$

- **(F24) 货币政策规则，implementation_cross_check**：

$$
\hat{R}_t = \phi_\pi \pi_t+\phi_x x_t.
$$

论文的最优政策部分求解承诺或相机抉择问题。MMB `NK_RW06_rep.mod` 改用 (F24)，其中 `phipi=1.1` 且 `phix=1`；该规则是 MMB 实现的交叉核对证据，而不是替代论文最优政策推导的纸面来源。

## 6. Steady-State Solution

由于 MMB 实现是线性的，稳态偏离均为零：

$$
\bar{x}=0,\qquad \bar{\pi}=0,\qquad \bar{\hat{R}}=0,\qquad \bar{u}=0.
$$

论文底层非线性模型使用正的稳态总名义利率 $\bar{R}$，在生产率和偏好冲击处于归一化稳态时，稳态产出为

$$
\bar{Y} =
\left[
\frac{\bar{\gamma}^{-\sigma}}
{\chi\Phi\bar{R}}
\right]^{1/(\sigma+\eta)}
$$

在福利分析中，来源通过补贴将平均效率扭曲设为零，使得 $z^*=0$，并用 (F10) 表示福利缺口。`needs_review`：论文引用一个附录给出二阶福利推导；本地没有 `NK_RW06` 的附录归一化文件。

## 7. Timing & Form Conventions

- 本归档条目是线性/对数线性的；带帽变量是围绕稳态的偏离，而 `x_t` 是相对于 $\hat{Y}_t^*$ 的产出缺口。
- 菲利普斯曲线中的名义利率是当期政策利率偏离 $\hat{R}_t$。
- 通胀通过 $E_t\pi_{t+1}$ 前瞻。
- IS 方程使用 $E_t x_{t+1}$ 和 $E_t\pi_{t+1}$；复合冲击 `u_t` 按 (F21) 汇总生产率、偏好和财政创新。
- `NK_RW06` 使用的基准理论模型没有资本存量；因此不存在资本时序约定。
- 未执行运行时验证，也未运行 Dynare。

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII name | 含义 | Determined by |
|---|---|---|---|
| Endogenous | $x_t$ / `x` | 相对于固定利率潜在产出的产出缺口 | (F18)，MMB 中结合政策规则 (F24) |
| Endogenous | $\pi_t$ / `pi` | 通胀偏离 | (F19) |
| Endogenous | $\hat{R}_t$ / `R` | 名义利率偏离 | MMB 中由 (F24) 决定；最优政策分析中为政策工具 |
| Exogenous | $u_t$ / `u` | 复合需求扰动 | (F21)；MMB 中实现为一个外生冲击 |
| Auxiliary/source concept | $\hat{Y}_t^f$ | 灵活价格产出 | (F6) |
| Auxiliary/source concept | $\hat{Y}_t^e$ | 有效率产出 | (F7) |
| Auxiliary/source concept | $\hat{Y}_t^*$ | 固定利率潜在产出 | (F8) |
| Auxiliary/source concept | $\hat{A}_t$ | 生产率冲击 | (F21), (F22) |
| Auxiliary/source concept | $\hat{\xi}_t$ | 偏好/口味冲击 | (F21) |
| Auxiliary/source concept | $\hat{\gamma}_t$ | 消费/产出份额，即财政需求份额的反向指标 | (F14), (F21), (F23) |
| Parameter | $\sigma$ / `sigma` | 跨期替代弹性倒数 / CRRA 系数 | 来源校准：1.5 |
| Parameter | $\eta$ / `eta` | 劳动供给曲率 | 来源校准：1 |
| Parameter | $\beta$ / `beta` | 贴现因子 | 来源校准：0.99 |
| Parameter | $\omega$ / `omega` | Calvo 不调价概率 | 来源校准：0.75 |
| Parameter | $\theta$ | 差异化商品替代弹性 | 来源校准：11，对应 1.1 加成 |
| Parameter | $\kappa$ / `kappa` | 菲利普斯曲线斜率 | (F20) |
| Parameter | $\lambda$ | 福利缺口权重 | 来源第 4 节公式 |
| Parameter | $\phi_\pi$ / `phipi` | 政策对通胀的反应 | MMB 交叉核对：1.1 |
| Parameter | $\phi_x$ / `phix` | 政策对产出缺口的反应 | MMB 交叉核对：1 |
| Parameter | $\rho_a$ | 生产率持续性 | 论文示例 |
| Parameter | $\rho_\gamma$ | 财政份额持续性 | 来源校准：0.9 |

MMB 实现子集的方程数是三个内生方程，对应 `x`、`pi` 和 `R`：(F18)、(F19) 和 (F24)。上面的较宽纸面推导记录了理解简化 MMB 系统所需的来源方程和恒等式。
