# US_CMR14 -- 推导（最优化问题 + 一阶条件）

> MMB 档案首轮抽取。公式状态：`needs_review`；方程来自 AER 论文的 MinerU Markdown 和实现交叉检查，但在线技术附录/PDF 公式没有做源级核验，也没有运行 Dynare。

## 1. Model Overview

- **模型 ID**：`US_CMR14`。
- **论文**：Christiano, Lawrence J.; Motto, Roberto; Rostagno, Massimo (2014), "Risk Shocks", *American Economic Review* 104(1), 27-65, DOI `10.1257/aer.104.1.27`。
- **主来源**：`raw/mmb_mineru/runs/us_cmr14_us_cmr14nofa__risk_shocks__d33971b2/full.md`；原始 PDF 记录为 `raw/mmb_papers/Risk shocks.pdf`。
- **MMB 变体**：带 CEE 式名义刚性和 BGG 式企业家金融摩擦的基准风险冲击模型。论文也讨论了去掉三条金融摩擦方程的 CEE 版本；`US_CMR14` 保留金融加速器和风险新闻冲击块。
- **主体**：最终品聚合者、垄断竞争中间品生产者、劳动聚合者和 Calvo 工资工会、代表性家庭、资本生产者/家庭资本建造部门、企业家、共同基金、政府需求和货币当局。
- **形式**：论文给出非线性和稳定化缩放后的均衡块，但估计使用围绕非随机稳态的一阶对数线性扰动。MMB 文件为非线性 Dynare 语法。本档案记录源侧非线性条件以及论文给出的线性政策/新闻过程方程。总体公式质量为 `needs_review`。
- **运行验证**：未执行；没有运行 Dynare。

## 2. Optimization Problems

### 最终品聚合者

竞争性最终品企业聚合差异化中间品：

\[
Y_t=\left[\int_0^1Y_{jt}^{1/\lambda_{f,t}}\,dj\right]^{\lambda_{f,t}},\qquad 1\leq \lambda_{f,t}<\infty .
\]

### 中间品生产者

中间品企业 \(j\) 租用有效资本服务和同质劳动：

\[
Y_{jt}=
\begin{cases}
\epsilon_tK_{jt}^{\alpha}(z_tl_{jt})^{1-\alpha}-\Phi z_t^{\ast},&
\epsilon_tK_{jt}^{\alpha}(z_tl_{jt})^{1-\alpha}>\Phi z_t^{\ast},\\
0,&\text{otherwise},
\end{cases}
\qquad 0<\alpha<1.
\]

价格服从 Calvo 摩擦。比例 \(1-\xi_p\) 的企业可以重新定价，不能重新定价的企业按下式指数化：

\[
\tilde{\pi}_t=(\pi_t^{target})^\iota(\pi_{t-1})^{1-\iota}.
\]

### 劳动聚合者与垄断工会

劳动聚合者聚合差异化劳动服务：

\[
l_t=\left[\int_0^1h_{it}^{1/\lambda_w}\,di\right]^{\lambda_w},\qquad 1\leq\lambda_w .
\]

每类劳动由垄断工会供给，并服从 Calvo 工资设定。未重设工资按下式指数化：

\[
\tilde{\pi}_{w,t}=(\pi_t^{target})^{\iota_w}(\pi_{t-1})^{1-\iota_w}.
\]

### 代表性家庭与资本建造

家庭选择消费、债券持有、投资和原始资本。偏好为：

\[
E_0\sum_{t=0}^{\infty}\beta^t\zeta_{c,t}
\left[
\log(C_t-bC_{t-1})-\psi_L\int_0^1\frac{h_{it}^{1+\sigma_L}}{1+\sigma_L}\,di
\right].
\]

家庭按照下式建造期末原始资本：

\[
\bar K_{t+1}=(1-\delta)\bar K_t+\left[1-S\left(\zeta_{I,t}I_t/I_{t-1}\right)\right]I_t.
\]

预算约束把名义资源分配给消费、一期期债券、长期债券、投资品和既有资本，资金来源是劳动收入、债券回报、出售原始资本和一次性支付。OCR 版本可用但括号有损坏；税项和长期债券的精确位置标记为 `needs_review`。

### 企业家与共同基金

净值为 \(N\) 的企业家借入 \(B_{t+1}^N\) 并购买原始资本：

\[
Q_{\bar K,t}\bar K_{t+1}^N=N+B_{t+1}^N.
\]

特质生产率 \(\omega\) 服从均值为 1 的对数正态分布，\(\log\omega\) 的截面标准差 \(\sigma_t\) 随时间变化。债务合约由杠杆 \(L_t\) 和违约阈值 \(\bar\omega_{t+1}\) 表示：

\[
L_t=\frac{Q_{\bar K,t}\bar K_{t+1}^N}{N}.
\]

企业家在共同基金零利润和 costly monitoring 条件下最大化下一期预期净值。共同基金竞争性地向家庭支付无风险名义回报。

### 政府和货币当局

政府消费在经济趋势缩放后为外生。货币当局遵循论文给出的线性化短期利率规则，包含利率平滑、预期通胀目标缺口、产出增长和货币政策创新。

## 3. First-Order Conditions

**生产、价格和工资**

- **(F1) 最终品对中间品的需求**（`needs_review`；由源方程 1 推出）：

\[
Y_{jt}=\left(\frac{P_{jt}}{P_t}\right)^{-\lambda_{f,t}/(\lambda_{f,t}-1)}Y_t .
\]

- **(F2) 有效资本需求/租金率**（`needs_review`；论文给出技术，实现交叉检查提供稳定化条件）：

\[
r_t^k=\alpha\epsilon_t
\left(\frac{\Upsilon\mu_{z,t}^{\ast}h_t(w_t^{\ast})^{\lambda_w/(\lambda_w-1)}}{u_t\bar k_{t-1}}\right)^{1-\alpha}s_t .
\]

- **(F3) 边际成本**（`needs_review`；仅用实现交叉检查确认缩放）：

\[
s_t=\frac{(r_t^k/\alpha)^\alpha(\tilde w_t/(1-\alpha))^{1-\alpha}}{\epsilon_t}.
\]

- **(F4) 重设价格的价格指数递推**（`needs_review`；论文给出 Calvo/指数化，公式仅与 `.mod` 交叉检查）：

\[
p_t^{\ast}=\left[(1-\xi_p)\left(\frac{K_{p,t}}{F_{p,t}}\right)^{\lambda_{f,t}/(1-\lambda_{f,t})}
\xi_p\left(\frac{\tilde\pi_t}{\pi_t}p_{t-1}^{\ast}\right)^{\lambda_{f,t}/(1-\lambda_{f,t})}\right]^{(1-\lambda_{f,t})/\lambda_{f,t}} .
\]

- **(F5) 价格辅助变量 \(F_p\) 递推**（`needs_review`；实现交叉检查）：

\[
F_{p,t}=\zeta_{c,t}\lambda_{z,t}Y_{z,t}
\left(\frac{\tilde\pi_{t+1}}{\pi_{t+1}}\right)^{1/(1-\lambda_{f,t+1})}\beta\xi_pF_{p,t+1}.
\]

- **(F6) 价格辅助变量 \(K_p\) 递推**（`needs_review`；实现交叉检查）：

\[
K_{p,t}=\zeta_{c,t}\lambda_{f,t}\lambda_{z,t}Y_{z,t}s_t
\beta\xi_p\left(\frac{\tilde\pi_{t+1}}{\pi_{t+1}}\right)^{\lambda_{f,t+1}/(1-\lambda_{f,t+1})}K_{p,t+1}.
\]

- **(F7) 稳定化产出定义**（`needs_review`；源生产方程加实现缩放）：

\[
Y_{z,t}=(p_t^{\ast})^{\lambda_f/(\lambda_f-1)}
\left[
\epsilon_t\left(\frac{u_t\bar k_{t-1}}{\mu_{z,t}^{\ast}\Upsilon}\right)^\alpha
\left(h_t(w_t^{\ast})^{\lambda_w/(\lambda_w-1)}\right)^{1-\alpha}
-\phi
\right].
\]

- **(F8) 重设工资指数**（`needs_review`；论文给出 Calvo 工资设定，实现交叉检查提供递推）：

\[
w_t^{\ast}=\left[(1-\xi_w)A_{w,t}^{\lambda_w}
\xi_w\left(\frac{\tilde\pi_{w,t}}{\pi_{w,t}}(\mu_{z^{\ast}})^{1-\iota_\mu}(\mu_{z^{\ast},t})^{\iota_\mu}w_{t-1}^{\ast}\right)^{\lambda_w/(1-\lambda_w)}\right]^{(1-\lambda_w)/\lambda_w}.
\]

- **(F9) 工资辅助变量 \(F_w\) 递推**（`needs_review`；实现交叉检查）：

\[
F_{w,t}=\zeta_{c,t}\lambda_{z,t}(w_t^{\ast})^{\lambda_w/(\lambda_w-1)}h_t\frac{1-\tau^l}{\lambda_w}
\beta\xi_wE_t[\mathcal I^F_{w,t+1}F_{w,t+1}].
\]

- **(F10) 工资辅助变量 \(K_w\) 递推**（`needs_review`；实现交叉检查）：

\[
K_{w,t}=\zeta_{c,t}\left[(w_t^{\ast})^{\lambda_w/(\lambda_w-1)}h_t\right]^{1+\sigma_L}
\beta\xi_wE_t[\mathcal I^K_{w,t+1}K_{w,t+1}].
\]

**家庭、资本和利用率**

- **(F11) 家庭消费边际效用**（`needs_review`；源偏好方程 7 和 `.mod`）：

\[
(1+\tau^c)\zeta_{c,t}\lambda_{z,t}
=\frac{\mu_{z,t}^{\ast}\zeta_{c,t}}{c_t\mu_{z,t}^{\ast}-bc_{t-1}}
-b\beta E_t\left[\frac{\zeta_{c,t+1}}{c_{t+1}\mu_{z,t+1}^{\ast}-bc_t}\right].
\]

- **(F12) 一期债券欧拉方程**（`needs_review`；源预算方程 8 和 `.mod`）：

\[
\zeta_{c,t}\lambda_{z,t}
=\beta E_t\left[\frac{\zeta_{c,t+1}\lambda_{z,t+1}}{\mu_{z,t+1}^{\ast}\pi_{t+1}}\left(1+(1-\tau^d)R_t^e\right)\right].
\]

- **(F13) 资本利用率条件**（`needs_review`；源利用率成本函数）：

\[
r_t^k=\tau_t^{oil}a'(u_t),\qquad
a(u)=r^k\frac{\exp[\sigma_a(u-1)]-1}{\sigma_a}.
\]

- **(F14) 资本回报率**（`needs_review`；源方程 10，稳定化缩放来自实现）：

\[
1+R_t^k=
\frac{\left[(1-\tau^k)(u_tr_t^k-\tau_t^{oil}a(u_t))+(1-\delta)q_t\right]\pi_t}{\Upsilon q_{t-1}}
+\tau^k\delta .
\]

- **(F15) 资本积累**（`needs_review`；源方程 6，稳定化缩放来自实现）：

\[
\bar k_t=(1-\delta)\frac{\bar k_{t-1}}{\mu_{z,t}^{\ast}\Upsilon}
+\left[1-S\left(\zeta_{I,t}\mu_{z,t}^{\ast}\Upsilon I_t/I_{t-1}\right)\right]I_t .
\]

- **(F16) 投资 FOC / 资本供给价格**（`needs_review`；源调整成本函数和 `.mod`）：

\[
0=-\frac{\zeta_{c,t}\lambda_{z,t}}{\mu_{\Upsilon,t}}
+\zeta_{c,t}\lambda_{z,t}q_t\left[1-S_t-S_t'x_t\right]
+\beta E_t\left[\frac{\zeta_{c,t+1}\lambda_{z,t+1}q_{t+1}S_{t+1}'x_{t+1}^2}{\mu_{z,t+1}^{\ast}\Upsilon}\right].
\]

**金融合约**

- **(F17) 净值加总**（源方程 9）：

\[
N_{t+1}=\int_0^\infty N f_t(N)\,dN.
\]

- **(F18) 违约阈值**（源方程 11）：

\[
R_{t+1}^k\bar\omega_{t+1}Q_{\bar K,t}\bar K_{t+1}^N=B_{t+1}^NZ_{t+1}.
\]

- **(F19) 企业家目标值**（源方程 12）：

\[
E_t\left[1-\Gamma_t(\bar\omega_{t+1})\right]R_{t+1}^kL_tN .
\]

- **(F20) 合约份额函数**（源方程 12 后）：

\[
\Gamma_t(\bar\omega_{t+1})=[1-F_t(\bar\omega_{t+1})]\bar\omega_{t+1}+G_t(\bar\omega_{t+1}),\qquad
G_t(\bar\omega_{t+1})=\int_0^{\bar\omega_{t+1}}\omega\,dF_t(\omega).
\]

- **(F21) 共同基金零利润约束**（源方程 14）：

\[
\Gamma_t(\bar\omega_{t+1})-\mu G_t(\bar\omega_{t+1})
=\frac{L_t-1}{L_t}\frac{R_t}{R_{t+1}^k}.
\]

- **(F22) 标准债务合约最优性**（`needs_review`；论文说明该条件存在，详细清单在在线附录/代码中）：

\[
0=E_t\left\{
[1-\Gamma_t(\bar\omega_{t+1})]\frac{1+R_{t+1}^k}{1+R_t^e}
+\frac{\Gamma_t'(\bar\omega_{t+1})}{\Gamma_t'(\bar\omega_{t+1})-\mu G_t'(\bar\omega_{t+1})}
\left[
\frac{1+R_{t+1}^k}{1+R_t^e}\left(\Gamma_t(\bar\omega_{t+1})-\mu G_t(\bar\omega_{t+1})\right)-1
\right]
\right\}.
\]

- **(F23) 企业家购买的总资本**（源方程 15）：

\[
\bar K_{t+1}=\int_0^\infty \bar K_{t+1}^N f_t(N)\,dN.
\]

- **(F24) 总资本服务**（源方程 16）：

\[
K_t=\int_0^\infty\int_0^\infty u_t^N\omega\bar K_t^N f_{t-1}(N)\,dF(\omega)\,dN
=u_t\bar K_t.
\]

- **(F25) 企业家净值运动方程**（源方程 17）：

\[
N_{t+1}=\gamma_t\left[1-\Gamma_{t-1}(\bar\omega_t)\right]R_t^kQ_{\bar K,t-1}\bar K_t+W_t^e.
\]

- **(F26) 企业家总信用**（源方程 17 后）：

\[
B_{t+1}=Q_{\bar K,t}\bar K_{t+1}-N_{t+1}.
\]

- **(F27) 企业家贷款利率**（源方程 17 后）：

\[
Z_{t+1}=R_{t+1}^k\bar\omega_{t+1}L_t.
\]

## 4. Market Clearing & Identities

- **(F28) 资源约束**（`needs_review`；论文侧公式，稳定化/缩放未完全修复）：

\[
Y_t=D_t+G_t+C_t+\frac{I_t}{\Upsilon^t\mu_{\Upsilon,t}}+a(u_t)\Upsilon^{-t}\bar K_t.
\]

- **(F29) 监控资源成本**（`needs_review`；论文 OCR 中价格/缩放记号有歧义）：

\[
D_t=\mu G(\bar\omega_t)(1+R_t^k)\frac{Q_{\bar K,t-1}\bar K_t}{P_t}.
\]

- **(F30) 政府消费缩放**（源方程 19）：

\[
G_t=z_t^{\ast}g_t.
\]

- **(F31) 长期名义债券测度关系**（源 Section ID）：

\[
(R_t^L)^{40}=(\tilde R_t^L)^{40}\eta_{t+1}\cdots\eta_{t+40}.
\]

## 5. Exogenous Processes

- **(F32) 带新闻的通用冲击过程**（源方程 20）：

\[
x_t=\rho_xx_{t-1}+\xi_{0,t}+\xi_{1,t-1}+\cdots+\xi_{p,t-p}.
\]

对 `US_CMR14`，基准信息结构把新闻放在风险 \(\sigma_t\) 上，MMB 实现包含 0 到 8 期的风险新闻。

- **(F33) 新闻冲击相关结构**（源方程 21）：

\[
\rho_{x,n}^{|i-j|}
=\frac{E[\xi_{i,t}\xi_{j,t}]}
{\sqrt{E[\xi_{i,t}^2]E[\xi_{j,t}^2]}},
\qquad i,j=0,\ldots,p.
\]

- **(F34) 货币政策规则**（源方程 18；线性化）：

\[
R_t-R=\rho_p(R_{t-1}-R)
+(1-\rho_p)\left[
\alpha_\pi(\pi_{t+1}-\pi_t^{\ast})
+\alpha_{\Delta y}\frac{1}{4}(g_{y,t}-\mu_{z^{\ast}})
\right]
+\frac{1}{400}\varepsilon_t^p.
\]

- **(F35) 特质风险分布**（`needs_review`；源文本）：

\[
\log\omega\sim\mathcal N\left(-\frac{\sigma_t^2}{2},\sigma_t^2\right),\qquad E[\omega]=1.
\]

估计模型中的其他外生过程包括 term premium、暂时技术、持久增长、价格加成、通胀目标、消费偏好、投资品特定技术、投资边际效率、企业家转移率、政府支出和风险的对数偏离 AR(1)。论文说明它们为 AR(1)，但只展示通用表示和若干参数值。

## 6. Steady-State Solution

来源模型是带增长的估计模型。完整数值稳态重构留待后续。源支持的稳态限制和目标如下：

1. 模型在按 \(z_t^{\ast}\) 缩放后平稳；该平衡增长对象结合了中性技术增长和投资品特定增长。
2. 投资调整在稳态满足 \(S(x)=S'(x)=0\)，利用率归一化为 \(u=1\)。
3. 季度校准参数包括 \(\beta=0.9987\)、\(\delta=0.025\)、\(\alpha=0.40\)、\(\lambda_f=1.20\)、\(\lambda_w=1.05\)、\(\psi_L=0.7705\)、\(\tau^c=0.05\)、\(\tau^k=0.32\)、\(\tau^l=0.24\)、\(1-\gamma=1-0.985\) 和 \(W^e=0.005\)。
4. 政府支出与 GDP 比率目标为 \(\eta_g=0.20\)。
5. 稳态年度通胀目标为 2.43 percent，论文表 3 中短期无风险利率目标约为 4.67 percent APR。
6. 稳态违约概率 \(F(\bar\omega)\) 被估计，其后验众数为 0.0056；后验众数参数隐含的稳态风险水平约为 \(\sigma=0.26\)。
7. 实现交叉检查报告的稳态值包括 `q=1`、`u=1`、`gamma=0.985`、`sigma=0.259199`、`omegabar=0.500971`、`muzstar=1.00412` 和 `pi=1.00601`。这些值仅记录为 `implementation_cross_check`。

状态：`needs_review`。审阅者在把本条目用于可运行实现之前，应从在线附录/代码重构完整稳定化稳态。

## 7. Timing & Form Conventions

- 资本时序：\(\bar K_{t+1}\) 在第 \(t\) 期生产之后建造，并在第 \(t+1\) 期使用；MMB 实现中 `kbar(-1)` 出现在第 \(t\) 期生产和回报中。
- 企业家净值时序：\(N_{t+1}\) 在第 \(t\) 期回报、转移和合约结算之后确定；它约束下一期信用和原始资本购买。
- 风险时序：第 \(t\) 期购买资本的企业家面对特质分散度 \(\sigma_t\)，对应下一期生产/偿付期实现的 \(\omega\)。MMB 实现在若干违约份额函数中使用滞后的 `sigma(-1)`，并在合约最优性中使用未来 \(\sigma\)。
- 货币政策规则：论文直接以线性化净利率形式展示。
- 模型形式：源均衡为非线性/稳定化缩放；估计和许多报告实验使用一阶扰动。标记为 `needs_review`，因为若干条件的完整清单只在在线附录/代码中，而不在正文中。
- `.mod` 使用：`.agents/skills/dynare-copilot/references/examples/US_CMR14_rep.mod` 只用于交叉检查变量覆盖、时序和冲击名称。未运行 Dynare。

## 8. Variable & Parameter Reference Table

| 类别 | 符号 / ASCII | 含义 | 主要方程 |
|---|---|---|---|
| 内生 | `Y`, `yz` | 最终产出 / 稳定化产出 | (F1), (F7), (F28) |
| 内生 | `Y_j` | 中间品产出 | (F1), (F7) |
| 内生 | `P_j`, `pstar`, `pi` | 个别/重设价格和通胀 | (F4)-(F6), (F34) |
| 内生 | `s` | 实际边际成本 | (F2), (F3) |
| 内生 | `l`, `h`, `wstar`, `wtilde` | 劳动总量、工时、重设工资、工资指数 | (F8)-(F10) |
| 内生 | `c` | 消费 | (F11), (F28) |
| 内生 | `lambdaz` | 边际效用乘子 | (F11), (F12) |
| 内生 | `i` | 投资 | (F15), (F16), (F28) |
| 内生 | `q` | 原始资本价格 | (F16), (F18), (F25), (F26) |
| 内生 | `kbar`, `K` | 原始资本和有效资本服务 | (F15), (F23), (F24) |
| 内生 | `u` | 利用率 | (F13), (F14), (F24) |
| 内生 | `rk`, `Rk` | 资本租金和总回报 | (F13), (F14), (F18), (F22) |
| 内生 | `n` | 企业家净值 | (F17), (F25), (F26) |
| 内生 | `omegabar` | 违约阈值 | (F18), (F20)-(F22), (F27) |
| 内生 | `B`, `credit_obs` | 企业家信用 | (F26) |
| 内生 | `Re`, `R`, `Z` | 无风险和企业家债务回报 | (F12), (F21), (F27), (F34) |
| 内生 | `RL`, `rL` | 长期名义/实际利率 | (F31) |
| 内生 | `D` | 监控资源成本 | (F28), (F29) |
| 内生 | `premium_obs`, `Spread1_obs` | 信用利差观测量 | (F21), (F27) |
| 外生 | `e_sigma`, `e_xi1`...`e_xi8` | 非预期和预期风险新闻创新 | (F32), (F33) |
| 外生 | `e_epsil` | 暂时技术创新 | (F2), (F7), AR(1) |
| 外生 | `e_g` | 政府支出创新 | (F30), AR(1) |
| 外生 | `e_gamma` | 权益/企业家转移冲击 | (F25), AR(1) |
| 外生 | `e_lambdaf` | 价格加成冲击 | (F1), (F4)-(F7), AR(1) |
| 外生 | `e_muup` | 投资品价格冲击 | (F15), (F16), AR(1) |
| 外生 | `e_muzstar` | 平衡增长冲击 | (F7), (F11), (F12), (F15) |
| 外生 | `e_pitarget` | 通胀目标冲击 | (F3), (F8), (F34) |
| 外生 | `e_term` | term premium 测度冲击 | (F31) |
| 外生 | `e_zetac`, `e_zetai` | 偏好和投资边际效率冲击 | (F11), (F15), (F16) |
| 外生 | `e_xp` | 货币政策创新 | (F34) |
| 参数 | `beta`, `b`, `psiL`, `sigmaL` | 家庭贴现、习惯、劳动负效用 | (F11), (F12) |
| 参数 | `alpha`, `delta`, `lambda_f`, `lambda_w` | 生产、折旧、商品/劳动加成 | (F1)-(F10), (F15) |
| 参数 | `xi_p`, `xi_w`, `iota`, `iota_w`, `iota_mu` | Calvo 价格/工资和指数化参数 | (F4)-(F10) |
| 参数 | `mu`, `gamma`, `we`, `sigma_a`, `Sdoupr` | 监控成本、企业家存活/转移、利用率和投资调整成本 | (F13), (F16), (F20)-(F25) |
| 参数 | `rho_*`, `std*`, `signal_corr` | 冲击持续性、标准差、风险新闻相关 | (F32), (F33) |
| 参数 | `rho_p`, `alpha_pi`, `alpha_Delta_y` | 货币政策平滑和反应系数 | (F34) |
| 参数 | `tau_c`, `tau_k`, `tau_l`, `tau_d`, `tau_o` | 税和利用率/oil 楔子 | (F11)-(F14) |
