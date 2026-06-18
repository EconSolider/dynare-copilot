# US_AJ16 - 推导（最优化问题与一阶条件）

> 这是供后续实现使用的私有模型档案推导。未进行运行时验证。

## 1. Model Overview

- **模型 ID**：`US_AJ16`。
- **论文**：Andrea Ajello (2016), "Financial intermediation, investment dynamics, and business cycle fluctuations," *American Economic Review* 106(8), 2256-2303。
- **DOI**：`10.1257/aer.20120079`。
- **来源 Markdown**：`raw/mmb_mineru/runs/us_aj16__financial_intermediation_investment_dynamics_and_business_cycle_fluctuat__68cd7c2d/full.md`。
- **原始 PDF**：`raw/mmb_papers/Financial intermediation, investment dynamics, and business cycle fluctuations.pdf`。
- **MinerU run id**：`68cd7c2d-56de-47eb-b378-19705191b4ce`。
- **仅作实现交叉核对**：`.agents/skills/dynare-copilot/references/examples/US_AJ16_rep.mod`。
- **主体**：包含异质成员的代表性家庭、金融中介、最终品生产者、垄断竞争中间品生产者、投资品生产者、就业中介、货币当局和财政当局。
- **核心机制**：家庭成员获得异质资本安装技术。高技术成员出售权益索取权为投资融资，中间类型保留安装资本，低技术成员购买权益和政府债券。竞争性金融中介在权益卖价和买价之间形成买卖价差。金融中介楔子的持久和暂时冲击驱动信用利差、融资缺口、投资和总量活动。
- **模型形式**：论文围绕稳态求解平稳化后的对数线性近似。MMB 实现采用对数偏离/平稳变量并使用 `stoch_simul(..., order=1)`，所以本档案将其记录为对数线性化估计 DSGE 系统，而不是完整非线性复现。
- **状态**：`needs_review`，主要原因是论文引用的在线附录推导不在本来源包中，且若干异质主体聚合积分对 OCR 较敏感。

## 2. Optimization Problems

### 2.1 家庭

代表性家庭包含测度为一的成员，索引为 $`i`$。每期期初，每个成员获得异质资本安装技术 $`A_{i,t}\sim F(A_{i,t})`$，其中 $`F`$ 是位置参数 $`\mu_A`$、离散度 $`\sigma_A`$ 的对数正态分布。家庭户主选择或有计划

```math
\mathbf X_{i,t+s}=\{C_{i,t+s},W_{i,t+s},\iota_{i,t+s},\Delta N^+_{i,t+s},\Delta N^-_{i,t+s},N_{i,t+s},B_{i,t+s}\}
```

以及总量变量 $`\mathbf X_{t+s}`$，最大化

```math
\max_{\{\mathbf X_{i,t+s},\mathbf X_{t+s}\}} E_t\sum_{s=0}^{\infty}\beta^{t+s} b_{t+s}
\left[
\log(C_{t+s}-hC_{t+s-1})
-\chi_0\chi_{b,t+s}\frac{L_{t+s}^{1+\nu}}{1+\nu}
\right].
\tag{F1}
```

个体资金流约束为

```math
P_t C_{i,t}+P_t^K\iota_{i,t}+Q_t^B\Delta N^+_{i,t}-Q_t^A\Delta N^-_{i,t}+B_{i,t}
=R_t^K N_{t-1}+W_{i,t}L_{i,t}+R_{t-1}^B B_{t-1}-P_tT_t+P_tD_t.
\tag{F2}
```

成员层面的权益索取权运动方程为

```math
N_{i,t}=A_{i,t}\iota_{i,t}+\Delta N^+_{i,t}-\Delta N^-_{i,t}+(1-\delta)N_{t-1}.
\tag{F3}
```

总量资金流和总量权益积累为

```math
P_t C_t+P_t^K\iota_t+Q_t^B\Delta N_t^+-Q_t^A\Delta N_t^-+B_t
=R_t^K N_{t-1}+W_tL_t+R_{t-1}^B B_{t-1}-P_tD_t+P_tT_t,
\tag{F4}
```

```math
N_t=\int\left[A_{i,t}\iota_{i,t}+\Delta N^+_{i,t}-\Delta N^-_{i,t}\right]dF(A_{i,t})+(1-\delta)N_{t-1}.
\tag{F5}
```

权益出售受到新投资抵押和既有索取权可转售性的约束：

```math
\Delta N^-_{i,t}\leq \theta\frac{P_t^K\iota_{i,t}}{Q_t^A}+\phi(1-\delta)N_{t-1}.
\tag{F6}
```

### 2.2 卖方、保留者和买方

异质技术抽样将家庭成员划分为卖方、保留者和买方：

```math
\chi_{s,t}=1-F\left(\frac{P_t^K}{Q_t^A}\right),
\tag{F7}
```

```math
\chi_{k,t}=F\left(\frac{P_t^K}{Q_t^A}\right)-F\left(\frac{P_t^K}{Q_t^B}\right),
\tag{F8}
```

```math
\chi_{b,t}=1-\chi_{s,t}-\chi_{k,t}.
\tag{F9}
```

卖方使用高技术并出售约束允许的最大权益数量：

```math
\Delta N^+_{s,t}=0,\qquad
\Delta N^-_{s,t}= \theta\frac{P_t^K\iota_{s,t}}{Q_t^A}+\phi(1-\delta)N_{t-1}.
\tag{F10}
```

其投资需求为

```math
\iota_{s,t}=
\frac{R_t^K N_{t-1}+R_{t-1}^B B_{t-1}+P_tD_t-P_tT_t+Q_t^A\phi(1-\delta)N_{t-1}}
{P_t^K(1-\theta)}.
\tag{F11}
```

保留者使用内部资金投资且不交易权益：

```math
C_{k,t}=0,\qquad
\Delta N^-_{k,t}=0,\qquad
\Delta N^+_{k,t}=0,\qquad
B_{k,t}=0,
\tag{F12}
```

```math
\iota_{k,t}=
\frac{R_t^K N_{t-1}+R_{t-1}^B B_{t-1}+P_tD_t-P_tT_t}{P_t^K}.
\tag{F13}
```

买方不安装资本，而是购买权益索取权和政府债券、消费并供给差异化劳动。

### 2.3 金融中介

完全竞争金融中介从卖方购买权益索取权并转售给买方。它们最大化名义利润

```math
\Pi_t^{II}=Q_t^B\Delta N^+_{i,t}-(1+\tau_t^q)Q_t^A\Delta N^-_{i,t}
\tag{F14}
```

约束为

```math
\Delta N^+_{i,t}=\Delta N^-_{i,t}.
\tag{F15}
```

### 2.4 最终品生产者

最终品生产者聚合差异化中间品：

```math
Y_t=\left[\int_0^1 Y_t(j)^{\frac{1}{1+\lambda_{p,t}}}dj\right]^{1+\lambda_{p,t}}.
\tag{F16}
```

### 2.5 中间品生产者

中间品生产者使用预定资本和当期劳动：

```math
Y_t(j)=A_t^\eta K_{t-1}(j)^{1-\eta}L_t(j)^\eta.
\tag{F17}
```

它们面临带过去通胀和稳态通胀指数化的 Calvo 价格刚性。

### 2.6 投资品生产者

竞争性投资品生产者将最终品转化为投资品：

```math
\iota_t=\left[1-S\left(\frac{I_t}{I_{t-1}}\right)\right]I_t,
\qquad
S=0,\quad S'=0,\quad S''=\theta_I\text{ in steady state}.
\tag{F18}
```

它们选择 $`I_t`$ 以最大化利润流的预期贴现值

```math
\max_{\{I_{t+s}\}}E_t\sum_{s=0}^{\infty}\beta^s E_{t+s}
\left\{\mu_{t+s}^{\Sigma C}\left[P_{t+s}^K\iota_{t+s}-P_{t+s}I_{t+s}\right]\right\}.
\tag{F19}
```

### 2.7 就业中介

就业中介聚合买方的差异化劳动：

```math
L_t=\left[\int_0^{P_t^K/Q_t^B} L_{b,t}^{\frac{1}{1+\lambda_{w,t}}}dF(A_{i,t})\right]^{1+\lambda_{w,t}}.
\tag{F20}
```

### 2.8 政策当局

货币当局设定泰勒型名义利率规则。财政当局发行名义政府债券并征收一次总付税，为政府支出和到期债务融资。

## 3. First-Order Conditions

**带外部习惯的家庭边际效用**：

```math
\mu_t^{\Sigma C}
=\frac{1}{C_t-hC_{t-1}}
-\beta b_t h E_t\left[\frac{1}{C_{t+1}-hC_t}\right].
\tag{F21}
```

**权益 Euler 条件**：

```math
Q_t^B=
\beta b_t E_t\left\{
\frac{\mu_{t+1}^{\Sigma C}}{\mu_t^{\Sigma C}}
\frac{1}{\pi_{t+1}}
\left[
\chi_{s,t+1}E_t\left(\frac{Q_{t+1}^B}{\tilde Q_{s,t+1}^A}\Pi_{s,t+1}\right)
+\chi_{k,t+1}E_t\left(\frac{Q_{t+1}^B}{P_{t+1}^K/A_{k,t+1}}\Pi_{k,t+1}\right)
+\chi_{b,t+1}E_t\left(\Pi_{b,t+1}\right)
\right]\right\}.
\tag{F22}
```

收益项为

```math
\Pi_{s,t+1}=R_{t+1}^K+\phi Q_{t+1}^A(1-\delta)+(1-\phi)\tilde Q_{s,t+1}^A(1-\delta),
\tag{F23}
```

```math
\Pi_{k,t+1}=R_{t+1}^K+\frac{P_{t+1}^K}{A_{k,t+1}}(1-\delta),
\tag{F24}
```

```math
\Pi_{b,t+1}=R_{t+1}^K+Q_{t+1}^B(1-\delta).
\tag{F25}
```

**债券 Euler 条件**：

```math
1=\beta b_tE_t\left\{
\frac{\mu_{t+1}^{\Sigma C}}{\mu_t^{\Sigma C}}\frac{R_t^B}{\pi_{t+1}}
\left[
\chi_{s,t+1}E_t\left(\frac{Q_{t+1}^B}{\tilde Q_{s,t+1}^A}\right)
+\chi_{k,t+1}E_t\left(\frac{Q_{t+1}^B}{P_{t+1}^K/A_{k,t+1}}\right)
+\chi_{b,t+1}
\right]\right\}.
\tag{F26}
```

**金融中介零利润买卖价条件**：

```math
Q_t^B=(1+\tau_t^q)Q_t^A.
\tag{F27}
```

MMB `.mod` 交叉核对使用写成 `exp(Q_t_B) - exp(Q_t_A)*exp(tau_q_t)` 的对数近似，因此实现将 $`\tau_t^q`$ 解释为该方程中的对数楔子。该处与论文记号的差异标记为 `needs_review`。

**最终品对中间品 $`j`$ 的需求**：

```math
Y_t(j)=\left(\frac{P_t(j)}{P_t}\right)^{-\frac{1+\lambda_{p,t}}{\lambda_{p,t}}}Y_t.
\tag{F28}
```

**中间品成本最小化**：

```math
\frac{K_{t-1}}{A_tL_t}=\frac{W_t/P_t}{R_t^K}\frac{1-\eta}{\eta}.
\tag{F29}
```

**实际边际成本**：

```math
mc_t=\frac{1}{(1-\eta)^{1-\eta}\eta^\eta}(R_t^K)^{1-\eta}(W_t/P_t)^\eta.
\tag{F30}
```

**黏性价格 Phillips 曲线，对数线性化实现形式**：

```math
\pi_t-\pi
=\frac{\beta}{1+\iota_p\beta}(\pi_{t+1}-\pi)
+\frac{\iota_p}{1+\iota_p\beta}(\pi_{t-1}-\pi)
+\kappa_p(mc_t-mc)
+(\lambda_{p,t}-\lambda_p),
\tag{F31}
```

其中 $`\kappa_p=\frac{(1-\xi_p\beta)(1-\xi_p)}{\xi_p(1+\iota_p\beta)}`$。

**黏性工资方程，对数线性化实现形式**：

```math
\begin{aligned}
w_t-w={}&\frac{1}{1+\beta}(w_{t-1}-w)+\frac{\beta}{1+\beta}(w_{t+1}-w)
+\frac{\iota_w}{1+\beta}\left[(\pi_{t-1}-\pi)+(z_{t-1}-\gamma)\right]\\
&-\frac{\beta\iota_w+1}{1+\beta}\left[(\pi_t-\pi)+(z_t-\gamma)\right]
+\frac{\beta}{1+\beta}\left[(\pi_{t+1}-\pi)+(z_{t+1}-\gamma)\right]\\
&+\frac{(1-\xi_w\beta)(1-\xi_w)}{1+\beta}
\left[\eta_{\beta,t}-(\lambda_t-\lambda)+\nu(l_t-l)+(\lambda_{w,t}-\lambda_w)-(w_t-w)\right].
\end{aligned}
\tag{F32}
```

**投资品生产者 Tobin's-Q 条件**：

```math
P_t^K
=\frac{1-\beta E_t\left[\frac{\mu_{t+1}^{\Sigma C}}{\mu_t^{\Sigma C}}P_{t+1}^K
S'\left(\frac{I_{t+1}}{I_t}\right)\left(\frac{I_{t+1}}{I_t}\right)^2\right]}
{1-S\left(\frac{I_t}{I_{t-1}}\right)-S'\left(\frac{I_t}{I_{t-1}}\right)\frac{I_t}{I_{t-1}}}.
\tag{F33}
```

## 4. Market Clearing & Identities

**总量权益积累**：

```math
N_t=AI_t+(1-\delta)N_{t-1},
\qquad
AI_t=\int A_{i,t}\iota_{i,t}dF(A_{i,t}).
\tag{F34}
```

**模型资本-权益恒等式**：

```math
K_t=N_t.
\tag{F35}
```

**总量投资品需求**：

```math
\iota_t=\iota_{s,t}+\iota_{k,t}.
\tag{F36}
```

**交易的权益索取权**：

```math
\Delta N_t=\theta\frac{P_t^K}{Q_t^A}\iota_{s,t}
+\phi(1-\delta)\chi_{s,t}N_{t-1}.
\tag{F37}
```

**生产函数**：

```math
Y_t=\left(\frac{K_{t-1}}{z_t}\right)^{1-\eta}L_t^\eta.
\tag{F38}
```

**资源约束 / GDP 恒等式**：

```math
Y_t=C_t+I_t+G_t.
\tag{F39}
```

**政府预算约束**：

```math
B_t+T_t=R_{t-1}^B B_{t-1}+G_t.
\tag{F40}
```

**财政税收反馈规则**：

```math
\frac{T_t/Y_t}{T/Y}=\left(\frac{B_t/Y_t}{B/Y}\right)^{\varphi_B}.
\tag{F41}
```

**Taylor 规则**：

```math
\frac{R_t^B}{R^B}=
\left(\frac{R_{t-1}^B}{R^B}\right)^{\rho_R}
\left[
\left(\frac{\bar\pi_t}{\bar\pi}\right)^{\phi_\pi}
\left(\frac{\Delta\bar Y_t}{\gamma}\right)^{\phi_{DY}}
\right]^{1-\rho_R}
\eta_{mp,t}.
\tag{F42}
```

论文将该规则写成乘法形式。MMB `.mod` 交叉核对将其实现为对数线性利率规则，包含利率平滑、四季度平均通胀、可选产出缺口、GDP 增长响应和货币政策创新。

**融资缺口份额观测方程**：

```math
FGS_t=
\frac{
\int_{P_t^K/Q_t^A}^{\infty}\theta\frac{P_t^K}{Q_t^A}\iota_{i,t}dF(A_{i,t})
+(\chi_{s,t}+\chi_{k,t})\left[Q_t^A\phi(1-\delta)N_t+R_{t-1}^B B_t\right]
}{I_t}\eta_t^{FGS}.
\tag{F43}
```

**企业利差观测方程**：

```math
Sp_t=400\,E_t\left[
\log\left(\frac{R_{t+1}^K+(1-\delta)Q_{t+1}^A}{Q_t^A}\right)-R_t^B
\right]+\eta_t^{Sp}.
\tag{F44}
```

## 5. Exogenous Processes

**偏好冲击**：

```math
\log b_t=\rho_b\log b_{t-1}+\varepsilon_t^b,\qquad
\varepsilon_t^b\sim N(0,\sigma_b^2).
\tag{F45}
```

**持久与暂时金融中介冲击**：

```math
\tau_t^q=\bar\tau_t^q+\tilde\tau_t^q,
\tag{F46}
```

```math
\bar\tau_t^q=(1-\rho_{\bar\tau})\tau_{ss}^q+\rho_{\bar\tau}\bar\tau_{t-1}^q+\varepsilon_t^{\bar\tau},
\tag{F47}
```

```math
\tilde\tau_t^q=\rho_{\tilde\tau}\tilde\tau_{t-1}^q+\varepsilon_t^{\tilde\tau},
\qquad \rho_{\tilde\tau}=\omega_\tau\rho_{\bar\tau}.
\tag{F48}
```

**价格加成冲击**：

```math
\log(1+\lambda_{p,t})=(1-\rho_p)\log(1+\lambda_p)+\rho_p\log(1+\lambda_{p,t-1})
+\varepsilon_t^p+\theta_p\varepsilon_{t-1}^p.
\tag{F49}
```

**劳动增广技术增长**：

```math
\log z_t=(1-\rho_z)\log\gamma+\rho_z\log z_{t-1}+\varepsilon_t^z.
\tag{F50}
```

**工资加成冲击**：

```math
\log(1+\lambda_{w,t})=(1-\rho_w)\log(1+\lambda_w)+\rho_w\log(1+\lambda_{w,t-1})
+\varepsilon_t^w+\theta_w\varepsilon_{t-1}^w.
\tag{F51}
```

**货币政策冲击**：

```math
\log\eta_{mp,t}=\varepsilon_{mp,t}.
\tag{F52}
```

**政府支出份额**：

```math
G_t=\left(1-\frac{1}{g_t}\right)Y_t,
\tag{F53}
```

```math
\log g_t=(1-\rho_g)\log g_{ss}+\rho_g\log g_{t-1}+\varepsilon_t^g.
\tag{F54}
```

MMB 实现交叉核对包含冲击 `eps_z`、`eps_g`、`eps_i`、`eps_tau`、`eps_tau_trans`、`eps_beta`、`eps_p`、`eps_w`，以及测量误差 `eps_meas` 和 `eps_meas_sp`。流动性冲击和技术离散度冲击被注释掉。

## 6. Steady-State Solution

论文说明，均衡条件先通过重缩放继承劳动增广技术 $`A_t`$ 单位根的变量而平稳化，再围绕稳态对数线性化。MinerU 来源中没有完整的论文侧稳态推导；本节因此记录来源支持和实现交叉核对过的稳态结构，并将未解决的闭式细节标为 `needs_review`。

1. 根据校准或估计目标设定稳态增长和通胀：

```math
z=\gamma,\qquad \pi=\pi_{ss},\qquad \eta_{\beta}=0,\qquad \lambda_{p,t}=\lambda_p,\qquad \lambda_{w,t}=\lambda_w.
\tag{F55}
```

2. 按报告的季度毛利率约定计算贴现因子：

```math
\beta=\frac{1}{1+(\beta^{-1}-1)}.
\tag{F56}
```

3. 设定稳态金融中介楔子和政府份额：

```math
\tau_q=\tau_{q,ss},\qquad g=g_{ss},\qquad G=\left(1-\frac{1}{g_{ss}}\right)Y.
\tag{F57}
```

4. 使用金融中介条件确定稳态价格楔子：

```math
Q^B=(1+\tau_q)Q^A.
\tag{F58}
```

在 MMB 对数实现中，交叉核对形式为 $`Q^B=Q^A\exp(\tau_q)`$；这是实现约定，推广前需要来源复核。

5. 使用对数正态阈值 $`P^K/Q^A`$ 和 $`P^K/Q^B`$ 计算 $`\chi_s`$、$`\chi_k`$ 和 $`\chi_b`$，然后用 (F11) 与 (F13) 聚合卖方和保留者投资。

6. 在稳态中使用 $`N=K`$、权益积累以及 $`S=S'=0`$ 的投资品技术：

```math
\iota=I,\qquad N=AI+(1-\delta)N/z.
\tag{F59}
```

7. 使用生产函数、要素条件和边际成本方程：

```math
Y=(K/z)^{1-\eta}L^\eta,\qquad
\frac{K/z}{L}=\frac{W/P}{R^K}\frac{1-\eta}{\eta},\qquad
mc=\frac{(R^K)^{1-\eta}(W/P)^\eta}{(1-\eta)^{1-\eta}\eta^\eta}.
\tag{F60}
```

8. 使用资源约束得到消费：

```math
C=Y-I-G.
\tag{F61}
```

9. 使用政府预算和财政反馈规则确定 $`B`$、$`T`$、债务产出比和税收产出比：

```math
B+T=R^B B+G,\qquad
\frac{T/Y}{T/Y}=\left(\frac{B/Y}{B/Y}\right)^{\varphi_B}=1.
\tag{F62}
```

10. 论文校准或估计的若干矩和参数包括 $`FGS_{ss}=0.35`$、$`B/Y=0.02`$、$`g_{ss}=0.17`$、$`\tau_{q,ss}\times100=3.52`$、$`\theta=0.677`$、$`\sigma_A=0.0147`$、$`h=0.843`$、$`\delta=0.025`$，以及 15% 的价格和工资加成。

`needs_review`：完整且经来源核对的闭式稳态需要在线附录中的家庭积分和稳定化推导。本条目不应直接视为可编写 `steady_state_model` 的最终版本。

## 7. Timing & Form Conventions

- **存量时点**：物质资本/权益 $`K_t=N_t`$ 是期末存量。第 $`t`$ 期生产使用预定的 $`K_{t-1}`$，这一点体现在论文生产函数以及实现项 `Kbar(-1)/exp(z_t)` 和 `N_t(-1)/exp(z_t)` 中。
- **权益交易**：权益买卖发生在第 $`t`$ 期技术抽样之后。卖方面临包含当期投资购买和既有权益可转售部分的约束。
- **债券时点**：第 $`t-1`$ 期购买的政府债券在第 $`t`$ 期支付 $`R_{t-1}^B B_{t-1}`$。
- **价格记号**：$`Q_t^A`$ 是卖方收到的 bid/resale 价格；$`Q_t^B`$ 是买方支付的 ask/purchase 价格。
- **平稳化**：继承劳动增广增长的总量变量在求对数线性解之前被重缩放。实现对许多实际变量使用对数变量，并将预定存量除以 `exp(z_t)`。
- **模型形式**：对数线性/平稳估计模型。论文求解对数线性理性预期系统，`.mod` 使用对数变量和围绕 `steady_state(...)` 的偏离方程。
- **验证**：未运行 Dynare。运行时验证状态为 `not_performed`。

## 8. Variable & Parameter Reference Table

### 内生变量

| 类别 | 符号 / ASCII | 含义 | 主要方程 |
|---|---|---|---|
| 内生 | $`AI_t`$ / `AI` | 总量安装投资技术积分 | (F34) |
| 内生 | $`AIK_t`$ / `AIK` | $`AI_t`$ 的保留者部分 | (F13), (F34) |
| 内生 | $`AIS_t`$ / `AIS` | $`AI_t`$ 的卖方部分 | (F11), (F34) |
| 内生 | $`A^{eff}_t`$ / `A_eff` | 有效投资技术 | (F36) |
| 内生 | $`B_t`$ / `B_t` | 政府债券 | (F40), (F41) |
| 内生 | $`C_t`$ / `chat` | 消费 | (F21), (F39) |
| 内生 | $`D_t`$ / `D_t` | 分红和返还 | (F2), 企业利润 |
| 内生 | $`\Delta N_t`$ / `Delta_N` | 交易的权益索取权 | (F37) |
| 内生 | $`FGS_t`$ / `FGS` | 融资缺口份额 | (F43) |
| 内生 | $`GDP_t`$ / `GDP_t` | GDP 观测恒等式 | (F39) |
| 内生 | $`I_t`$ / `Ihat` | 总量投资 | (F18), (F33), (F39) |
| 内生 | $`K_t`$ / `Kbar` | 资本/权益存量 | (F35), (F38) |
| 内生 | $`L_t`$ / `l` | 工时 | (F20), (F32), (F38) |
| 内生 | $`mc_t`$ / `mchat` | 实际边际成本 | (F30), (F31) |
| 内生 | $`N_t`$ / `N_t` | 权益存量 | (F34), (F35) |
| 内生 | $`P_t^K`$ / `QK` | 投资品价格 | (F33) |
| 内生 | $`Q_t^A`$ / `Q_t_A` | 权益卖出/bid 价格 | (F27), (F43), (F44) |
| 内生 | $`Q_t^B`$ / `Q_t_B` | 权益买入/ask 价格 | (F22), (F27) |
| 内生 | $`R_t^B`$ / `i_t` | 名义政策/无风险利率 | (F26), (F42) |
| 内生 | $`R_t^K`$ / `rK` | 资本回报 | (F22)-(F25), (F29), (F44) |
| 内生 | $`r_t`$ / `r` | 实际无风险利率 | (F26), 实现 |
| 内生 | $`\pi_t`$ / `pi_t` | 通胀 | (F31), (F42) |
| 内生 | $`\tau_t^q`$ / `tau_q_t` | 金融中介楔子 | (F46)-(F48) |
| 内生 | $`T_t`$ / `T_t` | 一次总付税 | (F40), (F41) |
| 内生 | $`W_t/P_t`$ / `what_t` | 实际工资 | (F29), (F32) |
| 内生 | $`Y_t`$ / `yhat` | 产出 | (F38), (F39) |
| 内生 | $`z_t`$ / `z_t` | TFP 增长 | (F50) |

### 外生创新

| 符号 / ASCII | 含义 |
|---|---|
| $`\varepsilon_t^z`$ / `eps_z` | TFP 增长创新 |
| $`\varepsilon_t^g`$ / `eps_g` | 政府支出创新 |
| $`\varepsilon_t^{mp}`$ / `eps_i` | 货币政策创新 |
| $`\varepsilon_t^{\bar\tau}`$ / `eps_tau` | 持久金融中介创新 |
| $`\varepsilon_t^{\tilde\tau}`$ / `eps_tau_trans` | 暂时金融中介创新 |
| $`\varepsilon_t^b`$ / `eps_beta` | 偏好/贴现因子创新 |
| $`\varepsilon_t^p`$ / `eps_p` | 价格加成创新 |
| $`\varepsilon_t^w`$ / `eps_w` | 工资加成创新 |
| $`\eta_t^{FGS}`$ / `eps_meas` | 融资缺口测量误差 |
| $`\eta_t^{Sp}`$ / `eps_meas_sp` | 利差测量误差 |

### 参数

| 符号 / ASCII | 含义 |
|---|---|
| $`\beta`$ / `bet_s` conversion | 贴现因子 |
| $`\delta`$ / `delta` | 资本折旧 |
| $`\nu`$ / `nu` | Frisch 弹性倒数 |
| $`h`$ / `h` | 习惯持续性 |
| $`\eta`$ / `eta` | 生产函数劳动指数 |
| $`\lambda_p,\lambda_w`$ / `lambda_p`, `lambda_w` | 价格和工资加成 |
| $`\xi_p,\xi_w`$ / `xi_p`, `xi_w` | Calvo 价格和工资刚性 |
| $`\iota_p,\iota_w`$ / `iota_p`, `iota_w` | 价格和工资指数化 |
| $`\mu_A,\sigma_A`$ / `mu_ss`, `sg_ss` | 异质技术分布 |
| $`FGS_{ss}`$ / `fgs_param` | 稳态融资缺口份额 |
| $`\theta`$ / `theta` | 抵押约束 |
| $`\phi`$ / `phi_t` | 既有索取权可转售性/流动性 |
| $`B/Y`$ / `Bs_ss` | 稳态流动性/GDP |
| $`g_{ss}`$ / `gs_ss` | 政府支出份额过程参数 |
| $`\tau_{q,ss}`$ / `etau_q_ss` | 稳态金融中介成本 |
| $`\theta_I`$ / `theta_I` | 投资调整成本曲率 |
| $`\pi_{ss}`$ / `pis` | 稳态通胀 |
| $`\rho_R,\phi_\pi,\phi_{DY},\phi_{Ygap}`$ / `rho_i`, `phi_pi`, `phi_DY`, `phi_Ygap` | 货币政策规则系数 |
| $`\varphi_B`$ / `tB` | 财政债务反馈 |
| $`\rho_z,\rho_g,\rho_{\bar\tau},\omega_\tau,\rho_b,\rho_p,\rho_w`$ | 外生过程持续性参数 |
| $`\sigma_z,\sigma_g,\sigma_i,\sigma_{\bar\tau},\sigma_{\tilde\tau},\sigma_b,\sigma_p,\sigma_w`$ | 结构冲击标准差 |
