# NK_CK08 -- 推导（最优化问题 + 一阶条件）

> `NK_CK08` 的第一轮归档抽取。状态：`needs_review`。未执行运行时验证。

出处：Kai Christoffel and Keith Kuester (2008), "Resuscitating the wage channel in models with unemployment fluctuations", Journal of Monetary Economics 55(5), 865-887, DOI `10.1016/j.jmoneco.2008.03.009`。源 Markdown：`raw/mmb_mineru/runs/nk_ck08__resuscitating_the_wage_channel_in_models_with_unemployment__9824f7f5/full.md`。原始 PDF：`raw/mmb_papers/Resuscitating the wage channel in models with unemployment.pdf`。MinerU run id：`9824f7f5-cffe-47c7-8bf0-1ade5a06c243`。

## 1. Model Overview

- **模型**：带搜索匹配失业、right-to-manage 工资谈判、Calvo 名义工资设定、Calvo 价格设定和工作相关固定成本的新凯恩斯模型。
- **归档形式**：围绕月度稳态的线性化均衡系统，`model(linear)`。带帽变量表示相对稳态的对数偏离，但利率/通胀变量遵循论文附录和 MMB 实现的约定。
- **主要主体和模块**：代表性家庭、零售聚合部门、批发定价企业、劳动品企业、匹配工人、发布职位的企业、货币当局和 Ricardian 财政当局。
- **核心机制**：工资直接影响劳动品价格并进而影响边际成本；固定成本使劳动企业利润较小，从而放大职位空缺和失业的反应。
- **实现交叉核对**：`.agents/skills/dynare-copilot/references/examples/NK_CK08_rep.mod` 是论文月度模型的季度再校准版本。它确认了 `model(linear)` 模块和变量覆盖，但不作为论文侧来源。

## 2. Optimization Problems

### 2.1 代表性家庭

家庭在就业和失业成员之间汇集收入，选择消费和名义债券持有，并在边际效用中体现习惯形成：

$$
\max_{\{c_t,D_t\}} E_0 \sum_{t=0}^{\infty}\beta^t
U(c_t,c_{t-1},u_t,\{h_{i,t}\})
$$

约束为：

$$
c_t+t_t=\int_0^{1-u_t} w_{i,t}h_{i,t}di+u_tb+
\frac{D_{t-1}}{P_t}R_{t-1}\varepsilon^b_{t-1}
-\frac{D_t}{P_t}+\Psi_t .
$$

边际效用为：

$$
\lambda_t=(c_t-\varrho c_{t-1})^{-\sigma}.
$$

### 2.2 零售和批发企业

零售商聚合差异化产品：

$$
y_t=\left(\int_0^1 y_{j,t}^{(\varepsilon-1)/\varepsilon}dj\right)^{\varepsilon/(\varepsilon-1)} .
$$

批发企业以一比一技术使用同质劳动品：

$$
y_{j,t}=y_{j,t}^{L,d},
$$

能够重新定价的企业选择 $P^*_{t}$ 以最大化：

$$
E_t\sum_{s=0}^{\infty}\omega^s\beta_{t,t+s}
\left[\frac{P^*_t}{P_{t+s}}-mc_{t+s}\right]y_{j,t+s}.
$$

### 2.3 劳动品企业、匹配和工资谈判

一个劳动品企业是一对已匹配的工人-企业关系：

$$
y^L_{i,t}=z_t h_{i,t}^{\alpha},\qquad \alpha\in(0,1).
$$

给定谈判得到的名义小时工资，right-to-manage 企业根据边际利润条件选择工时：

$$
x^L_t z_t\alpha h_{i,t}^{\alpha-1}=\frac{W_{i,t}}{P_t}.
$$

进入 Nash 谈判的工人剩余和企业价值为：

$$
\Delta_t(W_{i,t})=V_t^E(W_{i,t})-U_t,
$$

$$
J_t(W_{i,t})=\Psi_t^L(W_{i,t})+(1-\vartheta)E_t\{\beta_{t,t+1}[\gamma J_{t+1}(W_{i,t})+(1-\gamma)J_{t+1}(W^*_{t+1})]\}.
$$

重置工资满足：

$$
\max_{W_{i,t}}\,[\Delta_t(W_{i,t})]^{\eta_t}[J_t(W_{i,t})]^{1-\eta_t}.
$$

### 2.4 职位发布和政府

自由进入使职位空缺价值为零：

$$
\kappa=q_tE_t\{\beta_{t,t+1}[\gamma J_{t+1}(W_t)+(1-\gamma)J_{t+1}(W^*_{t+1})]\}.
$$

货币当局对名义利率采用 Taylor 型规则，政府通过一次总付税和债务为失业救济、债务服务和外生政府支出融资。

## 3. First-Order Conditions

下面的线性化系统来自论文附录 A.2 的 RTM 模型经济；本归档为其分配连续方程编号。若干较长的工资剩余递推式标为 `needs_review`，因为 MinerU 源中 $\vartheta$ 与 `9` 等符号存在 OCR 歧义；其经济含义已用复制 `.mod` 交叉核对。

- **(F1) 消费 Euler 方程**：
$$
\widehat{\lambda}_t=E_t\{\widehat{\lambda}_{t+1}+\widehat R_t+\widehat\varepsilon^b_t-\widehat\Pi_{t+1}\}.
$$

- **(F2) 消费边际效用**：
$$
\widehat{\lambda}_t=-\frac{\sigma}{1-\varrho}\left(\widehat c_t-\varrho\widehat c_{t-1}\right).
$$

- **(F3) 新凯恩斯 Phillips 曲线**：
$$
\widehat\Pi_t=\beta E_t\{\widehat\Pi_{t+1}\}+
\frac{(1-\omega)(1-\omega\beta)}{\omega}\widehat{mc}_t .
$$

- **(F4) 边际成本等于劳动品价格**：
$$
\widehat{mc}_t=\widehat{x}^L_t .
$$

- **(F5) 工资谈判一阶条件**：
$$
\widehat J^*_t+\widehat\delta^W_t=
\widehat\Delta^*_t+\widehat\delta^F_t-\frac{1}{1-\eta}\widehat\eta_t .
$$

- **(F6) right-to-manage 下的工时一阶条件**：
$$
\widehat{x}^L_t+\widehat z_t+(\alpha-1)\widehat h_t=\widehat w_t .
$$

- **(F7) 总体实际工资演化**：
$$
\widehat w_t=\gamma(\widehat w_{t-1}-\widehat\Pi_t)+(1-\gamma)\widehat w^*_t .
$$

- **(F8) 企业侧边际工资剩余递推式**（`needs_review`，OCR 敏感长式）：
$$
\begin{aligned}
\widehat\delta^F_t={}&[1-\beta(1-\vartheta)\gamma]\left[
-\frac{\alpha}{1-\alpha}\widehat w^*_t+
\frac{1}{1-\alpha}(\widehat{x}^L_t+\widehat z_t)\right] \\
&+\beta(1-\vartheta)\gamma E_t\left\{
-\frac{\alpha}{1-\alpha}(\widehat w^*_t-\widehat w^*_{t+1}-\widehat\Pi_{t+1})
+\widehat\delta^F_{t+1}+\widehat\lambda_{t+1}-\widehat\lambda_t\right\}.
\end{aligned}
$$

- **(F9) 工人侧边际工资剩余递推式**（`needs_review`，OCR 敏感长式）：
$$
\begin{aligned}
\delta^W\widehat\delta^W_t={}&-\frac{\alpha}{1-\alpha}wh
\left[-\frac{\alpha}{1-\alpha}\widehat w^*_t+
\frac{1}{1-\alpha}(\widehat{x}^L_t+\widehat z_t)\right] \\
&+\frac{1}{1-\alpha}mrsh
\left[-\frac{1+\varphi}{1-\alpha}\widehat w^*_t-\widehat\lambda_t+
\frac{1+\varphi}{1-\alpha}(\widehat{x}^L_t+\widehat z_t)\right] \\
&+\frac{\beta(1-\vartheta)\gamma}{1-\beta(1-\vartheta)\gamma}
\left[\left(\frac{\alpha}{1-\alpha}\right)^2wh-
\frac{1+\varphi}{(1-\alpha)^2}mrsh\right]
E_t\{\widehat w^*_t-\widehat w^*_{t+1}-\widehat\Pi_{t+1}\} \\
&+\beta(1-\vartheta)\gamma\delta^W
E_t\{\widehat\lambda_{t+1}-\widehat\lambda_t+\widehat\delta^W_{t+1}\}.
\end{aligned}
$$

- **(F10) 重置工资劳动企业的价值**（`needs_review`）：
$$
\begin{aligned}
J\widehat J^*_t={}&\frac{wh}{\alpha}
[-\alpha\widehat w^*_t+\widehat{x}^L_t+\widehat z_t] \\
&+\frac{\beta(1-\vartheta)\gamma}{1-\beta(1-\vartheta)\gamma}wh
E_t\{\widehat w^*_{t+1}+\widehat\Pi_{t+1}-\widehat w^*_t\} \\
&+\beta(1-\vartheta)J
E_t\{\widehat\lambda_{t+1}-\widehat\lambda_t+\widehat J^*_{t+1}\}.
\end{aligned}
$$

- **(F11) 重置工资下的工人剩余**（`needs_review`）：
$$
\begin{aligned}
\Delta\widehat\Delta^*_t={}&\frac{wh}{1-\alpha}
[-\alpha\widehat w^*_t+\widehat{x}^L_t+\widehat z_t]\\
&-\frac{mrsh}{1+\varphi}\left[
\frac{1+\varphi}{1-\alpha}(-\widehat w^*_t+\widehat{x}^L_t+\widehat z_t)
-\widehat\lambda_t\right] \\
&+\frac{\beta(1-\vartheta)\gamma}{1-\beta(1-\vartheta)\gamma}
\left[\frac{\alpha}{1-\alpha}wh-\frac{1}{1-\alpha}mrsh\right]
E_t\{\widehat w^*_{t+1}+\widehat\Pi_{t+1}-\widehat w^*_t\}\\
&-\frac{\beta\gamma s}{1-\beta(1-\vartheta)\gamma}
\left[\frac{\alpha}{1-\alpha}wh-\frac{1}{1-\alpha}mrsh\right]
E_t\{\widehat w^*_{t+1}+\widehat\Pi_{t+1}-\widehat w_t\}\\
&+\beta(1-\vartheta-s)\Delta
E_t\{\widehat\lambda_{t+1}-\widehat\lambda_t+\widehat\Delta^*_{t+1}\}
-\beta\Delta s\widehat s_t .
\end{aligned}
$$

- **(F12) 职位发布条件**：
$$
-\frac{\kappa}{q}\widehat q_t=
\frac{\beta\gamma}{1-\beta(1-\vartheta)\gamma}wh
E_t\{\widehat w^*_{t+1}+\widehat\Pi_{t+1}-\widehat w_t\}
+\beta J E_t\{\widehat\lambda_{t+1}-\widehat\lambda_t+\widehat J^*_{t+1}\}.
$$

## 4. Market Clearing & Identities

- **(F13) Cobb-Douglas 匹配函数**：
$$
\widehat m_t=\xi\widehat u_t+(1-\xi)\widehat v_t .
$$

- **(F14) 就业运动方程**：
$$
\widehat n_t=(1-\vartheta)\widehat n_{t-1}+\frac{m}{n}\widehat m_{t-1}.
$$

- **(F15) 就业-失业关系**：
$$
\widehat n_t=-\frac{u}{1-u}\widehat u_t .
$$

- **(F16) 企业找到工人的概率**：
$$
\widehat q_t=\widehat m_t-\widehat v_t .
$$

- **(F17) 工人找到工作的概率**：
$$
\widehat s_t=\widehat m_t-\widehat u_t .
$$

- **(F18) 资源约束**：
$$
y\widehat y_t=c\widehat c_t+g\widehat g_t+\kappa v\widehat v_t+\Phi n\widehat n_t .
$$

- **(F19) 总量生产**：
$$
\widehat y_t=\widehat z_t+\alpha\widehat h_t+\widehat n_t .
$$

- **(F20) 平均劳动品利润**：
$$
\widehat\Psi^L_t=
\frac{\frac{1-\alpha}{\alpha}wh}{\frac{1-\alpha}{\alpha}wh-\Phi}
(\widehat w_t+\widehat h_t).
$$

- **(F21) 年化通胀恒等式**：
$$
\widehat\Pi^a_t=\widehat\Pi_t+\widehat\Pi_{t-1}+\widehat\Pi_{t-2}+\widehat\Pi_{t-3}.
$$

## 5. Exogenous Processes

- **(F22) 带利率平滑的 Taylor 规则**：
$$
\widehat R_t=\gamma_R\widehat R_{t-1}
+(1-\gamma_R)\left[\frac{\gamma_\pi}{12}\widehat\Pi^a_{t-1}
+\frac{\gamma_y}{12}\widehat y_t\right]
+\widehat\varepsilon^{money}_t .
$$

- **(F23) 偏好/风险溢价冲击**：
$$
\widehat\varepsilon^b_t=\rho_b\widehat\varepsilon^b_{t-1}+\zeta^b_t,\qquad
\zeta^b_t\sim iid\,N(0,\sigma_b^2).
$$

- **(F24) 技术冲击**：
$$
\widehat z_t=\rho_z\widehat z_{t-1}+\zeta^z_t,\qquad
\zeta^z_t\sim iid\,N(0,\sigma_z^2).
$$

- **(F25) 政府支出冲击**：
$$
\widehat g_t=\rho_g\widehat g_{t-1}+\zeta^g_t,\qquad
\zeta^g_t\sim iid\,N(0,\sigma_g^2).
$$

- **(F26) 货币政策创新**：
$$
\widehat\varepsilon^{money}_t=\zeta^{money}_t,\qquad
\zeta^{money}_t\sim iid\,N(0,\sigma_{money}^2).
$$

## 6. Steady-State Solution

归档形式是线性化模型，因此模拟变量是围绕非零月度稳态的偏离。论文给出 RTM 模型的如下稳态系统：

1. 设 $\Pi=1$，论文月度记号中 $\Pi^a=4\Pi$，$R=\Pi/\beta$，且 $mc=x^L=(\varepsilon-1)/\varepsilon$。
2. 劳动力市场：
$$
m=\sigma_m u^\xi v^{1-\xi},\qquad \vartheta n=m,\qquad u=1-n,\qquad q=m/v,\qquad s=m/u.
$$
3. 边际效用和工时：
$$
\lambda=(c-\varrho c)^{-\sigma},\qquad
w=x^Lz\alpha h^{\alpha-1},\qquad
mrs=\frac{\kappa^L h^\varphi}{\lambda}.
$$
4. 谈判和边际工资剩余项：
$$
\eta J\delta^W=(1-\eta)\Delta\delta^F,
$$
$$
\delta^F=\frac{wh}{1-\beta(1-\vartheta)\gamma},
\qquad
\delta^W=\frac{h}{1-\beta(1-\vartheta)\gamma}
\left[-\frac{\alpha}{1-\alpha}w+\frac{1}{1-\alpha}mrs\right].
$$
5. 企业和工人价值：
$$
J=\frac{\frac{1-\alpha}{\alpha}wh-\Phi}{1-\beta(1-\vartheta)},\qquad
\Delta=\frac{wh-b-\frac{mrs\,h}{1+\varphi}}{1-\beta(1-\vartheta-s)}.
$$
6. 职位和资源方程：
$$
\kappa=q\beta J,\qquad
y=c+g+\kappa v+\Phi n,\qquad
y=nzh^\alpha.
$$

源文献中的校准目标包括 $y=1$、$h=1/3$、$u=0.0588$、季度找到工人的概率 0.70、替代率 $b/(wh)=0.4$ 以及 $c/(c+g)\approx0.65$。MMB 复制文件使用季度再校准，因此数值稳态不同于论文的月度校准。

## 7. Timing & Form Conventions

- **形式**：帽变量中的线性化 `model(linear)`。
- **频率**：论文模型为月度；可用 MMB 复制文件说明其被再校准为季度频率。
- **存量和流量**：新匹配 $m_t$ 在 $t+1$ 首次生产，因此 (F14) 中就业取决于滞后就业和滞后匹配。
- **名义合约**：Calvo 价格不能重新优化的概率为 $\omega$；Calvo 工资不能重新谈判的概率为 $\gamma$。
- **工资时序**：总体工资由经当前通胀调整的滞后实际工资和新重置工资共同决定，见 (F7)。
- **运行时验证**：本次归档未执行。

## 8. Variable & Parameter Reference Table

| 类别 | 符号 / ASCII 提示 | 含义 | 主要方程 |
|---|---|---|---|
| 内生变量 | $\widehat c_t$ / `ct` | 消费偏离 | (F2), (F18) |
| 内生变量 | $\widehat\lambda_t$ / `lambdat` | 边际效用偏离 | (F1), (F2) |
| 内生变量 | $\widehat R_t$ / `Rt` | 名义政策利率偏离 | (F1), (F22) |
| 内生变量 | $\widehat\Pi_t$ / `Pit` | 通胀偏离 | (F1), (F3), (F7) |
| 内生变量 | $\widehat\Pi^a_t$ / `Piannt` | 年化通胀偏离 | (F21), (F22) |
| 内生变量 | $\widehat{mc}_t$ / `mct` | 边际成本偏离 | (F3), (F4) |
| 内生变量 | $\widehat{x}^L_t$ / `xLt` | 劳动品价格偏离 | (F4), (F6) |
| 内生变量 | $\widehat w_t$ / `wt` | 总体实际工资偏离 | (F6), (F7) |
| 内生变量 | $\widehat w^*_t$ / `wstart` | 新重置工资偏离 | (F5), (F7)-(F11) |
| 内生变量 | $\widehat h_t$ / `ht` | 每个工人工时偏离 | (F6), (F19) |
| 内生变量 | $\widehat J^*_t$ / `Jstart` | 重置工资劳动企业价值 | (F5), (F10), (F12) |
| 内生变量 | $\widehat\Delta^*_t$ / `Deltastart` | 重置工资下工人剩余 | (F5), (F11) |
| 内生变量 | $\widehat\delta^F_t$ / `deltaFt` | 企业侧工资导数 | (F5), (F8) |
| 内生变量 | $\widehat\delta^W_t$ / `deltaWt` | 工人侧工资导数 | (F5), (F9) |
| 内生变量 | $\widehat m_t$ / `mt` | 新匹配偏离 | (F13), (F14) |
| 内生变量 | $\widehat n_t$ / `nt` | 就业偏离 | (F14), (F15), (F19) |
| 内生变量 | $\widehat u_t$ / `ut` | 失业偏离 | (F13), (F15), (F17) |
| 内生变量 | $\widehat v_t$ / `vt` | 职位空缺偏离 | (F13), (F16), (F18) |
| 内生变量 | $\widehat q_t$ / `qt` | 企业找到工人的概率偏离 | (F12), (F16) |
| 内生变量 | $\widehat s_t$ / `st` | 工人找到工作的概率偏离 | (F11), (F17) |
| 内生变量 | $\widehat y_t$ / `yt` | 产出偏离 | (F18), (F19), (F22) |
| 内生变量 | $\widehat\Psi^L_t$ | 平均劳动品利润偏离 | (F20) |
| 外生/状态 | $\widehat\varepsilon^b_t$ / `ebt` | 偏好/风险溢价冲击状态 | (F1), (F23) |
| 外生/状态 | $\widehat z_t$ / `zt` | 技术冲击状态 | (F6), (F19), (F24) |
| 外生/状态 | $\widehat g_t$ / `gt` | 政府支出冲击状态 | (F18), (F25) |
| 外生/状态 | $\widehat\varepsilon^{money}_t$ / `emoneyt` | 货币政策冲击状态 | (F22), (F26) |
| 创新 | $\zeta^b_t$ / `inno_ebt` | 偏好/风险溢价创新 | (F23) |
| 创新 | $\zeta^z_t$ / `inno_zt` | 技术创新 | (F24) |
| 创新 | $\zeta^g_t$ / `g_` | 政府支出创新 | (F25) |
| 创新 | $\zeta^{money}_t$ / `interest_` | 货币政策创新 | (F26) |
| 参数 | $\beta,\sigma,\varrho,\varphi,\kappa^L$ | 偏好参数 | (F1), (F2), (F9), 稳态 |
| 参数 | $\varepsilon,\omega$ | 价格加成和 Calvo 价格黏性 | (F3), 稳态 |
| 参数 | $\xi,\sigma_m,\vartheta,\kappa$ | 匹配、分离率、职位发布成本 | (F12)-(F17), 稳态 |
| 参数 | $\eta,\gamma,\alpha,\Phi,b$ | 谈判、工资黏性、劳动生产、固定成本、失业救济 | (F5)-(F12), (F18)-(F20) |
| 参数 | $\gamma_R,\gamma_\pi,\gamma_y$ | Taylor 规则系数 | (F22) |
| 参数 | $\rho_b,\rho_z,\rho_g,\sigma_b,\sigma_z,\sigma_g,\sigma_{money}$ | 冲击持久性和创新尺度 | (F23)-(F26) |
