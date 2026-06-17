# US_CMR14noFA -- 推导（最优化问题 + 一阶条件）

> MMB 档案一阶段提取。公式状态：`needs_review`；方程依据论文 Markdown 和无金融摩擦实现交叉检查整理。未打开 PDF 正文，也未运行 Dynare。

## 1. Model Overview

- **模型 ID**：`US_CMR14noFA`。
- **论文**：Christiano, Lawrence J.; Motto, Roberto; Rostagno, Massimo (2014), "Risk shocks," *American Economic Review* 104(1), 27-65, DOI `10.1257/aer.104.1.27`。
- **主要来源**：`raw/mmb_mineru/runs/us_cmr14_us_cmr14nofa__risk_shocks__d33971b2/full.md`；原始 PDF 记录为 `raw/mmb_papers/Risk shocks.pdf`。
- **模型变体**：不含金融摩擦的 CEE 型模型。论文说明该版本通过加入家庭资本跨期 Euler 方程，并删去企业家合约最优性、银行零利润、企业家净值运动方程以及资源约束中的监控成本得到。
- **主体**：最终品聚合商、带 Calvo 定价的垄断竞争中间品企业、消费储蓄并建设原始资本的家庭、通过 Calvo 工资设定供给差异化劳动的工会、政府需求和货币当局。
- **形式**：用于一阶对数线性求解和估计的平稳化非线性均衡条件。本条目在可得处记录非线性平稳化条件，并将来源或实现归一化疑点标为 `needs_review`。
- **运行验证**：未执行；没有运行 Dynare。

## 2. Optimization Problems

### 最终品聚合商

竞争性最终品生产者选择差异化投入 $Y_{jt}$ 生产同质最终品：

$$
Y_t=\left[\int_0^1Y_{jt}^{1/\lambda_{f,t}}\,dj\right]^{\lambda_{f,t}},\qquad 1\leq \lambda_{f,t}<\infty .
$$

### 中间品企业

中间品生产者租用有效资本服务并雇用同质劳动：

$$
Y_{jt}=\epsilon_t K_{jt}^{\alpha}(z_t l_{jt})^{1-\alpha}-\Phi z_t^* .
$$

企业在 Calvo 摩擦下设定价格。未重新定价的企业按目标通胀和滞后通胀指数化：

$$
\tilde{\pi}_t=(\pi_t^{target})^{\iota}(\pi_{t-1})^{1-\iota}.
$$

### 家庭与资本生产

家庭选择消费、一期债券、长期债券、投资和原始资本，并建设期末原始资本：

$$
\bar K_{t+1}=(1-\delta)\bar K_t+\left[1-S\left(\zeta_{I,t}I_t/I_{t-1}\right)\right]I_t .
$$

偏好为：

$$
E_0\sum_{t=0}^{\infty}\beta^t\zeta_{c,t}
\left[
\log(C_t-bC_{t-1})
-\psi_L\int_0^1\frac{h_{it}^{1+\sigma_L}}{1+\sigma_L}\,di
\right].
$$

家庭预算约束包含消费税、工资税、一时期债券、长期债券、按投资专有技术定价的投资品、资本买卖以及一次总付利润/转移：

$$
\begin{aligned}
(1+\tau^c)P_tC_t+B_{t+1}+B^L_{t+40}
+\frac{P_t}{\Upsilon^t\mu_{\Upsilon,t}}I_t+Q_{\bar K,t}(1-\delta)\bar K_t
\leq {} &(1-\tau^l)\int_0^1W^i_th_{it}\,di+R_tB_t \\
&+(R_t^L)^{40}B_t^L+Q_{\bar K,t}\bar K_{t+1}+\Pi_t .
\end{aligned}
$$

### 劳动工会

每个家庭包含所有差异化劳动类型。垄断工会在 Calvo 工资摩擦下设定工资。未重新设定的工资满足：

$$
W_{it}=(\mu_{z^*,t})^{\iota_\mu}(\mu_{z^*})^{1-\iota_\mu}\tilde{\pi}_{w,t}W_{i,t-1},
\qquad
\tilde{\pi}_{w,t}=(\pi_t^{target})^{\iota_w}(\pi_{t-1})^{1-\iota_w}.
$$

## 3. First-Order Conditions

**价格设定与生产**

- **(F1) 重设价格指数递推**（`needs_review`；实现交叉检查 Eqn 1）：

$$
p_t^*=
\left[
(1-\xi_p)\left(\frac{K_{p,t}}{F_{p,t}}\right)^{\lambda_{f,t}/(1-\lambda_{f,t})}
+\xi_p\left(\frac{\tilde{\pi}_t}{\pi_t}p_{t-1}^*\right)^{\lambda_{f,t}/(1-\lambda_{f,t})}
\right]^{(1-\lambda_{f,t})/\lambda_{f,t}} .
$$

- **(F2) 价格辅助变量 $F_p$ 递推**（`needs_review`；实现交叉检查 Eqn 2）：

$$
F_{p,t}=\zeta_{c,t}\lambda_{z,t}Y_{z,t}
+\beta\xi_pE_t\left[
\left(\frac{\tilde{\pi}_{t+1}}{\pi_{t+1}}\right)^{1/(1-\lambda_{f,t+1})}F_{p,t+1}
\right].
$$

- **(F3) 价格辅助变量 $K_p$ 递推**（`needs_review`；实现交叉检查 Eqn 3）：

$$
K_{p,t}=\zeta_{c,t}\lambda_{f,t}\lambda_{z,t}Y_{z,t}s_t
+\beta\xi_pE_t\left[
\left(\frac{\tilde{\pi}_{t+1}}{\pi_{t+1}}\right)^{\lambda_{f,t+1}/(1-\lambda_{f,t+1})}K_{p,t+1}
\right].
$$

- **(F4) 平稳化产出定义**（`needs_review`；来源生产函数与实现交叉检查辅助变量 `yz`）：

$$
Y_{z,t}=(p_t^*)^{\lambda_{f,t}/(\lambda_{f,t}-1)}
\left[
\epsilon_t\left(u_t\frac{\bar k_{t-1}}{\mu_{z^*,t}\Upsilon}\right)^{\alpha}
\left(H_t(w_t^*)^{\lambda_w/(\lambda_w-1)}\right)^{1-\alpha}
-\phi
\right].
$$

- **(F5) 资本利用率条件**（`needs_review`；实现交叉检查 Eqn 9）：

$$
r^k_t=\tau_t^{oil}r^k_{ss}\exp\{\sigma_a(u_t-1)\}.
$$

- **(F6) 资本服务租金率**（`needs_review`；实现交叉检查 Eqn 10）：

$$
r^k_t=\alpha\epsilon_t
\left(\frac{\Upsilon\mu_{z^*,t}H_t(w_t^*)^{\lambda_w/(\lambda_w-1)}}{u_t\bar k_{t-1}}\right)^{1-\alpha}s_t .
$$

- **(F7) 边际成本**（`needs_review`；实现交叉检查 Eqn 11）：

$$
s_t=\frac{(r^k_t/\alpha)^\alpha(\tilde w_t/(1-\alpha))^{1-\alpha}}{\epsilon_t}.
$$

**家庭、资本和投资**

- **(F8) 资本积累**（`needs_review`；来源方程 6 与实现交叉检查 Eqn 13）：

$$
\bar k_t=(1-\delta)\frac{\bar k_{t-1}}{\mu_{z^*,t}\Upsilon}
+\left[1-S\left(\zeta_{I,t}\mu_{z^*,t}\Upsilon I_t/I_{t-1}\right)\right]I_t .
$$

- **(F9) 无风险债券 Euler 方程**（`needs_review`；实现交叉检查 Eqn 14）：

$$
\zeta_{c,t}\lambda_{z,t}
=\beta E_t\left[
\frac{\zeta_{c,t+1}\lambda_{z,t+1}}{\mu_{z^*,t+1}\pi_{t+1}}
\left(1+(1-\tau^d)R_t^e\right)
\right].
$$

- **(F10) 带习惯的消费边际效用**（`needs_review`；实现交叉检查 Eqn 15）：

$$
(1+\tau^c)\zeta_{c,t}\lambda_{z,t}
=\frac{\mu_{z^*,t}\zeta_{c,t}}{C_t\mu_{z^*,t}-bC_{t-1}}
-\beta bE_t\left[\frac{\zeta_{c,t+1}}{C_{t+1}\mu_{z^*,t+1}-bC_t}\right].
$$

- **(F11) 无金融摩擦资本 Euler 方程**（`needs_review`；论文说明该式替代金融加速器块；实现交叉检查 Eqn 16）：

$$
\zeta_{c,t}\lambda_{z,t}
=\beta E_t\left[
\frac{\zeta_{c,t+1}\lambda_{z,t+1}}{\mu_{z^*,t+1}\pi_{t+1}}
(1+R^k_{t+1})
\right].
$$

- **(F12) 资本回报率**（`needs_review`；来源方程 10 与实现交叉检查 Eqn 17）：

$$
1+R^k_t=
\frac{\left[(1-\tau^k)\left(u_tr^k_t-\tau_t^{oil}a(u_t)\right)+(1-\delta)q_t\right]\pi_t}
\{\Upsilon q_{t-1}\}
+\tau^k\delta .
$$

- **(F13) 投资/Tobin's Q 条件**（`needs_review`；实现交叉检查 Eqn 18）：

$$
0=-\frac{\zeta_{c,t}\lambda_{z,t}}{\mu_{\Upsilon,t}}
+\zeta_{c,t}\lambda_{z,t}q_t
\left[
1-S_t-S'_t\frac{\zeta_{I,t}\mu_{z^*,t}\Upsilon I_t}{I_{t-1}}
\right]
+\beta E_t\left[
\frac{\zeta_{c,t+1}\lambda_{z,t+1}q_{t+1}S'_{t+1}}{\mu_{z^*,t+1}\Upsilon}
\left(\frac{\zeta_{I,t+1}\mu_{z^*,t+1}\Upsilon I_{t+1}}{I_t}\right)^2
\right].
$$

**工资设定**

- **(F14) 重设工资递推**（`needs_review`；实现交叉检查 Eqn 8）：

$$
w_t^*=
\left[
(1-\xi_w)A_{w,t}^{\lambda_w}
+\xi_w\left(\frac{\tilde{\pi}_{w,t}}{\pi_{w,t}}
\mu_{z^*}^{1-\iota_\mu}\mu_{z^*,t}^{\iota_\mu}w_{t-1}^*\right)^{\lambda_w/(1-\lambda_w)}
\right]^{(1-\lambda_w)/\lambda_w},
$$

其中 $A_{w,t}$ 是工资聚合器隐含的标准 Calvo 工资调整项；其精确 OCR 归一化表达仍为 `needs_review`。

- **(F15) 工资辅助变量 $F_w$ 递推**（`needs_review`；实现交叉检查 Eqn 5）：

$$
F_{w,t}=\zeta_{c,t}\lambda_{z,t}(w_t^*)^{\lambda_w/(\lambda_w-1)}H_t\frac{1-\tau^l}{\lambda_w}
+\beta\xi_wE_t\left[\mathcal I^F_{w,t+1}F_{w,t+1}\right].
$$

- **(F16) 工资辅助变量 $K_w$ 递推**（`needs_review`；实现交叉检查 Eqn 6）：

$$
K_{w,t}=\zeta_{c,t}\left[(w_t^*)^{\lambda_w/(\lambda_w-1)}H_t\right]^{1+\sigma_L}
+\beta\xi_wE_t\left[\mathcal I^K_{w,t+1}K_{w,t+1}\right].
$$

指数化核 $\mathcal I^F_{w,t+1}$ 和 $\mathcal I^K_{w,t+1}$ 依赖工资通胀、目标通胀和 $\mu_{z^*,t+1}$；精确归一化仍为 `needs_review`。

## 4. Market Clearing & Identities

- **(F17) 无监控成本的资源约束**（`needs_review`；实现交叉检查 Eqn 12）：

$$
Y_{z,t}=g_t+C_t+\frac{I_t}{\mu_{\Upsilon,t}}
+\tau_t^{oil}a(u_t)\frac{\bar k_{t-1}}{\mu_{z^*,t}\Upsilon}.
$$

- **(F18) 最终产出会计恒等式**（`needs_review`；实现交叉检查辅助变量 `y`）：

$$
Y_t=g_t+C_t+\frac{I_t}{\mu_{\Upsilon,t}}.
$$

- **(F19) GDP 增长观测恒等式**（`needs_review`；实现交叉检查观测方程）：

$$
gdp\_obs_t=
\frac{C_t+I_t/\mu_{\Upsilon,t}+g_t}{C_{t-1}+I_{t-1}/\mu_{\Upsilon,t-1}+g_{t-1}}
\frac{\mu_{z^*,t}}{\mu_{z^*}} .
$$

- **(F20) 消费增长观测恒等式**（`needs_review`；实现交叉检查观测方程）：

$$
consumption\_obs_t=\frac{C_t}{C_{t-1}}\frac{\mu_{z^*,t}}{\mu_{z^*}} .
$$

- **(F21) 投资增长观测恒等式**（`needs_review`；实现交叉检查观测方程）：

$$
investment\_obs_t=\frac{I_t}{I_{t-1}}\frac{\mu_{z^*,t}}{\mu_{z^*}} .
$$

- **(F22) 相对投资品价格观测恒等式**（`needs_review`；实现交叉检查观测方程）：

$$
pinvest\_obs_t=\frac{\mu_{\Upsilon,t-1}}{\mu_{\Upsilon,t}} .
$$

- **(F23) 实际无风险利率观测恒等式**（`needs_review`；实现交叉检查观测方程）：

$$
RealRe\_obs_t=
\frac{(1+R^e_t)/\pi_{t+1}}{(1+R^e)/\pi}.
$$

## 5. Exogenous Processes

- **(F24) 货币政策规则**（`needs_review`；论文方程 18 与实现交叉检查 Eqn 20）：

$$
\log\left(\frac{R^e_t}{R^e}\right)
=\rho_p\log\left(\frac{R^e_{t-1}}{R^e}\right)
+\frac{1-\rho_p}{R^e}\left[
\alpha_\pi\pi\log\left(\frac{\pi_{t+1}}{\pi_t^{target}}\right)
+\frac{\alpha_{\Delta y}}{4}\mu_{z^*}\log(gdp\_obs_t)
\right].
$$

- **(F25) 暂时性技术冲击**：

$$
\log(\epsilon_t/\epsilon)=\rho_\epsilon\log(\epsilon_{t-1}/\epsilon)+e_{\epsilon,t}.
$$

- **(F26) 政府需求**：

$$
\log(g_t/g)=\rho_g\log(g_{t-1}/g)+e_{g,t}.
$$

- **(F27) 价格加成冲击**：

$$
\log(\lambda_{f,t}/\lambda_f)=\rho_{\lambda_f}\log(\lambda_{f,t-1}/\lambda_f)+e_{\lambda_f,t}.
$$

- **(F28) 投资专有技术冲击**：

$$
\log(\mu_{\Upsilon,t}/\mu_\Upsilon)=\rho_{\mu_\Upsilon}\log(\mu_{\Upsilon,t-1}/\mu_\Upsilon)+e_{\mu_\Upsilon,t}.
$$

- **(F29) 持久增长冲击**：

$$
\log(\mu_{z^*,t}/\mu_{z^*})=\rho_{\mu_z}\log(\mu_{z^*,t-1}/\mu_{z^*})+e_{\mu_z,t}.
$$

- **(F30) 通胀目标冲击**：

$$
\log(\pi_t^{target}/\pi^{target})=\rho_{\pi^*}\log(\pi_{t-1}^{target}/\pi^{target})+e_{\pi^*,t}.
$$

- **(F31) 消费偏好冲击**：

$$
\log(\zeta_{c,t}/\zeta_c)=\rho_{\zeta_c}\log(\zeta_{c,t-1}/\zeta_c)+e_{\zeta_c,t}.
$$

- **(F32) 投资边际效率冲击**：

$$
\log(\zeta_{I,t}/\zeta_I)=\rho_{\zeta_I}\log(\zeta_{I,t-1}/\zeta_I)+e_{\zeta_I,t}.
$$

风险冲击 $\sigma_t$、权益冲击 $\gamma_t$、信用利差观测变量、信贷观测变量、净值观测变量和期限溢价冲击在 `US_CMR14noFA` 中不活跃；`.mod` 仅保留上述非金融冲击集合。

## 6. Steady-State Solution

论文正文给出稳态增长和校准目标，而不是完整可手工求解的 `steady_state_model`。本一阶段条目记录有来源支撑的顺序：

1. 将归一化冲击设在均值：
   $\epsilon=1$, $\mu_\Upsilon=1$, $\zeta_c=1$, $\zeta_I=1$, $\lambda_f=1.2$, $\pi^{target}=\pi=1.006010795406775$, $\mu_{z^*}=1.004124413586981$。
2. 固定校准参数：
   $\beta=0.998704208591811$, $\delta=0.025$, $\alpha=0.4$, $\lambda_w=1.05$, $\tau^c=0.047$, $\tau^l=0.241$, $\tau^k=0.32$, $\psi_L=0.7705$。
3. 归一化利用率和资本价格：
   $u=1$, $q=1$, $p^*=1$, $w^*=1$。
4. 用债券 Euler 方程和通胀目标确定稳态名义净无风险利率 $R^e$。
5. 用利用率、租金率、边际成本、生产和零利润固定成本条件求解 $r^k$, $s$, $\bar k$, $H$, $Y_z$, $\phi$。
6. 在稳态 $S=0$ 且 $S'=0$ 时，由资本积累求投资：
   $$I=\left[1-\frac{1-\delta}{\mu_{z^*}\Upsilon}\right]\bar k.$$
7. 设定政府支出使 $g/(C+I)=\eta_g/(1-\eta_g)$，等价于校准稳态中的 $g/Y=0.20$。
8. 用资源约束和消费 FOC 确定 $C$, $\lambda_z$ 以及工资和价格块辅助变量 $F_w,K_w,F_p,K_p$。

实现交叉检查稳态值包括 $C=1.72001$, $I=1.28368$, $g=0.771211$, $\bar k=38.7956$, $H=1.08818$, $Y=3.7749$, $q=1$, $u=1$, $R^e=0.0114707$, $R^k=0.0114707$, $r^k=0.0392464$, $s=0.833333$。这些数值记录为 `implementation_cross_check`，不是论文侧推导证据。

## 7. Timing & Form Conventions

- $\bar k_t$ 是期末原始资本。第 $t$ 期生产使用按 $\mu_{z^*,t}\Upsilon$ 缩放并由利用率 $u_t$ 调整后的 $\bar k_{t-1}$。
- 无金融摩擦模型使用关于 $R^k_{t+1}$ 的家庭资本 Euler 方程；不包含企业家杠杆、违约阈值、信用利差或净值动态。
- 价格和工资设定均为 Calvo，并对滞后通胀和通胀目标指数化；工资指数化还使用稳态和当期增长项。
- 模型围绕平稳化非线性均衡进行一阶近似。观测方程按照数据变换报告增长率和水平偏离。
- 运行验证、残差检查、BK 检查、IRF 和方程数量核对均推迟处理。

## 8. Variable & Parameter Reference Table

| 类别 | 符号 / ASCII 名 | 含义 | 由哪条方程决定 |
|---|---|---|---|
| 内生 | `c`, $C_t$ | 消费 | (F10), (F17) |
| 内生 | `i`, $I_t$ | 投资 | (F13), (F17) |
| 内生 | `kbar`, $\bar k_t$ | 期末原始资本 | (F8) |
| 内生 | `q`, $q_t$ | 已安装/原始资本价格 | (F13) |
| 内生 | `u`, $u_t$ | 资本利用率 | (F5) |
| 内生 | `rk`, $r_t^k$ | 资本服务租金率 | (F5), (F6) |
| 内生 | `Rk`, $R_t^k$ | 资本回报率约定 | (F11), (F12) |
| 内生 | `Re`, $R_t^e$ | 无风险政策/债券利率 | (F9), (F24) |
| 内生 | `pi`, $\pi_t$ | 通胀 | (F1)-(F3), (F24) |
| 内生 | `pitarget`, $\pi_t^{target}$ | 通胀目标 | (F30) |
| 内生 | `pstar`, $p_t^*$ | 重设相对价格 | (F1) |
| 内生 | `Fp`, $F_{p,t}$ | 价格设定辅助变量 | (F2) |
| 内生 | `s`, $s_t$ | 边际成本 | (F7) |
| 内生 | `h`, $H_t$ | 工时 / 同质劳动 | (F4), (F15)-(F16) |
| 内生 | `wstar`, $w_t^*$ | 重设工资 | (F14) |
| 内生 | `wtilde`, $\tilde w_t$ | 平稳化实际工资 | (F7), 工资块 |
| 内生 | `Fw`, $F_{w,t}$ | 工资设定辅助变量 | (F15) |
| 内生 | `g`, $g_t$ | 政府需求 | (F26) |
| 内生 | `y`, $Y_t$ | 产出恒等式 | (F18) |
| 内生 | `epsil`, $\epsilon_t$ | 暂时性技术水平 | (F25) |
| 内生 | `lambdaf`, $\lambda_{f,t}$ | 价格加成冲击 | (F27) |
| 内生 | `muup`, $\mu_{\Upsilon,t}$ | 投资专有技术 | (F28) |
| 内生 | `muzstar`, $\mu_{z^*,t}$ | 平稳增长因子 | (F29) |
| 内生 | `zetac`, $\zeta_{c,t}$ | 消费偏好扰动 | (F31) |
| 内生 | `zetai`, $\zeta_{I,t}$ | 投资边际效率 | (F32) |
| 内生 | `*_obs` | 观测变量测量方程 | (F19)-(F23) |
| 外生 | `e_epsil` | 暂时性技术创新 | (F25) |
| 外生 | `e_lambdaf` | 价格加成创新 | (F27) |
| 外生 | `e_muup` | 投资专有技术创新 | (F28) |
| 外生 | `e_muzstar` | 持久增长创新 | (F29) |
| 外生 | `e_pitarget` | 通胀目标创新 | (F30) |
| 外生 | `e_zetac` | 偏好冲击创新 | (F31) |
| 外生 | `e_zetai` | 投资边际效率创新 | (F32) |
| 外生 | `e_g` | 政府需求创新 | (F26) |
| 参数 | `beta_p`, $\beta$ | 贴现因子 | -- |
| 参数 | `alpha_p`, $\alpha$ | 资本份额 | -- |
| 参数 | `delta_p`, $\delta$ | 折旧率 | -- |
| 参数 | `xip_p`, $\xi_p$ | Calvo 价格黏性 | -- |
| 参数 | `xiw_p`, $\xi_w$ | Calvo 工资黏性 | -- |
| 参数 | `lambdaf_p`, $\lambda_f$ | 稳态价格加成 | -- |
| 参数 | `lambdaw_p`, $\lambda_w$ | 稳态工资加成 | -- |
| 参数 | `b_p`, $b$ | 习惯持久性 | -- |
| 参数 | `sigmaL_p`, $\sigma_L$ | 劳动负效用曲率 | -- |
| 参数 | `Sdoupr_p`, $S''$ | 投资调整成本曲率 | -- |
| 参数 | `rhotil_p`, $\rho_p$ | 政策平滑 | -- |
| 参数 | `aptil_p`, $\alpha_\pi$ | 政策对通胀反应 | -- |
| 参数 | `adytil_p`, $\alpha_{\Delta y}$ | 政策对产出增长反应 | -- |
| 参数 | `rho*`, `std*` | 冲击持续性和创新尺度 | -- |
