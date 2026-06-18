# BRA_SAMBA08 - SAMBA：采用贝叶斯方法的随机分析模型

来源信息：`BRA_SAMBA08`，Gouvea、Minella、Santos 和 Souza-Sobrinho，2008 模型行；主要论文来源为 Banco Central do Brasil Working Paper 239，"SAMBA: Stochastic Analytical Model with a Bayesian Approach"，2011 年 4 月/6 月。MMB 索引中的 DOI：`10.12660/bre.v35n22015.57573`。来源 Markdown：`raw/mmb_mineru/runs/bra_samba08__samba_stochastic_analytical_model_with_a_bayesian_approach__8681ba38/full.md`。原始 PDF 路径已存在：`raw/mmb_papers/Stochastic analytical model with a bayesian approach 2011.pdf`。MinerU run ids：`8681ba38-3d6a-453b-8229-c524e9fde18e`；次要匹配 run `c6e497b6-b09e-4a9e-9c91-8b913af49f93`。

状态：`needs_review`。MMB 索引标记了标题/来源日期不一致：模型行为 `BRA_SAMBA08`，但主要来源标题是 "Stochastic analytical model with a bayesian approach 2011"。以下提取使用论文侧 Markdown 和论文附录中的对数线性系统；MMB `.mod` 仅作为实现交叉核对。

## 1. Model Overview

SAMBA 是面向巴西的中等规模小型开放经济 DSGE 模型。模型包含优化型家庭和即期消费家庭、工资刚性、分部门价格刚性、管制价格、国内和进口生产投入、进口的外部融资、不完全国际资产市场、遵循基本盈余规则的财政当局，以及遵循前瞻性 Taylor 规则的货币当局。

论文给出了非线性问题、平衡增长路径下的平稳系统、确定性稳态关系，以及用于估计的对数线性模型。MMB 实现交叉核对文件使用 `model(linear)`，因此本条目将对数线性均衡记录为操作性模型形式，同时保留优化问题和非线性/BGP 来源信息。

主要主体和模块：

- 优化型家庭选择消费、国内债券、国外债券、资本、投资和工资。
- 即期消费家庭消费当期税后劳动收入。
- 国内投入生产者使用资本和劳动。
- 进口商在 Calvo 刚性下设定本币进口价格。
- 分部门中间品生产者组合国内和进口投入，生产消费、政府、投资和出口品。
- 消费品分为自由定价和管制定价部分。
- 政府遵循财政和货币政策规则。
- 外国产出、外国价格、外国利率、进口价格和投资者风险厌恶是外生过程。

## 2. Optimization Problems

优化型家庭问题：

```math
\max_{\{C_{j,t},B_{j,t+1},B^{\ast}_{j,t+1},K_{j,t+1},I_{j,t}\}}
E_0\sum_{t=0}^{\infty}\beta^t u(C_{j,t},N_{j,t})
```

约束包括名义流量预算约束、资本积累和工资设定约束。效用包含外部习惯和劳动负效用项：

```math
u(C_{j,t},N_{j,t})
=Z_t^C\left[
\frac{(C_{j,t}-\kappa C^O_{t-1})^{1-\sigma}}{1-\sigma}
-Z_t^{1-\sigma}\frac{\psi}{1+\eta}N_{j,t}^{1+\eta}
\right].
```

即期消费家庭约束：

```math
C^{RT}_t=(1-T_t)W_tN_t.
```

国内投入生产者成本最小化：

```math
\min_{\{K_t,N_t\}}\; R_t^{K,n}K_t+W_t^nN_t
\quad\text{s.t.}\quad
Y_t^D=Z_t^D K_t^\alpha\bigl(Z_t(N_t-\bar N)\bigr)^{1-\alpha}.
```

进口商和分部门生产者求解 Calvo 定价问题。对部门品 $`H\in\{C,I,G,X\}`$，部门组装商使用 Dixit-Stiglitz 聚合器，中间品企业组合国内和进口投入。出口价格以外币设定。管制价格企业不优化价格，而是根据滞后 CPI 通胀、实际汇率变动、边际成本、自由定价价格和管制价格冲击进行更新。

## 3. First-Order Conditions

下列方程是论文用于估计的对数线性系统，符号与附录 C 对齐，并与 MMB `model(linear)` 实现交叉核对。标记为 `needs_review` 的方程包含 OCR 敏感符号，或包含论文到 MMB 简化版本之间需要后续核对的部分。

- **(F1) 优化型家庭消费 Euler 方程**:

```math
c_t^O=\frac{\tilde\kappa}{1+\tilde\kappa}c_{t-1}^O
+\frac{1}{1+\tilde\kappa}E_tc_{t+1}^O
-\frac{1-\tilde\kappa}{\sigma(1+\tilde\kappa)}
\left(r_t+s_t^B-E_t\pi_{t+1}^C\right)
+\frac{\rho_Z-\tilde\kappa}{1+\tilde\kappa}z_t^Z
-\frac{(1-\rho_C)(1-\tilde\kappa)}{\sigma(1+\tilde\kappa)}z_t^C.
```

- **(F2) 即期消费家庭消费**:

```math
c_t^{RT}=w_t+n_t-\frac{T}{1-T}\tau_t.
```

- **(F3) 总消费**:

```math
c_t=\tilde\varpi_C c_t^{RT}+(1-\tilde\varpi_C)c_t^O.
```

- **(F4) 实际汇率 UIP 条件**:

```math
q_t=E_tq_{t+1}-(r_t+s_t^B-E_t\pi_{t+1}^C)
+(r_t^{\ast}+s_t^{B^{\ast}}-E_t\pi_{t+1}^{C^{\ast}})+z_t^Q.
```

- **(F5) 资本影子价值**:

```math
q_t^K=\tilde\beta\frac{1-\delta}{Z^Z}E_tq_{t+1}^K
+\left(1-\tilde\beta\frac{1-\delta}{Z^Z}\right)E_tr_{t+1}^K
-(r_t+s_t^B-E_t\pi_{t+1}^C).
```

- **(F6) 投资 Euler 方程**:

```math
i_t=\frac{1}{1+\tilde\beta}i_{t-1}
+\frac{\tilde\beta}{1+\tilde\beta}E_ti_{t+1}
+\frac{q_t^K-q_t^I}{\vartheta_I(Z^Z)^2(1+\tilde\beta)}
-\frac{1-\rho_I\tilde\beta}{1+\tilde\beta}z_t^Z
+\frac{1-\rho_I\tilde\beta}{1+\tilde\beta}z_t^I.
```

- **(F7) 资本积累**:

```math
k_{t+1}=\frac{1-\delta}{Z^Z}(k_t-z_t^Z)
+\left(1-\frac{1-\delta}{Z^Z}\right)i_t.
```

- **(F8) 国家风险溢价**:

```math
s_t^{B^{\ast}}=-\varphi_B^{\ast} b_{t+1}^{\asty}+\varphi_V^{\ast}v_t^{\ast}+z_t^{B^{\ast}}.
```

- **(F9) 国内风险溢价**:

```math
s_t^B=\rho_Bs_{t-1}^B+\varepsilon_t^B.
```

- **(F10) 工资 Phillips 曲线**:

```math
\Delta w_t=\frac{\omega_W}{1+\tilde\beta\omega_W}\Delta w_{t-1}
+\frac{\tilde\beta}{1+\tilde\beta\omega_W}E_t\Delta w_{t+1}
+\lambda_W(mrs_t-w_t)+z_t^W+\text{indexation terms}.
```

`needs_review`：紧凑的 MMB 实现使用静态劳动供给关系，而不是完整工资 Phillips 曲线。

- **(F11) 消费和闲暇边际替代率**:

```math
mrs_t=\eta n_t+\frac{\sigma}{1-\tilde\kappa}
\left[c_t^O-\tilde\kappa(c_{t-1}^O-z_t^Z)\right].
```

- **(F12) 资本租赁率**:

```math
r_t^K=q_t^D+y_t^D-k_t+z_t^Z.
```

- **(F13) 国内投入相对价格**:

```math
q_t^D=\alpha r_t^K+(1-\alpha)w_t-z_t^D.
```

- **(F14) 劳动需求**:

```math
n_t=\alpha_N(q_t^D+y_t^D-w_t).
```

- **(F15) 进口价格 Phillips 曲线**:

```math
\pi_t^M-v_t^M=\lambda_M(q_t+q_t^{M^{\ast}}-q_t^M)
+\tilde\beta E_t(\pi_{t+1}^M-v_{t+1}^M).
```

- **(F16) 部门边际成本**:

```math
mc_t^H=\varpi_Hq_t^D+(1-\varpi_H)\left[
q_t^M+\varpi_H^{\ast}(r_t^{\ast}+s_t^{B^{\ast}})
+\vartheta_H^M\bigl((m_t^H-y_t^H)-(m_{t-1}^H-y_{t-1}^H)\bigr)-z_t^M
\right].
```

- **(F17) 部门国内投入需求**:

```math
y_{H,t}^D=y_t^H-\epsilon_H(q_t^D-mc_t^H).
```

- **(F18) 部门进口投入需求**:

```math
m_t^H=y_t^H-\frac{\epsilon_H}{1+\epsilon_H\vartheta_H^M}
\left[q_t^M+\varpi_H^{\ast}(r_t^{\ast}+s_t^{B^{\ast}})-mc_t^H\right]
+\frac{\epsilon_H}{1+\epsilon_H\vartheta_H^M}
\left[\vartheta_H^M(m_{t-1}^H-y_{t-1}^H)+z_t^M\right].
```

- **(F19) 政府和投资品价格 Phillips 曲线**:

```math
\pi_t^H-v_t^H=\lambda_H(mc_t^H-q_t^H)
+\tilde\beta E_t(\pi_{t+1}^H-v_{t+1}^H)+z_t^P,\quad H\in\{G,I\}.
```

- **(F20) 部门相对价格运动方程**:

```math
q_t^H=q_{t-1}^H+\pi_t^H-\pi_t^C.
```

- **(F21) 自由定价消费品价格 Phillips 曲线**:

```math
\pi_t^F-v_t^F=\lambda_F(mc_t^C-q_t^F)
+\tilde\beta E_t(\pi_{t+1}^F-v_{t+1}^F)+z_t^P.
```

- **(F22) 自由定价相对价格运动方程**:

```math
q_t^F=q_{t-1}^F+\pi_t^F-\pi_t^C.
```

- **(F23) 管制价格通胀**:

```math
\pi_t^A=\theta_Av_t^A+(1-\theta_A)\bar\pi_t^C.
```

- **(F24) 管制价格规则**:

```math
v_t^A=\chi_A\left[\pi_{t-1,t-5}^C+v_A^1(q_{t-1}-q_{t-5})
+v_A^2(mc_{t-1}^C-mc_{t-5}^C)\right]
+(1-\chi_A)q_t^F+\frac{1}{\theta_A}z_t^A.
```

- **(F25) CPI 通胀聚合**:

```math
\pi_t^C=\varpi_A\pi_t^A+(1-\varpi_A)\pi_t^F.
```

- **(F26) 出口价格 Phillips 曲线**:

```math
\pi_t^X-v_t^X=\lambda_X(mc_t^X-q_t^{X^{\ast}}-q_t)
+\tilde\beta E_t(\pi_{t+1}^X-v_{t+1}^X)+z_t^{P^X}.
```

- **(F27) 出口相对价格运动方程**:

```math
q_t^{X^{\ast}}=q_{t-1}^{X^{\ast}}+\pi_t^X-\pi_t^{C^{\ast}}.
```

- **(F28) 世界对巴西出口的需求**:

```math
x_t=y_t^{\ast}+\frac{\epsilon^{\ast}}{1+\epsilon^{\ast}\vartheta^{M^{\ast}}}
\left[\vartheta^{M^{\ast}}(x_{t-1}-y_{t-1}^{\ast})-q_t^{X^{\ast}}+z_t^{M^{\ast}}\right].
```

## 4. Market Clearing & Identities

- **(F29) 最终品市场出清**:

```math
y_t^C=c_t,\qquad y_t^G=g_t,\qquad y_t^I=i_t,\qquad y_t^X=x_t.
```

- **(F30) 国内投入市场出清**:

```math
y_t^D=s_C^D y_{C,t}^D+s_G^D y_{G,t}^D+s_I^D y_{I,t}^D+s_X^D y_{X,t}^D.
```

- **(F31) 进口投入市场出清**:

```math
m_t=s_C^M m_t^C+s_I^M m_t^I+s_X^M m_t^X.
```

- **(F32) 外部贷款/GDP 比率**:

```math
l_t^{\asty}=\sum_{H=C,I,X}\iota_Hs_{M,H}
\left[
R^{\ast}S^{B^{\ast}}(r_t^{\ast}+s_t^{B^{\ast}})
+(R^{\ast}S^{B^{\ast}}-1)(q_t^M+m_t^H-q_t^Y-y_t)
\right].
```

- **(F33) 净出口/GDP 比率**:

```math
nx_t^y=s_X(q_t+q_t^{X^{\ast}}+x_t)
-s_M(q_t+q_t^{M^{\ast}}+m_t)
-(s_X-s_M)(q_t^Y+y_t).
```

- **(F34) 净国外资产/GDP 运动方程**:

```math
b_{t+1}^{\asty}=\lambda_{B^{\ast}}b_t^{\asty}
+R^{\ast}S^{B^{\ast}}(nx_t^y-l_t^{\asty})
+\tilde B^{\asty}(r_t^{\ast}+s_t^{B^{\ast}})
+\lambda_{B^{\ast}}\tilde B^{\asty}
(y_{t-1}-y_t-\pi_t^Y-z_t^Z+q_t-q_{t-1}+\pi_t^C-\pi_t^{\ast}).
```

- **(F35) 实际 GDP**:

```math
y_t=s_Cc_t+s_Ii_t+s_Gg_t+s_Xx_t-s_Mm_t.
```

- **(F36) 相对 GDP 平减指数**:

```math
q_t^Y=s_Gq_t^G+s_Iq_t^I+s_X(q_t+q_t^{X^{\ast}})
-s_M(q_t+q_t^{M^{\ast}}).
```

- **(F37) GDP 平减指数通胀**:

```math
\pi_t^Y=\pi_t^C+q_t^Y-q_{t-1}^Y.
```

## 5. Exogenous Processes

- **(F38) 货币政策规则**:

```math
r_t=\gamma_Rr_{t-1}+(1-\gamma_R)
\left[\frac{1}{4}\bar\pi_{t-3,t+1}^C
+\gamma_\Pi E_t\left(\frac{1}{4}\pi_{t,t+4}^C-\frac{1}{4}\bar\pi_{t,t+4}^C\right)
+\gamma_Yy_t\right]+z_t^R.
```

- **(F39) 通胀目标**:

```math
\frac{1}{4}\bar\pi_{t,t+4}^C
=\rho_{\bar\Pi^C}\frac{1}{4}\bar\pi_{t-4,t}^C
+\varepsilon_t^{\bar\Pi^C}.
```

- **(F40) 财政基本盈余规则**:

```math
s_t^y=\phi_Ss_{t-1}^y+\phi_{\bar S}\bar s_t^y-s_Gz_t^G.
```

- **(F41) 基本盈余目标**:

```math
\bar s_t^y=\rho_{\bar S}\bar s_{t-1}^y+\phi_Bb_t^y+\varepsilon_t^{\bar S}.
```

- **(F42) 税率过程**:

```math
\tau_t=\rho_T\tau_{t-1}+\varepsilon_t^T.
```

- **(F43) 政府消费**:

```math
g_t=\frac{1}{s_G}(\tau_t-s_t^y)+y_t+q_t^Y-q_t^G.
```

- **(F44) 政府债务运动方程**:

```math
b_t^y=\lambda_Bb_{t-1}^y+B^yr_t-Rs_t^y
+\lambda_BB^y(y_{t-1}-y_t-\pi_t^Y-z_t^Z).
```

- **(F45) 外国产出**:

```math
y_t^{\ast}=\rho_{Y^{\ast}}y_{t-1}^{\ast}+\varepsilon_t^{Y^{\ast}}.
```

- **(F46) 外国进口价格过程**:

```math
q_t^{M^{\ast}}=\rho_{Q^{M^{\ast}}}q_{t-1}^{M^{\ast}}+\varepsilon_t^{Q^{M^{\ast}}}.
```

- **(F47) 外国通胀**:

```math
\pi_t^{C^{\ast}}=\rho_{\Pi^{C^{\ast}}}\pi_{t-1}^{C^{\ast}}+\varepsilon_t^{\Pi^{C^{\ast}}}.
```

- **(F48) 外国投资者风险厌恶**:

```math
v_t^{\ast}=\rho_{V^{\ast}}v_{t-1}^{\ast}+\varepsilon_t^{V^{\ast}}.
```

- **(F49) 外国利率**:

```math
r_t^{\ast}=\rho_{R^{\ast}}r_{t-1}^{\ast}+\varepsilon_t^{R^{\ast}}.
```

- **(F50) 国内结构冲击过程**:

```math
z_t^S=\rho_Sz_{t-1}^S+\varepsilon_t^S,\quad
S\in\{C,Q,B^{\ast},D,Z,I,M,M^{\ast},W,P,A,P^X,R,G\}.
```

在论文估计设定中，$`\rho_R=0`$ 且 $`\rho_G=0`$。

## 6. Steady-State Solution

论文在用技术 $`Z_t`$ 平稳化所有增长的实际变量、用 $`P_t^C`$ 平稳化名义变量后，推导确定性稳态。在稳态中，所有国内通胀率等于 CPI 通胀目标，价格和工资扭曲消失。

关键价格关系：

```math
MC^C=\frac{\epsilon_C^P-1}{\epsilon_C^P},\qquad
Q^M=Q^{M^\star}=\frac{\epsilon_M}{\epsilon_M-1}QQ^{M^{\ast}}.
```

```math
R=\frac{\bar\Pi^C(Z^Z)^\sigma}{\beta},\qquad
Q^K=Q^I,\qquad
R^K=\left(\frac{(Z^Z)^\sigma}{\beta}-(1-\delta)\right)Q^K.
```

```math
\tilde W=(1-\alpha)(Q^D)^{1/(1-\alpha)}
\left(\frac{\alpha}{R^K}\right)^{\alpha/(1-\alpha)},\qquad
S^{B^{\ast}}=\frac{R/\bar\Pi^C}{R^{\ast}/\Pi^{C^{\ast}}}.
```

配置关系包括由外国需求决定出口、由税收和基本盈余目标决定政府支出、资本积累、家庭消费聚合、生产投入条件和进口投入份额。论文还校准了线性模型直接使用的稳态比率，包括 $`s_C,s_I,s_G,s_X,s_M`$、债务比率、通胀目标、国内和国外总利率以及国家风险溢价。

运行验证：未执行。本条目是推导/档案提取，不是 Dynare 运行。

## 7. Timing & Form Conventions

- 模型形式：MMB 操作性实现为 `model(linear)`。论文也给出非线性和 BGP 方程。
- 时间单位：季度。
- 线性变量是相对稳态的偏离或对数偏离；$`b_t^y,b_{t+1}^{\asty},nx_t^y,l_t^{\asty}`$ 等 GDP 比率是相对稳态的偏离。
- 在论文的非线性时序约定中，时期 $`t`$ 决定的流量变量记为 $`t`$，而在 $`t`$ 选择的存量变量记为 $`t+1`$。资本持有 $`K_t`$ 和债券 $`B_t,B_t^{\ast}`$ 来自上一期选择；$`K_{t+1},B_{t+1},B_{t+1}^{\ast}`$ 在 $`t`$ 选择。
- MMB `.mod` 将其映射为 Dynare 时序：生产中的预定资本写为 `k(-1)`，当前 `k` 是由当期投资形成的下一期/安装后存量。
- CPI 通胀是计价基准通胀；相对价格运动方程使用部门通胀减 CPI 通胀。
- OCR 问题：方程 (A.21)、(A.31) 和若干调整成本导数项在 MinerU Markdown 中含有畸形符号，若后续推广需要精确非线性方程，应对 PDF 做公式级核对，状态为 `needs_review`。

## 8. Variable & Parameter Reference Table

| Category | Symbol | Meaning | Main equation(s) |
|---|---|---|---|
| Endogenous | `co`, $`c_t^O`$ | 优化型家庭消费 | (F1) |
| Endogenous | `crot`, $`c_t^{RT}`$ | 即期消费家庭消费 | (F2) |
| Endogenous | `c`, $`c_t`$ | 总消费 | (F3) |
| Endogenous | `q`, $`q_t`$ | 实际汇率 | (F4) |
| Endogenous | `qi`, $`q_t^K`$ | 资本影子价值 / Tobin Q | (F5) |
| Endogenous | `i`, $`i_t`$ | 投资 | (F6) |
| Endogenous | `k`, $`k_t`$ | 资本存量 | (F7) |
| Endogenous | `fii`, $`s_t^{B^{\ast}}`$ | 国家风险溢价 | (F8) |
| Endogenous | `wr`, $`w_t`$ | 实际工资 | (F10) |
| Endogenous | `rk`, $`r_t^K`$ | 资本租赁率 | (F12) |
| Endogenous | `mc`, $`q_t^D`$ or marginal cost proxy | 国内投入价格 / 边际成本 | (F13), (F16) |
| Endogenous | `n`, $`n_t`$ | 总劳动 | (F14) |
| Endogenous | `m`, $`m_t`$ | 进口 | (F18), (F31) |
| Endogenous | `pi`, $`\pi_t^C`$ | MMB 简化中的 CPI/自由价格通胀代理 | (F21), (F25) |
| Endogenous | `x`, $`x_t`$ | 出口 | (F28) |
| Endogenous | `nxy`, $`nx_t^y`$ | 净出口/GDP 比率 | (F33) |
| Endogenous | `bystar`, $`b_{t+1}^{\asty}`$ | 净国外资产/GDP | (F34) |
| Endogenous | `y`, $`y_t`$ | 实际 GDP | (F35) |
| Endogenous | `yva`, $`y_t^Y`$ | 增加值产出 / GDP 指标 | (F35)-(F37) |
| Endogenous | `piva`, $`\pi_t^Y`$ | GDP 平减指数通胀 | (F37) |
| Endogenous | `r`, $`r_t`$ | 国内政策利率 | (F38) |
| Endogenous | `pibar`, $`\bar\pi_t^C`$ | 通胀目标 | (F39) |
| Endogenous | `syhat`, $`s_t^y`$ | 基本盈余/GDP 比率 | (F40) |
| Endogenous | `sgbar`, $`\bar s_t^y`$ | 基本盈余目标 | (F41) |
| Endogenous | `gy`, fiscal gap | 财政规则辅助变量 | (F40)-(F43) |
| Endogenous | `bby`, $`b_t^y`$ | 政府债务/GDP 比率 | (F44) |
| Endogenous | `g`, $`g_t`$ | 政府消费 | (F43) |
| Endogenous | `mstar`, $`y_t^{\ast}`$ or world demand | 外国需求过程 | (F45) |
| Endogenous | `pistar`, $`\pi_t^{C^{\ast}}`$ | 外国通胀 | (F47) |
| Endogenous | `rstar`, $`r_t^{\ast}`$ | 外国利率 | (F49) |
| Exogenous | `c_` | 家庭偏好创新 | (F50) |
| Exogenous | `n_` | 工资/劳动加成创新 | (F50) |
| Exogenous | `i_` | 投资创新 | (F50) |
| Exogenous | `fii_` | 国家风险溢价创新 | (F50) |
| Exogenous | `a_` | 技术创新 | (F50) |
| Exogenous | `r_` | 货币政策创新 | (F50) |
| Exogenous | `g_`, `gbar_` | 财政/政府目标创新 | (F40)-(F44), (F50) |
| Exogenous | `mstar_`, `pistar_`, `rstar_` | 外国需求、通胀和利率创新 | (F45)-(F49) |
| Parameters | $`\beta,\alpha,\sigma,\kappa,h,\delta,\theta,\omega,\rho,\gamma,\phi,s_j`$ | 偏好、技术、名义刚性、政策、份额和冲击持续性 | all blocks |

实现交叉核对：MMB 示例包含 39 个内生变量和 13 个创新。它将论文更完整的分部门系统压缩为简化线性表示，变量为 `co crot c no nrot n q wr k u fii qi i x m rk mc pi bystar nxy r gy syhat bby g y yva piva pibar sgbar zc zn zi zfiistar zfii a zr zg mstar pistar rstar`。
