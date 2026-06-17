# HK_FP13 -- 推导（最优化问题 + 均衡条件）

> 状态：`needs_review`，第一轮从 MinerU Markdown 提取。未执行运行时验证。
> 来源：Funke and Paetz (2013), "Housing prices and the business cycle: An empirical application to Hong Kong", Journal of Housing Economics 22(1), 62-76, DOI: `10.1016/j.jhe.2012.11.001`。

## 1. Model Overview

- **模型**：HK_FP13，一个用于香港的双主体、双部门、小型开放经济 DSGE 模型，包含住房服务、住房投资和抵押约束。
- **主体**：不耐心借款人、耐心储蓄者、非住宅和住宅品企业、外国/世界其余部分、政府，以及货币发行局制度下的货币当局。
- **部门**：非住宅消费品 $C$ 和住宅/住房品 $D$。
- **核心摩擦**：非耐用品消费习惯、效用中的住房、借款人抵押约束、部门特定开放度、带有前瞻和后顾定价者的名义刚性，以及贷款价值比、偏好、技术、加价、外国需求、外国价格和政府冲击。
- **形式**：论文给出非线性住户问题，但估计一阶对数线性化模型。MMB 实现使用 `model(linear)`，因此本条目在来源给出线性条件时记录对数线性均衡条件，并把 OCR 较重的非线性 FOC 标为 `needs_review`。
- **实验**：基于香港 1985Q1-2010Q2 季度数据的贝叶斯估计。运行时验证延期。

## 2. Optimization Problems

### 2.1 借款人家庭

代表性不耐心借款人选择非耐用品消费、住宅存量、国内债务和两个部门的劳动：

$$
\max_{\{C_t^b,D_t^b,B_{H,t}^b,N_{C,t}^b,N_{D,t}^b\}} E_0\sum_{t=0}^{\infty}\beta_b^t
\left[
\frac{(X_t^b)^{1-\sigma}}{1-\sigma}
- \sum_{j=C,D}\frac{(N_{j,t}^b)^{1+\varphi}}{1+\varphi}
\right].
$$

福利相关消费指数和习惯调整后的非耐用品消费为：

$$
X_t^b=(\widetilde C_t^b)^{1-\gamma \mathcal E_t^{D,b}}(D_t^b)^{\gamma \mathcal E_t^{D,b}},
\qquad
\widetilde C_t^b=C_t^b-h_c C_{t-1}^b.
$$

预算约束为：

$$
C_t^b+P_{D/C,t}I_{D,t}^b-B_{H,t}^b
=-R_{t-1}\frac{B_{H,t-1}^b}{\Pi_{C,t}}
+\sum_{j=C,D}\frac{W_{j,t}^bN_{j,t}^b}{P_{C,t}},
\qquad
I_{D,t}^b=D_t^b-(1-\delta)D_{t-1}^b.
$$

借款人面对绑定的抵押约束：

$$
R_tB_{H,t}^b\le (1-\chi)(1-\delta)E_t\left[P_{D/C,t+1}D_t^b\Pi_{C,t+1}\right]\epsilon_t^{LTV}.
$$

### 2.2 储蓄者家庭

代表性耐心储蓄者具有相同的时期效用和消费聚合器，但可以交易国内和外国债券：

$$
\max_{\{C_t^s,D_t^s,B_{H,t}^s,B_{F,t}^s,N_{C,t}^s,N_{D,t}^s\}} E_0\sum_{t=0}^{\infty}\beta_s^t
\left[
\frac{(X_t^s)^{1-\sigma}}{1-\sigma}
- \sum_{j=C,D}\frac{(N_{j,t}^s)^{1+\varphi}}{1+\varphi}
\right].
$$

其预算约束为：

$$
C_t^s+P_{D/C,t}I_{D,t}^s-B_{H,t}^s-\mathfrak E_tB_{F,t}^s
=-R_{t-1}\frac{B_{H,t-1}^s}{\Pi_{C,t}}
-\frac{R_{t-1}^*\mathfrak E_tB_{F,t-1}^s}{\Pi_{C,t}}
+\sum_{j=C,D}\frac{W_{j,t}^sN_{j,t}^s}{P_{C,t}}.
$$

### 2.3 企业和价格设定

最终品零售商在每个部门聚合差异化中间品：

$$
Y_{j,t}=\left(\int_0^1Y_{j,t}(k)^{-1/(1+\mu_t^j)}dk\right)^{1+\mu_t^j},
\qquad j=C,D.
$$

中间品生产者使用线性劳动技术 $Y_{j,t}(k)=A_{j,t}N_{j,t}(k)$。部门边际成本结合家庭劳动供给、习惯调整消费、住房、贸易条件、部门生产率和住房相对价格。

价格调整遵循混合 Calvo 定价。比例为 $1-\theta_j$ 的企业重设价格；重设价格者中比例为 $\tau_j$ 的企业采用后顾规则。

### 2.4 政府和货币当局

政府购买每个部门产出的时变比例，并用一次总付税融资。货币政策由可信的固定汇率制度表示，因此汇率变动设为零，部门贸易条件吸收外国和国内通胀差异。

## 3. First-Order Conditions

**借款人家庭**

- **(F1) 借款人劳动供给，两个部门**：
$$
\frac{W_{j,t}^b}{P_{C,t}}=
\frac{(X_t^b)^\sigma (N_{j,t}^b)^\varphi(\widetilde C_t^b)^{\gamma\mathcal E_t^{D,b}}}
{(1-\gamma\mathcal E_t^{D,b})(D_t^b)^{\gamma\mathcal E_t^{D,b}}},
\qquad j=C,D.
$$

- **(F2) 借款人住房 Euler 条件**（`needs_review`：OCR 对幂和期望项较脆弱）：
$$
\begin{aligned}
P_{D/C,t}={}&
\left(\frac{\gamma\mathcal E_t^{D,b}}{1-\gamma\mathcal E_t^{D,b}}\right)
\frac{\widetilde C_t^b}{D_t^b}
+(1-\chi)(1-\delta)\psi_tP_{D/C,t}E_t[\Pi_{D,t+1}]\epsilon_t^{LTV} \\
&+\beta_b(1-\delta)E_t\left[
\left(\frac{1-\gamma\mathcal E_{t+1}^{D,b}}{1-\gamma\mathcal E_t^{D,b}}\right)
\left(\frac{X_{t+1}^b}{X_t^b}\right)^{-\sigma}
\left(\frac{D_{t+1}^b}{\widetilde C_{t+1}^b}\right)^{\gamma\mathcal E_{t+1}^{D,b}}
(\widetilde C_t^b)^{\gamma\mathcal E_t^{D,b}}P_{D/C,t+1}
\right].
\end{aligned}
$$

- **(F3) 带抵押影子价值的借款人 Euler 方程**（`needs_review`：OCR 在偏好项中交替使用 $\mathcal E$ 和 $\varepsilon$）：
$$
R_t\psi_t=
1-\beta_bE_t\left[
\left(\frac{1-\gamma\mathcal E_{t+1}^{D,b}}{1-\gamma\mathcal E_t^{D,b}}\right)
\left(\frac{X_{t+1}^b}{X_t^b}\right)^{-\sigma}
\left(\frac{D_{t+1}^b}{\widetilde C_{t+1}^b}\right)^{\gamma\mathcal E_{t+1}^{D,b}}
\left(\frac{\widetilde C_t^b}{D_t^b}\right)^{\gamma\mathcal E_t^{D,b}}
\frac{R_t}{\Pi_{C,t+1}}
\right].
$$

**储蓄者家庭**

- **(F4) 储蓄者劳动供给，两个部门**：
$$
\frac{W_{j,t}^s}{P_{C,t}}=
\frac{(X_t^s)^\sigma (N_{j,t}^s)^\varphi(\widetilde C_t^s)^{\gamma\mathcal E_t^{D,s}}}
{(1-\gamma\mathcal E_t^{D,s})(D_t^s)^{\gamma\mathcal E_t^{D,s}}},
\qquad j=C,D.
$$

- **(F5) 储蓄者住房 Euler 条件**（`needs_review`：MinerU 公式包含畸形比率）：
$$
\begin{aligned}
P_{D/C,t}={}&
\left(\frac{\gamma\mathcal E_t^{D,s}}{1-\gamma\mathcal E_t^{D,s}}\right)
\frac{\widetilde C_t^s}{D_t^s} \\
&+\beta_s(1-\delta)E_t\left[
\left(\frac{1-\gamma\mathcal E_{t+1}^{D,s}}{1-\gamma\mathcal E_t^{D,s}}\right)
\left(\frac{X_{t+1}^s}{X_t^s}\right)^{-\sigma}
\left(\frac{D_{t+1}^s}{\widetilde C_{t+1}^s}\right)^{\gamma\mathcal E_{t+1}^{D,s}}
\left(\frac{\widetilde C_t^s}{D_t^s}\right)^{\gamma\mathcal E_t^{D,s}}
P_{D/C,t+1}
\right].
\end{aligned}
$$

- **(F6) 储蓄者国内债券 Euler 方程**：
$$
1=\beta_sE_t\left[
\left(\frac{1-\gamma\mathcal E_{t+1}^{D,s}}{1-\gamma\mathcal E_t^{D,s}}\right)
\left(\frac{X_{t+1}^s}{X_t^s}\right)^{-\sigma}
\left(\frac{D_{t+1}^s}{\widetilde C_{t+1}^s}\right)^{\gamma\mathcal E_{t+1}^{D,s}}
\left(\frac{\widetilde C_t^s}{D_t^s}\right)^{\gamma\mathcal E_t^{D,s}}
\frac{R_t}{\Pi_{C,t+1}}
\right].
$$

- **(F7) 储蓄者外国债券 Euler/风险分担条件**（`needs_review`：来源 OCR 中汇率记号畸形）：
$$
1=\beta_sE_t\left[
\left(\frac{1-\gamma\mathcal E_{t+1}^{D,s}}{1-\gamma\mathcal E_t^{D,s}}\right)
\left(\frac{X_{t+1}^s}{X_t^s}\right)^{-\sigma}
\left(\frac{D_{t+1}^s}{\widetilde C_{t+1}^s}\right)^{\gamma\mathcal E_{t+1}^{D,s}}
\left(\frac{\widetilde C_t^s}{D_t^s}\right)^{\gamma\mathcal E_t^{D,s}}
\frac{\mathfrak E_{t+1}}{\mathfrak E_t}\frac{R_t^*}{\Pi_{C,t+1}}
\right].
$$

## 4. Market Clearing & Identities

- **(F8) 非耐用品 Armington 聚合器**：
$$
C_t=\left[
(1-\alpha_C)^{1/\eta_C}C_{H,t}^{(\eta_C-1)/\eta_C}
+\alpha_C^{1/\eta_C}C_{F,t}^{(\eta_C-1)/\eta_C}
\right]^{\eta_C/(\eta_C-1)}.
$$

- **(F9) 耐用品 Armington 聚合器**：
$$
D_t=\left[
(1-\alpha_D)^{1/\eta_D}D_{H,t}^{(\eta_D-1)/\eta_D}
+\alpha_D^{1/\eta_D}D_{F,t}^{(\eta_D-1)/\eta_D}
\right]^{\eta_D/(\eta_D-1)}.
$$

- **(F10) 部门价格指数**：
$$
P_{C,t}=\left[(1-\alpha_C)P_{C,H,t}^{1-\eta_C}+\alpha_CP_{C,F,t}^{1-\eta_C}\right]^{1/(1-\eta_C)},
\quad
P_{D,t}=\left[(1-\alpha_D)P_{D,H,t}^{1-\eta_D}+\alpha_DP_{D,F,t}^{1-\eta_D}\right]^{1/(1-\eta_D)}.
$$

- **(F11) 相对贸易条件恒等式**：
$$
(1-\alpha_C)\widehat s_{C,t}-(1-\alpha_D)\widehat s_{D,t}
=\widehat p_{D/C,t}-\widehat p_{D/C,t}^*.
$$

- **(F12) 耐心家庭的国际风险分担条件**：
$$
\left(\frac{X_t^s}{X_t^{s,*}}\right)^{-\sigma}
\left(\frac{(\widetilde C_t^s)^{\mathcal E_t^{D,s}}}{(\widetilde C_t^{s,*})^{\mathcal E_t^{D,*}}}\right)^\gamma
\left(\frac{(D_t^s)^{\mathcal E_t^{D,s}}}{(D_t^{s,*})^{\mathcal E_t^{D,*}}}\right)^\gamma
=\mathcal R_t.
$$

- **(F13) 零售聚合技术**：
$$
Y_{j,t}=\left(\int_0^1Y_{j,t}(k)^{-1/(1+\mu_t^j)}dk\right)^{1+\mu_t^j},
\qquad j=C,D.
$$

- **(F14) 消费品部门边际成本**：
$$
MC_{C,t}=
\frac{X_t^\sigma N_{C,t}^\varphi \widetilde C_t^{\gamma\mathcal E_t^D}S_{C,t}^{\alpha_C}}
{(1-\gamma\mathcal E_t^D)D_t^{\gamma\mathcal E_t^D}A_{C,t}}.
$$

- **(F15) 住房部门边际成本**：
$$
MC_{D,t}=
\frac{X_t^\sigma N_{D,t}^\varphi \widetilde C_t^{\gamma\mathcal E_t^D}S_{D,t}^{\alpha_D}}
{(1-\gamma\mathcal E_t^D)D_t^{\gamma\mathcal E_t^D}A_{D,t}P_{D/C,t}}.
$$

- **(F16) 混合 Calvo 加价规则**：
$$
\bar p_{j,H,t}^{n}=
\widehat\mu_t^j+(1-\beta_s\theta_j)
\sum_{k=0}^{\infty}(\beta_s\theta_j)^kE_t(mc_{j,t+k}+p_{j,H,t}).
$$

- **(F17) 消费品市场出清，对数线性化**：
$$
\widehat y_{C,t}=(1-\alpha_C)\widehat c_t+\alpha_C\widehat c_t^*
+\alpha_C\vartheta_C\widehat s_{C,t}+g_t.
$$

- **(F18) 住房品市场出清，对数线性化**：
$$
\widehat y_{D,t}=(1-\alpha_D)\widehat i_{D,t}+\alpha_D\widehat i_{D,t}^*
+\alpha_D\vartheta_D\widehat s_{D,t}+g_t.
$$

- **(F19) 总实际产出恒等式，对数线性化**：
$$
\widehat y_t=
\frac{P_{D/C}^{-\xi}C}{Y}\widehat y_{C,t}
+\frac{\delta P_{D/C}^{1-\xi}D}{Y}\widehat y_{D,t}
+\Xi\widehat p_{D/C,H,t}
-\xi\ln(P_{D/C})(\varepsilon_t^D+\varepsilon_t^{D,*}).
$$

- **(F20) 货币发行局固定汇率与贸易条件调整**：
$$
\widehat e_t=0,\qquad
\Delta\widehat s_{C,t}=\widehat\pi_{C,F,t}-\widehat\pi_{C,H,t},\qquad
\Delta\widehat s_{D,t}=\widehat\pi_{D,F,t}-\widehat\pi_{D,H,t}.
$$

## 5. Exogenous Processes

- **(F21) 部门技术冲击**：
$$
a_{j,t}=\rho_{a_j}a_{j,t-1}+\varepsilon_t^{a_j},\qquad j=C,D.
$$

- **(F22) 部门加价冲击，ARMA(1,1)**：
$$
\epsilon_t^{\mu_j}=\rho_{\mu_j}^{+}\epsilon_{t-1}^{\mu_j}
+\varepsilon_t^{\mu_j}-\rho_{\mu_j}^{-}\varepsilon_{t-1}^{\mu_j},
\qquad j=C,D.
$$

- **(F23) 贷款价值比冲击**：
$$
\epsilon_t^{LTV}=\rho_{LTV}\epsilon_{t-1}^{LTV}+\varepsilon_t^{LTV}.
$$

- **(F24) 住房偏好冲击**：
$$
\epsilon_t^{d,j}=\rho_{d,j}\epsilon_{t-1}^{d,j}+\varepsilon_t^{d,j},
\qquad j=s,b,*.
$$

- **(F25) 政府支出冲击**：
$$
g_t=\rho_g g_{t-1}+\varepsilon_t^g.
$$

- **(F26) 外国非耐用品消费需求**：
$$
\widehat c_t^*=\rho_{c^*}\widehat c_{t-1}^*+\varepsilon_t^{c^*}.
$$

- **(F27) 外国住房投资需求**：
$$
\widehat i_{D,t}^*=\rho_{d^*}\widehat d_{t-1}^*+\varepsilon_t^{d^*}.
$$

- **(F28) 外国住房价格扰动**：
$$
\widehat p_{D,t}^*=\rho_{p_D^*}\widehat p_{D,t-1}^*+\varepsilon_t^{p_D^*}.
$$

- **(F29) 外国消费价格扰动**：
$$
\widehat p_{C,t}^*=\rho_{p_C^*}\widehat p_{C,t-1}^*+\varepsilon_t^{p_C^*}.
$$

## 6. Steady-State Solution

- MMB 实现是 `model(linear)`。内生模型变量是相对于确定性稳态的偏离，因此 Dynare `initval` 块把 `pi_c_h` 和 `pi_d_h` 等通胀变量设为零，并对其余线性变量使用隐含零稳态。
- 校准常数在 `model(linear)` 块之前计算。关键来源值包括 $\beta_s=0.99$、$\beta_b=0.96$、$\delta=0.01$、通过 $\chi=0.4$ 体现的 60% LTV 校准、部门加价 $\mu_C=\mu_D=0.1$、稳态工时 $N=0.3$，以及住房部门产出份额 $\xi=0.1$。
- 实现中的相对稳态量包括 $PDC=(1+\mu_D)/(1+\mu_C)$、借款人和储蓄者消费-住房比、借款人债务-消费比、部门劳动配置，以及 `CBC`、`CSC`、`DBD`、`DSD` 等聚合权重。
- 论文的非线性方程意味着稳态由耐心者贴现因子、部门价格加价、折旧、抵押参数，以及住房/非住房支出份额共同确定。所有稳态代数的精确复现延期到运行时复制阶段，因为本 archive 任务不执行 Dynare。

## 7. Timing & Form Conventions

- **时序**：住宅存量 $D_t^q$ 是家庭类型 $q\in\{b,s\}$ 持有的存量；住房投资为 $I_{D,t}^q=D_t^q-(1-\delta)D_{t-1}^q$。
- **债务时序**：$B_{H,t}^b$ 是借款人在 $t$ 期选择并在下一期偿还的国内债务；抵押约束把 $R_tB_{H,t}^b$ 与预期未来抵押品价值联系起来。
- **价格**：$P_{D/C,t}$ 是以非住宅品计价的住宅品相对价格；CPI 通胀为 $\Pi_{C,t}$；线性实现中部门本国通胀表示为 $\pi_{C,H,t}$ 和 $\pi_{D,H,t}$。
- **开放经济**：储蓄者交易外国债券并满足国际风险分担条件；借款人不能通过国际市场为支出融资。
- **货币发行局制度**：名义汇率固定，$\widehat e_t=0$，货币条件通过贸易条件和外国变量传导，而不是 Taylor 规则。
- **模型形式**：最终实现形式是对数线性 `model(linear)`。论文中的小写帽变量对应对数偏离；利率和通胀等变量是相对趋势/稳态的偏离。
- **实现交叉检查**：`.agents/skills/dynare-copilot/references/examples/HK_FP13_rep.mod` 含 33 个内生变量和 13 个外生创新；它确认了线性形式、借款人/储蓄者拆分、部门冲击、外国模块，以及 Rep-MMB 运行中对 `epsd_s` 和 `epsd_b` 两个冲击标准差的启用。

## 8. Variable & Parameter Reference Table

### 内生变量

| 符号 / ASCII | 含义 | 主要条件 |
|---|---|---|
| $c$, $c_b$, $c_s$ | 总消费、借款人消费和储蓄者消费 | (F1)-(F7), (F17), 实现中的聚合 |
| $d$, $d_b$, $d_s$ | 总住房存量、借款人和储蓄者住房存量 | (F2), (F5), (F9), (F18) |
| $b_b$ | 借款人国内债务 | (F3), 抵押约束 |
| $\psi$ | 借款的边际价值 | (F2), (F3) |
| $n$, $n_C$, $n_D$ | 总劳动和部门劳动 | (F1), (F4), (F14), (F15) |
| $n_C^b,n_D^b,n_C^s,n_D^s$ | 类型-部门劳动供给 | (F1), (F4), 实现中的工资方程 |
| $y$, $y_C$, $y_D$ | 总产出和部门产出 | (F13), (F17)-(F19) |
| $mc_C$, $mc_D$ | 部门实际边际成本 | (F14), (F15), (F16) |
| $p_{D/C}$ | 住房相对价格 | (F2), (F5), (F10), (F11), (F19) |
| $\pi_C$, $\pi_{C,H}$, $\pi_{D,H}$ | CPI 和部门本国通胀 | (F10), (F16), (F20) |
| $r$ | 实现中的国内名义利率偏离 | (F3), (F6), (F7) |
| $s_C$, $s_D$ | 部门贸易条件 | (F11), (F17), (F18), (F20) |
| $wp_C$, $wp_D$ | 实现中的部门实际工资 | (F1), (F4), 边际成本方程 |
| $a_C$, $a_D$ | 部门技术状态 | (F21) |
| `shock_mu_c`, `shock_mu_d` | 部门加价状态 | (F22) |
| `LTV` | 贷款价值比状态 | (F23) |
| `shock_d_b`, `shock_d_s`, `shock_d_stern` | 住房偏好状态 | (F24) |
| $c^*$, $i_D^*$, $p_C^*$, $p_D^*$, $p_{D/C}^*$ | 外国需求和价格状态 | (F26)-(F29), (F11) |
| $g$ | 政府支出状态 | (F25) |

### 外生创新

| ASCII | 含义 |
|---|---|
| `epsa_c`, `epsa_d` | 部门技术创新 |
| `epsmu_c`, `epsmu_d` | 部门加价创新 |
| `epsLTV` | 贷款价值比创新 |
| `epsd_b`, `epsd_s`, `epsd_stern` | 借款人、储蓄者和外国住房偏好创新 |
| `epsc_ast`, `epsd_ast` | 外国非耐用品消费和住房投资创新 |
| `epsg` | 政府支出创新 |
| `epsp_c_ast`, `epsp_d_ast` | 外国价格创新 |

### 参数和校准常数

| ASCII / 符号 | 含义 | 来源说明 |
|---|---|---|
| $\beta_b$, $\beta_s$ | 借款人和储蓄者贴现因子 | 论文校准；实现为 `beta_b=0.96`, `beta_s=0.99` |
| $\sigma$, $\varphi$ | 消费曲率和劳动曲率 | 估计/校准 |
| $\gamma$ | 效用中的住房权重 | 估计 |
| $h_c$ | 非耐用品消费习惯 | 估计 |
| $\delta$ | 住房折旧 | 季度校准为 0.01 |
| $\chi$ | 不能抵押的住房比例 | 对应 LTV $1-\chi$ |
| $\alpha_C$, $\alpha_D$ | 部门开放度参数 | 估计/校准 |
| $\eta_C,\eta_D,\zeta_C,\zeta_D$ | Armington 和世界其余部分替代弹性 | 论文/实现中校准为 2 |
| $\mu_C,\mu_D$ | 稳态加价 | 校准为 0.1 |
| $\theta_C,\theta_D,\tau_C,\tau_D$ | 混合 Calvo 参数 | 估计 |
| $\rho$ parameters | 冲击持续性/ARMA 系数 | 估计 |
| `CBDB`, `CSDS`, `BHCB`, `CBC`, `CSC`, `DBD`, `DSD` | 稳态比率和聚合权重 | 实现交叉检查常数 |

**方程数**：29 个编号条件，(F1)-(F29)。英文版本必须保持相同计数。
