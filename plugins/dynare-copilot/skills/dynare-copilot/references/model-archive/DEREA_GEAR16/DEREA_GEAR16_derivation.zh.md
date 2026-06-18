# DEREA_GEAR16 - 推导（最优化问题 + 一阶条件）

> MMB 模型 `DEREA_GEAR16` 的第一轮归档抽取。
> 状态：`needs_review`。
> 运行验证：未执行。

来源：Gadatsch, Niklas; Hauzenberger, Klemens; Stahler, Nikolai (2016), "Fiscal policy during the crisis: A look on Germany and the Euro area with GEAR", *Economic Modelling*, 52, 997-1016, DOI `10.1016/j.econmod.2015.10.038`。

主要 Markdown 来源：`raw/mmb_mineru/runs/derea_gear16__fiscal_policy_during_the_crisis_a_look_on_germany_and_the_euro_area_with__0124e095/full.md`。

原始 PDF 溯源：`raw/mmb_papers/Fiscal policy during the crisis- A look on Germany and the Euro area with GEAR.pdf`。

重要限制：论文侧 Markdown 明确说明，大多数推导、一阶条件、方程汇总以及完整稳态推导并未印在正文中，而是 available upon request。因此，下列方程是基于可见模型章节的第一轮结构化抽取；凡缺少方程汇总支持的位置均标为 `needs_review`。

## 1. 模型概述

- **模型**：GEAR，三地区 DSGE 模型，包含德国（`a`）、欧元区其余地区（`b`）和世界其余地区（`c`）。
- **用途**：估计型财政政策分析，用于研究全球金融危机期间及之后德国和欧元区财政政策的影响。
- **地区结构**：德国和欧元区其余地区构成货币联盟，共用一个货币当局；世界其余地区由一个紧凑 VAR 模块表示。
- **`a` 与 `b` 地区主体**：优化型家庭、rule-of-thumb 家庭、垄断竞争企业、财政当局和共同货币当局。生产模块包含私人资本、私人就业、公共资本和公共就业。
- **主要摩擦/特征**：外部习惯、优化型与 RoT 家庭、非自愿失业、垄断竞争、Rotemberg 价格与工资调整成本、公共资本和公共就业生产率外溢、扭曲性税收、公共债务、财政反馈规则、国际贸易、净国外资产风险溢价和共同货币政策。
- **形式**：大型非线性 DSGE 模型，并用 Dynare 估计。实现交叉检查使用水平变量和非线性方程；部分世界其余地区 VAR 变量为相对稳态的对数/水平偏离。
- **本文档范围**：在来源明确给出时，显式写出国家 `a` 的方程；国家 `b` 将上标从 `a` 改为 `b` 即为对应结构；国家 `c` 为来源中的 VAR 模块。

## 2. 主体的最优化问题

### 2.1 最终品组合商

国家 `a` 的代表性最终品企业购买差异化中间品，并选择投入数量，使名义收入减去中间品成本最大：

```math
\max_{\{\tilde y_t^a(z):z\in[0,1]\}}
P_t^{a,a}Y_t^a-\int_0^1 P_t^{a,a}(z)\tilde y_t^a(z)\,dz .
\tag{F1}
```

CES 聚合器为：

```math
Y_t^a=\left(\int_0^1 \tilde y_t^a(z)^{(\theta_{a,t}-1)/\theta_{a,t}}\,dz\right)^{\theta_{a,t}/(\theta_{a,t}-1)} .
\tag{F2}
```

### 2.2 中间品企业

中间品企业 `z` 使用私人资本、私人就业、公共资本、公共就业、本地与全球技术以及固定成本进行生产：

```math
y_t^a(z)=e^{\varepsilon_t^{A_a}}e^{\varepsilon_t^{A_g}}
\zeta_a\left(K_t^{G,a}\right)^{\eta^{K^G,a}}
\left(N_t^{G,a}\right)^{\eta^{N^G,a}}
\left[K_{t-1}^a(z)\right]^{\alpha_a}
\left[N_t^{P,a}(z)\right]^{1-\alpha_a}
-\Omega_a .
\tag{F3 needs_review}
```

`needs_review`：来源中公共投入生产率乘子附近的 OCR 明显受损。预期结构应为乘法形式，实现交叉检查中使用 `yG_a_t = z_a*kG_a_t^eta_kG_a*nG_a_t^eta_nG_a` 乘以私人生产函数。

价格制定者选择自身价格路径，并受到需求与 Rotemberg 调整成本约束：

```math
\max_{\{P_{t+s}^{a,a}(z)\}}
E_t\sum_{s=0}^{\infty}\beta_a^s
\frac{\lambda_{o,t+s}^a}{\lambda_{o,t}^a}
\left[
\left(\frac{P_{t+s}^{a,a}(z)}{P_{t+s}^a}-mc_{t+s}^a\right)y_{t+s}^a(z)
-adj_t^{p,a}Y_{t+s}^a
\right].
\tag{F4}
```

Rotemberg 价格调整项为：

```math
adj_t^{P,a}
=\frac{\gamma_a}{2}
\left(
\frac{P_{t+s}^{a,a}(z)}
{(\pi_{t+s-1}^{a,a})^{\xi_a}(\bar\pi^{a,a})^{1-\xi_a}P_{t+s-1}^{a,a}(z)}
-1
\right)^2
\frac{P_{t+s}^{a,a}}{P_{t+s}^a}.
\tag{F5 needs_review}
```

`needs_review`：该调整成本方程位于价格制定问题中，同时出现 `t` 与 `t+s`；精确时点需用不可得的 equation summary 检查。

### 2.3 家庭

每个地区有优化型家庭（`o`）与 rule-of-thumb 家庭（`r`）。类型 `x` 家庭的效用含外部习惯与劳动参与成本：

```math
U(C_{x,t+s}^a,N_{x,t+s}^a)
=e^{\varepsilon_{t+s}^{\beta_a}}
\left[
\frac{(C_{x,t+s}^a-h_a\bar C_{x,t+s-1}^a)^{1-\sigma_a}}{1-\sigma_a}
-\kappa_a^w e^{\varepsilon_{t+s}^{N_a}}
\int_0^1
\frac{N_{x,t+s}^a(\mathfrak h_x)^{1+\varphi_a}}{1+\varphi_a}
d\mathfrak h_x
\right].
\tag{F6}
```

国家 `a` 的私人消费聚合器为：

```math
C_{x,t}^a=\left[
(n_a^a)^{1/\eta_a}(C_{x,t}^{a,a})^{(\eta_a-1)/\eta_a}
+(n_b^a e^{\varepsilon_t^{b,a}})^{1/\eta_a}(C_{x,t}^{a,b})^{(\eta_a-1)/\eta_a}
+(n_c^a)^{1/\eta_a}(C_{x,t}^{a,c})^{(\eta_a-1)/\eta_a}
\right]^{\eta_a/(\eta_a-1)} .
\tag{F7}
```

RoT 家庭消费当期税后劳动收入、失业救济和转移：

```math
0=(1+\tau_t^{c,a})C_{r,t}^a
-(1-\tau_t^{w,a})(w_t^aN_t^{P,a}+w_t^{G,a}N_t^{G,a})
-UB^a(L_{r,t}^a-N_t^a)-TR_{r,t}^a .
\tag{F8}
```

优化型家庭在大型跨期预算约束下选择消费、投资、私人债券、外国债券、政府债券和资本。正文公式有 OCR 损坏，但含义为：

```math
0=(1+\tau_t^{c,a})C_{o,t}^a+I_{o,t}^a+B_{o,t}^{a,a}
+\sum_{j=b,c}S_t^{a,j}B_{o,t}^{a,j}+B_{o,t}^{G,a}+T_{o,t}^a
-\text{after-tax labor income}
-\text{benefits and transfers}
-\text{real bond payoffs}
-\text{after-tax capital income}
-D_{o,t}^a .
\tag{F9 needs_review}
```

优化者持有资本的运动方程为：

```math
k_{o,t}^a=(1-\delta_a)k_{o,t-1}^a+
\left[
I_{o,t}^a-I_{o,t}^a\frac{\psi_a^i}{2}
\left(\frac{I_{o,t}^a}{I_{o,t-1}^a}-1\right)^2
\right]e^{\varepsilon_t^{I_a}} .
\tag{F10}
```

### 2.4 劳动聚合机构与工会

劳动聚合机构在给定工资支出的约束下选择差异化劳动服务：

```math
\max_{\{N_t^{P,a}(\mathfrak h):\mathfrak h\in[0,1]\}}
N_t^{P,a}
=\left(\int_0^1(N_t^{P,a}(\mathfrak h))^{(\theta_{a,t}^w-1)/\theta_{a,t}^w}\,d\mathfrak h\right)^{\theta_{a,t}^w/(\theta_{a,t}^w-1)} .
\tag{F11}
```

论文仅概述工会工资设定问题；详细 FOC 被说明位于 equation summary 中。来源表明工资设定包含两类家庭的 Rotemberg 工资调整与工会谈判。

```math
\text{Union chooses } W_t^a(\mathfrak h)\text{ taking labor demand, labor supply, wage adjustment costs, and household weights as constraints.}
\tag{F12 needs_review}
```

## 3. 一阶条件

### 3.1 最终品需求与价格指数

最终品组合商给出对品种 `z` 的需求：

```math
\tilde y_t^a(z)=\left(\frac{P_t^{a,a}(z)}{P_t^{a,a}}\right)^{-\theta_{a,t}}Y_t^a .
\tag{F13}
```

对应的 PPI 聚合器为：

```math
P_t^{a,a}=\left(\int_0^1 P_t^{a,a}(z)^{1-\theta_{a,t}}\,dz\right)^{1/(1-\theta_{a,t})}.
\tag{F14}
```

### 3.2 企业成本最小化

来源给出国家 `a` 的资本-劳动比条件：

```math
\frac{r_{k,t}^a}{w_t^a(1+\tau_t^{sc,a})}
=\frac{N_t^{P,a}(z)}{K_{t-1}^a(z)}\frac{\alpha_a}{1-\alpha_a}.
\tag{F15}
```

以 CPI 平减的实际边际成本为：

```math
mc_t^a=
\frac{
(r_{k,t}^a)^{\alpha_a}
\left(w_t^a(1+\tau_t^{sc,a})\right)^{1-\alpha_a}
}{
e^{\varepsilon_t^{A_a}}e^{\varepsilon_t^{A_g}}
\zeta_a(K_t^{G,a})^{\eta^{K^G,a}}(N_t^{G,a})^{\eta^{N^G,a}}
\alpha_a^{\alpha_a}(1-\alpha_a)^{1-\alpha_a}
}.
\tag{F16 needs_review}
```

`needs_review`：OCR 损坏影响分母指数和公共投入乘子的位置。该数学关系需对照 equation summary 或 PDF 公式检查。

### 3.3 家庭 FOC

论文说明优化者关于私人债券、公共债券、物理资本投资和边际效用的欧拉方程被放入附录/equation summary。实现交叉检查显示国家 `a` 的国内私人债券欧拉关系为：

```math
\lambda_{o,t}^a\pi_{t+1}^a
=\beta_a e^{\varepsilon_t^{RP,EA}}(1+i_t^a)\lambda_{o,t+1}^a .
\tag{F17 implementation_cross_check needs_review}
```

实现交叉检查显示对应的政府债券欧拉方程为：

```math
\lambda_{o,t}^a\pi_{t+1}^a
=\beta_a(1+i_t^{G,a})\lambda_{o,t+1}^a .
\tag{F18 implementation_cross_check needs_review}
```

优化型与 RoT 消费边际效用由打印出的效用式和实现交叉检查给出：

```math
\lambda_{x,t}^a
=\frac{e^{\varepsilon_t^{\beta_a}}(C_{x,t}^a-h_aC_{x,t-1}^a)^{-\sigma_a}}{1+\tau_t^{c,a}},
\quad x\in\{o,r\}.
\tag{F19 implementation_cross_check needs_review}
```

优化者资本回报欧拉方程在实现交叉检查中为：

```math
1=\beta_a\frac{\lambda_{o,t+1}^a}{\lambda_{o,t}^a}
\frac{1+Rk_{t+1}^a}{\pi_{t+1}^a}.
\tag{F20 implementation_cross_check needs_review}
```

有效资本回报在实现交叉检查中为：

```math
Rk_t^a
=\frac{\pi_t^a\left(q_t^a(1-\delta_a)+(1-\tau_t^{k,a})rk_t^a+\tau_t^{k,a}\delta_a\right)}{q_{t-1}^a}-1 .
\tag{F21 implementation_cross_check needs_review}
```

投资调整成本隐含的 Tobin's Q 条件在实现交叉检查中为：

```math
\begin{aligned}
1={}&q_t^a\left[1-\frac{\upsilon_a}{2}\left(\frac{I_{o,t}^a}{I_{o,t-1}^a}-1\right)^2
-\upsilon_a\frac{I_{o,t}^a}{I_{o,t-1}^a}\left(\frac{I_{o,t}^a}{I_{o,t-1}^a}-1\right)\right]e^{\varepsilon_t^{I_a}}\\
&+\beta_a\frac{\lambda_{o,t+1}^a}{\lambda_{o,t}^a}q_{t+1}^a
\upsilon_a\left(\frac{I_{o,t+1}^a}{I_{o,t}^a}\right)^2
\left(\frac{I_{o,t+1}^a}{I_{o,t}^a}-1\right)e^{\varepsilon_{t+1}^{I_a}} .
\end{aligned}
\tag{F22 implementation_cross_check needs_review}
```

`needs_review`：F17-F22 未印在正文中；此处仅记录与现有 MMB 实现的覆盖关系。

### 3.4 劳动供给与工资设定

来源印出的家庭劳动参与条件为：

```math
\lambda_{x,t}^a
\left[
(1-\tau_t^{w,a})(w_t^aN_t^{P,a}+w_t^{G,a}N_t^{G,a})
+UB^a(L_{x,t}^a-N_t^a)
\right]
=N_t^a\kappa_a^w e^{\varepsilon_t^{N_a}}(L_{x,t}^a)^{\varphi_a},
\quad x\in\{o,r\}.
\tag{F23}
```

劳动聚合机构给出品种劳动需求：

```math
N_t^{P,a}(\mathfrak h)
=\left(\frac{W_t^a(\mathfrak h)}{W_t^a}\right)^{-\theta_{a,t}^w}N_t^{P,a}.
\tag{F24}
```

论文未印出工资设定 FOC，标记为：

```math
\text{Rotemberg union wage FOC linking } \pi_{w,t}^a,\,\lambda_{o,t}^a,\,\lambda_{r,t}^a,\,N_t^{P,a},\,L_{o,t}^a,\,L_{r,t}^a,\text{ and wage-adjustment costs.}
\tag{F25 needs_review}
```

### 3.5 价格设定

论文没有完整推导 Rotemberg 价格设定 FOC。实现交叉检查使用：

```math
\begin{aligned}
&(1-\theta_{a,t})+\theta_{a,t}mc_t^a(pr_{aa,t})^{-1}
+\beta_a\frac{\lambda_{o,t+1}^a}{\lambda_{o,t}}
\upsilon_p^a
\left(\frac{\pi_{aa,t+1}}{\pi_{aa,t}^{\xi_a^p}\pi_{ss}^{1-\xi_a^p}}-1\right)
\frac{\pi_{aa,t+1}^2}{\pi_{t+1}^a y_t^a}
\frac{y_{t+1}^a}{\pi_{aa,t}^{\xi_a^p}\pi_{ss}^{1-\xi_a^p}}\\
&\quad=
\upsilon_p^a
\left(\frac{\pi_{aa,t}}{\pi_{aa,t-1}^{\xi_a^p}\pi_{ss}^{1-\xi_a^p}}-1\right)
\frac{\pi_{aa,t}}{\pi_{aa,t-1}^{\xi_a^p}\pi_{ss}^{1-\xi_a^p}} .
\end{aligned}
\tag{F26 implementation_cross_check needs_review}
```

`needs_review`：精确的来源级价格 Phillips/Rotemberg 方程必须对照 equation summary 核查；上式仅记录可用实现形状。

## 4. 市场出清与总量恒等式

家庭总量变量由优化者和 RoT 家庭加总：

```math
X_t^a=(1-\mu^a)X_{o,t}^a+\mu^aX_{r,t}^a,
\quad X\in\{C,L\}.
\tag{F27}
```

对仅属于优化者的存量和流量，来源说明：

```math
X_t^a=(1-\mu^a)X_{o,t}^a,
\quad X\in\{K,I,B^{G}\}.
\tag{F28}
```

总就业、劳动人口和失业率为：

```math
N_t^a=N_t^{P,a}+N_t^{G,a},\qquad
L_t^a=(1-\mu^a)L_{o,t}^a+\mu^aL_{r,t}^a,\qquad
UR_t^a=\frac{L_t^a-N_t^a}{L_t^a}.
\tag{F29}
```

政府债务演化为：

```math
B_t^{G,a}=\frac{1+i_{t-1}^{G,a}}{\pi_t^a}B_{t-1}^{G,a}+PD_t^a.
\tag{F30}
```

政府初级支出为：

```math
\begin{aligned}
G_t^a={}&R_t^{a,a}(C_t^{G,a}+I_t^{G,a})
+UB^a\left[\mu^a(L_{r,t}^a-N_t^a)+(1-\mu^a)(L_{o,t}^a-N_t^a)\right]\\
&+(1+\tau_t^{sc,a})N_t^{G,a}w_t^{G,a}+TR_t^a .
\end{aligned}
\tag{F31}
```

初级收入为：

```math
\begin{aligned}
Rev_t^a={}&(\tau_t^{w,a}+\tau_t^{sc,a})(w_t^aN_t^{P,a}+w_t^{G,a}N_t^{G,a})
+\tau_t^{k,a}(r_t^{k,a}-\delta_a)K_{t-1}^a\\
&+\tau_t^{c,a}C_t^a+T_{o,t}^a .
\end{aligned}
\tag{F32}
```

公共资本和公共品生产率为：

```math
K_t^{G,a}=(1-\delta_a^G)K_{t-1}^{G,a}+I_t^{G,a},
\qquad
yG_t^a=z_a(K_t^{G,a})^{\eta_k^G,a}(N_t^{G,a})^{\eta_n^G,a}.
\tag{F33 needs_review}
```

两类家庭之间的转移分配为：

```math
\bar\mu^a\left(\frac{TR_{o,t}^a}{\overline{TR}_o^a}-1\right)
=(1-\bar\mu^a)\left(\frac{TR_{r,t}^a}{\overline{TR}_r^a}-1\right).
\tag{F34}
```

国家 `a` 所生产商品的市场出清为：

```math
\begin{aligned}
Y_t^a={}&C_t^{G,a}+I_t^{G,a}+C_t^{a,a}+I_t^{a,a}
+\frac{n_b^a}{n_a^b}(C_t^{b,a}+I_t^{b,a})\\
&+\frac{n_c^a}{n_a^c}(C_t^{c,a}+I_t^{c,a})+ADJ_t^a .
\end{aligned}
\tag{F35}
```

国民账户 GDP 将公共就业工资成本加入私人部门产出：

```math
GDP_t^a=Y_t^a+\frac{(1+\tau_t^{sc,a})w_t^{G,a}n_t^{G,a}}{R_t^{a,a}}.
\tag{F36}
```

世界其余地区对国家 `j` 商品的需求近似为：

```math
C_t^{c,j}+I_t^{c,j}
=n_j^cR_t^{c,j}(g^{c,c}+g^{c,i})e^{\varepsilon_t^{c,j}}Y_t^c,
\quad j\in\{a,b\}.
\tag{F37}
```

国家 `a` 的净国外资产为：

```math
\begin{aligned}
nfa_t^a={}&rer_t^{a,c}B_t^{a,c}+B_t^a\\
={}&(1+i_{t-1}^{a,c})\frac{rer_t^{a,c}B_{t-1}^{a,c}}{\pi_t^c}
+(1+i_{t-1}^{b,a})\frac{B_{t-1}^a}{\pi_t^a}
+R_t^{a,a}Y_t^a-C_t^a-I_t^a-C_t^{G,a}-I_t^{G,a}.
\end{aligned}
\tag{F38}
```

国家 `b` 的净国外资产类似：

```math
\begin{aligned}
nfa_t^b={}&rer_t^{b,c}B_t^{b,c}+rer_t^{b,a}B_t^{b,a}\\
={}&(1+i_{t-1}^{b,c})\frac{rer_t^{b,c}B_{t-1}^{b,c}}{\pi_t^c}
+(1+i_{t-1}^{b,a})\frac{rer_t^{b,a}B_{t-1}^{b,a}}{\pi_t^a}
+R_t^{b,b}Y_t^b-C_t^b-I_t^b-C_t^{G,b}-I_t^{G,b}.
\end{aligned}
\tag{F39}
```

世界其余地区债券头寸的债券市场出清为：

```math
B_t^c=-\left(\frac{\mathcal P^a}{\mathcal P^c}B_t^{a,c}
+\frac{\mathcal P^b}{\mathcal P^c}B_t^{b,c}\right).
\tag{F40}
```

相对实际汇率和名义汇率变化满足：

```math
rer_t^{c,a}=\frac{1}{rer_t^{a,c}},
\qquad
rer_t^{b,c}=\frac{rer_t^{b,a}}{rer_t^{c,a}},
\qquad
\Delta S_t^{a,c}=\frac{\pi_t^a(rer_t^{a,c}/rer_{t-1}^{a,c})}{\pi_t^c}.
\tag{F41 needs_review}
```

`needs_review`：来源行存在重复/畸形的 `rer` 记号，需用 equation summary 检查。

## 5. 外生过程

来源描述了 41 个结构冲击。除财政与货币政策冲击外，所有非政策冲击均服从 AR(1) 过程：

```math
\varepsilon_t^{X,i}=\rho^X\varepsilon_{t-1}^{X,i}+\nu_t^X,\quad i\in\{a,b\}.
\tag{F42}
```

加成冲击在变换后的加成中服从 AR(1)：

```math
\frac{\theta_{a,t}}{\theta_{a,t}-1}
=\rho_{\theta_a}\frac{\theta_{a,t-1}}{\theta_{a,t-1}-1}
+(1-\rho_{\theta_a})\frac{\bar\theta_a}{\bar\theta_a-1}
+\nu_t^{\theta_a}.
\tag{F43 needs_review}
```

财政支出工具服从对数规则：

```math
\begin{aligned}
\log\left(\frac{X_t}{\bar X}\right)
={}&\rho^{X,a}\log\left(\frac{X_{t-1}}{\bar X}\right)
-\xi^{X,B^{G,a},a}\log\left(\frac{B_{t-1}^{G,a}}{\bar B^{G,a}}\right)
-\xi^{X,y,a}\log\left(\frac{Y_{t-1}^a}{\bar Y^a}\right)\\
&+\psi^{X,a}\nu_t^{X,a}+(1-\psi^{X,a})\nu_{t-1}^{X,a},
\end{aligned}
\tag{F44}
```

其中：

```math
X\in\{C^{G,a},I^{G,a},TR^a,w^{G,a}\}.
\tag{F45}
```

财政收入/就业工具服从水平偏离规则：

```math
\begin{aligned}
X_t-\bar X
={}&\rho^{X,a}(X_{t-1}-\bar X)
+\xi^{X,B^{G,a},a}\log\left(\frac{B_{t-1}^{G,a}}{\bar B^{G,a}}\right)
+\xi^{X,y,a}\log\left(\frac{Y_{t-1}^a}{\bar Y^a}\right)\\
&+\psi^{X,a}\nu_t^{X,a}+(1-\psi^{X,a})\nu_{t-1}^{X,a},
\end{aligned}
\tag{F46}
```

其中：

```math
X\in\{\tau^{w,a},\tau^{sc,a},\tau^{k,a},T_o^a,N^{G,a}\}.
\tag{F47 needs_review}
```

货币当局设定一个欧元区政策利率：

```math
\begin{aligned}
\log\left(\frac{1+i_t^{EA}}{1+\bar i^{EA}}\right)
={}&\rho_i^a\log\left(\frac{1+i_{t-1}^{EA}}{1+\bar i^{EA}}\right)
+(1-\rho_i^a)\phi_\pi^{EA}
\left[
s\log\left(\frac{\pi_t^a}{\bar\pi^a}\right)
+(1-s)\log\left(\frac{\pi_t^b}{\bar\pi^b}\right)
\right]\\
&+(1-\rho_i^a)\phi_y^{EA}
\left[
s\log\left(\frac{Y_t^a}{\bar Y^a}\right)
+(1-s)\log\left(\frac{Y_t^b}{\bar Y^b}\right)
\right]
+\nu_t^{M^{EA}} .
\end{aligned}
\tag{F48}
```

政策利率与国家利率之间的关系为：

```math
\log\left(\frac{1+i_t^{EA}}{1+\bar i^{EA}}\right)
=s\log\left(\frac{1+i_t^a}{1+\bar i^a}\right)
+(1-s)\log\left(\frac{1+i_t^b}{1+\bar i^b}\right).
\tag{F49}
```

国际风险溢价满足：

```math
1+i_t^{i,j}
=(1+i_t^j)
\left[
1-\phi\left(
\exp\left(\frac{rer_t^{i,j}B_t^{i,j}}{R_t^{i,i}Y_t^i}
-\frac{\bar B^{i,j}}{\bar R^{i,i}\bar Y^i}\right)-1
\right)
\right],
\quad i\ne j.
\tag{F50 needs_review}
```

`needs_review`：来源中稳态分母附近存在 OCR 损坏，并且 `Y^j`/`Y^i` 呈现不一致。

世界其余地区 SVAR 为：

```math
\begin{pmatrix}
\hat Y_t^c\\
\hat\pi_t^c\\
\hat i_t^c\\
\varepsilon_t^{A_g}
\end{pmatrix}
=
A
\begin{pmatrix}
\hat Y_{t-1}^c\\
\hat\pi_{t-1}^c\\
\hat i_{t-1}^c\\
\varepsilon_{t-1}^{A_g}
\end{pmatrix}
+C
\begin{pmatrix}
\nu_t^{Y,c}\\
\nu_t^{\pi,c}\\
\nu_t^{i,c}\\
\nu_t^{A_g}
\end{pmatrix}.
\tag{F51}
```

## 6. 稳态求解

来源说明模型具有解析求解的非对称稳态，但完整推导 available upon request，未印在 Markdown 中。因此本节记录来源支持的稳态限制，而不是完整可执行的 `steady_state_model`。

稳态下，政策冲击和非政策创新为零：

```math
\nu^X=0,\qquad \varepsilon^X=0 \text{ for stationary AR(1) shocks}.
\tag{F52 needs_review}
```

资本积累方程给出由投资决定的私人资本：

```math
\bar I_o^a=\delta_a\bar k_o^a
\quad\text{when } \varepsilon^{I_a}=0 \text{ and adjustment costs are zero}.
\tag{F53 needs_review}
```

公共资本由公共投资决定：

```math
\bar I^{G,a}=\delta_a^G\bar K^{G,a}.
\tag{F54 needs_review}
```

只有当财政规则满足来源所述至少一个债务反馈系数为正时，政府债务才是稳定的：

```math
\exists X:\xi^{X,B^{G,a},a}>0 .
\tag{F55 needs_review}
```

长期相对价格和通胀目标嵌入 CPI/PPI 模块、财政规则和 Taylor 规则。来源中的表 1 和表 2 包含校准参数与目标稳态值，但 OCR Markdown 主要将这些表作为图像保存，因此本条目没有抽取数值稳态校准。

## 7. 时序与形式约定

- **资本时点**：私人生产使用 `K_{t-1}`，运动方程决定 `K_t`；公共资本采用同样的期末存量约定。
- **政府债务时点**：`B_t^{G,a}` 是期末实际政府债务存量；预算方程使用 `B_{t-1}^{G,a}` 和 `i_{t-1}^{G,a}`。
- **家庭**：优化者持有国内私人债券、外国债券、政府债券和物理资本；RoT 家庭不储蓄也不借款。
- **货币联盟**：国家 `a` 与 `b` 共用一个政策利率，但有各自国家利率，并由人口加权关系 (F49) 连接。
- **世界其余地区**：在本文版本中，`c` 是 VAR 模块，而不是完整微观基础 DSGE 地区。
- **价格/工资调整**：来源文字说明 Rotemberg 调整成本并允许向滞后通胀和稳态通胀指数化。精确工资 FOC 需要不可得的 equation summary。
- **模型形式**：非线性水平模型，带有若干对数偏离的政策与 VAR 过程；不是纯 `model(linear)` 推导。
- **实现交叉检查**：`.agents/skills/dynare-copilot/references/examples/DEREA_GEAR16_rep.mod` 确认了总体变量覆盖、国家 `a`/国家 `b` 对称性、财政冲击和非线性时点。它未被用作论文侧数学证据。

## 8. 变量与参数对照表

### 内生变量与方程覆盖

| 类别 | 符号 / ASCII 提示 | 含义 | 主要方程 |
|---|---|---|---|
| 内生 | `y_a_t`, `y_b_t` | 德国/欧元区其余地区私人部门产出 | (F3), (F35) |
| 内生 | `GDP_a_t`, `GDP_b_t` | 含公共工资支出的国民账户 GDP | (F36) |
| 内生 | `c_o_a_t`, `c_r_a_t`, `c_a_t` | 优化者、RoT 与总消费 | (F7), (F8), (F27) |
| 内生 | `in_o_a_t`, `in_a_t` | 优化者与总私人投资 | (F10), (F22), (F28) |
| 内生 | `k_o_a_t`, `k_a_t` | 优化者与总私人资本 | (F10), (F28) |
| 内生 | `lambda_o_a_t`, `lambda_r_a_t` | 消费边际效用 | (F19) |
| 内生 | `nP_a_t`, `nG_a_t`, `n_a_t` | 私人、公共与总就业 | (F29) |
| 内生 | `l_o_a_t`, `l_r_a_t`, `l_a_t`, `ur_a_t` | 分类型劳动人口、总劳动人口与失业率 | (F23), (F29) |
| 内生 | `wr_a_t`, `wrG_a_t`, `pi_w_a_t` | 私人工资、公共工资和工资通胀 | (F12), (F25) |
| 内生 | `rk_a_t`, `Rk_a_t`, `q_a_t` | 租金率、有效资本回报和 Tobin's Q | (F15), (F20), (F21), (F22) |
| 内生 | `mcr_a_t` | 实际边际成本 | (F16), (F26) |
| 内生 | `pi_a_t`, `pi_aa_t` | CPI 与生产者通胀 | (F14), (F26), (F48) |
| 内生 | `pr_aa_t`, `pr_ab_t`, `pr_ac_t` | 相对价格 | (F7), (F35), (F41) |
| 内生 | `cG_a_t`, `inG_a_t`, `TR_a_t`, `T_a_t` | 财政消费、公共投资、转移、一次总付税 | (F31), (F34), (F44), (F46) |
| 内生 | `tauw_a_t`, `tausc_a_t`, `tauk_a_t`, `tauc_a_t` | 劳动税、社保缴费、资本税和消费税 | (F32), (F46), (F47) |
| 内生 | `BG_a_t`, `i_Ga_t` | 政府债务和政府债券利率 | (F18), (F30) |
| 内生 | `kG_a_t`, `yG_a_t` | 公共资本和公共品生产率项 | (F33) |
| 内生 | `i_policy_t`, `i_a_t`, `i_b_t` | 共同政策利率和国家利率 | (F48), (F49) |
| 内生 | `B_ac_t`, `B_bc_t`, `B_ba_t`, `nfa_a_t`, `nfa_b_t`, `nfa_c_t` | 国际债券头寸与净国外资产 | (F38), (F39), (F40), (F50) |
| 内生 | `rer_ba_t`, `rer_ca_t`, `rer_bc_t`, `Del_S_ac_t`, `Del_S_bc_t` | 实际汇率和名义汇率变化 | (F41) |
| 内生 | `y_c_var_t`, `pi_c_var_t`, `i_c_var_t`, `y_c_t` | 世界其余地区 VAR 变量 | (F51) |

### 外生冲击

| 类别 | ASCII 提示 | 含义 | 主要方程 |
|---|---|---|---|
| 外生 | `nua_a`, `nub_a`, `eps_z_g` | 国内与全球技术创新 | (F42), (F51) |
| 外生 | `nua_etheta`, `nub_etheta` | 价格加成创新 | (F43) |
| 外生 | `nua_ethetaw`, `nub_ethetaw` | 工资加成创新 | (F42) |
| 外生 | `nua_eb`, `nub_eb` | 偏好创新 | (F6), (F42) |
| 外生 | `nua_en`, `nub_en` | 劳动供给创新 | (F23), (F42) |
| 外生 | `nua_ein`, `nub_ein` | 私人投资创新 | (F10), (F22), (F42) |
| 外生 | `nua_erp`, `nub_erp` | 风险溢价/UIP 创新 | (F17), (F42), (F50) |
| 外生 | `nua_ecG`, `nub_ecG` | 公共消费冲击 | (F44) |
| 外生 | `nua_einG`, `nub_einG` | 公共投资冲击 | (F44), (F54) |
| 外生 | `nua_eTR`, `nub_eTR`, `nua_eT`, `nub_eT` | 转移和一次总付税冲击 | (F44), (F46) |
| 外生 | `nua_etauw`, `nub_etauw`, `nua_etausc`, `nub_etausc`, `nua_etauc`, `nub_etauc`, `nua_etauk`, `nub_etauk` | 税率与社保缴费冲击 | (F46), (F47) |
| 外生 | `nua_enG`, `nub_enG`, `nua_emg`, `nub_emg` | 公共就业与公共工资冲击 | (F44), (F46) |
| 外生 | `nua_RoW`, `nub_RoW`, `nua_RoE`, `nub_RoE` | 外需/贸易偏好冲击 | (F37), (F42) |
| 外生 | `eps_y_c`, `eps_i_c`, `eps_pi_c` | 世界其余地区 VAR 冲击 | (F51) |
| 外生 | `nua_eM` | 货币政策冲击 | (F48) |

### 参数

| 类别 | ASCII 提示 | 含义 | 来源状态 |
|---|---|---|---|
| 参数 | `mu_a`, `mu_b` | RoT 家庭比例 | 来源与实现交叉检查 |
| 参数 | `betta_a`, `betta_b` | 主观贴现因子 | 来源与实现交叉检查 |
| 参数 | `delta_a`, `delta_b` | 私人资本折旧 | 来源与实现交叉检查 |
| 参数 | `sigma_a`, `sigma_b` | 消费曲率 | 来源与实现交叉检查 |
| 参数 | `hab_a`, `hab_b` | 外部习惯 | 来源与实现交叉检查 |
| 参数 | `rho_a`, `rho_b` / `alpha_a`, `alpha_b` | 私人资本份额 | 来源与实现交叉检查命名不同 |
| 参数 | `eta_kG_a`, `eta_nG_a` | 公共资本/公共就业生产率弹性 | 来源与实现交叉检查 |
| 参数 | `upsilon_a`, `upsilon_b` | 私人投资调整成本 | 来源与实现交叉检查 |
| 参数 | `upsilon_p_a`, `upsilon_w_a` | 价格和工资 Rotemberg 成本 | 来源与实现交叉检查 |
| 参数 | `theta_a`, `thetaw_a` | 商品和劳动替代/加成参数 | 来源与实现交叉检查 |
| 参数 | `xip_a`, `xiw_a` | 价格和工资指数化 | 来源与实现交叉检查 |
| 参数 | `tauw_a`, `tausc_a`, `tauk_a`, `tauc_a` | 稳态税率/社保缴费率 | 来源与实现交叉检查 |
| 参数 | `rho_*`, `xi_*`, `psi_*` | 财政规则中的持续性、债务/产出反馈和预期参数 | 来源与实现交叉检查 |
| 参数 | `rho_a_i`, `phi_a_pi`, `phi_a_y` | Taylor 规则平滑与反应系数 | 来源与实现交叉检查 |
| 参数 | `phi` | 国际债券风险溢价参数 | 来源与实现交叉检查 |
| 参数 | `a11...a44`, `c11...c44` | 世界其余地区 VAR 系数 | 来源与实现交叉检查 |

第一轮方程覆盖按设计仍不完整，因为论文没有印出完整 equation summary、FOC 或稳态推导。该条目应保持 `needs_review`，直到纳入这些来源侧文件或有针对性的 PDF 检查。
