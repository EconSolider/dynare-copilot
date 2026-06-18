# EA_ALSV06 -- 推导（最优化问题 + 一阶条件）

> 私有模型档案的一遍草稿。状态：`needs_review`。未执行运行时验证。

来源：`EA_ALSV06` 基于 Javier Andres、J. David Lopez-Salido 和 Javier Valles 的 "Money in an estimated business cycle model of the euro area"，*The Economic Journal* 116，2006 年 4 月，第 457-477 页，DOI `10.1111/j.1468-0297.2006.01088.x`。本次提取使用 `raw/mmb_mineru/runs/ea_alsv06__money_in_an_estimated_business_cycle_model_of_the_euro_area__21baa95d/full.md`。原始 PDF 路径 `raw/mmb_papers/Money in an estimated business cycle model of the euro area.pdf` 存在，但未读取 PDF 正文。该模型没有附录规范化文件。MMB 复现文件 `.agents/skills/dynare-copilot/references/examples/EA_ALSV06_rep.mod` 仅作为实现交叉检查使用。

## 1. Model Overview

- **模型**：一个用于欧元区的小型估计型粘性价格 DSGE 模型，包含效用中的货币、习惯形成、混合通胀动态、货币需求和扩展 Taylor 规则。
- **MMB 变体**：`EA_ALSV06` 对应带可分 CRRA 偏好和习惯的工作论文/复现变体。实现交叉检查是一个含内生变量 `y, m, r, mu, pi, mc, a, e, z` 的 `model(linear)` 系统。
- **主体**：代表性家庭选择消费、劳动、货币和债券；垄断竞争企业生产差异化商品，并在 Calvo 型名义刚性下定价，同时可包含向后看的定价成分；货币当局根据产出、通胀和货币增长设定名义利率。
- **形式**：对数线性 `model(linear)`。带帽变量表示相对稳态或去趋势/对数线性变量的偏离。一遍状态为 `needs_review`，因为 Markdown OCR 存在人名重音和符号的小问题，且尚未用 PDF 做源级核对。

## 2. Optimization Problems

### 2.1 家庭

论文从包含实际货币余额和习惯的代表性家庭问题出发：

```math
\max_{\{C_t,N_t,M_t,B_t\}} E_0 \sum_{t=0}^{\infty}\beta^t a_t
\left[
\Psi\left(C_t^{\ast},\frac{M_t}{e_t P_t}\right)
- \frac{N_t^{1+\varphi}}{1+\varphi}
\right],
\qquad C_t^{\ast}=\frac{C_t}{C_{t-1}^{h}} .
```

期间预算约束为：

```math
\frac{M_{t-1}+B_{t-1}+W_tN_t+T_t+D_t}{P_t}
= C_t + \frac{B_t/r_t+M_t}{P_t}.
```

对于 MMB 的 `EA_ALSV06` 复现变体，采用论文中的可分 CRRA 偏好限制：

```math
U\left(C_t,\frac{M_t}{e_tP_t}\right)
= \frac{1}{1-\sigma}\left(\frac{C_t}{C_{t-1}^{h}}\right)^{1-\sigma}
+ \frac{1}{1-\delta}\left(\frac{M_t}{e_tP_t}\right)^{1-\delta}.
```

### 2.2 企业

最终需求是各品种的 CES 聚合。代表性差异化商品生产者的生产技术为：

```math
Y_t(j)=z_t N_t(j)^{1-\alpha}.
```

企业在 Calvo 刚性下设定名义价格。论文允许一部分重新定价者采用向后看的规则，因此均衡中产生混合 Phillips 曲线。

### 2.3 货币当局

政策规则闭合模型：

```math
\ln(r_t/r)=\rho_r\ln(r_{t-1}/r)
+(1-\rho_r)\rho_\pi\ln(\pi_t/\pi)
+(1-\rho_r)\rho_y\ln(Y_t/Y)
+(1-\rho_r)\rho_\mu\ln(\mu_t/\mu)
+\varepsilon_{r_t}.
```

## 3. First-Order Conditions

源论文将对称均衡报告为对数线性系统。MMB 变体采用可分 CRRA 特例，因此用方程 (15)-(17) 替代一般效用中货币模型中的对应方程，而政策规则、货币增长恒等式、Phillips 曲线和冲击过程沿用方程 (7)-(13)。

- **(F1) 跨期配置 / IS 关系**（`needs_review`：转写自论文方程 (15)，期望记号已规范化）：

```math
\widehat{y}_t
= \frac{\phi_1}{\phi_1+\phi_2}\widehat{y}_{t-1}
+ \frac{\beta\phi_1+\phi_2}{\phi_1+\phi_2}E_t\widehat{y}_{t+1}
- \frac{1}{\phi_1+\phi_2}\left(\widehat{r}_t-E_t\widehat{\pi}_{t+1}\right)
- \frac{\beta\phi_1}{\phi_1+\phi_2}E_t\widehat{y}_{t+2}
+ \frac{1-\beta h\rho_a}{1-\beta h}\frac{1-\rho_a}{\phi_1+\phi_2}\widehat{a}_t .
```

- **(F2) 货币需求**（`needs_review`：转写自论文方程 (16)；速度冲击项的符号在 OCR 论文文本和 `.mod` 约定之间存在差异，因此这里遵循论文文本并标记）：

```math
\widehat{m}_t
= -\frac{\phi_1}{\delta}\widehat{y}_{t-1}
+ \frac{\phi_2}{\delta}\widehat{y}_t
- \frac{\beta\phi_1}{\delta}E_t\widehat{y}_{t+1}
- \frac{1}{\delta(r-1)}\widehat{r}_t
+ \frac{\beta h(1-\rho_a)}{(1-\beta h)\delta}\widehat{a}_t
+ \frac{\delta-1}{\delta}\widehat{e}_t .
```

- **(F3) 货币政策规则**：

```math
\widehat{r}_t
= \rho_r\widehat{r}_{t-1}
+(1-\rho_r)\rho_y\widehat{y}_t
+(1-\rho_r)\rho_\pi\widehat{\pi}_t
+(1-\rho_r)\rho_\mu\widehat{\mu}_t
+\varepsilon_{r_t}.
```

- **(F4) 货币增长恒等式**：

```math
\widehat{\mu}_t=\widehat{m}_t-\widehat{m}_{t-1}+\widehat{\pi}_t .
```

- **(F5) 混合新 Keynesian Phillips 曲线**：

```math
\widehat{\pi}_t
= \gamma_f E_t\widehat{\pi}_{t+1}
+\gamma_b\widehat{\pi}_{t-1}
+\lambda\widehat{mc}_t .
```

- **(F6) 实际边际成本关系**（`needs_review`：转写自论文方程 (17)，使用可分 CRRA 限制）：

```math
\widehat{mc}_t
= -\phi_1\widehat{y}_{t-1}
+(\chi+\phi_2)\widehat{y}_t
-\beta\phi_1E_t\widehat{y}_{t+1}
-(1+\chi)\widehat{z}_t
-\frac{\beta h(1-\rho_a)}{1-\beta h}\widehat{a}_t .
```

该变体使用的 CRRA 系数定义为：

```math
\phi_1=\frac{(\sigma-1)h}{1-\beta h},
\qquad
\phi_2=\frac{\sigma+(\sigma-1)\beta h^2-\beta h}{1-\beta h}.
```

## 4. Market Clearing & Identities

- **(F7) 对称均衡中的商品市场出清**：

```math
Y_t=C_t .
```

该条件在对数线性均衡系统之前的企业行为部分给出。在简化的 `model(linear)` 实现中，`y` 是产出/消费配置变量，而不是单独的消费变量。

- **(F8) 水平形式的货币增长定义**：

```math
\mu_t=\frac{M_t}{M_{t-1}},
\qquad
\widehat{\mu}_t=\widehat{m}_t-\widehat{m}_{t-1}+\widehat{\pi}_t .
```

方程 (F8) 记录了 (F4) 对数线性恒等式的市场出清/恒等式来源；在实现方程计数中应使用 (F4)，不要同时使用 (F4) 和 (F8)。

## 5. Exogenous Processes

- **(F9) 偏好/需求冲击**：

```math
\widehat{a}_t=\rho_a\widehat{a}_{t-1}+\varepsilon_{a_t}.
```

- **(F10) 速度或货币需求冲击**：

```math
\widehat{e}_t=\rho_e\widehat{e}_{t-1}+\varepsilon_{e_t}.
```

- **(F11) 技术/供给冲击**：

```math
\widehat{z}_t=\rho_z\widehat{z}_{t-1}+\varepsilon_{z_t}.
```

- **(F12) 货币政策冲击**：

```math
\varepsilon_{r_t}\ \text{enters the interest-rate rule (F3) directly.}
```

## 6. Steady-State Solution

因为 `EA_ALSV06` 是对数线性 `model(linear)` 条目，模型变量表示相对稳态的偏离：

```math
\widehat{y}=\widehat{m}=\widehat{r}=\widehat{\mu}=\widehat{\pi}
=\widehat{mc}=\widehat{a}=\widehat{e}=\widehat{z}=0.
```

稳态总名义利率水平在货币需求系数中以 `rss` 出现：

```math
r_{ss}=\exp(0.0224)
```

在实现交叉检查中，论文的 CRRA/可分估计大致对应 $`\beta=0.9876`$、$`\sigma\approx1.0573`$、$`h\approx0.9025`$、$`\delta=108.76`$、$`\gamma_f\approx0.9876`$、$`\gamma_b\approx0`$、$`\lambda\approx1.1939`$，以及接近表 2 的持久性参数。这些数值作为实现交叉检查记录，并非通过读取 PDF 正文重新验证的校准。

## 7. Timing & Form Conventions

- **形式**：`model(linear)` 对数线性系统。带帽变量表示相对稳态或去趋势/对数线性观测变量的偏离。
- **期望**：$`E_t\widehat{y}_{t+1}`$、$`E_t\widehat{y}_{t+2}`$ 和 $`E_t\widehat{\pi}_{t+1}`$ 等前瞻项均以 $`t`$ 期信息为条件。
- **预定/滞后变量**：IS 关系使用 $`\widehat{y}_{t-1}`$；政策规则使用 $`\widehat{r}_{t-1}`$；货币增长恒等式使用 $`\widehat{m}_{t-1}`$；当 $`\gamma_b\ne0`$ 时 Phillips 曲线包含 $`\widehat{\pi}_{t-1}`$。
- **存量和资本**：这个小型模型没有物质资本存量；生产只使用劳动和技术冲击。
- **货币约定**：`m` 是实际货币余额，`mu` 是货币增长，`e` 是速度/货币需求冲击。论文在一般非可分模型中强调实际货币余额缺口 $`\widehat{m}_t-\widehat{e}_t`$，而 MMB 变体施加可分 CRRA 偏好。
- **运行时验证**：未执行。

## 8. Variable & Parameter Reference Table

### 内生变量

| 符号 | 含义 | 主要方程 |
|---|---|---|
| `y`, $`\widehat{y}_t`$ | 去趋势/对数线性产出；在对称均衡中等于消费 | (F1), (F7) |
| `m`, $`\widehat{m}_t`$ | 实际货币余额 | (F2), (F4) |
| `r`, $`\widehat{r}_t`$ | 实现约定中的名义利率偏离 | (F3) |
| `mu`, $`\widehat{\mu}_t`$ | 货币增长 | (F4), (F8) |
| `pi`, $`\widehat{\pi}_t`$ | 通胀 | (F5) |
| `mc`, $`\widehat{mc}_t`$ | 实际边际成本 | (F6) |
| `a`, $`\widehat{a}_t`$ | 偏好/需求冲击状态 | (F9) |
| `e`, $`\widehat{e}_t`$ | 速度/货币需求冲击状态 | (F10) |
| `z`, $`\widehat{z}_t`$ | 技术/供给冲击状态 | (F11) |

### 外生冲击

| 符号 | 含义 |
|---|---|
| `epsa`, $`\varepsilon_{a_t}`$ | 偏好/需求冲击创新 |
| `epse`, $`\varepsilon_{e_t}`$ | 速度/货币需求冲击创新 |
| `epsz`, $`\varepsilon_{z_t}`$ | 技术/供给冲击创新 |
| `epsr`, $`\varepsilon_{r_t}`$ | 货币政策冲击 |

### 参数

| 符号 | 含义 |
|---|---|
| $`\beta`$ / `beta` | 贴现因子 |
| $`\sigma`$ / `sigma` | CRRA 曲率、跨期替代弹性倒数 |
| $`h`$ / `h` | 习惯参数 |
| $`\delta`$ / `delta` | CRRA/可分限制下支配货币需求的曲率 |
| $`\phi_1,\phi_2`$ / `phi1`, `phi2` | 习惯/偏好的复合系数 |
| $`\gamma_f,\gamma_b`$ / `gammaf`, `gammab` | Phillips 曲线的前瞻和后顾权重 |
| $`\lambda`$ / `lambda` | Phillips 曲线中实际边际成本的斜率 |
| $`\chi`$ / `chi` | 劳动供给/收益递减的复合参数 |
| $`\rho_r,\rho_y,\rho_\pi,\rho_\mu`$ | 利率平滑和政策反应参数 |
| $`\rho_a,\rho_e,\rho_z`$ | 冲击持久性参数 |
| $`\sigma_a,\sigma_e,\sigma_z,\sigma_r`$ | 冲击标准差 |
| $`r_{ss}`$ / `rss` | 稳态总名义利率水平 |
