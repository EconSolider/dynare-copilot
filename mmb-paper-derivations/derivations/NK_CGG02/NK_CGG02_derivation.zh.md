# NK_CGG02 - 推导（最优化问题 + 一阶条件）

> 状态：`needs_review`。本第一版归档条目以 Clarida、Gali 和 Gertler (2002) 的 MinerU Markdown 为来源。未执行运行时验证。

来源：Richard Clarida, Jordi Gali, and Mark Gertler, "A simple framework for international monetary policy analysis," Journal of Monetary Economics 49(5), 879-904, 2002。本地索引中的 DOI 字段：`10.3386/w8870`。

## 1. Model Overview

- **模型**：两国开放经济新凯恩斯框架，包含完全国际风险分担、本国与外国粘性价格、产品市场垄断竞争、具有垄断竞争特征但工资灵活的劳动供给，以及由外生工资加成变化产生的成本推动冲击。
- **MMB 实现范围**：`NK_CGG02` 使用论文中的 Nash/相机抉择对数线性模块：本国和外国 IS 方程、Phillips 曲线、本国自然产出定义、自然实际利率、技术与成本推动冲击的 AR 过程，以及 Taylor 型利率规则。论文还推导了合作政策公式；这些仅作为来源背景，不作为已检查 `.mod` 的基准实现。
- **主体**：本国和外国家庭；最终品企业；中间品企业；本国和外国中央银行；在政策稳态中设定就业补贴的财政当局。
- **模型形式**：MMB 实现交叉检查中为 `model(linear)`。小写变量表示相对于确定性稳态的对数偏离；产出缺口是相对于自然产出概念的偏离。
- **公式质量**：主要均衡方程在 MinerU Markdown 中可读。最优定价目标以及若干后续政策规则系数存在 OCR 痕迹，因此第一版公式状态保持为 `needs_review`。

## 2. Optimization Problems

### 家庭

本国家庭选择消费、劳动供给和状态或有资产组合。其复合消费和 CPI 为：

$$
C_t \equiv C_{H,t}^{1-\gamma} C_{F,t}^{\gamma},
\qquad
P_t = k^{-1} P_{H,t}^{1-\gamma} P_{F,t}^{\gamma}
    = k^{-1} P_{H,t} S_t^{\gamma},
$$

其中 $S_t=P_{F,t}/P_{H,t}$ 且 $k=(1-\gamma)^{1-\gamma}\gamma^\gamma$。

本国代表性家庭最大化：

$$
E_0 \sum_{t=0}^{\infty} \beta^t
\left[
\frac{C_t^{1-\sigma}}{1-\sigma}
- \frac{N_t(h)^{1+\phi}}{1+\phi}
\right]
$$

并满足名义预算约束和劳动需求曲线：

$$
P_t C_t + E_t\{Q_{t,t+1}D_{t+1}\}
= W_t(h)N_t(h)+D_t-T_t+\Gamma_t,
$$

$$
N_t(h)=\left(\frac{W_t(h)}{W_t}\right)^{-\eta_t}N_t.
$$

### 最终品企业

最终品企业聚合中间品品种：

$$
Y_t=\left(\int_0^1 Y_t(f)^{(\xi-1)/\xi}\,df\right)^{\xi/(\xi-1)}.
$$

利润最大化给出品种需求和本国价格指数：

$$
Y_t(f)=\left(\frac{P_{H,t}(f)}{P_{H,t}}\right)^{-\xi}Y_t,
\qquad
P_{H,t}=\left(\int_0^1 P_{H,t}(f)^{1-\xi}\,df\right)^{1/(1-\xi)}.
$$

### 中间品企业

中间品企业使用线性劳动技术：

$$
Y_t(f)=A_t N_t(f),
$$

劳动由差异化家庭劳动聚合而成：

$$
N_t(f)=\left(\frac{1}{1-\gamma}\int_0^{1-\gamma}
N_t(h)^{(\eta_t-1)/\eta_t}\,dh\right)^{\eta_t/(\eta_t-1)}.
$$

每个中间品企业获得工资账单补贴 $\tau$，进行成本最小化，并按照 Calvo 机制设定价格，其中不能重新定价的概率为 $\theta$。

### 货币当局

论文从二次福利近似中推导相机抉择最优政策。MMB 交叉检查实现了根据本国和外国通胀校准的 Taylor 型利率规则：

$$
r_t = \phi_\pi \pi_t + \varepsilon^r_t,
\qquad
r_t^* = \phi_\pi \pi_t^* + \varepsilon^{r,*}_t.
$$

## 3. First-Order Conditions

- **(F1) 本国商品的本国支出份额**：

$$
P_{H,t} C_{H,t}=(1-\gamma)P_t C_t.
$$

- **(F2) 外国商品的本国支出份额**：

$$
P_{F,t} C_{F,t}=\gamma P_t C_t.
$$

- **(F3) 随机贴现因子**：

$$
\beta\left(\frac{C_{t+1}}{C_t}\right)^{-\sigma}
\left(\frac{P_t}{P_{t+1}}\right)=Q_{t,t+1}.
$$

- **(F4) 消费 Euler 方程**：

$$
1=\beta R_t E_t\left[
\left(\frac{C_{t+1}}{C_t}\right)^{-\sigma}
\left(\frac{P_t}{P_{t+1}}\right)
\right].
$$

- **(F5) 含灵活工资加成的劳动供给**：

$$
\frac{W_t(h)}{P_t}=(1+\mu_t^w)N_t(h)^\phi C_t^\sigma,
\qquad
\mu_t^w=\frac{1}{\eta_t-1}.
$$

- **(F6) 国际风险分担条件**：

$$
C_t=C_t^*.
$$

- **(F7) 实际边际成本**：

$$
MC_t=\frac{(1-\tau)(W_t/P_{H,t})}{A_t}
=\frac{(1-\tau)(W_t/P_t)S_t^\gamma}{kA_t}.
$$

- **(F8) Calvo 重设价格条件**：

$$
E_t\sum_{j=0}^{\infty}\theta^j Q_{t,t+j}Y_{t+j}(f)
\left[P^0_{H,t}-(1+\mu^p)P_{H,t+j}MC_{t+j}\right]=0.
$$

上述目标函数的来源 Markdown 存在符号/字符 OCR 损伤，但结果性的重设价格条件可读。

- **(F9) 灵活价格加成条件**：

$$
\frac{P^0_{H,t}}{P_{H,t}}=(1+\mu^p)MC_t.
$$

- **(F10) 粘性价格 Phillips 曲线**：

$$
\pi_t=\beta E_t\{\pi_{t+1}\}+\delta mc_t,
\qquad
\delta=\frac{(1-\theta)(1-\beta\theta)}{\theta}.
$$

- **(F11) 用本国产出缺口表示的边际成本**：

$$
mc_t=\kappa \tilde{y}_t+\mu_t^w.
$$

- **(F12) 产出缺口形式的本国 IS 曲线**：

$$
\tilde{y}_t=E_t\{\tilde{y}_{t+1}\}
-\sigma_0^{-1}\left[
r_t-E_t\{\pi_{t+1}\}-\overline{rr}_t
\right].
$$

- **(F13) 产出缺口形式的本国 Phillips 曲线**：

$$
\pi_t=\beta E_t\{\pi_{t+1}\}+\lambda\tilde{y}_t+u_t,
\qquad
\lambda=\delta\kappa.
$$

- **(F14) Nash 相机抉择目标条件**：

$$
\tilde{y}_t=-\frac{\lambda}{\alpha}\pi_t=-\xi\pi_t.
$$

- **(F15) Nash 简化式本国通胀**：

$$
\pi_t=\psi u_t,
\qquad
\psi=\left[(1-\beta\rho)+\lambda\xi\right]^{-1}.
$$

- **(F16) Nash 简化式本国产出缺口**：

$$
\tilde{y}_t=-\xi\psi u_t.
$$

- **(F17) Nash 利率实现规则**（OCR 中的系数 `needs_review`）：

$$
r_t=\overline{rr}_t+\vartheta E_t\{\pi_{t+1}\},
\qquad
\vartheta=1+\frac{\xi\sigma_0(1-\rho)}{\rho}.
$$

来源行将预期通胀前的系数打印为类似 OCR 的 `9`；上下文定义说明该系数应为 $\vartheta$。

## 4. Market Clearing & Identities

- **(F18) 本国商品市场出清**：

$$
(1-\gamma)Y_t=(1-\gamma)C_{H,t}+\gamma C^*_{H,t}.
$$

- **(F19) 外国商品市场出清**：

$$
\gamma Y_t^*=(1-\gamma)C_{F,t}+\gamma C^*_{F,t}.
$$

- **(F20) 购买力平价/一价定律下的 CPI 实际汇率**：

$$
\frac{\varepsilon_t P_t^*}{P_t}=1.
$$

- **(F21) 本国贸易平衡**：

$$
P_{H,t}Y_t=P_t C_t.
$$

- **(F22) 外国贸易平衡**：

$$
P^*_{F,t}Y_t^*=P_t^* C_t^*.
$$

- **(F23) 总需求与贸易条件**：

$$
Y_t=k^{-1}C_t S_t^\gamma,
\qquad
S_t=\frac{Y_t}{Y_t^*}.
$$

- **(F24) 作为本国和外国产出函数的消费**：

$$
C_t=kY_t^{1-\gamma}(Y_t^*)^\gamma.
$$

- **(F25) 含价格离散度的总生产函数**：

$$
Y_t=\frac{A_tN_t}{V_t},
\qquad
V_t=\int_0^1\left(\frac{P_t(f)}{P_t}\right)^{-\xi}df\ge 1.
$$

- **(F26) 作为产出水平函数的边际成本**：

$$
MC_t=(1-\tau)k^{\sigma-1}(1+\mu_t^w)
A_t^{-(1+\phi)}Y_t^\kappa(Y_t^*)^{\kappa_0}V_t^\phi.
$$

- **(F27) 开放经济边际成本弹性**：

$$
\kappa\equiv\sigma(1-\gamma)+\gamma+\phi=\sigma+\phi-\kappa_0,
\qquad
\kappa_0\equiv\sigma\gamma-\gamma=\gamma(\sigma-1).
$$

- **(F28) 本国自然产出**：

$$
\bar{y}_t=\kappa^{-1}\left[(1+\phi)a_t-\kappa_0y_t^*\right].
$$

- **(F29) 自然实际利率**：

$$
\overline{rr}_t=\sigma_0E_t\{\Delta\bar{y}_{t+1}\}
+\kappa_0E_t\{\Delta y^*_{t+1}\},
\qquad
\sigma_0=\sigma-\kappa_0.
$$

- **(F30) 对数偏离形式的贸易条件**：

$$
s_t=y_t-y_t^*
=\left(\tilde{y}_t-\tilde{y}_t^*\right)+\left(\bar{y}_t-\bar{y}_t^*\right).
$$

- **(F31) 名义汇率恒等式**：

$$
e_t=e_{t-1}+s_t-s_{t-1}+\pi_t-\pi_t^*.
$$

## 5. Exogenous Processes

- **(F32) 成本推动冲击**：

$$
u_t=\rho u_{t-1}+\varepsilon_t.
$$

- **(F33) 实现交叉检查中使用的本国技术过程**：

$$
a_t=\rho_a a_{t-1}+\varepsilon^a_t.
$$

- **(F34) 实现交叉检查中使用的外国技术过程**：

$$
a_t^*=\rho_a a_{t-1}^*+\varepsilon^{a,*}_t.
$$

- **(F35) 实现交叉检查中使用的外国成本推动过程**：

$$
u_t^*=\rho_u u_{t-1}^*+\varepsilon_t^{u,*}.
$$

- **(F36) 实现交叉检查中的外国产出过程/冲击**：

$$
\tilde{y}_t^*
=E_t\{\tilde{y}_{t+1}^*\}
-\sigma_0^{-1}\left[
r_t^*-E_t\{\pi^*_{t+1}\}-\overline{rr}_t^*
\right]
+\varepsilon_t^{y,*}.
$$

论文以解析方式给出对称外国模块。额外的外国产出创新存在于 `NK_CGG02_rep.mod`，因此这里只记录为 `implementation_cross_check`。

## 6. Steady-State Solution

归档的 MMB 实现是线性化模型，因此所有对数偏离内生变量的计算稳态为零：

$$
y_t=\tilde{y}_t=\bar{y}_t=\pi_t=r_t=\overline{rr}_t=u_t=a_t=0,
$$

外国星号变量同理。线性化背后的确定性总量稳态满足：

$$
S=1,\qquad C=C^*,\qquad \Pi=\Pi^*=1,\qquad V=1.
$$

线性模块使用的开放经济复合参数为：

$$
\kappa_0=\gamma(\sigma-1),\qquad
\kappa=\sigma+\phi-\kappa_0,\qquad
\sigma_0=\sigma-\kappa_0,\qquad
\delta=\frac{(1-\theta)(1-\beta\theta)}{\theta},\qquad
\lambda=\delta\kappa.
$$

在已检查的实现交叉检查中，校准为 `beta=0.99`, `rhoa=0.9`, `rhou=0`, `sigma=7`, `phi=1`, `theta=0.75`, `gamma1=0.5`, `kappa0=sigma*gamma1-gamma1`, `kappa=sigma+phi-kappa0`, `sigma0=sigma-kappa0`, `delta1=((1-theta)*(1-beta*theta))/theta`, `lambda=delta1*kappa`。

## 7. Timing & Form Conventions

- 实现为 `model(linear)`；变量是对数偏离，不是水平值。
- 通胀 $\pi_t$ 是本国生产者价格通胀。CPI 通胀不是 Nash 问题中的政策目标。
- 本国产出缺口为 $\tilde{y}_t=y_t-\bar{y}_t$，其中 $\bar{y}_t$ 是在给定外国产出条件下的本国灵活价格水平。合作政策部分改用全球灵活价格缺口；该区别不提升为基准 MMB 模块。
- 自然实际利率 $\overline{rr}_t$ 是前瞻性的，取决于本国自然产出和外国产出的预期变化。
- 外国变量在推导中使用星号上标，在实现交叉检查中使用 `star` 后缀。
- 存量资本时序不适用：所提取的论文侧 NK 模块没有资本存量。
- 未执行运行时验证；没有运行 Dynare。

## 8. Variable & Parameter Reference Table

| 类别 | 符号 / ASCII | 含义 | 方程引用 |
|---|---|---|---|
| 内生 | $\tilde{y}_t$ / `ytilde` | 本国产出缺口 | (F12), (F13) |
| 内生 | $\bar{y}_t$ / `ybar` | 本国自然产出 | (F28) |
| 内生 | $y_t$ / `y` | 本国产出对数偏离 | (F28), 恒等式 |
| 内生 | $\pi_t$ / `infl` | 本国通胀 | (F13), (F15) |
| 内生 | $r_t$ / `r` | 本国名义利率 | (F17), Taylor 规则 |
| 内生 | $\overline{rr}_t$ / `rr` | 本国自然实际利率 | (F29) |
| 内生 | $u_t$ / `u` | 本国成本推动冲击状态 | (F32) |
| 内生 | $a_t$ / `a` | 本国技术状态 | (F33) |
| 内生 | $\tilde{y}_t^*$ / `ytildestar` | 外国产出缺口 | (F36) |
| 内生 | $\bar{y}_t^*$ / `ybarstar` | 外国自然产出 | (F28) 的外国对应式 |
| 内生 | $y_t^*$ / `ystar` | 外国产出对数偏离 | (F36), 外国模块 |
| 内生 | $\pi_t^*$ / `infstar` | 外国通胀 | (F13) 的外国对应式 |
| 内生 | $r_t^*$ / `rstar` | 外国名义利率 | 外国 Taylor 规则 |
| 内生 | $\overline{rr}_t^*$ / `rrstar` | 外国自然实际利率 | (F29) 的外国对应式 |
| 内生 | $u_t^*$ / `ustar` | 外国成本推动冲击状态 | (F35) |
| 内生 | $a_t^*$ / `astar` | 外国技术状态 | (F34) |
| 外生 | $\varepsilon_t^u$ / `inf_` | 本国成本推动创新 | (F32) |
| 外生 | $\varepsilon_t^a$ / `a_` | 本国技术创新 | (F33) |
| 外生 | $\varepsilon_t^{u,*}$ / `infstar_` | 外国成本推动创新 | (F35) |
| 外生 | $\varepsilon_t^{y,*}$ / `ystar_` | 交叉检查中的外国产出/IS 创新 | (F36) |
| 外生 | $\varepsilon_t^{a,*}$ / `astar_` | 外国技术创新 | (F34) |
| 外生 | $\varepsilon_t^{r,*}$ / `rstar_` | 外国利率规则创新 | 外国 Taylor 规则 |
| 外生 | $\varepsilon_t^r$ / `interest_` | 本国利率规则创新 | 本国 Taylor 规则 |
| 参数 | $\beta$ / `beta` | 贴现因子 | (F4), (F10) |
| 参数 | $\sigma$ / `sigma` | 跨期替代弹性倒数 / CRRA 系数 | (F4), (F27) |
| 参数 | $\phi$ / `phi` | 劳动负效用中的 Frisch 弹性倒数 | (F5), (F27) |
| 参数 | $\theta$ / `theta` | Calvo 不调整概率 | (F8), (F10) |
| 参数 | $\gamma$ / `gamma1` | 外国商品份额 / 国家规模权重 | (F1), (F2), (F27) |
| 参数 | $\kappa_0$ / `kappa0` | 外国产出对边际成本的弹性 | (F27) |
| 参数 | $\kappa$ / `kappa` | 本国产出对边际成本的弹性 | (F27) |
| 参数 | $\sigma_0$ / `sigma0` | 开放经济需求参数 | (F12), (F29) |
| 参数 | $\delta$ / `delta1` | Calvo Phillips 曲线斜率组成项 | (F10) |
| 参数 | $\lambda$ / `lambda` | Phillips 曲线产出缺口斜率 | (F13) |
| 参数 | $\rho_a$ / `rhoa` | 技术持续性 | (F33), (F34) |
| 参数 | $\rho_u$ / `rhou` | 实现中的成本推动持续性 | (F32), (F35) |
