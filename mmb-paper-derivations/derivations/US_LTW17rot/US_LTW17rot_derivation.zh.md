# US_LTW17rot -- 推导（最优化问题 + 一阶条件）

> 状态：needs_review。本一遍归档条目从 MinerU Markdown 抽取论文侧模型结构，并且只把 `.agents/skills/dynare-copilot/references/examples/US_LTW17rot_rep.mod` 用作 implementation_cross_check。未执行运行时验证。

出处：`US_LTW17rot`，Leeper, Traum, and Walker (2017)，"Clearing Up the Fiscal Multiplier Morass," American Economic Review 107(8): 2409-2454，DOI `10.1257/aer.20111196`。来源 Markdown：`raw/mmb_mineru/runs/us_ltw17_us_ltw17gz_us_ltw17nu_us_ltw17rot__clearing_up_the_fiscal_multiplier_morass__f1cc32b3/full.md`。原始 PDF：`raw/mmb_papers/Clearing Up the Fiscal Multiplier Morass.pdf`。

## 1. Model Overview

- **模型**：用于研究美国政府支出乘数的中等规模财政/货币 DSGE 模型，在 Christiano-Eichenbaum-Evans 和 Smets-Wouters 类模型上加入了详细财政部门。
- **MMB 变体**：`US_LTW17rot` 是 rule-of-thumb 消费者实现版本。论文最终估计模型把非储蓄者比例设为零，并让政府支出进入效用；本归档条目记录更广义的论文模型，并把 `rot` 实现差异标为 implementation_cross_check 证据。
- **主体**：最终品厂商、垄断竞争中间品厂商、劳动聚合机构/工会、储蓄者家庭、非储蓄者家庭、财政当局和货币当局。
- **摩擦**：Calvo 价格、Calvo 工资、价格和工资指数化、消费外部习惯、投资调整成本、可变资本利用率、长期名义政府债务，以及稳态扭曲性税收。
- **政策制度**：regime M 是主动货币/被动财政；regime F 是被动货币/主动财政。
- **形式**：MMB 实现为 `model(linear)`；下列方程按上下文写成来源层面的非线性定义或对数线性均衡条件。OCR 公式是一遍抽取，凡来源文本畸形处均标为 needs_review。

## 2. Optimization Problems

### 最终品厂商

最终品厂商聚合差异化中间品：

$$Y_t = \left(\int_0^1 Y_t(i)^{\frac{1}{1+\eta_t^p}}\,di\right)^{1+\eta_t^p} \tag{(F1)}$$

中间品 \(i\) 的需求为：

$$Y_t(i)=Y_t\left(\frac{P_t(i)}{P_t}\right)^{-\frac{1+\eta_t^p}{\eta_t^p}} \tag{(F2)}$$

### 中间品厂商

中间品厂商租用资本和劳动并生产：

$$Y_t(i)=K_t(i)^\alpha\big(A_t L_t(i)\big)^{1-\alpha}-A_t\Omega \tag{(F3)}$$

成本最小化给出名义边际成本：

$$MC_t=(1-\alpha)^{\alpha-1}\alpha^{-\alpha}(R_t^k)^\alpha W_t^{1-\alpha}A_t^{-1+\alpha} \tag{(F4)}$$

能够重设价格的厂商最大化：

$$E_t\sum_{s=0}^{\infty}(\beta\omega_p)^s\frac{\lambda_{t+s}}{\lambda_t}
\left[\left(\prod_{k=1}^{s}\pi_{t+k-1}^{\chi_p}\pi^{1-\chi_p}\right)P_t^{\ast}(i)Y_{t+s}(i)-MC_{t+s}Y_{t+s}(i)\right] \tag{(F5), needs_review}$$

(F5) 中利润括号前的加号来自 OCR 文本，但很可能应理解为贴现因子与利润项相乘；需要对照 PDF 复核。

### 劳动聚合机构和工资设定者

竞争性劳动聚合机构聚合差异化劳动：

$$L_t=\left(\int_0^1 L_t(l)^{\frac{1}{1+\eta_t^w}}\,dl\right)^{1+\eta_t^w} \tag{(F6)}$$

类型 \(l\) 的劳动需求为：

$$L_t(l)=L_t^d\left(\frac{W_t(l)}{W_t}\right)^{-\frac{1+\eta_t^w}{\eta_t^w}} \tag{(F7)}$$

工资设定者面临 Calvo 重设并带有指数化：

$$W_t(l)=W_{t-1}(l)\big(\pi_{t-1}e^{u^a_{t-1}}\big)^{\chi_w}(\pi e^\gamma)^{1-\chi_w} \tag{(F8), needs_review}$$

### 储蓄者家庭

储蓄者家庭 \(j\) 最大化：

$$E_0\sum_{t=0}^{\infty}\beta^t u_t^b\left[\log\left(C_t^{\astS}(j)-\theta\widetilde C_{t-1}^{\astS}\right)-\frac{(L_t^S(j))^{1+\xi}}{1+\xi}\right] \tag{(F9)}$$

进入效用的复合消费为：

$$C_t^{\astS}(j)=C_t^S(j)+\alpha_G G_t \tag{(F10)}$$

储蓄者名义预算约束为：

$$\begin{aligned}
P_t(1+\tau_t^C)C_t^S(j)+P_tI_t^S(j)+P_t^B B_t(j)+R_t^{-1}B_{s,t}(j)
&=(1+\rho P_t^B)B_{t-1}(j)+B_{s,t-1}(j)\\
&\quad +(1-\tau_t^L)\int_0^1 W_t(l)L_t^S(j,l)\,dl\\
&\quad +(1-\tau_t^K)R_t^k v_t(j)\bar K_{t-1}^S(j)-\psi(v_t)\bar K_{t-1}^S(j)\\
&\quad +P_tZ_t^S(j)+D_t(j).
\end{aligned} \tag{(F11)}$$

资本演化为：

$$\bar K_t^S(j)=(1-\delta)\bar K_{t-1}^S(j)+u_t^i\left[1-s\left(\frac{I_t^S(j)}{I_{t-1}^S(j)}\right)\right]I_t^S(j) \tag{(F12)}$$

有效资本为：

$$K_t^S(j)=v_t(j)\bar K_{t-1}^S(j) \tag{(F13)}$$

### 非储蓄者家庭

非储蓄者消费当期可支配收入：

$$P_t(1+\tau_t^C)C_t^N(j)=(1-\tau_t^L)\int_0^1 W_t(l)L_t^N(j,l)\,dl+P_tZ_t^N(j) \tag{(F14)}$$

## 3. First-Order Conditions

来源论文在 OCR 文本中没有以单一附录块列出所有非线性 FOC。下列条件结合了可直接看见的来源公式和仅作为 implementation_cross_check 的 `model(linear)` 方程。

**(F15) 储蓄者财富边际效用，对数线性 implementation_cross_check**：

$$\lambda_t+\frac{\theta}{e^\gamma-\theta}u_t^a+\frac{e^\gamma}{e^\gamma-\theta}c_t^{\ast} -u_t^b+\frac{\tau^C}{1+\tau^C}\tau_t^C
=\frac{\theta}{e^\gamma-\theta}c_{t-1}^{\ast}$$

**(F16) 储蓄者欧拉方程，对数线性 implementation_cross_check**：

$$\lambda_t-R_t+\pi_{t+1}-\lambda_{t+1}+\rho_a u_t^a=0$$

**(F17) 资本利用率条件，对数线性 implementation_cross_check**：

$$\frac{1-\psi}{\psi}r_t^k-v_t-\frac{1-\psi}{\psi}\frac{\tau^K}{1-\tau^K}\tau_t^K=0$$

**(F18) 资本 FOC，对数线性 implementation_cross_check**：

$$q_t+R_t-\pi_{t+1}-\beta e^{-\gamma}(1-\delta)q_{t+1}
-\beta e^{-\gamma}R^K(1-\tau^K)r_{t+1}^k
+\tau^K e^{-\gamma}\beta R^K\tau_{t+1}^K=0$$

**(F19) 投资 FOC，对数线性 implementation_cross_check**：

$$-\frac{1}{(1+\beta)s e^{2\gamma}}q_t+i_t-\frac{\beta}{1+\beta}i_{t+1}
+\frac{1-\beta\rho_a}{1+\beta}u_t^a-u_t^i=\frac{1}{1+\beta}i_{t-1}$$

**(F20) 工资 Phillips 曲线，对数线性 implementation_cross_check，needs_review**：

$$\begin{aligned}
(1+\lambda_w)w_t-\lambda_w\frac{\beta}{1+\beta}w_{t+1}
+\lambda_w\frac{1+\beta\chi_w}{1+\beta}\pi_t
-\lambda_w\frac{\beta}{1+\beta}\pi_{t+1}
-\xi l_t+\lambda_t
+\lambda_w\frac{1+\beta\chi_w-\rho_a\beta}{1+\beta}u_t^a
-\frac{\tau^L}{1-\tau^L}\tau_t^L-\lambda_w u_t^w-u_t^b\\
=\frac{\lambda_w}{1+\beta}w_{t-1}
+\frac{\lambda_w\chi_w}{1+\beta}\pi_{t-1}
+\frac{\lambda_w\chi_w}{1+\beta}u_{t-1}^a .
\end{aligned}$$

**(F21) 新凯恩斯价格 Phillips 曲线，对数线性 implementation_cross_check**：

$$\lambda_p\pi_t-\lambda_p\frac{\beta}{1+\beta\chi_p}\pi_{t+1}-mc_t-\lambda_p u_t^p
=\lambda_p\frac{\chi_p}{1+\beta\chi_p}\pi_{t-1}$$

## 4. Market Clearing & Identities

总消费：

$$C_t=(1-\mu)C_t^S+\mu C_t^N \tag{(F22)}$$

产品市场出清：

$$Y_t=C_t+I_t+G_t+\psi(v_t)\bar K_{t-1} \tag{(F23)}$$

债务产出比：

$$s_t^b=\frac{P_t^B B_t}{P_tY_t} \tag{(F24)}$$

长期名义债券定价，对数线性 implementation_cross_check：

$$R_t-\frac{\rho_B P^B}{1+\rho_B P^B}P^B_{t+1}+P^B_t=0 \tag{(F25)}$$

政府预算约束，来源层面恒等式：

$$P_t^B B_t+\tau_t^K R_t^K K_t+\tau_t^L W_tL_t+P_t\tau_t^C C_t=(1+\rho P_t^B)B_{t-1}+P_tG_t+P_tZ_t \tag{(F26), needs_review}$$

基本盈余：

$$S_t=\tau_t^K R_t^kK_t+\tau_t^L W_tL_t+\tau_t^C C_t-G_t-Z_t \tag{(F27)}$$

税收收入定义：

$$T_t^C=\tau_t^C C_t,\qquad T_t^K=\tau_t^K R_t^kK_t,\qquad T_t^L=\tau_t^L W_tL_t \tag{(F28)}$$

Fisher 方程：

$$r_t-R_t+\pi_{t+1}=0 \tag{(F29)}$$

## 5. Exogenous Processes

技术增长：

$$u_t^a=(1-\rho_a)\gamma+\rho_a u_{t-1}^a+\epsilon_t^a,\qquad \epsilon_t^a\sim N(0,\sigma_a^2) \tag{(F30)}$$

货币政策：

$$\widehat R_t=\rho_r\widehat R_{t-1}+(1-\rho_r)\left(\phi_\pi\widehat\pi_t+\phi_y\widehat y_t\right)+u_t^m \tag{(F31)}$$

货币政策冲击：

$$u_t^m=\rho_{em}u_{t-1}^m+\epsilon_t^m,\qquad \epsilon_t^m\sim N(0,\sigma_m^2) \tag{(F32)}$$

政府消费和转移支付财政规则：

$$\widehat g_t=\rho_G\widehat g_{t-1}-(1-\rho_G)\gamma_G\widehat s_{t-1}^b+u_t^G \tag{(F33)}$$

$$\widehat z_t=\rho_Z\widehat z_{t-1}-(1-\rho_Z)\gamma_Z\widehat s_{t-1}^b+u_t^Z \tag{(F34)}$$

税收工具财政规则：

$$\widehat\tau_t^J=\rho_J\widehat\tau_{t-1}^J+(1-\rho_J)\gamma_J\widehat s_{t-1}^b,\qquad J\in\{K,L,C\} \tag{(F35)}$$

财政冲击：

$$u_t^s=\rho_{es}u_{t-1}^s+\epsilon_t^s,\qquad s\in\{G,Z\},\qquad \epsilon_t^s\sim N(0,\sigma_s^2) \tag{(F36)}$$

其他 implementation_cross_check 冲击：

$$u_t^b=\rho_bu_{t-1}^b+\epsilon_t^b,\quad
u_t^i=\rho_iu_{t-1}^i+\epsilon_t^i,\quad
u_t^w=\rho_wu_{t-1}^w+\epsilon_t^w,\quad
u_t^p=\rho_pu_{t-1}^p+\epsilon_t^p \tag{(F37)}$$

## 6. Steady-State Solution

实现文件计算平衡增长稳态，然后求解偏离形式的线性模型。未执行运行时验证。

1. 设定校准稳态目标：\(\beta=0.99\)、\(\delta=0.025\)、\(\alpha=0.33\)、\(\eta_w=\eta_p=0.14\)、\(g_c/Y=0.11\)、\(b/Y=1.47\)、\(\tau^L=0.186\)、\(\tau^K=0.218\)、\(\tau^C=0.023\)、\(\pi=1\)，以及政府债券期限 \(AD=20\)。
2. 计算增长和利率：\(\gamma=gamm100/100\)、\(e^\gamma\)、\(R=e^\gamma/\beta\)，以及 \(\rho_B=(1-1/AD)/\beta\)。
3. 给长期债券定价：\(P^B=1/(R-\rho_B)\)。
4. 计算资本租金回报和边际成本：\(R^K=(e^\gamma/\beta-1+\delta)/(1-\tau^K)\)、\(mc=1/(1+\eta_p)\)。
5. 求解要素价格和比率：\(w=[mc(1-\alpha)^{1-\alpha}\alpha^\alpha(R^K)^{-\alpha}]^{1/(1-\alpha)}\)、\(K/L=(w/R^K)\alpha/(1-\alpha)\)，以及固定成本 \(\Omega/L=(K/L)^\alpha-R^K(K/L)-w\)。
6. 计算单位劳动的产出、投资和消费；随后从财政账户和家庭预算中求转移支付以及储蓄者/非储蓄者消费。
7. 从储蓄者跨期或劳动条件求劳动，并用 \(l\) 缩放所有总量水平。
8. 在 `US_LTW17rot` `.mod` 中，\(\mu=0.3\)，模型为 `model(linear)`，所以在这些水平常数给定后，对数偏离变量的动态稳态为零。

## 7. Timing & Form Conventions

- MMB 实现文件声明 `model(linear)`：变量是围绕已计算平衡增长稳态的对数或百分比偏离。
- 物理资本 \(\bar K_t\) 是期末存量；生产使用有效资本 \(K_t=v_t\bar K_{t-1}\)。
- 长期政府债务是带几何到期衰减 \(\rho\) 的组合；债券价格 \(P_t^B\) 是前瞻变量，重估进入政府预算。
- Taylor 规则使用名义利率和当期通胀/产出偏离。
- 财政规则响应滞后一阶债务产出比 \(\widehat s_{t-1}^b\)。
- 论文估计的是政府支出进入效用且 \(\mu=0\) 的模型；`US_LTW17rot` 实现 rule-of-thumb 版本且 \(\mu=0.3\)。这个变体差异需要对 MMB catalog 元数据做 needs_review 复核。

## 8. Variable & Parameter Reference Table

| 类别 | 符号 / ASCII | 含义 | 主要方程 |
|---|---|---|---|
| 内生 | `cs`, \(C_t^S\) | 储蓄者消费 | F9-F12, F15-F16 |
| 内生 | `cn`, \(C_t^N\) | 非储蓄者消费 | F14 |
| 内生 | `c`, \(C_t\) | 总消费 | F22 |
| 内生 | `cstar`, \(C_t^{\ast}\) | 进入效用的消费 | F10 |
| 内生 | `R` | 名义利率偏离 | F31 |
| 内生 | `r` | 实际利率偏离 | F29 |
| 内生 | `i`, \(I_t\) | 投资 | F12, F19, F23 |
| 内生 | `k`, \(K_t\) | 有效资本 | F13 |
| 内生 | `kbar`, \(\bar K_t\) | 物理资本存量 | F12 |
| 内生 | `v`, \(v_t\) | 资本利用率 | F13, F17 |
| 内生 | `l`, \(L_t\) | 劳动 | F6-F8, F20 |
| 内生 | `y`, \(Y_t\) | 产出 | F1-F3, F23 |
| 内生 | `gc`, \(G_t\) | 政府消费 | F23, F33 |
| 内生 | `q`, \(q_t\) | 投资品乘数/Tobin's q | F18-F19 |
| 内生 | `rk`, \(R_t^k\) | 实际资本回报 | F4, F18 |
| 内生 | `w`, \(W_t\) | 实际工资 | F7-F8, F20 |
| 内生 | `pi`, \(\pi_t\) | 通胀 | F21, F29, F31 |
| 内生 | `b`, \(B_t\) | 政府债务 | F24-F26 |
| 内生 | `sb`, \(s_t^b\) | 债务产出比 | F24 |
| 内生 | `tauk`, \(\tau_t^K\) | 资本税率 | F26-F28, F35 |
| 内生 | `taul`, \(\tau_t^L\) | 劳动税率 | F14, F26-F28, F35 |
| 内生 | `tauc`, \(\tau_t^C\) | 消费税率 | F11, F14, F26-F28, F35 |
| 内生 | `z`, \(Z_t\) | 转移支付 | F11, F14, F26-F27, F34 |
| 内生 | `mc`, \(MC_t\) | 边际成本 | F4, F21 |
| 内生 | `lambda`, \(\lambda_t\) | 储蓄者财富边际效用 | F5, F15-F16 |
| 内生 | `Pb`, \(P_t^B\) | 长债价格 | F25-F26 |
| 内生 | `piL`, `rL` | 长期通胀和实际利率 | implementation_cross_check |
| 内生 | `S`, `Tk`, `Tl`, `Tc`, `rb` | 财政账户变量 | F27-F28 |
| 外生 | `eugc`, `euz` | 政府消费和转移支付创新 | F33-F36 |
| 外生 | `eua`, `eub`, `eui` | 技术、偏好、投资创新 | F30, F37 |
| 外生 | `eum`, `euw`, `eup` | 货币、工资加成、价格加成创新 | F32, F37 |
| 参数 | `bet`, `delt`, `alph` | 贴现因子、折旧、资本份额 | F3-F23 |
| 参数 | `etaw`, `etap` | 工资和价格加成参数 | F1-F8 |
| 参数 | `xi`, `thet`, `alphag`, `muHH` | 劳动弹性、习惯、公共/私人消费参数、非储蓄者比例 | F9-F22 |
| 参数 | `omegaw`, `omegap`, `chiw`, `chip` | Calvo 和指数化参数 | F5, F8, F20-F21 |
| 参数 | `gpsi`, `s` | 利用率和投资调整参数 | F12, F17-F19 |
| 参数 | `phipi`, `phiy`, `rhor` | 货币规则参数 | F31 |
| 参数 | `gammgc`, `gammtk`, `gammtl`, `gammz` | 财政债务响应 | F33-F35 |
| 参数 | `rho*`, `sig*` | 持续性和创新标准差 | F30-F37 |
