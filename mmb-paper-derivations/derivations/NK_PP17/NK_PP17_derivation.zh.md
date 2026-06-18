# NK_PP17 - 货币政策与宏观审慎政策协调

> 归档状态：第一轮基于来源的推导；`needs_review`。
> 运行验证：未执行。Rep-MMB `.mod` 文件仅作为 `implementation_cross_check` 阅读；未运行 Dynare。

来源信息：`NK_PP17`，De Paoli and Paustian (2017), "Coordinating monetary and macroprudential policies," Journal of Money, Credit and Banking 49(2-3), 319-349, DOI `10.1111/jmcb.12381`。主 Markdown 来源为 `raw/mmb_mineru/runs/nk_pp17__coordinating_monetary_and_macroprudential_policies__7a9fb3e4/full.md`；原始 PDF 为 `raw/mmb_papers/Coordinating monetary and macroprudential policies.pdf`；MinerU run id 为 `7a9fb3e4-aa53-43fb-8193-d10c6ee867a1`。

## 1. Model Overview

- **模型**：带金融中介、 costly-enforcement 摩擦、固定资本和可变资本利用率的新凯恩斯黏性价格无现金经济。
- **论文目的**：比较承诺和相机抉择下，货币政策与宏观审慎政策的合作和非合作安排。
- **Rep-MMB 闭合方式**：实现文件使用线性化均衡系统，配以简单 Taylor 规则，并设定宏观审慎工具不活跃，即 `S_t=0`。
- **主体**：代表性家庭、中间品生产者、带 Rotemberg 调价成本的垄断竞争最终品企业、金融中介、货币当局和宏观审慎当局。
- **形式**：实现交叉检查显示为 `model(linear)`。带帽变量为相对稳态的偏离；论文在方程 (26) 附近说明 `\widehat{\phi}_t`、`\widehat{S}_t` 和 `\widehat{R}_t` 是水平偏离。
- **核心扭曲**：名义刚性、markup 冲击、营运资本成本渠道、内生信用利差，以及始终绑定的银行激励约束。

## 2. Optimization Problems

### 2.1 家庭

家庭选择消费、存款、劳动和利用率服务。偏好为

\[
U(c_t,L_t,u_t)=\frac{c_t^{1-\sigma}}{1-\sigma}
-\frac{L_t^{1+\theta}}{1+\theta}
-\frac{u_t^{1+\theta}}{1+\theta}.
\]

实际预算约束为

\[
c_t+A_t=\Omega_w w_t L_t+\Omega_r r_t u_t+\frac{R_{t-1}}{\pi_t}A_{t-1}+T_t+\Pi_t.
\]

### 2.2 中间品生产者

中间品企业雇佣劳动和利用率服务，生产函数为

\[
x_t=L_t^{\alpha}u_t^{1-\alpha}.
\]

企业需要预先向银行借入工资账单。利润为

\[
\text{profits}_t=p_t x_t-R_t^B w_t L_t-r_t u_t.
\]

利差由贷款利率相对于存款利率定义；线性系统使用 `\phi_t` 表示信用利差。

### 2.3 最终品企业

最终品企业用弹性 `\varepsilon_t` 聚合差异化产品；生产率把中间品产出转化为最终产出，实际边际成本为

\[
z_t=\frac{p_t}{a_t}.
\]

Rotemberg 调价成本为

\[
\frac{\varphi}{2}(\pi_t-1)^2y_t.
\]

### 2.4 金融中介

银行向企业贷款、吸收存款，并面临作用于融资成本的补贴/税。银行家价值可递归表示为贷款价值和净值价值。银行激励约束为

\[
V_{jt}\geq \lambda_t B_{jt}.
\]

在约束绑定且杠杆为 `\delta_t=B_{jt}/N_{jt}` 时，银行净值由留存银行家财富和冲击决定。论文设定 startup-fund 项 `\omega=0`，以获得简单的对数线性系统。

### 2.5 政策当局

货币政策工具是名义利率偏离 `\widehat{R}_t`；基准宏观审慎工具是银行融资补贴 `\widehat{S}_t`。论文研究最优政策博弈，但 Rep-MMB 文件用 Taylor 规则和 `S_t=0` 闭合模型。

## 3. First-Order Conditions

以下方程构成 `NK_PP17` 归档条目的来源均衡条件。可用时保留论文方程编号。

- **(F1) 家庭劳动供给**：

\[
\frac{L_t^\theta}{c_t^{-\sigma}}=\Omega_w w_t.
\]

- **(F2) 家庭利用率服务供给**：

\[
\frac{u_t^\theta}{c_t^{-\sigma}}=\Omega_r r_t.
\]

- **(F3) 家庭 Euler 方程**：

\[
c_t^{-\sigma}=\beta E_t\left(c_{t+1}^{-\sigma}\frac{R_t}{\pi_{t+1}}\right).
\]

- **(F4) 带营运资本融资的中间品企业劳动需求**：

\[
\alpha p_t x_t=(1+\phi_t)R_t w_t L_t.
\]

- **(F5) 中间品企业利用率服务需求**：

\[
(1-\alpha)p_t x_t=r_t u_t.
\]

- **(F6) 非线性来源形式的 Rotemberg Phillips 曲线**：

\[
0=(1-\varepsilon_t)+\varepsilon_t z_t-\varphi(\pi_t-1)\pi_t
-\beta E_t\left[
\frac{c_{t+1}^{-\sigma}}{c_t^{-\sigma}}
\varphi(\pi_{t+1}-1)\pi_{t+1}\frac{y_{t+1}}{y_t}
\right].
\]

- **(F7) 银行贷款价值**：

\[
v_{b,t}=(1-\gamma)(\phi_t+S_t)
+E_t\gamma\beta\Lambda_{t,t+1}\pi_{b,t+1}v_{b,t+1}.
\]

- **(F8) 银行净值价值**：

\[
v_{n,t}=(1-\gamma)(1-S_t)
+E_t\gamma\beta\Lambda_{t,t+1}\pi_{n,t+1}v_{n,t+1}.
\]

- **(F9) 绑定激励约束 / 杠杆**：

\[
\delta_t=\frac{v_{n,t}}{\lambda_t-v_{b,t}}.
\]

- **(F10) 总银行净值来源方程**：

\[
N_t=\gamma\left[\phi_{t-1}\delta_{t-1}+1-S_{t-1}(1-\delta_{t-1})\right]R_{t-1}N_{t-1}
+\omega B_{t-1}+N_t^s.
\]

简化线性系统中，论文设定 `\omega=0`。

- **(F11) 线性 Phillips 曲线，论文方程 (22)**：

\[
\widehat{\pi}_t=\kappa\left[
(\sigma+\theta)\widehat{y}_t^g
+\alpha(\widehat{R}_t+b\widehat{\phi}_t)
+\widehat{\varepsilon}_t
\right]+\beta E_t\widehat{\pi}_{t+1}.
\]

- **(F12) 线性 Euler / IS 方程，论文方程 (23)**：

\[
\widehat{R}_t=\sigma E_t\Delta\widehat{y}_{t+1}^g
+\frac{\theta+1}{\sigma+\theta}\sigma E_t\Delta\widehat{a}_{t+1}
+E_t\widehat{\pi}_{t+1}.
\]

- **(F13) 线性净值演化，论文方程 (24)；`needs_review` OCR tag 间距**：

\[
\widehat{n}_t=\widehat{n}_{t-1}+\widehat{R}_{t-1}-\widehat{\pi}_t
+\frac{1}{\phi\delta+1}\left[
\phi\delta\widehat{\delta}_{t-1}
+\delta\widehat{\phi}_{t-1}
+(\delta-1)\widehat{S}_{t-1}
\right]+\widehat{n}_t^s.
\]

- **(F14) 企业劳动需求与银行部门资产负债关系，论文方程 (25)**：

\[
\widehat{\delta}_t+\widehat{n}_t
=(1+\sigma+\theta)\widehat{y}_t^g
+\frac{\theta+1}{\sigma+\theta}\widehat{a}_t
-(1-\alpha)(\widehat{R}_t+b\widehat{\phi}_t).
\]

- **(F15) 线性激励相容约束，论文方程 (26)**：

\[
\widehat{\delta}_t+\widehat{\lambda}_t
=\delta\widehat{\phi}_t+(\delta-1)\widehat{S}_t
+\beta E_t\left[
(\phi\delta+1)\widehat{\delta}_{t+1}
+\widehat{\lambda}_{t+1}
\right].
\]

## 4. Market Clearing & Identities

- **(F16) 含 Rotemberg 成本的最终品市场出清**：

\[
y_t=c_t+\frac{\varphi}{2}(\pi_t-1)^2y_t.
\]

- **(F17) 产出缺口定义**：

\[
\widehat{y}_t^g=\widehat{y}_t-\frac{1+\theta}{\sigma+\theta}\widehat{a}_t.
\]

- **(F18) 有效融资成本 / 信用扭曲指标**：

\[
\widehat{f}_t=\widehat{R}_t+b\widehat{\phi}_t,
\qquad b=\frac{1}{1+\phi}.
\]

- **(F19) 实现交叉检查使用的边际成本表达式**：

\[
\widehat{z}_t=\kappa\left[(\sigma+\theta)\widehat{y}_t^g
+\alpha(\widehat{R}_t+b\widehat{\phi}_t)\right].
\]

- **(F20) Rep-MMB 实现中的宏观审慎闭合**：

\[
\widehat{S}_t=0.
\]

- **(F21) Rep-MMB 实现中的 Taylor 规则闭合**：

\[
\widehat{R}_t=\tau\widehat{\pi}_t+\tau_g\widehat{y}_t^g+\widehat{\varepsilon}_{R,t}.
\]

## 5. Exogenous Processes

论文为生产率、markup、净值和 moral hazard 冲击设定自回归过程。Rep-MMB 实现还加入自回归货币政策冲击：

- **(F22) 技术冲击**：

\[
\widehat{a}_t=\rho_a\widehat{a}_{t-1}+\eta_{a,t}.
\]

- **(F23) Markup 冲击**：

\[
\widehat{\varepsilon}_t=\rho_m\widehat{\varepsilon}_{t-1}+\eta_{m,t}.
\]

- **(F24) 净值冲击**：

\[
\widehat{n}^s_t=\rho_n\widehat{n}^s_{t-1}+\eta_{n,t}.
\]

- **(F25) 货币政策冲击，实现交叉检查闭合**：

\[
\widehat{\varepsilon}_{R,t}=\rho_R\widehat{\varepsilon}_{R,t-1}+\eta_{R,t}.
\]

- **(F26) Moral-hazard 冲击**：

\[
\widehat{\lambda}_t=\rho_l\widehat{\lambda}_{t-1}+\eta_{l,t}.
\]

Rep-MMB `.mod` 使用符号约定 `a=rho_a*a(-1)-eta_a`、`ns=rho_n*ns(-1)-eta_n` 和 `eps_R=rho_R*eps_R(-1)-eta_R`；这些是实现约定，不是额外的论文侧公式。

## 6. Steady-State Solution

由于归档实现为 `model(linear)`，操作性稳态中所有带帽内生变量均为零：

\[
\widehat{y}=\widehat{y}^g=\widehat{R}=\widehat{\pi}=\widehat{\phi}
=\widehat{n}=\widehat{\delta}=\widehat{S}=\widehat{z}=0.
\]

论文和实现交叉检查给出的稳态水平及校准目标：

1. `\beta=0.99`，`\sigma=1`。
2. 劳动/投入份额 `\alpha=0.50`。
3. 稳态杠杆 `\delta=9`。
4. 稳态信用利差 `\phi=0.02`，因此 `b=1/(1+\phi)`。
5. 替代弹性 `\epsilon=10`。
6. Rep-MMB 文件中的调价成本 `\varphi=211`；论文正文报告 `173.08`，因此这是待复核的校准差异。
7. `\kappa=(\epsilon-1)/\varphi`。
8. 冲击持续性：`\rho_a=0.95`，`\rho_m=0.95`，`\rho_n=0`；Rep-MMB 文件补充 `\rho_R=0.5` 和 `\rho_l=0.5`，因为论文未给出这些值。

未进行非线性稳态重构或 Dynare 验证。

## 7. Timing & Form Conventions

- **形式**：`model(linear)`；变量表示相对稳态的对数偏离，但 `\widehat{\phi}_t`、`\widehat{S}_t` 和 `\widehat{R}_t` 为水平偏离。
- **预定状态**：净值方程中，银行净值、杠杆、利差、补贴和名义利率以滞后形式出现。
- **前瞻变量**：通胀、产出缺口增长、生产率增长、杠杆和 moral-hazard 项在 (F11)、(F12) 和 (F15) 中以期望形式出现。
- **金融约定**：银行杠杆是贷款相对于银行家净值的比例，`\delta_t=B_{jt}/N_{jt}`。
- **资本约定**：无资本积累；模型使用固定资本和可变利用率服务。
- **政策约定**：论文政策分析研究 `R_t` 和 `S_t` 的合作与非合作最优选择；Rep-MMB 用 Taylor 规则和 `S_t=0` 闭合。
- **运行验证**：未执行。

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Determined by |
|---|---|---|---|
| Endogenous | `y` / `\widehat{y}_t` | 产出偏离 | (F17), implementation identity |
| Endogenous | `yg` / `\widehat{y}^g_t` | 产出缺口 | (F17) |
| Endogenous | `R` / `\widehat{R}_t` | 名义利率偏离 | (F12), (F21) |
| Endogenous | `pi` / `\widehat{\pi}_t` | 通胀偏离 | (F11) |
| Endogenous | `phi` / `\widehat{\phi}_t` | 信用利差偏离 | (F15), (F18) |
| Endogenous | `n` / `\widehat{n}_t` | 实际银行净值 | (F13) |
| Endogenous | `del` / `\widehat{\delta}_t` | 银行杠杆 | (F14), (F15) |
| Endogenous | `S` / `\widehat{S}_t` | 宏观审慎补贴 | (F20), or optimal-policy problem outside Rep-MMB closure |
| Endogenous | `z` / `\widehat{z}_t` | 边际成本指标 | (F19) |
| Endogenous shock state | `a` / `\widehat{a}_t` | 技术状态 | (F22) |
| Endogenous shock state | `eps_m` / `\widehat{\varepsilon}_t` | markup 冲击状态 | (F23) |
| Endogenous shock state | `ns` / `\widehat{n}^s_t` | 净值冲击状态 | (F24) |
| Endogenous shock state | `eps_R` / `\widehat{\varepsilon}_{R,t}` | 货币政策冲击状态 | (F25) |
| Endogenous shock state | `lam` / `\widehat{\lambda}_t` | moral-hazard 冲击状态 | (F26) |
| Exogenous | `eta_a` | 技术创新 | -- |
| Exogenous | `eta_m` | markup 创新 | -- |
| Exogenous | `eta_n` | 净值创新 | -- |
| Exogenous | `eta_R` | 货币政策创新 | -- |
| Exogenous | `eta_l` | moral-hazard 创新 | -- |
| Parameter | `betta` / `\beta` | 贴现因子 | -- |
| Parameter | `sig` / `\sigma` | 风险规避 / 跨期替代参数 | -- |
| Parameter | `alfa` / `\alpha` | 需要营运资本融资的投入份额 | -- |
| Parameter | `thet` / `\theta` | 劳动供给弹性倒数 | -- |
| Parameter | `eps` / `\epsilon` | 商品替代弹性 | -- |
| Parameter | `del_ss` / `\delta` | 稳态杠杆 | -- |
| Parameter | `phi_ss` / `\phi` | 稳态信用利差 | -- |
| Parameter | `varphi` / `\varphi` | Rotemberg 调价成本 | -- |
| Parameter | `b` | `1/(1+\phi)` | -- |
| Parameter | `kap` / `\kappa` | Phillips 曲线斜率，`(eps-1)/varphi` | -- |
| Parameter | `rho_a, rho_m, rho_n, rho_R, rho_l` | 冲击持续性系数 | -- |
| Parameter | `tau, tau_g` | Taylor 规则系数 | -- |
