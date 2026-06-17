# NK_BGG99 -- 推导（最优化问题 + 一阶条件）

> 私有归档的一稿条目。状态：`needs_review`。未执行运行时验证。

## 1. Model Overview

- **模型 ID**：`NK_BGG99`。
- **来源**：Ben S. Bernanke, Mark Gertler, and Simon Gilchrist (1999), "The financial accelerator in a quantitative business cycle framework," *Handbook of Macroeconomics*, DOI `10.1016/s1574-0048(99)10034-x`。
- **来源文件**：主要 OCR Markdown `raw/mmb_mineru/runs/nk_bgg99_nk_bgg99al__the_financial_accelerator_in_a_quantitative_business__e6291ccb/full.md`；原始 PDF `raw/mmb_papers/The financial accelerator in a quantitative business.pdf`。
- **主体**：家庭、企业家、竞争性金融中介、批发生产者、垄断竞争零售商以及财政/货币当局。
- **核心机制**：成本状态验证合约使外部融资溢价随企业家净值相对于装机资本价值的提高而下降。
- **模型形式**：MMB 实现交叉检查中为 log-linearized `model(linear)`。源论文也直接给出对数线性化的完整宏观模型，非线性合约和家庭/零售附录作为推导依据。
- **实验**：货币政策、技术、政府支出和财富转移冲击；MMB 实现保留技术、政府支出和货币政策创新。

## 2. Optimization Problems

### 家庭

家庭选择消费、存款、劳动和实际货币余额：

$$
\max_{\{C_{t+k},D_{t+k+1},H_{t+k},M_{t+k}/P_{t+k}\}} E_t\sum_{k=0}^{\infty}\beta^k
\left[\ln C_{t+k}+\xi\ln(M_{t+k}/P_{t+k})+\xi\ln(1-H_{t+k})\right]
$$

约束为

$$
C_t = W_tH_t-T_t+\Pi_t+R_tD_t-D_{t+1}+\frac{M_{t-1}-M_t}{P_t}.
$$

### 企业家和金融中介

企业家 $j$ 购买下一期使用的资本。借款为

$$
B_{t+1}^j = Q_tK_{t+1}^j-N_{t+1}^j.
$$

成本状态验证合约选择资本和特质回报截止值：

$$
\max_{K,\bar\omega}\;(1-\Gamma(\bar\omega))R^kQK
$$

并满足贷款人盈亏平衡条件

$$
\left[\Gamma(\bar\omega)-\mu G(\bar\omega)\right]R^kQK=R(QK-N).
$$

论文定义

$$
\Gamma(\bar\omega)=\int_0^{\bar\omega}\omega f(\omega)d\omega+\bar\omega\int_{\bar\omega}^{\infty}f(\omega)d\omega,
\qquad
\mu G(\bar\omega)=\mu\int_0^{\bar\omega}\omega f(\omega)d\omega.
$$

### 资本品 / 投资技术

投资通过调整成本技术形成新资本：

$$
K_{t+1}=\Phi\!\left(\frac{I_t}{K_t}\right)K_t+(1-\delta)K_t.
$$

新资本价格由边际转换率决定：

$$
Q_t=\left[\Phi'\!\left(\frac{I_t}{K_t}\right)\right]^{-1}.
$$

### 零售商

零售商聚合差异化商品，

$$
Y_t^f=\left[\int_0^1Y_t(z)^{(\epsilon-1)/\epsilon}dz\right]^{\epsilon/(\epsilon-1)},
$$

面临需求

$$
Y_t(z)=\left(\frac{P_t(z)}{P_t}\right)^{-\epsilon}Y_t^f,
$$

并在 Calvo 刚性下选择最优重设价格：

$$
\max_{P_t^*}\sum_{k=0}^{\infty}\theta^kE_{t-1}\left[
\Lambda_{t,k}\frac{P_t^*-P_{t+k}^w}{P_{t+k}}Y_{t+k}^*(z)
\right].
$$

## 3. First-Order Conditions

- **(F1) 家庭欧拉方程**：

$$
\frac{1}{C_t}=E_t\left\{\beta\frac{1}{C_{t+1}}\right\}R_{t+1}.
$$

- **(F2) 家庭劳动供给**：

$$
W_t\frac{1}{C_t}=\xi\frac{1}{1-H_t}.
$$

- **(F3) 家庭货币需求**：

$$
\frac{M_t}{P_t}=\zeta C_t\left(\frac{R_{t+1}^n-1}{R_{t+1}^n}\right)^{-1}.
$$

- **(F4) 合约贷款人盈亏平衡条件**：

$$
\left[\Gamma(\bar\omega)-\mu G(\bar\omega)\right]R^kQK=R(QK-N).
$$

- **(F5) 合约截止值条件**：

$$
s=\rho(\bar\omega),\qquad s\equiv\frac{R^k}{R}.
$$

- **(F6) 最优合约给出的资本/财富比率**：

$$
\frac{QK}{N}=\psi(s),\qquad \psi'(s)>0.
$$

- **(F7) 一般均衡中的外部融资溢价**：

$$
E_t\{R_{t+1}^k\}=s\!\left(\frac{N_{t+1}}{Q_tK_{t+1}}\right)R_{t+1},\qquad s'(\cdot)<0.
$$

- **(F8) 资本预期回报**：

$$
E_t\{R_{t+1}^k\}=E_t\left\{\frac{\frac{1}{X_{t+1}}\frac{\alpha Y_{t+1}}{K_{t+1}}+Q_{t+1}(1-\delta)}{Q_t}\right\}.
$$

- **(F9) 资本价格/投资条件**：

$$
Q_t=\left[\Phi'\!\left(\frac{I_t}{K_t}\right)\right]^{-1}.
$$

- **(F10) 企业家权益**：

$$
V_t=R_t^kQ_{t-1}K_t-
\left(R_t+\frac{\mu\int_0^{\bar\omega_t}\omega R_t^kQ_{t-1}K_t\,dF(\omega)}
{Q_{t-1}K_t-N_{t-1}}\right)(Q_{t-1}K_t-N_{t-1}).
$$

- **(F11) 企业家净值**：

$$
N_{t+1}=\gamma V_t+W_t^e.
$$

- **(F12) 批发生产**：

$$
Y_t=A_tK_t^{\alpha}L_t^{1-\alpha},\qquad L_t=H_t^{\Omega}(H_t^e)^{1-\Omega}.
$$

- **(F13) 家庭劳动需求**：

$$
(1-\alpha)\Omega\frac{Y_t}{H_t}=X_tW_t.
$$

- **(F14) 企业家劳动需求**：

$$
(1-\alpha)(1-\Omega)\frac{Y_t}{H_t^e}=X_tW_t^e.
$$

- **(F15) 零售最优重设价格**：

$$
\sum_{k=0}^{\infty}\theta^kE_{t-1}\left\{
\Lambda_{t,k}\left(\frac{P_t^*}{P_{t+k}}\right)^{-\epsilon}Y_{t+k}^*(z)
\left[\frac{P_t^*}{P_{t+k}}-\left(\frac{\epsilon}{\epsilon-1}\right)\frac{P_{t+k}^w}{P_{t+k}}\right]\right\}=0.
$$

- **(F16) Calvo 定价下的总价格指数**：

$$
P_t=\left[\theta P_{t-1}^{1-\epsilon}+(1-\theta)(P_t^*)^{1-\epsilon}\right]^{1/(1-\epsilon)}.
$$

## 4. Market Clearing & Identities

- **(F17) 最终品资源约束**：

$$
Y_t^f=C_t+C_t^e+I_t+G_t+\mu\int_0^{\bar\omega_t}\omega\,dF(\omega)R_t^kQ_{t-1}K_t.
$$

- **(F18) 存款/可贷资金出清**：

$$
D_t=B_t.
$$

- **(F19) 政府预算恒等式**：

$$
G_t=\frac{M_t-M_{t-1}}{P_t}+T_t.
$$

- **(F20) 名义利率与实际利率关系**：

$$
r_{t+1}^n=r_{t+1}+E_t(p_{t+1}-p_t).
$$

源文计算模块将主要均衡对数线性化为：

$$
y_t=\frac{C}{Y}c_t+\frac{I}{Y}i_t+\frac{G}{Y}g_t+\frac{C^e}{Y}c_t^e+\cdots+\phi_t^v,
$$

$$
c_t=-r_{t+1}+E_t\{c_{t+1}\},
$$

$$
c_t^e=n_{t+1}+\cdots+\phi_t^{c^e},
$$

$$
E_t\{r_{t+1}^k\}-r_{t+1}=-\nu\left[n_{t+1}-(q_t+k_{t+1})\right],
$$

$$
r_{t+1}^k=(1-\epsilon)(y_{t+1}-k_{t+1}-x_{t+1})+\epsilon q_{t+1}-q_t,
$$

$$
q_t=\varphi(i_t-k_t),
$$

$$
y_t=a_t+\alpha k_t+(1-\alpha)\Omega h_t,
$$

$$
y_t-h_t-x_t-c_t=\eta^{-1}h_t,
$$

$$
\pi_t=E_{t-1}\{\kappa(-x_t)+\beta\pi_{t+1}\},
$$

$$
k_{t+1}=\delta i_t+(1-\delta)k_t,
$$

$$
n_{t+1}=\frac{\gamma RK}{N}(r_t^k-r_t)+r_t+n_t+\cdots+\phi_t^n.
$$

这些对数线性方程由来源给出，但论文 OCR 中若干二阶项或监测成本项用省略号表示；状态：`needs_review`。

## 5. Exogenous Processes

- **(F21) 货币政策规则**：

$$
r_t^n=\rho r_{t-1}^n+\varsigma\pi_{t-1}+\varepsilon_t^{rn}.
$$

- **(F22) 政府支出冲击**：

$$
g_t=\rho_g g_{t-1}+\varepsilon_t^g.
$$

- **(F23) 技术冲击**：

$$
a_t=\rho_a a_{t-1}+\varepsilon_t^a.
$$

实现交叉检查使用 `e_a`、`e_g` 和 `e_rn` 作为三个外生创新。

## 6. Steady-State Solution

MMB 实现是线性化模型，因此 `model(linear)` 块中的动态变量是相对稳态的偏离。实现交叉检查在校准稳态比率和常数后，对内生偏离变量使用零稳态。

实现交叉检查中记录的稳态校准关系包括：

1. 设定 $\beta=0.99$、$\alpha=0.35$、$\delta=0.025$、$\rho=0.9$、$\rho_a=1$、$\rho_g=0.95$、$\theta=0.75$、$\eta=3$、$\varphi=0.25$。
2. 设定 $R=1/\beta$。
3. 设定稳态外部融资溢价 $s=1.005$ 且 $R^K=sR$。
4. 设定 $K/N=2$、$G/Y=0.2$、总加成 $X=1.1$ 和家庭劳动 $H=0.25$。
5. 由资本回报条件计算 $Y/K=(X/\alpha)(R^K-(1-\delta))$。
6. 根据论文侧恒等式和实现公式计算 $C/Y$、$I/Y$、$C^e/Y$、$N/Y$ 和 $D/Y$ 等收入份额比率。

论文侧合约校准目标包括二百个基点的年化风险利差、百分之三的年化企业失败率以及资本净值比率 2。附录合约与实现校准之间的逐公式核对仍为 `needs_review`。

## 7. Timing & Form Conventions

- 计算模型是对数线性化模型；论文中小写变量表示相对稳态的百分比偏离，而实现文件给变量名附加 `H`。
- 资本时序在论文中为：第 $t$ 期购买的资本在第 $t+1$ 期使用；MMB 实现中，生产和回报方程使用 `kH(-1)`，资本运动方程决定当前 `kH`。
- 净值时序在论文中为：$N_{t+1}$ 是第 $t$ 期回报和企业家工资收入之后的期末净值；实现用滞后 `nH(-1)`、滞后资本/价格项和当期回报来表示当前线性化 `nH`。
- Calvo 定价者在来源时序中于当期总量不确定性实现前选择重设价格；实现通过 `pi_t1H` 表示 Phillips 曲线的一期预期/实现时序安排。
- 来源在家庭问题中包含实际货币余额，但 MMB 实现在线性模型中省略货币需求，只保留利率规则和 Fisher 关系。
- 未运行运行时验证。

## 8. Variable & Parameter Reference Table

### 内生变量

| 类别 | 符号 / ASCII | 含义 | 主要方程 |
|---|---|---|---|
| endogenous | `cH`, $c_t$ | 家庭消费偏离 | (F1), 对数线性需求 |
| endogenous | `hH`, $h_t$ | 家庭劳动偏离 | (F2), 劳动市场 |
| endogenous | `piH`, $\pi_t$ | 通胀 | (F16), Phillips 曲线, (F21) |
| endogenous | `rH`, $r_t$ | 实际无风险利率 | (F1), (F20) |
| endogenous | `r_nH`, $r_t^n$ | 名义无风险利率 | (F20), (F21) |
| endogenous | `qH`, $q_t$ | 资本价格 | (F9), 投资关系 |
| endogenous | `kH`, $k_t$ | 资本存量 | 资本运动方程 |
| endogenous | `nH`, $n_t$ | 企业家净值 | (F10), (F11) |
| endogenous | `r_kH`, $r_t^k$ | 资本回报 | (F8) |
| endogenous | `yH`, $y_t$ | 产出 | (F12), 资源约束 |
| endogenous | `xH`, $x_t$ | 零售加成 | 劳动市场, Phillips 曲线 |
| endogenous | `iH`, $i_t$ | 投资 | (F9), 资本运动方程 |
| endogenous | `aH`, $a_t$ | 技术状态 | (F23) |
| endogenous | `c_eH`, $c_t^e$ | 企业家消费 | 资源约束, 净值 |
| endogenous | `gH`, $g_t$ | 政府支出 | (F22) |
| endogenous | `pi_t1H` | 一期前瞻通胀辅助变量 | Phillips 时序辅助 |
| endogenous | `premiumH` | 外部融资溢价 | (F7) |

### 外生冲击

| 类别 | ASCII | 含义 |
|---|---|---|
| exogenous | `e_a` | 技术创新 |
| exogenous | `e_g` | 政府支出创新 |
| exogenous | `e_rn` | 货币政策创新 |

### 参数

| 类别 | ASCII / 符号 | 含义 |
|---|---|---|
| parameter | `betav`, $\beta$ | 贴现因子 |
| parameter | `alphav`, $\alpha$ | 资本份额 |
| parameter | `omegav`, $\Omega$ | 家庭劳动份额参数 |
| parameter | `deltav`, $\delta$ | 折旧 |
| parameter | `phiv`, $\varphi$ | 资本价格对投资资本比率的弹性 |
| parameter | `thetav`, $\theta$ | Calvo 不重设概率 |
| parameter | `kappav`, $\kappa$ | Phillips 曲线斜率复合项 |
| parameter | `etav`, $\eta$ | 劳动供给弹性参数 |
| parameter | `rhov`, $\rho$ | 政策规则平滑 |
| parameter | `rhov_a`, $\rho_a$ | 技术持续性 |
| parameter | `rhov_g`, $\rho_g$ | 政府支出持续性 |
| parameter | `zetav`, $\varsigma$ | 政策规则中的通胀系数 |
| parameter | `muv`, $\mu$ | 监测/审计成本 |
| parameter | `gammav`, $\gamma$ | 企业家存活概率 |
| parameter | `sigmav` | 对数正态特质冲击方差参数 |
| parameter | `X` | 稳态总加成 |
| parameter | `R`, $R$ | 稳态实际无风险毛利率 |
| parameter | `R_K`, $R^K$ | 稳态资本回报 |
| parameter | `s` | 稳态外部融资溢价 |
| parameter | `KN` | 资本净值比率 |
| parameter | `CY`, `GY`, `C_EY`, `IY` | 支出份额 |
| parameter | `YK`, `NY`, `DY`, `YN` | 稳态产出/资本/净值/存款比率 |
| parameter | `niv`, $\nu$ | 外部融资溢价对杠杆的弹性 |
