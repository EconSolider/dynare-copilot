# EA_VI16gk - 推导

> 用途：为以后编写 Dynare 实现准备的、带来源记录的推导。未执行运行时验证。第一遍状态：`needs_review`。

## 1. 模型概述

- **模型 ID**：`EA_VI16gk`。
- **来源**：Stefania Villa (2016), "Financial frictions in the Euro Area and the United States: a Bayesian assessment", *Macroeconomic Dynamics*, 20(05), 1313-1340, DOI `10.1017/s1365100514000881`。
- **变体**：欧元区 SWGK 模型，即带 Gertler-Karadi 金融中介摩擦的 Smets-Wouters 经济。论文用 1983Q1-2008Q3 的欧元区季度数据估计该模型。
- **主体和模块**：家庭、劳动工会、劳动打包商、零售商、最终品厂商、中间品厂商、资本品生产者、金融中介和货币当局。
- **形式**：对数线性化模型。带帽变量表示相对稳态的百分比偏离；无时间下标变量表示稳态值。Rep-MMB 实现使用 `model(linear)`。
- **来源范围**：下列方程提取自论文 Table 1 中的 SW 模型方程以及 SWGK 金融中介模块。公式整体可读，但 Table 1 中若干 OCR 问题标为 `needs_review`。

## 2. 主体的最优化问题

### 家庭

家庭消费、储蓄并供给劳动。带外部习惯时，线性模型中使用的边际效用对象为：

$$
\hat{\mu}_t = \frac{h}{1-h}\hat{C}_{t-1} - \frac{1}{1-h}\hat{C}_t,
\qquad
\hat{\Lambda}_{t,t+1} = \hat{\mu}_{t+1} - \hat{\mu}_t.
$$

欧拉方程列在第 3 节。SWGK 变体中，每个家庭还包含工人和银行家：银行家以概率 $\theta$ 存活，退出的银行家转为工人，新进入的银行家得到相当于总资产一小部分 $\chi$ 的初始转移。

### 劳动工会和劳动打包商

工会差异化劳动，并在 Calvo 工资黏性和指数化下设定工资。竞争性劳动打包商聚合差异化劳动，再卖给中间品厂商。

### 零售商和最终品厂商

零售商差异化商品，并在 Calvo 价格黏性和指数化下设定价格。最终品厂商聚合中间品。论文直接给出对数线性的价格 Phillips 曲线。

### 中间品厂商和资本品生产者

中间品厂商租用有效资本和劳动生产产出。资本品生产者把投资和折旧资本转化为供生产使用的资本，并存在投资调整成本。在 SWGK 变体中，中间品厂商通过金融中介为资本购买融资。

### 金融中介

每个银行家管理一个金融中介。道德风险摩擦来自银行家可以转移可用资金的一部分 $\lambda$。因此，存款人施加激励约束，使金融中介能够持有的资产正向依赖银行家净值。线性化的资产价值、净值价值、杠杆和净值方程列在第 3 节。

## 3. 一阶条件（FOC）

**(F1) 消费欧拉方程**

$$
\frac{1+h}{1-h}\hat{C}_t =
\frac{1}{1-h}E_t[\hat{C}_{t+1}]
+ \frac{h}{1-h}\hat{C}_{t-1}
- \hat{R}_t.
$$

**(F2) 工资 Phillips 曲线**

$$
\hat{W}_t =
\frac{\beta}{1+\beta}E_t[\hat{W}_{t+1}]
+ \frac{1}{1+\beta}\hat{W}_{t-1}
+ \frac{\beta}{1+\beta}E_t[\hat{\Pi}_{t+1}]
- \frac{1+\beta\sigma_{wi}}{1+\beta}\hat{\Pi}_t
+ \frac{\sigma_{wi}}{1+\beta}\hat{\Pi}_{t-1}
+ \frac{1}{1+\beta}
\frac{(1-\beta\sigma_w)(1-\sigma_w)}
{(1+\varepsilon_w\phi)\sigma_w}
\left[
\phi\hat{L}_t - \frac{h}{1-h}\hat{C}_{t-1}
+ \frac{1}{1-h}\hat{C}_t - \hat{W}_t
\right]
+ \varepsilon_t^w.
$$

**(F3) 资本积累**

$$
\hat{K}_{t+1}
= \delta(\hat{I}_t + \varepsilon_t^x)
+ (1-\delta)(\hat{K}_t + \varepsilon_t^k).
$$

**(F4) 最优资本利用率**

$$
\hat{Z}^k_t = \frac{\zeta}{1-\zeta}\hat{U}_t.
$$

**(F5) 投资欧拉方程**

$$
\hat{I}_t =
\frac{1}{\xi(1+\beta)}(\hat{Q}_t+\varepsilon_t^x)
+ \frac{1}{1+\beta}\hat{I}_{t-1}
+ \frac{\beta}{1+\beta}E_t[\hat{I}_{t+1}].
$$

**(F6) 生产侧要素一阶条件**

$$
\hat{W}_t = \hat{Z}^k_t - \hat{L}_t + \hat{K}_t + \hat{U}_t.
$$

**(F7) 价格 Phillips 曲线**

$$
\hat{\Pi}_t =
\frac{\sigma_{pi}}{1+\sigma_{pi}\beta}\hat{\Pi}_{t-1}
+ \frac{\beta}{1+\sigma_{pi}\beta}E_t[\hat{\Pi}_{t+1}]
- \frac{(1-\beta\sigma_p)(1-\sigma_p)}
{(1+\sigma_{pi}\beta)\sigma_p}
\left[
\varepsilon_t^a - \alpha\hat{Z}^k_t - (1-\alpha)\hat{W}_t
\right]
+ \varepsilon_t^p.
$$

**(F8) SWGK 模块中的资本价格/资本回报**

$$
\hat{R}^k_t =
\frac{Z^k}{R^k}\hat{Z}^k_t
+ \frac{1-\delta}{R^k}(\hat{Q}_t+\varepsilon_t^k)
- \hat{Q}_{t-1}.
$$

**(F9) 扩张资产的收益**

$$
\hat{V}_t =
\frac{(1-\theta)\beta}{V}(R^k-R)E_t[\hat{\Lambda}_{t,t+1}]
+ \frac{(1-\theta)\beta}{V}
\left[
R^k E_t[\hat{R}^k_{t+1}] - R\hat{R}_t
\right]
+ \theta\beta X E_t[
\hat{X}_{t,t+1}+\hat{V}_{t+1}+\hat{\Lambda}_{t,t+1}
].
$$

**(F10) 扩张净值的价值**

$$
\hat{D}_t =
\theta\beta Z E_t[
\hat{\Lambda}_{t,t+1}+\hat{Z}_{t,t+1}+\hat{D}_{t+1}
].
$$

**(F11) 净值总增长率**

$$
\hat{Z}_{t,t+1} =
\frac{1}{Z}
\left[
\operatorname{lev} R^k E_t[\hat{R}^k_{t+1}]
+ R(1-\operatorname{lev})\hat{R}_t
+ (R^k-R)\operatorname{lev}\,\widehat{\operatorname{lev}}_t
\right].
$$

**(F12) 资产总增长率**

$$
\hat{X}_{t,t+1}
= E_t[\widehat{\operatorname{lev}}_{t+1}]
+ \hat{Z}_{t,t+1}
- \widehat{\operatorname{lev}}_t.
$$

来源 OCR 将该式渲染为 `lev t+1`；上式依据方程标题和实现交叉检查整理。状态：`needs_review`。

**(F13) 杠杆**

$$
\widehat{\operatorname{lev}}_t =
\hat{D}_t + \frac{V}{\lambda-V}\hat{V}_t.
$$

Rep-MMB 文件为了确定性将该关系向前移动一期；论文表格把它写在 $t$。运行时序状态：`needs_review`。

**(F14) 金融中介激励/资产负债表约束**

$$
\hat{K}_{t+1} + \hat{Q}_t =
\widehat{\operatorname{lev}}_t + \hat{N}_t.
$$

来源 OCR 拆开了 `lev`；实现文件确认其意图是杠杆变量。

**(F15) 既有金融中介净值**

$$
\hat{N}^e_t =
\hat{N}_{t-1}
+ \frac{1}{Z}
\left[
\operatorname{lev} R^k E_t[\hat{R}^k_{t+1}]
+ R(1-\operatorname{lev})\hat{R}_t
+ (R^k-R)\operatorname{lev}\,\widehat{\operatorname{lev}}_t
\right].
$$

**(F16) 新金融中介净值**

$$
\hat{N}^n_t = \hat{Q}_t + \hat{K}_t.
$$

**(F17) 总净值**

$$
\hat{N}_t =
\frac{N^e}{Y}\frac{Y}{N}\hat{N}^e_t
+ \frac{N^n}{Y}\frac{Y}{N}\hat{N}^n_t.
$$

**(F18) 外部融资溢价/利差**

$$
\widehat{EP}_t = E_t[\hat{R}^k_{t+1}] - \hat{R}_t.
$$

## 4. 市场出清与总量恒等式

**(F19) 资源约束**

$$
\hat{Y}_t =
\frac{C}{Y}\hat{C}_t
+ \frac{I}{Y}\hat{I}_t
+ \frac{G}{Y}\varepsilon_t^g
+ Z^k\frac{K}{Y}\hat{U}_t.
$$

**(F20) 生产函数**

$$
\hat{Y}_t =
\Theta
\left[
\varepsilon_t^a
+ \alpha(\varepsilon_t^k+\hat{K}_t+\hat{U}_t)
+ (1-\alpha)\hat{L}_t
\right].
$$

**(F21) Taylor 规则**

$$
\hat{R}^n_t =
\rho_i\hat{R}^n_{t-1}
+ (1-\rho_i)
\left[
\rho_\pi\hat{\Pi}_t
+ \rho_y(\hat{Y}_t-\hat{Y}^p_t)
\right]
+ \rho_{\Delta y}
\left[
\hat{Y}_t-\hat{Y}^p_t-(\hat{Y}_{t-1}-\hat{Y}^p_{t-1})
\right]
+ \varepsilon_t^r.
$$

**(F22) Fisher 方程**

$$
\hat{R}^n_t = \hat{R}_t + E_t[\hat{\Pi}_{t+1}].
$$

**(F23) 就业 Phillips 曲线**

$$
\hat{E}_t =
\frac{1}{1+\beta}\hat{E}_{t-1}
+ \frac{\beta}{1+\beta}E_t[\hat{E}_{t+1}]
- \frac{(1-\beta\sigma_E)(1-\sigma_E)}
{(1+\beta)\sigma_E}
(\hat{L}_t-\hat{E}_t).
$$

Rep-MMB 实现把该式放在观测方程附近。这里保留它，因为论文 Table 1 将其列为模型方程 (12)。

## 5. 外生过程

论文说明有七个正交 AR(1) 结构冲击：技术、投资特定技术、货币政策、资本质量、政府支出、价格加成和工资加成。正文没有完整打印每条过程方程；Rep-MMB 实现交叉检查使用：

$$
\varepsilon^a_t = \rho_a \varepsilon^a_{t-1} + \eta^a_t,\quad
\varepsilon^x_t = \rho_x \varepsilon^x_{t-1} + \eta^x_t,\quad
\varepsilon^g_t = \rho_g \varepsilon^g_{t-1} + \eta^g_t,
$$

$$
\varepsilon^r_t = \rho_{ri}\varepsilon^r_{t-1} + \eta^r_t,\quad
\varepsilon^p_t = \rho_p\varepsilon^p_{t-1} + \eta^p_t,\quad
\varepsilon^w_t = \rho_w\varepsilon^w_{t-1} + \eta^w_t,\quad
\varepsilon^k_t = \rho_k\varepsilon^k_{t-1} + \eta^k_t.
$$

由于主文没有逐条打印 AR(1) 方程，本模块标记为 `implementation_cross_check` 和 `needs_review`，需要以后对照在线附录。

## 6. 稳态求解

对于线性化模型，所有带帽内生变量在确定性稳态下为零。稳态常数作为系数使用：

1. 设 $\hat{C}=\hat{I}=\hat{Y}=\hat{L}=\hat{W}=\hat{\Pi}=\hat{R}=\hat{R}^n=\hat{Q}=\hat{K}=\hat{U}=0$，并令所有冲击创新为零。
2. 论文共同校准：$\beta=0.99$，$\alpha=0.33$，$\delta=0.025$，$G/Y=0.20$，商品和工资弹性用于匹配 1.20 的加成率。
3. SWGK 金融校准：存活率 $\theta=0.972$，稳态年化利差 150 个基点，杠杆率 $K/N=4$，$\chi=0.001$，$\lambda=0.515$。
4. 欧元区 SWGK 后验均值系数包括 $\sigma_p=0.84$，$\sigma_w=0.78$，$\sigma_{pi}=0.15$，$\sigma_{wi}=0.39$，$\sigma_E=0.80$，$\xi=4.95$，$\zeta=0.95$，$h=0.65$，$\Theta=1.40$，$\phi=1.49$，$\rho_\pi=1.73$，$\rho_y=0.09$，$\rho_{\Delta y}=0.08$，$\rho_i=0.89$，趋势增长率 $0.30$，稳态通胀 $0.63$；冲击持久性和标准差见 Table 5。
5. Rep-MMB 实现在 `model(linear)` 之前计算派生常数，例如 $R=1/\beta$、$Z^k=R^k-(1-\delta)$、要素比例、支出份额、银行家净值份额、杠杆、$Z$、$X$ 和 $V$。

本推导未执行非线性稳态求解或 Dynare 验证。

## 7. 时序与形式约定

- 带帽变量表示相对稳态的对数或百分比偏离；论文在 Table 1 后明确说明这一点。
- 模型是线性化模型，适合 Dynare `model(linear)`。
- 论文表格在资本积累方程中写 $\hat{K}_{t+1}$，在生产函数中写 $\hat{K}_t$。Rep-MMB 文件调整了若干下标以匹配内部时序，其中注释说明方程 18b 为了确定性向前移动一期，方程 19 使用静态资本而非前瞻资本。这些属于 `needs_review` 运行时序问题。
- SWGK 金融模块在利差、净值增长和资产价值方程中使用预期的下一期资本回报。
- 观测方程将 GDP、消费、投资、实际工资增长、就业/工时、通胀和名义利率映射到模型变量；它们不计入 F1-F23。

## 8. 变量与参数对照表

| 类别 | 符号 / ASCII | 含义 | 主要方程 |
|---|---|---|---|
| 内生变量 | $\hat{C}_t$ / `c` | 消费 | (F1), (F19) |
| 内生变量 | $\hat{\mu}_t$ / `mu` | 边际效用对象 | 第 2 节 |
| 内生变量 | $\hat{\Lambda}_{t,t+1}$ / `Lambda` | 随机贴现因子变化 | (F9), (F10) |
| 内生变量 | $\hat{W}_t$ / `w` | 实际工资 | (F2), (F6), (F7) |
| 内生变量 | $\hat{L}_t$ / `l` | 劳动投入 | (F2), (F6), (F20), (F23) |
| 内生变量 | $\hat{E}_t$ / `emp` | 就业观测状态 | (F23) |
| 内生变量 | $\hat{I}_t$ / `i` | 投资 | (F5), (F19) |
| 内生变量 | $\hat{K}_t$ / `k` | 资本存量 | (F3), (F14), (F16), (F20) |
| 内生变量 | $\hat{U}_t$ / `u` | 资本利用率 | (F4), (F19), (F20) |
| 内生变量 | $\hat{Z}^k_t$ / `zk` | 资本边际产出/使用成本 | (F4), (F6), (F7), (F8) |
| 内生变量 | $\hat{Q}_t$ / `q` | 资本价格 | (F5), (F8), (F14), (F16) |
| 内生变量 | $\hat{Y}_t$ / `y` | 产出 | (F19), (F20), (F21) |
| 内生变量 | $\hat{\Pi}_t$ / `pi` | 通胀 | (F7), (F22) |
| 内生变量 | $\hat{R}_t$ / `r` | 实际利率 | (F1), (F9), (F11), (F18), (F22) |
| 内生变量 | $\hat{R}^n_t$ / `rn` | 名义利率 | (F21), (F22) |
| 内生变量 | $\hat{R}^k_t$ / `rk` | 资本回报率 | (F8), (F9), (F11), (F15), (F18) |
| 内生变量 | $\hat{V}_t$ / `v` | 扩张资产的收益 | (F9), (F13) |
| 内生变量 | $\hat{D}_t$ / `d` | 扩张净值的价值 | (F10), (F13) |
| 内生变量 | $\widehat{lev}_t$ / `lev` | 金融中介杠杆 | (F11), (F12), (F13), (F14), (F15) |
| 内生变量 | $\hat{X}_{t,t+1}$ / `x` | 资产总增长率 | (F9), (F12) |
| 内生变量 | $\hat{Z}_{t,t+1}$ / `z` | 净值总增长率 | (F10), (F11), (F15) |
| 内生变量 | $\hat{N}_t$ / `n` | 金融中介总净值 | (F14), (F15), (F17) |
| 内生变量 | $\hat{N}^e_t$ / `ne` | 既有金融中介净值 | (F15), (F17) |
| 内生变量 | $\hat{N}^n_t$ / `nn` | 新金融中介净值 | (F16), (F17) |
| 内生变量 | $\widehat{EP}_t$ / `ext_pr` | 利差/外部融资溢价 | (F18) |
| 内生变量 | $\hat{Y}^p_t$ / `yf` | 弹性价格产出 | (F21), 弹性价格模块 |
| 外生状态 | $\varepsilon^a_t$ / `eps_a`, `a` | 技术冲击/状态 | (F20), 第 5 节 |
| 外生状态 | $\varepsilon^x_t$ / `eps_x` | 投资特定冲击/状态 | (F3), (F5), 第 5 节 |
| 外生状态 | $\varepsilon^g_t$ / `g` | 政府支出冲击/状态 | (F19), 第 5 节 |
| 外生状态 | $\varepsilon^r_t$ / `eps_r` | 货币政策冲击/状态 | (F21), 第 5 节 |
| 外生状态 | $\varepsilon^p_t$ / `eps_p` | 价格加成冲击/状态 | (F7), 第 5 节 |
| 外生状态 | $\varepsilon^w_t$ / `eps_w` | 工资加成冲击/状态 | (F2), 第 5 节 |
| 外生状态 | $\varepsilon^k_t$ / `eps_k` | 资本质量冲击/状态 | (F3), (F8), (F20), 第 5 节 |
| 参数 | $\beta,\alpha,\delta,G/Y,\varepsilon,\varepsilon_w$ | 共同校准 | 第 6 节 |
| 参数 | $\sigma_p,\sigma_w,\sigma_{pi},\sigma_{wi},\sigma_E,\xi,\zeta,h,\Theta,\phi$ | 名义、真实和偏好摩擦 | (F2), (F4), (F5), (F7), (F23) |
| 参数 | $\rho_\pi,\rho_y,\rho_{\Delta y},\rho_i$ | 货币政策系数 | (F21) |
| 参数 | $\theta,\chi,\lambda,\operatorname{lev},R^k,R,Z,X,V,N^e/Y,N^n/Y$ | SWGK 金融中介常数 | (F9)-(F18) |
| 参数 | $\rho_a,\rho_x,\rho_g,\rho_{ri},\rho_p,\rho_w,\rho_k$ | 冲击持久性 | 第 5 节 |
