# US_YR13AL - 推导（最优化问题与均衡条件）

> 供后续 Dynare 实现使用的模型档案草稿。状态：`needs_review`；未执行运行时验证。

来源：`US_YR13AL`，Yuliya Rychalovska (2016)，"The implications of financial frictions and imperfect knowledge in the estimated DSGE model of the U.S. economy"，*Journal of Economic Dynamics and Control* 73, 259-282，DOI `10.1016/j.jedc.2016.09.014`。源 Markdown：`raw/mmb_mineru/runs/us_yr13_us_yr13al__the_implications_of_financial_frictions_and_imperfect_knowledge_in_the_e__235aee23/full.md`。原始 PDF：`raw/mmb_papers/The implications of financial frictions and imperfect knowledge in the estimated dsge model of the U.S. economy.pdf`。MinerU run id：`235aee23-e4aa-4a58-8e02-dbb3676a7975`。

## 1. Model Overview

- **模型**：基于 Smets and Wouters (2007) 的美国中等规模 DSGE 模型，加入 Bernanke-Gertler-Gilchrist 金融加速器和适应性学习。
- **实验**：在理性预期和 Kalman-filter 适应性学习下进行贝叶斯估计和冲击传导比较。`US_YR13AL` 对应适应性学习的金融加速器规格。
- **主体**：家庭；最终品、中间品、劳动包装和资本品企业；企业家；银行；货币当局；外生财政/支出部门。
- **金融加速器**：企业家用净值和银行贷款为资本融资。代理摩擦产生取决于金融状况和外生风险溢价冲击的外部融资溢价。
- **学习模块**：主体预测七个前瞻变量：消费、投资、工时、价格通胀、工资通胀、资本回报率和资产价格。基准学习规格使用带常数项的 AR(2) 预测函数。
- **形式**：先对非线性模型去趋势，再围绕平稳稳态对数线性化。小写带帽变量表示对数偏离或平稳偏离。因此，下列档案方程是 `model(linear)` 风格的一阶草稿表示。
- **来源限制**：论文打印了金融加速器、学习、政策、资源约束和测量方程。其余微观基础引用 Smets and Wouters (2007)；当来源没有打印相应方程时，下文继承的家庭、价格、工资、生产和冲击方程标记为 `needs_review`。

## 2. Optimization Problems

### 2.1 资本品生产商

竞争性资本品生产商选择投资，并以价格 $Q_t$ 向企业家出售新资本。它们面对投资调整成本 $S(I_t/I_{t-1})$ 和投资专用技术冲击 $\varepsilon_t^i$：

$$
\max_{\{I_t\}} E_t\sum_{s=0}^{\infty}\beta^s\frac{\lambda_{t+s}}{\lambda_t}
\left[
Q_{t+s} I_{t+s}\varepsilon_{t+s}^i
- I_{t+s}
- Q_{t+s} I_{t+s}\varepsilon_{t+s}^i
S\left(\frac{I_{t+s}}{I_{t+s-1}}\right)
\right].
$$

### 2.2 企业家和银行

企业家风险中性，并以概率 $\varkappa$ 存活。在期末 $t$，企业家以价格 $Q_t$ 购买资本 $K_{t+1}$，资金来源为净值 $N_{t+1}$ 和银行借款：

$$
B_{t+1}=Q_tK_{t+1}-N_{t+1}.
$$

观察到下一期冲击后，企业家选择利用率 $U_{t+1}$：

$$
\max_{U_{t+1}}\left[r^k_{t+1}U_{t+1}-a(U_{t+1})\right]\omega K_{t+1}.
$$

银行以无风险利率从家庭吸收存款并向企业家贷款。 costly state verification 产生外部融资溢价。

### 2.3 适应性学习

结构系统写作：

$$
A_0
\begin{bmatrix} y_{t-1}\\ w_{t-1}\end{bmatrix}
+ A_1
\begin{bmatrix} y_t\\ w_t\end{bmatrix}
+ A_2 E_t y_{t+1}
+ B_0\epsilon_t
= \text{const.}
$$

主体不知道 RE 运动法则。每个前瞻变量 $j$ 使用感知运动法则：

$$
y^f_{j,t}=\beta_{j,t-1}X_{j,t-1}+u_{j,t}.
$$

信念向量通过 Kalman filter 更新，然后用于在结构方程中计算预期。

## 3. First-Order Conditions

- **(F1) 资本品生产商 Tobin's Q 条件**：

$$
\varepsilon_t^i Q_t\left(1-S\left(\frac{I_t}{I_{t-1}}\right)\right)
= 1
+ \varepsilon_t^i Q_t S'\left(\frac{I_t}{I_{t-1}}\right)\frac{I_t}{I_{t-1}}
- E_t\left[
\beta\frac{\lambda_{t+1}}{\lambda_t}
\varepsilon_{t+1}^i Q_{t+1}
S'\left(\frac{I_{t+1}}{I_t}\right)
\left(\frac{I_{t+1}}{I_t}\right)^2
\right].
$$

- **(F2) 由 (F1) 得到的对数线性投资动态**：

$$
\widehat{i}_t =
\frac{1}{1+\bar{\beta}\gamma}
\left(
\widehat{i}_{t-1}
+\bar{\beta}\gamma E_t\widehat{i}_{t+1}
+\frac{1}{\gamma^2 S''}\widehat{Q}_t
\right)
+\widehat{q}_t.
$$

- **(F3) 资本积累，对数线性化**：

$$
\widehat{k}_t
=
\left(1-\frac{i_*}{\bar{k}_*}\right)\widehat{k}_{t-1}
+\frac{i_*}{\bar{k}_*}\widehat{i}_t
+\frac{i_*}{\bar{k}_*}(1+\bar{\beta}\gamma)\gamma^2 S''\widehat{q}_t.
$$

- **(F4) 利用率选择**：

$$
r^k_{t+1}=a'(U_{t+1}).
$$

- **(F5) 利用率条件，对数线性化**：

$$
\widehat{u}_t=\frac{1-\psi}{\psi}\widehat{r}^k_t.
$$

- **(F6) 资本服务**：

$$
\widehat{k}^S_{t+1}=\widehat{u}_{t+1}+\widehat{k}_{t+1}.
$$

- **(F7) 预期资本回报率**：

$$
E_t R^k_{t+1}
=E_t\left[
\frac{
r^k_{t+1}U_{t+1}-a(U_{t+1})+Q_{t+1}(1-\tau)
}{Q_t}
\right].
$$

- **(F8) 预期资本回报率，对数线性化**：

$$
E_t\widehat{R}^K_{t+1}
=
\frac{1-\tau}{\bar{R}^K}E_t\widehat{Q}_{t+1}
+\frac{\bar{r}^k}{\bar{R}^K}E_t\widehat{r}^k_{t+1}
-\widehat{Q}_t.
$$

- **(F9) 金融合约 / 外部融资溢价**：

$$
E_t R^k_{t+1}
=
E_t\left[
s\left(\frac{N_{t+1}}{Q_tK_{t+1}}\right)
\varepsilon_t^b R_t
\right].
$$

- **(F10) 外部融资溢价，对数线性化**：

$$
E_t\widehat{R}^K_{t+1}
=
-el\,E_t\left[\widehat{N}_{t+1}-\widehat{Q}_t-\widehat{k}_{t+1}\right]
+\widehat{R}_t+\widehat{b}_t.
$$

- **(F11) 企业家净值积累**：

$$
N_{t+1}
=
\varkappa\left[
R_t^KQ_{t-1}K_t
-E_{t-1}R_t^K(Q_{t-1}K_t-N_t)
\right]
+W_t^e.
$$

- **(F12) 净值，对数线性化**：

$$
\widehat{N}_{t+1}
=
\varkappa\bar{R}^K
\left[
\frac{\bar{K}}{\bar{N}}
\left(\widehat{R}_t^K-E_{t-1}\widehat{R}_t^K\right)
+E_{t-1}\widehat{R}_t^K
+\widehat{N}_t
\right].
$$

- **(F13) 代入融资溢价后的净值方程**：

$$
\widehat{N}_{t+1}
=
\varkappa\bar{R}^K
\left[
\frac{\bar{K}}{\bar{N}}\widehat{R}_t^K
-\left(\frac{\bar{K}}{\bar{N}}-1\right)(\widehat{R}_{t-1}+\widehat{b}_{t-1})
-el\left(\frac{\bar{K}}{\bar{N}}-1\right)
(\widehat{k}_t+\widehat{Q}_{t-1}-\widehat{N}_t)
+\widehat{N}_t
\right].
$$

- **(F14) 货币政策规则**：

$$
\widehat{R}^n_t
=
\rho_R\widehat{R}^n_{t-1}
+(1-\rho_R)(r_\pi\widehat{\pi}_t+r_y\widehat{ygap}_t)
+r_{\Delta y}(\widehat{ygap}_t-\widehat{ygap}_{t-1})
+\epsilon_{r,t}.
$$

- **(F15) 产出缺口定义**：

$$
\widehat{ygap}_t=\widehat{y}_t-\widehat{A}_t.
$$

- **(F16) 无风险实际利率定义**：

$$
\widehat{R}_t=\widehat{R}^n_t-E_t\widehat{\pi}_{t+1}.
$$

- **(F17) 继承自 Smets-Wouters 的家庭 Euler 方程（`needs_review`）**：

$$
E_t\widehat{c}_{t+1}=\mathcal{E}_c(\widehat{c}_t,\widehat{c}_{t-1},\widehat{R}_t,\widehat{g}_t,\widehat{\varepsilon}^b_t;\Theta_{SW}).
$$

- **(F18) 继承自 Smets-Wouters 的价格 Phillips 曲线（`needs_review`）**：

$$
\widehat{\pi}_t=\mathcal{P}(\widehat{\pi}_{t-1},E_t\widehat{\pi}_{t+1},\widehat{mc}_t,\widehat{\varepsilon}^p_t;\Theta_{SW}).
$$

- **(F19) 继承自 Smets-Wouters 的工资 Phillips 曲线（`needs_review`）**：

$$
\widehat{\pi}^w_t=\mathcal{W}(\widehat{\pi}^w_{t-1},E_t\widehat{\pi}^w_{t+1},\widehat{w}_t,\widehat{l}_t,\widehat{\varepsilon}^w_t;\Theta_{SW}).
$$

- **(F20) 继承自 Smets-Wouters 的劳动供需和生产模块（`needs_review`）**：

$$
(\widehat{y}_t,\widehat{l}_t,\widehat{w}_t,\widehat{mc}_t,\widehat{r}^k_t)
=\mathcal{S}(\widehat{k}^S_t,\widehat{A}_t,\widehat{u}_t;\Theta_{SW}).
$$

## 4. Market Clearing & Identities

- **(F21) 资源约束，对数线性化**：

$$
\widehat{y}_t
=
\frac{(\bar{R}^K-1+\tau)k_*}{y_*}\widehat{u}_t
+\widehat{\mu}^{bank}_t
+\frac{c_*}{y_*}\widehat{c}_t
+\frac{i_*}{y_*}\widehat{i}_t
+\widehat{g}_t.
$$

- **(F22) 银行资源楔子**：

$$
\widehat{\mu}^{bank}_t
=
\frac{k_*}{y_*}(\bar{R}^K-\bar{R})
\left(1-\frac{\bar{N}}{\bar{K}}\right)
(\widehat{R}^K_t+\widehat{Q}_{t-1}+\widehat{k}_t).
$$

- **(F23) 测量方程**：

$$
\begin{bmatrix}
dlGdp_t\\ dlCons_t\\ dlInv_t\\ dlWage_t\\ lHours_t\\ dlP_t\\ FedFundsR_t
\end{bmatrix}
=
\begin{bmatrix}
\bar{\gamma}_y\\ \bar{\gamma}_c\\ \bar{\gamma}_i\\ \bar{\gamma}_w\\ \bar{l}\\ \bar{\pi}\\ \bar{r}
\end{bmatrix}
+
\begin{bmatrix}
\widehat{y}_t-\widehat{y}_{t-1}\\
\widehat{c}_t-\widehat{c}_{t-1}\\
\widehat{i}_t-\widehat{i}_{t-1}\\
\widehat{w}_t-\widehat{w}_{t-1}\\
\widehat{l}_t\\
\widehat{\pi}_t\\
\widehat{R}^n_t
\end{bmatrix}.
$$

## 5. Exogenous Processes

- **(F24) 一般外生状态向量**：

$$
w_t=\Gamma w_{t-1}+\Pi\epsilon_t.
$$

- **(F25) 投资专用技术冲击**：

$$
\widehat{q}_t=\rho_q\widehat{q}_{t-1}+\epsilon^i_t.
$$

- **(F26) 政府支出冲击**：

$$
\widehat{g}_t=\rho_g\widehat{g}_{t-1}+\rho_{ga}\epsilon^a_t+\epsilon^g_t.
$$

- **(F27) 其余 Smets-Wouters 冲击（`needs_review`）**：

$$
(\widehat{A}_t,\widehat{b}_t,\widehat{\varepsilon}^p_t,\widehat{\varepsilon}^w_t)
=\mathcal{X}((\widehat{A}_{t-1},\widehat{b}_{t-1},\widehat{\varepsilon}^p_{t-1},\widehat{\varepsilon}^w_{t-1}),\epsilon_t;\Theta_{SW}).
$$

- **(F28) 学习下前瞻变量的感知运动法则**：

$$
y^f_{j,t}=\beta_{j,t-1}X_{j,t-1}+u_{j,t}.
$$

- **(F29) Kalman 信念更新**：

$$
\beta_{t/t}=\beta_{t/t-1}+K_t\widetilde{z}_t,
\qquad
P_{t/t}=(I-K_tX_{t-1})P_{t/t-1}.
$$

- **(F30) 信念预测步骤**：

$$
(\beta_t-\bar{\beta})=F(\beta_{t-1}-\bar{\beta})+v_t.
$$

- **(F31) 适应性学习下的实际运动法则**：

$$
\begin{bmatrix}y_t\\w_t\end{bmatrix}
=
\mu_t+
T_t\begin{bmatrix}y_{t-1}\\w_{t-1}\end{bmatrix}
+R_t\epsilon_t.
$$

## 6. Steady-State Solution

论文使用去趋势变量，并围绕平稳稳态对数线性化。在线性化档案表示中，所有带帽内生变量和冲击的稳态为零：

$$
\widehat{x}=0
\quad\text{for}\quad
x\in\{c,i,k,u,k^S,Q,R^K,R^n,R,\pi,\pi^w,l,w,mc,y,N,b,q,g,A\}.
$$

来源报告了以下稳态对象或关系：

1. 确定性趋势为 $\gamma$，且 $\bar{\beta}=\beta/\gamma^{\sigma_c}$。
2. 测量方程中的稳态名义利率为 $\bar{r}=100(\bar{\gamma}^{\sigma_c}II_*/\beta-1)`.
3. 决定稳态杠杆和溢价动态的金融摩擦参数为 $\bar{K}/\bar{N}$、$\varkappa$ 和 $el$。
4. 学习模型从与 REE 一致的初始信念开始。在初始稳态处，学习 ALM 与 RE 解一致；后续动态来自信念更新。

Needs review：论文没有打印消费、劳动、工资、边际成本、价格和工资加成模块的完整 Smets-Wouters 稳态构造，也没有打印完整的校准/估计稳态比例 $c_*/y_*$、$i_*/y_*$、$k_*/y_*$。

## 7. Timing & Form Conventions

- 资本在期末 $t$ 以价格 $Q_t$ 购买为 $K_{t+1}$；在 $t+1$ 提供的资本服务为 $K^S_{t+1}=U_{t+1}K_{t+1}$。
- 企业家净值 $N_{t+1}$ 为购买 $K_{t+1}$ 融资；贷款为 $B_{t+1}=Q_tK_{t+1}-N_{t+1}$。
- 净值由上一份合约延续的实现和预期回报决定，因此 (F12) 和 (F13) 混合了 $t+1$、$t$ 和 $t-1$ 时序。
- $R^n_t$ 是名义无风险利率；在线性化项中 $R_t=R^n_t-E_t\pi_{t+1}$。
- 变量在对数线性化前先用确定性劳动增强趋势 $\gamma$ 去趋势。
- 带帽变量是围绕平稳稳态的偏离。来源中的小写变量表示去趋势实际变量。
- `US_YR13AL` 应实现为线性化模型。未来运行时实现必须决定是直接编码适应性学习系统，还是使用学习工具箱生成的固定约简形式表示。

## 8. Variable & Parameter Reference Table

| 类别 | 符号 / ASCII 候选名 | 含义 | 方程覆盖 |
|---|---|---|---|
| 内生 | `c` / $\widehat{c}_t$ | 消费 | (F17), (F23), needs_review |
| 内生 | `i` / $\widehat{i}_t$ | 投资 | (F2), (F21), (F23) |
| 内生 | `k` / $\widehat{k}_t$ | 资本存量 | (F3), (F13), (F22) |
| 内生 | `u` / $\widehat{u}_t$ | 利用率 | (F5), (F21) |
| 内生 | `ks` / $\widehat{k}^S_t$ | 资本服务 | (F6), (F20) |
| 内生 | `q` / $\widehat{Q}_t$ | 资产价格 / Tobin's Q | (F1), (F2), (F8), (F10), (F13) |
| 内生 | `rk` / $\widehat{R}^K_t$ | 资本回报率 | (F7), (F8), (F10), (F12), (F13) |
| 内生 | `r` / $\widehat{R}_t$ | 实际无风险利率 | (F10), (F13), (F16) |
| 内生 | `rn` / $\widehat{R}^n_t$ | 名义政策利率 | (F14), (F16), (F23) |
| 内生 | `n` / $\widehat{N}_t$ | 企业家净值 | (F9), (F11), (F12), (F13) |
| 内生 | `y` / $\widehat{y}_t$ | 产出 | (F15), (F21), (F23) |
| 内生 | `ygap` / $\widehat{ygap}_t$ | 产出缺口 | (F14), (F15) |
| 内生 | `pi` / $\widehat{\pi}_t$ | 价格通胀 | (F14), (F16), (F18), (F23), needs_review |
| 内生 | `piw` / $\widehat{\pi}^w_t$ | 工资通胀 | (F19), needs_review |
| 内生 | `w` / $\widehat{w}_t$ | 实际工资 | (F19), (F20), (F23), needs_review |
| 内生 | `l` / $\widehat{l}_t$ | 工时 | (F19), (F20), (F23), needs_review |
| 内生 | `mc` / $\widehat{mc}_t$ | 边际成本 | (F18), (F20), needs_review |
| 内生 | `mubank` / $\widehat{\mu}^{bank}_t$ | 银行资源楔子 | (F21), (F22) |
| 外生 / 冲击 | `eps_i`, `q` | 投资专用技术创新/过程 | (F25) |
| 外生 / 冲击 | `eps_g`, `g` | 政府支出创新/过程 | (F26) |
| 外生 / 冲击 | `eps_a`, `a` | 生产率创新/过程 | (F15), (F20), (F26), (F27), needs_review |
| 外生 / 冲击 | `eps_b`, `b` | 外生风险溢价创新/过程 | (F9), (F10), (F13), (F27), needs_review |
| 外生 / 冲击 | `eps_r` | 货币政策创新 | (F14) |
| 外生 / 冲击 | `eps_p` | 价格加成创新 | (F18), (F27), needs_review |
| 外生 / 冲击 | `eps_w` | 工资加成创新 | (F19), (F27), needs_review |
| 参数 | `betta`, `gammma`, `sigma_c` | 折现、趋势增长、消费曲率 | (F1), (F2), (F6) |
| 参数 | `Spp`, `tau`, `psi` | 调整成本弹性、折旧、利用率成本弹性 | (F2), (F3), (F5), (F7) |
| 参数 | `kappa`, `K_N`, `el` | 存活率、资本净值比、溢价弹性 | (F10), (F12), (F13) |
| 参数 | `rho_R`, `r_pi`, `r_y`, `r_Dy` | Taylor 规则系数 | (F14) |
| 参数 | `rho_q`, `rho_g`, `rho_ga` | 外生过程持续性/载荷 | (F25), (F26) |
| 学习 | `beta_j`, `X_j`, `P`, `K_gain`, `rho` | 感知运动法则和 Kalman-filter 信念对象 | (F28), (F29), (F30), (F31) |

本草稿中的方程数：31 个编号方程。若干继承的 Smets-Wouters 模块仍为占位项，并有意标记为 `needs_review`。
