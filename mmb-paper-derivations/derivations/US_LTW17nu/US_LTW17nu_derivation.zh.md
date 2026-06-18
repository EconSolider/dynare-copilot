# US_LTW17nu —— 推导（最优化问题 + 一阶条件）

> 档案状态：`needs_review`。本一稿推导以 MinerU Markdown 为论文侧来源，并仅把 MMB `.mod` 用作 `implementation_cross_check`；未执行 Dynare 运行验证。

来源信息：`US_LTW17nu`，Leeper、Traum 和 Walker（2017），"Clearing Up the Fiscal Multiplier Morass"，DOI `10.1257/aer.20111196`。来源 Markdown：`raw/mmb_mineru/runs/us_ltw17_us_ltw17gz_us_ltw17nu_us_ltw17rot__clearing_up_the_fiscal_multiplier_morass__f1cc32b3/full.md`；原始 PDF：`raw/mmb_papers/Clearing Up the Fiscal Multiplier Morass.pdf`；MinerU run id：`f1cc32b3-a1c8-4473-bab4-edca5aaeb37e`。

## 1. Model Overview

- **模型**：美国中等规模新凯恩斯财政乘数模型，包含名义刚性、真实摩擦、财政反馈规则、长期名义政府债务和稳态扭曲税。
- **变体**：`US_LTW17nu`，即政府支出不进入效用的变体。论文嵌套了政府支出进入效用的模型，但 MMB 实现设置 `alphag = 0` 与 `thet = 0.8`；这一变体限制来自 `.agents/skills/dynare-copilot/references/examples/US_LTW17nu_rep.mod`，证据类型为 `implementation_cross_check`。
- **主体与模块**：储蓄型家庭、论文侧一般模型中的非储蓄型家庭、最终品与中间品企业、劳动聚合机构与工资设定者、货币当局和财政当局。
- **形式**：对数线性化的 `model(linear)` 实现。论文以水平变量和帽子变量百分比偏离表示方程；MMB `.mod` 将 `nu` 变体写成围绕确定性稳态的线性方程。
- **审阅状态**：一稿公式质量为 `needs_review`，因为来源 Markdown 中若干 OCR 方程有噪声，且 `nu` 变体的限制来自实现交叉检查，而不是论文中独立的小节。

## 2. Optimization Problems

### 2.1 最终品生产者

最终品企业聚合差异化中间品：

```math
Y_t \leq \left(\int_0^1 Y_t(i)^{\frac{1}{1+\eta_t^p}}\,di\right)^{1+\eta_t^p}.
```

它选择投入需求以最大化最终品收入减去对中间品企业的支付。由此得到的 Dixit-Stiglitz 需求记为 (F1)。

### 2.2 中间品企业

中间品企业 $`i`$ 使用技术：

```math
Y_t(i)=K_t(i)^\alpha \big(A_t L_t(i)\big)^{1-\alpha}-A_t\Omega.
```

成本最小化给出共同名义边际成本。企业以 $`1-\omega_p`$ 的 Calvo 概率重设价格；未重设的价格部分指数化到滞后通胀和稳态通胀。

重设价格企业最大化预期贴现利润：

```math
E_t\sum_{s=0}^{\infty}(\beta\omega_p)^s\frac{\lambda_{t+s}}{\lambda_t}
\left[\left(\prod_{k=1}^{s}\pi_{t+k-1}^{\chi_p}\pi^{1-\chi_p}\right)P_t(i)Y_{t+s}(i)-MC_{t+s}Y_{t+s}(i)\right].
```

`needs_review`：Markdown 中价格设定问题的结构可读，但名义价格/相对价格记号应对 PDF 再核查。

### 2.3 劳动聚合机构与工资设定者

劳动聚合机构聚合差异化劳动服务：

```math
L_t=\left(\int_0^1 L_t(l)^{\frac{1}{1+\eta_t^w}}\,dl\right)^{1+\eta_t^w}.
```

家庭供给差异化劳动服务。储蓄型家庭以 $`1-\omega_w`$ 的概率重设名义工资，否则工资指数化到滞后通胀和趋势增长。工资重设问题是 Calvo 价格问题的家庭侧对应物。

### 2.4 储蓄型家庭

储蓄型家庭 $`j`$ 最大化：

```math
E_0\sum_{t=0}^{\infty}\beta^t u_t^b
\left[
\log\big(C_t^{\astS}(j)-\theta \widetilde C_{t-1}^{\astS}\big)
-\frac{(L_t^S(j))^{1+\xi}}{1+\xi}
\right],
```

其中复合消费为：

```math
C_t^{\astS}(j)=C_t^S(j)+\alpha_G G_t.
```

对 `US_LTW17nu`，`implementation_cross_check` 设置 $`\alpha_G=0`$，所以 $`C_t^{\astS}=C_t^S`$。名义预算约束为：

```math
\begin{aligned}
P_t(1+\tau_t^C)C_t^S(j)+P_t I_t^S(j)+P_t^B B_t(j)+R_t^{-1}B_{s,t}(j)
&=(1+\rho P_t^B)B_{t-1}(j)+B_{s,t-1}(j)\\
&\quad +(1-\tau_t^L)\int_0^1 W_t(l)L_t^S(j,l)\,dl\\
&\quad +(1-\tau_t^K)R_t^k\nu_t(j)\bar K_{t-1}^S(j)-\Psi(\nu_t)\bar K_{t-1}^S(j)\\
&\quad +P_t Z_t^S(j)+D_t(j).
\end{aligned}
```

实物资本按下式演化：

```math
\bar K_t^S(j)=(1-\delta)\bar K_{t-1}^S(j)+u_t^i\left[1-s\left(\frac{I_t^S(j)}{I_{t-1}^S(j)}\right)\right]I_t^S(j).
```

### 2.5 非储蓄型家庭

论文侧一般模型允许比例为 $`\mu`$ 的非储蓄型家庭。它们每期消费可支配收入：

```math
(1+\tau_t^C)P_t C_t^N(j)=(1-\tau_t^L)\int_0^1 W_t(l)L_t^N(j,l)\,dl+P_t Z_t^N(j).
```

对 `US_LTW17nu`，`implementation_cross_check` 设置 `muHH = 0`；非储蓄型家庭模块在数值变体中不活跃，但此处保留以覆盖论文来源。

### 2.6 政府与货币当局

货币当局遵循 Taylor 型反馈规则。财政当局在政府预算恒等式约束下选择政府消费、转移支付和税收工具，并让这些工具对市场价值债务产出比作出反馈。

## 3. First-Order Conditions

- **(F1) 中间品需求**：

```math
Y_t(i)=Y_t\left(\frac{P_t(i)}{P_t}\right)^{-\frac{1+\eta_t^p}{\eta_t^p}}.
```

- **(F2) 生产函数，平稳化/对数线性实现形式**：

```math
\hat y_t-\frac{\bar Y+\bar\Omega}{\bar Y}\alpha \hat k_t-\frac{\bar Y+\bar\Omega}{\bar Y}(1-\alpha)\hat l_t=0.
```

- **(F3) 要素价格关系**：

```math
\hat r_t^k-\hat w_t+\hat k_t-\hat l_t=0.
```

- **(F4) 实际边际成本**：

```math
\widehat{mc}_t-\alpha\hat r_t^k+(\alpha-1)\hat w_t=0.
```

- **(F5) 价格 Phillips 曲线**：

```math
\Lambda_p\pi_t-\frac{\Lambda_p\beta}{1+\beta\chi_p}\pi_{t+1}-\widehat{mc}_t-\Lambda_p u_t^p
=\frac{\Lambda_p\chi_p}{1+\beta\chi_p}\pi_{t-1}.
```

`needs_review`：结构性 Calvo FOC 来自论文，紧凑线性 Phillips 曲线来自 `.mod` 实现交叉检查。

- **(F6) 储蓄型家庭财富边际效用**：

```math
\lambda_t+\frac{\theta}{e^\gamma-\theta}u_t^a+\frac{e^\gamma}{e^\gamma-\theta}\hat c_t^{\ast}
-u_t^b+\frac{\bar\tau^C}{1+\bar\tau^C}\hat\tau_t^C
=\frac{\theta}{e^\gamma-\theta}\hat c_{t-1}^{\ast}.
```

- **(F7) 长期实际利率与债券价格**：

```math
\hat r_t^L+\widehat P_t^B-\frac{\beta\rho}{e^\gamma}\hat r_{t+1}^L
-\frac{\beta\rho}{e^\gamma}\widehat P_{t+1}^B+\pi_{t+1}=0.
```

- **(F8) 长期通胀关系**：

```math
\hat\pi_t^L+\widehat P_t^B+\hat r_t^L=0.
```

- **(F9) 效用中的消费，`nu` 变体**：

```math
\hat c_t^{\ast}-\hat c_t^S=0,\qquad \alpha_G=0.
```

- **(F10) 储蓄型家庭 Euler 方程**：

```math
\lambda_t-\hat R_t+\pi_{t+1}-\lambda_{t+1}+\rho_a u_t^a=0.
```

- **(F11) 资本利用率**：

```math
\frac{1-\psi}{\psi}\hat r_t^k-\hat\nu_t
-\frac{1-\psi}{\psi}\frac{\bar\tau^K}{1-\bar\tau^K}\hat\tau_t^K=0.
```

- **(F12) 资本 FOC**：

```math
\hat q_t+\hat R_t-\pi_{t+1}
-\beta e^{-\gamma}(1-\delta)\hat q_{t+1}
-\beta e^{-\gamma}\bar R^k(1-\bar\tau^K)\hat r_{t+1}^k
+\bar\tau^K\beta e^{-\gamma}\bar R^k\hat\tau_{t+1}^K=0.
```

- **(F13) 投资 FOC**：

```math
-\frac{1}{(1+\beta)s e^{2\gamma}}\hat q_t+\hat i_t-\frac{\beta}{1+\beta}\hat i_{t+1}
+\frac{1-\beta\rho_a}{1+\beta}u_t^a-u_t^i
=\frac{1}{1+\beta}\hat i_{t-1}.
```

- **(F14) 有效资本**：

```math
\hat k_t-\hat\nu_t+u_t^a=\hat{\bar k}_{t-1}.
```

- **(F15) 实物资本积累**：

```math
\hat{\bar k}_t-\left[1-(1-\delta)e^{-\gamma}\right](1+\beta)s e^{2\gamma}u_t^i
-\left[1-(1-\delta)e^{-\gamma}\right]\hat i_t
+(1-\delta)e^{-\gamma}u_t^a
=(1-\delta)e^{-\gamma}\hat{\bar k}_{t-1}.
```

- **(F16) 工资 Phillips 曲线**：

```math
\begin{aligned}
(1+\Lambda_w)\hat w_t-\frac{\Lambda_w\beta}{1+\beta}\hat w_{t+1}
+\frac{\Lambda_w(1+\beta\chi_w)}{1+\beta}\pi_t
-\frac{\Lambda_w\beta}{1+\beta}\pi_{t+1}
-\xi\hat l_t+\lambda_t\\
+\frac{\Lambda_w(1+\beta\chi_w-\rho_a\beta)}{1+\beta}u_t^a
-\frac{\bar\tau^L}{1-\bar\tau^L}\hat\tau_t^L
-\Lambda_w u_t^w-u_t^b\\
=\frac{\Lambda_w}{1+\beta}\hat w_{t-1}
+\frac{\Lambda_w\chi_w}{1+\beta}\pi_{t-1}
+\frac{\Lambda_w\chi_w}{1+\beta}u_{t-1}^a.
\end{aligned}
```

`needs_review`：论文说明了 Calvo 工资问题，但该线性工资方程来自实现交叉检查。

- **(F17) 货币政策规则**：

```math
\hat R_t-\left(1-\rho_R\right)\phi_\pi\pi_t-\left(1-\rho_R\right)\phi_y\hat y_t-u_t^m
=\rho_R\hat R_{t-1}.
```

## 4. Market Clearing & Identities

- **(F18) 总资源约束**：

```math
\bar C\hat c_t+\bar I\hat i_t-\bar Y\hat y_t+\bar s_G\bar Y\hat g_t+\Psi'(1)\bar K\hat\nu_t=0.
```

- **(F19) 非储蓄型家庭预算约束，$`\mu=0`$ 时不活跃**：

```math
\bar C^N(1+\bar\tau^C)\hat c_t^N+\bar\tau^C\bar C^N\hat\tau_t^C
-\bar W\bar L(1-\bar\tau^L)(\hat w_t+\hat l_t)
+\bar W\bar L\bar\tau^L\hat\tau_t^L-\bar Z\hat z_t=0.
```

- **(F20) 消费加总**：

```math
\bar C\hat c_t-(1-\mu)\bar C^S\hat c_t^S-\mu\bar C^N\hat c_t^N=0.
```

- **(F21) 长期债券定价**：

```math
\hat R_t-\frac{\rho\bar P^B}{1+\rho\bar P^B}\widehat P_{t+1}^B+\widehat P_t^B=0.
```

- **(F22) 政府预算约束**：

```math
\begin{aligned}
\bar s_b\hat b_t-\bar s_G\hat g_t-\frac{\bar Z}{\bar Y}\hat z_t
+\bar\tau^K\bar r^k\bar k_y(\hat\tau_t^K+\hat r_t^k+\hat k_t)
+\frac{\bar s_b}{\beta}u_t^a\\
+\bar\tau^L\bar w\bar l_y(\hat\tau_t^L+\hat w_t+\hat l_t)
+\bar\tau^C\bar c_y(\hat c_t+\hat\tau_t^C)
-\bar s_b\rho e^{-\gamma}\widehat P_t^B+\frac{\bar s_b}{\beta}\pi_t\\
=\frac{\bar s_b}{\beta}\hat b_{t-1}-\frac{\bar s_b}{\beta}\widehat P_{t-1}^B.
\end{aligned}
```

`needs_review`：论文中的政府预算恒等式 OCR 噪声较大；此对数线性版本来自实现交叉检查。

- **(F23) 政府消费规则**：

```math
\hat g_t-u_t^G=\rho_G\hat g_{t-1}-(1-\rho_G)\gamma_G\hat s_{t-1}^b.
```

- **(F24) 资本税规则**：

```math
\hat\tau_t^K=(1-\rho_K)\gamma_K\hat s_{t-1}^b+\rho_K\hat\tau_{t-1}^K.
```

- **(F25) 劳动税规则**：

```math
\hat\tau_t^L=(1-\rho_L)\gamma_L\hat s_{t-1}^b+\rho_L\hat\tau_{t-1}^L.
```

- **(F26) 消费税规则**：

```math
\hat\tau_t^C=\rho_C\hat\tau_{t-1}^C.
```

- **(F27) 转移支付规则**：

```math
\hat z_t-u_t^Z=-(1-\rho_Z)\gamma_Z\hat s_{t-1}^b+\rho_Z\hat z_{t-1}.
```

- **(F28) Fisher 方程**：

```math
\hat r_t-\hat R_t+\pi_{t+1}=0.
```

- **(F29) 债务产出比定义**：

```math
\hat s_t^b+\hat y_t-\hat b_t=0.
```

- **(F30) 消费税收入**：

```math
\widehat T_t^C-\hat\tau_t^C-\hat c_t=0.
```

- **(F31) 资本税收入**：

```math
\widehat T_t^K-\hat\tau_t^K-\hat r_t^k-\hat k_t=0.
```

- **(F32) 实际债券收益定义**：

```math
\widehat r_t^b-\rho\beta e^{-\gamma}\widehat P_t^B+\pi_t=-\widehat P_{t-1}^B.
```

- **(F33) 初级盈余定义**：

```math
\widehat S_t-\frac{\bar\tau^K\bar r^k\bar k}{\bar S}(\hat\tau_t^K+\hat r_t^k+\hat k_t)
-\frac{\bar\tau^L\bar w\bar l}{\bar S}(\hat\tau_t^L+\hat w_t+\hat l_t)
-\frac{\bar\tau^C\bar c}{\bar S}(\hat\tau_t^C+\hat c_t)
+\frac{\bar Z}{\bar S}\hat z_t+\frac{\bar G}{\bar S}\hat g_t=0.
```

- **(F34) 劳动税收入**：

```math
\widehat T_t^L-\hat\tau_t^L-\hat w_t-\hat l_t=0.
```

## 5. Exogenous Processes

- **(F35) 政府消费冲击**：

```math
u_t^G=\rho_{eG}u_{t-1}^G+\epsilon_t^G.
```

- **(F36) 转移支付冲击**：

```math
u_t^Z=\rho_{eZ}u_{t-1}^Z+\epsilon_t^Z.
```

- **(F37) 技术增长冲击**：

```math
u_t^a=\rho_a u_{t-1}^a+\epsilon_t^a.
```

- **(F38) 偏好冲击**：

```math
u_t^b=\rho_b u_{t-1}^b+\epsilon_t^b.
```

- **(F39) 货币政策冲击**：

```math
u_t^m=\rho_{em}u_{t-1}^m+\epsilon_t^m.
```

- **(F40) 投资冲击**：

```math
u_t^i=\rho_i u_{t-1}^i+\epsilon_t^i.
```

- **(F41) 工资加成冲击**：

```math
u_t^w=\rho_w u_{t-1}^w+\epsilon_t^w.
```

- **(F42) 价格加成冲击**：

```math
u_t^p=\rho_p u_{t-1}^p+\epsilon_t^p.
```

## 6. Steady-State Solution

MMB 实现先以水平变量计算确定性稳态，再用 `model(linear)` 表示偏离。令 $`\bar\pi=1`$、$`\bar\nu=1`$，并令 $`e^\gamma`$ 为总趋势增长率。

1. 从美国数据均值校准财政稳态 $`\bar s_b`$、$`\bar\tau^L`$、$`\bar\tau^K`$、$`\bar\tau^C`$ 与 $`\bar s_G`$。
2. 设置 $`\bar R=e^\gamma/\beta`$，并设置长期债券价格 $`\bar P^B=1/(\bar R-\rho)`$。
3. 设置税后私人资本回报：

```math
\bar R^k=\frac{e^\gamma/\beta-1+\delta}{1-\bar\tau^K}.
```

4. 设置实际边际成本 $`\overline{mc}=1/(1+\eta^p)`$，并由生产、投资和资源约束恢复 $`\bar W`$、$`\bar K/\bar L`$、$`\bar Y/\bar L`$、$`\bar I/\bar L`$ 与每单位劳动的总消费。
5. 对 `US_LTW17nu`，根据实现交叉检查设置 $`\alpha_G=0`$、$`\mu=0`$ 和 $`\theta=0.8`$。因此稳态中 $`C^{\ast S}=C^S`$。
6. 由储蓄型家庭的静态劳动条件恢复劳动，并按 $`\bar L`$ 缩放水平变量。
7. 根据财政稳态比率计算税收收入、初级盈余、转移支付、债务和政府消费。

`needs_review`：稳态公式由论文结构和实现交叉检查总结而来。未进行独立代数验证，也未执行 Dynare 稳态验证。

## 7. Timing & Form Conventions

- **形式**：`model(linear)`；(F2)-(F42) 中变量为帽子变量或实现风格的确定性稳态偏离。
- **技术趋势**：永久技术 $`A_t`$ 具有平稳增长冲击 $`u_t^a=\log A_t-\log A_{t-1}`$。
- **资本时序**：实物资本 $`\bar K_t`$ 是期末存量；生产使用的有效资本与利用率和滞后实物资本相关。
- **债务时序**：长期名义债务按到期参数 $`\rho`$ 支付递减票息流；市场价值债务产出比 $`s_t^b`$ 使用债券价格和未偿债务。
- **变体限制**：`US_LTW17nu` 移除政府消费进入效用，$`\alpha_G=0`，并在 MMB 实现中把习惯形成降低为 `$\theta=0.8`。
- **运行验证**：未执行；没有运行任何 Dynare 命令。

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Equation source |
|---|---|---|---|
| Endogenous | `cs`, $`C^S`$ | 储蓄型家庭消费 | (F6), (F9), (F10), (F20) |
| Endogenous | `cn`, $`C^N`$ | 非储蓄型家庭消费，$`\mu=0`$ 时不活跃 | (F19), (F20) |
| Endogenous | `R` | 名义利率 | (F17), (F28) |
| Endogenous | `i` | 投资 | (F13), (F18) |
| Endogenous | `k` | 有效资本 | (F2), (F14) |
| Endogenous | `v` | 资本利用率 | (F11), (F14), (F18) |
| Endogenous | `l` | 劳动 | (F2), (F3), (F16) |
| Endogenous | `y` | 产出 | (F2), (F18), (F29) |
| Endogenous | `gc` | 政府消费 | (F18), (F23), (F33) |
| Endogenous | `c` | 总消费 | (F18), (F20), (F30) |
| Endogenous | `q` | 投资品乘子 / Tobin's Q | (F12), (F13) |
| Endogenous | `rk` | 资本实际回报 | (F3), (F12), (F31) |
| Endogenous | `w` | 实际工资 | (F3), (F4), (F16) |
| Endogenous | `pi` | 通胀 | (F5), (F17), (F28) |
| Endogenous | `b`, `sb` | 政府债务和债务产出比 | (F22), (F29) |
| Endogenous | `tauk`, `taul`, `tauc` | 税率 | (F24)-(F26) |
| Endogenous | `r` | 实际利率 | (F28) |
| Endogenous | `z` | 转移支付 | (F27), (F33) |
| Endogenous | `mc` | 实际边际成本 | (F4), (F5) |
| Endogenous | `kbar` | 实物资本存量 | (F15) |
| Endogenous | `lambda` | 储蓄型家庭财富边际效用 | (F6), (F10), (F16) |
| Endogenous | `Pb` | 长期债券价格 | (F7), (F8), (F21), (F22), (F32) |
| Endogenous | `cstar` | 效用中的消费 | (F9) |
| Endogenous | `piL`, `rL` | 长期通胀和实际利率 | (F7), (F8) |
| Endogenous | `S`, `rb`, `Tk`, `Tl`, `Tc` | 财政会计变量 | (F30)-(F34) |
| Exogenous shock | `eugc`, `euz`, `eua`, `eub`, `eum`, `eui`, `euw`, `eup` | 政府消费、转移支付、技术、偏好、货币政策、投资、工资加成和价格加成冲击的创新 | (F35)-(F42) |
| Parameter | `bet`, `delt`, `alph`, `etaw`, `etap` | 贴现、折旧、资本份额、工资和价格加成参数 | 所有模型模块 |
| Parameter | `omegaw`, `omegap`, `chiw`, `chip` | Calvo 工资/价格刚性和指数化 | (F5), (F16) |
| Parameter | `phipi`, `phiy`, `rhor` | Taylor 规则系数 | (F17) |
| Parameter | `gammgc`, `gammtk`, `gammtl`, `gammz` | 财政对债务的反馈 | (F23)-(F27) |
| Parameter | `rhoa`, `rhob`, `rhoi`, `rhow`, `rhop`, `rhogc`, `rhoz`, `rhoem`, `rhoeg`, `rhoez` | 持续性参数 | (F35)-(F42) |
| Parameter | `alphag`, `thet`, `muHH` | 政府消费进入效用、习惯、非储蓄者比例 | (F9), 变体限制 |

文档中的方程数为 (F1)-(F42)。实现还包含额外的灵活价格影子经济方程和观测方程；这些在 `extraction_notes.md` 中说明，但未在本一稿档案条目中完整重推。
