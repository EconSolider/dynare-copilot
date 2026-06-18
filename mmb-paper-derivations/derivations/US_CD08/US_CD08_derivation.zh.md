# US_CD08 -- 推导（最优化问题 + 一阶条件）

> 私有模型档案一稿。状态：`needs_review`。未执行运行时验证。

## 1. Model Overview

- **模型 ID**：`US_CD08`。
- **来源**：Ian Christensen and Ali Dib (2008), "The financial accelerator in an estimated New Keynesian model," *Review of Economic Dynamics* 11(1), 155-178, DOI `10.1016/j.red.2007.04.006`。
- **源文件**：主要 OCR Markdown `raw/mmb_mineru/runs/us_cd08__the_financial_accelerator_in_an_estimated_new_keynesian_model__a324933c/full.md`；原始 PDF `raw/mmb_papers/The financial accelerator in an estimated New Keynesian model.pdf`。
- **MinerU run id**：`a324933c-651a-412e-ae68-97c765d22004`。
- **主体**：代表性家庭、企业家、金融中介、资本品生产者、Calvo 零售商和货币当局。
- **核心机制**：企业家以名义债务合约融资。外部融资溢价随杠杆上升而上升，因此净值变动会改变资本需求并放大部分冲击。
- **模型形式**：MMB 实现交叉检查为 log-linearized `model(linear)`。论文附录 A 给出非线性均衡条件，附录 B 给出稳态公式，附录 C 给出对数线性化系统。
- **冲击**：偏好、货币需求、技术、投资效率和货币政策冲击。

## 2. Optimization Problems

### 家庭

家庭选择消费、实际货币余额、劳动和存款：

```math
\max_{\{c_t,m_t,h_t,D_t\}} E_0\sum_{t=0}^{\infty}\beta^t
\left[
\frac{\gamma e_t}{\gamma-1}\log\left(c_t^{\frac{\gamma-1}{\gamma}}+
b_t^{1/\gamma}m_t^{\frac{\gamma-1}{\gamma}}\right)
+\eta\log(1-h_t)
\right],
```

其中 $`m_t=M_t/P_t`$，约束为名义预算约束

```math
P_tc_t+M_t+D_t\le W_th_t+R_{t-1}D_{t-1}+M_{t-1}+T_t+\Omega_t.
```

### 企业家

企业家在 $`t`$ 期末购买资本并在 $`t+1`$ 期使用。购买成本为 $`q_tk_{t+1}`$，由净值 $`n_{t+1}`$ 和借款 $`q_tk_{t+1}-n_{t+1}`$ 融资。资本需求条件使预期资本回报等于预期外部资金利率。外部溢价是 Bernanke-Gertler-Gilchrist 成本状态验证合约的简约结果：

```math
S(\cdot)=S\left(\frac{n_{t+1}}{q_tk_{t+1}}\right),\qquad S'(\cdot)<0,\qquad S(1)=1.
```

企业家还租用资本和雇用劳动来生产批发品：

```math
\max_{\{k_t,h_t\}}\; p_t^wy_t-W_th_t-Z_tk_t
\quad\text{s.t.}\quad
y_t=k_t^{\alpha}(A_th_t)^{1-\alpha},
```

其中 $`p_t^w/P_t=\xi_t`$ 为实际边际成本，$`z_t=Z_t/P_t`$ 为资本实际边际产出。

### 资本品生产者

资本品生产者选择投资以最大化实际利润：

```math
\max_{i_t} E_t\left[
q_tx_ti_t-i_t-\frac{\chi}{2}\left(\frac{i_t}{k_t}-\delta\right)^2k_t
\right].
```

资本运动方程为

```math
k_{t+1}=x_ti_t+(1-\delta)k_t.
```

### 零售商

零售商购买批发品、差异化产品，并在 Calvo-Yun 交错调价下定价。可以重新定价的零售商选择 $`\tilde p_t(j)`$ 以最大化贴现预期实际利润：

```math
\max_{\{\tilde p_t(j)\}} E_t\sum_{l=0}^{\infty}(\beta\phi)^l
\lambda_{t+l}\frac{\Omega_{t+l}(j)}{p_{t+l}},
```

需求约束为

```math
y_{t+l}(j)=\left(\frac{\tilde p_t(j)}{p_{t+l}}\right)^{-\theta}y_{t+l}.
```

## 3. First-Order Conditions

- **(F1) 消费边际效用**：

```math
\frac{e_tc_t^{-1/\gamma}}
{c_t^{\frac{\gamma-1}{\gamma}}+b_t^{1/\gamma}m_t^{\frac{\gamma-1}{\gamma}}}
=\lambda_t.
```

- **(F2) 货币需求**：

```math
\left(\frac{b_tc_t}{m_t}\right)^{1/\gamma}=\frac{R_t-1}{R_t}.
```

- **(F3) 劳动供给**：

```math
\frac{\eta}{1-h_t}=\lambda_tw_t.
```

- **(F4) 家庭欧拉方程**：

```math
\frac{\lambda_t}{R_t}=\beta E_t\left(\frac{\lambda_{t+1}}{\pi_{t+1}}\right).
```

- **(F5) 企业家资本回报**：

```math
E_tf_{t+1}=E_t\left[\frac{z_{t+1}+(1-\delta)q_{t+1}}{q_t}\right].
```

- **(F6) 外部融资成本**：

```math
E_tf_{t+1}=E_t\left[
S\left(\frac{n_{t+1}}{q_tk_{t+1}}\right)\frac{R_t}{\pi_{t+1}}
\right].
```

- **(F7) 对数线性化外部资金利率**：

```math
\hat f_{t+1}=\hat R_t-\hat\pi_{t+1}
+\psi(\hat q_t+\hat k_{t+1}-\hat n_{t+1}).
```

- **(F8) 企业家净值**：

```math
n_{t+1}=\nu v_t+(1-\nu)g_t.
```

- **(F9) 存续企业家的权益**：

```math
v_t=f_tq_{t-1}k_t-E_{t-1}f_t(q_{t-1}k_t-n_t).
```

- **(F10) 资本租金条件**：

```math
z_t=\alpha\xi_t\frac{y_t}{k_t}.
```

- **(F11) 劳动需求**：

```math
w_t=(1-\alpha)\xi_t\frac{y_t}{h_t}.
```

- **(F12) 批发生产函数**：

```math
y_t=k_t^{\alpha}(A_th_t)^{1-\alpha}.
```

- **(F13) 资本品生产者 Tobin's Q 条件**：

```math
q_tx_t=1+\chi\left(\frac{i_t}{k_t}-\delta\right).
```

- **(F14) Calvo 重置价格**：

```math
\tilde p_t(j)=\frac{\theta}{\theta-1}
\frac{E_t\sum_{l=0}^{\infty}(\beta\phi)^l\lambda_{t+l}y_{t+l}(j)\xi_{t+l}}
{E_t\sum_{l=0}^{\infty}(\beta\phi)^l\lambda_{t+l}y_{t+l}(j)\pi^l/p_{t+l}}.
```

- **(F15) 总价格指数**：

```math
p_t^{1-\theta}=\phi(\pi p_{t-1})^{1-\theta}+(1-\phi)\tilde p_t^{1-\theta}.
```

- **(F16) 新凯恩斯 Phillips 曲线**：

```math
\hat\pi_t=\beta E_t\hat\pi_{t+1}
+\frac{(1-\beta\phi)(1-\phi)}{\phi}\hat\xi_t.
```

- **(F17) 家庭乘数运动方程，对数线性化**：

```math
\hat\lambda_{t+1}=\hat\lambda_t-\hat R_t+\hat\pi_{t+1}.
```

## 4. Market Clearing & Identities

- **(F18) 最终品资源约束**：

```math
y_t=c_t+i_t.
```

- **(F19) 货币增长恒等式**：

```math
\mu_t=\frac{m_t\pi_t}{m_{t-1}}.
```

- **(F20) 对数线性名义货币增长**：

```math
\hat\mu_t=\hat m_t-\hat m_{t-1}+\hat\pi_t.
```

- **(F21) 资本积累**：

```math
k_{t+1}=x_ti_t+(1-\delta)k_t.
```

MMB 实现将 (F21) 写为对数线性形式

```math
\hat k_{t+1}=\delta\hat i_t+\delta\hat x_t+(1-\delta)\hat k_t.
```

## 5. Exogenous Processes

- **(F22) 偏好冲击**：

```math
\log(e_t)=\rho_e\log(e_{t-1})+\varepsilon_{et}.
```

- **(F23) 货币需求冲击**：

```math
\log(b_t)=(1-\rho_b)\log(b)+\rho_b\log(b_{t-1})+\varepsilon_{bt}.
```

- **(F24) 技术冲击**：

```math
\log(A_t)=(1-\rho_A)\log(A)+\rho_A\log(A_{t-1})+\varepsilon_{At}.
```

- **(F25) 投资效率冲击**：

```math
\log(x_t)=\rho_x\log(x_{t-1})+\varepsilon_{xt}.
```

- **(F26) 货币政策规则**：

```math
\frac{R_t}{R}=
\left(\frac{\pi_t}{\pi}\right)^{\varrho_{\pi}}
\left(\frac{y_t}{y}\right)^{\varrho_y}
\left(\frac{\mu_t}{\mu}\right)^{\varrho_{\mu}}
\exp(\varepsilon_{Rt}).
```

在线性化均衡中，(F26) 变为

```math
\hat R_t=\varrho_{\pi}\hat\pi_t+\varrho_{\mu}\hat\mu_t+\varrho_y\hat y_t+\varepsilon_{Rt}.
```

## 6. Steady-State Solution

稳态取常数且无冲击。附录 B 给出如下求解块：

- **(F27) 资本价格**：

```math
q=1.
```

- **(F28) 实际边际成本**：

```math
\xi=\frac{\theta-1}{\theta}.
```

- **(F29) 名义利率**：

```math
R=\frac{\pi}{\beta}.
```

- **(F30) 外部资金利率**：

```math
f=\frac{SR}{\pi}.
```

- **(F31) 回报分解**：

```math
f=z+1-\delta.
```

- **(F32) 消费边际效用乘积**：

```math
\lambda c=\left[1+b\left(\frac{\pi}{\pi-\beta}\right)^{\gamma-1}\right]^{-1}.
```

- **(F33) 货币边际效用乘积**：

```math
\lambda m=\lambda c\,b\left(\frac{\pi}{\pi-\beta}\right)^{\gamma}.
```

- **(F34) 资本产出比**：

```math
\frac{k}{y}=\alpha\frac{\xi}{z}.
```

- **(F35) 消费产出比**：

```math
\frac{c}{y}=1-\delta\frac{k}{y}.
```

- **(F36) 劳动份额条件**：

```math
wh\lambda=\frac{(1-\alpha)(\lambda c)\xi}{c/y}.
```

- **(F37) 工时**：

```math
h=\frac{wh\lambda}{\eta+wh\lambda}.
```

- **(F38) 产出**：

```math
y=Ah\left(\frac{k}{y}\right)^{\alpha/(1-\alpha)}.
```

- **(F39) 投资**：

```math
i=\delta k.
```

实现交叉检查还记录了 $`\beta=0.9928`$、$`\delta=0.025`$、$`\pi=1.0079`$、$`S=1.0075`$、$`\nu=0.9728`$ 和 $`k/n=2`$ 等校准值。未执行运行时验证，也未核对每一个实现稳态辅助变量。

## 7. Timing & Form Conventions

- **形式**：论文的计算系统围绕确定性稳态对数线性化；MMB 文件使用 `model(linear)`。
- **帽变量**：$`\hat x_t`$ 表示相对稳态的对数偏离。
- **资本时序**：论文写作中企业家在 $`t`$ 期末购买 $`k_{t+1}`$ 并于下一期使用。MMB 实现移动了下标，使生产使用滞后资本 `k(-1)`。
- **名义债务**：贷款合约规定名义偿付；实际通胀影响债务偿付的实际成本，从而影响净值。
- **外部资金利率**：(F7) 将预期实际借款成本与名义无风险利率、预期通胀和杠杆联系起来。
- **运行时验证**：未执行；没有运行 Dynare 命令。

## 8. Variable & Parameter Reference Table

| 类别 | 符号 / ASCII | 含义 | 主要方程 |
|---|---|---|---|
| 内生 | $`\lambda_t`$ / `lambda` | 家庭预算乘数 | (F1), (F4), (F17) |
| 内生 | $`c_t`$ / `c` | 消费 | (F1), (F18), (F32), (F35) |
| 内生 | $`b_t`$ / `b` | 货币需求扰动项 | (F2), (F23) |
| 内生 | $`m_t`$ / `m` | 实际货币余额 | (F2), (F19), (F20) |
| 内生 | $`e_t`$ / `e` | 偏好扰动项 | (F1), (F22) |
| 内生 | $`R_t`$ / `r` | 名义无风险毛利率 | (F4), (F26), (F29) |
| 内生 | $`h_t`$ / `h` | 工时 | (F3), (F11), (F37) |
| 内生 | $`w_t`$ / `w` | 实际工资 | (F3), (F11), (F36) |
| 内生 | $`y_t`$ / `y` | 产出 | (F12), (F18), (F38) |
| 内生 | $`k_t`$ / `k` | 资本存量 | (F10), (F12), (F21), (F34) |
| 内生 | $`A_t`$ / `a` | 技术水平 | (F12), (F24), (F38) |
| 内生 | $`i_t`$ / `i` | 投资 | (F13), (F18), (F21), (F39) |
| 内生 | $`\xi_t`$ / `cost` | 实际边际成本 | (F10), (F11), (F16), (F28) |
| 内生 | $`z_t`$ / `z` | 资本边际产出 | (F5), (F10), (F31) |
| 内生 | $`\mu_t`$ / `mu` | 货币增长 | (F19), (F20), (F26) |
| 内生 | $`\pi_t`$ / `pi` | 毛通胀 | (F4), (F16), (F19), (F26) |
| 内生 | $`q_t`$ / `q` | 资本价格 | (F5), (F6), (F13), (F27) |
| 内生 | $`x_t`$ / `x` | 投资效率扰动项 | (F13), (F21), (F25) |
| 内生 | $`f_t`$ / `f` | 外部资金利率 / 资本回报 | (F5), (F6), (F7), (F30) |
| 内生 | $`n_t`$ / `n` | 企业家净值 | (F6), (F7), (F8), (F9) |
| 内生 | `rp` | 风险溢价，实现辅助变量 | (F6), (F7) |
| 外生 | `e_r` / $`\varepsilon_{Rt}`$ | 货币政策创新 | (F26) |
| 外生 | `u_x` / $`\varepsilon_{xt}`$ | 投资效率创新 | (F25) |
| 外生 | `u_a` / $`\varepsilon_{At}`$ | 技术创新 | (F24) |
| 外生 | `u_e` / $`\varepsilon_{et}`$ | 偏好创新 | (F22) |
| 外生 | `u_b` / $`\varepsilon_{bt}`$ | 货币需求创新 | (F23) |
| 参数 | $`\beta`$ / `beta` | 贴现因子 | (F4), (F29) |
| 参数 | $`\gamma`$ / `gamma` | 消费和货币的 CES 参数 | (F1), (F2), (F32), (F33) |
| 参数 | $`\eta`$ / `eta` | 闲暇权重；论文记为 `eta`，交叉检查文件参数头部漏列 | (F3), (F37) |
| 参数 | $`\alpha`$ / `alpha` | 资本份额 | (F10), (F12), (F34) |
| 参数 | $`\delta`$ / `delta` | 折旧率 | (F13), (F21), (F31), (F39) |
| 参数 | $`\chi`$ / `chi` | 资本调整成本参数 | (F13) |
| 参数 | $`\psi`$ / `psi` | 外部融资溢价对杠杆的弹性 | (F7) |
| 参数 | $`\nu`$ / `nu` | 企业家存活概率 | (F8) |
| 参数 | $`\phi`$ / `phi` | Calvo 不重设价格概率 | (F14), (F15), (F16) |
| 参数 | $`\theta`$ / `theta` | 替代弹性 / 目标加成 | (F14), (F15), (F28) |
| 参数 | $`\varrho_{\pi},\varrho_y,\varrho_{\mu}`$ / `rho_pi`, `rho_y`, `rho_mu` | 政策反应系数 | (F26) |
| 参数 | $`\rho_A,\rho_x,\rho_e,\rho_b`$ / `rho_a`, `rho_x`, `rho_e`, `rho_b` | 冲击持久性 | (F22)-(F25) |
| 参数 | $`S`$ / `S` | 稳态外部融资毛溢价 | (F30) |
