# US_ACELt 推导

> Altig、Christiano、Eichenbaum 和 Linde (2005)《Firm-Specific Capital, Nominal Rigidities and the Business Cycle》的有来源支撑的一阶档案条目。状态：`needs_review`。
> 运行验证：未执行。未运行 Dynare。

## 1. Model Overview

- **模型 ID**：`US_ACELt`。
- **论文**：David Altig, Lawrence J. Christiano, Martin Eichenbaum, and Jesper Linde (2005), "Firm-Specific Capital, Nominal Rigidities and the Business Cycle," CEPR Discussion Paper 4858。`model_index.csv` 记录的 DOI：`10.3386/w11034`。
- **方程来源**：`raw/mmb_mineru/runs/us_acelm_us_acelswm_us_acelswt_us_acelt__firm_specific_capital_nominal_rigidities__e0fac58f/full.md`。
- **经济体和变体**：估计的美国中等规模 DSGE 模型，包含中性技术、资本体现型技术、价格粘性、工资粘性、习惯形成、可变资本利用率、货币需求，以及工资账单的营运资本融资。MMB 的 `US_ACELt` 实现是技术冲击时序变体：实现注释说明技术冲击先实现，然后主体决策，最后货币政策冲击实现。
- **核心主体**：最终品聚合者、垄断竞争中间品厂商、消费并设定差异化工资且持有货币和资本的家庭、向企业提供工资账单贷款的金融中介、政府和货币当局。
- **形式**：MMB 实现为 `model(linear)`。论文先给出增长经济的非线性结构，再围绕非随机平衡增长路径估计线性化均衡动态。本档案记录论文侧结构，并把实现层面的线性均衡方程作为交叉核对；OCR 敏感公式标为 `needs_review`。

## 2. Optimization Problems

### 最终品厂商

竞争性最终品厂商聚合差异化中间品：

$$
Y_t=\left[\int_0^1 y_t(i)^{1/\lambda_f}\,di\right]^{\lambda_f}.
$$

它在该聚合技术约束下选择中间投入以最小化成本。

### 中间品厂商

在同质资本表述中，中间品厂商 \(i\) 使用资本服务和劳动生产：

$$
y_t(i)=K_t(i)^\alpha\left(z_t h_t(i)\right)^{1-\alpha}-\phi z_t^{\ast},
\qquad
z_t^{\ast}=\Upsilon_t^{\alpha/(1-\alpha)}z_t.
$$

厂商在竞争性要素市场租用资本和劳动，并必须按总利率 \(R_t\) 预先融资工资账单。价格设定服从 Calvo 摩擦，不能重优化价格的厂商按下式指数化：

$$
P_t(i)=\pi_{t-1}P_{t-1}(i).
$$

名义价格设定目标是销售收入减去含工资融资成本和资本租金成本后的预期贴现值：

$$
E_t\sum_{j=0}^{\infty}\beta^j v_{t+j}
\left[P_{t+j}(i)y_{t+j}(i)-P_{t+j}\left(w_{t+j}R_{t+j}h_{t+j}(i)+r_{t+j}^kK_{t+j}(i)\right)\right].
$$

在厂商专有资本变体中，每个中间品厂商拥有期初既定资本，并选择厂商层面的投资和利用率：

$$
\bar K_{t+1}(i)=(1-\delta)\bar K_t(i)+\left[1-S\left(\frac{I_t(i)}{I_{t-1}(i)}\right)\right]I_t(i).
$$

其现金流目标扣除含营运资本利息的劳动成本以及投资和资本利用成本：

$$
E_t\sum_{j=0}^{\infty}\beta^jv_{t+j}
\left\{P_{t+j}(i)y_{t+j}(i)-P_{t+j}R_{t+j}w_{t+j}h_{t+j}(i)
-P_{t+j}\Upsilon_{t+j}^{-1}\left[I_{t+j}(i)+a(u_{t+j}(i))\bar K_{t+j}(i)\right]\right\}.
$$

### 家庭

家庭 \(j\) 对带习惯的消费和劳动厌恶有偏好：

$$
E_t^j\sum_{\ell=0}^{\infty}\beta^{\ell-t}
\left[\log(C_{t+\ell}-bC_{t+\ell-1})-\psi_L\frac{h_{j,t+\ell}^2}{2}\right].
$$

家庭把期初货币配置为存款和交易现金，供应资本服务，投资实物资本，接收利润，并在 Calvo 工资粘性下设定工资。其资产演化为：

$$
\begin{aligned}
M_{t+1}={}&R_t\left[M_t-Q_t+(x_t-1)M_t^a\right]+A_{j,t}+Q_t+W_{j,t}h_{j,t}\\
&+P_tr_t^ku_t\bar K_t+D_t-(1+\eta(V_t))P_tC_t
-P_t\Upsilon_t^{-1}\left(I_t+a(u_t)\bar K_t\right).
\end{aligned}
$$

交易速度为：

$$
V_t=\frac{P_tC_t}{Q_t}.
$$

资本服务和实物资本积累为：

$$
K_t=u_t\bar K_t,\qquad
\bar K_{t+1}=(1-\delta)\bar K_t+\left[1-S\left(\frac{I_t}{I_{t-1}}\right)\right]I_t.
$$

### 工资设定

差异化劳动服务按下式聚合：

$$
H_t=\left[\int_0^1 h_{j,t}^{1/\lambda_w}\,dj\right]^{\lambda_w}.
$$

对家庭 \(j\) 劳动的需求为：

$$
h_{j,t}=\left(\frac{W_t}{W_{j,t}}\right)^{\lambda_w/(\lambda_w-1)}H_t.
$$

家庭以概率 \(1-\xi_w\) 重优化工资；否则：

$$
W_{j,t}=\pi_{t-1}\mu_{z^{\ast}}W_{j,t-1}.
$$

## 3. First-Order Conditions

论文用围绕非随机平衡增长路径的线性近似表示均衡。以下编号条件只用 MMB `US_ACELt` 实现作为技术附录方程骨架和变量命名的 `implementation_cross_check`；它们不被当作论文侧原始数学来源。

- **(F1) 资本欧拉方程，粘性价格块，needs_review**：

$$
\lambda_{z^{\ast},t+1}+\frac{1-\delta}{\tilde\rho+1-\delta}\tilde\mu_{t+1}
+\frac{\tilde\rho}{\tilde\rho+1-\delta}\tilde\rho_{t+1}
-\lambda_{z^{\ast},t}-\tilde\mu_t
=\mu_{z,t+1}+\frac{1}{1-\alpha}\mu_{\Upsilon,t+1}.
$$

- **(F2) 投资欧拉方程，粘性价格块，needs_review**：

$$
-\beta\kappa(\mu_{z^{\ast}}\mu_\Upsilon)^2 i_{t+1}-\tilde\mu_t
+\kappa(\mu_{z^{\ast}}\mu_\Upsilon)^2(1+\beta)i_t
-\kappa(\mu_{z^{\ast}}\mu_\Upsilon)^2i_{t-1}
=\beta\kappa(\mu_{z^{\ast}}\mu_\Upsilon)^2\left(\mu_{z,t+1}+\frac{\mu_{\Upsilon,t+1}}{1-\alpha}\right)
-\kappa(\mu_{z^{\ast}}\mu_\Upsilon)^2\left(\mu_{z,t}+\frac{\mu_{\Upsilon,t}}{1-\alpha}\right).
$$

- **(F3) 资本影子租金，粘性价格块，needs_review**：

$$
\tilde w_t+\frac{1}{1-\alpha}\frac{\tilde y}{\tilde y+\phi}\tilde y_t
+\frac{\nu R}{\nu R+1-\nu}R_t-\tilde\rho_t-\frac{1}{1-\alpha}u_t
-\frac{1}{1-\alpha}\bar k_{t-1}
=-\frac{1}{1-\alpha}\mu_{z,t}-\frac{1}{(1-\alpha)^2}\mu_{\Upsilon,t}
+\frac{1}{1-\alpha}\epsilon_t.
$$

- **(F4) 资本演化，粘性价格块**：

$$
(\mu_{z^{\ast}}\mu_\Upsilon-(1-\delta))i_t-\mu_\Upsilon\mu_{z^{\ast}}\bar k_t
+(1-\delta)\bar k_{t-1}
=(1-\delta)\mu_{z,t}+\frac{1-\delta}{1-\alpha}\mu_{\Upsilon,t}.
$$

- **(F5) 带约化斜率 \(\gamma\) 的通胀方程**：

$$
\beta\pi_{t+1}-(1+\beta\varsigma)\pi_t+\gamma s_t=-\varsigma\pi_{t-1}.
$$

- **(F6) 边际成本方程，粘性价格块，needs_review**：

$$
\tilde w_t-s_t+\frac{\alpha}{1-\alpha}\frac{\tilde y}{\tilde y+\phi}\tilde y_t
+\frac{\nu R}{\nu R+1-\nu}R_t-\frac{\alpha}{1-\alpha}u_t
-\frac{\alpha}{1-\alpha}\bar k_{t-1}
=-\frac{\alpha}{1-\alpha}\mu_{z,t}-\frac{\alpha}{(1-\alpha)^2}\mu_{\Upsilon,t}
+\frac{1}{1-\alpha}\epsilon_t.
$$

- **(F7) 货币需求**：

$$
c_t-q_t=\frac{R}{R-1}\frac{1}{2+\sigma_\eta}R_t.
$$

- **(F8) 带习惯和流动性服务的消费欧拉方程，needs_review**：

$$
\begin{aligned}
&-\beta b\left(\frac{1}{\mu_{z^{\ast}}c-bc}\right)^2\mu_{z^{\ast}}c\,c_{t+1}
+A_c c_t+\lambda_{z^{\ast}}(1+\eta+\eta'V)\lambda_{z^{\ast},t}\\
&-\lambda_{z^{\ast}}(2+\sigma_\eta)\eta'V q_t
-\left(\frac{1}{c(1-b/\mu_{z^{\ast}})}\right)^2\frac{bc}{\mu_{z^{\ast}}}c_{t-1}\\
&=\beta b\left(\frac{1}{\mu_{z^{\ast}}c-bc}\right)^2\mu_{z^{\ast}}c
\left(\mu_{z,t+1}+\frac{\alpha}{1-\alpha}\mu_{\Upsilon,t+1}\right)
-B_c\left(\mu_{z,t}+\frac{\alpha}{1-\alpha}\mu_{\Upsilon,t}\right).
\end{aligned}
$$

- **(F9) 货币基础一阶条件**：

$$
\lambda_{z^{\ast},t+1}-\pi_{t+1}+R_{t+1}-\lambda_{z^{\ast},t}
=\mu_{z,t+1}+\frac{\alpha}{1-\alpha}\mu_{\Upsilon,t+1}.
$$

- **(F10) 工资一阶条件，needs_review**：

$$
\eta_2\tilde w_{t+1}+\eta_5\pi_{t+1}
+\eta_1\tilde w_t+\eta_4\pi_t+\eta_6 h_t+\eta_7\lambda_{z^{\ast},t}
+\eta_0\tilde w_{t-1}+\bar\eta_3\pi_{t-1}
=-\eta_8\left(\mu_{z,t+1}+\frac{\alpha}{1-\alpha}\mu_{\Upsilon,t+1}\right)
-\eta_7^\mu\left(\mu_{z,t}+\frac{\alpha}{1-\alpha}\mu_{\Upsilon,t}\right).
$$

- **(F11) 资本利用率**：

$$
\frac{1}{\sigma_a}\tilde\rho_t=u_t.
$$

`US_ACELt` 中的弹性价格块用弹性价格变量 \((c_t^f,\tilde w_t^f,\lambda_{z^{\ast},t}^f,\ldots)\) 重复资本、投资、租金、资本积累、边际成本、货币需求、消费欧拉、货币基础、工资、生产和利用率条件。其价格块设定 \(s_t^f=0\)，货币增长过程固定为 \(x_t^f=0\)。这些重复方程用于定义实现中的自然产出和产出缺口，本档案在变量表中记录，而不作为额外论文侧 FOC 重新编号。

## 4. Market Clearing & Identities

- **(F12) 贷款市场出清**：

$$
W_tH_t=x_tM_t-Q_t.
$$

- **(F13) 资源约束，论文非线性形式**：

$$
(1+\eta(V_t))C_t+\Upsilon_t^{-1}\left[I_t+a(u_t)\bar K_t\right]\leq Y_t.
$$

- **(F14) 资源约束，实现线性形式，needs_review**：

$$
\begin{aligned}
&\left((1+\eta)c+\eta'c^2/q\right)c_t
+\left(1-\frac{1-\delta}{\mu_\Upsilon\mu_{z^{\ast}}}\right)\bar k\,i_t
-(\tilde y+\phi)(1-\alpha)h_t-\eta'c^2q^{-1}q_t\\
&+\left(\frac{\tilde\rho\bar k}{\mu_{z^{\ast}}\mu_\Upsilon}-(\tilde y+\phi)\alpha\right)u_t
-(\tilde y+\phi)\alpha\bar k_{t-1}
+(\tilde y+\phi)\alpha\mu_{z,t}
+\frac{(\tilde y+\phi)\alpha}{1-\alpha}\mu_{\Upsilon,t}
-(\tilde y+\phi)\epsilon_t=0.
\end{aligned}
$$

- **(F15) 货币市场出清，实现线性形式**：

$$
\tilde w_t-\frac{xm}{xm-q}m_t+h_t+\frac{q}{xm-q}q_t
=\frac{xm}{xm-q}x_t.
$$

- **(F16) 货币基础增长和货币余额的连接式**：

$$
-m_t-\pi_t+m_{t-1}+x_{t-1}
=\mu_{z,t}+\frac{\alpha}{1-\alpha}\mu_{\Upsilon,t}.
$$

- **(F17) 生产函数，实现线性形式，needs_review**：

$$
(\tilde y+\phi)(1-\alpha)h_t-\tilde y\,\tilde y_t
+\left((\tilde y+\phi)\alpha-\frac{\tilde\rho\bar k}{\mu_{z^{\ast}}\mu_\Upsilon}\right)u_t
+(\tilde y+\phi)\alpha\bar k_{t-1}
=(\tilde y+\phi)\alpha\mu_{z,t}
+\frac{(\tilde y+\phi)\alpha}{1-\alpha}\mu_{\Upsilon,t}
-(\tilde y+\phi)\epsilon_t.
$$

- **(F18) 最终品对中间品投入的需求**：

$$
\frac{y_t(i)}{Y_t}=\left(\frac{P_t}{P_t(i)}\right)^{\lambda_f/(\lambda_f-1)}.
$$

- **(F19) 价格指数**：

$$
P_t=\left[\int_0^1P_t(i)^{1/(1-\lambda_f)}\,di\right]^{1-\lambda_f}.
$$

- **(F20) 总工资指数**：

$$
W_t=\left[\int_0^1W_{j,t}^{1/(1-\lambda_w)}\,dj\right]^{1-\lambda_w}.
$$

- **(F21) Modelbase 利率规则，实现替换**：

$$
\begin{aligned}
interest_t={}&\sum_{\ell=1}^{4}a_\ell interest_{t-\ell}
+\sum_{\ell=0}^{4}b_\ell inflationq_{t-\ell}
+\sum_{\ell=1}^{4}b^f_\ell inflationq_{t+\ell}\\
&+\sum_{\ell=0}^{4}c_\ell outputgap_{t-\ell}
+\sum_{\ell=1}^{4}c^f_\ell outputgap_{t+\ell}
+\sum_{\ell=0}^{4}d_\ell output_{t-\ell}
+\sum_{\ell=1}^{4}d^f_\ell output_{t+\ell}
+\sigma_R\varepsilon^R_t.
\end{aligned}
$$

Modelbase 观测变量为：

$$
interest_t=4R_t,\quad inflationq_t=4\pi_t,\quad
inflation_t=\pi_t+\pi_{t-1}+\pi_{t-2}+\pi_{t-3},\quad
outputgap_t=\tilde y_t-\tilde y_t^f,\quad output_t=\tilde y_t.
$$

## 5. Exogenous Processes

- **(F22) 中性技术增长**：

$$
\hat\mu_{z,t}=\rho_{\mu_z}\hat\mu_{z,t-1}+\varepsilon_{\mu_z,t}.
$$

- **(F23) 资本体现型技术增长**：

$$
\hat\mu_{\Upsilon,t}=\rho_{\mu_\Upsilon}\hat\mu_{\Upsilon,t-1}+\varepsilon_{\mu_\Upsilon,t}.
$$

- **(F24) 平衡增长技术复合项**：

$$
\mu_{z^{\ast},t}=(\mu_{\Upsilon,t})^{\alpha/(1-\alpha)}\mu_{z,t}.
$$

- **(F25) 货币增长分解，论文形式**：

$$
\hat x_t=\hat x_{z,t}+\hat x_{\Upsilon,t}+\hat x_{M,t}.
$$

- **(F26) 货币政策冲击过程，论文形式**：

$$
\hat x_{M,t}=\rho_{xM}\hat x_{M,t-1}+\varepsilon_{M,t}.
$$

- **(F27) 货币对中性技术的响应，论文形式**：

$$
\hat x_{z,t}=\rho_{xz}\hat x_{z,t-1}+c_z\varepsilon_{z,t}+c_z^p\varepsilon_{z,t-1}.
$$

- **(F28) 货币对体现型技术的响应，论文形式**：

$$
\hat x_{\Upsilon,t}=\rho_{x\Upsilon}\hat x_{\Upsilon,t-1}
+c_{\Upsilon}\varepsilon_{\Upsilon,t}+c_{\Upsilon}^p\varepsilon_{\Upsilon,t-1}.
$$

- **(F29) MMB 实现中的额外暂时性技术冲击，implementation_cross_check**：

$$
\epsilon_t=\rho_\epsilon\epsilon_{t-1}+\sigma_\epsilon\varepsilon^\epsilon_t.
$$

## 6. Steady-State Solution

论文使用平衡增长路径。稳态变量省略时间下标。实现交叉核对采用以下稳态顺序；本次未做运行验证。

1. 设定校准的增长、偏好和技术参数 \(\alpha,\beta,\delta,b,\lambda_f,\lambda_w,\mu_\Upsilon,\mu_z,\nu,\psi_L,\sigma_L,x,V,\eta\)。
2. 计算平衡增长技术：

$$
\mu_{z^{\ast}}=\mu_\Upsilon^{\alpha/(1-\alpha)}\mu_z.
$$

3. 计算租金回报和名义利率：

$$
\tilde\rho=\frac{\mu_\Upsilon\mu_{z^{\ast}}}{\beta}-(1-\delta),\qquad
\pi=\frac{x}{\mu_{z^{\ast}}},\qquad
R=\frac{\pi\mu_{z^{\ast}}}{\beta}.
$$

4. 参数化交易成本：

$$
\eta'=\frac{R-1}{V^2},\qquad
\sigma_\eta=\frac{1}{4\epsilon(R-1)}-2.
$$

5. 计算边际成本和营运资本对象：

$$
s=\frac{1}{\lambda_f},\qquad
R_\nu=\nu R+1-\nu.
$$

6. 用实现公式计算稳态工资、资本小时比、资本、小时、消费、货币余额、产出、固定成本、投资和边际效用：

$$
\tilde w=\frac{1-\alpha}{R_\nu}s\left(\frac{\tilde\rho}{\alpha s}\right)^{\alpha/(\alpha-1)},
\qquad
\frac{h}{\bar k}=\left(\frac{\tilde\rho}{\alpha s(\mu_{z^{\ast}}\mu_\Upsilon)^{1-\alpha}}\right)^{1/(1-\alpha)}.
$$

7. 对共享水平，弹性价格稳态等于粘性价格稳态；在线性模型中弹性价格偏离为零。

\(c,\bar k,h,q,m,\tilde y,\phi,i,\lambda_{z^{\ast}}\) 的完整代数按 MMB 实现给出；在任何可运行提升之前，应与原始技术附录重新核对。运行验证记录为未执行。

## 7. Timing & Form Conventions

- **形式**：MMB 实现是 `model(linear)`。`c_t`、`pi_t`、`i_t`、`ytilde_t` 等变量是平稳化平衡增长表述中的偏离，不是非线性水平。
- **`US_ACELt` 的技术时序**：实现注释写明 "Technology shock, agents' decisions, monetary policy shock." 这也是 `US_ACELt` 适合中性和投资专有技术冲击、但不适合货币政策冲击的原因。
- **资本时序**：实物资本在期内预定。实现中 `kbar_t1(-1)` 进入生产、租金、边际成本和资源方程，而 `kbar_t1` 由资本积累方程决定。
- **厂商专有资本**：论文偏好的微观解释是每个中间品厂商拥有期初资本，并通过厂商层面投资逐步调整。
- **弹性价格对应项**：带 `f` 后缀的变量定义用于产出缺口构造的弹性价格配置。
- **政策规则**：MMB modelbase 文件用 modelbase 利率规则替换了论文的货币增长过程。这是实现替换，不是论文侧推导结果。

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII name | Meaning | Equation reference |
|---|---|---|---|
| Endogenous | `c_t`, `cf_t` | 粘性/弹性价格消费偏离 | (F8), (F13), flexible block |
| Endogenous | `wtilde_t`, `wtildef_t` | 缩放实际工资 | (F3), (F6), (F10), (F15) |
| Endogenous | `lambda_zstar_t`, `lambda_zstarf_t` | 由 \(z^{\ast}\) 缩放的边际效用/影子价值 | (F1), (F8), (F9) |
| Endogenous | `m_t`, `mf_t` | 货币余额 | (F15), (F16) |
| Endogenous | `pi_t`, `pif_t` | 通胀偏离 | (F5), (F9), (F16), (F21) |
| Endogenous | `x_t`, `xf_t` | 货币增长/政策过程 | (F16), (F25)-(F28) |
| Endogenous | `s_t`, `sf_t` | 边际成本 | (F5), (F6) |
| Endogenous | `i_t`, `if_t` | 投资偏离 | (F2), (F4), (F14) |
| Endogenous | `h_t`, `hf_t` | 工时 | (F10), (F14), (F15), (F17) |
| Endogenous | `kbar_t1`, `kbarf_t1` | 期末实物资本存量 | (F4), (F17) |
| Endogenous | `q_t`, `qf_t` | 真实交易余额/流动性变量 | (F7), (F8), (F15) |
| Endogenous | `ytilde_t`, `ytildef_t` | 产出偏离 | (F3), (F6), (F17), (F21) |
| Endogenous | `R_t`, `Rf_t` | 利率偏离 | (F3), (F7), (F9), (F21) |
| Endogenous | `mutilde_t`, `mutildef_t` | 已安装资本的影子价值 | (F1), (F2) |
| Endogenous | `rhotilde_t`, `rhotildef_t` | 资本租金回报 | (F1), (F3), (F11) |
| Endogenous | `u_t`, `uf_t` | 资本利用率 | (F3), (F6), (F11), (F14), (F17) |
| Endogenous | `x_M_t`, `x_z_t`, `x_ups_t` | 货币政策和技术响应的货币增长分量 | (F25)-(F28) |
| Endogenous | `eps_M_t`, `eps_muz_t`, `eps_muups_t` | 实现中的一期冲击状态 | (F22), (F23), (F26)-(F28) |
| Endogenous | `mu_z_t`, `mu_ups_t` | 中性和体现型技术增长偏离 | (F22), (F23) |
| Endogenous | `epsilon_t` | MMB 实现中的额外暂时性技术状态 | (F29) |
| Modelbase | `interest`, `inflation`, `inflationq`, `outputgap`, `output` | 观测/modelbase 变量 | (F21) |
| Exogenous | `epsilon_M_` | 货币政策创新 | (F26) |
| Exogenous | `eps_muz_` | 中性技术创新 | (F22), (F27) |
| Exogenous | `eps_muups_` | 资本体现型技术创新 | (F23), (F28) |
| Exogenous | `epsilon_t_` | MMB 实现中的暂时性技术创新 | (F29) |
| Parameter | `alpha`, `beta`, `delta`, `b`, `lambda_f`, `lambda_w` | 资本份额、贴现、折旧、习惯、商品和劳动加成 | (F1)-(F24) |
| Parameter | `mu_ups`, `mu_z`, `mu_zstar`, `x` | 平衡增长和货币增长稳态 | (F24), steady state |
| Parameter | `nu`, `psi_L`, `sigma_L`, `V`, `eta`, `eta_pr`, `sig_eta` | 营运资本、劳动、速度和交易成本参数 | (F7), (F8), (F10) |
| Parameter | `kappa`, `sigma_a`, `gamma`, `squig` | 投资调整成本、利用率曲率、Phillips 曲线斜率、价格指数化系数 | (F2), (F5), (F11) |
| Parameter | `rho_M`, `theta_M`, `rho_muz`, `theta_muz`, `rho_muups`, `theta_muups`, `rho_epsilon` | 冲击持久性和移动平均系数 | (F22), (F23), (F26)-(F29) |
| Parameter | `c_z`, `cp_z`, `rho_xz`, `c_ups`, `cp_ups`, `rho_xups` | 货币增长对技术冲击的响应 | (F27), (F28) |
| Parameter | `cofint*`, `std_r_` | 从 `policy_param.mat` 载入的 modelbase 利率规则系数 | (F21) |
