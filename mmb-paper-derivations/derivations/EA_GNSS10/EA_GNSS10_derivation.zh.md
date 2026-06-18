# EA_GNSS10 - 推导（最优化问题与一阶条件）

> 私有档案一稿。状态：`needs_review`。来源：Gerali, Neri, Sessa, and Signoretti (2010), "Credit and Banking in a DSGE Model of the Euro Area", DOI `10.1111/j.1538-4616.2010.00331.x`。

## 1. 模型概述

- **模型**：欧元区 DSGE 模型，包含耐心家庭、非耐心家庭、企业家、垄断竞争银行、资本品生产者、零售商、工会和遵循泰勒规则的中央银行。
- **档案模型编号**：`EA_GNSS10`。
- **核心金融机制**：非耐心家庭和企业家以抵押品向银行借款；银行用存款和银行资本为贷款融资，设置具有黏性的零售利率，并在资本/资产比率偏离目标时承担成本。
- **形式**：论文说明模型在稳态附近进行对数线性化。下列方程在有用处保留论文的非线性约束和可实现的均衡形式，但在完成源级公式审查之前，本一稿应作为对数线性模型条目处理。
- **实现交叉核对**：`.agents/skills/dynare-copilot/references/examples/EA_GNSS10_rep.mod` 确认了实现中的模块和冲击名称，但不作为论文侧数学来源。

## 2. 主体的最优化问题

### 耐心家庭

耐心家庭选择消费、住房、存款和劳动：

$$
\max_{\{c_t^P,h_t^P,d_t^P,l_t^P\}} E_0\sum_{t=0}^{\infty}\beta_P^t
\left[(1-a^P)\varepsilon_t^z\log(c_t^P-a^P c_{t-1}^P)+\varepsilon_t^h\log h_t^P-\frac{(l_t^P)^{1+\phi}}{1+\phi}\right]
$$

约束为

$$
c_t^P+q_t^h(h_t^P-h_{t-1}^P)+d_t^P
=w_t^P l_t^P+\frac{(1+r_{t-1}^d)d_{t-1}^P}{\pi_t}+t_t^P .
$$

### 非耐心家庭

非耐心家庭选择消费、住房、银行借款和劳动：

$$
\max_{\{c_t^I,h_t^I,b_t^I,l_t^I\}} E_0\sum_{t=0}^{\infty}\beta_I^t
\left[(1-a^I)\varepsilon_t^z\log(c_t^I-a^I c_{t-1}^I)+\varepsilon_t^h\log h_t^I-\frac{(l_t^I)^{1+\phi}}{1+\phi}\right]
$$

预算约束为

$$
c_t^I+q_t^h(h_t^I-h_{t-1}^I)+\frac{(1+r_{t-1}^{bH})b_{t-1}^I}{\pi_t}
=w_t^I l_t^I+b_t^I+t_t^I
$$

抵押约束为

$$
(1+r_t^{bH})b_t^I \le m_t^I E_t[q_{t+1}^h h_t^I\pi_{t+1}] .
$$

### 企业家

企业家选择消费、资本、银行借款、资本利用率和两类劳动投入：

$$
\max_{\{c_t^E,k_t^E,b_t^E,u_t,l_t^{E,P},l_t^{E,I}\}} E_0\sum_{t=0}^{\infty}\beta_E^t
\log(c_t^E-a^E c_{t-1}^E)
$$

约束为

$$
\begin{aligned}
c_t^E+w_t^P l_t^{E,P}+w_t^I l_t^{E,I}+\frac{(1+r_{t-1}^{bE})b_{t-1}^E}{\pi_t}
+q_t^k k_t^E+\psi(u_t)k_{t-1}^E
=\frac{y_t^E}{x_t}+b_t^E+q_t^k(1-\delta)k_{t-1}^E ,
\end{aligned}
$$

生产技术为

$$
y_t^E=A_t^E(u_t k_{t-1}^E)^\alpha\left[(l_t^{E,P})^\mu(l_t^{E,I})^{1-\mu}\right]^{1-\alpha},
$$

企业贷款抵押约束为

$$
(1+r_t^{bE})b_t^E \le m_t^E E_t[q_{t+1}^k\pi_{t+1}(1-\delta)k_t^E] .
$$

### 银行

批发银行在资产负债表恒等式下选择贷款和存款：

$$
B_t=D_t+K_t^b .
$$

给定银行资本后，批发银行问题化为

$$
\max_{\{B_t,D_t\}} R_t^bB_t-R_t^dD_t-\frac{\kappa_{Kb}}{2}\left(\frac{K_t^b}{B_t}-\nu^b\right)^2K_t^b .
$$

零售贷款部门在 CES 贷款需求和二次利率调整成本下选择家庭和企业家贷款利率。零售存款部门在 CES 存款需求和二次利率调整成本下选择存款利率。

### 资本品生产者、零售商和工会

资本品生产者以投资调整成本将最终品转化为有效资本。零售商设置差异化商品价格，面对 Rotemberg 型调整成本并按滞后通胀和稳态通胀指数化。耐心家庭和非耐心家庭的工会设置差异化工资，面对工资调整成本和指数化。

## 3. 一阶条件（FOC）

- **(F1) 耐心家庭消费边际效用**：

$$
\lambda_t^P=(1-a^P)\varepsilon_t^z(c_t^P-a^P c_{t-1}^P)^{-1}.
$$

- **(F2) 耐心家庭存款欧拉方程**：

$$
\lambda_t^P=\beta_P E_t\left[\lambda_{t+1}^P\frac{1+r_t^d}{\pi_{t+1}}\right].
$$

- **(F3) 耐心家庭住房需求**：

$$
\frac{\varepsilon_t^h}{h_t^P}-\lambda_t^P q_t^h+\beta_P E_t[\lambda_{t+1}^P q_{t+1}^h]=0.
$$

- **(F4) 非耐心家庭借款欧拉楔子**：

$$
\lambda_t^I-\beta_I E_t\left[\lambda_{t+1}^I\frac{1+r_t^{bH}}{\pi_{t+1}}\right]=s_t^I(1+r_t^{bH}).
$$

- **(F5) 带抵押价值的非耐心家庭住房需求**：

$$
\frac{\varepsilon_t^h}{h_t^I}-\lambda_t^I q_t^h+\beta_I E_t[\lambda_{t+1}^I q_{t+1}^h]+s_t^I m_t^I E_t[q_{t+1}^h\pi_{t+1}]=0.
$$

- **(F6) 企业家资本需求**：

$$
\lambda_t^E q_t^k=s_t^E m_t^E E_t[q_{t+1}^k\pi_{t+1}(1-\delta)]
+\beta_E E_t\left[\lambda_{t+1}^E\left(q_{t+1}^k(1-\delta)+r_{t+1}^k u_{t+1}-\psi(u_{t+1})\right)\right].
$$

- **(F7) 企业家信贷需求楔子**：

$$
\lambda_t^E-s_t^E(1+r_t^{bE})
=\beta_E E_t\left[\lambda_{t+1}^E\frac{1+r_t^{bE}}{\pi_{t+1}}\right].
$$

- **(F8) 资本利用率**：

$$
r_t^k=\psi'(u_t),\qquad \psi(u_t)=\xi_1(u_t-1)+\frac{\xi_2}{2}(u_t-1)^2 .
$$

- **(F9) 企业家劳动需求**：

$$
w_t^P=\mu(1-\alpha)\frac{y_t^E}{x_t l_t^{E,P}},
\qquad
w_t^I=(1-\mu)(1-\alpha)\frac{y_t^E}{x_t l_t^{E,I}}.
$$

- **(F10) 批发银行利差和杠杆条件**：

$$
S_t^W\equiv R_t^b-r_t=-\kappa_{Kb}\left(\frac{K_t^b}{B_t}-\nu^b\right)\left(\frac{K_t^b}{B_t}\right)^2 .
$$

- **(F11) 黏性零售贷款利率设定**，借款人类型 $s\in\{H,E\}$：

$$
\begin{aligned}
0=&1-\varepsilon_t^{bs}+\varepsilon_t^{bs}\frac{R_t^b}{r_t^{bs}}
-\kappa_{bs}\left(\frac{r_t^{bs}}{r_{t-1}^{bs}}-1\right)\frac{r_t^{bs}}{r_{t-1}^{bs}}\\
&+\beta_P E_t\left[\frac{\lambda_{t+1}^P}{\lambda_t^P}\kappa_{bs}
\left(\frac{r_{t+1}^{bs}}{r_t^{bs}}-1\right)
\left(\frac{r_{t+1}^{bs}}{r_t^{bs}}\right)^2
\frac{b_{t+1}^s}{b_t^s}\right].
\end{aligned}
$$

- **(F12) 黏性存款利率设定**：

$$
\begin{aligned}
0=&-1+\varepsilon_t^d-\varepsilon_t^d\frac{r_t}{r_t^d}
-\kappa_d\left(\frac{r_t^d}{r_{t-1}^d}-1\right)\frac{r_t^d}{r_{t-1}^d}\\
&+\beta_P E_t\left[\frac{\lambda_{t+1}^P}{\lambda_t^P}\kappa_d
\left(\frac{r_{t+1}^d}{r_t^d}-1\right)
\left(\frac{r_{t+1}^d}{r_t^d}\right)^2
\frac{d_{t+1}}{d_t}\right].
\end{aligned}
$$

- **(F13) 资本积累和 Tobin's $q$**：

$$
k_t=(1-\delta)k_{t-1}+\left[1-\frac{\kappa_i}{2}\left(\frac{i_t\varepsilon_t^{qk}}{i_{t-1}}-1\right)^2\right]i_t ,
$$

以及资本品生产者对应的 $q_t^k$ 一阶条件。OCR/来源方程在提升审查状态前需要公式核对：`needs_review`。

- **(F14) 价格和工资菲利普斯曲线**：

$$
\text{Rotemberg price FOC and two wage-union FOCs with indexation to lagged and steady-state inflation.}
$$

论文和实现都包含这些模块，但精确系数归一化需要源级公式审查：`needs_review`。

## 4. 市场出清与总量恒等式

- **(F15) 家庭抵押约束**：

$$
(1+r_t^{bH})b_t^I=m_t^I E_t[q_{t+1}^h h_t^I\pi_{t+1}].
$$

- **(F16) 企业家抵押约束**：

$$
(1+r_t^{bE})b_t^E=m_t^E E_t[q_{t+1}^k\pi_{t+1}(1-\delta)k_t^E].
$$

- **(F17) 银行资产负债表和银行资本积累**：

$$
B_t=B_t^H+B_t^E=D_t+K_t^b,\qquad
\pi_tK_t^b=(1-\delta^b)K_{t-1}^b+j_{t-1}^b .
$$

- **(F18) 银行利润**：

$$
j_t^b=r_t^{bH}b_t^H+r_t^{bE}b_t^E-r_t^d d_t
-\frac{\kappa_{Kb}}{2}\left(\frac{K_t^b}{B_t}-\nu^b\right)^2K_t^b-Adj_t^B .
$$

- **(F19) 总量变量**：

$$
C_t=c_t^P+c_t^I+c_t^E,\qquad
B_t^H=b_t^I,\qquad B_t^E=b_t^E,\qquad D_t=d_t^P .
$$

- **(F20) 劳动、住房和资本加总**：

$$
l_t^{E,P}=l_t^P,\qquad l_t^{E,I}=l_t^I,\qquad
\bar h=h_t^P+h_t^I,\qquad K_t=k_t^E .
$$

- **(F21) 商品市场资源约束**：

$$
y_t=c_t+q_t^k[k_t-(1-\delta)k_{t-1}]+k_{t-1}\psi(u_t)+\delta^b\frac{K_{t-1}^b}{\pi_t}+Adj_t .
$$

- **(F22) 货币政策规则**：

$$
(1+r_t)=(1+r)^{1-\phi_R}(1+r_{t-1})^{\phi_R}
\left(\frac{\pi_t}{\pi}\right)^{\phi_\pi(1-\phi_R)}
\left(\frac{y_t}{y_{t-1}}\right)^{\phi_y(1-\phi_R)}
\varepsilon_t^r .
$$

## 5. 外生过程

论文给出持续性冲击的一般 AR(1) 形式：

- **(F23) 一般持续性过程**：

$$
\varepsilon_t=(1-\rho_\varepsilon)\bar{\varepsilon}+\rho_\varepsilon\varepsilon_{t-1}+\eta_t^\varepsilon .
$$

实现交叉核对确认 13 个创新：消费偏好、技术、住房偏好、家庭 LTV、企业家 LTV、存款 markdown、家庭贷款 markup、企业贷款 markup、投资效率、货币政策、价格 markup、工资 markup、银行资本/资产负债表冲击。

## 6. 稳态求解

论文估计的是围绕确定性稳态的对数线性模型。来源中一稿稳态锚点包括：

- **(F24) 贴现和利率锚点**：

$$
\beta_P=0.9943,\qquad \beta_I=\beta_E=0.975,\qquad \pi=1.
$$

- **(F25) 抵押和银行锚点**：

$$
m^I=0.7,\qquad m^E=0.35,\qquad \nu^b=0.09 .
$$

- **(F26) 生产和折旧锚点**：

$$
\alpha=0.25,\qquad \delta=0.025,\qquad \phi=1.
$$

- **(F27) markup/markdown 锚点**：

$$
\varepsilon^d=-1.46,\qquad \varepsilon^{bH}\approx 2.79,\qquad \varepsilon^{bE}\approx 3.12,\qquad
\varepsilon^y=6,\qquad \varepsilon^l=5 .
$$

完整的非线性稳态递归没有在本一稿档案条目中进行源级核对。未执行运行时验证。

## 7. 时序与形式约定

- 论文中的模型在稳态附近对数线性化。
- 贷款和存款是一期金融工具。上一期债务和存款的偿还由当期通胀调整。
- 日期 $t$ 选择的住房通过预期下一期实际住房价值约束非耐心家庭债务。
- 企业家资本 $k_t^E$ 在日期 $t$ 选择，并通过预期下一期扣除折旧后的资本价值作为抵押品。
- 银行资本 $K_t^b$ 是资产负债表中的预定状态变量，由留存银行利润演化。
- 在 MMB 实现交叉核对中，模型变量通常按对数存储，方程以 `exp(...)` 形式书写；这是实现约定，不是独立来源证据。

## 8. 变量与参数对照表

| 类别 | 符号 / 实现名称 | 含义 | 主要方程 |
|---|---|---|---|
| 内生变量 | $c^P,c^I,c^E$ / `c_p,c_i,c_e` | 耐心家庭、非耐心家庭、企业家消费 | (F1), (F4), (F7), (F19) |
| 内生变量 | $h^P,h^I$ / `h_p,h_i` | 住房存量 | (F3), (F5), (F15), (F20) |
| 内生变量 | $d^P,D$ / `d_p,D,d_b` | 存款 | (F2), (F12), (F17), (F19) |
| 内生变量 | $b^I,b^E,B^H,B^E,B$ / `b_i,b_ee,BH,BE,B` | 家庭和企业贷款 | (F4), (F7), (F15), (F16), (F17) |
| 内生变量 | $k^E,K,q^k,u,r^k$ / `k_e,K,q_k,u,r_k` | 资本、Tobin's q、利用率、资本租金率 | (F6), (F8), (F13), (F20), (F21) |
| 内生变量 | $l^P,l^I,l^{E,P},l^{E,I}$ / `l_p,l_i,l_pd,l_id` | 劳动供给和需求 | (F9), (F14), (F20) |
| 内生变量 | $w^P,w^I,\pi^{wP},\pi^{wI}$ / `w_p,w_i,pie_wp,pie_wi` | 工资和工资通胀 | (F9), (F14) |
| 内生变量 | $r^d,r^{bH},r^{bE},R^b,r$ / `r_d,r_bh,r_be,R_b,r_ib` | 存款、贷款、批发和政策利率 | (F10), (F11), (F12), (F22) |
| 内生变量 | $K^b,j^b$ / `K_b,j_B` | 银行资本和银行利润 | (F17), (F18) |
| 内生变量 | $y^E,Y,C,x,\pi$ / `y_e,Y,C,x,pie` | 生产、产出、总消费、markup、通胀 | (F14), (F19), (F21), (F22) |
| 外生变量 | `e_z,e_A_e,e_j,e_mi,e_me,e_mk_d,e_mk_bh,e_mk_be,e_qk,e_r_ib,e_y,e_l,e_eps_K_b` | 偏好、技术、抵押、利差、投资、政策、markup 和银行资本创新 | (F23) |
| 参数 | $\beta_P,\beta_I,\beta_E,\alpha,\delta,\phi,\mu$ | 偏好和技术 | (F1)-(F9), (F24), (F26) |
| 参数 | $m^I,m^E,\nu^b,\delta^b,\kappa_{Kb}$ | 抵押和银行资本参数 | (F10), (F15)-(F18), (F25) |
| 参数 | $\kappa_i,\kappa_d,\kappa_{bH},\kappa_{bE},\kappa_p,\kappa_w$ | 调整成本 | (F11)-(F14), (F21) |
| 参数 | $\varepsilon^d,\varepsilon^{bH},\varepsilon^{bE},\varepsilon^y,\varepsilon^l$ | 银行、商品和劳动弹性 | (F11), (F12), (F14), (F27) |
| 参数 | $\rho_\cdot,\sigma_\cdot$ | 冲击持续性和标准差 | (F23) |
