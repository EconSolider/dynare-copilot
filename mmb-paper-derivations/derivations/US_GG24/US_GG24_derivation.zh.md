# US_GG24 -- 推导（最优化问题 + 一阶条件）

> `US_GG24` 的模型档案草稿。未执行运行时验证。第一遍公式状态：`needs_review`。

## 1. Model Overview

- **模型**：Gagliardone and Gertler (2024), "Oil Prices, Monetary Policy and Inflation Surges"；MMB 模型 ID `US_GG24`。
- **用途**：一个按月估计的新凯恩斯模型，用于研究美国近期通胀上升中的油价冲击、货币政策宽松、需求冲击和劳动力市场紧张度。
- **主体与模块**：代表性家庭、Mortensen-Pissarides 劳动力市场、使用劳动和石油的竞争性批发企业、工人、Nash 工资基准及真实工资刚性、Calvo 零售企业、石油禀赋部门、中央银行和通过一次总付税融资的财政部门。
- **模型形式**：来源方程多以非线性水平形式书写，但定量模型通过对数线性化均衡条件和脉冲响应匹配估计。在完成源代码或方程验证前，本档案条目按 `needs_review` 的线性化 DSGE 推导处理。
- **主要冲击**：石油供给冲击 `eps_o`、贴现因子/需求冲击 `eps_b`、匹配效率冲击 `eps_phi`、货币政策冲击 `eps_r`，以及历史分解测量方程中的油价投机/噪声冲击 `eps_m`。
- **来源**：从 `raw/mmb_mineru/runs/us_gg24__oil_prices_monetary_policy_and_inflation_surges__65e1c546/full.md` 提取；原始 PDF 记录为 `raw/mmb_papers/Oil Prices, Monetary Policy and Inflation Surges.pdf`；DOI `10.3386/w31263`；MinerU run id `65e1c546-8764-48d5-8571-e080685b9992`。

## 2. Optimization Problems

### 2.1 家庭

代表性家庭为就业和失业成员提供消费保险。在给定就业 $n_t$ 的条件下，选择复合消费 $c_t$、名义债券 $B_t$、最终品消费 $c_{qt}$ 和石油消费 $c_{ot}$。

$$
\max_{\{c_t,B_t,c_{qt},c_{ot}\}} E_t \sum_{i=0}^{\infty} \beta^i \varepsilon_{bt}
\ln(c_{t+i}-h c_{t-1+i})
$$

约束为消费聚合器和预算约束

$$
c_t =
\left(\chi^{1/\psi} c_{ot}^{1-1/\psi}
+ (1-\chi)^{1/\psi} c_{qt}^{1-1/\psi}\right)^{1/(1-1/\psi)},
$$

$$
c_t = w_{ct} n_t + b_t(1-n_t)
+ R^n_{t-1}\frac{p_{c,t-1}}{p_{ct}}B_{t-1} - B_t + \Pi_t.
$$

`needs_review`：论文中边际效用一行存在 OCR 噪声；本条目在第 3 节记录预期的习惯边际效用形式。

### 2.2 批发企业

竞争性批发企业在 CES 生产函数和就业积累约束下选择空缺、就业和石油投入，以最大化贴现利润价值：

$$
\max_{\{v_t,n_t,o_t\}} F_t
= p_{wt}y_t - w_{qt}n_t - c_v v_t - s_{qt}o_t
+ E_t\{\Lambda^q_{t,t+1}F_{t+1}\},
$$

$$
y_t =
\left(\alpha^{1/\epsilon} n_t^{1-1/\epsilon}
+(1-\alpha)^{1/\epsilon} o_t^{1-1/\epsilon}\right)^{1/(1-1/\epsilon)},
$$

$$
n_t = \rho n_{t-1}+q_t v_t.
$$

### 2.3 Nash 工资基准

Nash 基准工资满足

$$
\max_{w^o_{qt}} H_t^{\varsigma}J_t^{1-\varsigma},
$$

其中 $H_t$ 是工人剩余，$J_t$ 是已填补岗位对企业的价值。实际使用的工资是该基准工资经过真实工资刚性变换后的结果，而不是完全灵活的 Nash 工资。

### 2.4 零售企业

零售企业面临 Calvo 定价。能够重新定价的企业选择 $p^*_{jt}$ 和需求 $y_{j,t+i}$ 以最大化预期贴现利润：

$$
\max_{\{p^*_{jt},y_{j,t+i}\}} E_t\left\{\sum_{i=0}^{\infty}\lambda^i
\Lambda^q_{t,t+i}\left(\frac{p^*_{jt}}{p_{qt}}-p_{w,t+i}\right)y_{j,t+i}\right\},
$$

并满足需求函数

$$
y_{jt}=\left(\frac{p_{jt}}{p_{qt}}\right)^{-\eta}c_{qt}.
$$

### 2.5 石油生产者、政府和政策当局

石油生产者收到外生禀赋并把利润支付给家庭。财政部门用一次总付税为失业保险融资。中央银行遵循 Taylor 规则，而不是求解最优化问题。

## 3. First-Order Conditions

- **(F1) 家庭随机贴现因子和 Euler 方程**：

$$
\Lambda_{t,t+1}=\beta\frac{u_{c,t+1}}{u_{ct}}, \qquad
E_t\left\{\Lambda_{t,t+1} R^n_t\frac{p_{ct}}{p_{c,t+1}}\right\}=1.
$$

其中习惯边际效用为

$$
u_{ct}=\frac{1}{c_t-hc_{t-1}}-\frac{\beta h}{c_{t+1}-hc_t}.
$$

- **(F2) 家庭对最终消费品和石油的需求**：

$$
c_{qt}=(1-\chi)\left(\frac{p_{qt}}{p_{ct}}\right)^{-\psi}c_t,
\qquad
c_{ot}=\chi s_t^{-\psi}c_t.
$$

- **(F3) 消费价格指数**：

$$
p_{ct}=\left(\chi p_{ot}^{1-\psi}+(1-\chi)p_{qt}^{1-\psi}\right)^{1/(1-\psi)}.
$$

- **(F4) 批发生产函数**：

$$
y_t =
\left(\alpha^{1/\epsilon} n_t^{1-1/\epsilon}
+(1-\alpha)^{1/\epsilon} o_t^{1-1/\epsilon}\right)^{1/(1-1/\epsilon)}.
$$

- **(F5) 就业积累**：

$$
n_t=\rho n_{t-1}+q_t v_t.
$$

- **(F6) 招聘条件**：

$$
\frac{c_v}{q_t}
= p_{wt}a_{nt}-w_{qt}
+\rho E_t\left\{\Lambda^q_{t,t+1}\frac{c_v}{q_{t+1}}\right\}.
$$

- **(F7) 劳动边际产出**：

$$
a_{nt}=\left(\alpha\frac{y_t}{n_t}\right)^{1/\epsilon}.
$$

- **(F8) 石油需求条件**：

$$
p_{wt}a_{ot}=s_{qt}.
$$

- **(F9) 石油边际产出**：

$$
a_{ot}=\left((1-\alpha)\frac{y_t}{o_t}\right)^{1/\epsilon}.
$$

- **(F10) 已填补岗位对企业的价值**：

$$
J_t=p_{wt}a_{nt}-w_{qt}
+\rho E_t\{\Lambda^q_{t,t+1}J_{t+1}\}.
$$

- **(F11) 工人剩余**：

$$
H_t=w_{ct}-b_t
+E_t\{\Lambda_{t,t+1}(\rho-f_{t+1})H_{t+1}\}.
$$

- **(F12) Nash 基准产品工资**：

$$
w^o_{qt} =
\frac{\varsigma\left(p_{wt}a_{nt}
+\rho E_t\left\{\frac{c_v}{q_{t+1}}(\Lambda^q_{t,t+1}-\Lambda_{t,t+1})\right\}
+E_t\{\Lambda_{t,t+1}c_v\theta_{t+1}\}\right)
+(1-\varsigma)\frac{p_{qt}}{p_{ct}}b}
{\varsigma+(1-\varsigma)\frac{p_{qt}}{p_{ct}}}.
$$

`needs_review`：该公式根据 Nash 工资表达式附近的 OCR 文本整理而成。

- **(F13) 真实工资刚性**：

$$
w_{qt}=(w^o_{qt})^{1-\gamma}(\bar w^o_q)^\gamma.
$$

- **(F14) 差异化商品零售需求**：

$$
y_{jt}=\left(\frac{p_{jt}}{p_{qt}}\right)^{-\eta}c_{qt}.
$$

- **(F15) Calvo 重置价格 FOC**：

$$
E_t\left\{\sum_{i=0}^{\infty}\lambda^i\Lambda^q_{t,t+i}
\left(\frac{p^*_{jt}}{p_{q,t+i}}-(1+\mu)p_{w,t+i}\right)y_{j,t+i}\right\}=0.
$$

- **(F16) Calvo 定价下的商品价格指数**：

$$
p_{qt}=\left((1-\lambda)(p^*_t)^{1-\eta}
+\lambda p_{q,t-1}^{1-\eta}\right)^{1/(1-\eta)}.
$$

- **(F17) 对数线性 New Keynesian Phillips 曲线**：

$$
\pi_{qt}=\kappa\widehat p_{wt}+E_t\{\pi_{q,t+1}\},
\qquad
\kappa=\frac{(1-\lambda)(1-\lambda\beta)}{\lambda}.
$$

- **(F18) 通胀的现值表示**：

$$
\pi_{qt}=\kappa\sum_{i=0}^{\infty}E_t\{\widehat p_{w,t+i}\}.
$$

- **(F19) 边际成本恒等式**：

$$
p_{wt}=\frac{w_{qt}+\omega_t}{a_{nt}}.
$$

- **(F20) 净招聘成本**：

$$
\omega_t=\frac{c_v}{q_t}
-\rho E_t\left\{\Lambda^q_{t,t+1}\frac{c_v}{q_{t+1}}\right\}.
$$

- **(F21) 对数线性边际成本分解**：

$$
\widehat p_{wt}=\zeta\widehat w_{qt}+(1-\zeta)\widehat\omega_t-\widehat a_{nt},
\qquad
\zeta=\frac{\bar w_q}{\bar w_q+\bar\omega}.
$$

- **(F22) 劳动边际产出的对数线性近似**：

$$
\widehat a_{nt}=\frac{1}{\epsilon}(1-\bar\alpha)(\widehat o_t-\widehat n_t),
$$

其中

$$
\bar\alpha =
\frac{\alpha}
{\alpha+\alpha^{1-1/\epsilon}(1-\alpha)^{1/\epsilon}(\bar o/\bar n)^{1-1/\epsilon}}
\approx \alpha.
$$

## 4. Market Clearing & Identities

- **(F23) 失业恒等式**：

$$
u_t=1-n_{t-1}.
$$

- **(F24) 匹配函数**：

$$
\Phi_t=\varepsilon_{\Phi t}u_t^\sigma v_t^{1-\sigma}.
$$

- **(F25) 空缺填补概率和求职成功概率**：

$$
q_t=\frac{\Phi_t}{v_t}, \qquad f_t=\frac{\Phi_t}{u_t}.
$$

- **(F26) 劳动力市场紧张度**：

$$
\theta_t=\frac{v_t}{u_t}.
$$

- **(F27) 石油市场出清**：

$$
o_t+c_{ot}=S\exp(-\varepsilon_{ot}).
$$

- **(F28) 产成品资源约束**：

$$
c_{qt}=y_{qt}-c_v v_t.
$$

- **(F29) 债券市场出清**：

$$
B_t=0.
$$

- **(F30) 产品工资和石油价格单位转换**：

$$
w_{qt}=w_{ct}\frac{p_{ct}}{p_{qt}},
\qquad
s_{qt}=s_t\frac{p_{ct}}{p_{qt}},
\qquad
s_t=\frac{p_{ot}}{p_{ct}}.
$$

- **(F31) 财政预算**：

$$
b_t u_t=\tau_t.
$$

## 5. Exogenous Processes

- **(F32) 货币政策规则**：

$$
R^n_t =
\left(R^n(1+\pi_{qt})^{\phi_\pi}\right)^{1-\rho^R}
+(R^n_{t-1})^{\rho^R}e^{\varepsilon_{rt}}.
$$

`needs_review`：来源中的 Taylor 规则为乘法型；此处保留印刷式中两个部分之间的加号，但标准 Dynare 实现可能使用乘法。

- **(F33) 货币政策冲击**：

$$
\varepsilon_{rt}=\rho^m\varepsilon_{r,t-1}+\sigma^m e^r_t.
$$

`needs_review`：AR(1) 形式由正文和参数表推断；论文没有把精确创新记号作为编号方程列出。

- **(F34) 持久性石油冲击**：

$$
\varepsilon_{ot}=\rho^o\varepsilon_{o,t-1}+\sigma^o e^o_t.
$$

`needs_review`：AR(1) 形式由正文和参数表推断。

- **(F35) 贴现因子/需求冲击**：

$$
\varepsilon_{bt}=\rho^b\varepsilon_{b,t-1}+\sigma^b e^b_t.
$$

`needs_review`：Appendix B 报告了持续性和波动率，但主模型块没有印刷该过程。

- **(F36) 匹配效率冲击**：

$$
\varepsilon_{\Phi t}=\rho^\Phi\varepsilon_{\Phi,t-1}+\sigma^\Phi e^\Phi_t.
$$

`needs_review`：Appendix B 报告了持续性和波动率，但主模型块没有印刷该过程。

- **(F37) 油价测量/噪声方程**：

$$
\pi_{ot}=\bar\pi_{ot}+\varepsilon_{mt}.
$$

## 6. Steady-State Solution

论文报告的是稳态目标和参数限制，而不是完整解析 `steady_state_model`。下列来源支持的稳态结构在与实现文件或作者代码核对前应保持 `needs_review`。

1. 最终品通胀采用零通胀稳态：$\pi_q=0$，相对价格不变。
2. 选择 $\beta=0.998$，对应约 2% 的年化真实利率。
3. 选择 $\eta=4$，通过 $\mu=1/(1-1/\eta)$ 对应约 1.3 的稳态毛加成。
4. 设定劳动力市场稳态目标：$\rho=0.96$、$\sigma=\varsigma=0.5$、失业率 $u=0.05$、外部选项 $b=0.7$。
5. 用失业恒等式 $u=1-n_{-1}$ 将稳态就业固定在约 $n=0.95$。
6. 一旦选择匹配归一化，用稳态匹配、空缺填补和求职成功条件求解空缺、匹配、$q$、$f$ 和紧张度 $\theta=v/u$。
7. 用石油部门目标 $o/y=0.03$ 和 $o/c_o=1.5$ 固定劳动份额参数 $\alpha=0.97$ 和家庭石油份额 $\chi=0.02$。
8. 其余参数通过脉冲响应匹配估计：$\epsilon=0.370$、$\psi=0.020$、$h=0.906$、$\lambda=0.946$、$\gamma=0.705$、$\phi_\pi=2.16$、$\rho^R=0.063$、$\rho^m=0.946$、$\rho^o=0.964$、$\sigma^m=0.023$、$\sigma^o=0.062$。
9. Appendix B 给出历史分解冲击过程的 Bayesian 估计：$\rho^b=0.298$、$\rho^\Phi=0.515$、$\sigma^b=0.0577$、$\sigma^\Phi=0.157$、石油冲击波动率约 $0.052$、货币冲击波动率约 $0.042$。

## 7. Timing & Form Conventions

- **频率**：月度校准和估计；部分表格也给出季度等价值。
- **就业时序**：失业为 $u_t=1-n_{t-1}$，因此期初失业由滞后就业决定。新雇佣工人在第 $t$ 期立即工作，就业按 $n_t=\rho n_{t-1}+q_t v_t$ 演化。
- **石油禀赋时序**：第 $t$ 期石油供给为 $S\exp(-\varepsilon_{ot})$，相对石油价格同时出清家庭和企业的石油需求。
- **通胀约定**：核心通胀是在政策规则和线性化 Phillips 曲线中使用的净对数通胀 $\pi_{qt}=\ln(p_{qt}/p_{q,t-1})$。
- **政策利率**：基准实证实现使用 proxy funds rate，而不是原始 Federal funds rate。
- **模型形式**：论文侧均衡混合了非线性条件和对数线性近似；档案中将 `US_GG24` 归类为线性化估计 NK 模型。
- **运行时验证**：未执行；没有运行 Dynare。

## 8. Variable & Parameter Reference Table

| 类别 | 符号 / ASCII 名 | 含义 | 主要方程 |
|---|---|---|---|
| 内生 | `c` / $c_t$ | 复合消费 | (F1)-(F3) |
| 内生 | `c_q` / $c_{qt}$ | 最终消费品 | (F2), (F28) |
| 内生 | `c_o` / $c_{ot}$ | 家庭石油消费 | (F2), (F27) |
| 内生 | `B` / $B_t$ | 名义债券 | (F1), (F29) |
| 内生 | `n` / $n_t$ | 就业 | (F5), (F23) |
| 内生 | `u` / $u_t$ | 失业 | (F23) |
| 内生 | `v` / $v_t$ | 空缺 | (F24)-(F26) |
| 内生 | `Phi` / $\Phi_t$ | 新匹配 | (F24) |
| 内生 | `q` / $q_t$ | 空缺填补概率 | (F25) |
| 内生 | `f` / $f_t$ | 求职成功概率 | (F25) |
| 内生 | `theta` / $\theta_t$ | 劳动力市场紧张度 | (F26) |
| 内生 | `y` / $y_t$ | 批发产出 | (F4) |
| 内生 | `o` / $o_t$ | 企业石油投入 | (F8), (F27) |
| 内生 | `a_n` / $a_{nt}$ | 劳动边际产出 | (F7), (F22) |
| 内生 | `a_o` / $a_{ot}$ | 石油边际产出 | (F9) |
| 内生 | `p_w` / $p_{wt}$ | 实际边际成本 / 批发相对价格 | (F19), (F21) |
| 内生 | `w_q` / $w_{qt}$ | 产品工资 | (F12), (F13), (F30) |
| 内生 | `w_c` / $w_{ct}$ | 消费用工资 | (F30) |
| 内生 | `J` / $J_t$ | 匹配对企业的价值 | (F10) |
| 内生 | `H` / $H_t$ | 工人剩余 | (F11) |
| 内生 | `p_q` / $p_{qt}$ | 最终品价格指数 | (F16) |
| 内生 | `pi_q` / $\pi_{qt}$ | 核心通胀 | (F17), (F32) |
| 内生 | `p_star` / $p^*_t$ | 重置价格 | (F15), (F16) |
| 内生 | `R_n` / $R^n_t$ | 名义政策利率 | (F1), (F32) |
| 内生 | `s` / $s_t$ | 消费单位下的相对石油价格 | (F2), (F30) |
| 内生 | `s_q` / $s_{qt}$ | 最终品单位下的石油价格 | (F8), (F30) |
| 外生 | `eps_o` / $\varepsilon_{ot}$ | 石油供给冲击 | (F27), (F34) |
| 外生 | `eps_b` / $\varepsilon_{bt}$ | 贴现因子/需求冲击 | (F35) |
| 外生 | `eps_phi` / $\varepsilon_{\Phi t}$ | 匹配效率冲击 | (F24), (F36) |
| 外生 | `eps_r` / $\varepsilon_{rt}$ | 货币政策冲击 | (F32), (F33) |
| 外生 | `eps_m` / $\varepsilon_{mt}$ | 油价投机/噪声冲击 | (F37) |
| 参数 | `beta` / $\beta$ | 贴现因子 | 0.998 |
| 参数 | `eta` / $\eta$ | 差异化商品替代弹性 | 4 |
| 参数 | `rho` / $\rho$ | 岗位存活率 | 0.96 |
| 参数 | `sigma` / $\sigma$ | 匹配弹性 | 0.5 |
| 参数 | `varsigma` / $\varsigma$ | 工人议价权重 | 0.5 |
| 参数 | `b` / $b$ | 工人外部选项 | 0.7 |
| 参数 | `alpha` / $\alpha$ | 生产 CES 中劳动份额 | 0.97 |
| 参数 | `chi` / $\chi$ | 家庭石油份额 | 0.02 |
| 参数 | `epsilon` / $\epsilon$ | 石油-劳动替代弹性 | 0.370 |
| 参数 | `psi` / $\psi$ | 石油-消费替代弹性 | 0.020 |
| 参数 | `h` / $h$ | 习惯持久性 | 0.906 |
| 参数 | `lambda` / $\lambda$ | Calvo 不调整概率 | 0.946 |
| 参数 | `gamma` / $\gamma$ | 真实工资刚性 | 0.705 |
| 参数 | `phi_pi` / $\phi_\pi$ | Taylor 规则通胀反馈 | 2.16 |
| 参数 | `rho_R` / $\rho^R$ | 利率平滑 | 0.063 |
| 参数 | `rho_m` / $\rho^m$ | 货币冲击持续性 | 0.946 |
| 参数 | `rho_o` / $\rho^o$ | 石油冲击持续性 | 0.964 |

第一遍方程和变量覆盖有意比最终 Dynare `model(linear)` 模块更宽，因为论文没有提供完整可运行方程列表。状态保持为 `needs_review`。
