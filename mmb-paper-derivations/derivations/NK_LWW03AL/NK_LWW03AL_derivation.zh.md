# NK_LWW03AL - 推导（适应性学习优化 AD-AS 条目）

> `NK_LWW03AL` 的模型档案条目。状态：`needs_review`。本第一轮推导从 Levin, Wieland, and Williams (2003) 提取小型优化 AD-AS 模型，并记录适应性学习实现线索。未执行运行时验证；未运行 Dynare。

## 1. Model Overview

- **模型**：`NK_LWW03AL`，即 Levin, Wieland, and Williams (2003), "The performance of forecast-based monetary policy rules under model uncertainty" 中小型优化 AD-AS 模型的适应性学习版本。
- **论文**：Andrew Levin, Volker Wieland, and John C. Williams (2003), *American Economic Review* 93(3), 622-645, DOI `10.1257/000282803322157016`。
- **主来源**：`raw/mmb_mineru/runs/nk_lww03_nk_lww03al_us_frb03__the_performance_of_forecast_based_monetary_policy_rules_under_model_unce__c97e3d2f/full.md`；原始 PDF 记录在 `raw/mmb_papers/The Performance of Forecast-Based Monetary Policy Rules under Model Uncertainty.pdf`。
- **用途**：论文比较五个美国模型中的预测型货币政策规则。`NK_LWW03AL` 档案条目对应小型风格化优化 AD-AS 模型，MMB 元数据将该实现标记为适应性学习 (`AL`) 变体。
- **主体/模块**：论文侧模型是一个两方程理性预期 New Keynesian AD-AS 系统：前瞻 Phillips 曲线、预期 IS 曲线、自然实际利率过程、总供给扰动和利率规则。适应性学习细节没有在论文正文中推导；下文仅从 MMB 实现交叉检查文件记录。
- **形式**：线性化季度 New Keynesian 模型（MMB 实现中为 `model(linear)`）。变量是年率百分点偏离或缺口。`AL` 变体仍为 `needs_review`，因为论文侧 Markdown 陈述的是理性预期模型，而本地 MMB 文件识别了适应性学习设置。

## 2. Optimization Problems

论文说明两个私人部门结构方程来自优化主体行为，但没有列出家庭和企业问题。因此，忠于来源的档案条目以约化形式记录隐含优化模块：

- **代表性家庭 / 总需求模块**：跨期消费储蓄选择推出由产出缺口、实际政策利率和自然实际利率构成的预期 IS 曲线。
- **定价 / 总供给模块**：交错名义价格设定推出前瞻 Phillips 曲线，把当前通胀同未来预期通胀、产出缺口和供给扰动相连。
- **政策制定者**：选择政策规则预测期和系数，使通胀与产出缺口的无条件方差损失最小，并满足利率波动约束和确定性要求。

政策制定者问题为：

```math
\min_{\rho,\alpha,\beta,\theta,\kappa}\; \mathcal{L}
\quad\text{s.t.}\quad
\sigma_{\Delta i}\leq \bar{\sigma}_{\Delta i}
\quad\text{and a unique stationary rational-expectations equilibrium.}
```

损失函数为：

```math
\mathcal{L}=\operatorname{Var}(\pi)+\lambda\operatorname{Var}(y).
```

跨模型稳健规则练习使用：

```math
\overline{\mathcal{L}}=\frac{1}{5}\left(\mathcal{L}_{OPT}+\mathcal{L}_{FM}+\mathcal{L}_{FRB}+\mathcal{L}_{MSR}+\mathcal{L}_{TMCM}\right).
```

## 3. First-Order Conditions

- **(F1) 前瞻总供给 / New Keynesian Phillips 曲线**：

```math
\pi_t=\delta E_t\pi_{t+1}+\phi y_t+\varepsilon_t.
```

论文将该方程标为优化 AD-AS 模型中的总供给。 在本地实现中，`pdot` 是季度通胀，`pdotsh` 是加成/供给扰动。

- **(F2) 预期 IS 曲线 / 总需求**：

```math
y_t=E_t y_{t+1}-\sigma\left(i_t-E_t\pi_{t+1}-r_t^{\ast}\right).
```

政策利率、预期通胀和自然实际利率决定产出缺口。

- **(F3) 预测型政策规则族**：

```math
i_t=\rho i_{t-1}+(1-\rho)\left(r^{\ast}+E_t\tilde{\pi}_{t+\theta}\right)
+\alpha\left(E_t\tilde{\pi}_{t+\theta}-\pi^{\ast}\right)
+\beta E_t y_{t+\kappa}.
```

变量为年率百分点。$`\theta`$ 和 $`\kappa`$ 是以季度计的预测期。

- **(F4) 估计的基准联邦基金利率规则**：

```math
i_t=-0.28+0.76 i_{t-1}+0.60\tilde{\pi}_t+0.21y_t+0.97\Delta y_t.
```

MMB `NK_LWW03AL` 交叉检查将该规则映射到一般政策规则系数向量，其中包含利率平滑、四季度通胀平均和产出缺口变化项。

- **(F5) 政策制定者损失函数**：

```math
\mathcal{L}=\operatorname{Var}(\pi)+\lambda\operatorname{Var}(y),\qquad
\lambda\in\left\{0,\frac{1}{3},1,3\right\}.
```

- **(F6) 利率波动约束**：

```math
\sigma_{\Delta i}\leq \bar{\sigma}_{\Delta i}.
```

- **(F7) 跨模型平均损失准则**：

```math
\overline{\mathcal{L}}=\frac{1}{5}\left(\mathcal{L}_{OPT}+\mathcal{L}_{FM}+\mathcal{L}_{FRB}+\mathcal{L}_{MSR}+\mathcal{L}_{TMCM}\right).
```

- **(F8) 稳健基准预测型规则**：

```math
i_t=1.0\,i_{t-1}+0.4\,E_t\left(\tilde{\pi}_{t+4}-\pi^{\ast}\right)+0.4\,y_t.
```

- **(F9) 表 3 中优化 AD-AS 的优化规则行**：

```math
(\theta,\kappa,\rho,\alpha,\beta)=
\begin{cases}
(0,1,0.78,16.55,-0.64), & \lambda=0,\\
(0,0,1.57,7.27,6.12), & \lambda=1/3,\\
(0,0,1.55,3.04,6.23), & \lambda=1,\\
(0,0,1.55,1.49,6.26), & \lambda=3.
\end{cases}
```

这些行概括论文中优化 AD-AS 模型的最优预测期和系数。它们不是适应性学习运动定律。

## 4. Market Clearing & Identities

- **(F10) 四季度平均通胀恒等式**：

```math
\tilde{\pi}_t=\frac{1}{4}\left(\pi_t+\pi_{t-1}+\pi_{t-2}+\pi_{t-3}\right).
```

MMB `NK_LWW03AL` 实现引入 `pinf4`、`inflationql` 和 `inflationql2` 来支持该恒等式和适应性学习信息集。

- **(F11) 产出缺口变化**：

```math
\Delta y_t=y_t-y_{t-1}.
```

该项进入基准规则。

- **(F12) Modelbase 变量映射，implementation_cross_check**：

```math
\text{interest}_t=rff_t,\qquad
\text{inflationq}_t=pdot_t,\qquad
\text{outputgap}_t=ygap_t,\qquad
\text{output}_t=ygap_t.
```

最后一个等式是这个小型缺口模型的 MMB 接口约定，不是额外的论文侧资源约束。

## 5. Exogenous Processes

- **(F13) 自然实际利率过程**：

```math
r_t^{\ast}=\rho_{r^{\ast}}r_{t-1}^{\ast}+\eta_t^r,\qquad \rho_{r^{\ast}}=0.35.
```

论文说明自然实际利率创新的标准差为 3.72。

- **(F14) 总供给扰动**：

```math
\varepsilon_t=\rho_{\varepsilon}\varepsilon_{t-1}+\eta_t^{\pi}.
```

论文称总供给扰动是 i.i.d.，并校准为在估计基准规则下匹配通胀方差。MMB 实现设定 $`\rho_{\varepsilon}=0`$，并使用价格加成冲击 `pdotsh_`。

- **(F15) 政策规则创新，implementation_cross_check**：

```math
i_t=\text{systematic policy rule}_t+\eta_t^i.
```

MMB `NK_LWW03AL` 文件暴露 `interest_` 作为 modelbase 货币政策冲击，尽管被检查的随机设定在归档模型文件中把其方差设为零。

## 6. Steady-State Solution

由于模型是线性化形式，推导层面的稳态把所有缺口、偏离和创新设为零，但嵌入年率常数中的外生政策目标除外。

1. 将冲击设为零：

```math
\eta_t^r=0,\qquad \eta_t^{\pi}=0,\qquad \eta_t^i=0.
```

2. 将缺口变量和通胀偏离设在基线：

```math
y_t=0,\qquad \Delta y_t=0,\qquad \pi_t=\tilde{\pi}_t=\pi^{\ast}.
```

3. 自然实际利率过程推出：

```math
r_t^{\ast}=0
```

当它表示为相对无条件均值的偏离时。

4. 对稳健基准规则，如果 $`y_t=0`$ 且 $`\tilde{\pi}_{t+4}=\pi^{\ast}`$，该规则保持继承的名义利率基线：

```math
i_t=i_{t-1}.
```

5. 对估计的基准规则，常数项和年率单位需要来源层面的基线复核：

```math
i=(1-0.76)^{-1}\left[-0.28+0.60\pi^{\ast}+0.21y+0.97\Delta y\right].
```

精确的适应性学习稳态和初始信念约定暂缓处理，因为没有执行 Dynare 运行或 AL 模拟验证。

## 7. Timing & Form Conventions

- **频率和单位**：季度模型；论文中的利率和通胀为年率百分点。
- **预期**：$`E_t`$ 表示给定 $`t`$ 期信息的预测。在论文方程中这是理性预期；MMB `AL` 实现添加了适应性学习信息集。
- **预测期**：$`\theta`$ 和 $`\kappa`$ 以季度计。稳健基准使用 $`\theta=4`$ 和 $`\kappa=0`$。
- **模型形式**：线性化 New Keynesian AD-AS 模型（实现中为 `model(linear)`）。
- **存量变量**：论文侧小模型没有显式资本或其他物理存量积累。滞后利率、滞后通胀项和滞后产出缺口是政策规则和信息状态滞后，而不是生产中资本时序。
- **适应性学习约定，implementation_cross_check**：`raw/mmb/mmci-cli/models/NK_LWW03AL/NK_LWW03AL.json` 标记 `"al": true`；`.mod` 保存 `AL_Info`，其中前瞻变量为 `ygap`、`pdot` 和 `inflationq`，长状态为 `rstar`、`interest`、`inflationq`、`inflationql` 和 `inflationql2`，短状态为 `interest` 和 `outputgap`。
- **来源边界**：`raw/mmb/mmci-cli/models/NK_LWW03AL/NK_LWW03AL.mod` 和 `.json` 仅作为 `implementation_cross_check` 阅读。它们不被视为论文侧数学来源，且未运行 Dynare。
- **运行时验证**：未执行。没有执行残差、稳态、Blanchard-Kahn、适应性学习或 IRF 验证。

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII name | Meaning | Source role | Determined by |
|---|---|---|---|---|
| Endogenous gap | $`y_t`$ / `ygap`, `outputgap`, `output` | 产出缺口 | Paper and implementation | (F2), (F4), (F8), (F11), (F12) |
| Endogenous inflation | $`\pi_t`$ / `pdot`, `inflationq` | 季度年率通胀 | Paper and implementation | (F1), (F2), (F10), (F12), (F14) |
| Endogenous smoothed inflation | $`\tilde{\pi}_t`$ / `pinf4`, `inflation` | 四季度平均通胀 | Paper and implementation | (F3), (F4), (F8), (F10) |
| Endogenous policy rate | $`i_t`$ / `rff`, `interest` | 短期名义利率 | Paper and implementation | (F2), (F3), (F4), (F8), (F12), (F15) |
| Endogenous change | $`\Delta y_t`$ | 产出缺口变化 | Paper and implementation | (F4), (F11) |
| Endogenous change | $`\Delta i_t`$ / `drff` | 政策利率变化 | Implementation cross-check | (F6) |
| Exogenous state | $`r_t^{\ast}`$ / `rstar` | 自然实际利率 | Paper and implementation | (F2), (F13) |
| Exogenous shock | $`\eta_t^r`$ / `rstar_` | 自然利率创新 | Paper and implementation | (F13) |
| Exogenous shock | $`\eta_t^\pi`$ / `pdotsh_` | 总供给 / 加成创新 | Paper and implementation | (F1), (F14) |
| Exogenous shock | $`\eta_t^i`$ / `interest_` | 货币政策创新 | Implementation cross-check | (F15) |
| Parameter | $`\delta`$ / `discountt` | 通胀预期贴现系数 | Paper and implementation | (F1) |
| Parameter | $`\sigma`$ / `sigma` | IS 曲线实际利率敏感度 | Paper and implementation | (F2) |
| Parameter | $`\phi`$ / `phi` | Phillips 曲线中的产出缺口斜率 | Paper and implementation | (F1) |
| Parameter | $`\rho`$ | 政策规则中的利率平滑 | Paper and implementation | (F3), (F4), (F8), (F9) |
| Parameter | $`\alpha`$ | 政策规则中的通胀反应系数 | Paper and implementation | (F3), (F8), (F9) |
| Parameter | $`\beta`$ | 政策规则中的产出缺口反应系数 | Paper and implementation | (F3), (F8), (F9) |
| Parameter | $`\theta`$ | 通胀预测期 | Paper | (F3), (F9) |
| Parameter | $`\kappa`$ | 产出缺口预测期 | Paper | (F3), (F9) |
| Parameter | $`\lambda`$ | 损失函数中的产出方差权重 | Paper | (F5), (F7), (F9) |
| Parameter | $`\bar{\sigma}_{\Delta i}`$ | 利率波动上限 | Paper | (F6) |
| Status marker | `needs_review` | 第一轮来源和适应性学习变体复核尚未完成 | Archive | - |
