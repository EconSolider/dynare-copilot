# G2_SIGMA08 -- 推导（最优化问题 + 均衡条件）

> 状态：`needs_review`。本一稿档案条目以 Erceg、Guerrieri 和 Gust (2008) 的 MinerU Markdown 为来源。本文记录论文中给出的 SIGMA 结构和 Rep-MMB 实现覆盖范围，但未执行运行时验证。

## 1. Model Overview

- **模型**：`G2_SIGMA08`，"Trade adjustment and the composition of trade"，Christopher J. Erceg、Luca Guerrieri 和 Christopher J. Gust，*Journal of Economic Dynamics and Control* 32(8), 2622-2650, 2008，DOI `10.1016/j.jedc.2007.09.015`。
- **用途**：比较 SIGMA 中两种开放经济贸易设定。基准的分解贸易（DT）设定区分消费品进口和投资品进口；吸收贸易（AT）设定使用一个私人吸收进口聚合器。
- **经济体**：两国 DSGE 模型。外国经济除规模和外国贸易份额校准外与本国经济对称。
- **主体和模块**：具有 Calvo 本国价格和出口价格的中间品企业、最终消费/投资品分销商、前瞻型（FL）家庭、即期消费（HM）家庭、工资设定者、财政当局、货币当局、外债中介成本，以及外生冲击过程。
- **形式**：围绕平衡增长稳态的对数线性化模型。Rep-MMB 实现交叉检查使用 `model(linear)`。
- **主要档案限制**：论文给出的是模型简述，并将完整 SIGMA 系统指向 Erceg et al. (2006)。论文或实现中没有明确显示的方程标为 `needs_review`。

## 2. Optimization Problems

### 2.1 中间品企业

中间品生产者是垄断竞争企业。每家企业在竞争性要素市场租用劳动和资本，并在本国和国外销售差异化产品。本国价格和出口价格采用 Calvo 合同；不能重新优化的企业按滞后通胀指数化。出口销售采用当地货币定价。

来源论文只概述生产端，而没有完整写出企业层面的最优化。Rep-MMB 实现交叉检查使用以下线性生产和边际成本模块：

$$
(1-q_K)(\ell_t+a_t)=y_t-q_K k_{t-1},
$$

外国经济有对称方程。因此，底层企业问题记录为 `needs_review`，等待从配套 SIGMA 文档做完整 CES 生产/成本最小化系统的来源级核验。

### 2.2 最终消费和投资品分销商：DT 设定

对每个最终用途 $V_t \in \{C_t,I_t\}$，代表性分销商选择本国产投入 $V_{Dt}$ 和进口投入 $M_{Vt}$，在 CES 技术约束下最小化成本：

$$
\min_{\{V_{Dt},M_{Vt}\}} \; P_{Dt}V_{Dt}+P_{Mt}M_{Vt}
\quad\text{s.t.}\quad
V_t =
\left(
\omega_V^{\frac{\rho_V}{1+\rho_V}} V_{Dt}^{\frac{1}{1+\rho_V}}
+(1-\omega_V)^{\frac{\rho_V}{1+\rho_V}}
(\varphi_{Vt}M_{Vt})^{\frac{1}{1+\rho_V}}
\right)^{1+\rho_V}.
$$

进口调整项是相对于滞后总体比率的进口/本国产投入比率的二次函数：

$$
\varphi_{Vt} =
1-\frac{\varphi_{M_V}\omega_V}{2}
\left(
\frac{M_{Vt}/V_{Dt}}{M^A_{V,t-1}/V^A_{D,t-1}}-1
\right)^2 .
$$

### 2.3 最终吸收分销商：AT 设定

在 AT 变体中，一个私人吸收品 $A_t \equiv C_t+I_t$ 由本国产投入 $A_{Dt}$ 和总进口 $M_t$ 生产：

$$
\min_{\{A_{Dt},M_t\}} \; P_{Dt}A_{Dt}+P_{Mt}M_t
\quad\text{s.t.}\quad
A_t =
\left(
\omega_A^{\frac{\rho_A}{1+\rho_A}} A_{Dt}^{\frac{1}{1+\rho_A}}
+(1-\omega_A)^{\frac{\rho_A}{1+\rho_A}}
(\varphi_{At}M_t)^{\frac{1}{1+\rho_A}}
\right)^{1+\rho_A},
$$

其中

$$
\varphi_{At} =
1-\frac{\varphi_{M_A}\omega_A}{2}
\left(
\frac{M_t/A_{Dt}}{M^A_{t-1}/A^A_{D,t-1}}-1
\right)^2 .
$$

### 2.4 前瞻型家庭

每个 FL 家庭成员选择消费、劳动、货币余额、投资、资本和金融资产。论文给出的单个成员预期效用为：

$$
\widetilde{E}_t \sum_{j=0}^{\infty}\beta^j
\left\{
\frac{(C_{t+j}(h)-\varkappa C^O_{t+j-1}-\nu_{c,t+j})^{1-\sigma}}{1-\sigma}
+\frac{\chi_0}{1-\chi}(1-N_{t+j}(h))^{1-\chi}
+\frac{\mu_0}{1-\mu}
\left(\frac{MB_{t+j+1}(h)}{P_{C,t+j}}\right)^{1-\mu}
\right\}.
$$

投资含有调整成本楔子：

$$
\phi_{It}(h)=\frac{1}{2}\phi_I
\frac{(I_t(h)-I_{t-1}(h))^2}{I_{t-1}(h)}.
$$

资本按下式演化：

$$
K_{t+1}(h)=(1-\delta)K_t(h)+I_t(h).
$$

完整跨期预算约束在论文中以文字说明：家庭获得税后资本收入、工资收入、企业利润和转移；支付扣除折旧抵免后的资本税；持有本国货币、政府债券、状态依存本国债券，以及带中介成本的非状态依存外国债券。完整的论文侧预算方程为 `needs_review`。

### 2.5 即期消费家庭和工资设定

HM 家庭将当期税后劳动可支配收入扣除一次总付税后的金额全部用于消费，并把工资设为 FL 家庭的平均工资。两类家庭面对相同劳动需求。

家庭在劳动市场中是垄断竞争者。工资设定采用 Calvo 合同；不能重新优化的家庭按滞后工资通胀指数化。来源论文未打印完整的工资重设目标函数和 FOC，标为 `needs_review`。

## 3. First-Order Conditions

来源论文打印的是若干结构方程，而不是完整 FOC 系统。下列方程连续编号论文提取的条件和部分实现中可见的线性条件。实现中可见的条件标为 `implementation_cross_check`。

- **(F1) DT 最终品聚合器**：
$$
V_t =
\left(
\omega_V^{\frac{\rho_V}{1+\rho_V}} V_{Dt}^{\frac{1}{1+\rho_V}}
+(1-\omega_V)^{\frac{\rho_V}{1+\rho_V}}
(\varphi_{Vt}M_{Vt})^{\frac{1}{1+\rho_V}}
\right)^{1+\rho_V}, \quad V\in\{C,I\}.
$$

- **(F2) DT 进口调整因子**：
$$
\varphi_{Vt} =
1-\frac{\varphi_{M_V}\omega_V}{2}
\left(
\frac{M_{Vt}/V_{Dt}}{M^A_{V,t-1}/V^A_{D,t-1}}-1
\right)^2 .
$$

- **(F3) DT 消费品进口需求，线性化实现交叉检查**：
$$
m^C_t = r^C_t + c_t .
$$

- **(F4) DT 投资品进口需求，线性化实现交叉检查**：
$$
m^I_t = r^I_t+i_t .
$$

- **(F5) DT 总进口，实现交叉检查**：
$$
s_M m_t=s_{MC}s_C m^C_t+s_{MI}s_I m^I_t .
$$

- **(F6) AT 最终吸收聚合器**：
$$
A_t =
\left(
\omega_A^{\frac{\rho_A}{1+\rho_A}} A_{Dt}^{\frac{1}{1+\rho_A}}
+(1-\omega_A)^{\frac{\rho_A}{1+\rho_A}}
(\varphi_{At}M_t)^{\frac{1}{1+\rho_A}}
\right)^{1+\rho_A}.
$$

- **(F7) AT 进口调整因子**：
$$
\varphi_{At} =
1-\frac{\varphi_{M_A}\omega_A}{2}
\left(
\frac{M_t/A_{Dt}}{M^A_{t-1}/A^A_{D,t-1}}-1
\right)^2 .
$$

- **(F8) AT 进口需求比率，论文对数线性方程**：
$$
\tilde{x}_t =
-\frac{\varepsilon_A}{1+\varepsilon_A\varphi_{M_A}}\tilde{\psi}_t
+\frac{\varepsilon_A\varphi_{M_A}}{1+\varepsilon_A\varphi_{M_A}}\tilde{x}_{t-1}.
$$

- **(F9) AT 总进口需求，论文对数线性方程**：
$$
\tilde{M}_t =
\tilde{A}_t
-\frac{\frac{\varepsilon_A}{1+\varepsilon_A\varphi_{M_A}}}
{1-\left(\frac{\varepsilon_A\varphi_{M_A}}{1+\varepsilon_A\varphi_{M_A}}\right)L}
\tilde{\psi}_t .
$$

- **(F10) DT 总进口需求，论文对数线性方程**：
$$
\tilde{M}_t =
\tilde{A}^{DT}_t
-\frac{\frac{\varepsilon_A}{1+\varepsilon_A\varphi_{M_A}}}
{1-\left(\frac{\varepsilon_A\varphi_{M_A}}{1+\varepsilon_A\varphi_{M_A}}\right)L}
\tilde{\psi}^{DT}_t .
$$

- **(F11) DT 活动变量**：
$$
\tilde{A}^{DT}_t =
\left(\frac{M_C}{M}\right)\tilde{C}_t
+\left(\frac{M_I}{M}\right)\tilde{I}_t .
$$

- **(F12) AT 活动变量**：
$$
\tilde{A}_t =
\left(\frac{C}{A}\right)\tilde{C}_t
+\left(\frac{I}{A}\right)\tilde{I}_t .
$$

- **(F13) FL 家庭欧拉方程，实现交叉检查**：
$$
\lambda^C_t=\lambda^C_{t+1}+r^s_t-\Delta p^C_{t+1}+\varepsilon^\beta_t .
$$

- **(F14) 习惯调整后的边际效用，实现交叉检查**：
$$
\lambda^C_t =
-\sigma \frac{c^{FL}_t-(\varkappa/g_z)c^{FL}_{t-1}-\xi_C(\varepsilon^C_t+a_t)}
{1-\varkappa/g_z-\xi_C}.
$$

- **(F15) 即期消费家庭消费规则，实现交叉检查**：
$$
c^{HM}_t =
-rp^C_t
+\Omega_y(\zeta^p_t+\ell_t-\tau^L_t-y_t)
+y_t+\Omega_T(tr_t-tax_t).
$$

确切系数 $\Omega_y$ 和 $\Omega_T$ 是 Rep-MMB 实现中的复合校准比率；来源级核验为 `needs_review`。

- **(F16) Tobin's Q / 投资调整条件，实现交叉检查**：
$$
q_t =
rp^I_t+\phi_K\frac{\hat{\delta}}{1+n} (i_t-k_{t-1})
+\phi_I g_z(i_t-i_{t-1})
-\frac{g_z^2(1+n)}{1+\bar r}\phi_I(i_{t+1}-i_t).
$$

- **(F17) 资本估值方程，实现交叉检查**：
$$
q_t =
\frac{1-\delta}{1+\bar r}q_{t+1}
-\frac{r^s_t-\Delta p_{t+1}}{1+\bar r}
+\frac{\bar r+\delta-\bar{\delta}\tau_K}{1+\bar r}r^K_{t+1}
-\frac{\bar r+\delta-\bar{\delta}}{(1+\bar r)(1-\tau_K)}\tau^K_{t+1}
+\tau_K\bar{\delta}\,rp^I_{t+1}
+\frac{\phi_K\hat{\delta}^2}{(1+\bar r)(1+n)}(i_{t+1}-k_t).
$$

- **(F18) 劳动市场楔子和边际替代率，实现交叉检查**：
$$
wmark_t=mrs_t-\zeta^C_t+\frac{1}{1-\tau_L}\tau^L_t,
\qquad
mrs_t=\chi s_L\ell_t-\lambda^C_t .
$$

- **(F19) 本国价格 Phillips 曲线，实现交叉检查**：
$$
\Delta p^Q_t =
\iota_p \Delta p^Q_{t-1}
+\frac{(1+n)g_z}{1+\bar r}\left(\Delta p^Q_{t+1}-\iota_p\Delta p^Q_t\right)
+\kappa_p mc^Q_t .
$$

- **(F20) 当地货币定价下的出口价格 Phillips 曲线，实现交叉检查**：
$$
\Delta p^M_t =
\iota_m \Delta p^M_{t-1}
+\frac{(1+n)g_z}{1+\bar r}\left(\Delta p^M_{t+1}-\iota_m\Delta p^M_t\right)
+\kappa_x(mc^Q_t-rp^X_t).
$$

- **(F21) 工资 Phillips 曲线，实现交叉检查**：
$$
\Delta w_t =
\iota_w \Delta w_{t-1}
+\frac{(1+n)g_z}{1+\bar r}\left(\Delta w_{t+1}-\iota_w\Delta w_t\right)
+\kappa_w wmark_t .
$$

- **(F22) 货币政策规则，论文方程**：
$$
i_t =
\gamma_i i_{t-1}+\bar r+\bar{\pi}_t
+\gamma_{\pi}\left(\pi^{(4)}_t-\bar{\pi}\right)
+\gamma_y\left(y_t-y_{t-4}-g_y\right)
+\varepsilon^i_t .
$$

## 4. Market Clearing & Identities

- **(F23) 本国产品资源约束，论文方程**：
$$
Y_{Dt}=C_{Dt}+I_{Dt}+G_t+\phi_{It}.
$$

- **(F24) GDP 恒等式，实现交叉检查**：
$$
y_t=s_C c_t+s_I i_t+s_G g_t+s_M(m^{\ast}_t-m_t).
$$

- **(F25) 资本积累，实现交叉检查**：
$$
\left(1-\frac{1-\delta}{g_z(1+n)}\right)i_t
=k_t-\frac{1-\delta}{g_z(1+n)}k_{t-1}.
$$

- **(F26) 生产函数和灵活价格产出，实现交叉检查**：
$$
(1-q_K)(\ell_t+a_t)=y_t-q_K k_{t-1},
\qquad
y^{pot}_t=q_K k_{t-1}+(1-q_K)a_t .
$$

- **(F27) Fisher 实际利率恒等式，实现交叉检查**：
$$
r^{1}_t=r^s_t-\Delta p^Q_{t+1}.
$$

- **(F28) 带平稳化溢价的无抛补利率平价，实现交叉检查**：
$$
e_t=e_{t+1}+r^s_{f,t}-r^s_t+risk_t-\phi_b nfa_t .
$$

- **(F29) 净外国资产，实现交叉检查**：
$$
nfa_t=\frac{1+\bar r}{g_z(1+n)}
\left[nfa_{t-1}+0.25\,s_M(rp^X_t+m^{\ast}_t-rp^M_t-m_t)\right].
$$

- **(F30) 实际汇率，实现交叉检查**：
$$
rer^C_t=e_t+p^C_{f,t}-p^C_t,
\qquad
rer^Q_t=e_t+p^Q_{f,t}-p^Q_t .
$$

- **(F31) 政府预算约束，实现交叉检查**：
$$
b^G_t =
\frac{1+\bar r}{g_z(1+n)}b^G_{t-1}
+s_G(g_t-y_t)+tr_t-tax_t
-\tau_L s_L(\zeta^p_t+\ell_t-y_t)
-\tau_K q_K(k_{t-1}+r^K_t-y_t-\bar{\delta}rp^I_t/\bar r_K)
+\text{tax-wedge terms}.
$$

上式是实现中的紧凑线性化预算条件。完整来源级财政核算为 `needs_review`。

## 5. Exogenous Processes

论文和实现包含本国与外国的持久过程：技术、政府支出、通胀目标、消费偏好、资本税、转移、风险溢价、贴现因子、进口需求和劳动税楔子。实现将若干冲击拆分为永久和暂时成分。

- **(F32) 本国技术增长分解，实现交叉检查**：
$$
a_t=a_{t-1}+g^p_{A,t}+g^T_{A,t},
\qquad
g^p_{A,t}=\rho^p_A g^p_{A,t-1}+\varepsilon^p_{A,t},
\qquad
g^T_{A,t}=\rho^T_A g^T_{A,t-1}+\varepsilon^T_{A,t}.
$$

- **(F33) 外国技术增长分解，实现交叉检查**：
$$
a^{\ast}_t=a^{\ast}_{t-1}+g^{p,\ast}_{A,t}+g^{T,\ast}_{A,t},
\qquad
g^{p,\ast}_{A,t}=\rho^p_A g^{p,\ast}_{A,t-1}+\varepsilon^{p,\ast}_{A,t},
\qquad
g^{T,\ast}_{A,t}=\rho^T_A g^{T,\ast}_{A,t-1}+\varepsilon^{T,\ast}_{A,t}.
$$

- **(F34) 政府支出规则，实现交叉检查**：
$$
g_t=\mathbb{1}_{switch} y_t+g^p_t+g^T_t,
\qquad
g^p_t=\rho^p_G g^p_{t-1}+\varepsilon^p_{G,t}/s_G,
\qquad
g^T_t=\rho^T_G g^T_{t-1}+\varepsilon^T_{G,t}/s_G .
$$

- **(F35) 通胀目标过程，实现交叉检查**：
$$
\pi^{tar}_t=\pi^{tar,p}_t+\pi^{tar,T}_t,
\qquad
\pi^{tar,p}_t=\rho^p_\pi\pi^{tar,p}_{t-1}+\varepsilon^p_{\pi,t},
\qquad
\pi^{tar,T}_t=\rho^T_\pi\pi^{tar,T}_{t-1}+\varepsilon^T_{\pi,t}.
$$

- **(F36) 消费偏好冲击，实现交叉检查**：
$$
\nu^C_t=\nu^{C,p}_t+\nu^{C,T}_t,
\qquad
\nu^{C,p}_t=\rho^p_C\nu^{C,p}_{t-1}+\varepsilon^p_{C,t}/\xi_C,
\qquad
\nu^{C,T}_t=\rho^T_C\nu^{C,T}_{t-1}+\varepsilon^T_{C,t}/\xi_C .
$$

- **(F37) 资本税冲击，实现交叉检查**：
$$
\tau^K_t=\tau^{K,p}_t+\tau^{K,T}_t,
\qquad
\tau^{K,T}_t=\rho^T_K\tau^{K,T}_{t-1}-5.5\,\varepsilon^T_{K,t}.
$$

持久资本税过程包含带额外滞后的实现开关；来源级解释为 `needs_review`。

- **(F38) 风险溢价冲击，实现交叉检查**：
$$
risk_t=risk^p_t+risk^T_t,
\qquad
risk^p_t=\rho^p_R risk^p_{t-1}+(1-\rho^p_R)(10/6)14.5\,\varepsilon^p_{R,t},
\qquad
risk^T_t=\rho^T_R risk^T_{t-1}+\varepsilon^T_{R,t}.
$$

- **(F39) 贴现因子和进口需求冲击，实现交叉检查**：
$$
\varepsilon^\beta_t=\rho_\beta\varepsilon^\beta_{t-1}-u^\beta_t,
\qquad
imp_t=\rho_M imp_{t-1}+u^M_t .
$$

- **(F40) 劳动税楔子过程，实现交叉检查**：
$$
\tau^L_t=\rho_L\tau^L_{t-1}+\phi_{d3}b^G_t+\phi_{d4}(b^G_t-b^G_{t-1})
-u^L_t/s_L .
$$

Rep-MMB 实现中存在 (F34)-(F40) 的外国对应方程，用于相应外国冲击。

## 6. Steady-State Solution

论文说明，求解模型前先用确定性技术增长转换实际变量，并用对应增长和稳态通胀趋势转换名义变量。简约形式解通过围绕两国共同技术增长稳态的对数线性化获得。

本一稿档案的稳态结构如下：

1. 设定共同确定性技术增长 $g_z=1.0037$ 和人口增长 $n=0.0025$。
2. 设定校准目标：$s_I=0.25$、$s_G=0.18$、总进口份额 $s_M=0.12$、$\omega_C=0.052$、$\omega_I=0.36$、外国 $\omega^{\ast}_C=0.01$、外国 $\omega^{\ast}_I=0.07$、$\delta=0.025$、$\beta=0.997$、$\tau_K=0.30$。
3. 按实现计算稳态实际利率：
$$
\bar r=\frac{g_z^\sigma}{\beta}-1.
$$
4. 计算资本稳态租金回报：
$$
\bar r_K=\frac{\bar r+\delta-\tau_K\bar{\delta}}{1-\tau_K}.
$$
5. 计算进口份额和最终用途份额：
$$
s_C=1-s_I-s_G,\qquad
s_M=s_{MC}s_C+s_{MI}s_I.
$$
6. 在线性化实现中，所有转换后的变量都表示为对稳态的偏离，因此 `model(linear)` 中模型变量的稳态值为零。

完整非线性稳态核算，包括所有税收、债务、工资、货币和外国资产水平，为 `needs_review`，因为论文未打印完整 SIGMA 稳态系统。

## 7. Timing & Form Conventions

- **形式**：Rep-MMB 实现中为 `model(linear)`。方程是在去趋势后围绕平衡增长稳态的对数偏离或线性化比率。
- **资本时序**：实现方程在生产和资本回报方程中使用 $k_{t-1}$；$k_t$ 是由当期投资选择的期末存量。
- **增长调整**：资本积累和贴现项包含 $g_z(1+n)$，对应确定性技术和人口增长。
- **价格和工资通胀**：本国价格通胀、消费价格通胀、进出口价格通胀和工资通胀是带滞后指数化的不同线性变量。
- **外国资产**：UIP 条件包含中介/平稳化溢价，因此净外国资产是平稳的。
- **当地货币定价**：出口价格 Phillips 曲线使用相对出口价格，符合论文中的当地货币定价。
- **运行时验证**：未执行。此档案条目未运行 Dynare、残差检查或 BK 检查。

## 8. Variable & Parameter Reference Table

### 内生变量

| 类别 | 符号 | 含义 | 主要对应 |
|---|---|---|---|
| 内生 | $c_t,c^{FL}_t,c^{HM}_t$ | 总消费、前瞻型消费、即期消费 | (F13)-(F15), (F24) |
| 内生 | $i_t,q_t,k_t,k_{t-1}$ | 投资、Tobin's Q、资本存量 | (F16), (F17), (F25), (F26) |
| 内生 | $\ell_t,wmark_t,mrs_t$ | 劳动、工资加成、边际替代率 | (F18), (F21), (F26) |
| 内生 | $y_t,y^{pot}_t,gap_t$ | 产出、潜在产出、产出缺口 | (F24), (F26) |
| 内生 | $m^C_t,m^I_t,m_t$ | 消费品进口、投资品进口和总进口 | (F3)-(F5), (F8)-(F12) |
| 内生 | $m^{\ast}_t$ | 外国进口 / 本国出口 | (F3)-(F12) 的外国对应式，(F24) |
| 内生 | $\Delta p^Q_t,\Delta p^C_t,\Delta p^M_t,\Delta w_t$ | 本国、消费、进出口和工资通胀 | (F19)-(F21), (F27) |
| 内生 | $r^s_t,r^1_t,i_t$ | 政策利率和短期实际利率 | (F22), (F27) |
| 内生 | $e_t,rer^C_t,rer^Q_t,nfa_t$ | 名义汇率、实际汇率、净外国资产 | (F28)-(F30) |
| 内生 | $b^G_t,tax_t,tr_t$ | 政府债务、税收、转移 | (F31), (F34), (F40) |
| 内生 | $a_t,g^p_{A,t},g^T_{A,t}$ | 技术水平和增长冲击 | (F32) |
| 内生 | 外国星号对应变量 | 外国经济变量 | (F33) 和外国对应式 |

### 外生冲击

| 符号 / 实现名称 | 含义 |
|---|---|
| `erratp`, `erratt`, `erratpf`, `errattf` | 本国和外国永久/暂时技术创新 |
| `errgcxp`, `fiscal_`, `errgcxpf`, `errgcxtf` | 本国和外国政府支出创新 |
| `errpitarp`, `errpitart`, `errpitarpf`, `errpitartf` | 本国和外国通胀目标创新 |
| `errconshkp`, `errconshkt`, `errconshkpf`, `errconshktf` | 消费偏好创新 |
| `errtaxkp`, `errtaxkt`, `errtaxkpf`, `errtaxktf` | 资本税创新，包括投资需求实验 |
| `errtranshkp`, `errtranshkt`, `errtranshkpf`, `errtranshktf` | 转移创新 |
| `errriskpp`, `errriskpt` | 风险溢价创新 |
| `errbetashk`, `errbetashkf` | 贴现因子创新 |
| `errimpshk`, `errimpshkf` | 进口需求创新 |
| `errtaxlshk`, `errtaxlshkpf`, `errtaxlshktf` | 劳动税楔子创新 |
| `interest_`, `fiscal_` | MMB 面向的货币和财政冲击别名 |

### 参数

| 参数 | 含义 / 校准线索 |
|---|---|
| $\beta=0.997$ | 贴现因子 |
| $\sigma=2$ | 跨期替代弹性倒数 |
| $\varkappa=0.8$ | 外部习惯持续性 |
| $\varsigma=0.5$ | 论文记号中的 FL 家庭份额；实现中 `popkey` 表示 HM 份额 |
| $\chi=10$ | 劳动供给曲率 |
| $\phi_I=3$ | 投资调整成本 |
| $\phi_b=0.001$ | 外债中介成本 |
| $g_z=1.0037$, $n=0.0025$ | 技术和人口增长 |
| $\delta=0.025$ | 折旧 |
| $\theta_p=0.20$, $\theta_w=0.20$ | 论文表中的价格和工资加成参数 |
| $\xi_p=0.75$, $\xi_w=0.75$, $\xi_{p,x}=0.5$ | Calvo 本国价格、工资和出口价格黏性 |
| $\tau_K=0.30$, $\tau_L=0.20$ | 资本和劳动税率 |
| $\gamma_\pi=0.6$, $\gamma_y=0.28$, $\gamma_i=0.8$ | 货币规则系数 |
| $s_I=0.25$, $s_G=0.18$, $s_M=0.12$ | 投资、政府和进口份额 |
| $\omega_A=0.15$, $\rho_A=2$, $\varphi_{M_A}=10$ | AT 贸易参数 |
| $\omega_C=0.052$, $\omega_I=0.36$, $\rho_C=\rho_I=2$, $\varphi_{M_C}=\varphi_{M_I}=10$ | DT 贸易参数 |
| $\omega_C^{\ast}=0.01$, $\omega_I^{\ast}=0.07$ | 外国 DT 进口份额校准 |
