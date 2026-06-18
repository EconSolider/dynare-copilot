# US_JPT11 - 推导（最优化问题 + 一阶条件）

> 状态：needs_review。本文件是基于 MinerU Markdown 的第一轮归档抽取，并辅以实现交叉检查。未执行 Dynare 运行时验证。

来源：`US_JPT11`，Alejandro Justiniano、Giorgio E. Primiceri 和 Andrea Tambalotti (2011)，《Investment shocks and the relative price of investment》，*Review of Economic Dynamics* 14, 102-121，DOI `10.1016/j.red.2010.08.004`。主 Markdown 来源：`raw/mmb_mineru/runs/us_jpt11__investment_shocks_and_the_relative_price_of_investment__8d6c49b8/full.md`。原始 PDF：`raw/mmb_papers/Investment shocks and the relative price of investment.pdf`。MinerU run id：`8d6c49b8-f6bc-490f-8ddf-6ab7756b73bc`。

## 1. Model Overview

- **模型**：含两个投资冲击的中等规模美国 New-Neoclassical Synthesis DSGE 模型。
- **经济体**：封闭美国经济，包含最终消费品、差异化中间品、投资品、安装资本、家庭、政府和货币当局。
- **核心区分**：投资特定技术（IST）\(\Upsilon_t\) 将最终品转化为投资品，并决定投资相对价格；投资边际效率（MEI）\(\mu_t\) 将投资品转化为已安装的生产性资本。
- **名义摩擦**：Calvo 黏性价格及价格指数化，Calvo 黏性工资及工资指数化。
- **真实摩擦**：外部习惯形成、可变资本利用率、投资调整成本、中间品生产固定成本、政府支出冲击和跨期偏好冲击。
- **冲击**：中性技术增长、IST 增长、MEI、价格加成、工资加成、跨期偏好、政府支出和货币政策。
- **形式**：论文说明先将模型转化为平稳变量，计算非随机稳态，再在稳态附近作对数线性近似。实现交叉检查 `.agents/skills/dynare-copilot/references/examples/US_JPT11_rep.mod` 使用 `model(linear)`。该 `.mod` 文件仅作为 `implementation_cross_check` 使用，不作为论文侧数学来源。

## 2. Optimization Problems

### 2.1 最终品生产者

竞争性最终品企业聚合差异化中间品：

\[
Y_t=\left[\int_0^1 Y_t(i)^{\frac{1}{1+\lambda_{p,t}}}\,di\right]^{1+\lambda_{p,t}}.
\]

它们以价格 \(P_t(i)\) 购买中间品，并以价格 \(P_t\) 出售总量品。

### 2.2 中间品生产者

中间品企业 \(i\) 使用有效资本和劳动生产：

\[
Y_t(i)=\max\left\{A_t^{1-\alpha}K_t(i)^\alpha L_t(i)^{1-\alpha}
-A_t\Upsilon_t^{\frac{\alpha}{1-\alpha}}F,\;0\right\}.
\]

每期只有比例 \(1-\xi_p\) 的企业可以重新优化价格。未重新优化的企业按如下规则指数化价格：

\[
P_t(i)=P_{t-1}(i)\pi_{t-1}^{\iota_p}\pi^{1-\iota_p}.
\]

重新优化价格的企业选择 \(\tilde P_t(i)\)，在中间品需求和生产技术约束下最大化预期贴现利润：

\[
\max_{\tilde P_t(i)} E_t\sum_{s=0}^{\infty}\xi_p^s
\frac{\beta^s\lambda_{t+s}}{\lambda_t}
\left\{
\tilde P_t(i)\left(\prod_{j=0}^{s}\pi_{t-1+j}^{\iota_p}\pi^{1-\iota_p}\right)Y_{t+s}(i)
-W_{t+s}L_{t+s}(i)-r^k_{t+s}K_{t+s}(i)
\right\}.
\]

### 2.3 投资品生产者

竞争性投资品生产者购买 \(Y_t^I\) 单位最终品，并将其转化为投资品：

\[
\max_{\{I_t,Y_t^I\}} P_{I,t}I_t-P_tY_t^I
\quad\text{s.t.}\quad
I_t=\Upsilon_tY_t^I.
\]

### 2.4 资本品生产者

竞争性资本品生产者购买投资品，并将其转化为新安装资本：

\[
i_t=\mu_t\left(1-S\left(\frac{I_t}{I_{t-1}}\right)\right)I_t.
\]

它们最大化预期贴现利润：

\[
\max_{\{I_t,i_t\}} E_t\sum_{s=0}^{\infty}\beta^s\lambda_{t+s}
\left[P_{k,t+s}i_{t+s}-P_{I,t+s}I_{t+s}\right].
\]

### 2.5 家庭

家庭 \(j\) 最大化：

\[
\max_{\{C_t,L_t(j),B_t,\bar K_t,u_t,W_t(j)\}} E_t\sum_{s=0}^{\infty}\beta^s b_{t+s}
\left[
\log(C_{t+s}-hC_{t+s-1})
-\varphi\frac{L_{t+s}(j)^{1+\nu}}{1+\nu}
\right].
\]

名义预算约束为：

\[
P_tC_t+P_{k,t}i_t+T_t+B_t
\le R_{t-1}B_{t-1}+Q_t(j)+\Pi_t+W_t(j)L_t(j)
+r_t^k u_t\bar K_{t-1}
-P_t\frac{a(u_t)}{\Upsilon_t}\bar K_{t-1}.
\]

资本服务和物理资本演化为：

\[
K_t=u_t\bar K_{t-1},
\qquad
\bar K_t=(1-\delta)\bar K_{t-1}+i_t.
\]

家庭是专门化劳动的垄断供应者。就业中介聚合劳动：

\[
L_t=\left[\int_0^1 L_t(j)^{\frac{1}{1+\lambda_{w,t}}}\,dj\right]^{1+\lambda_{w,t}}.
\]

未重新优化的工资遵循：

\[
W_t(j)=W_{t-1}(j)
\left(\pi_{t-1}e^{z_{t-1}+\frac{\alpha}{1-\alpha}\upsilon_t}\right)^{\iota_w}
\left(\pi e^{\gamma_z+\frac{\alpha}{1-\alpha}\gamma_\upsilon}\right)^{1-\iota_w}.
\]

### 2.6 政府和货币当局

政府支出是 GDP 中外生变化的一部分：

\[
G_t=\left(1-\frac{1}{g_t}\right)Y_t.
\]

货币当局遵循 Taylor 型规则：

\[
\frac{R_t}{R}
=\left(\frac{R_{t-1}}{R}\right)^{\rho_R}
\left[
\left(\frac{\pi_t}{\pi}\right)^{\phi_\pi}
\left(\frac{X_t}{X_t^{\ast}}\right)^{\phi_X}
\right]^{1-\rho_R}
\left[
\frac{X_t/X_{t-1}}{X_t^{\ast}/X_{t-1}^{\ast}}
\right]^{\phi_{dX}}
\varepsilon_{mp,t}.
\]

## 3. First-Order Conditions

- **(F1) 最终品价格指数**：

\[
P_t=\left[\int_0^1 P_t(i)^{-\frac{1}{\lambda_{p,t}}}\,di\right]^{-\lambda_{p,t}}.
\]

- **(F2) 对中间品 \(i\) 的需求**：

\[
Y_t(i)=\left(\frac{P_t(i)}{P_t}\right)^{-\frac{1+\lambda_{p,t}}{\lambda_{p,t}}}Y_t.
\]

- **(F3) 中间品企业资本-劳动成本条件** needs_review：

\[
\frac{r_t^k}{W_t}
=\frac{\alpha}{1-\alpha}\frac{L_t(i)}{K_t(i)}.
\]

这是生产函数的标准成本最小化含义；论文给出了优化问题，但提取出的 Markdown 在主模型部分没有打印该条件。

- **(F4) 由要素价格定义的实际边际成本** needs_review：

\[
s_t=\left(\frac{r_t^k}{\alpha}\right)^\alpha
\left(\frac{W_t}{1-\alpha}\right)^{1-\alpha}
A_t^{-(1-\alpha)}.
\]

\(s_t\) 关于 \(A_t\) 和 \(\Upsilon_t\) 的确切平稳化尺度需要回到来源核查。

- **(F5) Calvo 价格设定条件** needs_review：

\[
\tilde P_t(i)\;\text{solves the discounted profit problem in Section 2.2 subject to }(F2).
\]

论文侧 Markdown 给出目标函数，但没有给出显式递归 Phillips 曲线表示。实现交叉检查使用带价格指数化和价格加成冲击的对数线性价格 Phillips 曲线。

- **(F6) 投资品零利润 / 相对价格条件**：

\[
\frac{P_{I,t}}{P_t}=\Upsilon_t^{-1}.
\]

- **(F7) 已安装资本生产者零利润条件**：

\[
P_{k,t}i_t=P_t\tilde I_t,
\qquad
\tilde I_t\equiv \frac{P_{I,t}}{P_t}I_t.
\]

- **(F8) 资本品生产者跨期 \(Q\) 条件** needs_review：

\[
P_{I,t}
=P_{k,t}\mu_t
\left[
1-S\left(\frac{I_t}{I_{t-1}}\right)
-S'\left(\frac{I_t}{I_{t-1}}\right)\frac{I_t}{I_{t-1}}
\right]
+E_t\left[
\beta\frac{\lambda_{t+1}}{\lambda_t}
P_{k,t+1}\mu_{t+1}
S'\left(\frac{I_{t+1}}{I_t}\right)
\left(\frac{I_{t+1}}{I_t}\right)^2
\right].
\]

\(Q\) 条件的精确归一化是第一轮结果，应与 PDF 核查。

- **(F9) 带习惯的消费边际效用** needs_review：

\[
\lambda_t
=b_t(C_t-hC_{t-1})^{-1}
-\beta h\,E_t\left[b_{t+1}(C_{t+1}-hC_t)^{-1}\right].
\]

- **(F10) 债券 Euler 方程** needs_review：

\[
\lambda_t
=\beta E_t\left[\lambda_{t+1}\frac{R_t}{\pi_{t+1}}\right].
\]

- **(F11) 资本利用率条件** needs_review：

\[
r_t^k=P_t\frac{a'(u_t)}{\Upsilon_t}.
\]

以实际量表示时，该条件令有效资本服务的边际租金价值等于边际利用成本。论文记录了利用成本尺度，但 OCR 文本在 \(\Upsilon_t\) 符号附近有噪声。

- **(F12) 物理资本积累**：

\[
\bar K_t=(1-\delta)\bar K_{t-1}+i_t.
\]

- **(F13) 对专门化劳动 \(j\) 的需求**：

\[
L_t(j)=\left(\frac{W_t(j)}{W_t}\right)^{-\frac{1+\lambda_{w,t}}{\lambda_{w,t}}}L_t.
\]

- **(F14) 总工资指数**：

\[
W_t=\left[\int_0^1 W_t(j)^{-\frac{1}{\lambda_{w,t}}}\,dj\right]^{-\lambda_{w,t}}.
\]

- **(F15) 最优重设工资条件** needs_review：

\[
\tilde W_t(j)\;\text{solves the household wage-setting problem subject to }(F13).
\]

论文描述了该问题，但 MinerU Markdown 没有在模型部分给出闭式工资 Phillips 曲线。实现交叉检查确认模型使用带工资加成冲击和指数化的对数线性工资 Phillips 曲线。

## 4. Market Clearing & Identities

- **(F16) 有效资本服务**：

\[
K_t=u_t\bar K_{t-1}.
\]

- **(F17) 投资品技术**：

\[
I_t=\Upsilon_tY_t^I.
\]

- **(F18) 新安装资本技术**：

\[
i_t=\mu_t\left(1-S\left(\frac{I_t}{I_{t-1}}\right)\right)I_t.
\]

- **(F19) 单部门资本积累表示**：

\[
\bar K_t=(1-\delta)\bar K_{t-1}+\mu_t\Upsilon_t(1-S_t)\tilde I_t,
\qquad
S_t\equiv S\left(\frac{I_t}{I_{t-1}}\right).
\]

- **(F20) 政府支出恒等式**：

\[
G_t=\left(1-\frac{1}{g_t}\right)Y_t.
\]

- **(F21) GDP / 产出缺口目标恒等式** needs_review：

\[
X_t^{\ast}=\text{flexible-price/wage counterpart of }X_t.
\]

Taylor 规则使用 GDP 缺口 \(X_t/X_t^{\ast}\)。论文在政策规则中使用灵活经济对象，实现交叉检查包含对应的星号变量。

## 5. Exogenous Processes

- **(F22) 价格加成冲击**：

\[
\log\lambda_{p,t}
=(1-\rho_p)\log\lambda_p+\rho_p\log\lambda_{p,t-1}
+\varepsilon_{p,t}-\theta_p\varepsilon_{p,t-1}.
\]

- **(F23) 中性技术增长**：

\[
z_t=(1-\rho_z)\gamma_z+\rho_z z_{t-1}+\varepsilon_{z,t}.
\]

- **(F24) IST 增长**：

\[
\upsilon_t=(1-\rho_\upsilon)\gamma_\upsilon+\rho_\upsilon\upsilon_{t-1}
+\varepsilon_{\upsilon,t}.
\]

- **(F25) MEI 冲击**：

\[
\log\mu_t=\rho_\mu\log\mu_{t-1}+\varepsilon_{\mu,t}.
\]

- **(F26) 跨期偏好冲击**：

\[
\log b_t=\rho_b\log b_{t-1}+\varepsilon_{b,t}.
\]

- **(F27) 工资加成冲击**：

\[
\log\lambda_{w,t}
=(1-\rho_w)\log\lambda_w+\rho_w\log\lambda_{w,t-1}
+\varepsilon_{w,t}-\theta_w\varepsilon_{w,t-1}.
\]

- **(F28) 政府支出冲击**：

\[
\log g_t=(1-\rho_g)\log g+\rho_g\log g_{t-1}+\varepsilon_{g,t}.
\]

- **(F29) 货币政策规则**：

\[
\frac{R_t}{R}
=\left(\frac{R_{t-1}}{R}\right)^{\rho_R}
\left[
\left(\frac{\pi_t}{\pi}\right)^{\phi_\pi}
\left(\frac{X_t}{X_t^{\ast}}\right)^{\phi_X}
\right]^{1-\rho_R}
\left[
\frac{X_t/X_{t-1}}{X_t^{\ast}/X_{t-1}^{\ast}}
\right]^{\phi_{dX}}
\varepsilon_{mp,t}.
\]

## 6. Steady-State Solution

论文通过去趋势化非平稳变量、计算转化后模型的非随机稳态，并在稳态附近对数线性化来求解模型。主 Markdown 来源没有打印完整解析稳态系统，因此本节为 `needs_review`。

来源中明确的稳态限制包括：

\[
\gamma_\ast=\gamma_z+\frac{\alpha}{1-\alpha}\gamma_\upsilon.
\]

\[
S=0,\qquad S'=0,\qquad S''>0.
\]

\[
u=1,\qquad a(1)=0,\qquad
\chi=\frac{a''(1)}{a'(1)}.
\]

\[
\frac{P_I}{P}=\Upsilon^{-1},
\qquad
\mu=1,
\qquad
\log\lambda_p=\log\lambda_p,
\qquad
\log\lambda_w=\log\lambda_w.
\]

实现交叉检查在内部用 \(\alpha\)、\(\delta\)、价格和工资指数化、习惯、加成、增长率、政策系数、冲击持续性和调整成本参数等校准值计算线性模型稳态。未运行 Dynare，且这些实现侧稳态定义不提升为论文侧来源状态。

## 7. Timing & Form Conventions

- **资本时序**：物理安装资本 \(\bar K_t\) 是期末存量。\(t\) 期生产使用有效资本 \(K_t=u_t\bar K_{t-1}\)。
- **投资时序**：\(I_t/I_{t-1}\) 进入调整成本，因此滞后投资是资本品生产者问题中的状态。
- **技术趋势**：中性技术 \(A_t\) 和 IST \(\Upsilon_t\) 的水平非平稳。平稳转化模型使用增长率 \(z_t=\Delta\log A_t\) 和 \(\upsilon_t=\Delta\log\Upsilon_t\)。
- **复合趋势**：平衡增长趋势是 \(A_t\Upsilon_t^{\alpha/(1-\alpha)}\)，稳态增长率为 \(\gamma_\ast\)。
- **相对价格约定**：在竞争性基准中，\(P_{I,t}/P_t=\Upsilon_t^{-1}\)。附录 A 说明，当消费品和投资品生产部门都存在黏性价格时，该等式可能失效。
- **形式**：本归档条目标记为 `model(linear)`，因为论文说明对去趋势模型作对数线性近似，且 Rep-MMB 实现使用 `model(linear)`。
- **运行时验证**：按指令未执行。

## 8. Variable & Parameter Reference Table

| 类别 | 符号 / ASCII | 含义 | 主要方程 |
|---|---|---|---|
| 内生 | \(Y_t\), `y` | 最终产出 | (F1), (F2), (F20) |
| 内生 | \(Y_t(i)\) | 中间品品种 | (F2) |
| 内生 | \(P_t\), `p` | 最终品价格指数 / 通胀基础 | (F1), (F29) |
| 内生 | \(P_t(i)\) | 中间品价格 | (F2), (F5) |
| 内生 | \(s_t\), `s` | 实际边际成本 | (F4), (F5) |
| 内生 | \(K_t\), `k` | 有效资本服务 | (F3), (F16) |
| 内生 | \(\bar K_t\), `kbar` | 已安装物理资本存量 | (F12), (F19) |
| 内生 | \(L_t\), `L` | 总劳动 | (F13), (F14) |
| 内生 | \(W_t\), `w` | 归一化后的名义 / 实际工资 | (F13), (F14), (F15) |
| 内生 | \(C_t\), `c` | 消费 | (F9), (F10) |
| 内生 | \(\lambda_t\), `lambda` | 边际效用 / 随机贴现因子 | (F8), (F9), (F10) |
| 内生 | \(I_t\), `i` | 投资品 | (F6), (F8), (F17), (F18) |
| 内生 | \(i_t\) | 新安装资本 | (F7), (F18) |
| 内生 | \(\tilde I_t\) | 以消费品计的实际投资 | (F7), (F19) |
| 内生 | \(P_{I,t}\) | 投资品价格 | (F6), (F7), (F8) |
| 内生 | \(P_{k,t}\), `q` | 已安装资本价格 / Tobin's Q | (F7), (F8) |
| 内生 | \(u_t\), `u` | 资本利用率 | (F11), (F16) |
| 内生 | \(r_t^k\), `mpk` / `Rk` | 资本租金率或回报 | (F3), (F11) |
| 内生 | \(G_t\), `g` | 政府支出 | (F20), (F28) |
| 内生 | \(R_t\), `R` | 名义政策毛利率 | (F10), (F29) |
| 内生 | \(\pi_t\), `p` | 毛通胀 / 线性形式下的对数通胀 | (F5), (F29) |
| 内生 | \(X_t/X_t^{\ast}\), `gdp-gap` | 相对灵活经济的 GDP 缺口 | (F21), (F29) |
| 外生 | \(\varepsilon_{z,t}\), `zs` | 中性技术增长创新 | (F23) |
| 外生 | \(\varepsilon_{\upsilon,t}\), `upsilons` | IST 增长创新 | (F24) |
| 外生 | \(\varepsilon_{\mu,t}\), `mius` | MEI 创新 | (F25) |
| 外生 | \(\varepsilon_{p,t}\), `lambdaps` | 价格加成创新 | (F22) |
| 外生 | \(\varepsilon_{w,t}\), `lambdaws` | 工资加成创新 | (F27) |
| 外生 | \(\varepsilon_{b,t}\), `bs` | 跨期偏好创新 | (F26) |
| 外生 | \(\varepsilon_{g,t}\), `gs` | 政府支出创新 | (F28) |
| 外生 | \(\varepsilon_{mp,t}\), `Rs` | 货币政策创新 | (F29) |
| 参数 | \(\alpha\) | 资本份额 | (F3), (F4), (F23) |
| 参数 | \(\beta\) | 贴现因子 | (F5), (F8), (F10) |
| 参数 | \(\delta\) | 折旧率 | (F12), (F19) |
| 参数 | \(h\) | 习惯参数 | (F9) |
| 参数 | \(\xi_p,\iota_p\) | 价格黏性与指数化 | (F5) |
| 参数 | \(\xi_w,\iota_w\) | 工资黏性与指数化 | (F15) |
| 参数 | \(\lambda_p,\lambda_w\) | 期望价格和工资加成 | (F22), (F27) |
| 参数 | \(\rho_z,\rho_\upsilon,\rho_\mu,\rho_b,\rho_g,\rho_p,\rho_w\) | 冲击持续性参数 | (F22)-(F28) |
| 参数 | \(\phi_\pi,\phi_X,\phi_{dX},\rho_R\) | 货币政策系数 | (F29) |
| 参数 | \(S(\cdot)\), \(S'(\cdot)\) | 投资调整成本函数 | (F8), (F18), (F19) |
| 参数 | \(\chi\) | 资本利用率曲率 | (F11), Section 6 |
