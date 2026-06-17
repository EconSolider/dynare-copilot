# NK_PSV16 - 推导（最优化问题与均衡条件）

> 本推导是 Model ID `NK_PSV16` 的第一版私有归档条目。来源为 Pancrazi、Seoane 和 Vukotic (2016) 的 MinerU Markdown，论文题名为 "The price of capital and the financial accelerator"；`.agents/skills/dynare-copilot/references/examples/NK_PSV16_rep.mod` 仅作为 `implementation_cross_check` 使用。未进行运行时验证。

## 1. Model Overview

- **模型**：`NK_PSV16`，Pancrazi, Roberto; Seoane, Hernan D.; Vukotic, Marija (2016)，"The price of capital and the financial accelerator"，*Economics Letters* 149, 86-89，DOI `10.1016/j.econlet.2016.10.022`。
- **来源文件**：`raw/mmb_mineru/runs/nk_psv16__the_price_of_capital_and_the_financial_accelerator__a468e7e7/full.md`；原始 PDF 为 `raw/mmb_papers/The price of capital and the financial accelerator.pdf`；MinerU run id 为 `a468e7e7-073f-4a72-a489-1ee9eba05671`。
- **用途**：在 BGG 金融加速器模型中加入既有资本的均衡价格。论文说明，当折旧率为正时，用扣除折旧后的新资本价格替代既有资本均衡价格会产生一阶影响。
- **主体**：家庭、财政和货币当局、企业家、零售商、资本生产企业。论文说明前四个模块沿用标准 BGG 框架，并正式推导资本生产企业模块，因为该模块决定本文结果。
- **形式**：线性化新凯恩斯金融加速器系统。下方多数基准方程依据 `NK_PSV16_rep.mod` 交叉核对；(F5)、(F11)、(F12) 和 (F15) 是论文给出的资本价格条件。论文第 (9) 式对应 (F15)，并标为 `needs_review`，因为 OCR/论文表达与实现交叉核对结果不一致。

## 2. Optimization Problems

### 2.1 家庭

论文描述了无限期、风险厌恶的家庭。家庭在给定价格下选择消费、工时、货币持有和存款。论文省略了精确目标函数和预算约束，因为这些条件不影响资本价格结果。下方线性化家庭欧拉方程因此归类为 `implementation_cross_check`。

### 2.2 企业家

企业家风险中性，拥有生产技术，以固定概率存活，向资本生产企业购买资本，雇用劳动，并用净值与借款融资。贷款人与借款人的关系包含 costly-state-verification 金融摩擦。论文给出的总量资本需求为：

$$
E_t R^k_{t+1}
= E_t\left\{\frac{MPK_{t+1}+\tilde Q_{t+1}}{Q_t}\right\}.
$$

外部融资供给曲线为：

$$
E_t R^k_{t+1}
= s\left(\frac{N_{t+1}}{Q_tK_{t+1}}\right)R_{t+1}.
$$

### 2.3 零售商与政策当局

零售商处于垄断竞争，并受 Calvo 名义刚性约束。政府预算使用一次性税收和货币创造，货币政策遵循 Taylor 型名义利率规则。论文没有正式推导 Calvo 和政策方程；下方方程依据论文描述并结合 `implementation_cross_check`。

### 2.4 资本生产企业

资本生产企业购买投资品 $I_t$ 和旧资本 $K_t$，将其转化为下一期资本，并以价格 $Q_t$ 出售新资本。企业以价格 $\tilde Q_t$ 购买既有资本。生产技术为：

$$
K_{t+1}=\Phi\left(\frac{I_t}{K_t}\right)K_t+(1-\delta)K_t.
$$

代表性企业求解：

$$
\max_{\{K_t,I_t\}}\; Q_tK_{t+1}-I_t-\tilde Q_tK_t
\quad\text{s.t.}\quad
K_{t+1}=\Phi\left(\frac{I_t}{K_t}\right)K_t+(1-\delta)K_t.
$$

## 3. First-Order Conditions

- **(F1) 消费欧拉方程**（`implementation_cross_check`）：

$$
c_t=E_t c_{t+1}-r_t.
$$

- **(F2) Fisher 关系**（`implementation_cross_check`）：

$$
rn_t=r_t+E_t\pi_{t+1}.
$$

- **(F3) 企业家消费与净值**（`implementation_cross_check`）：

$$
ce_t=n_t.
$$

- **(F4) 外部融资溢价 / 资本供给**（`implementation_cross_check`）：

$$
E_t rk_{t+1}-r_t=-\nu\big(n_t-q_t-k_t\big).
$$

- **(F5) 使用既有资本均衡价格的资本回报**（`source_stated`，论文第 8 式；索引时点沿用来源方程）：

$$
E_t r^k_{t+1}
=(1-\epsilon)(y_{t+1}-k_{t+1}-x_{t+1})+\epsilon\tilde q_{t+1}-q_t.
$$

- **(F6) 新安装资本价格**（`implementation_cross_check`）：

$$
q_t=\psi(i_t-k_{t-1}).
$$

- **(F7) 生产函数**（`implementation_cross_check`）：

$$
y_t=a_t+\alpha k_{t-1}+(1-\alpha)\omega h_t.
$$

- **(F8) 劳动需求 / 家庭静态条件**（`implementation_cross_check`）：

$$
y_t-h_t-x_t-c_t=\eta^{-1}h_t.
$$

- **(F9) 新凯恩斯 Phillips 曲线**（`implementation_cross_check`）：

$$
\pi_t=\kappa(-x_t)+\beta E_t\pi_{t+1}.
$$

- **(F10) 净值积累**（`implementation_cross_check`）：

$$
n_t=\gamma R K_N(rk_t-r_{t-1})+r_{t-1}+n_{t-1}.
$$

- **(F11) 新安装资本价格的一阶条件**（`source_stated`，论文第 5 式）：

$$
Q_t=\left[\Phi'\left(\frac{I_t}{K_t}\right)\right]^{-1}.
$$

- **(F12) 既有资本均衡价格的一阶条件**（`source_stated`，论文第 6 式）：

$$
\tilde Q_t
=\left[
(1-\delta)
+\Phi\left(\frac{I_t}{K_t}\right)
-\Phi'\left(\frac{I_t}{K_t}\right)\frac{I_t}{K_t}
\right]Q_t.
$$

## 4. Market Clearing & Identities

- **(F13) 总资源约束**（`implementation_cross_check`）：

$$
y_t=C_Yc_t+I_Yi_t+G_Yg_t+Ce_Yce_t.
$$

- **(F14) 资本积累**（`implementation_cross_check`）：

$$
k_t=\delta i_t+(1-\delta)k_{t-1}.
$$

- **(F15) 线性化既有资本均衡价格**（`source_stated with needs_review`；论文第 9 式）：

$$
\tilde q_t
=-\frac{\delta\varphi}{1-\delta}i_t
-\frac{\delta\varphi}{1-\delta}k_t
+q_t.
$$

`needs_review`：实现交叉核对中为 `qtilde = delta*psi/(1-delta)*i - delta*psi/(1-delta)*k(-1) + q`，它与投资项符号以及资本时点都不同。来源 Markdown 对 $\varphi$ 的定义也有明显 OCR 噪声。本条保留来源方程并记录差异。

## 5. Exogenous Processes

- **(F16) 货币政策规则**（`implementation_cross_check`）：

$$
rn_t=\rho rn_{t-1}+S\pi_{t-1}+e^M_t.
$$

- **(F17) 政府支出过程**（`implementation_cross_check`）：

$$
g_t=\rho_Gg_{t-1}+e^G_t.
$$

- **(F18) 技术过程**（`implementation_cross_check`）：

$$
a_t=\rho_Aa_{t-1}+e^A_t.
$$

## 6. Steady-State Solution

模型围绕确定性 BGG 型稳态线性化。对 Dynare `model(linear)` 实现交叉核对而言，小写偏离变量的稳态均为零：

$$
\bar y=\bar c=\bar i=\bar g=\bar{ce}=\bar n=\bar{rk}=\bar r=\bar q=\bar k=\bar x=\bar a=\bar h=\bar\pi=\bar{rn}=\bar{\tilde q}=0.
$$

实现交叉核对使用的校准常数为：

$$
\beta=0.99,\quad R=\frac{1}{\beta},\quad \alpha=0.35,\quad
\delta=0.025,\quad \rho_A=0.999,\quad \rho_G=0.95,
$$

$$
C_Y=0.61,\quad I_Y=0.18,\quad G_Y=0.20,\quad Ce_Y=0.01,\quad
K_N=2.00,\quad Y_N=0.28,\quad X=1.10.
$$

论文给出的稳态关系为：在稳态，$\Phi(I/K)=\delta$、$\Phi'(I/K)=1$、$I/K=\delta$。因此：

$$
\bar Q=1,\qquad \bar{\tilde Q}=1-\delta.
$$

论文定义：

$$
\epsilon
=\frac{1-\delta}{(1-\delta)+\alpha Y/(XK)}.
$$

来源 Markdown 对 $\varphi$ 的定义渲染不清；实现中在线性化 `qtilde` 方程里使用调整成本参数 `psi`。该映射标为 `needs_review`。

## 7. Timing & Form Conventions

- **形式**：线性化模型；实现交叉核对为直接写成偏离变量的 Dynare `model` 块。
- **资本时点**：实现使用 $k_{t-1}$ 进入生产，并由资本积累方程决定 $k_t$，所以 $k_t$ 是期末存量，在 $t+1$ 期生产中使用。
- **既有资本价格时点**：来源回报方程使用 $E_t\tilde q_{t+1}$ 和当期 $q_t$。实现交叉核对使用 `rk = ... + eps*qtilde - q(-1)`，对应在 $t$ 期实现的、基于更早资本选择的回报。
- **存量与净值时点**：实现交叉核对中，净值依赖滞后净值和滞后安全利率。
- **运行时验证**：未执行。`.mod` 文件仅作为 `implementation_cross_check` 阅读；没有运行 Dynare。

## 8. Variable & Parameter Reference Table

| 类别 | 符号 / ASCII 名称 | 含义 | 方程引用 |
|---|---|---|---|
| 内生 | `y`, $y_t$ | 产出 | (F13), (F7) |
| 内生 | `c`, $c_t$ | 家庭消费 | (F1), (F13) |
| 内生 | `i`, $i_t$ | 投资 | (F6), (F14), (F15) |
| 内生 | `g`, $g_t$ | 政府支出 | (F13), (F17) |
| 内生 | `ce`, $ce_t$ | 企业家消费 | (F3), (F13) |
| 内生 | `n`, $n_t$ | 企业家净值 | (F3), (F4), (F10) |
| 内生 | `rk`, $rk_t$ | 资本回报 | (F4), (F5), (F10) |
| 内生 | `r`, $r_t$ | 实际利率 | (F1), (F2), (F4) |
| 内生 | `q`, $q_t$ | 新安装资本价格 | (F5), (F6), (F11), (F12), (F15) |
| 内生 | `k`, $k_t$ | 资本存量 | (F4), (F5), (F7), (F14), (F15) |
| 内生 | `x`, $x_t$ | 总加成 / 边际成本倒数项 | (F5), (F8), (F9) |
| 内生 | `a`, $a_t$ | 技术 | (F7), (F18) |
| 内生 | `h`, $h_t$ | 工时 | (F7), (F8) |
| 内生 | `pi`, $\pi_t$ | 通胀 | (F2), (F9), (F16) |
| 内生 | `rn`, $rn_t$ | 名义利率 | (F2), (F16) |
| 内生 | `qtilde`, $\tilde q_t$ | 既有资本价格 | (F5), (F12), (F15) |
| 外生 | `eM` | 货币政策创新 | (F16) |
| 外生 | `eG` | 政府支出创新 | (F17) |
| 外生 | `eA` | 技术创新 | (F18) |
| 参数 | `beta` | 贴现因子 | (F1), (F9) |
| 参数 | `eta` | 劳动偏好 / Frisch 相关参数 | (F8) |
| 参数 | `alpha` | 资本份额 | (F7), (F18) |
| 参数 | `delta` | 折旧率 | (F12), (F14), (F15) |
| 参数 | `omega` | 劳动投入缩放 | (F7) |
| 参数 | `eps` / $\epsilon$ | 资本回报方程权重 | (F5) |
| 参数 | `C_Y`, `I_Y`, `G_Y`, `Ce_Y` | 支出份额 | (F13) |
| 参数 | `Y_N`, `K_N`, `X` | 稳态比率和加成 | (F5), (F7), (F10) |
| 参数 | `rhoA`, `rhoG`, `rho`, `S` | AR 与政策参数 | (F16)-(F18) |
| 参数 | `psi` / $\varphi$ | 投资调整成本斜率参数 | (F6), (F15) |
| 参数 | `gamma`, `nu` | 存活率和外部融资溢价参数 | (F4), (F10) |
| 参数 | `theta`, `kappa` | Calvo 与 Phillips 曲线参数 | (F9) |

状态：`needs_review`。原因是本归档条目用论文方程支持资本价格贡献，但多数 BGG 基准系统依赖实现交叉核对重建；同时论文第 (9) 式与 `.mod` 中 `qtilde` 的符号/时点存在差异。
