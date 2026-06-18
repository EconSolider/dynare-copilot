# US_HL16 -- 推导（最优化问题 + 一阶条件）

> 第一遍档案抽取。状态：`needs_review`。运行验证：未执行。

来源信息：`US_HL16`，Hollander and Liu (2016)，"The equity price channel in a New-Keynesian DSGE model with financial frictions and banking"，DOI `10.1016/j.econmod.2015.09.015`。源 Markdown：`raw/mmb_mineru/runs/us_hl16__the_equity_price_channel_in_a_new_keynesian_dsge_model_with_financial_fr__e3259b88/full.md`。原始 PDF：`raw/mmb_papers/The equity price channel in a New-Keynesian DSGE model with financial frictions and banking.pdf`。MinerU run id：`e3259b88-d1fa-4daa-af29-40e129c1367e`。

## 1. Model Overview

- **模型**：美国中等规模 New-Keynesian DSGE 模型，包含异质家庭、股票需求、金融摩擦和银行资本。
- **论文设定**：使用美国季度数据进行 Bayesian 估计，样本期为 1982Q01-2015Q01。
- **主体**：储蓄型家庭、借款型家庭、企业家、垄断竞争零售商、含批发/存款/贷款分支的银行，以及货币当局。
- **股票价格渠道**：股票价格进入家庭财富、借款人和企业家的抵押品价值，以及银行资本积累。
- **模型形式**：论文附录 A 给出非线性均衡条件；Rep-MMB 实现交叉检查使用 `model(linear)`。本档案条目记录论文侧非线性方程，并将线性 MMB 实现标记为 `implementation_cross_check`。
- **第一遍状态**：`needs_review`，因为附录 A 中若干方程存在 OCR 损坏，且本任务未要求也未执行 Dynare 运行验证。

## 2. Optimization Problems

### 2.1 家庭

存在储蓄型家庭（`s`）和借款型家庭（`b`）。对类型 \(\Gamma \in \{b,s\}\)，终身目标为：

**(F1) Household utility objective**

\[
E_0 \sum_{t=0}^{\infty} \beta_\Gamma^t
\left[
\frac{(C_t^\Gamma-\phi C_{t-1}^\Gamma)^{1-\gamma^\Gamma}}{1-\gamma^\Gamma}
- \frac{(H_t^\Gamma)^{1+\eta}}{1+\eta}
+ a \ln\left(\frac{D_t^\Gamma}{P_t}\right)
+ \xi_{\psi,t}\ln\left(\frac{Q_t^\psi\Psi_t^\Gamma}{P_t}\right)
\right].
\]

其中 \(a=1\) 对应储蓄者，\(a=0\) 对应借款者。

### 2.2 储蓄者

储蓄者选择消费、存款、劳动和股票持有量，约束为：

**(F2) Saver budget constraint**

\[
C_t^s+\frac{D_t^s}{P_t}+\frac{Q_t^\psi}{P_t}\Psi_t^s
=
\frac{W_t}{P_t}H_t^s+\frac{I_{t-1}^dD_{t-1}^s}{P_t}
+\frac{Q_t^\psi+\Pi_{\psi,t}}{P_t}\Psi_{t-1}^s.
\]

### 2.3 借款者

借款者选择消费、劳动、家庭贷款和股票持有量，约束为：

**(F3) Borrower budget constraint**

\[
C_t^b+\frac{I_{t-1}^hL_{t-1}^h}{P_t}+\frac{Q_t^\psi}{P_t}\Psi_t^b
=
\frac{W_t}{P_t}H_t^b+\frac{L_t^h}{P_t}
+\frac{Q_t^\psi+\Pi_{\psi,t}}{P_t}\Psi_{t-1}^b.
\]

**(F4) Borrower binding collateral constraint**

\[
I_t^hL_t^h
=
\nu_{h,t}\left[
\phi_w W_{t+1}H_t^b
+(1-\phi_w)(Q_{t+1}^\psi+\Pi_{\psi,t+1})\Psi_t^b
\right].
\]

### 2.4 零售商

零售商在 Calvo 黏性价格下定价。可以重新定价的零售商选择 \(P_{k,t}^{\ast}\)：

**(F5) Retailer Calvo pricing problem**

\[
\max_{\{P_{k,t}^{\ast}\}} E_t\sum_{z=0}^{\infty}\theta_R^z\Lambda_{t,z}
\left[P_{k,t}^{\ast}Y_{k,t+z}-P_{j,t+z}^WXY_{k,t+z}\right],
\]

满足：

**(F6) Demand for a differentiated retail good**

\[
Y_{k,t+z}
=
\left(\frac{P_{k,t}^{\ast}}{P_{t+z}}\right)^{-\varepsilon_t^p}Y_{t+z}.
\]

### 2.5 企业家

企业家生产批发品，并选择资本、贷款和劳动：

**(F7) Entrepreneur objective**

\[
E_0\sum_{t=0}^{\infty}\beta_e^t\Omega_{j,t}^e.
\]

**(F8) Entrepreneur production technology**

\[
Y_{j,t}=\xi_{z,t}K_{j,t-1}^{\alpha}H_{j,t}^{1-\alpha}.
\]

**(F9) Entrepreneur flow of funds**

\[
\Omega_{j,t}^e
=
\frac{Y_{j,t}}{X_{j,t}}+\frac{L_{j,t}^e}{P_t}
-\frac{I_{j,t-1}^eL_{j,t-1}^e}{P_t}
-\frac{W_t}{P_t}H_{j,t}
-\left(K_{j,t}-(1-\delta_e)K_{j,t-1}\right)
-Adj_{j,t}^e-\Pi_{\psi,jt}^e.
\]

**(F10) Capital installation cost**

\[
Adj_{j,t}^e
=
\kappa_v\left(\frac{V_{j,t}}{K_{j,t-1}}-\delta_e\right)^2
\frac{K_{j,t-1}}{2\delta_e}.
\]

**(F11) Entrepreneur binding borrowing constraint**

\[
I_{j,t}^eL_{j,t}^e
=
\nu_{e,jt}\left[
\phi_kQ_{j,t+1}^kK_{j,t}
+(1-\phi_k)Q_{j,t+1}^{\psi}\Psi_j^e
\right].
\]

### 2.6 银行

批发分支选择贷款和存款：

**(F12) Wholesale bank objective**

\[
E_0\sum_{t=0}^{\infty}\beta_B^t
\left[
i_t^lL_t-i_t^dD_t
-\frac{\kappa_k}{2}\left(\frac{K_t^B}{L_t}-\tau\right)^2K_t^B
\right],
\]

满足：

**(F13) Bank balance sheet**

\[
L_t=K_t^B+D_t.
\]

零售贷款分支选择家庭贷款利率和企业家贷款利率：

**(F14) Retail loan branch objective**

\[
\max_{\{i_t^h,i_t^e\}} E_0\sum_{t=0}^{\infty}\beta_B^t
\left[
i_t^hL_t^h+i_t^eL_t^e-i_t^lL_t
-\frac{\kappa_h}{2}\left(\frac{i_t^h}{i_{t-1}^h}-1\right)^2i_t^hL_t^h
-\frac{\kappa_e}{2}\left(\frac{i_t^e}{i_{t-1}^e}-1\right)^2i_t^eL_t^e
\right].
\]

## 3. First-Order Conditions

记 \(\tilde C_t^\Gamma=C_t^\Gamma-\phi C_{t-1}^\Gamma\)，\(U_{c,t}^\Gamma=(\tilde C_t^\Gamma)^{-\gamma^\Gamma}\)。

**(F15) Saver deposit demand**

\[
\frac{P_t}{D_t^s}
=
U_{c,t}^s-\beta_sE_t\left[
U_{c,t+1}^s\frac{I_t^d}{P_{t+1}/P_t}
\right].
\]

**(F16) Saver labor supply**

\[
\frac{W_t}{P_t}=\frac{(H_t^s)^\eta}{U_{c,t}^s}.
\]

**(F17) Saver equity demand**

\[
\xi_{\psi,t}\frac{P_t}{Q_t^\psi\Psi_t^s}
=
U_{c,t}^s-\beta_sE_t\left[
U_{c,t+1}^s
\left(\frac{Q_{t+1}^{\psi}+\Pi_{\psi,t+1}}{Q_t^\psi}\right)
\frac{P_t}{P_{t+1}}
\right].
\]

**(F18) Saver consumption-based equity pricing relation**

\[
1=
\beta_sE_t\left[
\frac{U_{c,t}^s}{U_{c,t+1}^s}
\left(\frac{Q_{t+1}^{\psi}+\Pi_{\psi,t+1}}{Q_t^\psi}\right)
\frac{P_t}{P_{t+1}}
\right].
\]

**(F19) Borrower labor supply**

\[
(H_t^b)^\eta
=
U_{c,t}^b\frac{W_t}{P_t}
+\lambda_t^h\nu_{h,t}\phi_wE_t\left[\frac{W_{t+1}}{P_t}\right].
\]

**(F20) Borrower consumption Euler equation**

\[
U_{c,t}^b
=
\beta_bE_t\left[
U_{c,t+1}^b\frac{I_t^h}{P_{t+1}/P_t}
\right]+\lambda_t^hI_t^h.
\]

**(F21) Borrower equity demand**

\[
\xi_{\psi,t}\frac{P_t}{Q_t^\psi\Psi_t^b}
=
U_{c,t}^b
-E_t\left[
\beta_bU_{c,t+1}^b
\frac{R_{t+1}^{\psi}}{P_{t+1}/P_t}
+\lambda_t^h\nu_{h,t}(1-\phi_w)
\frac{R_{t+1}^{\psi}}{P_{t+1}/P_t}
\right].
\]

**(F22) Retail price index**

\[
P_t^{1-\varepsilon_t^p}
=
\theta_R
\left[\left(\frac{P_{t-1}}{P_{t-2}}\right)^{\gamma_p}P_{t-1}\right]^{1-\varepsilon_t^p}
+(1-\theta_R)(P_t^{\ast})^{1-\varepsilon_t^p}.
\]

**(F23) Retailer optimal reset price, needs_review**

\[
\frac{P_t^{\ast}}{P_t}
=
\left(\frac{\varepsilon_t^p}{\varepsilon_t^p-1}\right)
\frac{
E_t\sum_{z=0}^{\infty}\theta_R^z\Lambda_{t,z}
\left[\frac{X}{X_{t+z}}\left(\frac{P_{t+z}}{P_t}\right)^{\varepsilon_t^p}Y_{t+z}\right]
}{
E_t\sum_{z=0}^{\infty}\theta_R^z\Lambda_{t,z}
\left[\left(\frac{P_{t+z}}{P_t}\right)^{\varepsilon_t^p-1}Y_{t+z}\right]
}.
\]

**(F24) Entrepreneur labor demand**

\[
\frac{W_t}{P_t}=\frac{(1-\alpha)Y_{j,t}}{H_{j,t}X_{j,t}}.
\]

**(F25) Entrepreneur loan Euler equation**

\[
\lambda_{j,t}^e
=
\frac{1}{I_{j,t}^e}
-\beta_eE_t\left[\frac{P_t}{P_{t+1}}\right].
\]

**(F26) Entrepreneur capital demand, needs_review**

\[
\frac{Q_{j,t}^k}{P_t}
=
\beta_eE_t\left[
\frac{\kappa_v}{\delta_e}
\left(\frac{V_{j,t+1}}{K_{j,t}}-\delta_e\right)
\frac{V_{j,t+1}}{K_{j,t}}
-\frac{\kappa_v}{2\delta_e}
\left(\frac{V_{j,t+1}}{K_{j,t}}-\delta_e\right)^2
+\frac{Q_{j,t+1}^k}{P_{t+1}}(1-\delta_e)
+\frac{\alpha Y_{j,t+1}}{X_{j,t+1}K_{j,t}}
+\lambda_{j,t}^e\nu_{e,jt}\phi_k\frac{Q_{j,t+1}^k}{P_{t+1}}
\right].
\]

**(F27) Wholesale loan-deposit spread**

\[
i_t^l
=
i_t^d-\kappa_k\left(\frac{K_t^B}{L_t}-\tau\right)
\left(\frac{K_t^B}{L_t}\right)^2.
\]

**(F28) Entrepreneur retail loan-rate setting, needs_review**

\[
0=
1-\varepsilon_t^e+\varepsilon_t^e\frac{i_t^l}{i_t^e}
-\kappa_e\left(\frac{i_t^e}{i_{t-1}^e}-1\right)\frac{i_t^e}{i_{t-1}^e}
+\beta_BE_t\left[
\kappa_e\left(\frac{i_{t+1}^e}{i_t^e}-1\right)
\left(\frac{i_{t+1}^e}{i_t^e}\right)^2
\frac{L_{t+1}^e}{L_t^e}
\right].
\]

**(F29) Household retail loan-rate setting, needs_review**

\[
0=
1-\varepsilon_t^h+\varepsilon_t^h\frac{i_t^l}{i_t^h}
-\kappa_h\left(\frac{i_t^h}{i_{t-1}^h}-1\right)\frac{i_t^h}{i_{t-1}^h}
+\beta_BE_t\left[
\kappa_h\left(\frac{i_{t+1}^h}{i_t^h}-1\right)
\left(\frac{i_{t+1}^h}{i_t^h}\right)^2
\frac{L_{t+1}^h}{L_t^h}
\right].
\]

## 4. Market Clearing & Identities

**(F30) Aggregate production**

\[
Y_t=\xi_{z,t}K_{t-1}^{\alpha}H_t^{1-\alpha}.
\]

**(F31) Aggregate resource constraint**

\[
Y_t=C_t+V_t+\delta_B\frac{K_{t-1}^B}{\Pi_t}.
\]

**(F32) Equity market clearing**

\[
\Psi_t^s+\Psi_t^b=\Psi^B+\Psi^e.
\]

**(F33) Aggregate consumption**

\[
C_t=C_t^s+C_t^b.
\]

**(F34) Aggregate loans**

\[
L_t=L_t^h+L_t^e.
\]

**(F35) Aggregate labor, needs_review**

\[
H_t=H_t^h+H_t^e.
\]

附录写为 \(H_t^h+H_t^e\)，而正文使用储蓄/借款家庭劳动和企业家劳动需求。该加总式应对照 PDF 和实现文件复核。

**(F36) Capital accumulation**

\[
K_t=(1-\delta_e)K_{t-1}+V_t.
\]

**(F37) Capital shadow price, needs_review**

\[
\frac{Q_t^k}{P_t}
=
1+\frac{\kappa_v}{\delta_e}\left(\frac{V_t}{K_{t-1}}-\delta_e\right).
\]

**(F38) Equity dividend from entrepreneurs**

\[
\Pi_{\psi,t}^e=r^\psi Q_t^\psi\Psi^e.
\]

**(F39) Equity dividend from banks**

\[
\Pi_t^{\psi B}=\phi_\psi\omega_{B,t}.
\]

**(F40) Aggregate equity dividend, needs_review**

\[
\Pi_t^\psi=\frac{\Pi_t^{\psi e}}{\Psi^e}+\frac{\Pi_t^{\psi B}}{\Psi^B}.
\]

**(F41) Household borrowing constraint in equality form**

\[
L_t^h
=
\frac{\nu_{h,t}}{I_t^h}
\left[
\phi_wW_{t+1}H_t^b
+(1-\phi_w)(Q_{t+1}^{\psi}+\Pi_{t+1}^{\psi})\Psi_t^b
\right].
\]

**(F42) Entrepreneur borrowing constraint in equality form**

\[
L_t^e
=
\frac{\nu_{e,t}}{I_t^e}
\left[
\phi_kQ_{t+1}^kK_t
+(1-\phi_k)Q_{t+1}^{\psi}\Psi^e
\right].
\]

**(F43) Bank capital accumulation**

\[
K_t^B
=
(1-\delta_B)K_{t-1}^B
+\phi_B(Q_t^\psi-Q_{t-1}^{\psi})\Psi^B
+(1-\phi_\psi)\omega_{B,t-1}.
\]

**(F44) Bank balance sheet identity**

\[
L_t=K_t^B+D_t.
\]

**(F45) Saver flow of funds**

\[
C_t^s
=
\frac{W_t}{P_t}H_t^s+\frac{I_{t-1}^dD_{t-1}^s}{P_t}
+\frac{Q_t^\psi+\Pi_{\psi,t}}{P_t}\Psi_{t-1}^s
-\frac{D_t^s}{P_t}
-\frac{Q_t^\psi}{P_t}\Psi_t^s.
\]

**(F46) Bank profits**

\[
\begin{aligned}
\omega_{B,t}={}&i_t^hL_t^h+i_t^eL_t^e-i_t^dD_t
-\frac{\kappa_K}{2}\left(\frac{K_t^B}{L_t}-\tau\right)^2K_t^B \\
&-\frac{\kappa_h}{2}\left(\frac{i_t^h}{i_{t-1}^h}-1\right)^2i_t^hL_t^h
-\frac{\kappa_e}{2}\left(\frac{i_t^e}{i_{t-1}^e}-1\right)^2i_t^eL_t^e
-\Pi_t^{\psi B}.
\end{aligned}
\]

**(F47) Monetary policy rule**

\[
I_t
=
(I_{t-1})^{\kappa_i}
\left(\frac{\Pi_t}{\Pi^{target}}\right)^{\kappa_\pi(1-\kappa_i)}
\left(\frac{Y_t}{Y_{t-1}}\right)^{\kappa_y(1-\kappa_i)}
\xi_{i,t}.
\]

论文正文将政策冲击写为乘法形式；MMB 实现交叉检查将其对数线性化为加法形式。

## 5. Exogenous Processes

**(F48) Price markup process**

\[
\varepsilon_t^p=\rho_p\varepsilon_{t-1}^p+\epsilon_{p,t}.
\]

**(F49) Technology process**

\[
\xi_{z,t}=\rho_z\xi_{z,t-1}+\epsilon_{z,t}.
\]

**(F50) Monetary policy shock process, needs_review**

\[
\xi_{i,t}=\rho_i\xi_{i,t-1}+\epsilon_{i,t}.
\]

附录 A 的 OCR 在该式中显示 \(\rho_z\)；模型正文和实现文件指向 \(\rho_i\)。

**(F51) Deposit shock process**

\[
\xi_{d,t}=\rho_d\xi_{d,t-1}+\epsilon_{d,t}.
\]

**(F52) Household loan-markup process**

\[
\varepsilon_t^h=\rho_h\varepsilon_{t-1}^h+\epsilon_{h,t}.
\]

**(F53) Entrepreneur loan-markup process**

\[
\varepsilon_t^e=\rho_e\varepsilon_{t-1}^e+\epsilon_{e,t}.
\]

**(F54) Household LTV process**

\[
\nu_{h,t}=\rho_{\nu h}\nu_{h,t-1}+\epsilon_{\nu h,t}.
\]

**(F55) Entrepreneur LTV process**

\[
\nu_{e,t}=\rho_{\nu e}\nu_{e,t-1}+\epsilon_{\nu e,t}.
\]

**(F56) Equity demand shock process**

\[
\xi_{\psi,t}=\rho_{\psi}\xi_{\psi,t-1}+\epsilon_{\psi,t}.
\]

## 6. Steady-State Solution

论文估计的是线性化模型，并提供校准稳态比率，而不是完整的非线性闭式稳态算法。Rep-MMB 实现交叉检查使用 `model(linear)`，变换后模型变量稳态为零，并在观测方程中加入观测稳态偏移。

对论文侧非线性约束：

1. 令所有 AR(1) 创新为零，并使外生过程处于确定性均值。
2. 使用表 1 的校准稳态总利率和比率：\(\beta_s=0.99\)，\(\beta_b=0.96\)，\(\beta_e=0.95\)，\(\alpha=0.33\)，\(\delta_e=0.025\)，\(\varepsilon^p=11\)，\(R^\psi=1.035\)，\(\tau=0.11\)，\(L^h/L=0.45\)，\(L^e/L=0.55\)，\(L/Y=1.5\)，\(C/Y=0.653\)，以及 \(Q^\psi\Psi/Y=0.816\)。
3. 使用资产负债表恒等式 \(L=K^B+D\)、\(L=L^h+L^e\) 和总量约束确定比率。
4. 仅将实现交叉检查中的观测变量稳态偏移作为实现证据：`pi_ss`、`i_h_ss`、`i_e_ss` 和 `i_d_ss`。

`needs_review`：第一遍没有完成可供未来 `steady_state_model` 直接使用的非线性稳态求解顺序的来源级核查。

## 7. Timing & Form Conventions

- **资本时序**：\(K_t\) 是期末物质资本；生产使用 \(K_{t-1}\)。
- **银行资本时序**：\(K_t^B\) 取决于 \(K_{t-1}^B\)、从 \(t-1\) 到 \(t\) 的股票价格变化，以及滞后留存收益。
- **贷款**：借款者和企业家的借款约束绑定，并使用 \(t+1\) 期的预期/抵押价值。
- **股票供给**：总股票份额供给固定；家庭在储蓄型和借款型之间重新配置持有量。
- **价格**：Calvo 定价包含由参数 \(\gamma_p\) 控制的指数化。
- **形式**：论文侧均衡条件为非线性；MMB 实现交叉检查是对数线性 `model(linear)` 系统。
- **运行验证**：未执行；没有运行任何 Dynare 命令。

## 8. Variable & Parameter Reference Table

### 内生变量

| Category | Symbol | Meaning | Main determining equations |
|---|---|---|---|
| Endogenous | \(Y_t\) | 产出 | (F30), (F31) |
| Endogenous | \(C_t\) | 总消费 | (F33) |
| Endogenous | \(C_t^s\) | 储蓄者消费 | (F2), (F45) |
| Endogenous | \(C_t^b\) | 借款者消费 | (F3), (F20) |
| Endogenous | \(K_t\) | 企业家物质资本 | (F36), (F37) |
| Endogenous | \(H_t\) | 总劳动 | (F35) |
| Endogenous | \(H_t^s\) | 储蓄者劳动 | (F16) |
| Endogenous | \(H_t^b\) | 借款者劳动 | (F19) |
| Endogenous | \(V_t\) | 投资/资本积累流量 | (F31), (F36), (F37) |
| Endogenous | \(D_t\) | 存款 | (F13), (F15), (F44) |
| Endogenous | \(L_t\) | 总贷款 | (F34), (F44) |
| Endogenous | \(L_t^h\) | 家庭贷款 | (F41) |
| Endogenous | \(L_t^e\) | 企业家贷款 | (F42) |
| Endogenous | \(K_t^B\) | 银行资本 | (F43), (F44) |
| Endogenous | \(\Psi_t^s\) | 储蓄者股票持有 | (F17), (F32) |
| Endogenous | \(\Psi_t^b\) | 借款者股票持有 | (F21), (F32) |
| Endogenous | \(P_t\) | 总价格水平 | (F22) |
| Endogenous | \(P_t^{\ast}\) | 重设价格 | (F23) |
| Endogenous | \(Q_t^k\) | 物质资本价格 | (F26), (F37) |
| Endogenous | \(X_t\) | 零售加成 | (F23), (F24) |
| Endogenous | \(W_t\) | 名义工资 | (F16), (F19), (F24) |
| Endogenous | \(I_t\) | 政策利率 | (F47) |
| Endogenous | \(I_t^l\) | 批发贷款利率 | (F27) |
| Endogenous | \(I_t^h\) | 家庭贷款利率 | (F28), (F41) |
| Endogenous | \(I_t^e\) | 企业家贷款利率 | (F29), (F42) |
| Endogenous | \(Q_t^\psi\) | 股票价格 | (F17), (F21), (F43) |
| Endogenous | \(\Pi_{\psi,t}\) | 总股票股息 | (F40) |
| Endogenous | \(\Pi_{\psi,t}^e\) | 企业家股息 | (F38) |
| Endogenous | \(\Pi_{\psi,t}^B\) | 银行股息 | (F39) |
| Endogenous | \(\omega_{B,t}\) | 银行利润 | (F46) |
| Endogenous | \(\lambda_t^h\) | 家庭抵押约束乘子 | (F19), (F20), (F21) |
| Endogenous | \(\lambda_t^e\) | 企业家抵押约束乘子 | (F25), (F26) |

### 外生冲击

| Symbol | Meaning | Process |
|---|---|---|
| \(\epsilon_{p,t}\) | 价格加成创新 | (F48) |
| \(\epsilon_{z,t}\) | 技术创新 | (F49) |
| \(\epsilon_{i,t}\) | 货币政策创新 | (F50) |
| \(\epsilon_{d,t}\) | 存款创新 | (F51) |
| \(\epsilon_{h,t}\) | 家庭贷款加成创新 | (F52) |
| \(\epsilon_{e,t}\) | 企业家贷款加成创新 | (F53) |
| \(\epsilon_{\nu h,t}\) | 家庭 LTV 创新 | (F54) |
| \(\epsilon_{\nu e,t}\) | 企业家 LTV 创新 | (F55) |
| \(\epsilon_{\psi,t}\) | 股票需求创新 | (F56) |

### 主要参数

| Symbol | Meaning | Source notes |
|---|---|---|
| \(\beta_s,\beta_b,\beta_e\) | 储蓄者、借款者和企业家贴现因子 | 表 1 |
| \(\beta_B,\beta_R\) | 银行和零售商贴现因子 | 表 1 注释说明等于 \(\beta_s\) |
| \(\gamma^s,\gamma^b\) | 储蓄者和借款者风险规避 | 估计 |
| \(\phi\) | 习惯形成 | 估计 |
| \(\eta\) | Frisch 弹性倒数 | 表 1 |
| \(\alpha\) | 资本份额 | 表 1 |
| \(\delta_e\) | 物质资本折旧 | 表 1 |
| \(\kappa_v\) | 资本安装成本 | 表 1 |
| \(\theta_R,\gamma_p\) | Calvo 价格黏性和指数化 | 估计 |
| \(\varepsilon^p\) | 商品需求价格弹性 | 表 1 |
| \(R^\psi\) | 稳态股票收益 | 表 1 |
| \(\nu_h,\nu_e\) | 家庭和企业家 LTV 比率 | 估计 |
| \(\phi_w,\phi_k\) | 抵押品权重 | 估计 |
| \(\kappa_k,\kappa_h,\kappa_e\) | 银行资本和零售利率调整成本 | 估计 |
| \(\tau\) | 银行资本要求 | 表 1 |
| \(\delta_B\) | 银行资本管理沉没成本 | 表 1 |
| \(\phi_\psi,\phi_B\) | 银行股息份额和股票价格传导 | 表 1 / 估计 |
| \(\kappa_i,\kappa_\pi,\kappa_y\) | Taylor 规则系数 | 估计 |
| \(\rho_\cdot\) | AR(1) 持续性参数 | 表 3 |
