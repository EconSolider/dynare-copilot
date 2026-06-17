# NK_ET14 -- 推导

> 本推导是供后续 Dynare 实现使用的来源支撑草稿。尚未进行运行时验证。

来源：Ellison, Martin, and Andreas Tischbirek (2014), "Unconventional government debt purchases as a supplement to conventional monetary policy," *Journal of Economic Dynamics and Control* 43, 199-217. DOI: `10.1016/j.jedc.2014.03.012`。

出处记录：`raw/mmb_mineru/runs/nk_et14__unconventional_government_debt_purchases_as_a_supplement_to_conventional__f7e430ba/full.md`；原始 PDF 路径已确认存在：`raw/mmb_papers/Unconventional government debt purchases as a supplement to conventional monetary policy.pdf`；MinerU run id `f7e430ba-7c77-4633-ba23-6e943c335622`。MMB 实现 `.mod` 仅作为实现交叉检查使用。

## 1. Model Overview / 模型概述

- **模型**：新凯恩斯 DSGE 模型，包含完全弹性工资、Calvo 价格黏性、带偏好栖息地资产需求的代表性银行、财政部和中央银行。中央银行同时使用短期利率规则和长期政府债购买规则。
- **实验**：围绕趋势平稳稳态做一阶随机模拟。论文研究长期政府债购买是否能在非零下限环境中补充常规短期利率政策。
- **主体**：家庭选择消费、劳动和银行储蓄工具；企业在 Calvo 摩擦下定价并使用劳动生产；银行将存款配置到短债和长债；财政部发行债务并用税收融资支出；中央银行设定短期名义利率并购买长期债。
- **形式**：非线性平稳均衡方程，随后在 Dynare 中做一阶近似。该模型不是手工对数线性模型。稳态通胀不等于 1 时，名义水平是趋势平稳的；附录 B 使用实际平稳变量。
- **状态**：`needs_review`。附录 B 的 OCR 存在若干公式伪影；能用正文公式校正的地方已用正文版本，不读取 PDF 正文。

## 2. Optimization Problems / 主体的最优化问题

### 2.1 代表性家庭

家庭最大化期望效用：

$$
\max_{\{C_t,L_t,S_{t,t+1}\}} E_0\sum_{t=0}^{\infty}\beta^t
\left[
\chi_t^C\frac{C_t^{1-\delta}}{1-\delta}
-\chi_t^L\frac{L_t^{1+\psi}}{1+\psi}
\right]
$$

约束为名义预算约束：

$$
P_t C_t+T_t+P_t^S S_{t,t+1}
=S_{t-1,t}+W_tL_t+(1-t_{\mathcal P})(P_tY_t-W_tL_t).
$$

其中 $S_{t,t+1}$ 是银行提供、价格为 $P_t^S$ 的储蓄工具；家庭获得企业利润的税后份额。

### 2.2 定价企业

每个企业的技术为 $Y_t(i)=A_tL_t(i)^{1/\phi}$。能够重新定价的企业选择 $P_t^*(i)$ 以最大化贴现利润：

$$
\max_{P_t^*(i)} E_t\sum_{T=t}^{\infty}\alpha^{T-t}M_{t,T}
\left[P_t^*(i)Y_T(i)-W_TL_T(i)\right]
$$

需求约束为：

$$
Y_T(i)=Y_T\left(\frac{P_t^*(i)}{P_T}\right)^{-\theta_t}
$$

贴现因子为：

$$
M_{t,T}=\beta^{T-t}
\frac{\chi_T^C C_T^{-\delta}P_t}{\chi_t^C C_t^{-\delta}P_T}.
$$

### 2.3 代表性银行

银行收集名义存款 $P_t^SS_{t,t+1}$，并配置到短期债 $B_{t,t+1}$ 与长期债 $Q_{t,t+\tau}$：

$$
P_t^SS_{t,t+1}=P_t^BB_{t,t+1}+P_t^QQ_{t,t+\tau}.
$$

银行解决偏好栖息地配置问题：

$$
\max_{B_{t,t+1},Q_{t,t+\tau}}
V\left(\frac{B_{t,t+1}}{P_t},\frac{Q_{t,t+\tau}}{P_t}\right),
$$

并受上述流量约束限制。在论文的 Generalised Translog 限制下，该问题给出短债和长债的闭式需求方程。

### 2.4 财政部与中央银行

财政部发行短债，并按固定实际流量发行长期债。政府消费外生，并通过一次性税收融资。中央银行通过 Taylor 型规则设定短期名义利率和留给私人部门的长期债比例。

## 3. First-Order Conditions / 一阶条件

- **(F1) 家庭关于银行储蓄工具的欧拉方程**：

$$
1=\beta E_t\left[
\frac{\chi_{t+1}^C}{\chi_t^C}
\left(\frac{C_{t+1}}{C_t}\right)^{-\delta}
\frac{1}{\Pi_{t+1}}
\right]\frac{1}{P_t^S}.
$$

- **(F2) 家庭劳动-消费静态条件**：

$$
w_t=\frac{\chi_t^L}{\chi_t^C}L_t^\psi C_t^\delta.
$$

- **(F3) Calvo 价格指数关系 / 重定价条件**：

$$
\frac{1-\alpha\Pi_t^{\theta_t-1}}{1-\alpha}
=\left(\frac{F_t}{K_t}\right)^{\frac{\theta_t-1}{\theta_t(\phi-1)+1}}.
$$

- **(F4) Calvo 辅助变量 $F_t$ 递归式**：

$$
F_t=\chi_t^C C_t^{-\delta}Y_t
+\alpha\beta E_t\left[\Pi_{t+1}^{\theta_t-1}F_{t+1}\right].
$$

- **(F5) Calvo 辅助变量 $K_t$ 递归式**：

$$
K_t=\frac{\theta_t\phi}{\theta_t-1}\chi_t^LL_t^\psi
\left(\frac{Y_t}{A_t}\right)^\phi
+\alpha\beta E_t\left[\Pi_{t+1}^{\theta_t\phi}K_{t+1}\right].
$$

附录 B OCR 版本中的 (F3) 与 (F5) 为 `needs_review`；上式采用更清晰的正文方程 (7)-(9)。

- **(F6) 银行储蓄工具回报**：

$$
s_t=b_t+\frac{1}{\tau}\left(q_t+\sum_{k=1}^{\tau-1}
\frac{q_{t-k}}{\prod_{j=0}^{k-1}\Pi_{t-j}}\right).
$$

- **(F7) 短债价格与名义利率**：

$$
1+i_t=\frac{1}{P_t^B}.
$$

- **(F8) 长债收益率定义**：

$$
P_t^Q=\frac{1}{\tau}\frac{1}{1+i_t^Q}
\frac{1-\left(\frac{1}{1+i_t^Q}\right)^\tau}
{1-\frac{1}{1+i_t^Q}}.
$$

- **(F9) 银行配置问题给出的短债需求**：

$$
b_t=g^B+\frac{P_t^Ss_t-P_t^Bg^B-P_t^Qg^Q}{P_t^B}
\left[
a_1+a_2\log\left(\frac{P_t^B}{P_t^Q}\right)
\right].
$$

- **(F10) 银行配置问题给出的长债需求**：

$$
q_t=g^Q+\frac{P_t^Ss_t-P_t^Bg^B-P_t^Qg^Q}{P_t^Q}
\left[
1-a_1-a_2\log\left(\frac{P_t^B}{P_t^Q}\right)
\right].
$$

- **(F11) 长期债发行规则**：

$$
\bar q_t=fY.
$$

- **(F12) 常规货币政策规则**：

$$
\frac{1+i_t}{1+i}
=\left(\frac{\Pi_t}{\Pi}\right)^{\gamma_\Pi}
\left(\frac{Y_t}{Y}\right)^{\gamma_Y}\nu_t.
$$

- **(F13) 非常规资产购买规则**：

$$
\frac{\bar q_t-q_t^{CB}}{\bar q_t}
=\left(\frac{\Pi_t}{\Pi}\right)^{\gamma_\Pi^{QE}}
\left(\frac{Y_t}{Y}\right)^{\gamma_Y^{QE}}\xi_t.
$$

源文件 OCR 中 $\gamma_\Pi$ 有时显示为 `gamma_II`；本推导将其规范化为通胀反应系数，并在 notes 中记录 OCR 问题。

## 4. Market Clearing & Identities / 市场出清与恒等式

- **(F14) 长债市场出清**：

$$
\bar q_t=q_t+q_t^{CB}.
$$

- **(F15) 商品市场出清**：

$$
Y_t=C_t+G_t.
$$

- **(F16) 含价格分散度的总量生产**：

$$
Y_t=A_t\left(\frac{L_t}{D_t}\right)^{1/\phi}.
$$

- **(F17) 价格分散度运动方程**：

$$
D_t=(1-\alpha)
\left(\frac{1-\alpha\Pi_t^{\theta_t-1}}{1-\alpha}\right)^{\frac{\theta_t\phi}{\theta_t-1}}
+\alpha\Pi_t^{\theta_t\phi}D_{t-1}.
$$

- **(F18) 实际家庭预算 / 平稳资源恒等式**：

$$
C_t+P_t^Ss_t+G_t
=\frac{s_{t-1}}{\Pi_t}+t_{\mathcal P}w_tL_t+(1-t_{\mathcal P})Y_t.
$$

该恒等式是结合政府融资和银行回报后的家庭预算平稳形式。合并政府预算由家庭、银行、市场出清和税收关系隐含，在平稳模型中不作为独立方程处理。

## 5. Exogenous Processes / 外生过程

- **(F19) 消费偏好冲击**：

$$
\log(\chi_t^C)=\rho_C\log(\chi_{t-1}^C)+\varepsilon_t^C.
$$

- **(F20) 劳动偏好冲击**：

$$
\log(\chi_t^L)=\rho_L\log(\chi_{t-1}^L)+\varepsilon_t^L.
$$

- **(F21) 技术冲击**：

$$
\log(A_t)=\rho_A\log(A_{t-1})+\varepsilon_t^A.
$$

- **(F22) 替代弹性冲击**：

$$
\log\left(\frac{\theta_t}{\theta}\right)
=\rho_\theta\log\left(\frac{\theta_{t-1}}{\theta}\right)+\varepsilon_t^\theta.
$$

- **(F23) 政府支出冲击**：

$$
\log\left(\frac{G_t}{G}\right)
=\rho_G\log\left(\frac{G_{t-1}}{G}\right)+\varepsilon_t^G.
$$

- **(F24) 利率规则冲击**：

$$
\log(\nu_t)=\rho_\nu\log(\nu_{t-1})+\varepsilon_t^\nu.
$$

- **(F25) 资产购买规则冲击**：

$$
\log(\xi_t)=\rho_\xi\log(\xi_{t-1})+\varepsilon_t^\xi.
$$

MMB 实现对 `epsnu` 和 `epsksi` 使用负号，使报告的正冲击具有扩张性；这是实现约定，不是额外的论文方程。

## 6. Steady-State Solution / 稳态解

稳态变量省略时间下标。论文在附录 B.2 给出了平稳稳态。尚未进行运行时验证。

1. 归一化外生状态：

$$
A=\chi^C=\chi^L=\nu=\xi=1.
$$

2. 给定校准的 $\Pi,\alpha,\theta,\phi$，计算价格分散度：

$$
D=\frac{1-\alpha}{1-\alpha\Pi^{\theta\phi}}
\left(\frac{1-\alpha\Pi^{\theta-1}}{1-\alpha}\right)^{\frac{\theta\phi}{\theta-1}}.
$$

3. 用平稳稳态表达式计算产出：

$$
Y=\left[
\frac{1-\alpha\beta\Pi^{\theta-1}}
{1-\alpha\beta\Pi^{\theta\phi}}
\frac{\theta\phi}{\theta-1}
D^\psi(1-\bar g)^\delta
\left(\frac{1-\alpha\Pi^{\theta-1}}{1-\alpha}\right)^{\frac{\theta(\phi-1)+1}{\theta-1}}
\right]^{\frac{1}{1-\delta-\phi(\psi+1)}}.
$$

该公式的附录 B OCR 版本为 `needs_review`；MMB 实现中的稳态表达式仅作为意图上的实现交叉检查。

4. 设定财政总量和消费：

$$
G=\bar gY,\qquad C=Y-G.
$$

5. 计算 Calvo 辅助变量、劳动和工资：

$$
F=\frac{YC^{-\delta}}{1-\alpha\beta\Pi^{\theta-1}},\qquad
K=\frac{1}{1-\alpha\beta\Pi^{\theta\phi}}\frac{\theta\phi}{\theta-1}D^\psi Y^{\phi(\psi+1)},
$$

$$
L=DY^\phi,\qquad w=L^\psi C^\delta.
$$

6. 计算储蓄工具和长期债数量：

$$
P^S=\frac{\beta}{\Pi},\qquad
q^{CB}=0,\qquad
\bar q=fY,\qquad
q=\bar q.
$$

7. 计算总储蓄和短债持有量：

$$
s=\frac{\Pi}{1-\beta}\left[C+G-t_{\mathcal P}wL-(1-t_{\mathcal P})Y\right],
$$

$$
b=s-\frac{q}{\tau}\left(1-\frac{1}{\Pi^\tau}\right)\frac{\Pi}{\Pi-1}.
$$

8. 联立两个稳态资产需求方程求解 $P^B$ 和 $P^Q$：

$$
b=g^B+\frac{P^Ss-P^Bg^B-P^Qg^Q}{P^B}
\left[a_1+a_2\log\left(\frac{P^B}{P^Q}\right)\right],
$$

$$
q=g^Q+\frac{P^Ss-P^Bg^B-P^Qg^Q}{P^Q}
\left[1-a_1-a_2\log\left(\frac{P^B}{P^Q}\right)\right].
$$

9. 还原利率：

$$
i=\frac{1}{P^B}-1,
$$

并由下式隐式求解 $i^Q$：

$$
P^Q=\frac{1}{\tau}\frac{1}{1+i^Q}
\frac{1-\left(\frac{1}{1+i^Q}\right)^\tau}
{1-\frac{1}{1+i^Q}}.
$$

## 7. Timing & Form Conventions / 时序与形式约定

- **平稳变量**：$w_t=W_t/P_t$, $s_t=S_{t,t+1}/P_t$, $b_t=B_{t,t+1}/P_t$, $q_t=Q_{t,t+\tau}/P_t$, $\bar q_t=\bar Q_{t,t+\tau}/P_t$, $q_t^{CB}=Q_{t,t+\tau}^{CB}/P_t$。
- **长债时序**：在 $t$ 期发行的长期债从 $t+1$ 到 $t+\tau$ 每期支付 $1/\tau$。$t$ 期存款回报取决于短债偿付和过去 $\tau$ 个长期债 vintage 的票息支付。
- **长期债无二级市场**：长期债在发行时购买并持有至到期，因此状态向量通过回报恒等式包含滞后长期债数量。
- **价格分散度**：$D_t$ 在 (F17) 中通过 $D_{t-1}$ 预定。
- **政策冲击**：$\nu_t$ 进入短期利率规则；$\xi_t$ 进入资产购买规则。实现文件可能通过符号约定让正创新表示扩张性冲击。
- **模型形式**：非线性平稳方程，做一阶近似；不是 `model(linear)`。
- **运行时验证**：本 archive-entry pass 未执行。

## 8. Variable & Parameter Reference Table / 变量与参数对照表

### 内生变量

| 符号 | 含义 | 主要方程 |
|---|---|---|
| $Y_t$ | 产出 | (F15), (F16) |
| $C_t$ | 消费 | (F1), (F15) |
| $s_t$ | 实际储蓄工具数量 | (F6), (F18) |
| $G_t$ | 政府消费 | (F23), (F15) |
| $\Pi_t$ | 毛通胀 | (F3), (F12), (F13) |
| $L_t$ | 劳动 | (F2), (F16) |
| $\chi_t^C$ | 消费偏好状态 | (F19) |
| $P_t^S$ | 储蓄工具价格 | (F1), (F18) |
| $P_t^Q$ | 长债价格 | (F8), (F10) |
| $P_t^B$ | 短债价格 | (F7), (F9) |
| $w_t$ | 实际工资 | (F2), (F18) |
| $\chi_t^L$ | 劳动偏好状态 | (F20) |
| $F_t$ | Calvo 辅助分子 | (F4) |
| $K_t$ | Calvo 辅助分母 | (F5) |
| $A_t$ | 技术 | (F21), (F16) |
| $b_t$ | 实际短债持有 | (F9), (F6) |
| $q_t$ | 私人实际长债持有 | (F10), (F14) |
| $\bar q_t$ | 实际长期债总发行 | (F11), (F14) |
| $q_t^{CB}$ | 中央银行长债购买 | (F13), (F14) |
| $i_t$ | 短期名义利率 | (F7), (F12) |
| $i_t^Q$ | 长债收益率 | (F8) |
| $D_t$ | 价格分散度 | (F17), (F16) |
| $\theta_t$ | 时变替代弹性 | (F22), (F3)-(F5) |
| $\nu_t$ | 利率政策状态 | (F24), (F12) |
| $\xi_t$ | 资产购买政策状态 | (F25), (F13) |

### 外生创新

| 符号 | 含义 |
|---|---|
| $\varepsilon_t^C$ | 消费偏好创新 |
| $\varepsilon_t^L$ | 劳动偏好创新 |
| $\varepsilon_t^A$ | 技术创新 |
| $\varepsilon_t^\theta$ | 替代弹性创新 |
| $\varepsilon_t^G$ | 政府支出创新 |
| $\varepsilon_t^\nu$ | 短期利率规则创新 |
| $\varepsilon_t^\xi$ | 资产购买规则创新 |

### 参数

| 符号 | 含义 |
|---|---|
| $\beta$ | 贴现因子 |
| $\delta$ | 跨期替代弹性倒数 |
| $\psi$ | Frisch 劳动弹性倒数 |
| $\theta$ | 稳态替代弹性 |
| $\phi$ | 生产中的规模报酬倒数参数 |
| $\alpha$ | Calvo 不能调价概率 |
| $\Pi$ | 稳态毛通胀 |
| $\tau$ | 长债期限 |
| $\bar g$ | 政府支出产出比 |
| $t_{\mathcal P}$ | 政府获得的企业利润份额/税率 |
| $f$ | 长债发行规则参数 |
| $a_1,a_2,g^B,g^Q$ | 偏好栖息地资产需求参数 |
| $\gamma_\Pi,\gamma_Y$ | 短期利率规则系数 |
| $\gamma_\Pi^{QE},\gamma_Y^{QE}$ | 资产购买规则系数 |
| $\rho_C,\rho_L,\rho_A,\rho_\theta,\rho_G,\rho_\nu,\rho_\xi$ | 冲击持续性 |
| $\sigma_C,\sigma_L,\sigma_A,\sigma_\theta,\sigma_G,\sigma_\nu,\sigma_\xi$ | 创新标准差 |
