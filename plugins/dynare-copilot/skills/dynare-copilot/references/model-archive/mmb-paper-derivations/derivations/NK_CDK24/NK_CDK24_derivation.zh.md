# NK_CDK24 - 能源价格与家庭异质性：Gas-TANK 中的货币政策

> `NK_CDK24` 的模型档案推导。来源：Chan, Diz, and Kanngiesser (2024), "Energy prices and household heterogeneity: Monetary policy in a Gas-TANK", Journal of Monetary Economics, DOI `10.1016/j.jmoneco.2024.103620`。主要抽取来源：`raw/mmb_mineru/runs/nk_cdk24__energy_prices_and_household_heterogeneity_monetary_policy_in_a_gas_tank__9fe20b52/full.md`。
>
> 状态：`needs_review`。MinerU OCR 在若干家庭份额和乘子段落中保留了占位符；下列方程保留论文侧结构，并明确标出不确定项。

## 1. Model Overview / 模型概述

- **模型**：小型开放经济两类主体新凯恩斯模型，生产中使用进口能源，论文称为 Gas-TANK。
- **实验**：Taylor 规则下的能源价格冲击、TFP 冲击和加成冲击；论文也研究 Ramsey 政策，但本推导记录私人部门均衡和基准 Taylor 规则。
- **主体与部门**：非受限家庭、受限手停口停家庭、最终品打包商、垄断竞争最终品生产商、具有工资黏性的工会、能源进口商、出口/零售部门和货币当局。
- **模型形式**：围绕稳态的对数线性摘要，同时保留家庭预算、生产、定价、进口、出口和政策的非线性来源方程。除非未来从来源层面重建完整非线性 Ramsey 系统，否则实现时应按线性/对数偏离形式处理。
- **核心机制**：进口能源和劳动不是完全替代。若能源与劳动互补，进口能源价格上升会降低劳动份额，并扩大非受限与受限家庭之间的消费差距，从而直接压低需求。

## 2. Optimization Problems / 主体的最优化问题

### 2.1 非受限家庭

比例为 $1-\omega$ 的家庭可以交易国内和外国债券，并获得劳动收入、企业分红和工会分红。其选择消费、劳动和债券持有：

$$
\max_{\{C_{u,t},N^h_{u,t},B_{u,t},B^*_{u,t}\}}
E_0\sum_{t=0}^{\infty}\beta^t
\left[
\frac{C_{u,t}^{1-\sigma}-1}{1-\sigma}
-\chi\frac{(N^h_{u,t})^{1+\varphi}}{1+\varphi}
\right]
$$

约束为名义预算约束：

$$
W_t^h N^h_{u,t}+R_{t-1}B_{u,t-1}+\mathcal{E}_t\bar R^*B^*_{u,t-1}
+DIV^F_{u,t}+DIV^L_{u,t}
=P_tC_{u,t}+B_{u,t}+\mathcal{E}_tB^*_{u,t}+T_{u,t}+P_t\mathcal{T}_u.
\tag{F1}
$$

### 2.2 受限家庭

比例为 $\omega$ 的家庭为手停口停家庭。它们获得劳动收入和工会分红，但不交易债券：

$$
P_tC_{c,t}=W_t^hN^h_{c,t}+DIV^L_{c,t}-T_{c,t}+P_t\mathcal{T}_c.
\tag{F2}
$$

论文假定两类家庭获得相同的劳动配置：

$$
N^h_{u,t}=N^h_{c,t}.
\tag{F3}
$$

### 2.3 最终品打包商

竞争性打包商将差异化品种聚合为最终品：

$$
Z_t=\left(\int_0^1 Z_t(i)^{\frac{\epsilon_z-1}{\epsilon_z}}\,di\right)^{\frac{\epsilon_z}{\epsilon_z-1}},
\qquad
P_t=\left(\int_0^1 P_t(i)^{1-\epsilon_z}\,di\right)^{\frac{1}{1-\epsilon_z}}.
\tag{F4}
$$

成本最小化给出品种需求：

$$
Z_t(i)=\left(\frac{P_t(i)}{P_t}\right)^{-\epsilon_z}Z_t.
\tag{F5}
$$

### 2.4 最终品生产商

每个垄断竞争生产商使用劳动和进口能源：

$$
Z_t(i)=\varepsilon_t^{TFP}
\left[
(1-\alpha_{ez})^{\frac{1}{\psi_{ez}}}N_t(i)^{\frac{\psi_{ez}-1}{\psi_{ez}}}
+\alpha_{ez}^{\frac{1}{\psi_{ez}}}E_t^z(i)^{\frac{\psi_{ez}-1}{\psi_{ez}}}
\right]^{\frac{\psi_{ez}}{\psi_{ez}-1}}.
\tag{F6}
$$

生产商在给定工资 $W_t$、国内能源价格 $P_t^E$ 和边际成本 $MC_t^Z$ 时最小化投入成本。OCR 将生产楔子标为 $\tau_t^Z=\tau^Z\varepsilon_t^{\mathcal M_z}$；本条目保留该记号但标为 `needs_review`。

### 2.5 Calvo 定价者

以概率 $1-\phi_z$，最终品生产商可重设价格 $P_t^\#$。其问题为：

$$
\max_{P_t^\#} E_t\sum_{s=0}^{\infty}\phi_z^s
\left\{\Lambda_{u,t,t+s}\left(P_t^\#Z_{t+s|t}-MC_{t+s}^ZZ_{t+s|t}\right)\right\}
\quad\text{s.t.}\quad
Z_{t+s|t}=\left(\frac{P_t^\#}{P_{t+s}}\right)^{-\epsilon_z}Z_{t+s}.
\tag{F7}
$$

### 2.6 能源进口商、出口需求与零售商

能源进口商以 $P_t^{E,*}$ 购买外国能源品，并在国内销售。国内非能源品的出口需求取决于其外币价格。零售商把最终品转化为国内消费品和出口品；抽取到的模型摘要中没有额外优化楔子。

## 3. First-Order Conditions / 一阶条件

**(F8) 非受限家庭 Euler 方程**：

$$
1=E_t\left[\Lambda_{u,t,t+1}\frac{R_t}{\Pi_{t+1}}\right],
\qquad
\Lambda_{u,t,t+1}=\beta\left(\frac{C_{u,t}}{C_{u,t+1}}\right)^\sigma.
\tag{F8}
$$

**(F9) 总消费的对数线性 Euler 方程**：

$$
\hat c_t=E_t[\hat c_{t+1}]+E_t[\omega\Delta\hat\gamma_{t+1}]
-\frac{1}{\sigma}\left(\hat r_t-E_t[\hat\pi_{t+1}]\right).
\tag{F9}
$$

**(F10) 消费差距与总消费**：

$$
\hat\gamma_t\equiv\hat c_{u,t}-\hat c_{c,t},
\qquad
\hat c_t=\omega\hat c_{c,t}+(1-\omega)\hat c_{u,t}.
\tag{F10}
$$

**(F11) 成本最小化得到的劳动和能源要素需求**：

$$
W_t=(1-\alpha_{ez})^{\frac{1}{\psi_{ez}}}
\frac{MC_t^Z}{\tau_t^Z}
\left(\frac{Z_t(i)}{N_t(i)}\right)^{\frac{1}{\psi_{ez}}}
\left(\varepsilon_t^{TFP}\right)^{\frac{\psi_{ez}-1}{\psi_{ez}}},
\quad
P_t^E=\alpha_{ez}^{\frac{1}{\psi_{ez}}}
\frac{MC_t^Z}{\tau_t^Z}
\left(\frac{Z_t(i)}{E_t^z(i)}\right)^{\frac{1}{\psi_{ez}}}
\left(\varepsilon_t^{TFP}\right)^{\frac{\psi_{ez}-1}{\psi_{ez}}}.
\tag{F11}
$$

`needs_review`：论文/OCR 在 $\tau_t^Z$ 和边际成本乘子附近的记号较噪，但要素需求结构是清楚的。

**(F12) Calvo 最优价格条件**：

$$
E_t\sum_{s=0}^{\infty}\phi_z^s
\left\{
\Lambda_{u,t,t+s}Z_{t+s|t}
\left(P_t^\#-\mathcal{M}_zMC_{t+s|t}^Z\right)
\right\}=0,
\qquad
\mathcal{M}_z=\frac{\epsilon_z}{\epsilon_z-1}.
\tag{F12}
$$

**(F13) 黏性工资 Phillips 曲线**：

$$
\hat\pi_t^W=
\frac{(1-\phi_w\beta)(1-\phi_w)}{\phi_w}
\left(\hat w_t^h-\hat w_t\right)
+\beta E_t[\hat\pi_{t+1}^W],
\qquad
\hat\pi_t^W=\hat w_t-\hat w_{t-1}+\hat\pi_t.
\tag{F13}
$$

**(F14) 黏性价格 Phillips 曲线**：

$$
\hat\pi_t=
\frac{(1-\phi_z\beta)(1-\phi_z)}{\phi_z}\hat{mc}_t^Z
+\beta E_t[\hat\pi_{t+1}].
\tag{F14}
$$

**(F15) 对数线性边际成本，劳动需求侧**：

$$
\hat{mc}_t^Z=\hat w_t+\hat\varepsilon_t^{\mathcal M_z}
-\psi_{ez}^{-1}\left(\alpha_{ez}\hat e_t^z-\alpha_{ez}\hat n_t\right)
-\hat\varepsilon_t^{TFP}.
\tag{F15}
$$

**(F16) 对数线性边际成本，能源需求侧**：

$$
\hat{mc}_t^Z=\hat p_t^E+\hat\varepsilon_t^{\mathcal M_z}
-\psi_{ez}^{-1}\left((1-\alpha_{ez})\hat n_t-(1-\alpha_{ez})\hat e_t^z\right)
-\hat\varepsilon_t^{TFP}.
\tag{F16}
$$

## 4. Market Clearing & Identities / 市场出清与恒等式

**(F17) 水平形式的总消费与消费差距**：

$$
C_t=(1-\omega)C_{u,t}+\omega C_{c,t},
\qquad
\Gamma_t\equiv\frac{C_{u,t}}{C_{c,t}}.
\tag{F17}
$$

**(F18) 进口能源一价定律**：

$$
p_t^E=Q_tp_t^{E,*}.
\tag{F18}
$$

**(F19) 出口需求**：

$$
X_t=\kappa^*
\left(\frac{P_t^{EXP}}{P_{ss}^{X*}}\right)^{-\zeta^*}
Y_{ss}^*.
\tag{F19}
$$

**(F20) 对数线性商品市场出清与生产恒等式**：

$$
\hat c_t=\frac{Z_{ss}}{C_{ss}}\hat z_t-\frac{X_{ss}}{C_{ss}}\hat x_t,
\qquad
\hat z_t=\hat\varepsilon_t^{TFP}+(1-\alpha_{ez})\hat n_t+\alpha_{ez}\hat e_t^z.
\tag{F20}
$$

**(F21) 出口、国内能源价格和 UIP 恒等式**：

$$
\hat x_t=\zeta^*\hat q_t,\qquad
\hat p_t^E=\hat p_t^{E,*}+\hat q_t,\qquad
\hat q_t=E_t[\hat q_{t+1}]-\left(\hat r_t-E_t[\hat\pi_{t+1}]\right).
\tag{F21}
$$

**(F22) Taylor 规则**：

$$
\hat r_t=\theta_R\hat r_{t-1}
+(1-\theta_R)\left[
\frac{\theta_\pi}{4}\hat\pi_t^{CPI,a}
+\theta_Y(\hat n_t-\hat n_t^{flex})
\right],
\qquad
\hat\pi_t^{CPI,a}\equiv\sum_{j=0}^{3}\hat\pi_{t-j}^{CPI},
\qquad
\hat\pi_t^{CPI}=\hat\pi_t.
\tag{F22}
$$

**(F23) 动态 IS 渠道分解**：

$$
\hat n_t=
-\frac{1}{\sigma}\frac{C_{ss}}{Z_{ss}}E_t\sum_{k=0}^{\infty}
\left(\hat r_{t+k}-\hat\pi_{t+k+1}\right)
-\omega\frac{C_{ss}}{Z_{ss}}\hat\gamma_t
+\psi_{ez}\alpha_{ez}(\hat p_t^E-\hat w_t)
+\frac{X_{ss}}{Z_{ss}}\zeta^*\hat q_t
-\hat\varepsilon_t^{TFP}.
\tag{F23}
$$

**(F24) 消费差距分解**：

$$
\Gamma_t=\Gamma_t^{inc}
+\frac{\mathcal E_t(\bar R^*-1)B^*_{u,t-1}-\mathcal E_t\Delta B^*_{u,t}}
{INC_{c,t}}.
\tag{F24}
$$

**(F25) 使用贸易余额表示的消费差距**：

$$
\Gamma_t=\Gamma_t^{inc}
-\frac{1}{1-\omega}\frac{TB_t}{INC_{c,t}},
\qquad
TB_t=P_t^XX_t-P_t^EE_t^z.
\tag{F25}
$$

**(F26) 消费差距的收入差距项和借款项**：

$$
\Gamma_t=
1+\frac{1}{1-\omega}\frac{\mathcal M_t^Z-1}{\Xi_t^N}
+\frac{1}{1-\omega}
\left(
\frac{1}{\Xi_t^N}-1-\frac{P_t^XX_t}{INC_{c,t}}
\right),
\qquad
\frac{\partial\Gamma_t}{\partial\mathcal M_t^Z}>0,\quad
\frac{\partial\Gamma_t}{\partial\Xi_t^N}<0.
\tag{F26}
$$

**(F27) 加成与劳动份额恒等式**：

$$
\mathcal M_t^Z=
\frac{\varepsilon_t^{TFP}P_t}
{\left((1-\alpha_{ez})W_t^{1-\psi_{ez}}
+\alpha_{ez}(P_t^E)^{1-\psi_{ez}}\right)^{\frac{1}{1-\psi_{ez}}}},
\qquad
\Xi_t^N=
\left[
1+\frac{\alpha_{ez}}{1-\alpha_{ez}}
\left(\frac{P_t^E}{W_t}\right)^{1-\psi_{ez}}
\right]^{-1}.
\tag{F27}
$$

## 5. Exogenous Processes / 外生过程

**(F28) TFP 冲击**：

$$
\log\varepsilon_t^{TFP}
=\rho_{TFP}\log\varepsilon_{t-1}^{TFP}
-\varsigma_{TFP}\eta_t^{TFP},
\qquad
\eta_t^{TFP}\sim N(0,1).
\tag{F28}
$$

**(F29) 价格加成冲击**：

$$
\log\varepsilon_t^{\mathcal M_z}
=\rho_{\mathcal M_z}\log\varepsilon_{t-1}^{\mathcal M_z}
-\varsigma_{\mathcal M_z}\eta_t^{\mathcal M_z},
\qquad
\eta_t^{\mathcal M_z}\sim N(0,1).
\tag{F29}
$$

**(F30) 能源价格冲击**：

$$
\log\varepsilon_t^E=\varsigma_E\eta_t^E,
\qquad
\eta_t^E\sim N(0,1).
\tag{F30}
$$

**(F31) 外国能源价格水平**：

$$
p_t^{E,*}=(p_{ss}^{E,*})^{1-\rho_E}(p_{t-1}^{E,*})^{\rho_E}\varepsilon_t^E.
\tag{F31}
$$

## 6. Steady-State Solution / 稳态求解

本档案条目没有运行 Dynare 稳态验证。对于对数线性模块，所有带帽变量都是相对稳态的偏离：

$$
\hat x_t=\log(X_t/X_{ss}) \quad \text{for positive level variables,}
\qquad
\hat r_t,\hat\pi_t,\hat q_t,\hat\gamma_t
\text{ are steady-state deviations as defined in the paper.}
\tag{F32}
$$

论文报告的基准校准目标包括：

$$
\beta=0.9994,\quad
\epsilon_z=\epsilon_w=11,\quad
\phi_z=0.66,\quad
\phi_w=0.92,\quad
\theta_\pi=1.5,\quad
\theta_Y=0.125,\quad
\theta_R=0.9,
\tag{F33}
$$

$$
\rho_{TFP}=0.93,\quad
\varsigma_{TFP}=0.07,\quad
\rho_E=0.8,\quad
\varsigma_E=1,\quad
\rho_{\mathcal M_z}\approx0.9,\quad
\varsigma_{\mathcal M_z}=0.1,
\tag{F34}
$$

$$
\omega=0.25,\quad
\psi_{ez}=0.15,\quad
\alpha_{ez}=0.05,\quad
\zeta^*=0.35.
\tag{F35}
$$

`needs_review`：来源 Markdown 说明附录包含完整关键参数表，但抽取出的 Markdown 中没有该附录表。若需要，未来应恢复补充资料或有针对性地检查 PDF 附录。

## 7. Timing & Form Conventions / 时序与形式约定

- **线性化**：可操作的摘要方程是带帽变量的对数线性形式。非线性家庭、生产、进口、出口和 Calvo 方程记录线性模块背后的来源均衡。
- **利率与通胀**：Euler 方程使用 $R_t/\Pi_{t+1}$，对数线性 Euler 方程使用预期实际利率 $\hat r_t-E_t[\hat\pi_{t+1}]$。
- **开放经济时序**：实际汇率通过 UIP 前瞻决定，$\hat q_t=E_t[\hat q_{t+1}]-(\hat r_t-E_t[\hat\pi_{t+1}])$。
- **家庭**：受限家庭消费当期可支配劳动收入；非受限家庭可通过国内和外国债券平滑消费。
- **基准抽取模块中无资本存量**：生产只使用劳动和进口能源。论文侧基准模型块中没有物质资本积累方程。
- **运行验证**：未执行。`.agents/skills/dynare-copilot/references/examples/NK_CDK24_rep.mod` 下没有 `.mod` 交叉检查文件。

## 8. Variable & Parameter Reference Table / 变量与参数对照表

| 类别 | 符号 / ASCII 名称 | 含义 | 主要方程 |
|---|---|---|---|
| 内生 | $C_{u,t}$ / `c_u` | 非受限家庭消费 | (F1), (F8), (F10), (F17) |
| 内生 | $C_{c,t}$ / `c_c` | 受限家庭消费 | (F2), (F10), (F17) |
| 内生 | $C_t$ / `c` | 总消费 | (F9), (F10), (F17), (F20) |
| 内生 | $\Gamma_t,\hat\gamma_t$ / `gamma_gap` | 消费差距 | (F10), (F17), (F24)-(F26) |
| 内生 | $N_t,N^h_{j,t}$ / `n` | 劳动/就业 | (F3), (F6), (F11), (F20), (F22), (F23) |
| 内生 | $W_t,W_t^h$ / `w`, `w_h` | 生产者工资和家庭工资 | (F1)-(F3), (F11), (F13), (F15), (F27) |
| 内生 | $Z_t$ / `z` | 最终产出 | (F4)-(F6), (F20), (F23) |
| 内生 | $E_t^z$ / `e_z` | 进口能源投入 | (F6), (F11), (F16), (F20), (F25) |
| 内生 | $MC_t^Z,\hat{mc}_t^Z$ / `mc_z` | 边际成本 | (F7), (F11), (F12), (F14)-(F16) |
| 内生 | $\mathcal M_t^Z$ / `markup_z` | 最终品平均加成 | (F26), (F27) |
| 内生 | $\Xi_t^N$ / `labor_share` | 企业支出中的劳动份额 | (F26), (F27) |
| 内生 | $P_t^E,p_t^E$ / `p_e` | 国内能源价格 | (F11), (F18), (F21), (F27) |
| 内生 | $Q_t,\hat q_t$ / `q` | 实际汇率 | (F18), (F21), (F23) |
| 内生 | $X_t,\hat x_t$ / `x` | 出口 | (F19), (F20), (F21), (F25) |
| 内生 | $TB_t$ / `tb` | 贸易余额 | (F25) |
| 内生 | $R_t,\hat r_t$ / `r` | 论文记号中的名义政策利率/对数偏离 | (F8), (F9), (F21), (F22), (F23) |
| 内生 | $\Pi_t,\hat\pi_t$ / `pi` | 通胀 | (F8), (F13), (F14), (F21), (F22), (F23) |
| 外生 | $\eta_t^{TFP}$ / `eta_tfp` | TFP 创新 | (F28) |
| 外生 | $\eta_t^{\mathcal M_z}$ / `eta_markup` | 加成创新 | (F29) |
| 外生 | $\eta_t^E$ / `eta_e` | 能源价格创新 | (F30), (F31) |
| 参数 | $\beta$ / `beta` | 贴现因子 | (F8), (F13), (F14), (F33) |
| 参数 | $\sigma$ / `sigma` | 跨期替代/风险厌恶参数 | (F8), (F9), (F23) |
| 参数 | $\chi$ / `chi` | 劳动负效用尺度 | §2.1 |
| 参数 | $\varphi$ / `varphi` | Frisch 弹性倒数 | §2.1 |
| 参数 | $\omega$ / `omega` | 受限家庭占比 | (F9), (F10), (F17), (F23), (F26), (F35) |
| 参数 | $\alpha_{ez}$ / `alpha_ez` | 生产中的能源份额 | (F6), (F11), (F15), (F16), (F20), (F27), (F35) |
| 参数 | $\psi_{ez}$ / `psi_ez` | 能源-劳动替代弹性 | (F6), (F11), (F15), (F16), (F23), (F27), (F35) |
| 参数 | $\epsilon_z$ / `epsilon_z` | 最终品品种间替代弹性 | (F4), (F5), (F12), (F33) |
| 参数 | $\phi_z$ / `phi_z` | Calvo 价格不重设概率 | (F7), (F12), (F14), (F33) |
| 参数 | $\phi_w$ / `phi_w` | Calvo 工资不重设概率 | (F13), (F33) |
| 参数 | $\theta_R,\theta_\pi,\theta_Y$ | Taylor 规则系数 | (F22), (F33) |
| 参数 | $\zeta^*$ / `zeta_star` | 出口需求弹性 | (F19), (F21), (F23), (F35) |
| 参数 | $\rho_{TFP},\rho_{\mathcal M_z},\rho_E$ | 冲击持续性参数 | (F28), (F29), (F31), (F34) |
| 参数 | $\varsigma_{TFP},\varsigma_{\mathcal M_z},\varsigma_E$ | 冲击标准差 | (F28)-(F30), (F34) |
