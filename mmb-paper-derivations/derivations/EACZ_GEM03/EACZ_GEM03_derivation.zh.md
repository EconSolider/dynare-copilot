# EACZ_GEM03 -- 推导（最优化问题 + 一阶条件）

> MMB 模型 `EACZ_GEM03` 的第一遍私有归档条目。未执行运行时验证。公式状态：凡 MinerU OCR 或论文到实现的压缩存在不确定处，均标为 `needs_review`。

## 1. Model Overview

- **模型**：Laxton and Pesenti (2003), "Monetary rules for small, open, emerging economies"，即 IMF Global Economy Model (GEM) 的两国版本。
- **归档模型 ID**：`EACZ_GEM03`。
- **来源**：`raw/mmb_mineru/runs/eacz_gem03__monetary_rule_for_small_open_emerging_economies__7512f0ea/full.md`；原始 PDF 溯源为 `raw/mmb_papers/Monetary rule for small, open, emerging economies.pdf`。
- **国家**：Home 是相对较小的开放经济，校准为捷克共和国；Foreign 是较大的相对封闭经济，校准为欧元区。论文中 Foreign 变量加星号，代码交叉检查中用后缀 `F`；Home 变量用后缀 `H`。
- **主体和部门**：无限寿命家庭、最终品企业、垄断竞争的非贸易品和贸易品中间品企业、竞争性分销企业、使用土地的竞争性原材料企业，以及政府/中央银行。
- **实验**：在随机冲击下比较广义 Taylor 规则和通胀预测型规则；MMB 实现复制表 4 第二行，即 Home 国最优政策规则参数。
- **模型形式**：论文为非线性结构 DSGE；先求非线性稳态，再在 Dynare 中研究线性化版本。Rep-MMB 实现是非线性 Dynare `model` 块，并包含百分比偏离的报告变量。
- **第一遍状态**：`needs_review`。论文给出核心结构方程，但若干 FOC 只用文字说明；实现文件只作为 `implementation_cross_check`，不作为论文侧数学证据。

## 2. Optimization Problems

### 2.1 最终品企业

完全竞争的最终品企业选择非贸易品投入篮子 $N_{N,t}(x)$、国内贸易品篮子 $Q_t(x)$ 和进口贸易品篮子 $M_t(x)$，在嵌套 CES 生产函数约束下最小化投入成本。论文 Eq. (1) 的外层嵌套存在 OCR 损坏，所以下面的清理形式标记为 `needs_review`：

$$
A_t(x)=\Bigg\lbrace(1-\gamma_t)^{1/\epsilon}N_{N,t}(x)^{1-1/\epsilon}
+\gamma_t^{1/\epsilon}\left[\nu^{1/\epsilon_{QM}}Q_t(x)^{1-1/\epsilon_{QM}}
+(1-\nu)^{1/\epsilon_{QM}}\left(M_t(x)(1-\Gamma_{M,t}(x))\right)^{1-1/\epsilon_{QM}}\right]^{\frac{\epsilon_{QM}}{\epsilon_{QM}-1}\left(1-\frac{1}{\epsilon}\right)}\Bigg\rbrace^{\frac{\epsilon}{\epsilon-1}}.
\quad \text{needs_review}
$$

进口调整成本楔子为：

$$
\Gamma_{M,t}(x)=\frac{\phi_M}{2}\left(\frac{M_t(x)/A_t(x)}{M_{t-1}/A_{t-1}}-1\right)^2.
$$

### 2.2 中间品企业

每个非贸易品生产者 $n$ 在劳动、资本和材料篮子的 CES 技术约束下最小化成本：

$$
N_t^S(n)=Z_{N,t}\left[(1-\alpha_N-\gamma_N)^{1/\xi_N}\ell_t(n)^{1-1/\xi_N}
+\alpha_N^{1/\xi_N}K_t(n)^{1-1/\xi_N}
+\gamma_N^{1/\xi_N}(O_t(n)(1-\Gamma_{O,t}(n)))^{1-1/\xi_N}\right]^{\xi_N/(\xi_N-1)}.
$$

贸易品生产者求解相同结构的问题，使用 $T_t^S(h)$ 和参数 $(\alpha_T,\gamma_T,\xi_T,Z_{T,t})$。原材料企业在劳动、资本和土地投入下进行竞争性成本最小化：

$$
T_{O,t}^S(o)=Z_{O,t}\left[(1-\alpha_O-\gamma_O)^{1/\xi_O}\ell_t(o)^{1-1/\xi_O}
+\alpha_O^{1/\xi_O}K_t(o)^{1-1/\xi_O}
+\gamma_O^{1/\xi_O}L_t(o)^{1-1/\xi_O}\right]^{\xi_O/(\xi_O-1)}.
$$

垄断竞争的非贸易品和贸易品企业在向下倾斜的需求和 Rotemberg 式调整成本约束下选择价格，最大化折现实际利润。非贸易品定价问题为：

$$
\max_{\{p_\tau(n)\}_{\tau=t}^{\infty}}E_t\sum_{\tau=t}^{\infty}
D_{t,\tau}(p_\tau(n)-MC_\tau(n))p_\tau(n)^{-\theta}P_{N,\tau}^{\theta}
\left[N_{N,\tau}+\eta(Q_\tau+M_\tau)+G_{N,\tau}\right](1-\Gamma_{PN,\tau}(n)).
$$

### 2.3 家庭

Home 家庭 $j$ 最大化预期生命周期效用：

$$
\mathscr W_t(j)=E_t\sum_{\tau=t}^{\infty}\beta^{\tau-t}\left[U(C_\tau(j))-V(\ell_\tau(j))\right],
$$

其中消费效用含习惯，劳动为负效用：

$$
U_t(j)=Z_{U,t}\frac{(C_t(j)-bC_{t-1})^{1-\sigma}-1}{1-\sigma},
\qquad
V_t(j)=Z_{V,t}\frac{\ell_t(j)^{1+\zeta}}{1+\zeta}.
$$

家庭选择货币、国内债券、外币债券、资本、投资、消费和工资，并受到名义预算约束、资本积累和劳动需求约束。来源中的预算约束包括货币、国内和国外债券、资本和土地租金收入、扣除工资调整成本后的工资收入、含购物成本的消费、投资、利润/返还以及一次总付税。

### 2.4 政府和货币当局

政府购买最终品和非贸易品，并通过一次总付税和铸币税融资。中央银行按照广义 Taylor/IFB 规则控制短期名义利率。在 Home 国 MMB 变体中，实现交叉检查使用表 4 的 Home 国最优广义 Taylor 规则第二行。

## 3. First-Order Conditions

- **(F1) 非贸易品篮子价格指数**：

$$
P_{N,t}=\left[\frac{1}{s}\int_0^s p_t(n)^{1-\theta}\,dn\right]^{1/(1-\theta)}.
$$

- **(F2) 国内贸易品差异化商品需求**：

$$
\int_0^s Q_t^D(h,x)\,dx=\left(\frac{p_t(h)}{P_{Q,t}}\right)^{-\theta}Q_t.
$$

- **(F3) 分销部门价格楔子**：

$$
p_t(n)=\bar p_t(n),\qquad p_t(h)=\bar p_t(h)+\eta P_{N,t},\qquad p_t(f)=\bar p_t(f)+\eta P_{N,t}.
$$

- **(F4) 含分销服务的非贸易品需求**：

$$
N_t^D(n)=\left(\frac{p_t(n)}{P_{N,t}}\right)^{-\theta}
\left[N_{N,t}+\eta(Q_t+M_t)+G_{N,t}\right].
$$

- **(F5) 劳动投入需求和工资指数**：

$$
\ell_t^D(n,j)=\frac{1}{s}\left(\frac{W_t(j)}{W_t}\right)^{-\phi}\ell_t(n),
\qquad
W_t=\left[\frac{1}{s}\int_0^s W_t(j)^{1-\phi}\,dj\right]^{1/(1-\phi)}.
$$

- **(F6) 非贸易品边际成本指数**：

$$
MC_{N,t}=Z_{N,t}^{-1}\left[(1-\alpha_N-\gamma_N)W_t^{1-\xi_N}
+\alpha_NR_t^{1-\xi_N}
+\gamma_NP_{O,N,t}^{1-\xi_N}\Xi_{O,N,t}^{\xi_N-1}\right]^{1/(1-\xi_N)}.
$$

`needs_review`：论文说明成本最小化给出边际成本，但未打印这个精确表达式；该形式由 CES 对偶推得，并与实现交叉检查。

- **(F7) 贸易品边际成本指数**：

$$
MC_{T,t}=Z_{T,t}^{-1}\left[(1-\alpha_T-\gamma_T)W_t^{1-\xi_T}
+\alpha_TR_t^{1-\xi_T}
+\gamma_TP_{O,T,t}^{1-\xi_T}\Xi_{O,T,t}^{\xi_T-1}\right]^{1/(1-\xi_T)}.
$$

`needs_review`：来源限制同 (F6)。

- **(F8) 原材料边际成本**：

$$
P_{QO,t}=
\frac{\left[(1-\alpha_O-\gamma_O)W_t^{1-\xi_O}
+\alpha_OR_t^{1-\xi_O}
+\gamma_OP_{L,t}^{1-\xi_O}\right]^{1/(1-\xi_O)}}{Z_{O,t}}.
$$

- **(F9) 原材料一价定律**：

$$
P_{MO,t}^{\ast}=\frac{P_{QO,t}}{\mathcal E_t}.
$$

- **(F10) 非贸易品价格调整成本**：

$$
\Gamma_{PN,t}(n)=\frac{\phi_N}{2}
\left(\frac{p_t(n)/p_{t-1}(n)}{P_{N,t-1}/P_{N,t-2}}-1\right)^2.
$$

- **(F11) 非贸易品灵活价格加成极限**：

$$
p_t(n)=\frac{\theta}{\theta-1}MC_t(n).
$$

- **(F12) 含分销成本的灵活价格出口定价**：

$$
\bar p_t(h)=\frac{\theta}{\theta-1}MC_t(h)+\frac{\eta}{\theta-1}P_{N,t},
\qquad
\mathcal E_t\bar p_t^{\ast}(h)=\frac{\theta}{\theta-1}MC_t(h)+\frac{\eta^{\ast}}{\theta-1}\mathcal E_tP_{N,t}^{\ast}.
$$

- **(F13) 随机贴现因子 / 定价核**：

$$
D_{t,\tau}=\beta^{\tau-t}\frac{P_tU'(C_\tau)\left[1+\Gamma_{S,t}+\Gamma'_{S,t}v_t\right]}
{P_\tau U'(C_t)\left[1+\Gamma_{S,\tau}+\Gamma'_{S,\tau}v_\tau\right]}.
$$

`needs_review`：MinerU OCR 在 Eq. (34) 中显示前导 $\beta$，而不是 $\beta^{\tau-t}$；指数来自 Eq. (25) 的推断。

- **(F14) 国内债券 Euler 方程**：

$$
1=(1+i_{t+1})E_tD_{t,t+1}.
$$

- **(F15) 风险调整的未抛补利率平价**：

$$
1=(1+i_{t+1}^{\ast})(1-\Gamma_{B,t+1})
E_t\left(D_{t,t+1}\frac{\mathcal E_{t+1}}{\mathcal E_t}\right).
$$

- **(F16) 外币债券中介楔子**：

$$
\Gamma_{B,t+1}=\phi_{B1}
\frac{\exp\left(\phi_{B2}\mathcal E_tB_{H,t+1}^{\ast}/P_t\right)-1}
{\exp\left(\phi_{B2}\mathcal E_tB_{H,t+1}^{\ast}/P_t\right)+1}
+Z_{B,t}.
$$

- **(F17) 资本积累**：

$$
K_{t+1}(j)=(1-\delta)K_t(j)+\Psi_tK_t(j).
$$

- **(F18) 投资调整技术**：

$$
\Psi_t=\frac{I_t(j)}{K_t(j)}
-\frac{\phi_{I1}}{2}\left(\frac{I_t(j)}{K_t(j)}-\delta(1+Z_{I,t})\right)^2
-\frac{\phi_{I2}}{2}\left(\frac{I_t(j)}{K_t(j)}-\frac{I_{t-1}}{K_{t-1}}\right)^2.
$$

- **(F19) 工资调整成本**：

$$
\Gamma_{W,t}(j)=\frac{\phi_W}{2}
\left(\frac{W_t(j)/W_{t-1}(j)}{W_{t-1}/W_{t-2}}-1\right)^2.
$$

- **(F20) 家庭横截条件**：

$$
\lim_{\tau\to\infty}E_tD_{t,\tau}
\left[\mathcal M_{\tau-1}(j)+(1+i_\tau)B_\tau(j)+(1+i_\tau^{\ast})(1-\Gamma_{B,\tau})\mathcal E_\tau B_\tau^{\ast}(j)\right]=0.
$$

- **(F21) 政府预算约束**：

$$
sP_tG_{A,t}+sP_{N,t}G_{N,t}
\leq \int_0^s NETT_t(j)\,dj+\int_0^s\left[\mathcal M_t(j)-\mathcal M_{t-1}(j)\right]\,dj.
$$

- **(F22) 年化货币政策规则**：

$$
(1+i_{t+1})^4-1=\omega_i\left[(1+i_t)^4-1\right]
+(1-\omega_i)\left[(1+\bar i_{t+1})^4-1\right]
+\omega_1E_t\left[\frac{P_{t+\tau}}{P_{t+\tau-4}}-\Pi_{t+\tau}\right]
+\Theta(F_t).
$$

`needs_review`：论文 Eq. (38) 在预测期符号和目标通胀记号处存在 OCR 歧义。

## 4. Market Clearing & Identities

- **(F23) 原材料市场出清**：

$$
\int_0^s T_{O,t}^S(o)\,do
=\int_0^s Q_{O,t}^D(n)\,dn+\int_0^s Q_{O,t}^D(h)\,dh
+\int_s^1 M_{O,t}^{D\ast}(n^{\ast})\,dn^{\ast}+\int_s^1 M_{O,t}^{D\ast}(f)\,df.
$$

- **(F24) 非贸易品市场出清**：

$$
N^S(n)=\int_0^s N_{N,t}^D(n,x)\,dx+\eta(Q_t+M_t)+G_{N,t}.
$$

- **(F25) 贸易品市场出清**：

$$
T^S(h)=\int_0^s Q_t^D(h,x)\,dx+\int_s^1 M_t^{\astD}(h,x^{\ast})\,dx^{\ast}.
$$

- **(F26) 最终品资源约束**：

$$
\int_0^s A_t(x)\,dx=\int_0^s C_t(j)(1+\Gamma_{S,t}(j))\,dj+sG_{A,t}+\int_0^s I_t(j)\,dj.
$$

- **(F27) 劳动市场出清**：

$$
\ell_t(j)=\int_0^s\ell_t^D(n,j)\,dn+\int_0^s\ell_t^D(h,j)\,dh+\int_0^s\ell_t^D(o,j)\,do.
$$

- **(F28) 资本市场出清**：

$$
\int_0^sK_t(j)\,dj=\int_0^sK_t^D(n)\,dn+\int_0^sK_t^D(h)\,dh+\int_0^sK_t^D(o)\,do.
$$

- **(F29) 土地市场出清**：

$$
\int_0^s\bar L_t(j)\,dj=\int_0^sL_t^D(o)\,do.
$$

- **(F30) 资产市场出清**：

$$
\int_0^sB_t(j)\,dj=0,\qquad
\int_0^sB_t^{\ast}(j)\,dj+\int_s^1B_t^{\ast}(j^{\ast})\,dj^{\ast}=0.
$$

`needs_review`：MinerU 将 Eq. (46) 的两个资产出清方程合并；这里按上下文拆分。

- **(F31) Home GDP 恒等式，仅实现交叉检查**：

$$
GDPH=AH+REALPNH\cdot GNH+EXPORTSH-IMPORTSH+(RNOMF_{t-1}-1)\frac{REALEX_tREALBH_{t-1}}{PIEF_t}.
$$

- **(F32) Home 经常账户比率，仅实现交叉检查**：

$$
CURBALH\_RAT=\frac{REALEX_t(REALBH_t-REALBH_{t-1}/PIEF_t)}{GDPH_t}.
$$

## 5. Exogenous Processes

论文说明每个随机过程采用 AR(1) 形式 $y_t=(1-\psi)\bar y+\psi y_{t-1}+\epsilon_t^y$，作用于变量水平或对数。

- **(F33) 通用水平冲击**：

$$
y_t=(1-\rho_y)\bar y+\rho_yy_{t-1}+\varepsilon_t^y.
$$

- **(F34) 通用对数冲击**：

$$
\log y_t=(1-\rho_y)\log\bar y+\rho_y\log y_{t-1}+\varepsilon_t^y.
$$

- **(F35) 风险溢价冲击**：

$$
Z_{B,t}=(1-\rho_B)\bar Z_B+\rho_BZ_{B,t-1}+\varepsilon_t^B.
$$

- **(F36) 贸易品偏好权重冲击**：

$$
\log\gamma_t=(1-\rho_\gamma)\log\bar\gamma+\rho_\gamma\log\gamma_{t-1}+\varepsilon_t^\gamma.
$$

来源和实现交叉检查显示，模型包含生产率 $(Z_N,Z_T,Z_O)$、投资/折旧 $(Z_I)$、消费边际效用 $(Z_U)$、劳动边际负效用 $(Z_V)$、政府吸收 $(G_A)$、偏好权重 $(\gamma)$、风险溢价 $(Z_B)$、土地/生产率组冲击以及通胀目标冲击。

## 6. Steady-State Solution

论文没有打印完整闭式稳态块。它说明非线性稳态通过 Newton 型 divide-and-conquer 方法求解：先从更容易的近似线性参数化开始，再逐步把参数和外生变量调到目标校准。因此，第一遍归档记录有来源支持的稳态限制，而不虚构闭式解。

关键稳态限制：

- **(F37) 稳态实际总利率**：

$$
1+r=\frac{1}{\beta}.
$$

- **(F38) 稳态名义利率和通胀**：

$$
1+i=\frac{\pi}{\beta}.
$$

- **(F39) 净外国资产的无中介稳态**：

$$
B_H^{\ast}=0,\qquad \Gamma_B=0.
$$

- **(F40) 资本租金稳态限制**：

$$
1+\frac{R}{P}=\frac{1}{\beta}+\delta.
$$

- **(F41) 实际工资稳态条件**：

$$
\frac{W}{P}=\frac{\phi}{\phi-1}\frac{V'(\ell)}{U'(C)}.
$$

- **(F42) 政府支出份额**：

$$
\frac{G_N}{GDP}=0.10,\qquad \frac{G_A}{GDP}=0.05.
$$

- **(F43) 核心校准值**：

$$
s=0.05,\quad \beta=1.03^{-0.25},\quad \theta=\theta^{\ast}=6,\quad
\phi=\phi^{\ast}=4,\quad \delta=\delta^{\ast}=0.025.
$$

来源还记录了 Home 进口份额、Home/Foreign 开放度权重、材料/投入份额、分销参数、习惯持久性 $b=0.95$、跨期替代参数 $\sigma=1/3$ 和劳动负效用曲率 $\zeta=2.5$ 等稳态目标。实现交叉检查包含数值 `initval`，但这里不将其提升为论文侧推导证据。

## 7. Timing & Form Conventions

- 周期为季度。
- 存量：论文写作 $K_{t+1}=(1-\delta)K_t+\Psi_tK_t$；Rep-MMB 代码写为 `K = K(-1)*(1-delta)+PSI(-1)*K(-1)`，所以第 $t$ 期生产使用预定资本。
- 债券：短期名义利率 $i_t$ 和 $i_t^{\ast}$ 在第 $t$ 期期初支付，并在 $t-1$ 已知；Euler 方程使用在 $t$ 选择的 $i_{t+1}$。
- 汇率：$\mathcal E_t$ 为每单位 Foreign 货币对应的 Home 货币。贬值进入风险调整 UIP 条件。
- 国家记号：论文中 Home 不加星号、Foreign 加星号。实现中小型 Home 经济用 `H`，大型 Foreign 经济用 `F`。
- 模型形式：非线性均衡条件用于求稳态，再线性化进行随机政策分析。MMB 实现没有声明 `model(linear)`。
- 运行时验证：未执行；没有运行 Dynare 命令。
- 公式不确定性：(F4)、(F6)、(F7)、(F13)、(F22) 和 (F30) 因 OCR 损坏、来源只给文字而非打印 FOC，或仅来自实现压缩，均为 `needs_review`。

## 8. Variable & Parameter Reference Table

### 内生变量

| 符号 / ASCII | 含义 | 方程参考 |
|---|---|---|
| $A$, `AH`, `AF` | 最终品 / 吸收 | (F26), (F31) |
| $N_N$, `NNH`, `NNF` | 非贸易品投入篮子 | (F1), (F4), (F24) |
| $Q$, `QH`, `QF` | 国内贸易品篮子 | (F2), (F23), (F25) |
| $M$, `MH`, `MF` | 进口贸易品篮子 | (F3), (F4), (F26) |
| $N$, `NH`, `NF` | 非贸易中间品产出 | (F4), (F24) |
| $T$, `TH`, `TF` | 贸易中间品产出 | (F25) |
| $T_O$, `T_OH`, `T_OF` | 原材料产出 | (F8), (F23) |
| $O_N,O_T$, `O_NH`, `O_TH` | 材料复合投入 | (F6), (F7) |
| $C$, `CH`, `CF` | 消费 | (F13), (F26) |
| $I$, `EYEH`, `EYEF` | 投资 | (F17), (F18), (F26) |
| $K$, `KH`, `KF` | 资本存量 | (F17), (F28), (F40) |
| $\ell$, `LH`, `LF` | 劳动 | (F5), (F27), (F41) |
| $L$, `LANDH`, `LANDF` | 土地 | (F8), (F29) |
| $P_N,P_Q,P_M$, `REALPNH`, `REALPQH`, `REALPMH` | 相对价格 | (F1), (F3), (F8) |
| $MC_N,MC_T$, `REALMCNH`, `REALMCTH` | 实际边际成本 | (F6), (F7), (F11), (F12) |
| $W$, `REALWH`, `REALWF` | 工资 | (F5), (F19), (F41) |
| $R$, `REALRH`, `REALRF` | 资本租金率 | (F6), (F7), (F40) |
| $i$, `RNOMH`, `RNOMF` | 名义政策利率 | (F14), (F22), (F38) |
| $B^{\ast}$, `REALBH`, `REALBF` | 外币债券头寸 | (F15), (F16), (F30), (F32) |
| $\mathcal E$, `REALEX` | 名义/实际汇率块 | (F9), (F15), (F32) |
| $GDP$, `GDPH`, `GDPF` | GDP 核算对象 | (F31), (F32) |
| $\Pi_4$, `PIE4H`, `PIE4F` | 年通胀 | (F22), (F38) |

### 外生冲击

| 符号 / ASCII | 含义 | 过程 |
|---|---|---|
| $Z_B$, `ZBH`, `ZBF` | 风险溢价 / UIP 冲击 | (F35) |
| $Z_N,Z_T,Z_O$ | 部门生产率冲击 | (F34) |
| $Z_I$, `ZEYEH`, `ZEYEF` | 投资/折旧冲击 | (F33) |
| $Z_U$, `ZUH`, `ZUF` | 消费边际效用冲击 | (F34) |
| $Z_V$, `CAPAH`, `CAPAF` | 实现中的劳动负效用冲击 | (F33) |
| $G_A$, `GAH`, `GAF` | 政府吸收冲击 | (F33) |
| $\gamma$, `GAMMAH`, `GAMMAF` | 贸易品偏好权重冲击 | (F36) |
| `E_PIE4TARH`, `E_PIE4TARF` | 通胀目标创新 | (F33) |

### 参数

| 符号 / ASCII | 含义 | 来源数值 / 说明 |
|---|---|---|
| $s$, `SSH` | Home 国家规模 | $0.05$ |
| $\beta$, `BET` | 贴现因子 | $1.03^{-0.25}$ |
| $\theta$, `THETAH`, `THETAF` | 中间品替代弹性 | $6$ |
| $\phi$, `PHIH`, `PHIF` | 劳动投入替代弹性 | 论文校准为 $4$；实现参数化使用相关工资加成对象 |
| $\epsilon$, `EPSH`, `EPSF` | 贸易品/非贸易品替代弹性 | $1.1$ |
| $\epsilon_{QM}$, `EPSQMH`, `EPSQMF` | Home/Foreign 贸易品复合替代弹性 | Home 和 Foreign 校准不同 |
| $\xi_N,\xi_T,\xi_O$, `XIXI_*` | 投入替代弹性 | 基准为 $0.75$ |
| $\alpha_N,\alpha_T,\alpha_O$ | 资本份额 | 分部门、分国家 |
| $\gamma_N,\gamma_T,\gamma_O$ | 材料/土地份额 | 分部门、分国家 |
| $\eta$, `ETAH`, `ETAF` | 分销服务参数 | 论文文本中 Home 为 $0.2$、Foreign 为 $0.35$ |
| $b$, `B1H`, `B1F` | 习惯持久性 | $0.95$ |
| $\sigma$, `SIGMAH`, `SIGMAF` | 消费曲率 | $1/3$ |
| $\zeta$, `ZEDH`, `ZEDF` | 劳动负效用曲率 | $2.5$ |
| $\delta$, `DELTAH`, `DELTAF` | 折旧 | $0.025$ |
| $\phi_{B1},\phi_{B2}$, `CHI0`, `CHI1` | 债券中介成本参数 | $0.05$, $0.1$ |
| $\omega_i,\omega_1,\omega_2$, `XR3H`, `XR1H`, `XR2H` | 政策规则系数 | MMB 变体在实现中使用表 4 第二行的最优值 |
