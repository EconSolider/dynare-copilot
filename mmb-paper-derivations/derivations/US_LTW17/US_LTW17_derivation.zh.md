# US_LTW17 推导 - Leeper、Traum 和 Walker (2017)

来源：Eric M. Leeper, Nora Traum, and Todd B. Walker (2017), "Clearing Up the Fiscal Multiplier Morass," *American Economic Review* 107(8), 2409-2454。DOI: `10.1257/aer.20111196`。

模型 ID：`US_LTW17`。状态：`needs_review`。

## 1. Model Overview

- **模型**：估计的美国货币 DSGE 模型，包含详细财政部门、长期名义政府债务、稳态扭曲性税收、效用中的政府消费，以及 `US_LTW17` 实现变体中的主动货币/被动财政政策。
- **主体与部门**：最终品生产者、垄断竞争中间品企业、劳动中介、储蓄家庭、非储蓄家庭、货币当局和财政当局。
- **财政结构**：政府支出、转移支付、资本税、劳动税、消费税、长期名义债务和初级盈余恒等式。
- **形式**：`model(linear)`。论文描述 DSGE 模型及其对数线性解；MMB 实现交叉检查确认使用 `model (linear)`。除非明确说明为水平变量或稳态对象，下列方程中的变量均为相对平衡增长稳态的百分比/对数偏离。
- **运行验证**：未执行。没有运行 Dynare。
- **来源边界**：论文侧 Markdown 是数学来源。`.agents/skills/dynare-copilot/references/examples/US_LTW17_rep.mod` 仅作为 `implementation_cross_check` 使用。

## 2. Optimization Problems

### 最终品生产者

最终品生产者聚合差异化中间品：

\[
Y_t =
\left(\int_0^1 Y_t(i)^{\frac{1}{1+\eta_t^p}}\,di\right)^{1+\eta_t^p}.
\]

利润最大化给出商品 \(i\) 的需求：

\[
Y_t(i)=Y_t\left(\frac{P_t(i)}{P_t}\right)^{-\frac{1+\eta_t^p}{\eta_t^p}}.
\]

### 中间品企业

中间品企业 \(i\) 使用资本和劳动生产：

\[
\bar{Y}_t(i)=\bar{K}_t(i)^\alpha (A_t L_t(i))^{1-\alpha}-A_t\Omega.
\]

成本最小化意味着共同的名义边际成本：

\[
MC_t=(1-\alpha)^{\alpha-1}\alpha^{-\alpha}(R_t^k)^\alpha W_t^{1-\alpha}A_t^{-1+\alpha}.
\]

Calvo 定价企业以概率 \(1-\omega_p\) 重新优化。不能重设价格的企业按权重 \(\chi_p\) 对滞后通胀指数化。Markdown 来源中的重设价格问题为：

\[
E_t\sum_{s=0}^{\infty}(\beta\omega_p)^s\frac{\lambda_{t+s}}{\lambda_t}
\left[
\left(\prod_{k=1}^s \pi_{t+k-1}^{\chi_p}\pi^{1-\chi_p}\right)P_t(i)Y_{t+s}(i)
-MC_{t+s}Y_{t+s}(i)
\right].
\]

### 劳动中介与工资设定者

竞争性劳动中介聚合差异化劳动服务，并推导每种劳动的需求。储蓄家庭以概率 \(1-\omega_w\) 最优重设工资；非储蓄家庭遵循储蓄家庭设定的平均工资。不能重设工资者对过去通胀和趋势增长进行指数化。因此下方工资 Phillips 方程被视为来源支持的模型模块，但一阶代数仍标记为 `needs_review`。

### 储蓄家庭

储蓄家庭 \(j\) 从复合消费和闲暇中获得效用：

\[
E_0\sum_{t=0}^{\infty}\beta^t u_t^b
\left[
\log\left(C_t^{\astS}(j)-\theta \tilde{C}_{t-1}^{\astS}\right)
-\frac{(L_t^S(j))^{1+\xi}}{1+\xi}
\right],
\]

其中

\[
C_t^{\astS}(j)=C_t^S(j)+\alpha_G G_t.
\]

储蓄家庭选择消费、名义私人债券、长期政府债券、投资、资本利用率和资本积累，并受到名义预算约束、资本运动方程和利用成本约束。来源 Markdown 给出了预算约束和资本积累方程；下方若干 FOC 标记为 `needs_review`，因为本地来源没有提供清晰的附录推导。

### 非储蓄家庭

非储蓄家庭消费当期可支配收入：

\[
(1+\tau_t^C)P_t C_t^N(j)
=(1-\tau_t^L)\int_0^1 W_t(l)L_t^N(j,l)\,dl+P_tZ_t^N(j).
\]

### 政府与政策当局

货币当局通过 Taylor 规则设定名义利率。财政当局使用长期名义债务和税收收入为政府消费、转移支付和债务服务融资，财政工具对滞后的债务市值与 GDP 之比作出反应。

## 3. First-Order Conditions

以下条件在有助于核对时使用 `US_LTW17` 实现中的变量名。由于本地论文 Markdown 没有为每个一阶条件提供清晰的附录推导，由实现确认的线性方程标记为 `needs_review`。

- **(F1) 生产函数**：

\[
y_t-\frac{\bar{Y}+\bar{\Omega}}{\bar{Y}}\alpha k_t
-\frac{\bar{Y}+\bar{\Omega}}{\bar{Y}}(1-\alpha)l_t=0.
\]

- **(F2) 要素价格关系**：

\[
rk_t-w_t+k_t-l_t=0.
\]

- **(F3) 实际边际成本**：

\[
mc_t-\alpha rk_t+(\alpha-1)w_t=0.
\]

- **(F4) 价格 Phillips 方程**（`needs_review` OCR/代数）：

\[
\lambda_p \pi_t-\frac{\lambda_p\beta}{1+\beta\chi_p}\pi_{t+1}
-mc_t-\lambda_p u_t^p
=\frac{\lambda_p\chi_p}{1+\beta\chi_p}\pi_{t-1}.
\]

- **(F5) 储蓄家庭财富边际效用**（`needs_review`）：

\[
\lambda_t+\frac{\theta}{e^\gamma-\theta}u_t^a
+\frac{e^\gamma}{e^\gamma-\theta}c_t^{\ast}
-u_t^b+\frac{\bar{\tau}^C}{1+\bar{\tau}^C}\tau_t^C
=\frac{\theta}{e^\gamma-\theta}c_{t-1}^{\ast}.
\]

- **(F6) 长期实际利率**：

\[
r_t^L+P_t^B-\frac{\beta\rho}{e^\gamma}r_{t+1}^L
-\frac{\beta\rho}{e^\gamma}P_{t+1}^B+\pi_{t+1}=0.
\]

- **(F7) 长期通胀率**：

\[
\pi_t^L+P_t^B+r_t^L=0.
\]

- **(F8) 进入效用的消费**：

\[
c_t^{\ast}-\frac{\bar{C}^S}{\bar{C}^S+\alpha_G\bar{G}}c_t^S
-\frac{\alpha_G\bar{G}}{\bar{C}^S+\alpha_G\bar{G}}g_t=0.
\]

- **(F9) 储蓄家庭 Euler 方程**（`needs_review`）：

\[
\lambda_t-R_t+\pi_{t+1}-\lambda_{t+1}+\rho_a u_t^a=0.
\]

- **(F10) 资本利用率**：

\[
\frac{1-\psi}{\psi}rk_t-v_t
-\frac{1-\psi}{\psi}\frac{\bar{\tau}^K}{1-\bar{\tau}^K}\tau_t^K=0.
\]

- **(F11) 资本 FOC**（`needs_review`）：

\[
q_t+R_t-\pi_{t+1}
-\beta e^{-\gamma}(1-\delta)q_{t+1}
-\beta e^{-\gamma}\bar{R}^k(1-\bar{\tau}^K)rk_{t+1}
+\bar{\tau}^K\beta e^{-\gamma}\bar{R}^k\tau_{t+1}^K=0.
\]

- **(F12) 投资 FOC**（`needs_review`）：

\[
-\frac{1}{(1+\beta)s e^{2\gamma}}q_t+i_t
-\frac{\beta}{1+\beta}i_{t+1}
+\frac{1-\beta\rho_a}{1+\beta}u_t^a-u_t^i
=\frac{1}{1+\beta}i_{t-1}.
\]

- **(F13) 有效资本**：

\[
k_t-v_t+u_t^a=\bar{k}_{t-1}.
\]

- **(F14) 物质资本运动方程**：

\[
\bar{k}_t-\left[1-(1-\delta)e^{-\gamma}\right](1+\beta)s e^{2\gamma}u_t^i
-\left[1-(1-\delta)e^{-\gamma}\right]i_t
+(1-\delta)e^{-\gamma}u_t^a
=(1-\delta)e^{-\gamma}\bar{k}_{t-1}.
\]

- **(F15) 工资 Phillips 方程**（`needs_review`）：

\[
\begin{aligned}
(1+\lambda_w)w_t
&-\lambda_w\frac{\beta}{1+\beta}w_{t+1}
+\lambda_w\frac{1+\beta\chi_w}{1+\beta}\pi_t
-\lambda_w\frac{\beta}{1+\beta}\pi_{t+1}
-\xi l_t+\lambda_t \\
&+\lambda_w\frac{1+\beta\chi_w-\rho_a\beta}{1+\beta}u_t^a
-\frac{\bar{\tau}^L}{1-\bar{\tau}^L}\tau_t^L
-\lambda_w u_t^w-u_t^b \\
&=\frac{\lambda_w}{1+\beta}w_{t-1}
+\frac{\lambda_w\chi_w}{1+\beta}\pi_{t-1}
+\frac{\lambda_w\chi_w}{1+\beta}u_{t-1}^a .
\end{aligned}
\]

## 4. Market Clearing & Identities

- **(F16) 总量资源约束**：

\[
\bar{C}c_t+\bar{I}i_t-\bar{Y}y_t+\bar{s}_G\bar{Y}g_t+\psi_1\bar{K}v_t=0.
\]

- **(F17) 非储蓄家庭预算约束**：

\[
\bar{C}^N(1+\bar{\tau}^C)c_t^N+\bar{\tau}^C\bar{C}^N\tau_t^C
-\bar{W}\bar{L}(1-\bar{\tau}^L)w_t
-\bar{W}\bar{L}(1-\bar{\tau}^L)l_t
+\bar{W}\bar{L}\bar{\tau}^L\tau_t^L-\bar{Z}z_t=0.
\]

- **(F18) 消费加总**：

\[
\bar{C}c_t-(1-\mu)\bar{C}^S c_t^S-\mu\bar{C}^N c_t^N=0.
\]

- **(F19) 长期政府债券价格**：

\[
R_t-\frac{\rho \bar{P}^B}{1+\rho\bar{P}^B}P_{t+1}^B+P_t^B=0.
\]

- **(F20) 政府预算约束**（`needs_review`）：

\[
\begin{aligned}
\bar{s}_b b_t-\bar{s}_G g_t-\frac{\bar{Z}}{\bar{Y}}z_t
&+\bar{\tau}^K\bar{r}^k\bar{k}_y(\tau_t^K+rk_t+k_t)
+\bar{s}_b\beta^{-1}u_t^a \\
&+\bar{\tau}^L\bar{w}\bar{l}_y(\tau_t^L+w_t+l_t)
+\bar{\tau}^C\bar{c}_y(c_t+\tau_t^C)
-\bar{s}_b\rho e^{-\gamma}P_t^B+\bar{s}_b\beta^{-1}\pi_t \\
&=\bar{s}_b\beta^{-1}b_{t-1}-\bar{s}_b\beta^{-1}P_{t-1}^B.
\end{aligned}
\]

- **(F21) Fisher 方程**：

\[
r_t-R_t+\pi_{t+1}=0.
\]

- **(F22) 债务产出比**：

\[
s_t^b+y_t-b_t=0.
\]

- **(F23) 消费税收入**：

\[
T_t^C-\tau_t^C-c_t=0.
\]

- **(F24) 资本税收入**：

\[
T_t^K-\tau_t^K-rk_t-k_t=0.
\]

- **(F25) 长债回报定义**：

\[
r_t^b-\frac{\rho\beta}{e^\gamma}P_t^B+\pi_t=-P_{t-1}^B.
\]

- **(F26) 初级盈余定义**：

\[
\begin{aligned}
S_t
&-\frac{\bar{\tau}^K\bar{r}^k\bar{k}}{\bar{S}}(\tau_t^K+rk_t+k_t)
-\frac{\bar{\tau}^L\bar{w}\bar{l}}{\bar{S}}(\tau_t^L+w_t+l_t)
-\frac{\bar{\tau}^C\bar{C}}{\bar{S}}(\tau_t^C+c_t) \\
&+\frac{\bar{Z}}{\bar{S}}z_t+\frac{\bar{G}}{\bar{S}}g_t=0.
\end{aligned}
\]

- **(F27) 劳动税收入**：

\[
T_t^L-\tau_t^L-w_t-l_t=0.
\]

- **(F28) 可观测消费增长**：

\[
c_t^{obs}-100c_t-100u_t^a=-100c_{t-1}.
\]

- **(F29) 可观测投资增长**：

\[
i_t^{obs}-100i_t-100u_t^a=-100i_{t-1}.
\]

- **(F30) 可观测政府支出增长**：

\[
g_t^{obs}-100g_t-100u_t^a=-100g_{t-1}.
\]

- **(F31) 可观测工资增长**：

\[
w_t^{obs}-100w_t-100u_t^a=-100w_{t-1}.
\]

- **(F32) 可观测债务增长**：

\[
b_t^{obs}-100b_t-100u_t^a=-100b_{t-1}.
\]

- **(F33) 可观测名义利率**：

\[
R_t^{obs}-100R_t=0.
\]

- **(F34) 可观测通胀**：

\[
\Pi_t^{obs}-100\pi_t=0.
\]

- **(F35) 可观测工时**：

\[
L_t^{obs}-100l_t=0.
\]

## 5. Exogenous Processes

- **(F36) 货币政策规则**：

\[
R_t-(1-\rho_R)\phi_\pi\pi_t-(1-\rho_R)\phi_y y_t-u_t^m=\rho_R R_{t-1}.
\]

- **(F37) 政府支出规则**：

\[
g_t-u_t^G=\rho_G g_{t-1}-(1-\rho_G)\gamma_G s_{t-1}^b.
\]

- **(F38) 资本税规则**：

\[
\tau_t^K=(1-\rho_K)\gamma_K s_{t-1}^b+\rho_K\tau_{t-1}^K.
\]

- **(F39) 劳动税规则**：

\[
\tau_t^L=(1-\rho_L)\gamma_L s_{t-1}^b+\rho_L\tau_{t-1}^L.
\]

- **(F40) 消费税规则**：

\[
\tau_t^C=\rho_C\tau_{t-1}^C.
\]

- **(F41) 转移支付规则**：

\[
z_t-u_t^Z=-(1-\rho_Z)\gamma_Z s_{t-1}^b+\rho_Zz_{t-1}.
\]

- **(F42) 政府支出冲击**：

\[
u_t^G=\rho_{eG}u_{t-1}^G+\varepsilon_t^G.
\]

- **(F43) 转移支付冲击**：

\[
u_t^Z=\rho_{eZ}u_{t-1}^Z+\varepsilon_t^Z.
\]

- **(F44) 技术增长冲击**：

\[
u_t^a=\rho_a u_{t-1}^a+\varepsilon_t^a.
\]

- **(F45) 偏好冲击**：

\[
u_t^b=\rho_b u_{t-1}^b+\varepsilon_t^b.
\]

- **(F46) 货币政策冲击**：

\[
u_t^m=\rho_{em}u_{t-1}^m+\sigma_m\varepsilon_t^m.
\]

- **(F47) 投资冲击**：

\[
u_t^i=\rho_i u_{t-1}^i+\varepsilon_t^i.
\]

- **(F48) 工资加成冲击**：

\[
u_t^w=\rho_w u_{t-1}^w+\varepsilon_t^w.
\]

- **(F49) 价格加成冲击**：

\[
u_t^p=\rho_p u_{t-1}^p+\varepsilon_t^p.
\]

## 6. Steady-State Solution

由于 `US_LTW17` 以 `model(linear)` 实现，动态模型变量是相对平衡增长稳态的偏离，在线性模型块中的稳态为零。所需的非零常数在模型块之前计算，并作为系数使用。

来自实现交叉检查的稳态构造：

1. 设定 \(\beta=0.99\)、\(\delta=0.025\)、\(\alpha=0.33\)、\(\pi=1\)，并使用美国数据中的财政份额：\(\bar{s}_G=0.11\)、\(\bar{s}_b=1.47\)、\(\bar{\tau}^L=0.186\)、\(\bar{\tau}^K=0.218\)、\(\bar{\tau}^C=0.023\)。
2. 将估计的稳态增长 `gamm100` 转换为 \(\gamma\)，设定 \(e^\gamma\)，并计算 \(\bar{R}=e^\gamma/\beta\)。
3. 使用政府债务久期 \(AD\) 计算到期衰减和长期债券价格：\(\rho=(1-1/AD)/\beta\)，\(\bar{P}^B=1/(\bar{R}-\rho)\)。
4. 计算租赁回报和边际成本：

\[
\bar{R}^k=\frac{e^\gamma/\beta-1+\delta}{1-\bar{\tau}^K},
\qquad
\bar{mc}=\frac{1}{1+\eta_p}.
\]

5. 按实现中的递归顺序求解工资、资本劳动比、固定成本、产出劳动比、投资劳动比、消费劳动比、转移支付、储蓄/非储蓄消费以及劳动尺度。这些步骤属于 `implementation_cross_check`，并且相对于论文侧附录仍为 `needs_review`。
6. 在线性稳态中，将所有创新和模型偏离设为零。未执行运行验证。

## 7. Timing & Form Conventions

- **形式**：`model(linear)`。模型块中的变量是稳态偏离，不是非线性水平。
- **增长调整**：论文含有永久技术 \(A_t\)；实现使用增长调整后的变量和包含 \(e^\gamma\) 的稳态系数。
- **资本时序**：有效资本 \(k_t\) 取决于利用率 \(v_t\)、技术增长 \(u_t^a\) 和滞后物质资本 \(\bar{k}_{t-1}\)。物质资本 \(\bar{k}_t\) 通过 (F14) 预定。
- **债务时序**：政府预算约束使用滞后债务和滞后债券价格；财政规则响应 \(s_{t-1}^b\)。
- **债券期限**：长期名义债务以 \(\rho\) 衰减，久期为 \((1-\beta\rho)^{-1}\)。
- **政策制度**：此 `US_LTW17` 实现交叉检查设置了基准模型的主动货币/被动财政系数。其他同论文归档 ID（`US_LTW17gz`、`US_LTW17nu`、`US_LTW17rot`）不应并入本条目。

## 8. Variable & Parameter Reference Table

| 类别 | 符号 / ASCII 名 | 含义 | 主要方程 |
|---|---|---|---|
| 内生 | `cs` / \(c_t^S\) | 储蓄家庭消费 | (F9), (F18) |
| 内生 | `cn` / \(c_t^N\) | 非储蓄家庭消费 | (F17), (F18) |
| 内生 | `R` / \(R_t\) | 名义利率 | (F36) |
| 内生 | `i` / \(i_t\) | 投资 | (F12), (F16) |
| 内生 | `k` / \(k_t\) | 有效资本 | (F13) |
| 内生 | `v` / \(v_t\) | 利用率 | (F10) |
| 内生 | `l` / \(l_t\) | 劳动 | (F1), (F15) |
| 内生 | `y` / \(y_t\) | 产出 | (F1), (F16) |
| 内生 | `gc` / \(g_t\) | 政府消费 | (F37) |
| 内生 | `c` / \(c_t\) | 总消费 | (F18) |
| 内生 | `q` / \(q_t\) | 投资乘子/Tobin's Q | (F11), (F12) |
| 内生 | `rk` / \(rk_t\) | 私人资本实际回报 | (F2), (F11) |
| 内生 | `w` / \(w_t\) | 实际工资 | (F2), (F15) |
| 内生 | `pi` / \(\pi_t\) | 通胀 | (F4), (F21) |
| 内生 | `b` / \(b_t\) | 政府债务 | (F20), (F22) |
| 内生 | `sb` / \(s_t^b\) | 债务产出比 | (F22) |
| 内生 | `tauk`, `taul`, `tauc` | 资本、劳动、消费税率 | (F38)-(F40) |
| 内生 | `r` / \(r_t\) | 实际利率 | (F21) |
| 内生 | `z` / \(z_t\) | 转移支付 | (F41) |
| 内生 | `mc` / \(mc_t\) | 实际边际成本 | (F3), (F4) |
| 内生 | `kbar` / \(\bar{k}_t\) | 物质资本 | (F14) |
| 内生 | `lambda` / \(\lambda_t\) | 财富边际效用 | (F5), (F9) |
| 内生 | `Pb` / \(P_t^B\) | 长期债券价格 | (F19), (F20) |
| 内生 | `cstar` / \(c_t^{\ast}\) | 进入效用的消费 | (F8) |
| 内生 | `piL`, `rL` | 长期通胀和实际利率 | (F6), (F7) |
| 内生 | `S`, `rb`, `Tk`, `Tl`, `Tc` | 盈余、债券回报、税收收入 | (F23)-(F27) |
| 可观测 | `cobs`, `iobs`, `gcobs`, `wobs`, `bobs`, `Robs`, `Piobs`, `Lobs` | 测量方程 | (F28)-(F35) |
| 冲击状态 | `ugc`, `uz`, `ua`, `ub`, `um`, `ui`, `uw`, `up` | 财政、偏好、技术、货币、投资、加成冲击 | (F42)-(F49) |
| 外生创新 | `eugc`, `euz`, `eua`, `eub`, `eum`, `eui`, `euw`, `eup` | 结构创新 | (F42)-(F49) |
| 参数 | `bet`, `delt`, `alph`, `etaw`, `etap`, `xi`, `muHH`, `omegaw`, `omegap`, `gpsi`, `s`, `chiw`, `chip`, `phipi`, `phiy` | 偏好、技术、名义/实际刚性、政策系数 | - |
| 参数 | `gammgc`, `gammtk`, `gammtl`, `gammz`, `rhoa`, `rhob`, `rhor`, `rhoi`, `rhow`, `rhop`, `rhogc`, `rhotk`, `rhotl`, `rhotc`, `rhoz` | 财政和冲击持续性/反馈 | - |
| 参数 | 以 `ss` 结尾的稳态块名称 | 线性化模型的系数值 | (F1)-(F49) |

第一遍方程覆盖：本推导包含 49 个编号条件。实现还包含前瞻变量的期望辅助恒等式；这些没有作为单独经济条件列出，仍属于 `implementation_cross_check`。
