# US_FRB03 - 推导（FRB-US 预测型政策规则档案条目）

> `US_FRB03` 的模型档案条目。状态：`needs_review`。未执行运行时验证；未运行 Dynare。

## 1. Model Overview

- **模型**：Levin, Wieland, and Williams (2003), "The Performance of Forecast-Based Monetary Policy Rules under Model Uncertainty."
- **模型 ID**：`US_FRB03`。
- **来源**：`raw/mmb_mineru/runs/nk_lww03_nk_lww03al_us_frb03__the_performance_of_forecast_based_monetary_policy_rules_under_model_unce__c97e3d2f/full.md`；DOI `10.1257/000282803322157016`。
- **用途**：在五个美国宏观模型中评估预测型货币政策规则，并在模型不确定性下识别稳健规则特征。
- **FRB-US 的角色**：四个估计型美国宏观计量模型之一。论文描述 FRB 模型的价格和支出具有高阶调整成本，并有较细的供给侧刻画。
- **主体/模块**：文章没有给出 FRB-US 的主体最优化问题。对 `US_FRB03` 而言，可用的论文侧结构包括预测型政策规则族、损失函数、确定性/表现限制，以及 FRB-US 宏观计量模型概述。`.mod` 交叉检查确认了一个大型线性化 FRB-US 实现，包含消费、投资、住房、劳动、价格、财政、金融、预期和政策模块。
- **形式**：线性理性预期宏观计量模型。MMB 实现是线性化 FRB-US 模型；本条目只把详细 `.mod` 方程作为 `implementation_cross_check`。

## 2. Optimization Problems

论文没有为 FRB-US 模型陈述家庭、企业、政府或金融中介的最优化问题。政策制定者的优化问题有明确陈述：

```math
\min_{\rho,\alpha,\beta,\theta,\kappa}\; \mathcal{L}
\quad\text{s.t.}\quad
\sigma_{\Delta i}\leq \bar{\sigma}_{\Delta i}
\quad\text{and the selected rule yields a unique stationary rational-expectations equilibrium.}
```

损失函数是不条件方差准则：

```math
\mathcal{L}=\operatorname{Var}(\pi)+\lambda\operatorname{Var}(y).
```

稳健规则练习还最小化五个模型的平均损失：

```math
\overline{\mathcal{L}}=\frac{1}{5}\left(\mathcal{L}_{OPT}+\mathcal{L}_{FM}+\mathcal{L}_{FRB}+\mathcal{L}_{MSR}+\mathcal{L}_{TMCM}\right).
```

完整 FRB-US 模型的私人部门 FOC 不能从论文侧 Markdown 中恢复。因此，下方编号方程是模型限制、恒等式和政策条件，而不是主体层面的一阶条件。

## 3. First-Order Conditions

- **(F1) 预测型政策规则族**：

```math
i_t=\rho i_{t-1}+(1-\rho)\left(r^{\ast}+E_t\tilde{\pi}_{t+\theta}\right)
+\alpha\left(E_t\tilde{\pi}_{t+\theta}-\pi^{\ast}\right)
+\beta E_t y_{t+\kappa}.
```

其中 $`i_t`$ 是短期名义利率，$`\tilde{\pi}_t`$ 是四季度平均通胀率，$`y_t`$ 是产出缺口，$`r^{\ast}`$ 是短期实际利率的无条件均值，$`\pi^{\ast}`$ 是通胀目标。

- **(F2) 估计的联邦基金利率基准规则**：

```math
i_t=-0.28+0.76 i_{t-1}+0.60\tilde{\pi}_t+0.21y_t+0.97\Delta y_t.
```

该规则使用 1980:1-1998:4 的美国季度数据估计，并用于生成政策优化中的利率波动约束。

- **(F3) 政策制定者损失函数**：

```math
\mathcal{L}=\operatorname{Var}(\pi)+\lambda\operatorname{Var}(y),\qquad \lambda\in\left\{0,\frac{1}{3},1,3\right\}.
```

- **(F4) 利率波动约束**：

```math
\sigma_{\Delta i}\leq \bar{\sigma}_{\Delta i}.
```

论文用估计基准规则诱导的波动率来设定 $`\bar{\sigma}_{\Delta i}`$。

- **(F5) 跨模型平均损失准则**：

```math
\overline{\mathcal{L}}=\frac{1}{5}\left(\mathcal{L}_{OPT}+\mathcal{L}_{FM}+\mathcal{L}_{FRB}+\mathcal{L}_{MSR}+\mathcal{L}_{TMCM}\right).
```

- **(F6) 稳健预测型基准规则**：

```math
i_t=1.0\,i_{t-1}+0.4\,E_t\left(\tilde{\pi}_{t+4}-\pi^{\ast}\right)+0.4\,y_t.
```

这是论文给出的简单稳健基准规则，其校准接近 $`\lambda=1/3`$ 时的平均损失最优值。

- **(F7) 论文报告的 FRB 最优规则行**：

```math
(\theta,\kappa,\rho,\alpha,\beta)=
\begin{cases}
(4,1,1.28,5.47,0.02), & \lambda=0,\\
(0,2,1.16,1.63,1.46), & \lambda=1/3,\\
(0,2,1.19,1.21,1.97), & \lambda=1,\\
(0,2,1.19,0.74,2.16), & \lambda=3.
\end{cases}
```

这些行概括了论文表 3 中 FRB-US 模型的最优预测期和系数。

## 4. Market Clearing & Identities

- **(F8) 四季度平均通胀恒等式**：

```math
\tilde{\pi}_t=\frac{1}{4}\left(\pi_t+\pi_{t-1}+\pi_{t-2}+\pi_{t-3}\right).
```

`.mod` 交叉检查把它实现为由季度 `picnia` 构造的 `inflation` modelbase 变量。

- **(F9) 产出缺口定义**：

```math
y_t=Y_t-Y_t^{pot}.
```

论文将 $`y_t`$ 定义为产出相对于潜在产出的偏离。`.mod` 交叉检查把 modelbase 产出缺口映射到 `xgap2`，即实际产出相对趋势/潜在产出的百分比偏离。

- **(F10) 产出缺口变化**：

```math
\Delta y_t=y_t-y_{t-1}.
```

该项进入估计基准规则 (F2)。

- **(F11) 模型一致预测**：

```math
E_t z_{t+h}=\mathbb{E}\left[z_{t+h}\mid\mathcal{I}_t,\mathcal{M}\right].
```

政策规则预测使用时间 $`t`$ 的信息集和相关模型生成，并区分模型一致和模型不一致的稳健性实验。

- **(F12) FRB-US 实现中的总产出核算**：

```math
xgdp_t=s_C\,C_t+s_H\,H_t+s_{E_d}E^d_t+s_{E_s}E^s_t+s_I I_t+s_X X_t+s_M M_t+s_{G_f}G^f_t+s_{G_s}G^s_t.
```

这个紧凑加总式仅为 `implementation_cross_check`。文章没有打印完整 FRB-US 核算模块；`.mod` 确认了 `xgdp` 的大型线性化支出加总方程。

## 5. Exogenous Processes

- **(F13) 实现中的政策规则创新**：

```math
i_t=\text{systematic policy rule}_t+\varepsilon^i_t.
```

`.mod` 交叉检查在档案化随机模拟设置中使用 `interest_` 作为活跃货币政策冲击。

- **(F14) 大多数冲击的序列相关结构**：

```math
\varepsilon^j_t \sim \text{i.i.d.},\qquad j\in\mathcal{J}.
```

论文说明四个宏观计量模型用于无条件矩计算的大多数冲击都是序列不相关的。

- **(F15) 期限溢价冲击例外**：

```math
s^b_t=\rho_b s^b_{t-1}+\varepsilon^b_t.
```

论文指出 FRB 和 TMCM 的某些金融变量中期限溢价冲击是例外。`.mod` 交叉检查含有债券/权益残差状态的 AR 系数，例如 `rg5es`、`rg10es`、`rcbes` 和 `lwpss`。

- **(F16) 实现中的趋势通胀和均衡实际利率持久性**：

```math
\pi^{\ast}_t=\rho_{\pi^{\ast}}\pi^{\ast}_{t-1}+(1-\rho_{\pi^{\ast}})\bar{\pi}^{\ast}_t,\qquad
r^{\ast}_t=\rho_{r^{\ast}}r^{\ast}_{t-1}+(1-\rho_{r^{\ast}})(i_t-\pi_t)+\text{optional gap term}.
```

该条件仅为 `implementation_cross_check`。论文侧基准规则使用常数 $`r^{\ast}`$ 和 $`\pi^{\ast}`$ 记号，而 `.mod` 包含持久的 `pitarg`、`ptr`、`rstar` 和 `rtr` 模块。

## 6. Steady-State Solution

由于 FRB-US 模型以线性化形式使用，推导层面的稳态表示为相对模型基线的偏离。

1. 将所有创新设为零：

```math
\varepsilon^i_t=0,\qquad \varepsilon^j_t=0\quad\forall j.
```

2. 将缺口变量设为基线值：

```math
y_t=\Delta y_t=0,\qquad \pi_t=\tilde{\pi}_t=\pi^{\ast},\qquad i_t=r^{\ast}+\pi^{\ast}.
```

3. 对基准规则 (F2)，截距和历史数据单位意味着数值稳态必须对照原 FRB-US 基线和论文年化利率约定检查：

```math
i=(1-0.76)^{-1}\left[-0.28+0.60\pi^{\ast}+0.21y+0.97\Delta y\right].
```

4. 对稳健基准规则 (F6)，若 $`y_t=0`$ 且 $`\tilde{\pi}_{t+4}=\pi^{\ast}`$，该规则保持继承的稳态名义利率：

```math
i_t=i_{t-1}=r^{\ast}+\pi^{\ast}.
```

5. 对 `.mod` 实现变量，应使用 Rep-MMB 校准和线性模型基线。所有 FRB-US 内部变量的精确稳态常数留待对 FRB-US 文档和实现文件进行源级审查；未运行 Dynare `steady` 检查。

## 7. Timing & Form Conventions

- **频率和单位**：季度数据；论文中的利率和通胀以年化百分点计量。
- **预期**：$`E_t`$ 表示基于时间 $`t`$ 可得信息的预测。
- **预测期**：$`\theta`$ 和 $`\kappa`$ 以季度计量。稳健基准使用 $`\theta=4`$ 和 $`\kappa=0`$。
- **模型形式**：线性理性预期宏观计量模型。MMB 实现是线性化 FRB-US 模型，并非该来源中的非线性最优化 DSGE 系统。
- **存量/时序约定**：论文侧 Markdown 没有打印完整 FRB-US 模型的存量时序。`.mod` 交叉检查包含许多滞后存量和前瞻预期项，但这些细节在对照 FRB-US 文档前仍为 `needs_review`。
- **来源边界**：`.agents/skills/dynare-copilot/references/examples/US_FRB03_rep.mod` 仅用于识别覆盖范围、命名、时序线索和实现约定。它不被视为论文侧数学来源。
- **运行时验证**：未执行。没有运行 Dynare、BK 检查、残差检查或 IRF 验证。

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII name | Meaning | Source role | Determined by |
|---|---|---|---|---|
| Endogenous policy variable | $`i_t`$ / `interest`, `rffe` | 短期名义利率 / 联邦基金利率 | Paper and implementation | (F1), (F2), (F6), (F13) |
| Endogenous macro variable | $`\pi_t`$ / `inflationq`, `picnia` | 一季度年化通胀 | Paper and implementation | (F3), (F8) |
| Endogenous macro variable | $`\tilde{\pi}_t`$ / `inflation` | 四季度平均通胀 | Paper and implementation | (F1), (F8) |
| Endogenous macro variable | $`y_t`$ / `outputgap`, `xgap2` | 产出缺口 | Paper and implementation | (F1), (F2), (F9), (F10) |
| Endogenous macro variable | $`\Delta y_t`$ | 产出缺口变化 | Paper | (F2), (F10) |
| Endogenous aggregate | $`Y_t`$ / `output`, `xgdp` | 产出 / 实际 GDP 加总 | Implementation cross-check | (F12) |
| Policy target | $`\pi^{\ast}`$ / `pitarg`, `ptr` | 通胀目标 / 趋势通胀 | Paper and implementation | (F1), (F6), (F16) |
| Policy baseline | $`r^{\ast}`$ / `rstar`, `rtr` | 短期实际利率无条件均值 | Paper and implementation | (F1), (F16) |
| Expectation object | $`E_t\tilde{\pi}_{t+\theta}`$ | 政策规则使用的通胀预测 | Paper | (F1), (F11) |
| Expectation object | $`E_t y_{t+\kappa}`$ | 政策规则使用的产出缺口预测 | Paper | (F1), (F11) |
| Exogenous shock | $`\varepsilon^i_t`$ / `interest_` | 货币政策创新 | Implementation cross-check | (F13) |
| Exogenous shocks | $`\varepsilon^j_t`$ | 其他模型创新 | Paper and implementation | (F14), (F15) |
| Parameter | $`\rho`$ / `tayr1` | 利率平滑 | Paper and implementation | (F1), (F7) |
| Parameter | $`\alpha`$ / `tayp*` | 通胀预测反应 | Paper and implementation | (F1), (F7) |
| Parameter | $`\beta`$ / `tayx*` | 产出缺口反应 | Paper and implementation | (F1), (F7) |
| Parameter | $`\theta`$ | 通胀预测期，单位为季度 | Paper | (F1), (F7) |
| Parameter | $`\kappa`$ | 产出缺口预测期，单位为季度 | Paper | (F1), (F7) |
| Parameter | $`\lambda`$ | 损失函数中的产出方差权重 | Paper | (F3), (F5) |
| Parameter | $`\bar{\sigma}_{\Delta i}`$ | 利率波动上界 | Paper | (F4) |
| Status marker | `needs_review` | 第一轮抽取；公式和来源覆盖尚未完全检查 | Archive | - |
