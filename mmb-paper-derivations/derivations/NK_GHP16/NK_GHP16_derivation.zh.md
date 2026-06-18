# NK_GHP16 -- 推导（最优化问题 + 一阶条件）

> 私有 MMB 档案草稿。未执行运行时验证。

来源：Gnocci, Stefano; Hauser, Daniela; Pappa, Evi (2016), "Housework and Fiscal Expansions", Journal of Monetary Economics 79, 94-108, DOI `10.1016/j.jmoneco.2016.04.003`。

## 1. Model Overview

- **模型**：包含家庭生产/家务劳动、市场生产、Calvo 价格黏性、资本积累和政府购买市场品的新凯恩斯模型。
- **实验**：政府消费支出冲击，政府支出服从持久 AR(1) 过程；MMB 实现做一阶近似模拟。
- **主体与模块**：代表性家庭、垄断竞争市场品企业、财政当局和中央银行。
- **形式**：水平方程的非线性均衡条件，MMB 实现使用对数变量。论文还给出简化的对数线性机制，但本档案以第 2 节完整非线性模型为主要推导对象。
- **来源质量**：MinerU Markdown 含有主要模型方程。Calvo 辅助递归和 Taylor 规则的精确 MMB 简化形式只用 `.agents/skills/dynare-copilot/references/examples/NK_GHP16_rep.mod` 作为 `implementation_cross_check`。

## 2. Optimization Problems

### 2.1 家庭

家庭选择市场消费品种、投资、下一期状态或有资产、市场工时、家庭工时、资本在市场生产和家庭生产之间的配置，以及下一期总资本。资本可以出租给企业，也可以留在家庭生产中使用。

\[
\max E_0\sum_{t=0}^{\infty}\beta^t U(C_t,l_t)
\]

约束为时间、家庭生产、CES 消费、预算和资本积累关系：

\[
K_{m,t}+K_{n,t}=K_t,\qquad h_{m,t}+h_{n,t}=h_t,\qquad l_t=1-h_t.
\]

\[
C_{n,t}=K_{n,t}^{\alpha_2}h_{n,t}^{1-\alpha_2}.
\]

\[
C_t=\left[\alpha_1 C_{m,t}^{b_1}+(1-\alpha_1)C_{n,t}^{b_1}\right]^{1/b_1}.
\]

\[
B_t+W_tP_t h_{m,t}+r_t^kP_tK_{m,t}+T_t
\ge E_t\{Q_{t,t+1}B_{t+1}\}+P_t(C_{m,t}+I_t).
\]

\[
K_{t+1}=(1-\delta)K_t+I_t-\frac{\xi}{2}\left(\frac{K_{t+1}}{K_t}-1\right)^2.
\]

在定量基准中，论文指定 KPR 偏好：

\[
U(C_t,l_t)=\frac{\left(C_t^b l_t^{1-b}\right)^{1-\sigma}-1}{1-\sigma}.
\]

### 2.2 市场品企业

每个企业使用市场资本和市场劳动生产差异化市场品：

\[
Y_t(i)=K_{m,t}(i)^{\alpha_3}h_{m,t}(i)^{1-\alpha_3}.
\]

CES 汇总下的需求为：

\[
Y_t(i)=\left[\frac{P_t(i)}{P_t}\right]^{-\varepsilon}Y_t^d.
\]

在不能重设价格的 Calvo 概率为 \(\theta\) 时，调价企业最大化贴现名义利润：

\[
E_t\sum_{j=0}^{\infty}\theta^j Q_{t,t+j}
\left[P_t(i)Y_{t+j}(i)-P_{t+j}(1-\tau)RMC_{t+j}Y_{t+j}(i)\right].
\]

### 2.3 政策当局

财政当局购买市场品种以生产总公共消费 \(G_t\)，并用一次性税收/转移支付融资。中央银行用 Taylor 型规则设定名义利率。

## 3. First-Order Conditions

**(F1) 总资本配置**

\[
K_{m,t}+K_{n,t}=K_t.
\]

**(F2) 时间配置**

\[
h_{m,t}+h_{n,t}=h_t,\qquad l_t=1-h_t.
\]

**(F3) 家庭品生产**

\[
C_{n,t}=K_{n,t}^{\alpha_2}h_{n,t}^{1-\alpha_2}.
\]

**(F4) 市场/家庭消费汇总器**

\[
C_t=\left[\alpha_1 C_{m,t}^{b_1}+(1-\alpha_1)C_{n,t}^{b_1}\right]^{1/b_1}.
\]

**(F5) 市场消费边际效用**

\[
\lambda_t=U_C(C_t,l_t)\alpha_1\left(\frac{C_{m,t}}{C_t}\right)^{b_1-1}.
\]

使用 KPR 偏好时，MMB 实现交叉核对式为：

\[
\lambda_t=b\alpha_1 l_t^{(1-b)(1-\sigma)}C_{m,t}^{b_1-1}C_t^{b(1-\sigma)-b_1}.
\]

**(F6) 闲暇/市场工时条件**

\[
W_t=\frac{U_l(C_t,l_t)}{\lambda_t}.
\]

**(F7) 闲暇/家庭生产条件**

\[
\frac{U_l(C_t,l_t)}{(1-\alpha_1)U_C(C_t,l_t)}
\left(\frac{C_{n,t}}{C_t}\right)^{1-b_1}
=\frac{(1-\alpha_2)C_{n,t}}{h_{n,t}}.
\]

**(F8) 家庭部门和市场部门之间的资本配置**

\[
\frac{\alpha_1}{1-\alpha_1}
\left(\frac{C_{m,t}}{C_{n,t}}\right)^{b_1-1}
=\frac{\alpha_2 C_{n,t}}{r_t^k K_{n,t}}.
\]

**(F9) 资本积累**

\[
K_{t+1}=(1-\delta)K_t+I_t-\frac{\xi}{2}\left(\frac{K_{t+1}}{K_t}-1\right)^2.
\]

**(F10) 资本 Euler 方程**

\[
\beta E_t\left\{\frac{\lambda_{t+1}}{\lambda_t}
\frac{
1-\delta+r_{t+1}^k+\xi\left(\frac{K_{t+2}}{K_{t+1}}-1\right)\left(\frac{K_{t+2}}{K_{t+1}^2}\right)
}{
1+\frac{\xi}{K_t}\left(\frac{K_{t+1}}{K_t}-1\right)
}\right\}=1.
\]

**(F11) 金融资产 Euler 方程**

\[
\beta E_t\left\{\frac{\lambda_{t+1}}{\lambda_t}(1+R_t)\Pi_{t+1}^{-1}\right\}=1.
\]

**(F12) 市场品生产**

\[
Y_t(i)=K_{m,t}(i)^{\alpha_3}h_{m,t}(i)^{1-\alpha_3}.
\]

**(F13) 企业层面需求**

\[
Y_t(i)=\left[\frac{P_t(i)}{P_t}\right]^{-\varepsilon}Y_t^d.
\]

**(F14) 实际边际成本**

\[
RMC_t=\frac{r_t^kK_{m,t}(i)}{\alpha_3Y_t(i)}
=\frac{W_t h_{m,t}(i)}{(1-\alpha_3)Y_t(i)}.
\]

**(F15) 最优重设价格，needs_review**

论文给出 Calvo 利润问题，但没有给出紧凑的递归实现。MMB 实现使用辅助变量：

\[
\frac{P_t^{\ast}}{P_t}=\frac{x_{1,t}}{x_{2,t}}.
\]

**(F16) Calvo 分子递归，implementation_cross_check，needs_review**

\[
x_{1,t}=Y_t\frac{\varepsilon(1-\tau)}{\varepsilon-1}RMC_t
\beta\theta E_t\left[\frac{\lambda_{t+1}}{\lambda_t}\Pi_{t+1}^{\varepsilon}x_{1,t+1}\right].
\]

**(F17) Calvo 分母递归，implementation_cross_check，needs_review**

\[
x_{2,t}=Y_t+\beta\theta E_t\left[\frac{\lambda_{t+1}}{\lambda_t}\Pi_{t+1}^{\varepsilon-1}x_{2,t+1}\right].
\]

**(F18) 价格指数关系**

\[
1=\theta\Pi_t^{\varepsilon-1}+(1-\theta)\left(\frac{P_t^{\ast}}{P_t}\right)^{1-\varepsilon}.
\]

**(F19) 价格离散度**

\[
\Delta_t=(1-\theta)\left(\frac{P_t^{\ast}}{P_t}\right)^{-\varepsilon}+\theta\Pi_t^{\varepsilon}\Delta_{t-1}.
\]

## 4. Market Clearing & Identities

**(F20) 政府品汇总器**

\[
G_t=\left[\int_0^1 G_t(i)^{(\varepsilon-1)/\varepsilon}di\right]^{\varepsilon/(\varepsilon-1)}.
\]

**(F21) 总产出**

\[
Y_t=\left[\int_0^1 Y_t(i)^{(\varepsilon-1)/\varepsilon}di\right]^{\varepsilon/(\varepsilon-1)}.
\]

**(F22) 市场出清**

\[
Y_t=Y_t^d=C_{m,t}+I_t+G_t,\qquad
h_{m,t}=\int_0^1h_{m,t}(i)di,\qquad
K_{m,t}=\int_0^1K_{m,t}(i)di.
\]

**(F23) 含价格离散度的市场总生产函数**

\[
Y_t=\Delta_t^{-1}K_{m,t}^{\alpha_3}h_{m,t}^{1-\alpha_3}.
\]

## 5. Exogenous Processes

**(F24) 政府支出过程**

\[
\log G_t=(1-\rho_g)\log \bar{G}+\rho_g\log G_{t-1}+\varepsilon^g_t.
\]

MMB 实现写作 \(G_t=\bar{G}\exp(g_t)\) 以及：

\[
g_t=\rho_g g_{t-1}+\varepsilon^g_t.
\]

**(F25) 货币政策规则**

论文的一般 Taylor 规则为：

\[
(1+R_t)=(1+R_{t-1})^{\rho_m}
\cdot\left(\beta^{-1}\Pi_t^{\phi_\pi}\left(\frac{Y_t}{Y_t^n}\right)^{\phi_y}\right)^{1-\rho_m}
\cdot\left(\frac{Y_t/Y_t^n}{Y_{t-1}/Y_{t-1}^n}\right)^{\phi_{dy}}.
\]

MMB 实现将其限制为无平滑且无产出缺口项：

\[
1+R_t=\beta^{-1}\Pi_t^{\phi_\pi}.
\]

## 6. Steady-State Solution

论文报告了基准稳态校准系统。令 \(i=I/K\)，\(k_m=K_m/Y\)，\(k_n=K_n/Y\)，\(g=G/Y\)，并设 \(\Pi=1\)。

1. 选择数据目标 \(\beta\)、\(i\)、\(k_m\)、\(k_n\)、\(h_m\)、\(h_n\) 和 \(g\)。
2. 确定折旧和回报：

\[
\delta=i,\qquad r^k=\frac{1-\beta(1-\delta)}{\beta}.
\]

3. 确定市场部门生产参数和市场数量：

\[
\alpha_3=r^k k_m,\qquad
Y=k_m^{\alpha_3/(1-\alpha_3)}h_m.
\]

\[
C_m=Y\left[1-g-\delta(k_m+k_n)\right],\qquad
G=gY,\qquad
W=\frac{(1-\alpha_3)Y}{h_m}.
\]

4. 确定家庭部门参数和非市场数量：

\[
\alpha_2=\frac{k_nr^kY}{k_nr^kY+Wh_n},\qquad
C_n=(k_nY)^{\alpha_2}h_n^{1-\alpha_2}.
\]

\[
\alpha_1=
\frac{(1-\alpha_2)C_n^{b_1}/(Wh_n)}
{C_m^{b_1-1}+(1-\alpha_2)C_n^{b_1}/(Wh_n)}.
\]

\[
h=h_m+h_n,\qquad l=1-h,\qquad
b=\frac{(1-\alpha_2)C_m+Wh_n}{(1-\alpha_2)(Wl+C_m)+Wh_n}.
\]

5. MMB 实现使用的其他稳态对象包括：

\[
C=\left[\alpha_1C_m^{b_1}+(1-\alpha_1)C_n^{b_1}\right]^{1/b_1},\qquad
I=\delta(k_m+k_n)Y.
\]

\[
RMC=\frac{\varepsilon-1}{\varepsilon(1-\tau)},\qquad
\lambda=b\alpha_1l^{(1-b)(1-\sigma)}C_m^{b_1-1}C^{b(1-\sigma)-b_1}.
\]

稳态公式有来源支撑，但本条目仍为 `needs_review`，因为未运行 Dynare 残差或 BK 验证。

## 7. Timing & Form Conventions

- **资本时序**：论文写作家庭在 \(t\) 期初持有 \(K_t\) 并选择 \(K_{t+1}\)。MMB 实现将其转换为 Dynare 时序，`K(-1)` 为预定状态变量，当前 `K` 为期末资本。
- **家庭资本和市场资本**：\(K_{n,t}\) 与 \(K_{m,t}\) 是总资本在当期家庭生产和市场生产之间的配置。
- **通胀**：\(\Pi_t=P_t/P_{t-1}\)；MMB 代码把对数通胀存为 `infl`。
- **利率**：论文在 Euler 方程和规则中使用 \(1+R_t\)；MMB 代码存储 `r`，使 `exp(1+r)` 为名义总回报。
- **形式**：来源方程为非线性方程，MMB 围绕确定性稳态做一阶扰动。`.mod` 对正变量取对数。
- **运行时验证**：未执行。

## 8. Variable & Parameter Reference Table

| Category | Symbol / Dynare name | Meaning | Main equation(s) |
|---|---|---|---|
| 内生 | \(C_t\) / `C` | 总消费组合 | (F4), (F5) |
| 内生 | \(C_{m,t}\) / `C_m` | 市场消费 | (F4), (F22) |
| 内生 | \(C_{n,t}\) / `C_n` | 家庭生产消费 | (F3), (F7), (F8) |
| 内生 | \(K_t\) / `K` | 总资本 | (F1), (F9), (F10) |
| 内生 | \(K_{m,t}\) / `K_m` | 市场部门资本 | (F1), (F14), (F22), (F23) |
| 内生 | \(K_{n,t}\) / `K_n` | 家庭部门资本 | (F1), (F3), (F8) |
| 内生 | \(I_t\) / `I` | 投资 | (F9), (F22) |
| 内生 | \(W_t\) / `W` | 实际工资 | (F6), (F14) |
| 内生 | \(h_{m,t}\) / `h_m` | 市场工时 | (F2), (F22), (F23) |
| 内生 | \(h_{n,t}\) / `h_n` | 家庭工时 | (F2), (F3), (F7) |
| 内生 | \(r_t^k\) / `r_k` | 资本租赁回报 | (F8), (F10), (F14) |
| 内生 | \(R_t\) / `r` | 论文记号中扣除 1 的名义政策利率 | (F11), (F25) |
| 内生 | \(\lambda_t\) / `lambda` | 市场消费边际效用 | (F5), (F10), (F11) |
| 内生 | \(\Pi_t\) / `infl` | 总通胀 | (F11), (F18), (F19), (F25) |
| 内生 | \(P_t^{\ast}/P_t\) / `inflstar` | 最优重设相对价格 | (F15), (F18), (F19) |
| 内生 | \(x_{1,t}\) / `x_1` | Calvo 分子辅助变量 | (F16) |
| 内生 | \(x_{2,t}\) / `x_2` | Calvo 分母辅助变量 | (F17) |
| 内生 | \(RMC_t\) / `RMC` | 实际边际成本 | (F14), (F16) |
| 内生 | \(G_t\) / `G` | 政府购买 | (F20), (F22), (F24) |
| 内生 | \(g_t\) / `g` | 政府支出对数偏离 | (F24) |
| 内生 | \(Y_t\) / `Y` | 总产出 | (F21), (F22), (F23) |
| 内生 | \(\Delta_t\) / `D` | 价格离散度 | (F19), (F23) |
| 外生 | \(\varepsilon^g_t\) / `e_g` | 政府支出创新 | (F24) |
| 参数 | \(\beta\) / `beta` | 贴现因子 | (F10), (F11), (F25) |
| 参数 | \(\varepsilon\) / `eps` | 品种间替代弹性 | (F13), (F18), (F20), (F21) |
| 参数 | \(\theta\) / `theta` | Calvo 不调价概率 | (F16), (F17), (F18), (F19) |
| 参数 | \(\xi\) / `xi` | 资本调整成本 | (F9), (F10) |
| 参数 | \(\sigma\) / `sigma` | KPR 效用中的风险厌恶 | (F5), 稳态 |
| 参数 | \(\rho_g\) / `rho_g` | 政府支出持久性 | (F24) |
| 参数 | \(\delta\) / `delta` | 折旧率 | (F9), (F10), 稳态 |
| 参数 | \(\tau\) / `tau` | 生产补贴 | (F16), 稳态 |
| 参数 | \(\tau_p\) / `taup` | 实现中作用于要素 FOC 的税收/补贴楔子 | (F14), implementation_cross_check |
| 参数 | \(\phi_\pi\) / `phi_infl` | Taylor 规则通胀系数 | (F25) |
| 参数 | \(\alpha_1,\alpha_2,\alpha_3\) / `alpha_1`, `alpha_2`, `alpha_3` | 消费、家庭生产和市场生产份额 | (F3), (F4), (F8), (F12), (F23) |
| 参数 | \(b_1,b\) / `b_1`, `b` | 家庭/市场替代性和 KPR 消费-闲暇份额 | (F4), (F5), 稳态 |
