# NK_GLSV07 - 推导（最优化问题 + 一阶条件）

> 本推导是供后续 Dynare 工作使用的私有模型档案草稿。未执行运行时验证。

来源信息：`NK_GLSV07`，Galí, Jordi; López-Salido, J. David; Vallés, Javier，"Understanding the effects of government spending on consumption"，Journal of the European Economic Association 5(1), 227-270，2007，DOI `10.1162/jeea.2007.5.1.227`。源 Markdown：`raw/mmb_mineru/runs/nk_glsv07__understanding_the_effects_of_government_spending_on_consumption__47e78a28/full.md`；原始 PDF 仅检查存在性：`raw/mmb_papers/Understanding the effects of government spending on consumption.pdf`；MinerU 运行 id `47e78a28-668e-4d2c-a7ff-9274c85dd958`。仅作为实现交叉检查：`.agents/skills/dynare-copilot/references/examples/NK_GLSV07_rep.mod`。

## 1. Model Overview

- **模型**：含经验法则消费者、黏性价格、资本积累、政府债务和政府支出冲击的新凯恩斯财政模型。
- **MMB 变体**：`NK_GLSV07` 对应 Rep-MMB 示例中的不完全竞争劳动市场实现（`NK_GLSV07_iclm`）。论文还讨论了完全竞争劳动市场变体。
- **主体**：优化型 Ricardian 家庭、经验法则家庭、最终品厂商、具有 Calvo 定价的垄断竞争中间品厂商、中央银行和财政当局。
- **实验**：对政府支出创新的一阶随机模拟响应。
- **形式**：log-linear/model(linear)。小写变量是围绕零通胀稳态的对数偏离或稳态归一化偏离。本档案条目使用论文 Appendix C 中的不完全竞争劳动市场约化系统，因为它与可用 MMB 实现一致。
- **审查状态**：`needs_review`。公式来自 MinerU OCR Markdown，`.mod` 文件仅用于确认方程覆盖和变量命名。

## 2. Optimization Problems

### 2.1 优化型家庭

比例 $`1-\lambda`$ 的家庭交易状态依赖债权、债券和资本。代表性优化型家庭求解

```math
\max_{\{C_t^o,N_t^o,I_t^o,K_{t+1}^o,B_{t+1}^o\}} E_0\sum_{t=0}^{\infty}\beta^t U(C_t^o,N_t^o)
```

约束为

```math
P_t(C_t^o+I_t^o)+R_t^{-1}B_{t+1}^o
=W_tP_tN_t^o+R_t^kP_tK_t^o+B_t^o+D_t^o-P_tT_t^o,
```

以及

```math
K_{t+1}^o=(1-\delta)K_t^o+\phi\!\left(\frac{I_t^o}{K_t^o}\right)K_t^o.
```

论文使用的期效用特例为

```math
U(C,N)=\log C-\frac{N^{1+\varphi}}{1+\varphi}.
```

### 2.2 经验法则家庭

比例 $`\lambda`$ 的家庭不交易资产，并消费当期扣税后的劳动收入：

```math
P_tC_t^r=W_tP_tN_t^r-P_tT_t^r.
```

在完全竞争劳动市场下，这类家庭满足与优化型家庭相同的期内条件。在 `NK_GLSV07` 使用的不完全竞争劳动市场变体中，工时由需求决定，工资方程替代家庭劳动供给条件。

### 2.3 厂商

最终品厂商聚合差异化中间品：

```math
Y_t=\left(\int_0^1 X_t(j)^{\frac{\varepsilon_p-1}{\varepsilon_p}}dj\right)^{\frac{\varepsilon_p}{\varepsilon_p-1}},
```

这意味着需求为

```math
X_t(j)=\left(\frac{P_t(j)}{P_t}\right)^{-\varepsilon_p}Y_t.
```

中间品厂商使用

```math
Y_t(j)=K_t(j)^{\alpha}N_t(j)^{1-\alpha}.
```

在 Calvo 不调价概率 $`\theta`$ 下，重设价格的厂商选择 $`P_t^{\ast}`$ 以最大化受需求约束的预期贴现利润：

```math
\max_{P_t^{\ast}} E_t\sum_{k=0}^{\infty}\theta^k \Lambda_{t,t+k}Y_{t+k}(j)\left(\frac{P_t^{\ast}}{P_{t+k}}-MC_{t+k}\right).
```

### 2.4 货币与财政当局

中央银行设定简单名义利率规则。财政当局满足政府预算约束，使税收随债务和政府购买变动，政府购买服从 AR(1) 过程。

## 3. First-Order Conditions

论文先推导结构模型，再使用 log-linear 均衡条件。对于 MMB 的不完全劳动市场约化系统，实际使用的均衡条件如下。

**(F1) 优化型家庭名义 Euler 条件**

```math
1=R_tE_t\left\{\Lambda_{t,t+1}\frac{P_t}{P_{t+1}}\right\}.
```

**(F2) 资本价值方程**

```math
Q_t=E_t\left\{\Lambda_{t,t+1}\left[R_{t+1}^k+Q_{t+1}\left((1-\delta)+\phi_{t+1}-\frac{I_{t+1}^o}{K_{t+1}^o}\phi'_{t+1}\right)\right]\right\}.
```

**(F3) 投资-资本条件**

```math
Q_t=\frac{1}{\phi'\!\left(I_t^o/K_t^o\right)}.
```

**(F4) 不完全劳动市场下的总消费 Euler 方程**

```math
c_t=E_t\{c_{t+1}\}-\frac{1}{\tilde{\sigma}}\left(r_t-E_t\{\pi_{t+1}\}\right)
-\Theta_nE_t\{\Delta n_{t+1}\}+\Theta_tE_t\{\Delta t_{t+1}^r\},
```

其中

```math
\frac{1}{\tilde{\sigma}}=\gamma_c\Phi(1-\lambda)\mu^p,\quad
\Theta_n=\lambda\Phi(1-\alpha)(1+\varphi),\quad
\Theta_t=\lambda\Phi\mu^p,\quad
\Phi=(\gamma_c\mu^p-\lambda(1-\alpha))^{-1}.
```

**(F5) 不完全劳动市场变体的工资方程**

```math
w_t=c_t+\varphi n_t.
```

**(F6) 约化变量形式的新凯恩斯 Phillips 曲线**

```math
\pi_t=\beta E_t\{\pi_{t+1}\}+\lambda_p c_t-\alpha\lambda_p k_t+(\alpha+\varphi)\lambda_p n_t,
```

其中 $`\lambda_p=(1-\beta\theta)(1-\theta)/\theta`$。

**(F7) 代入政策规则后的约化总 Euler 方程**

```math
c_t-\Theta_n n_t+\frac{\phi_{\pi}}{\tilde{\sigma}}\pi_t
=E_t\{c_{t+1}\}+\frac{1}{\tilde{\sigma}}E_t\{\pi_{t+1}\}
-\Theta_nE_t\{n_{t+1}\}
+\Theta_t\phi_b\Delta b_{t+1}
+\Theta_t\phi_g(\rho_g-1)g_t.
```

**(F8) 投资与 Tobin's-q 约化条件**

```math
\begin{aligned}
&(1-\alpha)n_t-\gamma_c c_t-(1-\tilde{\gamma}_c-\alpha)k_t
+(1-\tilde{\gamma}_c)\eta\phi_{\pi}\pi_t \\
&=[\omega(1+\varphi)+\beta(1-\alpha)]E_t\{n_{t+1}\}
+(\omega-\beta\gamma_c)E_t\{c_{t+1}\}
-[\omega+\beta(1-\tilde{\gamma}_c-\alpha)]k_{t+1} \\
&\quad +(1-\tilde{\gamma}_c)\eta E_t\{\pi_{t+1}\}+(1-\beta\rho_g)g_t,
\end{aligned}
```

其中 $`\tilde{\gamma}_c=\gamma_c+\gamma_g`$ 且 $`\omega=\eta[1-\beta(1-\delta)](1-\tilde{\gamma}_c)`$。

## 4. Market Clearing & Identities

**(F9) 消费与工时的总量定义**

```math
C_t=\lambda C_t^r+(1-\lambda)C_t^o,\qquad
N_t=\lambda N_t^r+(1-\lambda)N_t^o.
```

**(F10) 总投资与资本**

```math
I_t=(1-\lambda)I_t^o,\qquad K_t=(1-\lambda)K_t^o.
```

**(F11) Log-linear 生产函数**

```math
y_t=(1-\alpha)n_t+\alpha k_t.
```

**(F12) 产品市场出清**

```math
y_t=\gamma_c c_t+\gamma_i i_t+g_t.
```

**(F13) 约化资本积累方程**

```math
k_{t+1}=\left(1-\delta+\frac{\delta\alpha}{1-\tilde{\gamma}_c}\right)k_t
+\frac{\delta(1-\alpha)}{1-\tilde{\gamma}_c}n_t
-\frac{\delta\gamma_c}{1-\tilde{\gamma}_c}c_t
-\frac{\delta}{1-\tilde{\gamma}_c}g_t.
```

**(F14) Phillips 曲线使用的实际边际成本/加成关系**

```math
\mu_t=y_t-c_t-(1+\varphi)n_t.
```

**(F15) 税收规则**

```math
t_t=\phi_b b_t+\phi_g g_t.
```

**(F16) 债务积累**

```math
b_{t+1}=(1+\rho)(1-\phi_b)b_t+(1+\rho)(1-\phi_g)g_t.
```

## 5. Exogenous Processes

**(F17) 政府支出冲击**

```math
g_t=\rho_g g_{t-1}+\varepsilon_t.
```

MMB 示例使用一个外生创新 `e_g`，并计算财政支出冲击的 IRF。该实现中没有单独的货币政策冲击。

## 6. Steady-State Solution

模型以对数偏离或稳态归一化偏离求解，因此 MMB 实现中的所有动态变量初始化为零：

```math
n=c=\pi=k=b=g=y=w=t=i=0.
```

论文用于定义约化系数的稳态关系包括：

```math
\rho=\beta^{-1}-1,
```

```math
\gamma_c=(1-\gamma_g)-\frac{\delta\alpha}{(\rho+\delta)\mu^p},
```

```math
\gamma_i=1-\gamma_c-\gamma_g,\qquad \tilde{\gamma}_c=\gamma_c+\gamma_g.
```

随后由校准结构参数计算约化系统系数：

```math
\lambda_p=\frac{(1-\beta\theta)(1-\theta)}{\theta},
```

```math
\Phi=(\gamma_c\mu^p-\lambda(1-\alpha))^{-1},\quad
\frac{1}{\tilde{\sigma}}=\gamma_c\Phi(1-\lambda)\mu^p,
```

```math
\Theta_t=\lambda\Phi\mu^p,\quad
\Theta_n=\lambda\Phi(1-\alpha)(1+\varphi),\quad
\omega=\eta[1-\beta(1-\delta)](1-\tilde{\gamma}_c).
```

源论文按季度校准 $`\beta=0.99`$、$`\delta=0.025`$、$`\alpha=1/3`$、基准 $`\lambda=1/2`$、$`\theta=0.75`$、$`\varphi=0.2`$、$`\eta=1`$、$`\phi_\pi=1.5`$、$`\rho_g=0.9`$、$`\phi_g=0.10`$、$`\phi_b=0.33`$ 和 $`\gamma_g=0.2`$。实现交叉检查使用 `alpha=0.33` 和 `my_p=1.2`；论文符号将 $`\mu^p`$ 描述为总价格加成，但有一句文字称加成为 0.2，因此本条目将实现值保留为交叉检查，并把加成约定标记为 `needs_review`。

## 7. Timing & Form Conventions

- 实际 MMB 文件本质上是 `model(linear)`：所有内生变量都是围绕稳态的偏离。
- 在论文时序中，优化型家庭选择的资本由当期投资形成 $`K_{t+1}`$；MMB 示例将 `k` 和 `b` 声明为 predetermined variables。
- Appendix C 中的约化状态向量为 $`\mathbf{x}_t=(n_t,c_t,\pi_t,k_t,b_t,g_{t-1})'`$。
- 通胀 $`\pi_t`$ 是围绕零通胀的对数偏离。
- 政府支出 $`g_t`$、税收 $`t_t`$ 和债务 $`b_t`$ 均按稳态产出归一化。
- 实现使用不完全竞争劳动市场约化方程；完全竞争劳动市场的总 Euler 方程在论文中有记录，但不是所选 `NK_GLSV07` 变体。
- 未执行运行时验证。

## 8. Variable & Parameter Reference Table

| 类别 | 符号 / ASCII | 含义 | 方程参考 |
|---|---|---|---|
| 内生 | `n`, $`n_t`$ | 总工时 | (F5), (F7), (F8), (F11), (F13) |
| 内生 | `c`, $`c_t`$ | 总消费 | (F4), (F7), (F8), (F12), (F13) |
| 内生 | `pi`, $`\pi_t`$ | 通胀 | (F6), (F7), (F8) |
| 内生 | `k`, $`k_t`$ | 资本存量偏离 | (F8), (F11), (F13) |
| 内生 | `b`, $`b_t`$ | 政府债务偏离 | (F16) |
| 内生 | `g`, $`g_t`$ | 政府支出偏离 | (F17) |
| 内生 | `y`, $`y_t`$ | 产出 | (F11), (F12) |
| 内生 | `w`, $`w_t`$ | 实际工资 | (F5) |
| 内生 | `t`, $`t_t`$ | 税收 | (F15) |
| 内生 | `i`, $`i_t`$ | 投资 | (F12), (F13), 实现恒等式 |
| 外生 | `e_g`, $`\varepsilon_t`$ | 政府支出创新 | (F17) |
| 参数 | `alpha`, $`\alpha`$ | 资本份额 | (F6), (F8), (F11), (F13) |
| 参数 | `beta`, $`\beta`$ | 贴现因子 | (F1), (F6), (F8) |
| 参数 | `delta`, $`\delta`$ | 折旧率 | (F2), (F13) |
| 参数 | `eta`, $`\eta`$ | 投资对 $`q`$ 的弹性 | (F8) |
| 参数 | `theta`, $`\theta`$ | Calvo 不调价概率 | (F6), 稳态系数 |
| 参数 | `lambda`, $`\lambda`$ | 经验法则家庭占比 | (F4), (F9), 系数 |
| 参数 | `lambda_p`, $`\lambda_p`$ | Phillips 曲线斜率 | (F6) |
| 参数 | `my_p`, $`\mu^p`$ | 价格加成约定，needs_review | (F4), (F14), 稳态系数 |
| 参数 | `rho_g`, $`\rho_g`$ | 政府支出持续性 | (F7), (F17) |
| 参数 | `phi_b`, $`\phi_b`$ | 税收对债务的反应 | (F7), (F15), (F16) |
| 参数 | `phi_g`, $`\phi_g`$ | 税收对支出的反应 | (F7), (F15), (F16) |
| 参数 | `phi_pi`, $`\phi_\pi`$ | 货币政策对通胀的反应 | (F7), (F8) |
| 参数 | `psi`, $`\varphi`$ | 工资-工时弹性 / 劳动负效用曲率 | (F5), (F6), (F8) |
| 参数 | `sigma_bar`, $`\tilde{\sigma}`$ | 总 Euler 系数 | (F4), (F7) |
| 参数 | `theta_n`, $`\Theta_n`$ | 总 Euler 方程中的工时系数 | (F4), (F7) |
| 参数 | `theta_tau`, $`\Theta_t`$ | 总 Euler 方程中的税收系数 | (F4), (F7) |
| 参数 | `omega`, $`\omega`$ | 投资模块复合系数 | (F8) |
