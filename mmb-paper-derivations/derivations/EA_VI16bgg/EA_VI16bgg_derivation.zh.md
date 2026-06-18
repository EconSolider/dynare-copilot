# EA_VI16bgg - 推导（最优化问题 + 一阶条件）

> 状态：needs_review。本第一轮档案条目以 Villa (2016) 的 MinerU Markdown 抽取文本和表 1 为论文侧来源，并仅用 Rep-MMB 实现交叉检查变量覆盖和时序约定。未执行运行时验证。

## 1. Model Overview

- **模型 ID**：`EA_VI16bgg`。
- **论文**：Stefania Villa (2016), "Financial frictions in the Euro Area and the United States: a Bayesian assessment", *Macroeconomic Dynamics*, 20(05), 1313-1340. DOI: `10.1017/s1365100514000881`。
- **经济体和变体**：欧元区估计版 Smets-Wouters 模型，加入 Bernanke-Gertler-Gilchrist (BGG) 金融摩擦；摩擦来自非金融企业。
- **主体和部门**：家庭、工会、劳动打包部门、零售商、最终品厂商、中间品厂商、资本品生产者和政策制定者。在 SWBGG 变体中，中间品厂商用净值和外部借款购买资本，并面对 costly-state-verification 金融合约。
- **形式**：`model(linear)`。带帽变量为相对稳态的百分比或对数偏离；没有时间下标的变量为稳态常数。
- **主要来源**：`raw/mmb_mineru/runs/ea_vi16bgg_ea_vi16gk_us_vi16bgg_us_vi16gk__financial_frictions_in_the_euro_area_and_the_united_states_a_bayesian_as__ed2f2b1d/full.md`。
- **公式质量**：Markdown 中包含表 1，并且与实现中的模型块高度一致。论文列出 employment Phillips curve，但 Rep-MMB 实现因为 EA/US 可观测变量差异而省略该方程；本草稿跟随 `EA_VI16bgg` 实现覆盖，并将该省略标为 `needs_review`。

## 2. Optimization Problems

### 家庭

家庭消费、储蓄并供给劳动。论文给出线性化 Euler 方程和工资 Phillips 曲线，而不是完整的非线性家庭问题。与 SW 习惯形成模块一致的紧凑表示为：

\[
\max_{\{C_t,L_t,B_t\}} E_0 \sum_{t=0}^{\infty}\beta^t
U(C_t-h C_{t-1},L_t)
\]

约束为家庭预算约束和工会工资设定环境。模型中使用的线性化条件为 (F1) 和 (F2)。

### 工会、劳动打包部门、零售商和产品生产部门

工会和零售商在 Calvo 摩擦和部分指数化下设定差异化工资和价格。竞争性打包部门聚合差异化劳动，最终品厂商聚合中间品，中间品厂商选择劳动、安装资本和利用率。论文表 1 直接报告了工资 Phillips 曲线、价格 Phillips 曲线、生产函数和要素条件。

### 资本品生产者

资本品生产者把投资和折旧资本转化为新资本。投资调整成本给出投资 Euler 方程 (F5)。安装资本利用率的选择使利用率和资本边际产出满足 (F4)。

### 带外部融资的 SWBGG 中间品厂商

在 \(t\) 期末，企业以价格 \(Q_t\) 购买 \(K_{t+1}\)。购买成本 \(Q_tK_{t+1}\) 由净值 \(N_{t+1}\) 和借款融资。企业以概率 \(\theta\) 存活，有限预期寿命防止完全自我融资。costly-state-verification 合约意味着外部融资溢价随杠杆上升。论文的线性化 BGG 模块为 (F12)-(F15)。

## 3. First-Order Conditions

- **(F1) 带习惯形成的消费 Euler 方程**

\[
\frac{1+h}{1-h}\hat{C}_t =
\frac{1}{1-h}E_t\hat{C}_{t+1}
+ \frac{h}{1-h}\hat{C}_{t-1}
- \hat{R}_t .
\]

- **(F2) 工资 Phillips 曲线**

\[
\hat{W}_t =
\frac{\beta}{1+\beta}E_t\hat{W}_{t+1}
+\frac{1}{1+\beta}\hat{W}_{t-1}
+\frac{\beta}{1+\beta}E_t\hat{\Pi}_{t+1}
-\frac{1+\beta\sigma_{wi}}{1+\beta}\hat{\Pi}_t
+\frac{\sigma_{wi}}{1+\beta}\hat{\Pi}_{t-1}
+\frac{1}{1+\beta}
\frac{(1-\beta\sigma_w)(1-\sigma_w)}{(1+\varepsilon_w\phi)\sigma_w}
\left[
\phi\hat{L}_t-\frac{h}{1-h}\hat{C}_{t-1}
+\frac{1}{1-h}\hat{C}_t-\hat{W}_t
\right]
+\varepsilon_t^w .
\]

- **(F3) 资本积累**

\[
\hat{K}_{t+1} =
\delta(\hat{I}_t+\varepsilon_t^x)
+(1-\delta)(\hat{K}_t+\varepsilon_t^k).
\]

- **(F4) 最优资本利用率**

\[
\hat{Z}_t^k = \frac{\zeta}{1-\zeta}\hat{U}_t .
\]

- **(F5) 投资 Euler 方程**

\[
\hat{I}_t =
\frac{1}{\xi(1+\beta)}(\hat{Q}_t+\varepsilon_t^x)
+\frac{1}{1+\beta}\hat{I}_{t-1}
+\frac{\beta}{1+\beta}E_t\hat{I}_{t+1}.
\]

- **(F6) 企业要素条件**

\[
\hat{W}_t = \hat{Z}_t^k-\hat{L}_t+\hat{K}_t+\hat{U}_t .
\]

- **(F7) SWBGG 金融摩擦下的资本价格/回报条件**

\[
\hat{R}_t^k =
\frac{Z^k}{R^k}\hat{Z}_t^k
+\frac{1-\delta}{R^k}(\hat{Q}_t+\varepsilon_t^k)
-\hat{Q}_{t-1}.
\]

- **(F8) 外部融资溢价**

\[
\hat{E}P_t =
\varkappa\left(\hat{Q}_t+E_t\hat{K}_{t+1}-E_t\hat{N}_{t+1}\right).
\]

- **(F9) 利差关系**

\[
E_t\hat{R}_{t+1}^k=\hat{R}_t+\hat{E}P_t .
\]

- **(F10) 企业净值积累**

\[
\frac{1}{\theta R^k}E_t\hat{N}_{t+1}
=
\frac{K}{N}\hat{R}_t^k
-\left(\frac{K}{N}-1\right)\hat{R}_{t-1}
-\varkappa\left(\frac{K}{N}-1\right)(\hat{K}_t+\hat{Q}_{t-1})
+\left[\left(\frac{K}{N}-1\right)\varkappa+1\right]\hat{N}_t .
\]

## 4. Market Clearing & Identities

- **(F11) 资源约束**

\[
\hat{Y}_t =
\frac{C}{Y}\hat{C}_t
+\frac{I}{Y}\hat{I}_t
+\frac{G}{Y}\varepsilon_t^g
+Z^k\frac{K}{Y}\hat{U}_t .
\]

- **(F12) 生产函数**

\[
\hat{Y}_t =
\Theta\left[
\varepsilon_t^a
+\alpha(\varepsilon_t^k+\hat{K}_t+\hat{U}_t)
+(1-\alpha)\hat{L}_t
\right].
\]

- **(F13) 价格 Phillips 曲线**

\[
\hat{\Pi}_t =
\frac{\sigma_{pi}}{1+\sigma_{pi}\beta}\hat{\Pi}_{t-1}
+\frac{\beta}{1+\sigma_{pi}\beta}E_t\hat{\Pi}_{t+1}
-\frac{(1-\beta\sigma_p)(1-\sigma_p)}
{(1+\sigma_{pi}\beta)\sigma_p}
\left[
\varepsilon_t^a-\alpha\hat{Z}_t^k-(1-\alpha)\hat{W}_t
\right]
+\varepsilon_t^p .
\]

- **(F14) Taylor 规则**

\[
\hat{R}_t^n =
\rho_i\hat{R}_{t-1}^n
+(1-\rho_i)\left[
\rho_{\pi}\hat{\Pi}_t
+\rho_y(\hat{Y}_t-\hat{Y}_t^p)
\right]
+\rho_{\Delta y}\left[
\hat{Y}_t-\hat{Y}_t^p-(\hat{Y}_{t-1}-\hat{Y}_{t-1}^p)
\right]
+\varepsilon_t^r .
\]

- **(F15) Fisher 方程**

\[
\hat{R}_t^n = \hat{R}_t + E_t\hat{\Pi}_{t+1}.
\]

## 5. Exogenous Processes

论文说明模型有七个正交结构冲击。下列符号方向跟随 Rep-MMB 实现交叉检查；正式提升前应进行来源复核。

- **(F16) 技术冲击**

\[
\varepsilon_t^a = \rho_a\varepsilon_{t-1}^a - e_t^a .
\]

- **(F17) 政府支出冲击**

\[
\varepsilon_t^g = \rho_g\varepsilon_{t-1}^g - e_t^g .
\]

- **(F18) 投资专有技术冲击**

\[
\varepsilon_t^x = \rho_x\varepsilon_{t-1}^x - e_t^x .
\]

- **(F19) 货币政策冲击**

\[
\varepsilon_t^r = \rho_{ri}\varepsilon_{t-1}^r + e_t^r .
\]

- **(F20) 价格加成冲击**

\[
\varepsilon_t^p = \rho_p\varepsilon_{t-1}^p + e_t^p .
\]

- **(F21) 工资加成冲击**

\[
\varepsilon_t^w = \rho_w\varepsilon_{t-1}^w + e_t^w .
\]

- **(F22) 资本质量冲击**

\[
\varepsilon_t^k = \rho_k\varepsilon_{t-1}^k - e_t^k .
\]

## 6. Steady-State Solution

因为 `EA_VI16bgg` 是线性化模型，模型块中的动态变量都是相对稳态的偏离，确定性稳态为零：

\[
\hat{C}=\hat{I}=\hat{Y}=\hat{W}=\hat{L}=\hat{\Pi}=\hat{R}=\hat{R}^n
=\hat{Z}^k=\hat{U}=\hat{K}=\hat{Q}=\hat{R}^k
=\hat{E}P=\hat{N}=0 .
\]

用于缩放线性方程的稳态常数为：

\[
R=\frac{1}{\beta},\qquad
Z^k=R-(1-\delta),\qquad
R^k=S R .
\]

\[
\frac{K}{N}=2,\qquad
\frac{G}{Y}=0.20,\qquad
\frac{I}{K}=\delta .
\]

论文校准：\(\beta=0.99\)，\(\alpha=0.33\)，\(\delta=0.025\)，\(G/Y=0.20\)，商品和劳动替代弹性用于匹配 1.20 的总加成，企业存活率 \(\theta=0.972\)，年化稳态利差目标 \(S=150\) 个基点，且 \(K/N=2\)。Rep-MMB 实现在进入 `model(linear)` 前由这些基本量推导 \(C/Y\)、\(I/Y\)、\(K/Y\)、\(Z^k\)、\(W\) 和 \(R^k\) 等比率。

employment Phillips curve 出现在来源表中，但 `EA_VI16bgg` 实现省略了 employment。它对稳态和方程数量的影响仍为 `needs_review`。

## 7. Timing & Form Conventions

- **线性形式**：档案条目应实现为 `model(linear)`。
- **带帽变量**：带帽变量是相对稳态偏离；论文说明没有时间下标的变量表示稳态值。
- **资本时序**：论文描述期末以价格 \(Q_t\) 购买 \(K_{t+1}\)，用于 \(t+1\) 期生产。Rep-MMB 实现在生产函数中使用预定状态 `k(-1)`，并把资本积累写成当期 `k` 取决于滞后 `k`；这是同一约定在 Dynare 时序中的平移。
- **金融时序**：来源方程中，BGG 溢价使用预期下一期净值；实现用当前 `n` 和模型移位时序表示。此时序规范来自实现交叉检查，仍为 `needs_review`。
- **产出缺口**：政策规则使用 \(\hat{Y}_t-\hat{Y}_t^p\)；实现用平行的 flexible-price 模块得到 \(\hat{Y}_t^p\)。
- **运行时验证**：未执行。

实现中用于 \(\hat{Y}^p\) 的 flexible-price 辅助模块：

- **(F23) flexible 边际产出条件**

\[
\alpha\hat{Z}_{t}^{k,p}=\varepsilon_t^a-(1-\alpha)\hat{W}_t^p .
\]

- **(F24) flexible 利用率**

\[
\hat{U}_t^p=\frac{1-\zeta}{\zeta}\hat{Z}_t^{k,p}.
\]

- **(F25) flexible 企业要素条件**

\[
\hat{Z}_t^{k,p}=\hat{W}_t^p+\hat{L}_t^p-\hat{K}_{t-1}^p-\hat{U}_t^p .
\]

- **(F26) flexible 投资 Euler 方程**

\[
\hat{I}_t^p =
\frac{1}{1+\beta}\left[
\hat{I}_{t-1}^p+\beta\hat{I}_{t+1}^p+\frac{1}{\xi}(\hat{Q}_t^p+\varepsilon_t^x)
\right].
\]

- **(F27) flexible 资本价格/回报条件**

\[
\hat{R}_t^{k,p} =
\frac{Z^k}{R^k}\hat{Z}_t^{k,p}
+\frac{1-\delta}{R^k}(\hat{Q}_t^p+\varepsilon_t^k)
-\hat{Q}_{t-1}^p .
\]

- **(F28) flexible 外部融资溢价**

\[
\hat{E}P_t^p=\varkappa(\hat{Q}_t^p+\hat{K}_t^p-\hat{N}_t^p).
\]

- **(F29) flexible 利差关系**

\[
E_t\hat{R}_{t+1}^{k,p}=\hat{E}P_t^p+\hat{R}_t^p .
\]

- **(F30) flexible 净值积累**

\[
\frac{1}{\theta R^k}\hat{N}_t^p
=
\frac{K}{N}\hat{R}_t^{k,p}
-\left(\frac{K}{N}-1\right)\hat{R}_{t-1}^p
-\varkappa\left(\frac{K}{N}-1\right)(\hat{K}_{t-1}^p+\hat{Q}_{t-1}^p)
+\left[\left(\frac{K}{N}-1\right)\varkappa+1\right]\hat{N}_{t-1}^p .
\]

- **(F31) flexible 消费 Euler 方程**

\[
\hat{C}_t^p =
\frac{1}{1+h}\hat{C}_{t+1}^p
+\frac{h}{1+h}\hat{C}_{t-1}^p
-\frac{1-h}{1+h}\hat{R}_t^p .
\]

- **(F32) flexible 资源约束**

\[
\hat{Y}_t^p =
\frac{C}{Y}\hat{C}_t^p
+\frac{I}{Y}\hat{I}_t^p
+\frac{G}{Y}\varepsilon_t^g
+Z^k\frac{K}{Y}\hat{U}_t^p .
\]

- **(F33) flexible 生产函数**

\[
\hat{Y}_t^p =
\Theta\left[
\varepsilon_t^a+\alpha(\hat{K}_{t-1}^p+\varepsilon_t^k+\hat{U}_t^p)
+(1-\alpha)\hat{L}_t^p
\right].
\]

- **(F34) flexible 劳动供给/工资条件**

\[
\hat{W}_t^p =
\phi\hat{L}_t^p+\frac{1}{1-h}\hat{C}_t^p-\frac{h}{1-h}\hat{C}_{t-1}^p .
\]

- **(F35) flexible 资本积累**

\[
\hat{K}_t^p=(1-\delta)(\hat{K}_{t-1}^p+\varepsilon_t^k)+\frac{I}{K}\hat{I}_t^p+\frac{I}{K}\xi\varepsilon_t^x .
\]

## 8. Variable & Parameter Reference Table

### 内生变量

| ASCII 名称 | 数学符号 | 含义 | 主要方程 |
|---|---|---|---|
| `y` | \(\hat{Y}_t\) | 产出 | (F11), (F12) |
| `c` | \(\hat{C}_t\) | 消费 | (F1) |
| `i` | \(\hat{I}_t\) | 投资 | (F5) |
| `w` | \(\hat{W}_t\) | 实际工资 | (F2), (F6) |
| `l` | \(\hat{L}_t\) | 劳动 | (F2), (F12) |
| `pi` | \(\hat{\Pi}_t\) | 通胀 | (F13) |
| `r` | \(\hat{R}_t\) | 实际利率 | (F15) |
| `rn` | \(\hat{R}_t^n\) | 名义政策利率 | (F14) |
| `zk` | \(\hat{Z}_t^k\) | 资本边际产出/租金回报分量 | (F4), (F7) |
| `u` | \(\hat{U}_t\) | 资本利用率 | (F4) |
| `k` | \(\hat{K}_t\) | 资本存量 | (F3) |
| `q` | \(\hat{Q}_t\) | 资本价格 / Tobin's Q | (F5), (F7) |
| `rk` | \(\hat{R}_t^k\) | 资本回报 / 外部融资成本 | (F7), (F9) |
| `ext_pr` | \(\hat{E}P_t\) | 外部融资溢价 / 利差 | (F8), (F9) |
| `n` | \(\hat{N}_t\) | 企业净值 | (F10) |
| `yf, cf, if, wf, lf, rf, zkf, uf, kf, qf, rkf, ext_prf, nf` | flexible-price counterparts | 用于产出缺口的自然率辅助系统 | (F23)-(F35) |
| `a, g, eps_x, eps_r, eps_p, eps_w, eps_k` | \(\varepsilon_t^a,\varepsilon_t^g,\varepsilon_t^x,\varepsilon_t^r,\varepsilon_t^p,\varepsilon_t^w,\varepsilon_t^k\) | 内生冲击状态 | (F16)-(F22) |

### 外生创新

| ASCII 名称 | 含义 |
|---|---|
| `e_a` | 技术创新 |
| `e_g` | 政府支出创新 |
| `e_x` | 投资专有技术创新 |
| `e_r` | 货币政策创新 |
| `e_p` | 价格加成创新 |
| `e_w` | 工资加成创新 |
| `e_k` | 资本质量创新 |

### 参数

| ASCII 名称 | 含义 | 来源值或作用 |
|---|---|---|
| `beta` | 贴现因子 \(\beta\) | 0.99 |
| `alpha` | 资本收入份额 \(\alpha\) | 0.33 |
| `delta` | 折旧率 \(\delta\) | 0.025 |
| `epsilon`, `epsilon_w` | 商品和劳动替代弹性 | 匹配 1.20 的总加成 |
| `G_Y` | 政府支出占 GDP 比例 | 0.20 |
| `theta` | 企业存活概率 | 0.972 |
| `N_K` | 净值资本比 | 0.500，因此 \(K/N=2\) |
| `kappa` | 外部融资溢价弹性 | EA 后验均值约 0.04 |
| `h` | 习惯形成参数 | EA 后验均值约 0.69 |
| `ksi` | 投资调整成本 | EA 后验均值约 4.59 |
| `zeta` | 资本利用率弹性变换 | EA 后验均值约 0.95 |
| `sigma_p`, `sigma_w` | Calvo 价格和工资参数 | EA 后验均值约 0.82 和 0.77 |
| `sigma_pi`, `sigma_wi` | 价格和工资指数化 | EA 后验均值约 0.15 和 0.37 |
| `phi` | Frisch 弹性倒数 | EA 后验均值约 1.34 |
| `Theta` | 固定成本/生产缩放参数 | EA 后验均值约 1.33 |
| `rho_pi`, `rho_y`, `rho_dy`, `rho_r` | Taylor 规则参数 | EA 后验均值约 1.80、0.09、0.06、0.88 |
| `rho_a`, `rho_k`, `rho_g`, `rho_x`, `rho_ri`, `rho_p`, `rho_w` | 冲击持久性参数 | 估计 AR 系数 |
| `bas_point`, `s_coef` | 稳态利差变换 | 实现目标为年化 150 个基点 |

建议 catalog 行：`EA_VI16bgg,Derivation,Financial frictions in the Euro Area and the United States: a Bayesian assessment,2016,Linearized DSGE,Euro Area,Financial frictions,Smets-Wouters with BGG firm balance-sheet channel,2026-06-17,raw/mmb_mineru/runs/ea_vi16bgg_ea_vi16gk_us_vi16bgg_us_vi16gk__financial_frictions_in_the_euro_area_and_the_united_states_a_bayesian_as__ed2f2b1d/full.md,raw/mmb_papers/Financial frictions in the Euro Area and the United States- a Bayesian assessment.pdf,10.1017/s1365100514000881,needs_review`
