# US_CCTW10 - 推导（最优化问题 + 一阶条件）

> 本推导用于私有 MMB 模型档案。它从论文侧来源提取 Cogan, Cwik, Taylor, and Wieland (2010) 财政刺激模型条目。论文说明核心模型是 Smets-Wouters (2007) 美国模型，并且只重新列出规则型家庭和财政政策扩展；因此，下文中来自 MMB `.mod` 交叉检查、而不是 CCTW 论文印刷方程的其余 Smets-Wouters 方程，均标记为 `implementation_cross_check`/`needs_review`。

## 1. Model Overview

- **模型 ID**：`US_CCTW10`。
- **论文**：John F. Cogan, Tobias Cwik, John B. Taylor, and Volker Wieland (2010), "New Keynesian versus old Keynesian government spending multipliers," Journal of Economic Dynamics and Control 34(3), 281-295, DOI `10.1016/j.jedc.2010.01.010`。
- **来源文件**：`raw/mmb_mineru/runs/us_cctw10__new_keynesian_versus_old_keynesian_government_spending_multipliers__da0c2db2/full.md`；原始 PDF `raw/mmb_papers/New keynesian versus old keynesian government spending multipliers.pdf`；MMB 实现交叉检查 `.agents/skills/dynare-copilot/references/examples/US_CCTW10_rep.mod`。
- **实验**：ARRA 政府购买路径，并在 MMB 文件中对前四个季度设置货币政策哑变量利率钉住。财政冲击 `fiscal_` 直接作为外生政府支出路径给定。
- **主体和模块**：Ricardian 家庭、规则型家庭、工会/粘性工资、具有粘性价格的中间品/最终品企业、含资本利用和投资调整成本的资本积累、政府债务/税收，以及货币政策规则。
- **形式**：去趋势/对数线性化的稳态偏离模型。CCTW 附录明确对新增的规则型家庭和财政方程做对数线性化。MMB 交叉检查在 Dynare 中使用线性方程但没有写 `model(linear)`，所以本条目把数学形式记录为对数线性，把运行时形式标为 needs_review。
- **状态**：第一轮 `needs_review`。未执行运行时验证。

## 2. Optimization Problems

### 2.1 Ricardian 家庭

比例为 $1-\omega$、以 $j$ 为索引的家庭可以进入金融市场，积累实物资本并租给企业，获得工资和分红收入，并支付一次总付税。CCTW 说明其问题为 Smets-Wouters 家庭问题。用档案中的紧凑记号表示为：

$$
\max_{\{C_{j,t},L_{j,t},B_{j,t},K_{j,t},I_{j,t}\}} E_0 \sum_{t=0}^{\infty}\beta^t
U(C_{j,t},C_{j,t-1},L_{j,t})
$$

约束包括跨期预算约束、资本积累和资本利用成本。CCTW 论文没有重新列出精确的 Smets-Wouters 效用函数和约束；因此下文对应的对数线性 Euler、投资、资本价格、工资和资源约束方程均为 `implementation_cross_check`，并且相对于 Smets-Wouters (2007) `needs_review`。

### 2.2 规则型家庭

比例为 $\omega$、以 $i$ 为索引的家庭不交易资产，每期消费可支配劳动收入：

$$
C_{i,t} = \frac{W_t^h L_t}{P_t} - \frac{T_{i,t}}{P_t}.
$$

### 2.3 企业和工资制定者

企业和工会采用 Smets-Wouters 粘性价格/粘性工资结构，包括 Kimball aggregator、价格指数化、工资指数化、资本利用和投资调整成本。CCTW 未复述完整的企业和工资设定最优化系统；第 3 和第 4 节中这些模块的方程来自 MMB 实现交叉检查，并需要与 Smets-Wouters (2007) 做来源级复核。

### 2.4 政府和货币当局

政府购买最终品 $G_t$，发行一期债券 $B_t$，并征收一次总付税 $T_t$。政府预算约束为：

$$
P_t G_t + B_{t-1} = T_t + \frac{B_t}{R_t}.
$$

税收遵循对债务和政府支出作出反应的对数线性财政规则。货币当局遵循 MMB 政策规则；当 `dummy_MP=1` 时，名义利率观测变量被钉住。

## 3. First-Order Conditions

以下方程使用去趋势/对数线性记号。CCTW 附录使用帽子时，带帽变量表示相对稳态的百分比或对数偏离。MMB 交叉检查使用不带帽子的 ASCII 变量名。

- **(F1) 灵活经济边际成本关系**（`implementation_cross_check`, needs_review）：

$$
a_t = \alpha r^k_{f,t} + (1-\alpha) w_{f,t}.
$$

- **(F2) 灵活经济资本利用**（`implementation_cross_check`, needs_review）：

$$
z^k_{f,t} = \frac{1-\zeta}{\zeta} r^k_{f,t},
$$

其中 MMB 文件把该系数实现为 $1/(\zeta/(1-\zeta))$。

- **(F3) 灵活经济资本租赁率**（`implementation_cross_check`, needs_review）：

$$
r^k_{f,t} = w_{f,t} + l_{f,t} - k_{f,t}.
$$

- **(F4) 灵活经济生产中使用的已安装资本**（`implementation_cross_check`, needs_review）：

$$
k_{f,t} = k^p_{f,t-1} + z^k_{f,t}.
$$

- **(F5) 灵活经济投资 Euler 方程**（`implementation_cross_check`, needs_review）：

$$
i_{f,t} =
\frac{1}{1+\bar{\beta}\gamma}
\left(i_{f,t-1}+\bar{\beta}\gamma E_t i_{f,t+1}
+\frac{1}{\gamma^2 S''}\,p^k_{f,t}\right)+q^s_t.
$$

- **(F6) 灵活经济资本价值**（`implementation_cross_check`, needs_review）：

$$
p^k_{f,t} =
-r^r_{f,t}
+\frac{1}{\eta_c} b_t
+\frac{\bar{r}^k}{\bar{r}^k+1-\delta}E_t r^k_{f,t+1}
+\frac{1-\delta}{\bar{r}^k+1-\delta}E_t p^k_{f,t+1},
$$

其中 $\eta_c=(1-h/\gamma)/[\sigma_c(1+h/\gamma)]$。

- **(F7) 灵活经济 Ricardian 消费 Euler 方程**（`implementation_cross_check`, needs_review）：

$$
c_{j,f,t} =
\frac{h/\gamma}{1+h/\gamma}c_{j,f,t-1}
+\frac{1}{1+h/\gamma}E_t c_{j,f,t+1}
+\frac{(\sigma_c-1)\bar{w}\bar{l}/\bar{c}}{\sigma_c(1+h/\gamma)}
(l_{f,t}-E_t l_{f,t+1})
-\frac{1-h/\gamma}{\sigma_c(1+h/\gamma)}r^r_{f,t}+b_t.
$$

- **(F8) 灵活经济规则型家庭消费**：

$$
c_{i,f,t} =
\frac{\bar{W}^h\bar{L}}{\bar{C}}(w_{f,t}+l_{f,t})
-\frac{\bar{Y}}{\bar{C}}t_{f,t}.
$$

- **(F9) 灵活经济总消费**：

$$
c_{f,t}=(1-\omega)c_{j,f,t}+\omega c_{i,f,t}.
$$

- **(F10) 灵活经济工资/劳动供给条件**（`implementation_cross_check`, needs_review）：

$$
w_{f,t} =
\sigma_l l_{f,t}
+\frac{1}{1-h/\gamma}c_{j,f,t}
-\frac{h/\gamma}{1-h/\gamma}c_{j,f,t-1}.
$$

- **(F11) 粘性经济边际成本**（`implementation_cross_check`, needs_review）：

$$
mc_t = \alpha r^k_t + (1-\alpha)w_t - a_t.
$$

- **(F12) 粘性经济资本利用**（`implementation_cross_check`, needs_review）：

$$
z^k_t = \frac{1-\zeta}{\zeta}r^k_t.
$$

- **(F13) 粘性经济资本租赁率**（`implementation_cross_check`, needs_review）：

$$
r^k_t = w_t + l_t - k_t.
$$

- **(F14) 粘性经济生产中使用的已安装资本**（`implementation_cross_check`, needs_review）：

$$
k_t = k^p_{t-1}+z^k_t.
$$

- **(F15) 粘性经济投资 Euler 方程**（`implementation_cross_check`, needs_review）：

$$
i_t =
\frac{1}{1+\bar{\beta}\gamma}
\left(i_{t-1}+\bar{\beta}\gamma E_t i_{t+1}
+\frac{1}{\gamma^2 S''}p^k_t\right)+q^s_t.
$$

- **(F16) 粘性经济资本价值/套利方程**（`implementation_cross_check`, needs_review）：

$$
p^k_t =
-r_t+E_t\pi_{t+1}
+\frac{1}{\eta_c}b_t
+\frac{\bar{r}^k}{\bar{r}^k+1-\delta}E_t r^k_{t+1}
+\frac{1-\delta}{\bar{r}^k+1-\delta}E_t p^k_{t+1}.
$$

- **(F17) 粘性经济 Ricardian 消费 Euler 方程**（`implementation_cross_check`, needs_review）：

$$
c_{j,t} =
\frac{h/\gamma}{1+h/\gamma}c_{j,t-1}
+\frac{1}{1+h/\gamma}E_t c_{j,t+1}
+\frac{(\sigma_c-1)\bar{w}\bar{l}/\bar{c}}{\sigma_c(1+h/\gamma)}
(l_t-E_t l_{t+1})
-\frac{1-h/\gamma}{\sigma_c(1+h/\gamma)}(r_t-E_t\pi_{t+1})
+b_t.
$$

- **(F18) 粘性经济规则型家庭消费**：

$$
c_{i,t} =
\frac{\bar{W}^h\bar{L}}{\bar{C}}(w_t+l_t)
-\frac{\bar{Y}}{\bar{C}}t_t.
$$

- **(F19) 粘性经济总消费**：

$$
c_t=(1-\omega)c_{j,t}+\omega c_{i,t}.
$$

- **(F20) 价格 Phillips 曲线**（`implementation_cross_check`, needs_review）：

$$
\pi_t =
\frac{1}{1+\bar{\beta}\gamma\iota_p}
\left[
\bar{\beta}\gamma E_t\pi_{t+1}
+\iota_p\pi_{t-1}
+\kappa_p mc_t
\right]+s^\pi_t.
$$

- **(F21) 工资 Phillips 曲线**（`implementation_cross_check`, needs_review）：

$$
w_t =
\frac{1}{1+\bar{\beta}\gamma}w_{t-1}
+\frac{\bar{\beta}\gamma}{1+\bar{\beta}\gamma}E_t w_{t+1}
+\frac{\iota_w}{1+\bar{\beta}\gamma}\pi_{t-1}
-\frac{1+\bar{\beta}\gamma\iota_w}{1+\bar{\beta}\gamma}\pi_t
+\frac{\bar{\beta}\gamma}{1+\bar{\beta}\gamma}E_t\pi_{t+1}
+\kappa_w\left(\sigma_l l_t+\frac{c_{j,t}}{1-h/\gamma}
-\frac{h/\gamma}{1-h/\gamma}c_{j,t-1}-w_t\right)+s^w_t.
$$

## 4. Market Clearing & Identities

- **(F22) 灵活经济资源约束**（`implementation_cross_check`, needs_review）：

$$
y_{f,t} = c_y c_{f,t}+i_y i_{f,t}+g_t+\bar{r}^k k_y z^k_{f,t}.
$$

- **(F23) 灵活经济生产函数**（`implementation_cross_check`, needs_review）：

$$
y_{f,t} = \Phi\left(\alpha k_{f,t}+(1-\alpha)l_{f,t}+a_t\right).
$$

- **(F24) 灵活经济已安装资本积累**（`implementation_cross_check`, needs_review）：

$$
k^p_{f,t}=(1-\bar{i}/\bar{k})k^p_{f,t-1}
+(\bar{i}/\bar{k})i_{f,t}
+(\bar{i}/\bar{k})\gamma^2 S''q^s_t.
$$

- **(F25) 灵活经济政府预算约束**：

$$
b_{f,t}=R_\ast\left(\frac{b_{f,t-1}}{\pi_\ast}+g_t-t_{f,t}\right).
$$

- **(F26) 灵活经济财政规则**：

$$
t_{f,t}=\phi_b b_{f,t-1}+\phi_g g_t.
$$

- **(F27) 粘性经济总资源约束**（`implementation_cross_check`, needs_review）：

$$
y_t = c_y c_t+i_y i_t+g_t+\bar{r}^k k_y z^k_t.
$$

- **(F28) 粘性经济生产函数**（`implementation_cross_check`, needs_review）：

$$
y_t = \Phi\left(\alpha k_t+(1-\alpha)l_t+a_t\right).
$$

- **(F29) 粘性经济已安装资本积累**（`implementation_cross_check`, needs_review）：

$$
k^p_t=(1-\bar{i}/\bar{k})k^p_{t-1}
+(\bar{i}/\bar{k})i_t
+(\bar{i}/\bar{k})\gamma^2 S''q^s_t.
$$

- **(F30) 粘性经济政府预算约束**：

$$
b_t=R_\ast\left(\frac{b_{t-1}}{\pi_\ast}+g_t-t_t\right).
$$

- **(F31) 粘性经济财政规则**：

$$
t_t=\phi_b b_{t-1}+\phi_g g_t.
$$

- **(F32) 带钉住哑变量的货币政策规则**：

$$
i_t^{obs} =
d^{MP}_t\cdot 0+(1-d^{MP}_t)
\left(\rho_i i_{t-1}^{obs}+\phi_{\pi,0}\pi^{(4)}_t+\phi_y(y_t-y_{f,t})+\phi_{y,-1}(y_{t-1}-y_{f,t-1})\right).
$$

- **(F33) Modelbase 产出缺口恒等式**：

$$
gap_t=y_t-y_{f,t}.
$$

- **(F34) 通胀和利率观测变量**（`implementation_cross_check`, needs_review）：

$$
\pi^{obs}_t=\pi_t+\bar{\pi},\quad
\pi^{(4)}_t=\pi_t+\pi_{t-1}+\pi_{t-2}+\pi_{t-3},\quad
r^{obs}_t=r_t+\bar{r}.
$$

- **(F35) 增长率观测变量**（`implementation_cross_check`, needs_review）：

$$
\Delta y_t=y_t-y_{t-1}+\bar{\gamma},\quad
\Delta c_t=c_t-c_{t-1}+\bar{\gamma},\quad
\Delta i_t=i_t-i_{t-1}+\bar{\gamma},\quad
\Delta w_t=w_t-w_{t-1}+\bar{\gamma}.
$$

## 5. Exogenous Processes

- **(F36) 技术冲击**（`implementation_cross_check`, needs_review）：

$$
a_t=\rho_a a_{t-1}+\varepsilon^a_t.
$$

- **(F37) 偏好/风险溢价冲击**（`implementation_cross_check`, needs_review）：

$$
b_t^{pref}=\rho_b b_{t-1}^{pref}+\varepsilon^b_t.
$$

- **(F38) 政府购买路径**：

$$
g_t=fiscal_t.
$$

- **(F39) 投资专有冲击**（`implementation_cross_check`, needs_review）：

$$
q^s_t=\rho_{qs}q^s_{t-1}+\varepsilon^{qs}_t.
$$

- **(F40) 货币政策冲击过程**（`implementation_cross_check`, needs_review）：

$$
m_t=\rho_m m_{t-1}+\varepsilon^m_t.
$$

- **(F41) 价格加成冲击**（`implementation_cross_check`, needs_review）：

$$
s^\pi_t=\rho_\pi s^\pi_{t-1}+\varepsilon^\pi_t-\mu_\pi\varepsilon^\pi_{t-1}.
$$

- **(F42) 工资加成冲击**（`implementation_cross_check`, needs_review）：

$$
s^w_t=\rho_w s^w_{t-1}+\varepsilon^w_t-\mu_w\varepsilon^w_{t-1}.
$$

- **(F43) 政策钉住哑变量路径**：

$$
d^{MP}_t =
\begin{cases}
1, & t=1,\ldots,4,\\
0, & \text{otherwise.}
\end{cases}
$$

## 6. Steady-State Solution

由于归档模型为对数线性/去趋势形式，内生模型变量的稳态偏离为零：

$$
\bar{a}=\bar{b}^{pref}=\bar{g}=\bar{q}^s=\bar{m}=\bar{s}^{\pi}=\bar{s}^{w}=0,
\quad
\bar{c}_{i}=\bar{c}_{j}=\bar{c},\quad
\bar{b}^{gov}=0.
$$

论文说明了规则型家庭扩展中的相等消费和零债务稳态假设：

$$
C_i=C_j=C,\qquad B=0.
$$

MMB 实现在 model 块之前计算非零稳态比率和常数。来源支持的计算顺序为：

1. 设定季度稳态通胀和趋势增长：

$$
\pi_\ast = 1+\frac{\bar{\pi}^{obs}}{100},\qquad
\gamma = 1+\frac{\bar{\gamma}^{obs}}{100}.
$$

2. 设定贴现和趋势调整贴现因子：

$$
\beta=\frac{1}{1+\bar{\beta}^{obs}/100},\qquad
\bar{\beta}=\beta\gamma^{-\sigma_c}.
$$

3. 计算稳态名义回报和资本租赁回报：

$$
R_\ast=\frac{\pi_\ast}{\beta\gamma^{-\sigma_c}},\qquad
\bar{r}^k=\beta^{-1}\gamma^{\sigma_c}-(1-\delta).
$$

4. 计算工资、资本产出比、投资产出比和消费产出比：

$$
\bar{w} =
\left[
\frac{\alpha^\alpha(1-\alpha)^{1-\alpha}}{\lambda_p(\bar{r}^k)^\alpha}
\right]^{1/(1-\alpha)},\quad
\frac{\bar{k}}{\bar{y}}=\lambda_p\left(\frac{(1-\alpha)\bar{r}^k}{\alpha\bar{w}}\right)^{\alpha-1},
$$

$$
\frac{\bar{i}}{\bar{y}}=
\left(1-\frac{1-\delta}{\gamma}\right)\frac{\bar{k}}{\bar{y}},\qquad
\frac{\bar{c}}{\bar{y}}=1-\frac{\bar{g}}{\bar{y}}-\frac{\bar{i}}{\bar{y}}.
$$

5. 从论文估计值设置 CCTW 扩展参数：MMB 实现中 $\omega=0.2651$、$\phi_b=0.0531$、$\phi_g=0.1242$。这些数值对应 Table A1 的 posterior mean 行。

线性模型中的所有其他变量都是围绕这些稳态对象的偏离。未执行运行时稳态验证。

## 7. Timing & Form Conventions

- 档案方程采用对数线性/偏离形式。$c_t$、$y_t$、$i_t$、$w_t$、$\pi_t$ 和 $r_t$ 等变量是相对趋势/稳态的偏离，而不是非线性水平。
- 已安装资本 $k^p_t$ 是预定状态变量。生产使用上一期带来的已安装资本加当期利用率：$k_t=k^p_{t-1}+z^k_t$。
- 灵活经济变量在 MMB 文件中带有 `f` 后缀，并定义用于缺口的自然产出、利率和劳动对象。
- 有两个家庭消费概念：Ricardian/非流动性约束消费 $c_{j,t}$ (`c_nlc`) 和规则型/流动性约束消费 $c_{i,t}$ (`c_lc`)。
- CCTW 附录中，政府债务和税收以稳态产出的百分比表示。
- MMB 情景中，政策哑变量 `dummy_MP` 在第 1:4 期钉住 modelbase 利率观测变量。CCTW 论文讨论 2009 年和/或持续到 2010 年的有限联邦基金利率宽松；精确的 MMB 哑变量路径属于实现情景，而不是论文的一般推导。
- CCTW 论文来源对完整 Smets-Wouters 模块是不完整的，因为它让读者参考 Smets and Wouters (2007)。标为 `implementation_cross_check` 的方程在提升前需要来源级检查。

## 8. Variable & Parameter Reference Table

### 内生变量

| ASCII 名称 | 符号 | 含义 | 主要方程 |
|---|---|---|---|
| `labobs` | $l^{obs}_t$ | 观测劳动 | measurement block |
| `robs` | $r^{obs}_t$ | 观测年化名义/利率变量 | (F34) |
| `pinfobs` | $\pi^{obs}_t$ | 观测季度通胀 | (F34) |
| `dy` | $\Delta y_t$ | 产出增长观测变量 | (F35) |
| `dc` | $\Delta c_t$ | 消费增长观测变量 | (F35) |
| `dinve` | $\Delta i_t$ | 投资增长观测变量 | (F35) |
| `dw` | $\Delta w_t$ | 工资增长观测变量 | (F35) |
| `ewma`, `epinfma` | $\varepsilon^w_t,\varepsilon^\pi_t$ lags | MA 冲击辅助变量 | (F41), (F42) |
| `zcapf`, `zcap` | $z^k_{f,t},z^k_t$ | 资本利用 | (F2), (F12) |
| `rkf`, `rk` | $r^k_{f,t},r^k_t$ | 资本租赁率 | (F3), (F13) |
| `kf`, `k` | $k_{f,t},k_t$ | 生产中使用的资本 | (F4), (F14) |
| `pkf`, `pk` | $p^k_{f,t},p^k_t$ | 已安装资本价值 | (F6), (F16) |
| `cf`, `c` | $c_{f,t},c_t$ | 总消费 | (F9), (F19) |
| `invef`, `inve` | $i_{f,t},i_t$ | 投资 | (F5), (F15) |
| `yf`, `y` | $y_{f,t},y_t$ | 灵活和粘性经济产出 | (F22)-(F23), (F27)-(F28) |
| `labf`, `lab` | $l_{f,t},l_t$ | 劳动 | (F10), (F21) |
| `wf`, `w` | $w_{f,t},w_t$ | 实际工资 | (F10), (F21) |
| `rrf` | $r^r_{f,t}$ | 灵活实际回报 | (F6) |
| `mc`, `mcf` | $mc_t,mc_{f,t}$ | 边际成本 | (F11) |
| `r` | $r_t$ | 政策利率偏离 | (F16), (F34) |
| `a` | $a_t$ | 技术 | (F36) |
| `b` | $b^{pref}_t$ | 偏好/风险溢价冲击状态 | (F37) |
| `g` | $g_t$ | 政府购买 | (F38) |
| `qs` | $q^s_t$ | 投资专有冲击 | (F39) |
| `ms` | $m_t$ | 货币政策冲击状态 | (F40) |
| `spinf`, `sw` | $s^\pi_t,s^w_t$ | 价格和工资加成冲击状态 | (F41), (F42) |
| `kpf`, `kp` | $k^p_{f,t},k^p_t$ | 已安装资本存量 | (F24), (F29) |
| `pinf4`, `pinfobs4`, `robs4` | $\pi^{(4)}_t,\pi^{obs,4}_t,r^{obs,4}_t$ | 年化观测变量 | (F34) |
| `c_lc`, `c_lcf` | $c_{i,t},c_{i,f,t}$ | 规则型家庭消费 | (F8), (F18) |
| `c_nlc`, `c_nlcf` | $c_{j,t},c_{j,f,t}$ | Ricardian 消费 | (F7), (F17) |
| `debt`, `debtf` | $b_t,b_{f,t}$ | 政府债务 | (F25), (F30) |
| `t`, `tf` | $t_t,t_{f,t}$ | 税收 | (F26), (F31) |
| `interest`, `inflation`, `inflationq`, `outputgap`, `output` | modelbase reporting variables | MMB 报告变量 | (F32)-(F35) |
| `pinflag1`, `pinflag2`, `dlab`, `realinterest`, `gry` | lag/reporting auxiliaries | 测量辅助变量 | (F34)-(F35) |

### 外生冲击

| ASCII 名称 | 符号 | 含义 |
|---|---|---|
| `ea` | $\varepsilon^a_t$ | 技术创新 |
| `eb` | $\varepsilon^b_t$ | 偏好/风险溢价创新 |
| `eqs` | $\varepsilon^{qs}_t$ | 投资专有创新 |
| `em` | $\varepsilon^m_t$ | 货币政策创新 |
| `epinf` | $\varepsilon^\pi_t$ | 价格加成创新 |
| `ew` | $\varepsilon^w_t$ | 工资加成创新 |
| `fiscal_` | $fiscal_t$ | 确定性财政购买路径 |
| `dummy_MP` | $d^{MP}_t$ | 确定性货币政策钉住哑变量 |

### 参数

| ASCII 名称 | 符号 | 含义 |
|---|---|---|
| `omega` | $\omega$ | 规则型家庭比例 |
| `phi_b` | $\phi_b$ | 税收对政府债务的反应 |
| `phi_g` | $\phi_g$ | 税收对政府支出的反应 |
| `csigma` | $\sigma_c$ | 跨期替代弹性倒数 |
| `chabb` | $h$ | 习惯持久性 |
| `cprobp`, `cprobw` | $\xi_p,\xi_w$ | Calvo 价格和工资粘性 |
| `cindp`, `cindw` | $\iota_p,\iota_w$ | 价格和工资指数化 |
| `calfa` | $\alpha$ | MMB 代码中的资本份额参数 |
| `ctou` | $\delta$ | 折旧率 |
| `czcap` | $\zeta$ | 资本利用曲率参数 |
| `csadjcost` | $S''$ | 投资调整成本 |
| `crpi`, `crr`, `cry`, `crdy` | policy-rule coefficients | 通胀、平滑和产出缺口反应 |
| `crhoa`, `crhob`, `crhoqs`, `crhoms`, `crhopinf`, `crhow` | shock persistence/MA parameters | 外生过程参数 |
| `cg`, `cgy`, `ccy`, `ciy`, `cky`, `crkky`, `cwhlc` | steady-state ratios | 资源约束和家庭收入权重 |
| `constepinf`, `constebeta`, `constelab`, `ctrend` | steady observed constants | 通胀、贴现、劳动和增长常数 |

由于 MMB 文件除核心均衡方程外还包含报告恒等式和情景哑变量，本条目不声称已验证内生方程数。方程覆盖为 `needs_review`。
