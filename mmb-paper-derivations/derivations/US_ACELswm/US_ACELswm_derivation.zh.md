# US_ACELswm -- 推导（最优化问题 + 一阶条件）

> 归档状态：`needs_review`。本一稿推导基于 Altig、Christiano、Eichenbaum 和 Linde（2005）的 MinerU Markdown；`.agents/skills/dynare-copilot/references/examples/US_ACELswm_rep.mod` 仅作为 `implementation_cross_check` 使用。未进行运行时验证。

> 方程标签从 (F1) 连续到 (F53)；公式使用对应的 LaTeX `\tag{F#}` 标签。

## 1. Model Overview

- **模型**：`US_ACELswm`，Altig, Christiano, Eichenbaum, and Linde, "Firm-Specific Capital, Nominal Rigidities and the Business Cycle"（2005 working paper；DOI `10.3386/w11034`）。
- **归档来源**：`raw/mmb_mineru/runs/us_acelm_us_acelswm_us_acelswt_us_acelt__firm_specific_capital_nominal_rigidities__e0fac58f/full.md`；原始 PDF 为 `raw/mmb_papers/Firm-specific capital, nominal rigidities.pdf`。
- **经济体**：估计型美国中等规模新凯恩斯模型，包含习惯形成、货币/交易服务、粘性工资、粘性价格、可变资本利用、投资调整成本、中性技术冲击、资本体现型技术冲击和货币冲击。
- **模型变体**：`US_ACELswm` 是 MMB 中的粘性工资货币冲击实现。实现交叉检查显示，该版本关闭成本渠道（`\nu` 近似为零），并包含一个并行的灵活价格配置块。
- **形式**：`model(linear)`。MMB 实现中的变量是围绕平衡增长稳态的对数偏离或缩放线性偏离。论文给出非线性基础和简化通胀方程；OCR 未完整包含技术附录线性系统，因此从交叉检查恢复的部分标记为 `needs_review`。
- **核心时序**：先观察技术冲击；家庭和企业作出实际决策；工资设定发生在货币政策冲击之前；随后货币冲击和产品需求实现。资本在期内预定；在企业特定资本解释中，每个中间品企业在期初拥有自己的物质资本存量。

## 2. Optimization Problems

### 2.1 最终品企业

竞争性最终品生产者聚合中间品：

\[
Y_t=\left[\int_0^1 y_t(i)^{1/\lambda_f}\,di\right]^{\lambda_f},
\qquad 1\leq \lambda_f<\infty .
\tag{F1}
\]

利润最大化给出中间品 \(i\) 的需求曲线：

\[
\frac{y_t(i)}{Y_t}=\left(\frac{P_t}{P_t(i)}\right)^{\lambda_f/(\lambda_f-1)} .
\tag{F2}
\]

对应的总价格指数为：

\[
P_t=\left[\int_0^1 P_t(i)^{1/(1-\lambda_f)}\,di\right]^{1-\lambda_f}.
\tag{F3}
\]

### 2.2 中间品企业

中间品企业 \(i\) 使用中性技术、体现型技术缩放和固定成本生产：

\[
y_t(i)=K_t(i)^\alpha\left(z_t h_t(i)\right)^{1-\alpha}-\phi z_t^{\ast},
\qquad
z_t^{\ast}=\Upsilon_t^{\alpha/(1-\alpha)}z_t .
\tag{F4}
\]

在同质资本基准中，企业租用资本和劳动，并在需求和 Calvo 定价约束下最大化预期贴现名义利润。在企业特定资本模型中，企业 \(i\) 拥有其资本，并选择价格、劳动、投资和利用率：

\[
E_t\sum_{j=0}^{\infty}\beta^j v_{t+j}
\left\{
P_{t+j}(i)y_{t+j}(i)
-P_{t+j}R_{t+j}w_{t+j}h_{t+j}(i)
-P_{t+j}\Upsilon_{t+j}^{-1}\left[I_{t+j}(i)+a(u_{t+j}(i))\bar K_{t+j}(i)\right]
\right\}.
\tag{F5}
\]

企业特定资本积累为：

\[
\bar K_{t+1}(i)=(1-\delta)\bar K_t(i)+
\left[1-S\left(\frac{I_t(i)}{I_{t-1}(i)}\right)\right]I_t(i).
\tag{F6}
\]

Calvo 价格设定：企业以概率 \(1-\xi_p\) 重新优化价格；否则：

\[
P_t(i)=\pi_{t-1}P_{t-1}(i).
\tag{F7}
\]

### 2.3 家庭

家庭 \(j\) 最大化习惯偏好：

\[
E_t^j\sum_{\ell=0}^{\infty}\beta^{\ell-t}
\left[
\log(C_{t+\ell}-bC_{t+\ell-1})
-\psi_L\frac{h_{j,t+\ell}^2}{2}
\right].
\tag{F8}
\]

名义资产积累方程为：

\[
\begin{aligned}
M_{t+1}={}&R_t\left[M_t-Q_t+(x_t-1)M_t^a\right]+A_{j,t}+Q_t+W_{j,t}h_{j,t}\\
&+P_t r_t^k u_t\bar K_t+D_t
-(1+\eta(V_t))P_tC_t
-P_t\Upsilon_t^{-1}\left[I_t+a(u_t)\bar K_t\right].
\end{aligned}
\tag{F9}
\]

交易速度和货币服务成本为：

\[
V_t=\frac{P_tC_t}{Q_t},\qquad \eta'(V_t)>0,\qquad \eta''(V_t)>0.
\tag{F10}
\]

资本服务、利用率和投资调整为：

\[
K_t=u_t\bar K_t,\qquad
\bar K_{t+1}=(1-\delta)\bar K_t+\left[1-S\left(\frac{I_t}{I_{t-1}}\right)\right]I_t .
\tag{F11}
\]

### 2.4 工资设定者

差异化劳动服务被聚合为：

\[
H_t=\left[\int_0^1 h_{j,t}^{1/\lambda_w}\,dj\right]^{\lambda_w}.
\tag{F12}
\]

劳动需求和工资指数为：

\[
h_{j,t}=\left(\frac{W_t}{W_{j,t}}\right)^{\lambda_w/(\lambda_w-1)}H_t,
\qquad
W_t=\left[\int_0^1 W_{j,t}^{1/(1-\lambda_w)}\,dj\right]^{1-\lambda_w}.
\tag{F13}
\]

家庭以概率 \(1-\xi_w\) 重新优化工资；否则：

\[
W_{j,t}=\pi_{t-1}\mu_{z^{\ast}}W_{j,t-1}.
\tag{F14}
\]

## 3. First-Order Conditions

### 3.1 价格和边际成本块

论文说明，同质资本和企业特定资本的总量系统只在结构参数到通胀方程斜率的映射上不同。简化通胀方程为：

\[
\Delta\hat\pi_t
=E_t\left[\beta\Delta\hat\pi_{t+1}+\gamma\hat s_t\mid\Omega_t\right].
\tag{F15}
\]

同质资本情形下：

\[
\gamma=\frac{(1-\xi_p)(1-\beta\xi_p)}{\xi_p}\chi,
\qquad \chi=1.
\tag{F16}
\]

企业特定资本情形下，\(\chi\) 是结构参数的非线性函数；精确函数由技术附录给出，本归档条目中标记为 `needs_review`。

### 3.2 来自技术附录交叉检查的线性均衡条件

MMB 实现把粘性价格块标注为技术附录方程 (1)-(16)。由于 OCR 来源未包含完整技术附录，`(F17)` 至 `(F32)` 记录为 implementation-cross-checked 公式，后续推广前需要论文/PDF 层面核查。

**(F17) 资本欧拉方程（`needs_review`, implementation_cross_check）：**

\[
\hat\lambda_{z^{\ast},t+1}
\frac{1-\delta}{\tilde\rho+1-\delta}\hat{\tilde\mu}_{t+1}
\frac{\tilde\rho}{\tilde\rho+1-\delta}\hat{\tilde\rho}_{t+1}
-\hat\lambda_{z^{\ast},t}-\hat{\tilde\mu}_t
=\hat\mu_{z,t+1}+\frac{1}{1-\alpha}\hat\mu_{\Upsilon,t+1}.
\tag{F17}
\]

**(F18) 投资欧拉方程（`needs_review`, implementation_cross_check）：**

\[
\begin{aligned}
&-\beta\kappa(\mu_{z^{\ast}}\mu_\Upsilon)^2\hat i_{t+1}
-\hat{\tilde\mu}_{t-1|t}
+\kappa(\mu_{z^{\ast}}\mu_\Upsilon)^2(1+\beta)\hat i_t
-\kappa(\mu_{z^{\ast}}\mu_\Upsilon)^2\hat i_{t-1}\\
&=\beta\kappa(\mu_{z^{\ast}}\mu_\Upsilon)^2\hat\mu_{z,t+1}
+\frac{\beta\kappa(\mu_{z^{\ast}}\mu_\Upsilon)^2}{1-\alpha}\hat\mu_{\Upsilon,t+1}
-\kappa(\mu_{z^{\ast}}\mu_\Upsilon)^2\hat\mu_{z,t}
-\frac{\kappa(\mu_{z^{\ast}}\mu_\Upsilon)^2}{1-\alpha}\hat\mu_{\Upsilon,t}.
\end{aligned}
\tag{F18}
\]

**(F19) 资本影子租金方程（`needs_review`, implementation_cross_check）：**

\[
\begin{aligned}
\hat{\tilde w}_{t-1|t}
+\frac{1}{1-\alpha}\frac{\tilde y}{\tilde y+\phi}\hat{\tilde y}_t
+\frac{\nu R}{\nu R+1-\nu}\hat R_t
-\hat{\tilde\rho}_t
-\frac{1}{1-\alpha}\hat u_{t-1|t}
-\frac{1}{1-\alpha}\hat{\bar k}_{t}
=-\frac{1}{1-\alpha}\hat\mu_{z,t}
-\frac{1}{(1-\alpha)^2}\hat\mu_{\Upsilon,t}
+\frac{1}{1-\alpha}\epsilon_t .
\end{aligned}
\tag{F19}
\]

**(F20) 资本演化（`needs_review`, implementation_cross_check）：**

\[
(\mu_{z^{\ast}}\mu_\Upsilon-(1-\delta))\hat i_{t-1|t}
-\mu_\Upsilon\mu_{z^{\ast}}\hat{\bar k}_{t+1}
+(1-\delta)\hat{\bar k}_{t}
=(1-\delta)\hat\mu_{z,t}
+\frac{1-\delta}{1-\alpha}\hat\mu_{\Upsilon,t}.
\tag{F20}
\]

**(F21) 粘性价格通胀方程（`needs_review`, implementation_cross_check）：**

\[
\beta\hat\pi_{t+1}-(1+\beta\varsigma)\hat\pi_t+\gamma\hat s_t
=-\varsigma\hat\pi_{t-1}.
\tag{F21}
\]

**(F22) 边际成本方程（`needs_review`, implementation_cross_check）：**

\[
\begin{aligned}
\hat{\tilde w}_{t-1|t}-\hat s_t
+\frac{\alpha}{1-\alpha}\frac{\tilde y}{\tilde y+\phi}\hat{\tilde y}_t
+\frac{\nu R}{\nu R+1-\nu}\hat R_t
-\frac{\alpha}{1-\alpha}\hat u_{t-1|t}
-\frac{\alpha}{1-\alpha}\hat{\bar k}_t\\
=-\frac{\alpha}{1-\alpha}\hat\mu_{z,t}
-\frac{\alpha}{(1-\alpha)^2}\hat\mu_{\Upsilon,t}
+\frac{1}{1-\alpha}\epsilon_t .
\end{aligned}
\tag{F22}
\]

**(F23) 货币需求（`needs_review`, implementation_cross_check）：**

\[
\hat c_{t-1|t}-\hat q_t=\frac{R}{(R-1)(2+\varphi_\eta)}\hat R_t .
\tag{F23}
\]

**(F24) 消费欧拉方程（`needs_review`, implementation_cross_check）：**

\[
\mathcal A_c E_t\hat c_{t+1}+\mathcal B_c\hat c_t+\mathcal C_c\hat\lambda_{z^{\ast},t}
\mathcal D_c\hat q_t+\mathcal E_c\hat c_{t-1}
=\mathcal F_cE_t\hat\mu_{z,t+1}+\mathcal G_cE_t\hat\mu_{\Upsilon,t+1}
\mathcal H_c\hat\mu_{z,t}+\mathcal J_c\hat\mu_{\Upsilon,t}.
\tag{F24}
\]

系数 \(\mathcal A_c,\ldots,\mathcal J_c\) 是 \((\beta,b,\mu_{z^{\ast}},c,\lambda_{z^{\ast}},\eta,\eta',V,\alpha)\) 的函数，如实现交叉检查所示；此紧凑写法标记为 `needs_review`。

**(F25) 货币基础一阶条件（`needs_review`, implementation_cross_check）：**

\[
\hat\lambda_{z^{\ast},t+1}-\hat\pi_{t+1}+\hat R_{t+1}-\hat\lambda_{z^{\ast},t}
=\hat\mu_{z,t+1}+\frac{\alpha}{1-\alpha}\hat\mu_{\Upsilon,t+1}.
\tag{F25}
\]

**(F26) 工资一阶条件（`needs_review`, implementation_cross_check）：**

\[
\begin{aligned}
\eta_2\hat{\tilde w}_{t+1}+\eta_4\hat\pi_{t+1}
+\eta_1\hat{\tilde w}_{t}+\eta_3\hat\pi_t
+\eta_5\hat h_t+\eta_6\hat\lambda_{z^{\ast},t}
+\eta_0\hat{\tilde w}_{t-1}+\bar\eta_3\hat\pi_{t-1}\\
=-\eta_8\frac{\alpha}{1-\alpha}\hat\mu_{\Upsilon,t+1}
-\eta_8\hat\mu_{z,t+1}
-\eta_7\frac{\alpha}{1-\alpha}\hat\mu_{\Upsilon,t}
-\eta_7\hat\mu_{z,t}.
\end{aligned}
\tag{F26}
\]

### 3.3 利用率和家庭稳态 FOC

论文侧稳态名义回报和货币 FOC 为：

\[
R=\frac{\pi\mu_{z^{\ast}}}{\beta}.
\tag{F27}
\]

\[
R_t=1+\eta'\left(\frac{P_tC_t}{Q_t}\right)
\left(\frac{P_tC_t}{Q_t}\right)^2.
\tag{F28}
\]

货币需求利率半弹性为：

\[
\epsilon=\frac{1}{4}\left(\frac{1}{R-1}\right)\left(\frac{1}{2+\varphi_\eta}\right),
\qquad
\varphi_\eta=\frac{\eta''V}{\eta'} .
\tag{F29}
\]

线性化利用率满足：

\[
E_t\left[\frac{1}{\sigma_a}\hat r_t^k-\hat u_t\mid\Omega_t\right]=0.
\tag{F30}
\]

投资调整成本 FOC 可概括为：

\[
\hat i_t=\hat i_{t-1}
+\frac{1}{S''}\sum_{j=0}^{\infty}\beta^j
E_t\hat P_{k',t+j}.
\tag{F31}
\]

## 4. Market Clearing & Identities

贷款市场出清要求金融中介把企业支付工资所需资金全部贷出：

\[
W_tH_t=x_tM_t-Q_t.
\tag{F32}
\]

总资源约束为：

\[
(1+\eta(V_t))C_t+\Upsilon_t^{-1}\left[I_t+a(u_t)\bar K_t\right]\leq Y_t .
\tag{F33}
\]

实现交叉检查中的线性资源约束为：

\[
\begin{aligned}
&\left((1+\eta)c+\eta'c^2/q\right)\hat c_{t-1|t}
+\left(1-\frac{1-\delta}{\mu_\Upsilon\mu_{z^{\ast}}}\right)\bar k\,\hat i_{t-1|t}
-(\tilde y+\phi)(1-\alpha)\hat h_t
-\eta'c^2/q\,\hat q_t\\
&+\left(\frac{\tilde\rho\bar k}{\mu_{z^{\ast}}\mu_\Upsilon}-(\tilde y+\phi)\alpha\right)\hat u_{t-1|t}
-(\tilde y+\phi)\alpha\hat{\bar k}_t
+(\tilde y+\phi)\alpha\hat\mu_{z,t}
+\frac{(\tilde y+\phi)\alpha}{1-\alpha}\hat\mu_{\Upsilon,t}
-(\tilde y+\phi)\epsilon_t=0 .
\end{aligned}
\tag{F34}
\]

货币基础积累连接货币增长、货币余额和通胀：

\[
-\hat m_t-\hat\pi_{t-1}+\hat m_{t-1}+\hat x_{t-1}
=\hat\mu_{z,t}+\frac{\alpha}{1-\alpha}\hat\mu_{\Upsilon,t}.
\tag{F35}
\]

线性化生产函数为：

\[
\begin{aligned}
(\tilde y+\phi)(1-\alpha)\hat h_t-\tilde y\hat{\tilde y}_t
+\left((\tilde y+\phi)\alpha-\frac{\tilde\rho\bar k}{\mu_{z^{\ast}}\mu_\Upsilon}\right)\hat u_{t-1|t}
+(\tilde y+\phi)\alpha\hat{\bar k}_t\\
=(\tilde y+\phi)\alpha\hat\mu_{z,t}
+\frac{(\tilde y+\phi)\alpha}{1-\alpha}\hat\mu_{\Upsilon,t}
-(\tilde y+\phi)\epsilon_t .
\end{aligned}
\tag{F36}
\]

实现交叉检查中的资本利用率为：

\[
\hat u_t=\frac{1}{\sigma_a}\hat{\tilde\rho}_t .
\tag{F37}
\]

## 5. Exogenous Processes

中性技术增长：

\[
\hat\mu_{z,t}=\rho_{\mu_z}\hat\mu_{z,t-1}+\varepsilon_{\mu_z,t}.
\tag{F38}
\]

资本体现型技术增长：

\[
\hat\mu_{\Upsilon,t}=\rho_{\mu_\Upsilon}\hat\mu_{\Upsilon,t-1}+\varepsilon_{\mu_\Upsilon,t}.
\tag{F39}
\]

货币增长分解为货币政策成分和技术响应成分：

\[
\hat x_t=\hat x_{M,t}+\hat x_{z,t}+\hat x_{\Upsilon,t}.
\tag{F40}
\]

货币政策成分为：

\[
\hat x_{M,t}=\rho_{xM}\hat x_{M,t-1}+\varepsilon_{M,t}.
\tag{F41}
\]

对中性技术的政策响应是 ARMA(1,1)：

\[
\hat x_{z,t}=\rho_{xz}\hat x_{z,t-1}+c_z\varepsilon_{\mu_z,t}
+c_z^p\varepsilon_{\mu_z,t-1}.
\tag{F42}
\]

对体现型技术的政策响应是 ARMA(1,1)：

\[
\hat x_{\Upsilon,t}=\rho_{x\Upsilon}\hat x_{\Upsilon,t-1}
+c_\Upsilon\varepsilon_{\mu_\Upsilon,t}
+c_\Upsilon^p\varepsilon_{\mu_\Upsilon,t-1}.
\tag{F43}
\]

MMB 实现还包含一个原始代码未考虑的额外暂时性中性技术冲击：

\[
\epsilon_t=\rho_\epsilon\epsilon_{t-1}+\sigma_\epsilon\varepsilon_{\epsilon,t}.
\tag{F44}
\]

## 6. Steady-State Solution

由于 `US_ACELswm` 以 `model(linear)` 实现，动态方程写成围绕平衡增长稳态的偏离形式；带帽变量的线性化稳态为零。用于缩放的非随机水平为：

\[
\mu_{z^{\ast}}=\mu_\Upsilon^{\alpha/(1-\alpha)}\mu_z .
\tag{F45}
\]

\[
\tilde\rho=\frac{\mu_\Upsilon\mu_{z^{\ast}}}{\beta}-(1-\delta),
\qquad
\pi=\frac{x}{\mu_{z^{\ast}}},
\qquad
R=\frac{\pi\mu_{z^{\ast}}}{\beta}.
\tag{F46}
\]

货币服务校准：

\[
\eta'=\frac{R-1}{V^2},
\qquad
\varphi_\eta=\frac{1}{4\epsilon(R-1)}-2,
\qquad
q=\frac{c}{V}.
\tag{F47}
\]

边际成本和要素比例：

\[
s=\frac{1}{\lambda_f},
\qquad
R_\nu=\nu R+1-\nu,
\qquad
\tilde w=\frac{1-\alpha}{R_\nu}s
\left(\frac{\tilde\rho}{\alpha s}\right)^{\alpha/(\alpha-1)}.
\tag{F48}
\]

\[
\frac{h}{\bar k}
=\left[
\frac{\tilde\rho}
{\alpha s(\mu_{z^{\ast}}\mu_\Upsilon)^{1-\alpha}}
\right]^{1/(1-\alpha)} .
\tag{F49}
\]

其余稳态水平由家庭劳动条件、消费、货币、生产、固定成本零利润条件、投资和边际效用递归求解：

\[
\bar k=
\left[
\frac{(1+\eta)\tilde w}{\psi_L(h/\bar k)^{\sigma_L}}
\frac{\mu_{z^{\ast}}-b\beta}{\lambda_w(\mu_{z^{\ast}}-b)(1+\eta+\eta'V)}
\bigg/
\left(
\frac{1}{\lambda_f}(\mu_{z^{\ast}}\mu_\Upsilon)^{-\alpha}(h/\bar k)^{1-\alpha}
-\left[1-\frac{1-\delta}{\mu_\Upsilon\mu_{z^{\ast}}}\right]
\right)
\right]^{1/(1+\sigma_L)} .
\tag{F50}
\]

\[
h=(h/\bar k)\bar k,\qquad
c=\bar k^{-\sigma_L}\frac{\tilde w}{\psi_L(h/\bar k)^{\sigma_L}}
\frac{\mu_{z^{\ast}}-\beta b}{\lambda_w(\mu_{z^{\ast}}-b)(1+\eta+\eta'V)} .
\tag{F51}
\]

\[
m=\frac{\nu\tilde w h+q}{x},
\qquad
\tilde y=\frac{\tilde\rho\bar k}{\mu_\Upsilon\mu_{z^{\ast}}}+\tilde w R_\nu h,
\qquad
\phi=\tilde y(\lambda_f-1).
\tag{F52}
\]

\[
i=\left(1-\frac{1-\delta}{\mu_\Upsilon\mu_{z^{\ast}}}\right)\bar k,
\qquad
\lambda_{z^{\ast}}=
\frac{\mu_{z^{\ast}}-b\beta}{\mu_{z^{\ast}}c-bc}
\frac{1}{1+\eta+\eta'V}.
\tag{F53}
\]

以上稳态值和公式经过实现交叉检查，但在技术附录或原始复制包完成来源级核查前均标记为 `needs_review`。

## 7. Timing & Form Conventions

- 模型是线性偏离系统：所有带帽变量以及 MMB 变量如 `c_t`、`pi_t`、`i_t`、`mu_z_t` 都是围绕平衡增长稳态的偏离。
- 资本存量在期内预定。实现变量 `kbar_t1` 表示下一期可用的物质资本存量；生产方程使用预定资本存量。
- 实现中的时序使用 `c_tlead`、`c_tpred`、`i_tlead`、`i_tpred` 等辅助变量表示超前变量和在货币政策冲击前决定的变量。这也是 MMB 文件警告该文件的技术冲击 IRF 不可靠的关键。
- 技术冲击在实际决策前被观察到；货币冲击在价格/工资和实际配置决策后到达。
- MMB 实现同时存在粘性价格块和灵活价格配置块。灵活价格变量使用 `f` 后缀。
- 运行时验证：未执行。未运行 Dynare。

## 8. Variable & Parameter Reference Table

### 内生变量

| 类别 | 符号 / ASCII | 含义 | 主要方程 |
|---|---|---|---|
| 内生 | `c_t` | 消费偏离 | (F24), (F34) |
| 内生 | `wtilde_t` | 缩放实际工资 | (F26), (F22) |
| 内生 | `lambda_zstar_t` | 缩放边际效用 | (F24), (F25) |
| 内生 | `m_t` | 货币余额 | (F35) |
| 内生 | `pi_t` | 通胀 | (F21) |
| 内生 | `x_t` | 货币增长 | (F40) |
| 内生 | `s_t` | 平均边际成本 | (F21), (F22) |
| 内生 | `i_t` | 投资 | (F18), (F20), (F34) |
| 内生 | `h_t` | 工时 | (F26), (F34), (F36) |
| 内生 | `kbar_t1` | 下一期物质资本存量 | (F20), (F36) |
| 内生 | `q_t` | 实际现金余额 / 流动性 | (F23), (F34) |
| 内生 | `ytilde_t` | 缩放产出 | (F19), (F36) |
| 内生 | `R_t` | 名义/货币回报偏离 | (F23), (F25) |
| 内生 | `mutilde_t` | 已安装资本影子价值 | (F17), (F18) |
| 内生 | `rhotilde_t` | 缩放资本租金回报 | (F17), (F19), (F37) |
| 内生 | `u_t` | 资本利用率 | (F30), (F37) |
| 内生 | `*_tlead`, `*_tpred` | 超前和预定决策的时序辅助变量 | (F17)-(F37) |
| 内生 | `cf_t`, `pif_t`, `xf_t`, etc. | 灵活价格配置对应变量 | 灵活价格实现块 |
| 内生 | `x_M_t`, `eps_M_t` | 货币政策状态和创新代理 | (F41) |
| 内生 | `mu_z_t`, `eps_muz_t` | 中性技术增长状态和创新代理 | (F38) |
| 内生 | `x_z_t` | 对中性技术的政策响应 | (F42) |
| 内生 | `mu_ups_t`, `eps_muups_t` | 体现型技术增长状态和创新代理 | (F39) |
| 内生 | `x_ups_t` | 对体现型技术的政策响应 | (F43) |
| 内生 | `epsilon_t` | MMB 文件中的暂时性中性技术状态 | (F44) |

### 外生冲击

| ASCII | 含义 |
|---|---|
| `epsilon_M_` | 货币政策创新 |
| `eps_muz_` | 中性技术增长创新 |
| `eps_muups_` | 体现型技术增长创新 |
| `epsilon_t_` | MMB 实现加入的暂时性中性技术创新 |

### 参数

| ASCII | 含义 |
|---|---|
| `alpha` | 资本份额 |
| `b` | 习惯参数 |
| `beta` | 折现因子 |
| `delta` | 折旧率 |
| `epsilon` | 货币需求利率半弹性目标 |
| `eta`, `eta_pr`, `sig_eta` | 交易成本水平/斜率/曲率对象 |
| `lambda_f` | 中间品加成参数 |
| `lambda_w` | 工资加成参数 |
| `mu_ups`, `mu_z`, `mu_zstar` | 体现型、中性和复合趋势增长 |
| `nu` | 周转资本/成本渠道参数；MMB 变体将其设为接近零 |
| `psi_L`, `sigma_L` | 劳动负效用水平和曲率 |
| `x` | 稳态货币增长 |
| `xi_w`, `xif_w`, `xif_p` | 工资和灵活价格 Calvo 参数 |
| `V` | 稳态速度 |
| `kappa` | 投资调整成本曲率 |
| `sigma_a` | 利用率成本曲率 |
| `gamma` | 简化通胀斜率 |
| `squig` | 价格指数化/通胀滞后系数 |
| `rho_M`, `theta_M` | 货币冲击持续性/MA 项 |
| `rho_muz`, `theta_muz`, `c_z`, `cp_z`, `rho_xz` | 中性冲击和政策响应参数 |
| `rho_muups`, `theta_muups`, `c_ups`, `cp_ups`, `rho_xups` | 体现型冲击和政策响应参数 |
| `rho_epsilon` | 额外暂时性技术冲击的持续性 |
| `ETA1`-`ETA10`, `ETA1f`-`ETA10f` | 工资方程系数组 |
