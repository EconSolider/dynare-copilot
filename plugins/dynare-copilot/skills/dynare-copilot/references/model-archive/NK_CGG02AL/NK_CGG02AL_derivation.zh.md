# NK_CGG02AL - 推导（最优化问题 + 一阶条件）

> 档案状态：`needs_review`。本第一版推导基于 MinerU Markdown 来源，尚未在 Dynare 中做运行验证。

来源信息：模型 `NK_CGG02AL`；论文 "A simple framework for international monetary policy analysis"；作者 Richard Clarida、Jordi Gali、Mark Gertler；年份 2002；DOI/工作论文标识 `10.3386/w8870`；来源 Markdown `raw/mmb_mineru/runs/nk_cgg02_nk_cgg02al__a_simple_framework_for_international_monetary_policy_analysis__8ffaf5fd/full.md`；原始 PDF `raw/mmb_papers/A simple framework for international monetary policy analysis.pdf`；MinerU run id `8ffaf5fd-ee22-465d-89b8-0690a85353c0`。

## 1. Model Overview

- **模型**：两国开放经济新凯恩斯框架。本国人口权重为 $`1-\gamma`$，外国人口权重为 $`\gamma`$。两国在偏好、技术、价格设定和政策问题上对称，但冲击可以不同。
- **用途**：在国内生产者价格粘性、浮动汇率、完全国际风险分担，以及由劳动市场势力变动产生的成本推动权衡下，解析比较非合作 Nash 货币政策与合作货币政策。
- **主体**：家庭消费由本国与外国商品组成的 CES/Cobb-Douglas 组合，垄断竞争地供给差异化劳动，并交易完整的状态或有证券；最终品厂商聚合中间品；中间品厂商用劳动线性生产并按 Calvo 方式定价；货币当局选择名义利率，或等价地选择满足 IS 与 Phillips 约束的产出缺口。
- **形式**：围绕确定性稳态的 log-linear 解析模型。粘性价格政策系统中的小写变量为对数偏离；MMB 后缀 `AL` 在本条目中按 analytical/log-linear 处理。MinerU 文本中若干公式存在 OCR 瑕疵，已标为 `needs_review`。
- **运行验证**：未执行。

## 2. Optimization Problems

### 2.1 本国家庭

类型为 $`h`$ 的本国代表性家庭选择消费、劳动供给和状态或有资产组合：

```math
\max_{\{C_t,N_t(h),D_{t+1}\}} E_0\sum_{t=0}^{\infty}\beta^t
\left[\frac{C_t^{1-\sigma}}{1-\sigma}-\frac{N_t(h)^{1+\phi}}{1+\phi}\right]
```

约束为

```math
P_t C_t + E_t\{Q_{t,t+1}D_{t+1}\}
= W_t(h)N_t(h)+D_t-T_t+\Gamma_t.
```

消费是本国和外国商品的 Cobb-Douglas 组合：

```math
C_t \equiv C_{H,t}^{1-\gamma}C_{F,t}^{\gamma}, \qquad
P_t = k^{-1}P_{H,t}^{1-\gamma}P_{F,t}^{\gamma},
\quad k=(1-\gamma)^{1-\gamma}\gamma^\gamma.
```

家庭面对劳动需求

```math
N_t(h)=\left(\frac{W_t(h)}{W_t}\right)^{-\eta_t}N_t,
```

工资加成为 $`\mu_t^w=1/(\eta_t-1)`$。

### 2.2 外国家庭

外国家庭求解带星号变量的对称问题。完整国际 Arrow-Debreu 市场和一价定律推出下文使用的国际风险分担条件。

### 2.3 最终品厂商

本国最终品厂商选择中间品投入 $`Y_t(f)`$，在 CES 技术下最大化利润：

```math
Y_t=\left(\int_0^1 Y_t(f)^{(\xi-1)/\xi}\,df\right)^{\xi/(\xi-1)}.
```

### 2.4 中间品厂商

每个中间品厂商用劳动线性生产：

```math
Y_t(f)=A_tN_t(f),
```

劳动聚合为

```math
N_t(f)=\left(\frac{1}{1-\gamma}\int_0^{1-\gamma}N_t(h)^{(\eta_t-1)/\eta_t}\,dh\right)^{\eta_t/(\eta_t-1)}.
```

厂商获得工资账单补贴 $`\tau`$，面对不调价概率为 $`\theta`$ 的 Calvo 价格粘性，并在能够调价时选择 $`P^0_{H,t}`$，在需求约束下最大化贴现利润流。

### 2.5 政策制定者

在 Nash 情形，本国央行在给定外国变量下最小化国内二次损失。在合作情形，两国央行联合最小化加权世界损失。政策按相机抉择求解，因此逐期政策问题把未来预期视为给定。

## 3. First-Order Conditions

- **(F1) 本国商品需求**

```math
P_{H,t}C_{H,t}=(1-\gamma)P_tC_t.
```

- **(F2) 外国商品需求**

```math
P_{F,t}C_{F,t}=\gamma P_tC_t.
```

- **(F3) 随机贴现因子**

```math
Q_{t,t+1}=\beta\left(\frac{C_{t+1}}{C_t}\right)^{-\sigma}\left(\frac{P_t}{P_{t+1}}\right).
```

- **(F4) 名义债券 Euler 方程**

```math
1=\beta R_t E_t\left[\left(\frac{C_{t+1}}{C_t}\right)^{-\sigma}\left(\frac{P_t}{P_{t+1}}\right)\right].
```

- **(F5) 带灵活工资加成的劳动供给**

```math
\frac{W_t(h)}{P_t}=(1+\mu_t^w)N_t(h)^\phi C_t^\sigma.
```

- **(F6) 对称劳动配置**

```math
W_t(h)=W_t,\qquad N_t(h)=N_t.
```

- **(F7) 国际风险分担**

```math
C_t=C_t^{\ast}.
```

- **(F8) 最终品对品种 $`f`$ 的需求**

```math
Y_t(f)=\left(\frac{P_{H,t}(f)}{P_{H,t}}\right)^{-\xi}Y_t.
```

- **(F9) 本国生产者价格指数**

```math
P_{H,t}=\left(\int_0^1 P_{H,t}(f)^{1-\xi}\,df\right)^{1/(1-\xi)}.
```

- **(F10) 实际边际成本**

```math
MC_t=\frac{(1-\tau)(W_t/P_{H,t})}{A_t}
=\frac{(1-\tau)(W_t/P_t)S_t^\gamma}{kA_t}.
```

- **(F11) Calvo 重置价格条件**

```math
E_t\sum_{j=0}^{\infty}\theta^j Q_{t,t+j}Y_{t+j}(f)
\left[P^0_{H,t}-(1+\mu^p)P_{H,t+j}MC_{t+j}\right]=0.
```

- **(F12) 灵活价格加成条件**

```math
\frac{P^0_{H,t}}{P_{H,t}}=(1+\mu^p)MC_t.
```

- **(F13) Calvo 价格指数运动方程**

```math
P_{H,t}=\left[\theta P_{H,t-1}^{1-\xi}+(1-\theta)(P^0_{H,t})^{1-\xi}\right]^{1/(1-\xi)}.
```

- **(F14) 总需求和贸易条件**

```math
Y_t=k^{-1}C_tS_t^\gamma,\qquad S_t=\frac{Y_t}{Y_t^{\ast}}.
```

- **(F15) 用本国和外国产出表示消费**

```math
C_t=kY_t^{1-\gamma}(Y_t^{\ast})^\gamma.
```

- **(F16) 含价格分散的总生产函数**

```math
Y_t=\frac{A_tN_t}{V_t},\qquad
V_t=\int_0^1\left(\frac{P_t(f)}{P_t}\right)^{-\xi}df\ge 1.
```

- **(F17) 产出形式的实际边际成本**

```math
MC_t=(1-\tau)k^{\sigma-1}(1+\mu_t^w)A_t^{-(1+\phi)}
Y_t^\kappa(Y_t^{\ast})^{\kappa_0}V_t^\phi.
```

- **(F18) 开放经济斜率参数**

```math
\kappa=\sigma(1-\gamma)+\gamma+\phi=\sigma+\phi-\kappa_0,\qquad
\kappa_0=\gamma(\sigma-1).
```

- **(F19) 国内灵活价格边际成本**

```math
\overline{MC}=\frac{1}{1+\mu^p}.
```

- **(F20) 国内自然产出**

```math
\bar{Y}_t=
\left[
\frac{k^{1-\sigma}A_t^{1+\phi}(Y_t^{\ast})^{-\kappa_0}}
{(1-\tau)(1+\mu^w)(1+\mu^p)}
\right]^{1/\kappa}.
```

- **(F21) 全球灵活价格自然产出**

```math
\bar{\bar{Y}}_t=
\left[
\frac{k^{1-\sigma}A_t^{1+\phi}(\bar{\bar{Y}}_t^{\ast})^{-\kappa_0}}
{(1-\tau)(1+\mu^w)(1+\mu^p)}
\right]^{1/\kappa}
=\bar{Y}_t\left(\frac{\bar{\bar{Y}}_t^{\ast}}{Y_t^{\ast}}\right)^{-\kappa_0/\kappa}.
```

- **(F22) Log-linear 总需求**

```math
y_t=c_t+\gamma s_t.
```

- **(F23) Log-linear 消费 Euler 方程**

```math
c_t=E_t c_{t+1}
-\frac{1}{\sigma}\left(r_t-E_t\pi_{t+1}-\gamma E_t\Delta s_{t+1}\right).
```

- **(F24) Log-linear 贸易条件**

```math
s_t=y_t-y_t^{\ast}.
```

- **(F25) Log-linear 生产**

```math
y_t=a_t+n_t.
```

- **(F26) 以边际成本表示的新凯恩斯 Phillips 曲线**

```math
\pi_t=\delta mc_t+\beta E_t\pi_{t+1},\qquad
\delta=\frac{(1-\theta)(1-\beta\theta)}{\theta}.
```

- **(F27) 边际成本等于国内产出缺口加成本推动冲击**

```math
mc_t=\kappa\tilde{y}_t+\mu_t^w.
```

- **(F28) 对数偏离形式的国内自然产出**

```math
\bar{y}_t=\kappa^{-1}\left[(1+\phi)a_t-\kappa_0y_t^{\ast}\right].
```

- **(F29) 国内产出缺口 IS 方程**

```math
\tilde{y}_t=E_t\tilde{y}_{t+1}
-\sigma_0^{-1}\left[r_t-E_t\pi_{t+1}-\overline{rr}_t\right],
\qquad \sigma_0=\sigma-\kappa_0.
```

- **(F30) 国内产出缺口 Phillips 曲线**

```math
\pi_t=\beta E_t\pi_{t+1}+\lambda\tilde{y}_t+u_t,
\qquad \lambda=\delta\kappa,\quad u_t=\delta\hat{\mu}^w_t.
```

- **(F31) 国内自然实际利率**

```math
\overline{rr}_t=\sigma_0E_t\Delta\bar{y}_{t+1}
+\kappa_0E_t\Delta y_{t+1}^{\ast}.
```

- **(F32) 自然贸易条件关系**

```math
s_t=(\tilde{y}_t-\tilde{y}_t^{\ast})+(\bar{y}_t-\bar{y}_t^{\ast})=(\tilde{y}_t-\tilde{y}_t^{\ast})+\bar{s}_t.
```

- **(F33) Nash 补贴条件**

```math
(1-\tau)(1+\mu^w)(1+\mu^p)(1-\gamma)=1.
```

- **(F34) Nash 政策损失**

```math
W^H=-(1-\gamma)\frac{\Lambda}{2}E_0\sum_{t=0}^{\infty}\beta^t
\left[\pi_t^2+\alpha\tilde{y}_t^2\right],
\quad \Lambda=\frac{\xi}{\delta},\quad \alpha=\frac{\lambda}{\xi}.
```

- **(F35) Nash 相机抉择最优性条件**

```math
\tilde{y}_t=-\frac{\lambda}{\alpha}\pi_t=-\xi\pi_t.
```

- **(F36) Nash 通胀和产出缺口简约解**

```math
\pi_t=\psi u_t,\qquad \tilde{y}_t=-\xi\psi u_t,\qquad
\psi=\left[(1-\beta\rho)+\lambda\xi\right]^{-1}.
```

- **(F37) 实施 Nash 政策的利率规则**

```math
r_t=\overline{rr}_t+\vartheta E_t\pi_{t+1},\qquad
\vartheta=1+\frac{\xi\sigma_0(1-\rho)}{\rho}>1.
```

- **(F38) 合作补贴条件**

```math
(1-\tau)(1+\mu^w)(1+\mu^p)=1.
```

- **(F39) 合作缺口定义**

```math
\tilde{\tilde{y}}_t=\tilde{y}_t-\frac{\kappa_0}{\kappa}\tilde{y}_t^{\ast}.
```

- **(F40) 合作福利损失**

```math
W_C=-\frac{1}{2}\Lambda E_0\sum_{t=0}^{\infty}\beta^t
\left[
(1-\gamma)\left(\pi_t^2+\alpha\tilde{\tilde{y}}_t^2\right)
+\gamma\left((\pi_t^{\ast})^2+\alpha^{\ast}(\tilde{\tilde{y}}_t^{\ast})^2\right)
-2\Phi\tilde{\tilde{y}}_t\tilde{\tilde{y}}_t^{\ast}
\right],
```

```math
\Phi=\frac{\delta(1-\sigma)\gamma(1-\gamma)}{\xi}.
```

- **(F41) 合作情形本国 Phillips 曲线**

```math
\pi_t=\beta E_t\pi_{t+1}+\lambda\tilde{\tilde{y}}_t
+\lambda_0\tilde{\tilde{y}}_t^{\ast}+u_t,\qquad \lambda_0=\delta\kappa_0.
```

- **(F42) 合作情形外国 Phillips 曲线**

```math
\pi_t^{\ast}=\beta E_t\pi_{t+1}^{\ast}+\lambda^{\ast}\tilde{\tilde{y}}_t^{\ast}
+\lambda_0^{\ast}\tilde{\tilde{y}}_t+u_t^{\ast}.
```

- **(F43) 以全球缺口表示的合作最优性条件**

```math
\tilde{\tilde{y}}_t=-\xi\pi_t,\qquad
\tilde{\tilde{y}}_t^{\ast}=-\xi\pi_t^{\ast}.
```

- **(F44) 以国内缺口表示的合作最优性条件**

```math
\tilde{y}_t=-\xi\left(\pi_t+\frac{\kappa_0}{\kappa}\pi_t^{\ast}\right),\qquad
\tilde{y}_t^{\ast}=-\xi\left(\pi_t^{\ast}+\frac{\kappa_0^{\ast}}{\kappa^{\ast}}\pi_t\right).
```

- **(F45) 合作情形 Taylor 型规则**

```math
r_t=\overline{rr}_t^d+\vartheta E_t\pi_{t+1}
+\frac{\kappa_0}{\kappa}(\vartheta-1)E_t\pi_{t+1}^{\ast}.
```

`needs_review`：MinerU OCR 在论文 Eq. (61) 和 Eq. (77) 中把 $`\vartheta`$ 渲染成 `9`；论文 Eq. (76) 附近的合作通胀简约式存在重复且不可辨认的 $`\psi`$ 符号。这些内容在提升为 reviewed 之前需要对照 PDF。

## 4. Market Clearing & Identities

- 本国和外国商品市场出清：

```math
(1-\gamma)Y_t=(1-\gamma)C_{H,t}+\gamma C_{H,t}^{\ast},\qquad
\gamma Y_t^{\ast}=(1-\gamma)C_{F,t}+\gamma C_{F,t}^{\ast}.
```

- 完全传递和一价定律意味着 CPI 实际汇率为 1：

```math
\frac{E_tP_t^{\ast}}{P_t}=1.
```

- 两国贸易平衡：

```math
P_{H,t}Y_t=P_tC_t,\qquad P_{F,t}^{\ast}Y_t^{\ast}=P_t^{\ast}C_t^{\ast}.
```

- 名义汇率恒等式：

```math
e_t=e_{t-1}+s_t-s_{t-1}+\pi_t-\pi_t^{\ast}.
```

这些恒等式支撑 (F14)、(F15)、(F24) 和 (F32) 中的简约系统。外国经济有带星号变量和人口权重替换的对称方程。

## 5. Exogenous Processes

- **(F46) 成本推动冲击**

```math
u_t=\rho u_{t-1}+\varepsilon_t,\qquad 0<\rho<1.
```

- **(F47) 外国成本推动冲击**

```math
u_t^{\ast}=\rho u_{t-1}^{\ast}+\varepsilon_t^{\ast}.
```

- **(F48) 技术冲击**

```math
a_t \ \text{and}\ a_t^{\ast} \ \text{enter natural output through (F28) and its foreign analogue.}
```

`needs_review`：论文明确给出成本推动冲击的 AR(1)，但 MinerU Markdown 没有为技术状态给出单独随机过程。实现时如果需要技术 AR(1)，应从 MMB 代码或校准来源指定，而不能仅由本文文字推断。

## 6. Steady-State Solution

本档案条目是 log-linear 解析模型。稳态是小写变量围绕其取对数偏离的确定性零通胀参考点。

1. 归一化技术和对称产出水平：$`A=A^{\ast}=1`$，在对称稳态下 $`Y=Y^{\ast}`$，因此 $`S=1`$。
2. 消费风险分担和贸易平衡意味着 $`C=C^{\ast}`$ 且 $`Y=k^{-1}CS^\gamma`$，因此 $`S=1`$ 时 $`C=kY`$。
3. 零国内通胀且无价格分散时，所有重置价格等于价格指数，$`V=1`$。
4. 灵活价格加成条件给定 $`MC=(1+\mu^p)^{-1}`$。
5. Nash 稳态补贴满足 (F33)；合作稳态补贴满足 (F38)。这是两个不同的稳态政策扭曲，不能混用。
6. 在选定确定性参考值后，log-linear 动态变量满足 $`\bar{x}=0`$，其中 $`x\in\{y,c,s,n,mc,\pi,\tilde{y},u,a,r-\bar{rr}\}`$。
7. 自然产出规律 (F28) 和自然实际利率规律 (F31) 给出从技术与外国产出到本国自然水平的稳态一致映射。

本条目没有完成数值校准或 Dynare `steady_state_model` 验证。

## 7. Timing & Form Conventions

- 本推导为 log-linear 形式。小写变量表示相对稳态的对数偏离；但 $`r_t`$、$`\pi_t`$ 和相关利率/通胀变量沿用论文解析记号，为通胀或利率偏离。
- 国内通胀 $`\pi_t`$ 是生产者价格通胀，不是 CPI 通胀。最优政策瞄准国内通胀；汇率在浮动汇率制度下调整。
- $`\tilde{y}_t`$ 是相对国内灵活价格配置的国内产出缺口，该配置把外国产出视为给定。$`\tilde{\tilde{y}}_t`$ 是相对全球灵活价格合作配置的产出缺口。
- 贸易条件水平定义为 $`S_t=P_{F,t}/P_{H,t}`$，log-linear 均衡中 $`s_t=y_t-y_t^{\ast}`$。
- 本模型没有资本存量。生产对劳动线性，因此不需要资本时序约定。
- IS 曲线是前瞻的：$`r_t-E_t\pi_{t+1}`$ 是预期实际利率项，并由国内自然实际利率调整。
- 政策问题是相机抉择，而非承诺；央行把未来预期视为给定。

## 8. Variable & Parameter Reference Table

### 内生变量

| 符号 | 含义 | 主要方程 |
|---|---|---|
| $`C_t,C_{H,t},C_{F,t}`$ | 本国消费总量及分项 | (F1), (F2), (F15) |
| $`C_t^{\ast}`$ | 外国消费总量 | (F7) 和外国对称式 |
| $`Y_t,Y_t^{\ast}`$ | 本国和外国产出 | (F14), (F16), (F22), (F25) |
| $`N_t,N_t^{\ast}`$ | 劳动 | (F5), (F6), (F16), (F25) |
| $`P_t,P_{H,t},P_{F,t}`$ | CPI 和生产者价格 | (F1), (F2), (F9), (F13) |
| $`P^0_{H,t}`$ | Calvo 重置价格 | (F11), (F12), (F13) |
| $`S_t,s_t`$ | 贸易条件 | (F14), (F24), (F32) |
| $`MC_t,mc_t`$ | 实际边际成本 | (F10), (F17), (F26), (F27) |
| $`V_t`$ | 价格分散 | (F16) |
| $`\bar{Y}_t,\bar{\bar{Y}}_t`$ | 国内和全球自然产出 | (F20), (F21), (F28) |
| $`\tilde{y}_t,\tilde{\tilde{y}}_t`$ | 国内和合作产出缺口 | (F29), (F30), (F39), (F43), (F44) |
| $`\pi_t,\pi_t^{\ast}`$ | 国内生产者通胀 | (F26), (F30), (F41), (F42) |
| $`r_t`$ | log-linear 政策系统中的名义政策利率 | (F29), (F37), (F45) |
| $`\overline{rr}_t`$ | 国内自然实际利率 | (F31), (F37), (F45) |
| $`e_t`$ | 名义汇率 | 第 4 节恒等式 |
| $`u_t,u_t^{\ast}`$ | 成本推动冲击 | (F30), (F41), (F42), (F46), (F47) |
| $`a_t,a_t^{\ast}`$ | 技术冲击 | (F28), (F48) |

### 外生冲击

| 符号 | 含义 | 来源状态 |
|---|---|---|
| $`\varepsilon_t,\varepsilon_t^{\ast}`$ | 成本推动创新 | 来源在 (F46), (F47) 中明示 |
| $`a_t,a_t^{\ast}`$ | 生产率过程 | 技术状态由来源明示，随机过程需要复核 |

### 参数

| 符号 | 含义 |
|---|---|
| $`\beta`$ | 家庭贴现因子 |
| $`\sigma`$ | 跨期替代弹性倒数 / CRRA 参数 |
| $`\phi`$ | 劳动负效用曲率 |
| $`\gamma`$ | 外国人口权重，也是本国消费中的进口份额 |
| $`k`$ | Cobb-Douglas 消费价格归一化常数 |
| $`\eta_t,\mu_t^w,\mu^w`$ | 劳动需求弹性和工资加成 |
| $`\xi,\mu^p`$ | 中间品需求弹性和价格加成 |
| $`\theta`$ | Calvo 不调价概率 |
| $`\tau`$ | 工资账单补贴 |
| $`\delta`$ | Phillips 曲线 Calvo 系数 $`(1-\theta)(1-\beta\theta)/\theta`$ |
| $`\kappa,\kappa_0,\sigma_0`$ | 开放经济边际成本和 IS 斜率组合参数 |
| $`\lambda,\lambda_0`$ | Phillips 曲线斜率和国际边际成本溢出 |
| $`\alpha,\alpha^{\ast}`$ | 本国和外国福利损失中的产出缺口权重 |
| $`\Lambda,\Phi`$ | 福利损失尺度和合作交叉缺口项 |
| $`\rho`$ | 成本推动冲击持续性 |
| $`\psi,\vartheta`$ | 简约政策系数；来源 OCR 敏感 |
