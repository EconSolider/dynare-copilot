# US_DNGS15_SW -- 推导（最优化问题 + 一阶条件）

> 本推导用于私有 MMB 模型档案。未执行运行时验证。主要论文来源：Del Negro, Giannoni, and Schorfheide (2015), "Inflation in the Great Recession and New Keynesian Models," DOI `10.1257/mac.20140097`。模型 ID：`US_DNGS15_SW`。

## 1. Model Overview

- **模型**：DNGS15 对 Smets-Wouters (2007) 中等规模新凯恩斯模型的实现，依据 Del Negro, Giannoni, and Schorfheide (2015) 第 I.A 节总结的 SW 方程块。
- **来源映射**：`raw/mmb_mineru/model_index.csv` 将 `US_DNGS15_SW` 映射到 `raw/mmb_mineru/runs/us_dngs15_us_dngs15_sw_us_dngs15_swsp_us_dngs15__infation_in_the_great_recession_and_new_keynesian_models__c8e184ab/full.md`；首页抽查与预期标题和作者匹配。
- **主体和方程块**：带消费习惯的家庭、带投资调整成本的资本/投资块、可变资本利用率、带指数化的价格和工资黏性、广义反馈货币政策规则、政府支出和外生结构冲击。
- **模型形式**：`model(linear)`。论文说明展示系统中的变量均为相对非随机稳态的对数偏离，稳态值用星号下标表示。Rep-MMB 文件 `.agents/skills/dynare-copilot/references/examples/US_DNGS15_SW_rep.mod` 也确认 `model(linear)`。
- **变体说明**：`US_DNGS15_SW` 的实现交叉检查包含带 `sigw` 的利差式方程，但不含企业家净值状态 `n`。因此，论文中更完整的金融摩擦块和净值方程被记录为相邻来源块，精确变体归属标记为 `needs_review`。

## 2. Optimization Problems

### 2.1 家庭

论文没有重新写出完整非线性家庭问题，而是说明该块继承自 Christiano, Eichenbaum, and Evans (2005) 与 Smets-Wouters (2007)。家庭具有外部消费习惯，选择消费、劳动和一期名义债券。与来源一致的简写为：

$$
\max_{\{C_t,L_t,B_t\}} E_0 \sum_{t=0}^{\infty} \beta^t
\left[
U(C_t-h C_{t-1}) - V(L_t)
\right]
$$

约束为包含工资收入、债券回报、转移和利润的名义预算约束。下文直接采用论文给出的对数线性欧拉方程和劳动楔子。

### 2.2 资本和投资块

家庭持有中间品企业使用的安装资本。投资在调整成本和投资边际效率扰动下把消费品转化为安装资本，从而给出第 3 节中的 Tobin's Q 条件和资本运动方程。

### 2.3 商品生产者和价格制定者

中间品企业租用有效资本和劳动，按含固定成本/加成参数 $\Phi_p$ 的技术生产，并面对带指数化的价格黏性。对数线性价格 Phillips 曲线概括其最优重定价条件。

### 2.4 劳动打包者和工资制定者

家庭提供差异化劳动服务。工资制定者面临带指数化的 Calvo 黏性，产生工资 Phillips 曲线。家庭消费-劳动边际替代率进入工资设定。

### 2.5 货币当局和外生过程

中央银行按通胀、灵活价格产出缺口、缺口变化和货币政策残差制定广义反馈规则。DNGS15 扩展把常数通胀目标替换为持久的时变通胀目标过程。

## 3. First-Order Conditions

以下变量均为对数偏离，除非另有说明。记号沿用论文：$c_t$ 为消费，$l_t$ 为劳动，$R_t$ 为名义利率，$\pi_t$ 为通胀，$q_t^k$ 为资本价值，$i_t$ 为投资，$\bar{k}_t$ 为安装资本，$k_t$ 为有效资本，$u_t$ 为利用率，$r_t^k$ 为资本租金率，$mc_t$ 为边际成本，$w_t$ 为实际工资，$w_t^h$ 为家庭 MRS 工资。

**(F1) 生产率趋势增长过程**：

$$
z_t = \frac{1}{1-\alpha}(\rho_z-1)\tilde z_{t-1}+\frac{1}{1-\alpha}\sigma_z\varepsilon_{z,t}
$$

**(F2) 带习惯和跨期楔子的消费欧拉方程**：

$$
c_t =
-\frac{1-h e^{-\gamma}}{\sigma_c(1+h e^{-\gamma})}
\left(R_t-E_t[\pi_{t+1}]+b_t\right)
+\frac{h e^{-\gamma}}{1+h e^{-\gamma}}(c_{t-1}-z_t)
+\frac{1}{1+h e^{-\gamma}}E_t[c_{t+1}+z_{t+1}]
+\frac{\sigma_c-1}{\sigma_c(1+h e^{-\gamma})}\frac{w_*l_*}{c_*}
\left(l_t-E_t[l_{t+1}]\right)
$$

**(F3) 投资/Tobin's-Q 条件**：

$$
q_t^k =
S'' e^{2\gamma}(1+\bar\beta)
\left(
i_t-\frac{1}{1+\bar\beta}(i_{t-1}-z_t)
-\frac{\bar\beta}{1+\bar\beta}E_t[i_{t+1}+z_{t+1}]
-\mu_t
\right)
$$

**(F4) 安装资本运动方程**：

$$
\bar{k}_t =
\left(1-\frac{i_*}{\bar{k}_*}\right)(\bar{k}_{t-1}-z_t)
+\frac{i_*}{\bar{k}_*}i_t
+\frac{i_*}{\bar{k}_*}S''e^{2\gamma}(1+\bar\beta)\mu_t
$$

**(F5) 基准 SW 无金融摩擦资本套利条件**：

$$
\frac{r_*^k}{r_*^k+(1-\delta)}E_t[r_{t+1}^k]
+\frac{1-\delta}{r_*^k+(1-\delta)}E_t[q_{t+1}^k]
-q_t^k
=R_t+b_t-E_t[\pi_{t+1}]
$$

**(F6) 由利用率和预定安装资本得到有效资本**：

$$
k_t=u_t-z_t+\bar{k}_{t-1}
$$

**(F7) 资本利用率最优条件**：

$$
\frac{1-\psi}{\psi}r_t^k=u_t
$$

**(F8) 实际边际成本**：

$$
mc_t=w_t+\alpha l_t-\alpha k_t
$$

**(F9) 共同资本劳动比条件**：

$$
k_t=w_t-r_t^k+l_t
$$

**(F10) 家庭边际替代率工资**：

$$
w_t^h=
\frac{1}{1-h e^{-\gamma}}
\left(c_t-h e^{-\gamma}c_{t-1}+h e^{-\gamma}z_t\right)
+\nu_l l_t
$$

**(F11) 价格 Phillips 曲线**：

$$
\pi_t =
\kappa mc_t
+\frac{\iota_p}{1+\iota_p\bar\beta}\pi_{t-1}
+\frac{\bar\beta}{1+\iota_p\bar\beta}E_t[\pi_{t+1}]
+\lambda_{f,t}
$$

with

$$
\kappa=
\frac{(1-\zeta_p\bar\beta)(1-\zeta_p)}
{(1+\iota_p\bar\beta)\zeta_p((\Phi_p-1)\epsilon_p+1)}
$$

**(F12) 工资 Phillips 曲线**：

$$
w_t =
\frac{(1-\zeta_w\bar\beta)(1-\zeta_w)}
{(1+\bar\beta)\zeta_w((\lambda_w-1)\epsilon_w+1)}
(w_t^h-w_t)
-\frac{1+\iota_w\bar\beta}{1+\bar\beta}\pi_t
+\frac{1}{1+\bar\beta}(w_{t-1}-z_t+\iota_w\pi_{t-1})
+\frac{\bar\beta}{1+\bar\beta}E_t[w_{t+1}+z_{t+1}+\pi_{t+1}]
+\lambda_{w,t}
$$

**(F13) `US_DNGS15_SW` 实现使用的金融利差回报条件，needs_review**：

$$
E_t[\tilde R_{t+1}^k-R_t]
=b_t+\tilde\sigma_{\omega,t}
$$

这是压低杠杆敏感项后的来源侧金融利差条件。Rep-MMB 交叉检查把该变体实现为 `Rktil(+1)` 的前瞻方程，含跨期楔子项和 `sigw`，但不含净值 `n`。

**(F14) 名义资本回报定义**：

$$
\tilde R_t^k-\pi_t
=
\frac{r_*^k}{r_*^k+(1-\delta)}r_t^k
+\frac{1-\delta}{r_*^k+(1-\delta)}q_t^k
-q_{t-1}^k
$$

## 4. Market Clearing & Identities

**(F15) 生产函数**：

$$
y_t=
\Phi_p\left(\alpha k_t+(1-\alpha)l_t\right)
+\mathcal I\{\rho_z<1\}(\Phi_p-1)\frac{1}{1-\alpha}\tilde z_t
$$

**(F16) 资源约束**：

$$
y_t=
g_t+\frac{c_*}{y_*}c_t+\frac{i_*}{y_*}i_t
+\frac{r_*^k k_*}{y_*}u_t
-\mathcal I\{\rho_z<1\}\frac{1}{1-\alpha}\tilde z_t
$$

**(F17) 灵活价格产出缺口定义**：

$$
x_t=y_t-y_t^f
$$

**(F18) 灵活价格比较系统**：

$$
y_t^f=\mathcal F(c_t^f,l_t^f,q_t^{k,f},i_t^f,k_t^f,u_t^f,w_t^f,r_t^{k,f},\tilde z_t,z_t,g_t,b_t,\mu_t)
$$

论文说明 $y_t^f$ 由无名义刚性的实际 SW 方程组求解。实现交叉检查把它展开为一套平行灵活价格方程；如果档案需要逐方程覆盖，上面的紧凑写法仍为 `needs_review`。

## 5. Exogenous Processes

**(F19) 去趋势对数生产率**：

$$
\tilde z_t=\rho_z\tilde z_{t-1}+\sigma_z\varepsilon_{z,t}
$$

**(F20) 政府支出**：

$$
g_t=\rho_g g_{t-1}+\sigma_g\varepsilon_{g,t}+\eta_{gz}\sigma_z\varepsilon_{z,t}
$$

**(F21) 跨期偏好楔子**：

$$
b_t=\rho_b b_{t-1}+\sigma_b\varepsilon_{b,t}
$$

**(F22) 投资边际效率**：

$$
\mu_t=\rho_\mu\mu_{t-1}+\sigma_\mu\varepsilon_{\mu,t}
$$

**(F23) 价格加成冲击，ARMA(1,1)**：

$$
\lambda_{f,t}=\rho_{\lambda_f}\lambda_{f,t-1}
+\sigma_{\lambda_f}\varepsilon_{\lambda_f,t}
-\eta_{\lambda_f}\sigma_{\lambda_f}\varepsilon_{\lambda_f,t-1}
$$

**(F24) 工资加成冲击，ARMA(1,1)**：

$$
\lambda_{w,t}=\rho_{\lambda_w}\lambda_{w,t-1}
+\sigma_{\lambda_w}\varepsilon_{\lambda_w,t}
-\eta_{\lambda_w}\sigma_{\lambda_w}\varepsilon_{\lambda_w,t-1}
$$

**(F25) 带时变通胀目标的货币政策规则**：

$$
R_t=\rho_R R_{t-1}
+(1-\rho_R)\left(\psi_1(\pi_t-\pi_t^*)+\psi_2(y_t-y_t^f)\right)
+\psi_3\left((y_t-y_t^f)-(y_{t-1}-y_{t-1}^f)\right)
+r_t^m
$$

**(F26) 货币政策残差**：

$$
r_t^m=\rho_{r^m}r_{t-1}^m+\sigma_{r^m}\varepsilon_{r^m,t}
$$

**(F27) 时变通胀目标**：

$$
\pi_t^*=\rho_{\pi^*}\pi_{t-1}^*+\sigma_{\pi^*}\varepsilon_{\pi^*,t}
$$

**(F28) 金融风险/利差冲击，本变体需复核**：

$$
\tilde\sigma_{\omega,t}=\rho_{\sigma_\omega}\tilde\sigma_{\omega,t-1}
+\sigma_{\sigma_\omega}\varepsilon_{\sigma_\omega,t}
$$

在 `US_DNGS15_SW_rep.mod` 中，对应的 `sigw` 创新标准差为零且没有净值状态；本档案保留该冲击是因为论文来源和实现都命名了它。

## 6. Steady-State Solution

由于模型围绕非随机稳态线性化，第 3-5 节动态变量的稳态对数偏离为零：

$$
c=i=y=l=k=\bar{k}=u=mc=w=w^h=\pi=q^k=r^k=R=b=\mu=g=\lambda_f=\lambda_w=r^m=\pi^*=\tilde\sigma_\omega=0
$$

本轮没有从 Markdown 正文求出稳态常数。论文说明稳态公式见 Del Negro and Schorfheide (2013) 技术附录，而本模型没有本地 appendix normalization 文件。实现交叉检查记录了若干校准/隐含稳态值：

$$
\gamma=0.0037,\quad R_*=1.0069,\quad r_*^k=0.0319,\quad
c_*=0.4796,\quad y_*=0.7102,\quad i_*=0.1028,\quad \bar{k}_*=3.5897
$$

这些数值属于 `implementation_cross_check`，不是论文侧推导证据。

## 7. Timing & Form Conventions

- **形式**：对数线性 `model(linear)`；变量为相对非随机稳态的偏离。
- **增长去趋势**：非平稳变量由技术趋势 $Z_t$ 去趋势；$z_t$ 是 $Z_t$ 增长率相对 $\gamma$ 的偏离。
- **资本时序**：$\bar{k}_{t-1}$ 是期初预定安装资本，用于第 $t$ 期生产。有效资本为 $k_t=u_t-z_t+\bar{k}_{t-1}$。
- **前瞻项**：消费、投资、资本回报、价格通胀、工资通胀和政策缺口动态都包含期望或超前项。
- **名义刚性**：价格和工资黏性通过带指数化的对数线性 Phillips 曲线进入。
- **灵活价格比较**：$y_t^f$ 由平行的灵活价格/工资模型求解，并作为产出缺口进入政策规则。
- **运行时验证**：未执行；没有运行 Dynare、残差检查、BK 检查或 IRF 生成。

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Main equation |
|---|---|---|---|
| Endogenous | `c` / $c_t$ | 消费 | (F2) |
| Endogenous | `R` / $R_t$ | 名义政策利率 | (F25) |
| Endogenous | `pi` / $\pi_t$ | 通胀 | (F11) |
| Endogenous | `L` / $l_t$ | 劳动 | (F2), (F10), (F12) |
| Endogenous | `qk` / $q_t^k$ | 安装资本价值 | (F3), (F14) |
| Endogenous | `i` / $i_t$ | 投资 | (F3), (F16) |
| Endogenous | `Rktil` / $\tilde R_t^k$ | 名义资本回报 | (F13), (F14) |
| Endogenous | `rk` / $r_t^k$ | 资本租金率 | (F7), (F9), (F14) |
| Endogenous | `kbar` / $\bar{k}_t$ | 安装资本存量 | (F4) |
| Endogenous | `y` / $y_t$ | 产出 | (F15), (F16) |
| Endogenous | `k` / $k_t$ | 有效资本服务 | (F6), (F9) |
| Endogenous | `u` / $u_t$ | 资本利用率 | (F7), (F16) |
| Endogenous | `mc` / $mc_t$ | 实际边际成本 | (F8), (F11) |
| Endogenous | `w` / $w_t$ | 实际工资 | (F8), (F9), (F12) |
| Endogenous | `wh` / $w_t^h$ | 家庭 MRS 工资 | (F10), (F12) |
| Endogenous | `z` / $z_t$ | 趋势增长率偏离 | (F1) |
| Endogenous | `ztil` / $\tilde z_t$ | 去趋势对数生产率 | (F19) |
| Endogenous | `mu` / $\mu_t$ | 投资边际效率 | (F22) |
| Endogenous | `sigw` / $\tilde\sigma_{\omega,t}$ | 金融风险/利差冲击状态 | (F28) |
| Endogenous | `laf` / $\lambda_{f,t}$ | 价格加成冲击状态 | (F23) |
| Endogenous | `law` / $\lambda_{w,t}$ | 工资加成冲击状态 | (F24) |
| Endogenous | `g` / $g_t$ | 政府支出 | (F20) |
| Endogenous | `b` / $b_t$ | 跨期偏好楔子 | (F21) |
| Endogenous | `rm` / $r_t^m$ | 货币政策残差 | (F26) |
| Endogenous | `pist` / $\pi_t^*$ | 时变通胀目标 | (F27) |
| Endogenous | flexible-price variables | $c_t^f,\ldots,y_t^f$ | 平行无名义刚性系统 | (F18), (F25) |
| Exogenous | `psi_b` | 偏好楔子创新 | (F21) |
| Exogenous | `psi_mu` | MEI 创新 | (F22) |
| Exogenous | `psi_z` | 生产率创新 | (F1), (F19), (F20) |
| Exogenous | `psi_laf` | 价格加成创新 | (F23) |
| Exogenous | `psi_law` | 工资加成创新 | (F24) |
| Exogenous | `psi_sigw` | 利差/风险创新 | (F28) |
| Exogenous | `psi_rm` | 货币政策创新 | (F26) |
| Exogenous | `psi_g` | 政府支出创新 | (F20) |
| Parameter | `alp` / $\alpha$ | 资本份额 | (F1), (F8), (F15) |
| Parameter | `zeta_p`, `iota_p`, `epsp` | 价格 Calvo/指数化/Kimball 参数 | (F11) |
| Parameter | `zeta_w`, `iota_w`, `epsw` | 工资 Calvo/指数化/Kimball 参数 | (F12) |
| Parameter | `del` / $\delta$ | 折旧 | (F5), (F14) |
| Parameter | `Bigphi` / $\Phi_p$ | 固定成本/加成生产参数 | (F15), (F16) |
| Parameter | `s2` / $S''$ | 投资调整成本曲率 | (F3), (F4) |
| Parameter | `h` | 习惯持久性 | (F2), (F10) |
| Parameter | `ppsi` / $\psi$ | 利用率成本参数 | (F7) |
| Parameter | `nu_l` | 劳动负效用曲率 | (F10) |
| Parameter | `bet` / $\beta$ | 贴现因子 | (F3), (F11), (F12) |
| Parameter | `psi1`, `psi2`, `psi3`, `rho` | 政策规则系数 | (F25) |
| Parameter | `sigmac` / $\sigma_c$ | 相对风险厌恶 | (F2) |
| Parameter | `rho_*`, `eta_*`, `sigma_*` | 冲击持久性、MA 和尺度参数 | (F19)-(F28) |
| Parameter | starred steady-state constants | $c_*,i_*,y_*,\bar{k}_*,r_*^k,\gamma$ | (F2)-(F16) |

状态：`needs_review`。核心 SW 对数线性方程在 MinerU Markdown 中可读；`US_DNGS15_SW` 相对 SWFF/SWSP 变体的边界和技术附录稳态应在升级审核状态前复核。
