# US_BKM12 -- 推导（最优化问题 + 一阶条件）

> 本推导用于私有模型档案中的来源化整理，尚不意图直接生成可运行的 Dynare `.mod` 文件。当前状态：`needs_review`。原论文是围绕重置价格通胀的应用，核心模型是经过修改和重新估计的 Smets-Wouters 模型；本地 `US_BKM12_rep.mod` 只作为 implementation_cross_check 使用。

## 1. Model Overview

- 模型：Bils, Klenow, and Malin (2012), "Reset Price Inflation and the Impact of Monetary Policy Shocks"。
- MMB 代码：`US_BKM12`。
- 论文元数据：Mark Bils, Peter J. Klenow, and Benjamin A. Malin, 2012, *American Economic Review* 102(6), 2798-2825, DOI `10.1257/aer.102.6.2798`。
- 形式：重新估计的双月频 Smets-Wouters DSGE，采用 log-linear `model(linear)`。论文说明，在评估重置价格通胀时移除价格指数化，因为 CPI 微观数据并不显示指数化所要求的小幅名义价格变化。
- 频率与样本：双月频模型，针对现代 1989/1990-2009 样本估计，并与 CPI Research Database 的重置价格统计量比较。
- 主体：最终品聚合器、差异化中间品厂商、代表性家庭、工资设定型劳动联盟、财政当局和中央银行。
- 主要摩擦：外部习惯、投资调整成本、可变资本利用率、Calvo 价格和工资、Kimball 商品/劳动曲率、工资黏性、货币政策平滑，以及七个结构冲击。
- 重置价格层：论文从调价商品和 Calvo 时序构造经验与模型一致的重置通胀 $\pi^{\ast}_t$；该测度对象是本档案条目的核心，即使它不是标准 DSGE 优化条件。

## 2. Optimization Problems

### 2.1 最终品聚合器

最终品部门聚合差异化中间品。战略互补性通过 Kimball 型需求曲率进入，因此价格 Phillips 曲线比简单 Dixit-Stiglitz/Calvo 模型更平坦。论文将模型描述为含 Kimball kink 的 Smets-Wouters 环境，并强调移除该 kink 会提高短期 Phillips 曲线斜率。论文正文没有打印精确的来源层 Kimball 聚合器，仍标记为 `needs_review`。

### 2.2 中间品厂商

中间品厂商租用资本服务和劳动并生产差异化商品：

$$
y_t=\phi_p\left[\alpha k_t+(1-\alpha)l_t+a_t\right].
$$

在线性化形式下，边际成本结合要素价格与技术：

$$
mc_t=\alpha r^k_t+(1-\alpha)w_t-a_t.
$$

价格设定遵循 Calvo 时序。对于用于重置通胀主比较的一部门模型，论文施加 31.2 percent 的双月调价频率，并移除非调价价格的价格指数化。移除 markup shocks 时，implementation_cross_check 在模拟中把价格 markup 创新的方差设为零，但该状态仍保留在线性系统中以维持覆盖。

### 2.3 代表性家庭

家庭在具有外部习惯的 Smets-Wouters 环境中选择消费、投资、债券、资本、资本利用率和劳动供给。论文正文没有完整打印来源侧非线性问题；因此档案记录线性化均衡条件，并把非线性 FOC 推导标记为 `needs_review`。

线性化消费 Euler 方程使用习惯调整后的消费、预期消费、预期劳动、事前实际政策利率，以及随机贴现因子冲击：

$$
c_t=c_1c_{t-1}+(1-c_1)E_tc_{t+1}
 +c_2(l_t-E_tl_{t+1})
 -c_3(r_t-E_t\pi_{t+1})+b_t.
$$

投资调整成本生成带有滞后项、前瞻项、Tobin's $q$ 和投资专用技术冲击的投资方程。

### 2.4 劳动联盟

工资设定遵循 Calvo 时序，包含工资 markup shock 和 Kimball 劳动市场曲率。论文的模型比较部分将工资黏性和工资指数化识别为重要的战略互补性。`US_BKM12_rep.mod` cross-check 包含工资指数化 (`cindw`) 和工资 markup 过程 (`sw`)；价格指数化在重置通胀变体中应被移除（implementation 中出现 `cindp=0.671`，与论文侧重置价格练习需要核对；此差异标记为 `needs_review`）。

## 3. First-Order Conditions

以下方程记录档案草稿使用的线性均衡系统。变量是相对于平衡增长稳态的偏离。由于政策规则响应相对于弹性价格产出的产出缺口，因此纳入弹性经济块。

**(F1) 弹性经济要素价格关系**

$$
a_t=\alpha r^k_{f,t}+(1-\alpha)w_{f,t}.
$$

**(F2) 弹性资本利用率**

$$
z_{f,t}=\frac{1-c_z}{c_z}r^k_{f,t}.
$$

**(F3) 弹性资本租金条件**

$$
r^k_{f,t}=w_{f,t}+l_{f,t}-k_{f,t}.
$$

**(F4) 弹性资本服务**

$$
k_{f,t}=kp_{f,t-1}+z_{f,t}.
$$

**(F5) 弹性投资方程**

$$
i_{f,t}=\frac{1}{1+\bar\beta\gamma}\left(i_{f,t-1}+\bar\beta\gamma E_ti_{f,t+1}
+\frac{1}{\gamma^2\varphi}q_{f,t}\right)+q^s_t.
$$

**(F6) 弹性资本价值**

$$
q_{f,t}=-rr_{f,t}+b_t\frac{\sigma_c(1+h/\gamma)}{1-h/\gamma}
+\frac{r^k_\ast}{r^k_\ast+1-\delta}E_tr^k_{f,t+1}
+\frac{1-\delta}{r^k_\ast+1-\delta}E_tq_{f,t+1}.
$$

**(F7) 弹性消费 Euler 方程**

$$
c_{f,t}=\frac{h/\gamma}{1+h/\gamma}c_{f,t-1}
+\frac{1}{1+h/\gamma}E_tc_{f,t+1}
+\frac{(\sigma_c-1)c_{whlc}}{\sigma_c(1+h/\gamma)}(l_{f,t}-E_tl_{f,t+1})
-\frac{1-h/\gamma}{\sigma_c(1+h/\gamma)}rr_{f,t}+b_t.
$$

**(F8) 弹性资源约束**

$$
y_{f,t}=c_yc_{f,t}+i_yi_{f,t}+g_t+r^k_\astk_yz_{f,t}.
$$

**(F9) 弹性生产函数**

$$
y_{f,t}=c_{fc}\left(\alpha k_{f,t}+(1-\alpha)l_{f,t}+a_t\right).
$$

**(F10) 弹性工资/MRS 条件**

$$
w_{f,t}=\sigma_l l_{f,t}+\frac{1}{1-h/\gamma}c_{f,t}
-\frac{h/\gamma}{1-h/\gamma}c_{f,t-1}.
$$

**(F11) 弹性装配资本法则**

$$
kp_{f,t}=(1-\bar i_k)kp_{f,t-1}+\bar i_k i_{f,t}+\bar i_k\gamma^2\varphi q^s_t.
$$

**(F12) 黏性经济边际成本**

$$
mc_t=\alpha r^k_t+(1-\alpha)w_t-a_t.
$$

**(F13) 黏性资本利用率**

$$
z_t=\frac{1-c_z}{c_z}r^k_t.
$$

**(F14) 黏性资本租金条件**

$$
r^k_t=w_t+l_t-k_t.
$$

**(F15) 黏性资本服务**

$$
k_t=kp_{t-1}+z_t.
$$

**(F16) 黏性投资方程**

$$
i_t=\frac{1}{1+\bar\beta\gamma}\left(i_{t-1}+\bar\beta\gamma E_ti_{t+1}
+\frac{1}{\gamma^2\varphi}q_t\right)+q^s_t.
$$

**(F17) 黏性资本价值**

$$
q_t=-r_t+E_t\pi_{t+1}+b_t\frac{\sigma_c(1+h/\gamma)}{1-h/\gamma}
+\frac{r^k_\ast}{r^k_\ast+1-\delta}E_tr^k_{t+1}
+\frac{1-\delta}{r^k_\ast+1-\delta}E_tq_{t+1}.
$$

**(F18) 黏性消费 Euler 方程**

$$
c_t=\frac{h/\gamma}{1+h/\gamma}c_{t-1}
+\frac{1}{1+h/\gamma}E_tc_{t+1}
+\frac{(\sigma_c-1)c_{whlc}}{\sigma_c(1+h/\gamma)}(l_t-E_tl_{t+1})
-\frac{1-h/\gamma}{\sigma_c(1+h/\gamma)}(r_t-E_t\pi_{t+1})+b_t.
$$

**(F19) 黏性资源约束**

$$
y_t=c_yc_t+i_yi_t+g_t+r^k_\astk_yz_t.
$$

**(F20) 黏性生产函数**

$$
y_t=c_{fc}\left(\alpha k_t+(1-\alpha)l_t+a_t\right).
$$

**(F21) 价格 Phillips 曲线**

$$
\pi_t=\frac{1}{1+\bar\beta\gamma\iota_p}
\left(\bar\beta\gamma E_t\pi_{t+1}+\iota_p\pi_{t-1}
+\kappa_p mc_t\right)+s^p_t.
$$

论文侧重置价格练习移除非调价者的名义指数化，因此精确的 $\iota_p$ 处理需要后续核对 implementation。

**(F22) 工资 Phillips 曲线**

$$
\begin{aligned}
w_t&=\frac{1}{1+\bar\beta\gamma}w_{t-1}
+\frac{\bar\beta\gamma}{1+\bar\beta\gamma}E_tw_{t+1}
+\frac{\iota_w}{1+\bar\beta\gamma}\pi_{t-1} \\
&\quad-\frac{1+\bar\beta\gamma\iota_w}{1+\bar\beta\gamma}\pi_t
+\frac{\bar\beta\gamma}{1+\bar\beta\gamma}E_t\pi_{t+1}
+\kappa_w\left[mrs_t-w_t\right]+s^w_t .
\end{aligned}
$$

其中：

$$
mrs_t=\sigma_l l_t+\frac{1}{1-h/\gamma}c_t-\frac{h/\gamma}{1-h/\gamma}c_{t-1}.
$$

**(F23) 货币政策规则**

$$
r_t=\rho_R r_{t-1}+(1-\rho_R)\left[\phi_\pi\pi_t+\phi_y(y_t-y_{f,t})\right]
+\phi_{\Delta y}\left[(y_t-y_{f,t})-(y_{t-1}-y_{f,t-1})\right]+m_t.
$$

**(F24) 黏性装配资本法则**

$$
kp_t=(1-\bar i_k)kp_{t-1}+\bar i_k i_t+\bar i_k\gamma^2\varphi q^s_t.
$$

## 4. Market Clearing & Identities

**(F25) 实际价格增长测度**

$$
\pi^{obs}_t=\pi_t+\bar\pi.
$$

**(F26) 观测实际增长率**

$$
\Delta y^{obs}_t=y_t-y_{t-1}+\bar\gamma,\quad
\Delta c^{obs}_t=c_t-c_{t-1}+\bar\gamma,\quad
\Delta i^{obs}_t=i_t-i_{t-1}+\bar\gamma,\quad
\Delta w^{obs}_t=w_t-w_{t-1}+\bar\gamma.
$$

**(F27) 重置价格通胀统计量**

对商品 $i$，令 $I_{i,t}$ 表示价格是否变化，$p^{\ast}_{i,t}$ 表示重置价格。论文定义：

$$
p^{\ast}_{i,t}=
\begin{cases}
p_{i,t}, & p_{i,t}\ne p_{i,t-1},\\
p^{\ast}_{i,t-1}+\pi^{\ast}_t, & p_{i,t}=p_{i,t-1},
\end{cases}
$$

以及总重置通胀：

$$
\pi^{\ast}_t=
\frac{\sum_i\omega_{i,t}(p_{i,t}-p^{\ast}_{i,t-1})I_{i,t}}
{\sum_i\omega_{i,t}I_{i,t}}.
$$

**(F28) 从实际通胀到重置通胀的 Calvo 映射**

在调价频率为 $\lambda$ 的 Calvo 时序下，重置价格统计量满足：

$$
\pi^{\ast}_t=\frac{\pi_t-(1-\lambda)\pi_{t-1}}{\lambda}.
$$

**(F29) Calvo 重置/实际波动率比率**

论文使用以下含义检验时间依赖定价：

$$
\frac{\sigma_{\pi^{\ast}}}{\sigma_{\pi}}
=\sqrt{1+\frac{2(1-\rho)(1-\lambda)}{\lambda^2}}.
$$

## 5. Exogenous Processes

双月 implementation_cross_check 包含七个结构创新：

**(F30) 技术冲击**

$$
a_t=\rho_a a_{t-1}+\varepsilon^a_t.
$$

**(F31) 风险溢价或偏好冲击**

$$
b_t=\rho_b b_{t-1}+\varepsilon^b_t.
$$

**(F32) 政府支出冲击**

$$
g_t=\rho_g g_{t-1}+\varepsilon^g_t+c_{gy}\varepsilon^a_t.
$$

**(F33) 投资专用技术冲击**

$$
q^s_t=\rho_{qs}q^s_{t-1}+\varepsilon^{qs}_t.
$$

**(F34) 货币政策冲击**

$$
m_t=\rho_m m_{t-1}+\varepsilon^m_t.
$$

**(F35) 含 MA 项的价格 markup shock**

$$
s^p_t=\rho_p s^p_{t-1}+\varepsilon^p_t-\mu_p\varepsilon^p_{t-1}.
$$

**(F36) 含 MA 项的工资 markup shock**

$$
s^w_t=\rho_w s^w_{t-1}+\varepsilon^w_t-\mu_w\varepsilon^w_{t-1}.
$$

## 6. Steady-State Solution

由于 `US_BKM12` 作为线性化双月 Smets-Wouters implementation 归档，第 3-5 节的所有模型变量在确定性稳态中均为零：

$$
y_f=c_f=i_f=q_f=k_f=kp_f=z_f=r^k_f=l_f=w_f=rr_f=0,
$$

$$
y=c=i=q=k=kp=z=r^k=l=w=mc=\pi=r=0,
$$

$$
a=b=g=q^s=m=s^p=s^w=0.
$$

implementation_cross_check 从校准和估计参数反解平衡增长常数：

$$
\Pi=1+\frac{\bar\pi}{100},\qquad
\gamma=1+\frac{\bar\gamma}{100},\qquad
\beta=\frac{1}{1+\bar\beta_{obs}/100}.
$$

$$
\bar R=\frac{\Pi}{\beta\gamma^{-\sigma_c}},\qquad
\bar R^k=\beta^{-1}\gamma^{\sigma_c}-(1-\delta).
$$

$$
\bar i_k=1-\frac{1-\delta}{\gamma},\qquad
\frac{I}{K}=\bar i_k\gamma,\qquad
\frac{K}{Y}=c_{fc}\left(\frac{K}{L}\right)^{\alpha-1}.
$$

论文正文没有给出完整的非线性稳态推导；因此本节标记为 `needs_review`，只记录线性稳态约定和 implementation_cross_check 常数。

## 7. Timing & Form Conventions

- 模型形式：`model(linear)`，双月频。
- 资本时序：生产使用预定的装配资本服务，$k_t=kp_{t-1}+z_t$，装配资本法则决定 $kp_t$。
- 政策规则：名义利率响应通胀和相对于弹性价格产出的产出缺口。
- 价格设定：论文的重置价格分析要求非调价价格不做名义价格指数化；精确 implementation 对齐标记为 `needs_review`。
- 重置通胀：$\pi^{\ast}_t$ 是从调价价格构造的测度/统计对象，而不是独立优化主体的一阶条件。
- 运行验证：未执行；没有运行 Dynare。

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | 含义 | Main equations |
| --- | --- | --- | --- |
| Endogenous | `yf`, $y_{f,t}$ | 弹性产出偏离 | (F8), (F9), (F23) |
| Endogenous | `cf`, $c_{f,t}$ | 弹性消费 | (F7), (F8), (F10) |
| Endogenous | `invef`, $i_{f,t}$ | 弹性投资 | (F5), (F8), (F11) |
| Endogenous | `pkf`, $q_{f,t}$ | 弹性资本价值 | (F5), (F6) |
| Endogenous | `kf`, $k_{f,t}$ | 弹性资本服务 | (F3), (F4), (F9) |
| Endogenous | `kpf`, $kp_{f,t}$ | 弹性装配资本 | (F4), (F11) |
| Endogenous | `zcapf`, $z_{f,t}$ | 弹性资本利用率 | (F2), (F4), (F8) |
| Endogenous | `rkf`, $r^k_{f,t}$ | 弹性资本租金 | (F1), (F2), (F3), (F6) |
| Endogenous | `labf`, $l_{f,t}$ | 弹性劳动 | (F3), (F7), (F9), (F10) |
| Endogenous | `wf`, $w_{f,t}$ | 弹性实际工资 | (F1), (F3), (F10) |
| Endogenous | `rrf`, $rr_{f,t}$ | 弹性实际利率 | (F6), (F7) |
| Endogenous | `y`, $y_t$ | 黏性产出偏离 | (F19), (F20), (F23), (F26) |
| Endogenous | `c`, $c_t$ | 黏性消费 | (F18), (F19), (F22), (F26) |
| Endogenous | `inve`, $i_t$ | 黏性投资 | (F16), (F19), (F24), (F26) |
| Endogenous | `pk`, $q_t$ | 黏性资本价值 | (F16), (F17) |
| Endogenous | `k`, $k_t$ | 黏性资本服务 | (F14), (F15), (F20) |
| Endogenous | `kp`, $kp_t$ | 黏性装配资本 | (F15), (F24) |
| Endogenous | `zcap`, $z_t$ | 黏性资本利用率 | (F13), (F15), (F19) |
| Endogenous | `rk`, $r^k_t$ | 黏性资本租金 | (F12), (F13), (F14), (F17) |
| Endogenous | `lab`, $l_t$ | 黏性劳动 | (F14), (F18), (F20), (F22) |
| Endogenous | `w`, $w_t$ | 黏性实际工资 | (F12), (F14), (F22), (F26) |
| Endogenous | `mc`, $mc_t$ | 实际边际成本 | (F12), (F21) |
| Endogenous | `pinf`, $\pi_t$ | 通胀 | (F17), (F18), (F21), (F22), (F25), (F28) |
| Endogenous | `r`, $r_t$ | 政策利率 | (F17), (F18), (F23) |
| Endogenous | `dy`, `dc`, `dinve`, `dw`, `pinfobs`, `robs`, `labobs` | 观测变量 | (F25), (F26) |
| Endogenous | `a`, `b`, `g`, `qs`, `ms`, `spinf`, `sw` | 冲击状态 | (F30)-(F36) |
| Endogenous | `epinfma`, `ewma` | implementation 中的 MA 辅助变量 | (F35), (F36) |
| Exogenous | `ea`, `eb`, `eg`, `eqs`, `em`, `epinf`, `ew` | 结构创新 | (F30)-(F36) |
| Measurement | $\pi^{\ast}_t$ | 重置价格通胀统计量 | (F27), (F28), (F29) |
| Parameter | `cbeta`, $\beta$ | 贴现因子 | (F5)-(F7), (F16)-(F18), Section 6 |
| Parameter | `cgamma`, $\gamma$ | 趋势增长 | (F5)-(F7), (F16)-(F18), Section 6 |
| Parameter | `csigma`, $\sigma_c$ | 消费曲率 | (F6), (F7), (F10), (F17), (F18), (F22) |
| Parameter | `chabb`, $h$ | 外部习惯 | (F7), (F10), (F18), (F22) |
| Parameter | `calfa`, $\alpha$ | 资本份额 | (F1), (F3), (F9), (F12), (F14), (F20) |
| Parameter | `ctou`, $\delta$ | 折旧 | (F6), (F17), Section 6 |
| Parameter | `csadjcost`, $\varphi$ | 投资调整成本曲率 | (F5), (F11), (F16), (F24) |
| Parameter | `czcap`, $c_z$ | 资本利用成本曲率 | (F2), (F13) |
| Parameter | `cprobp`, $\lambda$ | 价格不调整概率/调价频率对应项 | (F21), (F28), (F29) |
| Parameter | `cprobw` | 工资不调整概率 | (F22) |
| Parameter | `crr`, `crpi`, `cry`, `crdy` | 货币政策规则系数 | (F23) |
| Parameter | `crhoa`, `crhob`, `crhog`, `crhoqs`, `crhoms`, `crhopinf`, `crhow` | 冲击持续性参数 | (F30)-(F36) |
| Parameter | `cmap`, `cmaw` | 价格/工资 markup MA 系数 | (F35), (F36) |

### Self-Check Status

- 八节结构：完整。
- 模型形式：声明为双月 log-linear `model(linear)`。
- 时序约定：已记录预定装配资本。
- 来源记录：见 `source_manifest.json`。
- 公式质量：`needs_review`，尤其是 Kimball 曲率、精确价格指数化处理和非线性 FOC 来源。
- 运行验证：未执行，且不在本次请求范围内。
