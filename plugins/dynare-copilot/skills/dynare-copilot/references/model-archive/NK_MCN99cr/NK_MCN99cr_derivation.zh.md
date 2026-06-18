# NK_MCN99cr - 推导

> MMB 模型档案的有来源草稿。未执行运行时验证。公式状态：`needs_review`，原因是尚未做 PDF 级公式核对，也尚未完全核准论文仿真变体与 Rep-MMB Calvo-Rotemberg 实现之间的精确映射。

## 1. Model Overview

- **模型 ID**：`NK_MCN99cr`。
- **论文**：Bennett T. McCallum and Edward Nelson, "Performance of Operational Policy Rules in an Estimated Semiclassical Structural Model," NBER Working Paper 6599 / *Monetary Policy Rules*, 1999。
- **DOI**：`10.3386/w6599`。
- **来源 Markdown**：`raw/mmb_mineru/runs/nk_mcn99cr__performance_of_operational_policy_rules_in_an_estimated_semiclassical_st__b43633f6/full.md`。
- **原始 PDF**：`raw/mmb_papers/Performance of Operational Policy Rules in an Estimated Semiclassical Structural Model.pdf`。
- **MinerU run id**：`b43633f6-1141-457a-af12-8edc3db54f79`。
- **模型形式**：Rep-MMB 实现为 log-linear `model(linear)`。小写变量是对数或对数偏离；名义利率使用季度小数单位。实现中的变体是 Calvo-Rotemberg 总供给版本，不是论文中的 P-bar 变体。
- **主体与模块**：无限期家庭消费、持有实际货币余额、债券和资本，并生产差异化产品；需求加总；外生投资和产能产出过程；Calvo-Rotemberg 价格调整；货币政策规则。
- **实现交叉检查**：`.agents/skills/dynare-copilot/references/examples/NK_MCN99cr_rep.mod` 仅用于识别 Rep-MMB 变量集合和所选政策规则变体。它不作为论文侧数学来源。

## 2. Optimization Problems

### 家庭的消费、货币、资本和债券选择

家庭最大化消费和实际货币余额带来的预期贴现效用：

```math
E_t \sum_{j=0}^{\infty} \beta^j U\!\left(C_{t+j}, \frac{M_{t+j}}{P^A_{t+j}}\right)
```

其中单期效用可分：

```math
U\!\left(C_t,\frac{M_t}{P^A_t}\right)
= \frac{\sigma}{\sigma-1} C_t^{(\sigma-1)/\sigma} e^{\omega_t}
+ \frac{1}{1-\gamma}\left(\frac{M_t}{P^A_t}\right)^{1-\gamma} e^{\chi_t}.
```

家庭同时拥有一个生产差异化产品的单位。给定其产品需求，家庭雇佣劳动并使用资本：

```math
A_t K_t^{\alpha}(N^d_t)^{1-\alpha}
= \left(\frac{P_t}{P^A_t}\right)^{-\theta} Y^A_t.
```

期预算约束为：

```math
\begin{aligned}
0={}&
\left(\frac{P_t}{P^A_t}\right)^{1-\theta}Y^A_t
- C_t - K_{t+1} + (1-\delta)K_t
+ \frac{W_t}{P^A_t}N^S_t
- \frac{W_t}{P^A_t}N^d_t \\
&+ TR_t
- \frac{M_t}{P^A_t} + \frac{M_{t-1}}{P^A_t}
- \frac{B_{t+1}}{1+r_t} + B_t .
\end{aligned}
```

闲暇不进入效用，因此期望劳动供给为无弹性，$`N^S_t=1`$。价格黏性下的实际劳动投入由需求决定。

### 生产者定价

在 Calvo-Rotemberg 变体中，生产者选择价格路径，以最小化价格偏离无摩擦期望价格和二次价格调整成本的预期贴现和：

```math
E_t \sum_{j=0}^{\infty}\beta^j
\left[
(p_{t+j}-\bar p_{t+j})^2
+ c_1(p_{t+j}-p_{t+j-1})^2
\right].
```

论文还发展了一个 P-bar 替代设定，其中产出缺口变动进入调整成本项。该变体不是 `NK_MCN99cr` 的 Rep-MMB 交叉检查模型，因此不作为这里的有效实现。

## 3. First-Order Conditions

- **(F1) 消费边际效用**：

```math
C_t^{-1/\sigma} e^{\omega_t} = \lambda_t .
```

- **(F2) 实际货币边际条件**：

```math
\left(\frac{M_t}{P^A_t}\right)^{-\gamma} e^{\chi_t}
= \lambda_t
- \beta E_t\!\left[
\lambda_{t+1}\frac{P^A_t}{P^A_{t+1}}
\right].
```

- **(F3) 资本 Euler 条件**：

```math
\lambda_t
= \beta(1-\delta)E_t\lambda_{t+1}
+ \alpha\beta E_t\!\left[
\xi_{t+1}A_{t+1}K_{t+1}^{\alpha-1}(N^d_{t+1})^{1-\alpha}
\right].
```

- **(F4) 债券 Euler 条件**：

```math
\lambda_t = \beta E_t\!\left[\lambda_{t+1}(1+r_t)\right].
```

- **(F5) 劳动需求条件**：

```math
\lambda_t\frac{W_t}{P^A_t}
= (1-\alpha)\xi_t A_tK_t^{\alpha}(N^d_t)^{-\alpha}.
```

- **(F6) 对数线性化的优化 IS 关系**：

```math
y_t
= E_t y_{t+1}
- \sigma\frac{C^{ss}}{Y^{ss}}
\left(R_t-E_t\Delta p_{t+1}-\bar r\right)
+ \frac{C^{ss}}{Y^{ss}} v_t .
```

论文随后在仿真中将 $`E_t y_{t+1}`$ 替换为 $`E_{t-1}y_{t+1}`$，以改善通胀波动表现。Rep-MMB 实现使用如下前瞻形式：

```math
y_t
= y_{t+1}
- \sigma\frac{C^{ss}}{Y^{ss}}\left(R_t-\pi_{t+1}\right)
+ \frac{C^{ss}}{Y^{ss}} v_t .
```

- **(F7) 对数线性化的货币需求关系**：

```math
m_t-p_t
= (\sigma\gamma)^{-1}\frac{Y^{ss}}{C^{ss}}y_t
- (\sigma\gamma)^{-1}\frac{I^{ss}}{C^{ss}}i_t
- (\gamma R^{ss})^{-1}(R_t-R^{ss})
+ \eta_t .
```

实现中的线性模型省略常数项，写作：

```math
m_t-p_t
= \frac{1}{\sigma\gamma}\frac{Y^{ss}}{C^{ss}}
\left(y_t-\frac{I^{ss}}{Y^{ss}}i_t\right)
- \frac{1}{\gamma R^{ss}}R_t + \eta_t .
```

- **(F8) Calvo-Rotemberg 定价条件**：

```math
\Delta p_t
= \beta E_t\Delta p_{t+1}
+ \frac{\theta}{c_1}(y_t-\bar y_t).
```

Rep-MMB 实现将其映射为：

```math
\pi_t = \beta \pi_{t+1} + \theta_{c1}\tilde y_t .
```

## 4. Market Clearing & Identities

- **(F9) 通胀定义**：

```math
\pi_t = p_t-p_{t-1}.
```

- **(F10) 产出缺口定义**：

```math
\tilde y_t = y_t-\bar y_t.
```

- **(F11) 嵌入总需求的对数线性资源恒等式**：

```math
y_t \approx \frac{C^{ss}}{Y^{ss}}c_t+\frac{I^{ss}}{Y^{ss}}i_t .
```

Rep-MMB 实现中消去了显式消费变量。来源论文在估计和仿真中固定 $`C^{ss}/Y^{ss}=0.81`$ 和 $`I^{ss}/Y^{ss}=0.19`$。

- **(F12) 产能产出测度关系**：

```math
\tilde y_t = y_t-\bar y_t = (1-\alpha)(n_t-\bar n_t).
```

在无弹性灵活价格劳动假设下，$`\bar n_t`$ 被视为常数。

- **(F13) Rep-MMB 交叉检查中使用的 Taylor 型政策规则**：

```math
R_t = \mu_1\pi_t+\mu_2\tilde y_t+\mu_3 R_{t-1}.
```

`.mod` 文件的有效校准设定为 $`\mu_1=1.5`$、$`\mu_2=0`$、$`\mu_3=0`$；其他规则行是注释，不作为有效方程。

## 5. Exogenous Processes

- **(F14) 投资过程**：

```math
i_t = g_k+i_{t-1}+e_{it}.
```

实现交叉检查设置 `gk = 0` 并包含创新 `e_`；论文对一般模型估计得到 $`g_k=0.0073`$。

- **(F15) 产能产出过程**：

```math
\bar y_t = \varsigma+\rho_{\bar y}\bar y_{t-1}+e_{yt}.
```

实现交叉检查设置 `stigma = 0`、`rhoybar = 1`，并包含创新 `ey_`；论文估计得到带漂移 $`0.0073`$ 的随机游走产能过程。

- **(F16) 偏好需求冲击过程**：

```math
v_t = \rho_v v_{t-1}+e_{vt}.
```

- **(F17) 货币需求扰动过程**：

```math
\eta_t = \rho_{\eta}\eta_{t-1}+u_t .
```

- **(F18) 相关需求冲击分解**：

```math
e_{vt}=\psi_u u_t+\varepsilon_{vt}.
```

论文报告残差相关性接近零，并在仿真中设置 $`\psi_u=0`$。Rep-MMB `.mod` 实现了独立创新 `ev_` 和 `u_`。

## 6. Steady-State Solution

有效档案对象是线性化模型，因此 Dynare 中声明变量的稳态为零，除非变量代表水平比率或固定参数。来源论文在对数线性化前固定或推出以下水平/比率：

1. 设置 $`C^{ss}/Y^{ss}=0.81`$，因此 $`Y^{ss}/C^{ss}=1/0.81`$。
2. 设置 $`I^{ss}/Y^{ss}=0.19`$。
3. 设置 $`R^{ss}=0.014`$，季度小数单位。
4. 在 Rep-MMB 实现中使用估计值 $`\sigma=0.203`$。
5. 使用货币需求估计 $`(\sigma\gamma)^{-1}=0.753`$，这意味着 $`\gamma \approx 1/(\sigma\cdot0.753)`$。Rep-MMB 文件将其存为 `gam = 6.579`。
6. 对 Calvo-Rotemberg 斜率，实现在 $`\beta=0.99`$ 下使用 $`\theta_{c1}=0.30`$。论文为 Calvo-Rotemberg 仿真变体说明了 $`\theta/c_1=0.30`$ 的取值动机。
7. 稳态中外生创新为零：$`e_{it}=e_{yt}=e_{vt}=u_t=\varepsilon_{vt}=0`$。
8. 对有效 `.mod` 中的线性状态变量，使用：

```math
\pi=p=y=R=v=m=i=\eta=\tilde y=\bar y=0 .
```

运行时验证状态：`not_performed`。未运行 `resid`、`steady`、`check` 或随机模拟。

## 7. Timing & Form Conventions

- **形式**：log-linear `model(linear)`。小写变量是对数水平或对数偏离；实现的线性模型中 `R` 是季度小数名义利率偏离。
- **预期**：论文结构性 IS 和 LM 方程包含 $`E_t y_{t+1}`$ 和 $`E_t\Delta p_{t+1}`$；仿真讨论说明了使用 $`E_{t-1}y_{t+1}`$ 的修改时序。Rep-MMB 实现使用 `y(+1)` 和 `pi(+1)`。
- **通胀**：`pi` 定义为价格水平差分，$`\pi_t=p_t-p_{t-1}`$。
- **存量**：家庭问题中的货币余额是期末存量。资本出现在来源家庭问题中，但季度资本动态未进入实现的总需求系统；投资服从外生随机游走。
- **产出缺口**：$`\tilde y_t=y_t-\bar y_t`$；来源测度将其连接到相对于常数灵活价格劳动的工时。
- **政策规则**：有效 Rep-MMB 规则对当期通胀和产出缺口反应，可选滞后利率平滑。有效校准没有产出缺口反应，也没有平滑。
- **变体**：来源中的 P-bar 方程作为论文侧替代变体记录，但排除在本实现特定推导之外。

## 8. Variable & Parameter Reference Table

| 类别 | 符号 / ASCII | 含义 | 由哪条方程决定 |
|---|---|---|---|
| 内生 | `pi`, $`\pi_t`$ | 通胀，价格水平差分 | (F8), (F9) |
| 内生 | `p`, $`p_t`$ | 对数总价格水平 | (F9) |
| 内生 | `y`, $`y_t`$ | 对数产出 | (F6), (F7) |
| 内生 | `R`, $`R_t`$ | 名义利率 | (F13) |
| 内生 | `v`, $`v_t`$ | IS/偏好扰动 | (F16) |
| 内生 | `m`, $`m_t`$ | 对数名义货币存量 | (F7) |
| 内生 | `i`, $`i_t`$ | 对数投资 | (F14) |
| 内生 | `eta`, $`\eta_t`$ | 货币需求扰动 | (F17) |
| 内生 | `ytilde`, $`\tilde y_t`$ | 产出缺口 | (F10) |
| 内生 | `ybar`, $`\bar y_t`$ | 产能产出 | (F15) |
| 外生 | `u_`, $`u_t`$ | 货币需求创新 | (F17) |
| 外生 | `e_`, $`e_{it}`$ | 投资创新 | (F14) |
| 外生 | `ey_`, $`e_{yt}`$ | 产能产出创新 | (F15) |
| 外生 | `ev_`, $`e_{vt}`$ | IS/偏好创新 | (F16), (F18) |
| 参数 | `sigm`, $`\sigma`$ | IS 中的跨期替代参数和效用曲率记号 | (F1), (F6), (F7) |
| 参数 | `CssYss` | $`C^{ss}/Y^{ss}`$ | (F6), (F11) |
| 参数 | `YssCss` | $`Y^{ss}/C^{ss}`$ | (F7) |
| 参数 | `gam`, $`\gamma`$ | 货币需求曲率 / 逆利率弹性组成部分 | (F2), (F7) |
| 参数 | `IssYss` | $`I^{ss}/Y^{ss}`$ | (F7), (F11) |
| 参数 | `Rss` | 稳态季度名义利率 | (F7) |
| 参数 | `rhov` | $`v_t`$ 持续性 | (F16) |
| 参数 | `rhoeta` | $`\eta_t`$ 持续性 | (F17) |
| 参数 | `gk` | 投资过程漂移 | (F14) |
| 参数 | `stigma` | 产能产出过程漂移 | (F15) |
| 参数 | `rhoybar` | 产能产出持续性 | (F15) |
| 参数 | `bet` | 贴现因子 $`\beta`$ | (F3), (F4), (F8) |
| 参数 | `thetac1` | Calvo-Rotemberg 斜率 $`\theta/c_1`$ | (F8) |
| 参数 | `mu1` | 政策规则中的通胀反应 | (F13) |
| 参数 | `mu2` | 政策规则中的产出缺口反应 | (F13) |
| 参数 | `mu3` | 政策规则中的利率平滑 | (F13) |

第一遍状态：`needs_review`。上述方程提取了论文结构关系和有效 Rep-MMB 线性实现，但尚未打开来源 PDF 做针对性公式校对，P-bar 替代变体也仅作为排除变体记录。
