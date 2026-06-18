# US_CMR10fa -- 推导（最优化问题 + 一阶条件）

> MMB 档案一阶段抽取。公式状态：`needs_review`；方程基于 MinerU Markdown OCR，尚未核对 PDF 正文，也未运行 Dynare。

## 1. 模型概述

- **模型 ID**：`US_CMR10fa`。
- **论文**：Christiano, Lawrence J.; Motto, Roberto; Rostagno, Massimo (2010), "Financial factors in economic fluctuations - small version with financial accelerator", DOI `10.2139/ssrn.1600166`。
- **主来源**：`raw/mmb_mineru/runs/us_cmr10_us_cmr10fa__financial_factors_in_economic_fluctuations__7ef56ea6/full.md`；原始 PDF 记录为 `raw/mmb_papers/Financial factors in economic fluctuations - small version with financial accelerator.pdf`。
- **变体**：论文中的 "Financial Accelerator Model" 变体，保留 BGG 风格的企业家金融加速器，去掉银行融资渠道：银行负债发行、流动性效用、货币总量、营运资本融资、风险新闻信号和长期债券项均在该变体中关闭。
- **主体**：最终品聚合商、垄断竞争中间品生产者、资本品生产者、企业家、用于企业家信贷的简化银行/金融合约模块、带 Calvo 工资设定的家庭、政府需求和货币当局。
- **形式**：源文献 Appendix A 以平稳化缩放后的非线性形式列出方程，但论文围绕非随机稳态求解并估计对数线性近似。本条目记录平稳化非线性均衡条件；OCR 受损的公式细节标为 `needs_review`。
- **运行验证**：未执行；未运行 Dynare。

## 2. 主体的最优化问题

### 最终品聚合商

代表性最终品厂商聚合差异化中间品，并选择 $Y_{jt}$ 的需求：

$$
Y_t=\left[\int_0^1 Y_{jt}^{1/\lambda_{f,t}}\,dj\right]^{\lambda_{f,t}},\qquad 1\leq\lambda_{f,t}<\infty .
$$

### 中间品厂商

中间品生产者租用资本服务并雇佣同质劳动，生产函数为：

$$
Y_{jt}=\epsilon_t K_{jt}^{\alpha}(z_t l_{jt})^{1-\alpha}-\Phi z_t^{\ast}
$$

当右侧为正时生产。基准论文中企业存在营运资本融资需求，但 `US_CMR10fa` 的金融加速器变体关闭营运资本融资。价格设定采用带指数化的 Calvo 调整：

$$
P_{it}=\tilde{\pi}_t P_{i,t-1},\qquad
\tilde{\pi}_t=(\pi_t^{target})^\iota(\pi_{t-1})^{1-\iota}.
$$

### 资本品生产者

资本品生产者购买投资品和未折旧资本，将投资转化为安装资本，并最大化贴现利润：

$$
x'=x+F(I_t,I_{t-1},\zeta_{i,t})
=x+\left[1-S\left(\zeta_{i,t}I_t/I_{t-1}\right)\right]I_t.
$$

$$
\max_{\{I_{t+j},x_{t+j}\}}E_t\sum_{j=0}^{\infty}\beta^j\lambda_{t+j}\Pi^k_{t+j}.
$$

### 企业家

企业家用净值和银行贷款购买安装资本。其收益受到对数正态的异质性冲击 $\omega$ 影响，冲击离散度 $\sigma_t$ 随时间变化。标准债务合约在银行零利润约束下选择 cutoff $\bar{\omega}_{t+1}$ 和资本购买量 $\bar{K}_{t+1}$。

$$
\bar{\omega}_{t+1}(1+R^k_{t+1})Q_{\bar K',t}\bar K_{t+1}=Z_{t+1}B_{t+1},\qquad
B_{t+1}=Q_{\bar K',t}\bar K_{t+1}-N_{t+1}.
$$

### 家庭

家庭消费、储蓄、持有资产并供给差异化劳动。在完整模型中，家庭从货币资产获得流动性服务；在该金融加速器变体中，这些流动性项设为零。工资设定采用带工资指数化的 Calvo 调整：

$$
W_{j,t}=\tilde{\pi}_{w,t}(\mu_{z^{\ast}})^{1-\vartheta}(\mu_{z^{\ast},t})^\vartheta W_{j,t-1},
\qquad
\tilde{\pi}_{w,t}=(\pi_t^{target})^{\iota_w}(\pi_{t-1})^{1-\iota_w}.
$$

## 3. 一阶条件（FOC）

**产品生产和定价**

- **(F1) 边际成本度量**（`needs_review`，来源 A.1）：

$$
s_t=\left(\frac{1}{1-\alpha}\right)^{1-\alpha}\left(\frac{1}{\alpha}\right)^\alpha
\frac{(r_t^k[1+\psi_k R_t])^\alpha(\tilde w_t[1+\psi_l R_t])^{1-\alpha}}{\epsilon_t}.
$$

- **(F2) 边际成本的另一种度量**（`needs_review`，来源 A.2）：

$$
s_t=\frac{r_t^k[1+\psi_kR_t]}{\alpha\epsilon_t\left(\Upsilon\frac{\mu_{z,t}^{\ast}l_t}{u_tk_t}\right)^{1-\alpha}}.
$$

- **(F3) Calvo 价格重设指数递推**（`needs_review`，来源 A.3）：

$$
p_t^{\ast}-\left[(1-\xi_p)\left(\frac{1-\xi_p(\tilde\pi_t/\pi_t)^{1/(1-\lambda_{f,t})}}{1-\xi_p}\right)^{\lambda_{f,t}}
+\xi_p\left((\tilde\pi_t/\pi_t)p_{t-1}^{\ast}\right)^{\lambda_{f,t}/(1-\lambda_{f,t})}\right]^{(1-\lambda_{f,t})/\lambda_{f,t}}=0.
$$

- **(F4) 价格辅助变量 $F_p$ 递推**（`needs_review`，来源 A.4）：

$$
E_t\left\{\lambda_{z,t}Y_{z,t}
+\left(\frac{\tilde\pi_{t+1}}{\pi_{t+1}}\right)^{1/(1-\lambda_{f,t})}\beta\xi_pF_{p,t+1}-F_{p,t}\right\}=0.
$$

- **(F5) 价格辅助变量 $K_p$ 递推**（`needs_review`，来源 A.5）：

$$
E_t\left\{\lambda_{f,t}\lambda_{z,t}Y_{z,t}s_t
+\beta\xi_p\left(\frac{\tilde\pi_{t+1}}{\pi_{t+1}}\right)^{-\lambda_{f,t}/(\lambda_{f,t}-1)}K_{p,t+1}-K_{p,t}\right\}=0.
$$

- **(F6) 缩放产出定义**（`needs_review`，来源 A.6）：

$$
Y_{z,t}=(p_t^{\ast})^{\lambda_f/(\lambda_f-1)}
\left\{\epsilon_t\nu_t^l\left(u_t\frac{\bar k_t}{\Upsilon\mu_{z,t}^{\ast}}\right)^\alpha
\left[(w_t^{\ast})^{\lambda_w/(\lambda_w-1)}H_t\right]^{1-\alpha}-\phi\right\}.
$$

**资本品生产者和企业家**

- **(F7) 资本供给价格**（`needs_review`，来源 A.7）：

$$
E_t\left[\lambda_{z,t}q_tF_{1,t}-\lambda_{z,t}\frac{1}{\mu_{\Upsilon,t}}
+\beta\frac{\lambda_{z,t+1}}{\mu_{z,t+1}^{\ast}\Upsilon}q_{t+1}F_{2,t+1}\right]=0.
$$

- **(F8) 资本积累**（`needs_review`，来源 A.8）：

$$
\bar k_{t+1}=(1-\delta)\frac{1}{\mu_{z,t}^{\ast}\Upsilon}\bar k_t+
\left[1-S\left(\frac{\zeta_{i,t}i_t\mu_{z,t}^{\ast}\Upsilon}{i_{t-1}}\right)\right]i_t.
$$

- **(F9) 资本利用率**（`needs_review`，来源 A.9）：

$$
r_t^k=\tau_t^{oil}a'(u_t).
$$

- **(F10) 资本收益率**（`needs_review`，来源 A.10）：

$$
R_t^k=\frac{[u_tr_t^k-\tau_t^{oil}a(u_t)]+(1-\delta)q_t}{\Upsilon q_{t-1}}\pi_t+\tau^k\delta-1.
$$

- **(F11) 标准债务合约最优性**（`needs_review`，来源 A.11 的 OCR 受损）：

$$
E_t\left\{[1-\Gamma_t(\bar\omega_{t+1})]\frac{1+R_{t+1}^k}{1+R_{t+1}^e}
+\frac{\Gamma_t'(\bar\omega_{t+1})}{\Gamma_t'(\bar\omega_{t+1})-\mu G_t'(\bar\omega_{t+1})}
\left[\frac{1+R_{t+1}^k}{1+R_{t+1}^e}\big(\Gamma_t(\bar\omega_{t+1})-\mu G_t(\bar\omega_{t+1})\big)-1\right]\right\}=0.
$$

- **(F12) 企业家贷款的银行零利润条件**（`needs_review`，来源 A.12 看起来存在 OCR 维度损坏）：

$$
(1+R_{t+1}^k)\left[\Gamma_t(\bar\omega_{t+1})-\mu G_t(\bar\omega_{t+1})\right]
=1+R_{t+1}^e\left(q_t\bar k_{t+1}-n_{t+1}\right).
$$

- **(F13) 净值运动方程**（`needs_review`，来源 A.13）：

$$
n_{t+1}=\frac{\gamma_t}{\pi_t\mu_{z,t}^{\ast}}
\left\{(1+R_t^k)\bar k_tq_{t-1}
-\left[1+R_t^e+
\frac{\mu\int_0^{\bar\omega_t}\omega\,dF_t(\omega_t)(1+R_t^k)\bar k_tq_{t-1}}{\bar k_tq_{t-1}-n_t}\right]
(\bar k_tq_{t-1}-n_t)\right\}+w^e.
$$

**家庭和工资设定**

- **(F14) 消费边际效用**（`needs_review`，来源 A.19）：

$$
E_t\left\{u_{c,t}^z-\frac{\mu_{z,t}^{\ast}\zeta_{c,t}}{c_t\mu_{z,t}^{\ast}-bc_{t-1}}
+b\beta\frac{\zeta_{c,t+1}}{c_{t+1}\mu_{z,t+1}^{\ast}-bc_t}\right\}=0.
$$

- **(F15) 消费选择**（`needs_review`，`US_CMR10fa` 中流动性项不活跃；来源 A.20）：

$$
E_t\{u_{c,t}^z-(1+\tau^C)\lambda_{z,t}-\text{liquidity-service marginal utility term}\}=0.
$$

- **(F16) Calvo 工资重设指数**（`needs_review`，来源 A.21）：

$$
w_t^{\ast}=\left[(1-\xi_w)\left(\frac{1-\xi_w\left(\frac{\tilde\pi_{w,t}}{\pi_{w,t}}(\mu_{z^{\ast}})^{1-\vartheta}(\mu_{z^{\ast},t})^\vartheta\right)^{1/(1-\lambda_w)}}{1-\xi_w}\right)^{\lambda_w}
+\xi_w\left(\frac{\tilde\pi_{w,t}}{\pi_{w,t}}(\mu_{z^{\ast}})^{1-\vartheta}(\mu_{z^{\ast},t})^\vartheta w_{t-1}^{\ast}\right)^{\lambda_w/(1-\lambda_w)}\right]^{(1-\lambda_w)/\lambda_w}.
$$

- **(F17) 工资辅助变量 $F_w$ 递推**（`needs_review`，来源 A.22）：

$$
E_t\left\{(w_t^{\ast})^{\lambda_w/(\lambda_w-1)}H_t\frac{(1-\tau^l)\lambda_{z,t}}{\lambda_w}
+\beta\xi_w(\mu_{z^{\ast}})^{(1-\vartheta)/(1-\lambda_w)}
(\mu_{z^{\ast},t+1})^{\vartheta/(1-\lambda_w)-1}
\left(\frac{1}{\pi_{w,t+1}}\right)^{\lambda_w/(1-\lambda_w)}
\frac{\tilde\pi_{w,t+1}^{1/(1-\lambda_w)}}{\pi_{t+1}}F_{w,t+1}-F_{w,t}\right\}=0.
$$

- **(F18) 工资辅助变量 $K_w$ 递推**（`needs_review`，来源 A.23）：

$$
E_t\left\{\left[(w_t^{\ast})^{\lambda_w/(\lambda_w-1)}H_t\right]^{1+\sigma_L}\zeta_{c,t}
+\beta\xi_wE_t\left(\frac{\tilde\pi_{w,t+1}}{\pi_{w,t+1}}(\mu_{z^{\ast}})^{1-\vartheta}(\mu_{z^{\ast},t+1})^\vartheta\right)^{\lambda_w(1+\sigma_L)/(1-\lambda_w)}K_{w,t+1}-K_{w,t}\right\}=0.
$$

- **(F19) 无风险非流动资产 Euler 方程**（`needs_review`，来源 A.24）：

$$
E_t\left\{-\lambda_{z,t}+\frac{\beta}{\mu_{z,t+1}^{\ast}\pi_{t+1}}\lambda_{z,t+1}(1+R_{t+1}^T)\right\}=0.
$$

源文献还列出货币选择 FOC A.25-A.27。它们属于完整基准模型，但在 `US_CMR10fa` 中不活跃，因为金融加速器变体取消了流动性效用和货币总量选择。

## 4. 市场出清与总量恒等式

- **(F20) 资源约束**（`needs_review`，来源 A.30）：

$$
\frac{\mu G_t(\bar\omega_t)(1+R_t^k)q_{t-1}\bar k_t}{\mu_{z,t}^{\ast}}\frac{1}{\pi_t}
+\tau_t^{oil}a(u_t)\frac{\bar k_t}{\Upsilon\mu_{z,t}^{\ast}}
+g_t+c_t+\frac{i_t}{\mu_{\Upsilon,t}}
+\Theta\frac{1-\gamma_t}{\gamma_t}(n_{t+1}-w^e)
=Y_{z,t}.
$$

- **(F21) 总银行贷款/信贷定义**（`needs_review`，来源 A.32）：

$$
b_t^{Tot}=\psi_lw_tl_t+\psi_k\frac{r_t^ku_t\bar k_t}{\mu_{z,t}^{\ast}\Upsilon}
+(q_t\bar k_{t+1}-n_{t+1}).
$$

- **(F22) 平均信用利差**（`needs_review`，来源 A.33）：

$$
P_t^e=\frac{\mu\int_0^{\bar\omega_t}\omega\,dF_t(\omega_t)(1+R_t^k)\bar k_tq_{t-1}}
{\bar k_tq_{t-1}-n_t}.
$$

- **(F23) Appendix E 的资本需求曲线**（`needs_review`，来源 E.7）：

$$
\hat q_t=-\widehat{\bar k}_{t+1}+\hat n_{t+1}
+A\left(\frac{\bar k-n}{n}\right)E_t\left(\frac{R^k\hat R_{t+1}^k}{1+R^k}-\frac{R^e\hat R_{t+1}^e}{1+R^e}\right)
-B\left(\frac{\bar k-n}{n}\right)\sigma\hat\sigma_t.
$$

- **(F24) Appendix E 的信贷需求曲线**（`needs_review`，来源 E.10）：

$$
\hat P_{t+1}^{e,D}=-\frac{n}{\bar k}\hat b_{t+1}+\frac{n}{\bar k}\hat n_{t+1}
+E_t\left[H\left(\frac{R^k\hat R_{t+1}^k}{1+R^k}\right)
-(H-1)\frac{R^e\hat R_{t+1}^e}{1+R^e}+J\sigma\hat\sigma_t\right].
$$

- **(F25) Appendix E 的信贷供给曲线**（`needs_review`，来源 E.11）：

$$
\hat P_{t+1}^{e,S}=S\frac{n}{\bar k}\hat b_{t+1}-S\frac{n}{\bar k}\hat n_{t+1}
-E_t\left[S\left(\frac{R^k\hat R_{t+1}^k}{1+R^k}\right)
+(1+S)\frac{R^e\hat R_{t+1}^e}{1+R^e}-T\sigma\hat\sigma_t\right].
$$

仅属于基准模型的货币和准备金恒等式 A.29、A.31、A.34 和 A.35 不列为活跃 `US_CMR10fa` 变体方程，因为金融加速器变体删除了银行融资渠道。

## 5. 外生过程

- **(F26) 持久技术趋势**（`needs_review`，来源方程 3 和 Appendix 缩放）：

$$
z_t=\mu_{z,t}z_{t-1},\qquad
\mu_{z^{\ast},t}=\mu_{z,t}\Upsilon^{\alpha/(1-\alpha)}.
$$

- **(F27) 政府支出缩放**（`needs_review`，来源 2.6 节）：

$$
G_t=z_t^{\ast}g_t.
$$

- **(F28) 通胀目标过程**（`needs_review`，来源 2.9 节）：

$$
\hat\pi_t^{target}=\rho_\pi\hat\pi_{t-1}^{target}+\varepsilon_t^{target}.
$$

- **(F29) 本变体中仅含未预期分量的风险冲击**（`needs_review`，来源 2.10.1 节关闭风险新闻信号）：

$$
\hat\sigma_t=\rho_\sigma\hat\sigma_{t-1}+\xi_{\sigma,t}^{0}.
$$

- **(F30) 其他一阶自回归冲击**（`needs_review`，来源 2.9 节）：

$$
\hat x_t=\rho_x\hat x_{t-1}+\varepsilon_t^x,\qquad
x\in\{\mu_{\Upsilon},g,\mu_{z^{\ast}},\gamma,\epsilon,\zeta_c,\zeta_i,\tau^{oil},\lambda_f\}.
$$

- **(F31) 货币政策冲击**（`needs_review`，来源 2.9 节）：

$$
\varepsilon_t\sim iid.
$$

## 6. 稳态求解

源文献说明，模型先改写为平稳变量，再围绕非随机稳态求解。一阶段档案条目不重建完整数值稳态算法；以下条件是后续实现阶段需要的来源支持稳态限制。

- **(F32) 平衡增长路径平稳化**（`needs_review`，来源 Appendix A）：

$$
\bar k_{t+1}=\frac{\bar K_{t+1}}{z_t^{\ast}\Upsilon^t},\quad
i_t=\frac{I_t}{z_t^{\ast}\Upsilon^t},\quad
Y_{z,t}=\frac{Y_t}{z_t^{\ast}},\quad
c_t=\frac{C_t}{z_t^{\ast}},\quad
q_t=\Upsilon^t\frac{Q_{\bar K',t}}{P_t}.
$$

- **(F33) 零稳态安装成本条件**（`needs_review`，来源 2.2 节）：

$$
S(\mu_z^{\ast}\Upsilon)=0,\qquad S'(\mu_z^{\ast}\Upsilon)=0,\qquad S''>0.
$$

- **(F34) 利用率成本归一化**（`needs_review`，来源 2.3 节）：

$$
u=1,\qquad a(1)=0,\qquad a'(u)=r^k,\qquad a''(u)=\sigma_a r^k.
$$

- **(F35) 美国金融加速器稳态目标**（`needs_review`，来源 Tables 1-3）：

$$
\beta=0.9966,\quad \delta=0.025,\quad \alpha=0.40,\quad
\lambda_f=1.20,\quad \lambda_w=1.05,\quad \gamma=0.9762,\quad \mu=0.94.
$$

源表还报告美国目标比率，包括 $i/y=0.22$、$c/y=0.58$、$g/y=0.20$、$k/y=6.98$ 和 $N/(K-N)=3.40$。这些记录为校准目标，而不是独立核验过的稳态解。

## 7. 时序与形式约定

- 本推导使用论文中的平稳化变量：产出和消费按 $z_t^{\ast}$ 缩放，资本和投资按 $z_t^{\ast}\Upsilon^t$ 缩放。
- 期末 $t$ 购买的资本为 $\bar K_{t+1}$；日期 $t$ 的生产使用此前安装的资本服务。因此，缩放后的资本积累方程用 $\bar k_t$ 和 $i_t$ 决定 $\bar k_{t+1}$。
- 企业家净值 $n_{t+1}$ 是日期 $t$ 资本市场使用的期末购买力，受金融财富冲击 $\gamma_t$ 以及与较早风险冲击实现相关的信贷损失影响。
- 合约 cutoff $\bar\omega_{t+1}$ 按贷款清偿观察期标注日期；决定合约的风险离散度在贷款发放时已知。
- 模型围绕平稳稳态做对数线性近似求解。因此 Appendix E 方程以带帽变量的百分比偏离形式表示。
- `US_CMR10fa` 删除基准模型中的银行融资/流动性模块，因此完整模型的货币/准备金 FOC 记录为排除项，而不是活跃方程。
- 运行验证、Blanchard-Kahn 检查和 IRF 检查均延期。

## 8. 变量与参数对照表

| 类别 | 符号 / ASCII 提示 | 含义 | 方程参考 |
|---|---|---|---|
| 内生变量 | $s_t$ / `sU` | 实际边际成本 | (F1), (F2) |
| 内生变量 | $r_t^k$ / `rkU` | 资本服务租金率 | (F2), (F9) |
| 内生变量 | $\tilde w_t$ / `wU` | 缩放实际工资 | (F1), (F17) |
| 内生变量 | $p_t^{\ast}$ / `pstarU` | 相对重设价格 | (F3) |
| 内生变量 | $F_{p,t}$ / `FpXU` | 价格 Calvo 辅助变量 | (F4) |
| 内生变量 | $K_{p,t}$ | 价格 Calvo 辅助变量 | (F5) |
| 内生变量 | $Y_{z,t}$ / `YU` | 缩放产出 | (F6), (F20) |
| 内生变量 | $q_t$ / `qU` | 安装资本相对价格 | (F7), (F23) |
| 内生变量 | $\bar k_{t+1}$ / `kbarU` | 缩放安装资本存量 | (F8), (F23) |
| 内生变量 | $i_t$ / `iU` | 缩放投资 | (F8), (F20) |
| 内生变量 | $u_t$ / `uU` | 资本利用率 | (F9), (F10) |
| 内生变量 | $R_t^k$ / `RkXU` | 企业家资本总收益率 | (F10), (F11), (F13) |
| 内生变量 | $\bar\omega_t$ / `omegabarU` | 债务合约违约 cutoff | (F11), (F12) |
| 内生变量 | $n_{t+1}$ / `nU` | 企业家净值 | (F13), (F21), (F23) |
| 内生变量 | $u_{c,t}^z$ / `uzcU` | 缩放消费边际效用 | (F14), (F15) |
| 内生变量 | $\lambda_{z,t}$ / `lambdazU` | 缩放家庭乘子 | (F15), (F19) |
| 内生变量 | $c_t$ / `cU` | 缩放消费 | (F14), (F20) |
| 内生变量 | $w_t^{\ast}$ / `wstarU` | 相对重设工资 | (F16), (F17), (F18) |
| 内生变量 | $F_{w,t}$ / `FwXU` | 工资 Calvo 辅助变量 | (F17) |
| 内生变量 | $K_{w,t}$ | 工资 Calvo 辅助变量 | (F18) |
| 内生变量 | $R_{t+1}^T,R_{t+1}^e$ / `ReXU` | 无风险/存款机会收益率 | (F11), (F19), (F23) |
| 内生变量 | $g_t$ / `gU` | 缩放政府消费 | (F20), (F27), (F30) |
| 内生变量 | $b_t^{Tot}$ / `BU` | 总银行贷款/信贷 | (F21), (F24), (F25) |
| 内生变量 | $P_t^e$ / `PrU` | 平均信用利差/溢价 | (F22), (F24), (F25) |
| 外生冲击 | $\mu_{\Upsilon,t}$ / `muupU` | 投资特定技术/相对投资价格 | (F7), (F20), (F30) |
| 外生冲击 | $\mu_{z^{\ast},t}$ / `muzstarU` | 持久平衡增长冲击 | (F26), (F30) |
| 外生冲击 | $\gamma_t$ / `gammaU` | 金融财富/企业家生存冲击 | (F13), (F30) |
| 外生冲击 | $\epsilon_t$ / `epsilU` | 暂时技术冲击 | (F1), (F6), (F30) |
| 外生冲击 | $\sigma_t$ / `sigmaU` | 企业家风险冲击 | (F11), (F29) |
| 外生冲击 | $\zeta_{c,t}$ / `zetacU` | 消费偏好冲击 | (F14), (F30) |
| 外生冲击 | $\zeta_{i,t}$ / `zetaiU` | 投资边际效率冲击 | (F7), (F8), (F30) |
| 外生冲击 | $\tau_t^{oil}$ / `tauoU` | 油价/利用率成本冲击 | (F9), (F10), (F30) |
| 外生冲击 | $\lambda_{f,t}$ / `lambdafU` | 价格加成冲击 | (F3), (F30) |
| 外生冲击 | $\pi_t^{target}$ / `pitargetU` | 通胀目标冲击 | (F28) |
| 外生冲击 | $\varepsilon_t$ / `e_xpU` | 货币政策冲击 | (F31) |
| 参数 | $\beta,\delta,\alpha$ / `betaUU, deltaUU, alphaUU` | 贴现因子、折旧率、资本份额 | (F7), (F8), (F35) |
| 参数 | $\xi_p,\xi_w,\iota,\iota_w$ / `xipUU, xiwUU, iota1UU, iotaw1UU` | Calvo 和指数化参数 | (F3), (F16) |
| 参数 | $\lambda_f,\lambda_w$ / `lambdafUU, lambdawUU` | 产品和劳动加成 | (F1), (F16) |
| 参数 | $\psi_k,\psi_l$ / `psi_k, psi_l` | 营运资本融资比例；本变体中设为零 | (F1), (F21) |
| 参数 | $\mu,\Theta,w^e$ / `muUU, bigthetaUU, weUU` | 监控成本、退出企业家消费份额、初始转移 | (F13), (F20), (F22) |
| 参数 | $\rho_x$ | 冲击持久性参数 | (F28), (F29), (F30) |
