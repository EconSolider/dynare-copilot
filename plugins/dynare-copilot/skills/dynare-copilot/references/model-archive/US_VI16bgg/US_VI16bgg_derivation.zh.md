# US_VI16bgg -- 推导（最优化问题 + 一阶条件）

> `US_VI16bgg` 的模型档案条目。未执行运行时验证。公式状态：`needs_review`，因为表 1 来自 MinerU OCR/HTML，且本轮没有取得在线附录。

来源：Stefania Villa (2016), "Financial frictions in the Euro Area and the United States: a Bayesian assessment", *Macroeconomic Dynamics*, 20(05), 1313-1340. DOI: `10.1017/s1365100514000881`。

## 1. Model Overview

- **模型**：Villa (2016) 的美国 SWBGG 模型，将 Smets-Wouters 中等规模 DSGE 核心与 Bernanke-Gertler-Gilchrist 型非金融中间品企业金融摩擦结合。
- **经济体与样本**：美国，使用 1983Q1-2008Q3 季度数据估计。
- **实验**：贝叶斯估计的线性 DSGE 模型，包含七个冲击；本档案条目记录推导层面的模型方程，而不是经过 Dynare 运行验证的实现。
- **主体与模块**：家庭、工会与劳动打包者、零售商与最终品厂商、中间品企业、资本品生产者以及货币当局。在 SWBGG 变体中，中间品企业进行外部融资，并面对 costly-state-verification 金融合约。
- **形式**：`model(linear)`。带帽变量是相对稳态的对数偏离，稳态比率和稳态水平作为常数进入。
- **来源范围**：正文说明在线附录提供完整细节，但源 Markdown 包含带线性化模型方程的表 1。缺失的优化原始问题和只在附录中出现的推导均标记为 `needs_review`。

## 2. Optimization Problems

### 2.1 家庭

家庭选择消费、债券持有和劳动供给，并具有外部习惯。源文件表 1 报告的是所得欧拉方程和工资 Phillips 曲线，而不是完整的家庭拉格朗日问题；因此底层优化问题记录为：

```math
\max_{\{C_t,L_t,B_t\}} E_0 \sum_{t=0}^{\infty} \beta^t
\left[ U(C_t-h C_{t-1}) - V(L_t) \right]
\quad\text{s.t.}\quad
P_t C_t + B_t \le W_t L_t + R^n_{t-1}B_{t-1} + \Pi_t^{div}.
```

`needs_review`：精确的效用归一化依赖附录；下方线性化欧拉方程和工资方程来自表 1。

### 2.2 工会与劳动打包者

工会差异化劳动，并在带有部分工资指数化的 Calvo 工资黏性下设定工资。竞争性劳动打包者聚合差异化劳动，并把综合劳动出售给中间品企业。正文没有打印优化细节，但表 1 给出了工资 Phillips 曲线。

### 2.3 零售商与最终品厂商

零售商差异化商品，并在垄断竞争、Calvo 价格黏性和部分价格指数化下设定价格。最终品厂商竞争性地组装中间品。表 1 给出了相应的价格 Phillips 曲线。

### 2.4 带 BGG 金融合约的中间品企业

中间品企业选择生产要素，并通过净值和外部借款为资本购买融资。在 `t` 期末，企业以价格 `Q_t` 购买资本 `K_{t+1}`，所以资本购买额为 `Q_t K_{t+1}`。净值 `N_{t+1}` 为其中一部分融资，其余部分通过借款融资。企业以概率 `theta` 存活到下一期。

由于项目回报受到企业可无成本观察、但贷款人只能以监测成本观察的个体冲击影响，最优合约生成外部融资溢价：

```math
EP_t = EP\!\left(Q_t + E_t[\hat{K}_{t+1}] - E_t[\hat{N}_{t+1}]\right),
```

其线性化形式见表 1 中的方程 (F14)。

### 2.5 资本品生产者

资本品生产者把投资和折旧后资本转化为出售给中间品企业的新资本。表 1 报告了线性投资欧拉方程和资本积累律。

### 2.6 货币当局

政策制定者遵循包含利率平滑、通胀反应、产出缺口反应、产出缺口增速反应以及货币政策冲击的利率规则。

## 3. First-Order Conditions

**(F1) 带习惯的欧拉方程**

```math
\frac{1+h}{1-h}\hat{C}_{t}
= \frac{1}{1-h}E_t[\hat{C}_{t+1}]
+ \frac{h}{1-h}\hat{C}_{t-1}
- \hat{R}_{t}.
```

**(F2) 工资 Phillips 曲线**

```math
\hat{W}_{t}
= \frac{\beta}{1+\beta}E_t[\hat{W}_{t+1}]
+ \frac{1}{1+\beta}\hat{W}_{t-1}
+ \frac{\beta}{1+\beta}E_t[\hat{\Pi}_{t+1}]
- \frac{1+\beta\sigma_{wi}}{1+\beta}\hat{\Pi}_{t}
+ \frac{\sigma_{wi}}{1+\beta}\hat{\Pi}_{t-1}
+ \frac{1}{1+\beta}
\frac{(1-\beta\sigma_w)(1-\sigma_w)}{(1+\varepsilon_w\phi)\sigma_w}
\left[\phi\hat{L}_{t}-\frac{h}{1-h}\hat{C}_{t-1}
+\frac{1}{1-h}\hat{C}_{t}-\hat{W}_{t}\right]
+\varepsilon_t^w.
```

**(F3) 资本积累**

```math
\hat{K}_{t+1}
= \delta(\hat{I}_{t}+\varepsilon_t^x)
+ (1-\delta)(\hat{K}_{t}+\varepsilon_t^k).
```

**(F4) 最优资本利用率**

```math
\hat{Z}_t^k = \frac{\zeta}{1-\zeta}\hat{U}_t.
```

**(F5) 投资欧拉方程**

```math
\hat{I}_t
= \frac{1}{\xi(1+\beta)}(\hat{Q}_t+\varepsilon_t^x)
+ \frac{1}{1+\beta}\hat{I}_{t-1}
+ \frac{\beta}{1+\beta}E_t[\hat{I}_{t+1}].
```

**(F6) 生产侧要素 FOC**

```math
\hat{W}_t = \hat{Z}_t^k - \hat{L}_t + \hat{K}_t + \hat{U}_t.
```

**(F7) 价格 Phillips 曲线**

```math
\hat{\Pi}_t
= \frac{\sigma_{pi}}{1+\sigma_{pi}\beta}\hat{\Pi}_{t-1}
+ \frac{\beta}{1+\sigma_{pi}\beta}E_t[\hat{\Pi}_{t+1}]
- \frac{(1-\beta\sigma_p)(1-\sigma_p)}{(1+\sigma_{pi}\beta)\sigma_p}
\left[\varepsilon_t^a-\alpha\hat{Z}_t^k-(1-\alpha)\hat{W}_t\right]
+ \varepsilon_t^p.
```

**(F8) Taylor 规则**

```math
\hat{R}_t^n
= \rho_i\hat{R}_{t-1}^n
+ (1-\rho_i)\left[\rho_\pi\hat{\Pi}_t
+ \rho_y(\hat{Y}_t-\hat{Y}_t^p)\right]
+ \rho_{\Delta y}\left[\hat{Y}_t-\hat{Y}_t^p
- (\hat{Y}_{t-1}-\hat{Y}_{t-1}^p)\right]
+ \varepsilon_t^r.
```

**(F9) Fisher 方程**

```math
\hat{R}_t^n = \hat{R}_t + E_t[\hat{\Pi}_{t+1}].
```

**(F10) SWBGG 中的资本价格/资本回报**

```math
\hat{R}_t^k
= \frac{Z^k}{R^k}\hat{Z}_t^k
+ \frac{1-\delta}{R^k}(\hat{Q}_t+\varepsilon_t^k)
- \hat{Q}_{t-1}.
```

**(F11) 外部融资溢价**

```math
\hat{EP}_t
= \varkappa\left(\hat{Q}_t + E_t[\hat{K}_{t+1}]
- E_t[\hat{N}_{t+1}]\right).
```

**(F12) 利差/资本回报套利**

```math
E_t[\hat{R}_{t+1}^k] = \hat{R}_t + \hat{EP}_t.
```

**(F13) 企业净值积累**

```math
\frac{1}{\theta R^k}E_t[\hat{N}_{t+1}]
= \frac{K}{N}\hat{R}_t^k
- \left(\frac{K}{N}-1\right)\hat{R}_{t-1}
- \varkappa\left(\frac{K}{N}-1\right)(\hat{K}_t+\hat{Q}_{t-1})
+ \left[\left(\frac{K}{N}-1\right)\varkappa+1\right]\hat{N}_t.
```

## 4. Market Clearing & Identities

**(F14) 资源约束**

```math
\hat{Y}_t
= \frac{C}{Y}\hat{C}_t
+ \frac{I}{Y}\hat{I}_t
+ \frac{G}{Y}\varepsilon_t^g
+ Z^k\frac{K}{Y}\hat{U}_t.
```

**(F15) 生产函数**

```math
\hat{Y}_t
= \Theta\left[\varepsilon_t^a
+ \alpha(\varepsilon_t^k+\hat{K}_t+\hat{U}_t)
+ (1-\alpha)\hat{L}_t\right].
```

**(F16) 可选就业 Phillips 曲线**

```math
\hat{E}_t
= \frac{1}{1+\beta}\hat{E}_{t-1}
+ \frac{\beta}{1+\beta}E_t[\hat{E}_{t+1}]
- \frac{(1-\beta\sigma_E)(1-\sigma_E)}{(1+\beta)\sigma_E}
(\hat{L}_t-\hat{E}_t).
```

`needs_review`：实现交叉检查中，美国复制版因为有可用工时数据而注释掉就业方程；本档案保留表 1 中的来源方程，但将其标为美国 MMB 实现的可选项。

## 5. Exogenous Processes

论文说明七个正交冲击服从 AR(1) 过程。下列符号方向来自 `US_VI16bgg_rep.mod` 实现交叉检查；由于表 1 本身没有打印全部 AR(1) 规律，这些符号方向属于 `implementation_cross_check`。

**(F17) 技术冲击**

```math
\varepsilon_t^a = \rho_a\varepsilon_{t-1}^a - e_t^a.
```

**(F18) 政府冲击**

```math
\varepsilon_t^g = \rho_g\varepsilon_{t-1}^g - e_t^g.
```

**(F19) 投资专有技术冲击**

```math
\varepsilon_t^x = \rho_x\varepsilon_{t-1}^x - e_t^x.
```

**(F20) 货币政策冲击**

```math
\varepsilon_t^r = \rho_{ri}\varepsilon_{t-1}^r + e_t^r.
```

**(F21) 价格加成冲击**

```math
\varepsilon_t^p = \rho_p\varepsilon_{t-1}^p + e_t^p.
```

**(F22) 工资加成冲击**

```math
\varepsilon_t^w = \rho_w\varepsilon_{t-1}^w + e_t^w.
```

**(F23) 资本质量冲击**

```math
\varepsilon_t^k = \rho_k\varepsilon_{t-1}^k - e_t^k.
```

## 6. Steady-State Solution

因为模型是线性化模型，所有带帽内生变量和零均值冲击的稳态均为零：

```math
\hat{C}=\hat{I}=\hat{Y}=\hat{W}=\hat{L}=\hat{\Pi}=\hat{R}=\hat{R}^n
=\hat{K}=\hat{Q}=\hat{R}^k=\hat{EP}=\hat{N}=\hat{U}=\hat{Z}^k=0.
```

来源和实现交叉检查定义了稳态常数：

```math
R=\frac{1}{\beta},\qquad
Z^k=R-(1-\delta),\qquad
R^k=S R,\qquad
\frac{K}{N}=2.
```

线性方程中使用的其他比率由校准常数计算：

```math
\frac{I}{K}=\delta,\qquad
\frac{G}{Y}=0.20,\qquad
\frac{C}{Y}=1-\frac{I}{Y}-\frac{G}{Y}.
```

`needs_review`：来源表 1 没有打印每个稳态比率公式。实现交叉检查计算了 `W`、`K_L`、`Y_K`、`K_Y`、`I_Y` 和 `C_Y`；这些在 `extraction_notes.md` 中作为实现证据记录，而不是独立的论文侧推导。

## 7. Timing & Form Conventions

- **线性形式**：MMB 实现使用 `model(linear)`。带帽变量是对数偏离或相对稳态的百分比偏离。
- **资本时序**：论文把 `t` 期末购买、供 `t+1` 使用的资本记为 `K_{t+1}`；实现中用预定资本写法，在生产和回报方程中使用 `k(-1)`，并用 `k` 表示下一期/期末资本。
- **金融时序**：外部融资溢价取决于预期下一期资本和净值。实现交叉检查在当前模型时序下写为 `ext_pr = kappa*(q + k - n)`。
- **产出缺口**：Taylor 规则对黏性价格产出相对于灵活价格产出 `Y_t - Y_t^p` 作出反应。
- **美国特定实现约定**：就业 Phillips 曲线在来源中给出，但在美国 MMB `.mod` 中被注释掉；模型使用工时而不是就业模块。
- **运行时验证**：未执行。

## 8. Variable & Parameter Reference Table

| 类别 | 符号 / ASCII | 含义 | 方程覆盖 |
|---|---|---|---|
| 内生 | `c`, `C_t` | 消费偏离 | (F1), (F14) |
| 内生 | `i`, `I_t` | 投资偏离 | (F5), (F14) |
| 内生 | `y`, `Y_t` | 产出偏离 | (F14), (F15), (F8) |
| 内生 | `w`, `W_t` | 实际工资偏离 | (F2), (F6), (F7) |
| 内生 | `l`, `L_t` | 劳动或工时偏离 | (F2), (F6), (F15) |
| 内生 | `pi`, `Pi_t` | 通胀偏离 | (F2), (F7), (F8), (F9) |
| 内生 | `r`, `R_t` | 实际利率偏离 | (F1), (F9), (F12) |
| 内生 | `rn`, `R_t^n` | 名义利率偏离 | (F8), (F9) |
| 内生 | `zk`, `Z_t^k` | 资本租赁率/资本边际产出偏离 | (F4), (F6), (F10), (F15) |
| 内生 | `u`, `U_t` | 资本利用率偏离 | (F4), (F14), (F15) |
| 内生 | `k`, `K_t` | 资本存量偏离 | (F3), (F11), (F13), (F15) |
| 内生 | `q`, `Q_t` | 资本价格偏离 | (F5), (F10), (F11), (F13) |
| 内生 | `rk`, `R_t^k` | 资本回报偏离 | (F10), (F12), (F13) |
| 内生 | `ext_pr`, `EP_t` | 外部融资溢价/利差 | (F11), (F12) |
| 内生 | `n`, `N_t` | 净值偏离 | (F11), (F13) |
| 内生 | `yf, cf, if, wf, lf, rf, zkf, uf, kf, qf, rkf, ext_prf, nf` | 用于产出缺口和自然利率模块的灵活价格对应变量 | 对应 (F1), (F3)-(F6), (F10)-(F13), (F14), (F15) |
| 可选内生 | `E_t` | 就业偏离 | (F16)，美国实现中可选 |
| 外生状态 | `a` | 技术冲击状态 | (F17) |
| 外生状态 | `g` | 政府冲击状态 | (F18), (F14) |
| 外生状态 | `eps_x` | 投资专有技术冲击状态 | (F19), (F3), (F5) |
| 外生状态 | `eps_r` | 货币政策冲击状态 | (F20), (F8) |
| 外生状态 | `eps_p` | 价格加成冲击状态 | (F21), (F7) |
| 外生状态 | `eps_w` | 工资加成冲击状态 | (F22), (F2) |
| 外生状态 | `eps_k` | 资本质量冲击状态 | (F23), (F3), (F10), (F15) |
| 创新 | `e_a, e_g, e_x, e_r, e_p, e_w, e_k` | 正交创新 | (F17)-(F23) |
| 参数 | `alpha, beta, delta` | 资本份额、贴现因子、折旧率 | 稳态、(F3), (F7), (F10), (F15) |
| 参数 | `epsilon, epsilon_w, M` | 商品/劳动替代弹性与加成目标 | 价格和工资模块 |
| 参数 | `G_Y, N_K, theta, bas_point, s_coef` | 政府份额、净值资本比、企业存活率、利差校准 | (F11)-(F14)、稳态 |
| 参数 | `ksi, h, zeta, phi, Theta, kappa` | 投资调整、习惯、利用率、劳动供给、固定成本、外部融资弹性 | (F1)-(F7), (F11), (F13), (F15) |
| 参数 | `sigma_w, sigma_p, sigma_wi, sigma_pi` | 工资和价格 Calvo/指数化参数 | (F2), (F7) |
| 参数 | `rho_pi, rho_dy, rho_y, rho_r` | Taylor 规则系数 | (F8) |
| 参数 | `rho_a, rho_k, rho_g, rho_x, rho_ri, rho_p, rho_w` | 冲击持久性 | (F17)-(F23) |
