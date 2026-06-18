# US_BB18 -- 推导（最优化问题 + 一阶条件）

> 状态：`needs_review`。这是基于 Balke and Brown (2018) MinerU Markdown 的第一版归档条目。未执行运行时验证，`.mod` 文件仅作为 implementation_cross_check 使用。

来源：Nathan S. Balke and Stephen P. A. Brown (2018), "Oil supply shocks and the U.S. economy: An estimated DSGE model," *Energy Policy*, 116, 357-372. DOI: `10.1016/j.enpol.2018.02.027`。

## 1. Model Overview

- **模型**：美国中型估计 DSGE 模型，包含家庭消费服务、运输服务、中间品生产、国内石油生产、世界石油市场，以及简约形式的 ROW 贸易联系中的石油。
- **目的**：使用 1991Q1-2015Q4 季度数据，估计由 ROW 石油供给冲击引起的油价变动对美国实际 GDP 的影响。
- **主体与模块**：国内家庭；最终品厂商；运输服务；具有 Rotemberg 价格调整的垄断竞争中间品厂商；中间品资本服务供给者；国内石油生产者；货币当局；商品、石油和资产市场出清；ROW 石油供给、ROW 石油需求、ROW 经济活动、净出口和实际汇率方程。
- **形式**：论文说明将一阶条件和市场出清条件在确定性稳态附近对数线性化。实现交叉检查确认使用 `model(linear)`。
- **实现交叉检查**：`.agents/skills/dynare-copilot/references/examples/US_BB18_rep.mod` 列出 99 个内生变量和 13 个外生创新。该文件仅用于检查变量名、时序、冲击覆盖和线性实现形式。

## 2. Optimization Problems

### 2.1 国内家庭

家庭选择消费服务、非耐用品消费、耐用品资本、消费中的石油使用、石油效率投资、跨部门劳动配置和对外净资产。期望效用目标为：

$$
E_0\sum_{i=0}^{\infty}\beta^i u(c_t,l_t)
\tag{F1}
$$

基准期效用为：

$$
u(c_t,l_t)=\frac{(c_t-x_c h_t)^{1-\sigma}}{1-\sigma}
-\chi\frac{l_t^{1+\eta}}{1+\eta}.
\tag{F2}
$$

外部习惯演化为：

$$
h_t=c_{t-1}^{1-\gamma_h}h_{t-1}^{\gamma_h}.
\tag{F3}
$$

消费服务由非耐用品和耐用品服务聚合：

$$
c_t=z_{c,t}\left(\psi_n n_t^{\rho_c}+(1-\psi_n)ks_{c,t}^{\rho_c}\right)^{1/\rho_c}.
\tag{F4}
$$

总劳动包含跨部门重新配置成本：

$$
l_t=\sum_{j\in\{f,m,o\}}\left[1+\phi_l\left(\frac{l_{j,t}}{l_{j,t-1}}\right)\right]l_{j,t},
\qquad
\phi_l\left(\frac{l_{j,t}}{l_{j,t-1}}\right)=a_{jl}\frac{(l_{j,t}/l_{j,t-1}-1)^2}{2}.
\tag{F5}
$$

实际工资刚性为：

$$
w_t=w_{t-1}^{\alpha_w}\lambda_{l,t}^{1-\alpha_w},
\qquad
\lambda_{l,t}=\frac{1}{\rho_w}\lambda_{c,t}\frac{-U_l(c_t,l_t)}{U_c(c_t,l_t)}.
\tag{F6}
$$

消费耐用品服务把预定的耐用品资本与当期石油使用结合：

$$
ks_{c,t}=z_{ksc,t}\left[\psi_{co}(e_{c,t-1}o_{c,t})^{\rho_{ksc}}+(1-\psi_{co})k_{c,t-1}^{\rho_{ksc}}\right]^{1/\rho_{ksc}}.
\tag{F7}
$$

消费耐用品资本与效率演化为：

$$
k_{c,t}=(1-\delta)k_{c,t-1}+z_{I,t}I_{c,t},
\qquad
e_{c,t}=v_{c,t}x_{c,t}^{\delta}e_{c,t-1}^{1-\delta}.
\tag{F8}
$$

家庭预算约束为：

$$
\begin{aligned}
&w_{f,t}l_{f,t}+w_{m,t}l_{m,t}+w_{o,t}l_{o,t}+pr_{f,t}+pr_{m,t}+pr_{ksm,t}+pr_{o,t}
-p_{f,t}n_t \\
&\quad -p_{f,t}\left[1+\phi_I(I_{c,t}/k_{c,t-1})\right]\left[1+\phi_e(x_{c,t})\right]I_{c,t}
+(1+R_t)A_t-A_{t+1}=0.
\end{aligned}
\tag{F9}
$$

消费耐用品的调整成本为：

$$
\phi_I(I_{c,t}/k_{c,t-1})=a_{ck}\frac{(I_{c,t}/k_{c,t-1}-\delta)^2}{2},
\qquad
\phi_e(x_{c,t})=a_{ec}(x_{c,t}-x_{c,ss})+b_{ec}\frac{(x_{c,t}-x_{c,ss})^2}{2}.
\tag{F10}
$$

### 2.2 最终品与运输生产者

最终品厂商结合中间品和运输服务：

$$
y_{f,t}=z_{f,t}\left(\psi_m y_{m,t}^{\rho_f}+(1-\psi_m)y_{tr,t}^{\rho_f}\right)^{1/\rho_f}.
\tag{F11}
$$

中间品综合品和品种需求为：

$$
y_{m,t}=\int_0^1\left(y_{m,t}(z)^{\rho_m}\right)^{1/\rho_m}dz,
\qquad
y_{m,t}(z)=\left(\frac{p_{m,t}}{p_{m,t}(z)}\right)^{1/(1-\rho_m)}y_{m,t}.
\tag{F12}
$$

运输服务和运输资本服务为：

$$
y_{tr,t}=z_{tr,t}\left(\psi_{tr,l}l_{tr,t}^{\rho_{tr}}+(1-\psi_{tr})ks_{tr,t}^{\rho_{tr}}\right)^{1/\rho_{tr}},
\tag{F13}
$$

$$
ks_{tr,t}=z_{kstr,t}\left[\psi_{o,tr}(e_{tr,t-1}o_{tr,t})^{\rho_{kstr}}+(1-\psi_{o,tr})k_{tr,t-1}^{\rho_{kstr}}\right]^{1/\rho_{kstr}}.
\tag{F14}
$$

运输资本和效率演化为：

$$
k_{tr,t}=(1-\delta)k_{tr,t-1}+z_{I,t}I_{tr,t},
\qquad
e_{tr,t}=x_{tr,t}^{\delta}e_{tr,t-1}^{1-\delta}.
\tag{F15}
$$

### 2.3 中间品厂商

每个差异化中间品厂商使用劳动和资本服务：

$$
y_{m,t}(z)=z_{m,t}l_{m,t}(z)^{\psi_{m,l}}ks_{m,t}(z)^{1-\psi_{m,l}}.
\tag{F16}
$$

现值利润目标为：

$$
\sum_{i=0}^{\infty}M_{t,t+i}
\left[p_{m,t+i}(z)y_{m,t+i}(z)-w_{m,t+i}l_{m,t+i}(z)-r_{m,t+i}ks_{m,t+i}(z)
-p_{f,t+i}\phi_p\left(\frac{p_{m,t+i}(z)}{p_{m,t+i-1}(z)}\right)y_{m,t+i}(z)\right].
\tag{F17}
$$

共同边际成本表达式为：

$$
\lambda_{m,t}=z_{m,t}^{-1}
\left(\frac{w_{m,t}}{\psi_{m,l}}\right)^{\psi_{m,l}}
\left(\frac{r_{m,t}}{1-\psi_{m,l}}\right)^{1-\psi_{m,l}}.
\tag{F18}
$$

### 2.4 中间品资本服务供给者

资本服务供给者为中间品生产选择石油、资本和效率投资。论文端目标函数 OCR 不确定，标记为 `needs_review`，但预期模块为：

$$
\sum_{i=0}^{\infty}M_{t,t+i}
\left[
r_{m,t+i}ks_{m,t+i}-p_{o,t+i}o_{m,t+i}
-p_{f,t+i}(1+\phi_I(I_{m,t+i}/k_{m,t+i-1}))(1+\phi_e(x_{m,t+i}))I_{m,t+i}
\right].
\tag{F19, needs_review}
$$

资本服务、资本和效率为：

$$
ks_{m,t}=z_{ksm,t}\left[\psi_{m,o}(e_{m,t-1}o_{m,t})^{\rho_{ksm}}+(1-\psi_{m,o})k_{m,t-1}^{\rho_{ksm}}\right]^{1/\rho_{ksm}},
\tag{F20}
$$

$$
k_{m,t}=(1-\delta)k_{m,t-1}+z_{I,t}I_{m,t},
\qquad
e_{m,t}=x_{m,t}^{\delta}e_{m,t-1}^{1-\delta}.
\tag{F21}
$$

### 2.5 国内石油生产者

国内石油生产者最大化：

$$
\sum_{i=0}^{\infty}M_{t,t+i}
\left[p_{o,t+i}y_{o,t+i}-w_{o,t+i}l_{o,t+i}
-p_{f,t+i}(1+\phi_I(I_{o,t+i}/k_{o,t+i-1}))I_{o,t+i}\right].
\tag{F22}
$$

国内石油产出和石油部门资本积累为：

$$
y_{o,t}=z_{o,t}\left[\psi_{o,l}l_{o,t}^{\rho_o}+(1-\psi_{o,l})k_{o,t-1}^{\rho_o}\right]^{1/\rho_o},
\qquad
k_{o,t}=(1-\delta)k_{o,t-1}+z_{I,t}I_{o,t}.
\tag{F23}
$$

## 3. First-Order Conditions

论文明确给出部分 FOC。其余优化 FOC 以模块层面记录；在提升归档状态前，应与作者实现或技术附录进行源级核查。

- **(F24) 无风险利率欧拉方程**：

$$
E_t\left[\left(\frac{R_t}{\pi_{f,t+1}}\right)\beta
\frac{u_c(c_{t+1},l_{t+1})/\lambda_{c,t+1}}
{u_c(c_t,l_t)/\lambda_{c,t}}\right]=1.
\tag{F24}
$$

- **(F25) 带风险冲击的厂商随机贴现因子**：

$$
M_{t,t+1}=z_{risk,t}\beta
\frac{u_c(c_{t+1},l_{t+1})/\lambda_{c,t+1}}
{U_C(c_t,l_t)/\lambda_{c,t}}.
\tag{F25}
$$

- **(F26) 部门石油使用 FOC**，$j\in\{c,tr,m\}$：

$$
p_{j,t}\frac{\partial y_{j,t}}{\partial ks_{j,t}}
\frac{\partial ks_{j,t}}{\partial(e_{j,t-1}o_{j,t})}e_{j,t-1}
-p_{o,t}=0.
\tag{F26}
$$

- **(F27) 部门效率存量 FOC**，$j\in\{c,tr,m\}$：

$$
M_{t,t+1}
\left[
p_{j,t+1}\frac{\partial y_{j,t+1}}{\partial ks_{j,t+1}}
\frac{\partial ks_{j,t+1}}{\partial(e_{j,t}o_{j,t+1})}o_{j,t+1}
+(1-\delta)\frac{e_{j,t+1}}{e_{j,t}}\lambda^e_{j,t+1}
\right]
-\lambda^e_{j,t}=0.
\tag{F27}
$$

- **(F28) 合并后的石油效率价值 FOC**，$j\in\{c,tr,m\}$：

$$
M_{t,t+1}\left[p_{o,t+1}o_{j,t+1}+(1-\delta)e_{j,t+1}\lambda^e_{j,t+1}\right]
-e_{j,t}\lambda^e_{j,t}=0.
\tag{F28}
$$

- **(F29) 效率投资 FOC**，$j\in\{c,tr,m\}$：

$$
-p_{f,t}\left[1+\phi_I(I_{j,t}/k_{j,t-1})\right]\phi_e'(x_{j,t})I_{j,t}
+\delta\lambda^e_{j,t}\frac{e_{j,t}}{x_{j,t}}=0.
\tag{F29}
$$

- **(F30) 稳态效率价值**，$j\in\{c,tr,m\}$：

$$
\lambda_j^e e_j=\frac{\beta p_o o_j}{1-\beta(1-\delta)}.
\tag{F30}
$$

- **(F31) 稳态效率影子价格**，$j\in\{c,tr,m\}$：

$$
\lambda_j^e=p_f\phi_e'(x_{j,ss})k_{j,ss}.
\tag{F31}
$$

- **(F32) 稳态效率相对资本价值比**，$j\in\{c,tr,m\}$：

$$
\frac{\lambda_j^e e_j}{\lambda_j^k k_j}=\frac{s_{o,j}}{1-s_{o,j}}.
\tag{F32}
$$

- **(F33) 货币政策规则**：

$$
R_t=\frac{R_{ss}}{(\pi_{ss}^{\ast})}\pi_t^{\ast}
\left[\left(\frac{\pi_{GDP,t}}{\pi_t^{\ast}}\right)^{\gamma_\pi}
\left(\frac{y_{GDP,t}}{y_{GDP,ss}}\right)^{\gamma_y}\right]^{1-\gamma_R}
\left(\frac{R_{t-1}}{R_{ss}}\right)^{\gamma_R}\varepsilon_{R,t}.
\tag{F33}
$$

## 4. Market Clearing & Identities

- **(F34) 最终品市场出清**：

$$
\begin{aligned}
&y_{f,t}-n_t
-[1+\phi_I(I_{c,t}/k_{c,t-1})][1+\phi_e(x_{c,t})]I_{c,t}\\
&\quad -[1+\phi_I(I_{tr,t}/k_{tr,t-1})][1+\phi_e(x_{tr,t})]I_{tr,t}
-[1+\phi_I(I_{m,t}/k_{m,t-1})][1+\phi_e(x_{m,t})]I_{m,t}\\
&\quad -[1+\phi_I(I_{o,t}/k_{o,t-1})]I_{o,t}
+p_{f,t}\phi_p\left(\frac{p_{m,t}}{p_{m,t-1}}\right)y_{m,t}
-nx_{f,t}=0.
\end{aligned}
\tag{F34, needs_review}
$$

- **(F35) 石油市场出清**：

$$
y_{o,t}-o_{c,t}-o_{tr,t}-o_{m,t}+row_{s,t}-row_{d,t}=0.
\tag{F35}
$$

- **(F36) 贸易余额恒等式**：

$$
nx_t=nx_{f,t}-\frac{p_{o,t}}{p_{f,t}}\left(o_{c,t}+o_{tr,t}+o_{m,t}-y_{o,t}\right).
\tag{F36}
$$

- **(F37) 实际 GDP 度量恒等式**，围绕稳态对数线性化：

$$
\hat y^{GDP}_t=
\frac{p_{f,ss}y_{f,ss}}{ny_{GDP,ss}}\hat y_{f,t}
+\frac{p_{o,ss}y_{o,ss}}{ny_{GDP,ss}}\hat y_{o,t}
-\frac{p_{o,ss}o_{tr,ss}}{ny_{GDP,ss}}\hat o_{tr,t}
-\frac{p_{o,ss}o_{m,ss}}{ny_{GDP,ss}}\hat o_{m,t}.
\tag{F37, needs_review}
$$

- **(F38) GDP 通胀恒等式**，围绕稳态对数线性化：

$$
\hat\pi_{GDP,t}=
\frac{p_{f,ss}y_{f,ss}}{ny_{GDP,ss}}\hat\pi_{f,t}
+\frac{p_{o,ss}(y_{o,ss}-o_{tr,ss}-o_{m,ss})}{ny_{GDP,ss}}\hat\pi_{o,t}.
\tag{F38}
$$

## 5. Exogenous Processes

- **(F39) ROW 石油供给**：

$$
row_{s,t}=row_{s,t-1}^{\theta_s}
\left[\left(\frac{p_{o,t}}{p^{\ast}_{f,t}}\right)^{\eta_s}z_{row,t}\right]^{1-\theta_s}.
\tag{F39}
$$

- **(F40) ROW 石油需求**：

$$
row_{d,t}=row_{d,t-1}^{\theta_d}
\left[\left(\frac{p_{o,t}}{p^{\ast}_{f,t}}\right)^{\eta_d}
y_{row,t}^{\eta_y}z^d_{row,t}\right]^{1-\theta_d}.
\tag{F40}
$$

- **(F41) ROW 经济活动简约方程**：

$$
\begin{aligned}
\log\left(\frac{y_{row,t}}{y_{row,ss}}\right)
&=a_{row}(L)\log\left(\frac{y_{row,t-1}}{y_{row,ss}}\right)
+b_{row}(L)\log\left(\frac{nx_{t-1}}{nx_{ss}}\right)\\
&\quad +c_{row}(L)\log\left(\frac{p^{\ast}_{f,t-1}}{p_{f,t-1}}\right)
+d_{row}(L)\log\left(\frac{p_{o,t}}{p_{f,t}}\right)
+e_{row}(L)\log\left(\frac{y_{f,t}}{y_{f,ss}}\right)
+\varepsilon_{row,t}.
\end{aligned}
\tag{F41}
$$

- **(F42) 美国净出口简约方程**：

$$
\begin{aligned}
\log\left(\frac{nx_t}{nx_{ss}}\right)
&=a_{nx}(L)\log\left(\frac{y_{row,t}}{y_{row,ss}}\right)
+b_{nx}(L)\log\left(\frac{nx_{t-1}}{nx_{ss}}\right)
+c_{nx}(L)\log\left(\frac{p^{\ast}_{f,t-1}}{p_{f,t-1}}\right)\\
&\quad +d_{nx}(L)\log\left(\frac{p_{o,t}}{p_{f,t}}\right)
+e_{nx}(L)\log\left(\frac{y_{f,t}}{y_{f,ss}}\right)
+\varepsilon_{nx,t}.
\end{aligned}
\tag{F42}
$$

- **(F43) ROW 实际汇率简约方程**：

$$
\begin{aligned}
\log\left(\frac{p^{\ast}_{f,t}}{p_{f,t}}\right)
&=a_{rer}(L)\log\left(\frac{y_{row,t}}{y_{row,ss}}\right)
+b_{rer}(L)\log\left(\frac{nx_t}{nx_{ss}}\right)
+c_{rer}(L)\log\left(\frac{p^{\ast}_{f,t-1}}{p_{f,t-1}}\right)\\
&\quad +d_{rer}(L)\log\left(\frac{p_{o,t}}{p_{f,t}}\right)
+e_{rer}(L)\log\left(\frac{y_{f,t}}{y_{f,ss}}\right)
+\varepsilon_{rer,t}.
\end{aligned}
\tag{F43}
$$

实现交叉检查还包含美国消费/偏好、中间品 TFP、美国石油技术、美国 markup、投资技术、美国风险、ROW 石油需求和美国通胀目标的 AR(1) 过程。这些过程名记录在第 8 节，但 Markdown 中没有以紧凑列表给出精确论文端转移方程，因此仍为 `needs_review`。

## 6. Steady-State Solution

模型在确定性稳态附近对数线性化后求解，因此实现中的 `model(linear)` 变量是稳态偏离。论文和实现使用校准的稳态份额与水平，而不是完整闭式稳态推导。

源文献记录的稳态限制包括：

$$
\phi_I(\delta)=0,\qquad \phi_I'(\delta)=0,\qquad \phi_I''(\delta)>0.
\tag{F44}
$$

$$
\phi_e(x_{j,ss})=0,\qquad \phi_e'(x_{j,ss})>0,\qquad \phi_e''(x_{j,ss})=0,
\quad j\in\{c,tr,m\}.
\tag{F45}
$$

$$
nx_{ss}=0,
\qquad
\frac{p^{\ast}_{f,ss}}{p_{f,ss}}=1.
\tag{F46}
$$

$$
ny_{GDP,ss}=p_{f,ss}y_{f,ss}+p_{o,ss}(y_{o,ss}-o_{tr,ss}-o_{m,ss}).
\tag{F47}
$$

源文献中的关键校准稳态目标包括 $\beta=0.99$、$\delta=0.025$、汽油占总消费份额 0.03、机动车支出占消费份额 0.045、劳动 0.30、运输占总产出份额 0.03、运输石油投入份额 0.25、中间品劳动份额 0.60、中间品石油投入份额 0.015、石油和天然气开采劳动份额 0.15、美国石油进口占石油消费份额 0.67、美国石油生产占世界生产份额 0.08，以及隐含石油支出/GDP 约 0.035。

实现交叉检查的稳态值包括 `yfss=1`、`css=1`、`pifss=1`、`Rss=pifss/beta`、`gss=0.1900`、`poss=0.0123`、`ocss=1.4083`、`ofss=0.6083`、`omss=0.9834`、`importoss=2.0000` 和 `rowgdpss=1`。这些作为交叉检查值记录，不作为独立论文端推导。

## 7. Timing & Form Conventions

- **形式**：围绕确定性稳态的对数线性理性预期模型。`.mod` 交叉检查使用 `model(linear)`。
- **资本存量**：部门资本存量 `kc`、`kf`、`km` 和 `ko` 在生产和服务方程中是预定变量，在论文中写作 $k_{j,t-1}$，在实现交叉检查中写作 `k_j(-1)`。
- **石油效率**：部门效率存量对当期石油服务生产是预定变量，在 $ks_{j,t}$ 中写作 $e_{j,t-1}$，在实现中写作 `e_j(-1)`。
- **劳动配置**：部门劳动调整成本依赖当前和滞后劳动配置，并产生动态劳动配置 FOC。
- **价格**：论文对中间品使用 Rotemberg 价格调整，并使用带通胀目标漂移的 Taylor 型规则；实现交叉检查包含 `pim`、`pif`、`pifstar`、`pi` 和 `R`。
- **ROW 模块**：ROW 石油供给/需求是准结构方程，ROW 活动、净出口和实际汇率则是带当期及滞后油价和美国经济活动项的 VARX 风格简约方程。
- **运行时验证**：未执行。没有运行任何 Dynare 命令。

## 8. Variable & Parameter Reference Table

### 内生变量

| 类别 | 符号 / ASCII | 含义 | 主要方程 |
|---|---|---|---|
| 家庭 | `c`, `cn`, `h`, `l` | 消费服务、非耐用品、习惯、总劳动 | (F2)-(F6) |
| 消费耐用品 | `ksc`, `kc`, `Ic`, `ec`, `oc`, `xec` | 耐用品服务、存量、投资、效率、石油使用、效率投资 | (F7)-(F10), (F26)-(F32) |
| 最终品 | `yf`, `ym`, `transf`, `zf` | 最终产出、中间品综合、运输投入、最终品 TFP | (F11)-(F15), (F34) |
| 中间品 | `ym`, `lm`, `ksm`, `pm`, `pim`, `lambdam` | 中间品产出/投入、劳动、资本服务、价格、通胀、边际成本 | (F12), (F16)-(F18) |
| 中间品资本服务 | `ksm`, `km`, `Im`, `em`, `om`, `xem`, `rm` | 资本服务、存量、投资、效率、石油、效率投资、租金 | (F19)-(F21), (F26)-(F32) |
| 运输 | `lf`, `ksf`, `kf`, `If`, `ef`, `of`, `xef`, `lambdatransf` | 运输劳动、服务、资本、投资、效率、石油、效率投资、影子价值 | (F13)-(F15), (F26)-(F32) |
| 国内石油 | `yo`, `lo`, `ko`, `Io`, `zo` | 石油产出、劳动、资本、投资、技术 | (F22)-(F23), (F35) |
| 价格/利率 | `po`, `prow`, `R`, `pif`, `pi`, `pifstar`, `M`, `w` | 石油价格、国外价格、利率、通胀、目标、贴现因子、工资 | (F6), (F24)-(F25), (F33), (F38) |
| 贸易/ROW | `importo`, `rowsupply`, `rowdemand`, `rowgdp`, `netexpf`, `rer` | 石油进口、ROW 供给/需求/活动、最终品净出口、实际汇率 | (F35)-(F43) |
| 观测/辅助 | `yfout`, `cout`, `Iout`, `poout`, `lout`, `usoilprod`, `oilimports`, `worldoil`, `ROW_y`, `int_rate`, `oilexpend`, `usoilcons` | 实现中的度量和报告变量 | (F37)-(F38), implementation_cross_check |

### 外生创新

| ASCII | 含义 |
|---|---|
| `vzm` | 中间品生产率创新 |
| `vzc` | 消费/偏好创新 |
| `vzo` | 美国石油生产生产率创新 |
| `vzoil` | ROW 石油供给创新 |
| `vzrowgdp` | ROW 经济活动创新 |
| `vznetexpf` | ROW/美国净出口创新 |
| `vmk` | 美国价格 markup 创新 |
| `vzprow` | ROW 实际汇率创新 |
| `vzI` | 投资技术创新 |
| `vzrisk` | 美国风险/偏好贴现创新 |
| `vzdoil` | ROW 石油特定需求创新 |
| `vpifstar` | 美国通胀目标创新 |
| `vR` | 美国货币政策创新 |

### 主要参数

| ASCII / 符号 | 含义 |
|---|---|
| `beta`, $\beta$ | 贴现因子 |
| `delta`, $\delta$ | 耐用品/资本折旧率与效率演化指数 |
| `sigma`, $\sigma$ | 跨期替代弹性倒数 |
| `eta`, $\eta$ | Frisch 弹性倒数 |
| `xc`, $\chi_c$ | 习惯权重 |
| `thetah`, $\gamma_h$ | 习惯持续性 |
| `rho*`, `psi*`, `sh*` | 消费、运输、中间品、石油生产和石油/资本服务中的 CES 曲率与稳态份额参数 |
| `af`, `am`, `ao` | 劳动配置调整成本 |
| `akc`, `akf`, `akm`, `ako` | 资本调整成本 |
| `aec`, `aef`, `aem`, `aeo`, `bec`, `bef`, `bem`, `beo` | 石油效率成本参数 |
| `alphap`, `indexp` | Rotemberg 价格调整与指数化参数 |
| `alphaw`, `markupw`, `rhow` | 实际工资刚性/markup 参数 |
| `gammapi`, `gammay`, `arR1` | Taylor 规则通胀反应、产出反应和惯性 |
| `oilsupplyelasticity`, `oildemandelasticity`, `oilincomeelasticity`, `thetasupply`, `thetademand` | ROW 石油供给/需求弹性和惯性 |
| `z*1`, `sdz*`, `sdvR`, `sdpifstar` | 持续性和冲击标准差参数 |

### 交叉检查说明

- 实现方程数量远大于本推导，因为实现把对数线性 FOC 展开为部门特定方程和度量恒等式。
- `(F1)` 到 `(F47)` 是归档推导编号，不是论文方程编号或 Dynare 方程编号。
- 公式状态仍为 `needs_review`，因为论文端 Markdown 中若干 OCR 表达式存在错误，且完整实现方程清单尚未与技术附录做源级核查。
