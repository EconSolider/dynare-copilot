# NK_GM07 -- 推导（最优化问题 + 一阶条件）

> MMB 模型 `NK_GM07` 的模型档案条目。
> 来源：Goodfriend and McCallum (2007), "Banking and interest rates in monetary policy analysis: A quantitative exploration", Journal of Monetary Economics 54(5), 1480-1507, DOI `10.1016/j.jmoneco.2007.06.009`。
> 运行验证：未执行。

## 1. Model Overview

- **模型**：带有商品部门、显式竞争性银行部门、交易便利型存款、抵押品以及多个短期利率的新凯恩斯货币模型。
- **主体和部门**：代表性家庭消费 Dixit-Stiglitz 组合品，向商品生产和贷款监控供给劳动，以资本、债券和货币储蓄，生产差异化商品，并经营竞争性银行。政府/中央银行提供货币、债券、税收/转移支付和政策规则。
- **银行机制**：存款为交易提供融资；贷款/存款由监控劳动和来自债券及资本的抵押服务共同生产。这在基准跨期利率、政府债券利率、银行间政策利率和贷款利率之间生成楔子。
- **模型形式**：论文给出非线性优化核心，然后在校准的确定性稳态附近使用对数线性动态系统。MMB 实现是稳态偏离形式的 `model(linear)`。
- **来源记录**：本推导使用 `raw/mmb_mineru/runs/nk_gm07__banking_and_interest_rates_in_monetary_policy_analysis_a_quantitative_ex__cb4ea347/full.md`。原始 PDF 路径存在，但除存在性检查外未读取正文。不存在附录归一化文件。`.agents/skills/dynare-copilot/references/examples/NK_GM07_rep.mod` 仅作为实现交叉检查使用。
- **来源质量**：MinerU 公式总体可读，但 PDF 到 Markdown 转换中有若干 OCR 符号异常。依赖这些位置的方程标为 `needs_review`。

## 2. Optimization Problems

### 代表性家庭 / 商品生产者 / 银行所有者

论文将家庭的消费储蓄、商品生产和银行所有权合并到一个代表性家庭问题中。家庭选择消费、劳动供给、要素需求、资本、债券、货币以及其差异化价格。

\[
\max E_0 \sum_{t=0}^{\infty}\beta^t
\left[
\phi \log c_t + (1-\phi)\log(1-n_t^s-m_t^s)
\right].
\]

家庭面对实际预算约束：

\[
\begin{aligned}
0={}&q_t(1-\delta)K_t+\frac{B_t}{P_t^A}+\frac{H_{t-1}}{P_t^A}
+w_t(n_t^s+m_t^s)+c_t^A\left(\frac{P_t}{P_t^A}\right)^{1-\theta} \\
&-w_t(n_t+m_t)-\frac{H_t}{P_t^A}-tax_t-q_tK_{t+1}
-\frac{B_{t+1}}{P_t^A(1+R_t^B)}-c_t .
\end{aligned}
\]

销售等于净产出的约束为：

\[
K_t^\eta(A1_t n_t)^{1-\eta}
-c_t^A\left(\frac{P_t}{P_t^A}\right)^{-\theta}=0.
\]

交易技术要求存款为消费融资：

\[
c_t=\frac{V D_t}{P_t^A}.
\]

### 竞争性银行部门

银行资产负债表和贷款管理技术为：

\[
H_t+L_t=D_t,
\]

\[
\frac{L_t}{P_t^A}
=F\left(b_{t+1}+A3_t k q_tK_{t+1}\right)^\alpha
\left(A2_t m_t\right)^{1-\alpha},
\qquad 0<\alpha<1 .
\]

抵押品由政府债券和资本组成，资本按抵押效率参数 \(k\) 折价。监控努力 \(m_t\) 是贷款管理的劳动投入。

### 定价和货币政策

弹性价格核心给出加成条件。动态版本用 Calvo 型新凯恩斯 Phillips 曲线替换该条件。货币政策由银行间利率 Taylor 规则或高能货币增长规则表示。

## 3. First-Order Conditions

- **(F1) 流动性/抵押品影子价值定义**：

\[
\Omega_t
=\frac{\alpha c_t}{b_{t+1}+A3_t k q_tK_{t+1}} .
\]

- **(F2) 闲暇-劳动条件**：

\[
\frac{1-\phi}{1-n_t-m_t}=w_t\lambda_t .
\]

- **(F3) 银行监控劳动条件**：

\[
w_t
=\left(\frac{\phi}{c_t\lambda_t}-1\right)
\frac{(1-\alpha)c_t}{m_t}.
\]

- **(F4) 商品劳动需求 / 边际产出条件**：

\[
w_t
=\frac{\xi_t}{\lambda_t}A1_t(1-\eta)
\left(\frac{K}{n_tA1_t}\right)^\eta .
\]

- **(F5) 资本 Euler 条件**（`needs_review`：第二个期望项附近 OCR 有噪声，但经济结构和 MMB 交叉检查均支持资本价格方程）：

\[
\begin{aligned}
0={}&
\left(\frac{\phi}{c_t\lambda_t}-1\right)k\Omega_t q_t-q_t
+\beta(1-\delta)E_t\left(\frac{\lambda_{t+1}}{\lambda_t}q_{t+1}\right) \\
&+\beta\eta E_t\left[
\frac{\lambda_{t+1}\xi_{t+1}}{\lambda_t\lambda_{t+1}}
\left(\frac{A1_{t+1}n_{t+1}}{K}\right)^{1-\eta}
\right].
\end{aligned}
\]

- **(F6) 政府债券 Euler / 流动性服务条件**：

\[
\left(\frac{\phi}{c_t\lambda_t}-1\right)\Omega_t-1
+\beta E_t\left[
\frac{\lambda_{t+1}P_t}{\lambda_tP_{t+1}}(1+R_t^B)
\right]=0 .
\]

- **(F7) 弹性价格加成条件**：

\[
\frac{\xi_t}{\lambda_t}=\frac{\theta-1}{\theta}.
\]

- **(F8) 实际债券存量定义**：

\[
b_{t+1}=\frac{B_{t+1}}{P_t^A(1+R_t^B)} .
\]

- **(F9) 政府预算约束**（`needs_review`：债券分母附近 OCR 歧义保留在 notes 中）：

\[
g_t-tax_t
=\frac{H_t}{P_t^A}-\frac{H_{t-1}}{P_t^A}
+\frac{B_{t+1}}{(1+R_t^B)P_t^A}
-\frac{B_t}{P_t^A}.
\]

- **(F10) 基准跨期利率**：

\[
1+R_t^T
=E_t\frac{\lambda_tP_{t+1}}{\beta\lambda_{t+1}P_t}.
\]

- **(F11) 债券利率与基准利率**：

\[
\frac{1+R_t^B}{1+R_t^T}
=1-\left(\frac{\phi}{c_t\lambda_t}-1\right)\Omega_t .
\]

- **(F12) 流动性服务收益近似式**：

\[
R_t^T-R_t^B=LSY_t^B .
\]

- **(F13) 资本抵押服务收益近似式**：

\[
LSY_t^K=k\,LSY_t^B .
\]

- **(F14) 银行间利差 / 无抵押贷款生产成本**：

\[
(1+R_t^{IB})
\left[
1+\frac{Vw_tm_t}{(1-\alpha)(1-rr)c_t}
\right]
=1+R_t^T .
\]

- **(F15) 无抵押外部融资溢价近似式**：

\[
R_t^T-R_t^{IB}
=\frac{Vw_tm_t}{(1-\alpha)(1-rr)c_t}.
\]

- **(F16) 抵押贷款利率利差**：

\[
(1+R_t^{IB})
\left[
1+\frac{Vw_tm_t}{(1-rr)c_t}
\right]
=1+R_t^L .
\]

- **(F17) 抵押型 EFP 近似式**：

\[
R_t^L-R_t^{IB}
=\frac{Vw_tm_t}{(1-rr)c_t}.
\]

- **(F18) 存款利率关系**：

\[
R_t^D=(1-rr)R_t^{IB}.
\]

## 4. Market Clearing & Identities

- **(F19) 银行资产负债表**：

\[
H_t+L_t=D_t.
\]

- **(F20) 交易/存款恒等式**：

\[
c_t=\frac{V D_t}{P_t^A}.
\]

- **(F21) 贷款生产技术**：

\[
\frac{L_t}{P_t^A}
=F\left(b_{t+1}+A3_t k q_tK_{t+1}\right)^\alpha
\left(A2_t m_t\right)^{1-\alpha}.
\]

- **(F22) 商品生产 / 对称需求恒等式**：

\[
K_t^\eta(A1_t n_t)^{1-\eta}
=c_t^A\left(\frac{P_t}{P_t^A}\right)^{-\theta}.
\]

- **(F23) 动态线性模型中使用的新凯恩斯 Phillips 曲线**：

\[
\Delta p_t=\beta E_t\Delta p_{t+1}+\kappa mc_t+u_t .
\]

- **(F24) 粘性价格模型中的实际边际成本定义**：

\[
mc_t=\frac{\xi_t}{\lambda_t}.
\]

- **(F25) 价格通胀恒等式**：

\[
\Delta \hat p_t=\hat P_t-\hat P_{t-1}.
\]

- **(F26) 线性动态系统中的高能货币恒等式**：

\[
\hat H_t=\hat c_t+\hat P_t.
\]

- **(F27) 线性化 EFP 定义**：

\[
EFP_t=\hat w_t+\hat m_t-\hat c_t.
\]

- **(F28) MMB 实现中使用的债券-消费比固定政策闭合**：

\[
\hat b_t=0.
\]

## 5. Exogenous Processes

- **(F29) 银行间利率 Taylor 规则**：

\[
R_t^{IB}
=(1-\mu_3)\left[
\mu_0+(1+\mu_1)\Delta p_t+\mu_2 mc_t
\right]
+\mu_3R_{t-1}^{IB}+e_t .
\]

- **(F30) 替代的高能货币增长规则**：

\[
\Delta h_t=\rho^H\Delta h_{t-1}+e_t^H .
\]

- **(F31) 商品生产率冲击**：

\[
a1_t=\rho_{a1}a1_{t-1}+\varepsilon_{a1,t}.
\]

- **(F32) 银行监控生产率冲击**：

\[
a2_t=\rho_{a2}a2_{t-1}+\varepsilon_{a2,t}.
\]

- **(F33) 有效抵押品冲击**：

\[
a3_t=\rho_{a3}a3_{t-1}-\varepsilon_{a3,t}.
\]

- **(F34) 货币政策冲击**：

\[
e_t=\varepsilon_{i,t}.
\]

- **(F35) 可选基础货币冲击**：

\[
e_t^H=\varepsilon_{h,t}.
\]

## 6. Steady-State Solution

确定性稳态具有零通胀、去趋势生产率增长 \(\gamma\)、\(q=1\)，以及政策固定的债券-消费比 `boc`。论文将核心稳态模块化简为关于 \(c,m,n,w,\lambda,\Omega,K\) 的七个方程。

- **(F36) 稳态广义流动性 / 贷款生产条件**：

\[
1=\frac{VF}{1-rr}
\left(boc+\frac{kqK}{c}\right)^\alpha
\left(\frac{m}{c}\right)^{1-\alpha}.
\]

- **(F37) 稳态抵押品影子价值**：

\[
\Omega=\frac{\alpha}{boc+kqK/c}.
\]

- **(F38) 稳态闲暇-劳动条件**：

\[
\frac{1-\phi}{1-n-m}=w\lambda .
\]

- **(F39) 稳态监控劳动条件**：

\[
w=\left(\frac{\phi}{\lambda c}-1\right)\frac{(1-\alpha)c}{m}.
\]

- **(F40) 稳态商品劳动条件**：

\[
w=\frac{(\theta-1)(1-\eta)}{\theta}
\left(\frac{K}{n}\right)^\eta .
\]

- **(F41) 稳态资本条件**：

\[
\left(\frac{\phi}{c\lambda}-1\right)k\Omega-1
+\frac{\beta}{1+\gamma}
\left[
1-\delta+\frac{\eta(\theta-1)}{\theta}
\left(\frac{K}{n}\right)^{\eta-1}
\right]=0 .
\]

- **(F42) 稳态资源关系**：

\[
1=\left(\frac{K}{c}\right)^\eta
\left(\frac{n}{c}\right)^{1-\eta}
-\frac{\delta K}{c}.
\]

- **(F43) 稳态基准利率**：

\[
R^T=\frac{1}{\beta(1+\gamma)}-1.
\]

- **(F44) 稳态利率恢复**：

\[
R^B,\;R^{IB},\;R^L,\;R^D
\quad\text{are recovered from (F11), (F15), (F17), and (F18).}
\]

来源报告的基准校准值包括 \(c=0.8409\), \(m=0.0063\), \(n=0.3195\), \(w=1.949\), \(\lambda=0.457\), \(\Omega=0.237\), \(K=9.19\), \(R^T=0.015\), \(R^{IB}=0.0021\), \(R^L=0.0066\), \(R^B=0.0052\), 以及 \(CEFP=0.0045\)。

## 7. Timing & Form Conventions

- 非线性生产方程中的资本 \(K_t\) 在 \(t\) 期期初安装；动态实现使用固定的去趋势稳态资本存量以及前瞻资本价格 \(q_t\)。
- 债券 \(B_{t+1}\) 和实际债券抵押品 \(b_{t+1}\) 是期末资产选择，进入下一期抵押服务。
- 存款 \(D_t\) 和高能货币 \(H_t\) 通过有约束力的存款-消费关系支持当期交易。
- 论文动态系统写为围绕校准稳态的带帽对数偏离，利率和利差除外，它们在实现中作为偏离/利率变量处理。
- 粘性价格版本用新凯恩斯 Phillips 曲线和实际边际成本定义替换弹性价格劳动需求/加成条件。
- 本档案条目未执行运行验证、Dynare 残差检查或 Blanchard-Kahn 诊断。

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Main source equation |
|---|---|---|---|
| Endogenous | `dp` / \(\Delta p_t\) | 通胀 | (F23), (F25) |
| Endogenous | `mc` / \(mc_t\) | 实际边际成本 | (F24) |
| Endogenous | `omega` / \(\Omega_t\) | 抵押品/流动性影子价值 | (F1), (F37) |
| Endogenous | `lambda` / \(\lambda_t\) | 预算乘子 / 财富边际效用 | (F2), (F6) |
| Endogenous | `xi` / \(\xi_t\) | 生产约束乘子 | (F4), (F7) |
| Endogenous | `w` / \(w_t\) | 实际工资 | (F2), (F3), (F4) |
| Endogenous | `n` / \(n_t\) | 商品生产劳动 | (F2), (F4), (F22) |
| Endogenous | `m` / \(m_t\) | 银行监控劳动 | (F3), (F21) |
| Endogenous | `c` / \(c_t\) | 消费 | (F20), (F42) |
| Endogenous | `q` / \(q_t\) | 资本实际价格 | (F5) |
| Endogenous | `p` / \(P_t\) | 价格水平/对数价格 | (F25), (F26) |
| Endogenous | `h` / \(H_t\) | 高能货币 | (F19), (F26) |
| Endogenous | `b` / \(b_t\) | 实际债券/抵押品比率 | (F8), (F28) |
| Endogenous | `a1` | 商品生产率状态 | (F31) |
| Endogenous | `a2` | 银行生产率状态 | (F32) |
| Endogenous | `a3` | 有效抵押品状态 | (F33) |
| Endogenous | `EFP` | 外部融资溢价 | (F15), (F17), (F27) |
| Endogenous | `rT` / \(R^T\) | 基准跨期利率 | (F10), (F43) |
| Endogenous | `rIB` / \(R^{IB}\) | 银行间政策利率 | (F14), (F29) |
| Endogenous | `rL` / \(R^L\) | 抵押贷款利率 | (F16), (F17) |
| Endogenous | `rB` / \(R^B\) | 政府债券利率 | (F6), (F11) |
| Exogenous | `eps_h` | 基础货币增长冲击 | (F35) |
| Exogenous | `eps_a1` | 商品生产率创新 | (F31) |
| Exogenous | `eps_a2` | 银行生产率创新 | (F32) |
| Exogenous | `eps_a3` | 有效抵押品创新 | (F33) |
| Exogenous | `eps_i` | 银行间政策冲击 | (F34) |
| Parameter | `phi` / \(\phi\) | 效用中的消费权重 | utility |
| Parameter | `eta` / \(\eta\) | 商品生产中的资本份额 | (F22) |
| Parameter | `theta` / \(\theta\) | 需求弹性 / 加成参数 | (F7), (F40) |
| Parameter | `beta` / \(\beta\) | 贴现因子 | (F5), (F6), (F43) |
| Parameter | `kappa` / \(\kappa\) | Phillips 曲线斜率 | (F23) |
| Parameter | `alpha` / \(\alpha\) | 贷款生产中的抵押品份额 | (F1), (F21) |
| Parameter | `k` / \(k\) | 资本抵押效率 | (F1), (F13), (F21) |
| Parameter | `delta` / \(\delta\) | 资本折旧 | (F5), (F41), (F42) |
| Parameter | `gamma` / \(\gamma\) | 趋势生产率增长 | (F41), (F43) |
| Parameter | `rr` | 准备金率 | (F14), (F16), (F36) |
| Parameter | `V` | 存款流通速度参数 | (F20), (F36) |
| Parameter | `boc` | 稳态债券-消费比 | (F36), (F37) |
| Parameter | `F` | 贷款生产规模 | (F21), (F36) |
| Parameter | `mu_0, mu_1, mu_2, mu_3` | 政策规则常数 | (F29) |
| Parameter | `rho_h, rho_a1, rho_a2, rho_a3` | 冲击持续性参数 | (F30)-(F33) |
