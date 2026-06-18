# NK_GN25 - 推导（最优化问题 + 均衡条件）

> MMB 模型 `NK_GN25` 的来源支持型一稿归档推导。未执行运行时验证。状态：`needs_review`。

来源信息：Gnocato, Nicolo (2025), "Energy price shocks, unemployment, and monetary policy", *Journal of Monetary Economics*, DOI `10.1016/j.jmoneco.2025.103734`。主要来源 Markdown：`raw/mmb_mineru/runs/nk_gn25__energy_price_shocks_unemployment_and_monetary_policy__ca6f092e/full.md`。已检查原始 PDF 路径：`raw/mmb_papers/Energy price shocks, unemployment, and monetary policy.pdf`。MinerU run id：`ca6f092e-7214-4c3a-be67-f019e816eacc`。未找到 appendix-normalization 文件或可用于交叉检查的实现 `.mod`。

## 1. Model Overview

- **模型**：具有未保险失业风险、搜寻匹配劳动市场摩擦、非位似能源消费、以及能源作为非生产性生产投入的异质主体新凯恩斯模型。
- **主要实验**：具有持续性的实际能源价格冲击；比较严格非能源通胀目标、稳定失业政策、优化简单规则和最优政策。
- **主体和部门**：就业与失业工人、风险中性企业所有者、竞争性最终品集成商、Calvo 批发企业、劳动中介、财政当局和货币当局。
- **模型形式**：定量 MMB 风格动态系统为 `model(linear)`。论文先给出非线性的家庭、生产、定价和劳动市场方程，然后在第 5 节给出一阶近似系统。下面的 F 编号模拟模块记录线性化模型及解释它所需的来源非线性定义。
- **审阅状态**：`needs_review`；MinerU OCR 在若干参数名称和部分 appendix/最优政策表达式中含有 `??` 占位符。

## 2. Optimization Problems

### 工人

工人处于就业状态 \(i=n\) 或失业状态 \(i=u\)。他们选择非能源消费 \(g_t^i\)、能源 \(e_t^i\) 和名义一期债券 \(B_t^i\)，并受零债务约束限制。其 Stone-Geary 消费篮子为：

\[
c_t^i = (g_t^i)^{1-\omega_e}(e_t^i-\xi)^{\omega_e}, \qquad i\in\{n,u\}.
\]

递归效用为：

\[
U_t^n=\ln(c_t^n)+\beta E_t\left[(1-\lambda_{t+1})U_{t+1}^n+\lambda_{t+1}U_{t+1}^u\right],
\]

\[
U_t^u=\ln(c_t^u)+\beta E_t\left[f_{t+1}U_{t+1}^n+(1-f_{t+1})U_{t+1}^u\right].
\]

名义预算约束和借款约束为：

\[
P_{g,t}g_t^i+P_{e,t}e_t^i+B_t^i={\cal Y}_t^i+(1+i_{t-1})B_{t-1}^i,\qquad B_t^i\ge 0,
\]

其中 \({\cal Y}_t^n=W_t\)，\({\cal Y}_t^u=\Delta_t\)。

### 最终品集成商

竞争性集成商将差异化非能源批发品组合为：

\[
Y_t=\left(\int_0^1 y_t(k)^{\frac{\varepsilon-1}{\varepsilon}}dk\right)^{\frac{\varepsilon}{\varepsilon-1}}.
\]

### 批发企业

每个批发企业以固定比例使用劳动服务和能源：

\[
y_t(k)=\min\left\{\frac{l_t(k)}{1-\gamma_e},\frac{e_t(k)}{\gamma_e}\right\}.
\]

批发企业在 Calvo 摩擦 \(\theta\) 下设定价格。来源报告了最优重置价格的递归辅助变量；这些变量记录在第 3 节。

### 劳动中介

中介以流量成本 \(\kappa\) 发布岗位，并在摩擦性匹配市场雇佣劳动。一个匹配的价值为：

\[
J_t=(1-\tau_z)(\varphi_t-w_t+S)+\beta(1-\rho)E_t[J_{t+1}].
\]

岗位发布的自由进入条件给出下方记录的就业创造条件。

### 政策当局

财政当局使用补贴/税收 \(\tau_y\)、\(\tau_z\) 和 \(S\) 抵消稳态扭曲。货币政策或者表示为简单利率规则，或者表示为线性二次问题导出的最优政策目标条件。

## 3. First-Order Conditions

- **(F1) 类型 \(i\) 工人的非能源需求**：

\[
g_t^i=(1-\omega_e)\left(\frac{P_t}{P_{g,t}}\right)c_t^i.
\]

- **(F2) 类型 \(i\) 工人的能源需求**：

\[
e_t^i=\omega_e\left(\frac{P_t}{P_{e,t}}\right)c_t^i+\xi.
\]

- **(F3) CPI 集成式**：

\[
P_t=\left(\frac{P_{g,t}}{1-\omega_e}\right)^{1-\omega_e}
\left(\frac{P_{e,t}}{\omega_e}\right)^{\omega_e}.
\]

`needs_review`：来源中的式 (4) 打印为 Cobb-Douglas 价格指数；最终审阅前应对照 PDF 检查本式。

- **(F4) 就业工人 Euler 不等式**：

\[
\frac{1}{c_t^n}\geq \beta E_t\left\{\left(\frac{1+i_t}{1+\pi_{t+1}}\right)
\left[(1-\lambda_{t+1})\frac{1}{c_{t+1}^n}+\lambda_{t+1}\frac{1}{c_{t+1}^u}\right]\right\}.
\]

`needs_review`：期望内应为乘积关系；OCR 空格可能遮蔽了该关系。

- **(F5) 失业工人 Euler 不等式**：

\[
\frac{1}{c_t^u}\geq \beta E_t\left\{\left(\frac{1+i_t}{1+\pi_{t+1}}\right)
\left[f_{t+1}\frac{1}{c_{t+1}^n}+(1-f_{t+1})\frac{1}{c_{t+1}^u}\right]\right\}.
\]

`needs_review`：期望内应为乘积关系；OCR 空格可能遮蔽了该关系。

- **(F6) 零流动性均衡下就业者消费**：

\[
c_t^n=w_t-p_{e,t}\xi.
\]

- **(F7) 零流动性均衡下失业者消费**：

\[
c_t^u=\delta_t-p_{e,t}\xi.
\]

- **(F8) 品种需求**：

\[
y_t(k)=Y_t\left[\frac{P_t(k)}{P_{g,t}}\right]^{-\varepsilon}.
\]

- **(F9) 劳动服务投入需求**：

\[
l_t(k)=(1-\gamma_e)y_t(k).
\]

- **(F10) 能源投入需求**：

\[
e_t(k)=\gamma_e y_t(k).
\]

- **(F11) 批发部门实际边际成本**：

\[
mc_{g,t}=(1-\gamma_e)\frac{\Phi_t}{P_{g,t}}+\gamma_e\frac{P_{e,t}}{P_{g,t}}.
\]

- **(F12) 最优重置价格比率**：

\[
\bar p_{g,t}=\frac{\bar P_t}{P_{g,t}}=\frac{{\cal Y}_t}{{\cal Z}_t}.
\]

- **(F13) Calvo 分子递归**：

\[
{\cal Y}_t=(1-\tau_y)\left(\frac{\varepsilon}{\varepsilon-1}\right)\frac{P_{g,t}}{P_t}mc_{g,t}Y_t
+\theta\beta E_t\left[(1+\pi_{g,t+1})^{\varepsilon}{\cal Y}_{t+1}\right].
\]

- **(F14) Calvo 分母递归**：

\[
{\cal Z}_t=\frac{P_{g,t}}{P_t}Y_t+\theta\beta E_t\left[(1+\pi_{g,t+1})^{\varepsilon-1}{\cal Z}_{t+1}\right].
\]

- **(F15) 来自 Calvo 价格指数的非能源通胀规律**：

\[
1+\pi_{g,t}=\left[\frac{1}{\theta}-\left(\frac{1-\theta}{\theta}\right)(\bar p_{g,t})^{1-\varepsilon}\right]^{\frac{1}{\varepsilon-1}}.
\]

- **(F16) 价格分散度规律**：

\[
{\cal D}_t=(1-\theta)(\bar p_{g,t})^{-\varepsilon}+\theta(1+\pi_{g,t})^{\varepsilon}{\cal D}_{t-1}.
\]

- **(F17) 匹配函数**：

\[
m_t=s_t^{\alpha}v_t^{1-\alpha},\qquad s_t=u_{t-1}+\rho n_{t-1}.
\]

- **(F18) 找工作率与岗位填补率**：

\[
f_t=\frac{m_t}{s_t},\qquad q_t=\frac{m_t}{v_t}=f_t^{\frac{\alpha}{\alpha-1}}.
\]

- **(F19) 就业创造 / 自由进入条件**：

\[
f_t^{\frac{\alpha}{1-\alpha}}=\frac{1-\tau_z}{\kappa}(\varphi_t-w_t+S)
+\beta(1-\rho)E_t\left[f_{t+1}^{\frac{\alpha}{1-\alpha}}\right].
\]

- **(F20) 线性化模型中的工资规则**：

\[
\widetilde w_t=-\chi\widetilde p_{e,t}.
\]

## 4. Market Clearing & Identities

- **(F21) 就业存量运动方程**：

\[
n_{t+1}=(1-\lambda_{t+1})n_t+f_{t+1}u_t.
\]

- **(F22) 失业存量运动方程**：

\[
u_{t+1}=(1-f_{t+1})u_t+\lambda_{t+1}n_t.
\]

- **(F23) 分离率和失业恒等式**：

\[
u_t=1-n_t,\qquad \lambda_{t+1}=\rho(1-f_{t+1}).
\]

- **(F24) 劳动市场出清**：

\[
n_t=(1-\gamma_e)Y_t{\cal D}_t.
\]

- **(F25) 企业所有者消费**：

\[
c_t^o=\left(\frac{p_{g,t}{\cal D}_t^{-1}-\gamma_e p_{e,t}}{1-\gamma_e}-w_t\right)n_t
-\kappa\left\{\frac{n_t-(1-\rho)n_{t-1}}{[1-(1-\rho)n_{t-1}]^{\alpha}}\right\}^{\frac{1}{1-\alpha}}.
\]

- **(F26) 线性化失业动态**：

\[
\widehat u_t=(1-\rho)(1-f)\widehat u_{t-1}
-\frac{\rho}{f+\rho(1-f)}\widehat f_t.
\]

- **(F27) 线性化就业创造**：

\[
\widehat f_t=\frac{qf}{\kappa}\left(\frac{1-\alpha}{\alpha}\right)(1-\tau_z)(\widehat\varphi_t-\widehat w_t)
+\beta(1-\rho)E_t(\widehat f_{t+1}).
\]

- **(F28) 线性化实际边际成本**：

\[
\widehat{mc}_{g,t}=(1-\gamma_e)\frac{1}{p_g}\widehat\varphi_t
+\left(\gamma_e\frac{p_e}{p_g}+\frac{\omega_e}{1-\omega_e}\right)\widetilde p_{e,t}.
\]

- **(F29) 新凯恩斯 Phillips 曲线**：

\[
\pi_{g,t}=\beta E_t(\pi_{g,t+1})+\Theta\widehat{mc}_{g,t}.
\]

- **(F30) CPI 通胀恒等式**：

\[
\pi_t=\pi_{g,t}+\frac{\omega_e}{1-\omega_e}(\widetilde p_{e,t}-\widetilde p_{e,t-1}).
\]

- **(F31) 动态 IS 条件**：

\[
\widetilde I_t-E_t(\pi_{t+1})
=E_t(\widetilde w_{t+1}-\widetilde w_t)
+\frac{\Lambda}{1-f}E_t(\widehat f_{t+1})
+\Xi_w\frac{(1+\Lambda\Psi)E_t(\widetilde w_{t+1}-\widetilde p_{e,t+1})-(\widetilde w_t-\widetilde p_{e,t})}{1-\Xi_w}.
\]

- **(F32) 简单利率规则**：

\[
\widetilde I_t=\phi_{\pi}\pi_{g,t}+\phi_f\widehat f_t.
\]

- **(F33) 分析特例中自然失业与有效失业的楔子**：

\[
\widehat u_t^n-\widehat u_t^{\ast}
=\frac{w}{2\kappa}\left(\frac{\zeta\Xi_w}{1-\zeta-\Xi_w}\right)(1+\chi)\widetilde p_{e,t}.
\]

- **(F34) 分析特例中福利相关 NKPC**：

\[
\pi_{g,t}=\beta E_t(\pi_{g,t+1})
-\Theta\frac{2\kappa}{p_g}(1-\gamma_e){\cal V}_t
+\Theta\frac{w}{p_g}(1-\gamma_e)\left(\frac{\zeta\Xi_w}{1-\zeta-\Xi_w}\right)(1+\chi)\widetilde p_{e,t}.
\]

- **(F35) 线性二次损失函数**：

\[
E_t\sum_{j=0}^{\infty}\beta^j\left({\cal V}_{t+j}^2+\Omega\pi_{g,t+j}^2\right).
\]

## 5. Exogenous Processes

- **(F36) 实际能源价格冲击**：

\[
\widetilde p_{e,t}=\rho_e\widetilde p_{e,t-1}+\varepsilon^e_t.
\]

论文将稳态实际能源价格设为 \(p_e=1\)，并在定量练习中考虑持续性 \(\rho_e=0.95\) 的一次性 40% 冲击。

## 6. Steady-State Solution

- 约束有效稳态具有零非能源通胀，\(\pi_g=0\)，因此 \(\bar p_g=1\) 且 \({\cal D}=1\)。
- 实际能源价格均值为 \(p_e=1\)。
- 批发生产补贴抵消稳态加成：

\[
\tau_y=\frac{1}{\varepsilon}.
\]

- 有效工资为：

\[
w^{\ast}=\frac{1}{\nu}+\xi p_e.
\]

- 来源报告的稳态财政工具为：

\[
\tau_y=\frac{1}{\varepsilon},\qquad
S=\frac{1}{\nu}\ln\left(\frac{w^{\ast}-\xi p_e}{\delta-\xi p_e}\right),\qquad
\tau_z=1-\frac{(1-\alpha)[1-\beta(1-\rho)]}{1-\beta(1-\rho)(1-\alpha f^{\ast})}.
\]

- 稳态有效找工作率满足：

\[
f^{\ast}=\left[\frac{1-\tau_z}{\kappa[1-\beta(1-\rho)]}
\left(\frac{p_g-\gamma_e p_e}{1-\gamma_e}-w^{\ast}+S\right)\right]^{\frac{1-\alpha}{\alpha}}.
\]

- 定量校准为季度模型，参数包括 \(\beta=0.98\)、\(\omega_e=0.08\)、\(\Xi_w=0.11\)、\(f=0.25\)、\(u=0.10\)、\(\rho=0.037\)、\(\alpha=0.6\)、\(\chi=0.1\)、\(\gamma_e=0.04\)、\(\theta=3/4\) 和 \(\varepsilon=4\)。
- 对线性化模型，稳态被规范化为相对约束有效稳态的偏离：带帽变量的水平偏离和带波浪变量的比例偏离在稳态均为零。

## 7. Timing & Form Conventions

- 时间频率为季度。
- \(n_t\) 和 \(u_t\) 是就业和失业存量；论文使用 \(s_t=u_{t-1}+\rho n_{t-1}\) 表示搜寻者，因此匹配和岗位发布使用滞后的劳动市场存量。
- \(\lambda_{t+1}=\rho(1-f_{t+1})\) 是从 \(t\) 到 \(t+1\) 的就业转失业概率。
- \({\cal D}_t\) 是类似存量的价格分散度状态，依赖于 \({\cal D}_{t-1}\)。
- 能源为非生产品；其实际价格 \(p_{e,t}=P_{e,t}/P_t\) 外生给定。
- 定量 MMB 归档形式为 `model(linear)`：帽子表示相对约束有效稳态的水平偏离，波浪表示比例偏离。上面的非线性方程保留为需求、定价递归和市场出清的来源定义。
- 运行时验证：未执行。

## 8. Variable & Parameter Reference Table

| 类别 | 符号 / ASCII | 含义 | 主要方程 |
|---|---|---|---|
| 内生 | `c_n`, `c_u` | 就业和失业工人的消费篮子 | (F6), (F7) |
| 内生 | `g_n`, `g_u` | 各类工人的非能源消费 | (F1) |
| 内生 | `e_n`, `e_u` | 各类工人的能源消费 | (F2) |
| 内生 | `P`, `P_g`, `P_e`, `p_e` | CPI、非能源价格、能源价格、实际能源价格 | (F3), (F36) |
| 内生 | `pi`, `pi_g` | CPI 和非能源通胀 | (F15), (F29), (F30) |
| 内生 | `Y`, `y_k` | 最终产出和品种产出 | (F8), (F24) |
| 内生 | `l_k`, `e_k` | 批发企业使用的劳动服务和能源 | (F9), (F10) |
| 内生 | `mc_g` | 非能源实际边际成本 | (F11), (F28) |
| 内生 | `Ycal`, `Zcal`, `pbar_g` | Calvo 定价辅助变量 | (F12)-(F15) |
| 内生 | `D` | 价格分散度 | (F16) |
| 内生 | `n`, `u`, `s`, `m`, `v` | 就业、失业、搜寻者、匹配、岗位 | (F17), (F21)-(F24), (F26) |
| 内生 | `f`, `q`, `lambda` | 找工作率、岗位填补率、就业转失业概率 | (F18), (F19), (F23), (F27) |
| 内生 | `w`, `varphi` | 实际工资和劳动服务实际价格 | (F19), (F20), (F27), (F28) |
| 内生 | `I` | 以偏离表示的名义利率 | (F31), (F32) |
| 内生 | `V` / `mathcal_V` | 福利相关失业缺口 | (F34), (F35) |
| 外生 | `eps_e` | 能源价格创新 | (F36) |
| 参数 | `beta` | 折现因子 | (F4), (F5), (F13), (F14), (F19), (F27), (F29), (F35) |
| 参数 | `omega_e` | 消费中的能源准份额 | (F1)-(F3), (F30) |
| 参数 | `xi` | 生存能源需求 | (F2), (F6), (F7) |
| 参数 | `gamma_e` | 固定比例生产中的能源投入份额 | (F9)-(F11), (F24), (F28), (F34) |
| 参数 | `epsilon` | 品种替代弹性 | (F8), (F13)-(F16) |
| 参数 | `theta` | Calvo 不重置价格概率 | (F13)-(F16) |
| 参数 | `alpha` | 匹配弹性 | (F17)-(F19), (F27) |
| 参数 | `rho` | 分离概率 | (F19), (F21)-(F23), (F26), (F27) |
| 参数 | `kappa` | 岗位发布成本 | (F19), (F25), (F27), (F33), (F34) |
| 参数 | `tau_y`, `tau_z`, `S` | 财政工具/补贴 | (F13), (F19), 稳态 |
| 参数 | `chi` | 实际工资对能源价格的响应 | (F20), (F33), (F34) |
| 参数 | `zeta` | 失业时的消费/收入损失 | (F33), (F34) |
| 参数 | `Xi_w`, `Lambda`, `Psi`, `Theta`, `Omega` | 线性化复合系数 | (F29), (F31), (F33)-(F35) |
| 参数 | `phi_pi`, `phi_f` | 简单规则反馈系数 | (F32) |
| 参数 | `rho_e` | 实际能源价格冲击持续性 | (F36) |
