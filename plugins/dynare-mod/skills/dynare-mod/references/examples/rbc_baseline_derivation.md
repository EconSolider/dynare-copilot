# 基础 RBC 模型 —— 推导（最优化问题 + 一阶条件）

> 一句话说明：本推导用于据此编写 `rbc_baseline.mod`；确认后再进入写代码阶段。
> 本文件是 `references/derivation-style.md` 的标准范本——八节齐全、FOC 编号与 .mod 的
> `[name=]` 一一对应。仿写时照此格式与详略度即可。

## 1. 模型概述

- 模型：基础实际经济周期（Real Business Cycle, RBC），含全要素生产率（TFP）冲击。来源：
  King-Plosser-Rebelo / 标准研究生宏观教科书（如 Pfeifer 的 `RBC_baseline`）。
- 实验：随机模拟（`stoch_simul`），给一个 TFP 冲击 $\varepsilon_z$，看产出/消费/投资/资本/劳动的 IRF 与矩。
- 主体：代表性家庭（消费-储蓄-劳动选择）+ 完全竞争厂商（生产、按边际产品支付要素报酬）。
- 形式：**非线性（默认，R8）**——直接写原始 FOC 与约束，交给 Dynare 做泰勒展开。
  这样可做高阶近似、稳态有经济含义可核对大比率。

## 2. 主体的最优化问题

**代表性家庭。** 拥有资本、把资本租给厂商、提供劳动，最大化期望效用：

$$\max_{\{C_t,N_t,K_t\}}\; E_0\sum_{t=0}^{\infty}\beta^t
\left[\frac{C_t^{1-\sigma}}{1-\sigma}+\psi\,\log(1-N_t)\right]
\quad\text{s.t.}\quad C_t + I_t = W_t N_t + R^k_t K_{t-1},\qquad
K_t = I_t + (1-\delta)K_{t-1}$$

其中 $W_t$ 为工资、$R^k_t$ 为资本租金率、$I_t$ 为投资、$0<\beta<1$、$\sigma>0$、$\psi>0$、$0<\delta<1$。

**完全竞争厂商。** 用资本与劳动生产，技术为 Cobb–Douglas，$A_t$ 为 TFP：

$$\max_{K_{t-1},N_t}\; A_t K_{t-1}^{\alpha}N_t^{1-\alpha}-R^k_t K_{t-1}-W_t N_t$$

竞争均衡下要素报酬 = 边际产品（下面直接代入家庭 FOC，故 $W_t,R^k_t$ 不作为独立内生变量）：

$$R^k_t=\alpha A_t K_{t-1}^{\alpha-1}N_t^{1-\alpha},\qquad
W_t=(1-\alpha)A_t K_{t-1}^{\alpha}N_t^{-\alpha}$$

## 3. 一阶条件（FOC）

- **(F1) 欧拉方程**（跨期消费选择；对 $K_t$ 求 FOC，资本次期回报 $R^k_{t+1}+1-\delta$）：
$$C_t^{-\sigma}=\beta\,E_t\!\left[C_{t+1}^{-\sigma}
\Big(\alpha A_{t+1}K_t^{\alpha-1}N_{t+1}^{1-\alpha}+1-\delta\Big)\right]$$

- **(F2) 劳动供给**（消费-闲暇权衡；$-U_N/U_C=W_t$，代入 $W_t=(1-\alpha)A_tK_{t-1}^{\alpha}N_t^{-\alpha}$）：
$$\psi\,\frac{C_t^{\sigma}}{1-N_t}=(1-\alpha)A_t K_{t-1}^{\alpha}N_t^{-\alpha}$$

## 4. 市场出清与总量恒等式

- **(F3) 资本运动律**（期末存量在左边）：
$$K_t=I_t+(1-\delta)K_{t-1}$$
- **(F4) 资源约束**（产出用于消费与投资）：
$$Y_t=C_t+I_t$$
- **(F5) 生产函数**（资本预定，用 $K_{t-1}$）：
$$Y_t=A_t K_{t-1}^{\alpha}N_t^{1-\alpha}$$
- **(F6)–(F9) 报告用对数辅助恒等式**（便于读 IRF / 可对接观测方程）：
$$\log Y_t=\log(Y_t),\quad \log C_t=\log(C_t),\quad \log K_t=\log(K_t),\quad \log N_t=\log(N_t)$$

## 5. 外生过程

- **(F10) TFP 过程**：以 $z_t\equiv\log A_t$ 写成对数 AR(1)，$A_t=\exp(z_t)$，仅创新项 $\varepsilon_z$ 外生（R3）：
$$z_t=\rho_z z_{t-1}+\varepsilon_z,\qquad \varepsilon_z\sim\mathcal N(0,\sigma_z^2)$$

## 6. 稳态求解（写到能直接照抄进 steady_state_model）

去掉时间下标（$X_t=X_{t+1}=\bar X$），按"可自上而下逐个求值"的次序排列；**校准目标 $\bar N=1/3$
用反解**：把参数 $\psi$ 当未知反解，命中该目标。

1. 外生稳态：$\bar z=0\Rightarrow \bar A=1$。
2. 校准目标：$\bar N=1/3$。
3. 资本-劳动比（由 F1 稳态 $1=\beta(\alpha\,(K/N)^{\alpha-1}+1-\delta)$ 反解）：
$$\left(\frac{K}{N}\right)=\left(\frac{1/\beta-1+\delta}{\alpha}\right)^{\frac{1}{\alpha-1}}$$
4. $\bar K=(K/N)\cdot\bar N$。
5. $\bar I=\delta\bar K$（由 F3 稳态）。
6. $\bar Y=(K/N)^{\alpha}\bar N$（由 F5，$Y=K^{\alpha}N^{1-\alpha}=(K/N)^{\alpha}N$）。
7. $\bar C=\bar Y-\bar I$（由 F4）。
8. 反解 $\psi$（由 F2 稳态）：$\displaystyle \psi=(1-\alpha)(K/N)^{\alpha}\frac{1-\bar N}{\bar C^{\sigma}}$。
9. 对数辅助：$\overline{\log X}=\log(\bar X)$，$X\in\{Y,C,K,N\}$。

## 7. 时序与形式约定

- **期末存量**约定（R2）：$K_t$ 是 $t$ 期末决定的资本，进入 $t{+}1$ 期生产；故当期生产用 $K_{t-1}$，
  运动律左边是 $K_t$。.mod 中即 `k(-1)` 进生产、`k = invest + (1-delta)*k(-1)`。
- 形式：**非线性**（R8），不取对数线性化；TFP 以 $z=\log A$ 写 AR(1)，模型里用 `exp(z)`。

## 8. 变量与参数对照表（预告阶段2）

| 类别 | 符号（.mod 名） | 含义 | 由哪条 FOC 定 |
|------|------|------|--------------|
| 内生 var | $Y$ (`y`) | 产出 | (F5) |
| 内生 var | $C$ (`c`) | 消费 | (F1) |
| 内生 var | $K$ (`k`) | 资本（期末） | (F3) |
| 内生 var | $N$ (`l`) | 劳动 | (F2) |
| 内生 var | $I$ (`invest`) | 投资 | (F4) |
| 内生 var | $z$ (`z`) | 对数 TFP | (F10) |
| 内生 var | `log_y, log_c, log_k, log_l` | 对数报告量 | (F6)–(F9) |
| 外生 varexo | $\varepsilon_z$ (`eps_z`) | TFP 创新 | — |
| 参数 | `betta, sigma, alppha, delta, rhoz, psi` | 贴现/风险规避/资本份额/折旧/持续性/劳动负效用 | — |

- 内生变量 10 个（`y,c,k,l,invest,z` + 4 个 `log_*`）= 方程 10 条（F1–F10）→ **R4 预核对通过**。
- 命名注意（R5）：$\beta\to$`betta`、$\alpha\to$`alppha`、投资 $\to$`invest`、劳动用 `l`（不用 `i`/`e`）。

---

**质量自检**：八节齐全 ✓；每条 FOC 有编号、LaTeX 括号配平 ✓；内生数 = 定方程的 FOC 数（10=10）✓；
形式非线性已声明（R8）✓；时序期末存量已写明 ✓；稳态可自上而下求值、校准用反解 ✓；主体覆盖完整 ✓。
