# NK_KM16 - 公共债务与变化的通胀目标

> `NK_KM16` 的模型档案推导。来源：Krause and Moyen (2016), "Public Debt and Changing Inflation Targets," *American Economic Journal: Macroeconomics*, 8(4): 142-176, DOI `10.1257/mac.20130014`。主要 Markdown 来源：`raw/mmb_mineru/runs/nk_km16__public_debt_and_changing_inflation_targets__e715ef78/full.md`；原始 PDF 记录在 `raw/mmb_papers/Public Debt and Changing Inflation Targets.pdf`。运行验证：未执行。

## 1. Model Overview

- **模型**：封闭经济新凯恩斯模型，包含 Calvo 价格设定、随机到期的长期名义公共债务、财政税率反馈规则和随机通胀目标。
- **主体**：代表性家庭、垄断竞争中间品厂商、财政当局和货币当局。
- **关键非标准机制**：用可赎回永续债近似政府债务期限结构，并为中央银行通胀目标设置不完全信息信号提取问题。
- **形式**：论文求解线性化理性预期系统。MMB 实现使用非线性水平变量、`steady_state_model` 和一阶模拟；本档案记录论文侧非线性均衡条件，并在论文给出时保留线性政策/观测定义。
- **来源状态**：MinerU Markdown 基本可读，但部分公式存在 OCR 损坏。标记为 `needs_review` 的方程在提升为已审条目前应对 PDF 或作者代码核查。

## 2. Optimization Problems

### 代表性家庭

家庭选择消费、实际货币余额、劳动、一周期名义债券，以及随机长期债券组合：

$$
\max_{\{C_t,M_t,N_t,B_t,B_t^L,i_t^L\}} E_0 \sum_{t=0}^{\infty}\beta^t
\left[
\frac{C_t^{1-\sigma_c}}{1-\sigma_c}
+ \chi\frac{(M_t/P_t)^{1-\sigma_m}}{1-\sigma_m}
- \varphi\frac{N_t^{1+\phi}}{1+\phi}
\right].
$$

名义预算约束为：

$$
\begin{aligned}
\frac{B_t}{P_t}+\frac{B_t^{L,n}}{P_t}+\frac{M_t}{P_t}+C_t
&=(1+i_{t-1})\frac{B_{t-1}}{P_t}
+(\alpha+i_{t-1}^L)\frac{B_{t-1}^L}{P_t}
+\frac{M_{t-1}}{P_t} \\
&\quad +(1-\tau_t)\frac{W_t}{P_t}N_t
+\int_0^1\frac{\Pi_t(z)}{P_t}\,dz .
\end{aligned}
$$

家庭还内生化随机长期债券存量和平均利率的运动方程。

### 中间品厂商

每个差异化厂商面对 CES 最终品汇总器给出的需求，并只使用劳动生产：

$$
Y_t(z)=A N_t(z).
$$

以 Calvo 概率 `theta`，厂商不能重设价格。未重设的价格按实际或感知的通胀目标指数化。能够重设价格的厂商选择 \(P_t^*(z)\)，在需求和指数化规则约束下最大化预期贴现利润。

### 财政与货币当局

财政当局在论文侧模型中不求解最优化问题，而是遵循税率规则和合并预算约束。货币当局遵循带随机通胀目标的 Taylor 型名义利率规则。在不完全信息下，私人主体从货币政策信号中估计通胀目标和政策冲击。

## 3. First-Order Conditions

- **(F1) 短期债券欧拉方程**：

$$
1=E_t\left[\beta\frac{\lambda_{t+1}}{\lambda_t}\frac{P_t}{P_{t+1}}(1+i_t)\right].
$$

- **(F2) 长期债券欧拉方程**（`needs_review`：资本损失项附近 OCR 受损）：

$$
1=E_t\left[
\beta\frac{\lambda_{t+1}}{\lambda_t}\frac{P_t}{P_{t+1}}
\left(1+i_t^{L,n}-\mu_{t+1}(1-\alpha)\Delta i_{t+1}^{L,n}\right)
\right].
$$

- **(F3) 财富边际效用**：

$$
\lambda_t=C_t^{-\sigma_c}.
$$

- **(F4) 随机债券价格递推式**：

$$
\mu_t=E_t\left[
\beta\frac{\lambda_{t+1}}{\lambda_t}\frac{P_t}{P_{t+1}}
\left(1+(1-\alpha)\mu_{t+1}\right)
\right].
$$

- **(F5) 货币需求**：

$$
\frac{M_t}{P_t}=
\left[
\chi C_t^{\sigma_c}\frac{1+i_t}{i_t}
\right]^{1/\sigma_m}.
$$

- **(F6) 劳动供给**：

$$
\varphi N_t^{\phi}=C_t^{-\sigma_c}(1-\tau_t)\frac{W_t}{P_t}.
$$

- **(F7) 差异化产品需求**：

$$
C_t(z)=\left(\frac{P_t(z)}{P_t}\right)^{-\epsilon}C_t.
$$

- **(F8) 相对重设价格**：

$$
\frac{P_t^*}{P_t}=\frac{\epsilon}{\epsilon-1}\frac{\mathcal{Z}_{1,t}}{\mathcal{Z}_{2,t}}.
$$

- **(F9) Calvo 分子递推式**：

$$
\mathcal{Z}_{1,t}
=\lambda_t mc_t C_t
+\theta\beta E_t\left[
\left(\frac{\pi_{t+1}}{\pi_{t+1}^*}\right)^{-\epsilon}
\mathcal{Z}_{1,t+1}
\right].
$$

- **(F10) Calvo 分母递推式**：

$$
\mathcal{Z}_{2,t}
=\lambda_t C_t
+\theta\beta E_t\left[
\left(\frac{\pi_{t+1}}{\pi_{t+1}^*}\right)^{1-\epsilon}
\mathcal{Z}_{2,t+1}
\right].
$$

- **(F11) 实际边际成本**：

$$
mc_t=\frac{W_t/P_t}{A}.
$$

## 4. Market Clearing & Identities

- **(F12) 长期债务存量运动方程**：

$$
B_t^L=(1-\alpha)B_{t-1}^L+B_t^{L,n}.
$$

- **(F13) 存量长期债务平均利率**：

$$
i_t^L B_t^L=(1-\alpha)i_{t-1}^L B_{t-1}^L+i_t^{L,n}B_t^{L,n}.
$$

- **(F14) 总价格指数**：

$$
1=\theta(\pi_t^*)^{1-\epsilon}\pi_t^{-(1-\epsilon)}
+(1-\theta)\left(
\frac{\epsilon}{\epsilon-1}\frac{\mathcal{Z}_{1,t}}{\mathcal{Z}_{2,t}}
\right)^{1-\epsilon}.
$$

- **(F15) 财政税率规则**：

$$
\tau_t-\tau=\rho_{\tau}(\tau_{t-1}-\tau)+\phi_{\tau}\hat{b}_t^L.
$$

- **(F16) 实际形式的政府预算约束**：

$$
\tau_t w_t N_t+m_t-\frac{m_{t-1}}{\pi_t}+b_t^{L,n}
=g+(\alpha+i_{t-1}^L)\frac{b_{t-1}^L}{\pi_t}.
$$

- **(F17) 实际长期债务运动方程**：

$$
b_t^L=(1-\alpha)\frac{b_{t-1}^L}{\pi_t}+b_t^{L,n}.
$$

- **(F18) 带时变通胀目标的 Taylor 规则**：

$$
i_t=\rho_i i_{t-1}
+(1-\rho_i)\left[
i+\hat{\pi}_t^*
+\phi_{\pi}(\hat{\pi}_t-\hat{\pi}_t^*)
+\phi_y(\hat{Y}_t-\hat{Y}_t^n)
\right]
+\eta_t.
$$

- **(F19) 总需求**：

$$
Y_t=C_t+g.
$$

- **(F20) 劳动市场/含价格分散的生产汇总**：

$$
\Delta_{p,t}Y_t=A N_t.
$$

- **(F21) 价格分散运动方程**：

$$
\Delta_{p,t}
=\theta\Delta_{p,t-1}\left(\frac{\pi_t}{\pi_t^*}\right)^{\epsilon}
+(1-\theta)\left(
\frac{\epsilon}{\epsilon-1}\frac{\mathcal{Z}_{1,t}}{\mathcal{Z}_{2,t}}
\right)^{-\epsilon}.
$$

## 5. Exogenous Processes

- **(F22) 通胀目标过程**：

$$
\hat{\pi}_t^*=\rho_{\pi}\hat{\pi}_{t-1}^*+\eta_t^{\pi}.
$$

- **(F23) 不完全信息下的货币政策信号**：

$$
\varepsilon_t^{\pi}\equiv(1-\rho_i)(1-\phi_{\pi})\hat{\pi}_t^*+\eta_t.
$$

- **(F24) 感知通胀目标更新**（`needs_review`：OCR 可读，但周边状态空间记号被压缩）：

$$
\tilde{E}_t\hat{\pi}_t^*
=\tilde{E}_{t-1}\hat{\pi}_t^*
+\frac{k}{\rho_{\pi}}
\left(\varepsilon_t^{\pi}-\tilde{E}_{t-1}\varepsilon_t^{\pi}\right).
$$

- **(F25) 感知货币政策冲击**：

$$
\tilde{E}_t\eta_t
=\varepsilon_t^{\pi}
-(1-\rho_i)(1-\phi_{\pi})
\tilde{E}_{t-1}\hat{\pi}_t^*.
$$

- **(F26) Kalman 滤波下的预测**：

$$
\begin{bmatrix}
\tilde{E}_t\hat{\pi}_{t+i}^*\\
\tilde{E}_t\eta_{t+i}
\end{bmatrix}
=
\begin{bmatrix}
\rho_{\pi} & 0\\
0 & 0
\end{bmatrix}^{i}
\begin{bmatrix}
\tilde{E}_t\hat{\pi}_{t}^*\\
\tilde{E}_t\eta_t
\end{bmatrix}.
$$

论文还研究了带偏好冲击的零利率下限扩展，但该扩展不是基准 `NK_KM16` 档案抽取的一部分。

## 6. Steady-State Solution

论文校准季度稳态，并从线性化系统求解动态。MMB 交叉检查文件给出了与论文校准一致的显式稳态赋值：

1. 将稳态通胀设为目标，\(\pi=\pi^*=1.005\)，且 \(R=1/\beta\)。
2. 短期名义利率满足 \(i=R\pi-1\)。
3. 将工时标准化为 \(N=1/3\)。在粘性价格模块中，20% 加成给出 \(w=mc=1/1.2\)；产出为 \(Y=N/\Delta_p\)，且 \(\Delta_p=1\)。
4. 政府支出为 \(g=0.2Y\)，消费为 \(C=Y-g\)，长期公共债务为 \(b^L=0.5Y\)。
5. 货币余额为 \(m=[\chi C^{\sigma_c}(1+i)/i]^{1/\sigma_m}\)。
6. 债券价格乘子为 \(\mu=\frac{\beta/\pi}{1-(\beta/\pi)(1-\alpha)}\)。
7. 新发行长期债务为 \(b^{L,n}=[1-(1-\alpha)/\pi]b^L\)，且 \(i^{L,n}=\pi/\beta-1\)。稳态下平均长期利率等于新发行利率。
8. 税率 \(\tau\) 由政府预算约束残差确定。
9. Calvo 递推式给出 \(\mathcal{Z}_1=\lambda mcY/(1-\theta\beta)\) 和 \(\mathcal{Z}_2=\lambda Y/(1-\theta\beta)\)，重设价格等于指数化后的稳态价格。

本档案条目未对这些稳态赋值执行运行验证。

## 7. Timing & Form Conventions

- **债务存量时点**：\(B_t^L\) 和 \(b_t^L\) 是期末存量，已经包含 \((1-\alpha)B_{t-1}^L\) 的存续部分和新发行 \(B_t^{L,n}\)。政府预算支付 \(t-1\) 期债务的赎回和利息，实际形式中除以当期通胀。
- **长期债券定价**：\(i_t^{L,n}\) 是新发行随机债券的利率。\(i_t^L\) 是存量长期债务的平均利率，并随存续债务存量递推。
- **价格设定**：未重设价格在完全信息下按 \(\pi_t^*\) 指数化，在不完全信息下按感知通胀目标指数化。
- **自然与粘性模块**：MMB 实现包含用于产出缺口政策规则的灵活价格自然模块和粘性价格模块；论文均衡描述在 Taylor 规则中列出 \(Y_t^n\)，但没有在第二节完整重述自然模块方程。
- **模型形式**：论文侧均衡为求解而线性化；实现交叉检查使用非线性水平方程和一阶 Dynare 模拟。

## 8. Variable & Parameter Reference Table

| 类别 | 符号 / ASCII | 含义 | 主要方程 |
|---|---|---|---|
| 内生 | `C`, `c` | 消费 | (F1), (F19) |
| 内生 | `M/P`, `m` | 实际货币余额 | (F5), (F16) |
| 内生 | `N`, `h` | 劳动/工时 | (F6), (F20) |
| 内生 | `B_L`, `D` | 实际/名义长期债务存量 | (F12), (F17) |
| 内生 | `B_L_n`, `Dnew` | 新发行长期债务 | (F12), (F16), (F17) |
| 内生 | `i_L`, `i_D` | 平均长期债务利率 | (F13) |
| 内生 | `i_L_n`, `i_Dnew` | 新发行长期债务利率 | (F2), (F13) |
| 内生 | `i`, `R` | 短期名义政策利率/实际回报约定 | (F1), (F18) |
| 内生 | `pi` | 总通胀率 | (F14), (F18), (F21) |
| 内生 | `lambda`, `lamda` | 财富边际效用 | (F3) |
| 内生 | `mu` | 随机债券乘子/价格 | (F4) |
| 内生 | `tau` | 劳动税率 | (F15), (F16) |
| 内生 | `w`, `MC` | 实际工资/边际成本 | (F6), (F11) |
| 内生 | `Y`, `y` | 产出 | (F19), (F20) |
| 内生 | `Delta_p`, `Disp` | 价格分散 | (F21) |
| 内生 | `Z1`, `Z2` | Calvo 辅助递推变量 | (F9), (F10) |
| 内生 | `P_t^*/P_t` | 相对重设价格 | (F8), (F14), (F21) |
| 内生 | `pi_star`, `PIESTAR` | 通胀目标/目标偏离 | (F18), (F22) |
| 内生 | `Y_n`, `yn` | 灵活价格自然产出 | (F18)；实现交叉检查 |
| 外生 | `eta_PIESTAR` | 通胀目标创新 | (F22) |
| 外生 | `eta_r` / `eta_t` | 货币政策创新 | (F18), (F23) |
| 外生 | `epsi_D` | MMB 实现中的债务冲击 | 实现交叉检查 |
| 外生 | `epsi_G` | MMB 实现中的政府支出冲击 | 实现交叉检查 |
| 参数 | `beta` / `betta` | 贴现因子 | 校准 |
| 参数 | `sigma_c`, `sigma_m` | 消费和货币曲率 | (F1), (F5) |
| 参数 | `chi` | 货币效用权重 | (F5) |
| 参数 | `phi`, `varphi` | 劳动负效用曲率和尺度 | (F6) |
| 参数 | `alpha` / `alphaa` | 随机债务的季度到期概率 | (F12), (F13), (F17) |
| 参数 | `epsilon`, `theta` | 商品替代弹性和 Calvo 粘性 | (F8)-(F10), (F14), (F21) |
| 参数 | `rho_tau`, `phi_tau` | 财政税收反馈参数 | (F15) |
| 参数 | `rho_i`, `phi_pi`, `phi_y` | Taylor 规则参数 | (F18) |
| 参数 | `rho_pi` | 通胀目标持续性 | (F22), (F24), (F26) |
| 参数 | `k`, `P`, `sigma`, `sigma_pi` | Kalman 滤波增益组成项 | (F24)-(F26) |
