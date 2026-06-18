# NK_ADE25ppi - 推导（最优化问题 + 一阶条件）

> 归档状态：needs_review。本首轮推导基于 Auray、Devereux 和 Eyquem (2025) 的 MinerU Markdown。论文说明完整两国均衡系统见在线附录 C 的方程 (C40)-(C48)，但该附录在本文件夹中没有规范化 Markdown 来源。因此下列方程保留论文侧结构，并在依赖附录核查的位置标记 needs_review。

来源信息：model_id `NK_ADE25ppi`；论文题名 "Trade Wars and the Optimal Design of Monetary Rules"；作者 Stéphane Auray、Micheal Devereux 和 Aurélien Eyquem；年份 2025；DOI `10.1016/j.jmoneco.2024.103726`；源 Markdown `raw/mmb_mineru/runs/nk_ade25cpi_nk_ade25ppi__trade_wars_and_the_optimal_design_of_monetary_rules__2eb96dcd/full.md`；原始 PDF `raw/mmb_papers/Trade Wars and the Optimal Design of Monetary Rules.pdf`；MinerU run id `2eb96dcd-d16e-4f63-85f3-a8572fc7a9dd`。

## 1. Model Overview

- **模型**：两国开放经济 New Keynesian 贸易战模型，包含生产者货币定价、垄断竞争、Rotemberg 调价成本、非或有债券和相机抉择的关税设定。
- **MMB 变体**：`NK_ADE25ppi`，即 PPI 目标变体。本地 MMB 实现交叉检查显示，该变体在货币政策反馈变量中使用生产者价格通胀；相对地，`NK_ADE25cpi` 将 CPI 通胀定义为国内品通胀乘以 CPI 价格指数变化。
- **政策实验**：非合作关税与货币规则相互作用。论文比较 PPI 目标、CPI 目标、固定汇率，以及稳定关税调整贸易条件的更一般规则。本归档条目记录 PPI 目标基准。
- **主体和政策当局**：Home 与 Foreign 家庭消费 Home 和 Foreign 商品、供给劳动并持有债券；垄断竞争企业以生产者货币设定价格；政府选择进口关税并返还收入；央行设定名义利率。
- **模型形式**：围绕确定性稳态求解的非线性均衡条件；MMB 实现随后进行对数线性化/模拟，但本推导保留非线性论文公式。未执行运行时验证。

## 2. Optimization Problems

### 2.1 Home 家庭

Home 家庭选择 Home 商品消费、Foreign 商品消费、工时和债券持有：

$$
\max_{\{C_{h,t},C_{f,t},H_t,B_t\}} E_0\sum_{t=0}^{\infty}\beta^t
\left[u(C_{h,t},C_{f,t})-\ell(H_t)\right]
$$

约束为名义预算约束：

$$
B_t+P_{h,t}C_{h,t}+(1+\tau_t)S_tP_{f,t}^{\ast}C_{f,t}
=R_{t-1}B_{t-1}+W_tH_t+\Pi_t+TR_t .
$$

论文的定量模型使用总消费 $C_t$、劳动 $H_t$（MMB 实现中为 $L_t$）以及国内品和进口品的 CES 价格指数。附录 C 的精确加总形式为 needs_review。

### 2.2 Foreign 家庭

Foreign 家庭求解对称问题：

$$
\max_{\{C_{f,t}^{\ast},C_{h,t}^{\ast},H_t^{\ast},B_t^{\ast}\}} E_0\sum_{t=0}^{\infty}\beta^t
\left[u^{\ast}(C_{f,t}^{\ast},C_{h,t}^{\ast})-\ell(H_t^{\ast})\right],
$$

其中 Foreign 进口关税 $\tau_t^{\ast}$ 作用于 Home 商品，债券计价遵循模型变体。US-China 扩展将债券计价改为美元；本归档条目不把该扩展重构为单独模型。

### 2.3 企业

一连续统垄断竞争 Home 企业在生产者货币定价下生产差异化品种。在简单模型中，品种 $i$ 的产出为

$$
Y_t(i)=A_tH_t(i).
$$

在完整定量模型中，生产还使用份额为 $\alpha$ 的中间品：

$$
Y_t=A_tL_t^{1-\alpha}X_t^\alpha,
$$

Foreign 生产函数对称。企业在需求曲线和 Rotemberg 调价成本约束下选择价格。相应 Phillips 曲线列于第 3 节。

### 2.4 政府与央行

Home 和 Foreign 关税当局选择相机抉择 Nash 关税。在浮动汇率下，论文将 Home 问题概括为

$$
\max_{\{C_t,C_t^{\ast},Y_t,Y_t^{\ast},b_t,b_t^{\ast},S_t,\pi_{h,t},\pi_{f,t}^{\ast},\tau_t\}}
V(b_{t-1})=U(C_t,H_t)+\beta E_t[V(b_t)]
$$

约束为完整均衡条件和货币政策规则。Foreign 关于 $\tau_t^{\ast}$ 的问题是对称的。这些关税 FOC 未在正文列出，因此需要对照在线附录 C 进行 needs_review。

对 `NK_ADE25ppi`，央行目标是生产者价格通胀而不是 CPI 通胀。

## 3. First-Order Conditions

- **(F1) Home 劳动静态条件**：
$$
\ell'(H_t)=A_t\,u_{c_h,t}\,E_t\{\Omega_{t,t+1}\}.
$$

- **(F2) Home 最优进口支出条件**：
$$
u_{c_h,t}(1+\tau_t)S_t=u_{c_f,t}.
$$

- **(F3) 以 Home 商品计价的 Home Euler 方程，与 PPI 货币政策结合**：
$$
E_t\left[
\frac{\pi_{h,t}^{\mu_\pi}}{\pi_{h,t+1}}
\frac{u_{c_h,t+1}}{u_{c_h,t}}
\right]=1.
$$

- **(F4) Home 企业定价得到的 Rotemberg Phillips 曲线**：
$$
E_t\{\Omega_{t,t+1}\}
=\mathcal{W}_t A_t^{-1}
=E_t\left\{\theta+\frac{\phi}{\epsilon}
\left[\pi_{h,t}(\pi_{h,t}-1)-\beta\pi_{h,t+1}(\pi_{h,t+1}-1)\right]\right\}.
$$

- **(F5) 定量模型使用的 Home 边际成本表示** needs_review：
$$
MC_t=
\frac{\left(\chi P_t C_t^\sigma L_t^\psi\right)^{1-\alpha}P_{x,t}^{\alpha}}
{A_t\alpha^\alpha(1-\alpha)^{1-\alpha}}.
$$

- **(F6) Home 中间品需求条件** needs_review：
$$
X_t=
\left(
\frac{\chi P_t C_t^\sigma L_t^{\alpha+\psi}}
{(1-\alpha)MC_tA_t}
\right)^{1/\alpha}.
$$

- **(F7) Home 生产函数**：
$$
Y_t=A_tL_t^{1-\alpha}X_t^\alpha.
$$

- **(F8) Foreign 劳动静态条件** needs_review：
$$
\ell^{\ast'}(H_t^{\ast})=A_t^{\ast}\,u_{c_f^{\ast},t}^{\ast}\,E_t\{\Omega_{t,t+1}^{\ast}\}.
$$

- **(F9) Foreign 最优进口支出条件** needs_review：
$$
u_{c_f^{\ast},t}^{\ast}\frac{1+\tau_t^{\ast}}{S_t}=u_{c_h^{\ast},t}^{\ast}.
$$

- **(F10) 以 Foreign 商品计价的 Foreign Euler 方程，与 PPI 货币政策结合** needs_review：
$$
E_t\left[
\frac{(\pi_{f,t}^{\ast})^{\mu_\pi^{\ast}}}{\pi_{f,t+1}^{\ast}}
\frac{u_{c_f^{\ast},t+1}^{\ast}}{u_{c_f^{\ast},t}^{\ast}}
\right]=1.
$$

- **(F11) Foreign Rotemberg Phillips 曲线** needs_review：
$$
E_t\{\Omega_{t,t+1}^{\ast}\}
=\mathcal{W}_t^{\ast}(A_t^{\ast})^{-1}
=E_t\left\{\theta^{\ast}+\frac{\phi^{\ast}}{\epsilon}
\left[\pi_{f,t}^{\ast}(\pi_{f,t}^{\ast}-1)-\beta\pi_{f,t+1}^{\ast}(\pi_{f,t+1}^{\ast}-1)\right]\right\}.
$$

- **(F12) Foreign 生产函数**：
$$
Y_t^{\ast}=A_t^{\ast}(L_t^{\ast})^{1-\alpha}(X_t^{\ast})^\alpha.
$$

## 4. Market Clearing & Identities

- **(F13) 简单模型中的 Home 商品市场出清**：
$$
A_tH_t\Phi_t=C_{h,t}+C_{h,t}^{\ast},\qquad
\Phi_t=1-\frac{\phi}{2}(\pi_{h,t}-1)^2.
$$

- **(F14) 简单模型中的平衡贸易条件**：
$$
\bar{A}S_t^\eta=S_tC_{f,t}.
$$

- **(F15) 定量模型中的 Home 资源约束** needs_review：
$$
Y_t\left[1-\frac{\phi}{2}(\pi_{h,t}-1)^2\right]=D_t+D_{x,t}^{\ast}.
$$

- **(F16) 定量模型中的 Foreign 资源约束** needs_review：
$$
Y_t^{\ast}\left[1-\frac{\phi^{\ast}}{2}(\pi_{f,t}^{\ast}-1)^2\right]=D_t^{\ast}+D_{x,t}.
$$

- **(F17) Home CPI 和进口价格指数** needs_review：
$$
P_t=\left[\gamma_h+(1-\gamma_h)\left((1+\tau_t)S_t\right)^{1-\lambda}\right]^{1/(1-\lambda)}.
$$

- **(F18) Foreign CPI 和进口价格指数** needs_review：
$$
P_t^{\ast}=\left[\gamma_f+(1-\gamma_f)\left(\frac{1+\tau_t^{\ast}}{S_t}\right)^{1-\lambda}\right]^{1/(1-\lambda)}.
$$

- **(F19) 净国外资产积累和 UIP 条件** needs_review：
$$
b_t=\mathcal{B}(b_{t-1},S_t,P_t,P_t^{\ast},D_{x,t},D_{x,t}^{\ast}),\qquad
E_t\left[\frac{S_{t+1}\Omega_t}{S_t\Omega_t^{\ast}(1+\nu(b_t-\bar{b}))}\right]=1.
$$

## 5. Exogenous Processes

- **(F20) `NK_ADE25ppi` 的 Home PPI 货币政策规则**：
$$
R_t=\beta^{-1}\left(\frac{\pi_{h,t}}{\bar{\pi}_h}\right)^{\mu_\pi}\exp(e^R_t).
$$

- **(F21) Foreign PPI 货币政策规则**：
$$
R_t^{\ast}=\beta^{-1}\left(\frac{\pi_{f,t}^{\ast}}{\bar{\pi}_f^{\ast}}\right)^{\mu_\pi^{\ast}}\exp(e^{R^{\ast}}_t).
$$

- **(F22) 生产率过程**：
$$
\log A_t=\rho_a\log A_{t-1}+\varepsilon^A_t,\qquad
\log A_t^{\ast}=\rho_a^{\ast}\log A_{t-1}^{\ast}+\varepsilon^{A^{\ast}}_t.
$$

- **(F23) MMB 实现交叉检查中使用的关税和货币冲击**：
$$
\tau_t=\bar{\tau}+e^T_t,\qquad
\tau_t^{\ast}=\bar{\tau}^{\ast}+e^{T^{\ast}}_t,\qquad
e^R_t=\rho_R e^R_{t-1}+\varepsilon^R_t,\qquad
e^{R^{\ast}}_t=\rho_{R^{\ast}} e^{R^{\ast}}_{t-1}+\varepsilon^{R^{\ast}}_t.
$$

## 6. Steady-State Solution

确定性稳态令冲击为零，并保持关税不变。论文第 5 节校准例子使用对称国家，而第 8 节 US-China 应用使用非对称规模、生产率、home bias 和关税水平。

1. 对称校准中设 $A=A^{\ast}=1$；US-China 应用中使用 $A^{\ast}/A=1/3$。
2. 设 $\pi_h=\pi_f^{\ast}=1$；在 PPI 规则下，当货币政策冲击为零时，$R=R^{\ast}=\beta^{-1}$。
3. 将净国外资产设为目标值，通常为 $b=\bar{b}=0$。
4. 给定关税 $\tau,\tau^{\ast}$，由 (F17)-(F18) 以及相应中间品价格指数计算 CPI/进口价格指数 $P,P^{\ast},P_x,P_x^{\ast}$。
5. 使用稳态企业条件求解边际成本。零通胀且没有销售补贴时，扭曲稳态包含垄断加成扭曲；若有 first-best 补贴，则 $\theta=1$。
6. 由 (F5)-(F16) 求解劳动、中间品、产出和需求。完整闭式顺序为 needs_review，因为主 Markdown 引用附录 C 方程 (C40)-(C48) 而未列出。
7. 对简单小国 PPI 情形，论文给出稳态最优关税：
$$
1+\tau^{ppi}=\frac{\eta}{\eta-1}\frac{1-\theta\Delta_1}{1-\Delta_1},
$$
其中
$$
\Delta_1=\frac{A^2u_{c_hc_h}}{\ell''(H)}
\left(\theta+\frac{\phi}{\mu_\pi\epsilon}\right)<0.
$$

## 7. Timing & Form Conventions

- 本推导是非线性的。不要将这些方程视为手工对数线性化。
- 使用生产者货币定价：黏性价格是国内生产者价格，因此 `ppi` 变体目标为 $\pi_{h,t}$ 和 $\pi_{f,t}^{\ast}$。
- CPI 通胀与 PPI 通胀的差异来自关税调整贸易条件的变化。对 Home，论文写为
$$
\pi_{cpi,t}=\pi_{h,t}
\frac{\mathcal{P}((1+\tau_t)S_t)}{\mathcal{P}((1+\tau_{t-1})S_{t-1})}.
$$
该公式不是 `NK_ADE25ppi` 的目标，但它识别了配对的 CPI 变体。
- 债券/净国外资产是状态变量。MMB 实现使用滞后净国外资产和债务弹性 UIP 楔子；精确附录 C 记号为 needs_review。
- 关税政策是相机抉择的：关税制定者选择当前关税时，将未来政策函数视为给定。
- 未执行运行时验证。

## 8. Variable & Parameter Reference Table

| 类别 | 符号 / ASCII 名 | 含义 | 主要方程 |
|---|---|---|---|
| 内生变量 | $C_{h,t},C_{f,t},C_t$ / `C` | Home 家庭消费分项 / 总消费 | (F2), (F3), (F17) |
| 内生变量 | $C_t^{\ast}$ / `Cs` | Foreign 总消费 | (F9), (F10), (F18) |
| 内生变量 | $H_t,L_t$ / `L` | Home 劳动 | (F1), (F7) |
| 内生变量 | $H_t^{\ast},L_t^{\ast}$ / `Ls` | Foreign 劳动 | (F8), (F12) |
| 内生变量 | $Y_t,Y_t^{\ast}$ / `Y`, `Ys` | Home 和 Foreign 产出 | (F7), (F12), (F15), (F16) |
| 内生变量 | $X_t,X_t^{\ast}$ / `X`, `Xs` | 中间品 | (F6), (F12) |
| 内生变量 | $MC_t,MC_t^{\ast}$ / `Mc`, `Mcs` | 边际成本 | (F5), (F11) |
| 内生变量 | $\pi_{h,t},\pi_{f,t}^{\ast}$ / `Pih`, `Pif` | PPI 通胀率 | (F4), (F11), (F20), (F21) |
| 内生变量 | $P_t,P_t^{\ast}$ / `P`, `Ps` | CPI 价格指数 | (F17), (F18) |
| 内生变量 | $S_t$ / `S` | 贸易条件 / 相对价格 | (F2), (F9), (F17), (F18), (F19) |
| 内生变量 | $b_t$ / `nfa` | 净国外资产 | (F19) |
| 内生变量 | $R_t,R_t^{\ast}$ / `R`, `Rs` | 名义利率 | (F20), (F21) |
| 内生政策 | $\tau_t,\tau_t^{\ast}$ / `T`, `Ts` | 进口关税 | (F2), (F9), (F23) |
| 外生变量 | $\varepsilon^A_t,\varepsilon^{A^{\ast}}_t$ / `eA`, `eAs` | 生产率创新 | (F22) |
| 外生变量 | $\varepsilon^T_t,\varepsilon^{T^{\ast}}_t$ / `eT`, `eTs` | MMB 实现中的关税冲击 / 关税移位项 | (F23) |
| 外生变量 | $\varepsilon^R_t,\varepsilon^{R^{\ast}}_t$ / `epsR`, `epsRs`, `interest_` | 货币政策冲击 | (F20), (F21), (F23) |
| 参数 | $\beta$ / `bet` | 贴现因子 | (F3), (F20), (F21) |
| 参数 | $\sigma,\chi,\psi$ / `sigma`, `chi`, `psi` | 效用曲率和劳动负效用参数 | (F1), (F5), (F6) |
| 参数 | $\lambda$ / `lamb` | 贸易弹性 | (F17), (F18) |
| 参数 | $\epsilon$ / `elas` | 品种间替代弹性 / 加成参数 | (F4), (F11) |
| 参数 | $\phi,\phi^{\ast}$ / `phi` | Rotemberg 调价成本 | (F4), (F11), (F15), (F16) |
| 参数 | $\alpha$ / `alpha` | 中间品份额 | (F5), (F7), (F12) |
| 参数 | $\gamma_h,\gamma_f,\gamma_{xh},\gamma_{xf}$ / `gamh`, `gamf`, `gamxh`, `gamxf` | home-bias 权重 | (F17), (F18) |
| 参数 | $\mu_\pi,\mu_\pi^{\ast}$ / `mu` | 货币规则中的通胀反应系数 | (F20), (F21) |
| 参数 | $\rho_a,\rho_R,\rho_{R^{\ast}}$ / `rhoa`, `rhoR`, `rhoRs` | 冲击持久性 | (F22), (F23) |
