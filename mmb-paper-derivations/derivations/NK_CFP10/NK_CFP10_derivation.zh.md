# NK_CFP10 -- 推导（最优化问题 + 均衡条件）

> 状态：`needs_review`。本首轮归档条目由 Carlstrom、Fuerst 和 Paustian (2010) 的 MinerU Markdown 来源抽取。核心模型的 OCR 基本可读，但若干附录公式仍有噪声，且未执行运行时验证。

来源：Charles T. Carlstrom, Timothy S. Fuerst, and Matthias Paustian (2010), "Optimal monetary policy in a model with agency costs," *Journal of Money, Credit and Banking* 42(s1), 37-70. DOI: `10.1111/j.1538-4616.2010.00329.x`。

## 1. 模型概述

- **模型**：`NK_CFP10`，一个小型对数线性新凯恩斯模型，代理成本通过约束某一种生产性劳动投入的抵押约束表示。
- **主体**：家庭、生产中间品的企业家、带 Rotemberg 调价成本的垄断竞争最终品厂商，以及货币当局。
- **金融摩擦**：企业家必须用净值和经营利润抵押来支持受约束投入 \(L_t\) 的工资账单。乘数 \(b\phi_t\) 被解释为信用扭曲或风险溢价的代理变量。
- **冲击**：技术冲击、加成冲击、企业家净值冲击和货币政策冲击。
- **形式**：论文建立了非线性原始条件，但 MMB 实现和约化系统是围绕确定性稳态的百分比偏离形式 `model(linear)`。带帽变量表示对数偏离。运行时验证：未执行。

## 2. 最优化问题

### 2.1 家庭

家庭选择消费、两种劳动投入、一期间债券和股权份额。期效用为：

\[
U(C_t,L_t,u_t)=\frac{C_t^{1-\sigma}}{1-\sigma}
-B_1\frac{L_t^{1+\theta}}{1+\theta}
-B_2\frac{u_t^{1+\theta}}{1+\theta}.
\]

论文的模型部分报告家庭最优性条件，而不是完整预算约束。家庭以价格 \(w_t\) 和 \(r_t\) 供给受约束劳动 \(L_t\) 和非受约束劳动 \(u_t\)，用总名义回报 \(R_t\) 为名义债券定价，并为支付股利 \(D_t\) 的股权份额 \(Q_t\) 定价。

### 2.2 企业家

企业家具备线性消费偏好，并使用两种劳动投入按 CRS 技术生产中间品：

\[
x_t=L_t^\alpha u_t^{1-\alpha}.
\]

其经营利润为：

\[
\text{profits}_t=p_t x_t-w_tL_t-r_tu_t.
\]

受约束投入 \(L_t\) 的雇佣受到绑定抵押约束：

\[
w_tL_t \leq nw_t^b\left(p_tx_t-r_tu_t\right)^{1-b},
\]

其中净值为 \(nw_t=e_{t-1}(Q_t+D_t)\)。该约束的拉格朗日乘数为 \(\phi_t\)。

企业家预算约束为：

\[
c_t^e+e_tQ_t \leq e_{t-1}(Q_t+D_t)+\text{profits}_t.
\]

由于企业家具有线性偏好，并且内部资金可放松未来约束，论文考虑的均衡中，企业家在意外死亡/退出转移之前的消费为零。

### 2.3 黏性价格最终品厂商

最终品厂商聚合差异化商品，并线性使用中间品，\(y_{t,j}=a_tx_{t,j}\)。实际边际成本为：

\[
z_t=\frac{p_t}{a_t}.
\]

Rotemberg 调价成本在均衡中生成线性新凯恩斯菲利普斯曲线。最终品厂商股利为：

\[
D_t=a_tx_t(1-z_t).
\]

### 2.4 货币当局

论文研究承诺下的最优政策和简单利率规则。MMB 实现使用对通胀和产出缺口作出反应的 Taylor 规则，并加入持久性货币政策冲击。

## 3. 一阶条件（FOC）

以下归档方程结合了论文的非线性模型条件和 `NK_CFP10` 使用的对数线性约化系统。凡在 `extraction_notes.md` 中标记 OCR 问题的方程均应视为 `needs_review`。

- **(F1) 家庭对受约束投入的劳动供给**：

\[
\frac{U_L(t)}{U_c(t)}=w_t(1+w_{\mathrm{sub}}).
\]

- **(F2) 家庭对非受约束投入的劳动供给**：

\[
\frac{U_u(t)}{U_c(t)}=r_t(1+r_{\mathrm{sub}}).
\]

- **(F3) 家庭债券 Euler / Fisher 条件**：

\[
U_c(t)=E_t\left[\beta U_c(t+1)\frac{R_t}{\pi_{t+1}}\right].
\]

- **(F4) 家庭股权定价条件**：

\[
Q_tU_c(t)=E_t\left[\beta U_c(t+1)(Q_{t+1}+D_{t+1})\right].
\]

- **(F5) 企业家对受约束劳动的 FOC**：

\[
\alpha p_tx_t=w_tL_t(1+b\phi_t).
\]

- **(F6) 企业家对非受约束劳动的 FOC**：

\[
(1-\alpha)p_tx_t=r_tu_t.
\]

- **(F7) 绑定抵押约束，改写为信用扭曲**：

\[
1+b\phi_t=\left(\frac{\alpha p_tx_t}{nw_t}\right)^b.
\]

- **(F8) 企业家利润恒等式**：

\[
\text{profits}_t=\alpha p_tx_t-w_tL_t
=\alpha p_tx_t\left(\frac{b\phi_t}{1+b\phi_t}\right).
\]

- **(F9) \(L_t\) 的线性家庭劳动条件**：

\[
\sigma\hat y_t+\theta\hat L_t=\hat w_t.
\]

- **(F10) \(u_t\) 的线性家庭劳动条件**：

\[
\sigma\hat y_t+\theta\hat u_t=\hat r_t.
\]

- **(F11) 线性跨期 Euler 条件**：

\[
\sigma(E_t\hat y_{t+1}-\hat y_t)=\hat R_t-E_t\hat\pi_{t+1}.
\]

- **(F12) 线性股权定价方程**（`needs_review`：OCR 在最后括号中显示出不一致的当期产出项）：

\[
\hat q_t=\beta E_t\hat q_{t+1}+(1-\beta)E_t\hat d_{t+1}
-\sigma(E_t\hat y_{t+1}-\hat y_t).
\]

- **(F13) 企业家股权价值恒等式**：

\[
\hat e_t+\hat q_t=\hat z_t+\hat y_t+\Lambda\hat\phi_t,
\qquad \Lambda\equiv\frac{F'}{F}\approx b-1\leq 0.
\]

- **(F14) 线性抵押约束**：

\[
\hat w_t+\hat L_t
=b(\hat e_{t-1}+\beta\hat q_t+(1-\beta)\hat d_t+\hat n_t)
+(1-b)(\hat z_t+\hat y_t).
\]

- **(F15) 线性生产函数**：

\[
\hat y_t=\hat a_t+(1-\alpha)\hat u_t+\alpha\hat L_t.
\]

- **(F16) Rotemberg 菲利普斯曲线**：

\[
\hat\pi_t=\lambda\hat z_t+\beta E_t\hat\pi_{t+1}+\lambda\epsilon_t^\pi,
\qquad \lambda=\frac{\varepsilon-1}{\varphi}.
\]

- **(F17) 股利方程**：

\[
\hat d_t=\hat y_t-(\varepsilon-1)\hat z_t.
\]

- **(F18) 线性信用扭曲恒等式**：

\[
b\hat\phi_t=\hat z_t+\hat y_t-\hat w_t-\hat L_t.
\]

## 4. 市场出清与恒等式

- **(F19) 有效产出与产出缺口**：

\[
\hat y_t^{\mathrm{eff}}=\frac{1+\theta}{\sigma+\theta}\hat a_t,
\qquad
\hat y_t^g=\hat y_t-\hat y_t^{\mathrm{eff}}.
\]

- **(F20) 产出缺口与边际成本、信用扭曲的关系**：

\[
\hat y_t^g=\frac{1}{\sigma+\theta}\hat z_t
-\frac{\alpha}{\sigma+\theta}b\hat\phi_t.
\]

- **(F21) 产出缺口形式的菲利普斯曲线**：

\[
\hat\pi_t=\lambda(\sigma+\theta)\hat y_t^g
+\alpha\lambda b\hat\phi_t
+\beta E_t\hat\pi_{t+1}
+\lambda\epsilon_t^\pi.
\]

- **(F22) MMB 实现中使用的 Taylor 规则**：

\[
\hat R_t=\tau\hat\pi_t+\tau_g\hat y_t^g+\epsilon_t^R.
\]

该模型没有资本积累模块。股权持有、股权价格、股利和企业家净值是代理成本传播所依赖的状态变量。

## 5. 外生过程

- **(F23) 技术过程**：

\[
\hat a_t=\rho_a\hat a_{t-1}-\eta_t^a.
\]

- **(F24) 加成冲击过程**：

\[
\epsilon_t^\pi=\rho_\pi\epsilon_{t-1}^\pi+\eta_t^\pi.
\]

- **(F25) 净值冲击过程**：

\[
\hat n_t=\rho_n\hat n_{t-1}-\eta_t^n.
\]

- **(F26) 货币政策冲击过程**：

\[
\epsilon_t^R=\rho_R\epsilon_{t-1}^R-\eta_t^R.
\]

## 6. 稳态求解

约化模型是围绕有效确定性稳态的对数线性模型。因此，所有带帽内生变量和创新的稳态均为零：

\[
\hat y=\hat y^{\mathrm{eff}}=\hat y^g=\hat R=\hat\pi=\hat z=\hat\phi=\hat e=\hat q=\hat d
=\hat L=\hat u=\hat r=\hat w=\hat a=\epsilon^\pi=\hat n=\epsilon^R=0.
\]

附录报告的非线性稳态关系为：

\[
B_1C_{ss}^{\sigma}L_{ss}^{\theta}=w_{ss}(1+w_{\mathrm{sub}}),\qquad
B_2C_{ss}^{\sigma}u_{ss}^{\theta}=r_{ss}(1+r_{\mathrm{sub}}).
\]

\[
Q_{ss}=\frac{\beta}{1-\beta}D_{ss},\qquad
z_{ss}=\frac{\varepsilon-1}{\varepsilon},\qquad
D_{ss}=x_{ss}(1-z_{ss}).
\]

\[
z_{ss}MPL_{ss}=w_{ss}(1+b\phi_{ss}),\qquad
z_{ss}MPU_{ss}=r_{ss}.
\]

补贴被选择为使：

\[
B_1C_{ss}^{\sigma}L_{ss}^{\theta}
=MPL_{ss}\frac{z_{ss}}{1+b\phi_{ss}}(1+w_{\mathrm{sub}})
=MPL_{ss},
\]

\[
B_2C_{ss}^{\sigma}u_{ss}^{\theta}
=MPU_{ss}z_{ss}(1+r_{\mathrm{sub}})
=MPU_{ss}.
\]

附录还报告了与 CSV 模型的校准联系：在 \(\mu=0.15\)、1% 破产率和 330/4 个基点的季度风险溢价下，\(\xi=4\)，意味着 \(b=1/(1+\xi)=0.2\) 且 \(b\phi_{ss}=0.026\)。这些校准细节与 `.mod` 参数 `b = 0.20` 作为 `implementation_cross_check` 一致。

## 7. 时序与形式约定

- **形式**：`model(linear)`；带帽变量是相对于确定性稳态的百分比/对数偏离。在 `.mod` 中，帽子被省略，因为所有变量已经是偏离。
- **预期**：方程使用 \(E_t\) 时序。在 Dynare 形式中，未来预期显示为超前项，例如 \(\hat\pi_{t+1}\) 和 \(\hat y_{t+1}\)。
- **状态变量**：企业家股权/份额持有 \(\hat e_t\) 和净值冲击承载代理成本动态。来源定义 \(nw_t=e_{t-1}(Q_t+D_t)\)，因此净值取决于滞后的企业家股权持有和当期股权回报。
- **无资本存量**：\(u_t\) 可解释为非受约束劳动投入或类似资本利用率的服务，但模型归档不应引入资本积累方程。
- **政策闭合**：论文分析最优政策，但 MMB 实现用 Taylor 规则闭合模拟模型。

## 8. 变量与参数对照表

| 类别 | 符号 / 名称 | 含义 | 主要方程 |
|---|---|---|---|
| 内生 | `y`, \(\hat y_t\) | 产出 | (F15), (F19)-(F21) |
| 内生 | `yeff`, \(\hat y_t^{\mathrm{eff}}\) | 有效产出 | (F19) |
| 内生 | `yg`, \(\hat y_t^g\) | 产出缺口 | (F19)-(F21), (F22) |
| 内生 | `R`, \(\hat R_t\) | 名义利率偏离 | (F11), (F22) |
| 内生 | `pi`, \(\hat\pi_t\) | 通胀偏离 | (F16), (F21) |
| 内生 | `z`, \(\hat z_t\) | 实际边际成本 | (F16), (F18), (F20) |
| 内生 | `phi`, \(\hat\phi_t\) | 代理成本乘数 / 信用扭曲 | (F7), (F18), (F20)-(F21) |
| 内生 | `e`, \(\hat e_t\) | 企业家股权份额持有 | (F13), (F14) |
| 内生 | `q`, \(\hat q_t\) | 股权/份额价格 | (F4), (F12)-(F14) |
| 内生 | `d`, \(\hat d_t\) | 股利 | (F17) |
| 内生 | `L`, \(\hat L_t\) | 受约束劳动投入 | (F1), (F5), (F9), (F14)-(F15) |
| 内生 | `u`, \(\hat u_t\) | 非受约束劳动投入 | (F2), (F6), (F10), (F15) |
| 内生 | `r`, \(\hat r_t\) | 非受约束劳动投入的价格 | (F2), (F6), (F10) |
| 内生 | `w`, \(\hat w_t\) | 受约束劳动投入的工资 | (F1), (F5), (F9), (F14), (F18) |
| 内生冲击状态 | `a`, \(\hat a_t\) | 技术 | (F19), (F23) |
| 内生冲击状态 | `eps_pi`, \(\epsilon_t^\pi\) | 加成冲击状态 | (F16), (F21), (F24) |
| 内生冲击状态 | `n`, \(\hat n_t\) | 净值冲击状态 | (F14), (F25) |
| 内生冲击状态 | `eps_R`, \(\epsilon_t^R\) | 货币政策冲击状态 | (F22), (F26) |
| 外生 | `eta_a` | 技术创新 | (F23) |
| 外生 | `eta_pi` | 加成创新 | (F24) |
| 外生 | `eta_n` | 净值创新 | (F25) |
| 外生 | `eta_R` | 货币政策创新 | (F26) |
| 参数 | `betta`, \(\beta\) | 贴现因子 | (F3), (F4), (F12), (F16) |
| 参数 | `sig`, \(\sigma\) | 跨期替代弹性倒数 / CRRA 参数 | (F9)-(F12), (F19)-(F21) |
| 参数 | `thet`, \(\theta\) | Frisch 弹性倒数 | (F9), (F10), (F19)-(F21) |
| 参数 | `eps`, \(\varepsilon\) | Dixit-Stiglitz 替代弹性 | (F16), (F17) |
| 参数 | `alfa`, \(\alpha\) | 受约束投入份额 | (F5), (F15), (F20), (F21) |
| 参数 | `b` | 抵押约束弹性 | (F7), (F14), (F18), (F20), (F21) |
| 参数 | `Lam`, \(\Lambda\) | \(F(\phi)\) 在稳态附近的导数 | (F13) |
| 参数 | `varphi`, \(\varphi\) | Rotemberg 调价成本参数 | (F16) |
| 参数 | `lam`, \(\lambda\) | 菲利普斯曲线斜率 | (F16), (F21) |
| 参数 | `rho_a`, `rho_pi`, `rho_n`, `rho_R` | 冲击持久性参数 | (F23)-(F26) |
| 参数 | `tau`, `tau_g` | Taylor 规则系数 | (F22) |
