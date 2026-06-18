# EA_PV17 - 推导档案条目

> 第一遍状态：`needs_review`。来源是 Priftis and Vogel (2017) 的 MinerU Markdown 附录；未打开原始 PDF 正文。实现 `.mod` 仅作为 `implementation_cross_check` 用于覆盖范围和命名核对。

## 1. 模型概述

- **模型 ID**：`EA_PV17`
- **论文**：Romanos Priftis and Lukas Vogel (2017), "The macroeconomic effects of the ECB's evolving QE programme: a model-based analysis", *Open Economies Review*, 28(5), 823-845。
- **DOI**：`10.1007/s11079-017-9460-1`
- **经济体和实验**：两地区 EA 与 rest-of-world QUEST III DSGE 模型，用 ECB 购买长期政府债券来研究 2015 年 1 月 QE 计划及后续扩展。
- **主体和模块**：垄断竞争企业、Ricardian 家庭、流动性受限家庭、工资设定工会、财政当局、中央银行、短期和长期债券市场、贸易/经常账户模块，以及对称的 RoW 模块。
- **模型形式**：非线性水平模型，含调整成本、习惯形成、名义和真实刚性，并且 Rep-MMB 实现中可选动态差分变量。未执行运行时验证。
- **QE 机制**：长期债券与短期国内债券、外国长期债券不完全替代。中央银行购买降低私人部门持有的长期债券，影响期限溢价、资产价格、汇率以及储蓄/投资决策。

## 2. 主体的最优化问题

### 企业

企业选择商品价格、劳动、资本服务和产能利用率，在 Cobb-Douglas 生产技术和凸调整成本约束下最大化真实利润：

\[
\max_{\{P_t,N_t,K_t,ucap_t\}} Pr_t
= p_tY_t-w_tN_t-i_t^k p_t^I K_t
-\left(adj^P(P_t)+adj^N(N_t)+adj^{ucap}(ucap_t)\right).
\]

\[
Y_t=(ucap_tK_t)^{1-\alpha}(N_t-LO_t)^\alpha KG_t^{\alpha_g}.
\]

调整成本函数为：

\[
adj^N(N_t)=\frac{\gamma_N}{2}w_t(\Delta N_t)^2,\quad
adj^P(P_t)=\frac{\gamma_P}{2}\left(\frac{P_t-P_{t-1}}{P_{t-1}}\right)^2Y_t,
\]

\[
adj^{ucap}(ucap_t)=p_t^IK_t\left[\gamma_{ucap,1}(ucap_t-1)+\frac{\gamma_{ucap,2}}{2}(ucap_t-1)^2\right].
\]

### Ricardian 家庭

Ricardian 家庭在消费和闲暇上最大化含习惯形成的贴现期望效用：

\[
\max L^r=E_0\sum_{t=0}^{\infty}\beta^t U(C_t^r,N_t^r),
\qquad
U(C_t^h,N_t^h)=\log(C_t^h-hC_{t-1})+\omega(1-N_t^h)^{1-\kappa}.
\]

预算约束包括消费税、实物资本投资、短期债券、国内长期债券、外国短期债券、外国长期债券、组合调整成本、转移支付、息票、递减的长期债券价值、劳动收入、扣除风险溢价的资本收入、税收和股利。Markdown OCR 的多行拉格朗日式可用但仍需源级核查，因此该预算模块标记为 `needs_review`。

实物投资含调整成本：

\[
I_t=J_t\left(1+\frac{\gamma_KJ_t}{2K_t}\right)+\frac{\gamma_I}{2}(\Delta J_t)^2.
\]

### 流动性受限家庭和工会

流动性受限家庭不进行跨期优化；其消费等于当期可支配收入。工会通过使加权闲暇边际效用等于加权消费边际效用乘以税后真实消费工资和工资加成来设定工资。

### 政策当局

财政政策遵循稳定债务的劳动税规则。货币政策在正常时期遵循 Taylor 规则。QE 模拟中，中央银行长期债券持有量服从外生购买路径，而不是内生反馈规则。

## 3. 一阶条件

**(F1) Firm production technology**

\[
Y_t=(ucap_tK_t)^{1-\alpha}(N_t-LO_t)^\alpha KG_t^{\alpha_g}.
\]

**(F2) Labour CES aggregator**

\[
N_t=\left(\int_0^1 (N_t^h)^{\frac{\theta-1}{\theta}}dh\right)^{\frac{\theta}{\theta-1}}.
\]

**(F3) Firm labour demand with employment adjustment costs**

\[
\frac{\partial Y_t}{\partial N_t}\eta_t-\gamma_Nw_t\Delta N_t
+\gamma_NE_t\!\left(\beta\lambda_{t,t+1}^rw_{t+1}\Delta N_{t+1}\right)=w_t.
\]

**(F4) Firm capital rental condition**

\[
\frac{\partial Y_t}{\partial K_t}\eta_t=i_t^k p_t^I.
\]

**(F5) Capacity-utilisation condition**

\[
\frac{\partial Y_t}{\partial ucap_t}\eta_t
=p_t^IK_t\left[\gamma_{ucap,1}+\gamma_{ucap,2}(ucap_t-1)\right].
\]

**(F6) Price-markup condition with partial backward indexation**

\[
\eta_t=1-\frac{1}{\sigma}
-\gamma_pE_t\!\left(\beta\lambda_{t,t+1}^r\left(sfp\,\pi_{t+1}+(1-sfp)\pi_{t-1}\right)-\pi_t\right).
\]

**(F7) Short-term domestic bond Euler condition**

\[
\beta E_t\left(\frac{\lambda_{t+1}}{\lambda_t}\right)
=E_t\left(\frac{P_{t+1}}{P_t}\right)
\left[\frac{1}{1+i_t}+\gamma_b\kappa P_t^N\left(\kappa\frac{B_t^S}{B_t^{L,H}}-1\right)\right].
\]

**(F8) Domestic long-term bond Euler condition (`needs_review`: OCR tag and superscripts malformed in source)**

\[
\beta E_t\left(\frac{\lambda_{t+1}P_t}{\lambda_tP_{t+1}}\right)
=E_t\left(\frac{P_t^N}{\delta_bP_{t+1}^N+c}\right)
\left[
1+\frac{\gamma_b}{2}\left(\kappa\frac{B_t^S}{B_t^{L,H}}-1\right)^2
-\gamma_b\kappa\left(\kappa\frac{B_t^S}{B_t^{L,H}}-1\right)\frac{B_t^S}{B_t^{L,H}}
+\gamma_b^{\ast}\kappa^{\ast}\left(\kappa^{\ast}\frac{B_t^{L,H}}{B_t^{L,H\ast}}-1\right)\frac{e_tP_t^{N\ast}}{P_t^N}
\right].
\]

**(F9) Foreign long-term bond Euler condition (`needs_review`)**

\[
\beta E_t\left(\frac{\lambda_{t+1}P_te_{t+1}}{\lambda_tP_{t+1}e_t}\right)
=E_t\left(\frac{P_t^{N\ast}}{\delta_b^{\ast}P_{t+1}^{N\ast}+c^{\ast}}\right)
\left[
1+\frac{\gamma_b^{\ast}}{2}\left(\kappa^{\ast}\frac{B_t^{L,H}}{B_t^{L,H\ast}}-1\right)^2
-\gamma_b^{\ast}\kappa^{\ast}\left(\kappa^{\ast}\frac{B_t^{L,H}}{B_t^{L,H\ast}}-1\right)\frac{B_t^{L,H}}{B_t^{L,H\ast}}
\right].
\]

**(F10) Foreign short-term bond/UIP condition**

\[
\beta E_t\left(\frac{\lambda_{t+1}}{\lambda_t}\right)
=E_t\left(\frac{e_tP_{t+1}}{e_{t+1}P_t}\right)
\left[\frac{1}{1+i_t^{\ast}}+\gamma_f\frac{e_t(B_t^{\ast}-\bar{B}^{\ast})}{P_t}\right].
\]

**(F11) Capital Euler condition**

\[
\beta E_t\left(\frac{\lambda_{t+1}}{\lambda_t}\right)
=E_t\left(\frac{P_{t+1}}{P_t}\frac{P_t^C}{P_{t+1}^C}\right)
\frac{1}{(1+i_t^k-\varphi_t-\delta_k)-t_t^k(i_t^k-\delta_k)}.
\]

**(F12) Consumption marginal utility condition**

\[
U_t^C=\frac{(1+t_t^c)P_t^C}{P_t}\lambda_t.
\]

**(F13) Labour supply condition**

\[
U_t^N=\frac{(1-t_t^w)W_t}{P_t}\lambda_t.
\]

**(F14) Investment arbitrage rule**

\[
\left(\gamma_K\frac{J_t^K}{K_{t-1}}+\gamma_I\Delta J_t^K\right)
-E_t\left(\frac{1}{1+r_t+\pi_{t+1}^{GDP}-\pi_{t+1}^I}\Delta J_{t+1}^K\right)
=\frac{\xi_t}{p_t^I}-1.
\]

**(F15) Shadow value of capital (`needs_review`: source equation ends with an ambiguous `=0`)**

\[
\frac{\xi_t}{p_t^I}
=E_t\left(\frac{1}{1+r_t+\pi_{t+1}^{GDP}-\pi_{t+1}^I}\frac{\xi_{t+1}}{p_{t+1}^I}(1-\delta_k)\right)
+(1-t_t^k)i_t^k+t_t^k\delta_k.
\]

**(F16) Liquidity-constrained consumption**

\[
(1+t_t^c)P_t^C C_t^l=(1-t_t^w)W_tN_t^l+TR_t^l-T_t^{LS,l}.
\]

**(F17) Wage-setting condition**

\[
\frac{(1-s^l)U_{1-N,t}^r+s^lU_{1-N,t}^l}
{(1-s^l)U_{c,t}^r+s^lU_{c,t}^l}
=\frac{1-t_t^w}{1+t_t^c}\frac{W_t}{P_t^C}\eta_t^W.
\]

**(F18) Wage-markup dynamics**

\[
\eta_t^W=1-\frac{1}{\theta}
-\frac{\gamma_W}{\theta}E_t\left(\beta\lambda_{t,t+1}^r(\pi_{t+1}^W-(1-sfw)\pi_t)-(\pi_t^W-(1-sfw)\pi_{t-1})\right).
\]

## 4. 市场出清与恒等式

**(F19) Aggregate consumption**

\[
C_t=(1-s^l)C_t^r+s^lC_t^l.
\]

**(F20) Aggregate employment**

\[
N_t=(1-s^l)N_t^r+s^lN_t^l,\qquad N_t^r=N_t^l.
\]

**(F21) Long-term bond pricing: new issue**

\[
P_t^N=\sum_{n=0}^{T}\frac{\delta_b^n}{(1+i)^{1+n}}c.
\]

**(F22) Long-term bond pricing: outstanding bond**

\[
P_t^O=\sum_{n=0}^{T-1}\frac{\delta_b^{1+n}}{(1+i)^{1+n}}c.
\]

**(F23) Approximate depreciation of outstanding long-term bond value**

\[
P_t^O=\delta_bP_t^N.
\]

**(F24) Government debt composition with cross-border and central-bank holdings**

\[
B_t=B_t^{L,H}+B_t^{L,F}+B_t^{L,CB}+B_t^S.
\]

**(F25) Public capital accumulation**

\[
KG_t=IG_t+(1-\delta^g)KG_{t-1}.
\]

**(F26) Transfers**

\[
TR_t=try\,P_t^C.
\]

**(F27) Government budget constraint**

\[
\begin{aligned}
\frac{B_t^S}{1+i_t}+P_t^NB_t^L
&=B_{t-1}^S+(\delta_bP_t^N+c)B_{t-1}^L+P_t^C(G_t+IG_t)+TR_t\\
&\quad-t_t^cP_t^cC_t-t_t^wW_tN_t-t_t^k(P_tY_t-W_tN_t-\delta_kP_t^IK_{t-1})-T_t^{LS}.
\end{aligned}
\]

**(F28) Fiscal closure rule**

\[
\Delta t_t^w=\tau^B\left(\frac{B_{t-1}}{P_{t-1}Y_{t-1}}-b^{tar}\right)
+\tau^{DEF}\Delta\left(\frac{B_t}{Y_tP_t}\right).
\]

**(F29) CPI aggregator**

\[
P_t^C=\left((1-s_m)P_t^{1-\sigma_m}+s_m(e_tP_t^F)^{1-\sigma_m}\right)^{\frac{1}{1-\sigma_m}}.
\]

**(F30) Imports**

\[
M_t=s_m\left(\frac{e_tP_t^{\ast}}{P_t^C}\right)^{-\sigma_m}Z_t.
\]

**(F31) Exports**

\[
X_t=s_m^{\ast}\left(\frac{P_t}{e_tP_t^{C\ast}}\right)^{-\sigma_x}Z_t^{\ast}.
\]

**(F32) Trade balance**

\[
TB_t=P_tX_t-e_tP_t^{\ast}M_t.
\]

## 5. 外生过程

**(F33) Central-bank operating profit**

\[
PR_t^{CB}=\Delta M_t+cB_{t-1}^{L,CB}-\left(P_t^NB_t^{L,CB}-\delta_bP_t^NB_{t-1}^{L,CB}\right).
\]

**(F34) Exogenous QE purchase path**

\[
B_t^{L,CB}=\rho_LB_{t-1}^{L,CB}+F(\cdot)+\varepsilon_t^{CB},\qquad F(\cdot)=0\ \text{in the paper simulations}.
\]

**(F35) Taylor rule**

\[
i_t=\rho_i i_{t-1}+(1-\rho_i)\left(\bar{r}+\pi^{tar}+\tau_\pi(\pi_t^C-\pi^{tar})+\tau_y\,ygap_t\right).
\]

**(F36) Output gap**

\[
ygap_t=\alpha\ln(N_t/N_t^{ss})+(1-\alpha)\ln(ucap_t/ucap_t^{ss}).
\]

**(F37) Employment trend**

\[
N_t^{ss}=\rho^NN_{t-1}^{ss}+(1-\rho^N)N_t.
\]

**(F38) Capacity-utilisation trend**

\[
ucap_t^{ss}=\rho^{ucap}ucap_{t-1}^{ss}+(1-\rho^{ucap})ucap_t.
\]

实现交叉核对还包含政府支出、公共投资、消费、加成、劳动供给、TFP、货币政策、QE、债券风险溢价、货币风险溢价、投资风险溢价、劳动税闭合、转移、产能利用、企业价值、工资和进口需求等冲击。许多属于实现层面的扰动过程，论文附录没有完整推导，作为源支持方程仍标记为 `needs_review`。

## 6. 稳态求解

论文附录给出校准表，而不是完整解析稳态推导。因此第一遍稳态重建标记为 `needs_review`。

1. 从校准表设定趋势通胀、人口增长、TFP 增长、公共债务目标比率、稳定税率、进口份额和偏好/摩擦参数。
2. 在实现稳态中归一化价格和长期债券价格：`ea_py=ea_pc=EA_pbl=1`，RoW 对应变量对称处理。
3. 设长期债券期限参数 \(\delta_b=0.975\)、长期债券占总债务份额 \(s_{bl}=0.5\)、组合调整成本 \(\gamma_b=0.00015\)，均来自论文校准。
4. 选择 EA 稳态产出份额：私人消费 0.58、投资 0.20、政府购买 0.18、政府投资 0.04、出口 0.23、进口 0.23。
5. 用 (F1)、(F3)-(F5)、公共资本积累、产能利用处于趋势值以及校准税收/风险溢价楔子，联合求解生产和要素模块。
6. 通过 (F12)、(F16) 和 (F19) 求解 Ricardian 与流动性受限消费，LC 家庭份额校准为 0.40。
7. 由 (F24)、(F27)、(F28) 和校准债务目标求解债券存量和政府债务。
8. 基准稳态设 QE 冲击路径为零：\(\varepsilon_t^{CB}=0\)，中央银行长期债券持有量取政策模拟前的基准存量。

本档案条目未执行 Dynare `steady` 或 `check`。

## 7. 时序与形式约定

- 模型是非线性的，并作为动态 DSGE 模型求解/模拟；Rep-MMB 文件含水平变量和由 `dyn` 开关控制的一阶差分辅助变量。
- 实现中的资本通过使用 `ea_k-ea_dk` 和滞后资本差分的方程体现预定状态；论文写作中说明 \(K_t=I_t+(1-\delta_k)K_{t-1}\)。
- 长期债券是递减息票资产。存量价值按 \(\delta_b\) 衰减，旧债价格近似为 \(\delta_bP_t^N\)。
- QE 由中央银行长期债券存量表示，而不是短端利率规则冲击。论文模拟中的购买路径是外生的，并根据 ECB 公告校准。
- 两地区模型结构上对 EA 和 RoW 对称，实现中用 EA/RoW 前缀（`ea_`, `r_`, `EA_`, `R_`）。
- 公式质量：附录 OCR 对显示公式总体可用，但 F8、F9、F15 和完整家庭拉格朗日式需要与 PDF 或原论文做源级核查。

## 8. 变量与参数对照表

### 核心内生变量

| 类别 | 符号 / 实现提示 | 含义 | 主要方程 |
|---|---|---|---|
| 内生 | \(Y_t\) / `ea_y` | 产出 | (F1), (F27), (F30)-(F32) |
| 内生 | \(N_t\) / `ea_l` | 就业 | (F2), (F3), (F20), (F36)-(F37) |
| 内生 | \(K_t\) / `ea_k` | 私人资本 | (F4), (F11), (F14)-(F15) |
| 内生 | \(ucap_t\) / `ea_ucap` | 产能利用率 | (F5), (F36), (F38) |
| 内生 | \(\eta_t\) / `ea_eta` | 商品加成或边际成本楔子 | (F3)-(F6) |
| 内生 | \(C_t,C_t^r,C_t^l\) / `ea_c`, `ea_cnlc`, `ea_clc` | 总消费、Ricardian 消费、LC 消费 | (F12), (F16), (F19) |
| 内生 | \(W_t\) / `ea_wr` | 真实工资 | (F13), (F17)-(F18) |
| 内生 | \(B_t^S,B_t^L,B_t^{L,CB}\) / `EA_bs`, `EA_bl`, `EA_blcb` | 短债、长期债、央行长期债持有 | (F7)-(F10), (F24), (F27), (F33)-(F34) |
| 内生 | \(P_t^N\) / `EA_pbl` | 长期债券价格 | (F21)-(F23) |
| 内生 | \(i_t\) / `ea_inom` | 短期名义政策利率 | (F7), (F35) |
| 内生 | \(e_t\) / `ea_e` | 汇率 | (F9), (F10), (F29)-(F32) |
| 内生 | \(M_t,X_t,TB_t\) / `ea_im`, `ea_ex`, `ea_tby` | 进口、出口、贸易余额 | (F29)-(F32) |

### 外生冲击和路径

| 类别 | 实现提示 | 含义 | 来源状态 |
|---|---|---|---|
| 外生 | `EA_eps_qe` | ECB 长期债券购买路径 | QE 模块有来源说明 |
| 外生 | `ea_eps_m` | 货币政策冲击 | 实现交叉核对 |
| 外生 | `ea_eps_ltfp` | TFP 冲击 | 实现交叉核对 |
| 外生 | `ea_eps_g`, `ea_eps_ig` | 政府购买和政府投资冲击 | 实现交叉核对 |
| 外生 | `ea_eps_rpremb`, `ea_eps_rpreme`, `ea_eps_rpremk` | 政府债券、货币和资本风险溢价冲击 | 实现交叉核对 |
| 外生 | many `ea_ex_*` variables | 稳态值或目标值 | 实现交叉核对 |

### 参数

| 类别 | 符号 / 实现提示 | 含义 | 校准线索 |
|---|---|---|---|
| 参数 | \(\beta\) / `ea_theta` in implementation discounting expression | 时间贴现 | 模型方程 |
| 参数 | \(\alpha\) / `ea_alpha` | 生产函数劳动份额 | 0.65 |
| 参数 | \(\alpha_g\) / `ea_alphag` | 公共资本生产参数 | 校准表 |
| 参数 | \(\delta_k\) / `ea_delta` | 私人资本折旧 | 0.015 |
| 参数 | \(\delta_b\) / `EA_deltabl` | 长期债券息票衰减 | 0.975 |
| 参数 | \(\gamma_b\) / `EA_gamb` | 短债与长债组合调整成本 | 约 0.00015 |
| 参数 | \(\gamma_b^{\ast}\) / `EA_gambd` | 国内与外国长期债券调整成本 | 表中为 0.0013 |
| 参数 | \(\gamma_K,\gamma_I\) / `ea_gami`, `ea_gami2` | 资本和投资调整成本 | 20.0 和 75.0 |
| 参数 | \(\gamma_N,\gamma_P,\gamma_W\) / `ea_gaml`, `ea_gamp`, `ea_gamw` | 劳动、价格和工资调整成本 | 校准表 |
| 参数 | \(s^l\) / `ea_slc` | 流动性受限家庭份额 | 0.40 |
| 参数 | \(\rho_i,\tau_\pi,\tau_y\) / `ea_ilag`, `ea_tinf`, `ea_ty` | Taylor 规则平滑、通胀反应、产出缺口反应 | 0.82, 1.50, 0.05 |
| 参数 | \(\rho^N,\rho^{ucap}\) / `ea_llag`, `ea_ucaplag` | 就业和产能利用趋势平滑 | 0.95, 0.99 |
