# NK_FNL23 推导：Ferrari and Nispi Landi (2023)

> 档案状态：`needs_review`。本初稿推导来自 Ferrari and Nispi Landi, "Towards a Green Economy: The Role of the Central Bank's Asset Purchases" 的 MinerU Markdown（IJCB, 2023；DOI `10.2139/ssrn.4357535`）。未执行运行时验证。

## 1. Model Overview

- **模型 ID**：`NK_FNL23`。
- **来源**：Alessandro Ferrari and Valerio Nispi Landi, "Towards a Green Economy: The Role of the Central Bank's Asset Purchases"。
- **用途**：带绿色与棕色生产部门、家庭对绿色与棕色债券的偏好、碳税、污染积累和中央银行绿色资产购买的中等规模 New Keynesian 模型。
- **主体与模块**：代表性家庭；最终品厂商；带价格调整成本的中间品厂商；绿色与棕色基础厂商；资本品生产者；政府和中央银行。
- **形式**：非线性模型，用劳动增强型生产率 \(z_t\) 去趋势；MMB 实现交叉检查使用 Dynare 风格的一阶随机模拟。论文附录列出 29 个去趋势均衡方程，并把政策路径 \(\tau_t\) 和 \(\widetilde{re}_t\) 作为外生变量。
- **来源说明**：附录方程可以恢复，但 MinerU OCR 在若干政策和资产负债表行存在轻微符号错误；这些方程标记为 `needs_review`。

## 2. Optimization Problems

### 2.1 家庭

代表性家庭选择消费、劳动、公共债券/准备金、绿色债券和棕色债券持有量：

\[
\max E_0\sum_{t=0}^{\infty}\beta^t\left[
\log(c_t-\varsigma c_{t-1})-\frac{h_t^{1+\varphi}}{1+\varphi}
+\frac{\nu_G}{1-\kappa_G}\left(\frac{B^G_{Ht}}{P_tz_t}\right)^{1-\kappa_G}
-\frac{\nu_B}{1+\kappa_B}\left(\frac{B^B_{Ht}}{P_tz_t}\right)^{1+\kappa_B}
\right]
\]

约束为名义预算约束

\[
c_t+\frac{D_{Ht}+B^G_{Ht}+B^B_{Ht}}{P_t}
=\frac{r_{t-1}D_{H,t-1}+R^G_tB^G_{H,t-1}+R^B_tB^B_{H,t-1}}{P_t}
+w_th_t-t_t+\Gamma_t .
\]

绿色债券正向进入效用，棕色债券负向进入效用，因此二者不是完全替代品，中央银行资产组合可以影响利差。

### 2.2 最终品厂商

最终品厂商组合差异化中间品：

\[
y_t=\left[\int_0^1 y_t(i)^{\frac{\varepsilon-1}{\varepsilon}}\,di\right]^{\frac{\varepsilon}{\varepsilon-1}},
\]

并在相对价格约束下选择各类投入。

### 2.3 中间品厂商

中间品厂商组合绿色和棕色部门产出：

\[
y^I_t(i)=\left[(1-\zeta)^{1/\xi}y^G_t(i)^{\frac{\xi-1}{\xi}}+\zeta^{1/\xi}y^B_t(i)^{\frac{\xi-1}{\xi}}\right]^{\frac{\xi}{\xi-1}}.
\]

它们在该 CES 聚合约束下最小化 \(p^G_ty^G_t(i)+p^B_ty^B_t(i)\)，并在二次价格调整成本下设定价格：

\[
AC_t(i)=\frac{\kappa_P}{2}\left(\frac{P_t(i)}{P_{t-1}(i)}-\bar{\pi}\right)^2P_ty_t .
\]

### 2.4 绿色与棕色厂商

每个部门 \(j\in\{G,B\}\) 使用资本和劳动生产：

\[
y^j_t=a_t(k^j_{t-1})^\alpha(z_th^j_t)^{1-\alpha}.
\]

绿色厂商不污染。棕色厂商面对排放税并选择减排 \(\mu_t\)，棕色净价格为

\[
p^{Bnet}_t=p^B_t-\tau_t(1-\mu_t)\nu_E-\frac{\nu_M}{1+\chi}\mu_t^{1+\chi}.
\]

### 2.5 资本品生产者

资本品生产者选择投资和总资本：

\[
\max E_0\sum_{t=0}^{\infty}\beta^t\frac{\lambda_t}{\lambda_0}
\left[q_tk_t-(1-\delta)q_tk_{t-1}-i_t\right]
\]

约束为

\[
k_t=(1-\delta)k_{t-1}+\left[1-\frac{\kappa_I}{2}\left(\frac{i_t}{i_{t-1}}-\theta\right)^2\right]i_t .
\]

### 2.6 政策当局

中央银行持有绿色公司债、棕色公司债和公共债券/准备金：

\[
b^G_{Ct}+b^B_{Ct}+d_{Ct}=re_t .
\]

政府征收排放税，并通过合并预算返还。论文把 \(\tau_t\) 和 \(re_t\) 作为转型实验中的政策路径。

## 3. First-Order Conditions

以下方程使用论文附录的去趋势记号。波浪号表示变量除以 \(z_t\)；\(\theta\) 是总趋势增长率。

- **(F1) 劳动供给**：

\[
h_t^\varphi=\widetilde{w}_t\widetilde{\lambda}_t .
\]

- **(F2) 公共债券/准备金欧拉方程**：

\[
1=\beta E_t\left(\frac{\widetilde{\lambda}_{t+1}}{\widetilde{\lambda}_t\theta}\frac{r_t}{\pi_{t+1}}\right).
\]

- **(F3) 绿色债券欧拉方程**：

\[
1=\beta E_t\left[\frac{\widetilde{\lambda}_{t+1}}{\widetilde{\lambda}_t\theta}r^G_{t+1}\right]
+\frac{\nu_G}{\widetilde{\lambda}_t}\left(\widetilde{b}^G_{Ht}\right)^{-\kappa_G}.
\]

- **(F4) 棕色债券欧拉方程**：

\[
1=\beta E_t\left[\frac{\widetilde{\lambda}_{t+1}}{\widetilde{\lambda}_t\theta}r^B_{t+1}\right]
-\frac{\nu_B}{\widetilde{\lambda}_t}\left(\widetilde{b}^B_{Ht}\right)^{\kappa_B}.
\]

- **(F5) 中间投入 CES 生产**：

\[
\widetilde{y}_t=\left[(1-\zeta)^{1/\xi}(\widetilde{y}^G_t)^{\frac{\xi-1}{\xi}}
+\zeta^{1/\xi}(\widetilde{y}^B_t)^{\frac{\xi-1}{\xi}}\right]^{\frac{\xi}{\xi-1}}.
\]

- **(F6) 绿色产出需求**：

\[
\widetilde{y}^G_t=(1-\zeta)\left(\frac{p^G_t}{p^I_t}\right)^{-\xi}\widetilde{y}_t .
\]

- **(F7) 棕色产出需求**：

\[
\widetilde{y}^B_t=\zeta\left(\frac{p^B_t}{p^I_t}\right)^{-\xi}\widetilde{y}_t .
\]

- **(F8) 非线性 Phillips 曲线**：

\[
\pi_t(\pi_t-\bar{\pi})=\beta E_t\left[
\frac{\widetilde{\lambda}_{t+1}}{\widetilde{\lambda}_t}
\frac{\widetilde{y}_{t+1}}{\widetilde{y}_t}
\pi_{t+1}(\pi_{t+1}-\bar{\pi})\right]
+\frac{\varepsilon}{\kappa_P}\left(p^I_t-\frac{\varepsilon-1}{\varepsilon}\right).
\]

- **(F9) 绿色生产**：

\[
\widetilde{y}^G_t=\left(\frac{\widetilde{k}^G_{t-1}}{\theta}\right)^\alpha(h^G_t)^{1-\alpha}.
\]

- **(F10) 棕色生产**：

\[
\widetilde{y}^B_t=\left(\frac{\widetilde{k}^B_{t-1}}{\theta}\right)^\alpha(h^B_t)^{1-\alpha}.
\]

- **(F11) 绿色劳动需求**：

\[
\widetilde{w}_t h^G_t=(1-\alpha)p^G_t\widetilde{y}^G_t .
\]

- **(F12) 棕色劳动需求**：

\[
\widetilde{w}_t h^B_t=(1-\alpha)\left[p^B_t-\tau_t(1-\mu_t)\nu_E-\frac{\nu_M}{1+\chi}\mu_t^{1+\chi}\right]\widetilde{y}^B_t .
\]

- **(F13) 绿色资本需求**：

\[
r^G_{kt}\frac{\widetilde{k}^G_{t-1}}{\theta}=\alpha p^G_t\widetilde{y}^G_t .
\]

- **(F14) 棕色资本需求**：

\[
r^B_{kt}\frac{\widetilde{k}^B_{t-1}}{\theta}
=\alpha\left[p^B_t-\tau_t(1-\mu_t)\nu_E-\frac{\nu_M}{1+\chi}\mu_t^{1+\chi}\right]\widetilde{y}^B_t .
\]

- **(F15) 绿色资本租金率**：

\[
r^G_{kt}=r^G_tq_{t-1}-(1-\delta)q_t .
\]

- **(F16) 棕色资本租金率**：

\[
r^B_{kt}=r^B_tq_{t-1}-(1-\delta)q_t .
\]

- **(F17) 最优减排**：

\[
\mu_t=\left(\frac{\nu_E\tau_t}{\nu_M}\right)^{1/\chi}.
\]

- **(F18) 资本品生产者 Tobin's Q 条件**：

\[
\begin{aligned}
1={}&q_t\left[1-\frac{\kappa_I}{2}\left(\frac{\widetilde{i}_t}{\widetilde{i}_{t-1}}\theta-\theta\right)^2
-\kappa_I\frac{\widetilde{i}_t}{\widetilde{i}_{t-1}}\theta\left(\frac{\widetilde{i}_t}{\widetilde{i}_{t-1}}\theta-\theta\right)\right]\\
&+\beta E_t\left[
\frac{\widetilde{\lambda}_{t+1}}{\widetilde{\lambda}_t\theta}q_{t+1}
\left(\frac{\widetilde{i}_{t+1}}{\widetilde{i}_t}\theta\right)^2
\kappa_I\left(\frac{\widetilde{i}_{t+1}}{\widetilde{i}_t}\theta-\theta\right)
\right].
\end{aligned}
\]

- **(F19) 带外部习惯的消费边际效用**：

\[
\widetilde{\lambda}_t=\frac{\theta}{\theta\widetilde{c}_t-\varsigma\widetilde{c}_{t-1}}
-\beta\varsigma E_t\left(\frac{1}{\theta\widetilde{c}_{t+1}-\varsigma\widetilde{c}_t}\right).
\]

## 4. Market Clearing & Identities

- **(F20) 排放函数**：

\[
\widetilde{e}_t=(1-\mu_t)\nu_E\widetilde{y}^B_t .
\]

- **(F21) 污染积累**：

\[
\widetilde{x}_t=(1-\delta^x)\frac{\widetilde{x}_{t-1}}{\theta}+\widetilde{e}_t+\widetilde{e}^{row}.
\]

- **(F22) 资本积累**：

\[
\widetilde{k}_t=(1-\delta)\frac{\widetilde{k}_{t-1}}{\theta}
+\left[1-\frac{\kappa_I}{2}\left(\frac{\widetilde{i}_t}{\widetilde{i}_{t-1}}\theta-\theta\right)^2\right]\widetilde{i}_t .
\]

- **(F23) 资源约束**：

\[
\widetilde{y}_t=\widetilde{c}_t+\widetilde{i}_t+\widetilde{g}
+\widetilde{y}^B_t\frac{\nu_M}{1+\chi}\mu_t^{1+\chi}
+\frac{\kappa_P}{2}(\pi_t-\bar{\pi})^2\widetilde{y}_t .
\]

- **(F24) 劳动市场出清**：

\[
h_t=h^B_t+h^G_t .
\]

- **(F25) 资本市场出清**：

\[
\widetilde{k}_t=\widetilde{k}^B_t+\widetilde{k}^G_t .
\]

- **(F26) 绿色债券市场出清**：

\[
q_t\widetilde{k}^G_t=\widetilde{b}^G_{Ht}+\widetilde{b}^G_{Ct}.
\]

- **(F27) 棕色债券市场出清**（`needs_review`：附录 OCR 漏掉中央银行棕色债券的时间下标）：

\[
q_t\widetilde{k}^B_t=\widetilde{b}^B_{Ht}+\widetilde{b}^B_{Ct}.
\]

- **(F28) 中央银行资产负债表**（`needs_review`：MinerU 对实际准备金的渲染有歧义）：

\[
\widetilde{b}^G_{Ct}+\widetilde{b}^B_{Ct}+\widetilde{d}_{Ct}=\widetilde{re}_t .
\]

- **(F29) 碳价格换算**：

\[
p^C_t=\frac{s_1s_2}{s_3}\tau_t .
\]

- **(F30) 欧元区污染存量**：

\[
\widetilde{x}^{ea}_t=(1-\delta^x)\frac{\widetilde{x}^{ea}_{t-1}}{\theta}+\widetilde{e}_t .
\]

## 5. Exogenous Processes

- **(F31) TFP 过程**：

\[
\log(a_t)=\log(\bar{a})+\rho_a\log(a_{t-1})+v^a_t .
\]

- **政策路径**：论文附录把 \(\tau_t\) 和 \(\widetilde{re}_t\) 作为转型和 Green QE 情景中的外生政策工具，而不是平稳冲击过程。
- **仅作实现交叉检查**：`NK_FNL23_rep.mod` 增加了 \(a_t\)、投资专用生产率 \(\varepsilon^I_t\)、政府支出 \(G_t\) 以及 Taylor 规则货币政策冲击的随机过程。这些内容有助于检查 MMB 模拟覆盖，但本推导不把它们当作论文侧来源方程。

## 6. Steady-State Solution

论文给出初始和最终稳态的构造步骤，而不是每个变量的完整闭式解。

初始稳态：

1. 设 \(\tau=0\)，因此 \(\mu=0\)。
2. 用债券欧拉方程设定 \(\beta=\theta/rr\)，其中 \(rr=r/\pi\)。
3. 设 \(\pi=\bar{\pi}\)，\(r=\bar{\pi}\theta/\beta\)，\(r^G=rr+\gamma^G\)，\(r^B=rr+\gamma^B\)，\(q=1\)，\(r^G_k=r^G-(1-\delta)\)，\(r^B_k=r^B-(1-\delta)\)。
4. 由 Phillips 曲线得到 \(p^I=(\varepsilon-1)/\varepsilon\)。
5. 给定 \(p^B\)，由下式计算 \(p^G\)：

\[
p^G=\left\{\frac{(p^I)^{1-\xi}-\zeta(p^B)^{1-\xi}}{1-\zeta}\right\}^{1/(1-\xi)}.
\]

6. 由 (F6) 和 (F7) 确定部门产出，由 (F20)-(F21) 确定污染，由投资产出比和 (F22) 确定投资与总资本，并由 (F13)-(F14) 确定部门资本。
7. 由 (F9)-(F10) 确定部门劳动，由 (F11) 确定工资，由 \(g/y\) 校准确定政府支出，由 (F23) 确定消费，并由 (F24) 确定总劳动。
8. 家庭债券持有量由 (F26)-(F27) 得到，\(\kappa_G,\kappa_B,\nu_G,\nu_B\) 由稳态利差和债券欧拉方程反解。

剩余的初始稳态系统为：

\[
\widetilde{w}h^B=(1-\alpha)\left[p^B-\tau(1-\mu)\nu_E-\frac{\nu_M}{1+\chi}\mu^{1+\chi}\right]\widetilde{y}^B,
\]

\[
\widetilde{\lambda}\widetilde{w}=h^\varphi,
\]

\[
\widetilde{e}=(1-\mu)\nu_E\widetilde{y}^B.
\]

最终稳态：

- 设 \(\mu=1\)，因此 \(\widetilde{e}=0\)。
- 解 \(\{\widetilde{y},p^B,r^G,r^B\}\) 四变量系统：棕色劳动需求、总劳动供给以及两个债券欧拉方程。

运行时验证：未执行。

## 7. Timing & Form Conventions

- 变量由劳动增强型生产率 \(z_t\) 去趋势；附录中的波浪号表示去趋势水平。
- \(k_t\)、\(k^G_t\)、\(k^B_t\) 是期末资本存量。\(t\) 期生产使用 \(k^j_{t-1}/\theta\)。
- 债券 \(b^G_t\) 和 \(b^B_t\) 为部门资本购买融资，并由家庭和中央银行持有量共同出清。
- 模型是水平值非线性模型。MMB `.mod` 实现在非线性稳态块后使用一阶扰动；它还为商业周期模拟引入额外随机冲击。
- 论文转型实验使用碳税和中央银行准备金的外生政策路径。

## 8. Variable & Parameter Reference Table

### 内生变量

| 符号 | 含义 | 主要决定方程 |
|---|---|---|
| \(\widetilde{c}\) | 去趋势消费 | F19, F23 |
| \(\widetilde{i}\) | 去趋势投资 | F18, F22, F23 |
| \(\widetilde{y}\) | 去趋势最终产出 | F5, F23 |
| \(\widetilde{k}\) | 总资本 | F22, F25 |
| \(h\) | 总劳动 | F1, F24 |
| \(\widetilde{w}\) | 去趋势工资 | F1, F11, F12 |
| \(q\) | 资本价格 | F15, F16, F18 |
| \(p^I\) | 中间投入价格 / 实际边际成本 | F6, F7, F8 |
| \(\pi\) | 总通胀率 | F2, F8 |
| \(r\) | 公共债券/准备金名义利率 | F2 |
| \(r^G,r^B\) | 绿色与棕色实际债券利率 | F3, F4, F15, F16 |
| \(\widetilde{b}^G_H,\widetilde{b}^B_H\) | 家庭绿色/棕色债券 | F3, F4, F26, F27 |
| \(\widetilde{b}^G_C,\widetilde{b}^B_C\) | 中央银行绿色/棕色债券 | F26, F27, F28 |
| \(\mu\) | 棕色部门减排比例 | F17 |
| \(p^G,p^B\) | 绿色与棕色部门价格 | F6, F7, F11-F14 |
| \(\widetilde{k}^G,\widetilde{k}^B\) | 部门资本 | F13-F16, F25 |
| \(h^G,h^B\) | 部门劳动 | F9-F12, F24 |
| \(r^G_k,r^B_k\) | 绿色/棕色资本租金率 | F13-F16 |
| \(\widetilde{e}\) | 排放 | F20 |
| \(\widetilde{x},\widetilde{x}^{ea}\) | 全球与欧元区污染存量 | F21, F30 |
| \(\widetilde{y}^G,\widetilde{y}^B\) | 绿色与棕色产出 | F5-F7, F9-F10 |
| \(\widetilde{\lambda}\) | 消费边际效用 | F19 |

### 外生 / 政策变量

| 符号 | 含义 | 来源状态 |
|---|---|---|
| \(v^a\) | TFP 创新 | 论文附录 |
| \(\tau\) | 碳税政策路径 | 论文附录 |
| \(\widetilde{re}\) | 实际中央银行准备金政策路径 | 论文附录 |
| \(v^i,v^m,v^g\) | 投资、货币政策和政府支出创新 | 仅实现交叉检查 |

### 参数

| 符号 | 含义 |
|---|---|
| \(\beta\), \(\varsigma\), \(\varphi\) | 贴现因子、习惯、Frisch 弹性倒数 |
| \(\nu_G,\nu_B,\kappa_G,\kappa_B\) | 绿色/棕色债券效用水平和曲率 |
| \(\varepsilon,\kappa_P,\bar{\pi}\) | 差异化产品替代弹性、价格调整成本、通胀目标 |
| \(\zeta,\xi\) | 棕色产品权重与绿色-棕色替代弹性 |
| \(\alpha,\delta,\kappa_I,\theta\) | 资本份额、折旧、投资调整成本、趋势增长 |
| \(\nu_E,\nu_M,\chi,\delta^x,e^{row}\) | 排放强度、减排成本、减排曲率、污染衰减、世界其他地区排放 |
| \(\rho_a\) | TFP 持续性 |
| \(s_1,s_2,s_3\) | 碳价格换算因子 |
