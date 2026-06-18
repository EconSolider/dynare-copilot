# RBC_DTT11 -- 推导

> MMB 模型档案的一阶来源支撑推导。未执行运行时验证。

## 1. Model Overview

- **模型 ID**：`RBC_DTT11`。
- **论文**：Fiorella De Fiore, Pedro Teles, and Oreste Tristani (2011), "Monetary Policy and the Financing of Firms," *American Economic Journal: Macroeconomics*, 3(4), 112-142, DOI `10.1257/mac.3.4.112`。
- **来源**：`raw/mmb_mineru/runs/rbc_dtt11__monetary_policy_and_the_financing_of_firms__d32dcd23/full.md`；原始 PDF `raw/mmb_papers/Monetary policy and the financing of firms.pdf`；MinerU run `d32dcd23-cfeb-4a15-88ac-25e2cb169c6e`。
- **模型形式**：带灵活价格、名义预定企业融资和 costly-state-verification 违约机制的随机 RBC 风格货币模型。论文给出非线性均衡限制，但 Rep-MMB 实现记录 `fo_t`, `CapG_t`, `co_t`, `ho_t`, `dumnum_t`, `dumden_t`, `Util`, `Welf` 为水平线性化，其余变量为对数线性化。
- **MMB 实现实验**：简单 Taylor 规则结果、政府支出份额固定、且无企业家消费。`.mod` 文件仅作为 `implementation_cross_check` 使用；未运行 Dynare。
- **主体**：家庭、企业家/企业、银行/金融中介、政府/中央银行。
- **核心机制**：企业必须使用上一期带入的名义内外部资金支付工资。总量冲击在融资决策固定后到达，因此政策通过价格水平和名义利率影响实际资金和实际债务。企业特质生产率为私人信息，并通过最优债务合约产生破产/违约。
- **抽取状态**：`needs_review`。主要均衡块和 Appendix B 可读，但若干 OCR 规范化公式和实现简化需要源文件级复核后才能最终提升。

## 2. Optimization Problems

### 2.1 家庭

家庭选择消费、劳动、货币、存款和名义状态或有债券。货币效用可分，并在档案核心中视为可忽略。

```math
\max_{\{c_t,n_t,M_t,D_t,B_{t,t+1}\}} E_0 \sum_{t=0}^{\infty} \beta^t
\left[u(c_t,m_t)-\alpha n_t\right],
```

约束为名义预算约束

```math
M_t + \sum_{s^{t+1}|s^t} Q_{t,t+1} B_{t,t+1} + D_t
\leq B_t + R_{t-1}^d D_{t-1} + M_{t-1} - P_t c_t + W_t n_t - T_t^h.
```

其中 $`m_t=M_{t-1}/P_t`$，$`R_t^d`$ 是安全存款毛利率，$`Q_{t,t+1}`$ 是名义状态或有债券价格。

### 2.2 企业家/企业与金融合约

每个企业 $`i`$ 只使用劳动生产：

```math
y_{i,t}=\omega_{i,t} A_t N_{i,t},
```

其中 $`\omega_{i,t}`$ 是特质生产率，分布为 $`\Phi`$、密度为 $`\phi`$、均值为 1，并有时变风险 $`\sigma_{\omega,t}`$。总量技术过程为 $`A_t`$。

企业必须在期初使用预定名义总资金支付工资：

```math
W_t N_{i,t} \leq X_{i,t-1}.
```

总资金由内部资金和银行借款构成：

```math
X_{i,t-1}=Z_{i,t-1}+\left(X_{i,t-1}-Z_{i,t-1}\right).
```

最优债务合约设定贷款偿付 $`R_{i,t-1}^l(X_{i,t-1}-Z_{i,t-1})`$。破产阈值 $`\bar{\omega}_{i,t}`$ 满足

```math
P_t A_t \bar{\omega}_{i,t} N_{i,t}
=R_{i,t-1}^l\left(X_{i,t-1}-Z_{i,t-1}\right).
```

定义企业家和银行获得的产出份额为

```math
f(\bar{\omega}_t)
=\int_{\bar{\omega}_t}^{\infty}(\omega_t-\bar{\omega}_t)\,\Phi(d\omega),
```

```math
g(\bar{\omega}_t;\mu_t)
=\int_0^{\bar{\omega}_t}(1-\mu_t)\omega_t\,\Phi(d\omega)
+\int_{\bar{\omega}_t}^{\infty}\bar{\omega}_t\,\Phi(d\omega),
```

监测损失函数为

```math
G(\bar{\omega}_t)=\int_0^{\bar{\omega}_t}\omega_t\,\Phi(d\omega),
```

因此

```math
f(\bar{\omega}_t)+g(\bar{\omega}_t;\mu_t)
=1-\mu_t G(\bar{\omega}_t).
```

令

```math
z_{t-1}\equiv \frac{Z_{i,t-1}}{X_{i,t-1}},
\qquad
\nu_t\equiv \frac{P_t A_t}{W_t}.
```

合约选择 $`(R_{i,t-1}^l,X_{i,t-1},\bar{\omega}_{i,t},N_{i,t})`$ 来最大化企业家预期产出：

```math
\max E_{t-1}\left[f(\bar{\omega}_{i,t})P_t A_t N_{i,t}\right],
```

约束包括工资融资可行性、银行参与和企业家参与：

```math
W_t N_{i,t}\leq X_{i,t-1},
```

```math
E_{t-1}\left[g(\bar{\omega}_{i,t};\mu_t)P_t A_t N_{i,t}\right]
\geq R_{t-1}^d\left(X_{i,t-1}-Z_{i,t-1}\right),
```

```math
E_{t-1}\left[f(\bar{\omega}_{i,t})P_t A_t N_{i,t}\right]
\geq R_{t-1}^d Z_{i,t-1}.
```

### 2.3 银行

银行是零利润金融中介。它们接受家庭存款，并通过上述合约向企业家贷款。政府的存款保险、税收和补贴使银行逐状态零利润，因此家庭存款获得安全利率。

### 2.4 政府与货币当局

政府消费是扣除监测损失后产出的固定份额 $`g`$。在 Taylor 规则实现中，货币当局按通胀偏离设定存款/政策利率。

## 3. First-Order Conditions

- **(F1) 家庭劳动供给条件**：

```math
\frac{u_c(t)}{\alpha}=\frac{P_t}{W_t}.
```

- **(F2) 状态或有债券定价条件**：

```math
\frac{u_c(t)}
{\beta\,\Pr(s^{t+1}|s^t)\,u_c(t+1)}
=Q_{t,t+1}^{-1}\frac{P_t}{P_{t+1}}.
```

- **(F3) 存款 Euler 方程**：

```math
\frac{u_c(t)}{P_t}
=R_t^d E_t\left[\frac{\beta u_c(t+1)}{P_{t+1}}\right].
```

- **(F4) 货币需求条件**：

```math
E_t\left[\frac{u_m(t+1)}{P_{t+1}}\right]
=E_t\left[\frac{u_c(t+1)}{P_{t+1}}\right](R_t^d-1).
```

- **(F5) 破产阈值**：

```math
\bar{\omega}_t=\frac{R_{t-1}^l(1-z_{t-1})}{\nu_t}.
```

- **(F6) 企业家产出份额**：

```math
f(\bar{\omega}_t)
=\int_{\bar{\omega}_t}^{\infty}(\omega_t-\bar{\omega}_t)\,\Phi(d\omega).
```

- **(F7) 银行产出份额**：

```math
g(\bar{\omega}_t;\mu_t)
=\int_0^{\bar{\omega}_t}(1-\mu_t)\omega_t\,\Phi(d\omega)
+\int_{\bar{\omega}_t}^{\infty}\bar{\omega}_t\,\Phi(d\omega).
```

- **(F8) 监测损失恒等式**：

```math
f(\bar{\omega}_t)+g(\bar{\omega}_t;\mu_t)
=1-\mu_t G(\bar{\omega}_t).
```

- **(F9) 最优合约，企业家回报条件**：

```math
E_{t-1}\left[\nu_t f(\bar{\omega}_t)\right]
=
\frac{R_{t-1}^d}
{1-\frac{E_{t-1}\left[\mu_t\bar{\omega}_t\phi(\bar{\omega}_t)\right]}
{E_{t-1}\left[1-\Phi(\bar{\omega}_t)\right]}}
z_{t-1}.
```

- **(F10) 最优合约，银行零利润条件**：

```math
E_{t-1}\left[\nu_t g(\bar{\omega}_t;\mu_t)\right]
=R_{t-1}^d(1-z_{t-1}).
```

- **(F11) 由家庭期内最优性得到的 wedge/markup 定义**：

```math
\nu_t=\frac{u_c(t)A_t}{\alpha}.
```

- **(F12) 企业家内部资金积累**：

```math
Z_t=(1-\gamma_t)f(\bar{\omega}_t)P_t A_t N_t.
```

- **(F13) 内部资金积累的递归比率形式**：

```math
Z_t=(1-\gamma_t)f(\bar{\omega}_t)\frac{\nu_t}{z_{t-1}}Z_{t-1}.
```

- **(F14) 无企业家消费极限之前的企业家消费**：

```math
c_t^e=\frac{\gamma_t f(\bar{\omega}_t)A_t N_t}{1+\tau}.
```

MMB 实现说明企业家消费被关闭；该条件作为论文侧 provenance 保留，而不是作为活跃的 MMB 资源方程。

## 4. Market Clearing & Identities

- **(F15) 工资融资约束取等号**：

```math
W_t N_{i,t}=X_{i,t-1}.
```

- **(F16) 总生产与劳动加总**：

```math
Y_t=A_t N_t,
\qquad
\int N_{i,t}\,di=N_t=n_t.
```

- **(F17) 内部资金占总资金份额**：

```math
Z_t=z_t X_t.
```

- **(F18) 预定实际资金关系**：

```math
\frac{Z_{t-1}}{P_t}
=z_{t-1}\frac{A_t}{\nu_t}N_t.
```

- **(F19) 带政府支出份额和监测损失的资源约束**：

```math
c_t=(1-g)A_t N_t\left[1-\mu_t G(\bar{\omega}_t)\right].
```

- **(F20) 结合合约和 markup wedge 的 implementability 条件**：

```math
E_{t-1}\left[
\frac{u_c(t)A_t}{\alpha}
\left(
1-\mu_t G(\bar{\omega}_t)
-f(\bar{\omega}_t)
\frac{E_{t-1}\left[\mu_t\bar{\omega}_t\phi(\bar{\omega}_t)\right]}
{E_{t-1}\left[1-\Phi(\bar{\omega}_t)\right]}
\right)
\right]
=R_{t-1}^d.
```

`needs_review`：OCR 来源给出了清楚的结构，但在最终使用前应对照 PDF 检查符号以及 $`f(\bar{\omega}_t)`$ 乘子的分组位置。

- **(F21) 简单规则模拟使用的 Taylor 型政策规则**：

```math
\hat{r}_t^d=1.5\,\hat{\pi}_t.
```

Rep-MMB `.mod` 实现了毛利率/对数线性化对应式：

```math
R_t^d=\frac{1.0025}{\beta}
\left(\frac{\Pi_t}{1.0025}\right)^{\zeta}\exp(\varepsilon_t^{pol}),
\qquad \zeta=1.5,
```

其中记号按实现调整。该方程是实现交叉检查，不是独立论文侧来源。

## 5. Exogenous Processes

- **(F22) 技术过程**：

```math
a_t=\rho_a a_{t-1}+\varepsilon_t^A,
\qquad a_t\equiv \log A_t.
```

- **(F23) 监测成本过程**：

```math
\mu_t=(1-\rho_\mu)\log(\mu)+\rho_\mu\mu_{t-1}+\varepsilon_t^\mu.
```

- **(F24) 企业家死亡/内部资金冲击**：

```math
\gamma_t=(1-\rho_\gamma)\log(\gamma)+\rho_\gamma\gamma_{t-1}+\varepsilon_t^\gamma.
```

- **(F25) 特质风险过程**：

```math
\sigma_{\omega,t}=(1-\rho_\sigma)\log(\sigma_\omega)+\rho_\sigma\sigma_{\omega,t-1}+\varepsilon_t^\sigma.
```

- **(F26) 货币政策冲击过程**：

```math
pol_t=\rho_{pol}pol_{t-1}+\varepsilon_t^{pol}.
```

`needs_review`：Rep-MMB 文件将政策冲击持久性设为 `rho_a`；这可能是有意简写，也可能是复制实现细节。

## 6. Steady-State Solution

论文的稳态系统使用毛通胀 $`\Pi`$、存款利率 $`R^d`$、markup/wedge $`\nu`$、内部资金份额 $`z`$、破产阈值 $`\bar{\omega}`$ 和贷款利率 $`R^l`$。

1. 存款 Euler 条件：

```math
\frac{1}{\beta}=\frac{R^d}{\Pi}.
```

2. 名义内部资金增长率等于通胀：

```math
\Pi=(1-\gamma)\frac{f(\bar{\omega})\nu}{z}.
```

3. 企业家内部资金毛回报：

```math
R^e\equiv\frac{f(\bar{\omega})\nu}{z}
=
\frac{R^d}
{1-\mu\frac{\bar{\omega}\phi(\bar{\omega})}{1-\Phi(\bar{\omega})}}.
```

4. 银行零利润条件：

```math
\frac{g(\bar{\omega};\mu)\nu}{1-z}=R^d.
```

5. 破产阈值：

```math
\bar{\omega}=\frac{R^l(1-z)}{\nu}.
```

6. 独立于平均通胀的阈值方程：

```math
\frac{1-\gamma}{\beta}
=1-\frac{\mu\bar{\omega}\phi(\bar{\omega})}{1-\Phi(\bar{\omega})}.
```

7. 稳态 implementability 条件：

```math
\frac{u_c A}{\alpha}
=
\frac{R^d}
{1-\mu G(\bar{\omega})
-f(\bar{\omega})
\frac{\mu\bar{\omega}\phi(\bar{\omega})}{1-\Phi(\bar{\omega})}}.
```

`needs_review`：与 (F20) 一样，OCR 分母在机械使用前需要检查精确分组。

8. 资源约束：

```math
c=(1-g)AN\left[1-\mu G(\bar{\omega})\right].
```

9. 来自实现交叉检查的校准锚：

```math
\beta=0.99,\quad \alpha=5.0,\quad \sigma=1.0,\quad \mu=0.12,\quad \gamma=0.06,\quad
\sigma_\omega=0.07,\quad g=0.02,\quad \zeta=1.5.
```

稳态求解顺序为：选择/校准 $`(\beta,\alpha,\sigma,\mu,\gamma,\sigma_\omega,g,\Pi)`$；由阈值方程求 $`\bar{\omega}`$；求 $`R^d=\Pi/\beta`$；由合约和阈值方程求 $`(\nu,z,R^l)`$；再由 implementability 与资源约束求 $`N`$ 和 $`c`$。Rep-MMB 初始值提供一个对数线性化点，但本任务未用 Dynare 验证。

## 7. Timing & Form Conventions

- 金融变量 $`X_{t-1}`$、$`Z_{t-1}`$、$`z_{t-1}`$ 和 $`R_{t-1}^l`$ 在 $`t`$ 期总量冲击实现时已经预定。
- 企业在总量冲击后、特质生产率被观察前雇佣劳动并生产。
- 违约/破产在生产后通过 $`\bar{\omega}_t`$ 决定。
- 存活企业家将内部资金带到下一期；死亡概率 $`\gamma_t`$ 从积累过程中移除一部分企业家资金。
- 价格水平和通胀影响预定资金与债务负债的实际价值。
- 论文推导非线性均衡限制，但研究对数线性动态。Rep-MMB 文件将若干辅助对象做水平线性化，其余变量做对数线性化。
- 未执行运行时验证、BK 检查或 IRF 复现。

## 8. Variable & Parameter Reference Table

| 类别 | 符号 / ASCII 名称 | 含义 | 主要方程 |
|---|---|---|---|
| 内生 | $`c_t`$ / `c_t` | 家庭消费 | (F3), (F19) |
| 内生 | $`n_t,N_t`$ / `n_t` | 劳动 | (F1), (F15), (F16) |
| 内生 | $`Y_t`$ / `y_t` | 产出 | (F16) |
| 内生 | $`P_t,\Pi_t`$ / `pi_t` | 价格水平与通胀 | (F3), (F21) |
| 内生 | $`R_t^d`$ / `r_t` | 安全存款/政策利率 | (F3), (F21) |
| 内生 | $`R_t^l`$ / `rl_t` | 贷款利率 | (F5), 稳态阈值 |
| 内生 | $`Z_t`$ / `zbar_t` | 名义内部资金 | (F12), (F13) |
| 内生 | $`z_t`$ / `z_t` | 内部资金占总资金比例 | (F9), (F10), (F17) |
| 内生 | $`X_t`$ | 名义总资金 | (F15), (F17) |
| 内生 | $`\bar{\omega}_t`$ / `omeg_t` | 破产阈值 | (F5) |
| 内生 | $`f(\bar{\omega}_t)`$ / `fo_t` | 企业家产出份额 | (F6) |
| 内生 | $`G(\bar{\omega}_t)`$ / `CapG_t` | 预期被监测产出 | (F8), (F19) |
| 内生 | $`\Phi(\bar{\omega}_t)`$ / `co_t` | 破产概率 | (F7) |
| 内生 | $`\phi(\bar{\omega}_t)`$ / `ho_t` | 阈值处密度 | (F9), (F20) |
| 内生 | $`\nu_t`$ / `ni_t` | markup/wedge $`P_tA_t/W_t`$ | (F11) |
| 内生 | $`\Delta_t`$ / `del_t` | 实现中的信用利差 $`R_t^l/R_t^d`$ | implementation cross-check |
| 内生 | `dumnum_t`, `dumden_t` | 合约辅助分母项 | (F9) |
| 内生 | `Util`, `Welf` | 当期效用和福利递归 | implementation cross-check |
| 外生 | $`A_t`$ / `a_t`, `epsA` | 总量技术 | (F22) |
| 外生 | $`\mu_t`$ / `mu_t`, `epsmu` | 监测成本冲击 | (F23) |
| 外生 | $`\gamma_t`$ / `gam_t`, `epsgam` | 企业家死亡/内部资金冲击 | (F24) |
| 外生 | $`\sigma_{\omega,t}`$ / `std_t`, `epsstd` | 特质风险冲击 | (F25) |
| 外生 | `pol_t`, `epspol` | 货币政策冲击 | (F26) |
| 参数 | $`\beta`$ / `bet` | 家庭贴现因子 | (F3), 稳态 |
| 参数 | $`\alpha`$ / `alf` | 论文/实现记号中的劳动负效用尺度 | (F1) |
| 参数 | $`\sigma`$ / `sig` | 风险厌恶/对数效用参数 | 效用与 Euler 方程 |
| 参数 | $`\mu`$ / `mu` | 监测成本 | (F8), (F20) |
| 参数 | $`\gamma`$ / `gam` | 企业家死亡概率 | (F12), (F24) |
| 参数 | $`\zeta`$ / `zet` | Taylor 规则通胀反应 | (F21) |
| 参数 | $`g`$ / `g` | 政府支出份额 | (F19) |
| 参数 | $`\rho_a,\rho_\mu,\rho_\gamma,\rho_\sigma`$ | 冲击持久性 | (F22)-(F25) |
