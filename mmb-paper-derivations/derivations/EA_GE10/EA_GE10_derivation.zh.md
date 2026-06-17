# EA_GE10 -- 推导（最优化问题 + 一阶条件）

> 一阶归档状态：`needs_review`。本条目基于 MinerU Markdown 抽取；Rep-MMB `.mod` 文件只作为 `implementation_cross_check` 使用。

## 1. 模型概述

- **模型 ID**：`EA_GE10`。
- **论文**：Paolo Gelain (2010), "The external finance premium in the euro area: A dynamic stochastic general equilibrium analysis", DOI `10.1016/j.najef.2009.11.004`。
- **来源**：`raw/mmb_mineru/runs/ea_ge10__the_external_finance_premium_in_the_euro_area_a_dynamic_stochastic_gener__718b56bc/full.md`；原始 PDF 仅记录为来源证明，默认未读取正文。
- **用途**：估计欧元区带 BGG 型金融加速器的新凯恩斯 DSGE 模型，用于构造并分析不可观测的外部融资溢价。
- **主体和模块**：带习惯形成的家庭、垄断竞争劳动供给和 Calvo 工资设定；带 Calvo 价格设定的零售/中间品企业；带资本需求、利用率、净值和最优金融合约的企业家；带投资调整成本的资本生产者；货币当局；外生财政当局。
- **模型形式**：论文侧以对数线性形式呈现。带帽变量为相对稳态的百分比或对数偏离。Rep-MMB 实现交叉检查中的 `model;` 方程也是偏离形式的线性化方程。
- **运行验证**：未执行。

## 2. 主体的最优化问题

### 2.1 家庭

家庭 `i` 在跨期预算约束下选择消费、劳动和银行存款。论文报告的是推导后的对数线性欧拉方程，而不是完整的非线性拉格朗日问题。效用含外部习惯参数 `h`、消费曲率 `\sigma_c` 和劳动曲率 `\sigma_l`。

### 2.2 工资设定者

每个家庭供给一种差异化劳动服务。劳动聚合者将差异化服务转换为同质劳动投入。在 Calvo 工资刚性下，每期只有比例 `1-\xi_w` 的家庭可以重新优化；不能重新优化的工资按过去 CPI 通胀、以指数化参数 `\tau_w` 调整。

### 2.3 最终品零售商和中间品生产者

零售商用 Dixit-Stiglitz 聚合器、以替代弹性 `\theta` 聚合差异化中间品。中间品生产者面临 Calvo 价格刚性：每期只有比例 `1-\xi_\pi` 可以重设价格，其他价格按过去通胀、以参数 `\tau_\pi` 指数化。

### 2.4 资本生产者

资本生产者购买最终品，并将其转换为出售给企业家的投资品。投资品生产受投资调整成本 `S(I_t/I_{t-1})` 和投资特定冲击 `x_t` 影响，其中 `S(1)=S'(1)=0` 且 `S''(1)>0`。

### 2.5 企业家和金融合约

企业家生产批发/中间品，雇佣劳动，使用资本，选择资本利用率，并向金融中介借款来弥补资本购买额超过净值的部分。最优合约遵循 BGG 的 costly-state-verification 设定：总量外部融资溢价取决于企业家净值相对于资本价值的高低，并与净值负相关。

## 3. 一阶条件（FOC）

**(F1) 带习惯和偏好冲击的家庭欧拉方程**：

$$
\hat c_t =
\frac{h}{1+h}\hat c_{t-1}
+ \frac{1}{1+h}E_t\hat c_{t+1}
- \frac{1-h}{\sigma_c(1+h)}\hat r_t
+ \frac{1-h}{\sigma_c(1+h)}\hat\varepsilon^\beta_t .
$$

**(F2) 实际利率定义**：

$$
\hat r_t = \hat r^n_t - E_t \pi^c_{t+1}.
$$

**(F3) Calvo 工资方程**：

$$
\begin{aligned}
\hat w_t ={}&
\frac{\beta}{1+\beta}E_t\hat w_{t+1}
+ \frac{1}{1+\beta}\hat w_{t-1}
+ \frac{\beta}{1+\beta}E_t\pi^c_{t+1}
- \frac{1+\beta\tau_w}{1+\beta}\pi^c_t
+ \frac{\tau_w}{1+\beta}\pi^c_{t-1} \\
&- \frac{1}{1+\beta}
\frac{(1-\beta\xi_w)(1-\xi_w)}
{\left[1+((1+\lambda_w)\sigma_l/\lambda_w)\right]\xi_w}
\left[
\hat w_t-\sigma_l\hat l_t-\frac{\sigma_c}{1-h}(\hat c_t-h\hat c_{t-1})+\hat\varepsilon^L_t
\right]
+ u^w_t .
\end{aligned}
$$

**(F4) 来自资本生产者最优性的投资动态**：

$$
\hat I_t =
\frac{1}{1+\beta}\hat I_{t-1}
+ \frac{\beta}{1+\beta}E_t\hat I_{t+1}
+ \frac{1}{\varphi(1+\beta)}\hat q_t
+ \hat x_t .
$$

**(F5) 资本积累**：

$$
\hat k_t = \delta(\hat I_t+\varphi\hat x_t)+(1-\delta)\hat k_{t-1}.
$$

**(F6) 带固定成本和利用率的生产函数**：

$$
\hat y_t =
(1+\phi)\left[
\hat a_t+\alpha\hat k_{t-1}+\alpha\psi\hat r e^k_t+(1-\alpha)\hat l_t
\right].
$$

**(F7) 成本最小化给出的实际边际成本**：

$$
\widehat{mc}_t = \alpha\widehat{r e}^k_t+(1-\alpha)\hat w_t-\hat a_t .
$$

**(F8) 资本边际产出的要素需求条件**：

$$
(1+\psi)\widehat{r e}^k_t = \hat l_t+\hat w_t-\hat k_{t-1}.
$$

**(F9) 资本利用率条件**：

$$
\widehat{r e}^k_t = \psi z_t .
$$

**(F10) 事后总量资本回报**：

$$
\hat r^k_{t+1} =
\frac{R e^k}{R^k}\widehat{r e}^k_{t+1}
+ \frac{1-\delta}{R^k}\hat q_{t+1}
- \hat q_t .
$$

**(F11) 外部融资溢价 / 金融加速器关系**：

$$
\hat s_t =
-\varkappa\left(\widehat{nw}_{t+1}-\hat q_t-\hat k_{t+1}\right),
\qquad
\hat s_t \equiv E_t\hat r^k_{t+1}-\hat r_t .
$$

**(F12) 企业家净值**：

$$
\widehat{nw}_{t+1} =
\vartheta^e\left[
\frac{K}{NW}R^n(S\hat r^k_t-\hat r_t)
+ \frac{K}{NW}R^n(S-1)(\hat q_{t-1}+\hat k_t)
+ R^n(\hat r_t+\widehat{nw}_t)
\right].
$$

**(F13) 带价格指数化的新凯恩斯 Phillips 曲线**：

$$
\pi^c_t =
\frac{\beta}{1+\beta\tau_\pi}E_t\pi^c_{t+1}
+ \frac{\tau_\pi}{1+\beta\tau_\pi}\pi^c_{t-1}
+ \frac{1}{1+\beta\tau_\pi}
\frac{(1-\beta\xi_\pi)(1-\xi_\pi)}{\xi_\pi}\widehat{mc}_t
+ u^{\lambda^\pi}_t .
$$

## 4. 市场出清与总量恒等式

**(F14) 差异化产品的 Dixit-Stiglitz 需求**：

$$
y_t(j)=\left(\frac{P^c_t}{P_t(j)}\right)^{-\theta}Y_t .
$$

**(F15) 总量资源约束**：

$$
\hat y_t =
\frac{C}{Y}\hat c_t
+ \frac{I}{Y}\hat I_t
+ \frac{G}{Y}\hat g_t
+ \frac{K}{Y}\psi R e^k \widehat{r e}^k_t
+ \frac{K}{Y}S\left(1-\frac{NW}{K}\right)(\hat r^k_t+\hat q_{t-1}+\hat k_t).
$$

**(F16) 政府预算/均衡条件**：

$$
G_t=T_t .
$$

**(F17) 货币政策规则**：

$$
\begin{aligned}
\hat r^n_t ={}&
\phi_m\hat r^n_{t-1}
+(1-\phi_m)\left[
r_\pi\pi_{t-1}+r_y(\hat y_{t-1}-\hat y^*_{t-1})
\right] \\
&+ r_{\Delta\pi}(\pi_t-\pi_{t-1})
+ r_{\Delta y}\left[
\hat y_t-\hat y^*_t-(\hat y_{t-1}-\hat y^*_{t-1})
\right]
+ u^{ru}_t .
\end{aligned}
$$

## 5. 外生过程

**(F18) 偏好冲击**：

$$
\hat\varepsilon^\beta_t=\rho_\beta\hat\varepsilon^\beta_{t-1}+u^\beta_t .
$$

**(F19) 劳动供给冲击**：

$$
\hat\varepsilon^L_t=\rho_L\hat\varepsilon^L_{t-1}+u^L_t .
$$

**(F20) 投资特定冲击**：

$$
\hat x_t=\rho_x\hat x_{t-1}+u^x_t .
$$

**(F21) 技术冲击**：

$$
\hat a_t=\rho_a\hat a_{t-1}+u^a_t .
$$

**(F22) 政府支出冲击**：

$$
\hat g_t=\rho_g\hat g_{t-1}+u^g_t .
$$

**(F23) 货币政策冲击**：

$$
u^{ru}_t \sim N(0,\sigma_{ru}^2).
$$

**(F24) 工资加成冲击**：

$$
u^w_t\sim N(0,\sigma_w^2).
$$

**(F25) 价格加成冲击**：

$$
u^{\lambda^\pi}_t\sim N(0,\sigma_{\lambda^\pi}^2).
$$

## 6. 稳态求解

论文在附录 A 给出稳态关系。由于模型以对数线性偏离形式呈现，稳态偏离值均为零。以下水平值定义线性化展开点和校准目标。

1. 金融和资本回报：
   $R^k=SR^n$, $R^k=R e^k+1-\delta$, $R^n=1/\beta$, 因此 $R e^k=S/\beta-1+\delta$。
2. 价格加成和边际成本：
   $MC=(\theta-1)/\theta$。
3. 由边际成本求工资：
   $W=\left[MC(1-\alpha)^{1-\alpha}\alpha^\alpha/(R e^k)^\alpha\right]^{1/(1-\alpha)}$。
4. 要素比率：
   $R e^k=\alpha MC\,Y/K$, $W=(1-\alpha)MC\,Y/L$, 且 $L/K=((1-\alpha)/\alpha)(R e^k/W)$。
5. 固定成本和产出：
   稳态利润为零时，$F=(\lambda_d-1)Y$ 且 $Y=(1/(1+F/Y))(K/L)^\alpha L$。
6. 资本产出比和投资产出比：
   $K/Y=(L/K)^{\alpha-1}(1+F/Y)$ 且 $I/Y=\delta K/Y$。
7. 资源配置：
   $g=1-(C/Y+I/Y)$ 且 $C/K=(1-g)(1/(1+F/Y))(L/K)^{1-\alpha}-\delta$。
8. 资本、消费、投资、产出、劳动和净值：
   $K=W(\theta^w-1)/\theta^w\{[(1-h)C/K]^{-\sigma_c}(L/K)^{-\sigma_L}\}^{1/(\sigma_c+\sigma_L)}$，
   然后 $C=(C/K)K$, $I=\delta K$, $Y=(C+I)/(1-g)$, $L=(L/K)K$, $NW=(NW/K)K$。

`needs_review`：附录 A 中若干符号存在 OCR 损坏（`theta^w`、`sigma_L` 和加成记号）。上述关系从 Markdown 规范化，并用 Rep-MMB 稳态定义交叉检查，但未对 PDF 正文逐项核对。

## 7. 时序与形式约定

- 论文侧模型为对数线性模型。带帽变量表示相对稳态的偏离。
- 进入生产的资本存量是预定变量：生产使用 `k_{t-1}`，资本积累决定 `k_t`。
- 投资调整成本使投资同时具有前瞻项和滞后项。
- 金融合约在个体冲击实现前签订；溢价条件把预期资本回报和当期杠杆/净值联系起来。
- 论文把企业家净值写为 `nw_{t+1}`；Rep-MMB 实现通过滞后项把它移到当期线性方程中，例如 `nw=...rk(-1)...q(-2)+k(-1)...`。
- Rep-MMB 实现包含粘性价格/粘性工资经济以及用于定义潜在产出 `ypot` 的灵活价格对应模型；这只是实现交叉检查，不是额外论文侧证据。
- 未执行运行验证、Dynare 残差检查或 Blanchard-Kahn 检查。

## 8. 变量与参数对照表

| 类别 | 符号 / 实现名称 | 含义 | 主要方程 |
|---|---|---|---|
| 内生变量 | `c`, $\hat c_t$ | 消费 | (F1), (F15) |
| 内生变量 | `r`, $\hat r_t$ | 实际利率 | (F2), (F11) |
| 内生变量 | `rn`, $\hat r^n_t$ | 名义政策利率 | (F2), (F17) |
| 内生变量 | `wp`, $\hat w_t$ | 实际工资 | (F3), (F7), (F8) |
| 内生变量 | `l`, $\hat l_t$ | 劳动 | (F3), (F6), (F8) |
| 内生变量 | `inv`, $\hat I_t$ | 投资 | (F4), (F5), (F15) |
| 内生变量 | `q`, $\hat q_t$ | 资本价格 / Tobin q | (F4), (F10), (F11), (F12) |
| 内生变量 | `k`, $\hat k_t$ | 资本存量 | (F5), (F6), (F11), (F12) |
| 内生变量 | `y`, $\hat y_t$ | 产出 | (F6), (F15), (F17) |
| 内生变量 | `mc`, $\widehat{mc}_t$ | 实际边际成本 | (F7), (F13) |
| 内生变量 | `z`, $\widehat{re}^k_t$ / 利用率代理 | 资本边际产出/租赁服务；实现中用 `z` | (F8), (F9) |
| 内生变量 | `rk`, $\hat r^k_t$ | 资本回报 | (F10), (F11), (F12) |
| 内生变量 | `nw`, $\widehat{nw}_t$ | 企业家净值 | (F11), (F12) |
| 内生变量 | `pi`, $\pi^c_t$ | CPI 通胀 | (F2), (F13), (F17) |
| 内生变量 | `S`, $\hat s_t$ | 对数金融溢价 | (F11) |
| 内生变量 | `g`, $\hat g_t$ | 政府支出 | (F15), (F22) |
| 内生变量 | `ypot` | 灵活价格产出缺口参照 | (F17) |
| 内生变量 | `EMP` | 实现中的就业平滑模块 | implementation_cross_check |
| 外生变量 | `ub`, $u^\beta_t$ | 偏好创新 | (F18) |
| 外生变量 | `ul`, $u^L_t$ | 劳动供给创新 | (F19) |
| 外生变量 | `ux`, $u^x_t$ | 投资特定创新 | (F20) |
| 外生变量 | `ua`, $u^a_t$ | 技术创新 | (F21) |
| 外生变量 | `ug`, $u^g_t$ | 政府支出创新 | (F22) |
| 外生变量 | `ur`, $u^{ru}_t$ | 货币政策创新 | (F23), (F17) |
| 外生变量 | `uw`, $u^w_t$ | 工资加成创新 | (F24), (F3) |
| 外生变量 | `ulambdapi`, $u^{\lambda^\pi}_t$ | 价格加成创新 | (F25), (F13) |
| 参数 | `beta` | 贴现因子 | (F1), 稳态 |
| 参数 | `h` | 习惯参数 | (F1), (F3) |
| 参数 | `sigmac`, `sigmal` | 消费/劳动曲率 | (F1), (F3) |
| 参数 | `delta` | 折旧率 | (F5), 稳态 |
| 参数 | `alpha` | 资本份额 | (F6)-(F8), 稳态 |
| 参数 | `theta`, `thetaest` | 实现中的 Calvo 价格参数 / 商品替代弹性 | (F13), (F14) |
| 参数 | `cw`, `lambdaw`, `gammaw` | 工资 Calvo、工资加成、工资指数化 | (F3) |
| 参数 | `gammapi` | 价格指数化 | (F13) |
| 参数 | `pis`, `varphi` | 投资调整成本倒数 | (F4), (F5) |
| 参数 | `FI`, `psi` | 利用率成本弹性倒数 | (F6), (F9), (F15) |
| 参数 | `vkappa`, `varkappa` | 溢价相对于杠杆的弹性 | (F11) |
| 参数 | `thetae`, $\vartheta^e$ | 企业家存活概率 | (F12) |
| 参数 | `S_ss`, `S` | 稳态金融溢价 | (F11), 稳态 |
| 参数 | `KNW`, `NWK` | 资本-净值比 | (F12), 稳态 |
| 参数 | `phim`, `rpi`, `ry`, `rdeltapi`, `rdeltay` | 政策规则系数 | (F17) |
| 参数 | `rho*` | AR(1) 持续性参数 | (F18)-(F22) |
