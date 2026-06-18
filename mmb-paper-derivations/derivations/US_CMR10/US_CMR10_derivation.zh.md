# US_CMR10 推导

> Christiano, Motto, and Rostagno (2010)《Financial Factors in Economic Fluctuations》美国基准版本的来源支撑一稿归档条目。状态：`needs_review`。
> 运行验证：未执行。未运行 Dynare。

## 1. Model Overview

- **模型 ID**：`US_CMR10`。
- **论文**：Lawrence J. Christiano, Roberto Motto, and Massimo Rostagno (2010), "Financial Factors in Economic Fluctuations," ECB Working Paper Series No. 1192。`model_index.csv` 记录的 DOI：`10.2139/ssrn.1600166`。
- **方程来源**：`raw/mmb_mineru/runs/us_cmr10_us_cmr10fa__financial_factors_in_economic_fluctuations__7ef56ea6/full.md`。该行的 `primary_full_md_path` 指向另一篇 Furlanetto-Ravazzolo-Sarferaz VAR 论文，因此在本条目中记录为源索引问题，不作为数学证据。
- **经济体和版本**：美国估计基准模型，包含完整金融加速器和银行融资渠道。论文也估计欧元区和较小版本；本条目记录美国基准实现家族。
- **核心主体**：最终品聚合者、带 Calvo 定价的垄断竞争中间品企业、资本品生产者、带 BGG 式 costly state verification 的企业家、同时提供营运资本贷款和企业家贷款的代表性银行、带货币/存款选择和 Calvo 工资设定的家庭、政府和货币当局。
- **形式**：经平稳化后的非线性均衡条件，并在一阶扰动后求解。论文以线性化形式报告货币政策规则。本一稿保留论文的缩放方程，并将 OCR 敏感公式标为 `needs_review`。

## 2. Optimization Problems

### 中间品企业

中间品生产者租用资本服务和劳动，预先融资部分要素账单，并在 Calvo 粘性价格下按通胀目标和滞后通胀进行指数化。

$$
Y_{j,t}=\epsilon_t z_t^{1-\alpha}K_{j,t}^{\alpha}l_{j,t}^{1-\alpha}-\Phi z_t^{\ast} .
$$

给定营运资本融资要求，实际边际成本定义为：

$$
s_t=\left(\frac{1}{1-\alpha}\right)^{1-\alpha}\left(\frac{1}{\alpha}\right)^{\alpha}
\frac{\left(\tilde r_t^k[1+\psi_k R_t]\right)^{\alpha}
\left(\frac{W_t}{P_t}[1+\psi_l R_t]\right)^{1-\alpha}}{\epsilon_t z_t^{1-\alpha}} .
$$

未重设价格的企业按如下规则指数化：

$$
\tilde\pi_t=(\pi_t^{target})^{\iota}(\pi_{t-1})^{1-\iota}.
$$

### 资本品生产者

竞争性资本品生产者把投资品和未折旧资本转化为安装资本：

$$
x' = x + F(I_t,I_{t-1},\zeta_{i,t})
=x+\left[1-S\left(\zeta_{i,t}I_t/I_{t-1}\right)\right]I_t .
$$

资本品生产者求解：

$$
\max_{\{I_{t+j},x_{t+j}\}} E_t\sum_{j=0}^{\infty}\beta^j\lambda_{t+j}\Pi^k_{t+j}.
$$

### 企业家

在 \(t\) 期末，企业家把净值 \(N_{t+1}\) 与银行贷款 \(B_{t+1}\) 结合，用于购买安装资本。项目异质生产率 \(\omega\) 服从对数正态分布，离散度 \(\sigma_t\) 随时间变化，是模型中的风险冲击。标准债务合约在银行子部门零利润约束下选择贷款规模和违约阈值 \(\bar\omega_{t+1}\)。

阈值满足：

$$
\bar\omega_{t+1}(1+R^k_{t+1})Q_{\bar K',t}\bar K_{t+1}=Z_{t+1}B_{t+1}.
$$

### 银行

代表性银行提供营运资本贷款和企业家贷款。营运资本贷款满足：

$$
(1+R_t)S_t^w=(1+R_t)(\psi_l W_t l_t+\psi_k P_t\tilde r_t^k K_t).
$$

企业家贷款由带监控成本 \(\mu\)、违约份额 \(G_t(\bar\omega)\) 和银行收入份额 \(\Gamma_t(\bar\omega)-\mu G_t(\bar\omega)\) 的 costly-state-verification 合约刻画。

### 家庭

家庭消费、供给差异化劳动，并在提供不同流动性服务的存款和证券之间配置财富。附录报告了边际效用、消费、工资设定、定期存款、货币、可交易存款和基础货币的一阶条件。

## 3. First-Order Conditions

以下方程为论文的缩放均衡条件，并为归档用途连续重新编号。OCR 受损方程标为 `needs_review`。

- **(F1) 边际成本，成本份额表达式**：

$$
s_t=\left(\frac{1}{1-\alpha}\right)^{1-\alpha}\left(\frac{1}{\alpha}\right)^{\alpha}
\frac{(r_t^k[1+\psi_kR_t])^{\alpha}(\tilde w_t[1+\psi_lR_t])^{1-\alpha}}{\epsilon_t}.
$$

- **(F2) 边际成本，资本租金表达式**：

$$
s_t=\frac{r_t^k[1+\psi_kR_t]}{\alpha\epsilon_t\left(\Upsilon\frac{\mu_{z,t}^{\ast}l_t}{u_t k_t}\right)^{1-\alpha}}.
$$

- **(F3) Calvo 重设价格指数**：

$$
p_t^{\ast}-\left[(1-\xi_p)\left(\frac{1-\xi_p(\tilde\pi_t/\pi_t)^{1/(1-\lambda_{f,t})}}{1-\xi_p}\right)^{\lambda_{f,t}}
\xi_p\left((\tilde\pi_t/\pi_t)p_{t-1}^{\ast}\right)^{\lambda_{f,t}/(1-\lambda_{f,t})}\right]^{(1-\lambda_{f,t})/\lambda_{f,t}}=0.
$$

- **(F4) 价格设定辅助变量 \(F_{p,t}\)，needs_review**：

$$
E_t\left\{\lambda_{z,t}Y_{z,t}+\left(\frac{\tilde\pi_{t+1}}{\pi_{t+1}}\right)^{1/(1-\lambda_{f,t})}\beta\xi_pF_{p,t+1}-F_{p,t}\right\}=0.
$$

- **(F5) 价格设定辅助变量 \(K_{p,t}\)，needs_review**：

$$
E_t\left\{\lambda_{f,t}\lambda_{z,t}Y_{z,t}s_t+\beta\xi_p
\left(\frac{\tilde\pi_{t+1}}{\pi_{t+1}}\right)^{-\lambda_{f,t}/(\lambda_{f,t}-1)}
K_{p,t+1}-K_{p,t}\right\}=0.
$$

- **(F6) 生产和价格离散条件**：

$$
Y_{z,t}=(p_t^{\ast})^{\lambda_f/(\lambda_f-1)}
\left\{\epsilon_t\nu_t^l\left(u_t\frac{\bar k_t}{\Upsilon\mu_{z,t}^{\ast}}\right)^\alpha
\left[(w_t^{\ast})^{\lambda_w/(\lambda_w-1)}H_t\right]^{1-\alpha}-\phi\right\}.
$$

- **(F7) 资本供给 FOC**：

$$
E_t\left[\lambda_{z,t}q_tF_{1,t}-\lambda_{z,t}\frac{1}{\mu_{\Upsilon,t}}
+\beta\frac{\lambda_{z,t+1}}{\mu_{z,t+1}^{\ast}\Upsilon}q_{t+1}F_{2,t+1}\right]=0.
$$

- **(F8) 资本利用率**：

$$
r_t^k=\tau_t^{oil}a'(u_t).
$$

- **(F9) 资本回报率**：

$$
R_t^k=\frac{[u_t r_t^k-\tau_t^{oil}a(u_t)]+(1-\delta)q_t}{\Upsilon q_{t-1}}\pi_t+\tau^k\delta-1.
$$

- **(F10) 标准债务合约最优性，needs_review**：

$$
E_t\left\{[1-\Gamma_t(\bar\omega_{t+1})]\frac{1+R_{t+1}^k}{1+R_{t+1}^e}
+\frac{\Gamma_t'(\bar\omega_{t+1})}{\Gamma_t'(\bar\omega_{t+1})-\mu G_t'(\bar\omega_{t+1})}
\left[\frac{1+R_{t+1}^k}{1+R_{t+1}^e}\left(\Gamma_t(\bar\omega_{t+1})-\mu G_t(\bar\omega_{t+1})\right)-1\right]\right\}=0.
$$

- **(F11) 企业家贷款零利润条件，needs_review**：

$$
(1+R_{t+1}^k)[\Gamma_t(\bar\omega_{t+1})-\mu G_t(\bar\omega_{t+1})]=
(1+R_{t+1}^e)\frac{q_t\bar k_{t+1}-n_{t+1}}{q_t\bar k_{t+1}}.
$$

- **(F12) 净值运动方程，needs_review**：

$$
n_{t+1}=\frac{\gamma_t}{\pi_t\mu_{z,t}^{\ast}}\left\{(1+R_t^k)\bar k_tq_{t-1}
-\left[1+R_t^e+\frac{\mu\int_0^{\bar\omega_t}\omega\,dF_t(\omega)(1+R_t^k)\bar k_tq_{t-1}}{\bar k_tq_{t-1}-n_t}\right](\bar k_tq_{t-1}-n_t)\right\}+w^e.
$$

- **(F13) 银行业服务生产，needs_review**：

$$
x_t^b(e_{v,t})^{-\xi_t}e_{z,t}^r=
\frac{m_t^b(1-m_t+\varsigma d_{m,t})}{\pi_t\mu_{z,t}^{\ast}}
+\psi_lw_tl_t+\psi_k\frac{r_t^kk_t}{\mu_{z,t}^{\ast}\Upsilon}.
$$

- **(F14) 超额准备金与银行增加值之比**：

$$
e_{v,t}=\frac{(1-\tau)\frac{m_t^b}{\pi_t\mu_{z,t}^{\ast}}(1-m_t)-\tau\left(\psi_lw_tl_t+\frac{\psi_kr_t^k}{\mu_{z,t}^{\ast}\Upsilon}k_t\right)}
{\left(\frac{1}{\mu_{z,t}^{\ast}\Upsilon}(1-\nu_t^k)k_t\right)^\alpha((1-\nu_t^l)l_t)^{1-\alpha}}.
$$

- **(F15) 银行效率条件**：

$$
R_{a,t}=\frac{(1-\tau)h_{e^r,t}-1}{\tau h_{e^r,t}+1}R_t,\qquad
h_{e^r,t}=(1-\xi_t)x_t^b(e_{v,t})^{-\xi_t}.
$$

- **(F16) 跨期银行效率条件**：

$$
E_t\left\{\frac{\lambda_{z,t+1}}{\mu_{z,t+1}^{\ast}\pi_{t+1}}
\left[R_{t+1}^T-R_{t+1}^m-\frac{\varsigma R_{t+1}}{h_{e^r,t+1}\tau+1}\right]\right\}=0.
$$

- **(F17) 银行劳动选择**：

$$
w_t=\frac{R_t}{1+\psi_lR_t}
\frac{(1-\alpha)\xi_tx_t^b(e_{v,t})^{1-\xi_t}
\left(\frac{\mu_{z,t}^{\ast}\Upsilon(1-\nu_t^l)l_t}{(1-\nu_t^k)k_t}\right)^{-\alpha}}{1+\tau h_{e^r,t}}.
$$

- **(F18) 消费边际效用**：

$$
E_t\left\{u_{c,t}^z-\frac{\mu_{z,t}^{\ast}\zeta_{c,t}}{c_t\mu_{z,t}^{\ast}-bc_{t-1}}
+b\beta\frac{\zeta_{c,t+1}}{c_{t+1}\mu_{z,t+1}^{\ast}-bc_t}\right\}=0.
$$

- **(F19) 消费-存款选择，needs_review**：

$$
0=E_t\left\{u_{c,t}^z-(1+\tau^C)\lambda_{z,t}
-\zeta_{c,t}vc_t^{-\sigma_q}\left(\frac{\pi_t\mu_{z,t}^{\ast}}{m_t^b}\right)^{1-\sigma_q}
\left[(1+\tau^C)\left(\frac{1}{m_t}\right)^{(1-\chi_t)\theta}
\left(\frac{1}{1-m_t}\right)^{(1-\chi_t)(1-\theta)}
\left(\frac{1}{dm_t}\right)^{\chi_t}\right]^{1-\sigma_q}\right\}.
$$

- **(F20) Calvo 工资重设指数，needs_review**：

$$
w_t^{\ast}=\left[(1-\xi_w)\left(\frac{1-\xi_w\left(\frac{\tilde\pi_{w,t}}{\pi_{w,t}}(\mu_{z^{\ast}})^{1-\vartheta}(\mu_{z^{\ast},t})^\vartheta\right)^{1/(1-\lambda_w)}}{1-\xi_w}\right)^{\lambda_w}
+\xi_w\left(\frac{\tilde\pi_{w,t}}{\pi_{w,t}}(\mu_{z^{\ast}})^{1-\vartheta}(\mu_{z^{\ast},t})^\vartheta w_{t-1}^{\ast}\right)^{\lambda_w/(1-\lambda_w)}\right]^{(1-\lambda_w)/\lambda_w}.
$$

- **(F21) 工资设定辅助变量 \(F_{w,t}\)，needs_review**：

$$
E_t\left\{(w_t^{\ast})^{\lambda_w/(\lambda_w-1)}H_t\frac{(1-\tau^l)\lambda_{z,t}}{\lambda_w}
+\beta\xi_w(\mu_{z^{\ast}})^{(1-\vartheta)/(1-\lambda_w)}
(\mu_{z^{\ast},t+1})^{\vartheta/(1-\lambda_w)-1}
\left(\frac{1}{\pi_{w,t+1}}\right)^{\lambda_w/(1-\lambda_w)}
\frac{\tilde\pi_{w,t+1}^{1/(1-\lambda_w)}}{\pi_{t+1}}F_{w,t+1}-F_{w,t}\right\}=0.
$$

- **(F22) 工资设定辅助变量 \(K_{w,t}\)，needs_review**：

$$
E_t\left\{\left[(w_t^{\ast})^{\lambda_w/(\lambda_w-1)}H_t\right]^{1+\sigma_L}\zeta_{c,t}
+\beta\xi_w\left(\frac{\tilde\pi_{w,t+1}}{\pi_{w,t+1}}(\mu_{z^{\ast}})^{1-\vartheta}(\mu_{z^{\ast},t+1})^\vartheta\right)^{\lambda_w(1+\sigma_L)/(1-\lambda_w)}K_{w,t+1}
-K_{w,t}\right\}=0.
$$

- **(F23) 定期存款 Euler 方程**：

$$
E_t\left\{-\lambda_{z,t}+\frac{\beta}{\mu_{z,t+1}^{\ast}\pi_{t+1}}\lambda_{z,t+1}(1+R_{t+1}^T)\right\}=0.
$$

- **(F24) 货币 \(M_t\) 选择，needs_review**：

$$
E_t\left\{\zeta_{c,t}v\mathcal L_t^{1-\sigma_q}
\left(\frac{\pi_t\mu_{z,t}^{\ast}}{m_t^b}\right)^{2-\sigma_q}
\left[\frac{(1-\chi_t)\theta}{m_t}-\frac{(1-\chi_t)(1-\theta)}{1-m_t}\right]
-\lambda_{z,t}R_t^a+\text{adjustment-cost terms}\right\}=0.
$$

- **(F25) 可交易存款 \(D_{t+1}^m\) 选择，needs_review**：

$$
E_t\left\{\beta\zeta_{c,t+1}v\chi_{t+1}\mathcal L_{t+1}^{1-\sigma_q}
\frac{1}{d_{t+1}^m}\left(\frac{1}{m_{t+1}^b}\right)^{2-\sigma_q}
(\pi_{t+1}\mu_{z,t+1}^{\ast})^{1-\sigma_q}
+\frac{\beta}{\pi_{t+1}\mu_{z,t+1}^{\ast}}\lambda_{z,t+1}(1+R_{t+1}^m)-\lambda_{z,t}\right\}=0.
$$

- **(F26) 基础货币 \(M_{t+1}^b\) 选择，needs_review**：

$$
E_t\left\{\beta\zeta_{c,t+1}v(1-\theta)(1-\chi_{t+1})\mathcal L_{t+1}^{1-\sigma_q}
\left(\frac{1}{m_{t+1}^b}\right)^{2-\sigma_q}(\pi_{t+1}\mu_{z,t+1}^{\ast})^{1-\sigma_q}\frac{1}{1-m_{t+1}}
+\frac{\beta}{\pi_{t+1}\mu_{z,t+1}^{\ast}}\lambda_{z,t+1}(1+R_{t+1}^a)-\lambda_{z,t}\right\}=0.
$$

## 4. Market Clearing & Identities

- **(F27) 资本积累**：

$$
\bar k_{t+1}=(1-\delta)\frac{1}{\mu_{z,t}^{\ast}\Upsilon}\bar k_t+
\left[1-S\left(\frac{\zeta_{i,t}i_t\mu_{z,t}^{\ast}\Upsilon}{i_{t-1}}\right)\right]i_t.
$$

- **(F28) 货币政策规则，线性化**：

$$
\hat R_{t+1}^e=\rho_i\hat R_t^e+(1-\rho_i)\alpha_\pi\frac{\pi}{R^e}
\left[E_t(\hat\pi_{t+1})-\hat\pi_t^{target}\right]
+(1-\rho_i)\frac{\alpha_{\Delta y}}{4R^e}\log\left(\frac{GDP_t}{\mu_{z^{\ast}}GDP_{t-1}}\right)
+(1-\rho_i)\alpha_{\Delta\pi}\frac{\pi}{R^e}(\hat\pi_t-\hat\pi_{t-1})
+(1-\rho_i)\frac{\alpha_{\Delta c}}{R^e}\log\left(\frac{B_t^{Tot}}{\mu_{z^{\ast}}B_{t-1}^{Tot}}\right)
+(1-\rho_i)\frac{\alpha_\xi}{R^e}\hat\xi_t+\frac{1}{400R^e}\varepsilon_t.
$$

- **(F29) 基础货币运动方程**：

$$
m_{t+1}^b=\frac{1}{\pi_t\mu_{z,t}^{\ast}}m_t^b(1+x_t).
$$

- **(F30) 资源约束，needs_review**：

$$
\frac{\mu G_t(\bar\omega_t)(1+R_t^k)q_{t-1}\bar k_t}{\mu_{z,t}^{\ast}\pi_t}
+\tau_t^{oil}a(u_t)\frac{\bar k_t}{\Upsilon\mu_{z,t}^{\ast}}+g_t+c_t+\frac{i_t}{\mu_{\Upsilon,t}}
+\Theta\frac{1-\gamma_t}{\gamma_t}(n_{t+1}-w^e)
=Y_{z,t}.
$$

- **(F31) 广义货币**：

$$
m_t^{Broad}=m_{t+1}^b(1+d_{t+1}^m)+\psi_lw_tl_t+
\psi_k\frac{r_t^ku_t}{\Upsilon\mu_{z,t}^{\ast}}\bar k_t.
$$

- **(F32) 银行贷款总量**：

$$
b_t^{Tot}=\psi_lw_tl_t+\psi_k\frac{r_t^ku_t\bar k_t}{\mu_{z,t}^{\ast}\Upsilon}
+(q_t\bar k_{t+1}-n_{t+1}).
$$

- **(F33) 平均信用利差 / 外部融资溢价**：

$$
P_t^e=\frac{\mu\int_0^{\bar\omega_t}\omega\,dF_t(\omega_t)(1+R_t^k)\bar k_tq_{t-1}}
{\bar k_tq_{t-1}-n_t}.
$$

- **(F34) 狭义货币**：

$$
m_t^{Narrow}=m_{t+1}^b+\psi_lw_tl_t+
\psi_k\frac{r_t^ku_t\bar k_t}{\Upsilon\mu_{z,t}^{\ast}}.
$$

- **(F35) 准备金**：

$$
res_t=\frac{m_t^b}{\pi_t}(1-m_t+x_t).
$$

## 5. Exogenous Processes

论文估计了价格加成、银行技术、银行准备金需求/流动性偏好、期限溢价、投资专用技术、货币需求、政府消费、永久和暂时生产率、金融财富、风险、消费偏好、投资边际效率、油价、货币政策和价格加成冲击的随机过程。Rep-MMB 实现交叉检查使用如下形式的一阶 AR(1) 过程：

- **(F36) 通用 AR(1) 冲击过程**：

$$
x_t=\bar x(1+\varepsilon_{x,t})+\rho_x(x_{t-1}-\bar x).
$$

例如，实现交叉检查记录了 \(\lambda_{f,t},\pi_t^{target},x_t^b,\mu_{\Upsilon,t},\chi_t,g_t,\mu_{z,t}^{\ast},\gamma_t,\epsilon_t,\sigma_t,\zeta_{i,t},\tau_t^{oil}\) 的过程。

论文给出了风险冲击的信号表示：

- **(F37) 带新闻信号的风险冲击**：

$$
\hat\sigma_t=\rho\hat\sigma_{t-1}+\xi_t^0+\xi_{t-1}^1+\xi_{t-2}^2+\cdots+\xi_{t-p}^p.
$$

- **(F38) 风险信号状态向量，紧凑形式**：

$$
\Psi_{\hat\sigma,t}=P_{\hat\sigma}\Psi_{\hat\sigma,t-1}+\varepsilon_{\hat\sigma,t}.
$$

## 6. Steady-State Solution

论文在附录 C 报告稳态校准和目标，但 Markdown 来源中没有提供完整闭式 `steady_state_model` 顺序。因此本一稿只记录来源支撑的稳态关系，并将完整可执行顺序标为 `needs_review`。

- 变量按随机中性技术趋势 \(z_t^{\ast}\) 和确定性投资专用技术趋势 \(\Upsilon^t\) 缩放。由于投资专用技术进步，资本和投资增长快于消费/产出。
- 平衡增长缩放为：

$$
z_t^{\ast}=z_t\Upsilon^{\alpha t/(1-\alpha)}.
$$

- 资本、投资、消费、政府支出、货币、信贷和净值使用 \(z_t^{\ast}\)、\(P_t\) 和 \(\Upsilon^t\) 转换为平稳变量。
- 稳态校准用于匹配回报利差、权益债务比、税率、货币流通速度和金融摩擦目标。相较欧元区校准，美国模型使用更高的权益债务比和更高的外部融资利差。
- 附录指出稳态处 \(S=S'=0\) 且 \(S''>0\)；\(u=1\)，\(a(1)=0\)，\(a'(u)=r^k\)，\(a''(u)=\sigma_a r^k\)。
- **Needs review**：从原复制文件及相关 `.mat` 稳态值重建 Dynare 兼容的稳态求解顺序；本次未尝试。

## 7. Timing & Form Conventions

- 除非另有说明，变量均为平稳化后的缩放变量。模型包含随机中性技术趋势和确定性投资专用技术趋势。
- \(\bar k_{t+1}\) 是 \(t\) 期末购买并在下一生产周期使用的安装资本存量；生产方程使用经缩放后从上一期继承的期初资本。
- 企业家净值 \(n_{t+1}\) 在 \(t\) 期回报、债务结算、退出、进入和创业转移之后确定。
- 债务合约在 \(t\) 期末签订，并在 \(t+1\) 期冲击后偿付。基准设定中的企业家贷款利率 \(R_{t+1}^e\) 以名义非状态或有方式确定，产生 Fisher deflation channel。
- 风险 \(\sigma_t\) 影响企业家回报的横截面离散度。在基准模型中，它同时有已实现成分和预期信号成分。
- 货币政策规则用线性化帽变量表示，而多数其他附录均衡条件采用平稳化非线性缩放形式。
- Rep-MMB `US_CMR10_rep.mod` 交叉检查确认存在非线性 Dynare `model;` 块、并行弹性价格块和 AR(1) 式冲击方程；未执行运行验证。

## 8. Variable & Parameter Reference Table

| 类别 | 符号 / ASCII 交叉检查 | 含义 | 主要方程 |
|---|---|---|---|
| 内生 | `sU`, \(s_t\) | 边际成本 | (F1), (F2) |
| 内生 | `piU`, \(\pi_t\) | 毛通胀 | (F3)-(F5), (F20)-(F22), (F28) |
| 内生 | `pstarU`, \(p_t^{\ast}\) | 重设价格聚合对象 | (F3), (F6) |
| 内生 | `FpXU`, \(F_{p,t}\) | 价格设定辅助变量 | (F4), (F5) |
| 内生 | `YU`, \(Y_{z,t}\) | 缩放产出 | (F6), (F30) |
| 内生 | `qU`, \(q_t\) | 安装资本价格 | (F7), (F9), (F27), (F32) |
| 内生 | `iU`, \(i_t\) | 投资 | (F7), (F27), (F30) |
| 内生 | `kbarU`, \(\bar k_t\) | 安装资本存量 | (F27) |
| 内生 | `uU`, \(u_t\) | 资本利用率 | (F8), (F9) |
| 内生 | `rkU`, \(r_t^k\) | 资本租金率 | (F8), (F9) |
| 内生 | `RkXU`, \(R_t^k\) | 资本回报率 | (F9)-(F12), (F33) |
| 内生 | `omegabarU`, \(\bar\omega_t\) | 违约阈值 | (F10), (F11), (F33) |
| 内生 | `nU`, \(n_t\) | 企业家净值 | (F12), (F32), (F33) |
| 内生 | `evU`, \(e_{v,t}\) | 超额准备金/增加值比率 | (F13)-(F15) |
| 内生 | `mbU`, \(m_t^b\) | 基础货币 | (F13), (F14), (F29), (F31), (F34), (F35) |
| 内生 | `RXU`, \(R_t\) | 银行/短期政策利率对象 | (F15), (F17), (F28) |
| 内生 | `RaXU`, \(R_t^a\) | 基础货币资产回报 | (F15), (F24), (F26) |
| 内生 | `ReXU`, \(R_t^e\) | 企业家贷款融资利率 / 政策目标对象 | (F10), (F11), (F28) |
| 内生 | `RmXU`, \(R_t^m\) | 可交易存款回报 | (F16), (F25) |
| 内生 | `uzcU`, \(u_{c,t}^z\) | 缩放边际效用 | (F18), (F19) |
| 内生 | `lambdazU`, \(\lambda_{z,t}\) | 缩放预算乘子 | (F7), (F16), (F18), (F23)-(F26) |
| 内生 | `cU`, \(c_t\) | 消费 | (F18), (F19), (F30) |
| 内生 | `wU`, \(\tilde w_t\) | 实际工资 | (F17), (F20)-(F22), (F31), (F32) |
| 内生 | `hU`, `wstarU`, \(H_t,w_t^{\ast}\) | 劳动与工资重设对象 | (F20)-(F22) |
| 内生 | `dmU`, \(d_t^m\) | 可交易存款比率 | (F25), (F31) |
| 内生 | `btotU`, \(b_t^{Tot}\) | 银行贷款总量 | (F28), (F32) |
| 内生 | `mU`, \(m_t\) | 货币组合份额 | (F14), (F19), (F24)-(F26), (F35) |
| 内生 | `xU`, \(x_t\) | 基础货币增长成分 | (F29), (F35) |
| 外生 | `e_lambdafU`, \(\varepsilon_{\lambda_f,t}\) | 价格加成创新 | (F36) |
| 外生 | `e_pitargetU`, \(\varepsilon_{\pi^{\ast},t}\) | 通胀目标创新 | (F36) |
| 外生 | `e_xbU`, \(\varepsilon_{x^b,t}\) | 银行技术创新 | (F36) |
| 外生 | `e_muupU`, \(\varepsilon_{\mu_\Upsilon,t}\) | 投资专用技术创新 | (F36) |
| 外生 | `e_chiiU`, \(\varepsilon_{\chi,t}\) | 货币需求/流动性创新 | (F36) |
| 外生 | `e_gU`, \(\varepsilon_{g,t}\) | 政府支出创新 | (F36) |
| 外生 | `e_muzstarU`, \(\varepsilon_{\mu_z^{\ast},t}\) | 永久技术创新 | (F36) |
| 外生 | `e_gammaU`, \(\varepsilon_{\gamma,t}\) | 金融财富创新 | (F36) |
| 外生 | `e_epsilU`, \(\varepsilon_{\epsilon,t}\) | 暂时生产率创新 | (F36) |
| 外生 | `e_sigmaU`, \(\varepsilon_{\sigma,t}\) | 风险冲击创新 | (F36)-(F38) |
| 外生 | `e_zetaiU`, \(\varepsilon_{\zeta_i,t}\) | 投资边际效率创新 | (F36) |
| 外生 | `e_tauoU`, \(\varepsilon_{\tau^{oil},t}\) | 油价创新 | (F36) |
| 外生 | `e_xpU`, \(\varepsilon_t\) | 货币政策创新 | (F28) |
| 参数 | \(\alpha,\beta,\delta,\Upsilon,\mu,\gamma,\xi_p,\xi_w,\lambda_f,\lambda_w,\psi_k,\psi_l,\tau,\Theta,\rho_i,\alpha_\pi,\alpha_{\Delta y},\alpha_{\Delta\pi}\) | 技术、偏好、金融摩擦、Calvo、营运资本和政策参数 | all |
