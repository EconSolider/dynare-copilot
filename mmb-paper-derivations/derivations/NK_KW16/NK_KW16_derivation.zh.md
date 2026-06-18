# NK_KW16 -- 推导（最优化问题 + 一阶条件）

> 归档状态：`needs_review`。本初稿推导以 MinerU Markdown 提取结果为论文侧来源，并用 MMB 实现作交叉检查。论文说明完整形式结构在在线补充材料中，但本地 MinerU Markdown 不包含该补充材料；仅由实现交叉检查支持的详细方程均标为 `needs_review`。原始 PDF 路径仅检查了是否存在。

来源：Markus Kirchner and Sweder van Wijnbergen (2016), "Fiscal deficits, financial fragility, and the effectiveness of government policies", *Journal of Monetary Economics* 80, 51-68. DOI: `10.1016/j.jmoneco.2016.04.007`。

## 1. 模型概述

- **模型**：封闭经济新凯恩斯 DSGE 模型，包含价格黏性、资本积累、习惯形成、金融中介、政府债务，以及两类政府债务融资渠道。
- **MMB 实现**：`NK_KW16`，Rep-MMB 中用于复现论文 Figure 1 银行融资情形的实现。
- **主体**：包含工人与银行家的家庭；中间品企业；资本品生产者；零售商/最终品生产者；受代理问题约束的银行；不受该代理问题约束的 Money Management Funds (MMFs)；财政与货币当局。
- **政策实验**：论文研究赤字融资的政府购买、预告支出、银行资本重组、资本质量冲击和 ZLB 变体。归档的 MMB 文件实现随机银行融资模型，不运行 ZLB 完全预见实验。
- **形式**：围绕非随机稳态的非线性/对数水平实现，使用 `exp()` 转换。MMB `.mod` 未声明 `model(linear)`。
- **来源边界**：MinerU Markdown 中可见方程 (2)-(15) 以及 Taylor/Fisher/财政方程。标准非金融结构和完整 FOC 列表被论文说明放在在线补充附录；由于本地缺少该附录，下面的非金融与完整均衡方程组保持 `needs_review`。

## 2. 最优化问题

### 2.1 家庭

代表性家庭最大化带消费习惯和劳动负效用的期望效用：

\[
\max_{\{c_t,h_t,d_t\}} E_t\sum_{s=0}^{\infty}\beta^s
\left[
\log(c_{t+s}-\nu c_{t-1+s})-\frac{h_{t+s}^{1+\varphi}}{1+\varphi}
\right].
\]

论文中的单期预算约束为：

\[
c_t+d_t+\tau_t \leq w_t h_t + (1+r_t^d)d_{t-1}+\Sigma_t.
\]

家庭在银行或 MMF 持有存款，并通过转移拥有企业和家庭内金融中介成员。`.mod` 交叉检查使用边际效用变量 `U_c` 和随机折现因子 `Lambda`。

### 2.2 中间品企业

中间品企业租用劳动、使用有效资本，并发行由银行融资的索取权。生产技术为：

\[
Y^m_t = a_t(\xi_tK_{t-1})^\alpha L_t^{1-\alpha}.
\]

企业在给定实际边际成本/中间品价格 \(P^m_t\)、工资 \(w_t\)、资本价格 \(Q_t\) 和资本回报 \(R^k_t\) 下选择资本和劳动需求。

### 2.3 资本品生产者

资本品生产者将未折旧的有效资本与投资品结合，并面对凸投资调整成本。令 \(S(I_t/I_{t-1})=\frac{\eta_i}{2}(I_t/I_{t-1}-1)^2\)，其最优投资条件决定 Tobin's \(Q_t\)。

### 2.4 零售商与最终品生产者

零售商面临 Calvo 价格黏性，不能重新定价的概率为 \(\gamma\)。均衡使用辅助变量 \(F_t\) 和 \(Z_t\)、最优重置通胀 \(\pi^\ast_t\)、通胀 \(\pi_t\) 与价格分散度 \(Dis_t\)。

### 2.5 银行

银行 \(j\) 持有私人索取权和政府债券：

\[
p^B_{j,t}=q_t s^k_{j,t}+s^b_{j,t}.
\]

其资产负债表为：

\[
p^B_{j,t}=d^B_{j,t}+n_{j,t}.
\]

净值随组合回报演化：

\[
n_{j,t+1}=(1+r^p_{t+1}-r^d_{t+1})p^B_{j,t}+(1+r^d_{t+1})n_{j,t}.
\]

组合权重满足：

\[
1+r^p_t=(1+r^k_t)\omega_{j,t-1}+(1+r^{b,B}_t)(1-\omega_{j,t-1}).
\]

银行家在激励约束下最大化贴现终端财富：

\[
\max_{\{s^k_{j,t},s^b_{j,t}\}} V_{j,t}
\quad\text{s.t.}\quad
V_{j,t}\geq \lambda^\ast p^B_{j,t}.
\]

绑定的激励约束生成内生杠杆率 \(\phi_t\)，以及私人索取权和政府债券的组合选择条件。

### 2.6 MMFs

MMFs 是政府债券的无摩擦传递型中介。其资产负债表为 \(p_t^{MMF}=d_t^{MMF}\)，债券回报等于存款回报：

\[
r_t^{b,MMF}=r_t^d.
\]

### 2.7 政府与货币当局

货币当局对名义存款利率使用 Taylor 规则，Fisher 关系定义事后实际存款回报。财政政策设定政府购买、税收、可能的银行转移，以及新债中分配给受杠杆约束银行的份额 \(\Delta_t\)。

## 3. 一阶条件

下面的 F 编号系统遵循 MMB 实现作为 `implementation_cross_check`；论文正文不可见的公式在提升审核状态前应与在线补充附录核对。

**家庭**

- **(F1) 消费边际效用**（`needs_review`）：

\[
U_{c,t}=(C_t-hC_{t-1})^{-1}-\beta h(C_{t+1}-hC_t)^{-1}.
\]

- **(F2) 随机折现因子**（`needs_review`）：

\[
\Lambda_t=\frac{U_{c,t}}{U_{c,t-1}}.
\]

- **(F3) 存款 Euler 方程**（`needs_review`）：

\[
1=\beta R^d_{t+1}\Lambda_{t+1}.
\]

- **(F4) 劳动供给**（`needs_review`）：

\[
L_t^\varphi=U_{c,t}w_t.
\]

**中间品企业**

- **(F5) 总实际资本回报**（`needs_review`）：

\[
R^k_t=\frac{P^m_t\alpha Y^m_t/K_{t-1}+\xi_tQ_t(1-\delta)}{Q_{t-1}}.
\]

- **(F6) 生产函数**（`needs_review`）：

\[
Y^m_t=a_t(\xi_tK_{t-1})^\alpha L_t^{1-\alpha}.
\]

- **(F7) 实际工资**（`needs_review`）：

\[
w_t=P^m_t(1-\alpha)\frac{Y^m_t}{L_t}.
\]

**资本品生产者**

- **(F8) Tobin's Q / 投资调整条件**（`needs_review`）：

\[
\frac{1}{Q_t}=1-\frac{\eta_i}{2}\left(\frac{I_t}{I_{t-1}}-1\right)^2
-\eta_i\left(\frac{I_t}{I_{t-1}}-1\right)\frac{I_t}{I_{t-1}}
+\beta\Lambda_{t+1}\eta_i\left(\frac{I_{t+1}}{I_t}-1\right)
\left(\frac{I_{t+1}}{I_t}\right)^2\frac{Q_t}{Q_{t+1}}.
\]

- **(F9) 资本积累**（`needs_review`）：

\[
K_t=(1-\delta)\xi_tK_{t-1}
+\left[1-\frac{\eta_i}{2}\left(\frac{I_t}{I_{t-1}}-1\right)^2\right]I_t.
\]

**零售定价**

- **(F10) 零售产出与价格分散**（`needs_review`）：

\[
Y^m_t=Y_t Dis_t.
\]

- **(F11) 价格分散度演化**（`needs_review`）：

\[
Dis_t=\gamma Dis_{t-1}\pi_t^\epsilon
+(1-\gamma)\left(\frac{1-\gamma\pi_t^{\epsilon-1}}{1-\gamma}\right)^{-\epsilon/(1-\epsilon)}.
\]

- **(F12) Calvo 辅助变量 F**（`needs_review`）：

\[
F_t=Y_tP^m_t+\beta\gamma\Lambda_{t+1}\pi_{t+1}^{\epsilon}F_{t+1}.
\]

- **(F13) Calvo 辅助变量 Z**（`needs_review`）：

\[
Z_t=Y_t+\beta\gamma\Lambda_{t+1}\pi_{t+1}^{\epsilon-1}Z_{t+1}.
\]

- **(F14) 最优重置价格/通胀**（`needs_review`）：

\[
\pi^\ast_t=\frac{\epsilon}{\epsilon-1}\frac{F_t}{Z_t}\pi_t.
\]

- **(F15) 价格指数**（`needs_review`）：

\[
\pi_t^{1-\epsilon}=\gamma+(1-\gamma)(\pi^\ast_t)^{1-\epsilon}.
\]

**金融中介**

- **(F16) 私人索取权影子价值**（`needs_review`）：

\[
\nu^k_t=\beta\Lambda_{t+1}\left[(R^k_{t+1}-R^d_{t+1})(1-\theta)
+\theta\frac{Q_{t+1}K_{t+1}}{Q_tK_t}\nu^k_{t+1}\right].
\]

- **(F17) 银行持有债券的影子价值**（`needs_review`）：

\[
\nu^b_t=\beta\Lambda_{t+1}\left[(R^b_{t+1}-R^d_{t+1})(1-\theta)
+\theta\frac{B_{t+1}}{B_t}\nu^b_{t+1}\right].
\]

- **(F18) 净值影子价值**（`needs_review`）：

\[
\nu^n_t=\beta\Lambda_{t+1}\left[R^d_{t+1}(1-\theta)
+\theta\frac{N_{t+1}}{N_t}\nu^n_{t+1}\right].
\]

- **(F19) 私人索取权与债券的组合套利**（`needs_review`）：

\[
\nu^k_t=\nu^b_t.
\]

- **(F20) 内生杠杆率**（`needs_review`）：

\[
\Phi_t=\frac{\nu^n_t}{\lambda-\nu^k_t}.
\]

- **(F21) 总银行净值**（`needs_review`）：

\[
N_t=\theta\left[(R^p_t-R^d_t)\Phi_{t-1}+R^d_t\right]N_{t-1}
+\chi N_{t-1}.
\]

- **(F22) 银行资产负债表恒等式**：

\[
N_t+D_t=Q_tK_t+B_t.
\]

- **(F23) 银行组合规模**：

\[
portf^B_t=Q_tK_t+B_t.
\]

- **(F24) 私人索取权组合份额**：

\[
Q_tK_t=\Omega_t\Phi_tN_t.
\]

- **(F25) 银行持有债券组合份额**：

\[
B_t=(1-\Omega_t)\Phi_tN_t.
\]

- **(F26) 预期私人索取权回报**：

\[
ER^k_t=R^k_{t+1}.
\]

- **(F27) 预期银行持有债券回报**：

\[
ER^b_t=R^b_{t+1}.
\]

- **(F28) 私人信贷利差**：

\[
prem_t=R^k_{t+1}-R^d_{t+1}.
\]

- **(F29) 银行持有债券利差**：

\[
prem2_t=R^b_{t+1}-R^d_{t+1}.
\]

- **(F30) 组合回报**：

\[
R^p_t=R^k_t\Omega_{t-1}+R^b_t(1-\Omega_{t-1}).
\]

## 4. 市场出清与恒等式

- **(F31) 银行持有政府债务的预算约束**：

\[
B_t=R^b_tB_{t-1}+G_t-T_t.
\]

- **(F32) 政府购买水平**：

\[
G_t=\bar{G}\,g_t.
\]

- **(F33) MMB 银行融资实现中的税收**：

\[
T_t=\bar{T}.
\]

- **(F34) 政府支出份额**：

\[
Gy_t=\frac{G_t}{\bar{Y}}.
\]

- **(F35) 总资源约束**：

\[
Y_t=C_t+G_t+I_t.
\]

- **(F36) Fisher 关系**：

\[
i_{t-1}=R^d_t\pi_t.
\]

- **(F37) Taylor 规则**：

\[
i_t=i_{t-1}^{\rho_i}
\left[\bar{i}\,\pi_t^{\kappa_\pi}\left(\frac{Y_t}{Y_{t-1}}\right)^{\kappa_y}\right]^{1-\rho_i}
\exp(-\varepsilon^i_t)\quad\text{in gross-rate form}.
\]

论文印刷的规则为净利率加法形式：

\[
r^n_t=(1-\rho_r)\left[r^n+\kappa_\pi(\pi_t-\bar{\pi})+\kappa_y\log(y_t/y_{t-1})\right]
+\rho_r r^n_{t-1}+\varepsilon_{r,t}.
\]

## 5. 外生过程

- **(F38) TFP 冲击**：

\[
\log a_t=\rho_a\log a_{t-1}-\varepsilon^a_t.
\]

- **(F39) 资本质量冲击**：

\[
\log \xi_t=\rho_\xi\log \xi_{t-1}-\varepsilon^\xi_t.
\]

- **(F40) 政府购买冲击**：

\[
\log g_t=\rho_g\log g_{t-1}+\varepsilon^g_t.
\]

论文还讨论未预期与提前四期公布的政府支出新闻冲击、对资本质量冲击的财政反应、银行转移，以及 MMF 与银行融资份额：

\[
\log(\tilde{g}_t/\bar{g})=\rho_g\log(\tilde{g}_{t-1}/\bar{g})+\varepsilon^u_{g,t}+\varepsilon^a_{g,t-4},
\]

\[
n_{g,t}=\varkappa(\xi_{t-l}-\xi),
\]

\[
s^b_t=\Delta_t(g_t-\tau_t+n_{g,t}-\tilde{n}_{g,t})+(1+r^{b,B}_t)s^b_{t-1}.
\]

这些政策变体是论文侧方程，但并非全部在归档 Rep-MMB `.mod` 闭合中启用。

## 6. 稳态解

未执行运行时验证。实现交叉检查包含闭式校准顺序。令 \(\bar{\pi}=1\)、\(\bar{\xi}=1\)、\(\bar{a}=1\)、\(\bar{Q}=1\)、\(\overline{Dis}=1\)、\(\bar{\Lambda}=1\)。

1. 存款回报与政策利率：

\[
\bar{R}^d=\frac{1}{\beta},\qquad \bar{i}=\bar{R}^d.
\]

2. 利差与中介回报：

\[
\overline{prem}=\overline{prem2}=0.01/4,\qquad
\bar{R}^k=\bar{R}^b=\bar{R}^p=\bar{R}^d+\overline{prem}.
\]

3. 边际成本与银行影子价值：

\[
\bar{P}^m=\frac{\epsilon-1}{\epsilon},
\]

\[
\bar{\nu}^n=\frac{(1-\theta)\beta\bar{R}^d}{1-\theta\beta},\qquad
\bar{\nu}^k=\bar{\nu}^b=\frac{(1-\theta)\beta(\bar{R}^k-\bar{R}^d)}{1-\theta\beta}.
\]

4. 激励约束与进入转移参数：

\[
\lambda=\bar{\nu}^k+\frac{\bar{\nu}^n}{\bar{\Phi}},
\]

\[
\chi=1-\theta\left[(\bar{R}^k-\bar{R}^d)\bar{\Phi}+\bar{R}^d\right].
\]

5. 实体侧比率：

\[
\bar{w}=\left[\alpha^\alpha(1-\alpha)^{1-\alpha}\bar{P}^m(\bar{R}^k-1+\delta)^{-\alpha}\right]^{1/(1-\alpha)},
\]

\[
\frac{\bar{Y}}{\bar{K}}=\frac{\bar{R}^k-1+\delta}{\alpha\bar{P}^m},
\qquad
\frac{\bar{L}}{\bar{K}}=\left(\frac{\bar{Y}}{\bar{K}}\right)^{1/(1-\alpha)}.
\]

6. 支出与存量：

\[
\bar{I}/\bar{Y}=\delta(\bar{Y}/\bar{K})^{-1},\qquad
\bar{C}/\bar{Y}=1-\bar{G}/\bar{Y}-\bar{I}/\bar{Y}.
\]

在实现校准中，\(\bar{G}/\bar{Y}=0.2\)、\(\bar{B}/\bar{Y}=2.4\)、\(\bar{\Phi}=4\)：

\[
\bar{B}=2.4\bar{Y},\qquad
\bar{N}=\frac{\bar{K}+\bar{B}}{\bar{\Phi}},\qquad
\bar{D}=\bar{K}+\bar{B}-\bar{N}.
\]

7. Calvo 辅助变量与财政变量：

\[
\bar{Z}=\frac{\bar{Y}}{1-\beta\gamma},\qquad
\bar{F}=\bar{P}^m\bar{Z},\qquad
\bar{T}=(\bar{R}^b-1)\bar{B}+\bar{G}.
\]

稳态顺序为 `draft_extracted`；在审核前应与在线补充附录核对。

## 7. 时序与形式约定

- **资本时序**：\(K_t\) 为期末存量。生产与资本回报使用 \(K_{t-1}\)。
- **资本质量**：\(\xi_t\) 缩放期初有效资本，并出现在生产函数和资本积累中。
- **银行资产负债表时序**：银行净值 \(N_t\)、债务/存款 \(D_t\)、组合规模和份额是期末对象。组合回报 \(R^p_t\) 使用滞后组合份额 \(\Omega_{t-1}\)。
- **政府债务时序**：归档的银行融资模型对银行持有债务使用 \(B_t=R^b_tB_{t-1}+G_t-T_t\)。
- **利率**：`.mod` 在 `exp()` 变量中使用总利率。部分论文方程以净利率印刷；相关位置两者均记录。
- **形式**：非线性/对数水平 Dynare 实现，不是 `model(linear)`。`.mod` 中变量为对数，冲击作为 AR(1) 对数偏离直接书写。
- **验证**：按指令未运行 Dynare。

## 8. 变量与参数对照表

| 类别 | 符号 / ASCII | 含义 | 主要方程 |
|---|---|---|---|
| 内生 | `Y` | 最终产出 \(Y_t\) | (F35) |
| 内生 | `Ym` | 中间品产出 \(Y^m_t\) | (F6), (F10) |
| 内生 | `L` | 劳动 \(L_t\) | (F4) |
| 内生 | `w` | 实际工资 \(w_t\) | (F7) |
| 内生 | `C` | 消费 \(C_t\) | (F1), (F35) |
| 内生 | `U_c` | 边际效用 \(U_{c,t}\) | (F1) |
| 内生 | `Lambda` | 随机折现因子 \(\Lambda_t\) | (F2) |
| 内生 | `I` | 投资 \(I_t\) | (F8), (F35) |
| 内生 | `K` | 资本存量 \(K_t\) | (F9) |
| 内生 | `Q` | 资本价格 \(Q_t\) | (F8) |
| 内生 | `a` | 技术 \(a_t\) | (F38) |
| 内生 | `ksi` | 资本质量 \(\xi_t\) | (F39) |
| 内生 | `Pm` | 实际边际成本/中间品价格 \(P^m_t\) | (F5), (F7) |
| 内生 | `infl` | 通胀 \(\pi_t\) | (F15), (F36) |
| 内生 | `inflstar` | 最优重置通胀 \(\pi^\ast_t\) | (F14) |
| 内生 | `F`, `Z` | 定价辅助变量 | (F12), (F13) |
| 内生 | `Dis` | 价格分散度 | (F11) |
| 内生 | `Rd`, `i` | 存款利率与名义政策利率 | (F3), (F36), (F37) |
| 内生 | `Rk`, `Rb`, `Rp` | 资本、银行债券、组合回报 | (F5), (F30), (F31) |
| 内生 | `ERk`, `ERb` | 预期资产回报 | (F26), (F27) |
| 内生 | `prem`, `prem2` | 私人与公共信贷利差 | (F28), (F29) |
| 内生 | `Phi` | 银行杠杆 | (F20) |
| 内生 | `portf_B`, `N`, `Om`, `D`, `B` | 银行资产负债表变量 | (F21)-(F25), (F31) |
| 内生 | `nu_k`, `nu_b`, `nu_n` | 银行影子价值 | (F16)-(F18) |
| 内生 | `G`, `g`, `Gy`, `T` | 财政变量 | (F31)-(F34), (F40) |
| 外生 | `e_ksi`, `e_g`, `e_i`, `e_a`, `e_n` | 资本质量、支出、政策、TFP 和净值创新 | (F37)-(F40)；`e_n` 已声明但未在显示的 model 块中启用 |
| 参数 | `beta`, `hh`, `delta`, `varphi`, `eta_i`, `alpha`, `gam`, `epsilon` | 偏好、资本、生产与 Calvo 参数 | -- |
| 参数 | `kappa_pi`, `kappa_y`, `rho_i` | Taylor 规则系数 | (F37) |
| 参数 | `G_over_Y`, `B_over_Y`, `theta`, `lambda`, `chi`, `Phi_ss` | 财政比率与银行摩擦参数 | (F16)-(F25), 稳态 |
| 参数 | `rho_ksi`, `rho_a`, `rho_g`, `sigma_*` | 冲击持续性与标准差 | (F38)-(F40) |

方程数：本初稿归档方程表含 40 条 F 编号条件。公式质量：`needs_review`，因为本地来源集中缺少在线补充附录。
