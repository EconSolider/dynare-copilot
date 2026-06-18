# NK_DT12 - 推导

> 用途：为后续 Dynare 复现准备的私有 MMB 模型档案推导。未执行运行时验证。

来源：Fiorella De Fiore and Oreste Tristani, "Optimal Monetary Policy in a Model of the Credit Channel", *The Economic Journal* 123(571), 906-931, DOI `10.1111/j.1468-0297.2012.02558.x`。

出处记录：模型 id `NK_DT12`；MinerU run `286bd0e5-2870-46db-bfc4-1f7b2fbf2f3c`；源 Markdown `raw/mmb_mineru/runs/nk_dt12__optimal_monetary_policy_in_a_model_of_the_credit_channel__286bd0e5/full.md`；原始 PDF `raw/mmb_papers/Optimal Monetary Policy in a Model of the Credit Channel.pdf`。

## 1. Model Overview

- **模型**：含信用渠道、名义债务合约、 costly state verification 和 Calvo 定价的小型新凯恩斯模型。
- **主体**：代表性家庭、风险中性的企业家/批发企业、完全竞争的金融中介、垄断竞争的零售企业和货币当局。
- **核心机制**：批发企业必须在生产前融资支付工资；个体违约风险和监督成本产生内生的贷款-存款利差。
- **政策对象**：论文使用线性化均衡系统和二阶福利近似，研究 Taylor 规则动态和承诺下的 Ramsey 最优政策。
- **模型形式**：论文侧均衡先以非线性形式给出，再在零通胀稳态附近对数线性化，并写成相对有效均衡的缺口形式。MMB 实现使用带 `exp(.)` 的对数变量非线性方程，而不是 Dynare `model(linear)`。
- **资本**：基准模型没有资本。生产对劳动是线性的；企业每期收到外生内部资金 $`\tau_t`$。内生内部资金版本是独立于基准 `NK_DT12` 核心的扩展。

## 2. Optimization Problems

### 2.1 家庭

在 $`t`$ 期初，家庭把名义财富 $`W_t`$ 分配到货币、状态或有债券和一期存款。名义财富演化为：

**(F1) Household nominal wealth accumulation**

```math
W_{t+1}=Z_{t+1}+R_t^dD_t+R_t^m\left(M_t+P_tw_th_t+V_t-P_tc_t-T_t\right).
```

家庭最大化：

**(F2) Household preferences**

```math
E_0\sum_{t=0}^{\infty}\beta^t\left[u(c_t)+\kappa(m_t)-v(h_t)\right],
```

约束为：

**(F3) Household portfolio budget**

```math
M_t+D_t+E_t(Q_{t,t+1}Z_{t+1})\leq W_t.
```

在化简系统中，论文采用：

**(F4) Functional form for household utility**

```math
U(c_t,h_t)=\frac{c_t^{1-\sigma^{-1}}}{1-\sigma^{-1}}-\psi\frac{h_t^{1+\varphi}}{1+\varphi}.
```

由于假设存款回报和货币回报之间的利差为常数，货币需求可递归处理，因此化简系统中的家庭 Euler 方程与基准 NK 结构一致。

### 2.2 批发企业和企业家

批发企业 $`i`$ 使用劳动和个体生产率：

**(F5) Wholesale production**

```math
y_{i,t}=A_t\omega_{i,t}l_{i,t}.
```

企业必须在生产前借款来支付劳动成本。总资金 $`P_tx_{i,t}`$ 满足：

**(F6) Working-capital financing constraint**

```math
x_{i,t}\geq w_tl_{i,t}.
```

企业在融资约束下选择劳动/资金。由于 (F6) 以等号成立，最优性给出：

**(F7) Financial markup and real wage relation**

```math
q_t=\frac{A_t}{w_t\chi_t}.
```

**(F8) Expected wholesale revenue condition**

```math
\mathcal{E}(y_{i,t})=\chi_tq_tx_{i,t}.
```

企业家对消费具有线性效用，并在偿还贷款后消费最终品。

### 2.3 金融中介和债务合约

银行吸收家庭存款并向企业贷款。个体冲击由企业家私下观察，中介可以用成本 $`\mu P_tx_{i,t}`$ 监督。令 $`\bar{\omega}_t`$ 为违约阈值。定义企业家和贷款人的产出份额：

**(F9) Entrepreneur share under the debt contract**

```math
f(\bar{\omega}_t)=\int_{\bar{\omega}_t}^{\infty}\omega\,\Phi(d\omega)-\bar{\omega}_t\left[1-\Phi(\bar{\omega}_t)\right].
```

**(F10) Lender share under the debt contract**

```math
g(\bar{\omega}_t)=\int_{0}^{\bar{\omega}_t}\omega\,\Phi(d\omega)-\mu\Phi(\bar{\omega}_t)+\bar{\omega}_t\left[1-\Phi(\bar{\omega}_t)\right].
```

论文说明最优合约由在线附录推导。Markdown 中报告的合约最优性条件为：

**(F11) Financial markup from costly state verification**

```math
q_t=\frac{R_t}{1-\mu\Phi(\bar{\omega}_t)+\frac{\mu f(\bar{\omega}_t)\phi(\bar{\omega}_t)}{f_{\bar{\omega}}(\bar{\omega}_t)}}.
```

**(F12) Total production funds**

```math
x_t=\frac{R_t\tau_t}{R_t-q_tg(\bar{\omega}_t)}.
```

贷款总利率可以从债务偿还条件反推出，并可概括为：

**(F13) Loan-deposit spread**

```math
\Delta_t=\frac{\bar{\omega}_t}{g(\bar{\omega}_t)}.
```

### 2.4 零售企业

零售商购买同质批发品、无成本差异化，并受 Calvo 刚性约束设定价格。Markdown 说明定价由在线附录 B 描述；正文在化简系统中使用所得 Phillips 曲线。

## 3. First-Order Conditions

论文侧 Markdown 中可见的一阶条件和最优性条件是 (F7)-(F13)，以及下面的化简条件。Calvo 重设价格递归依赖附录，升级前需源级恢复，故标记为 `needs_review`。

定义通胀 $`\pi_{t+1}=\log(P_{t+1}/P_t)`$，生产率 $`a_t=\log A_t`$，内部资金冲击 $`\hat{\tau}_t=\log\tau_t`$。令 $`\tilde{Y}_t`$ 表示相对有效产出的产出缺口。对数线性化的基准均衡为：

**(F14) Credit-spread relation**

```math
\delta_1\hat{\Delta}_t=\left(1+\varphi+\sigma^{-1}\frac{Y}{c}\right)\tilde{Y}_t-\sigma^{-1}\frac{e}{c}\hat{R}_t+\xi_{1,t}.
```

**(F15) IS curve with credit channel**

```math
\tilde{Y}_t=E_t\tilde{Y}_{t+1}-\sigma\left(\frac{1+\sigma^{-1}\frac{e}{c}}{1-\varphi\frac{e}{c}}\right)(\hat{R}_t-E_t\pi_{t+1})
-\left(\frac{\alpha_1-\alpha_2\frac{e}{c}}{1-\varphi\frac{e}{c}}\right)(\hat{\Delta}_t-E_t\hat{\Delta}_{t+1})
+\frac{\frac{e}{c}}{1-\varphi\frac{e}{c}}(\hat{R}_t-E_t\hat{R}_{t+1})+\xi_{2,t}.
```

**(F16) Phillips curve with nominal-rate and spread terms**

```math
\pi_t=\bar{\kappa}\left[(\sigma^{-1}\alpha_1+\alpha_2)\hat{\Delta}_t+(\sigma^{-1}+\varphi)\tilde{Y}_t+\hat{R}_t+\xi_{3,t}\right]+\beta E_t\pi_{t+1}.
```

用于经验比较时，论文把 Phillips 曲线改写为平均实际边际成本 $`u_t`$ 的形式：

**(F17) Marginal-cost Phillips curve**

```math
\hat{\pi}_t=\lambda(\hat{u}_t+\hat{R}_t+\alpha_2\hat{\Lambda}_t)+\beta E_t\hat{\pi}_{t+1}.
```

该经验方程的 GMM 矩条件为：

**(F18) GMM orthogonality condition**

```math
E_t\left\{\left[\theta\hat{\pi}_t-(1-\theta)(1-\theta\beta)\left(\frac{\hat{u}_t}{\zeta}+\eta\frac{\hat{R}_t}{\zeta}+\alpha_2\frac{\hat{\Delta}_t}{\zeta}\right)-\theta\beta\hat{\pi}_{t+1}\right]\mathbf{z}_t\right\}=0.
```

## 4. Market Clearing & Identities

论文侧 Markdown 隐含以下总量条件：

**(F19) Aggregate entrepreneurial consumption**

```math
e_t=f(\bar{\omega}_t)q_tx_t.
```

使用合约方程后，企业家消费可写为：

**(F20) Entrepreneurial consumption in reduced form**

```math
e_t=\tau_tR_t\left[1+\frac{\mu\phi(\bar{\omega}_t)}{f_{\bar{\omega}}(\bar{\omega}_t)}\right]^{-1}.
```

最终零售产出用于家庭消费和企业家消费：

**(F21) Resource identity**

```math
Y_t=c_t+e_t.
```

批发品平均实际边际成本为：

**(F22) Average wholesale real marginal cost**

```math
u_t=\frac{w_th_t}{y_t}.
```

零售边际成本可由批发边际成本和金融加价表示：

**(F23) Retail marginal-cost identity**

```math
\chi_t^{-1}=u_tq_t.
```

对于第 2 节讨论的含资本经验扩展，该式变为：

**(F24) Capital-extension marginal-cost identity**

```math
\chi_t^{-1}=\frac{q_tu_t}{a}.
```

## 5. Exogenous Processes

基准论文侧文本识别了总生产率和企业内部资金冲击。Taylor 规则模拟加入货币政策冲击。MMB 实现还包括监督成本和个体风险离散度冲击；这些作为实现交叉检查变量记录，不在本一稿中作为单独推导的论文侧方程。

**(F25) Productivity process**

```math
a_t=\rho_a a_{t-1}+\varepsilon^A_t.
```

**(F26) Internal-funds shock process**

```math
\hat{\tau}_t=\rho_{\tau}\hat{\tau}_{t-1}+\varepsilon^{\tau}_t.
```

对于 Taylor 规则实验：

**(F27) Monetary policy shock process**

```math
u_t^p=\rho_pu_{t-1}^p+\varepsilon^p_t.
```

基准脉冲响应使用的货币政策规则为：

**(F28) Taylor-type policy rule**

```math
R_t=-\ln\beta+1.5\hat{\pi}_t+0.5\tilde{Y}_t+u_t^p.
```

内生内部资金扩展，而非基准核心，具有：

**(F29) Endogenous internal-funds extension**

```math
\pi_tb_t=(1-\gamma)\left[1+\frac{\mu\phi(\bar{\omega}_t)}{f_{\bar{\omega}}(\bar{\omega}_t)}\right]^{-1}R_tb_{t-1}\varepsilon_t^v.
```

## 6. Steady-State Solution

源文说明非线性系统在零通胀稳态附近对数线性化，然后写成相对有效均衡的偏离。详细稳态公式由在线附录 C 给出，但本条目没有本地规范化附录源；因此本节为 `needs_review`。

正文中直接可见的稳态约束为：

**(F30) Zero-inflation steady state**

```math
\pi=0.
```

**(F31) Deposit-rate steady state from the Taylor rule**

```math
R=-\ln\beta.
```

**(F32) Steady-state spread target**

```math
\Delta=\frac{\bar{\omega}}{g(\bar{\omega})}.
```

**(F33) Steady-state financial markup**

```math
q=\frac{R}{1-\mu\Phi(\bar{\omega})+\frac{\mu f(\bar{\omega})\phi(\bar{\omega})}{f_{\bar{\omega}}(\bar{\omega})}}.
```

**(F34) Steady-state funds**

```math
x=\frac{R\tau}{R-qg(\bar{\omega})}.
```

**(F35) Steady-state entrepreneurial consumption**

```math
e=\tau R\left[1+\frac{\mu\phi(\bar{\omega})}{f_{\bar{\omega}}(\bar{\omega})}\right]^{-1}.
```

正文中的校准说明：$`\mu=0.12`$；个体冲击服从对数正态；$`\sigma_{\omega}`$ 和补贴被校准到年化稳态利差约 2% 且季度破产率约 1%；$`\varepsilon=11`$；$`\theta=0.66`$；$`\rho_a=0.9`$；$`\rho_{\tau}=0.7317`$。

## 7. Timing & Form Conventions

- 金融市场在期初、总量冲击实现后开启。企业在生产前借款支付劳动成本。
- 商品市场在金融合约之后开启。批发产出实现、出售给零售商，并在期末偿还贷款或违约。
- 贷款是一期名义合约；源文记号中的存款利率和贷款利率均为名义总利率。
- 基准模型没有资本存量，因此核心模型不存在生产性资本的时序约定。
- $`x_t`$ 在期内个体生产率观测前、但总量冲击实现后决定。
- $`\bar{\omega}_t`$ 是同期期金融合约中选择的违约阈值。
- 本推导结合了非线性论文侧合约方程和对数线性化化简方程 (F14)-(F16)。这种混合展示遵循论文。最终 Dynare 复现应选择单一实现约定并记录。

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Equation reference |
|---|---|---|---|
| Endogenous | $`W_t`$ / `wealth` | 家庭名义财富 | (F1) |
| Endogenous | $`c_t`$ / `cons_h` | 家庭消费 | (F2), (F21) |
| Endogenous | $`h_t`$ / `labor` | 家庭劳动 | (F4), (F6) |
| Endogenous | $`D_t`$ / `deposits` | 家庭存款 | (F3) |
| Endogenous | $`y_{i,t}`$ / `y_i` | 批发企业产出 | (F5) |
| Endogenous | $`Y_t`$ / `y_t` | 总最终产出 | (F14)-(F16), (F21) |
| Endogenous | $`x_t`$ / `credit` | 生产资金 / 信用 | (F6), (F12) |
| Endogenous | $`q_t`$ / `q_t` | 金融加价 | (F7), (F11), (F23) |
| Endogenous | $`\chi_t`$ / `chi_t` | 零售加价项 | (F7), (F23) |
| Endogenous | $`\bar{\omega}_t`$ / `omeg_t` | 破产阈值 | (F9)-(F13) |
| Endogenous | $`\Delta_t`$ / `spread` | 贷款-存款利差 | (F13), (F14) |
| Endogenous | $`e_t`$ / `cons_e` | 企业家消费 | (F19), (F20) |
| Endogenous | $`\pi_t`$ / `infl` | 通胀 | (F16), (F17), (F18) |
| Endogenous | $`\tilde{Y}_t`$ / `ygap` | 产出缺口 | (F14)-(F16), (F28) |
| Endogenous | $`R_t`$ / `i_dep` | 存款/政策名义利率 | (F11), (F15), (F28) |
| Endogenous | $`u_t`$ / `mon_cost` or `u` | 平均实际边际成本 / 监督成本记号取决于上下文 | (F22), (F17) |
| Exogenous | $`A_t`$ / `a_t` | 总生产率 | (F5), (F25) |
| Exogenous | $`\tau_t`$ / `tau_t` | 企业内部资金 | (F12), (F20), (F26) |
| Exogenous | $`u_t^p`$ / `pol_t` | 货币政策冲击 | (F27), (F28) |
| Exogenous | $`\varepsilon_t^A`$ / `epsA` | 生产率创新 | (F25) |
| Exogenous | $`\varepsilon_t^\tau`$ / `epstau` | 内部资金创新 | (F26) |
| Exogenous | $`\varepsilon_t^p`$ / `epspol` | 货币政策创新 | (F27) |
| Parameter | $`\beta`$ / `bet` | 贴现因子 | (F2), (F28) |
| Parameter | $`\sigma`$ / `sig` | 效用中的跨期弹性记号 | (F4), (F14)-(F18) |
| Parameter | $`\varphi`$ / `phi` | 劳动负效用曲率 | (F4), (F14)-(F16) |
| Parameter | $`\psi`$ / `psai` | 劳动负效用权重 | (F4) |
| Parameter | $`\mu`$ / `mu_hat` | 监督成本份额 | (F10), (F11), (F20) |
| Parameter | $`\theta`$ / `thet` | Calvo 不重设价格概率 | (F18) |
| Parameter | $`\varepsilon`$ / `epsil` | 替代弹性 | model overview / Calvo block |
| Parameter | $`\alpha_1,\alpha_2,\delta_1`$ | 来自附录缺口定义的系数 | (F14)-(F16) |
| Parameter | $`\bar{\kappa}`$ | Phillips 曲线斜率复合项 | (F16) |
| Parameter | $`\rho_a,\rho_{\tau},\rho_p`$ | 冲击持久性 | (F25)-(F27) |

实现交叉检查：`.agents/skills/dynare-copilot/references/examples/NK_DT12_rep.mod` 使用的 MMB 对数变量包括 `cons_h`, `i_dep`, `infl`, `omeg_t`, `s_t`, `chi_t`, `thet1_t`, `thet2_t`, `y_t`, `spread`, `q_t`, `ygap`, `cons_e`, `mon_cost`, `Bankrupt`, `fo_t`, `ho_t`, `i_l`, `credit`, `stdoi_t`, `i_e`, `y_e`, `a_t`, `mu_t`, `pol_t`, and `tau_t`。这些名称仅用于覆盖范围对齐；除明确标记为实现交叉检查外，上述方程均来自论文侧 Markdown。
