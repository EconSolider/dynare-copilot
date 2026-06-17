# NK_CW09 - 信贷摩擦与最优货币政策推导

> 状态：`needs_review`。本首轮归档条目来自 Curdia and Woodford (2009) 的 MinerU Markdown；MMB 复现文件仅作为实现交叉检查。未执行运行时验证。

来源：Vasco Curdia and Michael Woodford, "Credit frictions and optimal monetary policy", BIS Working Paper No. 278, 2009, DOI `10.2139/ssrn.1440289`。

## 1. Model Overview

- **模型**：`NK_CW09`，一个含异质家庭、金融中介以及存款利率和借款利率利差的无现金新凯恩斯模型。
- **主体**：在借款者（`b`）和储蓄者（`s`）类型之间转换的家庭、竞争性金融中介、采用 Calvo 定价的垄断竞争产品生产者、财政当局和货币当局。
- **核心摩擦**：借款者支付贷款利率 $i_t^b$，储蓄者获得存款/政策利率 $i_t^d$，利差反映中介资源成本以及可能存在的中介加价。
- **形式**：论文给出非线性均衡，然后围绕零通胀稳态进行对数线性化。MMB 实现是非线性水平方程加辅助对数偏离定义，并在一阶下求解；本推导同时记录非线性结构方程和来源重点给出的对数线性政策模块。
- **溯源**：主 Markdown `raw/mmb_mineru/runs/nk_cw09__credit_frictions_and_optimal_monetary_policy__763a743f/full.md`；原始 PDF `raw/mmb_papers/Credit frictions and optimal monetary policy 2009.pdf`；MinerU run IDs `763a743f-88d3-48b0-a1c5-d85aa1904cdd` 和 `8a203c25-5728-480d-b422-aa5185c8e7af`。

## 2. Optimization Problems

### 2.1 家庭

家庭 $i$ 最大化带贴现的期望效用，其消费效用依赖类型，劳动负效用共同：

$$
E_0\sum_{t=0}^{\infty}\beta^t\left[
u^{\tau_t(i)}(\mathbf{c}_t(i);\xi_t)
-\int_0^1 v(h_t(j;i);\xi_t)\,dj
\right].
$$

类型 $\tau_t(i)\in\{b,s\}$ 服从二状态 Markov 过程。以概率 $1-\delta$ 重新抽取类型，抽到 `b` 和 `s` 的概率分别为 $\pi_b$ 和 $\pi_s$；否则家庭保留上一期类型。在相关范围内，`b` 型家庭的当前消费边际效用高于 `s` 型家庭。

期初名义财富和期末名义财富为：

$$
A_t(i)=[B_{t-1}(i)]^+(1+i_{t-1}^d)+[B_{t-1}(i)]^-(1+i_{t-1}^b)+D_t^{int}+T_t(i),
$$

$$
B_t(i)=A_t(i)-P_tc_t(i)+\int W_t(j)h_t(j;i)\,dj+D_t+T_t^g.
$$

### 2.2 金融中介

金融中介通过约化技术把存款转化为贷款：

$$
d_t=b_t+\Xi_t(b_t),
$$

其中 $\Xi_t(0)=0$，$\Xi_t'(b)\ge 0$，且 $\Xi_t''(b)\ge 0$。竞争性中介和可能的加价 $\mu_t^b(b_t)$ 产生贷款利率和存款利率之间的楔子：

$$
1+i_t^b=(1+i_t^d)(1+\omega_t),\qquad
1+\omega_t=\mu_t^b(b_t)\left[1+\Xi_t'(b_t)\right].
$$

### 2.3 劳动供给与产品生产者

家庭供给差异化劳动类型。采用等弹性劳动负效用

$$
v(h;\xi_t)=\frac{1}{1+\nu}h^{1+\nu}\bar{H}_t^{-\nu},
$$

总劳动供给可由边际效用聚合量概括：

$$
\tilde{\lambda}_t=\left[\pi_b(\lambda_t^b)^{1/\nu}+\pi_s(\lambda_t^s)^{1/\nu}\right]^\nu.
$$

产品生产者使用等弹性生产函数 $y_t(i)=A_t h_t(i)^{1/\phi}$ 并采用 Calvo 定价。价格分散度 $\Delta_t$ 影响总劳动需求，并随通胀演化。

## 3. First-Order Conditions

- **(F1) 借款者 Euler 方程**：

$$
\lambda_t^b=\beta E_t\left[
\frac{1+i_t^b}{\Pi_{t+1}}
\left\{[\delta+(1-\delta)\pi_b]\lambda_{t+1}^b+(1-\delta)\pi_s\lambda_{t+1}^s\right\}
\right].
$$

- **(F2) 储蓄者 Euler 方程**：

$$
\lambda_t^s=\beta E_t\left[
\frac{1+i_t^d}{\Pi_{t+1}}
\left\{(1-\delta)\pi_b\lambda_{t+1}^b+[\delta+(1-\delta)\pi_s]\lambda_{t+1}^s\right\}
\right].
$$

- **(F3) 按类型的消费需求**：

$$
c_t^b=c^b(\lambda_t^b;\xi_t),\qquad
c_t^s=c^s(\lambda_t^s;\xi_t).
$$

- **(F4) 劳动供给工资表**：

$$
\frac{W_t(j)}{P_t}=\mu_t^w\tilde{\lambda}_t^{-1}\left(\frac{h_t(j)}{\bar{H}_t}\right)^\nu.
$$

- **(F5) 边际效用聚合量**：

$$
\tilde{\lambda}_t=\left[\pi_b(\lambda_t^b)^{1/\nu}+\pi_s(\lambda_t^s)^{1/\nu}\right]^\nu.
$$

- **(F6) 总工资账单**：

$$
\int W_t(j)h_t(j)\,dj
=\mu_t^w\frac{P_t}{\tilde{\lambda}_t\bar{H}_t^\nu}
\left(\frac{Y_t}{A_t}\right)^{1+\omega_y}\Delta_t,
\qquad \omega_y=\phi(1+\nu)-1.
$$

- **(F7) 新凯恩斯价格设定模块**（`needs_review`：来源说明递归函数 $G$ 和 $g$ 在附录中，抽取的 Markdown 未完全展开）：

$$
\Pi_t=\Pi(Z_t),\qquad
Z_t=G(Y_t,\lambda_t^b,\lambda_t^s;\tilde{\xi}_t)+E_t[g(\Pi_{t+1},Z_{t+1})].
$$

- **(F8) 对数线性借款者边际效用方程**：

$$
\hat{\lambda}_t^b=\hat{i}_t^b-E_t\pi_{t+1}
+[\delta+(1-\delta)\pi_b]E_t\hat{\lambda}_{t+1}^b
+(1-\delta)\pi_sE_t\hat{\lambda}_{t+1}^s.
$$

- **(F9) 对数线性储蓄者边际效用方程**：

$$
\hat{\lambda}_t^s=\hat{i}_t^d-E_t\pi_{t+1}
+(1-\delta)\pi_bE_t\hat{\lambda}_{t+1}^b
+[\delta+(1-\delta)\pi_s]E_t\hat{\lambda}_{t+1}^s.
$$

- **(F10) 平均边际效用关系**：

$$
\hat{\lambda}_t=\hat{i}_t^{avg}-E_t\pi_{t+1}+E_t\hat{\lambda}_{t+1},
\qquad
\hat{i}_t^{avg}\equiv\pi_b\hat{i}_t^b+\pi_s\hat{i}_t^d.
$$

- **(F11) 边际效用差距关系**：

$$
\hat{\Omega}_t=\hat{\omega}_t+\delta E_t\hat{\Omega}_{t+1},
\qquad
\hat{\Omega}_t\equiv\hat{\lambda}_t^b-\hat{\lambda}_t^s.
$$

- **(F12) 跨期 IS 关系**（`needs_review`：来源 OCR 损坏了若干利率帽记号，但显示关系和实现文件均对应平均利率对象）：

$$
\hat{Y}_t=-\bar{\sigma}(\hat{i}_t^{avg}-E_t\pi_{t+1})
+E_t\hat{Y}_{t+1}
-E_t\left[\Delta g_{t+1}+\Delta\hat{\Xi}_{t+1}
-\bar{\sigma}s_\Omega\Delta\hat{\Omega}_{t+1}\right].
$$

- **(F13) 含信贷摩擦项的新凯恩斯 Phillips 曲线**：

$$
\pi_t=\kappa(\hat{Y}_t-\hat{Y}_t^n)+u_t
+\xi(s_\Omega+\pi_b-\gamma_b)\hat{\Omega}_t
-\xi\bar{\sigma}^{-1}\hat{\Xi}_t
+\beta E_t\pi_{t+1}.
$$

## 4. Market Clearing & Identities

- **(F14) 产品市场出清**：

$$
Y_t=\pi_b c^b(\lambda_t^b;\xi_t)+\pi_s c^s(\lambda_t^s;\xi_t)+G_t+\Xi_t(b_t).
$$

- **(F15) 政府债务运动方程**：

$$
b_t^g=b_{t-1}^g\frac{1+i_{t-1}^d}{\Pi_t}+G_t+\frac{T_t^g}{P_t}-\tau_tY_t.
$$

- **(F16) 金融中介利差恒等式**：

$$
1+i_t^b=(1+i_t^d)(1+\omega_t),\qquad
1+\omega_t=\mu_t^b(b_t)\left[1+\Xi_t'(b_t)\right].
$$

- **(F17) 总私人债务运动方程**（`needs_review`：保留论文显示的总量方程；若后续要做可运行模型，应检查附录中的完整 $B(\cdot)$ 定义）：

$$
\begin{aligned}
b_t={}&\delta\left[b_{t-1}+\pi_s\omega_{t-1}(b_{t-1})b_{t-1}
+\pi_b\Xi_{t-1}(b_{t-1})\right]\frac{1+i_{t-1}^d}{\Pi_t}
-\pi_b\Xi_t(b_t)\\
&+\pi_b\left[\delta b_{t-1}^g\frac{1+i_{t-1}^d}{\Pi_t}-b_t^g\right]
+\pi_b\pi_sB(Y_t,\lambda_t^b,\lambda_t^s,\Delta_t;\tilde{\xi}_t).
\end{aligned}
$$

- **(F18) 价格分散度运动方程**（`needs_review`：来源把函数 $h$ 留给附录）：

$$
\Delta_t=h(\Delta_{t-1},\Pi_t).
$$

## 5. Exogenous Processes

- **(F19) MMB 交叉检查中使用的一般 AR(1) 扰动过程**：

$$
x_t=(1-\rho_x)\bar{x}+\rho_x x_{t-1}+\varepsilon_t^x,
\qquad
x\in\{\bar{C}^b,\bar{C}^s,G,\bar{H},\mu^w,\tau,\epsilon^m,\tilde{\Xi},\tilde{\chi},Z,b^g\}.
$$

- **(F20) 存款/政策利率 Taylor 规则及可选利差调整**：

$$
\hat{i}_t^d=\phi_\pi\pi_t+\phi_y\hat{Y}_t+\epsilon_t^m
\quad\text{or}\quad
\hat{i}_t^d=\phi_\pi\pi_t+\phi_y\hat{Y}_t-\phi_\omega\hat{\omega}_t.
$$

论文还强调恒等式

$$
\hat{i}_t^{avg}=\hat{i}_t^d+\pi_b\hat{\omega}_t,
$$

因此政策利率变动必须通过与总需求相关的平均利率来解释。

## 6. Steady-State Solution

论文围绕确定性零通胀稳态进行对数线性化。主文没有完全展开完整非线性稳态，MMB 复现所用的若干校准公式属于实现证据，而不是论文端推导证据。因此本节首轮状态为 `needs_review`。

从来源和实现交叉检查记录的稳态限制：

1. 设 $\Pi=1$，外生创新为零，并按实现交叉检查归一化产出/生产率对象：$\bar{Y}=1$，$\bar{Z}=1$，$\bar{\Delta}=1$。
2. 校准中取家庭类型份额 $\pi_b=\pi_s=0.5$。
3. 取类型持续性 $\delta=0.975$。
4. 给定存款利率稳态 $\bar{i}^d$ 和年化利差目标；论文校准使用 2 个百分点的年化稳态利差。
5. 选择 $\bar{b}/\bar{Y}$ 并校准中介函数。凸情形为 $\Xi(b)=\tilde{\Xi}b^\eta$。
6. 联立类型 Euler 方程 (F1)-(F2)，求解稳态边际效用 $\bar{\lambda}^b,\bar{\lambda}^s$ 以及利差隐含的边际效用差距。
7. 使用类型消费需求 (F3)、总需求 (F14) 和政府支出恢复 $\bar{c}^b,\bar{c}^s,\bar{G}$。
8. 使用劳动供给聚合量 (F5)、工资表 (F4) 以及产品定价模块 (F7)/(F18) 恢复 $\bar{\tilde{\lambda}}$、工资成本和稳态价格分散度对象。

MMB 实现交叉检查定义了 `lambda_b_bar`、`lambda_s_bar`、`lambda_tilde_bar`、`Lambda_bar`、`K_bar`、`F_bar`、`B_bar` 和 `Xi_tilde_bar` 等稳态常数。这些对未来可运行验证有用，但在作为来源陈述推导推广前，应先与论文附录核对。

## 7. Timing & Form Conventions

- 论文结构模型是非线性的；第 2 节使用围绕 $\bar{\Pi}=1$ 的对数线性化均衡关系。
- 存款和贷款是期末 $t$ 选择并在 $t+1$ 期初偿还的一期名义合约。
- $i_t^d$ 是基础设定中的储蓄者/存款利率和政策利率对象；$i_t^b$ 是借款者/贷款利率。
- $b_t$ 是期末来自中介的实际借款；$b_t^g$ 是实际政府债务。
- $\Delta_t$ 是类似存量的价格分散度对象，依赖 $\Delta_{t-1}$。
- MMB 复现使用水平变量，并为对数偏离/年化变量设置单独的 hat 变量。这是实现约定，不是论文端要求。
- 未执行运行时验证。

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Main equation |
|---|---|---|---|
| Endogenous | $\lambda_t^b$ / `lambda_b` | 借款者收入边际效用 | (F1), (F8) |
| Endogenous | $\lambda_t^s$ / `lambda_s` | 储蓄者收入边际效用 | (F2), (F9) |
| Endogenous | $c_t^b,c_t^s$ / `C_bar_b`, `C_bar_s` | 分类型消费需求 | (F3), (F14) |
| Endogenous | $\tilde{\lambda}_t$ / `lambda_tilde` | 劳动供给边际效用聚合量 | (F5) |
| Endogenous | $\Lambda_t$ / `Lambda` | 实现中的平均边际效用聚合量 | (F10) |
| Endogenous | $Y_t$ / `Y` | 总产出 | (F12), (F14) |
| Endogenous | $\Pi_t$ / `Pi` | 总通胀 | (F7), (F13) |
| Endogenous | $i_t^d$ / `i_d` | 存款/政策利率 | (F2), (F16), (F20) |
| Endogenous | $i_t^b$ / `i_b_hat` | 借款贷款利率对象/利差调整利率 | (F1), (F16) |
| Endogenous | $\omega_t$ / `omega` | 信贷利差 | (F11), (F16) |
| Endogenous | $b_t$ / `b` | 私人借款/中介信贷 | (F17) |
| Endogenous | $b_t^g$ / `b_g` | 政府债务 | (F15), (F19) |
| Endogenous | $\Delta_t$ / `Delta` | 价格分散度 | (F18) |
| Endogenous | $Z_t$ / `Z` | 随记号上下文表示生产率或 Calvo 辅助对象 | (F7), (F19) |
| Endogenous | $K_t,F_t$ / `K`, `F` | 实现中的 Calvo 递归辅助变量 | (F7) |
| Exogenous | $\epsilon_t^m$ / `e_epsilon_m` | 货币政策扰动 | (F19), (F20) |
| Exogenous | $\varepsilon_t^x$ | 偏好、政府支出、劳动供给、加价、生产率、金融摩擦和债务冲击 | (F19) |
| Parameter | $\beta$ / `beta` | 贴现因子 | (F1), (F2), (F13) |
| Parameter | $\delta$ / `delta` | 类型持续概率 | (F1), (F2), (F11), (F17) |
| Parameter | $\pi_b,\pi_s$ / `pi_b`, `pi_s` | 类型份额 | (F1)-(F5), (F10), (F14), (F17) |
| Parameter | $\nu$ / `nu` | 劳动供给弹性相关参数 | (F4)-(F6) |
| Parameter | $\phi,\omega_y$ / `phi`, `omega_y` | 生产曲率和由此得到的边际成本弹性 | (F6), (F13) |
| Parameter | $\theta,\alpha$ / `theta`, `alpha` | 需求弹性 / Calvo 价格黏性记号 | (F7), (F13), (F18) |
| Parameter | $\mu_t^w,\mu_t^b$ / `mu_w`, financial markup | 劳动和中介加价 | (F4), (F16), (F19) |
| Parameter | $\Xi_t,\tilde{\Xi},\eta$ / `Xi_tilde` | 中介资源成本函数 | (F12), (F14), (F16), (F17), (F19) |
| Parameter | $\phi_\pi,\phi_y,\phi_\omega$ / `phi_pi`, `phi_y` | 政策规则系数 | (F20) |
