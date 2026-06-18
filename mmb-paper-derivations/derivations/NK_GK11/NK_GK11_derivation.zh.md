# NK_GK11 推导：Gertler-Karadi (2011)

来源：`NK_GK11`，Mark Gertler 和 Peter Karadi（2011），"A model of unconventional monetary policy"，*Journal of Monetary Economics* 58(1), 17-34。DOI：`10.1016/j.jmoneco.2010.10.004`。主来源：`raw/mmb_mineru/runs/nk_gk09lin_nk_gk11__a_model_of_unconvetional_monetary_policy__e6192938/full.md`。原始 PDF 存在于 `raw/mmb_papers/A Model of Unconvetional Monetary Policy.pdf`；未读取 PDF 正文。用于抽取的 MinerU run id：`e6192938-5688-49c7-9621-66ca2478274f`。附录规范化文件：未找到。实现交叉检查：`.agents/skills/dynare-copilot/references/examples/NK_GK11_rep.mod`。

未执行运行时验证。这是一份第一轮、基于来源的推导，状态仍为 `needs_review`，主要原因是若干 MinerU 公式在下标和希腊字母识别上存在 OCR 异常。

## 1. Model Overview

- **模型**：闭合经济新凯恩斯 DSGE 模型，包含金融中介、内生中介资产负债表约束、资本质量冲击，以及可选的央行信贷中介。
- **核心主体**：带有工人和银行家的代表性家庭、私人金融中介、竞争性中间品生产者、资本品生产者、垄断竞争零售商、财政当局和中央银行。
- **金融机制**：银行家面临激励约束，因为他们可以转移一部分资产。当约束绑定时，私人贷款总量通过内生杠杆率与中介净值相连。
- **非常规政策**：中央银行可以通过发行无风险政府债并向私人企业贷款来中介一部分资产。公共中介不受杠杆约束，但以 `tau` 的成本消耗资源。
- **模型形式**：论文中的均衡条件为水平方程的非线性形式；MMB 实现将多数实际变量写为对数并做一阶近似。本推导记录来源中的非线性方程。

## 2. Optimization Problems

### 家庭

家庭选择消费、劳动和一期无风险债券持有量。消费具有习惯形成：

```math
\max_{\{C_t,L_t,B_{t+1}\}} E_t \sum_{i=0}^{\infty}\beta^i
\left[\log(C_{t+i}-h C_{t+i-1})-\frac{\chi}{1+\varphi}L_{t+i}^{1+\varphi}\right].
```

当期预算约束为

```math
C_t = W_tL_t+\Pi_t+T_t+R_tB_t-B_{t+1}.
```

### 银行家/中介

银行家 `j` 在时期 `t` 以净值 `N_{jt}` 开始，并取得存款 `B_{jt+1}`，以价格 `Q_t` 购买索取权 `S_{jt}`：

```math
Q_tS_{jt}=N_{jt}+B_{jt+1}.
```

下一期中介净值等于资产收益减去存款偿还：

```math
N_{j,t+1}=R_{k,t+1}Q_tS_{jt}-R_{t+1}B_{j,t+1}.
```

银行家最大化预期终值财富：

```math
V_{jt}=\max E_t\sum_{i=0}^{\infty}(1-\theta)\theta^i\beta^{i+1}
\Lambda_{t,t+1+i}N_{j,t+1+i}.
```

只有当特许经营价值超过转移一部分资产的收益时，存款人才愿意放贷：

```math
V_{jt}\geq \lambda Q_tS_{jt}.
```

### 中间品生产者

在时期 `t` 末，企业取得用于 `t+1` 生产的资本，并发行等于所取得资本的索取权：

```math
Q_tK_{t+1}=Q_tS_t.
```

在时期 `t`，企业选择利用率和劳动来生产

```math
Y_t=A_t(U_t\xi_tK_t)^\alpha L_t^{1-\alpha}.
```

### 资本品生产者

资本品生产者购买并翻新折旧资本，并在流量调整成本下生产新资本。其贴现利润问题为

```math
\max_{\{I_{n,t}\}} E_t\sum_{\tau=t}^{\infty}\beta^{\tau-t}\Lambda_{t,\tau}
\left[(Q_\tau-1)I_{n,\tau}
-f\!\left(\frac{I_{n,\tau}+I_{ss}}{I_{n,\tau-1}+I_{ss}}\right)(I_{n,\tau}+I_{ss})\right].
```

### 零售商

最终产出是差异化零售品的 CES 聚合：

```math
Y_t=\left[\int_0^1 Y_{ft}^{(\varepsilon-1)/\varepsilon}df\right]^{\varepsilon/(\varepsilon-1)}.
```

零售商 `f` 在 Calvo 粘性和滞后通胀指数化下选择重设价格：

```math
\max_{P_t^{\ast}} E_t\sum_{i=0}^{\infty}\gamma^i\beta^i\Lambda_{t,t+i}
\left[
\frac{P_t^{\ast}}{P_{t+i}}\prod_{k=1}^{i}(1+\pi_{t+k-1})^{\gamma_p}
-P_{m,t+i}
\right]Y_{f,t+i}.
```

## 3. First-Order Conditions

**家庭**

- **(F1) 带外部习惯的边际效用**：

```math
\varrho_t=(C_t-hC_{t-1})^{-1}-\beta h E_t(C_{t+1}-hC_t)^{-1}.
```

- **(F2) 劳动供给**：

```math
\varrho_t W_t=\chi L_t^\varphi.
```

- **(F3) 无风险债券欧拉方程**：

```math
E_t\beta\Lambda_{t,t+1}R_{t+1}=1,\qquad
\Lambda_{t,t+1}=\frac{\varrho_{t+1}}{\varrho_t}.
```

**金融中介**

- **(F4) 资产负债表**：

```math
Q_tS_{jt}=N_{jt}+B_{j,t+1}.
```

- **(F5) 净值积累**：

```math
N_{j,t+1}=(R_{k,t+1}-R_{t+1})Q_tS_{jt}+R_{t+1}N_{jt}.
```

- **(F6) 银行家价值分解**：

```math
V_{jt}=\nu_t Q_tS_{jt}+\eta_t N_{jt}.
```

- **(F7) 中介资产的边际价值**：

```math
\nu_t=E_t\left\{(1-\theta)\beta\Lambda_{t,t+1}(R_{k,t+1}-R_{t+1})
+\beta\Lambda_{t,t+1}\theta x_{t,t+1}\nu_{t+1}\right\}.
```

- **(F8) 中介净值的边际价值**：

```math
\eta_t=E_t\left\{(1-\theta)+\beta\Lambda_{t,t+1}\theta z_{t,t+1}\eta_{t+1}\right\}.
```

- **(F9) 激励约束**：

```math
\eta_tN_{jt}+\nu_tQ_tS_{jt}\geq \lambda Q_tS_{jt}.
```

- **(F10) 绑定杠杆关系**：

```math
Q_tS_{jt}=\frac{\eta_t}{\lambda-\nu_t}N_{jt}\equiv \phi_tN_{jt}.
```

- **(F11) 私人中介资产总量**：

```math
Q_tS_{p,t}=\phi_tN_t.
```

- **(F12) 中介净值增长率**：

```math
z_{t,t+1}=(R_{k,t+1}-R_{t+1})\phi_t+R_{t+1}.
```

- **(F13) 中介资产增长率**：

```math
x_{t,t+1}=\frac{\phi_{t+1}}{\phi_t}z_{t,t+1}.
```

- **(F14) 中介净值总量**：

```math
N_t=N_{e,t}+N_{n,t}.
```

- **(F15) 存续银行家的净值**：

```math
N_{e,t}=\theta\left[(R_{k,t}-R_t)\phi_{t-1}+R_t\right]N_{t-1}.
```

- **(F16) 新进入银行家的净值**：

```math
N_{n,t}=\omega Q_tS_{t-1}.
```

**信贷政策与总中介**

- **(F17) 总资产在私人和公共中介之间拆分**：

```math
Q_tS_t=Q_tS_{p,t}+Q_tS_{g,t}.
```

- **(F18) 公共中介份额**：

```math
Q_tS_{g,t}=\psi_tQ_tS_t.
```

- **(F19) 信贷政策下的总杠杆**：

```math
Q_tS_t=\phi_tN_t+\psi_tQ_tS_t\equiv \phi_{c,t}N_t,\qquad
\phi_{c,t}=\frac{\phi_t}{1-\psi_t}.
```

**中间品生产者**

- **(F20) 索取权等于下一期资本**：

```math
Q_tK_{t+1}=Q_tS_t.
```

- **(F21) 生产函数**：

```math
Y_t=A_t(U_t\xi_tK_t)^\alpha L_t^{1-\alpha}.
```

- **(F22) 利用率选择**：

```math
P_{m,t}\alpha\frac{Y_t}{U_t}=\delta'(U_t)\xi_tK_t.
```

- **(F23) 劳动需求**：

```math
P_{m,t}(1-\alpha)\frac{Y_t}{L_t}=W_t.
```

- **(F24) 资本回报**：

```math
R_{k,t+1}=
\frac{\left[P_{m,t+1}\alpha\frac{Y_{t+1}}{\xi_{t+1}K_{t+1}}
+Q_{t+1}-\delta(U_{t+1})\right]\xi_{t+1}}{Q_t}.
```

**资本品生产者**

- **(F25) 净投资定义**：

```math
I_{n,t}=I_t-\delta(U_t)\xi_tK_t.
```

- **(F26) 资本品生产者的 Q 关系**：

```math
Q_t=1+f(\cdot)
+\frac{I_{n,t}+I_{ss}}{I_{n,t-1}+I_{ss}}f'(\cdot)
-E_t\beta\Lambda_{t,t+1}
\left(\frac{I_{n,t+1}+I_{ss}}{I_{n,t}+I_{ss}}\right)^2f'(\cdot).
```

**零售商**

- **(F27) 零售品种需求**：

```math
Y_{f,t}=\left(\frac{P_{f,t}}{P_t}\right)^{-\varepsilon}Y_t.
```

- **(F28) 价格指数**：

```math
P_t=\left[\int_0^1P_{f,t}^{1-\varepsilon}df\right]^{1/(1-\varepsilon)}.
```

- **(F29) 重设价格 FOC**：

```math
E_t\sum_{i=0}^{\infty}\gamma^i\beta^i\Lambda_{t,t+i}
\left[
\frac{P_t^{\ast}}{P_{t+i}}\prod_{k=1}^{i}(1+\pi_{t+k-1})^{\gamma_p}
-\mu P_{m,t+i}
\right]Y_{f,t+i}=0,\qquad
\mu=\frac{1}{1-1/\varepsilon}.
```

- **(F30) 价格水平运动方程**：

```math
P_t=\left[(1-\gamma)(P_t^{\ast})^{1-\varepsilon}
+\gamma\left(\Pi_{t-1}^{\gamma_p}P_{t-1}\right)^{1-\varepsilon}\right]^{1/(1-\varepsilon)}.
```

## 4. Market Clearing & Identities

- **(F31) 资源约束**：

```math
Y_t=C_t+I_t+
f\!\left(\frac{I_{n,t}+I_{ss}}{I_{n,t-1}+I_{ss}}\right)(I_{n,t}+I_{ss})
+G+\tau\psi_tQ_tK_{t+1}.
```

- **(F32) 资本积累**：

```math
K_{t+1}=\xi_tK_t+I_{n,t}.
```

- **(F33) 政府预算恒等式**：

```math
G+\tau\psi_tQ_tK_{t+1}=T_t+(R_{k,t}-R_t)B_{g,t-1}.
```

- **(F34) 用于公共中介的政府债**：

```math
B_{g,t}=\psi_tQ_tS_t.
```

- **(F35) 批发与零售产出关系**：

```math
Y_{m,t}=D_tY_t.
```

- **(F36) 加成定义**：

```math
X_t=\frac{1}{P_{m,t}}.
```

- **(F37) Fisher 关系**：

```math
1+i_t=R_{t+1}\frac{E_tP_{t+1}}{P_t}.
```

- **(F38) Taylor 规则**：

```math
i_t=(1-\rho)\left[i+\kappa_\pi\pi_t+\kappa_y(\log Y_t-\log Y_t^{\ast})\right]
+\rho i_{t-1}+\varepsilon^i_t.
```

## 5. Exogenous Processes

- **(F39) 信贷政策反馈规则**：

```math
\psi_t=\psi+\nu_\psi E_t\left[(\log R_{k,t+1}-\log R_{t+1})-(\log R_k-\log R)\right].
```

- **(F40) 技术冲击**：

```math
\log A_t=\rho_a\log A_{t-1}+\varepsilon^a_t.
```

- **(F41) 资本质量冲击**：

```math
\log \xi_t=\rho_\xi\log \xi_{t-1}+\varepsilon^\xi_t.
```

- **(F42) 政府支出冲击**：

```math
\log G_t=(1-\rho_g)\log G+\rho_g\log G_{t-1}+\varepsilon^g_t.
```

- **(F43) 中介财富冲击，仅作为实现交叉检查**：

```math
N_{e,t}=\theta\left[(R_{k,t}-R_t)\phi_{t-1}+R_t\right]N_{t-1}\exp(-\varepsilon^N_t).
```

来源论文使用估值和政策实验；实现文件还为 MMB 模拟保留了中介净值冲击和货币政策冲击。

## 6. Steady-State Solution

稳态将通胀和资本质量冲击设为确定性均值，且 `A=1`、`xi=1`、`U=1`。令总通胀为一；除非校准了正的 `psi`，基准稳态忽略公共中介。

1. 由 **(F3)**，在边际效用为常数时：

```math
R=\frac{1}{\beta}.
```

2. 目标稳态利差意味着

```math
R_k=R\cdot\exp(\overline{\text{prem}}).
```

3. 由目标杠杆率：

```math
\phi=\overline{\phi}.
```

4. 银行家模块联合求解 `lambda`、`omega` 和 `chi`，以匹配杠杆率、利差和劳动目标。在稳态，

```math
z=(R_k-R)\phi+R,\qquad x=z.
```

5. 当 `Q=1` 且 `xi=1` 时，资本回报方程给出稳态边际产出关系：

```math
R_k=P_m\alpha\frac{Y}{K}+1-\delta(U).
```

6. 利用率条件确定折旧函数的尺度：

```math
P_m\alpha Y=b U^{1+\zeta}K.
```

7. 净投资和资本积累意味着

```math
I_n=0,\qquad I=\delta(U)K.
```

8. Calvo 模块在零通胀下无价格分散：

```math
D=1,\qquad X=\frac{\varepsilon}{\varepsilon-1},\qquad P_m=\frac{\varepsilon-1}{\varepsilon}.
```

9. 资源可行性随后决定消费：

```math
C=Y-I-G.
```

10. 劳动目标和 **(F1)**-**(F2)** 确定劳动效用权重：

```math
\chi=\frac{\varrho W}{L^\varphi},\qquad
\varrho=(C-hC)^{-1}-\beta h(C-hC)^{-1}.
```

精确的 MMB 稳态实现通过数值方式求解校准目标，并且只记录为 `implementation_cross_check`；论文没有给出完整的闭式稳态算法。

## 7. Timing & Form Conventions

- `K_{t+1}` 在时期 `t` 末选择，用于 `t+1` 的生产；时期 `t` 的生产使用 `K_t`，并结合当前资本质量冲击和利用率。
- 中介在 `t` 选择资产；资产回报和净值实现发生在 `t+1`。
- `Q_t` 是时期 `t` 末取得的下一期资本索取权价格。
- `R_{t+1}` 是从 `t` 到 `t+1` 的实际无风险总回报；`R_{k,t+1}` 是同一期间中介资产的随机总回报。
- 论文方程为非线性。MMB 示例通过 `exp(variable)` 将许多变量写成对数形式，并使用一阶扰动。
- 原始 MinerU 标题拼写为 "Unconvetional"；论文元数据和 DOI 使用 "unconventional"。该标题拼写错误仅在来源路径中保留。

## 8. Variable & Parameter Reference Table

| 类别 | 符号或 ASCII 名称 | 含义 | 主要方程 |
|---|---|---|---|
| 内生变量 | `C_t`, `L_t`, `B_t` | 家庭消费、劳动、债券持有 | (F1)-(F3) |
| 内生变量 | `varrho_t`, `Lambda_{t,t+1}` | 边际效用和随机贴现因子 | (F1), (F3) |
| 内生变量 | `W_t` | 实际工资 | (F2), (F23) |
| 内生变量 | `N_t`, `N_e`, `N_n` | 中介净值及其组成 | (F14)-(F16) |
| 内生变量 | `nu_t`, `eta_t` | 银行家对资产和净值的价值 | (F6)-(F8) |
| 内生变量 | `phi_t`, `phi_c,t` | 私人和总杠杆率 | (F10), (F19) |
| 内生变量 | `S_t`, `S_p,t`, `S_g,t` | 总、私人和公共中介资产 | (F11), (F17)-(F20) |
| 内生变量 | `Q_t` | 资本/索取权价格 | (F20), (F26) |
| 内生变量 | `K_t`, `I_t`, `I_n,t` | 资本、总投资、净投资 | (F25), (F32) |
| 内生变量 | `U_t`, `delta(U_t)` | 利用率和取决于利用率的折旧 | (F22), (F25) |
| 内生变量 | `Y_t`, `Y_m,t`, `D_t` | 最终产出、批发产出、价格分散 | (F21), (F31), (F35) |
| 内生变量 | `P_m,t`, `X_t` | 相对中间品价格和加成 | (F22)-(F24), (F36) |
| 内生变量 | `R_t`, `R_k,t`, `i_t` | 实际无风险回报、资本回报、名义政策利率 | (F24), (F37), (F38) |
| 内生变量 | `P_t`, `P_t^*`, `pi_t` | 总价格、重设价格、通胀 | (F28)-(F30) |
| 内生/政策变量 | `psi_t` | 央行信贷份额 | (F18), (F39) |
| 外生变量 | `A_t`, `xi_t`, `G_t` | 技术、资本质量、政府支出 | (F40)-(F42) |
| 外生创新 | `eps_a`, `eps_ksi`, `eps_g`, `eps_Ne`, `eps_i` | MMB 示例中的冲击 | (F40)-(F43), (F38) |
| 参数 | `beta`, `h`, `chi`, `varphi` | 贴现、习惯、劳动效用、Frisch 逆弹性 | (F1)-(F3) |
| 参数 | `theta`, `lambda`, `omega` | 银行家存活率、可转移比例、启动转移 | (F7)-(F16) |
| 参数 | `alpha`, `zeta`, `delta`, `eta_i` | 生产、利用率折旧、投资调整 | (F21)-(F26) |
| 参数 | `epsilon`, `gamma`, `gamma_p`, `mu` | 零售替代弹性、Calvo 粘性、指数化、加成 | (F27)-(F30) |
| 参数 | `rho_i`, `kappa_pi`, `kappa_y` | Taylor 规则平滑和反馈系数 | (F38) |
| 参数 | `kappa`, `tau` | 信贷政策反馈和资源成本 | (F31), (F39) |
| 参数 | `rho_a`, `rho_ksi`, `rho_g` | 冲击持续性 | (F40)-(F42) |
