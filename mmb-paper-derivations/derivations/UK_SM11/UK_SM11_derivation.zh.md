# UK_SM11 -- 推导（对数线性均衡条件提取）

> 私有 MMB 推导工作区的归档条目。未执行运行时验证。论文说明第 2 节给出对数线性均衡条件，并将完整非线性推导指向 Harrison et al. (2011) 技术附录；因此本条目保留论文侧对数线性系统，并将无法从正文取得的原始最优化细节标记为 `needs_review`。

来源信息：`UK_SM11`，Stephen Millard (2011)，"An estimated DSGE model of energy, costs and inflation in the United Kingdom"，Bank of England Working Paper No. 432，DOI `10.2139/ssrn.1898065`。主 Markdown：`raw/mmb_mineru/runs/uk_sm11__an_estimated_dsge_model_of_energy_costs_and_inflation_in_the_united_king__84b3b0b8/full.md`。原始 PDF：`raw/mmb_papers/An estimated DSGE model of energy, costs and inflation in the United Kingdom.pdf`。MinerU run ids：`84b3b0b8-fdb9-42d7-a2f1-4e4e266ccde8`，`7c46224e-727a-48ed-950c-97f2f1810d7d`。

## 1. Model Overview

- **模型**：包含显式能源部门的英国小型开放经济估计 DSGE 模型。
- **论文侧来源**：第 2 节报告 Millard 估计的 Harrison, Thomas and de Weymarn (2011) 模型的对数线性均衡条件。
- **主体与模块**：家庭、差异化劳动供给者、非能源企业、增加值生产者、汽油生产者、公用事业生产者、货币/财政当局以及国外部门。
- **关键特征**：三类消费品（非能源、汽油、公用事业）；劳动、资本、进口中间品、石油和天然气投入；工资粘性；分部门价格粘性；习惯形成；资本调整成本；可变资本利用率；营运资本成本渠道；含外国债券调整成本的 UIP；Taylor 规则；包含汽油税且预算平衡的财政当局。
- **模型形式**：对数线性，MMB 交叉检查文件使用 `model(linear)`。带帽变量为相对趋势或稳态的对数偏离；外国债券持有量按非能源产出份额归一化。
- **状态**：`needs_review`，因为论文正文不包含完整非线性最优化推导，且 Markdown 中若干 OCR 符号需要与 PDF/附录做源码级核查。

## 2. Optimization Problems

论文没有打印原始最大化问题。它说明经济选择，然后给出对数线性均衡条件。底层最优化模块为：

- **家庭**在习惯形成、资本调整/利用成本、债券调整成本以及工资刚性下，选择总消费、非能源/汽油/公用事业消费构成、资本积累、资本利用率、国内外债券头寸和差异化工资。完整原始目标函数和约束为 `needs_review`，因为正文仅说明其在 Harrison et al. (2011) 技术附录中。
- **非能源企业**将增加值/进口品组合与能源组合，最小化增加值、进口中间品、汽油和公用事业投入成本，并在带指数化的价格粘性下定价。
- **增加值生产者**组合劳动和已利用资本，并借款支付一部分工资账单，从而产生营运资本成本渠道。
- **汽油和公用事业生产者**使用能源商品和增加值的 Leontief 技术，并在名义刚性下设置部门价格。
- **进口商**面对向购买力平价缓慢传递的价格过程，形成进口价格 Phillips 曲线。
- **政策当局和国外部门**在正文中是规则/恒等式模块，不是打印出的最优化主体。

## 3. First-Order Conditions

以下条件复现论文中作为主体选择或定价条件的对数线性均衡方程。此处不沿用论文方程号；归档编号连续记为 `(F#)`。

- **(F1) 含习惯的消费 Euler 方程**：

$$
\hat{c}_t =
\frac{\psi_{hab}(1-\sigma_c)}{1+\psi_{hab}(1-\sigma_c)}\hat{c}_{t-1}
+\frac{1}{1+\psi_{hab}(1-\sigma_c)}E_t\hat{c}_{t+1}
-\frac{\sigma_c}{1+\psi_{hab}(1-\sigma_c)}
\left(i_t-E_t\pi_{c,t+1}-\left(\frac{1}{\beta}-1\right)+\varepsilon_{b,t}\right).
$$

- **(F2) 资本积累 / 投资条件**：

$$
\begin{aligned}
i_t-E_t\pi_{c,t+1}-\left(\frac{1}{\beta}-1\right)+\varepsilon_{b,t}
&=\left(\frac{\varepsilon_k}{1-\delta+\chi_z}+1+\varepsilon_k\right)\chi_k\hat{k}_{t-1}\\
&-\left(\frac{1+\varepsilon_k}{1-\delta+\chi_z}+1\right)\chi_k\hat{k}_t
+\frac{\chi_k}{1-\delta+\chi_z}E_t\hat{k}_{t+1}\\
&-\chi_k\varepsilon_k\hat{k}_{t-2}
+\frac{\chi_z}{1-\delta+\chi_z}E_t\hat{w}_{k,t+1}
+\varepsilon_{inv,t}.
\end{aligned}
$$

- **(F3) 资本利用率与资本租金条件**：

$$
\hat{w}_{k,t}=\phi_z\hat{z}_t.
$$

- **(F4) 能源消费聚合器**：

$$
\hat{c}_{E,t}=(1-\psi_p)\hat{c}_{U,t}+\psi_p\hat{c}_{P,t}.
$$

- **(F5) 总消费聚合器**：

$$
\hat{c}_t=(1-\psi_e)\hat{c}_{n,t}+\psi_e\hat{c}_{e,t}.
$$

- **(F6) 非能源/公用事业相对消费需求**：

$$
\hat{p}_{U,t}=\frac{1}{\sigma_e}\hat{c}_{n,t}
+\left(\frac{1}{\sigma_p}-\frac{1}{\sigma_e}\right)\hat{c}_{E,t}
-\frac{1}{\sigma_p}\hat{c}_{U,t}.
$$

- **(F7) 汽油/公用事业相对消费需求**：

$$
\hat{p}_{U,t}-\hat{p}_{P,t}
=-\frac{1}{\sigma_p}\hat{c}_{U,t}
+\frac{1}{\sigma_p}\hat{c}_{P,t}.
$$

- **(F8) 含外国债券调整成本的 UIP**：

$$
E_t\hat{s}_{t+1}-\hat{s}_t
=-\left(i_t-\left(\frac{1}{\beta}-1\right)\right)-\chi_{bf}b_{f,t}+\varepsilon_{rf,t}.
$$

- **(F9) 工资 Phillips 曲线**：

$$
\dot{W}_t=\frac{\xi_w}{1+\beta\xi_w}\dot{W}_{t-1}
+\frac{\beta}{1+\beta\xi_w}E_t\dot{W}_{t+1}
-\frac{\psi_w(1-\beta(1-\psi_w))}
{(1+\sigma_w/\sigma_h)(1-\psi_w)(1+\beta\xi_w)}
(\hat{w}_t-mrs_t)+\varepsilon_{w,t}.
$$

- **(F10) 边际替代率**：

$$
mrs_t=\frac{1}{\sigma_h}\hat{h}_t
+\frac{1}{\sigma_c}\left(\hat{c}_t+\psi_{hab}(\sigma_c-1)\hat{c}_{t-1}\right).
$$

- **(F11) 实际消费工资运动方程**：

$$
\hat{w}_t=\dot{W}_t+\hat{w}_{t-1}-\pi_{c,t}.
$$

- **(F12) 非能源生产**：

$$
\hat{q}_t=(1-\alpha_q)\hat{B}_t+\alpha_q\hat{e}_t+\varepsilon_{a,t}.
$$

- **(F13) 增加值/进口品组合**：

$$
\hat{B}_t=(1-\alpha_B)\hat{V}_{n,t}+\alpha_B\hat{M}_{n,t}.
$$

- **(F14) 非能源生产中的能源投入 Leontief 关系**：

$$
\hat{e}_t=\hat{I}_{p,t}=\hat{I}_{u,t}.
$$

- **(F15) 非能源企业对增加值的需求**：

$$
\hat{V}_{n,t}=\hat{\mu}_t-\hat{p}_{vc,t}
+\frac{1}{\sigma_q}\hat{q}_t
+\frac{\sigma_q-1}{\sigma_q}\hat{B}_t
+\frac{\sigma_q-1}{\sigma_q}\varepsilon_{a,t}.
$$

- **(F16) 非能源企业对进口中间品的需求**：

$$
\hat{M}_{n,t}=\hat{\mu}_t-\hat{p}_{m,t}
+\frac{1}{\sigma_q}\hat{q}_t
-\left(\frac{1}{\sigma_q}-1\right)\hat{B}_t
+\frac{\sigma_q-1}{\sigma_q}\varepsilon_{a,t}.
$$

- **(F17) 非能源企业对能源的需求**：

$$
\hat{e}_t=\sigma_q\hat{\mu}_t+\hat{q}_t
-\sigma_q\left(\psi_n\hat{p}_{p,t}+(1-\psi_n)\hat{p}_{U,t}\right)
+(\sigma_q-1)\varepsilon_{a,t}.
$$

- **(F18) 非能源部门 Phillips 曲线**：

$$
\pi_t=\frac{\beta}{1+\beta\varepsilon}E_t\pi_{t+1}
+\frac{\varepsilon}{1+\beta\varepsilon}\pi_{t-1}
+\frac{(1-\chi_p)(1-\beta\chi_p)}{(1+\beta\varepsilon)\chi_p}\hat{\mu}_t
+\varepsilon_{\mu,t}.
$$

- **(F19) 增加值生产**：

$$
\hat{V}_t=(1-\alpha_v)\hat{h}_t+\alpha_v(\hat{k}_{t-1}+\hat{z}_t).
$$

- **(F20) 含营运资本成本的增加值生产者劳动需求**：

$$
\hat{h}_t=\hat{V}_t+\sigma_V\left(\hat{p}_{vc,t}-\hat{w}_t-\psi_{wc}\left(i_t-\left(\frac{1}{\beta}-1\right)+\varepsilon_{b,t}\right)\right).
$$

- **(F21) 增加值生产者资本服务需求**：

$$
\hat{k}_{t-1}+\hat{z}_t=\hat{V}_t+\sigma_V(\hat{p}_{vc,t}-\hat{w}_{k,t}).
$$

- **(F22) 汽油生产技术**：

$$
\hat{q}_{p,t}=\hat{I}_{o,t}=\hat{V}_{p,t}.
$$

- **(F23) 汽油部门 Phillips 曲线**：

$$
\pi_{pb,t}=\frac{\beta}{1+\beta\varepsilon_{pp}}E_t\pi_{pb,t+1}
+\frac{\varepsilon_{pp}}{1+\beta\varepsilon_{pp}}\pi_{pb,t-1}
+\frac{(1-\chi_{pp})(1-\beta\chi_{pp})}{(1+\beta\varepsilon_{pp})\chi_{pp}}\hat{\mu}_{p,t}.
$$

- **(F24) 汽油边际成本**：

$$
\hat{\mu}_{p,t}=\psi_{qp}\hat{p}_{vc,t}+(1-\psi_{qp})\hat{p}_{o,t}-\hat{p}_{pb,t}.
$$

- **(F25) 基础汽油通胀恒等式**：

$$
\pi_{pb,t}=\pi_t+\hat{p}_{pb,t}-\hat{p}_{pb,t-1}.
$$

- **(F26) 公用事业生产技术**：

$$
\hat{q}_{u,t}=\hat{I}_{g,t}=\hat{V}_{u,t}.
$$

- **(F27) 公用事业部门 Phillips 曲线**：

$$
\pi_{u,t}=\frac{\beta}{1+\beta\varepsilon_u}E_t\pi_{u,t+1}
+\frac{\varepsilon_u}{1+\beta\varepsilon_u}\pi_{u,t-1}
+\frac{(1-\chi_u)(1-\beta\chi_u)}{(1+\beta\varepsilon_u)\chi_u}\hat{\mu}_{u,t}.
$$

- **(F28) 公用事业边际成本**：

$$
\hat{\mu}_{u,t}=\psi_u\hat{p}_{vc,t}+(1-\psi_u)\hat{p}_{g,t}-\hat{p}_{u,t}.
$$

- **(F29) 公用事业通胀恒等式**：

$$
\pi_{u,t}=\pi_t+\hat{p}_{u,t}-\hat{p}_{u,t-1}.
$$

- **(F30) Taylor 规则**：

$$
i_t-\left(\frac{1}{\beta}-1\right)
=\theta_{rg}\left(i_{t-1}-\left(\frac{1}{\beta}-1\right)\right)
+(1-\theta_{rg})(\theta_{pdot}\pi_{c,t}+\theta_y\hat{y}_t)
+\varepsilon_{i,t}.
$$

- **(F31) 汽油税传递**：

$$
\hat{p}_{p,t}=(1-\psi_d)\hat{p}_{pb,t}.
$$

- **(F32) 本币石油价格**：

$$
\hat{p}_{o,t}=\varepsilon_{p_o,t}-\hat{s}_t.
$$

- **(F33) 本币天然气价格**：

$$
\hat{p}_{g,t}=\varepsilon_{p_g,t}-\hat{s}_t.
$$

- **(F34) 进口价格 Phillips 曲线**：

$$
\pi_{m,t}=\frac{\iota_{pm}}{1+\beta\iota_{pm}}\pi_{m,t-1}
+\frac{\beta}{1+\beta\iota_{pm}}E_t\pi_{m,t+1}
+\frac{(1-\xi_{pm})(1-\beta\xi_{pm})}{(1+\beta\iota_{pm})\xi_{pm}}
(\varepsilon_{P_{mf},t}-\hat{s}_t-\hat{p}_{m,t}).
$$

- **(F35) 出口需求**：

$$
\hat{x}_{n,t}=\psi_x\hat{x}_{n,t-1}+(1-\psi_x)(\varepsilon_{y_f,t}-\eta_x\hat{s}_t).
$$

## 4. Market Clearing & Identities

- **(F36) 消费者价格指数 / 总消费价值恒等式**：

$$
\hat{p}_{c,t}+\hat{c}_t
=\frac{c_n}{p_c c}\hat{c}_{n,t}
+\frac{p_u c_u}{p_c c}(\hat{p}_{U,t}+\hat{c}_{U,t})
+\left(1-\frac{c_n}{p_c c}-\frac{p_u c_u}{p_c c}\right)(\hat{p}_{P,t}+\hat{c}_{P,t}).
$$

- **(F37) 总增加值配置**：

$$
\hat{V}_t=\frac{V_n}{V}\hat{V}_{n,t}
+\frac{V_u}{V}\hat{V}_{u,t}
+\left(1-\frac{V_n}{V}-\frac{V_u}{V}\right)\hat{V}_{p,t}.
$$

- **(F38) 汽油品市场出清**：

$$
\hat{q}_{P,t}=\frac{c_P}{q_P}\hat{c}_{P,t}
+\left(1-\frac{c_P}{q_P}\right)\hat{I}_{P,t}.
$$

- **(F39) 公用事业品市场出清**：

$$
\hat{q}_{U,t}=\frac{c_U}{q_U}\hat{c}_{U,t}
+\left(1-\frac{c_U}{q_U}\right)\hat{I}_{U,t}.
$$

- **(F40) 石油投入/出口恒等式**：

$$
\hat{I}_{O,t}=-\frac{X_o}{I_o}\hat{X}_{O,t}.
$$

- **(F41) 天然气投入/出口恒等式**：

$$
\hat{I}_{G,t}=-\frac{X_g}{I_g}\hat{X}_{G,t}.
$$

- **(F42) 非能源产出市场出清**：

$$
\hat{q}_t=\frac{c_n}{q}\hat{c}_{n,t}
+\frac{k}{q}\hat{k}_t-\frac{(1-\delta)k}{q}\hat{k}_{t-1}
+\frac{\chi_z k}{q}\hat{z}_t
+\frac{x_n}{q}\hat{x}_{n,t}
+\frac{c_g}{q}\varepsilon_{g,t}.
$$

- **(F43) 净外国资产积累**：

$$
b_{f,t}=\frac{1}{\beta}b_{f,t-1}
+\frac{x_n}{q}\hat{x}_{n,t}
+\frac{X_g}{q}(\hat{p}_{g,t}+\hat{X}_{g,t})
+\frac{X_o}{q}(\hat{p}_{o,t}+\hat{X}_{o,t})
-\frac{M_n}{q}(\hat{p}_{m,t}+\hat{M}_{n,t}).
$$

政府预算通过一次总付税平衡：

$$
G_t=\psi_d P_{p,t}q_{p,t}+T_t.
$$

这条正文预算式不分配 F 编号，因为论文将其作为财政闭合条件，且对数线性的国内需求扰动进入 (F42)。

## 5. Exogenous Processes

- **(F44) 生产率冲击**：

$$
\varepsilon_{a,t}=\rho_a\varepsilon_{a,t-1}+\eta_{a,t}.
$$

- **(F45) 风险溢价冲击**：

$$
\varepsilon_{b,t}=\rho_b\varepsilon_{b,t-1}+\eta_{b,t}.
$$

- **(F46) 国内需求冲击**：

$$
\varepsilon_{g,t}=\rho_g\varepsilon_{g,t-1}+\eta_{g,t}.
$$

- **(F47) 货币政策冲击**：

$$
\varepsilon_{i,t}=\rho_i\varepsilon_{i,t-1}+\eta_{i,t}.
$$

- **(F48) 价格加成冲击**：

$$
\varepsilon_{\mu,t}=\rho_{\mu}\varepsilon_{\mu,t-1}+\eta_{\mu,t}.
$$

- **(F49) 投资专用技术冲击**：

$$
\varepsilon_{inv,t}=\rho_{inv}\varepsilon_{inv,t-1}+\eta_{inv,t}.
$$

- **(F50) 工资加成冲击**：

$$
\varepsilon_{w,t}=\rho_w\varepsilon_{w,t-1}+\eta_{w,t}.
$$

- **(F51) 世界需求冲击**：

$$
\varepsilon_{y_f,t}=\rho_{y_f}\varepsilon_{y_f,t-1}+\eta_{y_f,t}.
$$

- **(F52) 世界出口/进口价格冲击**：

$$
\varepsilon_{p_{mf},t}=\rho_{p_{mf}}\varepsilon_{p_{mf},t-1}+\eta_{p_{mf},t}.
$$

- **(F53) 世界石油价格冲击**：

$$
\varepsilon_{p_o,t}=\rho_{p_o}\varepsilon_{p_o,t-1}+\eta_{p_o,t}.
$$

- **(F54) 世界天然气价格冲击**：

$$
\varepsilon_{p_g,t}=\rho_{p_g}\varepsilon_{p_g,t-1}+\eta_{p_g,t}.
$$

- **(F55) 世界实际利率冲击**：

$$
\varepsilon_{rf,t}=\rho_{rf}\varepsilon_{rf,t-1}+\eta_{rf,t}.
$$

估计部分打印的国外过程估计值为：$\rho_{y_f}=0.9061$，$\sigma_{y_f}=0.0142$；$\rho_{p_{mf}}=0.8991$，$\sigma_{p_{mf}}=0.0075$；$\rho_{p_o}=0.7283$，$\sigma_{p_o}=0.1410$；$\rho_{p_g}=0.5940$，$\sigma_{p_g}=0.2544$；$\rho_{rf}=0.8738$，$\sigma_{rf}=0.0012$。

## 6. Steady-State Solution

打印出的模型是对数线性模型。因此，带帽变量、通胀偏离、价格偏离和冲击的运行稳态为零：

$$
\hat{x}=0,\quad \pi=0,\quad \dot{W}=0,\quad \varepsilon_j=0,\quad \eta_j=0.
$$

论文校准或固定了对数线性恒等式中使用的稳态比率，包括 $c_n/(p_c c)$、$p_u c_u/(p_c c)$、$V_n/V$、$V_u/V$、$c_P/q_P$、$c_U/q_U$、$X_o/I_o$、$X_g/I_g$、$c_n/q$、$k/q$、$c_g/q$、$x_n/q$、$M_n/q$、$X_o/q$ 和 $X_g/q$。MMB 交叉检查文件将这些设为 `cncratio`、`cucratio`、`vnvratio`、`vuvratio`、`cpqpratio`、`cuquratio`、`xoioratio`、`xgigratio`、`cnqratio`、`kqratio`、`cgqratio`、`xnqratio`、`mnqratio`、`xoqratio` 和 `xgqratio`。

原始非线性稳态方程为 `needs_review`，因为 Millard (2011) 正文没有打印这些方程。在核查被引用的技术附录和完整 MMB 实现之前，不应将此推导提升为非线性可运行模型归档。

## 7. Timing & Form Conventions

- **形式**：对数线性均衡系统；MMB 文件使用 `model(linear)`。
- **预期项**：方程使用 $E_t x_{t+1}$ 表示消费、资本、工资、价格和进口价格条件中的前瞻项。
- **资本时序**：生产性资本服务在 (F19) 和 (F21) 中使用预定资本 $\hat{k}_{t-1}$ 加利用率 $\hat{z}_t$。由于资本调整成本，(F2) 包含 $\hat{k}_{t-2}$、$\hat{k}_{t-1}$、$\hat{k}_t$ 和 $E_t\hat{k}_{t+1}$。
- **价格与通胀**：相对价格为带帽变量；部门通胀恒等式将相对价格变化与非能源通胀相连。
- **外国资产**：$b_{f,t}$ 是按非能源产出归一化的、类似水平变量的对数线性化存量，并在 (F43) 中滞后积累。
- **灵活价格交叉检查**：`.mod` 包含平行灵活价格模块（`cf`、`vaf`、`rf` 等），用于构造 Taylor 规则中的缺口。这是实现证据，不是额外的论文侧来源方程组。
- **运行时验证**：未执行；没有运行 Dynare。

## 8. Variable & Parameter Reference Table

| Category | Symbols / ASCII names | Meaning | Main equations |
|---|---|---|---|
| Endogenous | $\hat{c}$ / `c` | 总消费 | (F1), (F5), (F36) |
| Endogenous | $\lambda$ / `lam` | 实现中的边际效用代理 | implementation_cross_check |
| Endogenous | $\hat{c}_n,\hat{c}_P,\hat{c}_U,\hat{c}_E$ / `cn, cp, cu, ce` | 非能源、汽油、公用事业和能源消费 | (F4)-(F7), (F36), (F38)-(F39) |
| Endogenous | $\hat{p}_c,\hat{p}_P,\hat{p}_U,\hat{p}_{pb}$ / `pc, pp, pu, ppb` | 消费者价格和部门相对价格 | (F6)-(F7), (F24)-(F31), (F36) |
| Endogenous | $\pi,\pi_c,\pi_{pb},\pi_u,\pi_m,\dot{W}$ / `pdot, pcdot, ppbdot, pudot, pmdot, wdot` | 通胀率和工资通胀 | (F9), (F18), (F23), (F25), (F27), (F29), (F34) |
| Endogenous | $i$ / `rg` | 名义政策利率偏离 | (F1), (F8), (F20), (F30) |
| Endogenous | $\hat{w},mrs,\hat{h}$ / `w, rcw, h` | 实际工资、边际替代率、工时 | (F9)-(F11), (F19)-(F21) |
| Endogenous | $\hat{k},\hat{z},\hat{w}_k$ / `k, z, wk` | 资本、利用率、资本租金 | (F2), (F3), (F19), (F21), (F42) |
| Endogenous | $\hat{q},\hat{B},\hat{e}$ / `q, b, e` | 非能源产出、组合投入、能源投入 | (F12)-(F17), (F42) |
| Endogenous | $\hat{V},\hat{V}_n,\hat{V}_p,\hat{V}_u$ / `va, vn, vp, vu` | 总增加值和部门增加值 | (F15), (F19), (F22), (F26), (F37) |
| Endogenous | $\hat{M}_n,\hat{p}_m$ / `mn, pm` | 进口中间品和进口价格 | (F16), (F34), (F43) |
| Endogenous | $\hat{q}_P,\hat{q}_U,\hat{I}_p,\hat{I}_u,\hat{I}_o,\hat{I}_g$ / `qp, qu, ip, iu, io, ig` | 能源部门产出和投入 | (F14), (F22), (F26), (F38)-(F41) |
| Endogenous | $\hat{s},b_f,\hat{x}_n,\hat{X}_o,\hat{X}_g$ / `s, bf, xn, xo, xg` | 汇率、外国资产、出口 | (F8), (F35), (F40)-(F43) |
| Endogenous | $\hat{p}_o,\hat{p}_g$ / `po, pg` | 本币石油和天然气价格 | (F32), (F33), (F43) |
| Exogenous shocks | `eps_a, eps_b, eps_i, eps_g, eps_mu, eps_inv, eps_w, eps_yf, eps_pmf, eps_po, eps_pg, eps_rf` | 生产率、风险溢价、货币政策、国内需求、加成、投资和国外冲击的创新 | (F44)-(F55) |
| Parameters | $\beta,\delta,\chi_z,\psi_e,\psi_p,\alpha_q,\alpha_v,\alpha_B,\psi_n,\psi_{qp},\psi_u,\psi_d$ | 贴现、折旧/利用率、份额和技术权重 | Multiple |
| Parameters | $\sigma_c,\psi_{hab},\chi_{bf},\chi_k,\varepsilon_k,\phi_z,\sigma_w,\sigma_h,\psi_w,\xi_w$ | 偏好、债券成本、资本成本、工资设定 | (F1)-(F11) |
| Parameters | $\sigma_e,\sigma_p,\sigma_V,\sigma_q,\chi_p,\chi_u,\chi_{pp},\varepsilon,\varepsilon_u,\varepsilon_{pp}$ | 替代弹性和部门价格刚性/指数化 | (F4)-(F29) |
| Parameters | $\psi_{wc},\psi_x,\eta_x,\xi_{pm},\iota_{pm},\theta_{rg},\theta_{pdot},\theta_y,\rho_j$ | 营运资本、出口/进口行为、政策、冲击持久性 | (F20), (F30), (F34)-(F55) |
| Calibration ratios | `cncratio, cucratio, vnvratio, vuvratio, cpqpratio, cuquratio, xoioratio, xgigratio, cnqratio, kqratio, cgqratio, xnqratio, mnqratio, xoqratio, xgqratio` | 市场出清方程中的稳态比率 | (F36)-(F43) |
