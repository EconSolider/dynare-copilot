# US_BR13 -- 推导

> MMB 模型 `US_BR13` 的来源支撑归档草稿。未执行运行时验证。

## 1. Model Overview

- **模型**：Blanchard and Riggi (2013)，"Why are the 2000s so different from the 1970s?"
- **模型族**：美国对数线性新凯恩斯模型，用最小距离方法匹配 1960:Q1-1983:Q4 与 1984:Q1-2007:Q3 两个样本期的油价冲击 IRF。
- **主体与模块**：带习惯形成的家庭、使用劳动与进口石油的垄断竞争厂商、Calvo 国内品价格设定、采用 Taylor 规则的货币当局，以及外生实际油价过程。
- **核心机制**：石油同时进入生产和消费、实际工资刚性、通胀预期中的不完全可信度、名义价格刚性。
- **来源出处**：主 Markdown `raw/mmb_mineru/runs/us_br13__why_are_the_2000s_so_different_from_the_1970s__5227bf28/full.md`；原始 PDF `raw/mmb_papers/Why are the 2000s so different from the 1970s?.pdf`；MinerU run id `5227bf28-1ed1-42e5-9235-36552bd5505b`；`raw/mmb_mineru/model_index.csv` 未记录 DOI。
- **形式**：对数线性。论文说明小写变量表示相对稳态的偏离，带帽小写变量表示相对稳态的比例偏离。本条目记录基准 Cobb-Douglas 技术；稳健性变体只作说明，不并入基准方程数。

## 2. Optimization Problems

本地论文 Markdown 给出的是隐含对数线性方程，而不是完整非线性优化问题。论文称完整推导在 Online Appendix 中，但本地没有 `US_BR13` 的独立附录归一化文件。因此以下问题只概括模型方程隐含的优化结构，并标记为 `needs_review`，等待附录层面的来源确认。

### 2.1 家庭

家庭在外部习惯形成下选择消费和劳动。隐含跨期问题为：

\[
\max_{\{C_t,N_t,B_t\}} E_0\sum_{t=0}^{\infty}\beta^t
U(C_t-hC_{t-1},N_t)
\]

并受到标准跨期预算约束限制。本地来源报告的是对应的对数线性 Euler 方程和实际供给工资关系，而不是原始非线性预算约束。

### 2.2 厂商

国内厂商为垄断竞争者，使用劳动和进口石油。生产函数为 Cobb-Douglas：

\[
\hat q_t=\alpha_n\hat n_t+\alpha_m\hat m_t.
\]

成本最小化给出石油需求和要素价格前沿。Calvo 定价给出以国内品通胀表示的对数线性新凯恩斯 Phillips 曲线。

### 2.3 货币当局与预期

中央银行遵循带惯性的 Taylor 规则，对国内通胀和福利相关产出缺口作出反应。主体的通胀预期由模型一致预期和当前通胀共同决定，可信度参数为 \(\lambda\)。

## 3. First-Order Conditions

- **(F1) 总生产技术**：

\[
\hat q_t=\alpha_n\hat n_t+\alpha_m\hat m_t.
\]

- **(F2) 消费聚合器**：

\[
\hat c_t=(1-\chi)\hat c_{q,t}+\chi\hat c_{m,t}.
\]

- **(F3) 消费价格指数**：

\[
\hat p_{c,t}=\hat p_{q,t}+\chi\hat s_t,
\qquad
\hat s_t\equiv \hat p_{m,t}-\hat p_{q,t}.
\]

- **(F4) 带习惯的家庭 Euler 方程**：

\[
\hat c_t=\frac{h}{1+h}\hat c_{t-1}
+\frac{1}{1+h}E_t\hat c_{t+1}
-\frac{1-h}{(1+h)\sigma}
\left(i_t-\hat\pi^e_{c,t+1}+\log\beta\right).
\]

- **(F5) 带实际工资刚性的实际供给工资 / 劳动供给**：

\[
\hat w_t-\hat p_{c,t}
=\gamma(\hat w_{t-1}-\hat p_{c,t-1})
+(1-\gamma)\left\{\varphi\hat n_t+
\frac{\sigma}{1-h}(\hat c_t-h\hat c_{t-1})\right\}.
\]

- **(F6) 成本最小化给出的厂商石油需求**：

\[
\hat m_t=-\hat\mu_t-\hat s_t+\hat q_t.
\]

- **(F7) 消去石油后的约化生产函数**：

\[
\hat q_t=\frac{1}{1-\alpha_m}
\left(\alpha_n\hat n_t-\alpha_m\hat s_t-\alpha_m\hat\mu_t\right).
\]

- **(F8) 要素价格前沿**：

\[
(1-\alpha_m)(\hat w_t-\hat p_{c,t})
+[\alpha_m+(1-\alpha_m)\chi]\hat s_t
+(1-\alpha_n-\alpha_m)\hat n_t+\hat\mu_t=0.
\]

- **(F9) 国内品 Phillips 曲线**：

\[
\hat\pi_{q,t}=\beta\hat\pi^e_{q,t+1}-\lambda_p\hat\mu_t,
\]

其中

\[
\lambda_p=
\frac{(1-\theta)(1-\beta\theta)}{\theta}
\frac{\alpha_m+\alpha_n}
{1+(1-\alpha_m-\alpha_n)(\epsilon-1)}.
\]

## 4. Market Clearing & Identities

- **(F10) 消费与总产出的平衡贸易关系**：

\[
\hat c_t=\hat q_t-\chi\hat s_t+\eta\hat\mu_t,
\qquad
\eta\equiv\frac{\alpha_m}{\mathcal M-\alpha_m}.
\]

- **(F11) 消费-就业关系**：

\[
\hat c_t=
\frac{\alpha_n}{1-\alpha_m}\hat n_t
-\left(\chi+\frac{\alpha_m}{1-\alpha_m}\right)\hat s_t
+\left(\eta-\frac{\alpha_m}{1-\alpha_m}\right)\hat\mu_t.
\]

- **(F12) 增加值平减指数恒等式**：

\[
\hat p_{y,t}=\hat p_{q,t}-\frac{\alpha_m}{1-\alpha_m}\hat s_t.
\]

- **(F13) GDP 与总产出恒等式**：

\[
\hat y_t=\hat q_t+\frac{\alpha_m}{1-\alpha_m}\hat s_t+\eta\hat\mu_t.
\]

- **(F14) Taylor 规则**：

\[
i_t=\rho_i i_{t-1}+
(1-\rho_i)\left(-\log\beta+\varphi_\pi\hat\pi_{q,t}
+\varphi_x\hat x^f_t\right).
\]

- **(F15) 国内通胀预期与可信度**：

\[
\hat\pi^e_{q,t+1}=(1-\lambda)\hat\pi_{q,t}
+\lambda E_t\hat\pi_{q,t+1}.
\]

- **(F16) 消费通胀预期**：

\[
\hat\pi^e_{c,t+1}
=\hat\pi^e_{q,t+1}+\chi E_t(\hat s_{t+1}-\hat s_t).
\]

- **(F17) 灵活价格就业运动方程**：

\[
\hat n_t=\Gamma_1\hat s_t+\Gamma_2\hat s_{t-1}+\Gamma_3\hat n_{t-1}.
\]

其中

\[
\Gamma_1=
\frac{[\sigma(1-\gamma)-(1-h)][\alpha_m+\chi(1-\alpha_m)]}
{\varphi(1-\gamma)(1-h)(1-\alpha_m)+\sigma\alpha_n(1-\gamma)+(1-h)(1-\alpha_m-\alpha_n)},
\]

\[
\Gamma_2=
\frac{[(1-h)\gamma-\sigma h(1-\gamma)][\alpha_m+\chi(1-\alpha_m)]}
{\varphi(1-\gamma)(1-h)(1-\alpha_m)+\sigma\alpha_n(1-\gamma)+(1-h)(1-\alpha_m-\alpha_n)},
\]

\[
\Gamma_3=
\frac{\gamma(1-\alpha_m-\alpha_n)(1-h)+\sigma h\alpha_n(1-\gamma)}
{\varphi(1-\gamma)(1-h)(1-\alpha_m)+\sigma\alpha_n(1-\gamma)+(1-h)(1-\alpha_m-\alpha_n)}.
\]

(F14) 中的福利相关产出缺口 \(\hat x^f_t\) 是实际产出和有效率产出之间的楔子。来源指向 Online Appendix C 给出推导；本地没有该附录，因此 \(\hat x^f_t\) 的精确实现为 `needs_review`。

## 5. Exogenous Processes

- **(F18) 实际油价过程**：

\[
\hat s_t=\rho_s\hat s_{t-1}+\varepsilon^s_t.
\]

实证练习将实际油价冲击视为相对于国内变量当期变化外生。论文校准 \(\rho_s=0.999\)，使实际油价接近随机游走但保持平稳。

## 6. Steady-State Solution

由于模型为对数线性，所有偏离变量的稳态均为零：

\[
\hat q=\hat n=\hat m=\hat c=\hat c_q=\hat c_m=\hat p_c=\hat p_q
=\hat p_m=\hat s=\hat w=\hat\mu=\hat\pi_q=\hat\pi_c=\hat y=i-\bar i=0.
\]

Taylor 规则中的名义利率截距使零通胀稳态满足：

\[
\bar i=-\log\beta.
\]

来源报告的基准校准和估计为：

| Parameter | Pre-1984 | Post-1984 | Source role |
|---|---:|---:|---|
| \(\alpha_m\) | 0.015 | 0.012 | 生产中的石油份额，校准 |
| \(\chi\) | 0.023 | 0.017 | 消费中的石油份额，校准 |
| \(\alpha_n\) | \(1-\alpha_m\) | \(1-\alpha_m\) | 劳动和石油的短期规模报酬不变 |
| \(\rho_s\) | 0.999 | 0.999 | 油价持续性 |
| \(\beta\) | 0.99 | 0.99 | 贴现因子 |
| \(\epsilon\) | 6.0 | 6.0 | 替代弹性 / 20% 期望加成 |
| \(\varphi\) | 1.0 | 1.0 | Frisch 弹性倒数 |
| \(h\) | 0.8 | 0.8 | 习惯 |
| \(\sigma\) | 0.39 | 0.26 | 估计风险规避 |
| \(\gamma\) | 0.97 | 0.00 | 估计实际工资刚性 |
| \(\theta\) | 0.96 | 0.59 | 估计价格黏性 |
| \(\varphi_\pi\) | 1.33 | 1.08 | Taylor 规则通胀系数 |
| \(\varphi_x\) | 0.00 | 0.00 | Taylor 规则产出缺口系数 |
| \(\rho_i\) | 0.49 | 0.54 | 政策惯性 |
| \(\lambda\) | 0.00 | 1.00 | 中央银行可信度 |

## 7. Timing & Form Conventions

- **频率**：季度。
- **样本**：pre-1984 样本为 1960:Q1-1983:Q4；结构估计段落中的 post-1984 样本为 1984:Q1-2007:Q3，而 VAR 讨论中写作 1984:Q1-2007:Q4。此差异记录为 `needs_review`。
- **线性化**：所有方程均为对数线性或相对稳态的偏离。带帽变量是相对稳态的比例偏离；不带帽小写变量是相对稳态的偏离。
- **预期**：\(E_t\) 表示模型一致预期；\(\hat\pi^e\) 变量是感知预期，可通过 \(\lambda\) 将当前通胀和理性预期相结合。
- **存量**：基准模型没有资本存量。主要持久状态为滞后消费、滞后实际消费工资、滞后名义利率、滞后实际油价和滞后灵活价格就业。
- **实现交叉检查**：当前 checkout 中不存在 `.agents/skills/dynare-copilot/references/examples/US_BR13_rep.mod` 文件，因此未使用 `.mod` 交叉检查。
- **运行时验证**：未执行；未运行 Dynare。

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII name | 含义 | Equation reference |
|---|---|---|---|
| Endogenous | `q_hat` / \(\hat q_t\) | 总国内产出 | (F1), (F7), (F10), (F13) |
| Endogenous | `n_hat` / \(\hat n_t\) | 就业 / 劳动 | (F1), (F5), (F7), (F8), (F11), (F17) |
| Endogenous | `m_hat` / \(\hat m_t\) | 生产中使用的进口石油 | (F1), (F6) |
| Endogenous | `c_hat` / \(\hat c_t\) | 总消费 | (F2), (F4), (F10), (F11) |
| Endogenous | `cq_hat` / \(\hat c_{q,t}\) | 国内品消费组成 | (F2) |
| Endogenous | `cm_hat` / \(\hat c_{m,t}\) | 进口石油消费组成 | (F2) |
| Endogenous | `pc_hat` / \(\hat p_{c,t}\) | 消费价格 | (F3), (F5), (F16) |
| Endogenous | `pq_hat` / \(\hat p_{q,t}\) | 国内产出价格 | (F3), (F12) |
| Endogenous | `pm_hat` / \(\hat p_{m,t}\) | 进口石油价格 | (F3) |
| Endogenous | `s_hat` / \(\hat s_t\) | 实际油价 | (F3), (F6)-(F8), (F10)-(F13), (F16)-(F18) |
| Endogenous | `w_hat` / \(\hat w_t\) | 名义工资 | (F5), (F8) |
| Endogenous | `mu_hat` / \(\hat\mu_t\) | 价格加成偏离 | (F6)-(F13) |
| Endogenous | `piq_hat` / \(\hat\pi_{q,t}\) | 国内品通胀 | (F9), (F14), (F15) |
| Endogenous | `pic_exp_hat` / \(\hat\pi^e_{c,t+1}\) | 预期消费通胀 | (F4), (F16) |
| Endogenous | `piq_exp_hat` / \(\hat\pi^e_{q,t+1}\) | 预期国内通胀 | (F9), (F15), (F16) |
| Endogenous | `y_hat` / \(\hat y_t\) | GDP / 增加值 | (F13) |
| Endogenous | `py_hat` / \(\hat p_{y,t}\) | 增加值平减指数 | (F12) |
| Endogenous | `i` / \(i_t\) | 名义利率 | (F4), (F14) |
| Endogenous | `xf_hat` / \(\hat x^f_t\) | 福利相关产出缺口 | (F14), `needs_review` |
| Exogenous | `eps_s` / \(\varepsilon^s_t\) | 实际油价创新 | (F18) |
| Parameter | `alpha_n` / \(\alpha_n\) | 生产中的劳动份额 | (F1), (F7), (F8), (F11), (F17) |
| Parameter | `alpha_m` / \(\alpha_m\) | 生产中的石油份额 | (F1), (F7), (F8), (F10)-(F13), (F17) |
| Parameter | `chi` / \(\chi\) | 消费中的石油份额 | (F2), (F3), (F8), (F10), (F11), (F16), (F17) |
| Parameter | `beta` / \(\beta\) | 贴现因子 | (F4), (F9), (F14) |
| Parameter | `sigma` / \(\sigma\) | 风险规避 | (F4), (F5), (F17) |
| Parameter | `h` / \(h\) | 习惯参数 | (F4), (F5), (F17) |
| Parameter | `gamma` / \(\gamma\) | 实际工资刚性 | (F5), (F17) |
| Parameter | `varphi` / \(\varphi\) | Frisch 弹性倒数 | (F5), (F17) |
| Parameter | `theta` / \(\theta\) | Calvo 价格黏性 | (F9) |
| Parameter | `epsilon` / \(\epsilon\) | 替代弹性 | (F9) |
| Parameter | `lambda_p` / \(\lambda_p\) | Phillips 曲线斜率 | (F9) |
| Parameter | `eta` / \(\eta\) | 平衡贸易加成系数 | (F10), (F11), (F13) |
| Parameter | `markup_ss` / \(\mathcal M\) | 期望总加成 | (F10) |
| Parameter | `rho_i` / \(\rho_i\) | 利率平滑 | (F14) |
| Parameter | `phi_pi` / \(\varphi_\pi\) | Taylor 规则对通胀的反应 | (F14) |
| Parameter | `phi_x` / \(\varphi_x\) | Taylor 规则对产出缺口的反应 | (F14) |
| Parameter | `lambda_cred` / \(\lambda\) | 货币政策可信度 | (F15) |
| Parameter | `rho_s` / \(\rho_s\) | 实际油价持续性 | (F18) |
