# EA_QUEST3 -- QUEST III 推导

> `EA_QUEST3` 的第一遍私有模型档案推导。状态：`needs_review`。
> 未执行运行时验证。

来源：Ratto, Marco; Roeger, Werner; Veld, Jan (2009), "QUEST III: An estimated open-economy DSGE model of the euro area with fiscal and monetary policy", *Economic Modelling* 26(1), 222-233, DOI `10.1016/j.econmod.2008.06.014`。

## 1. Model Overview

- **模型**：QUEST III 欧元区估计型开放经济 DSGE 模型。
- **用途**：用于欧元区货币与财政稳定政策的贝叶斯估计和脉冲响应分析。
- **经济体**：小型开放经济，面对外生的世界利率、世界通胀、世界需求和外国价格。
- **主体与机构**：垄断竞争的国内企业、投资品生产者、李嘉图家庭、流动性约束家庭、工资设定工会、进出口价格设定者、财政当局和货币当局。
- **摩擦**：带指数化的价格调整成本、带指数化的工资调整成本、劳动调整成本、可变产能利用率、投资调整成本、外国债券风险溢价、资本权益溢价、流动性约束家庭和财政政策规则。
- **形式**：论文端以水平和增长率的非线性模型为基础，并用平稳增长率和名义比率估计。MMB 实现交叉检查是线性化/对数增长率 Dynare 实现，使用 `E_GY`、`E_LCSN`、`E_INOM`、`E_LYGAP` 等变量。本档案条目记录论文端方程，并将 OCR 敏感公式标为 `needs_review`。

## 2. Optimization Problems

### 国内最终品企业

企业 \(j\) 面对其差异化国内品种的需求：

**(F1) 国内品种需求**：

\[
Y_t^j =
\frac{1-s^M-u_t^M}{n}
\left(\frac{P_t}{P_t^j}\right)^{\sigma^d}
\left(\frac{P_t^C}{P_t}\right)^{\sigma^M}
\left(C_t+C_t^G+I_t^G+I_t^{inp}+X_t\right).
\]

生产使用经利用率调整的私人资本、扣除固定劳动后的劳动、技术和公共资本：

**(F2) 生产函数**：

\[
Y_t^j =
\left(ucap_t^j K_t^j\right)^{1-\alpha}
\left(L_t^j-LO_t^j\right)^\alpha
\left(U_t^Y\right)^\alpha
\left(K_t^G\right)^{1-\alpha_G}.
\]

企业总劳动是家庭劳动类型的 CES 聚合：

**(F3) 劳动聚合**：

\[
L_t^j =
\left[\int_0^1 \left(L_t^{i,j}\right)^{(\theta-1)/\theta}\,di\right]^{\theta/(\theta-1)}.
\]

代表性企业选择劳动、资本服务、利用率和价格来最大化当期实际利润：

**(F4) 企业利润目标**：

\[
Pr_t^j =
\frac{P_t^j}{P_t}Y_t^j
-\frac{W_t}{P_t}L_t^j
-i_t^K\frac{P_t^I}{P_t}K_t^j
-\frac{adj^P(P_t^j)+adj^L(L_t^j)+adj^{UCAP}(ucap_t^j)}{P_t}.
\]

调整成本为：

**(F5) 劳动调整成本**：

\[
adj^L(L_t^j)=W_t\left(L_t^j u_t^L+\frac{\gamma_L}{2}(\Delta L_t^j)^2\right).
\]

**(F6) 价格调整成本**：

\[
adj^P(P_t^j)=\frac{\gamma_P}{2}\frac{(\Delta P_t^j)^2}{P_{t-1}^j}.
\]

**(F7) 产能利用率调整成本**：

\[
adj^{UCAP}(ucap_t^j)=P_t^I K_t\left[\gamma_{ucap,1}(ucap_t^j-1)+\frac{\gamma_{ucap,2}}{2}(ucap_t^j-1)^2\right].
\]

### 投资品生产者

投资品部门把国内和外国最终品组合为投资投入，并用线性技术转化：

**(F8) 投资品技术**：

\[
I_t=I_t^{inp}U_t^I.
\]

**(F9) 投资品价格**：

\[
P_t^I=\frac{P_t^C}{U_t^I}.
\]

### 李嘉图家庭

非流动性约束家庭选择消费、国内和外国债券、物质资本、现金余额和投资。论文将其问题写为：

**(F10) 李嘉图家庭目标**：

\[
\max E_0\sum_{t=0}^{\infty}\beta^t U(C_t^i,1-L_t^i).
\]

当期效用为：

**(F11) 习惯效用**：

\[
U(C_t^i,1-L_t^i)=
\frac{
\exp(\varepsilon_t^C)
\left[
\left(C_t^i-h^C C_{t-1}\right)
\left(1-\exp(\varepsilon_t^L)\omega(L_t^i-h^L L_{t-1})^\kappa\right)
\right]^{1-\rho}-1
}{1-\rho}.
\]

带调整成本的物质投资支出为：

**(F12) 家庭资本投资调整成本**：

\[
I_t^i=
J_t^i\left(1+\frac{\gamma_K}{2}\frac{J_t^i}{K_{t-1}^i}\right)
+\frac{\gamma_I}{2}(\Delta J_t^i)^2.
\]

### 流动性约束家庭

流动性约束家庭不在资产上优化；其消费等于当期可支配收入：

**(F13) 流动性约束消费**：

\[
(1+t_t^c)P_t^C C_t^k=(1-t_t^w)W_t L_t+\mathrm{TR}_t^k-T_t^{LS,k}.
\]

### 贸易聚合器

私人消费、投资、政府消费和政府投资使用相同的国内/外国 CES 聚合器：

**(F14) 国内/外国吸收聚合器**：

\[
Z^i=
\left[
(1-s^M-u_t^M)^{1/\sigma^M}(Z^{d,i})^{(\sigma^M-1)/\sigma^M}
+(s^M+u_t^M)^{1/\sigma^M}(Z^{f,i})^{(\sigma^M-1)/\sigma^M}
\right]^{\sigma^M/(\sigma^M-1)}.
\]

## 3. First-Order Conditions

### 企业

**(F15) 劳动需求条件**（`needs_review`：OCR 中前瞻劳动调整项的括号受损）：

\[
\alpha\frac{Y_t^j}{L_t^j-LO_t^j}\eta_t^j
-\frac{W_t}{P_t^j}u_t^L
-\frac{W_t}{P_t^j}\gamma_L\Delta L_t^j
+E_t\left[\frac{W_{t+1}}{P_{t+1}^j}\frac{\gamma_L}{1+r_t}\Delta L_{t+1}^j\right]
=\frac{W_t}{P_t^j}.
\]

**(F16) 资本服务需求**：

\[
(1-\alpha)\frac{Y_t^j}{K_t^j}\eta_t^j
=i_t^K\frac{P_t^{I,j}}{P_t^j}.
\]

**(F17) 产能利用率条件**：

\[
(1-\alpha)\frac{Y_t^j}{K_t^j ucap_t^j}\eta_t^j
=
\frac{P_t^{I,j}}{P_t^j}
\left(\gamma_{ucap,1}+\gamma_{ucap,2}(ucap_t^j-1)\right).
\]

**(F18) 企业加成条件**（`needs_review`：来源 OCR 损坏了 Eq. 7d 的撇号）：

\[
\eta_t =
1-\frac{1}{\sigma^d}
-\gamma_P\left[
\beta\left(sfp\,E_t\pi_{t+1}+(1-sfp)\pi_{t-1}\right)-\pi_t
\right]
-u_t^p.
\]

### 李嘉图家庭

**(F19) 消费边际效用条件**：

\[
U_{C,t}^i-\lambda_t\frac{(1+t_t^c)P_t^C}{P_t}=0.
\]

**(F20) 国内债券欧拉方程**：

\[
-\lambda_t+
E_t\left[
\lambda_{t+1}\beta
\left(1+(1-t_t^i)i_t\right)
\frac{P_t}{P_{t+1}}
\right]=0.
\]

**(F21) 带风险溢价的外国债券欧拉方程**：

\[
-\lambda_t+
E_t\left[
\lambda_{t+1}\beta
\left(1+(1-t_t^i)i_t^F\right)
\left(1-risk\!\left(\frac{E_tB_t^F}{P_tY_t}\right)-u_t^{B^F}\right)
\frac{P_t}{P_{t+1}}\frac{E_{t+1}}{E_t}
\right]=0.
\]

**(F22) 资本欧拉方程**：

\[
-\xi_t+
E_t\left[
\xi_{t+1}\beta(1-\delta)
+\lambda_{t+1}\beta
\left((1-t_t^K)(i_t^K-rp_t^K)+t_t^K\delta\right)
\frac{P_t^I}{P_{t+1}}
\right]=0.
\]

**(F23) 物质投资 FOC**（`needs_review`：来源 OCR 在 Eq. 13 与 Eq. 15a 中使用的资本时点不一致）：

\[
\gamma_K\frac{J_t^i}{K_{t-1}^i}
+\gamma_I\Delta J_t^i
-\frac{\gamma_I}{1+r_t}E_t(\Delta J_{t+1}^i)
=Q_t-1,
\qquad
Q_t=\frac{\xi_t}{\lambda_t}\frac{P_t}{P_t^I}.
\]

**(F24) Tobin-Q 资产价值方程**：

\[
Q_t=
E_t\left[
\frac{1-\delta}{(1-t_t^i)(1+i_t)/(1+{}_{t}\pi_{t+1}^I)}
Q_{t+1}
\right]
+(1-t_t^K)(i_t^K-rp_t^K)+t_t^K\delta.
\]

### 工资设定

**(F25) 工资规则**：

\[
\frac{W_t}{P_t^C}
=
\gamma_{WR}\frac{W_{t-1}}{P_{t-1}^C}
+(1-\gamma_{WR})
\frac{1}{\eta_t^W}
\frac{1+t_t^C}{1-t_t^W}
\frac{(1-slc)U_{1-L,t}^i+slc\,U_{1-L,t}^k}
{(1-slc)U_{c,t}^i+slc\,U_{c,t}^k}.
\]

**(F26) 带指数化的工资加成**（`needs_review`：OCR 括号受损）：

\[
\eta_t^W=
1-\frac{1}{\theta}
-\frac{\gamma_W}{\theta}
\left[
\beta\left(\pi_{t+1}^W-(1-sfw)\pi_t\right)
-\left(\pi_t^W-(1-sfw)\pi_{t-1}\right)
\right]
+u_t^W.
\]

## 4. Market Clearing & Identities

**(F27) 总消费**：

\[
C_t=(1-slc)C_t^i+slc\,C_t^k.
\]

**(F28) 总就业**：

\[
L_t=(1-slc)L_t^i+slc\,L_t^k,
\qquad L_t^i=L_t^k=L_t.
\]

**(F29) 进口需求**：

\[
M_t=(s^M+u_t^M)
\left[
\rho^{PCPM}\frac{P_{t-1}^C}{P_{t-1}^M}
+(1-\rho^{PCPM})\frac{P_t^C}{P_t^M}
\right]^{\sigma^M}
\left(C_t+I_t^{inp}+C_t^G+I_t^G\right).
\]

**(F30) 出口需求**：

\[
X_t=(s^{M,W}+u_t^X)
\left[
\rho^{PWPX}\frac{P_{t-1}^{C,F}E_{t-1}}{P_{t-1}^X}
+(1-\rho^{PWPX})\frac{P_t^{C,F}E_t}{P_t^X}
\right]^{\sigma^X}
Y_t^F.
\]

**(F31) 出口价格加成**：

\[
\eta_t^X P_t^X=P_t.
\]

**(F32) 进口价格加成**：

\[
\eta_t^M P_t^M=E_tP_t^F.
\]

**(F33) 进出口加成动态**：

\[
\eta_t^k=
1-\frac{1}{\sigma^{v,k}}
-\gamma_{Pk}
\left[
\beta\left(sfp^k E_t\pi_{t+1}^k+(1-sfp^k)\pi_{t-1}^k\right)-\pi_t^k
\right]
+u_t^{P,k},
\qquad k\in\{X,M\}.
\]

**(F34) 净外国资产**：

\[
E_tB_t^F=(1+i_t^F)E_tB_{t-1}^F+P_t^X X_t-P_t^M M_t.
\]

**(F35) 产出缺口指标**：

\[
YGAP_t=
\left(\frac{ucap_t}{ucap_t^{ss}}\right)^{1-\alpha}
\left(\frac{L_t}{L_t^{ss}}\right)^\alpha.
\]

**(F36) 平滑的产能利用率参照值**：

\[
ucap_t^{ss}=(1-\rho^{ucap})ucap_{t-1}^{ss}+\rho^{ucap}ucap_t.
\]

**(F37) 平滑的就业参照值**：

\[
L_t^{ss}=(1-\rho^{Lss})L_{t-1}^{ss}+\rho^{Lss}L_t.
\]

**(F38) 政府收入**：

\[
R_t^G=t_t^w W_tL_t+t_t^cP_t^C C_t+t_t^K i_t^K P_t^I K_{t-1}.
\]

**(F39) 劳动所得税规则**：

\[
t_t^w=\tau_0^w Y_t^{\tau_1^w}U_t^{TW}.
\]

**(F40) 线性化劳动所得税响应**：

\[
t_t^w=\tau_0^w+\tau_0^w\tau_1^w ygap_t.
\]

**(F41) 政府债务运动方程**：

\[
B_t=(1+i_t)B_{t-1}+P_t^C C_t^G+P_t^C I_t^G+\mathrm{TR}_t-R_t^G-T_t^{LS}.
\]

**(F42) 一次总付税/债务反馈**：

\[
\Delta T_t^{LS}
=\tau^B\left(\frac{B_{t-1}}{Y_{t-1}P_{t-1}}-b^T\right)
+\tau^{DEF}\Delta\left(\frac{B_t}{Y_tP_t}\right).
\]

## 5. Exogenous Processes

**(F43) TFP 随机趋势**：

\[
u_t^Y=g_t^U+u_{t-1}^Y+\varepsilon_t^Y.
\]

**(F44) 固定劳动份额**：

\[
lol_t^j=(1-\rho^{LOL})lol+\rho^{LOL}lol_{t-1}^j+\varepsilon_t^{LOL}.
\]

**(F45) 投资技术随机趋势**：

\[
u_t^I=g^{UI}+u_{t-1}^I+\varepsilon_t^{UI}.
\]

**(F46) 政府消费财政规则**：

\[
\Delta c_t^G=
(1-\tau_{Lag}^{CG})\overline{\Delta c^G}
+\tau_{Lag}^{CG}\Delta c_{t-1}^G
+\tau_{Adj}^{CG}(cgy_{t-1}-\overline{cgy})
+\sum_i\tau_i^{CG}ygap_{t-i}
+u_t^{CG}.
\]

**(F47) 政府投资财政规则**：

\[
\Delta i_t^G=
(1-\tau_{Lag}^{IG})\overline{\Delta i^G}
+\tau_{Lag}^{IG}\Delta i_{t-1}^G
+\tau_{Adj}^{IG}(igy_{t-1}-\overline{igy})
+\sum_i\tau_i^{IG}ygap_{t-i}
+u_t^{IG}.
\]

**(F48) 转移支付规则**：

\[
\mathrm{TR}_t=
b^U W_t(POP_t^W-POP_t^{NPART}-L_t)
+b^R W_tPOP_t^P
+u_t^{TR}.
\]

**(F49) 货币政策规则**：

\[
i_t=
\tau_{lag}^{INOM}i_{t-1}
+(1-\tau_{lag}^{INOM})
\left[
r^{EQ}+\pi^T+\tau_\pi^{INOM}(\pi_t^C-\pi^T)
+\tau_{y,1}^{INOM}ygap_{t-1}
\right]
+\tau_{y,2}^{INOM}(ygap_t-ygap_{t-1})
+u_t^{INOM}.
\]

**(F50) 通用自相关结构冲击**：

\[
\log U_t^k=\rho^k\log U_{t-1}^k+\varepsilon_t^k.
\]

## 6. Steady-State Solution

QUEST III 以增长率和平稳名义比率估计。论文说明，国内和外国 GDP 组成部分在增长率上平稳，而消费/GDP、投资/GDP、政府支出/GDP、转移支付/工资、贸易余额/GDP、工资份额、就业和实际汇率等名义比率平稳。

本第一遍档案条目记录如下：

- 稳态是平衡增长/平稳比率系统，而不是所有实际变量的单一水平稳态。
- 技术趋势过程 (F43) 和 (F45) 在生产率和投资专有技术中引入永久成分。
- 平稳名义比率和增长率由论文附录和 MMB 实现中报告的估计/校准参数块与稳态份额决定。
- 实现交叉检查值包括 `BETAE = 0.996`、`DELTAE = 0.025`、`GSN = 0.203`、`IGSN = 0.025`、`BGTAR = 2.4`、`SLC = 0.3507`、`L0 = 0.65`、`UCAP0 = 1`、`E_Q = 1`、`E_LYGAP = 0`、`E_BWRY = 0`，以及 `GP0 = 0.005`、`GY0 = 0.003` 等季度通胀/增长基线。
- `needs_review`：论文提到完整稳态关系见 Appendix 1，但 MinerU Markdown 未暴露足够公式细节的附录表；若不定向检查 PDF，无法 source-check 完整递归稳态块。

## 7. Timing & Form Conventions

- 生产中使用的资本相对于当期投资是预定状态；实现交叉检查使用 `E_GK` 等状态变量和 `E_LIK` 等投资资本比。
- 论文区分物质投资 \(J_t\) 与投资支出 \(I_t\)，原因是存在资本调整成本。
- 产能利用率是当期控制变量，产出缺口指标使用缓慢移动的参照利用率。
- 就业和产能利用率的趋势/参照变量是平滑状态。
- 净外国资产以本币计价，并随外国利息支付和贸易余额演化。
- 货币政策包含当期和滞后产出缺口项以及滞后名义利率平滑。
- 财政规则包含滞后支出增长、支出/GDP 比率误差修正和产出缺口响应。
- 模型形式是论文端非线性/增长率 DSGE；MMB 实现是线性化/对数增长率 Dynare 表示。不要把 `.mod` 方程当作独立论文证据。

## 8. Variable & Parameter Reference Table

| 类别 | 符号 / 实现名 | 含义 | 主要方程 |
|---|---|---|---|
| 内生 | \(Y_t^j\), `E_GY` | 国内产出/增长 | (F1), (F2), (F35) |
| 内生 | \(L_t\), `E_LL`, `E_GL` | 就业和就业增长 | (F3), (F15), (F28), (F37) |
| 内生 | \(K_t\), `E_GK` | 私人资本存量/增长 | (F16), (F22), (F24) |
| 内生 | \(ucap_t\), `E_UCAP` | 产能利用率 | (F17), (F35), (F36) |
| 内生 | \(P_t^j\), \(\pi_t\), `E_PHI` | 国内价格通胀/加成 | (F6), (F18) |
| 内生 | \(I_t\), \(J_t\), `E_GI`, `E_LIK` | 投资和物质投资 | (F8), (F12), (F23) |
| 内生 | \(Q_t\), `E_Q` | Tobin's Q | (F23), (F24) |
| 内生 | \(C_t^i\), `E_LCNLCSN` | 李嘉图消费 | (F10), (F11), (F19), (F27) |
| 内生 | \(C_t^k\), `E_LCLCSN` | 流动性约束消费 | (F13), (F27) |
| 内生 | \(C_t\), `E_LCSN` | 总消费 | (F27) |
| 内生 | \(W_t/P_t^C\), `E_LYWR`, `E_WS` | 实际消费工资/工资份额 | (F25), (F26) |
| 内生 | \(M_t\), `E_LIMYN` | 进口 | (F29), (F32), (F33) |
| 内生 | \(X_t\), `E_LEXYN` | 出口 | (F30), (F31), (F33) |
| 内生 | \(B_t^F\), `E_BWRY` | 净外国资产 | (F21), (F34) |
| 内生 | \(B_t\), `E_LBGYN` | 政府债务 | (F41), (F42) |
| 内生 | \(YGAP_t\), `E_LYGAP` | 产出缺口 | (F35) |
| 内生 | \(i_t\), `E_INOM` | 名义利率 | (F49) |
| 外生冲击 | \(\varepsilon_t^Y\), `E_EPS_Y` | TFP 创新 | (F43) |
| 外生冲击 | \(\varepsilon_t^{UI}\) | 投资技术创新 | (F45) |
| 外生冲击 | \(u_t^{CG}\), `E_EPS_G` / `fiscal_` | 政府消费冲击 | (F46) |
| 外生冲击 | \(u_t^{IG}\), `E_EPS_IG` | 政府投资冲击 | (F47) |
| 外生冲击 | \(u_t^{TR}\), `E_EPS_TR` | 转移支付冲击 | (F48) |
| 外生冲击 | \(u_t^{INOM}\), `E_EPS_M` / `interest_` | 货币政策冲击 | (F49) |
| 外生冲击 | \(u_t^M\), `E_EPS_EX` | 进口/贸易偏好冲击 | (F14), (F29), (F30) |
| 外生冲击 | \(u_t^p\), `E_EPS_ETA` | 国内价格加成冲击 | (F18) |
| 外生冲击 | \(u_t^W\), `E_EPS_W` | 工资加成冲击 | (F26) |
| 外生冲击 | \(u_t^{P,k}\), `E_EPS_ETAM`, `E_EPS_ETAX` | 进出口加成冲击 | (F33) |
| 参数 | \(\beta\), `BETAE` | 贴现因子 | (F10), (F20)-(F24) |
| 参数 | \(\alpha\), `ALPHAE` | 劳动/资本生产份额约定 | (F2), (F15)-(F17) |
| 参数 | \(\alpha_G\), `ALPHAGE` | 公共资本生产弹性 | (F2) |
| 参数 | \(\gamma_L\), `GAMLE` | 劳动调整成本 | (F5), (F15) |
| 参数 | \(\gamma_P\), `GAMPE` | 国内价格调整成本 | (F6), (F18) |
| 参数 | \(\gamma_{ucap,1}\), \(\gamma_{ucap,2}\), `A1E`, `A2E` | 利用率成本 | (F7), (F17) |
| 参数 | \(\gamma_K\), \(\gamma_I\), `GAMIE`, `GAMI2E` | 投资调整成本 | (F12), (F23) |
| 参数 | \(slc\), `SLC` | 流动性约束家庭占比 | (F13), (F27), (F28) |
| 参数 | \(\tau\) coefficients | 财政和货币规则系数 | (F46), (F47), (F49) |
| 参数 | \(\rho\) coefficients | 持续性参数 | (F36), (F37), (F43)-(F50) |
