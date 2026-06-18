# EAUS_NAWMctww 推导

> 状态：`needs_review`。这是基于 MinerU Markdown 的第一轮论文侧提取；MMB 复现文件只作为 `implementation_cross_check` 使用。未执行 Dynare 运行验证。

来源记录：Cogan, John F.; Taylor, John B.; Wieland, Volker; Wolters, Maik H. (2013), "Fiscal consolidation strategy", Journal of Economic Dynamics and Control 37, 404-421, DOI `10.1016/j.jedc.2012.10.004`。主来源：`raw/mmb_mineru/runs/eaus_nawmctww__fiscal_consolidation_strategy__97cf0e5f/full.md`；原始 PDF 记录在 `raw/mmb_papers/Fiscal consolidation strategy.pdf`。

## 1. Model Overview

- **模型**：`EAUS_NAWMctww`，即 Cogan-Taylor-Wieland-Wolters 财政整顿校准下的 Coenen-McAdam-Straub New Area-Wide Model (NAWM/CMS)。
- **用途**：在包含前瞻主体、名义刚性、财政工具和政府债务的美国/欧元区两区域 DSGE 模型中评估美国财政整顿。
- **主体与当局**：每个经济体有两类家庭、中间品企业、最终品企业、财政当局、货币当局，以及连接两区域的外国债券市场。
- **形式**：围绕确定性稳态求解的非线性均衡系统。论文给出结构性非线性方程和模拟；MMB `.mod` 交叉检查也使用非线性 `model;` 块，而不是 `model(linear)`。
- **来源覆盖**：Markdown 包含财政部门、家庭、企业和货币规则的主要结构方程。部分一阶递归和实现变量在 `.mod` 中记录更完整；凡使用该来源处均标记为仅实现交叉检查证据。

## 2. Optimization Problems

### 2.1 Household I

Household I 成员可以选择消费、投资、下一期资本、资本利用率、国内债券、外币债券和货币。其期效用包含消费外部习惯和可分离劳动负效用：

```math
E_t \sum_{k=0}^{\infty}\beta^k\left[
\frac{(C_{i,t+k}-\kappa C_{I,t+k-1})^{1-\sigma}}{1-\sigma}
-\frac{N_{i,t+k}^{1+\theta}}{1+\theta}
\right].
```

名义预算约束为：

```math
\begin{aligned}
&(1+\tau_t^C+\Gamma_v(v_{i,t}))P_{C,t}C_{i,t}+P_{I,t}I_{i,t}
+R_t^{-1}B_{i,t+1}
+\big((1-\Gamma_{B^F}(B_t^F))R_{F,t}\big)^{-1}S_tB_{i,t+1}^F
+M_{i,t}+\phi_{i,t} \\
&=(1-\tau_t^N-\tau_t^{W_h})W_{i,t}N_{i,t}
+(1-\tau_t^K)(R_{K,t}u_{i,t}-\Gamma_u(u_{i,t})P_{I,t})K_{i,t}
+\tau_t^K\delta P_{I,t}K_{i,t} \\
&\quad +(1-\tau_t^D)D_{i,t}+TR_{i,t}-T_{i,t}
+B_{i,t}+S_tB_{i,t}^{F}+M_{i,t-1}.
\end{aligned}
```

资本积累为：

```math
K_{i,t+1}=(1-\delta)K_{i,t}+\left[1-\Gamma_I\left(\frac{I_{i,t}}{I_{i,t-1}}\right)\right]I_{i,t}.
```

Household I 还在 Calvo 工资设定中供给差异化劳动；不能重设工资时按指数化规则调整。

### 2.2 Household J

Household J 具有与 Household I 相同的效用核，但不能进入债券市场，也不能积累实物资本。它在以下约束下选择消费、货币和劳动：

```math
(1+\tau_t^C+\Gamma_v(v_{j,t}))P_{C,t}C_{j,t}+M_{j,t}
=(1-\tau_t^N-\tau_t^{W_h})W_{j,t}N_{j,t}+TR_{j,t}-T_{j,t}+M_{j,t-1}+\phi_{j,t}.
```

Household J 也以相同的 Calvo-指数化结构设定差异化工资。财政整顿校准把转移支付和一次总付税平均分配给两类家庭，而不是采用 CMS 基准中的不均等分配。

### 2.3 Intermediate-Good Firms

中间品企业使用资本服务和劳动组合生产可贸易差异化产品：

```math
Y_{f,t}=\max\left[z_tK_{f,t}^{\alpha}N_{f,t}^{1-\alpha}-\psi,0\right].
```

它们最小化投入成本，并在 Calvo 合约和指数化下设定国内价格与出口价格。能够重设价格的企业最大化国内和出口市场未来利润的贴现期望和。

### 2.4 Final-Good Firms

最终品企业用 CES 技术把国内中间品和进口中间品组合为私人消费品与投资品，并包含进口调整成本。公共消费品只使用国内中间品。

### 2.5 Authorities

财政当局设定政府购买、转移支付、债务目标和扭曲性税率，一次总付税对债务缺口作出反应。货币当局通过带利率平滑的 Taylor 型规则设定名义利率。

## 3. First-Order Conditions

以下方程是紧凑的来源支持推导。部分完整实现递归标记为 `needs_review`，因为论文给出的是简化结构方程，而 `.mod` 包含操作性递归形式。

**Household I**

- **(F1) 含交易成本楔子的消费边际效用**：

```math
\lambda_{I,t}\left(1+\tau_t^C+\Gamma_v(v_{I,t})+v_{I,t}\Gamma_v'(v_{I,t})\right)
= (C_{I,t}-\kappa C_{I,t-1})^{-\sigma}.
```

- **(F2) 国内债券 Euler 方程**：

```math
R_t=\beta^{-1}\frac{\lambda_{I,t}}{\lambda_{I,t+1}}\Pi_{C,t+1}.
```

- **(F3) 货币需求/速度条件**：

```math
v_{I,t}^2\Gamma_v'(v_{I,t})
=1-\beta\frac{\lambda_{I,t+1}}{\lambda_{I,t}\Pi_{C,t+1}}.
```

- **(F4) 消费速度定义**：

```math
v_{I,t}=\frac{(1+\tau_t^C)C_{I,t}}{M_{I,t}}.
```

- **(F5) 投资调整成本**：

```math
\Gamma_I\left(\frac{I_{I,t}}{I_{I,t-1}}\right)
=\frac{\gamma_I}{2}\left(\frac{I_{I,t}}{I_{I,t-1}}-1\right)^2.
```

- **(F6) 资本积累**：

```math
K_{I,t+1}=(1-\delta)K_{I,t}+\left[1-\Gamma_I\left(\frac{I_{I,t}}{I_{I,t-1}}\right)\right]I_{I,t}.
```

- **(F7) 资本利用率条件**：

```math
R_{K,t}=P_{I,t}\Gamma_u'(u_t).
```

- **(F8) 安装资本价格的投资 FOC**：

```math
P_{I,t}=Q_t\left[1-\Gamma_I(s_t)-\Gamma_I'(s_t)s_t\right]
+\beta E_t\left[\frac{\lambda_{I,t+1}}{\lambda_{I,t}}Q_{t+1}\Gamma_I'(s_{t+1})s_{t+1}^2\right],
\quad s_t=\frac{I_{I,t}}{I_{I,t-1}}.
```

- **(F9) 含资本所得税的资本 Euler 方程**：

```math
Q_t=\beta E_t\left[\frac{\lambda_{I,t+1}}{\lambda_{I,t}}
\left((1-\tau_{t+1}^K)(R_{K,t+1}u_{t+1}-\Gamma_u(u_{t+1})P_{I,t+1})
+\tau_{t+1}^K\delta P_{I,t+1}+(1-\delta)Q_{t+1}\right)\right].
```

- **(F10) Household I 最优重设工资**（`needs_review`，论文说明 Calvo 工资问题但未给出完整递归）：

```math
\widetilde W_{I,t}^{1+\eta_I\theta}
=\frac{\eta_I}{\eta_I-1}\frac{F_{I,t}}{G_{I,t}}.
```

**Household J**

- **(F11) Household J 预算约束**：

```math
(1+\tau_t^C+\Gamma_v(v_{J,t}))P_{C,t}C_{J,t}+M_{J,t}
=(1-\tau_t^N-\tau_t^{W_h})W_{J,t}N_{J,t}+TR_{J,t}-T_{J,t}+M_{J,t-1}.
```

- **(F12) Household J 消费边际效用**：

```math
\lambda_{J,t}\left(1+\tau_t^C+\Gamma_v(v_{J,t})+v_{J,t}\Gamma_v'(v_{J,t})\right)
=(C_{J,t}-\kappa C_{J,t-1})^{-\sigma}.
```

- **(F13) Household J 货币需求**：

```math
v_{J,t}^2\Gamma_v'(v_{J,t})
=1-\beta\frac{\lambda_{J,t+1}}{\lambda_{J,t}\Pi_{C,t+1}}.
```

- **(F14) Household J 最优重设工资**（`needs_review`）：

```math
\widetilde W_{J,t}^{1+\eta_J\theta}
=\frac{\eta_J}{\eta_J-1}\frac{F_{J,t}}{G_{J,t}}.
```

**Firms**

- **(F15) 生产技术**：

```math
Y_{s,t}=z_tK_{d,t}^{\alpha}N_{d,t}^{1-\alpha}-\psi.
```

- **(F16) 资本需求条件**：

```math
R_{K,t}=\alpha\frac{Y_{s,t}+\psi}{K_{d,t}}MC_t.
```

- **(F17) 边际成本**：

```math
MC_t=\frac{R_{K,t}^{\alpha}\left((1+\tau_t^{W_f})W_t\right)^{1-\alpha}}
{z_t\alpha^{\alpha}(1-\alpha)^{1-\alpha}}.
```

- **(F18) 劳动聚合与劳动需求**：

```math
N_{d,t}^{1-1/\eta}
=(1-\omega)^{1/\eta}N_{dI,t}^{1-1/\eta}
+\omega^{1/\eta}N_{dJ,t}^{1-1/\eta},
```

```math
N_{dI,t}=(1-\omega)\left(\frac{W_{I,t}}{W_t}\right)^{-\eta}N_{d,t},
\quad
N_{dJ,t}=\omega\left(\frac{W_{J,t}}{W_t}\right)^{-\eta}N_{d,t}.
```

- **(F19) 国内价格 Calvo 重设条件**（`needs_review`）：

```math
\frac{\widetilde P_{H,t}}{P_{H,t}}
=\frac{\theta_p}{\theta_p-1}\frac{F_{H,t}}{G_{H,t}}.
```

- **(F20) 国内价格指数化法则**：

```math
P_{H,t}^{1-\theta_p}
=(1-\xi_H)\widetilde P_{H,t}^{1-\theta_p}
+\xi_H\left(P_{H,t-1}\Pi_{H,t-1}^{\chi_H}\bar\Pi_H^{1-\chi_H}/\Pi_{C,t}\right)^{1-\theta_p}.
```

- **(F21) 出口价格 Calvo 重设条件**（`needs_review`）：

```math
\frac{\widetilde P_{X,t}}{P_{X,t}}
=\frac{\theta_p}{\theta_p-1}\frac{F_{X,t}}{G_{X,t}}.
```

- **(F22) 消费品 CES 技术**：

```math
Q_{C,t}^{(\mu_C-1)/\mu_C}
=\nu_C^{1/\mu_C}H_{C,t}^{1-1/\mu_C}
+(1-\nu_C)^{1/\mu_C}\left[(1-\Gamma_{IM,C,t})IM_{C,t}\right]^{1-1/\mu_C}.
```

- **(F23) 投资品 CES 技术**：

```math
Q_{I,t}^{(\mu_I-1)/\mu_I}
=\nu_I^{1/\mu_I}H_{I,t}^{1-1/\mu_I}
+(1-\nu_I)^{1/\mu_I}\left[(1-\Gamma_{IM,I,t})IM_{I,t}\right]^{1-1/\mu_I}.
```

## 4. Market Clearing & Identities

- **(F24) 政府预算约束**：

```math
\begin{aligned}
P_{G,t}G_t+TR_t+B_t+M_{t-1}
&=\tau_t^CP_{C,t}C_t+\tau_t^N(W_{I,t}N_t^I+W_{J,t}N_t^J)
+\tau_t^{W_h}(W_{I,t}N_t^I+W_{J,t}N_t^J) \\
&\quad+\tau_t^{W_f}W_tN_t
+\tau_t^K\left(R_{K,t}u_t-(\Gamma_u(u_t)+\delta)P_{I,t}\right)K_t
+T_t+R_t^{-1}B_{t+1}+M_t.
\end{aligned}
```

- **(F25) 一次总付税/债务反馈规则**：

```math
\frac{T_t}{P_{Y,t}Y_t}
=\phi_{B_Y}\left(\frac{B_t}{P_{Y,t}Y_t}-B^{\ast}\right).
```

- **(F26) 财政支出份额**：

```math
P_{H,t}G_t=GY_t\,\bar P_Y\bar Y,
\quad
TR_t=TRY_t\,\bar P_Y\bar Y.
```

- **(F27) 总消费、货币、资本与投资**：

```math
C_t=(1-\omega)C_{I,t}+\omega C_{J,t},\quad
M_t=(1-\omega)M_{I,t}+\omega M_{J,t},
```

```math
K_t=(1-\omega)K_{I,t},\quad I_t=(1-\omega)I_{I,t}.
```

- **(F28) 国内吸收与贸易资源恒等式**：

```math
P_{Y,t}Y_t
=Q_{C,t}+P_{I,t}Q_{I,t}+P_{H,t}G_t
+RER_tP_{M,t}^{\ast}\frac{SIZE^{\ast}}{SIZE}IM_t^{\ast}
-P_{M,t}\left(\frac{IM_{C,t}(1-\Gamma_{IM,C,t})}{\Gamma_{IM,C,t}^{\dagger}}
+\frac{IM_{I,t}(1-\Gamma_{IM,I,t})}{\Gamma_{IM,I,t}^{\dagger}}\right).
```

- **(F29) 产出恒等式**：

```math
Y_t=Y_{s,t}.
```

- **(F30) 资本服务恒等式**：

```math
u_tK_t=K_{d,t}.
```

- **(F31) 国内中间品使用恒等式**：

```math
H_t=H_{C,t}+H_{I,t}+G_t.
```

- **(F32) 进口使用恒等式**：

```math
IM_t=IM_{C,t}+IM_{I,t}.
```

- **(F33) 对外净资产与贸易余额恒等式**（论文侧来源中的精确时序 `needs_review`）：

```math
TB_t=RER_tP_{M,t}^{\ast}\frac{SIZE^{\ast}}{SIZE}IM_t^{\ast}-P_{M,t}IM_t,
\quad
\frac{B_t^F}{R_{t-1}^{\ast}}=B_{t-1}^F+\frac{TB_{t-1}}{RER_{t-1}}.
```

- **(F34) 世界外国债券出清**：

```math
SIZE\cdot B_t^F+SIZE^{\ast}\cdot B_t^{F,\ast}=0.
```

## 5. Exogenous Processes

- **(F35) 全要素生产率**：

```math
\log z_t=(1-\rho_z)\log \bar z+\rho_z\log z_{t-1}+\varepsilon^z_t.
```

- **(F36) 政府购买比率**：

```math
GY_t=(1-\rho_G)\bar{GY}+\rho_GGY_{t-1}+\varepsilon^G_t.
```

- **(F37) 转移支付比率**：

```math
TRY_t=(1-\rho_{TR})\bar{TRY}+\rho_{TR}TRY_{t-1}+\varepsilon^{TR}_t.
```

- **(F38) 税率过程**：

```math
\tau_t^x=(1-\rho_x)\bar\tau^x+\rho_x\tau_{t-1}^x+\varepsilon_t^x,
\quad x\in\{C,D,K,N,W_h,W_f\}.
```

- **(F39) 货币政策规则**：

```math
R_t^4-1=\phi_R(R_{t-1}^4-1)
+(1-\phi_R)\left[R_{\star}^4\bar\Pi_4-1+\phi_\Pi(\Pi_{C,t}^{(4)}-\bar\Pi_4)\right]
+\phi_{g_Y}\left(\frac{Y_t}{Y_{t-1}}-1\right)+\varepsilon^R_t.
```

- **(F40) 四季度 CPI 通胀与实际利率**：

```math
\Pi_{C,t}^{(4)}=\Pi_{C,t}\Pi_{C,t-1}\Pi_{C,t-2}\Pi_{C,t-3},
\quad
RR_t-1=\frac{R_t}{\Pi_{C,t+1}}-1.
```

## 6. Steady-State Solution

论文报告校准目标，`.mod` 交叉检查保存了数值 `initval` 块，但本第一轮条目没有重新求解完整两国稳态。未执行运行验证。

稳态限制：

```math
z=\bar z,\quad GY=\bar{GY},\quad TRY=\bar{TRY},\quad \tau^x=\bar\tau^x.
```

```math
RR-1=\beta^{-1}-1,\quad \Pi_C^{(4)}=\bar\Pi_4,\quad R=\beta^{-1}\bar\Pi_4^{1/4}.
```

```math
\Gamma_I(1)=0,\quad \Gamma_I'(1)=0,\quad u=1,\quad K_d=K.
```

```math
\frac{T}{P_YY}=\phi_{B_Y}\left(\frac{B}{P_YY}-B^{\ast}\right).
```

实现交叉检查中的美国校准使用 `US_BETA=0.992638`, `US_SIGMA=1`, `US_KAPPA=0.67`, `US_OMEGA=0.2651`, `US_ALPHA=0.30`, `US_DELTA=0.025`, `US_GYBAR=0.16`, `US_TRYBAR=0.079732`, `US_TAUCBAR=0.077`, `US_TAUKBAR=0.184123`, `US_TAUNBAR=0.154`, `US_TAUWHBAR=0.071`, `US_TAUWFBAR=0.071`。这些参数值是实现证据，不是独立的论文侧公式。

待处理问题：经审阅的归档版本应从论文和 NAWM 来源方程推导完整稳态系统，或记录一个已接受的参考稳态文件。因此本第一轮仍保持 `needs_review`。

## 7. Timing & Form Conventions

- 论文中家庭资本积累方程把资本写为下一期资本；MMB `.mod` 把 `K_t` 实现为由过去投资带来的存量，生产服务为 `K_{d,t}=u_tK_t`。
- Household I 持有为下一期选择的国内和外国债券；Household J 不能持有债券，只能通过货币平滑。
- 价格和工资采用 Calvo 重设概率；不能重设时按滞后通胀和稳态通胀目标指数化。
- 模型是两区域开放经济。`EAUS_NAWMctww` 实现使用美国变量作为共同比较变量，同时保留欧元区溢出和外国债券出清。
- 在实现中若干财政工具的自相关被设为零，以便直接施加已宣布的政府购买、转移支付和税率路径。
- 形式约定：非线性水平、比率和总通胀/利率；没有手工对数线性化，也没有 `model(linear)` 标记。

## 8. Variable & Parameter Reference Table

| 类别 | 符号 / ASCII 提示 | 含义 | 主要方程 |
|---|---|---|---|
| 内生 | `C_I`, `C_J`, `C` | Household I/J 与总消费 | (F1), (F11), (F12), (F27) |
| 内生 | `lambda_I`, `lambda_J` | 边际效用/乘子 | (F1), (F12) |
| 内生 | `M_I`, `M_J`, `M`, `v_I`, `v_J` | 货币与消费速度 | (F3), (F4), (F13), (F27) |
| 内生 | `K_I`, `K`, `K_d`, `I_I`, `I`, `u` | 资本、投资、利用率 | (F6), (F7), (F8), (F9), (F27), (F30) |
| 内生 | `R`, `RR`, `R_K`, `Q` | 名义/实际利率、资本租金、Tobin's Q | (F2), (F7), (F8), (F9), (F40) |
| 内生 | `W_I`, `W_J`, `W`, `N_I`, `N_J`, `N_d` | 工资与劳动聚合 | (F10), (F14), (F18) |
| 内生 | `Y_s`, `Y`, `MC`, `D` | 生产、产出、边际成本、股利 | (F15), (F16), (F17), (F29) |
| 内生 | `P_H`, `P_X`, `P_C`, `P_I`, `Pi_C` | 国内/出口/最终品价格与通胀 | (F19), (F20), (F21), (F40) |
| 内生 | `Q_C`, `Q_I`, `H_C`, `H_I`, `IM_C`, `IM_I` | 最终品和进口品组合 | (F22), (F23), (F31), (F32) |
| 内生 | `G`, `TR`, `T`, `B`, `BY`, `GY`, `TRY` | 财政变量与债务比率 | (F24), (F25), (F26), (F36), (F37) |
| 内生 | `RER`, `TB`, `B_F` | 实际汇率、贸易余额、外国债券 | (F28), (F33), (F34) |
| 外生 | `eps_z`, `eps_g`, `eps_tr`, `eps_r` | TFP、政府购买、转移支付、货币创新 | (F35), (F36), (F37), (F39) |
| 外生 | `eps_tauc`, `eps_taud`, `eps_tauk`, `eps_taun`, `eps_tauwh`, `eps_tauwf` | 税率创新 | (F38) |
| 参数 | `beta`, `sigma`, `kappa`, `theta`, `omega` | 偏好与家庭份额 | (F1), (F10), (F12), (F14), (F27) |
| 参数 | `alpha`, `delta`, `psi`, `eta`, `theta_p` | 技术、折旧、固定成本、替代弹性 | (F15), (F16), (F18), (F19) |
| 参数 | `xi_H`, `xi_X`, `chi_H`, `chi_X`, `xi_I`, `xi_J`, `chi_I`, `chi_J` | 价格和工资 Calvo/指数化参数 | (F10), (F14), (F20), (F21) |
| 参数 | `rho_z`, `rho_G`, `rho_TR`, `rho_x`, `phi_R`, `phi_Pi`, `phi_gY`, `phi_BY` | 持续性与政策反馈参数 | (F25), (F35), (F36), (F37), (F38), (F39) |
