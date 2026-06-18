# CA_ToTEM10 - 推导

> 私有模型档案的一稿。未进行运行时验证。公式级状态：`needs_review`，因为 MinerU Markdown 来源是模型概览文章，而不是包含完整均衡方程的正式附录。

## 1. Model Overview

- **模型 ID**：`CA_ToTEM10`。
- **论文侧来源**：Murchison and Rennison (2006), "ToTEM: The Bank of Canada's New Canadian Projection Model," Bank of Canada Technical Report。
- **来源路径**：`raw/mmb_mineru/runs/ca_totem10__totem_the_bank_of_canada_s_new_canadian_projection_model__1f1558b7/full.md`；原始 PDF 记录为 `raw/mmb_papers/ToTEM- The Bank of Canada's New Canadian Projection Model.pdf`。
- **来源 DOI**：`raw/mmb_mineru/model_index.csv` 未列出。
- **模型类别**：加拿大开放经济 DSGE 预测和政策分析模型。
- **主体与机构**：家庭、企业、中央银行、财政当局。论文描述家庭、企业和中央银行是优化主体；财政政策按规则刻画。
- **商品与部门**：四个最终产品部门（消费、投资、政府、出口）以及一个商品生产部门。最终产品企业使用资本服务、劳动、商品和进口品。
- **名义刚性**：交错的粘性价格和交错的粘性工资。进口价格也具有粘性，因此形成供应链价格交错和渐进的汇率传递。
- **形式**：MMB 复制文件中的大规模对数线性化 / 线性化 DSGE 实现；论文叙述称 ToTEM 使用线性化和现代求解技术。精确论文侧代数为 `needs_review`。
- **论文重点冲击**：消费/偏好冲击、国家风险溢价或汇率冲击、世界商品价格冲击。实现交叉检查列出七个外生冲击：`lyrow_shk`、`lpcomrow_shk`、`lxdc_shk`、`lforexn_shk`、`lc_shk`、`la_shk`、`gn_yn_shk`。

## 2. Optimization Problems

### 生命周期收入家庭

生命周期收入家庭在跨期预算约束下平滑消费，获得企业利润，供给差异化劳动服务，并可借入或储蓄。一个与来源一致的紧凑表示为：

\[
\max_{\{C^L_t,N^L_t,A^L_t\}} E_0\sum_{t=0}^{\infty}\beta^t
U(C^L_t-h C^L_{t-1},N^L_t)
\]

约束为

\[
P^c_t C^L_t + A^L_t
= W_t N^L_t + R_{t-1}A^L_{t-1}+\Pi_t-T^L_t .
\]

`needs_review`：论文来源识别了生命周期收入家庭及其跨期预算约束，但没有打印精确效用函数或资产定价方程。

### 当期收入家庭

当期收入家庭不能储蓄或借款，消费等于包括转移在内的当期可支配收入：

\[
P^c_t C^C_t = W_t N^C_t + TR_t - T^C_t .
\]

`needs_review`：Markdown 来源没有打印精确税收/转移分解。

### 工资设定者

由于劳动技能不可完全替代，家庭在劳动供给上具有市场势力。名义工资合约交错，并且平均约持续六个季度：

\[
\max_{W^{\ast}_t} E_t\sum_{j=0}^{\infty}(\beta \theta_w)^j
\Lambda_{t,t+j}\left[
W^{\ast}_t N_{t+j|t}-P^c_{t+j} MRS^N_{t+j}N_{t+j|t}
\right] .
\]

`needs_review`：这是与论文描述一致的一般 Calvo 工资设定表示；论文侧 Markdown 没有打印精确 ToTEM 工资模块。

### 最终产品企业

每个最终产品部门 `s in {c, inv, g, x}` 用 CES 生产技术组合资本服务、劳动、商品和进口品，并设置粘性价格：

\[
\max_{\{K_{s,t},L_{s,t},COM_{s,t},M_{s,t}\}}
P^s_t Y^s_t-W_tL_{s,t}-R^k_tK_{s,t}-P^{com}_tCOM_{s,t}-P^m_tM_{s,t}
\]

约束为

\[
Y^s_t = A^s_t\,F_s(K_{s,t},L_{s,t},COM_{s,t},M_{s,t};u_{s,t}) .
\]

`needs_review`：Markdown 来源说明生产函数是 CES，当前 ToTEM 版本中最终产品主要通过相对进口含量区分，但没有打印嵌套 CES 公式。

### 商品生产企业

商品部门独立于最终产品部门，是世界商品市场的价格接受者，并为国内使用、家庭消费和出口供给商品：

\[
\max_{\{K^{com}_t,L^{com}_t\}}
P^{com}_tY^{com}_t-W_tL^{com}_t-R^k_tK^{com}_t
\]

约束为

\[
Y^{com}_t=A^{com}_tF^{com}(K^{com}_t,L^{com}_t).
\]

### 中央银行和财政当局

中央银行被描述为选择政策以最小化通胀偏离目标、产出偏离潜在水平以及利率波动。就 MMB 实现而言，这表现为优化后的利率反馈规则，而不是显式 Ramsey 问题。

财政当局遵循支出、税收、转移和债务规则，并与中期债务/GDP 目标一致。

## 3. First-Order Conditions

以下方程是一稿结构图。论文侧 Markdown 未打印精确代数的条件均明确标为 `needs_review`。

- **(F1) 生命周期收入家庭欧拉条件**（`needs_review`）：

\[
U_{C,t}=\beta E_t\left[U_{C,t+1}\frac{1+i_t}{\Pi^c_{t+1}}\right].
\]

- **(F2) 当期收入家庭预算规则**（`needs_review`）：

\[
C^C_t=\frac{W_tN^C_t+TR_t-T^C_t}{P^c_t}.
\]

- **(F3) 劳动供给 / 期望实际工资条件**（`needs_review`）：

\[
\frac{W^{des}_t}{P^c_t}=MRS^N_t(C_t,N_t).
\]

- **(F4) Calvo 工资 Phillips 曲线模块**（`needs_review`）：

\[
\pi^w_t=\gamma_w\pi^w_{t-1}+\beta E_t\pi^w_{t+1}
\kappa_w\left(\log W_t-\log P^c_t-\log MRS^N_t\right).
\]

- **(F5) 最终品投入需求，资本服务**（`needs_review`）：

\[
R^k_t=P^s_t MC^s_t\frac{\partial F_s}{\partial K_{s,t}}.
\]

- **(F6) 最终品投入需求，劳动**（`needs_review`）：

\[
W_t=P^s_t MC^s_t\frac{\partial F_s}{\partial L_{s,t}}.
\]

- **(F7) 最终品投入需求，商品**（`needs_review`）：

\[
P^{com}_t=P^s_t MC^s_t\frac{\partial F_s}{\partial COM_{s,t}}.
\]

- **(F8) 最终品投入需求，进口品**（`needs_review`）：

\[
P^m_t=P^s_t MC^s_t\frac{\partial F_s}{\partial M_{s,t}}.
\]

- **(F9) 部门新凯恩斯价格方程**（`needs_review`）：

\[
\pi^s_t=\gamma_s\pi^s_{t-1}+\beta E_t\pi^s_{t+1}
\kappa_s\left(\log MC^s_t-\log \overline{MC}^s\right)+\varepsilon^s_t .
\]

- **(F10) 进口价格 Phillips 曲线 / 供应链传递模块**（`needs_review`）：

\[
\pi^m_t=\gamma_m\pi^m_{t-1}+\beta E_t\pi^m_{t+1}
\kappa_m\left(\log P^{row}_t+\log S_t-\log P^m_t\right).
\]

- **(F11) 资本积累与利用成本**（`needs_review`）：

\[
K_{t+1}=(1-\delta(u_t))K_t+I_t-\Phi_I(I_t,I_{t-1}).
\]

- **(F12) Tobin's Q / 投资条件**（`needs_review`）：

\[
Q_t=1+\Phi_{I,t}+\beta E_t\left[\Lambda_{t,t+1}Q_{t+1}\Phi_{I,t+1}\right].
\]

- **(F13) 资本服务利用条件**（`needs_review`）：

\[
R^k_t=\frac{\partial \delta(u_t)}{\partial u_t}Q_t .
\]

- **(F14) 商品部门投入需求**（`needs_review`）：

\[
W_t=P^{com}_t\frac{\partial F^{com}}{\partial L^{com}_t},\qquad
R^k_t=P^{com}_t\frac{\partial F^{com}}{\partial K^{com}_t}.
\]

- **(F15) 货币政策反馈规则**（`needs_review`；实现交叉检查）：

\[
i_t=\rho_i i_{t-1}+(1-\rho_i)\left(\bar{i}
\phi_{\pi}(\pi^{cpi}_{t+h}-\pi^{target}_{t+h})
\phi_y y^{gap}_t\right)+\varepsilon^i_t .
\]

实现交叉检查将其映射到针对 `infq2`、`pertarget`、`pertran` 和 `ly_gap` 反应的平滑 `r1n` 规则。

## 4. Market Clearing & Identities

- **(F16) 最终品资源恒等式**（`needs_review`）：

\[
Y^c_t=C_t,\qquad Y^{inv}_t=I_t,\qquad Y^g_t=G_t,\qquad Y^x_t=X_t .
\]

- **(F17) 总 GDP 恒等式**（`needs_review`）：

\[
Y_t=C_t+I_t+G_t+X_t-M_t+Y^{com,value}_t .
\]

- **(F18) 商品配置**（`needs_review`）：

\[
Y^{com}_t=COM^c_t+COM^{inv}_t+COM^g_t+COM^x_t+COM^{hh}_t+X^{com}_t .
\]

- **(F19) 净外国资产积累**（`needs_review`；实现交叉检查）：

\[
NFA_t=\frac{1+i^{row}_{t-1}+\rho^{risk}_{t-1}}{\Pi_t}\frac{S_t}{S_{t-1}}NFA_{t-1}
NX_t .
\]

实现交叉检查中有显式 `nfa` 运动方程和与期望 NFA 偏离相关的风险溢价项。

- **(F20) 风险溢价 / 汇率关系**（`needs_review`；实现交叉检查）：

\[
1+i_t=(1+i^{row}_t)(1+risk_t)E_t\left[\frac{S_{t+1}}{S_t}\frac{\Pi^{row}_{t+1}}{\Pi_{t+1}}\right].
\]

- **(F21) 财政债务积累**（`needs_review`；实现交叉检查）：

\[
B^g_t=(1+i^g_{t-1})B^g_{t-1}+P^g_tG_t+TR_t-T_t .
\]

- **(F22) 财政规则模块**（`needs_review`；实现交叉检查）：

\[
G_t,TR_t,T_t=f(B^g_t/Y_t,\overline{B^g/Y},Y^{gap}_t,\varepsilon^g_t).
\]

- **(F23) 价格指数定义**（`needs_review`）：

\[
\Pi^{cpi}_t=g(\Pi^c_t,\Pi^m_t,\Pi^{com}_t,\Pi^g_t,\Pi^{inv}_t,\Pi^x_t).
\]

## 5. Exogenous Processes

- **(F24) 国内技术过程**（`needs_review`；实现交叉检查 `la_shk`）：

\[
a_t=a_{t-1}+\bar{g}_a+\varepsilon^a_t .
\]

- **(F25) 世界商品价格过程**（`needs_review`；实现交叉检查 `lpcomrow_shk`）：

\[
\log P^{com,row}_t-\log \bar{P}^{com,row}
=\rho_{com}\left(\log P^{com,row}_{t-1}-\log \bar{P}^{com,row}\right)
\varepsilon^{com}_t .
\]

- **(F26) 外国总产出模块**（`needs_review`；实现交叉检查 `lyrow_shk`）：

\[
y^{row}_t=y^{row,sreq}_t+y^{row,gap}_t .
\]

- **(F27) 汇率 / 国家风险冲击模块**（`needs_review`；实现交叉检查 `lforexn_shk`、`risk_shk`）：

\[
risk_t=\overline{risk}+\tau\left(e^{-(NFA_t-\overline{NFA})}-1\right)+\varepsilon^{risk}_t .
\]

- **(F28) 消费需求冲击**（`needs_review`；实现交叉检查 `lc_shk`）：

\[
\xi^c_t=\rho_c\xi^c_{t-1}+\varepsilon^c_t .
\]

- **(F29) 财政支出比率冲击**（`needs_review`；实现交叉检查 `gn_yn_shk`）：

\[
gny_t=\rho_g gny_{t-1}+\varepsilon^g_t .
\]

- **(F30) 直接 CPI 价格冲击**（`needs_review`；实现交叉检查 `lxdc_shk`）：

\[
\varepsilon^{pc}_t=\rho_{pc}\varepsilon^{pc}_{t-1}+\eta^{pc}_t .
\]

## 6. Steady-State Solution

来源 Markdown 说明许多参数被选择为使稳态复制 1980-2004 年加拿大数据均值。它没有提供完整稳态系统。因此一稿稳态状态为 `needs_review`。

后续已检查实现建议采用的稳态顺序：

1. 设定通胀目标、国外趋势增长和平衡增长率。
2. 设定最终品和进口定价的稳态加成。
3. 解部门 CES 单位成本方程，得到相对价格和边际成本。
4. 解各部门劳动、资本服务、商品和进口投入份额。
5. 解资本存量、利用率、折旧、投资和 Tobin's Q。
6. 解各类型家庭消费、工资设定稳态、转移、税收和政府支出份额。
7. 解净出口、NFA、国家风险溢价和汇率归一化外国资产项。
8. 解货币政策稳态：90 天名义利率、实际利率、目标通胀和零产出缺口。

与实现交叉检查一致的稳态占位式：

\[
\pi^{target}=\bar{\pi},\qquad y^{gap}=0,\qquad i=\bar{i},\qquad risk=\overline{risk}.
\]

未运行 Dynare 稳态残差检查。

## 7. Timing & Form Conventions

- **形式**：一稿档案将 `CA_ToTEM10` 归类为线性化 / 对数线性化。MMB 实现使用许多对数水平变量和大型 `model` 块；论文称 ToTEM 使用线性化和新的求解技术。
- **资本时序**：实现交叉检查在部门资本估值和投资方程中使用滞后和前瞻资本存量项。在公式级审查确认精确时序之前，将资本视作由过去积累预定的存量。
- **NFA 时序**：净外国资产是存量变量，滞后 NFA 进入积累恒等式，风险溢价与期望 NFA 偏离相关。
- **通胀时序**：部门通胀方程具有前瞻项和滞后指数化/动态项；进口和部门价格形成交错传递。
- **政策时序**：政策规则对前瞻通胀指标（实现交叉检查中的 `infq2`）和当期产出缺口反应，并具有利率平滑。
- **运行时验证**：未执行。

## 8. Variable & Parameter Reference Table

### 内生变量和模块

| 类别 | 符号 / ASCII 线索 | 含义 | 主要方程 |
|---|---|---|---|
| 内生 | `C^L`, `lcfl` | 生命周期收入消费 | (F1) |
| 内生 | `C^C`, `lc` components | 当期收入消费 | (F2) |
| 内生 | `W`, `lwn_r`, `w_inf` | 名义/实际工资和工资通胀 | (F3), (F4) |
| 内生 | `Y^s`, `ly`, sector outputs | 最终产品产出 | (F5)-(F9), (F16), (F17) |
| 内生 | `MC^s`, `lmc*_r` | 部门边际成本 | (F5)-(F10) |
| 内生 | `K_s`, `lk*` | 部门资本存量 | (F11)-(F14) |
| 内生 | `I`, `linv*` | 投资和部门投资 | (F11), (F12), (F17) |
| 内生 | `u_s`, `u*` | 利用率 | (F13) |
| 内生 | `P^m`, `lpm*_r` | 进口价格 | (F10), (F23) |
| 内生 | `Y^{com}`, `lcom*` | 商品产出和使用 | (F14), (F18) |
| 内生 | `i`, `r1n` | 90 天名义利率 | (F15), (F20) |
| 内生 | `S`, `lforex` | 名义/实际汇率模块 | (F20), (F27) |
| 内生 | `NFA`, `nfa` | 净外国资产 | (F19), (F27) |
| 内生 | `B^g`, `gbn_yn` | 政府债务比率 | (F21), (F22) |
| 内生 | `G`, `lg`, `gn_yn` | 政府支出 | (F22), (F29) |
| 内生 | `pi`, `infq`, `inff` | CPI/核心通胀指标 | (F9), (F10), (F23), (F30) |

### 外生冲击

| 符号 / ASCII 线索 | 含义 | 主要方程 |
|---|---|---|
| `la_shk` | 国内生产率冲击 | (F24) |
| `lpcomrow_shk` | 世界商品价格冲击 | (F25) |
| `lyrow_shk` | 世界其他地区产出冲击 | (F26) |
| `lforexn_shk`, `risk_shk` | 国家风险 / 汇率冲击模块 | (F27) |
| `lc_shk` | 消费需求冲击 | (F28) |
| `gn_yn_shk` | 财政支出比率冲击 | (F29) |
| `lxdc_shk` | 直接 CPI 价格冲击 | (F30) |

### 参数和校准线索

| 参数线索 | 含义 |
|---|---|
| `beta` | 贴现因子 |
| `habit`, `habitrow` | 国内/国外需求模块中的习惯持久性 |
| `calvo_*` | 各价格/工资模块的 Calvo 粘性参数 |
| `dyn_*` | 指数化/动态通胀参数 |
| `smooth1` | 利率平滑 |
| `b`, `bqy` | 货币政策对通胀和产出缺口的反应 |
| `alpha_*` | 生产/投入份额或 CES 权重参数 |
| `sigma`, `sigma_com`, `theta`, `theta_com` | 替代/曲率参数 |
| `chi`, `chi_k`, `psi*` | 调整/利用率/投资成本参数 |
| `tau`, `tau2` | NFA/风险溢价敏感性 |
| `fiscal1`-`fiscal4` | 财政规则系数 |

本稿方程数：30 个编号条件。由于许多条件是结构模块方程而不是完整 MMB 实现方程列表，方程-变量数量相等检查为 `needs_review`。
