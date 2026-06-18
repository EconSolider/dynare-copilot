# US_ACELm -- 企业特定资本、名义刚性

> MMB 模型 `US_ACELm` 的第一版私有档案推导。未执行运行时验证。凡论文侧 Markdown 只引用需另行索取的技术附录而没有给出完整线性方程的地方，均标记为 `needs_review`。

## 1. 模型概述

- **模型**：`US_ACELm`，Altig, Christiano, Eichenbaum, and Linde (2005), "Firm-Specific Capital, Nominal Rigidities and the Business Cycle."
- **来源记录**：源 Markdown `raw/mmb_mineru/runs/us_acelm_us_acelswm_us_acelswt_us_acelt__firm_specific_capital_nominal_rigidities__e0fac58f/full.md`；原始 PDF `raw/mmb_papers/Firm-specific capital, nominal rigidities.pdf`；DOI `10.3386/w11034`；MinerU run `e0fac58f-0dfb-476b-b2df-8712e57d9ce4`。
- **经济环境**：美国闭合经济中型 DSGE 模型，包含垄断竞争中间品企业、Calvo 价格、Calvo 工资、消费习惯、货币需求、可变资本利用率、投资调整成本、中性技术增长、资本体现型技术增长，以及货币增长规则。
- **资本结构**：本 MMB 条目是企业特定资本版本。企业拥有自己的资本，并在每期开始时持有预定资本存量；投资改变未来的企业层面资本。
- **形式**：Rep-MMB 实现为 `model(linear)`。论文先给出非线性原始模型，再围绕平衡增长稳态作对数线性近似。精确实现方程应视为技术附录交叉核对，而不是论文来源推导。

## 2. 主体的最优化问题

### 最终品企业

完全竞争最终品企业聚合差异化中间品：

**(F1) 最终品聚合器**

\[
Y_t=\left[\int_0^1 y_t(i)^{1/\lambda_f}\,di\right]^{\lambda_f},\qquad 1\leq \lambda_f<\infty .
\]

对各中间品投入利润最大化得到需求：

**(F2) 中间品需求**

\[
\left(\frac{P_t}{P_t(i)}\right)^{\lambda_f/(\lambda_f-1)}
=\frac{y_t(i)}{Y_t}.
\]

### 中间品企业

每个中间品企业是垄断生产者，使用中性技术和资本服务：

**(F3) 中间品生产技术**

\[
y_t(i)=K_t(i)^\alpha\big(z_t h_t(i)\big)^{1-\alpha}-\phi z_t^\ast ,
\qquad
z_t^\ast=\Upsilon_t^{\alpha/(1-\alpha)}z_t .
\]

在企业特定资本版本中，企业 `i` 积累自己的物质资本：

**(F4) 企业特定投资技术**

\[
F(I_t(i),I_{t-1}(i))=
\left[1-S\left(\frac{I_t(i)}{I_{t-1}(i)}\right)\right]I_t(i),
\]

**(F5) 企业特定资本积累**

\[
\bar K_{t+1}(i)=(1-\delta)\bar K_t(i)+F(I_t(i),I_{t-1}(i)).
\]

企业最大化预期贴现名义现金流：

**(F6) 企业目标函数**

\[
E_t\sum_{j=0}^{\infty}\beta^j v_{t+j}
\left\{
P_{t+j}(i)y_{t+j}(i)
-P_{t+j}R_{t+j}w_{t+j}h_{t+j}(i)
-P_{t+j}\Upsilon_{t+j}^{-1}\big[I_{t+j}(i)+a(u_{t+j}(i))\bar K_{t+j}(i)\big]
\right\}.
\]

企业在 Calvo 定价和期内时序约束下选择价格、劳动、资本利用率和投资。技术冲击先到达，随后企业选择价格、投资和利用率；货币政策冲击和最终需求随后实现。

### 家庭

家庭消费、供给差异化劳动、持有货币和现金余额、在同质资本基准中拥有资本，并在 Calvo 摩擦下设定工资。偏好为：

**(F7) 家庭效用**

\[
E_t^j\sum_{l=0}^{\infty}\beta^{l-t}
\left[
\log(C_{t+l}-bC_{t+l-1})
-\psi_L\frac{h_{j,t+l}^2}{2}
\right].
\]

名义资产演化方程为：

**(F8) 家庭资产演化**

\[
\begin{aligned}
M_{t+1}={}&R_t\big[M_t-Q_t+(x_t-1)M_t^a\big]+A_{j,t}+Q_t+W_{j,t}h_{j,t}\\
&+P_t r_t^k u_t\bar K_t+D_t-(1+\eta(V_t))P_tC_t
-P_t\Upsilon_t^{-1}\big[I_t+a(u_t)\bar K_t\big].
\end{aligned}
\]

现金流通速度和交易技术为：

**(F9) 流通速度定义**

\[
V_t=\frac{P_tC_t}{Q_t}.
\]

家庭通过劳动聚合器供给差异化劳动：

**(F10) 劳动聚合器**

\[
H_t=\left[\int_0^1 h_{j,t}^{1/\lambda_w}\,dj\right]^{\lambda_w}.
\]

## 3. 一阶条件（FOC）

论文侧 Markdown 报告了原始最优化问题和若干一阶条件，但没有给出完整技术附录线性系统。因此，下列一阶和均衡条件是有来源支撑的推导骨架；精确系数层面的线性方程在获得附录来源核验前标记为 `needs_review`。

**(F11) 总价格指数**

\[
P_t=\left[\int_0^1 P_t(i)^{1/(1-\lambda_f)}\,di\right]^{1-\lambda_f}.
\]

**(F12) 未重优化企业的 Calvo 价格更新**

\[
P_t(i)=\pi_{t-1}P_{t-1}(i).
\]

**(F13) 通胀动态的约化形式**

\[
\Delta\hat\pi_t
=E\left[\beta\Delta\hat\pi_{t+1}+\gamma\hat s_t\mid\Omega_t\right].
\]

**(F14) 斜率参数映射**

\[
\gamma=\frac{(1-\xi_p)(1-\beta\xi_p)}{\xi_p}\chi ,
\]

其中 \(\chi=1\) 对应同质资本模型；在企业特定资本模型中，\(\chi\) 是结构参数的非线性函数。

**(F15) 工资需求曲线**

\[
h_{j,t}=\left(\frac{W_t}{W_{j,t}}\right)^{\lambda_w/(\lambda_w-1)}H_t.
\]

**(F16) 总工资指数**

\[
W_t=\left[\int_0^1 W_{j,t}^{1/(1-\lambda_w)}\,dj\right]^{1-\lambda_w}.
\]

**(F17) 未重优化家庭的 Calvo 工资更新**

\[
W_{j,t}=\pi_{t-1}\mu_{z^\ast}W_{j,t-1}.
\]

**(F18) 货币需求一阶条件**

\[
R_t=1+\eta'\left(\frac{P_tC_t}{Q_t}\right)\left(\frac{P_tC_t}{Q_t}\right)^2 .
\]

**(F19) 货币需求利率半弹性**

\[
\epsilon=\frac{1}{4}\left(\frac{1}{R-1}\right)\left(\frac{1}{2+\varphi}\right),
\qquad
\varphi=\frac{\eta''V}{\eta'} .
\]

**(F20) 资本服务**

\[
K_t=u_t\bar K_t .
\]

**(F21) 资本利用率对数线性 FOC, needs_review**

\[
E\left[\frac{1}{\sigma_a}\hat r_t^k-\hat u_t\mid\Omega_t\right]=0.
\]

**(F22) 投资调整对数线性反应, needs_review**

\[
\hat i_t=\hat i_{t-1}+\frac{1}{S''}\sum_{j=0}^{\infty}\beta^j
E\left[\hat P_{k',t+j}\mid\Omega_t\right].
\]

**(F23) 稳态 Fisher 关系**

\[
R=\frac{\pi\mu_{z^\ast}}{\beta}.
\]

## 4. 市场出清与总量恒等式

**(F24) 平衡增长技术的增长率**

\[
\mu_{z^\ast,t}=\mu_{\Upsilon,t}^{\alpha/(1-\alpha)}\mu_{z,t}.
\]

**(F25) 贷款市场出清**

\[
W_tH_t=x_tM_t-Q_t.
\]

**(F26) 总资源约束**

\[
(1+\eta(V_t))C_t+\Upsilon_t^{-1}\big[I_t+a(u_t)\bar K_t\big]\leq Y_t.
\]

**(F27) 货币基础恒等式, implementation_cross_check needs_review**

\[
\hat m_t+\hat\pi_t-\hat m_{t-1}-\hat x_{t-1}
=-\hat\mu_{z,t}-\frac{\alpha}{1-\alpha}\hat\mu_{\Upsilon,t}.
\]

**(F28) 产出缺口定义, implementation_cross_check**

\[
\widehat{outputgap}_t=\hat y_t-\hat y_t^{flex}.
\]

## 5. 外生过程

**(F29) 中性技术增长**

\[
\hat\mu_{z,t}=\rho_{\mu_z}\hat\mu_{z,t-1}+\varepsilon_{\mu_z,t}.
\]

**(F30) 资本体现型技术增长**

\[
\hat\mu_{\Upsilon,t}=\rho_{\mu_\Upsilon}\hat\mu_{\Upsilon,t-1}+\varepsilon_{\mu_\Upsilon,t}.
\]

**(F31) 货币增长政策分解**

\[
\hat x_t=\hat x_{z,t}+\hat x_{\Upsilon,t}+\hat x_{M,t}.
\]

**(F32) 货币政策冲击过程**

\[
\hat x_{M,t}=\rho_{xM}\hat x_{M,t-1}+\varepsilon_{M,t}.
\]

**(F33) 货币政策对中性技术的反应**

\[
\hat x_{z,t}=\rho_{xz}\hat x_{z,t-1}+c_z\varepsilon_{z,t}+c_z^p\varepsilon_{z,t-1}.
\]

**(F34) 货币政策对体现型技术的反应**

\[
\hat x_{\Upsilon,t}=\rho_{x\Upsilon}\hat x_{\Upsilon,t-1}
c_{\Upsilon}\varepsilon_{\Upsilon,t}+c_{\Upsilon}^p\varepsilon_{\Upsilon,t-1}.
\]

**(F35) Rep-MMB 中的暂时性中性技术冲击, implementation_cross_check**

\[
\epsilon_t=\rho_\epsilon\epsilon_{t-1}+\sigma_\epsilon\varepsilon_{\epsilon,t}.
\]

## 6. 稳态求解

模型围绕平衡增长稳态求解。论文直接设定若干稳态关系，并估计动态参数。

1. 选择校准的长期参数：

\[
\beta=1.03^{-0.25},\qquad \alpha=0.36,\qquad \delta=0.025,\qquad \lambda_w=1.05.
\]

2. 设定体现型技术增长，并由平均产出增长推出中性技术增长：

\[
\mu_y=\mu_\Upsilon^{\alpha/(1-\alpha)}\mu_z,\qquad
\mu_\Upsilon=1.0042,\qquad \mu_y=1.0045.
\]

3. 定义平衡增长技术：

\[
\mu_{z^\ast}=\mu_\Upsilon^{\alpha/(1-\alpha)}\mu_z.
\]

4. 使用稳态 Fisher 关系：

\[
R=\frac{\pi\mu_{z^\ast}}{\beta}.
\]

5. 设定平均货币增长：

\[
x=1.017.
\]

6. 通过稳态流通速度和交易成本份额参数化交易成本：

\[
V=0.45,\qquad \eta=0.036,\qquad V=\frac{PC}{Q}.
\]

7. 选择固定成本 \(\phi\) 使稳态利润为零。来源说明了这一标准化，但主论文 Markdown 没有给出完整闭式稳态块。

8. 对 Rep-MMB 的 `model(linear)` 文件，所有带帽实现变量均为相对平衡增长稳态的偏离；未执行运行时验证或精确稳态残差检查。

## 7. 时序与形式约定

- **期内时序**：技术冲击先被观测，随后家庭作出实际决策、企业作出价格/投资/利用率决策；货币政策冲击随后到达；最终需求实现后企业选择劳动以满足需求。
- **企业特定资本**：每个中间品企业在 `t` 期初持有预定的 \(\bar K_t(i)\)。投资 \(I_t(i)\) 改变 \(\bar K_{t+1}(i)\)，因此企业层面资本是状态变量。
- **资本服务**：\(K_t=u_t\bar K_t\)；资本利用率可变且有成本。
- **价格和工资**：Calvo 未重优化者的价格按滞后通胀指数化，工资按滞后通胀加稳态生产率增长指数化。
- **模型形式**：Rep-MMB 使用 `model(linear)`。论文原始模型是带平衡增长的非线性模型，随后围绕非随机稳态近似。
- **运行时验证**：未执行；没有运行 Dynare。

## 8. 变量与参数对照表

| 类别 | 符号 / ASCII | 含义 | 主要方程 |
|---|---|---|---|
| 内生 | `Y`, `ytilde_t` | 产出 / 缩放产出 | (F1), (F3), (F26) |
| 内生 | `y(i)` | 中间品产出 | (F2), (F3) |
| 内生 | `P`, `pi_t` | 价格水平 / 通胀 | (F11)-(F14) |
| 内生 | `s_t` | 平均实际边际成本 | (F13), (F14) |
| 内生 | `W`, `wtilde_t` | 总工资 / 缩放工资 | (F15)-(F17), (F25) |
| 内生 | `H`, `h_t` | 总工时 | (F10), (F25) |
| 内生 | `C`, `c_t` | 消费 | (F7)-(F9), (F26) |
| 内生 | `Q`, `q_t` | 现金余额 / 货币需求对象 | (F8), (F9), (F18), (F25) |
| 内生 | `M`, `m_t` | 货币余额 | (F8), (F25), (F27) |
| 内生 | `x`, `x_t` | 总货币增长 | (F31)-(F34) |
| 内生 | `R`, `R_t` | 总利率 | (F18), (F23), (F32) |
| 内生 | `K`, `kbar_t1` | 资本服务 / 物质资本存量 | (F5), (F20) |
| 内生 | `I`, `i_t` | 投资 | (F4), (F5), (F22), (F26) |
| 内生 | `u_t` | 资本利用率 | (F20), (F21), (F26) |
| 内生 | `lambda_zstar_t` | 实现中的边际效用 / 乘子对象 | (F7), implementation cross-check |
| 内生 | `rhotilde_t` | 缩放资本租金回报 | (F21), implementation cross-check |
| 外生 | `eps_M_t`, `epsilon_M_` | 货币政策创新 | (F32) |
| 外生 | `eps_muz_t`, `eps_muz_` | 中性技术增长创新 | (F29), (F33) |
| 外生 | `eps_muups_t`, `eps_muups_` | 体现型技术增长创新 | (F30), (F34) |
| 外生 | `epsilon_t` | Rep-MMB 中的暂时性中性技术冲击 | (F35) |
| 参数 | `alpha` | 资本份额 | (F3), (F24) |
| 参数 | `beta` | 贴现因子 | (F6), (F13), (F23) |
| 参数 | `delta` | 折旧率 | (F5) |
| 参数 | `lambda_f` | 中间品加成参数 | (F1), (F2), (F14) |
| 参数 | `lambda_w` | 工资加成参数 | (F10), (F15), (F16) |
| 参数 | `xi_p`, `gamma` | Calvo 价格概率 / 约化 Phillips 曲线斜率 | (F13), (F14) |
| 参数 | `xi_w` | Calvo 工资概率 | (F17) |
| 参数 | `b` | 习惯参数 | (F7) |
| 参数 | `psi_L` | 劳动负效用尺度 | (F7) |
| 参数 | `sigma_a` | 利用率成本曲率 | (F21) |
| 参数 | `S''`, `kappa` | 投资调整曲率 | (F22) |
| 参数 | `mu_z`, `mu_ups`, `mu_zstar` | 稳态增长率 | (F23), (F24) |
| 参数 | `rho_*`, `c_*`, `cp_*` | 冲击和政策过程系数 | (F29)-(F35) |

实现交叉核对文件包含粘性价格和灵活价格两套相同线性化模块。灵活价格模块用于定义产出缺口；来源论文说明同质资本和企业特定资本模型只通过 \(\gamma\) 的通胀方程映射而不同。
