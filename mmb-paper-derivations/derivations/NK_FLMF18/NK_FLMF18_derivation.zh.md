# NK_FLMF18 - 推导

> `NK_FLMF18` 的模型档案草稿。未进行运行时验证。状态：`needs_review`。

来源：Filardo, Andrew; Lombardi, Marco; Montoro, Carlos; Ferrari, Massimo (2018), "Monetary policy spillovers, global commoditiy prices and cooperation", BIS Working Paper No. 696。`raw/mmb_mineru/model_index.csv` 记录的 DOI：`10.5089/9781513519357.001`。

## 1. Model Overview

- **模型**：基于 Nakov and Pescatori (2010) 的多国新凯恩斯商品价格溢出模型。MMB 复制版本为 `NK_FLMF18`。
- **地区**：一个具有粘性最终品价格和货币政策的商品进口地区；一个具有市场势力的主导商品出口国；以及一组竞争性商品出口边缘供给者。
- **核心机制**：实际商品价格内生决定。商品需求来自进口国居民消费和最终品生产；商品供给来自主导出口者和竞争性边缘供给者。货币政策可能把商品价格变化误判为供给驱动或需求驱动。
- **政策实验**：有效/自然/基准政策规则、商品供给冲击、总需求冲击，以及误诊断实验。
- **形式**：论文给出非线性均衡条件和对数线性化基准方程。MMB 实现使用非线性水平变量方程、对数变换和一阶 `stoch_simul`；操作性决策规则围绕稳态线性化。本条目同时记录来源中的非线性模块和对数线性政策/基准形式。
- **主要来源**：`raw/mmb_mineru/runs/nk_flmf18__monetary_policy_spillovers_global_commoditiy_prices_and_cooperation__837579b4/full.md`；仅作为实现交叉检查：`.agents/skills/dynare-copilot/references/examples/NK_FLMF18_rep.mod`。

## 2. Optimization Problems

### 商品进口国居民

代表性居民选择消费、劳动和名义债券：

$$
\max_{\{C_t,L_t,B_t\}} E_{t_0}\sum_{t=t_0}^{\infty}\beta^{t-t_0}\exp(g_t)
\left[\ln C_t-\frac{L_t^{1+\nu}}{1+\nu}\right].
$$

复合消费由最终品和商品组成：

$$
C_t=(C_{Y,t})^{1-\gamma}(\mathfrak{M}_{C,t})^\gamma.
$$

名义预算约束为：

$$
C_t=\frac{W_tL_t}{P_t}+\frac{B_{t-1}}{P_t}-\frac{1}{R_t}\frac{B_t}{P_t}
+\frac{\Gamma_t}{P_t}+\frac{T_t}{P_t}.
$$

### 最终品生产者

每个差异化最终品生产者使用劳动和商品投入：

$$
Y_t(z)=A_tL_t(z)^{1-\alpha}\mathfrak{M}_{Y,t}(z)^\alpha.
$$

在 Calvo 定价下，能够重设价格的企业选择 $\hat P_{Y,t}(z)$ 以最大化预期贴现利润：

$$
E_t\sum_{k=0}^{\infty}\theta^k\zeta_{t,t+k}F_{t+k}^{-1}\Gamma_{t+k}(z),
$$

其中税后名义利润为：

$$
\Gamma_t(z)=\left[(1-\tau)P_{Y,t}(z)-P_tMC_t\right]
\left(\frac{P_{Y,t}(z)}{P_{Y,t}}\right)^{-\varepsilon}Y_t.
$$

### 主导商品出口者

主导出口者使用从进口地区购买的最终品生产商品：

$$
\mathfrak{M}_t=Z_t I_t^{\ast,D}.
$$

其居民消费最终品并拥有出口企业。每期实际利润表达式为：

$$
\frac{\Gamma_t^{\ast,D}}{P_{Y,t}}=Q_t^{1/(1-\gamma)}\mathfrak{M}_t-I_t^{\ast,D}.
$$

主导出口者在给定进口国宏观变量和边缘供给的情况下选择商品产出：

$$
\max_{\{\mathfrak{M}_t\}}E_{t_0}\sum_{t=t_0}^{\infty}\beta^{t-t_0}
\ln\left(Q_t^{1/(1-\gamma)}\mathfrak{M}_t-\mathfrak{M}_t/Z_t\right).
$$

### 竞争性商品边缘供给者

每个边缘生产者 $j$ 在产能约束下选择商品产出：

$$
\max_{X_t(j)\in[0,\bar X]}
\left[Q_tX_t(j)-\frac{(P_{Y,t}/P_t)X_t(j)}{\xi(j)Z_t}\right].
$$

## 3. First-Order Conditions

**(F1) 居民欧拉方程**

$$
1=\beta E_t\left[
R_t\left(\frac{P_t}{P_{t+1}}\right)
\left(\frac{C_{t+1}}{C_t}\right)^{-1}
\exp(g_{t+1}-g_t)
\right].
$$

**(F2) 居民劳动供给**

$$
\frac{W_t}{P_t}=C_tL_t^\nu.
$$

**(F3) 商品消费需求**

$$
\mathfrak{M}_{C,t}=\gamma\frac{P_t}{P_{\mathfrak{M},t}}C_t
=\gamma\frac{C_t}{Q_t}.
$$

**(F4) 最终品消费需求**

$$
C_{Y,t}=(1-\gamma)\frac{P_t}{P_{Y,t}}C_t.
$$

**(F5) 差异化最终品需求**

$$
C_{Y,t}(z)=\left(\frac{P_{Y,t}(z)}{P_{Y,t}}\right)^{-\varepsilon}C_{Y,t}.
$$

**(F6) 总价格指数**

$$
P_t=(P_{Y,t})^{1-\gamma}(P_{\mathfrak{M},t})^\gamma.
$$

**(F7) 总通胀关系**

$$
\Pi_t=(\Pi_{Y,t})^{1-\gamma}(\Pi_{\mathfrak{M},t})^\gamma.
$$

**(F8) 最终品价格指数**

$$
P_{Y,t}=\left[\int_0^1P_{Y,t}(z)^{1-\varepsilon}dz\right]^{1/(1-\varepsilon)}.
$$

**(F9) 实际边际成本**

$$
MC_t=\frac{(W_t/P_t)^{1-\alpha}Q_t^\alpha}
{A_t(1-\alpha)^{1-\alpha}\alpha^\alpha}.
$$

**(F10) 最终品企业劳动需求**

$$
L_t(z)=(1-\alpha)\frac{MC_t}{W_t/P_t}Y_t(z).
$$

**(F11) 最终品企业商品投入需求**

$$
\mathfrak{M}_{Y,t}(z)=\alpha\frac{MC_t}{Q_t}Y_t(z).
$$

**(F12) Calvo 最优相对重设价格**

$$
\frac{\hat P_{Y,t}(z)}{P_{Y,t}}=
\frac{\mu E_t\sum_{k=0}^{\infty}\theta^k\zeta_{t,t+k}MC_{t+k}F_{t+k}^{\varepsilon}Y_{t+k}}
{E_t\sum_{k=0}^{\infty}\theta^k\zeta_{t,t+k}F_{t+k}^{\varepsilon-1}Y_{t+k}}.
$$

**(F13) 核心通胀递归分母**

$$
D_t=\frac{Y_t}{C_t}+\theta\beta E_t\left[(\Pi_{Y,t+1})^{\varepsilon-1}D_{t+1}\right].
$$

**(F14) 核心通胀递归分子**

$$
N_t=\mu\frac{Y_t}{C_t}MC_t+\theta\beta E_t\left[(\Pi_{Y,t+1})^\varepsilon N_{t+1}\right].
$$

**(F15) 非线性核心 Phillips 曲线 / 价格加总**

$$
\theta(\Pi_{Y,t})^{\varepsilon-1}
=1-(1-\theta)\left(\frac{N_t}{D_t}\right)^{1-\varepsilon}.
$$

**(F16) 价格分散度**

$$
\Delta_t=(1-\theta)\left(\frac{N_t}{D_t}\right)^{-\varepsilon}
+\theta\Delta_{t-1}(\Pi_{Y,t})^\varepsilon.
$$

**(F17) 总劳动需求**

$$
L_t=(1-\alpha)\frac{MC_t}{W_t/P_t}Y_t\Delta_t.
$$

**(F18) 总商品投入需求**

$$
\mathfrak{M}_{Y,t}=\alpha\frac{MC_t}{Q_t}Y_t\Delta_t.
$$

**(F19) 总生产函数**

$$
Y_t=\frac{A_tL_t^{1-\alpha}\mathfrak{M}_{Y,t}^{\alpha}}{\Delta_t}.
$$

**(F20) 主导出口者商品剩余需求**

$$
\mathfrak{M}_t=\mathfrak{M}_{C,t}+\mathfrak{M}_{Y,t}-X_t.
$$

**(F21) 边缘供给者商品供给**

$$
X_t=\Omega_tZ_tQ_t.
$$

**(F22) 主导出口者定价条件**

$$
Q_t=\Psi_tZ_t^{-1}.
$$

**(F23) 商品加成**

$$
\Psi_t=\frac{1}{1-\eta_t}=1+\frac{\mathfrak{M}_t}{2X_t}.
$$

**(F24) 商品需求弹性**

$$
\eta_t=\frac{\mathfrak{M}_t}{\mathfrak{M}_t+2X_t}.
$$

**(F25) 一般非线性政策规则**

$$
R_t=\bar R(\Pi_t)^{\varphi_{head}}(\Pi_{Y,t})^{\varphi_{core}}
\left(\frac{Q_t}{Q_{t-1}}\right)^{\varphi_{com}}.
$$

**(F26) 主要模拟使用的有效基准政策规则**

$$
r_t=E_{t|t-1}\left[r_t^e+\varphi_{core}\pi_{Y,t}+\varphi_y\hat y_t^e\right]
+\varphi_{com}\Delta q_t.
$$

**(F27) 信号提取观测方程**

$$
q_t=-z_t+\psi_t=H'\xi_t,\qquad H'=[-1\;\;1],\qquad \xi_t=[z_t\;\;\psi_t]'.
$$

**(F28) 信号提取更新**

$$
E_t^{ma}\left([z_t\;\;\psi_t]'\right)=Mq_t,\qquad
M=PH(H'PH)^{-1}.
$$

**(F29) 带误诊断的政策规则**

$$
r_t=E_{t|t-1}^{ma}\left[r_t^e+\varphi_{core}\pi_{Y,t}+\varphi_y\hat y_t^e\right]
+\varphi_{com}\Delta q_t.
$$

## 4. Market Clearing & Identities

**(F30) 债券市场出清**

$$
B_t=0.
$$

**(F31) 商品市场出清**

$$
\mathfrak{M}_{C,t}+\mathfrak{M}_{Y,t}=\mathfrak{M}_t+X_t.
$$

**(F32) 进口国总资源约束**

$$
\frac{P_{Y,t}}{P_t}C_{Y,t}
=\frac{P_{Y,t}}{P_t}Y_t-Q_t(\mathfrak{M}_t+X_t).
$$

**(F33) 世界最终品市场出清**

$$
Y_t=C_{Y,t}+C_t^{\ast,D}+I_t^{\ast,D}+C_t^{\ast,F}+I_t^{\ast,F}.
$$

**(F34) 自然产出缺口**

$$
\hat y_t^n=\left(\frac{\alpha}{1-\alpha}-\frac{1}{1+\nu}\Upsilon\right)mc_t.
$$

**(F35) 有效产出缺口关系**

$$
\hat y_t^e=\hat y_t^n
-\left(\frac{\alpha}{1-\alpha}-\frac{1}{1+\nu}\frac{\gamma}{1-\gamma}\Upsilon\right)\psi_t
-\frac{1}{1+\nu}\frac{\gamma}{1-\gamma}(\Upsilon-\Upsilon^e)z_t.
$$

**(F36) 对数线性总通胀**

$$
\pi_t=\pi_{Y,t}+\frac{\gamma}{1-\gamma}\Delta q_t.
$$

**(F37) 对数线性核心通胀**

$$
\pi_{Y,t}=\kappa_y\hat y_t^n+E_t\pi_{Y,t+1}.
$$

## 5. Exogenous Processes

**(F38) 商品生产率 / 供给冲击**

$$
\ln Z_t=(1-\rho_z)\ln\bar Z+\rho_z\ln Z_{t-1}+\varepsilon_t^z.
$$

**(F39) 边缘供给规模冲击**

$$
\omega_t=\rho_\omega\omega_{t-1}+\varepsilon_t^\omega.
$$

**(F40) 进口国 TFP 冲击**

$$
a_t=\rho_a a_{t-1}+\varepsilon_t^a.
$$

**(F41) 偏好冲击**

$$
g_t=\rho_g g_{t-1}+\varepsilon_t^g.
$$

**(F42) 货币政策冲击**

$$
err_t=\rho_{err}err_{t-1}+\varepsilon_t^{err}.
$$

**(F43) 总需求 / 政府支出冲击**

$$
gg_t=\rho_{gg}gg_{t-1}+\varepsilon_t^{gg}.
$$

## 6. Steady-State Solution

来源附录给出商品部门稳态系统：

$$
\Psi=1+\frac{\mathfrak{M}/Y}{2X/Y},\qquad Q=\Psi Z^{-1}.
$$

$$
\frac{P_Y}{P}=Q^{-\gamma/(1-\gamma)},\qquad
\frac{X}{Y}=\frac{\Omega Z}{Y}Q.
$$

$$
\frac{\mathfrak{M}}{Y}=
\left[\gamma\frac{P_Y}{P}+(1-\gamma)\frac{\alpha}{\mu}\right]\frac{1}{Q}
-\frac{X}{Y}.
$$

给定 $(\alpha,\gamma,\Omega Z/Y,\mu,Z)$ 后，解出 $(\Psi,Q,P_Y/P,X/Y,\mathfrak{M}/Y)`。零稳态通胀下：

$$
\Pi=1,\qquad MC=\frac{1}{\mu},\qquad \Delta=1.
$$

其余稳态比率为：

$$
\frac{C}{Y}=\frac{P_Y}{P}-\frac{\alpha}{\mu}.
$$

$$
L=\left[\frac{(1-\alpha)/\mu}{C/Y}\right]^{1/(1-\nu)}.
$$

$$
Y=\left[A\left(\frac{\alpha}{\mu}\frac{1}{Q}\right)^\alpha\right]^{1/(1-\alpha)}L.
$$

论文/MMB 实现中的基准校准包括：

| Parameter | Value | Role |
|---|---:|---|
| $\Pi$, $MC$, $\Delta$ | $1$, $1/\mu$, $1$ | normalized steady-state values |

其余稳态比率为：

$$
\frac{C}{Y}=\frac{P_Y}{P}-\frac{\alpha}{\mu}.
$$

$$
L=\left[\frac{(1-\alpha)/\mu}{C/Y}\right]^{1/(1-\nu)}.
$$

$$
Y=\left[A\left(\frac{\alpha}{\mu}\frac{1}{Q}\right)^\alpha\right]^{1/(1-\alpha)}L.
$$

论文/MMB 实现中的基准校准包括：

| Parameter | Value | Role |
|---|---:|---|
| $\gamma$ | 0.1 | 消费篮子中的商品份额 |
| $\alpha$ | 0.1 | 生产中的商品份额 |
| $\nu$ | 0.5 | Frisch 劳动供给弹性倒数 |
| $\varepsilon$ | 7.66 or 7.67 | 差异化商品替代弹性；OCR/表格与 `.mod` 存在舍入差异 |
| $\beta$ | 0.99 | 贴现因子 |
| $\theta$ | 0.75 | Calvo 不重设价格概率 |
| $A,Z$ | 1 | 稳态生产率归一化 |
| $X/Y$ | 0.1 | 竞争性商品部门相对 GDP 的规模 |

needs_review：来源 Markdown 的附录部分存在 OCR 损坏；一个 `.mod` 交叉检查行使用 `RHO_GG`，但显示的参数声明片段没有列出该参数。未进行运行时验证。

## 7. Timing & Form Conventions

- **时序**：债券为期末名义持有量，净供给为零。价格分散度 $\Delta_t$ 是含滞后项 $\Delta_{t-1}` 的状态变量。商品价格变化使用 $Q_t/Q_{t-1}`。
- **通胀**：$\Pi_t=P_t/P_{t-1}$ 是总通胀，$\Pi_{Y,t}=P_{Y,t}/P_{Y,t-1}$ 是核心/最终品通胀，商品通胀通过商品价格和总价格指数进入。
- **实际商品价格**：$Q_t=P_{\mathfrak{M},t}/P_t`；由价格指数恒等式，它也与进口国贸易条件相关。
- **形式**：尽可能保留论文中的非线性方程；基准和政策分析模块为对数线性。MMB `.mod` 使用带 `N` 前缀的水平变量和 `Y=ln(NY)`、`Q=ln(NQ)` 等对数报告变量，并进行一阶模拟。
- **运行时验证**：本档案条目未执行。

## 8. Variable & Parameter Reference Table

### 内生变量

| Symbol / MMB name | 含义 | 主要方程 |
|---|---|---|
| $C_t$ / `NC`, `C` | 总消费 | (F1), (F3), (F4) |
| $C_{Y,t}$ / `NCY`, `CY` | 最终品消费 | (F4), (F32) |
| $\mathfrak{M}_{C,t}$ / `NOC`, `OC` | 商品消费 | (F3), (F31) |
| $L_t$ / `NL`, `L` | 劳动 | (F2), (F17) |
| $W_t/P_t$ / `NWP`, `WP` | 实际工资 | (F2), (F17) |
| $Y_t$ / `NY`, `Y` | 最终产出 | (F19), (F33) |
| $MC_t$ / `NMC`, `MC` | 实际边际成本 | (F9), (F37) |
| $\Pi_t$ / `NPI`, `PI` | 总通胀 | (F7), (F36) |
| $\Pi_{Y,t}$ / `NPIY`, `PIY` | 核心通胀 | (F15), (F37) |
| $\Delta_t$ / `DELTA` | 价格分散度 | (F16) |
| $D_t$ / `DD` | Calvo 分母 | (F13) |
| $N_t$ / `NN` | Calvo 分子 | (F14) |
| $R_t$ / `NR`, `R` | 政策利率 | (F25), (F26), (F29) |
| $Q_t$ / `NQ`, `Q` | 实际商品价格 | (F22), (F23) |
| $\mathfrak{M}_{Y,t}$ / `NOY`, `OY` | 商品投入需求 | (F18) |
| $\mathfrak{M}_t$ / `NO`, `O` | 主导出口者商品供给/剩余需求 | (F20) |
| $X_t$ / `NX`, `X` | 竞争性边缘供给 | (F21) |
| $\Psi_t$, $\eta_t$ / `NETA`, `ETA` | 商品加成与需求弹性 | (F23), (F24) |
| $y_t^n,\hat y_t^n$ / `Yn`, `Yn_gap` | 自然产出与缺口 | (F34) |
| $y_t^e,\hat y_t^e$ / `Ye`, `Y_gap` | 有效产出与缺口 | (F35) |
| $r_t^n,r_t^e$ / `Rn`, `Re`, `Rfe` | 自然/有效利率 | 政策基准模块 |

### 外生冲击

| Symbol / MMB name | 含义 | 过程 |
|---|---|---|
| $\varepsilon_t^z$ / `EZ` | 商品生产率/供给创新 | (F38) |
| $\varepsilon_t^\omega$ / `EOMEGA` | 竞争性边缘规模创新 | (F39) |
| $\varepsilon_t^a$ / `EA` | 进口国 TFP 创新 | (F40) |
| $\varepsilon_t^g$ / `EG` | 偏好创新 | (F41) |
| $\varepsilon_t^{err}$ / `EERR` | 货币政策创新 | (F42) |
| $\varepsilon_t^{gg}$ / `EGG` | 总需求/政府支出创新 | (F43) |

### 参数

| Symbol / MMB name | 含义 |
|---|---|
| $\beta$ / `BETA` | 贴现因子 |
| $\gamma$ / `GAMMA` | 消费篮子中的商品份额 |
| $\xi=1-\gamma$ / `XI` | CPI 聚合中的最终品份额 |
| $\alpha$ / `ALPHA` | 生产中的商品份额 |
| $\nu$ / `NU` | Frisch 弹性倒数 |
| $\varepsilon$ / `EPS` | 差异化商品替代弹性 |
| $\mu$ / `MU` | 最终品总加成 |
| $\theta$ / `THETA` | Calvo 不重设价格概率 |
| $\kappa$ / `KAPPA` | 实现中的线性化 Phillips 曲线斜率 |
| $\varphi_{head},\varphi_{core},\varphi_{com},\varphi_y$ / `PHI_*` | 政策规则系数 |
| $\rho_z,\rho_\omega,\rho_a,\rho_g,\rho_{err},\rho_{gg}$ / `RHO_*` | 冲击持续性参数 |
| $A,Z$ / `AS`, `ZS` | 稳态生产率归一化 |
| $\Omega$ / `NOMEGAS` | 稳态边缘供给规模 |
| `PHI_BENCH`, `PHI_NAT`, `PHI_EFF` | 基准、自然和有效政策规则开关 |
| `M1`, `M2`, `PHI_MISP_*` | 信号提取/误诊断权重和开关 |
