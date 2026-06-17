# NK_BGEU10 -- 推导（最优化问题 + 一阶条件）

> 归档状态：`needs_review`。这份一稿推导以 Blanchard and Gali (2010) 的 MinerU Markdown 为来源；Rep-MMB `.mod` 文件只作为 `implementation_cross_check`。
> 未执行运行时验证。

## 1. Model Overview（模型概述）

- **模型**：`NK_BGEU10`，Blanchard and Gali (2010) "Labor markets and monetary policy: A New Keynesian model with unemployment" 的欧洲大陆校准。
- **核心机制**：包含代表性家庭、劳动市场雇佣摩擦、真实工资刚性、Calvo 定价和货币政策的新凯恩斯失业模型。当真实工资不能随生产率一比一调整时，生产率冲击会影响通胀和失业。
- **主体与模块**：家庭、带雇佣成本的中间品厂商、Calvo 定价的垄断竞争最终品厂商、工资规则、货币当局。
- **归档形式**：Rep-MMB 实现为 `model(linear)`。论文先推导非线性对象，再在零通胀稳态附近对数线性化。带帽变量为对数偏离，但失业变量 $\hat u_t$ 是失业率相对稳态的偏离。
- **欧洲校准标识**：`NK_BGEU10` 使用较僵化的劳动市场校准，稳态失业率 $u=0.10$，就业找到率 $x=0.25$。

## 2. Optimization Problems（主体的最优化问题）

### 2.1 代表性家庭

家庭由连续成员组成，最大化期望效用：

$$
E_0 \sum_{t=0}^{\infty}\beta^t
\left(\log C_t-\chi\frac{N_t^{1+\phi}}{1+\phi}\right),
$$

约束为 $0 \le N_t \le 1$ 以及总量资源和资产市场约束。在线性化均衡中，家庭跨期条件由第 3 节的消费欧拉方程表示。

### 2.2 中间品厂商与雇佣

中间品厂商仅用劳动生产：

$$
X_t(j)=A_t N_t(j),
$$

就业随当期雇佣演化：

$$
N_t(j)=(1-\delta)N_{t-1}(j)+H_t(j).
$$

期初失业、总雇佣和劳动市场紧张度为：

$$
U_t=1-(1-\delta)N_{t-1}, \qquad
H_t=N_t-(1-\delta)N_{t-1}, \qquad
x_t=\frac{H_t}{U_t}.
$$

每名新雇员的雇佣成本与生产率成比例：

$$
G_t=A_t B x_t^\alpha.
$$

厂商利润最大化意味着实际边际成本取决于真实工资、当期雇佣成本以及预期未来雇佣成本节约。

### 2.3 工资规则与定价厂商

就业关系剩余产生一个工资区间。货币政策分析使用的真实工资刚性情形假设：

$$
W_t=\Theta A_t^{1-\gamma},
$$

其中 $\gamma \in [0,1]$ 衡量真实工资刚性。最终品厂商面对 Calvo 定价；每期只有比例 $1-\theta$ 的厂商能重新定价。

### 2.4 货币当局

论文研究极端政策、最优政策和优化后的简单规则。`NK_BGEU10` 的 Rep-MMB 实现使用最优政策线性系统，其中辅助乘子变量对应第 3 节的一阶条件。

## 3. First-Order Conditions（一阶条件）

以下编号方程概括归档条目使用的线性均衡和最优政策条件。编号在第 3-5 节连续。

- **(F1) 以边际成本表示的新凯恩斯菲利普斯曲线**：

$$
\pi_t=\beta E_t\{\pi_{t+1}\}+\lambda \widehat{mc}_t,
\qquad
\lambda=\frac{(1-\beta\theta)(1-\theta)}{\theta}.
$$

- **(F2) 替换失业变量前的线性化边际成本**：

$$
\widehat{mc}_t=\alpha g\mathcal{M}\hat{x}_t
-\beta(1-\delta)g\mathcal{M}E_t\left\{
(\hat c_t-\hat a_t)-(\hat c_{t+1}-\hat a_{t+1})+\alpha\hat{x}_{t+1}
\right\}
-\Phi\gamma\hat a_t,
$$

其中

$$
\Phi=1-(1-\beta(1-\delta))g\mathcal{M}.
$$

- **(F3) 由就业动态得到的劳动市场紧张度**：

$$
\delta\hat{x}_t=\hat n_t-(1-\delta)(1-x)\hat n_{t-1}.
$$

- **(F4) 由资源约束得到的消费**：

$$
\hat c_t=\hat a_t+\xi_0\hat n_t+\xi_1\hat n_{t-1},
$$

其中

$$
\xi_0=\frac{1-g(1+\alpha)}{1-\delta g},
\qquad
\xi_1=\frac{g(1-\delta)(1+\alpha(1-x))}{1-\delta g}.
$$

- **(F5) 消费欧拉方程**：

$$
\hat c_t=E_t\{\hat c_{t+1}\}-\left(i_t-E_t\{\pi_{t+1}\}-\rho\right),
\qquad
\rho=-\log\beta.
$$

- **(F6) 精确失业菲利普斯曲线**：

$$
\pi_t=\beta E_t\{\pi_{t+1}\}
-\kappa_0\hat u_t+\kappa_L\hat u_{t-1}
\kappa_F E_t\{\hat u_{t+1}\}
-\lambda\Phi\gamma\hat a_t.
$$

系数为：

$$
\kappa_0=\frac{\lambda h_0}{1-u}, \qquad
\kappa_L=-\frac{\lambda h_L}{1-u}, \qquad
\kappa_F=-\frac{\lambda h_F}{1-u},
$$

$$
h_0=\frac{\alpha g\mathcal{M}}{\delta}
\left(1+\beta(1-\delta)^2(1-x)\right)
\beta(1-\delta)g\mathcal{M}(\xi_1-\xi_0),
$$

$$
h_L=-\frac{\alpha g\mathcal{M}}{\delta}(1-\delta)(1-x)
-\beta(1-\delta)g\mathcal{M}\xi_1,
$$

$$
h_F=-\beta(1-\delta)g\mathcal{M}
\left(\frac{\alpha}{\delta}-\xi_0\right).
$$

`needs_review`：MinerU OCR 中 $h_0$ 和 $h_F$ 定义基本可读，但在归档升级前应对照 PDF 检查，因为 OCR 可能丢失了 $\alpha g\mathcal{M}/\delta$ 与 $g\mathcal{M}$ 因子的括号。Rep-MMB 文件使用的系数定义对应论文的精确失业菲利普斯曲线。

- **(F7) 最优政策的通胀一阶条件**：

$$
2\pi_t+\zeta_t-\zeta_{t-1}=0.
$$

- **(F8) 最优政策的失业一阶条件**：

$$
2\alpha_u\hat u_t+\kappa_0\zeta_t
-\beta\kappa_L E_t\{\zeta_{t+1}\}
-\beta^{-1}\kappa_F\zeta_{t-1}=0.
$$

Rep-MMB 变量 `eta` 与最优政策乘子模块对应，但存在尺度或符号约定差异。

## 4. Market Clearing & Identities（市场出清与恒等式）

- **(F9) 期初失业恒等式**：

$$
U_t=1-(1-\delta)N_{t-1}.
$$

- **(F10) 雇佣恒等式**：

$$
H_t=N_t-(1-\delta)N_{t-1}.
$$

- **(F11) 劳动市场紧张度定义**：

$$
x_t=\frac{H_t}{U_t}.
$$

- **(F12) 期末失业率**：

$$
u_t=1-N_t.
$$

- **(F13) 含雇佣成本的总量资源约束**：

$$
C_t=A_t\left(N_t-Bx_t^\alpha H_t\right).
$$

- **(F14) Rep-MMB 使用的年化通胀报告恒等式**：

$$
\text{inflation}_t=4\pi_t.
$$

简化后的 Rep-MMB `model(linear)` 将 (F2)-(F6) 折叠为关于 `pi`、`uhat`、滞后 `uhat`、预期 `uhat` 和 `a` 的紧凑失业菲利普斯曲线，以及最优政策乘子方程。

## 5. Exogenous Processes（外生过程）

- **(F15) 生产率过程**：

$$
\hat a_t=\rho_a \hat a_{t-1}+\varepsilon^a_t.
$$

Rep-MMB 实现写作 `a = ra*a(-1) - a_`，即命名冲击的符号相反；这是实现符号约定，不是另一条来源方程。

## 6. Steady-State Solution（稳态求解）

这里归档的模型是在零通胀稳态附近线性化，因此 `model(linear)` 模块中的内生偏离变量稳态为零：

$$
\bar\pi=\bar{\hat u}=\bar{\hat a}=\bar\zeta=0,
\qquad
\overline{\text{inflation}}=0.
$$

用于构造系数的底层非线性稳态对象为：

$$
\mathcal{M}=\frac{\epsilon}{\epsilon-1}, \qquad
\lambda=\frac{1}{12}, \qquad
\rho=-\log\beta,
$$

$$
\delta=\frac{ux}{(1-u)(1-x)}, \qquad
g=Bx^\alpha,
$$

$$
\Phi=1-(1-\beta(1-\delta))g\mathcal{M},
$$

$$
\alpha_u=\frac{\lambda(1+\phi)\chi(1-u)^{\phi-1}}{\epsilon}.
$$

欧洲校准为：

$$
u=0.10, \qquad x=0.25, \qquad \delta \approx 0.04.
$$

Rep-MMB 校准交叉检查值包括 $\beta=0.99$、$\phi=1$、$\epsilon=6$、$\lambda=1/12$、$\gamma=0.5$、$\alpha=1$、$B=5/42$、$\rho_a=0.9$。

## 7. Timing & Form Conventions（时序与形式约定）

- **形式**：线性化 `model(linear)` 表示；未执行非线性 Dynare 运行时验证。
- **通胀**：$\pi_t$ 是季度通胀；Rep-MMB 文件中的 `inflation` 按 $4\pi_t$ 年化。
- **失业**：$\hat u_t$ 是失业率相对稳态的偏离，不是对数偏离。在线性化模型中它与就业满足 $\hat u_t=-(1-u)\hat n_t$。
- **劳动时序**：期初失业 $U_t$ 由滞后就业 $N_{t-1}$ 和离职决定；新雇员在被雇佣当期工作，因此 $N_t=(1-\delta)N_{t-1}+H_t$。
- **政策时序**：最优政策 FOC 使用滞后乘子 $\zeta_{t-1}$ 和预期未来乘子 $E_t\zeta_{t+1}$。Rep-MMB 实现用 `eta(-1)` 和 `eta(+1)` 表示。
- **冲击符号**：实现中的 `a = ra*a(-1) - a_` 表示正的 `a_` 降低生产率；来源过程统一记录为 (F15)。

## 8. Variable & Parameter Reference Table（变量与参数对照表）

### 内生变量

| ASCII 名称 | 数学符号 | 含义 | 主要决定方程 |
|---|---:|---|---|
| `pi` | $\pi_t$ | 季度通胀 | (F6), (F7) |
| `uhat` | $\hat u_t$ | 失业率偏离 | (F6), (F8) |
| `a` | $\hat a_t$ | 生产率偏离 | (F15) |
| `eta` | $\zeta_t$ | 最优政策乘子/辅助变量 | (F7), (F8) |
| `inflation` | $\text{inflation}_t$ | 年化通胀 | (F14) |

### 外生冲击

| ASCII 名称 | 含义 |
|---|---|
| `a_` | 生产率创新；Rep-MMB 实现中符号相反 |

### 参数

| ASCII 名称 | 数学符号 | 含义 |
|---|---:|---|
| `bet` | $\beta$ | 贴现因子 |
| `phi` | $\phi$ | 家庭劳动负效用中的 Frisch 倒数参数 |
| `eps` | $\epsilon$ | 商品间替代弹性 |
| `lam` | $\lambda$ | Calvo 定价斜率项 |
| `gam` | $\gamma$ | 真实工资刚性指数 |
| `alf` | $\alpha$ | 雇佣成本弹性 |
| `M` | $\mathcal{M}$ | 期望总加成 |
| `x` | $x$ | 稳态就业找到率；欧洲校准为 0.25 |
| `u` | $u$ | 稳态失业率；欧洲校准为 0.10 |
| `del` | $\delta$ | 离职率 |
| `B` | $B$ | 雇佣成本规模 |
| `g` | $g$ | 稳态雇佣成本项 $Bx^\alpha$ |
| `rho` | $\rho$ | 稳态实际利率，$-\log\beta$ |
| `ra` | $\rho_a$ | 生产率持续性 |
| `chi` | $\chi$ | 由有效稳态确定的劳动负效用规模 |
| `bphi` | $\Phi$ | 真实工资/边际成本系数 |
| `alfux` | $\alpha_u$ | 失业福利权重 |
| `gmu` | $g\mathcal{M}/(1-u)$ | 系数辅助项 |
| `xi0` | $\xi_0$ | 消费-就业系数 |
| `xi1` | $\xi_1$ | 滞后就业系数 |
| `k0` | $\kappa_0$ | 当期失业系数 |
| `kl` | $\kappa_L$ | 滞后失业系数 |
| `kf` | $\kappa_F$ | 预期失业系数 |
| `the` | $\theta$ | Calvo 价格刚性参数；来源公式中出现，但 Rep-MMB 通过 `lam` 间接设定 |
