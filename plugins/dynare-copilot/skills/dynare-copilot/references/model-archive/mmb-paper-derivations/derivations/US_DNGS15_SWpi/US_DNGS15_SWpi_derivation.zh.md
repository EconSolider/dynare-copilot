# US_DNGS15_SWpi -- 推导（最优化问题 + 一阶条件）

> 私有模型档案的一轮草稿，供复核使用。公式状态：`needs_review`；方程从 MinerU Markdown 抽取，并仅用 Rep-MMB 实现文件核对覆盖范围和命名，不把实现文件当作论文侧数学来源。

## 1. Model Overview

- **模型 ID**：`US_DNGS15_SWpi`。
- **来源论文**：Del Negro, Marco; Giannoni, Marc P.; Schorfheide, Frank (2015), "Inflation in the Great Recession and New Keynesian Models," *American Economic Journal: Macroeconomics* 7(1), 168-196。DOI：`10.1257/mac.20140097`。
- **主要来源**：`raw/mmb_mineru/runs/us_dngs15_us_dngs15_sw_us_dngs15_swsp_us_dngs15__infation_in_the_great_recession_and_new_keynesian_models__c8e184ab/full.md`；原始 PDF 路径存在于 `raw/mmb_papers/Infation in the Great recession and New Keynesian models.pdf`。
- **变体**：SWpi 变体。实现交叉核对文件将其描述为带时变通胀目标、但不含完整金融摩擦净值模块的 Del Negro-Giannoni-Schorfheide 模型。
- **主体与模块**：带习惯形成的代表性家庭、最终品/中间品生产者、带投资调整成本的资本积累、可变资本利用率、带指数化的 Calvo 价格和工资设定、财政支出、货币政策、漂移通胀目标，以及弹性价格/工资反事实变量。
- **实验**：用于大衰退通胀预测和基本面通胀分析的美国中等规模新凯恩斯 DSGE 估计模型。Rep-MMB 文件使用 `model(linear)` 和一阶模拟；本档案条目不运行 Dynare。
- **模型形式**：对数线性均衡系统。除非明确标为稳态常数，模型方程中的所有变量均为相对非随机稳态的对数偏离。
- **一轮状态**：`needs_review`。Markdown 中核心方程可读；来源说明稳态公式见技术附录，但本模型没有本地的单独规范化附录文件。

## 2. Optimization Problems

论文说明 SW 模型基于 Christiano, Eichenbaum, and Evans (2005)，并给出对数线性化均衡条件，而不是完整的非线性家庭、厂商和工资设定者拉格朗日问题。因此，下列最优化问题是与标准 SW 模块一致的结构性重构；档案中的精确方程取自第 3 节的论文侧对数线性条件。

### 2.1 家庭

代表性家庭选择消费、劳动和名义债券/存款头寸，并具有外部消费习惯。与所展示 Euler 方程和工资方程一致的通用非线性问题为：

$$
\max_{\{C_t,L_t,B_t\}} E_0 \sum_{t=0}^{\infty} \beta^t
\left[
\frac{(C_t-h C_{t-1})^{1-\sigma_c}}{1-\sigma_c}
- \chi_L \frac{L_t^{1+\nu_l}}{1+\nu_l}
\right]
$$

约束为包含名义总利率、工资收入、利润/转移以及影响 Euler 方程的偏好楔子 \(b_t\) 的跨期预算约束。

### 2.2 资本与投资

资本/投资模块在调整成本和投资特定效率冲击 \(\mu_t\) 下选择投资和安装资本。论文以对数线性形式给出投资 Euler 方程、资本积累方程和收益套利条件。安装资本 \(\bar{k}_t\) 是下一期生产的预定状态，实际资本服务 \(k_t\) 取决于利用率 \(u_t\)。

### 2.3 商品生产者

中间品生产者租用资本和劳动服务。成本最小化给出实际边际成本、资本劳动比均衡以及总生产函数。生产模块通过 \(\Phi_p\) 包含固定成本/加成缩放；当技术为趋势平稳时，还包含线性去趋势生产率项。

### 2.4 价格和工资设定者

零售价格设定者和工资设定者面临带指数化的 Calvo 调整摩擦。论文直接报告由此得到的价格 Phillips 曲线和工资 Phillips 曲线。家庭边际替代率 \(w_t^h\) 进入工资设定条件。

### 2.5 货币当局

基准规则对通胀和相对于弹性价格/工资反事实的产出缺口作出反应。SWpi 变体用漂移通胀目标 \(\pi_t^*\) 替代常数通胀目标；Rep-MMB 交叉核对文件将 `pist` 固定为参数并注释掉其冲击过程，因此这里保留时变目标定律作为论文侧结构，但标记为实现差异。

## 3. First-Order Conditions

- **(F1) 去趋势生产率水平**：

$$
\tilde{z}_t = \rho_z \tilde{z}_{t-1} + \sigma_z \varepsilon_{z,t}.
$$

- **(F2) 趋势增长率组成项**：

$$
z_t = \frac{1}{1-\alpha}(\rho_z-1)\tilde{z}_{t-1}
+ \frac{1}{1-\alpha}\sigma_z \varepsilon_{z,t}.
$$

- **(F3) 带习惯的消费 Euler 方程**：

$$
\begin{aligned}
c_t ={}& -\frac{1-h e^{-\gamma}}{\sigma_c(1+h e^{-\gamma})}
\big(R_t-E_t[\pi_{t+1}]+b_t\big)
+\frac{h e^{-\gamma}}{1+h e^{-\gamma}}(c_{t-1}-z_t) \\
&+\frac{1}{1+h e^{-\gamma}}E_t[c_{t+1}+z_{t+1}]
+\frac{\sigma_c-1}{\sigma_c(1+h e^{-\gamma})}
\frac{w_*l_*}{c_*}(l_t-E_t[l_{t+1}]).
\end{aligned}
$$

- **(F4) 投资 Euler 方程 / Tobin's \(q\)**：

$$
q_t^k = S''e^{2\gamma}(1+\bar{\beta})
\left[
i_t-\frac{1}{1+\bar{\beta}}(i_{t-1}-z_t)
-\frac{\bar{\beta}}{1+\bar{\beta}}E_t[i_{t+1}+z_{t+1}]
-\mu_t
\right].
$$

- **(F5) 安装资本积累**：

$$
\bar{k}_t =
\left(1-\frac{i_*}{\bar{k}_*}\right)(\bar{k}_{t-1}-z_t)
+\frac{i_*}{\bar{k}_*}i_t
+\frac{i_*}{\bar{k}_*}S''e^{2\gamma}(1+\bar{\beta})\mu_t.
$$

- **(F6) 不含完整金融摩擦模块的无风险收益套利条件**：

$$
\frac{r_*^k}{r_*^k+(1-\delta)}E_t[r_{t+1}^k]
+\frac{1-\delta}{r_*^k+(1-\delta)}E_t[q_{t+1}^k]
-q_t^k
= R_t+b_t-E_t[\pi_{t+1}].
$$

- **(F7) 实际资本服务**：

$$
k_t = u_t-z_t+\bar{k}_{t-1}.
$$

- **(F8) 利用率条件**：

$$
u_t = \frac{1-\psi}{\psi}r_t^k.
$$

- **(F9) 实际边际成本**：

$$
mc_t = w_t+\alpha l_t-\alpha k_t.
$$

- **(F10) 共同资本劳动比条件**：

$$
k_t = w_t-r_t^k+l_t.
$$

- **(F11) 总生产函数**：

$$
y_t =
\Phi_p\big(\alpha k_t+(1-\alpha)l_t\big)
+\mathcal{I}\{\rho_z<1\}(\Phi_p-1)\frac{1}{1-\alpha}\tilde{z}_t.
$$

- **(F12) 资源约束**：

$$
y_t =
g_t+\frac{c_*}{y_*}c_t+\frac{i_*}{y_*}i_t
+\frac{r_*^k k_*}{y_*}u_t
-\mathcal{I}\{\rho_z<1\}\frac{1}{1-\alpha}\tilde{z}_t.
$$

- **(F13) 价格 Phillips 曲线**：

$$
\pi_t =
\kappa mc_t
+\frac{\iota_p}{1+\iota_p\bar{\beta}}\pi_{t-1}
+\frac{\bar{\beta}}{1+\iota_p\bar{\beta}}E_t[\pi_{t+1}]
+\lambda_{f,t}.
$$

其中

$$
\kappa=
\frac{(1-\zeta_p\bar{\beta})(1-\zeta_p)}
{(1+\iota_p\bar{\beta})\zeta_p((\Phi_p-1)\epsilon_p+1)}.
$$

- **(F14) 工资 Phillips 曲线**：

$$
\begin{aligned}
w_t ={}&
\frac{(1-\zeta_w\bar{\beta})(1-\zeta_w)}
{(1+\bar{\beta})\zeta_w((\lambda_w-1)\epsilon_w+1)}
\big(w_t^h-w_t\big)
-\frac{1+\iota_w\bar{\beta}}{1+\bar{\beta}}\pi_t \\
&+\frac{1}{1+\bar{\beta}}(w_{t-1}-z_t+\iota_w\pi_{t-1})
+\frac{\bar{\beta}}{1+\bar{\beta}}E_t[w_{t+1}+z_{t+1}+\pi_{t+1}]
+\lambda_{w,t}.
\end{aligned}
$$

- **(F15) 工资设定中的家庭边际替代率**：

$$
w_t^h =
\frac{1}{1-h e^{-\gamma}}
\big(c_t-h e^{-\gamma}c_{t-1}+h e^{-\gamma}z_t\big)
+\nu_l l_t.
$$

- **(F16) 含产出缺口的货币政策规则**：

$$
R_t =
\rho_R R_{t-1}
+(1-\rho_R)\big(\psi_1\pi_t+\psi_2(y_t-y_t^f)\big)
+\psi_3\big((y_t-y_t^f)-(y_{t-1}-y_{t-1}^f)\big)
+r_t^m.
$$

- **(F17) 含漂移通胀目标的货币政策规则**：

$$
R_t =
\rho_R R_{t-1}
+(1-\rho_R)\big(\psi_1(\pi_t-\pi_t^*)+\psi_2(y_t-y_t^f)\big)
+\psi_3\big((y_t-y_t^f)-(y_{t-1}-y_{t-1}^f)\big)
+r_t^m.
$$

- **(F18) 时变通胀目标过程**：

$$
\pi_t^*=\rho_{\pi^*}\pi_{t-1}^*+\sigma_{\pi^*}\varepsilon_{\pi^*,t}.
$$

`needs_review`：Rep-MMB `US_DNGS15_SWpi_rep.mod` 使用 `pist` 作为固定参数并注释掉 \(\pi_t^*\) 冲击过程，而论文侧 SWpi 小节定义了 (F18) 中的过程。

- **(F19) 实现交叉核对中使用的资本名义总收益定义**：

$$
\tilde{R}_t^k-\pi_t =
\frac{r_*^k}{r_*^k+(1-\delta)}r_t^k
+\frac{1-\delta}{r_*^k+(1-\delta)}q_t^k
-q_{t-1}^k.
$$

- **(F20) 实现交叉核对中使用的利差/套利方程**：

$$
E_t[\tilde{R}_{t+1}^k]
= R_t-\frac{\sigma_c(1+h e^{-\gamma})}{1-h e^{-\gamma}}b_t+\sigma_{\omega,t}.
$$

`needs_review`：(F19)-(F20) 在 Rep-MMB SWpi 文件中位于 "Financial Frictions" 注释下，但该文件说明此变体没有金融摩擦。这里将其保留为实现交叉核对方程，而不是作为完整企业家净值模块处于激活状态的证据。

## 4. Market Clearing & Identities

- **(F21) 弹性价格/工资消费 Euler 方程**：

$$
\begin{aligned}
c_t^f ={}&
-\frac{1-h e^{-\gamma}}{\sigma_c(1+h e^{-\gamma})}r_t^f+b_t
+\frac{h e^{-\gamma}}{1+h e^{-\gamma}}(c_{t-1}^f-z_t) \\
&+\frac{1}{1+h e^{-\gamma}}E_t[c_{t+1}^f+z_{t+1}]
+\frac{\sigma_c-1}{\sigma_c(1+h e^{-\gamma})}
\frac{w_*l_*}{c_*}(l_t^f-E_t[l_{t+1}^f]).
\end{aligned}
$$

- **(F22) 弹性价格/工资投资方程**：

$$
q_t^{k,f}=S''e^{2\gamma}(1+\bar{\beta})
\left[
i_t^f-\frac{1}{1+\bar{\beta}}(i_{t-1}^f-z_t)
-\frac{\bar{\beta}}{1+\bar{\beta}}E_t[i_{t+1}^f+z_{t+1}]
-\mu_t
\right].
$$

- **(F23) 弹性价格/工资资本积累**：

$$
\bar{k}_t^f=
\left(1-\frac{i_*}{\bar{k}_*}\right)(\bar{k}_{t-1}^f-z_t)
+\frac{i_*}{\bar{k}_*}i_t^f
+\frac{i_*}{\bar{k}_*}S''e^{2\gamma}(1+\bar{\beta})\mu_t.
$$

- **(F24) 弹性价格/工资实际资本**：

$$
k_t^f=u_t^f-z_t+\bar{k}_{t-1}^f.
$$

- **(F25) 弹性价格/工资利用率**：

$$
u_t^f=\frac{1-\psi}{\psi}r_t^{k,f}.
$$

- **(F26) 弹性价格/工资边际成本规范化**：

$$
w_t^f=-\alpha l_t^f+\alpha k_t^f.
$$

- **(F27) 弹性价格/工资资本劳动比**：

$$
k_t^f=w_t^f-r_t^{k,f}+l_t^f.
$$

- **(F28) 弹性价格/工资生产函数**：

$$
y_t^f=\Phi_p\alpha k_t^f+\Phi_p(1-\alpha)l_t^f
+\frac{\Phi_p-1}{1-\alpha}\tilde{z}_t.
$$

- **(F29) 弹性价格/工资资源约束**：

$$
y_t^f=g_*g_t+\frac{c_*}{y_*}c_t^f+\frac{i_*}{y_*}i_t^f
+\frac{r_*^k k_*}{y_*}u_t^f
-g_*\frac{1}{1-\alpha}\tilde{z}_t.
$$

- **(F30) 弹性价格/工资劳动供给 / MRS**：

$$
w_t^f=
\frac{1}{1-h e^{-\gamma}}
\big(c_t^f-h e^{-\gamma}c_{t-1}^f+h e^{-\gamma}z_t\big)
+\nu_l l_t^f.
$$

- **(F31) 弹性价格/工资套利条件**：

$$
q_t^{k,f}=
\frac{r_*^k}{r_*^k+(1-\delta)}E_t[r_{t+1}^{k,f}]
+\frac{1-\delta}{r_*^k+(1-\delta)}E_t[q_{t+1}^{k,f}]
-r_t^f
+\frac{\sigma_c(1+h e^{-\gamma})}{1-h e^{-\gamma}}b_t.
$$

政策规则使用的产出缺口为 \(y_t-y_t^f\)。弹性价格/工资变量存在于 Rep-MMB 实现和论文对 \(y_t^f\) 的定义中；它们不是单独的福利模型。

## 5. Exogenous Processes

- **(F32) 政府支出**：

$$
g_t=\rho_g g_{t-1}+\sigma_g\varepsilon_{g,t}+\eta_{gz}\sigma_z\varepsilon_{z,t}.
$$

- **(F33) 偏好楔子 / 跨期楔子**：

$$
b_t=\rho_b b_{t-1}+\sigma_b\varepsilon_{b,t}.
$$

- **(F34) 投资边际效率**：

$$
\mu_t=\rho_\mu\mu_{t-1}+\sigma_\mu\varepsilon_{\mu,t}.
$$

- **(F35) 价格加成冲击**：

$$
\lambda_{f,t}=
\rho_{\lambda_f}\lambda_{f,t-1}
+\sigma_{\lambda_f}\varepsilon_{\lambda_f,t}
-\eta_{\lambda_f}\sigma_{\lambda_f}\varepsilon_{\lambda_f,t-1}.
$$

- **(F36) 工资加成冲击**：

$$
\lambda_{w,t}=
\rho_{\lambda_w}\lambda_{w,t-1}
+\sigma_{\lambda_w}\varepsilon_{\lambda_w,t}
-\eta_{\lambda_w}\sigma_{\lambda_w}\varepsilon_{\lambda_w,t-1}.
$$

- **(F37) 货币政策残差**：

$$
r_t^m=\rho_{r^m}r_{t-1}^m+\sigma_{r^m}\varepsilon_{r^m,t}.
$$

- **(F38) 实现交叉核对中保留的利差冲击**：

$$
\sigma_{\omega,t}=\rho_{\sigma_\omega}\sigma_{\omega,t-1}+\sigma_{\sigma_\omega}\varepsilon_{\sigma_\omega,t}.
$$

在 Rep-MMB SWpi 文件中，`rho_sigw = 0` 且 `psi_sigw` 的标准差为零，因此该冲击存在于变量列表中，但在记录的校准下不活跃。

## 6. Steady-State Solution

由于论文给出的是对数线性系统，第 3-5 节中的状态变量是相对非随机稳态的偏离。论文说明稳态公式见 Del Negro and Schorfheide (2013) 的技术附录，但没有本地 `docs/mmb_appendix_full_normalizations/US_DNGS15_SWpi.md` 文件。

- **对数偏离稳态**：

$$
c=i=l=q^k=\bar{k}=y=k=u=mc=w=w^h=z=\tilde{z}=\mu=\lambda_f=\lambda_w=g=b=r^m=0.
$$

- **通胀目标约定**：

$$
\pi=0,\qquad R=0,\qquad \pi^*=0
$$

当目标被表示为相对均值的偏离时，上式成立。Rep-MMB 文件则校准 `pist = 1.0069`，并在 `model(linear)` 中使用 `pi - pist`，这一点在升级前应复核。

- **来自实现交叉核对的稳态常数**：

Rep-MMB 校准记录了 `zstar`、`rstar`、`rkstar`、`wstar`、`Lstar`、`kstar`、`kbarstar`、`istar`、`ystar`、`cstar` 和 `gstar`。这些是用于缩放线性模型的实现常数，并非本条目重新推导得到。

- **延后稳态复核**：

`steady_state_quality = partial_from_paper_and_implementation_cross_check`。经过复核的档案条目应检查缺失的技术附录或其他有来源依据的规范化材料，然后才能把稳态模块标为完整。

未执行运行时验证。未运行 `resid`、`steady`、`check` 或 `stoch_simul`。

## 7. Timing & Form Conventions

- **形式**：`model(linear)` 对数偏离系统。
- **趋势处理**：非平稳变量由 \(Z_t\) 去趋势；\(z_t\) 是趋势增长率组成项，\(\tilde{z}_t\) 是线性去趋势的对数生产率水平。
- **资本时序**：\(\bar{k}_t\) 是 \(t\) 期末安装资本；\(t\) 期生产通过实际资本 \(k_t=u_t-z_t+\bar{k}_{t-1}\) 使用 \(\bar{k}_{t-1}\)。
- **前瞻控制**：消费、投资、通胀、工资和资产价格都包含预期未来项。
- **政策缺口**：Taylor 规则对 \(y_t-y_t^f\) 作出反应，其中 \(y_t^f\) 由弹性价格/工资比较模块生成。
- **变体说明**：论文侧 SWpi 扩展是漂移通胀目标。可用 Rep-MMB 文件还保留一个不活跃的利差冲击方程并固定 `pist`；这些内容被记录为实现交叉核对和 `needs_review` 项。

## 8. Variable & Parameter Reference Table

### 内生变量

| 符号 | 含义 | 主要方程 |
|---|---|---|
| `c` | 消费 \(c_t\) | (F3) |
| `R` | 名义利率偏离 \(R_t\) | (F17) |
| `pi` | 通胀 \(\pi_t\) | (F13) |
| `L` | 劳动 \(l_t\) | (F3), (F10), (F15) |
| `qk` | 安装资本价值 \(q_t^k\) | (F4) |
| `i` | 投资 \(i_t\) | (F4), (F5) |
| `Rktil` | 资本名义总收益 \(\tilde{R}_t^k\) | (F19), (F20) |
| `rk` | 资本租金率 \(r_t^k\) | (F8), (F10), (F19) |
| `kbar` | 安装资本 \(\bar{k}_t\) | (F5) |
| `y` | 产出 \(y_t\) | (F11), (F12) |
| `k` | 实际资本 \(k_t\) | (F7) |
| `u` | 利用率 \(u_t\) | (F8) |
| `mc` | 实际边际成本 \(mc_t\) | (F9), (F13) |
| `w` | 实际工资 \(w_t\) | (F9), (F14) |
| `wh` | 家庭 MRS 工资 \(w_t^h\) | (F15) |
| `z` | 趋势增长组成项 \(z_t\) | (F2) |
| `ztil` | 去趋势生产率 \(\tilde{z}_t\) | (F1) |
| `mu` | MEI 冲击状态 \(\mu_t\) | (F34) |
| `sigw` | 利差/离散度冲击状态 \(\sigma_{\omega,t}\) | (F38) |
| `laf` | 价格加成冲击 \(\lambda_{f,t}\) | (F35) |
| `law` | 工资加成冲击 \(\lambda_{w,t}\) | (F36) |
| `g` | 政府支出 \(g_t\) | (F32) |
| `b` | 偏好/跨期楔子 \(b_t\) | (F33) |
| `c_f` | 弹性价格/工资消费 | (F21) |
| `r_f` | 弹性价格/工资实际收益 | (F31) |
| `L_f` | 弹性价格/工资劳动 | (F21), (F27), (F30) |
| `qk_f` | 弹性价格/工资资本价值 | (F22), (F31) |
| `i_f` | 弹性价格/工资投资 | (F22), (F23) |
| `rk_f` | 弹性价格/工资租金率 | (F25), (F27), (F31) |
| `y_f` | 弹性价格/工资产出 | (F28), (F29) |
| `k_f` | 弹性价格/工资实际资本 | (F24) |
| `u_f` | 弹性价格/工资利用率 | (F25) |
| `kbar_f` | 弹性价格/工资安装资本 | (F23) |
| `w_f` | 弹性价格/工资工资/MRS | (F26), (F30) |

### 外生冲击

| 符号 | 含义 |
|---|---|
| `psi_b` | \(b_t\) 的创新 |
| `psi_mu` | \(\mu_t\) 的创新 |
| `psi_z` | \(\tilde{z}_t\) 和 \(z_t\) 的创新 |
| `psi_laf` | \(\lambda_{f,t}\) 的创新 |
| `psi_law` | \(\lambda_{w,t}\) 的创新 |
| `psi_sigw` | \(\sigma_{\omega,t}\) 的创新，在交叉核对校准中不活跃 |
| `psi_g` | \(g_t\) 的创新 |
| `psi_pist` | 论文侧 \(\pi_t^*\) 创新；在 Rep-MMB 交叉核对文件中被注释 |
| `psi_rm` | 论文侧货币政策残差创新；在 Rep-MMB 交叉核对文件中被注释 |

### 参数

| 符号 | 含义 |
|---|---|
| `alp` | 资本份额 \(\alpha\) |
| `zeta_p`, `iota_p`, `epsp` | 价格 Calvo 粘性、价格指数化、价格聚合器曲率 |
| `zeta_w`, `iota_w`, `epsw` | 工资 Calvo 粘性、工资指数化、工资聚合器曲率 |
| `del` | 折旧率 \(\delta\) |
| `Bigphi` | 固定成本/加成生产缩放 \(\Phi_p\) |
| `s2` | 投资调整成本曲率 \(S''\) |
| `h` | 习惯参数 |
| `ppsi` | 利用成本参数 \(\psi\) |
| `nu_l` | 劳动负效用曲率 \(\nu_l\) |
| `bet` | 贴现因子 \(\beta\) |
| `psi1`, `psi2`, `psi3`, `rho` | 政策规则反应和利率平滑参数 |
| `sigmac` | 相对风险厌恶参数 \(\sigma_c\) |
| `rho_g`, `rho_b`, `rho_mu`, `rho_z`, `rho_laf`, `rho_law`, `rho_rm`, `rho_sigw`, `rho_pist` | 冲击持续性参数 |
| `eta_gz`, `eta_laf`, `eta_law` | 冲击溢出 / 移动平均系数 |
| `zstar`, `rkstar`, `rstar`, `wstar`, `Lstar`, `kstar`, `kbarstar`, `istar`, `ystar`, `cstar`, `gstar`, `wl_c`, `pist` | 用于缩放线性模型的稳态常数 |

方程数量说明：(F1)-(F38) 包含来源方程、弹性价格/工资比较方程以及实现交叉核对方程。论文将系统呈现为对数线性化均衡条件，而不是直接的非线性 FOC-变量数量核对。
