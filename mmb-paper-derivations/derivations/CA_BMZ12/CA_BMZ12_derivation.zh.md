# CA_BMZ12 -- 推导（最优化问题 + 一阶条件）

> 私有模型档案的一遍草稿，供后续审查。公式状态：`needs_review`；方程来自 MinerU Markdown，并仅用 Rep-MMB 实现文件交叉检查覆盖范围和命名，不把实现文件当作论文侧数学来源。

## 1. Model Overview

- **模型 ID**：`CA_BMZ12`。
- **来源论文**：Bailliu, Jeannine; Zhang, Yahong; Meh, Cesaire A. (2012/2015), "Macroprudential rules and monetary policy when financial frictions matter," Bank of Canada Working Paper 2012-6 / *Economic Modelling*。MMB 索引记录的 DOI 为 `10.1016/j.econmod.2015.06.012`。
- **主要来源**：`raw/mmb_mineru/runs/ca_bmz12__macroprudential_rules_and_monetary_policy_when_financial_frictions_matte__aa2f7a66/full.md`；原始 PDF 路径存在于 `raw/mmb_papers/Macroprudential rules and monetary policy when financial frictions matter.pdf`。
- **主体**：代表性家庭、带 Bernanke-Gertler-Gilchrist 金融摩擦的企业家、资本品生产者、Calvo 垄断竞争零售商、货币当局，以及宏观审慎当局/工具。
- **实验**：使用加拿大数据估计的 DSGE 模型，用于比较标准 Taylor、扩展 Taylor、宏观审慎、以及扩展宏观审慎制度在金融冲击和技术冲击下的表现。
- **模型形式**：包含 Calvo 定价、金融加速器和外生冲击过程的非线性 DSGE 方程。可用的 Rep-MMB 文件实现为非线性 `model` 块并使用一阶随机模拟；本推导不运行 Dynare。
- **一遍状态**：`needs_review`。论文 Markdown 大体可读，但 Calvo 随机贴现因子、零售商 FOC、企业家净值中的工资收入项存在 OCR 瑕疵，推广前应对 PDF 做定点核查。

## 2. Optimization Problems

### 2.1 家庭

代表性家庭选择消费、工时和存款以最大化预期效用：

$$
\max_{\{C_t,H_t,D_t\}} E_0 \sum_{t=0}^{\infty} \beta^t
\left(e_t \log C_t - \theta \frac{H_t^{1+\gamma}}{1+\gamma}\right)
$$

并满足名义存款预算约束：

$$
C_t + \frac{D_t}{P_t}
= \frac{W_t}{P_t}H_t + \Pi_t + \frac{R_{t-1}^n D_{t-1}}{P_t}.
$$

### 2.2 企业家

企业家 \(j\) 使用上一期购入的资本和复合劳动生产同质中间品：

$$
F(K_t^j,L_t^j)=\omega_t^j (K_t^j)^\alpha (z_t L_t^j)^{1-\alpha}.
$$

复合劳动由家庭劳动和企业家劳动组成：

$$
L_t^j=(H_t^j)^{1-\Omega}(H_t^{ej})^\Omega.
$$

期末 \(t\) 购入资本的资产负债表约束为：

$$
Q_t K_{t+1}^j = N_{t+1}^j + \frac{B_t^j}{P_t}.
$$

金融摩擦来自 costly-state-verification 合约。外部融资溢价是杠杆率的递增函数，并受到金融冲击移动。在包含宏观审慎工具的政策制度中，它还乘以 \(\tau_t\)。

### 2.3 资本品生产者

资本品生产者用最终品、投资特定效率 \(x_t\) 和二次安装成本生产已安装资本。论文中的当期目标为：

$$
\Pi_t^k = E_t\left[
Q_t x_t I_t - I_t - \frac{\xi}{2}\left(\frac{I_t}{K_t}-\delta\right)^2 K_t
\right].
$$

### 2.4 零售商

垄断竞争零售商购买中间品、无成本差异化，并面对 CES 最终品需求。零售商 \(j\) 在 Calvo 定价下，在价格保持不变的期间最大化预期实际利润：

$$
E_t \sum_{i=0}^{\infty} \nu^i \Delta_{i,t+i}
\left[
\left(\frac{P_{jt}}{P_{t+i}}\right)Y_{j,t+i}
- mc_{t+i}Y_{j,t+i}
\right].
$$

`needs_review`：Markdown 对 \(\Delta_{i,t+i}\) 和零售商 FOC 的 OCR 存在畸形下标；在把精确递归形式视作最终版本前应对 PDF 核查。

## 3. First-Order Conditions

- **(F1) 家庭 Euler 方程**：

$$
\frac{e_t}{C_t}\frac{1}{R_t^n}
= \beta E_t\left[\frac{e_{t+1}}{C_{t+1}}\frac{P_t}{P_{t+1}}\right].
$$

- **(F2) 家庭劳动供给**：

$$
\frac{e_t}{C_t}\frac{W_t}{P_t} = \theta H_t^\gamma.
$$

- **(F3) 企业家生产函数**：

$$
Y_t^W = F(K_t,L_t)=K_t^\alpha(z_t L_t)^{1-\alpha}.
$$

- **(F4) 劳动聚合器**：

$$
L_t=(H_t)^{1-\Omega}(H_t^e)^\Omega.
$$

- **(F5) 家庭劳动需求条件**：

$$
(1-\Omega)F_{H_t}=\frac{W_t}{P_{W,t}}.
$$

- **(F6) 企业家劳动需求条件**：

$$
\Omega F_{H_t^e}=\frac{W_t^e}{P_{W,t}}.
$$

- **(F7) 企业家资产负债表**：

$$
Q_tK_{t+1}=N_{t+1}+\frac{B_t}{P_t}.
$$

- **(F8) 外部融资溢价定义**：

$$
s_t=\frac{E_tR_{t+1}^k}{E_t\left[R_t^n\frac{P_t}{P_{t+1}}\right]}.
$$

- **(F9) 带金融冲击的杠杆溢价**：

$$
s_t=f_t\,s\left(\frac{Q_tK_{t+1}}{N_{t+1}}\right).
$$

- **(F10) 资本套利条件**：

$$
E_tR_{t+1}^k=s_t R_t^n E_t\left[\frac{P_t}{P_{t+1}}\right].
$$

- **(F11) 资本预期总收益率**：

$$
E_tR_{t+1}^k
=E_t\left[
\frac{\frac{P_{t+1}^W}{P_{t+1}}F_K+Q_{t+1}(1-\delta)}{Q_t}
\right].
$$

- **(F12) 企业家净值**（工资收入项 OCR `needs_review`）：

$$
\begin{aligned}
N_{t+1}
=&\ \eta\left[
R_t^k Q_{t-1}K_t
- E_{t-1}(R_t^k)(Q_{t-1}K_t-N_t)
\right] \\
&+ (1-\alpha)(1-\Omega)z_tK_t^\alpha L_t^{(1-\alpha)\Omega}.
\end{aligned}
$$

- **(F13) 代入名义债务偿还后的净值**（`needs_review`）：

$$
\begin{aligned}
N_{t+1}
=&\ \eta\left[
R_t^k Q_{t-1}K_t
- s_{t-1}R_{t-1}^n E_{t-1}\left(\frac{P_{t-1}}{P_t}\right)(Q_{t-1}K_t-N_t)
\right] \\
&+ (1-\alpha)(1-\Omega)z_tK_t^\alpha L_t^{(1-\alpha)\Omega}.
\end{aligned}
$$

- **(F14) 退出企业家的消费**：

$$
C_t^e=(1-\eta)\left[
R_t^kQ_{t-1}K_t
-E_{t-1}(R_t^k)(Q_{t-1}K_t-N_t)
\right].
$$

- **(F15) 资本积累**：

$$
K_{t+1}=x_tI_t+(1-\delta)K_t.
$$

- **(F16) 资本品生产者 FOC / Tobin's \(Q\)**：

$$
E_t\left[
Q_t x_t - 1 - \xi\left(\frac{I_t}{K_t}-\delta\right)
\right]=0.
$$

- **(F17) 最终品 CES 聚合器**：

$$
Y_t=\left[\int_0^1 Y_{jt}^{\frac{\varepsilon-1}{\varepsilon}}dj\right]^{\frac{\varepsilon}{\varepsilon-1}}.
$$

- **(F18) 最终品价格指数**（`needs_review`：Markdown 写作 \(dz\)，预期应为 \(dj\)）：

$$
P_t=\left[\int_0^1 P_t(j)^{1-\varepsilon}dj\right]^{\frac{1}{1-\varepsilon}}.
$$

- **(F19) 零售品需求**：

$$
Y_{jt}=\left(\frac{P_{jt}}{P_t}\right)^{-\varepsilon}Y_t.
$$

- **(F20) 最优重置价格**（\(mc\)、时间下标和贴现因子附近 OCR `needs_review`）：

$$
P_t^{\ast}=\left(\frac{\varepsilon}{\varepsilon-1}\right)
\frac{
E_t\sum_{i=0}^{\infty}\nu^i\Delta_{i,t+i}mc_{t+i}Y_{t+i}
\left(\frac{1}{P_{t+i}}\right)^{-\varepsilon}
}{
E_t\sum_{i=0}^{\infty}\nu^i\Delta_{i,t+i}Y_{t+i}
\left(\frac{1}{P_{t+i}}\right)^{1-\varepsilon}
}.
$$

- **(F21) Calvo 调价下的总价格指数**：

$$
P_t=\left[\nu P_{t-1}^{1-\varepsilon}+(1-\nu)(P_t^{\ast})^{1-\varepsilon}\right]^{\frac{1}{1-\varepsilon}}.
$$

## 4. Market Clearing & Identities

- **(F22) 基本最终品资源约束**：

$$
K_t^\alpha(z_tL_t)^{1-\alpha}
=C_t+C_t^e+I_t+\frac{\xi}{2}\left(\frac{I_t}{K_t}-\delta\right)^2K_t.
$$

- **(F23) 带价格分散的企业层面资源条件**：

$$
F(K_{jt},L_{jt})
=\left(C_t+C_t^e+I_t+\frac{\xi}{2}\left(\frac{I_t}{K_t}-\delta\right)^2K_t\right)
\left(\frac{P_{jt}}{P_t}\right)^{-\varepsilon}.
$$

- **(F24) 带分散项的总生产/资源条件**：

$$
F(K_t,L_t)
=\left(C_t+C_t^e+I_t+\frac{\xi}{2}\left(\frac{I_t}{K_t}-\delta\right)^2K_t\right)\Gamma_t.
$$

- **(F25) 价格分散运动方程**（`needs_review`：Markdown 在 \(\Gamma_t\) 的积分定义中遗漏了价格比）：

$$
\Gamma_t=(1-\nu)\left(\frac{P_t^{\ast}}{P_t}\right)^{-\varepsilon}
+\nu \pi_t^\varepsilon \Gamma_{t-1}.
$$

- **(F26) 存款-债务出清**：

$$
D_t=B_t.
$$

- **(F27) 名义信贷增长**：

$$
cg_t=\frac{B_t}{B_{t-1}}.
$$

- **(F28) 扩展 Taylor 规则**：

$$
\frac{R_t^n}{R^n}
=\left(\frac{R_{t-1}^n}{R^n}\right)^{\phi_R}
\left[
\left(\frac{\pi_t}{\pi}\right)^{\phi_\pi}
\left(\frac{Y_t}{Y}\right)^{\phi_Y}
\left(\frac{cg_t}{cg_{ss}}\right)^{\phi_c}
\right]^{1-\phi_R}
e^{\epsilon_t^m}.
$$

- **(F29) 标准 Taylor 规则**：

$$
\frac{R_t^n}{R^n}
=\left(\frac{R_{t-1}^n}{R^n}\right)^{\phi_R}
\left[
\left(\frac{\pi_t}{\pi}\right)^{\phi_\pi}
\left(\frac{Y_t}{Y}\right)^{\phi_Y}
\right]^{1-\phi_R}
e^{\epsilon_t^m}.
$$

- **(F30) 宏观审慎溢价规则**：

$$
s_t=f_t\,s\left(\frac{Q_tK_{t+1}}{N_{t+1}}\right)\tau_t.
$$

- **(F31) 宏观审慎工具**：

$$
\tau_t=\left(\frac{cg_t}{cg_{ss}}\right)^{\rho_\tau}.
$$

- **(F32) 价格水平目标规则，论文中的可选制度**：

$$
\frac{R_t^n}{R^n}
=\left(\frac{R_{t-1}^n}{R^n}\right)^{\phi_R}
\left[
\left(\frac{P_t}{\overline{P}_t}\right)^{\phi_P}
\left(\frac{Y_t}{Y_{ss}}\right)^{\phi_Y}
\right]^{1-\phi_R}
e^{\epsilon_t^m}.
$$

## 5. Exogenous Processes

- **(F33) 偏好冲击**：

$$
\log e_t=\rho_e\log e_{t-1}+\epsilon_t^e,
\qquad \epsilon_t^e\sim i.i.d.\ N(0,\sigma_{\epsilon^e}^2).
$$

- **(F34) 技术冲击**：

$$
\log z_t=\rho_z\log z_{t-1}+\epsilon_t^z,
\qquad \epsilon_t^z\sim i.i.d.\ N(0,\sigma_{\epsilon^z}^2).
$$

- **(F35) 金融冲击**：

$$
\log f_t=\rho_f\log f_{t-1}+\epsilon_t^f,
\qquad \epsilon_t^f\sim i.i.d.\ N(0,\sigma_{\epsilon^f}^2).
$$

- **(F36) 投资特定冲击**：

$$
\log x_t=\rho_x\log x_{t-1}+\epsilon_t^x,
\qquad \epsilon_t^x\sim i.i.d.\ N(0,\sigma_{\epsilon^x}^2).
$$

- **(F37) 货币政策冲击**：

$$
\epsilon_t^m\sim i.i.d.\ N(0,\sigma_{\epsilon^m}).
$$

## 6. Steady-State Solution

论文报告了校准稳态目标和估计后验众数，而不是完整的闭式稳态推导。一遍稳态构造为：

1. 将确定性冲击设为均值：\(\bar e=\bar z=\bar x=\bar f=1\)，创新为零，且当 \(cg_t=cg_{ss}\) 时 \(\bar \tau=1\)。
2. 使用家庭 Euler 方程：

$$
1=\beta R^n/\pi.
$$

3. 用校准值设定稳态总通胀。论文说明年化 \(\pi=1.02\)；Rep-MMB 文件使用季度总目标 `mub = 1.005`。
4. 使用加成定价，并结合实现中的 Calvo 通胀项，确定稳态边际成本。
5. 令 \(Q=1\)，并用资本回报方程从下式求资本劳动比：

$$
\bar R^k=\frac{\bar{mc}\,F_K+(1-\delta)}{\bar Q}.
$$

6. 使用劳动供给和家庭将三分之一时间用于工作的校准目标，确定 \(\theta\) 或检验选取的 \(\theta=5.75\)。
7. 使用净值资本比目标 \(N/K=0.6\)、资本积累 \(\bar I=\delta \bar K/\bar x\) 和资源约束，求解 \(\bar C\)、\(\bar C^e\)、\(\bar I\) 与 \(\bar Y\)。
8. 使用 \(B=QK-N\) 和 \(cg_{ss}=1\) 或实现中的名义增长调整惯例，初始化信贷与宏观审慎变量。

`needs_review`：论文 Markdown 没有提供足够干净的方程来完成已由来源核查的稳态块。Rep-MMB 实现包含具体稳态校准，但此处只作为 `implementation_cross_check`。

## 7. Timing & Form Conventions

- 资本 \(K_t\) 在生产中为预定变量：企业家在 \(t\) 期末购买 \(K_{t+1}\)，而 \(t\) 期生产使用此前购入的资本。Rep-MMB 实现在生产和资本回报方程中使用 `kt(-1)`，与此时序一致。
- 债务合约为名义形式。实际偿还负担通过 \(R_{t-1}^n P_{t-1}/P_t\) 受到意外通胀影响。
- \(Q_t\) 是已安装资本的相对价格。
- \(s_t\) 是外部融资溢价；\(f_t\) 是金融冲击；\(\tau_t\) 是宏观审慎乘子。
- Calvo 价格刚性使用不调价概率 \(\nu\)。价格分散 \(\Gamma_t\) 进入总资源可行条件。
- 模型形式为非线性。Rep-MMB 交叉检查使用非线性 Dynare `model` 和一阶模拟，而不是手工对数线性 `model(linear)` 块。
- 未执行运行时验证。

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII hint | Meaning | Main equation(s) |
|---|---|---|---|
| 内生 | \(C_t\) / `ct` | 家庭消费 | (F1), (F22) |
| 内生 | \(C_t^e\) / `ce` | 退出企业家的消费 | (F14), (F22) |
| 内生 | \(H_t\) / `ht` | 家庭劳动时间 | (F2), (F4), (F5) |
| 内生 | \(H_t^e\) | 企业家劳动 | (F4), (F6) |
| 内生 | \(L_t\) / `llt` | 复合劳动 / 实现中的价格分散调整劳动块 | (F4), (F24) |
| 内生 | \(K_t\) / `kt` | 资本存量 | (F7), (F15) |
| 内生 | \(I_t\) / `it` | 投资 | (F15), (F16), (F22) |
| 内生 | \(Q_t\) / `qt` | 资本相对价格 | (F7), (F11), (F16) |
| 内生 | \(N_t\) / `nt` | 企业家净值 | (F7), (F12), (F13) |
| 内生 | \(B_t,D_t\) / `bt` | 企业家债务和家庭存款 | (F7), (F26), (F27) |
| 内生 | \(R_t^n\) / `rnt` | 名义政策/存款利率 | (F1), (F28), (F29), (F32) |
| 内生 | \(R_t^k\) / `rkt` | 资本总收益率 | (F8), (F10), (F11) |
| 内生 | \(s_t\) / `st` | 外部融资溢价 | (F8), (F9), (F30) |
| 内生 | \(\tau_t\) / `taut` | 宏观审慎乘子 | (F30), (F31) |
| 内生 | \(cg_t\) / `cgn`, `cg` | 名义信贷增长 | (F27), (F28), (F31) |
| 内生 | \(Y_t\) / `yt` | 最终产出 | (F17), (F22), (F24) |
| 内生 | \(P_t,P_t^{\ast},\pi_t\) / `pit`, `pstart` | 总价格、重置价格、通胀 | (F18), (F20), (F21), (F25) |
| 内生 | \(mc_t\) / `mct` | 实际边际成本 | (F20), 加成/回报方程 |
| 内生 | \(\Gamma_t\) / 论文符号与实现中的 `llt` 不完全一致 | 价格分散 | (F25) |
| 外生 | \(e_t\) / `pref` | 偏好冲击 | (F33) |
| 外生 | \(z_t\) / `zt` | 技术冲击 | (F34) |
| 外生 | \(f_t\) / `ft` | 金融冲击 | (F35) |
| 外生 | \(x_t\) / `xt` | 投资特定冲击 | (F36) |
| 外生 | \(\epsilon_t^m\) / 实现中政策冲击位置为 `epset` | 货币政策冲击 | (F37) |
| 参数 | \(\beta\) / `b` | 贴现因子 | (F1) |
| 参数 | \(\theta,\gamma\) / `te`, `g` | 劳动效用权重和劳动供给弹性倒数 | (F2) |
| 参数 | \(\alpha\) / `a` | 资本份额 | (F3), (F11) |
| 参数 | \(\Omega\) | 复合劳动中的企业家劳动份额 | (F4)-(F6) |
| 参数 | \(\eta\) / `eta` | 企业家存活概率 | (F12)-(F14) |
| 参数 | \(\delta\) / `d` | 折旧率 | (F11), (F15), (F22) |
| 参数 | \(\xi\) / `xi` | 资本调整成本 | (F16), (F22) |
| 参数 | \(\varepsilon\) / `veps` | 零售品替代弹性 | (F17)-(F21) |
| 参数 | \(\nu\) / `nu` | Calvo 不调价概率 | (F20), (F21), (F25) |
| 参数 | \(\phi_R,\phi_\pi,\phi_Y,\phi_c,\phi_P\) / `r_r`, `r_p`, `r_y`, `r_c` | 货币政策规则系数 | (F28), (F29), (F32) |
| 参数 | \(\rho_\tau\) / `rhotau` | 宏观审慎规则系数 | (F31) |
| 参数 | \(\rho_e,\rho_z,\rho_f,\rho_x\) | 冲击持续性 | (F33)-(F36) |
