# NK_GK09lin - 推导

> MMB `model(linear)` 版本 Gertler and Karadi, "A Model of Unconvetional Monetary Policy" 的私有档案首轮推导。未执行运行时验证。标为 `needs_review` 的内容需要源级核对后才能提升到草稿以外状态。

来源信息：`model_id=NK_GK09lin`；作者 Mark Gertler and Peter Karadi；MMB 元数据年份 2009，发表于 Journal of Monetary Economics 58(1), pp. 17-34；DOI `10.1016/j.jmoneco.2010.10.004`；主 Markdown `raw/mmb_mineru/runs/nk_gk09lin_nk_gk11__a_model_of_unconvetional_monetary_policy__e6192938/full.md`；原始 PDF `raw/mmb_papers/A Model of Unconvetional Monetary Policy.pdf`；MinerU run ids `e6192938-5688-49c7-9621-66ca2478274f`, `7766fa43-5b60-4812-9445-88d48b0fe6cf`。

## 1. Model Overview

- **模型**：带金融中介、内生中介资产负债表约束、资本质量冲击和央行信用中介的新凯恩斯 DSGE 模型。
- **MMB 条目**：`NK_GK09lin`，是 Gertler-Karadi 框架的线性化 MMB 实现（`model(linear)`）。
- **主体**：含工人与银行家的代表性家庭、金融中介、竞争性中间品厂商、资本品生产商、垄断竞争零售商、财政当局和中央银行。
- **核心机制**：中介杠杆受激励约束限制；削弱中介净值的冲击会收紧信贷供给、提高资本超额回报、压低资产价格和投资，并放大真实经济衰退。
- **形式**：论文写出非线性均衡条件，并在政策分析中近似；MMB 实现是围绕确定性稳态的对数线性或线性偏离系统。下文保留论文侧非线性条件，并在第 8 节记录实现中的线性变量。

## 2. Optimization Problems

### 2.1 家庭

家庭选择消费、劳动和一期无风险债券，并内生化习惯形成：

\[
\max_{\{C_{t+i},L_{t+i},B_{t+1+i}\}} E_t\sum_{i=0}^{\infty}\beta^i
\left[\log(C_{t+i}-hC_{t+i-1})-\frac{\chi}{1+\varphi}L_{t+i}^{1+\varphi}\right].
\]

当期预算约束为：

\[
C_t = W_t L_t + \Pi_t + T_t + R_t B_t - B_{t+1}.
\]

### 2.2 金融中介

中介 \(j\) 持有价值为 \(Q_tS_{jt}\) 的债权，由净值 \(N_{jt}\) 和存款 \(B_{jt+1}\) 融资：

\[
Q_tS_{jt}=N_{jt}+B_{jt+1}.
\]

银行家最大化预期终值财富：

\[
V_{jt}=\max E_t\sum_{i=0}^{\infty}(1-\theta)\theta^i\beta^{i+1}\Lambda_{t,t+1+i}N_{jt+1+i}.
\]

只有当银行家不愿转移资产中 \(\lambda\) 比例时，存款人才愿意提供融资：

\[
V_{jt}\geq \lambda Q_tS_{jt}.
\]

### 2.3 中间品厂商

厂商租用有效资本和劳动生产中间品：

\[
Y_t=A_t(U_t\xi_tK_t)^\alpha L_t^{1-\alpha}.
\]

它静态选择劳动和利用率，并将事后资本回报支付给债权持有人。

### 2.4 资本品生产商

资本品生产商在流量调整成本下选择净投资：

\[
\max E_t\sum_{\tau=t}^{\infty}\beta^{\tau-t}\Lambda_{t,\tau}
\left[(Q_\tau-1)I_{n\tau}
- f\!\left(\frac{I_{n\tau}+I_{ss}}{I_{n,\tau-1}+I_{ss}}\right)(I_{n\tau}+I_{ss})\right].
\]

### 2.5 零售商

零售商重新包装中间品，并面临带指数化的 Calvo 定价：

\[
\max_{P_t^{\ast}} E_t\sum_{i=0}^{\infty}\gamma^i\beta^i\Lambda_{t,t+i}
\left[
\frac{P_t^{\ast}}{P_{t+i}}\prod_{k=1}^i(1+\pi_{t+k-1})^{\gamma_p}
- P_{m,t+i}
\right]Y_{f,t+i}.
\]

## 3. First-Order Conditions

- **(F1) 带外部习惯的家庭边际效用**：

\[
\varrho_t=(C_t-hC_{t-1})^{-1}-\beta h E_t(C_{t+1}-hC_t)^{-1}.
\]

- **(F2) 劳动供给**：

\[
\varrho_t W_t=\chi L_t^\varphi.
\]

- **(F3) 无风险债券欧拉方程**：

\[
E_t\beta\Lambda_{t,t+1}R_{t+1}=1,\qquad
\Lambda_{t,t+1}=\frac{\varrho_{t+1}}{\varrho_t}.
\]

- **(F4) 中介净值积累**：

\[
N_{j,t+1}=(R_{k,t+1}-R_{t+1})Q_tS_{jt}+R_{t+1}N_{jt}.
\]

- **(F5) 中介价值分解**：

\[
V_{jt}=\nu_t Q_tS_{jt}+\eta_tN_{jt}.
\]

- **(F6) 扩张资产的边际价值**：

\[
\nu_t=E_t\left\{(1-\theta)\beta\Lambda_{t,t+1}(R_{k,t+1}-R_{t+1})
\,+\beta\theta\Lambda_{t,t+1}x_{t,t+1}\nu_{t+1}\right\}.
\]

- **(F7) 净值的边际价值**：

\[
\eta_t=E_t\left\{(1-\theta)+\beta\theta\Lambda_{t,t+1}z_{t,t+1}\eta_{t+1}\right\}.
\]

- **(F8) 绑定的激励约束与私人杠杆**：

\[
Q_tS_{jt}=\frac{\eta_t}{\lambda-\nu_t}N_{jt}\equiv \phi_tN_{jt}.
\]

- **(F9) 个体净值增长**：

\[
z_{t,t+1}=\frac{N_{j,t+1}}{N_{jt}}=(R_{k,t+1}-R_{t+1})\phi_t+R_{t+1}.
\]

- **(F10) 资产增长**：

\[
x_{t,t+1}=\frac{Q_{t+1}S_{j,t+1}}{Q_tS_{jt}}=\frac{\phi_{t+1}}{\phi_t}z_{t,t+1}.
\]

- **(F11) 总资产受总净值约束**：

\[
Q_tS_t=\phi_tN_t.
\]

- **(F12) 存续银行家净值**：

\[
N_{e,t}=\theta\left[(R_{k,t}-R_t)\phi_{t-1}+R_t\right]N_{t-1}.
\]

- **(F13) 新进入银行家净值**：

\[
N_{n,t}=\omega Q_tS_{t-1}.
\]

- **(F14) 中介总净值**：

\[
N_t=N_{e,t}+N_{n,t}.
\]

- **(F15) 央行信贷份额与总中介规模**：

\[
Q_tS_t=Q_tS_{p,t}+Q_tS_{g,t},\qquad
Q_tS_{g,t}=\psi_t Q_tS_t,\qquad
Q_tS_t=\phi_{c,t}N_t.
\]

- **(F16) 信贷政策下的总杠杆**：

\[
\phi_{c,t}=\frac{\phi_t}{1-\psi_t}.
\]

- **(F17) 厂商资本债权融资**：

\[
Q_tK_{t+1}=Q_tS_t.
\]

- **(F18) 中间品生产**：

\[
Y_t=A_t(U_t\xi_tK_t)^\alpha L_t^{1-\alpha}.
\]

- **(F19) 利用率条件**：

\[
P_{m,t}\alpha\frac{Y_t}{U_t}=\delta'(U_t)\xi_tK_t.
\]

- **(F20) 劳动需求**：

\[
P_{m,t}(1-\alpha)\frac{Y_t}{L_t}=W_t.
\]

- **(F21) 资本回报**：

\[
R_{k,t+1}=
\frac{\left[P_{m,t+1}\alpha\frac{Y_{t+1}}{\xi_{t+1}K_{t+1}}+Q_{t+1}-\delta(U_{t+1})\right]\xi_{t+1}}{Q_t}.
\]

- **(F22) 净投资定义**：

\[
I_{n,t}=I_t-\delta(U_t)\xi_tK_t.
\]

- **(F23) 资本品生产商 Tobin's Q 条件**：

\[
Q_t=1+f(\cdot)+
\frac{I_{n,t}+I_{ss}}{I_{n,t-1}+I_{ss}}f'(\cdot)
-E_t\beta\Lambda_{t,t+1}
\left(\frac{I_{n,t+1}+I_{ss}}{I_{n,t}+I_{ss}}\right)^2f'(\cdot).
\]

- **(F24) 差异化产出的零售需求**：

\[
Y_{f,t}=\left(\frac{P_{f,t}}{P_t}\right)^{-\varepsilon}Y_t.
\]

- **(F25) 重置价格一阶条件**：

\[
E_t\sum_{i=0}^{\infty}\gamma^i\beta^i\Lambda_{t,t+i}
\left[
\frac{P_t^{\ast}}{P_{t+i}}\prod_{k=1}^{i}(1+\pi_{t+k-1})^{\gamma_p}
-\mu P_{m,t+i}
\right]Y_{f,t+i}=0.
\]

- **(F26) 价格指数运动方程**：

\[
P_t=\left[(1-\gamma)(P_t^{\ast})^{1-\varepsilon}
+\gamma\left(\Pi_{t-1}^{\gamma_p}P_{t-1}\right)^{1-\varepsilon}\right]^{1/(1-\varepsilon)}.
\]

## 4. Market Clearing & Identities

- **(F27) 含信贷政策成本的资源约束**：

\[
Y_t=C_t+I_t+
f\!\left(\frac{I_{n,t}+I_{ss}}{I_{n,t-1}+I_{ss}}\right)(I_{n,t}+I_{ss})
+G+\tau\psi_tQ_tK_{t+1}.
\]

- **(F28) 资本积累**：

\[
K_{t+1}=\xi_tK_t+I_{n,t}.
\]

- **(F29) 含央行中介收入的政府预算约束**：

\[
G+\tau\psi_tQ_tK_{t+1}=T_t+(R_{k,t}-R_t)B_{g,t-1}.
\]

- **(F30) 费雪关系**：

\[
1+i_t=R_{t+1}\frac{E_tP_{t+1}}{P_t}.
\]

## 5. Exogenous Processes

- **(F31) 利率规则**：

\[
i_t=(1-\rho)\left[i+\kappa_\pi\pi_t+\kappa_y(\log Y_t-\log Y_t^{\ast})\right]
+\rho i_{t-1}+\varepsilon_t.
\]

- **(F32) 信贷政策反馈规则**：

\[
\psi_t=\psi+\nu_\psi E_t\left[(\log R_{k,t+1}-\log R_{t+1})-(\log R_k-\log R)\right].
\]

- **(F33) 技术过程，按线性 MMB 文件实现**：

\[
a_t=\rho_a a_{t-1}+\varepsilon^a_t.
\]

- **(F34) 资本质量过程，按线性 MMB 文件实现**：

\[
\xi_t=\rho_\xi\xi_{t-1}+\varepsilon^\xi_t.
\]

- **(F35) 中介净值转移冲击，按线性 MMB 文件实现**：

\[
\varepsilon^n_t \text{ shifts aggregate intermediary net worth in the linearized net-worth equation.}
\]

## 6. Steady-State Solution

本档案首轮记录稳态结构，但不复现完整可运行的 `steady_state_model`。在 MMB 实现中，变量是相对确定性稳态的线性偏离，因此 `model(linear)` 块内所有模型变量在归一化后稳态为零。

关键稳态限制：

1. \(\Lambda=1\) 时，由 (F3) 得 \(R=1/\beta\)。
2. 由垄断竞争得 \(P_m=(\varepsilon-1)/\varepsilon\)。
3. \(R_k=R+\text{EFP}\)，论文校准中的稳态外部融资溢价目标为年化一百个基点。
4. \(\phi=QK/N\) 使杠杆率约等于论文校准中的四。
5. 稳态中 \(G/Y=0.2\)，\(U=1\)，\(\delta(U)=0.025\)，且 \(Q=1\)。
6. 参数 \(\omega\) 固定银行家进入净值，使总净值平稳。

来自 `NK_GK09lin_rep.mod` 的实现交叉核对：该文件在声明 `model(linear)` 前计算 `Rss`, `EFPss`, `PHIss`, `PMss`, `RKss`, `DELTAss`, `YKss`, `KLss`, `Kss`, `Yss`, `Nss`, `NEss`, `NNss`, `Css`, `Fss`, `F1ss`, `Dss` 等稳态对象。这些数值作为实现证据，而不是论文侧源方程。

## 7. Timing & Form Conventions

- **资本时序**：论文使用 \(K_t\) 进入生产，并将期末 \(t\) 的融资决策写为购入 \(K_{t+1}\)。MMB 实现在生产方程中使用滞后资本，与线性化 Dynare 系统中的预定资本一致。
- **中介净值**：\(N_t\) 是经过存续、回报和进入转移后的期末中介资本，对下一期放贷能力而言是预定状态。
- **回报**：\(R_{k,t+1}\) 是 \(t\) 期购入资本在下一期的随机收益；\(R_{t+1}\) 是从 \(t\) 到 \(t+1\) 支付的无风险实际回报。
- **通胀和名义利率**：MMB 文件使用对数线性通胀 `pi`、名义利率 `rn` 和实际利率 `r`，并使用线性费雪关系。
- **形式**：`NK_GK09lin` 是 `model(linear)`。上面的方程是论文侧非线性祖先；`.mod` 确认线性变量和冲击。
- **状态**：由于原始论文源给出非线性条件，而 MMB 代码给出紧凑线性实现，逐方程线性化对应关系标为 `needs_review`。

## 8. Variable & Parameter Reference Table

| Category | Symbol or ASCII name | 含义 | Source equation |
|---|---|---|---|
| Endogenous | \(C_t\), `c` | 家庭消费 | (F1), (F27) |
| Endogenous | \(L_t\), `l` | 劳动供给 | (F2), (F20) |
| Endogenous | \(W_t\) | 实际工资 | (F2), (F20) |
| Endogenous | \(\varrho_t\), `uc` | 消费边际效用 | (F1) |
| Endogenous | \(\Lambda_{t,t+1}\), `lambda` | 随机贴现因子 | (F3) |
| Endogenous | \(R_t\), `r` | 无风险实际回报 | (F3), (F30) |
| Endogenous | \(R_{k,t}\), `rk` | 资本回报 | (F21) |
| Endogenous | \(Q_t\), `q` | 资本相对价格 | (F8), (F17), (F23) |
| Endogenous | \(S_t\) | 对非金融企业的债权 | (F11), (F17) |
| Endogenous | \(N_t\), `n` | 中介总净值 | (F12)-(F14) |
| Endogenous | \(N_{e,t}\), `ne` | 存续银行家净值 | (F12) |
| Endogenous | \(N_{n,t}\), `nn` | 新进入银行家净值 | (F13) |
| Endogenous | \(\nu_t\), `nu` | 中介资产边际价值 | (F6) |
| Endogenous | \(\eta_t\), `eta` | 中介净值边际价值 | (F7) |
| Endogenous | \(\phi_t\), `phi` | 私人杠杆率 | (F8) |
| Endogenous | \(\phi_{c,t}\), `phic` | 含信贷政策的总杠杆 | (F16) |
| Endogenous | \(\psi_t\), `psi` | 央行信贷份额 | (F32) |
| Endogenous | \(K_t\), `k` | 资本存量 | (F17), (F28) |
| Endogenous | \(U_t\), `u` | 利用率 | (F19) |
| Endogenous | \(Y_t\), `y`, `ym` | 产出、中间品产出 | (F18), (F27) |
| Endogenous | \(I_t\), `i` | 总投资 | (F22), (F27) |
| Endogenous | \(I_{n,t}\), `in` | 净投资 | (F22), (F28) |
| Endogenous | \(P_{m,t}\), `pm`, `pmn`, `mc` | 相对价格 / 边际成本 | (F19), (F20), (F25) |
| Endogenous | \(\pi_t\), `pi` | 通胀 | (F26), (F30), (F31) |
| Endogenous | \(i_t\), `rn` | 净名义政策利率 | (F31) |
| Endogenous | \(P_t^{\ast}\), `pistar` | 最优重置价格 / 重置通胀 | (F25), (F26) |
| Endogenous | `f`, `f1`, `d` | 实现中的 Calvo 辅助变量和价格分散 | (F25), (F26) |
| Exogenous | `e_rn` | 货币政策冲击 | (F31) |
| Exogenous | `e_a` | 技术创新 | (F33) |
| Exogenous | `e_epsilon` | 资本质量创新 | (F34) |
| Exogenous | `e_n` | 净值转移冲击 | (F35) |
| Parameter | \(\beta\), `beta` | 贴现因子 | (F1)-(F3) |
| Parameter | \(h\) | 习惯参数 | (F1) |
| Parameter | \(\chi,\varphi\) | 劳动负效用权重和 Frisch 弹性倒数 | (F2) |
| Parameter | \(\theta\) | 金融块中的银行家存续概率 | (F6)-(F14) |
| Parameter | \(\lambda\) | 可转移资产比例 | (F8) |
| Parameter | \(\omega\) | 给新进入银行家的转移 | (F13) |
| Parameter | \(\alpha\) | 有效资本份额 | (F18)-(F21) |
| Parameter | \(\delta(\cdot)\), `deltac`, `zeta` | 折旧和利用率曲率 | (F19), (F22), (F28) |
| Parameter | \(\varepsilon\), `veps` | 替代弹性 | (F24)-(F26) |
| Parameter | \(\gamma,\gamma_p\) | Calvo 刚性和指数化 | (F25), (F26) |
| Parameter | \(\kappa_\pi,\kappa_y,\rho\) | Taylor 规则系数 | (F31) |
| Parameter | \(\tau,\nu_\psi\) | 信贷政策成本和反馈系数 | (F27), (F32) |
