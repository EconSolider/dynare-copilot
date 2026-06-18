# EA_PV16 -- 推导说明（模型档案第一遍）

来源信息：模型 `EA_PV16`，Priftis and Vogel (2016)，"The Portfolio Balance Mechanism and QE in the Euro Area"，DOI `10.1111/manc.12162`。主要来源：`raw/mmb_mineru/runs/ea_pv16__the_portfolio_balance_mechanism_and_qe_in_the_euro_area__1dbe823d/full.md`。原始 PDF 只检查了文件存在性以记录来源；未读取 PDF 正文。状态：`needs_review`。

## 1. 模型概述

EA_PV16 是 QUEST 开放经济 DSGE 模型的欧元区版本，并加入中央银行资产负债表、短期政府债务、长期政府债券以及资产之间的不完全替代。QE 表示为中央银行购买长期政府债券，并通过向私人部门提供流动性融资。

论文说明每个区域模块包含李嘉图家庭和流动性约束家庭、企业、政府、价格和工资粘性、资本积累、贸易以及与世界其他地区的金融联系。已提取的正文重点给出了 QE 资产组合平衡模块；完整 QUEST 基准模型则指向外部模型文档和论文附录。因此，基准生产、工资和价格设定方程在此作为来源背景列出，完整逐式提取仍为 `needs_review`。

模型形式：非线性水平值和比率形式 DSGE，并在实现中作局部近似。实现交叉检查文件 `EA_PV16_rep.mod` 使用大型非线性 model block、许多一阶差分辅助变量和随机模拟；这里只用于核对变量名和 QE 模块覆盖范围。

## 2. 主体的最优化问题

### 李嘉图家庭

李嘉图家庭选择消费、劳动、物质资本、国内短期债券、国内长期债券和外国债券：

$$
\max L^r = E_0\sum_{t=0}^{\infty}\beta^t U(C_t^r,1-N_t^r)
$$

其约束为来源中的预算约束，包含消费税、资本积累、短期债券购买、带有资产组合调整成本的长期债券购买、带有外部头寸调整成本的外国债券购买、转移、息票和折旧后的长期债券本金、继承的短期和外国债券、工资收入、资本收入和股利：

$$
\begin{aligned}
0={}&
\frac{(1+t_t^c)P_t^C}{P_t}C_t^r
+\frac{P_t^C(K_t-(1-\delta_k)K_{t-1})}{P_t}
+\frac{P_t^N B_t^{L,H}}{P_t}
\left[1+\frac{\gamma_b}{2}\left(\kappa\frac{B_t^S}{B_t^{L,H}}-1\right)^2\right]
+\frac{B_t^S}{(1+i_t)P_t}
+\frac{e_t B_t^{\ast}}{(1+i_t^{\ast})P_t} \\
&+\frac{\gamma_f}{2}\left(\frac{e_t(B_t^{\ast}-\bar B^{\ast})}{P_t}\right)^2
-\frac{TR_t}{P_t}
-\frac{cB_{t-1}^{L,H}}{P_t}
-\frac{\delta_b P_t^N B_{t-1}^{L,H}}{P_t}
-\frac{B_{t-1}^S}{P_t}
-\frac{e_tB_{t-1}^{\ast}}{P_t} \\
&-\frac{(1-t_t^w)W_tN_t^r}{P_t}
-\left(i_{t-1}^k-(i_{t-1}^k-\delta_k)t_{t-1}^k-\varphi_{t-1}\right)
\frac{P_t^C}{P_t}K_{t-1}
-\frac{D_t}{P_t}.
\end{aligned}
$$

跨境扩展加入外国长期债券持有 \(B_t^{L,H\ast}\)，以及围绕本国/外国长期债券组合的二次调整成本：

$$
\frac{e_t P_t^{N\ast}B_t^{L,H\ast}}{P_t}
\left[1+\frac{\gamma_b^{\ast}}{2}\left(\kappa^{\ast}\frac{B_t^{L,H}}{B_t^{L,H\ast}}-1\right)^2\right].
$$

### 流动性约束家庭、企业和政府

论文说明流动性约束家庭消费当期可支配工资和转移收入；中间品生产者使用本地劳动和资本；最终品企业组合国内和进口中间品；工资由垄断竞争工会设定；政府购买商品、转移收入、征税并发行债务。已提取 Markdown 未包含这些 QUEST 模块的完整最优化系统；该缺口为 `needs_review`。

## 3. 一阶条件

以下 F 条件是有来源支持的 QE 和资产组合平衡方程。它们为档案审阅连续编号；标为 `needs_review` 的部分反映 OCR 或附录覆盖限制。

- **(F1) 国内短期债券欧拉方程**：

$$
\beta E_t\left(\frac{\lambda_{t+1}}{\lambda_t}\right)
=E_t\left(\frac{P_{t+1}}{P_t}\right)
\left[
\frac{1}{1+i_t}
+\gamma_b\kappa P_t^N\left(\kappa\frac{B_t^S}{B_t^{L,H}}-1\right)
\right].
$$

- **(F2) 国内长期债券欧拉方程**：

$$
\beta E_t\left(\frac{\lambda_{t+1}}{\lambda_t}\right)
=E_t\left\{
\frac{P_t^N}{\delta_bP_{t+1}^N+c}
\frac{P_{t+1}}{P_t}
\left[
1+\frac{\gamma_b}{2}\left(\kappa\frac{B_t^S}{B_t^{L,H}}-1\right)^2
-\gamma_b\kappa\left(\kappa\frac{B_t^S}{B_t^{L,H}}-1\right)\frac{B_t^S}{B_t^{L,H}}
\right]\right\}.
$$

- **(F3) 外国短期债券欧拉方程**：

$$
\beta E_t\left(\frac{\lambda_{t+1}}{\lambda_t}\right)
=E_t\left(\frac{e_t}{e_{t+1}}\frac{P_{t+1}}{P_t}\right)
\left[
\frac{1}{1+i_t^{\ast}}
+\gamma_f\frac{e_t(B_t^{\ast}-\bar B^{\ast})}{P_t}
\right].
$$

- **(F4) 物质资本回报条件**：

$$
\beta E_t\left(\frac{\lambda_{t+1}}{\lambda_t}\right)
=E_t\left(\frac{P_{t+1}}{P_t}\frac{P_t^C}{P_{t+1}^C}\right)
\frac{1}{(1+i_t^k-\varphi_t-\delta_k)-t_t^k(i_t^k-\delta_k)}.
$$

- **(F5) 消费边际效用条件**：

$$
U_t^C=\frac{(1+t_t^c)P_t^C}{P_t}\lambda_t.
$$

- **(F6) 劳动边际条件**：

$$
U_t^N=\frac{(1-t_t^w)W_t}{P_t}\lambda_t.
$$

- **(F7) QE 渠道：国内资产与外国短期资产**：

$$
\frac{1}{1+i_t}
+\gamma_b\kappa P_t^N\left(\kappa\frac{B_t^S}{B_t^{L,H}}-1\right)
=E_t\left(\frac{e_t}{e_{t+1}}\right)
\left[
\frac{1}{1+i_t^{\ast}}
+\gamma_f\frac{e_t(B_t^{\ast}-\bar B^{\ast})}{P_t}
\right].
$$

- **(F8) QE 渠道：国内资产与资本**：

$$
\frac{1}{1+i_t}
+\gamma_b\kappa P_t^N\left(\kappa\frac{B_t^S}{B_t^{L,H}}-1\right)
=E_t\left(\frac{P_t^C}{P_{t+1}^C}\right)
\frac{1}{(1+i_t^k-\varphi_t-\delta_k)-t_t^k(i_t^k-\delta_k)}.
$$

- **(F9) QE 渠道：国内资产与消费储蓄**：

$$
\frac{1}{1+i_t}
+\gamma_b\kappa P_t^N\left(\kappa\frac{B_t^S}{B_t^{L,H}}-1\right)
=
\beta
\frac{(1+t_t^c)P_t^C U_{t+1}^C}
{(1+t_{t+1}^c)P_{t+1}^C U_t^C}.
$$

- **(F10) 跨境扩展：国内长期债券欧拉条件**：

$$
\beta E_t\left(\frac{\lambda_{t+1}}{\lambda_t}\frac{P_t}{P_{t+1}}\right)
=E_t\left(\frac{P_t^N}{\delta_bP_{t+1}^N+c}\right)
\left[
1+\frac{\gamma_b}{2}\left(\kappa\frac{B_t^S}{B_t^{L,H}}-1\right)^2
-\gamma_b\kappa\left(\kappa\frac{B_t^S}{B_t^{L,H}}-1\right)\frac{B_t^S}{B_t^{L,H}}
+\gamma_b^{\ast}\kappa^{\ast}\left(\kappa^{\ast}\frac{B_t^{L,H}}{B_t^{L,H\ast}}-1\right)
\frac{e_tP_t^{N\ast}}{P_t^N}
\right].
$$

- **(F11) 跨境扩展：外国长期债券欧拉条件**：

$$
\beta E_t\left(\frac{\lambda_{t+1}}{\lambda_t}\frac{P_t}{P_{t+1}}\frac{e_{t+1}}{e_t}\right)
=E_t\left(\frac{P_t^{N\ast}}{\delta_b^{\ast}P_{t+1}^{N\ast}+c^{\ast}}\right)
\left[
1+\frac{\gamma_b^{\ast}}{2}\left(\kappa^{\ast}\frac{B_t^{L,H}}{B_t^{L,H\ast}}-1\right)^2
-\gamma_b^{\ast}\kappa^{\ast}\left(\kappa^{\ast}\frac{B_t^{L,H}}{B_t^{L,H\ast}}-1\right)
\frac{B_t^{L,H}}{B_t^{L,H\ast}}
\right].
$$

## 4. 市场出清与恒等式

- **(F12) 新发行长期债券价格**：

$$
P_t^N=\sum_{n=0}^{T}\frac{\delta_b^n}{(1+i)^{1+n}}c.
$$

- **(F13) 旧长期债券价格**：

$$
P_t^O=\sum_{n=0}^{T-1}\frac{\delta_b^{1+n}}{(1+i)^{1+n}}c.
$$

- **(F14) 旧/新长期债券价格近似关系**：

$$
P_t^O=\delta_b P_t^N.
$$

- **(F15) 政府总债务分解**：

$$
B_t=B_t^L+B_t^S.
$$

- **(F16) 政府债务中长期债券份额固定**：

$$
B_t^L=s^L B_t.
$$

- **(F17) 长期债券国内持有人分解**：

$$
B_t^L=B_t^{L,H}+B_t^{L,CB}.
$$

- **(F18) 含短期和长期债务的政府预算约束**：

$$
\frac{B_t^S}{(1+i_t)P_t}+\frac{P_t^N}{P_t}B_t^L
=\frac{B_{t-1}^S}{P_t}
+\frac{(\delta_bP_t^N+c)B_{t-1}^L}{P_t}
+\frac{PGE_t}{P_t}
-\frac{TAX_t}{P_t}
-\frac{PR_t^{CB}}{P_t}.
$$

- **(F19) 中央银行经营利润**：

$$
PR_t^{CB}=\Delta M_t+cB_{t-1}^{L,CB}
-\left(P_t^N B_t^{L,CB}-\delta_bP_t^N B_{t-1}^{L,CB}\right).
$$

- **(F20) 跨境政府债券分解**：

$$
B_t=B_t^{L,H}+B_t^{L,F}+B_t^{L,CB}+B_t^S.
$$

- **(F21) 含外国长期债券的净外国资产恒等式**：

$$
\begin{aligned}
e_t(B_t^{\ast}+P_t^{N\ast}B_t^{L,H\ast})-P_t^N B_t^{L,F}
={}&(1+i_{t-1}^{\ast})e_tB_{t-1}^{\ast}
+(c^{\ast}+\delta_b^{\ast}P_t^{N\ast})e_tB_{t-1}^{L,H\ast} \\
&-(c+\delta_bP_t^N)e_tB_{t-1}^{L,F}
+P_t^X X_t-P_t^M M_t.
\end{aligned}
$$

最终产出、进口、出口、资本、劳动、粘性价格、粘性工资和财政闭合等基准 QUEST 市场出清方程存在于实现交叉检查中，但未在 Markdown 来源中完整列出。这些方程对于论文侧提取仍为 `needs_review`。

## 5. 外生过程

- **(F22) QE 购买路径**：

$$
B_t^{L,CB}=\rho_{qe}B_{t-1}^{L,CB}+\tau_{qe}\,\widetilde{Y}_t+\varepsilon_t^{qe}
$$

该规则不是论文中的编号方程；它来自 `EA_PV16_rep.mod` 的实现交叉检查，其中 `EA_blcb` 服从带冲击 `EA_eps_qe` 的自回归/政策规则。在与论文附录核对前标记为 `needs_review`。

- **(F23) 常规时期政策规则 / ZLB 模拟约定**：

$$
i_t=\mathcal{T}(\pi_t,\widetilde{Y}_t,i_{t-1},\varepsilon_t^m)
$$

论文说明常规时期货币政策遵循泰勒规则，并且模拟中在初始 ZLB 时段冻结短期政策利率。已提取 Markdown 未给出精确泰勒规则方程，故为 `needs_review`。

实现交叉检查中还包括政府支出、投资、进口、劳动供给、TFP、货币政策、债券风险溢价、汇率风险溢价、投资风险溢价、财政闭合、转移、产能利用、企业价值和工资等冲击。这些名称记录在 `source_manifest.json` 中作为实现覆盖，不作为论文侧方程。

## 6. 稳态求解

来源给出的是校准锚点，而不是完整解析稳态解。长期债券折旧参数由十年季度期限假设得到：

$$
\delta_b=0.975.
$$

政府债务中的长期债券份额设为：

$$
s^L=0.5.
$$

基准资产组合调整参数校准为复制 6 个基点的初始期限溢价下降：

$$
\gamma_b=0.0005.
$$

在跨境扩展中，来源报告：

$$
\gamma_b=0.0001,\qquad \gamma_b^{\ast}=0.0013.
$$

实现交叉检查的稳态值包括 `EA_deltabl=0.975`、`EA_gamb=0.0005`、`EA_sbl=0.5`、`EA_kbl=1`、`EA_pbl=1`、`EA_bl=EA_bs=1.20388124742112` 和 `EA_blcb=0`。这些值只作为实现交叉检查记录。完整 QUEST 模型的稳态推导未包含在论文 Markdown 中，仍为 `needs_review`。

## 7. 时序与形式约定

长期债券支付递减的息票流。第 \(t\) 期新发行债券价格为 \(P_t^N\)；第 \(t-1\) 期发行的债券价格为 \(P_t^O\)，并近似等于 \(\delta_bP_t^N\)。中央银行持有量 \(B_t^{L,CB}\)、私人长期债券持有量 \(B_t^{L,H}\)、短期债券 \(B_t^S\)、资本 \(K_t\) 和外国资产 \(B_t^{\ast}\) 都是存量变量。在家庭预算中，第 \(t\) 期购买作为当期资金用途出现，而继承存量及息票/折旧本金支付带有 \(t-1\) 滞后。

模型是非线性的。实现交叉检查使用水平值、比率、通胀率和一阶差分辅助变量；它不是手工对数线性化的 `model(linear)` 文件。论文模拟中的 QE 是与 ECB 2015 年公告相匹配的外生资产负债表路径，并在 ZLB 区间冻结短期利率。

## 8. 变量与参数对照表

| 类别 | 符号 / 实现名称 | 含义 | 主要来源支持方程 |
|---|---|---|---|
| 内生变量 | \(C_t^r\), `ea_cnlc` | 李嘉图消费 | (F5), (F9) |
| 内生变量 | \(N_t^r\), `ea_l` | 劳动 / 就业 | (F6) |
| 内生变量 | \(\lambda_t\), `ea_lamnlc` | 财富边际价值 | (F1)-(F6) |
| 内生变量 | \(B_t^S\), `EA_bs` | 短期政府债券 | (F1), (F15), (F18) |
| 内生变量 | \(B_t^L\), `EA_bl` | 长期政府债券 | (F15)-(F18), (F20) |
| 内生变量 | \(B_t^{L,H}\), `EA_blnlc` | 私人部门持有的长期债券 | (F2), (F10), (F17), (F20) |
| 内生变量 | \(B_t^{L,CB}\), `EA_blcb` | 中央银行持有的长期债券 | (F17), (F19), (F22) |
| 内生变量 | \(P_t^N\), `EA_pbl` | 长期债券价格 | (F12)-(F14), (F18), (F19) |
| 内生变量 | \(M_t\), `ea_m` | 流动性 / 货币 | (F19) |
| 内生变量 | \(B_t^{\ast}\), `ea_bw` | 外国短期资产头寸 | (F3), (F21) |
| 内生变量 | \(e_t\), `ea_e` | 名义汇率 | (F3), (F7), (F10), (F11), (F21) |
| 内生变量 | \(K_t\), `ea_k` | 私人资本存量 | (F4), (F8) |
| 内生变量 | \(i_t\), `ea_inom` | 短期名义利率 | (F1), (F7)-(F9), (F23) |
| 内生变量 | \(PR_t^{CB}\), `EA_profcb` | 中央银行经营利润 | (F18), (F19) |
| 外生冲击 | \(\varepsilon_t^{qe}\), `EA_eps_qe` | QE 购买冲击 | (F22) |
| 外生冲击 | \(\varepsilon_t^m\), `ea_eps_m` | 货币政策冲击 | (F23) |
| 参数 | \(\beta,\theta\), `ea_theta` | 贴现 / 实现中的贴现参数 | (F1)-(F4), (F10), (F11) |
| 参数 | \(\gamma_b\), `EA_gamb` | 国内长短债组合调整成本 | (F1), (F2), (F7)-(F10) |
| 参数 | \(\gamma_b^{\ast}\) | 本国/外国长期债券调整成本 | (F10), (F11) |
| 参数 | \(\gamma_f\) | 外国资产头寸调整成本 | (F3), (F7) |
| 参数 | \(\kappa,\kappa^{\ast}\), `EA_kbl` | 目标资产比率参数 | (F1), (F2), (F7), (F10), (F11) |
| 参数 | \(\delta_b,\delta_b^{\ast}\), `EA_deltabl` | 长期债券息票折旧率 | (F12)-(F14), (F18), (F21) |
| 参数 | \(s^L\), `EA_sbl` | 政府债务中的长期债券份额 | (F16) |
| 参数 | \(\rho_{qe},\tau_{qe}\), `EA_rhoqe`, `EA_tqe` | QE 购买持续性和响应 | (F22) |

未执行运行时验证。
