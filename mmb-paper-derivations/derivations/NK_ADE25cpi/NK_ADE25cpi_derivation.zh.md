# NK_ADE25cpi -- 推导（最优化问题 + 一阶条件）

> 归档状态：`needs_review`。本文件是一版初稿，依据主文 Markdown 和作者网站在线附录整理。未执行运行时验证。

来源：Auray, Stephane; Devereux, Micheal; Eyquem, Aurelien (2025), "Trade Wars and the Optimal Design of Monetary Rules," *Journal of Monetary Economics*, DOI `10.1016/j.jmoneco.2024.103726`。

模型 ID：`NK_ADE25cpi`。MMB 实现交叉检查显示，它是 `NK_ADE25` 的 CPI 目标规则版本；PPI 目标规则对应的相邻模型是 `NK_ADE25ppi`。

## 1. Model Overview

- **模型**：两国开放经济新凯恩斯模型，含内生进口关税、生产者货币定价、Rotemberg 价格调整成本、消费和中间品的本国偏好、国际债券交易以及垄断扭曲。
- **政策实验**：贸易政策当局在无承诺条件下选择 Nash 关税。货币政策遵循通胀目标型利率规则。在 `NK_ADE25cpi` 中，目标通胀指数是 CPI 通胀。
- **主体**：本国和外国家庭消费本国产品及进口品、供给劳动并交易债券；垄断竞争厂商以本币设定价格；政府返还关税收入并设定关税；央行设定名义利率。
- **形式**：围绕稳态求解的非线性均衡系统，用于一阶模拟和最优控制比较。下列方程不是手工对数线性化版本。
- **来源说明**：主文说明完整两国均衡系统在 Online Appendix C。附录 PDF 给出方程 (C.1)-(C.54)；标记为 `needs_review` 的公式在推广前应对照 PDF 排版公式复核。

## 2. Optimization Problems

### 2.1 本国家庭

本国家庭选择本国品消费、进口品消费、劳动和债券头寸：

\[
\max_{\{C_{h,t},C_{f,t},H_t,B_t,B_t^{\ast}\}} E_t\sum_{j=0}^{\infty}\beta^j
\left(\frac{C_{t+j}^{1-\sigma}}{1-\sigma}-\chi\frac{H_{t+j}^{1+\psi}}{1+\psi}\right)
\]

约束为 CES 消费聚合器和预算约束：

\[
C_t=\left[\gamma^{1/\lambda}C_{h,t}^{1-1/\lambda}+(1-\gamma)^{1/\lambda}C_{f,t}^{1-1/\lambda}\right]^{1/(1-1/\lambda)}
\]

\[
S_tB_t^{\ast}+B_t+P_{h,t}C_{h,t}+(1+\tau_t)S_tP_{f,t}^{\ast}C_{f,t}+P_t\Lambda_t
=S_tB_{t-1}^{\ast}R_{t-1}^{\ast}+B_{t-1}R_{t-1}+W_tH_t+\Pi_t+TR_t .
\]

### 2.2 外国家庭

外国家庭对 \(C_t^{\ast}\) 和 \(H_t^{\ast}\) 具有对称偏好，消费聚合器为：

\[
C_t^{\ast}=\left[\gamma^{\ast1/\lambda}C_{f,t}^{\ast1-1/\lambda}+(1-\gamma^{\ast})^{1/\lambda}C_{h,t}^{\ast1-1/\lambda}\right]^{1/(1-1/\lambda)} .
\]

在 Appendix C 中，外国家庭持有本币债券，且不承担本国家庭的调整成本。Appendix D 为美中量化实验修改债券计价货币结构；这一变体问题记录在 `extraction_notes.md`。

### 2.3 本国厂商

每个本国生产者在需求 \(Y_t(i)=(P_{h,t}(i)/P_{h,t})^{-\epsilon}Y_t\) 和生产函数下选择要素投入与价格 \(P_{h,t}(i)\)：

\[
Y_t(i)=A_tH_t(i)^{1-\alpha}X_t(i)^\alpha .
\]

中间品聚合器为：

\[
X_t(i)=\left[\gamma_x^{1/\lambda}X_{h,t}(i)^{1-1/\lambda}
+(1-\gamma_x)^{1/\lambda}X_{f,t}(i)^{1-1/\lambda}\right]^{1/(1-1/\lambda)} .
\]

Rotemberg 定价问题最大化扣除价格调整成本后的预期贴现利润：

\[
E_t\sum_{j=0}^{\infty}\omega_{t+j}
\left[\Pi_{t+j}(i)-\frac{\phi}{2}\left(\frac{P_{h,t+j}(i)}{P_{h,t+j-1}(i)}-1\right)^2P_{h,t+j}(i)Y_{t+j}(i)\right].
\]

外国厂商求解对称问题。

### 2.4 贸易与货币当局

在相机抉择贸易政策下，本国在给定未来政策的条件下选择 \(\tau_t\)，最大化家庭福利并满足均衡系统；外国对称地选择 \(\tau_t^{\ast}\)。在 `NK_ADE25cpi` 版本中，各央行通过利率规则目标 CPI 通胀，而不是 PPI 通胀。

## 3. First-Order Conditions

### 家庭与需求

- **(F1) 本国消费价格指数**：

\[
P_t=\left[\gamma P_{h,t}^{1-\lambda}+(1-\gamma)\left((1+\tau_t)S_tP_{f,t}^{\ast}\right)^{1-\lambda}\right]^{1/(1-\lambda)} .
\]

- **(F2) 本国对本国品的需求**：

\[
C_{h,t}=\gamma\left(\frac{P_{h,t}}{P_t}\right)^{-\lambda}C_t .
\]

- **(F3) 本国对进口品的需求**：

\[
C_{f,t}=(1-\gamma)\left(\frac{(1+\tau_t)S_tP_{f,t}^{\ast}}{P_t}\right)^{-\lambda}C_t .
\]

- **(F4) 本币债券的本国家庭 Euler 方程**：

\[
\beta E_t\left[\frac{R_tP_tC_t^\sigma}{\pi_{h,t+1}P_{t+1}C_{t+1}^\sigma}\right]=1 .
\]

- **(F5) 本国劳动供给**：

\[
\chi H_t^\psi C_t^\sigma=\frac{W_t}{P_t}.
\]

- **(F6) 外国消费价格指数**：

\[
P_t^{\ast}=\left[\gamma^{\ast}P_{f,t}^{\ast1-\lambda}+(1-\gamma^{\ast})\left(\frac{(1+\tau_t^{\ast})P_{h,t}}{S_t}\right)^{1-\lambda}\right]^{1/(1-\lambda)} .
\]

- **(F7) 外国家庭 Euler 方程**：

\[
\beta E_t\left[\frac{R_t^{\ast}P_t^{\ast}C_t^{\ast\sigma}}{\pi_{f,t+1}^{\ast}P_{t+1}^{\ast}C_{t+1}^{\ast\sigma}}\right]=1 .
\]

- **(F8) 外国劳动供给**：

\[
\chi H_t^{\ast\psi}C_t^{\ast\sigma}=\frac{W_t^{\ast}}{P_t^{\ast}}.
\]

### 厂商

- **(F9) 本国中间品价格指数**：

\[
P_{x,t}=\left[\gamma_xP_{h,t}^{1-\lambda}+(1-\gamma_x)\left((1+\tau_t)S_tP_{f,t}^{\ast}\right)^{1-\lambda}\right]^{1/(1-\lambda)} .
\]

- **(F10) 本国要素需求**：

\[
(1-\alpha)MC_tY_t=W_tH_t,\qquad \alpha MC_tY_t=P_{x,t}X_t .
\]

- **(F11) 本国实际边际成本**：

\[
MC_t=\frac{W_t^{1-\alpha}P_{x,t}^{\alpha}}{A_t\alpha^\alpha(1-\alpha)^{1-\alpha}P_{h,t}} .
\]

- **(F12) 本国 Rotemberg Phillips 曲线**：

\[
\theta+\frac{\phi}{\epsilon}\left[\pi_{h,t}(\pi_{h,t}-1)-E_t\left\{\omega_{t+1}\pi_{h,t+1}(\pi_{h,t+1}-1)\frac{Y_{t+1}}{Y_t}\right\}\right]=MC_t .
\]

- **(F13) 外国中间品价格指数**：

\[
P_{x,t}^{\ast}=\left[\gamma_x^{\ast}P_{f,t}^{\ast1-\lambda}+(1-\gamma_x^{\ast})\left(\frac{(1+\tau_t^{\ast})P_{h,t}}{S_t}\right)^{1-\lambda}\right]^{1/(1-\lambda)} .
\]

- **(F14) 外国 Rotemberg Phillips 曲线**（`needs_review`：附录 OCR 在 reduced display 中交替显示 \(MC_t^{\ast}\) 与 \(\epsilon MC_t^{\ast}\)）：

\[
\theta+\frac{\phi}{\epsilon}\left[\pi_{f,t}^{\ast}(\pi_{f,t}^{\ast}-1)-E_t\left\{\omega_{t+1}^{\ast}\pi_{f,t+1}^{\ast}(\pi_{f,t+1}^{\ast}-1)\frac{Y_{t+1}^{\ast}}{Y_t^{\ast}}\right\}\right]=MC_t^{\ast} .
\]

- **(F15) 本国生产函数**：

\[
Y_t=A_tH_t^{1-\alpha}X_t^\alpha .
\]

- **(F16) 外国生产函数**：

\[
Y_t^{\ast}=A_t^{\ast}H_t^{\ast1-\alpha}X_t^{\ast\alpha}.
\]

### 货币与贸易政策

- **(F17) 本国 CPI 通胀定义**：

\[
\pi_{cpi,t}=\pi_{h,t}\frac{\mathcal{P}_t}{\mathcal{P}_{t-1}},\qquad
\mathcal{P}_t=P_t/P_{h,t}.
\]

- **(F18) 外国 CPI 通胀定义**：

\[
\pi_{cpi,t}^{\ast}=\pi_{f,t}^{\ast}\frac{\mathcal{P}_t^{\ast}}{\mathcal{P}_{t-1}^{\ast}},\qquad
\mathcal{P}_t^{\ast}=P_t^{\ast}/P_{f,t}^{\ast} .
\]

- **(F19) 本国 CPI 目标货币政策规则**：

\[
R_t=\beta^{-1}\left(\frac{\pi_{cpi,t}}{\Pi_h^{tar}}\right)^{\mu_\pi}\exp(\varepsilon_{R,t}) .
\]

- **(F20) 外国 CPI 目标货币政策规则**：

\[
R_t^{\ast}=\beta^{-1}\left(\frac{\pi_{cpi,t}^{\ast}}{\Pi_f^{tar}}\right)^{\mu_\pi^{\ast}}\exp(\varepsilon_{R,t}^{\ast}) .
\]

- **(F21) MMB 交叉检查中的本国关税过程**：

\[
\tau_t=\bar{\tau}+e_{\tau,t}.
\]

- **(F22) MMB 交叉检查中的外国关税过程**：

\[
\tau_t^{\ast}=\bar{\tau}^{\ast}+e_{\tau,t}^{\ast}.
\]

## 4. Market Clearing & Identities

- **(F23) 含 Rotemberg 资源成本的本国品市场出清**：

\[
Y_t\left[1-\frac{\phi}{2}(\pi_{h,t}-1)^2\right]=D_t+D_{x,t}^{\ast} .
\]

- **(F24) 含 Rotemberg 资源成本的外国品市场出清**：

\[
Y_t^{\ast}\left[1-\frac{\phi}{2}(\pi_{f,t}^{\ast}-1)^2\right]=D_t^{\ast}+D_{x,t}.
\]

- **(F25) 本国对本国品的吸收**：

\[
D_t=\gamma\mathcal{P}_t^\lambda(C_t+\Lambda_t)+\gamma_x\mathcal{P}_{x,t}^\lambda X_t .
\]

- **(F26) 外国对外国品的吸收**：

\[
D_t^{\ast}=\gamma^{\ast}\mathcal{P}_t^{\ast\lambda}C_t^{\ast}+\gamma_x^{\ast}\mathcal{P}_{x,t}^{\ast\lambda}X_t^{\ast} .
\]

- **(F27) 本国出口到外国**：

\[
D_{x,t}^{\ast}=\frac{1-n}{n}\left(\frac{S_t}{1+\tau_t^{\ast}}\right)^\lambda
\left[(1-\gamma^{\ast})\mathcal{P}_t^{\ast\lambda}C_t^{\ast}+(1-\gamma_x^{\ast})\mathcal{P}_{x,t}^{\ast\lambda}X_t^{\ast}\right].
\]

- **(F28) 外国出口到本国**：

\[
D_{x,t}=\frac{n}{1-n}\left(\frac{1}{S_t(1+\tau_t)}\right)^\lambda
\left[(1-\gamma)\mathcal{P}_t^\lambda(C_t+\Lambda_t)+(1-\gamma_x)\mathcal{P}_{x,t}^\lambda X_t\right].
\]

- **(F29) 净国外资产市场出清**：

\[
nb_t+(1-n)\frac{S_tP_t^{\ast}}{P_t}b_t^{\ast}=0 .
\]

- **(F30) 含组合调整成本的 UIP**：

\[
E_t\left[\frac{S_{t+1}\omega_{t+1}}{S_t\omega_{t+1}^{\ast}(1+\nu(b_t-\bar{b}))}-1\right]=0 .
\]

- **(F31) 本国净国外资产积累**：

\[
b_t-\frac{S_tP_{t-1}}{S_{t-1}P_t\omega_t^{\ast}}b_{t-1}-P_t^{-1}\left(D_{x,t}^{\ast}-\frac{1-n}{n}S_tD_{x,t}\right)=0 .
\]

## 5. Exogenous Processes

- **(F32) 本国生产率**：

\[
\log A_t=\rho_a\log A_{t-1}+\varepsilon_{A,t}.
\]

- **(F33) 外国生产率**：

\[
\log A_t^{\ast}=\rho_a^{\ast}\log A_{t-1}^{\ast}+\varepsilon_{A,t}^{\ast}.
\]

- **(F34) 本国货币政策冲击**：

\[
\varepsilon_{R,t}=\rho_R\varepsilon_{R,t-1}+u_{R,t}.
\]

- **(F35) 外国货币政策冲击**：

\[
\varepsilon_{R,t}^{\ast}=\rho_R^{\ast}\varepsilon_{R,t-1}^{\ast}+u_{R,t}^{\ast}.
\]

## 6. Steady-State Solution

论文报告了校准和估计稳态；本归档条目不重新计算稳态。对于主文中的对称年度校准，相关条件为：

1. 设 \(\bar{A}=\bar{A}^{\ast}=1\)、\(\bar{b}=\bar{b}^{\ast}=0\)、\(\bar{\pi}_h=\bar{\pi}_f^{\ast}=\bar{\pi}_{cpi}=\bar{\pi}_{cpi}^{\ast}=1\)，并令政策创新为零。
2. 由 (F4) 和 (F7)，当通胀目标等于 1 时，\(\bar{R}=\bar{R}^{\ast}=1/\beta\)。
3. 零通胀下 Rotemberg 成本消失，(F23)-(F24) 化为 \(\bar{Y}=\bar{D}+\bar{D}_x^{\ast}\) 和 \(\bar{Y}^{\ast}=\bar{D}^{\ast}+\bar{D}_x\)。
4. 若垄断扭曲未由补贴抵消，稳态加成楔子由 \(\theta=(1+s)(\epsilon-1)/\epsilon<1\) 控制；使用一阶最优补贴时，\(\theta=1\)。
5. 在对称贸易战稳态中，\(\bar{S}=1\)、\(\bar{\tau}=\bar{\tau}^{\ast}\)，CPI 规则通过关税调整相对价格 \(\mathcal{P}_t\) 影响相机抉择关税均衡。
6. MMB `NK_ADE25cpi.mod` 交叉检查保存了一个对称稳态，含 \(\beta=0.99\)、\(\lambda=5\)、\(\epsilon=6\)、\(\alpha=0.4\)、\(\phi=40\)，并把 CPI 通胀作为 modelbase 通胀变量。这些数值属于实现证据，不是独立论文来源方程。

`needs_review`：精确 MMB 稳态值应在后续实现验证阶段对照模型专属 `.json`/`.mod` 文件统一核对。

## 7. Timing & Form Conventions

- 债券是存量变量，在 \(t\) 期决定并在 \(t\) 到 \(t+1\) 之间支付收益；Appendix C 同时包含本国和外国债券头寸以及组合调整楔子。
- \(S_t\) 是名义汇率/贸易条件对象，经归一化后使用；本国贸易条件由外国品相对本国品价格表示。
- \(P_t/P_{h,t}\) 和 \(P_t^{\ast}/P_{f,t}^{\ast}\) 是含关税调整的相对 CPI 项。`cpi` 版本目标 CPI 通胀，因此货币政策对 \(\pi_h\) 以及这一相对 CPI 组成部分的变动做出反应。
- 价格采用生产者货币定价。价格黏性通过 Rotemberg 成本和 Phillips 曲线进入，而不是通过 Calvo 辅助递归。
- 模型是非线性的。Dynare 或最优控制例程应对系统做线性近似/数值近似，而不是使用手工对数线性化方程。
- Appendix D 为美中量化实验改变国际债券计价货币；该块未完全并入上面的紧凑方程。

## 8. Variable & Parameter Reference Table

| 类别 | 符号 / ASCII | 含义 | 主要方程 |
|---|---|---|---|
| 内生 | \(C_t,C_t^{\ast}\) / `C,Cs` | 本国和外国总消费 | (F1)-(F8) |
| 内生 | \(C_{h,t},C_{f,t},C_{f,t}^{\ast},C_{h,t}^{\ast}\) | 双边消费需求 | (F2), (F3), (F6) |
| 内生 | \(H_t,H_t^{\ast}\) / `L,Ls` | 劳动 | (F5), (F8), (F15), (F16) |
| 内生 | \(Y_t,Y_t^{\ast}\) / `Y,Ys` | 产出 | (F15), (F16), (F23), (F24) |
| 内生 | \(X_t,X_t^{\ast}\) / `X,Xs` | 中间投入 | (F9), (F10), (F13) |
| 内生 | \(P_t,P_t^{\ast}\) / `P,Ps` | CPI 价格指数；实现中相对生产者价格表示 | (F1), (F6) |
| 内生 | \(P_{x,t},P_{x,t}^{\ast}\) / `Px,Pxs` | 中间品价格指数 | (F9), (F13) |
| 内生 | \(\pi_{h,t},\pi_{f,t}^{\ast}\) / `Pih,Pif` | PPI 通胀 | (F12), (F14), (F17), (F18) |
| 内生 | \(\pi_{cpi,t},\pi_{cpi,t}^{\ast}\) / `Pih_cpi,Pif_cpi` | CPI 通胀目标变量 | (F17), (F18) |
| 内生 | \(MC_t,MC_t^{\ast}\) / `Mc,Mcs` | 实际边际成本 | (F11), (F12), (F14) |
| 内生 | \(D_t,D_t^{\ast},D_{x,t},D_{x,t}^{\ast}\) / `D,Ds,Dx,Dxs` | 国内吸收与出口需求 | (F23)-(F28) |
| 内生 | \(S_t\) / `S` | 贸易条件/汇率对象 | (F27), (F28), (F30), (F31) |
| 内生 | \(b_t,b_t^{\ast}\) / `nfa` | 净国外资产 | (F29)-(F31) |
| 内生 | \(R_t,R_t^{\ast}\) / `R,Rs` | 名义利率 | (F19), (F20) |
| 内生 / 政策 | \(\tau_t,\tau_t^{\ast}\) / `T,Ts` | 进口关税 | (F21), (F22), 需求方程 |
| 外生 | \(\varepsilon_{A,t},\varepsilon_{A,t}^{\ast}\) / `eA,eAs` | 生产率创新 | (F32), (F33) |
| 外生 | \(u_{R,t},u_{R,t}^{\ast}\) / `epsR,epsRs` | 货币政策创新 | (F34), (F35) |
| 外生 | \(e_{\tau,t},e_{\tau,t}^{\ast}\) / `eT,eTs` | MMB 交叉检查中的关税创新 | (F21), (F22) |
| 参数 | \(\beta\) / `bet` | 贴现因子 | (F4), (F7), (F19), (F20) |
| 参数 | \(\sigma\) / `sigma` | 风险厌恶 | (F4), (F5), (F7), (F8) |
| 参数 | \(\chi,\psi\) / `chi,psi` | 劳动负效用与 Frisch 参数 | (F5), (F8) |
| 参数 | \(n\) / `size` | 本国人口/经济规模 | (F27)-(F29), (F31) |
| 参数 | \(\gamma,\gamma^{\ast},\gamma_x,\gamma_x^{\ast}\) / `gamh,gamf,gamxh,gamxf` | 本国偏好权重 | (F1), (F6), (F9), (F13), (F25)-(F28) |
| 参数 | \(\lambda\) / `lamb` | 贸易弹性 | 需求方程 |
| 参数 | \(\epsilon\) / `elas` | 品种间替代弹性 | (F12), (F14) |
| 参数 | \(\alpha\) / `alpha` | 中间投入份额 | (F10), (F15), (F16) |
| 参数 | \(\phi\) / `phi` | Rotemberg 价格调整参数 | (F12), (F14), (F23), (F24) |
| 参数 | \(\nu\) / `adj` | 组合调整成本 | (F30), (F31) |
| 参数 | \(\mu_\pi,\mu_\pi^{\ast}\) / `mu` | 通胀规则反应系数 | (F19), (F20) |
| 参数 | \(\rho_a,\rho_R,\rho_R^{\ast}\) | 冲击持续性 | (F32)-(F35) |

方程数量：(F1)-(F35)，共 35 个编号条件。
