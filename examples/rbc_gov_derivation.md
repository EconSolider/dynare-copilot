# RBC_gov —— 推导（最优化问题 + 一阶条件）

> 一句话说明：本推导用于据此编写 Dynare `.mod`；确认后再进入写代码阶段。

## 1. 模型概述
- 模型：含政府支出的基础 RBC，来源：标准 RBC（Pfeifer `RBC_baseline` 谱系）+ 一个外生政府支出冲击。
- 实验：随机模拟（`stoch_simul`），给 TFP 冲击与政府支出冲击各一个，看产出/消费/投资/劳动的 IRF 与矩。
- 主体：家庭（消费-劳动-储蓄）、厂商（完全竞争 Cobb–Douglas）、政府（外生支出、一次总付税平衡预算，不优化）。
- 形式：**非线性（默认，R8）**。原始 FOC 交给 Dynare 做泰勒展开，便于二阶福利分析与大比率核对。

## 2. 主体的最优化问题

**家庭**（可分效用、CRRA 消费、Frisch 劳动）：

$$\max_{\{C_t,N_t,K_t,I_t\}} \; E_0\sum_{t=0}^{\infty}\beta^t\Big[\frac{C_t^{1-\sigma}}{1-\sigma}-\psi\frac{N_t^{1+\varphi}}{1+\varphi}\Big]
\quad\text{s.t.}\quad C_t+I_t+T_t = w_tN_t+R^k_tK_{t-1}$$

$$K_t=(1-\delta)K_{t-1}+I_t$$

（完全竞争 + 规模报酬不变 ⇒ 厂商利润为零，故预算约束不含 $\Pi_t$。）

**厂商**（完全竞争，逐期静态利润最大化）：

$$\max_{K_{t-1},N_t}\; A_tK_{t-1}^{\alpha}N_t^{1-\alpha}-w_tN_t-R^k_tK_{t-1}$$

**政府**（不优化）：外生支出 $G_t$，一次总付税平衡预算 $T_t=G_t$。

## 3. 一阶条件（FOC）

**家庭**（对 $C_t,N_t$ 及通过 $K_t$ 的跨期选择，令消费边际效用为 $C_t^{-\sigma}$）：

- **(F1) 劳动供给**（消费-闲暇权衡）：
$$\psi N_t^{\varphi}=C_t^{-\sigma}w_t$$

- **(F2) 欧拉方程**（消费跨期选择，期末资本 $K_t$ 由当期决定）：
$$C_t^{-\sigma}=\beta\,E_t\Big[C_{t+1}^{-\sigma}\big(R^k_{t+1}+1-\delta\big)\Big]$$

**厂商**（要素需求）：

- **(F3) 劳动需求**：
$$w_t=(1-\alpha)\frac{Y_t}{N_t}$$

- **(F4) 资本需求**：
$$R^k_t=\alpha\frac{Y_t}{K_{t-1}}$$

## 4. 市场出清与总量恒等式

- **(F5) 生产函数**（资本预定，期初存量 $K_{t-1}$ 进当期生产）：
$$Y_t=A_tK_{t-1}^{\alpha}N_t^{1-\alpha}$$

- **(F6) 资本运动律**（期末存量在左边）：
$$K_t=I_t+(1-\delta)K_{t-1}$$

- **(F7) 资源约束**：
$$Y_t=C_t+I_t+G_t$$

## 5. 外生过程

- **(F8) TFP**（$A_t$ 内生，仅 $\varepsilon_{a,t}$ 外生，对数 AR(1)，稳态 $\bar A=1$）：
$$\log A_t=\rho_a\log A_{t-1}+\varepsilon_{a,t}$$

- **(F9) 政府支出**（$G_t$ 内生，仅 $\varepsilon_{g,t}$ 外生，对数 AR(1) 绕稳态 $\bar G$）：
$$\log G_t=(1-\rho_g)\log\bar G+\rho_g\log G_{t-1}+\varepsilon_{g,t}$$

## 6. 稳态求解（写到能直接照抄进 steady_state_model）

去时间下标，$\bar A=1$，冲击均值为 0。**校准目标**：稳态劳动 $\bar N=1/3$（反解 $\psi$）、政府支出占比 $\bar G/\bar Y=s_g$（反解参数 $\bar G$）。按可自上而下求值的次序：

1. $\bar A=1$
2. 由 (F2)：$\bar R^k=\dfrac{1}{\beta}-1+\delta$
3. 由 (F4) 定义资本-劳动比 $\kappa\equiv \bar K/\bar N$：$\bar R^k=\alpha\kappa^{\alpha-1}\Rightarrow \kappa=\big(\alpha/\bar R^k\big)^{1/(1-\alpha)}$
4. 目标 $\bar N=1/3$
5. $\bar K=\kappa\bar N$
6. $\bar Y=\kappa^{\alpha}\bar N$（由 (F5)，$\bar Y=\bar K^{\alpha}\bar N^{1-\alpha}=\kappa^{\alpha}\bar N$）
7. 由 (F3)：$\bar w=(1-\alpha)\kappa^{\alpha}$
8. 由 (F6)：$\bar I=\delta\bar K$
9. 反解政府支出参数：$\bar G=s_g\bar Y$
10. $\bar G_{(\text{变量})}=\bar G$
11. 由 (F7)：$\bar C=\bar Y-\bar I-\bar G$
12. 反解 $\psi$ 命中 $\bar N=1/3$，由 (F1)：$\psi=\dfrac{\bar C^{-\sigma}\bar w}{\bar N^{\varphi}}$

## 7. 时序与形式约定
- **期末存量**约定：资本以 $K_{t-1}$ 进生产 (F5) 与资本需求 (F4)；运动律左边是期末存量 $K_t$ (F6)。
- 形式：**非线性**（R8 默认），不手推线性化。
- 取对数：报告用辅助变量 $\log x$（产出/消费/投资/劳动），不改变模型解。

## 8. 变量与参数对照表

| 类别 | 符号（推导 / .mod） | 含义 | 由哪条 FOC 定 |
|------|------|------|--------------|
| 内生 var | $Y$ / `y` | 产出 | (F5) |
| 内生 var | $C$ / `c` | 消费 | (F7) |
| 内生 var | $N$ / `n` | 劳动 | (F1) |
| 内生 var | $K$ / `k` | 资本（期末） | (F6) |
| 内生 var | $I$ / `invest` | 投资 | (F2) 经欧拉定 |
| 内生 var | $w$ / `w` | 工资 | (F3) |
| 内生 var | $R^k$ / `rk` | 资本租金率 | (F4) |
| 内生 var | $A$ / `a` | TFP | (F8) |
| 内生 var | $G$ / `g` | 政府支出 | (F9) |
| 外生 varexo | $\varepsilon_a$ / `eps_a` | TFP 创新 | — |
| 外生 varexo | $\varepsilon_g$ / `eps_g` | 政府支出创新 | — |
| 参数 | $\beta$ / `betta` | 贴现因子 | — |
| 参数 | $\sigma$ / `sigma` | 风险规避 | — |
| 参数 | $\varphi$ / `phi` | Frisch 劳动弹性倒数 | — |
| 参数 | $\alpha$ / `alppha` | 资本份额 | — |
| 参数 | $\delta$ / `delta` | 折旧率 | — |
| 参数 | $\rho_a,\rho_g$ / `rho_a,rho_g` | 冲击持续性 | — |
| 参数 | $s_g$ / `gy_share` | 政府支出占比目标 | — |
| 参数（反解） | $\psi$ / `psi` | 劳动负效用 | 反解命中 $\bar N=1/3$ |
| 参数（反解） | $\bar G$ / `gss` | 稳态政府支出 | 反解命中 $\bar G/\bar Y=s_g$ |

**R4 预核对**：内生 9 个（y,c,n,k,invest,w,rk,a,g）= 能定方程 9 条（F1–F9）。对得上。
