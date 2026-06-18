# NK_BGG99AL - 推导（最优化问题 + 均衡条件）

> 归档状态：`needs_review`。本初稿仅以 MinerU Markdown 为来源。已检查原始 PDF 路径存在，但未阅读 PDF 正文。未发现 `NK_BGG99AL` 的 appendix-normalization 文件或实现示例可用于变体层面的交叉核对。

## 1. Model Overview

- **模型 ID**：`NK_BGG99AL`。
- **论文**：Bernanke, Ben; Gertler, Mark; Gilchrist, Simon (1999), "The financial accelerator in a quantitative business cycles framework", DOI `10.1016/s1574-0048(99)10034-x`。
- **来源 Markdown**：`raw/mmb_mineru/runs/nk_bgg99_nk_bgg99al__the_financial_accelerator_in_a_quantitative_business__e6291ccb/full.md`。
- **原始 PDF**：`raw/mmb_papers/The financial accelerator in a quantitative business.pdf`。
- **MinerU run id**：`e6291ccb-176a-4258-bb8d-4ad10594377a`。
- **来源复核说明**：`raw/mmb_mineru/model_index.csv` 记录 `model_title_match_score=0.8595`，并说明 `primary source title differs from model title; review variant mapping`。因此，本推导记录论文中的 BGG 金融加速器模型，并将 `AL` 变体标为未解决。
- **主体**：家庭、企业家、金融中介、零售商、通过调整成本形成资本的资本品部门，以及财政/货币当局。
- **核心机制**：成本状态验证使外部融资溢价随企业家净值相对于资本购买规模的提高而下降。因此，资本价格变动会反馈到净值和投资。
- **模型形式**：用于计算块的是对数线性化的新凯恩斯金融加速器模型。论文也给出了非线性的家庭、契约、生产、资本积累、资源约束和零售定价基础。下列方程同时保留这两个层次，并在适用处标明对数线性方程。
- **运行验证**：未执行。

## 2. Optimization Problems

### 家庭

家庭选择消费、存款、劳动和实际货币余额：

$$
\max_{\{C_t,D_{t+1},H_t,M_t/P_t\}} E_t\sum_{k=0}^{\infty}\beta^k
\left[\ln C_{t+k}+\xi\ln(M_{t+k}/P_{t+k})+\xi\ln(1-H_{t+k})\right]
$$

约束为

$$
C_t=W_tH_t-T_t+\Pi_t+R_tD_t-D_{t+1}+\frac{M_{t-1}-M_t}{P_t}.
$$

### 企业家与金融契约

企业家 $j$ 在期末 $t$ 购买资本，并在 $t+1$ 用于生产。借款为

$$
B_{t+1}^j=Q_tK_{t+1}^j-N_{t+1}^j.
$$

成本状态验证契约选择资本和阈值 $\bar{\omega}^j$。若 $\omega^j\geq\bar{\omega}^j$，借款人偿付承诺金额；否则贷款人监测并获得扣除监测成本后的剩余索取权。阈值满足

$$
\bar{\omega}^j R_{t+1}^k Q_tK_{t+1}^j=Z_{t+1}^jB_{t+1}^j.
$$

贷款人的零利润条件为

$$
[1-F(\bar{\omega}^j)]Z_{t+1}^jB_{t+1}^j
+(1-\mu)\int_0^{\bar{\omega}^j}\omega R_{t+1}^kQ_tK_{t+1}^j\,dF(\omega)
=R_{t+1}B_{t+1}^j.
$$

在附录表述中，令 $s=R^k/R$、$k=QK/N$，归一化契约问题为

$$
\max_{K,\bar{\omega}}\;(1-\Gamma(\bar{\omega}))R^kQK
\quad\text{s.t.}\quad
[\Gamma(\bar{\omega})-\mu G(\bar{\omega})]R^kQK=R(QK-N).
$$

### 零售商

零售商 $z$ 面临 CES 需求，并在可调价时选择重置价格：

$$
\max_{P_t^{\ast}}\sum_{k=0}^{\infty}\theta^kE_{t-1}\left[
\Lambda_{t,k}\frac{P_t^{\ast}-P_{t+k}^w}{P_{t+k}}Y_{t+k}^{\ast}(z)
\right],
$$

其中 $\Lambda_{t,k}=\beta C_t/C_{t+k}$，且 $P_t^w=P_t/X_t$。

## 3. First-Order Conditions

- **(F1) 家庭欧拉方程**：

$$
\frac{1}{C_t}=E_t\left\{\beta\frac{1}{C_{t+1}}\right\}R_{t+1}.
$$

- **(F2) 家庭劳动供给**：

$$
W_t\frac{1}{C_t}=\xi\frac{1}{1-H_t}.
$$

- **(F3) 货币需求**：

$$
\frac{M_t}{P_t}=\zeta C_t\left(\frac{R_{t+1}^n-1}{R_{t+1}^n}\right)^{-1}.
$$

- **(F4) 金融契约中贷款人的替代后零利润条件**：

$$
\left([1-F(\bar{\omega}^j)]\bar{\omega}^j+(1-\mu)\int_0^{\bar{\omega}^j}\omega\,dF(\omega)\right)
R_{t+1}^kQ_tK_{t+1}^j
=R_{t+1}(Q_tK_{t+1}^j-N_{t+1}^j).
$$

- **(F5) 资本需求/净值关系**：

$$
Q_tK_{t+1}^j=\psi(s_t)N_{t+1}^j,\qquad \psi(1)=1,\quad\psi'(\cdot)>0.
$$

- **(F6) 外部融资溢价关系**：

$$
E_t\{R_{t+1}^k\}=s\left(\frac{N_{t+1}^j}{Q_tK_{t+1}^j}\right)R_{t+1},\qquad s'(\cdot)<0.
$$

- **(F7) 附录中的阈值-溢价映射**：

$$
s=\rho(\bar{\omega}).
$$

- **(F8) 附录中的杠杆-溢价映射**：

$$
k=\psi(s),\qquad \psi'(s)>0,\qquad k=\frac{QK}{N}.
$$

- **(F9) 生产技术**：

$$
Y_t=A_tK_t^{\alpha}L_t^{1-\alpha}.
$$

- **(F10) 含调整成本的资本积累**：

$$
K_{t+1}=\Phi\left(\frac{I_t}{K_t}\right)K_t+(1-\delta)K_t.
$$

- **(F11) 资本价格**：

$$
Q_t=\left[\Phi'\left(\frac{I_t}{K_t}\right)\right]^{-1}.
$$

- **(F12) 资本预期总回报**：

$$
E_t\{R_{t+1}^k\}
=E_t\left\{\frac{\frac{1}{X_{t+1}}\frac{\alpha Y_{t+1}}{K_{t+1}}+Q_{t+1}(1-\delta)}{Q_t}\right\}.
$$

- **(F13) 总量投资融资供给**：

$$
E_t\{R_{t+1}^k\}=s\left(\frac{N_{t+1}}{Q_tK_{t+1}}\right)R_{t+1}.
$$

- **(F14) 复合劳动投入**：

$$
L_t=H_t^{\Omega}(H_t^e)^{1-\Omega}.
$$

- **(F15) 企业家净值**：

$$
N_{t+1}=\gamma V_t+W_t^e.
$$

- **(F16) 企业家权益**：

$$
V_t=R_t^kQ_{t-1}K_t-\left(R_t+
\frac{\mu\int_0^{\bar{\omega}_t}\omega R_t^kQ_{t-1}K_t\,dF(\omega)}
{Q_{t-1}K_t-N_t}\right)(Q_{t-1}K_t-N_t).
$$

`needs_review`：论文正文在该表达式附近还出现过分母含 $N_{t-1}$ 的相邻时序记号，随后给出的总量差分方程使用 $N_t$。上式遵循总量差分方程，但在实现前应与 PDF 做来源级核对。

- **(F17) 企业家消费**：

$$
C_t^e=(1-\gamma)V_t.
$$

- **(F18) 家庭劳动需求**：

$$
(1-\alpha)\Omega\frac{Y_t}{H_t}=X_tW_t.
$$

- **(F19) 企业家劳动需求**：

$$
(1-\alpha)(1-\Omega)\frac{Y_t}{H_t^e}=X_tW_t^e.
$$

- **(F20) 总量净值转移方程**：

$$
\begin{aligned}
N_{t+1}={}&\gamma\left[
R_t^kQ_{t-1}K_t-\left(R_t+
\frac{\mu\int_0^{\bar{\omega}_t}\omega\,dF(\omega)R_t^kQ_{t-1}K_t}
{Q_{t-1}K_t-N_t}\right)(Q_{t-1}K_t-N_t)\right] \\
&+(1-\alpha)(1-\Omega)A_tK_t^{\alpha}H_t^{(1-\alpha)\Omega}.
\end{aligned}
$$

- **(F21) 零售需求曲线**：

$$
Y_t(z)=\left(\frac{P_t(z)}{P_t}\right)^{-\epsilon}Y_t^f.
$$

- **(F22) Calvo 重置价格条件**：

$$
\sum_{k=0}^{\infty}\theta^kE_{t-1}\left\{
\Lambda_{t,k}\left(\frac{P_t^{\ast}}{P_{t+k}}\right)^{-\epsilon}Y_{t+k}^{\ast}(z)
\left[\frac{P_t^{\ast}}{P_{t+k}}-\left(\frac{\epsilon}{\epsilon-1}\right)\frac{P_{t+k}^w}{P_{t+k}}\right]\right\}=0.
$$

- **(F23) 总价格指数演化**：

$$
P_t=\left[\theta P_{t-1}^{1-\epsilon}+(1-\theta)(P_t^{\ast})^{1-\epsilon}\right]^{1/(1-\epsilon)}.
$$

- **(F24) 对数线性资源约束**：

$$
y_t=\frac{C}{Y}c_t+\frac{I}{Y}i_t+\frac{G}{Y}g_t+\frac{C^e}{Y}c_t^e+\cdots+\phi_t^v.
$$

- **(F25) 对数线性家庭消费欧拉方程**：

$$
c_t=-r_{t+1}+E_t\{c_{t+1}\}.
$$

- **(F26) 对数线性企业家消费**：

$$
c_t^e=n_{t+1}+\cdots+\phi_t^{c^e}.
$$

- **(F27) 对数线性外部融资溢价**：

$$
E_t\{r_{t+1}^k\}-r_{t+1}=-\nu[n_{t+1}-(q_t+k_{t+1})].
$$

- **(F28) 对数线性资本回报**：

$$
r_{t+1}^k=(1-\epsilon)(y_{t+1}-k_{t+1}-x_{t+1})+\epsilon q_{t+1}-q_t.
$$

- **(F29) 对数线性资本价格/投资关系**：

$$
q_t=\varphi(i_t-k_t).
$$

- **(F30) 对数线性总量生产**：

$$
y_t=a_t+\alpha k_t+(1-\alpha)\Omega h_t.
$$

- **(F31) 对数线性劳动市场均衡**：

$$
y_t-h_t-x_t-c_t=\eta^{-1}h_t.
$$

- **(F32) 对数线性 Phillips 曲线**：

$$
\pi_t=E_{t-1}\{\kappa(-x_t)+\beta\pi_{t+1}\}.
$$

- **(F33) 对数线性资本转移方程**：

$$
k_{t+1}=\delta i_t+(1-\delta)k_t.
$$

- **(F34) 对数线性净值转移方程**：

$$
n_{t+1}=\frac{\gamma RK}{N}(r_t^k-r_t)+r_t+n_t+\cdots+\phi_t^n.
$$

## 4. Market Clearing & Identities

- **(F35) 家庭存款等于企业家借款**：

$$
D_t=B_t.
$$

- **(F36) CES 最终品聚合器**：

$$
Y_t^f=\left[\int_0^1Y_t(z)^{(\epsilon-1)/\epsilon}\,dz\right]^{\epsilon/(\epsilon-1)}.
$$

- **(F37) 零售价格指数**：

$$
P_t=\left[\int_0^1P_t(z)^{1-\epsilon}\,dz\right]^{1/(1-\epsilon)}.
$$

- **(F38) 含监测成本的非线性资源约束**：

$$
Y_t^f=C_t+C_t^e+I_t+G_t+\mu\int_0^{\bar{\omega}_t}\omega\,dF(\omega)R_t^kQ_{t-1}K_t.
$$

- **(F39) 政府预算约束**：

$$
G_t=\frac{M_t-M_{t-1}}{P_t}+T_t.
$$

- **(F40) 总名义利率定义**：

$$
i_{t+1}\equiv R_{t+1}^n\frac{P_{t+1}}{P_t}-1.
$$

## 5. Exogenous Processes

- **(F41) 货币政策规则**：

$$
r_t^n=\rho r_{t-1}^n+\varsigma\pi_{t-1}+\varepsilon_t^{rn}.
$$

- **(F42) 政府支出过程**：

$$
g_t=\rho_g g_{t-1}+\varepsilon_t^g.
$$

- **(F43) 技术过程**：

$$
a_t=\rho_a a_{t-1}+\varepsilon_t^a.
$$

- **(F44) 投资延迟扩展，若 `AL` 变体使用论文中的一期计划滞后**：

$$
E_t\left\{q_{t+j}-\varphi(i_{t+j}-k_{t+j})\right\}=0,\qquad j=1\ \text{in the simulations}.
$$

`needs_review`：来源论文包含此扩展，但仅凭 model-index 行不能证明 `NK_BGG99AL` 就是投资延迟变体。该方程作为变体候选项列入，而不是作为已确认的基准方程来替代 (F29)。

## 6. Steady-State Solution

计算系统围绕确定性稳态做对数线性化。因此，对数偏离变量的稳态为零：

$$
\bar{a}=\bar{g}=\bar{c}=\bar{i}=\bar{y}=\bar{k}=\bar{n}=\bar{q}=\bar{x}=\bar{\pi}=0.
$$

论文陈述的非线性归一化和校准目标为：

$$
\bar{R}=\beta^{-1},\qquad \bar{Q}=1,\qquad \bar{G}/\bar{Y}=0.2,\qquad \bar{K}/\bar{N}=2.
$$

稳态外部融资溢价目标为

$$
\bar{R}^k-\bar{R}=200\ \text{annual basis points}.
$$

稳态违约/失败率目标为

$$
F(\bar{\omega})=0.03\ \text{annualized}.
$$

论文校准的企业家退出率、个体风险离散度和监测成本为

$$
1-\gamma=0.0272,\qquad \operatorname{Var}(\log\omega)=0.28,\qquad \mu=0.12.
$$

来源中还报告了其他基准校准：

$$
\beta=0.99,\quad \eta=3.0,\quad \alpha=0.35,\quad (1-\alpha)(1-\Omega)=0.64,\quad \delta=0.025,\quad \varphi=0.25.
$$

来源中报告的冲击和政策参数包括

$$
\rho_a=1.0,\qquad \rho_g=0.95,\qquad \theta=0.75,\qquad \rho=0.9,\qquad \varsigma=0.11.
$$

`needs_review`：来源给出校准目标和对数线性稳态含义，而不是完整的非线性 `steady_state_model` 顺序。后续实现阶段应根据所选 MMB `.mod` 变体重构精确稳态水平。

## 7. Timing & Form Conventions

- 在 period $t$ 购买的资本记作 $K_{t+1}$，因为它在 $t+1$ 用于生产。
- period $t$ 的生产函数使用上一期购买的资本存量。
- 企业家净值 $N_{t+1}$ 是期末状态，并进入资本购买和借款决策。
- 在用于 Phillips 曲线的 Bernanke-Woodford 时序中，零售商在 period-$t$ 总量不确定性实现前设定价格。
- 计算块是对数线性化系统。小写变量表示相对稳态的百分比偏离，但通胀和利率符号按论文定义。
- 基准资本价格方程为 (F29)。若确认滞后投资变体，则投资延迟扩展以预期未来关系 (F44) 替代它。
- 这里不是一个 `model(linear)` 源文件；它是论文侧的对数线性系统，后续还需映射为实现。

## 8. Variable & Parameter Reference Table

| 类别 | 符号 / ASCII hint | 含义 | 主要方程 |
|---|---|---|---|
| 内生 | $C_t$, `c` | 家庭消费 | (F1), (F24), (F25) |
| 内生 | $D_t$, `d` | 家庭存款 / 可贷资金 | (F35) |
| 内生 | $H_t$, `h` | 家庭劳动 | (F2), (F18), (F30), (F31) |
| 内生 | $M_t/P_t$, `m` | 实际货币余额 | (F3), (F39) |
| 内生 | $B_t$, `b` | 企业家借款 | (F4), (F35) |
| 内生 | $K_t$, `k` | 资本存量 | (F10), (F33) |
| 内生 | $I_t$, `i` | 投资 | (F10), (F29), (F44) |
| 内生 | $Q_t$, `q` | 资本相对价格 | (F11), (F29), (F44) |
| 内生 | $N_t$, `n` | 企业家净值 | (F15), (F20), (F34) |
| 内生 | $V_t$, `v` | 企业家权益 | (F16) |
| 内生 | $C_t^e$, `ce` | 企业家消费 | (F17), (F26), (F38) |
| 内生 | $Y_t$, `y` | 批发/最终产出，取决于上下文 | (F9), (F24), (F30), (F38) |
| 内生 | $L_t$, `l` | 复合劳动投入 | (F14) |
| 内生 | $W_t$, `w` | 家庭实际工资 | (F18) |
| 内生 | $W_t^e$, `we` | 企业家工资 | (F19) |
| 内生 | $X_t$, `x` | 零售品相对批发品的加成 | (F12), (F18), (F19), (F31), (F32) |
| 内生 | $R_t$, `r` | 无风险实际总回报 / 对数实际利率 | (F1), (F4), (F13), (F40) |
| 内生 | $R_t^k$, `rk` | 资本总回报 | (F12), (F16), (F20), (F28), (F34) |
| 内生 | $R_t^n$, `rn` | 总名义回报 / 政策工具 | (F3), (F40), (F41) |
| 内生 | $\pi_t$, `pi` | 通胀 | (F32), (F41) |
| 内生 | $\bar{\omega}_t$, `omega_bar` | 违约阈值 | (F4), (F7), (F16), (F20), (F38) |
| 内生 | $P_t^{\ast}$, `pstar` | Calvo 重置价格 | (F22), (F23) |
| 内生 | $Y_t(z)$, `yz` | 零售商层面的需求/产出 | (F21) |
| 外生 | $a_t$, `a` | 技术对数偏离 | (F30), (F43) |
| 外生 | $g_t$, `g` | 政府支出对数偏离 | (F24), (F42) |
| 外生冲击 | $\varepsilon_t^{rn}$, `eps_rn` | 货币政策创新 | (F41) |
| 外生冲击 | $\varepsilon_t^g$, `eps_g` | 政府支出创新 | (F42) |
| 外生冲击 | $\varepsilon_t^a$, `eps_a` | 技术创新 | (F43) |
| 参数 | $\beta$ | 家庭贴现因子 | (F1), (F22), (F32) |
| 参数 | $\xi$ | 实际货币余额/闲暇的效用权重 | (F2), (F3) |
| 参数 | $\zeta$ | 货币需求尺度参数 | (F3) |
| 参数 | $\alpha$ | 资本份额 | (F9), (F12), (F18), (F19), (F20), (F30) |
| 参数 | $\delta$ | 折旧率 | (F10), (F12), (F33) |
| 参数 | $\gamma$ | 企业家存活概率 | (F15), (F17), (F20), (F34) |
| 参数 | $\mu$ | 监测成本份额 | (F4), (F16), (F20), (F38) |
| 参数 | $\Omega$ | 复合劳动中家庭劳动份额 | (F14), (F18), (F19), (F30) |
| 参数 | $\theta$ | Calvo 不调价概率 | (F22), (F23), (F32) |
| 参数 | $\epsilon$ | 需求弹性 / OCR 来源中的回报权重参数 | (F21), (F22), (F23), (F28) |
| 参数 | $\eta$ | 劳动供给弹性参数 | (F31) |
| 参数 | $\nu$ | 金融加速器弹性 | (F27) |
| 参数 | $\varphi$ | 资本价格/投资弹性 | (F29), (F44) |
| 参数 | $\kappa$ | Phillips 曲线斜率 | (F32) |
| 参数 | $\rho$, $\varsigma$ | 政策规则持久性和通胀反应 | (F41) |
| 参数 | $\rho_g$, $\rho_a$ | 冲击持久性 | (F42), (F43) |
