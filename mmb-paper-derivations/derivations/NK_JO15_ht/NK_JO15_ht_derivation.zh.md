# NK_JO15_ht - 推导（最优化问题 + 一阶条件）

> `NK_JO15_ht` 的模型档案草稿。未执行运行时验证。公式提取基于 MinerU Markdown 来源；凡 OCR 或论文-代码差异会影响精确转录的位置均标记为 `needs_review`。

## 1. Model Overview

- **模型**：`NK_JO15_ht`，Jang and Okano (2015) "Productivity Shocks and Monetary Policy in a Two-Country Model" 的高贸易校准。
- **来源与出处**：主要 Markdown `raw/mmb_mineru/runs/nk_jo15_ht_nk_jo15_lt__productivity_shocks_and_monetary_policy_in_a_two_country_model__f031feec/full.md`；原始 PDF `raw/mmb_papers/Productivity Shocks and Monetary Policy in a Two-Country Model.pdf`；MinerU run id `f031feec-a81e-43ec-ac7a-f89bd2d73785`；DOI `10.1016/j.jpolmod.2015.03.017`。
- **变体**：高贸易水平，MMB 实现中贸易开放度为 `\alpha=0.9`。论文研究多个贸易开放情形 `\alpha \in \{0,0.1,0.6,0.9\}`；本条目记录高贸易情形。
- **主体**：H 国和 F 国的代表性家庭；具有 Calvo-Yun 定价和 Ravenna-Walsh 成本渠道的垄断竞争差异化产品厂商；遵循 Taylor 规则的各国货币当局。
- **模型形式**：围绕确定性稳态的对数线性 `model(linear)` 系统。小写变量为相对稳态的百分比偏离或对数偏离，但利率变量表示总名义利率的偏离。
- **核心机制**：外国生产率通过国际风险分担和成本渠道影响自然产出、贸易条件、CPI/PPI 通胀、实际汇率和货币政策。
- **状态**：`needs_review`；论文侧 Markdown 可用，但 Appendix C 和内嵌 Dynare 代码中的若干 OCR 方程存在空格和下标损坏。

## 2. Optimization Problems

### 2.1 家庭

两国居民最大化预期终身效用：

**(F1) Household objectives**

$$
\mathcal{U}=E_0\sum_{t=0}^{\infty}\beta^t
\left[\frac{C_t^{1-\sigma}}{1-\sigma}-\frac{N_t^{1+\varphi}}{1+\varphi}\right],
\qquad
\mathcal{U}^{\ast}=E_0\sum_{t=0}^{\infty}\beta^t
\left[\frac{(C_t^{\ast})^{1-\sigma}}{1-\sigma}-\frac{(N_t^{\ast})^{1+\varphi}}{1+\varphi}\right].
$$

**(F2) Home and foreign consumption aggregators**

$$
C_t=\left[(1-\alpha)^{1/\eta}C_{H,t}^{(\eta-1)/\eta}
+\alpha^{1/\eta}C_{F,t}^{(\eta-1)/\eta}\right]^{\eta/(\eta-1)},
$$

$$
C_t^{\ast}=\left[(1-\alpha)^{1/\eta}(C_{F,t}^{\ast})^{(\eta-1)/\eta}
+\alpha^{1/\eta}(C_{H,t}^{\ast})^{(\eta-1)/\eta}\right]^{\eta/(\eta-1)}.
$$

**(F3) Household nominal budget constraints**

$$
P_t C_t+E_t(Q_{t,t+1}D_{t+1}^{n})\le D_t^n+W_tN_t+TR_t,
$$

$$
P_t^{\ast}C_t^{\ast}+E_t(Q_{t,t+1}^{\ast}D_{t+1}^{n\ast})\le D_t^{n\ast}+W_t^{\ast}N_t^{\ast}+TR_t^{\ast}.
$$

### 2.2 商品需求与价格指数

**(F4) Within-origin differentiated-goods demand**

$$
C_t(h)=\left(\frac{P_t(h)}{P_{H,t}}\right)^{-\varepsilon}C_{H,t},
\quad
C_t(f)=\left(\frac{P_t(f)}{P_{F,t}}\right)^{-\varepsilon}C_{F,t},
$$

$$
C_t^{\ast}(h)=\left(\frac{P_t^{\ast}(h)}{P_{H,t}^{\ast}}\right)^{-\varepsilon}C_{H,t}^{\ast},
\quad
C_t^{\ast}(f)=\left(\frac{P_t^{\ast}(f)}{P_{F,t}^{\ast}}\right)^{-\varepsilon}C_{F,t}^{\ast}.
$$

**(F5) Home/foreign-good allocation**

$$
C_{H,t}=(1-\alpha)\left(\frac{P_{H,t}}{P_t}\right)^{-\eta}C_t,
\quad
C_{F,t}=\alpha\left(\frac{P_{F,t}}{P_t}\right)^{-\eta}C_t,
$$

$$
C_{H,t}^{\ast}=\alpha\left(\frac{P_{H,t}^{\ast}}{P_t^{\ast}}\right)^{-\eta}C_t^{\ast},
\quad
C_{F,t}^{\ast}=(1-\alpha)\left(\frac{P_{F,t}^{\ast}}{P_t^{\ast}}\right)^{-\eta}C_t^{\ast}.
$$

**(F6) CPI indices**

$$
P_t=\left[(1-\alpha)P_{H,t}^{1-\eta}+\alpha P_{F,t}^{1-\eta}\right]^{1/(1-\eta)},
$$

$$
P_t^{\ast}=\left[(1-\alpha)(P_{F,t}^{\ast})^{1-\eta}+\alpha(P_{H,t}^{\ast})^{1-\eta}\right]^{1/(1-\eta)}.
$$

### 2.3 厂商

每个国家的典型厂商用线性劳动技术生产差异化产品：

**(F7) Firm production technologies**

$$
Y_t(h)=A_tN_t(h),
\qquad
Y_t^{\ast}(f)=A_t^{\ast}N_t^{\ast}(f).
$$

Calvo-Yun 定价厂商在获得重设价格机会时最大化预期贴现利润。来源直接给出最优重设价格：

**(F8) Calvo reset-price optimality, needs_review**

$$
\widetilde{P}_{H,t}
=E_t\left[
\frac{\sum_{k=0}^{\infty}\theta^k Q_{t,t+k}Y_{t+k}
\frac{\varepsilon}{\varepsilon-1}P_{H,t+k}MC_{H,t+k}}
{\sum_{k=0}^{\infty}\theta^k Q_{t,t+k}Y_{t+k}}
\right],
$$

$$
\widetilde{P}_{F,t}^{\ast}
=E_t\left[
\frac{\sum_{k=0}^{\infty}\theta^k Q_{t,t+k}^{\ast}Y_{F,t+k}
\frac{\varepsilon}{\varepsilon-1}P_{F,t+k}^{\ast}MC_{F,t+k}^{\ast}}
{\sum_{k=0}^{\infty}\theta^k Q_{t,t+k}^{\ast}Y_{F,t+k}}
\right].
$$

`needs_review` 标记反映了外国输出项附近的 OCR 歧义，以及论文同时用 `Q` 表示随机贴现因子和实际汇率的问题。

## 3. First-Order Conditions

**(F9) Intertemporal Euler equations**

$$
\beta E_t\left(\frac{C_{t+1}^{-\sigma}P_t}{C_t^{-\sigma}P_{t+1}}\right)=\frac{1}{R_t},
\qquad
\beta E_t\left(\frac{(C_{t+1}^{\ast})^{-\sigma}P_t^{\ast}}{(C_t^{\ast})^{-\sigma}P_{t+1}^{\ast}}\right)=\frac{1}{R_t^{\ast}}.
$$

**(F10) Intratemporal labor supply**

$$
C_t^{\sigma}N_t^{\varphi}=\frac{W_t}{P_t},
\qquad
(C_t^{\ast})^{\sigma}(N_t^{\ast})^{\varphi}=\frac{W_t^{\ast}}{P_t^{\ast}}.
$$

**(F11) Log-linear consumption Euler equations**

$$
c_t=E_t(c_{t+1})-\frac{1}{\sigma}\left\{\hat r_t-E_t(\pi_{t+1})\right\},
\qquad
c_t^{\ast}=E_t(c_{t+1}^{\ast})-\frac{1}{\sigma}\left\{\hat r_t^{\ast}-E_t(\pi_{t+1}^{\ast})\right\}.
$$

**(F12) Log-linear New Keynesian IS curves in output**

$$
y_t=E_t(y_{t+1})-\frac{1}{\sigma_{\omega}}\left\{\hat r_t-E_t(\pi_{H,t+1})\right\}
+\frac{\omega_2}{\omega_2+1}E_t(y_{t+1}^{\ast}-y_t^{\ast}),
$$

$$
y_t^{\ast}=E_t(y_{t+1}^{\ast})-\frac{1}{\sigma_{\omega}}\left\{\hat r_t^{\ast}-E_t(\pi_{F,t+1}^{\ast})\right\}
+\frac{\omega_2}{\omega_2+1}E_t(y_{t+1}-y_t).
$$

**(F13) Output-gap IS curves**

$$
x_t=E_t(x_{t+1})-\frac{1}{\sigma_{\omega}}\left\{\hat r_t-E_t(\pi_{H,t+1})\right\}
+\frac{\omega_2}{\omega_2+1}\left\{E_t(x_{t+1}^{\ast})-x_t^{\ast}\right\}
+\frac{1}{\sigma_{\omega}}\bar r_t,
$$

$$
x_t^{\ast}=E_t(x_{t+1}^{\ast})-\frac{1}{\sigma_{\omega}}\left\{\hat r_t^{\ast}-E_t(\pi_{F,t+1}^{\ast})\right\}
+\frac{\omega_2}{\omega_2+1}\left\{E_t(x_{t+1})-x_t\right\}
+\frac{1}{\sigma_{\omega}}\bar r_t^{\ast}.
$$

**(F14) Real marginal costs**

$$
mc_{H,t}=\frac{\varsigma}{\omega_4+1}x_t+\frac{\omega_2\sigma}{\omega_4+1}x_t^{\ast}+r_t,
\qquad
mc_{F,t}^{\ast}=\frac{\varsigma}{\omega_4+1}x_t^{\ast}+\frac{\omega_2\sigma}{\omega_4+1}x_t+r_t^{\ast}.
$$

**(F15) PPI Phillips curves**

$$
\pi_{H,t}=\beta E_t(\pi_{H,t+1})+\kappa_H\frac{\varsigma}{\omega_4+1}x_t
+\kappa_H\frac{\omega_2\sigma}{\omega_4+1}x_t^{\ast}
+\kappa_H r_t,
$$

$$
\pi_{F,t}^{\ast}=\beta E_t(\pi_{F,t+1}^{\ast})+\kappa_F\frac{\varsigma}{\omega_4+1}x_t^{\ast}
+\kappa_F\frac{\omega_2\sigma}{\omega_4+1}x_t
+\kappa_F r_t^{\ast}.
$$

论文还报告了带 `\kappa_{\omega}` 的紧凑对称形式；MMB 实现使用国家特定的 `\kappa_H` 和 `\kappa_F`，与 `\theta_H \ne \theta_F` 一致。

## 4. Market Clearing & Identities

**(F16) Goods-market clearing**

$$
Y_t(h)=C_t(h)+C_t^{\ast}(h),
\qquad
Y_t^{\ast}(f)=C_t(f)+C_t^{\ast}(f).
$$

**(F17) Aggregate output and consumption**

$$
y_t=c_t+\frac{\alpha[2(1-\alpha)(\sigma\eta-1)+1]}{\sigma}s_t,
\qquad
y_t^{\ast}=c_t^{\ast}-\frac{\alpha[2(1-\alpha)(\sigma\eta-1)+1]}{\sigma}s_t.
$$

**(F18) Terms of trade and real exchange rate**

$$
s_t=\frac{\sigma}{\omega_4+1}(y_t-y_t^{\ast}),
\qquad
q_t=(1-2\alpha)s_t.
$$

**(F19) CPI/PPI inflation identities**

$$
\pi_t=\pi_{H,t}+\frac{\alpha\sigma}{\omega_4+1}(x_t-x_{t-1})
-\frac{\alpha\sigma}{\omega_4+1}(x_t^{\ast}-x_{t-1}^{\ast})
+\Omega_2(a_t-a_{t-1})-\Omega_2(a_t^{\ast}-a_{t-1}^{\ast}),
$$

$$
\pi_t^{\ast}=\pi_{F,t}^{\ast}+\frac{\alpha\sigma}{\omega_4+1}(x_t^{\ast}-x_{t-1}^{\ast})
-\frac{\alpha\sigma}{\omega_4+1}(x_t-x_{t-1})
+\Omega_2(a_t^{\ast}-a_{t-1}^{\ast})-\Omega_2(a_t-a_{t-1}).
$$

**(F20) Natural output and output gaps**

$$
x_t=y_t-\bar y_t,
\qquad
x_t^{\ast}=y_t^{\ast}-\bar y_t^{\ast},
$$

$$
\bar y_t=\frac{\varsigma\psi}{\delta}a_t-\frac{\omega_2\sigma\psi}{\delta}a_t^{\ast},
\qquad
\bar y_t^{\ast}=\frac{\varsigma\psi}{\delta}a_t^{\ast}-\frac{\omega_2\sigma\psi}{\delta}a_t.
$$

**(F21) Natural real interest rates**

$$
\bar r_t=-\Theta a_t-\Omega_1 a_t^{\ast},
\qquad
\bar r_t^{\ast}=-\Theta a_t^{\ast}-\Omega_1 a_t.
$$

**(F22) Price-level and exchange-rate accounting**

$$
p_t=p_{t-1}+\pi_t,
\qquad
p_t^{\ast}=p_{t-1}^{\ast}+\pi_t^{\ast},
\qquad
e_t=q_t-p_t^{\ast}+p_t.
$$

## 5. Exogenous Processes

**(F23) Productivity processes**

$$
a_t=\rho a_{t-1}+\xi_t,
\qquad
a_t^{\ast}=\rho^{\ast}a_{t-1}^{\ast}+\xi_t^{\ast}.
$$

**(F24) Monetary policy rules**

$$
\hat r_t=\varrho \hat r_{t-1}+(1-\varrho)(\phi_{\pi}\pi_t+\phi_x x_t)+m_t,
$$

$$
\hat r_t^{\ast}=\varrho^{\ast}\hat r_{t-1}^{\ast}+(1-\varrho^{\ast})(\phi_{\pi}^{\ast}\pi_t^{\ast}+\phi_x^{\ast}x_t^{\ast})+m_t^{\ast}.
$$

MMB 高贸易模拟冲击 `\xi_t^{*}`，并在报告的外国生产率实验中将货币政策创新设为零。

## 6. Steady-State Solution

论文中的确定性稳态令生产者通胀率为一、生产率水平为一，并令所有对数偏离变量为零：

$$
\Pi_H=\Pi_F=1,
\qquad
A_H=A_N=A_F=A_N^{\ast}=1.
$$

总名义利率满足：

$$
R=R^{\ast}=\beta^{-1}.
$$

厂商 FONC 意味着稳态边际成本为：

$$
MC_H=MC_F=\frac{\varepsilon-1}{\varepsilon}.
$$

当 `\vartheta=1` 时，风险分担条件给出：

$$
C=C^{\ast},
\qquad
Q=1.
$$

PPP 在该确定性稳态成立，两国价格水平相等，贸易条件为常数：

$$
P_H=P_F,
\qquad
S=1.
$$

市场出清意味着：

$$
Y=C=Y^{\ast}=C^{\ast}.
$$

对于对数线性 MMB 实现，内生状态/控制变量的操作性稳态均为零：

$$
x=\pi_H=r=\pi=x^{\ast}=\pi_F^{\ast}=r^{\ast}=\pi^{\ast}=\bar r=\bar r^{\ast}=a=a^{\ast}=mc=mc^{\ast}=y=y^{\ast}=\bar y=\bar y^{\ast}=p=p^{\ast}=e=s=q=0.
$$

## 7. Timing & Form Conventions

- **线性化**：`model(linear)`；实现中的变量是平稳的稳态偏离。
- **预期**：推导中用 `E_t(\cdot)` 表示前瞻变量，实现中用 `(+1)` 表示。
- **存量变量**：该论文模型在约化形式中没有资本存量或债券存量状态。预定状态包括滞后利率、滞后价格水平、CPI 恒等式中的滞后产出缺口，以及 AR(1) 生产率状态。
- **贸易开放度**：`NK_JO15_ht` 固定 `\alpha=0.9`；配对的低贸易条目使用相同方程但设定 `\alpha=0.1`。
- **通胀约定**：`\pi_H` 和 `\pi_F^{*}` 是 PPI 通胀；`\pi` 和 `\pi^{*}` 是 CPI 通胀。MMB `.mod` 用 `pi_F_star` 表示外国 PPI 通胀，用 `pi_star` 表示外国 CPI 通胀。
- **运行时验证**：本档案条目未执行。

## 8. Variable & Parameter Reference Table

### 内生变量

| ASCII name | Mathematical symbol | 含义 | 主要方程 |
|---|---:|---|---|
| `x` | $x_t$ | 本国产出缺口 | (F13), (F20) |
| `pi_H` | $\pi_{H,t}$ | 本国 PPI 通胀 | (F15) |
| `r` | $\hat r_t$ | 本国名义利率偏离 | (F24) |
| `pi` | $\pi_t$ | 本国 CPI 通胀 | (F19) |
| `x_star` | $x_t^{\ast}$ | 外国产出缺口 | (F13), (F20) |
| `pi_F_star` | $\pi_{F,t}^{\ast}$ | 外国 PPI 通胀 | (F15) |
| `r_star` | $\hat r_t^{\ast}$ | 外国名义利率偏离 | (F24) |
| `pi_star` | $\pi_t^{\ast}$ | 外国 CPI 通胀 | (F19) |
| `r_bar` | $\bar r_t$ | 本国自然实际利率 | (F21) |
| `r_bar_star` | $\bar r_t^{\ast}$ | 外国自然实际利率 | (F21) |
| `a` | $a_t$ | 本国生产率偏离 | (F23) |
| `a_star` | $a_t^{\ast}$ | 外国生产率偏离 | (F23) |
| `mc` | $mc_{H,t}$ | 本国实际边际成本 | (F14) |
| `mc_star` | $mc_{F,t}^{\ast}$ | 外国实际边际成本 | (F14) |
| `y` | $y_t$ | 本国产出偏离 | (F17), (F20) |
| `y_star` | $y_t^{\ast}$ | 外国产出偏离 | (F17), (F20) |
| `y_bar` | $\bar y_t$ | 本国自然产出 | (F20) |
| `y_bar_star` | $\bar y_t^{\ast}$ | 外国自然产出 | (F20) |
| `p` | $p_t$ | 本国 CPI 价格水平偏离 | (F22) |
| `p_star` | $p_t^{\ast}$ | 外国 CPI 价格水平偏离 | (F22) |
| `e` | $e_t$ | 名义汇率对数偏离 | (F22) |
| `s` | $s_t$ | 贸易条件 | (F18) |
| `q` | $q_t$ | 实际汇率 | (F18) |

### 外生冲击

| ASCII name | Mathematical symbol | 含义 |
|---|---:|---|
| `m` | $m_t$ | 本国货币政策创新 |
| `m_star` | $m_t^{\ast}$ | 外国货币政策创新 |
| `xi` | $\xi_t$ | 本国生产率创新 |
| `xi_star` | $\xi_t^{\ast}$ | 外国生产率创新 |

### 参数

| ASCII name | Symbol | 含义 | 高贸易值或定义 |
|---|---:|---|---|
| `sigma` | $\sigma$ | 相对风险厌恶 | 4.5 |
| `eta` | $\eta$ | 本国/外国商品替代弹性 | 2.5 |
| `beta` | $\beta$ | 贴现因子 | 0.99 |
| `theta_H` | $\theta_H$ | 本国 Calvo 不重设概率 | 0.9 |
| `theta_F` | $\theta_F$ | 外国 Calvo 不重设概率 | 0.75 |
| `alpha` | $\alpha$ | 贸易开放度 | 0.9 |
| `varphi` | $\varphi$ | Frisch 弹性倒数/劳动负效用曲率 | 3 |
| `kappa_H` | $\kappa_H$ | 本国 Phillips 曲线斜率原始项 | $(1-\theta_H)(1-\theta_H\beta)/\theta_H$ |
| `kappa_F` | $\kappa_F$ | 外国 Phillips 曲线斜率原始项 | $(1-\theta_F)(1-\theta_F\beta)/\theta_F$ |
| `omega_2` | $\omega_2$ | 贸易复合项 | $2\alpha(1-\alpha)(\sigma\eta-1)$ |
| `omega_4` | $\omega_4$ | 贸易复合项 | $4\alpha(1-\alpha)(\sigma\eta-1)$ |
| `psi` | $\psi$ | 自然产出复合项 | $(\omega_4+1)(1+\varphi)$ |
| `varsigma` | $\varsigma$ | 边际成本复合项 | $(\omega_2+1)\sigma+(\omega_4+1)\varphi$ |
| `delta` | $\delta$ | 自然产出分母 | $\sigma^2(2\omega_2+1)+2\sigma\varphi(\omega_2+1)(\omega_4+1)+(\omega_4+1)^2\varphi^2$ |
| `sigma_omega` | $\sigma_{\omega}$ | 开放经济 IS 弹性复合项 | $(\omega_2+1)\sigma/(\omega_4+1)$ |
| `oomega_2` | $\Omega_2$ | CPI 通胀/生产率复合项 | $\alpha\sigma(1+\varphi)(\varsigma+\omega_2\sigma)/\delta$ |
| `rho` | $\rho$ | 本国生产率持续性 | 0.55 in implementation cross-check |
| `rho_star` | $\rho^{\ast}$ | 外国生产率持续性 | 0.55 |
| `phi_pi` | $\phi_{\pi}$ | 本国通胀反应 | 1.5 |
| `phi_pi_star` | $\phi_{\pi}^{\ast}$ | 外国通胀反应 | 1.5 |
| `phi_x` | $\phi_x$ | 本国产出缺口反应 | 0.5 |
| `phi_x_star` | $\phi_x^{\ast}$ | 外国产出缺口反应 | 0.5 |
| `varrho` | $\varrho$ | 本国利率平滑 | 0.4 |
| `varrho_star` | $\varrho^{\ast}$ | 外国利率平滑 | 0.4 |
