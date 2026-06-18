# EA_BE15 - 生产函数中的货币：新凯恩斯 DSGE 视角

> `EA_BE15` 的第一遍私有模型档案推导。状态：`needs_review`。
> 来源：Jonathan Benchimol (2015), "Money in the Production Function: A New Keynesian DSGE Perspective", Southern Economic Journal 82(1), 152-184。DOI: `10.4284/0038-4038-2011.197`。
> 主 Markdown：`raw/mmb_mineru/runs/ea_be15__money_in_the_production_function_a_new_keynesian_dsge_perspective__1c7666dc/full.md`。
> 原始 PDF 路径存在并已记录作来源证明，但未打开 PDF 正文。

## 1. 模型概述

- **模型**：欧元区新凯恩斯 DSGE 模型，真实货币余额进入生产函数。
- **论文侧来源匹配**：Markdown 开头报告 "Money in the Production Function: A New Keynesian DSGE Perspective" 和 "Author(s): Jonathan Benchimol"，与 `EA_BE15` 的模型索引行匹配。
- **主体**：代表性家庭、具有 Calvo 定价的垄断竞争厂商，以及采用平滑名义利率规则的中央银行。
- **货币模块**：家庭持有非生产用途真实货币余额，厂商把真实货币余额作为生产投入。数量/流通速度方程把总真实货币和产出连接起来。
- **估计/实现形式**：对数线性 `model(linear)`。论文用八个方程给出粘性价格和弹性价格变量；MMB 实现交叉检查也使用 `model(linear)`。
- **运行验证**：未执行。没有运行 Dynare，也没有把本推导提升到可运行 skill archive。

## 2. 主体的最优化问题

### 家庭

代表性家庭最大化预期贴现效用，

$$
E_t\sum_{k=0}^{\infty}\beta^k U_{t+k},
$$

单期效用为

$$
U_t=e^{\varepsilon_t^u}\left[
\frac{C_t^{1-\sigma}}{1-\sigma}
+\frac{\gamma e^{\varepsilon_t^n}}{1-\nu}\left(\frac{M_{n,t}}{P_t}\right)^{1-\nu}
-\frac{\chi N_t^{1+\eta}}{1+\eta}
\right],
$$

约束为名义预算约束

$$
P_t C_t+M_{n,t}+M_{p,t}+Q_tB_t
\le B_{t-1}+W_tN_t+M_{n,t-1}+M_{p,t-1}.
$$

附录中的拉格朗日函数把约束改写为真实项，包含货币变化和真实债券头寸。家庭选择消费、劳动、非生产用途货币余额、进入总预算的生产用途货币以及债券。论文中有效的家庭货币 FOC 是非生产用途货币余额的 FOC。

### 厂商

每个厂商用生产用途货币余额生产差异化产品：

$$
Y_t(i)=e^{\varepsilon_t^a}
\left(e^{\varepsilon_t^p}\frac{M_{p,t}}{P_t}\right)^{\alpha_m}
N_t(i)^{1-\alpha_n}.
$$

厂商面对等弹性需求和 Calvo 定价。在第 `t` 期，只有比例 `1-\theta` 的厂商可以重设价格。重设价格的厂商选择 `P_t^*`，最大化该价格有效期间的预期贴现利润。论文随后在零通胀稳态附近使用一阶泰勒展开。

### 中央银行

中央银行由平滑 Taylor 型规则表示。论文按哪一种货币缺口进入规则检验五个变体。`EA_BE15` 的 MMB 实现采用生产用途货币缺口变体。

## 3. 一阶条件

附录中的原始家庭 FOC 为：

$$
\lambda_t=e^{\varepsilon_t^u}C_t^{-\sigma},
$$

$$
\lambda_t Q_t=\beta E_t\left[\lambda_{t+1}\frac{P_t}{P_{t+1}}\right],
$$

$$
\gamma e^{\varepsilon_t^u}e^{\varepsilon_t^n}
\left(\frac{M_{n,t}}{P_t}\right)^{-\nu}
=\lambda_t-\beta E_t\left[\lambda_{t+1}\frac{P_t}{P_{t+1}}\right],
$$

$$
\chi e^{\varepsilon_t^u}N_t^{\eta}
=\lambda_t\frac{W_t}{P_t}.
$$

这些条件推出总量模型中使用的对数线性 IS 曲线、家庭真实货币需求和劳动供给关系。下列简化 DSGE 条件是归档 `EA_BE15` 系统的模型方程。

**(F1) 弹性价格产出**

$$
y_t^f=v_a^y\varepsilon_t^a+v_p^y\varepsilon_t^p+v_m^y mp_{p,t}^f+v_c^y.
$$

这些系数是 `sigma`、`eta`、`alpha_n`、`alpha_m`、加成项和稳态常数的函数。OCR 与实现中的函数形式一致；系数公式在进入 reviewed 状态前仍为 `needs_review`。

**(F2) 弹性价格家庭货币需求**

$$
mp_{n,t}^f=\frac{\sigma}{\nu}y_t^f-\frac{a_2}{\nu}\sigma E_t[\Delta y_{t+1}^f]
-\frac{\rho_m+\rho_c a_2}{\nu}+\frac{1}{\nu}\varepsilon_t^n.
$$

**(F3) 弹性价格生产用途货币恒等式**

$$
mp_{p,t}^f=y_t^f-mp_{n,t}^f-\zeta_t.
$$

**(F4) 含生产用途货币缺口的新凯恩斯 Phillips 曲线**

$$
\pi_t=\beta E_t[\pi_{t+1}]
+\psi_x(y_t-y_t^f)
+\psi_m(mp_{p,t}-mp_{p,t}^f).
$$

货币项来自生产函数渠道和边际成本缺口。论文定义

$$
\psi_x=
\frac{\eta+\alpha_n-(1-\alpha_n)(1-\sigma)}
{1-\alpha_n+\varepsilon(2\alpha_n-1)}
(1-\theta)\left(\frac{1}{\theta}-\beta\right),
$$

$$
\psi_m=
\frac{1-\alpha_n-\alpha_m(1+\eta)}
{1-\alpha_n+\varepsilon(2\alpha_n-1)}
(1-\theta)\left(\frac{1}{\theta}-\beta\right).
$$

OCR 可读，但这些系数公式在任何 reviewed 状态前应与 PDF 或作者来源核对。

**(F5) 动态 IS 方程**

$$
y_t=E_t[y_{t+1}]
-\sigma^{-1}\left(i_t-E_t[\pi_{t+1}]-\rho_c\right)
-\sigma^{-1}E_t[\Delta\varepsilon_{t+1}^u].
$$

**(F6) 家庭非生产用途货币需求**

$$
mp_{n,t}=\frac{\sigma}{\nu}y_t-\frac{a_2}{\nu}i_t-\frac{\rho_m}{\nu}
+\frac{1}{\nu}\varepsilon_t^n.
$$

**(F7) 生产用途货币恒等式**

$$
mp_{p,t}=y_t-mp_{n,t}-\zeta_t.
$$

**(F8) 平滑 Taylor 规则**

$$
i_t=(1-\lambda_i)
\left[\lambda_\pi(\pi_t-\pi^{\ast})+\lambda_x(y_t-y_t^f)+M_{k,t}\right]
+\lambda_i i_{t-1}+\varepsilon_t^i.
$$

对 MMB 的 `EA_BE15` 实现，交叉检查使用

$$
M_{k,t}=\lambda_2(mp_{p,t}-mp_{p,t}^f),
$$

对应论文的 `k=2` 规则变体。该变体识别来自实现交叉检查，应再与预期的 MMB 实验元数据核对。

## 4. 市场出清与恒等式

商品市场出清给出总量对数线性模型中的 `Y_t=C_t`。生产用途货币模块使用论文的数量/流通速度闭合条件：

$$
P_tY_t=e^{\zeta_t}M_t,
$$

因此

$$
y_t=mp_t+\zeta_t=mp_{n,t}+mp_{p,t}+\zeta_t.
$$

弹性价格版本已记为 (F3)，粘性价格恒等式已记为 (F7)。劳动市场出清用于推导总量生产和边际成本：

$$
y_t=\varepsilon_t^a+\alpha_m\varepsilon_t^p+(1-\alpha_n)n_t+\alpha_m mp_{p,t}.
$$

Calvo 价格指数关系和重设价格 FOC 是用于推导 (F4) 的中间方程，不是最终八方程 DSGE 模块中的额外模型方程。

## 5. 外生过程

**(F9) 流通速度过程**

$$
\zeta_t=\zeta+\lambda_s\left[\lambda_{ms}\varepsilon_{n,t}+(1-\lambda_{ms})\varepsilon_{p,t}\right].
$$

**(F10) 技术冲击**

$$
\varepsilon_{a,t}=\rho_a\varepsilon_{a,t-1}+\xi_{a,t}.
$$

**(F11) 家庭货币需求冲击**

$$
\varepsilon_{n,t}=\rho_n\varepsilon_{n,t-1}+\xi_{n,t}.
$$

**(F12) 厂商货币需求冲击**

$$
\varepsilon_{p,t}=\rho_p\varepsilon_{p,t-1}+\xi_{p,t}.
$$

**(F13) 货币政策冲击**

$$
\varepsilon_{i,t}=\rho_i\varepsilon_{i,t-1}+\xi_{i,t}.
$$

**(F14) 偏好冲击**

$$
\varepsilon_{u,t}=\rho_u\varepsilon_{u,t-1}+\xi_{u,t}.
$$

每个创新在论文中都是均值为零、标准差为 `sigma_j` 的正态 i.i.d. 过程。MMB 实现把创新命名为 `ua`、`un`、`up`、`ui` 和 `uu`。

## 6. 稳态求解

由于 `EA_BE15` 以线性化 `model(linear)` 系统归档，(F1)-(F8) 中的动态变量是围绕近似点的对数偏离或可观测缺口变换。实现直接设定线性模型，因此没有从论文中抽取非线性 `steady_state_model`。

线性系统需要的稳态和系数定义：

1. `beta` 通过 `rho_c=-ln(beta)` 固定稳态真实利率。
2. `rho_m=-ln(gamma)+a_1`，其中实现交叉检查给出
   $a_1=\ln(1-\exp(-1/\beta))-\frac{1/\beta}{\exp(1/\beta)-1}$，
   $a_2=\frac{1}{\exp(1/\beta)-1}$。
3. 弹性价格系数 `v_a^y`、`v_p^y`、`v_m^y` 和 `v_c^y` 是 `alpha_n`、`alpha_m`、`eta`、`sigma`、加成项以及边际成本表达式中常数的函数。
4. 通胀目标 `pi^*` 在 (F8) 中显式出现；实现交叉检查使用 `cible` 表示该目标。
5. AR(1) 偏离变量的冲击稳态为零；流通速度均值为 `zeta`。

稳态质量为 `needs_review`：本推导记录线性系统和系数公式，但没有独立重建或验证所有宏观参数变换。

## 7. 时序与形式约定

- **形式**：对数线性 `model(linear)`。
- **期望**：`E_t[x_{t+1}]` 对应实现中的 Dynare `x(+1)`。
- **政策时序**：Taylor 规则含滞后名义利率 `i_{t-1}` / `ir(-1)`。
- **存量变量**：本模型没有资本存量。货币余额以真实余额进入，分为非生产用途家庭余额 `mp_n` 和生产用途厂商余额 `mp_p`。
- **缺口变量**：`y_t-y_t^f` 和 `mp_{p,t}-mp_{p,t}^f` 是 Phillips 曲线和 Taylor 规则变体中的核心状态缺口。
- **实现交叉检查**：`.mod` 文件确认变量 `y, pi, ir, mp, mn, yf, mpf, mnf, ea, eu, ei, ep, en, vel, rr, ygap`；外生冲击 `ua, uu, ui, up, un`；以及 `k=2` 生产用途货币 Taylor 规则变体。

## 8. 变量与参数对照表

| 类别 | 符号 / 实现名 | 含义 | 主要方程 |
|---|---|---|---|
| 内生 | `yf`, $y_t^f$ | 弹性价格产出 | (F1) |
| 内生 | `mnf`, $mp_{n,t}^f$ | 弹性价格非生产用途真实货币余额 | (F2) |
| 内生 | `mpf`, $mp_{p,t}^f$ | 弹性价格生产用途真实货币余额 | (F3) |
| 内生 | `pi`, $\pi_t$ | 通胀 | (F4) |
| 内生 | `y`, $y_t$ | 产出 | (F5) |
| 内生 | `mn`, $mp_{n,t}$ | 非生产用途真实货币余额 | (F6) |
| 内生 | `mp`, $mp_{p,t}$ | 生产用途真实货币余额 | (F7) |
| 内生 | `ir`, $i_t$ | 名义利率 | (F8) |
| 内生 | `vel`, $\zeta_t$ | 时变流通速度 | (F9) |
| 内生 | `ea` | 技术冲击状态 | (F10) |
| 内生 | `en` | 家庭货币需求冲击状态 | (F11) |
| 内生 | `ep` | 厂商货币需求冲击状态 | (F12) |
| 内生 | `ei` | 货币政策冲击状态 | (F13) |
| 内生 | `eu` | 偏好冲击状态 | (F14) |
| 辅助内生 | `rr` | 事后真实利率表达式，`ir-pi(+1)` | 恒等式，实现交叉检查 |
| 辅助内生 | `ygap` | 产出缺口，`y-yf` | 恒等式，实现交叉检查 |
| 外生 | `ua`, $\xi_{a,t}$ | 技术创新 | (F10) |
| 外生 | `un`, $\xi_{n,t}$ | 家庭货币需求创新 | (F11) |
| 外生 | `up`, $\xi_{p,t}$ | 厂商货币需求创新 | (F12) |
| 外生 | `ui`, $\xi_{i,t}$ | 货币政策创新 | (F13) |
| 外生 | `uu`, $\xi_{u,t}$ | 偏好创新 | (F14) |
| 参数 | `alphan`, $\alpha_n$ | 劳动指数 / 报酬参数 | (F1), (F4) |
| 参数 | `alpham`, $\alpha_m$ | 生产用途货币指数 | (F1), (F4) |
| 参数 | `beta`, $\beta$ | 贴现因子 | (F2), (F4), (F5) |
| 参数 | `teta`, $\theta$ | Calvo 价格粘性 | (F4) |
| 参数 | `nu`, $\nu$ | 货币持有利率弹性的倒数 | (F2), (F6) |
| 参数 | `sigma`, $\sigma$ | 风险厌恶 / IES 倒数 | (F2), (F5), (F6) |
| 参数 | `gamma`, $\gamma$ | 家庭货币效用尺度 | (F2), (F6) |
| 参数 | `khi`, $\chi$ | 劳动负效用尺度 | 家庭 FOC |
| 参数 | `neta`, $\eta$ | Frisch 弹性倒数 | (F1), (F4) |
| 参数 | `epsilon`, $\varepsilon$ | 需求弹性 / 加成参数 | (F4) |
| 参数 | `a1`, `a2` | 货币需求的泰勒近似常数 | (F2), (F6) |
| 参数 | `li1`, $\lambda_i$ | 利率平滑 | (F8) |
| 参数 | `li2`, $\lambda_\pi$ | 通胀反应 | (F8) |
| 参数 | `li3`, $\lambda_x$ | 产出缺口反应 | (F8) |
| 参数 | `cible`, $\pi^{\ast}$ | 通胀目标 | (F8) |
| 参数 | `rhoa1`, `rhon1`, `rhop1`, `rhoi1`, `rhou1` | AR(1) 持续性参数 | (F10)-(F14) |
| 参数 | `vel0`, $\zeta$ | 流通速度均值 | (F9) |
| 参数 | `vel1`, $\lambda_s$ | 流通速度冲击载荷 | (F9) |
| 参数 | `vel2`, $\lambda_{ms}$ | 家庭和厂商货币冲击的流通速度混合权重 | (F9) |
| 参数 | `vym`, `vyc`, `vya`, `vyp` | 弹性产出系数别名 | (F1) |
| 参数 | `mnf1`, `mnf2`, `mnf3`, `mnf4` | 弹性非生产用途货币系数别名 | (F2) |
| 参数 | `pi1`, `pi2` | Phillips 曲线系数别名 | (F4) |
