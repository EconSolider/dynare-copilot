# NK_RW06AL - 推导（最优化问题 + 一阶条件）

> `NK_RW06AL` 的模型归档条目。来源：Federico Ravenna and Carl E. Walsh (2006), "Optimal monetary policy with the cost channel", *Journal of Monetary Economics* 53(2), 199-216, DOI `10.1016/j.jmoneco.2005.01.004`。

## 1. Model Overview

- **模型**：线性化的新凯恩斯成本渠道模型；此处归档的是 MMB 自适应学习变体 `NK_RW06AL`。
- **论文侧目标**：研究企业在销售收入实现前借入营运资本支付工资时的最优货币政策；此时名义利率直接进入实际边际成本。
- **实现变体**：MMB `NK_RW06AL` `.mod` 是紧凑政策模型的自适应学习实现。`.mod` 仅作为 `implementation_cross_check` 使用，不作为论文侧数学来源。
- **主体与模块**：代表性家庭、具有 Calvo 定价的垄断竞争最终品厂商、竞争性金融中介、财政当局和货币当局。
- **刚性与楔子**：Calvo 价格粘性、垄断竞争、由 $C_t=\gamma_tY_t$ 产生的政府支出楔子、偏好冲击 $\xi_t$、生产率冲击 $A_t$，以及营运资本成本渠道。
- **形式**：`model(linear)`。论文先给出非线性原始条件，再使用稳态附近的对数偏离。MMB 实现包含内生变量 `x`、`pi`、`R` 以及 modelbase 报告变量。
- **运行验证**：未执行。此归档条目没有运行 Dynare。

## 2. Optimization Problems

### 代表性家庭

家庭选择消费、劳动、存款和货币持有，以最大化期望效用：

$$
E_t\sum_{i=0}^{\infty}\beta^i\left[
\frac{\xi_{t+i}C_{t+i}^{1-\sigma}}{1-\sigma}
-\chi\frac{N_{t+i}^{1+\eta}}{1+\eta}
\right].
$$

综合消费由差异化商品聚合：

$$
C_t=\left[\int_0^1 c_{jt}^{(\theta-1)/\theta}\,dj\right]^{\theta/(\theta-1)},\qquad \theta>1.
$$

家庭面临现金先付约束和货币积累方程：

$$
P_tC_t\le M_t+W_tN_t-D_t,
$$

$$
M_{t+1}=M_t+W_tN_t-D_t-P_tC_t+R_tD_t+\Pi_t-T_t.
$$

### 商品需求与价格指数

综合品成本最小化给出对厂商 $j$ 的需求和总价格指数：

$$
c_{jt}=\left(\frac{p_{jt}}{P_t}\right)^{-\theta}C_t,
$$

$$
P_t=\left[\int_0^1 p_{jt}^{1-\theta}\,dj\right]^{1/(1-\theta)}.
$$

### 厂商与成本渠道

厂商 $j$ 使用线性劳动技术生产：

$$
y_{jt}=A_tN_{jt}.
$$

营运资本假设是厂商在生产收入到账前借入工资账单。若 $R_t$ 为名义总利率且 $w_t=W_t/P_t$，实际边际成本为：

$$
\varphi_t\equiv \frac{R_tw_t}{A_t}=R_tS_t.
$$

在弹性价格下，厂商令边际成本等于加成的倒数：

$$
\frac{R_tw_t}{A_t}=\frac{\theta-1}{\theta}=\frac{1}{\Phi},\qquad \Phi\equiv\frac{\theta}{\theta-1}.
$$

### Calvo 定价

每期有比例 $1-\omega$ 的厂商可以重新定价；其余比例按稳态通胀率更新原价格。重新定价的一阶条件导出论文使用的线性新凯恩斯 Phillips 曲线。

### 财政与政策环境

商品市场出清和政府支出份额为：

$$
Y_t=C_t+G_t,\qquad G_t=(1-\gamma_t)Y_t,\qquad C_t=\gamma_tY_t.
$$

论文的政策问题以名义利率作为政策工具，并推导出关于通胀和福利相关产出缺口的福利损失。

## 3. First-Order Conditions

- **(F1) 家庭 Euler 方程**：

$$
\xi_tC_t^{-\sigma}
=\beta E_t\left(\frac{R_tP_t}{P_{t+1}}\right)\xi_{t+1}C_{t+1}^{-\sigma}.
$$

- **(F2) 家庭劳动供给**：

$$
\frac{\chi N_t^{\eta}}{\xi_tC_t^{-\sigma}}=\frac{W_t}{P_t}=w_t.
$$

- **(F3) 现金先付条件**：

$$
P_tC_t=M_t+W_tN_t-D_t.
$$

- **(F4) 弹性价格产出**：

$$
Y_t^f=\left[
\frac{\xi_t\gamma_t^{-\sigma}A_t^{1+\eta}}{\chi\Phi R_t^f}
\right]^{1/(\sigma+\eta)}.
$$

- **(F5) 对数偏离形式的弹性价格产出**：

$$
\hat Y_t^f=\frac{1}{\sigma+\eta}
\left[(1+\eta)\hat A_t-\sigma\hat\gamma_t+\hat\xi_t-\hat R_t^f\right].
$$

- **(F6) 有效产出**：

$$
Y_t^e=\left[
\frac{\xi_t\gamma_t^{1-\sigma}A_t^{1+\eta}}{\chi}
\right]^{1/(\sigma+\eta)}.
$$

- **(F7) 带成本渠道的实际边际成本**：

$$
\hat\varphi_t\approx \hat R_t+\hat s_t,
$$

其中 $\hat s_t$ 是劳动收入份额相对稳态的对数偏离。

- **(F8) 通胀调整方程**：

$$
\pi_t=\beta E_t\pi_{t+1}+\kappa\hat\varphi_t,\qquad
\kappa=\frac{(1-\omega)(1-\omega\beta)}{\omega}.
$$

- **(F9) 边际成本形式的成本渠道 Phillips 曲线**：

$$
\pi_t=\beta E_t\pi_{t+1}+\kappa(\hat R_t+\hat s_t).
$$

- **(F10) 缺口形式的 IS 曲线**：

$$
\hat Y_t-\hat Y_t^f
=E_t(\hat Y_{t+1}-\hat Y_{t+1}^f)
-\frac{1}{\sigma}\left[
(\hat R_t-E_t\pi_{t+1})-\hat r_t^f
\right].
$$

- **(F11) 弹性价格缺口形式的 Phillips 曲线**：

$$
\pi_t=\beta E_t\pi_{t+1}
+\kappa(\sigma+\eta)(\hat Y_t-\hat Y_t^f)
+\kappa(\hat R_t-\hat R_t^f).
$$

- **(F12) 福利产出缺口与损失函数**：

$$
L_t=\pi_t^2+\lambda(\hat Y_t-\hat Y_t^e-z^*)^2,
$$

其中

$$
\hat Y_t^e=\frac{(1+\eta)\hat A_t+\hat\xi_t+(1-\sigma)\hat\gamma_t}{\sigma+\eta}.
$$

- **(F13) 固定利率下的弹性产出参考值**：

$$
\hat Y_t^*=\frac{(1+\eta)\hat A_t-\sigma\hat\gamma_t+\hat\xi_t}{\sigma+\eta}.
$$

- **(F14) 用 $x_t$ 表示的成本渠道边际成本**：

$$
\hat\varphi_t=(\sigma+\eta)x_t+\hat R_t,\qquad
x_t\equiv \hat Y_t-\hat Y_t^*.
$$

- **(F15) 政策模型 IS 曲线**：

$$
x_t=E_tx_{t+1}-\frac{1}{\sigma}(\hat R_t-E_t\pi_{t+1})+u_t.
$$

- **(F16) 政策模型 Phillips 曲线**：

$$
\pi_t=\beta E_t\pi_{t+1}+\kappa(\sigma+\eta)x_t+\kappa\hat R_t.
$$

- **(F17) 复合需求扰动**：

$$
u_t\equiv \frac{1+\eta}{\sigma+\eta}
\left[
(E_t\hat A_{t+1}-\hat A_t)
-\frac{\eta}{\sigma}(E_t\hat\xi_{t+1}-\hat\xi_t)
+\frac{\eta}{1+\eta}(E_t\hat\gamma_{t+1}-\hat\gamma_t)
\right].
$$

- **(F18) 相机抉择下的最优性条件**：

$$
\pi_t=-\frac{\lambda}{\kappa\eta}
\left[x_t-\frac{1}{\sigma+\eta}\hat\gamma_t\right].
$$

`needs_review`：(F18) 是论文给出的相机抉择最优政策条件；MMB `NK_RW06AL` 自适应学习实现使用政策规则模块，而不是该最优性条件。

## 4. Market Clearing & Identities

- **(F19) 总资源约束**：

$$
Y_t=C_t+G_t.
$$

- **(F20) 政府支出份额**：

$$
G_t=(1-\gamma_t)Y_t,\qquad C_t=\gamma_tY_t.
$$

- **(F21) 厂商贷款市场恒等式**：

$$
W_tN_t^d=D_t+X_t.
$$

- **(F22) 现金注入恒等式**：

$$
X_t=M_{t+1}-M_t=(G_{t+1}^M-1)M_t.
$$

- **(F23) MMB 年化利率报告恒等式**（`implementation_cross_check`）：

$$
\text{interest}_t=4R_t.
$$

- **(F24) MMB 年化通胀报告恒等式**（`implementation_cross_check`）：

$$
\text{inflationq}_t=4\pi_t.
$$

- **(F25) MMB 四季度通胀恒等式**（`implementation_cross_check`）：

$$
\text{pinf4}_t=\frac{1}{4}
\left(\text{inflationq}_t+\text{inflationq}_{t-1}
+\text{inflationqls}_{t-1}\right).
$$

- **(F26) MMB 产出缺口报告恒等式**（`implementation_cross_check`）：

$$
\text{outputgap}_t=x_t,\qquad \text{output}_t=x_t.
$$

## 5. Exogenous Processes

论文在 (F17) 中从生产率、偏好和财政冲击定义复合需求扰动。论文用 AR(1) 展示生产率冲击：

- **(F27) 生产率过程**：

$$
\hat A_t=\rho_a\hat A_{t-1}+\varepsilon^a_t,\qquad 0<\rho_a<1.
$$

政策练习中的财政份额被校准为持久冲击：

- **(F28) 财政份额过程**：

$$
\hat\gamma_t=\rho_\gamma\hat\gamma_{t-1}+\varepsilon^\gamma_t.
$$

对 `NK_RW06AL`，实现保留一个结构性需求冲击和一个 modelbase 货币政策冲击：

- **(F29) MMB 需求冲击**（`implementation_cross_check`）：

$$
u_t=\varepsilon^u_t.
$$

- **(F30) MMB 政策规则冲击**（`implementation_cross_check`）：

$$
\text{interest}_t=\text{policy rule terms}+\text{std\_r\_}\,\varepsilon^{R}_t.
$$

## 6. Steady-State Solution

该归档条目对应线性化模型。紧凑政策模型中的所有变量都是围绕确定性稳态的对数偏离或百分点偏离：

$$
\bar x=\bar\pi=\bar R=\bar u=0.
$$

非线性原始条件给出如下归一化：

$$
\bar A=1,\qquad \bar\xi=1,\qquad \bar\gamma\in(0,1),\qquad
\bar R=\frac{1}{\beta}\quad\text{in gross nominal steady-state terms}.
$$

弹性价格经济中的稳态产出为：

$$
\bar Y=\left[
\frac{\bar\gamma^{-\sigma}}{\chi\Phi\bar R}
\right]^{1/(\sigma+\eta)}.
$$

由于政府支出与产出成比例，有效产出水平不同：

$$
\bar Y^e=\left[
\frac{\bar\gamma^{1-\sigma}}{\chi}
\right]^{1/(\sigma+\eta)}.
$$

对 MMB 自适应学习实现，`.mod` 报告的校准参数为：

$$
\sigma=1.5,\qquad \eta=1,\qquad \beta=0.99,\qquad \omega=0.75,
\qquad \kappa=\frac{(1-\omega)(1-\omega\beta)}{\omega}.
$$

运行验证、Blanchard-Kahn 检查和自适应学习求解检查均推迟处理。

## 7. Timing & Form Conventions

- **时序**：紧凑 MMB 模型是前瞻线性模型。IS 曲线使用 $x_{t+1}$ 和 $\pi_{t+1}$ 的期望；Phillips 曲线使用预期通胀。
- **存量**：此处使用的论文模型没有资本，因此不存在资本进入生产的时序约定需要解决。
- **利率记号**：论文中的 $R_t$ 是名义总利率；在线性化方程中 $\hat R_t$ 是名义利率偏离。MMB `.mod` 变量 `R` 是紧凑方程中的线性偏离。
- **产出缺口**：$x_t=\hat Y_t-\hat Y_t^*$ 是相对于固定利率政策下弹性价格产出的缺口，不一定是相对于有效产出的缺口。
- **自适应学习**：`NK_RW06AL` 增加了自适应学习元数据（`AL_Info`）并限制政策规则的超前/滞后结构。这是实现元数据，不是独立的论文侧最优化问题。
- **形式**：`model(linear)`；`.mod` 模型块中的所有稳态偏离均为零。

## 8. Variable & Parameter Reference Table

| 类别 | 符号 / ASCII 名 | 含义 | 由哪条方程决定 |
|---|---|---|---|
| 内生 | $x_t$ / `x` | 相对于 $\hat Y_t^*$ 的产出缺口 | (F15), policy rule |
| 内生 | $\pi_t$ / `pi` | 通胀偏离 | (F16) |
| 内生 | $\hat R_t$ / `R` | 名义利率偏离 | policy rule / (F30) |
| 报告内生 | `interest` | 年化利率 | (F23), policy rule |
| 报告内生 | `inflationq` | 年化季度通胀 | (F24) |
| 报告内生 | `inflation`, `pinf4` | 四季度通胀指标 | (F25) |
| 报告内生 | `outputgap`, `output` | MMB 产出/产出缺口报告变量 | (F26) |
| 外生 | $u_t$ / `u` | 复合需求扰动 | (F17), (F29) |
| 外生 | $\varepsilon^R_t$ / `interest_` | modelbase 货币政策冲击 | (F30) |
| 原始外生 | $\hat A_t$ | 生产率冲击 | (F27) |
| 原始外生 | $\hat\gamma_t$ | 财政份额冲击 | (F28) |
| 原始外生 | $\hat\xi_t$ | 偏好/味觉冲击 | (F17) |
| 参数 | $\sigma$ / `sigma` | 跨期替代弹性倒数 / CRRA 系数 | - |
| 参数 | $\eta$ / `eta` | Frisch 劳动供给弹性倒数 | - |
| 参数 | $\beta$ / `beta` | 折现因子 | - |
| 参数 | $\omega$ / `omega` | Calvo 不调价概率 | - |
| 参数 | $\kappa$ / `kappa` | Phillips 曲线斜率 | (F8) |
| 参数 | $\theta$ | 商品间替代弹性 | - |
| 参数 | $\Phi$ | 总加成 $\theta/(\theta-1)$ | - |
| 参数 | $\chi$ | 论文原始条件中的劳动负效用尺度 | - |
| 参数 | $\lambda$ | 损失函数中的福利缺口权重 | (F12) |
| 参数 | `cofint*`, `std_r_` | modelbase 政策规则系数 | (F30) |

方程覆盖说明：论文侧紧凑政策模型由 (F15)-(F16) 加上类似 (F18) 的最优政策条件或类似 (F30) 的实现政策规则表示。额外恒等式记录了源文献原始条件和 MMB 报告变量，便于审计。
