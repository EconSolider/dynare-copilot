# NK_RA16 -- 推导（最优化问题 + 一阶条件）

> `NK_RA16` 的模型档案条目。未执行运行时验证。公式状态：`needs_review`，因为来源是 MinerU OCR，且论文说明主要推导放在附录 A，而附录中若干公式存在 OCR 损坏。

来源：Ansgar Rannenberg (2016), "Bank leverage cycles and the external finance premium", *Journal of Money, Credit and Banking*, 48(8), 1569-1612. DOI: `10.1111/jmcb.12359`。

## 1. Model Overview

- **模型**：Rannenberg (2016) 的完整封闭经济 New Keynesian DSGE 模型，结合 Gertler-Karadi 银行杠杆摩擦与 Bernanke-Gertler-Gilchrist/Christiano-Motto-Rostagno 非金融企业家 costly-state-verification 摩擦。
- **MMB 实现目标**：`NK_RA16`；实现交叉检查文件说明它复制论文图 1 和图 2 所用完整模型，并包含可变资本利用率。
- **经济与实验**：美国校准的季度模型。论文比较完整模型与 BGG 型、GK 型、无金融部门模型在货币政策、技术、政府支出、银行净值和企业家净值扰动下的结果。Rep-MMB 文件保留常规冲击用于模拟。
- **主体与模块**：代表性家庭、资本品生产者、带 Calvo 定价和指数化的垄断竞争零售商、受存款人道德风险约束的银行、受 CSV 债务合约约束的企业家、政府和货币当局。
- **形式**：实现交叉检查为 `model(linear)`。论文给出非线性原始问题以及若干一阶/对数偏离条件。带帽变量表示相对稳态的对数偏离；Rep-MMB 实现直接用变量名存储偏离。
- **来源范围**：以下方程来自论文侧 Markdown，尤其是第 1.1-1.6 节和附录 A。`.mod` 文件仅作为 `implementation_cross_check`。

## 2. Optimization Problems

### 2.1 家庭

家庭选择消费、一期期限无风险资产和劳动：

```math
\max_{\{C_t,l_t,B_t,B_t^g\}} E_t \sum_{i=0}^{\infty}\beta^i
\left[\log(C_{t+i}-hC_{t+i-1})-\frac{\chi}{1+\varphi}(l_{t+i}^s)^{1+\varphi}\right].
```

名义预算约束在来源中写为：

```math
P_t C_t = w_tP_t l_t + P_t prof_t + R_{t-1}B_{t-1}-B_t
+ R_t^{gov}B_{t-1}^g - B_t^g.
```

`needs_review`：附录 A 中政府债券记号附近的 OCR 有噪声，但一阶条件表明存款和政府债券是完全替代品。

### 2.2 资本品生产者

资本品生产者由家庭拥有，选择投资并以实际价格 `Q_t` 出售新资本，其贴现利润问题为：

```math
\max_{\{I_t\}} E_t\sum_{i=0}^{\infty}\beta^i
\frac{\varrho_{t+i}}{\varrho_t}
I_{t+i}\left[
Q_{t+i}\left(1-\frac{\eta_i}{2}\left(\frac{I_{t+i}}{I_{t+i-1}}-1\right)^2\right)-1
\right].
```

### 2.3 零售商

零售商在全经济要素市场雇佣劳动和资本服务，使用 Cobb-Douglas 技术，预付部分要素成本，并在带指数化的 Calvo 合约下设定价格。重设价格的零售商在 CES 需求和指数化约束下最大化贴现利润。

### 2.4 银行

银行家风险中性，并以概率 `theta` 存活。银行吸收存款，向企业家发放有风险跨期贷款，并向零售商发放无风险日内营运资本贷款。吸收存款后，银行家可以转移企业家贷款中的 `lambda` 份额，因此存款人要求：

```math
V_t^b(q) \ge \lambda L_t^e(q).
```

银行家 `q` 的价值为：

```math
V_t^b(q)=E_t\left\{\sum_{i=0}^{\infty}(1-\theta)\theta^i
\left(\frac{1}{\prod_{j=0}^i R_{t+1+j}^r}\right)N_{t+1+i}^b(q)\right\},
\qquad R_{t+1}^r=\frac{R_t}{\Pi_{t+1}}.
```

论文校准 `lambda`，使激励相容约束在局部均衡中绑定。

### 2.5 企业家

风险中性企业家在 `t` 期末用净值和银行贷款购买资本：

```math
P_tL_t^j=P_t(Q_tK_t^j-N_t^j).
```

贷款合约受到对数正态个体风险 `omega`、监控成本 `mu` 和违约阈值 `\bar{\omega}_{t+1}` 约束：

```math
\bar{\omega}_{t+1}^j R_{t+1}^K P_tQ_tK_t^j
=R_t^L P_tL_t^j.
```

企业家选择杠杆和贷款合约以在银行参与约束下最大化预期权益。

### 2.6 政府与货币当局

政府支出模块在实现交叉检查中是外生的。货币政策通过含平滑项、通胀响应和以实际边际成本代理产出缺口的响应项来设定无风险名义利率。

## 3. First-Order Conditions

**(F1) 带内部习惯的家庭边际效用**

```math
\varrho_t =
\frac{1}{C_t-hC_{t-1}}
-\beta h E_t\left[\frac{1}{C_{t+1}-hC_t}\right].
```

**(F2) 无风险存款 Euler 方程**

```math
\varrho_t=\beta E_t\left[\varrho_{t+1}\frac{R_t}{\Pi_{t+1}}\right].
```

**(F3) 政府债券 Euler 方程与资产替代条件**

```math
\varrho_t=\beta E_t\left[\varrho_{t+1}\frac{R_t^{gov}}{\Pi_{t+1}}\right],
\qquad R_t=R_t^{gov}.
```

**(F4) 家庭劳动供给**

```math
\varrho_t w_t=\chi l_t^{\varphi}.
```

**(F5) 实现中使用的线性边际效用方程**

```math
\hat{\varrho}_t=
\frac{1}{(1-h)(1-\beta h)}
\left[-(\hat{C}_t-h\hat{C}_{t-1})
+\beta h(\hat{C}_{t+1}-h\hat{C}_t)\right].
```

**(F6) 线性无风险 Euler 方程**

```math
\hat{R}_t+\hat{\Lambda}_{t+1}-\hat{\Pi}_{t+1}=0.
```

**(F7) 随机贴现因子**

```math
\hat{\Lambda}_t=\hat{\varrho}_t-\hat{\varrho}_{t-1}.
```

**(F8) 线性劳动供给**

```math
\varphi\hat{l}_t=\hat{\varrho}_t+\hat{w}_t.
```

**(F9) 资本品生产者投资 FOC**

```math
\begin{aligned}
Q_t\left(1-\frac{\eta_i}{2}\left(\frac{I_t}{I_{t-1}}-1\right)^2\right)
&=1+Q_t\eta_i\left(\frac{I_t}{I_{t-1}}-1\right)\frac{I_t}{I_{t-1}} \\
&\quad -E_t\left[\beta\frac{\varrho_{t+1}}{\varrho_t}
Q_{t+1}\eta_i\left(\frac{I_{t+1}}{I_t}-1\right)
\left(\frac{I_{t+1}}{I_t}\right)^2\right].
\end{aligned}
```

**(F10) 线性投资动态**

```math
\hat{I}_t=\frac{1}{1+\beta}
\left(\hat{I}_{t-1}+\beta\hat{I}_{t+1}+\frac{\hat{Q}_t}{\eta_i}\right).
```

**(F11) 资本积累**

```math
K_t=(1-\delta)K_{t-1}
+I_t\left[1-\frac{\eta_i}{2}\left(\frac{I_t}{I_{t-1}}-1\right)^2\right].
```

**(F12) 线性资本积累**

```math
\hat{K}_t=(1-\delta)\hat{K}_{t-1}+\delta\hat{I}_t.
```

**(F13) 带利用率的生产函数**

```math
\hat{Y}_t=\alpha(\hat{U}_t+\hat{K}_{t-1})+(1-\alpha)(\hat{a}_t+\hat{l}_t).
```

**(F14) 含营运资本成本的零售商劳动需求**

```math
w_t(1+\psi_L(R_t-1))=(1-\alpha)mc_t\frac{Y_t}{l_t}.
```

**(F15) 线性零售商劳动需求**

```math
w(1+\psi_L(R-1))\hat{w}_t+w\psi_LR\hat{R}_t
=(1+\psi_L(R-1))w(\widehat{mc}_t+\hat{Y}_t-\hat{l}_t).
```

**(F16) 含营运资本成本的零售商资本需求**

```math
r_t^k(1+\psi_K(R_t-1))=\alpha mc_t\frac{Y_t}{K_{t-1}}.
```

**(F17) 带利用率的线性零售商资本需求**

```math
\frac{\hat{r}_t^k}{r^k}
+\frac{\psi_KR}{1+\psi_K(R-1)}\hat{R}_t
=\widehat{mc}_t+\hat{Y}_t-\hat{K}_{t-1}-\hat{U}_t.
```

**(F18) 营运资本贷款**

```math
L_t^r=\psi_Lw_tl_t+\psi_Kr_t^kK_{t-1}.
```

**(F19) New Keynesian Phillips 曲线**

```math
\hat{\Pi}_t=
\frac{1}{1+\beta\gamma_P}
\left[
\beta\hat{\Pi}_{t+1}+\gamma_P\hat{\Pi}_{t-1}
+\frac{(1-\xi^P\beta)(1-\xi^P)}{\xi^P}\widehat{mc}_t
\right].
```

**(F20) 银行杠杆恒等式**

```math
\hat{\phi}_t^b=\hat{L}_t^e-\hat{N}_t^b.
```

**(F21) 存续银行家的净值**

```math
N_{et}^b=\theta z_{t-1,t}N_{t-1}^b.
```

**(F22) 总银行净值**

```math
N_t^b=N_{et}^b+N_n^b.
```

**(F23) 银行资产增长**

```math
z_{t-1,t}=
\frac{[(R_t^b-R_{t-1})\phi_{t-1}^b+R_{t-1}]}{\Pi_t}\exp(e_t^z).
```

**(F24) 银行家消费**

```math
C_t^b=(1-\theta)z_{t-1,t}N_{t-1}^b.
```

**(F25) 前瞻性银行杠杆条件**

```math
\hat{\phi}_t^b
=E_t\left[
\theta\beta^2z^2\hat{\phi}_{t+1}^b
+\phi^b\frac{R^b}{R}\left(\hat{R}_{t+1}^b-\hat{R}_t\right)
\right].
```

**(F26) 企业家贷款的银行资产负债表**

```math
L_t^e=\phi_t^bN_t^b.
```

**(F27) 资本回报率**

```math
R_{t+1}^K=\Pi_{t+1}\frac{r_{t+1}^k+Q_{t+1}(1-\delta)}{Q_t}.
```

**(F28) 企业家杠杆**

```math
\phi_t^e=\frac{Q_tK_t}{N_t}.
```

**(F29) 企业家银行参与约束**

```math
(\phi_t^e-1)E_tR_{t+1}^b
=\phi_t^eE_t\left[
R_{t+1}^K\left(\Gamma(\bar{\omega}_{t+1})-\mu G(\bar{\omega}_{t+1})\right)
\right].
```

**(F30) 企业家最优合约关于杠杆的 FOC**

```math
E_t\left[R_{t+1}^K(1-\Gamma(\bar{\omega}_{t+1}))\right]
+\xi_tE_t\left[
R_{t+1}^K(\Gamma(\bar{\omega}_{t+1})-\mu G(\bar{\omega}_{t+1}))
-R_{t+1}^b
\right]=0.
```

**(F31) 企业家最优合约关于阈值的 FOC**

```math
E_t\left[
-\Gamma'(\bar{\omega}_{t+1})
+\xi_t\left(\Gamma'(\bar{\omega}_{t+1})-\mu G'(\bar{\omega}_{t+1})\right)
\right]=0.
```

**(F32) 企业家最优合约参与 FOC**

```math
E_t\left[
\phi_t^e R_{t+1}^K(\Gamma(\bar{\omega}_{t+1})-\mu G(\bar{\omega}_{t+1}))
-R_{t+1}^b(\phi_t^e-1)
\right]=0.
```

**(F33) 资本回报相对银行资产回报的线性利差**

```math
E_t\hat{R}_{t+1}^K-E_t\hat{R}_{t+1}^b
=\chi^l(\hat{K}_t+\hat{Q}_t-\hat{N}_t).
```

**(F34) 企业家权益**

```math
V_t=Q_{t-1}K_{t-1}\frac{R_t^K}{\Pi_t}
\left[1-\Gamma(\bar{\omega}_t)\right]\exp(e_t^N).
```

`needs_review`：正文方程 (15) 给出积分形式；附录 A29 给出紧凑的 `1-\Gamma` 形式。`Q_{t-1}K_{t-1}` 乘法附近的 OCR 较脆弱。

**(F35) 企业家净值**

```math
N_t=\gamma V_t+W^e.
```

**(F36) 企业家消费**

```math
C_t^e=(1-\gamma)V_t.
```

**(F37) 企业家违约阈值**

```math
\bar{\omega}_t=
\frac{R_{t-1}^L(Q_{t-1}K_{t-1}-N_{t-1})}
{R_t^KQ_{t-1}K_{t-1}}.
```

**(F38) 银行对企业家贷款的平均回报**

```math
\begin{aligned}
R_t^b
&=R_{t-1}^L\int_{\bar{\omega}_t}^{\infty}f(\omega^j)d\omega^j \\
&\quad +(1-\mu)R_t^K
\frac{\phi_{t-1}^e}{\phi_{t-1}^e-1}
\int_0^{\bar{\omega}_t}\omega^j f(\omega^j)d\omega^j .
\end{aligned}
```

**(F39) 线性贷款利率/阈值关系**

```math
\widehat{\bar{\omega}R^K}_t=\hat{R}_t^L+\frac{1}{\phi^e-1}\hat{\phi}_t^e.
```

**(F40) 货币政策规则**

```math
R_t-1=(1-\rho_i)\left[
R-1+\psi_{\pi}(\log\Pi_t-\log\Pi)
+\psi_y(\log GDP_t-\log GDP_t^{\ast})
\right]
+\rho_i(R_{t-1}-1)+e_t^i.
```

在实现中，产出缺口项由实际边际成本代理：

```math
R\hat{R}_t=(1-\rho_i)(\psi_{\pi}\hat{\Pi}_t+\psi_y\widehat{mc}_t)
+\rho_iR\hat{R}_{t-1}+e_t^i.
```

## 4. Market Clearing & Identities

**(F41) 总私人消费**

```math
C_t^P=C_t+C_t^e+C_t^b.
```

**(F42) 含监控成本和利用率成本的资源约束**

```math
Y_t=S_t\left[
I_t+C_t^P
+\frac{R_t^K}{\Pi_t}Q_{t-1}K_{t-1}\mu
\int_0^{\bar{\omega}_t}\omega f(\omega)d\omega
\right].
```

实现交叉检查在线性资源约束中加入了可变利用率成本项。

**(F43) GDP 恒等式**

```math
GDP_t=I_t+C_t+G_t.
```

**(F44) 总贷款**

```math
L_t=L_t^e+L_t^r.
```

**(F45) 价格离散递归**

```math
S_t=(1-\xi^P)\left(\frac{\Pi_t}{\Pi_t^{\ast}}\right)^{\varepsilon}
+\xi^P\left(\frac{\Pi_t}{\Pi_{t-1}^{\gamma_P}\Pi^{1-\gamma_P}}\right)^{\varepsilon}S_{t-1}.
```

**(F46) 商品生产**

```math
Y_t=K_{t-1}^{\alpha}(A_tl_t)^{1-\alpha}.
```

**(F47) 银行贷款会计关系**

```math
P_tL_t^e(q)=P_tN_t^b(q)+B_t(q).
```

## 5. Exogenous Processes

**(F48) 技术冲击**

```math
\hat{a}_t=\rho_a\hat{a}_{t-1}-e_t^a.
```

**(F49) 政府支出冲击**

```math
\hat{g}_t=\rho_g\hat{g}_{t-1}-e_t^g.
```

**(F50) 货币政策创新**

```math
e_t^i \sim iid(0,\sigma_i^2).
```

**(F51) 银行净值冲击**

```math
e_t^z \sim iid.
```

**(F52) 企业家净值冲击**

```math
e_t^N \sim iid.
```

`needs_review`：Rep-MMB 模拟声明了货币、技术和政府创新。论文用银行和企业家净值冲击做危机实验，但交叉检查实现未在最终 `shocks` 块中保留它们。

## 6. Steady-State Solution

实现交叉检查直接存储稳态校准。论文描述目标并报告校准表，而不是为每个金融合约对象推导完整闭式顺序。以下有序解记录实现交叉检查中的校准逻辑，因此用于来源提升前仍为 `needs_review`：

1. 设置政策和偏好参数：`beta=0.9958`、`h=0.6`、`varphi=0.25`、`alpha=0.33`、`delta=0.025`、`eta_i=4`、`epsilon=6`、`xi_p=0.67`、`gamma_p=0`、`psi_L=psi_K=1`。
2. 设置金融合约参数和目标：`sigma=0.35`、`mu=0.2981`、企业家存活率 `gamma=0.975`、银行家存活率 `theta=0.9915`、政府支出份额 `G/Y=0.2`、违约率目标 `brate=0.0075`、银行杠杆 `phi_b=1/0.125`、银行利差目标 `spread_RbR=(1.002)^{1/4}`。
3. 设置季度通胀和名义无风险稳态：

```math
\Pi=(1+0.0223)^{1/4},\qquad R=\frac{\Pi}{\beta}.
```

4. 构造对数正态违约项：

```math
\bar{\omega}=\exp(\sigma\Phi^{-1}(brate)-0.5\sigma^2),\quad
F=\Phi\left(\frac{\log\bar{\omega}+0.5\sigma^2}{\sigma}\right),
\quad G=\Phi\left(\frac{\log\bar{\omega}+0.5\sigma^2}{\sigma}-\sigma\right).
```

5. 使用 `F`、`G`、`Gamma` 的导数计算合约乘数 `xi`、资本-银行利差 `spread_RkRb`、企业家杠杆 `phi_e` 和 (F33) 中的线性系数 `chi_e`。
6. 设置：

```math
R^b=spread_{RbR}R,\qquad R^K=R^b spread_{RkRb},\qquad
R^L=\frac{\bar{\omega}R^K}{1-1/\phi_e}.
```

7. 设置加成和边际成本：

```math
X=\frac{\varepsilon}{\varepsilon-1},\qquad mc=\frac{\varepsilon-1}{\varepsilon},\qquad Q=1.
```

8. 由含营运资本成本的要素需求解资本劳动比，然后规范化劳动 `l=1/3`，计算 `K`、`Y`、`I=delta K` 和 `G=0.2Y`。
9. 计算企业家变量：

```math
N=\frac{K}{\phi_e},\qquad L^e=K-N,\qquad
V=K\frac{R^K}{\Pi}(1-\Gamma),\qquad C^e=(1-\gamma)V.
```

10. 计算营运资本贷款和银行变量：

```math
L^r=\psi_Lwl+\psi_Kr^kK,\quad L=L^e+L^r,\quad
N^b=\frac{L^e}{\phi_b},\quad C^b=(1-\theta)zN^b.
```

11. 家庭消费和总消费为残差：

```math
C=Y-I-C^e-C^b-G-\mu G(\bar{\omega})\frac{R^K}{\Pi}K,
\qquad C^P=C+C^e+C^b.
```

12. 在 `model(linear)` 中，赋值这些水平和比率后，所有带帽/偏离变量的稳态均为零。

## 7. Timing & Form Conventions

- **形式**：`model(linear)`。本推导用带帽变量表示对数偏离；MMB 实现直接使用偏离变量名。
- **资本时序**：`K_t` 是 `t` 期末购买的存量；`t` 期生产使用 `K_{t-1}` 和利用率 `U_t`。
- **银行贷款**：`t-1` 期发放的企业家贷款在 `t` 期初到期；`t` 期银行净值取决于 `R_t^b`、`R_{t-1}`、`L_{t-1}^e` 和 `N_{t-1}^b`。
- **企业家净值**：`N_t` 是企业家保留权益并接受新企业家转移 `W^e` 后的期末净值。
- **贷款利率**：完整模型使用在 `t` 期确定的非状态依赖贷款利率；`t+1` 期违约阈值随实现的资本回报移动。
- **通胀和利率**：`Pi_t=P_t/P_{t-1}`。论文写名义利率；实现报告年化 `R4=4R`、`Pi4=4Pi` 和各类利差。
- **灵活价格副本**：实现包含模型的 flex-price 副本以定义 `outputgap`；本档案记录核心粘性价格模型，并将 flex 模块记为实现细节。
- **运行时验证**：未运行 Dynare、Rep-MMB、BK 或 IRF 验证。

## 8. Variable & Parameter Reference Table

### 内生变量

| 符号 | 含义 | 主要方程 |
|---|---|---|
| `Y` | 产出 | (F13), (F42), (F46) |
| `GDP` | GDP | (F43) |
| `I` | 投资 | (F9), (F10), (F11) |
| `K` | 资本存量 | (F11), (F12) |
| `l` | 劳动 | (F4), (F8), (F14) |
| `U` | 利用率 | (F13), implementation cross-check |
| `Cp` | 总私人消费 | (F41) |
| `C` | 家庭消费 | (F1), (F2), (F41) |
| `Ce` | 企业家消费 | (F36) |
| `Cb` | 银行家消费 | (F24) |
| `varrho` | 家庭边际效用 | (F1), (F5) |
| `Lambda` | 随机贴现因子 | (F7) |
| `R` | 无风险名义/存款利率 | (F2), (F6), (F40) |
| `Rk` | 资本回报率 | (F27), (F33) |
| `rk` | 资本租金/边际产出 | (F16), (F17), (F27) |
| `Rb` | 银行企业家贷款组合回报 | (F23), (F25), (F38) |
| `Rl` | 企业家贷款利率 | (F37), (F39) |
| `w` | 实际工资 | (F4), (F14), (F15) |
| `a` | 技术 | (F13), (F48) |
| `Q` | 资本价格 | (F9), (F27), (F28) |
| `Pi` | 通胀 | (F2), (F19), (F40), (F45) |
| `mc` | 实际边际成本 | (F14), (F16), (F19), (F40) |
| `N` | 企业家净值 | (F28), (F35) |
| `V` | 企业家权益/价值 | (F34), (F35), (F36) |
| `phi_e` | 企业家杠杆 | (F28), (F33) |
| `omega_bar_prime` | 实现中的阈值-回报复合项 | (F39) |
| `L` | 总贷款 | (F44) |
| `Lr` | 零售商营运资本贷款 | (F18) |
| `Le` | 企业家贷款 | (F26), (F44), (F47) |
| `g` | 政府支出偏离 | (F49) |
| `Nb` | 银行净值 | (F21), (F22), (F26) |
| `phi_b` | 银行杠杆 | (F20), (F25), (F26) |
| `z` | 银行净值增长 | (F23) |
| `spread_RlR`, `spread_RkR`, `spread_RbR`, `spread_RkRb` | 年化利差 | implementation definitions |
| `R4`, `Pi4` | 年化无风险利率和通胀 | implementation definitions |

### 外生冲击

| 符号 | 含义 | 来源状态 |
|---|---|---|
| `e_i` / `interest_` | 货币政策创新 | source-stated and implementation cross-check |
| `e_a` | 技术创新 | source-stated and implementation cross-check |
| `e_g` / `fiscal_` | 政府支出创新 | implementation cross-check |
| `e_z` | 银行净值冲击 | source-stated; not retained in final Rep-MMB `shocks` block |
| `e_N` | 企业家净值冲击 | source-stated; not retained in final Rep-MMB `shocks` block |

### 参数

| 符号 | 含义 |
|---|---|
| `beta` | 家庭贴现因子 |
| `h` | 内部习惯 |
| `varphi` | Frisch 弹性倒数 |
| `chi` | 劳动负效用权重 |
| `alpha` | 资本份额 |
| `delta` | 折旧率 |
| `eta_i` | 投资调整成本曲率 |
| `epsilon` | 品种间 CES 替代弹性 |
| `xi_p` | Calvo 不重设价格概率 |
| `gamma_p` | 价格指数化参数 |
| `theta` | 银行家存活率 |
| `gamma` | 企业家存活率 |
| `lambda` | 银行道德风险约束中可转移份额 |
| `psi_L`, `psi_K` | 劳动和资本成本的营运资本融资份额 |
| `sigma` | 企业家个体生产率冲击标准差 |
| `mu` | 监控/破产成本 |
| `psi_pi`, `psi_y`, `rho_i` | Taylor 规则参数 |
| `rho_a`, `rho_g` | 冲击持续性 |
| `G_over_Y` | 稳态政府支出份额 |
| `brate` | 目标违约率 |
| `phi_b_ss`, `phi_e_ss` | 银行和企业家稳态杠杆 |
| `spread_RbR_ss`, `spread_RkRb_ss` | 稳态利差 |
| `c_U` | 来自作者提供实现交叉检查的利用率成本参数 |
