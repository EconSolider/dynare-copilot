# NK_CKL09 - 推导

> 后续 Dynare 实现审阅用的私有归档一稿。状态：`needs_review`。

来源：Kai Christoffel、Keith Kuester 和 Tobias Linzert (2009)，"The role of labor markets for euro area monetary policy," *European Economic Review* 53(8), 908-936。DOI：`10.1016/j.euroecorev.2009.04.007`。

## 1. 模型概述

- **模型 ID**：`NK_CKL09`。
- **模型类型**：校准到欧元区的新凯恩斯模型，包含 Mortensen-Pissarides 搜索匹配摩擦、right-to-manage 工时选择、Calvo 价格刚性和 Calvo 名义工资议价。
- **主要实验**：校准版第 3 节经济中的货币政策传导和劳动市场反事实；Rep-MMB 实现交叉检查文件为 `model(linear)`。
- **主体和部门**：代表性大家庭、零售最终品聚合商、Calvo 批发厂商、劳动品厂商、匹配工人、政府和使用 Taylor 规则的货币当局。
- **形式**：围绕零通胀稳态的对数线性 / hat-variable 系统。下列方程除非变量本身就是利率或份额，均用帽变量表示相对稳态的对数偏离。MinerU Markdown 中若干 OCR 方程可读但尚未与 PDF 做源级核验，标记为 `needs_review`。
- **实现交叉检查**：`.agents/skills/dynare-copilot/references/examples/NK_CKL09_rep.mod` 确认 Rep-MMB 文件为论文第 3 节校准版本，并使用 `ct`、`lambdat`、`Pit`、`Rt`、`nt`、`ut`、`vt`、`wt`、`wstart`、`Jstart`、`Deltastart`、`deltaFt` 和 `deltaWt` 等变量。

## 2. 优化问题

### 2.1 代表性大家庭

家庭最大化其成员的合并预期效用：

$$
E_0\sum_{t=0}^{\infty}\beta^t\left[
\frac{(c_{i,t}-\varrho c_{t-1})^{1-\sigma}}{1-\sigma}
-\kappa^L\frac{h_{i,t}^{1+\varphi}}{1+\varphi}
\right].
$$

家庭代表成员选择消费、债券持有、空缺发布和劳动供给决策，并满足总预算约束：

$$
c_t+t_t+\kappa_t\nu_t
=\int_0^{1-u_t} w_{i,t}h_{i,t}\,di
+u_t b+\frac{D_{t-1}}{P_t}R_{t-1}\varepsilon^b_{t-1}
-\frac{D_t}{P_t}+\Psi_t+n_t\Phi^K.
$$

### 2.2 零售和批发厂商

零售商聚合差异化批发品：

$$
y_t=\left(\int_0^1 y_{j,t}^{(\varepsilon-1)/\varepsilon}\,dj\right)^{\varepsilon/(\varepsilon-1)},
\qquad
y_{j,t}=\left(\frac{P_{j,t}}{P_t}\right)^{-\varepsilon}y_t.
$$

批发厂商在 Calvo 摩擦下设定价格。可以重设价格的厂商选择 $P^*_t$ 以最大化贴现预期利润：

$$
\max_{P^*_t} E_t\sum_{s=0}^{\infty}\omega^s\beta_{t,t+s}
\left[
\frac{P^*_t\Pi_{t-1,t-1+s}^{\xi_p}\Pi^{(1-\xi_p)s}}{P_{t+s}}
-mc_{t+s}
\right]y_{j,t+s}.
$$

### 2.3 劳动品厂商和工资议价

一个匹配上的劳动品厂商生产：

$$
l_{i,t}=z_t h_{i,t}^{\alpha}.
$$

在 right-to-manage 下，工资给定后厂商选择工时：

$$
x^L_t z_t\alpha h_{i,t}^{\alpha-1}=\frac{W_{i,t}}{P_t}.
$$

工人与厂商通过 Nash 议价决定重设工资 $W^*_t$：

$$
\max_{W_{i,t}}\left[\Delta_t(W_{i,t})\right]^{\eta_t}
\left[J_t(W_{i,t})\right]^{1-\eta_t}.
$$

厂商价值和家庭剩余对象由论文价值方程递归定义。其对数线性形式列在下面的均衡条件中；非线性价值方程的 OCR 可用，但精确标点和贴现记号仍 `needs_review`。

### 2.4 空缺发布

空缺发布的自由进入条件使空缺成本等于填补职位的贴现预期价值：

$$
\kappa_t=q_t E_t\left\{\beta_{t,t+1}\left[
\gamma J_{t+1}\!\left(W_t\Pi_t^{\xi_w}\Pi^{1-\xi_w}\right)
+(1-\gamma)J_{t+1}(W^*_{t+1})
\right]\right\}.
$$

## 3. 一阶条件

本归档方程组遵循论文附录 A 的线性化系统，并用 Rep-MMB `model(linear)` 交叉检查。

**(F1) 消费 Euler 方程**

$$
\hat{\lambda}_t
=E_t\left[\hat{\lambda}_{t+1}+\hat{R}_t+\hat{\varepsilon}^b_t-\hat{\Pi}_{t+1}\right].
$$

**(F2) 含外部习惯的消费边际效用**

$$
\hat{\lambda}_t
=-\frac{\sigma}{1-\varrho}\left(\hat{c}_t-\varrho\hat{c}_{t-1}\right).
$$

**(F3) 含指数化的新凯恩斯 Phillips 曲线**

$$
\hat{\Pi}_t
=\frac{\xi_p}{1+\beta\xi_p}\hat{\Pi}_{t-1}
+\frac{\beta}{1+\beta\xi_p}E_t\hat{\Pi}_{t+1}
+\frac{(1-\omega)(1-\omega\beta)}{\omega(1+\beta\xi_p)}\widehat{mc}_t.
$$

**(F4) 边际成本**

$$
\widehat{mc}_t=\hat{e}^C_t+\hat{x}^L_t.
$$

**(F5) 匹配技术**

$$
\hat{m}_t=\xi\hat{u}_t+(1-\xi)\hat{\nu}_t.
$$

**(F6) 就业运动方程**

$$
\hat{n}_t=(1-\vartheta)\hat{n}_{t-1}+\frac{m}{n}\hat{m}_{t-1}-\vartheta\hat{\vartheta}_t.
$$

**(F7) 就业-失业恒等式**

$$
\hat{n}_t=-\frac{u}{1-u}\hat{u}_t.
$$

**(F8) 职位填补率**

$$
\hat{q}_t=\hat{m}_t-\hat{\nu}_t.
$$

**(F9) 求职成功率**

$$
\hat{s}_t=\hat{m}_t-\hat{u}_t.
$$

**(F10) 重设工资议价条件**

$$
\hat{J}^*_t+\hat{\delta}^W_t
=\hat{\Delta}^*_t+\hat{\delta}^F_t-\frac{1}{1-\eta}\hat{\eta}_t.
$$

**(F11) Right-to-manage 工时条件**

$$
\hat{w}_t=\hat{x}^L_t+\hat{z}_t+(\alpha-1)\hat{h}_t.
$$

**(F12) 总实际工资演化**

$$
\hat{w}_t
=\gamma\left(\hat{w}_{t-1}-\hat{\Pi}_t+\xi_w\hat{\Pi}_{t-1}\right)
+(1-\gamma)\hat{w}^*_t.
$$

**(F13) 厂商剩余导数递归** `needs_review`

$$
\begin{aligned}
\hat{\delta}^F_t
=&\left[1-\beta(1-\vartheta)\gamma\right]
\left[-\frac{\alpha}{1-\alpha}\hat{w}^*_t
+\frac{1}{1-\alpha}(\hat{x}^L_t+\hat{z}_t)\right] \\
&+\beta(1-\vartheta)\gamma E_t\left[
-\frac{\alpha}{1-\alpha}
(\hat{w}^*_t+\xi_w\hat{\Pi}_t-\hat{w}^*_{t+1}-\hat{\Pi}_{t+1})
+\hat{\delta}^F_{t+1}+\hat{\lambda}_{t+1}-\hat{\lambda}_t
-\frac{\vartheta}{1-\vartheta}\hat{\vartheta}_{t+1}
\right].
\end{aligned}
$$

**(F14) 工人剩余导数递归** `needs_review`

$$
\begin{aligned}
\delta^W\hat{\delta}^W_t
=&-\frac{\alpha}{1-\alpha}wh
\left[-\frac{\alpha}{1-\alpha}\hat{w}^*_t
+\frac{1}{1-\alpha}(\hat{x}^L_t+\hat{z}_t)\right] \\
&+\frac{1}{1-\alpha}mrsh
\left[-\frac{1+\varphi}{1-\alpha}\hat{w}^*_t
-\hat{\lambda}_t
+\frac{1+\varphi}{1-\alpha}(\hat{x}^L_t+\hat{z}_t)\right] \\
&+\frac{\beta(1-\vartheta)\gamma}{1-\beta(1-\vartheta)\gamma}
\left[\left(\frac{\alpha}{1-\alpha}\right)^2wh
-\frac{1+\varphi}{(1-\alpha)^2}mrsh\right]
E_t(\hat{w}^*_t+\xi_w\hat{\Pi}_t-\hat{w}^*_{t+1}-\hat{\Pi}_{t+1})\\
&+\beta(1-\vartheta)\gamma\delta^W
E_t\left[\hat{\lambda}_{t+1}-\hat{\lambda}_t+\hat{\delta}^W_{t+1}
-\frac{\vartheta}{1-\vartheta}\hat{\vartheta}_{t+1}\right].
\end{aligned}
$$

**(F15) 重设工资厂商价值** `needs_review`

$$
\begin{aligned}
J\hat{J}^*_t
=&\frac{wh}{\alpha}\left[-\alpha\hat{w}^*_t+\hat{x}^L_t+\hat{z}_t\right]\\
&+\frac{\beta(1-\vartheta)\gamma}{1-\beta(1-\vartheta)\gamma}wh
E_t(\hat{w}^*_{t+1}+\hat{\Pi}_{t+1}-\hat{w}^*_t-\xi_w\hat{\Pi}_t)\\
&+\beta(1-\vartheta)J
E_t\left[\hat{\lambda}_{t+1}-\hat{\lambda}_t+\hat{J}^*_{t+1}
-\frac{\vartheta}{1-\vartheta}\hat{\vartheta}_{t+1}\right].
\end{aligned}
$$

**(F16) 重设工资下的工人剩余** `needs_review`

$$
\begin{aligned}
\Delta\hat{\Delta}^*_t
=&\frac{wh}{1-\alpha}\left[-\alpha\hat{w}^*_t+\hat{x}^L_t+\hat{z}_t\right]\\
&-\frac{mrsh}{1+\varphi}
\left[\frac{1+\varphi}{1-\alpha}(-\hat{w}^*_t+\hat{x}^L_t+\hat{z}_t)-\hat{\lambda}_t\right]\\
&+\frac{\beta(1-\vartheta)\gamma}{1-\beta(1-\vartheta)\gamma}
\left[\frac{\alpha}{1-\alpha}wh-\frac{1}{1-\alpha}mrsh\right]
E_t(\hat{w}^*_{t+1}+\hat{\Pi}_{t+1}-\hat{w}^*_t-\xi_w\hat{\Pi}_t)\\
&-\frac{\beta\gamma s}{1-\beta(1-\vartheta)\gamma}
\left[\frac{\alpha}{1-\alpha}wh-\frac{1}{1-\alpha}mrsh\right]
E_t(\hat{w}^*_{t+1}+\hat{\Pi}_{t+1}-\hat{w}_t-\xi_w\hat{\Pi}_t)\\
&+\beta(1-\vartheta-s)\Delta
E_t(\hat{\lambda}_{t+1}-\hat{\lambda}_t+\hat{\Delta}^*_{t+1})
-\beta\Delta s\hat{s}_t-\beta\Delta\vartheta E_t\hat{\vartheta}_{t+1}.
\end{aligned}
$$

**(F17) 空缺发布条件**

$$
\begin{aligned}
\frac{\kappa}{q}(\hat{\kappa}_t-\hat{q}_t)
=&\frac{\beta\gamma}{1-\beta(1-\vartheta)\gamma}wh
E_t(\hat{w}^*_{t+1}+\hat{\Pi}_{t+1}-\hat{w}_t-\xi_w\hat{\Pi}_t)\\
&+\beta J E_t(\hat{\lambda}_{t+1}-\hat{\lambda}_t+\hat{J}^*_{t+1}).
\end{aligned}
$$

## 4. 市场出清与恒等式

**(F18) 零售资源约束**

$$
y\hat{y}_t=c\hat{c}_t+g\hat{g}_t+\kappa\nu(\hat{\kappa}_t+\hat{\nu}_t)+\Phi^L n\hat{n}_t.
$$

**(F19) 总生产函数**

$$
\hat{y}_t=\hat{z}_t+\alpha\hat{h}_t+\hat{n}_t.
$$

**(F20) 年化 / 同比通胀恒等式**

$$
\hat{\Pi}^{yoy}_t=\hat{\Pi}_t+\hat{\Pi}_{t-1}+\hat{\Pi}_{t-2}+\hat{\Pi}_{t-3}.
$$

**(F21) 平均劳动品厂商利润**

$$
\widehat{\Psi}^L_t
=A(\hat{w}_t+\hat{h}_t),
\qquad
A=\frac{\frac{1-\alpha}{\alpha}wh}{\frac{1-\alpha}{\alpha}wh-\Phi}.
$$

**(F22) 批发部门利润**

$$
\Psi^C\widehat{\Psi}^C_t=(1-mc)y\hat{y}_t-ymc\widehat{mc}_t.
$$

**(F23) 货币政策规则**

$$
\hat{R}_t
=\gamma_R\hat{R}_{t-1}
+(1-\gamma_R)\left[
\frac{\gamma_{\pi}}{4}\hat{\Pi}^{yoy}_t
+\frac{\gamma_y}{4}(\hat{y}_t-\hat{y}^{flex}_t)
\right]
+\gamma_{\Delta y}(\hat{y}_t-\hat{y}_{t-1})
+\hat{e}^{money}_t.
$$

**(F24) 灵活价格 / 灵活工资产出块**

$$
\hat{y}^{flex}_t=\hat{z}_t+\alpha\hat{h}^{flex}_t+\hat{n}_t.
$$

来源说明，灵活经济复制实际系统，但将价格和工资刚性设为零，并保留实际经济的状态。Rep-MMB 文件实现了消费、边际效用、匹配、职位填补率、求职成功率、工资议价、工时、空缺发布、资源出清和生产的显式灵活版本。完整的一一对应灵活经济方程暂记为 `needs_review`，因为本一稿归档聚焦基准论文方程。

## 5. 外生过程

**(F25) 风险溢价 / 偏好冲击**

$$
\hat{\varepsilon}^b_t=\rho_b\hat{\varepsilon}^b_{t-1}+e^b_t.
$$

**(F26) 政府支出**

$$
\hat{g}_t=\rho_g\hat{g}_{t-1}+e^g_t.
$$

**(F27) 货币政策冲击**

$$
\hat{e}^{money}_t=\rho_{money}\hat{e}^{money}_{t-1}+e^{money}_t.
$$

**(F28) 技术冲击**

$$
\hat{z}_t=\rho_z\hat{z}_{t-1}+e^z_t.
$$

**(F29) 议价能力冲击**

$$
\hat{\eta}_t=\rho_{\eta}\hat{\eta}_{t-1}+e^{\eta}_t.
$$

**(F30) 空缺发布成本冲击**

$$
\hat{\kappa}_t=\rho_{\kappa}\hat{\kappa}_{t-1}+e^{\kappa}_t.
$$

**(F31) 分离率冲击**

$$
\hat{\vartheta}_t=\rho_{\vartheta}\hat{\vartheta}_{t-1}+e^{\vartheta}_t.
$$

**(F32) 成本推动冲击**

$$
\hat{e}^C_t=\rho_C\hat{e}^C_{t-1}+e^C_t.
$$

## 6. 稳态解

校准版论文和 Rep-MMB 文件对线性化模型的稳态进行归一化。在零通胀目标下，所有帽变量内生变量和冲击偏离的稳态均为零。稳态水平用于缩放线性方程：

1. 设定 $y=1$，$h=1/3$，$u=0.0916$，$q=0.7$，以及 $\bar{g}/y=0.2$。
2. 就业和匹配：

$$
n=1-u,\qquad m=\vartheta n,\qquad \nu=\frac{m}{q},\qquad s=\frac{m}{u},
\qquad \sigma_m=m(u^{\xi}\nu^{1-\xi})^{-1}.
$$

3. 定价和贴现：

$$
mc=x^L=\frac{\varepsilon-1}{\varepsilon},\qquad R=\frac{1}{\beta}.
$$

4. 生产和工资：

$$
z=\frac{y}{nh^\alpha},\qquad w=x^L z\alpha h^{\alpha-1}.
$$

5. 劳动品厂商利润、价值和空缺成本：

$$
\Psi^L=x^L z h^\alpha-wh-\Phi,\qquad
J=\frac{\Psi^L}{1-\beta(1-\vartheta)},\qquad
\kappa=q\beta J.
$$

6. 边际效用和 MRS：

$$
\lambda=[c(1-\varrho)]^{-\sigma},\qquad
mrs=\frac{\kappa^L h^{\varphi}}{\lambda}.
$$

7. 资源约束：

$$
y=c+g+\kappa\nu+n\Phi^L.
$$

论文表 6 报告的稳态为：$y=1$，$c=0.79$，劳动份额 $whn/y=0.6$，$u=0.091$，$\nu=0.039$，$s=0.3$，$q=0.7$，$b/(wh)=0.65$，$\kappa\nu/y=0.0023$，$J=0.084$，以及 $\Delta=0.070$。未执行运行时验证。

## 7. 时序与形式约定

- 模型以对数线性形式实现；Rep-MMB 文件中的变量是相对稳态的偏离。
- 第 $t$ 期形成的新匹配在 $t+1$ 期开始生产，因此就业方程 (F6) 使用滞后匹配。
- 分离率冲击进入当期就业存量和未来价值递归。
- Taylor 规则响应年通胀以及相对灵活价格 / 灵活工资经济的产出缺口。
- 名义工资刚性采用 Calvo 机制；未重设工资按参数 $\xi_w$ 对滞后通胀指数化。
- 价格刚性采用 Calvo 机制；未重设价格按参数 $\xi_p$ 对滞后通胀指数化。
- 模型没有物质资本积累。`PhiK` 是劳动品厂商收入中归属资本收入的推定份额，不是资本存量运动方程。
- 一稿方程 (F13)-(F16) 标记为 `needs_review`，因为 MinerU 附录 OCR 有若干符号损坏，虽然 Rep-MMB 实现给出了一致的线性化对应项。

## 8. 变量与参数对照表

| 类别 | 符号 / ASCII | 含义 | 主要方程 |
|---|---|---|---|
| 内生变量 | `ct`, $\hat{c}_t$ | 消费 | (F2), (F18) |
| 内生变量 | `lambdat`, $\hat{\lambda}_t$ | 消费边际效用 | (F1), (F2) |
| 内生变量 | `Pit`, $\hat{\Pi}_t$ | 季度通胀 | (F3), (F20) |
| 内生变量 | `Piannt`, $\hat{\Pi}^{yoy}_t$ | 同比通胀 | (F20), (F23) |
| 内生变量 | `Rt`, $\hat{R}_t$ | 名义政策利率 | (F1), (F23) |
| 内生变量 | `mct`, $\widehat{mc}_t$ | 边际成本 | (F3), (F4) |
| 内生变量 | `xLt`, $\hat{x}^L_t$ | 劳动品实际价格 | (F4), (F11) |
| 内生变量 | `mt`, $\hat{m}_t$ | 新匹配 | (F5) |
| 内生变量 | `nt`, $\hat{n}_t$ | 就业 | (F6), (F7), (F19) |
| 内生变量 | `ut`, $\hat{u}_t$ | 失业 | (F5), (F7), (F9) |
| 内生变量 | `vt`, $\hat{\nu}_t$ | 空缺 | (F5), (F8), (F18) |
| 内生变量 | `qt`, $\hat{q}_t$ | 职位填补率 | (F8), (F17) |
| 内生变量 | `st`, $\hat{s}_t$ | 求职成功率 | (F9), (F16) |
| 内生变量 | `wt`, $\hat{w}_t$ | 平均实际工资 | (F11), (F12) |
| 内生变量 | `wstart`, $\hat{w}^*_t$ | 重设工资 | (F10), (F13)-(F16) |
| 内生变量 | `deltaFt`, $\hat{\delta}^F_t$ | 厂商剩余导数 | (F10), (F13) |
| 内生变量 | `deltaWt`, $\hat{\delta}^W_t$ | 工人剩余导数 | (F10), (F14) |
| 内生变量 | `Jstart`, $\hat{J}^*_t$ | 重设工资厂商价值 | (F10), (F15), (F17) |
| 内生变量 | `Deltastart`, $\hat{\Delta}^*_t$ | 重设工资下工人剩余 | (F10), (F16) |
| 内生变量 | `ht`, $\hat{h}_t$ | 人均工时 | (F11), (F19) |
| 内生变量 | `yt`, $\hat{y}_t$ | 产出 | (F18), (F19), (F23) |
| 内生变量 | `yflext`, $\hat{y}^{flex}_t$ | 灵活价格 / 灵活工资产出 | (F23), (F24) |
| 内生冲击状态 | `ebt`, $\hat{\varepsilon}^b_t$ | 风险溢价 / 偏好楔子 | (F25) |
| 内生冲击状态 | `gt`, $\hat{g}_t$ | 政府支出 | (F26) |
| 内生冲击状态 | `emoneyt`, $\hat{e}^{money}_t$ | 货币政策冲击 | (F27) |
| 内生冲击状态 | `zt`, $\hat{z}_t$ | 技术 | (F28) |
| 内生冲击状态 | `ebargaint`, $\hat{\eta}_t$ | 议价能力冲击 | (F29) |
| 内生冲击状态 | `ekappat`, $\hat{\kappa}_t$ | 空缺成本冲击 | (F30) |
| 内生冲击状态 | `esept`, $\hat{\vartheta}_t$ | 分离冲击 | (F31) |
| 内生冲击状态 | `eCt`, $\hat{e}^C_t$ | 成本推动冲击 | (F32) |
| 外生创新 | `inno_ebt` | 风险溢价冲击创新 | (F25) |
| 外生创新 | `g_` | 政府支出创新 | (F26) |
| 外生创新 | `interest_` | 货币政策冲击创新 | (F27) |
| 外生创新 | `inno_zt` | 技术创新 | (F28) |
| 外生创新 | `inno_ebargaint` | 议价能力创新 | (F29) |
| 外生创新 | `inno_ekappat` | 空缺成本创新 | (F30) |
| 外生创新 | `inno_esept` | 分离创新 | (F31) |
| 外生创新 | `inno_eCt` | 成本推动冲击创新 | (F32) |
| 参数 | `bet`, $\beta$ | 贴现因子 | 稳态, (F1) |
| 参数 | `epsilon`, $\varepsilon$ | 替代弹性 | (F3), 稳态 |
| 参数 | `habit`, $\varrho$ | 外部习惯 | (F2) |
| 参数 | `sig`, $\sigma$ | 风险厌恶 | (F2) |
| 参数 | `vphi`, $\varphi$ | Frisch 弹性倒数 | (F14), (F16) |
| 参数 | `omega`, $\omega$ | Calvo 价格刚性 | (F3) |
| 参数 | `price_index`, $\xi_p$ | 价格指数化 | (F3) |
| 参数 | `xi`, $\xi$ | 匹配函数中失业弹性 | (F5) |
| 参数 | `eta`, $\eta$ | 工人议价能力 | (F10) |
| 参数 | `gamma`, $\gamma$ | Calvo 工资刚性 | (F10), (F12)-(F17) |
| 参数 | `wage_index`, $\xi_w$ | 工资指数化 | (F12)-(F17) |
| 参数 | `vtheta`, $\vartheta$ | 分离率 | (F6), (F13)-(F17) |
| 参数 | `alp`, $\alpha$ | 劳动品生产中劳动弹性 | (F11), (F19) |
| 参数 | `gamma_R`, `gamma_Pi`, `gamma_y`, `gamma_dy` | Taylor 规则系数 | (F23) |
| 参数 | `rho_*`, `sig_inno*` | 冲击持续性和创新尺度 | (F25)-(F32) |
| 参数 / 稳态 | `cbar`, `gbar`, `hbar`, `Jbar`, `Deltabar`, `mbar`, `nbar`, `qbar`, `sbar`, `vbar`, `wbar`, `ybar` | 稳态缩放量 | 第 6 节 |
