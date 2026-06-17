# US_CET15 -- 推导（最优化问题 + 一阶条件）

> 本私有归档草稿用于有来源支撑的模型理解。未执行运行时验证。实现文件 `.mod` 只作为 `implementation_cross_check` 使用。

来源信息：模型 `US_CET15`，Christiano、Eichenbaum 和 Trabandt，"Understanding the Great Recession"，American Economic Journal: Macroeconomics，DOI `10.1257/mac.20140104`。主要来源 Markdown：`raw/mmb_mineru/runs/us_cet15__understanding_the_great_recession__310d6625/full.md`。原始 PDF：`raw/mmb_papers/Understanding the Great Recession.pdf`。MinerU run id：`310d6625-b977-4335-aae4-c44716391cf8`。

## 1. Model Overview

- **模型**：美国中等规模新凯恩斯 DSGE 模型，在 Christiano、Eichenbaum 和 Trabandt (2013) 基础上把劳动参与率内生化。
- **用途**：用金融、消费、技术和政府支出冲击解释大衰退期间产出、消费、投资、就业、失业、职位空缺、劳动参与、工资、通胀和利率的变化。
- **主体和模块**：含家庭生产与劳动参与选择的代表性家庭；最终品聚合器；Calvo 零售商；带交替出价工资谈判的竞争性批发商和搜寻匹配劳动市场；政府；货币当局；技术和 wedge 冲击过程。
- **名义刚性**：Calvo 价格；论文模型没有名义工资刚性。
- **形式**：带平衡增长缩放的非线性均衡系统，MMB 实现使用对数变量。2008 年后的模拟使用非线性条件、确定性等价、绑定 ZLB 和货币政策制度切换。MMB `.mod` 是一阶对数水平实现，并用 `R` 与 `F` 两个平行经济处理货币政策信息时序。
- **状态**：`needs_review`；论文说明许多技术细节在单独技术附录中，而本条目没有对应的规范化附录文件。

## 2. Optimization Problems

### 2.1 家庭

每个家庭有单位质量成员，分为不参与劳动市场、就业和失业三种状态。家庭选择市场消费、家庭消费、投资、资本利用率、资本积累、劳动参与、就业和金融资产。期效用为：

$$
\mathcal{U}_t = \ln \tilde{C}_t + v\left(\frac{M_{t+1}}{P_t}\right),
\qquad
\tilde{C}_t =
\left[(1-\omega)(C_t-b\bar C_{t-1})^\chi
+ \omega(C_t^H-b\bar C_{t-1}^H)^\chi\right]^{1/\chi}.
$$

家庭生产和劳动参与调整成本为：

$$
C_t^H = \eta_t^H(1-L_t) - \mathcal{F}(L_t,L_{t-1};\eta_t^L),
\qquad
\mathcal{F}(L_t,L_{t-1};\eta_t^L)
= \frac{1}{2}\eta_t^L\phi_L\left(\frac{L_t}{L_{t-1}}-1\right)^2.
$$

家庭预算和资产约束为：

$$
P_t C_t + P_{I,t}I_t + \mathcal{A}_{t+1}
\leq
\left(R_{K,t}u_t^K-a(u_t^K)P_{I,t}\right)K_t
+(L_t-l_t)P_t\eta_t^D D + l_t W_t - T_t + B_t + M_t,
$$

$$
\mathcal{A}_{t+1}\geq \frac{B_{t+1}}{R_t}+M_{t+1}.
$$

资本演化为：

$$
K_{t+1}=(1-\delta_K)K_t+\left[1-S(I_t/I_{t-1})\right]I_t.
$$

### 2.2 最终品生产者

竞争性最终品企业聚合差异化零售品：

$$
Y_t=\left[\int_0^1 Y_{j,t}^{1/\lambda}\,dj\right]^\lambda,
\qquad
\max_{\{Y_{j,t}\}}\; P_tY_t-\int_0^1P_{j,t}Y_{j,t}\,dj.
$$

### 2.3 零售商

零售商 `j` 使用资本服务和批发商劳动投入生产差异化投入：

$$
Y_{j,t}=k_{j,t}^{\alpha}(z_t h_{j,t})^{1-\alpha}-\eta_t^\phi\phi.
$$

零售商选择要素投入，并在需求曲线和 Calvo 刚性下定价：

$$
P_{j,t}=
\begin{cases}
P_{j,t-1}, & \text{with probability }\xi,\\
\tilde P_t, & \text{with probability }1-\xi.
\end{cases}
$$

有风险营运资本版本把普通中间投入融资成本替换为：

$$
P_t^h\left[\varkappa R_t(1+\hat\Delta_t^k)+(1-\varkappa)\right].
$$

### 2.4 批发商与劳动市场

竞争性批发商在匹配市场招聘工人，支付职位/招聘成本，并通过交替出价协议谈判工资。自由进入使招聘成本等于匹配价值：

$$
\eta_t^\kappa\kappa = J_t.
$$

工资满足交替出价分享规则：

$$
\alpha_1J_t=\alpha_2(V_t-U_t)-\alpha_3\eta_t^\gamma\gamma+\alpha_4(\vartheta_t-\eta_t^D D).
$$

### 2.5 政策与 wedges

在 ZLB 以外，货币当局遵循利率规则。大衰退模拟在债券 Euler 方程中加入消费 wedge，在资本 Euler 方程中加入金融 wedge。政府消费在平衡增长缩放后外生给定。

## 3. First-Order Conditions

- **(F1) 复合消费对市场消费的边际效用**：

$$
\lambda_{C,t}
= (1-\omega)\tilde C_t^{1-\chi-1}(C_t-b\bar C_{t-1})^{\chi-1}.
$$

- **(F2) 家庭消费的边际效用**：

$$
\lambda_{H,t}
= \omega \tilde C_t^{1-\chi-1}(C_t^H-b\bar C_{t-1}^H)^{\chi-1}.
$$

- **(F3) 带消费 wedge 的债券 Euler 方程**：

$$
1=(1+\Delta_t^b)E_t\left[m_{t+1}\frac{R_t}{\pi_{t+1}}\right].
$$

- **(F4) 带金融 wedge 的资本 Euler 方程**：

$$
1=(1-\tilde\Delta_t^k)E_t\left[m_{t+1}\frac{R_{t+1}^k}{\pi_{t+1}}\right].
$$

- **(F5) 投资调整成本 FOC** `needs_review`：论文定义调整成本函数，但 OCR Markdown 没有印出完整 FOC。实现交叉检查中它由 `pk` 的 Tobin 价格方程表示：

$$
1=P_{K,t}\left[1-S_t-S_t'\frac{I_t}{I_{t-1}}\mu_{\Phi,t}\mu_{\Psi,t}\right]
+E_t\left[m_{t+1}\mu_{\Phi,t+1}P_{K,t+1}S'_{t+1}
\left(\frac{I_{t+1}}{I_t}\right)^2\mu_{\Phi,t+1}\mu_{\Psi,t+1}\right].
$$

- **(F6) 资本积累**：

$$
K_{t+1}=(1-\delta_K)K_t+\left[1-S(I_t/I_{t-1})\right]I_t.
$$

- **(F7) 资本利用率租金条件** `needs_review`：

$$
R_{K,t}=P_{I,t}a'(u_t^K).
$$

- **(F8) 最终品企业对零售商 `j` 的需求**：

$$
Y_{j,t}=\left(\frac{P_t}{P_{j,t}}\right)^{\lambda/(\lambda-1)}Y_t.
$$

- **(F9) 零售生产函数**：

$$
Y_{j,t}=k_{j,t}^{\alpha}(z_t h_{j,t})^{1-\alpha}-\eta_t^\phi\phi.
$$

- **(F10) 营运资本边际投入成本**：

$$
MC^h_t=P_t^h\left[\varkappa R_t(1+\hat\Delta_t^k)+(1-\varkappa)\right].
$$

- **(F11) 零售商成本最小化条件** `needs_review`：

$$
a'(u_t^K)u_t^K\frac{K_t}{\mu_{\Phi,t}\mu_{\Psi,t}}
=\frac{\alpha}{1-\alpha}\left[\varkappa R_t(1+\hat\Delta_t^k)+(1-\varkappa)\right]\vartheta_t l_t.
$$

- **(F12) Calvo 价格辅助递推 1** `needs_review`：

$$
F_t=\lambda_{C,t}Y_t+\beta\xi E_t\left[\left(\frac{\tilde\pi_{t+1}}{\pi_{t+1}}\right)^{1/(1-\lambda)}F_{t+1}\right].
$$

- **(F13) Calvo 价格辅助递推 2** `needs_review`：

$$
K_t^p=\lambda \lambda_{C,t}Y_t MC_t
+\beta\xi E_t\left[\left(\frac{\tilde\pi_{t+1}}{\pi_{t+1}}\right)^{\lambda/(1-\lambda)}K_{t+1}^p\right].
$$

- **(F14) 最优重定价条件** `needs_review`：

$$
K_t^p-F_t=(1-\lambda)\log\left(\frac{1-\xi(\tilde\pi_t/\pi_t)^{1/(1-\lambda)}}{1-\xi}\right).
$$

- **(F15) 价格分散度** `needs_review`：

$$
\Delta_t^{\lambda/(1-\lambda)}
=(1-\xi)^{1-\lambda}\left[1-\xi(\tilde\pi_t/\pi_t)^{1/(1-\lambda)}\right]^\lambda
+\xi(\tilde\pi_t\Delta_{t-1})^{\lambda/(1-\lambda)}.
$$

- **(F16) 工资现值**：

$$
w_t^p=w_t+\rho E_t[m_{t+1}w_{t+1}^p].
$$

- **(F17) 边际收益产品现值**：

$$
\vartheta_t^p=\vartheta_t+\rho E_t[m_{t+1}\vartheta_{t+1}^p].
$$

- **(F18) 企业匹配价值**：

$$
J_t=\vartheta_t^p-w_t^p.
$$

- **(F19) 自由进入招聘条件**：

$$
J_t=\eta_t^\kappa\kappa.
$$

- **(F20) 就业工人的价值**：

$$
V_t=w_t^p+A_t.
$$

- **(F21) 分离后的工人价值**：

$$
A_t=(1-\rho)E_t m_{t+1}\left[s f_{t+1}V_{t+1}
+s(1-f_{t+1})U_{t+1}
+(1-s)(\mathcal{L}_{t+1}+N_{t+1})\right]
+\rho E_t[m_{t+1}A_{t+1}].
$$

- **(F22) 失业价值**：

$$
U_t=\eta_t^D D+E_t m_{t+1}\left[s f_{t+1}V_{t+1}
+s(1-f_{t+1})U_{t+1}
+(1-s)(\mathcal{L}_{t+1}+N_{t+1})\right].
$$

- **(F23) 不参与劳动市场的价值**：

$$
N_t=\lambda_t\eta_t^H+E_t m_{t+1}
\left[e_{t+1}\left(f_{t+1}V_{t+1}+(1-f_{t+1})U_{t+1}-\mathcal{L}_{t+1}\right)
+(1-e_{t+1})N_{t+1}\right].
$$

- **(F24) 交替出价工资分享规则**：

$$
\alpha_1J_t=\alpha_2(V_t-U_t)-\alpha_3\eta_t^\gamma\gamma+\alpha_4(\vartheta_t-\eta_t^D D).
$$

- **(F25) 就业运动方程**：

$$
l_t=\rho l_{t-1}+f_t(L_t-\rho l_{t-1}).
$$

- **(F26) 找到工作的概率**：

$$
f_t=\frac{x_tl_{t-1}}{L_t-\rho l_{t-1}}.
$$

- **(F27) 从不参与状态进入劳动市场的概率**：

$$
e_t=\frac{L_t-s(L_{t-1}-\rho l_{t-1})-\rho l_{t-1}}{1-L_{t-1}}.
$$

- **(F28) 劳动参与选择条件** `needs_review`：

$$
\eta_t^D D+p_{l,t}f_t
-\lambda_t\frac{C_t^H+\mathcal{F}(L_t,L_{t-1};\eta_t^L)}{1-L_t}
-\lambda_t\mathcal{F}_1(L_t,L_{t-1};\eta_t^L)
-E_t[m_{t+1}\lambda_{t+1}\mathcal{F}_2(L_{t+1},L_t;\eta_{t+1}^L)]
=0.
$$

- **(F29) 家庭消费**：

$$
C_t^H=\eta_t^H(1-L_t)-\mathcal{F}(L_t,L_{t-1};\eta_t^L).
$$

- **(F30) 匹配函数**：

$$
x_tl_{t-1}=\sigma_m(L_t-\rho l_{t-1})^\sigma(l_{t-1}v_t)^{1-\sigma}.
$$

- **(F31) 职位填补概率**：

$$
Q_t=\frac{x_t}{v_t}.
$$

## 4. Market Clearing & Identities

- **(F32) 中间品市场出清**：

$$
h_t=l_t.
$$

- **(F33) 资本服务市场出清**：

$$
u_t^K K_t=\int_0^1k_{j,t}\,dj.
$$

- **(F34) 最终品资源约束**：

$$
C_t+\frac{I_t+a(u_t^K)K_t}{\Psi_t}+\eta_t^\kappa\kappa x_tl_{t-1}+G_t=Y_t.
$$

- **(F35) 投资品价格**：

$$
P_{I,t}=\frac{P_t}{\Psi_t}.
$$

- **(F36) 贷款市场出清**：

$$
\varkappa h_tP_t^h=\frac{B_{t+1}}{R_t}.
$$

- **(F37) 政策规则使用的 GDP 恒等式**：

$$
\mathcal{O}_t=C_t+\frac{I_t}{\Psi_t}+G_t.
$$

## 5. Exogenous Processes

- **(F38) ZLB 之外的货币政策规则**：

$$
\ln(R_t/R)=\rho_R\ln(R_{t-1}/R)
+(1-\rho_R)\left[
0.25 r_\pi\ln\left(\frac{\pi_t^A}{\pi^A}\right)
+0.25 r_{\Delta y}\ln\left(\frac{\mathcal{O}_t}{\mathcal{O}_{t-4}\mu_\mathcal{O}^A}\right)
\right]
+\sigma_R\varepsilon_{R,t}.
$$

- **(F39) 政府消费**：

$$
G_t=\eta_t^g g_t.
$$

- **(F40) 投资专有技术增长**：

$$
\ln\mu_{\Psi,t}=(1-\rho_\Psi)\ln\mu_\Psi+\rho_\Psi\ln\mu_{\Psi,t-1}
+\sigma_\Psi\varepsilon_{\Psi,t}.
$$

- **(F41) 中性技术增长分解**：

$$
\ln\mu_{z,t}=\ln(z_t/z_{t-1})=\ln\mu_z+\mu_{P,t}+\mu_{T,t}.
$$

- **(F42) 持久中性技术成分**：

$$
\mu_{P,t}=\rho_P\mu_{P,t-1}+\sigma_P\varepsilon_{P,t}.
$$

- **(F43) 暂时中性技术成分**：

$$
\mu_{T,t}=\rho_T\mu_{T,t-1}+\sigma_T(\varepsilon_{T,t}-\varepsilon_{T,t-1}).
$$

- **(F44) 中性技术的 Wold 表示**：

$$
(1-\rho_PL)(1-\rho_TL)\ln(\mu_{z,t})
=(1-\theta_1L-\theta_2L^2)\sigma_\eta\eta_t.
$$

- **(F45) 平衡增长复合技术**：

$$
\Phi_t=\Psi_t^{\alpha/(1-\alpha)}z_t.
$$

- **(F46) 缓慢移动的平衡增长归一化项**：

$$
\Omega_{i,t}=\Phi_{t-1}^{\theta}(\Omega_{i,t-1})^{1-\theta},
\qquad i=1,\ldots,7.
$$

- **(F47) 消费 wedge 过程**：

$$
\Delta_t^b=1.5\Delta_{t-1}^b-0.56\Delta_{t-2}^b+\varepsilon_t^b.
$$

- **(F48) 金融利差映射**：

$$
\Gamma_t=E_t\left[\frac{\Delta_t^k+\Delta_{t+1}^k+\cdots+\Delta_{t+27}^k}{7}\right],
\qquad
E_t\Gamma_{t+1}=0.5\Gamma_t.
$$

- **(F49) 营运资本 wedge 缩放**：

$$
\hat\Delta_t^k=0.33\Delta_t^k.
$$

## 6. Steady-State Solution

模型围绕非随机平衡增长路径求解。$Y_t/\Phi_t$、$C_t/\Phi_t$、$w_t/\Phi_t$ 和 $I_t/(\Psi_t\Phi_t)$ 等变量收敛到常数。

稳态归一化和校准步骤：

1. 用校准平均增长率设定稳态增长：年人均产出增长固定 $\mu_\Phi$；年投资增长固定 $\mu_\Phi\mu_\Psi$。
2. 设 $u_t^K=1$、$S(\mu_\Phi\mu_\Psi)=S'(\mu_\Phi\mu_\Psi)=0$，并在 $L_t=L_{t-1}$ 时令劳动参与调整成本为零。
3. 设稳态通胀目标 $\pi^A$ 为年化净通胀 2%，并选择 $\beta$ 以对应年化实际利率 3%。
4. 校准 $\delta_K=0.025$、工作存续概率 $\rho=0.9$、$Q=0.7$、失业率 $u=0.055$、劳动参与 $L=0.67$，以及 $G/Y=0.2$。
5. 推出就业 $l=L(1-u)$、招聘率 $x=1-\rho$、找工作概率 $f=xl/(L-\rho l)$、由 $Q=x/v$ 推出职位空缺，并由 (F30) 推出匹配效率参数。
6. 选择 $\omega$、$\sigma_m$、$\phi$、$\gamma$ 和政府规模 `g`，使劳动参与、职位填补、政府产出比、失业率和零售商零利润等校准稳态目标成立。
7. MMB 实现交叉检查为所有 `R` 与 `F` 变量计算对数稳态，但本归档草稿不验证残差或 BK 条件。

本节标记为 `needs_review`，因为来源 Markdown 给出了稳态目标和隐含值，但没有完整手工规范化的稳态推导。

## 7. Timing & Form Conventions

- 时间频率为季度。
- 在论文方程中，$K_t$ 是 `t` 期初拥有的资本存量，并演化为 $K_{t+1}$；MMB 实现使用缩放后的对数资本 `kstst`，当前生产使用滞后资本。
- 进入 `t` 期的就业由 $\rho l_{t-1}$ 加新增招聘继承；当期就业为 $l_t=(\rho+x_t)l_{t-1}$。
- 在 MMB 实现中，货币政策冲击不属于 `t` 期价格/工资和数量决策的信息集。`.mod` 用两个平行经济实现这一点：`R` 处理受限信息下的货币政策冲击，`F` 处理标准信息集下的其他冲击。
- 所有实现中的内生变量均为对数；报告的聚合变量是结合 `R` 与 `F` 经济后的稳态偏离。
- 论文的大衰退模拟使用非线性条件、确定性等价、ZLB 和前瞻指引制度切换。本地归档条目不记录 Dynare 运行时验证。

## 8. Variable & Parameter Reference Table

| 类别 | 符号 / ASCII 线索 | 含义 | 方程线索 |
|---|---|---|---|
| 内生 | $C_t$ / `c` | 市场消费 | (F1), (F34) |
| 内生 | $\tilde C_t$ | 复合消费 | (F1)-(F2) |
| 内生 | $C_t^H$ / `cH` | 家庭消费 | (F2), (F29) |
| 内生 | $\lambda_{C,t}$ / `lambda_C` | 市场消费边际效用 | (F1), (F3) |
| 内生 | $I_t$ / `i` | 投资 | (F5), (F34) |
| 内生 | $K_t$ / `kstst` | 物质资本存量 | (F6), (F33) |
| 内生 | $u_t^K$ / `uk` | 资本利用率 | (F7), (F33) |
| 内生 | $P_{I,t}$ / `pk` | 投资品价格 | (F35) |
| 内生 | $Y_t$ / `y` | 总产出 | (F9), (F34) |
| 内生 | $\mathcal O_t$ / `GDP` | 政策规则中的 GDP 指标 | (F37), (F38) |
| 内生 | $\pi_t$ / `pi` | 通胀 | (F3), (F38) |
| 内生 | $R_t$ / `R` | 名义利率 | (F3), (F38) |
| 内生 | $\Delta_t$ / `Disp` | 价格分散度 | (F15) |
| 内生 | $F_t,K_t^p$ / `F`, `K` | Calvo 定价辅助变量 | (F12)-(F14) |
| 内生 | $L_t$ / `L` | 劳动力 | (F25), (F27), (F28) |
| 内生 | $l_t$ / `l` | 就业 | (F25), (F30) |
| 内生 | $u_t$ / `unemp` | 失业率 | 由 $L_t,l_t$ 定义 |
| 内生 | $x_t$ / `x` | 招聘率 | (F25), (F30) |
| 内生 | $f_t$ / `f` | 找工作概率 | (F26) |
| 内生 | $v_t$ / `v`, `vTot` | 职位空缺率 / 空缺数 | (F30), (F31) |
| 内生 | $Q_t$ / `Q` | 职位填补概率 | (F31) |
| 内生 | $w_t,w_t^p$ / `w`, `wp` | 实际工资和工资现值 | (F16), (F24) |
| 内生 | $J_t,V_t,U_t,N_t,A_t$ / `J`, `V`, `U`, `N`, `A` | 匹配和工人状态价值 | (F18)-(F24) |
| 内生 | $\vartheta_t,\vartheta_t^p$ / `varthet`, `varthetp` | 边际收益产品及其现值 | (F17), (F18) |
| 外生/状态 | $\mu_{\Psi,t}$ / `mupsi` | 投资专有技术增长 | (F40) |
| 外生/状态 | $\mu_{z,t}$ / `muz` | 中性技术增长 | (F41)-(F44) |
| 外生/状态 | $\eta_t^g,\eta_t^D,\eta_t^\gamma,\eta_t^\kappa,\eta_t^\phi,\eta_t^L,\eta_t^H$ / `nG` family | 平衡增长归一化项 | (F46) |
| 外生/wedge | $\Delta_t^b$ | 消费 wedge | (F3), (F47) |
| 外生/wedge | $\Delta_t^k,\hat\Delta_t^k,\Gamma_t$ | 金融和营运资本 wedges | (F4), (F10), (F48), (F49) |
| varexo | `epsR_eps`, `muz_eps`, `mupsi_eps` | MMB 实现冲击 | implementation cross-check |
| 参数 | $\beta,b,\omega,\chi$ | 偏好和习惯/家庭消费参数 | (F1)-(F3) |
| 参数 | $\alpha,\delta_K,\lambda,\xi,\varkappa$ | 生产、折旧、加成、Calvo、营运资本份额 | (F6)-(F15) |
| 参数 | $\rho,s,\sigma,\sigma_m,\kappa,\delta,M,\gamma,D,\phi_L$ | 劳动市场和谈判参数 | (F19)-(F31) |
| 参数 | $\rho_R,r_\pi,r_{\Delta y},\sigma_R$ | 货币政策参数 | (F38) |
| 参数 | $\rho_\Psi,\rho_P,\rho_T,\sigma_\Psi,\sigma_P,\sigma_T,\theta_1,\theta_2,\sigma_\eta$ | 技术过程参数 | (F40)-(F44) |

本一阶推导不声明方程数等于变量数，因为发表版 Markdown 不含完整技术附录，且 MMB 实现把许多变量复制到受限信息和完全信息两个经济中。
