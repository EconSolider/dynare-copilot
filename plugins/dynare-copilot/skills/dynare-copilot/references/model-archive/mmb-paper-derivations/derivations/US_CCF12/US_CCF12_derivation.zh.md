# US_CCF12 - 推导（最优化问题 + 一阶条件）

> 归档条目状态：`needs_review`。这个一稿推导依据 Chen, Curdia, and Ferrero (2012) 的论文 Markdown。论文正文说明，归一化非线性方程、稳态和完整对数线性系统位于在线 Technical Appendix，但当前 MinerU 来源不包含该附录。

## 1. Model Overview

- **模型 ID**：`US_CCF12`
- **论文**：Han Chen, Vasco Curdia, and Andrea Ferrero (2012), "The Macroeconomic Effects of Large-scale Asset Purchase Programmes", *The Economic Journal*, 122, F289-F315。
- **DOI**：`10.1111/j.1468-0297.2012.02549.x`
- **核心机制**：一个估计的美国中等规模新凯恩斯 DSGE 模型，包含名义和实际刚性，并加入短期与长期政府债券市场分割。LSAP 被建模为私人部门持有长期债务市值规则的冲击。
- **主体**：非受限家庭、受限家庭、劳动中介、资本生产者、最终品生产者、垄断竞争中间品企业、金融中介以及政府/中央银行。
- **形式**：围绕平衡增长稳态的一阶对数线性近似，变量按生产率归一化。MMB 实现使用 `model(linear)`。
- **运行验证**：未执行。`.mod` 文件仅作为 `implementation_cross_check`；未运行 Dynare。

## 2. Optimization Problems

### 2.1 家庭

每类家庭 $j \in \{u,r\}$ 在消费和差异化劳动上最大化预期效用：

$$
E_t \sum_{s=0}^{\infty} \beta_j^s b_{t+s}^j
\left[
\frac{1}{1-\sigma_j}
\left(
\frac{C_{t+s}^j}{Z_{t+s}} - h\frac{C_{t+s-1}^j}{Z_{t+s-1}}
\right)^{1-\sigma_j}
-
\frac{\varphi_{t+s}^j [L_{t+s}^j(i)]^{1+\nu}}{1+\nu}
\right].
$$

非受限家庭可交易一期债券和长期永续债，但在长期债券上支付交易成本：

$$
P_t C_t^u + B_t^u + (1+\zeta_t)P_{L,t}B_t^{L,u}
\leq R_{t-1}B_{t-1}^u + \sum_{s=1}^{\infty}\kappa^{s-1}B_{t-s}^{L,u}
+ W_t^u(i)L_t^u(i) + \mathcal{P}_t+\mathcal{P}_t^{cp}+\mathcal{P}_t^{fi}-T_t^u .
$$

受限家庭只交易长期证券，且不支付交易成本：

$$
P_t C_t^r + P_{L,t}B_t^{L,r}
\leq \sum_{s=1}^{\infty}\kappa^{s-1}B_{t-s}^{L,r}
+ W_t^r(i)L_t^r(i) + \mathcal{P}_t+\mathcal{P}_t^{cp}+\mathcal{P}_t^{fi}-T_t^r .
$$

### 2.2 工资设定者

家庭是差异化劳动的垄断供应者。类型 $j$ 的家庭若在 $t$ 期能够重设工资，则选择 $\tilde W_t^j(i)$，在劳动需求和 Calvo 工资不调整约束下，最大化贴现工资收入减劳动负效用。

### 2.3 资本生产者

资本生产者选择投资 $I_t$、利用率 $u_t$ 和资本服务，以最大化预期贴现股利：

$$
E_t\sum_{s=0}^{\infty}\Xi_{t+s}^p
\left[
R_{t+s}^k u_{t+s}\bar K_{t+s-1}
- P_{t+s}a(u_{t+s})\bar K_{t+s-1}
- P_{t+s}I_{t+s}
\right],
$$

并满足有效资本和资本积累：

$$
K_t = u_t \bar K_{t-1},
\qquad
\bar K_t = (1-\delta)\bar K_{t-1}
+ \mu_t\left[1-S\left(\frac{I_t}{I_{t-1}}\right)\right]I_t .
$$

### 2.4 最终品与中间品企业

最终品企业聚合差异化产品：

$$
Y_t = \left[\int_0^1 Y_t(f)^{1/(1+\lambda_f)}\,df\right]^{1+\lambda_f}.
$$

中间品企业租用资本和劳动进行生产：

$$
Y_t(f)=K_t(f)^\alpha [Z_t L_t(f)]^{1-\alpha}.
$$

它们在 Calvo 价格刚性和稳态通胀指数化下设定价格，选择 $\tilde P_t(f)$，在最终品需求约束下最大化预期贴现利润。

## 3. First-Order Conditions

论文正文给出若干非线性最优条件，并说明完整归一化与对数线性系统位于在线 Technical Appendix。除非显式标记 `needs_review`，下面方程均来自论文正文。

- **(F1) 非受限家庭短债欧拉方程**：

$$
1 = \beta_u E_t\left[
e^{-\gamma-z_{t+1}}\frac{\Xi_{t+1}^u}{\Xi_t^u}
\frac{R_t}{\Pi_{t+1}}
\right].
$$

- **(F2) 非受限家庭长债欧拉方程**：

$$
1+\zeta_t =
\beta_u E_t\left[
e^{-\gamma-z_{t+1}}\frac{\Xi_{t+1}^u}{\Xi_t^u}
\frac{P_{L,t+1}}{P_{L,t}}\frac{R_{L,t+1}}{\Pi_{t+1}}
\right].
$$

- **(F3) 受限家庭长债欧拉方程**：

$$
1 =
\beta_r E_t\left[
e^{-\gamma-z_{t+1}}\frac{\Xi_{t+1}^r}{\Xi_t^r}
\frac{P_{L,t+1}}{P_{L,t}}\frac{R_{L,t+1}}{\Pi_{t+1}}
\right].
$$

- **(F4) 差异化劳动需求**：

$$
L_t(i)=\left[\frac{W_t(i)}{W_t}\right]^{-(1+\lambda_w)/\lambda_w}L_t .
$$

- **(F5) 工资指数**：

$$
W_t=\left[\int_0^1 W_t(i)^{-1/\lambda_w}\,di\right]^{-\lambda_w}.
$$

- **(F6) 有效资本服务**：

$$
K_t = u_t\bar K_{t-1}.
$$

- **(F7) 资本积累**：

$$
\bar K_t=(1-\delta)\bar K_{t-1}
+\mu_t\left[1-S\left(\frac{I_t}{I_{t-1}}\right)\right]I_t .
$$

- **(F8) 最终品企业对中间品 $f$ 的需求**：

$$
Y_t(f)=\left[\frac{P_t(f)}{P_t}\right]^{-(1+\lambda_f)/\lambda_f}Y_t .
$$

- **(F9) 总价格指数**：

$$
P_t=\left[\int_0^1 P_t(f)^{-1/\lambda_f}\,df\right]^{-\lambda_f}.
$$

- **(F10) 中间品生产函数**：

$$
Y_t(f)=K_t(f)^\alpha [Z_t L_t(f)]^{1-\alpha}.
$$

- **(F11) 实际边际成本**：

$$
MC_t=\frac{(R_t^k)^\alpha W_t^{1-\alpha}}
{\alpha^\alpha(1-\alpha)^{1-\alpha}Z_t^{1-\alpha}}.
$$

- **(F12) Calvo 价格设定 FOC**（`needs_review`：论文正文给出优化问题；递归归一化 FOC 在缺失的在线附录中）：

$$
\tilde P_t(f)\ \text{solves}
\max E_t\sum_{s=0}^{\infty}\zeta_p^s\Xi_{t+s}^p
\left[\tilde P_t(f)\Pi^s-\lambda_{f,t+s}MC_{t+s}\right]Y_{t+s}(f).
$$

- **(F13) Calvo 工资设定 FOC**（`needs_review`：论文正文没有递归归一化 FOC）：

$$
\tilde W_t^j(i)\ \text{solves the Calvo wage problem for } j\in\{u,r\}
\text{ subject to labor demand and indexation by } \Pi e^\gamma .
$$

## 4. Market Clearing & Identities

- **(F14) 总资源约束**：

$$
Y_t=\omega_u C_t^u+\omega_r C_t^r+I_t+G_t+a(u_t)\bar K_{t-1}.
$$

- **(F15) 含永续债的政府预算约束**：

$$
B_t+P_{L,t}B_t^L
=R_{t-1,t}B_{t-1}+(1+\kappa P_{L,t})B_{t-1}^L+P_tG_t-T_t .
$$

- **(F16) 长期债务供给规则**：

$$
\frac{P_{L,t}B_t^L}{P_tZ_t}
=
\left(\frac{P_{L,t-1}B_{t-1}^L}{P_{t-1}Z_{t-1}}\right)^{\rho_B}
e^{\epsilon_{B,t}}.
$$

- **(F17) 财政盈余规则**：

$$
\frac{T_t}{P_tZ_t}-\frac{G_t}{Z_t}
=
\Phi
\left(\frac{P_{L,t-1}B_{t-1}^L}{P_{t-1}Z_{t-1}}\right)^{\phi_T}
e^{\epsilon_{T,t}}.
$$

- **(F18) 作为贴现交易成本的风险溢价**：

$$
\hat R_{L,t}-\hat R_{L,t}^{EH}
=
\frac{1}{D_L}\sum_{s=0}^{\infty}
\left(\frac{D_L-1}{D_L}\right)^s E_t\zeta_{t+s}.
$$

- **(F19) 交易成本函数**：

$$
\zeta_t \equiv
\zeta\left(\frac{P_{L,t}B_{z,t}^L}{B_{z,t}},\epsilon_{\zeta,t}\right).
$$

- **(F20) 货币政策规则**：

$$
\frac{R_t}{R}=
\left(\frac{R_{t-1}}{R}\right)^{\rho_m}
\left[
\left(\frac{\Pi_t}{\Pi}\right)^{\phi_\pi}
\left(\frac{Y_t/Y_{t-4}}{e^{4\gamma}}\right)^{\phi_y}
\right]^{1-\rho_m}
e^{\epsilon_{m,t}}.
$$

## 5. Exogenous Processes

- **(F21) 技术增长**：

$$
\log\left(\frac{Z_t}{Z_{t-1}}\right)
=(1-\rho_z)\gamma
+\rho_z\log\left(\frac{Z_{t-1}}{Z_{t-2}}\right)
+\epsilon_{z,t}.
$$

- **(F22) 投资专有技术冲击**：

$$
\log\mu_t = \rho_\mu\log\mu_{t-1}+\epsilon_{\mu,t}.
$$

- **(F23) 偏好和劳动供给冲击**：

$$
\log b_t^j=\rho_b\log b_{t-1}^j+\epsilon_{b^j,t},
\qquad
\log\varphi_t^j=\rho_\varphi\log\varphi_{t-1}^j+\epsilon_{\varphi^j,t}.
$$

- **(F24) 风险溢价、财政、货币、加成和债务创新**：

$$
\epsilon_{\zeta,t},\ \epsilon_{T,t},\ \epsilon_{m,t},\ \epsilon_{\lambda,t},\ \epsilon_{B,t}
\text{ enter the corresponding rules as innovations.}
$$

## 6. Steady-State Solution

来源说明，模型围绕一个稳态做一阶对数线性近似；在该稳态中，数量变量按生产率 $Z_t$ 归一化，相对价格相对于 $P_t$ 表示。来源同时说明在线附录刻画了稳态解。

论文正文和实现交叉检查中可得的一稿稳态信息：

- 平衡增长归一化使用 $C_t^j/Z_t$、$B_t/(P_tZ_t)$、$B_t^L/(P_tZ_t)$、$G_t/Z_t$ 以及相关实际量。
- 生产率增长稳态由 $\gamma$ 控制。
- 稳态通胀为 $\Pi$；论文表 2 报告了 $400\pi$ 的后验中位数。
- 长债现金流参数 $\kappa$ 校准为对应 30 个季度久期。
- 稳态风险溢价为正，交易成本水平 $\zeta>0$ 且斜率 $\zeta'>0$。
- MMB 实现从校准和后验参数推导 `betar`、`RL`、`kappa`、`Bz_SS`、`BzL_SS`、`BLMVz_SS`、`beta_av`、`rk_SS`、`Kz_SS`、`Iz_SS`、`Tz_SS`、`Czu_SS` 和 `Czr_SS`。这些公式仅记录为实现交叉检查证据。

`needs_review`：当前论文 Markdown 不包含在线 Appendix C 的完整解析稳态推导。除非补入或核对该附录/PDF 支持材料，否则本条目不应标记为 reviewed。

## 7. Timing & Form Conventions

- **形式**：线性化估计模型；MMB 实现使用 `model(linear)`。
- **归一化**：数量变量按生产率 $Z_t$ 去趋势。
- **资本时序**：$\bar K_t$ 是期末物理资本存量；当期有效资本服务使用 $K_t=u_t\bar K_{t-1}$。
- **债券**：短债是一期期限名义证券，在 $t+1$ 支付 $R_t$；长债是以 $P_{L,t}$ 购买、支付几何衰减息票的永续债。
- **市场分割时序**：非受限家庭同时定价短债和长债；受限家庭只定价长债。
- **LSAP 约定**：资产购买表示为私人部门持有长期债务市值规则的冲击。
- **实现交叉检查**：`.mod` 文件使用 `Kz(-1)`、`z(+1)`、`pi(+1)`、`rL(+1)` 和 `BLMVz(-1)` 等对数线性变量，符合预定资本和债务存量以及前瞻欧拉/定价方程。

## 8. Variable & Parameter Reference Table

| 类别 | 符号 / ASCII 名 | 含义 | 主要方程 |
|---|---|---|---|
| 内生 | $C_t^u$, `Czu` | 非受限消费，实现中按生产率归一化 | (F1), (F14) |
| 内生 | $C_t^r$, `Czr` | 受限消费，实现中按生产率归一化 | (F3), (F14) |
| 内生 | $\Xi_t^u,\Xi_t^r$, `Xiu`, `Xir` | 实际边际效用 | (F1)-(F3) |
| 内生 | $L_t$, `L` | 总劳动 | (F4), (F10) |
| 内生 | $W_t$, `wz` | 总实际工资 | (F5), (F11), (F13) |
| 内生 | $Y_t$, `Yz` | 产出 | (F8), (F10), (F14) |
| 内生 | $K_t$, `Kz_eff` | 有效资本服务 | (F6), (F10) |
| 内生 | $\bar K_t$, `Kz` | 期末资本存量 | (F7) |
| 内生 | $I_t$, `Iz` | 投资 | (F7), (F14) |
| 内生 | $u_t$, `u` | 资本利用率 | (F6), (F14) |
| 内生 | $MC_t$, `marc` | 实际边际成本 | (F11), (F12) |
| 内生 | $\Pi_t$, `pi` | 通胀 | (F20) |
| 内生 | $R_t$, `r` | 论文中的短期名义政策利率及实现中的线性变量 | (F1), (F20) |
| 内生 | $R_{L,t}$, `rL` | 长期收益率 | (F2), (F3), (F18) |
| 内生 | $B_t$, `Bz` | 归一化短期政府债务 | (F15), (F19) |
| 内生 | $B_t^L$, `BzL` | 归一化长期政府债务 | (F15), (F16), (F19) |
| 内生 | $P_{L,t}B_t^L/(P_tZ_t)$, `BLMVz` | 长期债务市值 | (F16), (F19) |
| 内生 | $T_t$, `Tz` | 税收或基本盈余组成部分 | (F17) |
| 内生 | $G_t$, `Gz` | 政府购买 | (F14), (F17) |
| 内生 | $\zeta_t$, `zeta_h` | 长债交易成本/风险溢价组成部分 | (F2), (F18), (F19) |
| 外生 | $\epsilon_{z,t}$, `eps_z` | 技术增长创新 | (F21) |
| 外生 | $\epsilon_{\mu,t}$, `eps_mu` | 投资专有技术创新 | (F22) |
| 外生 | $\epsilon_{b^u,t},\epsilon_{b^r,t}$, `eps_bu`, `eps_br` | 偏好创新 | (F23) |
| 外生 | $\epsilon_{\varphi,t}$, `eps_phi` | 劳动供给偏好创新 | (F23) |
| 外生 | $\epsilon_{\lambda,t}$, `eps_lambda` | 加成创新 | (F24) |
| 外生 | $\epsilon_{\zeta,t}$, `eps_zeta` | 风险溢价创新 | (F19), (F24) |
| 外生 | $\epsilon_{m,t}$, `eps_m` | 货币政策创新 | (F20) |
| 外生 | $\epsilon_{T,t}$, `eps_T` | 财政规则创新 | (F17) |
| 外生 | $\epsilon_{B,t}$, `eps_B` | 长债供给/LSAP 创新 | (F16) |
| 参数 | $\beta_u,\beta_r$ | 非受限/受限家庭贴现因子 | (F1)-(F3) |
| 参数 | $\omega_u,\omega_r$ | 人口份额；$\omega_r=1-\omega_u$ | (F14) |
| 参数 | $\sigma_u,\sigma_r,h,\nu$ | 偏好曲率、习惯、劳动弹性倒数 | 第 2 节 |
| 参数 | $\lambda_w,\lambda_f$ | 工资和价格稳态加成 | (F4), (F8), (F11) |
| 参数 | $\zeta_w,\zeta_p$ | 工资和价格 Calvo 不调整概率 | (F12), (F13) |
| 参数 | $\alpha,\delta,\gamma$ | 资本份额、折旧率、趋势增长 | (F7), (F10), (F21) |
| 参数 | $\kappa,D_L$ | 长债息票衰减和久期 | (F2), (F18) |
| 参数 | $\zeta,\zeta'$ | 稳态交易成本和风险溢价弹性 | (F18), (F19) |
| 参数 | $\rho_m,\phi_\pi,\phi_y,\rho_B,\phi_T$ | 政策规则参数 | (F16), (F17), (F20) |
| 参数 | $\rho_z,\rho_\mu,\rho_b,\rho_\varphi$ | 冲击持续性参数 | (F21)-(F23) |
