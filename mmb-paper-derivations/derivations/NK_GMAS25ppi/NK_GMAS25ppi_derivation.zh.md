# NK_GMAS25ppi -- 推导（最优化问题 + 均衡条件）

> 状态：`needs_review`。这个一稿归档条目来自 Gali and Monacelli (2005) 的 MinerU Markdown。论文先给出非线性的家庭和厂商原始问题，再使用小型开放经济新凯恩斯模型的对数线性系统。这里将 `NK_GMAS25ppi` 处理为生产者价格/国内通胀 Taylor 规则版本。未进行运行时验证。

来源：Jordi Gali and Tommaso Monacelli (2005), "Monetary policy and exchange rate volatility in a small open economy," *Review of Economic Studies* 72, 707-734. DOI: `10.1111/j.1467-937x.2005.00349.x`。

## 1. Model Overview

- **模型**：`NK_GMAS25ppi`，一个小型开放经济 Calvo 黏性价格模型，包含完全国际金融市场，利率规则对生产者价格/国内通胀作出反应。
- **主体**：代表性家庭、垄断竞争的国内厂商、一个由本国视为外生的外国经济连续统，以及货币当局。
- **商品结构**：国内消费品和进口消费品都是 CES 聚合。开放度由 $\alpha$ 表示；$\eta$ 控制本国与外国商品束之间的替代；$\gamma$ 控制不同外国来源之间的替代；$\epsilon$ 控制品种之间的替代。
- **政策版本**：本归档条目对应 PPI/国内通胀 Taylor 规则 $r_t=\rho+\phi_\pi\pi_{H,t}$，不是 CPI 规则或汇率钉住版本。
- **形式**：围绕对称零通胀稳态和 PPP 的对数线性 `model(linear)` 均衡。小写变量表示对数或对数偏离；带帽边际成本是相对稳态加价水平的偏离。
- **运行时验证**：未执行。没有运行 Dynare 残差、稳态、BK 或 IRF 检查。

## 2. Optimization Problems

### 2.1 家庭

本国代表性家庭最大化：

$$
E_0\sum_{t=0}^{\infty}\beta^t U(C_t,N_t),
\qquad
U(C_t,N_t)=\frac{C_t^{1-\sigma}}{1-\sigma}-\frac{N_t^{1+\varphi}}{1+\varphi}.
$$

综合消费品束为：

$$
C_t=\left[(1-\alpha)^{1/\eta}C_{H,t}^{(\eta-1)/\eta}
+\alpha^{1/\eta}C_{F,t}^{(\eta-1)/\eta}\right]^{\eta/(\eta-1)}.
$$

国内品种和进口品种束是 CES 聚合：

$$
C_{H,t}=\left(\int_0^1 C_{H,t}(j)^{(\epsilon-1)/\epsilon}dj\right)^{\epsilon/(\epsilon-1)},
\qquad
C_{i,t}=\left(\int_0^1 C_{i,t}(j)^{(\epsilon-1)/\epsilon}dj\right)^{\epsilon/(\epsilon-1)}.
$$

进口消费在国家之间聚合为：

$$
C_{F,t}=\left(\int_0^1 C_{i,t}^{(\gamma-1)/\gamma}di\right)^{\gamma/(\gamma-1)}.
$$

支出聚合后的名义预算约束为：

$$
P_tC_t+E_t\{Q_{t,t+1}D_{t+1}\}\leq D_t+W_tN_t+T_t.
$$

### 2.2 支出最小化

在国内和外国品种束内部的成本最小化给出：

$$
C_{H,t}(j)=\left(\frac{P_{H,t}(j)}{P_{H,t}}\right)^{-\epsilon}C_{H,t},
\qquad
C_{i,t}(j)=\left(\frac{P_{i,t}(j)}{P_{i,t}}\right)^{-\epsilon}C_{i,t}.
$$

在外国来源之间以及本国/外国商品束之间的配置给出：

$$
C_{i,t}=\left(\frac{P_{i,t}}{P_{F,t}}\right)^{-\gamma}C_{F,t},
$$

$$
C_{H,t}=(1-\alpha)\left(\frac{P_{H,t}}{P_t}\right)^{-\eta}C_t,
\qquad
C_{F,t}=\alpha\left(\frac{P_{F,t}}{P_t}\right)^{-\eta}C_t.
$$

CPI 为：

$$
P_t=\left[(1-\alpha)P_{H,t}^{1-\eta}+\alpha P_{F,t}^{1-\eta}\right]^{1/(1-\eta)}.
$$

### 2.3 国内厂商

国内厂商 $j$ 使用线性技术生产：

$$
Y_t(j)=A_tN_t(j),
\qquad
a_t=\rho_a a_{t-1}+\varepsilon_t^a.
$$

名义边际成本为 $MC_t^n=(1-\tau)W_t/A_t$。以国内品计价的实际边际成本为：

$$
mc_t=-\nu+w_t-p_{H,t}-a_t,
\qquad
\nu\equiv-\log(1-\tau).
$$

在 Calvo 定价下，能在 $t$ 期重设价格的厂商选择 $\overline{P}_{H,t}$，最大化该价格有效期间的贴现利润：

$$
\max_{\overline{P}_{H,t}}\sum_{k=0}^{\infty}\theta^k
E_t\left\{Q_{t,t+k}Y_{t+k}\left(\overline{P}_{H,t}-MC_{t+k}^n\right)\right\},
$$

并满足需求序列：

$$
Y_{t+k}(j)\leq
\left(\frac{\overline{P}_{H,t}}{P_{H,t+k}}\right)^{-\epsilon}
\left(C_{H,t+k}+\int_0^1 C_{H,t+k}^i\,di\right).
$$

### 2.4 货币当局

对这个 `NK_GMAS25ppi` 归档条目，简单政策规则是国内通胀/PPI Taylor 规则：

$$
r_t=\rho+\phi_\pi\pi_{H,t}.
$$

论文还分析 CPI 通胀目标和汇率钉住，但这些是不同版本，不作为本条目的闭合规则。

## 3. First-Order Conditions

- **(F1) 家庭劳动的期内条件**：

$$
C_t^{\sigma}N_t^{\varphi}=\frac{W_t}{P_t}.
$$

- **(F2) 名义随机贴现因子**：

$$
\beta\left(\frac{C_{t+1}}{C_t}\right)^{-\sigma}
\left(\frac{P_t}{P_{t+1}}\right)=Q_{t,t+1}.
$$

- **(F3) 家庭 Euler 方程**：

$$
\beta R_tE_t\left[
\left(\frac{C_{t+1}}{C_t}\right)^{-\sigma}
\left(\frac{P_t}{P_{t+1}}\right)
\right]=1.
$$

- **(F4) 对数线性消费 Euler 方程**：

$$
c_t=E_t c_{t+1}-\frac{1}{\sigma}
\left(r_t-E_t\pi_{t+1}-\rho\right).
$$

- **(F5) 完全市场下的国际风险分享**：

$$
C_t=C_t^i\mathcal{Q}_{i,t}^{1/\sigma}
\quad\Rightarrow\quad
c_t=c_t^{\ast}+\frac{1}{\sigma}q_t.
$$

- **(F6) 用有效贸易条件表示的风险分享关系**：

$$
c_t=c_t^{\ast}+\frac{1-\alpha}{\sigma}s_t.
$$

- **(F7) 无抛补利率平价**：

$$
r_t-r_t^{\ast}=E_t\Delta e_{t+1}.
$$

- **(F8) 贸易条件差分方程**：

$$
s_t=(r_t^{\ast}-E_t\pi_{t+1}^{\ast})-(r_t-E_t\pi_{H,t+1})+E_ts_{t+1}.
$$

- **(F9) Calvo 最优重设价格条件，对数线性形式**：

$$
\overline{p}_{H,t}=\mu+(1-\beta\theta)
\sum_{k=0}^{\infty}(\beta\theta)^kE_t\{mc_{t+k}+p_{H,t+k}\},
\qquad
\mu\equiv\log\left(\frac{\epsilon}{\epsilon-1}\right).
$$

- **(F10) 边际成本形式的国内 Phillips 曲线**：

$$
\pi_{H,t}=\beta E_t\pi_{H,t+1}+\lambda\widehat{mc}_t,
\qquad
\lambda=\frac{(1-\beta\theta)(1-\theta)}{\theta}.
$$

- **(F11) 由产出、世界产出和生产率表示的实际边际成本**：

$$
mc_t=-\nu+(\sigma_\alpha+\varphi)y_t
+(\sigma-\sigma_\alpha)y_t^{\ast}-(1+\varphi)a_t.
$$

- **(F12) 国内自然产出**：

$$
\overline{y}_t=\Omega+\Gamma a_t+\alpha\Psi y_t^{\ast},
$$

其中：

$$
\Omega=\frac{\nu-\mu}{\sigma_\alpha+\varphi},
\qquad
\Gamma=\frac{1+\varphi}{\sigma_\alpha+\varphi},
\qquad
\Psi=-\frac{\Theta\sigma_\alpha}{\sigma_\alpha+\varphi}.
$$

- **(F13) 产出缺口定义**：

$$
x_t=y_t-\overline{y}_t.
$$

- **(F14) 边际成本与产出缺口关系**：

$$
\widehat{mc}_t=(\sigma_\alpha+\varphi)x_t.
$$

- **(F15) 小型开放经济 New Keynesian Phillips 曲线**：

$$
\pi_{H,t}=\beta E_t\pi_{H,t+1}+\kappa_\alpha x_t,
\qquad
\kappa_\alpha=\lambda(\sigma_\alpha+\varphi).
$$

- **(F16) 自然实际利率**：

$$
\overline{rr}_t=\rho-\sigma_\alpha\Gamma(1-\rho_a)a_t
+\alpha\sigma_\alpha(\Theta+\Psi)E_t\Delta y_{t+1}^{\ast}.
$$

- **(F17) 产出缺口形式的动态 IS 方程**：

$$
x_t=E_tx_{t+1}
-\frac{1}{\sigma_\alpha}
\left(r_t-E_t\pi_{H,t+1}-\overline{rr}_t\right).
$$

- **(F18) `NK_GMAS25ppi` 的 PPI/国内通胀 Taylor 规则**：

$$
r_t=\rho+\phi_\pi\pi_{H,t}.
$$

## 4. Market Clearing & Identities

- **(F19) 有效贸易条件**：

$$
s_t=p_{F,t}-p_{H,t}.
$$

- **(F20) CPI 与国内价格恒等式**：

$$
p_t=p_{H,t}+\alpha s_t.
$$

- **(F21) CPI 通胀恒等式**：

$$
\pi_t=\pi_{H,t}+\alpha\Delta s_t.
$$

- **(F22) 名义汇率与贸易条件恒等式**：

$$
s_t=e_t+p_t^{\ast}-p_{H,t}.
$$

- **(F23) 实际汇率关系**：

$$
q_t=(1-\alpha)s_t.
$$

- **(F24) 总量生产函数，一阶近似**：

$$
y_t=a_t+n_t.
$$

- **(F25) 商品市场出清/产出需求关系**：

$$
y_t=c_t+\frac{\alpha\omega}{\sigma}s_t.
$$

- **(F26) 世界资源条件**：

$$
y_t^{\ast}=c_t^{\ast}.
$$

- **(F27) 贸易条件与相对产出**：

$$
y_t=y_t^{\ast}+\frac{1}{\sigma_\alpha}s_t,
\qquad
\sigma_\alpha=\frac{\sigma}{(1-\alpha)+\alpha\omega}.
$$

- **(F28) 净出口关系**：

$$
nx_t=\alpha\left(\frac{\omega}{\sigma}-1\right)s_t.
$$

- **(F29) 开放经济辅助参数**：

$$
\omega=\sigma\gamma+(1-\alpha)(\sigma\eta-1),
\qquad
\Theta=\omega-1.
$$

## 5. Exogenous Processes

- **(F30) 国内技术过程**：

$$
a_t=\rho_a a_{t-1}+\varepsilon_t^a.
$$

- **(F31) 校准中使用的世界产出过程**：

$$
y_t^{\ast}=\rho_{y^{\ast}}y_{t-1}^{\ast}+\varepsilon_t^{\ast}.
$$

- **(F32) 校准中使用的创新相关系数**：

$$
\operatorname{corr}(\varepsilon_t^a,\varepsilon_t^{\ast})=0.3.
$$

论文的校准示例使用加拿大生产率和美国 GDP 数据估计出 $\rho_a\approx0.66$ 与 $\rho_{y^{\ast}}\approx0.86$。这些经验值记录为来源背景，不是运行时验证。

## 6. Steady-State Solution

本归档条目是对数线性 `model(linear)` 表示。确定性对称稳态被归一化，使所有对数偏离为零：

$$
a=y^{\ast}=x=\pi_H=\pi=s=e=q=nx=0.
$$

对称稳态满足 PPP 和单位贸易条件：

$$
\mathcal{S}=1,
\qquad
\mathcal{Q}=1,
\qquad
C=C^{\ast}=Y=Y^{\ast}.
$$

国内通胀、CPI 通胀和预期贬值在稳态为零：

$$
\pi_H=\pi=\Delta e=0.
$$

总贴现关系给出以对数项表示的稳态名义/实际利率：

$$
\rho=\beta^{-1}-1
$$

这沿用论文记号。在 Dynare `model(linear)` 实现中，如果 $r_t$ 是相对 $\rho$ 的偏离，则 $r_t$ 的稳态偏离为零。

对福利/最优政策特殊情形，论文施加：

$$
\sigma=\eta=\gamma=1.
$$

当就业补贴被选择为抵消垄断和贸易条件扭曲时：

$$
(1-\tau)(1-\alpha)=1-\frac{1}{\epsilon},
$$

弹性价格配置是有效的，严格国内价格稳定意味着：

$$
x_t=0,
\qquad
\pi_{H,t}=0.
$$

这一稳态和最优政策讨论来自来源提取。没有构建或检查数值稳态文件。

## 7. Timing & Form Conventions

- **时序**：简化模型没有资本存量或其他预定私人存量。在保留水平表示时，状态变量是外生的 $a_t$、$y_t^{\ast}$ 以及价格水平/贸易条件对象。
- **信息集**：预期 $E_t$ 以 $t$ 期信息为条件。前瞻项包括 $E_t\pi_{H,t+1}$、$E_tx_{t+1}$ 和 $E_t\Delta y_{t+1}^{\ast}$。
- **通胀口径**：`NK_GMAS25ppi` 在 Taylor 规则中使用生产者价格/国内通胀 $\pi_{H,t}$。CPI 通胀作为恒等式 $\pi_t=\pi_{H,t}+\alpha\Delta s_t$ 保留，但不是该版本的政策反馈变量。
- **形式**：围绕对称零通胀稳态的对数线性 `model(linear)`。小写变量表示对数或对数偏离；$\widehat{mc}_t$ 是实际边际成本相对稳态值 $-\mu$ 的偏离。
- **未阅读原始 PDF 正文**：已检查原始 PDF 路径存在并计算哈希；由于 Markdown 来源足以支持一稿提取，未打开 PDF 正文。

## 8. Variable & Parameter Reference Table

### 内生变量

| 符号 | 含义 | 主要决定方程 |
|---|---|---|
| $x_t$ | 国内产出缺口 | (F17) |
| $\pi_{H,t}$ | 国内/PPI 通胀 | (F15) |
| $r_t$ | 对数形式的国内短期名义利率 | (F18) |
| $y_t$ | 国内产出 | (F27) |
| $\overline{y}_t$ | 自然产出 | (F12) |
| $\overline{rr}_t$ | 自然实际利率 | (F16) |
| $s_t$ | 有效贸易条件 | (F27) |
| $p_t$ | CPI 水平 | (F20) |
| $p_{H,t}$ | 国内生产者价格水平 | (F22) |
| $\pi_t$ | CPI 通胀 | (F21) |
| $e_t$ | 名义有效汇率 | (F22) |
| $q_t$ | 实际有效汇率 | (F23) |
| $c_t$ | 国内消费 | (F6), (F25) |
| $n_t$ | 劳动投入 | (F24) |
| $mc_t,\widehat{mc}_t$ | 实际边际成本及其偏离 | (F11), (F14) |
| $nx_t$ | 净出口占比近似 | (F28) |

### 外生变量

| 符号 | 含义 | 过程 |
|---|---|---|
| $a_t$ | 国内技术 | (F30) |
| $y_t^{\ast}$ | 世界产出 | (F31) |
| $\varepsilon_t^a$ | 国内技术创新 | (F30) |
| $\varepsilon_t^{\ast}$ | 世界产出创新 | (F31) |

### 参数

| 符号 | 含义 |
|---|---|
| $\beta$ | 家庭贴现因子 |
| $\sigma$ | 跨期替代弹性倒数/风险厌恶参数 |
| $\varphi$ | 劳动供给弹性倒数 |
| $\alpha$ | 开放度/进口份额参数 |
| $\eta$ | 本国与外国商品束之间的替代弹性 |
| $\gamma$ | 外国来源之间的替代弹性 |
| $\epsilon$ | 差异化品种之间的替代弹性 |
| $\theta$ | Calvo 不重设价格概率 |
| $\lambda$ | Phillips 曲线边际成本斜率 |
| $\kappa_\alpha$ | 开放经济 Phillips 曲线产出缺口斜率 |
| $\rho$ | 稳态实际利率项，$\beta^{-1}-1$ |
| $\rho_a$ | 国内技术持续性 |
| $\rho_{y^{\ast}}$ | 世界产出持续性 |
| $\phi_\pi$ | 国内通胀 Taylor 规则系数 |
| $\tau$ | 就业补贴 |
| $\mu$ | 对数期望加价，$\log(\epsilon/(\epsilon-1))$ |
| $\nu$ | 补贴项，$-\log(1-\tau)$ |
| $\omega,\Theta,\sigma_\alpha,\Omega,\Gamma,\Psi$ | 在 (F12)、(F27) 和 (F29) 中定义的开放经济复合系数 |

公式计数：F1-F32。运行时验证：未执行。
