# EA_PV15 -- 推导（最优化问题 + 一阶条件）

> 状态：`needs_review`。这个第一遍归档条目基于 MinerU Markdown 来源；`.agents/skills/dynare-copilot/references/examples/EA_PV15_rep.mod` 仅作为 `implementation_cross_check` 使用。未进行运行时验证。

来源：Jean-Christophe Poutineau and Gauthier Vermandel (2015), "Cross-border banking flows spillovers in the eurozone: Evidence from an estimated DSGE model", *Journal of Economic Dynamics and Control* 51, 378-403. DOI: `10.1016/j.jedc.2014.11.006`.

## 1. Model Overview

- **模型**：`EA_PV15`，一个用于欧元区核心国家（`h`）和外围国家（`f`）的两国货币联盟 DSGE 模型，包含跨境企业贷款和同业贷款。
- **目的**：量化跨境银行资金流如何影响非对称冲击传导、投资周期、信贷数量、利差以及经常账户动态。
- **主体**：家庭、工会、中间品与最终品生产者、资本供应者、企业家、流动性银行与非流动性银行、各国财政当局以及共同中央银行。
- **摩擦**：消费和贷款需求的外部习惯、投资调整成本、资本利用成本、资产组合调整成本、黏性商品价格、黏性工资、黏性贷款利率、金融加速器风险、银行资产负债约束，以及商品、企业贷款和同业贷款的跨境 CES 聚合器。
- **模型形式**：论文推导非线性模型，然后使用对数线性均衡条件。MMB 实现交叉检查使用 `model(linear)`。

记号：国家索引 $i \in \{h,f\}$ 且 $j \neq i$。除非没有国家下标，变量均为国家特定变量。若干公式的 OCR 质量不均；标记为 `needs_review` 的公式在提升状态前应对照 PDF 检查。

## 2. Optimization Problems

### 2.1 非流动性银行

非流动性银行 $b \in [0,\lambda]$ 向企业家供给一期企业贷款，并以同业借款、银行资本和其他负债融资。其资产负债表为：

**(F1) 非流动性银行资产负债表**：
$$
L_{i,t+1}^{s}(b)=IB_{i,t+1}^{H}(b)+BK_{i,t+1}(b)+liab_{i,t}.
$$

它选择贷款供给以最大化预期利润：

**(F2) 非流动性银行利润问题**：
$$
\max_{L_{i,t+1}^{s}(b)}
E_t\left[
\eta_{i,t+1} MC_{i,t}^{ill}(b)L_{i,t+1}^{s}(b)
-P_{i,t}^{IB}\left(L_{i,t+1}^{s}(b)-BK_{i,t+1}(b)-liab_{i,t}(b)\right)
\right].
$$

### 2.2 流动性银行

流动性银行 $b \in [\lambda,1]$ 向企业家供给贷款，并向非流动性银行供给同业贷款；其资金来自 ECB 借款、银行资本和其他负债：

**(F3) 流动性银行资产负债表**：
$$
L_{i,t+1}^{s}(b)+IB_{i,t+1}^{s}(b)=L_{i,t+1}^{ECB}(b)+BK_{i,t+1}(b)+liab_t(b).
$$

其目标函数包括贷款收入、同业贷款收入、ECB 融资成本以及凸的监测/中介成本：

**(F4) 流动性银行利润问题**：
$$
\max_{\{L_{i,t+1}^{s}(b),IB_{i,t+1}^{s}(b)\}}
E_t\left[
\eta_{i,t+1}MC_{i,t}^{liq}(b)L_{i,t+1}^{s}(b)
+R_{i,t}^{IB}(b)IB_{i,t+1}^{s}(b)
-R_tL_{i,t+1}^{ECB}(b)-AC_{i,t+1}^{IB}(b)
\right].
$$

### 2.3 设置黏性贷款利率的银行

代表性全国银行体系在 Calvo 黏性下设置差异化企业贷款利率。获得重新定价机会的银行选择 $R_{i,t}^{L*}(b)$：

**(F5) 贷款利率重设问题（`needs_review`）**：
$$
\max_{\{R_{i,t}^{L*}(b)\}}
E_t\sum_{\tau=0}^{\infty}(\theta_i^L\beta)^\tau
\frac{\lambda_{i,t+\tau}^{c}}{\lambda_{i,t}^{c}}\eta_{i,t+1+\tau}
\left[(1-\tau^L)R_{i,t}^{L*}(b)\Xi_{i,t,\tau}^{L}-MC_{i,t+\tau}^{L}\right]
L_{i,t+1+\tau}(b).
$$

Markdown OCR 损坏了需求约束的部分内容，但论文说明未重新定价的贷款利率按过去贷款利率增长进行指数化。

### 2.4 企业家

企业家 $e$ 用净值和企业贷款为资本项目融资：

**(F6) 企业家资产负债表**：
$$
Q_{i,t}K_{i,t+1}(e)-N_{i,t+1}(e)=L_{i,t+1}^{H}(e).
$$

企业家在考虑风险项目回报和感知盈利能力后选择资本：

**(F7) 企业家资本选择问题**：
$$
\max_{\{K_{i,t+1}(e)\}}
E_t\left\{
\eta_{i,t+1}^{E}
\left[
g(\bar{\omega}_{i,t+1},\varepsilon_{i,t}^{Q})R_{i,t+1}^{k}Q_{i,t}K_{i,t+1}(e)
-P_{i,t}^{L}(e)L_{i,t+1}^{H}(e)
\right]
\right\}.
$$

### 2.5 家庭

代表性家庭选择消费、工时和债券持有：

**(F8) 家庭效用最大化**：
$$
\max_{\{C_{i,t}(j),H_{i,t}(j),B_{i,t+1}(j)\}}
E_t\sum_{\tau=0}^{\infty}\beta^\tau e^{\varepsilon_{i,t+\tau}^{\beta}}
\left[
\frac{(C_{i,t+\tau}(j)-h_i^c C_{i,t-1+\tau})^{1-\sigma_i^c}}{1-\sigma_i^c}
-\chi_i\frac{H_{i,t+\tau}(j)^{1+\sigma_i^L}}{1+\sigma_i^L}
\right].
$$

**(F9) 家庭预算约束**：
$$
\frac{W_{i,t}^{h}}{P_{i,t}^{c}}H_{i,t}(j)+R_{t-1}\frac{B_{i,t}(j)}{P_{i,t}^{c}}+\frac{\Pi_{i,t}(j)}{P_{i,t}^{c}}
=C_{i,t}(j)+\frac{B_{i,t+1}(j)}{P_{i,t}^{c}}+\frac{T_{i,t}(j)}{P_{i,t}^{c}}+\frac{P_{i,t}}{P_{i,t}^{c}}AC_{i,t}^{B}(j).
$$

### 2.6 工会、企业和资本供应者

工会以 Calvo 黏性和部分指数化设置差异化工资。中间品企业租用劳动和使用后的资本、最小化成本并设置黏性价格。资本供应者在投资调整成本下生产安装资本。

**(F10) 资本供应者问题**：
$$
\max_{\{I_{i,t}(k)\}}E_t\sum_{\tau=0}^{\infty}\beta^\tau
\frac{\lambda_{i,t+\tau}^{c}}{\lambda_{i,t}^{c}}
\left[Q_{i,t}\left(1-AC_{i,t}^{I}(k)\right)-P_{i,t}^{I}\right]I_{i,t}(k).
$$

## 3. First-Order Conditions

### 3.1 银行和贷款聚合

**(F11) 非流动性银行贷款边际成本**：
$$
MC_{i,t}^{ill}=\frac{P_{i,t}^{IB}}{E_t\eta_{i,t+1}}.
$$

**(F12) 同业 CES 需求聚合器**：
$$
IB_{i,t+1}^{d}(b)=
\left[
(1-\alpha_i^{IB})^{1/\xi}IB_{h,i,t+1}^{d}(b)^{(\xi-1)/\xi}
+(\alpha_i^{IB})^{1/\xi}IB_{f,i,t+1}^{d}(b)^{(\xi-1)/\xi}
\right]^{\xi/(\xi-1)}.
$$

**(F13) 同业价格指数**：
$$
P_{i,t}^{IB}=
\left[
(1-\alpha_i^{IB})(R_{h,t}^{IB})^{1-\xi}
+\alpha_i^{IB}(R_{f,t}^{IB})^{1-\xi}
\right]^{1/(1-\xi)}.
$$

**(F14) 按来源划分的同业贷款需求**：
$$
IB_{h,i,t+1}^{d}(b)=(1-\alpha_i^{IB})
\left(\frac{R_{h,t}^{IB}}{P_{i,t}^{IB}}\right)^{-\xi}IB_{i,t+1}^{d}(b),
\quad
IB_{f,i,t+1}^{d}(b)=\alpha_i^{IB}
\left(\frac{R_{f,t}^{IB}}{P_{i,t}^{IB}}\right)^{-\xi}IB_{i,t+1}^{d}(b).
$$

**(F15) 银行资本积累**：
$$
BK_{i,t+1}(b)=(1-\tau^B)\Pi_{i,t}^{B}(b).
$$

**(F16) 流动性银行贷款边际成本**：
$$
MC_{i,t}^{liq}=\frac{R_t}{E_t\eta_{i,t+1}}.
$$

**(F17) 由监测成本决定的同业利率**：
$$
R_{i,t}^{IB}(b)=\chi_i^{IB}\left(IB_{i,t+1}^{s}(b)-\bar{IB}_{i}^{s}(b)\right)+R_t.
$$

**(F18) 企业贷款总边际成本**：
$$
MC_{i,t}^{L}=(MC_{i,t}^{ill})^\lambda(MC_{i,t}^{liq})^{1-\lambda}
=\frac{(P_{i,t}^{IB})^\lambda R_t^{1-\lambda}}{E_t\eta_{i,t+1}}.
$$

**(F19) 对数线性贷款边际成本（`needs_review`）**：
$$
\widehat{mc}_{i,t}^{L}=
\frac{(1-\alpha_i^L)(1-\varkappa_i)\widehat{kn}_{i,t}
+\alpha_i^L(1-\varkappa_j)\widehat{kn}_{j,t}}{1-\bar{N}/\bar{K}}
+(1-\lambda)\widehat{r}_t+\lambda\widehat{p}_{i,t}^{IB}.
$$

**(F20) 黏性实际贷款利率方程（`needs_review`）**：
$$
\hat{r}_{i,t}^{L}=
\frac{
(1+\xi_i^L(1+\beta))\hat{r}_{i,t-1}^{L}
-\xi_i^L\hat{r}_{i,t-2}^{L}
+\beta E_t\hat{r}_{i,t+1}^{L}
+\frac{(1-\theta_i^L)(1-\theta_i^L\beta)}{\theta_i^L}(\widehat{mc}_{i,t}^{L}-\hat{r}_{i,t}^{L})
}{1+\beta(1+\xi_i^L)}
+\varepsilon_{i,t}^{L}.
$$

### 3.2 企业家和金融加速器

**(F21) 企业贷款 CES 聚合器**：
$$
L_{i,t+1}^{d}(e)=
\left[
(1-\alpha_i^L)^{1/\nu}L_{h,i,t+1}^{d}(e)^{(\nu-1)/\nu}
+(\alpha_i^L)^{1/\nu}L_{f,i,t+1}^{d}(e)^{(\nu-1)/\nu}
\right]^{\nu/(\nu-1)}.
$$

**(F22) 企业贷款价格指数**：
$$
P_{i,t}^{L}(e)=
\left[
(1-\alpha_i^L)R_{h,t}^{L}(e)^{1-\nu}
+\alpha_i^LR_{f,t}^{L}(e)^{1-\nu}
\right]^{1/(1-\nu)}.
$$

**(F23) 按来源划分的企业贷款需求**：
$$
L_{h,i,t+1}^{d}(e)=(1-\alpha_i^L)
\left(\frac{R_{h,t}^{L}(e)}{P_{i,t}^{L}(e)}\right)^{-\nu}L_{i,t+1}^{d}(e),
\quad
L_{f,i,t+1}^{d}(e)=\alpha_i^L
\left(\frac{R_{f,t}^{L}(e)}{P_{i,t}^{L}(e)}\right)^{-\nu}L_{i,t+1}^{d}(e).
$$

**(F24) 企业家一期利润**：
$$
\Pi_{i,t+1}^{E}(e)=
\begin{cases}
\bar{\omega}_{i,t+1}R_{i,t+1}^{k}Q_{i,t}K_{i,t+1}(e)-P_{i,t}^{L}(e)L_{i,t+1}^{H}(e), & \text{with probability }\eta_{i,t+1}^{E},\\
0, & \text{with probability }1-\eta_{i,t+1}^{E}.
\end{cases}
$$

**(F25) 感知盈利能力函数**：
$$
g(\bar{\omega}_{i,t+1},\varepsilon_{i,t}^{Q})
=\gamma_i(\bar{\omega}_{i,t+1})^{\varkappa_i/(\varkappa_i-1)}
\left(e^{\varepsilon_{i,t}^{Q}}\right)^{1/(\varkappa_i-1)}.
$$

**(F26) 外部融资溢价**：
$$
S_{i,t}(e)=\frac{E_tR_{i,t+1}^{k}}{P_{i,t}^{L}(e)}
=\gamma_i^{\varkappa_i-1}
\left[
\frac{\kappa}{\kappa-1}
\left(1-\frac{N_{i,t+1}(e)}{Q_{i,t}K_{i,t+1}(e)}\right)
\right]^{\varkappa_i}e^{\varepsilon_{i,t}^{Q}}.
$$

**(F27) 企业家净值积累**：
$$
N_{i,t+1}(e)=(1-\tau^E)\frac{\Pi_{i,t}^{E}(e)}{e^{\varepsilon_{i,t}^{N}}}.
$$

**(F28) 对数线性利差方程**：
$$
\hat{s}_{i,t}=E_t\hat{r}_{i,t+1}^{k}-\hat{p}_{i,t}^{L}
=\varkappa_i\left(\hat{q}_{i,t}+\hat{k}_{i,t+1}-\hat{n}_{i,t+1}\right)+\varepsilon_{i,t}^{Q}.
$$

**(F29) Pareto 附录中的违约阈值**：
$$
\omega_{i,t}^{C}(e)R_{i,t}^{k}Q_{i,t-1}K_{i,t}(e,\omega_{i,t}^{C})
=P_{i,t-1}^{L}(e)L_{i,t}^{H}(e,\omega_{i,t}^{C}).
$$

### 3.3 家庭、工资、企业和资本

**(F30) 家庭欧拉方程（`needs_review`）**：
$$
C_{i,t+1}-(1+h_i^c)C_{i,t}+h_i^cC_{i,t-1}
=\frac{1-h_i^c}{\sigma_i^c}
\left(R_t-\pi_{i,t+1}^{c}+\varepsilon_{i,t+1}^{\beta}-\varepsilon_{i,t}^{\beta}-\chi^B B_{i,t+1}\right).
$$

**(F31) 家庭劳动供给**：
$$
\widehat{W}_{i,t}^{h}=\sigma_i^L\widehat{H}_{i,t}
+\frac{\sigma_i^c}{1-h_i^c}\left(\widehat{C}_{i,t}-h_i^c\widehat{C}_{i,t-1}\right).
$$

**(F32) 黏性工资条件（`needs_review`）**：
$$
(1+\beta)\widehat{W}_{i,t}
=\xi_i^w\pi_{i,t-1}^{c}+\widehat{W}_{i,t-1}
-(1+\beta\xi_i^w)\pi_{i,t}^{c}
+\beta(\widehat{W}_{i,t+1}+\pi_{i,t+1}^{c})
+\frac{(1-\theta_i^w\beta)(1-\theta_i^w)}{\theta_i^w}
(\widehat{W}_{i,t}^{h}-\widehat{W}_{i,t})
+\varepsilon_{i,t}^{W}.
$$

**(F33) 中间品企业边际成本**：
$$
MC_{i,t}=\frac{1}{e^{\varepsilon_{i,t}^{A}}}
\left(\frac{Z_{i,t}}{\alpha}\right)^\alpha
\left(\frac{W_{i,t}}{1-\alpha}\right)^{1-\alpha}.
$$

**(F34) 黏性价格重设条件（`needs_review`）**：
$$
P_{i,t}^{*}=
\frac{\epsilon_p}{(\epsilon_p-1)(1-\tau^y)}
\frac{
E_t\sum_{\tau=0}^{\infty}(\theta_i^p\beta)^\tau
\frac{\lambda_{i,t+\tau}^{c}}{\lambda_{i,t}^{c}}MC_{i,t+\tau}Y_{i,t+\tau}
}{
E_t\sum_{\tau=0}^{\infty}(\theta_i^p\beta)^\tau
\frac{\lambda_{i,t+\tau}^{c}}{\lambda_{i,t}^{c}}
\prod_{k=1}^{\tau}\pi_{i,t+k-1}^{\xi_i^p}Y_{i,t+\tau}
}.
$$

**(F35) Tobin's Q 投资条件**：
$$
Q_{i,t}=P_{i,t}^{I}
+Q_{i,t}\frac{\partial(I_{i,t}AC_{i,t}^{I})}{\partial I_{i,t}}
+\beta E_t\frac{\lambda_{i,t+1}^{c}}{\lambda_{i,t}^{c}}Q_{i,t+1}
\frac{\partial(I_{i,t+1}AC_{i,t+1}^{I})}{\partial I_{i,t}}.
$$

**(F36) 资本预期回报（`needs_review`）**：
$$
\frac{E_tR_{i,t+1}^{k}}{1+P_{i,t}\chi^B(B_{i,t+1}(j)-B_i(j))}
=E_t\left[
\frac{Z_{i,t+1}u_{i,t+1}-P_{i,t+1}\Phi(u_{i,t+1})+(1-\delta)Q_{i,t+1}}{Q_{i,t}}
\right].
$$

**(F37) 资本利用条件**：
$$
\frac{\psi_i}{1-\psi_i}\hat{u}_{i,t}=\hat{z}_{i,t}.
$$

## 4. Market Clearing & Identities

**(F38) 政府预算恒等式**：
$$
P_{i,t}\bar{G}\varepsilon_{i,t}^{G}
=\int_0^1T_{i,t}(j)\,dj+\tau^y\int_0^1P_{i,t}(m)Y_{i,t}(m)\,dm
+\tau^w\int_0^1W_{i,t}(j)H_{i,t}(j)\,dj
+\tau^L\int_0^1L_{i,t+1}^{s}(b)R_{i,t}^{L}(b)\,db
+\tau^E\int_0^1N_{i,t}^{E}(e)\,de
+\tau^B\int_0^1BK_{i,t}(b)\,db.
$$

**(F39) 货币政策规则**：
$$
\frac{R_t}{\bar{R}}=
\left(\frac{R_{t-1}}{\bar{R}}\right)^\rho
\left[
(\pi_{h,t}^{c}\pi_{f,t}^{c})^{\phi^\pi}
\left(\frac{Y_{h,t}Y_{f,t}}{Y_{h,t-1}Y_{f,t-1}}\right)^{\phi^{\Delta y}}
\right]^{\frac{1}{2}(1-\rho)}
e^{\varepsilon_t^R}.
$$

**(F40) 本国资源约束（`needs_review`）**：
$$
\frac{Y_{h,t}}{\Delta_{h,t}^{p}}
=(1-\alpha^C)\left(\frac{P_{h,t}}{P_{h,t}^{c}}\right)^{-\mu}C_{h,t}
+\alpha^C\left(\frac{P_{h,t}}{P_{f,t}^{c}}\right)^{-\mu}C_{f,t}
+(1-\alpha^I)\left(\frac{P_{h,t}}{P_{h,t}^{I}}\right)^{-\mu}(1+AC_{h,t}^{I})I_{h,t}
+\alpha^I\left(\frac{P_{h,t}}{P_{f,t}^{I}}\right)^{-\mu}(1+AC_{f,t}^{I})I_{f,t}
+\bar{G}\varepsilon_{h,t}^{G}+AC_{h,t}^{B}
+(1-\eta_{h,t}^{E})\underline{\omega}_{h,t}Q_{h,t}K_{h,t}
+\Phi(u_{h,t})K_{h,t-1}.
$$

**(F41) 价格指数聚合**：
$$
P_{i,t}^{1-\epsilon_p}
=\theta_i^p(P_{i,t-1}\pi_{i,t-1}^{\xi_i^p})^{1-\epsilon_p}
+(1-\theta_i^p)(P_{i,t}^{*})^{1-\epsilon_p}.
$$

**(F42) 工资指数聚合**：
$$
W_{i,t}^{1/(1-\mu_{i,t}^{w})}
=\theta_i^w\left[W_{i,t-1}(\pi_{i,t-1}^{C})^{\xi_i^w}\right]^{1/(1-\mu_{i,t}^{w})}
+(1-\theta_i^w)(W_{i,t}^{*})^{1/(1-\mu_{i,t}^{w})}.
$$

**(F43) 企业信贷市场出清**：
$$
L_{h,t+1}^{s}=
\left[
(1-\alpha^L)\left(\frac{R_{h,t}^{L}}{P_{h,t}^{L}}\right)^{-\nu}L_{h,t+1}^{d}
+\alpha^L\left(\frac{R_{h,t}^{L}}{P_{f,t}^{L}}\right)^{-\nu}L_{f,t+1}^{d}
\right]\Delta_{h,t}^{L}.
$$

**(F44) 同业市场出清**：
$$
IB_{h,t+1}^{s}=
\frac{\lambda}{1-\lambda}
\left[
(1-\alpha^{IB})\left(\frac{R_{h,t}^{IB}}{P_{h,t}^{IB}}\right)^{-\xi}IB_{h,t+1}^{d}
+\alpha^{IB}\left(\frac{R_{h,t}^{IB}}{P_{f,t}^{IB}}\right)^{-\xi}IB_{f,t+1}^{d}
\right].
$$

**(F45) 国际资产市场出清**：
$$
B_{h,t+1}+B_{f,t+1}=0,\qquad CA_{h,t}+CA_{f,t}=0.
$$

**(F46) 本国经常账户恒等式**：
$$
CA_{h,t}=(B_{h,t+1}-B_{h,t})
+[(L_{h,f,t+1}-L_{h,f,t})-(L_{f,h,t+1}-L_{f,h,t})]
+[(IB_{h,f,t+1}-IB_{h,f,t})-(IB_{f,h,t+1}-IB_{f,h,t})].
$$

## 5. Exogenous Processes

对国家特定扰动 $s \in \{\beta,A,Q,N,L,B\}$：

**(F47) 国家冲击过程**：
$$
\varepsilon_{i,t}^{s}=\rho_i^s\varepsilon_{i,t-1}^{s}+\eta_{i,t}^{s}.
$$

共同货币政策扰动为：

**(F48) 货币政策冲击**：
$$
\varepsilon_t^R=\rho^R\varepsilon_{t-1}^R+\eta_t^R.
$$

政府支出与生产率创新相连：

**(F49) 支出冲击过程**：
$$
\varepsilon_{i,t}^{G}=\rho_i^G\varepsilon_{i,t-1}^{G}+\eta_{i,t}^{G}+\rho_i^{ag}\eta_{i,t}^{A}.
$$

工资加成扰动具有 ARMA 成分：

**(F50) 工资加成冲击过程**：
$$
\varepsilon_{i,t}^{W}=\rho_i^W\varepsilon_{i,t-1}^{W}+\eta_{i,t}^{W}-u_i^W\eta_{i,t-1}^{W}.
$$

实现交叉检查中还对 $s \in \{Q,N,L,B\}$ 加入共同金融创新。

## 6. Steady-State Solution

论文报告季度校准目标，而不是完整的解析稳态推导。下面的第一遍稳态重构遵循论文校准讨论和实现交叉检查；在对照原始代码或运行时稳态文件前均为 `needs_review`。

1. 设定 $\bar{R}=1/\beta$，其中 $\beta=0.995$。
2. 设定实际侧校准目标：$\delta=0.02$、$\alpha=0.25$、$\bar{H}=1/3$、$\bar{G}/\bar{Y}=0.24$，以及资产组合调整成本 $\chi^B=0.0007$。
3. 设定金融目标：$\bar{N}/\bar{K}=0.40$、$\bar{IB}/\bar{L}=0.20$、$\bar{BK}/\bar{L}=0.10$，以及贷款利差 $\bar{R}^L-\bar{R}=0.02/4$。
4. 归一化 $\bar{Q}=1$，并得到 $\bar{R}^L=\bar{R}+0.02/4$。
5. 使用 Pareto 分布条件 $E[\omega]=1$ 和 $\omega_{\min}=(\kappa-1)/\kappa=1-\bar{N}/\bar{K}$ 来确定 (F24)-(F29) 中使用的风险参数。
6. 用资本回报关系以及 $\bar{R}^k$、$\delta$、$\alpha$ 和 $\bar{H}$ 计算 $\bar{K}$；然后设定 $\bar{N}=0.40\bar{K}$ 和 $\bar{L}=\bar{Q}\bar{K}-\bar{N}$。
7. 设定 $\bar{Y}=(\bar{Z}/\alpha)\bar{K}$、$\bar{I}=\delta\bar{K}$，以及 $\bar{C}=(1-\bar{G}/\bar{Y})\bar{Y}-\delta\bar{K}$。
8. 实现交叉检查中设定 $\bar{BK}=0.11\bar{L}$ 和 $\bar{IB}=0.20\bar{L}$；这与论文表格中四舍五入的 $\bar{BK}/\bar{L}=0.10$ 略有差异，是延后核对事项。
9. 在对数线性形式中，带帽变量的稳态为零，而上述水平值和校准比率锚定线性化系数。

## 7. Timing & Form Conventions

- 论文用于估计的均衡为对数线性形式；`.mod` 实现声明 `model(linear)`。
- 核心国家变量使用后缀 `_h`；外围国家变量使用后缀 `_f`；欧元区总量为两个国家区块的平均值。
- 资本需要一期安装。实现中使用 `ku_i = k_i(-1) + u_i`；生产使用滞后且经过利用率调整的资本，而投资决定下一期资本。
- 论文资产负债表 $Q_{i,t}K_{i,t+1}-N_{i,t+1}=L_{i,t+1}^{H}$ 中，企业家贷款和资本定在 $t+1$。
- 企业贷款和同业贷款需求包含外部习惯，在线性实现中表现为贷款需求的滞后项。
- 共同中央银行设定联盟范围的名义利率，对平均消费价格通胀和产出增长作出反应。
- 来源 Markdown 足以支持第一遍推导，因此未打开原始 PDF 正文。

## 8. Variable & Parameter Reference Table

| 类别 | 符号 / 实现名称 | 含义 | 主要方程 |
|---|---|---|---|
| 内生 | $Y_i$ / `y_h`, `y_f` | 产出 | (F33), (F40) |
| 内生 | $C_i$ / `c_h`, `c_f` | 消费 | (F8), (F30), (F40) |
| 内生 | $R$ / `r` | 共同中央银行利率 | (F39), (F48) |
| 内生 | $\pi_i$, $\pi_i^c$ / `pi_h`, `pi_f`, `pic_h`, `pic_f` | 生产者和消费通胀 | (F34), (F41) |
| 内生 | $W_i$, $W_i^h$ / `w_h`, `w_f`, `wh_h`, `wh_f` | 工资和家庭期望工资 | (F31), (F32), (F42) |
| 内生 | $H_i$ / `h_h`, `h_f` | 工时 | (F31), (F33) |
| 内生 | $MC_i$ / `mc_h`, `mc_f` | 商品边际成本 | (F33), (F34) |
| 内生 | $K_i$, $K_i^u$, $u_i$ / `k_h`, `k_f`, `ku_h`, `ku_f`, `u_h`, `u_f` | 资本、使用后资本、资本利用率 | (F35), (F36), (F37) |
| 内生 | $I_i$ / `i_h`, `i_f` | 投资 | (F10), (F35), (F40) |
| 内生 | $Z_i$ / `z_h`, `z_f` | 资本租金成本 | (F33), (F36), (F37) |
| 内生 | $Q_i$ / `q_h`, `q_f` | 资本影子价值 | (F6), (F26), (F35) |
| 内生 | $B_h$, $CA$ / `b_h`, `CA` | 净外国资产和经常账户 | (F45), (F46) |
| 内生 | $N_i^E$ / `n_E_h`, `n_E_f` | 企业家净值 | (F6), (F27), (F28) |
| 内生 | $R_i^k$ / `r_K_h`, `r_K_f` | 资本回报 | (F24), (F26), (F36) |
| 内生 | $L_i^d$, $L_i^s$ / `ld_h`, `ld_f`, `ls_h`, `ls_f` | 企业贷款需求和供给 | (F21), (F43) |
| 内生 | $R_i^L$, $P_i^L$ / `r_L_h`, `r_L_f`, `pl_h`, `pl_f` | 企业贷款利率和 CES 借款成本 | (F20), (F22), (F23) |
| 内生 | $MC_i^L$ / `mcL_h`, `mcL_f` | 贷款边际成本 | (F18), (F19) |
| 内生 | $BK_i$ / `bk_h`, `bk_f` | 银行资本 | (F15) |
| 内生 | $IB_i^d$, $IB_i^s$ / `IBd_h`, `IBd_f`, `IBs_h`, `IBs_f` | 同业需求和供给 | (F12), (F44) |
| 内生 | $R_i^{IB}$, $P_i^{IB}$ / `r_IB_h`, `r_IB_f`, `p_IB_h`, `p_IB_f` | 同业利率和 CES 同业价格 | (F13), (F17) |
| 内生 | $\omega_i^C$ / `omega_h`, `omega_f` | 违约阈值 | (F29) |
| 内生 | $s_i$, $kn_i$ / `s_h`, `s_f`, `nk_h`, `nk_f` | 外部融资利差和资本净值比 | (F26), (F28) |
| 内生 | $ToT$ / `ToT` | 贸易条件 | (F40), (F46) |
| 外生状态 | $\varepsilon_i^A$, $\varepsilon_i^G$, $\varepsilon_i^\beta$, $\varepsilon_i^N$, $\varepsilon_i^Q$, $\varepsilon_i^L$, $\varepsilon_i^W$, $\varepsilon_i^B$, $\varepsilon^R$ | 生产率、支出、偏好、净值、风险、银行利率加成、工资加成、银行负债和货币政策冲击 | (F47)-(F50) |
| 创新 | `e_a_*`, `e_g_*`, `e_beta_*`, `e_n_*`, `e_q_*`, `e_rL_*`, `e_w_*`, `e_ib_*`, `e_r` | 国家、共同金融和货币创新 | (F47)-(F50) |
| 参数 | $\beta,\alpha,\delta,\theta^p,\xi^p,\theta^w,\xi^w,\theta^L,\xi^L,\chi^I,\chi^{IB},\psi,\varkappa,\lambda,\rho,\phi^\pi,\phi^{\Delta y},\alpha^C,\alpha^I,\alpha^L,\alpha^{IB},\mu,\nu,\xi$ | 偏好、技术、名义、金融、开放度和替代弹性参数 | throughout |
