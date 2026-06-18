# US_VI16gk -- 推导（最优化问题 + 一阶条件）

> 本稿用于私有 MMB 推导档案。未执行运行时验证。公式质量标记为 `needs_review`，因为方程来自 MinerU Markdown OCR，并且只与 Rep-MMB 实现作交叉检查，未读取 PDF 正文逐式核验。

来源：Stefania Villa (2016), "Financial frictions in the Euro Area and the United States: a Bayesian assessment," *Macroeconomic Dynamics*, 20(05), 1313-1340。DOI: `10.1017/s1365100514000881`。模型 `US_VI16gk` 是美国估计版 Smets-Wouters/Gertler-Karadi 金融中介变体。

## 1. Model Overview

- **模型**：Villa (2016) 的美国 SWGK 模型。该模型把 Gertler-Karadi 金融中介嵌入 Smets-Wouters 风格的中等规模新凯恩斯 DSGE 经济。
- **经济体与实验**：美国季度估计，样本期为论文中的 1983Q1-2008Q3。可观测变量为产出增长、消费增长、投资增长、工时、通胀、工资增长和名义利率。
- **主体与模块**：家庭、工会、劳动打包者、零售商、最终品厂商、中间品厂商、资本品生产者、金融中介和货币当局。实现还包含一个灵活价格/工资的参照经济，用于构造产出缺口。
- **金融摩擦**：银行家经营金融中介。银行家以概率 $`\theta`$ 存活，新进入银行家获得资产比例 $`\chi`$ 的启动转移，并因可转移资产比例 $`\lambda`$ 而面对道德风险激励约束。
- **形式**：对数线性 `model(linear)`。带帽变量表示相对稳态的对数偏离或百分比偏离。Rep-MMB `.mod` 以 `model(linear)` 实现美国 GK 分支。

## 2. Optimization Problems

### 2.1 家庭

主文 Markdown 没有打印完整非线性家庭问题，但表 1 给出了线性化欧拉方程和边际效用定义。家庭具有外部消费习惯，通过工会供给差异化劳动，向金融中介存款，并包含工人与银行家成员。

在档案记号中，消费-储蓄模块由边际效用 $`\hat{\mu}_t`$ 和随机贴现因子 $`\hat{\Lambda}_{t,t+1}`$ 概括：

```math
(1-h)\hat{\mu}_t = h\hat{C}_{t-1}-\hat{C}_t .
```

### 2.2 工会

工会在 Calvo 工资黏性和部分工资指数化下设定差异化工资。其优化产生第 3 节的工资 Phillips 曲线。主文 Markdown 未给出完整非线性递归工会问题；线性化条件由表 1 给出。

### 2.3 零售商与中间品厂商

零售商在 Calvo 价格黏性和部分价格指数化下设定差异化商品价格。中间品厂商租用有效资本和劳动、选择资本利用率，并用固定成本/规模参数 $`\Theta`$ 生产。来源给出了线性化价格 Phillips 曲线、利用率条件、要素 FOC、生产函数和资本回报方程。

### 2.4 资本品生产者

资本品生产者在投资调整成本和投资专用技术冲击下，把投资和折旧资本转化为安装资本。其线性化最优条件为第 3 节的投资欧拉方程。

### 2.5 金融中介

银行家在激励约束下选择资产与负债。论文给出 GK 条件的线性化形式：扩张资产收益、扩张净值价值、净值/资产增长率、杠杆、净值加总和利差。激励约束具有标准 GK 含义：资产只能按银行净值的某个倍数扩张，而该倍数由延续价值和可转移资产参数 $`\lambda`$ 决定。

## 3. First-Order Conditions

**家庭与工资设定模块**

- **(F1) 习惯调整后的边际效用**：

```math
(1-h)\hat{\mu}_t = h\hat{C}_{t-1}-\hat{C}_t .
```

- **(F2) 随机贴现因子**：

```math
\hat{\Lambda}_{t,t+1} = \hat{\mu}_{t+1}-\hat{\mu}_t .
```

- **(F3) 消费欧拉方程**：

```math
\frac{1+h}{1-h}\hat{C}_t
= \frac{1}{1-h}E_t\hat{C}_{t+1}
+ \frac{h}{1-h}\hat{C}_{t-1}
- \hat{R}_t .
```

- **(F4) 工资 Phillips 曲线**：

```math
\begin{aligned}
\hat{W}_t
=&\frac{\beta}{1+\beta}E_t\hat{W}_{t+1}
+\frac{1}{1+\beta}\hat{W}_{t-1}
+\frac{\beta}{1+\beta}E_t\hat{\Pi}_{t+1}
-\frac{1+\beta\sigma_{wi}}{1+\beta}\hat{\Pi}_t
+\frac{\sigma_{wi}}{1+\beta}\hat{\Pi}_{t-1} \\
&+\frac{1}{1+\beta}
\frac{(1-\beta\sigma_w)(1-\sigma_w)}
{\sigma_w(1+\varepsilon_w\phi)}
\left[\phi\hat{L}_t-\frac{h}{1-h}\hat{C}_{t-1}
+\frac{1}{1-h}\hat{C}_t-\hat{W}_t\right]
+\varepsilon_t^w .
\end{aligned}
```

**资本、生产与定价**

- **(F5) 资本积累**：

```math
\hat{K}_{t+1}=\delta(\hat{I}_t+\varepsilon_t^x)
+(1-\delta)(\hat{K}_t+\varepsilon_t^k) .
```

- **(F6) 最优资本利用率**：

```math
\hat{Z}^k_t=\frac{\zeta}{1-\zeta}\hat{U}_t .
```

- **(F7) 投资欧拉方程**：

```math
\hat{I}_t
=\frac{1}{\xi(1+\beta)}(\hat{Q}_t+\varepsilon_t^x)
+\frac{1}{1+\beta}\hat{I}_{t-1}
+\frac{\beta}{1+\beta}E_t\hat{I}_{t+1}.
```

- **(F8) 生产函数**：

```math
\hat{Y}_t=\Theta\left[
\varepsilon_t^a+\alpha(\hat{K}_t+\varepsilon_t^k+\hat{U}_t)
+(1-\alpha)\hat{L}_t
\right].
```

- **(F9) 中间品厂商要素 FOC**：

```math
\hat{W}_t=\hat{Z}^k_t-\hat{L}_t+\hat{K}_t+\hat{U}_t .
```

- **(F10) 价格 Phillips 曲线**：

```math
\hat{\Pi}_t
=\frac{\sigma_{\pi}}{1+\beta\sigma_{\pi}}\hat{\Pi}_{t-1}
+\frac{\beta}{1+\beta\sigma_{\pi}}E_t\hat{\Pi}_{t+1}
-\frac{(1-\beta\sigma_p)(1-\sigma_p)}
{(1+\beta\sigma_{\pi})\sigma_p}
\left[\varepsilon_t^a-\alpha\hat{Z}^k_t-(1-\alpha)\hat{W}_t\right]
+\varepsilon_t^p .
```

- **(F11) 资本回报**：

```math
\hat{R}^k_t
=\frac{Z^k}{R^k}\hat{Z}^k_t
+\frac{1-\delta}{R^k}(\hat{Q}_t+\varepsilon_t^k)
-\hat{Q}_{t-1}.
```

**金融中介模块**

- **(F12) 扩张资产的收益**：

```math
\hat{V}_t
=\frac{(1-\theta)\beta}{V}(R^k-R)E_t\hat{\Lambda}_{t,t+1}
+\frac{(1-\theta)\beta}{V}\left(R^kE_t\hat{R}^k_{t+1}-R\hat{R}_t\right)
+\theta\beta X E_t(\hat{X}_{t,t+1}+\hat{V}_{t+1}+\hat{\Lambda}_{t,t+1}) .
```

- **(F13) 扩张净值的价值**：

```math
\hat{D}_t=\theta\beta Z E_t(\hat{\Lambda}_{t,t+1}+\hat{Z}_{t,t+1}+\hat{D}_{t+1}) .
```

- **(F14) 净值总增长率**：

```math
\hat{Z}_{t,t+1}
=\frac{1}{Z}\left[
\mathrm{lev}\,R^k E_t\hat{R}^k_{t+1}
+R(1-\mathrm{lev})\hat{R}_t
+(R^k-R)\mathrm{lev}\,\widehat{\mathrm{lev}}_t
\right].
```

- **(F15) 资产总增长率**：

```math
\hat{X}_{t,t+1}=E_t\widehat{\mathrm{lev}}_{t+1}+\hat{Z}_{t,t+1}-\widehat{\mathrm{lev}}_t .
```

- **(F16) 来自银行家激励约束的杠杆条件**（`needs_review`：论文表格给出同期方程，而 Rep-MMB 为保证确定性把它前移一期）：

```math
\widehat{\mathrm{lev}}_t=\hat{D}_t+\frac{V}{\lambda-V}\hat{V}_t .
```

- **(F17) 金融中介资产负债表约束**（`needs_review`：来源表格使用 $`K_{t+1}+Q_t`$；Rep-MMB 实现采用静态 `k+q` 约定）：

```math
\hat{K}_{t+1}+\hat{Q}_t=\widehat{\mathrm{lev}}_t+\hat{N}_t .
```

- **(F18) 既有金融中介净值**：

```math
\hat{N}^e_t=\hat{N}_{t-1}+\hat{Z}_{t,t+1}.
```

- **(F19) 新金融中介净值**：

```math
\hat{N}^n_t=\hat{Q}_t+\hat{K}_t .
```

- **(F20) 中介总净值**：

```math
\hat{N}_t
=\frac{N^e}{Y}\frac{Y}{N}\hat{N}^e_t
+\frac{N^n}{Y}\frac{Y}{N}\hat{N}^n_t .
```

- **(F21) 外部融资溢价/利差**：

```math
\widehat{EP}_t=E_t\hat{R}^k_{t+1}-\hat{R}_t .
```

## 4. Market Clearing & Identities

- **(F22) 资源约束**：

```math
\hat{Y}_t=\frac{C}{Y}\hat{C}_t+\frac{I}{Y}\hat{I}_t+\frac{G}{Y}\hat{G}_t+\frac{Z^kK}{Y}\hat{U}_t .
```

- **(F23) 含产出缺口和产出缺口变化项的 Taylor 规则**：

```math
\hat{R}^n_t
=\rho_i\hat{R}^n_{t-1}
+(1-\rho_i)\left[\rho_{\pi}\hat{\Pi}_t+\rho_y(\hat{Y}_t-\hat{Y}^p_t)\right]
+\rho_{\Delta y}\left[(\hat{Y}_t-\hat{Y}^p_t)-(\hat{Y}_{t-1}-\hat{Y}^p_{t-1})\right]
+\varepsilon_t^r .
```

- **(F24) Fisher 方程**：

```math
\hat{R}^n_t=\hat{R}_t+E_t\hat{\Pi}_{t+1}.
```

- **(F25) 观测方程**：

```math
\begin{bmatrix}
\Delta Y_t^o\\ \Delta C_t^o\\ \Delta I_t^o\\ \Delta W_t^o\\ L_t^o\\ \pi_t^o\\ r_t^{n,o}
\end{bmatrix}
=
\begin{bmatrix}
\gamma\\ \gamma\\ \gamma\\ \gamma\\ 0\\ \bar{\pi}\\ \bar{r}^n
\end{bmatrix}
+
\begin{bmatrix}
\hat{Y}_t-\hat{Y}_{t-1}\\
\hat{C}_t-\hat{C}_{t-1}\\
\hat{I}_t-\hat{I}_{t-1}\\
\hat{W}_t-\hat{W}_{t-1}\\
\hat{L}_t\\
\hat{\Pi}_t\\
\hat{R}^n_t
\end{bmatrix}.
```

灵活价格/工资参照经济使用同样的实际和金融模块，但排除价格/工资加成扭曲，使 $`\hat{Y}^p_t`$ 能进入政策规则。Rep-MMB 交叉检查把相应变量命名为带 `f` 后缀的变量（`yf`, `cf`, `kf`, `qf`, `nf` 等）。

## 5. Exogenous Processes

- **(F26) 技术冲击**：

```math
\varepsilon_t^a=\rho_A\varepsilon_{t-1}^a+e_t^a .
```

- **(F27) 投资专用技术冲击**：

```math
\varepsilon_t^x=\rho_X\varepsilon_{t-1}^x+e_t^x .
```

- **(F28) 政府支出冲击**：

```math
\hat{G}_t=\rho_G\hat{G}_{t-1}+e_t^g .
```

- **(F29) 货币政策冲击**：

```math
\varepsilon_t^r=\rho_{ri}\varepsilon_{t-1}^r+e_t^r .
```

- **(F30) 价格加成冲击**：

```math
\varepsilon_t^p=\rho_P\varepsilon_{t-1}^p+e_t^p .
```

- **(F31) 工资加成冲击**：

```math
\varepsilon_t^w=\rho_W\varepsilon_{t-1}^w+e_t^w .
```

- **(F32) 资本质量冲击**：

```math
\varepsilon_t^k=\rho_k\varepsilon_{t-1}^k+e_t^k .
```

Rep-MMB 实现对若干创新项使用负号。本档案保留上述论文侧 AR(1) 符号约定，并把符号映射列为实现交叉检查事项。

## 6. Steady-State Solution

由于模型是线性化形式，带帽内生变量的稳态为零：

```math
\hat{C}=\hat{I}=\hat{Y}=\hat{K}=\hat{Q}=\hat{L}=\hat{W}=\hat{\Pi}=\hat{R}=\hat{R}^n=\hat{N}=\widehat{EP}=0 .
```

来源给出的校准目标和稳态定义为：

```math
\beta=0.99,\quad \alpha=0.33,\quad \delta=0.025,\quad G/Y=0.20,\quad
\varepsilon=\varepsilon_w=6 .
```

对于 SWGK 金融模块，Villa (2016) 校准为：

```math
\theta=0.972,\quad \chi=0.001,\quad \lambda=0.515,\quad \mathrm{lev}=4,
```

并以年化 150 个基点利差为目标。Rep-MMB 美国实现交叉检查使用的后验/校准值包括 $`\theta=0.9715`$, $`\lambda=0.5152`$, $`\chi=0.001`$, $`RK=1.013860066271978`$, $`h=0.44`$, $`\xi=4.27`$, $`\sigma_p=0.89`$, $`\sigma_w=0.84`$, $`\rho_r=0.85`$, $`\rho_{\pi}=1.89`$, $`\rho_y=0.09`$, $`\rho_{\Delta y}=0.20`$, trend $`=0.32`$, 以及稳态通胀 `picbar = 0.64`。

`needs_review`：主文 Markdown 未打印完整非线性稳态推导，本次也未重构。实现在线性模型块之前定义了转换后的稳态常数（`R`, `ZK`, `W`, `K_L`, `Y_K`, `I_Y`, `C_Y`, `LEV`, `Z`, `X`, `V`）；如果以后将本条目推进为可运行复现，应复核这些定义。

## 7. Timing & Form Conventions

- **形式**：`model(linear)`；带帽变量表示相对稳态的偏离。中英文推导保留相同方程编号。
- **资本时序**：论文说明期末 $`t`$ 购买的资本为 $`K_{t+1}`$，在 $`t+1`$ 使用。Rep-MMB 实现备注说方程 19b 从前瞻资本改为静态 `k` 约定。
- **资本回报时序**：Rep-MMB 备注 1 表明方程 13 向后移动一期，与 Gertler-Karadi 记号一致。
- **杠杆时序**：Rep-MMB 备注 2 表明方程 18b 为保证确定性向前移动一期；原同期方程在实现中保留为注释。
- **灵活参照模型**：实现中带 `f` 后缀的变量表示用于政策规则缺口的灵活价格/工资对应经济。
- **运行时验证**：未执行。此次档案任务没有运行任何 Dynare 命令。

## 8. Variable & Parameter Reference Table

### 内生变量

| ASCII name | 数学符号 | 含义 | 主要方程 |
|---|---|---|---|
| `y` | $`\hat{Y}_t`$ | 产出 | (F8), (F22) |
| `i` | $`\hat{I}_t`$ | 投资 | (F7), (F22) |
| `c` | $`\hat{C}_t`$ | 消费 | (F3), (F22) |
| `l` | $`\hat{L}_t`$ | 劳动 | (F4), (F8), (F9) |
| `w` | $`\hat{W}_t`$ | 实际工资 | (F4), (F9) |
| `pi` | $`\hat{\Pi}_t`$ | 通胀 | (F10), (F24) |
| `r` | $`\hat{R}_t`$ | 实际利率 | (F3), (F24) |
| `rn` | $`\hat{R}^n_t`$ | 名义利率 | (F23), (F24) |
| `k` | $`\hat{K}_t`$ | 资本 | (F5), (F17) |
| `u` | $`\hat{U}_t`$ | 利用率 | (F6), (F8), (F22) |
| `zk` | $`\hat{Z}^k_t`$ | 边际产出/租金回报组成 | (F6), (F9), (F11) |
| `q` | $`\hat{Q}_t`$ | 资本价格 | (F7), (F11), (F17) |
| `rk` | $`\hat{R}^k_t`$ | 资本回报 | (F11), (F21) |
| `mu` | $`\hat{\mu}_t`$ | 边际效用 | (F1), (F2) |
| `Lambda` | $`\hat{\Lambda}_{t,t+1}`$ | 随机贴现因子 | (F2), (F12), (F13) |
| `v` | $`\hat{V}_t`$ | 扩张中介资产的价值 | (F12), (F16) |
| `d` | $`\hat{D}_t`$ | 扩张净值的价值 | (F13), (F16) |
| `z` | $`\hat{Z}_{t,t+1}`$ | 净值增长 | (F14), (F18) |
| `x` | $`\hat{X}_{t,t+1}`$ | 资产增长 | (F15), (F12) |
| `lev` | $`\widehat{\mathrm{lev}}_t`$ | 杠杆 | (F15), (F16), (F17) |
| `n` | $`\hat{N}_t`$ | FI 总净值 | (F20) |
| `ne` | $`\hat{N}^e_t`$ | 既有 FI 净值 | (F18), (F20) |
| `nn` | $`\hat{N}^n_t`$ | 新 FI 净值 | (F19), (F20) |
| `ext_pr` | $`\widehat{EP}_t`$ | 外部融资溢价/利差 | (F21) |
| `yf`, `cf`, `if`, `kf`, `qf`, `nf`, ... | 上标 $`p`$ 或灵活对应变量 | 灵活价格/工资参照变量 | 类似灵活模块 |
| `dy`, `dc`, `dfi`, `dw`, `hobsgm`, `piobs`, `robs` | 观测映射 | 测量变量 | (F25) |

### 外生创新

| ASCII name | 含义 | 过程 |
|---|---|---|
| `e_a` | 技术创新 | (F26) |
| `e_x` | 投资专用技术创新 | (F27) |
| `e_g` | 政府支出创新 | (F28) |
| `e_r` | 货币政策创新 | (F29) |
| `e_p` | 价格加成创新 | (F30) |
| `e_w` | 工资加成创新 | (F31) |
| `e_k` | 资本质量创新 | (F32) |

### 参数

| ASCII name | 含义 | 来源值或角色 |
|---|---|---|
| `beta` | 贴现因子 | 0.99 |
| `alpha` | 资本份额 | 0.33 |
| `delta` | 折旧 | 0.025 |
| `epsilon`, `epsilon_w` | 商品/劳动替代弹性 | 设定为对应 1.20 加成 |
| `G_Y` | 政府支出份额 | 0.20 |
| `h` | 习惯 | 美国 GK 后验估计 |
| `phi` | Frisch 弹性倒数 | 美国 GK 后验估计 |
| `lambda` | 可转移资产比例 | 基准 0.515；Rep-MMB 美国实现为 0.5152 |
| `theta` | 银行家存活概率 | 基准 0.972；Rep-MMB 美国实现为 0.9715 |
| `chi` | 新银行家资产转移比例 | 0.001 |
| `zeta` | 资本利用率弹性参数 | 后验估计 |
| `ksi` | 投资调整成本 | 后验估计 |
| `sig_p`, `sig_pi` | 价格黏性与指数化 | 后验估计 |
| `sig_w`, `sig_wi` | 工资黏性与指数化 | 后验估计 |
| `rho_r`, `rho_PI`, `rho_Y`, `rho_DY` | Taylor 规则参数 | 后验估计 |
| `rho_A`, `rho_X`, `rho_G`, `rho_ri`, `rho_P`, `rho_W`, `rho_k` | 冲击持续性参数 | (F26)-(F32) |
| `RK`, `picbar`, `trend`, `constelab` | 稳态/测量常数 | Rep-MMB 实现交叉检查 |
