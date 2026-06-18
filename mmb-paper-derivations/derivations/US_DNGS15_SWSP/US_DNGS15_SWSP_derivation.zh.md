# US_DNGS15_SWSP -- 推导（最优化问题 + 均衡条件）

> 私有 MMB 档案草稿。未执行运行时验证。状态：`needs_review`。

来源记录：模型 `US_DNGS15_SWSP`，Del Negro、Giannoni 和 Schorfheide (2015)，"Inflation in the Great Recession and New Keynesian Models," *American Economic Journal: Macroeconomics* 7(1), 168-196，DOI `10.1257/mac.20140097`。主要 Markdown 来源：`raw/mmb_mineru/runs/us_dngs15_us_dngs15_sw_us_dngs15_swsp_us_dngs15__infation_in_the_great_recession_and_new_keynesian_models__c8e184ab/full.md`；原始 PDF：`raw/mmb_papers/Infation in the Great recession and New Keynesian models.pdf`；MinerU run id `c8e184ab-3624-4257-9ea5-7ec1cf904fbb`。文件 `.agents/skills/dynare-copilot/references/examples/US_DNGS15_SWSP_rep.mod` 仅作为 `implementation_cross_check` 使用。

## 1. Model Overview

- **模型**：SWFF，一个估计的美国 Smets-Wouters (2007) 中等规模新凯恩斯模型，并扩展了时变通胀目标和金融摩擦。
- **MMB 变体**：`US_DNGS15_SWSP`；实现交叉检查文件说明它是 DNGS15 的 SW 模型，使用与 Smets-Wouters 相同的可观测变量并加入信用利差数据估计。
- **主体和模块**：带外部习惯的家庭、含调整成本的投资/资本积累、具有名义刚性和指数化的价格与工资设定者、中间品企业、产生相对无风险利率利差的企业家/银行、货币当局和外生过程。
- **形式**：`model(linear)`。论文说明列出的方程均为相对非随机稳态的对数偏离；稳态常数作为参数进入。
- **来源提示**：论文本身概述的是对数线性均衡条件，并将稳态公式指向 Del Negro and Schorfheide (2013)。本条目记录论文侧方程，并将完整原始优化问题恢复标为 `needs_review`。

## 2. Optimization Problems

论文没有重新列出完整非线性优化问题；它概述对数线性均衡系统，并说明 SW 模型沿用 Christiano, Eichenbaum, and Evans (2005)。隐含的优化来源为：

- **家庭**：在外部习惯下选择消费、劳动和债券持有。对数线性欧拉方程与工资/MRS 条件隐含了习惯调整消费和劳动负效用偏好。
- **资本/投资模块**：在调整成本技术和投资边际效率冲击下选择投资。
- **价格和工资设定者**：在 Calvo 摩擦、指数化和 Kimball 型曲率项下选择重设价格和工资。
- **企业家和银行**：企业家使用净值和银行贷款购买资本；银行汇集异质违约风险，并根据杠杆和风险性收取利差。
- **中央银行**：遵循反馈规则，不作为优化主体。

`needs_review`：主要 Markdown 包含均衡条件，但不足以在不引入分配来源集之外 CEE/SW/BGG 推导的情况下重建每一个原始拉格朗日问题。

## 3. First-Order Conditions

除特别说明外，所有变量都是相对非随机稳态的对数偏离。令 \(\bar{\beta}=\beta e^{(1-\sigma_c)\gamma}\)。

- **(F1) 消费欧拉方程**：

\[
c_t =
-\frac{1-h e^{-\gamma}}{\sigma_c(1+h e^{-\gamma})}
\left(R_t-E_t[\pi_{t+1}]+b_t\right)
+\frac{h e^{-\gamma}}{1+h e^{-\gamma}}(c_{t-1}-z_t)
+\frac{1}{1+h e^{-\gamma}}E_t[c_{t+1}+z_{t+1}]
+\frac{\sigma_c-1}{\sigma_c(1+h e^{-\gamma})}\frac{w_\astl_\ast}{c_\ast}
\left(l_t-E_t[l_{t+1}]\right).
\]

- **(F2) 投资欧拉 / Tobin's Q 条件**：

\[
q_t^k=S'' e^{2\gamma}(1+\bar{\beta})
\left(i_t-\frac{1}{1+\bar{\beta}}(i_{t-1}-z_t)
-\frac{\bar{\beta}}{1+\bar{\beta}}E_t[i_{t+1}+z_{t+1}]
-\mu_t\right).
\]

- **(F3) 资本积累**：

\[
\bar{k}_t=
\left(1-\frac{i_\ast}{\bar{k}_\ast}\right)(\bar{k}_{t-1}-z_t)
+\frac{i_\ast}{\bar{k}_\ast}i_t
+\frac{i_\ast}{\bar{k}_\ast}S''e^{2\gamma}(1+\bar{\beta})\mu_t.
\]

- **(F4) 有效资本服务**：

\[
k_t=u_t-z_t+\bar{k}_{t-1}.
\]

- **(F5) 资本利用率条件**：

\[
u_t=\frac{1-\psi}{\psi}r_t^k.
\]

- **(F6) 实际边际成本**：

\[
mc_t=w_t+\alpha l_t-\alpha k_t.
\]

- **(F7) 共同资本劳动比**：

\[
k_t=w_t-r_t^k+l_t.
\]

- **(F8) 价格 Phillips 曲线**：

\[
\pi_t=\kappa mc_t+
\frac{\iota_p}{1+\iota_p\bar{\beta}}\pi_{t-1}
+\frac{\bar{\beta}}{1+\iota_p\bar{\beta}}E_t[\pi_{t+1}]
+\lambda_{f,t}.
\]

- **(F9) 价格 Phillips 曲线斜率**：

\[
\kappa=
\frac{(1-\zeta_p\bar{\beta})(1-\zeta_p)}
{(1+\iota_p\bar{\beta})\zeta_p((\Phi_p-1)\epsilon_p+1)}.
\]

- **(F10) 工资 Phillips 曲线**：

\[
\begin{aligned}
w_t={}&
\frac{(1-\zeta_w\bar{\beta})(1-\zeta_w)}
{(1+\bar{\beta})\zeta_w((\lambda_w-1)\epsilon_w+1)}
(w_t^h-w_t)
-\frac{1+\iota_w\bar{\beta}}{1+\bar{\beta}}\pi_t \\
&+\frac{1}{1+\bar{\beta}}(w_{t-1}-z_t+\iota_w\pi_{t-1})
+\frac{\bar{\beta}}{1+\bar{\beta}}E_t[w_{t+1}+z_{t+1}+\pi_{t+1}]
+\lambda_{w,t}.
\end{aligned}
\]

- **(F11) 家庭边际替代率工资**：

\[
w_t^h=\frac{1}{1-h e^{-\gamma}}
(c_t-h e^{-\gamma}c_{t-1}+h e^{-\gamma}z_t)+\nu_l l_t.
\]

- **(F12) 金融摩擦利差条件**：

\[
E_t[\tilde{R}_{t+1}^k-R_t]
=b_t+\zeta_{sp,b}(q_t^k+\bar{k}_t-n_t)+\tilde{\sigma}_{\omega,t}.
\]

- **(F13) 名义资本回报**：

\[
\tilde{R}_t^k-\pi_t=
\frac{r_\ast^k}{r_\ast^k+(1-\delta)}r_t^k
+\frac{1-\delta}{r_\ast^k+(1-\delta)}q_t^k
-q_{t-1}^k.
\]

- **(F14) 企业家净值**：

\[
\begin{aligned}
n_t={}&
\zeta_{n,\tilde{R}^k}(\tilde{R}_t^k-\pi_t)
-\zeta_{n,R}(R_{t-1}-\pi_t)
+\zeta_{n,qK}(q_{t-1}^k+\bar{k}_{t-1})
+\zeta_{n,n}n_{t-1} \\
&-\frac{\zeta_{n,\sigma_\omega}}{\zeta_{sp,\sigma_\omega}}
\tilde{\sigma}_{\omega,t-1}
-\gamma_\ast\frac{v_\ast}{n_\ast}z_t.
\end{aligned}
\]

## 4. Market Clearing & Identities

- **(F15) 总生产函数**：

\[
y_t=\Phi_p(\alpha k_t+(1-\alpha)l_t)
+\mathcal{I}\{\rho_z<1\}(\Phi_p-1)\frac{1}{1-\alpha}\tilde{z}_t.
\]

- **(F16) 资源约束**：

\[
y_t=g_t+\frac{c_\ast}{y_\ast}c_t+\frac{i_\ast}{y_\ast}i_t
+\frac{r_\ast^k k_\ast}{y_\ast}u_t
-\mathcal{I}\{\rho_z<1\}\frac{1}{1-\alpha}\tilde{z}_t.
\]

- **(F17) 时变目标 Taylor 规则**：

\[
\begin{aligned}
R_t={}&\rho_R R_{t-1}
+(1-\rho_R)\left(\psi_1(\pi_t-\pi_t^{\ast})+\psi_2(y_t-y_t^f)\right) \\
&+\psi_3\left((y_t-y_t^f)-(y_{t-1}-y_{t-1}^f)\right)+r_t^m.
\end{aligned}
\]

- **(F18) 弹性价格/工资对应模型**：

\[
y_t^f=\mathcal{F}^{flex}(c_t^f,i_t^f,l_t^f,k_t^f,u_t^f,\bar{k}_t^f,w_t^f,r_t^f,q_t^{k,f}; \Theta),
\]

其中 \(\mathcal{F}^{flex}\) 表示 (F1)-(F7)、(F11) 和 (F15)-(F16) 的弹性价格/工资版本。论文通过求解无名义刚性模型定义 \(y_t^f\)；实现交叉检查文件将其展开为一组平行方程。

## 5. Exogenous Processes

- **(F19) 去趋势生产率**：

\[
\tilde{z}_t=\rho_z\tilde{z}_{t-1}+\sigma_z\varepsilon_{z,t}.
\]

- **(F20) 生产率的增长率效应**：

\[
z_t=\frac{1}{1-\alpha}(\rho_z-1)\tilde{z}_{t-1}
+\frac{1}{1-\alpha}\sigma_z\varepsilon_{z,t}.
\]

- **(F21) 政府支出**：

\[
g_t=\rho_g g_{t-1}+\sigma_g\varepsilon_{g,t}
+\eta_{gz}\sigma_z\varepsilon_{z,t}.
\]

- **(F22) 价格加成过程**：

\[
\lambda_{f,t}=\rho_{\lambda_f}\lambda_{f,t-1}
+\sigma_{\lambda_f}\varepsilon_{\lambda_f,t}
-\eta_{\lambda_f}\sigma_{\lambda_f}\varepsilon_{\lambda_f,t-1}.
\]

- **(F23) 工资加成过程**：

\[
\lambda_{w,t}=\rho_{\lambda_w}\lambda_{w,t-1}
+\sigma_{\lambda_w}\varepsilon_{\lambda_w,t}
-\eta_{\lambda_w}\sigma_{\lambda_w}\varepsilon_{\lambda_w,t-1}.
\]

- **(F24) 时变通胀目标**：

\[
\pi_t^{\ast}=\rho_{\pi^{\ast}}\pi_{t-1}^{\ast}+\sigma_{\pi^{\ast}}\varepsilon_{\pi^{\ast},t}.
\]

- **(F25) 贴现率楔子**：

\[
b_t=\rho_b b_{t-1}+\sigma_b\varepsilon_{b,t}.
\]

- **(F26) 投资边际效率**：

\[
\mu_t=\rho_\mu\mu_{t-1}+\sigma_\mu\varepsilon_{\mu,t}.
\]

- **(F27) 货币政策残差**：

\[
r_t^m=\rho_{r^m}r_{t-1}^m+\sigma_{r^m}\varepsilon_{r^m,t}.
\]

- **(F28) 金融风险/利差冲击**：

\[
\tilde{\sigma}_{\omega,t}=\rho_{\sigma_\omega}\tilde{\sigma}_{\omega,t-1}
+\sigma_{\sigma_\omega}\varepsilon_{\sigma_\omega,t}.
\]

## 6. Steady-State Solution

由于档案来源是对数线性系统，(F1)-(F28) 中的模型变量都是相对非随机稳态的偏离。因此：

- 内生对数偏离稳态为零：\(c=l=R=\pi=q^k=i=r^k=\bar{k}=n=y=k=u=mc=w=w^h=z=\tilde{z}=\mu=\tilde{\sigma}_\omega=\lambda_f=\lambda_w=g=b=r^m=\pi^{\ast}=0\)；
- 弹性价格/工资对应变量的偏离稳态同样为零：\(c^f=l^f=q^{k,f}=i^f=r^{k,f}=y^f=k^f=u^f=\bar{k}^f=w^f=r^f=0\)；
- 非零稳态水平以参数形式进入，包括 \(\gamma\)、\(r_\ast\)、\(r_\ast^k\)、\(c_\ast\)、\(w_\ast\)、\(l_\ast\)、\(k_\ast\)、\(\bar{k}_\ast\)、\(i_\ast\)、\(y_\ast\)、\(g_\ast\)、\(v_\ast\) 和 \(n_\ast\)。

`needs_review`：论文将稳态公式指向 Del Negro and Schorfheide (2013) 的技术附录。本档案条目没有引入该外部附录，因此原始稳态推导留待后续处理。

## 7. Timing & Form Conventions

- **线性形式**：方程是相对非随机稳态的对数偏离；MMB 实现使用 `model(linear)`。
- **资本时序**：\(\bar{k}_t\) 是第 \(t\) 期期末安装资本存量；生产使用有效资本服务 \(k_t=u_t-z_t+\bar{k}_{t-1}\)。
- **预期**：含 \(E_t[\cdot]\) 的变量是一期领先理性预期；实现交叉检查文件用 Dynare lead 表示这些项。
- **金融模块**：\(\tilde{R}_{t+1}^k\) 以预期形式进入利差方程；净值 \(n_t\) 取决于已实现的当期资本回报和滞后净值。
- **政策变体**：论文中的 SWFF 时变目标规则使用 (F17)。MMB `US_DNGS15_SWSP` 实现将紧凑 Taylor 规则替换为 model-base 政策规则接口，并在估计变体中保留利差数据；这是实现层面的交叉检查证据。
- **运行时验证**：未执行；没有运行 Dynare。

## 8. Variable & Parameter Reference Table

| 类别 | 符号 / ASCII | 含义 | 主要方程 |
|---|---|---|---|
| 内生变量 | `c` | 消费 | (F1), (F16) |
| 内生变量 | `L` / \(l\) | 劳动供给 | (F1), (F7), (F10), (F15) |
| 内生变量 | `R` | 名义政策利率偏离 | (F1), (F17) |
| 内生变量 | `pi` | 通胀 | (F8), (F10), (F17) |
| 内生变量 | `qk` / \(q^k\) | 资本价值 | (F2), (F12), (F13) |
| 内生变量 | `i` | 投资 | (F2), (F3), (F16) |
| 内生变量 | `kbar` / \(\bar{k}\) | 安装资本 | (F3), (F4), (F12) |
| 内生变量 | `k` | 有效资本服务 | (F4), (F7), (F15) |
| 内生变量 | `u` | 资本利用率 | (F5), (F16) |
| 内生变量 | `rk` / \(r^k\) | 资本租金率 | (F5), (F7), (F13) |
| 内生变量 | `mc` | 实际边际成本 | (F6), (F8) |
| 内生变量 | `w` | 实际工资 | (F6), (F7), (F10) |
| 内生变量 | `wh` / \(w^h\) | 家庭 MRS 工资 | (F10), (F11) |
| 内生变量 | `y` | 产出 | (F15), (F16) |
| 内生变量 | `y_f` | 弹性价格/工资产出 | (F17), (F18) |
| 内生变量 | `Rktil` / \(\tilde{R}^k\) | 企业家的名义资本回报 | (F12), (F13), (F14) |
| 内生变量 | `n` | 企业家净值 | (F12), (F14) |
| 内生变量 | `z`, `ztil` | 生产率组成部分 | (F19), (F20) |
| 内生变量 | `g`, `b`, `mu`, `laf`, `law`, `rm`, `pist`, `sigw` | 在 Dynare 中作为内生 AR 状态表示的外生过程 | (F21)-(F28) |
| 内生变量 | `c_f`, `r_f`, `L_f`, `qk_f`, `i_f`, `rk_f`, `k_f`, `u_f`, `kbar_f`, `w_f` | 弹性价格/工资对应变量 | (F18) |
| 外生创新 | `psi_b` | 贴现率楔子创新 | (F25) |
| 外生创新 | `psi_mu` | 投资边际效率创新 | (F26) |
| 外生创新 | `psi_z` | 生产率创新 | (F19), (F20), (F21) |
| 外生创新 | `psi_laf` | 价格加成创新 | (F22) |
| 外生创新 | `psi_law` | 工资加成创新 | (F23) |
| 外生创新 | `psi_sigw` | 金融风险/利差创新 | (F28) |
| 外生创新 | `psi_pist` | 通胀目标创新 | (F24) |
| 外生创新 | `psi_rm` | 货币政策残差创新 | (F27) |
| 外生创新 | `interest_`, `fiscal_` | MMB 政策规则接口冲击 | implementation_cross_check |
| 参数 | `alp`, `zeta_p`, `iota_p`, `del`, `Bigphi`, `s2`, `h`, `ppsi`, `nu_l`, `zeta_w`, `iota_w`, `bet`, `psi1`, `psi2`, `psi3`, `sigmac`, `rho`, `epsp`, `epsw` | SW 偏好、名义刚性、生产、政策和调整成本参数 | (F1)-(F17) |
| 参数 | `rho_g`, `rho_b`, `rho_mu`, `rho_z`, `rho_laf`, `rho_law`, `rho_rm`, `rho_sigw`, `rho_pist`, `eta_gz`, `eta_laf`, `eta_law` | 外生过程持久性和 MA/相关参数 | (F19)-(F28) |
| 参数 | `zstar`, `rstar`, `rkstar`, `wl_c`, `cstar`, `wstar`, `Lstar`, `kstar`, `kbarstar`, `istar`, `ystar`, `gstar` | 稳态常数 | (F1)-(F16) |
| 参数 | `zeta_spb`, `gammstar`, `vstar`, `nstar`, `zeta_nRk`, `zeta_nR`, `zeta_nsigw`, `zeta_spsigw`, `zeta_nqk`, `zeta_nn` | 金融摩擦和净值系数 | (F12), (F14), (F28) |
