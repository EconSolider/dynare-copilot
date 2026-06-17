# US_FV15 - 推导（含随机波动的商业周期模型）

> `US_FV15` 的模型档案条目。状态：`needs_review`。未执行运行时验证；未运行 Dynare。

## 1. Model Overview

- **模型**：Fernandez-Villaverde, Guerron-Quintana, and Rubio-Ramirez (2015), "Estimating dynamic equilibrium models with stochastic volatility."
- **模型 ID**：`US_FV15`。
- **来源**：`raw/mmb_mineru/runs/us_fv15__estimating_dynamic_equilibrium_models_with_stochastic_volatility__ae6b2e5b/full.md`；DOI `10.1016/j.jeconom.2014.08.010`。
- **目的**：估计一个中等规模的美国商业周期经济，其中结构冲击具有随机波动，货币政策反应系数随时间漂移。
- **主体/模块**：具有习惯、货币效用、资本利用率、投资调整成本、差异化劳动和 Calvo 工资设定的家庭；具有 Calvo 价格设定的最终品和中间品企业；采用 Taylor 规则、政策冲击随机波动以及通胀/产出反应漂移的货币当局。
- **冲击**：偏好、劳动负效用、投资专有技术、中性技术和货币政策冲击具有时变波动率。政策规则反应系数也作为固定创新方差的结构冲击漂移。
- **形式**：经过平稳化重标度的非线性 DSGE 模型，论文用二阶近似求解。Rep-MMB 实现求解一阶 Dynare 表示，但此处仅作为 `implementation_cross_check`。

## 2. Optimization Problems

### 2.1 家庭

家庭 $j$ 选择消费 $c_{jt}$、实际货币余额 $m_{jt}/p_t$、债券持有、投资 $x_{jt}$、资本 $k_{jt}$、利用率 $u_{jt}$ 和工资设定，以最大化：

$$
E_0\sum_{t=0}^{\infty}\beta^t d_t
\left[
\log(c_{jt}-h c_{j,t-1})
+\nu\log\left(\frac{m_{jt}}{p_t}\right)
-\varphi_t\psi\frac{l_{jt}^{1+\vartheta}}{1+\vartheta}
\right].
$$

名义债券/货币预算约束为：

$$
c_{jt}+x_{jt}+\frac{m_{jt}}{p_t}+\frac{b_{j,t+1}}{p_t}
= w_{jt}l_{jt}
+\left(r_tu_{jt}-\mu_t^{-1}\Phi(u_{jt})\right)k_{j,t-1}
+\frac{m_{j,t-1}}{p_t}
+R_{t-1}\frac{b_{jt}}{p_t}
+T_t+F_t.
$$

资本演化为：

$$
k_{jt}=(1-\delta)k_{j,t-1}
+\mu_t\left[
1-\frac{\kappa}{2}\left(\frac{x_{jt}}{x_{j,t-1}}-\Lambda_x\right)^2
\right]x_{jt}.
$$

资本利用成本函数在平衡增长路径的 $u=1$ 附近为二次形式。OCR 在该函数附近存在乱码；涉及 $\Phi(u)$ 的规范化公式标为 `needs_review`。

家庭供给差异化劳动。竞争性劳动打包商形成总劳动需求：

$$
l_t^d=\left(\int_0^1 l_{jt}^{\frac{\eta-1}{\eta}}dj\right)^{\frac{\eta}{\eta-1}},
$$

家庭以 $1-\theta_w$ 的 Calvo 概率重新设定工资，未重新设定的工资用参数 $\chi_w$ 按滞后通胀指数化。

### 2.2 企业

竞争性最终品企业聚合中间品：

$$
y_t=\left(\int_0^1 y_{it}^{\frac{\varepsilon-1}{\varepsilon}}di\right)^{\frac{\varepsilon}{\varepsilon-1}}.
$$

中间品企业 $i$ 使用技术：

$$
y_{it}=A_t k_{i,t-1}^{\alpha}(l^d_{it})^{1-\alpha},
$$

以 $r_t$ 和 $w_t$ 租用资本与打包劳动，并在 Calvo 价格刚性下设定价格，重定价概率为 $1-\theta_p$，未重定价价格以 $\chi$ 指数化。

### 2.3 货币当局

货币当局按如下规则设定名义总利率：

$$
\frac{R_t}{R}
=\left(\frac{R_{t-1}}{R}\right)^{\gamma_R}
\left[
\left(\frac{\Pi_t}{\Pi}\right)^{\gamma_{\Pi}\gamma_{\Pi t}}
\left(
\frac{y_t^d/y_{t-1}^d}{\exp(\Lambda_{y^d})}
\right)^{\gamma_y\gamma_{yt}}
\right]^{1-\gamma_R}\xi_t.
$$

政策冲击 $\xi_t$ 具有随机波动，$\gamma_{\Pi t}$ 与 $\gamma_{yt}$ 随时间漂移。

## 3. First-Order Conditions

论文给出了家庭和企业问题，但把完整平稳化均衡系统放在附录中。下面编号方程是基于论文模型描述的一阶规范化均衡清单，并用 `.agents/skills/dynare-copilot/references/examples/US_FV15_rep.mod` 检查实现覆盖。依赖仅附录代数的条件仍为 `needs_review`。

- **(F1) 含习惯的边际效用**：

$$
\lambda_t
=d_t(c_t-hc_{t-1}\mu_{z,t}^{-1})^{-1}
-h\beta E_t\left[d_{t+1}(c_{t+1}\mu_{z,t+1}-hc_t)^{-1}\right].
$$

- **(F2) 债券欧拉方程**：

$$
\lambda_t
=\beta E_t\left[
\lambda_{t+1}\mu_{z,t+1}^{-1}\frac{R_t}{\Pi_{t+1}}
\right].
$$

- **(F3) 资本利用率 FOC**（由 OCR 规范化，`needs_review`）：

$$
r_t=\Phi'(u_t), \qquad
\Phi'(u_t)=\phi_1+\phi_2(u_t-1).
$$

- **(F4) 资本欧拉方程**：

$$
q_t=\beta E_t\left[
\frac{\lambda_{t+1}}{\lambda_t}\mu_{z,t+1}^{-1}\mu_{I,t+1}^{-1}
\left((1-\delta)q_{t+1}+r_{t+1}u_{t+1}-\Phi(u_{t+1})\right)
\right].
$$

- **(F5) 投资调整 FOC**：

$$
1=q_t\left[
1-\frac{\kappa}{2}\left(\frac{x_t}{x_{t-1}}\mu_{z,t}-\Lambda_x\right)^2
-\kappa\left(\frac{x_t}{x_{t-1}}\mu_{z,t}-\Lambda_x\right)\frac{x_t}{x_{t-1}}\mu_{z,t}
\right]
$$

$$
+\beta E_t\left[
q_{t+1}\frac{\lambda_{t+1}}{\lambda_t}\mu_{z,t+1}^{-1}
\kappa\left(\frac{x_{t+1}}{x_t}\mu_{z,t+1}-\Lambda_x\right)
\left(\frac{x_{t+1}}{x_t}\mu_{z,t+1}\right)^2
\right].
$$

- **(F6) 工资设定递归，边际收益侧**（`needs_review`，本地无附录代数规范化）：

$$
f_t=\frac{\eta-1}{\eta}w_t^{*\,1-\eta}\lambda_t w_t^\eta l_t^d
+\beta\theta_w E_t\left[
\left(\frac{\Pi_t^{\chi_w}}{\Pi_{t+1}}\right)^{1-\eta}
\left(\frac{w^*_{t+1}}{w^*_t}\mu_{z,t+1}\right)^{\eta-1}
f_{t+1}
\right].
$$

- **(F7) 工资设定递归，边际成本侧**（`needs_review`）：

$$
f_t=\psi d_t\varphi_t(\Pi^*_{w,t})^{-\eta(1+\vartheta)}(l_t^d)^{1+\vartheta}
+\beta\theta_w E_t\left[
\left(\frac{\Pi_t^{\chi_w}}{\Pi_{t+1}}\right)^{-\eta(1+\vartheta)}
\left(\frac{w^*_{t+1}}{w^*_t}\mu_{z,t+1}\right)^{\eta(1+\vartheta)}
f_{t+1}
\right].
$$

- **(F8) 价格设定递归 $g_1$**：

$$
g_{1t}=\lambda_t mc_t y_t^d
+\beta\theta_p E_t\left[
\left(\frac{\Pi_t^{\chi}}{\Pi_{t+1}}\right)^{-\varepsilon}g_{1,t+1}
\right].
$$

- **(F9) 价格设定递归 $g_2$**：

$$
g_{2t}=\lambda_t\Pi^*_t y_t^d
+\beta\theta_p E_t\left[
\left(\frac{\Pi_t^{\chi}}{\Pi_{t+1}}\right)^{1-\varepsilon}
\frac{\Pi^*_t}{\Pi^*_{t+1}}g_{2,t+1}
\right].
$$

- **(F10) 最优重定价条件**：

$$
\varepsilon g_{1t}=(\varepsilon-1)g_{2t}.
$$

- **(F11) 成本最小化投入比例**：

$$
\frac{u_t k_{t-1}}{l_t^d}
=\frac{\alpha}{1-\alpha}\frac{w_t}{r_t}\mu_{z,t}\mu_{I,t}.
$$

- **(F12) 实际边际成本**：

$$
mc_t=\left(\frac{1}{1-\alpha}\right)^{1-\alpha}
\left(\frac{1}{\alpha}\right)^{\alpha}
w_t^{1-\alpha}r_t^{\alpha}.
$$

- **(F13) 工资指数演化**：

$$
1=\theta_w\left(\frac{\Pi_{t-1}^{\chi_w}}{\Pi_t}\right)^{1-\eta}
\left(\frac{w_{t-1}}{w_t}\mu_{z,t}^{-1}\right)^{1-\eta}
+(1-\theta_w)(\Pi^*_{w,t})^{1-\eta}.
$$

- **(F14) 价格指数演化**：

$$
1=\theta_p\left(\frac{\Pi_{t-1}^{\chi}}{\Pi_t}\right)^{1-\varepsilon}
+(1-\theta_p)(\Pi^*_t)^{1-\varepsilon}.
$$

- **(F15) 含漂移系数的 Taylor 规则**：

$$
\frac{R_t}{R}
=\left(\frac{R_{t-1}}{R}\right)^{\gamma_R}
\left[
\left(\frac{\Pi_t}{\Pi}\right)^{\gamma_{\Pi}\gamma_{\Pi t}}
\left(\frac{(y_t^d/y_{t-1}^d)\mu_{z,t}}{\exp(\Lambda_{y^d})}\right)^{\gamma_y\gamma_{yt}}
\right]^{1-\gamma_R}
\exp(\varepsilon_{\xi t})^{\sigma_{\xi}\sigma_{\xi t}}.
$$

## 4. Market Clearing & Identities

- **(F16) 总需求/资源约束**：

$$
y_t^d=c_t+x_t
+\mu_{z,t}^{-1}\mu_{I,t}^{-1}\Phi(u_t)k_{t-1}.
$$

- **(F17) 含价格分散的总生产**：

$$
y_t^d=\frac{\mu_{A,t}\mu_{z,t}^{-1}(u_tk_{t-1})^{\alpha}(l_t^d)^{1-\alpha}-\Phi}{v^p_t}.
$$

- **(F18) 含工资分散的劳动加总**：

$$
l_t=v^w_t l_t^d.
$$

- **(F19) 价格分散**：

$$
v^p_t=\theta_p\left(\frac{\Pi_{t-1}^{\chi}}{\Pi_t}\right)^{-\varepsilon}v^p_{t-1}
+(1-\theta_p)(\Pi^*_t)^{-\varepsilon}.
$$

- **(F20) 工资分散**：

$$
v^w_t=\theta_w\left(\frac{w_{t-1}}{w_t}\mu_{z,t}^{-1}
\frac{\Pi_{t-1}^{\chi_w}}{\Pi_t}\right)^{-\eta}v^w_{t-1}
+(1-\theta_w)(\Pi^*_{w,t})^{-\eta}.
$$

- **(F21) 平稳变量下的资本积累**：

$$
k_{t+1}\mu_{z,t}\mu_{I,t}
=(1-\delta)k_t
+\mu_{z,t}\mu_{I,t}
\left[
1-\frac{\kappa}{2}\left(\frac{x_t}{x_{t-1}}\mu_{z,t}-\Lambda_x\right)^2
\right]x_t.
$$

- **(F22) 企业利润**：

$$
F_t=y_t^d-\frac{1}{1-\alpha}w_tl_t^d.
$$

- **(F23) 最优工资通胀定义**：

$$
\Pi^*_{w,t}=\frac{w^*_t}{w_t}.
$$

## 5. Exogenous Processes

- **(F24) 跨期偏好冲击**：

$$
\log d_t=\rho_d\log d_{t-1}+\sigma_d\sigma_{dt}\varepsilon_{dt}.
$$

- **(F25) 劳动负效用冲击**：

$$
\log\varphi_t=\rho_{\varphi}\log\varphi_{t-1}
+\sigma_{\varphi}\sigma_{\varphi t}\varepsilon_{\varphi t}.
$$

- **(F26) 投资专有技术增长**：

$$
\log\mu_{I,t}=\Lambda_{\mu}+\sigma_{\mu}\sigma_{\mu t}\varepsilon_{\mu t}.
$$

- **(F27) 中性技术增长**：

$$
\log\mu_{A,t}=\Lambda_A+\sigma_A\sigma_{At}\varepsilon_{At}.
$$

- **(F28) 复合增长率**：

$$
\mu_{z,t}=\mu_{A,t}^{1/(1-\alpha)}\mu_{I,t}^{\alpha/(1-\alpha)}.
$$

- **(F29) 偏好波动率过程**：

$$
\log\sigma_{dt}
=\rho_{\sigma_d}\log\sigma_{d,t-1}
+(1-\rho_{\sigma_d}^2)^{1/2}\eta_d u_{dt}.
$$

- **(F30) 劳动负效用波动率过程**：

$$
\log\sigma_{\varphi t}
=\rho_{\sigma_{\varphi}}\log\sigma_{\varphi,t-1}
+(1-\rho_{\sigma_{\varphi}}^2)^{1/2}\eta_{\varphi}u_{\varphi t}.
$$

- **(F31) 投资专有冲击波动率过程**：

$$
\log\sigma_{\mu t}
=\rho_{\sigma_{\mu}}\log\sigma_{\mu,t-1}
+(1-\rho_{\sigma_{\mu}}^2)^{1/2}\eta_{\mu}u_{\mu t}.
$$

- **(F32) 中性技术波动率过程**：

$$
\log\sigma_{At}
=\rho_{\sigma_A}\log\sigma_{A,t-1}
+(1-\rho_{\sigma_A}^2)^{1/2}\eta_Au_{At}.
$$

- **(F33) 货币政策波动率过程**：

$$
\log\sigma_{\xi t}
=\rho_{\sigma_{\xi}}\log\sigma_{\xi,t-1}
+(1-\rho_{\sigma_{\xi}}^2)^{1/2}\eta_{\xi}u_{\xi t}.
$$

- **(F34) 通胀反应漂移**：

$$
\log\gamma_{\Pi t}
=\rho_{\gamma_{\Pi}}\log\gamma_{\Pi,t-1}
+\sigma_{\pi}\varepsilon_{\pi t}.
$$

- **(F35) 产出增长反应漂移**：

$$
\log\gamma_{yt}
=\rho_{\gamma_y}\log\gamma_{y,t-1}
+\sigma_y\varepsilon_{yt}.
$$

- **(F36) 产出增长观测量**：

$$
y^g_t=\frac{(y_t^d/y_{t-1}^d)\mu_{z,t}}{\exp(\Lambda_{y^d})}.
$$

## 6. Steady-State Solution

论文用下列变量重标度：

$$
z_t=A_t^{1/(1-\alpha)}\mu_t^{\alpha/(1-\alpha)},\quad
\widetilde{k}_t=\frac{k_t}{z_t\mu_t},\quad
\widetilde{c}_t=\frac{c_t}{z_t},\quad
\widetilde{x}_t=\frac{x_t}{z_t},\quad
\widetilde{y}_t=\frac{y_t}{z_t},\quad
\widetilde{w}_t=\frac{w_t}{z_t},\quad
\widetilde{r}_t=\mu_t r_t.
$$

在平衡增长的平稳表示中：

- $\sigma_{dt}=\sigma_{\varphi t}=\sigma_{\mu t}=\sigma_{At}=\sigma_{\xi t}=1$（以对数偏离表示）。
- $\gamma_{\Pi t}=\gamma_{yt}=1$（以漂移偏离表示）。
- $\mu_A=\exp(\Lambda_A)$ 且 $\mu_I=\exp(\Lambda_{\mu})$；$\mu_z=\mu_A^{1/(1-\alpha)}\mu_I^{\alpha/(1-\alpha)}$。
- 利用率归一化为 $u=1$，意味着 $\Phi(1)=0$ 且 $\Phi'(1)=\widetilde r$。
- 当通胀和工资通胀处于平衡增长值时，价格和工资分散为 $v^p=v^w=1$。
- 本地论文 Markdown 没有完整写出闭式稳态求解顺序，因此稳态部分为 `needs_review`。以后应检查论文附录或原始计算文件，之后才能把稳态质量提升到一审以上。

## 7. Timing & Form Conventions

- **资本时序**：论文生产中使用上期租入资本。Dynare 交叉检查形式声明 `predetermined_variables k`，生产使用 $k_{t-1}$，平稳资本运动方程求解 $k_{t+1}$。
- **平稳化**：具有单位根技术趋势的变量按第 5.4 节用 $z_t$ 重标度；资本/租金项也涉及 $\mu_t$。
- **近似形式**：论文估计需要二阶近似，因为随机波动和政策参数漂移不会出现在确定性等价的一阶决策规则中。未执行运行时验证。
- **来源状态**：方程 (F6)、(F7) 以及部分资本利用率/分散项代数为 `needs_review`，因为本地 MinerU 文本没有干净的附录规范化。
- **实现交叉检查**：Rep-MMB `.mod` 确认了 36 条模型方程、36 个内生变量、12 个外生创新以及预定资本。该信息仅作为 `implementation_cross_check` 记录。

## 8. Variable & Parameter Reference Table

### 内生变量

| ASCII name | 数学符号 | 含义 | 主要方程 |
|---|---|---|---|
| `d` | $d_t$ | 跨期偏好冲击 | (F24) |
| `c` | $c_t$ | 消费 | (F1), (F16) |
| `mu_z` | $\mu_{z,t}$ | 复合增长率 | (F28) |
| `mu_I` | $\mu_{I,t}$ | 投资专有技术增长 | (F26) |
| `mu_A` | $\mu_{A,t}$ | 中性技术增长 | (F27) |
| `lambda` | $\lambda_t$ | 边际效用/拉格朗日乘子 | (F1), (F2) |
| `R` | $R_t$ | 名义总利率 | (F2), (F15) |
| `PI` | $\Pi_t$ | 通胀 | (F14), (F15) |
| `r` | $r_t$ | 资本租金率 | (F3), (F11), (F12) |
| `x` | $x_t$ | 投资 | (F5), (F16), (F21) |
| `u` | $u_t$ | 资本利用率 | (F3), (F17) |
| `q` | $q_t$ | Tobin 边际 q | (F4), (F5) |
| `f` | $f_t$ | 工资设定递归变量 | (F6), (F7) |
| `ld` | $l_t^d$ | 总劳动需求 | (F11), (F17), (F18) |
| `w` | $w_t$ | 实际工资 | (F11), (F12), (F13) |
| `wstar` | $w^*_t$ | 最优重设工资 | (F6), (F23) |
| `PIstarw` | $\Pi^*_{w,t}$ | 最优工资通胀 | (F7), (F13), (F20), (F23) |
| `PIstar` | $\Pi^*_t$ | 最优重设价格通胀 | (F9), (F14), (F19) |
| `g1` | $g_{1t}$ | 价格设定递归变量 | (F8), (F10) |
| `g2` | $g_{2t}$ | 价格设定递归变量 | (F9), (F10) |
| `yd` | $y_t^d$ | 总需求/产出 | (F15), (F16), (F17), (F36) |
| `mc` | $mc_t$ | 实际边际成本 | (F8), (F12) |
| `k` | $k_t$ | 资本存量 | (F4), (F17), (F21) |
| `vp` | $v^p_t$ | 价格分散 | (F17), (F19) |
| `vw` | $v^w_t$ | 工资分散 | (F18), (F20) |
| `l` | $l_t$ | 总劳动组合 | (F18) |
| `phi` | $\varphi_t$ | 劳动负效用冲击 | (F25) |
| `F` | $F_t$ | 企业利润 | (F22) |
| `sigma_dt` | $\sigma_{dt}$ | 偏好冲击波动率 | (F29) |
| `sigma_phit` | $\sigma_{\varphi t}$ | 劳动负效用冲击波动率 | (F30) |
| `sigma_mut` | $\sigma_{\mu t}$ | 投资专有冲击波动率 | (F31) |
| `sigma_At` | $\sigma_{At}$ | 中性技术冲击波动率 | (F32) |
| `sigma_mt` | $\sigma_{\xi t}$ | 货币政策冲击波动率 | (F33) |
| `gammaPIt` | $\gamma_{\Pi t}$ | 通胀反应漂移 | (F34) |
| `gammayt` | $\gamma_{yt}$ | 产出增长反应漂移 | (F35) |
| `yg` | $y^g_t$ | 产出增长观测量 | (F36) |

### 外生创新

| ASCII name | 含义 |
|---|---|
| `epsd` | 偏好冲击创新 |
| `epsphi` | 劳动负效用冲击创新 |
| `epsmu_I` | 投资专有技术创新 |
| `epsA` | 中性技术创新 |
| `epsm` | 货币政策创新 |
| `ud` | 偏好波动率创新 |
| `uphi` | 劳动负效用波动率创新 |
| `umu` | 投资专有波动率创新 |
| `uA` | 中性技术波动率创新 |
| `um` | 货币政策波动率创新 |
| `epspi` | 通胀反应漂移创新 |
| `epsy` | 产出增长反应漂移创新 |

### 主要参数

| ASCII name | 含义 |
|---|---|
| `h`, `betta` | 习惯持续性和贴现因子 |
| `gammma1`, `gammma2` | 资本利用成本线性/二次项 |
| `delta`, `kappa` | 折旧和投资调整成本 |
| `eta`, `epsilon` | 劳动和商品替代弹性 |
| `varpsi`, `gammma` | 劳动负效用尺度和 Frisch 弹性倒数 |
| `chiw`, `chi` | 工资和价格指数化 |
| `thetaw`, `thetap` | Calvo 工资和价格刚性 |
| `alppha` | 资本份额 |
| `Rbar`, `PIbar` | 平衡增长名义利率和通胀 |
| `gammmaR`, `gammmaPI`, `gammmay` | Taylor 规则平滑、通胀反应、产出增长反应 |
| `Phi` | 中间品生产固定成本 |
| `rhod`, `rhophi` | 偏好和劳动负效用冲击持续性 |
| `Lambdamu`, `LambdaA`, `Lambdax`, `LambdaYd` | 增长率常数 |
| `sigma_d`, `sigma_phi`, `sigma_mu`, `sigma_A`, `sigma_m` | 平均创新标准差 |
| `rhosigd`, `rhosigphi`, `rhosigmu`, `rhosigA`, `rhosigm` | 波动率冲击持续性 |
| `rhogammaPI`, `rhogammay` | 政策漂移持续性 |
| `eta_d`, `eta_phi`, `eta_mu`, `eta_A`, `eta_m` | 波动率冲击创新尺度 |
| `sigma_pi`, `sigma_y` | 政策漂移创新尺度 |
