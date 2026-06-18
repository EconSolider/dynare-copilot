# EA_SWW14 - 推导（最优化问题 + 均衡条件）

> 这是一份用于源码复核的一阶归档推导；尚未进入 Dynare 实现工作。未执行运行时验证。

来源：Frank Smets, Anders Warne, and Rafael Wouters (2014), "Professional forecasters and real-time forecasting with a DSGE model", *International Journal of Forecasting*, 30, 981-995. DOI: `10.1016/j.ijforecast.2014.03.018`。

## 1. Model Overview

- **模型**：欧元区 Galí-Smets-Wouters (GSW) 中等规模新凯恩斯 DSGE 模型，用于实时预测与 SPF 条件预测实验。
- **归档 ID**：`EA_SWW14`。
- **经济体**：欧元区。
- **实验**：使用八个观测宏观序列进行实时预测，并比较基准 GSW 模型以及 SPF 条件下的 noise/news 变体。以下归档推导记录基准结构性 GSW 模型块；SPF noise/news 条件是预测和测量扩展，而不是另一个私人部门均衡。
- **主体与模块**：具有消费习惯的家庭，带调整成本和资本利用率的投资/资本积累，具有 Calvo 摩擦和指数化的价格与工资设定者，失业/劳动力模块，Taylor 型货币当局，以及八个外生结构冲击。
- **形式**：围绕平衡增长路径的对数线性化均衡系统；实现交叉检查文件使用 `model(linear)`。
- **状态**：`needs_review`。源 Markdown 给出了主要均衡方程，但冲击符号和 markup 定义附近仍有 OCR 噪声。

## 2. Optimization Problems

论文给出的是对数线性化均衡条件，而不是完整的非线性家庭和企业问题。底层优化模块根据 GSW/Smets-Wouters 结构推断，只应作为推导背景，不能视为论文逐条写出的非线性方程。

### 2.1 家庭消费-储蓄问题

家庭具有外部消费习惯，并选择消费和名义债券持有。论文直接给出对应的对数线性 Euler 方程。隐含目标函数具有习惯调整后的边际效用，Euler 方程中含有跨期楔子/风险溢价冲击 $\widehat{\varepsilon}^b_t$。

### 2.2 投资与资本服务

资本品决策推出关于投资和安装资本价值 $\widehat{q}^k_t$ 的前瞻性投资 Euler 方程。资本随投资专用技术冲击演化，生产中的资本服务由滞后安装资本和当期利用率组成。

### 2.3 价格和工资设定

中间品和劳动品种面对 Calvo 名义刚性以及部分指数化。论文用平均 markup 和自然 markup 给出对数线性价格和工资 Phillips 曲线。

### 2.4 货币政策与预测/测量层

货币当局遵循含利率平滑、通胀、产出缺口和产出缺口增速反应的利率规则。实时预测实验为观测宏观变量和 SPF 预测增加测量与条件方程。这些不是优化问题，放在第 4 节和第 5 节。

## 3. First-Order Conditions

方程编号贯穿第 3-5 节。带帽变量表示相对稳态平衡增长路径的偏离。

- **(F1) 含习惯和风险溢价的消费 Euler 方程**：

$$
\widehat{c}_t
= c_1 E_t\widehat{c}_{t+1}
+ (1-c_1)\widehat{c}_{t-1}
- c_2\left(\widehat{r}_t-E_t\widehat{\pi}_{t+1}-\widehat{\varepsilon}^b_t\right),
$$

其中 $c_1=1/(1+h/\tau)$ 且 $c_2=(1-h/\tau)/(1+h/\tau)$。

- **(F2) 投资 Euler 方程**：

$$
\widehat{i}_t
= i_1\widehat{i}_{t-1}
+ (1-i_1)E_t\widehat{i}_{t+1}
+ i_2\widehat{q}^k_t
+ \widehat{\varepsilon}^q_t,
$$

其中 $i_1=1/(1+\beta)$ 且 $i_2=i_1/(\tau^2\varphi)$。

- **(F3) 安装资本价值**：

$$
\widehat{q}^k_t
= -\left(\widehat{r}_t-E_t\widehat{\pi}_{t+1}-\widehat{\varepsilon}^b_t\right)
+ q_1E_t\widehat{r}^k_{t+1}
+ (1-q_1)E_t\widehat{q}^k_{t+1},
$$

其中 $q_1=r^k/(r^k+1-\delta)$。

- **(F4) 带指数化的价格 Phillips 曲线**：

$$
\widehat{\pi}_t-\gamma_p\widehat{\pi}_{t-1}
= \pi_1\left(E_t\widehat{\pi}_{t+1}-\gamma_p\widehat{\pi}_t\right)
-\pi_2\left(\widehat{\mu}_{p,t}-\widehat{\mu}^n_{p,t}\right),
$$

其中 $\pi_1=\beta$ 且 $\pi_2=(1-\theta_p\beta)(1-\theta_p)/[\theta_p(1+(\phi_p-1)\varepsilon_p)]$。

- **(F5) 平均价格 markup / 实际边际成本关系**：

$$
\widehat{mc}_t
= (1-\alpha)(\widehat{w}_t-\widehat{p}_t)
+\alpha\widehat{r}^k_t
+\widehat{\varepsilon}^a_t,
\qquad
\widehat{\mu}_{p,t}\approx-\widehat{mc}_t.
$$

符号与 markup 归一化标记为 `needs_review`，因为 Markdown 在 inverse marginal-cost 句子附近有 OCR 噪声。

- **(F6) 自然价格 markup 冲击**：

$$
\widehat{\mu}^n_{p,t}=100\,\widehat{\varepsilon}^p_t.
$$

- **(F7) 带指数化的工资 Phillips 曲线**：

$$
\Delta\widehat{w}_t
= \gamma_w\widehat{\pi}_{t-1}
+\beta E_t\left(\Delta\widehat{w}_{t+1}-\gamma_w\widehat{\pi}_t\right)
-w_1\left(\widehat{\mu}_{w,t}-\widehat{\mu}^n_{w,t}\right),
$$

其中 $w_1=(1-\beta\theta_w)(1-\theta_w)/[\theta_w(1+\epsilon_w\omega)]$。

- **(F8) 平均工资 markup 与失业**：

$$
\widehat{\mu}_{w,t}
= \widehat{w}_t-\widehat{p}_t-\left(\widehat{z}_t+\widehat{\varepsilon}^s_t+\omega\widehat{e}_t\right)
= \omega\widehat{u}_t.
$$

- **(F9) 自然工资 markup / 自然失业率**：

$$
\widehat{\mu}^n_{w,t}=100\,\widehat{\varepsilon}^w_t
=\omega\widehat{u}^n_t.
$$

- **(F10) 进入劳动供给的平滑消费趋势**：

$$
\widehat{z}_t
=(1-\upsilon)\widehat{z}_{t-1}
+\frac{\upsilon}{1-h/\tau}
\left(\widehat{c}_t-\frac{h}{\tau}\widehat{c}_{t-1}\right).
$$

- **(F11) 资本利用率条件**：

$$
\widehat{v}_t=\frac{1-\psi}{\psi}\widehat{r}^k_t.
$$

- **(F12) 最优资本-劳动投入条件**：

$$
\widehat{k}_t
=\widehat{w}_t-\widehat{p}_t-\widehat{r}^k_t+\widehat{n}_t.
$$

## 4. Market Clearing & Identities

- **(F13) 总需求 / 资源约束**：

$$
\widehat{y}_t
=c_y\widehat{c}_t+i_y\widehat{i}_t+v_y\widehat{v}_t+\widehat{\varepsilon}^g_t.
$$

- **(F14) 总供给 / 生产函数**：

$$
\widehat{y}_t
=\phi_p\left(\alpha\widehat{k}_t+(1-\alpha)\widehat{n}_t+\widehat{\varepsilon}^a_t\right).
$$

- **(F15) 资本积累**：

$$
\widehat{\bar{k}}_t
=\kappa_1\widehat{\bar{k}}_{t-1}
+(1-\kappa_1)\widehat{i}_t
+\kappa_2\widehat{\varepsilon}^q_t,
$$

其中 $\kappa_1=(1-\delta)/\tau$ 且 $\kappa_2=(\tau+\delta-1)(1+\beta)\tau\varphi$。

- **(F16) 资本服务**：

$$
\widehat{k}_t=\widehat{v}_t+\widehat{\bar{k}}_{t-1}.
$$

- **(F17) 劳动力恒等式**：

$$
\widehat{l}_t=\widehat{e}_t+\widehat{u}_t.
$$

- **(F18) 就业调整 / 生产率连接方程**：

$$
\widehat{e}_t-\widehat{e}_{t-1}
=E_t\widehat{e}_{t+1}-\widehat{e}_t
+\frac{(1-\beta\theta_e)(1-\theta_e)}{\theta_e}
\left(\widehat{n}_t-\widehat{e}_t\right).
$$

- **(F19) 产出缺口定义**：

$$
\widehat{y}^{gap}_t=\widehat{y}_t-\widehat{y}^{flex}_t.
$$

弹性价格与弹性工资模块复制无名义 markup 扭曲时的结构方程；论文将缺口定义为实际产出相对弹性价格/工资经济的产出，但没有逐条列出所有 flex-block 方程。

- **(F20) 八个观测变量的测量方程**：

$$
\begin{bmatrix}
\Delta y_t\\
\Delta c_t\\
\Delta i_t\\
\pi_{y,t}\\
\Delta w_t-\pi_{y,t}\\
\Delta e_t\\
u_t\\
r_t
\end{bmatrix}
=
\begin{bmatrix}
\bar{\tau}+\bar{e}\\
\bar{\tau}+\bar{e}\\
\bar{\tau}+\bar{e}\\
\bar{\pi}\\
\bar{\tau}\\
\bar{e}\\
\bar{u}\\
4\bar{r}
\end{bmatrix}
+
\begin{bmatrix}
\Delta\widehat{y}_t\\
\Delta\widehat{c}_t\\
\Delta\widehat{i}_t\\
\widehat{\pi}_t\\
\Delta\widehat{w}_t-\Delta\widehat{\pi}_t\\
\Delta\widehat{e}_t\\
\widehat{u}_t\\
4\widehat{r}_t
\end{bmatrix}.
$$

第五行是 `needs_review`：论文印刷的测量向量与实现交叉检查文件在工资观测项是减通胀还是减通胀变化上存在差异。

- **(F21) 年通胀 SPF noise 测量示例**：

$$
\pi^a_{t+3|t}
=4\bar{\pi}
+E_t\left[\widehat{\pi}_{t+3}+\widehat{\pi}_{t+2}+\widehat{\pi}_{t+1}+\widehat{\pi}_{t}\right]
+\eta_{\pi,t}.
$$

类似的 noisy 测量方程也加入到三季度后 SPF 失业预测和两季度后年度实际 GDP 增长预测中。在 news 解释下，SPF 路径通过预期未来结构冲击作为条件信息施加，而不是作为 noisy measurement。

## 5. Exogenous Processes

论文说明了冲击列表以及 AR/ARMA 类型，表 2 报告了持续性与 MA 参数。实现交叉检查文件明确写出如下过程：

- **(F22) 风险溢价冲击**：

$$
\widehat{\varepsilon}^b_t=\rho_b\widehat{\varepsilon}^b_{t-1}+\eta^b_t.
$$

- **(F23) 投资专用技术冲击**：

$$
\widehat{\varepsilon}^q_t=\rho_q\widehat{\varepsilon}^q_{t-1}+\eta^q_t.
$$

- **(F24) 带生产率创新溢出的外生支出冲击**：

$$
\widehat{\varepsilon}^g_t=\rho_g\widehat{\varepsilon}^g_{t-1}+\eta^g_t+\rho_{ga}\eta^a_t.
$$

- **(F25) 生产率冲击**：

$$
\widehat{\varepsilon}^a_t=\rho_a\widehat{\varepsilon}^a_{t-1}+\eta^a_t.
$$

- **(F26) 价格 markup ARMA(1,1) 冲击**：

$$
\widehat{\varepsilon}^p_t
=\rho_p\widehat{\varepsilon}^p_{t-1}+\eta^p_t-\mu_p\eta^p_{t-1}.
$$

- **(F27) 工资 markup ARMA(1,1) 冲击**：

$$
\widehat{\varepsilon}^w_t
=\rho_w\widehat{\varepsilon}^w_{t-1}+\eta^w_t-\mu_w\eta^w_{t-1}.
$$

- **(F28) 劳动供给冲击**：

$$
\widehat{\varepsilon}^s_t=\rho_s\widehat{\varepsilon}^s_{t-1}+\eta^s_t.
$$

- **(F29) 货币政策冲击过程**：

$$
\widehat{\varepsilon}^r_t=\rho_r\widehat{\varepsilon}^r_{t-1}+\eta^r_t.
$$

- **(F30) 货币政策规则**：

$$
\widehat{r}_t
=\rho_R\widehat{r}_{t-1}
+(1-\rho_R)
\left(r_\pi\widehat{\pi}_t+r_y\widehat{y}^{gap}_t
+r_{\Delta y}\Delta\widehat{y}^{gap}_t\right)
+\widehat{\varepsilon}^r_t.
$$

实现交叉检查文件在 `epsilonr` 前使用负号；这个符号约定相对作者状态空间冲击定义标记为 `needs_review`。

## 6. Steady-State Solution

由于模型围绕平衡增长路径对数线性化，所有带帽结构变量的稳态均为零：

$$
\widehat{x}=0
\quad\text{for}\quad
x\in\{c,i,q^k,r,\pi,r^k,y,v,k,n,mc,w,z,u,e,l,\bar{k},y^{gap}\}.
$$

论文报告了测量方程使用的稳态变换：

$$
\bar{\tau}=100(\tau-1),\qquad
\bar{\pi}=100(\pi-1),
$$

$$
\bar{r}=100\left(\frac{\pi\tau}{\beta}-1\right),\qquad
\bar{u}=100\left(\frac{\phi_w-1}{\omega}\right).
$$

非估计的校准参数包括：

$$
g_y=0.18,\qquad \delta=0.025,\qquad \varepsilon_p=10.
$$

实现交叉检查文件使用的派生比率包括：

$$
i_y=(\tau+\delta-1)k_y,\qquad
c_y=1-i_y-g_y,\qquad
v_y=r^k k_y.
$$

本次归档未运行非线性稳态求解器或 Dynare check。

## 7. Timing & Form Conventions

- **线性形式**：所有模型方程均写为相对平衡增长路径的对数偏离或水平偏离，适合 `model(linear)`。
- **资本存量时序**：安装资本存量 $\widehat{\bar{k}}_t$ 为预定状态；生产中的资本服务使用 $\widehat{\bar{k}}_{t-1}$ 加当期利用率 $\widehat{v}_t$。
- **期望**：$E_t$ 以 $t$ 期信息为条件。
- **名义利率与通胀**：政策利率和通胀变量为偏离值；观测利率在测量方程中写作 $4\widehat{r}_t$ 加其年度化稳态值。
- **产出缺口**：$\widehat{y}^{gap}_t$ 是实际产出与弹性价格和工资对应产出的差。
- **SPF 条件信息**：noise 变体增加预测测量误差；news 变体将预测条件化于预期未来结构冲击。这些是估计/预测扩展，而不是不同的私人部门均衡模块。

## 8. Variable & Parameter Reference Table

### 内生变量

| Symbol | Meaning | Main equations |
|---|---|---|
| `c` | 消费偏离 $\widehat{c}_t$ | (F1), (F13), (F20) |
| `r` | 短期名义利率偏离 $\widehat{r}_t$ | (F1), (F3), (F30), (F20) |
| `pi` | 通胀偏离 $\widehat{\pi}_t$ | (F1), (F4), (F20), (F30) |
| `i` | 投资偏离 $\widehat{i}_t$ | (F2), (F13), (F15), (F20) |
| `q` | 资本价值 $\widehat{q}^k_t$ | (F2), (F3) |
| `rk` | 资本租金回报 $\widehat{r}^k_t$ | (F3), (F5), (F11), (F12) |
| `y` | 产出偏离 $\widehat{y}_t$ | (F13), (F14), (F19), (F20) |
| `v` | 资本利用率 $\widehat{v}_t$ | (F11), (F13), (F16) |
| `k` | 资本服务 $\widehat{k}_t$ | (F12), (F14), (F16) |
| `n` | 工作小时 $\widehat{n}_t$ | (F12), (F14), (F18) |
| `mc` | 实际边际成本 $\widehat{mc}_t$ | (F5) |
| `w` | 实际工资偏离 | (F7), (F8), (F12), (F20) |
| `z` | 平滑消费趋势 | (F8), (F10) |
| `u` | 失业偏离 | (F8), (F17), (F20) |
| `un` | 自然失业偏离 | (F9) |
| `e` | 就业偏离 | (F8), (F17), (F18), (F20) |
| `l` | 劳动力偏离 | (F17) |
| `kbar` | 安装资本存量 | (F15), (F16) |
| `ygap` | 产出缺口 | (F19), (F30) |
| `dyobs`, `dcobs`, `diobs`, `piobs`, `dwobs`, `deobs`, `uobs`, `robs` | 观测数据方程 | (F20) |
| `epsilonb`, `epsilonq`, `epsilong`, `epsilona`, `epsilonp`, `epsilons`, `epsilonw`, `epsilonr` | 结构冲击状态 | (F22)-(F29) |
| `cf`, `rf`, `invf`, `qf`, `rkf`, `vf`, `kf`, `nf`, `wf`, `zf`, `ef`, `kbarf`, `yf` | 弹性价格/工资对应变量 | (F19), implementation cross-check |

### 外生创新

| Symbol | Meaning |
|---|---|
| `etab` | 风险溢价创新 $\eta^b_t$ |
| `etaq` | 投资专用技术创新 $\eta^q_t$ |
| `etag` | 外生支出创新 $\eta^g_t$ |
| `etaa` | 生产率创新 $\eta^a_t$ |
| `etap` | 价格 markup 创新 $\eta^p_t$ |
| `etas` | 劳动供给创新 $\eta^s_t$ |
| `etaw` | 工资 markup 创新 $\eta^w_t$ |
| `etar` | 货币政策创新 $\eta^r_t$ |

### 参数

| Symbol | Meaning |
|---|---|
| `h` / `ch` | 习惯参数 |
| `tau` / `ctau` | 趋势增长率 |
| `beta` / `cbeta` | 贴现因子 |
| `varphi` / `cphi` | 资本调整成本弹性 |
| `delta` / `cdelta` | 折旧率 |
| `phi_p` / `cpsip` | 固定成本/生产尺度参数 |
| `alpha` / `calpha` | Cobb-Douglas 资本份额 |
| `gamma_p`, `theta_p`, `epsilon_p` | 价格指数化、Calvo 价格刚性、价格 aggregator 曲率 |
| `gamma_w`, `theta_w`, `epsilon_w` | 工资指数化、Calvo 工资刚性、工资 aggregator 曲率 |
| `omega` / `comega` | 劳动供给弹性倒数 |
| `upsilon` / `cv` | 短期财富效应平滑参数 |
| `psi` / `cpsi` | 资本利用成本弹性 |
| `rho_R`, `r_pi`, `r_y`, `r_Delta_y` | 货币政策规则系数 |
| `theta_e` | 就业调整参数 |
| `rho_*`, `mu_p`, `mu_w` | 冲击持续性与 MA 参数 |
| `bar_tau`, `bar_pi`, `bar_r`, `bar_u`, `bar_e` | 测量方程稳态常数 |
