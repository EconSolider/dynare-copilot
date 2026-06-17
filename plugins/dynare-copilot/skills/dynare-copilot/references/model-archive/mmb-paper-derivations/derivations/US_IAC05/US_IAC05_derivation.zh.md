# US_IAC05 - Iacoviello (2005) 推导

> 状态：`needs_review`。这是面向 MMB 实现 `US_IAC05` 的第一遍、基于来源的 MinerU Markdown 推导。未执行运行时验证。

## 1. Model Overview

- 模型：Matteo Iacoviello (2005), "House prices, borrowing constraints, and monetary policy in the business cycle."
- MMB ID：`US_IAC05`。
- 来源形式：包含名义债务、住房抵押、粘性价格、耐心家庭、非耐心家庭、企业家、零售商和货币当局的季度对数线性 DSGE 模型。
- 主要摩擦：与预期住房价值绑定的抵押约束、名义贷款偿还、由 Phillips 曲线概括的 Calvo 粘性价格、带调整成本的可变资本，以及固定总住房供给。
- 冲击：货币政策、住房偏好、通胀/加成和技术冲击。
- 来源：primary Markdown `raw/mmb_mineru/runs/us_iac05__house_prices_borrowing_constraints_and_monetary_policy_in_the_business_c__4002ee39/full.md`；raw PDF `raw/mmb_papers/House prices, borrowing constraints, and monetary policy in the business cycle.pdf`；DOI `10.1257/0002828054201477`；MinerU run `4002ee39-61e1-4470-a4e8-b5386cfee9a2`。
- 形式约定：本归档条目记录论文的完整对数线性扩展模型。带帽变量表示相对稳态的百分比偏离。附录中对 `t+1` 期变量的期望是隐含的；下文在有帮助时显式写出。状态标记：`needs_review`，因为若干 OCR 方程需要从附录文本中规范化，应在晋升为已审阅前对照 PDF 检查。

## 2. Optimization Problems

### 耐心家庭

耐心家庭选择消费、住房、劳动、债券和实际货币余额：

$$
\max E_0\sum_{t=0}^{\infty}\beta^t
\left(\log c'_t+j_t\log h'_t-\frac{(L'_t)^\eta}{\eta}+\chi\log\frac{M'_t}{P_t}\right)
$$

约束为名义债务流量预算：

$$
c'_t+q_t\Delta h'_t+\frac{R_{t-1}b'_{t-1}}{\pi_t}
=b'_t+w'_tL'_t+F_t+T'_t-\frac{\Delta M'_t}{P_t}.
$$

货币需求是可分的；由于政策通过利率规则实施，简化系统省略货币需求。

### 企业家

企业家比耐心家庭更不耐心，选择消费、资本、商业地产、劳动需求和债务：

$$
\max E_0\sum_{t=0}^{\infty}\gamma^t\log c_t,\qquad \gamma<\beta.
$$

扩展模型的生产函数为：

$$
Y_t=A_tK_{t-1}^{\mu}h_{t-1}^{\nu}(L'_t)^{\alpha(1-\mu-\nu)}
(L''_t)^{(1-\alpha)(1-\mu-\nu)}.
$$

流量预算约束为：

$$
\frac{Y_t}{X_t}+b_t
=c_t+q_t\Delta h_t+\frac{R_{t-1}b_{t-1}}{\pi_t}
+w'_tL'_t+w''_tL''_t+I_t+\xi_{e,t}+\xi_{K,t}.
$$

资本随投资 \(I_t=K_t-(1-\delta)K_{t-1}\) 演化，调整成本为：

$$
\xi_{K,t}=\frac{\psi}{2\delta}\left(\frac{I_t}{K_{t-1}}-\delta\right)^2K_{t-1}.
$$

住房调整成本为：

$$
\xi_{e,t}=\frac{\phi_e}{2}\left(\frac{\Delta h_t}{h_{t-1}}\right)^2q_th_{t-1}.
$$

在用于对数线性化的确定性邻域中，企业家抵押约束为绑定：

$$
b_t=mE_t\left(\frac{q_{t+1}h_t\pi_{t+1}}{R_t}\right).
$$

### 非耐心家庭

非耐心家庭选择消费、住房、劳动、债务和实际货币余额：

$$
\max E_0\sum_{t=0}^{\infty}(\beta'')^t
\left(\log c''_t+j_t\log h''_t-\frac{(L''_t)^\eta}{\eta}+\chi\log\frac{M''_t}{P_t}\right),
\qquad \beta''<\beta.
$$

其流量预算和抵押约束为：

$$
c''_t+q_t\Delta h''_t+\frac{R_{t-1}b''_{t-1}}{\pi_t}
=b''_t+w''_tL''_t+T''_t-\frac{\Delta M''_t}{P_t}-\xi_{h,t},
$$

$$
b''_t=m''E_t\left(\frac{q_{t+1}h''_t\pi_{t+1}}{R_t}\right),
$$

其中：

$$
\xi_{h,t}=\frac{\phi_h}{2}\left(\frac{\Delta h''_t}{h''_{t-1}}\right)^2q_th''_{t-1}.
$$

### 零售商和货币当局

零售商面对 Calvo 价格粘性。论文将定价模块化约为对数线性系统中的新凯恩斯 Phillips 曲线。中央银行遵循估计的 Taylor 型利率规则，包含利率惯性以及对滞后通胀和滞后产出的响应。

## 3. First-Order Conditions

以下方程复现论文的完整对数线性扩展模型。带帽变量表示相对稳态的偏离；\(t+1\) 期变量为条件期望。

- **(F1) 耐心家庭 Euler 方程**：

$$
\hat c'_t=E_t\hat c'_{t+1}-\widehat{rr}_t.
$$

- **(F2) 企业家投资条件**：

$$
\hat I_t-\hat K_{t-1}
=\gamma(E_t\hat I_{t+1}-\hat K_t)
+\frac{1-\gamma(1-\delta)}{\psi}(E_t\hat Y_{t+1}-E_t\hat X_{t+1}-\hat K_t)
+\frac{1}{\psi}(\hat c_t-E_t\hat c_{t+1}).
$$

- **(F3) 企业家住房-消费边际条件**：

$$
\begin{aligned}
\hat q_t={}&\gamma_eE_t\hat q_{t+1}
+(1-\gamma_e)(E_t\hat Y_{t+1}-E_t\hat X_{t+1}-\hat h_t)
-m\beta\,\widehat{rr}_t \\
&-(1-m\beta)E_t\Delta\hat c_{t+1}
-\phi_e(\Delta\hat h_t-\gamma E_t\Delta\hat h_{t+1}).
\end{aligned}
$$

`needs_review`：Markdown 某处显示 `m beta r rrhat`，而 MMB `.mod` 使用 `m*beta*rrhat`；本稿依据 implementation cross-check 和附录上下文采用后者。

- **(F4) 非耐心家庭住房-消费边际条件**：

$$
\begin{aligned}
\hat q_t={}&\gamma_hE_t\hat q_{t+1}
+(1-\gamma_h)(\hat j_t-\hat h''_t)
-m''\beta\,\widehat{rr}_t
+(1-m''\beta)(\hat c''_t-\omega E_t\hat c''_{t+1})\\
&-\phi_h(\Delta\hat h''_t-\beta''E_t\Delta\hat h''_{t+1}).
\end{aligned}
$$

- **(F5) 含市场出清的耐心家庭住房需求**：

$$
\begin{aligned}
\hat q_t={}&\beta E_t\hat q_{t+1}+(1-\beta)\hat j_t+\iota\hat h_t+\iota''\hat h''_t
+\hat c'_t-\beta E_t\hat c'_{t+1}\\
&+\frac{\phi_h}{h'}\left(h\Delta\hat h_t+h''\Delta\hat h''_t
-\beta hE_t\Delta\hat h_{t+1}-\beta h''E_t\Delta\hat h''_{t+1}\right).
\end{aligned}
$$

`needs_review`：附录将最后的调整成本括号归入耐心家庭住房条件；由于 OCR 换行较嘈杂，调整成本系数应对照 PDF 检查。

- **(F6) 生产和劳动市场模块**：

$$
\hat Y_t=
\frac{\eta}{\eta-(1-\nu-\mu)}
\left(\hat A_t+\nu\hat h_{t-1}+\mu\hat K_{t-1}\right)
-\frac{1-\nu-\mu}{\eta-(1-\nu-\mu)}
\left(\hat X_t+\alpha\hat c'_t+(1-\alpha)\hat c''_t\right).
$$

- **(F7) Phillips 曲线**：

$$
\hat\pi_t=\beta E_t\hat\pi_{t+1}-\kappa\hat X_t+\hat u_t.
$$

## 4. Market Clearing & Identities

- **(F8) 总需求 / 商品市场出清**：

$$
\hat Y_t=\frac{c}{Y}\hat c_t+\frac{c'}{Y}\hat c'_t+\frac{c''}{Y}\hat c''_t+\frac{I}{Y}\hat I_t.
$$

- **(F9) 企业家借款约束**：

$$
\hat b_t=E_t\hat q_{t+1}+\hat h_t-\widehat{rr}_t.
$$

- **(F10) 非耐心家庭借款约束**：

$$
\hat b''_t=E_t\hat q_{t+1}+\hat h''_t-\widehat{rr}_t.
$$

- **(F11) 资本积累**：

$$
\hat K_t=\delta\hat I_t+(1-\delta)\hat K_{t-1}.
$$

- **(F12) 企业家资金流 / 净值动态**：

$$
\begin{aligned}
\frac{b}{Y}\hat b_t={}&\frac{c}{Y}\hat c_t+\frac{qh}{Y}\Delta\hat h_t+\frac{I}{Y}\hat I_t
+\frac{Rb}{Y}(\hat R_{t-1}+\hat b_{t-1}-\hat\pi_t)\\
&-(1-s'-s'')(\hat Y_t-\hat X_t).
\end{aligned}
$$

- **(F13) 非耐心家庭资金流 / 净值动态**：

$$
\frac{b''}{Y}\hat b''_t=
\frac{c''}{Y}\hat c''_t+\frac{qh''}{Y}\Delta\hat h''_t
+\frac{Rb''}{Y}(\hat b''_{t-1}+\hat R_{t-1}-\hat\pi_t)
-s''(\hat Y_t-\hat X_t).
$$

- **(F14) 事前实际利率定义**：

$$
\widehat{rr}_t=\hat R_t-E_t\hat\pi_{t+1}.
$$

住房市场出清由固定总住房供给施加，并已嵌入变换后的住房需求方程。贷款市场出清为 \(b_t+b'_t+b''_t=0\)，稳态下耐心家庭为净贷款人。

## 5. Exogenous Processes

- **(F15) 货币政策规则**：

$$
\hat R_t=(1-r_R)(1+r_\pi)\hat\pi_{t-1}
+r_Y(1-r_R)\hat Y_{t-1}
+r_R\hat R_{t-1}+\hat e_{R,t}.
$$

- **(F16) 住房偏好冲击**：

$$
\hat j_t=\rho_j\hat j_{t-1}+\hat e_{j,t}.
$$

- **(F17) 通胀/加成冲击**：

$$
\hat u_t=\rho_u\hat u_{t-1}+\hat e_{u,t}.
$$

- **(F18) 技术冲击**：

$$
\hat A_t=\rho_A\hat A_{t-1}+\hat e_{A,t}.
$$

## 6. Steady-State Solution

模型围绕零通胀确定性稳态求解，且 \(R=1/\beta\)。由于 MMB 实现为对数线性模型，本归档记录稳态比率。

定义：

$$
\gamma_e=(1-m)\gamma+m\beta,\qquad
\gamma_h=\beta''+m''(\beta-\beta''),\qquad
\omega=\frac{\beta''-m''\beta''}{1-m''\beta}.
$$

收入份额：

$$
s'=\frac{\alpha(1-\mu-\nu)+X-1}{X},\qquad
s''=\frac{(1-\alpha)(1-\mu-\nu)}{X}.
$$

商业地产和债务比率：

$$
\frac{qh}{Y}=\frac{\gamma\nu}{1-\gamma_e}\frac{1}{X},\qquad
\frac{b}{Y}=\frac{\beta m\gamma\nu}{1-\gamma_e}\frac{1}{X}.
$$

耐心和非耐心家庭的房地产比率：

$$
\frac{qh'}{Y}
=\frac{j}{1-\beta}s'
+\frac{jm\gamma\nu}{1-\gamma_e}\frac{1}{X}
+\frac{jm''s''}{1-\beta''-m''(\beta-\beta''-j(1-\beta))}.
$$

$$
\frac{qh''}{Y}
=\frac{js''}{1-\beta''-m''(\beta-\beta''-j(1-\beta))}.
$$

非耐心家庭债务和消费比率：

$$
\frac{b''}{Y}
=\frac{j\beta m''s''}{1-\beta''-m''(\beta-\beta'')+jm''(1-\beta)}.
$$

$$
\frac{c''}{Y}
=\frac{1-\beta''-m''(\beta-\beta'')}{1-\beta''-m''(\beta-\beta'')+jm''(1-\beta)}s''.
$$

企业家消费比率：

$$
\frac{c}{Y}
=\left(\mu+\nu-\frac{\delta\gamma\mu}{1-\gamma(1-\delta)}
-\frac{(1-\beta)m\gamma\nu}{1-\gamma_e}\right)\frac{1}{X}.
$$

耐心家庭消费比率和投资比率随后由总资源核算确定：

$$
\frac{c'}{Y}=1-\frac{c}{Y}-\frac{c''}{Y}-\frac{I}{Y},\qquad
\frac{I}{Y}=1-\frac{c}{Y}-\frac{c'}{Y}-\frac{c''}{Y}.
$$

`needs_review`：论文附录给出了多个稳态比率，但没有给出每个归一化变量的完整独立求解顺序。本节应对照原始附录和 MMB 校准后再晋升为非 first-pass 状态。

## 7. Timing & Form Conventions

- 形式：对数线性、百分比偏离模型；MMB `.mod` 使用线性化 `model` 块。
- 期望：附录文本省略 \(t+1\) 期变量前的显式 \(E_t\)；本推导根据来源声明在公式中恢复 \(E_t\)。
- 资本时序：\(K_t\) 是期末资本；\(t\) 期生产使用 \(K_{t-1}\)。资本积累为 (F11)。
- 住房时序：生产使用商业地产 \(h_{t-1}\)；抵押约束依赖预期 \(q_{t+1}h_t\)。家庭住房选择为当期存量，调整成本项使用一阶差分。
- 债务时序：债务义务为名义形式。实际偿还负担包含 \(R_{t-1}b_{t-1}/\pi_t\)，所以未预期通胀会在贷款人和借款人之间重新分配资源。
- 利率：\(\hat R_t\) 是线性系统中的名义政策利率；\(\widehat{rr}_t=\hat R_t-E_t\hat\pi_{t+1}\) 是事前实际利率。
- 运行时验证：未执行；没有运行 Dynare。

## 8. Variable & Parameter Reference Table

| 类别 | 符号 / ASCII | 含义 | 方程锚点 |
|---|---|---|---|
| 内生 | `Yhat` / \(\hat Y_t\) | 总产出 | (F8), (F6) |
| 内生 | `chat` / \(\hat c_t\) | 企业家消费 | (F3), (F12) |
| 内生 | `c1hat` / \(\hat c'_t\) | 耐心家庭消费 | (F1), (F5) |
| 内生 | `c2hat` / \(\hat c''_t\) | 非耐心家庭消费 | (F4), (F13) |
| 内生 | `Ihat` / \(\hat I_t\) | 投资 | (F2), (F11) |
| 内生 | `Khat` / \(\hat K_t\) | 资本存量 | (F11) |
| 内生 | `Xhat` / \(\hat X_t\) | 加成 | (F6), (F7) |
| 内生 | `qhat` / \(\hat q_t\) | 实际住房价格 | (F3)-(F5) |
| 内生 | `bhat` / \(\hat b_t\) | 企业家债务 | (F9), (F12) |
| 内生 | `b2hat` / \(\hat b''_t\) | 非耐心家庭债务 | (F10), (F13) |
| 内生 | `hhat` / \(\hat h_t\) | 企业家住房 | (F3), (F9), (F12) |
| 内生 | `h2hat` / \(\hat h''_t\) | 非耐心家庭住房 | (F4), (F10), (F13) |
| 内生 | `pihat` / \(\hat\pi_t\) | 通胀 | (F7), (F14), (F15) |
| 内生 | `Rhat` / \(\hat R_t\) | 名义政策利率 | (F15) |
| 内生 | `rrhat` / \(\widehat{rr}_t\) | 事前实际利率 | (F14) |
| 带 AR 动态的内生 | `jhat` / \(\hat j_t\) | 住房偏好 | (F16) |
| 带 AR 动态的内生 | `uhat` / \(\hat u_t\) | 通胀/加成扰动 | (F17) |
| 带 AR 动态的内生 | `Ahat` / \(\hat A_t\) | 技术 | (F18) |
| 外生冲击 | `eRhat` | 货币政策创新 | (F15) |
| 外生冲击 | `ejhat` | 住房偏好创新 | (F16) |
| 外生冲击 | `euhat` | 通胀/加成创新 | (F17) |
| 外生冲击 | `eAhat` | 技术创新 | (F18) |
| 参数 | `beta` / \(\beta\) | 耐心家庭贴现因子 | steady state, (F1) |
| 参数 | `beta2` / \(\beta''\) | 非耐心家庭贴现因子 | (F4), steady state |
| 参数 | `gamma` / \(\gamma\) | 企业家贴现因子 | (F2), (F3), steady state |
| 参数 | `j` | 住房效用权重 | (F5), steady state |
| 参数 | `eta` / \(\eta\) | 劳动供给曲率 | (F6) |
| 参数 | `my` / \(\mu\) | 资本份额 | (F6), steady state |
| 参数 | `ypsilon` / \(\nu\) | 商业地产份额 | (F6), steady state |
| 参数 | `psi` | 资本调整成本 | (F2) |
| 参数 | `delta` / \(\delta\) | 折旧率 | (F2), (F11), steady state |
| 参数 | `fie`, `fih` / \(\phi_e,\phi_h\) | 住房调整成本 | (F3)-(F5) |
| 参数 | `X` | 稳态加成 | steady state |
| 参数 | `theta` | Calvo 固定价格概率 | (F7), via \(\kappa\) |
| 参数 | `alfa` / \(\alpha\) | 耐心家庭劳动收入份额 | (F6), steady state |
| 参数 | `m`, `m2` / \(m,m''\) | loan-to-value ratios | (F3), (F4), (F9), (F10) |
| 参数 | `rhou`, `rhoj`, `rhoA` | AR 系数 | (F16)-(F18) |
| 参数 | `sigmaR`, `sigmaj`, `sigmau`, `sigmaA` | 冲击标准差 | shock calibration |
| 参数 | `rR`, `rpi`, `rY` | Taylor 规则系数 | (F15) |
| 派生参数 | `gammae`, `gammah`, `omega`, `kappa`, `s1`, `s2`, ratios | 稳态和线性化系数 | multiple |
