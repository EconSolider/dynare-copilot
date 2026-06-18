# US_CFOP14 -- 推导（最优化问题 + 一阶条件）

> 状态：`needs_review`。这是一个由 MinerU Markdown 和实现交叉检查支持的第一版归档条目。未执行运行时验证。

来源：`US_CFOP14`，Carlstrom, Charles T.; Fuerst, Timothy S.; Ortiz, Alberto; Paustian, Matthias (2014), "Estimating contract indexation in a financial accelerator model", Journal of Economic Dynamics & Control 46, pp. 130-194, DOI `10.1016/j.jedc.2014.06.009`。源 Markdown：`raw/mmb_mineru/runs/us_cfop14__estimating_contract_indexation_in_a_financial_accelerator_model__06425d65/full.md`；原始 PDF：`raw/mmb_papers/Estimating contract indexation in a financial accelerator model.pdf`；MinerU run id：`06425d65-581e-4e92-98d4-a90b7f9fa804`。未找到 appendix-normalization 文件。实现交叉检查：`.agents/skills/dynare-copilot/references/examples/US_CFOP14_rep.mod`。

## 1. Model Overview

- **模型**：以 Justiniano, Primiceri and Tambalotti (2011) 为基础的美国中等规模新凯恩斯模型，并加入 BGG 金融加速器代理成本以及 CFP 合同对资本总回报的指数化。
- **实验**：贝叶斯估计的线性化模型。MMB 实现使用 `model(linear)` 并模拟一阶动态。
- **主体和模块**：具有习惯形成与 Calvo 工资设定的家庭；具有 Calvo 价格、工资和价格加成冲击的中间品厂商；最终品厂商；具有投资调整成本和 MEI 冲击的资本品生产者；使用净值和外部融资购买安装资本的企业家；满足零期望超额收益的一般贷款人；货币和财政当局。
- **金融机制**：贷款偿付可以对资本总回报中的意外部分进行指数化。估计得到的 `R^k` 指数化参数改变资本回报冲击传导到借款人净值和外部融资溢价的方式。
- **形式**：对数线性化系统，在 Dynare 中实现为 `model(linear)`。论文中的带帽变量表示围绕平衡增长稳态的对数偏离或线性偏离。

## 2. Optimization Problems

### 2.1 贷款人

代表性贷款人接受支付无风险实际收益 \(R_t^d\) 的家庭存款，并向企业家发放一期贷款。股利等于贷款组合已实现利差乘以存款。其权益价值为

\[
Q_t^L = E_t \sum_{j=1}^{\infty}\frac{\beta^j\Lambda_{t+j}}{\Lambda_t}\,\mathrm{Div}_{t+j}.
\]

### 2.2 企业家与贷款合约

企业家在 \(t\) 期末使用净值和信贷购买总资本存量：

\[
\mathrm{Credit}_t \equiv Q_t\overline{K}_t - NW_t,
\qquad
\bar{\kappa}_t \equiv \frac{Q_t\overline{K}_t}{NW_t}.
\]

资本总回报为

\[
R_{t+1}^k \equiv \frac{Q_{t+1}^{beg}}{Q_t},
\qquad
Q_{t+1}^{beg}=Q_{t+1}(1-\delta)+\rho_{t+1}u_{t+1}-a(u_{t+1}).
\]

风险债务合约设定违约阈值 \(\varpi_{t+1}\) 和承诺收益 \(R_{t+1}^p\)：

\[
R_{t+1}^p(Q_t\overline{K}_t-NW_t)
= \varpi_{t+1}R_{t+1}^k Q_t\overline{K}_t.
\]

企业家和贷款人的项目份额为

\[
f(\varpi)=\int_{\varpi}^{\infty}\omega\phi(\omega)d\omega-[1-\Phi(\varpi)]\varpi,
\]

\[
g(\varpi)=[1-\Phi(\varpi)]\varpi+(1-\mu_{mc})\int_0^{\varpi}\omega\phi(\omega)d\omega,
\]

企业家求解

\[
\max_{\bar{\kappa}_t,\varpi_{t+1}}
E_t\left[V_{t+1}R_{t+1}^k\bar{\kappa}_t f(\varpi_{t+1})\right]
\]

并满足贷款人参与约束

\[
E_t R_{t+1}^k \frac{\bar{\kappa}_t}{\bar{\kappa}_t-1}\Lambda_{t+1}g(\varpi_{t+1})
\ge R_t^d E_t\Lambda_{t+1}.
\]

企业家净值由保留的项目收益演化：

\[
NW_t = \gamma NW_{t-1}\bar{\kappa}_{t-1}R_t^k f(\varpi_t)\eta_{nw,t}.
\]

### 2.3 最终品与中间品厂商

最终品厂商组合差异化产品：

\[
Y_t=\left[\int_0^1Y_t(i)^{1/(1+\lambda_{p,t})}di\right]^{1+\lambda_{p,t}}.
\]

中间品厂商使用

\[
Y_t(i)=\max\left\{A_t^{1-\alpha}K_t(i)^\alpha L_t(i)^{1-\alpha}
-A_t\Upsilon_t^{\alpha/(1-\alpha)}F,0\right\}
\]

并面对带价格指数化的 Calvo 价格刚性。

### 2.4 资本品生产者

资本品生产者选择投资以最大化被转化投资品的价值，

\[
\max_{\{I_t\}}\;E_t\sum_{s\ge0}\beta^s\frac{\Lambda_{t+s}}{\Lambda_t}
\left[Q_{t+s}\mu_{t+s}\left(1-S\left(\frac{I_{t+s}}{I_{t+s-1}}\right)\right)I_{t+s}
-P^I_{t+s}I_{t+s}\right].
\]

### 2.5 家庭

家庭 \(j\) 最大化

\[
E_t\sum_{s=0}^{\infty}\beta^s b_{t+s}
\left[\log(C_{t+s}-hC_{t+s-1})
-\varphi\frac{L_{t+s}(j)^{1+\psi}}{1+\psi}\right]
\]

并受包含消费、税收、存款、名义债券、工资、存款收益和企业利润的流量预算约束约束。Calvo 工资调整者在劳动需求约束下选择 \(W_t(j)\)；不能重新优化的工资按照滞后通胀和平衡增长项进行指数化。

## 3. First-Order Conditions

MMB 实现包含每个基准方程以及标记为 `star` 的潜在产出对应方程。下列方程给出来源侧核心；`star` 方程通过替换为对应的 `star` 变量并按实现文件移除金融摩擦得到。

- **(F1) 贷款人零利润条件**：

\[
E_t\frac{\Lambda_{t+1}}{\Lambda_t}\left(R_{t+1}^L-R_t^d\right)=0.
\]

- **(F2) 生产函数**：

\[
\hat{y}_t=\frac{y+F}{y}\left[\alpha\hat{k}_t+(1-\alpha)\hat{L}_t\right].
\]

- **(F3) 成本最小化**：

\[
\hat{\rho}_t-\hat{w}_t=\hat{L}_t-\hat{k}_t.
\]

- **(F4) 实际边际成本**：

\[
\hat{s}_t=\alpha\hat{\rho}_t+(1-\alpha)\hat{w}_t.
\]

- **(F5) 带指数化的价格 Phillips 曲线**：

\[
\hat{\pi}_t=\frac{\beta}{1+\beta\iota_p}E_t\hat{\pi}_{t+1}
+\frac{\iota_p}{1+\beta\iota_p}\hat{\pi}_{t-1}
+\frac{(1-\beta\xi_p)(1-\xi_p)}{(1+\beta\iota_p)\xi_p}\hat{s}_t
+\hat{\lambda}_{p,t}.
\]

- **(F6) 家庭边际效用 / 消费 FOC**（`needs_review`：MEI 增长项附近的 OCR 记号有噪声）：

\[
\hat{\lambda}_t =
a_c E_t\hat{c}_{t+1}-b_c\hat{c}_t+d_c\hat{c}_{t-1}
+a_z\hat{z}_t+a_b\hat{b}_t+a_{\mu}\hat{v}_t,
\]

其中系数是 \(\beta,h,\gamma_z,\rho_z,\rho_b,\rho_v,\alpha\) 的函数，见论文方程 (A5)。

- **(F7) 无风险名义收益的 Euler 方程**：

\[
\hat{\lambda}_t=\hat{R}_t+E_t\left(\hat{\lambda}_{t+1}-\hat{z}_{t+1}
-\hat{\pi}_{t+1}-\frac{\alpha}{1-\alpha}\hat{v}_{t+1}\right).
\]

- **(F8) 资本利用率 FOC**：

\[
\hat{\rho}_t=\vartheta\hat{u}_t.
\]

- **(F9) 无摩擦预期资本回报条件**：

\[
E_t\hat{r}_{t+1}^k=\hat{\lambda}_t-E_t\hat{\lambda}_{t+1}
+E_t\hat{z}_{t+1}
+\frac{\alpha}{1-\alpha}E_t\hat{v}_{t+1}.
\]

- **(F10) 代理成本下的预期资本回报条件**：

\[
E_t\hat{r}_{t+1}^k=\hat{\lambda}_t-E_t\hat{\lambda}_{t+1}
+E_t\hat{z}_{t+1}
+\frac{\alpha}{1-\alpha}E_t\hat{v}_{t+1}
+\nu(\hat{q}_t+\hat{\bar{k}}_t-\hat{n}_t)+\hat{\sigma}_t.
\]

- **(F11) 投资 FOC / Tobin's q**：

\[
\hat{q}_t=-\hat{\mu}_t+e^{2(\gamma_z+\gamma_v)}S''\left(\hat{i}_t-\hat{i}_{t-1}
+\hat{z}_t+\frac{1}{1-\alpha}\hat{v}_t\right)
-\beta e^{2(\gamma_z+\gamma_v)}S''E_t\left(\hat{i}_{t+1}-\hat{i}_t
+\hat{z}_{t+1}+\frac{1}{1-\alpha}\hat{v}_{t+1}\right).
\]

- **(F12) 资本服务投入**：

\[
\hat{k}_t=\hat{u}_t+\hat{\bar{k}}_{t-1}-\hat{z}_t-\frac{1}{1-\alpha}\hat{v}_t.
\]

- **(F13) 资本积累**：

\[
\hat{\bar{k}}_t=(1-\delta)e^{-(\gamma_z+\gamma_v)}
\left(\hat{\bar{k}}_{t-1}-\hat{z}_t-\frac{1}{1-\alpha}\hat{v}_t\right)
+\left[1-(1-\delta)e^{-(\gamma_z+\gamma_v)}\right](\hat{\mu}_t+\hat{i}_t).
\]

- **(F14) 工资 Phillips 曲线**（`needs_review`：OCR 在增长记号中同时使用 \(v\) 和 \(\nu\)）：

\[
\hat{w}_t=\frac{1}{1+\beta}\hat{w}_{t-1}
+\frac{\beta}{1+\beta}E_t\hat{w}_{t+1}
-\kappa_w\hat{g}_{w,t}
+\frac{\iota_w}{1+\beta}\hat{\pi}_{t-1}
-\frac{1+\beta\iota_w}{1+\beta}\hat{\pi}_t
+\frac{\beta}{1+\beta}E_t\hat{\pi}_{t+1}
+\text{growth-indexation terms}
+\hat{\lambda}_{w,t}.
\]

- **(F15) 工资缺口**：

\[
\hat{g}_{w,t}=\hat{w}_t-(\psi\hat{L}_t+\hat{b}_t-\hat{\lambda}_t).
\]

- **(F16) 货币政策规则**：

\[
\hat{R}_t=\rho_R\hat{R}_{t-1}
+(1-\rho_R)\left[\phi_{\pi}\hat{\pi}_t+\phi_x(\hat{x}_t-\hat{x}_t^{\ast})\right]
+\phi_{dx}\left[(\hat{x}_t-\hat{x}_{t-1})-(\hat{x}_t^{\ast}-\hat{x}_{t-1}^{\ast})\right]
+\hat{\eta}_{mp,t}.
\]

- **(F17) GDP 缺口定义**：

\[
\hat{x}_t=\hat{y}_t-\frac{\rho k}{y}\hat{u}_t.
\]

- **(F18) 实际存款收益 / Fisher 方程**：

\[
\hat{r}_t^d=\hat{R}_t-E_t\hat{\pi}_{t+1}.
\]

- **(F19) 已实现资本回报**：

\[
\hat{r}_t^k=\beta e^{-(\gamma_z+\gamma_v)}(1-\delta)\hat{q}_t
+\left[1-\beta e^{-(\gamma_z+\gamma_v)}(1-\delta)\right]\hat{\rho}_t
-\hat{q}_{t-1}.
\]

- **(F20) 净值积累**：

\[
\hat{n}_t=\kappa\frac{\gamma}{\beta}(\hat{r}_t^k-\hat{r}_t^l)
+\frac{\gamma}{\beta}(\hat{r}_t^l+\hat{n}_{t-1})
+\gamma\kappa\frac{rp}{\beta}(\hat{\bar{k}}_{t-1}+\hat{q}_{t-1}+\hat{r}_t^k)
-\hat{z}_t-\frac{1}{1-\alpha}\hat{v}_t+\hat{\eta}_{nw,t}.
\]

- **(F21) 带合同指数化的贷款人收益**：

\[
\hat{r}_t^l=\hat{r}_{t-1}^d+\left[1+\theta_g(\chi_k-1)\right]
\left(\hat{r}_t^k-E_{t-1}\hat{r}_t^k\right).
\]

- **(F22) 预期收益辅助变量**：

\[
\hat{r}_{t}^{ke}=E_t\hat{r}_{t+1}^k.
\]

- **(F23) 边际效用预期辅助变量**：

\[
\hat{\lambda}_t^e=E_t\hat{\lambda}_{t+1}.
\]

- **(F24) 承诺偿付规则**：

\[
\hat{r}_t^p=\hat{r}_{t-1}^d
+\frac{(1-\theta_g)[1-\nu(\kappa-1)]}{\theta_g(\kappa-1)}
(\hat{q}_{t-1}+\hat{\bar{k}}_{t-1}-\hat{n}_{t-1})
+\chi_k(\hat{r}_t^k-E_{t-1}\hat{r}_t^k)
+c_b(\hat{\lambda}_t-E_{t-1}\hat{\lambda}_t).
\]

- **(F25) 利差**：

\[
\widehat{spr}_t=E_t\hat{r}_{t+1}^k-\hat{r}_t^d.
\]

- **(F26) 信贷**：

\[
\widehat{credit}_t=\frac{\kappa}{\kappa-1}\hat{q}_t
+\frac{\kappa}{\kappa-1}\hat{\bar{k}}_t
-\frac{1}{\kappa-1}\hat{n}_t.
\]

## 4. Market Clearing & Identities

- **(F27) 资源约束**：

\[
\frac{1}{g}\hat{y}_t=\frac{1}{g}\hat{g}_t+\frac{c}{y}\hat{c}_t
+\frac{i}{y}\hat{i}_t+\frac{\rho k}{y}\hat{u}_t.
\]

- **(F28) 来自非线性源模型的总资本法则**：

\[
\overline{K}_t=(1-\delta)
\left(1-\mu_{mc}\int_0^{\varpi_t}\omega\phi(\omega)d\omega\right)\overline{K}_{t-1}
+\mu_t\left[1-S\left(\frac{I_t}{I_{t-1}}\right)\right]I_t.
\]

- **(F29) 政府支出份额恒等式**：

\[
G_t=\left(1-\frac{1}{g_t}\right)Y_t.
\]

实现交叉检查还定义了 `gdp`、`gdpstar`、潜在产出对应变量，以及生产、成本最小化、边际成本、消费、投资、资本、工资和金融变量的独立 `star` 版本。

## 5. Exogenous Processes

- **(F30) 净值冲击**：

\[
\hat{\eta}_{nw,t}=\rho_{nw}\hat{\eta}_{nw,t-1}+\varepsilon_{nw,t}.
\]

- **(F31) 特质方差 / 外部融资溢价冲击**：

\[
\hat{\sigma}_t=\rho_{\sigma}\hat{\sigma}_{t-1}+\varepsilon_{\sigma,t}.
\]

- **(F32) 非金融 AR 和 ARMA 冲击**：

\[
\begin{aligned}
\hat{z}_t &= \rho_z\hat{z}_{t-1}+\varepsilon_{z,t},\\
\hat{g}_t &= \rho_g\hat{g}_{t-1}+\varepsilon_{g,t},\\
\hat{\mu}_t &= \rho_{\mu}\hat{\mu}_{t-1}+\varepsilon_{\mu,t},\\
\hat{b}_t &= \rho_b\hat{b}_{t-1}+\varepsilon_{b,t},\\
\hat{\eta}_{mp,t} &= \rho_{mp}\hat{\eta}_{mp,t-1}+\varepsilon_{mp,t},\\
\hat{\lambda}_{p,t} &= \rho_p\hat{\lambda}_{p,t-1}+\varepsilon_{p,t}-\theta_p\varepsilon_{p,t-1},\\
\hat{\lambda}_{w,t} &= \rho_w\hat{\lambda}_{w,t-1}+\varepsilon_{w,t}-\theta_w\varepsilon_{w,t-1}.
\end{aligned}
\]

- **(F33) 实现中的投资专用技术增长冲击**：

\[
\hat{\upsilon}_t=\rho_{\upsilon}\hat{\upsilon}_{t-1}+\varepsilon_{\upsilon,t}.
\]

## 6. Steady-State Solution

由于 `US_CFOP14` 是线性化平衡增长模型，Dynare `model(linear)` 模块中的所有模型变量都是相对于稳态的偏离；这些变量的操作稳态为零：

\[
\hat{y}=\hat{k}=\hat{L}=\hat{c}=\hat{q}=\hat{n}=\hat{R}=\hat{r}^k=\hat{spr}=0,
\qquad
\varepsilon_{\cdot}=0.
\]

实现文件在 model 模块之前计算所需的稳态比率和系数。交叉检查文件定义：

\[
\beta=\frac{100}{Fbeta+100},\quad
r_{ss}=e^{\gamma}/\beta-1,\quad
\pi_{ss}=pss100/100,
\]

\[
R^k_{ss}=e^{\gamma+\gamma_{\mu}}/\beta-1+\delta,\quad
s_{ss}=\frac{1}{1+\lambda_{p,ss}},
\]

然后由校准或估计参数构造稳态工资、资本劳动比、产出、投资、固定成本、消费和 Calvo 工资系数。金融稳态目标包括杠杆率 \(\kappa=1.95\)、季度风险溢价 \(rp=0.02/4\)、企业家存活率 \(\gamma=0.94\)，以及基准指数化模型中的代理成本弹性 \(\nu=0.19\)。

## 7. Timing & Form Conventions

- **形式**：对数线性化；Dynare 实现使用 `model(linear)`。
- **资本时序**：安装资本存量 \(\bar{k}_t\) 通过 \(\bar{k}_{t-1}\) 预定并进入生产服务；当期资本服务结合利用率、滞后安装资本和增长项。
- **贷款**：贷款在 \(t\) 期末发放，并在 \(t+1\) 期偿还；\(t\) 期已实现贷款人收益取决于上一期存款收益和已实现资本回报的意外部分。
- **净值**：\(\hat{n}_t\) 是由 \(\hat{n}_{t-1}\)、已实现资本/贷款人收益和净值再分配冲击推进的状态变量。
- **预期**：实现文件使用 `Rk(+1)` 等超前记号，以及 `Rke = Rk(+1)`、`lambdae = lambda(+1)` 等辅助变量表示一期前瞻对象。
- **潜在产出系统**：`star` 变量表示政策规则和产出缺口中使用的相应无摩擦或潜在产出模块。
- **运行时验证**：未执行；没有运行 Dynare 命令。

## 8. Variable & Parameter Reference Table

| Category | Symbol / ASCII name | Meaning | Main equation(s) |
|---|---|---|---|
| Endogenous | `y`, `ystar` | 产出和潜在产出 | (F2), (F27) |
| Endogenous | `k`, `kstar` | 资本服务 | (F12) |
| Endogenous | `L`, `Lstar` | 劳动 | (F2), (F3), (F15) |
| Endogenous | `mpk`, `mpkstar` | 资本边际产品/租金回报 | (F3), (F8) |
| Endogenous | `w`, `wstar` | 实际工资 | (F3), (F14), (F15) |
| Endogenous | `p` | 通胀 | (F5) |
| Endogenous | `s`, `sstar` | 实际边际成本 | (F4), (F5) |
| Endogenous | `lambda`, `lambdastar` | 家庭边际效用 | (F6), (F7), (F23) |
| Endogenous | `c`, `cstar` | 消费 | (F6), (F27) |
| Endogenous | `R`, `Rstar` | 名义政策利率 | (F16), (F18) |
| Endogenous | `u`, `ustar` | 利用率 | (F8), (F12), (F17), (F27) |
| Endogenous | `i`, `istar` | 投资 | (F11), (F27) |
| Endogenous | `kbar`, `kbarstar` | 安装资本 | (F13), (F28) |
| Endogenous | `wgap`, `wgapstar` | 工资缺口 | (F15) |
| Endogenous | `gdp`, `gdpstar` | GDP 缺口度量 | (F17) |
| Endogenous | `z`, `g`, `miu`, `b`, `mp`, `lambdap`, `lambdaw`, `upsilon` | 放在 `var` 中的外生状态变量 | (F32), (F33) |
| Endogenous | `Rk`, `Rkstar`, `q`, `qstar` | 资本回报和资本价格 | (F10), (F11), (F19), (F22) |
| Endogenous | `Rl`, `Rlstar`, `Rd`, `Rdstar` | 贷款人和存款收益 | (F18), (F21) |
| Endogenous | `nw`, `nwstar` | 企业家净值 | (F20) |
| Endogenous | `lamefp`, `lamnw` | 金融冲击状态 | (F30), (F31) |
| Endogenous | `spr`, `sprstar` | 利差 | (F25) |
| Endogenous | `promz`, `promzstar` | 承诺偿付 | (F24) |
| Endogenous | `credit` | 信贷总量 | (F26) |
| Exogenous | `Rs`, `zs`, `gs`, `mius`, `lambdaps`, `lambdaws`, `bs`, `efps`, `upsilons`, `nws` | 货币、技术、财政、MEI、加成、偏好、金融、IST 和净值冲击创新 | (F30)-(F33) |
| Parameter | `alpha`, `delta`, `h`, `Fbeta`, `gamma100`, `gammamiu100` | 生产、折旧、习惯、贴现、趋势增长 | steady state, (F2), (F6), (F11)-(F13) |
| Parameter | `iotap`, `iotaw`, `xip`, `xiw`, `lambdapss`, `lambdawss`, `niu` | 价格/工资指数化、Calvo 参数、加成、劳动曲率 | (F5), (F14), (F15) |
| Parameter | `Sadj`, `chi` | 投资调整和利用率成本弹性 | (F8), (F11) |
| Parameter | `fp`, `fy`, `fdy`, `rhoR` | 货币政策响应和平滑 | (F16) |
| Parameter | `cnu`, `cgamma`, `crp`, `ckappa`, `ctheta`, `cchi`, `cb` | 金融加速器和合同指数化参数 | (F10), (F20), (F21), (F24), (F26) |
| Parameter | `rhoz`, `rhog`, `rhomiu`, `rholambdap`, `rholambdaw`, `rhob`, `rhomp`, `rhoefp`, `rhonw`, `rhoupsilon` | 冲击持久性参数 | (F30)-(F33) |
