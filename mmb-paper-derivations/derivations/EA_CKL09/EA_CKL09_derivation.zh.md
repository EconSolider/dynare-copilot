# EA_CKL09 -- 推导

状态：`needs_review`，基于 MinerU Markdown 的第一轮抽取。未执行 Dynare 或运行时验证。

来源：Kai Christoffel, Keith Kuester, and Tobias Linzert (2009), "The role of labor markets for euro area monetary policy", European Economic Review 53(8), 908-936, DOI `10.1016/j.euroecorev.2009.04.007`。

## 1. 模型概述

- **模型 ID**：`EA_CKL09`。
- **经济体与目的**：闭合经济欧元区 New Keynesian DSGE 模型，含 Mortensen-Pissarides 搜索匹配摩擦、right-to-manage 工时选择、Calvo 价格刚性和 Calvo 工资谈判刚性。
- **实现形式**：MMB 复现文件交叉检查显示为 `model(linear)`。论文给出非线性均衡对象和 Appendix A 线性化经济；本归档记录估计版本实现使用的线性化系统。
- **主要主体和模块**：代表性大家庭、零售聚合商、批发 Calvo 定价者、劳动品企业、匹配工人、发布空缺的企业、财政当局和货币当局。
- **来源嗅探**：Markdown 开头匹配预期标题和作者。未发现标题/作者不匹配。

## 2. 优化问题

### 代表性大家庭

家庭汇总就业和失业成员，并选择消费、债券持有和空缺发布，同时内化成员效用：

$$
E_0\sum_{t=0}^{\infty}\beta^t
\left[
\frac{(c_{i,t}-\varrho c_{t-1})^{1-\sigma}}{1-\sigma}
-\kappa^L\frac{h_{i,t}^{1+\varphi}}{1+\varphi}
\right].
$$

家庭预算约束为：

$$
c_t+t_t+\kappa_t\nu_t
=\int_0^{1-u_t}w_{i,t}h_{i,t}\,di+u_tb
+\frac{D_{t-1}}{P_t}R_{t-1}\varepsilon^b_{t-1}
-\frac{D_t}{P_t}
+\Psi_t+n_t\Phi^K .
$$

边际效用为 $\lambda_t=(c_t-\varrho c_{t-1})^{-\sigma}$。

### 零售聚合商

竞争性零售商聚合差异化批发品：

$$
y_t=\left(\int_0^1 y_{j,t}^{(\varepsilon-1)/\varepsilon}\,dj\right)^{\varepsilon/(\varepsilon-1)}.
$$

成本最小化推出价格指数和需求函数：

$$
P_t=\left(\int_0^1P_{j,t}^{1-\varepsilon}\,dj\right)^{1/(1-\varepsilon)},\qquad
y_{j,t}=\left(\frac{P_{j,t}}{P_t}\right)^{-\varepsilon}y_t .
$$

### 批发定价企业

批发企业 $j$ 每生产一单位产出使用一单位劳动品：

$$
y_{j,t}=l^d_{j,t}.
$$

可以重设价格的企业在 Calvo 价格刚性 $\omega$ 和价格指数化 $\xi_p$ 下选择 $P^{\ast}_t$，最大化贴现预期利润：

$$
\max_{P_{j,t}}E_t\sum_{s=0}^{\infty}\omega^s\beta_{t,t+s}
\left[
\frac{P_{j,t}\left(\Pi_{t-1,t-1+s}^{\xi_p}\Pi^{1-\xi_p}\right)^s}{P_{t+s}}
-mc_{t+s}
\right]y_{j,t+s}.
$$

### 劳动品企业和工资谈判

每个已匹配的劳动品企业生产：

$$
l_{i,t}=z_t h_{i,t}^{\alpha},\qquad \alpha\in(0,1).
$$

给定小时工资，企业在 right-to-manage 下选择工时。工资重设者就工人剩余 $\Delta_t(W_{i,t})$ 和企业价值 $J_t(W_{i,t})$ 解 Nash 谈判问题：

$$
\arg\max_{W_{i,t}}\left[\Delta_t(W_{i,t})\right]^{\eta_t}
\left[J_t(W_{i,t})\right]^{1-\eta_t}\Rightarrow W_t^{\ast} .
$$

空缺发布由自由进入决定，因此真实空缺成本等于已填补工作岗位价值的贴现期望。

## 3. 一阶条件

**(F1) 消费 Euler 方程**

$$
1=E_t\left\{\beta\frac{\lambda_{t+1}}{\lambda_t}
\frac{R_t\varepsilon^b_t}{\Pi_{t+1}}\right\}.
$$

线性化形式：

$$
\hat{\lambda}_t=E_t\{\hat{\lambda}_{t+1}+\hat{R}_t+\hat{\varepsilon}^b_t-\hat{\Pi}_{t+1}\}.
$$

**(F2) 消费边际效用**

$$
\hat{\lambda}_t=-\frac{\sigma}{1-\varrho}(\hat{c}_t-\varrho\hat{c}_{t-1}).
$$

**(F3) 批发 Calvo 定价 FOC**

$$
E_t\sum_{s=0}^{\infty}\omega^s\beta_{t,t+s}
\left[
\frac{P_t^{\ast}\left(\Pi_{t-1,t-1+s}^{\xi_p}\Pi^{1-\xi_p}\right)^s}{P_{t+s}}
-\frac{\varepsilon}{\varepsilon-1}mc_{t+s}
\right]y_{j,t+s}=0.
$$

线性化 Phillips 曲线：

$$
\hat{\Pi}_t=
\frac{\xi_p}{1+\beta\xi_p}\hat{\Pi}_{t-1}
+\frac{\beta}{1+\beta\xi_p}E_t\hat{\Pi}_{t+1}
+\frac{(1-\omega)(1-\omega\beta)}{\omega(1+\beta\xi_p)}\hat{mc}_t.
$$

**(F4) 边际成本**

$$
\hat{mc}_t=\hat{e}^C_t+\hat{x}^L_t.
$$

论文还报告了工资渠道：

$$
\hat{mc}_t=\hat{e}^C_t+\hat{w}_t+(1-\alpha)\hat{h}_t .
$$

**(F5) 劳动品企业工时条件**

$$
x^L_t\,z_t\alpha h_{i,t}^{\alpha-1}=\frac{W_{i,t}}{P_t}.
$$

线性化总量工时条件：

$$
\hat{w}_t=\hat{x}^L_t+\hat{z}_t+(\alpha-1)\hat{h}_t.
$$

**(F6) 工人就业价值**

$$
\begin{aligned}
V_t^E(W_{i,t})={}&\frac{W_{i,t}}{P_t}h_{i,t}
-\kappa^L\frac{h_{i,t}^{1+\varphi}}{(1+\varphi)\lambda_t}\\
&+E_t\{\beta_{t,t+1}(1-\vartheta_{t+1})
[\gamma V_{t+1}^E(W_{i,t}\Pi_t^{\xi_w}\Pi^{1-\xi_w})
+(1-\gamma)V_{t+1}^E(W^{\ast}_{t+1})]\}\\
&+E_t\{\beta_{t,t+1}\vartheta_{t+1}U_{t+1}\}.
\end{aligned}
$$

**(F7) 工人失业价值**

$$
\begin{aligned}
U_t={}&b+E_t\{\beta_{t,t+1}s_t[
\gamma V_{t+1}^E(W_t\Pi_t^{\xi_w}\Pi^{1-\xi_w})
+(1-\gamma)V_{t+1}^E(W^{\ast}_{t+1})]\}\\
&+E_t\{\beta_{t,t+1}(1-s_t)U_{t+1}\}.
\end{aligned}
$$

**(F8) 工人剩余**

$$
\Delta_t(W_{i,t})=V_t^E(W_{i,t})-U_t.
$$

OCR 来源中的展开式较长且有轻微 OCR 噪声；这里保留上面的恒等式，并标记为 `needs_review`，需在推广前做来源级公式检查。

**(F9) 已匹配劳动品企业价值**

$$
J_t(W_{i,t})=\Psi^L_t(W_{i,t})
+E_t\{\beta_{t,t+1}(1-\vartheta_{t+1})
[\gamma J_{t+1}(W_{i,t}\Pi_t^{\xi_w}\Pi^{1-\xi_w})
+(1-\gamma)J_{t+1}(W^{\ast}_{t+1})]\}.
$$

**(F10) 劳动品企业当期利润**

$$
\Psi^L_t(W_{i,t})=x^L_tz_t h_{i,t}^{\alpha}
-\frac{W_{i,t}}{P_t}h_{i,t}-\Phi.
$$

**(F11) Nash 工资重设条件**

$$
\eta_t J_t(W_t^{\ast})\,\frac{\partial \Delta_t(W_t^{\ast})}{\partial W_t}
+(1-\eta_t)\Delta_t(W_t^{\ast})\,\frac{\partial J_t(W_t^{\ast})}{\partial W_t}=0.
$$

线性化实现形式：

$$
\hat{J}^{\ast}_t+\hat{\delta}^W_t
=\hat{\Delta}^{\ast}_t+\hat{\delta}^F_t-\frac{1}{1-\eta}\hat{\eta}_t .
$$

导数记号和线性化方程均需对 Appendix OCR 做 `needs_review` 检查。

**(F12) 总量真实工资运动方程**

$$
\hat{w}_t=\gamma(\hat{w}_{t-1}-\hat{\Pi}_t+\xi_w\hat{\Pi}_{t-1})
+(1-\gamma)\hat{w}^{\ast}_t.
$$

**(F13) 企业工资导数辅助变量**

$$
\begin{aligned}
\hat{\delta}^F_t={}&[1-\beta(1-\vartheta)\gamma]
\left[-\frac{\alpha}{1-\alpha}\hat{w}^{\ast}_t
+\frac{1}{1-\alpha}(\hat{x}^L_t+\hat{z}_t)\right]\\
&+\beta(1-\vartheta)\gamma E_t\left\{
-\frac{\alpha}{1-\alpha}(\hat{w}^{\ast}_t-\hat{\Pi}_{t+1}
+\xi_w\hat{\Pi}_t-\hat{w}^{\ast}_{t+1})
+\hat{\delta}^F_{t+1}
+\hat{\lambda}_{t+1}-\hat{\lambda}_t
-\frac{\vartheta}{1-\vartheta}\hat{\vartheta}_{t+1}
\right\}.
\end{aligned}
$$

**(F14) 工人工资导数辅助变量**

$$
\begin{aligned}
\delta^W\hat{\delta}^W_t={}&
-\frac{\alpha}{1-\alpha}wh
\left[-\frac{\alpha}{1-\alpha}\hat{w}^{\ast}_t
+\frac{1}{1-\alpha}(\hat{x}^L_t+\hat{z}_t)\right]\\
&+\frac{1}{1-\alpha}mrsh
\left[-\frac{1+\varphi}{1-\alpha}\hat{w}^{\ast}_t-\hat{\lambda}_t
+\frac{1+\varphi}{1-\alpha}(\hat{x}^L_t+\hat{z}_t)\right]\\
&+\frac{\beta(1-\vartheta)\gamma}{1-\beta(1-\vartheta)\gamma}
\left[\left(\frac{\alpha}{1-\alpha}\right)^2wh
-\frac{1+\varphi}{(1-\alpha)^2}mrsh\right]
E_t(\hat{w}^{\ast}_t-\hat{\Pi}_{t+1}+\xi_w\hat{\Pi}_t-\hat{w}^{\ast}_{t+1})\\
&+\beta(1-\vartheta)\gamma\delta^W
E_t(\hat{\lambda}_{t+1}-\hat{\lambda}_t+\hat{\delta}^W_{t+1}
-\frac{\vartheta}{1-\vartheta}\hat{\vartheta}_{t+1}).
\end{aligned}
$$

该 OCR 抽取的 Appendix 方程为 `needs_review`。

**(F15) 空缺发布自由进入条件**

$$
\kappa_t=q_tE_t\{\beta_{t,t+1}[
\gamma J_{t+1}(W_t\Pi_t^{\xi_w}\Pi^{1-\xi_w})
+(1-\gamma)J_{t+1}(W^{\ast}_{t+1})]\}.
$$

线性化形式：

$$
\frac{\kappa}{q}(\hat{\kappa}_t-\hat{q}_t)
=\frac{\beta\gamma}{1-\beta(1-\vartheta)\gamma}wh
E_t(\hat{w}^{\ast}_{t+1}+\hat{\Pi}_{t+1}-\hat{w}_t-\xi_w\hat{\Pi}_t)
+\beta J E_t(\hat{\lambda}_{t+1}-\hat{\lambda}_t+\hat{J}^{\ast}_{t+1}).
$$

**(F16) 重设工资企业价值**

$$
\begin{aligned}
J\hat{J}^{\ast}_t={}&\frac{wh}{\alpha}(-\alpha\hat{w}^{\ast}_t+\hat{x}^L_t+\hat{z}_t)\\
&+\frac{\beta(1-\vartheta)\gamma}{1-\beta(1-\vartheta)\gamma}wh
E_t(\hat{w}^{\ast}_{t+1}+\hat{\Pi}_{t+1}-\hat{w}^{\ast}_t-\xi_w\hat{\Pi}_t)\\
&+\beta(1-\vartheta)J
E_t(\hat{\lambda}_{t+1}-\hat{\lambda}_t+\hat{J}^{\ast}_{t+1}
-\frac{\vartheta}{1-\vartheta}\hat{\vartheta}_{t+1}).
\end{aligned}
$$

该 Appendix OCR 方程为 `needs_review`。

**(F17) 重设工资工人剩余价值**

$$
\begin{aligned}
\Delta\hat{\Delta}^{\ast}_t={}&
wh\frac{1}{1-\alpha}(-\alpha\hat{w}^{\ast}_t+\hat{x}^L_t+\hat{z}_t)\\
&-\frac{1}{1+\varphi}mrsh
\left[\frac{1+\varphi}{1-\alpha}(-\hat{w}^{\ast}_t+\hat{x}^L_t+\hat{z}_t)-\hat{\lambda}_t\right]\\
&+\frac{\beta(1-\vartheta)\gamma}{1-\beta(1-\vartheta)\gamma}
\left[\frac{\alpha}{1-\alpha}wh-\frac{1}{1-\alpha}mrsh\right]
E_t(\hat{w}^{\ast}_{t+1}+\hat{\Pi}_{t+1}-\hat{w}^{\ast}_t-\xi_w\hat{\Pi}_t)\\
&-\frac{\beta\gamma s}{1-\beta(1-\vartheta)\gamma}
\left[\frac{\alpha}{1-\alpha}wh-\frac{1}{1-\alpha}mrsh\right]
E_t(\hat{w}^{\ast}_{t+1}+\hat{\Pi}_{t+1}-\hat{w}_t-\xi_w\hat{\Pi}_t)\\
&+\beta(1-\vartheta-s)\Delta
E_t(\hat{\lambda}_{t+1}-\hat{\lambda}_t+\hat{\Delta}^{\ast}_{t+1})
-\beta\Delta s\hat{s}_t-\beta\Delta\vartheta E_t\hat{\vartheta}_{t+1}.
\end{aligned}
$$

该 Appendix OCR 方程为 `needs_review`。

## 4. 市场出清与恒等式

**(F18) 匹配函数**

$$
m_t=\sigma_m u_t^{\xi}\nu_t^{1-\xi}.
$$

线性化：

$$
\hat{m}_t=\xi\hat{u}_t+(1-\xi)\hat{\nu}_t.
$$

**(F19) 劳动力市场紧张度**

$$
\theta_t=\frac{\nu_t}{u_t}.
$$

**(F20) 空缺填补概率**

$$
q_t=\frac{m_t}{\nu_t}=\sigma_m\theta_t^{-\xi},\qquad
\hat{q}_t=\hat{m}_t-\hat{\nu}_t.
$$

**(F21) 找到工作概率**

$$
s_t=\frac{m_t}{u_t}=\sigma_m\theta_t^{1-\xi},\qquad
\hat{s}_t=\hat{m}_t-\hat{u}_t.
$$

**(F22) 就业运动方程**

$$
n_t=(1-\vartheta_t)n_{t-1}+m_{t-1}.
$$

线性化：

$$
\hat{n}_t=(1-\vartheta)\hat{n}_{t-1}+\frac{m}{n}\hat{m}_{t-1}
-\vartheta\hat{\vartheta}_t.
$$

**(F23) 失业恒等式**

$$
n_t=1-u_t,\qquad
\hat{n}_t=-\frac{u}{1-u}\hat{u}_t.
$$

**(F24) 零售资源约束**

$$
y^d_t=c_t+g_t+\kappa_t\nu_t+n_t\Phi^L.
$$

线性化：

$$
y\hat{y}_t=c\hat{c}_t+g\hat{g}_t+\kappa\nu(\hat{\kappa}_t+\hat{\nu}_t)+\Phi^L n\hat{n}_t.
$$

**(F25) 总量生产**

$$
y_t=n_t z_t h_t^\alpha,\qquad
\hat{y}_t=\hat{z}_t+\alpha\hat{h}_t+\hat{n}_t.
$$

**(F26) 政府预算约束**

$$
t_t+\frac{D_t}{P_t}+(e^C_t-1)x^L_t
=u_tb+\frac{D_{t-1}}{P_t}R_{t-1}\varepsilon^b_{t-1}+g_t.
$$

**(F27) 同比通胀恒等式**

$$
\hat{\Pi}^{yoy}_t=\hat{\Pi}_t+\hat{\Pi}_{t-1}+\hat{\Pi}_{t-2}+\hat{\Pi}_{t-3}.
$$

**(F28) 平均劳动企业利润**

$$
\hat{\Psi}^L_t=A(\hat{w}_t+\hat{h}_t),\qquad
A=\frac{\frac{1-\alpha}{\alpha}wh}{\frac{1-\alpha}{\alpha}wh-\Phi}.
$$

**(F29) 平均批发利润**

$$
\Psi^C\hat{\Psi}^C_t=(1-mc)y\hat{y}_t-ymc\hat{mc}_t.
$$

## 5. 外生过程

**(F30) 风险溢价冲击**

$$
\log(\varepsilon^b_t)=\rho_b\log(\varepsilon^b_{t-1})+e^b_t.
$$

线性化实现交叉检查：

$$
\hat{\varepsilon}^b_t=\rho_b\hat{\varepsilon}^b_{t-1}+\sigma_b\epsilon^b_t.
$$

**(F31) 技术**

$$
\log(z_t)=(1-\rho_z)\log(z)+\rho_z\log(z_{t-1})+e^z_t.
$$

**(F32) 分离率**

$$
\log(\vartheta_t)=(1-\rho_\vartheta)\log(\vartheta)
+\rho_\vartheta\log(\vartheta_{t-1})+e^\vartheta_t.
$$

**(F33) 谈判能力**

$$
\log(\eta_t)=(1-\rho_\eta)\log(\eta)+\rho_\eta\log(\eta_{t-1})+e^\eta_t.
$$

**(F34) 空缺发布成本**

$$
\log(\kappa_t)=(1-\rho_\kappa)\log(\kappa)+\rho_\kappa\log(\kappa_{t-1})+e^\kappa_t.
$$

**(F35) 政府支出**

$$
\log(g_t)=(1-\rho_g)\bar{g}+\rho_g\log(g_{t-1})+e^g_t.
$$

**(F36) 货币政策规则**

$$
\begin{aligned}
\log(R_t)={}&(1-\gamma_R)\log\left(\frac{\bar{\Pi}}{\beta}\right)
+\gamma_R\log(R_{t-1})
+\gamma_{\Delta y}\log\left(\frac{y_t}{y_{t-1}}\right)\\
&+(1-\gamma_R)\left[
\frac{\gamma_\pi}{4}\log\left(\frac{(\Pi^{yoy}_t)}{\bar{\Pi}^4}\right)
+\frac{\gamma_y}{4}\log\left(\frac{y_t}{y^{flex}_t}\right)
\right]
+\log(e^{money}_t).
\end{aligned}
$$

线性化：

$$
\hat{R}_t=\gamma_R\hat{R}_{t-1}
+(1-\gamma_R)\left[\frac{\gamma_\pi}{4}\hat{\Pi}^{yoy}_t
+\frac{\gamma_y}{4}(\hat{y}_t-\hat{y}^{flex}_t)\right]
+\gamma_{\Delta y}(\hat{y}_t-\hat{y}_{t-1})+\hat{e}^{money}_t.
$$

**(F37) 成本推动冲击**

$$
\hat{e}^C_t=\rho_C\hat{e}^C_{t-1}+\sigma_C\epsilon^C_t.
$$

## 6. 稳态求解

Appendix A 报告的稳态用于对数线性化。模型对产出做归一化，并使用帽子变量表示相对确定性稳态的百分比偏离。

1. 利率：

$$
R=\frac{1}{\beta}.
$$

2. 边际效用：

$$
\lambda=(c-\varrho c)^{-\sigma}.
$$

3. 边际成本和劳动品价格：

$$
mc=x^L=\frac{\varepsilon-1}{\varepsilon}.
$$

4. 匹配和存量：

$$
m=\sigma_m u^\xi\nu^{1-\xi},\qquad
\vartheta n=m,\qquad
u=1-n,\qquad
q=\frac{m}{\nu},\qquad
s=\frac{m}{u}.
$$

5. 工资谈判稳态辅助条件：

$$
\eta J\delta^W=(1-\eta)\Delta\delta^F,
$$

$$
\delta^F=\frac{1}{1-\beta(1-\vartheta)\gamma}wh,
$$

$$
\delta^W=\frac{1}{1-\beta(1-\vartheta)\gamma}h
\left[-\frac{\alpha}{1-\alpha}w+\frac{1}{1-\alpha}mrs\right].
$$

6. 劳动企业对象：

$$
mrs=\frac{\kappa^L h^\varphi}{\lambda},\qquad
J=\frac{\Psi^L}{1-\beta(1-\vartheta)},\qquad
\Psi^L=x^Lzh^\alpha-wh-\Phi.
$$

7. 工人剩余、工时和空缺发布：

$$
\Delta=\frac{1}{1-\beta(1-\vartheta-s)}
\left[wh-\frac{mrs\,h}{1+\varphi}-b\right],
$$

$$
w=x^Lz\alpha h^{\alpha-1},\qquad
\kappa=q\beta J.
$$

8. 资源和生产：

$$
y=c+g+\kappa\nu+n\Phi^L,\qquad
y=nzh^\alpha.
$$

9. 批发利润：

$$
\Psi^C=(1-mc)y.
$$

论文记录的校准目标包括 $y=1$、$h=1/3$、$u\simeq 0.091$、$q=0.7$、政府支出约为 GDP 的 20%、以及替代率目标 $b/(wh)=0.65$。估计版本 `.mod` 交叉检查在适用处使用 Section 5 的后验/校准值；上面的稳态公式仍是论文侧证据。

## 7. 时序与形式约定

- **形式**：`model(linear)`；线性化系统中的变量是围绕确定性稳态的帽子/对数偏离对象。
- **匹配时序**：$t$ 期形成的匹配在 $t+1$ 期开始生产；就业满足 $n_t=(1-\vartheta_t)n_{t-1}+m_{t-1}$。
- **工资时序**：存续匹配和新形成匹配均受 Calvo 工资重设概率约束。未重设工资通过 $\xi_w$ 与滞后/稳态通胀指数化。
- **政策目标**：Taylor 规则响应同比通胀和相对于灵活价格/灵活工资经济的产出缺口。
- **无资本积累模块**：模型通过 $\Phi^K$ imputes 固定资本收入份额，而不显式建模实物资本积累。
- **运行时验证**：未执行。

## 8. 变量与参数对照表

| 类别 | 符号 / ASCII | 含义 | 主要方程 |
|---|---|---|---|
| 内生 | $\hat{c}_t$ / `ct` | 消费 | (F1), (F2), (F24) |
| 内生 | $\hat{\lambda}_t$ / `lambdat` | 边际效用 | (F1), (F2) |
| 内生 | $\hat{\Pi}_t$ / `Pit` | 通胀 | (F3), (F27) |
| 内生 | $\hat{\Pi}^{yoy}_t$ / `Piannt` | 同比通胀 | (F27), (F36) |
| 内生 | $\hat{R}_t$ / `Rt` | 名义政策利率 | (F1), (F36) |
| 内生 | $\hat{mc}_t$ / `mct` | 边际成本 | (F3), (F4) |
| 内生 | $\hat{x}^L_t$ / `xLt` | 劳动品真实价格 | (F4), (F5) |
| 内生 | $\hat{w}_t$ / `wt` | 总量真实工资 | (F5), (F12) |
| 内生 | $\hat{w}^{\ast}_t$ / `wstart` | 重设工资 | (F11)-(F17) |
| 内生 | $\hat{h}_t$ / `ht` | 每名工人工时 | (F5), (F25) |
| 内生 | $\hat{y}_t$ / `yt` | 产出 | (F24), (F25), (F36) |
| 内生 | $\hat{m}_t$ / `mt` | 匹配 | (F18), (F22) |
| 内生 | $\hat{n}_t$ / `nt` | 就业 | (F22), (F23), (F25) |
| 内生 | $\hat{u}_t$ / `ut` | 失业 | (F18), (F23) |
| 内生 | $\hat{\nu}_t$ / `vt` | 空缺 | (F18), (F20), (F24) |
| 内生 | $\hat{q}_t$ / `qt` | 空缺填补概率 | (F20), (F15) |
| 内生 | $\hat{s}_t$ / `st` | 找到工作概率 | (F21), (F17) |
| 内生 | $\hat{J}^{\ast}_t$ / `Jstart` | 重设工资企业价值 | (F11), (F16) |
| 内生 | $\hat{\Delta}^{\ast}_t$ / `Deltastart` | 重设工资工人剩余 | (F11), (F17) |
| 内生 | $\hat{\delta}^F_t$ / `deltaFt` | 企业工资导数辅助变量 | (F11), (F13) |
| 内生 | $\hat{\delta}^W_t$ / `deltaWt` | 工人工资导数辅助变量 | (F11), (F14) |
| 内生 | $\hat{y}^{flex}_t$ and flex variables | 灵活价格/灵活工资对应经济 | (F36) |
| 外生 | $\epsilon^b_t$ / `inno_ebt` | 风险溢价创新 | (F30) |
| 外生 | $\epsilon^z_t$ / `inno_zt` | 技术创新 | (F31) |
| 外生 | $\epsilon^\eta_t$ / `inno_ebargaint` | 谈判能力创新 | (F33) |
| 外生 | $\epsilon^\kappa_t$ / `inno_ekappat` | 空缺成本创新 | (F34) |
| 外生 | $\epsilon^\vartheta_t$ / `inno_esept` | 分离率创新 | (F32) |
| 外生 | $\epsilon^C_t$ / `inno_eCt` | 成本推动创新 | (F37) |
| 外生 | $\epsilon^{money}_t$ / `interest_` | 货币政策创新 | (F36) |
| 外生 | $\epsilon^g_t$ / `g_` | 政府支出创新 | (F35) |
| 参数 | $\beta,\sigma,\varrho,\varphi,\kappa^L$ | 偏好 | (F1), (F2), steady state |
| 参数 | $\varepsilon,\omega,\xi_p$ | 需求弹性和价格刚性 | (F3) |
| 参数 | $\alpha,z,\Phi,\Phi^K,\Phi^L$ | 劳动品生产和固定成本 | (F5), (F10), (F24), (F25) |
| 参数 | $\xi,\sigma_m,\vartheta,\eta,\gamma,\xi_w$ | 匹配、分离、谈判、工资刚性 | (F18)-(F23), (F11)-(F17) |
| 参数 | $\gamma_R,\gamma_\pi,\gamma_y,\gamma_{\Delta y}$ | 政策规则系数 | (F36) |
| 参数 | $\rho_b,\rho_z,\rho_\vartheta,\rho_\eta,\rho_\kappa,\rho_g,\rho_C$ | 冲击持续性 | (F30)-(F37) |
