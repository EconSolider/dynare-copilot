# NK_DEFK17 - 推导

> `NK_DEFK17` 的模型档案草稿。未执行运行时验证。标记为 `needs_review` 的方程依赖论文正文摘要和本地实现交叉检查，因为论文正文把价格、工资和资本品生产者的详细推导交给在线附录，而本仓库没有对应的规范化附录文件。

## 1. Model Overview

- **模型**：Del Negro, Eggertsson, Ferrero, and Kiyotaki (2017), "The Great Escape? A Quantitative Evaluation of the Fed's Liquidity Facilities."
- **来源**：`raw/mmb_mineru/runs/nk_defk17__the_great_escape_a_quantitative_evaluation_of_the_fed_s_liquidity_facili__b6479bed/full.md`；已检查原始 PDF 路径 `raw/mmb_papers/The Great Escape? A Quantitative Evaluation of the Fed's Liquidity Facilities.pdf` 存在。
- **主体**：含企业家和工人的代表性家庭、政府、中间品与最终品厂商、劳动机构/工会、资本品生产者。
- **核心摩擦**：Kiyotaki-Moore 流动性摩擦。企业家面临新股权发行的借款约束和既有股权的可转售约束；政府票据完全流动。
- **政策实验**：对私人票据可转售性 `phi` 的确定性完全预见流动性冲击；常规货币政策是受零下限约束的 Taylor 规则；非常规政策是政府购买私人票据。
- **形式**：论文使用含偶发绑定 ZLB 的非线性模型。本地 MMB 实现使用非线性 Dynare `model` 块和 `max(...,1)` 名义利率规则。

## 2. Optimization Problems

### 家庭

总家庭消费为

\[
C_t = \int_0^1 C_t(j)\,dj.
\]

代表性家庭目标函数为

\[
E_t \sum_{s=t}^{\infty}\beta^{s-t}
\left[
\frac{C_s^{1-\sigma}}{1-\sigma}
- \frac{\omega}{1+\nu}\int_{\varkappa}^{1} H_s(j)^{1+\nu}\,dj
\right].
\]

净股权由其他家庭资本索取权、自有资本和对自有资本发行的索取权定义：

\[
N_t = N_t^O + K_t - N_t^I.
\]

每个成员的资金流约束为

\[
C_t(j) + p_t^I I_t(j) + q_t\left[N_{t+1}(j)-I_t(j)\right] + \frac{B_{t+1}(j)}{P_t}
= \left[R_t^k+(1-\delta)q_t\right]N_t + \frac{R_{t-1}B_t}{P_t}
+ \frac{W_t(j)}{P_t}H_t(j)-\tau_t.
\]

金融约束为

\[
N_{t+1}(j) \ge (1-\theta)I_t(j) + (1-\phi_t)(1-\delta)N_t,
\]

\[
B_{t+1}(j) \ge 0.
\]

### 企业家

对企业家，论文聚焦于 \(q_t>p_t^I\) 的受约束均衡。融资约束绑定：

\[
N_{t+1}(j) = (1-\theta)I_t(j) + (1-\phi_t)(1-\delta)N_t(j),
\]

\[
B_{t+1}(j)=0,\qquad C_t(j)=0.
\]

个人投资为

\[
I_t(j)=
\frac{\left[R_t^k+(1-\delta)q_t\phi_t\right]N_t
+ \frac{R_{t-1}B_t}{P_t}-\tau_t}
{p_t^I-\theta q_t}.
\]

总投资为

\[
I_t=\varkappa
\frac{\left[R_t^k+(1-\delta)q_t\phi_t\right]N_t
+ \frac{R_{t-1}B_t}{P_t}-\tau_t}
{p_t^I-\theta q_t}.
\]

### 工人、工资制定者、厂商和资本品生产者

工人的资产与消费选择在家庭层面决定。工会在 Calvo 工资黏性下设定工资。最终品厂商聚合中间品；中间品生产者使用资本和劳动、支付固定成本，并在 Calvo 价格黏性下设定价格。资本品生产者把最终品转化为投资品，并有调整成本 \(S(I_t/I)\)，其中 \(S(1)=S'(1)=0\) 且 \(S''(1)>0\)。

论文正文说明这些生产、价格、工资和资本品生产者模块是标准 CEE/SW 模块，并将细节交给在线附录 B.1-B.3。本地 `.mod` 交叉检查给出了递归方程，但凡论文正文未打印的公式均标为 `needs_review`。

## 3. First-Order Conditions

- **(F1) 债券 Euler 方程**：

\[
C_t^{-\sigma} =
\beta E_t\left\{
C_{t+1}^{-\sigma}
\frac{R_t}{\pi_{t+1}}
\left[
1+\frac{\varkappa(q_{t+1}-p_{t+1}^I)}
{p_{t+1}^I-\theta q_{t+1}}
\right]
\right\}.
\]

- **(F2) 股权 Euler 方程**：

\[
C_t^{-\sigma} =
\beta E_t\left\{
C_{t+1}^{-\sigma}
\left[
\frac{R_{t+1}^k+(1-\delta)q_{t+1}}{q_t}
+ \frac{\varkappa(q_{t+1}-p_{t+1}^I)}
{p_{t+1}^I-\theta q_{t+1}}
\frac{R_{t+1}^k+(1-\delta)\phi_{t+1}q_{t+1}}{q_t}
\right]
\right\}.
\]

- **(F3) 投资融资方程**：

\[
(p_t^I-\theta q_t)I_t =
\varkappa\left(
\left[R_t^k+\phi_t(1-\delta)q_t\right]N_t
+ \frac{R_{t-1}B_t}{P_t}-\tau_t
\right).
\]

- **(F4) 投资品价格** `needs_review`：

\[
p_t^I = 1+S\left(\frac{I_t}{I}\right)+S'\left(\frac{I_t}{I}\right)\frac{I_t}{I}.
\]

- **(F5) 投资调整成本定义** `needs_review`：

\[
S_t = \frac{s_0}{2}\left(\frac{I_t}{I}-1\right)^2.
\]

- **(F6) 投资调整成本导数** `needs_review`：

\[
S'_t = s_0\left(\frac{I_t}{I}-1\right).
\]

- **(F7) 含价格分散和固定成本的生产函数** `needs_review`：

\[
Y_t\Delta_{p,t} = A K_{t-1}^{\gamma}H_t^{1-\gamma}-\Gamma.
\]

- **(F8) 资本边际产出** `needs_review`：

\[
r_t^K = \gamma mc_t A\left(\frac{H_t}{K_{t-1}}\right)^{1-\gamma}.
\]

- **(F9) 劳动边际产出 / 实际工资** `needs_review`：

\[
w_t = (1-\gamma)mc_t A\left(\frac{K_{t-1}}{H_t}\right)^{\gamma}.
\]

- **(F10) 租金收入恒等式** `needs_review`：

\[
R_t^K K_{t-1} = Y_t - w_tH_t + \left[p_t^I-(1+S_t)\right]I_t.
\]

- **(F11) 价格 Phillips 辅助关系** `needs_review`：

\[
X_{1p,t}=X_{2p,t}
\left(
\frac{1-\xi_p\pi_t^{1/\lambda_p}}{1-\xi_p}
\right)^{-\lambda_p}.
\]

- **(F12) 实际边际成本现值** `needs_review`：

\[
X_{1p,t}=(1+\lambda_p)C_t^{-\sigma}Y_tmc_t
+\beta\xi_p E_t\left[\pi_{t+1}^{(1+\lambda_p)/\lambda_p}X_{1p,t+1}\right].
\]

- **(F13) 实际边际收益现值** `needs_review`：

\[
X_{2p,t}=C_t^{-\sigma}Y_t
+\beta\xi_p E_t\left[\pi_{t+1}^{1/\lambda_p}X_{2p,t+1}\right].
\]

- **(F14) 工资 Phillips 辅助关系** `needs_review`：

\[
X_{1w,t}=X_{2w,t}
\left(
\frac{1-\xi_w\pi_{w,t}^{1/\lambda_w}}{1-\xi_w}
\right)^{-\left[\lambda_w+(1+\lambda_w)\nu\right]}.
\]

- **(F15) 工作边际负效用现值** `needs_review`：

\[
X_{1w,t}=(1+\lambda_w)H_t^{1+\nu}
+\beta\xi_w E_t\left[\pi_{w,t+1}^{(1+\lambda_w)(1+\nu)/\lambda_w}X_{1w,t+1}\right].
\]

- **(F16) 实际工资账单现值** `needs_review`：

\[
X_{2w,t}=C_t^{-\sigma}w_tH_t
+\beta\xi_w E_t\left[\pi_{w,t+1}^{1/\lambda_w}X_{2w,t+1}\right].
\]

- **(F17) 实际工资和通胀关系** `needs_review`：

\[
w_t\pi_t=w_{t-1}\pi_{w,t}.
\]

## 4. Market Clearing & Identities

- **(F18) 总净股权**：

\[
N_{t+1}=\int N_{t+1}(j)\,dj.
\]

- **(F19) 总债券**：

\[
B_{t+1}=\int B_{t+1}(j)\,dj.
\]

- **(F20) 资本积累**：

\[
K_{t+1}=(1-\delta)K_t+\int I_t(j)\,dj.
\]

- **(F21) 政府持有资本组合份额**：

\[
K_{t+1}=N_{t+1}+N_{t+1}^g.
\]

- **(F22) 资源约束**：

\[
Y_t=C_t+\left[1+S\left(\frac{I_t}{I}\right)\right]I_t.
\]

- **(F23) 政府预算约束**：

\[
q_tN_{t+1}^g+\frac{R_{t-1}B_t}{P_t}
=\tau_t+\left[R_t^k+(1-\delta)q_t\right]N_t^g+\frac{B_{t+1}}{P_t}.
\]

- **(F24) 财政规则**：

\[
\tau_t-\tau =
\psi_{\tau}
\left[
\left(\frac{R_{t-1}B_t}{P_t}-\frac{RB}{P}\right)
-q_tN_t^g
\right].
\]

- **(F25) 价格分散运动方程** `needs_review`：

\[
\Delta_{p,t}=
\xi_p\Delta_{p,t-1}\pi_t^{(1+\lambda_p)/\lambda_p}
+(1-\xi_p)
\left(
\frac{1-\xi_p\pi_t^{1/\lambda_p}}{1-\xi_p}
\right)^{1+\lambda_p}.
\]

- **(F26) 实际利率恒等式**：

\[
rr_t=\frac{R_t}{E_t\pi_{t+1}}.
\]

- **(F27) 非流动股权预期收益**：

\[
ERQ_t=E_t\left[\frac{R_{t+1}^K+(1-\delta)q_{t+1}}{q_t}\right].
\]

- **(F28) 股权-债券利差**：

\[
Spr_t=ERQ_t-rr_t.
\]

- **(F29) 便利收益率**：

\[
CY_t =
E_t\left[
\frac{\varkappa(q_{t+1}-p_{t+1}^I)}
{p_{t+1}^I-\theta q_{t+1}}
\right].
\]

- **(F30) 资本价值**：

\[
QK_t=q_tK_{t-1}.
\]

- **(F31) GDP 计量变量**：

\[
GDP_t=C_t+p_t^I I_t.
\]

- **(F32) 无便利收益证券 Euler 方程**：

\[
C_t^{-\sigma}=\beta E_t\left\{C_{t+1}^{-\sigma}\frac{R_t^0}{\pi_{t+1}}\right\}.
\]

## 5. Exogenous Processes

- **(F33) 含零下限的 Taylor 规则**：

\[
R_t=\max\left\{
R\pi_t^{\psi_{\pi}}\left(\frac{Y_t}{Y}\right)^{\psi_y},
1
\right\}.
\]

- **(F34) 非常规信用政策规则**：

\[
N_{t+1}^g=\psi_k(\phi_t-\phi).
\]

- **(F35) 流动性冲击过程**：

\[
\phi_t=(1-\rho_{\phi})\phi+\rho_{\phi}\phi_{t-1}+\varepsilon_{\phi,t}.
\]

## 6. Steady-State Solution

论文按季度频率校准模型。主要稳态目标是便利收益率、相对产出的流动资产供给、实际利率、流动性份额、劳动份额和投资产出比。论文报告了精确校准目标和模型隐含值，但正文没有给出每个递归定价和工资模块的完整闭式稳态推导。

有来源支持的稳态骨架为：

1. 设定 \(\bar{\phi}=0.309\), \(\theta=0.792\), \(\beta=0.993\), \(\varkappa=0.009\), \(\delta=0.024\), \(\gamma=0.340\)。
2. 设定 \(\bar{\pi}=1\) 且 \(\bar{\pi}_w=1\)。
3. 使用稳态实际收益率和便利收益率目标确定流动和非流动资产收益。
4. 由稳态非常规政策规则设定 \(\bar{N}^g=0\)。
5. 当 \(\bar{N}^g=0\) 时，由 (F21) 使用 \(\bar{K}=\bar{N}\)。
6. 由 (F20) 使用 \(\bar{I}=\delta\bar{K}\)。
7. 因为 \(S(1)=0\)，由 (F22) 使用 \(\bar{Y}=\bar{C}+\bar{I}\)。
8. 使用生产模块、工资模块和价格模块求解 \(\bar{mc}\), \(\bar{w}\), \(\bar{H}\), \(\bar{Y}\) 以及递归辅助变量。

`NK_DEFK17_rep.mod` 中的实现交叉检查稳态值包括 `Y_ss=2.6779`, `C_ss=1.9685`, `I_ss=0.70945`, `K_ss=29.2064`, `H_ss=0.90345`, `Q_ss=1.0223`, `R_ss=1.0055`, `phi_ss=0.3092`, `LY_ss=1.6`, `tau_ss=0.023387`。这些值没有由规范化附录独立来源验证，仍为 `needs_review`。

## 7. Timing & Form Conventions

- 模型是非线性的。论文求解非线性完全预见路径，并内生处理零下限。
- 生产中的资本是预定状态变量：生产使用 \(K_{t-1}\)，资本积累根据具体时点约定决定 \(K_t\) 或 \(K_{t+1}\)。
- 净股权和政府私人票据持有量是存量变量。论文说明总资本由家庭和政府持有，满足 \(K_{t+1}=N_{t+1}+N_{t+1}^g\)。
- 名义债券的时点设定使期初债务服务项表现为 \(R_{t-1}B_t/P_t\)。
- 流动性冲击是可转售性参数 \(\phi_t\)；MMB 实现使用 `e_phi` 作为唯一外生创新。
- 本地 MMB 实现相对论文符号把若干方程移动一个时期，例如生产中使用 `K(-1)`，投资方程中使用 `N(-1)`。这记录为实现时点交叉检查，而不是论文侧来源证据。

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII | Meaning | Equation anchor |
|---|---|---|---|
| Endogenous | `C`, \(C_t\) | 家庭总消费 | (F1), (F22) |
| Endogenous | `Inv`, \(I_t\) | 投资 | (F3), (F20), (F22) |
| Endogenous | `S_Inv`, \(S_t\) | 投资调整成本 | (F5), (F22) |
| Endogenous | `dS_Inv`, \(S'_t\) | 调整成本导数 | (F6) |
| Endogenous | `H`, \(H_t\) | 劳动投入 | (F7), (F9), (F15) |
| Endogenous | `Y`, \(Y_t\) | 产出 | (F7), (F22), (F33) |
| Endogenous | `tau`, \(\tau_t\) | 税收 / 初级盈余 | (F23), (F24) |
| Endogenous | `K`, \(K_t\) | 资本存量 | (F20), (F21) |
| Endogenous | `N`, \(N_t\) | 私人净股权 | (F18), (F21) |
| Endogenous | `Ng`, \(N_t^g\) | 政府私人票据持有 | (F21), (F34) |
| Endogenous | `LY` | 政府债务产出状态 | (F23), (F24) |
| Endogenous | `Q`, \(q_t\) | 股权 / 资本价值 | (F2), (F23), (F30) |
| Endogenous | `pI`, \(p_t^I\) | 投资品价格 | (F3), (F4) |
| Endogenous | `RK`, \(R_t^K\) | 资本租金/股息收益 | (F2), (F10) |
| Endogenous | `rK`, \(r_t^K\) | 边际产出 / 租金率 | (F8) |
| Endogenous | `rr`, \(rr_t\) | 流动资产实际收益 | (F26) |
| Endogenous | `rr0`, \(R_t^0/E_t\pi_{t+1}\) | 无便利收益证券收益 | (F32) |
| Endogenous | `ERQ`, \(ERQ_t\) | 非流动股权预期收益 | (F27) |
| Endogenous | `w`, \(w_t\) | 实际工资 | (F9), (F17) |
| Endogenous | `infl_w`, \(\pi_{w,t}\) | 工资通胀 | (F14), (F17) |
| Endogenous | `X1w`, \(X_{1w,t}\) | 工资递归分子 | (F14), (F15) |
| Endogenous | `X2w`, \(X_{2w,t}\) | 工资递归分母 | (F14), (F16) |
| Endogenous | `mc`, \(mc_t\) | 实际边际成本 | (F7), (F12) |
| Endogenous | `infl`, \(\pi_t\) | 价格通胀 | (F11), (F25), (F33) |
| Endogenous | `X1p`, \(X_{1p,t}\) | 价格递归分子 | (F11), (F12) |
| Endogenous | `X2p`, \(X_{2p,t}\) | 价格递归分母 | (F11), (F13) |
| Endogenous | `Delta_p`, \(\Delta_{p,t}\) | 价格分散 | (F7), (F25) |
| Endogenous | `CY`, \(CY_t\) | 便利收益率 | (F29) |
| Endogenous | `Spr`, \(Spr_t\) | 非流动股权利差 | (F28) |
| Endogenous | `phi`, \(\phi_t\) | 可转售性 / 流动性状态 | (F34), (F35) |
| Endogenous | `QK`, \(q_tK_{t-1}\) | 资本价值 | (F30) |
| Endogenous | `GDP` | GDP 计量变量 | (F31) |
| Exogenous | `e_phi`, \(\varepsilon_{\phi,t}\) | 流动性冲击创新 | (F35) |
| Parameter | `beta` | 贴现因子 | (F1), (F2) |
| Parameter | `sigma` | 相对风险厌恶 | (F1), (F2) |
| Parameter | `nu` | Frisch 弹性倒数 | (F15) |
| Parameter | `kappa`, \(\varkappa\) | 投资机会概率 | (F3), (F29) |
| Parameter | `theta` | 借款约束 | (F3), (F29) |
| Parameter | `gamma` | 资本份额 | (F7), (F8), (F9) |
| Parameter | `delta` | 折旧 | (F20) |
| Parameter | `s0` | 投资调整成本尺度 | (F5), (F6) |
| Parameter | `lambda_w`, `lambda_p` | 工资和价格加成参数 | (F11)-(F16) |
| Parameter | `xi_w`, `xi_p` | Calvo 工资和价格概率 | (F11)-(F16), (F25) |
| Parameter | `psi_p`, `psi_y` | Taylor 规则反应系数 | (F33) |
| Parameter | `rho_i` | 实现中的利率平滑 | (F33) |
| Parameter | `psi_k` | 流动性干预系数 | (F34) |
| Parameter | `psi_tau` | 财政反馈系数 | (F24) |
| Parameter | `rho_phi` | 流动性冲击持续性 | (F35) |
| Parameter | `Gamma` | 生产固定成本 | (F7) |
