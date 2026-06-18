# US_YR13 推导

> Yuliya Rychalovska (2016) "The implications of financial frictions and imperfect knowledge in the estimated DSGE model of the U.S. economy" 的有来源支撑的一轮归档条目。状态：`needs_review`。
> 运行验证：未执行。未运行 Dynare。

## 1. Model Overview

- **模型 ID**：`US_YR13`。
- **论文**：Yuliya Rychalovska (2016)，"The implications of financial frictions and imperfect knowledge in the estimated DSGE model of the U.S. economy," *Journal of Economic Dynamics and Control* 73, 259-282。DOI：`10.1016/j.jedc.2016.09.014`。
- **使用的来源**：`raw/mmb_mineru/runs/us_yr13_us_yr13al__the_implications_of_financial_frictions_and_imperfect_knowledge_in_the_e__235aee23/full.md`。
- **经济体与版本**：估计的美国中等规模 Smets-Wouters 型 DSGE 模型，加入 Bernanke-Gertler-Gilchrist 金融加速器和适应性学习。MMB 实现文件将 `US_YR13` 标识为适应性学习版本。
- **核心主体**：家庭、带 Calvo 价格的垄断竞争中间品/最终品生产者、Calvo 工资设定者、竞争性资本品生产者、企业家、银行、财政当局和货币当局。
- **形式**：围绕去趋势变量的平稳稳态进行对数线性化。小写实现变量为对数偏离或增长归一化的实际变量。`.mod` 交叉检查使用 `model(linear)`。
- **来源范围**：论文详细给出资本品生产者、企业家/银行、货币政策、资源约束、观测方程和适应性学习机制。其余 Smets-Wouters 家庭、工资、价格和生产微观基础引用 Smets and Wouters (2007)；本文未完整重印的继承模块标为 `needs_review`。

## 2. Optimization Problems

### 资本品生产者

竞争性资本品生产者选择投资，以家庭边际效用作为随机贴现因子来最大化贴现实际利润：

\[
\max_{\{I_{t+s}\}} E_t\sum_{s=0}^{\infty}\beta^s
\frac{\lambda_{t+s}}{\lambda_t}
\left[
Q_{t+s} I_{t+s}\varepsilon^i_{t+s}
- I_{t+s}
- Q_{t+s} I_{t+s}\varepsilon^i_{t+s}
S\left(\frac{I_{t+s}}{I_{t+s-1}}\right)
\right].
\]

### 企业家和银行

企业家风险中性，以概率 \(\varkappa\) 存续，并在期末用净值和银行贷款购买资本：

\[
B_{t+1}=Q_tK_{t+1}-N_{t+1}.
\]

观察到个体生产率 \(\omega\) 后，企业家选择下一期利用率：

\[
\max_{U_{t+1}} \left[r^k_{t+1}U_{t+1}-a(U_{t+1})\right]\omega K_{t+1}.
\]

银行以无风险利率吸收家庭存款来融资贷款。最优债务合约包含监督成本，并生成取决于企业家财务状况的外部融资溢价。

### 家庭、价格设定者和工资设定者

论文说明非金融私人部门遵循 Smets and Wouters (2007)：家庭选择消费、劳动和债券头寸并有外部习惯；中间品厂商面临带指数化的 Calvo 价格摩擦；家庭或工会在 Calvo 工资摩擦下设定差异化工资。实现中使用的具体 Euler 方程、价格 Phillips 曲线和工资 Phillips 曲线标为继承 SW07 模块 `needs_review`，因为本文没有重印完整微观基础。

### 适应性学习预测问题

主体不知道理性预期约化形式。对每个前瞻变量 \(y^f_{j,t}\)，他们使用感知运动规律：

\[
y^f_{j,t}=\beta_{j,t-1}X_{j,t-1}+u_{j,t}.
\]

基准学习设定是每个预测变量带常数项的 AR(2) 模型。论文识别七个预测变量：消费、投资、工时、价格通胀、工资通胀、资本回报和资产价格。

## 3. First-Order Conditions

- **(F1) 资本品生产者的投资调整 FOC**：

\[
\varepsilon^i_t Q_t\left(1-S\left(\frac{I_t}{I_{t-1}}\right)\right)
=1+\varepsilon^i_t Q_tS'\left(\frac{I_t}{I_{t-1}}\right)\frac{I_t}{I_{t-1}}
-E_t\left[
\beta\frac{\lambda_{t+1}}{\lambda_t}\varepsilon^i_{t+1}Q_{t+1}
S'\left(\frac{I_{t+1}}{I_t}\right)
\left(\frac{I_{t+1}}{I_t}\right)^2
\right].
\]

- **(F2) 线性化投资方程**：

\[
\hat i_t=\frac{1}{1+\bar\beta\gamma}
\left(\hat i_{t-1}+\bar\beta\gamma E_t\hat i_{t+1}
+\frac{1}{\gamma^2S''}\hat Q_t\right)+\hat q_t.
\]

- **(F3) 资本积累**：

\[
\hat k_t=\left(1-\frac{i_\ast}{k_\ast}\right)\hat k_{t-1}
+\frac{i_\ast}{k_\ast}\hat i_t
+\frac{i_\ast}{k_\ast}(1+\bar\beta\gamma)\gamma^2S''\hat q_t.
\]

- **(F4) 利用率 FOC**：

\[
r^k_{t+1}=a'(U_{t+1}).
\]

- **(F5) 线性化资本利用率**：

\[
\hat u_t=\frac{1-\psi}{\psi}\hat r^k_t.
\]

- **(F6) 资本服务**：

\[
\hat k^S_{t+1}=\hat u_{t+1}+\hat k_{t+1}.
\]

- **(F7) 预期资本回报**：

\[
E_tR^k_{t+1}
=E_t\left[
\frac{r^k_{t+1}U_{t+1}-a(U_{t+1})+Q_{t+1}(1-\tau)}
{Q_t}
\right].
\]

- **(F8) 线性化预期资本回报**：

\[
E_t\hat R^K_{t+1}
=\frac{1-\tau}{\bar R^K}E_t\hat Q_{t+1}
+\frac{\bar r^k}{\bar R^K}E_t\hat r^k_{t+1}
-\hat Q_t.
\]

- **(F9) 外部融资溢价条件**：

\[
E_tR^k_{t+1}
=E_t\left[
s\left(\frac{N_{t+1}}{Q_tK_{t+1}}\right)\varepsilon^b_tR_t
\right].
\]

- **(F10) 线性化外部融资溢价**：

\[
E_t\hat R^K_{t+1}
=-el\left\{E_t\left[\hat N_{t+1}-\hat Q_t-\hat k_{t+1}\right]\right\}
+\hat R_t+\hat b_t.
\]

- **(F11) 企业家净值运动规律**：

\[
N_{t+1}
=\varkappa\left[
R^K_tQ_{t-1}K_t
-E_{t-1}R^K_t(Q_{t-1}K_t-N_t)
\right]+W^e_t.
\]

- **(F12) 线性化净值运动规律**：

\[
\hat N_{t+1}
=\varkappa\bar R^K\left[
\frac{\bar K}{\bar N}(\hat R^K_t-E_{t-1}\hat R^K_t)
+E_{t-1}\hat R^K_t+\hat N_t
\right].
\]

- **(F13) 含溢价组成的净值方程**：

\[
\hat N_{t+1}
=\varkappa\bar R^K\left[
\frac{\bar K}{\bar N}\hat R^K_t
-\left(\frac{\bar K}{\bar N}-1\right)(\hat R_{t-1}+\hat b_{t-1})
-el\left(\frac{\bar K}{\bar N}-1\right)(\hat k_t+\hat Q_{t-1}-\hat N_t)
+\hat N_t
\right].
\]

- **(F14) 线性化消费 Euler 方程，继承 SW07 模块，needs_review**：

\[
\hat c_t=a_c\hat c_{t-1}+(1-a_c)\,E_t\hat c_{t+1}
+a_l(\hat l_t-E_t\hat l_{t+1})
-a_r(\hat r_t-E_t\hat\pi_{t+1}+\hat b_t).
\]

- **(F15) 生产和边际成本关系，继承 SW07 模块，needs_review**：

\[
\hat y_t=\Phi\left[\alpha\hat k^S_t+(1-\alpha)\hat l_t+\hat a_t\right],
\qquad
\hat{mc}_t=\alpha\hat r^k_t+(1-\alpha)\hat w_t-\hat a_t.
\]

- **(F16) 价格 Phillips 曲线，继承 SW07 模块，needs_review**：

\[
\hat\pi_t=b_pE_t\hat\pi_{t+1}+i_p\hat\pi_{t-1}+k_p\hat{mc}_t+\hat\varepsilon^p_t.
\]

- **(F17) 工资 Phillips 曲线，继承 SW07 模块，needs_review**：

\[
\hat w_t=b_wE_t\hat w_{t+1}+i_w\hat w_{t-1}
+\chi_w\left(\sigma_l\hat l_t+\hat\lambda_t-\hat w_t\right)
+\text{inflation-indexation terms}+\hat\varepsilon^w_t.
\]

- **(F18) 货币政策规则**：

\[
\hat R^n_t=\rho_R\hat R^n_{t-1}
+(1-\rho_R)(r_\pi\hat\pi_t+r_y\widehat{ygap}_t)
+r_{\Delta y}(\widehat{ygap}_t-\widehat{ygap}_{t-1})
+\epsilon^r_t.
\]

- **(F19) 产出缺口近似**：

\[
\widehat{ygap}_t=\hat y_t-\hat A_t.
\]

- **(F20) 实际利率的 Fisher 关系**：

\[
\hat R_t=\hat R^n_t-E_t\hat\pi_{t+1}.
\]

## 4. Market Clearing & Identities

- **(F21) 资源约束**：

\[
\hat y_t
=\frac{(\bar R^K-1+\tau)k_\ast}{y_\ast}\hat u_t
+\hat\mu^{bank}_t
+\frac{c_\ast}{y_\ast}\hat c_t
+\frac{i_\ast}{y_\ast}\hat i_t
+\hat g_t.
\]

- **(F22) 资源约束中的银行利差贡献，needs_review OCR**：

\[
\hat\mu^{bank}_t
=\frac{k_\ast}{y_\ast}(\bar R^K-\bar R)\left(1-\frac{\bar N}{\bar K}\right)
(\hat R^K_t+\hat Q_{t-1}+\hat k_t).
\]

- **(F23) 贷款融资资本购买恒等式**：

\[
B_{t+1}=Q_tK_{t+1}-N_{t+1}.
\]

- **(F24) 来自实现交叉检查的年通胀恒等式**：

\[
\hat\pi^{(4)}_t=\frac{1}{4}\left(4\hat\pi_t+4\hat\pi_{t-1}+4\hat\pi_{t-2}+4\hat\pi_{t-3}\right).
\]

## 5. Exogenous Processes

- **(F25) 外生风险溢价冲击**：

\[
\hat b_t=\rho_b\hat b_{t-1}+\epsilon^b_t.
\]

- **(F26) 投资专有技术冲击**：

\[
\hat q_t=\rho_q\hat q_{t-1}+\epsilon^i_t.
\]

- **(F27) 带生产率联动的政府支出冲击**：

\[
\hat g_t=\rho_g\hat g_{t-1}+\rho_{ga}\epsilon^a_t+\epsilon^g_t.
\]

- **(F28) 生产率冲击**：

\[
\hat a_t=\rho_a\hat a_{t-1}+\epsilon^a_t.
\]

- **(F29) 带移动平均项的价格加成冲击**：

\[
\hat\varepsilon^p_t=\rho_p\hat\varepsilon^p_{t-1}+\eta^p_t-\mu_p\eta^p_{t-1}.
\]

- **(F30) 带移动平均项的工资加成冲击**：

\[
\hat\varepsilon^w_t=\rho_w\hat\varepsilon^w_{t-1}+\eta^w_t-\mu_w\eta^w_{t-1}.
\]

- **(F31) 货币政策冲击**：

\[
\epsilon^r_t=\eta^r_t.
\]

- **(F32) 学习的感知运动规律**：

\[
y^f_{j,t}=\beta_{j,t-1}X_{j,t-1}+u_{j,t}.
\]

- **(F33) Kalman 信念更新**：

\[
\beta_{t/t}=\beta_{t/t-1}+K_t\tilde z_t,
\qquad
P_{t/t}=(I-K_tX_{t-1})P_{t/t-1}.
\]

- **(F34) 信念预测规律**：

\[
(\beta_t-\bar\beta)=F(\beta_{t-1}-\bar\beta)+v_t.
\]

- **(F35) 学习下的实际运动规律**：

\[
\begin{bmatrix}y_t\\w_t\end{bmatrix}
=\mu_t+T_t\begin{bmatrix}y_{t-1}\\w_{t-1}\end{bmatrix}+R_t\epsilon_t.
\]

## 6. Steady-State Solution

论文说明，非线性系统先用确定性的劳动增强型增长率 \(\gamma\) 去趋势，然后围绕去趋势变量的平稳稳态线性化。归档中稳态重建为 `needs_review`，因为论文没有给出完整且自洽的稳态算法。

- 在线性化平稳系统中令所有带帽变量和创新为零。
- 投资方程使用的贴现对象是 \(\bar\beta=\beta/\gamma^{\sigma_c}\)。
- 稳态资本回报和租金进入 (F8)，金融摩擦模块取决于 \(\bar K/\bar N\)、\(\varkappa\) 和 \(el\)。
- 模型在观测方程中分别估计产出、消费、投资和工资增长趋势，而不是对全部实际序列施加一个共同观测趋势。
- 实现交叉检查：`US_YR13_rep.mod` 在进入线性模型块前计算 `cgamma`、`cbetabar`、`cr`、`crk`、`cw`、`cik`、`cky`、`ciy`、`ccy`、`crkky`、`cwhlc` 和 `cwly` 等派生稳态参数。

## 7. Timing & Form Conventions

- **资本时序**：企业家在期末购买 \(K_{t+1}\)；下一期的安装资本服务使用利用率 \(U_{t+1}\)。实现中生产资本写作带滞后的物理资本加利用率。
- **净值时序**：\(N_{t+1}\) 由较早签订合约的已实现和预期回报决定；(F12) 和 (F13) 包含 \(E_{t-1}\hat R^K_t\)。
- **预期**：理性预期下，前瞻项使用模型一致的 \(E_t\)。适应性学习下，七个前瞻变量通过 PLM (F32) 预测，经 Kalman 滤波 (F33) 更新，并代入结构系统。
- **形式**：MMB 实现中为 `model(linear)`；所有带帽变量都是相对于平稳去趋势稳态的偏离。
- **运行验证**：未执行。

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII cross-check | Meaning | Main equation |
|---|---|---|---|
| Endogenous | \(\hat c_t\) / `c` | 消费 | (F14) |
| Endogenous | \(\hat i_t\) / `inve` | 投资 | (F2) |
| Endogenous | \(\hat y_t\) / `y` | 产出 | (F21) |
| Endogenous | \(\hat l_t\) / `lab` | 工时/劳动 | (F15), (F17) |
| Endogenous | \(\hat\pi_t\) / `pinf` | 通胀 | (F16) |
| Endogenous | \(\hat w_t\) / `w` | 实际工资 | (F17) |
| Endogenous | \(\hat R^n_t\) / `r` in implementation | 政策利率 | (F18) |
| Endogenous | \(\hat R_t\) / `rr` or real-rate object | 无风险实际利率 | (F20) |
| Endogenous | \(\hat Q_t\) / `pk` | 资产价格 / Tobin's Q | (F1), (F8) |
| Endogenous | \(\hat k_t\) / `k`, `kp` | 物理资本 | (F3) |
| Endogenous | \(\hat u_t\) / `zcap` | 利用率 | (F5) |
| Endogenous | \(\hat k^S_t\) | 资本服务 | (F6) |
| Endogenous | \(\hat r^k_t\) / `rk` | 资本租金/回报 | (F4), (F8) |
| Endogenous | \(\hat N_t\) / `nw` | 企业家净值 | (F12), (F13) |
| Endogenous | `prem` | 外部融资溢价 | (F10) |
| Endogenous | `pinf4` | 年通胀恒等式 | (F24) |
| Endogenous | `ewma`, `epinfma`, `spinf`, `sw` | 加成冲击辅助变量 | (F29), (F30) |
| Exogenous | \(\epsilon^a_t\) / `ea` | 生产率创新 | (F28) |
| Exogenous | \(\epsilon^b_t\) / `eb` | 外生风险溢价创新 | (F25) |
| Exogenous | \(\epsilon^i_t\) / `eqs` | 投资专有创新 | (F26) |
| Exogenous | \(\epsilon^g_t\) / `eg` | 政府支出创新 | (F27) |
| Exogenous | \(\eta^p_t\) / `epinf` | 价格加成创新 | (F29) |
| Exogenous | \(\eta^w_t\) / `ew` | 工资加成创新 | (F30) |
| Exogenous | \(\eta^r_t\) / `em` | 货币政策创新 | (F31) |
| Parameter | \(\beta\), `cbeta`, `cbetabar` | 家庭贴现和趋势调整贴现 | (F1), (F2) |
| Parameter | \(\gamma\), `cgamma` | 确定性趋势增长 | (F2), section 6 |
| Parameter | \(S''\), `csadjcost` | 投资调整成本曲率 | (F2), (F3) |
| Parameter | \(\tau\), `ctou` | 折旧 | (F7), (F8) |
| Parameter | \(\psi\), `czcap` | 利用率成本弹性对象 | (F5) |
| Parameter | \(\varkappa\), `cv` | 企业家存续率 | (F11), (F12) |
| Parameter | \(\bar K/\bar N\), `clev` | 资本净值比 | (F12), (F13) |
| Parameter | \(el\), `elast` | 溢价弹性 | (F10), (F13) |
| Parameter | \(\rho_R,r_\pi,r_y,r_{\Delta y}\) | 货币政策规则 | (F18) |
| Parameter | shock persistence and MA parameters | AR 和 MA 冲击系数 | (F25)-(F31) |
| Parameter | learning gain \(\rho\) / `ro` | 信念持久性参数 | (F34) |
