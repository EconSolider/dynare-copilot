# NK_GSSZ17 - 金融危机期间的通胀动态

来源信息：`NK_GSSZ17`，Gilchrist、Schoenle、Sim 和 Zakrajsek (2017)，《Inflation Dynamics during the Financial Crisis》，American Economic Review 107(3): 785-823，DOI `10.1257/aer.20150248`。源 Markdown：`raw/mmb_mineru/runs/nk_gssz17__inflation_dynamics_during_the_financial_crisis__85a7350a/full.md`。已检查原始 PDF 路径：`raw/mmb_papers/Inflation Dynamics during the Financial Crisis.pdf`。MinerU run id：`85a7350a-a6d9-40e9-8065-b8a924aa1887`。

这是第一版归档推导。未执行运行时验证。若论文公式来自 MinerU OCR 且符号明显受损，均标为 `needs_review`。

## 1. Model Overview

- **模型**：带金融摩擦、深度习惯、Rotemberg 价格调整成本和昂贵外部股权融资的新凯恩斯顾客市场模型。
- **目标**：解释为什么金融状况弱的企业会在危机中涨价，而金融状况强的企业会降价，以及为什么顾客市场和金融摩擦会削弱通缩压力。
- **主体与模块**：具有商品特定外部习惯的家庭；在特质成本冲击实现前定价的垄断竞争企业；昂贵股权发行；总生产率、需求、金融和货币政策冲击；Taylor 型货币当局。
- **形式**：论文先给出非线性模型，再使用 Phillips 曲线等局部/对数线性均衡对象。Rep-MMB 实现交叉检查是非线性 Dynare `model` 块并做一阶求解，不是 `model(linear)`。
- **基准模拟重点**：带金融摩擦和名义刚性的同质企业模型；论文还扩展到异质经营成本。

## 2. Optimization Problems

### 2.1 家庭

家庭 $j$ 最大化关于习惯调整消费组合和劳动的预期贴现效用：

$$
E_t \sum_{s=0}^{\infty} \beta^s U(x_{t+s}^j-\psi_{t+s},h_{t+s}^j),
\qquad 0<\beta<1.
\tag{F1} % (F1)
$$

需求冲击 $\psi_t$ 通过改变当期消费边际效用影响最终需求。商品特定消费/习惯聚合器为：

$$
x_t^j =
\left[
\int_0^1
\left(\frac{c_{it}^j}{s_{i,t-1}^{\theta}}\right)^{1-\frac{1}{\eta}} di
\right]^{\frac{1}{1-\frac{1}{\eta}}},
\qquad \theta<0,\ \eta>0.
\tag{F2} % (F2)
$$

外部的商品特定习惯存量演化为：

$$
s_{it}=\rho s_{i,t-1}+(1-\rho)c_{it},
\qquad 0<\rho<1.
\tag{F3} % (F3)
$$

对差异化商品的成本最小化给出品种 $i$ 的需求：

$$
c_{it}^j =
\left(\frac{p_{it}}{\tilde p_t}\right)^{-\eta}
s_{i,t-1}^{\theta(1-\eta)}x_t^j.
\tag{F4} % (F4)
$$

外部性调整后的综合价格指数为：

$$
\tilde p_t =
\left[
\int_0^1
\left(p_{it}s_{i,t-1}^{\theta}\right)^{1-\eta}di
\right]^{\frac{1}{1-\eta}}.
\tag{F5} % (F5)
$$

### 2.2 企业

企业 $i$ 使用劳动、总技术和特质成本风险生产差异化商品，并承担固定经营成本：

$$
y_{it}=\left(\frac{A_t}{a_{it}}h_{it}\right)^{\alpha}-\phi,
\qquad 0<\alpha\le 1,\ \phi>0.
\tag{F6} % (F6)
$$

企业最大化实际股利流的预期现值：

$$
E_0\sum_{t=0}^{\infty}m_{0,t}d_{it}.
\tag{F7} % (F7)
$$

带单位股权稀释成本 $\varphi_t$ 的资金流约束为：

$$
0=p_{it}c_{it}-w_t h_{it}-d_{it}
+\varphi_t\min\{0,d_{it}\}.
\tag{F8} % (F8)
$$

企业选择股利、劳动、消费/销售、价格和习惯存量，并受生产、资金流、需求和习惯积累约束。紧凑的拉格朗日式为：

$$
\begin{aligned}
\mathcal L
=E_0\sum_{t=0}^{\infty}m_{0,t}\{&
d_{it}
+\kappa_{it}[(A_t h_{it}/a_{it})^{\alpha}-\phi-c_{it}]\\
&+\xi_{it}[p_{it}c_{it}-w_t h_{it}-d_{it}+\varphi_t\min\{0,d_{it}\}]\\
&+\nu_{it}[(p_{it}/\tilde p_t)^{-\eta}s_{i,t-1}^{\theta(1-\eta)}x_t-c_{it}]\\
&+\lambda_{it}[\rho s_{i,t-1}+(1-\rho)c_{it}-s_{it}]\}.
\end{aligned}
\tag{F9} % (F9)
$$

### 2.3 货币当局

货币当局按带平滑项、通胀缺口和产出缺口反应的规则设定名义利率：

$$
r_t=(1+r_{t-1})^{\tau_r}
\left[
(1+\bar r)
\left(\frac{\pi_t}{\pi^{\ast}}\right)^{\tau_\pi}
\left(\frac{y_t}{y_t^{\ast}}\right)^{\tau_y}
\right]^{1-\tau_r}-1.
\tag{F10} % (F10)
$$

`needs_review`：论文公式 (29) 在括号中似乎是乘法形式，但 MinerU OCR 将换行项连接得不清楚。Rep-MMB 实现使用乘法的毛利率规则。

## 3. First-Order Conditions

### 3.1 企业条件

内部资金影子价值来自股利/股权发行选择：

$$
\xi_{it}=
\begin{cases}
1, & d_{it}\ge 0,\\
1/(1-\varphi_t), & d_{it}<0.
\end{cases}
\tag{F11} % (F11)
$$

劳动/生产条件为：

$$
\kappa_{it}
=\xi_{it}a_{it}
\left(\frac{w_t}{\alpha A_t}\right)
(c_{it}+\phi)^{\frac{1-\alpha}{\alpha}}.
\tag{F12} % (F12)
$$

预期边际销售价值满足：

$$
E_t^a[\nu_{it}]
=E_t^a[\xi_{it}]p_{it}
-E_t^a[\kappa_{it}]
+(1-\rho)E_t^a[\lambda_{it}].
\tag{F13} % (F13)
$$

习惯/顾客基础的预期价值满足：

$$
E_t^a[\lambda_{it}]
=\rho E_t^a[m_{t,t+1}\lambda_{i,t+1}]
+\theta(1-\eta)E_t\left[
m_{t,t+1}E_{t+1}^a[\nu_{i,t+1}]
\left(\frac{c_{i,t+1}}{s_{it}}\right)
\right].
\tag{F14} % (F14)
$$

最优相对价格条件为：

$$
0=E_t^a[\xi_{it}]
-\eta\frac{E_t^a[\nu_{it}]}{p_{it}}.
\tag{F15} % (F15)
$$

### 3.2 融资触发点与加成

股权发行触发点为：

$$
a_t^E=
\frac{c_t}{(c_t+\phi)^{1/\alpha}}\frac{A_t}{w_t}.
\tag{F16} % (F16)
$$

实现的内部资金影子价值可按触发点写为：

$$
\xi_{it}=
\begin{cases}
1, & a_{it}\le a_t^E,\\
1/(1-\varphi_t), & a_{it}>a_t^E.
\end{cases}
\tag{F17} % (F17)
$$

令 $z_t^E=\sigma^{-1}(\log a_t^E+0.5\sigma^2)$，预期影子价值为：

$$
E_t^a[\xi_{it}]
=1+\left[\frac{\varphi_t}{1-\varphi_t}\right]
[1-\Phi(z_t^E)]\ge 1.
\tag{F18} % (F18)
$$

无顾客习惯时，定价规则为：

$$
p_{it}
=\frac{\eta}{\eta-1}
\frac{E_t^a[\xi_{it}a_{it}]}{E_t^a[\xi_{it}]}
\left[
\frac{w_t}{\alpha A_t}(c_{it}+\phi)^{\frac{1-\alpha}{\alpha}}
\right].
\tag{F19} % (F19)
$$

金融调整后的加成为：

$$
\tilde\mu_t
=
\frac{1}{
\frac{E_t^a[\xi_{it}a_{it}]}{E_t^a[\xi_{it}]}
\left[
\frac{w_t}{\alpha A_t}(c_{it}+\phi)^{\frac{1-\alpha}{\alpha}}
\right]
}.
\tag{F20} % (F20)
$$

存在顾客市场时，边际销售价值相对于内部资金价值满足：

$$
\frac{E_t^a[\nu_{it}]}{E_t^a[\xi_{it}]}
=
\frac{\tilde\mu_t-1}{\tilde\mu_t}
+(1-\rho)\frac{E_t^a[\lambda_{it}]}{E_t^a[\xi_{it}]}.
\tag{F21} % (F21)
$$

令 $g_t\equiv c_t/s_{t-1}=(s_t/s_{t-1}-\rho)/(1-\rho)$，并定义增长调整贴现因子：

$$
\tilde\beta_{t,s+1}
\equiv
m_{s,s+1}g_{s+1}
\prod_{j=1}^{s-t}
[\rho+\theta(1-\eta)(1-\rho)g_{t+j}]m_{t+j-1,t+j}.
\tag{F22} % (F22)
$$

边际销售价值的前向解为：

$$
\frac{E_t^a[\nu_{it}]}{E_t^a[\xi_{it}]}
=
\frac{\tilde\mu_t-1}{\tilde\mu_t}
+\chi E_t\left[
\sum_{s=t+1}^{\infty}
\tilde\beta_{t,s}
\frac{E_s^a[\xi_{is}]}{E_t^a[\xi_{it}]}
\left(\frac{\tilde\mu_s-1}{\tilde\mu_s}\right)
\right],
\quad
\chi=(1-\rho)\theta(1-\eta)>0.
\tag{F23} % (F23)
$$

`needs_review`：论文公式 (23) 使用同一个符号 $\chi$ 表示顾客市场系数，尽管实现例子没有使用 `chi`；OCR 足以确认结构，但最终版本应对照期刊 PDF 检查。

### 3.3 名义刚性

Rotemberg 价格调整成本为：

$$
\frac{\gamma_p}{2}
\left(\frac{P_{it}}{P_{i,t-1}}-\bar\pi\right)^2c_t
=
\frac{\gamma_p}{2}
\left(\pi_t\frac{p_{it}}{p_{i,t-1}}-\bar\pi\right)^2c_t.
\tag{F24} % (F24)
$$

局部通胀条件为：

$$
\hat\pi_t
=
\frac{1}{\gamma_p}(\hat\xi_t-\hat\nu_t)
+\beta E_t[\hat\pi_{t+1}].
\tag{F25} % (F25)
$$

论文的对数线性 Phillips 曲线为：

$$
\begin{aligned}
\hat\pi_t
=&-\frac{\omega(\eta-1)}{\gamma_p}
\left[
\hat\mu_t
+E_t\sum_{s=t}^{\infty}
\chi\tilde\delta^{s-t+1}\hat\mu_{s+1}
\right]
+\beta E_t[\hat\pi_{t+1}]\\
&+\frac{1}{\gamma_p}[\eta-\omega(\eta-1)]
E_t\sum_{s=t}^{\infty}
\chi\tilde\delta^{s-t+1}
\left[
(\hat\xi_t-\hat\xi_{s+1})-\hat\beta_{t,s+1}
\right].
\end{aligned}
\tag{F26} % (F26)
$$

其中 $\omega=1-\beta\theta(1-\rho)/(1-\rho\beta)$，$\tilde\delta=\beta[\rho+\theta(1-\eta)(1-\rho)]$。

`needs_review`：本条把 OCR 公式记录为结构 Phillips 曲线，但详细符号、帽号和正负号在提升审阅状态前需要源级核对。

## 4. Market Clearing & Identities

家庭消费-储蓄条件隐含的随机贴现因子为：

$$
m_{t,t+1}
=
\beta
\frac{U_x(x_{t+1}-\psi_{t+1},h_{t+1})}
{U_x(x_t-\psi_t,h_t)}
\frac{s_{t-1}^{\theta}}{s_t^{\theta}}.
\tag{F27} % (F27)
$$

Fisher 方程为：

$$
1=E_t\left[
m_{t,t+1}
\left(\frac{1+r_t}{1+\pi_{t+1}}\right)
\right].
\tag{F28} % (F28)
$$

家庭劳动-消费效率条件为：

$$
\frac{w_t}{\tilde p_t}
=
-\frac{U_h(x_t-\psi_t,h_t)}{U_x(x_t-\psi_t,h_t)}.
\tag{F29} % (F29)
$$

总习惯存量为：

$$
s_t=\rho s_{t-1}+(1-\rho)c_t.
\tag{F30} % (F30)
$$

总消费指数关系为：

$$
x_t=\frac{c_t}{s_t^\theta}.
\tag{F31} % (F31)
$$

同质企业模型中的劳动需求/生产关系为：

$$
h_t=
\left[
\frac{c_t+\phi}{\exp[0.5\alpha(1+\alpha)\sigma^2]}
\right]^{1/\alpha}.
\tag{F32} % (F32)
$$

在异质经营成本扩展中，论文将生产函数修改为：

$$
y_{it}=
\left(\frac{A_t}{a_{it}}h_{it}\right)^{\alpha}
-\phi_i.
\tag{F33} % (F33)
$$

存在企业类别 $k=1,\ldots,N$ 时，总通胀为：

$$
\pi_t=
\left[
\sum_{k=1}^N
\Xi_k(p_{k,t-1}\pi_{kt})^{1-\eta}
\right]^{\frac{1}{1-\eta}}.
\tag{F34} % (F34)
$$

## 5. Exogenous Processes

实现交叉检查中总技术冲击是持久的：

$$
\log A_t=\rho_A\log A_{t-1}+\sigma_A\varepsilon^A_t.
\tag{F35} % (F35)
$$

需求冲击是持久的：

$$
\psi_t=\rho_D\psi_{t-1}+\sigma_D\varepsilon^D_t.
\tag{F36} % (F36)
$$

金融冲击缩放股权稀释成本：

$$
\varphi_t=\bar\varphi f_t,
\qquad
\log f_t=0.90\log f_{t-1}+\varepsilon^f_t.
\tag{F37} % (F37)
$$

实现交叉检查还包含一个货币政策创新：

$$
R_t=\mathcal R(R_{t-1},\pi_t,\pi_t^f,y_t/y_t^{ss})\exp(\sigma_R\varepsilon^R_t).
\tag{F38} % (F38)
$$

`needs_review`：论文侧来源清楚说明了 Taylor 规则和金融冲击，但准确实现记号不同（`R`、`F`、`D`、`eR`、`eF`、`eD`）。

## 6. Steady-State Solution

论文使用季度校准，并围绕对称均衡做局部模拟。来源没有提供完整的 `steady_state_model`；下面是来自来源的第一版稳态限制，具体实现细节留待后续处理。

1. 将创新均值设为零：$\varepsilon^A=\varepsilon^D=\varepsilon^f=\varepsilon^R=0$。
2. 对称均衡归一化为 $p_i=1$、$c_i=c$、$s_i=s$，且事前相同企业具有共同的预期影子价值。
3. 由习惯积累，在 $\bar c$ 为常数且 $0<\rho<1$ 时，$\bar s=\bar c$。
4. 稳态通胀为零时，$\bar\pi=\pi^{\ast}$，Rotemberg 调整成本为零。
5. 家庭 SDF 满足稳态 Fisher 关系 $1=\bar m(1+\bar r)/(1+\bar\pi)$。
6. 融资触发点为 $\bar a^E=\bar c(\bar A/\bar w)/(\bar c+\phi)^{1/\alpha}$。
7. 预期内部资金楔子为 $\bar\xi=1+[\bar\varphi/(1-\bar\varphi)][1-\Phi(\bar z^E)]$，其中 $\bar z^E=\sigma^{-1}(\log\bar a^E+0.5\sigma^2)$。
8. 金融调整加成 $\bar{\tilde\mu}$ 由 (F20) 给出；存在顾客市场时，它通过 (F21)-(F23) 与边际销售价值相连。
9. 来源列出的基准校准值包括 $\beta=0.99$、$\theta=-0.8$、$\rho=0.95$、CRRA 参数 $1$、劳动供给弹性 $5$、$\eta=2$、$\alpha=0.8$、$\phi=0.3$、$\bar\varphi=0.3$、$\rho_f=0.9$、$\rho_D=0.9$、$\sigma=0.05$、$\gamma_p=10$、$\gamma_w=30$、$\tau_r=0.75$、$\tau_\pi=1.5$。

`needs_review`：Rep-MMB 示例使用相关但不完全相同的校准名称和值（`beta=0.985`、`theta=-0.75`、`rho_s=0.95`、`alpha=0.85`、`varrhobar=0.5`）。这些差异只作为实现交叉检查证据记录，不作为论文侧校准。

## 7. Timing & Form Conventions

- 企业在观察总量信息之后、特质成本冲击实现之前选择价格和生产计划。
- 劳动雇佣、股利和股权发行在特质成本冲击实现后确定。
- 顾客基础/习惯存量是预定状态：$c_{it}$ 的需求取决于 $s_{i,t-1}$，且 $s_{it}$ 由当期消费推动。
- 金融摩擦通过当期股权稀释成本 $\varphi_t$ 以及实现利润为负的概率进入模型。
- 同质模型在事前具有对称相对价格和生产规模，但特质冲击使劳动和股利结果具有非退化分布。
- 论文同时包含非线性均衡条件和局部/对数线性 Phillips 曲线表达式。Rep-MMB 实现是非线性 `model` 块并做一阶扰动，不声明为 `model(linear)`。
- 该模型没有物质资本存量。关键预定存量是顾客习惯存量 $s_{i,t-1}$。
- 未执行运行时验证。

## 8. Variable & Parameter Reference Table

### 内生变量

| 符号 | 含义 | 主要方程 |
|---|---|---|
| $x_t$ | 习惯调整后的总消费组合 | (F2), (F31) |
| $c_{it}, c_t$ | 品种消费和总消费/销售 | (F4), (F30), (F31) |
| $s_{it}, s_t$ | 商品特定/总习惯存量 | (F3), (F30) |
| $p_{it}$ | 品种 $i$ 的相对价格 | (F4), (F15), (F19) |
| $\tilde p_t$ | 外部性调整价格指数 | (F5), (F29) |
| $y_{it}, y_t$ | 产出 | (F6), (F33) |
| $h_{it}, h_t$ | 劳动投入 | (F6), (F29), (F32) |
| $d_{it}$ | 股利；为负时表示股权发行 | (F8), (F11) |
| $\xi_{it}$ | 内部资金影子价值 | (F11), (F17), (F18) |
| $\kappa_{it}$ | 生产乘子/边际成本对象 | (F12) |
| $\nu_{it}$ | 边际销售价值 | (F13), (F21), (F23) |
| $\lambda_{it}$ | 顾客基础/习惯存量价值 | (F14), (F21) |
| $\tilde\mu_t$ | 金融调整加成 | (F20), (F21), (F26) |
| $\pi_t$ | 通胀 | (F24), (F25), (F26), (F34) |
| $m_{t,t+1}$ | 随机贴现因子 | (F22), (F27), (F28) |
| $r_t$ | 名义利率 | (F10), (F28) |
| $a_t^E, z_t^E$ | 融资触发点及标准化触发点 | (F16), (F18) |
| $\varphi_t, f_t$ | 股权稀释成本和金融冲击状态 | (F37) |
| $A_t$ | 总生产率 | (F6), (F35) |
| $\psi_t$ | 需求冲击 | (F1), (F36) |

### 外生冲击

| 符号 | 含义 | 主要方程 |
|---|---|---|
| $\varepsilon^A_t$ | 生产率创新 | (F35) |
| $\varepsilon^D_t$ | 需求创新 | (F36) |
| $\varepsilon^f_t$ | 金融冲击创新 | (F37) |
| $\varepsilon^R_t$ | 实现中的货币政策创新 | (F38) |

### 参数

| 符号 | 含义 |
|---|---|
| $\beta$ | 贴现因子 |
| $\theta$ | 商品特定深度习惯参数 |
| $\rho$ | 习惯持久性 |
| $\eta$ | 品种间替代弹性 |
| $\alpha$ | 规模报酬/劳动技术参数 |
| $\phi$ | 固定经营成本 |
| $\sigma$ | 特质成本冲击波动率 |
| $\varphi_t,\bar\varphi$ | 股权稀释成本及稳态/基准值 |
| $\gamma_p$ | Rotemberg 价格调整成本 |
| $\gamma_w$ | 实现中的工资调整成本 |
| $\tau_r,\tau_\pi,\tau_y$ | Taylor 规则平滑、通胀和产出缺口系数 |
| $\rho_A,\rho_D,\rho_f$ | 冲击持久性参数 |
| $\Xi_k,\phi_k$ | 异质扩展中类别 $k$ 的质量和经营成本 |
