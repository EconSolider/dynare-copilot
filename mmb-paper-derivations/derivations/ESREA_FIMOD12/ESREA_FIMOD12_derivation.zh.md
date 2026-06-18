# ESREA_FIMOD12 -- 推导（最优化问题 + 一阶条件）

> 本一稿推导用于私有模型档案抽取。它根据 Stahler and Thomas (2012), "FiMod--A DSGE model for fiscal policy simulations" 概括模型方程和结构。公式层级状态：`needs_review`。

## 1. Model Overview

- **模型**：`ESREA_FIMOD12`，FiMod，一个用于财政政策模拟的中等规模两国货币联盟 DSGE 模型。
- **来源**：Stahler, Nikolai; Thomas, Carlos (2012), *Economic Modelling* 29, 239-261, DOI `10.1016/j.econmod.2011.10.001`。
- **经济体**：本国校准为西班牙，外国模块校准为欧元区其他地区。人口权重为 $`\omega`$ 和 $`1-\omega`$。
- **主体与模块**：优化家庭和规则型家庭、零售商、垄断竞争中间品生产者、带搜索匹配摩擦的劳动服务企业、国家财政当局，以及联盟层面的货币当局。
- **财政细节**：公共购买、公共投资、公共工资、公共就业、转移/补贴、公共债务，以及对消费、劳动收入、社保缴费、资本收入和债券收益的税收。
- **形式**：非线性 DSGE。MMB 实现是非线性 Dynare 模型，外国对称方程以 `f` 前缀表示。未执行运行时验证。
- **来源说明**：Markdown 前 80 行与预期标题和作者匹配。未发现来源索引错配。

## 2. Optimization Problems

### 2.1 家庭

两类家庭都从习惯调整后的私人消费和政府服务中获得效用：

```math
E_0\sum_{t=0}^{\infty}\beta^t u(c_t^i,c_{t-1}^i,\tilde g_t),\qquad i\in\{o,r\}.
```

当 $`\sigma_c\ne 1`$ 时，

```math
u(c_t^i,c_{t-1}^i,\tilde g_t)=
\frac{(c_t^i-hc_{t-1}^i)^{1-\sigma_c}-1}{1-\sigma_c}
+\zeta\frac{\tilde g_t^{1-\sigma_c}-1}{1-\sigma_c}.
```

优化家庭在实际预算约束、资本积累和无庞氏条件下选择消费、投资、资本、国内债券和国际债券。规则型家庭不能储蓄或借贷，每期消费可支配劳动收入和失业收入。

### 2.2 零售商和中间品生产者

零售商使用 CES 技术捆绑差异化中间品并选择投入需求。中间品生产者在使用私人资本、公共资本和劳动服务的 Cobb-Douglas 技术下最小化要素成本。定价企业按 Calvo 机制重新优化价格。

### 2.3 劳动服务企业和工资谈判

劳动服务企业发布职位空缺、与搜索工人匹配并生产同质劳动服务。私人部门工资由带交错调整的工会-企业 Nash 谈判决定。政府工资和就业是财政工具，而不是私人优化选择。

### 2.4 财政和货币当局

财政当局满足政府预算约束并遵循工具规则。联盟货币当局使用联盟加权通胀和产出增长设定共同 ECB 利率的非线性 Taylor 型规则。

## 3. First-Order Conditions

以下方程记录本国模块。外国结构相同，论文中用星号表示，实现交叉检查中用 `f` 前缀表示。

- **(F1) 优化家庭收入边际效用**：

```math
\lambda_t^o=
\frac{(c_t^o-hc_{t-1}^o)^{-\sigma_c}
-\beta h E_t[(c_{t+1}^o-hc_t^o)^{-\sigma_c}]}
{1+\tau_t^c}.
```

- **(F2) 国内债券 Euler 方程**：

```math
\lambda_t^o=\beta E_t\left[
\lambda_{t+1}^o
\frac{R_t(1-\tau_{t+1}^b)+\tau_{t+1}^b}{\pi_{t+1}}
\right].
```

- **(F3) 资本 Euler 方程**：

```math
Q_t=\beta E_t\left[
\frac{\lambda_{t+1}^o}{\lambda_t^o}
\left((1-\delta^k)Q_{t+1}+(1-\tau_{t+1}^k)r_{t+1}^k+\tau_{t+1}^k\delta^k\right)
\right].
```

- **(F4) 投资/Tobin's Q 条件**（`needs_review`：MinerU OCR 在调整成本项中丢失部分指数）：

```math
1=Q_t\left[1-S(I_t^o/I_{t-1}^o)-I_t^o S'(I_t^o/I_{t-1}^o)\right]
+\beta E_t\left[
\frac{\lambda_{t+1}^o}{\lambda_t^o}Q_{t+1}
\left(\frac{I_{t+1}^o}{I_t^o}\right)^2
S'(I_{t+1}^o/I_t^o)
\right].
```

- **(F5) 国际债券 Euler 方程**：

```math
\lambda_t^o=\beta R_t^{ecb}\exp\left[-\psi_d(d_t-\bar d)/Y_t\right]
E_t\left[\frac{\lambda_{t+1}^o}{\pi_{t+1}}\right].
```

- **(F6) 规则型家庭预算约束**：

```math
(1+\tau_t^c)c_t^r=(1-\tau_t^w)(w_t^p n_t^{p,r}+w_t^g n_t^{g,r})
+(1-n_t^{p,r}-n_t^{g,r})\kappa^B.
```

- **(F7) 规则型家庭边际效用**：

```math
\lambda_t^r=
\frac{(c_t^r-hc_{t-1}^r)^{-\sigma_c}
-\beta h E_t[(c_{t+1}^r-hc_t^r)^{-\sigma_c}]}
{1+\tau_t^c}.
```

- **(F8) 中间品品种 $`j`$ 的零售 CES 需求**：

```math
y_t(j)=\left(\frac{P_{At}(j)}{P_{At}}\right)^{-\varepsilon}Y_t.
```

- **(F9) 生产者价格指数**：

```math
P_{At}=\left(\int_0^\omega \frac{1}{\omega}P_{At}(j)^{1-\varepsilon}dj\right)^{1/(1-\varepsilon)}.
```

- **(F10) 中间品生产和价格分散**：

```math
Y_tD_t=A_t(k_{t-1}^g)^\eta k_{t-1}^{\alpha}L_t^{1-\alpha}.
```

- **(F11) 私人资本租金率**：

```math
r_t^k=mc_t\alpha\frac{Y_t}{k_{t-1}}.
```

- **(F12) 劳动服务价格**：

```math
x_t=mc_t(1-\alpha)\frac{Y_t}{L_t}.
```

- **(F13) Calvo 最优价格条件**（`needs_review`：紧凑无穷和条件被概括为递归实现形式）：

```math
\tilde p_t=\frac{\varepsilon}{\varepsilon-1}\frac{q_{1,t}}{q_{2,t}}.
```

- **(F14) Calvo 分子递归**：

```math
q_{1,t}=\lambda_t^oY_tmc_t+\theta_P\beta E_t[\pi_{A,t+1}^{\varepsilon}q_{1,t+1}].
```

- **(F15) Calvo 分母递归**：

```math
q_{2,t}=\lambda_t^oY_tp_{B,t}^{-(1-\omega-\psi)}
+\theta_P\beta E_t[\pi_{A,t+1}^{\varepsilon-1}q_{2,t+1}].
```

- **(F16) PPI 通胀规律**：

```math
1=\theta_P\pi_{A,t}^{\varepsilon-1}+(1-\theta_P)\tilde p_t^{1-\varepsilon}.
```

- **(F17) 价格分散规律**：

```math
D_t=(1-\theta_P)\tilde p_t^{-\varepsilon}
+\theta_P\pi_{A,t}^{\varepsilon}D_{t-1}.
```

- **(F18) 由 PPI 通胀和贸易条件得到 CPI 通胀**：

```math
\pi_t=\pi_{A,t}\left(\frac{p_{B,t}}{p_{B,t-1}}\right)^{1-\omega-\psi}.
```

- **(F19) 搜索工人池**：

```math
\tilde U_t=U_{t-1}+s^pN_{t-1}^p+s^gN_{t-1}^g.
```

- **(F20) 部门匹配函数**：

```math
M_t^f=\kappa_e^f(\tilde U_t)^{\phi^f}(v_t^f)^{1-\phi^f},\qquad f\in\{p,g\}.
```

- **(F21) 找工作概率和职位填补概率**：

```math
p_t^f=\frac{M_t^f}{\tilde U_t},\qquad q_t^f=\frac{M_t^f}{v_t^f}.
```

- **(F22) 部门就业运动方程**：

```math
N_t^f=(1-s^f)N_{t-1}^f+p_t^f\tilde U_t,\qquad f\in\{p,g\}.
```

- **(F23) 失业恒等式**：

```math
U_t=1-N_t^{tot},\qquad N_t^{tot}=N_t^p+N_t^g.
```

- **(F24) 职位自由进入条件**：

```math
\frac{\kappa_v^p}{q_t^p}+\kappa_{tc}
=(1-\theta_w^n)J_t(\tilde W_t^p)+\theta_w^nJ_t(W_{t-1}^p).
```

- **(F25) 工会-企业 Nash 分享规则**（`needs_review`：来源表达式中的税率符号有 OCR 噪声）：

```math
\Omega_t=\frac{\xi}{1-\xi}\cdot
\frac{\mathcal A_t^w}{\mathcal A_t^{sc}}\cdot J_t(\tilde W_t^p),
```

其中 $`\mathcal A_t^w`$ 和 $`\mathcal A_t^{sc}`$ 是论文 Eq. (58) 中的预期贴现劳动税和社保税楔子。

- **(F26) 平均私人实际工资运动方程**：

```math
w_t^p=
\frac{(1-s^p)N_{t-1}^p}{N_t^p}
\left[(1-\theta_w)\tilde w_t^p+\theta_w\frac{w_{t-1}^p}{\pi_t}\right]
+\frac{M_t^p}{N_t^p}
\left[(1-\theta_w^n)\tilde w_t^p+\theta_w^n\frac{w_{t-1}^p}{\pi_t}\right].
```

## 4. Market Clearing & Identities

- **(F27) 总消费**：

```math
C_t=(1-\mu)c_t^o+\mu c_t^r.
```

- **(F28) 仅优化家庭持有的总量存量和投资**：

```math
k_t=(1-\mu)k_t^o,\qquad I_t=(1-\mu)I_t^o,\qquad b_t=(1-\mu)b_t^o,\qquad d_t=(1-\mu)d_t^o.
```

- **(F29) 私人资本积累**：

```math
k_t=(1-\delta^k)k_{t-1}+[1-S(I_t/I_{t-1})]I_t,\qquad
S(x)=\frac{\kappa_I}{2}(x-1)^2.
```

- **(F30) 私人产出吸收**：

```math
Y_t=C_t^g+C_{A,t}^{tot}+I_{A,t}^{tot}+I_t^g+\frac{1-\omega}{\omega}(C_{A,t}^{\ast,tot}+I_{A,t}^{\ast,tot}).
```

- **(F31) 总 GDP 定义**：

```math
Y_t^{tot}=Y_t+g_t^g.
```

- **(F32) 政府支出分解**：

```math
G_t=C_t^g+I_t^g+\left[(1+\tau_t^{sc})w_t^gN_t^g\right]p_{B,t}^{1-\omega-\psi}.
```

- **(F33) 政府预算约束/债务积累**：

```math
b_t=\frac{R_{t-1}}{\pi_t}b_{t-1}+PD_t.
```

- **(F34) 初级赤字**：

```math
PD_t=
\left[\frac{G_t}{p_{B,t}^{1-\omega-\psi}}+\kappa^BU_t+Sub_t\right]
-\left[(\tau_t^w+\tau_t^{sc})(w_t^pN_t^p+w_t^gN_t^g)
+\tau_t^b\frac{R_{t-1}-1}{\pi_t}b_{t-1}
+\tau_t^cC_t+\tau_t^k(r_t^k-\delta^k)k_{t-1}+T_t\right].
```

- **(F35) 公共资本积累**：

```math
k_t^g=(1-\delta^g)k_{t-1}^g+I_t^g.
```

- **(F36) 贸易条件规律**：

```math
p_{B,t}=\frac{\pi_{B,t}}{\pi_{A,t}}p_{B,t-1}.
```

- **(F37) 本国经常账户/净国外资产恒等式**（`needs_review`：代码生成前需对照 PDF 核查价格平减约定）：

```math
d_t=\frac{R_{t-1}^{ecb}\exp[-\psi_d(d_{t-1}-\bar d)/Y_{t-1}]}{\pi_{A,t}}d_{t-1}
+\frac{1-\omega}{\omega}(C_{A,t}^{\ast,tot}+I_{A,t}^{\ast,tot})
-p_{B,t}(C_{B,t}^{tot}+I_{B,t}^{tot}).
```

## 5. Exogenous Processes

- **(F38) 技术过程**：

```math
\log A_t=\rho_A\log A_{t-1}+\varepsilon_t^A.
```

- **(F39) 财政工具规则**：

```math
X_t=\bar X+\rho_X(X_{t-1}-\bar X)
+(1-\rho_X)\varphi_X e_X^{aux}
\left(\frac{b_{t-1}}{Y_{t-1}^{tot}}p_{B,t-1}^{1-\omega-\psi}-\omega^b\right)
+\varepsilon_t^X,
```

适用于税率工具 $`X\in\{\tau^w,\tau^{sc},\tau^b,\tau^c,\tau^k\}`$。

- **(F40) 支出和转移工具规则**：

```math
\frac{X_t}{\bar X}=
\left(\frac{X_{t-1}}{\bar X}\right)^{\rho_X}
\left(\frac{b_{t-1}}{\omega^bY_{t-1}^{tot}}p_{B,t-1}^{1-\omega-\psi}\right)^{(1-\rho_X)\varphi_X}
\exp(\varepsilon_t^X),
```

适用于 $`X\in\{C^g,I^g,w^g,N^g,Sub,T\}`$。

- **(F41) 联盟 Taylor 规则**：

```math
\frac{R_t^{ecb}}{\bar R^{ecb}}=
\left(\frac{R_{t-1}^{ecb}}{\bar R^{ecb}}\right)^{\rho_i}
\left[
\left(\frac{\pi_t}{\bar\pi}\right)^{\omega\phi_\pi}
\left(\frac{\pi_t^{\ast}}{\bar\pi^{\ast}}\right)^{(1-\omega)\phi_\pi}
\left(\frac{Y_t^{tot}}{Y_{t-1}^{tot}}\right)^{\omega\phi_y}
\left(\frac{Y_t^{\ast,tot}}{Y_{t-1}^{\ast,tot}}\right)^{(1-\omega)\phi_y}
\right]^{1-\rho_i}\exp(\varepsilon_t^i).
```

## 6. Steady-State Solution

论文通过校准来匹配西班牙和欧元区其他地区的稳态比率，而不是为所有变量给出紧凑闭式解。因此，本一稿档案条目的稳态为 `needs_review`。

有来源支持的稳态关系包括：

1. 冲击取零，通胀固定在共同目标；零通胀下价格分散取对称稳态值。
2. 使用财政目标 $`\bar C^g=\omega_{Cg}\bar Y^{tot}`$、$`\bar I^g=\omega_{IG}\bar Y^{tot}`$、$`\bar w^g=\omega_{wg}\bar w^p`$、$`\bar N^g=\omega_{ng}\bar N^{tot}`$ 和债务目标 $`\omega^b`$。
3. 公共资本由 (F35) 给出 $`\bar k^g=\bar I^g/\delta^g`$。
4. 私人资本由 (F29) 给出 $`\bar k=\bar I/\delta^k`$。
5. 边际产出方程 (F11)-(F12)、生产方程 (F10) 和 Calvo 加成决定稳态边际成本、要素价格和校准就业资本比率下的产出。
6. 劳动匹配模块根据目标就业、失业、分离率和培训成本确定匹配效率和职位空缺成本。
7. 政府预算约束和初级赤字方程确定所需的剩余财政工具。

未决事项：仅从论文重建完整 `steady_state_model` 需要检查实现校准模块和若干 PDF 公式；本任务没有分配运行时验证。

## 7. Timing & Form Conventions

- 资本是预定状态变量：$`t`$ 期生产使用 $`k_{t-1}`$ 和 $`k_{t-1}^g`$；积累方程决定期末 $`k_t`$ 和 $`k_t^g`$。
- 匹配发生在期初。新匹配工人立即生产；$`t-1`$ 的分离者进入 $`t`$ 期搜索池。
- 国内债券和公共债务按 $`R_{t-1}/\pi_t`$ 支付。
- 贸易条件 $`p_{B,t}`$ 用于本国和外国 PPI 之间转换，也用于 CPI 与 PPI 平减的财政总量之间转换。
- 模型是非线性的。实现交叉检查使用一阶随机模拟，但档案推导不是手工线性化模型。
- 外国方程对称，但本土偏好和经济规模权重并不完全相同。

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII cue | Meaning | Main equations |
|---|---|---|---|
| Endogenous | `Ct`, $`C_t`$ | 总私人消费 | (F27) |
| Endogenous | `Crt`, $`c_t^r`$ | 规则型家庭消费 | (F6), (F7) |
| Endogenous | `lambdat`, $`\lambda_t^o`$ | 优化家庭收入边际效用 | (F1) |
| Endogenous | `lambdart`, $`\lambda_t^r`$ | 规则型家庭收入边际效用 | (F7) |
| Endogenous | `Qt`, $`Q_t`$ | Tobin's Q | (F3), (F4) |
| Endogenous | `It`, $`I_t`$ | 私人投资 | (F4), (F29) |
| Endogenous | `kt`, $`k_t`$ | 私人资本 | (F29) |
| Endogenous | `Yt`, $`Y_t`$ | 私人产出 | (F10), (F30) |
| Endogenous | `Ytot`, $`Y_t^{tot}`$ | 包含政府生产的 GDP | (F31) |
| Endogenous | `mct`, $`mc_t`$ | 边际成本 | (F11), (F12) |
| Endogenous | `rt`, $`r_t^k`$ | 私人资本租金率 | (F11) |
| Endogenous | `xt`, $`x_t`$ | 劳动服务价格 | (F12) |
| Endogenous | `piet`, $`\pi_t`$ | CPI 通胀 | (F18) |
| Endogenous | `pieAt`, $`\pi_{A,t}`$ | 本国 PPI 通胀 | (F16) |
| Endogenous | `Dt`, $`D_t`$ | 价格分散 | (F17) |
| Endogenous | `q1t`, `q2t`, `ptildt` | Calvo 定价辅助变量和重置价格 | (F13)-(F15) |
| Endogenous | `npt`, `ngt`, $`N_t^p,N_t^g`$ | 私人和公共就业 | (F22), (F23) |
| Endogenous | `utot`, $`U_t`$ | 失业 | (F23) |
| Endogenous | `Mpt`, `Mgt`, $`M_t^p,M_t^g`$ | 部门匹配数 | (F20) |
| Endogenous | `qpt`, `qgt`, `ppt`, `pgt` | 匹配概率 | (F21) |
| Endogenous | `wpt`, `wopt` | 平均和新谈判私人工资 | (F25), (F26) |
| Endogenous | `Jt`, `Jot`, `Wpt`, `Wgt` | 企业和工人的剩余/价值对象 | (F24), (F25) |
| Endogenous | `Debt`, $`b_t`$ | 实际公共债务 | (F33), (F34) |
| Endogenous | `G_t`, `Cgt`, `Igt`, `ggt` | 政府支出组成 | (F32), (F35), (F40) |
| Endogenous | `kgt`, $`k_t^g`$ | 公共资本 | (F35) |
| Endogenous | `pBt`, $`p_{B,t}`$ | 贸易条件/相对 PPI | (F36) |
| Endogenous | `ddt`, $`d_t`$ | 净国外资产头寸 | (F37) |
| Endogenous | `RECBt`, $`R_t^{ecb}`$ | 联盟货币政策利率 | (F41) |
| Exogenous | `epsiA`, $`\varepsilon_t^A`$ | 技术冲击 | (F38) |
| Exogenous | `epsiG`, `epsiIg`, `epsiwg`, `epsing` | 财政支出、投资、工资、就业冲击 | (F40) |
| Exogenous | `epsic`, `epsitw`, `epsisc`, `epsik`, `epsib` | 税率冲击 | (F39) |
| Exogenous | `epsii` | 货币政策冲击 | (F41) |
| Parameter | $`\beta,h,\sigma_c,\mu`$ | 贴现、习惯、风险规避、规则型家庭占比 | (F1), (F7), (F27) |
| Parameter | $`\alpha,\eta,\delta^k,\delta^g,\kappa_I`$ | 生产、公共资本、折旧、投资成本 | (F10), (F29), (F35) |
| Parameter | $`\theta_P,\varepsilon`$ | Calvo 价格刚性和商品替代弹性 | (F13)-(F17) |
| Parameter | $`s^p,s^g,\kappa_e^f,\phi^f,\kappa_v^p,\kappa_{tc}`$ | 劳动搜索匹配 | (F19)-(F24) |
| Parameter | $`\theta_w,\theta_w^n,\xi`$ | 工资刚性和谈判权重 | (F25), (F26) |
| Parameter | $`\rho_X,\varphi_X,\omega^b`$ | 财政规则平滑、债务反馈、目标债务率 | (F39), (F40) |
| Parameter | $`\rho_i,\phi_\pi,\phi_y,\omega`$ | 货币规则平滑、反馈系数、国家规模 | (F41) |
