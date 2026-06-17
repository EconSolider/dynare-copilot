# NK_BGUS10 - 推导（最优化问题 + 一阶条件）

> 第一轮归档抽取状态：`needs_review`。未执行运行时验证。

来源：Blanchard, Olivier, and Jordi Gali (2010), "Labor markets and monetary policy: A New Keynesian model with unemployment," *American Economic Journal: Macroeconomics* 2(2), 1-30, DOI `10.1257/mac.2.2.1`。

## 1. Model Overview

- **模型**：MMB `NK_BGUS10`，即 Blanchard-Gali 含失业的新凯恩斯模型的美国流动劳动力市场校准。
- **用途**：在价格黏性、劳动力市场招聘摩擦和实际工资刚性使失业产生低效周期波动时，分析生产率冲击与货币政策权衡。
- **主体与模块**：代表性家庭、具有招聘成本的中间品企业、Calvo 定价的垄断竞争最终品企业，以及货币当局。
- **形式**：围绕零通胀稳态的对数线性 `model(linear)` 系统。带帽小写变量为对数偏离，失业为相对稳态失业率的水平偏离。
- **变体**：MMB 实现使用美国/流动劳动力市场校准，稳态失业率 `u = 0.05`，就业找到率 `x = 0.7`。

## 2. Optimization Problems

### 代表性家庭

家庭最大化消费和就业带来的期望效用：

$$
E_0 \sum_{t=0}^{\infty} \beta^t
\left(\log C_t - \chi \frac{N_t^{1+\phi}}{1+\phi}\right),
\qquad 0 \le N_t \le 1.
$$

MMB 条目使用的对数线性欧拉方程来自该家庭的消费一阶条件。

### 劳动力市场流量与招聘成本

在 `t` 期初，失业池为

$$
U_t = 1 - (1-\delta)N_{t-1}.
$$

总招聘和劳动力市场紧张度为

$$
H_t = N_t - (1-\delta)N_{t-1}, \qquad
x_t = \frac{H_t}{U_t}.
$$

单位招聘成本与生产率成比例，并随紧张度上升：

$$
G_t = A_t B x_t^\alpha.
$$

### 企业与价格设定

中间品生产对就业是线性的：

$$
X_t(j) = A_t N_t(j).
$$

实际边际成本由工资部分、当期招聘成本以及未来招聘成本下降的预期延续价值共同决定：

$$
MC_t =
\Theta A_t^{-\gamma}
+ B x_t^\alpha
- \beta(1-\delta)E_t\left[
\frac{C_t}{C_{t+1}}\frac{A_{t+1}}{A_t}B x_{t+1}^\alpha
\right].
$$

最终品企业按照 Calvo 机制错期定价。围绕零通胀稳态对数线性化后得到第 3 节的新凯恩斯菲利普斯曲线。

### 货币当局

对 MMB `NK_BGUS10` 条目，政策规则采用文中美国校准下报告的优化简单规则：

$$
i_t = \rho + \phi_\pi \pi_t + \phi_u \hat u_t,
$$

实现交叉检查值为 `phi_pi = 5` 和 `phi_u = -0.8`。

## 3. First-Order Conditions

以下线性化均衡条件是 MMB 美国校准使用的模型方程。方程 (F2) 对应论文方程 (25)；这里规范化了 OCR 换行，如该条目未来提升到第一轮以外状态，应对 PDF 进行核查。

- **(F1) 新凯恩斯菲利普斯曲线**：

$$
\pi_t = \beta E_t\{\pi_{t+1}\} + \lambda \widehat{mc}_t.
$$

- **(F2) 含招聘成本和实际工资刚性的实际边际成本**（`needs_review` OCR 规范化）：

$$
\widehat{mc}_t =
\alpha g\mathcal{M}\hat{x}_t
- \beta(1-\delta)g\mathcal{M}E_t\left[
(\hat{c}_t-\hat{a}_t)-(\hat{c}_{t+1}-\hat{a}_{t+1})+\alpha\hat{x}_{t+1}
\right]
- \Phi\gamma\hat{a}_t.
$$

- **(F3) 灵活价格下的边际成本对应式**：

$$
\alpha g\mathcal{M}\hat{x}^f_t =
\beta(1-\delta)g\mathcal{M}E_t\left[
(\hat{c}^f_t-\hat{a}_t)-(\hat{c}^f_{t+1}-\hat{a}_{t+1})+\alpha\hat{x}^f_{t+1}
\right]
+ \Phi\gamma\hat{a}_t.
$$

- **(F4) 家庭欧拉方程**：

$$
\hat{c}_t = E_t\{\hat{c}_{t+1}\} - \left(i_t - E_t\{\pi_{t+1}\} - \rho\right).
$$

- **(F5) 灵活价格下的家庭欧拉方程**：

$$
\hat{c}^f_t = E_t\{\hat{c}^f_{t+1}\} - (r_t-\rho).
$$

## 4. Market Clearing & Identities

- **(F6) 由就业动态得到的劳动力市场紧张度**：

$$
\delta\hat{x}_t =
\hat{n}_t - (1-\delta)(1-x)\hat{n}_{t-1}.
$$

- **(F7) 灵活价格下由就业动态得到的紧张度**：

$$
\delta\hat{x}^f_t =
\hat{n}^f_t - (1-\delta)(1-x)\hat{n}^f_{t-1}.
$$

- **(F8) 商品市场资源关系**：

$$
\hat{c}_t =
\hat{a}_t
+ \frac{1-g}{1-\delta g}\hat{n}_t
+ \frac{g(1-\delta)}{1-\delta g}\hat{n}_{t-1}
- \frac{\alpha g}{1-\delta g}\delta\hat{x}_t.
$$

- **(F9) 灵活价格下的资源关系**：

$$
\hat{c}^f_t =
\hat{a}_t
+ \frac{1-g}{1-\delta g}\hat{n}^f_t
+ \frac{g(1-\delta)}{1-\delta g}\hat{n}^f_{t-1}
- \frac{\alpha g}{1-\delta g}\delta\hat{x}^f_t.
$$

- **(F10) 美国校准的优化简单货币政策规则**：

$$
i_t = \rho + 5\pi_t - 0.8\hat{u}_t.
$$

- **(F11) 失业偏离与就业**：

$$
\hat{u}_t = -(1-u)\hat{n}_t.
$$

- **(F12) 灵活价格下的失业偏离与就业**：

$$
\hat{u}^f_t = -(1-u)\hat{n}^f_t.
$$

- **(F13) 产出恒等式**：

$$
\hat{y}_t = \hat{a}_t + \hat{n}_t.
$$

- **(F14) 灵活价格下的产出恒等式**：

$$
\hat{y}^f_t = \hat{a}_t + \hat{n}^f_t.
$$

## 5. Exogenous Processes

- **(F15) 技术过程**：

$$
\hat{a}_t = \rho_a\hat{a}_{t-1} + \varepsilon^a_t.
$$

MMB 实现将创新写为负号形式 `a = ra*a(-1) - a_`；该符号约定记录为实现交叉检查，而不是论文侧方程。

## 6. Steady-State Solution

由于归档的 MMB 条目是 `model(linear)`，所有内生模型变量都表示为围绕稳态的偏离，因此线性系统的稳态为零：

$$
\pi = \widehat{mc} = \hat{x} = \hat{c} = \hat{a} = \hat{n} = \hat{u} = i-\rho = 0,
$$

灵活价格对应变量同理。

这些偏离变量背后的非零校准对象为：

$$
\mathcal{M}=\frac{\epsilon}{\epsilon-1}, \qquad
\lambda=\frac{(1-\beta\theta)(1-\theta)}{\theta}, \qquad
\rho=-\log\beta.
$$

对美国/流动劳动力市场校准：

$$
u=0.05,\qquad x=0.7,\qquad
\delta=\frac{ux}{(1-u)(1-x)},\qquad
g=Bx^\alpha.
$$

论文选择 `B`，使美国校准下稳态招聘成本约为 GDP 的百分之一；设定 `gamma = 0.5`、`alpha = 1`、`beta = 0.99`、`phi = 1`、`epsilon = 6`，并用约束有效稳态条件确定 `chi`。

## 7. Timing & Form Conventions

- **形式**：线性化模型，以 Dynare `model(linear)` 实现。
- **预期**：(F1)-(F5) 中的前瞻项按 `E_t` 定价。
- **就业时序**：就业 `N_t` 包括 `t` 期内新招聘并开始工作的劳动者；期初失业取决于 `N_{t-1}`。
- **紧张度时序**：`x_t` 是 `t` 期就业找到率，由 `t` 期招聘量除以期初失业池定义。
- **冲击符号**：论文侧技术过程写为标准 AR(1)；Rep-MMB 文件使用 `a = ra*a(-1) - a_`，因此运行时比较前应检查脉冲符号。
- **运行时验证**：未执行。

## 8. Variable & Parameter Reference Table

### 内生变量

| ASCII name | Mathematical symbol | 含义 | 方程 |
|---|---|---|---|
| `pi` | $\pi_t$ | 通胀 | (F1) |
| `mc` | $\widehat{mc}_t$ | 实际边际成本 | (F2) |
| `xhat` | $\hat{x}_t$ | 劳动力市场紧张度 | (F6) |
| `c` | $\hat{c}_t$ | 消费 | (F4), (F8) |
| `a` | $\hat{a}_t$ | 技术 | (F15) |
| `n` | $\hat{n}_t$ | 就业 | (F6), (F11) |
| `uhat` | $\hat{u}_t$ | 失业偏离 | (F11) |
| `i` | $i_t$ | 名义利率 | (F10) |
| `xhatf` | $\hat{x}^f_t$ | 灵活价格下紧张度 | (F7) |
| `cf` | $\hat{c}^f_t$ | 灵活价格下消费 | (F5), (F9) |
| `nf` | $\hat{n}^f_t$ | 灵活价格下就业 | (F7), (F12) |
| `uhatf` | $\hat{u}^f_t$ | 灵活价格下失业偏离 | (F12) |
| `r` | $r_t$ | 自然/灵活价格实际利率 | (F5) |
| `y` | $\hat{y}_t$ | 产出 | (F13) |
| `yf` | $\hat{y}^f_t$ | 灵活价格下产出 | (F14) |

### 外生冲击

| ASCII name | Mathematical symbol | 含义 |
|---|---|---|
| `a_` | $\varepsilon^a_t$ | 技术创新 |

### 参数

| ASCII name | Mathematical symbol | 含义 / 数值线索 |
|---|---|---|
| `gam` | $\gamma$ | 实际工资刚性程度；基准 0.5 |
| `alf` | $\alpha$ | 招聘成本弹性；基准 1 |
| `the` | $\theta$ | Calvo 价格黏性 |
| `bet` | $\beta$ | 贴现因子；0.99 |
| `phi` | $\phi$ | Frisch 弹性倒数；1 |
| `eps` | $\epsilon$ | 替代弹性；6 |
| `lam` | $\lambda$ | 菲利普斯曲线斜率 |
| `M` | $\mathcal{M}$ | 期望总加成 |
| `gdel` | $\delta g$ | 招聘成本 GDP 份额目标 |
| `ra` | $\rho_a$ | 技术持续性 |
| `x_` | $x$ | 稳态就业找到率；美国值 0.7 |
| `u` | $u$ | 稳态失业率；美国值 0.05 |
| `del` | $\delta$ | 由 `u` 和 `x_` 推出的分离率 |
| `g` | $g$ | 稳态招聘成本组成 |
| `B` | $B$ | 招聘成本尺度 |
| `chi` | $\chi$ | 由有效稳态确定的效用权重 |
| `bphi` | $\Phi$ | 边际成本中的工资刚性复合项 |
| `alfux` | $\alpha_u$ | 福利损失中的失业权重 |
| `gmu`, `xi0`, `xi1`, `k0`, `kl`, `kf` | composites | 论文/实现中的政策方程复合系数 |
| `rho` | $\rho$ | $-\log\beta$ |
