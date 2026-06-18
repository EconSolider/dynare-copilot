# NK_GM16 - 推导（最优化问题 + 一阶条件）

> 私有档案初稿。未执行运行时验证。状态：`needs_review`，因为本条目依赖 MinerU OCR Markdown，除确认 PDF 路径存在外，尚未逐式对照 PDF 正文。

## 1. Model Overview

- **模型 ID**：`NK_GM16`
- **论文**：Jordi Gali and Tommaso Monacelli (2016), "Understanding the Gains from Wage Flexibility: The Exchange Rate Connection," *American Economic Review*, 106(12), 3829-3868。
- **DOI**：`10.1257/aer.20131658`
- **核心经济体**：小型开放新凯恩斯经济，包含国内价格黏性、名义工资黏性、完全国际金融市场、一价定律、出口需求、基准模型中无资本积累，以及国内需求、技术、工资税、出口和世界利率等外生扰动。
- **MMB 实现交叉核对**：`.agents/skills/dynare-copilot/references/examples/NK_GM16_rep.mod` 实现货币联盟制度，使用 `model(linear)` 且设定 `e = 0`。
- **模型形式**：围绕零通胀对称稳态的对数线性均衡系统。小写变量为相对稳态的对数偏离；gap 变量为相对弹性价格与弹性工资自然配置的偏离。
- **政策制度**：论文讨论严格国内通胀目标制（`\pi_{H,t}=0`）和货币联盟/硬盯住（`e_t=0`）。MMB 复现文件启用货币联盟制度。
- **来源追踪**：源 Markdown `raw/mmb_mineru/runs/nk_gm16__understanding_the_gains_from_wage_flexibility_the_exchange_rate_connecti__f3573fbb/full.md`；原始 PDF `raw/mmb_papers/Understanding the Gains from Wage Flexibility- The Exchange Rate Connection.pdf`；未发现 appendix-normalization 文件。

## 2. Optimization Problems

### 2.1 代表性家庭

家庭选择消费、状态 contingent 资产组合，并为差异化劳动类型进行工资重设决策。时期效用对总消费取对数，并与各职业劳动供给可分：

```math
E_0\sum_{t=0}^{\infty}\beta^t
\left(\log C_t-\frac{1}{1+\varphi}\int_0^1 \mathcal{N}_t(j)^{1+\varphi}dj\right)Z_t.
```

消费由本国产品和进口品组成：

```math
C_t=\Upsilon C_{H,t}^{1-\nu}C_{F,t}^{\nu}.
```

名义预算约束为：

```math
\int_0^1 P_{H,t}(i)C_{H,t}(i)di+P_{F,t}C_{F,t}
+E_t\{Q_{t,t+1}D_{t+1}\}
\le D_t+\int_0^1 W_t(j)\mathcal{N}_t(j)dj-T_t.
```

在工资设定中，若某劳动类型在时期 `t` 可以重设工资，则选择 `\bar W_t`，并面临未来对该劳动类型的需求：

```math
\mathcal{N}_{t+k|t}=\left(\frac{\bar W_t}{W_{t+k}}\right)^{-\epsilon_w}N_{t+k}.
```

### 2.2 国内生产者

国内企业 `i` 使用差异化劳动服务生产：

```math
Y_t(i)=A_tN_t(i)^{1-\alpha},
\qquad
N_t(i)=\left(\int_0^1N_t(i,j)^{\frac{\epsilon_w-1}{\epsilon_w}}dj\right)^{\frac{\epsilon_w}{\epsilon_w-1}}.
```

企业在 CES 劳动聚合约束下最小化劳动成本；当允许重设价格时，选择 `\bar P_{H,t}` 以最大化贴现名义利润，并面临本国产品品种需求：

```math
Y_{t+k|t}=
\left(\frac{\bar P_{H,t}}{P_{H,t+k}}\right)^{-\epsilon_p}
\left(C_{H,t+k}+X_{t+k}\right).
```

### 2.3 外国需求与资产定价模块

完全国际金融市场给出风险共享条件，将国内消费与世界消费、实际汇率和相对偏好冲击相联系。出口需求是外生需求模块，而不是国内优化主体：

```math
X_t=\nu S_tY_t^{\ast}.
```

外国模块给出两个独立冲击：`z_{1,t}^*` 推动世界产出/出口需求，`z_{2,t}^*` 推动世界实际利率。

## 3. First-Order Conditions

下列编号条件表示基准对数线性 MMB 系统及其推导组件。编号在第 3-5 节连续。

- **(F1) 国内品需求**：

```math
C_{H,t}(i)=\left(\frac{P_{H,t}(i)}{P_{H,t}}\right)^{-\epsilon_p}C_{H,t}.
```

- **(F2) 本国产品/进口品配置**：

```math
P_{H,t}C_{H,t}=(1-\nu)P_tC_t,\qquad P_{F,t}C_{F,t}=\nu P_tC_t.
```

- **(F3) 国内欧拉方程**：

```math
1=\beta(1+i_t)E_t\left[
\left(\frac{C_t}{C_{t+1}}\right)
\left(\frac{Z_{t+1}}{Z_t}\right)
\left(\frac{P_t}{P_{t+1}}\right)
\right].
```

- **(F4) 外币债券欧拉方程 / UIP 来源**：

```math
1=\beta(1+i_t^{\ast})E_t\left[
\left(\frac{C_t}{C_{t+1}}\right)
\left(\frac{Z_{t+1}}{Z_t}\right)
\left(\frac{P_t}{P_{t+1}}\right)
\left(\frac{\mathcal{E}_{t+1}}{\mathcal{E}_t}\right)
\right].
```

- **(F5) 对数线性未覆盖利率平价**：

```math
i_t=i_t^{\ast}+E_t\{\Delta e_{t+1}\}.
```

- **(F6) 完全市场风险共享**：

```math
C_t=C_t^{\ast}\mathcal{Q}_t\left(\frac{Z_t}{Z_t^{\ast}}\right).
```

- **(F7) 重设工资最优性条件**：

```math
\sum_{k=0}^{\infty}(\beta\theta_w)^kE_t\left\{
N_{t+k|t}U_{c,t+k}
\left(\frac{\bar W_t}{P_{t+k}}-\mathcal{M}^w MRS_{t+k|t}\right)
\right\}=0.
```

- **(F8) 对数重设工资方程**：

```math
\bar w_t=\mu^w+(1-\beta\theta_w)\sum_{k=0}^{\infty}(\beta\theta_w)^k
E_t\{mrs_{t+k|t}+p_{t+k}\}.
```

- **(F9) 平均工资指数**：

```math
w_t=\theta_ww_{t-1}+(1-\theta_w)\bar w_t.
```

- **(F10) 以加成为形式的工资 Phillips 曲线**：

```math
\pi_t^w=\beta E_t\{\pi_{t+1}^w\}-\lambda_w(\mu_t^w-\mu^w).
```

- **(F11) 按类型劳动需求**：

```math
\mathcal{N}_t(j)=\left(\frac{W_t(j)}{W_t}\right)^{-\epsilon_w}N_t.
```

- **(F12) 重设价格最优性条件**：

```math
\sum_{k=0}^{\infty}\theta_p^kE_t\left\{
Q_{t,t+k}Y_{t+k|t}
\left(\bar P_{H,t}-\mathcal{M}^p\Psi_{t+k|t}\right)
\right\}=0.
```

- **(F13) 对数重设价格方程**：

```math
\bar p_{H,t}=\mu^p+(1-\beta\theta_p)\sum_{k=0}^{\infty}(\beta\theta_p)^k
E_t\{\psi_{t+k|t}\}.
```

- **(F14) 平均国内价格指数**：

```math
p_{H,t}=\theta_pp_{H,t-1}+(1-\theta_p)\bar p_{H,t}.
```

- **(F15) 以加成为形式的国内价格 Phillips 曲线**：

```math
\pi_{H,t}^p=\beta E_t\{\pi_{H,t+1}^p\}-\lambda_p(\mu_t^p-\mu^p).
```

## 4. Market Clearing & Identities

- **(F16) 国内商品市场出清，对数线性形式**：

```math
y_t=(1-\nu)c_t+\nu(2-\nu)s_t+\nu z_{1,t}^{\ast}.
```

- **(F17) MMB 系统使用的风险共享需求关系**：

```math
c_t=(1-\nu)s_t+z_t-z_{2,t}^{\ast}.
```

- **(F18) 消费欧拉方程，对数线性形式**：

```math
c_t=E_t\{c_{t+1}\}-\left(i_t-E_t\{\pi_{t+1}\}\right)+(1-\rho_z)z_t.
```

- **(F19) 贸易条件定义**：

```math
s_t\equiv e_t-p_{H,t}.
```

- **(F20) 生产/就业关系**：

```math
n_t=\frac{1}{1-\alpha}(y_t-a_t).
```

- **(F21) 以 gap 表示的国内价格 Phillips 曲线**：

```math
\pi_{H,t}^p=\beta E_t\{\pi_{H,t+1}^p\}
+\frac{\lambda_p\alpha}{1-\alpha}\tilde y_t
+\lambda_p\tilde\omega_t+\lambda_p\nu\tilde s_t+\lambda_p\tau_t.
```

- **(F22) 国内价格通胀定义**：

```math
\pi_{H,t}^p\equiv p_{H,t}-p_{H,t-1}.
```

- **(F23) CPI 价格水平**：

```math
p_t=p_{H,t}+\nu s_t.
```

- **(F24) CPI 通胀定义**：

```math
\pi_t^p\equiv p_t-p_{t-1}.
```

- **(F25) 以 gap 表示的工资 Phillips 曲线**：

```math
\pi_t^w=\beta E_t\{\pi_{t+1}^w\}
+\frac{\lambda_w\varphi}{1-\alpha}\tilde y_t
+\lambda_w\tilde c_t-\lambda_w\tilde\omega_t.
```

- **(F26) 工资通胀定义**：

```math
\pi_t^w\equiv w_t-w_{t-1}.
```

- **(F27) 实际消费工资**：

```math
\omega_t\equiv w_t-p_t.
```

- **(F28) 产出 gap**：

```math
\tilde y_t=y_t-y_t^n.
```

- **(F29) 消费 gap**：

```math
\tilde c_t=c_t-c_t^n.
```

- **(F30) 贸易条件 gap**：

```math
\tilde s_t=s_t-s_t^n.
```

- **(F31) 实际工资 gap**：

```math
\tilde\omega_t=\omega_t-\omega_t^n.
```

- **(F32) MMB 复现使用的政策制度：货币联盟 / 硬盯住**：

```math
e_t=0.
```

- **(F33) 论文讨论的替代严格国内通胀目标制度**：

```math
\pi_{H,t}=0.
```

## 5. Exogenous Processes

- **(F34) 国内需求/偏好冲击**：

```math
z_t=\rho_zz_{t-1}+\varepsilon_t^z.
```

- **(F35) 国内技术冲击**：

```math
a_t=\rho_aa_{t-1}+\varepsilon_t^a.
```

- **(F36) 外国出口需求冲击**：

```math
z_{1,t}^{\ast}=\rho_1^{\ast}z_{1,t-1}^{\ast}+\varepsilon_{1,t}^{\ast}.
```

- **(F37) 外国世界利率冲击**：

```math
z_{2,t}^{\ast}=\rho_2^{\ast}z_{2,t-1}^{\ast}+\varepsilon_{2,t}^{\ast}.
```

- **(F38) 工资税冲击，MMB 中按 IRF 方向选择符号**：

```math
\tau_t=\rho_\tau\tau_{t-1}-\varepsilon_t^\tau.
```

- **(F39) 出口冲击对应的世界产出关系**：

```math
Y_t^{\ast}=Z_{1,t}^{\ast}.
```

- **(F40) 世界利率关系**：

```math
i_t^{\ast}=\rho+(1-\rho_2^{\ast})z_{2,t}^{\ast}.
```

## 6. Steady-State Solution

MMB 模型围绕零通胀对称稳态线性化。所有对数偏离内生变量和外生冲击在确定性稳态中为零：

```math
y=c=s=z=z_1^{\ast}=z_2^{\ast}=i=\pi=p=n=a=\tau=\omega=\pi^w=e=0.
```

源论文采用对称稳态：

```math
S=1,\qquad C=C^{\ast}=Y^{\ast},\qquad X=\nu Y^{\ast},\qquad C_F=\nu C,\qquad Y=C.
```

忽略常数时，自然就业为：

```math
n_t^n=\frac{\nu}{1+\varphi}(z_{1,t}^{\ast}+z_{2,t}^{\ast}-z_t)-\frac{1}{1+\varphi}\tau_t.
```

用于定义 gap 的自然配置为：

```math
y_t^n=a_t+(1-\alpha)n_t^n,
```

```math
s_t^n=a_t-z_t+z_{2,t}^{\ast}-\tau_t-(\alpha+\varphi)n_t^n,
```

```math
c_t^n=z_t+(1-\nu)s_t^n-z_{2,t}^{\ast},
```

```math
\omega_t^n=a_t-\alpha n_t^n-\tau_t-\nu s_t^n.
```

完整源附录在自然配置中包含与目标加成相关的常数。MMB 实现与对数偏离 `model(linear)` 表示一致地省略这些常数。

## 7. Timing & Form Conventions

- **时序**：基准 MMB 条目中没有资本存量。通胀、工资通胀、汇率变化和价格水平均使用一期滞后定义。
- **预期**：欧拉方程和 Phillips 曲线项使用时期 `t` 对时期 `t+1` 变量的 `E_t`；MMB 文件中写作 `(+1)`。
- **开放经济价格**：贸易条件为 `s_t=e_t-p_{H,t}`，CPI 在对数线性形式下为 `p_t=p_{H,t}+\nu s_t`。
- **政策制度**：`NK_GM16_rep.mod` 设定 `e=0`，即货币联盟/硬盯住情形。论文还研究 `\pi_{H,t}=0` 的国内通胀目标制度。
- **形式**：`model(linear)`，变量为相对稳态的对数偏离。本档案条目未执行运行时验证。
- **OCR 状态**：MinerU Markdown 对基准模型和附录总体可读，但附录中围绕常数和边际成本的部分文字存在噪声。上列方程根据清晰的正文系统和附录条件规范化；条目仍为 `needs_review`。

## 8. Variable & Parameter Reference Table

| 类别 | 符号 / ASCII | 含义 | 主要方程 |
|---|---|---|---|
| 内生变量 | `y`, $`y_t`$ | 产出 | (F16), (F28) |
| 内生变量 | `c`, $`c_t`$ | 消费 | (F17), (F18), (F29) |
| 内生变量 | `s`, $`s_t`$ | 贸易条件 | (F19), (F30) |
| 内生变量 | `i`, $`i_t`$ | 名义利率 | (F18), (F32), (F40) |
| 内生变量 | `dpc`, $`\pi_t^p`$ | CPI 通胀 | (F24) |
| 内生变量 | `e`, $`e_t`$ | 名义汇率 | (F19), (F32) |
| 内生变量 | `p`, $`p_{H,t}`$ in MMB code | 国内价格水平 | (F19), (F22) |
| 内生变量 | `pc`, $`p_t`$ | CPI 价格水平 | (F23), (F24) |
| 内生变量 | `n`, $`n_t`$ | 就业 | (F20) |
| 内生变量 | `a`, $`a_t`$ | 技术状态 | (F35) |
| 内生变量 | `dp`, $`\pi_{H,t}^p`$ | 国内价格通胀 | (F21), (F22) |
| 内生变量 | `t`, $`\tau_t`$ | 工资税状态 | (F38) |
| 内生变量 | `wp`, $`\omega_t`$ | 实际消费工资 | (F27), (F31) |
| 内生变量 | `dw`, $`\pi_t^w`$ | 工资通胀 | (F25), (F26) |
| 内生变量 | `w`, $`w_t`$ | 名义工资 | (F26), (F27) |
| 内生变量 | `r` | 代码中的事前实际利率 | (F18), implementation identity |
| 内生变量 | `de` | 汇率变化 | price/exchange-rate identity |
| 内生变量 | `ygap`, `cgap`, `sgap`, `wgap`, `ngap` | 相对自然配置的 gap | (F28)-(F31) |
| 内生变量 | `yn`, `cn`, `sn`, `nn`, `wpn` | 自然值 | 稳态/自然配置模块 |
| 内生变量 | `z`, $`z_t`$ | 国内偏好状态 | (F34) |
| 内生变量 | `zx1`, $`z_{1,t}^{\ast}`$ | 出口需求状态 | (F36), (F39) |
| 内生变量 | `zx2`, $`z_{2,t}^{\ast}`$ | 世界利率状态 | (F37), (F40) |
| 外生变量 | `ez`, `ea`, `ezx1`, `ezx2`, `et` | 偏好、技术、出口、世界利率和税收过程创新 | (F34)-(F38) |
| 参数 | `bet`, $`\beta`$ | 贴现因子 | (F3), (F10), (F15), (F25) |
| 参数 | `phi`, $`\varphi`$ | 劳动负效用曲率 | (F25), natural allocation |
| 参数 | `epsp`, $`\epsilon_p`$ | 商品替代弹性 | (F1), (F12)-(F15) |
| 参数 | `epsw`, $`\epsilon_w`$ | 劳动替代弹性 | (F7)-(F11) |
| 参数 | `alf`, $`\alpha`$ | 劳动生产中的递减收益参数 | (F20), (F21), natural allocation |
| 参数 | `thep`, $`\theta_p`$ | Calvo 价格黏性 | (F12)-(F15) |
| 参数 | `thew`, $`\theta_w`$ | Calvo 工资黏性 | (F7)-(F10), (F25) |
| 参数 | `nu`, $`\nu`$ | 开放度 | (F16), (F17), (F21), (F23), natural allocation |
| 参数 | `lamp`, $`\lambda_p`$ | 价格 Phillips 曲线斜率 | (F15), (F21) |
| 参数 | `lamw`, $`\lambda_w`$ | 工资 Phillips 曲线斜率 | (F10), (F25) |
| 参数 | `rhoa`, `rhoz`, `rhot`, `rhozx1`, `rhozx2` | 冲击持续性参数 | (F34)-(F38) |

实现交叉核对说明：MMB `.mod` 还定义图表缩放变量 `ngraph`, `igraph`, `rgraph`, `sgraph`，它们是报告转换，不是独立模型方程。
