# CL_MS07 - 来源支持的模型推导

> 私有 MMB 模型档案的一轮抽取稿。状态：`needs_review`。
> 未进行运行时验证。

## 1. Model Overview

- **模型 ID**：`CL_MS07`。
- **论文**：Juan Pablo Medina and Claudio Soto (2007), "The Chilean business cycles through the lens of a stochastic general equilibrium model", Central Bank of Chile Working Paper 457。
- **来源**：`raw/mmb_mineru/runs/cl_ms07__the_chilean_business_cycles_through_the_lens_of_a_stochastic_general_equ__ba200544/full.md`；原始 PDF 仅记录溯源，默认未读取正文：`raw/mmb_papers/The Chilean business cycles through the lens of a stochastic general equilibrium model.pdf`。
- **DOI**：`raw/mmb_mineru/model_index.csv` 中未列出。
- **经济体与用途**：面向智利的估计型开放经济 DSGE 模型，使用 1987:Q1 到 2005:Q4 的季度数据分解商业周期波动。
- **主要主体和部门**：Ricardian 家庭、非 Ricardian 家庭、工资设定者、资本/投资企业、国内中间品生产者、进口零售商、商品出口部门、财政当局、货币当局和国外部门。
- **模型形式**：线性化的理性预期系统。实现交叉检查文件使用 `model(linear)`。除非明确给出非线性来源方程，下列方程均按对数偏离理解。
- **主要摩擦与冲击**：外部借款溢价、习惯形成、Calvo 工资、带指数化的 Calvo 国内价格和进口价格、投资调整成本、结构性财政规则、两个货币政策时期、铜价和油价冲击、永久和暂时生产率冲击、国外需求/通胀/利率冲击、偏好、劳动、财政、投资和货币冲击。

## 2. Optimization Problems

### Ricardian 家庭

Ricardian 家庭最大化含习惯形成、劳动负效用和实际货币余额的预期效用：

```math
E_t \sum_{i=0}^{\infty}\beta^i \zeta_{C,t+i}
\left[
\log(C_{t+i}(j)-\tilde h C_{t+i-1})
-\zeta_{L,t+i}\frac{l_{t+i}(j)^{1+\sigma_L}}{1+\sigma_L}
+\frac{\zeta_{\mathcal M}}{\mu}\left(\frac{\mathcal M_{t+i}(j)}{P_{C,t+i}}\right)^\mu
\right].
```

他们在名义预算约束下选择消费、货币、外国债券和状态或有国内债权；约束包含劳动收入、利润、税收、国内或有债权、货币和外国债券头寸。外部溢价是总净外国资产的函数：

```math
\mathcal B_t^{\ast}=\frac{\mathcal E_t B_t^{\ast}}{P_{Y,t}Y_t}, \qquad \Theta=\Theta(\mathcal B_t^{\ast}).
```

### 工资设定者

家庭是差异化劳动服务的垄断供给者。劳动聚合器形成：

```math
l_t=\left(\int_0^1 l_t(j)^{(\epsilon_L-1)/\epsilon_L}\,dj\right)^{\epsilon_L/(\epsilon_L-1)}.
```

每期家庭以概率 $`1-\phi_L`$ 重新优化名义工资；否则工资按基于过去 CPI 通胀和通胀目标的规则更新。

### 非 Ricardian 家庭

非 Ricardian 家庭不能进入资产市场，消费当期税后可支配劳动收入。

### 资本和投资企业

投资企业组合国内和国外投资品，

```math
I_t=\left[\gamma_I^{1/\eta_I}I_{H,t}^{1-1/\eta_I}+(1-\gamma_I)^{1/\eta_I}I_{F,t}^{1-1/\eta_I}\right]^{\eta_I/(\eta_I-1)},
```

并选择投资与资本，同时在资本积累方程中面对调整成本：

```math
K_{t+1}=(1-\delta)K_t+\zeta_{I,t}S\left(\frac{I_t}{I_{t-1}}\right)I_t.
```

### 国内生产者和进口零售商

国内生产者组合差异化国内品，并使用由增加值和石油构成的 CES 技术。增加值由劳动和资本组合而成。国内销售价格和出口价格设定均为 Calvo 问题。进口零售商从国外购买品种，在国内销售差异化进口品，并在 Calvo 黏性下以本币设定价格。

### 政府和国外部门

财政当局在合并预算约束和结构性余额规则下选择债务、税收和政府支出。货币当局分别遵循 1987-1999 与 2000-2005 两个时期的反馈规则。国外对智利国内品的需求取决于国外相对价格和国外总需求；铜和石油满足一价定律关系。

## 3. First-Order Conditions

- **(F1) Ricardian 消费 Euler 方程**：

```math
\hat c_t^R =
-\frac{1-h}{1+h}E_t[\hat i_t-\hat\pi_{C,t+1}]
+\frac{1}{1+h}E_t[\hat c_{t+1}^R]
+\frac{h}{1+h}\hat c_{t-1}^R
+\frac{1-h}{1+h}[\hat\zeta_{C,t}-E_t\hat\zeta_{C,t+1}]
-\frac{1}{1+h}[h\hat\zeta_{T,t}-E_t\hat\zeta_{T,t+1}].
```

- **(F2) 非 Ricardian 消费**：

```math
\hat c_t^{NR}=\frac{W}{P_CC}(\widehat{wr}_t+\hat l_t)-\frac{\mathcal T_p}{P_CC}\hat\tau_{p,t}.
```

- **(F3) 总消费**：

```math
\hat c_t=(1-\lambda)\hat c_t^R+\lambda\hat c_t^{NR}.
```

- **(F4) 未抛补利率平价**：

```math
\hat i_t=\hat i_t^{\ast}+\varrho\hat{\mathbf b}_t^{\ast}+E_t[\Delta\hat e_{t+1}].
```

- **(F5) 工资/劳动供给 Phillips 条件**：

```math
[\kappa_L+(1+\beta)]\widehat{wr}_t
=\kappa_L\left(\sigma_L\hat l_t+\frac{\hat c_t}{1-h}-\frac{h\hat c_{t-1}}{1-h}+\hat\zeta_{L,t}\right)
+\widehat{wr}_{t-1}+\beta E_t\widehat{wr}_{t+1}
-(1+\beta\chi_L)\hat\pi_{C,t}+\chi_L\hat\pi_{C,t-1}+\beta E_t\hat\pi_{C,t+1}.
```

- **(F6) 资本积累**：

```math
\hat k_{t+1}=\frac{1-\delta}{(1+n)(1+g_y)}\hat k_t+
\left(1-\frac{1-\delta}{(1+n)(1+g_y)}\right)(\widehat{inv}_t+\hat\zeta_{I,t}).
```

- **(F7) 投资的国内品需求**：

```math
\widehat{inv}_{H,t}=\widehat{inv}_t-\theta_I(\widehat{pr}_{H_D,t}-\widehat{pr}_{I,t}).
```

- **(F8) 投资的国外品需求**：

```math
\widehat{inv}_{F,t}=\widehat{inv}_t-\theta_I(\widehat{pr}_{F,t}-\widehat{pr}_{I,t}).
```

- **(F9) 投资价格指数**：

```math
\widehat{pr}_{I,t}=\gamma_I\widehat{pr}_{H_D,t}+(1-\gamma_I)\widehat{pr}_{F,t}.
```

- **(F10) 投资调整条件**：

```math
\widehat{pr}_{I,t}=\frac{Qr}{Pr_I}(\widehat{qr}_t+\varepsilon_{I,t})
-\frac{Qr}{Pr_I}\left(1+\frac{1}{1+r}\right)\mu_S(1+g_y)^2\widehat{inv}_t
+\frac{Qr}{Pr_I}\mu_S(1+g_y)^2\widehat{inv}_{t-1}
+\frac{Qr}{Pr_I}\frac{\mu_S(1+g_y)^2}{1+r}E_t\widehat{inv}_{t+1}.
```

- **(F11) 资本价格条件**：

```math
\widehat{qr}_t=E_t[\hat\pi_{C,t+1}-\hat i_t]
+\frac{1}{1+r}\frac{Zr}{Qr}E_t[\widehat{zr}_{t+1}]
+\frac{1-\delta}{1+r}E_t[\widehat{qr}_{t+1}].
```

- **(F12) 资本-劳动成本最小化**：

```math
\hat k_t-\hat\zeta_{T,t}-\hat l_t=\widehat{wr}_t-\widehat{zr}_t.
```

- **(F13) 石油投入成本最小化**：

```math
\frac{1}{\omega_H}\widehat{o}_{H,t}
-\left[\left(\frac{1}{\omega_H}+\frac{1}{\theta_H}\right)\eta_H-\frac{1}{\theta_H}\right]\hat l_t
-\left(\frac{1}{\omega_H}+\frac{1}{\theta_H}\right)(1-\eta_H)(\hat k_{t-1}-\hat\zeta_{T,t})
+\widehat{pr}_{O,t}-\widehat{wr}_t=0.
```

- **(F14) 国内品生产者边际成本**：

```math
\widehat{mcr}_{H,t}=
\frac{Zrk}{MCr_HY_H}(\widehat{zr}_t+\hat k_t)
+\frac{Wrl}{MCr_HY_H}(\widehat{wr}_t+\hat l_t)
+\frac{P_OO_H}{MCr_HY_H}(\widehat{pr}_{O,t}+\widehat{o}_{H,t})
-\widehat y_{H,t}.
```

- **(F15) 国内销售的国内品 Phillips 曲线**：

```math
\hat\pi_{H_D,t}=
\frac{\beta}{1+\beta\chi_{H_D}}E_t\hat\pi_{H_D,t+1}
+\frac{\chi_{H_D}}{1+\beta\chi_{H_D}}\hat\pi_{H_D,t-1}
+\frac{\kappa_{H_D}}{1+\beta\chi_{H_D}}(\widehat{mcr}_{H,t}-\widehat{pr}_{H_D,t}).
```

- **(F16) 出口国内品 Phillips 曲线**：

```math
\hat\pi_{H_F,t}=
\frac{\beta}{1+\beta\chi_{H_F}}E_t\hat\pi_{H_F,t+1}
+\frac{\chi_{H_F}}{1+\beta\chi_{H_F}}\hat\pi_{H_F,t-1}
+\frac{\kappa_{H_F}}{1+\beta\chi_{H_F}}(\widehat{mcr}_{H,t}-\widehat{rer}_t-\widehat{pr}_{H_F,t}).
```

- **(F17) 进口品 Phillips 曲线**：

```math
\hat\pi_{F,t}=
\frac{\beta}{1+\beta\chi_F}E_t\hat\pi_{F,t+1}
+\frac{\chi_F}{1+\beta\chi_F}\hat\pi_{F,t-1}
+\frac{\kappa_F}{1+\beta\chi_F}(\widehat{rer}_t+\hat\zeta^{\ast}_{F,t}-\widehat{pr}_{F,t}).
```

## 4. Market Clearing & Identities

- **(F18) 核心品消费需求**：

```math
\hat c_{Z,t}=\hat c_t-\omega_C\widehat{pr}_{Z,t}.
```

- **(F19) 石油消费需求**：

```math
\hat c_{O,t}=\hat c_t-\omega_C\widehat{pr}_{O,t}.
```

- **(F20) 消费价格规范化**：

```math
0=\alpha_C\widehat{pr}_{Z,t}+(1-\alpha_C)\widehat{pr}_{O,t}.
```

- **(F21) 国内品消费需求**：

```math
\hat c_{H,t}=\hat c_{Z,t}-\eta_C\widehat{pr}_{H_D,t}.
```

- **(F22) 国外品消费需求**：

```math
\hat c_{F,t}=\hat c_{Z,t}-\eta_C\widehat{pr}_{F,t}.
```

- **(F23) 核心消费价格指数**：

```math
\widehat{pr}_{Z,t}=\gamma_C\widehat{pr}_{H_D,t}+(1-\gamma_C)\widehat{pr}_{F,t}.
```

- **(F24) 财政结构性余额规则**：

```math
\frac{P_GG}{P_YY}\hat g_t=
\frac{\mathcal T_p}{P_YY}(\hat\tau_{p,t}-\hat y_t)
+\chi\frac{P_SY_S}{P_YY}(\widehat{\overline{pr}}_{S,t}+\hat y_{S,t}-\widehat{pr}_{Y,t}-\hat y_t)
+\cdots
+\frac{P_GG}{P_YY}(\hat\zeta_{G,t}+\widehat{pr}_{H_D,t}-\widehat{pr}_{Y,t}-\hat y_t).
```

`needs_review`：OCR 来源中的债务与汇率项可读但较长；本轮推导在正文中缩写，并在 `extraction_notes.md` 中记录完整来源位置。

- **(F25) 财政政策工具选择**：

```math
\hat g_t-\widehat{pr}_{H_D,t}+\widehat{pr}_{Y,t}+\hat y_t=0.
```

- **(F26) 财政净资产头寸**：

```math
\frac{\mathcal EB_G^{\ast}}{P_YY}\frac{1}{\Theta(1+i^{\ast})}\hat b_{G,t}
=\frac{1}{(1+\pi^{\ast})(1+g_y)(1+n)}\frac{\mathcal EB_G^{\ast}}{P_YY}
(\Delta\hat e_t-\hat\pi_{C,t}+\hat b_{G,t-1}-\Delta\widehat{pr}_{Y,t}-\Delta\hat y_t-\hat\zeta_{T,t})
+\cdots .
```

`needs_review`：OCR 换行使该式仍是一轮转写稿。

- **(F27) 1987-1999 货币政策规则**：

```math
\hat r_t=\psi_{i,1}\hat r_{t-1}
+(1-\psi_{i,1})(\psi_{\pi,1}-1)\hat\pi_{Z,t}
+(1-\psi_{i,1})\psi_{y,1}\Delta\hat y_t
+(1-\psi_{i,1})\psi_{rer,1}\widehat{rer}_t+\zeta_{m,t}.
```

- **(F28) 2000-2005 货币政策规则**：

```math
\hat i_t=\psi_{i,2}\hat i_{t-1}
+(1-\psi_{i,2})\psi_{\pi,2}\hat\pi_{Z,t}
+(1-\psi_{i,2})\psi_{y,2}\Delta\hat y_t+\zeta_{m,t}.
```

- **(F29) 国外对国内品的需求**：

```math
\widehat y^{\ast}_{H,t}=\hat y^{\ast}_t-\eta^{\ast}\widehat{pr}_{H_F,t}.
```

- **(F30) 商品品一价定律**：

```math
\widehat{pr}_{S,t}=\widehat{rer}_t+\widehat{pr}^{\ast}_{S,t}.
```

- **(F31) 石油一价定律**：

```math
\widehat{pr}_{O,t}=\widehat{rer}_t+\widehat{pr}^{\ast}_{O,t}.
```

- **(F32) 相对价格运动方程**：

```math
\hat\pi_{Z,t}=\widehat{pr}_{Z,t}-\widehat{pr}_{Z,t-1}+\hat\pi_{C,t}, \quad
\hat\pi_{H_D,t}=\widehat{pr}_{H_D,t}-\widehat{pr}_{H_D,t-1}+\hat\pi_{C,t},
```

```math
\hat\pi_{H_F,t}=\widehat{pr}_{H_F,t}-\widehat{pr}_{H_F,t-1}+\hat\pi^{\ast}_t, \quad
\hat\pi_{F,t}=\widehat{pr}_{F,t}-\widehat{pr}_{F,t-1}+\hat\pi_{C,t}.
```

- **(F33) 名义汇率贬值**：

```math
\Delta\hat e_t=\widehat{rer}_t-\widehat{rer}_{t-1}+\hat\pi_{C,t}-\hat\pi^{\ast}_t.
```

- **(F34) 实际利率**：

```math
\hat r_t=\hat i_t-\hat\pi_t.
```

- **(F35) 国内品需求**：

```math
\frac{P_HY_H}{P_YY}\hat y_{H,t}
=\gamma_C\frac{P_CC}{P_YY}\hat c_{H,t}
+\frac{P_GG}{P_YY}(\hat g_t-\widehat{pr}_{H_D,t}+\widehat{pr}_{Y,t}+\hat y_t)
+\gamma_I\frac{P_II}{P_YY}\widehat{inv}_{H,t}
+\frac{P_HY_H^{\ast}}{P_YY}\hat y^{\ast}_{H,t}.
```

- **(F36) 国内品供给**：

```math
\hat y_{H,t}=\hat a_{H,t}+\Xi_O\widehat{o}_{H,t}+\Xi_L\hat l_t+\Xi_K(\hat k_{t-1}-\hat\zeta_{T,t}),
```

其中 $`\Xi`$ 系数是来源附录中的稳态 CES 权重。

- **(F37) 实际 GDP 恒等式**：

```math
\hat y_t=\frac{P_CC}{P_YY}\hat c_t
+\frac{P_GG}{P_YY}(\hat g_t-\widehat{pr}_{H_D,t}+\widehat{pr}_{Y,t}+\hat y_t)
+\frac{P_II}{P_YY}\widehat{inv}_t
+\frac{P_XX}{P_YY}\hat x_t
-\frac{P_MM}{P_YY}\hat m_t.
```

- **(F38) 国际收支/净外国资产头寸**：

```math
\frac{(1-\varrho)\mathbf B^{\ast}}{(1+i^{\ast})\Theta(\mathbf B^{\ast})}\hat{\mathbf b}_t^{\ast}
=\frac{\mathbf B^{\ast}}{(1+i^{\ast})\Theta(\mathbf B^{\ast})}\hat i_t^{\ast}
-(1-\chi)\frac{\mathcal EP_S^{\ast}Y_S}{P_YY}(\widehat{pr}_{S,t}+\hat y_{S,t}-\widehat{pr}_{Y,t}-\hat y_t)
+\cdots .
```

`needs_review`：OCR 换行阻碍了完全审定的一轮转写。

- **(F39) 出口与进口模块**：

```math
\hat x_t=\frac{\mathcal EP_S^{\ast}Y_S}{P_XX}\hat y_{S,t}
+\left(1-\frac{\mathcal EP_S^{\ast}Y_S}{P_XX}\right)\hat c^{\ast}_{H,t},
```

```math
\hat m_t=(1-\gamma_C)\frac{P_CC}{P_MM}\hat c_{F,t}
+(1-\gamma_I)\frac{P_II}{P_MM}\widehat{inv}_{F,t}
+\frac{P_O(C_O+O_H)}{P_MM}\left(\frac{C_O}{C_O+O_H}\hat c_{O,t}+\frac{O_H}{C_O+O_H}\widehat{o}_{H,t}\right).
```

## 5. Exogenous Processes

- **(F40) 冲击过程**：

```math
\hat\xi_t=\rho_\xi\hat\xi_{t-1}+\varepsilon_{\xi,t}, \qquad
\varepsilon_{\xi,t}\sim N(0,\sigma_\xi^2),
```

其中

```math
\xi\in\{a_H,\zeta_T,y_S,y^{\ast},i^{\ast},\pi^{\ast},\zeta_m,\zeta_L,\zeta_C,\zeta_G,\zeta_I,\zeta_F^{\ast},p_O^{\ast},p_S^{\ast}\}.
```

实现交叉检查列出的对应创新为 `eps_ah`、`eps_st`、`eps_ys`、`eps_yF`、`eps_iF`、`eps_piF`、`eps_sh_m`、`eps_sh_w`、`eps_sh_c`、`eps_gex`、`eps_sh_i`、`eps_prfF`、`eps_proF` 和 `eps_prsF`。

## 6. Steady-State Solution

论文校准稳态比率和增长率，而不是给出紧凑的解析 `steady_state_model`。实现交叉检查在进入线性模型块之前计算稳态对象。来源支持的一轮值包括：

- 年度稳态劳动生产率增长 $`g_y=3.5\%`$；
- 年度稳态通胀目标 $`\bar\pi=3\%`$；
- 贴现因子 $`\beta=0.999`$；
- 非 Ricardian 家庭占比 $`\lambda=0.5`$；
- 商品部门增加值占比 $`Y_S/Y=10\%`$；
- 公共铜收入份额 $`\chi=40\%`$；
- 稳态经常账户/GDP 比率 $`CA/Y=-1.8\%`$；
- 年度折旧率 $`\delta=5.8\%`$；
- 国内增加值中劳动份额 $`\eta_H=0.66`$；
- 国内总产出中石油份额约为 1%；
- 基于 $`\epsilon_L=\epsilon_{H_D}=\epsilon_{H_F}=\epsilon_F=11`$ 的 CES 加成。

作为实现交叉检查的稳态计算顺序：

1. 设定长期增长、通胀、份额和国外趋势变量。
2. 计算稳态利率和相对价格对象（`r`、`iF`、`Theta_ss`、`Zr`、`Prh`、`Prf`、`RER`、`Pri`）。
3. 求解生产比率（`Kh_Lh`、`Oh_Lh`、`Yh_Lh`、`Y_Lh`、`Yh_Y`）和需求份额（`I_Y`、`C_Y`、`M_Y`、`X_Y`）。
4. 计算政府、税收、公共债务和外部余额比率。
5. 使用对数线性形式，因此在 Dynare `model(linear)` 表示中各偏离变量的确定性稳态为零。

`needs_review`：稳态代数由校准部分和 `.mod` 交叉检查支持，但尚未独立重建完整的论文侧稳态推导。

## 7. Timing & Form Conventions

- 本档案条目将 CL_MS07 视为对数线性化模型。带帽变量表示相对于稳态或平衡增长路径的偏离。
- 实现交叉检查确认 `model(linear)`。
- 复制方程中的资本在生产中是预定变量：生产和边际成本方程使用 `k_hat(-1)` 或 $`k_{t-1}`$；论文的非线性写法由 $`K_t`$ 和 $`I_t`$ 得到 $`K_{t+1}`$。
- 永久生产率过程产生随机趋势。数量变量以人均项表示，并在附录方程前去趋势。
- 政策工具跨时期变化：1987-1999 使用带实际汇率反应的实际利率规则；2000-2005 使用不含直接实际汇率反应的名义利率规则。
- 未打开原始 PDF；公式质量仅基于 MinerU Markdown 和实现交叉检查。
- 运行时验证：未执行。没有运行 Dynare。

## 8. Variable & Parameter Reference Table

| 类别 | 符号或 ASCII 名称 | 含义 | 主要方程 |
|---|---|---|---|
| 内生 | `c_hat`, $`\hat c_t`$ | 总消费 | (F3) |
| 内生 | `cR`, $`\hat c_t^R`$ | Ricardian 消费 | (F1) |
| 内生 | `cNR`, $`\hat c_t^{NR}`$ | 非 Ricardian 消费 | (F2) |
| 内生 | `bF_hat`, $`\hat{\mathbf b}_t^{\ast}`$ | 净外国资产 | (F4), (F38) |
| 内生 | `i_hat`, $`\hat i_t`$ | 名义利率 | (F4), (F28), (F34) |
| 内生 | `r_hat`, $`\hat r_t`$ | 实际利率 | (F27), (F34) |
| 内生 | `wr_hat` | 实际工资 | (F5), (F12) |
| 内生 | `l_hat` | 劳动 | (F5), (F12), (F36) |
| 内生 | `k_hat` | 资本 | (F6), (F12), (F36) |
| 内生 | `inv_hat` | 投资 | (F6), (F10), (F37) |
| 内生 | `qr_hat` | 实际资本价格 | (F10), (F11) |
| 内生 | `zr_hat` | 资本租金率 | (F11), (F12), (F14) |
| 内生 | `mcrh_hat` | 国内部门实际边际成本 | (F14)-(F17) |
| 内生 | `pic_hat`, `picz_hat` | CPI 和核心通胀 | (F15)-(F17), (F27), (F28), (F32) |
| 内生 | `rer_hat` | 实际汇率 | (F16), (F17), (F30), (F31), (F33) |
| 内生 | `yh_hat`, `y_hat` | 国内产出和实际 GDP | (F35)-(F37) |
| 内生 | `x_hat`, `m_hat` | 出口和进口 | (F37), (F39) |
| 内生 | `g_hat`, `tau_hat`, `bg_hat` | 财政支出、税收、公共资产 | (F24)-(F26) |
| 外生 | `eps_ah` | 暂时生产率创新 | (F40) |
| 外生 | `eps_st` | 永久生产率创新 | (F40) |
| 外生 | `eps_ys` | 商品生产创新 | (F40) |
| 外生 | `eps_yF` | 国外产出创新 | (F40) |
| 外生 | `eps_iF` | 国外利率创新 | (F40) |
| 外生 | `eps_piF` | 国外通胀创新 | (F40) |
| 外生 | `eps_sh_m` | 货币政策创新 | (F40) |
| 外生 | `eps_sh_w` | 劳动供给创新 | (F40) |
| 外生 | `eps_sh_c` | 偏好创新 | (F40) |
| 外生 | `eps_gex` | 财政支出创新 | (F40) |
| 外生 | `eps_sh_i` | 投资调整创新 | (F40) |
| 外生 | `eps_prfF` | 国外进口价格创新 | (F40) |
| 外生 | `eps_proF` | 油价创新 | (F40) |
| 外生 | `eps_prsF` | 铜价创新 | (F40) |
| 参数 | $`\beta`$, `beta` | 贴现因子 | (F1), 稳态 |
| 参数 | $`\lambda`$, `lambda` | 非 Ricardian 家庭占比 | (F3) |
| 参数 | $`h`$ | 习惯持续性 | (F1), (F5) |
| 参数 | $`\sigma_L`$ | Frisch 弹性倒数 | (F5) |
| 参数 | $`\phi_L,\chi_L`$ | 工资 Calvo 和指数化参数 | (F5) |
| 参数 | $`\gamma_C,\gamma_I,\alpha_C`$ | 最终品 CES 份额 | (F18)-(F23) |
| 参数 | $`\theta_I,\mu_S`$ | 投资替代和调整成本 | (F7)-(F10) |
| 参数 | $`\phi_{H_D},\phi_{H_F},\phi_F`$ | Calvo 价格概率 | (F15)-(F17) |
| 参数 | $`\chi_{H_D},\chi_{H_F},\chi_F`$ | 价格指数化参数 | (F15)-(F17) |
| 参数 | $`\psi_{i,1},\psi_{\pi,1},\psi_{y,1},\psi_{rer,1}`$ | 1987-1999 政策规则系数 | (F27) |
| 参数 | $`\psi_{i,2},\psi_{\pi,2},\psi_{y,2}`$ | 2000-2005 政策规则系数 | (F28) |
| 参数 | $`\rho_\xi,\sigma_\xi`$ | 冲击持续性和创新尺度 | (F40) |
