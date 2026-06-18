# NK_JO15_lt - 推导（最优化问题 + 一阶条件）

> 来源支撑的模型抽取草稿。未执行运行时验证。

出处：`NK_JO15_lt`，Jang and Okano (2015)，"Productivity Shocks and Monetary Policy in a Two-Country Model"，Front. Econ. China, 10(1), 7-37，DOI `10.1016/j.jpolmod.2015.03.017`。主要来源 Markdown：`raw/mmb_mineru/runs/nk_jo15_ht_nk_jo15_lt__productivity_shocks_and_monetary_policy_in_a_two_country_model__f031feec/full.md`。已检查原始 PDF 路径：`raw/mmb_papers/Productivity Shocks and Monetary Policy in a Two-Country Model.pdf`。MinerU run id：`f031feec-a81e-43ec-ac7a-f89bd2d73785`。附录规范化文件：未找到。实现交叉检查：`.agents/skills/dynare-copilot/references/examples/NK_JO15_lt_rep.mod`。

## 1. Model Overview

- **模型**：对称两国开放经济新凯恩斯模型，包含本国偏好、在非对称贸易份额下偏离 PPP、Calvo-Yun 定价、垄断竞争、完全金融市场，以及 Ravenna-Walsh 成本渠道进入企业边际成本。
- **MMB 变体**：`NK_JO15_lt`，低贸易开放度。论文研究多个开放度情形；本条目记录低贸易情形 $\alpha=0.1$。
- **实验**：MMB 实现模拟国内经济对国外生产率冲击的动态响应。本轮归档未做运行时验证。
- **主体与模块**：H 国和 F 国的代表性家庭、各国差异化商品企业、完全国际资产市场、以及两国遵循 Taylor 规则的中央银行。
- **形式**：对数线性 `model(linear)`。除实现中的价格/汇率类线性化对数变量 $p_t$、$p_t^{\ast}$、$e_t$、$s_t$ 和 $q_t$ 外，小写变量表示相对确定性稳态的百分比偏离。所有稳态偏离均为零。
- **来源质量**：MinerU Markdown 中模型方程总体可读，但若干 OCR 方程编号和符号存在错误；对精确论文编号以及含成本渠道项的 CPI 通胀表达式标记为 `needs_review`。

## 2. Optimization Problems

### 2.1 家庭

H 国和 F 国家庭最大化可分效用：

$$(F1)\qquad
\mathcal{U}=E_0\sum_{t=0}^{\infty}\beta^t
\left(\frac{C_t^{1-\sigma}}{1-\sigma}-\frac{N_t^{1+\varphi}}{1+\varphi}\right),
\quad
\mathcal{U}^{\ast}=E_0\sum_{t=0}^{\infty}\beta^t
\left(\frac{(C_t^{\ast})^{1-\sigma}}{1-\sigma}-\frac{(N_t^{\ast})^{1+\varphi}}{1+\varphi}\right).
$$

复合消费指数为：

$$(F2)\qquad
C_t=\left[(1-\alpha)^{1/\eta}C_{H,t}^{(\eta-1)/\eta}
\alpha^{1/\eta}C_{F,t}^{(\eta-1)/\eta}\right]^{\eta/(\eta-1)},
$$

$$(F3)\qquad
C_t^{\ast}=\left[(1-\alpha)^{1/\eta}(C_{F,t}^{\ast})^{(\eta-1)/\eta}
\alpha^{1/\eta}(C_{H,t}^{\ast})^{(\eta-1)/\eta}\right]^{\eta/(\eta-1)}.
$$

国内家庭在商品类别内加总后的预算约束为：

$$(F4)\qquad
P_t C_t+E_t(Q_{t,t+1}D_{t+1}^n)\leq D_t^n+W_tN_t+TR_t,
$$

对应的国外约束为：

$$(F5)\qquad
P_t^{\ast} C_t^{\ast}+E_t(Q_{t,t+1}^{\ast}D_{t+1}^{n\ast})\leq D_t^{n\ast}+W_t^{\ast}N_t^{\ast}+TR_t^{\ast}.
$$

### 2.2 商品需求与价格指数

同一国内差异化品种的需求为：

$$(F6)\qquad
C_t(h)=\left(\frac{P_t(h)}{P_{H,t}}\right)^{-\varepsilon}C_{H,t},\quad
C_t(f)=\left(\frac{P_t(f)}{P_{F,t}}\right)^{-\varepsilon}C_{F,t},
$$

$$(F7)\qquad
C_t^{\ast}(h)=\left(\frac{P_t^{\ast}(h)}{P_{H,t}^{\ast}}\right)^{-\varepsilon}C_{H,t}^{\ast},\quad
C_t^{\ast}(f)=\left(\frac{P_t^{\ast}(f)}{P_{F,t}^{\ast}}\right)^{-\varepsilon}C_{F,t}^{\ast}.
$$

本国产品与进口品之间的支出配置为：

$$(F8)\qquad
C_{H,t}=(1-\alpha)\left(\frac{P_{H,t}}{P_t}\right)^{-\eta}C_t,\quad
C_{F,t}=\alpha\left(\frac{P_{F,t}}{P_t}\right)^{-\eta}C_t,
$$

$$(F9)\qquad
C_{H,t}^{\ast}=\alpha\left(\frac{P_{H,t}^{\ast}}{P_t^{\ast}}\right)^{-\eta}C_t^{\ast},\quad
C_{F,t}^{\ast}=(1-\alpha)\left(\frac{P_{F,t}^{\ast}}{P_t^{\ast}}\right)^{-\eta}C_t^{\ast}.
$$

消费者价格指数为：

$$(F10)\qquad
P_t=\left[(1-\alpha)P_{H,t}^{1-\eta}+\alpha P_{F,t}^{1-\eta}\right]^{1/(1-\eta)}.
$$

$$(F11)\qquad
P_t^{\ast}=\left[(1-\alpha)(P_{F,t}^{\ast})^{1-\eta}+\alpha(P_{H,t}^{\ast})^{1-\eta}\right]^{1/(1-\eta)}.
$$

### 2.3 企业

每个国家有连续统的垄断竞争企业，生产技术为线性：

$$(F12)\qquad
Y_t(h)=A_tN_t(h),\quad Y_t^{\ast}(f)=A_t^{\ast}N_t^{\ast}(f).
$$

品种需求意味着：

$$(F13)\qquad
Y_t(h)=\left(\frac{P_t(h)}{P_{H,t}}\right)^{-\varepsilon}Y_t,\quad
Y_t^{\ast}(f)=\left(\frac{P_t^{\ast}(f)}{P_{F,t}^{\ast}}\right)^{-\varepsilon}Y_t^{\ast}.
$$

总劳动与生产满足：

$$(F14)\qquad
N_t=\frac{Y_tD_t}{A_t},\quad N_t^{\ast}=\frac{Y_t^{\ast}D_t^{\ast}}{A_t^{\ast}},
$$

在确定性稳态附近一阶近似为：

$$(F15)\qquad
y_t=a_t+n_t,\quad y_t^{\ast}=a_t^{\ast}+n_t^{\ast}.
$$

企业以概率 $1-\theta$ 重新定价。Calvo-Yun 最优重定价条件为：

$$(F16)\qquad
\tilde P_{H,t}=E_t\left(
\frac{\sum_{k=0}^{\infty}\theta^k Q_{t,t+k}Y_{t+k}
\frac{\varepsilon}{\varepsilon-1}P_{H,t+k}MC_{H,t+k}}
{\sum_{k=0}^{\infty}\theta^k Q_{t,t+k}Y_{t+k}}
\right),
$$

$$(F17)\qquad
\tilde P_{F,t}^{\ast}=E_t\left(
\frac{\sum_{k=0}^{\infty}\theta^k Q_{t,t+k}^{\ast}Y_{F,t+k}
\frac{\varepsilon}{\varepsilon-1}P_{F,t+k}^{\ast}MC_{F,t+k}^{\ast}}
{\sum_{k=0}^{\infty}\theta^k Q_{t,t+k}^{\ast}Y_{F,t+k}}
\right).
$$

实际边际成本包含成本渠道：

$$(F18)\qquad
MC_{H,t}=\frac{P_t}{P_{H,t}}\frac{(1-\tau)C_t^\sigma N_t^\varphi R_t}{A_t},\quad
MC_{F,t}^{\ast}=\frac{P_t^{\ast}}{P_{F,t}^{\ast}}\frac{(1-\tau)(C_t^{\ast})^\sigma (N_t^{\ast})^\varphi R_t^{\ast}}{A_t^{\ast}}.
$$

## 3. First-Order Conditions

家庭 Euler 方程：

$$(F19)\qquad
\beta E_t\left(\frac{C_{t+1}^{-\sigma}P_t}{C_t^{-\sigma}P_{t+1}}\right)=\frac{1}{R_t},\quad
\beta E_t\left(\frac{(C_{t+1}^{\ast})^{-\sigma}P_t^{\ast}}{(C_t^{\ast})^{-\sigma}P_{t+1}^{\ast}}\right)=\frac{1}{R_t^{\ast}}.
$$

劳动供给条件：

$$(F20)\qquad
C_t^\sigma N_t^\varphi=\frac{W_t}{P_t},\quad
(C_t^{\ast})^\sigma(N_t^{\ast})^\varphi=\frac{W_t^{\ast}}{P_t^{\ast}}.
$$

对数线性 Euler 方程：

$$(F21)\qquad
c_t=E_t(c_{t+1})-\frac{1}{\sigma}\{r_t-E_t(\pi_{t+1})\},\quad
c_t^{\ast}=E_t(c_{t+1}^{\ast})-\frac{1}{\sigma}\{r_t^{\ast}-E_t(\pi_{t+1}^{\ast})\}.
$$

对数线性 Calvo 重定价条件给出 PPI Phillips 曲线：

$$(F22)\qquad
\pi_{H,t}=\beta E_t(\pi_{H,t+1})+\kappa_H mc_{H,t},\quad
\pi_{F,t}^{\ast}=\beta E_t(\pi_{F,t+1}^{\ast})+\kappa_F mc_{F,t}^{\ast},
$$

其中 MMB 实现中 $\kappa_H=(1-\theta_H)(1-\theta_H\beta)/\theta_H$，$\kappa_F=(1-\theta_F)(1-\theta_F\beta)/\theta_F$。

自然产出定义：

$$(F23)\qquad
x_t\equiv y_t-\bar y_t,\quad x_t^{\ast}\equiv y_t^{\ast}-\bar y_t^{\ast}.
$$

灵活价格且边际成本不变时的自然产出：

$$(F24)\qquad
\bar y_t=\frac{\varsigma\psi}{\delta}a_t-\frac{\omega_2\sigma\psi}{\delta}a_t^{\ast},\quad
\bar y_t^{\ast}=\frac{\varsigma\psi}{\delta}a_t^{\ast}-\frac{\omega_2\sigma\psi}{\delta}a_t.
$$

以产出缺口表示的开放经济 IS 曲线：

$$(F25)\qquad
x_t=E_t(x_{t+1})-\frac{1}{\sigma_\omega}\{r_t-E_t(\pi_{H,t+1})\}
\frac{\omega_2}{\omega_2+1}\{E_t(x_{t+1}^{\ast})-x_t^{\ast}\}
\frac{1}{\sigma_\omega}\bar r_t.
$$

$$(F26)\qquad
x_t^{\ast}=E_t(x_{t+1}^{\ast})-\frac{1}{\sigma_\omega}\{r_t^{\ast}-E_t(\pi_{F,t+1}^{\ast})\}
\frac{\omega_2}{\omega_2+1}\{E_t(x_{t+1})-x_t\}
\frac{1}{\sigma_\omega}\bar r_t^{\ast}.
$$

自然实际利率：

$$(F27)\qquad
\bar r_t=-\Theta a_t-\Omega_1a_t^{\ast},\quad
\bar r_t^{\ast}=-\Theta a_t^{\ast}-\Omega_1a_t.
$$

以产出缺口表示的边际成本：

$$(F28)\qquad
mc_{H,t}=\frac{\varsigma}{\omega_4+1}x_t+\frac{\omega_2\sigma}{\omega_4+1}x_t^{\ast}+r_t,\quad
mc_{F,t}^{\ast}=\frac{\varsigma}{\omega_4+1}x_t^{\ast}+\frac{\omega_2\sigma}{\omega_4+1}x_t+r_t^{\ast}.
$$

论文中的紧凑新凯恩斯 Phillips 曲线为：

$$(F29)\qquad
\pi_{H,t}=\beta E_t(\pi_{H,t+1})+\kappa_\omega(x_t+x_t^{\ast})+r_t,\quad
\pi_{F,t}^{\ast}=\beta E_t(\pi_{F,t+1}^{\ast})+\kappa_\omega(x_t^{\ast}+x_t)+r_t^{\ast}.
$$

`needs_review`：MMB `.mod` 使用的国内和国外 PPI 方程对 $x_t$ 和 $x_t^{\ast}$ 有不同系数，这与合并 (F22) 和 (F28) 一致，而不是 OCR 来源中写出的单一 $\kappa_\omega(x_t+x_t^{\ast})$ 系数。

## 4. Market Clearing & Identities

各国差异化商品的市场出清：

$$(F30)\qquad
Y_t(h)=C_t(h)+C_t^{\ast}(h),\quad Y_t^{\ast}(f)=C_t(f)+C_t^{\ast}(f).
$$

代入并对数线性化后的总需求：

$$(F31)\qquad
y_t=c_t+\frac{\alpha[2(1-\alpha)(\sigma\eta-1)+1]}{\sigma}s_t,\quad
y_t^{\ast}=c_t^{\ast}-\frac{\alpha[2(1-\alpha)(\sigma\eta-1)+1]}{\sigma}s_t.
$$

CPI 通胀与 PPI 通胀：

$$(F32)\qquad
\pi_t=\pi_{H,t}+\alpha(s_t-s_{t-1}),\quad
\pi_t^{\ast}=\pi_{F,t}^{\ast}-\alpha(s_t-s_{t-1}).
$$

完全市场下的 UIP：

$$(F33)\qquad
r_t-r_t^{\ast}=E_t(e_{t+1})-e_t.
$$

国际风险分享：

$$(F34)\qquad
C_t=\vartheta C_t^{\ast}Q_t^{1/\sigma}.
$$

实际汇率与贸易条件：

$$(F35)\qquad
q_t=(1-2\alpha)s_t.
$$

对数线性风险分享：

$$(F36)\qquad
c_t=c_t^{\ast}+\frac{1-2\alpha}{\sigma}s_t.
$$

以产出表示的贸易条件：

$$(F37)\qquad
s_t=\frac{\sigma}{\omega_4+1}(y_t-y_t^{\ast}).
$$

产出水平恒等式：

$$(F38)\qquad
y_t=x_t+\bar y_t,\quad y_t^{\ast}=x_t^{\ast}+\bar y_t^{\ast}.
$$

MMB 实现中使用的国内和国外 CPI 通胀恒等式：

$$(F39)\qquad
\pi_t=\pi_{H,t}+\frac{\alpha\sigma}{\omega_4+1}(x_t-x_{t-1})
-\frac{\alpha\sigma}{\omega_4+1}(x_t^{\ast}-x_{t-1}^{\ast})
+\Omega_2(a_t-a_{t-1})-\Omega_2(a_t^{\ast}-a_{t-1}^{\ast}).
$$

$$(F40)\qquad
\pi_t^{\ast}=\pi_{F,t}^{\ast}+\frac{\alpha\sigma}{\omega_4+1}(x_t^{\ast}-x_{t-1}^{\ast})
-\frac{\alpha\sigma}{\omega_4+1}(x_t-x_{t-1})
+\Omega_2(a_t^{\ast}-a_{t-1}^{\ast})-\Omega_2(a_t-a_{t-1}).
$$

`needs_review`：MinerU OCR 中与 (F39)-(F40) 对应的来源方程在 CPI 通胀公式里显示了额外的 $r_t$ 和 $r_t^{\ast}$ 项。附录 Dynare 代码和 MMB 实现均省略这些项。

价格、名义汇率、实际汇率和贸易条件恒等式：

$$(F41)\qquad
p_t=p_{t-1}+\pi_t,\quad p_t^{\ast}=p_{t-1}^{\ast}+\pi_t^{\ast}.
$$

$$(F42)\qquad
e_t=q_t-p_t^{\ast}+p_t.
$$

## 5. Exogenous Processes

带利率平滑的 Taylor 规则：

$$(F43)\qquad
r_t=\varrho r_{t-1}+(1-\varrho)(\phi_\pi\pi_t+\phi_xx_t)+m_t.
$$

$$(F44)\qquad
r_t^{\ast}=\varrho^{\ast} r_{t-1}^{\ast}+(1-\varrho^{\ast})(\phi_\pi^{\ast}\pi_t^{\ast}+\phi_x^{\ast}x_t^{\ast})+m_t^{\ast}.
$$

生产率过程：

$$(F45)\qquad
a_t=\rho a_{t-1}+\xi_t,\quad a_t^{\ast}=\rho^{\ast}a_{t-1}^{\ast}+\xi_t^{\ast}.
$$

`NK_JO15_lt` 的 MMB 模拟对国外生产率创新 $\xi_t^{\ast}$ 设定 stderr 1。货币政策创新 $m_t,m_t^{\ast}$ 和国内生产率创新 $\xi_t$ 在已检查的实现示例中被声明但未施加冲击。

## 6. Steady-State Solution

由于模型是对数线性的，`model(linear)` 块中的确定性稳态对所有偏离变量均为零：

$$(F46)\qquad
x=\pi_H=r=\pi=x^{\ast}=\pi_F^{\ast}=r^{\ast}=\pi^{\ast}=\bar r=\bar r^{\ast}=a=a^{\ast}=mc=mc^{\ast}=y=y^{\ast}=\bar y=\bar y^{\ast}=p=p^{\ast}=e=s=q=0.
$$

论文给出的水平稳态限制为：

$$(F47)\qquad
R=R^{\ast}=\beta^{-1},\quad MC_H=MC_F^{\ast}=\frac{\varepsilon-1}{\varepsilon}.
$$

$$(F48)\qquad
C=C^{\ast},\quad Q=1,\quad S=1,\quad Y=C=Y^{\ast}=C^{\ast}.
$$

低贸易 MMB 变体的校准：

$$(F49)\qquad
\alpha=0.1,\quad \beta=0.99,\quad \sigma=4.5,\quad \eta=2.5,\quad
\theta_H=0.9,\quad \theta_F=0.75,\quad \varphi=3.
$$

$$(F50)\qquad
\rho=\rho^{\ast}=0.55,\quad \phi_\pi=\phi_\pi^{\ast}=1.5,\quad
\phi_x=\phi_x^{\ast}=0.5,\quad \varrho=\varrho^{\ast}=0.4.
$$

实现中的派生系数：

$$(F51)\qquad
\omega_2=2\alpha(1-\alpha)(\sigma\eta-1),\quad
\omega_4=4\alpha(1-\alpha)(\sigma\eta-1),\quad
\psi=(\omega_4+1)(1+\varphi).
$$

$$(F52)\qquad
\varsigma=(\omega_2+1)\sigma+(\omega_4+1)\varphi,
\quad
\delta=\sigma^2(2\omega_2+1)+2\sigma\varphi(\omega_2+1)(\omega_4+1)+\varphi^2(\omega_4+1)^2.
$$

$$(F53)\qquad
\sigma_\omega=\frac{(\omega_2+1)\sigma}{\omega_4+1},\quad
\Omega_2=\frac{\alpha\sigma(1+\varphi)(\varsigma+\omega_2\sigma)}{\delta}.
$$

## 7. Timing & Form Conventions

- 模型是线性的一阶偏离系统；Dynare `model(linear)` 表示中所有状态/控制变量都以零稳态为中心。
- 本模型没有资本存量。存量时序问题仅限于预定的名义利率和价格水平：$r_{t-1}$ 和 $r_{t-1}^{\ast}$ 进入 Taylor 规则；$p_{t-1}$ 和 $p_{t-1}^{\ast}$ 进入价格水平累积；滞后产出缺口和滞后生产率进入 CPI 通胀恒等式。
- IS 曲线和 Phillips 曲线中的预期均为一期超前。
- 成本渠道通过名义利率进入边际成本，并传导至 Phillips 曲线动态。
- 论文中外国变量带星号，实现中的 Dynare-safe 名称使用 `_star`。
- 低贸易变体由 $\alpha=0.1$ 识别；同一篇论文还包含无贸易、中等贸易和高贸易模拟。

## 8. Variable & Parameter Reference Table

| 类别 | 符号 / ASCII 名称 | 含义 | 主要方程 |
|---|---|---|---|
| 内生 | $x_t$ / `x` | 国内产出缺口 | (F23), (F25), (F43) |
| 内生 | $\pi_{H,t}$ / `pi_H` | 国内 PPI 通胀 | (F22), (F29) |
| 内生 | $r_t$ / `r` | 国内名义利率偏离 | (F43) |
| 内生 | $\pi_t$ / `pi` | 国内 CPI 通胀 | (F32), (F39) |
| 内生 | $x_t^{\ast}$ / `x_star` | 国外产出缺口 | (F23), (F26), (F44) |
| 内生 | $\pi_{F,t}^{\ast}$ / `pi_F_star` | 国外 PPI 通胀 | (F22), (F29) |
| 内生 | $r_t^{\ast}$ / `r_star` | 国外名义利率偏离 | (F44) |
| 内生 | $\pi_t^{\ast}$ / `pi_star` | 国外 CPI 通胀 | (F32), (F40) |
| 内生 | $\bar r_t$ / `r_bar` | 国内自然实际利率 | (F27) |
| 内生 | $\bar r_t^{\ast}$ / `r_bar_star` | 国外自然实际利率 | (F27) |
| 内生 | $a_t$ / `a` | 国内生产率偏离 | (F45) |
| 内生 | $a_t^{\ast}$ / `a_star` | 国外生产率偏离 | (F45) |
| 内生 | $mc_{H,t}$ / `mc` | 国内实际边际成本 | (F28) |
| 内生 | $mc_{F,t}^{\ast}$ / `mc_star` | 国外实际边际成本 | (F28) |
| 内生 | $y_t$ / `y` | 国内产出偏离 | (F38) |
| 内生 | $y_t^{\ast}$ / `y_star` | 国外产出偏离 | (F38) |
| 内生 | $\bar y_t$ / `y_bar` | 国内自然产出 | (F24) |
| 内生 | $\bar y_t^{\ast}$ / `y_bar_star` | 国外自然产出 | (F24) |
| 内生 | $p_t$ / `p` | 国内价格水平 | (F41) |
| 内生 | $p_t^{\ast}$ / `p_star` | 国外价格水平 | (F41) |
| 内生 | $e_t$ / `e` | 名义汇率 | (F42) |
| 内生 | $s_t$ / `s` | 贸易条件 | (F35), (F37) |
| 内生 | $q_t$ / `q` | 实际汇率 | (F35), (F42) |
| 外生 | $m_t$ / `m` | 国内货币政策创新 | (F43) |
| 外生 | $m_t^{\ast}$ / `m_star` | 国外货币政策创新 | (F44) |
| 外生 | $\xi_t$ / `xi` | 国内生产率创新 | (F45) |
| 外生 | $\xi_t^{\ast}$ / `xi_star` | 国外生产率创新 | (F45) |
| 参数 | $\sigma$ / `sigma` | 相对风险厌恶系数 | (F1), (F21) |
| 参数 | $\eta$ / `eta` | 本国产品与外国产品之间的替代弹性 | (F2), (F3) |
| 参数 | $\beta$ / `beta` | 贴现因子 | (F1), (F19), (F47) |
| 参数 | $\theta_H,\theta_F$ / `theta_H`, `theta_F` | Calvo 价格黏性概率 | (F16), (F17), (F22) |
| 参数 | $\alpha$ / `alpha` | 贸易开放度；低贸易取值 0.1 | (F2), (F8), (F49) |
| 参数 | $\varphi$ / `varphi` | Frisch 弹性倒数/劳动曲率 | (F1), (F20) |
| 参数 | $\kappa_H,\kappa_F$ / `kappa_H`, `kappa_F` | Phillips 曲线斜率 | (F22) |
| 参数 | $\omega_2,\omega_4$ / `omega_2`, `omega_4` | 开放度复合项 | (F51) |
| 参数 | $\psi,\varsigma,\delta,\sigma_\omega,\Omega_2$ / `psi`, `varsigma`, `delta`, `sigma_omega`, `oomega_2` | 派生复合参数 | (F51)-(F53) |
| 参数 | $\rho,\rho^{\ast}$ / `rho`, `rho_star` | 生产率持续性 | (F45), (F50) |
| 参数 | $\phi_\pi,\phi_\pi^{\ast},\phi_x,\phi_x^{\ast}$ / `phi_pi`, `phi_pi_star`, `phi_x`, `phi_x_star` | Taylor 规则反应系数 | (F43), (F44) |
| 参数 | $\varrho,\varrho^{\ast}$ / `varrho`, `varrho_star` | 利率平滑 | (F43), (F44) |
