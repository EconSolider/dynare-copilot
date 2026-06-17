# NK_ST13 - 推导（最优化问题 + 一阶条件）

> `NK_ST13` 的模型档案草稿。未进行运行时验证。论文侧方程来自 Stracca (2013) 的 MinerU Markdown；MMB `.mod` 文件仅作为实现交叉检查使用。

## 1. Model Overview

- **模型**：Livio Stracca (2013), "Inside money in general equilibrium: Does it matter for monetary policy?", *Macroeconomic Dynamics* 17(3), 563-590, DOI `10.1017/s1365100511000368`。
- **档案 ID**：`NK_ST13`。
- **主体**：代表性家庭、最终品厂商、连续统中间品厂商、竞争性金融中介、货币当局、被动财政当局。
- **核心机制**：存款是内部货币，并进入消费的预付存款约束。银行发行存款、债券和央行借款，同时持有贷款和准备金。存款生产成本使内部货币溢价 $R_t-R_t^d$ 内生化。
- **冲击**：技术冲击 $\varepsilon_{\theta t}$、货币政策冲击 $\varepsilon_t^R$、内部货币需求冲击 $q_t$、内部货币供给/中介成本冲击 $j_t$。
- **形式**：非线性均衡条件，包含 Rotemberg 价格调整成本以及二次资本/存款调整成本；MMB 实现采用一阶近似。实现中有平行的无摩擦/参考块，但以下论文侧基准档案条目聚焦于内部货币模型。
- **来源质量**：第一轮提取来自 OCR Markdown。方程足以形成草稿，但若干期望和时序规范化在推广前需要源级复核。

## 2. Optimization Problems

### 2.1 家庭

家庭选择 $\{c_t,n_t,b_t,d_t\}$ 以最大化预期终身效用

$$
E_t\sum_{j=0}^{\infty}\beta^j U_{t+j},
\qquad
U_t=\ln c_t-\phi n_t-\frac{\phi_d}{2}\left(\frac{D_t-D_{t-1}}{P_t}\right)^2,
$$

并满足实际预算约束和预付存款约束

$$
c_t+b_t+d_t=w_t n_t+\frac{d_{t-1}R_{t-1}^d}{\pi_t}
+\frac{b_{t-1}R_{t-1}}{\pi_t}+g_t,
$$

$$
\alpha_t c_t\le d_t.
$$

预算约束的拉格朗日乘子为 $\lambda_t$，预付存款约束的乘子为 $\xi_t$。

### 2.2 最终品厂商

竞争性最终品厂商用如下 CES 聚合差异化产品 $y_t(z)$：

$$
y_t=\left(\int_0^1 y_t(z)^{\frac{\mu-1}{\mu}}\,dz\right)^{\frac{\mu}{\mu-1}},
$$

并在给定价格下选择各品种需求。

### 2.3 中间品厂商

每个中间品厂商使用 Cobb-Douglas 技术

$$
y_t(z)=A_t k_t(z)^\gamma n_t(z)^{1-\gamma},
$$

并提前一期借款以融资工资账单和投资，

$$
L_t(z)=W_t n_t(z)+P_t i_t(z).
$$

厂商最大化扣除 Rotemberg 价格调整成本和二次资本调整成本后的贴现股利。调整成本为

$$
C_p(P_t(z))=\frac{\phi_p}{2}\left(\frac{P_t(z)}{P_{t-1}(z)}-1\right)^2 y_t(z),
$$

$$
C_k(k_t(z))=\frac{\phi_k}{2}\left(k_t(z)-k_{t-1}(z)\right)^2.
$$

### 2.4 金融中介

代表性竞争银行在给定政策利率下选择贷款利率、存款利率和准备金，并满足资产负债表约束

$$
L_t+M_t=B_t+D_t+\widetilde B_t.
$$

实际利润为

$$
\begin{aligned}
g_t^f={}&d_t+b_t+\widetilde b_t+\frac{m_{t-1}}{\pi_t}
+l_{t-1}\frac{R_{t-1}^l}{\pi_t}
-\frac{d_{t-1}R_{t-1}^d}{\pi_t}
-\frac{b_{t-1}R_{t-1}}{\pi_t} \\
&-\frac{\widetilde b_{t-1}R_{t-1}}{\pi_t}
-(1+\sigma)l_t-m_t-\frac{\omega_t d_t}{m_t}.
\end{aligned}
$$

金融中介成本为

$$
f_t=\sigma l_t+\frac{\omega_t d_t}{m_t}.
$$

### 2.5 货币当局

央行以债券交换银行准备金，

$$
\widetilde B_t=M_t,
$$

并用含利率平滑的规则设定无风险名义总利率。

## 3. First-Order Conditions

**家庭**

- **(F1) 预付存款约束**：

$$
\alpha_t c_t=d_t.
$$

- **(F2) 消费一阶条件**：

$$
\frac{1}{c_t}-\lambda_t-\xi_t\alpha_t=0.
$$

- **(F3) 劳动一阶条件**：

$$
\lambda_t=\frac{\phi}{w_t}.
$$

- **(F4) 债券欧拉方程**：

$$
\lambda_t=\beta R_t E_t\left(\frac{\lambda_{t+1}}{\pi_{t+1}}\right).
$$

- **(F5) 存款一阶条件 / 带调整成本的内部货币需求**：

$$
\beta E_t\left[\frac{\lambda_{t+1}(R_t-R_t^d)}{\pi_{t+1}}\right]
+\phi_d\left(d_t-\frac{d_{t-1}}{\pi_t}\right)
=\beta\phi_d E_t\left[\frac{1}{\pi_{t+1}}\left(d_{t+1}-\frac{d_t}{\pi_{t+1}}\right)\right]-\xi_t.
$$

`needs_review`：Rep-MMB `.mod` 注释称 $\xi_t$ 的符号与论文不同；上式遵循论文 OCR。

- **(F6) 随机折现因子**：

$$
\psi_{t,t+1}=\beta E_t\left(\frac{\lambda_{t+1}}{\lambda_t}\right).
$$

**最终品厂商**

- **(F7) 中间品品种需求**：

$$
y_t(z)=\left(\frac{P_t(z)}{P_t}\right)^{-\mu}y_t.
$$

- **(F8) 总价格指数**：

$$
P_t=\left(\int_0^1 P_t(z)^{1-\mu}\,dz\right)^{-\frac{1}{1-\mu}}.
$$

**中间品厂商**

- **(F9) 生产函数**：

$$
y_t(z)=A_t k_t(z)^\gamma n_t(z)^{1-\gamma}.
$$

- **(F10) 资本积累**：

$$
k_t=i_t+(1-\delta)k_{t-1}.
$$

- **(F11) 资本边际产出**：

$$
y_t^k=\gamma\frac{y_t}{k_{t-1}}.
$$

- **(F12) 劳动边际产出**：

$$
y_t^n=(1-\gamma)\frac{y_t}{n_t}.
$$

- **(F13) 含融资成本的实际边际成本**：

$$
\operatorname{rmc}_t(z)
=E_t\left[\frac{\psi_{t,t+1}w_t R_t^l}{y_t^n(z)\pi_{t+1}}\right]
=\frac{R_{t-1}^l}{y_t^k(z)\pi_t}
-E_t\left[\frac{\psi_{t,t+1}R_t^l(1-\delta)}{y_{t+1}^k(z)\pi_{t+1}}\right]
+\phi_k\left(\frac{\Delta k_t(z)}{y_t^k(z)}
-E_t\left[\psi_{t,t+1}\frac{\Delta k_{t+1}(z)}{y_t^k(z)}\right]\right).
$$

`needs_review`：OCR 公式在同一展示式中包含劳动成本和资本成本两种表达；本条保留该关系，但应对照 PDF 复核。

- **(F14) 劳动需求**：

$$
w_t=E_t\left[\frac{\psi_{t,t+1}y_t^n(z)P_t(z)\pi_{t+1}}{P_t R_t^l}\right].
$$

- **(F15) 资本一阶条件**：

$$
\frac{R_{t-1}^l}{\pi_t}+\phi_k\Delta k_t(z)
=\frac{P_t(z)}{P_t}y_t^k(z)
+\phi_k E_t\left[\psi_{t,t+1}\Delta k_{t+1}(z)\right]
+E_t\left[\frac{\psi_{t,t+1}R_t^l(1-\delta)}{\pi_{t+1}}\right].
$$

- **(F16) Rotemberg 新凯恩斯 Phillips 曲线**：

$$
\lambda_t(\pi_t-1)\pi_t
=\frac{\lambda_t}{\phi_p}(1-\mu+\mu\,\operatorname{rmc}_t)
+\beta E_t\left[\lambda_{t+1}(\pi_{t+1}-1)\pi_{t+1}\frac{y_{t+1}}{y_t}\right].
$$

**金融中介**

- **(F17) 银行资产负债表恒等式**：

$$
l_t+m_t=b_t+d_t+\widetilde b_t.
$$

- **(F18) 贷款供给 / 外部融资溢价**：

$$
E_t\left[\psi_{t,t+1}\frac{R_t^l-R_t}{\pi_{t+1}}\right]=\sigma.
$$

- **(F19) 存款利率一阶条件 / 内部货币溢价**：

$$
E_t\left[\psi_{t,t+1}\frac{R_t-R_t^d}{\pi_{t+1}}\right]=\frac{\omega_t}{m_t}.
$$

- **(F20) 银行准备金需求**：

$$
m_t=E_t\left[\frac{\omega_t d_t\pi_{t+1}}{\beta\lambda_{t+1}(R_t-1)}\right]^{1/2}.
$$

**货币当局**

- **(F21) 央行资产负债表**：

$$
\widetilde B_t=M_t.
$$

- **(F22) 利率规则**：

$$
R_t=(1-\rho)\left[\frac{1}{\beta}+\varphi_\pi(\pi_t-1)\right]+\rho R_{t-1}+\varepsilon_t^R.
$$

## 4. Market Clearing & Identities

- **(F23) 全经济资源约束**：

$$
y_t=c_t+i_t+\frac{\phi_k}{2}\Delta k_t^2
+\frac{\phi_p}{2}\left(\frac{P_t}{P_{t-1}}-1\right)^2y_t
+\frac{\omega_t d_t}{m_t}+\sigma l_t.
$$

- **(F24) 企业贷款需求**：

$$
l_t=i_t+w_t n_t.
$$

- **(F25) 金融中介成本定义**：

$$
f_t=\sigma l_t+\frac{\omega_t d_t}{m_t}.
$$

- **(F26) 利率利差**：

$$
EFP_t=R_t^l-R_t,\qquad IMP_t=R_t-R_t^d.
$$

- **(F27) 资本变动定义**：

$$
\Delta k_t=k_t-k_{t-1}.
$$

## 5. Exogenous Processes

- **(F28) 预付存款紧度 / 内部货币需求冲击**：

$$
\alpha_t=\rho_\alpha\alpha_{t-1}+(1-\rho_\alpha)\alpha+q_t.
$$

- **(F29) 技术过程**：

$$
A_t=\exp(\chi t+\theta_t),
\qquad
\theta_t=\rho_\theta\theta_{t-1}+\varepsilon_{\theta t}.
$$

- **(F30) 内部货币供给成本过程**：

$$
\omega_t=(1-\rho_\omega)\omega+\rho_\omega\omega_{t-1}+j_t.
$$

- **(F31) 可选银行困境变体**：

$$
\sigma_t=\sigma+\omega_t-\omega.
$$

(F31) 是文中讨论的银行困境实验，不是基准模型块。

## 6. Steady-State Solution

论文使用零通胀、非随机稳态。令 $\pi=1$，冲击为零，在 MMB 校准中 $\chi=0$ 时 $A=1$，并令 $\Delta k=0$。

1. 债券欧拉方程：

$$
R=\frac{1}{\beta}.
$$

2. 预付存款约束：

$$
d=\alpha c.
$$

3. 来自附录的家庭稳态货币需求：

$$
\ln d=-\ln\left[\frac{\lambda}{\alpha}+\beta(R-R^d)\right].
$$

`needs_review`：附录方程 (A.5) 的 OCR 含有疑似多余的尾部 `=0`；上面的对数表达遵循论文方程 (14)/(A.6)。

4. 劳动一阶条件和消费一阶条件：

$$
\lambda=\frac{\phi}{w},
\qquad
\xi=\frac{1}{c\alpha}-\frac{\lambda}{\alpha}.
$$

5. 金融中介利差：

$$
R^l=R+\frac{\sigma}{\psi},
\qquad
R^d=R-\frac{\omega}{m\psi}.
$$

6. 准备金需求：

$$
m=\left[\frac{\omega d}{\beta\lambda(R-1)}\right]^{1/2}.
$$

7. 零资本调整下的厂商侧稳态：

$$
k=i+(1-\delta)k,\qquad i=\delta k.
$$

$$
y=A k^\gamma n^{1-\gamma},\qquad
y^k=\gamma\frac{y}{k},\qquad
y^n=(1-\gamma)\frac{y}{n}.
$$

8. 由零通胀 Phillips 曲线得到的边际成本：

$$
\operatorname{rmc}=\frac{\mu-1}{\mu}.
$$

9. 资源约束：

$$
y=c+i+\frac{\omega d}{m}+\sigma l,
\qquad
l=i+wn.
$$

10. MMB 实现使用的校准值包括 $\beta=0.995$、$\phi=3$、$\gamma=0.35$、$\delta=0.025$、$\sigma=0.00675$、$\omega=0.0009$、$\alpha=0.7$、$\phi_d=10$、$\rho_\alpha=0.88$、$\phi_p=58.25$、$\phi_k=4$、$\rho=0.75$、$\rho_\pi=1.5$、$\rho_\omega=0.9$ 和 $\rho_\theta=0.95$。

## 7. Timing & Form Conventions

- 存款、银行债券和企业贷款均为一期名义债权。家庭在 $t$ 期选择的资产在 $t+1$ 支付，并通过除以当期通胀进入实际预算约束。
- 家庭在 $t$ 期期初向金融中介提供存款和银行债券；银行随后向企业贷款，企业用贷款支付工资和投资。企业在 $t+1$ 期期初偿还贷款。
- 生产性资本在生产中是预定状态。MMB 实现在生产函数和边际产出中使用 $k_{t-1}$，并写作 $k_t=i_t+(1-\delta)k_{t-1}$。
- 通胀为总通胀率，$\pi_t=P_t/P_{t-1}$。
- 论文方程是非线性的。Dynare/Rep-MMB 围绕零通胀稳态近似。不要将本档案草稿视为手工对数线性化模型。
- 未进行运行时验证，也未运行 Dynare。

## 8. Variable & Parameter Reference Table

| 类别 | 符号 / ASCII | 含义 | 主要方程 |
| --- | --- | --- | --- |
| 内生 | $c_t$ / `c` | 消费 | (F1), (F2), (F23) |
| 内生 | $i_t$ / `i` | 投资 | (F10), (F23), (F24) |
| 内生 | $y_t$ / `y` | 产出 | (F7), (F9), (F23) |
| 内生 | $n_t$ / `n` | 劳动 | (F3), (F12), (F14) |
| 内生 | $w_t$ / `w` | 实际工资 | (F3), (F14), (F24) |
| 内生 | $k_t$ / `k` | 资本存量 | (F10), (F15), (F27) |
| 内生 | $\Delta k_t$ / `delta_k` | 资本变动 | (F27) |
| 内生 | $m_t$ / `m` | 实际外部货币 / 银行准备金 | (F20), (F23) |
| 内生 | $d_t$ / `d` | 实际存款 / 内部货币 | (F1), (F5), (F19) |
| 内生 | $b_t$ / `b` | 家庭持有的银行债券 | (F17) |
| 内生 | $l_t$ / `l` | 银行对企业贷款 | (F17), (F18), (F24) |
| 内生 | $R_t$ / `R` | 无风险名义总利率 | (F4), (F22) |
| 内生 | $R_t^d$ / `Rd` | 存款总利率 | (F5), (F19), (F26) |
| 内生 | $R_t^l$ / `Rl` | 贷款总利率 | (F13), (F18), (F26) |
| 内生 | $\lambda_t$ / `lambda` | 预算约束乘子 | (F2)-(F6) |
| 内生 | $\xi_t$ / `xi` | 预付存款约束乘子 | (F2), (F5) |
| 内生 | $\psi_{t,t+1}$ / `psi` | 随机折现因子 | (F6), (F13), (F18)-(F20) |
| 内生 | $\pi_t$ / `pi` | 总通胀率 | (F4), (F16), (F22), (F23) |
| 内生 | $\operatorname{rmc}_t$ / `rmc` | 实际边际成本 | (F13), (F16) |
| 内生 | $y_t^k$ / `yk` | 资本边际产出 | (F11), (F13), (F15) |
| 内生 | $y_t^n$ / `yn` | 劳动边际产出 | (F12), (F13), (F14) |
| 内生 | $f_t$ / `f` | 金融中介成本 | (F25) |
| 内生 | $EFP_t$ / `EFP` | 外部融资溢价 | (F26) |
| 内生 | $IMP_t$ / `IMP` | 内部货币溢价 | (F26) |
| 内生 | $\alpha_t$ / `alpha` | 预付存款紧度 | (F1), (F28) |
| 内生 | $\omega_t$ / `omega` | 存款服务成本状态 | (F19), (F20), (F30) |
| 内生 | $A_t,\theta_t$ / `A`, `theta` | 生产率水平和技术状态 | (F9), (F29) |
| 外生 | $q_t$ / `q` | 内部货币需求创新 | (F28) |
| 外生 | $\varepsilon_{\theta t}$ / `epsilon_theta` | 技术创新 | (F29) |
| 外生 | $j_t$ / `j` | 内部货币供给/成本创新 | (F30) |
| 外生 | $\varepsilon_t^R$ / `epsilon_r` | 货币政策创新 | (F22) |
| 参数 | $\beta$ / `beta` | 贴现因子 | (F4)-(F6), (F16), (F20), (F22) |
| 参数 | $\phi$ / `phi` | 劳动负效用权重 | (F3) |
| 参数 | $\phi_d$ / `phi_d` | 存款调整成本 | (F5) |
| 参数 | $\gamma$ / `gamma` | 资本份额 | (F9), (F11), (F12) |
| 参数 | $\delta$ / `delta` | 资本折旧 | (F10), (F15) |
| 参数 | $\phi_p$ / `phi_p` | Rotemberg 价格调整成本 | (F16), (F23) |
| 参数 | $\phi_k$ / `phi_k` | 资本调整成本 | (F13), (F15), (F23) |
| 参数 | $\mu$ / `mu` | 替代弹性 / 加成参数 | (F7), (F8), (F16) |
| 参数 | $\sigma$ / `sigma` | 贷款中介成本 | (F18), (F23), (F25) |
| 参数 | $\omega$ / `omega_ss` | 稳态存款服务成本状态 | (F19), (F20), (F30) |
| 参数 | $\rho,\varphi_\pi$ / `rho`, `rho_pi` | 政策平滑与通胀反应 | (F22) |
| 参数 | $\rho_\alpha,\rho_\theta,\rho_\omega$ | 冲击持续性 | (F28)-(F30) |
