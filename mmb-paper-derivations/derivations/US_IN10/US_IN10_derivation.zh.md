# US_IN10 -- 推导（最优化问题 + 一阶条件）

> 模型档案初稿，用于有来源依据的后续审阅。未执行运行时验证。状态：`needs_review`。

来源信息：`US_IN10`，Iacoviello and Neri (2010)，"Housing Market Spillovers: Evidence from an Estimated DSGE Model"，DOI `10.1257/mac.2.2.125`。主要来源：`raw/mmb_mineru/runs/us_in10__housing_market_spillovers_evidence_from_an_estimated_dsge_model__eac0da74/full.md`；原始 PDF：`raw/mmb_papers/Housing market spillovers- Evidence from an estimated dsge model.pdf`；MinerU run id `eac0da74-ce5a-44ed-87f4-f7ac437abbaf`。

## 1. Model Overview

- 模型：带住房市场溢出效应的美国两部门估计 DSGE 模型。
- 目的：对 1965:Q1-2006:Q4 的住房需求、住房技术、货币冲击和抵押品效应进行贝叶斯估计与反事实分析。
- 主体和模块：耐心家庭、受抵押约束的非耐心家庭、消费品和住房生产中的批发厂商、消费部门的黏性价格零售商、两个部门和两类家庭的黏性工资工会，以及采用 Taylor 规则的中央银行。
- 核心机制：异质贴现因子、非耐心家庭的绑定住房抵押约束、作为耐用品效用存量的住房、两类资本存量、住房生产中的土地和中间投入、投资专有技术、资本利用率、价格和工资 Phillips 曲线，以及多个持久性冲击。
- 形式：论文说明先按平衡增长路径去趋势，再围绕非随机稳态线性化。Rep-MMB 实现使用围绕趋势的对数变量，并区分弹性价格/弹性工资模块和黏性价格/工资模块；这一 `.mod` 信息仅作为 `implementation_cross_check` 记录。
- 公式质量：本初稿来自 MinerU Markdown 的一轮抽取。方程 (B1)-(B36) 基本可用，但仍有若干 OCR 痕迹；不确定处标记为 `needs_review`。

## 2. Optimization Problems

### 耐心家庭

耐心家庭在消费、住房以及消费部门和住房部门工时上最大化期望效用：

\[
E_0 \sum_{t=0}^{\infty}(\beta G_C)^t z_t\left[
\Gamma_c\ln(c_t-\varepsilon c_{t-1})+j_t\ln h_t
-\frac{\tau_t}{1+\eta}\left(n_{c,t}^{1+\xi}+n_{h,t}^{1+\xi}\right)^{\frac{1+\eta}{1+\xi}}
\right].
\]

他们在 (F1) 的预算约束下选择消费、住房、贷款、土地、两部门资本、住房生产中的中间投入、部门工时和资本利用率。耐心家庭拥有资本和土地，获得股利，并向非耐心家庭放贷。

### 非耐心家庭

非耐心家庭有类似的目标函数：

\[
E_0 \sum_{t=0}^{\infty}({\beta}'G_C)^t z_t\left[
{\Gamma}'_c\ln({c}'_t-{\varepsilon}'{c}'_{t-1})+j_t\ln {h}'_t
-\frac{\tau_t}{1+{\eta}'}\left(({n}'_{c,t})^{1+{\xi}'}+({n}'_{h,t})^{1+{\xi}'}\right)^{\frac{1+{\eta}'}{1+{\xi}'}}
\right],
\]

其中 \({\beta}'<\beta\)。他们在 (F12) 和绑定抵押约束 (F13) 下选择消费、住房、部门工时和借款。

### 批发厂商

竞争性批发厂商生产非住房产出和新住房。他们选择劳动、资本服务、土地和中间品以最大化当期利润：

\[
\max \; \frac{Y_t}{X_t}+q_t IH_t
-\left(\sum_{i=c,h}w_{i,t}n_{i,t}+\sum_{i=c,h}{w}'_{i,t}{n}'_{i,t}
+\sum_{i=c,h}R_{i,t}z_{i,t}k_{i,t-1}+R_{l,t}l_{t-1}+p_{b,t}k_{b,t}\right),
\]

并受 (F18)-(F19) 的生产技术约束。

### 零售商、工会和政策

消费部门零售商在带指数化的 Calvo 合约下设定价格，得到 Phillips 曲线 (F28)。劳动工会以类似的 Calvo 合约设定四个部门/类型名义工资，得到 (F29)-(F32)。中央银行遵循 (F33) 的 Taylor 规则。这些模块在本档案初稿中作为均衡条件处理，而不是静态最优化问题。

## 3. First-Order Conditions

**耐心家庭**

- **(F1) 耐心家庭预算约束**：

\[
\begin{aligned}
c_t+\frac{k_{c,t}}{A_{k,t}}+k_{h,t}+k_{b,t}+q_t h_t+p_{l,t}l_t-b_t
&=\frac{w_{c,t}}{X_{wc,t}}n_{c,t}+\frac{w_{h,t}}{X_{wh,t}}n_{h,t}-\phi_t\\
&\quad+\left(R_{c,t}z_{c,t}+\frac{1-\delta_{kc}}{A_{k,t}}\right)k_{c,t-1}
+\left(R_{h,t}z_{h,t}+1-\delta_{kh}\right)k_{h,t-1}\\
&\quad+p_{b,t}k_{b,t}-\frac{R_{t-1}b_{t-1}}{\pi_t}
+(p_{l,t}+R_{l,t})l_{t-1}+q_t(1-\delta_h)h_{t-1}\\
&\quad+Div_t-\frac{a(z_{c,t})}{A_{k,t}}k_{c,t-1}-a(z_{h,t})k_{h,t-1}.
\end{aligned}
\]

needs_review：Appendix OCR 在 (B1) 中显示 `q_l h_t`，但主文预算约束和经济含义指向 `q_t h_t`；本稿采用 `q_t h_t`。

- **(F2) 耐心家庭住房 Euler 方程**：

\[
u_{c,t}q_t=u_{h,t}+\beta G_C E_t\left[u_{c,t+1}q_{t+1}(1-\delta_h)\right].
\]

- **(F3) 耐心家庭债券 Euler 方程**：

\[
u_{c,t}=\beta G_C E_t\left(u_{c,t+1}\frac{R_t}{\pi_{t+1}}\right).
\]

- **(F4) 耐心家庭消费部门资本 Euler 方程**：

\[
u_{c,t}\left(\frac{1}{A_{k,t}}+\frac{\partial\phi_{c,t}}{\partial k_{c,t}}\right)
=\beta G_C E_t u_{c,t+1}\left(R_{c,t+1}z_{c,t+1}-\frac{a(z_{c,t+1})+1-\delta_{kc}}{A_{k,t+1}}-\frac{\partial\phi_{c,t+1}}{\partial k_{c,t}}\right).
\]

- **(F5) 耐心家庭住房部门资本 Euler 方程**：

\[
u_{c,t}\left(1+\frac{\partial\phi_{h,t}}{\partial k_{h,t}}\right)
=\beta G_C E_t u_{c,t+1}\left(R_{h,t+1}z_{h,t+1}-a(z_{h,t+1})+1-\delta_{kh}-\frac{\partial\phi_{h,t+1}}{\partial k_{h,t}}\right).
\]

- **(F6) 耐心家庭消费部门劳动供给**：

\[
u_{c,t}w_{c,t}=u_{nc,t}X_{wc,t}.
\]

- **(F7) 耐心家庭住房部门劳动供给**：

\[
u_{c,t}w_{h,t}=u_{nh,t}X_{wh,t}.
\]

- **(F8) 中间投入价格条件**：

\[
u_{c,t}(p_{b,t}-1)=0.
\]

- **(F9) 消费部门资本利用率**：

\[
R_{c,t}A_{k,t}=a'(z_{c,t}).
\]

- **(F10) 住房部门资本利用率**：

\[
R_{h,t}=a'(z_{h,t}).
\]

- **(F11) 土地资产 Euler 方程**：

\[
u_{c,t}p_{l,t}=\beta G_C E_t u_{c,t+1}(p_{l,t+1}+R_{l,t+1}).
\]

**非耐心家庭**

- **(F12) 非耐心家庭预算约束**：

\[
{c}'_t+q_t{h}'_t=\frac{{w}'_{c,t}}{{X}'_{wc,t}}{n}'_{c,t}
+\frac{{w}'_{h,t}}{{X}'_{wh,t}}{n}'_{h,t}
+{b}'_t-\frac{R_{t-1}}{\pi_t}{b}'_{t-1}+q_t(1-\delta_h){h}'_{t-1}+{Div}'_t.
\]

- **(F13) 绑定住房抵押约束**：

\[
{b}'_t=mE_t\left(\frac{q_{t+1}{h}'_t\pi_{t+1}}{R_t}\right).
\]

- **(F14) 非耐心家庭住房 Euler 方程**：

\[
u_{{c}',t}q_t=u_{{h}',t}+{\beta}'G_CE_t\left[u_{{c}',t+1}q_{t+1}(1-\delta_h)\right]
+E_t\left(\lambda_t\frac{m q_{t+1}\pi_{t+1}}{R_t}\right).
\]

- **(F15) 带抵押乘数的非耐心家庭债券 Euler 方程**：

\[
u_{{c}',t}={\beta}'G_CE_t\left(u_{{c}',t+1}\frac{R_t}{\pi_{t+1}}\right)+\lambda_t.
\]

- **(F16) 非耐心家庭消费部门劳动供给**：

\[
u_{{c}',t}{w}'_{c,t}=u_{{n_c}',t}{X}'_{wc,t}.
\]

- **(F17) 非耐心家庭住房部门劳动供给**：

\[
u_{{c}',t}{w}'_{h,t}=u_{{n_h}',t}{X}'_{wh,t}.
\]

**批发厂商**

- **(F18) 非住房生产技术**：

\[
Y_t=\left(A_{c,t}(n_{c,t}^{\alpha}{n}'_{c,t}{}^{1-\alpha})\right)^{1-\mu_c}(z_{c,t}k_{c,t-1})^{\mu_c}.
\]

- **(F19) 住房生产技术**：

\[
IH_t=\left(A_{h,t}(n_{h,t}^{\alpha}{n}'_{h,t}{}^{1-\alpha})\right)^{1-\mu_h-\mu_l-\mu_b}
k_{b,t}^{\mu_b}(z_{h,t}k_{h,t-1})^{\mu_h}l_{t-1}^{\mu_l}.
\]

- **(F20) 耐心家庭劳动需求，消费部门**：

\[
(1-\mu_c)\alpha Y_t=X_t w_{c,t}n_{c,t}.
\]

- **(F21) 非耐心家庭劳动需求，消费部门**：

\[
(1-\mu_c)(1-\alpha)Y_t=X_t {w}'_{c,t}{n}'_{c,t}.
\]

- **(F22) 耐心家庭劳动需求，住房部门**：

\[
(1-\mu_h-\mu_l-\mu_b)\alpha q_t IH_t=w_{h,t}n_{h,t}.
\]

- **(F23) 非耐心家庭劳动需求，住房部门**：

\[
(1-\mu_h-\mu_l-\mu_b)(1-\alpha)q_t IH_t={w}'_{h,t}{n}'_{h,t}.
\]

- **(F24) 消费部门资本需求**：

\[
\mu_c Y_t=X_t R_{c,t}z_{c,t}k_{c,t-1}.
\]

- **(F25) 住房部门资本需求**：

\[
\mu_h q_t IH_t=R_{h,t}z_{h,t}k_{h,t-1}.
\]

- **(F26) 土地需求**：

\[
\mu_l q_t IH_t=R_{l,t}l_{t-1}.
\]

- **(F27) 中间投入需求**：

\[
\mu_b q_t IH_t=p_{b,t}k_{b,t}.
\]

**价格和工资设定**

- **(F28) 消费部门价格 Phillips 曲线**：

\[
\ln\pi_t-\iota_{\pi}\ln\pi_{t-1}
=\beta G_C(E_t\ln\pi_{t+1}-\iota_{\pi}\ln\pi_t)-\varepsilon_{\pi}\ln(X_t/X)+u_{p,t}.
\]

- **(F29) 耐心家庭消费部门工资 Phillips 曲线**：

\[
\ln\omega_{c,t}-\iota_{wc}\ln\pi_{t-1}
=\beta G_C(E_t\ln\omega_{c,t+1}-\iota_{wc}\ln\pi_t)-\varepsilon_{wc}\ln(X_{wc,t}/X_{wc}).
\]

- **(F30) 非耐心家庭消费部门工资 Phillips 曲线**：

\[
\ln{\omega}'_{c,t}-\iota_{wc}\ln\pi_{t-1}
={\beta}'G_C(E_t\ln{\omega}'_{c,t+1}-\iota_{wc}\ln\pi_t)-{\varepsilon}'_{wc}\ln({X}'_{wc,t}/X_{wc}).
\]

- **(F31) 耐心家庭住房部门工资 Phillips 曲线**：

\[
\ln\omega_{h,t}-\iota_{wh}\ln\pi_{t-1}
=\beta G_C(E_t\ln\omega_{h,t+1}-\iota_{wh}\ln\pi_t)-\varepsilon_{wh}\ln(X_{wh,t}/X_{wh}).
\]

- **(F32) 非耐心家庭住房部门工资 Phillips 曲线**：

\[
\ln{\omega}'_{h,t}-\iota_{wh}\ln\pi_{t-1}
={\beta}'G_C(E_t\ln{\omega}'_{h,t+1}-\iota_{wh}\ln\pi_t)-{\varepsilon}'_{wh}\ln({X}'_{wh,t}/X_{wh}).
\]

needs_review：Appendix B 中工资 Phillips 曲线斜率定义似乎在住房工资表达式中重复了 `theta_wc`，且 prime 记号不一致；本稿保留预期的部门/类型结构。

- **(F33) Taylor 规则**：

\[
R_t=(R_{t-1})^{r_R}\pi_t^{r_{\pi}(1-r_R)}
\left(\frac{GDP_t}{G_CGDP_{t-1}}\right)^{r_Y(1-r_R)}
\overline{rr}^{\,1-r_R}\frac{u_{R,t}}{s_t}.
\]

## 4. Market Clearing & Identities

- **(F34) 产品市场出清**：

\[
C_t+\frac{IK_{c,t}}{A_{k,t}}+IK_{h,t}+k_{b,t}=Y_t-\phi_t.
\]

- **(F35) 总住房积累**：

\[
h_t+{h}'_t-(1-\delta_h)(h_{t-1}+{h}'_{t-1})=IH_t.
\]

- **(F36) 土地供给**：

\[
l_t=1.
\]

Appendix B 还给出以下恒等式：

\[
b_t+{b}'_t=0,
\]

\[
GDP_t=Y_t-k_{b,t}+\bar{q}IH_t.
\]

\[
Div_t=\frac{X_t-1}{X_t}Y_t+\frac{X_{wc,t}-1}{X_{wc,t}}w_{c,t}n_{c,t}
+\frac{X_{wh,t}-1}{X_{wh,t}}w_{h,t}n_{h,t}.
\]

\[
{Div}'_t=\frac{{X}'_{wc,t}-1}{{X}'_{wc,t}}{w}'_{c,t}{n}'_{c,t}
+\frac{{X}'_{wh,t}-1}{{X}'_{wh,t}}{w}'_{h,t}{n}'_{h,t}.
\]

投资和调整成本定义：

\[
IK_{c,t}=k_{c,t}-(1-\delta_{kc})k_{c,t-1},\qquad
IK_{h,t}=k_{h,t}-(1-\delta_{kh})k_{h,t-1}.
\]

\[
\phi_t=\frac{\phi_{kc}}{2G_{IKc}}\left(\frac{k_{c,t}}{k_{c,t-1}}-G_{IKc}\right)^2
\frac{k_{c,t-1}}{(1+\gamma_{AK})^t}
+\frac{\phi_{kh}}{2G_{IKh}}\left(\frac{k_{h,t}}{k_{h,t-1}}-G_{IKh}\right)^2k_{h,t-1}.
\]

needs_review：调整成本公式尤其容易受到 OCR 换行影响；在实现前应对照 PDF 检查第一项与滞后资本和趋势缩放的乘法关系。

资本利用成本函数：

\[
a(z_{c,t})=R_c\left(\varpi z_{c,t}^2/2+(1-\varpi)z_{c,t}+(\varpi/2-1)\right),
\]

\[
a(z_{h,t})=R_h\left(\varpi z_{h,t}^2/2+(1-\varpi)z_{h,t}+(\varpi/2-1)\right).
\]

## 5. Exogenous Processes

偏好和政策冲击：

- **(F37) 跨期偏好冲击**：

\[
\ln z_t=\rho_z\ln z_{t-1}+u_{z,t}.
\]

- **(F38) 劳动供给冲击**：

\[
\ln\tau_t=\rho_{\tau}\ln\tau_{t-1}+u_{\tau,t}.
\]

- **(F39) 住房偏好冲击**：

\[
\ln j_t=(1-\rho_j)\ln j+\rho_j\ln j_{t-1}+u_{j,t}.
\]

- **(F40) 通胀目标冲击**：

\[
\ln s_t=\rho_s\ln s_{t-1}+u_{s,t}.
\]

带趋势的技术过程：

- **(F41) 消费部门生产率**：

\[
\ln A_{c,t}=t\ln(1+\gamma_{AC})+\ln Z_{c,t},\qquad
\ln Z_{c,t}=\rho_{AC}\ln Z_{c,t-1}+u_{C,t}.
\]

- **(F42) 住房部门生产率**：

\[
\ln A_{h,t}=t\ln(1+\gamma_{AH})+\ln Z_{h,t},\qquad
\ln Z_{h,t}=\rho_{AH}\ln Z_{h,t-1}+u_{H,t}.
\]

- **(F43) 投资专有技术**：

\[
\ln A_{k,t}=t\ln(1+\gamma_{AK})+\ln Z_{k,t},\qquad
\ln Z_{k,t}=\rho_{AK}\ln Z_{k,t-1}+u_{K,t}.
\]

价格加成冲击 `u_{p,t}` 是 (F28) 中的创新，货币政策冲击 `u_{R,t}` 进入 (F33)。Rep-MMB 实现交叉检查列出外生创新 `eps_c`、`eps_h`、`eps_j`、`eps_k`、`eps_t`、`eps_s`、`eps_z`、`eps_p` 和 `eps_e`。

## 6. Steady-State Solution

论文先按平衡增长趋势去趋势，再围绕非随机稳态线性化。完整数值稳态重建在本次归档中暂缓，因为本次不运行模型，且 Appendix B 使用了若干辅助稳态比率。

论文给出的平衡增长率：

\[
G_C=G_{IKh}=G_{q\times IH}=1+\gamma_{AC}+\frac{\mu_c}{1-\mu_c}\gamma_{AK}.
\]

\[
G_{IKc}=1+\gamma_{AC}+\frac{1}{1-\mu_c}\gamma_{AK}.
\]

\[
G_{IH}=1+(\mu_h+\mu_b)\gamma_{AC}
+\frac{\mu_c(\mu_h+\mu_b)}{1-\mu_c}\gamma_{AK}
+(1-\mu_h-\mu_l-\mu_b)\gamma_{AH}.
\]

\[
G_q=1+(1-\mu_h-\mu_b)\gamma_{AC}
+\frac{\mu_c(1-\mu_h-\mu_b)}{1-\mu_c}\gamma_{AK}
-(1-\mu_h-\mu_l-\mu_b)\gamma_{AH}.
\]

论文中的校准和稳态目标：

- \(\beta=0.9925\)，\({\beta}'=0.97\)，\(j=0.12\)，\(\mu_c=0.35\)，\(\mu_h=0.10\)，\(\mu_l=0.10\)，\(\mu_b=0.10\)，\(\delta_h=0.01\)，\(\delta_{kc}=0.025\)，\(\delta_{kh}=0.03\)，\(X=X_{wc}=X_{wh}=1.15\)，\(m=0.85\)，\(\rho_s=0.975\)。
- 稳态比率：年化实际利率 3 percent，\(C/GDP=67\) percent，\(IK/GDP=27\) percent，\(qIH/GDP=6\) percent，\(qH/(4GDP)=1.36\)，\(k_c/(4GDP)=2.05\)，\(k_h/(4GDP)=0.04\)，\(p_l/(4GDP)=0.50\)。
- MMB 实现交叉检查使用的后验均值趋势参数：`TREND_AC = 0.0032`、`TREND_AH = 0.0008` 和 `TREND_AK = 0.00275`。

needs_review：这里是稳态映射，不是可执行的 `steady_state_model`。后续实现阶段应在构造完整递归稳态程序前，对 `IK_c`、`IK_h`、`GDP_t`、股利和调整成本等辅助比率做来源检查。

## 7. Timing & Form Conventions

- 时序：物理资本存量 \(k_{c,t}\) 和 \(k_{h,t}\) 是期末存量；第 \(t\) 期生产使用 \(k_{c,t-1}\) 和 \(k_{h,t-1}\)，并配合利用率 \(z_{c,t}\) 和 \(z_{h,t}\)。
- 住房：家庭住房存量进入第 \(t\) 期效用，并通过 (F35) 演化；既有住房以 \(\delta_h\) 折旧。
- 贷款：名义一期贷款在实际项中支付 \(R_{t-1}/\pi_t\)；非耐心家庭借款由预期下一期名义住房价值除以 \(R_t\) 来抵押。
- 土地：总土地固定并归一化为一；生产使用 \(l_{t-1}\)。
- 形式：论文对真实变量按平衡增长率去趋势，并围绕非随机稳态线性化。Rep-MMB `.mod` 将许多变量写成对数形式，并有单独的弹性价格/弹性工资模块用于构造产出缺口；这仅是 `implementation_cross_check`。
- 运行时验证：未执行；没有运行 Dynare。

## 8. Variable & Parameter Reference Table

| 类别 | 符号 | 含义 | 主要方程 |
|---|---|---|---|
| 内生 | \(c_t,{c}'_t\) | 耐心和非耐心家庭消费 | F1, F12, F15 |
| 内生 | \(h_t,{h}'_t,H_t\) | 家庭和总住房存量 | F2, F13, F14, F35 |
| 内生 | \(k_{c,t},k_{h,t},k_{b,t}\) | 消费部门资本、住房部门资本、中间投入 | F4, F5, F8, F24, F25, F27 |
| 内生 | \(n_{c,t},n_{h,t},{n}'_{c,t},{n}'_{h,t}\) | 按部门和家庭类型划分的工时 | F6, F7, F16, F17, F20-F23 |
| 内生 | \(b_t,{b}'_t,\lambda_t\) | 贷款和借款约束乘数 | F3, F12, F13, F15 |
| 内生 | \(Y_t,IH_t,GDP_t\) | 非住房产出、新住房和 GDP 度量 | F18, F19, F34, F35 |
| 内生 | \(q_t,p_{l,t},R_t,\pi_t\) | 房价、地价、名义利率、通胀 | F2, F3, F11, F28, F33 |
| 内生 | \(w_{c,t},w_{h,t},{w}'_{c,t},{w}'_{h,t}\) | 按部门/类型划分的实际工资 | F6, F7, F16, F17, F20-F23, F29-F32 |
| 内生 | \(X_t,X_{wc,t},X_{wh,t},{X}'_{wc,t},{X}'_{wh,t}\) | 价格和工资加成 | F20-F23, F28-F32 |
| 内生 | \(R_{c,t},R_{h,t},R_{l,t},z_{c,t},z_{h,t}\) | 租金率和利用率 | F9, F10, F24-F26 |
| 内生 | \(Div_t,{Div}'_t,\phi_t,a(z)\) | 股利和成本 | 第4节恒等式 |
| 外生 | \(u_{C,t},u_{H,t},u_{K,t}\) | 技术创新 | F41-F43 |
| 外生 | \(u_{z,t},u_{\tau,t},u_{j,t}\) | 偏好、劳动供给、住房偏好创新 | F37-F39 |
| 外生 | \(u_{p,t},u_{R,t},u_{s,t}\) | 价格加成、货币政策、通胀目标创新 | F28, F33, F40 |
| 参数 | \(\beta,{\beta}',G_C,j,\varepsilon,{\varepsilon}'\) | 偏好和增长缩放 | 第2节和第6节 |
| 参数 | \(\mu_c,\mu_h,\mu_l,\mu_b,\alpha,\delta_h,\delta_{kc},\delta_{kh}\) | 技术和折旧 | F18-F27, F35 |
| 参数 | \(m\) | 贷款价值比 | F13-F15 |
| 参数 | \(\theta_{\pi},\theta_{wc},\theta_{wh},\iota_{\pi},\iota_{wc},\iota_{wh}\) | Calvo 和指数化参数 | F28-F32 |
| 参数 | \(r_R,r_{\pi},r_Y,\overline{rr}\) | Taylor 规则参数 | F33 |
| 参数 | \(\rho_z,\rho_{\tau},\rho_j,\rho_s,\rho_{AC},\rho_{AH},\rho_{AK}\) | 冲击持久性 | F37-F43 |
