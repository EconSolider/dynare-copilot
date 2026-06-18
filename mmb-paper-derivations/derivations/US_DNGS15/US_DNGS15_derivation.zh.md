# US_DNGS15 -- 推导（对数线性均衡条件）

> Del Negro、Giannoni 和 Schorfheide (2015)《Inflation in the Great Recession and New Keynesian Models》的来源支撑型一稿归档条目。本轮未执行运行时验证。

## 1. Model Overview

- **模型 ID**：`US_DNGS15`。
- **论文**：Marco Del Negro, Marc P. Giannoni, and Frank Schorfheide (2015), "Inflation in the Great Recession and New Keynesian Models," *American Economic Journal: Macroeconomics*, 7(1), 168-196。DOI：`10.1257/mac.20140097`。
- **来源文件**：`raw/mmb_mineru/runs/us_dngs15_us_dngs15_sw_us_dngs15_swsp_us_dngs15__infation_in_the_great_recession_and_new_keynesian_models__c8e184ab/full.md`；原始 PDF：`raw/mmb_papers/Infation in the Great recession and New Keynesian models.pdf`。
- **MinerU run id**：`c8e184ab-3624-4257-9ea5-7ec1cf904fbb`。
- **模型族**：中等规模美国 New Keynesian DSGE 模型。论文以 Smets and Wouters (2007) 为基础，该模型又基于 Christiano, Eichenbaum, and Evans (2005)，并加入时变通胀目标以及 Bernanke, Gertler, and Gilchrist (1999)、Christiano, Motto, and Rostagno (2003, 2014) 和 De Graeve (2008) 风格的金融摩擦。
- **主体与模块**：带外部习惯的家庭、带调整成本和可变利用率的投资/资本积累、带名义刚性和指数化的垄断竞争商品与劳动供给者、产生外部融资利差的企业家和银行、政府支出以及货币当局。
- **形式**：对数线性均衡条件；MMB 交叉检查文件中使用 `model(linear)`。除非另有说明，所提取均衡模块中的变量都是相对非随机稳态的对数偏离。稳态值用星号下标表示。
- **范围说明**：论文明确给出的是对数线性均衡条件摘要，而不是每个原始最优化问题的完整推导。因此，原始家庭、厂商和金融合约推导标记为 `needs_review`，推广前应与所引用的 CEE/SW/CMR 技术来源核对。

## 2. Optimization Problems

论文说明 SW 模型推导详见 Christiano, Eichenbaum, and Evans (2005)，正文直接给出对数线性均衡条件。以下最优化模块仅用于说明所列均衡条件的经济来源；它们不是完整的来源级原始推导。

### 2.1 家庭

代表性家庭在预算约束下选择消费、劳动和名义债券。偏好包含消费外部习惯和劳动负效用。论文方程支持如下对象：

- 带习惯和跨期楔子 `b_t` 的消费 Euler 条件；
- 带家庭边际替代率 `w_t^h` 的工资设定模块；
- 由 `nu_l` 控制的劳动供给曲率。

原始效用函数和预算方程未在论文正文打印，保留为 `needs_review`。

### 2.2 资本与商品生产厂商

生产侧包含已安装资本、可变利用率、投资调整成本、边际投资效率冲击、边际成本以及 Kimball/Calvo 定价模块。论文报告了 Tobin's Q、资本积累、利用率、边际成本、要素比例、生产、资源使用和价格 Phillips 曲线的线性结果。

### 2.3 工资设定者

名义工资刚性通过工资 Phillips 曲线表示，其中包括 Calvo 参数 `zeta_w`、指数化参数 `iota_w`、Kimball 曲率 `epsilon_w` 和工资加成冲击 `lambda_w,t`。

### 2.4 企业家与银行

银行从家庭吸收存款并向企业家贷款。企业家使用净值和借款购买实物资本。个体风险和监测/违约机制产生外部融资利差，该利差取决于杠杆率和离散度冲击 `tilde sigma_omega,t`。论文报告的是对数线性的利差、资本回报和净值方程，而不是完整合约问题。

### 2.5 货币当局

货币当局遵循广义反馈规则，包含利率平滑、通胀反应、产出缺口反应、产出缺口增速反应和政策冲击。在扩展模型中，该规则对相对于时变通胀目标的通胀作出反应。

## 3. First-Order Conditions

令 `bar beta = beta exp((1-sigma_c) gamma)`。下列归档方程保留论文的对数线性结构，并使用连续归档编号。

- **(F1) 消费 Euler 方程**：
$$
c_t =
-\frac{1-h e^{-\gamma}}{\sigma_c(1+h e^{-\gamma})}
\big(R_t - E_t[\pi_{t+1}] + b_t\big)
+ \frac{h e^{-\gamma}}{1+h e^{-\gamma}}(c_{t-1}-z_t)
+ \frac{1}{1+h e^{-\gamma}}E_t[c_{t+1}+z_{t+1}]
+ \frac{\sigma_c-1}{\sigma_c(1+h e^{-\gamma})}
\frac{w_\ast l_\ast}{c_\ast}(l_t-E_t[l_{t+1}]).
$$

- **(F2) 投资/Tobin's Q 条件**：
$$
q_t^k = S'' e^{2\gamma}(1+\bar\beta)
\left(i_t-\frac{1}{1+\bar\beta}(i_{t-1}-z_t)
-\frac{\bar\beta}{1+\bar\beta}E_t[i_{t+1}+z_{t+1}]
-\mu_t\right).
$$

- **(F3) 资本积累**：
$$
\bar{k}_t =
\left(1-\frac{i_\ast}{\bar{k}_\ast}\right)(\bar{k}_{t-1}-z_t)
+\frac{i_\ast}{\bar{k}_\ast}i_t
+\frac{i_\ast}{\bar{k}_\ast}S''e^{2\gamma}(1+\bar\beta)\mu_t.
$$

- **(F4) 租给厂商的有效资本**：
$$
k_t = u_t - z_t + \bar{k}_{t-1}.
$$

- **(F5) 利用率条件**：
$$
u_t = \frac{1-\psi}{\psi}r_t^k.
$$

- **(F6) 实际边际成本**：
$$
mc_t = w_t+\alpha l_t-\alpha k_t.
$$

- **(F7) 共同资本劳动比**：
$$
k_t = w_t-r_t^k+l_t.
$$

- **(F8) 生产函数**：
$$
y_t = \Phi_p\big(\alpha k_t+(1-\alpha)l_t\big)
+\mathcal{I}\{\rho_z<1\}\frac{\Phi_p-1}{1-\alpha}\tilde{z}_t.
$$

- **(F9) 资源约束**：
$$
y_t = g_t+\frac{c_\ast}{y_\ast}c_t+\frac{i_\ast}{y_\ast}i_t
+\frac{r_\ast^k k_\ast}{y_\ast}u_t
-\mathcal{I}\{\rho_z<1\}\frac{1}{1-\alpha}\tilde{z}_t.
$$

- **(F10) 价格 Phillips 曲线**：
$$
\pi_t = \kappa mc_t
+\frac{\iota_p}{1+\iota_p\bar\beta}\pi_{t-1}
+\frac{\bar\beta}{1+\iota_p\bar\beta}E_t[\pi_{t+1}]
+\lambda_{f,t},
$$
其中
$$
\kappa =
\frac{(1-\zeta_p\bar\beta)(1-\zeta_p)}
{(1+\iota_p\bar\beta)\zeta_p((\Phi_p-1)\epsilon_p+1)}.
$$

- **(F11) 工资 Phillips 曲线**：
$$
\begin{aligned}
w_t={}&
\frac{(1-\zeta_w\bar\beta)(1-\zeta_w)}
{(1+\bar\beta)\zeta_w((\lambda_w-1)\epsilon_w+1)}
(w_t^h-w_t)
-\frac{1+\iota_w\bar\beta}{1+\bar\beta}\pi_t \\
&+\frac{1}{1+\bar\beta}(w_{t-1}-z_t+\iota_w\pi_{t-1})
+\frac{\bar\beta}{1+\bar\beta}E_t[w_{t+1}+z_{t+1}+\pi_{t+1}]
+\lambda_{w,t}.
\end{aligned}
$$

- **(F12) 家庭边际替代率**：
$$
w_t^h =
\frac{1}{1-h e^{-\gamma}}(c_t-h e^{-\gamma}c_{t-1}+h e^{-\gamma}z_t)
+\nu_l l_t.
$$

- **(F13) 基准货币政策规则**：
$$
R_t = \rho_R R_{t-1}
+(1-\rho_R)\big(\psi_1\pi_t+\psi_2(y_t-y_t^f)\big)
+\psi_3\big((y_t-y_t^f)-(y_{t-1}-y_{t-1}^f)\big)
+r_t^m.
$$

- **(F14) 带时变目标的货币政策规则**：
$$
R_t = \rho_R R_{t-1}
+(1-\rho_R)\big(\psi_1(\pi_t-\pi_t^{\ast})+\psi_2(y_t-y_t^f)\big)
+\psi_3\big((y_t-y_t^f)-(y_{t-1}-y_{t-1}^f)\big)
+r_t^m.
$$
扩展模型用 (F14) 取代 (F13)。

- **(F15) 外部融资利差**：
$$
E_t[\tilde{R}_{t+1}^k-R_t] =
b_t+\zeta_{sp,b}(q_t^k+\bar{k}_t-n_t)+\tilde{\sigma}_{\omega,t}.
$$

- **(F16) 企业家资本回报**：
$$
\tilde{R}_t^k-\pi_t =
\frac{r_\ast^k}{r_\ast^k+(1-\delta)}r_t^k
+\frac{1-\delta}{r_\ast^k+(1-\delta)}q_t^k
-q_{t-1}^k.
$$

- **(F17) 企业家净值**：
$$
\begin{aligned}
n_t={}&
\zeta_{n,\tilde{R}^k}(\tilde{R}_t^k-\pi_t)
-\zeta_{n,R}(R_{t-1}-\pi_t)
+\zeta_{n,qK}(q_{t-1}^k+\bar{k}_{t-1})
+\zeta_{n,n}n_{t-1} \\
&-\frac{\zeta_{n,\sigma_\omega}}{\zeta_{sp,\sigma_\omega}}
\tilde{\sigma}_{\omega,t-1}
-\gamma_\ast\frac{v_\ast}{n_\ast}\hat{z}_t.
\end{aligned}
$$

## 4. Market Clearing & Identities

- **(F18) 产出缺口定义**：
$$
og_t = y_t-y_t^f.
$$

- **(F19) 灵活价格消费 Euler 方程**：
$$
c_t^f =
-\frac{1-h e^{-\gamma}}{\sigma_c(1+h e^{-\gamma})}r_t^f
+b_t+\frac{h e^{-\gamma}}{1+h e^{-\gamma}}(c_{t-1}^f-z_t)
+\frac{1}{1+h e^{-\gamma}}E_t[c_{t+1}^f+z_{t+1}]
+\frac{\sigma_c-1}{\sigma_c(1+h e^{-\gamma})}
\frac{w_\ast l_\ast}{c_\ast}(l_t^f-E_t[l_{t+1}^f]).
$$

- **(F20) 灵活价格投资/Tobin's Q 条件**：
$$
q_t^{k,f} = S'' e^{2\gamma}(1+\bar\beta)
\left(i_t^f-\frac{1}{1+\bar\beta}(i_{t-1}^f-z_t)
-\frac{\bar\beta}{1+\bar\beta}E_t[i_{t+1}^f+z_{t+1}]
-\mu_t\right).
$$

- **(F21) 灵活价格资本积累**：
$$
\bar{k}_t^f =
\left(1-\frac{i_\ast}{\bar{k}_\ast}\right)(\bar{k}_{t-1}^f-z_t)
+\frac{i_\ast}{\bar{k}_\ast}i_t^f
+\frac{i_\ast}{\bar{k}_\ast}S''e^{2\gamma}(1+\bar\beta)\mu_t.
$$

- **(F22) 灵活价格生产侧恒等式**：
$$
k_t^f=u_t^f-z_t+\bar{k}_{t-1}^f,\quad
u_t^f=\frac{1-\psi}{\psi}r_t^{k,f},\quad
w_t^f=-\alpha l_t^f+\alpha k_t^f,\quad
k_t^f=w_t^f-r_t^{k,f}+l_t^f.
$$

- **(F23) 灵活价格产出和资源约束**：
$$
y_t^f=\Phi_p\big(\alpha k_t^f+(1-\alpha)l_t^f\big)
+\frac{\Phi_p-1}{1-\alpha}\tilde{z}_t,
$$
$$
y_t^f=g_\ast\;g_t+\frac{c_\ast}{y_\ast}c_t^f+\frac{i_\ast}{y_\ast}i_t^f
+\frac{r_\ast^k k_\ast}{y_\ast}u_t^f
-g_\ast\frac{1}{1-\alpha}\tilde{z}_t.
$$

- **(F24) 灵活价格工资/MRS 条件**：
$$
w_t^f =
\frac{1}{1-h e^{-\gamma}}(c_t^f-h e^{-\gamma}c_{t-1}^f+h e^{-\gamma}z_t)
+\nu_l l_t^f.
$$

- **(F25) 无金融摩擦灵活价格套利条件**：
$$
q_t^{k,f} =
\frac{r_\ast^k}{r_\ast^k+1-\delta}E_t[r_{t+1}^{k,f}]
+\frac{1-\delta}{r_\ast^k+1-\delta}E_t[q_{t+1}^{k,f}]
-r_t^f
+\frac{\sigma_c(1+h e^{-\gamma})}{1-h e^{-\gamma}}b_t.
$$

## 5. Exogenous Processes

- **(F26) 去趋势生产率增长**：
$$
z_t=\frac{1}{1-\alpha}(\rho_z-1)\tilde{z}_{t-1}
+\frac{1}{1-\alpha}\sigma_z\varepsilon_{z,t}.
$$

- **(F27) 去趋势对数生产率**：
$$
\tilde{z}_t=\rho_z\tilde{z}_{t-1}+\sigma_z\varepsilon_{z,t}.
$$

- **(F28) 政府支出**：
$$
g_t=\rho_g g_{t-1}+\sigma_g\varepsilon_{g,t}
+\eta_{gz}\sigma_z\varepsilon_{z,t}.
$$

- **(F29) 跨期楔子**：
$$
b_t=\rho_b b_{t-1}+\sigma_b\varepsilon_{b,t}.
$$

- **(F30) 边际投资效率**：
$$
\mu_t=\rho_\mu\mu_{t-1}+\sigma_\mu\varepsilon_{\mu,t}.
$$

- **(F31) 价格加成冲击**：
$$
\lambda_{f,t}=\rho_{\lambda_f}\lambda_{f,t-1}
+\sigma_{\lambda_f}\varepsilon_{\lambda_f,t}
-\eta_{\lambda_f}\sigma_{\lambda_f}\varepsilon_{\lambda_f,t-1}.
$$

- **(F32) 工资加成冲击**：
$$
\lambda_{w,t}=\rho_{\lambda_w}\lambda_{w,t-1}
+\sigma_{\lambda_w}\varepsilon_{\lambda_w,t}
-\eta_{\lambda_w}\sigma_{\lambda_w}\varepsilon_{\lambda_w,t-1}.
$$

- **(F33) 货币政策残差**：
$$
r_t^m=\rho_{r^m}r_{t-1}^m+\sigma_{r^m}\varepsilon_{r^m,t}.
$$

- **(F34) 金融风险/利差冲击**：
$$
\tilde{\sigma}_{\omega,t}=
\rho_{\sigma_\omega}\tilde{\sigma}_{\omega,t-1}
+\sigma_{\sigma_\omega}\varepsilon_{\sigma_\omega,t}.
$$

- **(F35) 时变通胀目标**：
$$
\pi_t^{\ast}=\rho_{\pi^{\ast}}\pi_{t-1}^{\ast}
+\sigma_{\pi^{\ast}}\varepsilon_{\pi^{\ast},t}.
$$

## 6. Steady-State Solution

由于论文以相对非随机稳态的对数偏离形式展示模型，线性系统中所有内生和外生偏离变量的稳态均为零：

$$
c=i=l=R=\pi=q^k=r^k=\bar{k}=k=u=mc=w=w^h=y=n=\tilde{R}^k=z=\tilde z=\mu=\lambda_f=\lambda_w=r^m=g=b=\tilde\sigma_\omega=\pi^{\ast}=og=0.
$$

来源说明稳态公式见 Del Negro and Schorfheide (2013) 的技术附录，而非本文正文。用于实现交叉检查时，MMB `.mod` 文件使用 `zstar`、`rstar`、`rkstar`、`wstar`、`Lstar`、`kstar`、`kbarstar`、`istar`、`ystar` 和 `cstar` 等校准稳态水平；这些数值记录为实现证据，不作为论文端推导。

延后 `needs_review` 的稳态问题：

- 对照 Del Negro and Schorfheide (2013) 确认完整非线性稳态公式；
- 确认金融摩擦稳态系数如何由 `SP_*`、违约概率、企业家存活率和 `zeta_*` 参数映射到 (F15)-(F17)；
- 确认随机趋势情形下固定成本是否随趋势同比例变化。

## 7. Timing & Form Conventions

- **线性形式**：`model(linear)`；变量是相对非随机稳态的对数偏离。
- **趋势**：非平稳变量由 `Z_t` 去趋势；`z_t` 是 `Z_t` 的增长率偏离，`tilde z_t` 是线性去趋势的对数生产率。
- **预定资本**：生产使用有效资本 `k_t`，它取决于利用率和上一期选择的已安装资本 `bar{k}_{t-1}`。
- **资本回报时序**：企业家回报条件在已实现回报 (F16) 中使用 `q_{t-1}^k`，而利差条件以前瞻项 `E_t[tilde R_{t+1}^k-R_t]` 表示。
- **名义刚性**：价格和工资 Phillips 曲线同时包含滞后指数化和前瞻项。
- **政策规则**：扩展模型使用相对时变目标 `pi_t^*` 的通胀；MMB 实现同时包含粘性和灵活价格/工资产出，用于计算 `y_t-y_t^f`。
- **运行时验证**：未执行；本轮归档未运行 Dynare。

## 8. Variable & Parameter Reference Table

### 内生变量

| 符号 | ASCII / MMB 名称 | 含义 | 主要方程 |
|---|---|---|---|
| $c_t$ | `c` | 消费偏离 | (F1) |
| $R_t$ | `R` | 名义政策利率偏离 | (F14) |
| $\pi_t$ | `pi` | 通胀偏离 | (F10) |
| $l_t$ | `L` | 劳动偏离 | (F1), (F7), (F11), (F12) |
| $q_t^k$ | `qk` | 已安装资本价值 | (F2) |
| $i_t$ | `i` | 投资偏离 | (F2), (F3), (F9) |
| $\tilde{R}_t^k$ | `Rktil` | 企业家名义回报 | (F15), (F16), (F17) |
| $r_t^k$ | `rk` | 资本租赁率 | (F5), (F7), (F16) |
| $\bar{k}_t$ | `kbar` | 已安装资本存量 | (F3) |
| $n_t$ | `n` | 企业家净值 | (F17) |
| $y_t$ | `y` | 产出偏离 | (F8), (F9) |
| $k_t$ | `k` | 有效资本服务 | (F4), (F7) |
| $u_t$ | `u` | 利用率 | (F5) |
| $mc_t$ | `mc` | 实际边际成本 | (F6), (F10) |
| $w_t$ | `w` | 实际工资 | (F6), (F7), (F11) |
| $w_t^h$ | `wh` | 家庭 MRS 工资 | (F11), (F12) |
| $z_t$ | `z` | 趋势增长偏离 | (F26) |
| $\tilde z_t$ | `ztil` | 去趋势对数生产率 | (F27) |
| $\mu_t$ | `mu` | MEI 冲击状态 | (F30) |
| $\tilde{\sigma}_{\omega,t}$ | `sigw` | 金融风险离散度冲击状态 | (F34) |
| $\lambda_{f,t}$ | `laf` | 价格加成冲击状态 | (F31) |
| $\lambda_{w,t}$ | `law` | 工资加成冲击状态 | (F32) |
| $r_t^m$ | `rm` | 货币政策残差 | (F33) |
| $g_t$ | `g` | 政府支出偏离 | (F28) |
| $b_t$ | `b` | 跨期楔子状态 | (F29) |
| $\pi_t^{\ast}$ | `pist` | 时变通胀目标 | (F35) |
| $og_t$ | `og` | 产出缺口 | (F18) |
| 灵活模块 | `c_f`, `r_f`, `L_f`, `qk_f`, `i_f`, `rk_f`, `y_f`, `k_f`, `u_f`, `kbar_f`, `w_f` | 灵活价格/工资辅助经济 | (F19)-(F25) |

### 外生创新

| ASCII / MMB 名称 | 含义 |
|---|---|
| `psi_g` | 政府支出创新 |
| `psi_b` | 跨期楔子创新 |
| `psi_mu` | 边际投资效率创新 |
| `psi_z` | 生产率创新 |
| `psi_laf` | 价格加成创新 |
| `psi_law` | 工资加成创新 |
| `psi_rm` | 政策残差创新 |
| `psi_sigw` | 金融风险/利差创新 |
| `psi_pist` | 通胀目标创新 |

### 参数

| ASCII / MMB 名称 | 含义 |
|---|---|
| `alp` | 资本份额参数 $\alpha$ |
| `zeta_p`, `iota_p`, `epsp` | 价格 Calvo、价格指数化、Kimball 价格曲率 |
| `zeta_w`, `iota_w`, `epsw` | 工资 Calvo、工资指数化、Kimball 工资曲率 |
| `del` | 折旧率 |
| `Bigphi` | 固定成本/生产缩放参数 $\Phi_p$ |
| `s2` | 投资调整成本曲率 $S''$ |
| `h` | 习惯持续性 |
| `ppsi` | 利用率成本参数 $\psi$ |
| `nu_l` | 劳动负效用曲率 |
| `bet`, `sigmac`, `zstar` | 贴现因子、风险厌恶、稳态增长 |
| `psi1`, `psi2`, `psi3`, `rho` | 货币政策系数和平滑 |
| `gstar`, `rho_g`, `eta_gz` | 政府支出过程参数 |
| `rho_b`, `rho_mu`, `rho_z`, `rho_laf`, `rho_law`, `rho_rm`, `rho_sigw`, `rho_pist` | 外生持续性参数 |
| `eta_laf`, `eta_law` | ARMA 加成冲击移动平均参数 |
| `rkstar`, `wl_c`, `cstar`, `wstar`, `Lstar`, `kstar`, `kbarstar`, `istar`, `rstar`, `ystar` | 线性系统使用的稳态水平/比率 |
| `zeta_spb`, `gammstar`, `vstar`, `nstar`, `zeta_nRk`, `zeta_nR`, `zeta_nsigw`, `zeta_spsigw`, `zeta_nqk`, `zeta_nn` | 金融摩擦利差和净值系数 |
