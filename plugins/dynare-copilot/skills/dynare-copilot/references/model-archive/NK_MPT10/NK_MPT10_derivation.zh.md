# NK_MPT10 - 推导（最优化问题 + 一阶条件）

> 归档状态：needs_review。未执行运行时验证。`.mod` 文件仅作为 `implementation_cross_check` 使用，不作为论文侧数学来源。

来源溯源：`NK_MPT10`，Monacelli, Tommaso; Perotti, Roberto; Trigari, Antonella (2010), "Unemployment fiscal multipliers", Journal of Monetary Economics 57(5), 531-553, DOI `10.1016/j.jmoneco.2010.05.009`。主 OCR Markdown：`raw/mmb_mineru/runs/nk_mpt10__unemployment_fiscal_multipliers__7b622dc6/full.md`；原始 PDF：`raw/mmb_papers/Unemployment fiscal multipliers.pdf`；MinerU run id：`7b622dc6-7f76-4474-a39f-7237f4510f1b`。

## 1. 模型概述

- **模型**：Monacelli, Perotti, and Trigari (2010) 第 7 节的月度搜索匹配财政冲击模型及其新凯恩斯扩展。MMB 实现标签为 `NK_MPT10`。
- **实验**：政府支出冲击，论文模拟中校准为政府购买上升稳态产出的 1%；MMB 实现对应论文 Figure 11 的 `sigma=1` 情形。
- **主体与模块**：代表性家庭/家庭共同体、带空缺发布和搜索摩擦的中间品厂商、工资 Nash bargaining、带投资调整成本的资本积累、财政当局、带 Calvo 价格粘性的垄断竞争零售商，以及 Taylor 型货币政策规则。
- **形式**：非线性均衡系统，在实现中用一阶扰动求解。论文还给出用于机制解释的紧缩度对数线性方程，但除非明确标注为对数线性诊断，下列模型方程均按非线性形式记录。
- **来源质量说明**：论文 OCR 清楚保留了基准模型方程 (1)-(29)、扩展方程 (35)-(39) 和第 7 节 NK surplus 方程。论文侧文本未完整暴露所有 Calvo 递归方程；这些方程标记为 `needs_review`，并仅用 `NK_MPT10_rep.mod` 进行交叉核对。

## 2. 主体的最优化问题

### 2.1 匹配与就业时序

在 $`t`$ 期初，失业搜索者为

```math
u_t = 1 - n_{t-1}.
```

匹配函数为 Cobb-Douglas。新匹配在当期投入生产，直到下一期才面临分离：

```math
m_t = \gamma_m u_t^\gamma v_t^{1-\gamma}, \qquad
q_t = \frac{m_t}{v_t} = \gamma_m\theta_t^{-\gamma}, \qquad
p_t = \frac{m_t}{u_t} = \gamma_m\theta_t^{1-\gamma}, \qquad
\theta_t = \frac{v_t}{u_t}.
```

### 2.2 中间品厂商

代表性中间品厂商在给定工资、资本租金和匹配概率下选择资本和就业（等价地选择空缺）：

```math
F(n_{t-1},k_t)=\max_{\{k_t,n_t\}}
\left\{
z_t k_t^\alpha n_t^{1-\alpha}
-w_t n_t-\kappa v_t-r_{k,t}k_t
+\beta E_t\left[\Lambda_{t,t+1}F(n_t,k_{t+1})\right]
\right\}
```

约束为

```math
n_t=\rho n_{t-1}+q_t v_t.
```

在 NK 扩展中，中间品厂商把产品卖给零售商；实际边际成本是 markup 的倒数，因此进入 surplus 的边际产出按 $`mc_t=\mu_t^{-1}`$ 缩放。

### 2.3 代表性家庭 / 家庭共同体

家庭在成员之间 pooling 收入。对就业与失业成员消费分配优化后，论文把家庭写为最大化

```math
E_0\sum_{t=0}^{\infty}\beta^t
\frac{c_t^{1-\sigma}\left(1+(\sigma-1)b n_t\right)^\sigma-1}{1-\sigma}
```

约束为单期预算约束

```math
c_t+i_t+E_t\left[\Lambda_{t,t+1}B_{t+1}\right]
\leq w_t n_t+r_{k,t}k_t+B_t+\pi_t-\tau_t,
```

资本积累

```math
k_{t+1}=(1-\delta)k_t+i_t(1-\phi_t),
```

以及家庭就业运动方程

```math
n_t=\rho n_{t-1}+p_t(1-n_{t-1}).
```

### 2.4 工资议价

厂商与边际工人通过 Nash bargaining 选择工资：

```math
\max_{w_t}\; (H_{n,t})^\eta(F_{n,t})^{1-\eta},
```

其中 $`H_{n,t}`$ 是家庭多一个就业成员的价值，$`F_{n,t}`$ 是厂商多一个工人的价值。

### 2.5 零售价格设定

零售商在竞争性市场购买中间品、差异化产出，并在垄断竞争下销售最终品。论文说明采用传统 Calvo 设定，重设价格概率为 $`1-\phi`$，并给出 Taylor rule；但 OCR Markdown 没有包含完整零售商优化方程。因此下面的 Calvo 递归式为 `needs_review`，并记录为 `implementation_cross_check`，因为它们可在 MMB `.mod` 中看到。

## 3. 一阶条件（FOC）

- **(F1) 就业运动方程**：

```math
n_t=\rho n_{t-1}+q_t v_t.
```

- **(F2) 资本租金率**：

```math
r_{k,t}=\alpha\frac{y_t}{k_t}.
```

- **(F3) 厂商招聘条件**：

```math
\frac{\kappa}{q_t}
=a_t-w_t+\rho\beta E_t\left[\Lambda_{t,t+1}\frac{\kappa}{q_{t+1}}\right].
```

- **(F4) 厂商边际工人价值**：

```math
F_{n,t}=a_t-w_t+\rho\beta E_t\left[\Lambda_{t,t+1}F_{n,t+1}\right].
```

- **(F5) 空缺成本等于厂商边际工人价值**：

```math
\frac{\kappa}{q_t}=F_{n,t}.
```

- **(F6) 家庭财富边际效用**：

```math
\lambda_t=\left(\frac{1+(\sigma-1)b n_t}{c_t}\right)^\sigma.
```

- **(F7) 投资调整成本 FOC**：

```math
\varphi_t\left[1-\left(\phi_t+\frac{i_t}{i_{t-1}}\phi_{i,t}\right)\right]
=1-\beta E_t\left[
\varphi_{t+1}\Lambda_{t,t+1}
\left(\frac{i_{t+1}}{i_t}\right)^2\phi_{i,t+1}
\right].
```

- **(F8) 资本 FOC**：

```math
\varphi_t=\beta E_t\left[\Lambda_{t,t+1}\left(r_{k,t+1}+\varphi_{t+1}(1-\delta)\right)\right].
```

- **(F9) 家庭就业边际价值**：

```math
H_{n,t}=\lambda_t w_t-U_{n,t}
+\beta(\rho-p_{t+1})E_t\left[H_{n,t+1}\right].
```

- **(F10) 就业边际负效用**：

```math
U_{n,t}=\sigma b\left(\frac{1+(\sigma-1)b n_t}{c_t}\right)^{\sigma-1}.
```

- **(F11) 非工作活动边际价值**：

```math
\omega_t=\frac{U_{n,t}}{\lambda_t}=\sigma b\lambda_t^{-1/\sigma}.
```

- **(F12) Nash bargaining 条件**：

```math
\eta F_{n,t}=(1-\eta)\frac{H_{n,t}}{\lambda_t}.
```

- **(F13) 总 surplus 定义**：

```math
S_{n,t}=\frac{H_{n,t}}{\lambda_t}+F_{n,t}.
```

- **(F14) 工人 surplus 份额**：

```math
\frac{H_{n,t}}{\lambda_t}=\eta S_{n,t}.
```

- **(F15) 厂商 surplus 份额**：

```math
F_{n,t}=(1-\eta)S_{n,t}.
```

- **(F16) 保留工资差**：

```math
S_{n,t}=\overline{w}_t-\underline{w}_t.
```

- **(F17) 厂商保留工资**：

```math
\overline{w}_t=a_t+\rho\beta E_t\left[\Lambda_{t,t+1}F_{n,t+1}\right].
```

- **(F18) 工人保留工资**：

```math
\underline{w}_t=\omega_t-\beta E_t\left[(\rho-p_{t+1})\Lambda_{t,t+1}H_{n,t+1}\right].
```

- **(F19) 议价工资**：

```math
w_t=\eta\overline{w}_t+(1-\eta)\underline{w}_t.
```

- **(F20) 总 match surplus 递归式**：

```math
S_{n,t}=a_t-\omega_t+\beta E_t\left[(\rho-\eta p_{t+1})\Lambda_{t,t+1}S_{n,t+1}\right].
```

- **(F21) 紧缩度形式的招聘条件**：

```math
\kappa\gamma_m^{-1}\theta_t^\gamma=(1-\eta)S_{n,t}.
```

- **(F22) 合并后的紧缩度方程**：

```math
\kappa\gamma_m^{-1}\theta_t^\gamma
=(1-\eta)(a_t-\omega_t)
+\beta E_t\left[(\rho-\eta p_{t+1})\Lambda_{t,t+1}
\kappa\gamma_m^{-1}\theta_{t+1}^\gamma\right].
```

- **(F23) NK 有效劳动边际产出**：

```math
a_{\mu,t}=\mu_t^{-1}a_t.
```

- **(F24) NK match surplus 递归式**：

```math
S_{n,t}=a_{\mu,t}-\omega_t
+\beta E_t\left[(\rho-\eta p_{t+1})\Lambda_{t,t+1}S_{n,t+1}\right].
```

- **(F25) 第 7 节 Taylor rule**：

```math
1+r_t^n=(1+r)\pi_t^{\phi_\pi}\left(\frac{y_t}{y_{t-1}}\right)^{\phi_y}.
```

- **(F26) 名义利率和实际利率的 Fisher 关系**（`implementation_cross_check`）：

```math
1+r_t^n=(1+r_t)\pi_{t+1}.
```

- **(F27) Calvo 价格分散度递归式**（`needs_review`, `implementation_cross_check`）：

```math
D_t=\phi D_{t-1}\pi_{t-1}^{-\gamma_P\epsilon}\pi_t^\epsilon
+(1-\phi)\left(\frac{1-\phi\pi_{t-1}^{\gamma_P(1-\epsilon)}\pi_t^{\epsilon-1}}{1-\phi}\right)^{-\epsilon/(1-\epsilon)}.
```

- **(F28) Calvo 分子递归式**（`needs_review`, `implementation_cross_check`）：

```math
P_{F,t}=Y_t mc_t+\beta\phi E_t\left[
\Lambda_{t,t+1}\pi_{t+1}^{\epsilon}\pi_t^{-\epsilon\gamma_P}P_{F,t+1}
\right].
```

- **(F29) Calvo 分母递归式**（`needs_review`, `implementation_cross_check`）：

```math
P_{Z,t}=Y_t+\beta\phi E_t\left[
\Lambda_{t,t+1}\pi_{t+1}^{\epsilon-1}\pi_t^{\gamma_P(1-\epsilon)}P_{Z,t+1}
\right].
```

- **(F30) 最优重设价格关系**（`needs_review`, `implementation_cross_check`）：

```math
\pi_t^\star=\frac{\epsilon}{\epsilon-1}\frac{P_{F,t}}{P_{Z,t}}\pi_t.
```

- **(F31) 价格指数条件**（`needs_review`, `implementation_cross_check`）：

```math
\pi_t^{1-\epsilon}=\phi\pi_{t-1}^{\gamma_P(1-\epsilon)}
+(1-\phi)(\pi_t^\star)^{1-\epsilon}.
```

## 4. 市场出清与总量恒等式

- **(F32) 生产函数**：

```math
y_t=z_t k_t^\alpha n_t^{1-\alpha}.
```

在 NK 实现中，源侧中间品产出和最终产出通过价格分散度区分：

```math
y_t=Y_tD_t.
```

- **(F33) 资本积累**：

```math
k_{t+1}=(1-\delta)k_t+i_t(1-\phi_t).
```

- **(F34) 投资调整成本**：

```math
\phi_t=\frac{\eta_k}{2}\left(\frac{i_t}{i_{t-1}}-1\right)^2,\qquad
\phi_{i,t}=\eta_k\left(\frac{i_t}{i_{t-1}}-1\right).
```

- **(F35) 一次总付税下的政府预算**：

```math
\tau_t=g_t.
```

- **(F36) 总资源约束**：

```math
y_t=c_t+g_t+i_t+\kappa v_t.
```

- **(F37) 匹配函数**：

```math
m_t=\gamma_m u_t^\gamma v_t^{1-\gamma}.
```

- **(F38) 空缺填补概率**：

```math
q_t=\gamma_m\theta_t^{-\gamma}.
```

- **(F39) 找到工作概率**：

```math
p_t=\gamma_m\theta_t^{1-\gamma}.
```

- **(F40) 劳动力市场紧缩度**：

```math
\theta_t=\frac{v_t}{u_t}.
```

- **(F41) 失业恒等式**：

```math
u_t=1-n_{t-1}.
```

- **(F42) flexible-price benchmark output gap**（`implementation_cross_check`）：

```math
outputgap_t=Y_t-Y^{fe}_t.
```

## 5. 外生过程

- **(F43) 政府支出过程**：

```math
\log(g_t)=(1-\rho_g)\log(g_{ss})+\rho_g\log(g_{t-1})+\varepsilon_{g,t}.
```

论文方程 (28) 的 OCR/发表文本在截距中写稳态份额 $`g_y`$；MMB 实现注释说明这里需要替换为政府支出的稳态水平 $`g_{ss}`$。这记录为实现交叉核对，不作为新的论文来源。

- **(F44) 货币政策冲击**（`implementation_cross_check`）：

```math
\varepsilon_{i,t}
```

在实现中声明，但用于论文复制的 active Taylor rule 没有启用该冲击。

## 6. 稳态求解

模型以月度频率校准。论文给出常规参数 $`\beta=0.99^{1/3}`$、$`\delta=0.025/3`$、$`\alpha=1/3`$、$`\rho_g=0.9^{1/3}`$、匹配弹性 $`\gamma=0.5`$、议价权重 $`\eta=0.5`$、基准可分偏好 $`\sigma=1`$。NK 第 7 节给出 16% 稳态 markup、四个季度价格粘性，以及 Taylor 参数 $`\phi_\pi=1.5`$ 和 $`\phi_y=0.5/4`$；实现中把若干参数转换到月度频率。

使用如下有来源依据的稳态顺序：

1. 选择目标：$`\theta=0.5`$、$`p=0.45`$、$`\overline{\omega}=0.9`$、$`G/Y=0.2`$，以及 MMB 复制中的 $`\sigma=1`$。
2. 设 $`q=\gamma_m\theta^{-\gamma}`$ 和 $`p=\gamma_m\theta^{1-\gamma}`$，因此 $`\gamma_m=p\theta^{\gamma-1}`$。
3. 就业和失业：

```math
n=\frac{p}{1-\rho+p}, \qquad u=1-n, \qquad v=\theta u,\qquad m=\gamma_m u^\gamma v^{1-\gamma}.
```

4. 资本回报：

```math
r_k=\frac{1}{\beta}+\delta-1.
```

5. 给定 NK 实际边际成本 $`mc=(\epsilon-1)/\epsilon`$，使用

```math
\frac{Y}{K}=\frac{r_k}{\alpha mc}, \qquad
\frac{K}{N}=\left(\frac{Y}{K}\right)^{1/(\alpha-1)}, \qquad
k=\frac{K}{N}n,\qquad y=\frac{Y}{K}k.
```

6. 劳动边际产出：

```math
a=(1-\alpha)mc\frac{y}{n}.
```

7. 投资和政府：

```math
i=\delta k,\qquad g=0.2y,\qquad \tau=g.
```

8. 非工作价值、surplus、厂商工人价值和招聘成本：

```math
\omega=\overline{\omega}a,\qquad
S=\frac{a-\omega}{1-\beta(\rho-\eta p)},\qquad
F=(1-\eta)S,\qquad
\kappa=Fq.
```

9. 工资和保留工资：

```math
w=a-(1-\rho\beta)F,\qquad
\overline{w}=a+\rho\beta F,\qquad
\underline{w}=\overline{w}-S.
```

10. 由资源约束得到消费：

```math
c=y-g-i-\kappa v.
```

11. 恢复偏好参数：

```math
b=\frac{\omega}{c\sigma-(\sigma-1)\omega n}, \qquad
\lambda=\left(\frac{\sigma b}{\omega}\right)^\sigma.
```

12. NK 稳态值：$`\pi=1`$、$`\pi^\star=1`$、$`D=1`$、$`Y=y`$、$`mc=(\epsilon-1)/\epsilon`$、$`P_F=Ymc/(1-\beta\phi)`$、$`P_Z=Y/(1-\beta\phi)`$、$`1+r^n=1+r`$。

active 实现包含用于 output-gap 构造的 `_fe` flexible-price duplicate block；该模块仅为 `implementation_cross_check`。

## 7. 时序与形式约定

- 模型为月度频率。论文中的部分参数表示为季度值的月度转换。
- 就业通过失业恒等式 $`u_t=1-n_{t-1}`$ 体现预定性；新雇佣在 $`t`$ 期投入生产。
- 论文记号中的家庭资本运动方程为 $`k_{t+1}=(1-\delta)k_t+i_t(1-\phi_t)`$。实现中转换为 Dynare stock convention，即 `k = (1-delta)*k(-1)+...`，因此生产使用 `k(-1)`。
- 随机贴现因子为 $`\Lambda_{t,t+1}=\lambda_{t+1}/\lambda_t`$。
- MMB 文件为非线性形式，让 Dynare 计算一阶近似。论文的 tightness 对数线性方程是诊断式，不是 maintained implementation form。
- NK Calvo block 可在 `.mod` 中看到，但论文 OCR 没有完整保留公式。它仍需用 PDF 或更好来源复核，状态为 `needs_review`。
- Dynare 运行时验证：按指令未执行。

## 8. 变量与参数对照表

| 类别 | 符号 / ASCII | 含义 | 主要方程 |
|---|---|---|---|
| 内生变量 | `q`, $`q_t`$ | 空缺被填补概率 | (F38) |
| 内生变量 | `rk`, $`r_{k,t}`$ | 资本租金率 | (F2) |
| 内生变量 | `y`, $`y_t`$ | 中间品产出 | (F32) |
| 内生变量 | `k`, $`k_t`$ | 资本存量 | (F33) |
| 内生变量 | `w`, $`w_t`$ | 议价实际工资 | (F19) |
| 内生变量 | `lambda`, $`\lambda_t`$ | 财富边际效用 | (F6) |
| 内生变量 | `F`, $`F_{n,t}`$ | 厂商边际工人价值 | (F4), (F5) |
| 内生变量 | `n`, $`n_t`$ | 就业 | (F1) |
| 内生变量 | `p`, $`p_t`$ | 找到工作概率 | (F39) |
| 内生变量 | `theta`, $`\theta_t`$ | 劳动力市场紧缩度 | (F40) |
| 内生变量 | `u`, $`u_t`$ | 失业/搜索者 | (F41) |
| 内生变量 | `i`, $`i_t`$ | 投资 | (F7), (F33) |
| 内生变量 | `phi`, $`\phi_t`$ | 投资调整成本 | (F34) |
| 内生变量 | `c`, $`c_t`$ | 消费 | (F36) |
| 内生变量 | `phi_i`, $`\phi_{i,t}`$ | 调整成本导数 | (F34) |
| 内生变量 | `omega`, $`\omega_t`$ | 非工作价值 | (F11) |
| 内生变量 | `H`, $`H_{n,t}`$ | 家庭就业价值 | (F9) |
| 内生变量 | `w_bar`, $`\overline{w}_t`$ | 厂商保留工资 | (F17) |
| 内生变量 | `w_und`, $`\underline{w}_t`$ | 工人保留工资 | (F18) |
| 内生变量 | `S`, $`S_{n,t}`$ | 总 match surplus | (F20), (F24) |
| 内生变量 | `tau`, $`\tau_t`$ | 一次总付税 | (F35) |
| 内生变量 | `g`, $`g_t`$ | 政府支出 | (F43) |
| 内生变量 | `v`, $`v_t`$ | 空缺 | (F1), (F37), (F40) |
| 内生变量 | `m`, $`m_t`$ | 匹配数 | (F37) |
| 内生变量 | `Lambda`, $`\Lambda_{t,t+1}`$ | 随机贴现因子比率 | (F7), (F8) |
| 内生变量 | `varphi`, $`\varphi_t`$ | 投资影子价值 | (F7), (F8) |
| 内生变量 | `r`, $`r_t`$ | 净实际利率 | (F26) |
| 内生变量 | `i_nom`, $`r_t^n`$ | 净名义利率 | (F25), (F26) |
| 内生变量 | `mc`, $`mc_t`$ | 实际边际成本 / markup 倒数 | (F23), (F28) |
| 内生变量 | `Dis`, $`D_t`$ | 价格分散度 | (F27) |
| 内生变量 | `Y`, $`Y_t`$ | 最终产出 | (F32), (F36) |
| 内生变量 | `infl`, $`\pi_t`$ | 最终品通胀 | (F25), (F31) |
| 内生变量 | `inflstar`, $`\pi_t^\star`$ | 最优重设价格通胀 | (F30), (F31) |
| 内生变量 | `P_F`, $`P_{F,t}`$ | Calvo 分子辅助变量 | (F28) |
| 内生变量 | `P_Z`, $`P_{Z,t}`$ | Calvo 分母辅助变量 | (F29) |
| 内生变量 | `_fe` variables | flexible-price benchmark 对应变量 | (F42) |
| 内生变量 | `outputgap` | 最终产出减去 flexible-price 产出 | (F42) |
| 外生变量 | `e`, $`\varepsilon_{g,t}`$ | 政府支出创新 | (F43) |
| 外生变量 | `e_i`, $`\varepsilon_{i,t}`$ | 货币政策创新，已声明但未启用 | (F44) |
| 参数 | `alpha`, $`\alpha`$ | 资本份额 | (F2), (F32) |
| 参数 | `beta`, $`\beta`$ | 贴现因子 | (F3), (F7), (F8) |
| 参数 | `rho`, $`\rho`$ | 工作存续概率 | (F1), (F20) |
| 参数 | `gamma_m`, $`\gamma_m`$ | 匹配效率 | (F37)-(F39) |
| 参数 | `gamma`, $`\gamma`$ | 匹配弹性 | (F37)-(F39) |
| 参数 | `delta`, $`\delta`$ | 折旧 | (F33) |
| 参数 | `eta_k`, $`\eta_k`$ | 投资调整成本曲率 | (F34) |
| 参数 | `sigma`, $`\sigma`$ | 互补性 / 跨期参数 | (F6), (F10), (F11) |
| 参数 | `eta`, $`\eta`$ | 工人议价权重 | (F12), (F20) |
| 参数 | `b` | 相对工作负效用 / 非工作偏好参数 | (F6), (F11) |
| 参数 | `kappa`, $`\kappa`$ | 空缺发布成本 | (F3), (F21), (F36) |
| 参数 | `rho_g`, $`\rho_g`$ | 政府支出持续性 | (F43) |
| 参数 | `rho_i`, $`\rho_i`$ | 实现中的利率平滑 | (F25) cross-check |
| 参数 | `kappa_pi`, $`\phi_\pi`$ | Taylor 通胀系数 | (F25) |
| 参数 | `kappa_y`, $`\phi_y`$ | Taylor 产出增长系数 | (F25) |
| 参数 | `epsilon`, $`\epsilon`$ | 零售品替代弹性 | (F27)-(F31) |
| 参数 | `gam`, $`\phi`$ | Calvo 不重设价格概率 | (F27)-(F31) |
| 参数 | `gam_P`, $`\gamma_P`$ | 指数化/后顾价格设定参数 | (F27)-(F31) |
| 参数 | steady-state suffix `_ss` | 实现稳态值 | 第 6 节 |
