# CA_LS07 - 推导（最优化问题 + 一阶条件）

`CA_LS07` 的来源支撑第一版推导。状态：`needs_review`。

来源：Lubik and Schorfheide (2007), "Do central banks respond to exchange rate movements? A structural investigation", Journal of Monetary Economics 54(4), 1069-1087, DOI `10.1016/j.jmoneco.2006.01.009`。主要 Markdown 来源：`raw/mmb_mineru/runs/ca_ls07__do_central_banks_respond_to_exchange_rate_movements_a_structural_investi__075fd116/full.md`。已检查原始 PDF 路径存在：`raw/mmb_papers/Do central banks respond to exchange rate movements? A structural investigation.pdf`。MinerU run id：`075fd116-e951-48af-9644-dfddec2c1ac6`。

## 1. Model Overview

- **模型**：`CA_LS07`，Lubik and Schorfheide 小型结构性小开放经济新凯恩斯模型的加拿大实现。
- **目的**：估计加拿大央行在 Taylor 型货币政策规则中是否对名义汇率贬值作出反应。
- **主体与模块**：优化家庭给出开放经济 IS 曲线；具有名义刚性的国内厂商给出开放经济 Phillips 曲线；货币政策遵循利率规则；CPI 在相对 PPP 假设下连接国内通胀、名义贬值、贸易条件增长和世界通胀；贸易条件增长、技术增长、世界产出和世界通胀在实现规格中为外生过程。
- **模型形式**：线性理性预期模型。实现交叉检查使用 `model(linear)`，并且所有实际变量都表示为相对于非平稳技术过程的百分比偏离。
- **MMB 复制使用的加拿大特定校准 / 后验均值**：实现交叉检查记录 `tau=0.31`、`alfa=0.11`、`rhoz=0.42`、`rss=2.52`、`kappa=0.32`、`rhoR=0.69`、`psi1=1.3`、`psi2=0.23`、`psi3=0.14`、`rhoq=0.31`、`rhoy_star=0.97` 和 `rhopi_star=0.46`。

## 2. Optimization Problems

论文给出最终的线性结构方程，而不是完整的原始家庭和厂商问题。因此，本推导在约化均衡层面有来源支撑：

- **家庭**在小开放经济中进行跨期消费选择。其 Euler 方程在把实际变量表示为相对于随机技术趋势的变量、并使用基于 CPI 的实际利率后，得到 (F1) 中的开放经济 IS 曲线。
- **国内厂商**在名义刚性下设定价格。最优定价产生 (F2) 中的开放经济 Phillips 曲线。斜率参数 `\kappa` 在估计系统中被作为结构参数处理。
- **货币当局**通过带利率平滑的规则设定名义利率偏离，并对 CPI 通胀、产出和名义汇率贬值作出反应，如 (F3)。
- **外部部门 / 小开放经济闭合**使用相对 PPP 的 CPI 通胀关系，并在估计实现中把贸易条件增长视为外生。论文还展示了完全结构性的贸易条件市场出清关系，但明确说明估计模型用贸易条件冲击过程替代该关系。

Markdown 来源没有重现原始效用、生产和 Calvo 重置价格表达式；从 Galí-Monacelli 原始结构重新推导这些内容留待后续。`needs_review`：下面的提取在被视为最终数学文档之前，应与发表 PDF 或作者原始代码核对。

## 3. First-Order Conditions

- **(F1) 开放经济 IS 曲线**，来自消费 Euler 方程：

\[
y_t = E_t y_{t+1}
- \left[\tau + \alpha(2-\alpha)(1-\tau)\right]\left(R_t - E_t\pi_{t+1}\right)
- \rho_z z_t
- \alpha\left[\tau + \alpha(2-\alpha)(1-\tau)\right]E_t\Delta q_{t+1}
+ \alpha(2-\alpha)\frac{1-\tau}{\tau}E_t\Delta y^{\ast}_{t+1}.
\]

- **(F2) 开放经济 Phillips 曲线**，来自最优价格设定：

\[
\pi_t = \beta E_t\pi_{t+1}
+ \alpha\beta E_t\Delta q_{t+1}
- \alpha\Delta q_t
+ \frac{\kappa}{\tau+\alpha(2-\alpha)(1-\tau)}(y_t-\bar y_t).
\]

- **(F3) 货币政策规则**，含利率平滑和汇率反应：

\[
R_t = \rho_R R_{t-1}
+ (1-\rho_R)\left[\psi_1\pi_t+\psi_2 y_t+\psi_3\Delta e_t\right]
+ \varepsilon^R_t.
\]

`needs_review`：方程 (F1)-(F3) 转录自 MinerU OCR，并用实现文件的变量清单作了交叉检查。本轮没有与 PDF 正文核对。

## 4. Market Clearing & Identities

- **(F4) 无名义刚性时的潜在产出**：

\[
\bar y_t = -\alpha(2-\alpha)\frac{1-\tau}{\tau}y^{\ast}_t.
\]

- **(F5) CPI / 相对 PPP 恒等式**：

\[
\pi_t = \Delta e_t + (1-\alpha)\Delta q_t + \pi^{\ast}_t.
\]

- **(F6) 实现中使用的世界产出增长恒等式**：

\[
\Delta y^{\ast}_t = y^{\ast}_t-y^{\ast}_{t-1}.
\]

- **(F7) 年化 CPI 通胀报告恒等式**：

\[
\mathrm{inflationq}_t = 4\pi_t.
\]

- **(F8) 年化名义利率报告恒等式**：

\[
\mathrm{interest}_t = 4R_t.
\]

论文中的完全结构性贸易条件市场出清关系为：

\[
\left[\tau+\alpha(2-\alpha)(1-\tau)\right]\Delta q_t = \Delta y^{\ast}_t-\Delta y_t.
\]

估计和复制模型不把该式作为均衡条件；它被外生过程 (F9) 替代。这个排除既由来源说明，也由实现交叉检查确认。

## 5. Exogenous Processes

- **(F9) 贸易条件增长冲击**：

\[
\Delta q_t = \rho_q \Delta q_{t-1}+\varepsilon_{q,t}.
\]

- **(F10) 技术增长冲击**：

\[
z_t = \rho_z z_{t-1}+\varepsilon^z_t.
\]

- **(F11) 世界产出冲击**：

\[
y^{\ast}_t = \rho_{y^{\ast}}y^{\ast}_{t-1}+\varepsilon^{y^{\ast}}_t.
\]

- **(F12) 世界通胀冲击**：

\[
\pi^{\ast}_t = \rho_{\pi^{\ast}}\pi^{\ast}_{t-1}+\varepsilon^{\pi^{\ast}}_t.
\]

政策冲击 `\varepsilon^R_t` 进入 (F3) 的规则。实现交叉检查中的五个创新名称为 `epsR`、`epsq`、`epsy_star`、`epspi_star` 和 `epsz`。

## 6. Steady-State Solution

因为 `CA_LS07` 是 `model(linear)` 实现，模型变量是围绕稳态的偏离或增长率偏离。因此 Dynare 稳态中所有内生变量为零：

\[
y=R=\pi=z=\Delta q=\Delta y^{\ast}=y^{\ast}=\bar y=\Delta e=\pi^{\ast}=\mathrm{inflationq}=\mathrm{interest}=0.
\]

贴现因子由年化稳态实际利率参数化：

\[
\beta = \exp(-r/400).
\]

对于加拿大复制，实现交叉检查使用 `rss=2.52`，因此 `beta=exp(-2.52/400)`。未执行运行时验证。

## 7. Timing & Form Conventions

- 期望以 `t` 为信息时点；在 Dynare 记法中，`x(+1)` 对应线性理性预期方程中的 `E_t x_{t+1}`。
- `R_t`、`\pi_t`、`y_t`、`\Delta e_t` 和 `\Delta q_t` 是偏离 / 增长率变量，不是非线性总量水平。
- `y_t` 是相对于非平稳技术过程的产出。观测产出增长对应于 `\Delta y_t + z_t`。
- `\Delta q_t` 是贸易条件增长，在估计模型中被视为外生。
- `\Delta e_t` 是名义汇率贬值，并由 CPI / PPP 恒等式决定。
- 这个简化 SOE 模型没有资本存量；因此没有需要记录的生产用资本时序约定。

## 8. Variable & Parameter Reference Table

### 内生变量

| 符号 | 实现名称 | 含义 | 主要方程 |
|---|---|---|---|
| \(y_t\) | `y` | 相对于技术趋势的产出偏离 | (F1) |
| \(R_t\) | `R` | 名义利率偏离 | (F3) |
| \(\pi_t\) | `pi` | CPI 通胀偏离 | (F2), (F5) |
| \(z_t\) | `z` | 技术增长过程 | (F10) |
| \(\Delta q_t\) | `deltaq` | 贸易条件增长 | (F9) |
| \(\Delta y^{\ast}_t\) | `deltay_star` | 世界产出增长 | (F6) |
| \(\bar y_t\) | `y_bar` | 无名义刚性时的潜在产出 | (F4) |
| \(y^{\ast}_t\) | `y_star` | 世界产出 | (F11) |
| \(\Delta e_t\) | `deltae` | 名义汇率贬值 | (F5) |
| \(\pi^{\ast}_t\) | `pi_star` | 世界通胀 / PPP 偏离冲击 | (F12) |
| \(\mathrm{inflationq}_t\) | `inflationq` | 年化 CPI 通胀报告变量 | (F7) |
| \(\mathrm{interest}_t\) | `interest` | 年化名义利率报告变量 | (F8) |

### 外生冲击

| 符号 | 实现名称 | 含义 |
|---|---|---|
| \(\varepsilon^R_t\) | `epsR` | 货币政策冲击 |
| \(\varepsilon_{q,t}\) | `epsq` | 贸易条件增长冲击 |
| \(\varepsilon^{y^{\ast}}_t\) | `epsy_star` | 世界产出冲击 |
| \(\varepsilon^{\pi^{\ast}}_t\) | `epspi_star` | 世界通胀冲击 |
| \(\varepsilon^z_t\) | `epsz` | 技术增长冲击 |

### 参数

| 符号 | 实现名称 | 含义 / MMB 交叉检查使用的加拿大值 |
|---|---|---|
| \(\tau\) | `tau` | 跨期替代弹性；0.31 |
| \(\alpha\) | `alfa` | 进口份额；0.11 |
| \(\rho_z\) | `rhoz` | 技术增长持久性；0.42 |
| \(r\) | `rss` | 年化稳态实际利率；2.52 |
| \(\beta\) | `beta` | 贴现因子，`exp(-rss/400)` |
| \(\kappa\) | `kappa` | Phillips 曲线斜率；0.32 |
| \(\rho_R\) | `rhoR` | 利率平滑；0.69 |
| \(\psi_1\) | `psi1` | 对通胀的政策反应；1.30 |
| \(\psi_2\) | `psi2` | 对产出的政策反应；0.23 |
| \(\psi_3\) | `psi3` | 对名义贬值的政策反应；0.14 |
| \(\rho_q\) | `rhoq` | 贸易条件增长持久性；0.31 |
| \(\rho_{y^{\ast}}\) | `rhoy_star` | 世界产出持久性；0.97 |
| \(\rho_{\pi^{\ast}}\) | `rhopi_star` | 世界通胀持久性；0.46 |
