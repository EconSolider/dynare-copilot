# US_FU19 -- 推导（最优化问题 + 一阶条件）

> 本推导用于私有模型存档库的源材料整理，暂不用于直接生成 runnable Dynare `.mod` 文件。当前状态为 `needs_review`。Fratto-Uhlig 论文说明基准模型是原始 Smets-Wouters (2007) 模型，并给出若干会计分解方程；但论文正文没有重印完整的源层推导。`US_FU19_rep.mod` 仅作为 `implementation_cross_check` 使用。

## 1. Model Overview

- 模型：Fratto and Uhlig (2019), "Accounting for Post Crisis Inflation: A Retro Analysis"。
- MMB 代码：`US_FU19`。
- 论文信息：Chiara Fratto and Harald Uhlig, *Review of Economic Dynamics*, DOI `10.1016/j.red.2019.05.005`。
- 形式：估计用的 log-linear 中等规模 New Keynesian DSGE，通胀会计分解使用原始 Smets-Wouters (2007) 基准模型。本地实现使用 `model(linear)`。
- 主体：代表性家庭、最终品生产者、中间品企业、劳动/工资设定模块、资本积累和利用率模块、政府/中央银行。
- 主要摩擦：外部习惯、投资调整成本、可变资本利用率、固定成本、Calvo 价格和工资设定、价格和工资指数化。
- 冲击：技术、偏好/风险溢价、政府支出、投资专用技术、价格 markup、工资 markup、货币政策。
- 观测变量：产出增长、消费增长、投资增长、实际工资增长、劳动/工时、通胀、联邦基金利率。

源材料限制：论文侧 Markdown 描述了 Smets-Wouters 结构，并印出了 hybrid Phillips curve、ZLB 货币意外映射、time-varying inflation-target 扩展，以及若干 Del Negro et al. 金融摩擦扩展方程。完整 Smets-Wouters 模型方程没有出现在本文正文中，需要对照所引用的 Smets-Wouters 来源/在线附录复核。

## 2. Optimization Problems

### 2.1 代表性家庭

家庭具有消费外部习惯，供给劳动，持有债券，并通过可变利用率投资物质资本。Fratto-Uhlig 论文正文没有印出源层完整效用函数和预算约束；目标基准是 Smets-Wouters 家庭模块。待核实的通用源层问题为：

```math
\max E_0\sum_{t=0}^{\infty}\beta^t
\left[
U(C_t-hC_{t-1},L_t)
\right]
```

约束为实际预算约束，将资源分配到消费、债券持有、投资、资本利用成本、税收、工资收入、租金收入、债券收益和利润。`needs_review`：确切的非线性家庭问题不在 US_FU19 Markdown 中。

### 2.2 最终品生产者

最终品生产者聚合差异化中间品，并在给定相对价格下选择中间品需求。`needs_review`：US_FU19 指明 Smets-Wouters 基准以及 Calvo/Kimball 风格的价格设定，但没有印出完整最终品聚合问题。

### 2.3 中间品企业

中间品企业租用有效资本和劳动，生产差异化产品，并在 Calvo 黏性和部分指数化下设定价格。论文的会计分解讨论集中在价格 markup 渠道。`needs_review`：论文给出了约化 hybrid Phillips curve，但没有给出完整企业目标函数和重设价格 FOC。

### 2.4 工资设定模块

家庭或劳动 union 在 Calvo 工资黏性和部分指数化下设定差异化工资。工资 markup shock 是论文通胀会计分解的核心。`needs_review`：论文描述了工资 markup 和工资 Phillips-curve 作用，但没有印出完整工资设定目标。

### 2.5 政策与会计分解模块

货币当局遵循线性 Taylor 型规则。基准 retro analysis 在规则隐含名义利率为负时，把线性 Taylor-rule 利率和实际零利率之间的差额作为一系列 surprise monetary shocks。

## 3. First-Order Conditions

以下条件是 US_FU19 存档条目的源支持框架。直接来自 Fratto-Uhlig Markdown 的方程标为 `source_stated`；从 Smets-Wouters 基准推断并用 `US_FU19_rep.mod` 交叉检查的方程标为 `needs_review`。

**(F1) 带习惯和风险溢价 wedge 的消费 Euler 方程**（`needs_review`）：

```math
c_t =
\frac{h/\gamma}{1+h/\gamma}c_{t-1}
+\frac{1}{1+h/\gamma}E_t c_{t+1}
+\frac{(\sigma_c-1)w_L^c}{\sigma_c(1+h/\gamma)}(L_t-E_tL_{t+1})
-\frac{1-h/\gamma}{\sigma_c(1+h/\gamma)}(R_t-E_t\pi_{t+1})
+b^2_t .
```

**(F2) 投资 Euler 方程 / 投资调整成本 FOC**（`needs_review`）：

```math
i_t =
\frac{1}{1+\bar{\beta}\gamma}
\left(i_{t-1}+\bar{\beta}\gamma E_t i_{t+1}
+\frac{1}{\gamma^2\varphi_i}Q_t\right)+\mu_t .
```

**(F3) 已安装资本价值 / Tobin's Q**（`needs_review`）：

```math
Q_t =
\frac{1}{\chi_c}b^2_t
-(R_t-E_t\pi_{t+1})
+\frac{r_k^\ast}{r_k^\ast+1-\delta}E_t r^k_{t+1}
+\frac{1-\delta}{r_k^\ast+1-\delta}E_tQ_{t+1}.
```

其中 $`\chi_c=(1-h/\gamma)/[\sigma_c(1+h/\gamma)]`$。

**(F4) 资本利用率条件**（`needs_review`）：

```math
u_t=\frac{1-c_z}{c_z}r^k_t .
```

**(F5) 有效资本服务**（`needs_review`）：

```math
k_t=u_t+\bar{k}_{t-1}.
```

**(F6) 物质资本积累**（`needs_review`）：

```math
\bar{k}_t=(1-\iota_k)\bar{k}_{t-1}+\iota_k(\gamma^2\varphi_i\mu_t+i_t).
```

**(F7) 生产函数**（`needs_review`）：

```math
y_t=\Phi Z_t+\alpha\Phi k_t+(1-\alpha)\Phi L_t .
```

**(F8) 资本-劳动需求关系**（`needs_review`）：

```math
k_t=w_t-r^k_t+L_t .
```

**(F9) 实际边际成本**（`needs_review`）：

```math
mc_t=\alpha r^k_t+(1-\alpha)w_t-Z_t .
```

**(F10) Hybrid price Phillips curve**（`source_stated`，论文方程 (1)，符号已统一）：

```math
\pi_t=\pi_1\pi_{t-1}+\pi_2E_t\pi_{t+1}-\pi_3\mu^p_t+\epsilon^p_t .
```

其中 $`\mu^p_t`$ 是价格 markup，论文定义为劳动边际产出和实际工资之间的差。

**(F11) Wage Phillips curve**（`needs_review`）：

```math
w_t=
\frac{1}{1+\bar{\beta}\gamma}
\left[
w_{t-1}+\bar{\beta}\gamma E_tw_{t+1}
+\kappa_w
\left(
\frac{1}{1-h/\gamma}c_t-\frac{h/\gamma}{1-h/\gamma}c_{t-1}
+\nu_LL_t-w_t
\right)
-(1+\bar{\beta}\gamma\iota_w)\pi_t
+\iota_w\pi_{t-1}
+\bar{\beta}\gamma E_t\pi_{t+1}
\right]+\lambda^w_t .
```

**(F12) 货币政策规则**（规则形式为 `source_stated`；基准使用常数通胀目标）：

```math
R_t=\rho_RR_{t-1}+(1-\rho_R)\left(\psi_1\pi_t+\psi_2(y_t-y^{flex}_t)\right)
+\psi_3\left[(y_t-y_{t-1})-(y^{flex}_t-y^{flex}_{t-1})\right]+ms_t .
```

**(F13) 总资源约束**（`needs_review`）：

```math
y_t=c_yc_t+i_yi_t+g_t+r_k^\ast k_yu_t .
```

**(F14) Flexible-price 消费 Euler 方程**（`implementation_cross_check`, `needs_review`）：

```math
c^{flex}_t =
\frac{h/\gamma}{1+h/\gamma}c^{flex}_{t-1}
+\frac{1}{1+h/\gamma}E_t c^{flex}_{t+1}
+\frac{(\sigma_c-1)w_L^c}{\sigma_c(1+h/\gamma)}(L^{flex}_t-E_tL^{flex}_{t+1})
-\frac{1-h/\gamma}{\sigma_c(1+h/\gamma)}R^{flex}_t
+b^2_t .
```

**(F15) Flexible-price 投资方程**（`implementation_cross_check`, `needs_review`）：

```math
i^{flex}_t =
\frac{1}{1+\bar{\beta}\gamma}
\left(i^{flex}_{t-1}+\bar{\beta}\gamma E_ti^{flex}_{t+1}
+\frac{1}{\gamma^2\varphi_i}Q^{flex}_t\right)+\mu_t .
```

**(F16) Flexible-price Tobin's Q**（`implementation_cross_check`, `needs_review`）：

```math
Q^{flex}_t =
\frac{1}{\chi_c}b^2_t
-R^{flex}_t
+\frac{r_k^\ast}{r_k^\ast+1-\delta}E_tr^{k,flex}_{t+1}
+\frac{1-\delta}{r_k^\ast+1-\delta}E_tQ^{flex}_{t+1}.
```

**(F17) Flexible-price 资本利用率**（`implementation_cross_check`, `needs_review`）：

```math
u^{flex}_t=\frac{1-c_z}{c_z}r^{k,flex}_t .
```

**(F18) Flexible-price 有效资本**（`implementation_cross_check`, `needs_review`）：

```math
k^{flex}_t=u^{flex}_t+\bar{k}^{flex}_{t-1}.
```

**(F19) Flexible-price 资本积累**（`implementation_cross_check`, `needs_review`）：

```math
\bar{k}^{flex}_t=(1-\iota_k)\bar{k}^{flex}_{t-1}+\iota_k(\gamma^2\varphi_i\mu_t+i^{flex}_t).
```

**(F20) Flexible-price 生产函数**（`implementation_cross_check`, `needs_review`）：

```math
y^{flex}_t=\Phi Z_t+\alpha\Phi k^{flex}_t+(1-\alpha)\Phi L^{flex}_t .
```

**(F21) Flexible-price 资本-劳动需求关系**（`implementation_cross_check`, `needs_review`）：

```math
k^{flex}_t=w^{flex}_t-r^{k,flex}_t+L^{flex}_t .
```

**(F22) Flexible-price 边际成本归一化**（`implementation_cross_check`, `needs_review`）：

```math
0=\alpha r^{k,flex}_t+(1-\alpha)w^{flex}_t-Z_t .
```

**(F23) Flexible-price 工资/劳动条件**（`implementation_cross_check`, `needs_review`）：

```math
w^{flex}_t=\frac{1}{1-h/\gamma}c^{flex}_t-\frac{h/\gamma}{1-h/\gamma}c^{flex}_{t-1}+\nu_LL^{flex}_t .
```

**(F24) Flexible-price 资源约束**（`implementation_cross_check`, `needs_review`）：

```math
y^{flex}_t=c_yc^{flex}_t+i_yi^{flex}_t+g_t+r_k^\ast k_yu^{flex}_t .
```

## 4. Market Clearing & Identities

市场出清由总资源约束 (F13) 与 (F24)、要素需求关系 (F8) 与 (F21)，以及货币政策中使用的产出缺口定义 (F12) 编码。

论文会计分解使用七个观测变量：

**(F25) 观测方程**（`implementation_cross_check`, `needs_review`）：

```math
\Delta y^{obs}_t=y_t-y_{t-1},\quad
\Delta c^{obs}_t=c_t-c_{t-1},\quad
\Delta i^{obs}_t=i_t-i_{t-1},\quad
\Delta w^{obs}_t=w_t-w_{t-1}.
```

```math
\pi^{obs}_t=\pi_t,\quad R^{obs}_t=R_t,\quad L^{obs}_t=L_t .
```

论文报告的通胀和就业 shock decompositions 基于求解后的线性系统以及这些观测变量。

## 5. Exogenous Processes

**(F26) 技术冲击**（`needs_review`）：

```math
Z_t=\rho_ZZ_{t-1}+\epsilon^Z_t .
```

**(F27) 偏好/风险溢价冲击**（`needs_review`）：

```math
b^2_t=\rho_{b2}b^2_{t-1}+\epsilon^{b2}_t .
```

**(F28) 带技术创新联动的政府支出冲击**（`implementation_cross_check`, `needs_review`）：

```math
g_t=\rho_gg_{t-1}+\epsilon^g_t+\rho_{gZ}\epsilon^Z_t .
```

**(F29) 投资专用技术冲击**（`needs_review`）：

```math
\mu_t=\rho_\mu\mu_{t-1}+\epsilon^\mu_t .
```

**(F30) 价格 markup 冲击**（概念为 `source_stated`，确切过程为 `needs_review`）：

```math
\lambda^p_t=\rho_p\lambda^p_{t-1}+\epsilon^p_t-\theta_p\epsilon^p_{t-1}.
```

**(F31) 工资 markup 冲击**（概念为 `source_stated`，确切过程为 `needs_review`）：

```math
\lambda^w_t=\rho_w\lambda^w_{t-1}+\epsilon^w_t-\theta_w\epsilon^w_{t-1}.
```

**(F32) 货币政策冲击**（概念为 `source_stated`，确切过程为 `needs_review`）：

```math
ms_t=\rho_{ms}ms_{t-1}+\epsilon^{ms}_t .
```

对于 ZLB 会计分解，论文给出：

**(F33) ZLB 货币意外映射**（`source_stated`，论文方程 (7)）：

```math
\epsilon^m_t=\max\{-\tilde{i}_t,0\},
```

其中 $`\tilde{i}_t`$ 是线性 Taylor 规则隐含的利率。

对于可选的 time-varying inflation-target 扩展，论文给出：

**(F34) Time-varying inflation target extension**（`source_stated`，不是基准 MMB 实现的一部分）：

```math
i_t=\bar{i}+\rho_Ri_{t-1}+(1-\rho_R)\left[\psi_1(\pi_t-\pi_t^\ast)+\psi_2x_t\right]
+\psi_3(x_t-x_{t-1})+\epsilon^r_t,
```

```math
\hat{\pi}^\ast_t=\rho_{\pi^\ast}\hat{\pi}^\ast_{t-1}+\sigma_{\pi^\ast}\epsilon^{\pi^\ast}_t .
```

## 6. Steady-State Solution

由于 MMB 实现为 `model(linear)`，动态变量是相对于 balanced-growth steady state 的偏离，模型块围绕零求解：

```math
\bar{c}=\bar{i}=\bar{Q}=\bar{u}=\bar{k}=\bar{y}=\bar{\pi}=\bar{R}=\bar{L}=0 .
```

派生稳态比率和常数在评价线性模型前校准或计算：

```math
\beta=\frac{1}{1+\mathrm{constebeta}/100},
\qquad
\bar{\beta}=\beta\gamma^{-\sigma_c},
\qquad
r_k^\ast=\beta^{-1}\gamma^{\sigma_c}-(1-\delta).
```

```math
w^\ast=
\left[
\frac{\alpha^\alpha(1-\alpha)^{1-\alpha}}{\Phi(r_k^\ast)^\alpha}
\right]^{1/(1-\alpha)},
\qquad
\frac{K}{L}=\frac{\alpha}{1-\alpha}\frac{w^\ast}{r_k^\ast}.
```

```math
k_y=\Phi\left(\frac{K}{L}\right)^{1-\alpha},
\qquad
i_y=\left[1-\frac{1-\delta}{\gamma}\right]\gamma k_y,
\qquad
c_y=1-g^\ast-i_y .
```

`needs_review`：这些公式通过 `US_FU19_rep.mod` 交叉检查；US_FU19 论文正文没有印出完整稳态推导。

## 7. Timing & Form Conventions

- 形式约定：`model(linear)`；除非另有说明，(F1)-(F34) 中所有模型变量均为围绕 balanced-growth steady state 的 log deviations 或 linear deviations。
- 资本时序：生产使用有效资本服务 $`k_t=u_t+\bar{k}_{t-1}`$；物质资本 $`\bar{k}_t`$ 是期初预定、期末选择的存量。
- 期望：方程使用 $`E_t`$ 表示一期超前项；`.mod` 交叉检查使用 Dynare leads，例如 `(+1)`。
- 产出缺口：货币政策响应 $`y_t-y^{flex}_t`$ 及该缺口的变化。
- ZLB 处理：基准 retro analysis 不在基准线性模型中施加 occasionally binding constraint；它把负 Taylor-rule shadow rate 和零之间的差额视为一系列 surprise monetary shocks。
- 运行验证：未执行；没有运行 Dynare。

## 8. Variable & Parameter Reference Table

| 类别 | 符号 | 含义 | 方程覆盖 |
|---|---|---|---|
| 内生 | `c` | 消费 | (F1), (F13), (F25) |
| 内生 | `i` | 投资 | (F2), (F6), (F13), (F25) |
| 内生 | `Q` | Tobin's Q | (F3), (F6) |
| 内生 | `u` | 资本利用率 | (F4), (F5), (F13) |
| 内生 | `k` | 有效资本服务 | (F5), (F7), (F8) |
| 内生 | `k_bar` | 物质资本存量 | (F6) |
| 内生 | `y` | 产出 | (F7), (F12), (F13), (F25) |
| 内生 | `L` | 劳动/工时 | (F1), (F7), (F8), (F11), (F25) |
| 内生 | `w` | 实际工资 | (F8), (F9), (F11), (F25) |
| 内生 | `r_k` | 资本租金/回报 | (F3), (F4), (F8), (F9) |
| 内生 | `mc` | 实际边际成本 | (F9), (F10) |
| 内生 | `pi` | 通胀 | (F10), (F11), (F12), (F25) |
| 内生 | `R` | 名义政策利率 | (F1), (F12), (F25) |
| 内生 | `*_flex` | flexible-price 对应变量 | (F14)-(F24) |
| 内生 | `Z` | 技术状态 | (F7), (F20), (F26) |
| 内生 | `b2` | 偏好/风险溢价 wedge | (F1), (F3), (F14), (F16), (F27) |
| 内生 | `mu` | 投资专用技术 wedge | (F2), (F6), (F15), (F19), (F29) |
| 内生 | `g` | 政府支出 | (F13), (F24), (F28) |
| 内生 | `lambda_p` | 价格 markup shock 状态 | (F10), (F30) |
| 内生 | `lambda_w` | 工资 markup shock 状态 | (F11), (F31) |
| 内生 | `ms` | 货币政策 shock 状态 | (F12), (F32) |
| 内生 | `dy, dc, dinve, dw, pinfobs, robs, labobs` | 观测变量 | (F25) |
| 外生 | `eZ` | 技术创新 | (F26), (F28) |
| 外生 | `eb2` | 偏好/风险溢价创新 | (F27) |
| 外生 | `eg` | 政府支出创新 | (F28) |
| 外生 | `emu` | 投资专用创新 | (F29) |
| 外生 | `ep` | 价格 markup 创新 | (F10), (F30) |
| 外生 | `ew` | 工资 markup 创新 | (F11), (F31) |
| 外生 | `ems` | 货币政策创新 | (F32) |
| 参数 | `h` | 习惯持久性 | (F1), (F11), (F14), (F23) |
| 参数 | `gamma` | 趋势增长因子 | (F1)-(F3), (F6), (F14)-(F16), (F19) |
| 参数 | `sigma_c` | 消费曲率 | (F1), (F3), (F11), (F14), (F16), steady state |
| 参数 | `beta, beta_bar` | 贴现因子 | (F2), (F3), (F15), (F16), steady state |
| 参数 | `delta` | 折旧 | (F3), (F16), steady state |
| 参数 | `inv_adj_cost` | 投资调整成本 | (F2), (F6), (F15), (F19) |
| 参数 | `alpha, Phi` | 生产份额和固定成本/markup 项 | (F7), (F9), (F20), (F22), steady state |
| 参数 | `zeta_p, iota_p, lambda_pSS, curvp` | 价格黏性/指数化/曲率参数 | (F10) |
| 参数 | `zeta_w, iota_w, lambda_wSS, curvw, nu_L` | 工资黏性/指数化/劳动参数 | (F11), (F23) |
| 参数 | `rhoR, psi1, psi2, psi3` | 货币政策规则参数 | (F12), (F34) |
| 参数 | `rhoZ, rhob2, rhog, rhogZ, rhomu, rhop, rhow, rhoms, thetap, thetaw` | 冲击过程参数 | (F26)-(F32) |
| 参数 | `gSS, consumpt_ratioSS, invest_ratioSS, capital_ratioSS, r_kSS, wLc, czcap` | 稳态比率和利用率常数 | (F1)-(F25), steady state |
