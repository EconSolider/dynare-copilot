# HK_FPP11 -- 推导（最优化问题 + 一阶条件）

> 档案状态：`needs_review`。本首轮推导基于 Funke、Paetz 和 Pytlarczyk (2011) 的 MinerU Markdown，尚未在 Dynare 中做运行验证。
> 来源：model_id `HK_FPP11`；论文 "Stock market wealth effects in an estimated DSGE model for Hong Kong"；作者 Michael Funke、Michael Paetz、Ernest Pytlarczyk；年份 2011；DOI `10.1016/j.econmod.2010.08.016`；来源 Markdown `raw/mmb_mineru/runs/hk_fpp11__stock_market_wealth_effects_in_an_estimated_dsge_model_for_hong_kong__24bfe42d/full.md`；原始 PDF `raw/mmb_papers/Stock market wealth effects in an estimated DSGE model for Hong Kong.pdf`；MinerU run id `24bfe42d-832c-4187-85cd-31bab6f55223`。

## 1. Model Overview

- **模型**：面向香港的估计型小开放经济新凯恩斯 DSGE 模型，包含股票市场财富效应和汇率钉住制度。
- **实验**：对 1981Q1-2007Q3 的香港产出、股票价格、CPI 通胀和外国需求季度数据进行贝叶斯估计与随机模拟。
- **主体与模块**：永续青年家庭选择消费、劳动、状态依存债券和股票；垄断竞争中间品企业以 Calvo 机制错峰定价；最终品企业聚合差异化产品；货币政策是维持固定汇率所需的利率调整。
- **形式**：`model(linear)` / 对数线性规范形式。小写变量表示相对于对称零通胀稳态的偏离。本文保留能够导出线性均衡的非线性基础。
- **首轮不确定性**：Markdown 中若干参数定义存在 OCR 敏感符号，特别是规范形式系数中的希腊字母，标记为 `needs_review`。

## 2. Optimization Problems

### 2.1 永续青年家庭

每个世代 $j$ 面临死亡概率 $\gamma$，并选择消费、劳动、本国外国状态依存债券以及股票持有：

$$
\max_{\{C_t(j),N_t(j),B_{t+1}(j),B^i_{t+1}(j),Z_{t+1}(k,j)\}}
E_0\sum_{t=0}^{\infty}\beta^t(1-\gamma)^t
\left[\log C_t(j)+\log(1-N_t(j))\right].
$$

实际预算约束为

$$
\begin{aligned}
C_t(j)&+\frac{1}{P_t}E_t\{F_{t,t+1}B_{t+1}(j)\}
+\int_0^1\frac{\Xi_t^i}{P_t}E_t\{F_{t,t+1}B^i_{t+1}(j)\}\,di \\
&+\frac{1}{P_t}\int_0^1 Q_t(k)Z_{t+1}(k,j)\,dk
=\frac{W_t}{P_t}N_t(j)-T_t(j)+\frac{\Omega_t(j)}{P_t}.
\end{aligned}
$$

名义金融财富为

$$
\Omega_t(j)=\frac{1}{1-\gamma}
\left[
B_t(j)+\int_0^1\Xi_t^iB_t^i(j)\,di
+\int_0^1\big(Q_t(k)+D_t(k)\big)Z_t(k,j)\,dk
\right].
$$

### 2.2 期内消费配置

家庭消费国内品和进口品的 CES 聚合：

$$
C_t(j)=\left[(1-\alpha)^{1/\varpi}C_{H,t}(j)^{(\varpi-1)/\varpi}
+\alpha^{1/\varpi}C_{F,t}(j)^{(\varpi-1)/\varpi}\right]^{\varpi/(\varpi-1)}.
$$

相应 CPI 为

$$
P_t=\left[(1-\alpha)P_{H,t}^{1-\varpi}+\alpha P_{F,t}^{1-\varpi}\right]^{1/(1-\varpi)}.
$$

### 2.3 中间品企业

中间品企业 $k$ 采用线性技术：

$$
Y_t(k)=A_tN_t(k),
$$

实际边际成本为

$$
MC_t=(1-\vartheta)\frac{W_t}{P_{H,t}A_t}\exp(\mu_t^p).
$$

前瞻型定价企业求解 Calvo 问题：

$$
\max_{\{P_{H,t}(k)\}}\;
E_t\sum_{i=0}^{\infty}\theta^i\Delta_{i,t+i}
\left[
\frac{P_{H,t}(k)}{P_{H,t+i}}Y_{t+i}(k)-MC_{t+i}Y_{t+i}(k)
\right].
$$

后顾型定价企业采用经验规则：

$$
p^{bl}_{H,t}=\bar p^n_{H,t-1}+\pi_{H,t-1}.
$$

## 3. First-Order Conditions

- **(F1) 家庭劳动-闲暇边际条件**：

$$
\frac{C_t(j)}{1-N_t(j)}=\frac{W_t}{P_t}.
$$

- **(F2) 随机贴现因子 / 欧拉条件**：

$$
F_{t,t+1}=\beta E_t\left[
\frac{P_t}{P_{t+1}}\frac{C_t(j)}{C_{t+1}(j)}
\right].
$$

- **(F3) 股票定价条件**：

$$
Q_t(k)=E_t\left\{F_{t,t+1}\left[Q_{t+1}(k)+D_{t+1}(k)\right]\right\}.
$$

- **(F4) 本国一期债券无套利条件**：

$$
(1+r_t)E_t\{F_{t,t+1}\}=1.
$$

- **(F5) 总量财富-消费条件**：

$$
P_tC_t=\left[1-\beta(1-\gamma)\right](\Omega_t+H_t).
$$

- **(F6) 含财富效应的总量消费规律**：

$$
\beta P_tC_t=\frac{\gamma}{1-\gamma}E_t\{F_{t,t+1}\Omega_{t+1}\}
+\left[1-\beta(1-\gamma)\right]E_t\{F_{t,t+1}P_{t+1}C_{t+1}\}.
$$

- **(F7) 含股票财富效应的规范动态 IS 方程**：

$$
x_t=\frac{\sigma_{\alpha}}{\Gamma_0}E_tx_{t+1}
+\frac{\Psi}{\Gamma_0}\widehat q_t
-\frac{1}{\Gamma_0}\left(r_t-E_t\pi_{H,t+1}-rr_t^n\right).
$$

- **(F8) 股票价格缺口动态**：

$$
\widehat q_t=\frac{\tilde\beta}{1+\epsilon}E_t\widehat q_{t+1}
-\frac{\lambda_q}{1+\epsilon}E_tx_{t+1}
-\left(r_t-E_t\pi_{H,t+1}-rr_t^n\right)+\eta_t.
$$

- **(F9) 混合新凯恩斯 Phillips 曲线**：

$$
\pi_{H,t}=\phi\left(\theta\tilde\beta E_t\pi_{H,t+1}+\tau\pi_{H,t-1}\right)
+\kappa_{\alpha}x_t+\varepsilon_t^{\mu}.
$$

- **(F10) 汇率钉住下的货币政策闭合**：

$$
r_t=\phi_{\pi}\pi_{H,t}+\phi_xx_t.
$$

论文将汇率钉住 $e_t=0$ 作为政策目标；MMB 实现交叉检查使用上述简单估计反应规则，且 $\phi_x=0$。

## 4. Market Clearing & Identities

- **(F11) 来自风险分担和需求聚合的贸易条件/产出关系**：

$$
s_t=\sigma_{\alpha}(y_t-y_t^*).
$$

- **(F12) 自然产出**：

$$
y_t^n=\Gamma_a a_t-\alpha\Gamma_{y^*}y_t^*.
$$

- **(F13) 产出缺口定义**：

$$
x_t=y_t-y_t^n.
$$

- **(F14) CPI 通胀恒等式**：

$$
\pi_t=\pi_{H,t}+\alpha(s_t-s_{t-1}).
$$

- **(F15) PPP 与钉住制度下的汇率/贸易条件恒等式**：

$$
e_t-e_{t-1}=s_t-s_{t-1}+\pi_{H,t}.
$$

在钉住制度 $e_t=0$ 下，这意味着 $\Delta s_t=-\pi_{H,t}$。

- **(F16) 自然利率**：

$$
\begin{aligned}
rr_t^n={}&\rho+\left[\sigma_{\alpha}\rho_a+\Psi-\Gamma_0\right]\Gamma_a a_t \\
&+\left[\left(\sigma_{\alpha}\rho_{y^*}+\Psi-\Gamma_0\right)\Gamma_{y^*}
+\Theta\sigma_{\alpha}(\rho_{y^*}-1)\right]\alpha y_t^*.
\end{aligned}
$$

## 5. Exogenous Processes

- **(F17) 本国生产率**：

$$
a_t=\rho_a a_{t-1}+\varepsilon_t^a.
$$

- **(F18) 外国需求**：

$$
y_t^*=\rho_{y^*}y_{t-1}^*+\varepsilon_t^{y^*}.
$$

- **(F19) 股票价格缺口扰动**：

$$
\eta_t=\rho_{\eta}\eta_{t-1}+\varepsilon_t^{\eta}.
$$

- **(F20) 成本推动冲击**：

$$
\mu_t^p=\varepsilon_t^{\mu}.
$$

## 6. Steady-State Solution

实现系统围绕对称零通胀稳态线性化：

$$
\bar e=0,\quad \bar s=0,\quad \bar \pi_H=0,\quad \bar \pi=0,\quad
\bar x=0,\quad \bar{\widehat q}=0,\quad \bar a=0,\quad \bar y^*=0,\quad
\bar \eta=0,\quad \bar \mu^p=0.
$$

论文给出的稳态关系包括：

$$
Q+D=(1+r)Q(1+\epsilon),
$$

$$
Y=AN,
$$

$$
MC=\frac{1}{1+\mu},
$$

$$
D=\frac{\mu}{1+\mu}\frac{P_H}{P}Y.
$$

对于 MMB 线性实现，模型偏离变量的稳态值均为零。未执行运行验证。

## 7. Timing & Form Conventions

- 本档案条目对应 `model(linear)` 表示。
- $x_t$、$\widehat q_t$、$r_t$、$rr_t^n$、$\pi_{H,t}$、$s_t$、$e_t$、$y_t$、$y_t^n$、$a_t$、$y_t^*$ 和 $\eta_t$ 是相对稳态的对数或百分比偏离。
- 股票价格缺口为 $\widehat q_t=q_t-q_t^n$，自然股票价格满足 $q_t^n=y_t^n$。
- Phillips 曲线包含生产者价格通胀的一个前瞻项和一个滞后项。
- 动态 IS 方程和股票价格缺口方程是前瞻的。
- 除成本推动创新直接进入 Phillips 曲线外，冲击过程均为一阶自回归。
- 原始 PDF 已确认存在，但未打开正文做公式级核查；不确定 OCR 符号记录在 `extraction_notes.md` 中。

## 8. Variable & Parameter Reference Table

| 类别 | 符号 / ASCII 名 | 含义 | 方程 |
|---|---|---|---|
| 内生 | `x`, $x_t$ | 本国产出缺口 | (F7), (F13) |
| 内生 | `q_dach`, $\widehat q_t$ | 股票价格缺口 | (F8) |
| 内生 | `r`, $r_t$ | 名义政策利率偏离 | (F10) |
| 内生 | `rr`, $rr_t^n$ | 自然实际利率 | (F16) |
| 内生 | `pi_H`, $\pi_{H,t}$ | 生产者价格通胀 | (F9) |
| 内生 | `pi`, $\pi_t$ | 消费者价格通胀 | (F14) |
| 内生 | `s`, $s_t$ | 有效贸易条件 | (F11), (F15) |
| 内生 | `e`, $e_t$ | 名义有效汇率 | (F15) |
| 内生 | `y`, $y_t$ | 本国产出 | (F13) |
| 内生 | `y_n`, $y_t^n$ | 自然产出 | (F12) |
| 内生 | `a`, $a_t$ | 生产率状态 | (F17) |
| 内生 | `y_stern`, $y_t^*$ | 外国需求/产出 | (F18) |
| 内生 | `shock_eta`, $\eta_t$ | 股票价格缺口状态 | (F19) |
| 外生 | `epsa`, $\varepsilon_t^a$ | 生产率创新 | (F17) |
| 外生 | `epsy`, $\varepsilon_t^{y^*}$ | 外国需求创新 | (F18) |
| 外生 | `epseta`, $\varepsilon_t^{\eta}$ | 股票价格缺口创新 | (F19) |
| 外生 | `mu_p`, $\varepsilon_t^{\mu}$ | 成本推动创新 | (F9), (F20) |
| 参数 | $\gamma$ | 死亡概率 / 财富效应参数 | (F5)-(F8) |
| 参数 | $\alpha$ | 开放度 / 进口份额 | (F11), (F12), (F14), (F16) |
| 参数 | $\theta$ | Calvo 不重新定价概率 | (F9) |
| 参数 | $\tau$ | 后顾型定价份额 | (F9) |
| 参数 | $\beta$, $\tilde\beta$ | 家庭贴现因子 / 稳态贴现因子 | (F2), (F8), (F9) |
| 参数 | $\epsilon$ | 股票收益风险溢价协方差 | (F8) |
| 参数 | $\Psi$ | 财富效应系数 | (F7), (F16) |
| 参数 | $\Gamma_0,\Gamma_a,\Gamma_{y^*},\Theta$ | 小开放经济复合系数 | (F7), (F12), (F16) |
| 参数 | $\lambda_q,\kappa_{\alpha},\phi$ | 股票价格和 Phillips 曲线斜率 | (F8), (F9) |
| 参数 | $\phi_{\pi},\phi_x$ | 利率反应系数 | (F10) |
| 参数 | $\rho_a,\rho_{y^*},\rho_{\eta}$ | 冲击持续性参数 | (F16)-(F19) |

方程数：20 个编号条件，(F1)-(F20)。运行验证：未执行。
