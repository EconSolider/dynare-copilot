# US_ACELswt - 推导（最优化问题与均衡条件）

> 归档状态：`needs_review`。本一稿推导以 Altig、Christiano、Eichenbaum 和 Linde（2005）的 MinerU Markdown 为论文侧来源。本地 MMB `.mod` 仅作为 `implementation_cross_check` 使用；未执行 Dynare 运行验证。

来源信息：模型 ID `US_ACELswt`；论文 "Firm-specific capital, nominal rigidities"；作者 David Altig、Lawrence J. Christiano、Martin Eichenbaum 和 Jesper Linde；年份 2005；DOI `10.3386/w11034`；来源 Markdown `raw/mmb_mineru/runs/us_acelm_us_acelswm_us_acelswt_us_acelt__firm_specific_capital_nominal_rigidities__e0fac58f/full.md`；原始 PDF `raw/mmb_papers/Firm-specific capital, nominal rigidities.pdf`；MinerU run id `e0fac58f-0dfb-476b-b2df-8712e57d9ce4`。

## 1. Model Overview

- **模型**：含企业特定资本和名义刚性的美国中等规模估计型新凯恩斯模型。论文比较同质资本与企业特定资本两个版本；`US_ACELswt` 对应 MMB 的黏性价格/黏性工资实现，并以企业特定资本为目标解释。
- **主体与模块**：最终品加总商；垄断竞争中间品企业；具有习惯形成、货币需求、可变资本利用率、投资调整成本和 Calvo 工资设定的家庭；为工资账单融资的金融中介；货币当局；一次总付财政当局。
- **冲击**：货币基础增长冲击、中性技术增长冲击、资本体现型技术增长冲击，以及 MMB 实现交叉检查中的额外暂时性中性技术冲击。
- **形式**：论文说明计算策略是在非随机稳态附近作线性近似。MMB 文件为 `model(linear)`，因此本归档条目的形式是**对数线性/线性偏离**。除非明确标为非线性来源原式，下列所有 `F#` 方程都应理解为线性化均衡限制。
- **企业特定资本核心机制**：企业资本在期内预定，不能在企业之间即时重新配置。这使单个企业的边际成本随自身产出上升，并在给定价格重优化频率下压低总量通胀方程斜率。

## 2. Optimization Problems

### 2.1 最终品企业

竞争性最终品企业组合差异化中间品：

\[
Y_t=\left[\int_0^1 y_t(i)^{1/\lambda_f}\,di\right]^{\lambda_f},
\qquad 1\leq \lambda_f<\infty .
\]

它在给定所有价格的情况下选择投入以最大化最终品利润。

### 2.2 中间品企业

在同质资本基准中，中间品生产者 \(i\) 使用：

\[
y_t(i)=K_t(i)^\alpha\left(z_t h_t(i)\right)^{1-\alpha}-\phi z_t^{\ast},
\qquad
z_t^{\ast}=\Upsilon_t^{\alpha/(1-\alpha)}z_t .
\]

企业在 Calvo 摩擦下设定价格。若不能重优化，则按滞后通胀指数化。其贴现名义利润目标为：

\[
E_t\sum_{j=0}^{\infty}\beta^j v_{t+j}\left[
P_{t+j}(i)y_{t+j}(i)
-P_{t+j}\left(w_{t+j}R_{t+j}h_{t+j}(i)+r^k_{t+j}K_{t+j}(i)\right)
\right].
\]

在企业特定资本模型中，每个企业拥有预定的实物资本。它选择价格、就业、资本利用率和投资以最大化：

\[
E_t\sum_{j=0}^{\infty}\beta^j v_{t+j}\left\{
P_{t+j}(i)y_{t+j}(i)
-P_{t+j}R_{t+j}w_{t+j}h_{t+j}(i)
-P_{t+j}\Upsilon_{t+j}^{-1}\left[I_{t+j}(i)+a(u_{t+j}(i))\bar K_{t+j}(i)\right]
\right\}.
\]

### 2.3 家庭

家庭 \(j\) 对消费和工时具有习惯形成偏好：

\[
E_t^j\sum_{\ell=0}^{\infty}\beta^{\ell-t}
\left[
\log(C_{t+\ell}-bC_{t+\ell-1})
-\psi_L\frac{h_{j,t+\ell}^2}{2}
\right].
\]

名义资产积累约束为：

\[
\begin{aligned}
M_{t+1}={}&R_t\left[M_t-Q_t+(x_t-1)M_t^a\right]+A_{j,t}+Q_t+W_{j,t}h_{j,t} \\
&+P_t r_t^k u_t\bar K_t+D_t-(1+\eta(V_t))P_tC_t
-P_t\Upsilon_t^{-1}\left[I_t+a(u_t)\bar K_t\right].
\end{aligned}
\]

家庭还在 Calvo 工资摩擦和工资指数化约束下选择工资报价。

## 3. First-Order Conditions

- **(F1) 最终品对品种 \(i\) 的需求**：

\[
\frac{y_t(i)}{Y_t}=\left(\frac{P_t}{P_t(i)}\right)^{\lambda_f/(\lambda_f-1)} .
\]

- **(F2) 总最终品价格指数**：

\[
P_t=\left[\int_0^1 P_t(i)^{1/(1-\lambda_f)}\,di\right]^{1-\lambda_f}.
\]

- **(F3) 不能重优化企业的价格指数化**：

\[
P_t(i)=\pi_{t-1}P_{t-1}(i).
\]

- **(F4) 资本服务定义**：

\[
K_t=u_t\bar K_t .
\]

- **(F5) 货币需求 FOC**：

\[
R_t=1+\eta'\left(\frac{P_tC_t}{Q_t}\right)\left(\frac{P_tC_t}{Q_t}\right)^2 .
\]

- **(F6) 平衡增长路径上的稳态 Fisher 关系**：

\[
R=\frac{\pi\mu_{z^{\ast}}}{\beta}.
\]

- **(F7) 工资服务加总器**：

\[
H_t=\left[\int_0^1 h_{j,t}^{1/\lambda_w}\,dj\right]^{\lambda_w},
\qquad 1\leq\lambda_w<\infty .
\]

- **(F8) 对家庭劳动类型 \(j\) 的需求**：

\[
h_{j,t}=\left(\frac{W_t}{W_{j,t}}\right)^{\lambda_w/(\lambda_w-1)}H_t .
\]

- **(F9) 总工资指数**：

\[
W_t=\left[\int_0^1 W_{j,t}^{1/(1-\lambda_w)}\,dj\right]^{1-\lambda_w}.
\]

- **(F10) 不能重优化家庭的工资指数化**：

\[
W_{j,t}=\pi_{t-1}\mu_{z^{\ast}}W_{j,t-1}.
\]

- **(F11) 论文中的通胀方程简约式**：

\[
\Delta\hat\pi_t=E\left[\beta\Delta\hat\pi_{t+1}+\gamma\hat s_t\mid\Omega_t\right],
\qquad
\gamma=\frac{(1-\xi_p)(1-\beta\xi_p)}{\xi_p}\chi .
\]

对同质资本，\(\chi=1\)。对企业特定资本，\(\chi\) 是结构参数的非线性函数；由于来源 Markdown 未包含精确附录表达式，标记为 `needs_review`。

### 3.1 线性 MMB 实现交叉检查方程

MMB 实现使用以下黏性价格线性限制。这些不被当作论文侧数学来源；这里只记录它们以便审计 MMB 变量和方程覆盖。

- **(F12) 资本 Euler 方程**（`implementation_cross_check`，需对照技术附录 `needs_review`）：

\[
\hat\lambda_{z^{\ast},t+1}
+\frac{1-\delta}{\tilde r+1-\delta}\hat{\tilde\mu}_{t+1}
+\frac{\tilde r}{\tilde r+1-\delta}\hat{\tilde r}_{t+1}
-\hat\lambda_{z^{\ast},t}-\hat{\tilde\mu}_t
=\hat\mu_{z,t+1}+\frac{1}{1-\alpha}\hat\mu_{\Upsilon,t+1}.
\]

- **(F13) 投资 Euler 方程**（`implementation_cross_check`，`needs_review`）：

\[
\begin{aligned}
&-\beta\kappa(\mu_{z^{\ast}}\mu_\Upsilon)^2\hat i_{t+1}-\hat{\tilde\mu}_t
+\kappa(\mu_{z^{\ast}}\mu_\Upsilon)^2(1+\beta)\hat i_t
-\kappa(\mu_{z^{\ast}}\mu_\Upsilon)^2\hat i_{t-1} \\
&=\beta\kappa(\mu_{z^{\ast}}\mu_\Upsilon)^2\hat\mu_{z,t+1}
+\frac{\beta\kappa(\mu_{z^{\ast}}\mu_\Upsilon)^2}{1-\alpha}\hat\mu_{\Upsilon,t+1}
-\kappa(\mu_{z^{\ast}}\mu_\Upsilon)^2\hat\mu_{z,t}
-\frac{\kappa(\mu_{z^{\ast}}\mu_\Upsilon)^2}{1-\alpha}\hat\mu_{\Upsilon,t}.
\end{aligned}
\]

- **(F14) 资本影子租金率**（`implementation_cross_check`，`needs_review`）：

\[
\hat{\tilde w}_t+\frac{1}{1-\alpha}\frac{\tilde y}{\tilde y+\phi}\hat{\tilde y}_t
+\frac{\nu R}{\nu R+1-\nu}\hat R_t-\hat{\tilde r}_t
-\frac{1}{1-\alpha}\hat u_t-\frac{1}{1-\alpha}\hat{\bar k}_{t-1}
=-\frac{1}{1-\alpha}\hat\mu_{z,t}
-\frac{1}{(1-\alpha)^2}\hat\mu_{\Upsilon,t}
+\frac{1}{1-\alpha}\hat\epsilon_t .
\]

- **(F15) 线性资本演化**（`implementation_cross_check`）：

\[
(\mu_{z^{\ast}}\mu_\Upsilon-(1-\delta))\hat i_t
-\mu_\Upsilon\mu_{z^{\ast}}\hat{\bar k}_t
+(1-\delta)\hat{\bar k}_{t-1}
=(1-\delta)\hat\mu_{z,t}
+\frac{1-\delta}{1-\alpha}\hat\mu_{\Upsilon,t}.
\]

- **(F16) MMB 文件中的黏性价格通胀方程**（`implementation_cross_check`）：

\[
\beta\hat\pi_{t+1}-(1+\beta\varsigma)\hat\pi_t+\gamma\hat s_t
=-\varsigma\hat\pi_{t-1}.
\]

- **(F17) 线性边际成本方程**（`implementation_cross_check`，`needs_review`）：

\[
\hat{\tilde w}_t-\hat s_t+\frac{\alpha}{1-\alpha}\frac{\tilde y}{\tilde y+\phi}\hat{\tilde y}_t
+\frac{\nu R}{\nu R+1-\nu}\hat R_t
-\frac{\alpha}{1-\alpha}\hat u_t
-\frac{\alpha}{1-\alpha}\hat{\bar k}_{t-1}
=-\frac{\alpha}{1-\alpha}\hat\mu_{z,t}
-\frac{\alpha}{(1-\alpha)^2}\hat\mu_{\Upsilon,t}
+\frac{1}{1-\alpha}\hat\epsilon_t .
\]

- **(F18) 线性货币需求**（`implementation_cross_check`）：

\[
\hat c_t-\hat q_t=\frac{R}{R-1}\frac{1}{2+\varphi}\hat R_t .
\]

- **(F19) 线性消费 Euler 方程**（`implementation_cross_check`，`needs_review`）：

\[
\text{linear habit Euler restriction in }(\hat c_{t+1},\hat c_t,\hat c_{t-1},\hat\lambda_{z^{\ast},t},\hat q_t,\hat\mu_{z,t+1},\hat\mu_{\Upsilon,t+1},\hat\mu_{z,t},\hat\mu_{\Upsilon,t}).
\]

精确系数表达式在实现交叉检查中可见；推广前应对照技术附录核实。

- **(F20) 货币基础 FOC**（`implementation_cross_check`）：

\[
\hat\lambda_{z^{\ast},t+1}-\hat\pi_{t+1}+\hat R_{t+1}-\hat\lambda_{z^{\ast},t}
=\hat\mu_{z,t+1}+\frac{\alpha}{1-\alpha}\hat\mu_{\Upsilon,t+1}.
\]

- **(F21) 线性工资 FOC**（`implementation_cross_check`，`needs_review`）：

\[
\eta_3\hat{\tilde w}_{t+1}+\eta_6\hat\pi_{t+1}
+\eta_2\hat{\tilde w}_t+\eta_5\hat\pi_t+\eta_7\hat h_t+\eta_8\hat\lambda_{z^{\ast},t}
+\eta_1\hat{\tilde w}_{t-1}+\eta_4\hat\pi_{t-1}
=-\eta_{10}\frac{\alpha}{1-\alpha}\hat\mu_{\Upsilon,t+1}-\eta_{10}\hat\mu_{z,t+1}
-\eta_9\frac{\alpha}{1-\alpha}\hat\mu_{\Upsilon,t}-\eta_9\hat\mu_{z,t}.
\]

- **(F22) 资本利用率 FOC**（`implementation_cross_check`）：

\[
\frac{1}{\sigma_a}\hat{\tilde r}_t=\hat u_t .
\]

## 4. Market Clearing & Identities

- **(F23) 平衡增长技术缩放**：

\[
\mu_{z^{\ast},t}=\mu_{\Upsilon,t}^{\alpha/(1-\alpha)}\mu_{z,t}.
\]

- **(F24) 投资到资本的转换，同质资本**：

\[
\bar K_{t+1}=(1-\delta)\bar K_t+\left[1-S\left(\frac{I_t}{I_{t-1}}\right)\right]I_t .
\]

- **(F25) 企业特定资本积累**：

\[
\bar K_{t+1}(i)=(1-\delta)\bar K_t(i)
+\left[1-S\left(\frac{I_t(i)}{I_{t-1}(i)}\right)\right]I_t(i).
\]

- **(F26) 贷款市场出清**：

\[
W_tH_t=x_tM_t-Q_t .
\]

- **(F27) 最终品资源约束**：

\[
(1+\eta(V_t))C_t+\Upsilon_t^{-1}\left[I_t+a(u_t)\bar K_t\right]\leq Y_t .
\]

- **(F28) 线性生产函数**（`implementation_cross_check`）：

\[
(\tilde y+\phi)(1-\alpha)\hat h_t-\tilde y\hat{\tilde y}_t
+\left((\tilde y+\phi)\alpha-\frac{\tilde r\bar k}{\mu_{z^{\ast}}\mu_\Upsilon}\right)\hat u_t
+(\tilde y+\phi)\alpha\hat{\bar k}_{t-1}
=(\tilde y+\phi)\alpha\hat\mu_{z,t}
+\frac{(\tilde y+\phi)\alpha}{1-\alpha}\hat\mu_{\Upsilon,t}
-(\tilde y+\phi)\hat\epsilon_t .
\]

- **(F29) 线性资源约束**（`implementation_cross_check`，`needs_review`）：

\[
\begin{aligned}
&\left((1+\eta)c+\eta'c^2/q\right)\hat c_t
+\left(1-\frac{1-\delta}{\mu_\Upsilon\mu_{z^{\ast}}}\right)\bar k\,\hat i_t
-(\tilde y+\phi)(1-\alpha)\hat h_t-\eta'c^2/q\,\hat q_t \\
&+\left(\frac{\tilde r\bar k}{\mu_{z^{\ast}}\mu_\Upsilon}-(\tilde y+\phi)\alpha\right)\hat u_t
-(\tilde y+\phi)\alpha\hat{\bar k}_{t-1}
+(\tilde y+\phi)\alpha\hat\mu_{z,t}
+\frac{(\tilde y+\phi)\alpha}{1-\alpha}\hat\mu_{\Upsilon,t}
-(\tilde y+\phi)\hat\epsilon_t=0 .
\end{aligned}
\]

- **(F30) 货币市场出清**（`implementation_cross_check`）：

\[
\hat{\tilde w}_t-\frac{x m}{xm-q}\hat m_t+\hat h_t+\frac{q}{xm-q}\hat q_t
=\frac{x m}{xm-q}\hat x_t .
\]

- **(F31) 货币基础积累恒等式**（`implementation_cross_check`）：

\[
-\hat m_t-\hat\pi_t+\hat m_{t-1}+\hat x_{t-1}
=\hat\mu_{z,t}+\frac{\alpha}{1-\alpha}\hat\mu_{\Upsilon,t}.
\]

## 5. Exogenous Processes

- **(F32) 货币增长政策分解**：

\[
\hat x_t=\hat x_{z,t}+\hat x_{\Upsilon,t}+\hat x_{M,t}.
\]

- **(F33) 货币冲击过程**：

\[
\hat x_{M,t}=\rho_{xM}\hat x_{M,t-1}+\varepsilon_{M,t}.
\]

- **(F34) 中性技术增长**：

\[
\hat\mu_{z,t}=\rho_{\mu_z}\hat\mu_{z,t-1}+\varepsilon_{\mu_z,t}.
\]

- **(F35) 政策对中性技术创新的响应**：

\[
\hat x_{z,t}=\rho_{xz}\hat x_{z,t-1}+c_z\varepsilon_{z,t}+c_z^p\varepsilon_{z,t-1}.
\]

- **(F36) 资本体现型技术增长**：

\[
\hat\mu_{\Upsilon,t}=\rho_{\mu_\Upsilon}\hat\mu_{\Upsilon,t-1}+\varepsilon_{\mu_\Upsilon,t}.
\]

- **(F37) 政策对体现型技术创新的响应**：

\[
\hat x_{\Upsilon,t}=\rho_{x\Upsilon}\hat x_{\Upsilon,t-1}+c_\Upsilon\varepsilon_{\Upsilon,t}+c_\Upsilon^p\varepsilon_{\Upsilon,t-1}.
\]

- **(F38) MMB 实现中的暂时性中性技术过程**（`implementation_cross_check`）：

\[
\hat\epsilon_t=\rho_\epsilon\hat\epsilon_{t-1}+\sigma_\epsilon\varepsilon_{\epsilon,t}.
\]

## 6. Steady-State Solution

来源论文描述了平衡增长路径上的非随机稳态。MMB 实现为线性模型提供了具体的稳态归一化：

1. 计算 \(\mu_{z^{\ast}}=\mu_\Upsilon^{\alpha/(1-\alpha)}\mu_z\)。
2. 计算稳态资本租金项：

\[
\tilde r=\frac{\mu_\Upsilon\mu_{z^{\ast}}}{\beta}-(1-\delta).
\]

3. 计算稳态通胀和名义总利率：

\[
\pi=\frac{x}{\mu_{z^{\ast}}},
\qquad
R=\frac{\pi\mu_{z^{\ast}}}{\beta}.
\]

4. 从 velocity 计算货币需求交易成本斜率：

\[
\eta'=\frac{R-1}{V^2},
\qquad
\varphi=\frac{1}{4\epsilon(R-1)}-2.
\]

5. 令 \(s=1/\lambda_f\)、\(R_\nu=\nu R+1-\nu\)，并按 `US_ACELswt_rep.mod` 中的递归公式求稳态实际工资、资本-工时比、资本、工时、消费、实际货币余额、产出、固定成本、投资和边际效用。

由于本归档条目对应 `model(linear)` 实现，稳态值是偏离变量所围绕的参数；模型块中的所有动态变量确定性稳态为零。精确系数级稳态递归标记为 `implementation_cross_check`，在任何可运行推广之前应对照技术附录审查。

## 7. Timing & Form Conventions

- **信息时序**：技术冲击先于价格/工资和实际决策被观察；货币政策冲击发生在价格/工资设定之后、需求实现之前。
- **企业特定资本时序**：企业 \(i\) 进入 \(t\) 期时持有预定的 \(\bar K_t(i)\)。它只能通过当期投资 \(I_t(i)\) 调整未来资本，因此货币冲击后的产出需求主要通过劳动需求和资本利用率满足，而不是通过当期资本重新配置满足。
- **资本存量**：MMB 变量 `kbar_t1` 表示生产方程中来自上一期的可用实物资本存量，以及资本法则更新的存量。
- **工资与价格**：价格和工资均为 Calvo，并带滞后通胀指数化；论文通胀方程使用 \(\Delta\hat\pi_t\)，而 MMB 线性交叉检查用 \(\hat\pi_t,\hat\pi_{t+1},\hat\pi_{t-1}\) 写黏性价格方程。
- **模型形式**：`model(linear)`。帽变量表示相对平衡增长稳态的对数偏离或平稳百分比偏离。本条目未运行 Dynare，也不认证 Blanchard-Kahn 条件或 IRF 行为。

## 8. Variable & Parameter Reference Table

| 类别 | 符号 / ASCII 名称 | 含义 | 主要方程 |
|---|---|---|---|
| 内生 | `c_t` | 消费偏离 | (F18), (F19), (F29) |
| 内生 | `wtilde_t` | 平稳实际工资偏离 | (F17), (F21), (F30) |
| 内生 | `lambda_zstar_t` | 边际效用/乘子偏离 | (F12), (F19), (F20), (F21) |
| 内生 | `m_t` | 货币存量偏离 | (F30), (F31) |
| 内生 | `pi_t` | 通胀偏离 | (F16), (F21), (F31) |
| 内生 | `x_t` | 货币增长偏离 | (F32), (F33), (F35), (F37) |
| 内生 | `s_t` | 边际成本偏离 | (F16), (F17) |
| 内生 | `i_t` | 投资偏离 | (F13), (F15), (F29) |
| 内生 | `h_t` | 工时偏离 | (F21), (F28), (F29), (F30) |
| 内生 | `kbar_t1` | 预定资本存量偏离 | (F15), (F28), (F29) |
| 内生 | `q_t` | 实际现金余额偏离 | (F18), (F19), (F29), (F30) |
| 内生 | `ytilde_t` | 平稳产出偏离 | (F14), (F17), (F28) |
| 内生 | `R_t` | 实现中的名义/短期利率偏离 | (F14), (F18), (F20) |
| 内生 | `mutilde_t` | 安装资本影子价值 | (F12), (F13) |
| 内生 | `rhotilde_t` | 资本租金回报 | (F12), (F14), (F22) |
| 内生 | `u_t` | 利用率偏离 | (F14), (F17), (F22), (F28), (F29) |
| 内生 | `x_M_t`, `eps_M_t` | 货币冲击状态和创新复制变量 | (F33) |
| 内生 | `mu_z_t`, `eps_muz_t`, `x_z_t` | 中性技术增长及政策响应状态 | (F34), (F35) |
| 内生 | `mu_ups_t`, `eps_muups_t`, `x_ups_t` | 体现型技术增长及政策响应状态 | (F36), (F37) |
| 内生 | `epsilon_t` | 暂时性中性技术状态 | (F38) |
| 内生 | `*_f` variables | 黏性价格模块的灵活价格对应变量 | 灵活价格实现交叉检查 |
| 外生 | `epsilon_M_` | 货币政策创新 | (F33) |
| 外生 | `eps_muz_` | 中性技术增长创新 | (F34) |
| 外生 | `eps_muups_` | 体现型技术增长创新 | (F36) |
| 外生 | `epsilon_t_` | 暂时性中性技术创新 | (F38) |
| 参数 | `alpha` | 资本份额 | (F12)-(F17), (F23), (F28)-(F31) |
| 参数 | `b` | 习惯持久性 | (F19), 稳态 |
| 参数 | `beta` | 贴现因子 | (F6), (F11)-(F13), (F16), (F19) |
| 参数 | `delta` | 折旧率 | (F15), (F24), (F25) |
| 参数 | `eta`, `eta_pr`, `V`, `sig_eta` | 交易成本和 velocity 参数 | (F5), (F18), (F29) |
| 参数 | `lambda_f`, `lambda_w` | 产品和劳动加成参数 | (F1), (F7)-(F9), 稳态 |
| 参数 | `xi_w`, `xif_w` | 实现中的黏性/灵活工资 Calvo 参数 | (F21) |
| 参数 | `gamma`, `squig` | 通胀斜率和指数化系数 | (F11), (F16) |
| 参数 | `sigma_a` | 利用率成本曲率 | (F22) |
| 参数 | `kappa` | 投资调整成本曲率 | (F13) |
| 参数 | `rho_*`, `theta_*`, `c_*`, `cp_*` | 冲击持久性和 ARMA 响应参数 | (F33)-(F38) |

运行验证：未执行。公式质量：需要单独技术附录的系数级线性方程标记为 `needs_review`。
