# US_PV15 -- 推导

> 第一遍归档抽取。状态：`needs_review`。运行验证：未执行。公式来自 Poutineau and Vermandel (2015) 的 MinerU Markdown；代表性 `.mod` 文件仅作为 `implementation_cross_check`。

## 1. Model Overview

- **模型**：`US_PV15`，Poutineau and Vermandel (2015)，"Financial frictions and the extensive margin of activity"。
- **文献与出处**：Jean-Christophe Poutineau and Gauthier Vermandel，*Research in Economics* 69(4), 525-554，DOI `10.1016/j.rie.2015.09.005`。
- **经济体**：用 1993Q1-2012Q3 美国数据估计的 DSGE 模型，包含内生企业进入、金融加速器摩擦、工资粘性、价格粘性、贷款利率粘性、资本调整成本、可变利用率和多类外生冲击。
- **主体与模块**：家庭、工会、在位企业、初创/进入企业、企业家、金融中介、资本供应者和货币当局。
- **模型形式**：以水平值写成的非线性均衡系统。实现交叉检查中的 Dynare 文件使用非线性 `model` 块和一阶随机模拟，不是 `model(linear)`。
- **变体说明**：本归档条目记录含金融摩擦的论文侧模型。`.mod` 实现还包含用于构造产出缺口的自然/灵活价格对应模型；该信息只作为 `implementation_cross_check`。

## 2. Optimization Problems

### 家庭

家庭消费、供给劳动、持有存款，并持有在位企业股份。论文摘要方程给出边际效用、存款欧拉方程、股份欧拉方程、劳动供给条件和自由进入估值，而不是一个完整预算约束：

$$
\lambda_t^c = (C_t - h C_{t-1})^{-\sigma_c}.
$$

家庭、金融中介和资本供应者使用的随机贴现因子为

$$
M_{t,t+1} = \beta\,\frac{\lambda_{t+1}^c}{\lambda_t^c}.
$$

### 工会

工会在垄断竞争和 Rotemberg 式工资调整成本下设定工资。其最优条件把实际工资、家庭边际替代率和预期工资调整项联系起来。

### 在位企业

在位企业使用资本服务和劳动生产差异化中间品，通过选择投入最小化成本，并在时变加成和价格调整成本下设定价格。

### 初创企业

初创企业将进入劳动转化为新的生产性品种。进入企业面对沉没劳动需求，其进入成本通过工资预付约束受到贷款利率影响。

### 企业家

企业家同时融资集约边际，即在位企业资本，和广延边际，即进入劳动成本。资产负债表约束为

$$
L_{t+1} + NW_{t+1} = Q_t K_{t+1} + \gamma W_t H_t^E.
$$

企业家在项目特质回报实现之前选择融资规模。项目生产率服从带截止点 $\omega_t^C$ 的 Pareto 分布，乐观信念使外部融资溢价随杠杆上升。

### 金融中介

银行吸收存款，向企业家贷款，在违约状态承担监督损失，并在垄断竞争和 Rotemberg 调整成本下设定贷款利率。

### 资本供应者

资本供应者在投资调整成本下把投资品转化为已安装资本，选择资本影子价值并决定利用率。

## 3. First-Order Conditions

- **(F1) 消费边际效用**：
$$
\lambda_t^c = (C_t - h C_{t-1})^{-\sigma_c}.
$$

- **(F2) 存款欧拉方程**：
$$
\beta E_t\left[\frac{\lambda_{t+1}^c}{\lambda_t^c}\right] e^{\varepsilon_t^B}(1+r_t)=1.
$$

- **(F3) 股份欧拉方程**：
$$
v_t=(1-\delta)\beta E_t\left[\frac{\lambda_{t+1}^c}{\lambda_t^c}\left(d_{t+1}+v_{t+1}+\theta d_{t+1}^E\right)\right].
$$

- **(F4) 劳动供给**：
$$
\lambda_t^c w_t^h=\chi H_{jt}^{\sigma_H}.
$$

- **(F5) 自由进入条件**：
$$
f_E mc_t^E
=v_t\frac{\partial[(1-AC_t^E)n_t^E]}{\partial n_t^E}e^{\varepsilon_t^E}
+\beta E_t\left[
v_{t+1}\frac{\partial(1-AC_{t+1}^E)}{\partial n_t^E}n_{t+1}^E e^{\varepsilon_{t+1}^E}
\right].
$$

- **(F6) 工资设定条件**：
$$
\frac{W_t}{P_t^C}
=\mu_t^W\frac{W_t^h}{P_t^C}
-(\mu_t^W-1)W_t\left[
AC_t^{W\prime}
+\beta E_t\left\{\frac{\lambda_{t+1}^c}{\lambda_t^c}\frac{H_{t+1}}{H_t}AC_{t+1}^{W\prime}\right\}
\right].
$$

- **(F7) 在位企业生产函数**：
$$
n_tY_t=e^{\varepsilon_t^A}(K_{t+1}^u)^\alpha(H_t^d)^{1-\alpha}.
$$

- **(F8) 已利用资本**：
$$
K_{t+1}^u=u_tK_t.
$$

- **(F9) 实际边际成本**：
$$
mc_t=\frac{1}{e^{\varepsilon_t^A}}
\left(\frac{z_t}{\alpha}\right)^\alpha
\left(\frac{w_t}{1-\alpha}\right)^{1-\alpha}.
$$

- **(F10) 成本最小化投入组合**：
$$
\alpha H_t^d w_t=(1-\alpha)K_{t+1}^u z_t.
$$

- **(F11) 相对价格加成关系**：
$$
\rho_t=\mu_t mc_t.
$$

- **(F12) 时变商品加成**（`needs_review`：MinerU 对辅助变量 $\Psi_t$ 附近的 OCR 较嘈杂）：
$$
\mu_t=e^{\varepsilon_t^P}
\frac{\epsilon_P}{(\epsilon_P-1)\left(1-\frac{P_t^C}{P_t}AC_t^P\right)+\kappa_P\Psi_t}.
$$

- **(F13) 价格调整辅助项**（`needs_review`）：
$$
\Psi_t =
\left(\pi_t-[\xi_P\pi_{t-1}+(1-\xi_P)]\right)\pi_t
-\beta E_t\left\{
\frac{\lambda_{t+1}^c}{\lambda_t^c}
\left[
\left(\pi_t-[\xi_P\pi_{t-1}+(1-\xi_P)]\right)
\pi_{t+1}\frac{Y_{t+1}}{Y_t}
\right]\right\}.
$$

- **(F14) 在位企业股息**：
$$
d_t=(\rho_t-mc_t-AC_t^P)Y_t.
$$

- **(F15) 初创企业生产技术**：
$$
n_t^E f_E=e^{\varepsilon_t^A}H_t^E.
$$

- **(F16) 新企业边际成本**：
$$
mc_t^E=\frac{w_t}{e^{\varepsilon_t^A}}(1+\gamma r_t^L).
$$

- **(F17) 企业家资产负债表**：
$$
L_{t+1}+NW_{t+1}=Q_tK_{t+1}+\gamma W_tH_t^E.
$$

- **(F18) 违约截止点**：
$$
\omega_t^C(1+r_t^k)Q_{t-1}K_t=(1+r_{t-1}^L)L_t.
$$

- **(F19) 外部融资溢价 / 企业家 FOC**（`needs_review`：论文相邻方程中混用 $\chi$ 和 $\varkappa$ 记号）：
$$
\frac{1+E_t r_{t+1}^k}{1+r_t^L}
=\frac{\kappa-1}{\kappa\bar{\omega}^C}
\left[
\frac{\kappa}{\kappa-1}\left(\frac{L_{t+1}}{Q_tK_{t+1}}\right)
\right]^\chi.
$$

- **(F20) 企业家净值运动方程**：
$$
NW_{t+1}=(1-\delta)(1-\theta)d_t^E+T^E.
$$

- **(F21) 企业家股息**：
$$
n_td_t^E=\eta_t(\bar{\omega}_t-\omega_t^C)(1+R_t^k)Q_{t-1}K_t e^{\varepsilon_t^N}.
$$

- **(F22) 贷款边际成本**：
$$
1+MC_t^L=(1+R_t)E_t\left[
\eta_{t+1}+(1-\mu^B)(1-\eta_{t+1})\frac{\omega_{t+1}}{\omega_{t+1}^C}
\right]^{-1}.
$$

- **(F23) 名义贷款利率设定**：
$$
R_t^L=\mu_t^LMC_t^L
-(\mu_t^L-1)R_t^L
\left(
\frac{\partial AC_t^L}{\partial R_t^L}
+\beta E_t\left\{
\frac{\lambda_{t+1}^c}{\lambda_t^c}
\frac{\partial AC_{t+1}^L}{\partial R_t^L}
\frac{L_{t+2}}{L_{t+1}}
\right\}
\right).
$$

- **(F24) 实际贷款利率**：
$$
1+r_t^L=\frac{1+R_t^L}{E_t\pi_{t+1}^C}.
$$

- **(F25) 资本积累**：
$$
K_{t+1}=e^{\varepsilon_t^I}(1-AC_t^I)I_t+(1-\delta)K_t.
$$

- **(F26) 已安装资本影子价值**（`needs_review`：源方程以 $\varepsilon_t^I q_t$ 开头；实现交叉检查使用 $e^{\varepsilon_t^I}q_t$）：
$$
\varepsilon_t^I q_t
=1+e^{\varepsilon_t^I}q_t
\frac{\partial(I_{kt}AC_{kt}^I)}{\partial I_{kt}}
+\beta E_t\left\{
\frac{\lambda_{t+1}^c}{\lambda_t^c}e^{\varepsilon_{t+1}^I}\pi_{t+1}^Cq_{t+1}
\frac{\partial(I_{k,t+1}AC_{k,t+1}^I)}{\partial I_{kt}}
\right\}.
$$

- **(F27) 资本利用率条件**：
$$
z_t=\bar{Z}\exp\left[\frac{\psi}{1-\psi}(u_t-1)\right].
$$

- **(F28) 资本回报**：
$$
1+r_t^k=\frac{z_tu_t-\Phi(u_t)+(1-\delta)q_t}{q_{t-1}}.
$$

## 4. Market Clearing & Identities

- **(F29) 货币政策规则**（`needs_review`：源方程同时使用 $\rho$ 和 $\rho_R$）：
$$
R_t-\bar{R}
=\rho(R_{t-1}-\bar{R})
+(1-\rho_R)\left[\phi_\pi(\pi_t-1)+\phi_Y(Y_t-\bar{Y})\right]
+\phi_{\Delta Y}(Y_t-Y_{t-1})+\varepsilon_t^R.
$$

- **(F30) Fisher 方程**：
$$
1+r_t=\frac{1+R_t}{E_t\pi_{t+1}^C}.
$$

- **(F31) 总需求 / 资源约束**：
$$
Y_t^d=C_t+I_t+\bar{G}\varepsilon_t^G+\Phi(u_t)K_{t-1}
+n_tAC_t^PY_t+AC_t^WH_t+AC_t^LL_{t+1}.
$$

- **(F32) 品种价格关系**：
$$
n_t\rho_t^{1-\epsilon_P}=1.
$$

- **(F33) 相对价格通胀恒等式**：
$$
\frac{\rho_t}{\rho_{t-1}}=\frac{\pi_t}{\pi_t^C}.
$$

- **(F34) 商品市场均衡**：
$$
n_tY_t=\rho_t^{-\epsilon_P}Y_t^d.
$$

- **(F35) 劳动市场均衡**：
$$
H_t=H_t^d+H_t^E.
$$

- **(F36) 企业品种运动方程**（`needs_review`：Appendix B 使用 $n_{jt}$ 记号；这里按模型正文作总量解释）：
$$
n_t=(1-\delta)\left[n_{t-1}+e^{\varepsilon_{t-1}^E}(1-AC_{t-1}^E)n_{t-1}^E\right].
$$

## 5. Exogenous Processes

论文估计生产率、政府支出、偏好、投资、银行加成、净值、价格加成、工资加成、进入和货币政策冲击。Appendix B 将创新项嵌入均衡方程，而不是把所有冲击过程单独列为显示方程。实现交叉检查使用：

- **(F37) 生产率冲击**：
$$
\varepsilon_t^A=\rho_A\varepsilon_{t-1}^A+e_t^A.
$$

- **(F38) 政府支出冲击，实现中含生产率创新溢出项**：
$$
\varepsilon_t^G=\rho_G\varepsilon_{t-1}^G+e_t^G+\rho_{AG}e_t^A.
$$

- **(F39) 偏好冲击**：
$$
\varepsilon_t^B=\rho_B\varepsilon_{t-1}^B+e_t^B.
$$

- **(F40) 投资冲击**：
$$
\varepsilon_t^I=\rho_I\varepsilon_{t-1}^I+e_t^I.
$$

- **(F41) 银行加成冲击**：
$$
\varepsilon_t^L=\rho_L\varepsilon_{t-1}^L+e_t^L.
$$

- **(F42) 净值冲击**：
$$
\varepsilon_t^N=\rho_N\varepsilon_{t-1}^N+e_t^N.
$$

- **(F43) 价格加成冲击**：
$$
\varepsilon_t^P=\rho_P\varepsilon_{t-1}^P+e_t^P-u_Pe_{t-1}^P.
$$

- **(F44) 工资加成冲击**：
$$
\varepsilon_t^W=\rho_W\varepsilon_{t-1}^W+e_t^W-u_We_{t-1}^W.
$$

- **(F45) 进入冲击**：
$$
\varepsilon_t^E=\rho_E\varepsilon_{t-1}^E+e_t^E.
$$

- **(F46) 货币政策冲击**：
$$
\varepsilon_t^R=\rho_R\varepsilon_{t-1}^R+e_t^R.
$$

这些过程方程标记为 `implementation_cross_check`，因为论文正文描述了 AR(1) 加成和金融冲击，但 Appendix B 的简洁方程清单没有以显示形式给出全部 AR 规律。

## 6. Steady-State Solution

论文在 Appendix B.2 给出构造性稳态求解顺序。下列方程保留该顺序，并标记 OCR 问题。

1. 设定零稳态通胀并计算实际政策利率：
$$
\bar{\pi}^C=\bar{\pi}=1,\qquad \bar{r}=\bar{R}=\beta^{-1}-1.
$$

2. 校准稳态贷款利率：
$$
\bar{R}^L=\bar{r}^L=\left(1+\frac{0.98}{100}\right)\bar{R}-1.
$$

3. 使用贷款资本比目标：
$$
\omega_{\min}=\frac{\bar{L}}{\bar{K}}=0.50,\qquad
\kappa=\frac{1}{1-\omega_{\min}}=\frac{\bar{K}}{\bar{L}}=2.
$$

4. 用违约率目标求：
$$
\bar{\omega}^C=\omega_{\min}\bar{\eta}^{-\kappa}.
$$

5. 复原稳态资本回报和边际产出：
$$
\bar{r}^K=\frac{1+\bar{r}^L}{\bar{\omega}^C}\left(1-\frac{\bar{L}}{\bar{K}}\right)-1,\qquad
\bar{z}=\bar{r}^K+\delta.
$$

6. 计算 Pareto 项目回报的条件均值和贷款边际成本：
$$
1=\bar{\eta}\bar{\omega}+(1-\bar{\eta})\underline{\omega},\qquad
\underline{\omega}=\frac{1-\bar{\eta}\bar{\omega}}{1-\bar{\eta}},
$$
$$
\overline{mc}^L=(1+\bar{r})\left[\bar{\eta}+(1-\mu^B)(1-\bar{\eta})\frac{\underline{\omega}}{\bar{\omega}^C}\right]^{-1}-1.
$$

7. 计算贷款加成（`needs_review`：论文 B.43 附近 OCR 有歧义；实现中设为 `mu_L=rL/mcL`）：
$$
\mu_L \approx \frac{\bar{r}^L}{\overline{mc}^L}.
$$

8. 使用自由进入/股份估值方程求稳态企业数：
$$
\bar{n}=\bar{H}
\left[
\frac{(1-(1-\delta)\beta)f_E(1-\alpha)(1+\gamma\bar{r}^L)}
{(1-\delta)\beta\left((\bar{\mu}-1)+d^K\frac{\alpha}{\bar{z}}\right)}
+f_E\frac{\delta}{1-\delta}
\right]^{-1},
$$
其中
$$
d^K=\theta\bar{\eta}\bar{\omega}^C(\kappa-1)^{-1}(1+\bar{r}^K).
$$

9. 完成实际配置：
$$
\bar{\rho}=\bar{n}^{1/(\epsilon_P-1)},\qquad
\overline{mc}=\frac{\bar{\rho}}{\bar{\mu}},
$$
$$
\bar{n}^E=\bar{n}\frac{\delta}{1-\delta},\qquad
\bar{H}^E=f_E\bar{n}\frac{\delta}{1-\delta},\qquad
\bar{H}^d=\bar{H}-\bar{H}^E,
$$
$$
\bar{w}=(1-\alpha)\left[\overline{mc}\left(\frac{\alpha}{\bar{z}}\right)^\alpha\right]^{1/(1-\alpha)},
$$
$$
\bar{K}=\frac{\alpha}{\bar{z}(1-\alpha)}\bar{H}^d\bar{w}.
$$

源文报告的近似值包括 $\bar{r}=0.0081$、$\bar{r}^L=0.0179$、$\mu_L=2.1248$、$\bar{n}=1.0726$、$\bar{\rho}=1.0254$、$\bar{K}=5.6037$、$\bar{r}^K=0.0154$、$\bar{\omega}^C=0.5013$、$\bar{Y}=0.6983$、$\bar{Y}^d=0.8238$ 和 $\bar{C}=0.5354$。MinerU 源文件中最后一条稳态值句子包含重复片段，因此该稳态值清单仍为 `needs_review`。

## 7. Timing & Form Conventions

- 模型是水平值非线性模型，由扰动法求解；源归档条目不记录手工对数线性化。
- 资本在生产中是预定变量。Appendix B 将生产写作 $K_{t+1}^u=u_tK_t$，而实现交叉检查使用 `ku = u*k(-1)` 和带 `q(-1)` 的资本回报，说明 Dynare 时序下 $t$ 期生产使用上一期继承的已安装资本。
- 企业进入有一期 time-to-build 结构：$t-1$ 期选择的进入者影响 $t$ 期运营企业数。
- 企业家资产负债表融资下一期资本和当期进入劳动；论文和实现混合了论文中的 $K_{t+1}$ 记号与 Dynare 中预定状态 `k` 的时序。
- 通胀包含商品通胀率 $\pi_t$、消费品通胀率 $\pi_t^C$ 和相对价格 $\rho_t=P_t/P_t^C$。
- 金融模块区分名义政策利率 $R_t$、实际政策/存款利率 $r_t$、名义贷款利率 $R_t^L$ 和实际贷款利率 $r_t^L$。
- 未执行运行验证；未运行 Dynare。

## 8. Variable & Parameter Reference Table

| 类别 | 符号 / ASCII 交叉检查 | 含义 | 主要方程 |
|---|---|---|---|
| 内生 | $\lambda_t^c$ / `uc` | 消费边际效用 | (F1) |
| 内生 | $C_t$ / `c` | 消费 | (F1), (F31) |
| 内生 | $r_t$ / `rr`, `r` | 实际政策/存款利率 | (F2), (F30) |
| 内生 | $v_t$ / `v` | 股份价值 / 进入价值 | (F3), (F5) |
| 内生 | $H_t$, $H_t^d$, $H_t^E$ / `h`, `hc`, `he` | 总劳动、在位企业劳动和初创劳动 | (F4), (F15), (F35) |
| 内生 | $w_t^h$, $w_t$ / `wh`, `w` | 家庭期望工资和实际工资 | (F4), (F6) |
| 内生 | $n_t$, $n_t^E$ / `n`, `ne` | 运营企业和进入企业 | (F15), (F36) |
| 内生 | $Y_t$, $Y_t^d$ / `y`, `yd` | 在位企业产出和总需求 | (F7), (F31), (F34) |
| 内生 | $K_t$, $K_t^u$ / `k`, `ku` | 资本存量和已利用资本 | (F7), (F8), (F25) |
| 内生 | $mc_t$, $\rho_t$, $\mu_t$ / `mc`, `p`, `mk` | 边际成本、相对价格、加成 | (F9), (F11), (F12), (F32), (F33) |
| 内生 | $d_t$ / `d` | 在位企业股息 | (F14) |
| 内生 | $L_t$, $NW_t$ / `l`, `nn` | 企业家贷款和净值 | (F17), (F20) |
| 内生 | $\omega_t^C$, $\eta_t$, $\bar{\omega}_t$, $\underline{\omega}_t$ / `omega`, `eta`, `w_sup`, `w_inf` | 项目截止点、存活份额、条件项目回报 | (F18), (F21), (F22) |
| 内生 | $r_t^k$, $q_t$, $z_t$, $u_t$ / `rK`, `q`, `z`, `u` | 资本回报、Tobin's q、租金率、利用率 | (F25)-(F28) |
| 内生 | $R_t^L$, $r_t^L$, $MC_t^L$, $\mu_t^L$ / `rL`, `mcL`, `mut_L` | 名义/实际贷款利率、信贷边际成本、贷款加成 | (F22)-(F24) |
| 内生 | $R_t$, $\pi_t$, $\pi_t^C$ / `r`, `pi`, `pic` | 政策利率和通胀率 | (F29), (F30), (F33) |
| 外生 | $e_t^A,e_t^G,e_t^B,e_t^I,e_t^L,e_t^N,e_t^P,e_t^W,e_t^E,e_t^R$ / `e_a` 等 | 生产率、支出、偏好、投资、银行加成、净值、价格加成、工资加成、进入和政策创新 | (F37)-(F46) |
| 参数 | $\beta,h,\sigma_c,\chi,\sigma_H$ | 家庭贴现、习惯、风险厌恶、劳动偏好 | (F1)-(F4) |
| 参数 | $\alpha,\epsilon_P,\kappa_P,\xi_P,\delta$ | 生产、商品替代、价格调整/指数化、退出/折旧 | (F7)-(F14), (F25) |
| 参数 | $f_E,\gamma,\theta$ | 进入沉没成本、工资预付份额、企业家股息政策 | (F5), (F15), (F16), (F20) |
| 参数 | $\kappa,\omega_{\min},\mu_B,\chi/\varkappa$ | Pareto 形状/下界、监督成本、外部融资溢价弹性 | (F18), (F19), (F22) |
| 参数 | $\kappa_L,\mu_L$ | 贷款利率调整和贷款加成 | (F23) |
| 参数 | $\rho,\rho_R,\phi_\pi,\phi_Y,\phi_{\Delta Y}$ | 货币政策平滑和反应系数 | (F29) |
| 参数 | $\rho_A,\rho_G,\rho_B,\rho_I,\rho_L,\rho_N,\rho_P,\rho_W,\rho_E,\rho_R,u_P,u_W$ | 冲击持续性和 ARMA 项 | (F37)-(F46) |
