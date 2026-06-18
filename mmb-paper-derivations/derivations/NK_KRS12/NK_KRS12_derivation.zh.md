# NK_KRS12 -- 推导（最优化问题 + 一阶条件）

> 私有模型归档草稿，用于后续面向 Dynare 的审阅。未执行运行时验证。

来源信息：`NK_KRS12`，Kannan, Prakash; Rabanal, Pau; Scott, Alasdair M. (2012)，"Monetary and macroprudential policy rules in a model with house price booms"，DOI `10.1515/1935-1690.2268`。主 Markdown 来源：`raw/mmb_mineru/runs/nk_krs12__monetary_and_macroprudential_policy_rules_in_a_model_with_house_price_bo__fb846d59/full.md`。原始 PDF：`raw/mmb_papers/Monetary and macroprudential policy rules in a model with house price booms.pdf`。MinerU run id：`fb846d59-b45c-4f6d-96d6-d7fb0f6fd4dc`。

## 1. Model Overview

- **模型**：两部门新凯恩斯住房模型，包含储蓄者、借款者、金融中介、耐用品与非耐用品生产者、货币政策和宏观审慎利差工具。
- **核心机制**：借款者通过中介为住房融资。贷款利差取决于借款者杠杆、金融冲击，以及在部分政策制度下与名义信贷增长挂钩的宏观审慎工具。
- **部门**：非耐用品部门使用劳动并受到 TFP 冲击；耐用品/住房部门使用劳动。两个部门价格均存在 Calvo 黏性和滞后指数化。
- **政策制度**：Taylor rule、含信贷增长的 augmented Taylor rule，以及 augmented Taylor rule plus macroprudential policy。
- **模型形式**：`model(linear)`。附录和 MMB 实现中的小写变量表示相对稳态的对数线性偏离；增长率变量是一阶差分，如 `deltac` 和 `deltapC`。
- **状态**：`needs_review`。论文附录给出紧凑的对数线性系统，但 OCR 损坏了若干符号和方程编号。

## 2. Optimization Problems

### 2.1 储蓄者

每个储蓄者 $j \in [0,\lambda]$ 在非耐用品消费、住房服务和劳动之间最大化期望贴现效用：

$$
E_0 \sum_{t=0}^{\infty} \beta^t
\left[
\gamma \log(C_t^j-\varepsilon C_{t-1})
+(1-\gamma)\xi_t^D \log(D_t^j)
-\frac{(L_t^j)^{1+\varphi}}{1+\varphi}
\right].
$$

劳动是非耐用品和耐用品部门劳动的 CES 型总量：

$$
L_t^j =
\left[
\alpha^{-\iota_L}(L_t^{C,j})^{1+\iota_L}
+(1-\alpha)^{-\iota_L}(L_t^{D,j})^{1+\iota_L}
\right]^{1/(1+\iota_L)}.
$$

名义预算约束为

$$
P_t^C C_t^j + P_t^D I_t^j + B_t^j
\leq
R_{t-1}B_{t-1}^j + W_t^C L_t^{C,j} + W_t^D L_t^{D,j} + \Pi_t^j.
$$

住房存量演化为

$$
D_t^j = (1-\delta)D_{t-1}^j
+ \left[1-S\left(\frac{I_t^j}{I_{t-1}^j}\right)\right] I_t^j.
$$

### 2.2 借款者

每个借款者 $j \in [\lambda,1]$ 求解类似问题，但贴现因子为 $\beta^B < \beta$：

$$
E_0 \sum_{t=0}^{\infty} (\beta^B)^t
\left[
\gamma \log(C_t^{B,j}-\varepsilon C_{t-1}^B)
+(1-\gamma)\xi_t^D \log(D_t^{B,j})
-\frac{(L_t^{B,j})^{1+\varphi}}{1+\varphi}
\right].
$$

借款者预算约束为

$$
P_t^C C_t^{B,j}+P_t^D I_t^{B,j}+R_{t-1}^L B_{t-1}^{B,j}
\leq
B_t^{B,j}+W_t^C L_t^{C,B,j}+W_t^D L_t^{D,B,j}.
$$

借款者住房和劳动总量函数与储蓄者相同。借款者 Euler 条件使用贷款利率 $R_t^L$，而非储蓄者存款利率 $R_t$。

### 2.3 金融中介

金融中介吸收储蓄者存款并向借款者贷款。贷款利差是设定式，而不是由中介最优化推导：

$$
\frac{R_t^L}{R_t}
= v_t F\left(\frac{B_t^B}{P_t^D D_t^B}\right)\tau_t.
$$

其中 $v_t$ 是金融冲击，$F(\cdot)$ 随贷款价值比上升而上升，$\tau_t$ 是宏观审慎工具。

### 2.4 生产者

最终品生产者在每个部门用 CES 技术聚合差异化中间品。对耐用品部门：

$$
Y_t^D =
\left[
\int_0^1 Y_t^D(i)^{(\sigma_D-1)/\sigma_D}\,di
\right]^{\sigma_D/(\sigma_D-1)}.
$$

中间品生产者在 Calvo 约束下定价。生产只使用劳动：

$$
Y_t^C(i)=A_t^C L_t^C(i), \qquad
Y_t^D(i)=L_t^D(i).
$$

耐用品部门定价问题选择 $\hat P_t^D$，在 Calvo 不调价概率 $\theta_D$ 和指数化 $\varphi_D$ 下最大化贴现预期利润；非耐用品部门有相同结构并替换为部门 $C$ 记号。

## 3. First-Order Conditions

以下均衡条件采用论文附录的对数线性形式，并为本归档条目连续重编号为 `(F1)` 到 `(F29)`。小写变量为对数偏离。`needs_review` 标记表示 Markdown 来源中的 OCR 符号或方程标签受损。

- **(F1) 储蓄者住宅投资 FOC**：

$$
q_t - \frac{c_t-\varepsilon c_{t-1}}{1-\varepsilon}
+ \eta(i_t-i_{t-1})
= \mu_t + \beta\eta(E_t i_{t+1}-i_t).
$$

- **(F2) 储蓄者住房存量影子价值**：

$$
\left[1-\beta(1-\delta)\right](\xi_t^D-d_t)
= \mu_t-\beta(1-\delta)E_t\mu_{t+1}.
$$

- **(F3) 储蓄者非耐用品消费 Euler 方程**：

$$
\varepsilon \Delta c_t
= E_t\Delta c_{t+1}
-(1-\varepsilon)(r_t-E_t\Delta p_{t+1}^C).
$$

- **(F4) 储蓄者非耐用品部门劳动供给**：

$$
\frac{c_t-\varepsilon c_{t-1}}{1-\varepsilon}
+[(\varphi-\iota_L)\alpha+\iota_L]l_t^C
+(\varphi-\iota_L)(1-\alpha)l_t^D
= \omega_t^C.
$$

- **(F5) 储蓄者耐用品部门劳动供给**：

$$
\frac{c_t-\varepsilon c_{t-1}}{1-\varepsilon}
+[(\varphi-\iota_L)(1-\alpha)+\iota_L]l_t^D
+(\varphi-\iota_L)\alpha l_t^C
= \omega_t^D.
$$

- **(F6) 借款者住宅投资 FOC**：

$$
q_t - \frac{c_t^B-\varepsilon c_{t-1}^B}{1-\varepsilon}
+ \eta(i_t^B-i_{t-1}^B)
= \mu_t^B + \beta^B\eta(E_t i_{t+1}^B-i_t^B).
$$

- **(F7) 借款者住房存量影子价值**：

$$
\left[1-\beta^B(1-\delta)\right](\xi_t^D-d_t^B)
= \mu_t^B-\beta^B(1-\delta)E_t\mu_{t+1}^B.
$$

- **(F8) 含贷款利率的借款者 Euler 方程**：

$$
\varepsilon \Delta c_t^B
= E_t\Delta c_{t+1}^B
-(1-\varepsilon)(r_t^L-E_t\Delta p_{t+1}^C).
$$

- **(F9) 借款者非耐用品部门劳动供给**：

$$
\frac{c_t^B-\varepsilon c_{t-1}^B}{1-\varepsilon}
+[(\varphi-\iota_L)\alpha+\iota_L]l_t^{B,C}
+(\varphi-\iota_L)(1-\alpha)l_t^{B,D}
= \omega_t^C.
$$

- **(F10) 借款者耐用品部门劳动供给**：

$$
\frac{c_t^B-\varepsilon c_{t-1}^B}{1-\varepsilon}
+[(\varphi-\iota_L)(1-\alpha)+\iota_L]l_t^{B,D}
+(\varphi-\iota_L)\alpha l_t^{B,C}
= \omega_t^D.
$$

- **(F11) 借款者预算约束**：

$$
C^B c_t^B + I^B(q_t+i_t^B)
+R^L B^B(r_{t-1}^L+b_{t-1}^B-\Delta p_t^C)
=
B^B b_t^B
+\alpha W L^B(\omega_t^C+l_t^{C,B})
+(1-\alpha)W L^B(\omega_t^D+l_t^{D,B}).
$$

- **(F12) 有效贷款利率 / 含宏观审慎规则的利差**：

$$
r_t^L
= r_t+\kappa(b_t^B-d_t^B-q_t)-v_t
+\tau(b_{t-1}^B-b_{t-2}^B+\Delta p_{t-1}^C).
$$

- **(F13) 住房相对价格**：

$$
q_t=q_{t-1}+\Delta p_t^D-\Delta p_t^C.
$$

- **(F14) 非耐用品生产**：

$$
y_t^C=a_t^C+l_t^{C,tot}.
$$

- **(F15) 耐用品生产**：

$$
y_t^D=l_t^{D,tot}.
$$

- **(F16) 非耐用品部门新凯恩斯 Phillips 曲线**：

$$
\Delta p_t^C-\varphi_C\Delta p_{t-1}^C
=\beta E_t(\Delta p_{t+1}^C-\varphi_C\Delta p_t^C)
+\kappa^C(\omega_t^C-a_t^C).
$$

- **(F17) 耐用品部门新凯恩斯 Phillips 曲线**（`needs_review`：论文 OCR 显示额外的 `a_t^D`；实现文件没有耐用品 TFP 冲击，使用 $\omega_t^D-q_t$）：

$$
\Delta p_t^D-\varphi_D\Delta p_{t-1}^D
=\beta E_t(\Delta p_{t+1}^D-\varphi_D\Delta p_t^D)
+\kappa^D(\omega_t^D-q_t).
$$

## 4. Market Clearing & Identities

- **(F18) 非耐用品市场出清**：

$$
y_t^C=
\frac{\lambda C c_t+(1-\lambda)C^B c_t^B}
{\lambda C+(1-\lambda)C^B}.
$$

- **(F19) 耐用品市场出清**：

$$
y_t^D=
\frac{\lambda\delta D i_t+(1-\lambda)\delta D^B i_t^B}
{\lambda\delta D+(1-\lambda)\delta D^B}.
$$

- **(F20) 储蓄者住房存量运动方程**：

$$
d_t=(1-\delta)d_{t-1}+\delta i_t.
$$

- **(F21) 借款者住房存量运动方程**：

$$
d_t^B=(1-\delta)d_{t-1}^B+\delta i_t^B.
$$

- **(F22) 非耐用品部门总劳动**：

$$
l_t^{C,tot}=
\frac{\lambda L l_t^C+(1-\lambda)L^B l_t^{C,B}}
{\lambda L+(1-\lambda)L^B}.
$$

- **(F23) 耐用品部门总劳动**：

$$
l_t^{D,tot}=
\frac{\lambda L l_t^D+(1-\lambda)L^B l_t^{D,B}}
{\lambda L+(1-\lambda)L^B}.
$$

- **(F24) 信贷市场出清**：

$$
\lambda b_t+(1-\lambda)b_t^B=0.
$$

- **(F25) 借款者名义信贷增长恒等式**：

$$
\Delta b_t^B=b_t^B-b_{t-1}^B+\Delta p_t^C.
$$

- **(F26) 总实际 GDP**：

$$
y_t=\alpha y_t^C+(1-\alpha)y_t^D.
$$

- **(F27) 含信贷增长扩展的 Taylor rule**：

$$
r_t=\gamma_r r_{t-1}
+(1-\gamma_r)\left[
\gamma_\pi \Delta p_{t-1}^C
+\gamma_y(y_{t-1}-y_{t-1}^{\ast})
+\gamma_b(b_{t-1}^B-b_{t-2}^B+\Delta p_{t-1}^C)
\right].
$$

`needs_review`：附录方程 (53) 中 $(1-\gamma_r)$ 的作用范围在 OCR 中不清楚；实现文件把它作用于所有非滞后政策反应项。

## 5. Exogenous Processes

- **(F28) 非耐用品部门 TFP 冲击**：

$$
a_t^C=\rho_a a_{t-1}^C+\varepsilon_t^a.
$$

- **(F29) 住房需求与金融冲击**：

$$
\xi_t^D=\rho_d\xi_{t-1}^D+\varepsilon_t^d,
\qquad
v_t=\rho_v v_{t-1}+\varepsilon_t^v.
$$

## 6. Steady-State Solution

因为 `NK_KRS12` 以 `model(linear)` 表示，均衡系统中的动态变量是围绕校准确定性稳态的对数偏离或增长率偏离。因此，线性模型使用的内生偏离和冲击创新稳态均为零：

$$
\bar q=\bar c=\bar i=\bar \mu=\bar d=\bar r=\bar b=\bar p^C=\bar p^D
=\bar y=\bar y^{\ast}=\bar a^C=\bar \xi^D=\bar v=0.
$$

线性方程中的水平稳态常数由校准给定，而不是在本归档条目中求解。实现交叉检查给出：

$$
\beta=0.99,\quad \beta^B=0.98,\quad \delta=0.025,\quad
\lambda=0.5,\quad \alpha=0.9,\quad \gamma=0.5378.
$$

部分水平常数为

$$
C=1.5893,\quad C^B=1.3705,\quad D=7.8610,\quad D^B=5.2936,\quad
I^B=0.1323,\quad B^B=4.2349,\quad R^L=1.0204,\quad W=0.9.
$$

未执行运行时验证、残差检查或 Dynare。

## 7. Timing & Form Conventions

- 模型围绕稳态线性化；小写变量表示对数线性偏离，`Delta` 变量表示一阶差分。
- 住房存量 $d_t$ 和 $d_t^B$ 是运动方程 (F20)-(F21) 中的预定存量变量，生产/投资选择影响当期存量。
- 借款者债务 $b_t^B$ 是当期选择的存量；借款者预算成本包含滞后债务和滞后贷款利率。
- 政策规则对滞后 CPI 通胀、滞后产出缺口和滞后名义信贷增长作出反应。
- 用于实现交叉检查的 `.mod` 文件是 augmented Taylor plus macroprudential regime。论文中的其他政策制度令 $\gamma_b=0$ 和/或 $\tau=0$，或优化这些系数。
- 潜在产出 $y_t^{\ast}$ 在论文中定义为价格灵活、无金融约束且主体同质时的 GDP 动态。MMB 实现提供 `yCstar`、`yDstar` 和 `dstar` 的辅助规律；这些属于实现细节和交叉检查证据，而不是论文侧推导方程。

## 8. Variable & Parameter Reference Table

### 内生变量

| ASCII name | Mathematical symbol | 含义 | 主要方程 |
|---|---|---|---|
| `q` | $q_t$ | 住房相对价格，$P_t^D/P_t^C$ | (F13) |
| `c` | $c_t$ | 储蓄者非耐用品消费 | (F3) |
| `i` | $i_t$ | 储蓄者住宅投资 | (F1) |
| `mu` | $\mu_t$ | 储蓄者住房影子价值 | (F2) |
| `d` | $d_t$ | 储蓄者住房存量 | (F20) |
| `r` | $r_t$ | 存款/政策利率偏离 | (F27) |
| `deltac` | $\Delta c_t$ | 储蓄者消费增长 | (F3) |
| `deltap` | $\Delta p_t$ | 总通胀 | identity/cross-check |
| `deltapC` | $\Delta p_t^C$ | CPI/非耐用品通胀 | (F16) |
| `b` | $b_t$ | 储蓄者存款 | (F24) |
| `p`, `pC`, `pD` | $p_t,p_t^C,p_t^D$ | 价格水平偏离 | (F13), identities |
| `deltapD` | $\Delta p_t^D$ | 耐用品/房价通胀 | (F17) |
| `lC`, `lD` | $l_t^C,l_t^D$ | 储蓄者分部门劳动 | (F4), (F5) |
| `wC`, `wD` | $\omega_t^C,\omega_t^D$ | 实际工资偏离 | (F4), (F5), (F16), (F17) |
| `cB` | $c_t^B$ | 借款者消费 | (F8) |
| `deltacB` | $\Delta c_t^B$ | 借款者消费增长 | (F8) |
| `iB` | $i_t^B$ | 借款者住宅投资 | (F6) |
| `muB` | $\mu_t^B$ | 借款者住房影子价值 | (F7) |
| `dB` | $d_t^B$ | 借款者住房存量 | (F21) |
| `lCB`, `lDB` | $l_t^{C,B},l_t^{D,B}$ | 借款者分部门劳动 | (F9), (F10) |
| `rL` | $r_t^L$ | 借款者贷款利率 | (F12) |
| `bB` | $b_t^B$ | 借款者债务 | (F11), (F24), (F25) |
| `aC` | $a_t^C$ | 非耐用品 TFP | (F28) |
| `xiD` | $\xi_t^D$ | 住房偏好冲击状态 | (F29) |
| `v` | $v_t$ | 金融冲击状态 | (F29) |
| `lCtot`, `lDtot` | $l_t^{C,tot},l_t^{D,tot}$ | 分部门总劳动 | (F22), (F23) |
| `y` | $y_t$ | 总 GDP | (F26) |
| `ystar` | $y_t^{\ast}$ | 潜在产出 | policy-rule input |
| `yC`, `yD` | $y_t^C,y_t^D$ | 分部门产出 | (F14), (F15), (F18), (F19) |
| `yCstar`, `yDstar`, `dstar` | $y_t^{C,\ast},y_t^{D,\ast},d_t^{\ast}$ | 潜在产出辅助变量 | implementation cross-check |
| `deltabB` | $\Delta b_t^B$ | 名义信贷增长 | (F25) |

### 外生冲击

| ASCII name | Mathematical symbol | 含义 |
|---|---|---|
| `eps_A` | $\varepsilon_t^a$ | 非耐用品部门 TFP 创新 |
| `eps_D` | $\varepsilon_t^d$ | 住房需求创新 |
| `eps_v` | $\varepsilon_t^v$ | 金融/贷款利差创新 |

### 参数

| ASCII name | Mathematical symbol | 含义 |
|---|---|---|
| `epsilon` | $\varepsilon$ | 习惯形成 |
| `eta` | $\eta$ | 住宅投资调整成本曲率 |
| `beta` | $\beta$ | 储蓄者贴现因子 |
| `betaB` | $\beta^B$ | 借款者贴现因子 |
| `delta` | $\delta$ | 住房折旧 |
| `lL` | $\iota_L$ | 劳动重新配置/转换成本 |
| `phi` | $\varphi$ | Frisch 弹性倒数 |
| `alpha` | $\alpha$ | GDP 中非耐用品部门份额 / 劳动聚合份额 |
| `gamma` | $\gamma$ | 非耐用品效用权重 |
| `lambda` | $\lambda$ | 储蓄者占比 |
| `kappa` | $\kappa$ | 利差对贷款价值比的弹性 |
| `kappaC`, `kappaD` | $\kappa^C,\kappa^D$ | Phillips 曲线斜率 |
| `phiC`, `phiD` | $\varphi_C,\varphi_D$ | 分部门通胀指数化 |
| `thetaC`, `thetaD` | $\theta_C,\theta_D$ | Calvo 不调价概率 |
| `gammaR` | $\gamma_r$ | 利率平滑 |
| `gammapi` | $\gamma_\pi$ | 对 CPI 通胀的政策反应 |
| `gammay` | $\gamma_y$ | 对产出缺口的政策反应 |
| `gammab` | $\gamma_b$ | 对名义信贷增长的政策反应 |
| `tau` | $\tau$ | 对名义信贷增长的宏观审慎反应 |
| `rhoC`, `rhoD`, `rhov` | $\rho_a,\rho_d,\rho_v$ | 冲击持久性 |
| `C`, `D`, `CB`, `DB`, `IB`, `RL`, `BB`, `W`, `L`, `LB` | level constants | 线性化稳态常数 |
