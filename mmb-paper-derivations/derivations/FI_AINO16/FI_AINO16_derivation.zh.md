# FI_AINO16 -- 推导（最优化问题 + 均衡条件）

> 用途：私有 MMB 模型档案的一次源文献支撑推导。未执行运行时验证。公式状态为 `needs_review`，因为论文 Markdown/OCR 源对模型模块是清楚的，但完整线性化附录方程尚未逐条对照 PDF 正文核查。

来源：Kilponen, Juha; Orjasniemi, Seppo; Ripatti, Antti; Verona, Fabio (2016), "The Aino 2.0 model", Bank of Finland Research Discussion Paper 16/2016, DOI `10.2139/ssrn.2795479`。

## 1. Model Overview

- **模型**：Aino 2.0，一个季度频率、用于芬兰的小型开放经济估计 DSGE 模型，包含垄断竞争银行、名义刚性、财政细节和外部部门冲击。
- **MMB ID**：`FI_AINO16`。
- **实验/用途**：贝叶斯估计的线性理性预期模型，用于预测、政策分析、方差分解和脉冲响应。Rep-MMB 实现使用 `model(linear)` 并模拟选定冲击。
- **主体和模块**：家庭、国内中间品企业、最终消费品和投资品零售商、出口商、进口商、财政当局、企业家、竞争性资本品生产者、含批发和零售贷款分支的银行，以及外生的国外/技术/财政/金融过程。
- **形式**：实现交叉核查显示为 `model(linear)`。论文描述非线性结构问题并报告/对数线性化状态空间表示；本条目记录结构方程和关键线性化银行关系。完整附录方程覆盖仍为 `needs_review`。
- **来源匹配**：索引标题为 "The AINO II model"；主要 Markdown 首页为 "The Aino 2.0 model" 且作者匹配预期。这被视为标题规范化差异，而不是不同来源。

## 2. Optimization Problems

### 国内中间品生产者

中间品企业 \(j\) 使用 Harrod 中性的 CES 技术组合资本服务和私人劳动：

\[
Y_t(j)=\left[\delta_Y(\Lambda_{k,t}K_t)^{-\rho_Y}+(1-\delta_Y)(\Lambda_{l,t}L_t^F)^{-\rho_Y}\right]^{-1/\rho_Y}. \tag{F1}
\]

它在 (F1) 约束下最小化名义要素成本：

\[
\min_{\{K_t,L_t^F\}}\; R_t^K K_t+(1+\tau_t^F)W_tL_t^F
\quad\text{s.t.}\quad Y_t(j)\text{ given by (F1)}. \tag{F2}
\]

### 设定价格的中间品企业

在以概率 \(1-\zeta\) 重新优化、未重新优化者部分指数化的 Calvo 环境中，能重设价格的企业求解：

\[
\max_{\{P_t^\circ(j)\}}\;E_t\sum_{s=0}^{\infty}\zeta^s M_{t,t+s}
\left[P^\circ_{t+s|t}(j)-\mathcal{MC}_{t+s}(j)\right]Y_{t+s|t}(j). \tag{F3}
\]

### 最终品零售商

竞争性消费品和投资品零售商选择国内和进口投入以生产：

\[
C_t^H=\left\{\delta_c(\Lambda_{cy,t}Y_t^C)^{-\rho_c}
+(1-\delta_c)\left[(1-\Gamma_{cm})\Lambda_{cm,t}M_t^C\right]^{-\rho_c}\right\}^{-1/\rho_c}. \tag{F4}
\]

\[
I_t=\left\{\delta_i(\Lambda_{iy,t}Y_t^I)^{-\rho_i}
+(1-\delta_i)\left[(1-\Gamma_{im})\Lambda_{im,t}M_t^I\right]^{-\rho_i}\right\}^{-1/\rho_i}. \tag{F5}
\]

调整成本为：

\[
\Gamma_{cm}=\frac{\gamma_{cm}}{2}\left(\frac{M_t^C/C_t^H}{M_{t-1}^C/C_{t-1}^H}-1\right)^2,\qquad
\Gamma_{im}=\frac{\gamma_{im}}{2}\left(\frac{M_t^I/I_t}{M_{t-1}^I/I_{t-1}}-1\right)^2. \tag{F6}
\]

### 出口商和进口商

出口生产者组合国内和进口投入：

\[
X_t(i)=\left[\delta_x(\Lambda_{xy,t}Y_t^X)^{-\rho_x}
+(1-\delta_x)(\Lambda_{xm,t}M_t^X)^{-\rho_x}\right]^{-1/\rho_x}. \tag{F7}
\]

能重设外币价格的出口企业求解 Calvo 问题：

\[
\max_{\{P_t^{\circ X}(i)\}}\sum_{s=0}^{\infty}\zeta_x^s E_t\left\{M_{t,t+s}
\left[P_{t+s|t}^{\circ X}(i)-S_{t+s}^{-1}\mathcal{MC}_{x,t+s}(i)\right]X_{t+s|t}(i)\right\}. \tag{F8}
\]

外国进口商在 Calvo 摩擦下选择欧元计价或外币计价价格，并面对 FCP 和 PCP 品种需求。其一般重设价格问题为：

\[
\max_{\{P_t^{\circ M,j}(k)\}}\sum_{s=0}^{\infty}\zeta_m^sE_t\left[R^{\ast}_{t,t+s}\mathcal{D}_{t+s|t}^j(k)\right],
\qquad j\in\{FCP,PCP\}. \tag{F9}
\]

### 家庭

家庭 \(h\) 在外部习惯和劳动负效用下最大化终身效用：

\[
E_t\sum_{s=t}^{\infty}\beta^{s-t}
\left[\zeta_s^C\log(C_{h,s}-b_cC_{s-1})-\frac{(H_{h,s})^{1+\sigma_l}}{1+\sigma_l}\right]. \tag{F10}
\]

名义预算约束为：

\[
\begin{aligned}
(1+\tau_s^C)P_s^CC_{h,s}+P_s^II_{h,s}+B_{h,s+1}+B_{h,s+1}^E+S_sB_{h,s+1}^{\ast}
&=(1-\tau_s^W)W_sH_{h,s}+(1-\tau_s^K)R_s^KK_{h,s}\\
&\quad+\delta\tau_s^KP_s^IK_{h,s}+\mathcal{D}_{h,s}+R_{s-1}B_{h,s}\\
&\quad+\Gamma_{A^{\ast}}(A_s^{\ast},\zeta_{s-1}^E)(R_{s-1}^EB_{h,s}^E+R_{s-1}^{\ast}S_sB_{h,s}^{\ast})\\
&\quad-\mathcal{TR}_{h,s}+\mathcal{S}_{h,s}.
\end{aligned} \tag{F11}
\]

资本积累为：

\[
K_{h,t+1}=(1-\delta)K_{h,t}+\zeta_t^I F(I_{h,t},I_{h,t-1}). \tag{F12}
\]

家庭在 Calvo 工资合约下设定差异化工资。重新优化的家庭选择 \(W^{\ast}_{h,t}\)，在劳动需求和指数化约束下最大化折现的税后劳动收入减劳动负效用；这给出工资 Phillips 曲线。

### 资本品生产者和企业家

竞争性资本品生产者选择投资以最大化新增安装资本的价值：

\[
\max_{\{I_t^{CGP}\}}\;E_0\sum_{t=0}^{\infty}\beta^t\phi_t
\left\{P_t^K\left[(1-\delta)K_t+\zeta_t^IF(I_t^{CGP},I_{t-1}^{CGP})\right]\right\}
-P_t^K(1-\delta)K_t-P_t^II_t^{CGP}. \tag{F13}
\]

企业家用自身净值和银行贷款为资本支出融资：

\[
BL_{t+1}=P_t^K K_{t+1}-N_{t+1}. \tag{F14}
\]

企业家权益为：

\[
V_t=\left[(1-\tau_t^K)\frac{R_t^K}{P_t^C}+(1-\delta+\delta\tau_t^K)Q_t\right]P_t^CK_t
-(1+r_{t-1}^b)(Q_{t-1}P_{t-1}^CK_t-N_t). \tag{F15}
\]

净值演化为：

\[
N_{t+1}=\gamma V_t+W^e. \tag{F16}
\]

### 银行

批发分支在资产负债表和资本比率偏离成本约束下选择贷款和存款：

\[
\max_{\{BL_{t+1},D_{t+1}\}}\;R_t^bBL_{t+1}-R_t^dD_{t+1}
-\frac{\kappa_{K^b}}{2}\left(\frac{K_{t+1}^b}{BL_{t+1}}-v_t^b\right)^2K_{t+1}^b
\quad\text{s.t.}\quad BL_{t+1}=D_{t+1}+K_{t+1}^b. \tag{F17}
\]

零售贷款分支在二次调整成本下选择差异化贷款利率：

\[
\max_{\{r_{t+\tau}^b(z)\}}\;E_0\sum_{\tau=0}^{\infty}\beta^\tau\phi_{t+\tau}
\left[(r_{t+\tau}^b(z)-R_{t+\tau}^b)bl_{t+1+\tau}(z)
-\frac{\kappa_b}{2}\left(\frac{r_{t+\tau}^b(z)}{r_{t-1+\tau}^b(z)}-1\right)^2r_{t+\tau}^bBL_{t+1+\tau}\right]. \tag{F18}
\]

## 3. First-Order Conditions

Rep-MMB 文件实现的是线性化系统。下面列出结构 FOC 或论文报告/对数线性化条件；若干附录级映射仍为 `needs_review`。

- **(F19) CES 中间品生产的名义边际成本**：

\[
\mathcal{MC}_t=\left[
\delta_Y^{1/(1+\rho_Y)}\left(\frac{R_t^K}{\Lambda_{k,t}}\right)^{\rho_Y/(1+\rho_Y)}
+(1-\delta_Y)^{1/(1+\rho_Y)}\left(\frac{(1+\tau_t^F)W_t}{\Lambda_{l,t}}\right)^{\rho_Y/(1+\rho_Y)}
\right]^{(1+\rho_Y)/\rho_Y}. \tag{F19}
\]

- **(F20) 无工资刚性时的期内劳动供给**：

\[
\psi_{\Lambda,t}(1-\tau_t^W)\frac{W_{h,t}}{P_t^C\Lambda_{l,t}^P}
=\lambda_{w,t}H_{h,t}^{\sigma_l}. \tag{F20}
\]

- **(F21) 资本品生产者/Tobin's Q FOC**：

\[
\frac{P_t^I}{P_t^C}=
\frac{P_t^K}{P_t^C}\zeta_t^IF'(I_t^{CGP},I_{t-1}^{CGP})
+\beta E_t\frac{\psi_{t+1}}{\psi_t}\frac{P_{t+1}^K}{P_{t+1}^C}
\zeta_{t+1}^IF'(I_{t+1}^{CGP},I_t^{CGP}). \tag{F21}
\]

- **(F22) 企业家资本 Euler 方程**：

\[
P_t^K=\beta E_t\left\{(1-\tau_{t+1}^K)R_{t+1}^K
+(1-\delta+\delta\tau_{t+1}^K)P_{t+1}^K-r_t^bP_t^K\right\}. \tag{F22}
\]

- **(F23) 企业家资本 Euler 方程的实际价格形式**：

\[
Q_t=\frac{\beta}{1+\beta r_t^b}E_t\left[
(1-\tau_{t+1}^K)\frac{R_{t+1}^K}{P_t^C}
+\frac{(1-\delta+\delta\tau_{t+1}^K)Q_{t+1}P_{t+1}^C}{P_t^C}
\right]. \tag{F23}
\]

- **(F24) 批发贷款利差条件**：

\[
S_t^w\equiv R_t^b-r_t^{FI}
=-\kappa_{K^b}\left(\frac{K_{t+1}^b}{BL_{t+1}}-v_t^b\right)
\left(\frac{K_{t+1}^b}{BL_{t+1}}\right)^2. \tag{F24}
\]

- **(F25) 零售贷款利率方程，对数线性化**：

\[
\tilde r_t^b=
\frac{\varepsilon^b-1}{\varepsilon^b-1+(1+\beta)\kappa_b}\tilde R_t^b
-\frac{1}{\varepsilon^b-1+(1+\beta)\kappa_b}\tilde\varepsilon_t^b
+\frac{\kappa_b}{\varepsilon^b-1+(1+\beta)\kappa_b}\tilde r_{t-1}^b
+\frac{\beta\kappa_b}{\varepsilon^b-1+(1+\beta)\kappa_b}E_t\tilde r_{t+1}^b. \tag{F25}
\]

- **(F26) 净批发贷款利率，对数线性化**：

\[
\tilde R_t^b=\tilde R_t-\frac{\kappa_{K^b}}{R^b}(v^b)^3
\left(\tilde k_{t+1}^b-\tilde{bl}_{t+1}-\tilde v_t^b\right). \tag{F26}
\]

## 4. Market Clearing & Identities

- **(F27) 国内中间品市场出清**：

\[
\int_0^1Y_t(j)\,dj=Y_t^C+Y_t^I+Y_t^X. \tag{F27}
\]

- **(F28) 价格离散度加总**：

\[
\int_0^1Y_t(j)\,dj=\Delta_{p,t}Y_t. \tag{F28}
\]

- **(F29) 出口需求**：

\[
X_t=\exp(\epsilon_{x,t})\left(\frac{P_t^X}{P_t^W}\right)^{-1/(1+\rho_w)}M_t^W. \tag{F29}
\]

- **(F30) 进口市场出清**：

\[
M_t=M_t^C+M_t^I+M_t^X. \tag{F30}
\]

- **(F31) 最终消费和投资市场出清**：

\[
C_t=C_t^H=\int_0^1C_{h,t}\,dh,\qquad
I_t=I_t^H+I_t^G=\int_0^1I_{h,t}\,dh+I_t^G. \tag{F31}
\]

- **(F32) 国内债券市场出清**：

\[
B_t=\int_0^1B_{h,t}\,dh=0. \tag{F32}
\]

- **(F33) 名义总资源约束**：

\[
P_tY_t=P_t^CC_t^H+P_t^II_t^H+P_tC_t^G+P_t^II_t^G+S_tP_t^XX_t
-P_t^M(M_t^C+M_t^I+M_t^X). \tag{F33}
\]

- **(F34) 净国外资产**：

\[
NFA_{t+1}^{\ast}=R_t^EB_t^E+R_t^{\ast}S_tB_t^{\ast}+TB_t. \tag{F34}
\]

- **(F35) 贸易余额**：

\[
TB_t=S_tP_t^XX_t-P_t^M(M_t^C+M_t^I+M_t^X). \tag{F35}
\]

- **(F36) 贸易条件**：

\[
ToT_t=\frac{S_tP_t^X}{P_t^M}. \tag{F36}
\]

- **(F37) 银行资本积累**：

\[
K_{t+1}^b=(1-\delta^b)\frac{K_t^b}{\varepsilon_t^{Kb}}+J_t^b. \tag{F37}
\]

- **(F38) 银行利润**：

\[
J_t^B=r_{t-1}^bBL_t-r_{t-1}^{FI}D_t
-\frac{\kappa_{K^b}}{2}\left(\frac{K_{t+1}^b}{BL_{t+1}}-v_t^b\right)^2K_{t+1}^b
-\frac{\kappa_b}{2}\left(\frac{r_t^b}{r_{t-1}^b}-1\right)^2r_t^bBL_{t+1}. \tag{F38}
\]

## 5. Exogenous Processes

来源和实现包含许多 AR(1) 冲击。下面列表遵循论文的结构类别和 Rep-MMB 冲击名称。

- **(F39) 永久劳动生产率增长**：

\[
\mu_t=\rho_\mu\mu_{t-1}+\varepsilon_{\mu,t}. \tag{F39}
\]

- **(F40) 临时生产率移位项**：

\[
\lambda_{k,t}=\rho_{\lambda k}\lambda_{k,t-1}+\varepsilon_{\lambda k,t},\qquad
\lambda_{l,t}^T=\rho_{\lambda l}\lambda_{l,t-1}^T+\varepsilon_{\lambda l,t}. \tag{F40}
\]

- **(F41) 消费和投资技术/偏好移位项**：

\[
\lambda_{cy,t}=\rho_{cy}\lambda_{cy,t-1}+\varepsilon_{cy,t},\quad
\lambda_{cm,t}=\rho_{cm}\lambda_{cm,t-1}+\varepsilon_{cm,t},\quad
\lambda_{iy,t}=\rho_{iy}\lambda_{iy,t-1}+\varepsilon_{iy,t}. \tag{F41}
\]

- **(F42) 加成冲击**：

\[
\upsilon_t=\rho_\upsilon\upsilon_{t-1}+\varepsilon_{\upsilon,t},\quad
\upsilon_{m,t}=\rho_{\upsilon m}\upsilon_{m,t-1}+\varepsilon_{\upsilon m,t},\quad
\upsilon_{x,t}=\rho_{\upsilon x}\upsilon_{x,t-1}+\varepsilon_{\upsilon x,t}. \tag{F42}
\]

- **(F43) 需求、财政、外部和金融冲击**：

\[
zeta_{C,t},\ zeta_{E,t},\ \lambda_{W,t},\ i_t^G,\ h_t^G,\ c_t^{GF},\ p_t^{OIL},\ p_t^{RAW},\ m_t^W,\ \pi_t^W,\ \Delta s_t,\ \epsilon_{b,t},\ \epsilon_{Kb,t},\ r_t^{EUR}
\quad\text{follow AR(1) or exogenous processes in the linearized system.} \tag{F43}
\]

## 6. Steady-State Solution

来源说明估计使用模型的线性或对数线性状态空间表示，校准和稳态比率见表格。Rep-MMB 实现在 `model(linear)` 模块之前，通过一组很长的辅助定义计算确定性非线性稳态。

对本次初稿推导：

1. 将 `model(linear)` 模块中的所有线性化变量规范化为相对于非随机稳态的偏离；稳态偏离为零。
2. 相对价格、加成、税率、支出份额、银行比率以及外国/外部稳态值使用已校准/估计的稳态对象。
3. 从实现的辅助定义中确定的确定性稳态比率仅作为 `implementation_cross_check`，不作为论文侧证明。
4. 完整解析稳态重建标记为 `needs_review`，因为论文表格和附录方程尚未与 `.mat` 校准文件人工核对。

来源中可见的关键稳态目标包括季度校准、样本平均通胀、公共消费/投资/劳动份额、税率、外部进出口比率、银行资本资产比率、贷款/GDP 和贷款利差。实现交叉核查还使用 `ssnuBank`、`BYSS_data`、`spread_data` 等常数构造 `NWSS`、`BTOTSS`、银行资本、存款、杠杆和贷款比率。

## 7. Timing & Form Conventions

- **形式**：线性化/对数线性化系统；Rep-MMB 使用 `model(linear)`。
- **资本时序**：论文将家庭资本写作在时间 \(t\) 选择的 \(K_{h,t+1}\)；实现中生产和资本回报方程使用 `k(-1)` 作为预定资本。
- **企业家资产负债表时序**：企业家偿还旧贷款并在期末选择 \(K_{t+1}\)；净值 \(N_{t+1}\) 为下一期资本融资，权益 \(V_t\) 来自第 \(t\) 期回报。
- **银行资产负债表时序**：贷款 \(BL_{t+1}\) 与存款和银行资本一起选择。银行利润使用滞后贷款/存款回报，银行资本累积为 \(K_{t+1}^b\)。
- **名义和相对价格**：论文定义了许多名义价格；实现使用相对价格和通胀率的对数偏离（`pC`、`pI`、`pM`、`pX`、`pieC`、`pieI`、`pieM`、`pieY`、`pieX`、`pieW`）。
- **来源注意事项**：OCR 中有若干符号损坏（如类似加成项的 `rho_t^2`、欧元/外国资产符号、方程编号残留）。仅在可解释处保留，并在 `extraction_notes.md` 中标记。

## 8. Variable & Parameter Reference Table

### 内生变量

| Category | Symbol / Rep-MMB name | 含义 | 主要方程 |
|---|---|---|---|
| Endogenous | `y`, \(Y_t\) | 国内中间品产出 | (F1), (F27), (F28), (F33) |
| Endogenous | `hF`, `hG`, `h`, \(H_t^F,H_t^G,H_t\) | 私人/公共/总工时 | (F20), market clearing |
| Endogenous | `k`, \(K_t\) | 资本存量 | (F12), (F21), (F22) |
| Endogenous | `cH`, `c`, \(C_t^H,C_t\) | 家庭和总消费 | (F4), (F10), (F31), (F33) |
| Endogenous | `iH`, `iG`, `iT`, \(I_t^H,I_t^G,I_t\) | 私人、公共和总投资 | (F5), (F12), (F21), (F31) |
| Endogenous | `q`, \(Q_t\) | 安装资本实际价格 | (F21), (F23) |
| Endogenous | `rK`, \(R_t^K\) | 资本租赁回报 | (F19), (F22) |
| Endogenous | `wF`, `wG`, `w`, \(W_t\) | 私人/公共/平均工资 | (F20), wage setting |
| Endogenous | `mcY`, `mcX`, \(\mathcal{MC}_t,\mathcal{MC}_{x,t}\) | 边际成本 | (F19), (F7), (F8) |
| Endogenous | `pieY`, `pieX`, `pieMC`, `pieM`, `pieC`, `pieI` | 通胀率 | Calvo pricing (F3), (F8), (F9) |
| Endogenous | `pC`, `pI`, `pM`, `pX`, `pOILS`, `pRAWS` | 相对价格 | price identities |
| Endogenous | `yC`, `mC`, `yI`, `mI`, `yX`, `mX`, `m` | 国内/进口投入需求 | (F4), (F5), (F7), (F30) |
| Endogenous | `x`, \(X_t\) | 出口 | (F7), (F29), (F33), (F35) |
| Endogenous | `rs`, `ds`, \(S_t\) | 实际/名义汇率对象 | (F8), (F9), (F36) |
| Endogenous | `tbY`, `bstar`, `astar`, `ToT` | 贸易余额、NFA、贸易条件 | (F34), (F35), (F36) |
| Endogenous | `rFI`, `rEUR`, `rs` | 国内/欧元区/外部利率 | household bond FOCs, implementation cross-check |
| Endogenous | `nwe`, \(N_t\) | 企业家净值 | (F15), (F16) |
| Endogenous | `btot`, \(BL_t\) | 总贷款 | (F14), (F17) |
| Endogenous | `rb`, \(r_t^b\) | 零售贷款利率 | (F18), (F25) |
| Endogenous | `RB`, \(R_t^b\) | 批发贷款利率 | (F24), (F26) |
| Endogenous | `kbank`, \(K_t^b\) | 银行资本 | (F17), (F37) |
| Endogenous | `deposits`, \(D_t\) | 银行存款 | (F17) |
| Endogenous | `bankprofits`, \(J_t^B\) | 银行利润 | (F38) |
| Endogenous | `bka`, `lev_e`, `by` | 银行资本比率、企业家杠杆、信贷/产出 | banking identities |
| Endogenous | `psi`, `mu`, `lamK`, `lamLT`, `lamCY`, `lamCM`, `lamIY`, `upsilon*`, `zeta*`, `eps*` | 冲击状态和偏好/技术/加成楔子 | (F39)-(F43) |

### 外生冲击

| Rep-MMB name | 含义 |
|---|---|
| `epsMU` | 永久劳动生产率创新 |
| `epsLAMBDAK`, `epsLAMBDALT` | 临时资本和劳动生产率创新 |
| `epsLAMBDACY`, `epsLAMBDACM`, `epsLAMBDAIY` | 最终品技术/偏好移位项创新 |
| `epsUPSILON`, `epsUPSILONMC`, `epsUPSILONX` | 国内/进口/出口加成创新 |
| `epsZETACH`, `epsZETAEUR`, `epsLAMW` | 消费偏好、国内风险溢价、工资加成/劳动创新 |
| `epsIG`, `epshG`, `epsGF` | 政府投资、政府劳动、政府消费创新 |
| `epsPOILS`, `epsPRAWS`, `epsMW`, `epsPIEW`, `epsdS`, `epsXX` | 油价、原材料、世界需求、外国通胀、汇率、出口份额创新 |
| `epsEPSB`, `epsnuB`, `epsBankCapital`, `epsrEUR` | 银行加成、资本要求、银行资本、欧元区利率创新 |

### 参数

| 参数组 | Symbols / Rep-MMB names | 含义 |
|---|---|---|
| 偏好 | `bet`, `bC`, `sigmaL`, `lambdaW`, `xiW` | 贴现、习惯、劳动曲率、工资加成、工资 Calvo |
| 生产 | `rhoY`, `deltaY`, `ssLAMBDAK`, `ssLAMBDALT`, `delta`, `ssMU` | CES 生产、要素移位项、折旧、增长 |
| 最终品 | `rhoC`, `deltaC`, `gamCM`, `rhoI`, `deltaI`, `gamI`, `gamIM` | 消费/投资品 CES 和调整成本 |
| 贸易 | `rhoX`, `deltaX`, `thetaX`, `zetaX`, `sigmaW`, `RMCX`, `omegaOIL`, `omegaRAW` | 出口/进口 CES、Calvo、需求弹性、进口组成 |
| 价格 | `zeta`, `theta`, `thetaMC`, `omegaMC` | 国内和进口价格 Calvo/指数化/传递 |
| 税收/财政 | `ssTAXWR`, `ssTAXFR`, `ssTAXCR`, `ssTAXKR`, `ssGCF`, `ssIG`, `ssHG` | 劳动、企业、消费、资本税以及公共份额 |
| 银行 | `ssnuBank`, `kappaB`, `kappaKB`, `deltaBank`, `spread_data`, `BYSS_data` | 银行资本比率、贷款利率调整、资本比率成本、银行折旧、稳态比率 |
| 冲击持续性 | `rho*` parameters | 技术、需求、加成、外部和金融冲击的 AR(1) 系数 |
