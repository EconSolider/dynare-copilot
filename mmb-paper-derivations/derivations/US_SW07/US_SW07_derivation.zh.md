# US_SW07 -- 推导（最优化问题 + 一阶条件）

> 本推导用于私有模型存档库的源材料整理，暂不用于直接生成 runnable Dynare `.mod`。当前状态为 `needs_review`：公式来自已发表正文 MinerU Markdown 与 appendix normalization，`US_SW07_rep.mod` 仅作为实现交叉检查。

## 1. 模型概述

- 模型：Smets and Wouters (2007), "Shocks and Frictions in US Business Cycles: A Bayesian DSGE Approach"。
- MMB 代码：`US_SW07`。
- 论文信息：Frank Smets and Rafael Wouters, 2007, *American Economic Review* 97(3), 586-606, DOI `10.1257/aer.97.3.586`。
- 形式：估计用的 log-linear DSGE。论文正文第 I 节给出围绕 balanced-growth steady state 的线性化系统；online appendix 给出非线性源层最优化问题、稳态和线性化目标方程。
- 主体：最终品生产者、差异化中间品企业、代表性家庭、劳动 union、政府/央行。
- 主要摩擦：外部习惯、投资调整成本、可变资本利用、固定成本、Kimball goods/labor aggregator、Calvo 价格和工资黏性、价格和工资指数化。
- 冲击：技术、风险溢价、投资效率、政府支出、货币政策、价格 markup、工资 markup，共七类结构冲击。
- 观测变量：产出增长、消费增长、投资增长、实际工资增长、工时、通胀、联邦基金利率。

## 2. 主体的最优化问题

### 2.1 最终品生产者

最终品生产者使用 Kimball aggregator 聚合差异化中间品。给定中间品价格集合，选择中间品需求以最小化生产给定最终品的成本。在线 appendix 的源层记录包含最终品需求 FOC 和由 price-markup shock 驱动的需求/价格指数关系。

价格 markup shock 的源层过程记为：

```math
\log \varepsilon^p_t
= (1-\rho_p)\log \varepsilon^p
  + \rho_p \log \varepsilon^p_{t-1}
  - \mu_p \eta^p_{t-1}
  + \eta^p_t .
```

### 2.2 中间品企业

中间品企业用资本服务和劳动生产差异化中间品，并面对固定成本：

```math
Y_t(i)=\varepsilon^a_t \left(K^s_t(i)\right)^\alpha
\left(\gamma_t L_t(i)\right)^{1-\alpha}
- \gamma_t \Phi .
```

技术冲击为：

```math
\log \varepsilon^a_t
= (1-\rho_a)\log \varepsilon^a
  + \rho_a \log \varepsilon^a_{t-1}
  + \eta^a_t .
```

企业的静态成本最小化选择 $`K^s_t(i)`$ 与 $`L_t(i)`$。源层 FOC 给出工资、资本租金和边际成本之间的关系：

```math
W_t
= MC_t(i)(1-\alpha)\varepsilon^a_t
\left(K^s_t(i)\right)^\alpha
\left(\gamma_t L_t(i)\right)^{-\alpha}\gamma_t^{1-\alpha},
```

```math
R^k_t
= MC_t(i)\alpha\varepsilon^a_t
\left(K^s_t(i)\right)^{\alpha-1}
\left(\gamma_t L_t(i)\right)^{1-\alpha}.
```

可以整理出共同资本劳动比：

```math
K^s_t
= \frac{\alpha W_t L_t}{(1-\alpha)R^k_t}.
```

价格设定遵循 Calvo 机制。不能重设价格的企业按过去通胀和稳态通胀指数化；能重设价格的企业选择 $`\widetilde P_t(i)`$ 最大化未来仍沿用该价格时的贴现利润。Kimball 曲率项进入 reset-price FOC；该 FOC 在本草稿中保留为 `needs_review`，见 `extraction_notes.md`。

### 2.3 代表性家庭

家庭选择消费、劳动、债券、投资、资本和资本利用率，具有外部习惯。源层预算约束为：

```math
\begin{aligned}
C_t(j)+I_t(j)+\frac{B_t(j)}{\varepsilon^b_t R_t P_t}+T_t
&= \frac{B_{t-1}(j)}{P_t}
 + \frac{W^h_t(j)L_t(j)}{P_t} \\
&\quad + \frac{R^k_t Z_t(j)K_{t-1}(j)}{P_t}
 - a(Z_t(j))K_{t-1}(j)
 + \frac{Div_t}{P_t}.
\end{aligned}
```

风险溢价冲击和投资效率冲击分别满足：

```math
\log \varepsilon^b_t=\rho_b\log \varepsilon^b_{t-1}+\eta^b_t,
```

```math
\log \varepsilon^i_t=\rho_i\log \varepsilon^i_{t-1}+\eta^i_t.
```

资本服务为：

```math
K^s_t(j)=Z_t(j)K_{t-1}(j).
```

家庭的源层 FOC 包括边际效用、劳动供给、债券 Euler、投资调整成本、资本 Euler 和资本利用率条件。本草稿在第 3 节使用论文正文的估计用 log-linear 系统；源层非线性 FOC 的完整 TeX 仍需复核。

### 2.4 劳动 union

劳动 union 聚合差异化劳动并设置名义工资。源层包含劳动需求、工资指数、Calvo 工资重设 FOC 和 wage-markup shock：

```math
L_t=\left[\int_0^1 L_t(l)^{1/(1+\lambda^w_t)}dl\right]^{1+\lambda^w_t},
```

```math
L_t(l)=\left(\frac{W_t(l)}{W_t}\right)^{-(1+\lambda^w_t)/\lambda^w_t}L_t,
```

```math
W_t=\left[\int_0^1 W_t(l)^{-1/\lambda^w_t}dl\right]^{-\lambda^w_t}.
```

工资 markup shock 记为：

```math
\log \lambda^w_t
= (1-\rho_w)\log \lambda^w
  + \rho_w\log \lambda^w_{t-1}
  - \mu_w \eta^w_{t-1}
  + \eta^w_t .
```

Calvo wage reset FOC 在 appendix normalization 中已有库存，但 TeX 仍标记为 `needs_review`。

## 3. 一阶条件（FOC）

本节记录论文正文中用于估计的 log-linear 均衡系统。变量均为相对 balanced-growth steady state 的 log deviation 或线性化变量；星号/参数下标表示稳态对象。

**(F1) 资源约束**

```math
y_t=c_y c_t+i_y i_t+z_y z_t+\varepsilon^g_t .
```

其中 $`c_y`$、$`i_y`$、$`z_y`$ 分别为消费、投资和资本利用成本的稳态产出份额。

**(F2) 消费 Euler 方程**

```math
c_t=c_1 c_{t-1}+(1-c_1)E_t c_{t+1}
  +c_2(l_t-E_tl_{t+1})
  -c_3(r_t-E_t\pi_{t+1}+\varepsilon^b_t).
```

系数定义为：

```math
c_1=\frac{\lambda/\gamma}{1+\lambda/\gamma},\qquad
c_2=\frac{(\sigma_c-1)(W^h_\astL_\ast/C_\ast)}{\sigma_c(1+\lambda/\gamma)},\qquad
c_3=\frac{1-\lambda/\gamma}{\sigma_c(1+\lambda/\gamma)}.
```

**(F3) 投资 Euler 方程**

```math
i_t=i_1 i_{t-1}+(1-i_1)E_t i_{t+1}+i_2 q_t+\varepsilon^i_t.
```

其中：

```math
i_1=\frac{1}{1+\beta\gamma^{1-\sigma_c}},\qquad
i_2=\frac{1}{(1+\beta\gamma^{1-\sigma_c})\gamma^2\varphi}.
```

**(F4) 资本价值套利方程**

```math
q_t=q_1E_tq_{t+1}+(1-q_1)E_t r^k_{t+1}
  -(r_t-E_t\pi_{t+1}+\varepsilon^b_t).
```

其中：

```math
q_1=\beta\gamma^{-\sigma_c}(1-\delta)
=\frac{1-\delta}{R^k_\ast+1-\delta}.
```

**(F5) 总量生产函数**

```math
y_t=\phi_p\left(\alpha k^s_t+(1-\alpha)l_t+\varepsilon^a_t\right).
```

**(F6) 资本服务**

```math
k^s_t=k_{t-1}+z_t.
```

**(F7) 资本利用率**

```math
z_t=z_1 r^k_t,\qquad z_1=\frac{1-\psi}{\psi}.
```

**(F8) 资本积累**

```math
k_t=k_1k_{t-1}+(1-k_1)i_t+k_2\varepsilon^i_t,
```

其中：

```math
k_1=\frac{1-\delta}{\gamma},\qquad
k_2=\left(1-\frac{1-\delta}{\gamma}\right)(1+\beta\gamma^{1-\sigma_c})\gamma^2\varphi.
```

**(F9) 价格 markup / 边际成本关系**

```math
\mu^p_t=mpl_t-w_t=\alpha(k^s_t-l_t)+\varepsilon^a_t-w_t.
```

等价地，real marginal cost 的 log deviation 可写成：

```math
mc_t=(1-\alpha)w_t+\alpha r^k_t-\varepsilon^a_t.
```

**(F10) 价格 Phillips 曲线**

```math
\pi_t=\pi_1\pi_{t-1}+\pi_2E_t\pi_{t+1}-\pi_3\mu^p_t+\varepsilon^p_t.
```

其中 $`\pi_1`$、$`\pi_2`$、$`\pi_3`$ 由价格指数化、折现、Calvo 价格黏性和 Kimball goods-market 曲率决定。本草稿未展开 $`\pi_3`$ 的 Kimball 曲率项；该项需要源级 TeX 复核。

**(F11) 资本租金**

```math
r^k_t=-(k_t-l_t)+w_t.
```

**(F12) 工资 markup / MRS**

```math
\mu^w_t=w_t-mrs_t,
```

```math
mrs_t=\sigma_l l_t+\frac{1}{1-\lambda/\gamma}
\left(c_t-\frac{\lambda}{\gamma}c_{t-1}\right).
```

**(F13) 工资 Phillips 曲线**

```math
\begin{aligned}
w_t
&=w_1w_{t-1}+(1-w_1)(E_tw_{t+1}+E_t\pi_{t+1})
  -w_2\pi_t+w_3\pi_{t-1} \\
&\quad -w_4\mu^w_t+\varepsilon^w_t .
\end{aligned}
```

其中 $`w_1`$、$`w_2`$、$`w_3`$、$`w_4`$ 由折现、工资指数化、Calvo 工资黏性和 Kimball labor-market 曲率决定。本式在 `full.md` 中有 OCR 缺行；当前公式以 appendix normalization 和 implementation cross-check 补齐结构，仍需人工 TeX 复核。

**(F14) 货币政策规则**

```math
r_t=\rho r_{t-1}
 +(1-\rho)\left[r_\pi\pi_t+r_y(y_t-y^p_t)\right]
 +r_{\Delta y}\left[(y_t-y^p_t)-(y_{t-1}-y^p_{t-1})\right]
 +\varepsilon^r_t .
```

这里 $`y^p_t`$ 是无价格/工资 markup shock、价格工资灵活时的 potential output。

## 4. 市场出清与总量恒等式

**(F15) 资源约束的源层对应式**

```math
C_t+I_t+G_t+a(u_t)K_{t-1}=Y_t.
```

这对应 log-linear 系统中的 (F1)。资本利用成本 $`a(u_t)K_{t-1}`$ 在线性系统中映射为 $`z_yz_t`$。

**(F16) 政府预算**

```math
P_tG_t+B_{t-1}=T_t+\frac{B_t}{R_t}.
```

在估计用闭合系统中，政府支出以外生过程进入资源约束；债务和税收不作为主要状态进入 `US_SW07_rep.mod`。

**(F17) 观测方程**

```math
\begin{bmatrix}
dlGDP_t\\
dlCONS_t\\
dlINV_t\\
dlWAG_t\\
lHOURS_t\\
dlP_t\\
FEDFUNDS_t
\end{bmatrix}
=
\begin{bmatrix}
\bar\gamma\\
\bar\gamma\\
\bar\gamma\\
\bar\gamma\\
\bar l\\
\bar\pi\\
\bar r
\end{bmatrix}
+
\begin{bmatrix}
y_t-y_{t-1}\\
c_t-c_{t-1}\\
i_t-i_{t-1}\\
w_t-w_{t-1}\\
l_t\\
\pi_t\\
r_t
\end{bmatrix}.
```

**(F18) Flexible-economy potential-output block**

论文将 output gap 定义为实际产出相对 potential output 的偏离。`US_SW07_rep.mod` 的实现交叉检查显示 flexible-economy counterparts：`yf, cf, invef, labf, wf, rkf, kf, pkf, zcapf, rrf, kpf`。本草稿暂不把这些 `.mod` 方程提升为 source-stated equations；后续需与 appendix 中 natural output level 和 flexible-price/wage section 对齐。

## 5. 外生过程

**(F19) 技术冲击**

```math
\varepsilon^a_t=\rho_a\varepsilon^a_{t-1}+\eta^a_t.
```

**(F20) 风险溢价冲击**

```math
\varepsilon^b_t=\rho_b\varepsilon^b_{t-1}+\eta^b_t.
```

**(F21) 投资效率冲击**

```math
\varepsilon^i_t=\rho_i\varepsilon^i_{t-1}+\eta^i_t.
```

**(F22) 政府支出冲击**

```math
\varepsilon^g_t=\rho_g\varepsilon^g_{t-1}+\eta^g_t+\rho_{ga}\eta^a_t.
```

**(F23) 货币政策冲击**

```math
\varepsilon^r_t=\rho_r\varepsilon^r_{t-1}+\eta^r_t.
```

**(F24) 价格 markup shock**

```math
\varepsilon^p_t=\rho_p\varepsilon^p_{t-1}+\eta^p_t-\mu_p\eta^p_{t-1}.
```

**(F25) 工资 markup shock**

```math
\varepsilon^w_t=\rho_w\varepsilon^w_{t-1}+\eta^w_t-\mu_w\eta^w_{t-1}.
```

Implementation cross-check: `US_SW07_rep.mod` maps these innovations to `ea`, `eb`, `eqs`, `eg`, `em`, `epinf`, and `ew`, with MA auxiliaries `epinfma` and `ewma`.

## 6. 稳态求解

由于估计系统是 log-linear，进入第 3-5 节的主要模型变量在 deterministic steady state 下为零：

```math
y=c=i=q=k^s=k=z=r^k=\mu^p=\pi=\mu^w=w=l=r=0,
```

并且所有创新的稳态为零。

底层 balanced-growth steady state 仍需要以下源层关系支撑参数反解：

```math
k=\frac{\alpha}{1-\alpha}\frac{w}{r^k}L,
```

```math
R=\frac{\gamma^{\sigma_c}}{\beta},
```

```math
i=\left(1-\frac{1-\delta}{\gamma}\right)k,
```

```math
1=\beta\gamma^{-\sigma_c}(r^k+1-\delta),
```

```math
y=Zk^\alpha L^{1-\alpha}-\Phi,
```

```math
\frac{c}{y}+\frac{i}{y}+g=1.
```

`US_SW07_rep.mod` 的参数初始化进一步反解：

```math
\bar R=\frac{\bar\Pi}{\beta\gamma^{-\sigma_c}},\qquad
R^k=\beta^{-1}\gamma^{\sigma_c}-(1-\delta),
```

以及消费、投资、政府支出和资本收入份额。当前存档不把这些实现细节视为 source-stated steady-state proof；后续需逐项对照 appendix steady-state section。

## 7. 时序与形式约定

- 模型形式：线性化 `model(linear)`，围绕 balanced-growth steady state。
- 资本时序：新安装资本滞后一季进入生产，$`k^s_t=k_{t-1}+z_t`$。
- 投资调整成本：依赖投资增长或投资比率，产生滞后/前瞻投资动态。
- 价格设定：Calvo 价格黏性；未重设价格按过去通胀与稳态通胀指数化。
- 工资设定：Calvo 工资黏性；未重设工资按过去通胀、稳态通胀和趋势增长指数化。
- Output gap：相对 flexible-price/wage potential output，而不是统计滤波产出缺口。
- 符号约定：正文使用论文常见符号；变量表中的 ASCII 名称对齐 `US_SW07_rep.mod`，但 `.mod` 仅作为 cross-check。

## 8. 变量与参数对照表

| 类别 | 符号 / ASCII | 含义 | 主要方程 |
| --- | --- | --- | --- |
| 内生 | `y` / $`y_t`$ | 产出 | (F1), (F5), (F14), (F17) |
| 内生 | `c` / $`c_t`$ | 消费 | (F1), (F2), (F12), (F17) |
| 内生 | `inve` / $`i_t`$ | 投资 | (F1), (F3), (F8), (F17) |
| 内生 | `pk` / $`q_t`$ | 资本价值 / Tobin's Q | (F3), (F4) |
| 内生 | `k` / $`k^s_t`$ | 当期资本服务 | (F5), (F6), (F11) |
| 内生 | `kp` / $`k_t`$ | 安装资本存量 | (F8) |
| 内生 | `zcap` / $`z_t`$ | 资本利用率 | (F1), (F6), (F7) |
| 内生 | `rk` / $`r^k_t`$ | 资本租金 | (F4), (F7), (F11) |
| 内生 | `mc` / $`mc_t`$ | 实际边际成本 | (F9), (F10) |
| 内生 | `pinf` / $`\pi_t`$ | 通胀 | (F10), (F13), (F14), (F17) |
| 内生 | `w` / $`w_t`$ | 实际工资 | (F11), (F12), (F13), (F17) |
| 内生 | `lab` / $`l_t`$ | 工时 | (F2), (F5), (F9), (F12), (F17) |
| 内生 | `r` / $`r_t`$ | 名义政策利率 deviation | (F2), (F4), (F14), (F17) |
| 内生 | `a` / $`\varepsilon^a_t`$ | 技术状态 | (F5), (F9), (F19) |
| 内生 | `b` / $`\varepsilon^b_t`$ | 风险溢价状态 | (F2), (F4), (F20) |
| 内生 | `g` / $`\varepsilon^g_t`$ | 政府支出状态 | (F1), (F22) |
| 内生 | `qs` / $`\varepsilon^i_t`$ | 投资效率状态 | (F3), (F8), (F21) |
| 内生 | `ms` / $`\varepsilon^r_t`$ | 货币政策状态 | (F14), (F23) |
| 内生 | `spinf` / $`\varepsilon^p_t`$ | 价格 markup 状态 | (F10), (F24) |
| 内生 | `sw` / $`\varepsilon^w_t`$ | 工资 markup 状态 | (F13), (F25) |
| 内生 | `dy`, `dc`, `dinve`, `dw`, `labobs`, `pinfobs`, `robs` | 观测方程变量 | (F17) |
| 外生 | `ea` | 技术创新 | (F19) |
| 外生 | `eb` | 风险溢价创新 | (F20) |
| 外生 | `eqs` | 投资效率创新 | (F21) |
| 外生 | `eg` | 政府支出创新 | (F22) |
| 外生 | `em` | 货币政策创新 | (F23) |
| 外生 | `epinf` | 价格 markup 创新 | (F24) |
| 外生 | `ew` | 工资 markup 创新 | (F25) |
| 参数 | `cbeta`, $`\beta`$ | 贴现因子 | (F2), (F4), (F10), (F13) |
| 参数 | `cgamma`, $`\gamma`$ | 趋势增长 | (F2), (F3), (F8), §6 |
| 参数 | `csigma`, $`\sigma_c`$ | 消费相对风险规避 / IES 参数 | (F2), (F12), §6 |
| 参数 | `chabb`, $`\lambda`$ or $`h`$ | 外部习惯 | (F2), (F12) |
| 参数 | `calfa`, $`\alpha`$ | 资本份额 | (F5), (F9), (F11), §6 |
| 参数 | `ctou`, $`\delta`$ | 折旧率 | (F8), §6 |
| 参数 | `csadjcost`, $`\varphi`$ | 投资调整成本曲率 | (F3), (F8) |
| 参数 | `czcap`, $`\psi`$ | 资本利用调整成本参数 | (F7) |
| 参数 | `cprobp`, $`\xi_p`$ | Calvo 价格不调整概率 | (F10) |
| 参数 | `cindp`, $`\iota_p`$ | 价格指数化 | (F10) |
| 参数 | `cprobw`, $`\xi_w`$ | Calvo 工资不调整概率 | (F13) |
| 参数 | `cindw`, $`\iota_w`$ | 工资指数化 | (F13) |
| 参数 | `crr`, $`\rho`$ | 利率平滑 | (F14) |
| 参数 | `crpi`, $`r_\pi`$ | 对通胀反应 | (F14) |
| 参数 | `cry`, $`r_y`$ | 对 output gap 反应 | (F14) |
| 参数 | `crdy`, $`r_{\Delta y}`$ | 对 output-gap change 反应 | (F14) |
| 参数 | `crhoa`, `crhob`, `crhoqs`, `crhog`, `crhoms`, `crhopinf`, `crhow` | 冲击持久性 | (F19)-(F25) |
| 参数 | `cmap`, `cmaw` | 价格/工资 markup MA 系数 | (F24), (F25) |

### 自检状态

- 八节结构：完成。
- 模型形式：已声明为 log-linear estimated DSGE。
- 时序约定：资本滞后一季进入生产已记录。
- 来源 provenance：见 `source_manifest.json`。
- 公式质量：`needs_review`，尤其是 Kimball/Calvo reset-price 与 wage reset FOC。
- 运行验证：未做，且本阶段不做。
