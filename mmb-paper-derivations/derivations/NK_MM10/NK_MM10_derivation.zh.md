# NK_MM10 -- 推导（最优化问题 + 均衡条件）

> `NK_MM10` 的模型档案条目。状态：`needs_review`。未执行运行时验证；未运行 Dynare。

来源：Cesaire A. Meh 和 Kevin Moran (2010), "The role of bank capital in the propagation of shocks," *Journal of Economic Dynamics and Control* 34(3), 555-576. DOI: `10.1016/j.jedc.2009.10.009`。

## 1. Model Overview

- **模型**：`NK_MM10`，一个包含银行资本、企业家净值、资本品生产中的双重道德风险、粘性价格、粘性工资、习惯形成、货币/存款、可变资本利用率和 Taylor 型货币政策规则的中等规模新凯恩斯 DSGE 模型。
- **主体与模块**：家庭、企业家、银行家、中间品厂商、最终品厂商、劳动聚合商和货币当局。
- **金融摩擦**：企业家需要外部融资来运行资本品项目。银行监控企业家，但监控有成本且不可公开观察。因此银行资本缓解了银行与提供存款的家庭之间的道德风险。
- **冲击**：总技术冲击、货币政策冲击，以及通过银行资产加速折旧进入的外生银行资本冲击。
- **形式**：论文给出非线性均衡条件，并说明动态解由围绕确定性稳态的线性化得到。MMB 实现交叉检查是一个非线性 Dynare `model`，以一阶近似求解，不是 `model(linear)`。
- **来源质量**：MinerU Markdown 的核心方程可读，但方程 (4), (7)-(10), (13), (27) 和工资设定表达式中的若干上下标存在 OCR 噪声。使用这些公式时标记为 `needs_review`。

## 2. Optimization Problems

### 2.1 最终品厂商

竞争性最终品厂商聚合差异化中间品：

\[
Y_t=\left(\int_0^1 y_{jt}^{(\xi_p-1)/\xi_p}\,dj\right)^{\xi_p/(\xi_p-1)},\qquad \xi_p>1.
\]

### 2.2 中间品厂商

中间品厂商 \(j\) 在固定成本生产技术约束下最小化生产成本：

\[
\min_{\{k_{jt},h_{jt},h^e_{jt},h^b_{jt}\}}
r_t k_{jt}+w_t h_{jt}+w^e_t h^e_{jt}+w^b_t h^b_{jt}
\]

约束为：

\[
y_{jt}=z_t k_{jt}^{\theta_k}h_{jt}^{\theta_h}(h^e_{jt})^{\theta_e}(h^b_{jt})^{\theta_b}-\Theta.
\]

厂商处于垄断竞争，并面对带有滞后通胀指数化的 Calvo 型价格设定。

### 2.3 企业家、银行与家庭之间的金融合约

具有净值 \(n_t\) 的企业家希望开展规模为 \(i_t>n_t\) 的项目。银行投入自身净值 \(a_t\)，并筹集家庭存款 \(d_t\)。合约选择：

\[
\max_{\{i_t,a_t,d_t,R^e_t,R^b_t,R^h_t\}}
q_t\alpha^g R^e_t i_t
\]

约束包括企业家激励相容、银行监控激励相容、银行和家庭参与约束、融资可行性以及收益分配：

\[
q_t\alpha^g R^e_t i_t \ge q_t\alpha^b R^e_t i_t+q_t b i_t,
\]

\[
q_t\alpha^g R^b_t i_t-\mu i_t \ge q_t\alpha^b R^b_t i_t,
\]

\[
q_t\alpha^g R^b_t i_t \ge (1+r^a_t)a_t,\qquad
q_t\alpha^g R^h_t i_t \ge (1+r^d_t)d_t,
\]

\[
a_t+d_t-\mu i_t \ge i_t-n_t,\qquad
R^e_t+R^b_t+R^h_t=R.
\]

### 2.4 家庭

家庭最大化带有外部习惯、劳动负效用和实际货币服务的期望效用：

\[
E_0\sum_{t=0}^{\infty}\beta^t
U(c^h_t-\gamma c^h_{t-1},l_{it},M^c_t/P_t).
\]

家庭在存款和现金之间配置货币，选择资本利用率，购买资本品，供给差异化劳动，并面对预算约束：

\[
c^h_t+q_t i^h_t+\frac{M_{t+1}}{P_t}
=(1+r^d_t)\frac{D_t}{P_t}+r_tu_tk^h_t-v(u_t)k^h_t
\frac{W_{it}}{P_t}l_{it}+\Pi_t+\frac{M^c_t}{P_t}.
\]

家庭资本演化为：

\[
k^h_{t+1}=(1-\delta)k^h_t+i^h_t.
\]

### 2.5 工资设定者

劳动聚合商组合家庭的专业化劳动：

\[
H_t=\left(\int_0^{\eta^h}l_{it}^{(\xi_w-1)/\xi_w}\,di\right)^{\xi_w/(\xi_w-1)}.
\]

家庭以概率 \(1-\phi_w\) 重新优化名义工资，否则工资按滞后通胀指数化。

### 2.6 企业家和银行家

企业家和银行家为风险中性。每期有比例 \(1-\tau^e\) 和 \(1-\tau^b\) 退出。存活主体保留全部收益作为下一期资产；退出主体消费积累财富。

## 3. First-Order Conditions

下列条件是论文侧均衡条件，并被规范为单一连续档案编号。显式标记为 `needs_review` 的项目需要根据 PDF 做源级公式核查，因为 OCR 中有可见数学噪声。

- **(F1) 最终品对中间品品种的需求**：

\[
y_{jt}=\left(\frac{p_{jt}}{P_t}\right)^{-\xi_p}Y_t.
\]

- **(F2) 最终品价格指数**：

\[
P_t=\left(\int_0^1 p_{jt}^{1-\xi_p}\,dj\right)^{1/(1-\xi_p)}.
\]

- **(F3) 中间品生产技术，OCR 上标需 `needs_review`**：

\[
y_{jt}=z_t k_{jt}^{\theta_k}h_{jt}^{\theta_h}(h^e_{jt})^{\theta_e}(h^b_{jt})^{\theta_b}-\Theta.
\]

- **(F4) 技术过程**：

\[
\log z_t=\rho_z\log z_{t-1}+\varepsilon^z_t.
\]

- **(F5) 资本租赁需求**：

\[
r_t=s_t z_t\theta_k k_{jt}^{\theta_k-1}h_{jt}^{\theta_h}(h^e_{jt})^{\theta_e}(h^b_{jt})^{\theta_b}.
\]

- **(F6) 家庭劳动需求**：

\[
w_t=s_t z_t\theta_h k_{jt}^{\theta_k}h_{jt}^{\theta_h-1}(h^e_{jt})^{\theta_e}(h^b_{jt})^{\theta_b}.
\]

- **(F7) 企业家劳动需求，OCR 指数位置需 `needs_review`**：

\[
w^e_t=s_t z_t\theta_e k_{jt}^{\theta_k}h_{jt}^{\theta_h}(h^e_{jt})^{\theta_e-1}(h^b_{jt})^{\theta_b}.
\]

- **(F8) 银行家劳动需求**：

\[
w^b_t=s_t z_t\theta_b k_{jt}^{\theta_k}h_{jt}^{\theta_h}(h^e_{jt})^{\theta_e}(h^b_{jt})^{\theta_b-1}.
\]

- **(F9) 未重新优化厂商的指数化价格路径**：

\[
p_{j,t+k}=\left(\prod_{s=0}^{k-1}\pi_{t+s}\right)p_{jt}.
\]

- **(F10) 最优重置价格，OCR 中的符号/加成约定需 `needs_review`**：

\[
\tilde p_t=
\frac{\xi_p}{\xi_p-1}
\frac{E_t\sum_{k=0}^{\infty}(\beta\phi_p)^k\lambda_{t+k}s_{t+k}Y_{t+k}\pi_{t+k}^{\xi_p}}
{E_t\sum_{k=0}^{\infty}(\beta\phi_p)^k\lambda_{t+k}Y_{t+k}\pi_{t+k}^{\xi_p-1}}.
\]

- **(F11) 企业家激励相容的项目收益份额**：

\[
R^e_t=\frac{b}{\Delta\alpha},\qquad \Delta\alpha=\alpha^g-\alpha^b>0.
\]

- **(F12) 银行监控激励相容的项目收益份额**：

\[
R^b_t=\frac{\mu}{q_t\Delta\alpha}.
\]

- **(F13) 家庭存款人的项目收益份额**：

\[
R^h_t=R-\frac{b}{\Delta\alpha}-\frac{\mu}{q_t\Delta\alpha}.
\]

- **(F14) 家庭参与项目融资**：

\[
(1+r^d_t)d_t=q_t\alpha^g
\left(R-\frac{b}{\Delta\alpha}-\frac{\mu}{q_t\Delta\alpha}\right)i_t.
\]

- **(F15) 合约的融资可行性形式**：

\[
(1+r^d_t)\left[(1+\mu)-\frac{a_t}{i_t}-\frac{n_t}{i_t}\right]
=q_t\alpha^g\left(R-\frac{b}{\Delta\alpha}-\frac{\mu}{\Delta\alpha q_t}\right).
\]

- **(F16) 项目规模 / 总投资供给**：

\[
i_t=\frac{a_t+n_t}{G_t},\qquad
G_t=1+\mu-\frac{q_t\alpha^g}{1+r^d_t}
\left(R-\frac{b}{\Delta\alpha}-\frac{\mu}{\Delta\alpha q_t}\right)
\,\,\text{needs_review}.
\]

- **(F17) 资本资产比率，分母 OCR 需 `needs_review`**：

\[
\kappa_t=\frac{a_t}{a_t+d_t}.
\]

- **(F18) 家庭财富边际效用**：

\[
U_1(\cdot_t)-\beta\gamma E_tU_1(\cdot_{t+1})=\lambda_t.
\]

- **(F19) 现金/存款边际条件**：

\[
U_3(\cdot_t)=r^d_t\lambda_t.
\]

- **(F20) 资本利用率 FOC**：

\[
r_t=v'(u_t).
\]

- **(F21) 名义存款 Euler 方程**：

\[
\lambda_t=\beta E_t\left[\lambda_{t+1}(1+r^d_{t+1})\frac{P_t}{P_{t+1}}\right].
\]

- **(F22) 家庭资本 Euler 方程**：

\[
\lambda_t q_t=\beta E_t\left\{\lambda_{t+1}
\left[q_{t+1}(1-\delta)+r_{t+1}u_{t+1}-v(u_{t+1})\right]\right\}.
\]

- **(F23) 专业化劳动需求**：

\[
l_{it}=\left(\frac{W_{it}}{W_t}\right)^{-\xi_w}H_t.
\]

- **(F24) 总工资指数**：

\[
W_t=\left(\int_0^{\eta^h}W_{it}^{1-\xi_w}\,di\right)^{1/(1-\xi_w)}.
\]

- **(F25) 最优重置工资，OCR 和符号约定需 `needs_review`**：

\[
\tilde W_t=P_{t-1}\frac{\xi_w}{\xi_w-1}
\frac{E_t\sum_{k=0}^{\infty}(\beta\phi_w)^k U_2(\cdot_{t+k})H_{t+k}w_{t+k}^{\xi_w}\pi_{t+k}^{\xi_w}}
{E_t\sum_{k=0}^{\infty}(\beta\phi_w)^k\lambda_{t+k}w_{t+k}^{\xi_w}\pi_{t+k}^{\xi_w-1}}.
\]

- **(F26) 企业家净值**：

\[
n_t=[r_t+q_t(1-\delta)]k^e_t+w^e_t.
\]

- **(F27) 银行家净值**：

\[
a_t=[r_t+q_t(1-\delta)]k^b_t+w^b_t.
\]

- **(F28) 货币政策规则**：

\[
r^d_t=(1-\rho_r)r^d+\rho_r r^d_{t-1}
+(1-\rho_r)\left[\rho_{\pi}(\pi_t-\bar\pi)+\rho_y\hat y_t\right]
+\varepsilon^{mp}_t.
\]

- **(F29) 由银行和企业家总净值决定的总投资**：

\[
I_t=\frac{A_t+N_t}{G_t}.
\]

- **(F30) 银行净值的总回报**：

\[
1+r^a_t=\frac{q_t\alpha^g R^b_t I_t}{A_t}.
\]

- **(F31) 企业家总净值**：

\[
N_t=[r_t+q_t(1-\delta)]K^e_t+\eta^e w^e_t.
\]

- **(F32) 银行总净值**：

\[
A_t=[r_t+q_t(1-\delta)]K^b_t+\eta^b w^b_t.
\]

- **(F33) 企业家资本持有演化**：

\[
K^e_{t+1}=\tau^e\alpha^g R^e_t I_t.
\]

- **(F34) 银行家资本持有演化**：

\[
K^b_{t+1}=\tau^b\alpha^g R^b_t I_t.
\]

- **(F35) 企业家净值运动方程**：

\[
N_{t+1}=[r_{t+1}+q_{t+1}(1-\delta)]
\tau^e\alpha^g R^e_t\left(\frac{A_t+N_t}{G_t}\right)
+\eta^e w^e_{t+1}.
\]

- **(F36) 银行净值运动方程**：

\[
A_{t+1}=[r_{t+1}+q_{t+1}(1-\delta)]
\tau^b\alpha^g R^b_t\left(\frac{A_t+N_t}{G_t}\right)
+\eta^b w^b_{t+1}.
\]

- **(F37) 企业家消费**：

\[
C^e_t=(1-\tau^e)q_t\alpha^gR^e_tI_t.
\]

- **(F38) 银行家消费**：

\[
C^b_t=(1-\tau^b)q_t\alpha^gR^b_tI_t.
\]

- **(F39) 家庭总消费**：

\[
C^h_t=\eta^h c^h_t.
\]

- **(F40) 银行资本冲击变体**：

\[
A_t=[r_t+q_t(1-\delta x_t)]K^b_t+\eta^b w^b_t.
\]

## 4. Market Clearing & Identities

- **(F41) 总资本存量**：

\[
K_t=K^h_t+K^e_t+K^b_t.
\]

- **(F42) 资本服务市场出清**：

\[
u_tK^h_t+K^e_t+K^b_t=\int_0^1 k_{jt}\,dj.
\]

- **(F43) 复合家庭劳动市场出清**：

\[
H_t=\int_0^1 h_{jt}\,dj.
\]

- **(F44) 总资源约束**：

\[
Y_t=C^h_t+C^e_t+C^b_t+I_t+\mu I_t.
\]

- **(F45) 总资本积累**：

\[
K_{t+1}=(1-\delta)K_t+\alpha^g R I_t.
\]

- **(F46) 存款市场出清**：

\[
\eta^b d_t=\eta^h\frac{D_t}{P_t}.
\]

- **(F47) 货币市场出清**：

\[
\bar M_t=\eta^h M_t.
\]

- **(F48) 带固定成本的总产出恒等式，价格分散聚合需 `needs_review`**：

\[
Y_t=z_t K_t^{\theta_k}H_t^{\theta_h}(\eta^e)^{\theta_e}(\eta^b)^{\theta_b}-\Theta.
\]

- **(F49) 实现中的银行资本充足率**：

\[
CA_t=\frac{A_t}{(1+\mu)I_t-N_t}.
\]

- **(F50) 总银行贷款**：

\[
TL_t=I_t-N_t.
\]

- **(F51) 总消费**：

\[
C_t=C^h_t+C^e_t+C^b_t.
\]

## 5. Exogenous Processes

- **(F52) 技术冲击**：

\[
\log z_t=\rho_z\log z_{t-1}+\varepsilon^z_t.
\]

- **(F53) 货币政策扰动**：

\[
\varepsilon^{mp}_t=\rho_{mp}\varepsilon^{mp}_{t-1}+u^{mp}_t.
\]

- **(F54) 银行资本折旧扰动**：

\[
x_t=\rho_x x_{t-1}+u^x_t.
\]

MMB 实现交叉检查将三个创新命名为 `z_shk`、`mp_shk` 和 `bk_shk`，并将其对数状态变量写为 `lz`、`lmp` 和 `lbk`。这些命名仅作为实现证据。

## 6. Steady-State Solution

确定性稳态按季度频率规范化，设 \(u=1\)、\(z=1\) 且总通胀 \(\bar\pi\) 为常数。论文将剩余金融合约参数校准到若干稳态比率，MMB 实现明确计算这些比率。

1. 设定外生稳态：

\[
\bar z=1,\qquad \bar x=0,\qquad \varepsilon^z=\varepsilon^{mp}=u^x=0.
\]

2. 家庭跨期定价给出：

\[
1+\bar r^d=\frac{\bar\pi}{\beta}.
\]

3. 资本利用率规范化为 \(\bar u=1\)，利用率成本函数校准为：

\[
\bar r=v'(1).
\]

4. 生产侧校准设定稳态加成：

\[
\bar s=\frac{1}{\text{gross price markup}},\qquad
\bar Y=\bar z\,\bar K^{\theta_k}\bar H^{\theta_h}(\eta^e)^{\theta_e}(\eta^b)^{\theta_b}-\Theta.
\]

5. 金融合约由下式确定项目规模和杠杆：

\[
\bar I=\frac{\bar A+\bar N}{\bar G},\qquad
\bar G=1+\mu-\frac{\bar q\alpha^g}{1+\bar r^d}
\left(R-\frac{b}{\Delta\alpha}-\frac{\mu}{\Delta\alpha\bar q}\right)
\,\,\text{needs_review}.
\]

6. 基准校准目标包括：

\[
\bar\kappa=0.14,\qquad \bar I/\bar N=2.0,\qquad \bar I/\bar Y=0.2,\qquad \bar K/\bar Y\approx 12.
\]

7. 总资本在稳态中满足：

\[
\delta\bar K=\alpha^g R\bar I.
\]

8. 企业家和银行家资本持有满足：

\[
\bar K^e=\tau^e\alpha^g\bar R^e\bar I,\qquad
\bar K^b=\tau^b\alpha^g\bar R^b\bar I.
\]

9. 企业家和银行家消费为：

\[
\bar C^e=(1-\tau^e)\bar q\alpha^g\bar R^e\bar I,\qquad
\bar C^b=(1-\tau^b)\bar q\alpha^g\bar R^b\bar I.
\]

10. 家庭消费封闭资源约束：

\[
\bar C^h=\bar Y-\bar C^e-\bar C^b-\bar I-\mu\bar I.
\]

该稳态模块为 `draft_extracted`：论文给出校准目标，实现提供显式计算顺序，但未执行 Dynare 运行或独立稳态残差检查。

## 7. Timing & Form Conventions

- 一个模型期为一个季度。
- 总冲击在期初、生产和融资决策之前实现。
- 资本存量 \(K^h_t\)、\(K^e_t\) 和 \(K^b_t\) 是生产/使用决策中的期初持有量；总资本积累将第 \(t\) 期投资映射到 \(K_{t+1}\)。
- 银行和企业家净值来自留存收益，并影响下一轮融资；这种迟缓调整是传播机制的核心。
- 价格和工资采用带有滞后通胀指数化的 Calvo 型不重新优化机制。
- 模型在论文侧均衡形式中是非线性的，并围绕稳态线性化求解。本地 MMB `.mod` 交叉检查实现非线性 model 块并请求一阶 `stoch_simul`；本档案条目未运行 Dynare。
- 实现交叉检查中的存量变量在生产中使用滞后资本（`K(-1)`、`Ke(-1)`、`Kb(-1)`），并使用当期净值变量进行融资。

## 8. Variable & Parameter Reference Table

| 类别 | 符号 / ASCII | 含义 | 主要方程 |
|---|---|---|---|
| 内生 | \(Y_t\) / `Y` | 最终产出 | (F1), (F44), (F48) |
| 内生 | \(y_{jt}\) | 中间品品种产出 | (F1), (F3) |
| 内生 | \(P_t,\pi_t\) / `infl` | 价格水平和总通胀 | (F2), (F9), (F10), (F28) |
| 内生 | \(\tilde p_t\) / `ptilde` | 重置价格 | (F10) |
| 内生 | \(s_t\) / `s` | 实际边际成本 | (F5)-(F8), (F10) |
| 内生 | \(K_t,K^h_t,K^e_t,K^b_t\) / `K`, `Ke`, `Kb` | 总资本和部门资本 | (F33), (F34), (F41), (F45) |
| 内生 | \(u_t\) / `u` | 资本利用率 | (F20), (F42) |
| 内生 | \(H_t,l_{it}\) / `H` | 复合劳动和专业化劳动 | (F23), (F24), (F43) |
| 内生 | \(w_t,w^e_t,w^b_t\) / `w_h`, `w_e`, `w_b` | 家庭、企业家和银行家工资 | (F6)-(F8), (F25) |
| 内生 | \(q_t\) / `q` | 资本品相对价格 | (F15), (F16), (F22), (F31)-(F40) |
| 内生 | \(I_t\) / `I` | 总资本品投资 | (F29), (F44), (F45) |
| 内生 | \(A_t,N_t\) / `bigA`, `bigN` | 银行和企业家净值 | (F31), (F32), (F35), (F36), (F40) |
| 内生 | \(G_t\) / `G` | 金融合约中的逆杠杆 | (F16), (F29) |
| 内生 | \(\kappa_t\) / `CA` | 资本资产比率 | (F17), (F49) |
| 内生 | \(d_t,D_t\) / `smalld` | 银行存款 / 家庭存款资金 | (F14), (F46) |
| 内生 | \(R^e_t,R^b_t,R^h_t\) | 合约收益份额 | (F11)-(F13) |
| 内生 | \(C^h_t,C^e_t,C^b_t,C_t\) / `ch`, `Ce`, `Cb`, `totC` | 家庭、企业家、银行家和总消费 | (F37)-(F39), (F44), (F51) |
| 内生 | \(\lambda_t\) / `lam` | 财富边际效用 | (F18), (F21), (F22) |
| 内生 | \(r_t,r^d_t,r^a_t\) / `rk`, `Rd`, `Ra` | 租赁率、名义存款/政策利率、银行资本回报 | (F20), (F21), (F28), (F30) |
| 内生 | \(M_t,M^c_t\) / `p`, `mc` | 货币和现金相关变量 | (F19), (F47) |
| 内生 | \(TL_t\) / `TL` | 总银行贷款 | (F50) |
| 外生 | \(\varepsilon^z_t\) / `z_shk` | 技术创新 | (F4), (F52) |
| 外生 | \(u^{mp}_t\) / `mp_shk` | 货币政策创新 | (F28), (F53) |
| 外生 | \(u^x_t\) / `bk_shk` | 银行资本冲击创新 | (F40), (F54) |
| 参数 | \(\beta,\gamma,\psi,\zeta\) / `bet`, `habit`, `psi_l`, `reta` | 偏好、习惯和货币效用 | (F18)-(F22) |
| 参数 | \(\xi_p,\phi_p,\xi_w,\phi_w\) | 价格/工资弹性和 Calvo 概率 | (F1), (F2), (F9), (F10), (F23)-(F25) |
| 参数 | \(\theta_k,\theta_h,\theta_e,\theta_b,\Theta\) | 生产份额和固定成本 | (F3), (F5)-(F8), (F48) |
| 参数 | \(\alpha^g,\alpha^b,\Delta\alpha,R,b,\mu\) / `alphag`, `delalpha`, `bigR`, `smallb`, `mu` | 金融合约技术和道德风险参数 | (F11)-(F17), (F29) |
| 参数 | \(\tau^e,\tau^b\) / `tau_e`, `tau_b` | 存活/留存概率 | (F33)-(F38) |
| 参数 | \(\rho_r,\rho_\pi,\rho_y\) / `lam_r`, `lam_pi`, `lam_y` | 货币政策系数 | (F28) |
| 参数 | \(\rho_z,\rho_{mp},\rho_x\) / `rhoz`, `rhomp`, `rhobk` | 冲击持久性 | (F52)-(F54) |
