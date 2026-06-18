# EAUS_NAWM08 推导

> 私有模型存档的一轮草稿。公式状态：`needs_review`。本推导基于 Coenen、McAdam 和 Straub (2008) 的 MinerU Markdown；原始 PDF 路径已检查用于 provenance，但未读取 PDF 正文。`EAUS_NAWM08_rep.mod` 仅作为 `implementation_cross_check` 使用。

## 1. 模型概述

- **模型**：`EAUS_NAWM08`，校准的两国 New Area-Wide Model (NAWM)，覆盖欧元区和美国。
- **来源**：Coenen, Guenther; McAdam, Peter; Straub, Roland (2008), "Tax reform and labour-market performance in the euro area: A simulation-based analysis using the New Area-Wide Model", *Journal of Economic Dynamics & Control*, DOI `10.1016/j.jedc.2007.09.007`。
- **经济体**：两个规模不对称的国家。home block 是欧元区，foreign block 是美国/工业化世界其他部分。每个国家都有家庭、企业、财政当局和货币当局。
- **核心主体**：可进入资产市场的家庭 I、受限资产市场家庭 J、垄断竞争中间品企业、最终消费/投资/公共品企业、财政当局和 Taylor 规则货币当局。
- **关键机制**：外部习惯、货币交易成本、资本积累和利用率、两类家庭的 Calvo 工资设定、国内和出口市场的本币定价 Calvo 价格、进口调整成本、财政税楔、政府债务反馈和国际债券风险溢价。
- **模型形式**：非线性水平/相对价格 DSGE。MMB 实现求解非线性模型，并由 Dynare 用于随机模拟的一阶近似；本存档草稿不转换为 `model(linear)`。
- **范围约定**：下列方程写成无国家上标的通用国家块。外国有相同结构并带星号变量。国际出清条件连接两个国家块。

## 2. 主体的最优化问题

### 2.1 可进入资产市场的家庭 I

家庭成员 \(i \in [0,1-\omega]\) 选择消费、投资、下一期物质资本、资本利用率、国内债券、外国债券和货币：

$$
\max_{\{C_{i,t},I_{i,t},K_{i,t+1},u_{i,t},B_{i,t+1},B^F_{i,t+1},M_{i,t}\}}
E_t\sum_{k=0}^{\infty}\beta^k
\left[
\frac{(C_{i,t+k}-\kappa C_{I,t+k-1})^{1-\sigma}}{1-\sigma}
-\frac{N_{i,t+k}^{1+\zeta}}{1+\zeta}
\right].
$$

期间预算约束为：

$$
\begin{aligned}
&(1+\tau_t^C+\Gamma_v(v_{i,t}))P_{C,t}C_{i,t}+P_{I,t}I_{i,t}
+R_t^{-1}B_{i,t+1}
+((1-\Gamma_{B^F}(B_t^F))R_{F,t})^{-1}S_tB^F_{i,t+1}+M_{i,t}+\Xi_{i,t}+\Phi_{i,t} \\
&=(1-\tau_t^N-\tau_t^{W_h})W_{i,t}N_{i,t}
+(1-\tau_t^K)(R_{K,t}u_{i,t}-\Gamma_u(u_{i,t})P_{I,t})K_{i,t}
+\tau_t^K\delta P_{I,t}K_{i,t} \\
&\quad +(1-\tau_t^D)D_{i,t}+TR_{i,t}-T_{i,t}+B_{i,t}+S_tB^F_{i,t}+M_{i,t-1}.
\end{aligned}
$$

资本演化为：

$$
K_{i,t+1}=(1-\delta)K_{i,t}+\left(1-\Gamma_I(I_{i,t}/I_{i,t-1})\right)I_{i,t}.
$$

### 2.2 受限资产市场家庭 J

家庭成员 \(j \in (1-\omega,1]\) 有相同的期间效用，但只选择消费和货币，约束为：

$$
(1+\tau_t^C+\Gamma_v(v_{j,t}))P_{C,t}C_{j,t}+M_{j,t}
=(1-\tau_t^N-\tau_t^{W_h})W_{j,t}N_{j,t}+TR_{j,t}-T_{j,t}+M_{j,t-1}+\Phi_{j,t}.
$$

两类家庭都在 Calvo 合约下设定差异化工资。重设工资者选择 \(\widetilde W_{I,t}\) 或 \(\widetilde W_{J,t}\)，并把自身劳动品种需求视为给定。

### 2.3 中间品企业

每个垄断竞争中间品生产者在以下技术约束下最小化要素成本：

$$
Y_{f,t}=\max\left[z_t K_{f,t}^{\alpha}N_{f,t}^{1-\alpha}-\psi,0\right].
$$

企业租用资本服务和复合劳动，支付雇主工资税 \(\tau_t^{W_f}\)，并在 Calvo 本币定价下设定国内价格和出口价格。

### 2.4 最终品企业

最终消费品和投资品是国内与进口中间品束的 CES 组合，并有进口调整成本。公共消费品是国内中间品束。最终品企业在 CES 技术约束下最小化投入成本。

## 3. 一阶条件（FOC）

### 家庭 I

- **(F1) 消费边际效用**：

$$
\Lambda_{i,t}=
\frac{(C_{i,t}-\kappa C_{I,t-1})^{-\sigma}}
{1+\tau_t^C+\Gamma_v(v_{i,t})+\Gamma_v'(v_{i,t})v_{i,t}}.
$$

- **(F2) 投资 FOC / Tobin's Q**：

$$
\frac{P_{I,t}}{P_{C,t}}
=Q_{i,t}\left[1-\Gamma_I(s_{i,t})-\Gamma_I'(s_{i,t})I_{i,t}\right]
+\beta E_t\left[
\frac{\Lambda_{i,t+1}}{\Lambda_{i,t}}Q_{i,t+1}\Gamma_I'(s_{i,t+1})
\frac{I_{i,t+1}^2}{I_{i,t}}
\right],
\quad s_{i,t}=\frac{I_{i,t}}{I_{i,t-1}}.
$$

来源公式由 MinerU 转写，导数记号较紧凑，应复核；`needs_review`。

- **(F3) 资本 Euler 方程**：

$$
Q_{i,t}=\beta E_t\left[
\frac{\Lambda_{i,t+1}}{\Lambda_{i,t}}
\left(
(1-\delta)Q_{i,t+1}
+(1-\tau_{t+1}^K)\frac{R_{K,t+1}}{P_{C,t+1}}u_{i,t+1}
+(\tau_{t+1}^K\delta-(1-\tau_{t+1}^K)\Gamma_u(u_{i,t+1}))
\frac{P_{I,t+1}}{P_{C,t+1}}
\right)\right].
$$

- **(F4) 资本利用率 FOC**：

$$
R_{K,t}=\Gamma_u'(u_{i,t})P_{I,t}.
$$

- **(F5) 国内债券 Euler 方程**：

$$
\beta R_t E_t\left[
\frac{\Lambda_{i,t+1}}{\Lambda_{i,t}}
\frac{P_{C,t}}{P_{C,t+1}}
\right]=1.
$$

- **(F6) 含风险溢价的外国债券 Euler 方程**：

$$
\beta(1-\Gamma_{B^F}(B_t^F))R_{F,t}E_t\left[
\frac{\Lambda_{i,t+1}}{\Lambda_{i,t}}
\frac{P_{C,t}}{P_{C,t+1}}\frac{S_{t+1}}{S_t}
\right]=1.
$$

- **(F7) 货币 FOC**：

$$
\beta E_t\left[
\frac{\Lambda_{i,t+1}}{\Lambda_{i,t}}
\frac{P_{C,t}}{P_{C,t+1}}
\right]=1-\Gamma_v'(v_{i,t})v_{i,t}^2.
$$

- **(F8) 家庭 I 重设工资 FOC**：

$$
E_t\sum_{k=0}^{\infty}(\xi_I\beta)^k
\left[
\Lambda_{i,t+k}(1-\tau_{t+k}^N-\tau_{t+k}^{W_h})
\frac{\widetilde W_{I,t}}{P_{C,t+k}}
\left(\frac{P_{C,t+k-1}}{P_{C,t-1}}\right)^{\chi_I}
\pi_C^{(1-\chi_I)k}
-\frac{\eta_I}{\eta_I-1}N_{i,t+k}^{\zeta}
\right]N_{i,t+k}=0.
$$

该紧凑无限和公式来自论文；实现文件用递归辅助变量 \(F_I,G_I\) 改写。

- **(F9) 家庭 I 工资指数化**：

$$
W_{I,t}=\left[
(1-\xi_I)\widetilde W_{I,t}^{1-\eta_I}
+\xi_I\left(\left(\frac{P_{C,t-1}}{P_{C,t-2}}\right)^{\chi_I}
\pi_C^{1-\chi_I}W_{I,t-1}\right)^{1-\eta_I}
\right]^{1/(1-\eta_I)}.
$$

### 家庭 J

- **(F10) 家庭 J 预算约束**：

$$
(1+\tau_t^C+\Gamma_v(v_{j,t}))P_{C,t}C_{j,t}+M_{j,t}
=(1-\tau_t^N-\tau_t^{W_h})W_{j,t}N_{j,t}+TR_{j,t}-T_{j,t}+M_{j,t-1}+\Phi_{j,t}.
$$

- **(F11) 家庭 J 消费边际效用**：

$$
\Lambda_{j,t}=
\frac{(C_{j,t}-\kappa C_{J,t-1})^{-\sigma}}
{1+\tau_t^C+\Gamma_v(v_{j,t})+\Gamma_v'(v_{j,t})v_{j,t}}.
$$

- **(F12) 家庭 J 货币 FOC**：

$$
\beta E_t\left[
\frac{\Lambda_{j,t+1}}{\Lambda_{j,t}}
\frac{P_{C,t}}{P_{C,t+1}}
\right]=1-\Gamma_v'(v_{j,t})v_{j,t}^2.
$$

- **(F13) 家庭 J 重设工资 FOC**：

$$
E_t\sum_{k=0}^{\infty}(\xi_J\beta)^k
\left[
\Lambda_{j,t+k}(1-\tau_{t+k}^N-\tau_{t+k}^{W_h})
\frac{\widetilde W_{J,t}}{P_{C,t+k}}
\left(\frac{P_{C,t+k-1}}{P_{C,t-1}}\right)^{\chi_J}
\pi_C^{(1-\chi_J)k}
-\frac{\eta_J}{\eta_J-1}N_{j,t+k}^{\zeta}
\right]N_{j,t+k}=0.
$$

- **(F14) 家庭 J 工资指数化**：

$$
W_{J,t}=\left[
(1-\xi_J)\widetilde W_{J,t}^{1-\eta_J}
+\xi_J\left(\left(\frac{P_{C,t-1}}{P_{C,t-2}}\right)^{\chi_J}
\pi_C^{1-\chi_J}W_{J,t-1}\right)^{1-\eta_J}
\right]^{1/(1-\eta_J)}.
$$

### 中间品企业

- **(F15) 生产函数**：

$$
Y_{f,t}=z_tK_{f,t}^{\alpha}N_{f,t}^{1-\alpha}-\psi.
$$

- **(F16) 资本需求条件**：

$$
R_{K,t}=\alpha\frac{Y_{f,t}+\psi}{K_{f,t}}MC_t.
$$

- **(F17) 边际成本**：

$$
MC_t=\frac{1}{z_t\alpha^{\alpha}(1-\alpha)^{1-\alpha}}
(R_{K,t})^{\alpha}\left((1+\tau_t^{W_f})W_t\right)^{1-\alpha}.
$$

- **(F18) 复合劳动聚合器**：

$$
N_{f,t}=\left[
(1-\omega)^{1/\eta}(N_{f,t}^I)^{1-1/\eta}
+\omega^{1/\eta}(N_{f,t}^J)^{1-1/\eta}
\right]^{\eta/(\eta-1)}.
$$

- **(F19) 家庭类型劳动需求**：

$$
N_{f,t}^I=(1-\omega)\left(\frac{W_{I,t}}{W_t}\right)^{-\eta}N_{f,t},
\quad
N_{f,t}^J=\omega\left(\frac{W_{J,t}}{W_t}\right)^{-\eta}N_{f,t}.
$$

- **(F20) 国内价格重设 FOC**：

$$
E_t\sum_{k=0}^{\infty}\xi_H^k\Lambda_{I,t,t+k}
\left[
\widetilde P_{H,t}
\left(\frac{P_{H,t+k-1}}{P_{H,t-1}}\right)^{\chi_H}\pi_H^{(1-\chi_H)k}
-\frac{\theta}{\theta-1}MC_{t+k}
\right]H_{f,t+k}=0.
$$

- **(F21) 国内价格指数**：

$$
P_{H,t}=\left[
(1-\xi_H)\widetilde P_{H,t}^{1-\theta}
+\xi_H\left(\left(\frac{P_{H,t-1}}{P_{H,t-2}}\right)^{\chi_H}
\pi_H^{1-\chi_H}P_{H,t-1}\right)^{1-\theta}
\right]^{1/(1-\theta)}.
$$

- **(F22) 出口价格重设 FOC**：

$$
E_t\sum_{k=0}^{\infty}\xi_X^k\Lambda_{I,t,t+k}
\left[
\widetilde P_{X,t}
\left(\frac{P_{X,t+k-1}}{P_{X,t-1}}\right)^{\chi_X}\pi_X^{(1-\chi_X)k}
-\frac{\theta}{\theta-1}\frac{MC_{t+k}}{S_{t+k}}
\right]X_{f,t+k}=0.
$$

出口价格式是 (F20) 的来源陈述类比；其精确折现和币种换算应对照 PDF 或实现辅助变量复核；`needs_review`。

### 最终品企业

- **(F23) 消费品 CES 技术**：

$$
Q_t^C=\left[
\nu_C^{1/\mu_C}(H_t^C)^{1-1/\mu_C}
+(1-\nu_C)^{1/\mu_C}
\left((1-\Gamma_{IM^C}(IM_t^C/Q_t^C))IM_t^C\right)^{1-1/\mu_C}
\right]^{\mu_C/(\mu_C-1)}.
$$

- **(F24) 消费品国内投入需求**：

$$
H_t^C=\nu_C\left(\frac{P_{H,t}}{P_{C,t}}\right)^{-\mu_C}Q_t^C.
$$

- **(F25) 消费品进口需求**：

$$
IM_t^C=(1-\nu_C)
\left(\frac{P_{IM,t}}{P_{C,t}\Gamma_{IM^C,t}^{\dagger}}\right)^{-\mu_C}
\frac{Q_t^C}{1-\Gamma_{IM^C}(IM_t^C/Q_t^C)}.
$$

来源中 \(\Gamma^\dagger\) 定义附近 OCR 损坏；`needs_review`。

- **(F26) 消费品价格指数**：

$$
P_{C,t}=\left[
\nu_C P_{H,t}^{1-\mu_C}
+(1-\nu_C)\left(\frac{P_{IM,t}}{\Gamma_{IM^C,t}^{\dagger}}\right)^{1-\mu_C}
\right]^{1/(1-\mu_C)}.
$$

- **(F27) 投资品 CES 技术**：

$$
Q_t^I=\left[
\nu_I^{1/\mu_I}(H_t^I)^{1-1/\mu_I}
+(1-\nu_I)^{1/\mu_I}
\left((1-\Gamma_{IM^I}(IM_t^I/Q_t^I))IM_t^I\right)^{1-1/\mu_I}
\right]^{\mu_I/(\mu_I-1)}.
$$

- **(F28) 投资品价格和需求系统**：

$$
H_t^I=\nu_I\left(\frac{P_{H,t}}{P_{I,t}}\right)^{-\mu_I}Q_t^I,
\quad
P_{I,t}=\left[
\nu_I P_{H,t}^{1-\mu_I}
+(1-\nu_I)\left(\frac{P_{IM,t}}{\Gamma_{IM^I,t}^{\dagger}}\right)^{1-\mu_I}
\right]^{1/(1-\mu_I)}.
$$

投资品的进口需求伴随式与 (F25) 类似，如提升到可运行代码需复核；`needs_review`。

## 4. 市场出清与总量恒等式

- **(F29) 人均聚合**：

$$
X_t=(1-\omega)X_{i,t}+\omega X_{j,t}.
$$

- **(F30) 总资本和总投资**：

$$
K_t=(1-\omega)K_{i,t},\quad I_t=(1-\omega)I_{i,t},\quad M_t=(1-\omega)M_{i,t}+\omega M_{j,t}.
$$

- **(F31) 公共品和中间品需求聚合**：

$$
H_t=H_t^C+H_t^I+G_t,\quad IM_t=IM_t^C+IM_t^I.
$$

- **(F32) 总资源约束**：

$$
\begin{aligned}
P_{Y,t}Y_t
&=P_{C,t}(C_t+\Gamma_{v,t})
+P_{I,t}(I_t+\Gamma_u(u_t)K_t)
+P_{G,t}G_t+S_tP_{X,t}X_t \\
&\quad -P_{IM,t}\left[
IM_t^C\frac{1-\Gamma_{IM^C}(IM_t^C/Q_t^C)}
{\Gamma_{IM^C}^{\dagger}(IM_t^C/Q_t^C)}
+IM_t^I\frac{1-\Gamma_{IM^I}(IM_t^I/Q_t^I)}
{\Gamma_{IM^I}^{\dagger}(IM_t^I/Q_t^I)}
\right].
\end{aligned}
$$

OCR 对交易/进口成本的 \(T\) 和 \(\Gamma\) 使用不一致；公式需来源级复核。

- **(F33) 财政当局预算约束**：

$$
\begin{aligned}
P_{G,t}G_t+TR_t+B_t+M_{t-1}
&=\tau_t^CP_{C,t}C_t
+(\tau_t^N+\tau_t^{W_h})(W_{I,t}N_{t}^I+W_{J,t}N_t^J)
+\tau_t^{W_f}W_tN_t \\
&\quad+\tau_t^K(R_{K,t}u_t-(\Gamma_u(u_t)+\delta)P_{I,t})K_t
+\tau_t^DD_t+T_t+R_t^{-1}B_{t+1}+M_t.
\end{aligned}
$$

- **(F34) 一次总付税反馈规则**：

$$
\tau_t=\phi_{B_Y}\left(\frac{B_t}{P_YY}-B_Y\right).
$$

- **(F35) 货币政策规则**：

$$
R_t^4=\phi_RR_{t-1}^4+(1-\phi_R)
\left[R^4+\phi_{\Pi}\left(\frac{P_{C,t}}{P_{C,t-4}}-\Pi\right)\right]
+\phi_{g_Y}\left(\frac{Y_t}{Y_{t-1}}-g_Y\right)+\varepsilon_{R,t}.
$$

- **(F36) 净外国资产运动方程**：

$$
R_{F,t}^{-1}B_{t+1}^F=B_t^F+\frac{TB_t}{S_t},
\quad
TB_t=S_tP_{X,t}X_t-P_{IM,t}IM_t.
$$

- **(F37) 世界外国债券出清**：

$$
sB_t^F+(1-s)B_t^{F,\ast}=0.
$$

## 5. 外生过程

- **(F38) 全要素生产率**：

$$
\log z_t=(1-\rho_z)\log z+\rho_z\log z_{t-1}+\varepsilon_{z,t}.
$$

- **(F39) 财政和税率过程**：

$$
x_t=(1-\rho_x)\bar x+\rho_xx_{t-1}+\varepsilon_{x,t},
\quad
x_t\in\{g_t,tr_t,\tau_t^C,\tau_t^D,\tau_t^K,\tau_t^N,\tau_t^{W_h},\tau_t^{W_f}\}.
$$

已发表文章说明扭曲性税率在未另行说明时为常数，而 MMB 实现为每个税率包含 AR(1) 冲击过程，作为实现覆盖面记录。

## 6. 稳态求解

模型围绕非随机稳态的正水平值校准。本一轮存档没有重建完整解析 `steady_state_model`；状态为 `needs_review`。

从来源和交叉检查记录的稳态限制：

- 创新项为零，\(z=\bar z=1\)。
- 年化总通胀目标为 \(\Pi=1.02\)；季度消费价格通胀与 \(\Pi^{1/4}\) 一致。
- 均衡总政策利率满足 \(R^4=\beta^{-4}\Pi\)。
- 稳态进口和投资调整成本为零：\(\Gamma_I(1)=0\)、\(\Gamma_{IM^C}=0\)、\(\Gamma_{IM^I}=0\)。
- 资本利用率标准化为 \(u=1\)；\(\Gamma_u(1)=0\)，且 \(\Gamma_u'(1)\) 锚定稳态资本租赁率。
- 由国际交易成本设定和世界债券出清，世界净外国资产为零。
- 公共支出、转移、进口、消费、投资、政府债务和货币按 Appendix B 中的稳态比率校准。
- 固定成本 \(\psi\) 被选择以支持稳态零利润。
- 欧元区和美国的国家特定稳态比率不同；MMB 文件分别初始化国家块。

## 7. 时序与形式约定

- 推导为非线性并使用时间下标，不使用 Dynare `(+1)` 语法。
- 家庭 I 在日期 \(t\) 选择 \(K_{i,t+1}\)。MMB 实现把资本存量作为 predetermined stock，并用滞后投资和滞后资本写资本积累。
- 论文中的债券在日期 \(t\) 预算约束中写为下一期持有 \(B_{t+1}\) 和 \(B^F_{t+1}\)。实现将其映射为带滞后收益的当前存量变量。
- 从 \(t-1\) 带入的货币进入当前预算约束；实现中的政府预算约束有时序移动，在代码提升前应复核。
- 价格以水平和相对价格指数表示。消费价格通胀、国内品通胀、进口价格通胀和年化 CPI 通胀互不相同。
- 国家块结构对称但校准不同：`EA_` 和 `US_` 变量有不同的 home bias、税率、货币需求、转移和贸易比率校准。
- 未执行 runtime validation。未运行 Dynare。

## 8. 变量与参数对照表

| 类别 | 符号 / 实现名 | 含义 | 主要方程 |
|---|---|---|---|
| 内生变量 | \(C_I,C_J,C,I\) / `EA_CI`, `EA_CJ`, `EA_C`, `EA_I` | 家庭和总消费/投资 | (F1)-(F3), (F10)-(F12), (F29)-(F30) |
| 内生变量 | \(K,u,Q,R_K\) / `EA_K`, `EA_U`, `EA_Q`, `EA_RK` | 资本、利用率、Tobin's Q、租赁率 | (F3)-(F4), (F16), (F30) |
| 内生变量 | \(M,v,\Gamma_v,\Lambda\) / `EA_M`, `EA_VI`, `EA_VJ`, `EA_LAMBDAI`, `EA_LAMBDAJ` | 货币、velocity、交易成本、边际效用 | (F1), (F7), (F11), (F12), (F29)-(F30) |
| 内生变量 | \(W_I,W_J,\widetilde W_I,\widetilde W_J,N_I,N_J,N\) / `EA_WI`, `EA_WJ`, `EA_WITILDE`, `EA_WJTILDE`, `EA_NDI`, `EA_NDJ`, `EA_ND` | 工资设定和劳动需求 | (F8)-(F9), (F13)-(F14), (F18)-(F19) |
| 内生变量 | \(Y,Y_s,MC,D\) / `EA_Y`, `EA_YS`, `EA_MC`, `EA_D` | 产出、供给、边际成本、红利 | (F15)-(F17), (F32) |
| 内生变量 | \(P_H,\widetilde P_H,P_X,\widetilde P_X\) / `EA_PH`, `EA_PHTILDE`, `US_PIM`, `US_PIMTILDE` | 本币定价 | (F20)-(F22) |
| 内生变量 | \(Q^C,Q^I,H^C,H^I,IM^C,IM^I,P_C,P_I,P_{IM}\) / `EA_QC`, `EA_QI`, `EA_HC`, `EA_HI`, `EA_IMC`, `EA_IMI`, `EA_PIC`, `EA_PI`, `EA_PIM` | 最终品生产和价格指数 | (F23)-(F28), (F31)-(F32) |
| 内生变量 | \(G,TR,T,B,B^F,TB,ToT,R,S\) / `EA_G`, `EA_TR`, `EA_T`, `EA_B`, `EA_BF`, `EA_TB`, `EA_TOT`, `EA_R`, `EA_RER` | 财政、外部和货币变量 | (F33)-(F37) |
| 外生冲击 | \(\varepsilon_z,\varepsilon_R,\varepsilon_g,\varepsilon_{tr},\varepsilon_{\tau^C},\varepsilon_{\tau^D},\varepsilon_{\tau^K},\varepsilon_{\tau^N},\varepsilon_{\tau^{W_h}},\varepsilon_{\tau^{W_f}}\) / `EA_EPSZ`, `EA_EPSR`, `EA_EPSG`, `EA_EPSTR`, tax shocks | 生产率、政策、财政和税率冲击 | (F35), (F38)-(F39) |
| 参数 | \(\beta,\sigma,\kappa,\zeta,\delta,\omega,\alpha,\psi\) | 偏好、折旧、家庭份额、生产 | (F1)-(F19) |
| 参数 | \(\xi_I,\xi_J,\chi_I,\chi_J,\eta,\eta_I,\eta_J\) | 工资黏性、工资指数化、劳动替代 | (F8)-(F14), (F18)-(F19) |
| 参数 | \(\xi_H,\xi_X,\chi_H,\chi_X,\theta,\nu_C,\nu_I,\mu_C,\mu_I\) | 价格黏性、价格指数化、最终品 CES 参数 | (F20)-(F28) |
| 参数 | \(\gamma_v,\gamma_u,\gamma_I,\gamma_{IM^C},\gamma_{IM^I},\gamma_{B^F}\) | 交易、利用率、投资、进口和国际债券成本 | (F1)-(F7), (F23)-(F28), (F36) |
| 参数 | \(\tau^C,\tau^D,\tau^K,\tau^N,\tau^{W_h},\tau^{W_f},B_Y,\phi_{B_Y},\phi_R,\phi_{\Pi},\phi_{g_Y},s\) | 税率、财政反馈、货币规则、国家规模 | (F1)-(F7), (F33)-(F39) |
